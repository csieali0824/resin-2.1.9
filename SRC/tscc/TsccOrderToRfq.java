package tscc;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.mysql.jdbc.StringUtils;
import commonUtil.ToRfqParams;
import commonUtil.uriUtil.UriBuilderUtil;
import modelN.DetailColumn;
import tscc.dao.impl.TsccOrderToRfqImpl;
import tscc.dto.TsccOrderToRfqDto;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.*;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class TsccOrderToRfq {

    private final Gson gson = new GsonBuilder()
            .disableHtmlEscaping() // 防止 HTML 特殊字元被轉義（如 < 變成 \u003c）
            .create();
    private Connection conn;
    public String headerId;
    private TsccOrderToRfqDto tsccOrderToRfqDto;

    public static String[] headerColumns = new String[]{};
    public static HashMap<String, Integer> headerHtmlWidthMap = new LinkedHashMap<>();
    public static HashMap<Integer, List<TsccOrderToRfqDto>> detailMap = new LinkedHashMap<>();
//    public static HashMap<Integer, List<TsccOrderToRfqDto>> filterDtoMap = new LinkedHashMap<>();
    public static Map<Integer, List<?>> filterDtoMap = new LinkedHashMap<>();
    public static List<HashMap<String, String>> detailList = new LinkedList<>();

    public List<String> errList = new ArrayList<String>();

    public TsccOrderToRfqImpl tsccOrderToRfq() {
        return new TsccOrderToRfqImpl();
    }

    public HashMap<Integer, List<TsccOrderToRfqDto>> getDetailMap() {
        return detailMap;
    }


    public boolean checkPermission(Connection conn, String userName) throws SQLException {
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

    public void getTsccToRfqData(Connection conn, String headerId, String salesNo, String orderType) throws SQLException {
        this.conn = conn;
        this.headerId = headerId;
        detailMap = new LinkedHashMap();
        this.tsccOrderToRfq().setPolicyContext(this.conn, null);
        Map<Integer, TsccOrderToRfqDto> map = tsccOrderToRfq().getOrderToRfq(this.conn, headerId, salesNo, orderType);
        for (Map.Entry<Integer, TsccOrderToRfqDto> entry : map.entrySet()) {
            HashMap<String, String> keyValueMap = new LinkedHashMap<>();
            List list = new LinkedList();
            int rowIndex = entry.getKey();
            tsccOrderToRfqDto = entry.getValue();
            getShippingMarksAndRemarks(tsccOrderToRfqDto.getSalesNo());
            getShippingFobOrderTypeInfo();
            getBiRegionData();
            checkColumnsRulesAndShowErrMsg();
            list.add(tsccOrderToRfqDto);
            for (int i = 0, n= getHeaderColumns().length; i < n; i++) {
                String column = getHeaderColumns()[i];
                switch (DetailColumn.settingDetailColumn(column, i)) {
                    case CustomerName:
                        keyValueMap.put(column, tsccOrderToRfqDto.getSupplyCustomerName()); //todo 待和雄哥討論 getTsccCustomerName
                        break;
                    case RFQType:
                        keyValueMap.put(column, "NORMAL");
                        break;
                    case CustomerPO:
                        keyValueMap.put(column, tsccOrderToRfqDto.getCustPoNumber());//todo 待和雄哥討論 getCustPoNumber
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
    }

    public List<TsccOrderToRfqDto> getErrorList() {
        return detailMap.values().stream()
                .filter(list -> list != null && !list.isEmpty())
                .map(list -> list.get(0))
                .collect(Collectors.toList());
    }

    public Map<Integer, TsccOrderToRfqDto> getErrorMap() {
        return detailMap.entrySet().stream()
                .filter(entry -> entry.getValue() != null && !entry.getValue().isEmpty())
                .collect(Collectors.toMap(
                        Map.Entry::getKey,
                        entry -> entry.getValue().get(0)
                ));
    }

    public void getShippingFobOrderTypeInfo() throws SQLException {
        this.tsccOrderToRfq().setPolicyContext(this.conn, tsccOrderToRfqDto.getSupplyOrgId());
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

    public void getShippingMarksAndRemarks(String salesNo) throws SQLException {
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
                        remarks = remarks.replace("?02", (tsccOrderToRfqDto.getGreenFlag().equals("Y") ?
                                "green compound" : ""));
                        tsccOrderToRfqDto.setRemarks(remarks);
                        break;
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public void getBiRegionData() throws SQLException {
        if (tsccOrderToRfqDto.getSupplyCustomerId().equals("15540") || tsccOrderToRfqDto.getSupplyCustomerId().equals("14980")) {
            String sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION' AND A_VALUE ='TSCC-VAT-LO' ";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while (rs.next()) {
                tsccOrderToRfqDto.setBiRegion(rs.getString("A_VALUE"));
            }
        }
    }
    public void checkColumnsRulesAndShowErrMsg() {
        errList = new ArrayList<>();
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

    private TsccOrderToRfqDto setShippingAndFob(TsccOrderToRfqDto tsccOrderToRfqDto) {

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
            tsccOrderToRfqDto.setFob("DAP MALAYSIA");
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

    public String[] getHeaderColumns() {
//        String groupBy = DetailColumn.GroupBy.getColumnName();   // 新增到最後面
        headerColumns = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.ShipToId.getColumnName(), DetailColumn.RFQType.getColumnName(),
                DetailColumn.CustomerPO.getColumnName(), DetailColumn.TSC_PN.getColumnName(), DetailColumn.Customer_PN.getColumnName(),
                DetailColumn.Qty.getColumnName(), DetailColumn.SellingPrice.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.OrderType.getColumnName(), DetailColumn.ShippingMethod.getColumnName(), DetailColumn.FOB.getColumnName(),
                DetailColumn.CustomerPOLine.getColumnName(), DetailColumn.EndCustomerNumber.getColumnName(), DetailColumn.EndCust.getColumnName(),
                DetailColumn.UploadBy.getColumnName(), DetailColumn.UploadDate.getColumnName()
        };

        return headerColumns;

//        // 建立新陣列，長度多 1
//        String[] newArray = Arrays.copyOf(headerColumns, headerColumns.length + 1);
//        // 新字串放在最後一個位置
//        newArray[newArray.length - 1] = groupBy;
//        return newArray;
    }

    public HashMap<String, Integer> getHeaderHtmlWidthMap() {
        headerHtmlWidthMap = new HashMap<>();
        for (int i = 0, n= headerColumns.length; i < n; i++) {
            String columnKey = headerColumns[i];
            switch (DetailColumn.settingDetailColumn(columnKey, i)) {
                case CustomerName:
                    headerHtmlWidthMap.put(columnKey, 7);
                    break;
                case ShipToId:
                    headerHtmlWidthMap.put(columnKey, 4);
                    break;
                case RFQType:
                    headerHtmlWidthMap.put(columnKey,4);
                    break;
                case CustomerPO:
                    headerHtmlWidthMap.put(columnKey, 7);
                    break;
                case TSC_PN:
                    headerHtmlWidthMap.put(columnKey, 8);
                    break;
                case Customer_PN:
                    headerHtmlWidthMap.put(columnKey, 8);
                    break;
                case Qty:
                    headerHtmlWidthMap.put(columnKey, 4);
                    break;
                case SellingPrice:
                    headerHtmlWidthMap.put(columnKey, 5);
                    break;
                case SSD:
                    headerHtmlWidthMap.put(columnKey, 6);
                    break;
                case OrderType:
                    headerHtmlWidthMap.put(columnKey, 4);
                    break;
                case ShippingMethod:
                    headerHtmlWidthMap.put(columnKey, 6);
                    break;
                case FOB:
                    headerHtmlWidthMap.put(columnKey, 6);
                    break;
                case CustomerPOLine:
                    headerHtmlWidthMap.put(columnKey, 7);
                    break;
                case EndCustomerNumber:
                    headerHtmlWidthMap.put(columnKey, 5);
                    break;
                case EndCust:
                    headerHtmlWidthMap.put(columnKey, 6);
                    break;
                case UploadBy:
                    headerHtmlWidthMap.put(columnKey, 6);
                    break;
                case UploadDate:
                    headerHtmlWidthMap.put(columnKey, 5);
                    break;
                default:
                    break;
            }
        }

//        LinkedHashMap<String, Integer> map = new LinkedHashMap<>(headerHtmlWidthMap); // 加入原有內容
//        map.put("Group By", 0);    // 新增到最後面
        return headerHtmlWidthMap;
    }

//    public void removeDetailMap(String row) {
//        if (filterDtoMap.isEmpty()) {
//            filterDtoMap = getDetailMap();
//        }
//        filterDtoMap.remove(Integer.parseInt(row));
//    }

//    public Map<Integer, List<?>> filterByFieldValue(String fieldName, String targetValue) {
//        return detailMap.entrySet()
//                .stream()
//                .filter(entry -> {
//                    List<TsccOrderToRfqDto> list = entry.getValue();
//                    if (list.size() > 1 && list.get(1) instanceof Map) {
//                        Map<?, ?> dataMap = (Map<?, ?>) list.get(1);
//                        Object fieldValue = dataMap.get(fieldName);
//                        // 保留不等於 targetValue 的資料
//                        return !targetValue.equals(fieldValue);
//                    }
//                    return true;
//                })
//                .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue));
//    }


    public Map<Integer, List<?>> filterOrderStatus() {
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

    public String[][][] buildStringAndCheckMatrix() {
        List<List<String>> valueList = new LinkedList<>();
        List<List<String>> checkList = new LinkedList<>();

        for (Map.Entry<Integer, List<TsccOrderToRfqDto>> entry : detailMap.entrySet()) {
            List<String> row = new LinkedList<>();

            String rowNo = String.valueOf(entry.getKey());
            TsccOrderToRfqDto dto = entry.getValue().get(0);
            String custPo = dto.getCustPoNumber();
            row.add(rowNo);                                                                                  // 0: 序號
            row.add(dto.getItemName());                                                                      // 1: 料號
            row.add(dto.getItemDesc());                                                                      // 2: 品名
            row.add(dto.getRfqQty());                                                                        // 3: 數量
            row.add("KPC");                                                                                  // 4: 數量單位
            row.add(dto.getRequestDate());                                                                   // 5 CRD
            row.add(dto.getShippingMethod());                                                                // 6: 出貨方式
            row.add(dto.getRequestDate());                                                                   // 7: 業務需求日
            row.add(custPo);                                                                                 // 8: CUST PO
            row.add(StringUtils.isNullOrEmpty(dto.getRfqRemark()) ? "" : dto.getRfqRemark());                // 9: REMARK
            row.add("N");                                                                                    // 10: SPQ CHECK
            row.add(dto.getSpq());                                                                           // 11: SPQ
            row.add(dto.getMoq());                                                                           // 12: MOQ
            row.add(dto.getFactoryCode());                                                                   // 13: 工廠別
            row.add(StringUtils.isNullOrEmpty(dto.getOrderedItem()) ? "" : dto.getOrderedItem());            // 14: 客戶品號
            row.add(dto.getUnitPrice());                                                                     // 15: 單價
            row.add(dto.getOrderType());                                                                     // 16: 訂單類型
            row.add(dto.getLineType());                                                                      // 17: LINE TYPE
            row.add(dto.getFob());                                                                           // 18: FOB
            row.add(StringUtils.isNullOrEmpty(dto.getCustPoLineNo()) ? "" : dto.getCustPoLineNo());          // 19: 客戶訂單項次
            row.add("");                                                                                     // 20: Quote#
            row.add(dto.getTsccCustomerNumber());                                                            // 21: End Customer Number
            row.add(dto.getShippingMarks());                                                                 // 22: Shipping Marks
            row.add(dto.getRemarks());                                                                       // 23: Remarks
            row.add(dto.getCustomerNamePhonetic());                                                          // 24: End Customer Name
            row.add(dto.getLineId());                                                                        // 25: LINE ID
            row.add("");                                                                                     // 26
            row.add(dto.getBiRegion());                                                                      // 27 Bi Region
            row.add("");                                                                                     // 28
            row.add("");                                                                                     // 29

            // 固定檢查碼 30 欄
            String[] checks = {
                    rowNo, "D", "D", "U", "U", "D", "D", "U", "U", "U",
                    "P", "P", "P", "D", "D", "D", "D", "D", "D", "D",
                    "D", "D", "T", "T", "D", "D", "D", "D", "D", "D"
            };
            List<String> checkRow = new LinkedList<>(Arrays.asList(checks));
            valueList.add(row);
            checkList.add(checkRow);
        }

        return new String[][][]{
                string2D(valueList),
                string2D(checkList)
        };
    }

    public void redirect2TsccIntermediate(HttpServletResponse response, String headerId) throws UnsupportedEncodingException {
        String urlDir = "TSCCIntermediate.jsp?headerId=" + URLEncoder.encode(headerId, "UTF-8");
        try {
            response.sendRedirect(urlDir);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("redirectToTSCCIntermediate.jsp:" + e.getMessage());
        }
    }
    public void redirect2DRQCreate(HttpSession session, HttpServletResponse response, Map argMap) {
        String customerId = (String) argMap.get("customerId");
        String customerNo = (String) argMap.get("customerNo");
        String customerName = (String) argMap.get("customerName");
        String salesNo = (String) argMap.get("salesNo");
        String customerPo = (String) argMap.get("customerPo");
        String shipToOrgId = (String) argMap.get("shipToOrgId");
        String curr = (String) argMap.get("curr");
        String remark = (String) argMap.get("remark");
        String orderType = (String) argMap.get("orderType");
        String otypeId = (String) argMap.get("otypeId");
        String salesPerson = (String) argMap.get("salesPerson");
        String salesPersonId = (String) argMap.get("salesPersonId");
        String rfqType = (String) argMap.get("rfqType");
        String isEmptyRow = (String) argMap.get("isEmptyRow");
//        String shipToContactName = getShipToContactNameAndId(customerId, shipToOrgId)[0];
//        String shipToContactId = getShipToContactNameAndId(customerId, shipToOrgId)[1];

        session.setAttribute("headerId", this.headerId);

        String[] paramsKeys = new String[]{
                ToRfqParams.CUSTOMERID.name(), ToRfqParams.SPQCHECKED.name(), ToRfqParams.CUSTACTIVE.name(), ToRfqParams.SALESAREANO.name(),
                ToRfqParams.CUSTOMERPO.name(),ToRfqParams.CURR.name(), ToRfqParams.REMARK.name(), ToRfqParams.PREORDERTYPE.name(),
                ToRfqParams.ISMODELSELECTED.name(),ToRfqParams.PROCESSAREA.name(), ToRfqParams.SHIPTO.name(), ToRfqParams.CUSTOMERIDTMP.name(),
                ToRfqParams.INSERT.name(), ToRfqParams.RFQTYPE.name(), ToRfqParams.PROGRAMNAME.name(), ToRfqParams.ISEMPTYROW.name()
        };

        String[] paramsValues = new String[]{
                customerId, "Y", "A", salesNo,
                customerPo, curr, remark, otypeId,
                "Y",salesNo, shipToOrgId, customerId,
                "Y", rfqType, "TSCC", isEmptyRow
        };

        Map<String, String> result =
                IntStream.range(0, paramsKeys.length)
                        .boxed()
                        .collect(Collectors.toMap(index -> paramsKeys[index], index -> paramsValues[index],
                                (a, b) -> b, LinkedHashMap::new));
        String urlDir = UriBuilderUtil.buildUrlWithParams("TSSalesDRQ_Create.jsp", result);
        try {
            response.sendRedirect(urlDir);
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("redirect2DRQCreate:" + e.getMessage());
        }
    }

    private String[][] string2D(List<List<String>> list) {
        String[][] strArray = new String[list.size()][];
        for (int i = 0; i < list.size(); i++) {
            List<String> row = list.get(i);
            strArray[i] = new String[row.size()];
            for (int j = 0; j < row.size(); j++) {
                Object value = row.get(j);
                strArray[i][j] = (value == null) ? "" : value.toString(); // 處理 null 值為空字串
            }
        }
        return strArray;
    }

    /**
     * 將單筆物件包裝成 JSON 陣列字串，例如傳入 Object 會變成 [Object]
     */
    public String wrapAsStringToJsonArray(Object singleObject) {
        return "[" + gson.toJson(singleObject) + "]";
    }

    public String wrapAsJsonArray(Object singleObject) {
        return gson.toJson(singleObject);
    }
}
