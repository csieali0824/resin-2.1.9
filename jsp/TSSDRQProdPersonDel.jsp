<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Product Factory PC Person Data Delete</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;

try
{  
  for (int k=0;k<choice.length ;k++)
  {
   if (choiceString==null) 
   {
     choiceString="'"+choice[k]+"'";	 
   } else {	 
    choiceString=choiceString+",'"+choice[k]+"'";    
   }
  } //end of for
  //out.println(choiceString);
  String sql="delete from ORADDMAN.TSPROD_PERSON where USERID in ("+choiceString+")";   
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();           
  
  out.println("Delete Product Factory PC PERSON and ID:"+choiceString+") OK!<BR>");
  out.println("<A HREF=/oradds/jsp/TSSDRQProdPersonQueryAll.jsp>");
  %> 
  <jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgAllRecords"/>
  <%
  out.println("</A>");
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

