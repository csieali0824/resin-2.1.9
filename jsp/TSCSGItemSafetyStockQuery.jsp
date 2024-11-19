<%@ page language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{
	subWin=window.open(URL,"subwin","left=250,width=120,height=100,scrollbars=yes,menubar=no");  
}
function setSubmit2(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
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
<title>SG Safety Stock</title>
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
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<%
String sql = "";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String C_MONTH = request.getParameter("C_MONTH");
if (C_MONTH==null || C_MONTH.equals("--")) C_MONTH="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGItemSafetyStockQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Safety Stock Query</font></strong>
<BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 400px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">The data processing,please wait while.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%"><font color="#666600" >Org Code:</font></td>   
		<td width="7%"><select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="SG1" <%if (ORGCODE.equals("SG1")) out.println("selected");%>>SG-D</OPTION>
		<OPTION VALUE="SG2" <%if (ORGCODE.equals("SG2")) out.println("selected");%>>SG-E</OPTION>
		<!--<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>-->
		</select>
		</td>	
		<td width="15%"><font color="#666600">Item Name/Description:</font></td>
		<td width="15%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family:Arial;font-size:12px" size="25"></td>
		<td width="15%"><font color="#666600">Calculate  Month:</font></td>
		<td width="15%">		
		<%
	      PreparedStatement statement1 = con.prepareStatement("SELECT C_MONTH,C_MONTH FROM (SELECT C_MONTH FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK a GROUP BY C_MONTH ORDER BY C_MONTH desc) WHERE ROWNUM<=5");
		  ResultSet rs1=statement1.executeQuery();			
		  comboBoxBean.setRs(rs1);
	      comboBoxBean.setSelection(C_MONTH);
	      comboBoxBean.setFieldName("C_MONTH");	   
          out.println(comboBoxBean.getRsString());		
		  rs1.close();
		  statement1.close();	
		%>
		</td>
		<td>
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGItemSafetyStockQuery.jsp")' > 
			&nbsp;
			<INPUT TYPE="button" align="middle"  value='Excel' onClick='setSubmit2("../jsp/TSCSGItemSafetyStockExcel.jsp")'  style="font-family: Tahoma,Georgia" > 
			&nbsp;
			<INPUT TYPE="button" align="middle"  value='Calculate Safety Stock' onClick='setSubmit1("../jsp/TSCSGItemSafetyStockJob.jsp")' style="font-family: Tahoma,Georgia" > 
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	int job_cnt =0,job_id=2377;
	Statement statement2=con.createStatement();
	ResultSet rs2=statement2.executeQuery("select 1 from dba_jobs_running where JOB="+job_id+" union all select 1 from user_scheduler_jobs WHERE JOB_NAME = 'TSSG SAFETY STOCK JOB:"+job_id+"'");
	if (rs2.next())
	{
		job_cnt = rs2.getInt(1);
	}
	rs2.close();
	statement2.close();
	
	if (job_cnt >0)
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>The datas is updating,please wait a while!</strong></font></div>");
	}
	else
	{

		String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
		pstmtNLS.executeUpdate(); 
		pstmtNLS.close();
				
		sql = " SELECT A.ORGANIZATION_CODE,A.ITEM_NAME,A.ITEM_DESC,A.C_MONTH,A.SAFETY_STOCK,A.TSC_PROD_GROUP,TO_CHAR(A.CREATION_DATE,'yyyy/mm/dd hh24:mi') CREATION_DATE,A.SPQ,A.SUGGEST_SAFETY_STOCK "+
		      ",tsc_inv_category(a.inventory_item_id,43,23) TSC_PACKAGE"+
			  ",CASE WHEN A.ORGANIZATION_CODE='SG1' THEN 'SG-D' ELSE 'SG-E' END ORGANIZATION_NAME"+
        	  " FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK A"+
			  " WHERE 1=1";
		if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
		{
			sql += " AND A.ORGANIZATION_CODE='"+ORGCODE+"'";
		}
		if (!ITEM.equals(""))
		{
			sql += " AND (A.ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%')";
		}
		if (!C_MONTH.equals(""))
		{
			sql += " AND a.JOB_ID IN (SELECT MAX(JOB_ID) FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK B WHERE B.C_MONTH='"+C_MONTH +"')";
		}
		sql += " order by A.ORGANIZATION_CODE,a.C_MONTH desc,a.TSC_PROD_GROUP,a.ITEM_DESC";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		while (rs.next())
		{
			if (icnt ==0)
			{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
			<tr bgcolor="#C8E3E8" style="font-family: Tahoma,Georgia;font-size:11px" align="center">
				<td width="5%">&nbsp;</td>
				<td width="7%">Org Code</td>
				<td width="7%">Calculate Month</td>
				<td width="8%">TSC Prod Group</td>
				<td width="8%">TSC Package</td>
				<td width="16%">Item Name</td>
				<td width="14%">Item Desc</td>
				<td width="8%">Safety Stock(PCS)</td>
				<td width="8%">SPQ</td>
				<td width="11%">Suggest Safety Stock(PCS)</td>
				<td width="8%">Creation Date</td>
			</tr>
			
<%		
			}
			icnt++;
%>
			<tr>
				<td><%=icnt%></td>
				<td align="left"><%=rs.getString("ORGANIZATION_NAME")%></td>
				<td align="left"><%=rs.getString("C_MONTH")%></td>
				<td align="left"><%=rs.getString("TSC_PROD_GROUP")%></td>
				<td align="left"><%=rs.getString("TSC_PACKAGE")%></td>
				<td align="left"><%=rs.getString("ITEM_name")%></td>
				<td align="left"><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=rs.getString("SAFETY_STOCK")%></td>
				<td align="right"><%=rs.getString("SPQ")%></td>
				<td align="right"><%=rs.getString("SUGGEST_SAFETY_STOCK")%></td>
				<td align="center"><%=rs.getString("CREATION_DATE")%></td>
			</tr>
<%
		}
		rs.close();
		statement.close();
		if (icnt >0)
		{
	%>
			</table>
	<%
	
		}
		else
		{
			out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
		}
	}
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

