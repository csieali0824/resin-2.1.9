package iTJob;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.jspsmart.upload.SmartUpload;
import com.mysql.jdbc.StringUtils;
import commonUtil.ConnUtil;
import commonUtil.JsonUtil;
import commonUtil.dateUtil.DateUtil;
import iTJob.dto.ITJobDto;
import iTJob.service.ITJobService;
import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.stream.IntStream;

public class ITJob extends HttpServlet {
    private String uploadFilePath;
    public String userName;
    private Workbook wb;
    public HashMap<Integer, ITJobDto> excelMap = new LinkedHashMap<>();
    public List<String> statusList = new ArrayList<>();
    public List<String> ownerList = new ArrayList<>();
    public Connection conn;
    public String filePath;
    public static ITJobDto iTJobDto;
    public SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public ITJobService service() {
        return new ITJobService();
    }

    // 檢查是否為空的row
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

    /**
     * 去除字串前後的半形與全形空白，並將中間連續空白壓縮為單一空白
     * @param s 原始字串
     * @return 處理後的字串，若 s 為 null 則回傳 null
     */
    public String trimAll(String s) {
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

    public void writeExcel(String path, HttpServletResponse response, String fileName) throws Exception {
        InputStream is = Files.newInputStream(Paths.get(path));
        this.wb = Workbook.getWorkbook(is);
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
                            String requestDate = DateUtil.autoParse(content).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
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
                        if (!statusList.contains(content)){
                            statusList.add(content);
                        }
                        break;
                    case "Owner":
                        iTJobDto.setOwner(content);
                        if (!ownerList.contains(content)){
                            ownerList.add(content);
                        }
                        break;
                    case "Closed Date":
                        try {
                            content = trimAll(content);
                            String closedDate = StringUtils.isNullOrEmpty(content) ? "" :
                                    DateUtil.autoParse(content).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
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
                errList2String(errorMsgList);
                throw new RuntimeException(errorException);
            }
        }
        wb.close();

//        if (success) {
//            response.getWriter().write("{\"status\":\"success\",\"message\":\"File uploaded: " + fileName + "\"}");
//        } else {
//            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errList2String(iTJobDto.getErrorList()) + "\"}");
//        }

         service().insertFromExcel(conn, excelMap);
         if (iTJobDto.getErrorList().isEmpty()) {
             response.getWriter().write("{\"status\":\"success\",\"message\":\"File uploaded: " + fileName + "\"}");
         } else {
             response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errList2String(iTJobDto.getErrorList()) + "\"}");
         }
//        wb.close();
    }


    private void createOrDeleteDir(File dir) {
        if (dir.isDirectory()) {
            // 刪除子檔案或子目錄
            File[] files = dir.listFiles();
            if (files != null) {
                for (File file : files) {
                    if (file.exists()) {
                        file.delete();
                    }
                }
            }
        } else {
            // 建立子檔案或子目錄
            dir.mkdirs();
        }
    }

    public String convertToString(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader reader = request.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        return sb.toString();
    }

    public List<String> headers() {
        return Arrays.asList("no", "requestDate", "taskDescription", "memo", "status", "owner", "closedDate",
                "severity", "class");
    }

    public Map<String, Map<String, String>> jsonToMap(String json) throws JsonProcessingException {
        // 解析 JSON 並轉換為 Map
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.readValue(json, new TypeReference<Map<String, Map<String, String>>>() {
        });
    }

    public String convertToJson(List<List<String>> rawData) {
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

    public String errList2String(List errList) {
        StringBuilder result = new StringBuilder();
        IntStream.range(0, errList.size()).forEach(i -> {
            if (i < errList.size() - 1) {
                result.append(errList.get(i)).append("<br>");
            } else {
                result.append(errList.get(i));
            }
        });
        return result.toString();
    }

    public String writeValueToString(List list) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // 確保 request 以 UTF-8 解析
        request.setCharacterEncoding("UTF-8");
        // 回傳也用 UTF-8
        response.setContentType("text/html; charset=UTF-8");
        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing action parameter");
            return;
        }

        try {
            this.conn = ConnUtil.getConnection();
            switch (action) {
                case "upload":
                    handleUpload(request, response);
                    break;
                case "insert":
                    handleInsert(request, response);
                    break;
                case "search":
                    handleSearch(request, response);
                    break;
                case "update":
                    handleUpdate(request, response);
                    break;
                case "delete":
                    handleDelete(request, response);
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_BAD_REQUEST, "未知的動作");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"msg\":\"" + e.getMessage() + "\"}");
        }

    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");

        String action = request.getParameter("action");
        List<String> resultList = new ArrayList<>();
        String sql = "";
        if ("status".equalsIgnoreCase(action)) {
            sql = "SELECT DISTINCT status FROM TSC.IT_JOB_LIST WHERE status IS NOT NULL ORDER BY status";
        } else if ("owner".equalsIgnoreCase(action)) {
            sql = "SELECT DISTINCT owner FROM TSC.IT_JOB_LIST WHERE owner IS NOT NULL ORDER BY owner";
        }
        try (PreparedStatement ps = ConnUtil.getConnection().prepareStatement(sql)) {
            if (!sql.isEmpty()) {
                 ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    resultList.add(rs.getString(1));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"status\":\"error\",\"msg\":\"" + e.getMessage() + "\"}");
        }

        String json = new Gson().toJson(resultList);
        response.getWriter().write(json);
    }

    private void handleUpload(HttpServletRequest request, HttpServletResponse response) throws Exception {
        SmartUpload smartUpload = new SmartUpload();
        smartUpload.initialize(getServletConfig(), request, response);
        // 限制只能上傳 xls
        smartUpload.setAllowedFilesList("xls");
        smartUpload.upload();

        com.jspsmart.upload.File file = smartUpload.getFiles().getFile(0);
        String fileName = file.getFileName();
        if (fileName == null || fileName.trim().isEmpty()) {
            // 沒選檔案，回到 jobList.jsp
            response.getWriter().write("{\"status\":\"error\",\"msg\":\"No file\"}");
            return;
        }

        // 存檔路徑 (依實際情況調整)
        String savePath = getServletContext().getRealPath("/jsp/upload_exl/jobList");
        File dir = new File(savePath);
        createOrDeleteDir(dir);

        String filePath = savePath + File.separator + fileName;
        this.filePath = filePath;
        file.saveAs(filePath, SmartUpload.SAVE_PHYSICAL);
        // 存檔 / DB insert...
        writeExcel(filePath, response, fileName);
//        response.getWriter().write("{\"status\":\"success\",\"msg\":\"File uploaded: " + fileName + "\"}");
    }

    private void handleInsert(HttpServletRequest request, HttpServletResponse response) throws Exception {
        request.setCharacterEncoding("UTF-8");
//        response.setContentType("application/json;charset=UTF-8");

        String requestDate = trimAll(request.getParameter("requestDate"));
        requestDate = DateUtil.autoParse(requestDate).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
        iTJobDto.setRequestDate(requestDate);
        String taskDescription = request.getParameter("taskDescription");
        String memo = request.getParameter("memo");
        String status = request.getParameter("status");
        String owner = request.getParameter("owner");
        String closedDate = trimAll(request.getParameter("closedDate"));
        closedDate = DateUtil.autoParse(closedDate).format(DateTimeFormatter.ofPattern("uuuu/M/d"));
        String severity = request.getParameter("severity");
        severity = StringUtils.isNullOrEmpty(severity) ? "" : severity;
        String category = request.getParameter("category");
        iTJobDto.setRequestDate(requestDate);
        iTJobDto.setTaskDescription(taskDescription);
        iTJobDto.setMemo(memo);
        iTJobDto.setStatus(status);
        iTJobDto.setOwner(owner);
        iTJobDto.setClosedDate(closedDate);
        iTJobDto.setSeverity(severity);
        iTJobDto.setCategory(category);
        service().insert(conn, iTJobDto);
        // 回傳結果給前端
        response.setContentType("text/plain; charset=UTF-8");
        response.getWriter().write("{\"status\":\"success\",\"message\":\"Insert Success\"}");
    }
    private void handleSearch(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String[] status = request.getParameterValues("status");
        String[] owner = request.getParameterValues("owner");
        String[] dates = StringUtils.isNullOrEmpty(request.getParameter("dates")) ?
                new String[]{""} : request.getParameter("dates").split("-");
//        System.out.println("dates="+ Arrays.toString(dates));
//        System.out.println("status="+ Arrays.toString(status));
//        System.out.println("owner="+ Arrays.toString(owner));
        List list = new ArrayList<>();
        Map<Integer, ITJobDto> map = service().search(conn, dates, status, owner);
        for (Map.Entry<Integer, ITJobDto> entry : map.entrySet()) {
            iTJobDto = entry.getValue();
            list.add(Arrays.asList(iTJobDto.getNo(),
                    iTJobDto.getRequestDate(),
                    iTJobDto.getTaskDescription(),
                    iTJobDto.getMemo(),
                    iTJobDto.getStatus(),
                    iTJobDto.getOwner(),
                    iTJobDto.getClosedDate(),
                    iTJobDto.getSeverity(),
                    iTJobDto.getCategory()
            ));
        }

        response.setContentType("application/json;charset=UTF-8");
        ObjectMapper mapper = new ObjectMapper();
        mapper.writeValue(response.getWriter(), convertToJson(list));
    }
    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String jsonString = convertToString(request);
        boolean success = service().updateITJob(conn, jsonToMap(jsonString));
        if (success) {
            handleSearch(request, response);
        } else {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errList2String(iTJobDto.getErrorList()) + "\"}");
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String jsonString = convertToString(request);
        List<String> list = JsonUtil.jsonToList(jsonString);
        // DB delete...
        boolean success = service().deleteITJob(conn, list);
        if (success) {
            handleSearch(request, response);
        } else {
            response.getWriter().write("{\"status\":\"error\",\"message\":\"" + errList2String(iTJobDto.getErrorList()) + "\"}");
        }
    }
}
