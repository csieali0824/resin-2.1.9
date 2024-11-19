<!-- 20080107 Liling 增加移站後將正確的seq_num,id等資訊回寫yew_runcard_all -->
<!-- 20090426 Liling 增加移站後將正確資訊回寫yew_runcard_restxn / yew_runcard_transaction -->
<!-- 20090426 Liling 修正前頁帶來的 Transaction 改為 transDatea 加上系統時間移站 -->
<!-- 20200821 Liling FOR WMS  工單推to move不再執行完工入庫 -->

<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="oracle.sql.*,oracle.jdbc.driver.*,DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Move Transaction Interface Commit</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
</head>
<%  
    out.println("<A HREF='../ORADDSMainMenu.jsp'>");%><font size="2">回首頁</font><%out.println("</A>");
	out.println("&nbsp;&nbsp;<A HREF='../jsp/TSCMfgMovePending.jsp'>");%><font size="2">管理員Pending Move處理</font><%out.println("</A>");

    String woNo=request.getParameter("WO_NO");   //工單號
    String wipEntityId=request.getParameter("WIP_ENTITY_ID");  //工單ID
    String runCardNo=request.getParameter("RUNCARD_NO");       //流程卡號
	String fmIntOpSType=request.getParameter("FMINTOPSTYPE");
	String toIntOpSType=request.getParameter("TOINTOPSTYPE");
	String fmOpSeqNum=request.getParameter("FMOPERSEQNO");
	String toOpSeqNum=request.getParameter("TOOPERSEQNO");
	String transQty=request.getParameter("TRANSQTY");
	String transUom=request.getParameter("TRANSUOM");
	String lotNo=request.getParameter("LOT_NO"); // 後段外購工令批號
    String transDatea=request.getParameter("TRANSDATE");
	
	   
	  // 
	String organizationId=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");
	String oeOrderNo=request.getParameter("OEORDERNO");
	String oeHeaderId=request.getParameter("OEHEADERID");
	String orderLineId=request.getParameter("OELINEID");
	
	String delErrIFace=request.getParameter("DELERRIFACE");
	
	// 批號新增
	String insertLot=request.getParameter("INSERTLOT");
	String invItemLot=request.getParameter("INV_ITEM");
	String lotOrganId=request.getParameter("ORGANIZATION_ID");
	String lotNumber=request.getParameter("LOT_NUMBER");
	String priTransQty=request.getParameter("PRIMARY_TRANSQTY");
	String lotWipEntity=request.getParameter("LOTWIPENTITY");
	
	// 庫存保留
	String invReservation=request.getParameter("RESERVATION");
	String resOrganId=request.getParameter("RES_ORGAN_ID");
	String reservationDate=request.getParameter("RES_DATE");
	String resInvItem=request.getParameter("RES_INVITEM");
	String resQty=request.getParameter("RES_QTY");
	String resLotNumber=request.getParameter("RES_LOT");
	String resOeHeaderId=request.getParameter("RES_OEHDRID");
	String resOeLineId=request.getParameter("RES_OELINEID");
	
	String User_ID=request.getParameter("USER_ID");
	
	String TransDate=request.getParameter("TRANSDATE");
	if (TransDate==null || TransDate.equals("")) TransDate=dateBean.getYearMonthDay();
	
	String strTransDate = "",sTime="";
	
    Statement stateTime=con.createStatement();
    ResultSet rsTime=stateTime.executeQuery("select to_char(sysdate,'HH24MISS') from dual ");
	if (rsTime.next())
	{
	   strTransDate = TransDate + rsTime.getString(1); 
       sTime =  rsTime.getString(1); 
	}
	rsTime.close();
	stateTime.close();

	
	//String strTransDate = TransDate + dateBean.getHourMinuteSecond();
	
	java.sql.Date transactionDate = new java.sql.Date(Integer.parseInt(TransDate.substring(0,4))-1900,Integer.parseInt(TransDate.substring(4,6))-1,Integer.parseInt(TransDate.substring(6,8)));  // 給transactionDate
				
	String statusID=request.getParameter("STATUSID");
	
	if (delErrIFace==null || delErrIFace.equals("")) delErrIFace = "I";
	
	if (insertLot==null || insertLot.equals("")) insertLot = "N";
	
	if (invReservation==null || invReservation.equals("")) invReservation = "N";
	
	if (User_ID!=null && !User_ID.equals("")) userMfgUserID = User_ID;  // 若有選擇特定的使用者執行移站則以使用者選定的ID 作移站
	
	                     // 取處理人員姓名
						 String fndUserName="";
	                     String sqlfnd = " select USER_NAME from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 									      " where A.USER_NAME = UPPER(B.USERNAME)  and to_char(A.USER_ID) = '"+userMfgUserID+ "'";
						 Statement stateFndId=con.createStatement();
                         ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 if (rsFndId.next())
						 {
						   fndUserName = rsFndId.getString("USER_NAME"); 
						 }
						 rsFndId.close();
						 stateFndId.close();
						
						 // 取Oraganization Code
						 String organCode ="";
	                     String organizationID = "";
						 String woUOM = "";
                         Statement stateOrgCode=con.createStatement();
	                     //out.println("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' ");
	                     ResultSet rsOrgCode=stateOrgCode.executeQuery("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID, b.WO_UOM from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
	                     if (rsOrgCode.next())
	                     {
	                      organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
	                      organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
						  woUOM = rsOrgCode.getString("WO_UOM");
						  //out.println("woUOM ="+woUOM);
	                     }
	                     rsOrgCode.close();
                         stateOrgCode.close();
   
                         // 取報廢Account ID
						 int scrpAccID = 0;
						 String sqlScrp = " select DEFAULT_SCRAP_ACCOUNT_ID from WIP_PARAMETERS_V  "+
 									      " where ORGANIZATION_ID = '"+organizationID+ "' ";										  
						 Statement stateScrp=con.createStatement();
                         ResultSet rsScrp=stateScrp.executeQuery(sqlScrp);
						 if (rsScrp.next())
						 {
						     scrpAccID = rsScrp.getInt(1);
						 }
						 rsScrp.close();
						 stateScrp.close();
						 
						// 取工令基本完工資訊 
						 int primaryItemID = 0;
						 String invItem="",compSubInventory="";
						 String sqlWO = " select INV_ITEM, INVENTORY_ITEM_ID, COMPLETION_SUBINVENTORY from YEW_WORKORDER_ALL  "+
 									    " where WIP_ENTITY_ID = '"+wipEntityId+ "' ";										  
						 Statement stateWO=con.createStatement();
                         ResultSet rsWO=stateWO.executeQuery(sqlWO);
						 if (rsWO.next())
						 {
						     invItem=rsWO.getString(1);
						     primaryItemID = rsWO.getInt(2);
							 compSubInventory=rsWO.getString(3);
						 }
						 rsWO.close();
						 stateWO.close();
						 
						 
						 
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%

 if (insertLot.equals("N") && invReservation.equals("N"))  // 不是LOT 新增且不是庫存保留,則執行移站或MMT等作業
 {
 
   if (delErrIFace.equals("I")) // 若是一般處理模式,則寫處理Move Iterface
   {
           //int toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
	 int transType = 1; // Transaction Type = 1(Move Transaction)
	 if (toIntOpSType.equals("5")) // 若是報廢
	 {		   
           String SqlScrap="insert into WIP_MOVE_TXN_INTERFACE( "+
				           "            CREATED_BY_NAME,  LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				           "            PROCESS_PHASE, PROCESS_STATUS,  TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				           "            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				           "            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
						   "            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID, CREATION_DATE, LAST_UPDATE_DATE, TRANSACTION_DATE ) "+
				           "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?, WIP_TRANSACTIONS_S.NEXTVAL,SYSDATE,SYSDATE, to_date('"+transDatea+"'||'"+sTime+"','yyyymmddhh24miss') ) ";   
						// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
           PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
           scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
          // seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
	      // seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
	       scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	      
		   scrapstmt.setFloat(7,Float.parseFloat(transQty)); //out.println("<BR>此站報廢數量="+rcScrapQty+"<BR>");// 移站報廢數量	       	   
           scrapstmt.setString(8,woUOM);
	       scrapstmt.setInt(9,Integer.parseInt(wipEntityId));  
	       scrapstmt.setString(10,woNo);  
	       scrapstmt.setInt(11,Integer.parseInt(fmIntOpSType)); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
		   //seqstmt.setInt(12,20);
	       scrapstmt.setInt(12,Integer.parseInt(fmOpSeqNum)); // FM_OPERATION_SEQ_NUM(本站)		  
	       scrapstmt.setInt(13,Integer.parseInt(toIntOpSType)); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       scrapstmt.setInt(14,Integer.parseInt(toOpSeqNum)); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
	       scrapstmt.setString(15,runCardNo);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		   scrapstmt.setInt(16,1);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)報廢 ( 01-11-000-7650-951-0-000 ) 
		   scrapstmt.setInt(18,7);	// REASON_ID  製程異常 		  
		   //scrapstmt.setDate(19,transactionDate);	// TransactionDate
           scrapstmt.executeUpdate();
           scrapstmt.close();	





	 } else {
	              String Sqlrc="insert into WIP_MOVE_TXN_INTERFACE( "+
				        "            CREATED_BY_NAME, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				        "            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				        "            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				        "            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID, CREATION_DATE, LAST_UPDATE_DATE, TRANSACTION_DATE ) "+
				        "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL, SYSDATE, SYSDATE, to_date('"+transDatea+"'||'"+sTime+"','yyyymmddhh24miss')) ";
				  PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
                  seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME                 
	              seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
                  seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	              seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	              seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
                  seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error   
		          seqstmt.setFloat(7,Float.parseFloat(transQty)); // 移站數量	       	   
                  seqstmt.setString(8,woUOM);
	              seqstmt.setInt(9,Integer.parseInt(wipEntityId));  
	              seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
	              seqstmt.setInt(11,Integer.parseInt(fmIntOpSType)); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP		        
	              seqstmt.setInt(12,Integer.parseInt(fmOpSeqNum)); // FM_OPERATION_SEQ_NUM(本站)		  
	              seqstmt.setInt(13,Integer.parseInt(toIntOpSType)); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	              seqstmt.setInt(14,Integer.parseInt(toOpSeqNum)); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
	              seqstmt.setString(15,runCardNo);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		          seqstmt.setInt(16,1);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
				  //seqstmt.setDate(17,transactionDate);	// TRANSACTION_DATE		    
                  seqstmt.executeUpdate();
                  seqstmt.close();		
			     
	 
	        } // End of else 報廢之外再區分,一般移站(1)或是完工(3)			
			            
						 int groupID = 0;
						 Statement stateFnd=con.createStatement();
                         ResultSet rsFnd=stateFnd.executeQuery("select WIP_TRANSACTIONS_S.CURRVAL from DUAL");
						 if (rsFnd.next())
						 {						   
						   groupID = rsFnd.getInt(1); 
						 }
						 rsFnd.close();
						 stateFnd.close(); 
			
			 CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			 cs5.setInt(1,groupID);                                         //  Org ID 	
			 cs5.setString(2,null);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
			 cs5.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			 cs5.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			 cs5.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			 cs5.execute();					      
			 String getMoveStatus = cs5.getString(4);		
			 String getMoveErrorMsg = cs5.getString(5);								      				    
			 cs5.close();	
			 
			 out.println("<BR>getMoveStatus ="+getMoveStatus+"<BR>");	
			 out.println("<BR>getMoveErrorMsg ="+getMoveErrorMsg+"<BR>");	
		
     String groupId = "0";	
	 String respID = ""; // 預設值為 YEW INV Super User 	 

//20200820 FOR WMS  工單推to move不再執行完工入庫	 
	 // 再區分,若是一般的移站,則只執行Move Transaction,否則再寫MMT , MT LOT, MT Reservation **************************************
/*
	 if (toIntOpSType.equals("3")) //Start of 完工入庫再寫入Material Transaction及Material LOT,如為後段工令,再寫Reservation Interface
	 {
	     if (lotNo==null || lotNo.equals("")) lotNo = runCardNo;
		 try
		 { //out.println("Step1. 寫入MMT Interface<BR>");	
		         
		   // -- 取此次MMT 的Transaction ID 作為Group ID
	              Statement stateMSEQ=con.createStatement();	             
	              ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
				  if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
				  rsMSEQ.close();
				  stateMSEQ.close();		 
				  
		  //out.println("Stepa.寫入MMT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
		  //out.println("Step supplierLotNo = "+supplierLotNo+"<BR>");	  
		  String sqlInsMMT = "insert into MTL_TRANSACTIONS_INTERFACE( "+
		                     "TRANSACTION_INTERFACE_ID, SOURCE_CODE, SOURCE_HEADER_ID, SOURCE_LINE_ID, PROCESS_FLAG, "+
							 "TRANSACTION_MODE, INVENTORY_ITEM_ID, ORGANIZATION_ID, SUBINVENTORY_CODE, TRANSACTION_QUANTITY, "+
							 "TRANSACTION_UOM, PRIMARY_QUANTITY, TRANSACTION_SOURCE_ID, TRANSACTION_TYPE_ID, "+
							 "WIP_ENTITY_TYPE, OPERATION_SEQ_NUM, LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, "+
							 "ATTRIBUTE1, ATTRIBUTE2, LOCK_FLAG, TRANSACTION_HEADER_ID, FINAL_COMPLETION_FLAG, VENDOR_LOT_NUMBER, TRANSACTION_SOURCE_TYPE_ID, TRANSACTION_DATE ) "+
							 " VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 'WIP', "+     // SOURCE_CODE,
							 " ?,?,1,"+                                                   // PROCESS_FLAG, --1 - Yes
							 " 2,"+                                                       // TRANSACTION_MODE,  --2 - Concurrent  ,3 - Background
							 " ?,?,?,?,?,?, "+                                    // TRANSACTION_DATE,
							 " ?,44, "+                                                   // TRANSACTION_TYPE_ID,    --44 WIP Assembly Completion
							 " 1, "+                                                      // WIP_ENTITY_TYPE,   --1 - Standard discrete jobs   3 - Non-standard
							 " ?,SYSDATE, "+                                              // LAST_UPDATE_DATE
							 " -1, "+                                                     // LAST_UPDATED_BY
							 " SYSDATE, "+                                                // CREATION_DATE
							 " ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',?, 5, to_date('"+transDatea+"'||'"+sTime+"','yyyymmddhh24miss')) ";     // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error可以重新被Repeocess)
		  PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
		  mmtStmt.setInt(1,Integer.parseInt(wipEntityId));   // SOURCE_HEADER_ID(Wip_Entity_id)
		  mmtStmt.setInt(2,Integer.parseInt(wipEntityId));	  // SOURCE_LINE_ID(Wip_Entity_id)
		  mmtStmt.setInt(3,primaryItemID);	              // INVENTORY_ITEM_ID 
		  mmtStmt.setInt(4,Integer.parseInt(organizationID));	  // ORGANIZATION_ID  
		  mmtStmt.setString(5,compSubInventory);	      // SUBINVENTORY_CODE  
		  mmtStmt.setFloat(6,Float.parseFloat(transQty));     // TRANSACTION_QUANTITY
		  mmtStmt.setString(7,woUOM);	                  // TRANSACTION_UOM
		  mmtStmt.setFloat(8,Float.parseFloat(transQty));	  // PRIMARY_QUANTITY 
		  mmtStmt.setInt(9,Integer.parseInt(wipEntityId));	  // TRANSACTION_SOURCE_ID(Wip_Entity_id)
		  mmtStmt.setInt(10,Integer.parseInt(fmOpSeqNum));    // OPERATION_SEQ_NUM
		  mmtStmt.setInt(11,Integer.parseInt(userMfgUserID)); // CREATED_BY
		  mmtStmt.setString(12,oeOrderNo);                    //ATTRIBUTE1  MO_NO
		  mmtStmt.setString(13,lotNo);                      //ATTRIBUTE2 LOT_NO (流程卡號) 
		  mmtStmt.setString(14,lotNo);                      //VENDOR_LOT_NUMBER  SUPPLIER_LOT_NO
		  //mmtStmt.setDate(15,transactionDate);              // TRANSACTION_DATE 
          mmtStmt.executeUpdate();
          mmtStmt.close();		
		  
		  out.println("Step2. 寫入MMT Lot Interface<BR>");
		    String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
		                          "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
								  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, ATTRIBUTE1, ATTRIBUTE2 ) "+ 
								  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?) ";
	        PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
			mmtLotStmt.setString(1,lotNo);                         // LOT_NUMBER(流程卡號)
		    mmtLotStmt.setFloat(2,Float.parseFloat(transQty));	   // TRANSACTION_QUANTITY
		    mmtLotStmt.setFloat(3,Float.parseFloat(transQty));	   // PRIMARY_QUANTITY 
		    mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	       // LAST_UPDATED_BY 								 
		    mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
			mmtLotStmt.setString(6,oeOrderNo);                           //ATTRIBUTE1  MO_NO
		    mmtLotStmt.setString(7,lotNo);                              //ATTRIBUTE2 LOT_NO (流程卡號)
			mmtLotStmt.executeUpdate();
            mmtLotStmt.close();
			
		 out.println("Stepb.寫入MMT LOT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
			
		} // End of try
		catch (Exception e)
        {
           out.println("Exception MMT & LOT Interface:"+e.getMessage());
        }	
   //執行 MMT及MMT LOT Interface Submit Request
   String errorMsg = "";
   String woPassFlag = "";
   try
   {
	  Statement stateResp=con.createStatement();	   
	  ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME = 'YEW_INV_SEMI_SU' "); 
	  if (rsResp.next())
	  {
	     respID = rsResp.getString("RESPONSIBILITY_ID");
	  } else {
	           respID = "50757"; // 找不到則預設 --> YEW INV Super User 預設
	         }
			 rsResp.close();
			 stateResp.close();	  			 
			 
	  // -- 取此次MMT 的Transaction Header ID 作為Group Header ID
	  String grpHeaderID = "";
	  String devStatus = "";
	  String devMessage = "";
	              Statement statGRPID=con.createStatement();	             
	              ResultSet rsGRPID=statGRPID.executeQuery("select TRANSACTION_HEADER_ID from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID = "+groupId+" ");
				  if (rsGRPID.next()) grpHeaderID = rsGRPID.getString(1);
				  rsGRPID.close();
				  statGRPID.close();			    
				  
	           out.println("Step3. 呼叫 WIP_MTLINTERFACEPROC_PUB.processInterface <BR>");	
	             //	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
	
				 CallableStatement cs3 = con.prepareCall("{call WIP_MTLINTERFACEPROC_PUB.processInterface(?,?,?,?)}");			 
	             cs3.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
				 cs3.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
	             cs3.registerOutParameter(3, Types.VARCHAR);  //回傳 x_returnStatus
				 cs3.registerOutParameter(4, Types.VARCHAR);  //回傳 x_errorMsg				
	             cs3.execute();
                 out.println("Procedure : Execute Success !!! ");	             
				 devStatus = cs3.getString(3);    // 回傳 x_returnStatus
				 devMessage = cs3.getString(4);   // 回傳 x_errorMsg
                 cs3.close(); 
				 
				 //java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷				 
							 
				 Statement stateError=con.createStatement();
			     String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
				 //out.println("sqlError="+sqlError+"<BR>");					                                     
                 ResultSet rsError=stateError.executeQuery(sqlError);	
				 if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
				 { 
					   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+devStatus+"</TD></TR>");
				  	   out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
					   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					   woPassFlag="N";						   
					 errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
				 }
				 rsError.close();
				 stateError.close();
				 
				 if (errorMsg.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
				 {	
				   out.println("Success Submit !!! Return Status = "+devStatus+"<BR>");
				   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   woPassFlag="Y";	// 成功寫入的旗標
				   con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
				 }


              
	   }// end of try
       catch (Exception e)
       {
           out.println("Exception  WIP_MTLINTERFACEPROC_PUB.processInterface:"+e.getMessage());
       }	
    // #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄

    if ((woType=="3" || woType.equals("3")) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface需成功寫入才寫Reservaton
    {
	   String orderHeaderId="",sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
	   float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;

	 try
	 { 	     
		
		//out.println("orderno="+oeOrderNo+"  orderLineId="+orderLineId);
		
		
		if (orderLineId==null || orderLineId.equals(""))
		{
		     Statement stateLine=con.createStatement();
             ResultSet rsLine=stateLine.executeQuery("select ORDER_LINE_ID,OE_ORDER_NO from YEW_WORKORDER_ALL where WO_NO = '"+woNo+"' ");
		     if (rsLine.next()) 
			 {
			   orderLineId=rsLine.getString("ORDER_LINE_ID");
			   oeOrderNo=rsLine.getString("OE_ORDER_NO");
			 }
			 rsLine.close();
			 stateLine.close();
		}
		
		//抓不足欄位資料  mtl_sales_orders HEADER_ID
		String sqlfndb = "SELECT sales_order_id, HEADER_ID FROM mtl_sales_orders a, oe_order_headers_all b ,oe_transaction_types_tl c  "+
   						 " WHERE a.segment1 = b.order_number  and b.order_number='"+oeOrderNo+"' and b.SHIP_FROM_ORG_ID = "+organizationId+" "+
					     "   and a.segment2=c.name  and c.transaction_type_id=b.order_type_id   and c.language='US' ";
		
        //out.println(sqlfndb);
		Statement stateFndIdb=con.createStatement();
        ResultSet rsFndIdb=stateFndIdb.executeQuery(sqlfndb);
		if (rsFndIdb.next())
		{
			  sourceHeaderId = rsFndIdb.getString("sales_order_id"); 
			  orderHeaderId  = rsFndIdb.getString("HEADER_ID"); 
		}
		rsFndIdb.close();
		stateFndIdb.close(); 
		
		
				
		//抓已存在的reservation qty 與訂單相比  mtl_sales_orders HEADER_ID
		String sqlfndb1 =" select sum(decode(MTR.RESERVATION_UOM_CODE,'PCE',MTR.RESERVATION_QUANTITY/1000,MTR.RESERVATION_QUANTITY )) RESV_QTY, "+
       					 "        sum(decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY)) ORDER_QTY , "+
						 "        to_char(trunc(SCHEDULE_SHIP_DATE),'YYYYMMDD') SCHEDULE_SHIP_DATE "+
 						 "	from MTL_RESERVATIONS MTR , OE_ORDER_LINES_ALL OOL  "+
						 "	where MTR.DEMAND_SOURCE_LINE_ID(+) = OOL.LINE_ID and OOL.LINE_ID = "+orderLineId+"  "+
						 "  group by SCHEDULE_SHIP_DATE ";
		//out.println(sqlfndb1);				 
		Statement stateFndIdb1=con.createStatement();
        ResultSet rsFndIdb1=stateFndIdb1.executeQuery(sqlfndb1);
		if (rsFndIdb1.next())
		{  
			  requireDate = rsFndIdb1.getString("SCHEDULE_SHIP_DATE");     //需求日
			  resvQty = rsFndIdb1.getFloat("RESV_QTY");    //己被保留數
			  orderQty = rsFndIdb1.getFloat("ORDER_QTY");  //訂單數
			  //out.println("requireDate="+requireDate);
			  //out.println("resvQty="+resvQty);
			  //out.println("orderQty="+orderQty);
			  avaiResvQty = orderQty - resvQty ;           //可保留數  
			  //out.println("avaiResvQty="+avaiResvQty);
		}
		rsFndIdb1.close();
		stateFndIdb1.close(); 
		
		//out.println("aMFGRCCompleteCode[i][2]="+aMFGRCExpTransCode[i][2]);
		
		if (avaiResvQty<=0)
		 {
		  resvFlag ="N";
		  out.print("<br>無訂單量可供Reservation,不執行訂單保留!");
		  //out.print("HostTTT");
		 }
		 else if (Float.parseFloat(transQty) > avaiResvQty)   //流程卡數>可保留數
		 {
		  resvFlag ="Y";
		  resTxnQty=avaiResvQty;               //resversion qty=剩餘可保留數
		  out.print("<br>入庫數大於訂單數,執行訂單數保留!");
		  //out.print("HostQQQ");
		 }
		 else
		 {
		  resTxnQty = Float.parseFloat(transQty) ;   //resversion qty=流程卡數量
		  //out.print("<br>執行訂單數保留成功!");
		  resvFlag ="Y";
		  //out.print("HostRRR");
		 }
		 
	      }// end of try
         catch (SQLException e)
         {
           out.println("Exception RESERVATIONS confirm:"+e.getMessage());
         }			 
		
		if ( resvFlag!="N" && !resvFlag.equals("N"))
		{
		  try
		  {
	    	//抓不足欄位資料  RESERVATION_INTERFACE_ID 
	        Statement stateFndIdc=con.createStatement();
    	    ResultSet rsFndIdc=stateFndIdc.executeQuery("select MTL_RESERVATIONS_INTERFACE_S.NEXTVAL from dual");
			if (rsFndIdc.next())
			{
			  rsInterfaceId = rsFndIdc.getString(1); 
			}
			rsFndIdc.close();
			stateFndIdc.close();	  
			
	     java.sql.Date requirementDate = null;
		 if (requireDate.length()>4)
		 {
	       requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // 給requireDate
	  	 } else {
		           requireDate = dateBean.getYearMonthDay(); 
		           requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // 給requireDate  
		        }
		 
	      out.println("<br>Step4. 寫入Reservations Interface<BR>");	
	 	  String sqlInsRSIN = "  insert into MTL_RESERVATIONS_INTERFACE( "+
		                        " RESERVATION_INTERFACE_ID,RESERVATION_BATCH_ID,REQUIREMENT_DATE  "+
								" ,ORGANIZATION_ID,TO_ORGANIZATION_ID,INVENTORY_ITEM_ID,ITEM_SEGMENT1 "+
								" ,DEMAND_SOURCE_TYPE_ID,RESERVATION_UOM_CODE,RESERVATION_QUANTITY,SUPPLY_SOURCE_TYPE_ID "+
								" ,ROW_STATUS_CODE,LOCK_FLAG,RESERVATION_ACTION_CODE,TRANSACTION_MODE,VALIDATION_FLAG "+
								" ,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY "+
								" ,SUBINVENTORY_CODE,TO_DEMAND_SOURCE_TYPE_ID,TO_SUPPLY_SOURCE_TYPE_ID "+
								" ,LOT_NUMBER,DEMAND_SOURCE_HEADER_ID,DEMAND_SOURCE_LINE_ID) "+ 
								"  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?,SYSDATE,?,?,?,?,?,?,?) ";			
	      PreparedStatement rsInStmt=con.prepareStatement(sqlInsRSIN);
		 // out.print("<br>requirementDate="+requirementDate); 
		    rsInStmt.setInt(1,Integer.parseInt(rsInterfaceId));	   // TO_ORGANIZATION_ID
		    rsInStmt.setInt(2,Integer.parseInt(rsInterfaceId));		 
		    rsInStmt.setDate(3,requirementDate);    //REQUIREMENT_DATE 
		    rsInStmt.setInt(4,Integer.parseInt(organizationID));	   // ORGANIZATION_ID
		 // out.print("<br>organizationID="+organizationID); 	
		    rsInStmt.setInt(5,Integer.parseInt(organizationID));	   // TO_ORGANIZATION_ID
		    rsInStmt.setInt(6,primaryItemID);	                       // INVENTORY_ITEM_ID 								 
		    rsInStmt.setString(7,invItem);	       						//ITEM_SEGMENT1
		    rsInStmt.setInt(8,2);	      							    //DEMAND_SOURCE_TYPE_ID  2:sales order
			rsInStmt.setString(9,woUOM);	       //RESERVATION_UOM_CODE
		//  out.print("<br>RESERVATION_QUANTITY="+aMFGRCCompleteCode[i][2]); 		
		//	rsInStmt.setFloat(10,Float.parseFloat(aMFGRCExpTransCode[i][2])); 	       //RESERVATION_QUANTITY
			rsInStmt.setFloat(10,resTxnQty); 	       //RESERVATION_QUANTITY
		// out.print("<br>SOURCE_TYPE_ID");	
			rsInStmt.setInt(11,13);	       //SUPPLY_SOURCE_TYPE_ID  13:inventory
			rsInStmt.setInt(12,1);	       //--ROW_STATUS_CODE 1-active 2-inactive
			rsInStmt.setInt(13,2);	       //LOCK_FLAG 1-yes 2-no
			rsInStmt.setInt(14,1);	       //RESERVATION_ACTION_CODE -- 1=Insert
			rsInStmt.setInt(15,3);	       //RANSACTION_MODE 3-background
			rsInStmt.setInt(16,1);	       //VALIDATION_FLAG 1-yes 2-no
		 // out.print("<br>LAST_UPDATE_DATE"); 
			//rsInStmt.setInt(5,Integer.parseInt(userMfgUserID));	       //LAST_UPDATE_DATE
			rsInStmt.setInt(17,Integer.parseInt(userMfgUserID));	       //LAST_UPDATE_BY
			//rsInStmt.setInt(5,Integer.parseInt(userMfgUserID));	       //CREATE_DATE
			rsInStmt.setInt(18,Integer.parseInt(userMfgUserID));	       //CREATE_BY
			rsInStmt.setString(19,compSubInventory);	                   //subinventory
			rsInStmt.setInt(20,2);	       //TO_DEMAND_SOURCE_TYPE_ID 2:sales order
			rsInStmt.setInt(21,13);	       //TO_SUPPLY_SOURCE_TYPE_ID 13:inventory
		//  out.print("<br>lot number="+aMFGRCCompleteCode[i][1]); 
			rsInStmt.setString(22,lotNo);	                        //lot number
		   //out.print("<br>sourceHeaderId="+sourceHeaderId);	
			rsInStmt.setInt(23,Integer.parseInt(sourceHeaderId));	       //DEMAND_SOURCE_HEADER_ID  sourceHeaderId
			rsInStmt.setInt(24,Integer.parseInt(orderLineId));           //DEMAND_SOURCE_LINE_ID   order_line_id
		   //out.print("<br>orderLineId="+orderLineId);		
			
			rsInStmt.executeUpdate();
            rsInStmt.close();
	        out.print("<br>Insert into Interface Success!!");	
	      }// end of try
         catch (Exception e)
         {
           out.println("Exception RESERVATIONS_REQUEST:"+e.getMessage());
         }	
	   
     //執行 RESERVATIONS Interface Manager
    try
    {
	  String grpHeaderID = "";
	  String devStatus = "";
	  String devMessage = ""; 
	  String errorMsgResv = "";  
   
	  Statement stateResp=con.createStatement();	   
	  ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME like 'YEW_INV_SEMI_SU%' "); 
	  if (rsResp.next())
	  {
	     respID = rsResp.getString("RESPONSIBILITY_ID");
	  } else {
	           respID = "50776"; // 找不到則預設 --> YEW INV Super User 預設
	         }
			 rsResp.close();
			 stateResp.close();	  
	  
	   out.println("<br>Step5. 呼叫TSC_YEW_INVRSVIN_REQUEST <BR>");	
	             //	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
				 CallableStatement cs3 = con.prepareCall("{call TSC_YEW_INVRSVIN_REQUEST(?,?,?,?,?,?,?)}");			 
				 cs3.setString(1,userMfgUserID);    //  user_id 修改人ID /	
				 cs3.setString(2,respID);  //*  使用的Responsibility ID --> YEW_INV_Semi_SU /				 
	             cs3.registerOutParameter(3, Types.INTEGER); 
				 cs3.registerOutParameter(4, Types.VARCHAR);                  //回傳 DEV_STATUS
				 cs3.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_MASSAGE
				 cs3.setString(6,lotNo);  //*  RUNCARD NO (可能是外購廠商批號)	
				 cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
	             cs3.execute();
                 out.println("Procedure : Execute Success !!! ");
	             int requestID = cs3.getInt(3);
				 devStatus = cs3.getString(4);   //  回傳 REQUEST 執行狀況
				 devMessage = cs3.getString(5);   //  回傳 REQUEST 執行狀況訊息
                 cs3.close();
				 
				 //java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷				 
							 
				 Statement stateError=con.createStatement();
			     String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
				 //out.println("sqlError="+sqlError+"<BR>");					                                     
                 ResultSet rsError=stateError.executeQuery(sqlError);	
				 if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
				 { 
					   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RESERVATIONS Transaction fail!! </FONT></TD><TD colspan=3>"+rsInterfaceId+"</TD></TR>");
				  	   out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
					   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					 woPassFlag="N";						   
					 errorMsgResv = errorMsgResv+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
				 }
				 rsError.close();
				 stateError.close();
				 
				 if (errorMsgResv.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
				 {	
				   out.println("Success Submit !!! RequestID = "+requestID);
				   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   woPassFlag="Y";	// 成功寫入的旗標
				   con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
				 }
            
	    }// end of try
        catch (Exception e)
        {
           out.println("Exception INVRSVIN_REQUEST:"+e.getMessage());
        }	
	   }// end if resvFlag !="N" 
	 } //end if woType=3 
	   	 

          // ###################### 寫入 Reservations Interface Manager  迄################### 迄	
			 
			 
			 
	} // End of 完工入庫再寫入Material Transaction及Material LOT,如為後段工令,再寫Reservation Interface
		*/ //20200820 FOR WMS  工單推to move不再執行完工入庫	 
			 
  } // End of if (delErrIFace.equals("I"))	
  else if (delErrIFace.equals("D"))
	   {  // 若是刪除錯誤Interface 模式,則刪除Move Transaction Interface 內被處理為 Error 的當筆Runcard     
		     
			 PreparedStatement csStmtDel=con.prepareStatement("delete from WIP_MOVE_TXN_INTERFACE where WIP_ENTITY_ID = "+wipEntityId+" and ATTRIBUTE2= '"+runCardNo+"' "); 									 					      						   	 					     
			 csStmtDel.executeUpdate();	
			 csStmtDel.close();			
			 out.println("<BR>工令ID("+wipEntityId+")");
			 out.println("下之流程卡('"+runCardNo+"')移站異常Interface已刪除<BR>"); 			 	 
	   }
	   
 }  // End of if (insertLot.equals("N")) //不是LOT 新增作業
 else if (insertLot.equals("Y"))
      {  // 批號新增作業_起
	  
	     int invItemId = 0;
		 // 取對應InventoryItem的 Id
		 Statement stateInv=con.createStatement();	   
	     ResultSet rsInv=stateInv.executeQuery("select INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS where ORGANIZATION_ID = "+lotOrganId+" and SEGMENT1 = '"+invItemLot+"' "); 
	     if (rsInv.next())
	     {
	       invItemId = rsInv.getInt("INVENTORY_ITEM_ID");
	     } 
		 rsInv.close();
		 stateInv.close();	
		 
		 // Step1. 寫入 Material Transactions LOT NUMBER
		          int transID = 0;
		          Statement stateTR=con.createStatement();	   
	              ResultSet rsTR=stateTR.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual "); 
	              if (rsTR.next()) transID = rsTR.getInt(1);
	              rsTR.close();
				  stateTR.close();   
		 
		          java.sql.Date transDate = null; 
		          transDate = new java.sql.Date(Integer.parseInt(dateBean.getYearString())-1900,Integer.parseInt(dateBean.getMonthString())-1,Integer.parseInt(dateBean.getDayString()));
		   
		          // 取工令ID
		          int lotWipEntityId = 0;
				  Statement stateWIP=con.createStatement();	   
	              ResultSet rsWIP=stateWIP.executeQuery("select WIP_ENTITY_ID from WIP_ENTITIES where WIP_ENTITY_NAME = '"+lotWipEntity+"' "); 
	              if (rsWIP.next()) lotWipEntityId = rsWIP.getInt(1);
		          rsWIP.close();
				  stateWIP.close();
				  
		    /*  -- 不Work 的MTL_TRANSACTIONS_LOT
		         CallableStatement cs4 = con.prepareCall("{call INV_LOT_API_PUB.inserttrxlot(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");	
				 cs4.setInt(1,1);         //  p_api_version			 
				 cs4.setString(2,"F");    //  p_init_msg_list
				 cs4.setString(3,"T");    //   p_commit 	
				 cs4.setInt(4,100);       // p_validation_level	
				 cs4.setFloat(5,Float.parseFloat(priTransQty));  // p_primary_quantity
				 cs4.setInt(6,transID);    // p_transaction_id				 
				 cs4.setInt(7,invItemId); // p_inventory_item_id					 
				 cs4.setInt(8,Integer.parseInt(lotOrganId)); // p_lot_number
				 cs4.setDate(9,transDate);	     // p_transaction_date
				 cs4.setInt(10,lotWipEntityId);   //  p_transaction_source_id = wip_entity_id
				 cs4.setString(11,"");            //  p_transaction_source_name 
				 cs4.setInt(12,5);                //  p_transaction_source_type_id = 5 = WIP				  
				 cs4.setString(13,null); // p_transaction_temp_id				
				 cs4.setString(14,null); // p_transaction_action_id
				 cs4.setString(15,null); // p_transfer_organization_id
				 cs4.setString(16,lotNumber);     //  p_transaction_date
				 cs4.setString(17,null);            
				 cs4.registerOutParameter(18, Types.VARCHAR);                  //回傳 x_return_status
				 cs4.registerOutParameter(19, Types.INTEGER);                  //回傳 x_msg_count
				 cs4.registerOutParameter(20, Types.VARCHAR);                  //回傳 x_msg_data 				 
	             cs4.execute();
                 out.println("Procedure : Execute Insert Lot Success !!! ");	             
				 String rtnLotStatus = cs4.getString(18);   //  回傳 REQUEST 執行狀態
				 int msgLotCount = cs4.getInt(19);          //  回傳 RowCount
				 String msgLotData = cs4.getString(20);     //  回傳 REQUEST 執行狀況訊息
                 cs4.close();
				 
				 out.println("rtnLotStatus="+rtnLotStatus+"<BR>");
				 out.println("msgLotData="+msgLotData+"<BR>");
		 	*/
			
			     CallableStatement cs4 = con.prepareCall("{call INV_TRANSACTIONS.LOT_INTERFACE_INSERT(?,?,?,?)}");	
				 cs4.setFloat(1,Float.parseFloat(priTransQty));  //  p_api_version			 
				 cs4.setString(2,lotNumber);    //  p_Lot_Number
				 cs4.setInt(3,3077);           //  p_User_Id 	
				 cs4.setInt(4,6);              // p_serial_number_control_code	
				 cs4.execute();
				 cs4.close();
			
		    java.sql.Date expDate = null; 
		    //expDate = new java.sql.Date(Integer.parseInt("2099")-1900,Integer.parseInt("12")-1,Integer.parseInt("31"));
	  
	          // Step2. 寫入 Material LOT Number
	             CallableStatement cs3 = con.prepareCall("{call INV_LOT_API_PUB.insertlot(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");	
				 cs3.setInt(1,1);         //  p_api_version			 
				 cs3.setString(2,"F");    //  p_init_msg_list
				 cs3.setString(3,"T");    //   p_commit 	
				 cs3.setInt(4,100); // p_validation_level	
				 cs3.setInt(5,invItemId); // p_inventory_item_id	
				 cs3.setInt(6,Integer.parseInt(lotOrganId)); // p_lot_number	
				 cs3.setString(7,lotNumber); 
				 cs3.setDate(8,expDate);
				 cs3.setString(9,null); // p_transaction_temp_id				
				 cs3.setString(10,null); // p_transaction_action_id
				 cs3.setString(11,null); // p_transfer_organization_id
	             cs3.registerOutParameter(12, Types.INTEGER);                  // X_OBJECT_ID
				 cs3.registerOutParameter(13, Types.VARCHAR);                  //回傳 x_return_status
				 cs3.registerOutParameter(14, Types.INTEGER);                  //回傳 x_msg_count
				 cs3.registerOutParameter(15, Types.VARCHAR);                  //回傳 x_msg_data 				 
	             cs3.execute();
                 out.println("Procedure : Execute Insert Lot Success !!! ");
	             int objectID = cs3.getInt(12);
				 String rtnStatus = cs3.getString(13);   //  回傳 REQUEST 執行狀態
				 int msgCount = cs3.getInt(14);          //  回傳 RowCount
				 String msgData = cs3.getString(15);     //  回傳 REQUEST 執行狀況訊息
                 cs3.close();
				 
				 out.println("rtnStatus="+rtnStatus+"<BR>");
				 out.println("msgData="+msgData+"<BR>");
				 
		   
		  
	  }  // 批號新增作業_迄
	  else if (invReservation.equals("Y"))
	       { // 庫存保留API_起  
		         
				 int invItemId = 0;
		         // 取對應InventoryItem的 Id
		         Statement stateInv=con.createStatement();	   
	             ResultSet rsInv=stateInv.executeQuery("select INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS where ORGANIZATION_ID = "+resOrganId+" and SEGMENT1 = '"+resInvItem+"' "); 
	             if (rsInv.next())
	             {
	               invItemId = rsInv.getInt("INVENTORY_ITEM_ID");
	             } 
		         rsInv.close();
		         stateInv.close();	
		         
		         java.sql.Date reservDate = null; 
		         reservDate = new java.sql.Date(Integer.parseInt(reservationDate.substring(0,4))-1900,Integer.parseInt(reservationDate.substring(4,6))-1,Integer.parseInt(reservationDate.substring(6,8))); 		   
		   
		         // Step2. 寫入 Inventory Reservation
	             CallableStatement cs3 = con.prepareCall("{call TSC_RESERVATION.tsc_reservation_create(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");	
				 cs3.registerOutParameter(1, Types.VARCHAR);  // Errbuf
				 cs3.registerOutParameter(2, Types.VARCHAR);  // Retcode
				 cs3.setInt(3,Integer.parseInt(resOrganId));  // v_organization_id			 
				 cs3.setDate(4,reservDate); //  v_reser_date
				 cs3.setInt(5,invItemId);   //  v_inventory_item_id 	
				 cs3.setInt(6,Integer.parseInt(resOeHeaderId));     // v_oe_header_id	
				 cs3.setInt(7,Integer.parseInt(resOeLineId));       // v_oe_line_id	
				 cs3.setString(8,"KPC");                            // v_uom	 resUom 單位
				 cs3.setFloat(9,Float.parseFloat(resQty));          // v_reser_qty
				 cs3.setString(10,"03");                            // v_subinv // resSubInv 成品倉
				 cs3.setString(11,resLotNumber);                 // v_lot_number			
	             cs3.registerOutParameter(12, Types.DECIMAL);    // x_reserved_qty
				 cs3.registerOutParameter(13, Types.VARCHAR);                  //回傳 p_res_status
				 cs3.registerOutParameter(14, Types.VARCHAR);                  //回傳 p_res_message				 				 
	             cs3.execute();
                 out.println("Procedure : Execute Inventory Reservation Success !!! ");
	             float qtyReserved = cs3.getFloat(12);
				 String rtnStatus = cs3.getString(13);   //  回傳 REQUEST 執行狀態				
				 String msgData = cs3.getString(14);     //  回傳 REQUEST 執行狀況訊息
                 cs3.close();
				 
				 out.println("<BR>qtyReserved="+qtyReserved+"<BR>");
				 out.println("rtnStatus="+rtnStatus+"<BR>");
				 out.println("msgData="+msgData+"<BR>");
		   
		   
		   } // 庫存保留API_迄

