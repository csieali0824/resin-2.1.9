<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.Math.*,java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,ComboBoxBean,ArrayComboBoxBean,javax.xml.parsers.*,CodeUtil"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style5   {font-family:Tahoma,Georgia;font-size:12px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
	if (document.MYFORM.TSCPARTNO.value==""
	    && document.MYFORM.TSCPACKAGE.value==""
	    && document.MYFORM.TSCDATECODE.value==""
	    && document.MYFORM.SDATE.value==""
	    && document.MYFORM.EDATE.value==""
	    && document.MYFORM.check1.checked==false
	    && document.MYFORM.check2.checked==false
	    && document.MYFORM.check3.checked==false)
	{
		alert("Please enter anyone condiction!");
		return false;
	}
	else if (document.MYFORM.SDATE.value==""&& document.MYFORM.EDATE.value=="")
	{
		if (!confirm("Are you sure to search data code data under no specified date?\nThis may cause the search time to be too long.."))
		{
			return false;
		}
	}
	document.getElementById("alpha").style.width=document.body.scrollWidth+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setClear()
{
	document.MYFORM.TSCPARTNO.value="";
	document.MYFORM.TSCPACKAGE.value="";
	document.MYFORM.TSCDATECODE.value="";
	document.MYFORM.SDATE.value="";
	document.MYFORM.EDATE.value="";
	document.MYFORM.check1.checked=false;
	document.MYFORM.check2.checked=false;
	document.MYFORM.check3.checked=false;
}

function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

