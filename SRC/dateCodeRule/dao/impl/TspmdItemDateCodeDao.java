package dateCodeRule.dao.impl;

import dateCodeRule.dto.DateCodeDto;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface TspmdItemDateCodeDao {
    void insertTspmdItemDateCode(Connection conn, HashMap<Integer, DateCodeDto> map, String userName) throws SQLException;
    Map<Integer, DateCodeDto> getTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException;
    void updateTspmdItemDateCode(Connection conn, String itemDesc, String dateCodeRule, String dateCodeExample) throws SQLException;
    void updateMultiTspmdItemDateCode(Connection conn, Map<String, Map<String, String>> map, String modifyBy) throws SQLException;
    void deleteItemDateCode(Connection conn, List<String> itemDescList) throws SQLException;
}
