<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,SendMailBean,CodeUtil,ArrayStoreBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="arrayStoreBean" scope="session" class="ArrayStoreBean"/>
<html>
<head>
<title>Material Request Comfirmation Reply Data Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host nam
String docNo=request.getParameter("DOCNO");
String [][] choice=arrayStoreBean.getArray2DStore();
String dateString=null;
String action=request.getParameter("ACTION");
String status="",nextPrcsMan="",applyMan="",mailMan="",mailSubject="";
int docOrders=1;

Statement statement=con.createStatement();
ResultSet rs=null;
try
{  
  dateString=dateBean.getYearMonthDay();   
  
  //**************************************************************************
  rs=statement.executeQuery("select * from PSALES_FORE_MRC_HD where DOCNO='"+docNo+"'");  
  if (rs.next())
  {  
   docOrders=rs.getInt("ORDERS");
   applyMan=rs.getString("CREATEDBY");   
  }
  rs.close();
  
   //*********取得本流程資訊**********************************
   String isEnded="N";  
   rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='MRC' and TYPE='001' and ORDERS="+docOrders);
   if (rs.next())
   {
     isEnded=rs.getString("ISEND");      
   }    
   rs.close();  
   //************END OF 取得本流程資訊**************************
  
   //%%%%%%%%%%%%%%%%%判斷流程狀態%%%%%%%%%%%%%%%%%%%%%%%%%  
   if (isEnded.equals("Y"))  
   {   	
	  status="COMPLETE";	
   } else {
      status="IN_PROGRESS";
   }    
   //%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
	
   if (status.equals("COMPLETE") || status.equals("REJECT"))	
   {
     mailMan=applyMan;
  	 nextPrcsMan="--";
	 if (status.equals("COMPLETE") )
	 {
	    mailSubject="Material Request Confirmation has been replied by "+UserName+"!!"; 
	 } else {
	    mailSubject="Material Request Confirmation has been rejected by "+UserName+"!!"; 
	 }   
   } else {
     //*********取得下一個流程資訊**********************************
     docOrders++;     
     rs=statement.executeQuery("select * from WSWORKFLOW_ORDERBASE where ID='MRC' and TYPE='001' and ORDERS="+docOrders);
     if (rs.next())
     {      
       nextPrcsMan=rs.getString("PRCSMAN");  
     }    
     rs.close();  
     //************END OF 取得下一個流程資訊**************************
	 mailMan=nextPrcsMan;
	 mailSubject="Material Request Confirmation coming from "+UserName+" need to process!!";  
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

  String sql="update PSALES_FORE_MRC_HD set IS_COMPLETE=?,NEXTPRCSMAN=?,ORDERS=?,STATUS=? where DOCNO='"+docNo+"'";
  PreparedStatement pstmt=con.prepareStatement(sql);  
  pstmt.setString(1,isEnded);
  pstmt.setString(2,nextPrcsMan); 
  pstmt.setInt(3,docOrders); 
  pstmt.setString(4,status);
  
  pstmt.executeUpdate();
  pstmt.close();   
   
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
 
 
  for (int i=0;i<choice.length;i++)
  {      
   String element0=request.getParameter("DELIVERYQTY-"+choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]);//取前一頁之輸入欄位DELIVERYQTY  
   if (element0==null) element0="0";  
   String element1=request.getParameter("DELIVERYDATE-"+choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]);//取前一頁之輸入欄位DELIVERYDATE 
   if (element1==null) element1=""; 
   String element2=request.getParameter(choice[i][0]+"-"+choice[i][1]+"-"+choice[i][2]+"-COMMENT");//取前一頁之輸入欄位COMMENT  
   if (element2==null) element2="";        
   
   sql="insert into PSALES_FORE_MRC_LN(DOCNO,LINENO,PRJCD,COLOR,R_TYPE,HIERARCHY,CM_QTY,CM_DATE,REMARK,CREATEDBY,CREATEDDATE,CREATEDTIME,EP_QTY,EP_DATE,ORIGIN_RQTY) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
   pstmt=con.prepareStatement(sql);
   pstmt.setString(1,docNo);
   pstmt.setString(2,choice[i][2]); //line no
   pstmt.setString(3,choice[i][0]); //PRJCD 
   pstmt.setString(4,choice[i][1]); //COLOR
   pstmt.setString(5,"R"); //R_TYPE I:ISSUE R:REPLY 
   pstmt.setString(6,choice[i][3].substring(0,1)); //HEIRARCHY取第一個字元
   pstmt.setString(7,element0); //DELIVERY QTY    
   pstmt.setString(8,element1);  //DELIVERY DATE
   pstmt.setString(9,element2); //COMMENT -REMARK
   pstmt.setString(10,userID);  
   pstmt.setString(11,dateString);
   pstmt.setString(12,dateBean.getHourMinute()); 
   pstmt.setString(13,choice[i][6]); //EP_QTY期望數量
   pstmt.setString(14,choice[i][7]); //EP_DATE期望交期  
   pstmt.setString(15,choice[i][5]); //ORIGIN_RQTY原需求數量
   
   pstmt.executeUpdate();	
   pstmt.close();   
  } //end of for =>choice.length  
  
  out.println("Material Request Confirmation and has been sent to "+nextPrcsManName+"!! (Doc No:"+docNo+")<BR>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='../jsp/WSForecastMenu.jsp'>Back to submenu</A>");       
  
  //--------------send mail option---------------------------
  if (!nextPrcsManMail.equals(""))
  {
    sendMailBean.setMailHost(mailHost);	    
    String serverName=request.getServerName();
    sendMailBean.setReception(nextPrcsManMail);
    sendMailBean.setFrom("WINS"); 		  		           		   
    sendMailBean.setSubject(CodeUtil.unicodeToBig5(mailSubject));     
    sendMailBean.setUrlAddr(serverName+"/wins/jsp/WSFore_MRC_Receive.jsp?DOCNO="+docNo);		
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
arrayStoreBean.setArray2DStore(null); //離開前則清空Array Bean中之資料
statement.close();
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
