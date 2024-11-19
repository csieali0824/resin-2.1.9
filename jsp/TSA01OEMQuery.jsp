<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<title>A01 Outsourcing Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean,,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean1" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="PCBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setObj()
{
	document.MYFORM.REQ_SDATE.value="";
	document.MYFORM.REQ_EDATE.value="";
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
	dateBean.setAdjDate(-10);
	REQ_SDATE = dateBean.getYearMonthDay();
	dateBean.setAdjDate(10);
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
String PRNO_LIST = request.getParameter("PRNO_LIST");
if (PRNO_LIST==null) PRNO_LIST="";
String PONO_LIST = request.getParameter("PONO_LIST");
if (PONO_LIST==null) PONO_LIST="";
String ITEM_LIST = request.getParameter("ITEM_LIST");
if (ITEM_LIST==null) ITEM_LIST="";
int i_group_cnt=0;

%>
<body> 
<FORM ACTION="../jsp/TSA01OEMQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">A01 Outsourcing Query </div>
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
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#DCE1E2" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="6%" style="font-family:arial;font-size:11px" >Vendor：</td>
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
		<td width="3%" style="font-family:arial;font-size:11px" rowspan="3">工單：</td>
		<td width="12%" rowspan="3"><textarea cols="18" rows="5" name="WIPNO_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=WIPNO_LIST%></textarea></td>
		<td width="3%" style="font-family:arial;font-size:11px" rowspan="3">LOT：</td>
	    <td width="10%" rowspan="3"><textarea cols="14" rows="5" name="LOT_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=LOT_LIST%></textarea></td>
		<td width="4%" style="font-family:arial;font-size:11px" rowspan="3">採購單：</td>
		<td width="8%" rowspan="3"><textarea cols="14" rows="5" name="PONO_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=PONO_LIST%></textarea></td>
		<td width="4%" style="font-family:arial;font-size:11px" rowspan="3">品名：</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="5" name="ITEM_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=ITEM_LIST%></textarea></td>
		<td width="4%" style="font-family:arial;font-size:11px" rowspan="3">申請單：</td>
		<td width="9%" rowspan="3"><textarea cols="16" rows="5" name="REQNO_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=REQNO_LIST%></textarea></td>
		<td width="4%" style="font-family:arial;font-size:11px" rowspan="3">請購單：</td>
		<td width="8%" rowspan="3"><textarea cols="14" rows="5" name="PRNO_LIST"  style="font-family:arial;font-size:11px" onChange="setObj()"><%=PRNO_LIST%></textarea></td>
	</tr>
	<tr>
		<td style="font-family:arial;font-size:11px">WIP Type：</td>
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
		<td style="font-family:arial;font-size:11px">Request  Date：</td>
		<td><input type="TEXT" NAME="REQ_SDATE" value="<%=REQ_SDATE%>" style="font-size:11px;font-family:arial;" size="7" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REQ_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="REQ_EDATE" value="<%=REQ_EDATE%>" style="font-size:11px;font-family:arial;" size="7" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REQ_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>		</td>
	</tr>
	<tr>
		<td colspan="14" align="center">
		<input type="button" name="btnQuery" value="Query"  style="font-family:arial;font-size:11px" onClick="setQuery('../jsp/TSA01OEMQuery.jsp?ATYPE=Q')">
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
              ",ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY A.WIP_TYPE_NO, A.REQUEST_NO||'-'||A.VERSION_ID DESC,B.LINE_NO ) ROW_SEQ"+
              ",COUNT(1) OVER (PARTITION BY A.REQUEST_NO||'-'||A.VERSION_ID) REQ_CNT"+
              ",ROW_NUMBER() OVER (PARTITION BY A.REQUEST_NO||'-'||A.VERSION_ID ORDER BY B.LINE_NO) REQ_SEQ"+
			  ",NVL(RECEIVE_QTY,0) RECEIVE_QTY "+
			  ",NVL(ISSUE_QTY,0) ISSUE_QTY"+
			  ",NVL(SCRAP_QTY,0) SCRAP_QTY"+
			  ",(SELECT NVL(SUM(QUANTITY_K),0) FROM oraddman.tsa01_oem_lines_trans_all X WHERE X.REQUEST_NO=B.REQUEST_NO AND X.VERSION_ID=B.VERSION_ID AND X.TRANS_TYPE='RECEIVE' AND X.INVENTORY_ITEM_ID=B.INVENTORY_ITEM_ID AND X.LOT_NUMBER=B.LOT_NUMBER) RECEIVE_QTY_K"+
			  ",(SELECT AUTHORIZATION_STATUS FROM PO_HEADERS_ALL X WHERE X.SEGMENT1=A.PO_NO) AUTHORIZATION_STATUS"+
			  ",a.VENDOR_CODE"+ //add by Peggy 20221026
              " FROM ORADDMAN.TSA01_OEM_HEADERS_ALL A"+
			  ",ORADDMAN.TSA01_OEM_LINES_ALL B"+
			  ",INV.MTL_SYSTEM_ITEMS_B C"+
              " WHERE A.REQUEST_NO=B.REQUEST_NO "+
              " AND A.ORGANIZATION_ID=C.ORGANIZATION_ID"+
              " AND B.INVENTORY_ITEM_ID=C.INVENTORY_ITEM_ID";
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
				
		if (!PRNO_LIST.equals(""))
		{
			String [] sArray =PRNO_LIST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and a.PR_NO in ( '"+sArray[x].trim()+"'";
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
		sql += " ORDER BY A.WIP_TYPE_NO,A.REQUEST_NO||'-'||A.VERSION_ID DESC,B.LINE_NO";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);	
		while (rs.next())
		{
			if ( rs.getInt("ROW_SEQ")==1)
			{
		
		%>
	<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0" style="font-family:arial;font-size:11px">
		<tr style="background-color:#DCE1E2;">
			<td width="2%" rowspan="2" align="center">&nbsp;</td>
			<td width="7%" rowspan="2" align="center">申請單號</td>
			<td width="4%" rowspan="2" align="center">WIP TYPE</td>	
			<td width="11%" rowspan="2" align="center">料號/品名</td>	
			<td width="11%" rowspan="2" align="center">供應商</td>	
			<td width="7%" rowspan="2" align="center">工單號碼</td>	
			<td width="6%" rowspan="2" align="center">請購單號</td>	
			<td width="6%" rowspan="2" align="center">採購單號</td>	
			<td width="6%" rowspan="2" align="center">申請日期</td>	
			<td width="3%" rowspan="2" align="center">EXCEL</td>	
			<td width="38%" align="center" colspan="8" style="color:#FFFFFF;background-color:#6CA4AA;">發料明細</td>	
		</tr>
		<tr>
			<td width="11%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">料號/品名</td>	
			<!--<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">倉別</td>-->
			<td width="6%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">LOT Number</td>	
			<!--<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">D/C</td>-->
			<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Wafer Qty</td>	
			<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Issue Qty</td>	
			<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Receive Qty</td>	
			<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Receive Qty(K)</td>	
			<td width="3%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Scrap Qty</td>	
			<td width="4%" align="center" style="color:#FFFFFF;background-color:#6CA4AA;">Wafer#</td>	
		</tr>
		<%
			}
			if (rs.getInt("REQ_SEQ")==1) i_group_cnt++;
		%>
		<tr id="tr_<%=i_group_cnt%>">
		<%
			if (rs.getInt("REQ_SEQ")==1)
			{
		%>
			<td rowspan="<%=rs.getInt("req_cnt")%>" align="center"><%=i_group_cnt%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>" ><A href='../jsp/TSA01OEMConfirmDetail.jsp?REQNO=<%=rs.getString("REQ_NO")%>&IDX=1'><%=rs.getString("REQ_NO")%></A></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>"><%=rs.getString("WIP_TYPE_NO")%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>"><%=rs.getString("INVENTORY_ITEM_NAME")+"<br>"+rs.getString("ITEM_DESCRIPTION")%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>"><%=rs.getString("VENDOR_NAME")%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>"><%=(rs.getString("WIP_NO")==null?"&nbsp;":rs.getString("WIP_NO"))%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>"><%=(rs.getString("PR_NO")==null?"&nbsp;":rs.getString("PR_NO"))%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>" <%=(rs.getString("AUTHORIZATION_STATUS")==null || !rs.getString("AUTHORIZATION_STATUS").equals("APPROVED")?" style='color:#ff0000'":"")%>><%=(rs.getString("PO_NO")==null?"&nbsp;":rs.getString("PO_NO"))%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>" align="center"><%=rs.getString("REQUEST_DATE")%></td>
			<td rowspan="<%=rs.getInt("req_cnt")%>" align="center">
			<%
				if (rs.getString("STATUS").equals("Approved"))
				{
					if (rs.getString("VENDOR_CODE").equals("4682"))
					{
						out.println("<a href='../jsp/TSA01OEMMSECExcel.jsp?REQUESTNO="+rs.getString("REQ_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");
					}
					else if (rs.getString("VENDOR_CODE").equals("4986"))
					{
						out.println("<a href='../jsp/TSA01OEMPPTExcel.jsp?REQUESTNO="+rs.getString("REQ_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");
					}
					else
					{
						out.println("<a href='../jsp/TSA01OEMExcel.jsp?REQUESTNO="+rs.getString("REQ_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");  
					}
				}
				else
				{
					out.println("&nbsp;&nbsp;");
				}
			%>
			</td>
			<td align="left"><%=rs.getString("COMP_ITEM_NAME")%>
			<br><%=rs.getString("DESCRIPTION")%></td>
			<!--<td align="center"><%=rs.getString("SUBINVENTORY_CODE")%></td>-->
			<td align="left"><%=rs.getString("LOT_NUMBER")%></td>
			<!--<td align="center"><%=rs.getString("DATE_CODE")%></td>-->
			<td align="right"><%=rs.getString("WAFER_QTY")%></td>
			<td align="right" <%=!rs.getString("ISSUE_QTY").equals(rs.getString("WAFER_QTY"))?" style='color:#FF0000;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("ISSUE_QTY")%></td>
			<td align="right" <%=!rs.getString("RECEIVE_QTY").equals(rs.getString("WAFER_QTY"))?" style='color:#0000FF;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("RECEIVE_QTY")%></td>
			<td align="right"><%=rs.getString("RECEIVE_QTY_K")%></td>
			<td align="right" <%=rs.getInt("SCRAP_QTY")>0?" style='color:#FF0000;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("SCRAP_QTY")%></td>
			<td align="center"><%=(rs.getString("WAFER_NUMBER")==null?"&nbsp;":rs.getString("WAFER_NUMBER"))%></td>
		</tr>
			<%
			}
			else
			{
			%>
			<td align="left"><%=rs.getString("COMP_ITEM_NAME")%>
			<br><%=rs.getString("DESCRIPTION")%></td>
			<!--<td align="center"><%=rs.getString("SUBINVENTORY_CODE")%></td>-->
			<td align="left"><%=rs.getString("LOT_NUMBER")%></td>
			<!--td align="center"><%=rs.getString("DATE_CODE")%></td>-->
			<td align="right"><%=rs.getString("WAFER_QTY")%></td>
			<td align="right" <%=!rs.getString("ISSUE_QTY").equals(rs.getString("WAFER_QTY"))?" style='color:#FF0000;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("ISSUE_QTY")%></td>
			<td align="right" <%=!rs.getString("RECEIVE_QTY").equals(rs.getString("WAFER_QTY"))?" style='color:#0000FF;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("RECEIVE_QTY")%></td>
			<td align="right"><%=rs.getString("RECEIVE_QTY_K")%></td>
			<td align="right" <%=rs.getInt("SCRAP_QTY")>0?" style='color:#FF0000;font-weight:bold'":" style='color:#000000'"%>><%=rs.getString("SCRAP_QTY")%></td>
			<td align="center"><%=(rs.getString("WAFER_NUMBER")==null?"&nbsp;":rs.getString("WAFER_NUMBER"))%></td>
		</tr>
			<%			
			}
		}
		if (i_group_cnt>0)
		{
		%>
	</table>
		<%
		}	
		else
		{
			out.println("<div align='center'  style='font-size:14px;color:#0000ff'>not data found!</div>");
		}	
		rs.close();
		statement.close();		
	}
}
catch (Exception e) 
{ 
	out.println("<DIV align='center' style='font-size:12px;color:#ff0000'>Exception1:"+e.getMessage()+"</div>"); 
} 	
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

