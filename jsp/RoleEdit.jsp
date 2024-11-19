<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>RolrEdit.jsp</title>
</head>

<body>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>

<%
  String ROLENAME=request.getParameter("ROLENAME");
  String ROLEDESC="";


  try
    {
	Statement statement=con.createStatement();
	ResultSet rscheck=statement.executeQuery("select COUNT (*) from WsRole where ROLENAME='"+ROLENAME+"'");
	rscheck.next();
	if(rscheck.getInt(1)==0)
	{
	  response.sendRedirect("../jsp/RoleEdit1a.jsp");
	} 
	rscheck.close();
	
	String sql="select * from WsRole where ROLENAME='"+ROLENAME+"'";	
	ResultSet rs=statement.executeQuery(sql);
	rs.next();
	ROLENAME=rs.getString("ROLENAME");
    ROLEDESC=rs.getString("ROLEDESC"); 
	//out.println("<b>ROLEDESC"+ROLEDESC+":</b><br>");
	statement.close(); 
    rs.close();		
   }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>

<form action="/wins/jsp/RoleUpdata.jsp" method="post" name="signform" onsubmit="return validate()">
  <table border="1" align="center" bordercolor="#6699CC">
    <tr>
      <td width="612" height="74" background="../image/back5.gif"> 
        <p><a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp; <A HREF="../jsp/RoleShow.jsp">查詢所有角色記錄</A></p>
        <p><strong><font color="#FF0000">角色維護</font></strong></p></td>
    </tr>
    <tr>
      <td bgcolor="#DEF5FE">角色名稱: <%= ROLENAME %> <br>
        <input type="hidden" name="ROLENAME" value="<%= ROLENAME %>">
        角色說明:
        <input type="text" name="ROLEDESC" value="<%= ROLEDESC %>" size="30" maxlength="40">
      </td>
    </tr>
    <tr>
      <td><input type="submit" name="submit" value="修改"> <input type="reset" name="reset" value="清除"></td>
    </tr>
  </table>
  <br>
  <br>
</form>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>



  <script language="JavaScript"> 

   function validate(){
     if (document.signform.ROLEDESC.value == "") {
	      alert("請輸入角色說明!");
		  return (false);
	  }else {
	      document.signform.submit();
	  }
   }

    </script>