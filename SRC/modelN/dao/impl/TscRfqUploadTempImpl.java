package modelN.dao.impl;

import modelN.dto.DetailDto;
import modelN.dto.ModelNDto;

import java.sql.*;
import java.util.Date;
import java.util.*;

public class TscRfqUploadTempImpl implements TscRfqUploadTempDao {

    @Override
    public void setPolicyContext(Connection conn) throws SQLException {
        String sql = "alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.executeUpdate();
        pstmt.close();

        CallableStatement cs = conn.prepareCall(
                "{call mo_global.set_policy_context('S',?)}");
        cs.setString(1, "41");  // 取業務員隸屬ParOrgID
        cs.execute();
        cs.close();
    }

    @Override
    public Map getTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy, String customerNo, String customerPo, String groupByType, String shipToOrgId) throws SQLException {
        String sql = "select a.salesareano, to_char(a.upload_date,'yyyy/mm/dd') upload_date, a.upload_by, a.customer_no, a.customer_id,\n" +
                "a.customer_name,a.rfq_type, UTL_I18N.UNESCAPE_REFERENCE(a.customer_po) customer_po, b.description, b.segment1,\n" +
                "a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date as ssd, b.PRIMARY_UOM_CODE uom,a.crd, a.factory,\n" +
                "a.shipping_method,a.fob, a.remarks, d.OTYPE_ID as order_type_id, d.ORDER_NUM order_type, a.line_type, \n" +
                "UTL_I18N.UNESCAPE_REFERENCE(a.customer_po_line_number) customer_po_line_number,e.customer_number end_customer_number,\n" +
                "a.end_customer, a.quote_number, a.temp_id, nvl(a.ship_to_org_id,0) ship_to_org_id, a.bi_region, a.org_so_line_id, a.groupby_type, \n" +
                "(select count(1) from oraddman.tsc_rfq_upload_temp c \n" +
                "  where c.create_flag='N' \n" +
                "   and c.salesareano=a.salesareano \n" +
                "   and c.customer_no=a.customer_no \n" +
                "   and c.customer_po=a.customer_po \n" +
                "   and nvl(c.ship_to_org_id,0)= nvl (a.ship_to_org_id,0) \n" +
                "   and c.upload_by=a.upload_by) rowcnt \n" +
                " FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d, ar_customers e \n" +
                " where a.create_flag=? \n" +
                "   and a.salesareano=? \n" +
                "   and b.organization_id=43 \n" +
                "   and a.inventory_item_id = b.inventory_item_id \n" +
                "   and a.customer_no = nvl(?, a.customer_no) \n" +
                "   and a.customer_po = nvl(?, a.customer_po) \n" +
                "   and nvl(a.ship_to_org_id,0) = nvl(?, nvl(a.ship_to_org_id,0)) \n" +
                "   and a.upload_by = nvl(?, a.upload_by) \n" +
                "   and a.salesareano=d.SAREA_NO \n" +
                "   and a.order_type=d.OTYPE_ID \n" +
                "   and a.end_customer_id=e.customer_id(+) \n" +
                "   order by a.line_no,to_number(a.customer_no),a.customer_po,b.description";

        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "N");
        pstmt.setString(2, salesNo);
        pstmt.setString(3, customerNo);
        pstmt.setString(4, Arrays.asList(new String[]{"byCustNo", null, ""}).contains(groupByType) ? null : customerPo);
        pstmt.setString(5, Arrays.asList(new String[]{"byCustNo", null, ""}).contains(groupByType) ? null : shipToOrgId);
        pstmt.setString(6, uploadBy);
        ResultSet rs = pstmt.executeQuery();
        HashMap detailMap = new LinkedHashMap();
        int rsRowCount = 0;
        while (rs.next()) {
            rsRowCount++;
            DetailDto detailDto = new DetailDto();
            detailDto.setTscItem(rs.getString("segment1"));
            detailDto.setSalesNo(rs.getString("salesareano"));
            detailDto.setCustomerNo(rs.getString("customer_no"));
            detailDto.setCustomerId(rs.getString("customer_id"));
            detailDto.setCustomerName(rs.getString("customer_name"));
            detailDto.setRfqType(rs.getString("rfq_type"));
            detailDto.setCustomerPo(rs.getString("customer_po"));
            detailDto.setDescription(rs.getString("description"));
            detailDto.setCustItemName(rs.getString("cust_item_name"));
            detailDto.setUom(rs.getString("uom"));
            detailDto.setQty(rs.getString("qty"));
            detailDto.setSellingPrice(rs.getString("selling_price"));
            detailDto.setCrd(rs.getString("crd"));
            detailDto.setSsd(rs.getString("ssd"));
            detailDto.setManuFactoryNo(rs.getString("factory"));
            detailDto.setShippingMethod(rs.getString("shipping_method"));
            detailDto.setFobIncoterm(rs.getString("fob"));
            detailDto.setRemarks(rs.getString("remarks"));
            detailDto.setOrderTypeId(rs.getString("order_type_id"));
            detailDto.setOrderType(rs.getString("order_type"));
            detailDto.setLineType(rs.getString("line_type"));
            detailDto.setCustomerPoLineNumber(rs.getString("customer_po_line_number"));
            detailDto.setRowCount(rs.getString("rowcnt"));
            detailDto.setEndCustomerNumber(rs.getString("end_customer_number"));
            detailDto.setShipToOrgId(rs.getString("ship_to_org_id"));
//            detailDto.setEndCustId(rs.getString("end_customer_id"));
            detailDto.setEndCustomer(rs.getString("end_customer"));
            detailDto.setQuoteNumber(rs.getString("quote_number"));
            detailDto.setTempId(rs.getString("temp_id"));
            detailDto.setBiRegion(rs.getString("bi_region"));
            detailDto.setUploadDate(rs.getString("upload_date"));
            detailDto.setUploadBy(rs.getString("upload_by"));
            detailDto.setOrgSoLineId(rs.getString("org_so_line_id"));
            detailDto.setGroupByType(rs.getString("groupby_type"));
            detailMap.put(rsRowCount, detailDto);
        }
        pstmt.close();
        rs.close();
        return detailMap;
    }

    @Override
    public void deleteTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy, String customerId, String customerPo, String groupByType, String shipToOrgId) throws SQLException {
        try {
            String sql = "delete oraddman.tsc_rfq_upload_temp \n" +
                         "where customer_id = ? \n" +
                         "and customer_po = nvl(?, customer_po) \n " +
                         " and nvl(ship_to_org_id,0) = nvl(?, nvl(ship_to_org_id,0)) \n" +
                         "and upload_by = ? \n " +
                         "and salesareano = ? ";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, customerId);
            // 如果是byPo的話，則須卡 customerPo 當 delete 的條件
            pstmt.setString(2, Arrays.asList(new String[]{"byCustNo", null, ""}).contains(groupByType) ? null : customerPo);
            pstmt.setString(3, Arrays.asList(new String[]{"byCustNo", null, ""}).contains(groupByType) ? null : shipToOrgId);
            pstmt.setString(4, uploadBy);
            pstmt.setString(5, salesNo);
            pstmt.executeUpdate();
            pstmt.close();
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        }
    }

    @Override
    public void deleteAllTscRfqUploadTemp(Connection conn, String salesNo, String uploadBy) throws SQLException {
        try {
            String sql = "delete oraddman.tsc_rfq_upload_temp \n"+
                         "where  salesareano = ? \n" +
                         "and  upload_by = ? ";

            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1,salesNo);
            pstmt.setString(2,uploadBy);
            pstmt.executeUpdate();
            pstmt.close();
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        }
    }

    @Override
    public void insertTscRfqUploadTemp(Connection conn, HashMap map, String salesNo, String userName, String rfqType, String groupByType) throws SQLException {

        int insertRowCnt = 0;
        try {
            String tempCustId = "";
            for (Iterator it = map.entrySet().iterator(); it.hasNext(); ) {
                Map.Entry entry = (Map.Entry) it.next();
                ModelNDto modelNDto = (ModelNDto) entry.getValue();
                if (!tempCustId.equals(modelNDto.getCustId())) {
                    tempCustId = modelNDto.getCustId();
                }
                String sql = " insert into oraddman.tsc_rfq_upload_temp(\n " +
                        "salesareano,\n " +        //1
                        "upload_date,\n " +        //2
                        "upload_by,\n " +          //3
                        "customer_no,\n " +        //4
                        "customer_name,\n " +      //5
                        "rfq_type,\n " +           //6
                        "customer_po,\n " +        //7
                        "inventory_item_id,\n " +  //8
                        "cust_item_name,\n " +     //9
                        "qty,\n " +                //10
                        "selling_price,\n " +      //11
                        "crd,\n " +                //12
                        "request_date,\n " +       //13
                        "shipping_method,\n " +    //14
                        "fob,\n " +                //15
                        "remarks,\n " +            //16
                        "order_type,\n " +         //17
                        "line_type,\n " +          //18
                        "create_flag,\n " +        //19
                        "customer_id,\n " +        //20
                        "factory,\n " +            //21
                        "customer_po_line_number,\n " + //22
                        "line_no,\n " +            //23
                        "end_customer_id,\n " +    //24
                        "end_customer,\n " +       //25
                        "quote_number,\n " +       //26
                        "ship_to_org_id,\n " +     //27
                        "temp_id,\n " +            //28
                        "bi_region,\n " +          //29
                        "org_so_line_id,\n " +     //30
                        "groupby_type)\n " +       //31
                        " values(\n " +
                        "?,\n " +                  //1
                        "?,\n " +                  //2
                        "?,\n " +                  //3
                        "?,\n " +                  //4
                        "?,\n " +                  //5
                        "?,\n " +                  //6
                        "?,\n " +                  //7
                        "?,\n " +                  //8
                        "?,\n " +                  //9
                        "?,\n " +                  //10
                        "?,\n " +                  //11
                        "?,\n " +                  //12
                        "?,\n " +                  //13
                        "?,\n " +                  //14
                        "?,\n " +                  //15
                        "?,\n " +                  //16
                        "?,\n " +                  //17
                        "?,\n " +                  //18
                        "?,\n " +                  //19
                        "?,\n " +                  //20
                        "?,\n " +                  //21
                        "?,\n " +                  //22
                        "?,\n " +                  //23
                        "?,\n " +                  //24
                        "?,\n " +                  //25
                        "?,\n " +                  //26
                        "?,\n " +                  //27
                        "?,\n " +                  //28
                        "?,\n " +                  //29
                        "?,\n " +                  //30
                        "?)";                      //31

                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, salesNo);
                pstmt.setTimestamp(2, new Timestamp(new Date().getTime()));
                pstmt.setString(3, userName);
                pstmt.setString(4, modelNDto.getCustNo());
                pstmt.setString(5, modelNDto.getCustName());
                pstmt.setString(6, rfqType);
                pstmt.setString(7, modelNDto.getCustPo());
                pstmt.setString(8, modelNDto.getInventoryItemId());
                pstmt.setString(9, (modelNDto.getCustItem().equals("") ? "" : modelNDto.getCustItem()));
                pstmt.setString(10, modelNDto.getQty());
                pstmt.setString(11, modelNDto.getSellingPrice());
                pstmt.setString(12, modelNDto.getCrd());
                pstmt.setString(13, modelNDto.getSsd());
                pstmt.setString(14, modelNDto.getShippingMethod());
                pstmt.setString(15, modelNDto.getFob());
                pstmt.setString(16, modelNDto.getRemarks());
                pstmt.setString(17, modelNDto.getOrderTypeId());
                pstmt.setString(18, modelNDto.getLineType());
                pstmt.setString(19, "N");
                pstmt.setString(20, modelNDto.getCustId());
                pstmt.setString(21, modelNDto.getManuFactoryNo()); // factory
                pstmt.setString(22, modelNDto.getCustPoLineNo()); //customer po line number
                pstmt.setInt(23, (insertRowCnt + 1)); //line_no
                pstmt.setString(24, modelNDto.getEndCustId());
                pstmt.setString(25, modelNDto.getEndCustNamePhonetic()); //end_customer
                pstmt.setString(26, modelNDto.getQuoteNumber()); //end_customer
                pstmt.setString(27, modelNDto.getShipToOrgId());
                pstmt.setString(28, salesNo.equals("002") ? !tempCustId.equals(modelNDto.getCustId()) ? getTempId(conn) : tempCustId : null); // tempId
                pstmt.setString(29, modelNDto.getBiRegion()); //bi_region
                pstmt.setString(30, modelNDto.getOrgSoLineId()); //OrgSoLineId
                pstmt.setString(31, groupByType); //groupByType
                pstmt.executeUpdate();
                pstmt.close();
                insertRowCnt++;
            }
            conn.commit();
        } catch (SQLException e) {
            e.printStackTrace();
            conn.rollback();
        }
    }

    private String getTempId(Connection conn) throws SQLException {
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("select TSC_RFQ_UPLOAD_TEMP_S.nextval from dual");
        String tempId = "";
        if(rs.next())
        {
            tempId = rs.getString(1);
        }
        rs.close();
        stmt.close();
        return tempId;
    }
}
