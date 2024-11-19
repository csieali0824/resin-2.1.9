<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,java.io.*,java.text.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import="java.awt.image.BufferedImage" %>
<%@ page import="javax.imageio.ImageIO" %>
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
     String factory=request.getParameter("FAC");                 

     String webID="";    
     String sqlGlobal = "";     
       

     String thisYear = workingDateBean.getYearString();  
     String thisMonth = workingDateBean.getMonthString();
     String thisWeek = workingDateBean.getWeekString();  

     workingDateBean.setAdjMonth(-11);                      
     String beginYYYYMM = workingDateBean.getYearMonthDay().substring(0,6);
     workingDateBean.setAdjMonth(11);  

     String endYYYYMM = workingDateBean.getYearMonthDay().substring(0,6);         

     

       // org.jfree.data.xy.DefaultTableXYDataset dataset = new org.jfree.data.xy.DefaultTableXYDataset();       
       
       //org.jfree.data.jdbc.JDBCXYDataset dataSet=new org.jfree.data.jdbc.JDBCXYDataset(con); 
  

    
    /*String sqlOpened = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as OPENED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                      //   "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                       // "    and f.ORISTATUSID = '002' "+ // Assigning  
                        // "    and f.actionid = '003' "+  // Planner Action ( ASSIGNING ) 
                         "    and f.ORISTATUSID = '003' "+ // salse
                         "    and f.actionid = '008' "+  // Planner Action ( CONFIRM ) 台北企劃取消後,改pc回覆
						 "    and d.ASSIGN_MANUFACT  = '002' "+  // Sandon /20091117
                         // 20110520 Marvie Update : Performance Issue
                         //"    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMM+"' AND '"+endYYYYMM+"' "+
                         "    and d.CREATION_DATE between '"+beginYYYYMM+"' AND '"+endYYYYMM+"31235959' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "; 
   
       String sWhereOpened = " ";
       out.println(sqlOpened);
       sqlOpened = sqlOpened + sWhereOpened;

       org.jfree.data.time.TimeSeries timedataSeriesOpened = new org.jfree.data.time.TimeSeries("RECEIPTCNT",org.jfree.data.time.Month.class);   
       Statement stateXY1=con.createStatement();          
       ResultSet rsXY1=stateXY1.executeQuery(sqlOpened);
       while (rsXY1.next())
       {         
           String initYYYYMM = rsXY1.getString(1);                
          
          timedataSeriesOpened.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY1.getString(1).substring(4,6)),Integer.parseInt(rsXY1.getString(1).substring(0,4))), rsXY1.getInt(2));  // 加送單據數     
            
       }
       rsXY1.close();
       stateXY1.close(); 

           // 取退貨數初值 起
                int countInital = 0;

      // 取退貨數初值 迄  

      String sqlClosed = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as CLOSED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                      //   "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+  //20091117
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                         "    and f.ORISTATUSID = '004' "+ // Open 
                         "    and f.actionid = '009' "+  // Action 
						 "    and d.ASSIGN_MANUFACT = '002' "+ // Sandon //20091117
                         // 20110520 Marvie Update : Performance Issue
                         //"    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMM+"' AND '"+endYYYYMM+"' "+
                         "    and d.CREATION_DATE between '"+beginYYYYMM+"' AND '"+endYYYYMM+"31235959' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') ";	                      
       String sWhereClosed = " ";
       out.println(sqlClosed);
       sqlClosed = sqlClosed + sWhereClosed;

       org.jfree.data.time.TimeSeries timedataSeriesClosed = new org.jfree.data.time.TimeSeries("RESPONECNT",org.jfree.data.time.Month.class);   
       Statement stateXY2=con.createStatement();          
       ResultSet rsXY2=stateXY2.executeQuery(sqlClosed);
       while (rsXY2.next())
       {      
          String initYYYYMM = rsXY2.getString(1);
          
          timedataSeriesClosed.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY2.getString(1).substring(4,6)),Integer.parseInt(rsXY2.getString(1).substring(0,4))), rsXY2.getInt(2));      
            
       }
       rsXY2.close();
       stateXY2.close();     
	   */

       //String sql = " select RFQ_YM,OPEN_CNT,CLOSE_CNT from oraddman.tsrfq_fact_confirm_view a where RFQ_YM>="+beginYYYYMM+" and RFQ_YM<="+endYYYYMM+" and FACTORY_CODE='002'";
	   String sql = " select * from (select x.*,row_number() over (partition by RFQ_YM order by seqno) rank_seq"+
             "               from (select RFQ_YM,OPEN_CNT,CLOSE_CNT,1 as seqno from oraddman.tsrfq_fact_confirm_view a where RFQ_YM>="+beginYYYYMM+" and RFQ_YM<="+endYYYYMM+" and FACTORY_CODE='002'"+
             "                     union all"+
             "                     select RFQ_YM,OPEN_CNT,CLOSE_CNT,2 as seqno from oraddman.tsrfq_fact_confirm_view_his a where RFQ_YM>="+beginYYYYMM+" and RFQ_YM<="+endYYYYMM+" and FACTORY_CODE='002') x) y where rank_seq=1";
       org.jfree.data.time.TimeSeries timedataSeriesOpened = new org.jfree.data.time.TimeSeries("RECEIPTCNT",org.jfree.data.time.Month.class);   
       org.jfree.data.time.TimeSeries timedataSeriesClosed = new org.jfree.data.time.TimeSeries("RESPONECNT",org.jfree.data.time.Month.class);   
	   
       Statement stateXY=con.createStatement();          
       ResultSet rsXY=stateXY.executeQuery(sql);
       while (rsXY.next())
       {         
           //String initYYYYMM = rsXY1.getString(1);                
          
          timedataSeriesOpened.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY.getString(1).substring(4,6)),Integer.parseInt(rsXY.getString(1).substring(0,4))), rsXY.getInt(2));  
          timedataSeriesClosed.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY.getString(1).substring(4,6)),Integer.parseInt(rsXY.getString(1).substring(0,4))), rsXY.getInt(3));      
            
       }
       rsXY.close();
       stateXY.close(); 
	   							 
       org.jfree.data.time.TimeSeriesCollection dataSet = new org.jfree.data.time.TimeSeriesCollection();
         
       dataSet.addSeries(timedataSeriesOpened);
       dataSet.addSeries(timedataSeriesClosed);     
       dataSet.setDomainIsPointsInTime(true);
                    
       //dataSet.executeQuery(sql);
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
           
      org.jfree.chart.axis.ValueAxis timeAxis = new org.jfree.chart.axis.DateAxis("");
      org.jfree.chart.axis.NumberAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");
      org.jfree.chart.axis.NumberAxis valueAxisRetn = new org.jfree.chart.axis.NumberAxis("");            
      //org.jfree.chart.axis.CategoryAxis3D categoryAxis3D = new org.jfree.chart.axis.CategoryAxis3D("");
      //org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
      valueAxis.setAutoRangeIncludesZero(false);  // override default
             
      SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM", Locale.TAIWAN);
      //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");        
      org.jfree.chart.labels.StandardXYToolTipGenerator ttg = new org.jfree.chart.labels.StandardXYToolTipGenerator(org.jfree.chart.labels.StandardXYToolTipGenerator.DEFAULT_TOOL_TIP_FORMAT, sdf, NumberFormat.getInstance()); 
      org.jfree.chart.urls.TimeSeriesURLGenerator urlg = new org.jfree.chart.urls.TimeSeriesURLGenerator(sdf, "TSRFQYEWFacPlannerConfirmIMap.jsp?FAC="+factory, "TRENDMODE", "DATETIME");
      org.jfree.chart.renderer.xy.StandardXYItemRenderer rendererXYItem = new org.jfree.chart.renderer.xy.StandardXYItemRenderer(org.jfree.chart.renderer.xy.StandardXYItemRenderer.LINES + org.jfree.chart.renderer.xy.StandardXYItemRenderer.SHAPES, ttg, urlg);  

      rendererXYItem.setShapesFilled(true);

      //org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
      //renderer3D.setItemURLGenerator(new org.jfree.chart.urls.StandardCategoryURLGenerator("PISDOAP12MonthReturnRateRpt.jsp","RETURNRATE","MODELNO")); 
      //renderer3D.setToolTipGenerator(new org.jfree.chart.labels.StandardCategoryToolTipGenerator());
      org.jfree.chart.plot.XYPlot plot = new org.jfree.chart.plot.XYPlot(dataSet, timeAxis, valueAxis, rendererXYItem);
      plot.setBackgroundPaint(java.awt.Color.lightGray);
      plot.setDomainGridlinePaint(java.awt.Color.white);
      plot.setRangeGridlinePaint(java.awt.Color.white); 
      plot.setAxisOffset(new org.jfree.ui.Spacer(org.jfree.ui.Spacer.ABSOLUTE,5.0,5.0,5.0,5.0) );
      plot.setDomainCrosshairVisible(true) ;
      plot.setRangeCrosshairVisible(true);  

      plot.setRangeAxis(0, valueAxis);       
      plot.setRangeAxisLocation(0, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_LEFT);  

     // plot.setRangeAxis(1, valueAxisRetn);
      plot.setRangeAxis(1, valueAxisRetn);       
      plot.setRangeAxisLocation(1, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_RIGHT); 

      plot.zoomVerticalAxes(1.5);

      org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("山東廠企劃每月訂單接收/回覆統計", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plot, false);
      
      chart.setBackgroundPaint(java.awt.Color.white);

                
  
        // org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
      plot.setNoDataMessage("沒有相關資訊");    
