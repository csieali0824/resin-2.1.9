import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.mysql.jdbc.StringUtils;
import jxl.*;
import jxl.read.biff.BiffException;
import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ExcelColumn;
import modelN.dao.impl.TscRfqUploadTempImpl;
import modelN.dto.DetailDto;
import modelN.dto.ModelNDto;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

import static modelN.SalesArea.TSCTDA;

public class MarsTest {
    public static void mainc(String[] args) {
        Map<String, Integer> map = new HashMap<>();

        String[] array = new String[]{"4A", "4B", "4C", "4D", "4E", "4F", "4G", "4H", "4I", "4J",
                "4K", "4L", "4M", "4N", "4O", "4P", "4Q", "4R", "4S", "4T",
                "4U", "4V", "4W", "4X", "4Y", "4Z"};

        String[] alphabetArray = new String[]{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J",
                "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
                "U", "V", "W", "X", "Y", "Z"};

        String[] numberArray = new String[]{"1", "2", "3", "4", "5", "6", "7", "8", "9"};

        String[][] ary2 = new String[][]{alphabetArray, numberArray};

        int i = -1;
        for (String layer1 : array) {
            i += 2;
            map.put(layer1, i);
            for (String[] layer2 : ary2) {
                for (String value : layer2) {
                    String dateCode = layer1.concat(value);
                    int dateValue = map.get(layer1);
                    String insertSql = "INSERT INTO TSC.TSC_DATE_CODE (YEAR, DATE_TYPE, DATE_VALUE, DATE_CODE, " +
                            "PROD_GROUP, VENDOR, CUSTOMER, FACTORY_CODE, GREEN_FLAG, DC_RULE, TSC_PARTNO, " +
                            "CREATION_DATE) \n" +
                            "VALUES (2024, 'WEEK', " + dateValue + ", '" + dateCode + "', 'SSD', null, null, null, " +
                            "null, 'YWL', null, sysdate);";
                }
            }
        }
    }

