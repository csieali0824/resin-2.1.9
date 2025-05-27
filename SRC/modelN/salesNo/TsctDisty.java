package modelN.salesNo;

import modelN.DetailColumn;
import modelN.ModelNCommonUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Arrays;
import java.util.HashMap;

public class TsctDisty extends ModelNCommonUtils {

    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.RFQType.getColumnName(), DetailColumn.CustomerPO.getColumnName(),
                DetailColumn.TSC_PN.getColumnName(), DetailColumn.CustomerItem.getColumnName(), DetailColumn.Qty.getColumnName(),
                DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(), DetailColumn.OrderType.getColumnName(),
                DetailColumn.EndCustomerNumber.getColumnName(), DetailColumn.EndCustomer.getColumnName(), DetailColumn.UploadBy.getColumnName()
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
                    detailHeaderHtmlWidthMap.put(columnKey, 10);
                    break;
                case UploadBy:
                    detailHeaderHtmlWidthMap.put(columnKey, 10);
                    break;
                default:
                    break;
            }
        }
    }

    public void setShippingFobOrderTypeInfo() throws SQLException {
        String sql =" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,\n"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,\n"+
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE\n"+
                " ,a.tax_code \n"+
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c \n"+
                " ,SO_PRICE_LISTS d\n"+
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
        while (rs.next())
        {
            if (modelNDto.getShippingMethod().equals("") && rs.getString("ship_via") != null) {
                modelNDto.setShippingMethod(rs.getString("ship_via"));
            }
            if (modelNDto.getFob().equals("") && rs.getString("FOB_POINT")!= null) {
                modelNDto.setFob(rs.getString("FOB_POINT"));
            }
            if (modelNDto.getOrderType().equals("")) {
                if (Arrays.asList(new String[]{"24151", "2989", "23991", "11724", "24851", "26671", "2462"}).contains(modelNDto.getCustNo())) {
                    modelNDto.setOrderType("1131");
                }
            }
        }
        rs.close();
        statement.close();
    }
}
