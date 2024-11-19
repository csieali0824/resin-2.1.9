<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,RsBean" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckInputBoxBean,SendMailBean,CodeUtil" %>
<html>
<head>
<title>INVProcessACT.jsp</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckInputBoxBean" scope="session" class="ArrayCheckInputBoxBean"/>
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
</head>

<body>
<%
String ACTCENTERNO=request.getParameter("ACTCENTERNO");
String RECCREATEDATE=request.getParameter("RECCREATEDATE");
String RECCREATEUSER=request.getParameter("RECCREATEUSER");
String RECSTATID=request.getParameter("RECSTATID");
String RECSTAT=request.getParameter("RECSTAT");
String RECCREATENO=request.getParameter("RECCREATENO");
String ISSCENTERNO=request.getParameter("ISSCENTERNO");
String ISSCREATEDATE=request.getParameter("ISSCREATEDATE");
String ISSCREATEUSER=request.getParameter("ISSCREATEUSER");
String ISSSTATID=request.getParameter("ISSSTATID");
String ISSSTAT=request.getParameter("ISSSTAT");
String ISSCREATENO=request.getParameter("ISSCREATENO");
String USERNAME=request.getParameter("USERNAME");
String REMARK=request.getParameter("REMARK");
String actionID=request.getParameter("ACTIONID");
		String Item=null;
		String Whs=null;
		String Loc=null;
String sDate = dateBean.getYearMonthDay();	
		int oriQty=0;
		int newQty=0;
		int nowQty=0;
		int iDate=0;
        int iQtyAct = 0;			
