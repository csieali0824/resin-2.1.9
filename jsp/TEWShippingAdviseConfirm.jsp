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
	//if (document.MYFORM.SDATE.value =="" || document.MYFORM.EDATE.value=="")
	//{
	//	alert("請輸入排定出貨日!");
	//	if (document.MYFORM.SDATE.value =="")
	//	{
	//		document.MYFORM.SDATE.focus();
	//	}
	//	else
	//	{	
	//		document.MYFORM.EDATE.focus();
	//	}
	//	return false;
	//}
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
				if (document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value != document.MYFORM.VENDORFORM.value)
				{
					alert("項次"+i+":供應商不相符!");
					return false;				
				}
				//if (document.MYFORM.elements["CUSTOMER_ID_"+lineid].value != document.MYFORM.CUSTOMER_ID.value)
				//{
				//	alert("項次"+i+":客戶不相符!");
				//	return false;				
				//}
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
				//if (document.MYFORM.elements["CURR_"+lineid].value != document.MYFORM.CURR.value)
				//{
				//	alert("項次"+i+":幣別不相符!");
				//	return false;				
				//}
				//if (document.MYFORM.elements["SHIPTO_"+lineid].value != document.MYFORM.SHIPTO.value)
				//{
				//	alert("項次"+i+":SHIP TO不相符!");
				//	return false;				
				//}	
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
		alert("請先勾選資料!");
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
		alert("請先勾選資料!");
		return false;
	}
	else if (confirm("您確定要刪除資料?")==true)
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
		alert("請先勾選資料!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TEWAdviseNoListFind.jsp?SSD="+document.MYFORM.elements["SSD_"+lineid].value,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function popMenuMsg(unitPrice)
{
	alert("PO Price="+unitPrice);
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
<title>TEW 出貨通知確認</title>
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
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String VENDORFORM = request.getParameter("VENDORFORM");
if (VENDORFORM==null) VENDORFORM="";
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
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String TOTW1 = request.getParameter("TOTW1");
if (TOTW1==null) TOTW1="";
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
<FORM ACTION="../jsp/TEWShippingAdviseConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:18px;color:#000099">TEW 出貨通知確認</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="10%" bgcolor="#D3E6F3"  style="color:#006666">排定出貨日:</td>   
		<td width="30%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="7%" bgcolor="#D3E6F3"  style="color:#006666">業務區:</td> 
		<td width="10%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select  tsa.REGION_CODE from  tsc.tsc_shipping_advise_pc_tew tsa "+
                  " where tsa.shipping_from ='TEW'"+
                  " and tsa.VENDOR_SITE_ID is not null"+
                  " and tsa.advise_NO is null"+
                  " group by  tsa.REGION_CODE "+
                  " order by 1";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='SALESAREANO' style='font-family:arial'>");
			out.println("<OPTION VALUE=--"+ (SALESAREANO.equals("") || SALESAREANO.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (SALESAREANO.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(1));
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
		<td width="7%" bgcolor="#D3E6F3"  style="color:#006666">供應商:</td> 
		<td width="10%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select ass.vendor_site_id, ass.vendor_site_code from  tsc.tsc_shipping_advise_pc_tew tsa ,ap.ap_supplier_sites_all  ass"+
                  " where tsa.shipping_from ='TEW'"+
                  " and tsa.VENDOR_SITE_ID is not null"+
                  " and tsa.advise_NO is null"+
                  " and tsa.vendor_site_id = ass.vendor_site_id"+
                  " group by  ass.vendor_site_id,ass.vendor_site_code"+
                  " order by 1";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='VENDOR' style='font-family:arial'>");
			out.println("<OPTION VALUE=--"+ (VENDOR.equals("") || VENDOR.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (VENDOR.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
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
		<td width="5%" bgcolor="#D3E6F3"  style="color:#006666">回T:</td> 
		<td width="7%">
		<select NAME="TOTW1" style="font-family:arial">
		<OPTION VALUE="--" <%=(TOTW1.equals("") || TOTW1.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="N" <%=(TOTW1.equals("N")?" selected ":"")%>>否
        <OPTION VALUE="Y" <%=(TOTW1.equals("Y")?" selected ":"")%>>是
		</select>
		</td>		
		<td width="14%">		
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TEWShippingAdviseConfirm.jsp?ACTIONCODE=Q")' >
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
			  " ass.vendor_site_code,"+
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
			  " tsa.vendor_site_id,"+
			  " tsa.CURRENCY_CODE,"+
			  " tsa.CUSTOMER_ID,"+
			  " tsa.SHIP_TO_ORG_ID,"+
			  " tsa.seq_no"+
			  " FROM tsc.tsc_shipping_advise_pc_tew tsa,"+
			  " ap.ap_supplier_sites_all  ass ,"+
			  " ONT.OE_ORDER_LINES_ALL oolla,"+
			  " AR_CUSTOMERS ra"+
			  " where tsa.shipping_from ='TEW'"+
			  " and tsa.vendor_site_id = ass.vendor_site_id(+)"+
			  " and tsa.so_line_id = oolla.line_id(+)"+
			  " and tsa.CUSTOMER_ID = ra.CUSTOMER_ID(+)"+
			  " and tsa.VENDOR_SITE_ID is not null"+
			  " and tsa.advise_NO is null";
		if (!SDATE.equals("") && SDATE !=null)
		{
			sql += " and tsa.PC_SCHEDULE_SHIP_DATE >= TO_DATE('"+SDATE+"','yyyymmdd')";
		}
		if (!EDATE.equals("") && EDATE !=null)
		{
			sql += " and tsa.PC_SCHEDULE_SHIP_DATE <= TO_DATE('"+EDATE+"','yyyymmdd')";
		}
		if (SALESAREANO != null && !SALESAREANO.equals("--") && !SALESAREANO.equals(""))
		{
			sql += " and tsa.REGION_CODE = '" + SALESAREANO +"'";
		}
		if (VENDOR != null && !VENDOR.equals("--") && !VENDOR.equals(""))
		{
			sql += " and tsa.vendor_site_id = '" + VENDOR +"'";
		}	
		if (TOTW1 != null && !TOTW1.equals("--") && !TOTW1.equals(""))
		{
			sql += " and tsa.to_tw='"+TOTW1+"'";
		}
		sql += " order by ass.vendor_site_code,tsa.REGION_CODE,tsa.PC_SCHEDULE_SHIP_DATE,tsa.SHIPPING_METHOD, RA.CUSTOMER_NAME_PHONETIC,tsa.SHIPPING_METHOD,tsa.PC_ADVISE_ID";
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
						<input type="hidden" name="VENDORFORM" value="<%=VENDORFORM%>">
						<input type="hidden" name="SHIPDATE" value="<%=SHIPDATE%>">
						<input type="hidden" name="SHIPPINGMETHOD" value="<%=SHIPPINGMETHOD%>">
						<input type="hidden" name="TOTW" value="<%=TOTW%>">
						<!--<input type="hidden" name="CURR" value="<%=CURR%>">-->
						<!--<input type="hidden" name="SHIPTO" value="<%=SHIPTO%>">-->
						</td>
					</tr>
				</TABLE>
				<BR>			
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
					<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
						<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
						<td width="5%" align="center">供應商</td>
						<td width="6%" align="center">採購單號</td>
						<td width="6%" align="center">業務區</td>
						<td width="5%" align="center">出貨日</td>            
						<td width="2%" align="center">序號</td>
						<td width="6%" align="center">訂單號碼</td>
						<td width="4%" align="center">訂單項次</td>
						<td width="11%" align="center">型號</td>            
						<td width="5%" align="center">出貨量(K)</td>            
						<td width="3%" align="center">回T</td>            
						<td width="10%" align="center">嘜頭</td>
						<td width="10%" align="center">客戶</td>
						<td width="9%" align="center">客戶品號</td>
						<td width="11%" align="center">客戶PO</td>            
						<td width="5%" align="center">出貨方式</td>            
					</tr>
				
	<%		
			}
			
			po_list="";
			sql = " select distinct pha.segment1 po_no,tspp.PO_UNIT_PRICE from tsc.tsc_shipping_po_price tspp, po.po_headers_all pha"+
			      " where tspp.pc_advise_id=? and tspp.po_header_id = pha.po_header_Id";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,rs.getString("pc_advise_id"));
			ResultSet rs1=statement1.executeQuery();
			while (rs1.next())
			{
				po_list += (!po_list.equals("")?"<br>":"")+"<a href=javaScript:popMenuMsg('"+rs1.getString("PO_UNIT_PRICE")+"')  onMouseOver="+'"'+"this.T_WIDTH=80;return escape("+rs1.getString("PO_UNIT_PRICE")+")"+'"'+">"+rs1.getString("po_no")+"</a>";
			}
			if (po_list.equals("")) po_list ="&nbsp;";
			rs1.close();
			statement1.close();
	%>
					<tr style="font-size:11px" id="tr_<%=rs.getString("PC_ADVISE_ID")%>">
						<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("PC_ADVISE_ID")%>" onClick="setCheck(<%=(icnt)%>)"><input type="hidden" name="CURR_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("CURRENCY_CODE")%>"><input type="hidden" name="SHIPTO_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("SHIP_TO_ORG_ID")%>"></td>
						<td align="center"><%=rs.getString("vendor_site_code")%><input type="hidden" name="VENDOR_SITE_ID_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("vendor_site_id")%>"></td>
						<td><%=po_list%></td>
						<td><%=(rs.getString("REGION_CODE")==null?"&nbsp;":rs.getString("REGION_CODE"))%><input type="hidden" name="REGION_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("REGION_CODE")%>"></td>
						<td align="center"><input type="text" name="SSD_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=rs.getString("PC_SCHEDULE_SHIP_DATE").replace("/","")%>" size="6" style="font-size:11px;font-family:arial"></td>
						<td align="center"><input type="text" name="SEQ_<%=rs.getString("PC_ADVISE_ID")%>" value="<%=(rs.getString("SEQ_NO")==null?"":rs.getString("SEQ_NO"))%>" size="2" style="font-size:11px;font-family:arial"></td>
						<td><%=rs.getString("SO_NO")%></td>
						<td><%=rs.getString("SO_LINE_NUMBER")%></td>
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
					<tr><td align="center"><input type="button" name="save" value="出貨通知確認" style="font-family:'細明體'" onClick="setSubmit1('../jsp/TEWShippingAdviseProcess.jsp?TRANSTYPE=CONFIRM')">
  				     &nbsp;&nbsp;&nbsp;<input type="button" name="delete1" value="刪除" style="font-family:'細明體'" onClick="setSubmit2('../jsp/TEWShippingAdviseProcess.jsp?TRANSTYPE=DELETE')"></td></tr>
				</table>
	<%
	
		}
		else
		{
			out.println("<font style='color:#ff0000;font-size:12px'>查無待確認資料!!</font>");
		}
		rs.close();
		statement.close();
	}
	catch(Exception e)
	{
		out.println("<font style='color:#ff0000;font-size:12px'>搜尋資料發生異常!!請洽系統管理人員,謝謝!</font>");
	}
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

