import java.util.HashMap;
import java.util.Map;

public class ManualInsertDateCode {
    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();

        String[] array = new String[]{"5A","5B","5C","5D","5E","5F","5G","5H","5I","5J",
                "5K","5L","5M","5N","5O","5P","5Q","5R","5S","5T",
                "5U","5V","5W","5X","5Y","5Z"};

//        String[] alphabetArray = new String[]{"A","B","C","D","E","F","G","H","I","J",
//                "K","L","M","N","O","P","Q","R","S","T",
//                "U","V","W","X","Y","Z"};

        String[] numberArray = new String[]{"1","2","3","4","5","6","7","8","9"};

        String[][] ary2 = new String[][]{numberArray};
//        String[][] ary2 = new String[][]{alphabetArray,numberArray};

        int i = -1;
        for (String layer1 : array) {
            i += 2;
            map.put(layer1, i);
            for (String[] layer2 : ary2) {
                for (String value : layer2) {
                    String dateCode = layer1.concat(value);
                    int dateValue = map.get(layer1);
                    String insertSql = "INSERT INTO TSC.TSC_DATE_CODE (YEAR, DATE_TYPE, DATE_VALUE, DATE_CODE, PROD_GROUP, VENDOR, CUSTOMER, FACTORY_CODE, GREEN_FLAG, DC_RULE, TSC_PARTNO, CREATION_DATE) \n"+
                            "VALUES (2025, 'WEEK', "+dateValue+", '"+dateCode+"', 'SSD', null, null, null, null, 'YWL', null, sysdate);";
                    System.out.println(insertSql);
                }
            }
        }
    }
}
