<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,CodeUtil,ArrayCheckBoxBean" %>
<html>
<head>
<title>INVProcess.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
</head>

<body>
<%
String [][] chooseFeatures=arrayCheckBoxBean.getArray2DContent();
String [][] qty=arrayCheckBoxBean.getArray2DContent();

String [] choice=request.getParameterValues("CH");
String choiceString=null;
String formID=request.getParameter("FORMID");
//String svrTypeNo=request.getParameter("SVRTYPENO");
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
//String STATUSID=request.getParameter("STATUSID");
//String repPersonID=request.getParameter("REPPERSONID");
//String remark=request.getParameter("REMARK");
String repNo="";
//String oriIMEI=request.getParameter("IMEI");
String oriStatus=null;
String actionName=null;
//String changeRepCenterNo=request.getParameter("CHANGEREPCENTERNO");
//String changeRepPersonID=request.getParameter("CHANGEREPPERSONID");

//String ACTCENTERNO=request.getParameter("ACTCENTERNO");
//String RECCREATEDATE=request.getParameter("RECCREATEDATE");
//String RECCREATEUSER=request.getParameter("RECCREATEUSER");
//String USERNAME=request.getParameter("USERNAME");
String WHS=request.getParameter("WHS");
String LOC=request.getParameter("LOC");
//String REQREASON=request.getParameter("REQREASON");
String REMARK=request.getParameter("REMARK");
//String ACTIONID=request.getParameter("ACTIONID");
//String RECSTATID=request.getParameter("RECSTATID");
//String RECSTAT=request.getParameter("RECSTAT");
        String seqkey=null;
        String dateString=null;
		String seqno=null;
		String Hour=null;
		String Item=null;
String sDate = dateBean.getYearMonthDay();		
		int oriQty=0;
		int newQty=0;
		int nowQty=0;
		int iDate=0;

