<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%> 
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean" %>
<%@ page import="java.util.Date"%> 	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>工令明細查詢報表</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	var RPTTYPE="";
	var SDATE="";
	var EDATE="";
	var DEPTNO = document.MYFORM.DEPTNO.value;
	if ( DEPTNO=="--")  DEPTNO="";
	var WIPNO = document.MYFORM.WIPNO.value;
	var ITEMNO = document.MYFORM.ITEMNO.value;
	var STATUS = document.MYFORM.STATUS.value;
 	for (var i=0; i<document.MYFORM.rdo.length; i++)
    {
    	if (document.MYFORM.rdo[i].checked)
      	{
			RPTTYPE = document.MYFORM.rdo[i].value;
		}
	}
	if (RPTTYPE=="")
	{
		alert("請輸入報表種類!!");
		return false;
	}
	if (document.MYFORM.STARTDATE.value==null || document.MYFORM.STARTDATE.value=="" || document.MYFORM.ENDDATE.value==null || document.MYFORM.ENDDATE.value=="")
	{
		alert("請輸入開工日!!");
		return false;
	}
	else
	{
		SDATE = document.MYFORM.STARTDATE.value;
		EDATE = document.MYFORM.ENDDATE.value;
	}
	//document.MYFORM.submit1.disabled=true;
	//document.getElementById("alpha").style.width="100"+"%";
	//document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	//document.getElementById("showimage").style.visibility = '';
	//document.getElementById("blockDiv").style.display = '';
	//subWin=window.open(URL+"?RPTTYPE="+RPTTYPE+"&SDATE="+SDATE+"&EDATE="+EDATE+"&DEPTNO="+DEPTNO+"&ITEMNO="+ITEMNO+"&STATUS="+STATUS,"subwin","width=10,height=10,scrollbars=yes,menubar=no,location=no");
	document.MYFORM.action=URL+"?RPTTYPE="+RPTTYPE+"&SDATE="+SDATE+"&EDATE="+EDATE+"&DEPTNO="+DEPTNO+"&ITEMNO="+ITEMNO+"&STATUS="+STATUS+"&WIPNO="+WIPNO;
	document.MYFORM.submit(); 
}
</script>
</head>
<body>
<form name="MYFORM" method="post" >
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 160px; left: 500px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在下載中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 200px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table border="0" width="50%" align='center'>
	<tr>
		<td colspan="3" align="center" style="font-weight:bolder;font-family:'標楷體';font-size:26px">工令明細報表查詢</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align="right"><A HREF="../ORAddsMainMenu.jsp" style="font-size:14px;font-family:標楷體;text-decoration:none;color:#0000FF">
						<STRONG>回首頁</STRONG>
						</A></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="70%">
			<table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
				<tr>
	    			<td width="30%" style="font-family:'新細明體';font-size:12px" nowrap>報表種類</td> 
					<td width="70%"><input type="radio" name="rdo" value="1" style="font-family:'新細明體';font-size:12px"><font style="font-family:'新細明體';font-size:12px">前段</font>
		                			&nbsp;&nbsp;&nbsp;
									<input type="radio" name="rdo" value="2" style="font-family:'新細明體';font-size:12px"><font style="font-family:'新細明體';font-size:12px">後段</font>
					</td>
				</tr>
				<tr>
	    			<td style="font-family:'新細明體';font-size:12px">部門別</td>
	    			<td style="font-family:'新細明體';font-size:12px">
					<%
					try
					{    
						String sql = "SELECT CODE,CODE_DESC FROM yew_mfg_defdata A WHERE  def_type='MFG_DEPT_NO' and CODE in (1,2,3)";
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery(sql);
						comboBoxBean.setRs(rs1);
						comboBoxBean.setFieldName("DEPTNO");	   
						out.println(comboBoxBean.getRsString());
						rs1.close();       
						statement1.close();
					} 
					catch (Exception e)
					{
						out.println("Exception1:"+e.getMessage());
					}
					%>
					</td>
				</tr>
				<tr>
					<td style="font-family:'新細明體';font-size:12px">開工日</td>
					<td><input type="text" name="STARTDATE"  size="6" style="font-family:Arial;text-align:center" readonly>
					<%
							out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.STARTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");					
					%>
						~<input type="text" name="ENDDATE"  size="6" style="font-family:Arial;text-align:center" readonly>
					<%
							out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.ENDDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");					
					%>
					</td>
				</tr>
				<tr>
					<td style="font-family:'新細明體';font-size:12px">工令號</td>
					<td><input type="text" name="WIPNO" style="font-family:'ARIAL'"></td>
				</tr>
				<tr>
					<td style="font-family:'新細明體';font-size:12px">料號</td>
					<td><input type="text" name="ITEMNO" style="font-family:'ARIAL'"></td>
				</tr>
				<tr>
					<td width="10%" style="font-family:'新細明體';font-size:12px" nowrap>工令狀態</td> 
					<td width="90%"><select name="STATUS" style="font-family:arial;font-size:12px">
					                <option value="--" selected="selected">--
									<option value="OPEN">OPEN
									<option value="CLOSED">CLOSED
									</select>
					</td>
				</tr>
			</table>  
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3" align="center"><input type="button" name="submit1" value="匯出成Excel" onClick='setSubmit("../jsp/TSCMfgWIPOverviewExcelReport.jsp")'></td>
	</tr>
</table>
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
