<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,java.text.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>

<%@ page import = "java.io.PrintWriter" %>
<!--=============Connection Pool==========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<!--=================================-->

<html>
<head>

<title>PC Receipt/Confirmed Chart</title>
</head>
<body>

<%
   
     String factory=request.getParameter("FAC");                 

   
     

      thisYear = workingDateBean.getYearString();  
      thisMonth = workingDateBean.getMonthString();
      thisWeek = workingDateBean.getWeekString();  

     workingDateBean.setAdjMonth(-11);                      
     String beginYYYYMM = workingDateBean.getYearMonthDay().substring(0,6);
     workingDateBean.setAdjMonth(11); 
  
     String endYYYYMM = workingDateBean.getYearMonthDay().substring(0,6);  

  /* 20091117 liling update performance issue   
    String sqlOpened = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as OPENED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                         "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                         "    and f.ORISTATUSID = '002' "+ // Assigning  
                         "    and f.actionid = '003' "+  // Planner Action ( ASSIGNING ) 
						 "    and e.MANUFACTORY_NO = '002' "+ // Sandon
                         "    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMM+"' AND '"+endYYYYMM+"' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') ";    
*/
   /* String sqlOpened = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as OPENED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                      //   "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                       //  "    and f.ORISTATUSID = '002' "+ 
                      //   "    and f.actionid = '003' "+ 
                         "    and f.ORISTATUSID = '003' "+ // Assigning  
                         "    and f.actionid = '008' "+  // Planner Action (CONFIRM)
						 "    and d.ASSIGN_MANUFACT  = '002' "+  // Sandon /20091117
                         // 20110520 Marvie Update : Performance Issue
                         //"    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMM+"' AND '"+endYYYYMM+"' "+
                         "    and d.CREATION_DATE between '"+beginYYYYMM+"' AND '"+endYYYYMM+"31235959' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "; 
 
    String sWhereOpened = " ";
       //out.println(sqlOpened);
       sqlOpened = sqlOpened + sWhereOpened;

       org.jfree.data.time.TimeSeries timedataSeriesOpened = new org.jfree.data.time.TimeSeries("RECEIPTCNT",org.jfree.data.time.Month.class);   
       Statement stateXY1=con.createStatement();          
       ResultSet rsXY1=stateXY1.executeQuery(sqlOpened);
       while (rsXY1.next())
       {         
           String initYYYYMM = rsXY1.getString(1);                
          
          timedataSeriesOpened.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY1.getString(1).substring(4,6)),Integer.parseInt(rsXY1.getString(1).substring(0,4))), rsXY1.getInt(2));  // --
            
       }
       rsXY1.close();
       stateXY1.close(); 

      // Start
      int countInital = 0;      

      //End           
// 20091117 liling update performance issue
  //    String sqlClosed = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as CLOSED "+
    //                     "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
      //                   "        ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
        //                 "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
        //                 "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
         //                "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
         //                "    and f.ORISTATUSID = '004' "+ // Open 
         //                "    and f.actionid = '009' "+  // Action 
	//					 "    and e.MANUFACTORY_NO = '002' "+ // Sandon
     //                    "    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMM+"' AND '"+endYYYYMM+"' "+
      //		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
       //                  "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') ";	  

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
       //out.println(sqlClosed);
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
       stateXY2.close();  */
	   

	   //sql = " select RFQ_YM,OPEN_CNT,CLOSE_CNT from oraddman.tsrfq_fact_confirm_view a where RFQ_YM>="+beginYYYYMM+" and RFQ_YM<="+endYYYYMM+" and FACTORY_CODE='002'";
	   sql = " select * from (select x.*,row_number() over (partition by RFQ_YM order by seqno) rank_seq"+
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
       
       org.jfree.data.time.TimeSeriesCollection dataSetPC = new org.jfree.data.time.TimeSeriesCollection();
         
       dataSetPC.addSeries(timedataSeriesOpened);
       dataSetPC.addSeries(timedataSeriesClosed);   
       dataSetPC.setDomainIsPointsInTime(true);
      // dataSet.executeQuery(sql);

   //   JFreeChart chart=null;
   //   chart = org.jfree.chart.ChartFactory.createBarChart3D("Chart", "Model", "Rate(%)", dataSet, org.jfree.chart.plot.PlotOrientation.VERTICAL, true, true, false);
   //   CategoryPlot plot = chart.getCategoryPlot();

   //   out.clearBuffer();
   //   OutputStream ostream = response.getOutputStream();
   //   org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 416, 260);
      
   //   ostream.close();
      ///BarRenderer renderer = new BarRenderer(); 

      String filenamePC = null;   
      java.io.PrintWriter pwPC = new PrintWriter(out);    
 
      
      org.jfree.chart.axis.ValueAxis timeAxisPC = new org.jfree.chart.axis.DateAxis("");
      org.jfree.chart.axis.NumberAxis valueAxisPC = new org.jfree.chart.axis.NumberAxis("");
      org.jfree.chart.axis.NumberAxis valueAxisRetn = new org.jfree.chart.axis.NumberAxis("");  
      org.jfree.chart.axis.CategoryAxis3D categoryAxis3DPC = new org.jfree.chart.axis.CategoryAxis3D("");
      //org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
      valueAxisPC.setAutoRangeIncludesZero(false);  // override default

      //String dateTimeGet[] = dataSet.getLegendItemLabels();     
      //out.println(dateTimeGet[0]);       
      SimpleDateFormat sdfPC = new SimpleDateFormat("yyyyMM", Locale.TAIWAN);
      //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");  
      org.jfree.chart.labels.StandardXYToolTipGenerator ttgPC = new org.jfree.chart.labels.StandardXYToolTipGenerator(org.jfree.chart.labels.StandardXYToolTipGenerator.DEFAULT_TOOL_TIP_FORMAT, sdfPC, NumberFormat.getInstance()); 
      org.jfree.chart.urls.TimeSeriesURLGenerator urlgPC = new org.jfree.chart.urls.TimeSeriesURLGenerator(sdfPC, "jsp/TSRFQYEWFacPlannerConfirmIMap.jsp?FAC="+factory, "TRENDMODE","DATETIME");
      org.jfree.chart.renderer.xy.StandardXYItemRenderer rendererXYItemPC = new org.jfree.chart.renderer.xy.StandardXYItemRenderer(org.jfree.chart.renderer.xy.StandardXYItemRenderer.LINES + org.jfree.chart.renderer.xy.StandardXYItemRenderer.SHAPES, ttgPC, urlgPC);  

      rendererXYItemPC.setShapesFilled(true);

      //org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
      //renderer3D.setItemURLGenerator(new org.jfree.chart.urls.StandardCategoryURLGenerator("PISDOAP12MonthReturnRateRpt.jsp","RETURNRATE","MODELNO")); 
      //renderer3D.setToolTipGenerator(new org.jfree.chart.labels.StandardCategoryToolTipGenerator());
      org.jfree.chart.plot.XYPlot plotPC = new org.jfree.chart.plot.XYPlot(dataSetPC, timeAxisPC, valueAxisPC, rendererXYItemPC);
      plotPC.setBackgroundPaint(java.awt.Color.lightGray);
      plotPC.setDomainGridlinePaint(java.awt.Color.white);
      plotPC.setRangeGridlinePaint(java.awt.Color.white); 
      plotPC.setAxisOffset(new org.jfree.ui.Spacer(org.jfree.ui.Spacer.ABSOLUTE,5.0,5.0,5.0,5.0) );
      plotPC.setDomainCrosshairVisible(true) ;
      plotPC.setRangeCrosshairVisible(true);

      plotPC.setRangeAxis(0, valueAxisPC);       
      plotPC.setRangeAxisLocation(0, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_LEFT);     

     // plot.setRangeAxis(1, valueAxisRetn);
      plotPC.setRangeAxis(1, valueAxisRetn);       
      plotPC.setRangeAxisLocation(1, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_RIGHT); 

      plotPC.zoomVerticalAxes(1.5);
   
      org.jfree.chart.JFreeChart chartPC = new org.jfree.chart.JFreeChart("PC Receipt/Confirmed Chart", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plotPC, false);
      chartPC.setBackgroundPaint(java.awt.Color.white);

          
  
       //  org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
         plotPC.setNoDataMessage("No Record Found");    
