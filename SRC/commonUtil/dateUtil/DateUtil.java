package commonUtil.dateUtil;

import modelN.ErrorMessage;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;

public class DateUtil {

    // 支援的格式（用來比對實際合法日期）
    private static final List<NamedFormatter> SUPPORTED_FORMATTERS = Arrays.asList(
            new NamedFormatter("uuuuMMdd"),
            new NamedFormatter("uuuu/MM/dd"),
            new NamedFormatter("uuuu-MM-dd"),
            new NamedFormatter("MM/dd/uuuu"),
            new NamedFormatter("dd/MM/uuuu"),
            new NamedFormatter("M/d/uuuu"),
            new NamedFormatter("uuuu/M/d")
    );

    // 對應格式的正規表示式（用來先排除非日期格式的字串）
    private static final List<Pattern> SUPPORTED_PATTERNS = Arrays.asList(
            Pattern.compile("^\\d{4}/\\d{2}/\\d{2}$"),   // yyyy/MM/dd
            Pattern.compile("^\\d{4}-\\d{2}-\\d{2}$"),   // yyyy-MM-dd
            Pattern.compile("^\\d{8}$"),                // yyyyMMdd
            Pattern.compile("^\\d{2}/\\d{2}/\\d{4}$"),    // MM/dd/yyyy 或 dd/MM/yyyy
            Pattern.compile("^(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[2])/\\d{4}$"),    // M/d/uuuu
            Pattern.compile("^\\d{4}/(0?[1-9]|1[0-2])/(0?[1-9]|[12][0-9]|3[10])$")  // uuuu/M/d
//            Pattern.compile("^(0?[1-9]|[12][0-9]|3[01])/(0?[1-9]|1[0-2])/\\\\d{4}$")  // d/M/uuuu
    );

    /**
     * 自動解析格式，並返回 DateParseResult（包含使用的 pattern）
     */
    public static DateParseResult autoParseWithPattern(String input) {
        boolean matchesFormat = SUPPORTED_PATTERNS.stream()
                .anyMatch(p -> p.matcher(input).matches());

        if (!matchesFormat) {
            throw new IllegalArgumentException(ErrorMessage.DATE_FORMATTER_ERROR.getMessageFormat(input));
        }

        for (NamedFormatter nf : SUPPORTED_FORMATTERS) {
            try {
                LocalDate date = LocalDate.parse(input, nf.getFormatter());
                return new DateParseResult(date, nf.getPattern());
            } catch (DateTimeParseException ignored) {}
        }

        throw new IllegalArgumentException(ErrorMessage.INVALID_DATE_ERROR.getMessageFormat(input));
    }

    /**
     * 自動解析為 LocalDate（只取結果）
     */
    public static LocalDate autoParse(String input) {
        return autoParseWithPattern(input).getDate();
    }

    public static String autoConvertFormat(String input, String targetPattern) {
        LocalDate date = autoParse(input);
        return date.format(DateTimeFormatter.ofPattern(targetPattern));
    }
}
