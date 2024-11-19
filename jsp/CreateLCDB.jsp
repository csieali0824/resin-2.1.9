<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>CreateLCDB.jsp</title>
</head>

<body>
<%
  String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
  String LCNO=request.getParameter("LCNO");
  String LCAMT=request.getParameter("LCAMT");
  String LCCUR=request.getParameter("LCCUR");
  String LCEFF=request.getParameter("LCEFF");
  String LCDIS=request.getParameter("LCDIS");
  String LCENDT=request.getParameter("LCENDT");
  String LCENTM=request.getParameter("LCENTM");
  String LCID=request.getParameter("LCID");
  String LCUSGE=request.getParameter("LCUSGE");
  String LCSTAT=request.getParameter("LCSTAT");
  String firstdate=request.getParameter("firstdate");
  String seconddate=request.getParameter("seconddate");
  //String userID=(String)session.getAttribute("WEBID"); 
  /*out.print(userID+"<br>");
  out.print(LCNO+"<br>");
  out.print(LCAMT+"<br>");
  out.print(LCCUR+"<br>");
  out.print(LCEFF+"<br>");
  out.print(LCDIS+"<br>");
  out.print(LCENDT+"<br>");
  out.print(LCENTM+"<br>");
  out.print(LCID+"<br>");
  out.print(LCUSGE+"<br>");
  out.print(LCSTAT+"<br>");
  out.print(firstdate+"<br>");
  out.print(seconddate+"<br>");*/
  
  try
  {
	 String sql="insert into HLCM(LCID,LCNO,LCCUR,LCAMT,LCEFF,LCDIS,LCUSAGE,LCENUS,LCCFM,LCENDT,LCENTM,LCRDTE,LCRCTM,LCUPDT,LCUPTM,LCSTAT) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
	 PreparedStatement pstmt=ifxshoescon.prepareStatement(sql);
	 pstmt.setString(1,LCID);
	 pstmt.setString(2,LCNO);
	 pstmt.setString(3,LCCUR);
	 pstmt.setString(4,LCAMT);
	 pstmt.setString(5,firstdate);
	 pstmt.setString(6,seconddate);
	 pstmt.setString(7,LCUSGE);
	 pstmt.setString(8,"");
	 pstmt.setString(9,userID);
	 pstmt.setString(10,LCENDT);
	 pstmt.setString(11,LCENTM);
	 pstmt.setString(12,"0");
	 pstmt.setString(13,"0");
	 pstmt.setString(14,"0");
	 pstmt.setString(15,"0");
	 pstmt.setString(16,LCSTAT);
	 pstmt.executeUpdate(); 
	 pstmt.close();
	 
	 } 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
  
%>  
 <br><%= LCNO %> 加入記錄完成!<br>
 <a href="../WinsMainMenu.jsp">回首頁</a>
 <br><a href="../jsp/CreateLC2.jsp">上一頁</a>
  <%
    //執行sendMail動作
    if (sendMailOption!=null && sendMailOption.equals("YES"))
   { 
     out.println("<img src='../jsp/CreateNewsSendMail.jsp?LCCFM="+userID+"'&LCNO="+LCNO+" height='0' width='0'>&nbsp;&nbsp;");	
   } //end of send Mail if 
 %>  

</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
