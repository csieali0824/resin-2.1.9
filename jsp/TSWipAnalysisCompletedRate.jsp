<%@ page contentType="image/jpeg; charset=big5" language="java" import="java.sql.*,java.io.*,java.text.*,java.util.*,java.awt.*,org.jfree.chart.ui.*,org.jfree.data.*,org.jfree.chart.*,org.jfree.chart.plot.*" %>
<%@ page import="WorkingDateBean" %>
<%@ page import = "java.io.PrintWriter" %>
<!--=============Connection Pool==========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<!--=================================-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>

<title>PC Receipt/Confirmed Chart</title>
</head>
<body>

<%
 
	
       //out.println(sqlOpenedTEW); 
        String sqlMakeAvailableRate =   "  select  s_creation_date,s_fullload_rate,s_complete_rate  from tsc_factory_make_analysis";  

       org.jfree.data.time.TimeSeries timedataSeriesOpenedTEW = new org.jfree.data.time.TimeSeries("RECEIPTCNT",org.jfree.data.time.Month.class);   
       Statement stateXY1TEW=con.createStatement();          
       ResultSet rsXY1TEW=stateXY1TEW.executeQuery(sqlMakeAvailableRate);
	   
       while (rsXY1TEW.next())
       {         
           String initYYYYMM = rsXY1TEW.getString(1);                
          
           timedataSeriesOpenedTEW.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY1TEW.getString(1).substring(4,6)),Integer.parseInt(rsXY1TEW.getString(1).substring(0,4))), rsXY1TEW.getInt(2));  // --
           //timedataSeriesClosed.add(new org.jfree.data.time.Month(Integer.parseInt(rsXY2.getString(1).substring(4,6)),Integer.parseInt(rsXY2.getString(1).substring(0,4))), rsXY2.getInt(2));      

       }
       rsXY1TEW.close();
       stateXY1TEW.close(); 

      // Start
      int countInitalTEW = 0;      

      //End           
  
       org.jfree.data.time.TimeSeriesCollection dataSetPCTEW = new org.jfree.data.time.TimeSeriesCollection();
         
       dataSetPCTEW.addSeries(timedataSeriesOpenedTEW);  
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
      org.jfree.chart.urls.TimeSeriesURLGenerator urlgPCTEW = new org.jfree.chart.urls.TimeSeriesURLGenerator(sdfPCTEW, "", "1","2");
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
   

      org.jfree.chart.JFreeChart chart = new org.jfree.chart.JFreeChart("PC Receipt/Confirmed Chart", org.jfree.chart.JFreeChart.DEFAULT_TITLE_FONT, plotPCTEW, false);
      
	  chart.setBackgroundPaint(java.awt.Color.white);

          
  
       //  org.jfree.chart.plot.Plot plot = new CategoryPlot(dataSet, categoryAxis3D, valueAxis, renderer3D);
         plotPCTEW.setNoDataMessage("No Record Found");    
           
    //  JFreeChart chart = new JFreeChart("Rate Rank Permutation", JFreeChart.DEFAULT_TITLE_FONT, plot, false);

         chart.setBackgroundPaint(new Color(255,255,166));      
        chart.setBorderVisible(true);  
      
        org.jfree.chart.title.TextTitle subXTitlePCTEW = new org.jfree.chart.title.TextTitle("Date Period", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,0), org.jfree.ui.RectangleEdge.BOTTOM, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,0,15) ) ; // --
        chart.addSubtitle(subXTitlePCTEW); 

        org.jfree.chart.title.TextTitle subYLTitleTEW = new org.jfree.chart.title.TextTitle("Receipt", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(255,0,0), org.jfree.ui.RectangleEdge.LEFT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,15,0,0,0) ) ; // --
        chart.addSubtitle(subYLTitleTEW);   

        org.jfree.chart.title.TextTitle subYRTitleTEW = new org.jfree.chart.title.TextTitle("Response", new Font("Arial",java.awt.Font.PLAIN+java.awt.Font.BOLD,14), new Color(0,0,255), org.jfree.ui.RectangleEdge.RIGHT, org.jfree.ui.HorizontalAlignment.CENTER, org.jfree.ui.VerticalAlignment.CENTER, new org.jfree.ui.Spacer(1,0,0,15,0) ) ; // --
        chart.addSubtitle(subYRTitleTEW);           
       
        //  Write the chart image to the temporary directory
        //ChartRenderingInfo infoPCTEW = new ChartRenderingInfo(new org.jfree.chart.entity.StandardEntityCollection());
        //filenamePCTEW = org.jfree.chart.servlet.ServletUtilities.saveChartAsJPEG(chartPCTEW, 480, 320, infoPCTEW, session);

        //  Write the image map to the PrintWriter
       // ChartUtilities.writeImageMap(pwPCTEW, filenamePCTEW, infoPCTEW);
       // pwPCTEW.flush();     
		
		
		out.clearBuffer();
        OutputStream ostream = response.getOutputStream();
        org.jfree.chart.ChartUtilities.writeChartAsJPEG(ostream, chart, 480, 320);      
        ostream.close();      
  
%>
<table></table>
<!--<img border="0" src="jsp/TSWipAnalysisCompletedRateIMap.jsp" useMap="#//=filenamePCTEW%>">-->
</body>
</html>
<!--=============Release==========-->
<!--%@ include file="/jsp/include/ReleaseConnPage.jsp"%-->
<!--=================================-->
