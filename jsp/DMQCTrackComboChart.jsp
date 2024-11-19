<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.*,java.awt.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*,org.jCharts.*,org.jCharts.chartData.*,org.jCharts.properties.*,org.jCharts.types.ChartType.*,org.jCharts.axisChart.*,org.jCharts.test.TestDataGenerator.*,org.jCharts.encoders.JPEGEncoder13.*,org.jCharts.properties.util.ChartFont.*,org.jCharts.encoders.ServletEncoderHelper.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>

<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>


<% 

   		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO"); 
		String sYear=request.getParameter("YEAR");
		String sMonth=request.getParameter("MONTH"); 
		//out.println(sModelNo);
		//out.println(sYear);
		//out.println(sMonth);
		
		if (sModelNo==null) {sModelNo="2052C";}
		
		int iYearSelect = 0;
		int iMonthSelect = 0;
		int iMaxMonthDays = 0;
		String sDateSelectFr = "";
		String sDateSelectTo = "";
		try
		{
			if (sYear==null) 
			{ 
				sYear = dateBean.getYearString();
				iYearSelect = dateBean.getYear();
			}
			else iYearSelect = Integer.parseInt(sYear);
			
			if (sMonth==null) 
			{
				sMonth = dateBean.getMonthString();
				iMonthSelect = dateBean.getMonth();
			}
			else iMonthSelect = Integer.parseInt(sMonth);
			
			dateBean.setDate(iYearSelect, iMonthSelect, 1);
			// max day in month
			iMaxMonthDays = dateBean.getMonthMaxDay();
			//out.println(iMaxMonthDays);
		
			sDateSelectFr = sYear + sMonth + "01";
			sDateSelectTo = sYear + sMonth + String.valueOf(iMaxMonthDays);
			//out.println(sDateSelectFr);
			//out.println(sDateSelectTo);
		} // end of try
		catch (Exception e)
		{out.println("Exception:"+e.getMessage());}
		

%>