    public static String errList2String(List errList) {
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

    public static String appendErrMsg(String errorMsg) {
        StringBuffer result = new StringBuffer();
        if (!errList.contains(errorMsg)) {
            errList.add(errorMsg);
        }
//        if (currentRow != rowIndex) {
//            errList = new ArrayList();
//        }
        for (int i = 0; i < errList.size(); i++) {
            if (i < errList.size() - 1) {
                result.append(errList.get(i)).append("<br>");
            } else {
                result.append(errList.get(i));
            }
        }
        currentRow = rowIndex;
        return result.toString();
    }

    private static ModelNDto modelNDto;
    private static DetailDto detailDto;
    private static HashMap detailKVMap;
    private static Connection conn;
    private static HashMap map = new HashMap();

    static {
        try {
            conn = ConnUtils.getConnectionCRP1();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private static String salesNo = TSCTDA.getSalesNo();

    private static List errList = new LinkedList();

    static int currentRow = 1;
    static int rowIndex;

    public static String[] columns;

    static String sellingPrice_Q = "";
    static String endCustName = "";
    static String itemNoPacking = "";

//    private static TscRfqUploadTempDao tscRfqUploadTempDao;

    public static void setColumns() {
        columns = new String[]{DetailColumn.CustomerName.getColumnName(), DetailColumn.RFQType.getColumnName(),
                DetailColumn.CustomerPO.getColumnName(),
                DetailColumn.TSC_PN.getColumnName(), DetailColumn.CustomerItem.getColumnName(),
                DetailColumn.Qty.getColumnName(),
                DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.OrderType.getColumnName(),
                DetailColumn.EndCustomerNumber.getColumnName(), DetailColumn.EndCustomer.getColumnName(),
                DetailColumn.UploadBy.getColumnName()};
    }

    public static String[] getColumns() {
        return columns;
    }

    public static TscRfqUploadTempImpl tscRfqUploadTemp() {
        return new TscRfqUploadTempImpl();
    }

//    public static SalesCheckMechanism salesCheckMechanism() {
//        return new SalesCheckMechanism("005");
//    }


    public static void mainDetail(String[] args) throws SQLException {
        setColumns();
        String[] detailColumns = getColumns();
        HashMap detailKeyValueMap = new LinkedHashMap();
        List list = new ArrayList();
        HashMap detailMap = new LinkedHashMap();
        TscRfqUploadTempImpl temp = new TscRfqUploadTempImpl();
        Map map = tscRfqUploadTemp().getTscRfqUploadTemp(conn, "008", null, null, null, null, null);
        for (Iterator it = map.entrySet().iterator(); it.hasNext(); ) {
            Map.Entry en = (Map.Entry) it.next();
            int rowIndex = ((Integer) en.getKey()).intValue();
            detailDto = (DetailDto) en.getValue();
            System.out.println(detailDto.getQty());
            System.out.println(detailDto.getQty().replaceAll(",", ""));
            list.add(detailDto);
            for (int i = 0, n = detailColumns.length; i < n; i++) {
                String columnKey = detailColumns[i];
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
//        System.out.println("map="+detailMap);
    }

    public static void mainJson(String[] args) throws JsonProcessingException {
        Map<String, String> map = new LinkedHashMap<>();
        map.put("002", "(002)半導體業務部-上海蘇州地區");
        map.put("004", "(004)半導體業務部-韓國區");
        map.put("005", "(005)半導體業務部-台灣區(DA)");
        map.put("006", "(006)半導體業務部-台灣區(Disty)");
        map.put("008", "(008)半導體事業部-美國區");
        map.put("009", "(009)半導體事業部-R.O.W.");
        List<Map<String, String>> jsonList = new ArrayList<>();

        // 加入預設選項
        Map<String, String> defaultOption = new HashMap<>();
        defaultOption.put("value", "All");
        defaultOption.put("text", "請選擇");
        jsonList.add(defaultOption);

        for (Map.Entry<String, String> entry : map.entrySet()) {
            Map<String, String> item = new HashMap<>();
            item.put("value", entry.getKey());
            item.put("text", entry.getValue());
            jsonList.add(item);
        }

        // 轉換為 JSON
        ObjectMapper objectMapper = new ObjectMapper();
        String json = objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(jsonList);
        System.out.println("json=" + json);
    }

    public static void mainDetail_test(String[] args) throws Exception {
        setColumns();
        String[] detailColumns = getColumns();
//        String[] detailColumns = new String[]{" ", "Customer Name", "RFQ Type", "Customer PO", "Item Desc",
//        "Customer" +
//                "Item", "Qty", "Selling Price", "Request Date", "Order Type", "End Cust ID", "End Customer",
//                "Upload By"};
        String sql = " select a.salesareano, a.upload_date, a.upload_by, a.customer_no, a.customer_id, a" +
                ".customer_name,a.rfq_type, \n" +
                "UTL_I18N.UNESCAPE_REFERENCE(a.customer_po) customer_po, b.description, b.segment1, a.cust_item_name," +
                " a.qty, \n" +
                "a.selling_price, a.crd, a.request_date as ssd, b.PRIMARY_UOM_CODE uom,a.crd, a.factory, a" +
                ".shipping_method,a.fob, \n" +
                "a.remarks, d.OTYPE_ID as order_type_id, d.ORDER_NUM order_type, a.line_type, \n" +
                "UTL_I18N.UNESCAPE_REFERENCE(a.customer_po_line_number) customer_po_line_number, \n" +
                "(select count(1) from oraddman.tsc_rfq_upload_temp c \n" +
                "  where c.create_flag='N' \n" +
                "   and c.salesareano=a.salesareano \n" +
                "   and c.customer_no=a.customer_no \n" +
                "   and c.customer_po=a.customer_po \n" +
                "   and c.upload_by=a.upload_by) rowcnt \n" +
                ",e.customer_number end_customer_number, a.end_customer \n" +
                " FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d," +
                "ar_customers e \n" +
                " where a.create_flag=? \n" +
                " and a.salesareano=? \n" +
                " and b.organization_id=43 \n" +
                " and a.inventory_item_id = b.inventory_item_id \n" +
                " and a.customer_no = nvl(?, a.customer_no) \n" +
                " and a.customer_po = nvl(?, a.customer_po) \n" +
                " and a.upload_by = nvl(?, a.upload_by) \n" +
                " and a.salesareano=d.SAREA_NO \n" +
                " and a.order_type=d.OTYPE_ID \n" +
                " and a.end_customer_id=e.customer_id(+) \n" +
                " order by a.customer_no,a.customer_po,a.line_no,b.description";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "N");
        pstmt.setString(2, salesNo);
        pstmt.setString(3, null);
        pstmt.setString(4, null);
        pstmt.setString(5, null);
        ResultSet rs = pstmt.executeQuery();
        HashMap detailMap = new LinkedHashMap();
        int rowCount = 0;
        while (rs.next()) {
            HashMap detailKeyValueMap = new LinkedHashMap();
            List list = new ArrayList();
            rowCount++;
            detailDto = new DetailDto();
            detailDto.setSalesNo(rs.getString("salesareano"));
            detailDto.setUploadBy(rs.getString("upload_date"));
            detailDto.setCustomerNo(rs.getString("customer_no"));
            detailDto.setCustomerId(rs.getString("customer_id"));
            detailDto.setCustomerName(rs.getString("customer_name"));
            detailDto.setRfqType(rs.getString("rfq_type"));
            detailDto.setCustomerPo(rs.getString("customer_po"));
            detailDto.setDescription(rs.getString("description"));
            detailDto.setCustItemName(rs.getString("cust_item_name"));
            detailDto.setQty((new DecimalFormat("##,##0.######")).format(rs.getDouble("qty")));
            detailDto.setSellingPrice((new DecimalFormat("##,##0.######")).format(rs.getDouble("selling_price")));
            detailDto.setCrd(rs.getString("crd"));
            detailDto.setSsd(rs.getString("ssd"));
            detailDto.setShippingMethod(rs.getString("shipping_method"));
            detailDto.setFobIncoterm(rs.getString("fob"));
            detailDto.setRemarks(rs.getString("remarks"));
            detailDto.setOrderTypeId(rs.getString("order_type_id"));
            detailDto.setOrderType(rs.getString("order_type"));
            detailDto.setLineType(rs.getString("line_type"));
            detailDto.setCustomerPoLineNumber(rs.getString("customer_po_line_number"));
            detailDto.setRowCount(rs.getString("rowcnt"));
            detailDto.setEndCustomerNumber(rs.getString("end_customer_number"));
            detailDto.setEndCustomer(rs.getString("end_customer"));
//            detailMap.put(rowCount, detailDto);

            list.add(detailDto);
            for (int i = 0, n = detailColumns.length; i < n; i++) {
                String columnKey = detailColumns[i];
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
            detailMap.put(rowCount, list);
        }
        pstmt.close();
        rs.close();

        // 分組存儲到 Map
        Map groupedData = new HashMap();
        DetailDto dto = new DetailDto();
        HashMap map = new LinkedHashMap();
        for (Iterator it = detailMap.entrySet().iterator(); it.hasNext(); ) {
            Map.Entry entry = (Map.Entry) it.next();
            List detailList = (ArrayList) entry.getValue();
            for (int i = 0, n = detailList.size(); i < n; i++) {
                if (detailList.get(i) instanceof DetailDto) {
                    dto = (DetailDto) detailList.get(i);
                } else if (detailList.get(i) instanceof LinkedHashMap) {
                    map = (HashMap) detailList.get(i);
                }
            }
            String customerNumber = dto.getCustomerNo();
//            System.out.println("customerNumber="+customerNumber);
//            // 如果 Map 中沒有該 Customer Number，則初始化
            if (!groupedData.containsKey(customerNumber)) {
                groupedData.put(customerNumber, new ArrayList());
            }
//            // 添加數據到對應的分組
            List group = (List) groupedData.get(customerNumber);
            group.add(dto);
            group.add(map);
        }

        System.out.println("groupedData=" + groupedData);
        int groupCnt = 1;
        for (Iterator it = groupedData.entrySet().iterator(); it.hasNext(); ) {
            groupCnt++;
            Map.Entry entry = (Map.Entry) it.next();
            String customerNumber = (String) entry.getKey();
            List group = (List) entry.getValue();
//            System.out.println("Customer Number="+ entry.getKey());
//            System.out.println("groupr="+ group);
            DetailDto dtl = new DetailDto();
            String groupBy = "";
            for (int j = 0, k = group.size(); j < k; j++) {
                if (group.get(j) instanceof DetailDto) {
                    dtl = (DetailDto) group.get(j);
                    System.out.println("txxxx=" + (groupBy.equals(dtl.getCustomerNo()) ? true : false));
                } else if (group.get(j) instanceof LinkedHashMap) {
                    Map groupedMap = (Map) group.get(j);
                    groupBy = dtl.getCustomerNo();
                    System.out.println("dtl=" + dtl.getCustomerNo());
//                    System.out.println("groupCnt="+groupCnt);
                    System.out.println("---------------------------------------");
                    for (Iterator groupedIt = groupedMap.entrySet().iterator(); groupedIt.hasNext(); ) {
                        Map.Entry en = (Map.Entry) groupedIt.next();
                        String key = (String) en.getKey();
                        String value = (String) en.getValue();
//                    System.out.println(""+key+"="+value);
                    }
                }
//                Map groupedMap = (Map) groupIt.next();
//                for (Iterator groupedIt = groupedMap.entrySet().iterator(); groupedIt.hasNext();) {
//                    Map.Entry en = (Map.Entry) groupedIt.next();
//                    String key = (String) en.getKey();
//                    String value = (String) en.getValue();
////                    System.out.println(""+key+"="+value);
//                }
//                System.out.println("-------------------------------------");
//                DataRow dataRow = (DataRow) groupIt.next();
//                System.out.println("  Order Type: " + dataRow.getOrderType());
//                System.out.println("  Customer PO: " + dataRow.getCustomerPO());
//                System.out.println("  TSC Desc: " + dataRow.getTscDesc());
            }
//            System.out.println("group="+ group);
        }


//        DetailDto dto = new DetailDto();
//        HashMap map = new LinkedHashMap();
//        System.out.println("detailMap="+detailMap);
//        for (Iterator it = detailMap.entrySet().iterator(); it.hasNext(); ) {
//            Map.Entry entry = (Map.Entry) it.next();
//            List detailList = (ArrayList) entry.getValue();
//            for (int i = 0, n = detailList.size(); i < n; i++) {
//                if (detailList.get(i) instanceof DetailDto) {
//                    dto = (DetailDto) detailList.get(i);
//                } else if (detailList.get(i) instanceof LinkedHashMap) {
//                    map = (HashMap) detailList.get(i);
//                }
//            }
//            System.out.println("xxx="+map);
//            Map filteredMap = new LinkedHashMap();
//            for (Iterator it1 = map.entrySet().iterator(); it1.hasNext();) {
//                Map.Entry en = (Map.Entry) it1.next();
//                String column = (String) en.getKey();
//                String content = (String) en.getValue();
//                if (Arrays.asList(" ", "Customer Name", "RFQ Type").contains(column)) {
//                    filteredMap.put(column, content);
//                }
//            }
//            System.out.println("filteredMap="+filteredMap);
//        }

    }

    public static int findLastNonEmptyColumn(Sheet sheet) {
        int maxCol = 0;
        for (int rowIndex = 0; rowIndex < sheet.getRows(); rowIndex++) {
            for (int colIndex = sheet.getColumns() - 1; colIndex >= 0; colIndex--) {
                if (!sheet.getCell(colIndex, rowIndex).getContents().trim().isEmpty()) {
                    maxCol = Math.max(maxCol, colIndex + 1);
                    break;
                }
            }
        }
        return maxCol;
    }

    // 檢查是否為空行
    public static boolean isEmptyRow(Sheet sheet, int rowIndex) {
        int colCount = sheet.getColumns();
        for (int colIndex = 0; colIndex < colCount; colIndex++) {
            String content = sheet.getCell(colIndex, rowIndex).getContents().trim();
            if (!content.isEmpty()) {
                return false; // 只要有一個儲存格有內容，就不是空行
            }
        }
        return true;
    }

    public static void main(String[] args) throws Exception {
        CallableStatement cs1 = conn.prepareCall(
                "{call mo_global.set_policy_context('S',?)}");
        cs1.setString(1, "41");  // 取業務員隸屬ParOrgID
        cs1.execute();
        cs1.close();
//        Connection con = ConnUtils.getConnectionCRP1();
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
//        String uploadFilePath = "D:/D4-019.xls";
//        String uploadFilePath = "C:\\Users\\mars.wang\\Desktop\\sales-upload\\D4-019_20241212.xls";
        try {
            String uploadFilePath = "C:\\Users\\mars.wang\\Desktop\\modelN_Excel\\RFQ-TSCTDA-33452.xls";
            InputStream is = new FileInputStream(uploadFilePath);
            Workbook wb = Workbook.getWorkbook(is);
            Sheet sheet = wb.getSheet(0);
            for (int rowIndex = 1, rowCount = sheet.getRows(); rowIndex < rowCount; rowIndex++) {
                if (isEmptyRow(sheet, rowIndex)) {
                    System.out.println("跳過第 " + rowIndex + " 行（空白）");
                    continue; // 忽略空白行
                }

                modelNDto = new ModelNDto();
                for (int colIndex = 0, colCount = sheet.getColumns(); colIndex < colCount; colIndex++) {
                    Cell rowCell = sheet.getCell(colIndex, rowIndex);
                    String content = rowCell.getContents().trim(); // 取得儲存格內容
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
                                qty = "" + ((NumberCell) rowCell).getValue(); // 直接取數值
                            } else {
                                qty = content; // 文字型欄位
                            }
                            modelNDto.setQty(qty);
                            break;
                        case SellingPrice:
                            String sellingPrice = "";
                            if (rowCell instanceof NumberCell) {
                                sellingPrice = "" + ((NumberCell) rowCell).getValue(); // 直接取數值
                            } else {
                                sellingPrice = content; // 文字型欄位
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
                            String ssd = rowCell.getContents().trim();
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
                                ssd = "";
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
//                        throw new Exception("第" + (j + 1) + "欄的名稱錯誤:" + columnName);
                    }
                    map.put(rowIndex, modelNDto);
                }
//            System.out.println(""+i+"----------------------------------------------");
            }
            readExcelContent();
            wb.close();
        } catch (IOException | BiffException e) {
            e.printStackTrace();
        }
    }

    private static void checkCustIdAndName() throws SQLException {
        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS " +
                "where status = 'A'  and CUSTOMER_NUMBER ='" + modelNDto.getCustNo() + "'");
        if (rs.next()) {
            String custId = rs.getString("CUSTOMER_ID");
            modelNDto.setCustId(custId);
            String custName = rs.getString("CUSTOMER_NAME");
            modelNDto.setCustName(custName);
//            System.out.println("xxx="+modelNDto.getCustId());
            checkErpCustInfo();
//            salesCheckMechanism().getTest();
//            System.out.println("getTransportation="+modelNDto.getTransportation());
        } else {
            modelNDto.setErrorMsg(appendErrMsg("ERP查無客戶資訊"));
//            this.errList.add("ERP查無客戶資訊");
        }
    }

    private static void checkErpCustInfo() throws SQLException {
        if (salesNo.equals("006")) {
//            TsctDisty_006 tsctDisty006 = new TsctDisty_006();
            checkSalesErpInfo();
        } else if (salesNo.equals("005")) {
            setShippingFobOrderTypeInfo();
        }
    }

    public static void checkSalesErpInfo() throws SQLException {
        String sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO'" +
                " then 2 else 3 end as segno,\n" + //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,\n" +
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a" +
                ".FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE\n" +
                " ,a.tax_code \n" +
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, " +
                "RA_TERMS_VL c \n" +
                " ,SO_PRICE_LISTS d\n" +
                " where  a.ADDRESS_ID = b.cust_acct_site_id \n" +
                " AND b.party_site_id = party_site.party_site_id \n" +
                " AND loc.location_id = party_site.location_id \n" +
                " and a.STATUS='A' \n" +
                " and a.PRIMARY_FLAG='Y' \n" +
                " and b.CUST_ACCOUNT_ID ='" + modelNDto.getCustId() + "' \n" +
                " and a.PAYMENT_TERM_ID = c.TERM_ID(+) \n" +
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+) \n" +
                " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' " +
                "then 2 else 3 end ";
        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        while (rs.next()) {
            if (modelNDto.getShippingMethod().equals("") && rs.getString("ship_via") != null) {
                modelNDto.setShippingMethod(rs.getString("ship_via"));
            }
            if (modelNDto.getFob().equals("") && rs.getString("FOB_POINT") != null) {
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

    private static ResultSet getFndLookupValuesData() throws SQLException {
        String sql = " SELECT lookup_code,meaning FROM fnd_lookup_values lv" +
                " WHERE language = 'US'" +
                " AND view_application_id = 3" +
                " AND lookup_type = 'SHIP_METHOD'" +
                " AND security_group_id = 0" +
                " AND ENABLED_FLAG='Y'" +
                " AND (end_date_active IS NULL OR end_date_active > SYSDATE)";
        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        return stmt.executeQuery(sql);
    }

    public static void setShippingFobOrderTypeInfo() throws SQLException {
        String sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO'" +
                " then 2 else 3 end as segno," + //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
                " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1," +
                " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a" +
                ".FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE" +
                " ,a.tax_code" +
                " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, " +
                "RA_TERMS_VL c" +
                " ,SO_PRICE_LISTS d" +
                " where  a.ADDRESS_ID = b.cust_acct_site_id" +
                " AND b.party_site_id = party_site.party_site_id" +
                " AND loc.location_id = party_site.location_id " +
                " and a.STATUS='A' " +
                " and b.CUST_ACCOUNT_ID ='" + modelNDto.getCustId() + "'" +
                " and a.PAYMENT_TERM_ID = c.TERM_ID(+)" +
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)";
        if (!modelNDto.getShipToLocationId().equals("")) {
            sql += " and a.LOCATION='" + modelNDto.getShipToLocationId() + "'";
        } else if (modelNDto.getCustNo().equals("14413")) {
            if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0, 9).equals("CCPG01518")) ||
                    (modelNDto.getCustPo().length() >= 10 && modelNDto.getCustPo().substring(0, 10).equals(
                            "CCPF2300TB"))) &&
                    modelNDto.getCustPo().equals("1214")) {
                sql += " and a.site_use_id = 50156";
            } else if (((modelNDto.getCustPo().length() >= 9 && modelNDto.getCustPo().substring(0, 9).equals(
                    "CCPG01511")) ||
                    (modelNDto.getCustPo().length() >= 10 && (modelNDto.getCustPo().substring(0, 10).equals(
                            "CCPM121002") ||
                            modelNDto.getCustPo().substring(0, 10).equals("CCPF2301TB")))) &&
                    modelNDto.getCustPo().equals("1214")) {
                sql += " and a.site_use_id = 61410";
            } else if (modelNDto.getCustPo().substring(0, 3).equals("CCP")) {
                sql += " and a.site_use_id = 50156";
            } else if (modelNDto.getCustPo().substring(0, 3).equals("TPH")) {
                sql += " and a.site_use_id =65370";
            } else if (modelNDto.getCustPo().substring(0, 3).equals("FLC")) {
                sql += " and a.site_use_id = 65370";
            } else {
                sql += " and a.site_use_id = 31918";
            }
        } else if (modelNDto.getCustNo().equals("1671")) {
            sql += " and a.site_use_id = 4520";
        } else if (modelNDto.getCustNo().equals("1067")) {
            sql += " and a.site_use_id = 1328";
        } else if (modelNDto.getCustNo().equals("24051")) {
            if (modelNDto.getCustNo().substring(0, 3).equals("CIF") && modelNDto.getOrderType().equals("1141")) {
                sql += " and a.site_use_id = 56522";
            } else {
                sql += " and a.site_use_id = 52174";
            }
        } else {
            sql += " and a.PRIMARY_FLAG='Y'";
        }
        sql += " order by case when upper(a.site_use_code)='BILL_TO' then 2 when upper(a.site_use_code)='SHIP_TO' " +
                "then 1 else 3 end ";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        ResultSet lookValuesRs = getFndLookupValuesData();
        while (rs.next()) {
            if (modelNDto.getShippingMethod().equals("") && rs.getString("ship_via") != null) {
                if (lookValuesRs.isBeforeFirst() == false) lookValuesRs.beforeFirst();
                while (lookValuesRs.next()) {
                    if (lookValuesRs.getString("LOOKUP_CODE").equals(rs.getString("ship_via"))) {
                        modelNDto.setShippingMethod(rs.getString("ship_via"));
                        modelNDto.setTransportation(lookValuesRs.getString("MEANING"));
                        break;
                    }
                }
            }
            if (modelNDto.getFob().equals("") && rs.getString("FOB_POINT") != null) {
                modelNDto.setFob(rs.getString("FOB_POINT"));
            }
            if (modelNDto.getOrderType().equals("1141") && !rs.getString("CURRENCY_CODE").equals("USD")) {
                modelNDto.setOrderType("1131");
            }
            if (rs.getString("SITE_USE_CODE").equals("SHIP_TO")) {
                modelNDto.setShipToOrgId(rs.getString("SITE_USE_ID"));
            }
        }
        rs.close();
        stmt.close();
    }

