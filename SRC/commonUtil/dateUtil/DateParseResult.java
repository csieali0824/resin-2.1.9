package commonUtil.dateUtil;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

public class DateParseResult {
    private final LocalDate date;
    private final String pattern;

    public DateParseResult(LocalDate date, String pattern) {
        this.date = date;
        this.pattern = pattern;
    }

    public LocalDate getDate() {
        return date;
    }

    public String getPattern() {
        return pattern;
    }

    public String formattedDate() {
        return date.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
    }

    public String replacePattern() {
        switch (pattern) {
            case "uuuuMMdd":
                return "YYYYMMDD";
            case "uuuu/MM/dd":
            case "MM/dd/uuuu":
            case "dd/MM/uuuu":
                return "YYYY/MM/DD";
            case "uuuu-MM-dd":
                return "YYYY-MM-DD";
            default :
                throw new IllegalArgumentException("日期格式未設定");
        }
    }

    /**
     * 預設格式是 ISO 標準格式 → yyyy-MM-dd
     */
    @Override
    public String toString() {
        return "Parsed date: " + date + ", Pattern used: " + pattern;
    }
}

