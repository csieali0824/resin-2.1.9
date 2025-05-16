package modelN;

import java.util.Objects;

public enum ExcelColumn {
    CustomerNumber("Customer Number"),
    OrderType("Order Type"),
    CustomerPO("Customer PO"),
    CustomerPOLineNumber("Customer PO Line Number"),
    _22D30D("22D/30D"),
    TSC_PN("TSC P/N"),
    CustomerItem("Customer Item"),
    Customer_PN("Customer P/N"),
    Qty("Qty(KPCS)"),
    SellingPrice("Selling Price"),
    CRD("CRD"),
    SSD("SSD"),
    ShippingMethod("Shipping Method"),
    FOB("FOB(incoterm)"),
    Remarks("Remarks"),
    EndCustomerNumber("End Customer Number"),
    EndCustomerName("End Customer Name"),
    QuoteNumber("Quote Number"),
    SupplierID("Supplier ID"),
    ShipToLocationID("Ship To Location ID"),
    ShipToOrgID("Ship To Org ID"),
    BIRegion("BI Region"),
    IgnoreCOO("Ignore COO");

    private final String columnName;
    ExcelColumn(String columnName) {
        this.columnName = columnName;
    }

    public static ExcelColumn settingExcelColumn(String columnName, int position) {
        for (ExcelColumn column : ExcelColumn.values()) {
            if (Objects.equals(column.getColumnName(), columnName)) {
                return column;
            }
        }
        throw new IllegalArgumentException("Excel²Ä" + (position + 1) + "Äæ¦WºÙ¿ù»~:" + columnName);
    }

    public String getColumnName() {
        return columnName;
    }
}
