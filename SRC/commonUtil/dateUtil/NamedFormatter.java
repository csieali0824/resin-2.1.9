package commonUtil.dateUtil;

import java.time.format.DateTimeFormatter;
import java.time.format.ResolverStyle;

public class NamedFormatter {
    private final String pattern;
    private final DateTimeFormatter formatter;

    public NamedFormatter(String pattern) {
        this.pattern = pattern;
        this.formatter = DateTimeFormatter.ofPattern(pattern)
                .withResolverStyle(ResolverStyle.STRICT);
    }

    public String getPattern() {
        return pattern;
    }

    public DateTimeFormatter getFormatter() {
        return formatter;
    }
}
