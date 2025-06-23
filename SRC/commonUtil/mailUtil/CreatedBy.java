package commonUtil.mailUtil;

public enum CreatedBy {
    NONO,
    MARS;

    public static CreatedBy fromString(String value) {
        for (CreatedBy cb : values()) {
            if (value.contains(cb.name())) {
                return cb;
            }
        }
        return null;
    }
}
