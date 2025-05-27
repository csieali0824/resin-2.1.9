package tscSalesPrice;

import com.mysql.jdbc.StringUtils;
import jxl.write.WritableCellFormat;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.*;

import static tscSalesPrice.TscSalesPriceType.TS;
import static tscSalesPrice.TscSalesPriceType.TSC;

public class TscSalesPrice {
    private List<ExcelColumn> columns = new ArrayList<>();
    private Map<String, WritableCellFormat> styles;

    private List<String> keys(String... keys) {
        return Arrays.asList(keys);
    }

    private static boolean equalsCase(String text, String... options) {
        if (text == null) return false;
        for (String opt : options) {
            if (text.equals(opt)) {
                return true;
            }
        }
        return false;
    }

    public void setTscExcelColumns() throws Exception {
        styles = ExcelWriter.createStyles();
        columns = Arrays.asList(
                new ExcelColumn("22/30-Digit-Code", 30, styles.get("leftL"), keys("SEGMENT1")),
                new ExcelColumn("PART ID", 20, styles.get("leftL"), keys("FAIRCHILD_CPN", "PART_ID")),
                new ExcelColumn("PACKAGE CODE", 15, styles.get("leftL"), null,
                        "PREFEERED_PACKING_CODE_FLAG",
                        (Map<String, Object> rowData) -> {
                            String fairchildCpn = (String) rowData.get("FAIRCHILD_CPN");
                            String packageCode = (String) rowData.get("PACKAGE_CODE");
                            if (!StringUtils.isNullOrEmpty(fairchildCpn) || packageCode.contains("QQ")) return "";
                            return packageCode;
                        },
                        (val, styleMap) -> {
                            if (val != null && "Y".equalsIgnoreCase(val.toString().trim())) {
                                return styleMap.get("leftLR");
                            }
                            return styleMap.get("leftL");
                        }
                ),
                new ExcelColumn("TSC Ordering Code", 25, styles.get("leftL"), keys("FAIRCHILD_CPN", "DESCRIPTION")),
                new ExcelColumn("TP (USD/PCS)", 15, styles.get("rightL"), keys("PRICE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Bottom Price (USD/PCS)", 15, styles.get("rightL"), keys("BOTTOM_PRICE_USD_PCS"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Sales Head price (USD/PCS)", 15, styles.get("rightL"), keys(
                        "SALES_HEAD_PRICE_USD_PCS"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Recommended to Stock in Channel", 15, styles.get("centerL"), keys("RECOMMENDED_STOCK_IN_CHANNEL")),
                new ExcelColumn("Price book Code", 15, styles.get("centerL"), keys("PRICE_BOOK_CODE")),
                new ExcelColumn("Distribution Book Price", 15, styles.get("rightL"), keys("PRICE1"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Distribution MPP Price", 15, styles.get("rightL"), keys("PRICE2"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Design Registration", 15, styles.get("centerL"), keys("DESIGN_REGISTRATION")),
                new ExcelColumn("Design Registration Price", 15, styles.get("rightL"), keys("PRICE3"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Recommended Replacement", 15, styles.get("centerL"), keys("RECOMMENDED_REPLACEMENT")),
                new ExcelColumn("PL Category", 10, styles.get("leftL"), keys("PL_CATEGORY")),
                new ExcelColumn("PROD GROUP", 15, styles.get("leftL"), keys("TSC_PROD_GROUP")),
                new ExcelColumn("TSC Prod Category", 15, styles.get("leftL"), keys("TSC_PROD_CATEGORY")),
                new ExcelColumn("FAMILY", 20, styles.get("leftL"), keys("TSC_FAMILY")),
                new ExcelColumn("PROD FAMILY", 20, styles.get("leftL"), keys("TSC_PROD_FAMILY")),
                new ExcelColumn("PACKAGE", 20, styles.get("leftL"), keys("TSC_PACKAGE")),
                new ExcelColumn("SPQ", 15, styles.get("rightL"), keys("SPQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("MOQ", 15, styles.get("rightL"), keys("MOQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Standard Lead Time(Week)", 15, styles.get("rightL"), keys("LEAD_TIME")),
//                new ExcelColumn("PRICE LAST UPDATE DATE", 15, styles.get("centerL"), keys("PRICE_LAST_UPDATE_DATE"),
//                        val -> {
//                            if (val == null) return "";
//                            if (val instanceof Date) {
//                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
//                            }
//                            return val.toString();
//                        }),
//                new ExcelColumn("22D Creation Date", 15, styles.get("centerL"), keys("ITEM_CREATION_DATE"),
//                        val -> {
//                            if (val == null) return "";
//                            if (val instanceof Date) {
//                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
//                            }
//                            return val.toString();
//                        }),
                new ExcelColumn("Factory", 15, styles.get("centerL"), keys("FACTORY_CODE")),
//                new ExcelColumn("RFQ Factory Code", 12, styles.get("centerL"), keys("ATTRIBUTE3")),
                new ExcelColumn("COO", 7, styles.get("centerL"), keys("COO")),
                new ExcelColumn("COO(TSCA use only)", 7, styles.get("centerL"), keys("COO_CODE")),
                new ExcelColumn("Description", 35, styles.get("leftL"), keys("PART_SPEC")),
                new ExcelColumn("AEC-Q101", 10, styles.get("centerL"), keys("AEC_Q101")),
                new ExcelColumn("MSL", 5, styles.get("leftL"), keys("MSL"),
                        val -> {
                            if (val.toString().equals("0")) return "";
                            return val.toString();
                        }),
                new ExcelColumn("Website Status", 12, styles.get("centerL"), null, null,
                        (Map<String, Object> rowData) -> {
                            String tscProdGroup = (String) rowData.get("TSC_PROD_GROUP");
                            String packageCode = (String) rowData.get("PACKAGE_CODE");
                            String tscPackage = (String) rowData.get("TSC_PACKAGE");
                            String tscFamily = (String) rowData.get("TSC_FAMILY");
                            String description = (String) rowData.get("DESCRIPTION");
                            String websiteStatus = (String) rowData.get("WEBSITE_STATUS");

                            if (!StringUtils.isNullOrEmpty(tscProdGroup) && "PRD".equals(tscProdGroup) && !packageCode.contains("QQ")) {
                                if (!StringUtils.isNullOrEmpty(tscPackage) &&
                                        (("C-SMA".equals(tscPackage) &&
                                                !StringUtils.isNullOrEmpty(tscFamily) &&
                                                !"Trench SKY".equals(tscFamily))) ||
                                        equalsCase(tscPackage, "Folded SMA", "SMA", "SMB") ||
                                        ("SMC".equals(tscPackage) &&
                                                description != null &&
                                                description.startsWith("5.0SMDJ"))
                                ) {
                                    if (!StringUtils.isNullOrEmpty(websiteStatus) && "Active".equals(websiteStatus)) {
                                        return "NRND";
                                    }
                                }
                            }
                            return StringUtils.isNullOrEmpty(websiteStatus) ? "" : websiteStatus;
                        },
                        null
                ),
                new ExcelColumn("Packaging Description", 20, styles.get("centerL"), keys("PACKAGINGDESCRIPTION")),
                new ExcelColumn("Reel/Box (PC)", 12, styles.get("rightL"), keys("REEL_PC", "SPQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Inner Box(PC)", 12, styles.get("rightL"), keys("INNERBOX_PC"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Carton(PC)", 12, styles.get("rightL"), keys("CARTON_PC"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Carton Size(mm)", 16, styles.get("centerL"), keys("CARTONSIZE_MM")),
                new ExcelColumn("Gross Weight(kg/Carton)", 12, styles.get("rightL"), keys("GW_KG_CARTON")),
                new ExcelColumn("PCN/PDN", 25, styles.get("leftL"), keys("PCN_LIST")),
                new ExcelColumn("Product Group 8", 10, styles.get("leftL"), keys("PRODUCT_GROUP_8")),
                new ExcelColumn("Prod Group 5", 10, styles.get("leftL"), keys("PROD_GROUP_5")),
                new ExcelColumn("TARIC Code", 10, styles.get("centerL"), keys("CCCODE")),
                new ExcelColumn("HTS Code(TSCA local use)", 10, styles.get("leftL"), keys("HTS_CODE")),
//                new ExcelColumn("Part Name create Date", 15, styles.get("centerL"), keys("NEW_PARTS_RELEASE_DATE"),
//                        val -> {
//                            if (val == null) return "";
//                            if (val instanceof Date) {
//                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
//                            }
//                            return val.toString();
//                        }),
//                new ExcelColumn("TW Vendor", 8, styles.get("centerL"), keys("TW_VENDOR_FLAG")),
                new ExcelColumn("NPI released to Web", 12, styles.get("centerL"), keys("FIRST_ON_WEBSITE_DATE")),
                new ExcelColumn("F400 PRODUCT", 12, styles.get("centerL"), keys("F400_PRODUCT")),
                new ExcelColumn("SPG STATUS", 12, styles.get("centerL"), keys("SPG_STATUS")),
                new ExcelColumn("PROD HIERARCHY 1", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_1")),
                new ExcelColumn("PROD HIERARCHY 2", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_2")),
                new ExcelColumn("PROD HIERARCHY 3", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_3")),
                new ExcelColumn("PROD HIERARCHY 4", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_4")),
                new ExcelColumn("Part Name create Date", 15, styles.get("centerL"), keys("NEW_PARTS_RELEASE_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("PRICE LAST UPDATE DATE", 15, styles.get("centerL"), keys("PRICE_LAST_UPDATE_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("22D Creation Date", 15, styles.get("centerL"), keys("ITEM_CREATION_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("TW Vendor", 8, styles.get("centerL"), keys("TW_VENDOR_FLAG")),
                new ExcelColumn("RFQ Factory Code", 12, styles.get("centerL"), keys("ATTRIBUTE3"))

        );
    }

    public void setTsExcelColumns() throws Exception {
        styles = ExcelWriter.createStyles();
        columns = Arrays.asList(
                new ExcelColumn("22/30-Digit-Code", 30, styles.get("leftL"), keys("SEGMENT1")),
                new ExcelColumn("PART ID", 20, styles.get("leftL"), keys("PART_ID")),
                new ExcelColumn("PACKAGE CODE", 15, styles.get("leftL"), null,
                        "PREFEERED_PACKING_CODE_FLAG",
                        (Map<String, Object> rowData) -> {
                            String fairchildCpn = (String) rowData.get("FAIRCHILD_CPN");
                            String packageCode = (String) rowData.get("PACKAGE_CODE");
                            if (!StringUtils.isNullOrEmpty(fairchildCpn) || packageCode.contains("QQ")) return "";
                            return packageCode;
                        },
                        (val, styleMap) -> {
                            if (val != null && "Y".equalsIgnoreCase(val.toString().trim())) {
                                return styleMap.get("leftLR");
                            }
                            return styleMap.get("leftL");
                        }
                ),
                new ExcelColumn("TSC Ordering Code", 25, styles.get("leftL"), keys( "DESCRIPTION")),
                new ExcelColumn("PROD GROUP", 15, styles.get("leftL"), keys("TSC_PROD_GROUP")),
                new ExcelColumn("TSC Prod Category", 15, styles.get("leftL"), keys("TSC_PROD_CATEGORY")),
                new ExcelColumn("FAMILY", 20, styles.get("leftL"), keys("TSC_FAMILY")),
                new ExcelColumn("PROD FAMILY", 20, styles.get("leftL"), keys("TSC_PROD_FAMILY")),
                new ExcelColumn("PACKAGE", 20, styles.get("leftL"), keys("TSC_PACKAGE")),
                new ExcelColumn("SPQ", 15, styles.get("rightL"), keys("SPQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("MOQ", 15, styles.get("rightL"), keys("MOQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("SAMPLE SPQ", 15, styles.get("rightL"), keys("SAMPLE_SPQ"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Standard Lead Time(Week)", 15, styles.get("rightL"), keys("LEAD_TIME")),
                new ExcelColumn("PRICE", 15, styles.get("rightL"), keys("PRICE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("UOM", 15, styles.get("centerL"), keys("UOM")),
                new ExcelColumn("PRICE LAST UPDATE DATE", 15, styles.get("centerL"), keys("PRICE_LAST_UPDATE_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("22D Creation Date", 15, styles.get("centerL"), keys("ITEM_CREATION_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Factory", 15, styles.get("centerL"), keys("FACTORY_CODE")),
                new ExcelColumn("RFQ Factory Code", 12, styles.get("centerL"), keys("ATTRIBUTE3")),
                new ExcelColumn("COO", 7, styles.get("centerL"), keys("COO")),
                new ExcelColumn("COO(TSCA use only)", 7, styles.get("centerL"), keys("COO_CODE")),
                new ExcelColumn("AEC-Q101", 10, styles.get("centerL"), keys("AEC_Q101")),
                new ExcelColumn("Description", 35, styles.get("leftL"), keys("PART_SPEC")),
                new ExcelColumn("MSL", 5, styles.get("leftL"), keys("MSL"),
                        val -> {
                            if (val.toString().equals("0")) return "";
                            return val.toString();
                        }),
                new ExcelColumn("Website Status", 12, styles.get("centerL"), null, null,
                        (Map<String, Object> rowData) -> {
                            String description = (String) rowData.get("DESCRIPTION");
                            String websiteStatus = (String) rowData.get("WEBSITE_STATUS");
                            if (description.startsWith("TSM3446CX6 RKG")) {
                                return "Obsolete";
                            }
                            return StringUtils.isNullOrEmpty(websiteStatus) ? "" : websiteStatus;
                        },
                        null
                ),
                new ExcelColumn("Packaging Description", 20, styles.get("centerL"), keys("PACKAGINGDESCRIPTION")),
                new ExcelColumn("Reel(PC)", 12, styles.get("rightL"), keys("REEL_PC"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Inner Box(PC)", 12, styles.get("rightL"), keys("INNERBOX_PC"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Carton(PC)", 12, styles.get("rightL"), keys("CARTON_PC"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Number) {
                                return new BigDecimal(val.toString()).stripTrailingZeros().toPlainString();
                            }
                            return val.toString();
                        }),
                new ExcelColumn("Carton Size(mm)", 16, styles.get("centerL"), keys("CARTONSIZE_MM")),
                new ExcelColumn("Gross Weight(kg/Carton)", 12, styles.get("rightL"), keys("GW_KG_CARTON")),
                new ExcelColumn("PCN/PDN", 25, styles.get("leftL"), keys("PCN_LIST")),
                new ExcelColumn("Product Group 8", 10, styles.get("leftL"), keys("PRODUCT_GROUP_8")),
                new ExcelColumn("Prod Group 5", 10, styles.get("leftL"), keys("PROD_GROUP_5")),
                new ExcelColumn("Part Name create Date", 15, styles.get("centerL"), keys("NEW_PARTS_RELEASE_DATE"),
                        val -> {
                            if (val == null) return "";
                            if (val instanceof Date) {
                                return new SimpleDateFormat("yyyy-MM-dd").format((Date) val);
                            }
                            return val.toString();
                        }),
                new ExcelColumn("TARIC Code", 10, styles.get("centerL"), keys("CCCODE")),
                new ExcelColumn("HTS Code(TSCA local use)", 10, styles.get("leftL"), keys("HTS_CODE")),
                new ExcelColumn("NPI released to Web", 12, styles.get("centerL"), keys("FIRST_ON_WEBSITE_DATE")),
                new ExcelColumn("PROD HIERARCHY 1", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_1")),
                new ExcelColumn("PROD HIERARCHY 2", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_2")),
                new ExcelColumn("PROD HIERARCHY 3", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_3")),
                new ExcelColumn("PROD HIERARCHY 4", 20, styles.get("leftL"), keys("TSC_PROD_HIERARCHY_4"))
        );
    }

    public void downloadTscSalesPrice(Connection conn, HttpServletResponse response, String item) throws Exception {
        String sql ="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
        PreparedStatement pstmt1=conn.prepareStatement(sql);
        pstmt1.executeUpdate();
        pstmt1.close();

        CallableStatement cs = conn.prepareCall("{call mo_global.set_policy_context('S',?)}");
        cs.setString(1,"41");
        cs.execute();
        cs.close();

        TscSalesPriceType type = item.equals(TSC.name()) ? TSC : TS;
        String name = "";
        int freezeCol = 0;
        List<Map<String, Object>> dataList = new ArrayList<>();
        switch (type) {
            case TSC:
                name = "TSC distribution price book";
                freezeCol = 5;
                dataList = getTscResultSetToList(conn);
                setTscExcelColumns();
                break;
            case TS:
                name = "TS Item Price Report";
                freezeCol = 6;
                dataList = getTsResultSetToList(conn);
                setTsExcelColumns();
                break;
            default:
                break;
        }

        String fileName = name + "-" + new SimpleDateFormat("yyyyMMddHHmm").format(new Date()) + ".xls";
        response.reset();
        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        try (OutputStream os = response.getOutputStream()) {  // Get output stream from response
            String dataDateStr = "Data Date: " + new SimpleDateFormat("yyyy-MM-dd").format(new Date());
            ExcelWriter.writeExcel(os, dataDateStr, columns, dataList, styles, freezeCol);
            System.out.println("Excel 匯出成功");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public List<Map<String, Object>> getTsResultSetToList(Connection conn) throws SQLException {
        String sql = "with s1 as(SELECT a.*,\n" +
                "       CASE\n" +
                "           WHEN a.attribute3 IN ('005') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               ROUND (\n" +
                "                   DECODE (pp_ssd.TP_PRICE_UOM,\n" +
                "                           'KPC', pp_ssd.TP_PRICE / 1000,\n" +
                "                           pp_ssd.TP_PRICE),\n" +
                "                   5)\n" +
                "           WHEN a.attribute3 IN ('008') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               ROUND (\n" +
                "                   DECODE (pp_prod.TP_PRICE_UOM,\n" +
                "                           'KPC', pp_prod.TP_PRICE / 1000,\n" +
                "                           pp_prod.TP_PRICE),\n" +
                "                   5)\n" +
                "           ELSE\n" +
                "               DECODE (pp.TP_PRICE_UOM,\n" +
                "                       'KPC', pp.TP_PRICE / 1000,\n" +
                "                       pp.TP_PRICE)\n" +
                "       END\n" +
                "           AS PRICE,\n" +
                "       CASE\n" +
                "           WHEN a.attribute3 IN ('005') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               TO_CHAR (pp_ssd.last_update_date, 'yyyy-mm-dd')\n" +
                "           WHEN a.attribute3 IN ('008') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               TO_CHAR (pp_prod.last_update_date, 'yyyy-mm-dd')\n" +
                "           ELSE\n" +
                "               TO_CHAR (pp.last_update_date, 'yyyy-mm-dd')\n" +
                "       END\n" +
                "           AS price_last_update_date,\n" +
                "       CASE\n" +
                "           WHEN a.attribute3 IN ('005') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               pp_ssd.TP_PRICE_UOM\n" +
                "           WHEN a.attribute3 IN ('008') AND a.tw_vendor_flag = 'N'\n" +
                "           THEN\n" +
                "               pp_prod.TP_PRICE_UOM\n" +
                "           ELSE\n" +
                "               pp.TP_PRICE_UOM\n" +
                "       END\n" +
                "           AS PRODUCT_UOM_CODE,\n" +
                "       'PCE'                                           UOM,\n" +
                "       qq.SPQ,\n" +
                "       qq.MOQ,\n" +
                "       qq.SAMPLE_SPQ,\n" +
                "       tt.LEAD_TIME,\n" +
                "       tt.NO_WAFER_LEAD_TIME,\n" +
                "       TSC_INV_Prod_Group_7 (a.inventory_item_id, a.organization_id)\n" +
                "           Product_Group_8,\n" +
                "       aecq.series_aecq,\n" +
                "       aecq.part_spec,\n" +
                "       aecq.website_status,\n" +
                "       TO_CHAR (aecq.obsolete_timestamp, 'yyyy/mm/dd') obsolete_timestamp,\n" +
                "       TO_CHAR (aecq.first_on_website_date, 'yyyy/mm/dd')\n" +
                "           first_on_website_date,\n" +
                "       NVL (aecq.msl, 'NA')                            msl,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON' THEN on_packing.reel_qty\n" +
                "           ELSE REPLACE (NVL (tpi.reel_pc, tpii.reel_pc), '-', '')\n" +
                "       END\n" +
                "           reel_pc,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON' THEN on_packing.box_qty\n" +
                "           ELSE REPLACE (NVL (tpi.innerbox_pc, tpii.innerbox_pc), '-', '')\n" +
                "       END\n" +
                "           innerbox_pc,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON' THEN on_packing.carton_qty\n" +
                "           ELSE REPLACE (NVL (tpi.carton_pc, tpii.carton_pc), '-', '')\n" +
                "       END\n" +
                "           carton_pc,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON' THEN on_packing.carton_size\n" +
                "           ELSE NVL (tpi.CartonSize, tpii.CartonSize)\n" +
                "       END\n" +
                "           CartonSize_mm,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON'\n" +
                "           THEN\n" +
                "               on_packing.carton_weight\n" +
                "           ELSE\n" +
                "               NVL (tpi.GW_KG, tpii.GW_KG)\n" +
                "       END\n" +
                "           GW_KG_CARTON,\n" +
                "       (SELECT TO_CHAR (MAX (oola.creation_date), 'yyyy/mm/dd')\n" +
                "          FROM ont.oe_order_headers_all ooha, ont.oe_order_lines_all oola\n" +
                "         WHERE     ooha.header_id = oola.header_id\n" +
                "               AND oola.inventory_item_id = a.inventory_item_id\n" +
                "               AND SUBSTR (ooha.order_number, 1, 4) IN ('1121',\n" +
                "                                                        '1131',\n" +
                "                                                        '1141',\n" +
                "                                                        '1142',\n" +
                "                                                        '1156',\n" +
                "                                                        '1214',\n" +
                "                                                        '7141',\n" +
                "                                                        '7214',\n" +
                "                                                        '7121'))\n" +
                "           last_order_date,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON'\n" +
                "           THEN\n" +
                "               on_packing.PACKAGINGDESCRIPTION\n" +
                "           ELSE\n" +
                "               NVL (tpi.PACKAGINGDESCRIPTION, tpii.PACKAGINGDESCRIPTION)\n" +
                "       END\n" +
                "           PACKAGINGDESCRIPTION,\n" +
                "       CASE\n" +
                "           WHEN SUBSTR (a.ITEM_DESC1, -3) = '-ON' THEN NULL\n" +
                "           ELSE NVL (tpi.PART_NO_LIST, tpii.PART_NO_LIST)\n" +
                "       END\n" +
                "           PART_NO_LIST1,\n" +
                "       ROW_NUMBER ()\n" +
                "       OVER (\n" +
                "           PARTITION BY a.SEGMENT1\n" +
                "           ORDER BY\n" +
                "               DECODE (a.ITEM_DESC1,\n" +
                "                       NVL (tpi.part_no_list, tpii.part_no_list), 1,\n" +
                "                       2))\n" +
                "           item_cnt,\n" +
                "       CASE\n" +
                "           WHEN a.attribute3 = '005' AND a.tw_vendor_flag = 'N' THEN 'CHINA'\n" +
                "           ELSE a.COO_CODE\n" +
                "       END\n" +
                "           COO,\n" +
                "       CASE a.TSC_PROD_GROUP\n" +
                "           WHEN 'PRD'\n" +
                "           THEN\n" +
                "               CASE\n" +
                "                   WHEN SUBSTR (a.segment1, 11, 1) IN ('2', 'H') THEN 'Yes'\n" +
                "                   ELSE ''\n" +
                "               END\n" +
                "           WHEN 'SSD'\n" +
                "           THEN\n" +
                "               CASE\n" +
                "                   WHEN SUBSTR (a.segment1, 11, 1) IN ('2', 'H') THEN 'Yes'\n" +
                "                   ELSE ''\n" +
                "               END\n" +
                "           WHEN 'PMD'\n" +
                "           THEN\n" +
                "               CASE\n" +
                "                   WHEN SUBSTR (a.segment1, 11, 2) = 'TP' THEN 'Yes'\n" +
                "                   ELSE ''\n" +
                "               END\n" +
                "           ELSE\n" +
                "               ''\n" +
                "       END\n" +
                "           AEC_Q101,\n" +
                "       tsc_packing_info_preferred (a.inventory_item_id)\n" +
                "           prefeered_packing_code_flag,\n" +
                "       (SELECT LISTAGG (pl_category, ',') WITHIN GROUP (ORDER BY pl_category)\n" +
                "                   xx\n" +
                "          FROM oraddman.ts_pl_category ttpc\n" +
                "         WHERE     ttpc.TSC_PROD_GROUP = a.TSC_PROD_GROUP\n" +
                "               AND NVL (ttpc.TSC_PROD_CATEGORY, a.TSC_PROD_CATEGORY) =\n" +
                "                       a.TSC_PROD_CATEGORY\n" +
                "               AND ttpc.TSC_FAMILY = a.TSC_FAMILY\n" +
                "               AND NVL (ttpc.TSC_PROD_FAMILY, NVL (a.TSC_PROD_FAMILY, 'XXX')) =\n" +
                "                       NVL (a.TSC_PROD_FAMILY, 'XXX'))\n" +
                "           pl_category\n" +
                "  FROM (SELECT msi.organization_id,\n" +
                "               msi.segment1,\n" +
                "               msi.description,\n" +
                "               msi.inventory_item_id,\n" +
                "               msi.attribute3,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 23) TSC_PACKAGE,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000003)\n" +
                "                   TSC_PROD_GROUP,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 21) TSC_FAMILY,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000123)\n" +
                "                   TSC_PROD_CATEGORY,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000203)\n" +
                "                   TSC_prod_hierarchy_1,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000204)\n" +
                "                   TSC_prod_hierarchy_2,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000205)\n" +
                "                   TSC_prod_hierarchy_3,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 1100000206)\n" +
                "                   TSC_prod_hierarchy_4,\n" +
                "               CASE\n" +
                "                   WHEN TSC_INV_CATEGORY (msi.inventory_item_id,\n" +
                "                                          43,\n" +
                "                                          1100000003) IN\n" +
                "                            ('PMD', 'SSD', 'SSP')\n" +
                "                   THEN\n" +
                "                       TSC_INV_CATEGORY (msi.inventory_item_id,\n" +
                "                                         43,\n" +
                "                                         1100000004)\n" +
                "                   ELSE\n" +
                "                       ''\n" +
                "               END\n" +
                "                   TSC_PROD_FAMILY,\n" +
                "               TSC_GET_ITEM_PACKING_CODE (43, msi.inventory_item_id)\n" +
                "                   PACKAGE_CODE,\n" +
                "               TSC_GET_PARTNO (MSI.ORGANIZATION_ID, MSI.INVENTORY_ITEM_ID)\n" +
                "                   ITEM_DESC,\n" +
                "               TSC_GET_ITEM_DESC_NOPACKING (MSI.ORGANIZATION_ID,\n" +
                "                                            MSI.INVENTORY_ITEM_ID)\n" +
                "                   ITEM_DESC1,\n" +
                "               TSC_INV_CATEGORY (msi.inventory_item_id, 43, 24) TSC_PARTNO,\n" +
                "               tm.ALENGNAME                                     factory_code,\n" +
                "               pcn.pcn_list,\n" +
                "               TO_CHAR (pt.creation_date, 'yyyy-mm-dd')\n" +
                "                   parts_release_date,\n" +
                "               CASE\n" +
                "                   WHEN TSC_INV_CATEGORY (msi.inventory_item_id,\n" +
                "                                          49,\n" +
                "                                          1100000003) IN\n" +
                "                            ('PRD', 'PRD-Subcon')\n" +
                "                   THEN\n" +
                "                       TO_CHAR (\n" +
                "                           MIN (\n" +
                "                               pt.CREATION_DATE)\n" +
                "                           OVER (\n" +
                "                               PARTITION BY    SUBSTR (msi.segment1, 1, 10)\n" +
                "                                            || '1'\n" +
                "                                            || SUBSTR (msi.segment1, 12)),\n" +
                "                           'yyyy-mm-dd')\n" +
                "                   ELSE\n" +
                "                       TO_CHAR (pt.creation_date, 'yyyy-mm-dd')\n" +
                "               END\n" +
                "                   new_parts_release_date,\n" +
                "               TO_CHAR (msi.creation_date, 'yyyy-mm-dd')\n" +
                "                   item_creation_date,\n" +
                "               CASE\n" +
                "                   WHEN tm.manufactory_no IN ('002', '008')\n" +
                "                   THEN\n" +
                "                       'CHINA'\n" +
                "                   WHEN tm.manufactory_no IN ('005',\n" +
                "                                              '006',\n" +
                "                                              '010',\n" +
                "                                              '011')\n" +
                "                   THEN\n" +
                "                       'TAIWAN'\n" +
                "                   ELSE\n" +
                "                       ''\n" +
                "               END\n" +
                "                   AS COO_CODE,\n" +
                "               TRIM (SUBSTR (cc.cccode, -11))                   cccode,\n" +
                "               msii.INVENTORY_ITEM_STATUS_CODE                  IM_STATUS,\n" +
                "               CASE\n" +
                "                   WHEN 'Y' IN\n" +
                "                            (NVL (msi.CUSTOMER_ORDER_ENABLED_FLAG, 'N'),\n" +
                "                             NVL (msi.INTERNAL_ORDER_ENABLED_FLAG, 'N'))\n" +
                "                   THEN\n" +
                "                       'Y'\n" +
                "                   ELSE\n" +
                "                       'N'\n" +
                "               END\n" +
                "                   AS ORDER_ENABLED_FLAG,\n" +
                "               (SELECT PACKAGE_TYPE\n" +
                "                  FROM ORADDMAN.TSC_PACKAGE_TYPE B\n" +
                "                 WHERE TSC_PACKAGE =\n" +
                "                           TSC_INV_CATEGORY (msi.INVENTORY_ITEM_ID,\n" +
                "                                             msi.ORGANIZATION_ID,\n" +
                "                                             23))\n" +
                "                   PACKAGE_TYPE,\n" +
                "               TSCA_GET_HTS_CODE (msi.inventory_item_id,\n" +
                "                                  TRIM (SUBSTR (cc.cccode, -11)))\n" +
                "                   HTS_CODE,\n" +
                "               NVL (\n" +
                "                   NVL (\n" +
                "                       (SELECT DISTINCT 'Y'\n" +
                "                          FROM po_headers_all x, po_lines_all y\n" +
                "                         WHERE     x.TYPE_LOOKUP_CODE = 'BLANKET'\n" +
                "                               AND x.ORG_ID IN (41)\n" +
                "                               AND NVL (x.cancel_flag, 'N') = 'N'\n" +
                "                               AND NVL (x.closed_code, 'OPEN') NOT LIKE\n" +
                "                                       '%CLOSED%'\n" +
                "                               AND NVL (y.cancel_flag, 'N') = 'N'\n" +
                "                               AND NVL (y.closed_code, 'OPEN') <> 'CLOSED'\n" +
                "                               AND NVL (y.closed_flag, 'N') <> 'Y'\n" +
                "                               AND y.item_id = msi.inventory_item_id\n" +
                "                               AND x.po_header_id = y.po_header_id\n" +
                "                               AND EXISTS\n" +
                "                                       (SELECT 1\n" +
                "                                          FROM oraddman.tssg_vendor_tw z\n" +
                "                                         WHERE     z.vendor_site_id =\n" +
                "                                                       x.VENDOR_SITE_ID\n" +
                "                                               AND NVL (z.active_flag, 'N') =\n" +
                "                                                       'A')),\n" +
                "                       (SELECT 'Y'\n" +
                "                          FROM ORADDMAN.TSSG_VENDOR_TW_PARTS X\n" +
                "                         WHERE X.PART_NAME =\n" +
                "                                   TSC_GET_ITEM_DESC_NOPACKING (\n" +
                "                                       MSI.ORGANIZATION_ID,\n" +
                "                                       MSI.INVENTORY_ITEM_ID))),\n" +
                "                   'N')\n" +
                "                   tw_vendor_flag,\n" +
                "               NVL (tpcl.default_packing_code,\n" +
                "                    tsc_get_item_packing_code (43, msi.inventory_item_id))\n" +
                "                   default_packing_code,\n" +
                "               CASE\n" +
                "                   WHEN INSTR (\n" +
                "                            TSC_GET_ITEM_PACKING_CODE (43,\n" +
                "                                                       msi.inventory_item_id),\n" +
                "                            'QQ') > 0\n" +
                "                   THEN\n" +
                "                       msi.description\n" +
                "                   ELSE\n" +
                "                       TRIM (\n" +
                "                           SUBSTR (\n" +
                "                               msi.description,\n" +
                "                               0,\n" +
                "                                 LENGTH (msi.description)\n" +
                "                               - LENGTH (\n" +
                "                                     TSC_GET_ITEM_PACKING_CODE (\n" +
                "                                         43,\n" +
                "                                         msi.inventory_item_id))))\n" +
                "               END\n" +
                "                   part_id,\n" +
                "            case when tsdp.TSC_ORDERING_CODE is not null then 'YES' else '' end as F400_PRODUCT       \n" +
                "          FROM MTL_SYSTEM_ITEMS             msi,\n" +
                "               MTL_SYSTEM_ITEMS             msii,\n" +
                "               oraddman.tsprod_manufactory  tm,\n" +
                "               (  SELECT TSC_PART_NO,\n" +
                "                         LISTAGG (PCN_NUMBER, ',')\n" +
                "                             WITHIN GROUP (ORDER BY PCN_NUMBER)\n" +
                "                             pcn_list\n" +
                "                    FROM (  SELECT TSC_PART_NO, PCN_NUMBER\n" +
                "                              FROM oraddman.tsqra_pcn_item_detail a\n" +
                "                             WHERE SOURCE_TYPE = 2\n" +
                "                          GROUP BY TSC_PART_NO, PCN_NUMBER) X\n" +
                "                GROUP BY TSC_PART_NO) pcn,\n" +
                "               (SELECT y.INVENTORY_ITEM_ID,\n" +
                "                       y.ORGANIZATION_ID,\n" +
                "                       x.SEGMENT1,\n" +
                "                       x.CREATION_DATE\n" +
                "                  FROM inv.mtl_categories_b x, inv.mtl_item_categories y\n" +
                "                 WHERE     STRUCTURE_ID = 50203\n" +
                "                       AND x.CATEGORY_ID = y.CATEGORY_ID\n" +
                "                       AND y.ORGANIZATION_ID = 49\n" +
                "                       AND y.CATEGORY_SET_ID = 24) pt,\n" +
                "               (SELECT mc.inventory_item_id, mc.organization_id, tc.cccode\n" +
                "                  FROM mtl_item_categories  mc,\n" +
                "                       mtl_categories_tl    mct,\n" +
                "                       tsc_cccode           tc\n" +
                "                 WHERE     mc.CATEGORY_SET_ID = 6\n" +
                "                       AND mc.category_id = mct.category_id\n" +
                "                       AND mct.language = 'US'\n" +
                "                       AND tc.category_id = mct.category_id\n" +
                "                       AND tc.language = mct.language) cc,\n" +
                "               (SELECT *\n" +
                "                  FROM oraddman.tsc_packing_conversion_list\n" +
                "                 WHERE NVL (INACTIVE_DATE, TO_DATE ('20991231', 'yyyymmdd')) >\n" +
                "                           TRUNC (SYSDATE)) tpcl,\n" +
                "               TSC_SALES_DISTRIBUTION_PRICE tsdp\n" +
                "         WHERE     msi.ORGANIZATION_ID = 49\n" +
                "               AND LENGTH (msi.SEGMENT1) >= 22\n" +
                "               AND msi.INVENTORY_ITEM_ID = tsdp.INVENTORY_ITEM_ID(+)\n" +
                "               and case \n" +
                "                     when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description \n" +
                "                     else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id))))\n" +
                "                   end = tsdp.part_id(+)\n" +
                "               and msi.description = tsdp.tsc_ordering_code(+)\n" +
                "               AND TSC_INV_Category (msi.inventory_item_id, 43, 23) =\n" +
                "                       tpcl.tsc_package(+)\n" +
                "               AND tsc_get_item_packing_code (43, msi.inventory_item_id) =\n" +
                "                       tpcl.packing_code(+)\n" +
                "               AND msi.ITEM_TYPE = 'FG'\n" +
                "               AND msi.INVENTORY_ITEM_STATUS_CODE <> 'Inactive'\n" +
                "               AND msii.ORGANIZATION_ID = 43\n" +
                "               AND LENGTH (msii.SEGMENT1) >= 22\n" +
                "               AND msii.ITEM_TYPE = 'FG'\n" +
                "               AND msi.inventory_item_id = msii.inventory_item_id\n" +
                "               AND UPPER (msi.DESCRIPTION) NOT LIKE '%DISABLE%'\n" +
                "               AND msi.attribute3 = tm.manufactory_no(+)\n" +
                "               AND msi.description = pcn.TSC_PART_NO(+)\n" +
                "               AND msi.organization_id = pt.ORGANIZATION_ID(+)\n" +
                "               AND msi.INVENTORY_ITEM_ID = pt.INVENTORY_ITEM_ID(+)\n" +
                "               AND msi.organization_id = cc.ORGANIZATION_ID(+)\n" +
                "               AND msi.INVENTORY_ITEM_ID = cc.INVENTORY_ITEM_ID(+)) A,\n" +
                "       TABLE (TSC_GET_ITEM_SPQ_MOQ (a.inventory_item_id, 'TS', NULL))  qq,\n" +
                "       TABLE (\n" +
                "           TSC_GET_ITEM_LEADTIME (a.inventory_item_id, a.attribute3, NULL))\n" +
                "       tt,\n" +
                "       TABLE (TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW (\n" +
                "                  43,\n" +
                "                  a.inventory_item_id,\n" +
                "                  'PCE',\n" +
                "                  7257,\n" +
                "                  NVL (TO_DATE ('', 'YYYY/MM/DD'), TRUNC (SYSDATE)),\n" +
                "                  'USD',\n" +
                "                  CASE a.attribute3\n" +
                "                      WHEN '002' THEN 'Y'\n" +
                "                      WHEN '005' THEN 'T'\n" +
                "                      WHEN '006' THEN 'I'\n" +
                "                      WHEN '008' THEN 'T'\n" +
                "                      WHEN '010' THEN 'A'\n" +
                "                      WHEN '011' THEN 'E'\n" +
                "                      ELSE 'X'\n" +
                "                  END,\n" +
                "                  NULL)) pp,\n" +
                "       TABLE (TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW (\n" +
                "                  43,\n" +
                "                  a.inventory_item_id,\n" +
                "                  'PCE',\n" +
                "                  9455,\n" +
                "                  NVL (TO_DATE ('', 'YYYY/MM/DD'), TRUNC (SYSDATE)),\n" +
                "                  'CNY',\n" +
                "                  CASE a.attribute3\n" +
                "                      WHEN '002' THEN 'Y'\n" +
                "                      WHEN '005' THEN 'T'\n" +
                "                      WHEN '006' THEN 'I'\n" +
                "                      WHEN '008' THEN 'T'\n" +
                "                      WHEN '010' THEN 'A'\n" +
                "                      WHEN '011' THEN 'E'\n" +
                "                      ELSE 'X'\n" +
                "                  END,\n" +
                "                  NULL)) pp_cny,\n" +
                "       TABLE (TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW (\n" +
                "                  43,\n" +
                "                  a.inventory_item_id,\n" +
                "                  'PCE',\n" +
                "                  8534,\n" +
                "                  NVL (TO_DATE ('', 'YYYY/MM/DD'), TRUNC (SYSDATE)),\n" +
                "                  'USD',\n" +
                "                  CASE a.attribute3\n" +
                "                      WHEN '002' THEN 'Y'\n" +
                "                      WHEN '005' THEN 'T'\n" +
                "                      WHEN '006' THEN 'I'\n" +
                "                      WHEN '008' THEN 'T'\n" +
                "                      WHEN '010' THEN 'A'\n" +
                "                      WHEN '011' THEN 'E'\n" +
                "                      ELSE 'X'\n" +
                "                  END,\n" +
                "                  NULL)) pp_ssd,\n" +
                "       TABLE (TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW (\n" +
                "                  43,\n" +
                "                  a.inventory_item_id,\n" +
                "                  'PCE',\n" +
                "                  8508,\n" +
                "                  NVL (TO_DATE ('', 'YYYY/MM/DD'), TRUNC (SYSDATE)),\n" +
                "                  'USD',\n" +
                "                  CASE a.attribute3\n" +
                "                      WHEN '002' THEN 'Y'\n" +
                "                      WHEN '005' THEN 'T'\n" +
                "                      WHEN '006' THEN 'I'\n" +
                "                      WHEN '008' THEN 'T'\n" +
                "                      WHEN '010' THEN 'A'\n" +
                "                      WHEN '011' THEN 'E'\n" +
                "                      ELSE 'X'\n" +
                "                  END,\n" +
                "                  NULL)) pp_prod,\n" +
                "       TABLE (tsc_get_aecq_info (a.inventory_item_id))                 aecq,\n" +
                "       (SELECT *\n" +
                "          FROM oraddman.tsc_packing_info_list\n" +
                "         WHERE part_no_list IS NOT NULL) tpi,\n" +
                "       (SELECT *\n" +
                "          FROM oraddman.tsc_packing_info_list\n" +
                "         WHERE part_no_list IS NULL) tpii,\n" +
                "       (SELECT a.ALTERNATE_ROUTING TSC_PACKAGE,\n" +
                "               a.DEM_LOCATION_ID   SPQ,\n" +
                "               a.EXP_LOCATION_ID   MOQ,\n" +
                "               a.CODE_DESC         REEL_QTY,\n" +
                "               a.CODE_DESC2        BOX_QTY,\n" +
                "               a.CODE_DESC3        CARTON_QTY,\n" +
                "               a.CODE_DESC4        CARTON_SIZE,\n" +
                "               a.CODE_DESC5        CARTON_WEIGHT,\n" +
                "               a.code_desc6        PACKAGINGDESCRIPTION\n" +
                "          FROM yew_mfg_defdata a\n" +
                "         WHERE DEF_TYPE = 'ON') on_packing\n" +
                " WHERE     1 = 1\n" +
                "       AND a.ITEM_DESC1 = tpi.PART_NO_LIST(+)\n" +
                "       AND a.TSC_PACKAGE = tpii.TSC_PACKAGE(+)\n" +
                "       AND SUBSTR (UPPER (TRIM (a.PACKAGE_CODE)), 1, 2) = tpii.PackingCode(+)\n" +
                "       AND CASE\n" +
                "               WHEN    UPPER (a.TSC_PROD_GROUP) = 'PRD-SUBCON'\n" +
                "                    OR UPPER (a.TSC_PACKAGE) = 'I2PAK'\n" +
                "               THEN\n" +
                "                   'PRD'\n" +
                "               ELSE\n" +
                "                   a.TSC_PROD_GROUP\n" +
                "           END = tpii.GROUPTYPE(+)\n" +
                "       AND a.TSC_PACKAGE = on_packing.TSC_PACKAGE(+)\n" +
                ")\n" +
                "SELECT \n" +
                "  s1.*,\n" +
                "  CASE \n" +
                "    WHEN PRODUCT_GROUP_8 IS NULL THEN ''\n" +
                "    WHEN PRODUCT_GROUP_8 = 'LIGHTING IC' THEN 'PMD'\n" +
                "    WHEN PRODUCT_GROUP_8 IN ('MOSFET-Subcon', 'Super Junction', 'Super Junction-Subcon') THEN 'MOSFET'\n" +
                "    WHEN PRODUCT_GROUP_8 IN ('PRD-Subcon', 'TRENCH SCHOTTKY') THEN 'PRD'\n" +
                "    ELSE PRODUCT_GROUP_8\n" +
                "  END AS PROD_GROUP_5\n" +
                "FROM s1";

        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        List<Map<String, Object>> rows = new ArrayList<>();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        while (rs.next()) {
            if (rs.getString("PACKAGE_CODE") ==null || rs.getInt("ITEM_CNT")!=1 ) continue; //add by Peggy 20181023
            Map<String, Object> row = new LinkedHashMap<>(); // 使用 LinkedHashMap 保持欄位順序
            for (int i = 1; i <= columnCount; i++) {
                String columnName = metaData.getColumnLabel(i); // getColumnLabel 可拿到 SQL 別名
                Object value = rs.getObject(i);
                row.put(columnName, value);
            }
            rows.add(row);
        }
        rs.close();
        statement.close();
        conn.close();
        return rows;
    }


    public List<Map<String, Object>> getTscResultSetToList(Connection conn) throws SQLException {
        String sql = "with s1 as (\n" +
                "    select a.*,case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
                "    then round(decode( pp_ssd.TP_PRICE_UOM,'KPC',pp_ssd.TP_PRICE/1000,pp_ssd.TP_PRICE),5)\n" +
                "     when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
                "     then round(decode( pp_prod.TP_PRICE_UOM,'KPC',pp_prod.TP_PRICE/1000,pp_prod.TP_PRICE),5) \n" +
                "     else decode( pp.TP_PRICE_UOM,'KPC',pp.TP_PRICE/1000,pp.TP_PRICE) end AS PRICE\n" +
                "     ,case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
                "     then to_char(pp_ssd.last_update_date,'yyyy-mm-dd')  \n" +
                "     when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
                "     then to_char(pp_prod.last_update_date,'yyyy-mm-dd') \n" +
                "     else to_char(pp.last_update_date,'yyyy-mm-dd') end AS price_last_update_date,\n" +
                "     case when a.attribute3 in ('005') and a.tw_vendor_flag='N' \n" +
                "     then pp_ssd.TP_PRICE_UOM when a.attribute3 in ('008') and a.tw_vendor_flag='N' \n" +
                "     then pp_prod.TP_PRICE_UOM else pp.TP_PRICE_UOM end as PRODUCT_UOM_CODE,'\n" +
                "     PCE' UOM,qq.SPQ,qq.MOQ,qq.SAMPLE_SPQ,tt.LEAD_TIME,tt.NO_WAFER_LEAD_TIME,\n" +
                "     TSC_INV_Prod_Group_7(a.inventory_item_id ,a.organization_id) Product_Group_8,\n" +
                "     aecq.series_aecq,aecq.part_spec,aecq.website_status,\n" +
                "     to_char(aecq.obsolete_timestamp,'yyyy/mm/dd') obsolete_timestamp,\n" +
                "     to_char(aecq.first_on_website_date,'yyyy/mm/dd') first_on_website_date,\n" +
                "     nvl(aecq.msl,'NA') msl,case when substr(a.ITEM_DESC1,-3)='-ON' \n" +
                "     then on_packing.reel_qty else  replace(nvl(tpi.reel_pc,tpii.reel_pc),'-','')  end reel_pc,\n" +
                "     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.box_qty else replace(nvl(tpi.innerbox_pc,tpii.innerbox_pc),'-','')  end innerbox_pc,\n" +
                "     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_qty else replace(nvl(tpi.carton_pc,tpii.carton_pc),'-','') end carton_pc,\n" +
                "     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_size else nvl(tpi.CartonSize,tpii.CartonSize) end CartonSize_mm ,\n" +
                "     case when substr(a.ITEM_DESC1,-3)='-ON' then on_packing.carton_weight else nvl(tpi.GW_KG,tpii.GW_KG) end GW_KG_CARTON ,\n" +
                "     (select to_char(max(oola.creation_date),'yyyy/mm/dd') from ont.oe_order_headers_all ooha,ont.oe_order_lines_all oola \n" +
                "     where ooha.header_id=oola.header_id \n" +
                "      and oola.inventory_item_id=a.inventory_item_id \n" +
                "        and substr(ooha.order_number ,1,4) in ('1121','1131','1141','1142','1156','1214','7141','7214','7121')) last_order_date,\n" +
                "        case when substr(a.ITEM_DESC1,-3)='-ON' \n" +
                "        then on_packing.PACKAGINGDESCRIPTION  \n" +
                "        else nvl(tpi.PACKAGINGDESCRIPTION,tpii.PACKAGINGDESCRIPTION) end PACKAGINGDESCRIPTION ,\n" +
                "        case when substr(a.ITEM_DESC1,-3)='-ON' then null else nvl(tpi.PART_NO_LIST,tpii.PART_NO_LIST) end PART_NO_LIST1 ,\n" +
                "        row_number() over(partition by a.SEGMENT1 order by decode(a.ITEM_DESC1,nvl(tpi.part_no_list,tpii.part_no_list),1,2)) item_cnt,\n" +
                "        fair.cust_partno fairchild_cpn,case when  a.attribute3 ='005' and a.tw_vendor_flag='N' then 'CHINA' else a.COO_CODE end COO,\n" +
                "        case a.TSC_PROD_GROUP when 'PRD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end \n" +
                "        when 'SSD' then case when substr(a.segment1,11,1) in ('2','H') then 'Yes' else '' end\n" +
                "        when 'PMD' then case when substr(a.segment1,11,2) ='TP' then 'Yes' else '' end\n" +
                "        else '' end AEC_Q101,tsc_packing_info_preferred(a.inventory_item_id) prefeered_packing_code_flag,\n" +
                "        (select distinct pl_category from oraddman.ts_pl_category ttpc \n" +
                "        where ttpc.TSC_PROD_GROUP=a.TSC_PROD_GROUP \n" +
                "        and NVL(ttpc.TSC_PROD_CATEGORY,a.TSC_PROD_CATEGORY)=a.TSC_PROD_CATEGORY \n" +
                "        and ttpc.TSC_FAMILY=a.TSC_FAMILY \n" +
                "        and NVL(ttpc.TSC_PROD_FAMILY,nvl(a.TSC_PROD_FAMILY,'XXX'))=nvl(a.TSC_PROD_FAMILY,'XXX')) pl_category\n" +
                "        FROM (SELECT msi.organization_id,msi.segment1,msi.description,msi.inventory_item_id,msi.attribute3,\n" +
                "        case when tsdp.TSC_ORDERING_CODE is not null then 'YES' else '' end as F400_PRODUCT,\n" +
                "               tsdp.BOTTOM_PRICE_USD_PCS,tsdp.SALES_HEAD_PRICE_USD_PCS,tsdp.RECOMMENDED_STOCK_IN_CHANNEL,\n" +
                "               tsdp.PRICE_BOOK_CODE,tsdp.DESIGN_REGISTRATION,tsdp.RECOMMENDED_REPLACEMENT,tsdp.DISTRIBUTION_BOOK_PRICE as price1,\n" +
                "               tsdp.DISTRIBUTION_MPP_PRICE as price2, tsdp.DESIGN_REGISTRATION_PRICE as price3, tsdp.spg_status,               \n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,23) TSC_PACKAGE ,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) TSC_PROD_GROUP,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,21) TSC_FAMILY,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000123) TSC_PROD_CATEGORY,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000203) TSC_prod_hierarchy_1,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000204) TSC_prod_hierarchy_2,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000205) TSC_prod_hierarchy_3,\n" +
                "               TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000206) TSC_prod_hierarchy_4,\n" +
                "                CASE WHEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000003) IN ('PMD','SSD','SSP') \n" +
                "                THEN TSC_INV_CATEGORY(msi.inventory_item_id,43,1100000004) ELSE '' END TSC_PROD_FAMILY,\n" +
                "                TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id) PACKAGE_CODE ,\n" +
                "                TSCA_GET_HTS_CODE(msi.inventory_item_id,trim(substr(cc.cccode,-11))) HTS_CODE,\n" +
                "                TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID) ITEM_DESC1,\n" +
                "                tm.ALENGNAME factory_code,pcn.pcn_list,to_char(pt.creation_date,'yyyy-mm-dd') parts_release_date,\n" +
                "                case when TSC_INV_CATEGORY(msi.inventory_item_id,49,1100000003) in ('PRD','PRD-Subcon') \n" +
                "                THEN TO_CHAR(MIN(pt.CREATION_DATE) over (partition by substr(msi.segment1,1,10)||'1'||substr(msi.segment1,12)),'yyyy-mm-dd') \n" +
                "                ELSE to_char(pt.creation_date,'yyyy-mm-dd') END new_parts_release_date,\n" +
                "                to_char(msi.creation_date,'yyyy-mm-dd') item_creation_date,\n" +
                "                case when tm.manufactory_no in ('002','008') then 'CHINA' \n" +
                "                when tm.manufactory_no in ('005','006','010','011') then 'TAIWAN' else '' end as COO_CODE,\n" +
                "                trim(substr(cc.cccode,-11)) cccode,\n" +
                "                NVL(NVL((SELECT DISTINCT 'Y' FROM po_headers_all x,po_lines_all y WHERE x.TYPE_LOOKUP_CODE='BLANKET'\n" +
                "                AND x.ORG_ID in (41)\n" +
                "                 AND NVL(x.cancel_flag,'N') = 'N' \n" +
                "                 AND NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%' \n" +
                "                 AND NVL(y.cancel_flag,'N') = 'N'\n" +
                "                 AND NVL(y.closed_code,'OPEN') <> 'CLOSED'  \n" +
                "                 AND NVL(y.closed_flag,'N') <> 'Y' \n" +
                "                 AND y.item_id =msi.inventory_item_id AND x.po_header_id=y.po_header_id\n" +
                "                 AND EXISTS (SELECT 1 FROM oraddman.tssg_vendor_tw z \n" +
                "                 WHERE z.vendor_site_id=x.VENDOR_SITE_ID \n" +
                "                 AND nvl(z.active_flag,'N')='A')),(SELECT 'Y' FROM ORADDMAN.TSSG_VENDOR_TW_PARTS X\n" +
                "                 WHERE X.PART_NAME=TSC_GET_ITEM_DESC_NOPACKING(MSI.ORGANIZATION_ID ,MSI.INVENTORY_ITEM_ID))),'N') tw_vendor_flag\n" +
                "                 ,nvl(tpcl.default_packing_code,tsc_get_item_packing_code (43, msi.inventory_item_id))  default_packing_code\n" +
                "                 ,case when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description \n" +
                "                 else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id)))) end part_id\n" +
                "                 FROM MTL_SYSTEM_ITEMS  msi,MTL_SYSTEM_ITEMS  msii,oraddman.tsprod_manufactory tm,TSC_SALES_DISTRIBUTION_PRICE tsdp,\n" +
                "                 (SELECT TSC_PART_NO,listagg(PCN_NUMBER,',') within group(order by PCN_NUMBER) pcn_list\n" +
                "                 FROM (SELECT TSC_PART_NO,PCN_NUMBER FROM oraddman.tsqra_pcn_item_detail a WHERE SOURCE_TYPE=2\n" +
                "                 GROUP BY TSC_PART_NO,PCN_NUMBER) X\n" +
                "                 group by TSC_PART_NO) pcn,(SELECT distinct y.INVENTORY_ITEM_ID,y.ORGANIZATION_ID, x.SEGMENT1,x.CREATION_DATE\n" +
                "                 FROM inv.mtl_categories_b x,inv.mtl_item_categories y\n" +
                "                 WHERE STRUCTURE_ID=50203\n" +
                "                 and x.CATEGORY_ID=y.CATEGORY_ID\n" +
                "                 and y.ORGANIZATION_ID=49\n" +
                "                 and y.CATEGORY_SET_ID=24) pt\n" +
                "                 ,(select mc.inventory_item_id ,mc.organization_id , tc.cccode from mtl_item_categories mc, mtl_categories_tl mct,tsc_cccode tc \n" +
                "                 where mc.CATEGORY_SET_ID=6\n" +
                "                 and mc.category_id = mct.category_id and mct.language = 'US'\n" +
                "                 and tc.category_id = mct.category_id and tc.language = mct.language) cc\n" +
                "                 ,(SELECT * FROM oraddman.tsc_packing_conversion_list where nvl(INACTIVE_DATE,to_date('20991231','yyyymmdd'))>TRUNC(SYSDATE)) tpcl\n" +
                "                 WHERE msi.ORGANIZATION_ID=49\n" +
                "                 AND LENGTH(msi.SEGMENT1)>=22\n" +
                "                 and msi.INVENTORY_ITEM_ID = tsdp.INVENTORY_ITEM_ID(+)\n" +
                "                 and case \n" +
                "                       when instr(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id),'QQ')>0 then msi.description \n" +
                "                       else trim(substr(msi.description,0,length(msi.description)-length(TSC_GET_ITEM_PACKING_CODE(43,msi.inventory_item_id))))\n" +
                "                     end = tsdp.part_id(+)\n" +
                "                 and msi.description = tsdp.tsc_ordering_code(+)\n" +
                "                 AND TSC_INV_Category(msi.inventory_item_id,43, 23)=tpcl.tsc_package(+)\n" +
                "                 AND tsc_get_item_packing_code (43, msi.inventory_item_id)=tpcl.packing_code(+)\n" +
                "                 AND msi.ITEM_TYPE='FG'\n" +
                "                 AND msi.INVENTORY_ITEM_STATUS_CODE <>'Inactive'\n" +
                "                 AND msii.ORGANIZATION_ID=43\n" +
                "                 AND LENGTH(msii.SEGMENT1)>=22\n" +
                "                 AND msii.ITEM_TYPE='FG'\n" +
                "                 AND msii.INVENTORY_ITEM_STATUS_CODE <>'Inactive'\n" +
                "                 AND msi.inventory_item_id=msii.inventory_item_id\n" +
                "                 AND UPPER(msi.DESCRIPTION) NOT LIKE '%DISABLE%'\n" +
                "                 AND msi.attribute3=tm.manufactory_no(+)\n" +
                "                 and msi.description=pcn.TSC_PART_NO(+)\n" +
                "                 and msi.organization_id=pt.ORGANIZATION_ID(+)\n" +
                "                 and msi.INVENTORY_ITEM_ID=pt.INVENTORY_ITEM_ID(+)\n" +
                "                 and msi.organization_id=cc.ORGANIZATION_ID(+)\n" +
                "                 and msi.INVENTORY_ITEM_ID=cc.INVENTORY_ITEM_ID(+)\n" +
                "                 AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'\n" +
                "                 AND NVL(msi.INTERNAL_ORDER_ENABLED_FLAG,'N')='Y'\n" +
                "                 and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'\n" +
                "                 and (((length(msi.segment1)=22 and substr(msi.segment1,21,1)='0') or (length(msi.segment1)=30 \n" +
                "                 and substr(msi.segment1,21,1)='0' and substr(msi.segment1,29,2)='00'))\n" +
                "                 and substr(msi.segment1,22,1) in ('0','A','B','C','D','F','G','H','I','J','K','L','N','O','P','Q','R','S','T','V','W','X','Y','Z'))\n" +
                "                 and instr(msi.description,'/')<=0) A\n" +
                "                 ,TABLE(TSC_GET_ITEM_SPQ_MOQ(a.inventory_item_id,'TS',NULL)) qq\n" +
                "                 ,TABLE(TSC_GET_ITEM_LEADTIME(a.inventory_item_id,a.attribute3,NULL)) tt\n" +
                "                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',7257,\n" +
                "                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
                "                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
                "                 ELSE 'X' END ,NULL)) pp\n" +
                "                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',9455,\n" +
                "                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'CNY',\n" +
                "                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E'\n" +
                "                 ELSE 'X' END ,NULL)) pp_cny\n" +
                "                 ,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8534,\n" +
                "                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
                "                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
                "                 ELSE 'X' END ,NULL)) pp_ssd,TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(43,a.inventory_item_id,'PCE',8508,\n" +
                "                 nvl(TO_DATE('','YYYY/MM/DD'),trunc(sysdate)),'USD',\n" +
                "                 CASE a.attribute3 WHEN '002' THEN 'Y' WHEN '005' THEN 'T' WHEN '006' THEN 'I' WHEN '008' THEN 'T' WHEN '010' THEN 'A' WHEN '011' THEN 'E' \n" +
                "                 ELSE 'X' END ,NULL)) pp_prod,table(tsc_get_aecq_info(a.inventory_item_id)) aecq\n" +
                "                 ,(select * from oraddman.tsc_packing_info_list where part_no_list is not null) tpi\n" +
                "                 ,(select * from oraddman.tsc_packing_info_list where part_no_list is null) tpii\n" +
                "                 ,oraddman.tsc_sales_bottom_price tsbp       ,oraddman.tsc_sales_bottom_price_tvs tsbpt\n" +
                "                 ,(SELECT a.ALTERNATE_ROUTING TSC_PACKAGE, a.DEM_LOCATION_ID SPQ, a.EXP_LOCATION_ID MOQ, a.CODE_DESC REEL_QTY, a.CODE_DESC2 BOX_QTY,\n" +
                "                 a.CODE_DESC3 CARTON_QTY,a.CODE_DESC4 CARTON_SIZE,a.CODE_DESC5 CARTON_WEIGHT,a.code_desc6 PACKAGINGDESCRIPTION\n" +
                "                 FROM yew_mfg_defdata a WHERE DEF_TYPE='ON') on_packing\n" +
                "                 ,(select  cust_partno, tsc_partno from oraddman.ts_label_onsemi_item where tsc_partno like '%-ON%') fair\n" +
                "                 ,(SELECT x.PCN_NUMBER,x.TSC_PART_NO,case when substr(y.segment1,21,1) not in ('0') \n" +
                "                 or substr(y.segment1,22,1) not in ('0','E','M','N','U') THEN ''\n" +
                "                  ELSE REPLACE_PART_NO END REPLACE_PART_NO\n" +
                "                  FROM (SELECT a.*,ROW_NUMBER () OVER (PARTITION BY tsc_part_no ORDER BY pcn_number) row_seq\n" +
                "                   FROM (SELECT DISTINCT pcn_number, tsc_part_no, replace_part_no FROM oraddman.tsqra_pcn_item_detail a \n" +
                "                   WHERE source_type = '2' AND replace_part_no IS NOT NULL\n" +
                "                   AND TRIM (UPPER (replace_part_no)) NOT IN ('NO CHANGE', 'NONE')) a) x,\n" +
                "                   (select a.* from (select description,segment1,row_number() \n" +
                "                    over (partition by description order by creation_date desc) row_seq from inv.mtl_system_items_b\n" +
                "                     where organization_id=43 and inventory_item_status_code<>'Inactive' ) a where row_seq=1) y\n" +
                "                     WHERE x.row_seq = 1 and x.REPLACE_PART_NO=y.description(+)) new_pn\n" +
                "                     WHERE 1=1\n" +
                "                     AND a.ITEM_DESC1=tpi.PART_NO_LIST(+)\n" +
                "                     AND a.TSC_PACKAGE=tpii.TSC_PACKAGE(+)\n" +
                "                     AND substr(upper(TRIM(a.PACKAGE_CODE)),1,2)=tpii.PackingCode(+)\n" +
                "                     AND case when UPPER(a.TSC_PROD_GROUP)='PRD-SUBCON' or upper(a.TSC_PACKAGE)='I2PAK'\n" +
                "                     THEN 'PRD' else a.TSC_PROD_GROUP END =tpii.GROUPTYPE(+)\n" +
                "                     AND a.description=tsbp.tsc_partno(+)\n" +
                "                     AND a.TSC_PACKAGE=on_packing.TSC_PACKAGE(+)\n" +
                "                     AND a.description=new_pn.TSC_PART_NO(+)\n" +
                "                     AND a.part_id=tsbpt.part_id(+)\n" +
                "                     AND a.item_desc1=fair.tsc_partno(+)\n" +
                ") SELECT \n" +
                "    SEGMENT1, PART_ID, PACKAGE_CODE, DESCRIPTION, PL_CATEGORY, TSC_PROD_GROUP, TSC_PROD_CATEGORY,TSC_FAMILY,\n" +
                "    TSC_PROD_FAMILY, TSC_PACKAGE, SPQ, MOQ, LEAD_TIME, PRICE, PRICE_LAST_UPDATE_DATE,ITEM_CREATION_DATE, \n" +
                "    BOTTOM_PRICE_USD_PCS, SALES_HEAD_PRICE_USD_PCS, RECOMMENDED_STOCK_IN_CHANNEL, PRICE_BOOK_CODE,PRICE1, PRICE2,\n" +
                "    DESIGN_REGISTRATION, PRICE3, RECOMMENDED_REPLACEMENT, FACTORY_CODE, ATTRIBUTE3, COO, COO_CODE,PART_SPEC, \n" +
                "    AEC_Q101, MSL, WEBSITE_STATUS, PACKAGINGDESCRIPTION, REEL_PC, INNERBOX_PC, CARTON_PC,CARTONSIZE_MM,\n" +
                "    GW_KG_CARTON, PCN_LIST, PRODUCT_GROUP_8,\n" +
                "    CASE \n" +
                "        WHEN PRODUCT_GROUP_8 IS NULL THEN ''\n" +
                "        WHEN PRODUCT_GROUP_8 = 'LIGHTING IC' THEN 'PMD'\n" +
                "        WHEN PRODUCT_GROUP_8 IN ('MOSFET-Subcon', 'Super Junction', 'Super Junction-Subcon') THEN 'MOSFET'\n" +
                "        WHEN PRODUCT_GROUP_8 IN ('PRD-Subcon', 'TRENCH SCHOTTKY') THEN 'PRD'\n" +
                "        ELSE PRODUCT_GROUP_8\n" +
                "    END AS PROD_GROUP_5,\n" +
                "    CCCODE, HTS_CODE, NEW_PARTS_RELEASE_DATE, TW_VENDOR_FLAG,FIRST_ON_WEBSITE_DATE, F400_PRODUCT, SPG_STATUS, \n" +
                "    TSC_PROD_HIERARCHY_1, TSC_PROD_HIERARCHY_2, TSC_PROD_HIERARCHY_3, TSC_PROD_HIERARCHY_4,FAIRCHILD_CPN, \n" +
                "    ITEM_CNT, PREFEERED_PACKING_CODE_FLAG\n" +
                "FROM S1";

        Statement statement = conn.createStatement();
        ResultSet rs = statement.executeQuery(sql);
        List<Map<String, Object>> rows = new ArrayList<>();
        ResultSetMetaData metaData = rs.getMetaData();
        int columnCount = metaData.getColumnCount();

        while (rs.next()) {
            if (rs.getString("PACKAGE_CODE") == null || rs.getString("part_spec") == null || rs.getInt("ITEM_CNT") != 1)
                continue;
            if (rs.getString("TSC_PROD_GROUP").equals("PMD") && rs.getString("SEGMENT1").length() == 30 && rs.getString("SEGMENT1").charAt(21) == 'V')
                continue;
            Map<String, Object> row = new LinkedHashMap<>(); // 使用 LinkedHashMap 保持欄位順序
            for (int i = 1; i <= columnCount; i++) {
                String columnName = metaData.getColumnLabel(i); // getColumnLabel 可拿到 SQL 別名
                Object value = rs.getObject(i);
                row.put(columnName, value);
            }
            rows.add(row);
        }
        rs.close();
        statement.close();
        conn.close();
        return rows;
    }
}
