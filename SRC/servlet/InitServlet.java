package servlet;

import commonUtil.ConnUtil;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet(name="InitServlet", urlPatterns="/InitServlet", loadOnStartup=1)
public class InitServlet extends HttpServlet {
    public void init(ServletConfig config) throws ServletException {
        super.init(config);
        ConnUtil.init(getServletContext());
        System.out.println("DB Connection 設定已載入 (Resin 4.0.66)");
    }
}