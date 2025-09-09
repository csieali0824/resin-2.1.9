package tscc.dao.impl;

import com.mysql.jdbc.StringUtils;
import tscc.dto.TsccOrderToRfqDto;

import java.sql.*;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

public class TsccOrderToRfqImpl implements TsccOrderToRfqDao {

    @Override
    public void setPolicyContext(Connection conn, String orgId) throws SQLException {
        String sql = "alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.executeUpdate();
        pstmt.close();

        CallableStatement cs = conn.prepareCall("{call mo_global.set_policy_context('S',?)}");
        cs.setString(1, StringUtils.isNullOrEmpty(orgId)? "325" : orgId);  // 取業務員隸屬ParOrgID
        cs.execute();
        cs.close();
    }

    @Override
    public Map<Integer, TsccOrderToRfqDto> getOrderToRfq(Connection conn, String headerId, String salesNo, String orderType) throws SQLException {

        String sql = "SELECT\n" +
                "    TH.*,\n" +
                "    CASE\n" +
                "        WHEN TH.QUANTITY <> TH.RFQ_QTY THEN '客戶只需' || TH.QUANTITY || 'K'\n" +
                "        ELSE ''\n" +
                "    END AS RFQ_REMARK\n" +
                "FROM (\n" +
                "    SELECT\n" +
                "        A.SAREA_NO, \n" +
                "        A.ORDER_NUM4 AS ORDER_TYPE,\n" +
                "        A.HEADER_ID,\n" +
                "        A.LINE_ID,\n" +
                "        A.INVENTORY_ITEM_ID ITEM_ID,\n" +
                "        E.SEGMENT1 ITEM_NAME,\n" +
                "        E.DESCRIPTION ITEM_DESC,\n" +
                "        A.UNIT_PRICE,\n" +
                "        TO_CHAR(A.REQUEST_DATE, 'yyyymmdd') REQUEST_DATE,\n" +
                "        A.FACTORY_CODE,\n" +
                "        A.SHIPPING_METHOD_CODE SHIPPING_METHOD,\n" +
                "        J.lookup_code SHIPPING_METHOD_CODE,\n" +
                "        A.FOB_POINT_CODE,\n" +
                "        M.FOB,\n" +
                "        A.FLOW_STATUS_CODE TSCC_ORDER_STATUS,\n" +
                "        A.SUPPLY_ORG_ID,\n" +
                "        A.SUPPLY_CUSTOMER_ID,\n" +
                "        K.CUSTOMER_NUMBER SUPPLY_CUSTOMER_NUMBER,\n" +
                "        K.CUSTOMER_NAME SUPPLY_CUSTOMER_NAME,\n" +
                "        K.CUSTOMER_NAME_PHONETIC SUPPLY_CUSTOMER_NAME_PHONETIC,\n" +
                "        NVL(B.CUST_PO_NUMBER, B.CUSTOMER_LINE_NUMBER) CUST_PO_NUMBER,\n" +
                "        B.CUSTOMER_LINE_NUMBER CUST_PO_LINE_NUMBER,\n" +
                "        DECODE(B.ORDERED_ITEM_ID, B.INVENTORY_ITEM_ID, NULL, B.ORDERED_ITEM) ORDERED_ITEM,\n" +
                "        CASE\n" +
                "            WHEN B.ORDERED_ITEM_ID = B.INVENTORY_ITEM_ID THEN 0\n" +
                "            ELSE NVL((\n" +
                "                SELECT x.ITEM_ID\n" +
                "                FROM oe_items_v x\n" +
                "                WHERE x.ITEM = B.ORDERED_ITEM\n" +
                "                  AND x.INVENTORY_ITEM_ID = B.INVENTORY_ITEM_ID\n" +
                "                  AND x.SOLD_TO_ORG_ID = A.SUPPLY_CUSTOMER_ID\n" +
                "                  AND x.ITEM_STATUS = 'ACTIVE'\n" +
                "                  AND x.CROSS_REF_STATUS = 'ACTIVE'\n" +
                "            ), 0)\n" +
                "        END AS ORDERED_ITEM_ID,\n" +
                "        D.CUSTOMER_ID TSCC_CUSTOMER_ID,\n" +
                "        CASE\n" +
                "            WHEN K.CUSTOMER_NUMBER = D.CUSTOMER_NUMBER THEN ''\n" +
                "        ELSE D.CUSTOMER_NUMBER END TSCC_CUSTOMER_NUMBER,\n" +
//                "        D.CUSTOMER_NUMBER TSCC_CUSTOMER_NUMBER,\n" +
                "        D.CUSTOMER_NAME TSCC_CUSTOMER_NAME,\n" +
                "        CASE\n" +
                "            WHEN K.CUSTOMER_NUMBER = D.CUSTOMER_NUMBER THEN ''\n" +
                "        ELSE NVL(HCA.ACCOUNT_NAME, D.CUSTOMER_NAME) END CUSTOMER_NAME_PHONETIC,\n" +
                "        C.SALESREP_ID,\n" +
                "        B.CUSTOMER_SHIPMENT_NUMBER CUST_PO_LINE_NO,\n" +
                "        F.NAME SALESREP_NAME,\n" +
                "        C.TRANSACTIONAL_CURR_CODE CURRENCY,\n" +
                "        E.INVENTORY_ITEM_STATUS_CODE ITEM_STATUS,\n" +
                "        G.ORDER_NUMBER SUPPLY_SO_NO,\n" +
                "        I.OTYPE_ID,\n" +
                "        I.DEFAULT_ORDER_LINE_TYPE LINE_TYPE,\n" +
                "        A.QUANTITY / 1000 QUANTITY,\n" +
                "        A.SPQ / 1000 SPQ,\n" +
                "        A.MOQ / 1000 MOQ,\n" +
                "        A.SAMPLE_SPQ / 1000 SAMPLE_SPQ,\n" +
                "        B.LINE_NUMBER || '.' || B.SHIPMENT_NUMBER LINE_NO,\n" +
                "        (\n" +
                "            CASE\n" +
                "                WHEN A.MOQ > 0 THEN\n" +
                "                    CASE\n" +
                "                        WHEN A.QUANTITY <= A.MOQ THEN A.MOQ\n" +
                "                        ELSE CEIL(A.QUANTITY / A.SPQ) * A.SPQ\n" +
                "                    END\n" +
                "                ELSE A.QUANTITY\n" +
                "            END\n" +
                "        ) / 1000 AS RFQ_QTY,\n" +
                "        TSC_ITEM_GREEN_CHECK(E.ORGANIZATION_ID, E.INVENTORY_ITEM_ID) GREEN_FLAG,\n" +
                "        CASE\n" +
                "            WHEN TRUNC(A.REQUEST_DATE) < TRUNC(SYSDATE) + 7 THEN 'Y'\n" +
                "            ELSE 'N'\n" +
                "        END AS REQUEST_DATE_FLAG,\n" +
                "        CASE\n" +
                "            WHEN A.FACTORY_CODE IS NULL OR A.FACTORY_CODE = ''\n" +
                "                 OR A.FACTORY_CODE NOT IN ('002', '005', '006', '008', '010', '011') THEN 'Y'\n" +
                "            ELSE 'N'\n" +
                "        END AS FACTORY_CODE_FLAG,\n" +
                "        COUNT(A.LINE_ID) OVER (PARTITION BY A.HEADER_ID ORDER BY A.LINE_ID DESC) LINE_SEQ,\n" +
                "        TSC_ITEM_PCN_FLAG(43, A.INVENTORY_ITEM_ID, TRUNC(SYSDATE)) PCN_FLAG," +
                "        (SELECT USER_NAME FROM FND_USER WHERE A.CREATED_BY = USER_ID) AS CREATED_BY,\n" +
                "        TO_CHAR(A.CREATION_DATE,'yyyy/mm/dd') CREATION_DATE\n" +
                "    FROM (\n" +
                "        SELECT\n" +
                "            toq.*,\n" +
                "            NVL((SELECT SPQ FROM TABLE(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID, 'TS', toq" +
                ".FACTORY_CODE))), 0) AS SPQ,\n" +
                "            NVL((SELECT MOQ FROM TABLE(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID, 'TS', toq" +
                ".FACTORY_CODE))), 0) AS MOQ,\n" +
                "            NVL((SELECT SAMPLE_SPQ FROM TABLE(tsc_get_item_spq_moq(toq.INVENTORY_ITEM_ID, 'TS', toq" +
                ".FACTORY_CODE))), 0) AS SAMPLE_SPQ\n" +
                "        FROM TSC_OM_REQUISITION toq\n" +
                "        WHERE HEADER_ID = ?\n" +
                "          AND QUANTITY > 0\n" +
                "    ) A,\n" +
                "    ONT.OE_ORDER_LINES_ALL B,\n" +
                "    ONT.OE_ORDER_HEADERS_ALL C,\n" +
                "    AR_CUSTOMERS D,\n" +
                "    HZ_CUST_ACCOUNTS HCA,\n" +
                "    INV.MTL_SYSTEM_ITEMS_B E,\n" +
                "    (\n" +
                "        SELECT\n" +
                "            rs.SALESREP_ID,\n" +
                "            res.resource_name NAME\n" +
                "        FROM JTF_RS_SALESREPS rs,\n" +
                "             JTF_RS_RESOURCE_EXTNS_VL res\n" +
                "        WHERE STATUS = 'A'\n" +
                "          AND rs.resource_id = res.resource_id\n" +
                "          AND (res.END_DATE_ACTIVE IS NULL OR res.END_DATE_ACTIVE > TRUNC(SYSDATE))\n" +
                "    ) F,\n" +
                "    ONT.OE_ORDER_HEADERS_ALL G,\n" +
                "    ONT.OE_ORDER_LINES_ALL H,\n" +
                "    ORADDMAN.TSAREA_ORDERCLS I,\n" +
                "    (\n" +
                "        SELECT lookup_code, meaning\n" +
                "        FROM fnd_lookup_values lv\n" +
                "        WHERE language = 'US'\n" +
                "          AND view_application_id = 3\n" +
                "          AND lookup_type = 'SHIP_METHOD'\n" +
                "          AND security_group_id = 0\n" +
                "          AND ENABLED_FLAG = 'Y'\n" +
                "          AND (end_date_active IS NULL OR end_date_active > SYSDATE)\n" +
                "    ) J,\n" +
                "    AR_CUSTOMERS K,\n" +
                "    OE_FOBS_ACTIVE_V M\n" +
                "    WHERE A.ORG_ID = B.ORG_ID\n" +
                "      AND A.HEADER_ID = B.HEADER_ID\n" +
                "      AND A.LINE_ID = B.LINE_ID\n" +
                "      AND B.HEADER_ID = C.HEADER_ID\n" +
                "      AND B.ORG_ID = C.ORG_ID\n" +
                "      AND C.SOLD_TO_ORG_ID = D.CUSTOMER_ID\n" +
                "      AND D.CUSTOMER_ID = HCA.CUST_ACCOUNT_ID\n" +
                "      AND A.INVENTORY_ITEM_ID = E.INVENTORY_ITEM_ID\n" +
                "      AND E.ORGANIZATION_ID = ?\n" +
                "      AND C.SALESREP_ID = F.SALESREP_ID(+)\n" +
                "      AND A.SUPPLY_ORG_ID = H.ORG_ID(+)\n" +
                "      AND A.SUPPLY_LINE_ID = H.LINE_ID(+)\n" +
                "      AND H.HEADER_ID = G.HEADER_ID(+)\n" +
                "      AND H.ORG_ID = G.ORG_ID(+)\n" +
                "      AND A.SHIPPING_METHOD_CODE = J.meaning(+)\n" +
                "      AND A.SUPPLY_CUSTOMER_ID = K.CUSTOMER_ID(+)\n" +
                "      AND A.FOB_POINT_CODE = M.FOB_CODE(+)\n" +
                "      AND A.SAREA_NO = I.SAREA_NO(+)\n" +
                "      AND A.ORDER_NUM4 = I.ORDER_NUM(+)\n" +
                "      AND A.SAREA_NO = NVL(?, A.SAREA_NO)\n" +
                "      AND A.ORDER_NUM4 = NVL(?, A.ORDER_NUM4)\n" +
//                "      AND K.CUSTOMER_NUMBER = NVL(?, K.CUSTOMER_NUMBER)\n" +
                "      AND A.FLOW_STATUS_CODE = 'ENTERED'\n" +
                ") TH\n" +
                "ORDER BY ORDER_TYPE DESC,\n" +
                "    HEADER_ID,\n" +
                "    LINE_SEQ DESC";
//        System.out.println(sql);
        HashMap<Integer, TsccOrderToRfqDto> tsccOrderToRfqMap = new LinkedHashMap<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, headerId);
            pstmt.setInt(2, 49);
            pstmt.setString(3, salesNo);
            pstmt.setString(4, orderType);
            int rsRowCount = 0;
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    rsRowCount++;
                    TsccOrderToRfqDto tsccOrderToRfqDto = new TsccOrderToRfqDto();
                    tsccOrderToRfqDto.setHeaderId(rs.getString("HEADER_ID"));
                    tsccOrderToRfqDto.setLineId(rs.getString("LINE_ID"));
                    tsccOrderToRfqDto.setItemId(rs.getString("ITEM_ID"));
                    tsccOrderToRfqDto.setItemName(rs.getString("ITEM_NAME"));
                    tsccOrderToRfqDto.setItemDesc(rs.getString("ITEM_DESC"));
                    tsccOrderToRfqDto.setUnitPrice(rs.getString("UNIT_PRICE"));
                    tsccOrderToRfqDto.setRequestDate(rs.getString("REQUEST_DATE"));
                    tsccOrderToRfqDto.setFactoryCode(rs.getString("FACTORY_CODE"));
                    tsccOrderToRfqDto.setShippingMethod(rs.getString("SHIPPING_METHOD"));
                    tsccOrderToRfqDto.setShippingMethodCode(rs.getString("SHIPPING_METHOD_CODE"));
                    tsccOrderToRfqDto.setFobPointCode(rs.getString("FOB_POINT_CODE"));
                    tsccOrderToRfqDto.setFob(rs.getString("FOB"));
                    tsccOrderToRfqDto.setTsccOrderStatus(rs.getString("TSCC_ORDER_STATUS"));
                    tsccOrderToRfqDto.setSupplyOrgId(rs.getString("SUPPLY_ORG_ID"));
                    tsccOrderToRfqDto.setSupplyCustomerId(rs.getString("SUPPLY_CUSTOMER_ID"));
                    tsccOrderToRfqDto.setSupplyCustomerNumber(rs.getString("SUPPLY_CUSTOMER_NUMBER"));
                    tsccOrderToRfqDto.setSupplyCustomerName(rs.getString("SUPPLY_CUSTOMER_NAME"));
                    tsccOrderToRfqDto.setSupplyCustomerNamePhonetic(rs.getString("SUPPLY_CUSTOMER_NAME_PHONETIC"));
                    tsccOrderToRfqDto.setCustPoNumber(rs.getString("CUST_PO_NUMBER"));
                    tsccOrderToRfqDto.setOrderedItem(rs.getString("ORDERED_ITEM"));
                    tsccOrderToRfqDto.setOrderedItemId(rs.getString("ORDERED_ITEM_ID"));
                    tsccOrderToRfqDto.setTsccCustomerId(rs.getString("TSCC_CUSTOMER_ID"));
                    tsccOrderToRfqDto.setTsccCustomerNumber(rs.getString("TSCC_CUSTOMER_NUMBER"));
                    tsccOrderToRfqDto.setTsccCustomerName(rs.getString("TSCC_CUSTOMER_NAME"));
                    tsccOrderToRfqDto.setCustomerNamePhonetic(rs.getString("CUSTOMER_NAME_PHONETIC"));
                    tsccOrderToRfqDto.setSalesrepId(rs.getString("SALESREP_ID"));
                    tsccOrderToRfqDto.setCustPoLineNo(rs.getString("CUST_PO_LINE_NUMBER"));
                    tsccOrderToRfqDto.setSalesrepName(rs.getString("SALESREP_NAME"));
                    tsccOrderToRfqDto.setCurrency(rs.getString("CURRENCY"));
                    tsccOrderToRfqDto.setItemStatus(rs.getString("ITEM_STATUS"));
                    tsccOrderToRfqDto.setSupplySoNo(rs.getString("SUPPLY_SO_NO"));
                    tsccOrderToRfqDto.setOrderType(rs.getString("ORDER_TYPE"));
                    tsccOrderToRfqDto.setOtypeId(rs.getString("OTYPE_ID"));
                    tsccOrderToRfqDto.setLineType(rs.getString("LINE_TYPE"));
                    tsccOrderToRfqDto.setQuantity(rs.getString("QUANTITY"));
                    tsccOrderToRfqDto.setSpq(rs.getString("SPQ"));
                    tsccOrderToRfqDto.setMoq(rs.getString("MOQ"));
                    tsccOrderToRfqDto.setSampleSpq(rs.getString("SAMPLE_SPQ"));
                    tsccOrderToRfqDto.setLineNo(rs.getString("LINE_NO"));
                    tsccOrderToRfqDto.setRfqQty(rs.getString("RFQ_QTY"));
                    tsccOrderToRfqDto.setGreenFlag(rs.getString("GREEN_FLAG"));
                    tsccOrderToRfqDto.setRequestDateFlag(rs.getString("REQUEST_DATE_FLAG"));
                    tsccOrderToRfqDto.setFactoryCodeFlag(rs.getString("FACTORY_CODE_FLAG"));
                    tsccOrderToRfqDto.setLineSeq(rs.getString("LINE_SEQ"));
                    tsccOrderToRfqDto.setPcnFlag(rs.getString("PCN_FLAG"));
                    tsccOrderToRfqDto.setRfqRemark(rs.getString("RFQ_REMARK"));
                    tsccOrderToRfqDto.setCreatedBy(rs.getString("CREATED_BY"));
                    tsccOrderToRfqDto.setCreationDate(rs.getString("CREATION_DATE"));
                    tsccOrderToRfqDto.setSalesNo(rs.getString("SAREA_NO"));
                    tsccOrderToRfqMap.put(rsRowCount, tsccOrderToRfqDto);
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new RuntimeException(e);
            }
        }
        return tsccOrderToRfqMap;
    }
}