//String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
try
{

  Statement getStatusStat=con.createStatement();  
  ResultSet getStatusRs=getStatusStat.executeQuery("select TOSTATUSID,STATUSNAME from WSWORKFLOW x1,WSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID");  
  getStatusRs.next();  
   
  for (int k=0;k<choice.length ;k++)    
  { /*    
      String sql="update RPMR set STATUSID=?,STATUS=? where MRDOCNO='"+choice[k]+"'";
      PreparedStatement pstmt=con.prepareStatement(sql);  
 
      pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
      pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS
  
      pstmt.executeUpdate();
      pstmt.close();
    */ 


            Statement stateMRDOC=con.createStatement();
            //String sql="select * from RPMR where MRDOCNO='"+MRDOCNO+"'"; // 修正SPAN 誤用 userName 之問題點 2004/05/24 //
            String sqlMRDOC="select REMARK from INV_M_HISTORY where STATUSID IN ('001','004') and RECCREATENO='"+choice[k]+"' ";
            ResultSet rsMRDOC=stateMRDOC.executeQuery(sqlMRDOC);
			//out.println(sqlMRDOC);
	        if (rsMRDOC.next())
            {
             //ACTCENTERNO=rsMRDOC.getString("RECCENTERNO");
	         //RECCREATEDATE=rsMRDOC.getString("RECCREATEDATE");
             //RECCREATEUSER=rsMRDOC.getString("RECCREATEUSER");
	         //REQREASON=rsMRDOC.getString("REQREASON");
	         //BLWHS=rsMRDOC.getString("BLWHS");   
	         REMARK=rsMRDOC.getString("REMARK");
	         //RECSTATID=rsMRDOC.getString("RECSTATID");
	         //RECSTAT=rsMRDOC.getString("RECSTAT");
             //USERNAME=rsMRDOC.getString("USERNAME");
            }
			rsMRDOC.close();
            stateMRDOC.close();

  if (actionID.equals("003") && fromStatusID.equals("002"))//入庫單簽核同意
  {
  
   String sql1="update INV_M_REC set RECSTATID=?,RECSTAT=? where RECCREATENO='"+choice[k]+"'";
   PreparedStatement pstmt1=con.prepareStatement(sql1); 
   //out.println(sql1);
   pstmt1.setString(1,"003");  
   pstmt1.setString(2,"CONFIRM"); //   
    
   pstmt1.executeUpdate(); 
   pstmt1.close();

   //out.print("<a href=../RepairMainMenu.jsp>回首頁</a>");
   
   String commSql="update INV_M_DETAIL set RECWHS=?,RECLOC=? where RECCREATENO='"+choice[k]+"' ";
   PreparedStatement commStmt=con.prepareStatement(commSql);
   //out.println(commSql);
   commStmt.setString(1,WHS); 
   commStmt.setString(2,LOC);
   commStmt.executeUpdate();       
   commStmt.close(); 

   String sSqlH = "select a.RECCREATENO,a.RECITEMNOACT,a.RECQTYACT,b.RECPROJCODE from INV_M_DETAIL a,INV_M_REC b where a.RECCREATENO='"+choice[k]+"' and a.RECCREATENO=b.RECCREATENO";
   Statement statement=con.createStatement();
   ResultSet rsH=statement.executeQuery(sSqlH);
   //out.println(sSqlH);
   while (rsH.next())
   {   
    iDate = Integer.parseInt(sDate);
	Item = rsH.getString("RECITEMNOACT");		
	newQty = rsH.getInt("RECQTYACT"); 

   	String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
   	PreparedStatement pstmtH=con.prepareStatement(sqlH); 
	//out.println(sqlH); 
   	pstmtH.setString(1,WHS);
   	pstmtH.setString(2,LOC); 
   	pstmtH.setString(3,Item);
   	pstmtH.setInt(4,newQty); 
   	pstmtH.setString(5,"P");
	pstmtH.setString(6,rsH.getString("RECPROJCODE"));
   	pstmtH.setString(7,REMARK); 
   	pstmtH.setString(8,userID); 
   	pstmtH.setInt(9,iDate);
   	pstmtH.setString(10,rsH.getString("RECCREATENO"));      
  
   	pstmtH.executeUpdate();
	pstmtH.close();
	
	//insert into INV_M_REM 庫存餘額檔
	String sqlR = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+Item+"' ";
	Statement stateR=con.createStatement();
	ResultSet rsR=stateR.executeQuery(sqlR);
	//out.println(sqlR);
	if (rsR.next())
	{
		oriQty = rsR.getInt("REMQTY");
		
   		String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+Item+"' and REMWHS='"+WHS+"' and REMLOC='"+LOC+"' ";
   		PreparedStatement pstmtU=con.prepareStatement(sqlU); 
 		//out.println(sqlU);
		nowQty = oriQty + newQty;
		
   		pstmtU.setInt(1,nowQty);    
    
   		pstmtU.executeUpdate(); 
   		pstmtU.close();	
	}
	else
	{
   		String sqlI="insert into INV_M_REM(REMWHS,REMLOC,REMITEMNO,REMQTY) values(?,?,?,?)";
   		PreparedStatement pstmtI=con.prepareStatement(sqlI); 
		//out.println(sqlI); 
   		pstmtI.setString(1,WHS);
   		pstmtI.setString(2,LOC); 
   		pstmtI.setString(3,Item);
   		pstmtI.setInt(4,newQty);     
  
   		pstmtI.executeUpdate();
		pstmtI.close();	
	}
	rsR.close();
	stateR.close();	
  
   }			
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,choice[k]); 
  	historystmt.setString(2,"003"); 
  	historystmt.setString(3,"CONFIRM"); //寫入status名稱
  	historystmt.setString(4,"003"); 
  	historystmt.setString(5,"AGREE"); 
  	historystmt.setString(6,userID); 
  	historystmt.setString(7,dateBean.getYearMonthDay()); 
  	historystmt.setString(8,dateBean.getHourMinuteSecond());
  	historystmt.setString(9,userActCenterNo); //寫入Center編號
  	historystmt.setString(10,"OK");
  
  	historystmt.executeUpdate(); 
  
  	historystmt.close();    
   
   out.print("倉管簽核/入庫完成"+"<br>");
   //out.print("倉管發料完成"+"<br>"); 
   out.println("Processing INV OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVRecStatus.jsp?STATUSID=002&PAGEURL=INVRecPage.jsp'>回入庫案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");
      
   statement.close(); 
   rsH.close(); 
  } 
  else if(actionID.equals("003") && fromStatusID.equals("004")) //領料單簽核同意
  {  
   String sql1="update INV_M_ISS set ISSSTATID=?,ISSSTAT=? where ISSCREATENO='"+choice[k]+"'";
   PreparedStatement pstmt1=con.prepareStatement(sql1); 
   //out.println(sql1);
   pstmt1.setString(1,"005");  
   pstmt1.setString(2,"ISSUING"); //   
    
   pstmt1.executeUpdate(); 
   pstmt1.close();

   //out.print("<a href=../RepairMainMenu.jsp>回首頁</a>");
   
   String commSql="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO='"+choice[k]+"' ";
   PreparedStatement commStmt=con.prepareStatement(commSql);
   //out.println(commSql);
   commStmt.setString(1,WHS); 
   commStmt.setString(2,LOC);
   commStmt.executeUpdate();       
   commStmt.close(); 

   String sSqlH = "select a.ISSCREATENO,a.ISSITEMNOACT,a.ISSQTYACT,b.ISSPROJCODE from INV_M_IDTL a,INV_M_ISS b where a.ISSCREATENO='"+choice[k]+"' and a.ISSCREATENO=b.ISSCREATENO";
   Statement statement=con.createStatement();
   ResultSet rsH=statement.executeQuery(sSqlH);
   //out.println(sSqlH);
   while (rsH.next())
   {   
    iDate = Integer.parseInt(sDate);
	Item = rsH.getString("ISSITEMNOACT");		
	newQty = rsH.getInt("ISSQTYACT"); 

   	String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
   	PreparedStatement pstmtH=con.prepareStatement(sqlH); 
	//out.println(sqlH); 
   	pstmtH.setString(1,WHS);
   	pstmtH.setString(2,LOC); 
   	pstmtH.setString(3,Item);
   	pstmtH.setInt(4,newQty); 
   	pstmtH.setString(5,"I");
	pstmtH.setString(6,rsH.getString("ISSPROJCODE"));
   	pstmtH.setString(7,REMARK); 
   	pstmtH.setString(8,userID); 
   	pstmtH.setInt(9,iDate);
   	pstmtH.setString(10,rsH.getString("ISSCREATENO"));      
  
   	pstmtH.executeUpdate();
	pstmtH.close();
	
	//insert into INV_M_REM 庫存餘額檔
	String sqlR = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+Item+"' ";
	Statement stateR=con.createStatement();
	ResultSet rsR=stateR.executeQuery(sqlR);
	//out.println(sqlR);
	if (rsR.next())
	{
		oriQty = rsR.getInt("REMQTY");
		
   		String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+Item+"' and REMWHS='"+WHS+"' and REMLOC='"+LOC+"' ";
   		PreparedStatement pstmtU=con.prepareStatement(sqlU); 
 		//out.println(sqlU);
		nowQty = oriQty - newQty;
		
   		pstmtU.setInt(1,nowQty);    
    
   		pstmtU.executeUpdate(); 
   		pstmtU.close();	
	}
	rsR.close();
	stateR.close();	
  
   }			
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,choice[k]); 
  	historystmt.setString(2,"005"); 
  	historystmt.setString(3,"ISSUING"); //寫入status名稱
  	historystmt.setString(4,"003"); 
  	historystmt.setString(5,"AGREE"); 
  	historystmt.setString(6,userID); 
  	historystmt.setString(7,dateBean.getYearMonthDay()); 
  	historystmt.setString(8,dateBean.getHourMinuteSecond());
  	historystmt.setString(9,userActCenterNo); //寫入Center編號
  	historystmt.setString(10,"OK");
  
  	historystmt.executeUpdate(); 
  
  	historystmt.close();    
   
   out.print("倉管簽核/發料完成"+"<br>");
   //out.print("倉管發料完成"+"<br>"); 
   out.println("Processing ISS OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVIssStatus.jsp?STATUSID=004&PAGEURL=INVIssPage.jsp'>回領料案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");
      
   statement.close(); 
   rsH.close(); 
  }   
  else if(actionID.equals("004") && fromStatusID.equals("002"))//入庫單簽核批退
  {
   String sql2="update INV_M_REC set RECSTATID=?,RECSTAT=? where RECCREATENO='"+choice[k]+"'";
   PreparedStatement pstmt2=con.prepareStatement(sql2); 
 
   pstmt2.setString(1,"007");  
   pstmt2.setString(2,"DISAPPROVAL"); //   
    
   pstmt2.executeUpdate(); 
   pstmt2.close();
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,choice[k]); 
  	historystmt.setString(2,"007"); 
  	historystmt.setString(3,"DISAPPROVAL"); //寫入status名稱
  	historystmt.setString(4,"004"); 
  	historystmt.setString(5,"REJECT"); 
  	historystmt.setString(6,userID); 
  	historystmt.setString(7,dateBean.getYearMonthDay()); 
  	historystmt.setString(8,dateBean.getHourMinuteSecond());
  	historystmt.setString(9,userActCenterNo); //寫入Center編號
  	historystmt.setString(10,"NO");
  
  	historystmt.executeUpdate(); 
  
  	historystmt.close();
	   
   out.print("倉管簽核不同意"+"<br>");
   
   out.println("Processing INV OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVRecStatus.jsp?STATUSID=002&PAGEURL=INVRecPage.jsp'>回入庫案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");   
   //out.print("<a href=../RepairMainMenu.jsp>回首頁</a>");
  } 
  else if(actionID.equals("004") && fromStatusID.equals("004"))//領料單簽核批退
  {
   String sql2="update INV_M_ISS set ISSSTATID=?,ISSSTAT=? where ISSCREATENO='"+choice[k]+"'";
   PreparedStatement pstmt2=con.prepareStatement(sql2); 
 
   pstmt2.setString(1,"008");  
   pstmt2.setString(2,"DISAPPROVAL"); //   
    
   pstmt2.executeUpdate(); 
   pstmt2.close();
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,choice[k]); 
  	historystmt.setString(2,"008"); 
  	historystmt.setString(3,"DISAPPROVAL"); //寫入status名稱
  	historystmt.setString(4,"004"); 
  	historystmt.setString(5,"REJECT"); 
  	historystmt.setString(6,userID); 
  	historystmt.setString(7,dateBean.getYearMonthDay()); 
  	historystmt.setString(8,dateBean.getHourMinuteSecond());
  	historystmt.setString(9,userActCenterNo); //寫入Center編號
  	historystmt.setString(10,"NO");
  
  	historystmt.executeUpdate(); 
  
  	historystmt.close();
	   
   out.print("倉管簽核不同意"+"<br>");
   
   out.println("Processing ISS OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVIssStatus.jsp?STATUSID=004&PAGEURL=INVIssPage.jsp'>回領料案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");   

  } 
  getStatusRs.close();  // Statement 結束
  
  
 } // end of for (int k=0;k<choice.length ;k++) 
 //out.println("<A HREF=../jsp/MRQAll.jsp>查詢所有領料案件</A> ");
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
