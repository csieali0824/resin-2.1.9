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
<title>Forecast Application Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String vYear=request.getParameter("VYEAR");
String vMonth=request.getParameter("VMONTH"); 
String targetYear=request.getParameter("TARGETYEAR");
String targetMonth=request.getParameter("TARGETMONTH"); 
String comp=request.getParameter("COMP");
String type=request.getParameter("TYPE");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");
String remark=request.getParameter("REMARK");
String [] choice=request.getParameterValues("CH");
String dateString=null;
String seqno=null,seqkey=null;

try
{  
  dateString=dateBean.getYearMonthDay();  
  //====先取得流水號=====  
  seqkey="AP"+dateString.substring(2);
  Statement statement=con.createStatement();
  ResultSet rs=statement.executeQuery("select * from DOCSEQ where header='"+seqkey+"'");
  
  if (rs.next()==false)
  {   
   String seqSql="insert into DOCSEQ values(?,?)";   
   PreparedStatement seqstmt=con.prepareStatement(seqSql);     
   seqstmt.setString(1,seqkey);
   seqstmt.setInt(2,1);   
	
   seqstmt.executeUpdate();
   seqno=seqkey+"-001";
   seqstmt.close();   
  } else {   
   int lastno=rs.getInt("LASTNO");
   lastno++;
   String numberString = Integer.toString(lastno);
   String lastSeqNumber="000"+numberString;
   lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
   seqno=seqkey+"-"+lastSeqNumber;     
   
   String seqSql="update DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
   PreparedStatement seqstmt=con.prepareStatement(seqSql);        
   seqstmt.setInt(1,lastno);   
	
   seqstmt.executeUpdate();   
   seqstmt.close(); 
  }
  rs.close(); 
  //============end of 取得流水號=================================   
  
  //*********取得下一個流程資訊**********************************
  String isEnded="N";  
  String nextPrcsMan="";
  rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='"+comp+"' and ORDERS=1 and TYPE='"+type+"'");
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


  String sql="insert into PSALES_FORE_APP_HD(DOCNO,BUSINESSUNIT,TYPE,REGION,COUNTRY,RQYEAR,RQMONTH,APPROVED,NEXTPRCSMAN,CREATEDBY,CREATEDDATE,CREATEDTIME,REMARK,STATUS,CANCEL,IS_MR_CREATED) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,seqno);
  pstmt.setString(2,comp);  
  pstmt.setString(3,type);
  pstmt.setString(4,region);
  pstmt.setString(5,country);
  pstmt.setString(6,targetYear);
  pstmt.setString(7,targetMonth);
  pstmt.setString(8,"N");
  pstmt.setString(9,nextPrcsMan);
  pstmt.setString(10,userID);
  pstmt.setString(11,dateString);
  pstmt.setString(12,dateBean.getHourMinute());
  pstmt.setString(13,remark);
  pstmt.setString(14,"IN_PROGRESS");
  pstmt.setString(15,"N"); //cancel ?
  pstmt.setString(16,"N"); //Material Request是否已建立 ?
  
  pstmt.executeUpdate();
  pstmt.close();  
 
  for (int i=0;i<choice.length;i++)
  {      
   String element0=request.getParameter(choice[i]+"-0");//取前一頁之輸入欄位 inter Model   
   String element2=request.getParameter(choice[i]+"-2");//取前一頁之輸入欄位 color
   String element3=request.getParameter(choice[i]+"-3");//取前一頁之輸入欄位 sales forecast
   if (element3==null) element3="0";
   String element4=request.getParameter(choice[i]+"-4");//取前一頁之輸入欄位 購料需求數目
   if (element4==null) element4="0";   
   
   sql="insert into PSALES_FORE_APP_LN(DOCNO,PRJCD,COLOR,FCQTY,RQQTY,RQYEAR,RQMONTH) values(?,?,?,?,?,?,?)";
   pstmt=con.prepareStatement(sql);
   pstmt.setString(1,seqno);
   pstmt.setString(2,element0);  
   pstmt.setString(3,element2);
   pstmt.setString(4,element3);
   pstmt.setString(5,element4);  
   pstmt.setString(6,targetYear);
   pstmt.setString(7,targetMonth);
   
   pstmt.executeUpdate();	
   pstmt.close();   
  } //end of for
    
  
  out.println("Forescast Data submited and has been sent to "+nextPrcsManName+"!! (Doc No:"+seqno+")<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>");       
  
  //--------------send mail option---------------------------
  if (!nextPrcsManMail.equals(""))
  {
    sendMailBean.setMailHost(mailHost);	    
    String serverName=request.getServerName();
    sendMailBean.setReception(nextPrcsManMail);
    sendMailBean.setFrom("WINS");  		  		           		   
    sendMailBean.setSubject(CodeUtil.unicodeToBig5("Sales forecast coming from "+UserName+" need to approve!!"));     
    sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSForeToApprove.jsp?DOCNO="+seqno);		 
    sendMailBean.sendMail();
  }//enf of nextPrcsManMail if--------------------------------	
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