    private static void checkCustomerPo() throws SQLException {
        //檢查customerNo 和 customerPo 是否有待處理資料
        if (modelNDto.getCustNo() != null && !modelNDto.getCustNo().equals("")
                && modelNDto.getCustPo() != null && !modelNDto.getCustPo().equals("")) {
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(
                    "select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where SALESAREANO = '" + salesNo + "' \n" + "" +
                            " and CUSTOMER_NO ='" + modelNDto.getCustNo() + "' AND CUSTOMER_PO='" + modelNDto.getCustPo() + "' AND CREATE_FLAG='N'");
            if (rs.next()) {
                modelNDto.setErrorMsg(appendErrMsg("Pending Detail已存在此客戶+PO資料!"));
//                this.errList.add("Pending Detail已存在此客戶+PO資料!");
            }
            rs.close();
            statement.close();
        }
    }

    private static void readExcelContent() throws SQLException {
        for (Iterator it = map.entrySet().iterator(); it.hasNext(); ) {
            errList = new LinkedList();
            endCustName = "";
            Map.Entry entry = (Map.Entry) it.next();
            rowIndex = ((Integer) entry.getKey()).intValue();
            modelNDto = (ModelNDto) entry.getValue();

            // 檢查Excel客戶代號
            if (modelNDto.getCustNo() == null || modelNDto.getCustNo().equals("")) {
                modelNDto.setErrorMsg(appendErrMsg("客戶代號不可空白"));
//                this.errList.add("客戶代號不可空白");
            } else {
                // 取得table CustId 和 CustName
                checkCustIdAndName();
            }
            // 檢查Excel CustomerPO
            if (modelNDto.getCustPo() == null || modelNDto.getCustPo().equals("")) {
                modelNDto.setErrorMsg(appendErrMsg("Customer PO不可空白"));
//                this.errList.add("Customer PO不可空白");
            } else {
                // 檢查table客戶+customer po是否有待處理資料
                checkCustomerPo();
            }
            // 檢查Excel台半料號/品名及客戶料號
            if ((modelNDto.getTscItemDesc() == null || modelNDto.getTscItemDesc().equals(""))
                    && (modelNDto.getCustItem() == null || modelNDto.getCustItem().equals(""))
                    && (modelNDto.getTscItem() == null || modelNDto.getTscItem().equals(""))) {
                modelNDto.setTscItem("");
                modelNDto.setTscItemDesc("");
                modelNDto.setCustItem("");
                modelNDto.setErrorMsg(appendErrMsg("台半料號/品名及客戶料號不可同時空白"));
//                errList.add("台半料號及客戶料號不可同時空白");
            } else {
                // 檢查table台半料號及客戶料號在ERP是否存在
                checkTscAndCustPartNo();
            }
            checkCorrectOrderTypeId();
            checkQty();
            checkSellingPrice();
            checkSSD();
            checkShippingMethod();
            checkFOB();
            checkRemarks();
            setDefaultLineType();
            // 檢查Excel End Customer Number
            if (!modelNDto.getEndCustNo().equals("")) {
                //end customer number 不可與 customer number 相同
                if (modelNDto.getEndCustNo().equals(modelNDto.getCustNo())) {
                    modelNDto.setErrorMsg(appendErrMsg("End Customer Number不可與Customer Number相同"));
//                    this.errList.add("End Customer Number不可與Customer Number相同");
                } else {
                    // 檢查客戶ID在ERP是否存在
                    checkEndCustNumber();
                }
            } else if (!endCustName.equals("")) {
                modelNDto.setEndCustNamePhonetic(endCustName);
            }
//            System.out.println("xxxx=" + modelNDto.getEndCustNamePhonetic());
//            System.out.println("mo="+errList2String(modelNDto.getErrorList()));
        }
//        insertIntoTscRfqUploadTmp(connection, map);
//        if (currentRow != rowIndex) {
//            errList = new ArrayList();
//        }
//        currentRow = rowIndex;
        StringBuffer result = new StringBuffer();
        for (int i = 0; i < errList.size(); i++) {
            if (i < errList.size() - 1) {
                result.append(errList.get(i)).append("<br>");
            } else {
                result.append(errList.get(i));
            }
//            System.out.println("xxx="+result.toString());
        }
//        System.out.println("rowIndex="+rowIndex);
//        System.out.println("currentRow="+currentRow);
//        System.out.println("xxx="+result.toString());
    }


