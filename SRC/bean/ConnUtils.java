package bean;

import java.sql.Connection;
import java.sql.SQLException;

public class ConnUtils {
    static Connection con;

    public static Connection getConnectionProd() throws Exception {
        PoolBean poolBean = new PoolBean();
        WorkingDateBean workingDateBean = new WorkingDateBean();
        poolBean.setDriver("oracle.jdbc.driver.OracleDriver");
        poolBean.setURL("jdbc:oracle:thin:@10.0.1.34:1521:PROD");
        poolBean.setURL2("jdbc:oracle:thin:@10.0.1.34:1521:PROD");
        //oraddspoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL"));
        poolBean.setUsername("APPS");
        poolBean.setPassword("TSCApps12");
        poolBean.setSize(3);
        poolBean.initializePool();
        con=poolBean.getConnection();
        con.setAutoCommit(false);
        return con;
    }
    public static Connection getConnectionCRP1() throws Exception {
        PoolBean poolBean = new PoolBean();
        WorkingDateBean workingDateBean = new WorkingDateBean();
        poolBean.setDriver("oracle.jdbc.driver.OracleDriver");
        poolBean.setURL("jdbc:oracle:thin:@10.0.1.173:1528:crp1");
        poolBean.setURL2("jdbc:oracle:thin:@10.0.1.173:1528:crp1");
        //oraddspoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL"));
        poolBean.setUsername("APPS");
        poolBean.setPassword("TSCApps12");
        poolBean.setSize(3);
        poolBean.initializePool();
        con=poolBean.getConnection();
        con.setAutoCommit(false);
        return con;
    }

    public static Connection getConnectionCRP() throws Exception {

        PoolBean poolBean = new PoolBean();
        WorkingDateBean workingDateBean = new WorkingDateBean();
        poolBean.setDriver("oracle.jdbc.driver.OracleDriver");
        poolBean.setURL("jdbc:oracle:thin:@10.0.1.171:1527:crp");
        poolBean.setURL2("jdbc:oracle:thin:@10.0.1.171:1527:crp1");
        //oraddspoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL"));
        poolBean.setUsername("APPS");
        poolBean.setPassword("TSCApps12");
        poolBean.setSize(3);
        poolBean.initializePool();
        con=poolBean.getConnection();
        con.setAutoCommit(false);
        return con;
    }

    public void closeConnection() throws SQLException {
        con.close();
    }
}
