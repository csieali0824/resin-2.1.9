package modelN.dao.impl;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public interface TscRfqUploadTempDao {

    void setPolicyContext(Connection conn) throws SQLException;

    Map getTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy, String customerNo, String customerPo, String groupByType, String shipToOrgId) throws SQLException;

    void deleteTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy, String customerId, String customerPo, String groupByType, String shipToOrgId) throws SQLException;
    void deleteAllTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy) throws SQLException;

    void insertTscRfqUploadTemp(Connection conn, HashMap map, String salesNo, String userName, String rfqType, String groupByType) throws Exception;
}
