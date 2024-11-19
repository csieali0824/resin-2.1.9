<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
Statement statement=con.createStatement();
ResultSet rs=null;
String newID="001";
try  //取得最新之編號
{     	         
   rs=statement.executeQuery("select SOURCEID from PIT_SOURCE order by SOURCEID desc");	   
   if (rs.next())
   {
	 newID=String.valueOf(Integer.parseInt(rs.getString("SOURCEID"))+1);
	 newID="000"+newID;
	 newID=newID.substring(newID.length()-3);
   }   
   rs.close();       
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
<html>
<head>
<title>PIT SOURCE INPUT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="../jsp/WSPIT_SourceInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>測試來源基本資訊</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">NAME:<INPUT TYPE="text" NAME="NAME" size="20"></td>
      <td width="55%">ID:<INPUT TYPE="text" NAME="ID" size="3" MAXLENGTH=3 value='<%=newID%>'></td>
    </tr>
    <tr> 
      <td colspan="2">Description: 
        <INPUT TYPE="text" NAME="DESC" size="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
</FORM>
  <A HREF="WSPIT_SourceQueryAll.jsp">測試來源 清單</A> 
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->