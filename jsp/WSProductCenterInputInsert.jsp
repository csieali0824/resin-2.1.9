<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Sales Forecast Cost Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="";  
   if (a!=null) 
   {      
     for (int ac=0;ac<a.length;ac++)
     { 	 	
           sql="insert into PSALES_PROD_CENTER(INTER_MODEL,EXT_MODEL,PROD_DESC,BRAND,PLATFORM,DESIGNHOUSE,LAUNCH_DATE,CREATE_DATE,CREATE_USER) values(?,?,?,?,?,?,?,?,?)";           
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,a[ac][0]);
           pstmt.setString(2,a[ac][1]);  
           pstmt.setString(3,a[ac][2]);
           pstmt.setString(4,a[ac][3]);
           pstmt.setString(5,a[ac][4]);       
		   pstmt.setString(6,a[ac][5]);
		   pstmt.setString(7,a[ac][6]);      
           pstmt.setString(8,dateBean.getYearMonthDay());
           pstmt.setString(9,userID); //L
     
           pstmt.executeUpdate();
		   pstmt.close();
		//} //end of sub for   
	} //enf of for	
  } //end of array if null
  
  out.println("Input Product Data Successfully!!<BR>");
  out.println("<A HREF=../jsp/WSForecastMenu.jsp>Back to submenu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");  
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(array2DimensionInputBean.getResultString());		
	 array2DimensionInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作    		   	 
   }	//enf of a!=null if       
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
