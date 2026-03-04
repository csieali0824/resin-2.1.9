package iTJob.dao;

import iTJob.dto.ITJobDto;

import java.sql.*;
import java.util.*;

public class ITJobDao implements ITJob {

    private Connection conn;
    public ITJobDao(Connection conn) {
        this.conn = conn;
    }

    public List<String> errList = new ArrayList<>();

    @Override
    public void insertITJobFromExcel(HashMap<Integer, ITJobDto> map) throws SQLException {
        PreparedStatement pstmt = conn.prepareStatement("delete TSC.IT_JOB_LIST");
        pstmt.executeUpdate();
        pstmt.close();
        conn.commit();
        for (Map.Entry<Integer, ITJobDto> iTJobDtoEntry : map.entrySet()) {
            ITJobDto iTJobDto = iTJobDtoEntry.getValue();
            try {
                String sql = "insert into TSC.IT_JOB_LIST \n " +
                        "(NO, REQUEST_DATE, TASK_DESCRIPTION, MEMO, STATUS, OWNER, CLOSED_DATE, SEVERITY, CLASS) \n " +
                        "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
                pstmt = conn.prepareStatement(sql);

                pstmt.setString(1, iTJobDto.getNo());
                pstmt.setString(2, iTJobDto.getRequestDate());
                pstmt.setString(3, iTJobDto.getTaskDescription());
                pstmt.setString(4, iTJobDto.getMemo());
                pstmt.setString(5, iTJobDto.getStatus());
                pstmt.setString(6, iTJobDto.getOwner());
                pstmt.setString(7, iTJobDto.getClosedDate());
                pstmt.setString(8, iTJobDto.getSeverity());
                pstmt.setString(9, iTJobDto.getCategory());
                pstmt.executeUpdate();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                String msg = e.getMessage().replace("\\", "\\\\")   // 反斜線
                        .replace("\"", "")   // 雙引號
                        .replace("\r", "\\r")    // CR
                        .replace("\n", "\\n")    // LF
                        .replace("\t", "\\t");   // Tab
                errList.add("Excel No(" + iTJobDto.getNo() + ")新增失敗=>"+ msg);
                iTJob.ITJob.iTJobDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
    }
    @Override
    public void insertITJob(ITJobDto iTJobDto) throws SQLException {
        //todo 先暫時用最大的No+1 測試，到時再改用Seq
        Statement stamt = conn.createStatement();
        ResultSet rs = stamt.executeQuery("select max(no) from TSC.IT_JOB_LIST");
        while (rs.next()) {
            String sql = "insert into TSC.IT_JOB_LIST \n " +
                    "(NO, REQUEST_DATE, TASK_DESCRIPTION, MEMO, STATUS, OWNER, CLOSED_DATE, SEVERITY, CLASS) \n " +
                    "values(?, ?, ?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {

//                PreparedStatement pstmt = conn.prepareStatement(sql);
                System.out.println("currNo="+ rs.getString(1));
                pstmt.setInt(1, Integer.parseInt(rs.getString(1))+ 1);
                pstmt.setString(2, iTJobDto.getRequestDate());
                pstmt.setString(3, iTJobDto.getTaskDescription());
                pstmt.setString(4, iTJobDto.getMemo());
                pstmt.setString(5, iTJobDto.getStatus());
                pstmt.setString(6, iTJobDto.getOwner());
                pstmt.setString(7, iTJobDto.getClosedDate());
                pstmt.setString(8, iTJobDto.getSeverity());
                pstmt.setString(9, iTJobDto.getCategory());
                pstmt.executeUpdate();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                String msg = e.getMessage().replace("\\", "\\\\")   // 反斜線
                        .replace("\"", "")   // 雙引號
                        .replace("\r", "\\r")    // CR
                        .replace("\n", "\\n")    // LF
                        .replace("\t", "\\t");   // Tab
                errList.add("No(" + iTJobDto.getNo() + ")新增失敗=>"+ msg);
                iTJob.ITJob.iTJobDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
        stamt.close();
    }

    public boolean updateITJob(Map<String, Map<String, String>> map) throws SQLException {
        boolean isSuccess = false;
        for (Map.Entry<String, Map<String, String>> entry : map.entrySet()) {
            Map<String, String> parameterMap = entry.getValue();
            try {
                String sql = "update TSC.IT_JOB_LIST \n " +
                        "set REQUEST_DATE = ? \n " +
                        ",TASK_DESCRIPTION = ? \n " +
                        ",MEMO = ? \n " +
                        ",STATUS = ? \n " +
                        ",OWNER = ? \n " +
                        ",CLOSED_DATE = ? \n " +
                        ",SEVERITY = ? \n " +
                        ",CLASS = ? \n " +
                        "where NO = ?";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, parameterMap.get("requestDate"));
                pstmt.setString(2, parameterMap.get("taskDescription"));
                pstmt.setString(3, parameterMap.get("memo"));
                pstmt.setString(4, parameterMap.get("status"));
                pstmt.setString(5, parameterMap.get("owner"));
                pstmt.setString(6, parameterMap.get("closedDate"));
                pstmt.setString(7, parameterMap.get("severity"));
                pstmt.setString(8, parameterMap.get("class"));
                pstmt.setString(9, entry.getKey());
                int rows = pstmt.executeUpdate();
                isSuccess = rows != 0;
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                String msg = e.getMessage().replace("\\", "\\\\")   // 反斜線
                        .replace("\"", "")   // 雙引號
                        .replace("\r", "\\r")    // CR
                        .replace("\n", "\\n")    // LF
                        .replace("\t", "\\t");   // Tab
                errList.add("(No: " + entry.getKey() + ")更新失敗=>" + msg);
                iTJob.ITJob.iTJobDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
        return isSuccess;
    }

    @Override
    public boolean deleteITJob(List<String> noList) throws SQLException {
        boolean isSuccess = false;
        for (String no : noList) {
            try {
                String sql = "delete TSC.IT_JOB_LIST \n " +
                        "where no = ? ";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, no);
                int rows = pstmt.executeUpdate();
                isSuccess = rows != 0;
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                String msg = e.getMessage().replace("\\", "\\\\")   // 反斜線
                        .replace("\"", "")   // 雙引號
                        .replace("\r", "\\r")    // CR
                        .replace("\n", "\\n")    // LF
                        .replace("\t", "\\t");   // Tab
                errList.add("" + no + ")刪除失敗=>" + msg);
                iTJob.ITJob.iTJobDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
        return isSuccess;
    }

    @Override
    public Map<Integer, ITJobDto> searchITJob(String[] dates, String[] status, String[] owner) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM TSC.IT_JOB_LIST WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // 動態組條件
        appendInCondition(sql, params, "dates", dates);
        appendInCondition(sql, params, "status", status);
        appendInCondition(sql, params, "owner", owner);;

        sql.append(" ORDER BY TO_DATE(REQUEST_DATE, 'yyyy/mm/dd') DESC, NO DESC");
//        System.out.println(sql);

        HashMap<Integer, ITJobDto> map = new LinkedHashMap<>();
        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            // 帶入參數
            for (int i = 0; i < params.size(); i++) {
                System.out.println("params="+params.get(i));
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            int rsRowCount = 0;
            while (rs.next()) {
                rsRowCount++;
                ITJobDto iTJobDto = new ITJobDto();
                iTJobDto.setNo(rs.getString("NO"));
                iTJobDto.setRequestDate(rs.getString("REQUEST_DATE"));
                iTJobDto.setTaskDescription(rs.getString("TASK_DESCRIPTION"));
                iTJobDto.setMemo(rs.getString("MEMO"));
                iTJobDto.setStatus(rs.getString("STATUS"));
                iTJobDto.setOwner(rs.getString("OWNER"));
                iTJobDto.setClosedDate(rs.getString("CLOSED_DATE"));
                iTJobDto.setSeverity(rs.getString("SEVERITY"));
                iTJobDto.setCategory(rs.getString("CLASS"));
                map.put(rsRowCount, iTJobDto);
            }
        }
        return map;
    }

    private void appendInCondition(StringBuilder sql, List<Object> params, String column, String[] values) {
        if ("dates".equals(column)) {
            // 日期條件
            if (values != null && values.length > 0 && !"".equals(values[0])) {
                if (values.length == 2) {
                    String startDate = values[0]; // yyyy/MM/dd
                    String endDate = values[1];
                    sql.append(" AND TO_DATE(REQUEST_DATE, 'yyyy/mm/dd') >= TO_DATE('").append(startDate).append("', 'yyyy/mm/dd') ");
                    sql.append(" AND TO_DATE(REQUEST_DATE, 'yyyy/mm/dd') <= TO_DATE('").append(endDate).append("', 'yyyy/mm/dd') ");
                } else if (values.length == 1) {
                    String startDate = values[0];
                    sql.append(" AND TO_DATE(REQUEST_DATE, 'yyyy/mm/dd') >= TO_DATE('").append(startDate).append("', 'yyyy/mm/dd') ");
                }
            }
        } else if (values != null && values.length > 0 && !"".equals(values[0])) {
            sql.append(" AND ").append(column).append(" IN (");
            for (int i = 0; i < values.length; i++) {
                sql.append("?");
                if (i < values.length - 1) sql.append(",");
            }
            sql.append(")");
            params.addAll(Arrays.asList(values));
        }
    }
}
