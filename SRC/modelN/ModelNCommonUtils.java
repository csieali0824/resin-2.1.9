package modelN;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import modelN.dao.impl.TscRfqUploadTempImpl;
import modelN.dto.DetailDto;
import modelN.dto.ModelNDto;
import modelN.salesNo.*;
import com.mysql.jdbc.StringUtils;
import jxl.*;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import static modelN.SalesArea.TSCTDA;

public class ModelNCommonUtils extends AbstractModelNUtils {

    public String salesNo;
    public String rfqType;
    public String userName;
    public TscRfqUploadTempImpl tscRfqUploadTemp() {
        return new TscRfqUploadTempImpl();
    }

    public static String groupByType;
    public static Connection conn;
    public static String[] detailHeaderColumns = new String[]{};
    public static HashMap detailHeaderHtmlWidthMap = new LinkedHashMap();
    public static ModelNDto modelNDto;
    public static HashMap excelMap = new LinkedHashMap();
    public static HashMap detailMap = new LinkedHashMap();
    public static HashMap detailCoumnsMap = new LinkedHashMap();
    private Workbook wb;
    public static List errList = new ArrayList();
    private String uploadFilePath;
    public static String checkDate;
    private String itemNoPacking = "";
    private String sellingPrice_Q = "";
    private String endCustName = "";

    @Override
    public String[] getGroupBy(String salesNo) {
        return new String[]{"By Customer Number����RFQ", "By Customer PO����RFQ"};
    }

    public Map getDetailMap() {
        return detailMap;
    }

    @Override
    public String[] getRFQType(String salesNo) {
        return new String[]{"NORMAL", "FORECAST"};
    }

    public List getSalesArea(Connection conn, String userRoles, String userName) throws SQLException, JsonProcessingException {

        List<Map<String, String>> list = new ArrayList<>();
        ModelNCommonUtils.conn = conn;
        this.userName = userName;
        String salesAreaNo = "";
        String salesAreaName = "";
        String sql = "select SALES_AREA_NO,'('||SALES_AREA_NO||')'||SALES_AREA_NAME from ORADDMAN.TSSALES_AREA ";
        String sWhere = "where SALES_AREA_NO > 0 and SALES_AREA_NO in ('002','004','005','006','008','009')";
        String sOrder = "Order by 1";
        Map<String, String> salesAreaMap = new LinkedHashMap<>();
        if (!Objects.equals(userRoles, "admin") || !userRoles.equals("admin")) {
            sWhere += " and SALES_AREA_NO in (select tssaleareano from oraddman.tsrecperson " +
                    " where USERNAME='" + this.userName + "')";
        }
        PreparedStatement psmt = conn.prepareStatement(sql + sWhere + sOrder);
        ResultSet rs = psmt.executeQuery();
        while (rs.next()) {
            salesAreaMap.put(rs.getString(1), rs.getString(2));
        }
        rs.close();
        psmt.close();
        if (salesAreaMap.isEmpty()) {
            return new ArrayList();
        } else {
            for (Map.Entry<String, String> entry : salesAreaMap.entrySet()) {
                Map<String, String> item = new HashMap<>();
                item.put("value", entry.getKey());
                item.put("text", entry.getValue());
                list.add(item);
            }
            return list;
        }
    }

