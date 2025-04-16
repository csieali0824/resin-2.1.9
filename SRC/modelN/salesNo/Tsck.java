package modelN.salesNo;

import com.mysql.jdbc.StringUtils;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

public class Tsck extends ModelNCommonUtils {

    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.RFQType.getColumnName(), DetailColumn.CustomerPO.getColumnName(),
                DetailColumn.TSC_PN.getColumnName(), DetailColumn.CustomerItem.getColumnName(), DetailColumn.Qty.getColumnName(),
                DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(), DetailColumn.OrderType.getColumnName(),
                DetailColumn.EndCustomerNumber.getColumnName(), DetailColumn.EndCustomer.getColumnName(), DetailColumn.ShipTo.getColumnName(),
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
                case SSD:
                    detailHeaderHtmlWidthMap.put(columnKey,6);
                    break;
                case OrderType:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case EndCustomerNumber:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case EndCustomer:
                    detailHeaderHtmlWidthMap.put(columnKey, 8);
                case ShipTo:
                    detailHeaderHtmlWidthMap.put(columnKey, 4);
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
        String sql =" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno, \n"+
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
            if (modelNDto.getFob().equals("") && rs.getString("FOB_POINT")!= null) {
                modelNDto.setFob(rs.getString("FOB_POINT"));
            }
        }
        rs.close();
        statement.close();
    }

    public void setShippingMethod() throws SQLException {
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

    public void setExtraRuleInfo() {
        if (!StringUtils.isNullOrEmpty(modelNDto.getShipToLocationId())) {
            modelNDto.setShipToOrgId(modelNDto.getShipToOrgId());
        } else {
            if (modelNDto.getCustNo().equals("16163")) {
                modelNDto.setShipToOrgId("64112");
            } else if (modelNDto.getCustNo().equals("26892")) {
                modelNDto.setShipToOrgId("66170");
            }
        }
    }
}
