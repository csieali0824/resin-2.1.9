<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 10px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 10px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 10px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 10px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TSCH Order Revise for Query</title>
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

</script>
<%
String sql = "",request_no="";
String TEMP_ID=request.getParameter("TEMP_ID");
if (TEMP_ID ==null) TEMP_ID="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null || SDATE.equals("")) 
{
	dateBean.setAdjDate(-3);
	SDATE=dateBean.getYearMonthDay();
	dateBean.setAdjDate(3);
}
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String TSCH_MO=request.getParameter("TSCH_MO");
if (TSCH_MO==null) TSCH_MO="";
String TSC_MO=request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String queryCount = request.getParameter("queryCount");
if (queryCount==null) queryCount="0";
queryCount = ""+(Integer.parseInt(queryCount)+1);
String CREATEDBY=request.getParameter("CREATEDBY");
if (CREATEDBY==null) CREATEDBY="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String CUST_PARTNO = request.getParameter("CUST_PARTNO");
if (CUST_PARTNO==null) CUST_PARTNO="";
String CUSTOMER_PO = request.getParameter("CUSTOMER_PO");
if (CUSTOMER_PO==null) CUSTOMER_PO="";
String strBackColor="",seq_id="",temp_id="";
int rowcnt=0,tsc_org_cnt =0;

