package commonUtil.mailUtil;

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

public class MailUtil {
    public MimeMessage message;
    private final Session session;
    private String region;
    private String actType;
    private final Connection connection;

    public MailUtil(Connection con, String region, String actType) throws Exception {
        this.connection = con;
        this.region = region;
        this.actType = actType;
        Properties props = System.getProperties();
        props.put("mail.transport.protocol","smtp");
        props.put("mail.smtp.host", "mail.ts.com.tw");
        props.put("mail.smtp.port", "25");

        this.session = Session.getInstance(props, null);
        this.message = new MimeMessage(this.session);
        this.message.setSentDate(new java.util.Date());
        this.message.setFrom(new InternetAddress("prodsys@ts.com.tw"));
        resetMessage();
        getMailInfoByRegion();
    }

    public void resetMessage() throws MessagingException {
        this.message = new MimeMessage(this.session);
        this.message.setSentDate(new java.util.Date());
        this.message.setFrom(new InternetAddress("prodsys@ts.com.tw"));
    }

    public void getMailInfoByRegion() throws Exception {
        switch (region) {
            case "TSCE":
                getMailAddress(Region.TSCE_AUTO.getRegion());
                if ("ALLOVERDUE".equals(actType)) {
                    getMailAddress(Region.TSCE_ALLOVERDUE.getRegion());
                }
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
                break;
            case "TSCR-ROW":
                getMailAddress(Region.TSCR_ROW.getRegion());
                break;
            case "TSCT-DA":
                getMailAddress(Region.TSCT_DA.getRegion());
                break;
            case "TSCT-Disty":
                region = Region.TSCT_DISTY.getRegion();
                getMailAddress(Region.TSCT_DISTY.getRegion());
                break;
            case "SAMPLE":
                getMailAddress(Region.SAMPLE.getRegion());
                break;
        }
    }

    public void getMailAddress(String functionName) throws Exception {

        Map<String, Set<String>> groupedData = queryJobAndReceiverTypes(region, functionName);
        System.out.println("分組資料 groupedData = " + groupedData);

        String receiverSql = "SELECT tsc_mail_job_pkg.get_receiver(?, ?) AS email from dual";

        try (PreparedStatement receiverStmt = this.connection.prepareStatement(receiverSql)) {
            for (Map.Entry<String, Set<String>> entry : groupedData.entrySet()) {
                String jobId = entry.getKey();
                for (String receiverType : entry.getValue()) {
                    receiverStmt.setString(1, jobId);
                    receiverStmt.setString(2, receiverType);

                    try (ResultSet rs = receiverStmt.executeQuery()) {
                        while (rs.next()) {
                            String emailList = rs.getString("email");
                            if (emailList != null && !emailList.trim().isEmpty()) {
                                try {
                                    handleRecipients(receiverType, emailList);
                                } catch (Exception e) {
                                    e.printStackTrace();
                                    System.err.println("Failed to add email: " + e.getMessage());
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    private Map<String, Set<String>> queryJobAndReceiverTypes(String region, String functionName) throws SQLException {
        Map<String, Set<String>> groupedData = new HashMap<>();

        String sql = "SELECT JOB_ID, RECEIVER_TYPE FROM tsc_mail_receiver \n" +
                "WHERE JOB_ID IN (SELECT JOB_ID FROM TSC.TSC_MAIL_JOB \n" +
                "                  WHERE JOB_REGION = ? \n" +
                "                  AND JOB_SYSTEM IN (?, ?) \n" +
                "                  AND FUNCTION_NAME = ?) \n" +
                "AND ACTIVE = ?";

        try (PreparedStatement pstmt = this.connection.prepareStatement(sql)) {
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

    private void handleRecipients(String receiverType, String emailList) throws MessagingException {
        switch (receiverType) {
            case "TO":
                System.out.println("TO: " + emailList);
                this.message.addRecipients(Message.RecipientType.TO, InternetAddress.parse(emailList));
                break;
            case "CC":
                System.out.println("CC: " + emailList);
                this.message.addRecipients(Message.RecipientType.CC, InternetAddress.parse(emailList));
                break;
            case "BCC":
                System.out.println("BCC: " + emailList);
                this.message.addRecipients(Message.RecipientType.BCC, InternetAddress.parse(emailList));
                break;
            default:
                System.err.println("不支援的類型：" + receiverType);
        }
    }
}
