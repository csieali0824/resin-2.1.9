package bean;

public class SpecialItem18 {
    public static String get18SpecialItemToSql() {
        String[] description = new String[]{"TSM4925DCS RLG", "TSM4953DCS RLG", "TSM4936DCS RLG", "TSM2302CX RFG",
                "TSM2305CX RFG", "TSM2306CX RFG", "TSM2307CX RFG", "TSM2308CX RFG", "TSM2312CX RFG",
                "TSM2314CX RFG", "TSM2318CX RFG", "TSM2323CX RFG", "TSM2328CX RFG", "TSM9409CS RLG", "TSM3443CX6 RFG"
                , "TSM3481CX6 RFG", "TSM3457CX6 RFG", "TSM3911DCX6 RFG"};
        return createInCondition(description);
    }
    public static String createInCondition(String[] values) {
        StringBuffer result = new StringBuffer();

        for (int i = 0; i < values.length; i++) {
            // 包裹單引號並處理 SQL 注入
            result.append("'").append(values[i]).append("'");
            if (i < values.length - 1) {
                result.append(", "); // 添加逗號分隔
            }
        }
        return result.toString();
    }
}
