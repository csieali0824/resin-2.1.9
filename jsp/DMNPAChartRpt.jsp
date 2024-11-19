<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理完成開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>

<script language="JavaScript" type="text/JavaScript">
function Wopen(s1,s2,s3,s4)
{   
  //subWin=window.open("DMStockStatusDetailReport.jsp?PRODNO="+prod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
  subWin=window.open("DMNPADetailRpt.jsp?MODELNO="+s1+"&NDATE="+s2+"&CLASS="+s3+"&STAT="+s4,"subwin");  
}
</script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NPA Status Report</title>
</head>

<body>
	<% 
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO");
		
		if ( sModelNo==null )  { sModelNo = ""; out.println("未傳入MODELNO");}
	%>


<form ACTION="../jsp/DMNPAReport.jsp" METHOD="post">

<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> NPA STATUS</strong></font>

<!--
	<table border="1">
	<tr>
		<td><font color="#333399" face="Arial Black">MODEL</font>
			<%
			/*
				try
				{
					String sSqlModel="";
					String sModel = "";
					sSqlModel = "SELECT DISTINCT MODELNO FROM NPA";
					Statement stateModel=bpcscon.createStatement();
					ResultSet rsModel=stateModel.executeQuery(sSqlModel);
					out.println("<select NAME='ModelNo'>");
					out.println("<OPTION VALUE=>-");
					while (rsModel.next())
					{
						//out.println(rsModel.getString("MODELNO"));
						sModel = rsModel.getString("MODELNO");
						if (sModel.equals(sModelNo)) {out.println("<OPTION VALUE='"+sModelNo+"' SELECTED>"+sModelNo);}
						else {out.println("<OPTION VALUE='"+sModel+"'>"+sModel);}
						
					} // end of while rsModel.next()
						
					out.println("</select>");
						
					rsModel.close();
					stateModel.close();
					
				} // end of try
				catch (Exception e)
				{ out.println("Exception:"+e.getMessage()); }
			
			*/
			%>
		
		</td>
		<td ><input name="Search"  type="submit" value="Query"></td>
	</tr>
	
</table>
-->

