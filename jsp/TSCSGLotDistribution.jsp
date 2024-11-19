<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>
<html>
<head>
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
</STYLE>
<title>SG Distribution Lot </title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="PickBean" scope="session" class="Array2DimensionInputBean"/>
<%
String sql = "";
String SHIPDATE = request.getParameter("SHIPDATE");
if (SHIPDATE==null) SHIPDATE="";
if (!SHIPDATE.equals("")) PickBean.setArray2DString(null); 
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGLotDistribution.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Distribution Lot</font></strong>
<BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="20%"><font color="#666600">出貨日期:</font>
		<input type="text" name="SHIPDATE" value="<%=SHIPDATE%>" style="font-family:Arial;font-size:12px" size="15" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">&nbsp;<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SHIPDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
		&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGLotDistribution.jsp")' ></td>
	</tr>
</table> 
<HR>
<%
try
{
	sql = " select a.* from ( select  distinct a.tew_advise_no advise_no"+
		  ",CASE WHEN b.to_tw='Y' THEN 'TSCT' ELSE a.region_code END AS region_code"+
		  ",b.SHIPPING_METHOD"+
		  ",c.vendor_site_id"+
		  ",c.vendor_site_code"+
		  ",b.to_tw"+
		  ",TO_CHAR(A.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD"+
		  ",row_number() over (partition by a.tew_advise_no order by a.region_code) row_cnt"+
		  ",case b.shipping_from when 'SG1' then '內銷' when 'SG2' THEN '外銷' ELSE b.shipping_from END shipping_from_name"+
		  " from tsc.tsc_shipping_advise_lines a"+
		  ",tsc.tsc_shipping_advise_headers b"+
		  ",ap.ap_supplier_sites_all c"+
		  ",(select advise_header_id,advise_line_id,sum(QTY) qty  from tsc.TSC_PICK_CONFIRM_LINES where ONHAND_ORG_ID in (?,?) group by advise_header_id,advise_line_id) y"+
		  " where  b.SHIPPING_FROM LIKE ?||'%' "+
		  " and b.advise_header_id = a.advise_header_id "+
		  " and a.vendor_site_id = c.vendor_site_id(+)"+
		  " and a.tew_advise_no is not null"+
		  " and a.advise_line_id=y.advise_line_id(+)"+
		  " and a.SHIP_QTY>nvl(y.qty,0)";
		  //" and not exists (select 1 from tsc.TSC_PICK_CONFIRM_LINES y where y.advise_line_id = a.advise_line_id)";
	if (!SHIPDATE.equals("")) sql += " and a.pc_schedule_ship_date=TO_DATE('"+SHIPDATE+"','yyyymmdd') ";
	sql += " ) a where row_cnt =1 order by advise_no ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"907");
	statement.setString(2,"908");
	statement.setString(3,"SG");
	//statement.setString(2,"TEW");
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	while (rs.next())
	{		
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
			<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:12px" align="center">
				<td width="3%" align="center">&nbsp;</td>
				<td width="5%" align="center">&nbsp;</td>
				<td width="10%" align="center">內外銷</td>
				<td width="10%" align="center">Advise No</td>
				<!--<td width="25%" align="center">客戶</td>-->
				<td width="10%" align="center">業務區</td>
				<td width="12%" align="center">出貨方式</td>
				<td width="10%" align="center">排定出貨日</td>
				<!--<td width="10%" align="center">幣別</td>-->
				<td width="5%" align="center">回T</td>
			</tr>
<%		
		}
%>
		<tr>
			<td align="center"><%=(icnt+1)%></td>
			<td><input type="button" name="btn_<%=rs.getString("ADVISE_NO")%>" value="批號分配" onClick="setSubmit1('../jsp/TSCSGLotDistributionDetail.jsp?ADVISENO=<%=rs.getString("ADVISE_NO")%>')"></td>
			<td align="center"><%=rs.getString("shipping_from_name")%></td>
			<td align="center"><%=rs.getString("ADVISE_NO")%></td>
			<td><%=rs.getString("REGION_CODE")%><input type="hidden" name="REGION_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("REGION_CODE")%>"></td>
			<td><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"></td>
			<td align="center"><%=rs.getString("SSD")%><input type="hidden" name="SSD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SSD")%>"></td>
			<td align="center"><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%><input type="hidden" name="TOTW_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("TO_TW")%>"></td>
		</tr>
<%
		icnt++;
	}
	if (icnt >0)
	{
%>
		</table>
<%
	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

