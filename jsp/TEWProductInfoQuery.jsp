<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function DateValueOf(datevalue)
{
	if (datevalue.length >8)
	{
		document.MYFORM.EYEARFR.value = datevalue.substr(0,4);
		document.MYFORM.EMONTHFR.value = datevalue.substr(4,2);
		document.MYFORM.EDAYFR.value = datevalue.substr(6,2);
		document.MYFORM.EYEARTO.value = datevalue.substr(9,4);
		document.MYFORM.EMONTHTO.value = datevalue.substr(13,2);
		document.MYFORM.EDAYTO.value = datevalue.substr(15,2);	
	}
	else if (datevalue.length ==8)
	{
		document.MYFORM.EYEARFR.value = "--";
		document.MYFORM.EMONTHFR.value = "--";
		document.MYFORM.EDAYFR.value = "--";
		document.MYFORM.EYEARTO.value = datevalue.substr(0,4);
		document.MYFORM.EMONTHTO.value = datevalue.substr(4,2);
		document.MYFORM.EDAYTO.value = datevalue.substr(6,2);	
	}
	else
	{
		document.MYFORM.YEARFR.value = "--";
		document.MYFORM.MONTHFR.value = "--";
		document.MYFORM.DAYFR.value = "--";
		document.MYFORM.YEARTO.value = "--";
		document.MYFORM.MONTHTO.value = "--";
		document.MYFORM.DAYTO.value = "--";	
		document.MYFORM.EYEARFR.value = "--";
		document.MYFORM.EMONTHFR.value = "--";
		document.MYFORM.EDAYFR.value = "--";
		document.MYFORM.EYEARTO.value = "--";
		document.MYFORM.EMONTHTO.value = "--";
		document.MYFORM.EDAYTO.value = "--";	
	}
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setUpdate(URL)
{    
	subWin=window.open(URL,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function chgObj(objvalue)
{
	if (objvalue!="")
	{
		DateValueOf("");
		document.MYFORM.SUPPLIER.value="";
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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>TSC Product info Query</title>
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
String TSC_PARTNO=request.getParameter("TSC_PARTNO");
if (TSC_PARTNO==null) TSC_PARTNO="";
String TSC_PROD_GROUP=request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP==null || TSC_PROD_GROUP.equals("--")) TSC_PROD_GROUP="";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null || TSC_FAMILY.equals("--")) TSC_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null || TSC_PACKAGE.equals("--")) TSC_PACKAGE="";
String TSC_PACKINGCODE = request.getParameter("TSC_PACKINGCODE");
if (TSC_PACKINGCODE==null) TSC_PACKINGCODE="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String sql ="",stock_color="";
int icondition=0;
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWProductInfoQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">台半產品規格查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
	    <td width="14%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">TSC 22D(or Part Name):</td> 
		<td width="10%"><input type="text" name="TSC_PARTNO" value="<%=TSC_PARTNO%>" style="font-family: Tahoma,Georgia;font-size:12px" size="20"></td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">TSC Prod Group:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_GROUP' AND DISABLE_DATE IS NULL order by SEGMENT1 ";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PROD_GROUP);
			comboBoxBean.setFieldName("TSC_PROD_GROUP");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">TSC Family:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Family' AND DISABLE_DATE IS NULL  order by SEGMENT1";
			//if (STATUS.equals("UPD")) sql += " and SEGMENT1='"+TSC_FAMILY+"'";
			//sql +=" order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_FAMILY);
			comboBoxBean.setFieldName("TSC_FAMILY");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">TSC Package:</td> 
		<td width="10%">
		<%
		try
		{
			sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Package' AND DISABLE_DATE IS NULL order by SEGMENT1";
			//if (STATUS.equals("UPD")) sql += " and SEGMENT1='"+TSC_PACKAGE+"'";
			//sql +=" order by SEGMENT1";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TSC_PACKAGE);
			comboBoxBean.setFieldName("TSC_PACKAGE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>			
		</td>
	    <td width="10%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">TSC Packing Code:</td> 
		<td width="6%"><input type="text" name="TSC_PACKINGCODE" value="<%=TSC_PACKINGCODE%>" style="font-family: Tahoma,Georgia; font-size:12px" size="8"></td>
	</tr>
</table>
<BR>
<div align="center"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWProductInfoQuery.jsp?ACODE=Q")' > 
</div>
<hr>
<%
try
{    
	if (ACODE.equals("Q"))
	{   
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();
		
		int iCnt = 0;
		sql = " select segment1,description"+
			  " ,tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_PROD_GROUP') tsc_prod_group"+
			  " ,tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_Family') tsc_family"+
			  " ,tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_Package') tsc_package"+
			  " ,tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_Amp') tsc_amp"+
			  " ,tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_VOLT') tsc_volt"+
			  " ,tsc_get_item_packing_code(a.organization_id,a.inventory_item_id) tsc_packing_code"+
			  " ,a.inventory_item_status_code"+
			  " from inv.mtl_system_items_b a"+
			  " where organization_id=49"+
			  " and length(a.segment1)>=22"+
			  //" and upper(a.inventory_item_status_code)='ACTIVE'"+
			  " and a.inventory_item_status_code <> 'Inactive'"+  //modify by Peggy 20161220
			  " and lower(description) not like '%disable%'";
		if (!TSC_PARTNO.equals(""))
		{
			sql += " AND (a.segment1 = '"+ TSC_PARTNO+"' or a.description like '"+TSC_PARTNO+"%')";
			icondition++;
		}
		if (!TSC_PROD_GROUP.equals(""))
		{
			sql += " AND tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_PROD_GROUP') = '"+ TSC_PROD_GROUP+"'";
			icondition++;
		}	
		if (!TSC_FAMILY.equals(""))
		{
			sql += " AND tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_Family') = '"+ TSC_FAMILY+"'";
			icondition++;
		}	
		if (!TSC_PACKAGE.equals(""))
		{
			sql += " AND tsc_om_category(a.inventory_item_id,a.organization_id,'TSC_Package') = '"+ TSC_PACKAGE+"'";
			icondition++;
		}	
		if (!TSC_PACKINGCODE.equals(""))
		{
			sql += " AND tsc_get_item_packing_code(a.organization_id,a.inventory_item_id)='"+TSC_PACKINGCODE+"'";
			icondition++;
		}
		sql += " order by 3,2";	
		if (icondition==0)
		{
			out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>請輸入篩選條件,謝謝!</strong></font></div>");
		}
		else
		{
			//out.println(sql);
			Statement statement=con.createStatement(); 
			ResultSet rs=statement.executeQuery(sql);
			while (rs.next()) 
			{ 	
				iCnt++;
				if (iCnt ==1)
				{
				%>
				<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
					<tr bgcolor="#C9E2D0"> 
						<td width="15%" style="color:#006666" align="center">TSC 22D</td>
						<td width="15%" style="color:#006666" align="center">TSC Part Name</td>
						<td width="10%" style="color:#006666" align="center">TSC Prod Group</td>            
						<td width="15%" style="color:#006666" align="center">TSC Family</td>            
						<td width="15%" style="color:#006666" align="center">TSC Package</td>            
						<td width="10%" style="color:#006666" align="center">TSC Packing Code</td>
						<td width="10%" style="color:#006666" align="center">TSC Amp</td>            
						<td width="10%" style="color:#006666" align="center">TSC Volt</td>            
					</tr>
				<% 
				}
				%>
				<tr  id="tr_<%=iCnt%>" bgcolor="#E7F1EB" onMouseOver="this.style.Color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#E7F1EB';style.color='#000000';this.style.fontWeight='normal'">
					<td><%=rs.getString("segment1")%></td>
					<td><%=rs.getString("description")%></td>
					<td><%=rs.getString("tsc_prod_group")%></td>
					<td><%=rs.getString("tsc_family")%></td>
					<td><%=rs.getString("tsc_package")%></td>
					<td align="center"><%=rs.getString("tsc_packing_code")%></td>
					<td align="center"><%=rs.getString("tsc_amp")%></td>
					<td align="center"><%=rs.getString("tsc_volt")%></td>
				</tr>
		<%
			}
			rs.close();
			statement.close();
			
			if (iCnt==0)
			{
				out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
			}
			else
			{
		%>
			</table>
		<%
			}
			
			String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
			PreparedStatement pstmt2=con.prepareStatement(sql2);
			pstmt2.executeUpdate(); 
			pstmt2.close();	
		}
	}	
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

