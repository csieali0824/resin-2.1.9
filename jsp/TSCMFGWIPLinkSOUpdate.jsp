<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>YEW WIP Link ERP SO</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<script language="JavaScript" type="text/JavaScript">
function setAddLine(URL)
{
	var TXTLINE = document.MYFORMD.TXTLINE.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入欲新增行數!");
		document.MYFORMD.TXTLINE.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>10)
		{
    		alert("行數新增範圍1~10!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;		
		}
	}
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setDelete(objLine)
{
	if (confirm("您確定要刪除Line No:"+objLine+"的資料嗎?"))
	{
		document.MYFORMD.elements["ERPSO_"+objLine].value=""
		document.MYFORMD.elements["ERPSOLINE_"+objLine].value="";
		document.MYFORMD.elements["ERR_"+objLine].value="";
		for (var i =objLine+1; i <= document.MYFORMD.LINECNT.value ; i++)
		{
			document.MYFORMD.elements["ERPSO_"+(i-1)].value = document.MYFORMD.elements["ERPSO_"+i].value;
			document.MYFORMD.elements["ERPSOLINE_"+(i-1)].value = document.MYFORMD.elements["ERPLINE_"+i].value;
			document.MYFORMD.elements["ERPSOLINE_"+(i-1)].value = "";
			document.MYFORMD.elements["ERPSO_"+i].value=""
			document.MYFORMD.elements["ERPSOLINE_"+i].value="";
			document.MYFORMD.elements["ERR_"+i].value="";
		}		
	}
	else
	{
		return false;
	}
}
function setSubmit(URL)
{
	var mo_cnt=0;
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		if (document.MYFORMD.elements["ERPSO_"+i].value!="")
		{
			if (document.MYFORMD.elements["ERPSOLINE_"+i].value=="")
			{
				alert("項次"+i+":請輸入訂單項次!!");
				document.MYFORMD.elements["ERPSOLINE_"+i].focus();
				return false;
			}
			else 
			{
				mo_cnt ++;
			}
		}
	}
	if (mo_cnt==0)
	{
		alert("請指定ERP SO及Line No!!");
		return false;
	}
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.cancel1.disabled=true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setClose(URL)
{
	if (confirm("您確定要不存檔離開嗎?"))
	{
		location.href=URL;
	}
}
function setClear()
{
	document.MYFORMD.WIPNO.value="";
	document.MYFORMD.ITEM_ID.value="";
	document.MYFORMD.ITEM_NAME.value="";
	document.MYFORMD.ITEM_DESC.value="";
	for (var i =1; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		document.MYFORMD.elements["ERPSO_"+(i)].value = "";
		document.MYFORMD.elements["ERPSOLINE_"+(i)].value = "";
		document.MYFORMD.elements["ERR_"+(i)].value = "";
	}		
}
function setQuery()
{ 
	if (document.MYFORMD.WIPNO.length ==0)
	{
		alert("請輸入工單號!");
		document.MYFORMD.WIPNO.setfocus();
		return false;
	}
 	document.MYFORMD.submit();
}
</script>
<body>  
<FORM ACTION="../jsp/TSCMFGWIPLinkSOUpdate.jsp" METHOD="post" NAME="MYFORMD">
<%
String sql = "";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String ITEM_ID = request.getParameter("ITEM_ID");
if (ITEM_ID==null) ITEM_ID="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="3";
String ORIGCNT=  request.getParameter("ORIGCNT");
if (ORIGCNT ==null) ORIGCNT="";
String strPartNo=request.getParameter("TSC_PARTNO");
if (strPartNo==null) strPartNo="";
String DEL_LINE = request.getParameter("DEL_LINE");
if (DEL_LINE==null) DEL_LINE="";
boolean Line_Exist = false;
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="NEW";
if (ACODE.equals("ADDLINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)+Integer.parseInt(TXTLINE));
}
else if (ACODE.equals("DELETELINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)-1);
}
if (LINECNT.equals("0")) LINECNT="1";
int icnt=0,errcnt=0;	
String SO_LINE_LIST ="",SO_LIST="",strErr="",strExistLine="",strSO="",strSOLine="";
String [] aa = new String[1];

try
{
	if (ACODE.equals("NEW") &&  !WIPNO.equals("") && ITEM_NAME.equals(""))
	{
		sql = " select inventory_item_id,inv_item,item_desc,new_line_list,length(new_line_list)-length(replace(new_line_list,',',''))+1 id_cnt "+
		      ",TSC_GET_PARTNO(a.ORGANIZATION_ID ,a.inventory_item_id) tsc_partno"+
		      " from yew_workorder_all a"+
			  " where a.wo_no=? and a.STATUSID<>'050'";
		//out.println(sql);
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,WIPNO);
		ResultSet rs1=statement1.executeQuery();
		if (rs1.next())
		{
			ITEM_ID =rs1.getString("inventory_item_id");
			ITEM_NAME =rs1.getString("inv_item");
			ITEM_DESC = rs1.getString("item_desc");
			strExistLine =rs1.getString("new_line_list");
			strPartNo =rs1.getString("tsc_partno");
			if (strExistLine ==null) strExistLine ="";
			Line_Exist=true;
			if (!strExistLine.equals(""))
			{
				LINECNT = ""+(rs1.getInt("id_cnt")+3);
				aa = strExistLine.split(",");			
			}
		}
		else
		{
			Line_Exist=false;
		}
		rs1.close();
		statement1.close();	
	}
	else
	{
		Line_Exist =true;
	}
}
catch(Exception e)
{
	Line_Exist=false;
}

if (!Line_Exist)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查無工單號,請重新確認,謝謝!");
		document.MYFORMD.WIPNO.setfocus();
	</script>
<%
}  
%>
<div align="center"><font color="#003366" size="+2" face="Arial Black">YEW WIP Link SO</font></div>
<TABLE border="1" width="50%" align="center">
	<tr>
		<td width="15%" style="font-size:12px" align="right">WIP NO：</td>
	  <td width="85%" colspan="4"><input type="text" name="WIPNO" value="<%=WIPNO%>" style="font-family: Tahoma,Georgia;" size="20" onBlur="setQuery()"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">料號：</td>
		<td colspan="2"><input type="text" name="ITEM_NAME" value="<%=ITEM_NAME%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="40" readonly><input type="hidden" name="ITEM_ID" value="<%=ITEM_ID%>"><input type="hidden" name="TSC_PARTNO" value="<%=strPartNo%>"></td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">品名：</td>
		<td colspan="2"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;"  size="60" readonly></td>
	</tr>
