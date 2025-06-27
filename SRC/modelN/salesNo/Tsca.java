package modelN.salesNo;

import modelN.DetailColumn;
import modelN.ErrorMessage;
import modelN.ModelNCommonUtils;
import modelN.dto.ModelNDto;
import com.mysql.jdbc.StringUtils;

import java.sql.*;
import java.text.DecimalFormat;
import java.util.*;

public class Tsca extends ModelNCommonUtils {

    String itemNoPacking = "";
    String sellingPrice_Q = "";
    String endCustName = "";
    public void setDetailHeaderColumns() {
        detailHeaderColumns  = new String[] {
                DetailColumn.CustomerName.getColumnName(), DetailColumn.RFQType.getColumnName(), DetailColumn.CustomerPO.getColumnName(),
                DetailColumn.TSC_PN.getColumnName(), DetailColumn.Customer_PN.getColumnName(), DetailColumn.Qty.getColumnName(),
                DetailColumn.SellingPrice.getColumnName(), DetailColumn.CRD.getColumnName(), DetailColumn.SSD.getColumnName(),
                DetailColumn.ShippingMethod.getColumnName(), DetailColumn.FOB.getColumnName(), DetailColumn.EndCustomerNumber.getColumnName(),
                DetailColumn.EndCustomer.getColumnName(), DetailColumn.UploadBy.getColumnName()
                };
    }

    public void setDetailHeaderHtmlWidth() throws Exception {
        detailHeaderHtmlWidthMap = new HashMap();
        for (int i = 0, n= detailHeaderColumns.length; i < n; i++) {
            String columnKey = detailHeaderColumns[i];
            switch (DetailColumn.settingDetailColumn(columnKey, i)) {
                case CustomerName:
                    detailHeaderHtmlWidthMap.put(columnKey, 7);
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
                case CRD:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case SSD:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case ShippingMethod:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case FOB:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case EndCustomerNumber:
                    detailHeaderHtmlWidthMap.put(columnKey, 5);
                    break;
                case EndCustomer:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                case UploadBy:
                    detailHeaderHtmlWidthMap.put(columnKey, 6);
                    break;
                default:
                    break;
            }
        }
    }

