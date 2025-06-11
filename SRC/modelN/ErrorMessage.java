package modelN;

public enum ErrorMessage {

    CUSTNO_REQUEST("Customer Number為必填欄位"),
    CUSTPO_REQUEST("Customer PO為必填欄位"),
    TSC_PN_REQUEST("TSC P/N為必填欄位"),
    CRD_REQUEST("CRD為必填欄位"),
    SSD_REQUEST("SSD為必填欄位"),
    CRD_LENGTH_LESS_8("CRD欄位值長度小於8"),
    SSD_LENGTH_LESS_8("SSD欄位值長度小於8"),
    CUSTNO_NOTNULL("客戶代號不可空白"),
    CUSTPO_NOTNULL("Customer PO不可空白"),
    TSC_ITEM_AND_TSC_ITEM_PN_AND_CUST_ITEM_NOTNULL("台半料號/品名及客戶料號不可同時空白"),
    INPUT_CUST_PN("非SHANGHAI GREAT客戶必須輸入Customer P/N"),
    CUSTNO_NOT_FOUND_ERP("ERP查無客戶資訊"),
    PENDING_DETAIL_EXISTS_CUSTNO("Pending Detail已存在此客戶+PO資料!"),
    END_CUSTID_FOUND_ERP("End Customer ID不存在ERP"),
    CUST_PN_NOT_FOUND_ERP("客戶料號在ERP不存在!"),
    TSC_PN_NOT_FOUND_ERP("台半料號在ERP不存在!"),
    TSC_PN_MORE_THAN_ONE("對應的台半料號超過一個以上,請選擇正確台半料號"),
    ORDER_TYPE_ID_ERROR("訂單類型錯誤"),
    QTY_NOTNULL("數量不可空白"),
    QTY_MUST_GREATER_0("數量必須大於零"),
    QTY_FORMAT_ERROR("數量格式錯誤"),
    SELLING_PRICE_NOTNULL("Selling Price不可空白"),
    SELLING_PRICE_MUST_GREATER_0("Selling Price必須大於零"),
    SELLING_PRICE_NOT_MATCH_QUOTE_PRICE("Selling Price not match quote price(%s)"),
    SELLING_PRICE_FORMAT_ERROR("單價格式錯誤"),
    FOB_IS_NOTNULL("FOB不可空白"),
    FOB_IS_NOT_EXISTS("FOB不存在"),
    SHIPPING_METHOD_IS_NOTNULL("出貨方式不可空白"),
    SHIPPING_METHOD_IS_NOT_EXISTS("出貨方式不存在"),
    TRANSPORTATION_IS_NOT_DIFINED("運輸方式未定義(%s)"),
    SSD_IS_NOTNULL("SSD不可空白"),
    SSD_MUST_GREATER("SSD必須大於(%s)"),
    CRD_IS_NOTNULL("CRD不可空白"),
    CRD_MUST_GREATER("CRD必須大於(%s)"),
    CRD_MUST_GREATER_OR_EQUALS_SYS_DATE("CRD日期必須大於或等於系統日"),
    CRD_DATE_ERROR("CRD日期格式錯誤(正確格式=MM/DD/YY)"),
    BI_REGION_IS_NOTNULL("BI Region不可空白"),
    BI_REGION_MUST("BI Region必須為(%s)"),
    END_CUSTNO_NOT_SAME_CUSTNO("End Customer Number不可與Customer Number相同"),
    CHOOSE_END_CUSTNAME_OR_END_CUSTNO("End Customer Name與End Customer Number請擇一輸入"),
    INPUT_CUSTPO_LINE_NO("請輸入customer po line number"),
    INPUT_CUSTPO_NO("請輸入customer po number"),
    CONFIRM_TSCA_SALES_ORDER("查無對應TSCA銷售訂單,請確認CUST PO是否正確"),
    QTY_MUST_SPQ_K("數量必須是SPQ(%s K)的倍數"),
    QTY_MUST_GREATER_OR_EQUALS_MOQ_K("數量必須大於或等於MOQ(%s K)的倍數"),
    NOT_CREATE_SPQ_MOQ("SPQ/MOQ資訊未建立,請通知PC同仁建立"),
    QUOTE_NOT_FOUND("Quote not found"),
    QUOTE_HAS_EXPIRED("Quote has expired(%s)"),
    SHIPPING_METHOD_NOT_FOUND("%s not found!"),
    FOB_INCOTERM_NOT_FOUND("%s not found!"),
    DATE_FORMATTER_ERROR("%s，日期格式不正確，應為 YYYY/MM/DD");
    private final String message;

    ErrorMessage(String errorMessage) {
        this.message = errorMessage;
    }

    // 取得錯誤訊息
    public String getMessage() {
        return message;
    }

    // 取得帶參數的錯誤訊息
    public String getMessageFormat(String parameter) {
        return String.format(message, parameter);
    }
}
