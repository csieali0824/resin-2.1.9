<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setAdd(URL)
{    
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);	
}
function setDelete(URL)
{  
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setUpdate(URL)
{
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>Sales Region Default Shipping Method Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String SALES_REGION = request.getParameter("SALES_REGION");
if (SALES_REGION==null) SALES_REGION="--";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null || ITEM_DESC.equals("null")) ITEM_DESC="";
String ACTYPE = request.getParameter("ACTYPE");
if (ACTYPE==null) ACTYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String sql ="",stock_color="",subtable="";

if (ACTYPE.equals("DELETE"))
{
	try
	{
		sql = " delete oraddman.tsce_air_sea_freight_rule a"+
		      " where a.tsc_package=?"+
			  " and a.tsc_family=?"+
			  " and nvl(a.tsc_product_name,'xx')=nvl(?,'xx')"+
			  " and a.sales_area_no=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,TSC_PACKAGE); 
		pstmtDt.setString(2,TSC_FAMILY); 
		pstmtDt.setString(3,ITEM_DESC); 
		pstmtDt.setString(4,SALES_REGION); 
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

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSSalesShippingMethodQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">業務區出貨方式查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='1' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1' bordercolor="#cccccc">
     <tr>
		<td width="6%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">業務區:</td>   
		<td width="10%">
		<%
		try
		{
			sql = " SELECT  distinct ta.sales_area_no,ta.sales_area_no || ta.sales_area_name sales_name"+
                  " FROM oraddman.tssales_area ta,oraddman.tsrecperson tp,oraddman.wsuser ws,oraddman.tsce_air_sea_freight_rule tasfr"+
                  " where ta.sales_area_no=tp.tssaleareano "+
                  " and tp.username=ws.username"+
				  " and ta.sales_area_no=tasfr.sales_area_no";
			if (UserRoles.indexOf("admin")<0)
			{				  
				sql += " and ws.username='"+UserName+"'";
			}
			sql += " order by 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SALES_REGION);
			comboBoxBean.setFieldName("SALES_REGION");	
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setFontSize(12);   
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
		<td width="6%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">TSC Family:</td>   
		<td width="10%">
		<%
		try
		{
			sql = " select distinct tasfr.tsc_family ,tasfr.tsc_family from oraddman.tsce_air_sea_freight_rule tasfr"+
                  " where exists (select 1 from oraddman.tsrecperson tp,oraddman.wsuser ws "+
                  " where tp.username=ws.username";
			if (UserRoles.indexOf("admin")<0)
			{				  
				sql += " and ws.username='"+UserName+"'";
			}				  
            sql +=" and tp.tssaleareano=tasfr.sales_area_no)"+
                  " ORDER BY 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_FAMILY);
			comboBoxBean.setFieldName("TSC_FAMILY");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(12);   
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
	    <td width="7%" bgcolor="#D3E6F3" style="font-size:12px;font-weight:bold;color:#006666">TSC Package:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " select distinct tasfr.tsc_package ,tasfr.tsc_package from oraddman.tsce_air_sea_freight_rule tasfr"+
                  " where exists (select 1 from oraddman.tsrecperson tp,oraddman.wsuser ws "+
                  " where tp.username=ws.username";
			if (UserRoles.indexOf("admin")<0)
			{				  
				sql += " and ws.username='"+UserName+"'";
			}				  
            sql +=" and tp.tssaleareano=tasfr.sales_area_no)"+
                  " ORDER BY 1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PACKAGE);
			comboBoxBean.setFieldName("TSC_PACKAGE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			comboBoxBean.setFontSize(12);   
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
	    <td width="5%" bgcolor="#D3E6F3" style="font-size:12px;font-weight:bold;color:#006666">型號:</td> 
		<td width="8%"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia; font-size:12px" size="15" onChange="setChange();"></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr><td height="10">&nbsp;</td></tr>
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSalesShippingMethodQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSSalesShippingMethodAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='Download to Excel'  style="font-family:ARIAL" onClick='setSubmit("../jsp/TSSalesShippingMethodExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT '('||a.sales_area_no||')'||b.sales_area_name sales_name, a.sales_area_no,a.tsc_package, a.tsc_family, a.tsc_product_name, a.freight, a.sdays, a.edays,"+
          " to_char(a.last_update_date,'yyyy/mm/dd') last_update_date,a.last_updated_by,"+
          " row_number() over (partition by a.sales_area_no,a.tsc_package, a.tsc_family, nvl(a.tsc_product_name,'xx') order by a.sdays) row_seq,"+
          " count(FREIGHT) over (partition by a.sales_area_no,a.tsc_package, a.tsc_family, nvl(a.tsc_product_name,'xx')) row_cnt"+
          " FROM oraddman.tsce_air_sea_freight_rule a,oraddman.tssales_area b"+
          " where a.sales_area_no=b.sales_area_no";
	if (!SALES_REGION.equals("") && !SALES_REGION.equals("--"))
	{
	 	sql += " and a.sales_area_no='"+SALES_REGION+"'";
	}
	else if (UserRoles.indexOf("admin")<0)
	{				  
		sql += " and exists (select 1 from oraddman.tsrecperson tp,oraddman.wsuser ws"+
               " where tp.username=ws.username"+
			   " and ws.username='"+UserName+"'"+
			   " and tp.tssaleareano=a.sales_area_no) ";
	}
	if (!TSC_FAMILY.equals("") && !TSC_FAMILY.equals("--"))
	{
		sql += " and a.tsc_family ='"+ TSC_FAMILY+"'";
	}
	if (!TSC_PACKAGE.equals("") && !TSC_PACKAGE.equals("--"))
	{
		sql += " and a.tsc_package = '" + TSC_PACKAGE+"'";
	}
	if (!ITEM_DESC.equals(""))
	{
		sql += " and '"+  ITEM_DESC+"' like tsc_product_name||'%'";
	}
    sql += " order by a.sales_area_no,a.tsc_package, a.tsc_family,a.sdays";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (iCnt ==0)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671" bordercolor="#cccccc">
			<tr bgcolor="#D3E6F3"> 
				<td width="4%" height="22">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="10%" style="font-size:12px;color:#006666" align="center">業務區</td>
				<td width="8%" style="font-size:12px;color:#006666" align="center">TSC Family</td>
				<td width="9%" style="font-size:12px;color:#006666" align="center">TSC Package</td>            
				<td width="15%" style="font-size:12px;color:#006666" align="center">型號</td>            
				<td width="30%" style="font-size:12px;color:#006666" align="center">明細</td>            
			</tr>
		<% 
		}
		if (rs.getInt("ROW_SEQ")==1)
		{
			iCnt++;
    	%>
		<tr>
			<tr  id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSSalesShippingMethodAdd.jsp?STATUS=UPD&SALES_REGION=<%=rs.getString("sales_area_no")%>&TSC_FAMILY=<%=rs.getString("TSC_FAMILY")%>&TSC_PACKAGE=<%=rs.getString("TSC_PACKAGE")%>&ITEM_DESC=<%=rs.getString("tsc_product_name")%>')">&nbsp;&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="刪除資料" onClick="setDelete('../jsp/TSSalesShippingMethodQuery.jsp?SALES_REGION=<%=rs.getString("sales_area_no")%>&TSC_FAMILY=<%=rs.getString("TSC_FAMILY")%>&TSC_PACKAGE=<%=rs.getString("TSC_PACKAGE")%>&ITEM_DESC=<%=rs.getString("tsc_product_name")%>&ACTYPE=DELETE')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("sales_name")%></td>
			<td><%=rs.getString("tsc_family")%></td>
			<td><%=rs.getString("tsc_package")%></td>
			<td><%=(rs.getString("tsc_product_name")==null?"&nbsp;":rs.getString("tsc_product_name"))%></td>
		<%
			subtable="<table width='100%' border='1' cellpadding='1' cellspacing='1' bordercolor='#669966'><tr  style='color:#ffffff;background-color:#669966'><td>Shipping Method</td><td>Start Days</td><td>End Days</td><td>Creation Date</td><td>Created by</td></tr>";
		}
		subtable+= "<tr><td>"+rs.getString("FREIGHT")+"</td><td>"+rs.getString("SDAYS")+"</td><td>"+rs.getString("EDAYS")+"</td><td>"+rs.getString("LAST_UPDATE_DATE")+"</td><td>"+rs.getString("LAST_UPDATED_BY")+"</td></tr>";
		if (rs.getInt("ROW_SEQ")==rs.getInt("ROW_CNT"))
		{
			subtable+="</table>";	
		%>
			<td><%=subtable%></td>
		</tr>
		<%
		}
		%>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

