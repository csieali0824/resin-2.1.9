import com.jcraft.jsch.ChannelSftp;
import com.jcraft.jsch.JSch;
import com.jcraft.jsch.Session;
import com.jcraft.jsch.SftpATTRS;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.nio.file.attribute.BasicFileAttributes;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.time.Instant;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.stream.Collectors;

public class ModelNQuote {

    // ==========================================
    // 1. 設定區域 (Configuration)
    // ==========================================

    // 資料庫設定 (請確認與您的環境一致)
    // "jdbc:oracle:thin:@10.0.1.34:1521:PROD";
    // "jdbc:oracle:thin:@10.0.1.173:1528:crp1";
    // "jdbc:oracle:thin:@10.0.1.171:1527:crp";
    private static final String DB_URL = "jdbc:oracle:thin:@10.0.1.34:1521:PROD";
    private static final String DB_USER = "apps";
    private static final String DB_PASS = "tscapps12";

    // SFTP 設定
    private static final String SFTP_HOST = "mft.modeln.com";
    private static final int SFTP_PORT = 22;
    private static final String SFTP_USER = "tsc-prod";
    private static final String SFTP_PASS = "tsc-prod";
    private static final String SFTP_KEY_PATH = "D:\\ModenN_sshKey\\test.pem";
    // 設定 OpenSSH 格式的金鑰
    private static final String PASS_PHRASE = "TSCMODELNPR20240926";

    // 本地路徑設定
    private static final String LOCAL_BASE_FOLDER = "D:\\ModelN_Quote\\";
    private static final String LOCAL_BACKUP_FOLDER = LOCAL_BASE_FOLDER + "BK\\";
    // 遠端 SFTP 路徑 (根據您之前的測試，這裡應為 /Outbound/ 或 /download/)
    private static final String REMOTE_FOLDER = "/download/";

    public static void main(String[] args) {
        JSch.setLogger(new com.jcraft.jsch.Logger() {
            public boolean isEnabled(int level) { return false; }
            public void log(int level, String message) {
                System.out.println("[SFTP Log] " + message);
            }
        });
        ModelNQuote job = new ModelNQuote();
        job.execute(args);
    }

