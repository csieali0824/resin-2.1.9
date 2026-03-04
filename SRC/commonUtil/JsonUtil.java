package commonUtil;

import com.google.gson.Gson;

import java.util.Arrays;
import java.util.List;

public class JsonUtil {

    private static final Gson gson = new Gson();

    /**
     * 將 JSON Array 字串轉成 String[]
     */
    public static String[] jsonToArray(String jsonString) {
        return gson.fromJson(jsonString, String[].class);
    }

    /**
     * 將 JSON Array 字串轉成 List<String>
     */
    public static List<String> jsonToList(String jsonString) {
        return Arrays.asList(jsonToArray(jsonString));
    }

    // 測試
    public static void main(String[] args) {
        String jsonString = "[\"68\", \"99\", \"100\"]";

        // 轉成 String[]
        String[] arr = JsonUtil.jsonToArray(jsonString);
        System.out.println("Array: " + Arrays.toString(arr));

        // 轉成 List<String>
        List<String> list = JsonUtil.jsonToList(jsonString);
        System.out.println("List: " + list);
    }
}
