<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>Order Change Confirm</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8}
  .style2   {font-family:Tahoma,Georgia;border:none}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:11px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setDelete(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		iLen = document.MYFORM.CHKBOX.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.CHKBOX.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i-1].checked 
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
	else
	{	
		if (confirm("資料一經刪除,將無法恢原,您確定要刪除資料嗎?"))
		{
			document.MYFORM.action=URL;
			document.MYFORM.submit();
		}
	}
}
function subWindowConditionList(obj)
{   
	if (obj != null)
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
}
function chkall()
{
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.CHKBOX.length ;i++)
		{
			document.MYFORM.CHKBOX[i].checked= document.MYFORM.CHKBOXALL.checked;
			setCheck((i+1));
		}
	}
	else
	{
		document.MYFORM.CHKBOX.checked = document.MYFORM.CHKBOXALL.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		chkflag = document.MYFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.MYFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor = "#D7F4CC";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#F5F5F5";
	}
}
</script>
<%
String QTRANS = request.getParameter("QTRANS");
if (QTRANS==null) QTRANS="";
String TSCFAMILY = request.getParameter("TSCFAMILY");
if (TSCFAMILY==null) TSCFAMILY="";
String TSCPACKAGE = request.getParameter("TSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TERRITORY = request.getParameter("TERRITORY");
if (TERRITORY==null) TERRITORY="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String MARKETGROUP = request.getParameter("MARKETGROUP");
if (MARKETGROUP==null) MARKETGROUP="";
String TSCPARTNO = request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="";
String SEQID = request.getParameter("SEQID");
if (SEQID==null) SEQID="";
String DATECODE = request.getParameter("DATECODE");
if (DATECODE ==null) DATECODE ="";
String QPage = request.getParameter("QPage");
if (QPage ==null) QPage="1";
float PageSize=100;
float LastPage=0;
float dataCnt=0;
float NowPage = Float.parseFloat(QPage);
String CREATIONDATE = request.getParameter("CREATIONDATE");
if (CREATIONDATE==null) CREATIONDATE=dateBean.getYearMonthDay();
String ENDDATE = request.getParameter("ENDDATE");
if (ENDDATE==null) ENDDATE="";
String sql = "";

if (QTRANS.equals("D"))
{
	String chk[]= request.getParameterValues("CHKBOX");	
	if (chk.length >0)
	{
		for(int i=0; i< chk.length ;i++)
		{
			sql = " delete oraddman.tsqra_pcn_item_detail where PCN_NUMBER=? AND SEQID=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ID); 
			pstmtDt.setString(2,chk[i]);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="TSCQRAProductChangeDetail.jsp" METHOD="post" NAME="MYFORM">
<HR>
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td width="80%"><input type="text" name="ID" value="<%=ID%>" style="font-family:Tahoma;font-weight:bold;color:#006666;font-size:13px;border:#FF0000" readonly onKeyDown="return (event.keyCode!=8);" size="30">
					</td>
					<td align="right"><A href="TSCQRAProductChangeSummary.jsp"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgFunction"/></A>
					</td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td width="15%" style="color:#006666;background-color:#DCE6E7" align="center">TSC P/N</td>
					<td width="20%" style="color:#006666;background-color:#DCE6E7" align="center">Family<A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Family選單畫面" onClick="subWindowConditionList('TSCFAMILY')"><img src="images/search.gif" border="0"></A></td>
					<td width="15%" style="color:#006666;background-color:#DCE6E7" align="center">Package<A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Package選單畫面" onClick="subWindowConditionList('TSCPACKAGE')"><img src="images/search.gif" border="0"></A></td>
					<td width="15%" style="color:#006666;background-color:#DCE6E7" align="center">Territory<A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Territory選單畫面" onClick="subWindowConditionList('TERRITORY')"><img src="images/search.gif" border="0"></A></td>
					<td width="15%" style="color:#006666;background-color:#DCE6E7" align="center">Market Group<A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Market Group選單畫面" onClick="subWindowConditionList('MARKETGROUP')"><img src="images/search.gif" border="0"></A></td>
					<td width="20%" style="color:#006666;background-color:#DCE6E7" align="center">Customer</td>
				</tr>
				<tr>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="TSCPARTNO"><%=TSCPARTNO%></textarea></td>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="TSCFAMILY"><%=TSCFAMILY%></textarea></td>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="TSCPACKAGE"><%=TSCPACKAGE%></textarea></td>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="TERRITORY"><%=TERRITORY%></textarea></td>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="MARKETGROUP"><%=MARKETGROUP%></textarea></td>
					<td style="color:#006666;background-color:#DCE6E7" align="center"><textarea cols="25" rows="6" name="CUSTOMER"><%=CUSTOMER%></textarea></td>
				</tr>
				<tr>
					<td colspan="6" style="color:#006666;background-color:#DCE6E7"><hr></td>
				</tr>
				<tr>
					<td colspan="6" style="color:#006666;background-color:#DCE6E7" align="center" height="30"><input type="button" name="Query" value="Query" style="font-family: Tahoma,Georgia;" onClick='setQuery("../jsp/TSCQRAProductChangeDetail.jsp?QTRANS=Q")'></td>
				</tr>			
				<tr>
					<td colspan="6" style="color:#006666;background-color:#DCE6E7"><hr></td>
				</tr>
			</table>		
		</td>
	</tr>
<%
sql = " select distinct ROWNUM AS ROWNO ,c.PCN_NUMBER,c.PCN_TYPE,c.PCN_CREATION_DATE,b.TSC_PART_NO \"TSC P/N\""+
	  ",b.TSC_PROD_GROUP PROD_GROUP"+
	  ",b.TSC_PACKAGE PACKAGE"+
	  ",b.TSC_FAMILY FAMILY"+
	  ",b.TSC_PACKING_CODE AS \"PACKING CODE\""+
	  ",b.TSC_AMP AMP"+
	  ",b.MARKET_GROUP"+
	  ",b.CUST_SHORT_NAME customer"+
	  ",b.TERRITORY"+
	  ",b.CUST_PART_NO \"CUST P/N\""+
	  ",b.DATE_CODE datecode"+
	  ",b.source_type"+
	  ",b.SEQID"+
	  ",c.PCN_END_DATE"+     
	  " from oraddman.tsqra_pcn_item_detail b ,oraddman.tsqra_pcn_item_header c"+
	  " where b.PCN_NUMBER(+)=c.PCN_NUMBER"+
	  " and b.PCN_NUMBER=?";
if (!TSCFAMILY.equals("--") && !TSCFAMILY.equals(""))
{
	String [] strFamily = TSCFAMILY.split("\n");
	String FamilyList = "";
	for (int x = 0 ; x < strFamily.length ; x++)
	{
		if (FamilyList.length() >0) FamilyList += ",";
		FamilyList += "'"+strFamily[x].trim().toUpperCase()+"'";
	}
	sql += " and upper(b.TSC_FAMILY) in ("+FamilyList+")";
}
if (!TSCPACKAGE.equals("") && !TSCPACKAGE.equals("--"))
{
	String [] strPackage = TSCPACKAGE.split("\n");
	String PackageList = "";
	for (int x = 0 ; x < strPackage.length ; x++)
	{
		if (PackageList.length() >0) PackageList += ",";
		PackageList += "'"+strPackage[x].trim().toUpperCase()+"'";
	}
	sql += " and upper(b.TSC_PACKAGE) IN  ("+PackageList+")";
}
if (!TERRITORY.equals("") && !TERRITORY.equals("--"))
{
	String [] strTerritory = TERRITORY.split("\n");
	String TerritoryList = "";
	for (int x = 0 ; x < strTerritory.length ; x++)
	{
		if (TerritoryList.length() >0) TerritoryList += ",";
		TerritoryList += "'"+strTerritory[x].trim().toUpperCase()+"'";
	}
	sql += " and upper(b.TERRITORY) in ("+TerritoryList+")";
}
if (!MARKETGROUP.equals("") && !MARKETGROUP.equals("--"))
{
	String [] strMarketGroup = MARKETGROUP.split("\n");
	String MarketGroupList = "";
	for (int x = 0 ; x < strMarketGroup.length ; x++)
	{
		if (MarketGroupList.length() >0) MarketGroupList += ",";
		MarketGroupList += "'"+strMarketGroup[x].trim().toUpperCase()+"'";
	}
	sql += " and upper(b.MARKET_GROUP) in ("+MarketGroupList+")";
}
if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
{
	String [] sArray = CUSTOMER.split("\n");
	String sList = "";
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
		sql += " lower(b.CUST_SHORT_NAME) like '%"+sArray[x].toLowerCase()+"%'";
	}
	sql += " )";
}
if (!TSCPARTNO.equals("") && !TSCPARTNO.equals("--"))
{
	String [] sArray = TSCPARTNO.split("\n");
	for (int x =0 ; x < sArray.length ; x++)
	{
		if (x==0)
		{
			sql += " and (upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
			if (x==sArray.length -1) sql += ")";
		}
		else if (x==sArray.length -1)
		{
			sql += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%')";
		}
		else
		{
			sql += " or upper(b.TSC_PART_NO) like '"+sArray[x].trim().toUpperCase()+"%'";
		}
	}
}
sql +=  " order by b.TSC_PART_NO,b.source_type,b.TSC_PART_NO,b.CUST_SHORT_NAME ";
String sql1 = " select count(1) rowcnt from ("+sql+") ss";
//out.println(sql+ID);
try
{
	PreparedStatement statement1 = con.prepareStatement(sql1);
	statement1.setString(1,ID);
	ResultSet rs1=statement1.executeQuery();
	while (rs1.next())
	{
		//總筆數
		dataCnt = Float.parseFloat(rs1.getString("rowcnt"));
		//最後頁數
		LastPage = (int)(Math.ceil(dataCnt / PageSize));
	}
	rs1.close();
	statement1.close();	
}
catch(Exception e)
{
	out.println("Error:"+e.getMessage());
}
sql ="select * from ("+sql+") a where ROWNO between "+(int)((NowPage-1)*PageSize+1) +" and "+ (int)(NowPage*PageSize)+"";
//out.println(sql);
try
{
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ID);
	ResultSet rs=statement.executeQuery();
	int rowcnt =0;
	while (rs.next())
	{
		if (rowcnt ==0)
		{
				
%>
	<tr>
		<td>
			<table width="100%" border="0">
				<tr>
					<td><font face="標楷體" color="blue">查詢結果共<%=(int)dataCnt%>筆資料，每頁顯示<%=(int)PageSize%>筆/共<%=(int)LastPage%>頁</font>
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<input type=button name="FPage" id="FPage" value="<<" onClick="setQuery('../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=QRY&QPage=1')" <%if(NowPage==1){ out.println("disabled");}%> title="First Page">
						&nbsp;
						<input type=button name="PPage" id="PPage" value="<" onClick="setQuery('../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=QRY&QPage=<%=(NowPage-1)%>')"  <%if(NowPage==1){ out.println("disabled");}%> title="Previous Page">
						&nbsp;&nbsp;<font face='標楷體' color='blue'>第<%=(int)NowPage%>頁</font>&nbsp;&nbsp;
						<input type=button name="NPage" id="NPage" value=">" onClick="setQuery('../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=QRY&QPage=<%=(NowPage+1)%>')"  <%if(NowPage==LastPage){ out.println("disabled");}%> title="Next Page">
						&nbsp;
						<input type=button name="LPage" id="LPage" value=">>" onClick="setQuery('../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=QRY&QPage=<%=LastPage%>')" <%if(NowPage==LastPage){ out.println("disabled");}%> title="Last Page">
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
				<tr style="background-color:#006666;color:#FFFFFF;">
					<td width="3%" align="center"><input type='checkbox' name='CHKBOXALL' onClick='chkall();'></td>
					<td width="12%">TSC P/N</td>
					<td width="5%">Prod<BR>Group</td>
					<td width="12%">Family</td>
					<td width="10%">Package</td>
					<td width="7%">Packing Code</td>
					<td width="4%">Io(Amp)</td>
					<td width="7%">Territory</td>
					<td width="6%">Market Group</td>
					<td width="19%">Customer</td>
					<td width="10%">Cust P/N</td>
					<td width="5%">Source<br>Type</td>
				</tr>
<%				
		}
		rowcnt ++;
		out.println("<tr id='tr_"+(rowcnt)+"' bgcolor='#F5F5F5'>");
		//out.println("<td style='font-family:arial;font-size:12px'><input type='button' name='DELETE_"+rs.getString("SEQID")+"' value='DEL' style='font-family:arial;font-size:12px' onclick='setDelete("+'"'+"../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=DEL&QPage="+NowPage+"&ID="+ID+"&SEQID="+rs.getString("SEQID")+'"'+")'>&nbsp;<input type='button' name='UPDATE' value='Update' style='font-family:arial;font-size:12px' onclick='setUpdate("+'"'+"../jsp/TSCQRAProductChangeDetail.jsp?ACTIONCODE=UPD&QPage="+NowPage+"&ID="+ID+"&SEQID="+rs.getString("SEQID")+'"'+","+rs.getString("SEQID")+")'></td>");
		out.println("<td align='center'><input type='checkbox' name='CHKBOX' value='"+(rs.getString("SEQID"))+"'  onclick=setCheck('"+(rowcnt)+"');></td>");		
		out.println("<td>"+rs.getString("TSC P/N")+"</td>");
		out.println("<td>"+rs.getString("PROD_GROUP")+"</td>");
		out.println("<td>"+rs.getString("FAMILY")+"</td>");
		out.println("<td>"+rs.getString("PACKAGE")+"</td>");
		out.println("<td>"+rs.getString("PACKING CODE")+"</td>");
		out.println("<td>"+(rs.getString("AMP")==null?"N/A":rs.getString("AMP"))+"</td>");
		out.println("<td>"+(rs.getString("TERRITORY")==null?"N/A":rs.getString("TERRITORY"))+"</td>");
		out.println("<td>"+(rs.getString("MARKET_GROUP")==null?"N/A":rs.getString("MARKET_GROUP"))+"</td>");
		out.println("<td>"+(rs.getString("CUSTOMER")==null?"N/A":rs.getString("CUSTOMER"))+"</td>");
		out.println("<td>"+(rs.getString("CUST P/N")==null || rs.getString("CUST P/N").equals("null")?"N/A":rs.getString("CUST P/N"))+"</td>");
		out.println("<td>"+(rs.getString("source_type").equals("1")?"ERP":"N/A")+"</td>");
		out.println("</tr>");
	}
	rs.close();
	statement.close();	
	if (rowcnt >0)
	{
%>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center"><input type="button" name="delete" value="Delete" style="font-family:Tahoma" onClick='setDelete("../jsp/TSCQRAProductChangeDetail.jsp?QTRANS=D")'></td>
	</tr>
<%
	}
	else
	{
		out.println("<tr><td align='center' style='font-weight:bold;font-size:12px;color:#ff0000'>No Data Found!!</td></tr>");
	}  
}
catch(Exception e)
{
	out.println("Error1:"+e.getMessage());
}	  
%>
</table>
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
