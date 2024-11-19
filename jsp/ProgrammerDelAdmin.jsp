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
String choiceString="";
String ADDRESS=null;
//String ROLENAME="";

try
{  
  for (int k=0;k<choice.length ; k++)
  {   
	if (k>0) 
      {	 choiceString+= ","; }
	     choiceString+= choice[k];   
   } //end of for
 // out.println(choiceString);
  
     /*Statement statementu=con.createStatement();
	 String sSql="select ADDRESS from wsProgrammer where ADDRESS in ("+choiceString+")"; 
	 //out.println(sSql); 
     ResultSet rsu=statementu.executeQuery(sSql);
	 while(rsu.next())
	 {
	   
	  {ADDRESS=ADDRESS+",'"+rsu.getString("ADDRESS")+"' " ;} 	   
	   
	   
	 }
	 //out.println(ADDRESS); 
	 statementu.close();
	 rsu.close();*/
  
  
  String sql="delete from WSPROGRAMMER where ADDRESS in ('"+choiceString+"') ";   
  //out.println(sql); 
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();           
  
  //out.println("Delete ADDRESS:("+ADDRESS+") OK!<BR>");
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
  <%=choiceString%>, 資料刪除成功!<br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> &nbsp;&nbsp;<A HREF="../jsp/ShowProgrammerAdmin.jsp">查詢程式檔案資訊</A><br>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
