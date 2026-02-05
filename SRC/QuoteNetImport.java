import org.json.JSONArray;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class QuoteNetImport {

    // 資料庫設定
    // "jdbc:oracle:thin:@10.0.1.34:1521:PROD";
    // "jdbc:oracle:thin:@10.0.1.173:1528:crp1";
    // "jdbc:oracle:thin:@10.0.1.171:1527:crp";
    private static final String DB_URL = "jdbc:oracle:thin:@10.0.1.34:1521:PROD";
    private static final String DB_USER = "apps";
    private static final String DB_PASS = "tscapps12";

    // API 設定
    private static final String API_KEY = "FE853DF906584FA8B70DA3E97A71157474217749FFBA497E81B9A258CA3B00E871513CCE9129A948D69263C4B75A3AB8";
    private static final String API_URL = "http://quotenet/SalesNET.WebAPI/api/v1/Quote/Hq";
    private static final String TABLE_NAME = "TSC_OM_REF_QUOTENET";
    private static final int MAX_RESULTS = 100000;

    public static void main(String[] args) throws ClassNotFoundException {
        System.out.println("Job Started: " + LocalDateTime.now());
        Class.forName("oracle.jdbc.driver.OracleDriver");
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS)) {

            // 1. Truncate Table
            truncateTable(conn);

            // 2. 年份迴圈：改為從「當年往前推 5 年」開始
            int currentYear = LocalDate.now().getYear();
            int startYear = currentYear - 5; // 修改處：設定起始年

            System.out.println("Fetching data from year: " + startYear + " to " + currentYear);

            for (int year = startYear; year <= currentYear; year++) {
                // 迴圈 1 到 12 月
                for (int month = 1; month <= 12; month++) {
                    String startDate = String.format("%d-%02d-01", year, month);
                    // 計算月底日期 (處理閏年與大小月)
                    LocalDate lastDay = LocalDate.of(year, month, 1).plusMonths(1).minusDays(1);
                    String endDate = lastDay.format(DateTimeFormatter.ISO_LOCAL_DATE);

                    String params = "CreateDateStart=" + startDate + "&CreateDateEnd=" + endDate + "&MaxResults=" + MAX_RESULTS;

                    System.out.println("Processing: " + params);
                    getQNet(conn, params);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Critical Error: " + e.getMessage());
        }

        System.out.println("Job Finished: " + LocalDateTime.now());
    }

    private static void truncateTable(Connection conn) throws SQLException {
        String sql = "TRUNCATE TABLE " + TABLE_NAME;
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table Truncated: " + TABLE_NAME);
        }
    }

    private static void getQNet(Connection conn, String params) {
        HttpURLConnection urlConn = null;
        try {
            // 建立 HTTP 連線
            URL url = new URL(API_URL + "?" + params);
            urlConn = (HttpURLConnection) url.openConnection();
            urlConn.setRequestMethod("GET");
            urlConn.setRequestProperty("Authorization", "ApiKey " + API_KEY);
            urlConn.setRequestProperty("Content-Type", "application/json");
            urlConn.setConnectTimeout(0); // 無限等待，對應 PHP set_time_limit(0)
            urlConn.setReadTimeout(0);

            int responseCode = urlConn.getResponseCode();
            if (responseCode != 200) {
                System.err.println("API Error: HTTP " + responseCode);
                return;
            }

            // 讀取回傳資料
            BufferedReader in = new BufferedReader(new InputStreamReader(urlConn.getInputStream(), "UTF-8"));
            StringBuilder response = new StringBuilder();
            String inputLine;
            while ((inputLine = in.readLine()) != null) {
                response.append(inputLine);
            }
            in.close();

            // 解析 JSON
            String jsonStr = response.toString();
            // 檢查是否為空陣列或空字串
            if (jsonStr == null || jsonStr.trim().isEmpty() || jsonStr.equals("[]")) {
                return;
            }

            JSONArray jsonArray = new JSONArray(jsonStr);
            int count = jsonArray.length();
            if (count > 0) {
                System.out.println("Rows fetched: " + count);
                insertData(conn, jsonArray);
            }

        } catch (Exception e) {
            System.err.println("Error in getQNet: " + e.getMessage());
        } finally {
            if (urlConn != null) {
                urlConn.disconnect();
            }
        }
    }

    private static void insertData(Connection conn, JSONArray data) throws SQLException {
        // 為了效能，這裡使用 Statement 批次處理，或是逐筆執行
        try (Statement stmt = conn.createStatement()) {

            for (int i = 0; i < data.length(); i++) {
                JSONObject row = data.getJSONObject(i);

                List<String> columns = new ArrayList<>();
                List<String> values = new ArrayList<>();

                Iterator<String> keys = row.keys();
                while (keys.hasNext()) {
                    String key = keys.next();
                    Object valObj = row.get(key);
                    String val = (valObj == JSONObject.NULL) ? "" : valObj.toString().trim();

                    // 欄位名稱轉小寫
                    String colName = key.toLowerCase();
                    columns.add(colName);

                    // 處理數值與日期格式
                    switch (colName) {
                        case "datecreated":
                        case "datechanged":
                        case "fromdate":
                        case "todate":
                        case "debitdate":
                        case "debitexpiration":
                            if (!val.isEmpty()) {
                                // 1. 將 'T' 替換為空白
                                String cleanDate = val.replace("T", " ");

                                // 2. 【修正點】截斷毫秒
                                // 來源可能是 "2010-05-19 23:34:43.113"，長度超過 19
                                // 我們只需要 "2010-05-19 23:34:43" (前19碼)
                                if (cleanDate.length() > 19) {
                                    cleanDate = cleanDate.substring(0, 19);
                                }

                                values.add("TO_DATE('" + cleanDate + "','YYYY-MM-DD HH24:MI:SS')");
                            } else {
                                // 如果是空日期，視為 NULL 或空字串，這裡維持您的邏輯寫入空字串
                                // 若 DB欄位允許 NULL，建議改為 values.add("NULL");
                                values.add("'" + val.replace("'", "''") + "'");
                            }
                            break;

                        // 數值欄位若有需要也可在此處理，目前看 Log 數值正常
                        default:
                            // 一般字串，跳脫單引號
                            values.add("'" + val.replace("'", "''") + "'");
                            break;
                    }
                }

                if (!columns.isEmpty()) {
                    // 加入 apiUpdateTime
                    columns.add("apiUpdateTime");
                    // 取得當前時間
                    String now = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                    values.add("TO_DATE('" + now + "','YYYY-MM-DD HH24:MI:SS')");

                    // 組裝 SQL
                    String sql = "INSERT INTO " + TABLE_NAME + " (" +
                            String.join(",", columns) +
                            ") VALUES (" + String.join(",", values) + ")";

                    try {
                        stmt.executeUpdate(sql);
                    } catch (SQLException e) {
                        System.err.println("SQL Error: " + e.getMessage());
                        System.err.println("Failed SQL: " + sql);
                    }
                }
            }
        }
    }
}