    private static void setDefaultLineType() throws SQLException {
        if (salesNo.equals(TSCTDA.getSalesNo())
                && modelNDto.getOrderType().equals("1131")
                && modelNDto.getTscItemDesc().toLowerCase().contains("wafer".toLowerCase())) {
            System.out.println("Found: " + modelNDto.getTscItemDesc());
        } else {
            Statement statement = conn.createStatement();
            String sql = "select DEFAULT_ORDER_LINE_TYPE from ORADDMAN.TSAREA_ORDERCLS c  where c.SAREA_NO = '" + salesNo + "' \n" +
                    "and c.ORDER_NUM='" + modelNDto.getOrderType() + "'";
            ResultSet rs = statement.executeQuery(sql);
            if (rs.next()) {
                modelNDto.setLineType(rs.getString("DEFAULT_ORDER_LINE_TYPE"));
            } else if (salesNo.equals(TSCTDA.getSalesNo()) && modelNDto.getOrderType().equals("1131")) {
                System.out.println("Xxxxxx");
            } else {
                modelNDto.setLineType("0");
            }
            rs.close();
            statement.close();
        }
    }

    private static void checkSellingPrice() {
        if (modelNDto.getSellingPrice() == null || modelNDto.getSellingPrice().equals("")) {
            if (sellingPrice_Q == null || sellingPrice_Q.equals("")) {
                modelNDto.setSellingPrice("");
//                modelNDto.setErrorMsg(appendErrMsg("Selling Price不可空"));
                errList.add("Selling Price不可空");
                modelNDto.setErrorList(errList);
            } else {
                modelNDto.setSellingPrice(sellingPrice_Q);
            }
        } else {
            try {
                double priceNumber = Double.parseDouble(modelNDto.getSellingPrice().replace(",", ""));
                if (priceNumber <= 0) {
//                    modelNDto.setErrorMsg(appendErrMsg("Selling Price必須大於零"));
                    errList.add("Selling Price必須大於零");
                    modelNDto.setErrorList(errList);
                } else if (!modelNDto.getQuoteNumber().equals("")) {  // excel QuoteNumber 不為空時才會做檢查
                    if (!modelNDto.getSellingPrice().equals(sellingPrice_Q)) {
                        System.out.println("getSellingPrice=" + modelNDto.getSellingPrice());
                        System.out.println("sellingPrice_Q=" + sellingPrice_Q);
                        errList.add("Selling Price not match quote price(" + sellingPrice_Q + ")");
                        modelNDto.setErrorList(errList);
                    }
                } else {
                    modelNDto.setSellingPrice((new DecimalFormat("###,##0.000##")).format(priceNumber));
                }
            } catch (Exception e) {
//                modelNDto.setErrorMsg(appendErrMsg("單價格式錯誤"));
                errList.add("單價格式錯誤");
                modelNDto.setErrorList(errList);
            }
        }
    }


