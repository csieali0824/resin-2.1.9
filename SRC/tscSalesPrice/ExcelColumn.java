package tscSalesPrice;

import org.apache.poi.ss.usermodel.CellStyle;

import java.util.List;
import java.util.Map;
import java.util.function.BiFunction;
import java.util.function.Function;

public class ExcelColumn {
    private final String title;
    private final int width;
    private final CellStyle defaultFormat;
    private final List<String> fieldKeys;
    private final String styleDecideFieldKey; // 新增: 判斷style的欄位
    private final Function<Map<String, Object>, String> contentSelector;
    //    private final Function<Object, String> formatter;
    private final BiFunction<Object, Map<String, CellStyle>, CellStyle> styleSelector;

    public ExcelColumn(String title, int width, CellStyle format, List<String> fieldKeys) {
        this(title, width, format, fieldKeys, null, rowData -> getFirstNonNullFromKeys(rowData, fieldKeys), null);
    }

    public ExcelColumn(String title, int width, CellStyle format, List<String> fieldKeys, Function<Object, String> formatter) {
        this(title, width, format, fieldKeys, null, rowData -> {
            Object val = getFirstNonNullRaw(rowData, fieldKeys);
            return formatter != null ? formatter.apply(val) : (val == null ? "" : val.toString());
        }, null);
    }

    // 新增：支援依資料內容動態決定 style
    public ExcelColumn(String title,
                       int width,
                       CellStyle defaultFormat,
                       List<String> fieldKeys,
                       String styleDecideFieldKey,
                       Function<Map<String, Object>, String> contentSelector,
                       BiFunction<Object, Map<String, CellStyle>, CellStyle> styleSelector) {
        this.title = title;
        this.width = width;
        this.defaultFormat = defaultFormat;
        this.fieldKeys = fieldKeys;
        this.styleDecideFieldKey = styleDecideFieldKey;
        this.contentSelector = contentSelector;
//        this.formatter = formatter;
        this.styleSelector = styleSelector;
    }

    public String getTitle() {
        return title;
    }

    public int getWidth() {
        return width;
    }

    public CellStyle getDefaultFormat() {
        return defaultFormat;
    }

    public List<String> getFieldKeys() {
        return fieldKeys;
    }

    public String getStyleDecideFieldKey() {
        return styleDecideFieldKey;
    }

    public String selectContent(Map<String, Object> rowData) {
        return contentSelector != null ? contentSelector.apply(rowData) : "";
    }
//    public String selectContent(Map<String, Object> rowData) {
//        if (contentSelector != null) {
//            return contentSelector.apply(rowData);
//        } else {
//            return getFirstNonNullValue(rowData);
//        }
//    }

//    public String formatValue(Object value) {
//        return formatter != null ? formatter.apply(value) : (value == null ? "" : value.toString());
//    }

    public CellStyle decideFormat(Map<String, Object> rowData, Map<String, CellStyle> styles) {
        Object decideValue = (styleDecideFieldKey != null) ? rowData.get(styleDecideFieldKey) : null;
        if (styleSelector != null) {
            return styleSelector.apply(decideValue, styles);
        }
        return defaultFormat;
    }

//    public String getFirstNonNullValue(Map<String, Object> rowData) {
//        if (fieldKeys != null) {
//            for (String key : fieldKeys) {
//                Object value = rowData.get(key);
//                if (value != null && !"".equals(value.toString().trim())) {
//                    return formatter != null ? formatter.apply(value) : value.toString();
//                }
//            }
//        }
//        return "";
//    }

    // 讀第一個不為空的值
    private static String getFirstNonNullFromKeys(Map<String, Object> rowData, List<String> keys) {
        for (String key : keys) {
            Object value = rowData.get(key);
            if (value != null && !"".equals(value.toString().trim())) {
                return value.toString();
            }
        }
        return "";
    }

    private static Object getFirstNonNullRaw(Map<String, Object> rowData, List<String> keys) {
        for (String key : keys) {
            Object value = rowData.get(key);
            if (value != null && !"".equals(value.toString().trim())) {
                return value;
            }
        }
        return null;
    }
}
