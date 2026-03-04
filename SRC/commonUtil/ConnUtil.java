package commonUtil;

import javax.servlet.ServletContext;
import java.sql.Connection;
import java.sql.DriverManager;

public class ConnUtil {
    private static String dbUrl;
    private static String dbUser;
    private static String dbPassword;
    private static String dbDriver;
    static Connection con;

    public static void init(ServletContext context) {
        dbUrl = context.getInitParameter("ORADDS_JDBC_URL");
        dbUser = context.getInitParameter("db.username");
        dbPassword = context.getInitParameter("db.password");
        dbDriver = context.getInitParameter("db.driver");

        try {
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("DB Driver 載入失敗: " + dbDriver, e);
        }
    }

    public static Connection getConnection() throws Exception {
        con= DriverManager.getConnection(dbUrl, dbUser, dbPassword);
        con.setAutoCommit(false);
        return con;
    }
}