package modelN.salesNo;

import com.mysql.jdbc.StringUtils;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;

public class TsctDa extends ModelNCommonUtils {

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
                    break;
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
        String sql =" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE"+
                " ,a.tax_code" +
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
                " ,SO_PRICE_LISTS d"+
                " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                " AND b.party_site_id = party_site.party_site_id"+
                " AND loc.location_id = party_site.location_id "+
                " and a.STATUS='A' "+
                " and b.CUST_ACCOUNT_ID ='"+this.modelNDto.getCustId()+"'"+
                " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)";
        if (!modelNDto.getShipToLocationId().equals("")) {
            sql += " and a.LOCATION='" + modelNDto.getShipToLocationId() + "'";
        } else if (modelNDto.getCustNo().equals("14413")) {
            if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0,9).equals("CCPG01518")) ||
                  (modelNDto.getCustPo().length() >= 10 && modelNDto.getCustPo().substring(0,10).equals("CCPF2300TB"))) &&
                    modelNDto.getCustPo().equals("1214")) {
                sql +=" and a.site_use_id = 50156";
            } else if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0,9).equals("CCPG01511")) ||
                         (modelNDto.getCustPo().length() >= 10 && (modelNDto.getCustPo().substring(0,10).equals("CCPM121002") ||
                           modelNDto.getCustPo().substring(0,10).equals("CCPF2301TB")))) &&
                            modelNDto.getCustPo().equals("1214")) {
                sql +=" and a.site_use_id = 61410";
            } else if (modelNDto.getCustPo().substring(0,3).equals("CCP")) {
                sql +=" and a.site_use_id = 50156";
            } else if (modelNDto.getCustPo().substring(0,3).equals("TPH")) {
                sql +=" and a.site_use_id =65370";
            } else if (modelNDto.getCustPo().substring(0,3).equals("FLC")) {
                sql +=" and a.site_use_id = 65370";
            } else {
                sql +=" and a.site_use_id = 31918";
            }
        } else if (modelNDto.getCustNo().equals("1671")) {
            sql +=" and a.site_use_id = 4520";
        } else if (modelNDto.getCustNo().equals("1067")) {
            sql +=" and a.site_use_id = 1328";
        } else if (modelNDto.getCustNo().equals("24051")) {
            if (modelNDto.getCustNo().substring(0,3).equals("CIF") && modelNDto.getOrderType().equals("1141")) {
                sql +=" and a.site_use_id = 56522";
            } else {
                sql +=" and a.site_use_id = 52174";
            }
        } else {
            sql += " and a.PRIMARY_FLAG='Y'";
        }
        sql +=" order by case when upper(a.site_use_code)='BILL_TO' then 2 when upper(a.site_use_code)='SHIP_TO' then 1 else 3 end ";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
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
            if (modelNDto.getOrderType().equals("1141") && ! rs.getString("CURRENCY_CODE").equals("USD")) {
                modelNDto.setOrderType("1131");
            }
            if (rs.getString("SITE_USE_CODE").equals("SHIP_TO")) {
                modelNDto.setShipToOrgId(rs.getString("SITE_USE_ID"));
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
            ResultSet rs = this.getFndLookupValuesData();
            if (!rs.isBeforeFirst()) rs.beforeFirst();
            while (rs.next()) {
                if (rs.getString("MEANING").equals(modelNDto.getTransportation())) {
                    modelNDto.setShippingMethod(rs.getString("LOOKUP_CODE"));
                    break;
                }
            }
            if (modelNDto.getShippingMethod().equals("")) {
                String transportation = modelNDto.getTransportation().equals("") ? "" : modelNDto.getTransportation();
                errList.add("" + ErrorMessage.TRANSPORTATION_IS_NOT_DIFINED.getMessageFormat(transportation));
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
            if (!rs.isBeforeFirst()) rs.beforeFirst();
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

    public void setExtraRuleInfo() {
        if (groupByType.equals("byCustPo")) {
            if (!modelNDto.getShipToLocationId().equals("")) {
                modelNDto.setShipToOrgId(modelNDto.getShipToOrgId());
            } else if (modelNDto.getCustNo().equals("14413")) {  // DELTA 特殊邏輯
                if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0, 9).equals("CCPG01518")) ||
                      (modelNDto.getCustPo().length() >= 10 && modelNDto.getCustPo().substring(0, 10).equals("CCPF2300TB"))) &&
                       modelNDto.getOrderTypeId().equals("1342")) {
                    modelNDto.setShipToOrgId("50156");
                } else if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0, 9).equals("CCPG01511")) ||
                            (modelNDto.getCustPo().length() >= 10 && (modelNDto.getCustPo().substring(0, 10).equals("CCPM121002") || modelNDto.getCustPo().substring(0, 10).equals("CCPF2300TB")))) && modelNDto.getOrderTypeId().equals("1342")) {
                    modelNDto.setShipToOrgId("61410");
                } else if (modelNDto.getCustPo().substring(0, 3).equals("CCP")) {
                    modelNDto.setShipToOrgId("50156");
                } else if (modelNDto.getCustPo().substring(0, 3).equals("TPH")) {
                    modelNDto.setShipToOrgId("65370");
                } else {
                    modelNDto.setShipToOrgId("31918");
                }
            } else if (modelNDto.getCustNo().equals("1671")) {
                modelNDto.setShipToOrgId("4520");
            } else if (modelNDto.getCustNo().equals("1067")) {
                modelNDto.setShipToOrgId("1328");
            } else if (modelNDto.getCustNo().equals("24051")) {
                if (modelNDto.getCustPo().substring(0, 3).equals("CIF") && modelNDto.getOrderType().equals("1141")) {
                    modelNDto.setShipToOrgId("56522");
                } else {
                    modelNDto.setShipToOrgId("52174");
                }
            }
        }
    }
}