</TABLE>
<hr>
<table align="center" width="50%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="5%" align="center">項次</td>
		<td width="10%" align="center">ERP SO</td>
		<td width="10%" align="center">ERP SO Line No</td>
		<td width="8%" align="center">&nbsp;</td>
	</tr>
	<%
		for (int i =1 ; i <=Integer.parseInt(LINECNT) ; i++)
		{
			strErr="";
			if (ACODE.equals("SAVE"))
			{
				if (request.getParameter("ERPSO_"+i) != null && !request.getParameter("ERPSO_"+i).equals(""))
				{
					sql = " select a.order_number,b.inventory_item_id,b.flow_status_code,c.segment1 ,c.description,b.header_id,b.line_id"+
		                  ",TSC_GET_PARTNO(c.ORGANIZATION_ID ,c.inventory_item_id) tsc_partno"+
						  " from ont.oe_order_headers_all a,ont.oe_order_lines_all b,inv.mtl_system_items_b c"+
						  " where a.header_id=b.header_id"+
						  " and b.ship_from_org_id in (326,327)"+
						  " and a.org_id=case when substr(a.order_number,1,4) in (1156,1214) then 41 else 325 end "+
						  " and a.order_number=?"+
						  " and b.line_number||'.'||b.shipment_number=?"+
						  " and b.ship_from_org_id=c.organization_id"+
						  " and b.inventory_item_id=c.inventory_item_id";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,request.getParameter("ERPSO_"+(i)));
					statement.setString(2,request.getParameter("ERPSOLINE_"+(i)));
					ResultSet rs=statement.executeQuery();
					if (rs.next()) 
					{ 
						if (!rs.getString("inventory_item_id").equals(ITEM_ID) && !rs.getString("tsc_partno").equals(strPartNo))
						{
							strErr="工單料號:"+ITEM_NAME+" 與訂單料號:"+rs.getString("segment1")+"不符!!";
							errcnt++;
						}
						else if (rs.getString("flow_status_code").equals("CANCELLED") || rs.getString("flow_status_code").equals("CLOSED"))
						{
							strErr="訂單狀態已"+rs.getString("flow_status_code")+"!!";
							errcnt++;
						}
						else
						{
							if (SO_LIST.length() >0) SO_LIST += ",";
							SO_LIST += (request.getParameter("ERPSO_"+(i)) + " "+request.getParameter("ERPSOLINE_"+(i)));
							if (SO_LINE_LIST.length() >0) SO_LINE_LIST += ",";
							SO_LINE_LIST += rs.getString("line_id");
						}
					}
					else
					{
							strErr="查無訂單項次,請重新確認!!";
							errcnt++;
					}
					rs.close();
					statement.close();
				}
			}
	%>
	<tr>
		<td align="center"><%=(i)%></td>
	<%
			if (!strExistLine.equals(""))
			{
				if (i <= aa.length)
				{
		
					sql = " select a.order_number,b.line_number||'.'||b.shipment_number line_no"+
						  " from ont.oe_order_headers_all a,ont.oe_order_lines_all b"+
						  " where a.header_id=b.header_id"+
						  " and b.line_id=?";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,aa[i-1]);
					ResultSet rs=statement.executeQuery();
					if (rs.next()) 
					{ 
						strSO=rs.getString("order_number");
						strSOLine=rs.getString("line_no");
					}
					rs.close();	
					statement.close();			
				}
				else
				{
					strSO="";strSOLine="";
				}
				%>
				<td><input type="text" NAME="ERPSO_<%=(i)%>" value="<%=strSO%>" style="font-family: Tahoma,Georgia;" size="15"></td>
				<td><input type="text" name="ERPSOLINE_<%=(i)%>" value="<%=strSOLine%>" style="font-family: Tahoma,Georgia;" size="8"><input type="text" NAME="ERR_<%=(i)%>" value="<%=strErr%>" style="font-family: Tahoma,Georgia;border-top:none;border-right:none;border-left:none;border-bottom:none;color:#ff0000"  size="20" readonly></td>
			<%
			}
			else
			{
			%>
				<td><input type="text" NAME="ERPSO_<%=(i)%>" value="<%=(request.getParameter("ERPSO_"+(i))==null?"":request.getParameter("ERPSO_"+(i)))%>" style="font-family: Tahoma,Georgia;" size="15"></td>
				<td><input type="text" name="ERPSOLINE_<%=(i)%>" value="<%=(request.getParameter("ERPSOLINE_"+(i))==null?"":request.getParameter("ERPSOLINE_"+(i)))%>" style="font-family: Tahoma,Georgia;" size="8"><input type="text" NAME="ERR_<%=(i)%>" value="<%=strErr%>" style="font-family: Tahoma,Georgia;border-top:none;border-right:none;border-left:none;border-bottom:none;color:#ff0000"  size="20" readonly></td>
			<%
			}
			%>
		<td align="center"><input type="button" name="DEL<%=(i)%>" value="Delete" style="font-family: Tahoma,Georgia;"  onClick="setDelete(<%=(i)%>)"></td>
		<%
		}
		%>
	</tr>	
	<tr>
		<td  colspan="4"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick='setAddLine("../jsp/TSCMFGWIPLinkSOUpdate.jsp?ACODE=ADDLINE")'><input type="text" NAME="TXTLINE" value="1" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="3"></td>
	</tr>
