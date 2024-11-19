<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import = "java.io.PrintWriter" %>

<!--=============Pool=========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<!--jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/-->
<!--=================================-->

<html>
<head>
<title>Sales Area RFQ Complete MO Chart</title>
</head>
<body>

<%


       org.jfree.data.jdbc.JDBCCategoryDataset dataSet=new org.jfree.data.jdbc.JDBCCategoryDataset(con);
 
	   String sql1 =   " select s_packge,s_fullload_rate,s_complete_rate from tsc_factory_make_analysis ";                   

       String sWhere = " ";       
       sql1 = sql1 + sWhere;
       //out.println(sql); 
       dataSet.executeQuery(sql1);

  

      String filename = null;   
      java.io.PrintWriter pw = new PrintWriter(out);    
 
      org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
      org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
      org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
      renderer3D.setItemURLGenerator(new org.jfree.chart.urls.StandardCategoryURLGenerator("../jsp/TSWipMakeAnalysisRateIMap.jsp","SUMING","TEST")); 
      renderer3D.setToolTipGenerator(new org.jfree.chart.labels.StandardCategoryToolTipGenerator());
      org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
      plot.setNoDataMessage("No Data Found");    

         //-
         org.jfree.chart.labels.StandardCategoryLabelGenerator labelGT = new org.jfree.chart.labels.StandardCategoryLabelGenerator(); 
         //org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = (org.jfree.chart.renderer.category.CategoryItemRenderer)plot.getRenderer(); 
         org.jfree.chart.plot.CategoryPlot catePlot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D); 
         org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = catePlot.getRenderer();        
         itemRenderer.setLabelGenerator(labelGT);
         itemRenderer.setItemLabelFont(new Font("SansSerif", Font.BOLD, 11));
         itemRenderer.setItemLabelPaint(new Color(0,0,150));
         itemRenderer.setSeriesItemLabelsVisible(0, true); 
		 
		 // -
		 //org.jfree.chart.plot.CombinedDomainCategoryPlot combCatePlot = new org.jfree.chart.plot.CombinedDomainCategoryPlot(categoryAxis3D);
		 

		 
		 org.jfree.chart.axis.CategoryAxis domainAxis = catePlot.getDomainAxis();
		 domainAxis.setCategoryLabelPositions(org.jfree.chart.axis.CategoryLabelPositions.DOWN_45);
                 
        org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("The first Th Sales RFQ Generate MO Stat.", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);

        chart.setBackgroundPaint(new Color(255,255,166));      
        chart.setBorderVisible(true);  
        
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("產品總類", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,10) ) ; 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYTitle = new org.jfree.chart.title.TextTitle("滿載率", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,255,0), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,10,0,0,0) ) ; 
        chart.addSubtitle(subYTitle);   
		
		org.jfree.chart.title.TextTitle subYTitle2 = new org.jfree.chart.title.TextTitle("延遲完工率", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,10,0) ) ; 
        chart.addSubtitle(subYTitle2);       
        
        //  Write the chart image to the temporary directory
        ChartRenderingInfo info = new ChartRenderingInfo(new org.jfree.chart.entity.StandardEntityCollection());
        filename = org.jfree.chart.servlet.ServletUtilities.saveChartAsJPEG(chart, 480, 300, info, session);

        //  Write the image map to the PrintWriter
        ChartUtilities.writeImageMap(pw, filename, info);
        pw.flush();     
  
%>
<table ></table>
<img border="0" src="../jsp/TSWipMakeAnalysisRateIMap.jsp" useMap="#<%=filename%>">
</body>
</html>
<!--=============Release==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->