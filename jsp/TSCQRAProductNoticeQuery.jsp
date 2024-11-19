<!-- 20161114 Peggy,新增only global customer查詢條件-->
<!-- 20170602 Peggy,新增package & family查詢條件-->
<!-- 20170707 Peggy,新增X-Out customer report-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,ComboBoxBean,ArrayComboBoxBean,javax.xml.parsers.*,CodeUtil"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="codeUtil" scope="page" class="CodeUtil"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style5   {font-family:Tahoma,Georgia;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function subWindowConditionList(obj)
{    
	var objvalue = document.MYFORM.elements[obj].value;
	var varray = objvalue.split("\n");
	var value="";
	for (var i=0; i < varray.length ; i++)
	{
		if (value.length >0) value = value+";";
		value = value+varray[i]; 
	}
	subWin=window.open("../jsp/subwindow/TSCQRAConditionsFind.jsp?TYPE="+obj+"&VALUE="+value,"subwin","width=340,height=480,scrollbars=yes,menubar=no");
}

function subWindowCustomerList()
{
	var objvalue = document.MYFORM.elements["TERRITORY"].value.replace("ALL","");
	var varray = objvalue.split("\n");
	var territory="",marketgroup="",custlist="",qno="";
	for (var i=0; i < varray.length ; i++)
	{
		if (territory.length >0) territory= territory+";";
		territory = territory+varray[i]; 
	}
	var objvalue1 = document.MYFORM.elements["MARKETGROUP"].value;
	var varray1 = objvalue1.split("\n");
	for (var i=0; i < varray1.length ; i++)
	{
		if (marketgroup.length >0) marketgroup=marketgroup+";";
		marketgroup = marketgroup+varray1[i]; 
	}
	var objvalue2 = document.MYFORM.elements["QNO"].value;
	var varray2 = objvalue2.split("\n");
	for (var i=0; i < varray2.length ; i++)
	{
		if (qno.length >0) qno=qno+";";
		qno = qno+varray2[i]; 
	}
	if ((objvalue==null || objvalue=="") && (objvalue1==null || objvalue1=="")  && (objvalue2==null || objvalue2=="") && document.MYFORM.elements["TERRITORY"].value!="ALL")
	{
		alert("Please enter at least one of PCN/PDN/IN Number or Territory or Market Group!!");
		return false;
	}
	var objvalue3 = document.MYFORM.elements["CUSTOMER"].value;
	var varray3 = objvalue3.split("\n");
	for (var i=0; i < varray3.length ; i++)
	{
		if (custlist.length >0) custlist=custlist+";";
		custlist = custlist+varray3[i].substr(varray3[i].indexOf("(")+1,varray3[i].indexOf(")")-1); 
	}
	subWin=window.open("../jsp/subwindow/TSCQRACustomerFind.jsp?TERRITORY="+territory+"&MARKETGROUP="+marketgroup+"&CUSTLIST="+custlist+"&QNO="+qno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function subWindowCustPartList()
{
	var objvalue2 = document.MYFORM.elements["CUSTPARTNO"].value;
	var varray2 = objvalue2.split("\n");
	for (var i=0; i < varray2.length ; i++)
	{
		if (custpartlist.length >0) custpartlist=custpartlist+";";
		custpartlist = custpartlist+varray2[i].substr(varray2[i].indexOf("(")+1,varray2[i].indexOf(")")-1); 
	}
	subWin=window.open("../jsp/subwindow/TSCQRACustomerFind.jsp?TERRITORY="+territory+"&CUSTPNLIST="+custpartlist,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{   
	if (event.keyCode == 13)
	{ 
		document.MYFORM.action=URL+"?SQNO="+document.MYFORM.QNO.value;
		document.MYFORM.submit();
	}
}
function toUpper(objname)
{
	document.MYFORM.elements[objname].value = document.MYFORM.elements[objname].value.toUpperCase();
}
function subWindowReply(URL,HEIGHTNUM)
{
	subWin=window.open(URL,"subwin","width=600,height="+HEIGHTNUM+",scrollbars=yes,menubar=no");
}
function setChange()
{
	if (document.MYFORM.GROUPBY.value=="2")
	{
		document.MYFORM.xout.style.visibility = "visible";
		document.MYFORM.elements["chk2"].style.visibility="visible";
		document.MYFORM.elements["chk2"].checked = true;
		document.getElementById("id2").style.visibility="visible";
		document.getElementById("hlink1").style.visibility="visible";
		document.getElementById("fnt1").style.visibility="visible";
		//document.getElementById("btn1").style.visibility="visible";
	}
	else
	{
		document.MYFORM.xout.style.visibility = "hidden";
		document.MYFORM.elements["chk2"].style.visibility="hidden";
		document.MYFORM.elements["chk2"].checked = false;
		document.getElementById("id2").style.visibility="hidden";
		document.getElementById("hlink1").style.visibility="hidden";
		document.getElementById("fnt1").style.visibility="hidden";
		//document.getElementById("btn1").style.visibility="hidden";
	}
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setClear()
{
	document.MYFORM.QNO.value ="";
	document.MYFORM.TSCPARTNO.value="";
	document.MYFORM.CUSTPARTNO.value="";
	document.MYFORM.CUSTOMER.value="";
	document.MYFORM.MARKETGROUP.value="";
	document.MYFORM.SDATE.value="";
	document.MYFORM.EDATE.value="";
}
function setchkChange()
{
	//if (document.MYFORM.chk1.checked==true)
	//{
	//	document.MYFORM.xout.style.visibility = "visible";
	//}
	//else
	//{
	//	document.MYFORM.xout.style.visibility = "hidden";
	//}	
}
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
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+(irow+1)).style.backgroundColor ="#daf1a9";
	}
	else
	{
		document.getElementById("tr_"+(irow+1)).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit2()
{    
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
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
		alert("Please choose one or more than items!");
		return false;
	}
}
</script>
</head>
<%
boolean showHomePage=false;
String sql ="",where="",CTYPE="",SALES_NOTICE="",CUST_NOTICE="",HQ_NOTICE="";
//if ((","+UserRoles+",").indexOf(",WW_FAE,")>=0)
String TERRITORY = request.getParameter("TERRITORY");
if (TERRITORY ==null)  TERRITORY="";
if (TERRITORY.equals("") && ((","+UserRoles+",").indexOf(",PCN_QUERY,")>=0 || (","+UserRoles+",").indexOf(",PCN_QUERY(Sales),")>=0))
{
	if ((","+UserRoles+",").indexOf(",PCN_QUERY(Sales),")>=0) showHomePage=true;
	sql = " select distinct territory from oraddman.tsqra_contact_window_mail a where username =?";
	PreparedStatement statementx = con.prepareStatement(sql);
	statementx.setString(1,UserName);
	ResultSet rsx=statementx.executeQuery();
	int icnt =0;
	while (rsx.next())
	{
		if (TERRITORY.indexOf(rsx.getString("territory")+"\n")>=0) continue;
		if (TERRITORY.length() >0) TERRITORY +="\n";
		TERRITORY += rsx.getString("territory");
		icnt ++;
	}
	rsx.close();
	statementx.close();
	if (icnt==0)
	{
%>
	<Script language="JavaScript">
		alert("Invalid User!!");
		location.replace("http://www.taiwansemi.com/"); 
	</Script>
<%	}
}
else if (TERRITORY.equals(""))
{
	showHomePage=true;
	TERRITORY ="ALL";
}	
else
{
	showHomePage=true;
}
String QTRANS = request.getParameter("QTRANS");
if (QTRANS==null) QTRANS="";
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QTYPE = request.getParameter("QTYPE");
if (QTYPE==null) QTYPE="";
String PROD1 = request.getParameter("PROD1");
if (PROD1==null) PROD1="";
String PROD2 = request.getParameter("PROD2");
if (PROD2==null) PROD2="";
String PROD3 = request.getParameter("PROD3");
if (PROD3==null) PROD3="";
String TSCFAMILY = request.getParameter("ERPTSCFAMILY");
if (TSCFAMILY==null) TSCFAMILY="";
String TSCPACKAGE = request.getParameter("ERPTSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TSCPACKINGCODE = request.getParameter("TSCPACKINGCODE");
if (TSCPACKINGCODE==null) TSCPACKINGCODE="";
String TSCAMP = request.getParameter("TSCAMP");
if (TSCAMP==null) TSCAMP="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String MARKETGROUP = request.getParameter("MARKETGROUP");
if (MARKETGROUP==null) MARKETGROUP="";
String MANUFACTORY = request.getParameter("MANUFACTORY");
if (MANUFACTORY==null) MANUFACTORY="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String CUSTPARTNO = request.getParameter("CUSTPARTNO");
if (CUSTPARTNO==null) CUSTPARTNO="";
String TSCPARTNO = request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String involvedPartNo = request.getParameter("chk2");  //add by Peggy 20171212
if (involvedPartNo==null) involvedPartNo="N";
String GROUPBY = request.getParameter("GROUPBY");
if (GROUPBY==null)
{
	GROUPBY="2";
	involvedPartNo="Y";
}
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String numid="3285017";
//拿掉它,條件已放入xout-customer list button by Peggy 20220505
String strGlobalCust = request.getParameter("chk1");
if (strGlobalCust==null) strGlobalCust="N";

%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSCQRAProductNoticeQuery.jsp">
<font size=4><strong>PCN/PDN/IN Query</strong></font>
<table width="100%">
	<tr>
		<td align="right"><%if (showHomePage) out.println("<A href='/oradds/ORADDSMainMenu.jsp'>HOME</A>"); else out.println("<a href='../jsp/Logout.jsp'>Logout</a>");%>	
		</td>
	</tr>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Sorted 
				  by</font></td>
					<td width="13%"><SELECT NAME="GROUPBY" class="style5" onChange="setChange();">
					    <option value="1" <% if (GROUPBY.equals("1")) out.println("selected");%>>TSC P/N
						<option value="2" <% if (GROUPBY.equals("2")) out.println("selected");%>>CUSTOMER
						<option value="3" <% if (GROUPBY.equals("3")) out.println("selected");%>>PCN/PDN/IN NUMBER
						</SELECT>	
						<br>
						<!--<input type="checkbox" name="chk1" value="Y"  <%=(strGlobalCust.equals("Y")?" checked":"")%> <%=((","+UserRoles.toUpperCase()+",").indexOf(",PCN_USER,")>=0 || (","+UserRoles.toUpperCase()+",").indexOf(",ADMIN,")>=0?" style='visibility:visible'":" style='visibility:hidden'")%>  onClick="setchkChange(this.value)">
						<font <%=((","+UserRoles.toUpperCase()+",").indexOf(",PCN_USER,")>=0 || (","+UserRoles.toUpperCase()+",").indexOf(",ADMIN,")>=0?" style='font-family: Tahoma,Georgia;visibility:visible'":" style='visibility:hidden'")%>>Only Global Customer</font>
						<br>-->
						<div id="id2" <%=(GROUPBY.equals("2")?" style='font-family: Tahoma,Georgia;visibility:visible'":" style='visibility:hidden'")%>><input type="checkbox" name="chk2" value="Y"  <%=(involvedPartNo.equals("Y")?" checked":"")%>>Including involved P/N</DIV>
					</td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Territory</font></td>
					<td width="13%"><textarea cols="22" rows="2" name="TERRITORY" class="style5" <%=(!TERRITORY.equals("ALL")?" readonly":"")%>><%=TERRITORY%></textarea></td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Issue Date</font></td>
					<td width="13%">   
					<input type="text" name="SDATE" value="<%=SDATE%>" size="10" class="style5"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					<input type="text" name="EDATE" value="<%=EDATE%>" size="10" class="style5"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>					
					</td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">TSC P/N</font></td>
					<td width="13%"><textarea cols="24" rows="4" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Family</font><A href="javascript:void(0)" onClick="subWindowConditionList('ERPTSCFAMILY')" title="Press the left mouse button to open the menu screen of Family" ><img src="images/search.gif" border="0"></A></td>
					<td width="13%"><textarea cols="25" rows="4" name="ERPTSCFAMILY" class="style5"><%=TSCFAMILY%></textarea></td>
				</tr>
				<tr>
					<td style="background-color:#CFD1C0"><font color="#006666">PCN/PDN/IN<br>Number</font></td>
					<td><textarea cols="22" rows="4" name="QNO" class="style5" onKeyUp="toUpper('QNO')"><%=QNO%></textarea></td>
					<td style="background-color:#CFD1C0"><font color="#006666">Market Group</font><br><A href="javascript:void(0)" onClick="subWindowConditionList('MARKETGROUP')" title="Press the left mouse button to open the menu screen of Market Group" ><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="22" rows="4" name="MARKETGROUP" class="style5"><%=MARKETGROUP%></textarea></td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Customer</font></td>
					<td><textarea cols="30" rows="4" name="CUSTOMER" class="style5"><%=CUSTOMER%></textarea></td>
					<td width="7%" style="background-color:#CFD1C0"><font color="#006666">Cust P/N</font></td>
					<td><textarea cols="24" rows="4" name="CUSTPARTNO" class="style5"><%=CUSTPARTNO%></textarea></td>
					<td style="background-color:#CFD1C0"><font color="#006666">Package</font><A href="javascript:void(0)" onClick="subWindowConditionList('ERPTSCPACKAGE')" title="Press the left mouse button to open the menu screen of Package" ><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="25" rows="4" name="ERPTSCPACKAGE" class="style5"><%=TSCPACKAGE%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">
		<input type="button" name="submit1" value="Query" style="font-family:arial" onClick="setSubmit('../jsp/TSCQRAProductNoticeQuery.jsp?QTRANS=Q')">
		&nbsp;&nbsp;
		<input type="button" name="clear" value="Clear" style="font-family:arial" onClick="setClear()">
		&nbsp;&nbsp;
		<input type="button" name="excel" value="Excel" style="font-family:arial" onClick="setExportXLS('../jsp/TSCQRAProductNoticeExcel.jsp')">
		&nbsp;&nbsp;
		<input type="button" name="xout" value="X-Out Customer List" style="font-family:arial;" onClick="setExportXLS('../jsp/TSCQRAXoutCustomerList.jsp')">
		<A id="hlink1" HREF="../jsp/TSCQRAXoutCustomerRule.jsp" style="font-size:11px;font-family:Tahoma,Georgia;"><font id="fnt1">X-Out Customer Rule</font></A>
		</td>
	</tr>
<%
try
{
	if (QTRANS.equals("Q"))
	{		
		int rec_cnt =0;
		sql = " select c.PCN_NUMBER"+
		      ",b.SEQID"+
			  ",c.PCN_TYPE"+
			  ",c.PCN_CREATION_DATE"+
			  ",b.TSC_PART_NO \"TSC P/N\" "+
			  ",b.TSC_PROD_GROUP PROD_GROUP"+
			  ",b.TSC_PACKAGE PACKAGE"+
			  ",b.TSC_FAMILY FAMILY"+
			  ",b.TSC_PACKING_CODE AS \"PACKING CODE\""+
			  ",b.TSC_AMP AMP"+
			  ",NVL(b.MARKET_GROUP,'N/A') MARKET_GROUP"+
			  ",NVL(b.CUST_SHORT_NAME,'N/A') customer_name"+
			  ",NVL(b.TERRITORY,'N/A') TERRITORY "+
			  ",NVL(b.CUST_PART_NO,'N/A') \"CUST P/N\""+
			  ",NVL(b.CUST_SHORT_NAME,'N/A') customer"+
			  ",b.source_type"+
			  ",b.date_code"+
			  ",b.sales_issue_date"+
			  ",b.sales"+
			  ",b.CUST_REPRESENTATIVE"+
			  ",nvl(b.status,case when trunc(sysdate)-to_DATE(pcn_end_date,'yyyymmdd') >1 THEN 'Closed' else 'Open' end) status"+
			  ",c.PDF_FILE_PATH"+
			  ",b.REPLACE_PART_NO"+
			  " from oraddman.tsqra_pcn_item_detail b"+
			  ",oraddman.tsqra_pcn_item_header c"+
			  " where b.PCN_NUMBER(+)=c.PCN_NUMBER";
		if (!TERRITORY.equals("ALL"))
		{
			String [] strTerritory = TERRITORY.split("\n");
			String TerritoryList = "'N/A'";
			for (int x = 0 ; x < strTerritory.length ; x++)
			{
				if (TerritoryList.length() >0) TerritoryList += ",";
				TerritoryList += "'"+strTerritory[x].trim()+"'";
			}
			where += " and NVL(b.TERRITORY,'N/A') in ("+TerritoryList+")";
		}
		if (!QNO.equals(""))
		{
			String [] strNo = QNO.split("\n");
			String QNOList = "";
			for (int x = 0 ; x < strNo.length ; x++)
			{
				if (QNOList.length() >0) QNOList += ",";
				QNOList += "'"+strNo[x].trim()+"'";
			}
			where += " and c.PCN_NUMBER in ("+QNOList+")";
		}
		if (!PROD1.equals("") || !PROD2.equals("") || !PROD3.equals(""))
		{
			String PRODLIST="";
			if (!PROD1.equals(""))
			{ 
				if (!PRODLIST.equals("")) PRODLIST +=",";
				PRODLIST +="'"+PROD1+"'";
			}
			if (!PROD2.equals(""))
			{
				if (!PRODLIST.equals("")) PRODLIST +=",";
				PRODLIST +="'"+PROD2+"'";
			}
			if (!PROD3.equals(""))
			{
				if (!PRODLIST.equals("")) PRODLIST +=",";
				PRODLIST +="'"+PROD3+"'";
			}
			where += " and b.TSC_PROD_GROUP IN ("+PRODLIST+")";
		}
		if (!TSCFAMILY.equals("--") && !TSCFAMILY.equals(""))
		{
			String [] strFamily = TSCFAMILY.split("\n");
			String FamilyList = "";
			for (int x = 0 ; x < strFamily.length ; x++)
			{
				if (FamilyList.length() >0) FamilyList += ",";
				FamilyList += "'"+strFamily[x].trim()+"'";
			}
			where += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and TSC_INV_Category(msi.inventory_item_id, msi.organization_id,21) in ("+FamilyList+")"+
			         "  and tsc_get_item_desc_nopacking(  msi.organization_id,msi.inventory_item_id)=substr(b.tsc_part_no,1,length(b.tsc_part_no)-length(b.tsc_packing_code)-1))";
			//where += " and b.TSC_FAMILY in ("+FamilyList+")";
		}
		if (!TSCPACKAGE.equals("") && !TSCPACKAGE.equals("--"))
		{
			String [] strPackage = TSCPACKAGE.split("\n");
			String PackageList = "";
			for (int x = 0 ; x < strPackage.length ; x++)
			{
				if (PackageList.length() >0) PackageList += ",";
				PackageList += "'"+strPackage[x].trim()+"'";
			}
			//where += " and b.TSC_PACKAGE in ("+PackageList+")";
			where += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and TSC_INV_Category(msi.inventory_item_id, msi.organization_id,23) in ("+PackageList+")"+
			         "  and tsc_get_item_desc_nopacking(  msi.organization_id,msi.inventory_item_id)=substr(b.tsc_part_no,1,length(b.tsc_part_no)-length(b.tsc_packing_code)-1))";
		}
		if (!TSCPACKINGCODE.equals("") && !TSCPACKINGCODE.equals("--"))
		{
			String [] strPacking = TSCPACKINGCODE.split("\n");
			String PackingList = "";
			for (int x = 0 ; x < strPacking.length ; x++)
			{
				if (PackingList.length() >0) PackingList += ",";
				PackingList += "'"+strPacking[x].trim()+"'";
			}
			where += " and case when ( b.TSC_PROD_GROUP='PMD' and substr(a.segment1,4,1)='G')  then substr(a.segment1,9,2)||'G' when  ( b.TSC_PROD_GROUP<>'PMD' and substr(a.segment1,11,1)='1' ) then substr(a.segment1,9,2)||'G' else substr(a.segment1,9,2) end in ("+PackingList+")";
		}
		if (!TSCAMP.equals("") && !TSCAMP.equals("--"))
		{
			String [] strAmp = TSCAMP.split("\n");
			String AmpList = "";
			for (int x = 0 ; x < strAmp.length ; x++)
			{
				if (AmpList.length() >0) AmpList += ",";
				AmpList += "'"+strAmp[x].trim()+"'";
			}
			where += " and b.TSC_AMP in ("+AmpList+")";
		}
		if (!MARKETGROUP.equals("") && !MARKETGROUP.equals("--"))
		{
			String [] strMarketGroup = MARKETGROUP.split("\n");
			String MarketGroupList = "";
			for (int x = 0 ; x < strMarketGroup.length ; x++)
			{
				if (MarketGroupList.length() >0) MarketGroupList += ",";
				MarketGroupList += "'"+strMarketGroup[x].trim()+"'";
			}
			where += " and b.MARKET_GROUP in ("+MarketGroupList+")";
		}
		if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
		{
			String [] sArray = CUSTOMER.split("\n");
			String sList = "";
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					where += " and (";
				}
				else
				{
					where += " or ";
				}
				sArray[x] = sArray[x].trim();
				where += " lower(b.CUST_SHORT_NAME) like '%"+sArray[x].toLowerCase()+"%'";
			}
			//add by Peggy 20171212
			if (GROUPBY.equals("2") && involvedPartNo.equals("Y"))
			{
				where += "  or b.SOURCE_TYPE='2'";
			}
			where += " )";
		}
		if (!MANUFACTORY.equals("") && !MANUFACTORY.equals("--"))
		{
			String [] sArray = MANUFACTORY.split("\n");
			String sList = "";
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (sList.length() >0) sList += ",";
				sArray[x] = sArray[x].trim();
				sList += ("'"+sArray[x].substring(0,sArray[x].indexOf("-"))+"'");
			}
			where += " and b.packing_instructions in ("+sList+")";
		}
		if (!SDATE.equals("")) //modify by Peggy 20140416
		{
			where += " and c.pcn_creation_date >= '"+SDATE+"'";
		}
		if (!EDATE.equals(""))  //modify by Peggy 20140416
		{
			where += " and c.pcn_creation_date <= '"+EDATE+"'";
		}	
		if (!TSCPARTNO.equals("") && !TSCPARTNO.equals("--"))
		{
			String [] sArray = TSCPARTNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					where += " and (upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
					if (x==sArray.length -1) where += ")";
					
				}
				else if (x==sArray.length -1)
				{
					where += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%')";
				}
				else
				{
					where += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
			}
		}
		if (!CUSTPARTNO.equals("") && !CUSTPARTNO.equals("--"))
		{
			String [] sArray = CUSTPARTNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					where += " and (upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
					if (x==sArray.length -1) where += ")";
					
				}
				else if (x==sArray.length -1)
				{
					where += " or upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%')";
				}
				else
				{
					where += " or upper(b.CUST_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
			}
		}
		if (!STATUS.equals("--") && !STATUS.equals(""))
		{
			where += " and nvl(b.status,case when trunc(sysdate)-to_DATE(pcn_end_date,'yyyymmdd') >1 THEN 'Closed' else 'Open' end) ='"+STATUS+"'";
		}
		//out.println(sql);
		//out.println(where);
		
		//add by Peggy 20161114
		//if (strGlobalCust.equals("Y"))
		//{
		//	where += " and exists (select 1 from oraddman.tsqra_global_customer x where upper(x.customer_group_name)=upper(b.cust_short_name))";
		//}
		
		if (where.equals(""))
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("please input the query conditions!");
		</script>
		<%
		}
		else
		{
			if (GROUPBY.equals("1")) //TSC P/N
			{
				sql = " SELECT x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.\"TSC P/N\",x.\"CUST P/N\",x.TERRITORY,x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.SALES_ISSUE_DATE,x.PCN_CREATION_DATE,x.PDF_FILE_PATH,x.REPLACE_PART_NO"+
                      " FROM ("+sql+where+") x order by x.\"TSC P/N\",territory,market_group,customer,pcn_number";
			
			}
			else if (GROUPBY.equals("2")) //CUSTOMER
			{
				sql = " SELECT x.\"TSC P/N\",x.\"CUST P/N\",x.TERRITORY,x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.SALES_ISSUE_DATE,x.PCN_CREATION_DATE,x.PDF_FILE_PATH,x.SEQID,x.REPLACE_PART_NO"+
                      " FROM ("+sql+where+") x ";
				if (!involvedPartNo.equals("Y"))
				{
					sql += " where x.CUSTOMER <>'N/A'";
				}
				sql += " order by x.TERRITORY,x.CUSTOMER,x.\"TSC P/N\",x.pcn_number";
			
			}
			else if (GROUPBY.equals("3")) //by QPCN NUMBER
			{
				sql = " SELECT x.PROD_GROUP,x.FAMILY,x.PACKAGE,x.\"TSC P/N\",x.\"CUST P/N\",x.TERRITORY,x.CUSTOMER,x.MARKET_GROUP,x.PCN_NUMBER,x.SALES_ISSUE_DATE,x.PCN_CREATION_DATE,x.PDF_FILE_PATH,x.REPLACE_PART_NO"+
                      " FROM ("+sql+where+") x order by x.PCN_NUMBER,x.\"TSC P/N\",territory,market_group,customer";
				
			}
			//out.println(sql);
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			String pcn_number="",customer_name="",strflag="",rootPath="",pdfurl="",SALES_ISSUE_NOTICE="";
			int cnt1 =0,cnt2=0;
			while (rs.next())
			{
				if (rec_cnt==0)
				{
%>
	<tr>
		<td colspan="10">
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
<%
					if (GROUPBY.equals("1")) //by TSC P/N
					{
%>
				<tr style="background-color:#669966;color:#ffffff;">
					<td width="4%"  class="style5" align="center" valign="top">Seq No</td>
					<td width="6%"  class="style5" align="center" valign="top">Territory</td>
					<td width="10%"  class="style5" align="center" valign="top">Prod Group</td>
					<td width="10%"  class="style5" align="center" valign="top">Family</td>
					<td width="10%"  class="style5" align="center" valign="top">Package</td>
					<td width="10%"  class="style5" align="center" valign="top">TSC P/N</td>
					<td width="10%"  class="style5" align="center" valign="top">Customer P/N</td>
					<td width="10%" class="style5" align="center" valign="top">Customer Name</td>
					<td width="6%"  class="style5" align="center" valign="top">Market Group</td>
					<td width="8%"  class="style5" align="center" valign="top">PCN/PDN/IN#</td>
					<td width="6%"  class="style5" align="center" valign="top">Issue Date</td>
					<td width="10%"  class="style5" align="center" valign="top">Recommended Replacement TSC P/N</td>
					
				</tr>
<%
					}
					else if (GROUPBY.equals("2")) //by CUSTOMER
					{
%>
				<tr style="background-color:#669966;color:#ffffff;">
					<td width="2%"  class="style5" align="center" valign="top"><input type="checkbox" name="chkall" value="Y" onClick="checkall()"></td>
					<td width="4%"  class="style5" align="center" valign="top">Seq No</td>
					<td width="10%"  class="style5" align="center" valign="top">Territory</td>
					<td width="12%" class="style5" align="center" valign="top">Customer Name</td>
					<td width="14%" class="style5" align="center" valign="top">Customer P/N</td>
					<td width="14%"  class="style5" align="center" valign="top">TSC P/N</td>
					<td width="10%"  class="style5" align="center" valign="top">Market Group</td>
					<td width="10%"  class="style5" align="center" valign="top">PCN/PDN/IN#</td>
					<td width="10%"  class="style5" align="center" valign="top">Issue Date</td>
					<td width="12%"  class="style5" align="center" valign="top">Recommended Replacement TSC P/N</td>
				</tr>
<%
					}
					else if (GROUPBY.equals("3")) //by QPCN NUMBER
					{
%>
				<tr style="background-color:#669966;color:#ffffff;">
					<td width="4%"  class="style5" align="center" valign="top">Seq No</td>
					<td width="10%"  class="style5" align="center" valign="top">Territory</td>
					<td width="10%"  class="style5" align="center" valign="top">PCN/PDN/IN#</td>
					<td width="14%"  class="style5" align="center" valign="top">TSC P/N</td>
					<td width="14%" class="style5" align="center" valign="top">Customer P/N</td>
					<td width="13%" class="style5" align="center" valign="top">Customer Name</td>
					<td width="12%"  class="style5" align="center" valign="top">Market Group</td>
					<td width="10%"  class="style5" align="center" valign="top">Issue Date</td>
					<td width="12%"  class="style5" align="center" valign="top">Recommended Replacement TSC P/N</td>
				</tr>
<%
					}
				}
				
				rootPath = application.getRealPath("/jsp/QRA_Attache/"+rs.getString("PCN_NUMBER")+".pdf");
				File fp = new File(rootPath);
				if (fp.exists()) 
				{
					pdfurl = "<a href='../jsp/QRA_Attache/"+rs.getString("PCN_NUMBER")+".pdf"+"' target='_blank'><img src='images/pdf.gif' border='0' title='download pdf file'></a>";
				}
				else if (rs.getString("PDF_FILE_PATH")!=null)
				{
					pdfurl = "<a href='"+rs.getString("PDF_FILE_PATH")+"' target='_blank'><img src='images/pdf.gif' border='0' title='download pdf file'></a>";
				}		
				else
				{
					pdfurl ="";
				}				
				if (GROUPBY.equals("1")) //by TSC P/N
				{
					out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
					out.println("<td class='style5'>"+(rec_cnt+1)+"</td>");
					out.println("<td class='style5'>"+rs.getString("TERRITORY")+"</td>");
					out.println("<td class='style5' align='left'>"+rs.getString("PROD_GROUP")+"</td>");
					out.println("<td class='style5'>"+rs.getString("FAMILY")+"</td>");
					out.println("<td class='style5'>"+rs.getString("PACKAGE")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TSC P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUST P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUSTOMER")+"</td>");
					out.println("<td class='style5'>"+rs.getString("MARKET_GROUP")+"</td>");
					out.println("<td class='style5'>"+rs.getString("PCN_NUMBER")+(pdfurl.equals("")?"":"&nbsp;"+pdfurl)+(rs.getString("PCN_NUMBER").equals("QPDN14003")?"<br><font color='blue'>(SSH210 have market demand in 2015, factory can produce it)</font>":"")+"</td>");
					out.println("<td class='style5'>"+(rs.getString("PCN_CREATION_DATE")==null?"&nbsp;":rs.getString("PCN_CREATION_DATE"))+"</td>");
					out.println("<td class='style5'>"+(rs.getString("REPLACE_PART_NO")==null?"&nbsp;":rs.getString("REPLACE_PART_NO"))+"</td>");
					out.println("</tr>");
					
				}
				else if (GROUPBY.equals("2")) //by CUSTOMER
				{
					out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
					out.println("<td class='style5' align='center'><input type='checkbox' name='chk' value='"+(rs.getString("PCN_NUMBER")+"."+rs.getString("SEQID"))+"' onClick='setCheck("+rec_cnt+")'></td>");
					out.println("<td class='style5'>"+(rec_cnt+1)+"</td>");
					out.println("<td class='style5'>"+rs.getString("TERRITORY")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUSTOMER")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUST P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TSC P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("MARKET_GROUP")+"</td>");
					out.println("<td class='style5'>"+rs.getString("PCN_NUMBER")+(pdfurl.equals("")?"":"&nbsp;"+pdfurl)+(rs.getString("PCN_NUMBER").equals("QPDN14003")?"<br><font color='blue'>(SSH210 have market demand in 2015, factory can produce it)</font>":"")+"</td>");
					out.println("<td class='style5'>"+(rs.getString("PCN_CREATION_DATE")==null?"&nbsp;":rs.getString("PCN_CREATION_DATE"))+"</td>");
					out.println("<td class='style5'>"+(rs.getString("REPLACE_PART_NO")==null?"&nbsp;":rs.getString("REPLACE_PART_NO"))+"</td>");
					out.println("</tr>");
					
				}
				else if (GROUPBY.equals("3")) //by QPCN NUMBER
				{
					out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
					out.println("<td class='style5'>"+(rec_cnt+1)+"</td>");
					out.println("<td class='style5'>"+rs.getString("TERRITORY")+"</td>");
					out.println("<td class='style5'>"+rs.getString("PCN_NUMBER")+(pdfurl.equals("")?"":"&nbsp;"+pdfurl)+(rs.getString("PCN_NUMBER").equals("QPDN14003")?"<br><font color='blue'>(SSH210 have market demand in 2015, factory can produce it)</font>":"")+"</td>");
					out.println("<td class='style5'>"+rs.getString("TSC P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUST P/N")+"</td>");
					out.println("<td class='style5'>"+rs.getString("CUSTOMER")+"</td>");
					out.println("<td class='style5'>"+rs.getString("MARKET_GROUP")+"</td>");
					out.println("<td class='style5'>"+(rs.getString("PCN_CREATION_DATE")==null?"&nbsp;":rs.getString("PCN_CREATION_DATE"))+"</td>");
					out.println("<td class='style5'>"+(rs.getString("REPLACE_PART_NO")==null?"&nbsp;":rs.getString("REPLACE_PART_NO"))+"</td>");
					out.println("</tr>");
				}

				rec_cnt ++;
			}
			rs.close();
			statement.close();
			if (rec_cnt >0)
			{
	%>
			</table>
			<br>
			<!--<input type="button" name="btn1" value="Release" style="font-family: Tahoma,Georgia" <%=(GROUPBY.equals("2")?" style='visibility:visible'":" style='visibility:hidden'")%> onClick="setSubmit2()">-->
		</td>
	</tr>
	<%
			}
			else
			{
	%>
	<tr>
		<td colspan="10" align="center"><font style="font-size:12px;font-family:Tahoma;color:#C00000">No Data Found!!</font></td>
	</tr>
	
	<%
			}
		}
	}
}
catch(Exception e)
{
	out.println("exception2:"+e.toString());
}
%>	
</table>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>