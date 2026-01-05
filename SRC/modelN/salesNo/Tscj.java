package modelN.salesNo;

import com.mysql.jdbc.StringUtils;

import java.util.Arrays;

public class Tscj extends Tsck {
    public void byCustNoSetOrderType() {
        if (StringUtils.isNullOrEmpty(modelNDto.getOrderType().trim())) {
            if (Arrays.asList(new String[]{"14053", "15202", "16988"}).contains(modelNDto.getCustNo())) {
                modelNDto.setOrderType("1131");
            }
        }
    }
}
