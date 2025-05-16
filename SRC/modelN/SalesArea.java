package modelN;

import java.util.Objects;

public enum SalesArea {
    TSCCSH("002"),
    TSCK("004"),
    TSCTDA("005"),
    TSCTDISTY("006"),
    TSCA("008"),
    TSCR("009");
    private final String salesNo;

    SalesArea(String salesNo) {
        this.salesNo = salesNo;
    }

    public String getSalesNo() {
        return salesNo;
    }

    public static SalesArea fromSalesNo(String salesNo) {
        for (SalesArea salesArea : SalesArea.values()) {
            if (Objects.equals(salesArea.getSalesNo(), salesNo)) {
                return salesArea;
            }
        }
        throw new IllegalArgumentException("錯誤的業務區代碼: " + salesNo);
    }
}
