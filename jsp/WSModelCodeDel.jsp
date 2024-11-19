<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title></title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
String APPNO=request.getParameter("APPNO");
String WEBID=request.getParameter("APPLY_USER");
String RD_CODE=request.getParameter("RD_CODE");
String PCLS_CODE=request.getParameter("PCLS_CODE");
String APPEAR_CODE=request.getParameter("APPEAR_CODE");
String PLATFORM_CODE=request.getParameter("PLATFORM_CODE");
String PRODEXT_CODE=request.getParameter("PRODEXT_CODE");
String FTURE_CODE=request.getParameter("FTURE_CODE");
String FTURE_CODE2=request.getParameter("FTURE_CODE2");
String SALESCODE=null;
String BUYER=request.getParameter("BUYER");
String REMARK=request.getParameter("REMARK");
String seqkey=null;
String dateString=null;
String timeString=null;
String ENUSER=request.getParameter("ENUSER");
String ENDTIME=request.getParameter("ENDTIME");
String recPersonID=userID;
String remark=request.getParameter("REMARK");
String MODELNO=request.getParameter("MODELNO");
String RDDPT=request.getParameter("RDDPT");
String PROD_CLASS=request.getParameter("PROD_CLASS");
String pjtfYEAR=request.getParameter("PJTFYEAR");
String pjtfMONTH=request.getParameter("PJTFMONTH");
String pjtfDay=request.getParameter("PJTFDAY");
String pjtfDate=pjtfYEAR+pjtfMONTH+pjtfDay;
String pjtnDate=request.getParameter("pjtnDate");
String recDate=request.getParameter("APPLY_DATE");
String MVERSION=null;


try
{  
  dateString=dateBean.getYearMonthDay();
  timeString=dateBean.getHourMinuteSecond();
  MVERSION=dateString+dateBean.getHourMinuteSecond();

  //=============================================================================      
  
  String sqlw="update MRMODELAPP set pid=?,PJTTNOFF_DATE=?,REMARK=?,ENUSER=?,MVERSION=? WHERE MODELNO=? ";

  PreparedStatement pstmt=con.prepareStatement(sqlw);  
  pstmt.setString(1,"MZ");
  pstmt.setString(2,pjtfDate);
  pstmt.setString(3,REMARK);
  pstmt.setString(4,userID);
//  pstmt.setString(5,dateString+timeString);
  pstmt.setString(5,MVERSION);
  pstmt.setString(6,MODELNO);
  pstmt.executeUpdate(); 

  //===INSERT INTO HISTORY==========================================================      
  String sqlh="insert into MRMODEL_HIST values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  pstmt=con.prepareStatement(sqlh);  
  pstmt.setString(1,"MZ");
  pstmt.setString(2,APPNO);
  pstmt.setString(3,MODELNO);
  pstmt.setString(4,"");
  pstmt.setString(5,BUYER);
  pstmt.setString(6,"");
  pstmt.setString(7,"");
  pstmt.setString(8,pjtnDate);
  pstmt.setString(9,pjtfDate);
  pstmt.setString(10,RDDPT);
  pstmt.setString(11,PROD_CLASS);  
  pstmt.setString(12,REMARK);
  pstmt.setString(13,WEBID);
  pstmt.setString(14,recDate);
  pstmt.setString(15,dateString);
  pstmt.setString(16,timeString);
  pstmt.setString(17,userID);
  pstmt.setString(18,ENUSER);
  pstmt.setString(19,ENDTIME);
  pstmt.setString(20,MVERSION);
  pstmt.executeUpdate(); 

// 2005-05-17 -- -------- for 註銷
  String sqlp="delete from PIMASTER where PROJECTCODE=? ";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.executeUpdate(); 

  sqlp="delete from PIMMAGE where PROJECTCODE=? ";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.executeUpdate(); 

  sqlp="delete from PIPRODCOMM where PROJECTCODE=? ";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.executeUpdate(); 

  sqlp="delete from PIPRODFEATURES where PROJECTCODE=? ";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.executeUpdate(); 

  sqlp="delete from PIPRODRINGER where PROJECTCODE=? ";
  pstmt=con.prepareStatement(sqlp);  
  pstmt.setString(1,MODELNO);
  pstmt.executeUpdate(); 

// 2005-05-17 -- ---- for 註銷  END
    
    
  pstmt.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
session.setAttribute("DISPLAY"," 註銷 產品編碼 : ");
session.setAttribute("MODELNO",MODELNO);
response.sendRedirect("WSModelCodeInsShow.jsp");

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