    //檢查單價
//    private static void checkSellingPrice() {
//        if (modelNDto.getSellingPrice() == null || modelNDto.getSellingPrice().equals("")) {
//            modelNDto.setSellingPrice("");
////            modelNDto.setErrorMsg(appendErrMsg("Selling Price不可空"));
//            errList.add("Selling Price不可空白");
//        } else {
//            try {
//                double priceNumber = Double.parseDouble(modelNDto.getSellingPrice().replace(",", ""));
//                if (priceNumber <= 0) {
////                    modelNDto.setErrorMsg(appendErrMsg("Selling Price必須大於零"));
//                    errList.add("Selling Price必須大於零");
//                } else {
//                    modelNDto.setSellingPrice((new DecimalFormat("###,##0.000##")).format(priceNumber));
//                }
//            } catch (Exception e) {
////                modelNDto.setErrorMsg(appendErrMsg("單價格式錯誤"));
//                errList.add("單價格式錯誤");
//            }
//        }
//    }

    //檢查交貨日期(SSD or Request Date)
    private static void checkSSD() {
        if (modelNDto.getSsd() == null || modelNDto.getSsd().equals("")) {
            modelNDto.setSsd("&nbsp;");
            modelNDto.setErrorMsg(appendErrMsg("SSD不可空白"));
//            this.errList.add("Request Date不可空白");
        }
//        else if (Long.parseLong(modelNDto.getSsd()) <= Long.parseLong(checkDate)) {
//            modelNDto.setErrorMsg(appendErrMsg("SSD" + modelNDto.getSsd() + "必須大於" + checkDate));
////            this.errList.add("Request Date" + modelNDto.getSsd() + "必須大於" + checkDate);
//        }
    }

