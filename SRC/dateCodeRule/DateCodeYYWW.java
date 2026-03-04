package dateCodeRule;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import dateCodeRule.dao.impl.TspmdItemDateCodeImpl;
import dateCodeRule.dto.DateCodeDto;
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
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.IntStream;

public class DateCodeYYWW extends HttpServlet {
    private String uploadFilePath;
    public String userName;
    private Workbook wb;
    public HashMap<Integer, DateCodeDto> excelMap = new LinkedHashMap<>();
    public Connection conn;
    public DateCodeDto dateCodeDto;
    public SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    public TspmdItemDateCodeImpl tspmdItemDateCode() {
        return new TspmdItemDateCodeImpl();
    }

    public String getUploadFilePath(Connection conn, String startDateTime, String fileName, String userName) throws SQLException {
        this.conn = conn;
        this.userName = userName;
        String path = "/resin-2.1.9/webapps/oradds/jsp/upload_exl/dateCodeYYWW";
        String startDateTimeFileName = startDateTime + "-" + fileName;
        this.uploadFilePath = path + "/" +startDateTimeFileName;
        createOrDeleteDir(new File(path));
        return this.uploadFilePath;
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
    public void writeExcel(HttpServletRequest request, HttpServletResponse response) throws Exception {
        InputStream is = Files.newInputStream(Paths.get(uploadFilePath));
        this.wb = Workbook.getWorkbook(is);
        Sheet sheet = wb.getSheet(0);
        excelMap = new HashMap<>();

        for (int rowIndex = 1, rowCount = sheet.getRows(); rowIndex < rowCount; rowIndex++) {
            this.dateCodeDto = new DateCodeDto();
            if (isEmptyRow(sheet, rowIndex)) {
                continue; // ignore empty row
            }
            for (int colIndex = 0, colCount = sheet.getColumns(); colIndex < colCount; colIndex++) {
                Cell rowCell = sheet.getCell(colIndex, rowIndex);
                String content = rowCell.getContents().trim(); // 取得儲存格內容
                String columnName = sheet.getCell(colIndex, 0).getContents().trim();
                switch (columnName) {
                    case "D/C":
                        dateCodeDto.setDateCodeRange(content);
                        break;
                    case "Date Code":
                        dateCodeDto.setDateCode(content);
                        break;
                    case "Prod Group":
                        dateCodeDto.setProdGroup(content);
                        break;
                    case "YYWW":
                        dateCodeDto.setYyww(content);
                        break;
                    case "Year":
                        dateCodeDto.setYear(content);
                        break;
                    default:
                        break;
                }
                excelMap.put(rowIndex, dateCodeDto);
            }
        }
        if (!excelMap.isEmpty()) {
            insertDateCodeYYWW();
            redirect(request, response);
        }
        wb.close();
    }

    private void redirect(HttpServletRequest request, HttpServletResponse response) throws IOException {
        if (dateCodeDto.getErrorList().isEmpty()) {
            response.sendRedirect(request.getRequestURL().toString());
        }
    }

    private void createOrDeleteDir(File dir) {
        if (dir.isDirectory()) {
            // 刪除子檔案或子目錄
            File[] files = dir.listFiles();
            if (files != null) {
                for (File file : files) {
                    if(file.exists()) {
                        file.delete();
                    }
                }
            }
        } else {
            // 建立子檔案或子目錄
            dir.mkdirs();
        }
    }

    public void insertDateCodeYYWW() throws SQLException {
        tspmdItemDateCode().insertDateCodeYYWW(conn, excelMap, userName);
    }

    public void updateTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException {
        tspmdItemDateCode().updateTspmdItemDateCode(conn, itemDesc, dateCodeRule, dateCodeExample);
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

    public void updateMultiTspmdItemDateCode(Connection conn, HttpServletRequest request, HttpServletResponse response, String modifyBy) throws SQLException, IOException {
        String jsonString = convertToString(request);
        tspmdItemDateCode().updateMultiTspmdItemDateCode(conn, jsonToMap(jsonString), modifyBy);
        redirect(request, response);
    }

    public void deleteItemDateCode(Connection conn, HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String jsonString = convertToString(request);
        tspmdItemDateCode().deleteItemDateCode(conn,  Arrays.asList(jsonString.split(",")));
        redirect(request, response);
    }

    private List<String> headers() {
        return Arrays.asList("dc", "dateCode", "prodGroup", "yyww", "year", "creationDate", "uploadBy");
    }

    public Map<String, DateCodeDto> jsonToMap(String jsonString) throws JsonProcessingException {
        // 解析 JSON 並轉換為 Map
        ObjectMapper mapper = new ObjectMapper();
        return mapper.readValue(jsonString, new TypeReference<Map<String, DateCodeDto>>(){});
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
    public List getDateCodeYYWW(Connection conn, String dc, String dateCode, String prodGroup, String year) throws SQLException, ParseException {
        List list = new ArrayList<>();
        Map<Integer, DateCodeDto>  map = tspmdItemDateCode().getDateCodeYYWW(conn, dc, dateCode, prodGroup, year);
        for (Map.Entry<Integer, DateCodeDto> entry : map.entrySet()) {
            dateCodeDto = entry.getValue();
            list.add(Arrays.asList(

//                    String.valueOf(entry.getKey().intValue()),
//                    dateCodeDto.getDevice(),
                    dateCodeDto.getDateCodeRange(),
                    dateCodeDto.getDateCode(),
                    dateCodeDto.getProdGroup(),
                    dateCodeDto.getYyww(),
                    dateCodeDto.getYear(),
//                    dateCodeDto.getMarking(),
//                    dateCodeDto.getRemark(),
                    sdf.format(sdf.parse(dateCodeDto.getCreationDate())),
                    dateCodeDto.getUploadBy()
//                    dateCodeDto.getModifyBy(),
//                    sdf.format(sdf.parse(dateCodeDto.getUpdateDate()))
//                    StringUtils.isNullOrEmpty(dateCodeDto.getUpdateDate()) ? "" : sdf.format(sdf.parse(dateCodeDto.getUpdateDate()))
            ));
        }
        return list;
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
}
