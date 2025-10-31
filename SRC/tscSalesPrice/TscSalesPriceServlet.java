package tscSalesPrice;

import commonUtil.ConnUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
public class TscSalesPriceServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Connection conn = null;
        try {
            conn = ConnUtil.getConnection();

            // 呼叫 Excel 產生邏輯
            TscSalesPrice tscSalesPrice = new TscSalesPrice();
            tscSalesPrice.downloadTscSalesPrice(
                    conn,
                    response,
                    request.getParameter("item"),
                    request.getParameter("itemStatus")
            );

        } catch (Exception e) {
            e.printStackTrace();

            // 🟡 重設 response (清掉 Excel Header)
            response.reset();
            response.setContentType("application/json; charset=UTF-8");

            // 🟢 改用 OutputStream 送 JSON 錯誤訊息
            OutputStream out = response.getOutputStream();
            String msg = e.getMessage();
            if (msg == null) msg = "未知錯誤";

            // escape 雙引號與換行，避免 JSON.parse 出錯
            msg = msg.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "")
                    .replace("\n", "\\n");

            String json = "{\"status\":\"error\",\"msg\":\"" + msg + "\"}";
            out.write(json.getBytes("UTF-8"));
            out.flush();
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception ignore) {}
        }
    }
}
