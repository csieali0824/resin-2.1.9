<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,SendMailBean,CodeUtil" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<html>
<head>
<title>Material Request Comfirmation Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String targetYear=request.getParameter("TARGETYEAR");
String targetMonth=request.getParameter("TARGETMONTH"); 
String docNo=request.getParameter("DOCNO");
String remark=request.getParameter("REMARK");
String [] choice=request.getParameterValues("CH");
String dateString=null;

Statement statement=con.createStatement();
ResultSet rs=null;
try
{  
  dateString=dateBean.getYearMonthDay();   
  
  //*********取得下一個流程資訊**********************************
  String isEnded="N";  
  String nextPrcsMan="";
  rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='MRC' and ORDERS=1 and TYPE='001'");
  if (rs.next())
  {
    isEnded=rs.getString("ISEND");  
    nextPrcsMan=rs.getString("PRCSMAN");  
  }    
  rs.close();  
  //************END OF 取得下一個流程資訊**************************  
 
  //*********取得下一個處理人資料**********************************
  String nextPrcsManName="";  
  String nextPrcsManMail="";
  rs=statement.executeQuery("select * from WSUSER where WEBID='"+nextPrcsMan+"'");
  if (rs.next())
  {
    nextPrcsManName=rs.getString("USERNAME");  
    nextPrcsManMail=rs.getString("USERMAIL");  
  }    
  rs.close();
  statement.close();
  //************END OF 取得下一個流程資訊**************************  

  String sql="insert into PSALES_FORE_MRC_HD(DOCNO,TARGETYEAR,TARGETMONTH,NEXTPRCSMAN,CREATEDBY,CREATEDDATE,CREATEDTIME,REMARK,STATUS,IS_COMPLETE) values(?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,docNo);  
  pstmt.setString(2,targetYear);
  pstmt.setString(3,targetMonth); 
  pstmt.setString(4,nextPrcsMan);
  pstmt.setString(5,userID);
  pstmt.setString(6,dateString);
  pstmt.setString(7,dateBean.getHourMinute());
  pstmt.setString(8,remark);
  pstmt.setString(9,"IN_PROGRESS");
  pstmt.setString(10,"N"); //complete ?  
  
  pstmt.executeUpdate();
  pstmt.close();  
 
  for (int i=0;i<choice.length;i++)
  {      
   String element0=request.getParameter(choice[i]+"-MODEL");//取前一頁之隱藏欄位 inter Model   
   String element1=request.getParameter(choice[i]+"-COLOR");//取前一頁之隱藏欄位 color
   String element2=request.getParameter(choice[i]+"-RQQTY");//取前一頁之隱藏欄位 require qty
   String element3=request.getParameter("DUEDATE-"+choice[i]);//取前一頁之輸入欄位 due date  
   String element4=request.getParameter("QTY-"+choice[i]);//取前一頁之輸入欄位物料需求數目 qty
   if (element4==null) element4="0";        
   
   sql="insert into PSALES_FORE_MRC_LN(DOCNO,LINENO,PRJCD,COLOR,ORIGIN_RDATE,ORIGIN_RQTY,R_TYPE,EP_DATE,EP_QTY,CREATEDBY,CREATEDDATE,CREATEDTIME) values(?,?,?,?,?,?,?,?,?,?,?,?)";
   pstmt=con.prepareStatement(sql);
   pstmt.setString(1,docNo);
   pstmt.setString(2,String.valueOf(i+1));
   pstmt.setString(3,element0); //PRJCD 
   pstmt.setString(4,element1); //COLOR
   pstmt.setString(5,targetYear+targetMonth+"01");
   pstmt.setString(6,element2); //ORIGIN_RQTY
   pstmt.setString(7,"I"); //R_TYPE I:ISSUE R:REPLY     
   pstmt.setString(8,element3);  //EP_DATE
   pstmt.setString(9,element4); //EP_QTY
   pstmt.setString(10,userID);  
   pstmt.setString(11,dateString);
   pstmt.setString(12,dateBean.getHourMinute());    
   
   pstmt.executeUpdate();	
   pstmt.close();   
  } //end of for
    
  //**********更新原PR之IS_MR_CREATED,令其為Y表示已產生過MR************************
  String seqSql="update PSALES_FORE_APP_HD SET IS_MR_CREATED=? WHERE DOCNO='"+docNo+"'";   
  PreparedStatement seqstmt=con.prepareStatement(seqSql);        
  seqstmt.setString(1,"Y"); 
    	
  seqstmt.executeUpdate();   
  seqstmt.close(); 		
  //****************************************************************************
  
  out.println("Material Request Confirmation submited and has been sent to "+nextPrcsManName+"!! (Doc No:"+docNo+")<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>");       
  
  //--------------send mail option---------------------------
  if (!nextPrcsManMail.equals(""))
  {
    sendMailBean.setMailHost(mailHost);	    
    String serverName=request.getServerName();
    sendMailBean.setReception(nextPrcsManMail);
    sendMailBean.setFrom("WINS");  		  		           		   
    sendMailBean.setSubject(CodeUtil.unicodeToBig5("Material Request Confirmation coming from "+UserName+" need to reply!!"));     
    sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSFore_MRC_Display.jsp?DOCNO="+docNo);		
	sendMailBean.setUrlName("Material Request Confirmation");	 
    sendMailBean.sendMail();
  }//enf of nextPrcsManMail if--------------------------------	
} //end of try
catch (Exception ee)
{
 %>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
 <%
 out.println(ee.getMessage());
}//end of catch
statement.close();
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
