<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,java.io.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<!--=============Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>Title</title>
</head>
<body>
<%
 
     String webID="";    
     String sqlGlobal = "";

        org.jfree.data.jdbc.JDBCCategoryDataset dataSet=new org.jfree.data.jdbc.JDBCCategoryDataset(con);     
   
	   String sql =   " select s_packge,s_fullload_rate,s_complete_rate from tsc_factory_make_analysis ";     
       String sWhere = " ";
       
       sql = sql + sWhere;
       //out.println(sql);
       dataSet.executeQuery(sql);
  
         
  //       String filename = null;        
         org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
         org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
         org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
         renderer3D.setSeriesPaint(0,new Color(255,255,128)); 

         renderer3D.setItemLabelFont(new Font("Arial",java.awt.Font.ITALIC,10));
   //      renderer3D.setItemURLGenerator(new StandardCategoryURLGenerator("MyJFreeChart.jsp","series","section")); 
   //      renderer3D.setToolTipGenerator(new StandardCategoryToolTipGenerator());
         org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
               plot.setForegroundAlpha(1.00f);
               plot.setNoDataMessage("No Data Found");    

         //  
         org.jfree.chart.labels.StandardCategoryLabelGenerator labelGT = new org.jfree.chart.labels.StandardCategoryLabelGenerator(); 
         //org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = (org.jfree.chart.renderer.category.CategoryItemRenderer)plot.getRenderer(); 
         org.jfree.chart.plot.CategoryPlot catePlot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D); 
         org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = catePlot.getRenderer();        
         itemRenderer.setLabelGenerator(labelGT);
         itemRenderer.setItemLabelFont(new Font("SansSerif", Font.BOLD, 11));
         itemRenderer.setItemLabelPaint(new Color(0,0,150));
         itemRenderer.setSeriesItemLabelsVisible(0, true); 
		 
		 org.jfree.chart.axis.CategoryAxis domainAxis = catePlot.getDomainAxis();
		 domainAxis.setCategoryLabelPositions(org.jfree.chart.axis.CategoryLabelPositions.DOWN_45);
                
         org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("生產數據回報系統", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);
  //               chart.setBackgroundPaint(java.awt.Color.white);
                   chart.setBackgroundPaint(new Color(220,255,166));      
                   chart.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("產品總類", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,10) ) ; 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYTitle = new org.jfree.chart.title.TextTitle("滿載率", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(15,15,150), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,10,0,0,0) ) ; 
        chart.addSubtitle(subYTitle);        
		
		org.jfree.chart.title.TextTitle subYTitle2 = new org.jfree.chart.title.TextTitle("延遲完工率", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,10,0) ) ; 
        chart.addSubtitle(subYTitle2); 
 
            		
 
        //  Write the chart image to the temporary directory
 //        ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
 //        filename = ServletUtilities.saveChartAsPNG(chart, 500, 300, info, request);

        //  Write the image map to the PrintWriter
 //        ChartUtilities.writeImageMap(pw, filename, info);
 //        pw.flush();     


         
        out.clearBuffer();
        OutputStream ostream = response.getOutputStream();
        org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 700, 300);      
        ostream.close();      
  
%>

</body>
</html>
<!--=============Release Pool==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
