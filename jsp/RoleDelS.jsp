<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>RoleDel</title>
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
        Statement stmtexist=con.createStatement();
	    String sSql="select ROLENAME from WSROLEGROUP where GROUPNAME in ("+choiceString+")"; 
	    //out.println(sSql); 
       ResultSet rsexist=stmtexist.executeQuery(sSql);
	   while (rsexist.next())
       {  String sql5="delete from WSGROUPUSERROLE where ROLENAME ='"+rsexist.getString("ROLENAME")+"'";   
           PreparedStatement pstmt5=con.prepareStatement(sql5);      
           pstmt5.executeUpdate();       
		}    
  String sql="delete from WSROLE where ROLENAME in ("+choiceString+")";   
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();           
  
  out.println("Delete ROLENAME:("+choiceString+") OK!<BR>");
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
 <br><a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp; <A HREF="../jsp/RoleShow.jsp">查詢所有角色記錄</A></p>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
