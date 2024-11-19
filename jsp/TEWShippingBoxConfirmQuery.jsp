<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
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
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (i!=irow && document.MYFORM.chk[i].checked==true)
			{		
				if (document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value != document.MYFORM.elements["VENDOR_SITE_ID_"+document.MYFORM.chk[i].value].value)			
				{
					alert("不同供應商不可合併編箱!");
					document.MYFORM.chk[irow].checked=false;
					return false;					
				}												
				//else if (document.MYFORM.elements["CUSTOMER_ID_"+lineid].value != document.MYFORM.elements["CUSTOMER_ID_"+document.MYFORM.chk[i].value].value)
				//{
				//	alert("不同客戶不可合併編箱!");
				//	document.MYFORM.chk[irow].checked=false;
				//	return false;
				//}
				else if (document.MYFORM.elements["REGION_"+lineid].value != document.MYFORM.elements["REGION_"+document.MYFORM.chk[i].value].value && document.MYFORM.elements["REGION_"+lineid].value=="TSCC-SH" && document.MYFORM.elements["REGION_"+document.MYFORM.chk[i].value].value !="TSCH-HK")
				{
					alert("不同業務區不可合併編箱!");
					document.MYFORM.chk[irow].checked=false;
					return false;				
				} 	
				else if (document.MYFORM.elements["SHIPPING_METHOD_"+lineid].value != document.MYFORM.elements["SHIPPING_METHOD_"+document.MYFORM.chk[i].value].value)			
				{
					alert("不同出貨方式不可合併編箱!");
					document.MYFORM.chk[irow].checked=false;
					return false;					
				}
				else if (document.MYFORM.elements["SSD_"+lineid].value != document.MYFORM.elements["SSD_"+document.MYFORM.chk[i].value].value)			
				{
					alert("不同出貨日期不可合併編箱!");
					document.MYFORM.chk[irow].checked=false;
					return false;					
				}				
				//else if (document.MYFORM.elements["CURR_"+lineid].value != document.MYFORM.elements["CURR_"+document.MYFORM.chk[i].value].value)			
				//{
				//	alert("不同幣別不可合併編箱!");
				//	document.MYFORM.chk[irow].checked=false;
				//	return false;					
				//}
				else if (document.MYFORM.elements["TOTW_"+lineid].value != document.MYFORM.elements["TOTW_"+document.MYFORM.chk[i].value].value)			
				{
					alert("回T與直出不可合併編箱!");
					document.MYFORM.chk[irow].checked=false;
					return false;					
				}
			}
		}
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}
function setAddCheckBox()
{
	if (document.MYFORM.chkadd.checked)
	{
		document.MYFORM.ADVISE_NO.value="";
		document.MYFORM.ADVISE_NO.disabled=false;
		document.getElementById("btn2").style.Visibility ="visible";
		//document.MYFORM.CUSTOMER_ID.value="";		
		document.MYFORM.SALESAREA.value="";		
		document.MYFORM.VENDORFORM.value="";		
		document.MYFORM.SHIPDATE.value="";		
		document.MYFORM.SHIPPINGMETHOD.value="";		
		document.MYFORM.TOTW.value="";		
		//document.MYFORM.CURR.value="";	
		//document.MYFORM.SHIPTO.value="";	
	}
	else
	{
		document.MYFORM.ADVISE_NO.value="";
		document.MYFORM.ADVISE_NO.disabled=true;
		document.getElementById("btn2").style.Visibility ="hidden";
		//document.MYFORM.CUSTOMER_ID.value="";		
		document.MYFORM.SALESAREA.value="";		
		document.MYFORM.VENDORFORM.value="";		
		document.MYFORM.SHIPDATE.value="";		
		document.MYFORM.SHIPPINGMETHOD.value="";		
		document.MYFORM.TOTW.value="";		
		//document.MYFORM.CURR.value="";		
		//document.MYFORM.SHIPTO.value="";	
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
	subWin=window.open("../jsp/subwindow/TEWAdviseNoListFind.jsp?TYPE=BOX&ADVISENO="+lineid,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.chkadd.checked==true)
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
			if (document.MYFORM.chkadd.checked==true)
			{
				if (document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value != document.MYFORM.VENDORFORM.value)
				{
					if ((document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value != "311965" && document.MYFORM.elements["VENDOR_SITE_ID_"+lineid].value != "102965") &&  (document.MYFORM.VENDORFORM.value !="311965" && document.MYFORM.VENDORFORM.value !="102965"))
					{
						alert("項次"+i+":供應商不相符!");
						return false;		
					}		
				}
				//if (document.MYFORM.elements["CUSTOMER_ID_"+lineid].value != document.MYFORM.CUSTOMER_ID.value)
				//{
				//	alert("項次"+i+":客戶不相符!");
				//	return false;				
				//}
				if (document.MYFORM.elements["REGION_"+lineid].value != document.MYFORM.SALESAREA.value && document.MYFORM.elements["REGION_"+lineid].value =="TSCC-SH" && document.MYFORM.SALESAREA.value !="TSCH-HK")
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
				///}					
			}																		
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	document.MYFORM.btncfm.disabled=true;
	document.MYFORM.btnadd.disabled=true;
	document.MYFORM.btnqry.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TEW Shipping出貨編箱確認</title>
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
String S_ADVISE_NO = request.getParameter("S_ADVISE_NO");
if (S_ADVISE_NO==null) S_ADVISE_NO="%";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String CUSTOMER_ID=request.getParameter("CUSTOMER_ID");
if (CUSTOMER_ID==null) CUSTOMER_ID="";
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
String sql = "";
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
<FORM ACTION="../jsp/TEWShippingBoxConfirmQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨編箱確認</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">Advise No:</font></td>
		<td width="90%"><input type="text" name="S_ADVISE_NO"  style="font-family: Tahoma,Georgia;" value="<%=S_ADVISE_NO%>">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" name="btnqry" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TEWShippingBoxConfirmQuery.jsp")' ></td>
	</tr>
</table> 
<HR>
<%
try
{
	/*
	sql = " select  b.orig_advise_no advise_no"+
	      //",b.customer_id"+
		  //",b.CUSTOMER_NAME CUSTOMER"+
		  ",case when b.to_tw ='Y' THEN 'TSCT' ELSE b.region_code END REGION_CODE"+
		  ",b.SHIPPING_METHOD"+
		  ",c.vendor_site_id"+
		  ",c.vendor_site_code"+
		  ",b.to_tw"+
		  ",TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD"+
		  //",b.ship_to_org_id"+
		  //",b.CURRENCY_CODE"+
		  ",count(1) rowcnt"+
		  " from tsc.tsc_shipping_advise_pc_tew b"+
		  ",ap.ap_supplier_sites_all c"+
		  " where b.vendor_site_id = c.vendor_site_id"+
		  " and b.shipping_from =?"+ 
		  " and not exists (select 1 from tsc.tsc_shipping_advise_lines x where x.pc_advise_id = b.pc_advise_id)"+
		  " and b.advise_no like ?"+
		  //" group by b.orig_advise_no,b.CUSTOMER_ID,b.CUSTOMER_NAME,b.region_code,b.SHIPPING_METHOD,c.vendor_site_id,c.vendor_site_code,b.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') ,b.CURRENCY_CODE,b.ship_to_org_id"+
		  " group by b.orig_advise_no,case when b.to_tw ='Y' THEN 'TSCT' ELSE b.region_code END,b.SHIPPING_METHOD,c.vendor_site_id,c.vendor_site_code,b.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')"+		  
		  " order by b.orig_advise_no,b.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') ";
	*/
	sql = " select x.*,(select count(1) from tsc.tsc_shipping_advise_pc_tew a where a.orig_advise_no= x.advise_no) rowcnt "+
          " from (select  b.orig_advise_no advise_no"+
          "               ,case when b.to_tw ='Y' THEN 'TSCT' ELSE b.region_code END REGION_CODE"+
          "               ,b.SHIPPING_METHOD"+
          "               ,c.vendor_site_id"+
          "               ,c.vendor_site_code"+
          "               ,b.to_tw"+
          "               ,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD"+
          "               ,ROW_NUMBER() OVER(PARTITION BY b.advise_no order by 1) row_num"+
          "                from tsc.tsc_shipping_advise_pc_tew b"+
          "               ,ap.ap_supplier_sites_all c"+
          "                where b.vendor_site_id = c.vendor_site_id"+
          "                and b.shipping_from =?"+
          "                and not exists (select 1 from tsc.tsc_shipping_advise_lines x where x.pc_advise_id = b.pc_advise_id)"+
          "                and b.advise_no like ?"+
          "                group by b.advise_no,b.pc_advise_id,b.orig_advise_no,case when b.to_tw ='Y' THEN 'TSCT' ELSE b.region_code END,b.SHIPPING_METHOD,c.vendor_site_id,c.vendor_site_code,b.to_tw,TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')) x "+
          " where row_num=1"+
          " order by x.advise_no,x.to_tw,x.SSD";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"TEW");
	statement.setString(2,S_ADVISE_NO+"%");
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	while (rs.next())
	{
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
			<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
				<td width="3%">項次</td>
				<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
				<td width="10%" align="center">Advise No</td>
				<td width="10%" align="center">供應商</td>
				<td width="10%" align="center">業務區</td>
				<td width="10%" align="center">出貨方式</td>
				<td width="10%" align="center">排定出貨日</td>
				<td width="5%" align="center">回T</td>
				<td width="5%" align="center">出貨筆數</td>
			</tr>
		
<%
		}
%>
			<tr style="font-family:airl;font-size:11px" id="tr_<%=rs.getString("ADVISE_NO")%>">
				<td align="left"><%=(icnt+1)%></td>
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("ADVISE_NO")%>" onClick="setCheck(<%=icnt%>)"></td>
				<td><%=rs.getString("ADVISE_NO")%></td>
				<td><%=rs.getString("VENDOR_SITE_CODE")%><input type="hidden" name="VENDOR_SITE_ID_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("vendor_site_id")%>"></td>
				<td><%=rs.getString("REGION_CODE")%><input type="hidden" name="REGION_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("REGION_CODE")%>"></td>
				<td><%=rs.getString("SHIPPING_METHOD")%><input type="hidden" name="SHIPPING_METHOD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SHIPPING_METHOD")%>"></td>
				<td align="center"><%=rs.getString("SSD")%><input type="hidden" name="SSD_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SSD")%>"></td>
				<td align="center"><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%><input type="hidden" name="TOTW_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("TO_TW")%>"></td>
				<td align="right"><%=rs.getString("rowcnt")%></td>
			</tr>
