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
		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value = document.MYFORM.elements["SHIP_DATE_"+lineid].value;
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
	if ((document.MYFORM.SDATE.value =="" && document.MYFORM.EDATE.value=="") && document.MYFORM.TSC_MO.value=="")
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
			if (document.MYFORM.elements["VENDORSITE_"+lineid].value ==null || document.MYFORM.elements["VENDORSITE_"+lineid].value  =="--")
			{
				alert("項次"+i+":供應商不可空白!");
				document.MYFORM.elements["VENDORSITE_"+lineid].focus();
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
<title>TW Shipping Advise</title>
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
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null || STATUS.equals("--"))  STATUS="";
String TSC_MO = request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="SSD";
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
	if (UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY")<0 && UserName.indexOf("PERRY.JUAN")<0) //add by Peggy 20211007
	{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
	}
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGShippingAdviseTW.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TW Shipping Advise</font></strong>
<BR>
<table width="100%">
	<tr>
		<td style="color:#0000FF;font-family:arial;font-size:11px">&nbsp;</td>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
		<td width="8%"><font color="#666600" >TSC Prod Group:</font></td>
		<td width="7%">
		<select NAME="TSCPRODGROUP" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE="SSD" <%if (TSCPRODGROUP.equals("SSD")) out.println("selected");%>>SSD</OPTION>
		</select>		
		</td>
		<td width="6%"><font color="#666600" >Sales Region:</font></td>
		<td width="7%">
		<%
		try
		{   
			sql = " SELECT distinct d.group_name,d.group_name "+
			      " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_req e"+
                  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                  " and c.master_group_id=d.master_group_id"+
                  " and d.group_name=e.SALES_GROUP"+
				  " and b.SALES_AREA_NO<>'020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0)) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " union all"+
			       " select distinct ALNAME,ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0)) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " order by 1";
			
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(SALESAREA);
			comboBoxBean.setFieldName("SALESAREA");	
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
		<td width="10%"><font color="#666600" >Schedule Ship Date:</font></td>
		<td width="15%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="6%"><font color="#666600" >Customer:</font></td>
		<td width="8%"><input type="text" name="CUST" value="<%=CUST%>" style="font-family: Tahoma,Georgia;font-size:11px" size="15"></td>
		<td width="8%"><font color="#666600" >Order Number:</font></td>
		<td width="8%"><input type="text" name="TSC_MO" value="<%=TSC_MO%>" style="font-family: Tahoma,Georgia;font-size:11px" size="15" onChange="setChange();"></td>
		<td width="8%"><font color="#666600" >已排出貨通知:</font></td>
		<td width="6%">
		<select NAME="STATUS" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE="--" <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>Y</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>N</OPTION>
		</select>		
		</td>		
	</tr>
	<tr>
		<td align="center" colspan="12">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;font-size:11px" onClick='setSubmit("../jsp/TSCSGShippingAdviseTW.jsp?ACTIONCODE=Q")' >
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	if ( ACTIONCODE.equals("Q"))
	{

		 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
		 cs1.setString(1,"41"); 
		 cs1.execute();
		 cs1.close();
		 
		sql = " SELECT ODR.HEADER_ID,"+
			  " ODR.LINE_ID,"+
			  " TO_CHAR(ODR.ORDER_NUMBER) ORDER_NO,"+
			  " ODR.SOLD_TO_ORG_ID CUSTOMER_ID,"+
			  " RA.CUSTOMER_NUMBER,"+
			  " RA.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME,"+
			  //" Tsc_Intercompany_Pkg.get_sales_group(ODR.HEADER_ID) SALES_GROUP,"+
			  " TSC_OM_Get_Sales_Group(ODR.HEADER_ID) SALES_GROUP,"+
			  " ODR.LINE_NUMBER||'.'||ODR.shipment_NUMBER  line_no,"+
			  " ODR.INVENTORY_ITEM_ID,"+
			  " ODR.CUSTOMER_LINE_NUMBER CUST_PO,"+
			  " ODR.CUSTOMER_SHIPMENT_NUMBER CUST_PO_LINE,"+
			  " DECODE(ODR.ITEM_IDENTIFIER_TYPE,'CUST',ODR.ORDERED_ITEM,'') CUST_ITEM,"+
			  " NVL(ODR.ORDERED_QUANTITY,0) ORDERED_QUANTITY,"+
			  " ODR.ORDER_QUANTITY_UOM UOM,"+
			  " lc.meaning SHIP_METHOD,"+
			  " TRUNC(ODR.REQUEST_DATE) REQUEST_DATE,"+
			  " TRUNC(ODR.SCHEDULE_SHIP_DATE) SCHEDULE_SHIP_DATE,"+
			  " ODR.PACKING_INSTRUCTIONS PLANT_CODE,"+
			  " ODR.FOB,"+
			  " TERM.NAME PAYMENT_TERM,"+
			  " ODR.SHIP_FROM_ORG_ID,"+
			  " ODR.SHIP_TO_ORG_ID,"+
			  " ODR.INVOICE_TO_ORG_ID,"+
			  " ODR.deliver_to_org_id,"+
			  " ODR.ship_to_contact_id,"+
			  " ODR.FLOW_STATUS_CODE STATUS,"+
			  " ODR.HOLD_REASON,"+
			  " ODR.HOLD_REASON_CODE,"+
			  " NVL(hd.meaning,'N') HOLD_REASON_NAME,"+
			  " ODR.TSC_PROD_GROUP,"+
			  " ODR.ORG_ID,"+
			  " NVL(RA1.CUSTOMER_NAME,ODR.END_CUSTOMER_NAME) END_CUSTOMER_NAME,"+
			  " ADV.PC_SHIP_QTY,"+
			  " ADV.TOT_SHIP_QTY,"+
			  " ODR.DESCRIPTION,"+
			  " CASE WHEN NVL(ADV.PC_SHIP_QTY,0)>0 THEN 'Y' ELSE 'N' END SHIPPING_ADVISE_STATUS"+
			  " FROM (SELECT h.ORG_ID"+
			  "      ,H.HEADER_ID"+
			  "      ,h.ORDER_NUMBER"+
			  "      ,H.SOLD_TO_ORG_ID"+
			  "      ,H.SALESREP_ID"+
			  "      ,h.ORDER_TYPE_ID"+
			  "      ,NVL(L.payment_term_id,H.payment_term_id) payment_term_id"+
			  "      ,L.PACKING_INSTRUCTIONS"+
			  "      ,L.SHIPPING_METHOD_CODE"+
			  "      ,L.SCHEDULE_SHIP_DATE"+
			  "      ,NVL(L.ATTRIBUTE20,'N') HOLD_REASON_CODE "+
			  "      ,L.LINE_ID"+
			  "      ,L.inventory_item_id"+
			  "      ,TSC_INV_Category(L.inventory_item_id, 43, 1100000003) TSC_PROD_GROUP"+
			  "      ,L.LINE_NUMBER"+
			  "      ,L.END_CUSTOMER_ID"+
			  "      ,NVL(L.ATTRIBUTE13,'') END_CUSTOMER_NAME"+
			  "      ,NVL(L.ATTRIBUTE5,'') HOLD_REASON"+
			  "      ,L.FLOW_STATUS_CODE"+
			  "      ,L.SHIP_FROM_ORG_ID"+
			  "      ,NVL(L.FOB_POINT_CODE,H.FOB_POINT_CODE) FOB"+
			  "      ,L.REQUEST_DATE"+
			  "      ,L.ORDER_QUANTITY_UOM"+
			  "      ,L.shipment_NUMBER "+
			  "      ,L.CUSTOMER_LINE_NUMBER"+
			  "      ,L.CUSTOMER_SHIPMENT_NUMBER"+
			  "      ,L.ITEM_IDENTIFIER_TYPE"+
			  "      ,L.ORDERED_ITEM"+
			  "      ,L.ORDERED_QUANTITY"+
			  "      ,L.SHIP_TO_ORG_ID"+
			  "      ,L.INVOICE_TO_ORG_ID"+
			  "      ,L.deliver_to_org_id"+
			  "      ,L.ship_to_contact_id"+
			  "      ,L.CANCELLED_FLAG"+
			  "      ,MSI.DESCRIPTION"+
			  "      FROM ONT.OE_ORDER_HEADERS_ALL h"+
			  "      ,ONT.OE_ORDER_LINES_ALL L "+
			  "      ,INV.MTL_SYSTEM_ITEMS_B MSI"+
			  "      WHERE H.HEADER_ID=L.HEADER_ID"+
			  "      AND L.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID"+
			  "      AND MSI.ORGANIZATION_ID=43"+
			  "      AND H.ORG_ID=41"+
			  "      ) ODR,"+
			  " RA_SALESREPS R,"+
			  " AR_CUSTOMERS RA,"+
			  " AR_CUSTOMERS RA1,"+
			  " ra_terms_tl term,"+
			  " ONT.OE_ORDER_HEADERS_ALL X,"+
			  " (SELECT TSAP.SO_NO,SUBSTR(TSAP.SO_LINE_NUMBER,1,INSTR(TSAP.SO_LINE_NUMBER,'.')-1) LINE_NO,SUM(TSAP.SHIP_QTY) PC_SHIP_QTY ,SUM(TSAL.SHIP_QTY) TOT_SHIP_QTY"+
			  " FROM TSC.TSC_SHIPPING_ADVISE_PC TSAP"+
			  ",TSC.TSC_SHIPPING_ADVISE_LINES TSAL"+
			  " WHERE TSAP.PC_ADVISE_ID=TSAL.PC_ADVISE_ID"+
			  " GROUP BY TSAP.SO_NO,SUBSTR(TSAP.SO_LINE_NUMBER,1,INSTR(TSAP.SO_LINE_NUMBER,'.')-1)) ADV,"+
			  " (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES WHERE LOOKUP_TYPE='SHIP_METHOD' AND LANGUAGE='US' AND ENABLED_FLAG='Y') lc,"+
			  " (SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES WHERE LOOKUP_TYPE= 'YES_NO_HOLD'  AND LANGUAGE='US' AND ENABLED_FLAG='Y') hd"+
			  " WHERE ODR.SALESREP_ID = R.SALESREP_ID"+
			  " AND ODR.SOLD_TO_ORG_ID = RA.CUSTOMER_ID"+
			  " AND ODR.END_CUSTOMER_ID=RA1.CUSTOMER_ID(+)"+
			  " AND ODR.payment_term_id =term.term_id"+
			  " AND term.LANGUAGE='US'"+
			  " AND ODR.SHIPPING_METHOD_CODE = lc.lookup_code (+)"+
			  " AND ODR.HOLD_REASON_CODE=hd.lookup_code (+)"+
			  " AND X.ORG_ID=906 "+
			  " AND X.ORDER_NUMBER=ODR.ORDER_NUMBER"+
			  " AND ODR.ORDER_NUMBER=ADV.SO_NO(+)"+
			  " AND ODR.LINE_NUMBER=ADV.LINE_NO(+)"+
			  " AND ODR.PACKING_INSTRUCTIONS IN ('T')"+
			  " AND ODR.CANCELLED_FLAG != 'Y'"+
			  " AND ODR.FLOW_STATUS_CODE IN ('ENTERED','BOOKED','AWAITING_SHIPPING','AWAITING_APPROVE')"+
			  " AND ODR.ORDER_TYPE_ID not in ('1114','1091','1016','1020','1017','1019','1018') ";
		if (!SDATE.equals(""))
		{
			sql += " AND ODR.SCHEDULE_SHIP_DATE BETWEEN to_date('"+SDATE+"','yyyymmdd') and to_date('"+(EDATE.equals("")?"20991231":EDATE)+"','yyyymmdd')+0.99999";
		}
		else if (!EDATE.equals(""))
		{
			sql += " AND ODR.SCHEDULE_SHIP_DATE BETWEEN add_months(TRUNC(SYSDATE),-36) and to_date('"+EDATE+"','yyyymmdd')+0.99999 ";
		}
		if (!TSCPRODGROUP.equals("--") && !TSCPRODGROUP.equals(""))
		{
			sql += " AND ODR.TSC_PROD_GROUP='"+TSCPRODGROUP+"'";
		}	  
		if (!SALESAREA.equals("--") && !SALESAREA.equals(""))
		{
			//sql += " AND Tsc_Intercompany_Pkg.get_sales_group(ODR.HEADER_ID) ='" + SALESAREA+"'";
			sql += " AND TSC_OM_Get_Sales_Group(ODR.HEADER_ID) ='" + SALESAREA+"'";
		}
		if (!TSC_MO.equals(""))
		{
			sql += " AND ODR.ORDER_NO= '"+TSC_MO+"'";
		}
		if (!CUST.equals(""))
		{
			sql += " AND (RA.CUSTOMER_NUMBER like '%"+CUST+"%' or NVL(RA1.CUSTOMER_NAME,ODR.END_CUSTOMER_NAME)  like '%"+CUST+"%')";
		}
		if (!STATUS.equals("") && !STATUS.equals("--"))
		{
			sql += " and NVL(ADV.PC_SHIP_QTY,0)>0";
		}
		sql += " ORDER BY ODR.SCHEDULE_SHIP_DATE,ODR.ORDER_NUMBER"; 
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		while (rs.next())
		{
			if (icnt ==0)
			{
	%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
				<tr bgcolor="#C8E3E8" style="font-family:Tahoma,Georgia;font-size:11px" align="center">
					<td width="3%">Seq</td>
					<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="6%">Schedule Ship Date</td>
					<td width="6%">Shippine Method</td>
					<td width="3%">Hold</td>
					<td width="5%">Hold Reason</td>
					<td width="6%">Region#</td>
					<td width="6%">MO#</td>
					<td width="3%">Line#</td>
					<td width="11%">TSC PartNo</td>
					<td width="5%">Order Qty(PCE)</td>
					<td width="5%">Cust PO#(PCE)</td>
					<td width="9%">Cust PO Line#</td>
					<td width="6%">Request Date</td>
					<td width="6%">Schedule Ship Date</td>
					<td width="6%">Shippine Method</td>
					<td width="6%">End Customer</td>
					<td width="6%">已排出貨通知</td>
				</tr>
			
	<%		
			}
			
	%>
				<tr id="tr_<%=rs.getString("line_id")%>"  <%=(!rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") && rs.getString("HOLD_REASON").toUpperCase().equals("N")? "style='font-family:airl;font-size:11px'":" style='font-family:airl;font-size:11px;background-color:#FFFF66' title='Order status is hold'")%>>
					<td align="left"><%=(icnt+1)%></td>
					<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("line_id")%>" onClick="setCheck(<%=icnt%>)" <%=(rs.getString("STATUS").toUpperCase().equals("AWAITING_APPROVE") || !rs.getString("HOLD_REASON").toUpperCase().equals("N") || rs.getString("STATUS").toUpperCase().equals("ENTERED")?" disabled":"")%>></td>
					<td align="center"><input type="text" name="NEW_SSD_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial"></td>
					<td align="center"><input type="text" name="NEW_SHIPPING_METHOD_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial"></td>
					<td align="center"><input type="text" name="HOLD_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial"></td>
					<td align="center"><input type="text" name="HOLD_REASON_<%=rs.getString("line_id")%>" valu="" size="6" style="text-align:right;font-size:11px;font-family:arial"></td>
					<td align="left"><%=rs.getString("SALES_GROUP")%><input type="hidden" name="SALES_GROUP_<%=rs.getString("line_id")%>" value="<%=rs.getString("SALES_GROUP")%>"></td>
					<td align="center"><%=rs.getString("ORDER_NUMBER")%><input type="hidden" name="ORDER_NUMBER_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDER_NUMBER")%>"></td>
					<td align="center"><%=rs.getString("line_no")%></td>
					<td align="left"><%=rs.getString("DESCRIPTION")%><input type="hidden" name="ITEMID_<%=rs.getString("line_id")%>" value="<%=rs.getString("INVENTORY_ITEM_ID")%>"></td>
					<td align="right"><%=rs.getString("ORDERED_QUANTITY")%><input type="hidden" name="ORDERED_QUANTITY_<%=rs.getString("line_id")%>" value="<%=rs.getString("ORDERED_QUANTITY")%>"></td>
					<td align="left"><%=rs.getString("CUSTOMER_PO")%></td>
					<td align="left"><%=rs.getString("CUST_PO_LINE")%></td>
					<td align="center"><%=rs.getString("REQUEST_DATE")%><input type="hidden" name="REQUEST_DATE_<%=rs.getString("line_id")%>" value="<%=rs.getString("REQUEST_DATE").replace("/","")%>"></td>
					<td align="center"><%=rs.getString("SCHEDULE_SHIP_DATE")%><input type="hidden" name="SHIP_DATE_<%=rs.getString("line_id")%>" value="<%=rs.getString("SCHEDULE_SHIP_DATE").replace("/","")%>"></td>
					<td align="left"><%=(rs.getString("SHIP_METHOD")==null?"&nbsp;":rs.getString("SHIP_METHOD"))%><input type="hidden" name="SHIP_METHOD_<%=rs.getString("line_id")%>" value="<%=(rs.getString("SHIP_METHOD")==null?"":rs.getString("SHIP_METHOD"))%>"></td>
					<td align="left"><%=rs.getString("END_CUSTOMER_NAME")%></td>
					<td align="left"><%=(rs.getString("SHIPPING_ADVISE_STATUS")==null?"N":rs.getString("SHIPPING_ADVISE_STATUS"))%></td>
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
				<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGShippingAdviseProcessTW.jsp')"></td></tr>
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
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
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

