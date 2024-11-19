<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile</title>
<%@ page import="com.jspsmart.upload.*,ArrayCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<body>

<%
   try
   { 	
	   	 int iNew=0;//發料數量	      
	  String strDateTime =dateBean.getYearMonthDay();
	  String itemcreateNo="";
	  String itemcreateNo1 = "00001";
	  String sDate = dateBean.getYearMonthDay();
	  	 int iDate = 0;
	  String sNew = "N"; //記錄是否為當日第一筆資料
	  	 int iSeq = 0;
	
	  String formID=request.getParameter("FORMID");
	  String fromStatusID=request.getParameter("FROMSTATUSID");		
	  String actionID=request.getParameter("ACTIONID");
	  String project=request.getParameter("PROJECT");
	  String remark=request.getParameter("REMARK");		

	  String actionName="";
	  String oriStatus="";
	
	  String [][] chooseFeatures=arrayCheckBoxBean.getArray2DContent();
        
	  String sqlS = "select trim(to_char(SEQMAX+1,'00000')) ITEMCREATENO from INV_SEQ ";
	  String sWhere = " where SEQTYPE='I' and SEQDATE='"+strDateTime+"' ";		 
	  sqlS = sqlS+sWhere;
	  Statement stateS=con.createStatement();
	  ResultSet rsS=stateS.executeQuery(sqlS);
	  if (rsS.next()==false)
	  { itemcreateNo1 = "00001";
		sNew = "Y";
	  }
	  else
	  { 
		itemcreateNo1 = rsS.getString("ITEMCREATENO");			
		sNew = "N";	 
		if (itemcreateNo1==null || itemcreateNo1.equals(""))
		{
		  itemcreateNo1 = "00001";
		}
	  }  
	  rsS.close();
	  stateS.close();
	  
	  itemcreateNo = "I" + strDateTime + itemcreateNo1;  //取得新的單號
	  iDate = Integer.parseInt(sDate);
	  iSeq = Integer.parseInt(itemcreateNo1);
 	  
	  //////寫入INV_SEQ
	  if (sNew=="Y")
	  {
		String sqlN="insert into INV_SEQ(SEQTYPE,SEQDESC,SEQDATE,SEQMAX) values(?,?,?,?)";
		PreparedStatement pstmtN=con.prepareStatement(sqlN);  
		pstmtN.setString(1,"I");
		pstmtN.setString(2,"領料"); 
		pstmtN.setString(3,sDate);
		pstmtN.setInt(4,iSeq);   
	  
		pstmtN.executeUpdate(); 
		pstmtN.close(); 
	  }
	  else
	  {
		String sqlN="update INV_SEQ set SEQMAX = '"+iSeq+"' where SEQTYPE = 'I' and SEQDATE = '"+sDate+"' ";
		PreparedStatement pstmtN=con.prepareStatement(sqlN);  
	  
		pstmtN.executeUpdate();   
		pstmtN.close(); 
	  }  
	  	  
	  
	  //////取得STATUSID、STATUSNAME		
	   String TOSTATUSID="";  
	   String STATUSNAME=""; 
   	   
	   String sqlGet = "select TOSTATUSID,STATUSNAME from WSWORKFLOW x1,WSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID";  
	   Statement getStatusStat=con.createStatement();
	   ResultSet getStatusRs=getStatusStat.executeQuery(sqlGet);

	   if (getStatusRs.next()==false)
	   {}
	   else
	   { 
		TOSTATUSID = getStatusRs.getString("TOSTATUSID");			
		STATUSNAME = getStatusRs.getString("STATUSNAME");			
	   }  
	   getStatusRs.close();
	   getStatusStat.close();   
	
	  //////寫入INV_M_ISS
		 String commSql="insert into INV_M_ISS(IssCreateNo,IssProjCode,IssStatId,IssStat,IssCreateUser,IssCreateDate,IssCenterNo) values(?,?,?,?,?,?,?)";
		 PreparedStatement commStmt=con.prepareStatement(commSql);
		 commStmt.setString(1,itemcreateNo); 
		 commStmt.setString(2,project);
		 commStmt.setString(3,TOSTATUSID); 
		 commStmt.setString(4,STATUSNAME);	
		 commStmt.setString(5,userID);
		 commStmt.setInt(6,iDate);	
		 commStmt.setString(7,userActCenterNo); //寫入Center編號	   
		 commStmt.executeUpdate();       
		 commStmt.close();

	  //////寫入INV_M_IDTL
    	if (chooseFeatures!=null && chooseFeatures.length>0)
    	{      
          for (int i=0;i<chooseFeatures.length;i++)
          {         
			 if (chooseFeatures[i][0]!=null && !chooseFeatures[i][0].equals(""))
			 {
				 iNew = Integer.parseInt(chooseFeatures[i][1]);
				 String sSql="insert into INV_M_IDTL(IssCreateNo,IssItemNo,IssQty,IssItemNOAct,IssQtyAct,IssWhs,IssLoc) values(?,?,?,?,?,?,?)";
				 PreparedStatement sStmt=con.prepareStatement(sSql);
				 sStmt.setString(1,itemcreateNo); 
				 sStmt.setString(2,chooseFeatures[i][0]);
				 sStmt.setInt(3,iNew); 
				 sStmt.setString(4,chooseFeatures[i][0]);
				 sStmt.setInt(5,iNew); 	
				 sStmt.setString(6,""); 
				 sStmt.setString(7,"");	
				 sStmt.executeUpdate();       
				 sStmt.close();
			 }
		  } //end of for			
	    }//end of if

	  //////寫入INV_M_HISTORY
	   Statement statement=con.createStatement();
	   ResultSet rs=statement.executeQuery("select * from WSWFACTION where ACTIONID='"+actionID+"'");
	   rs.next();
	   actionName=rs.getString("ACTIONNAME");
	   
	   rs=statement.executeQuery("select * from WSWFStatus where STATUSID='"+fromStatusID+"'");
	   rs.next();
	   oriStatus=rs.getString("STATUSNAME");
	   
	   statement.close();
	   rs.close();
		 
	  String historySql="insert into INV_M_HISTORY(RECCREATENO,STATUSID,STATUSNAME,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CENTERNO,REMARK) values(?,?,?,?,?,?,?,?,?,?)";
	  
	  PreparedStatement historystmt=con.prepareStatement(historySql);  
	 
	  historystmt.setString(1,itemcreateNo); 
	  historystmt.setString(2,fromStatusID); 
	  historystmt.setString(3,oriStatus); //寫入status名稱
	  historystmt.setString(4,actionID); 
	  historystmt.setString(5,actionName); 
	  historystmt.setString(6,userID); 
	  historystmt.setString(7,dateBean.getYearMonthDay()); 
	  historystmt.setString(8,dateBean.getHourMinuteSecond());
	  historystmt.setString(9,userActCenterNo); //寫入Center編號
	  historystmt.setString(10,remark);
	  
	  historystmt.executeUpdate();   
	  historystmt.close();   
	  
	  out.println("領料單新增 OK!! <BR><BR><BR>領料單號:"+itemcreateNo+"<BR>User:"+userID+"<BR>Date:"+iDate+"<BR><BR><BR>");
	  out.println("<A HREF=../jsp/INVBatchIss.jsp>批次領料單新增<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>HOME</A>");  
		
			  
   } //end of try
   catch (Exception e)
   {
	out.println("Exception:"+e.getMessage());
   }
%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
