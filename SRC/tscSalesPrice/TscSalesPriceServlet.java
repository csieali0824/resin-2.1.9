package tscSalesPrice;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
//import javax.servlet.annotation.WebServlet; // ���� @WebServlet

//@WebServlet("/TscSalesPriceServlet")  // �N URL �Ҧ����ܦ��B (�p�G�ϥ� Servlet 3.0+)
public class TscSalesPriceServlet extends HttpServlet {

    private static final String DB_URL = "jdbc:oracle:thin:@10.0.1.173:1528:crp1"; // �z����Ʈw URL
    private static final String DB_USER = "APPS";   // �z����Ʈw�ϥΪ̦W��
    private static final String DB_PASSWORD = "TSCApps12";  // �z����Ʈw�K�X

    @Override
    public void init() throws ServletException {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver"); // �αz����Ʈw�X�ʵ{��
        } catch (ClassNotFoundException e) {
            throw new ServletException("�L�k���J��Ʈw�X�ʵ{��", e);
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
            // �I�s TscSalesPrice ����k�Ӳ��� Excel
            TscSalesPrice tscSalesPrice = new TscSalesPrice();
            tscSalesPrice.downloadTscSalesPrice(conn, response, request.getParameter("item")); // �ǻ� item �޼�
        } catch (SQLException e) {
            throw new ServletException("��Ʈw���~", e);
        } catch (Exception e) {
            throw new ServletException("���� Excel �ɮ׮ɵo�Ϳ��~", e);
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace(); // �O���γB�z�����`
                }
            }
        }
    }
}
