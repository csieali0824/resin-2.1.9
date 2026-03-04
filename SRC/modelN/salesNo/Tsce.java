package modelN.salesNo;

import com.mysql.jdbc.StringUtils;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;

import java.sql.*;
import java.util.HashMap;

public class Tsce extends ModelNCommonUtils {

    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.RFQType.getColumnName(), DetailColumn.CustomerPO.getColumnName(),
                DetailColumn.TSC_PN.getColumnName(), DetailColumn.CustomerItem.getColumnName(), DetailColumn.Qty.getColumnName(),
                DetailColumn.SellingPrice.getColumnName(), DetailColumn.CRD.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.OrderType.getColumnName(), DetailColumn.FOB.getColumnName(), DetailColumn.ShippingMethod.getColumnName(),
                DetailColumn.UploadBy.getColumnName()
        };
    }

    public void setDetailHeaderHtmlWidth() throws Exception {
        detailHeaderHtmlWidthMap = new HashMap();
        for (int i = 0, n= detailHeaderColumns.length; i < n; i++) {
            String columnKey = detailHeaderColumns[i];
            switch (DetailColumn.settingDetailColumn(columnKey, i)) {
                case CustomerName:
                    detailHeaderHtmlWidthMap.put(columnKey, 18);
                    break;
                case RFQType:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case CustomerPO:
                    detailHeaderHtmlWidthMap.put(columnKey,10);
                    break;
                case TSC_PN:
                    detailHeaderHtmlWidthMap.put(columnKey, 10);
                    break;
                case CustomerItem:
                    detailHeaderHtmlWidthMap.put(columnKey, 9);
                    break;
                case Qty:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case SellingPrice:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case CRD:
                    detailHeaderHtmlWidthMap.put(columnKey,6);
                    break;
                case SSD:
                    detailHeaderHtmlWidthMap.put(columnKey,6);
                    break;
                case OrderType:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case FOB:
                    detailHeaderHtmlWidthMap.put(columnKey, 10);
                    break;
                case ShippingMethod:
                    detailHeaderHtmlWidthMap.put(columnKey, 10);
                    break;
                case UploadBy:
                    detailHeaderHtmlWidthMap.put(columnKey, 8);
                    break;
                default:
                    break;
            }
        }
    }
    public void setShippingFobOrderTypeInfo() throws SQLException {
        String sql = "";

        if (!StringUtils.isNullOrEmpty(modelNDto.getDeliveryId())) {
            String shipToOrgId = modelNDto.getShipToOrgId();
            String shipToLocationId = modelNDto.getShipToLocationId();

            sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,\n" +
                    " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,\n" +
                    " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,d.CURRENCY_CODE\n" +
                    ",a.tax_code \n" +
                    " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d\n" +
                    " where  a.ADDRESS_ID = b.cust_acct_site_id\n" +
                    " AND b.party_site_id = party_site.party_site_id\n" +
                    " AND loc.location_id = party_site.location_id \n" +
                    " and a.STATUS='A' \n" +
                    " and b.CUST_ACCOUNT_ID ='" + modelNDto.getCustId() + "'\n" +
                    " and a.PAYMENT_TERM_ID = c.TERM_ID(+)\n" +
                    " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)\n" +
                    " and (\n" +
                    "(a.SITE_USE_CODE = 'SHIP_TO' AND (\n" +
                    "        -- 情況 1: 傳入了 Location ID (不為空)，則比對 location\n" +
                    "        ( '" + shipToLocationId + "' IS NOT NULL AND a.location = '"+ shipToLocationId + "' )\n" +
                    "        OR\n" +
                    "        -- 情況 2: Location ID 為空，則改為比對 SITE_USE_ID\n" +
                    "        ( '" + shipToLocationId + "' IS NULL AND a.SITE_USE_ID = '"+ shipToOrgId + "' )\n" +
                    "    ))\n" +
                    "    OR (a.SITE_USE_CODE='BILL_TO' AND a.PRIMARY_FLAG='Y')\n" +
                    "    OR (a.SITE_USE_CODE='DELIVER_TO' AND a.location='" + modelNDto.getDeliveryId() + "')\n" +
                    " )";
        } else {
            sql =" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno, \n"+
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1, \n"+
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE \n"+
                " ,a.tax_code \n"+
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c \n"+
                " ,SO_PRICE_LISTS d \n"+
                " where  a.ADDRESS_ID = b.cust_acct_site_id \n"+
                " AND b.party_site_id = party_site.party_site_id \n"+
                " AND loc.location_id = party_site.location_id \n"+
                " and a.STATUS='A' \n"+
                " and a.PRIMARY_FLAG='Y' \n"+
                " and b.CUST_ACCOUNT_ID ='"+modelNDto.getCustId()+"' \n"+
                " and a.PAYMENT_TERM_ID = c.TERM_ID(+) \n"+
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+) \n"+
                " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end ";
        }

        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        ResultSet lookValuesRs = this.getFndLookupValuesData();
        while (rs.next())
        {
            if (modelNDto.getShippingMethod().equals("") && rs.getString("ship_via") != null) {
                if (!lookValuesRs.isBeforeFirst()) lookValuesRs.beforeFirst();
                while (lookValuesRs.next())
                {
                    if (lookValuesRs.getString("LOOKUP_CODE").equals(rs.getString("ship_via"))) {
                        modelNDto.setShippingMethod(rs.getString("ship_via"));
                        modelNDto.setTransportation(lookValuesRs.getString("MEANING"));
                        break;
                    }
                }
            }

            if (StringUtils.isNullOrEmpty(modelNDto.getFob()) && !StringUtils.isNullOrEmpty(rs.getString("FOB_POINT"))) {
                modelNDto.setFob(rs.getString("FOB_POINT"));
            }

            if (rs.getString("SITE_USE_CODE").equals("SHIP_TO")) {
                modelNDto.setShipToOrgId(rs.getString("SITE_USE_ID"));
            } else if (rs.getString("SITE_USE_CODE").equals("DELIVER_TO")) {
                modelNDto.setDeliveryId(rs.getString("SITE_USE_ID"));
            }
        }
        rs.close();
        statement.close();
    }

    public void setShippingMethod() throws SQLException {

        if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
            String tscCategorySql = " select description, TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE, " +
                    " TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY " +
//                " tsc_get_item_coo(a.inventory_item_id)coo "+
                    " from APPS.MTL_SYSTEM_ITEMS A WHERE A.ORGANIZATION_ID=43" +
                    " and a.segment1= ? ";

            try (PreparedStatement tscCategoryStmt = conn.prepareStatement(tscCategorySql)) {
                tscCategoryStmt.setString(1, modelNDto.getTscItem());

                try (ResultSet rs = tscCategoryStmt.executeQuery()) {
                    while (rs.next()) {
                        CallableStatement cs = conn.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}");
                        cs.setString(1, "001");
                        cs.setString(2, rs.getString("TSC_PACKAGE"));
                        cs.setString(3, rs.getString("TSC_FAMILY"));
                        cs.setString(4, rs.getString("description"));
                        cs.setString(5, modelNDto.getCrd());
                        cs.registerOutParameter(6, Types.VARCHAR);
                        cs.setString(7, modelNDto.getOrderType());
                        cs.setString(8, modelNDto.getManuFactoryNo());
                        cs.setString(9, modelNDto.getCustId());   //add by Peggy 20160513
                        cs.setString(10, modelNDto.getFob());       //add by Peggy 20190319
                        cs.setString(11, modelNDto.getDeliveryId());       //add by Peggy 20190319
                        cs.execute();
                        modelNDto.setShippingMethod(cs.getString(6));
                        cs.close();
                    }
                }
            }

            if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
                modelNDto.setShippingMethod("");
                errList.add(ErrorMessage.SHIPPING_METHOD_IS_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                ResultSet rs = this.getFndLookupValuesData();
                if (!rs.isBeforeFirst()) rs.beforeFirst();
                while (rs.next()) {
                    if (rs.getString("MEANING").equals(modelNDto.getShippingMethod())) {
                        modelNDto.setShippingMethod(rs.getString("LOOKUP_CODE"));
                        break;
                    }
                }
                if (modelNDto.getShippingMethod().equals("")) {
                    String transportation = modelNDto.getTransportation().equals("") ? "" : modelNDto.getTransportation();
                    errList.add(ErrorMessage.TRANSPORTATION_IS_NOT_DIFINED.getMessageFormat(transportation));
                    modelNDto.setErrorList(errList);
                }
            }
        }
    }

    public void setExtraRuleInfo() throws SQLException {

        if (!StringUtils.isNullOrEmpty(modelNDto.getCustId())) {

            String sql = "SELECT 1 FROM ORADDMAN.tscust_special_setup WHERE sales_area_no = ? \n"+
                    "AND customer_id= ? and active_flag='A' \n"+
                    " UNION ALL \n"+
                    "SELECT 1 FROM TSC_EDI_CUSTOMER \n" +
                    "WHERE SALES_AREA_NO = ? and (INACTIVE_DATE IS NULL OR INACTIVE_DATE > TRUNC(SYSDATE)) \n"+
                    "AND customer_id= ?";

            try (PreparedStatement custStmt = conn.prepareStatement(sql)) {
                custStmt.setString(1, modelNDto.getSalesNo());
                custStmt.setString(2, modelNDto.getCustId());
                custStmt.setString(3, modelNDto.getSalesNo());
                custStmt.setString(4, modelNDto.getCustId());

                try (ResultSet custRs = custStmt.executeQuery()) {
                    while (custRs.next()) {
                        if (StringUtils.isNullOrEmpty(modelNDto.getCustPoLineNo())) {
                            errList.add(ErrorMessage.CUSTPO_LINE_NO.getMessageFormat(modelNDto.getCustId()));
                            modelNDto.setErrorList(errList);
                        }
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    throw new IllegalArgumentException(e.getMessage());
                }
            }
        }

        String salesNo = modelNDto.getSalesNo();
        String coo = modelNDto.getCoo();
        String factoryCode = modelNDto.getManuFactoryNo();
        String crd = modelNDto.getCrd();
        String shippingMethod = modelNDto.getShippingMethod();
        String orderType = modelNDto.getOrderType();
        String custId = modelNDto.getCustId();
        String fob = modelNDto.getFob();
        String deliveryId = modelNDto.getDeliveryId();

        String getSsd = coo.equals("CN")?
                "select GET_TSCE_PMD_SSD(?, ?, ?, ?, ?, ?, TRUNC(SYSDATE), ?, ?, ?) as SSD from dual" :
                "select tsc_edi_pkg.GET_TSCE_ORDER_SSD(?, ?, ?, ?, ?, ?, TRUNC(SYSDATE), ?, ?) as SSD from dual";

        try (PreparedStatement ssdStmt = conn.prepareStatement(getSsd)) {
            ssdStmt.setString(1, salesNo);
            ssdStmt.setString(2, factoryCode);
            ssdStmt.setString(3, crd);
            ssdStmt.setString(4, shippingMethod);
            ssdStmt.setString(5, orderType);
            ssdStmt.setString(6, custId);
            ssdStmt.setString(7, fob);
            ssdStmt.setString(8, deliveryId);
            if (coo.equals("CN")) {
                ssdStmt.setString(9, coo);
            }

            try (ResultSet rs = ssdStmt.executeQuery()) {
                while (rs.next()) {
                    String ssd = rs.getString("SSD");
                    if (!StringUtils.isNullOrEmpty(ssd)) {
                        try {
                            modelNDto.setSsd(ssd);
                        } catch (Exception e) {
                            e.printStackTrace();
                            throw new IllegalArgumentException(ErrorMessage.DATE_FORMATTER_ERROR.getMessageFormat(ssd));
                        }
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                throw new IllegalArgumentException(e.getMessage());
            }
        }
    }
}
