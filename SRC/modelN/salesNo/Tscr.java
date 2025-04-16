package modelN.salesNo;

import com.mysql.jdbc.StringUtils;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;

public class Tscr extends ModelNCommonUtils {

    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[]{
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

    public void setCrd() {
        //ÀË¬dCRD
        if (StringUtils.isNullOrEmpty(modelNDto.getCrd())) {
            modelNDto.setCrd("");
            if (!modelNDto.getCrd().equals("")) {
                errList.add(ErrorMessage.CRD_IS_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            }
        } else if (Long.parseLong(modelNDto.getCrd()) <= Long.parseLong(checkDate)) {
            errList.add(ErrorMessage.CRD_MUST_GREATER.getMessageFormat(checkDate));
            modelNDto.setErrorList(errList);
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

    public void setShippingMethod() throws SQLException {
        if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
            modelNDto.setShippingMethod("");
            errList.add(ErrorMessage.SHIPPING_METHOD_IS_NOTNULL.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            ResultSet rs = this.getAsoShippingMethodsV();
            boolean shippingMethodExist = false;
            if (!rs.isBeforeFirst()) rs.beforeFirst();
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
}