    private String salesNo ="";
    public void checkExcelContent(String salesNo) throws Exception {
        this.salesNo = salesNo;
        for (Iterator it = excelMap.entrySet().iterator(); it.hasNext(); ) {
            errList = new LinkedList();
            Map.Entry entry = (Map.Entry) it.next();
            modelNDto = (ModelNDto) entry.getValue();
            modelNDto.setCustNo("1008");
            modelNDto.setCustId("1019");

            // 檢查Excel客戶代號
            if (StringUtils.isNullOrEmpty(modelNDto.getCustNo())) {
                errList.add(ErrorMessage.CUSTNO_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // 取得table CustId 和 CustName
//                checkCustIdAndName();
            }
            // 檢查Excel CustomerPO
            if (StringUtils.isNullOrEmpty(modelNDto.getCustPo())) {
                errList.add(ErrorMessage.CUSTPO_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // 檢查table客戶+customer po是否有待處理資料
                checkCustomerPo();
            }
            // 檢查Excel台半料號/品名及客戶料號
            if (StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc())
                    && StringUtils.isNullOrEmpty(modelNDto.getCustItem())
                    && StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
                modelNDto.setTscItem("");
                modelNDto.setTscItemDesc("");
                modelNDto.setCustItem("");
                errList.add(ErrorMessage.TSC_ITEM_AND_TSC_ITEM_PN_AND_CUST_ITEM_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                // 檢查table台半料號及客戶料號在ERP是否存在
                checkTscAndCustPartNo();
                setShippingFobOrderTypeInfo();
            }
            //檢查數量
            checkQty();
            checkSellingPrice();
            checkCrd();
            checkShippingMethod();
            checkEndCustomerAndId();
            checkRemarks();
            // 檢查Excel End Customer Number
            if (!modelNDto.getEndCustNo().equals("")) {
                //end customer number 不可與 customer number 相同
                if (modelNDto.getEndCustNo().equals(modelNDto.getCustNo())) {
                    errList.add(ErrorMessage.END_CUSTNO_NOT_SAME_CUSTNO.getMessage());
                    modelNDto.setErrorList(errList);
                } else {
                    // 檢查End Customer Number在ERP是否存在
                    checkEndCustNumber();
                }
            } else if (!endCustName.equals("")) {
                modelNDto.setEndCustNamePhonetic(endCustName);
            }
            checkTscaSoLineId();
            setOrderAndLineTypeId();
        }
    }

    private void checkCustomerPo() throws SQLException {
        //檢查customerNo 和 customerPo 是否有待處理資料
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
            String sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID, \n"+
                    " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE \n"+
                    " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3 \n"+
                    " ,case when msi.attribute3 in ('005','011') or \n"+
                    " (msi.attribute3 in ('002') and TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') in ('SMA', 'SMB','SMC','SOD-123W','SOD-128')) then '1141' \n"+
                    " else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) end AS ORDER_TYPE \n"+
                    ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + // quote 使用
                    " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE \n"+
                    " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY \n"+
                    " from oe_items_v a,inv.mtl_system_items_b msi \n"+
                    " ,APPS.MTL_ITEM_CATEGORIES_V c \n"+
                    " where a.SOLD_TO_ORG_ID = '" + modelNDto.getCustId() + "' \n"+
                    " and a.organization_id = msi.organization_id \n"+
                    " and a.inventory_item_id = msi.inventory_item_id \n"+
                    " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID \n"+
                    " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID  \n"+
                    " and msi.ORGANIZATION_ID = '49' \n"+
                    " and c.CATEGORY_SET_ID = 6 \n"+
                    " and a.CROSS_REF_STATUS='ACTIVE' \n"+
                    " and msi.inventory_item_status_code <> 'Inactive' \n"+
                    " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'";

            if (!StringUtils.isNullOrEmpty(modelNDto.getCustItem())) {
                sql += " and a.ITEM = '"+modelNDto.getCustItem()+"'";
            }
            if (!StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc()))
            {
                sql += " and a.ITEM_DESCRIPTION = '"+modelNDto.getTscItemDesc()+"'";
            }
            if (!StringUtils.isNullOrEmpty(modelNDto.getTscItem()))
            {
                sql += " and a.INVENTORY_ITEM = '"+modelNDto.getTscItem()+"'";
            }
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            while(rs.next())
            {
                modelNDto.setTscItem(rs.getString("INVENTORY_ITEM"));
                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                modelNDto.setTscItemDesc(rs.getString("ITEM_DESCRIPTION"));
                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                itemNoPacking = rs.getString("itemnopacking");
                modelNDto.setUom(rs.getString("PRIMARY_UOM_CODE"));
                modelNDto.setOrderType(StringUtils.isNullOrEmpty(modelNDto.getOrderType())? rs.getString("ORDER_TYPE") : modelNDto.getOrderType());
                modelNDto.setTscPackage(rs.getString("TSC_PACKAGE"));
                modelNDto.setTscFamily(rs.getString("TSC_FAMILY"));
                recordCount++;
            }
            rs.close();
            stmt.close();
            if (recordCount == 0) {
                errList.add(ErrorMessage.CUST_PN_NOT_FOUND_ERP.getMessage());
                modelNDto.setErrorList(errList);
            }
        } else {
            if (!StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc())
                    || !StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
                String sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3 \n"+
                        " ,case when msi.attribute3 in ('005','011') or \n"+
                        " (msi.attribute3 in ('002') and TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') in ('SMA', 'SMB','SMC','SOD-123W','SOD-128')) then '1141' \n"+
                        " else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) end AS ORDER_TYPE \n"+
                        ",tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking \n" + // quote 使用
                        " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE \n"+
                        " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY \n"+
                        " FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c \n"+
                        " WHERE msi.inventory_item_id = c.inventory_item_id \n"+
                        " AND msi.organization_id = c.organization_id \n"+
                        " AND msi.organization_id = '49'\n"+
                        " AND c.category_set_id = 6 \n"+
                        " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y' \n"+
                        " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y' \n"+
                        " AND msi.inventory_item_status_code <> 'Inactive'\n"+
                        " AND tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'";
                if (!StringUtils.isNullOrEmpty(modelNDto.getTscItemDesc())) {
                    sql += " AND msi.description =  '"+modelNDto.getTscItemDesc()+"'";
                }
                if (!StringUtils.isNullOrEmpty(modelNDto.getTscItem())) {
                    sql += " AND msi.segment1 =  '"+modelNDto.getTscItem()+"'";
                }
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                while(rs.next())
                {
                    modelNDto.setTscItem(rs.getString("segment1"));
                    modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
                    modelNDto.setTscItemDesc(rs.getString("description"));
                    modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
                    itemNoPacking = rs.getString("itemnopacking");
                    modelNDto.setUom(rs.getString("PRIMARY_UOM_CODE"));
                    modelNDto.setOrderType(StringUtils.isNullOrEmpty(modelNDto.getOrderType())? rs.getString("ORDER_TYPE") : modelNDto.getOrderType());
                    modelNDto.setTscPackage(rs.getString("TSC_PACKAGE"));
                    modelNDto.setTscFamily(rs.getString("TSC_FAMILY"));
                    modelNDto.setCustItem("");
                    recordCount++;
                }
                rs.close();
                stmt.close();
            }
            if (recordCount == 0) {
                errList.add(ErrorMessage.TSC_PN_NOT_FOUND_ERP.getMessage());
                modelNDto.setErrorList(errList);
            } else if (recordCount >1) {
                errList.add(ErrorMessage.TSC_PN_MORE_THAN_ONE.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                if (!modelNDto.getQuoteNumber().equals("") && !modelNDto.getTscItemDesc().equals("")) {
                    String passFlag = "";
                    String expireDate = "";
                    Statement stmt = conn.createStatement();
                    String sql = "SELECT * FROM (\n" +
                            "    -- 第一部分：QUQTE 資料來源\n" +
                            "    SELECT\n" +
                            "        a.quoteid,\n" +
                            "        a.partnumber,\n" +
                            "        a.currency,\n" +
                            "LISTAGG(TO_CHAR(a.pricek / 1000, 'FM99990.0999999'), ',') \n" +
                            "            WITHIN GROUP (ORDER BY a.pricek DESC) AS pricek,\n" +
                            "        '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
                            "        CASE\n" +
                            "            WHEN (\n" +
                            "                CASE\n" +
                            "                    WHEN a.region IN ('TSCR', 'TSCI') THEN TRUNC(a.fromdate)\n" +
                            "                    ELSE TRUNC(SYSDATE)\n" +
                            "                END\n" +
                            "            ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
                            "            THEN '1'\n" +
                            "            ELSE '0'\n" +
                            "        END AS pass_flag,\n" +
                            "        TO_CHAR(a.todate,'yyyy-mm-dd') todate\n" +
                            "    FROM tsc_om_ref_quotenet a\n" +
                            "    WHERE a.quoteid='" + modelNDto.getQuoteNumber() + "' \n"+
                            "      AND a.partnumber='" + modelNDto.getTscItemDesc() + "' \n"+
                            "	 GROUP BY\n" +
                            "	         a.quoteid,\n" +
                            "	         a.partnumber,\n" +
                            "	         a.currency,\n" +
                            "	         a.datecreated,\n" +
                            "	         a.region,\n" +
                            "	         a.endcustomer,\n" +
                            "	         a.fromdate,\n" +
                            "	         a.todate\n" +
                            "    UNION ALL\n" +
                            "    -- 第二部分：MODELN 資料來源(只取最新報價)\n" +
                            "    SELECT\n" +
                            "        quoteid,\n" +
                            "        partnumber,\n" +
                            "        currency,\n" +
                            "        pricek,\n" +
                            "        end_customer,\n" +
                            "        pass_flag,\n" +
                            "        todate\n" +
                            "    FROM (\n" +
                            "        SELECT\n" +
                            "            a.quoteid,\n" +
                            "            a.partnumber,\n" +
                            "            a.currency,\n" +
                            "            TO_CHAR(a.pricek / 1000, 'FM99990.0999999') AS pricek,\n" +
                            "            '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
                            "            CASE\n" +
                            "                WHEN (\n" +
                            "                    CASE\n" +
                            "                        WHEN a.region IN ('TSCR') THEN TRUNC(a.fromdate)\n" +
                            "                        ELSE TRUNC(SYSDATE)\n" +
                            "                    END\n" +
                            "                ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
                            "                THEN '1'\n" +
                            "                ELSE '0'\n" +
                            "            END AS pass_flag,\n" +
                            "            TO_CHAR(a.todate,'yyyy-mm-dd') todate,\n" +
                            "            ROW_NUMBER() OVER (\n" +
                            "                PARTITION BY a.quoteid, a.partnumber, a.currency\n" +
                            "                ORDER BY a.datechanged DESC\n" +
                            "            ) AS rn\n" +
                            "        FROM tsc_om_ref_modeln a\n" +
                            "        WHERE a.quoteid='" + modelNDto.getQuoteNumber() + "' \n"+
                            "          AND a.partnumber='" + modelNDto.getTscItemDesc() + "' \n"+
                            "    )\n" +
                            "    WHERE rn = 1\n" +
                            ")";
                    ResultSet rs = stmt.executeQuery(sql);
                    if (rs.next()) {
                        passFlag = rs.getString("PASS_FLAG");
                        if ("1".equals(passFlag)) {
                            sellingPrice_Q = rs.getString("PRICEK");
                            endCustName = rs.getString("END_CUSTOMER");
                            if (sellingPrice_Q.split(",").length > 1) {
                                if(!Arrays.asList(sellingPrice_Q.split(",")).contains(modelNDto.getSellingPrice())) {
                                    errList.add(ErrorMessage.MULTIPLE_PRICES.getMessageFormat(sellingPrice_Q.replace(",", " / ")));
                                    modelNDto.setErrorList(errList);
                                } else {
                                    sellingPrice_Q = modelNDto.getSellingPrice();
                                }
                            }
                        } else {
                            expireDate = rs.getString("TODATE");
                            errList.add(ErrorMessage.QUOTE_HAS_EXPIRED.getMessageFormat(expireDate));
                            modelNDto.setErrorList(errList);
                        }
                    } else {
                        errList.add(ErrorMessage.QUOTE_NOT_FOUND.getMessage());
                        modelNDto.setErrorList(errList);
                    }
                    rs.close();
                    stmt.close();
                }
            }
        }
    }