%>
<body> 
<FORM ACTION="../jsp/TSCHSalesOrderReviseQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">TSCH  Order Revise for Query</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
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
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border="1" bordercolorlight="#426193" bordercolordark="#ffffff" cellPadding="1" cellspacing="0"  bgcolor="#CEEAD7">
	<tr>
		<td width="7%" align="right">Customer：</td>
		<td width="16%"><input type="text" name="CUST" value="<%=CUST%>" style="font-family:Tahoma,Georgia;font-size:11px" size="30"></td>
		<td width="7%" align="right">TSCH MO#：</td> 
		<td width="11%"><input type="text" name="TSCH_MO" value="<%=TSCH_MO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td style="font-size:11px" align="right">TSC MO#：</td>
		<td><INPUT TYPE="TEXT" NAME="TSC_MO" VALUE="<%=TSC_MO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="7%"align="right">Request No：</td>
		<td width="13%"><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>		
		<td width="7%"align="right">Requested By：</td>
		<td width="11%">		
		<%
		try
		{   
			sql = "SELECT DISTINCT CREATED_BY,CREATED_BY CREATED_BY1 FROM oraddman.tsc_om_salesorderrevise_tsch a";
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CREATEDBY);
			comboBoxBean.setFieldName("CREATEDBY");	 
			comboBoxBean.setOnChangeJS("");
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>	
		</td>
	</tr>
	<tr>
		<td align="right">Request Date：</td>
		<td><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right"><span style="font-size:11px">TSC Part No：</span></td> 
		<td><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" style="font-family:Tahoma,Georgia;font-size:11px" size="22"></td>
		<td style="font-size:11px" align="right">Cust Part No：</td>
		<td><INPUT TYPE="TEXT" NAME="CUST_PARTNO" VALUE="<%=CUST_PARTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td style="font-size:11px" align="right">Customer PO：</td>
		<td><INPUT TYPE="TEXT" NAME="CUSTOMER_PO" VALUE="<%=CUSTOMER_PO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td align="right">Status：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT STATUS,STATUS STATUS1 FROM oraddman.tsc_om_salesorderrevise_tsch";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(STATUS);
			comboBoxBean.setFieldName("STATUS");	
			comboBoxBean.setOnChangeJS("");   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSCHSalesOrderReviseQuery.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSCHSalesOrderReviseExcel.jsp?RTYPE=QUERY')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{
	sql = " select a.REQUEST_NO"+
	      ",a.TEMP_ID"+
		  ",a.SEQ_ID"+
		  ",a.SO_NO"+
		  ",a.LINE_NO"+
		  ",c.customer_number"+
		  ",nvl(c.CUSTOMER_NAME_PHONETIC,c.customer_name) customer_name"+
          ",a.SOURCE_ITEM_DESC"+
		  ",a.SOURCE_CUST_ITEM_NAME"+
		  ",a.SOURCE_CUSTOMER_PO"+
		  ",a.SOURCE_SO_QTY"+
		  ",to_char(a.SOURCE_REQUEST_DATE,'yyyymmdd') SOURCE_REQUEST_DATE"+
		  ",to_char(a.SOURCE_SSD,'yyyymmdd') SOURCE_SSD"+
          ",nvl(a.SO_QTY,a.SOURCE_SO_QTY) SO_QTY"+
		  ",to_char(nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD),'yyyymmdd') SCHEDULE_SHIP_DATE"+
		  ",to_char(nvl(a.REQUEST_DATE,a.SOURCE_REQUEST_DATE),'yyyymmdd') REQUEST_DATE"+
		  ",b.REQUEST_NO TSC_REQUEST_NO"+
		  ",b.TEMP_ID TSC_TEMP_ID"+
          ",b.SEQ_ID TSC_SEQ_ID"+
		  ",b.SO_NO TSC_SO_NO"+
		  ",b.LINE_NO TSC_LINE_NO"+
          ",b.SOURCE_ITEM_DESC SOURCE_TSC_ITEM_DESC"+
		  ",B.SOURCE_CUST_ITEM_NAME SOURCE_TSC_CUST_ITEM_NAME"+
          ",b.SOURCE_CUSTOMER_PO SOURCE_TSC_CUSTOMER_PO"+
		  ",b.SOURCE_SO_QTY SOURCE_TSC_SO_QTY"+
		  ",to_char(b.SOURCE_SSD,'yyyymmdd') SOURCE_TSC_SSD"+
          ",nvl(b.SO_QTY,b.SOURCE_SO_QTY) TSC_SO_QTY"+
		  ",to_char(nvl(b.SCHEDULE_SHIP_DATE,b.SOURCE_SSD),'yyyymmdd') TSC_SCHEDULE_SHIP_DATE"+
		  ",a.CREATED_BY"+
		  ",to_char(a.CREATION_DATE,'yyyymmdd') CREATION_DATE"+
		  ",a.STATUS"+
		  ",to_char(b.CREATION_DATE,'yyyymmdd') TSC_CREATION_DATE"+
		  //",row_number() over (partition by a.TEMP_ID,a.SEQ_ID ORDER BY b.seq_id) TSC_ORDER_CNT"+ 
		  ",COUNT(1) OVER (PARTITION BY a.temp_id, a.seq_id) tsc_order_cnt"+
          " from oraddman.tsc_om_salesorderrevise_tsch a"+
		  ",oraddman.tsc_om_salesorderrevise_req b"+
		  ",ar_customers c"+
          " where a.temp_id=b.tsch_temp_id"+
          " and a.seq_id=b.tsch_seq_id"+
          " and a.SOURCE_CUSTOMER_ID=c.customer_id";
	if (!UserRoles.equals("admin") && !UserName.toUpperCase().equals("COCO"))
	{
		sql += " AND EXISTS (SELECT 1 FROM TSC_OM_ORDER_PRIVILEGE X WHERE X.RFQ_USERNAME='"+UserName+"' AND X.CUSTOMER_ID=A.SOURCE_CUSTOMER_ID AND X.ORG_ID=A.ORG_ID)";
	}		  
	if (!CUST.equals(""))
	{
		sql += " and nvl(c.CUSTOMER_NAME_PHONETIC,c.customer_name) like '"+CUST+"%'";
	}
	if (!ITEMDESC.equals(""))
	{
		sql += " and a.SOURCE_ITEM_DESC like '"+ITEMDESC+"%'";
	}
	if (!CUST_PARTNO.equals(""))
	{
		sql += " and a.SOURCE_CUST_ITEM_NAME like '"+CUST_PARTNO+"%'";
	}	
	if (!CUSTOMER_PO.equals(""))
	{
		sql += " and a.SOURCE_CUSTOMER_PO like '"+CUSTOMER_PO+"%'";
	}	
	if (!CREATEDBY.equals("") && !CREATEDBY.equals("--"))
	{
		sql += " and a.CREATED_BY ='"+CREATEDBY+"'";
	}
	if (!TSCH_MO.equals(""))
	{
		sql += " and a.SO_NO LIKE '"+TSCH_MO+"%'";
	}
	if (!TSC_MO.equals(""))
	{
		sql += " and b.SO_NO LIKE '"+TSC_MO+"%'";
	}
	if (!STATUS.equals("") && !STATUS.equals("--"))
	{
		sql += " and a.STATUS = '"+STATUS+"'";
	}	
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!REQUESTNO.equals(""))
	{
		sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
	}
	sql += "  order by a.request_no,a.seq_id";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#CEEAD7;color:#000000">
		<td rowspan="2" width="5%" align="center">Request No </td>
		<td rowspan="2" width="8%" align="center">Customer</td>
		<td width="41%" colspan="9" align="center" style="background-color:#CCCCCC">TSCH</td>
		<td width="41%" colspan="7" align="center" style="background-color:#CCFF99">TSC</td>
		<td rowspan="2" width="5%" align="center">Status</td>	
		<td rowspan="2" width="5%" align="center">Requested by</td>	
		<td rowspan="2" width="5%" align="center">Request Date</td>	
	</tr>
	<tr >
		<td width="6%" align="center" style="background-color:#CCCCCC">MO#</td>	
		<td width="3%" style="background-color:#CCCCCC">Line#</td>
		<td width="5%" style="background-color:#CCCCCC">TSC Part No</td>
		<td width="5%" style="background-color:#CCCCCC">Cust Part No</td>
		<td width="5%" style="background-color:#CCCCCC">Cust PO</td>
		<td width="4%" style="background-color:#CCCCCC">Orig Qty</td>
		<td width="4%" style="background-color:#CCCCCC">New Qty</td>
		<td width="4%" style="background-color:#CCCCCC">Orig CRD </td>
		<td width="4%" style="background-color:#CCCCCC">New CRD </td>
		<td width="6%" align="center" style="background-color:#CCFF99">MO#</td>	
		<td width="3%" style="background-color:#CCFF99">Line#</td>
		<td width="5%" style="background-color:#CCFF99">TSC Part No</td>
		<td width="4%" style="background-color:#CCFF99">Orig Qty</td>
		<td width="4%" style="background-color:#CCFF99">New Qty</td>
		<td width="4%" style="background-color:#CCFF99">Orig SSD</td>
		<td width="4%" style="background-color:#CCFF99">New SSD </td>
	</tr>
		<%
		}
		if (!temp_id.equals(rs.getString("TEMP_ID")) || !seq_id.equals(rs.getString("seq_id")))
		{
			tsc_org_cnt = rs.getInt("tsc_order_cnt");
			temp_id=rs.getString("temp_id");
			seq_id=rs.getString("seq_id");
			rowcnt++;
		%>
	<tr id="tr<%=rowcnt%>" onMouseOver="this.style.backgroundColor='#E6F7F4';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#FFFFFF';style.color='#000000';this.style.fontWeight='normal'">
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("REQUEST_NO")==null?"&nbsp;":rs.getString("REQUEST_NO"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("CUSTOMER_NAME")==null?"&nbsp;":"("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("SO_NO")==null?"&nbsp;":rs.getString("SO_NO"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("LINE_NO")==null?"&nbsp;":rs.getString("LINE_NO"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("SOURCE_ITEM_DESC")==null?"&nbsp;":rs.getString("SOURCE_ITEM_DESC"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("SOURCE_CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("SOURCE_CUST_ITEM_NAME"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=(rs.getString("SOURCE_CUSTOMER_PO")==null?"&nbsp;":rs.getString("SOURCE_CUSTOMER_PO"))%></td>
		<td rowspan="<%=tsc_org_cnt%>" align="right"><%=(rs.getString("SOURCE_SO_QTY")==null?"&nbsp;":rs.getString("SOURCE_SO_QTY"))%></td>
		<td rowspan="<%=tsc_org_cnt%>" align="right" <%=(!rs.getString("SO_QTY").equals(rs.getString("SOURCE_SO_QTY"))?" style='color:#0000ff'":"")%>><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
		<td rowspan="<%=tsc_org_cnt%>" align="center"><%=(rs.getString("SOURCE_REQUEST_DATE")==null?"&nbsp;":rs.getString("SOURCE_REQUEST_DATE"))%></td>
		<td rowspan="<%=tsc_org_cnt%>" align="center" <%=(rs.getString("REQUEST_DATE")!=null && rs.getString("REQUEST_DATE")!=null && !rs.getString("REQUEST_DATE").equals(rs.getString("SOURCE_REQUEST_DATE"))?" style='color:#0000ff'":"")%>><%=(rs.getString("REQUEST_DATE")==null?"&nbsp;":rs.getString("REQUEST_DATE"))%></td>
		<td><a href="../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO=<%=rs.getString("TSC_REQUEST_NO")%>&MONO=<%=rs.getString("TSC_SO_NO")%>&SDATE=<%=rs.getString("TSC_CREATION_DATE")%>"><%=(rs.getString("TSC_SO_NO")==null?"&nbsp;":rs.getString("TSC_SO_NO"))%></a></td>
		<td><%=(rs.getString("TSC_LINE_NO")==null?"&nbsp;":rs.getString("TSC_LINE_NO"))%></td>
		<td><%=(rs.getString("SOURCE_TSC_ITEM_DESC")==null?"&nbsp;":rs.getString("SOURCE_TSC_ITEM_DESC"))%></td>
		<td align="right"><%=(rs.getString("SOURCE_TSC_SO_QTY")==null?"&nbsp;":rs.getString("SOURCE_TSC_SO_QTY"))%></td>
		<td align="right" <%=(!rs.getString("TSC_SO_QTY").equals(rs.getString("SOURCE_TSC_SO_QTY"))?" style='color:#0000ff'":"")%>><%=(rs.getString("TSC_SO_QTY")==null?"&nbsp;":rs.getString("TSC_SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("SOURCE_TSC_SSD")==null?"&nbsp;":rs.getString("SOURCE_TSC_SSD"))%></td>
		<td align="center" <%=(!rs.getString("TSC_SCHEDULE_SHIP_DATE").equals(rs.getString("SOURCE_TSC_SSD"))?" style='color:#0000ff'":"")%>><%=(rs.getString("TSC_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("TSC_SCHEDULE_SHIP_DATE"))%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=rs.getString("status")%></td>
		<td rowspan="<%=tsc_org_cnt%>"><%=rs.getString("CREATED_BY")%></td>
		<td rowspan="<%=tsc_org_cnt%>" align="center"><%=rs.getString("CREATION_DATE")%></td>
	</tr>
	<%
		}
		else
		{
	%>
	<tr id="tr<%=rowcnt%>" onMouseOver="this.style.backgroundColor='#E6F7F4';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#FFFFFF';style.color='#000000';this.style.fontWeight='normal'">
		<td><a href="../jsp/TSSalesOrderReviseQuery.jsp?REQUESTNO=<%=rs.getString("TSC_REQUEST_NO")%>&MONO=<%=rs.getString("TSC_SO_NO")%>&SDATE=<%=rs.getString("TSC_CREATION_DATE")%>"><%=(rs.getString("TSC_SO_NO")==null?"&nbsp;":rs.getString("TSC_SO_NO"))%></a></td>
		<td><%=(rs.getString("TSC_LINE_NO")==null?"&nbsp;":rs.getString("TSC_LINE_NO"))%></td>
		<td><%=(rs.getString("SOURCE_TSC_ITEM_DESC")==null?"&nbsp;":rs.getString("SOURCE_TSC_ITEM_DESC"))%></td>
		<td align="right"><%=(rs.getString("SOURCE_TSC_SO_QTY")==null?"&nbsp;":rs.getString("SOURCE_TSC_SO_QTY"))%></td>
		<td align="right" <%=(!rs.getString("TSC_SO_QTY").equals(rs.getString("SOURCE_TSC_SO_QTY"))?" style='color:#0000ff'":"")%>><%=(rs.getString("TSC_SO_QTY")==null?"&nbsp;":rs.getString("TSC_SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("SOURCE_TSC_SSD")==null?"&nbsp;":rs.getString("SOURCE_TSC_SSD"))%></td>
		<td align="center" <%=(!rs.getString("TSC_SCHEDULE_SHIP_DATE").equals(rs.getString("SOURCE_TSC_SSD"))?" style='color:#0000ff'":"")%>><%=(rs.getString("TSC_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("TSC_SCHEDULE_SHIP_DATE"))%></td>
	</tr>
	<%
		}
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
<input type="hidden" name="queryCount" value="<%=queryCount%>">
<input type="hidden" name="TEMP_ID" VALUE="<%=TEMP_ID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

