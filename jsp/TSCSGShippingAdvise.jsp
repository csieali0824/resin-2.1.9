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
			if (document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value ==null || document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value =="--" || document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value =="")
			{
				alert("項次"+i+":供應商不可空白!");
				document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].focus();
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
			if (document.MYFORM.elements["TO_TW_"+lineid].value ==null || document.MYFORM.elements["TO_TW_"+lineid].value  =="" || document.MYFORM.elements["TO_TW_"+lineid].value =="--")
			{
				alert("項次"+i+":請選擇是否回T!");
				document.MYFORM.elements["TO_TW_"+lineid].focus();
				return false;
			}
			//add by Peggy 20230415
			if (document.MYFORM.elements["PRICE_GID_"+lineid].value!="0" && document.MYFORM.elements["ASSIGN_PO_"+lineid].value=="")
			{
				alert("項次"+i+":此訂單有綁定採購價,請先指定對應採購單");
				document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
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
function setSubmit2(URL)
{    
	if (document.MYFORM.SDATE.value =="" || document.MYFORM.EDATE.value=="")
	{
		alert("Please input schedule ship date!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit3(URL)
{    
	if (confirm("Are you sure to want to update data now?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setChange() 
{
	if (document.MYFORM.TSC_MO.value != null && document.MYFORM.TSC_MO.value != "")
	{
		document.MYFORM.SDATE.value ="";
		document.MYFORM.EDATE.value ="";
	}
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
		subWin=window.open("../jsp/subwindow/TSCSGPOReceiveListFind.jsp?ID="+lineid+"&SHIPORGID="+shiptoorg+"&ITEMID="+document.MYFORM.elements["ITEMID_"+lineid].value+"&SHIP_QTY="+document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value+"&CUST_PARTNO="+document.MYFORM.elements["CUST_ITEM_"+lineid].value+"&IDLIST="+omlineid+"&PID="+document.MYFORM.elements["PRICE_GID_"+lineid].value,"subwin","width=850,height=500,scrollbars=yes,menubar=no");  
	}
	else
	{
		alert("請先勾選訂單!");
		return false;
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
<title>SG Shipping Advise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
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
String TSC_MO = request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String TOTW1 = request.getParameter("TOTW1");
if (TOTW1==null) TOTW1="";
String sql = "";
String to_tw = "";
String ERPUSERID="";
String [] sVendor = null;
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_id in (select erp_user_id from oraddman.wsuser where username=UPPER(?))");
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
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGShippingAdvise.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Shipping Advise</font></strong>
<BR>
<table width="100%">
	<tr>
		<td style="color:#0000FF;font-family:arial;font-size:11px">Notice! The system will import oracle order data every hour, Please avoid to operation system on this during.</td>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="4%"><font color="#666600" >內外銷:</font></td>   
		<td width="4%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
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
		<!--<select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG2</OPTION>
		</select>-->
		</td>	
		<td width="7%"><font color="#666600" >TSC Prod Group:</font></td>
		<td width="7%">
		<select NAME="TSCPRODGROUP" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (TSCPRODGROUP.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="PRD-Subcon" <%if (TSCPRODGROUP.equals("PRD-Subcon")) out.println("selected");%>>PRD-Subcon</OPTION>
		<OPTION VALUE="SSD" <%if (TSCPRODGROUP.equals("SSD")) out.println("selected");%>>SSD</OPTION>
		<OPTION VALUE="PMD" <%if (TSCPRODGROUP.equals("PMD")) out.println("selected");%>>PMD</OPTION>
		</select>		
		</td>
		<td width="10%"><font color="#666600" >Schedule Ship Date:</font></td>
		<td width="15%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="6%"><font color="#666600" >Sales Region:</font></td>
		<td width="7%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select sales_group from oraddman.tssg_open_orders_all group by sales_group order by 1";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='SALESAREA' style='font-family:Tahoma,Georgia;font-size:11px'>");
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
		<td width="6%"><font color="#666600">Item Desc:</font></td>
		<td width="12%">
		<textarea cols="25" rows="3" name="TSC_DESC"  style="font-family: Tahoma,Georgia;font-size:11px"><%=TSC_DESC%></textarea>		
		</td>
		<td width="6%"><font color="#666600" >Order Number:</font></td>
		<td width="7%">
		<textarea cols="15" rows="3" name="TSC_MO" style="font-family: Tahoma,Georgia;font-size:11px"  onChange="setChange();"><%=TSC_MO%></textarea>
		</td>
		<td width="4%"><font color="#666600">TO TW:</font></td>
		<td width="5%">
		<select NAME="TOTW1" style="font-family: Tahoma,Georgia;font-size:11px" >
		<OPTION VALUE="--" <%=(TOTW1.equals("") || TOTW1.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="N" <%=(TOTW1.equals("N")?" selected ":"")%>>否
        <OPTION VALUE="Y" <%=(TOTW1.equals("Y")?" selected ":"")%>>是
		</select>
		</td>			
	</tr>
	<tr>
		<td align="center" colspan="14">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;font-size:11px" onClick='setSubmit("../jsp/TSCSGShippingAdvise.jsp?ACTIONCODE=Q")' >
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='Import MO List'  style="font-family: Tahoma,Georgia;font-size:11px" onClick='setSubmit3("../jsp/TSCSGShippingAdvise.jsp?ACTIONCODE=IMPORT")' >
		</td>
	</tr>
</table> 
<HR>
<%
//int job_cnt =0,job_id=2397;
int job_cnt =0,job_id=2457;
if (ACTIONCODE.equals("IMPORT"))
{
	try
	{
		CallableStatement cs3 = con.prepareCall("{call TSSG_SHIP_PKG.SG_CREATE_MO_JOB(?)}");
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
ResultSet rs1=statement1.executeQuery("select 1 from dba_jobs_running where JOB="+job_id+" union all select 1 from user_scheduler_jobs WHERE JOB_NAME = 'SG MO JOB:"+job_id+"'");
if (rs1.next())
{
	job_cnt = rs1.getInt(1);
}
rs1.close();
statement1.close();

if (job_cnt >0)
{
	out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>The data is updating, Please operating system later!</strong></font></div>");
}
else
{
	if (((!SDATE.equals("") && !EDATE.equals("")) || !TSC_MO.equals(""))  && ACTIONCODE.equals("Q"))
	{
		MOShipBean.setArray2DString(null); 
		try
		{
			sql = "select * from (SELECT oola.HEADER_ID,"+
				  " oola.LINE_ID,"+
				  " oola.CUSTOMER_ID,"+
				  " oola.SHIP_FROM_ORG_ID,"+
				  " oola.ORDER_NO ORDER_NUMBER,"+
				  " msi.DESCRIPTION,"+
				  " APPS.TSCC_GET_FLOW_CODE(oola.INVENTORY_ITEM_ID)as flow_code,\n" +
				  " case when ((select nvl(sum(ORDERED_QUANTITY),0) from ont.oe_order_lines_all x where x.header_id=oola.header_id and x.LINE_NUMBER=substr(oola.line_no,1,instr(oola.line_no,'.')-1)) - NVL (sap.ship_qty, 0)) < NVL (oola.ordered_quantity, 0) "+
				  " then (select nvl(sum(ORDERED_QUANTITY),0) from ont.oe_order_lines_all x where x.header_id=oola.header_id and x.LINE_NUMBER=substr(oola.line_no,1,instr(oola.line_no,'.')-1)) - NVL (sap.ship_qty, 0) "+
				  " else NVL (oola.ordered_quantity, 0)-nvl((SELECT sum(x.SHIP_QTY) FROM tsc.tsc_shipping_advise_pc_sg x where x.so_line_id=oola.line_id),0) end ordered_quantity,"+  //modify by Peggy 20210901
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
				  " oola.TSC_PROD_GROUP,"+
				  " oola.ORDER_STATUS STATUS,"+
				  " NVL(sap.SHIP_QTY,0) SHIP_QTY,"+
				  " oola.INVENTORY_ITEM_ID,"+
				  " oola.SHIPPING_REMARK,"+
				  //" tssg_ship_pkg.get_inv_onhand(decode(oola.SHIP_FROM_ORG_ID,887,887,906,906,49),oola.INVENTORY_ITEM_ID,null) onhand,"+
				  " nvl(tssg_ship_pkg.get_inv_onhand(case when mp.organization_code in ('SG1','SG2') then oola.SHIP_FROM_ORG_ID else 49 end,oola.INVENTORY_ITEM_ID,null),0)-NVL(TSSG_SHIP_PKG.GET_ITEM_ALLOT_QTY (oola.SHIP_FROM_ORG_ID,oola.inventory_item_id),0) onhand,"+
				  "case when oola.SALES_GROUP ='TSCE' and substr(oola.ORDER_NO,0,4)='1214' then 'N'\n"+
				  " else oola.TO_TW end TO_TW,\n"+
//				  " oola.TO_TW,"+
				  //" TSSG_RCV_PKG.GET_ITEM_VENDOR_SITE(oola.line_id,oola.org_id,null) vendor_site_id,"+
				  //" TSSG_RCV_PKG.GET_ITEM_VENDOR_SITE(oola.line_id,906,null) vendor_site_id,"+
				  " TSSG_RCV_PKG.GET_ITEM_VENDOR_LIST(oola.INVENTORY_ITEM_ID,oola.SHIP_FROM_ORG_ID,null) vendor_site_id,"+
				  " oola.org_id,"+
//				  " case WHEN SUBSTR(oola.ORDER_NO,1,4) ='8131' THEN TO_CHAR(oola.SCHEDULE_SHIP_DATE,'yyyymmdd')"+ //add by Peggy 20200508
				  " CASE\n" +
				  "    WHEN (SUBSTR (oola.ORDER_NO, 1, 4) = '8131'\n" +
				  "          or SUBSTR (oola.ORDER_NO, 1, 4) = '1214' and oola.SALES_GROUP ='TSCE')\n" +
				  " THEN\n" +
				  "     TO_CHAR (oola.SCHEDULE_SHIP_DATE, 'yyyymmdd')\n" +
				  " WHEN oola.TO_TW='Y' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)+10,'yyyymmdd')),'yyyymmdd'),3),'yyyymmdd')"+
				  " WHEN oola.SALES_GROUP in ('TSCH-HK','TSCC-SH','TSCT-Disty','TSCT') and oola.SHIP_METHOD='SEA' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)+10,'yyyymmdd')),'YYYYMMDD'),4),'yyyymmdd')  "+
				  " WHEN oola.SALES_GROUP='TSCA' and  oola.SHIP_METHOD='SEA(UC)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)+10,'yyyymmdd')),'YYYYMMDD'),4),'yyyymmdd')"+
				  " WHEN oola.SALES_GROUP='TSCE' and  oola.SHIP_METHOD='SEA(C)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)+10,'yyyymmdd')),'YYYYMMDD'),5),'yyyymmdd')"+
				  " WHEN oola.SALES_GROUP='TSCE' and  oola.SHIP_METHOD='AIR(C)' THEN to_char(next_day(TO_DATE(NVL(?,TO_CHAR(TRUNC(SYSDATE)+10,'yyyymmdd')),'YYYYMMDD'),4),'yyyymmdd')"+
				  " ELSE '' END AS ACT_SHIP_DATE_R"+
				  ",nvl((select distinct group_id from oraddman.tssg_custpo_link_tspo x where x.sales_region=oola.SALES_GROUP and x.customer_po=oola.CUST_PO_NUMBER and x.item_desc=msi.DESCRIPTION),0) price_group_id"+ //特殊價綁定 by Peggy 20230515
				  " FROM (select * from oraddman.tssg_open_orders_all "+
				  "       )  oola,"+
				  " INV.MTL_SYSTEM_ITEMS_B msi,"+
				  " INV.MTL_PARAMETERS mp,"+
				  " (SELECT SO_HEADER_ID,substr(SO_LINE_NUMBER,1,instr(SO_LINE_NUMBER,'.')-1) SO_LINE_NUMBER,sum(SHIP_QTY) SHIP_QTY  FROM tsc.tsc_shipping_advise_pc_sg a group by SO_HEADER_ID,substr(SO_LINE_NUMBER,1,instr(SO_LINE_NUMBER,'.')-1)) sap"+ //modify by Peggy 20200715
				  " WHERE msi.organization_id=oola.ship_from_org_id"+
				  " AND msi.inventory_item_id=oola.inventory_item_Id"+
				  " AND oola.ship_from_org_id=mp.organization_id"+
				  " AND oola.HEADER_ID = sap.SO_HEADER_ID(+)"+
				  " AND substr(oola.line_no,1,instr(oola.line_no,'.')-1)=sap.so_line_number(+)"+ //modify by Peggy 20200715
				  " AND NVL(oola.ORDERED_QUANTITY,0) - nvl((SELECT sum(x.SHIP_QTY) FROM tsc.tsc_shipping_advise_pc_sg x where x.so_line_id=oola.line_id),0)>0"+ //add by Peggy 20200716
				  " AND EXISTS (SELECT 1 FROM ONT.OE_ORDER_LINES_ALL x WHERE x.LINE_ID=oola.LINE_ID AND x.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE'))";
			if (!SDATE.equals(""))
			{
				sql += " AND oola.SCHEDULE_SHIP_DATE BETWEEN to_date('"+SDATE+"','yyyymmdd') and to_date('"+(EDATE.equals("")?"20991231":EDATE)+"','yyyymmdd')+0.99999";
			}
			else if (!EDATE.equals(""))
			{
				sql += " AND oola.SCHEDULE_SHIP_DATE BETWEEN add_months(TRUNC(SYSDATE),-36) and to_date('"+EDATE+"','yyyymmdd')+0.99999 ";
			}
			if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
			{
				sql += " AND oola.SHIP_FROM_ORG_ID='"+ORGCODE+"'";
			}	
			if (!TSCPRODGROUP.equals("--") && !TSCPRODGROUP.equals(""))
			{
				sql += " AND oola.TSC_PROD_GROUP='"+TSCPRODGROUP+"'";
			}	  
			if (!SALESAREA.equals("--") && !SALESAREA.equals(""))
			{
				sql += " AND oola.SALES_GROUP ='" + SALESAREA+"'";
			}
			//if (!TSC_DESC.equals(""))
			//{
			//	sql += " AND msi.description like '"+TSC_DESC+"%'";
			//}
			if (!TSC_DESC.equals(""))
			{
				String [] sArray = TSC_DESC.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += "and msi.description in ( '"+sArray[x].trim()+"'";
					}
					else
					{
						sql += " ,'"+sArray[x].trim()+"'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}			
			//if (!TSC_MO.equals(""))
			//{
			//	sql += " AND oola.ORDER_NO= '"+TSC_MO+"'";
			//}
			if (!TSC_MO.equals(""))
			{
				String [] sArray = TSC_MO.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += "and oola.ORDER_NO in ( '"+sArray[x].trim()+"'";
					}
					else
					{
						sql += " ,'"+sArray[x].trim()+"'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}
			sql += " )\n";
			if (TOTW1 != null && !TOTW1.equals("--") && !TOTW1.equals(""))
			{
				sql += " where to_tw = '"+TOTW1+"' ";
			}
			sql += "ORDER BY SCHEDULE_SHIP_DATE,SALES_GROUP, SHIP_METHOD, SHIPPING_REMARK, ORDER_NUMBER, LINE_ID, DESCRIPTION";
			//out.println(sql);
			System.out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,SDATE);
			statement.setString(2,SDATE);
			statement.setString(3,SDATE);
			statement.setString(4,SDATE);
			statement.setString(5,SDATE);		
			ResultSet rs=statement.executeQuery();
			int icnt =0;
			while (rs.next())
			{
				//if (rs.getInt("ORDERED_QUANTITY")<=0)
				//{
				//	continue;
				//}
				if (icnt ==0)
				{
	%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
					<tr bgcolor="#C8E3E8" style="font-family:Tahoma,Georgia;font-size:11px" align="center">
						<td width="2%">Seq</td>
						<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
						<td width="2%">&nbsp;</td>
						<td width="5%">PC SSD </td>
						<td width="6%">Confirm Qty </td>
						<td width="4%">TO TW </td>
						<td width="5%">Order SSD</td>
						<td width="6%">Order Number </td>
						<td width="3%">Line No </td>
						<td width="11%">Item Desc </td>
						<td width="5%">Flow Code </td>
						<td width="5%">Order Qty <br>
						  (PCE)</td>
						<td width="5%">Onhand<br>
						  (PCE)</td>
						<td width="8%">Shipping Marks </td>
						<td width="6%">Sales Region </td>
						<!--<td width="8%">PC MARKS</td>-->
						<td width="6%">Shipping Method </td>
						<td width="6%">Cust PartNo </td>
						<td width="6%">Customer PO</td>
						<td width="6%">Order Status </td>
						<td width="6%">Vendor </td>
					</tr>
				
	<%		
				}
				to_tw = rs.getString("TO_TW");
				//out.println( rs.getString("org_id")+"    "+rs.getString("INVENTORY_ITEM_ID")+"    "+rs.getString("LINE_ID"));
				
	%>
					<tr id="tr_<%=rs.getString("line_id")%>"  <%=(!rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") && !rs.getString("STATUS").toUpperCase().equals("HOLD")? "style='font-family:airl;font-size:11px'":" style='font-family:airl;font-size:11px;background-color:#FFFF66' title='Order status is hold'")%>>
						<td align="left"><%=(icnt+1)%></td>
						<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("line_id")%>" onClick="setCheck(<%=icnt%>)" <%=(rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") || rs.getString("STATUS").toUpperCase().equals("HOLD") || rs.getString("STATUS").toUpperCase().equals("ENTERED") || rs.getString("ORDERED_QUANTITY").equals("0")?" disabled":"")%>></td>
						<td align="left"><img src="images/search.gif" border="0" onClick="showPOReceiveList('<%=rs.getString("line_id")%>','<%=icnt%>','<%=rs.getString("SHIP_FROM_ORG_ID")%>')"></td>
						<td align="center"><input type="text" name="ACT_SHIP_DATE_<%=rs.getString("line_id")%>" valu="" size="6" style="font-size:11px;font-family:arial">
						<input type="hidden" name="SHIP_DATE_R_<%=rs.getString("line_id")%>" value="<%=(rs.getString("act_SHIP_DATE_R")==null?"":rs.getString("act_SHIP_DATE_R"))%>">
						<input type="hidden" name="PRICE_GID_<%=rs.getString("line_id")%>" value="<%=(rs.getString("price_group_id")==null?"0":rs.getString("price_group_id"))%>">
						<input type="hidden" name="ASSIGN_PO_<%=rs.getString("line_id")%>" value="">
						<br><%=(rs.getString("price_group_id").equals("0")?"":"<font color='#0000ff'>請指定採購單</font>")%>
						</td>
						<td align="center">
						<input type="text" name="ACT_SHIP_QTY_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial">
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
						<td align="center"><%=rs.getString("SCHEDULE_SHIP_DATE")%><input type="hidden" name="SHIP_DATE_<%=rs.getString("line_id")%>" value="<%=rs.getString("SCHEDULE_SHIP_DATE").replace("/","")%>"></td>
						<td align="center"><%=rs.getString("ORDER_NUMBER")%><input type="hidden" name="ORDER_NUMBER_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDER_NUMBER")%>"></td>
						<td align="center"><%=rs.getString("line_no")%><input type="hidden" name="ORDER_LINE_<%=rs.getString("line_id")%>" value="<%=rs.getString("line_no")%>"></td>
						<td align="left"><%=rs.getString("DESCRIPTION")%><input type="hidden" name="ITEMID_<%=rs.getString("line_id")%>" value="<%=rs.getString("INVENTORY_ITEM_ID")%>"></td>
						<td align="left"><%=StringUtils.isNullOrEmpty(rs.getString("FLOW_CODE"))? "" : rs.getString("FLOW_CODE")%><input type="hidden" name="FLOW_CODE<%=rs.getString("line_id")%>" value="<%=StringUtils.isNullOrEmpty(rs.getString("FLOW_CODE"))? "" : rs.getString("FLOW_CODE")%>"></td>
						<td align="right"><%=rs.getString("ORDERED_QUANTITY")%><input type="hidden" name="ORDERED_QUANTITY_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDERED_QUANTITY")%>"></td>
						<td align="right"><%=(new DecimalFormat("######.###")).format(rs.getFloat("ONHAND"))%><input type="hidden" name="ONHAND_<%=rs.getString("line_id")%>" value="<%=(rs.getString("ONHAND")==null?"0":rs.getString("ONHAND"))%>"></td>
						<td align="left"><%=(rs.getString("SHIPPING_REMARK")==null || rs.getString("SHIPPING_REMARK").equals(" ")?"&nbsp;":rs.getString("SHIPPING_REMARK"))%><input type="hidden" name="SHIPPING_REMARK_<%=rs.getString("line_id")%>" value="<%=(rs.getString("SHIPPING_REMARK")==null?"":rs.getString("SHIPPING_REMARK"))%>"></td>
						<td align="left"><%=rs.getString("SALES_GROUP")%><input type="hidden" name="SALES_GROUP_<%=rs.getString("line_id")%>" value="<%=rs.getString("SALES_GROUP")%>"></td>
						<td align="left"><%=(rs.getString("SHIP_METHOD")==null?"&nbsp;":rs.getString("SHIP_METHOD"))%><input type="hidden" name="SHIP_METHOD_<%=rs.getString("line_id")%>" value="<%=(rs.getString("SHIP_METHOD")==null?"":rs.getString("SHIP_METHOD"))%>"></td>
						<td align="left"><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%><input type="hidden" name="CUST_ITEM_<%=rs.getString("line_id")%>" value="<%=(rs.getString("CUST_ITEM")==null?"":rs.getString("CUST_ITEM"))%>"></td>
						<td align="left"><%=rs.getString("CUSTOMER_PO")%>
						<td align="left" style="font-size:10px"><%=rs.getString("STATUS")%></td>
						<td>
						<select NAME="VENDOR_SITE_ID_<%=rs.getString("line_id")%>" style="font-size:11px;font-family:Tahoma,Georgia;">
						<%
							sVendor = rs.getString("vendor_site_id").split("\n");
							for (int k =0 ; k < sVendor.length ; k++)
							{
						%>
								<OPTION VALUE="<%=sVendor[k].trim().substring(0,sVendor[k].trim().indexOf("@"))%>" <%=(k==(sVendor.length-1)?"selected":"")%>><%=sVendor[k].trim().substring(sVendor[k].trim().indexOf("@")+1)%></OPTION>
						<%
							}	
						%>
						</select>
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
					<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGShippingAdviseProcess.jsp')"></td></tr>
				</table>
	<%
			}
			else
			{
				out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
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

