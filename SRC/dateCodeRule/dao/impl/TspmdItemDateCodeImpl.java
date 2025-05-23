package dateCodeRule.dao.impl;

import com.mysql.jdbc.StringUtils;
import dateCodeRule.DateCodeRuleSetting;
import dateCodeRule.dto.DateCodeDto;

import java.sql.*;
import java.util.Date;
import java.util.*;

import static dateCodeRule.DateCodeRuleSetting.dateCodeDto;

public class TspmdItemDateCodeImpl implements TspmdItemDateCodeDao {
    public List<String> errList = new ArrayList<>();
    @Override
    public void insertTspmdItemDateCode(Connection conn, HashMap<Integer, DateCodeDto> map, String userName) throws SQLException {
        Statement statement = conn.createStatement();
        for (Map.Entry<Integer, DateCodeDto> dateCodeDtoEntry : map.entrySet()) {
//            errList = new ArrayList<>()
            DateCodeDto dateCodeDto = dateCodeDtoEntry.getValue();
            ResultSet rs = statement.executeQuery("select 1 FROM inv.mtl_system_items_b \n" +
                    "where ORGANIZATION_ID = 49 \n" +
                    "and description='" + dateCodeDto.getDevice() + "'");
            if (rs.next()) {
                try {
                    String sql = "insert into oraddman.tspmd_item_date_code \n " +
                            "(item_description, date_code_rule, remarks, creation_date, date_code_example, upload_by) \n " +
                            "values(?, ?, ?, ?, ?, ?)";

                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, dateCodeDto.getDevice());
                    pstmt.setString(2, dateCodeDto.getDateCode());
                    pstmt.setString(3, dateCodeDto.getRemark());
                    pstmt.setTimestamp(4, new Timestamp(new Date().getTime()));
                    pstmt.setString(5, dateCodeDto.getMarking());
                    pstmt.setString(6, userName);
                    pstmt.executeUpdate();
                    pstmt.close();
                    conn.commit();
                } catch (SQLException e) {
                    errList.add("<strong>(" + dateCodeDto.getDevice() + ")</strong>已存在");
                    DateCodeRuleSetting.dateCodeDto.setErrorList(errList);
                    e.printStackTrace();
                    conn.rollback();
                }
            } else {
                errList.add("<strong>(" + dateCodeDto.getDevice() + ")</strong>料號主檔不存在");
                DateCodeRuleSetting.dateCodeDto.setErrorList(errList);
                conn.rollback();
            }
            rs.close();
        }
        statement.close();
    }

    @Override
    public Map<Integer, DateCodeDto> getTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException {

        String sql = "select item_description, date_code_rule, remarks, date_code_example, creation_date, upload_by, modify_by, update_date \n " +
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
            dateCodeDto.setRemark(StringUtils.isNullOrEmpty(rs.getString("remarks")) ? "" : rs.getString("remarks"));
            dateCodeDto.setMarking(rs.getString("date_code_example"));
            dateCodeDto.setCreationDate(rs.getString("creation_date"));
            dateCodeDto.setUploadBy(rs.getString("upload_by"));
            dateCodeDto.setModifyBy(rs.getString("modify_by"));
            dateCodeDto.setUpdateDate(rs.getString("update_date"));
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
            dateCodeDto.setErrMsg(e.getMessage());
            e.printStackTrace();
            conn.rollback();
        }
    }

    public void updateMultiTspmdItemDateCode(Connection conn, Map<String, Map<String, String>> map, String modifyBy) throws SQLException {
        for (Map.Entry<String, Map<String, String>> entry : map.entrySet()) {
            Map<String, String> parameterMap = entry.getValue();
            try {
                String sql = "update oraddman.tspmd_item_date_code \n " +
                        "set date_code_rule = ? \n " +
                        ",remarks = ? \n " +
                        ",date_code_example = ? \n " +
                        ",modify_by = ? \n " +
                        ",update_date = ? \n " +
                        "where item_description = ?";

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, parameterMap.get("dateCode"));
                pstmt.setString(2, parameterMap.get("remarks"));
                pstmt.setString(3, parameterMap.get("marking"));
                pstmt.setString(4, modifyBy);
                pstmt.setTimestamp(5, new Timestamp(new Date().getTime()));
                pstmt.setString(6, entry.getKey());
                pstmt.executeUpdate();
                pstmt.close();
                conn.commit();
            } catch (SQLException e) {
                errList.add("<strong>(" + parameterMap.get("dateCode") + ")</strong>更新失敗");
                DateCodeRuleSetting.dateCodeDto.setErrorList(errList);
//                dateCodeDto.setErrorList(errList);
//                dateCodeDto.setErrMsg(e.getMessage());
                e.printStackTrace();
                conn.rollback();
            }
        }
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
                DateCodeRuleSetting.dateCodeDto.setErrorList(errList);
//                dateCodeDto.setErrorList(errList);
                e.printStackTrace();
                conn.rollback();
            }
        }
    }
}
