package commonUtil.mailUtil;

public enum ActType {
    AUTO,
    REMINDER,
    ALLOVERDUE;

    public static ActType fromString(String value) {
        for (ActType at : values()) {
            if (at.name().equalsIgnoreCase(value)) {
                return at;
            }
        }
        throw new IllegalArgumentException("無效的動作類型: " + value);
    }
}
