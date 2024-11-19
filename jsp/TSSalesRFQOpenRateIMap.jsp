<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,java.io.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
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
     String modelNo = request.getParameter("MODELNO");  
     String comp=request.getParameter("COMP"); 
     String region=request.getParameter("REGION"); 
     String country=request.getParameter("COUNTRY");                                
     String locale=request.getParameter("LOCALE");                
     String smode=request.getParameter("SMODE"); 
     String repLvl=request.getParameter("REPLVL");                 

     String webID="";    
     String sqlGlobal = "";
     
     if (comp==null || comp.equals("")) comp = "01";
     if (region==null || region.equals("")) region = "ASIA";
     if (country==null || country.equals("")) country = "886";
     if (smode==null || smode.equals("")) smode = "WK"; 
     if (repLvl==null || repLvl.equals("")) repLvl = "--"; 
     if (modelNo==null || modelNo.equals("")) modelNo = "2052C";  
	 
	workingDateBean.setAdjWeek(-1); // --
 
     String thisYear = workingDateBean.getYearString();  
     String thisMonth = workingDateBean.getMonthString();
     String thisWeek = workingDateBean.getWeekString();
            workingDateBean.setDefineWeekFirstDay(1);  // --    
            String weekBelongYear = workingDateBean.getLastDateOfWorkingWeek().substring(0,4);  // -- 
	String strFirstDWeekP12 = workingDateBean.getFirstDateOfWorkingWeek();   // --
	String strLastDWeekP12 = workingDateBean.getLastDateOfWorkingWeek();  // --
	
	 workingDateBean.setAdjWeek(1);  // --	
    
/*				     
     Statement stmntCNT=con.createStatement();
     ResultSet rsCNT=stmntCNT.executeQuery(sqlCNT);
     if (rsCNT.next() && rsCNT.getInt(1)>0)
     {   
             thisWeek = workingDateBean.getWeekString();    
     } else {  
               workingDateBean.setAdjWeek(-1);        
               thisWeek = workingDateBean.getWeekString(); 
               workingDateBean.setAdjWeek(1);    
            }                
     rsCNT.close();
     stmntCNT.close();
*/
        org.jfree.data.jdbc.JDBCCategoryDataset dataSet=new org.jfree.data.jdbc.JDBCCategoryDataset(con);     
   
        // 20091208 Marvie Update : Performance Issue
        //String sql = "select /*+ ORDERED index(d IDX_TSDELIVERY_DETAIL_01)  */ "+
		//                 "b.ALCHNAME, t.cntopen, count(d.DNDOCNO) "+
	    //            "from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+
		//			    " ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f, "+
		//				" ( SELECT count(d.DNDOCNO) as cntopen, substr(d.DNDOCNO,3,3) as areano "+
		//				   "  FROM oraddman.tssales_area b, "+
		//				   "  oraddman.tsdelivery_notice c, oraddman.tsdelivery_notice_detail d, "+
		//				   "  oraddman.tsprod_manufactory e, "+
		//				    " (SELECT   d1.dndocno, SUM (DECODE (d1.sdrq_exceed, 'Y', 1, 0) ) AS sdrqcount "+
		//					"    FROM oraddman.tsdelivery_notice_detail d1 "+
		//					  "GROUP BY d1.dndocno) f "+
		//		  	      " WHERE c.dndocno = d.dndocno "+
		//				     "AND d.assign_manufact = e.manufactory_no(+) AND b.sales_area_no = c.tsareano "+
		//					 "AND SUBSTR (c.creation_date, 0, 8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"'  "+
		//					 "AND f.dndocno = d.dndocno "+
		//					 "GROUP BY substr(d.DNDOCNO,3,3) ORDER BY substr(d.DNDOCNO,3,3) "+
		//				  ") t "+
        //           "where t.areano = b.SALES_AREA_NO and d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
		//			 " and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
		//			 " and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO "+
		//			  "and d.LSTATUSID = '010' and f.actionid = '008' "+  
		//			  "and substr(d.CREATION_DATE,0,8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"'   "+
        //            " group by b.ALCHNAME, t.cntopen "+                    
        //             "order by b.ALCHNAME ";         
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
                
         org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("��"+thisWeek+"�g �~��RFQ�}��[�ͦ�MO��έp", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);
  //               chart.setBackgroundPaint(java.awt.Color.white);
                   chart.setBackgroundPaint(new Color(220,255,166));      
                   chart.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("�~�Ȧa��", new Font("�з���",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,10) ) ; 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYTitle = new org.jfree.chart.title.TextTitle("RFQ�}���", new Font("�з���",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(15,15,150), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,10,0,0,0) ) ; 
        chart.addSubtitle(subYTitle);        
		
		org.jfree.chart.title.TextTitle subYTitle2 = new org.jfree.chart.title.TextTitle("MO��ͦ���", new Font("�з���",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,10,0) ) ; 
        chart.addSubtitle(subYTitle2); 

        //  Write the chart image to the temporary directory
 //        ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
 //        filename = ServletUtilities.saveChartAsPNG(chart, 500, 300, info, request);

        //  Write the image map to the PrintWriter
 //        ChartUtilities.writeImageMap(pw, filename, info);
 //        pw.flush();     


         
        out.clearBuffer();
        BufferedImage chartImage = chart.createBufferedImage(480, 300);
        OutputStream ostream = response.getOutputStream();
        ImageIO.write(chartImage, "jpeg", ostream);
        ostream.close();      
  
%>

</body>
</html>
<!--=============Release Pool==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
