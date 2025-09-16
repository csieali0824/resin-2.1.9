package commonUtil.uriUtil;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.StringJoiner;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class UriBuilderUtil {

    public static String encodeUtf8(String input) {
        try {
            return URLEncoder.encode(input, "UTF-8");
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("UTF-8 encoding not supported", e);
        }
    }

    /**
     * Build URL with encoded query parameters.
     * @param baseUrl e.g. "https://example.com/api"
     * @param params Map of query params
     * @return full encoded URL with query string
     */
    public static String buildUrlWithParams(String baseUrl, Map<String, String> params) {
        if (params == null || params.isEmpty()) {
            return baseUrl;
        }

        StringJoiner joiner = new StringJoiner("&");
        for (Map.Entry<String, String> entry : params.entrySet()) {
            joiner.add(encodeUtf8(entry.getKey()) + "=" + encodeUtf8(entry.getValue()));
        }
        return baseUrl + "?" + joiner;
    }

    // Example usage
    public static void main(String[] args) {
        String[] arrayA = {"CUSTOMERID","SPQCHECKED","SALESAREANO","SALESPERSON","TOPERSONID","CUSTOMERPO","CURR","PREORDERTYPE","CUSTOMERIDTMP","INSERT","RFQTYPE","PROGRAMNAME"};
        String[] arrayB =   {"5274","Y","018","REGINA","100054807","P102-2409000068","USD","1322","5274","Y","NORMAL","TSCH"};
        Map<String, String> result =
                IntStream.range(0, Math.min(arrayA.length, arrayB.length))
                        .boxed()
                        .collect(Collectors.toMap(i -> arrayA[i], i -> arrayB[i], (a, b) -> b, LinkedHashMap::new));

        String fullUrl = buildUrlWithParams("TSSalesDRQ_Create.jsp", result);
        System.out.println("Generated URL: " + fullUrl);
    }
}
