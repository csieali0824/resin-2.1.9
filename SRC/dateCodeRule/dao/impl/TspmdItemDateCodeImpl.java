package dateCodeRule.dao.impl;

import com.mysql.jdbc.StringUtils;
import dateCodeRule.dto.DateCodeDto;

import java.sql.*;
import java.util.Date;
import java.util.*;

public class TspmdItemDateCodeImpl implements TspmdItemDateCodeDao {
    private DateCodeDto dateCodeDto = new DateCodeDto();
    public List<String> errList = new ArrayList<>();
    @Override
    public void insertTspmdItemDateCode(Connection conn, HashMap<Integer, DateCodeDto> map, String userName) throws SQLException {
        Statement statement = conn.createStatement();
        for (Map.Entry<Integer, DateCodeDto> dateCodeDtoEntry : map.entrySet()) {
            DateCodeDto dateCodeDto = dateCodeDtoEntry.getValue();
            ResultSet rs = statement.executeQuery("select 1 FROM inv.mtl_system_items_b \n" +
                    "where ORGANIZATION_ID = 49 \n" +
                    "and description='" + dateCodeDto.getDevice() + "'");
            if (rs.next()) {
                try {
                    String sql = "insert into oraddman.tspmd_item_date_code \n " +
                            "(item_description, date_code_rule, remarks, creation_date, date_code_example, upload_by, marking_desc) \n " +
                            "values(?, ?, ?, ?, ?, ?, ?)";

                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, dateCodeDto.getDevice());
                    pstmt.setString(2, dateCodeDto.getDateCode());
                    pstmt.setString(3, dateCodeDto.getRemarks());
                    pstmt.setTimestamp(4, new Timestamp(new Date().getTime()));
                    pstmt.setString(5, dateCodeDto.getMarking());
                    pstmt.setString(6, userName);
                    pstmt.setString(7, dateCodeDto.getMarkingDesc());
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.commit();
                } catch (SQLException e) {
                    errList.add("<strong>(" + dateCodeDto.getDevice() + ")</strong>已存在");
//                    dateCodeDto.setErrorList(errList);
                    e.printStackTrace();
                    conn.rollback();
                }
            } else {
                errList.add("<strong>(" + dateCodeDto.getDevice() + ")</strong>料號主檔不存在");
//                dateCodeDto.setErrorList(errList);
                conn.rollback();
            }
            rs.close();
        }
        statement.close();
    }

    @Override
    public Map<Integer, DateCodeDto> getTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException {

        String sql = "select item_description, date_code_rule, remarks, date_code_example, creation_date, \n " +
                " upload_by, modify_by, update_date, marking_desc \n " +
                "from oraddman.tspmd_item_date_code \n " +
                "where item_description = nvl(?, item_description) \n " +
                "and date_code_rule = nvl(?, date_code_rule) \n " +
                "and (date_code_example = nvl(?,date_code_example) or date_code_example is null)  \n " +
                "order by creation_date desc";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, itemDesc);
        pstmt.setString(2, dateCodeRule);
        pstmt.setString(3, dateCodeExample);
        ResultSet rs = pstmt.executeQuery();
        HashMap<Integer, DateCodeDto> dateCodeMap = new LinkedHashMap<>();
        int rsRowCount = 0;
        while (rs.next()) {
            rsRowCount++;
            DateCodeDto dateCodeDto = new DateCodeDto();
            dateCodeDto.setDevice(rs.getString("item_description"));
            dateCodeDto.setDateCode(rs.getString("date_code_rule"));
            dateCodeDto.setRemarks(StringUtils.isNullOrEmpty(rs.getString("remarks")) ? "" : rs.getString("remarks"));
            dateCodeDto.setMarking(rs.getString("date_code_example"));
            dateCodeDto.setCreationDate(rs.getString("creation_date"));
            dateCodeDto.setUploadBy(rs.getString("upload_by"));
            dateCodeDto.setModifyBy(rs.getString("modify_by"));
            dateCodeDto.setUpdateDate(rs.getString("update_date"));
            dateCodeDto.setMarkingDesc(rs.getString("marking_desc"));
            dateCodeMap.put(rsRowCount, dateCodeDto);
        }
        pstmt.close();
        rs.close();
        return dateCodeMap;
    }

    @Override
    public void updateTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException {
        try {
            String sql = "update oraddman.tspmd_item_date_code \n "+
                    "set date_code_rule = ? \n "+
                    ",date_code_example = ? \n "+
                    ",creation_date = ? \n "+
                    "where item_description = ?";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, dateCodeRule);
            pstmt.setString(2, dateCodeExample);
            pstmt.setTimestamp(3, new Timestamp(new Date().getTime()));
            pstmt.setString(4, itemDesc);
            pstmt.executeUpdate();
            pstmt.close();
            conn.commit();
        } catch (SQLException e) {
            errList.add("<strong>(" + dateCodeDto.getDateCode() + ")</strong>更新失敗");
//            dateCodeDto.setErrMsg(e.getMessage());
            e.printStackTrace();
            conn.rollback();
        }
    }

    public void updateMultiTspmdItemDateCode(Connection conn, Map<String, DateCodeDto> map, String modifyBy) throws SQLException {
//        for (Map.Entry<String, Map<String, String>> entry : map.entrySet()) {
//            Map<String, String> parameterMap = entry.getValue();
            try {
                String sql = "update oraddman.tspmd_item_date_code \n " +
                        "set date_code_rule = ? \n " +
                        ",remarks = ? \n " +
                        ",date_code_example = ? \n " +
                        ",marking_desc = ? \n " +
                        ",modify_by = ? \n " +
                        ",update_date = sysdate \n " +
                        "where item_description = ?";

                PreparedStatement pstmt = conn.prepareStatement(sql);

                for (Map.Entry<String, DateCodeDto> dateCodeDtoEntry : map.entrySet()) {
                    dateCodeDto = dateCodeDtoEntry.getValue();
                    System.out.println("getMarkingDesc="+dateCodeDto.getMarkingDesc());
                    pstmt.setString(1, dateCodeDto.getDateCode());
                    pstmt.setString(2, dateCodeDto.getRemarks());
                    pstmt.setString(3, dateCodeDto.getMarking());
                    pstmt.setString(4, dateCodeDto.getMarkingDesc());
                    pstmt.setString(5, modifyBy);
                    pstmt.setString(6, dateCodeDtoEntry.getKey());
                    pstmt.addBatch();
                }
                pstmt.executeBatch();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                errList.add("<strong>(" + dateCodeDto.getDateCode() + ")</strong>更新失敗");
//                dateCodeDto.setErrorList(errList);
//                dateCodeDto.setErrorList(errList);
//                dateCodeDto.setErrMsg(e.getMessage());
                e.printStackTrace();
                conn.rollback();
            }
//        }
    }

    @Override
    public void deleteItemDateCode(Connection conn, List<String> itemDescList) throws SQLException {
        for (String itemDesc : itemDescList) {
            try {
                String sql = "delete oraddman.tspmd_item_date_code \n " +
                        "where item_description = ? ";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, itemDesc);
                pstmt.executeUpdate();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                errList.add("<strong>(" + itemDesc + ")</strong>刪除失敗");
//                dateCodeDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
    }

    @Override
    public void insertDateCodeYYWW(Connection conn, HashMap<Integer, DateCodeDto> map, String userName) throws SQLException {
        for (Map.Entry<Integer, DateCodeDto> dateCodeDtoEntry : map.entrySet()) {
            DateCodeDto dateCodeDto = dateCodeDtoEntry.getValue();
            try {
                String sql = "insert into TSC.DATE_CODE_YYWW \n " +
                        "(DC, DATE_CODE, PROD_GROUP, YYWW, YEAR, USER_NAME, CREATE_DATE) \n " +
                        "values(?, ?, ?, ?, ?, ?, ?)";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, dateCodeDto.getDateCodeRange());
                pstmt.setString(2, dateCodeDto.getDateCode());
                pstmt.setString(3, dateCodeDto.getProdGroup());
                pstmt.setString(4, dateCodeDto.getYyww());
                pstmt.setString(5, dateCodeDto.getYear());
                pstmt.setString(6, userName);
                pstmt.setTimestamp(7, new Timestamp(System.currentTimeMillis()));
                pstmt.executeUpdate();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                String dateCodeExists = dateCodeDto.getDateCodeRange()
                        .concat(";")
                        .concat(dateCodeDto.getDateCode())
                        .concat(dateCodeDto.getProdGroup());

                errList.add("<strong>(" + dateCodeExists + ")</strong>已存在");
//                dateCodeDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
    }

    @Override
    public Map<Integer, DateCodeDto> getDateCodeYYWW(Connection conn, String dc, String dateCode, String prodGroup, String year) throws SQLException {
        String sql = "select * from TSC.DATE_CODE_YYWW \n " +
                "where DC like nvl(?, DC)||'%' \n " +
                "and DATE_CODE = nvl(?, DATE_CODE) \n " +
                "and PROD_GROUP = nvl(?,PROD_GROUP) \n " +
                "and YEAR = nvl(?,YEAR) \n " +
                "order by DATE_CODE desc, DC asc";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, dc);
        pstmt.setString(2, dateCode);
        pstmt.setString(3, prodGroup);
        pstmt.setString(4, year);
        ResultSet rs = pstmt.executeQuery();
        HashMap<Integer, DateCodeDto> dateCodeMap = new LinkedHashMap<>();
        int rsRowCount = 0;
        while (rs.next()) {
            rsRowCount++;
            DateCodeDto dateCodeDto = new DateCodeDto();
            dateCodeDto.setDateCodeRange(rs.getString("dc"));
            dateCodeDto.setDateCode(rs.getString("date_code"));
            dateCodeDto.setProdGroup(rs.getString("prod_group"));
            dateCodeDto.setYyww(rs.getString("yyww"));
            dateCodeDto.setYear(rs.getString("year"));
            dateCodeDto.setCreationDate(rs.getString("create_date"));
            dateCodeDto.setUploadBy(rs.getString("user_name"));
            dateCodeMap.put(rsRowCount, dateCodeDto);
        }
        pstmt.close();
        rs.close();
        return dateCodeMap;
    }
}
