<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String sourceID=request.getParameter("SOURCEID");
Statement statement=con.createStatement();
ResultSet rs=null;
String name="",desc="";
//取出原版本之所有資訊
try  
{     	         
   rs=statement.executeQuery("select * from PIT_SOURCE where SOURCEID='"+sourceID+"'");	   
   if (rs.next())
   {
	 name=rs.getString("NAME");
	 desc=rs.getString("DESCRIPTION");
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
<title>PIT SOURCE EDIT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="../jsp/WSPIT_SourceUpdate.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>測試來源基本資訊</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">NAME:<INPUT TYPE="text" NAME="NAME" size="20" value='<%=name%>'></td>
      <td width="55%">ID:<%=sourceID%><input name="ID" type="HIDDEN" value='<%=sourceID%>'></td>
    </tr>
    <tr> 
      <td colspan="2">Description: 
        <INPUT TYPE="text" NAME="DESC" size="60" value='<%=desc%>'></td>
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