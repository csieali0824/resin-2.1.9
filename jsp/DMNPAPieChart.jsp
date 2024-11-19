<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.util.*,java.awt.*,java.awt.Dimension.*,com.jrefinery.data.*,com.jrefinery.chart.*,com.jrefinery.chart.ui.*,com.jrefinery.chart.data.*,org.jCharts.*,org.jCharts.chartData.*,org.jCharts.properties.*,org.jCharts.types.ChartType.*,org.jCharts.axisChart.*,org.jCharts.test.TestDataGenerator.*,org.jCharts.encoders.JPEGEncoder13.*,org.jCharts.properties.util.ChartFont.*,org.jCharts.encoders.ServletEncoderHelper.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>

<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
	// 取得傳入參數
	String sModelNo=request.getParameter("MODELNO");
	//String sDate=request.getParameter("NDATE");
	//out.println(sModelNo);
	//out.println(sDate);
	
try
{

	int width = 416;
	int height = 260;
	
	String sDate = "";
	String sD = "";
	if (sModelNo!=null && !sModelNo.equals("") )
	{
		String sqlDate = "SELECT MAX(NDATE) AS NDATE FROM NPA WHERE MODELNO='"+sModelNo+"' ";
		Statement stateDate=bpcscon.createStatement();
		ResultSet rsDate=stateDate.executeQuery(sqlDate);
		if(rsDate.next()) 
		{ 
			
			sDate=rsDate.getString("NDATE"); 
			if ( sDate!=null && !sDate.equals("") )
			{
				sD = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8);
			}
			else { sD = ""; }
			//out.println(sD);
		}
		rsDate.close();
		stateDate.close();
	}
	
	float fCountTot = 0;
	if (sModelNo!=null && !sModelNo.equals("") && sDate!=null && !sDate.equals(""))
	{
		String sSqlCount = "SELECT SUM(NGCNT+OKCNT) AS COUNT FROM NPA WHERE MODELNO='"+sModelNo+"' AND NDATE="+sDate;
		Statement stateCount=bpcscon.createStatement();
		ResultSet rsCount=stateCount.executeQuery(sSqlCount);
		if (rsCount.next()) 
		{ 
			fCountTot = rsCount.getFloat("COUNT");
			if ( fCountTot > 0 ) {} else { fCountTot = 0; }
			
		}
		rsCount.close();
		stateCount.close();
	}





	
	String sClass = "";
	int iOK = 0; //已承認
	int iNG = 0; //未承認
	int iEXOK = 0; //電子料
	int iEXNG = 0; //電子料
	int iMKOK = 0; //機構料
	int iMKNG = 0; //機構料
	int iPKOK = 0; //包材料
	int iPKNG = 0; //包材料
	int iPLOK = 0; //塑膠料
	int iPLNG = 0; //塑膠料
	int iOTOK = 0; //其他
	int iOTNG = 0; //其他
	
	if (sModelNo!=null && !sModelNo.equals("") && sDate!=null && !sDate.equals("") && fCountTot>0 )
	{

		PieChart2DProperties properties = new org.jCharts.properties.PieChart2DProperties();
		ChartProperties chartProperties = new org.jCharts.properties.ChartProperties();
		LegendProperties legendProperties = new org.jCharts.properties.LegendProperties();
		legendProperties.setNumColumns( 2 );
		java.awt.Font legendFont = new java.awt.Font("標楷體", 0, 10);
		legendProperties.setFont(legendFont);      
		legendProperties.setPlacement( LegendProperties.BOTTOM );
		
		//double[] aData =  new double[10];
		//Paint[] aPaints = new Paint[]{Color.blue, Color.red, Color.green, Color.yellow, Color.magenta, Color.cyan, Color.lightGray, Color.white,  Color.pink, Color.orange};
		//String[] aLabels = {"","","","","","","","","",""};   
		double[] aData =  new double[2];
		Paint[] aPaints = new Paint[]{Color.blue, Color.red};
		String[] aLabels = {"",""};   


		String sSqlCount = "SELECT ICLAS,ICDES,SUM(OKCNT) AS OK,SUM(NGCNT) AS NG FROM NPA"+
		" WHERE MODELNO='"+sModelNo+"' AND NDATE="+sDate+
		" GROUP BY ICLAS,ICDES ORDER BY ICLAS";
		Statement stateCount=bpcscon.createStatement();
		ResultSet rsCount=stateCount.executeQuery(sSqlCount);
		boolean rsCount_isEmpty = !rsCount.next();		
		boolean rsCount_hasData = !rsCount_isEmpty;
		while (rsCount_hasData)	
		{
			sClass = rsCount.getString("ICLAS");
			sClass = sClass.trim();
			iOK = rsCount.getInt("OK");
			iNG = rsCount.getInt("NG");
			
			if (sClass.equals("EX")) { iEXOK = iEXOK + iOK; iEXNG = iEXNG + iNG; }
			else if (sClass.equals("MK")) { iMKOK = iMKOK + iOK; iMKNG = iMKNG + iNG; }
			else if (sClass.equals("PK")) { iPKOK = iPKOK + iOK; iPKNG = iPKNG + iNG; }
			else if (sClass.equals("PL")) { iPLOK = iPLOK + iOK; iPLNG = iPLNG + iNG; }
			else { iOTOK = iOTOK + iOK; iOTNG = iOTNG + iNG; }
			
			rsCount_isEmpty = !rsCount.next();
			rsCount_hasData = !rsCount_isEmpty;
		}
		
		rsCount.close();
		stateCount.close();
		
		/*
		aData[0] =  iEXOK; aLabels[0] = "已承認(電子)EX="+String.valueOf(iEXOK);
		aData[1] =  iEXNG; aLabels[1] = "未承認(電子)EX="+String.valueOf(iEXNG);		
		aData[2] =  iMKOK; aLabels[2] = "已承認(機構)MK="+String.valueOf(iMKOK);			  			  
		aData[3] =  iMKNG; aLabels[3] = "未承認(機構)MK="+String.valueOf(iMKNG);			  			  
		aData[4] =  iPKOK; aLabels[4] = "已承認(包材)PK="+String.valueOf(iPKOK);			  			  
		aData[5] =  iPKNG; aLabels[5] = "未承認(包材)PK="+String.valueOf(iPKNG);			  			  
		aData[6] =  iPLOK; aLabels[6] = "已承認(塑膠)PL="+String.valueOf(iPLOK);			  			  
		aData[7] =  iPLNG; aLabels[7] = "未承認(塑膠)PL="+String.valueOf(iPLNG);			  			  
		aData[8] =  iOTOK; aLabels[8] = "已承認(其他)OTHER="+String.valueOf(iOTOK);			  			  
		aData[9] =  iOTNG; aLabels[9] = "未承認(其他)OTHER="+String.valueOf(iOTNG);			
		*/  			  
		aData[0] =  iEXOK+iMKOK+iPKOK+iPLOK+iOTOK; aLabels[0] = "已承認="+String.valueOf(iEXOK+iMKOK+iPKOK+iPLOK+iOTOK);
		aData[1] =  iEXNG+iMKNG+iPKNG+iPLNG+iOTNG; aLabels[1] = "未承認="+String.valueOf(iEXNG+iMKNG+iPKNG+iPLNG+iOTNG);		



		org.jCharts.chartData.PieChartDataSet  pieChar = new org.jCharts.chartData.PieChartDataSet( sD+" "+sModelNo+" NPA承認率(材料類型)", aData, aLabels, aPaints, properties );
		out.clearBuffer();
		org.jCharts.nonAxisChart.PieChart2D pieChart2D = new org.jCharts.nonAxisChart.PieChart2D( pieChar, legendProperties, chartProperties, width, height );
		org.jCharts.encoders.ServletEncoderHelper.encodeJPEG13( pieChart2D, 1.0f, response );   
		OutputStream ostream = response.getOutputStream();
	} // end if


} // end try
catch (Exception e){out.println("Exception:"+e.getMessage());}

%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NPA Pie Chart</title>
</head>

<body>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>