<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Shipping Inspection Report</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setValue()
{
	if (document.MYFORM.INVOICE_NO.value!="" || document.MYFORM.WIP_NO.value!=""|| document.MYFORM.MO_NO.value!="" || document.MYFORM.LOT_NO.value!="")
	{
		document.MYFORM.SHIP_SDATE.value="";
		document.MYFORM.SHIP_EDATE.value="";
	}
}
function setColor(isline,ieline)
{
	var i=0;
	for (i=isline;i<=ieline;i++)
	{	
		document.getElementById("tr_"+i).style.backgroundColor="#FFFF66";
	}
}
</script>
<STYLE TYPE='text/css'> 
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<%
String sql = "";
String SHIP_SDATE=request.getParameter("SHIP_SDATE");
if (SHIP_SDATE==null) SHIP_SDATE="";
String SHIP_EDATE=request.getParameter("SHIP_EDATE");
if (SHIP_EDATE==null) SHIP_EDATE="";
//String WIP_SDATE=request.getParameter("WIP_SDATE");
//if (WIP_SDATE==null) WIP_SDATE="";
//String WIP_EDATE=request.getParameter("WIP_EDATE");
//if (WIP_EDATE==null) WIP_EDATE="";
String SHIPPING_MARKS=request.getParameter("SHIPPING_MARKS");
if (SHIPPING_MARKS==null) SHIPPING_MARKS="";
String MO_NO=request.getParameter("MO_NO");
if (MO_NO==null) MO_NO="";
String WIP_NO=request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String INVOICE_NO=request.getParameter("INVOICE_NO");
if (INVOICE_NO==null) INVOICE_NO="";
String LOT_NO=request.getParameter("LOT_NO");
if (LOT_NO==null) LOT_NO="";
String ITEM_DESC=request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
if (SHIP_SDATE.equals("") && SHIP_EDATE.equals("") && SHIPPING_MARKS.equals("") && MO_NO.equals("") && INVOICE_NO.equals("") && LOT_NO.equals("") && ITEM_DESC.equals(""))
{
	SHIP_SDATE=dateBean.getYearMonthDay();
}
int rowcnt=0,i_group_cnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSShippingInvoiceNumberQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Out-going Quality  Inspection Report</div>
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
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#CFDAC9" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="5%" style="font-size:11px" align="center">出貨日期</td>
		<td width="8%">
			<input type="text" size="5" name="SHIP_SDATE" style="font-family: Tahoma,Georgia;font-size:11px" value="<%=SHIP_SDATE%>"><A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SHIP_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A><BR>
            <input type="text" size="5" name="SHIP_EDATE" style="font-family: Tahoma,Georgia;font-size:11px" value="<%=SHIP_EDATE%>"><A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SHIP_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>		</td>
		<td width="5%" align="center">發票號碼(EW/YEW)</td>
		<td width="10%"><textarea cols="17" rows="4" name="INVOICE_NO"  style="font-family: Tahoma,Georgia;font-size:11px" onChange="setValue();"><%=INVOICE_NO%></textarea></td>
		<td width="5%" align="center">工單號碼</td>
		<td width="10%"><textarea cols="17" rows="4" name="WIP_NO"  style="font-family: Tahoma,Georgia;font-size:11px" onChange="setValue();"><%=WIP_NO%></textarea></td>
		<td width="5%" align="center">訂單號碼</td>
		<td width="10%"><textarea cols="17" rows="4" name="MO_NO"  style="font-family: Tahoma,Georgia;font-size:11px" onChange="setValue();"><%=MO_NO%></textarea></td>
		<td width="4%" align="center">嘜頭</td>
		<td width="10%"><textarea cols="17" rows="4" name="SHIPPING_MARKS"  style="font-family: Tahoma,Georgia;font-size:11px"><%=SHIPPING_MARKS%></textarea></td>
		<td width="4%" align="center">品名</td>
		<td width="10%"><textarea cols="17" rows="4" name="ITEM_DESC"  style="font-family: Tahoma,Georgia;font-size:11px"><%=ITEM_DESC%></textarea></td>
		<td width="4%" align="center">批號</td>
		<td width="10%"><textarea cols="17" rows="4" name="LOT_NO"  style="font-family: Tahoma,Georgia;font-size:11px" onChange="setValue();"><%=LOT_NO%></textarea></td>
	</tr>
	<tr>
	  <td colspan="14" align="center">
		<input type="button" name="btnQuery" value="查詢"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSYEWShippingInspectionQuery.jsp')">
		&nbsp;&nbsp;&nbsp;&nbsp;</td>
	</tr>
