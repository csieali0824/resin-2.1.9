<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>

<%
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {
    searchString="";
   }
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>saleInfoSubWindow</title>
</head>

<body>
<FORM METHOD="post" ACTION="SaleInfoSubWindowDb.jsp">
  <p><font color="#54A7A7" size="+2" face="Arial Black"><strong>安捷立 </strong></font><font color="#0080FF" size="+2"><strong>依業務員查詢所屬客戶資訊</strong></font></p>
  <font color="#0080FF"><strong><a href="../WinsMainMenu.jsp">HOME</a></strong></font> 
  <table width="43%" border="1">
    <tr>
      <td width="80%"><font color="#0080FF" ><strong>業務員代號</strong></font><font >: 
        <input type="text" name="SEARCHSTRING" size="20" maxlength="8" value=<%=searchString%> >
        </font></td>
      <td width="20%"><input type="submit" name="submit" value="查詢"></td>
    </tr>
  </table>
  <BR>
  </FORM>

	   
</body>

</html>
