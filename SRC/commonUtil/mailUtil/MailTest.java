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

    public static MimeMessage message;
    private static Session session;
    private static String region;
    private static String actType;
    private static String createdBy;
    private static final Set<String> addedEmails = new HashSet<>();
    private static Connection conn;
    static {
        try {
            conn = ConnUtils.getConnectionProd();
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public static void resetMessage() throws MessagingException {
        message = new MimeMessage(session);
        message.setSentDate(new java.util.Date());
        message.setFrom(new InternetAddress("prodsys@ts.com.tw"));
        addedEmails.clear();
    }

    public static void main1(String[] args) {
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

    public static void main(String[] args) throws Exception {
        Properties props = System.getProperties();
        props.put("mail.transport.protocol","smtp");
        props.put("mail.smtp.host", "mail.ts.com.tw");
        props.put("mail.smtp.port", "25");

        session = Session.getInstance(props, null);
//        message = new MimeMessage(session);
//        message.setSentDate(new java.util.Date());
//        message.setFrom(new InternetAddress("prodsys@ts.com.tw"));

        String sql = " SELECT DISTINCT a.request_no, DECODE(substr(a.sales_group,1,4),'TSCI','TSCR-ROW','TSCC','TSCC',a.sales_group) sales_region,created_by"+
                " FROM oraddman.tsc_om_salesorderrevise_pc a"+
                " WHERE REQUEST_NO=?"+
                " AND notice_date is null"+
                " ORDER BY  1,2";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "PC250620008");
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    resetMessage();
                    String salesRegion = rs.getString("sales_region");
                    String creatBy = rs.getString("created_by");
                    region = salesRegion;
                    createdBy = "NONO";
                    actType = ActType.AUTO.name();
                    getMailInfoByRegion();
                }
            }
        }

    }

    public static void getMailInfoByRegion() throws Exception {
        switch (region) {
            case "TSCE":
                getMailAddress(Region.TSCE_AUTO.getRegion());
                if ("ALLOVERDUE".equals(actType)) {
                    getMailAddress(Region.TSCE_ALLOVERDUE.getRegion());
                }
                System.out.println(region+"="+Arrays.deepToString(message.getAllRecipients()));
                break;
            case "TSCA":
                getMailAddress(Region.TSCA.getRegion());
                break;
            case "TSCJ":
                getMailAddress(Region.TSCJ.getRegion());
                break;
            case "TSCH-HK":
                region = "TSCH";
                getMailAddress(Region.TSCH_HK.getRegion());
                break;
            case "TSCC":
                getMailAddress(Region.TSCC.getRegion());
                break;
            case "TSCC-TSCH":
                region = "TSCH";
                getMailAddress(Region.TSCC_TSCH.getRegion());
                break;
            case "TSCK":
                getMailAddress(Region.TSCK.getRegion());
                System.out.println("getFrom="+ Arrays.toString(message.getFrom()));
                System.out.println(region+"="+Arrays.deepToString(message.getAllRecipients()));
                break;
            case "TSCR-ROW":
                getMailAddress(Region.TSCR_ROW.getRegion());
                break;
            case "TSCT-DA":
                getMailAddress(Region.TSCT_DA.getRegion());
                break;
            case "TSCT-Disty":
                getMailAddress(Region.TSCT_DISTY.getRegion());
                break;
            case "SAMPLE":
                getMailAddress(Region.SAMPLE.getRegion());
                break;
        }
    }

    public static void getMailAddress(String functionName) throws Exception {
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
                                handleRecipients(receiverType, emailList, actType);
                            }
                        }
                    }
                }
            }
        }
//        return message;
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

    private static Message.RecipientType parseRecipientType(String type) {
        switch (type.toUpperCase()) {
            case "TO":
                return Message.RecipientType.TO;
            case "CC":
                return Message.RecipientType.CC;
            case "BCC":
                return Message.RecipientType.BCC;
            default:
                throw new IllegalArgumentException("Invalid recipient type: " + type);
        }
    }

    private static void handleRecipients(String receiverType, String emailList, String actType) throws MessagingException {
//        Arrays.stream(emailList.split(","))
//                .map(String::trim)
//                .filter(email -> !email.isEmpty() && addedEmails.add(email))
//                .forEach(email -> {
//                    try {
//                        Message.RecipientType type = parseRecipientType(receiverType);
//                        message.addRecipient(type, new InternetAddress(email));
//                    } catch (Exception e) {
//                        System.err.println("Failed to add email: " + email);
//                    }
//                });
//
        switch (receiverType) {
            case "TO":
                System.out.println("TO: " + emailList);
                message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(emailList));
                break;
            case "CC":
                System.out.println("CC: " + emailList);
                message.addRecipients(Message.RecipientType.CC, InternetAddress.parse(emailList));
                break;
            case "BCC":
                System.out.println("BCC: " + emailList);
                message.addRecipients(Message.RecipientType.BCC, InternetAddress.parse(emailList));
                break;
            default:
                System.err.println("不支援的類型：" + receiverType);
        }
    }
}