<table border="1">
	<tr bgcolor="#0072A8">
		<td><font color="#FFFF00" size="2" face="Arial">更新日期</font></td>
		<td colspan="4"> <font color='#FFFF00' size='2' face='Arial'>
		<%
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
					else { sD = "沒有最後一次更新紀錄"; }
				}
				rsDate.close();
				stateDate.close();
				out.println(sD);

			}
			
		%></font></td>
	</tr>
	<tr>
		<td ><font color="#000000" size="2" face="Arial">總材料數</font></td>
		<%
			float fCountTot = 0;
			int iCountTot = 0;
			try
			{
				
				if (sModelNo!=null && !sModelNo.equals("") && sDate!=null && !sDate.equals(""))
				{
					String sSqlCount = "SELECT SUM(NGCNT+OKCNT) AS COUNT FROM NPA WHERE MODELNO='"+sModelNo+"' AND NDATE="+sDate;
					Statement stateCount=bpcscon.createStatement();
					ResultSet rsCount=stateCount.executeQuery(sSqlCount);
					if (rsCount.next()) 
					{ 
						fCountTot = rsCount.getFloat("COUNT");
						iCountTot = rsCount.getInt("COUNT");
						if ( fCountTot > 0 ) {} else { fCountTot = 0; iCountTot = 0; }
						
					}
					rsCount.close();
					stateCount.close();
					//out.println(iCountTot);
				}
			} // end of try
			catch (Exception e)
			{ out.println("Exception:"+e.getMessage()); }
		%>
		<td colspan="3"><font color='#000000' size='2' face='Arial'><A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"ALL"+'"'+","+'"'+"ALL"%>")'><%=iCountTot%></A></font></td>
		
	</tr>

	<tr>
		<td><font color="#000000" size="2" face="Arial">材料類型</font></td>   
		<td><font color="#000000" size="2" face="Arial">已承認數</font></td>   
		<td><font color="#000000" size="2" face="Arial">未承認數</font></td>   
		<!--<td><font color="#000000" size="2" face="Arial">已承認率</font></td>-->
	</tr>
	

	
	<%
		try
		{
			
			String sClass = "";
			int iOK = 0;
			int iNG = 0;
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


			if (sModelNo!=null && sModelNo!="" && sDate!=null && !sDate.equals("") && fCountTot>0 )
			{
				
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
					else if (sClass.equals("MK") || sClass.equals("MB")) { iMKOK = iMKOK + iOK; iMKNG = iMKNG + iNG; }
					else if (sClass.equals("PK")) { iPKOK = iPKOK + iOK; iPKNG = iPKNG + iNG; }
					else if (sClass.equals("PL")) { iPLOK = iPLOK + iOK; iPLNG= iPLNG + iNG; }
					else { iOTOK = iOTOK + iOK; iOTOK = iOTOK + iNG; }
					
					rsCount_isEmpty = !rsCount.next();
					rsCount_hasData = !rsCount_isEmpty;
				} // end of while
			
				rsCount.close();
				stateCount.close();
				
%>
	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>(電子)EX</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"EX"+'"'+","+'"'+"Y"%>")'><%=iEXOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"EX"+'"'+","+'"'+"N"%>")'><%=iEXNG%></A></font></div></td>
		<% float fEXRATE = Math.round((iEXOK/fCountTot)*100); %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fEXRATE%>%</font></div></td>-->
	</tr>
	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>(機構)MK</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"MK"+'"'+","+'"'+"Y"%>")'><%=iMKOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"MK"+'"'+","+'"'+"N"%>")'><%=iMKNG%></A></font></div></td>
		<% float fMKRATE = Math.round((iMKOK/fCountTot)*100); %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fMKRATE%>%</font></div></td>-->
	</tr>
	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>(包材)PK</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"PK"+'"'+","+'"'+"Y"%>")'><%=iPKOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"PK"+'"'+","+'"'+"N"%>")'><%=iPKNG%></A></font></div></td>
		<% float fPKRATE = Math.round((iPKOK/fCountTot)*100); %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fPKRATE%>%</font></div></td>-->
	</tr>

	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>(塑膠)PL</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"PL"+'"'+","+'"'+"Y"%>")'><%=iPLOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"PL"+'"'+","+'"'+"N"%>")'><%=iPLNG%></A></font></div></td>
		<% float fPLRATE = Math.round((iPLOK/fCountTot)*100); %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fPLRATE%>%</font></div></td>-->
	</tr>

	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>(其他)OT</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"OT"+'"'+","+'"'+"Y"%>")'><%=iOTOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"OT"+'"'+","+'"'+"N"%>")'><%=iOTNG%></A></font></div></td>
		<% float fOTRATE = Math.round((iOTOK/fCountTot)*100); %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fOTRATE%>%</font></div></td>-->
	</tr>
	<tr>
		<td><div align='left'><font color='#000000' size='2' face='Arial'>合計</font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"ALL"+'"'+","+'"'+"Y"%>")'><%=iEXOK+iMKOK+iPKOK+iPLOK+iOTOK%></A></font></div></td>
		<td><div align='right'><font color='#000000' size='2' face='Arial'>
			<A HREF='javaScript:Wopen("<%=sModelNo+'"'+","+'"'+sDate+'"'+","+'"'+"ALL"+'"'+","+'"'+"N"%>")'><%=iEXNG+iMKNG+iPKNG+iPLNG+iOTNG%></A></font></div></td>
		<% float fRateTot = fEXRATE+fMKRATE+fPKRATE+fPLRATE+fOTRATE; if (fRateTot>100) fRateTot = 100; %>
		<!--<td><div align='right'><font color='#000000' size='2' face='Arial'><%=fRateTot%>%</font></div></td>-->
	
	</tr>
	<tr>
		<td ><font color="#000000" size="2" face="Arial">已承認率</font></td>
		<td colspan="2"><font color='#000000' size='2' face='Arial'><%=fRateTot%>%</font></td>
	</tr>

<%
			} // end of if


		} // end of try
		catch (Exception e)
		{ out.println("Exception:"+e.getMessage()); }
		
%>

</table>

</form>

<%
	try
	{
		out.println("<img src='DMNPAPieChart.jsp?MODELNO="+sModelNo+" '>&nbsp;&nbsp;");
	}
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());		  
	}
%>

</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>