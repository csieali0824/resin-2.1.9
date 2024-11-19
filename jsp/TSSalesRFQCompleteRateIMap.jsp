<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>無標題文件</title>
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
	 
	workingDateBean.setAdjWeek(-4); // 4週前
 
     String thisYear = workingDateBean.getYearString();  
     String thisMonth = workingDateBean.getMonthString();
     String thisWeek = workingDateBean.getWeekString();
            workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日     
            String weekBelongYear = workingDateBean.getLastDateOfWorkingWeek().substring(0,4);  // 取週所屬年份 
	String strFirstDWeekP12 = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
	String strLastDWeekP12 = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天
	
	 workingDateBean.setAdjWeek(4);  // 4週前	
    /*
     String sqlCNT = "select count(DISTINCT a.PMODEL) from PISRATERANK a, PISSHIPCNT b, RPMODEL_ITEM_T c "+
                     "where a.BUSINESSUNIT=b.BUSINESSUNIT and a.REGION = b.REGION and a.COUNTRY =b.COUNTRY "+
                     "and a.PYEAR = b.PYEAR  and a.PMODEL = b.PMODEL and b.PMODEL = c.MODEL and a.PCLASS=b.PCLASS "+
                     "and a.BUSINESSUNIT='"+comp+"' and a.REGION = '"+region+"' and a.COUNTRY = '"+country+"' "+
                     "and a.PCLASS = '"+smode+"' and a.REPLVL ='"+repLvl+"' and a.PYEAR ='"+thisYear+"' and LPAD(a.PWEEK,2,'0') = '"+thisWeek+"' and a.PRATE>0 and b.PCOUNT>0 "+
                     "and c.MFLAG = '1' "+    // 只顯示 PISDISPLAY FLAG = '1' 的機種                  
                     "order by PRATE DESC"; 
   */
     String sqlCNT = "SELECT count(d.DNDOCNO), substr(d.DNDOCNO,3,3) "+
	                   "  FROM oraddman.tssales_area b, oraddman.tsdelivery_notice c, "+
					   "       oraddman.tsdelivery_notice_detail d, oraddman.tsprod_manufactory e, "+
					   "(SELECT   d1.dndocno, SUM (DECODE (d1.sdrq_exceed, 'Y', 1, 0) ) AS sdrqcount "+
                          "FROM oraddman.tsdelivery_notice_detail d1 "+
                          " GROUP BY d1.dndocno) f "+
                      "WHERE c.dndocno = d.dndocno AND d.assign_manufact = e.manufactory_no(+) "+
					    "AND b.sales_area_no = c.tsareano "+
					    "AND substr(creation_date,0,8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"' "+
						"AND f.dndocno = d.dndocno AND c.dndocno IS NOT NULL"+
				   "GROUP BY substr(d.DNDOCNO,3,3) "+
                   "ORDER BY substr(d.DNDOCNO,3,3) ";  
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
     
   /*   
       String sql = "select DISTINCT a.PMODEL,(a.PRATE) as PRATE from PISRATERANK a, PISSHIPCNT b, RPMODEL_ITEM_T c "+
                    "where a.BUSINESSUNIT=b.BUSINESSUNIT and a.REGION = b.REGION and a.COUNTRY =b.COUNTRY "+
                    "and a.PYEAR = b.PYEAR  and a.PMODEL = b.PMODEL and b.PMODEL = c.MODEL and a.PCLASS=b.PCLASS "+
                    "and a.BUSINESSUNIT='"+comp+"' and a.REGION = '"+region+"' and a.COUNTRY = '"+country+"' "+
                    "and a.PCLASS = '"+smode+"' and a.REPLVL ='"+repLvl+"' and a.PYEAR ='"+weekBelongYear+"' and LPAD(a.PWEEK,2,'0') = '"+thisWeek+"' and a.PRATE>0 and b.PCOUNT>0 "+
                    "and c.MFLAG = '1' "+    // 只顯示 PISDISPLAY FLAG = '1' 的機種
                   // "and a.PMODEL in('2039C','2042','2047','2047C','2052C','2054U','2055','2056M','2058','2068C','2072') "+
                    "order by PRATE DESC";
   */
       String sql = "select b.ALCHNAME, round((count(d.DNDOCNO)),2) as RATE "+
	                "from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+
					    " ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f, "+
						" ( SELECT count(d.DNDOCNO) as cntopen, substr(d.DNDOCNO,3,3) as areano "+
						   "  FROM oraddman.tssales_area b, "+
						   "  oraddman.tsdelivery_notice c, oraddman.tsdelivery_notice_detail d, "+
						   "  oraddman.tsprod_manufactory e, "+
						    " (SELECT   d1.dndocno, SUM (DECODE (d1.sdrq_exceed, 'Y', 1, 0) ) AS sdrqcount "+
							"    FROM oraddman.tsdelivery_notice_detail d1 "+
							  "GROUP BY d1.dndocno) f "+
				  	      " WHERE c.dndocno = d.dndocno "+
						     "AND d.assign_manufact = e.manufactory_no(+) AND b.sales_area_no = c.tsareano "+
							 "AND SUBSTR (c.creation_date, 0, 8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"'  "+
							 "AND f.dndocno = d.dndocno "+
							 "GROUP BY substr(d.DNDOCNO,3,3) ORDER BY substr(d.DNDOCNO,3,3) "+
						  ") t "+
                    "where t.areano = b.SALES_AREA_NO and d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
					 " and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
					 " and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO "+
					  "and d.LSTATUSID = '010' and f.actionid = '008' "+ // 只看結案的單據
					  "and substr(d.CREATION_DATE,0,8) between '"+strFirstDWeekP12+"' and '"+strLastDWeekP12+"'   "+
                    " group by b.ALCHNAME "+                    
                     "order by b.ALCHNAME ";    // 只顯示    
       String sWhere = " ";
       out.println(sql);
       sql = sql + sWhere;
   
       dataSet.executeQuery(sql);