<%
int width = 600;
int height = 400;
try
{
	if(sModelNo!=null)
	{
	// new bar chart
	BarChartProperties barChartProperties = new org.jCharts.properties.BarChartProperties();
	// new legend
	LegendProperties legendProperties = new org.jCharts.properties.LegendProperties();
	// new char
	ChartProperties chartProperties = new org.jCharts.properties.ChartProperties();
	// new axis
	AxisProperties axisProperties = new org.jCharts.properties.AxisProperties();
	// set axis font
	org.jCharts.properties.util.ChartFont axisScaleFont = new org.jCharts.properties.util.ChartFont( new Font( "Arial Black", Font.PLAIN, 12 ), Color.red.darker() );
	axisProperties.getXAxisProperties().setScaleChartFont( axisScaleFont );
	axisProperties.getYAxisProperties().setScaleChartFont( axisScaleFont );
	// set x,y font
	org.jCharts.properties.util.ChartFont axisTitleFont = new org.jCharts.properties.util.ChartFont( new Font( "Arial Narrow", Font.PLAIN, 14 ), Color.black );
	axisProperties.getXAxisProperties().setTitleChartFont( axisTitleFont );
	axisProperties.getYAxisProperties().setTitleChartFont( axisTitleFont );
	// set char title font
	org.jCharts.properties.util.ChartFont titleFont = new org.jCharts.properties.util.ChartFont( new Font( "Georgia Negreta cursiva", Font.PLAIN, 14 ), Color.black );
	chartProperties.setTitleFont( titleFont );
	// set line chart style
	Stroke[] strokes = {LineChartProperties.DEFAULT_LINE_STROKE};
	Shape[] shapes = {PointChartProperties.SHAPE_DIAMOND};
	org.jCharts.properties.LineChartProperties lineChartProperties = new org.jCharts.properties.LineChartProperties( strokes, shapes );
	
	// show value in chart
	//org.jCharts.axisChart.customRenderers.axisValue.renderers.ValueLabelRenderer valueLabelRenderer = new org.jCharts.axisChart.customRenderers.axisValue.renderers.ValueLabelRenderer( false, false, true, -1 );
	//valueLabelRenderer.setValueLabelPosition( org.jCharts.axisChart.customRenderers.axisValue.renderers.ValueLabelPosition.ON_TOP );
	//valueLabelRenderer.useVerticalLabels( false );
	//barChartProperties.addPostRenderEventListener( valueLabelRenderer ); 

	// initial draw x, y
	String xAxisTitle = "DAY";
	String yAxisTitle =  "YIELD RATE";
	String title = " MONTHLY YIELD RATE(PT,MT,FCT) IN ";
	title = sModelNo + title + sMonth + "/" + sYear + "(" + String.valueOf(iMaxMonthDays) + ")";
	// initial x axis label
	String[] xAxisLabels = { "1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" };	
	org.jCharts.chartData.interfaces.IAxisDataSeries dataSeries = new org.jCharts.chartData.DataSeries( xAxisLabels, xAxisTitle, yAxisTitle, title );
	
	String[] legendLabels = {"YIELD RATE"};
	Paint[] paints = new Paint[]{Color.blue.darker()};
	Paint[] linePaints = new Paint[]{Color.yellow};
	
	// initial data must be the same with initial x axis label
	double[][] data = new double[][]{{0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}};
	//float fRate = 0;
	int iIndex = 0;
	String sqlMM = "";
	Statement stateMM=dmcon.createStatement();
	
	
	// input data
	int n = 0;
	while ( n < iMaxMonthDays )
	{
		String sn = "";
		if (n+1<=9) {sn=sYear+sMonth+"0"+String.valueOf(n+1);}
		else {sn=sYear+sMonth+String.valueOf(n+1);}
		
		
		sqlMM = "select (1-ROUND(SUM((INQTY-OUTQTY)/INQTY),4))*100 as YIELD from dailyprod ";
		sqlMM = sqlMM + "WHERE INQTY>0 AND OUTQTY>0 AND STANUM IN ('PT','MT','FCT')"+
		" AND GENDATE ="+sn+
		" AND MODELNO='"+sModelNo.trim()+"'";
		//out.println(sqlMM);
		ResultSet rsMM=stateMM.executeQuery(sqlMM);
		boolean rsMM_isEmpty = !rsMM.next();		
		boolean rsMM_hasData = !rsMM_isEmpty;
		if (rsMM_hasData)
		{
			String sRate = rsMM.getString("YIELD");
			if (sRate!=null)
			{
				iIndex = sRate.indexOf(".");
				if (iIndex>0) { data[0][n] = Integer.parseInt(sRate.substring(0,iIndex));}
				else { data[0][n] = Integer.parseInt(sRate);}
			}
			else {data[0][n] = 0;}
			//out.println(sn); out.println(sRate); out.println("<br>");

		}
		else { data[0][n] = 0; }
		
		rsMM.close();
		

		n++;
	} // end of while
	
	stateMM.close();
	
	// draw char
	dataSeries.addIAxisPlotDataSet( new org.jCharts.chartData.AxisChartDataSet( data, legendLabels, paints, org.jCharts.types.ChartType.BAR, barChartProperties ) );
	dataSeries.addIAxisPlotDataSet( new org.jCharts.chartData.AxisChartDataSet( data, legendLabels, linePaints, org.jCharts.types.ChartType.LINE, lineChartProperties ) );
	out.clearBuffer();
	org.jCharts.axisChart.AxisChart axisChart = new org.jCharts.axisChart.AxisChart( dataSeries, chartProperties, axisProperties, legendProperties, width, height );
	org.jCharts.encoders.ServletEncoderHelper.encodeJPEG13( axisChart, 1.0f, response );


	} // end of if

} // end of try
catch (Exception e)
{out.println("Exception:"+e.getMessage());}

%>
<html>
<head>
<title>DPHU</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