    public String writeValueToString(List list) throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(list);
    }

    // ���o�Ȥ��T
    @Override
    public void setShippingFobOrderTypeInfo() throws SQLException {}

    public void setExtraRuleInfo() throws SQLException {}

    //�ˬd�X�f�覡
    @Override
    public void setShippingMethod() throws SQLException {}

    @Override
    public void setCrd() throws SQLException {}

    // �ˬdFOB
    @Override
    public void setFob() throws SQLException {}

    @Override
    public void setDetailHeaderColumns() {}

    @Override
    public void setDetailHeaderHtmlWidth() throws Exception {}

    public void setDetailHtmlColumns(String salesNo) throws Exception {
        switch (SalesArea.fromSalesNo(salesNo)) {
            case TSCCSH:
                Tsccsh tsccsh = new Tsccsh();
                tsccsh.setDetailHeaderColumns();
                tsccsh.setDetailHeaderHtmlWidth();
                break;
            case TSCK:
                Tsck tsck = new Tsck();
                tsck.setDetailHeaderColumns();
                tsck.setDetailHeaderHtmlWidth();
                break;
            case TSCTDA:
                TsctDa tsctDa = new TsctDa();
                tsctDa.setDetailHeaderColumns();
                tsctDa.setDetailHeaderHtmlWidth();
                break;
            case TSCTDISTY:
                TsctDisty tsctDisty = new TsctDisty();
                tsctDisty.setDetailHeaderColumns();
                tsctDisty.setDetailHeaderHtmlWidth();
                break;
            case TSCA:
                Tsca tsca = new Tsca();
                tsca.setDetailHeaderColumns();
                tsca.setDetailHeaderHtmlWidth();
                break;
            case TSCR:
                Tscr tscr = new Tscr();
                tscr.setDetailHeaderColumns();
                tscr.setDetailHeaderHtmlWidth();
                break;
            default:
                break;
        }
    }

    public String[] getDetailHeaderColumns() {
        // �~�ȰϷ|���hDelete All �MGroup By�����A�Τ@�[�o�̡A�N���Φb�B�~�A�g�F
        String deleteAll = DetailColumn.DeleteAll.getColumnName(); // �s�W��̫e��
        String groupBy = DetailColumn.GroupBy.getColumnName();   // �s�W��̫᭱
        String[] columns = detailHeaderColumns;
        // �s�}�C�A���פ��}�C�h 2
        String[] newArray = new String[columns.length + 2];
        // �NDelete All���J��Ĥ@�Ӧ�m
        newArray[0] = deleteAll;
        // �N��}�C�������̧ǽƻs��s�}�C
        for (int i = 0; i < columns.length; i++) {
            newArray[i + 1] = columns[i];
        }
        // �NGroup By���J��̫�@�Ӧ�m
        newArray[newArray.length - 1] = groupBy;
        return newArray;
    }

    public HashMap getDetailHeaderHtmlWidthMap() {
        // �~�ȰϷ|���h"Delete All �M Group By�����A�Τ@�[�o�̡A�N���Φb�B�~�A�g�F
        // ��k�G�إ߷s�� LinkedHashMap�A�N�̫e���M�즳���e���J
        LinkedHashMap modifiedMap = new LinkedHashMap();
        modifiedMap.put("Delete All", 2); // �s�W��̫e��
        modifiedMap.putAll(detailHeaderHtmlWidthMap); // �[�J�즳���e
        modifiedMap.put("Group By", 0);     // �s�W��̫᭱
        return modifiedMap;
    }

    public String getSalesProgramName(String salesNo) {
        switch (SalesArea.fromSalesNo(salesNo)) {
            case TSCCSH:
               return "D4-017";
            case TSCK:
                return "D4-013";
            case TSCTDA:
                return "D4-015";
            case TSCTDISTY:
                return "D4-019";
            case TSCA:
                return "D4-004";
            case TSCR:
                return "D4-012";
            default :
                throw new IllegalArgumentException("�~�ȥN�X:" + salesNo + "��programName���~");
        }
    }

    private void checkCustIdAndName() throws SQLException {
        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS " +
                "where status = 'A'  and CUSTOMER_NUMBER ='" + modelNDto.getCustNo() + "'");
        if (rs.next()) {
            modelNDto.setCustId(rs.getString("CUSTOMER_ID"));
            modelNDto.setCustName(rs.getString("CUSTOMER_NAME"));
            this.setAndCheckInfo(true, false);
        } else {
            errList.add(ErrorMessage.CUSTNO_NOT_FOUND_ERP.getMessage());
            modelNDto.setErrorList(errList);
        }
    }

    private void checkCustomerPo() throws SQLException {
        //�ˬdcustomerNo �M customerPo �O�_���ݳB�z���
        if (!StringUtils.isNullOrEmpty(modelNDto.getCustNo()) && !StringUtils.isNullOrEmpty(modelNDto.getCustPo())) {
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery("select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where SALESAREANO = '" + salesNo + "' \n" + "" +
                            " and CUSTOMER_NO ='" + modelNDto.getCustNo() + "' AND CUSTOMER_PO='" + modelNDto.getCustPo() + "' AND CREATE_FLAG='N'");
            if (rs.next()) {
                errList.add(ErrorMessage.PENDING_DETAIL_EXISTS_CUSTNO.getMessage());
                modelNDto.setErrorList(errList);
            }
            rs.close();
            statement.close();
        }
    }

    private void checkTscAndCustPartNo() throws SQLException {
        int recordCount = 0;
        if (!StringUtils.isNullOrEmpty(modelNDto.getCustItem())) {
            String sql = "select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,\n" +
                    "a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE\n" +
                    ",NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3\n" +
                    ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE \n" +
                    ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + // quote �ϥ�
                    "from oe_items_v a,inv.mtl_system_items_b msi \n" +
                    ",APPS.MTL_ITEM_CATEGORIES_V c \n" +
                    "where a.SOLD_TO_ORG_ID = '" + modelNDto.getCustId() + "' \n" +
                    "and a.organization_id = msi.organization_id\n" +
                    "and a.inventory_item_id = msi.inventory_item_id\n" +
                    "and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID \n" +
                    "and msi.ORGANIZATION_ID = c.ORGANIZATION_ID \n" +
                    "and msi.ORGANIZATION_ID = '49'\n" +
                    "and c.CATEGORY_SET_ID = 6\n" +
                    "and a.CROSS_REF_STATUS='ACTIVE'\n" +
                    "and msi.inventory_item_status_code <> 'Inactive'\n" +
                    "and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
                    "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
                    "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+
                    "and a.ITEM = '" + modelNDto.getCustItem() + "'";
            if (!StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc())) {
                sql += " and a.ITEM_DESCRIPTION = '" + modelNDto.getTscItemDesc() + "'";
            }
            if (!StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
                sql += " and a.INVENTORY_ITEM = '" + modelNDto.getTscItem() + "'";
            }
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                modelNDto.setTscItem(rs.getString("INVENTORY_ITEM"));
                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                modelNDto.setTscItemDesc(rs.getString("ITEM_DESCRIPTION"));
                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                modelNDto.setUom(rs.getString("PRIMARY_UOM_CODE"));
                itemNoPacking = rs.getString("itemnopacking");
                if (StringUtils.isNullOrEmpty(modelNDto.getOrderType())) {
                    modelNDto.setOrderType(rs.getString("ORDER_TYPE"));
                } else if (!SalesArea.TSCR.getSalesNo().equals(salesNo)) {
                    if (modelNDto.getOrderType().equals("1156")) {
                        modelNDto.setManuFactoryNo("002");
                    }
                }
                recordCount++;
            }
            rs.close();
            statement.close();
            if (recordCount == 0) {
                errList.add(ErrorMessage.CUST_PN_NOT_FOUND_ERP.getMessage());
                modelNDto.setErrorList(errList);
            }
        } else if (!StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc()) || !StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
            String sql = "select distinct msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,\n" +
                    "nvl(msi.attribute3, 'N/A') attribute3,\n" +
                    "tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type\n" +
                    ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + // quote �ϥ�
                    "FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c\n" +
                    "WHERE msi.inventory_item_id = c.inventory_item_id\n" +
                    "AND msi.organization_id = c.organization_id\n" +
                    "AND msi.organization_id = '49'\n" +
                    "AND c.category_set_id = 6\n" +
                    "AND msi.inventory_item_status_code <> 'Inactive'\n" +
                    "AND nvl(msi.CUSTOMER_ORDER_FLAG,'N')='Y'\n" +
                    "AND nvl(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'\n" +
                    "AND msi.description =  nvl('" + modelNDto.getTscItemDesc() + "',msi.description)\n" +
                    "AND msi.segment1 = nvl('" + modelNDto.getTscItem() + "',msi.segment1)\n"+
                    " and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
                    "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
                    "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) ";
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                modelNDto.setTscItem(rs.getString("segment1"));
                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                modelNDto.setTscItemDesc(rs.getString("description"));
                modelNDto.setCustItem("");
                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                itemNoPacking = rs.getString("itemnopacking");
                modelNDto.setUom(rs.getString("PRIMARY_UOM_CODE"));
                if (StringUtils.isNullOrEmpty(modelNDto.getOrderType())) {
                    modelNDto.setOrderType(rs.getString("ORDER_TYPE"));
                } else if (!SalesArea.TSCR.getSalesNo().equals(salesNo)) {
                    if (modelNDto.getOrderType().equals("1156")) {
                        modelNDto.setManuFactoryNo("002");
                    }
                }
                recordCount++;
            }
            rs.close();
            statement.close();
            if (recordCount == 0) {
                errList.add(ErrorMessage.TSC_PN_NOT_FOUND_ERP.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
        if (recordCount > 1) {
            errList.add(ErrorMessage.TSC_PN_MORE_THAN_ONE.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            if (!modelNDto.getQuoteNumber().equals("") && !modelNDto.getTscItemDesc().equals("")) {
                Statement stmt = conn.createStatement();
                String sql = " select a.quoteid, a.partnumber,a.currency, to_char(a.pricekusd/1000,'FM99990.0999999') price_usd, \n"+
                        "'('|| a.region ||')'|| a.endcustomer end_customer \n"+
                        " from tsc_om_ref_quotenet a \n"+
                        " where a.quoteid='" + modelNDto.getQuoteNumber() + "' \n"+
                        " and a.partnumber='" + modelNDto.getTscItemDesc() + "' \n"+
                        " order by a.quoteid, a.partnumber";
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    sellingPrice_Q = rs.getString("PRICE_USD");
                    endCustName = rs.getString("END_CUSTOMER");
                }
                rs.close();
                stmt.close();
                if (sellingPrice_Q.equals("")) {
                    stmt = conn.createStatement();
                    sql = " select a.quoteid, a.partnumber,a.currency, to_char(a.pricekusd/1000,'FM99990.0999999') price_usd, \n" +
                            "'('|| a.region ||')'|| a.endcustomer end_customer \n" +
                            " from tsc_om_ref_quotenet a \n" +
                            " where a.quoteid='" + modelNDto.getQuoteNumber() + "' \n" +
                            " and a.partnumber like '" + itemNoPacking + "%' \n" +
                            " order by a.quoteid, a.partnumber";
                    rs = stmt.executeQuery(sql);
                    if (rs.next())
                    {
                        sellingPrice_Q = rs.getString("PRICE_USD");
                        endCustName = rs.getString("END_CUSTOMER");
                    }
                    rs.close();
                    stmt.close();
                }
            }
        }
    }

    //�ˬd�q�������O�_���T
    private void checkCorrectOrderTypeId() throws SQLException {
        String sql = "SELECT a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b \n" +
                " where b.order_num=a.order_num and a.order_num='" + modelNDto.getOrderType() + "' and a.sarea_no ='" + salesNo + "'" +
                " and a.active='Y'\n" +
                " and b.MANUFACTORY_NO='" + modelNDto.getManuFactoryNo() + "' and b.ACTIVE='Y'";
        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        if (!rs.next()) {
            errList.add(ErrorMessage.ORDER_TYPE_ID_ERROR.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            modelNDto.setOrderTypeId(rs.getString(1));
        }
        rs.close();
        statement.close();
    }

    //�ˬd�ƶq
    private void checkQty() {
        if (StringUtils.isNullOrEmpty(modelNDto.getQty())) {
            modelNDto.setQty("");
            errList.add(ErrorMessage.QTY_NOTNULL.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            try {
                double qtyNumber = Double.parseDouble(modelNDto.getQty().replace(",", ""));
                if (qtyNumber <= 0) {
                    errList.add(ErrorMessage.QTY_MUST_GREATER_0.getMessage());
                    modelNDto.setErrorList(errList);
                } else {
                    modelNDto.setQty((new DecimalFormat("#######0.0##")).format(qtyNumber));
                }
            } catch (Exception e) {
                errList.add(ErrorMessage.QTY_FORMAT_ERROR.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
    }

    //�ˬd���
    private void checkSellingPrice() {
        if (StringUtils.isNullOrEmpty(modelNDto.getSellingPrice())) {
            if (modelNDto.getQuoteNumber().equals("") || StringUtils.isNullOrEmpty(sellingPrice_Q)) {
                modelNDto.setSellingPrice("");
//                errList.add(ErrorMessage.SELLING_PRICE_NOTNULL.getMessage());
//                modelNDto.setErrorList(errList);
            } else {
                modelNDto.setSellingPrice(sellingPrice_Q);
            }
        } else {
            try {
                double priceNumber = Double.parseDouble(modelNDto.getSellingPrice().replace(",", ""));
                if (priceNumber <= 0) {
                    errList.add(ErrorMessage.SELLING_PRICE_MUST_GREATER_0.getMessage());
                    modelNDto.setErrorList(errList);
                } else if (!modelNDto.getQuoteNumber().equals("")) { // excel QuoteNumber �����Ůɤ~�|���ˬd
                   if (!modelNDto.getSellingPrice().equals(sellingPrice_Q)) {
                       errList.add(ErrorMessage.SELLING_PRICE_NOT_MATCH_QUOTE_PRICE.getMessageFormat(sellingPrice_Q));
                       modelNDto.setErrorList(errList);
                   }
                } else {
                    modelNDto.setSellingPrice((new DecimalFormat("###,##0.000##")).format(priceNumber));
                }
            } catch (Exception e) {
                errList.add(ErrorMessage.SELLING_PRICE_FORMAT_ERROR.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
    }

    //�ˬd��f���(SSD)
    private void checkSSD() {
        if (StringUtils.isNullOrEmpty(modelNDto.getSsd())) {
            modelNDto.setSsd("");
//            errList.add(ErrorMessage.SSD_IS_NOTNULL.getMessage());
//            modelNDto.setErrorList(errList);
        } else if (Long.parseLong(modelNDto.getSsd()) <= Long.parseLong(checkDate)) {
            errList.add(ErrorMessage.SSD_MUST_GREATER.getMessageFormat(checkDate));
            modelNDto.setErrorList(errList);
        }
    }

    // �ˬdREMARKS
    private void checkRemarks() {
        if (StringUtils.isNullOrEmpty(modelNDto.getRemarks())) {
            modelNDto.setRemarks("");
        }
    }

    // ���o�B��覡����T
    protected ResultSet getFndLookupValuesData() throws SQLException {
        String sql = " SELECT lookup_code,meaning FROM fnd_lookup_values lv"+
                " WHERE language = 'US'"+
                " AND view_application_id = 3"+
                " AND lookup_type = 'SHIP_METHOD'"+
                " AND security_group_id = 0"+
                " AND ENABLED_FLAG='Y'"+
                " AND (end_date_active IS NULL OR end_date_active > SYSDATE)";
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        return stmt.executeQuery(sql);
    }

    private void setAndCheckInfo(Boolean isShippingFobOrderType, Boolean isSetSalesInfo) throws SQLException {
        switch (SalesArea.fromSalesNo(salesNo)) {
            case TSCCSH:
                Tsccsh tsccsh = new Tsccsh();
                if (isShippingFobOrderType) {
                    tsccsh.setShippingFobOrderTypeInfo();
                } else if (isSetSalesInfo) {
                    tsccsh.setShippingMethod();
                    tsccsh.setFob();
                    tsccsh.setExtraRuleInfo();
                }
                break;
            case TSCK:
                Tsck tsck = new Tsck();
                if (isShippingFobOrderType) {
                    tsck.setShippingFobOrderTypeInfo();
                } else if (isSetSalesInfo) {
                    tsck.setShippingMethod();
                }
                break;
            case TSCTDA:
                TsctDa tsctDa = new TsctDa();
                if (isShippingFobOrderType) {
                    tsctDa.setShippingFobOrderTypeInfo();
                } else if (isSetSalesInfo) {
                    tsctDa.setShippingMethod();
                    tsctDa.setFob();
                    tsctDa.setExtraRuleInfo();
                }
                break;
            case TSCTDISTY:
                TsctDisty tsctDisty = new TsctDisty();
                if (isShippingFobOrderType) {
                    tsctDisty.setShippingFobOrderTypeInfo();
                }  else if (isSetSalesInfo) {
                    tsctDisty.setExtraRuleInfo();
                }
                break;
            case TSCR:
                Tscr tscr = new Tscr();
                if (isSetSalesInfo) {
                    tscr.setFob();
                    tscr.setCrd();
                    tscr.setShippingMethod();
                }
                break;
            default:
                break;
        }
    }

    protected ResultSet getAsoShippingMethodsV() throws SQLException {
        Statement stmt = conn.createStatement();
        String sql = "select a.SHIPPING_METHOD_CODE, a.SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a ";
        ResultSet rs = stmt.executeQuery(sql);
        return stmt.executeQuery(sql);
    }

    // ���oFOB(incoterm)����T
    protected ResultSet getFobIncotermData() throws SQLException {
        String sql = " select a.FOB_CODE, a.FOB from OE_FOBS_ACTIVE_V a order by a.fob_code";
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        return stmt.executeQuery(sql);
    }

    // ���oBI REGION����T
    protected ResultSet getBiRegionData() throws SQLException {
        String sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
        Statement stmt = conn.createStatement();
        return stmt.executeQuery(sql);
    }

    // �ˬd End Customer Number
    private void checkEndCustNumber() throws SQLException {
        String sql = "select distinct c.customer_id,c.customer_number,c.customer_name_phonetic \n" +
                " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c \n" +
                " ,(select * from oraddman.tssales_area where SALES_AREA_NO='" + salesNo + "') d \n" +
                " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID \n" +
                " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%' \n" +
                " and a.STATUS = b.STATUS \n" +
                " and a.ORG_ID = b.ORG_ID \n" +
                " and a.ORG_ID = d.PAR_ORG_ID \n" +
                " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID \n" +
                " and c.STATUS='A' \n" +
                " order by c.customer_id";

        Statement statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = statement.executeQuery(sql);

        if (!rs.isBeforeFirst()) rs.beforeFirst();
        while (rs.next()) {
            if (rs.getString("customer_number").equals(modelNDto.getEndCustNo())) {
                modelNDto.setEndCustNamePhonetic(rs.getString("customer_name_phonetic"));
                modelNDto.setEndCustId(String.valueOf(rs.getInt("customer_id")));
                break;
            }
        }
        if (modelNDto.getEndCustNamePhonetic().equals("")) {
            errList.add(ErrorMessage.END_CUSTID_FOUND_ERP.getMessage());
            modelNDto.setErrorList(errList);
        }
    }

    public String getUploadFilePath(String salesNo, String startDate, String rfqType, String groupByType, String fileName,
                                    String checkDate) throws SQLException {
        tscRfqUploadTemp().setPolicyContext(conn);
        this.salesNo = salesNo;
        this.rfqType = rfqType;
        ModelNCommonUtils.groupByType = groupByType;
        ModelNCommonUtils.checkDate = checkDate;
        String path = "/resin-2.1.9/webapps/oradds/jsp/upload_exl/";
        String startDateTimeFileName = startDate + "-" + fileName;
        String salesAreaName = "";

        switch (SalesArea.fromSalesNo(salesNo)) {
            case TSCCSH:
                salesAreaName = SalesArea.TSCCSH.name();
                break;
            case TSCK:
                salesAreaName = SalesArea.TSCK.name();
                break;
            case TSCTDA:
                salesAreaName = SalesArea.TSCTDA.name();
                break;
            case TSCTDISTY:
                salesAreaName = SalesArea.TSCTDISTY.name();
                break;
            case TSCA:
                salesAreaName = SalesArea.TSCA.name();
                break;
            case TSCR:
                salesAreaName = SalesArea.TSCR.name();
                break;
        }
        path = path + "/" + salesAreaName;
        this.uploadFilePath = path + "/" +startDateTimeFileName;
        File dir = new File(path);
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }
//        createOrDeleteDir(new File(path)); //todo keep 365 days
        return this.uploadFilePath;
    }

    private void createOrDeleteDir(File dir) {
        if (dir.isDirectory()) {
            // �R���l�ɮשΤl�ؿ�
            File[] files = dir.listFiles();
            if (files != null) {
                for (File file : files) {
                    if(file.exists()) {
                        file.delete();
                    }
                }
            }
        } else {
            // �إߤl�ɮשΤl�ؿ�
            dir.mkdirs();
        }
    }

    // �ˬd�O�_���Ū�row
    private static boolean isEmptyRow(Sheet sheet, int rowIndex) {
        int colCount = sheet.getColumns();
        for (int colIndex = 0; colIndex < colCount; colIndex++) {
            String content = sheet.getCell(colIndex, rowIndex).getContents().trim();
            if (!content.isEmpty()) {
                return false; // �u�n���@���x�s�榳���e�A�N���O�Ū�row
            }
        }
        return true;
    }
    public void writeExcel() throws Exception {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        InputStream is = new FileInputStream(uploadFilePath);
        this.wb = Workbook.getWorkbook(is);
        Sheet sheet = wb.getSheet(0);
        excelMap = new HashMap();

        for (int rowIndex = 1, rowCount = sheet.getRows(); rowIndex < rowCount; rowIndex++) {
            modelNDto = new ModelNDto();
            if (isEmptyRow(sheet, rowIndex)) {
                continue; // ignore empty row
            }
            for (int colIndex = 0, colCount = sheet.getColumns(); colIndex < colCount; colIndex++) {
                Cell rowCell = sheet.getCell(colIndex, rowIndex);
                String content = rowCell.getContents().trim(); // ���o�x�s�椺�e
                String columnName = sheet.getCell(colIndex, 0).getContents().trim();
                switch (ExcelColumn.settingExcelColumn(columnName, colIndex)) {
                    case CustomerNumber:
                        if (StringUtils.isNullOrEmpty(content)) {
                            throw new Exception(ErrorMessage.CUSTNO_REQUEST.getMessage());
                        }
                        modelNDto.setCustNo(content);
                        break;
                    case OrderType:
                        modelNDto.setOrderType(content);
                        break;
                    case CustomerPO:
                        if (StringUtils.isNullOrEmpty(content)) {
                            throw new Exception(ErrorMessage.CUSTPO_REQUEST.getMessage());
                        }
                        modelNDto.setCustPo(content);
                        break;
                    case CustomerPOLineNumber:
                        modelNDto.setCustPoLineNo(content);
                        break;
                    case _22D30D:
                        modelNDto.setTscItem(content);
                        break;
                    case TSC_PN:
                        if (StringUtils.isNullOrEmpty(content)) {
                            throw new Exception(ErrorMessage.TSC_PN_REQUEST.getMessage());
                        }
                        modelNDto.setTscItemDesc(content);
                        break;
                    case Customer_PN:
                        modelNDto.setCustItem(content);
                        break;
                    case Qty:
                        String qty = "";
                        if (rowCell instanceof NumberCell) {
                            qty =  "" + ((NumberCell) rowCell).getValue(); // �������ƭ�
                        } else {
                            qty = (rowCell.getContents()).trim(); // ��r�����
                        }
                        modelNDto.setQty(qty);
                        break;
                    case SellingPrice:
                        String sellingPrice = "";
                        if (rowCell instanceof NumberCell) {
                            sellingPrice =  "" + ((NumberCell) rowCell).getValue(); // �������ƭ�
                        } else {
                            sellingPrice = (rowCell.getContents()).trim(); // ��r�����
                        }
                        modelNDto.setSellingPrice(sellingPrice);
                        break;
                    case CRD:
                        String crd = content;
                        try {
                            if (rowCell.getType() == CellType.DATE) {
                                crd = sdf.format(((DateCell) rowCell).getDate());
                            } else {
                                crd = content.replace("-", "");
                                if (crd.length() < 8) {
                                    throw new Exception(ErrorMessage.CRD_LENGTH_LESS_8.getMessage());
                                }
                            }
                        } catch (Exception e) {
                            if (StringUtils.isNullOrEmpty(crd)) {
                                throw new Exception(ErrorMessage.CRD_REQUEST.getMessage());
                            }
                        }
                        modelNDto.setCrd(crd);
                        break;
                    case SSD:
                        String ssd = content;
                        try {
                            if (rowCell.getType() == CellType.DATE) {
                                ssd = sdf.format(((DateCell) rowCell).getDate());
                            } else {
                                ssd = content.replace("-", "");
                                if (ssd.length() < 8) {
                                    throw new Exception(ErrorMessage.SSD_LENGTH_LESS_8.getMessage());
                                }
                            }
                        } catch (Exception e) {
                            if (StringUtils.isNullOrEmpty(ssd)) {
                                throw new Exception(ErrorMessage.SSD_REQUEST.getMessage());
                            }
                        }
                        modelNDto.setSsd(ssd);
                        break;
                    case ShippingMethod:
                        modelNDto.setShippingMethod(content);
                        break;
                    case FOB:
                        modelNDto.setFob(content);
                        break;
                    case Remarks:
                        modelNDto.setRemarks(content);
                        break;
                    case EndCustomerNumber:
                        modelNDto.setEndCustNo(content);
                        break;
                    case EndCustomerName:
                        modelNDto.setEndCustName(content);
                        break;
                    case QuoteNumber:
                        modelNDto.setQuoteNumber(content);
                        break;
                    case SupplierID:
                        modelNDto.setSupplierId(content);
                        break;
                    case ShipToLocationID:
                        modelNDto.setShipToLocationId(content);
                        break;
                    case ShipToOrgID:
                        modelNDto.setShipToOrgId(content);
                        break;
                    case BIRegion:
                        modelNDto.setBiRegion(content);
                        break;
                    default:
                        break;
                }
                excelMap.put(rowIndex, modelNDto);
            }
        }
        if (!SalesArea.TSCA.getSalesNo().equals(salesNo)) {
            readAndCheckExcelContent();
        } else {
            Tsca tsca = new Tsca();
            tsca.checkExcelContent(salesNo);
        }
        wb.close();
    }

    private void readAndCheckExcelContent() throws Exception {
        for (Iterator it = excelMap.entrySet().iterator(); it.hasNext(); ) {
            errList = new LinkedList();
            endCustName = "";
            sellingPrice_Q = "";
            itemNoPacking = "";
            Map.Entry entry = (Map.Entry) it.next();
            modelNDto = (ModelNDto) entry.getValue();

            // �ˬdExcel�Ȥ�N��
            if (StringUtils.isNullOrEmpty(modelNDto.getCustNo())) {
                errList.add(ErrorMessage.CUSTNO_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // ���otable CustId �M CustName
                checkCustIdAndName();
            }
            // �ˬdExcel CustomerPO
            if (StringUtils.isNullOrEmpty(modelNDto.getCustPo())) {
                errList.add(ErrorMessage.CUSTPO_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // �ˬdtable�Ȥ�+customer po�O�_���ݳB�z���
                checkCustomerPo();
            }
            // �ˬdExcel�x�b�Ƹ�/�~�W�ΫȤ�Ƹ�
            if (StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc())
                    && StringUtils.isNullOrEmpty(modelNDto.getCustItem())
                    && StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
                modelNDto.setTscItem("");
                modelNDto.setTscItemDesc("");
                modelNDto.setCustItem("");
                errList.add(ErrorMessage.TSC_ITEM_AND_TSC_ITEM_PN_AND_CUST_ITEM_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // �ˬdtable�x�b�Ƹ��ΫȤ�Ƹ��bERP�O�_�s�b
                checkTscAndCustPartNo();
                // �ثe�u��002���o�S�O�޿�
                if (SalesArea.TSCCSH.getSalesNo().equals(salesNo)) {
                    if(!modelNDto.getCustId().equals("15540")
                            && !modelNDto.getCustId().equals("9404")
                            && StringUtils.isNullOrEmpty(modelNDto.getCustItem())) {
                        errList.add(ErrorMessage.INPUT_CUST_PN.getMessage());
                        modelNDto.setErrorList(errList);
                    }
                }
            }
            checkCorrectOrderTypeId();
            checkQty();
            checkSellingPrice();
            // �ˬdCRD
            checkSSD();
            //�ˬd�X�f�覡
            // �ˬdFOB
            checkRemarks();
            setDefaultLineType();
            // �ˬdExcel End Customer Number
            if (!modelNDto.getEndCustNo().equals("")) {
                //end customer number ���i�P customer number �ۦP
                if (modelNDto.getEndCustNo().equals(modelNDto.getCustNo())) {
                    errList.add(ErrorMessage.END_CUSTNO_NOT_SAME_CUSTNO.getMessage());
                    modelNDto.setErrorList(errList);
                } else {
                    // �ˬdEnd Customer Number�bERP�O�_�s�b
                    checkEndCustNumber();
                }
            } else if (!endCustName.equals("")) {
                modelNDto.setEndCustNamePhonetic(endCustName);
            }
            // �~�Ȱ��B�~�ˬd�γ]�w���Ⱦ���, �g�b����k��
            this.setAndCheckInfo(false, true);

            //�]�~�Ӹ�class overwrite setShippingMethod ����k�A�p�G�S�[���P�_�AerrList�|append�A�ɭP�|�e�{�@�˪����~�T��
            if (!errList.contains(ErrorMessage.SHIPPING_METHOD_IS_NOTNULL.getMessage())) {
                if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
                    modelNDto.setShippingMethod("");
                    errList.add(ErrorMessage.SHIPPING_METHOD_IS_NOTNULL.getMessage());
                    modelNDto.setErrorList(errList);
                }
            }

            //�]�~�Ӹ�class overwrite setFob ����k�A�p�G�S�[���P�_�AerrList�|append�A�ɭP�|�e�{�@�˪����~�T��
            if (!errList.contains(ErrorMessage.FOB_IS_NOTNULL.getMessage())) {
                if (StringUtils.isNullOrEmpty(modelNDto.getFob())) {
                    modelNDto.setFob("");
                    errList.add(ErrorMessage.FOB_IS_NOTNULL.getMessage());
                    modelNDto.setErrorList(errList);
                }
            }
        }
    }

    public String errList2String(List errList) {
        StringBuffer result = new StringBuffer();
        for (int i = 0; i < errList.size(); i++) {
            if (i < errList.size() - 1) {
                result.append(errList.get(i)).append("<br>");
            } else {
                result.append(errList.get(i));
            }
        }
        return result.toString();
    }

    private void setDefaultLineType() throws SQLException {
        if (salesNo.equals(TSCTDA.getSalesNo())
                && modelNDto.getOrderType().equals("1131")
                && modelNDto.getTscItemDesc().toLowerCase().contains("wafer".toLowerCase())) {
            modelNDto.setLineType("1503");
        } else {
            Statement statement = conn.createStatement();
            String sql =
                    "select DEFAULT_ORDER_LINE_TYPE from ORADDMAN.TSAREA_ORDERCLS c \n" +
                            " where c.SAREA_NO = '" + salesNo + "' \n" +
                            " and c.ORDER_NUM='" + modelNDto.getOrderType() + "'";
            ResultSet rs = statement.executeQuery(sql);
            if (rs.next()) {
                modelNDto.setLineType(rs.getString("DEFAULT_ORDER_LINE_TYPE"));
            } else {
                modelNDto.setLineType("0");
            }
            rs.close();
            statement.close();
        }
    }

    public void insertIntoTscRfqUploadTmp() throws SQLException {
        tscRfqUploadTemp().insertTscRfqUploadTemp(conn, excelMap, salesNo, userName, rfqType, groupByType);
    }

    public void deteleTscRfqUploadTemp(String salesNo, String uploadBy, String customerId, String customerPo, String groupByType, String shipToOrgId) throws SQLException {
        tscRfqUploadTemp().deleteTscRfqUploadTemp(conn, salesNo, uploadBy, customerId, customerPo, groupByType, shipToOrgId);
        this.refreahDetailData(salesNo , uploadBy);
    }

    public void deteleAllTscRfqUploadTemp(String salesNo,String uploadBy) throws SQLException {
        tscRfqUploadTemp().deleteAllTscRfqUploadTemp(conn, salesNo, uploadBy);
        this.readTscRfqUploadTemp(salesNo, uploadBy, null, null, null, null);
    }

    private void refreahDetailData(String salesNo, String uploadBy) throws SQLException {
        this.readTscRfqUploadTemp(salesNo, uploadBy, null, null, null, null);
    }
    public void readTscRfqUploadTemp(String salesNo, String uploadBy, String customerNo, String customerPo, String groupByType, String shipToOrgId) throws SQLException {
        detailMap = new LinkedHashMap();
        Map map = tscRfqUploadTemp().getTscRfqUploadTemp(conn, salesNo, uploadBy, customerNo, customerPo, groupByType, shipToOrgId);
        for (Iterator it = map.entrySet().iterator(); it.hasNext();) {
            HashMap detailKeyValueMap = new LinkedHashMap();
            List list = new LinkedList();
            Map.Entry en = (Map.Entry) it.next();
            int rowIndex =  ((Integer) en.getKey()).intValue();
            DetailDto detailDto = (DetailDto) en.getValue();
            list.add(detailDto);

            for (int i = 0, n = getDetailHeaderColumns().length; i < n; i++) {
                String columnKey = getDetailHeaderColumns()[i];
                switch (DetailColumn.settingDetailColumn(columnKey, i)) {
                    case DeleteAll:
                        detailKeyValueMap.put(columnKey, "Delete");
                        break;
                    case CustomerName:
                        detailKeyValueMap.put(columnKey, detailDto.getCustomerName());
                        break;
                    case RFQType:
                        detailKeyValueMap.put(columnKey, detailDto.getRfqType());
                        break;
                    case CustomerPO:
                        detailKeyValueMap.put(columnKey, detailDto.getCustomerPo());
                        break;
                    case TSC_PN:
                        detailKeyValueMap.put(columnKey, detailDto.getDescription());
                        break;
                    case CustomerItem:
                    case Customer_PN:
                        detailKeyValueMap.put(columnKey, detailDto.getCustItemName());
                        break;
                    case Qty:
                        detailKeyValueMap.put(columnKey, detailDto.getQty());
                        break;
                    case SellingPrice:
                        detailKeyValueMap.put(columnKey, detailDto.getSellingPrice());
                        break;
                    case CRD:
                        detailKeyValueMap.put(columnKey, detailDto.getCrd());
                        break;
                    case SSD:
                        detailKeyValueMap.put(columnKey, detailDto.getSsd());
                        break;
                    case ShippingMethod:
                        detailKeyValueMap.put(columnKey, detailDto.getShippingMethod());
                        break;
                    case FOB:
                        detailKeyValueMap.put(columnKey, detailDto.getFobIncoterm());
                        break;
                    case OrderType:
                        detailKeyValueMap.put(columnKey, detailDto.getOrderType());
                        break;
                    case EndCustomerNumber:
                        detailKeyValueMap.put(columnKey, detailDto.getEndCustomerNumber());
                        break;
                    case EndCustomer:
                    case EndCust:
                        detailKeyValueMap.put(columnKey, detailDto.getEndCustomer());
                        break;
                    case ShipTo:
                    case ShipToId:
                        detailKeyValueMap.put(columnKey, detailDto.getShipToOrgId());
                        break;
                    case UploadBy:
                        detailKeyValueMap.put(columnKey, detailDto.getUploadBy());
                        break;
                    case UploadDate:
                        detailKeyValueMap.put(columnKey, detailDto.getUploadDate());
                        break;
                    case GroupBy:
                        detailKeyValueMap.put(columnKey, detailDto.getGroupByType());
                        break;
                    default:
                      break;
                }
            }
            list.add(detailKeyValueMap);
            detailMap.put(rowIndex, list);
        }
    }

    public String[][] sendRedirect2DRQCreate(HttpSession session, HttpServletResponse response, Map argMap) throws UnsupportedEncodingException {
        List list = new LinkedList();
        for (Iterator it = detailMap.entrySet().iterator(); it.hasNext(); ) {
            List row = new LinkedList();
            Map.Entry entry = (Map.Entry) it.next();
            int rowNo = ((Integer) entry.getKey()).intValue();
            DetailDto detailDto = (DetailDto) ((List) entry.getValue()).get(0); //�u�� DetailDto������
            row.add(String.valueOf(rowNo));               // 0
            row.add(detailDto.getTscItem());              // 1
            row.add(detailDto.getDescription());          // 2
            row.add(detailDto.getQty());                  // 3
            row.add(detailDto.getUom());                  // 4
            row.add(detailDto.getCrd());                  // 5
            row.add(detailDto.getShippingMethod());       // 6
            row.add(detailDto.getSsd());                  // 7
            row.add(detailDto.getCustomerPo());           // 8
            row.add(detailDto.getRemarks());              // 9
            row.add("N");                                 //10
            row.add("0");                                 //11
            row.add("0");                                 //12
            row.add(detailDto.getManuFactoryNo());        //13
            row.add(detailDto.getCustItemName());         //14
            row.add(detailDto.getSellingPrice());         //15
            row.add(detailDto.getOrderType());            //16
            row.add(detailDto.getLineType());             //17
            row.add(detailDto.getFobIncoterm());          //18
            row.add(detailDto.getCustomerPoLineNumber()); //19
            row.add(detailDto.getQuoteNumber());          //20
            row.add(detailDto.getEndCustomerNumber());    //21
            row.add("");                                  //22
            row.add("");                                  //23
            row.add(detailDto.getEndCustomer());          //24
            row.add(detailDto.getOrgSoLineId());          //25
            row.add("");                                  //26
            row.add(detailDto.getBiRegion());             //27
            row.add("");                                  //28
            row.add("");                                  //29
            list.add(row);
        }
        String[][] strArray = new String[list.size()][];
        for (int i = 0; i < list.size(); i++) {
            List row = (List) list.get(i);
            strArray[i] = new String[row.size()];
            for (int j = 0; j < row.size(); j++) {
                Object value = row.get(j);
                strArray[i][j] = (value == null) ? "" : value.toString(); // �B�z null �Ȭ��Ŧr��
            }
        }
        String customerId = (String) argMap.get("customerId");
        String customerNo = (String) argMap.get("customerNo");
        String customerName = (String) argMap.get("customerName");
        String salesNo = (String) argMap.get("salesNo");
        String customerPo = (String) argMap.get("customerPo");
        String shipToOrgId = (String) argMap.get("shipToOrgId");
        String curr = (String) argMap.get("curr");
        String remark = (String) argMap.get("remark");
        String orderType = (String) argMap.get("orderType");
        String rfqType = (String) argMap.get("rfqType");
        String tempId = (String) argMap.get("tempId");
        String groupByType = (String) argMap.get("groupByType");
        String shipToContactName = getShipToContactNameAndId(customerId, shipToOrgId)[0];
        String shipToContactId = getShipToContactNameAndId(customerId, shipToOrgId)[1];

        // �]��TSCRFQImportSPQCheck.jsp �|�ϥ�session �Ӱ��ơA�ҥH���N���A�s�b�o��
        session.setAttribute("SPQCHECKED","N");
        session.setAttribute("CUSTOMERID",customerId);
        session.setAttribute("CUSTOMERNO",customerNo);
        session.setAttribute("CUSTOMERNAME",customerName);
        session.setAttribute("CUSTOMERPO", customerPo);
        session.setAttribute("CUSTACTIVE","Y");
        session.setAttribute("SALESAREANO",salesNo);
        session.setAttribute("REMARK",remark);
        session.setAttribute("PREORDERTYPE",orderType);
        session.setAttribute("ISMODELSELECTED","Y");
        session.setAttribute("PROCESSAREA",salesNo);
        session.setAttribute("SHIPTO",shipToOrgId);
        session.setAttribute("CUSTOMERIDTMP",customerId);
        session.setAttribute("INSERT","Y");
        session.setAttribute("RFQ_TYPE",rfqType);
        session.setAttribute("UPLOAD_TEMP_ID",tempId);
        session.setAttribute("SHIPTOCONTACT",shipToContactName);
        session.setAttribute("SHIPTOCONTACTID",shipToContactId);
        session.setAttribute("modelN", "Y");
        session.setAttribute("groupByType", groupByType);
        session.setAttribute("MAXLINENO",""+strArray.length);
        session.setAttribute("PROGRAMNAME",getSalesProgramName(salesNo));

        String urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID=" + java.net.URLEncoder.encode(customerId) +
                "&SPQCHECKED=N" +
                "&CUSTOMERNO=" + java.net.URLEncoder.encode(customerNo) +
                "&CUSTOMERNAME= " + java.net.URLEncoder.encode(customerName, "UTF-8").replace("+", "%20") +
                "&CUSTACTIVE=A" +
                "&SALESAREANO=" + java.net.URLEncoder.encode(salesNo) +
                "&CUSTOMERPO=" + java.net.URLEncoder.encode(customerPo, "UTF-8").replace("+", "%20") +
                "&CURR=" + java.net.URLEncoder.encode(curr) +
                "&REMARK=" + java.net.URLEncoder.encode(remark) +
                "&PREORDERTYPE=" + java.net.URLEncoder.encode(orderType) +
                "&ISMODELSELECTED=Y" +
                "&PROCESSAREA=" + java.net.URLEncoder.encode(salesNo) +
                "&SHIPTO="+java.net.URLEncoder.encode(shipToOrgId)+
                "&CUSTOMERIDTMP=" + java.net.URLEncoder.encode(customerId) +
                "&INSERT=Y" +
                "&RFQTYPE=" + java.net.URLEncoder.encode(rfqType) +
                "&UPLOAD_TEMP_ID="+java.net.URLEncoder.encode(tempId)+
                "&SHIPTOCONTACT="+java.net.URLEncoder.encode(shipToContactName, "UTF-8").replace("+", "%20") +
                "&SHIPTOCONTACTID="+java.net.URLEncoder.encode(shipToContactId)+
                "&PROGRAMNAME=" + getSalesProgramName(salesNo);
        try {
            response.sendRedirect(urlDir);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error:" + e.getMessage());
        }
        return strArray;
    }

    private String[] getShipToContactNameAndId(String customerId, String shipToOrgId) {
        String contactName = "";
        String contactId = "";
        String sql = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id" +
                    " from ar_contacts_v con,hz_cust_site_uses su,HZ_CUST_SITE_USES_ALL hcsu " +
                    " where  con.customer_id ='" + customerId + "'" +
                    " and con.status='A'" +
                    " AND con.address_id=su.cust_acct_site_id" +
                    " AND su.site_use_code='SHIP_TO'" +
                    " AND hcsu.CUST_ACCT_SITE_ID =con.address_id(+)" +
                    " AND hcsu.SITE_USE_ID='" + shipToOrgId + "'" +
                    " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'" + customerId + "',1,2)";
        try {
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                contactName = rs.getString("contact_name");
                contactId = rs.getString("contact_id");
            }
            rs.close();
            stmt.close();
        } catch (SQLException e) {
            e.getMessage();
        }
        return new String[]{contactName, contactId};
    }
}
