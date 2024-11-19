<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
		setCheck(1);
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
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	var rec_year="",rec_month="",rec_day=""
	for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
	{
		if (document.MYFORM.rdo1[i].checked)
		{
			 chvalue = document.MYFORM.rdo1[i].value;
			 break;
		}
	}
	if (chvalue == "")
	{
		alert("請選擇要加到既有的Advise No或新產生Advise No!");
		return false;
	}
	else if (chvalue =="ADD")
	{
		if (document.MYFORM.ADVISE_NO.value =="")
		{
			alert("請選擇Advise No!");
			document.MYFORM.ADVISE_NO.focus();
			return false;
		}
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
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true)
		{
			if (chvalue=="ADD")
			{
				if (document.MYFORM.elements["ORGID_"+lineid].value != document.MYFORM.ORGID.value)
				{
					alert("項次"+i+":ORG條件不相符!");
					return false;				
				}			
				if (document.MYFORM.elements["TOTW_"+lineid].value  !="Y" && document.MYFORM.elements["REGION_"+lineid].value != document.MYFORM.SALESAREA.value)
				{
					alert("項次"+i+":業務區不相符!");
					return false;				
				}	
				if (document.MYFORM.elements["SSD_"+lineid].value != document.MYFORM.SHIPDATE.value)
				{
					alert("項次"+i+":出貨日期不相符!");
					return false;				
				}
				if (document.MYFORM.elements["SHIPPING_METHOD_"+lineid].value != document.MYFORM.SHIPPINGMETHOD.value)
				{
					alert("項次"+i+":出貨方式不相符!");
					return false;				
				}
				if (document.MYFORM.elements["TOTW_"+lineid].value != document.MYFORM.TOTW.value)
				{
					alert("項次"+i+":回T條件不相符!");
					return false;				
				}	
			}
			if (document.MYFORM.elements["SSD_"+lineid].value ==null || document.MYFORM.elements["SSD_"+lineid].value  =="")
			{
				alert("項次"+i+":排定出貨日不可空白!");
				document.MYFORM.elements["SSD_"+lineid].focus();
				return false;
			}
			else if (document.MYFORM.elements["SSD_"+lineid].value.length!=8)
			{
				alert("項次"+i+":排定出貨日格式錯誤(正確格式為YYYYMMDD)!!");
				document.MYFORM.elements["SSD_"+lineid].focus();
				return false;			
			}
			else
			{
				rec_year = document.MYFORM.elements["SSD_"+lineid].value.substr(0,4);
				rec_month= document.MYFORM.elements["SSD_"+lineid].value.substr(4,2);
				rec_day  = document.MYFORM.elements["SSD_"+lineid].value.substr(6,2);
				if (rec_month <1 || rec_month >12)
				{
					alert("項次"+i+":排定出貨月份有誤!!");
					document.MYFORM.elements["SSD_"+lineid].focus();
					return false;			
				}	
				else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
				{
					alert("項次"+i+":排定出貨日期有誤!!");
					document.MYFORM.elements["SSD_"+lineid].focus();
					return false;			
				} 
				else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
				{
					alert("項次"+i+":排定出貨日期有誤!!");
					document.MYFORM.elements["SSD_"+lineid].focus();
					return false;			
				} 
				else if (rec_month == 2)
				{
					if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
					{
						alert("項次"+i+":排定出貨日期有誤!!");
						document.MYFORM.elements["SSD_"+lineid].focus();
						return false;	
					}		
				}
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("Please click any one data!");
		return false;
	}
	document.MYFORM.save.disabled=true;
	document.MYFORM.delete1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
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
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("Please click any one data!");
		return false;
	}
	else if (confirm("Are you sure to delete the datas?")==true)
	{
		document.MYFORM.save.disabled=true;
		document.MYFORM.delete1.disabled=true;
		document.MYFORM.action=URL;
		document.MYFORM.submit();
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

function showActionType()
{
	var chvalue="";
	for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
	{
		if (document.MYFORM.rdo1[i].checked)
		{
			 chvalue = document.MYFORM.rdo1[i].value;
			 break;
		}
	}
	if (chvalue =="ADD")
	{
		document.MYFORM.elements["ADVISE_NO"].disabled =false;
		document.MYFORM.elements["ADVISE_NO"].value="";
		document.getElementById("bt2").style.visibility ="visible";
	}
	else if (chvalue =="NEW")
	{
		document.MYFORM.elements["ADVISE_NO"].disabled =true;
		document.MYFORM.elements["ADVISE_NO"].value="";
		document.getElementById("bt2").style.visibility ="hidden";
	}
}

function setAdviseNoList()
{
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked==true)
			{
				lineid = document.MYFORM.chk[i].value;
				break;
			}
		}
	}
	else if (document.MYFORM.chk.checked==true)
	{
		lineid = document.MYFORM.chk.value;
	}
	if (lineid=="")
	{
		alert("Please click any one data!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSCSGAdviseNoListFind.jsp?ORGID="+document.MYFORM.elements["ORGID_"+lineid].value+"&SSD="+document.MYFORM.elements["SSD_"+lineid].value,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
</script>
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
<title>SG Shipping Advise Confirm</title>
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
<%
String sql = "";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="Q";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null || ACTIONCODE.equals("Q")) ADVISE_NO="";
String CUSTOMER_ID = request.getParameter("CUSTOMER_ID");
if (CUSTOMER_ID ==null) CUSTOMER_ID="";
String SALESAREA1 = request.getParameter("SALESAREA1");
if (SALESAREA1==null) SALESAREA1="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String SHIPDATE=request.getParameter("SHIPDATE");
if (SHIPDATE==null) SHIPDATE="";
String SHIPPINGMETHOD = request.getParameter("SHIPPINGMETHOD");
if (SHIPPINGMETHOD==null) SHIPPINGMETHOD="";
String TOTW = request.getParameter("TOTW");
if (TOTW==null) TOTW="";
String CURR = request.getParameter("CURR");
if (CURR==null) CURR="";
String SHIPTO = request.getParameter("SHIPTO");
if (SHIPTO==null) SHIPTO="";
String SALESAREANO = request.getParameter("SALESAREANO");
if (SALESAREANO==null) SALESAREANO="";
String TOTW1 = request.getParameter("TOTW1");
if (TOTW1==null) TOTW1="";
String SHIPFROM= request.getParameter("SHIPFROM");
if (SHIPFROM==null) SHIPFROM="";
String ERPUSERID="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String ORGID= request.getParameter("ORGID");
if (ORGID==null) ORGID="";
String ITEMCNT=request.getParameter("ITEMCNT");
if (ITEMCNT==null) ITEMCNT="";
//PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
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
<FORM ACTION="../jsp/TSCSGShippingAdviseConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:18px;color:#000099">SG Shipping Advise Confirm</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%" style="font-weight:bold;color:#000000">內外銷:</td>   
		<td width="7%">
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
		<!--<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>
		</select>-->
		</td>	
		<td width="8%" style="font-weight:bold;color:#000000">TSC Prod Group:</td>
		<td width="8%">
		<select NAME="TSCPRODGROUP" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (TSCPRODGROUP.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="PRD-Subcon" <%if (TSCPRODGROUP.equals("PRD-Subcon")) out.println("selected");%>>PRD-Subcon</OPTION>
		<OPTION VALUE="SSD" <%if (TSCPRODGROUP.equals("SSD")) out.println("selected");%>>SSD</OPTION>
		</select>		
		</td>
		<td width="10%" style="font-weight:bold;color:#000000">Schedule Ship Date:</td>
		<td width="15%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="7%" style="font-weight:bold;color:#000000">Sales Region:</td>
		<td width="8%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select REGION_CODE sales_group from tsc.tsc_shipping_advise_pc_sg where ADVISE_NO is null group by REGION_CODE order by 1";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='SALESAREA1' style='font-family:Tahoma,Georgia;font-size:11px'>");
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
		<td width="5%" style="font-weight:bold;color:#000000">TO TW:</td>
		<td width="7%">
		<select NAME="TOTW1" style="font-family:arial">
		<OPTION VALUE="--" <%=(TOTW1.equals("") || TOTW1.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="N" <%=(TOTW1.equals("N")?" selected ":"")%>>否
        <OPTION VALUE="Y" <%=(TOTW1.equals("Y")?" selected ":"")%>>是
		</select>
		</td>		
	</tr>
	<tr>
		<td colspan="10" align="center">		
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCSGShippingAdviseConfirm.jsp?ACTIONCODE=Q")' >
		</td>  
	</tr>
</table> 
<HR>
<%
if (ACTIONCODE.equals("Q"))
{
	try
	{
		sql = " select tsa.PC_ADVISE_ID,"+
			  " tsa.shipping_from,"+
			  " tsa.SO_NO,"+
			  " tsa.SO_LINE_NUMBER,"+
			  " tsa.ITEM_NO,"+
			  " tsa.item_desc,"+
			  " (tsa.ship_qty/1000) ship_qty,"+
			  " to_char(tsa.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') PC_SCHEDULE_SHIP_DATE,"+
			  " tsa.TO_TW,"+
			  " tsa.SHIPPING_REMARK,"+
			  " tsa.CUST_PO_NUMBER,"+
			  " tsa.SHIPPING_METHOD,"+
			  " tsa.REGION_CODE,"+
			  " decode(oolla.item_identifier_type,'CUST',oolla.ordered_item,'') CUST_ITEM,"+
			  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
			  " tsa.CURRENCY_CODE,"+
			  " tsa.CUSTOMER_ID,"+
			  " tsa.SHIP_TO_ORG_ID,"+
			  " tsa.seq_no,"+
			  " mp.organization_code,"+
			  " tsa.organization_id,"+
			  " tsa.vendor_site_id,"+
			  " ap.vendor_site_code,"+
 		       "case  mp.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else mp.organization_code end as organization_name"+
			  " FROM tsc.tsc_shipping_advise_pc_sg tsa,"+
			  " ONT.OE_ORDER_LINES_ALL oolla,"+
			  " inv.mtl_parameters mp,"+
			  " AR_CUSTOMERS ra,"+
			  " ap_supplier_sites_all ap"+
			  " where tsa.so_line_id = oolla.line_id(+)"+
			  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID(+)"+
			  " and tsa.organization_id=mp.organization_id"+
			  " and tsa.vendor_site_id=ap.vendor_site_id"+
			  " and tsa.advise_NO is null";
		if (!SDATE.equals(""))
		{
			sql += " AND tsa.PC_SCHEDULE_SHIP_DATE BETWEEN to_date('"+SDATE+"','yyyymmdd') and to_date('"+(EDATE.equals("")?"20991231":EDATE)+"','yyyymmdd')+0.99999";
		}
		else if (!EDATE.equals(""))
		{
			sql += " AND tsa.PC_SCHEDULE_SHIP_DATE BETWEEN add_months(TRUNC(SYSDATE),-36) and to_date('"+EDATE+"','yyyymmdd')+0.99999 ";
		}
		if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
		{
			sql += " AND tsa.ORGANIZATION_ID='"+ORGCODE+"'";
		}	
		if (!TSCPRODGROUP.equals("--") && !TSCPRODGROUP.equals(""))
		{
			sql += " AND tsa.PRODUCT_GROUP='"+TSCPRODGROUP+"'";
		}	  
		if (!SALESAREA1.equals("--") && !SALESAREA1.equals(""))
		{
			sql += " AND tsa.REGION_CODE ='" + SALESAREA1+"'";
		}
		if (TOTW1 != null && !TOTW1.equals("--") && !TOTW1.equals(""))
		{
			sql += " and tsa.to_tw='"+TOTW1+"'";
		}
		sql += " order by tsa.ORGANIZATION_ID,tsa.REGION_CODE,tsa.PC_SCHEDULE_SHIP_DATE,tsa.SHIPPING_METHOD, RA.CUSTOMER_NAME_PHONETIC,tsa.SHIPPING_METHOD,tsa.PC_ADVISE_ID";
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		int icnt =0;
		String po_list="";
		while (rs.next())
		{
			if (icnt ==0)
			{
		%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1" bgcolor="#538079">
					<tr>
						<td style="border-left-style:none;border-right-style:none">
						<input type="radio" name="rdo1" value="NEW" onClick="showActionType();"><font  style="color:ffffff;font-family: Tahoma,Georgia">New Advise No</font>
						&nbsp;&nbsp;&nbsp;&nbsp;<input type="radio" name="rdo1" value="ADD" onClick="showActionType();"><font  style="color:ffffff;font-family: Tahoma,Georgia">Add To Advise No</font>
						&nbsp;&nbsp;<input type="text" style="font-family:Tahoma,Georgia;" name="ADVISE_NO" value="<%=ADVISE_NO%>" size="20"  onKeyDown="return (event.keyCode!=8);" readonly disabled>
						<input type="button" id="bt2" name="btn2" value=".."  onClick="setAdviseNoList();" style="visibility:hidden">
						<!--<input type="hidden" name="CUSTOMER_ID" value="<%=CUSTOMER_ID%>">-->
						<input type="hidden" name="SALESAREA" value="<%=SALESAREA%>">
						<input type="hidden" name="SHIPDATE" value="<%=SHIPDATE%>">
						<input type="hidden" name="SHIPPINGMETHOD" value="<%=SHIPPINGMETHOD%>">
						<input type="hidden" name="TOTW" value="<%=TOTW%>">
						<input type="hidden" name="SHIPFROM" value="<%=SHIPFROM%>">
						<input type="hidden" name="ORGID" value="<%=ORGID%>">
						</td>
					</tr>
				</TABLE>
				<BR>			
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
					<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
						<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
						<td width="2%" align="center">Seq No</td>
						<td width="4%" align="center">內外銷</td>
						<td width="5%" align="center">Sales Region </td>
						<td width="5%" align="center">PC SSD </td>            
						<td width="2%" align="center">Seq</td>
						<td width="6%" align="center">Order Number </td>
						<td width="4%" align="center">Line No </td>
						<td width="7%" align="center">Vendor </td>            
						<td width="9%" align="center">Item Desc </td>            
						<td width="5%" align="center">PC Confirm Qty (K)</td>            
						<td width="3%" align="center">To TW </td>            
						<td width="8%" align="center">Shipping Marks </td>
						<td width="8%" align="center">Customer</td>
						<td width="9%" align="center">Cust PartNo </td>
						<td width="10%" align="center">Customer PO</td>            
						<td width="5%" align="center">Shipping Method </td>            
					</tr>
				
	<%		
			}
			
	%>
					<tr style="font-size:11px" id="tr_<%=rs.getString("PC_ADVISE_ID")%>">
						<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("PC_ADVISE_ID")%>" onClick="setCheck(<%=(icnt)%>)"><input type="hidden" name="CURR_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("CURRENCY_CODE")%>"><input type="hidden" name="SHIPTO_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("SHIP_TO_ORG_ID")%>"></td>
						<td align="center"><%=icnt+1%></td>
						<td align="center"><%=rs.getString("organization_name")%><input type="hidden" name="ORGID_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("organization_id")%>"></td>
						<td><%=(rs.getString("REGION_CODE")==null?"&nbsp;":rs.getString("REGION_CODE"))%><input type="hidden" name="REGION_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("REGION_CODE")%>"></td>
						<td align="center"><input type="text" name="SSD_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("PC_SCHEDULE_SHIP_DATE").replace("/","")%>" size="6" style="font-size:11px;font-family:arial"></td>
						<td align="center"><input type="text" name="SEQ_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=(rs.getString("SEQ_NO")==null?"":rs.getString("SEQ_NO"))%>" size="2" style="font-size:11px;font-family:arial"></td>
						<td><%=rs.getString("SO_NO")%></td>
						<td><%=rs.getString("SO_LINE_NUMBER")%></td>
						<td><%=rs.getString("VENDOR_SITE_CODE")%></td>
						<td><%=rs.getString("ITEM_DESC")%></td>
						<td align="right"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("SHIP_QTY")))%></td>
						<td align="center"><%=(rs.getString("to_tw").equals("Y")?"是":"否")%><input type="hidden" name="TOTW_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("TO_TW")%>"></td>
						<td align="left"><%=(rs.getString("shipping_remark")==null?"&nbsp;":rs.getString("shipping_remark"))%><input type="hidden" name="SHIPPING_MARK_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("shipping_remark")%>"></td>
						<td align="left"><%=rs.getString("CUSTOMER_NAME")%><input type="hidden" name="CUSTOMER_ID_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("CUSTOMER_ID")%>"></td>
						<td><%=(rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))%></td>
						<td align="left"><%=rs.getString("CUST_PO_NUMBER")%></td>
						<td align="left"><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"></td>
					</tr>
	<%
			icnt++;
		}
		if (icnt >0)
		{
	%>
				</table>
				<table width="100%">
					<tr><td align="center"><input type="button" name="save" value="Shipping Advise" style="font-family:Tahoma,Georgia" onClick="setSubmit1('../jsp/TSCSGShippingAdviseProcess.jsp?TRANSTYPE=CONFIRM')">
  				     &nbsp;&nbsp;&nbsp;<input type="button" name="delete1" value="Delete" style="font-family:Tahoma,Georgia" onClick="setSubmit2('../jsp/TSCSGShippingAdviseProcess.jsp?TRANSTYPE=DELETE')"></td></tr>
				</table>
	<%
	
		}
		else
		{
			out.println("<font style='color:#ff0000;font-size:12px'>No Data Found!!</font>");
		}
		rs.close();
		statement.close();
	}
	catch(Exception e)
	{
		out.println("<font style='color:#ff0000;font-size:12px'>Exception Error!!Please contact the system administrator..</font>");
	}
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
<input type="hidden" name="ITEMCNT" value="<%=ITEMCNT%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

