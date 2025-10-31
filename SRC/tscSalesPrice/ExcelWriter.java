package tscSalesPrice;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExcelWriter {

    public static SXSSFWorkbook workbook;

    public static Map<String, CellStyle> createStyles(SXSSFWorkbook wb) {
        workbook = wb;
        Map<String, CellStyle> styles = new HashMap<>();
        int fontsize = 8;

        // --- 字體定義 ---
        Font font_bold = workbook.createFont();
        font_bold.setFontName("Arial");
        font_bold.setFontHeightInPoints((short) (fontsize + 1));
        font_bold.setBold(true);
        font_bold.setColor(IndexedColors.BLACK.getIndex());

        Font font_nobold = workbook.createFont();
        font_nobold.setFontName("Arial");
        font_nobold.setFontHeightInPoints((short) fontsize);
        font_nobold.setBold(false);
        font_nobold.setColor(IndexedColors.BLACK.getIndex());

        Font font_bold_red = workbook.createFont();
        font_bold_red.setFontName("Arial");
        font_bold_red.setFontHeightInPoints((short) fontsize);
        font_bold_red.setBold(true);
        font_bold_red.setColor(IndexedColors.RED.getIndex());

        // --- 樣式定義 ---

        // 英文內文水平垂直置中-粗體-格線-底色灰 (centerBLB)
        CellStyle centerBLB = workbook.createCellStyle();
        centerBLB.setFont(font_bold);
        centerBLB.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
        centerBLB.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        centerBLB.setAlignment(HorizontalAlignment.CENTER);
        centerBLB.setVerticalAlignment(VerticalAlignment.CENTER);
        centerBLB.setBorderTop(BorderStyle.THIN);
        centerBLB.setBorderBottom(BorderStyle.THIN);
        centerBLB.setBorderLeft(BorderStyle.THIN);
        centerBLB.setBorderRight(BorderStyle.THIN);
        centerBLB.setWrapText(false);
        styles.put("centerBLB", centerBLB);

        // 英文內文水平垂直置左-粗體-格線-底色黃 (leftBLY)
        CellStyle leftBLY = workbook.createCellStyle();
        leftBLY.setFont(font_bold);
        leftBLY.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
        leftBLY.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        leftBLY.setAlignment(HorizontalAlignment.LEFT);
        leftBLY.setVerticalAlignment(VerticalAlignment.CENTER);
        leftBLY.setBorderTop(BorderStyle.THIN);
        leftBLY.setBorderBottom(BorderStyle.THIN);
        leftBLY.setBorderLeft(BorderStyle.THIN);
        leftBLY.setBorderRight(BorderStyle.THIN);
        leftBLY.setWrapText(false);
        styles.put("leftBLY", leftBLY);

        // 英文內文水平垂直置中-正常-格線 (centerL)
        CellStyle centerL = workbook.createCellStyle();
        centerL.setFont(font_nobold);
        centerL.setAlignment(HorizontalAlignment.CENTER);
        centerL.setVerticalAlignment(VerticalAlignment.CENTER);
        centerL.setBorderTop(BorderStyle.THIN);
        centerL.setBorderBottom(BorderStyle.THIN);
        centerL.setBorderLeft(BorderStyle.THIN);
        centerL.setBorderRight(BorderStyle.THIN);
        centerL.setWrapText(false);
        styles.put("centerL", centerL);

        // 英文內文水平垂直置右-正常-格線 (rightL)
        CellStyle rightL = workbook.createCellStyle();
        rightL.setFont(font_nobold);
        rightL.setAlignment(HorizontalAlignment.RIGHT);
        rightL.setVerticalAlignment(VerticalAlignment.CENTER);
        rightL.setBorderTop(BorderStyle.THIN);
        rightL.setBorderBottom(BorderStyle.THIN);
        rightL.setBorderLeft(BorderStyle.THIN);
        rightL.setBorderRight(BorderStyle.THIN);
        rightL.setWrapText(false);
        styles.put("rightL", rightL);

        // 英文內文水平垂直置左-正常-格線 (leftL)
        CellStyle leftL = workbook.createCellStyle();
        leftL.setFont(font_nobold);
        leftL.setAlignment(HorizontalAlignment.LEFT);
        leftL.setVerticalAlignment(VerticalAlignment.CENTER);
        leftL.setBorderTop(BorderStyle.THIN);
        leftL.setBorderBottom(BorderStyle.THIN);
        leftL.setBorderLeft(BorderStyle.THIN);
        leftL.setBorderRight(BorderStyle.THIN);
        leftL.setWrapText(false);
        styles.put("leftL", leftL);

        // 英文內文水平垂直置左-正常-格線-紅字 (leftLR)
        CellStyle leftLR = workbook.createCellStyle();
        leftLR.setFont(font_bold_red);
        leftLR.setAlignment(HorizontalAlignment.LEFT);
        leftLR.setVerticalAlignment(VerticalAlignment.CENTER);
        leftLR.setBorderTop(BorderStyle.THIN);
        leftLR.setBorderBottom(BorderStyle.THIN);
        leftLR.setBorderLeft(BorderStyle.THIN);
        leftLR.setBorderRight(BorderStyle.THIN);
        leftLR.setWrapText(false);
        styles.put("leftLR", leftLR);

        return styles;
    }

    /**
     * 計算顯示寬度，中文算2個單位，英文及數字算1個單位。
     */
    private static int getDisplayWidth(String text) {
        if (text == null) return 0;
        int width = 0;
        for (char c : text.toCharArray()) {
            width += (c >= 0x2E80 && c <= 0x9FFF) ? 2 : 1;
        }
        return width;
    }

    /**
     * 將資料寫入 Excel (.xlsx) 並輸出到 OutputStream。
     * @param outputStream   輸出流
     * @param dataDateTitle  資料日期標題
     * @param columns        欄位定義列表
     * @param dataList       資料列表
     * @param freezeCol      要凍結的欄位數量 (e.g., 5 表示凍結 A 到 E 欄)
     * @throws Exception     寫入過程可能發生的錯誤
     */
    public static void writeExcel(OutputStream outputStream,
                                  String dataDateTitle,
                                  List<ExcelColumn> columns,
                                  List<Map<String, Object>> dataList,
                                  int freezeCol) throws Exception {

        try {
            Sheet sheet = workbook.createSheet("Sheet1");

            // ===== 樣式定義 =====
            // 在 POI 中，樣式是與 Workbook 綁定的，因此需要傳入 workbook 實例來創建
            Map<String, CellStyle> styles = createStyles(workbook);

            // ===== row 0: Data Date 標題（橫跨 A~C）=====
            Row titleRow = sheet.createRow(0);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue(dataDateTitle);
            titleCell.setCellStyle(styles.get("leftBLY"));
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 2)); // 合併 A1 到 C1

            // ===== 計算最大欄寬 (包含標題) =====
            int[] maxColumnWidths = new int[columns.size()];
            for (int i = 0; i < columns.size(); i++) {
                maxColumnWidths[i] = getDisplayWidth(columns.get(i).getTitle());
            }

            // ===== row 1: 欄位標題列 =====
            Row headerRow = sheet.createRow(1);
            for (int col = 0; col < columns.size(); col++) {
                ExcelColumn colDef = columns.get(col);
                Cell cell = headerRow.createCell(col);
                cell.setCellValue(colDef.getTitle());
                cell.setCellStyle(styles.get("centerBLB"));
            }

            // ===== row 2+: 資料列 =====
            for (int rowIdx = 0; rowIdx < dataList.size(); rowIdx++) {
                Map<String, Object> rowData = dataList.get(rowIdx);
                Row dataRow = sheet.createRow(rowIdx + 2); // 資料從第3行開始 (index 2)

                for (int col = 0; col < columns.size(); col++) {
                    ExcelColumn colDef = columns.get(col);
                    String text = colDef.selectContent(rowData);

                    // 假設 ExcelColumn 中有 decideFormat(rowData, styles) 方法返回 CellStyle
                    CellStyle format = colDef.decideFormat(rowData, styles);

                    Cell cell = dataRow.createCell(col);
                    cell.setCellValue(text);
                    cell.setCellStyle(format);

                    // 動態計算最大欄寬
                    int displayWidth = getDisplayWidth(text);
                    if (displayWidth > maxColumnWidths[col]) {
                        maxColumnWidths[col] = displayWidth;
                    }
                }
            }

            // ===== 設定最終欄寬 =====
            // POI 的欄寬單位為 1/256 個字元寬度，並增加一些間距 (+2)
            for (int col = 0; col < columns.size(); col++) {
                sheet.setColumnWidth(col, (maxColumnWidths[col] + 2) * 256);
            }

            // ===== 凍結窗格 =====
            // 凍結第 2 行以上的所有行，以及 freezeCol 之前的所有欄
            sheet.createFreezePane(freezeCol, 2);

            // ===== 寫入輸出流 =====
            workbook.write(outputStream);
            outputStream.flush();

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // Close the workbook to release resources
            try {
                workbook.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }
}