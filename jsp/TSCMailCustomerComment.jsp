<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" %>
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
}
</STYLE>
<title>客戶滿意度調查回函意見</title>
</head> 
<FORM ACTION="../jsp/TSCMailCustomerComment.jsp" METHOD="post" NAME="MYFORM" >
<%
 String id=request.getParameter("id");
 String comments = null;

try
   {
    	Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery("select * from ORADDMAN.CUST_COLLECT_QUESTIONNAIRE WHERE ID='"+id+"' ");
       
   
          if(rs.next())
          {
           comments=rs.getString("COMMENTS");      
          } 
		  
		  if (comments==null) comments = "";
	 
	 
   }
   catch (Exception e)
   {
     out.println("Exception:"+e.getMessage());
   }

%>
  <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="30%" align="left" bordercolorlight="#ffffff" border="1">
     <tr>
	    <td width="13%" colspan="1" nowrap>
		   <textarea name="COMMENTS" cols="80" rows="15" ><%=comments%></textarea>
		</td>
     </tr>
  </table>
  <BR> 
</form>
</body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

