package tscSalesPrice;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
//import javax.servlet.annotation.WebServlet; // 移除 @WebServlet

//@WebServlet("/TscSalesPriceServlet")  // 將 URL 模式移至此處 (如果使用 Servlet 3.0+)
public class TscSalesPriceServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:oracle:thin:@10.0.1.173:1528:crp1"; // 您的資料庫 URL
    private static final String DB_USER = "APPS";   // 您的資料庫使用者名稱
    private static final String DB_PASSWORD = "TSCApps12";  // 您的資料庫密碼

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver"); // 或您的資料庫驅動程式
        } catch (ClassNotFoundException e) {
            throw new ServletException("無法載入資料庫驅動程式", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Connection conn = null;
        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            // 呼叫 TscSalesPrice 的方法來產生 Excel
            TscSalesPrice tscSalesPrice = new TscSalesPrice();
            tscSalesPrice.downloadTscSalesPrice(conn, response, request.getParameter("item")); // 傳遞 item 引數
        } catch (SQLException e) {
            throw new ServletException("資料庫錯誤", e);
        } catch (Exception e) {
            throw new ServletException("產生 Excel 檔案時發生錯誤", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace(); // 記錄或處理此異常
                }
            }
        }
    }
}
