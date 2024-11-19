<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,ArrayStoreBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayStoreBean" scope="session" class="ArrayStoreBean"/>
<html>
<head>
<title>Material Request Comfirmation Receive Data Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String docNo=request.getParameter("DOCNO");
String [][] choice=arrayStoreBean.getArray2DStore();
String action=request.getParameter("ACTION");

Statement statement=con.createStatement();
ResultSet rs=null;

String sql="";
PreparedStatement pstmt=null;
try
{             
  for (int i=0;i<choice.length;i++)
  {      
   String element0=request.getParameter(choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]+"-RECQTY");//取前一頁之輸入欄位RECQTY  
   if (element0==null) element0="0";  
   String element1=request.getParameter("RECDATE-"+choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]);//取前一頁之輸入欄位RECDATE 
   if (element1==null) element1=""; 
   String element2=request.getParameter(choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]+"-COMMENT");//取前一頁之輸入欄位COMMENT  
   if (element2==null) element2="";    
   
   sql="update PSALES_FORE_MRC_LN set ACT_QTY=?,ACT_DATE=?,COMMENTS=? where DOCNO='"+docNo+"' and R_TYPE='R' and PRJCD='"+choice[i][0]+"' and COLOR='"+choice[i][1]+"' and LINENO='"+choice[i][2]+"'";
   pstmt=con.prepareStatement(sql);  
   pstmt.setString(1,element0);
   pstmt.setString(2,element1); 
   pstmt.setString(3,element2); 
     
   pstmt.executeUpdate();
   pstmt.close();                
  } //end of for =>choice.length  
  
   //******************SAVE THE ACTION INFORMATION**********************************************
   sql="insert into PSALES_FORE_MRC_HIST(DOCNO,WHO,ACTION,ACT_DATE,ACT_TIME) values(?,?,?,?,?)";
   pstmt=con.prepareStatement(sql);
   pstmt.setString(1,docNo);
   pstmt.setString(2,userID);  
   pstmt.setString(3,action);
   pstmt.setString(4,dateBean.getYearMonthDay());
   pstmt.setString(5,dateBean.getHourMinute());    
   
   pstmt.executeUpdate();	
   pstmt.close();   
  //****************************************************************************
  
  out.println("Material Request Confirmation and has been save successfully!!(Doc No:"+docNo+")<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>");          
} //end of try
catch (Exception ee)
{
 %>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
 <%
 out.println(ee.getMessage());
}//end of catch
arrayStoreBean.setArray2DStore(null); //離開前則清空Array Bean中之資料
statement.close();
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
