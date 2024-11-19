<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11x }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11x } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
.style4 {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:center}
</STYLE>
<title>A01 OEM WIP Issue</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(0);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
		lineid = document.MYFORM.chk[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#daf1a9";
		if (document.MYFORM.elements["open_qty_"+lineid].value<=eval(document.MYFORM.elements["onhand_qty_"+lineid].value))
		{
			document.MYFORM.elements["issue_qty_"+lineid].value = document.MYFORM.elements["open_qty_"+lineid].value;
		}
		else
		{
			document.MYFORM.elements["issue_qty_"+lineid].value = document.MYFORM.elements["onhand_qty_"+lineid].value;
		}
		document.MYFORM.elements["issue_qty_"+lineid].style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["issue_qty_"+lineid].style.color="#0000FF";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["issue_qty_"+lineid].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["issue_qty_"+lineid].value="";
	}
}
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="";
	if (document.MYFORM.chk.length != undefined)
	{
		chk_len = document.MYFORM.chk.length;
	}
	else
	{
		chk_len = 1;
	}

	for (var i =0 ; i < chk_len ;i++)
	{
		if (chk_len==1)
		{
			chkflag = document.MYFORM.chk.checked; 
			id = document.MYFORM.chk.value;		
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
			id = document.MYFORM.chk[i].value;		
		}
		if (eval(document.MYFORM.elements["issue_qty_"+id].value)==0)
		{
			alert("The issue Qty must be granter than zero!");
			document.MYFORM.elements["issue_qty_"+lineid].focus();
			return false;
		}
		else if (eval(document.MYFORM.elements["issue_qty_"+id].value)>eval(document.MYFORM.elements["open_qty_"+id].value))
		{
			alert("The issue Qty error!");
			document.MYFORM.elements["issue_qty_"+lineid].focus();
			return false;
		}
		else if (eval(document.MYFORM.elements["issue_qty_"+id].value)>eval(document.MYFORM.elements["onhand_qty_"+id].value))
		{
			alert("Inventory shortage!");
			document.MYFORM.elements["issue_qty_"+lineid].focus();
			return false;
		}
		if (chkflag==true) chkcnt ++;
	}
	if (chkcnt ==0)
	{
		alert("Please select process data!");
		return false;
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;	
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
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
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String WIP_TYPE =request.getParameter("WIP_TYPE");
if (WIP_TYPE==null) WIP_TYPE="";
String REQ_SDATE = request.getParameter("REQ_SDATE");
if (REQ_SDATE==null) REQ_SDATE="";
if (ATYPE.equals(""))
{
	//dateBean.setAdjDate(-10);
	//REQ_SDATE = dateBean.getYearMonthDay();
	//dateBean.setAdjDate(10);
	ATYPE="Q";
}
String REQ_EDATE = request.getParameter("REQ_EDATE");
if (REQ_EDATE==null) REQ_EDATE="";
String REQNO_LIST = request.getParameter("REQNO_LIST");
if (REQNO_LIST==null) REQNO_LIST="";
String WIPNO_LIST = request.getParameter("WIPNO_LIST");
if (WIPNO_LIST==null) WIPNO_LIST="";
String LOT_LIST = request.getParameter("LOT_LIST");
if (LOT_LIST==null) LOT_LIST="";
String PONO_LIST = request.getParameter("PONO_LIST");
if (PONO_LIST==null) PONO_LIST="";
String ITEM_LIST = request.getParameter("ITEM_LIST");
if (ITEM_LIST==null) ITEM_LIST="";
int rowcnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSA01OEMWIPIssue.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">A01 Outsourcing WIP Component Issue </div>
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
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#A2BBC6" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="7%" style="font-size:11px" align="right">Vendor：</td>
		<td width="15%" >
		<%
		try
		{   
			sql = " SELECT DISTINCT B.VENDOR_ID,B.VENDOR_NAME FROM ORADDMAN.TSA01_OEM_DATA_TYPE A,AP_SUPPLIERS B WHERE B.VENDOR_ID=A.DATA_SEQ AND A.DATA_TYPE='WIP_TYPE' AND A.STATUS_FLAG='A' ORDER BY B.VENDOR_ID";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(VENDOR);
			comboBoxBean.setFieldName("VENDOR");	 
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
		<td width="6%" style="font-size:11px" align="right" rowspan="3">申請單號：</td>
		<td width="9%" rowspan="3"><textarea cols="16" rows="5" name="REQNO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=REQNO_LIST%></textarea></td>
		<td width="6%" style="font-size:11px" align="right" rowspan="3">工單號碼：</td>
		<td width="9%" rowspan="3"><textarea cols="16" rows="5" name="WIPNO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=WIPNO_LIST%></textarea></td>
		<td width="6%" style="font-size:11px" align="right" rowspan="3">LOT# ：</td>
		<td width="9%" rowspan="3"><textarea cols="16" rows="5" name="LOT_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=LOT_LIST%></textarea></td>
		<td width="6%" style="font-size:11px" align="right" rowspan="3">採購單號：</td>
		<td width="9%" rowspan="3"><textarea cols="16" rows="5" name="PONO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=PONO_LIST%></textarea></td>
		<td width="6%" style="font-size:11px" align="right" rowspan="3">品名：</td>
		<td width="12%" rowspan="3"><textarea cols="16" rows="5" name="ITEM_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=ITEM_LIST%></textarea></td>
	</tr>
	<tr>
		<td style="font-size:11px" align="right">WIP Type：</td>
		<td>
		<%
		try
		{   
			sql = " SELECT DISTINCT A.DATA_CODE,A.DATA_CODE FROM ORADDMAN.TSA01_OEM_DATA_TYPE A WHERE A.DATA_TYPE='WIP_TYPE' AND A.STATUS_FLAG='A' ORDER BY A.DATA_CODE";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(WIP_TYPE);
			comboBoxBean.setFieldName("WIP_TYPE");	 
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
		<td style="font-size:11px" align="right">Request  Date：</td>
		<td><input type="TEXT" NAME="REQ_SDATE" value="<%=REQ_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REQ_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="REQ_EDATE" value="<%=REQ_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REQ_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>		</td>
	</tr>
	<tr>
		<td colspan="12" align="center">
		<input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setQuery('../jsp/TSA01OEMWIPIssue.jsp?ATYPE=Q')">
		&nbsp;&nbsp;</td>
	</tr>
</TABLE>
<hr>
<%
try
{
	if (ATYPE.equals("Q"))
	{
		sql = " SELECT A.REQUEST_NO||'-'||A.VERSION_ID REQ_NO"+
              ",A.REQUEST_NO"+
              ",A.VERSION_ID"+
              ",A.WIP_TYPE_NO"+
              ",A.VENDOR_NAME"+
              ",A.REQUEST_DATE"+
              ",A.INVENTORY_ITEM_NAME"+
              ",A.ITEM_DESCRIPTION"+
              ",A.WIP_NO"+
              ",A.PR_NO"+
              ",A.PO_NO"+
              ",B.INVENTORY_ITEM_NAME COMP_ITEM_NAME"+
              ",C.DESCRIPTION"+
              ",B.SUBINVENTORY_CODE"+
              ",B.LOT_NUMBER"+
              ",B.DATE_CODE"+
              ",B.WAFER_QTY"+
              ",B.WAFER_NUMBER"+
              ",A.STATUS"+
			  ",B.LINE_NO"+
              ",NVL(B.ISSUE_QTY,0) ISSUE_QTY"+
			  ",NVL(B.WAFER_QTY,0)-NVL(B.ISSUE_QTY,0) open_qty"+
              ",ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY A.REQUEST_NO||'-'||A.VERSION_ID ) ROW_SEQ"+
			  ",(SELECT NVL(SUM(MOQ.primary_transaction_quantity),0) FROM INV.MTL_ONHAND_QUANTITIES_DETAIL MOQ"+
              " WHERE MOQ.ORGANIZATION_ID=A.ORGANIZATION_ID"+
              " AND MOQ.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID"+
              " AND MOQ.SUBINVENTORY_CODE=B.SUBINVENTORY_CODE"+
              " AND MOQ.LOT_NUMBER=B.LOT_NUMBER) ONHAND"+  //add by Peggy 20220801
              " FROM ORADDMAN.TSA01_OEM_HEADERS_ALL A"+
              ",ORADDMAN.TSA01_OEM_LINES_ALL B"+
              ",INV.MTL_SYSTEM_ITEMS_B C"+
              " WHERE A.REQUEST_NO=B.REQUEST_NO"+
              " AND A.ORGANIZATION_ID=C.ORGANIZATION_ID"+
              " AND B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID"+
              " AND A.STATUS='Approved'"+
              " AND NVL(B.WAFER_QTY,0)-NVL(B.ISSUE_QTY,0)>0";
		if (!VENDOR.equals("") && !VENDOR.equals("--"))
		{
			sql += " AND A.VENDOR_ID="+VENDOR+" ";
		}	
		if (!WIP_TYPE.equals("") && !WIP_TYPE.equals("--"))
		{
			sql += " AND A.WIP_TYPE_NO='"+WIP_TYPE+"'";
		}				  
		if (!REQ_SDATE.equals("") || !REQ_EDATE.equals(""))
		{
			sql += " AND A.REQUEST_DATE between NVL('"+REQ_SDATE+"','20220201') and NVL('"+REQ_EDATE+"','20990101') ";
		}
		if (!REQNO_LIST.equals(""))
		{
			String [] sArray =REQNO_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.REQUEST_NO in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += ",'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}	
						
		if (!WIPNO_LIST.equals(""))
		{
			String [] sArray =WIPNO_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.WIP_NO in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += ",'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}			
		
		if (!LOT_LIST.equals(""))
		{
			String [] sArray =LOT_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and B.LOT_NUMBER in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += ",'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}
		
		if (!PONO_LIST.equals(""))
		{
			String [] sArray =PONO_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.PO_NO in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += ",'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}			
				
		if (!ITEM_LIST.equals(""))
		{
			String [] sArray = ITEM_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (upper(a.ITEM_DESCRIPTION) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or upper(a.ITEM_DESCRIPTION) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}
		sql += " ORDER BY A.REQUEST_NO||'-'||A.VERSION_ID,B.LINE_NO";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);	
		while (rs.next())
		{
			if ( rs.getInt("ROW_SEQ")==1)
			{
		
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="2%" align="center" style="background-color:#A2BBC6;color:#000000">&nbsp;</td>
		<td width="2%" align="center" style="background-color:#A2BBC6;color:#000000"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
		<td width="4%" align="center" style="background-color:#A2BBC6;color:#000000">Issue Qty(PCE)</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center"><span style="font-size:11px">WIP Type</span></td>
		<td width="10%" style="background-color:#67A971;color:#FFFFFF;" align="center"><span style="font-size:11px">Vendor</span></td>
		<td width="7%" style="background-color:#67A971;color:#FFFFFF;" align="center">工單號碼</td>
		<td width="11%" style="background-color:#67A971;color:#FFFFFF;" align="center">品名</td>
		<td width="8%" style="background-color:#67A971;color:#FFFFFF;" align="center">Lot#</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center">Date Code</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center">WIP Qty(PCE)</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center">Issue Qty(PCE)</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center">Open Qty(PCE)</td>
		<td width="4%" style="background-color:#67A971;color:#FFFFFF;" align="center">Onhand(PCE)</td>
		<td width="6%" style="background-color:#67A971;color:#FFFFFF;" align="center">請購單號</td>
		<td width="6%" style="background-color:#67A971;color:#FFFFFF;" align="center">採購單號</td>
		<td width="6%" style="background-color:#67A971;color:#FFFFFF;" align="center"><span style="font-size:11px">申請單號</span></td>
		<td width="5%" style="background-color:#67A971;color:#FFFFFF;" align="center"><span style="font-size:11px">Request Date</span></td>
	</tr>
		<%
			}
			rowcnt++;
		%>
	<tr id="tr_<%=(rowcnt-1)%>">
		<td><%=rowcnt%></td>
		<td align="center">
			<input type="checkbox" name="chk" value="<%=rs.getString("REQ_NO")+"."+rs.getString("LINE_NO")%>" onClick="setCheck(<%=(rowcnt-1)%>)"></td>
		<td align="center"><input type="text" name="issue_qty_<%=rs.getString("REQ_NO")+"."+rs.getString("LINE_NO")%>" value="" style="font-weight:bold;text-align:right;border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;" size="4" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
		<td align="center"><%=rs.getString("WIP_TYPE_NO")%></td>
		<td align="center"><%=rs.getString("VENDOR_NAME")%></td>
		<td><%=(rs.getString("WIP_NO")==null?"&nbsp;":rs.getString("WIP_NO"))%></td>
		<td><%=rs.getString("ITEM_DESCRIPTION")%></td>
		<td><%=rs.getString("LOT_NUMBER")%></td>
		<td><%=rs.getString("DATE_CODE")%></td>
		<td align="right"><%=rs.getString("WAFER_QTY")%></td>
		<td align="right"><%=rs.getString("ISSUE_QTY")%></td>
		<td align="right"><%=rs.getString("OPEN_QTY")%><input type="hidden" name="open_qty_<%=rs.getString("REQ_NO")+"."+rs.getString("LINE_NO")%>" value="<%=rs.getString("OPEN_QTY")%>"></td>
		<td align="right" <%=(rs.getInt("ONHAND")>=rs.getInt("OPEN_QTY")? "style='color:#0000FF;font-weight:bold'":"style='color:#FF0000;font-weight:bold'")%>><%=rs.getString("ONHAND")%><input type="hidden" name="onhand_qty_<%=rs.getString("REQ_NO")+"."+rs.getString("LINE_NO")%>" value="<%=rs.getString("ONHAND")%>"></td>
		<td align="center"><%=(rs.getString("PR_NO")==null?"&nbsp;":rs.getString("PR_NO"))%></td>
		<td align="center"><%=(rs.getString("PO_NO")==null?"&nbsp;":rs.getString("PO_NO"))%></td>
		<td align="center"><%=rs.getString("REQ_NO")%></td>
		<td align="center"><%=rs.getString("REQUEST_DATE")%></td>
	</tr>	
		<%
		}
		rs.close();
		statement.close();
		
		if (rowcnt >0) 
		{
		%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#DAF0FC">
	<tr>
		<td><input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSA01OEMProcess.jsp?TRANSCODE=Issue")'></td>
	</tr>
</table>
<hr>
		<%
		}
		else
		{
			out.println("<div style='color:#0000ff;font-size:16px' align='center'>No Data Found!!</div>");
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='font-size:11px;color:#ff0000'>Exception:"+e.getMessage()+"</div>");
}
%>
<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

