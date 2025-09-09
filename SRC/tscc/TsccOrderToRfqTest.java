package tscc;

import bean.ConnUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mysql.jdbc.StringUtils;
import commonUtil.ToRfqParams;
import commonUtil.uriUtil.UriBuilderUtil;
import modelN.DetailColumn;
import tscc.dao.impl.TsccOrderToRfqImpl;
import tscc.dto.TsccOrderToRfqDto;

import javax.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class TsccOrderToRfqTest {

    private static final Gson gson = new GsonBuilder()
            .disableHtmlEscaping() // 防止 HTML 特殊字元被轉義（如 < 變成 \u003c）
            .create();

    public static HashMap<Integer, List<TsccOrderToRfqDto>> getDetailMap() {
        return detailMap;
    }

    private static Connection conn;
    public static String[] detailHeaderColumns = new String[]{};
    public static HashMap<String, Integer> detailHeaderHtmlWidthMap = new LinkedHashMap<>();
    private static TsccOrderToRfqDto tsccOrderToRfqDto;
    //    public static HashMap detailMap = new LinkedHashMap();
    public static HashMap<Integer, List<TsccOrderToRfqDto>> detailMap = new LinkedHashMap<>();
    public static Map<Integer, List<?>> filterDtoMap = new LinkedHashMap<>();
    public static List<TsccOrderToRfqDto> dtoList = new LinkedList<>();
    public static List<String> errList = new ArrayList<String>();

    static {
        try {
            conn = ConnUtils.getConnectionCRP();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static TsccOrderToRfqImpl tsccOrderToRfqImpl() {
        return new TsccOrderToRfqImpl();
    }

    public static boolean checkPermission(String userName) throws SQLException {
        String[] salesNos = {"010", "002", "012", "018", "022", "023"};
        String placeholders = String.join(",", java.util.Collections.nCopies(salesNos.length, "?"));
        String sql = " SELECT 1 FROM oraddman.tsrecperson a  where USERNAME=? AND TSSALEAREANO in (" + placeholders + ")";
        PreparedStatement statement = conn.prepareStatement(sql);
        statement.setString(1, userName);
        // 設定 TSSALEAREANO 清單
        for (int i = 0; i < salesNos.length; i++) {
            statement.setString(i + 2, salesNos[i]); // offset +1 因為USERNAME是第1個
        }
        ResultSet rs1 = statement.executeQuery();
        return rs1.next();
    }

    public static String[] getDetailHeaderColumns() {
        String groupBy = DetailColumn.GroupBy.getColumnName();   // 新增到最後面
        detailHeaderColumns = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.ShipToId.getColumnName(), DetailColumn.RFQType.getColumnName(),
                DetailColumn.CustomerPO.getColumnName(), DetailColumn.TSC_PN.getColumnName(), DetailColumn.Customer_PN.getColumnName(),
                DetailColumn.Qty.getColumnName(), DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.OrderType.getColumnName(), DetailColumn.ShippingMethod.getColumnName(), DetailColumn.FOB.getColumnName(),
                DetailColumn.CustomerPOLine.getColumnName(),DetailColumn.EndCustomerNumber.getColumnName(),
                DetailColumn.EndCust.getColumnName(), DetailColumn.UploadBy.getColumnName(), DetailColumn.UploadDate.getColumnName()
        };

        // 建立新陣列，長度多 1
        String[] newArray = Arrays.copyOf(detailHeaderColumns, detailHeaderColumns.length + 1);
        // 新字串放在最後一個位置
        newArray[newArray.length - 1] = groupBy;
        return newArray;
    }

    public static HashMap<String, Integer> getDetailHeaderHtmlWidthMap() {
        detailHeaderHtmlWidthMap = new HashMap<String, Integer>();
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
                case CustomerPOLine:
                    detailHeaderHtmlWidthMap.put(columnKey, 7);
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

        LinkedHashMap<String, Integer> map = new LinkedHashMap<>(detailHeaderHtmlWidthMap); // 加入原有內容
        map.put("Group By", 0);    // 新增到最後面
        return map;
    }

    public static void main(String[] args) {
        List lineNoList= Arrays.asList("6578295", "6583287");
//        String result = String.join(",", lineNoList);
        String result = "('" + String.join("','", lineNoList) + "')";

        System.out.println("lineNoList="+lineNoList); // 6578295,6583287

        System.out.println(result); // 6578295,6583287
    }
    public static void main23(String[] args) throws SQLException, JsonProcessingException, UnsupportedEncodingException {
        tsccOrderToRfqImpl().setPolicyContext(conn, null);
        detailMap = new LinkedHashMap();
//        System.out.println("xxxx=" + checkPermission("mars.wang"));
        Map<Integer, TsccOrderToRfqDto> map = tsccOrderToRfqImpl().getOrderToRfq(conn, "4979177", null, null);
        for (Map.Entry<Integer, TsccOrderToRfqDto> tsccOrderToRfqDtoEntry : map.entrySet()) {
            Map.Entry<Integer, TsccOrderToRfqDto> en = tsccOrderToRfqDtoEntry;
            HashMap<String, String> keyValueMap = new LinkedHashMap<>();
            List list = new LinkedList();
            int rowIndex = en.getKey();
            tsccOrderToRfqDto = en.getValue();
            getShippingMarksAndRemarks(tsccOrderToRfqDto.getSalesNo());
            getShippingFobOrderTypeInfo();
            getBiRegionData();
            checkColumnsRulesAndShowErrMsg();
//            dtoList.add(tsccOrderToRfqDto);
//            detailMap.put(rowIndex, tsccOrderToRfqDto);
            list.add(tsccOrderToRfqDto);

//            System.out.println("getShipToOrgId="+tsccOrderToRfqDto.getShipToOrgId());
//            System.out.println("getBiRegion="+tsccOrderToRfqDto.getBiRegion());

            for (int i = 0, n= getDetailHeaderColumns().length; i < n; i++) {
                String column = getDetailHeaderColumns()[i];
                switch (DetailColumn.settingDetailColumn(column, i)) {
                    case CustomerName:
                        keyValueMap.put(column, tsccOrderToRfqDto.getSupplyCustomerName());
                        break;
                    case RFQType:
                        keyValueMap.put(column, "NORMAL");
                        break;
                    case CustomerPO:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCustPoLineNo());
                        break;
                    case TSC_PN:
                        keyValueMap.put(column, tsccOrderToRfqDto.getItemDesc());
                        break;
                    case CustomerItem:
                    case Customer_PN:
                        keyValueMap.put(column, tsccOrderToRfqDto.getOrderedItem());
                        break;
                    case Qty:
                        keyValueMap.put(column, tsccOrderToRfqDto.getRfqQty());
                        break;
                    case SellingPrice:
                        keyValueMap.put(column, tsccOrderToRfqDto.getUnitPrice());
                        break;
                    case SSD:
                        keyValueMap.put(column, tsccOrderToRfqDto.getRequestDate());
                        break;
                    case ShippingMethod:
                        keyValueMap.put(column, tsccOrderToRfqDto.getShippingMethod());
                        break;
                    case FOB:
                        keyValueMap.put(column, tsccOrderToRfqDto.getFob());
                        break;
                    case CustomerPOLine:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCustPoLineNo());
                        break;
                    case OrderType:
                        keyValueMap.put(column, tsccOrderToRfqDto.getOrderType());
                        break;
                    case EndCustomerNumber:
                        keyValueMap.put(column, tsccOrderToRfqDto.getTsccCustomerNumber());
                        break;
                    case EndCustomer:
                    case EndCust:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCustomerNamePhonetic());
                        break;
                    case ShipTo:
                    case ShipToId:
                        keyValueMap.put(column, tsccOrderToRfqDto.getShipToOrgId());
                        break;
                    case UploadBy:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCreatedBy());
                        break;
                    case UploadDate:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCreationDate());
                        break;
//                    case GroupBy:
//                        keyValueMap.put(column, "byCustNo");
//                        break;
                    default:
                        break;
                }
            }
            list.add(keyValueMap);
            detailMap.put(rowIndex, list);
        }

        List<TsccOrderToRfqDto> dtoList = detailMap.values().stream()
                .map(list -> (TsccOrderToRfqDto) list.get(0))  // 只取每筆的第一個物件，並轉型
                .collect(Collectors.toList());


        // 過濾掉 key = 1 的完整 List（保留整個 List<TsccOrderToRfqDto>）
         detailMap.entrySet().stream()
                .filter(entry -> entry.getKey() == 1)
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        Map.Entry::getValue,
                        (a, b) -> b,
                        LinkedHashMap::new
                ));
