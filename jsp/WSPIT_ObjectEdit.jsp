<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
String objectid=request.getParameter("objectid");
Statement statement=con.createStatement();
ResultSet rs=null;
String name="",desc="";
//取出所有資訊
try  
{     	         
   rs=statement.executeQuery("select * from PIT_OBJECT where objectid='"+objectid+"'");	   
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
<title>PIT OBJECT EDIT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="../jsp/WSPIT_ObjectUpdate.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>修改物件定義基本資訊</strong></font> 
  <table width="97%" height="114" border="1">
    <tr> 
      <td width="13%" height="30">OBJECTID: 
        <%=objectid%><input name="OBJECTID" type="HIDDEN"  value="<%=objectid%>"></td>
       <td width="39%">NAME: 
        <input name="NAME" type="text" size="30" maxlength="30" value="<%=name%>"></td>
	    </tr>
    <tr> 
      <td height="38" colspan="5">Description: 
        <input name="DESC" type="text" size="60" maxlength="60" value="<%=desc%>"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
</FORM>
  <A HREF="WSPIT_ObjectQueryAll.jsp">物件定義 清單</A> 
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->