String ChkFlag = "";
String fromStatusID=request.getParameter("FROMSTATUSID");
String [][] chooseFeatures=arrayCheckInputBoxBean.getArray2DContent();
//String [][] qty=ArrayCheckInputBoxBean.getArray2DContent();
 try
 { 
if (chooseFeatures!=null) {
	//入庫單簽核同意
  if (actionID.equals("003") && fromStatusID.equals("002"))
  {
   String sql1="update INV_M_REC set RECSTATID=?,RECSTAT=? where RECCREATENO='"+RECCREATENO+"'";
   PreparedStatement pstmt1=con.prepareStatement(sql1); 
 
   pstmt1.setString(1,"003");  
   pstmt1.setString(2,"CONFIRM"); //   
    
   pstmt1.executeUpdate(); 
   pstmt1.close();
   
    if (chooseFeatures!=null && chooseFeatures.length>0)
    { 
        for (int i=0;i<chooseFeatures.length;i++)
        {   
   			String sSqlD = "select RECITEMNO from INV_M_DETAIL where RECCREATENO='"+RECCREATENO+"' and RECITEMNO='"+chooseFeatures[i][0]+"' ";
   			Statement stateD=con.createStatement();
  			ResultSet rsD=stateD.executeQuery(sSqlD);
  			if (rsD.next())
   			{  	
			    iQtyAct = Integer.parseInt(chooseFeatures[i][1]);
   				String SqlD="update INV_M_DETAIL set RECWHS=?,RECLOC=?,RECITEMNOACT=?,RECQTYACT=? where RECCREATENO='"+RECCREATENO+"' and RECITEMNO='"+chooseFeatures[i][0]+"' ";
   				PreparedStatement commD=con.prepareStatement(SqlD);
   				commD.setString(1,chooseFeatures[i][2]); 
   				commD.setString(2,chooseFeatures[i][3]);				
   				commD.setString(3,chooseFeatures[i][0]); 
   				commD.setInt(4,iQtyAct);				
   				commD.executeUpdate();       
   				commD.close(); 
        	}
			else
			{
     			iQtyAct = Integer.parseInt(chooseFeatures[i][1]);
     			String sSql="insert into INV_M_DETAIL(RecCreateNo,RecItemNo,RecQty,RecItemNOAct,RecQtyAct,RecWhs,RecLoc) values(?,?,?,?,?,?,?)";
     			PreparedStatement sStmt=con.prepareStatement(sSql);
     			sStmt.setString(1,RECCREATENO); 
     			sStmt.setString(2,"");
	 			sStmt.setInt(3,0); 
     			sStmt.setString(4,chooseFeatures[i][0]);
	 			sStmt.setInt(5,iQtyAct); 	
     			sStmt.setString(6,chooseFeatures[i][2]); 
	 			sStmt.setString(7,chooseFeatures[i][3]);				
     			sStmt.executeUpdate();       
     			sStmt.close();			
			}
			rsD.close();
			stateD.close();	
		}
    }

   //將取消入庫的料號、數量，改為""、0	
   String SqlZ="update INV_M_DETAIL set RECITEMNOACT='',RECQTYACT=0 where RECCREATENO='"+RECCREATENO+"' and RECWHS is null and RECLOC is null ";
   PreparedStatement commZ=con.prepareStatement(SqlZ);		
   commZ.executeUpdate();       
   commZ.close(); 
				   
   String sSqlH = "select a.RECCREATENO,a.RECITEMNOACT,a.RECQTYACT,a.RECWHS,a.RECLOC,b.RECPROJCODE,b.RECCREATEUSER,c.REMARK "+ 
                  " from INV_M_DETAIL a,INV_M_REC b,INV_M_HISTORY c "+
                  " where a.RECCREATENO='"+RECCREATENO+"' and a.RECCREATENO=b.RECCREATENO and a.RECCREATENO=c.RECCREATENO "+
				  " and c.STATUSID='001' and RECWHS is not null and RECLOC is not null ";
   Statement statement=con.createStatement();
   ResultSet rsH=statement.executeQuery(sSqlH);
   while (rsH.next())
   {   
    iDate = Integer.parseInt(sDate);
	Item = rsH.getString("RECITEMNOACT");		
	Whs = rsH.getString("RECWHS");
	Loc = rsH.getString("RECLOC");
	newQty = rsH.getInt("RECQTYACT"); 

   	String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
   	PreparedStatement pstmtH=con.prepareStatement(sqlH);  
   	pstmtH.setString(1,Whs);
   	pstmtH.setString(2,Loc);	
   	pstmtH.setString(3,Item);
   	pstmtH.setInt(4,newQty); 
   	pstmtH.setString(5,"P");
	pstmtH.setString(6,rsH.getString("RECPROJCODE"));
   	pstmtH.setString(7,rsH.getString("REMARK")); 
   	pstmtH.setString(8,userID); 
   	pstmtH.setInt(9,iDate);
   	pstmtH.setString(10,rsH.getString("RECCREATENO"));      
  
   	pstmtH.executeUpdate();
	pstmtH.close();
	
	//insert into INV_M_REM 庫存餘額檔
	String sqlR = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+Item+"' ";
	Statement stateR=con.createStatement();
	ResultSet rsR=stateR.executeQuery(sqlR);
	if (rsR.next())
	{
		oriQty = rsR.getInt("REMQTY");
		
   		String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";
   		PreparedStatement pstmtU=con.prepareStatement(sqlU); 
		nowQty = oriQty + newQty;
		
   		pstmtU.setInt(1,nowQty);    
    
   		pstmtU.executeUpdate(); 
   		pstmtU.close();	
	}
	else
	{
		if (Item==null || Item.equals(""))
		{}
		else
		{
   			String sqlI="insert into INV_M_REM(REMWHS,REMLOC,REMITEMNO,REMQTY) values(?,?,?,?)";
   			PreparedStatement pstmtI=con.prepareStatement(sqlI); 
   			pstmtI.setString(1,Whs);
   			pstmtI.setString(2,Loc); 
   			pstmtI.setString(3,Item);
   			pstmtI.setInt(4,newQty);     
  
   			pstmtI.executeUpdate();
			pstmtI.close();	
		}
	}
	rsR.close();
	stateR.close();		 	    
   } // END OF WHILE
   
	//insert into INV_M_HISTORY 流程歷史檔
	String sqlC = "select * from INV_M_HISTORY where RECCREATENO='"+RECCREATENO+"' and STATUSID='002' ";
	Statement stateC=con.createStatement();
	ResultSet rsC=stateC.executeQuery(sqlC);
	if (rsC.next())
	{}
	else
	{	
    	String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 		PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  		historystmt.setString(1,RECCREATENO); 
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
  
  	}			
	rsC.close();
	stateC.close();	
	
	arrayCheckInputBoxBean.setArray2DString(null); // clear array bean data
	   
   out.print("倉管簽核/入庫完成"+"<br>");
   out.println("Processing INV OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVRecStatus.jsp?STATUSID=002&PAGEURL=INVRecPage.jsp'>回入庫案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");    
  }
  //領料單簽核同意
  else if(actionID.equals("003") && fromStatusID.equals("004")) 
  {       
    if (chooseFeatures!=null && chooseFeatures.length>0)
    { 
        for (int i=0;i<chooseFeatures.length;i++)
        {   
   			String sSqlD = "select ISSITEMNO from INV_M_IDTL where ISSCREATENO='"+ISSCREATENO+"' and ISSITEMNO='"+chooseFeatures[i][0]+"' ";
   			Statement stateD=con.createStatement();
  			ResultSet rsD=stateD.executeQuery(sSqlD);			
  			if (rsD.next())
   			{  	
			    iQtyAct = Integer.parseInt(chooseFeatures[i][1]);
   				String SqlD="update INV_M_IDTL set ISSWHS=?,ISSLOC=?,ISSITEMNOACT=?,ISSQTYACT=? where ISSCREATENO='"+ISSCREATENO+"' and ISSITEMNO='"+chooseFeatures[i][0]+"' ";
   				PreparedStatement commD=con.prepareStatement(SqlD);
   				commD.setString(1,chooseFeatures[i][2]); 
   				commD.setString(2,chooseFeatures[i][3]);				
   				commD.setString(3,chooseFeatures[i][0]); 
   				commD.setInt(4,iQtyAct);				
   				commD.executeUpdate();       
   				commD.close(); 
        	}
			else
			{
     			iQtyAct = Integer.parseInt(chooseFeatures[i][1]);
     			String sSql="insert into INV_M_IDTL(IssCreateNo,IssItemNo,IssQty,IssItemNOAct,IssQtyAct,IssWhs,IssLoc) values(?,?,?,?,?,?,?)";
     			PreparedStatement sStmt=con.prepareStatement(sSql);
     			sStmt.setString(1,ISSCREATENO); 
     			sStmt.setString(2,"");
	 			sStmt.setInt(3,0); 
     			sStmt.setString(4,chooseFeatures[i][0]);
	 			sStmt.setInt(5,iQtyAct); 	
     			sStmt.setString(6,chooseFeatures[i][2]); 
	 			sStmt.setString(7,chooseFeatures[i][3]);					
     			sStmt.executeUpdate();       
     			sStmt.close();			
			}
			rsD.close();
			stateD.close();	
		}
    }

   //將取消發料的料號、數量，改為""、0	
   String SqlZ="update INV_M_IDTL set ISSITEMNOACT='',ISSQTYACT=0 where ISSCREATENO='"+ISSCREATENO+"' and ISSWHS is null and ISSLOC is null ";
   PreparedStatement commZ=con.prepareStatement(SqlZ);		
   commZ.executeUpdate();       
   commZ.close(); 
     
   String sSqlH = "select a.ISSCREATENO,a.ISSITEMNOACT,a.ISSQTYACT,a.ISSWHS,a.ISSLOC,b.ISSPROJCODE,c.REMARK "+
                  " from INV_M_IDTL a,INV_M_ISS b,INV_M_HISTORY c "+
				  " where a.ISSCREATENO='"+ISSCREATENO+"' and a.ISSCREATENO=b.ISSCREATENO and a.ISSCREATENO=c.RECCREATENO "+
				  " and c.STATUSID='006' and ISSWHS is not null and ISSLOC is not null";
   Statement statement=con.createStatement();
   ResultSet rsH=statement.executeQuery(sSqlH);
   while (rsH.next())
   {   
    iDate = Integer.parseInt(sDate);
	Item = rsH.getString("ISSITEMNOACT");	
	Whs = rsH.getString("ISSWHS");
	Loc = rsH.getString("ISSLOC");	
	newQty = rsH.getInt("ISSQTYACT"); 

	String sqlC = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' ";		 
    Statement stateC=con.createStatement();
    ResultSet rsC=stateC.executeQuery(sqlC); 
    if (rsC.next()==false)
	{
	  ChkFlag = "NG";
	  out.println("料號："+Item+"不存在!<BR>");
	  //將不正確的料號之WHS、LOC Update 為空白
	  String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  pstmtN.setString(1,"");    
	  pstmtN.setString(2,"");
	  pstmtN.executeUpdate(); 
	  pstmtN.close();	  
	}
	else
	{
	  String sqlW = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' ";		 
      Statement stateW=con.createStatement();
      ResultSet rsW=stateC.executeQuery(sqlW); 
      if (rsW.next()==false)
	  {
	    ChkFlag = "NG";
		out.println("料號："+Item+"不存在此倉別!<BR>");
		//將不正確的料號之WHS、LOC Update 為空白
	  	String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  	PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  	pstmtN.setString(1,"");    
	  	pstmtN.setString(2,"");
	  	pstmtN.executeUpdate(); 
	  	pstmtN.close();	
 	  }
	  else
	  {
    	String sqlL = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";		 
    	Statement stateL=con.createStatement();
    	ResultSet rsL=stateC.executeQuery(sqlL); 
    	if (rsL.next()==false)
		{
		  ChkFlag = "NG";
		  out.println("料號："+Item+"不存在此架位!<BR>");
		  //將不正確的料號之WHS、LOC Update 為空白
	  	  String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  	  PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  	  pstmtN.setString(1,"");    
	  	  pstmtN.setString(2,"");
	  	  pstmtN.executeUpdate(); 
	  	  pstmtN.close();
		}
		else			
		{		
		  String sqlQ = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' and REMQTY>="+newQty+" ";		 
    	  Statement stateQ=con.createStatement();
    	  ResultSet rsQ=stateC.executeQuery(sqlQ); 
    	  if (rsQ.next()==false)
		  {
		    ChkFlag = "NG";
		    out.println("料號："+Item+"庫存不足!<BR>");
			//將不正確的料號之WHS、LOC Update 為空白
	  		String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  		PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  		pstmtN.setString(1,"");    
	  		pstmtN.setString(2,"");
	  		pstmtN.executeUpdate(); 
	  		pstmtN.close();
		  }
		  else
		  { 			    
    		//insert into INV_M_HIST 庫存異動歷史檔
   			String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
   			PreparedStatement pstmtH=con.prepareStatement(sqlH); 
   			pstmtH.setString(1,Whs);
   			pstmtH.setString(2,Loc); 
   			pstmtH.setString(3,Item);
   			pstmtH.setInt(4,newQty); 
   			pstmtH.setString(5,"I");
			pstmtH.setString(6,rsH.getString("ISSPROJCODE"));
   			pstmtH.setString(7,rsH.getString("REMARK")); 
   			pstmtH.setString(8,userID); 
   			pstmtH.setInt(9,iDate);
   			pstmtH.setString(10,rsH.getString("ISSCREATENO"));      
  
   			pstmtH.executeUpdate();
			pstmtH.close();
	
			//insert into INV_M_REM 庫存餘額檔
			String sqlR = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";
			Statement stateR=con.createStatement();
			ResultSet rsR=stateR.executeQuery(sqlR);
			if (rsR.next())
			{
				oriQty = rsR.getInt("REMQTY");
		
   				String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";
   				PreparedStatement pstmtU=con.prepareStatement(sqlU); 
				nowQty = oriQty - newQty;
   				pstmtU.setInt(1,nowQty);    
  
   				pstmtU.executeUpdate(); 
   				pstmtU.close();	
			}
			rsR.close();
			stateR.close();	
		  }	
		  rsQ.close(); 
		  stateQ.close();				
		}
		rsL.close(); 
		stateL.close();	
	  } 
	  rsW.close(); 
	  stateW.close();
	}
   	rsC.close(); 
	stateC.close();
   }//end of while
   
  //不管資料是否有錯，都要執行下面程式 
  //if (ChkFlag != "NG")
  //{
    //insert into INV_M_ISS 領料單主檔
    String sql1="update INV_M_ISS set ISSSTATID=?,ISSSTAT=? where ISSCREATENO='"+ISSCREATENO+"'";
    PreparedStatement pstmt1=con.prepareStatement(sql1); 
    pstmt1.setString(1,"005");  
    pstmt1.setString(2,"ISSUING"); //   
    
    pstmt1.executeUpdate(); 
    pstmt1.close();

	//insert into INV_M_HISTORY 流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,ISSCREATENO); 
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
    out.println("Processing ISS OK!<BR>");	
  //}
  out.println("<A HREF='/wins/jsp/INVIssStatus.jsp?STATUSID=004&PAGEURL=INVIssPage.jsp'>回領料案件處理</A>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");
     
  statement.close(); 
  rsH.close(); 
  arrayCheckInputBoxBean.setArray2DString(null);
  }  
  
   //批次領料單簽核同意 
  else if(actionID.equals("003") && fromStatusID.equals("011")) 
  {    
   //扣庫存
   String sSqlH = "select a.ISSCREATENO,a.ISSITEMNOACT,a.ISSQTYACT,a.ISSWHS,a.ISSLOC,b.ISSPROJCODE,c.REMARK "+
                  " from INV_M_IDTL a,INV_M_ISS b,INV_M_HISTORY c "+
				  " where a.ISSCREATENO='"+ISSCREATENO+"' and a.ISSCREATENO=b.ISSCREATENO and a.ISSCREATENO=c.RECCREATENO "+
				  " and c.STATUSID='010' and ISSWHS is not null and ISSLOC is not null";
   Statement statement=con.createStatement();
   ResultSet rsH=statement.executeQuery(sSqlH);
   while (rsH.next())
   {   
    iDate = Integer.parseInt(sDate);
	Item = rsH.getString("ISSITEMNOACT");	
	Whs = rsH.getString("ISSWHS");
	Loc = rsH.getString("ISSLOC");	
	newQty = rsH.getInt("ISSQTYACT"); 

	String sqlC = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' ";		 
    Statement stateC=con.createStatement();
    ResultSet rsC=stateC.executeQuery(sqlC); 
    if (rsC.next()==false)
	{
	  ChkFlag = "NG";
	  out.println("料號："+Item+"不存在!<BR>");
	  //將不正確的料號之WHS、LOC Update 為空白
	  String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  pstmtN.setString(1,"");    
	  pstmtN.setString(2,"");
	  pstmtN.executeUpdate(); 
	  pstmtN.close();
	}
	else
	{
	  String sqlW = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' ";		 
      Statement stateW=con.createStatement();
      ResultSet rsW=stateC.executeQuery(sqlW); 
      if (rsW.next()==false)
	  {
	    ChkFlag = "NG";
		out.println("料號："+Item+"不存在此倉別!<BR>");
		//將不正確的料號之WHS、LOC Update 為空白
	  	String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  	PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  	pstmtN.setString(1,"");    
	  	pstmtN.setString(2,"");
	  	pstmtN.executeUpdate(); 
	  	pstmtN.close();
 	  }
	  else
	  {
    	String sqlL = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";		 
    	Statement stateL=con.createStatement();
    	ResultSet rsL=stateC.executeQuery(sqlL); 
    	if (rsL.next()==false)
		{
		  ChkFlag = "NG";
		  out.println("料號："+Item+"不存在此架位!<BR>");
		  //將不正確的料號之WHS、LOC Update 為空白
	  	  String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  	  PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  	  pstmtN.setString(1,"");    
	  	  pstmtN.setString(2,"");
	  	  pstmtN.executeUpdate(); 
	  	  pstmtN.close();
		}
		else			
		{		
		  String sqlQ = "select REMITEMNO from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' and REMQTY>="+newQty+" ";
		  //out.println(sqlQ);		 
    	  Statement stateQ=con.createStatement();
    	  ResultSet rsQ=stateC.executeQuery(sqlQ); 
    	  if (rsQ.next()==false)
		  {
		    ChkFlag = "NG";
		    out.println("<font color='#FF0000' size='5'><strong>料號："+Item+"庫存不足!</strong></font><BR>");
			//將不正確的料號之WHS、LOC Update 為空白
	  		String sqlN="update INV_M_IDTL set ISSWHS=?,ISSLOC=? where ISSCREATENO = '"+ISSCREATENO+"' and ISSITEMNO = '"+Item+"' ";
	  		PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  		pstmtN.setString(1,"");    
	  		pstmtN.setString(2,"");
	  		pstmtN.executeUpdate(); 
	  		pstmtN.close();
		  }
		  else
		  { 			    
    		//insert into INV_M_HIST 庫存異動歷史檔
   			String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
   			PreparedStatement pstmtH=con.prepareStatement(sqlH); 
   			pstmtH.setString(1,Whs);
   			pstmtH.setString(2,Loc); 
   			pstmtH.setString(3,Item);
   			pstmtH.setInt(4,newQty); 
   			pstmtH.setString(5,"I");
			pstmtH.setString(6,rsH.getString("ISSPROJCODE"));
   			pstmtH.setString(7,rsH.getString("REMARK")); 
   			pstmtH.setString(8,userID); 
   			pstmtH.setInt(9,iDate);
   			pstmtH.setString(10,rsH.getString("ISSCREATENO"));      
  
   			pstmtH.executeUpdate();
			pstmtH.close();
	
			//insert into INV_M_REM 庫存餘額檔
			String sqlR = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";
			Statement stateR=con.createStatement();
			ResultSet rsR=stateR.executeQuery(sqlR);
			if (rsR.next())
			{
				oriQty = rsR.getInt("REMQTY");
		
   				String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+Item+"' and REMWHS='"+Whs+"' and REMLOC='"+Loc+"' ";
   				PreparedStatement pstmtU=con.prepareStatement(sqlU); 
				nowQty = oriQty - newQty;
   				pstmtU.setInt(1,nowQty);    
  
   				pstmtU.executeUpdate(); 
   				pstmtU.close();	
			}
			rsR.close();
			stateR.close();	
		  }	
		  rsQ.close(); 
		  stateQ.close();				
		}
		rsL.close(); 
		stateL.close();	
	  } 
	  rsW.close(); 
	  stateW.close();
	}
   	rsC.close(); 
	stateC.close();
   }//end of while
  
  //不管資料是否有錯，都要執行下面程式 
  //if (ChkFlag != "NG")
  //{
    //insert into INV_M_ISS 領料單主檔
    String sql1="update INV_M_ISS set ISSSTATID=?,ISSSTAT=? where ISSCREATENO='"+ISSCREATENO+"'";
    PreparedStatement pstmt1=con.prepareStatement(sql1); 
    pstmt1.setString(1,"012");  
    pstmt1.setString(2,"ISSUING"); //   
    
    pstmt1.executeUpdate(); 
    pstmt1.close();

	//insert into INV_M_HISTORY 流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,ISSCREATENO); 
  	historystmt.setString(2,"012"); 
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
    out.println("Processing ISS OK!<BR>");	
  //}
  out.println("<A HREF='/wins/jsp/INVBatchIssStatus.jsp?STATUSID=011&PAGEURL=INVBatchIssPage.jsp'>回批次領料案件處理</A>");
  out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");
     
  statement.close(); 
  rsH.close(); 
  arrayCheckInputBoxBean.setArray2DString(null);
  }    
  else if(actionID.equals("004") && fromStatusID.equals("002"))//入庫單簽核批退
  {
   String sql2="update INV_M_REC set RECSTATID=?,RECSTAT=? where RECCREATENO='"+RECCREATENO+"'";
   PreparedStatement pstmt2=con.prepareStatement(sql2); 
 
   pstmt2.setString(1,"007");  
   pstmt2.setString(2,"DISAPPROVAL"); //   
    
   pstmt2.executeUpdate(); 
   pstmt2.close();
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,RECCREATENO); 
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
	
   arrayCheckInputBoxBean.setArray2DString(null);
	   
   out.print("倉管簽核不同意"+"<br>");
   out.println("Processing INV OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVRecStatus.jsp?STATUSID=002&PAGEURL=INVRecPage.jsp'>回入庫案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");     
  } 
  else if(actionID.equals("004") && fromStatusID.equals("004"))//領料單簽核批退
  {
   String sql2="update INV_M_ISS set ISSSTATID=?,ISSSTAT=? where ISSCREATENO='"+ISSCREATENO+"'";
   PreparedStatement pstmt2=con.prepareStatement(sql2); 
 
   pstmt2.setString(1,"008");  
   pstmt2.setString(2,"DISAPPROVAL"); //   
    
   pstmt2.executeUpdate(); 
   pstmt2.close();
   
	//insert into INV_M_HISTORY 入庫單流程歷史檔
    String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
  
 	PreparedStatement historystmt=con.prepareStatement(historySql);  
 
  	historystmt.setString(1,ISSCREATENO); 
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
	 arrayCheckInputBoxBean.setArray2DString(null);  
	 
   out.print("倉管簽核不同意"+"<br>");
   
   out.println("Processing ISS OK!<BR>");
   out.println("<A HREF='/wins/jsp/INVIssStatus.jsp?STATUSID=004&PAGEURL=INVIssPage.jsp'>回領料案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");   

  } 
} // end if (chooseFeatures!=null)
else { 
	out.println("<font color='#FF0000' size='5'><strong>沒有傳入資料!</strong></font><BR>"); 
   out.println("<A HREF='/wins/jsp/INVIssStatus.jsp?STATUSID=004&PAGEURL=INVIssPage.jsp'>回領料案件處理</A>");
   out.println("<A HREF='/wins/WinsMainMenu.jsp'>回首頁</A>");   
} // end else
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}


%>

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