    // 檢查 End Customer Number
    private void checkEndCustNumber() throws SQLException {

        String sql = "select distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC \n"+
                    " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c \n"+
                    " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+this.salesNo+"') d \n"+
                    " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID \n"+
                    " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%' \n"+
                    " and a.STATUS = b.STATUS \n"+
                    " and a.ORG_ID = b.ORG_ID \n"+
                    " and (a.ORG_ID = d.PAR_ORG_ID \n"+
                    " OR a.ORG_ID=1046)  \n"+
                    " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID \n"+
                    " and c.STATUS='A'"+
                    " and c.customer_number <>'"+modelNDto.getCustNo()+"' \n"+
                    " order by c.customer_id";

        Statement stmt = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
        ResultSet rs = stmt.executeQuery(sql);

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

    public void setShippingFobOrderTypeInfo() throws SQLException {
        if (modelNDto.getEndCustNo().equals("25091") ||
                modelNDto.getEndCustNo().equals("32712") ||
                modelNDto.getEndCustNo().equals("32713")) {
            String sql = " select a.SITE_USE_CODE, a.SITE_USE_ID,a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID,a.tax_code \n"+
                    " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b \n"+
                    " where  a.ADDRESS_ID = b.cust_acct_site_id \n"+
                    " and a.STATUS='A' \n"+
                    " and b.CUST_ACCOUNT_ID ='"+modelNDto.getCustId()+"' \n"+
                    " and a.SITE_USE_ID=55839";
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                if (!modelNDto.getOrderType().equals("1141")) {
                    modelNDto.setShippingMethod(rs.getString("SHIP_VIA"));
                } else {
                    modelNDto.setShippingMethod(rs.getString("EXPEDITED"));
                }
                modelNDto.setFob(rs.getString("FOB_POINT"));
                if (modelNDto.getFob().equals("")) {
                    modelNDto.setFob(rs.getString("FCA"));
                }
            }
            rs.close();
            stmt.close();
        } else {
            modelNDto.setFob("DAP");
        }
    }