//        detailMap.clear();

   //  放入過濾後的完整 List
//        System.out.println("detailMap="+detailMap);
//        detailMap.get(1);
//        detailMap.remove(1);
//        System.out.println("filterDtoMap="+detailMap);

        for (Iterator it = detailMap.entrySet().iterator(); it.hasNext();) {
            errList = new LinkedList<>();
            Map.Entry entry = (Map.Entry) it.next();
            int index = (Integer) entry.getKey();
            List objectList = (LinkedList) entry.getValue();
//            System.out.println("objectList="+objectList);
//            System.out.println("111="+objectList.get(0));
//            System.out.println("222="+objectList.get(1));
//            tsccOrderToRfqDto = (TsccOrderToRfqDto) objectList.get(1);
        }

//        System.out.println("valuesList="+valuesList.get(0).get(0));

        String targetShipToId = "68813";

        System.out.println("be="+detailMap.keySet());
        filterDtoMap = filterByFieldValue("Ship to ID", targetShipToId);
//        detailMap.entrySet().removeIf(entry -> {
//            List<TsccOrderToRfqDto> list = entry.getValue();
//            System.out.println("list="+list);
//            if (list.size() > 0 && list.get(1) instanceof Map) {
//                Map<Integer, List<TsccOrderToRfqDto>> dataMap = (Map<Integer, List<TsccOrderToRfqDto>>) list.get(1);
//                Object shipToId = dataMap.get("Ship to ID");
//                return targetShipToId.equals(shipToId);
//            }
//            return false;
//        });

        System.out.println("after="+filterDtoMap.keySet());

        String[][][] result = buildStringAndCheckMatrix();
        String[][] values = result[0];
        String[][] checks = result[1];

