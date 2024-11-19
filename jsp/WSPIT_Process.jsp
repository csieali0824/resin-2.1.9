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
<title>PIT Data Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String action=request.getParameter("ACTION");
String assignTo=request.getParameter("ASSIGNTO");
String dueDate=request.getParameter("DUEDATE");
String fromStatus=request.getParameter("FROMSTATUS");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String [] choice=request.getParameterValues("CH");
String dateString=null;

Statement statement=con.createStatement();
ResultSet rs=null;
try
{  
  dateString=dateBean.getYearMonthDay();   
  
  //*********取得下一個流程資訊**********************************
  String nextStatus="",nextStatusName="";  
  String nextPrcsMan="";
  
  if (action.equals("007")) //如果動作是assign
  {
    nextPrcsMan=assignTo;
  }	
  if (action.equals("008")) //如果動作是assign,則取得PIT_Verifier之角色的人員資料
  {
    rs=statement.executeQuery("select WEBID from WSGROUPUSERROLE r,WSUSER u where r.GROUPUSERNAME=u.USERNAME and ROLENAME='PIT_Verifier'");
    if (rs.next())
    {
      nextPrcsMan=rs.getString("WEBID");	      
    }    
    rs.close();    
  }	  
  
  rs=statement.executeQuery("select TOSTATUSID,STATUSNAME from WSWORKFLOW w,WSWFSTATUS s where TOSTATUSID=STATUSID and FORMID='"+formID+"' and TYPENO='"+typeNo+"' and FROMSTATUSID='"+fromStatus+"' and ACTIONID='"+action+"'");
  if (rs.next())
  {
    nextStatus=rs.getString("TOSTATUSID");  
	nextStatusName=rs.getString("STATUSNAME");        
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
  //************END OF 取得下一個流程資訊**************************  

  for (int i=0;i<choice.length;i++)
  {      
                 
	String seqSql="";
	PreparedStatement seqstmt=null;
   
    if (action.equals("099")) //如果動作是close
	{
	    String element0=request.getParameter("REMARK-"+choice[i]);//取前一頁之REMARK欄位 
		seqSql="update PIT_MASTER SET STATUSID=?,STATUS=?,REMARK=? WHERE TICKETNO='"+choice[i]+"'";   
		seqstmt=con.prepareStatement(seqSql);        
		seqstmt.setString(1,nextStatus); 
		seqstmt.setString(2,nextStatusName); 
		seqstmt.setString(3,element0); 
	}
		
    if (action.equals("007")) //如果動作是assign
	{
		seqSql="update PIT_MASTER SET ASSIGNTO=?,DUEDATE=?,STATUSID=?,STATUS=? WHERE TICKETNO='"+choice[i]+"'";   
		seqstmt=con.prepareStatement(seqSql);        
		seqstmt.setString(1,assignTo); 
		seqstmt.setString(2,dueDate); 	
		seqstmt.setString(3,nextStatus); 	
		seqstmt.setString(4,nextStatusName); 		 
	}			
	
	 if (action.equals("008")) //如果動作是resolve
	{
	    String element0=request.getParameter("REASON-"+choice[i]);//取前一頁之REASON欄位		
		String element1=request.getParameter("CORRECTACTION-"+choice[i]);//取前一頁之CORRECTACTION欄位 
		
		seqSql="update PIT_MASTER SET STATUSID=?,STATUS=?,FAULTREASON=?,CORRECTACTION=?,RESOLVEDDATE=? WHERE TICKETNO='"+choice[i]+"'";   
		seqstmt=con.prepareStatement(seqSql);        
		seqstmt.setString(1,nextStatus); 
		seqstmt.setString(2,nextStatusName); 
		seqstmt.setString(3,element0); 
		seqstmt.setString(4,element1); 
		seqstmt.setString(5,dateString); 
	}	
	
	if (action.equals("009")) //如果動作是verify
	{
	    String element0=request.getParameter("VALIDATION-"+choice[i]);//取前一頁之VALIDATION欄位		
		String element1=request.getParameter("RESULT-"+choice[i]);//取前一頁之VALIDATION欄位		
		 
		seqSql="update PIT_MASTER SET VALIDATION=?,VALIDATEDDATE=?,RESULT=?,STATUSID=?,STATUS=? WHERE TICKETNO='"+choice[i]+"'";   
		seqstmt=con.prepareStatement(seqSql);        
		seqstmt.setString(1,element0); 
		seqstmt.setString(2,dateString); 	
		seqstmt.setString(3,element1); 
		seqstmt.setString(4,nextStatus); 	
		seqstmt.setString(5,nextStatusName); 		 
	}
		
    seqstmt.executeUpdate();   
    seqstmt.close(); 
	
	 //--------------send mail option---------------------------
   if (!nextPrcsManMail.equals("") && (action.equals("007") || action.equals("008")))
   {
     sendMailBean.setMailHost(mailHost);	    
     String serverName=request.getServerName();
     sendMailBean.setReception(nextPrcsManMail);
     sendMailBean.setFrom("WINS");  		  		
	 if (action.equals("007"))           		   
	 {
          sendMailBean.setSubject(CodeUtil.unicodeToBig5("Product Issue Tracking coming from "+UserName+" need to resolve!!"));     
          sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSPIT_Resolve.jsp?TICKETNO="+choice[i]);		
	 }	  
	 if (action.equals("008"))           		   
	 {
          sendMailBean.setSubject(CodeUtil.unicodeToBig5("Product Issue Tracking coming from "+UserName+" need to verify!!"));     
          sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSPIT_Verify.jsp?TICKETNO="+choice[i]);		
	 }	
	 sendMailBean.setUrlName("Product Issue Tracking");	 
     sendMailBean.sendMail();
	 out.println("Product Issue Tracking has been sent to "+nextPrcsManName+"!! (Ticket No:"+choice[i]+")<BR>");
   }//enf of nextPrcsManMail if--------------------------------	 
  
	out.println("Product Issue Tracking submited!! (Ticket No:"+choice[i]+")<BR>");		
  } //end of for -> i   
  
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp");          
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