<%
		icnt++;
	}
	if (icnt >0)
	{
%>
		</table>
		<hr>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#DCE6E7">
			<tr>
				<td style="border-left-style:none;border-right-style:none">
				<input type="checkbox" name="chkadd" value="ADD" onClick="setAddCheckBox();"><font  style="color:000000;font-family: Tahoma,Georgia">Add To Advise No</font>
				&nbsp;&nbsp;<input type="text" style="font-family:Tahoma,Georgia;" name="ADVISE_NO" value="<%=ADVISE_NO%>" size="20"  onKeyDown="return (event.keyCode!=8);" readonly disabled>
				<input type="button" id="btn2" name="btnadd" value=".."  onClick="setAdviseNoList();">
				<!--<input type="hidden" name="CUSTOMER_ID" value="<%=CUSTOMER_ID%>">-->
				<input type="hidden" name="SALESAREA" value="<%=SALESAREA%>">
				<input type="hidden" name="VENDORFORM" value="<%=VENDORFORM%>">
				<input type="hidden" name="SHIPDATE" value="<%=SHIPDATE%>">
				<input type="hidden" name="SHIPPINGMETHOD" value="<%=SHIPPINGMETHOD%>">
				<input type="hidden" name="TOTW" value="<%=TOTW%>">
				<!--<input type="hidden" name="CURR" value="<%=CURR%>">-->
				<!--<input type="hidden" name="SHIPTO" value="<%=SHIPTO%>">-->
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<input type="button" name="btncfm" value="進入編箱確認畫面" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TEWShippingBoxConfirm.jsp')"></td>
			</tr>
		</table>		
<%
	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>目前無待編箱資料,請重新確認,謝謝!</strong></font></div>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

