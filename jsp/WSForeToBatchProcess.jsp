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
<title>Forecast Data Batch Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String [] choice=request.getParameterValues("CH");
String comment=request.getParameter("COMMENT");
String action=request.getParameter("ACTION");
String businessUnit="",type="",status="";
String nextPrcsMan="",applyMan="",mailMan="";
String mailSubject="";

try
{  
  Statement statement=con.createStatement();
  ResultSet rs=null;
  
  for (int i=0;i<choice.length;i++)
  {   
    int docOrders=1;
    rs=statement.executeQuery("select * from PSALES_FORE_APP_HD where DOCNO='"+choice[i]+"'");  
    if (rs.next())
    {
     businessUnit=rs.getString("BUSINESSUNIT");
	 type=rs.getString("TYPE");
     docOrders=rs.getInt("ORDERS");
     applyMan=rs.getString("CREATEDBY");   
    }
    rs.close();
  
     //*********取得本流程資訊**********************************
    String isEnded="N";  
    rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='"+businessUnit+"' and TYPE='"+type+"' and ORDERS="+docOrders);
    if (rs.next())
    {
      isEnded=rs.getString("ISEND");      
    }    
    rs.close();  
    //************END OF 取得本流程資訊**************************
  
    //%%%%%%%%%%%%%%%%%判斷流程狀態%%%%%%%%%%%%%%%%%%%%%%%%%
    if (action.equals("REJECT"))
    {
       status="REJECT";
    } else {
       if (isEnded.equals("Y"))  
       {   	
	      status="COMPLETE";	
       } else {
          status="IN_PROGRESS";
       }  
    } 
    //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
  
    if (status.equals("COMPLETE") || status.equals("REJECT"))	
    {
      mailMan=applyMan;
	  nextPrcsMan="--";
  	  if (status.equals("COMPLETE") )
  	  {
	     mailSubject="Sales forecast has been approved by "+UserName+"!!"; 
	  } else {
	     mailSubject="Sales forecast has been rejected by "+UserName+"!!"; 
	  }   
    } else {
      //*********取得下一個流程資訊**********************************
      docOrders++;     
      rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='"+businessUnit+"' and TYPE='"+type+"' and ORDERS="+docOrders);
      if (rs.next())
      {      
        nextPrcsMan=rs.getString("PRCSMAN");  
      }    
      rs.close();  
    //************END OF 取得下一個流程資訊**************************
	  mailMan=nextPrcsMan;
	  mailSubject="Sales forecast coming from "+UserName+" need to approve!!";  
    }	
   
    //*********取得下一個處理人資料**********************************
    String nextPrcsManName="";  
    String nextPrcsManMail="";
    rs=statement.executeQuery("select * from WSUSER where WEBID='"+mailMan+"'");
    if (rs.next())
    {
      nextPrcsManName=rs.getString("USERNAME");  
      nextPrcsManMail=rs.getString("USERMAIL");  
    }    
    rs.close();    
    //************END OF 取得下一個處理人資料**************************
	
	String sql="update PSALES_FORE_APP_HD set APPROVED=?,NEXTPRCSMAN=?,ORDERS=?,STATUS=? where DOCNO='"+choice[i]+"'";
    PreparedStatement pstmt=con.prepareStatement(sql);  
    pstmt.setString(1,isEnded);
    pstmt.setString(2,nextPrcsMan); 
    pstmt.setInt(3,docOrders); 
    pstmt.setString(4,status);
  
    pstmt.executeUpdate();
    pstmt.close();   
   
    sql="insert into PSALES_FORE_APP_HIST(DOCNO,WHO,ACTION,ACT_DATE,ACT_TIME,H_COMMENT) values(?,?,?,?,?,?)";
    pstmt=con.prepareStatement(sql);
    pstmt.setString(1,choice[i]);
    pstmt.setString(2,userID);  
    pstmt.setString(3,action);
    pstmt.setString(4,dateBean.getYearMonthDay());
    pstmt.setString(5,dateBean.getHourMinute());
    pstmt.setString(6,comment); 
   
    pstmt.executeUpdate();	
    pstmt.close();  
  
    //--------------send mail option---------------------------
    if (!nextPrcsManMail.equals(""))
    {
      sendMailBean.setMailHost(mailHost);	    
      String serverName=request.getServerName();
      sendMailBean.setReception(nextPrcsManMail);
      sendMailBean.setFrom("WINS");  		  		           		   
      sendMailBean.setSubject(CodeUtil.unicodeToBig5(mailSubject));     
      sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSForeToApprove.jsp?DOCNO="+choice[i]);		 
      sendMailBean.sendMail();
    }//enf of nextPrcsManMail if--------------------------------	   
	
	if (status.equals("COMPLETE")) //若已核准則通知MCUser物管人員
    {
      rs=statement.executeQuery("select USERMAIL from WSGROUPUSERROLE,WSUSER where GROUPUSERNAME=USERNAME and ROLENAME='MCUser'");
	  while (rs.next())
	  {
	    sendMailBean.setReception(rs.getString("USERMAIL"));
	    sendMailBean.sendMail();
	  }  
      rs.close();  
    }
  } //end of choice for         	       
  statement.close();
  out.println("Forecast Data Processed !!<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>"); 
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