</script>
</head>
<%
String QTRANS = request.getParameter("QTRANS");
if (QTRANS==null) QTRANS="";
String TSCPACKAGE = request.getParameter("TSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TSCDATECODE = request.getParameter("TSCDATECODE");
if (TSCDATECODE==null) TSCDATECODE="";
String EDATE = request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String SDATE = request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String TSCPARTNO=request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String PRD_FLAG = request.getParameter("check1");
if (PRD_FLAG==null) PRD_FLAG="";
String SSD_FLAG = request.getParameter("check2");
if (SSD_FLAG==null) SSD_FLAG="";
String PMD_FLAG = request.getParameter("check3");
if (PMD_FLAG==null) PMD_FLAG="";
String sql ="",s_where="",s_orderby="";
%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSCDateCodeQuery.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="ARIAL" size="+1">The data processing, please wait.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font size=4><strong>TSC Date Code Query</strong></font>
<table width="100%">
	<tr>
		<td colspan="3" align="right">
		<A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
		</td>
	</tr>
	<tr>
		<td colspan="3">
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr>
					<td style="background-color:#DCE6E7" width="7%"><font color="#006666">TSC P/N</font></td>
					<td width="15%"><textarea cols="35" rows="5" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>
					<td style="background-color:#DCE6E7" width="7%"><font color="#006666">TSC D/C</font></td>
					<td width="10%"><textarea cols="25" rows="5" name="TSCDATECODE" class="style5"><%=TSCDATECODE%></textarea></td>
					<td style="background-color:#DCE6E7" width="7%"><font color="#006666">Product Group</font></td>
					<td width="10%" valign="middle"><input type="checkbox" name="check1" value="PRD" <%=(!PRD_FLAG.equals("")?"checked":"")%>>PRD<br>
					<input type="checkbox" name="check2" value="SSD" <%=(!SSD_FLAG.equals("")?"checked":"")%>>SSD<br>
					<input type="checkbox" name="check3" value="PMD" <%=(!PMD_FLAG.equals("")?"checked":"")%>>PMD<br>
					</td>
					<!--<td style="background-color:#DCE6E7" width="7%"><font color="#006666">Package</font><br><A href="javascript:void(0)" title="Click the left mouse button to open the Package menu" onClick="subWindowConditionList('TSCPACKAGE')"><img src="images/search.gif" border="0"></A></td>
					<td width="10%"><textarea cols="25" rows="5" name="TSCPACKAGE" class="style5"><%=TSCPACKAGE%></textarea></td>-->
					<td style="background-color:#DCE6E7" width="7%"><font color="#006666">D/C Date</font></td>
					<td width="20%">  
						<input type="text" name="SDATE" class="style5" value="<%=SDATE%>" SIZE="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57">
						<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>~
						<input type="text" name="EDATE" class="style5" value="<%=EDATE%>" size="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>			      </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="center">
		<p>
		<input type="button" name="submit1" value="Query" style="font-family:arial" onClick='setSubmit("../jsp/TSCDateCodeQuery.jsp?QTRANS=Q")'>
		&nbsp;<input type="button" name="submit2" value="Public Date Code Excel" style="font-family:arial;background-color:#FF9933" onClick='setExportXLS("../jsp/TSCDateCodeExcel.jsp")'>
		&nbsp;<input type="button" name="clear" value="Clear" style="font-family:arial" onClick="setClear()">
		</td>
	</tr>
	<tr><td colspan="3">&nbsp;</td></tr>
<%
try
{
	int rec_cnt =0;
	if (QTRANS.equals("Q"))
	{	
	%>
	<tr>
		<td width="20%"></td>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
				<tr style="background-color:#006666;color:#ffffff;">
					<td width="5%"  style="font-family:arial;font-size:12px">&nbsp;</td>
					<td width="15%" style="font-family:arial;font-size:12px">Division</td>
					<td width="15%"  style="font-family:arial;font-size:12px">TSC D/C</td>
					<td width="15%"  style="font-family:arial;font-size:12px">D/C(Year)</td>
					<td width="15%"  style="font-family:arial;font-size:12px">D/C(Month)</td>
					<td width="15%"  style="font-family:arial;font-size:12px">D/C(Week)</td>
					<td width="20%"  style="font-family:arial;font-size:12px" align="center">D/C(YYYY/MM/DD)</td>
				</tr>
		<%
		sql = " SELECT a.year"+
		      ",a.date_type"+
			  ",a.date_value"+
			  ",a.date_code"+
			  ",a.prod_group"+
              ",a.vendor"+
			  ",a.customer"+
			  ",a.factory_code"+
			  ",a.green_flag"+
			  ",to_char(to_date(case date_type when 'MONTH' THEN year||LPAD(DATE_VALUE,2,'0') ||'01' WHEN 'WEEK' then '20'||tsc_get_calendar_date(year||lpad(date_value,2,'0'),null) else '' end,'yyyymmdd'),'yyyy/mm/dd') as manufacture_date"+
			  ",case date_type when 'MONTH' then TO_CHAR(a.date_value) else '' end as MONTH"+
			  ",case date_type when 'WEEK' then TO_CHAR(a.date_value) else '' end as WEEK"+
    		  ",a.dc_rule"+			  
              " FROM tsc.tsc_date_code a"+
              " where 1=1";
		if (!PRD_FLAG.equals("")|| !SSD_FLAG.equals("") || !PMD_FLAG.equals(""))
		{
			s_where += " and a.prod_group in ('"+PRD_FLAG+"','"+SSD_FLAG+"','"+PMD_FLAG+"')";
		}
		//if (!TSCPACKAGE.equals(""))
		//{
		//	String [] strPackage = TSCPACKAGE.split("\n");
		//	String PackageList = "";
		//	for (int x = 0 ; x < strPackage.length ; x++)
		//	{
		//		if (PackageList.length() >0) PackageList += ",";
		//		PackageList += "'"+strPackage[x].trim().toUpperCase()+"'";
		//	}
		//	sql += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and substr(tsc_inv_category(msi.inventory_item_id,43,1100000003),1,3)=a.prod_group and tsc_inv_category(msi.inventory_item_id,43,23) IN  ("+PackageList+"))";
		//}
		if (!TSCPARTNO.equals(""))
		{
			String [] sArray = TSCPARTNO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					s_where += " and exists (select 1 from inv.mtl_system_items_b msi where msi.organization_id=43 and substr(tsc_inv_category(msi.inventory_item_id,43,1100000003),1,3)=a.prod_group and (upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					s_where += " or upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) s_where += "))";
			}
		}
		if (!TSCDATECODE.equals(""))
		{
			String [] strDC = TSCDATECODE.split("\n");
			String DCList = "";
			for (int x = 0 ; x < strDC.length ; x++)
			{
				if (x==0)
				{
					s_where += " and (a.date_code like '"+strDC[x].trim()+"'";
				}
				else
				{
					s_where += " or a.date_code like '"+strDC[x].trim()+"'";
				}				
				if (x==strDC.length -1) s_where +=")";
			}
		}	
		if (!SDATE.equals("") || !EDATE.equals(""))
		{
			s_where += " and to_date(case date_type when 'MONTH' THEN year||LPAD(DATE_VALUE,2,'0') ||'01' WHEN 'WEEK' then '20'||tsc_get_calendar_date(year||lpad(date_value,2,'0'),null) else '' end,'yyyymmdd') between to_date(nvl('"+SDATE+"','"+(Integer.parseInt(dateBean.getYearString())-3)+"0101'),'yyyymmdd') and to_date(NVL('"+EDATE+"','20991231'),'yyyymmdd')";
		}	

		s_orderby =" order by decode(a.prod_group,'PRD',1,'PMD',2,3),a.YEAR,a.DC_RULE,a.DATE_TYPE,a.DATE_VALUE,a.DATE_CODE";
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next())
		{
			out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
			out.println("<td style='font-family:arial;font-size:12px'>"+(rec_cnt+1)+"</td>");
			out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("PROD_GROUP")+"</td>");
			out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("DATE_CODE")+"</td>");
			out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("YEAR")+"</td>");
			out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("MONTH")==null?"&nbsp;":rs.getString("MONTH"))+"</td>");
			out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("WEEK")==null?"&nbsp;":rs.getString("WEEK"))+"</td>");
			out.println("<td style='font-family:arial;font-size:12px' align='center'>"+rs.getString("MANUFACTURE_DATE")+"</td>");
			out.println("</td>");
			out.println("</tr>");
			rec_cnt ++;
		}
		rs.close();
		statement.close();
%>			
			</table>
		</td>
		<td width="20%"></td>
	</tr>
<%
		if (rec_cnt ==0)
		{
%>
	<tr>
		<td  colspan="3" align="center" style="font-family:'arial';font-size:13px;color:#FF0000">No data found!</td>
	</tr>
<%
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
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>