/*
         //設定每個bar上頭的數字   
         org.jfree.chart.labels.StandardCategoryLabelGenerator labelGT = new org.jfree.chart.labels.StandardCategoryLabelGenerator(); 
         //org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = (org.jfree.chart.renderer.category.CategoryItemRenderer)plot.getRenderer(); 
         org.jfree.chart.plot.CategoryPlot catePlot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, rendererXYItem);  
         org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = catePlot.getRenderer();        
         itemRenderer.setLabelGenerator(labelGT);
         itemRenderer.setItemLabelFont(new Font("SansSerif", Font.BOLD, 11));
         itemRenderer.setItemLabelPaint(new Color(0,0,150));
         itemRenderer.setSeriesItemLabelsVisible(0, true); 
*/                 
    //  JFreeChart chart = new JFreeChart("月客退率排名", JFreeChart.DEFAULT_TITLE_FONT, plot, false);

        chart.setBackgroundPaint(new Color(255,255,255));      
        chart.setBorderVisible(true);  
           
        org.jfree.chart.title.TextTitle subXTitle = new org.jfree.chart.title.TextTitle("日期區間", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,15) ) ;  // 左右上下 
        chart.addSubtitle(subXTitle); 

        org.jfree.chart.title.TextTitle subYLTitle = new org.jfree.chart.title.TextTitle("月接收數量(依料件品項)", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,15,0,0,0) ) ;  // 左右上下 
        chart.addSubtitle(subYLTitle); 

        org.jfree.chart.title.TextTitle subYRTitle = new org.jfree.chart.title.TextTitle("月回覆數量(依料件品項)", new Font("標楷體",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,255), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,15,0) ) ; // 左右上下
        chart.addSubtitle(subYRTitle);             
         
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

