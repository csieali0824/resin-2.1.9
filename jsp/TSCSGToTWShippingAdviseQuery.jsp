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
		document.getElementById("tr_"+lineid).style.backgroundColor ="#CFC9D8";
		//document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value = document.MYFORM.elements["SHIP_DATE_"+lineid].value;
		//document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value = document.MYFORM.elements["ORDERED_QTY_"+lineid].value;		
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		//document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value = "";
		//document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value = "";
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
			//if (document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value ==null || document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value  =="")
			//{
			//	alert("項次"+i+":排定出貨日不可空白!");
			//	document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//	return false;
			//}
			//else if (document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.length!=8)
			//{
			//	alert("項次"+i+":排定出貨日格式錯誤(正確格式為YYYYMMDD)!!");
			//	document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//	return false;			
			//}
			//else
			//{
			//	rec_year = document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(0,4);
			//	rec_month= document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(4,2);
			//	rec_day  = document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].value.substr(6,2);
			//	if (rec_month <1 || rec_month >12)
			//	{
			//		alert("項次"+i+":排定出貨月份有誤!!");
			//		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//		return false;			
			//	}	
			//	else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
			//	{
			//		alert("項次"+i+":排定出貨日期有誤!!");
			//		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//		return false;			
			//	} 
			//	else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
			//	{
			//		alert("項次"+i+":排定出貨日期有誤!!");
			//		document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//		return false;			
			//	} 
			//	else if (rec_month == 2)
			//	{
			//		if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
			//		{
			//			alert("項次"+i+":排定出貨日期有誤!!");
			//			document.MYFORM.elements["ACT_SHIP_DATE_"+lineid].focus();
			//			return false;	
			//		}		
			//	}
			//}
			
			//if (document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value ==null || document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value  =="" || eval(document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value) ==0	)
			//{
			//	alert("項次"+i+":排定出貨量不可空白!");
			//	document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
			//	return false;
			//}
			//else if (eval(document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value) > eval(document.MYFORM.elements["UNSHIP_QTY_"+lineid].value))
			//{
			//	alert("項次"+i+":排定出貨量不可大於訂單量!");
			//	document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
			//	return false;
			//}
			//else if (eval(document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].value) >0 && eval(document.MYFORM.elements["LINE_ORDERED_QTY_"+lineid].value) <= eval(document.MYFORM.elements["LINE_ADVISE_QTY_"+lineid].value))
			//{
			//	alert("項次"+i+":此項次總排定出貨量已滿足訂單量,不允許超量排單!");
			//	document.MYFORM.elements["ACT_SHIP_QTY_"+lineid].focus();
			//	return false;
			//}	
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
<title>SG to TW Shipping Advise Query</title>
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
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
if (SDATE.equals("") && EDATE.equals(""))
{
	PreparedStatement statement8 = con.prepareStatement("select to_char(sysdate+14,'YYYYMMDD') from dual");
	ResultSet rs8=statement8.executeQuery();
	if (rs8.next())
	{
		EDATE= rs8.getString(1);
		ACTIONCODE ="Q";
	}
	rs8.close();
	statement8.close();
}
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String TSC_DESC = request.getParameter("TSC_DESC");
if (TSC_DESC==null) TSC_DESC="";
String TSC_MO = request.getParameter("TSC_MO");
if (TSC_MO==null) TSC_MO="";
String TSCPRODGROUP=request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null) TSCPRODGROUP="";
String CUST=request.getParameter("CUST");
if (CUST==null) CUST="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String sql = "";
String ERPUSERID="";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,(UserName.indexOf("CYTSOU")>=0?"CYTSOU":(UserName.startsWith("JUDY_")?"JUDY_CHO":UserName)));
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
<FORM ACTION="../jsp/TSCSGToTWShippingAdviseQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG To TW Shipping Advise Query</font></strong><BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DBFCB6">
	<tr>
		<td width="7%">TSC Prod Group:</td>
		<td width="8%">
		<select NAME="TSCPRODGROUP" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE="SSD" <%if (TSCPRODGROUP.equals("SSD")) out.println("selected");%>>SSD</OPTION>
		</select>		
		</td>
		<td width="7%"><font color="#666600">Sales Group:</font></td>
		<td width="8%">
		<%
		try
		{   
			sql = " SELECT distinct d.group_name,d.group_name "+
			      " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc.TSC_SHIPPING_ADVISE_PC e"+
                  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
                  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                  " and c.master_group_id=d.master_group_id"+
                  " and d.group_name=e.region_code(+)"+			  
				  " and b.SALES_AREA_NO<>'020'";
			if (UserRoles.indexOf("admin")<0 && UserName.indexOf("CYTSOU")<0 && !UserName.startsWith("JUDY")) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " union all"+
			       " select distinct ALNAME,ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and b.SALES_AREA_NO='020'";
			if (UserRoles.indexOf("admin")<0 && UserName.indexOf("CYTSOU")<0 && !UserName.startsWith("JUDY")) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " order by 1";			
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setFieldName("SALESGROUP");	   
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
		<td width="8%">Schedule Ship Date:</td>
		<td width="17%">
			<input type="TEXT" name="SDATE" value="<%=SDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
			&nbsp;~&nbsp;
			<input type="TEXT" name="EDATE" value="<%=EDATE%>"  style="font-family: Tahoma,Georgia;font-size:11px" size="8" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>		
		</td>
		<td width="7%">Customer:</td>
		<td width="8%">
		<textarea cols="18" rows="3" name="CUST"  style="font-family: Tahoma,Georgia;font-size:11px" ><%=CUST%></textarea>		
		</td>
		<td width="7%">Item Desc:</td>
		<td width="8%">
		<textarea cols="18" rows="3" name="TSC_DESC"  style="font-family: Tahoma,Georgia;font-size:11px" ><%=TSC_DESC%></textarea>		
		</td>
		<td width="7%">Order Number:</td>
		<td width="8%">
		<textarea cols="18" rows="3" name="TSC_MO" style="font-family: Tahoma,Georgia;font-size:11px"  onChange="setChange();"><%=TSC_MO%></textarea>
		</td>
	</tr>
	<tr>
		<td align="center" colspan="12">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;font-size:11px" onClick='setSubmit("../jsp/TSCSGToTWShippingAdviseQuery.jsp?ACTIONCODE=Q")' >
		</td>
	</tr>
</table> 
<HR>
<%
if (((!SDATE.equals("") || !EDATE.equals("")) || !TSC_MO.equals(""))  && ACTIONCODE.equals("Q"))
{
	try
	{
		sql = " SELECT ODR.*"+
		      ",lc.meaning SHIP_METHOD"+
              " FROM (SELECT TSAP.SO_LINE_ID"+
			  //"             ,TSAP.SO_LINE_STATUS"+
			  "             ,TSAP.REGION_CODE"+
			  "             ,TSAP.SO_NO"+
			  "             ,TSAP.SO_LINE_NUMBER"+
			  "             ,TSAP.CUSTOMER_NAME"+
			  "             ,TSAP.ITEM_DESC"+
			  "             ,TSAP.SHIP_QTY"+
			  "             ,TSAP.SO_QTY"+
			  "             ,TSAP.ITEM_NO"+
			  "             ,TSAP.INVENTORY_ITEM_ID"+
			  "             ,TO_CHAR(TSAP.SCHEDULE_SHIP_DATE,'YYYY/MM/DD') SCHEDULE_SHIP_DATE"+
			  "             ,TSAP.CUST_PO_NUMBER"+
			  "             ,OLA.ATTRIBUTE20 HOLD_CODE"+
			  "             ,OLA.ATTRIBUTE5 HOLD_REASON"+
			  "             ,NVL(NVL(AC.CUSTOMER_NAME_PHONETIC,AC.CUSTOMER_NAME),OLA.ATTRIBUTE13) END_CUSTOMER"+
			  "             ,OLA.CUSTOMER_SHIPMENT_NUMBER CUST_PO_LINE_NO"+
			  "             ,TO_CHAR(OLA.REQUEST_DATE,'YYYY/MM/DD') REQUEST_DATE"+
			  "             ,TSAP.SHIPPING_METHOD_CODE"+
              "             ,NVL(SUM(ola.ORDERED_QUANTITY) OVER (PARTITION BY TSAP.SO_NO,OLA.LINE_NUMBER),0) LINE_ORDERED_QTY"+
			  "             ,OLA.LINE_NUMBER"+
			  "             ,TSAP.PC_ADVISE_ID"+
			  "             ,TO_CHAR(TSAP.PC_SCHEDULE_SHIP_DATE,'YYYY/MM/DD') PC_SCHEDULE_SHIP_DATE"+
			  "             ,TSAP.PACKING_INSTRUCTIONS"+
			  "             ,(SELECT  DISTINCT TSAH.ADVISE_NO FROM TSC_SHIPPING_ADVISE_HEADERS TSAH,TSC_SHIPPING_ADVISE_LINES TSAL WHERE TSAL.ADVISE_HEADER_ID=TSAH.ADVISE_HEADER_ID AND TSAP.PC_ADVISE_ID=TSAL.PC_ADVISE_ID) ADVISE_NO"+
			  "      FROM TSC_SHIPPING_ADVISE_PC TSAP,ONT.OE_ORDER_LINES_ALL OLA,AR_CUSTOMERS AC"+
              "      WHERE TSAP.SO_LINE_ID=OLA.LINE_ID"+
			  "      AND OLA.END_CUSTOMER_ID=AC.CUSTOMER_ID(+)"+
			  "      AND TSAP.PACKING_INSTRUCTIONS=?"+
			  "      AND TSC_INV_CATEGORY(TSAP.INVENTORY_ITEM_ID,43,1100000003)='"+TSCPRODGROUP+"'"+
  			  "      AND TSAP.PC_SCHEDULE_SHIP_DATE BETWEEN to_date('"+(SDATE.equals("")?"20100101":SDATE)+"','yyyymmdd') and to_date('"+(EDATE.equals("")?"20991231":EDATE)+"','yyyymmdd')+0.99999"+			  
			  "       ) ODR"+
              ",(SELECT lookup_code,meaning  FROM FND_LOOKUP_VALUES_VL WHERE LOOKUP_TYPE='SHIP_METHOD') lc"+
              " WHERE ODR.SHIPPING_METHOD_CODE = lc.LOOKUP_CODE(+)";
		if (!UserRoles.equals("admin") && UserName.indexOf("CYTSOU")<0 && !UserName.startsWith("JUDY"))
		{				  
			sql +=" AND EXISTS (SELECT 1 FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d"+
			  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
			  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
			  " and c.master_group_id=d.master_group_id"+
			  " and a.username='"+UserName+"'"+
			  " and d.group_name=ODR.REGION_CODE)";
		}
		if (!salesGroup.equals("--") && !salesGroup.equals(""))
		{
			sql += " and ODR.REGION_CODE='"+salesGroup+"'";
		}						  
		if (!CUST.equals("") && !CUST.equals("--"))
		{
			String [] sArray = CUST.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (";
				}
				else
				{
					sql += " or ";
				}
				sArray[x] = sArray[x].trim();
				sql += " ODR.CUSTOMER_NAME like '%"+sArray[x]+"%'";
			}
		}			  
		if (!TSC_DESC.equals(""))
		{
			String [] sArray = TSC_DESC.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " AND ODR.ITEM_DESC in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}			
		if (!TSC_MO.equals(""))
		{
			String [] sArray = TSC_MO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " AND ODR.SO_NO in ( '"+sArray[x].trim()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}
		
		sql += " ORDER BY ODR.SCHEDULE_SHIP_DATE,ODR.SO_NO,ODR.SO_LINE_NUMBER";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		//statement.setString(1,v_batch_id);
		statement.setString(1,"T");
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		while (rs.next())
		{
			if (icnt ==0)
			{
%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
				<tr bgcolor="#E0E8D9" style="font-family:Tahoma,Georgia;font-size:11px" align="center">
					<td width="2%">Seq</td>
					<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="8%">Advise No</td>
					<td width="5%">PC SSD</td>
					<td width="5%">Ship Qty</td>
					<td width="5%">Sales Region </td>
					<td width="6%">MO#</td>
					<td width="3%">Line#</td>
					<td width="14%">Customer</td>
					<td width="8%">Item Desc </td>
					<td width="4%">Qty(PCE)</td>
					<td width="9%">Shipping Method </td>
					<td width="5%">SSD </td>
					<td width="5%">CRD </td>
					<td width="10%">Cust PO</td>
					<td width="4%">Cust PO Line No</td>
					<td width="5%">End Cust</td>
				</tr>
			
<%		
			}
%>
				<tr id="tr_<%=rs.getString("pc_advise_id")%>" style="font-family:airl;font-size:11px;">
					<td align="left"><%=(icnt+1)%></td>
					<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("pc_advise_id")%>" onClick="setCheck(<%=icnt%>)" <%=((rs.getString("ADVISE_NO") ==null || rs.getString("ADVISE_NO").equals(""))? "":"disabled")%>></td>
					<td align="center"><%=(rs.getString("ADVISE_NO")==null?"&nbsp;":rs.getString("ADVISE_NO"))%></td>
					<td align="center"><%=rs.getString("PC_SCHEDULE_SHIP_DATE")%></td>
					<td align="right"><%=rs.getString("SHIP_QTY")%></td>
					<td align="left"><%=rs.getString("REGION_CODE")%></td>
					<td align="center"><%=rs.getString("SO_NO")%></td>
					<td align="center"><%=rs.getString("SO_LINE_NUMBER")%></td>
					<td align="left"><%=rs.getString("CUSTOMER_NAME")%></td>
					<td align="left"><%=rs.getString("ITEM_DESC")%></td>
					<td align="right"><%=rs.getString("SO_QTY")%></td>
					<td align="left"><%=(rs.getString("SHIP_METHOD")==null?"&nbsp;":rs.getString("SHIP_METHOD"))%></td>
					<td align="center"><%=rs.getString("SCHEDULE_SHIP_DATE")%></td>
					<td align="center"><%=rs.getString("REQUEST_DATE")%></td>
					<td align="left"><%=(rs.getString("CUST_PO_NUMBER")==null?"&nbsp;":rs.getString("CUST_PO_NUMBER"))%></td>
					<td align="left"><%=(rs.getString("CUST_PO_LINE_NO")==null?"&nbsp;":rs.getString("CUST_PO_LINE_NO"))%></td>
					<td align="left"><%=(rs.getString("END_CUSTOMER")==null?"&nbsp;":rs.getString("END_CUSTOMER"))%></td>
				</tr>
<%
			icnt++;
		}
		if (icnt >0)
		{
%>
			</table>
			<table width="100%">
				<tr><td align="LEFT"><input type="button" name="save" value="Delete" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGToTWShippingAdviseProcess.jsp')"></td></tr>
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
%>
<input type="hidden" name="TRANSTYPE" value="DELETE">
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

