<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="CheckBoxBean" %>
<!--=============for multi-language==========-->
<%@ include file="../jsp/include/PageHeaderSwitch.jsp" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title><jsp:getProperty name="rPH" property="pgAdd"/><jsp:getProperty name="rPH" property="pgSuccess"/></title>
</head>

<body> 

<%
String WEBID=request.getParameter("WEBID");
String USERNAME=request.getParameter("USERNAME");
String USERMAIL=request.getParameter("USERMAIL");
String USERPROFILE=request.getParameter("USERPROFILE");
String PASSWORD=request.getParameter("PASSWORD");
String[] ROLENAME=request.getParameterValues("ROLENAME");
String ERPUSERID=request.getParameter("ERPUSERID");     //add by Peggy 20121217
String isExist = "N";
try 
{
	//檢查帳號是否重覆,add by Peggy 20110727
	Statement datacnt=con.createStatement(); 
	ResultSet rscnt=datacnt.executeQuery("select 1 from ORADDMAN.wsUser where USERNAME ='"+USERNAME+"' ");
	if (rscnt.next()) 
	{
		isExist = "Y";
	}
	rscnt.close();
	datacnt.close();	

	if (isExist.equals("N"))
	{
		String sql ="insert into ORADDMAN.wsUser(WEBID,USERNAME,USERMAIL,USERPROFILE,PASSWORD,ERP_USER_ID) "
	 	+" values('"+WEBID+"','"+USERNAME+"','"+USERMAIL+"','"+USERPROFILE+"','"+PASSWORD+"','"+ ERPUSERID +"')";
		PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.executeUpdate();
		pstmt.close();
	 
		if(ROLENAME != null) 
		{
			PreparedStatement pstmt1=con.prepareStatement("insert into ORADDMAN.wsgroupuserrole(GROUPUSERNAME,ROLENAME) values(?,?)");
			for(int i=0; i<ROLENAME.length ; i++) 
			{
				pstmt1.setString(1,USERNAME);
				pstmt1.setString(2,ROLENAME[i]);
				pstmt1.executeUpdate();
			} //end for
		 	pstmt1.close();
	 	} //end if
	}
}  
catch (Exception ee) 
{ 
	out.println("Exception:"+ee.getMessage()
);
%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
} // end try-catch
%>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
&nbsp;&nbsp;
<a href="MMAccountNew.jsp"><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgAccount"/></a>
&nbsp;&nbsp;
<a href="MMAccountList.jsp"><jsp:getProperty name="rPH" property="pgAccount"/><jsp:getProperty name="rPH" property="pgList"/></a>
<br><br>
<% 
if (isExist.equals("N"))
{	
%>
	<font><jsp:getProperty name="rPH" property="pgNew"/><jsp:getProperty name="rPH" property="pgSuccess"/></font>
<%
}
else
{
	out.println("<font color='red'><strong>新增失敗！帳號 "+USERNAME+" 已存在系統，請使用修改功能進行資料異動，謝謝!</strong></font>");
}
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->