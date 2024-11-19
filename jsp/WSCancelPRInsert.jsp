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
<title>Cancel PR Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String docNo=request.getParameter("DOCNO"); 
String comment=request.getParameter("COMMENT");
String type=request.getParameter("TYPE");
String comp=request.getParameter("COMP");
String dateString=null;
String seqno=null,seqkey=null;

try
{  
  dateString=dateBean.getYearMonthDay();  
  //====先取得流水號=====  
  seqkey="CNL"+dateString.substring(2); //CNL代表取消單
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

  //新增一筆主檔
  String sql="insert into PSALES_FORE_APP_HD(DOCNO,BUSINESSUNIT,TYPE,REGION,COUNTRY,RQYEAR,RQMONTH,APPROVED,NEXTPRCSMAN,CREATEDBY,CREATEDDATE,CREATEDTIME,REMARK,STATUS,ORIGIN_PR,CANCEL) select '"+seqno+"',BUSINESSUNIT,'"+type+"',REGION,COUNTRY,RQYEAR,RQMONTH,'N','"+nextPrcsMan+"','"+userID+"','"+dateString+"','"+dateBean.getHourMinute()+"','"+comment+"','IN_PROGRESS','"+docNo+"','N' from PSALES_FORE_APP_HD where DOCNO='"+docNo+"'";
  PreparedStatement pstmt=con.prepareStatement(sql);         
  pstmt.executeUpdate();
  pstmt.close();   
 
  //新增LINE檔 
  sql="insert into PSALES_FORE_APP_LN(DOCNO,PRJCD,COLOR,FCQTY,RQQTY,RQYEAR,RQMONTH) select '"+seqno+"',PRJCD,COLOR,FCQTY,RQQTY,RQYEAR,RQMONTH from  PSALES_FORE_APP_LN where DOCNO='"+docNo+"'";
  pstmt=con.prepareStatement(sql);    
  pstmt.executeUpdate();	
  pstmt.close();  
    
  
  out.println("Cancel PR submited and has been sent to "+nextPrcsManName+"!! (Doc No:"+seqno+")<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>");       
  
  //--------------send mail option---------------------------
  if (!nextPrcsManMail.equals(""))
  {
    sendMailBean.setMailHost(mailHost);	    
    String serverName=request.getServerName();
    sendMailBean.setReception(nextPrcsManMail);
    sendMailBean.setFrom("WINS");  		  		           		   
    sendMailBean.setSubject(CodeUtil.unicodeToBig5("Cancel PR coming from "+UserName+" need to approve!!"));     
    sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSCancelPRApprove.jsp?DOCNO="+seqno);		 
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
