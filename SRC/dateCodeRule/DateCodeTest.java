package dateCodeRule;

import bean.ConnUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dateCodeRule.dao.impl.TspmdItemDateCodeImpl;
import dateCodeRule.dto.DateCodeDto;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

public class DateCodeTest {

    private static DateCodeDto dateCodeDto;
    public static HashMap<Integer, DateCodeDto> excelMap = new LinkedHashMap<>();

    private static Connection conn;
    private static HashMap map = new HashMap();

    static {
        try {
            conn = ConnUtils.getConnectionCRP1();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static TspmdItemDateCodeImpl tspmdItemDateCodeImpl() {return new TspmdItemDateCodeImpl();}

    static class DataItem {
        int id;
        String device;
        String dateCode;
        String marking;
        String remarks;
        String createdDate;

        public DataItem(int id, String device, String dateCode, String marking, String remarks, String createdDate) {
            this.id = id;
            this.device = device;
            this.dateCode = dateCode;
            this.marking = marking;
            this.remarks = remarks;
            this.createdDate = createdDate;
        }
    }

    // 分頁回傳的 JSON 結構
    static class PaginatedResult {
        int total;
        List<DataItem> rows;

        public PaginatedResult(int total, List<DataItem> rows) {
            this.total = total;
            this.rows = rows;
        }
    }

    public static void main2(String[] args) {
        List<String> headers = Arrays.asList("id", "device", "dateCode", "marking", "remarks", "createdDate");

        List<List<String>> rawData = Arrays.asList(
                Arrays.asList("1", "fgffff", "YML", "Y_M_L_", "PEGGY_CHEN", "2025-03-03 14:05:25.0"),
                Arrays.asList("2", "TQM170NH10LCR RLG", "YWWLF", "YWWLF_", "Mars Wang Create", "2024-11-28 13:39:20.0"),
                Arrays.asList("3", "TQM170NH10CR RLG", "YWWLF", "YWWLF_", "Mars Wang Create", "2024-11-28 13:39:08.0"),
                Arrays.asList("4", "TQM100NH10LCR RLG", "YWWLF", "YWWLF_", "Mars Wang Create", "2024-11-28 13:38:57.0"),
                Arrays.asList("5", "TQM100NH10CR RLG", "YWWLF", "YWWLF_", "Mars Wang Create", "2024-11-28 13:38:45.0")
        );

        // 轉換成 JSON 格式
        JsonArray jsonArray = new JsonArray();
        for (List<String> row : rawData) {
            JsonObject obj = new JsonObject();
            for (int i = 0; i < headers.size(); i++) {
                obj.addProperty(headers.get(i), row.get(i));
            }
            jsonArray.add(obj);
        }

        // 轉換為 JSON 字串
        String jsonData = new Gson().toJson(jsonArray);
        System.out.println(jsonData);
    }
    public static void mainUpload(String[] args) throws SQLException, JsonProcessingException, ParseException {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        System.out.println(sdf.format(sdf.parse("2023-03-01 14:08:14.0")));
        List<DataItem> dataList = new ArrayList<>();

        Map<Integer, DateCodeDto>  map =  tspmdItemDateCodeImpl().getTspmdItemDateCode(conn, null, null, null);
        List list = new ArrayList();
        for (Map.Entry<Integer, DateCodeDto> entry : map.entrySet()) {
            dateCodeDto = entry.getValue();
            dataList.add(new DataItem(entry.getKey(), dateCodeDto.getDevice(), dateCodeDto.getDateCode(), dateCodeDto.getMarking(), dateCodeDto.getRemark(), sdf.format(sdf.parse(dateCodeDto.getCreationDate()))));
            list.add(Arrays.asList(String.valueOf(entry.getKey().intValue()), dateCodeDto.getDevice(), dateCodeDto.getDateCode(), dateCodeDto.getMarking(),dateCodeDto.getMarking(), sdf.format(sdf.parse(dateCodeDto.getCreationDate()))));
        }
        System.out.println(dataList);
//        System.out.println(ConvertToJson(list));
//        System.out.println(writeValueToString(list));
//        Map<Integer, DateCodeDto> map = tspmdItemDateCodeImpl().getTspmdItemDateCode(conn, null, null, null);
//        for (Map.Entry<Integer, DateCodeDto> dateCodeDtoEntry : map.entrySet()) {
//            dateCodeDto = dateCodeDtoEntry.getValue();
//            System.out.println("ddd="+dateCodeDto.getDevice());
//        }
    }

    public static String ConvertToJson(List<List<String>> rawData) {
        List<String> headers = Arrays.asList("id", "device", "dateCode", "marking", "remarks", "createdDate");
        JsonArray jsonArray = new JsonArray();
        for (List<String> row : rawData) {
            JsonObject obj = new JsonObject();
            for (int i = 0; i < headers.size(); i++) {
                obj.addProperty(headers.get(i), row.get(i));
            }
            jsonArray.add(obj);
        }

        // 轉換為 JSON 字串
        String jsonData = new Gson().toJson(jsonArray);
        return jsonData;
    }

    public static String writeValueToString(List list) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
    }

    private static boolean isEmptyRow(Sheet sheet, int rowIndex) {
        int colCount = sheet.getColumns();
        for (int colIndex = 0; colIndex < colCount; colIndex++) {
            String content = sheet.getCell(colIndex, rowIndex).getContents().trim();
            if (!content.isEmpty()) {
                return false; // 只要有一個儲存格有內容，就不是空的row
            }
        }
        return true;
    }

    public static void main(String[] args) throws Exception {
        String uploadFilePath = "C:\\Users\\mars.wang\\Desktop\\DateCode999.xls";
        InputStream is = new FileInputStream(uploadFilePath);
        Workbook wb = Workbook.getWorkbook(is);
        Sheet sheet = wb.getSheet(0);

        for (int rowIndex = 1, rowCount = sheet.getRows(); rowIndex < rowCount; rowIndex++) {
            dateCodeDto = new DateCodeDto();
            if (isEmptyRow(sheet, rowIndex)) {
                continue; // ignore empty row
            }
            for (int colIndex = 0, colCount = sheet.getColumns(); colIndex < colCount; colIndex++) {
                Cell rowCell = sheet.getCell(colIndex, rowIndex);
                String content = rowCell.getContents().trim(); // 取得儲存格內容
                String columnName = sheet.getCell(colIndex, 0).getContents().trim();
                switch (columnName) {
                    case "Device":
                        dateCodeDto.setDevice(content);
                        break;
                    case "Date Code":
                        dateCodeDto.setDateCode(content);
                        break;
                    case "Remark":
                        dateCodeDto.setRemark(content);
                        break;
                    case "Marking":
                        dateCodeDto.setMarking(content);
                        break;
                    default:
                        break;
                }
                excelMap.put(rowIndex, dateCodeDto);
            }
        }
        if (!excelMap.isEmpty()) {
            tspmdItemDateCodeImpl().insertTspmdItemDateCode(conn, excelMap, "mars");
        }
//        readExcel();
        wb.close();
    }
    private static void readExcel() throws Exception {
        for (Map.Entry<Integer, DateCodeDto> dateCodeDtoEntry : excelMap.entrySet()) {
            dateCodeDto = dateCodeDtoEntry.getValue();
            System.out.println("ddd="+dateCodeDto.getDevice());
        }
    }
}
