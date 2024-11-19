<%@ page contentType="text/html;charset=Big5" import="java.util.*,java.sql.*"%> 
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String userId = "";
String encryptPassword = "";
String decryptPassword = "";
String userName = "";
String Sql = "";

userName = request.getParameter("name");

Sql ="select * from fnd_user where USER_NAME like upper('"+userName+"')";
//out.println
PreparedStatement  stmt=con.prepareStatement(Sql);
ResultSet rs = stmt.executeQuery(Sql);

while (rs.next())
{
  userId = rs.getString("USER_NAME");
  encryptPassword = rs.getString("ENCRYPTED_USER_PASSWORD");
  //out.println("encryptPassword"+encryptPassword);
}
 
oracle.apps.fnd.security.AolSecurity aolsec=new oracle.apps.fnd.security.AolSecurity();
decryptPassword = aolsec.decrypt("APPS",encryptPassword);

out.println("decryptPassword:"+decryptPassword);
 
%>
  <FORM NAME="Logon0" ACTION="http://prod.ts.com.tw:8000/OA_HTML/AppsLocalLogin.jsp?langCode=US" METHOD="POST" TARGET="_blank"> 
  <INPUT TYPE="hidden" NAME="USERNAME" VALUE="<%=userId%>">
  <INPUT TYPE="hidden" NAME="PASSWORD" VALUE="<%=decryptPassword%>">
  <INPUT TYPE="hidden" NAME="rmode" VALUE="2">
  <INPUT TYPE="hidden" NAME="home_url" VALUE="">
</FORM>
<!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

