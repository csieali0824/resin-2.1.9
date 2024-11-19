<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<html>
<head>
<title>WSPIT_ObjectInput.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
    <%	    	   
		  Statement statement=con.createStatement();
          ResultSet rs=null;
          String newID="001";
try  //取得最新之編號
{     	         
   rs=statement.executeQuery("select OBJECTID from PIT_OBJECT order by OBJECTID desc");	   
   if (rs.next())
   {
	 newID=String.valueOf(Integer.parseInt(rs.getString("OBJECTID"))+1);
	 newID="00"+newID;
	 newID=newID.substring(newID.length()-3);
   }   
   rs.close();       
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
    %>
<FORM ACTION="../jsp/WSPIT_ObjectInsert.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>物件定義新增</strong></font> 
  
  <table width="97%" height="114" border="1">
    <tr> 
      <td width="13%" height="30">OBJECTID: 
        <%=newID%><input name="OBJECTID" type="hidden" size="5" maxlength="3" value="<%=newID%>"></td>
       <td width="39%">NAME: 
        <input name="NAME" type="text" size="30" maxlength="30"></td>
	    </tr>
    <tr> 
      <td height="38" colspan="5">Description: 
        <input name="DESC" type="text" size="60" maxlength="60"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
  </FORM>
  
<A HREF="WSPIT_ObjectQueryAll.jsp">Query All Object</A> 
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
