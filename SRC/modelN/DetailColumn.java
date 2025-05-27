package modelN;

import java.util.Objects;

public enum DetailColumn {
    DeleteAll("Delete All"),
    CustomerName("Customer Name"),
    RFQType("RFQ Type"),
    CustomerPO("Customer PO"),
    TSC_PN("TSC P/N"),
    CustomerItem("Customer Item"),
    Customer_PN("Customer P/N"),
    Qty("Qty"),
    SellingPrice("Selling Price"),
    CRD("CRD"),
    SSD("SSD"),
    ShippingMethod("Shipping Method"),
    FOB("FOB"),
    OrderType("Order Type"),
    EndCustomerNumber("End Customer Number"),
    EndCustomer("End Customer"),
    EndCust("End Cust"),
    ShipTo("Ship to"),
    ShipToId("Ship to ID"),
    UploadBy("Upload By"),
    UploadDate("Upload Date"),
    GroupBy("Group By");

    private final String columnName;
    DetailColumn(String columnName) {
        this.columnName = columnName;
    }

    public static DetailColumn settingDetailColumn(String columnName, int position) {
        for (DetailColumn column : DetailColumn.values()) {
            if (Objects.equals(column.getColumnName(), columnName)) {
                return column;
            }
        }
        throw new IllegalArgumentException("Detail第" + (position + 1) + "欄位的名稱設定錯誤:" + columnName);
    }

    public String getColumnName() {
        return columnName;
    }
}
