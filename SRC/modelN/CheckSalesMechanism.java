package modelN;

import modelN.salesNo.TsctDa;
import modelN.salesNo.TsctDisty;
import modelN.salesNo.Tsccsh;
import modelN.salesNo.Tsck;
import modelN.salesNo.Tscr;
import modelN.salesNo.Tsca;

import java.sql.SQLException;

public class CheckSalesMechanism extends ModelNCommonUtils {
    public String salesNo;
    public CheckSalesMechanism(String salesNo) {
        this.salesNo = salesNo;
    }

    protected void setAndCheckInfo(Boolean isSetInfo) throws SQLException {
        switch (salesNo) {
            case "002":
                Tsccsh tsccsh = new Tsccsh();
                tsccsh.setShippingFobOrderTypeInfo();
                if (isSetInfo) {
                    tsccsh.setShippingMethod();
                    tsccsh.setFob();
                    tsccsh.setExtraRuleInfo();
                }
                break;
            case "004":
                Tsck tsck = new Tsck();
                tsck.setShippingFobOrderTypeInfo();
                if (isSetInfo) {
                    tsck.setShippingMethod();
                }
                break;
            case "005":
                TsctDa tsctDa = new TsctDa();
                tsctDa.setShippingFobOrderTypeInfo();
                if (isSetInfo) {
                    tsctDa.setShippingMethod();
                    tsctDa.setFob();
                    tsctDa.setExtraRuleInfo();
                }
                break;
            case "006":
                TsctDisty tsctDisty = new TsctDisty();
                tsctDisty.setShippingFobOrderTypeInfo();
                break;
            case "008":
                Tsca tsca = new Tsca();
                if (isSetInfo) {
                    tsca.setShippingMethod();
                    tsca.setCrd();
                    tsca.setExtraRuleInfo();
                }
                break;
            case "009":
                Tscr tscr = new Tscr();
                if (isSetInfo) {
                    tscr.setFob();
                    tscr.setCrd();
                }
                break;
            default:
                break;
        }
    }

//    public void setSalesShippingFobOrderType() throws SQLException {
//        switch (salesNo) {
//            case "002":
//                Tsccsh tsccsh = new Tsccsh();
//                tsccsh.setShippingFobOrderTypeInfo();
//                break;
//            case "004":
//                Tsck tsck = new Tsck();
//                tsck.setShippingFobOrderTypeInfo();
//                break;
//            case "005":
//                TsctDa tsctDa = new TsctDa();
//                tsctDa.setShippingFobOrderTypeInfo();
//                break;
//            case "006":
//                TsctDisty tsctDisty = new TsctDisty();
//                tsctDisty.setShippingFobOrderTypeInfo();
//                break;
//            default:
//                break;
//        }
//    }

    //�ˬd�X�f�覡
//    public void setSalesShippingMethod() {
//        switch (this.salesNo) {
//            case "002":
//                Tsccsh tsccsh = new Tsccsh();
//                tsccsh.setShippingMethod();
//                break;
//            case "004":
//                Tsck tsck = new Tsck();
//                tsck.setShippingMethod();
//                break;
//            case "005":
//                TsctDa tsctDa = new TsctDa();
//                tsctDa.setShippingMethod();
//                break;
//            case "008":
//                Tsca tsca = new Tsca();
//                tsca.setShippingMethod();
//                break;
//            default:
//                break;
//        }
//    }

