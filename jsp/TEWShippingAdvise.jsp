<!-- 20141212 by Peggy, AWAITING APPROVE狀態可看但不可排-->
<!-- 20150305 by Peggy, Hold MO不可排出貨-->
<!-- 20160428 by Peggy, 回T天數從21改成17,同RFQ-->
<!-- 20161104 by Peggy, 新增訂單號碼查詢條件-->
<!-- 20170621 by Peggy, 調整訂單部份出貨已先排的數量,因line拆出而重複出現-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
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
			setCheck(1);
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
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value = document.MYFORM.elements["SHIP_DATE_R_"+lineid].value;
		document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value = document.MYFORM.elements["ORDERED_QUANTITY_"+lineid].value;
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["VENDOR_NAME_"+lineid].value="";
		document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value="";
		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value = "";
		document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value = "";
	}
}
function setSubmit(URL)
{    
	if ((document.MYFORM.SDATE.value =="" || document.MYFORM.EDATE.value=="") && document.MYFORM.TSC_MO.value=="")
	{
		alert("請輸入預計出貨日!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var rec_year="",rec_month="",rec_day=""
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value ==null || document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value  =="")
			{
				alert("項次"+i+":供應商不可空白!");
				document.MYFORM.elements["VENDOR_NAME_"+lineid].focus();
				return false;
			}	
			if (document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value ==null || document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value  =="")
			{
				alert("項次"+i+":排定出貨日不可空白!");
				document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
				return false;
			}
			else if (document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.length!=8)
			{
				alert("項次"+i+":排定出貨日格式錯誤(正確格式為YYYYMMDD)!!");
				document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
				return false;			
			}
			else
			{
				rec_year = document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(0,4);
				rec_month= document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(4,2);
				rec_day  = document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(6,2);
				if (rec_month <1 || rec_month >12)
				{
					alert("項次"+i+":排定出貨月份有誤!!");
					document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
					return false;			
				}	
				else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
				{
					alert("項次"+i+":排定出貨日期有誤!!");
					document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
					return false;			
				} 
				else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
				{
					alert("項次"+i+":排定出貨日期有誤!!");
					document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
					return false;			
				} 
				else if (rec_month == 2)
				{
					if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
					{
						alert("項次"+i+":排定出貨日期有誤!!");
						document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
						return false;	
					}		
				}
			}
			
			if (document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value ==null || document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value  ==""	)
			{
				alert("項次"+i+":排定出貨量不可空白!");
				document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
				return false;
			}
			else if (eval(document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value) > eval(document.MYFORM.elements["ORDERED_QUANTITY_"+lineid].value))
			{
				alert("項次"+i+":排定出貨量不可大於訂單量!");
				document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
				return false;
			}
			else if (eval(document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value) != eval(document.MYFORM.elements["ACT_ALLOT_QTY_"+lineid].value))
			{
				alert("項次"+i+":出貨分配量("+document.MYFORM.elements["ACT_ALLOT_QTY_"+lineid].value+")不等於排定出貨量("+document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value+")!");
				document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
				return false;
			}
			if (document.MYFORM.elements["TO_TW_"+lineid].value ==null || document.MYFORM.elements["TO_TW_"+lineid].value  =="" || document.MYFORM.elements["TO_TW_"+lineid].value =="--")
			{
				alert("項次"+i+":請選擇是否回T!");
				document.MYFORM.elements["TO_TW_"+lineid].focus();
				return false;
			}
			if (document.MYFORM.elements["SHIP_METHOD_"+lineid].value ==null || document.MYFORM.elements["SHIP_METHOD_"+lineid].value  =="" || document.MYFORM.elements["SHIP_METHOD_"+lineid].value =="--")
			{
				alert("項次"+i+":出貨方式不可空白!");
				return false;
			}			
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	document.MYFORM.save.disabled=true;
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
function showPOReceiveList(lineid,chkline,shiptoorg)
{
	var chkvalue = "";
	var omlineid = "";
	var id = "";
	var iLen=0;
	var g=0;
	if (document.MYFORM.chk.length != undefined)
	{
		chkvalue = document.MYFORM.chk[chkline].checked;
	}
	else
	{
		chkvalue =document.MYFORM.chk.checked;
	}

	if (chkvalue==true)
	{
		if (document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value==null || document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value=="" || document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value=="0")
		{
			alert("請輸入排定出貨量!");
			document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
			return false;
		}
		if (document.MYFORM.chk.length != undefined)
		{
			iLen = document.MYFORM.chk.length;
		}
		else
		{
			iLen = 1;
		}
		for (var i=1; i<= iLen ; i++)
		{
			if (iLen==1)
			{
				chkvalue =document.MYFORM.chk.checked;
				id = document.MYFORM.chk.value;
			}
			else
			{
				chkvalue = document.MYFORM.chk[i-1].checked;
				id = document.MYFORM.chk[i-1].value;
			}
			if (chkvalue==true)
			{
				omlineid += ","+id;
				g++;
			}
		}
		if (g>0) omlineid += ",";
		//document.getElementById("alpha").style.width="1300";
		//document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		subWin=window.open("../jsp/subwindow/TEWPOReceiveListFind.jsp?ID="+lineid+"&SHIPORGID="+shiptoorg+"&ITEMID="+document.MYFORM.elements["ITEMID_"+lineid].value+"&SHIP_QTY="+document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value+"&CUST_PARTNO="+document.MYFORM.elements["CUST_ITEM_"+lineid].value+"&IDLIST="+omlineid,"subwin","width=800,height=500,scrollbars=yes,menubar=no");  
	}
}

function setSubmit2(URL)
{    
	if (document.MYFORM.SDATE.value =="" || document.MYFORM.EDATE.value=="")
	{
		alert("請輸入預計出貨日!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit3(URL)
{    
	if (confirm("您確定要更新Oracle Open訂單資料嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setChange()  //add by Peggy 20161104
{
	if (document.MYFORM.TSC_MO.value != null && document.MYFORM.TSC_MO.value != "")
	{
		document.MYFORM.SDATE.value ="";
		document.MYFORM.EDATE.value ="";
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>TEW PC 出貨通知排定</title>
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
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<%
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String TSC_DESC = request.getParameter("TSC_DESC");
if (TSC_DESC==null) TSC_DESC="";
String TSC_MO = request.getParameter("TSC_MO"); //add by Peggy 20161104
if (TSC_MO==null) TSC_MO="";
String sql = "";
String to_tw = "";
String ERPUSERID="";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShippingAdvise.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨通知排定</font></strong>
<BR>
<!--<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料搜尋中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>-->
<table width="100%">
	<tr>
		<td style="color:#0000FF;font-family:arial;font-size:11px">請注意!系統每整點會更新Oracle Open訂單資料,請進行出貨通知排定作業時,盡量避開此時段,謝謝!</td>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%"><font color="#666600" >預計出貨日:</font></td>
		<td width="20%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="10" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;&nbsp;~&nbsp;&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="10" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="5%"><font color="#666600" >業務區:</font></td>
		<td width="10%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select sales_group from oraddman.tew_open_orders_all group by sales_group order by 1";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='SALESAREA' style='font-family:arial'>");
			out.println("<OPTION VALUE=--"+ (SALESAREA.equals("") || SALESAREA.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (SALESAREA.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(1));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 		
		%>
		</td>
		<td width="5%"><font color="#666600" >型號:</font></td>
		<td width="12%"><input type="text" name="TSC_DESC" value="<%=TSC_DESC%>" style="font-family: Tahoma,Georgia;" size="20"></td>
		<td width="5%"><font color="#666600" >訂單號碼:</font></td>
		<td width="8%"><input type="text" name="TSC_MO" value="<%=TSC_MO%>" style="font-family: Tahoma,Georgia;" size="12" onChange="setChange();"></td>
		<td width="28%">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TEWShippingAdvise.jsp?ACTIONCODE=Q")' >
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='Export To Excel'  style="font-family: Tahoma,Georgia;" onClick='setSubmit2("../jsp/TEWShippingAdviseReport.jsp")' >
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='Import MO List'  style="font-family: Tahoma,Georgia;" onClick='setSubmit3("../jsp/TEWShippingAdvise.jsp?ACTIONCODE=IMPORT")' >
		</td>
	</tr>
</table> 
<HR>
<%
int job_cnt =0,job_id=1756;
if (ACTIONCODE.equals("IMPORT"))
{
	try
	{
		CallableStatement cs3 = con.prepareCall("{call TEW_RCV_PKG.TEW_CREATE_MO_JOB(?)}");
		cs3.setInt(1,job_id); 
		cs3.execute();
		cs3.close();
		
		%>
		<script language="JavaScript" type="text/JavaScript">
			document.MYFORM.submit();
		</script>
		<%
		
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}		
}
Statement statement1=con.createStatement();
ResultSet rs1=statement1.executeQuery("select 1 from dba_jobs_running where JOB="+job_id+" union all select 1 from user_scheduler_jobs WHERE JOB_NAME = 'TEW MO JOB:"+job_id+"'");
if (rs1.next())
{
	job_cnt = rs1.getInt(1);
}
rs1.close();
statement1.close();

if (job_cnt >0)
{
	out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>系統正在整理訂單資料中,請稍候再進入,謝謝!</strong></font></div>");
}
else
{
	if (((!SDATE.equals("") && !EDATE.equals("")) || !TSC_MO.equals(""))  && ACTIONCODE.equals("Q"))
	{
		MOShipBean.setArray2DString(null); 
		try
		{
			sql = " SELECT oola.HEADER_ID,"+
				  " oola.LINE_ID,"+
				  " oola.CUSTOMER_ID,"+
				  " oola.SHIP_FROM_ORG_ID,"+
				  " oola.ORDER_NO ORDER_NUMBER,"+
				  " msi.DESCRIPTION,"+
				  //" NVL(oola.ORDERED_QUANTITY,0)+(select nvl(sum(SHIPPED_QUANTITY),0) from ont.oe_order_lines_all x where x.header_id=oola.header_id and x.LINE_NUMBER=substr(oola.line_no,1,instr(oola.line_no,'.')-1))- NVL(sap.SHIP_QTY,0) ORDERED_QUANTITY,"+
				  " NVL(oola.ORDERED_QUANTITY,0)+(select nvl(sum(SHIPPED_QUANTITY),0) from ont.oe_order_lines_all x where x.header_id=oola.header_id and x.LINE_NUMBER=oola.line_no)- NVL(sap.SHIP_QTY,0) ORDERED_QUANTITY,"+ //modify by Peggy 20161104
				  " oola.UOM,"+
				  " oola.SALES_GROUP,"+
				  " oola.line_no,"+
				  " oola.CUST_ITEM,"+
				  " oola.CUST_PO_NUMBER CUSTOMER_PO,"+
				  " msi.SEGMENT1,"+
				  " oola.SHIP_METHOD,"+
				  " oola.PLANT_CODE,"+
				  " oola.FOB, "+
				  " TO_CHAR(oola.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SCHEDULE_SHIP_DATE,"+
				  " oola.PCMARKS,"+
				  " oola.CUSTOMER_NAME,"+
				  " tsc_om_category(oola.inventory_item_id,49,'TSC_PROD_GROUP') AS TSC_PROD_GROUP,"+
				  " oola.ORDER_STATUS STATUS,"+
				  " NVL(sap.SHIP_QTY,0) SHIP_QTY,"+
				  " oola.INVENTORY_ITEM_ID,"+
				  " oola.SHIPPING_REMARK,"+		
				  " tew_rcv_pkg.GET_ITEM_ONHAND( decode(oola.SHIP_FROM_ORG_ID,566,566,49),oola.INVENTORY_ITEM_ID) onhand,"+
				  " oola.TO_TW,"+
				  //" case WHEN oola.TO_TW='Y' then to_char(oola.SCHEDULE_SHIP_DATE -21,'yyyy/mm/dd') else to_char(oola.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') end AS ACT_SHIP_DATE,"+
				  " case WHEN oola.TO_TW='Y' then to_char(oola.SCHEDULE_SHIP_DATE -tsc_get_china_to_tw_days('E',oola.ORDER_NO,oola.INVENTORY_ITEM_ID,null,null,null),'yyyy/mm/dd') else to_char(oola.SCHEDULE_SHIP_DATE,'yyyy/mm/dd') end AS ACT_SHIP_DATE,"+ //抓rfq回t天數,modify by Peggy 20160428
				  " case WHEN oola.TO_TW='Y' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'yyyymmdd'),3),'yyyymmdd')"+
				  " WHEN (oola.SALES_GROUP='TSCH-HK' or oola.SALES_GROUP='TSCC-SH' or oola.SALES_GROUP='TSCT-Disty') and  oola.SHIP_METHOD='SEA' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'YYYYMMDD'),4),'yyyymmdd')  "+
				  " WHEN oola.SALES_GROUP='TSCA' and  oola.SHIP_METHOD='SEA(UC)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'YYYYMMDD'),4),'yyyymmdd')"+
				  " WHEN oola.SALES_GROUP='TSCE' and  oola.SHIP_METHOD='SEA(C)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'YYYYMMDD'),2),'yyyymmdd')"+
				  " WHEN oola.SALES_GROUP='TSCE' and  oola.SHIP_METHOD='AIR(C)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'YYYYMMDD'),5),'yyyymmdd')"+
				  " ELSE '' END AS ACT_SHIP_DATE_R"+
				  " FROM oraddman.tew_open_orders_all oola,"+
				  " INV.MTL_SYSTEM_ITEMS_B msi,"+
				  //" (SELECT SO_HEADER_ID,SO_LINE_ID,sum(SHIP_QTY) SHIP_QTY  FROM tsc.tsc_shipping_advise_pc_tew a where shipping_from ='TEW' group by SO_HEADER_ID,SO_LINE_ID) sap,"+
				  //" (SELECT SO_HEADER_ID,substr(SO_LINE_NUMBER, 1, INSTR (SO_LINE_NUMBER, '.') - 1) so_line_number,sum(SHIP_QTY) SHIP_QTY  FROM tsc.tsc_shipping_advise_pc_tew a where shipping_from ='TEW' group by SO_HEADER_ID,substr(SO_LINE_NUMBER, 1, INSTR (SO_LINE_NUMBER, '.') - 1)) sap,"+
				  " (SELECT SO_HEADER_ID,SO_LINE_NUMBER,sum(SHIP_QTY) SHIP_QTY  FROM tsc.tsc_shipping_advise_pc_tew a where shipping_from ='TEW' group by SO_HEADER_ID,SO_LINE_NUMBER) sap,"+ //moidfy by Peggy 20161104
				  " (SELECT x.header_id, x.line_no  "+
				  "  FROM (SELECT header_id,TO_NUMBER (SUBSTR (line_no, 1, INSTR (line_no, '.') - 1)) line_no, SUM (ordered_quantity) order_ty "+
				  "        FROM oraddman.tew_open_orders_all GROUP BY header_id, SUBSTR (line_no, 1, INSTR (line_no, '.') - 1)) x,"+
				  "       (SELECT so_header_id,TO_NUMBER (SUBSTR (so_line_number,1,INSTR (so_line_number, '.') - 1)) line_no,SUM (ship_qty) pc_confirm_qty "+
				  "        FROM tsc.tsc_shipping_advise_pc_tew a where not exists (select 1 from tsc.tsc_shipping_advise_lines b"+
				  "                                                                 ,tsc.tsc_shipping_advise_HEADERs c"+
				  "                                                                 where b.advise_header_id=c.advise_header_id"+
                  "                                                                 and TEW_ADVISE_NO is not null"+
                  "                                                                 and c.STATUS='4'"+
				  //"                                                               where exists (select 1 from tsc.tsc_advise_dn_line_int c,tsc.tsc_advise_dn_header_int d "+
				  //"                                                                             where c.advise_header_id = d.advise_header_id"+
				  //"                                                                             and c.interface_header_id = d.interface_header_id"+
				  //"                                                                             and d.status='S'"+
				  //"                                                                             and c.advise_line_id = b.advise_line_id) "+
				  "                                                              and b.pc_advise_id=a.pc_advise_id)  GROUP BY so_header_id, SUBSTR (so_line_number, 1, INSTR (so_line_number, '.') - 1)) y"+
				  "        WHERE x.header_id = y.so_header_id(+) AND x.line_no = y.line_no(+) and NVL (x.order_ty, 0) - NVL (pc_confirm_qty, 0) > 0) oor"+
                  //",(SELECT SO_NO,SO_HEADER_ID,SUBSTR(SO_LINE_NUMBER,1,INSTR(SO_LINE_NUMBER,'.')-1) LINE_NUMBER,SUM(SHIP_QTY) LINE_TOT_SHIP_QTY FROM TSC_SHIPPING_ADVISE_PC_TEW A "+
				  ",(SELECT SO_NO,SO_HEADER_ID,SUBSTR(SO_LINE_NUMBER,1,INSTR(SO_LINE_NUMBER,'.')-1) LINE_NUMBER,SUM(CASE WHEN SO_NO='11310038456' THEN 0 ELSE SHIP_QTY END) LINE_TOT_SHIP_QTY FROM TSC_SHIPPING_ADVISE_PC_TEW A "+
                  "  GROUP BY SO_NO,SO_HEADER_ID,SUBSTR(SO_LINE_NUMBER,1,INSTR(SO_LINE_NUMBER,'.')-1)) line_ship_tot"+ //add by Peggy 20170621
				  //" WHERE ((oola.TO_TW='Y' and oola.SCHEDULE_SHIP_DATE BETWEEN to_date(?,'yyyymmdd')+21 AND to_date(?,'yyyymmdd')+21.99999)"+
				  " WHERE ((oola.TO_TW='Y' and oola.SCHEDULE_SHIP_DATE BETWEEN to_date(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'yyyymmdd')+tsc_get_china_to_tw_days('E',oola.ORDER_NO,oola.INVENTORY_ITEM_ID,null,null,null) AND to_date(NVL(?,TO_CHAR(TRUNC(SYSDATE)+30,'yyyymmdd')),'yyyymmdd')+(tsc_get_china_to_tw_days('E',oola.ORDER_NO,oola.INVENTORY_ITEM_ID,null,null,null)+0.99999))"+ //抓rfq回t天數,modify by Peggy 20160428
				  "  or (oola.TO_TW='N' and oola.SCHEDULE_SHIP_DATE BETWEEN to_date(NVL(?,TO_CHAR(TRUNC(SYSDATE)-30,'yyyymmdd')),'yyyymmdd') AND to_date(NVL(?,TO_CHAR(TRUNC(SYSDATE)+30,'yyyymmdd')),'yyyymmdd')+0.99999))"+
				  " AND  oola.INVENTORY_ITEM_ID = msi.INVENTORY_ITEM_ID"+
				  " AND msi.ORGANIZATION_ID = 49"+
				  //" AND tsc_om_category(oola.inventory_item_id,49,'TSC_PROD_GROUP')  =?"+
				  " AND oola.HEADER_ID = sap.SO_HEADER_ID(+)"+
				  //" AND SUBSTR (oola.line_no, 1, INSTR (oola.line_no, '.') - 1)=sap.so_line_number(+)"+ //add by Peggy 20151231
				  " AND oola.line_no=sap.so_line_number(+)"+ //modify by Peggy 20161104
				  //" AND oola.LINE_ID =sap.SO_LINE_ID(+)"+
				  " AND oola.HEADER_ID = oor.HEADER_ID"+ //add by Peggy 20140728
				  " AND TO_NUMBER (SUBSTR (oola.line_no, 1, INSTR (oola.line_no, '.') - 1))=oor.line_no"+ //add by Peggy 20140728
				  //" AND oola.line_no=sap.SO_LINE_NUMBER(+)"+
                  " AND oola.HEADER_ID = line_ship_tot.SO_HEADER_ID(+)"+  //add by Peggy 20170621
                  " AND TO_NUMBER (SUBSTR (oola.line_no, 1, INSTR (oola.line_no, '.') - 1))=line_ship_tot.LINE_NUMBER(+)"+
				  " AND NVL(oola.ORDERED_QUANTITY,0)+(select nvl(sum(SHIPPED_QUANTITY),0) from ont.oe_order_lines_all x where x.header_id=oola.header_id and x.LINE_NUMBER=substr(oola.line_no,1,instr(oola.line_no,'.')-1))- NVL(sap.SHIP_QTY,0)>0"+
				  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_LINES_ALL x WHERE x.LINE_ID=oola.LINE_ID AND x.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE'))"+  //add by Peggy 20160224
				  " AND oola.ORDER_LINE_TOT_QTY-nvl(line_ship_tot.LINE_TOT_SHIP_QTY,0) >0";  //add by Peggy 20170621
			if (!SALESAREA.equals("--") && !SALESAREA.equals(""))
			{
				sql += " AND oola.SALES_GROUP ='" + SALESAREA+"'";
			}
			if (!TSC_DESC.equals(""))
			{
				sql += " AND msi.description like '"+TSC_DESC+"%'";
			}
			if (!TSC_MO.equals("")) //add by Peggy 20161104
			{
				sql += " AND oola.ORDER_NO= '"+TSC_MO+"'";
			}
			sql += " ORDER BY ACT_SHIP_DATE,SALES_GROUP, oola.SHIP_METHOD,oola.SHIPPING_REMARK,oola.ORDER_NO,oola.LINE_ID,msi.DESCRIPTION";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			//statement.setString(1,"21"); //回T船期21天
			//statement.setString(2,"21"); //回T船期21天
			statement.setString(1,SDATE);
			statement.setString(2,SDATE);
			statement.setString(3,SDATE);
			statement.setString(4,SDATE);
			statement.setString(5,SDATE);
			statement.setString(6,SDATE);
			statement.setString(7,EDATE);
			statement.setString(8,SDATE);
			statement.setString(9,EDATE);		
			//statement.setString(10,"Rect-Subcon");
			ResultSet rs=statement.executeQuery();
			int icnt =0;
			//Hashtable hashtb = new Hashtable();
			while (rs.next())
			{
				if (rs.getInt("ORDERED_QUANTITY")<=0)
				{
					continue;
				}
				if (icnt ==0)
				{
	%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="1600" align="center" borderColorLight="#CFDAD8" border='1'>
					<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
						<td width="30">序號</td>
						<td width="20"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
						<!--<td width="80">採購單號</td>-->
						<td width="70">供應商</td>
						<!--<td width="50">單價</td>-->
						<td width="60">排定出貨日</td>
						<td width="60">排定出貨量</td>
						<td width="50">回T</td>
						<td width="70">預計出貨日</td>
						<td width="80">訂單號碼</td>
						<td width="40">項次</td>
						<td width="150">型號</td>
						<td width="70">訂單量<br>(PCE)</td>
						<td width="70">可用庫存<br>(PCE)</td>
						<td width="100">嘜頭</td>
						<td width="70">業務區</td>
						<td width="80">PC MARKS</td>
						<td width="70">出貨方式</td>
						<td width="100">客戶品號</td>
						<td width="200">客戶PO</td>
						<td width="100">訂單狀態</td>
					</tr>
				
	<%		
				}
				to_tw = rs.getString("TO_TW");
	%>
					<tr id="tr_<%=rs.getString("line_id")%>"  <%=(!rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") && !rs.getString("STATUS").toUpperCase().equals("HOLD")? "style='font-family:airl;font-size:11px'":" style='font-family:airl;font-size:11px;background-color:#FFFF66' title='此筆訂單目前為不可出貨狀態'")%>>
						<td align="left"><%=(icnt+1)%></td>
						<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("line_id")%>" onClick="setCheck(<%=icnt%>)" <%=(rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") || rs.getString("STATUS").toUpperCase().equals("HOLD")?" disabled":"")%>></td>
						<!--<td align="center"><input type="text" name="PONO_<%=rs.getString("line_id")%>" value="" size="8"  title="按下滑鼠左鍵，查詢採購單收貨庫存明細!" readonly onKeyDown="return (event.keyCode!=8);" style="font-size:11px;font-family:arial" onMouseDown="showPOReceiveList(<%=rs.getString("line_id")%>,<%=icnt%>)">-->
						<!--</td>-->
						<td align="left"><input type="text" name="VENDOR_NAME_<%=rs.getString("line_id")%>" value="" SIZE="10" title="按下滑鼠左鍵，查詢採購單收貨庫存明細!"  onKeyDown="return (event.keyCode!=8);" style="font-size:11px;font-family:arial" onMouseDown="showPOReceiveList('<%=rs.getString("line_id")%>','<%=icnt%>','<%=rs.getString("SHIP_FROM_ORG_ID")%>')" readonly>
						<input type="hidden" name="VENDOR_SITE_ID_<%=rs.getString("line_id")%>" value="">
						<input type="hidden" name="BOX_CODE_<%=rs.getString("line_id")%>" value="">
						<td align="center"><input type="text" name="ACT_SHIP_DATE_<%=rs.getString("line_id")%>" valu="" size="6" style="font-size:11px;font-family:arial"></td>
						<td align="center">
						<input type="text" name="ACT_SHIP_QTY_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial">
						<input type="hidden" name="ACT_ALLOT_QTY_<%=rs.getString("line_id")%>" value="">
						</td>
						<td align="center">
						<select NAME="TO_TW_<%=rs.getString("line_id")%>" style="font-family:Tahoma,Georgia; font-size: 11px">
					<%
						if (to_tw.equals("--"))
						{
					%>
						<OPTION VALUE=-- <%if (to_tw.equals("--")) out.println("selected");%>>--</OPTION>
					<%
						}
						if (to_tw.equals("--") || to_tw.equals("Y"))
						{
					%>
						<OPTION VALUE="Y" <%if (to_tw.equals("Y")) out.println("selected");%>>是</OPTION>
					<%
						}
						if (to_tw.equals("--") || to_tw.equals("N"))
						{
					%>
						<OPTION VALUE="N" <%if (to_tw.equals("N")) out.println("selected");%>>否</OPTION>
					<%
						}
					%>
						</select>
						</td>
						<td align="center"><%=rs.getString("act_SHIP_DATE")%><input type="hidden" name="SHIP_DATE_<%=rs.getString("line_id")%>" value="<%=rs.getString("act_SHIP_DATE").replace("/","")%>"><input type="hidden" name="SHIP_DATE_R_<%=rs.getString("line_id")%>" value="<%=(rs.getString("act_SHIP_DATE_R")==null?"":rs.getString("act_SHIP_DATE_R"))%>"></td>
						<td align="center"><%=rs.getString("ORDER_NUMBER")%><input type="hidden" name="ORDER_NUMBER_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDER_NUMBER")%>"></td>
						<td align="center"><%=rs.getString("line_no")%></td>
						<td align="left"><%=rs.getString("DESCRIPTION")%><input type="hidden" name="ITEMID_<%=rs.getString("line_id")%>" value="<%=rs.getString("INVENTORY_ITEM_ID")%>"></td>
						<td align="right"><%=rs.getString("ORDERED_QUANTITY")%><input type="hidden" name="ORDERED_QUANTITY_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDERED_QUANTITY")%>"></td>
						<td align="right"><%=(new DecimalFormat("######.###")).format(rs.getFloat("ONHAND"))%></td>
						<!--<td align="left"><%=rs.getString("CUSTOMER_NAME")%></td>-->
						<td align="left"><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
						<td align="left"><%=rs.getString("SALES_GROUP")%></td>
						<td align="left"><%=(rs.getString("PCMARKS")==null?"&nbsp;":rs.getString("PCMARKS"))%></td>
						<!--<td align="left"><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>-->
						<td align="left"><%=(rs.getString("SHIP_METHOD")==null?"&nbsp;":rs.getString("SHIP_METHOD"))%><input type="hidden" name="SHIP_METHOD_<%=rs.getString("line_id")%>" value="<%=(rs.getString("SHIP_METHOD")==null?"":rs.getString("SHIP_METHOD"))%>"></td>
						<td align="left"><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%><input type="hidden" name="CUST_ITEM_<%=rs.getString("line_id")%>" value="<%=(rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM"))%>"></td>
						<td align="left"><%=rs.getString("CUSTOMER_PO")%>
						<td align="left" style="font-size:10px"><%=rs.getString("STATUS")%>
						</td>
					</tr>
	<%
				icnt++;
			}
			if (icnt >0)
			{
	%>
				</table>
				<table width="100%">
					<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TEWShippingAdviseProcess.jsp')"></td></tr>
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
	}
}
%>
<input type="hidden" name="TRANSTYPE" value="INSERT">
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