    public void execute(String[] args) {
        Connection conn = null;
        Session session = null;
        ChannelSftp sftpChannel = null;

        try {
            // 0. 初始化本地目錄
            initDirectories();

            // ==========================================
            // 1. 設定/計算日期參數
            // ==========================================
            // 預設值：若無參數，預設抓取「昨天」到「今天」
            String tempStartDate = LocalDate.now().minusDays(1).format(DateTimeFormatter.ofPattern("yyyyMMdd"));
            String tempEndDate = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyyMMdd"));

            // 解析 args 參數
            // 支援格式: START:20260107 END:20260206
            if (args.length > 0) {
                System.out.println("偵測到輸入參數，正在解析...");
                for (String arg : args) {
                    // 轉大寫並去除前後空白，避免大小寫或誤打空格問題
                    String cleanArg = arg.trim().toUpperCase();

                    if (cleanArg.startsWith("START:")) {
                        // 取得冒號後的字串
                        tempStartDate = cleanArg.substring("START:".length()).trim();
                    }
                    else if (cleanArg.startsWith("END:")) {
                        // 取得冒號後的字串
                        tempEndDate = cleanArg.substring("END:".length()).trim();
                    }
                }
            }

            // 宣告 final 變數供 Lambda 使用 (解決 effectively final 錯誤)
            final String targetStartDate = tempStartDate;
            final String targetEndDate = tempEndDate;

            System.out.println("日期參數已設定 (範圍執行):");
            System.out.println("  - 起始日 (START) : " + targetStartDate);
            System.out.println("  - 結束日 (END)   : " + targetEndDate);

            // 檢查格式是否正確 (簡易檢查長度)
            if (targetStartDate.length() != 8 || targetEndDate.length() != 8) {
                System.err.println("警告：日期格式可能不正確 (應為 yyyyMMdd)，請檢查輸入參數。");
            }

            // 2. 建立連線
            conn = getOracleConnection();
            System.out.println("DB Connected.");

            JSch jsch = new JSch();
            // 如果有 Key 檔案且存在，則加入
            if (new File(SFTP_KEY_PATH).exists()) {
                jsch.addIdentity(SFTP_KEY_PATH, PASS_PHRASE);
            }

            session = jsch.getSession(SFTP_USER, SFTP_HOST, SFTP_PORT);
            session.setPassword(SFTP_PASS);

            Properties config = new Properties();
            config.put("StrictHostKeyChecking", "no");
            // 增加驗證相容性設定
            config.put("PreferredAuthentications", "publickey,keyboard-interactive,password");
            session.setConfig(config);

            session.connect();
            System.out.println("SFTP Connected.");

            sftpChannel = (ChannelSftp) session.openChannel("sftp");
            sftpChannel.connect();

            // 3. 掃描與下載檔案
            System.out.println("正在掃描遠端目錄: " + REMOTE_FOLDER);

            List<ChannelSftp.LsEntry> fileList = sftpChannel.ls(REMOTE_FOLDER).stream()
                    .filter(e -> !e.getAttrs().isDir())
                    .map(e -> (ChannelSftp.LsEntry) e)
                    .filter(e -> {
                        String fname = e.getFilename();

                        // 1. 基本檔名檢查：必須以 "TSC_QUOTE_EXPORT_" 開頭，且以 ".txt" 結尾
                        if (!fname.startsWith("TSC_QUOTE_EXPORT_") || !fname.endsWith(".txt")) {
                            return false;
                        }

                        // 2. 防呆檢查：確保檔名長度夠長，避免 substring 報錯
                        // "TSC_QUOTE_EXPORT_" (17字) + "yyyyMMdd" (8字) = 25字
                        if (fname.length() < 25) {
                            return false;
                        }

                        // 3. 擷取日期字串 (從第 17 位開始，取 8 碼)
                        String fileDate = fname.substring(17, 25);

                        // 4. 判斷日期範圍 (字串比對)
                        // 邏輯：檔案日期 >= 起始日  AND  檔案日期 <= 結束日
                        boolean isAfterStart = fileDate.compareTo(targetStartDate) >= 0;
                        boolean isBeforeEnd  = fileDate.compareTo(targetEndDate) <= 0;

                        return isAfterStart && isBeforeEnd;
                    })
                    .sorted(Comparator.comparing(ChannelSftp.LsEntry::getFilename))
                    .collect(Collectors.toList());

            List<File> downloadedFiles = new ArrayList<>();

            // 下載經過篩選的檔案
            for (ChannelSftp.LsEntry entry : fileList) {
                String filename = entry.getFilename();
                SftpATTRS attrs = entry.getAttrs();
                long fileSize = attrs.getSize();

                // 再次確認檔案大小 > 0
                if (fileSize > 0) {

                    // 檢查是否已處理過
                    if (isFileLogExists(conn, filename)) {
                        System.out.println("檔案已存在於 Log 表 (曾處理過)，跳過: " + filename);
                        continue; // 跳過本次迴圈，繼續處理下一筆檔案
                    }

                    System.out.println("下載檔案: " + filename + " (" + fileSize + " bytes)");
                    String localFilePath = LOCAL_BASE_FOLDER + filename;

                    try {
                        sftpChannel.get(REMOTE_FOLDER + filename, localFilePath);

                        // 紀錄 Log
                        insertFileLog(conn, filename, fileSize);
                        downloadedFiles.add(new File(localFilePath));
                    } catch (Exception dlEx) {
                        System.err.println("下載失敗: " + filename + " - " + dlEx.getMessage());
                    }
                }
            }

            // 4. 處理檔案 (Import -> Transfer -> Backup)
            for (File file : downloadedFiles) {
                System.out.println("=== 開始處理: " + file.getName() + " ===");

                try {
                    // A. 匯入到 Import 表
                    processFileImport(conn, file);

                    // B. 轉拋到主表
                    transferToMainTable(conn, file.getName());

                    // C. 備份檔案
                    backupFile(file);

                    System.out.println("=== 處理完成: " + file.getName() + " ===");

                } catch (Exception ex) {
                    System.err.println("處理檔案失敗 " + file.getName() + ": " + ex.getMessage());
                    ex.printStackTrace();
                }
            }

            // 5. 清除舊備份
            deleteOldBackupFiles();

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (sftpChannel != null && sftpChannel.isConnected()) sftpChannel.disconnect();
            if (session != null && session.isConnected()) session.disconnect();
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // ==========================================
    // 邏輯方法區
    // ==========================================

    private void initDirectories() {
        new File(LOCAL_BASE_FOLDER).mkdirs();
        new File(LOCAL_BACKUP_FOLDER).mkdirs();
    }

    // 階段 A: 讀取 CSV 並寫入 Import 表
    private void processFileImport(Connection conn, File file) throws SQLException, IOException {
        String tableName = "APPS.TSC_OM_REF_MODELN_QUOTE_IMPORT";

        // 1. 刪除 Import 表中該檔名的舊資料 (防止重複匯入)
        String deleteSql = "DELETE FROM " + tableName + " WHERE IMPORT_FILENAME = ?";
        try (PreparedStatement psDelete = conn.prepareStatement(deleteSql)) {
            psDelete.setString(1, file.getName());
            psDelete.executeUpdate();
        }

        // 2. 讀取 CSV 並 Insert
        try (BufferedReader br = new BufferedReader(new InputStreamReader(new FileInputStream(file), "UTF-8"))) {
            String line;
            String headerLine = br.readLine();
            if (headerLine == null) return;

            String[] headers = headerLine.split("\\|", -1);

            StringBuilder sqlBuilder = new StringBuilder();
            sqlBuilder.append("INSERT INTO ").append(tableName).append(" (");
            for (String header : headers) {
                sqlBuilder.append(header.trim()).append(", ");
            }
            // 在欄位列表中補上 CREATION_DATE
            sqlBuilder.append("IMPORT_FILENAME, CREATION_DATE) VALUES (");
            for (int i = 0; i < headers.length; i++) {
                sqlBuilder.append("?, ");
            }
            // 在 VALUES 結尾補上 SYSDATE (注意：前面的 ? 是給 IMPORT_FILENAME 用)
            sqlBuilder.append("?, SYSDATE)");

            try (PreparedStatement psInsert = conn.prepareStatement(sqlBuilder.toString())) {
                int count = 0;
                while ((line = br.readLine()) != null) {
                    if (line.trim().isEmpty()) continue;
                    String[] data = line.split("\\|", -1);

                    for (int i = 0; i < headers.length; i++) {
                        String val = (i < data.length) ? data[i] : "";
                        psInsert.setString(i + 1, val);
                    }
                    psInsert.setString(headers.length + 1, file.getName());
                    psInsert.addBatch();
                    count++;

                    if (count % 100 == 0) psInsert.executeBatch();
                }
                psInsert.executeBatch();
                System.out.println("匯入 IMPORT 表筆數: " + count);
            }
        }
    }

    // 階段 B: [核心整合] 將資料從 Import 表轉拋至主表 (邏輯來自 main.cs)
    private void transferToMainTable(Connection conn, String filename) throws SQLException {
        // 1. [修正] 依照 main.cs 的邏輯：只刪除 Import 表中存在的 Quote/Line (防止重複)
        // C# 原文: DELETE FROM TSC_OM_REF_MODELN QQ WHERE EXISTS ... AND MM.QUOTENUMBER = QQ.QUOTEID ...
        // Java 修正: 補上 Schema (TSC/APPS) 並修正欄位名稱 (QUOTEID -> QUOTE_NUMBER, POSITION -> LINE_NUMBER)
        StringBuilder deleteSb = new StringBuilder();
        deleteSb.append("DELETE FROM APPS.TSC_OM_REF_MODELN QQ ");
        deleteSb.append("WHERE EXISTS ( ");
        deleteSb.append("    SELECT 1 ");
        deleteSb.append("    FROM APPS.TSC_OM_REF_MODELN_QUOTE_IMPORT MM ");
        deleteSb.append("    WHERE 1=1 ");
        deleteSb.append("      AND MM.QUOTENUMBER = QQ.QUOTEID "); // 對應 C# 的 QQ.QUOTEID
        deleteSb.append("      AND MM.ITEMNUM = QQ.POSITION ");   // 對應 C# 的 QQ.POSITION (或 ITEMNUM)
        deleteSb.append("      AND UPPER(MM.IMPORT_FILENAME) = UPPER(?) ");
        deleteSb.append(") ");

        try (PreparedStatement psDel = conn.prepareStatement(deleteSb.toString())) {
            psDel.setString(1, filename);
            int rows = psDel.executeUpdate();
            // 如果有刪除資料才印出，避免 Log 太多
            if (rows > 0) {
                System.out.println("清除主表重疊資料 (Upsert前置): " + rows + " 筆");
            }
        }

        // 2. 執行 INSERT INTO ... SELECT ...
        // 這是 main.cs 中最長的那段 SQL，負責欄位對應與計算
        StringBuilder sb = new StringBuilder();
        sb.append("INSERT INTO TSC_OM_REF_MODELN(QUOTEID,POSITION,CUSTOMER,ENDCUSTOMER,CURRENCY,PARTNUMBER,FROMDATE,TODATE,PRICEK ,PRICEKUSD ,DATECREATED,DATECHANGED,CREATEDBY,REGION)");
        sb.append(" SELECT ");
        sb.append("   MM.QUOTENUMBER");
        sb.append(" , MM.ITEMNUM");
        sb.append(" , MM.SALESCHANNEL");
        sb.append(" , MM.CUSTOMER");
        sb.append(" , MM.CURRENCYCODE");
        sb.append(" , MM.MPN");
        sb.append(" , TO_DATE(MM.STARTDATE, 'MM/DD/YYYY')");
        sb.append(" , TO_DATE(MM.QUOTEITEMEXPIREDATE, 'MM/DD/YYYY')");
        sb.append(" , CASE");
        sb.append("      WHEN RR.REGION = 'TSCE' THEN MM.ADJDISTICOSTDENOMINATED");
        sb.append("      WHEN INSTR(UPPER(MM.SALESCHANNEL), 'AMERICA') > 0 THEN MM.QUOTEDDBC");
        sb.append("      ELSE MM.ADJDISTICOST");
        sb.append("   END * 1000 AS PRICEK");
        sb.append(" , ROUND(");
        sb.append("     CASE ");
        sb.append("       WHEN RR.REGION = 'TSCE'  THEN MM.ADJDISTICOSTDENOMINATED");
        sb.append("       WHEN INSTR(UPPER(MM.SALESCHANNEL), 'AMERICA') > 0 THEN MM.QUOTEDDBC");
        sb.append("       ELSE MM.ADJDISTICOST");
        sb.append("     END * 1000 / MM.HDREXCHANGERATE,4");
        sb.append("   ) PRICEKUSD");
        sb.append(" , MM.CREATION_DATE");
        sb.append(" , MM.CREATION_DATE");
        sb.append(" , 'MODELN'");
        sb.append(" , RR.REGION");
        sb.append(" FROM APPS.TSC_OM_REF_MODELN_QUOTE_IMPORT MM ");
        sb.append(" LEFT JOIN TSC.TSC_OM_REF_MODELN_QUOTE_REGION RR ");
        // C# 邏輯: 處理空白字元與 nbsp (\u00a0)
        sb.append("  ON REPLACE(REPLACE(MM.SALESCHANNEL, '\u00a0', ''), ' ', '') = REPLACE(REPLACE(RR.SALESCHANNEL, '\u00a0', ''), ' ', '') ");
        sb.append(" WHERE 1=1 ");
        sb.append("  AND UPPER(MM.IMPORT_FILENAME) = UPPER(?) ");
        sb.append("  AND MM.LINEWORKFLOWSTATUS NOT IN ('Cancelled', 'Rejected')");

        try (PreparedStatement psInsert = conn.prepareStatement(sb.toString())) {
            psInsert.setString(1, filename);
            int rows = psInsert.executeUpdate();
            System.out.println("轉拋主表 (TSC_OM_REF_MODELN) 完成: " + rows + " 筆");
        }
    }

    // 階段 C: 備份檔案 (邏輯來自 main.cs)
    private void backupFile(File sourceFile) {
        try {
            Path source = sourceFile.toPath();
            Path target = Paths.get(LOCAL_BACKUP_FOLDER + sourceFile.getName());

            // 移動檔案 (REPLACE_EXISTING 覆蓋舊檔)
            Files.move(source, target, StandardCopyOption.REPLACE_EXISTING);
            System.out.println("檔案已備份至: " + target.toString());
        } catch (IOException e) {
            System.err.println("檔案備份失敗: " + e.getMessage());
        }
    }

    // 階段 D: 清除過期備份 (邏輯來自 main.cs - 刪除 > 30天的檔案)
    private void deleteOldBackupFiles() {
        System.out.println("正在檢查過期備份 (BK 資料夾)...");
        File backupDir = new File(LOCAL_BACKUP_FOLDER);
        if (!backupDir.exists()) return;

        File[] files = backupDir.listFiles();
        if (files == null) return;

        long retentionPeriod = 30; // 保留 30 天
        Instant threshold = Instant.now().minus(retentionPeriod, ChronoUnit.DAYS);

        int deleteCount = 0;
        for (File f : files) {
            try {
                BasicFileAttributes attrs = Files.readAttributes(f.toPath(), BasicFileAttributes.class);
                Instant fileTime = attrs.lastModifiedTime().toInstant();

                if (fileTime.isBefore(threshold)) {
                    if (f.delete()) {
                        System.out.println("刪除過期檔案: " + f.getName());
                        deleteCount++;
                    }
                }
            } catch (IOException e) {
                System.err.println("無法檢查檔案時間: " + f.getName());
            }
        }
        if (deleteCount > 0) {
            System.out.println("共刪除 " + deleteCount + " 個過期檔案。");
        }
    }

    private void insertFileLog(Connection conn, String filename, long size) throws SQLException {
        String sql = "INSERT INTO APPS.TSC_MODELN_QUOTE_FILE_LOG (FILE_NAME, FILE_SIZE, DOWNLOAD_TIME) VALUES (?, ?, SYSDATE)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filename);
            ps.setLong(2, size);
            ps.executeUpdate();
        }
    }

    // 檢查檔案 Log 是否已存在 DB
    private boolean isFileLogExists(Connection conn, String filename) {
        String sql = "SELECT 1 FROM APPS.TSC_MODELN_QUOTE_FILE_LOG WHERE FILE_NAME = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, filename);
            try (java.sql.ResultSet rs = ps.executeQuery()) {
                return rs.next(); // 如果有查到資料，回傳 true
            }
        } catch (SQLException e) {
            System.err.println("檢查檔案 Log 失敗: " + e.getMessage());
            return false; // 發生錯誤時預設為不存在，嘗試繼續執行
        }
    }

    private Connection getOracleConnection() throws SQLException, ClassNotFoundException {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }
}