    // �ˬdFOB
//    public void setSalesFob() {
//        switch (this.salesNo) {
//            case "002":
//                Tsccsh tsccsh = new Tsccsh();
//                tsccsh.setFob();
//                break;
//            case "005":
//                TsctDa tsctDa = new TsctDa();
//                tsctDa.setFob();
//                break;
//            case "009":
//                Tscr tscr = new Tscr();
//                tscr.setFob();
//                break;
//            default:
//                break;
//        }
//    }
//    public void setSalesCrd() {
//        switch (this.salesNo) {
//            case "008":
//                Tsca tsca = new Tsca();
//                tsca.setCrd();
//                break;
//            case "009":
//                Tscr tscr = new Tscr();
//                tscr.setCrd();
//                break;
//        }
//    }

//    public void setSalesExtraInfo() throws SQLException {
//        switch (this.salesNo) {
//            case "002":
//                Tsccsh tsccsh = new Tsccsh();
//                tsccsh.setExtraRuleInfo();
//                break;
//            case "005":
//                TsctDa tsctDa = new TsctDa();
//                tsctDa.setExtraRuleInfo();
//                break;
//            case "008":
//                Tsca tsca = new Tsca();
//                tsca.setExtraRuleInfo();
//                break;
//        }
//    }

//    protected void checkCustIdAndName() throws SQLException {
//        Statement statement = conn.createStatement();
//        ResultSet rs = statement.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS " +
//                "where status = 'A'  and CUSTOMER_NUMBER ='" + modelNDto.getCustNo() + "'");
//        if (rs.next()) {
//            String custId = rs.getString("CUSTOMER_ID");
//            modelNDto.setCustId(custId);
//            String custName = rs.getString("CUSTOMER_NAME");
//            modelNDto.setCustName(custName);
//            checkErpCustInfo();
//        } else {
//            modelNDto.setErrorMsg(appendErrMsg("ERP�d�L�Ȥ��T"));
//        }
//    }
//
//    protected void checkCustomerPo() throws SQLException {
//        //�ˬdcustomerNo �M customerPo �O�_���ݳB�z���
//        if (modelNDto.getCustNo() != null && !modelNDto.getCustNo().equals("")
//                && modelNDto.getCustPo() != null && !modelNDto.getCustPo().equals("")) {
//            Statement statement = conn.createStatement();
//            ResultSet rs = statement.executeQuery(
//                    "select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where SALESAREANO = '" + salesNo + "' \n" + "" +
//                            " and CUSTOMER_NO ='" + modelNDto.getCustNo() + "' AND CUSTOMER_PO='" + modelNDto.getCustPo() + "' AND CREATE_FLAG='N'");
//            if (rs.next()) {
//                modelNDto.setErrorMsg(appendErrMsg("Pending Detail�w�s�b���Ȥ�+PO���!"));
//            }
//            rs.close();
//            statement.close();
//        }
//    }
//
//    protected void checkTscAndCustPartNo() throws SQLException {
//        int recordCount = 0;
//        if (modelNDto.getCustItem() != null && !modelNDto.getCustItem().equals("")) {
//            String sql = "select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,\n" +
//                    "a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE\n" +
//                    ",NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3\n" +
//                    ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE  \n" +
//                    "from oe_items_v a,inv.mtl_system_items_b msi \n" +
//                    ",APPS.MTL_ITEM_CATEGORIES_V c \n" +
//                    "where a.SOLD_TO_ORG_ID = '" + modelNDto.getCustId() + "' \n" +
//                    "and a.organization_id = msi.organization_id\n" +
//                    "and a.inventory_item_id = msi.inventory_item_id\n" +
//                    "and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID \n" +
//                    "and msi.ORGANIZATION_ID = c.ORGANIZATION_ID \n" +
//                    "and msi.ORGANIZATION_ID = '49'\n" +
//                    "and c.CATEGORY_SET_ID = 6\n" +
//                    "and a.CROSS_REF_STATUS='ACTIVE'\n" +
//                    "and msi.inventory_item_status_code <> 'Inactive'\n" +
//                    "and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
//                    "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
//                    "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+
//                    "and a.ITEM = '" + modelNDto.getCustItem() + "'";
//            if (modelNDto.getTscItemDesc() != null && !modelNDto.getTscItemDesc().equals("")) {
//                sql += " and a.ITEM_DESCRIPTION = '" + modelNDto.getTscItemDesc() + "'";
//            }
//            if (modelNDto.getTscItem() != null && !modelNDto.getTscItem().equals("")) {
//                sql += " and a.INVENTORY_ITEM = '" + modelNDto.getTscItem() + "'";
//            }
//            Statement statement = conn.createStatement();
//            ResultSet rs = statement.executeQuery(sql);
//            while (rs.next()) {
//                modelNDto.setTscItem(rs.getString("INVENTORY_ITEM"));
//                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
//                modelNDto.setTscItemDesc(rs.getString("ITEM_DESCRIPTION"));
//                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
//                if (modelNDto.getOrderType().equals("1156")) {
//                    modelNDto.setManuFactoryNo("002");
//                }
//                recordCount++;
//            }
//            rs.close();
//            statement.close();
//            if (recordCount == 0) {
//                modelNDto.setErrorMsg(appendErrMsg("�Ȥ�Ƹ��bERP���s�b!"));
////                this.errList.add("�Ȥ�Ƹ��bERP���s�b");
//            }
//        } else if ((modelNDto.getTscItemDesc() != null && !modelNDto.getTscItemDesc().equals(""))
//                || (modelNDto.getTscItem() != null && !modelNDto.getTscItem().equals(""))) {
//            String sql = "SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,\n" +
//                    "NVL (msi.attribute3, 'N/A') attribute3,\n" +
//                    "tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type\n" +
//                    "FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c\n" +
//                    "WHERE msi.inventory_item_id = c.inventory_item_id\n" +
//                    "AND msi.organization_id = c.organization_id\n" +
//                    "AND msi.organization_id = '49'\n" +
//                    "AND c.category_set_id = 6\n" +
//                    "AND msi.inventory_item_status_code <> 'Inactive'\n" +
//                    "AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'\n" +
//                    "AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'\n" +
//                    "AND msi.description =  nvl('" + modelNDto.getTscItemDesc() + "',msi.description)\n" +
//                    "AND msi.segment1 = nvl('" + modelNDto.getTscItem() + "',msi.segment1)\n"+
//                    " and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
//                    "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
//                    "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) ";
//            Statement statement = conn.createStatement();
//            ResultSet rs = statement.executeQuery(sql);
//            while (rs.next()) {
//                modelNDto.setTscItem(rs.getString("segment1"));
//                modelNDto.setInventoryItemId(rs.getString("INVENTORY_ITEM_ID"));
//                modelNDto.setTscItemDesc(rs.getString("description"));
//                modelNDto.setCustItem("");
//                modelNDto.setManuFactoryNo(rs.getString("ATTRIBUTE3"));
//                if (modelNDto.getOrderType().equals("1156")) {
//                    modelNDto.setManuFactoryNo("002");
//                }
//                recordCount++;
//            }
//            rs.close();
//            statement.close();
//            if (recordCount == 0) {
//                modelNDto.setErrorMsg(appendErrMsg("�x�b�Ƹ��bERP���s�b!"));
//            }
//        }
//        if (recordCount > 1) {
//            modelNDto.setErrorMsg(appendErrMsg("�������x�b�Ƹ��W�L�@�ӥH�W,�п�ܥ��T�x�b�Ƹ�!"));
//        }
//    }
//
//    // ���o�Ȥ��T
//    protected void checkErpCustInfo() throws SQLException {
//        if (salesNo.equals("006")) {
//            TsctDisty tsctDisty = new TsctDisty();
//            tsctDisty.setShippingFobOrderTypeInfo();
//        } else if (salesNo.equals("005")) {
//            TsctDa tsctDa = new TsctDa();
//            tsctDa.setShippingFobOrderTypeInfo();
//        }
//    }
//
//    //�ˬd�q�������O�_���T
//    protected void checkCorrectOrderTypeId() throws SQLException {
//        String sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b \n" +
//                " where b.order_num=a.order_num and a.order_num='" + modelNDto.getOrderType() + "' and a.sarea_no ='" + salesNo + "'" +
//                " and a.active='Y'\n" +
//                " and b.MANUFACTORY_NO='" + modelNDto.getManuFactoryNo() + "' and b.ACTIVE='Y'";
//
//        Statement statement = conn.createStatement();
//        ResultSet rs = statement.executeQuery(sql);
//        if (!rs.next()) {
//            modelNDto.setErrorMsg(appendErrMsg("�q���������~"));
//        } else {
//            modelNDto.setOrderTypeId(rs.getString(1));
//        }
//        rs.close();
//        statement.close();
//    }
//
//    //�ˬd�ƶq
//    protected void checkQty() {
//        if (modelNDto.getQty() == null || modelNDto.getQty().equals("")) {
//            modelNDto.setQty("&");
//            modelNDto.setErrorMsg(appendErrMsg("�ƶq���i�ť�"));
//        } else {
//            try {
//                double qtyNumber = Double.parseDouble(modelNDto.getQty().replace(",", ""));
//                if (qtyNumber <= 0) {
//                    modelNDto.setErrorMsg(appendErrMsg("�ƶq�����j��s"));
//                } else {
//                    modelNDto.setQty((new DecimalFormat("#######0.0##")).format(qtyNumber));
//                }
//            } catch (Exception e) {
//                modelNDto.setErrorMsg(appendErrMsg("�ƶq�榡���~"));
//            }
//        }
//    }
//
//    //�ˬd���
//    protected void checkSellingPrice() {
//        if (modelNDto.getSellingPrice() == null || modelNDto.getSellingPrice().equals("")) {
//            modelNDto.setSellingPrice("");
//            modelNDto.setErrorMsg(appendErrMsg("Selling Price���i��"));
//        } else {
//            try {
//                double priceNumber = Double.parseDouble(modelNDto.getSellingPrice().replace(",", ""));
//                if (priceNumber <= 0) {
//                    modelNDto.setErrorMsg(appendErrMsg("Selling Price�����j��s"));
//                } else {
//                    modelNDto.setSellingPrice((new DecimalFormat("###,##0.000##")).format(priceNumber));
//                }
//            } catch (Exception e) {
//                modelNDto.setErrorMsg(appendErrMsg("����榡���~"));
//            }
//        }
//    }
//
//    //�ˬd�X�f�覡
//    protected void checkShippingMethod() throws SQLException {
//        if (modelNDto.getShippingMethod() == null || modelNDto.getShippingMethod().equals("")) {
//            modelNDto.setShippingMethod("");
//            modelNDto.setErrorMsg(appendErrMsg("�X�f�覡���i�ť�"));
//        } else if (Arrays.asList(new String[] {"004", "005"}).contains(this.salesNo)) {
//            ResultSet rs = this.getFndLookupValuesData();
//            if (rs.isBeforeFirst() ==false) rs.beforeFirst();
//            while (rs.next())
//            {
//                if (rs.getString("MEANING").equals(modelNDto.getTransportation())) {
//                    modelNDto.setShippingMethod(rs.getString("LOOKUP_CODE"));
//                    break;
//                }
//            }
//            if (modelNDto.getShippingMethod().equals("")) {
//                String transportation = modelNDto.getTransportation().equals("") ? "" : modelNDto.getTransportation();
//                modelNDto.setErrorMsg(appendErrMsg("�B��覡���w�q("+(transportation)+")"));
//            }
//        }
//    }
//
//    // �ˬdFOB
//    protected void checkFob() throws SQLException {
//        if (modelNDto.getFob() == null || modelNDto.getFob().equals("")) {
//            modelNDto.setFob("");
//            modelNDto.setErrorMsg(appendErrMsg("FOB���i�ť�"));
//        } else if (Arrays.asList(new String[] {"002", "005", "009"}).contains(this.salesNo)) {
//            ResultSet rs = this.getFobIncotermData();
//            boolean fobExist = false;
//            if (rs.isBeforeFirst() ==false) rs.beforeFirst();
//            while (rs.next())
//            {
//                if (rs.getString("FOB").equals(modelNDto.getFob())) {
//                    fobExist = true;
//                    break;
//                }
//            }
//            if (!fobExist) {
//                String fobIncoterm = modelNDto.getFob().equals("") ? "" : modelNDto.getFob();
//                modelNDto.setErrorMsg(appendErrMsg("FOB���~("+(fobIncoterm)+")"));
//            }
//
//        }
//    }

//
//    // �ˬd End Customer Number
//    protected void checkEndCustNumber() throws SQLException {
//        String sql = "select distinct c.customer_id,c.customer_number,c.customer_name_phonetic \n" +
//                " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c \n" +
//                " ,(select * from oraddman.tssales_area where SALES_AREA_NO='" + salesNo + "') d \n" +
//                " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID \n" +
//                " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%' \n" +
//                " and a.STATUS = b.STATUS \n" +
//                " and a.ORG_ID = b.ORG_ID \n" +
//                " and a.ORG_ID = d.PAR_ORG_ID \n" +
//                " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID \n" +
//                " and c.STATUS='A' \n" +
//                " order by c.customer_id";
//
//        Statement statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
//        ResultSet rs = statement.executeQuery(sql);
//
//        if (rs.isBeforeFirst() == false) rs.beforeFirst();
//        while (rs.next()) {
//            if (rs.getString("customer_number").equals(modelNDto.getEndCustNo())) {
//                modelNDto.setEndCustNamePhonetic(rs.getString("customer_name_phonetic"));
//                modelNDto.setEndCustId(String.valueOf(rs.getInt("customer_id")));
//                break;
//            }
//        }
//        if (modelNDto.getEndCustNamePhonetic().equals("")) {
//            modelNDto.setErrorMsg(appendErrMsg("End Customer ID���s�bERP"));
//        }
//    }
}
