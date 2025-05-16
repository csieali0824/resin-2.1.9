package tscSalesPrice;

import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Border;
import jxl.format.BorderLineStyle;
import jxl.format.Colour;
import jxl.format.VerticalAlignment;
import jxl.format.*;
import jxl.write.*;

import java.io.OutputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ExcelWriter {
    public static Map<String, WritableCellFormat> createStyles() throws Exception {
        Map<String, WritableCellFormat> styles = new HashMap<>();
        int fontsize = 8;
        WritableFont font_bold = new WritableFont(WritableFont.createFont("Arial"), fontsize + 1, WritableFont.BOLD,
                false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
        WritableFont font_nobold = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.NO_BOLD,
                false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.BLACK);
        WritableFont font_bold_red = new WritableFont(WritableFont.createFont("Arial"), fontsize, WritableFont.BOLD,
                false, UnderlineStyle.NO_UNDERLINE, jxl.format.Colour.RED);


        //�^�夺����������m��-����-��u-�����
        WritableCellFormat centerBLB = new WritableCellFormat(font_bold);
        centerBLB.setBackground(Colour.GRAY_25);
        centerBLB.setAlignment(Alignment.CENTRE);
        centerBLB.setVerticalAlignment(VerticalAlignment.CENTRE);
        centerBLB.setBorder(Border.ALL, BorderLineStyle.THIN);
        centerBLB.setWrap(false);
        styles.put("centerBLB", centerBLB);

        //�^�夺����������m��-��u-�����
        WritableCellFormat leftBLY = new WritableCellFormat(font_bold);
        leftBLY.setBackground(Colour.YELLOW);
        leftBLY.setAlignment(Alignment.LEFT);
        leftBLY.setVerticalAlignment(VerticalAlignment.CENTRE);
        leftBLY.setBorder(Border.ALL, BorderLineStyle.THIN);
        leftBLY.setWrap(false);
        styles.put("leftBLY", leftBLY);

        //�^�夺����������m��-���`-��u
        WritableCellFormat centerL = new WritableCellFormat(font_nobold);
        centerL.setAlignment(Alignment.CENTRE);
        centerL.setVerticalAlignment(VerticalAlignment.CENTRE);
        centerL.setBorder(Border.ALL, BorderLineStyle.THIN);
        centerL.setWrap(false);
        styles.put("centerL", centerL);

        //�^�夺����������m�k-���`-��u
        WritableCellFormat rightL = new WritableCellFormat(font_nobold);
        rightL.setAlignment(Alignment.RIGHT);
        rightL.setVerticalAlignment(VerticalAlignment.CENTRE);
        rightL.setBorder(Border.ALL, BorderLineStyle.THIN);
        rightL.setWrap(false);
        styles.put("rightL", rightL);

        //�^�夺����������m��-���`-��u
        WritableCellFormat leftL = new WritableCellFormat(font_nobold);
        leftL.setAlignment(Alignment.LEFT);
        leftL.setVerticalAlignment(VerticalAlignment.CENTRE);
        leftL.setBorder(Border.ALL, BorderLineStyle.THIN);
        leftL.setWrap(false);
        styles.put("leftL", leftL);

        //�^�夺����������m�k-���`-��u-���r
        WritableCellFormat leftLR = new WritableCellFormat(font_bold_red);
        leftLR.setAlignment(Alignment.LEFT);
        leftLR.setVerticalAlignment(VerticalAlignment.CENTRE);
        leftLR.setBorder(Border.ALL, BorderLineStyle.THIN);
        leftLR.setWrap(false);
        styles.put("leftLR", leftLR);
        return styles;
    }

    private static int getDisplayWidth(String text) {
        if (text == null) return 0;
        int width = 0;
        for (char c : text.toCharArray()) {
            width += (c >= 0x2E80 && c <= 0x9FFF) ? 2 : 1; // �����2�e�A�^���1
        }
        return width;
    }

    public static void writeExcel(OutputStream outputStream,
                                  String dataDateTitle,
                                  List<ExcelColumn> columns,
                                  List<Map<String, Object>> dataList,
                                  Map<String, WritableCellFormat> styles,
                                  int freezeCol) throws Exception {

        WritableWorkbook wwb = Workbook.createWorkbook(outputStream);
        WritableSheet ws = wwb.createSheet("Sheet1", 0);

        // ===== �˦��w�q =====
        WritableCellFormat headerFormat = new WritableCellFormat();
        headerFormat.setBackground(Colour.GRAY_25);
        headerFormat.setAlignment(Alignment.CENTRE);
        headerFormat.setBorder(jxl.format.Border.ALL, jxl.format.BorderLineStyle.THIN);

        // ===== row 0: Data Date ���D�]��� A~C�^=====
        ws.addCell(new Label(0, 0, dataDateTitle, createStyles().get("leftBLY")));
        ws.mergeCells(0, 0, 2, 0);

        // max content width (�t���D)
        int[] maxColumnWidths = new int[columns.size()];
        for (int i = 0; i < columns.size(); i++) {
            maxColumnWidths[i] = getDisplayWidth(columns.get(i).getTitle());
        }
        // ===== row 1: �����D�C =====
        for (int col = 0; col < columns.size(); col++) {
            ExcelColumn colDef = columns.get(col);
            int titleLen = getDisplayWidth(colDef.getTitle());
            maxColumnWidths[col] = Math.max(maxColumnWidths[col], titleLen);
            Label label = new Label(col, 1, colDef.getTitle(), createStyles().get("centerBLB"));
            ws.addCell(label);

            // �]�w��e�]�p�G�n�γ̤j���e�ʺA�վ�]�i�H�X�R�^
//            ws.setColumnView(col, colDef.getWidth());
        }

        // ===== row 2+: ��ƦC =====
        for (int rowIdx = 0; rowIdx < dataList.size(); rowIdx++) {
            Map<String, Object> rowData = dataList.get(rowIdx);
//            System.out.println("rowData=" + rowData);
            for (int col = 0; col < columns.size(); col++) {
                ExcelColumn colDef = columns.get(col);
                String text = colDef.selectContent(rowData);

                WritableCellFormat format = colDef.decideFormat(rowData, styles);
                Label cell = new Label(col, rowIdx + 2, text, format);
                ws.addCell(cell);

                // �p��̤j��e
                int displayWidth = getDisplayWidth(text);
                if (displayWidth > maxColumnWidths[col]) {
                    maxColumnWidths[col] = displayWidth;
                }
            }
        }

        // �]�w��e�]+2�����Z�^
        for (int col = 0; col < columns.size(); col++) {
            ws.setColumnView(col, maxColumnWidths[col] + 2);
        }

        // ===== ??�� E�� + ��2�C =====
        ws.getSettings().setVerticalFreeze(2);     // Freeze Row 0 & 1
        ws.getSettings().setHorizontalFreeze(freezeCol);   // Freeze Col A~E
        wwb.write();
        wwb.close();
        outputStream.flush();
    }
}