// 更新YEW_RUNCARD_ALL 站別資訊  20080107 liling add
try
{ 

String  preOpNum="",nextOpNum="",fmDesc="";
int opSeqId=0,stdOpId=0;

    String rlsqlb= "  select OPERATION_SEQUENCE_ID,STANDARD_OPERATION_ID,PREVIOUS_OPERATION_SEQ_NUM,NEXT_OPERATION_SEQ_NUM, DESCRIPTION FM_DESC "+
  			       "    from wip_operations  where WIP_ENTITY_ID= '"+wipEntityId+"'  and OPERATION_SEQ_NUM = '"+toOpSeqNum+"' ";
         //out.print(rlsqlb+"<br>");

        Statement rlid=con.createStatement();	   
	    ResultSet rsId=rlid.executeQuery(rlsqlb);
	    if (rsId.next())
	     {
	         opSeqId   = rsId.getInt("OPERATION_SEQUENCE_ID");
             stdOpId   = rsId.getInt("STANDARD_OPERATION_ID");
			 preOpNum  = rsId.getString("PREVIOUS_OPERATION_SEQ_NUM");
             nextOpNum = rsId.getString("NEXT_OPERATION_SEQ_NUM");
             fmDesc    = rsId.getString("FM_DESC");
	     } 
		 rsId.close();
		 rlid.close();


        String rcSqla=" update APPS.YEW_RUNCARD_ALL set OPERATION_SEQ_NUM=?,OPERATION_SEQ_ID=? ,STANDARD_OP_ID=? ,PREVIOUS_OP_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?  "+
                      "   where WO_NO= '"+woNo+"' and RUNCARD_NO='"+runCardNo+"' "; 	
           PreparedStatement rcStmta=con.prepareStatement(rcSqla);
	       //out.print("rcSql="+rcSqla);           
	       rcStmta.setString(1,toOpSeqNum); 
           rcStmta.setInt(2,opSeqId);
           rcStmta.setInt(3,stdOpId);
           rcStmta.setString(4,preOpNum);
           rcStmta.setString(5,nextOpNum);		   	  
           rcStmta.executeUpdate();   
           rcStmta.close(); 


  //寫入YEW_RUNCARD_RESTXNS及YEW_RUNCARD_TRANSACTIONS 相關資訊 20090427 liling_start
        if (toIntOpSType.equals("5")) // 若是報廢
	     {
		  String resTxnSql=" update APPS.YEW_RUNCARD_RESTXNS set  QTY_AC_SCRAP="+transQty+" where RUNCARD_NO='"+runCardNo+"' and OPERATION_SEQ_NUM='"+fmOpSeqNum+"'  ";
          //out.print(resTxnSql);
		  PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                       
		  pstmtResTxn.executeUpdate(); 
          pstmtResTxn.close(); 
          //out.print("scrap="+"select * from YEW_RUNCARD_RESTXNS where RUNCARD_NO='"+runCardNo+"' and OPERATION_SEQ_NUM='"+fmOpSeqNum+"' ");

		  String SqlTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           "            RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           "            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           "            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, LASTUPDATE_BY, "+
						   "            LASTUPDATE_DATE,RCSTATUSID ) "+  // 2007/04/03 增加寫入報廢數及良品數
				           "     values(YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+transDatea+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,"+transQty+",?,?,?,?,SYSDATE,?) ";  						
           PreparedStatement queueTrans=con.prepareStatement(SqlTrans); 
        //   queueTransStmt.setInt(1,Integer.parseInt(aMFGRCExpTransCode[i][0])); // RUNCAD_ID          
	       queueTrans.setString(1,runCardNo);                // RUNCARD_NO
           queueTrans.setInt(2,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       queueTrans.setInt(3,Integer.parseInt(wipEntityId));                 // WIP_ENTITY_ID
	       queueTrans.setInt(4,primaryItemID);                                // PRIMARY_ITEM_ID
           queueTrans.setInt(5,Integer.parseInt(fmOpSeqNum)); //FM_OPERATION_SEQ_NUM(本站)    
		   queueTrans.setString(6,fmDesc);                          //  FM_OPERATION_CODE	       	   
           queueTrans.setInt(7,Integer.parseInt(toOpSeqNum)); //TO_OPERATION_SEQ_NUM(下一站) 
	       queueTrans.setString(8,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	      // queueTransStmt.setFloat(10,Float.parseFloat(transQty));  // Transaction Qty
	       queueTrans.setString(9,woUOM);      // Transaction_UOM		   
	       queueTrans.setInt(10,5);             // 1=Queue		  
	       queueTrans.setString(11,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
		   queueTrans.setString(12,fndUserName);	  // Update User  
		   queueTrans.setString(13,statusID); 
           queueTrans.executeUpdate();
           queueTrans.close();	    	  
		 // %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 
        }
         else
         {
		   String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, QTY_IN_INPUT, CREATED_BY, LAST_UPDATED_BY, "+
						    " OPERATION_SEQ_NUM,RESOURCE_SEQ_NUM,  WIP_ENTITY_ID, TRANSACTION_DATE ) "+
				            " values( '"+woNo+"', '"+runCardNo+"', "+transQty+", '"+userMfgUserID+"', '"+fndUserName+"', "+															              
			                "         "+Integer.parseInt(fmOpSeqNum)+",'"+10+"', '"+wipEntityId+"','"+transDatea+"'||'"+sTime+"' ) ";
		  PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                        
		  pstmtResTxn.executeUpdate(); 
          pstmtResTxn.close(); 
          //out.print("move="+"select * from YEW_RUNCARD_RESTXNS where RUNCARD_NO='"+runCardNo+"' and OPERATION_SEQ_NUM='"+fmOpSeqNum+"' ");

		  String SqlTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           "            RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           "            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           "            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, LASTUPDATE_BY, "+
						   "            LASTUPDATE_DATE,RCSTATUSID ) "+  // 2007/04/03 增加寫入報廢數及良品數
				           "     values(YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+transDatea+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,"+transQty+",?,?,?,?,SYSDATE,?) ";  						
           PreparedStatement queueTrans=con.prepareStatement(SqlTrans); 
        //   queueTransStmt.setInt(1,Integer.parseInt(aMFGRCExpTransCode[i][0])); // RUNCAD_ID          
	       queueTrans.setString(1,runCardNo);                // RUNCARD_NO
           queueTrans.setInt(2,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       queueTrans.setInt(3,Integer.parseInt(wipEntityId));                 // WIP_ENTITY_ID
	       queueTrans.setInt(4,primaryItemID);                                // PRIMARY_ITEM_ID
           queueTrans.setInt(5,Integer.parseInt(fmOpSeqNum)); //FM_OPERATION_SEQ_NUM(本站)    
		   queueTrans.setString(6,fmDesc);                          //  FM_OPERATION_CODE	       	   
           queueTrans.setInt(7,Integer.parseInt(nextOpNum)); //TO_OPERATION_SEQ_NUM(下一站) 
	       queueTrans.setString(8,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	      // queueTransStmt.setFloat(10,Float.parseFloat(transQty));  // Transaction Qty
	       queueTrans.setString(9,woUOM);      // Transaction_UOM		   
	       queueTrans.setInt(10,1);             // 1=Queue		  
	       queueTrans.setString(11,"Queue");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
		   queueTrans.setString(12,fndUserName);	  // Update User 
           queueTrans.setString(13,statusID); 
           queueTrans.executeUpdate();
           queueTrans.close();	    	 	 
		 // %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 
 //寫入YEW_RUNCARD_RESTXNS及YEW_RUNCARD_TRANSACTIONS 相關資訊 20090427 liling_END
         }

	    }// end of try
        catch (Exception e)
        {
           out.println("Exception update rc:"+e.getMessage());
        }
// 更新YEW_RUNCARD_ALL 站別資訊--end

		   
	// 若使用者亦選擇更改單據狀態,則一併修改流程卡狀態
	if (statusID !=null && !statusID.equals("") && !statusID.equals("--"))
	{
	       String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
		                "        PREVIOUS_OP_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, PROG_NOTES = 'WIP ADMIN UPDATE'  "+						 
		                " where WO_NO= '"+woNo+"' and RUNCARD_NO='"+runCardNo+"' "; 	
           PreparedStatement rcStmt=con.prepareStatement(rcSql);
	       //out.print("rcSql="+rcSql);           
	       rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	       rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 		   
	       rcStmt.setString(3,statusID); 
		   
          //"select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
           Statement getStatusStat=con.createStatement();  
           ResultSet getStatusRs=getStatusStat.executeQuery("select STATUSNAME from ORADDMAN.TSWFSTATUS where STATUSID='"+statusID+"' "); 
		   if (getStatusRs.next()) 
	       rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
		   getStatusRs.close();
		   getStatusStat.close();
		   
		   rcStmt.setInt(5,Integer.parseInt(fmOpSeqNum)); 
		   rcStmt.setInt(6,Integer.parseInt(toOpSeqNum));		  
           rcStmt.executeUpdate();   
           rcStmt.close(); 
	 } //End of if	若使用者亦選擇更改單據狀態,則一併修改流程卡狀態
  		
%>
<BR>
<%
    String sqlRCMTxn = "select * from WIP_MOVE_TRANSACTIONS ";
	String whereRCMTxn = "where WIP_ENTITY_ID = "+wipEntityId+" ";
	                     //" and ATTRIBUTE2 = '"+runCardNo+"' ";
	String orderRCMTxn = " order by ATTRIBUTE2, FM_OPERATION_SEQ_NUM ";		 
	sqlRCMTxn = sqlRCMTxn + whereRCMTxn + orderRCMTxn;
	//out.println(sqlRCMTxn);	 
	Statement stateRCMTxn=con.createStatement(); 
	ResultSet rsRCMTxn=stateRCMTxn.executeQuery(sqlRCMTxn);	
	if (rsRCMTxn!=null)
	{
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="50%" bordercolorlight="#FFFFFF" border="0">
<tr bgcolor="#CCCC99">
    <td nowrap><span class="style3">RUNCARD_NO</span></td>
    <td nowrap><span class="style3">FM_OPERATION_SEQ_NUM</span></td>
    <td nowrap><span class="style3">TO_OPERATION_SEQ_NUM</span></td><td nowrap><span class="style3">TRANSACTION_QUANTITY</span></td><td nowrap><span class="style3">TRANSACTION_UOM</span></td><td nowrap><span class="style3">TO_INTRAOPERATION_STEP_TYPE</span></td>
</tr>
  <%
       while (rsRCMTxn.next())
	   {
  %>
<tr bgcolor="#CCCC99">
   <td nowrap><a href="../jsp/TSCMfgMoveTransactionPage.jsp?WIP_ENTITY_ID=<%=wipEntityId%>&RUNCARD_NO=<%=rsRCMTxn.getString("ATTRIBUTE2")%>"><%=rsRCMTxn.getString("ATTRIBUTE2")%></a></td>
   <td nowrap><%=rsRCMTxn.getString("FM_OPERATION_SEQ_NUM")%></td>
   <td nowrap><%=rsRCMTxn.getString("TO_OPERATION_SEQ_NUM")%></td>
   <td nowrap><%=rsRCMTxn.getString("TRANSACTION_QUANTITY")%></td>
   <td nowrap><%=rsRCMTxn.getString("TRANSACTION_UOM")%></td>
   <td nowrap><%=rsRCMTxn.getString("TO_INTRAOPERATION_STEP_TYPE")%></td>
</tr>
<%
       } // End of while (rsRCMTxn.next())
	   rsRCMTxn.close();
	   stateRCMTxn.close();   
%>
</table>
<%
   } // End of if (rsRCMTxn!=null)
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
