package tscc.dao.impl;

import tscc.dto.TsccOrderToRfqDto;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;

public interface TsccOrderToRfqDao {

    void setPolicyContext(Connection conn, String orgId) throws SQLException;
    Map<Integer, TsccOrderToRfqDto> getOrderToRfq(Connection conn, String headerId, String salesNo, String orderType) throws SQLException;
}
