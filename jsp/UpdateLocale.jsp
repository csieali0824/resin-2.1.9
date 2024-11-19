<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>UpdataLocale.jsp</title>
</head>

<body> 
<%
  String[] LOCALE=request.getParameterValues("LOCALE");
  String[] LOCALE_NAME=request.getParameterValues("LOCALE_NAME");
  String[] LOCALE_ENG_NAME=request.getParameterValues("LOCALE_ENG_NAME");
  String[] LOCALE_SHT_NAME=request.getParameterValues("LOCALE_SHT_NAME");
  String CONTINENT=request.getParameter("CONTINENT");
  String CONTINENT_NAME=request.getParameter("CONTINENT_NAME");
  //out.println("<b>LOCALE"+LOCALE+":</b><br>");
  //out.println("<b>LOCALE_NAME"+LOCALE_NAME+":</b><br>");
  //out.println("<b>LOCALE_ENG_NAME"+LOCALE_ENG_NAME+":</b><br>");
  //out.println("<b>LOCALE_SHT_NAME"+LOCALE_SHT_NAME+":</b><br>");
  //out.println("<b>CONTINENT"+CONTINENT+":</b><br>");
  //out.println("<b>CONTINENT_NAME"+CONTINENT_NAME+":</b><br>");
  
try
   {
       Statement statement=con.createStatement();


   out.println("<ul>");
	 if(CONTINENT != null)
	 {	  		  
		  String sql="delete from WsContinent where CONTINENT='"+CONTINENT+"'";
		  //刪除
		  String sqlq="delete from Wslocale where CONTINENTID='"+CONTINENT+"'";
		  //刪除
		 
		  out.println(CONTINENT);
		  out.println("陸地刪除完成<br>");
          statement.executeUpdate(sql);
		  statement.executeUpdate(sqlq);
		  statement.close();
	   }
	 else
	 {
	  out.println("請輸入陸地資料");
	  out.println("</ul><br>");
	 }  
	 
	 ////////////////////////////////////////////////////////////////
	 
	 String sqlq="insert into WsContinent(CONTINENT,CONTINENT_NAME) values(?,?)";
	 //新增

	 PreparedStatement pstmtq=con.prepareStatement(sqlq);	 	 
	 pstmtq.setString(1,CONTINENT);
	 pstmtq.setString(2,CONTINENT_NAME);
	 pstmtq.executeUpdate(); 
	 pstmtq.close();
	 
	 
	 
	 String sql="insert into WSLOCALE(LOCALE,LOCALE_NAME,LOCALE_ENG_NAME,CONTINENTID) values(?,?,?,?)";
	 //新增	 	 
	 
	 
  	 out.println("<ul>");
	 if(LOCALE != null)
	 {
	   for(int i=0; i<LOCALE.length ; i++)
	    {
		  PreparedStatement pstmt=con.prepareStatement(sql);
		  out.println("LOCALE :"+LOCALE[i]+"<br>");
		  out.println("LOCALE_NAME :"+LOCALE_NAME[i]+"<br>");
		  out.println("LOCALE_ENG_NAME :"+LOCALE_ENG_NAME[i]+"<br>");
		  out.println("CONTINENT :"+CONTINENT+"<br>");
		  pstmt.setString(1,LOCALE[i]);
	      pstmt.setString(2,LOCALE_NAME[i]);
          pstmt.setString(3,LOCALE_ENG_NAME[i]);
	      pstmt.setString(4,CONTINENT);
		  pstmt.executeUpdate();
		  pstmt.close();
		}
	 }
	 else
	 {
	   out.println("請輸入資料");
	 out.println("</ul><br>");
	 }
	 
	 
	 
     
   }//try of end
    catch (Exception e)
  {
    out.println("Exception:"+e.getMessage());
  }
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

<a href="../jsp/EditEmployee1.jsp">回修改頁</a><br>
</body>
</html>