</table>	
<table width="50%" align="center">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TSCMFGWIPLinkSOUpdate.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia">
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick='setClose("../jsp/TSCMFGWIPLinkSOHistory.jsp")' style="font-family: Tahoma,Georgia">
		</td>
	</tr>
</table>
<input type="hidden" name="LINECNT" value="<%=LINECNT%>">
<input type="hidden" name="ORIGCNT" value="<%=ORIGCNT%>">
</FORM>
	<%		
	if (ACODE.equals("SAVE") && errcnt ==0)
	{
		try
		{
			sql = " insert into oraddman.TSYEW_WIP_LINK_SO_HISTORY"+
				  " (WO_NO"+
				  ", MO_LIST"+
				  ", CREATION_DATE"+
				  ", CREATED_BY"+
				  " )"+
				  " values"+
				  "(?"+
				  ",?"+
				  ",sysdate"+
				  ",?)";
			PreparedStatement pstmtDt=con.prepareStatement(sql);
			pstmtDt.setString(1,WIPNO);
			pstmtDt.setString(2,SO_LIST);
			pstmtDt.setString(3,UserName);
			pstmtDt.executeQuery();
			pstmtDt.close();	
			
			sql = " update YEW_WORKORDER_ALL"+
				  " set NEW_LINE_LIST=?"+
			      " where WO_NO=?";		
			PreparedStatement pstmt=con.prepareStatement(sql);
			pstmt.setString(1,SO_LINE_LIST);
			pstmt.setString(2,WIPNO);
			pstmt.executeQuery();
				  								  
			con.commit();
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("新增成功!");
				setClear();
			</script>			
		<%	
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<font color='#ff0000'>"+e.getMessage()+"</font>");
		}			
	}

%>	

<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

