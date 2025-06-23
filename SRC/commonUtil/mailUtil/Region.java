package commonUtil.mailUtil;

public enum Region {
    SAMPLE("SAMPLE"),
    TSCT_DISTY("TSCT-DISTY"),
    TSCT_DA("TSCT-DA"),
    TSCR_ROW("TSCR-ROW"),
    TSCK("TSCK"),
    TSCC_TSCH("TSCC-TSCH"),
    TSCC("TSCC"),
    TSCH_HK("TSCH-HK"),
    TSCJ("TSCJ"),
    TSCA("TSCA"),
    TSCE_AUTO("TSCE-AUTO"),
    TSCE_ALLOVERDUE("TSCE-ALLOVERDUE");

    private final String region;
    Region(String region) {
        this.region = region;
    }

    public String getRegion() {
        return region;
    }
}
