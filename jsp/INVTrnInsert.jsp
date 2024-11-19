<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TrnInsert.jsp</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean,ArrayCheckBoxBean" %>
</head>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<body>

	<%

	    String [][] chooseFeatures_=arrayCheckBoxBean.getArray2DContent();
		String project=request.getParameter("PROJECT");
	    String remark=request.getParameter("REMARK");
		
		String strDateTime =dateBean.getYearMonthDay();
		String itemcreateNo="";
		String itemcreateNo1 = "00001";
		String sDate = dateBean.getYearMonthDay();
		int iDate = 0;
		//String UserID = "B02260";
		//String UserName ="MARK CHEN";
		String sNew = "N"; //記錄是否為當日第一筆資料
		int iSeq = 0;
		
	    String formID=request.getParameter("FORMID");
	    String fromStatusID=request.getParameter("FROMSTATUSID");		
   	    String actionID=request.getParameter("ACTIONID");		
		
		String actionName=null;
		String oriStatus=null;
		String CenterNo=null;
		
        int iQty = 0;
        int iQtyAct = 0;		
	
	    String item1=request.getParameter("ITEM1");
	    String whs1=request.getParameter("WHS1");		
   	    String loc1=request.getParameter("LOC1");		
   	    //String qty1=request.getParameter("QTY1");		
	    String item2=request.getParameter("ITEM2");
	    String whs2=request.getParameter("WHS2");		
   	    String loc2=request.getParameter("LOC2");		
   	    //String qty2=request.getParameter("QTY2");
	    String item3=request.getParameter("ITEM3");
	    String whs3=request.getParameter("WHS3");		
   	    String loc3=request.getParameter("LOC3");		
   	    //String qty3=request.getParameter("QTY3");
		String item4=request.getParameter("ITEM4");
	    String whs4=request.getParameter("WHS4");		
   	    String loc4=request.getParameter("LOC4");		
   	    //String qty4=request.getParameter("QTY4");				
	    String item5=request.getParameter("ITEM5");
	    String whs5=request.getParameter("WHS5");		
   	    String loc5=request.getParameter("LOC5");		
   	    //String qty5=request.getParameter("QTY5");
	    String item6=request.getParameter("ITEM6");
	    String whs6=request.getParameter("WHS6");		
   	    String loc6=request.getParameter("LOC6");		
   	    String qty6=request.getParameter("QTY6");		
	    String item7=request.getParameter("ITEM7");
	    String whs7=request.getParameter("WHS7");		
   	    String loc7=request.getParameter("LOC7");		
   	    String qty7=request.getParameter("QTY7");
	    String item8=request.getParameter("ITEM8");
	    String whs8=request.getParameter("WHS8");		
   	    String loc8=request.getParameter("LOC8");		
   	    String qty8=request.getParameter("QTY8");
		String item9=request.getParameter("ITEM9");
	    String whs9=request.getParameter("WHS9");		
   	    String loc9=request.getParameter("LOC9");		
   	    String qty9=request.getParameter("QTY9");				
	    String item10=request.getParameter("ITEM10");
	    String whs10=request.getParameter("WHS10");		
   	    String loc10=request.getParameter("LOC10");		
   	    String qty10=request.getParameter("QTY10");		
		String ChkFlag = "";
		//String item = "";
		//String whs = "";
		//String loc = "";
		//String qty = "";
		//String itemN = "";
		//String whsN = "";
		//String locN = "";
		int oriQty=0;
		int nowQty=0;	
		int qtyT=0;	
		int qtyN=0;
					
 try
 {     
    String sqlS = "select trim(to_char(SEQMAX+1,'00000')) ITEMCREATENO from INV_SEQ ";
    String sWhere = " where SEQTYPE='T' and SEQDATE='"+strDateTime+"' ";		 
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
  
  	itemcreateNo = "T" + strDateTime + itemcreateNo1;  //取得新的shippNo
  	//out.println(itemcreateNo); 
  	iDate = Integer.parseInt(sDate);
  	//out.println(iDate);
  	iSeq = Integer.parseInt(itemcreateNo1);
	 
    for (int i=1;i<6;i++)
    { //out.println("Step2:");
	  int j = i + 5;
	  String item=request.getParameter("ITEM"+i);
	  String whs=request.getParameter("WHS"+i);
	  String loc=request.getParameter("LOC"+i);
	  String itemN=request.getParameter("ITEM"+j);
	  String whsN=request.getParameter("WHS"+j);
	  String locN=request.getParameter("LOC"+j);
	  String qty=request.getParameter("QTY"+j);	  
	  
	  //out.println(item);
	  if (item==null || item.equals(""))
	  {}
	  else
	  {
	    if (itemN==null || itemN.equals(""))
		{
		  out.println("轉出(From)料號："+item+",請輸入轉入(To)料號!<BR>");
		  ChkFlag = "NG";
		}
		else
		{		   
    	  String sqlC = "select REMITEMNO from INV_M_REM where REMITEMNO='"+item+"' ";		 
    	  Statement stateC=con.createStatement();
    	  ResultSet rsC=stateC.executeQuery(sqlC); 
    	  if (rsC.next()==false)
		  {
		    out.println("轉出料號："+item+"不存在!<BR>");
			ChkFlag = "NG";
	  	  }	
		  else
		  {
    	    String sqlW = "select REMITEMNO from INV_M_REM where REMITEMNO='"+item+"' and REMWHS='"+whs+"' ";		 
    	    Statement stateW=con.createStatement();
    	    ResultSet rsW=stateC.executeQuery(sqlW); 
    	    if (rsW.next()==false)
		    {
			  out.println("轉出料號："+item+"不存在此倉別!<BR>");
			  ChkFlag = "NG";
			}
		    else
			{
    	      String sqlL = "select REMITEMNO from INV_M_REM where REMITEMNO='"+item+"' and REMWHS='"+whs+"' and REMLOC='"+loc+"' ";		 
    	      Statement stateL=con.createStatement();
    	      ResultSet rsL=stateC.executeQuery(sqlL); 
    	      if (rsL.next()==false)
		      {
			    out.println("轉出料號："+item+"不存在此架位!<BR>");
				ChkFlag = "NG";
			  }
		      else			
		      {		  
			    //String sqlQ = "select REMITEMNO from INV_M_REM where REMITEMNO='"+item+"' and REMWHS='"+whs+"' and REMLOC='"+loc+"' and REMQTY>0 ";		 
    	        //Statement stateQ=con.createStatement();
    	  	    //ResultSet rsQ=stateC.executeQuery(sqlQ); 
    	  		//if (rsQ.next()==false)
		  		//{out.println("轉出料號："+item+"無庫存!<BR>");}
		  		//else
		  		//{ 	
					qtyT=Integer.parseInt(qty);
					String sqlA = "select REMITEMNO from INV_M_REM where REMITEMNO='"+item+"' and REMWHS='"+whs+"' and REMLOC='"+loc+"' and REMQTY>='"+qtyT+"' ";		 
					Statement stateA=con.createStatement();
					ResultSet rsA=stateA.executeQuery(sqlA); 
					if (rsA.next()==false)
					{
					  out.println("轉出料號："+item+"庫存不足!<BR>");
					  ChkFlag = "NG";
					}
					else
					{												  			  
					    /*
						out.println(itemcreateNo);
						out.println(item);
						out.println(itemN);
						out.println(whs);	
						out.println(whsN);	
						out.println(loc);							
						out.println(locN);	
						out.println(qtyT);													  				  
					    */
								  
				   }//end of rsA
				   rsA.close();
				   stateA.close();	  			  				  	  
				//}//end of rsQ
			   //rsQ.close(); 
		       //stateQ.close();				
			 }//end of rsL
			 rsL.close(); 
		     stateL.close();	
		   }//end of rsW 
		   rsW.close(); 
		   stateW.close();
		 }//end of rsC
   		 rsC.close(); 
		 stateC.close();
	   }//end of if (check 轉出料號 null)
	 } //end of if (check 轉入料號 null)
    } //end of for
	
  if (ChkFlag != "NG")	
  {
    for (int i=1;i<6;i++)
    { //out.println("Step2:");
	  int j = i + 5;
	  String item=request.getParameter("ITEM"+i);
	  String whs=request.getParameter("WHS"+i);
	  String loc=request.getParameter("LOC"+i);
	  String itemN=request.getParameter("ITEM"+j);
	  String whsN=request.getParameter("WHS"+j);
	  String locN=request.getParameter("LOC"+j);
	  String qty=request.getParameter("QTY"+j);
	  
	  if (item==null || item.equals(""))
	  {}	  
	  else
	  {
		  //////寫入INV_M_TDTL
		  String sSql="insert into INV_M_TDTL(TRNCREATENO,TRNITEMNOFR,TRNITEMNOTO,TRNWHSFR,TRNWHSTO,TRNLOCFR,TRNLOCTO,TRNQTY) values(?,?,?,?,?,?,?,?)";
		  PreparedStatement sStmt=con.prepareStatement(sSql);
		  sStmt.setString(1,itemcreateNo); 
		  sStmt.setString(2,item);
		  sStmt.setString(3,itemN); 
		  sStmt.setString(4,whs);
		  sStmt.setString(5,whsN); 	
		  sStmt.setString(6,loc); 
		  sStmt.setString(7,locN);	
		  sStmt.setInt(8,qtyT);		 
		  sStmt.executeUpdate();       
		  sStmt.close();
	
		  //insert into INV_M_HIST 庫存異動歷史檔 -- 轉出
		  qtyN=(qtyT*(-1));
		  String sqlH="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
		  PreparedStatement pstmtH=con.prepareStatement(sqlH); 
		  pstmtH.setString(1,whs);
		  pstmtH.setString(2,loc); 
		  pstmtH.setString(3,item);
		  pstmtH.setInt(4,qtyN); 
		  pstmtH.setString(5,"T");
		  pstmtH.setString(6,project);
		  pstmtH.setString(7,remark); 
		  pstmtH.setString(8,userID); 
		  pstmtH.setInt(9,iDate);
		  pstmtH.setString(10,itemcreateNo);      
		
		  pstmtH.executeUpdate();
		  pstmtH.close();
	
		  //insert into INV_M_HIST 庫存異動歷史檔 -- 轉入
		  String sqlD="insert into INV_M_HIST(HISTWHS,HISTLOC,HISTITEMNO,HISTQTY,HISTTYPE,HISTPROJCODE,HISTCOM,HISTCREATEUSER,HISTCREATEDATE,HISTCREATENO) values(?,?,?,?,?,?,?,?,?,?)";
		  PreparedStatement pstmtD=con.prepareStatement(sqlD); 
		  pstmtD.setString(1,whsN);
		  pstmtD.setString(2,locN); 
		  pstmtD.setString(3,itemN);
		  pstmtD.setInt(4,qtyT); 
		  pstmtD.setString(5,"T");
		  pstmtD.setString(6,project);
		  pstmtD.setString(7,remark); 
		  pstmtD.setString(8,userID); 
		  pstmtD.setInt(9,iDate);
		  pstmtD.setString(10,itemcreateNo);      
		
		  pstmtD.executeUpdate();
		  pstmtD.close();
								  
		  //update INV_M_REM 庫存餘額檔 -- 轉出
		  String sqlM = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+item+"' and REMWHS='"+whs+"' and REMLOC='"+loc+"'";
		  Statement stateM=con.createStatement();
		  ResultSet rsM=stateM.executeQuery(sqlM);
		  //out.println(sqlM);
		  if (rsM.next())
		  {
			oriQty = rsM.getInt("REMQTY");
	
			String sqlU="update INV_M_REM set REMQTY=? where REMITEMNO='"+item+"' and REMWHS='"+whs+"' and REMLOC='"+loc+"' ";
			PreparedStatement pstmtU=con.prepareStatement(sqlU); 
			//out.println(sqlU);
			nowQty = oriQty - qtyT;
			//out.println(nowQty);
			//out.println(item);
			//out.println(whs);	
			//out.println(loc);				   					
			pstmtU.setInt(1,nowQty);    
	
			pstmtU.executeUpdate(); 
			pstmtU.close();	
		  }//end of rsM
		  rsM.close();
		  stateM.close();			
		  
		  //update INV_M_REM 庫存餘額檔 -- 轉入
		  String sqlT = "select REMITEMNO,REMQTY from INV_M_REM where REMITEMNO='"+itemN+"' and REMWHS='"+whsN+"' and REMLOC='"+locN+"' ";		 
		  Statement stateT=con.createStatement();
		  ResultSet rsT=stateT.executeQuery(sqlT); 
		  if (rsT.next()==false)
		  {
			String sqlI="insert into INV_M_REM(REMWHS,REMLOC,REMITEMNO,REMQTY) values(?,?,?,?)";
			PreparedStatement pstmtI=con.prepareStatement(sqlI); 
			//out.println(sqlI); 
			pstmtI.setString(1,whsN);
			pstmtI.setString(2,locN); 
			pstmtI.setString(3,itemN);
			pstmtI.setInt(4,qtyT);     
	
			pstmtI.executeUpdate();
			pstmtI.close();					  
		  }
		  else
		  {
			oriQty = rsT.getInt("REMQTY");
	
			String sqlU1="update INV_M_REM set REMQTY=? where REMITEMNO='"+itemN+"' and REMWHS='"+whsN+"' and REMLOC='"+locN+"' ";
			PreparedStatement pstmtU1=con.prepareStatement(sqlU1); 
			//out.println(sqlU);
			nowQty = oriQty + qtyT;
			//out.println(nowQty);
			pstmtU1.setInt(1,nowQty);    
	
			pstmtU1.executeUpdate(); 
			pstmtU1.close();		
		  }//end of rsT
		  rsT.close();
		  stateT.close();				  
		} //end of for	 
	}//end of if
	   
  	//////寫入INV_SEQ
  	if (sNew=="Y")
  	{
      String sqlN="insert into INV_SEQ(SEQTYPE,SEQDESC,SEQDATE,SEQMAX) values(?,?,?,?)";
      PreparedStatement pstmtN=con.prepareStatement(sqlN);  
      pstmtN.setString(1,"T");
      pstmtN.setString(2,"轉撥"); 
      pstmtN.setString(3,sDate);
      pstmtN.setInt(4,iSeq);   
  
      pstmtN.executeUpdate();  
  	}
    else
  	{
      String sqlN="update INV_SEQ set SEQMAX = '"+iSeq+"' where SEQTYPE = 'T' and SEQDATE = '"+sDate+"' ";
      PreparedStatement pstmtN=con.prepareStatement(sqlN);  
  
      pstmtN.executeUpdate();    
  	}  
  	//////取得STATUSID、STATUSNAME
    
   	String TOSTATUSID="";  
   	String STATUSNAME="";  
   
   	String sqlGet = "select TOSTATUSID,STATUSNAME from WSWORKFLOW x1,WSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID";  
   	Statement getStatusStat=con.createStatement();
   	ResultSet getStatusRs=getStatusStat.executeQuery(sqlGet);
   	//out.println(sqlGet);
   	//out.println(formID);
   	//out.println(STATUSNAME); 
   	if (getStatusRs.next()==false)
   	{}
   	else
   	{ 
 	  TOSTATUSID = getStatusRs.getString("TOSTATUSID");			
 	  STATUSNAME = getStatusRs.getString("STATUSNAME");			
   	}  
    getStatusRs.close();
   	getStatusStat.close();   

  	//////寫入INV_M_TRN
    String commSql="insert into INV_M_TRN(TrnCreateNo,TrnProjCode,TrnStatId,TrnStat,TrnCreateUser,TrnCreateDate,TrnCenterNo) values(?,?,?,?,?,?,?)";
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
  
  	out.println("移轉 OK!! <BR><BR><BR>移轉單號:"+itemcreateNo+"<BR>User:"+userID+"<BR>Date:"+iDate+"<BR><BR><BR>");
  }//end of ChkFlag = "OK";	
 	out.println("<A HREF=../jsp/INVTrnInput.jsp>移轉單新增<BR><BR></A><A HREF=/wins/WinsMainMenu.jsp>HOME</A>");  
    
		  
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
