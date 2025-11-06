import java.util.HashMap;
import java.util.Map;

public class ManualInsertDateCode {

    public static void main(String[] args) {
        Map<String, Integer> map = new HashMap<>();

        String[] array = new String[]{"6O","6P","6Q","6R","6S","6T",
                "6U","6V","6W","6X","6Y","6Z"};

        String[] alphabetArray = new String[]{"A","B","C","D","E","F","G","H","I","J",
                "K","L","M","N","O","P","Q","R","S","T",
                "U","V","W","X","Y","Z"};

        String[] numberArray = new String[]{"1","2","3","4","5","6","7","8","9"};

        String[][] ary2 = new String[][]{alphabetArray,numberArray};

        int i = 0;
        for (String layer1 : array) {
//            if (layer1.contains("5O")) {
//                i = 2;
//            } else if (layer1.contains("5P")) {
//                i = 7;
//            } else if (layer1.contains("5Q")) {
//                i = 11;
//            } else if (layer1.contains("5R")) {
//                i = 15;
//            } else if (layer1.contains("5S")) {
//                i = 19;
//            } else if (layer1.contains("5T")) {
//                i = 24;
//            } else if (layer1.contains("5U")) {
//                i = 28;
//            } else if (layer1.contains("5V")) {
//                i = 33;
//            } else if (layer1.contains("5W")) {
//                i = 37;
//            }else if (layer1.contains("5X")) {
//                i = 41;
//            } else if (layer1.contains("5Y")) {
//                i = 46;
//            } else if (layer1.contains("5Z")) {
//                i = 50;
//            }
            i ++;
            map.put(layer1, i);
            for (String[] layer2 : ary2) {
                for (String value : layer2) {
                    String dateCode = layer1.concat(value);
                    int dateValue = map.get(layer1);
//                    System.out.println("dateCode="+dateCode);
//                    System.out.println("dateValue="+dateValue);
                    String insertSql = "INSERT INTO TSC.TSC_DATE_CODE (YEAR, DATE_TYPE, DATE_VALUE, DATE_CODE, PROD_GROUP, VENDOR, CUSTOMER, FACTORY_CODE, GREEN_FLAG, DC_RULE, TSC_PARTNO, CREATION_DATE) \n"+
                            "VALUES (2026, 'MONTH', "+dateValue+", '"+dateCode+"', 'PMD', null, null, null, null, 'YML', null, sysdate);";
                    System.out.println(insertSql);
                }
            }
        }
    }
    public static void mainYWL(String[] args) {
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