//        sendRedirect2DRQCreate(null);

//        for (int j = 0, k = list.size(); j < k; j++) {
//            List dtoList = (List)integerListEntry.getValue();
//        for (int j = 0, k = list.size(); j < k; j++) {
//             errList = new LinkedList<>();
//            tsccOrderToRfqDto = (TsccOrderToRfqDto) list.get(j);
//        }
//            tsccOrderToRfqDto = integerListEntry.getValue();
//            System.out.println("getOrderedItemId="+tsccOrderToRfqDto.getOrderedItemId());
//            System.out.println("Xxx="+writeValueToString());
//            System.out.println("toJson="+toJson());
//            list.add(tsccOrderToRfqDto);
//            System.out.println("getShippingMarks"+tsccOrderToRfqDto.getShippingMarks());
//            System.out.println("getRemarks="+tsccOrderToRfqDto.getRemarks());
//        System.out.println("dtoList="+gson.toJson(dtoList));
    }


//        TsccOrderToRfqDto tsccOrderToRfqDto = new TsccOrderToRfqDto();
//        for (Map.Entry<Integer, List<TsccOrderToRfqDto>> integerListEntry : detailMap.entrySet()) {
//            Map.Entry<Integer, List<TsccOrderToRfqDto>> entry = integerListEntry;
//            int index = entry.getKey();
//            List objectList = entry.getValue();
//            for (Object o : objectList) {
//                tsccOrderToRfqDto = (TsccOrderToRfqDto) o;
//                System.out.println("tsccOrderToRfqDto=" + tsccOrderToRfqDto);
//            }
//        }
//        System.out.println("xxx="+detailMap);
//    }

    public static Map<Integer, List<?>> filterByFieldValue(String fieldName, String targetValue) {
        return detailMap.entrySet()
                .stream()
                .filter(entry -> {
                    List<TsccOrderToRfqDto> list = entry.getValue();
                    if (list.size() > 0 && list.get(0) != null) {
                        TsccOrderToRfqDto dto = list.get(0);
                        Object fieldValue = dto.getTsccOrderStatus();
                        // 保留不等於 targetValue 的資料
                        return !"AWAITING_RFQ".equals(fieldValue);
                    }
                    return true;
                })
                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
    }