/*
      JFreeChart chart=null;
      chart = org.jfree.chart.ChartFactory.createBarChart3D("月客退率排名", "機種名稱", "比率(%)", dataSet, org.jfree.chart.plot.PlotOrientation.VERTICAL, false, true, true);
      CategoryPlot plot = chart.getCategoryPlot();

      plot.setForegroundAlpha(0.50f); 

      java.awt.Paint bkColor =  plot.getBackgroundPaint();  // 指的是平面背景的顏色(預設=白色)
      java.awt.Paint otlineColor =  plot.getOutlinePaint(); // 指的是立體背景的顏色(預設=灰色)
      java.awt.Image bkImg = plot.getBackgroundImage();     
      double areaRatio = plot.getDataAreaRatio();  
      String plotType = plot.getPlotType();        
      out.println(bkColor); out.println(otlineColor); out.println(bkImg); out.println("areaRatio="+areaRatio); out.println("plotType="+plotType); 
      //chart.setBackgroundPaint(java.awt.Color.orange);
      chart.setBackgroundPaint(new Color(255,255,166));
      chart.setBorderVisible(true);   
*/
             


  
         
  //       String filename = null;        
         org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
         org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
         org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
         renderer3D.setSeriesPaint(0,new Color(255,255,170)); 

         renderer3D.setItemLabelFont(new Font("標楷體",java.awt.Font.ITALIC,10));
   //      renderer3D.setItemURLGenerator(new StandardCategoryURLGenerator("MyJFreeChart.jsp","series","section")); 
   //      renderer3D.setToolTipGenerator(new StandardCategoryToolTipGenerator());
         org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
               plot.setForegroundAlpha(1.00f);
               plot.setNoDataMessage("沒有相關資訊");    

         //設定每個bar上頭的數字   
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
                
         org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("各區詢問單轉訂單數", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);
  //               chart.setBackgroundPaint(java.awt.Color.white);
                   chart.setBackgroundPaint(new Color(220,255,170));      
                   chart.setBorderVisible(true);  
      //  org.jfree.chart.title.TextTitle subTitle = new org.jfree.chart.title.TextTitle("機種名稱", new Font("標楷體",java.awt.Font.ITALIC,12),new Color(255,0,0));   
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("銷售業務地區", new Font("新細明體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,128,128), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,10) ) ; 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYTitle = new org.jfree.chart.title.TextTitle("轉訂單數", new Font("新細明體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,128,128), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,10,0,0,0) ) ; 
        chart.addSubtitle(subYTitle);        
 
        //  Write the chart image to the temporary directory
 //        ChartRenderingInfo info = new ChartRenderingInfo(new StandardEntityCollection());
 //        filename = ServletUtilities.saveChartAsPNG(chart, 500, 300, info, request);

        //  Write the image map to the PrintWriter
 //        ChartUtilities.writeImageMap(pw, filename, info);
 //        pw.flush();     


         
        out.clearBuffer();
        OutputStream ostream = response.getOutputStream();
        org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 480, 320);      
        ostream.close();      
  
%>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