</TABLE>
<hr>
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{
	sql = " SELECT YWSR.WMS_DOC_NUM"+
	      ",YWP.ORDER_NUMBER"+
		  ",YWP.ORDER_LINE_ID"+
		  ",YWP.ITEM_NO"+
		  ",YWP.ITEM_DESC"+
		  ",YWP.SHIP_MARK"+
		  ",YWP.CARTON_NO"+
		  ",YWP.TSC_LOT"+
		  ",YWP.QUANTITY"+
		  ",YWP.DATE_CODE"+
		  ",TO_CHAR(OOLA.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') SSD"+
		  ",YWP.CUST_NAME"+
		  ",YWSR.WMS_DOC_NUM||'_'||YWP.ORDER_NUMBER||'_'||OOLA.INVENTORY_ITEM_ID||'_'||YWP.DATE_CODE KID"+
		  ",YRA.WO_NO"+
		  ",TSC_GET_OQC_RPT(YWP.ORDER_LINE_ID,'YEW',null) as QC_RPT_FLAG"+
          ",ROW_NUMBER() OVER (PARTITION BY YWSR.WMS_DOC_NUM,YWP.ORDER_NUMBER,OOLA.INVENTORY_ITEM_ID,YWP.DATE_CODE ORDER BY YWP.TSC_LOT,TO_NUMBER(regexp_replace(YWP.CARTON_NO,'[^0-9]+',''))) ROW_SEQ"+
          ",COUNT(1) OVER (PARTITION BY YWSR.WMS_DOC_NUM,YWP.ORDER_NUMBER,OOLA.INVENTORY_ITEM_ID,YWP.DATE_CODE) ROW_CNT"+
		  //",(SELECT COUNT(1) FROM ORADDMAN.TSYEW_PRODUCT_MARKING TPM WHERE TPM.TSC_PARTNO= CASE WHEN INSTR(TSC_GET_ITEM_DESC_NOPACKING(43 ,OOLA.INVENTORY_ITEM_ID),'/')>0 THEN TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,43,24) ELSE TSC_GET_ITEM_DESC_NOPACKING(43 ,OOLA.INVENTORY_ITEM_ID) END) MARKING_CNT"+
		  //",(SELECT COUNT(1) FROM ORADDMAN.TSYEW_PRODUCT_MARKING TPM WHERE TPM.TSC_PARTNO = TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,43,24) or TPM.TSC_PARTNO =YWP.ITEM_DESC) MARKING_CNT"+
		  //",(SELECT COUNT(1) FROM ORADDMAN.TSYEW_PRODUCT_MARKING TPM WHERE (TPM.TSC_PARTNO = CASE WHEN INSTR(TSC_GET_ITEM_DESC_NOPACKING(43 ,OOLA.INVENTORY_ITEM_ID),'/')>0 THEN TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,43,24) ELSE TSC_GET_ITEM_DESC_NOPACKING(43 ,OOLA.INVENTORY_ITEM_ID) END or TPM.TSC_PARTNO =YWP.ITEM_DESC)) MARKING_CNT"+		  
		  ",(SELECT COUNT(1) FROM ORADDMAN.TSYEW_PRODUCT_MARKING TPM WHERE (TPM.TSC_PARTNO =  TSC_INV_CATEGORY(OOLA.INVENTORY_ITEM_ID,43,24) or TPM.TSC_PARTNO =YWP.ITEM_DESC)) MARKING_CNT"+	//modify by Peggy 20240307	  
          " FROM YEW_WMS_SHIPMMENT_RELS YWSR"+
		  ",YEW_WMS_PACKINGLIST YWP"+
		  ",ONT.OE_ORDER_LINES_ALL OOLA"+
		  ",YEW_RUNCARD_ALL YRA"+
          " WHERE YWSR.WMS_DOC_NUM=YWP.WMS_DOC_NUM"+
          " AND YWSR.OM_LINE_ID=YWP.ORDER_LINE_ID"+
          " AND YWSR.OM_LINE_ID=OOLA.LINE_ID"+
		  " AND YWP.TSC_LOT=YRA.RUNCARD_NO(+)";
	if (!SHIP_SDATE.equals("") || !SHIP_EDATE.equals(""))
	{
    	sql += " AND OOLA.SCHEDULE_SHIP_DATE BETWEEN NVL(TO_DATE('"+SHIP_SDATE+"','YYYYMMDD'),TRUNC(SYSDATE)-7) AND NVL(TO_DATE('"+SHIP_EDATE+"','YYYYMMDD'),TRUNC(SYSDATE))";
	}	
	if (!SHIPPING_MARKS.equals(""))
	{
		String [] sArray = SHIPPING_MARKS.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (YWP.SHIP_MARK like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or YWP.SHIP_MARK like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += ")";
		}	
	}	
	if (!ITEM_DESC.equals(""))
	{
		String [] sArray = ITEM_DESC.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and (YWP.ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			else
			{
				sql += " or YWP.ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	if (!WIP_NO.equals(""))
	{
		String [] sArray = WIP_NO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and YRA.WO_NO IN ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += ",'"+sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	if (!MO_NO.equals(""))
	{
		String [] sArray = MO_NO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and YWP.ORDER_NUMBER IN ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += ",'"+sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}
	if (!INVOICE_NO.equals(""))
	{
		String [] sArray = INVOICE_NO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and YWSR.WMS_DOC_NUM IN ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += ",'"+ sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	if (!LOT_NO.equals(""))
	{
		String [] sArray = LOT_NO.split("\n");
		for (int x =0 ; x < sArray.length ; x++)
		{
			if (x==0)
			{
				sql += " and YWP.TSC_LOT IN ('"+sArray[x].trim()+"'";
			}
			else
			{
				sql += ",'"+sArray[x].trim()+"'";
			}
			if (x==sArray.length -1) sql += ")";
		}
	}	
	sql += " ORDER BY YWSR.WMS_DOC_NUM,YWP.ORDER_NUMBER,OOLA.INVENTORY_ITEM_ID,YWP.DATE_CODE,YWP.TSC_LOT,TO_NUMBER(regexp_replace(YWP.CARTON_NO,'[^0-9]+',''))";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0" style="table-layout:fixed">
	<tr style="background-color:#E9F8F2;color:#000000">
		<td width="3%" align="center">序號</td>
		<td width="8%" align="center">發票號碼</td>
		<td width="8%" align="center">訂單號碼</td>
		<td width="13%" align="center">客戶</td>
		<td width="11%" align="center">嘜頭</td>
		<td width="12%" align="center">品名</td>
		<td width="5%" align="center">箱號</td>
		<td width="5%" align="center">數量</td>
		<td width="8%" align="center">工單</td>
		<td width="8%" align="center">批號</td>
		<td width="7%" align="center">Date Code</td>
		<td width="7%" align="center">出貨日期</td>
		<td width="3%" align="center">Group Seq</td>		
		<td width="4%" align="center">檢驗報告</td>
	</tr>
		<%
		}
		rowcnt++;	
		if (rs.getInt("ROW_SEQ")==1) //add by Peggy 20230927
		{
			i_group_cnt++;
		}	
		%>
	<tr id="tr_<%=rowcnt%>">
		<td align="center"><%=rowcnt%></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divb_<%=rowcnt%>" align="center"><%=(rs.getString("WMS_DOC_NUM")==null?"&nbsp;":rs.getString("WMS_DOC_NUM"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divc_<%=rowcnt%>" align="center"><%=(rs.getString("ORDER_NUMBER")==null?"&nbsp;":rs.getString("ORDER_NUMBER"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divd_<%=rowcnt%>"><%=(rs.getString("CUST_NAME")==null?"&nbsp;":rs.getString("CUST_NAME"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divd_<%=rowcnt%>"><%=(rs.getString("SHIP_MARK")==null?"&nbsp;":rs.getString("SHIP_MARK"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;<%=(rs.getInt("MARKING_CNT")==0?";background-color:#FF0000;color:#ffffff":"")%>"><div id="divf_<%=rowcnt%>"><%=(rs.getString("ITEM_DESC")==null?"&nbsp;":rs.getString("ITEM_DESC"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divg_<%=rowcnt%>"><%=(rs.getString("CARTON_NO")==null?"&nbsp;":rs.getString("CARTON_NO"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divf_<%=rowcnt%>" align="right"><%=(rs.getString("QUANTITY")==null?"&nbsp;":rs.getString("QUANTITY"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divg_<%=rowcnt%>"><%=(rs.getString("WO_NO")==null?"&nbsp;":rs.getString("WO_NO"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divg_<%=rowcnt%>"><%=(rs.getString("TSC_LOT")==null?"&nbsp;":rs.getString("TSC_LOT"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divh_<%=rowcnt%>"><%=(rs.getString("DATE_CODE")==null?"&nbsp;":rs.getString("DATE_CODE"))%></div></td>
		<td style="font-size:11px;word-wrap:break-word;"><div id="divh_<%=rowcnt%>" align="center"><%=(rs.getString("SSD")==null?"&nbsp;":rs.getString("SSD"))%></div></td>
		<%
		if (rs.getInt("ROW_SEQ")==1)
		{
		%>
		<td align="center" rowspan="<%=rs.getString("ROW_CNT")%>"><%=i_group_cnt%></td>
		<td align="center" rowspan="<%=rs.getString("ROW_CNT")%>" <%=(rs.getString("QC_RPT_FLAG").equals("Y")?"style='background-color:#FFFF66'":"")%> onClick="setColor(<%=rowcnt%>,<%=(rowcnt+rs.getInt("ROW_CNT")-1)%>)"><a href="../jsp/TSYEWShippingInspectionReport.jsp?KID=<%=rs.getString("KID")%>"><img name="popcal" border="0" src="../image/excel_16.gif"></a></td>
		<%
		}
		%>
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
