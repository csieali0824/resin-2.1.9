package modelN;

public enum ErrorMessage {

    CUSTNO_REQUEST("Customer Number���������"),
    CUSTPO_REQUEST("Customer PO���������"),
    TSC_PN_REQUEST("TSC P/N���������"),
    CRD_REQUEST("CRD���������"),
    SSD_REQUEST("SSD���������"),
    CRD_LENGTH_LESS_8("CRD���Ȫ��פp��8"),
    SSD_LENGTH_LESS_8("SSD���Ȫ��פp��8"),
    CUSTNO_NOTNULL("�Ȥ�N�����i�ť�"),
    CUSTPO_NOTNULL("Customer PO���i�ť�"),
    TSC_ITEM_AND_TSC_ITEM_PN_AND_CUST_ITEM_NOTNULL("�x�b�Ƹ�/�~�W�ΫȤ�Ƹ����i�P�ɪť�"),
    INPUT_CUST_PN("�DSHANGHAI GREAT�Ȥᥲ����JCustomer P/N"),
    CUSTNO_NOT_FOUND_ERP("ERP�d�L�Ȥ��T"),
    PENDING_DETAIL_EXISTS_CUSTNO("Pending Detail�w�s�b���Ȥ�+PO���!"),
    END_CUSTID_FOUND_ERP("End Customer ID���s�bERP"),
    CUST_PN_NOT_FOUND_ERP("�Ȥ�Ƹ��bERP���s�b!"),
    TSC_PN_NOT_FOUND_ERP("�x�b�Ƹ��bERP���s�b!"),
    TSC_PN_MORE_THAN_ONE("�������x�b�Ƹ��W�L�@�ӥH�W,�п�ܥ��T�x�b�Ƹ�"),
    ORDER_TYPE_ID_ERROR("�q���������~"),
    QTY_NOTNULL("�ƶq���i�ť�"),
    QTY_MUST_GREATER_0("�ƶq�����j��s"),
    QTY_FORMAT_ERROR("�ƶq�榡���~"),
    SELLING_PRICE_NOTNULL("Selling Price���i�ť�"),
    SELLING_PRICE_MUST_GREATER_0("Selling Price�����j��s"),
    SELLING_PRICE_NOT_MATCH_QUOTE_PRICE("Selling Price not match quote price(%s)"),
    SELLING_PRICE_FORMAT_ERROR("����榡���~"),
    FOB_IS_NOTNULL("FOB���i�ť�"),
    FOB_IS_NOT_EXISTS("FOB���s�b"),
    SHIPPING_METHOD_IS_NOTNULL("�X�f�覡���i�ť�"),
    SHIPPING_METHOD_IS_NOT_EXISTS("�X�f�覡���s�b"),
    TRANSPORTATION_IS_NOT_DIFINED("�B��覡���w�q(%s)"),
    SSD_IS_NOTNULL("SSD���i�ť�"),
    SSD_MUST_GREATER("SSD�����j��(%s)"),
    CRD_IS_NOTNULL("CRD���i�ť�"),
    CRD_MUST_GREATER("CRD�����j��(%s)"),
    CRD_MUST_GREATER_OR_EQUALS_SYS_DATE("CRD��������j��ε���t�Τ�"),
    CRD_DATE_ERROR("CRD����榡���~(���T�榡=MM/DD/YY)"),
    BI_REGION_IS_NOTNULL("BI Region���i�ť�"),
    BI_REGION_MUST("BI Region������(%s)"),
    END_CUSTNO_NOT_SAME_CUSTNO("End Customer Number���i�PCustomer Number�ۦP"),
    CHOOSE_END_CUSTNAME_OR_END_CUSTNO("End Customer Name�PEnd Customer Number�оܤ@��J"),
    INPUT_CUSTPO_LINE_NO("�п�Jcustomer po line number"),
    INPUT_CUSTPO_NO("�п�Jcustomer po number"),
    CONFIRM_TSCA_SALES_ORDER("�d�L����TSCA�P��q��,�нT�{CUST PO�O�_���T"),
    QTY_MUST_SPQ_K("�ƶq�����OSPQ(%s K)������"),
    QTY_MUST_GREATER_OR_EQUALS_MOQ_K("�ƶq�����j��ε���MOQ(%s K)������"),
    NOT_CREATE_SPQ_MOQ("SPQ/MOQ��T���إ�,�гq��PC�P���إ�");
    private final String message;

    ErrorMessage(String errorMessage) {
        this.message = errorMessage;
    }

    // ���o���~�T��
    public String getMessage() {
        return message;
    }

    // ���o�a�Ѽƪ����~�T��
    public String getMessageFormat(String parameter) {
        return String.format(message, parameter);
    }
}