/*
         //Set bars Number  
         org.jfree.chart.labels.StandardCategoryLabelGenerator labelGT = new org.jfree.chart.labels.StandardCategoryLabelGenerator(); 
         //org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = (org.jfree.chart.renderer.category.CategoryItemRenderer)plot.getRenderer(); 
         org.jfree.chart.plot.CategoryPlot catePlot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, rendererXYItem); 
         org.jfree.chart.renderer.category.CategoryItemRenderer itemRenderer = catePlot.getRenderer();        
         itemRenderer.setLabelGenerator(labelGT);
         itemRenderer.setItemLabelFont(new Font("SansSerif", Font.BOLD, 11));
         itemRenderer.setItemLabelPaint(new Color(0,0,150));
         itemRenderer.setSeriesItemLabelsVisible(0, true); 
 */                
    //  JFreeChart chart = new JFreeChart("Rate Rank Permutation", JFreeChart.DEFAULT_TITLE_FONT, plot, false);

    //    chart.setBackgroundPaint(new Color(255,255,166));      
        chartPC.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitlePC = new org.jfree.chart.title.TextTitle("Date Period", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,15) ) ; // --
        chartPC.addSubtitle(subXTitlePC); 

        org.jfree.chart.title.TextTitle subYLTitle = new org.jfree.chart.title.TextTitle("Receipt", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,15,0,0,0) ) ; // --
        chartPC.addSubtitle(subYLTitle);   

        org.jfree.chart.title.TextTitle subYRTitle = new org.jfree.chart.title.TextTitle("Response", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,255), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,15,0) ) ; // --
        chartPC.addSubtitle(subYRTitle);           
       
        //  Write the chart image to the temporary directory
//        ChartRenderingInfo infoPC = new ChartRenderingInfo(new org.jfree.chart.entity.StandardEntityCollection());
//        filenamePC = org.jfree.chart.servlet.ServletUtilities.saveChartAsJPEG(chartPC, 480, 320, infoPC, session);
//
//        //  Write the image map to the PrintWriter
//        ChartUtilities.writeImageMap(pwPC, filenamePC, infoPC);
//        pwPC.flush();
    // 渲染圖表為 BufferedImage // todo chart 似乎沒有用到
//    BufferedImage chartPCImage = chartPC.createBufferedImage(480, 300);
//    File outputPCfile = File.createTempFile("jfreechart-", ".jpeg", new File(System.getProperty("java.io.tmpdir")));
//    OutputStream outputPCStream = new BufferedOutputStream(new FileOutputStream(outputPCfile));
//    try {
//        ImageIO.write(chartPCImage, "jpeg", outputPCStream);
//        outputPCStream.flush();
//    } catch (IOException e) {
//        System.err.println("Error saving JPEG image: " + e.getMessage());
//    }
  
%>
<table></table>
<img border="0" src="jsp/TSRFQYEWFacPlannerConfirmIMap.jsp">
</body>
</html>
<!--=============Release==========-->
<!--%@ include file="/jsp/include/ReleaseConnPage.jsp"%-->
<!--=================================-->