    //檢查單價
    private void checkSellingPrice() throws SQLException {
        if (StringUtils.isNullOrEmpty(modelNDto.getSellingPrice())) {
            if (sellingPrice_Q == null || sellingPrice_Q.equals("")) {
                modelNDto.setSellingPrice("");
                errList.add(ErrorMessage.SELLING_PRICE_NOTNULL.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                modelNDto.setSellingPrice(sellingPrice_Q);
            }
        } else {
            double priceNumber = Double.parseDouble(modelNDto.getSellingPrice().replace(",", ""));
            if (priceNumber <= 0) {
                errList.add(ErrorMessage.SELLING_PRICE_MUST_GREATER_0.getMessage());
                modelNDto.setErrorList(errList);
            } else if (!modelNDto.getSellingPrice().equals(sellingPrice_Q)) {
                if (!modelNDto.getQuoteNumber().equals("")) { // 需有quote number
                    errList.add(ErrorMessage.SELLING_PRICE_NOT_MATCH_QUOTE_PRICE.getMessageFormat(sellingPrice_Q));
                    modelNDto.setErrorList(errList);
                }
            } else {
                modelNDto.setSellingPrice((new DecimalFormat("###,##0.000##")).format(priceNumber));
            }
        }
    }
    private void checkCrd() throws SQLException {
            Statement stmt = conn.createStatement();
            int monthNum = 0;
            if (StringUtils.isNullOrEmpty(modelNDto.getCrd())) {
                errList.add(ErrorMessage.CRD_IS_NOTNULL);
                modelNDto.setErrorList(errList);
            } else if (modelNDto.getCrd().length() != 8) {
                errList.add(ErrorMessage.CRD_DATE_ERROR.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                String sql = "select to_char(to_date('" + modelNDto.getCrd() + "','yyyymmdd'),'yyyymmdd'),to_date('" + modelNDto.getCrd() + "','yyyymmdd')-trunc(sysdate) from dual";
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    modelNDto.setCrd(rs.getString(1));
                    monthNum = rs.getInt(2);
                }
                rs.close();
                stmt.close();
                if (monthNum < -1) {
                    errList.add(ErrorMessage.CRD_MUST_GREATER_OR_EQUALS_SYS_DATE.getMessage());
                    modelNDto.setErrorList(errList);
                }
            }
    }
    
    private void checkShippingMethod() throws SQLException {
        if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod()))
        {
            CallableStatement cs = conn.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}");
            cs.setString(1, this.salesNo);
            cs.setString(2, modelNDto.getTscPackage());
            cs.setString(3, modelNDto.getTscFamily());
            cs.setString(4, modelNDto.getTscItemDesc());
            cs.setString(5, modelNDto.getCrd());
            cs.registerOutParameter(6, Types.VARCHAR);
            cs.setString(7, modelNDto.getOrderType());
            cs.setString(8, modelNDto.getManuFactoryNo());
            cs.setString(9, modelNDto.getCustId());
            cs.setString(10, modelNDto.getFob());
            cs.setString(11, "");
            cs.execute();
            modelNDto.setTransportation(cs.getString(6));
            cs.close();
            ResultSet rs = this.getFndLookupValuesData();
            if (!rs.isBeforeFirst()) rs.beforeFirst();
            while (rs.next()) {
                if (rs.getString("MEANING").equals(modelNDto.getShippingMethod())) {
                    modelNDto.setShippingMethod(rs.getString("LOOKUP_CODE"));
                    break;
                }
            }
            if (StringUtils.isNullOrEmpty(modelNDto.getShippingMethod())) {
                String transportation = StringUtils.isNullOrEmpty(modelNDto.getTransportation()) ? "" : modelNDto.getTransportation();
                errList.add("" + ErrorMessage.TRANSPORTATION_IS_NOT_DIFINED.getMessage() + "(" + (transportation) + ")");
                modelNDto.setErrorList(errList);
                rs.close();
            } else {
                if (!StringUtils.isNullOrEmpty(modelNDto.getManuFactoryNo())) {
                    //交貨日期
                    String sql = "SELECT TSCA_GET_ORDER_SSD("+modelNDto.getOrderType()+",'"+modelNDto.getTransportation()+"','"+modelNDto.getCrd()+"','CRD',trunc(sysdate),null) FROM DUAL";
                    Statement stmt = conn.createStatement();
                    ResultSet rs2 = stmt.executeQuery(sql);
                    if (rs2.next()) {
                        modelNDto.setSsd(rs2.getString(1));
                    } else {
                        modelNDto.setSsd("");
                    }
                    rs2.close();
                    stmt.close();
                }
            }
        }
    }

    private void checkEndCustomerAndId() {
        if (StringUtils.isNullOrEmpty(modelNDto.getEndCustName())) {
            modelNDto.setEndCustName("");
        } else if (modelNDto.getEndCustNo() !=null && !modelNDto.getEndCustNo().equals("")) {
            errList.add(ErrorMessage.CHOOSE_END_CUSTNAME_OR_END_CUSTNO.getMessage());
            modelNDto.setErrorList(errList);
        }
    }

    private void checkRemarks() {
        if (StringUtils.isNullOrEmpty(modelNDto.getRemarks())) {
            modelNDto.setRemarks("");
        }
    }


    private void checkTscaSoLineId () throws SQLException {
        if(StringUtils.isNullOrEmpty(modelNDto.getCustPoLineNo()) || modelNDto.getCustPoLineNo().equals("'")) {
            errList.add(ErrorMessage.INPUT_CUSTPO_LINE_NO.getMessage());
            modelNDto.setErrorList(errList);
        }
        if(StringUtils.isNullOrEmpty(modelNDto.getCustPo()) || modelNDto.getCustPo().equals("'")) {
            errList.add(ErrorMessage.INPUT_CUSTPO_NO.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            if (modelNDto.getCustPo().startsWith("SB")) {
                String sql = " select a.line_id " +
                        " from ont.oe_order_lines_all a" +
                        ",ont.oe_order_headers_all b" +
                        " where a.header_id=b.header_id" +
                        " and b.org_id=1046" +
                        " and a.attribute1='" + modelNDto.getCustPo() + "'" +
                        " and a.attribute11='" + modelNDto.getCustPoLineNo().replace("'", "") + "'" +
                        " and ORDERED_QUANTITY-nvl(CANCELLED_QUANTITY,0)-nvl(a.SHIPPING_QUANTITY,0)>0";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next()) {
                    modelNDto.setOrgSoLineId(rs.getString("line_id"));
                }
                rs.close();
                stmt.close();
            } else if (modelNDto.getCustPo().startsWith("9")) {
                String sql = "select line_id "+
                        " from ont.oe_order_lines_all a"+
                        ",ont.oe_order_headers_all b"+
                        " where a.header_id=b.header_id"+
                        " and b.order_number='"+modelNDto.getCustPo()+"'"+
                        " and a.line_number||'.'||a.shipment_number='"+modelNDto.getCustPoLineNo().replace("'","")+"'";
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql);
                if (rs.next())
                {
                    modelNDto.setOrgSoLineId(rs.getString("line_id"));
                }
                rs.close();
                stmt.close();
            }
            if (modelNDto.getOrgSoLineId().equals(""))
            {
                errList.add(ErrorMessage.CONFIRM_TSCA_SALES_ORDER.getMessage());
                modelNDto.setErrorList(errList);
            }
        }
    }

    private void checkQty() {
        if (StringUtils.isNullOrEmpty(modelNDto.getQty())) {
            modelNDto.setQty("");
            errList.add(ErrorMessage.QTY_NOTNULL.getMessage());
            modelNDto.setErrorList(errList);
        } else {
            float qtyNum = Float.parseFloat(modelNDto.getQty().replace(",",""));
            if (qtyNum <= 0) {
                errList.add(ErrorMessage.QTY_MUST_GREATER_0.getMessage());
                modelNDto.setErrorList(errList);
            } else {
                if (Float.parseFloat(modelNDto.getQty()) > 0) {
                    try {
                        String sql = "SELECT SPQ/1000 SPQ,MOQ/1000 MOQ,mod(" + qtyNum + ", spq/1000 ) com_qty,(MOQ/1000)-" + qtyNum + " as chkqty \n" +
                                "FROM TABLE(TSC_GET_ITEM_SPQ_MOQ('" + modelNDto.getInventoryItemId() + "','TS','" + modelNDto.getManuFactoryNo() + "'))";
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        if (rs.next()) {
                            if (!rs.getString(3).equals("0")) {
                                errList.add(ErrorMessage.QTY_MUST_SPQ_K.getMessageFormat(rs.getString(1)));
                                modelNDto.setErrorList(errList);
                            }
                            if (rs.getInt(4) > 0) {
                                errList.add(ErrorMessage.QTY_MUST_GREATER_OR_EQUALS_MOQ_K.getMessageFormat(rs.getString(2)));
                                modelNDto.setErrorList(errList);
                            }
                        }
                        rs.close();
                        stmt.close();
                        modelNDto.setQty((new DecimalFormat("#######0.0##")).format(qtyNum));
                    } catch (Exception e) {
                        errList.add(ErrorMessage.NOT_CREATE_SPQ_MOQ.getMessage());
                        modelNDto.setErrorList(errList);
                    }
                }
            }
        }
    }

    private void setOrderAndLineTypeId() throws SQLException {
        Statement statement = conn.createStatement();
        String sql = " select wf.LINE_TYPE_ID,ORDER_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl \n"+
                " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null \n"+
                " and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID \n"+
                " and c.SAREA_NO = '" + this.salesNo + "' and c.ORDER_NUM='" + modelNDto.getOrderType() + "') \n"+
                " and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
        ResultSet rs = statement.executeQuery(sql);
        if (rs.next()) {
            modelNDto.setLineType(rs.getString("LINE_TYPE_ID"));
            if (modelNDto.getOrderTypeId().equals("")) {
                modelNDto.setOrderTypeId(rs.getString("ORDER_TYPE_ID"));
            }
        } else {
            modelNDto.setLineType("0");
        }
        rs.close();
        statement.close();
    }
}
