package modelN.salesNo;

import com.mysql.jdbc.StringUtils;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

public class Tsccsh extends ModelNCommonUtils {

    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.ShipToId.getColumnName(), DetailColumn.RFQType.getColumnName(),
                DetailColumn.CustomerPO.getColumnName(), DetailColumn.TSC_PN.getColumnName(), DetailColumn.Customer_PN.getColumnName(),
                DetailColumn.Qty.getColumnName(), DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.OrderType.getColumnName(), DetailColumn.ShippingMethod.getColumnName(), DetailColumn.FOB.getColumnName(),
                DetailColumn.EndCustomerNumber.getColumnName(), DetailColumn.EndCust.getColumnName(), DetailColumn.UploadBy.getColumnName(),
                DetailColumn.UploadDate.getColumnName()
        };
    }

    public void setDetailHeaderHtmlWidth() throws Exception {
        detailHeaderHtmlWidthMap = new HashMap();
        for (int i = 0, n= detailHeaderColumns.length; i < n; i++) {
            String columnKey = detailHeaderColumns[i];
            switch (DetailColumn.settingDetailColumn(columnKey, i)) {
                case CustomerName:
                    detailHeaderHtmlWidthMap.put(columnKey, 7);
                    break;
                case ShipToId:
                    detailHeaderHtmlWidthMap.put(columnKey, 4);
                    break;
                case RFQType:
                    detailHeaderHtmlWidthMap.put(columnKey,4);
                    break;
                case CustomerPO:
                    detailHeaderHtmlWidthMap.put(columnKey, 7);
                    break;
                case TSC_PN:
                    detailHeaderHtmlWidthMap.put(columnKey, 8);
                    break;
                case Customer_PN:
                    detailHeaderHtmlWidthMap.put(columnKey, 8);
                    break;
                case Qty:
                    detailHeaderHtmlWidthMap.put(columnKey, 4);
                    break;
                case SellingPrice:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case SSD:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case OrderType:
                    detailHeaderHtmlWidthMap.put(columnKey, 4);
                    break;
                case ShippingMethod:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case FOB:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case EndCustomerNumber:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case EndCust:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case UploadBy:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case UploadDate:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                default:
                    break;
            }
        }
    }

    public void setShippingFobOrderTypeInfo() throws SQLException {
        String sql =" select 1 as segno, \n"+
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1, \n"+
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, \n"+
                " a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE, a.tax_code \n"+
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c \n"+
                " ,SO_PRICE_LISTS d \n"+
                " where  a.ADDRESS_ID = b.cust_acct_site_id \n"+
                " AND b.party_site_id = party_site.party_site_id \n"+
                " AND loc.location_id = party_site.location_id \n"+
                " and a.STATUS='A' \n"+
                " and a.site_use_code='SHIP_TO' \n"+
                " and b.CUST_ACCOUNT_ID ='"+modelNDto.getCustId()+"'";
        if (modelNDto.getShipToOrgId() !=null && !modelNDto.getShipToOrgId().equals(""))
        {
            sql += " and (a.SITE_USE_ID='" + modelNDto.getShipToOrgId() + "' or a.location='" + modelNDto.getShipToOrgId() + "')";
        }
        sql += " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
                " order by decode(a.PRIMARY_FLAG,'Y',1,2), a.SITE_USE_ID";

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next())
        {
            if (StringUtils.isNullOrEmpty(modelNDto.getShipToOrgId())) {
                modelNDto.setShipToOrgId(rs.getString("SITE_USE_ID"));
            }
            if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod()) && rs.getString("ship_via") != null) {
                modelNDto.setShippingMethod(rs.getString("ship_via"));
            }
            if (StringUtils.isNullOrEmpty(modelNDto.getFob()) && rs.getString("FOB_POINT") != null) {
                modelNDto.setFob(rs.getString("FOB_POINT"));
            }
        }
        rs.close();
        stmt.close();
    }

    public void setShippingMethod() throws SQLException {
        if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
            modelNDto.setShippingMethod("");
            errList.add(ErrorMessage.SHIPPING_METHOD_IS_NOTNULL.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            ResultSet rs = this.getShippingMethodForTsccsh();
            boolean shippingMethodExist = false;
            if (rs.isBeforeFirst() == false) rs.beforeFirst();
            while (rs.next()) {
                if (rs.getString("SHIPPING_METHOD").equals(modelNDto.getShippingMethod()) ||
                        rs.getString("SHIPPING_METHOD_CODE").equals(modelNDto.getShippingMethod())) {
                    shippingMethodExist = true;
                    modelNDto.setShippingMethod(rs.getString("SHIPPING_METHOD_CODE"));
                    break;
                }
            }
            if (!shippingMethodExist) {
                errList.add(ErrorMessage.SHIPPING_METHOD_IS_NOT_EXISTS.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
    }

    public void setFob() throws SQLException {
        if (StringUtils.isNullOrEmpty(modelNDto.getFob())) {
            modelNDto.setFob("");
            errList.add(ErrorMessage.FOB_IS_NOTNULL.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            ResultSet rs = this.getFobIncotermData();
            boolean fobExist = false;
            if (rs.isBeforeFirst() == false) rs.beforeFirst();
            while (rs.next()) {
                if (rs.getString("FOB").equals(modelNDto.getFob())) {
                    fobExist = true;
                    break;
                }
            }
            if (!fobExist) {
                errList.add(ErrorMessage.FOB_IS_NOT_EXISTS.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
    }
    // ÀË¬d BI Region
    public void setExtraRuleInfo() throws SQLException {
        if (modelNDto.getCustId().equals("15540") || modelNDto.getCustId().equals("14980")) {
            if (StringUtils.isNullOrEmpty(modelNDto.getBiRegion())) {
                errList.add(ErrorMessage.BI_REGION_IS_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                ResultSet rs = this.getBiRegionData();
                boolean biRegionExist = false;
                if (rs.isBeforeFirst() == false) rs.beforeFirst();
                while (rs.next()) {
                    if (rs.getString("A_VALUE").equals(modelNDto.getBiRegion())) {
                        biRegionExist = true;
                        break;
                    }
                }
                if (!biRegionExist) {
                    String biRegion = modelNDto.getBiRegion().equals("") ? "" : modelNDto.getBiRegion();
                    errList.add(ErrorMessage.BI_REGION_MUST.getMessageFormat(biRegion));
                    modelNDto.setErrorList(errList);
                }
            }
        }
    }
}
