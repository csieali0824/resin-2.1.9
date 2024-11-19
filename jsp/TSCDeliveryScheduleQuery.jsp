<!-- 20180919 Peggy,CS同仁依所屬業務區顯示查詢結果及維護資料-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 121px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TSC Delivery Schedule Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setDelete(URL)
{  
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
</script>
<%
String sql = "";
int rowcnt=0;
String DELIVERY_YEAR= request.getParameter("DELIVERY_YEAR");
if (DELIVERY_YEAR==null || DELIVERY_YEAR.equals("--")) DELIVERY_YEAR="";
String SHIP_FROM = request.getParameter("SHIP_FROM");
if (SHIP_FROM==null || SHIP_FROM.equals("--")) SHIP_FROM="";
String SALES_REGION = request.getParameter("SALES_REGION");
if (SALES_REGION==null || SALES_REGION.equals("--"))
{
	if (UserRoles.indexOf("Delivery_Schedule_CS")>0)
	{
		sql = " select alname from oraddman.tssales_area a where a.sales_area_no='"+userActCenterNo+"'";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if (rs.next())
		{
			SALES_REGION=rs.getString(1);
		}
		rs.close();
		statement.close();		
	}
	else
	{
		SALES_REGION="";
	}
}
String SHIPPING_METHOD =request.getParameter("SHIPPING_METHOD");
if (SHIPPING_METHOD==null || SHIPPING_METHOD.equals("--")) SHIPPING_METHOD="";
String delivery_schedule_id = request.getParameter("DELIVERY_ID");
if (delivery_schedule_id==null) delivery_schedule_id="";
String ATYPE =request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";

if (ATYPE.equals("DELETE"))
{
	try
	{
		sql = " delete  oraddman.tsc_delivery_schedule_header where DELIVERY_SCHEDULE_ID=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,delivery_schedule_id); 
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		sql = " delete  oraddman.tsc_delivery_schedule_lines where DELIVERY_SCHEDULE_ID=?";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,delivery_schedule_id); 
		pstmtDt.executeQuery();
		pstmtDt.close();
				
		con.commit();
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("刪除動作失敗!!(錯誤原因:"+e.getMessage()+")");
	}	
}
%>
<body> 
<FORM ACTION="../jsp/TSCDeliveryScheduleQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px"><strong><font style="font-size:20px;color:#006666">TSC Delivery Schedule Query </font></strong></div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='1' bgcolor="#E2EBBE" bordercolor="#cccccc">
	<tr>
		<td width="9%" align="right">Year：</td>
		<td width="13%">
		<%
		try
		{
			sql = " select distinct DELIVERY_YEAR,DELIVERY_YEAR from oraddman.tsc_delivery_schedule_header order by 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(DELIVERY_YEAR);
			comboBoxBean.setFieldName("DELIVERY_YEAR");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>		
		</td>
		<td width="7%" align="right"><span style="font-family:Tahoma,Georgia;font-size:12px;">Ship From</span>：</td>
		<td width="16%">
		<%
		try
		{
			sql = " select distinct SHIP_FROM,SHIP_FROM from oraddman.tsc_delivery_schedule_header order by 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SHIP_FROM);
			comboBoxBean.setFieldName("SHIP_FROM");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
		<td width="7%" align="right"><span style="font-family:Tahoma,Georgia;font-size:12px;">Sales Region：</span></td> 
		<td width="11%">
		<%
		try
		{
			if (UserRoles.indexOf("Delivery_Schedule_CS")>0)
			{
				sql = " select a.ALNAME,a.ALNAME from ORADDMAN.TSSALES_AREA a "+
					  " where a.SALES_AREA_NO > 0"+
					  " and exists (select 1 from oraddman.tsrecperson b"+
			          " where b.USERNAME='"+UserName+"'"+
					  " and b.TSSALEAREANO=a.SALES_AREA_NO)";
				Statement statement=con.createStatement();	  
				ResultSet rs=statement.executeQuery(sql);						  
				out.println("<select NAME='SALES_REGION' style='font-family:Tahoma,Georgia;font-size:11px'>");				  			  
				while (rs.next())
				{            
					if (rs.getString(1).equals(SALES_REGION)) 
					{		   					   
						out.println("<OPTION VALUE='"+rs.getString(1)+"' SELECTED>"+rs.getString(2)); 					                                
					} 
					else 
					{
						out.println("<OPTION VALUE='"+rs.getString(1)+"'>"+rs.getString(2));
					}        
				 } 
				 out.println("</select>"); 
				 rs.close();   
				 statement.close(); 					  
			}
			else
			{
				sql = " select distinct SALES_REGION,SALES_REGION from oraddman.tsc_delivery_schedule_header where SALES_REGION is not null order by 1";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				comboBoxBean.setRs(rs);
				comboBoxBean.setSelection(SALES_REGION);
				comboBoxBean.setFieldName("SALES_REGION");	
				comboBoxBean.setFontName("Tahoma,Georgia");   
				out.println(comboBoxBean.getRsString());
				rs.close();   
				statement.close();     	 		
			}
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
		<td width="7%"align="right"><span style="font-family:Tahoma,Georgia;font-size:12px;">Shipping Method：</span></td>
		<td width="13%">
		<%
		try
		{
			sql = " select distinct SHIPPING_METHOD,SHIPPING_METHOD from oraddman.tsc_delivery_schedule_header where SHIPPING_METHOD is not null order by 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SHIPPING_METHOD);
			comboBoxBean.setFieldName("SHIPPING_METHOD");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>	
		</td>		
	</tr>
	<tr>
		<td colspan="8" align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSCDeliveryScheduleQuery.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnAdd" value="Add"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setSubmit('../jsp/TSCDeliveryScheduleUpdate.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSCDeliveryScheduleExcel.jsp')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();
	
	sql = " SELECT X.DELIVERY_SCHEDULE_ID"+
	      ",X.delivery_year"+
		  ",X.ship_from"+
          ",X.sales_region"+
		  ",X.shipping_method"+
		  ",listagg(JAN_MON,',' ) within group (order by JAN_MON) JAN_MON"+
          ",listagg(FEB_MON,',' ) within group (order by FEB_MON) FEB_MON"+
          ",listagg(MAR_MON,',' ) within group (order by MAR_MON) MAR_MON"+
          ",listagg(APR_MON,',' ) within group (order by APR_MON) APR_MON"+
          ",listagg(MAY_MON,',' ) within group (order by MAY_MON) MAY_MON"+
          ",listagg(JUN_MON,',' ) within group (order by JUN_MON) JUN_MON"+
          ",listagg(JUL_MON,',' ) within group (order by JUL_MON) JUL_MON"+
          ",listagg(AUG_MON,',' ) within group (order by AUG_MON) AUG_MON"+
          ",listagg(SEP_MON,',' ) within group (order by SEP_MON) SEP_MON"+
          ",listagg(OCT_MON,',' ) within group (order by OCT_MON) OCT_MON"+
          ",listagg(NOV_MON,',' ) within group (order by NOV_MON) NOV_MON"+
          ",listagg(DEC_MON,',' ) within group (order by DEC_MON) DEC_MON"+
		  ",TO_CHAR(LAST_UPDATE_DATE,'yyyy-mm-dd') LAST_UPDATE_DATE"+
		  ",LAST_UPDATED_BY"+
          " FROM oraddman.tsc_delivery_schedule_header X, (select B.DELIVERY_SCHEDULE_ID,"+
          " case when b.MONTH_OF_YEAR ='JAN_MON' then DAY_OF_MONTH else '' end as JAN_MON,"+
          " case when b.MONTH_OF_YEAR ='FEB_MON' then DAY_OF_MONTH else '' end as FEB_MON,"+
          " case when b.MONTH_OF_YEAR ='MAR_MON' then DAY_OF_MONTH else '' end as MAR_MON,"+
          " case when b.MONTH_OF_YEAR ='APR_MON' then DAY_OF_MONTH else '' end as APR_MON,"+
          " case when b.MONTH_OF_YEAR ='MAY_MON' then DAY_OF_MONTH else '' end as MAY_MON,"+
          " case when b.MONTH_OF_YEAR ='JUN_MON' then DAY_OF_MONTH else '' end as JUN_MON,"+
          " case when b.MONTH_OF_YEAR ='JUL_MON' then DAY_OF_MONTH else '' end as JUL_MON,"+
          " case when b.MONTH_OF_YEAR ='AUG_MON' then DAY_OF_MONTH else '' end as AUG_MON,"+
          " case when b.MONTH_OF_YEAR ='SEP_MON' then DAY_OF_MONTH else '' end as SEP_MON,"+
          " case when b.MONTH_OF_YEAR ='OCT_MON' then DAY_OF_MONTH else '' end as OCT_MON,"+
          " case when b.MONTH_OF_YEAR ='NOV_MON' then DAY_OF_MONTH else '' end as NOV_MON,"+
          " case when b.MONTH_OF_YEAR ='DEC_MON' then DAY_OF_MONTH else '' end as DEC_MON"+
          " from (select DELIVERY_SCHEDULE_ID,upper(to_char(DELIVERY_SCHEDULE_DATE,'MON'))||'_MON' month_of_year, listagg(to_char(DELIVERY_SCHEDULE_DATE,'DD'),',' ) within group (order by DELIVERY_SCHEDULE_DATE) DAY_OF_MONTH from  oraddman.tsc_delivery_schedule_lines "+
          " group by to_char(DELIVERY_SCHEDULE_DATE,'MON'),DELIVERY_SCHEDULE_ID "+
          " order by DELIVERY_SCHEDULE_ID ) b"+
          " ORDER BY DELIVERY_SCHEDULE_ID, 2,3,4,5,6,7,8,9,10,11,12,13) Y "+
          " WHERE X.DELIVERY_SCHEDULE_ID=Y.DELIVERY_SCHEDULE_ID";
	if (!DELIVERY_YEAR.equals("")) sql += " and DELIVERY_YEAR='"+DELIVERY_YEAR+"'";
	if (!SHIP_FROM.equals("")) sql += "  and SHIP_FROM ='"+SHIP_FROM+"'";
	if (!SALES_REGION.equals("")) sql += " and SALES_REGION ='" + SALES_REGION+"'";
	if (!SHIPPING_METHOD.equals("")) sql += " and SHIPPING_METHOD='"+ SHIPPING_METHOD+"'";
    sql += " GROUP BY X.DELIVERY_SCHEDULE_ID,X.delivery_year , X.DELIVERY_SCHEDULE_ID,X.ship_from,"+
          " X.sales_region, X.shipping_method,x.LAST_UPDATE_DATE,x.LAST_UPDATED_BY"+
		  " order by abs(X.delivery_year-to_number(to_char(sysdate,'yyyy'))), X.delivery_year desc, X.ship_from,X.sales_region,X.shipping_method";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0" bordercolor="#E9F8F2">
	<tr style="background-color:#E9F8F2;color:#000000">
		<td width="5%">&nbsp;</td>
		<td width="4%" align="center">Year </td>
		<td width="4%" align="center">Ship From</td>
		<td width="6%" align="center">Sales Region</td>
		<td width="7%" align="center">Shipping Method</td>
		<td width="5%" align="center">JAN</td>
		<td width="5%" align="center">FEB</td>	
		<td width="5%" align="center">Mar</td>	
		<td width="5%" align="center">Apr</td>	
		<td width="5%" align="center">May</td>	
		<td width="5%" align="center">Jun</td>	
		<td width="5%" align="center">Jul </td>
		<td width="5%" align="center">Aug</td>
		<td width="5%" align="center">Sep</td>
		<td width="5%" align="center">Oct</td>	
		<td width="5%" align="center">Nov</td>
		<td width="5%" align="center">Dec</td>
		<td width="7%" align="center">Last Updated By</td>
		<td width="7%" align="center">Last Update Date</td>
	</tr>
		<%
		}
		rowcnt++;
		%>
	<tr onMouseOver="this.style.color='#ffffff';this.style.backgroundColor='#91819A';" onMouseOut="style.backgroundColor='#ffffff',style.color='#000000';this.style.fontWeight='normal'">
		<td align="center"><img border="0" src="images/updateicon_enabled.gif" height="18" title="Modify Record" onClick="setSubmit('../JSP/TSCDeliveryScheduleUpdate.jsp?ATYPE=UPDATE&DELIVERY_ID=<%=rs.getString("delivery_schedule_id")%>')">&nbsp;&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="Delete Record" onClick="setDelete('../jsp/TSCDeliveryScheduleQuery.jsp?DELIVERY_ID=<%=rs.getString("delivery_schedule_id")%>&ATYPE=DELETE')"></td>
		<td align="center"><%=rs.getString("DELIVERY_YEAR")%></td>
		<td align="center"><%=rs.getString("SHIP_FROM")%></td>
		<td align="center"><%=(rs.getString("SALES_REGION")==null?"&nbsp;":rs.getString("SALES_REGION"))%></td>
		<td align="center"><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></td>
		<td><%=(rs.getString("JAN_MON")==null?"&nbsp;":rs.getString("JAN_MON"))%></td>
		<td><%=(rs.getString("FEB_MON")==null?"&nbsp;":rs.getString("FEB_MON"))%></td>
		<td><%=(rs.getString("MAR_MON")==null?"&nbsp;":rs.getString("MAR_MON"))%></td>
		<td><%=(rs.getString("APR_MON")==null?"&nbsp;":rs.getString("APR_MON"))%></td>
		<td><%=(rs.getString("MAY_MON")==null?"&nbsp;":rs.getString("MAY_MON"))%></td>
		<td><%=(rs.getString("JUN_MON")==null?"&nbsp;":rs.getString("JUN_MON"))%></td>
		<td><%=(rs.getString("JUL_MON")==null?"&nbsp;":rs.getString("JUL_MON"))%></td>
		<td><%=(rs.getString("AUG_MON")==null?"&nbsp;":rs.getString("AUG_MON"))%></td>
		<td><%=(rs.getString("SEP_MON")==null?"&nbsp;":rs.getString("SEP_MON"))%></td>
		<td><%=(rs.getString("OCT_MON")==null?"&nbsp;":rs.getString("OCT_MON"))%></td>
		<td><%=(rs.getString("NOV_MON")==null?"&nbsp;":rs.getString("NOV_MON"))%></td>
		<td><%=(rs.getString("DEC_MON")==null?"&nbsp;":rs.getString("DEC_MON"))%></td>
		<td align="center"><%=(rs.getString("LAST_UPDATED_BY")==null?"&nbsp;":rs.getString("LAST_UPDATED_BY"))%></td>
		<td align="center"><%=(rs.getString("LAST_UPDATE_DATE")==null?"&nbsp;":rs.getString("LAST_UPDATE_DATE"))%></td>
	</tr>
		<%
	}
	rs.close();
	statement.close();

	if (rowcnt <=0) 
	{
		out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
	}
	else
	{
	%>
  </table>
	<%
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception:"+e.getMessage()+"</font></div>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

