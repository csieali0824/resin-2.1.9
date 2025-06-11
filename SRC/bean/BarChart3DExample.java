package bean;

import org.jfree.chart.plot.CategoryPlot;

import java.sql.Connection;
import java.util.Arrays;

public class BarChart3DExample {
//    public static void main(String[] args) {
//        import org.jfree.chart.ChartFactory;
//import org.jfree.chart.ChartRenderingInfo;
//import org.jfree.chart.JFreeChart;
//import org.jfree.chart.plot.CategoryPlot;
//import org.jfree.chart.plot.PlotOrientation;
//import org.jfree.chart.title.TextTitle;
//import org.jfree.chart.ui.HorizontalAlignment;
//import org.jfree.chart.ui.RectangleEdge;
//import org.jfree.chart.ui.VerticalAlignment;
//import org.jfree.data.category.DefaultCategoryDataset;
//import org.jfree.chart.ChartUtils;
//
//import javax.imageio.ImageIO;
//import java.awt.*;
//import java.awt.image.BufferedImage;
//import java.io.File;
//import java.io.IOException;
//import javax.servlet.http.HttpSession;
//import java.io.PrintWriter;
//
//        public class ChartExample {
//
//            public static void main(String[] args) {
//                // 創建示例數據集和圖表
//                DefaultCategoryDataset dataset = new DefaultCategoryDataset();
//                dataset.addValue(5, "Category1", "Series1");
//                dataset.addValue(3, "Category1", "Series2");
//
//                CategoryPlot plot = ChartFactory.createBarChart("Title", "Category", "Value", dataset, PlotOrientation.VERTICAL, false, true, false).getPlot();
//                JFreeChart chart = new JFreeChart("The "+thisWeek+"Th Sales RFQ Generate MO Stat.", JFreeChart.DEFAULT_TITLE_FONT, plot, false);
//
//                // 設置圖表屬性
//                chart.setBackgroundPaint(new Color(255, 255, 166));
//                chart.setBorderVisible(true);
//
//                // 添加子標題
//                TextTitle subXTitle = new TextTitle("Sales Area", new Font("Arial", Font.BOLD, 14), new Color(255, 0, 0), RectangleEdge.BOTTOM, HorizontalAlignment.CENTER, VerticalAlignment.CENTER);
//                chart.addSubtitle(subXTitle);
//
//                TextTitle subYTitle = new TextTitle("RFQ Created", new Font("Arial", Font.BOLD, 14), new Color(255, 255, 0), RectangleEdge.LEFT, HorizontalAlignment.CENTER, VerticalAlignment.CENTER);
//                chart.addSubtitle(subYTitle);
//
//                TextTitle subYTitle2 = new TextTitle("MO Generated", new Font("Arial", Font.BOLD, 14), new Color(255, 0, 0), RectangleEdge.RIGHT, HorizontalAlignment.CENTER, VerticalAlignment.CENTER);
//                chart.addSubtitle(subYTitle2);
//
//                // 渲染圖表為 BufferedImage
//                BufferedImage chartImage = chart.createBufferedImage(480, 300);
//
//                // 保存 JPEG 文件
//                try {
//                    File outputfile = new File("chart.jpg");
//                    ImageIO.write(chartImage, "jpg", outputfile);
//                    System.out.println("JPEG image saved successfully.");
//                } catch (IOException e) {
//                    System.err.println("Error saving JPEG image: " + e.getMessage());
//                }
//
//                // 使用 ChartRenderingInfo 生成映射資訊（例如圖表映射用於 HTML）
//                ChartRenderingInfo info = new ChartRenderingInfo();
//
//                // 將映射信息寫入 PrintWriter (例如在網頁中使用)
//                PrintWriter pw = new PrintWriter(System.out);
//                ChartUtils.writeImageMap(pw, "chartMap", info, false);
//                pw.flush();
//            }
//        }
//
//    }

    public static void main(String[] args) {
        String customerId = "By Customer ID產生RFQ";
        String customerPo = "By Customer Po產生RFQ";
        String[] array = new String[]{customerId, customerPo};
        System.out.println("xxx="+ Arrays.asList(array).contains("By Customer ID產生RFQ"));
//        for (String s : array) {
//            System.out.println("xxx=" + s);
//        }

    }
    public static void main1(String[] args) throws Exception {
        Connection con;
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

//        poolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
        poolBean.setBeanID("oraddspoolBean");
        poolBean.setUsingURL("127.0.0.1");
        con=poolBean.getConnection();
        con.setAutoCommit(false);//Setting AutoCommit for false to permmit Network connection Error

        String strFirstDWeekP12 = workingDateBean.getFirstDateOfWorkingWeek();   //
        String strLastDWeekP12 = workingDateBean.getLastDateOfWorkingWeek();
        System.out.println("strFirstDWeekP12="+strFirstDWeekP12);
        System.out.println("strLastDWeekP12="+strLastDWeekP12);
        org.jfree.data.jdbc.JDBCCategoryDataset dataSet=new org.jfree.data.jdbc.JDBCCategoryDataset(con);
        String sql = "select B.alchname, sum(cntopen), sum(cntgen) "+
                "  from oraddman.tssales_area B, "+
                "       (select c.tsareano, count(c.dndocno) cntopen, 0 cntgen "+
                "          from oraddman.tsdelivery_notice c, oraddman.tsdelivery_notice_detail d "+
                "         where c.creation_date BETWEEN '"+strFirstDWeekP12+"'  AND '"+strLastDWeekP12+"235959' "+
                "           and c.dndocno = d.dndocno "+
                "         group by c.tsareano "+
                "        union all "+
                "        select c.tsareano, 0, count(c.dndocno) "+
                "          from oraddman.tsdelivery_notice c, oraddman.tsdelivery_notice_detail d, "+
                "               oraddman.tsdelivery_detail_history f "+
                "         where c.creation_date BETWEEN '"+strFirstDWeekP12+"'  AND '"+strLastDWeekP12+"235959' "+
                "           and c.dndocno = d.dndocno "+
                "           and d.dndocno = f.dndocno "+
                "           and d.line_no = f.line_no "+
                "           and d.lstatusid = '010' "+
                "           and f.actionid = '008' "+
                "         group by c.tsareano  ) t "+
                " where t.tsareano = B.sales_area_no "+
                " group by B.alchname "+
                " order by B.alchname ";

        dataSet.executeQuery(sql);
        System.out.println("Data="+ dataSet.getColumnKeys());
        org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
        org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");
        org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
        renderer3D.setItemURLGenerator(new org.jfree.chart.urls.StandardCategoryURLGenerator("jsp/TSSalesRFQOpenRateIMap.jsp","SALESAREA","COUNT"));
        renderer3D.setToolTipGenerator(new org.jfree.chart.labels.StandardCategoryToolTipGenerator());
        org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
        plot.setNoDataMessage("No Data Found");

    }
}
