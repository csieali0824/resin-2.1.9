<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>DelProgrammer</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;
//String MODEL="";
//String ROLENAME="";

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
  
     /*Statement statementu=con.createStatement();
     ResultSet rsu=statementu.executeQuery("select MODEL,ROLENAME from RPPROGRAMMER where ADDRESS in ("+choiceString+")");
	 if(rsu.next())
	 {
	   MODEL=rsu.getString("MODEL");
	   ROLENAME=rsu.getString("ROLENAME");
	   //RECPERSONNO=rsu.getString("RECPERSONNO");
	   //out.print(ADDRESS);
	 }
	 statementu.close();
	 rsu.close();*/
  
  
  String sql="delete from WSPROGRAMMER where ADDRESSDESC in ("+choiceString+") ";   
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();           
  
  out.println("Delete ADDRESS:("+choiceString+") OK!<BR>");
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammer.jsp">查詢所有角色紀錄</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