//    public static Map<Integer, List<?>> filterByFieldValue(String fieldName, String targetValue) {
//        return detailMap.entrySet()
//                .stream()
//                .filter(entry -> {
//                    List<TsccOrderToRfqDto> list = entry.getValue();
//                    if (list.size() > 1 && list.get(0) instanceof Map) {
//                        Map<?, ?> dataMap = (Map<?, ?>) list.get(0);
//                        Object fieldValue = dataMap.get(fieldName);
//                        // 保留不等於 targetValue 的資料
//                        return !targetValue.equals(fieldValue);
//                    }
//                    return true;
//                })
//                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
//    }

    public static void sendRedirect2DRQCreate(HttpServletResponse response) {
        TsccOrderToRfqDto dto = detailMap.get(1).get(0);
        String customerPo = dto.getCustPoNumber();
        String orderTypeId = dto.getOtypeId();
        String orderType = dto.getOrderType();
        String customerId = dto.getSupplyCustomerId();
        String currency = dto.getCurrency();
        String salesPersonId = dto.getSalesrepId();
        String salesPerson = dto.getSalesrepName();
        String salesNo = dto.getSalesNo();

        String[] paramsKeys = new String[]{ToRfqParams.CUSTOMERID.name(), ToRfqParams.SPQCHECKED.name(),
                ToRfqParams.SALESAREANO.name(), ToRfqParams.SALESPERSON.name(),
                ToRfqParams.TOPERSONID.name(), ToRfqParams.CUSTOMERPO.name(), ToRfqParams.CURR.name(),
                ToRfqParams.PREORDERTYPE.name(),
                ToRfqParams.CUSTOMERIDTMP.name(), ToRfqParams.INSERT.name(), ToRfqParams.RFQTYPE.name(),
                ToRfqParams.PROGRAMNAME.name()};

        String[] paramsValues = new String[]{customerId, "Y", salesNo, salesPerson,
                salesPersonId, customerPo, currency, orderTypeId,
                customerId, "Y", "NORMAL", "TSCC"};

//        Map<String, String> result = new LinkedHashMap<>();
//        for (int j = 0; j < paramsKeys.length; j++) {
//            result.put(paramsKeys[j], paramsValues[j]);
//        }

        Map<String, String> result =
                IntStream.range(0, paramsKeys.length)
                        .boxed()
                        .collect(Collectors.toMap(index -> paramsKeys[index], index -> paramsValues[index],
                                (a, b) -> b, LinkedHashMap::new));
        String urlDir = UriBuilderUtil.buildUrlWithParams("TSSalesDRQ_Create.jsp", result);
        try {
//            response.sendRedirect(urlDir);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error:" + e.getMessage());
        }
    }

    public static String[][][] buildStringAndCheckMatrix() {
        List<List<String>> valueList = new LinkedList<>();
        List<List<String>> checkList = new LinkedList<>();

        for (Map.Entry<Integer, List<TsccOrderToRfqDto>> entry : detailMap.entrySet()) {
            List<String> row = new LinkedList<>();
            String rowNo = String.valueOf(entry.getKey());
            TsccOrderToRfqDto createRfqDto = entry.getValue().get(0);
//            TsccOrderToRfqDto createRfqDto = setShippingAndFob(entry.getValue().get(0));
//
            String custPo = createRfqDto.getCustPoLineNo();
//            if (!createRfqDto.getTsccCustomerNumber().equals("23075") &&
//                    !createRfqDto.getTsccCustomerNumber().equals("23125") &&
//                    !createRfqDto.getTsccCustomerNumber().equals("23174")) {
//                custPo = createRfqDto.getCustPoNumber() + "(" + createRfqDto.getCustomerNamePhonetic() + ")";
//            } else {
//                custPo = createRfqDto.getCustPoLineNo();
//            }

            row.add(rowNo);                                                                                           // 0: 序號
            row.add(createRfqDto.getItemName());                                                                      // 1: 料號
            row.add(createRfqDto.getItemDesc());                                                                      // 2: 品名
            row.add(createRfqDto.getRfqQty());                                                                        // 3: 數量
            row.add("KPC");                                                                                           // 4: 數量單位
            row.add("");                                                                                              // 5 CRD
            row.add(createRfqDto.getShippingMethod());                                                                // 6: 出貨方式
            row.add(createRfqDto.getRequestDate());                                                                   // 7: 業務需求日
            row.add(custPo);                                                                                          // 8: CUST PO
            row.add(StringUtils.isNullOrEmpty(createRfqDto.getRfqRemark()) ? "" : createRfqDto.getRfqRemark());       // 9: REMARK
            row.add("N");                                                                                             // 10: SPQ CHECK
            row.add(createRfqDto.getSpq());                                                                           // 11: SPQ
            row.add(createRfqDto.getMoq());                                                                           // 12: MOQ
            row.add(createRfqDto.getFactoryCode());                                                                   // 13: 工廠別
            row.add(StringUtils.isNullOrEmpty(createRfqDto.getOrderedItem()) ? "" : createRfqDto.getOrderedItem());   // 14: 客戶品號
            row.add(createRfqDto.getUnitPrice());               // 15: 單價
            row.add(createRfqDto.getOrderType());               // 16: 訂單類型
            row.add(createRfqDto.getLineType());                // 17: LINE TYPE
            row.add(createRfqDto.getFob());                     // 18: FOB
            row.add(StringUtils.isNullOrEmpty(createRfqDto.getCustPoLineNo()) ? "" : createRfqDto.getCustPoLineNo()); // 19: 客戶訂單項次
            row.add("");                                        // 20: Quote#
            row.add(createRfqDto.getTsccCustomerNumber());      // 21: End Customer Number
            row.add(createRfqDto.getShippingMarks());           // 22: Shipping Marks
            row.add(createRfqDto.getRemarks());                 // 23: Remarks
            row.add(createRfqDto.getCustomerNamePhonetic());    // 24: End Customer Name
            row.add(createRfqDto.getLineId());                  // 25: LINE ID
            row.add("");                                        // 26
            row.add("");                                        // 27
            row.add("");                                        // 28
            row.add("");                                        // 29

            // 固定檢查碼 30 欄
            String[] checks = {rowNo, "D", "D", "U", "U", "D", "D", "U", "U", "U",
                    "P", "P", "P", "D", "D", "D", "D", "D", "D", "D",
                    "D", "D", "T", "T", "D", "D", "D", "D", "D", "D"};
            List<String> checkRow = new LinkedList<>(Arrays.asList(checks));

            valueList.add(row);
            checkList.add(checkRow);
        }

        return new String[][][]{
                string2D(valueList),
                string2D(checkList)
        };
    }

    private static String[][] string2D(List<List<String>> list) {
        String[][] strArray = new String[list.size()][];
        for (int i = 0; i < list.size(); i++) {
            List<String> row = list.get(i);
            strArray[i] = new String[row.size()];
            for (int j = 0; j < row.size(); j++) {
                Object value = row.get(j);
                strArray[i][j] = (value == null) ? "" : value.toString();
            }
        }
        return strArray;
    }

    private static TsccOrderToRfqDto setShippingAndFob(TsccOrderToRfqDto tsccOrderToRfqDto) {

        if (Arrays.asList("23080", "26851", "30032").contains(tsccOrderToRfqDto.getTsccCustomerNumber())) {
            if (tsccOrderToRfqDto.getOrderType().equals("1141")) {
                tsccOrderToRfqDto.setFob("FOB TAIWAN");
            } else {
                tsccOrderToRfqDto.setFob("FOB TIANJIN");
            }
            switch (tsccOrderToRfqDto.getTsccCustomerNumber()) {
                case "23080":
                    tsccOrderToRfqDto.setShippingMethod("SEA");
                    break;
                case "26851":
                    if (tsccOrderToRfqDto.getOrderType().equals("1141")) {
                        tsccOrderToRfqDto.setShippingMethod("DHL");
                    } else {
                        tsccOrderToRfqDto.setShippingMethod("FEDEX ECNOMY");
                    }
                    break;
                case "30032":
                    tsccOrderToRfqDto.setShippingMethod("DHL");
                    if (tsccOrderToRfqDto.getOrderType().equals("1156")) {
                        tsccOrderToRfqDto.setShippingMethod("FOB CHINA");
                    }
                    break;
                default:
                    tsccOrderToRfqDto.setShippingMethod(tsccOrderToRfqDto.getShippingMethod());
                    break;
            }
        } else if (tsccOrderToRfqDto.getTsccCustomerNumber().equals("26971")) { //Conti Malaysia
            tsccOrderToRfqDto.setShippingMethod("DHL");
            tsccOrderToRfqDto.setFob("DAP  MALAYSIA");
        } else if (tsccOrderToRfqDto.getTsccCustomerNumber().equals("31332")) { //Conti Philippines
            tsccOrderToRfqDto.setShippingMethod("DHL");
            tsccOrderToRfqDto.setFob("DAP PHILIPPINES");
        } else if (tsccOrderToRfqDto.getTsccCustomerNumber().equals("33652")) { //Conti Philippines
            tsccOrderToRfqDto.setShippingMethod("DHL");
            tsccOrderToRfqDto.setFob("DAP PHILIPPINES");
        } else if (tsccOrderToRfqDto.getTsccCustomerNumber().equals("29612")) { //Conti Singapore
            tsccOrderToRfqDto.setShippingMethod("DHL");
            tsccOrderToRfqDto.setFob("DAP SINGAPORE");
        } else if (tsccOrderToRfqDto.getTsccCustomerNumber().equals("23121")) { //LITE ON-2680
            tsccOrderToRfqDto.setShippingMethod("000001_TRUCK_R_P2P"); //出貨方式改為LAND
            tsccOrderToRfqDto.setFob(tsccOrderToRfqDto.getFobPointCode()); //FOB
        } else if (Arrays.asList("31912", "32932").contains(tsccOrderToRfqDto.getTsccCustomerNumber())) { // GPV ,GPV(THAILAND)
            tsccOrderToRfqDto.setShippingMethod("DHL");
            if (tsccOrderToRfqDto.getOrderType().equals("1141")) {
                tsccOrderToRfqDto.setFob("FOB TAIWANE");
            } else {
                tsccOrderToRfqDto.setFob("FOB CHINA");
            }
        } else {
            tsccOrderToRfqDto.setShippingMethod(tsccOrderToRfqDto.getShippingMethod());
            tsccOrderToRfqDto.setFob(tsccOrderToRfqDto.getFobPointCode());
        }

        return tsccOrderToRfqDto;
    }

    public static String wrapAsStringToJsonArray(Object singleObject) {
        return "[" + gson.toJson(singleObject) + "]";
    }

    public static String wrapAsJsonArray(Object singleObject) {
        return gson.toJson(singleObject);
    }

    public static String toJson() {
        return gson.toJson(tsccOrderToRfqDto);
    }

    public static String writeValueToString() throws JsonProcessingException {
        ObjectMapper objectMapper = new ObjectMapper();
        return objectMapper.writerWithDefaultPrettyPrinter().writeValueAsString(tsccOrderToRfqDto);
    }

    public static void getShippingMarksAndRemarks(String salesNo) throws SQLException {
        String sql = "SELECT\n" +
                "    x.*\n" +
                "FROM (\n" +
                "    SELECT\n" +
                "        a.CUSTOMER,\n" +
                "        a.ORDER_TYPE,\n" +
                "        a.SHIPPING_MARKS,\n" +
                "        a.REMARKS,\n" +
                "        ROW_NUMBER() OVER (\n" +
                "            PARTITION BY a.ORDER_TYPE\n" +
                "            ORDER BY CASE\n" +
                "                WHEN INSTR(a.CUSTOMER, 'HARVEY STAN') > 0 THEN 1\n" +
                "                ELSE 2\n" +
                "            END\n" +
                "        ) AS REC_SEQ\n" +
                "    FROM\n" +
                "        oraddman.tsc_om_remarks_setup a\n" +
                "    WHERE\n" +
                "        TSAREANO = ?\n" +
                "        AND (\n" +
                "            'HARVEY STAN' LIKE CUSTOMER || '%'\n" +
                "            OR CUSTOMER = 'ALL'\n" +
                "        )\n" +
                ") x\n" +
                "WHERE\n" +
                "    x.REC_SEQ = 1";
        try (PreparedStatement pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY)) {
            pstmt.setString(1, salesNo);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (!rs.isBeforeFirst()) rs.beforeFirst();
                while (rs.next()) {
                    if (rs.getString("ORDER_TYPE").equals(tsccOrderToRfqDto.getOrderType())) {
                        String shippingMarks = rs.getString("SHIPPING_MARKS");
                        shippingMarks = shippingMarks.replace("?01",
                                (tsccOrderToRfqDto.getCustomerNamePhonetic().startsWith("ARROW") ?
                                        "ARROW HONG KONG" : tsccOrderToRfqDto.getCustomerNamePhonetic()));
                        tsccOrderToRfqDto.setShippingMarks(shippingMarks);
                        String remarks = rs.getString("REMARKS");
                        remarks = remarks.replace("?02", (tsccOrderToRfqDto.getGreenFlag().equals("Y") ? "green " +
                                "compound" : ""));
                        tsccOrderToRfqDto.setRemarks(remarks);
                        break;
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public static void getShippingFobOrderTypeInfo() throws SQLException {
        tsccOrderToRfqImpl().setPolicyContext(conn, tsccOrderToRfqDto.getSupplyOrgId());
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
                " and b.CUST_ACCOUNT_ID ='"+tsccOrderToRfqDto.getSupplyCustomerId()+"'";
//        if (tsccOrderToRfqDto.getShipToOrgId() !=null && !tsccOrderToRfqDto.getShipToOrgId().equals(""))
//        {
//            sql += " and (a.SITE_USE_ID='" + tsccOrderToRfqDto.getShipToOrgId() + "' or a.location='" + tsccOrderToRfqDto.getShipToOrgId() + "')";
//        }
        sql += " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
                " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
                " order by decode(a.PRIMARY_FLAG,'Y',1,2), a.SITE_USE_ID";

        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        while (rs.next())
        {
            if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getShipToOrgId())) {
                tsccOrderToRfqDto.setShipToOrgId(rs.getString("SITE_USE_ID"));
            }
            if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getShippingMethod()) && rs.getString("ship_via") != null) {
                tsccOrderToRfqDto.setShippingMethod(rs.getString("ship_via"));
            }
            if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getFob()) && rs.getString("FOB_POINT") != null) {
                tsccOrderToRfqDto.setFob(rs.getString("FOB_POINT"));
            }
        }
        rs.close();
        stmt.close();
    }

    public static void getBiRegionData() throws SQLException {
        if (tsccOrderToRfqDto.getSupplyCustomerId().equals("15540") || tsccOrderToRfqDto.getSupplyCustomerId().equals("14980")) {
            String sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION' AND A_VALUE ='TSCC-VAT-LO' ";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tsccOrderToRfqDto.setBiRegion(rs.getString("A_VALUE"));
            }
        }
    }

    public static void checkColumnsRulesAndShowErrMsg() {
        errList = new LinkedList<>();
        if (!tsccOrderToRfqDto.getTsccOrderStatus().equals("ENTERED")) {
            errList.add("轉單狀態必須為ENTERED");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (!StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getSupplySoNo())) {
            errList.add("已轉TSC訂單:" + tsccOrderToRfqDto.getSupplySoNo());
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (!tsccOrderToRfqDto.getItemStatus().equalsIgnoreCase("ACTIVE") &&
                !tsccOrderToRfqDto.getItemStatus().equalsIgnoreCase("COND")) {
            errList.add("料號狀態不是可下單");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (tsccOrderToRfqDto.getPcnFlag().equals("Y")) {
            errList.add("料號已IN/PCN/PD");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (tsccOrderToRfqDto.getRequestDateFlag().equals("Y")) {
            errList.add("Request Date必須大於系統日+7");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getShippingMethodCode())) {
            errList.add("出貨方式不存在");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (tsccOrderToRfqDto.getFactoryCodeFlag().equals("Y")) {
            errList.add("工廠代碼錯誤");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getFob())) {
            errList.add("FOB錯誤");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (!StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getOrderedItem()) &&
                tsccOrderToRfqDto.getOrderedItemId().equals("0")) {
            errList.add("尚未建立客戶品號:" + tsccOrderToRfqDto.getOrderedItem() + "與台半品號:" + tsccOrderToRfqDto.getItemDesc() + "關係");
            tsccOrderToRfqDto.setErrorList(errList);
        }
        if (StringUtils.isNullOrEmpty(tsccOrderToRfqDto.getCustPoNumber())) {
            errList.add("CUSTOMER PO不可空白");
            tsccOrderToRfqDto.setErrorList(errList);
        }
    }

    public static String errList2String(List<Object> errList) {
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
}
