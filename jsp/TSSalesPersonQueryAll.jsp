<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean" %>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Query All Sales Person</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = true;
		}
 		checkflag = "true";
 		return "取消選取"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "全部選取"; 
	}
}

function NeedConfirm()
{ 
	flag=confirm("是否確定刪除?"); 
 	return flag;
}
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
</script>
<%
	String USERNAME = request.getParameter("USERNAME");
	if (USERNAME == null) USERNAME="";
%>

<body><FORM NAME="MYFORM" ACTION="../jsp/TSSalesPersonDel.jsp" METHOD="POST" onSubmit="return NeedConfirm()"> 
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="<jsp:getProperty name="rPH" property="pgSelectAll"/>">
<INPUT TYPE="submit" value="<jsp:getProperty name="rPH" property="pgDelete"/>">
<input type="text" name="USERNAME" value=""><input type="button" name="search" value="查詢" onClick="setSubmit('../jsp/TSSalesPersonQueryAll.jsp')" >
&nbsp;&nbsp;<A HREF="../jsp/TSSalesPersonInput.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSalesMan"/></A>&nbsp;&nbsp;<A HREF="/Oradds/OraddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A> 

<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<%  
try
{
	String sql = "select ROW_NUMBER() OVER (order by TSSALEAREANO,RECPERSONNO) SEQNO ,USERID,TSSALEAREANO,RECPERSONNO,USERNAME,SALESPERSONID from ORADDMAN.TSRECPERSON";
	if (!USERNAME.equals("")) sql += " where upper(USERNAME) like '"+ USERNAME.toUpperCase()+"%'";
	sql += " order by TSSALEAREANO,RECPERSONNO";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
   	qryAllChkBoxEditBean.setPageURL("../jsp/TSSalesPersonEditPage.jsp");
   	//qryAllChkBoxEditBean.setSearchKey("USERID");
	qryAllChkBoxEditBean.setSearchKey("SEQNO");  //modify by Peggy 20121218
   	qryAllChkBoxEditBean.setFieldName("CH");
   	qryAllChkBoxEditBean.setRowColor1("B0E0E6");
   	qryAllChkBoxEditBean.setRowColor2("ADD8E6");
	int col [] = {2,3};
	qryAllChkBoxEditBean.setKeyColumn(col); //Add by by Peggy 20121218
   	qryAllChkBoxEditBean.setRs(rs);   
   	out.println(qryAllChkBoxEditBean.getRsString());
   
   	statement.close();
   	rs.close();   
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
 %>
</FORM>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

