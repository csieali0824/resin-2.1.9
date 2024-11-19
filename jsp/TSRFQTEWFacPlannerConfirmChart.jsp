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
   
     String factoryTEW=request.getParameter("FAC");                 

   
     

      thisYear = workingDateBean.getYearString();  
      thisMonth = workingDateBean.getMonthString();
      thisWeek = workingDateBean.getWeekString();  

     workingDateBean.setAdjMonth(-11);                      
     String beginYYYYMMTEW = workingDateBean.getYearMonthDay().substring(0,6);
     workingDateBean.setAdjMonth(11); 
  
     String endYYYYMMTEW = workingDateBean.getYearMonthDay().substring(0,6);  

     
    String sqlOpenedTEW = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as OPENED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                         "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                         "    and f.ORISTATUSID = '002' "+ // Assigning  
                         "    and f.actionid = '003' "+  // Planner Action ( ASSIGNING ) 
						 "    and e.MANUFACTORY_NO = '001' "+ // TEW
                         "    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMMTEW+"' AND '"+endYYYYMMTEW+"' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') ";     
    String sWhereOpenedTEW = " ";
       //out.println(sqlOpenedTEW);
       sqlOpenedTEW = sqlOpenedTEW + sWhereOpenedTEW;

       org.jfree.data.time.TimeSeries timedataSeriesOpenedTEW = new org.jfree.data.time.TimeSeries("RECEIPTCNT",org.jfree.data.time.Month.class);   
       Statement stateXY1TEW=con.createStatement();          
       ResultSet rsXY1TEW=stateXY1TEW.executeQuery(sqlOpenedTEW);
       while (rsXY1TEW.next())
       {         
           String initYYYYMM = rsXY1TEW.getString(1);                
          
          timedataSeriesOpenedTEW.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY1TEW.getString(1).substring(4,6)),Integer.parseInt(rsXY1TEW.getString(1).substring(0,4))), rsXY1TEW.getInt(2));  // --
            
       }
       rsXY1TEW.close();
       stateXY1TEW.close(); 

      // Start
      int countInitalTEW = 0;      

      //End           

      String sqlClosedTEW = " select to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM'), count(d.DNDOCNO) as CLOSED "+
                         "   from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+ 
                         "        ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_DETAIL_HISTORY f "+	   	                   
                         "  where d.DNDOCNO = f.DNDOCNO and d.LINE_NO = f.LINE_NO "+
                         "    and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
                         "    and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
                         "    and f.ORISTATUSID = '004' "+ // Open 
                         "    and f.actionid = '009' "+  // Action 
						 "    and e.MANUFACTORY_NO = '001' "+ // TEW
                         "    and substr(d.CREATION_DATE,0,6) between '"+beginYYYYMMTEW+"' AND '"+endYYYYMMTEW+"' "+
      		             "  group by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') "+
                         "  order by to_char(to_date(substr(d.CREATION_DATE,0,6),'YYYYMM'),'YYYYMM') ";	                     
       String sWhereClosedTEW = " ";
       //out.println(sqlClosedTEW);
       sqlClosedTEW = sqlClosedTEW + sWhereClosedTEW;

       org.jfree.data.time.TimeSeries timedataSeriesClosedTEW = new org.jfree.data.time.TimeSeries("RESPONECNT",org.jfree.data.time.Month.class);   
       Statement stateXY2TEW=con.createStatement();          
       ResultSet rsXY2TEW=stateXY2TEW.executeQuery(sqlClosedTEW);
       while (rsXY2TEW.next())
       {      
          String initYYYYMM = rsXY2TEW.getString(1);
          
          timedataSeriesClosedTEW.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY2TEW.getString(1).substring(4,6)),Integer.parseInt(rsXY2TEW.getString(1).substring(0,4))), rsXY2TEW.getInt(2));      
            
       }
       rsXY2TEW.close();
       stateXY2TEW.close();     
       
       org.jfree.data.time.TimeSeriesCollection dataSetPCTEW = new org.jfree.data.time.TimeSeriesCollection();
         
       dataSetPCTEW.addSeries(timedataSeriesOpenedTEW);
       dataSetPCTEW.addSeries(timedataSeriesClosedTEW);   
       dataSetPCTEW.setDomainIsPointsInTime(true);
      // dataSet.executeQuery(sql);

   //   JFreeChart chart=null;
   //   chart = org.jfree.chart.ChartFactory.createBarChart3D("Chart", "Model", "Rate(%)", dataSet, org.jfree.chart.plot.PlotOrientation.VERTICAL, true, true, false);
   //   CategoryPlot plot = chart.getCategoryPlot();

   //   out.clearBuffer();
   //   OutputStream ostream = response.getOutputStream();
   //   org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 416, 260);
      
   //   ostream.close();
      ///BarRenderer renderer = new BarRenderer(); 

      String filenamePCTEW = null;   
      java.io.PrintWriter pwPCTEW = new PrintWriter(out);    
 
      
      org.jfree.chart.axis.ValueAxis timeAxisPCTEW = new org.jfree.chart.axis.DateAxis("");
      org.jfree.chart.axis.NumberAxis valueAxisPCTEW = new org.jfree.chart.axis.NumberAxis("");
      org.jfree.chart.axis.NumberAxis valueAxisRetnTEW = new org.jfree.chart.axis.NumberAxis("");  
      org.jfree.chart.axis.CategoryAxis3D categoryAxis3DPCTEW = new org.jfree.chart.axis.CategoryAxis3D("");
      //org.jfree.chart.axis.ValueAxis valueAxis = new org.jfree.chart.axis.NumberAxis("");  
      valueAxisPCTEW.setAutoRangeIncludesZero(false);  // override default

      //String dateTimeGet[] = dataSet.getLegendItemLabels();     
      //out.println(dateTimeGet[0]);       
      SimpleDateFormat sdfPCTEW = new SimpleDateFormat("yyyyMM", Locale.TAIWAN);
      //SimpleDateFormat sdf = new SimpleDateFormat("yyyyMM");  
      org.jfree.chart.labels.StandardXYToolTipGenerator ttgPCTEW = new org.jfree.chart.labels.StandardXYToolTipGenerator(org.jfree.chart.labels.StandardXYToolTipGenerator.DEFAULT_TOOL_TIP_FORMAT, sdfPCTEW, NumberFormat.getInstance()); 
      org.jfree.chart.urls.TimeSeriesURLGenerator urlgPCTEW = new org.jfree.chart.urls.TimeSeriesURLGenerator(sdfPCTEW, "jsp/TSRFQTEWFacPlannerConfirmIMap.jsp?FAC="+factoryTEW, "TRENDMODE","DATETIME");
      org.jfree.chart.renderer.xy.StandardXYItemRenderer rendererXYItemPCTEW = new org.jfree.chart.renderer.xy.StandardXYItemRenderer(org.jfree.chart.renderer.xy.StandardXYItemRenderer.LINES + org.jfree.chart.renderer.xy.StandardXYItemRenderer.SHAPES, ttgPCTEW, urlgPCTEW);  

      rendererXYItemPCTEW.setShapesFilled(true);

      //org.jfree.chart.renderer.category.BarRenderer3D renderer3D = new org.jfree.chart.renderer.category.BarRenderer3D();
      //renderer3D.setItemURLGenerator(new org.jfree.chart.urls.StandardCategoryURLGenerator("PISDOAP12MonthReturnRateRpt.jsp","RETURNRATE","MODELNO")); 
      //renderer3D.setToolTipGenerator(new org.jfree.chart.labels.StandardCategoryToolTipGenerator());
      org.jfree.chart.plot.XYPlot plotPCTEW = new org.jfree.chart.plot.XYPlot(dataSetPCTEW, timeAxisPCTEW, valueAxisPCTEW, rendererXYItemPCTEW);
      plotPCTEW.setBackgroundPaint(java.awt.Color.lightGray);
      plotPCTEW.setDomainGridlinePaint(java.awt.Color.white);
      plotPCTEW.setRangeGridlinePaint(java.awt.Color.white); 
      plotPCTEW.setAxisOffset(new org.jfree.ui.Spacer(org.jfree.ui.Spacer.ABSOLUTE,5.0,5.0,5.0,5.0) );
      plotPCTEW.setDomainCrosshairVisible(true) ;
      plotPCTEW.setRangeCrosshairVisible(true);

      plotPCTEW.setRangeAxis(0, valueAxisPCTEW);       
      plotPCTEW.setRangeAxisLocation(0, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_LEFT);     

     // plot.setRangeAxis(1, valueAxisRetnTEW);
      plotPCTEW.setRangeAxis(1, valueAxisRetnTEW);       
      plotPCTEW.setRangeAxisLocation(1, org.jfree.chart.axis.AxisLocation.BOTTOM_OR_RIGHT); 

      plotPCTEW.zoomVerticalAxes(1.5);
   
      org.jfree.chart.JFreeChart chartPCTEW = new org.jfree.chart.JFreeChart("PC Receipt/Confirmed Chart", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plotPCTEW, false);
      chartPCTEW.setBackgroundPaint(java.awt.Color.white);

          
  
       //  org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
         plotPCTEW.setNoDataMessage("No Record Found");    
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
        chartPCTEW.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitlePCTEW = new org.jfree.chart.title.TextTitle("Date Period", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,15) ) ; // --
        chartPCTEW.addSubtitle(subXTitlePCTEW); 

        org.jfree.chart.title.TextTitle subYLTitleTEW = new org.jfree.chart.title.TextTitle("Receipt", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,15,0,0,0) ) ; // --
        chartPCTEW.addSubtitle(subYLTitleTEW);   

        org.jfree.chart.title.TextTitle subYRTitleTEW = new org.jfree.chart.title.TextTitle("Response", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,255), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,15,0) ) ; // --
        chartPCTEW.addSubtitle(subYRTitleTEW);           
       
        //  Write the chart image to the temporary directory
        ChartRenderingInfo infoPCTEW = new ChartRenderingInfo(new org.jfree.chart.entity.StandardEntityCollection());
        filenamePCTEW = org.jfree.chart.servlet.ServletUtilities.saveChartAsJPEG(chartPCTEW, 480, 320, infoPCTEW, session);

        //  Write the image map to the PrintWriter
        ChartUtilities.writeImageMap(pwPCTEW, filenamePCTEW, infoPCTEW);
        pwPCTEW.flush();     
  
%>
<table></table>
<img border="0" src="jsp/TSRFQTEWFacPlannerConfirmIMap.jsp" useMap="#<%=filenamePCTEW%>">
</body>
</html>
<!--=============Release==========-->
<!--%@ include file="/jsp/include/ReleaseConnPage.jsp"%-->
<!--=================================-->