    //檢查出貨方式
    private static void checkShippingMethod() {
        if (modelNDto.getShippingMethod() == null || modelNDto.getShippingMethod().equals("")) {
            modelNDto.setSsd("");
            modelNDto.setErrorMsg(appendErrMsg("出貨方式不可空白"));
        }
    }

    // 檢查FOB
    private static void checkFOB() {
        if (modelNDto.getFob() == null || modelNDto.getFob().equals("")) {
            modelNDto.setFob("&nbsp;");
            modelNDto.setErrorMsg(appendErrMsg("FOB不可空白"));
//            this.errList.add("FOB不可空白");
        }
    }

    // 檢查REMARKS
    private static void checkRemarks() {
        if (modelNDto.getRemarks() == null || modelNDto.getRemarks().equals("")) {
            modelNDto.setRemarks("");
        }
    }

    // 檢查 End Customer Number
    private static void checkEndCustNumber() throws SQLException {
        String sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC \n" +
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

        Statement statements = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = statements.executeQuery(sql);

        if (rs.isBeforeFirst() == false) rs.beforeFirst();
        while (rs.next()) {
            if (rs.getString("customer_number").equals(modelNDto.getEndCustNo())) {
                modelNDto.setEndCustNamePhonetic(rs.getString("CUSTOMER_NAME_PHONETIC"));
                modelNDto.setEndCustId(String.valueOf(rs.getInt("customer_id")));
                break;
            }
        }
        if (modelNDto.getEndCustNamePhonetic().equals("")) {
            modelNDto.setErrorMsg(appendErrMsg("End Customer ID不存在ERP"));
//            this.errList.add("End Customer ID不存在ERP");
        }
    }

