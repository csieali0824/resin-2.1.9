package commonUtil.mailUtil;

import bean.ConnUtils;
import com.mysql.jdbc.StringUtils;
import commonUtil.dateUtil.DateParseResult;
import commonUtil.dateUtil.DateUtil;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class MailTest {

    private static Connection conn;
    static {
        try {
            conn = ConnUtils.getConnectionProd();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static void main(String[] args) {
        String[] testInputs = {
//                "20250601",       // yyyyMMdd
//                "2025-06-01",     // yyyy-MM-dd
//                "06/01/2025",     // MM/dd/yyyy
                "2025/06/30",     // yyyy/MM/dd
                "2025/02/29",       // 非閏年 -> 錯誤
//                "01-01-2025"    // 格式錯誤
        };

        for (String input : testInputs) {
            if (StringUtils.isNullOrEmpty(input)) {
                System.err.println("Date is required");
            } else {
                try {
                    DateParseResult result = DateUtil.autoParseWithPattern(input);
                    System.out.println("✔ " + input + " ➜ " + result);
                } catch (IllegalArgumentException e) {
                    System.err.println("❌ " + input + " ➜ " + e.getMessage());
                }
            }
        }
    }


    public static void main2(String[] args) throws Exception {
        Message message = getMailAddress("TSCE", ActType.AUTO.name(), Region.TSCE_ALLOVERDUE.getRegion());
        System.out.println("Sss="+Arrays.deepToString(message.getAllRecipients()));
//        InternetAddress[] addresses = getMailAddress("SAMPLE");
//        for (InternetAddress address : addresses) {
//            System.out.println("✔ 收件人：" + address.toString());
//        }
    }

    public static Message getMailAddress(String region, String actType, String functionName) throws Exception {
        Properties props = System.getProperties();
        props.put("mail.transport.protocol","smtp");
        props.put("mail.smtp.host", "mail.ts.com.tw");
        props.put("mail.smtp.port", "25");

        javax.mail.Session session = Session.getInstance(props, null);
        Message message = new MimeMessage(session);
        message.setSentDate(new java.util.Date());
        message.setFrom(new InternetAddress("prodsys@ts.com.tw"));
        Map<String, Set<String>> groupedData = queryJobAndReceiverTypes(region, functionName);

        System.out.println("分組資料 groupedData = " + groupedData);

        String receiverSql = "SELECT tsc_mail_job_pkg.get_receiver(?, ?) AS email from dual";

        try (PreparedStatement receiverStmt = conn.prepareStatement(receiverSql)) {
            for (Map.Entry<String, Set<String>> entry : groupedData.entrySet()) {
                String jobId = entry.getKey();
                for (String receiverType : entry.getValue()) {
                    receiverStmt.setString(1, jobId);
                    receiverStmt.setString(2, receiverType);

                    try (ResultSet rs = receiverStmt.executeQuery()) {
                        while (rs.next()) {
                            String emailList = rs.getString("email");
                            if (emailList != null && !emailList.trim().isEmpty()) {
                                handleRecipients(message, receiverType, emailList, actType);
                            }
                        }
                    }
                }
            }
        }
        return message;
    }

    private static Map<String, Set<String>> queryJobAndReceiverTypes(String region, String functionName) throws SQLException {
        Map<String, Set<String>> groupedData = new HashMap<>();

        String sql = "SELECT JOB_ID, RECEIVER_TYPE FROM tsc_mail_receiver \n" +
                "WHERE JOB_ID IN (SELECT JOB_ID FROM TSC.TSC_MAIL_JOB \n" +
                "                  WHERE JOB_REGION = ? \n" +
                "                  AND JOB_SYSTEM IN (?, ?) \n" +
                "                  AND FUNCTION_NAME = ?) \n" +
                "AND ACTIVE = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, region);
            pstmt.setString(2, "SSIS");
            pstmt.setString(3, "RFQ");
            pstmt.setString(4, functionName);
            pstmt.setString(5, "Y");

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    String jobId = rs.getString("JOB_ID");
                    String receiverType = rs.getString("RECEIVER_TYPE");

                    groupedData.computeIfAbsent(jobId, k -> new HashSet<>()).add(receiverType);
                }
            }
        }

        return groupedData;
    }

    private static void handleRecipients(Message message, String receiverType, String emailList, String actType) throws MessagingException {
        switch (receiverType) {
            case "TO":
                System.out.println("TO: " + emailList);
                message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(emailList));
                break;
            case "CC":
                System.out.println("CC(特殊處理): " + emailList);
                addCcRecipientsWithCheck(message, emailList, actType);
                break;
            case "BCC":
                System.out.println("BCC: " + emailList);
                message.addRecipients(Message.RecipientType.BCC, InternetAddress.parse(emailList));
                break;
            default:
                System.err.println("不支援的類型：" + receiverType);
        }
    }

    private static void addCcRecipientsWithCheck(Message message, String emailList, String actType) throws MessagingException {
        List<String> removeMailList = new LinkedList<>();
        for (String email: emailList.split(",")) {
            String trimmedEmail = email.trim();
            String mailName = trimmedEmail.substring(0,trimmedEmail.indexOf("@")).toUpperCase();
            if (mailName.contains(CreatedBy.NONO.name()) && ActType.AUTO.name().equals(actType)) {
                removeMailList.add(trimmedEmail);
                message.addRecipients(Message.RecipientType.CC, InternetAddress.parse(trimmedEmail));
            }
        }
        List<String> list = new ArrayList<>(Arrays.asList(emailList.split(",")));
        list.removeAll(removeMailList); // 將已塞到message.addRecipients 的mail 移除，其餘的走原有的流程

        String result = String.join(",", list);
        message.addRecipients(Message.RecipientType.CC, InternetAddress.parse(result));
    }
}
