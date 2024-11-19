<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Request for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean1" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setUpload()
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSW02OrderReviseUpload.jsp","subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit(URL)
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.save1.disabled= true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setClose()
{
	if (confirm("Are you sure to exit this function?"))
	{
		location.href="/oradds/ORADDSMainMenu.jsp";
	}
}

// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
} 
</script>
<%
String sql = "";
String ATYPE = request.getParameter("ActionType");
if (ATYPE==null) ATYPE="";
String REQNO = request.getParameter("REQNO");
if (REQNO==null) REQNO="";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String strBackGround="color:#ff0000;";
int i=0;
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();


%>
<body> 
<FORM ACTION="../jsp/TSW02OrderReviseRequest.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">1181 Order Revise</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE border="0" width="100%" bgcolor="#CAD9DB">
	<tr>
		<td width="10%" style="font-size:12px" align="right">Created By：</td>
		<td width="30%"><%=UserName%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">Request Date：</td>
		<td><%=dateBean.getYearMonthDay()%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>		
	</tr>
	<tr>
		<td style="font-size:12px" align="right">Sample File：</td>
		<td><A HREF="../jsp/samplefiles/N1-001_SampleFile.xls">Download Sample File</A></td>
		<td><input type="button" name="btnUpload" value="Excel Upload"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload()">
		</td>
		<td align="right">&nbsp;</td>
	</tr>
	
</TABLE>
<hr>
<%
	
try
{
	if (ATYPE.equals("UPLOAD") && !REQNO.equals("") && REQNO != null)
	{
		sql = " select a.request_no"+
		      ", a.seq_id"+
			  ", a.sales_group"+
			  ", a.org_id"+
			  ", a.so_no"+
			  ", a.line_no"+
			  ", a.so_header_id"+
			  ", a.so_line_id"+
              ", a.source_item_desc"+
              ", a.source_cust_item_name"+
			  ", a.source_customer_po"+
              ", a.source_shipping_method"+
			  ", a.source_so_qty"+
			  ", to_char(a.source_ssd,'yyyy/mm/dd') source_ssd"+
			  ", to_char(a.source_request_date,'yyyy/mm/dd') source_request_date"+
              ", a.item_name"+
			  ", a.item_desc"+
			  ", a.shipping_method"+
			  ", a.so_qty"+
			  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date "+
              ", a.source_so_qty-sum(a.so_qty) over (partition by a.so_line_id) as cancel_qty"+
			  ", a.customer_dock_code"+ //add by Peggy 20220805
			  ", to_char(a.request_date,'yyyymmdd') request_date"+ //add by Peggy 20230113
              " from oraddman.tsc_om_salesorderrevise_w02 a"+
			  " where a.request_no=?"+
			  " order by a.so_no,a.line_no";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,REQNO);
		ResultSet rs=statement.executeQuery();			  
		while (rs.next())
		{
			if (i ==0)
			{
		%>
<table width="100%">
	<tr>
		<td style="font-size:11px;color:#000000;font-family:Tahoma,Georgia">Notice:No change field please keep blank.</td>
		<td style="font-size:11px;color:#000000;font-family:Tahoma,Georgia">&nbsp;</td>
	</tr>
</table>
<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
	<tr style="background-color:#705B80;color:#FFFFFF;">
		<td width="3%" align="center">&nbsp;</td>
		<td width="10%" align="center">MO#</td>
		<td width="4%" align="center">Line#</td>	
		<td width="13%" align="center">Item Desc </td>	
		<td width="11%" align="center">Customer PO</td>	
		<td width="6%" align="center">Source Qty</td>	
		<td width="6%" align="center">Source CRD</td>
		<td width="6%" align="center">Source SSD</td>	
		<td width="6%" align="center">Remarks</td>	
		<td width="6%" align="center" style="background-color:#5E82AA;">Order Qty(K)</td>
		<td width="7%" align="center" style="background-color:#5E82AA;">CRD</td>		
		<td width="7%" align="center" style="background-color:#5E82AA;">SSD pull in/out</td>
		<td width="7%" align="center" style="background-color:#5E82AA;">Customer Dock</td>

	</tr>
	<%
			}
			i ++;
	%>
	<tr id="tr_<%=i%>">
		<td align="center"><%=i%></td>
		<td align="center"><%=rs.getString("SO_NO")%><input type="hidden" name="SEQ_ID_<%=i%>" value="<%=rs.getString("seq_id")%>"></td>
		<td align="center"><div id="line_<%=i%>"><%=(rs.getString("LINE_NO")==null?"":rs.getString("LINE_NO"))%></div><input type="hidden" name="LINE_ID_<%=i%>" value="<%=(rs.getString("SO_LINE_ID")==null?"":rs.getString("SO_LINE_ID"))%>"></td>
		<td><%=(rs.getString("source_item_desc")==null?"":rs.getString("source_item_desc"))%></td>
		<td><%=(rs.getString("source_customer_po")==null?"":rs.getString("source_customer_po"))%></td>
		<td align="right"><%=(rs.getString("source_so_qty")==null?"":rs.getString("source_so_qty"))%></td>
		<td align="center"><%=(rs.getString("source_request_date")==null?"":rs.getString("source_request_date"))%></td>
		<td align="center"><%=(rs.getString("source_ssd")==null?"":rs.getString("source_ssd"))%></td>
		<td><%=(rs.getInt("cancel_qty")>0?"<font color='#0000ff'>Cancel Qty:"+rs.getFloat("cancel_qty")+"K":"&nbsp;")%></td>
		<td align="center"><input type="TEXT" NAME="CHANGE_QTY_<%=i%>" value="<%=((rs.getString("SO_QTY") != null && !rs.getString("SO_QTY").equals(rs.getString("source_so_qty"))) || (rs.getString("SCHEDULE_SHIP_DATE")!=null && !rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("source_ssd")))?(rs.getString("SO_QTY")==null?"":rs.getString("SO_QTY")):"")%>" style="text-align:right;font-size:11px;font-family:Tahoma,Georgia;<%=(rs.getInt("cancel_qty")>0?"color:#ff0000;font-weight:bold;":"")%>" size="6" readonly></td>
		<td align="center"><input type="TEXT" NAME="CHANGE_CRD_<%=i%>" value="<%=(rs.getString("REQUEST_DATE")==null?"":rs.getString("REQUEST_DATE"))%>" style="text-align:center;font-size:11px;font-family: Tahoma,Georgia;" size="8" readonly></td>						
		<td align="center"><input type="TEXT" NAME="CHANGE_SSD_<%=i%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>" style="text-align:center;font-size:11px;font-family: Tahoma,Georgia;" size="8" readonly></td>						
		<td align="center"><input type="TEXT" NAME="CHANGE_CUST_DOCK_<%=i%>" value="<%=(rs.getString("customer_dock_code")==null?"":rs.getString("customer_dock_code"))%>" style="text-align:center;font-size:11px;font-family: Tahoma,Georgia;" size="8" readonly></td>						
	</tr>	
		<%
		}
		if (i >0)
		{
	%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#CAD9DB">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="Submit" onClick='setSubmit("../jsp/TSW02OrderReviseProcess.jsp?ACODE=SAVE&REQNO=<%=REQNO%>")' style="font-family: Tahoma,Georgia;">
			&nbsp;&nbsp;&nbsp;<input type="button" name="exit1" value="Exit" onClick='setClose()' style="font-family: Tahoma,Georgia;">
		</td>
	</tr>
</table>
<hr>
<%
		}
		rs.close();
		statement.close();
	}
}
catch (Exception e) 
{ 
	out.println("Exception1:"+e.getMessage()+sql); 
} 	
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