    private static void checkQty() {
        if (modelNDto.getQty() == null || modelNDto.getQty().equals("")) {
            modelNDto.setQty("");
            modelNDto.setErrorMsg(appendErrMsg("數量不可空白"));
//            errList.add("數量不可空白");
        } else {
            try {
                double qtyNumber = Double.parseDouble(modelNDto.getQty().replace(",", ""));
                if (qtyNumber <= 0) {
//                    modelNDto.setErrorMsg(appendErrMsg("數量必須大於零"));
//                    errList.add("數量必須大於零");
                } else {
                    modelNDto.setQty((new DecimalFormat("#######0.0##")).format(qtyNumber));
                }
            } catch (Exception e) {
                modelNDto.setErrorMsg(appendErrMsg("數量格式錯誤"));
//                errList.add("數量格式錯誤");
            }
        }
    }

    //檢查訂單類型是否正確
    private static void checkCorrectOrderTypeId() throws SQLException {
        String sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b \n" +
                " where b.order_num=a.order_num and a.order_num='" + modelNDto.getOrderType() + "' and a.sarea_no ='" + salesNo + "'" +
                " and a.active='Y'\n" +
                " and b.MANUFACTORY_NO='" + modelNDto.getManuFactoryNo() + "' and b.ACTIVE='Y'";
        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        if (!rs.next()) {
            modelNDto.setErrorMsg(appendErrMsg("訂單類型錯誤"));
        } else {
            modelNDto.setOrderTypeId(rs.getString(1));
        }
        rs.close();
        statement.close();
    }

