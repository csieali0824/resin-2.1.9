<%@ page language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit2(URL)
{
	subWin=window.open(URL,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
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
<title>SG Forecast Item</title>
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
int job_cnt=0;
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGForecastItemQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Forecast Item Query</font></strong>
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
		<OPTION VALUE="907" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG-D</OPTION>
		<OPTION VALUE="908" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG-E</OPTION>
		<!--<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>-->
		</select>
		</td>	
		<td width="15%"><font color="#666600">Item Name/Description:</font></td>
		<td width="15%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family:Arial;font-size:12px" size="25"></td>
		<td>
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGForecastItemQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='Import Data' onClick='setSubmit2("../jsp/TSCSGForecastItemUpload.jsp")'  style="font-family: Tahoma,Georgia"> 
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	pstmtNLS.executeUpdate(); 
	pstmtNLS.close();
			
	Statement statement1=con.createStatement();
	ResultSet rs1=statement1.executeQuery("select count(1) from FND_CONC_REQ_SUMMARY_V where PROGRAM_SHORT_NAME='TSSG_FORECAST_ITEM_UPDATE' AND ACTUAL_COMPLETION_DATE is null");
	if (rs1.next())
	{
		job_cnt = rs1.getInt(1);
	}
	rs1.close();
	statement1.close();
	
	if (job_cnt >0)
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>The data update in processing,please query later</strong></font></div>");
	}		
	else
	{
		sql = " SELECT B.ORGANIZATION_CODE,A.SEGMENT1 ITEM_NAME,A.DESCRIPTION ITEM_DESC "+
		      ",CASE WHEN B.ORGANIZATION_CODE='SG1' THEN 'SG-D' ELSE 'SG-E' END ORGANIZATION_NAME"+
		      " FROM INV.MTL_SYSTEM_ITEMS_B A,INV.MTL_PARAMETERS B "+
		      " WHERE A.ORGANIZATION_ID=B.ORGANIZATION_ID "+
			  " AND A.ORGANIZATION_ID in (?,?) "+
			  " AND NVL(A.ATTRIBUTE16,'N')=? ";
		if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
		{
			sql += " AND B.ORGANIZATION_CODE='"+ORGCODE+"'";
		}
		if (!ITEM.equals(""))
		{
			sql += " AND (A.SEGMENT1 LIKE '"+ ITEM.toUpperCase()+"%' OR A.DESCRIPTION LIKE '"+ITEM.toUpperCase()+"%')";
		}
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"907");
		statement.setString(2,"908");
		statement.setString(3,"Y");
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
					<td width="10%">Org Code</td>
					<td width="45%">Item Name</td>
					<td width="40%">Item Desc</td>
				</tr>
			
<%		
			}
			icnt++;
%>
				<tr>
					<td><%=icnt%></td>
					<td align="left"><%=rs.getString("ORGANIZATION_NAME")%></td>
					<td align="left"><%=rs.getString("ITEM_name")%></td>
					<td align="left"><%=rs.getString("ITEM_DESC")%></td>
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

