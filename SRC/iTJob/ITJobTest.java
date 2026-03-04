package iTJob;

import bean.ConnUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.mysql.jdbc.StringUtils;
import commonUtil.dateUtil.DateParseResult;
import commonUtil.dateUtil.DateUtil;
import iTJob.dto.ITJobDto;
import iTJob.service.ITJobService;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import java.io.FileInputStream;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.ParseException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.format.ResolverStyle;
import java.util.*;

public class ITJobTest {

    private static ITJobDto iTJobDto;
    private static final Gson gson = new Gson();
    public static HashMap<Integer, ITJobDto> excelMap = new LinkedHashMap<>();
    public static List<String> errList = new ArrayList<>();

    private static Connection conn;
    private static HashMap map = new HashMap();

    static {
        try {
            conn = ConnUtils.getConnectionCRP1();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static ITJobService service() {return new ITJobService();}

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
    public static String ConvertToJson(List<List<String>> rawData) {
        List<String> headers = Arrays.asList("no", "requestDate", "taskDescription", "memo", "status", "owner", "closedDate", "severity", "class");
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

    public static String validateAndFormatDate(String dateStr) {
        // 定義輸入字串日期格式，允許1或2位數的月和日
        DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("yyyy/M/d")
                .withResolverStyle(ResolverStyle.STRICT); // 嚴格解析，檢查日期合法性

        // 定義輸出日期格式字串
        DateTimeFormatter outputFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        try {
            // 解析輸入字串
            LocalDate date = LocalDate.parse(dateStr, inputFormatter);
            // 格式化為目標字串格式並回傳
            return date.format(outputFormatter);

        } catch (DateTimeParseException ex) {
            // 解析失敗（格式不符或日期不合法）
            System.err.println("日期格式錯誤或日期不合法: " + ex.getMessage());
//            errList.add(ex.getMessage());
//            iTJobDto.setErrorList(errList);
            return null;
        }
    }

    public static void main1(String[] args) throws SQLException, JsonProcessingException {
        ITJobService service = new ITJobService();
//        String[] status = new String[]{"","Closed","Done","in progress"};
//        String[] owner = new String[]{"Joe","Mars","Sharon/Marvie","Jb", "ArthurC/Hennry"};
        String[] status = new String[]{""};
        String[] owner = new String[]{""};

//        List<String> statusList = Arrays.asList(status);
//        System.out.println("statusList="+statusList);
//        String statusRs = statusList.stream()
//                .map(s -> "'" + s + "'")   // 每個元素加上單引號
//                .collect(Collectors.joining(",", "(", ")")); // 用逗號分隔，前後加括號
//        System.out.println(statusRs); // 輸出: ('A1','A2','A3')
//
//        List<String> ownerList = Arrays.asList(owner);
//        System.out.println("ownerList="+ownerList);
//        String ownerRs = ownerList.stream()
//                .map(s -> "'" + s + "'")   // 每個元素加上單引號
//                .collect(Collectors.joining(",", "(", ")")); // 用逗號分隔，前後加括號
//        System.out.println(ownerRs); // 輸出: ('A1','A2','A3')

//        iTJobImpl().searchITJob(conn, statusRs, ownerRs);
        List list = new ArrayList<>();
//        Map<Integer, ITJobDto> map = iTJobImpl().searchITJob(status, owner);
        Map<Integer, ITJobDto> map = service.search(conn, null, status, owner);
        for (Map.Entry<Integer, ITJobDto> entry : map.entrySet()) {
            iTJobDto = entry.getValue();
            String requestDate = DateUtil.autoParse(iTJobDto.getRequestDate()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
            String closedDate = StringUtils.isNullOrEmpty(iTJobDto.getClosedDate()) ? "" :
                    DateUtil.autoParse(iTJobDto.getClosedDate()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
            list.add(Arrays.asList(iTJobDto.getNo(),
                    requestDate,
                    iTJobDto.getTaskDescription(),
                    iTJobDto.getMemo(),
                    iTJobDto.getStatus(),
                    iTJobDto.getOwner(),
                    closedDate,
                    iTJobDto.getSeverity(),
                    iTJobDto.getCategory()
            ));
        }

//        String jsonString = "[\"68\", \"99\", \"100\"]";
        String jsonString = "{"
                + "\"39\":{\"requestDate\":\"2025/7/28\",\"taskDescription\":\"YEW 收料Lot control設置導致收料問題\\n- 處理已經出現的幾個批次的收料問題\\n- WMS的接口中增加Item Lot Control的檢驗\",\"memo\":\"- 處理已經出現的幾個批次的收料問題\\n- WMS的接口中增加Item Lot Control的檢驗\",\"status\":\"Open\",\"owner\":\"Evan\\\\Lester\",\"severity\":\"2\",\"class\":\"YEW WMS\"},"
                + "\"117\":{\"requestDate\":\"2025/7/26\",\"taskDescription\":\"YEW:拋轉至總帳傳票調整需求(IVY)\",\"memo\":\"建議其改在AP做Validate後再做拋總帳,但系統允許AP可以針對錯誤那行去discard,再打一筆新的Line,系統即會出現科目互轉的調整分錄,再拋一張傳票至總帳(Rose已同意未來調整)\",\"status\":\"Open\",\"owner\":\"Sharon\",\"closedDate\":\"2025/7/30\",\"severity\":\"2\",\"class\":\"Fin\"},"
                + "\"118\":{\"requestDate\":\"2025/7/28\",\"taskDescription\":\"TSCH:1191/1194 無法自動產生AP\",\"memo\":\"目前皆採人工想辦法寫入介面,故為待調整項目\",\"status\":\"Open\",\"owner\":\"Sharon\",\"severity\":\"2\",\"class\":\"Fin\"}"
                + "}";

//        System.out.println("jsonToMap="+jsonToMap(jsonString));
//        service().updateITJob(conn, jsonToMap(jsonString));

        // 轉成 String[]
//        String[] arr = jsonToArray(jsonString);
//        System.out.println("Array: " + Arrays.toString(arr));
//
//        // 轉成 List<String>
//        List<String> _list = jsonToList(jsonString);
//        System.out.println("List: " + _list);

//        System.out.println("xxx="+convertToJson(list));

        String[] dates =new String[]{"2025/0707", "2025/0907"};
        String[] newStatus =new String[]{"Done", "Closed", "In Progress"};
        service().search(conn, dates, newStatus, new String[]{"Mars"});

    }

    public static String[] jsonToArray(String jsonString) {
        return gson.fromJson(jsonString, String[].class);
    }
    public static List<String> jsonToList(String jsonString) {
        return Arrays.asList(jsonToArray(jsonString));
    }

    public static List<String> headers() {
        return Arrays.asList("no", "requestDate", "taskDescription", "memo", "status", "owner", "closedDate",
                "severity", "class");
    }
    public static String convertToJson(List<List<String>> rawData) {
        JsonArray jsonArray = new JsonArray();
        for (List<String> row : rawData) {
            JsonObject obj = new JsonObject();
            for (int i = 0; i < headers().size(); i++) {
                obj.addProperty(headers().get(i), row.get(i));
            }
            jsonArray.add(obj);
        }

        // 轉換為 JSON 字串
        String jsonData = new Gson().toJson(jsonArray);
        return jsonData;
    }

    public static void mainfff(String[] args) throws SQLException, ParseException, JsonProcessingException {
//        String xxxx="{\"118\":{\"requestDate\":\"2025/7/28\",\"taskDescription\":\"TSCH:1191/1194 無法自動產生AP\",\"memo\":\"1234目前皆採人工想辦法寫入介面,故為待調整項目\",\"status\":\"Open\",\"owner\":\"Sharon\",\"closedDate\":\"\",\"severity\":\"2\",\"class\":\"Fin\"}}";
//        System.out.println("fffff="+jsonToMap(xxxx).keySet());

        DateParseResult result = DateUtil.autoParseWithPattern("2025/7/10");
        System.out.println("formattedDate="+result.getDate());
        System.out.println("getDate="+result.getDate().format(DateTimeFormatter.ofPattern("uuuu/M/d")));
        System.out.println("Ffff="+DateUtil.autoParse("2025/7/10").format(DateTimeFormatter.ofPattern("uuuu/M/d")));
//        date.format(DateTimeFormatter.ofPattern("yyyyMMdd"))
//        SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
//        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("M/d/uuuu");
//        System.out.println("LocalDate="+ LocalDate.parse("7/18/2025", formatter));
        Map<Integer, ITJobDto>  map =  service().search(conn, null, null, null);
        List list = new ArrayList();
        for (Map.Entry<Integer, ITJobDto> entry : map.entrySet()) {
            iTJobDto = entry.getValue();
            String requestDate = DateUtil.autoParse(iTJobDto.getRequestDate()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
            String closedDate = StringUtils.isNullOrEmpty(iTJobDto.getClosedDate()) ? "" : DateUtil.autoParse(iTJobDto.getClosedDate()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
            list.add(Arrays.asList(iTJobDto.getNo(),
                     requestDate,
//                    LocalDate.parse(iTJobDto.getRequestDate(), formatter),
//                    sdf.format(sdf.parse(iTJobDto.getRequestDate())),
//                    validateAndFormatDate("2025/13/1"),
                    iTJobDto.getTaskDescription(),
                    iTJobDto.getMemo(),
                    iTJobDto.getStatus(),
                    iTJobDto.getOwner(),
                    closedDate,
                    iTJobDto.getSeverity(),
                    iTJobDto.getCategory()
            ));
        }
//        System.out.println("xxx="+iTJobDto.getErrorList());
//        System.out.println("list="+list);
        ConvertToJson(list);
    }

    public static void main(String[] args) throws Exception {
        String uploadFilePath = "C:\\Users\\mars.wang\\Desktop\\202510-xxx.xls";
        InputStream is = new FileInputStream(uploadFilePath);
        Workbook wb = Workbook.getWorkbook(is);
        Sheet sheet = wb.getSheet(0);
        excelMap = new HashMap<>();

        for (int rowIndex = 1, rowCount = sheet.getRows(); rowIndex < rowCount; rowIndex++) {
            iTJobDto = new ITJobDto();
            List<String> errorMsgList = new LinkedList<>();
            if (isEmptyRow(sheet, rowIndex)) {
                continue; // ignore empty row
            }
            for (int colIndex = 0, colCount = sheet.getColumns(); colIndex < colCount; colIndex++) {
                Cell rowCell = sheet.getCell(colIndex, rowIndex);
                String content = rowCell.getContents().trim(); // 取得儲存格內容
                String columnName = sheet.getCell(colIndex, 0).getContents().trim();
                switch (columnName) {
                    case "No":
                    case "No.":
                        iTJobDto.setNo(content);
                        break;
                    case "Request Date":
                        try {
                            content = trimAll(content);
                            System.out.println("content="+content);
                            String requestDate = DateUtil.autoParse(content.trim()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
                            System.out.println("requestDate="+requestDate);
                            iTJobDto.setRequestDate(requestDate);
                        } catch (IllegalArgumentException e) {
                            errorMsgList.add("row:"+ rowIndex + ";" + columnName.concat(":" + e.getMessage()));
                        }
                        break;
                    case "Task Description":
                        iTJobDto.setTaskDescription(content);
                        break;
                    case "Memo":
                        iTJobDto.setMemo(content);
                        break;
                    case "Status":
                        iTJobDto.setStatus(content);
                        break;
                    case "Owner":
                        iTJobDto.setOwner(content);
                        break;
                    case "Closed Date":
                        try {
                            content = trimAll(content);
                            System.out.println("Closed Date="+content);
                            String closedDate = StringUtils.isNullOrEmpty(content.trim()) ? "" :
                                    DateUtil.autoParse(content.trim()).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
                            System.out.println("xxxx="+closedDate);
                            iTJobDto.setClosedDate(closedDate);
                        } catch (IllegalArgumentException e) {
                            errorMsgList.add("row:"+ rowIndex + ";" + columnName.concat(":" + e.getMessage()));
                        }
                        break;
                    case "Severity":
                        iTJobDto.setSeverity(content);
                        break;
                    case "Class":
                        iTJobDto.setCategory(content);
                        break;
                    default:
                        break;
                }
                excelMap.put(rowIndex, iTJobDto);
            }
            if (!errorMsgList.isEmpty()) {
                String errorException = String.join(";\t", errorMsgList);
                throw new RuntimeException(errorException);
            }
        }
//        if (iTJobDto.getErrorList().isEmpty()) {
//            try {
//                service().insert(conn, excelMap);
//                System.out.println("err="+iTJobDto.getErrorList());
//            } catch (SQLException e) {
//                System.out.println(e.getMessage());
//                e.printStackTrace();
//            }
//
//        }

//        if (!excelMap.isEmpty()) {
//            iTJobImpl().insertITJobList(conn, excelMap, "mars");
//        }
//        readExcel();
        wb.close();
    }
    private static void readExcel() throws Exception {
        for (Map.Entry<Integer, ITJobDto> iTJobDtoEntry : excelMap.entrySet()) {
            iTJobDto = iTJobDtoEntry.getValue();
            System.out.println("getNo="+iTJobDto.getNo());
            System.out.println("getRequestDate="+iTJobDto.getRequestDate());
            System.out.println("getClosedDate="+iTJobDto.getClosedDate());
        }
    }

    public static Map<String, Map<String, String>> jsonToMap(String json) throws JsonProcessingException {
        // 解析 JSON 並轉換為 Map
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(json, new TypeReference<Map<String, Map<String, String>>>() {});
    }

    /**
     * 去除字串前後的半形與全形空白，並將中間連續空白壓縮為單一空白
     * @param s 原始字串
     * @return 處理後的字串，若 s 為 null 則回傳 null
     */
    public static String trimAll(String s) {
        if (s == null) {
            return null;
        }

        // 1. 全形空白 (U+3000) 轉換成半形空白
        String normalized = s.replace('\u3000', ' ');

        // 2. 去掉前後的半形空白
        normalized = normalized.trim();

        // 3. 連續空白壓縮成單一空白
        normalized = normalized.replaceAll("\\s+", " ");

        return normalized;
    }
}