    private static void checkTscAndCustPartNo() throws SQLException {
        int recordCount = 0;
        if (modelNDto.getCustItem() != null && !modelNDto.getCustItem().equals("")) {
            String sql = "select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,\n" +
                    "a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE\n" +
                    ",NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3\n" +
                    ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE  \n" +
                    ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + //
                    // quote 使用
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
                    "and a.ITEM = '" + modelNDto.getCustItem() + "'";
            if (modelNDto.getTscItemDesc() != null && !modelNDto.getTscItemDesc().equals("")) {
                sql += " and a.ITEM_DESCRIPTION = '" + modelNDto.getTscItemDesc() + "'";
            }
            if (modelNDto.getTscItem() != null && !modelNDto.getTscItem().equals("")) {
                sql += " and a.INVENTORY_ITEM = '" + modelNDto.getTscItem() + "'";
            }
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                modelNDto.setTscItem(rs.getString("INVENTORY_ITEM"));
                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                modelNDto.setTscItemDesc(rs.getString("ITEM_DESCRIPTION"));
                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                itemNoPacking = rs.getString("itemnopacking");
                if (modelNDto.getOrderType() == null || modelNDto.getOrderType().equals("")) {
                    modelNDto.setOrderType(rs.getString("ORDER_TYPE"));
                } else if (modelNDto.getOrderType().equals("1156")) {
                    modelNDto.setManuFactoryNo("002");
                }
                recordCount++;
            }
            rs.close();
            statement.close();
            if (recordCount == 0) {
                modelNDto.setErrorMsg(appendErrMsg("客戶料號在ERP不存在!"));
            }
        } else if ((modelNDto.getTscItemDesc() != null && !modelNDto.getTscItemDesc().equals(""))
                || (modelNDto.getTscItem() != null && !modelNDto.getTscItem().equals(""))) {
            String sql = "SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,\n" +
                    "NVL (msi.attribute3, 'N/A') attribute3,\n" +
                    "tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type\n" +
                    ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + //
                    // quote 使用
                    "FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c\n" +
                    "WHERE msi.inventory_item_id = c.inventory_item_id\n" +
                    "AND msi.organization_id = c.organization_id\n" +
                    "AND msi.organization_id = '49'\n" +
                    "AND c.category_set_id = 6\n" +
                    "AND msi.inventory_item_status_code <> 'Inactive'\n" +
                    "AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'\n" +
                    "AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'\n" +
                    "AND msi.description =  nvl('" + modelNDto.getTscItemDesc() + "',msi.description)\n" +
                    "AND msi.segment1 = nvl('" + modelNDto.getTscItem() + "',msi.segment1)";
            Statement statement = conn.createStatement();
            ResultSet rs = statement.executeQuery(sql);
            while (rs.next()) {
                modelNDto.setTscItem(rs.getString("segment1"));
                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                modelNDto.setTscItemDesc(rs.getString("description"));
                modelNDto.setCustItem("");
                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                itemNoPacking = rs.getString("itemnopacking");
                if (modelNDto.getOrderType() == null || modelNDto.getOrderType().equals("")) {
                    modelNDto.setOrderType(rs.getString("ORDER_TYPE"));
                } else if (modelNDto.getOrderType().equals("1156")) {
                    modelNDto.setManuFactoryNo("002");
                }
                recordCount++;
            }
            rs.close();
            statement.close();
            if (recordCount == 0) {
                modelNDto.setErrorMsg(appendErrMsg("台半料號在ERP不存在!"));
            }
        }
        if (recordCount > 1) {
            modelNDto.setErrorMsg(appendErrMsg("對應的台半料號超過一個以上,請選擇正確台半料號!"));
        } else {
            if (!modelNDto.getQuoteNumber().equals("") && !modelNDto.getTscItemDesc().equals("")) {
                Statement stmt = conn.createStatement();
                String sql = " select a.quoteid, a.partnumber,a.currency, to_char(a.pricekusd/1000,'FM99990.0999999')" +
                        " price_usd, \n" +
                        "'('|| a.region ||')'|| a.endcustomer end_customer \n" +
                        " from tsc_om_ref_quotenet a \n" +
                        " where a.quoteid='" + modelNDto.getQuoteNumber() + "' \n" +
                        " and a.partnumber='" + modelNDto.getTscItemDesc() + "' \n" +
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
                    sql = " select a.quoteid, a.partnumber,a.currency, to_char(a.pricekusd/1000,'FM99990.0999999') " +
                            "price_usd, \n" +
                            "'('|| a.region ||')'|| a.endcustomer end_customer \n" +
                            " from tsc_om_ref_quotenet a \n" +
                            " where a.quoteid='" + modelNDto.getQuoteNumber() + "' \n" +
                            " and a.partnumber like '" + itemNoPacking + "%' \n" +
                            " order by a.quoteid, a.partnumber";
                    rs = stmt.executeQuery(sql);
                    if (rs.next()) {
                        sellingPrice_Q = rs.getString("PRICE_USD");
                        endCustName = rs.getString("END_CUSTOMER");
                    }
                    rs.close();
                    stmt.close();
                }
            }
        }
    }

}
