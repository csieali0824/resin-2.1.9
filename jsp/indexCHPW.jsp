<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.sql.*" %>
<%@ page import="java.sql.*,DateBean" %>
<%@ page pageEncoding="utf-8" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="SalesDRQPageHeaderBean" %-->

<html>
<head>
<title>Main</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<script>
function setSubmit(URL)
{
	var str_err="";
	if (document.MAINFORM.OPWD.value=="")
	{
		str_err = str_err+"Please enter a value on Current Password field\n"; 
	}
	if (document.MAINFORM.NPWD.value=="")
	{
		str_err = str_err+"Please enter a value on New Password field\n"; 
	}
	if (document.MAINFORM.RNPWD.value=="")
	{
		str_err = str_err+"Please enter a value on Re-enter New Password field\n"; 
	}
	if (str_err!="")
	{
		alert(str_err);
		return false;
	}
	else
	{
		if (document.MAINFORM.OPWD.value!=document.MAINFORM.PWD.value)
		{
			str_err = str_err+"The current password is incorrect\n"; 
		}
		if (document.MAINFORM.NPWD.value!=document.MAINFORM.RNPWD.value)
		{
			str_err = str_err+"The New Password verification failed\n";
		}
		if (document.MAINFORM.OPWD.value==document.MAINFORM.NPWD.value)
		{
			str_err = str_err+"Your new password must be different from your old password\n";
		}
		if (document.MAINFORM.NPWD.value.length<6)
		{
			str_err = str_err+"Passwords must be at least 6 characters long\n";
		}
	}
	if (str_err!="")
	{
		alert(str_err);
		return false;
	}
	else
	{
		document.MAINFORM.action=URL+"?ID="+Math.random();
		document.MAINFORM.submit();	
	}		
}
function setSubmit1(URL)
{
	document.MAINFORM.action=URL;
	document.MAINFORM.submit();	
}
</script>
<body style="background-color:#E3EBFF">
<FORM name="MAINFORM" action="../jsp/login.jsp" method="post">
<%
String UserName="",PWD="",UserName1="";
try
{
	UserName=session.getAttribute("UNME").toString();
}
catch(Exception e)
{
	UserName="";
}
try
{
	UserName1=session.getAttribute("UNME1").toString();
}
catch(Exception e)
{
	UserName1="";
}
try
{
	PWD=session.getAttribute("UPWD").toString();
}
catch(Exception e)
{
	PWD="";
}	
String langCh=request.getParameter("LANGCH");
if (langCh==null) langCh="";
String NPWD=request.getParameter("NPWD");
if (NPWD==null) NPWD="";
String ID=request.getParameter("ID");
if (ID==null) ID="";
if ((ID==null || ID.equals("")) && UserName1!=null && !UserName1.equals(""))
{
	String sql = " select password from oraddman.wsuser a"+
	      " where upper(USERNAME)=upper(?)";
	PreparedStatement pstmtDt=con.prepareStatement(sql);  
	pstmtDt.setString(1,UserName1);
	ResultSet rs=pstmtDt.executeQuery();	
	if (rs.next())
	{
		PWD=rs.getString(1);
	}
	rs.close();
	pstmtDt.close();
}
%>
<input type="hidden" name="UserName" value="<%=UserName%>">
<input type="hidden" name="UserName1" value="<%=UserName1%>">
<input type="hidden" name="PWD" value="<%=PWD%>">
<input type="hidden" name="Password" value="<%=NPWD%>">
<input name="LANGCH" type="HIDDEN" value="<%=langCh%>" >
<%
if (ID!=null && !ID.equals(""))
{
	String sql = " update oraddman.wsuser a"+
	      " set PASSWORD=?"+
		  ",PASSWORD_UPDATE_DATE=sysdate"+
		  ",LAST_UPDATE_DATE=sysdate"+
		  " where upper(USERNAME)=upper(?)";
	PreparedStatement pstmtDt=con.prepareStatement(sql);  
	pstmtDt.setString(1,NPWD);
	if (UserName1!=null && !UserName1.equals(""))
	{
		pstmtDt.setString(2,UserName1);	
	}
	else
	{
		pstmtDt.setString(2,UserName);
	}
	pstmtDt.executeQuery();
	pstmtDt.close();
	con.commit();	
	
	if (UserName1!=null && !UserName1.equals(""))
	{
	%>
	<script>
		alert("Modify successfully!Please re-login the RFQ system..");
		document.MAINFORM.action="Logout.jsp";
		document.MAINFORM.submit();	
	</script>	
	<%	
	}
	else
	{
	%>
	<script>
		document.MAINFORM.submit();	
	</script>	
	<%
	}
}
%>
<table width="100%">
<!-- 上半部 -->
<tr>
	<td width="25%" height="70" background="image/top-bd.jpg"><img src="../image/logo.JPG" height="54"></td>
	<td colspan="2" width="30%" style="font-size:32px;text-align:center;font-family:Tahoma,Georgia">RFQ System</td>
	<td width="45%">&nbsp;</td>
<tr>
<tr><td colspan="4"><hr></td></tr>
<tr>
	<td>&nbsp;</td>
	<td colspan="2" style="text-align:center;color:#FFFFFF;background-color:#0066CC;font-size:12px;font-family:Tahoma,Georgia" >Change Password</td>
	<td>&nbsp;</td>	
</tr>
<tr>
	<td width="25%">&nbsp;</td>
	<td style="font-size:12px;text-align:right;font-family:Tahoma,Georgia">*Current Password:</td><td><input type="password" name="OPWD" value="" tabindex="1"></td>
	<td width="45%">&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td style="font-size:12px;text-align:right;font-family:Tahoma,Georgia">*New Password:</td><td><input type="password" name="NPWD" value="" tabindex="2"></td>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>&nbsp;</td>
	<td style="vertical-align:top;font-size:12px;text-align:right;font-family:Tahoma,Georgia">*Re-enter New Password:</td><td><input type="password" name="RNPWD" value="" tabindex="3">
	<br><font style="font-size:12px;text-align:left;font-family:Tahoma,Georgia">Password must be at least 6 characters long.</font></td>
	<td>&nbsp;</td>
</tr>
<tr><td colspan="4"><hr></td></tr>
<tr>
<td>&nbsp;</td>
<td colspan="2" align="center"><input type="button" name="Submit1" value="Submit" style="font-size:12px;font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/indexCHPW.jsp')" tabindex="4">&nbsp;&nbsp;&nbsp;<input type="button" name="Cancel1" value="Cancel" style="font-size:12px;font-family:Tahoma,Georgia"  onClick="setSubmit1('<%=(UserName1!=null && !UserName1.equals("")?"/oradds/ORADDSMainMenu.jsp":"../jsp/index.jsp")%>')"></td>
<td>&nbsp;</td>
</tr>
</table>
</form>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>