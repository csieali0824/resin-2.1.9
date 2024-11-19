<!-- 20091217 Marvie Add : yew_runcard_restxns data loss-->
<!-- 20130123 liling Add : yew_runcard_transactions FM_OPERATION_CODE loss-->
<!-- 20130327 liling modity : OSP後有多站者其runcard status 要判斷為044 moving -->
<!-- 20200506 liling 不執行入庫動作,交由WMS執行 6/27更新系統-->
<!-- 20200703 Marvie : 1 receipt interface 可完成 receipt delivery 動作 -->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.util.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->
<script language="JavaScript" type="text/JavaScript">
function reProcessFormConfirm(ms1,URL,woNo,runCardNo)
{
	var orginalPage="";
    flag=confirm(ms1);      
    if (flag==false) return(false);
	else
    {
  		document.MPROCESSFORM.action=URL+orginalPage;
        document.MPROCESSFORM.submit();	
	} 
}

function reProcessQueryConfirm(ms1,URL,woNo,runCardNo)
{
	var orginalPage="";
    flag=confirm(ms1);      
    if (flag==false) return(false);
	else
    {
		document.MPROCESSFORM.action=URL+orginalPage;
        document.MPROCESSFORM.submit();
	} 
}

function alertItemExistsMsg(msItemExists)
{
	alert(msItemExists);
}

</script>
<html>
<head>
<title>MFG System Work Order Process Page</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrMFG2DWOExpandBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工令資料要展流程卡及丟入WIP interface-->
<jsp:useBean id="arrMFG2DRunCardBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡已展開-> 流程卡移站中 -->
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡移站中 -->
<jsp:useBean id="arrMFGRCPOReceiptBean" scope="session" class="Array2DimensionInputBean"/><!--FOR 流程卡移站中-> 流程卡外包待收料中 -->
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡完工入庫 -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<FORM ACTION="TSCMfgWoMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String inspLotNo=request.getParameter("INSPLOTNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");

// MFG工令資料_參數起   
String woNo=request.getParameter("WO_NO");   //工單號
String runCardCountI=request.getParameter("RUNCARDCOUNTI");   //欲展之流程卡張數
String runCardQty=request.getParameter("RUNCARDQTY");        //單張流程卡數量
String runCardCountD=request.getParameter("RUNCARDCOUNTD");  //尾張流程卡數量
String dividedFlag=request.getParameter("DIVIDEDFLAG");      //是否被整除 整除='Y' ,未被整除之流程卡要多加一張
String singleControl=request.getParameter("SINGLECONTROL");   //是否為單批控管
String runCardPrffix=request.getParameter("RUNCARDPREFIX");   //流程卡前置碼
String runCardNo=request.getParameter("RUNCARD_NO");   //流程卡號
String classID=request.getParameter("CLASSID");
String woType=request.getParameter("WOTYPE");
String alternateRouting=request.getParameter("ALTERNATEROUTING");
String oeOrderNo=request.getParameter("OE_ORDER_NO");   
   
String runCardId=request.getParameter("RUNCARD_ID");
String interfaceId="";
String groupId=request.getParameter("GROUP_ID");
String deptNo=request.getParameter("DEPT_NO");
String organizationId=request.getParameter("ORGANIZATION_ID");
String itemId=request.getParameter("INVENTORY_ITEM_ID");
String invItem=request.getParameter("INV_ITEM");
String itemDesc=request.getParameter("ITEM_DESC");
String jobType=request.getParameter("JOB_TYPE");
String woQty=request.getParameter("WO_QTY");
String startDate=request.getParameter("STARTDATE");
String endDate=request.getParameter("ENDDATE");   
String defInv=request.getParameter("COMPLETION_SUBINVENTORY"); 
String entityId=request.getParameter("ENTITY_ID");
String woPassFlag=request.getParameter("WOPASSFLAG");
String operationSeqNum   = "";  
String operationSeqId    = "";
String standardOpId  	= "";
String previousOpSeqNum  = "";
String nextOpSeqNum	    = "";
String standardOpDesc    = "";   
String sTime = request.getParameter("STIME");
String rcStatus ="",rcStatusDesc="";  //20130327
String runCardCount=String.valueOf(runCardCountI);  //流程卡張數
      
if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR 流程卡已展開-> 流程卡移站中
String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR 流程卡移站中-> 流程卡移站中
String aMFGRCPOReceiptCode[][]=arrMFGRCPOReceiptBean.getArray2DContent(); // FOR 流程卡移站中-> 流程卡外包待收料中
String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR 流程卡移站中-> 流程卡完工入庫
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String oriStatus=null;
String actionName=null;
String dateString="";
String seqkey="";
String seqno="";
String line_No=request.getParameter("LINE_NO");
String curr=request.getParameter("CURR");
String [] choice=request.getParameterValues("CHKFLAG");
int headerID   = 0;  
String errorMessageHeader ="";
String errorMessageLine ="";
String statusMessageHeader ="";
String statusMessageLine ="";
String processStatus="";
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);

// 為存入日期格式為US考量,將語系先設為美國
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";   //TRADITIONAL CHINESE   
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
String systemDate ="",txnDate=""; //20090603
String organCode ="";
String organizationID = "";
Statement stateOrgCode=con.createStatement();
ResultSet rsOrgCode=stateOrgCode.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE ,substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME ,a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
if (rsOrgCode.next())
{
	organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
	organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
	systemDate=rsOrgCode.getString("SYSTEMDATE");  //20091123
    sTime=rsOrgCode.getString("STIME");  
}
rsOrgCode.close();
stateOrgCode.close();


java.sql.Date processDateTime = null; //將SYSDATE轉換成日期格式以符丟入API格式
if (systemDate!=null && systemDate.length()>=8)
{
	processDateTime = new java.sql.Date(Integer.parseInt(systemDate.substring(0,4))-1900,Integer.parseInt(systemDate.substring(4,6))-1,Integer.parseInt(systemDate.substring(6,8)));  // 給Receiving Date
   	String systemTime = dateBean.getHourMinuteSecond();  // 給System Time
   
    Calendar calendar1 = Calendar.getInstance(); 
	calendar1.set(dateBean.getYear(),dateBean.getMonth(),dateBean.getDay(),dateBean.getHour(), dateBean.getMinute(), dateBean.getSecond() );  // 設定日期的格式(年,月,日,時,分,秒)
    String sqlDate="  select TO_DATE('"+systemDate+ systemTime+"','YYYYMMDDHH24MISS') from DUAL   ";  					
    Statement stateDate=con.createStatement();
    ResultSet rsDate=stateDate.executeQuery(sqlDate);
	if (rsDate.next())
	{ 
		processDateTime  = rsDate.getDate(1,calendar1); 
	}
	rsDate.close();
    stateDate.close();	   
}   
 
java.sql.Date receivingDate = null; //將SYSDATE轉換成日期格式以符丟入API格式
if (systemDate!=null && systemDate.length()>=8)
{
	receivingDate = new java.sql.Date(Integer.parseInt(systemDate.substring(0,4))-1900,Integer.parseInt(systemDate.substring(4,6))-1,Integer.parseInt(systemDate.substring(6,8)));  // 給Receiving Date
   	String systemTime = dateBean.getHourMinuteSecond();  // 給System Time
   
    String sqlDate="  select TO_DATE('"+systemDate+ systemTime+"','YYYYMMDDHH24MISS') from DUAL   ";  					
    Statement stateDate=con.createStatement();
    ResultSet rsDate=stateDate.executeQuery(sqlDate);
	if (rsDate.next())
	{ 
		receivingDate  = rsDate.getDate(1);  
	}
	rsDate.close();
    stateDate.close();	   
}
   
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date    
int lineType = 0;  
String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
String dateCurrent = dateBean.getYearMonthDay();	

try
{ 
	// 取得執行動作名稱_起_ByKerwin 2007/02/04
  	Statement getActionName=con.createStatement();  
  	ResultSet getActionRs=getActionName.executeQuery("select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID = '"+actionID+"' ");  
  	if (getActionRs.next())
  	{
    	actionName = getActionRs.getString("ACTIONNAME");
  	}
  	getActionRs.close();
  	getActionName.close();
  	// 取得執行動作名稱_迄_ByKerwin 2007/02/04

	// 先取得下一狀態及狀態描述並作流程狀態更新   
  	dateString=dateBean.getYearMonthDay();
  
  	String sqlStat = "";
  	String whereStat = "";
	//out.println("FORMID="+formID);
  	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
   	
  	sqlStat = sqlStat+whereStat;
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
  	getStatusRs.next();

	//MFG流程卡移站中_起	(ACTION=023)   流程卡已展開042->流程卡委外加工待收料(045)
	if (actionID.equals("023") && fromStatusID.equals("042"))   // 如為n站, 即 第一站 --> 第二站 --> 第 n-1 站(表示第二站即為委外加工站)
	{   
    	String fndUserName = "";  //處理人員
		String woUOM = ""; // 工令移站單位
		int primaryItemID = 0; // 料號ID
    	float runCardQtyf=0,overQty=0; 
		entityId = "0"; // 工令wip_entity_id
		boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
    	if (aMFGRCExpTransCode!=null)
		{	  
	  		if (aMFGRCExpTransCode.length>0)
	  		{    
				String sqlfnd = " select USER_NAME from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 				  		        " where A.USER_NAME = UPPER(B.USERNAME)  and A.USER_ID = '"+userMfgUserID+ "'";
				Statement stateFndId=con.createStatement();
                ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
				if (rsFndId.next())
				{
					fndUserName = rsFndId.getString("USER_NAME"); 
				}
				rsFndId.close();
				stateFndId.close();
		   
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID , a.OE_ORDER_NO, b.RUNCARD_QTY "+
				                "  from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 				  		        " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
				Statement stateUOM=con.createStatement();
                ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
				if (rsUOM.next())
				{
					woUOM = rsUOM.getString("WO_UOM");
					entityId =  rsUOM.getString("WIP_ENTITY_ID");
					primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
					oeOrderNo = rsUOM.getString("OE_ORDER_NO");
					runCardQtyf = rsUOM.getFloat("RUNCARD_QTY");
				}
				rsUOM.close();
				stateUOM.close();
	  		} 
	  
	  		for (int i=0;i<aMFGRCExpTransCode.length-1;i++)
	  		{	
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
	    			if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RUNCARD_ID = 陣列內容
	    			{
		  				if (Float.parseFloat(aMFGRCExpTransCode[i][2])>0) // 若設定移站數量大於0才進行移站及報廢
		  				{
		   					int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   					int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   					if (aMFGRCExpTransCode[i][5]==null || aMFGRCExpTransCode[i][5]=="0" || aMFGRCExpTransCode[i][5].equals("0")) 
		   					{
		     					toIntOpSType = 3; 
		     					aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // 無下一站的Seq No,故給本站
			 					transType = 1; //(完工由入庫後自動執行,故仍設為1)
		   					}
		   					//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
		   					float  rcMQty = 0;   
		   					float  rcScrapQty = 0;     
		   					java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
		               
						 	String sqlMQty = " select b.QTY_IN_QUEUE,b.RES_EMPLOYEE_OP from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 									         " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										     "   and b.RUNCARD_NO='"+aMFGRCExpTransCode[i][1]+"' ";
						 	Statement stateMQty=con.createStatement();
                         	ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						 	if (rsMQty.next())
						 	{
						   		if (aMFGRCExpTransCode[i][2]==null || aMFGRCExpTransCode[i][2].equals("null")) aMFGRCExpTransCode[i][2]=Float.toString(rcMQty);
						   		rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		//原投站數量	
                           		txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 移站日期	
    
						   		rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   
						   
						    	String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();
						 	}
						 	rsMQty.close();
						 	stateMQty.close();

           					if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null")) txnDate=systemDate;
		   
		 					String getErrScrapBuffer = "";
		 					int getRetScrapCode = 0;   
					 		if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢Interface
		 					{		 
		   						// 先取報廢 Scrap Account ID_起// 依Organization_id 取預設的 Scrap Acc ID
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
		 
		   						// *****%%%%%%%%%%%%%% 移站報廢數量  %%%%%%%%%%%%**********  起
		   						toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
		   						transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
           						String SqlScrap=" insert into WIP_MOVE_TXN_INTERFACE( "+
				                                " CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				                                " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				                                " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				                                " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
						                        " GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
				                                " values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?,WIP_TRANSACTIONS_S.NEXTVAL ) ";   
           						PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
           						scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
	       						scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           						scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       						scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       						scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           						scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 改為 Running )      
		   						scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>流程卡:"+aMFGRCExpTransCode[i][1]+"(1.報廢數量="+rcScrapQty+")  ");       	   
           						scrapstmt.setString(8,woUOM);
	       						scrapstmt.setInt(9,Integer.parseInt(entityId));  
	       						scrapstmt.setString(10,woNo);  
	       						scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       						scrapstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)		  
	       						scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       						scrapstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][4])); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
	       						scrapstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		   						scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   						scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)報廢 ( 01-11-000-7650-951-0-000 ) 
		   						scrapstmt.setInt(18,7);	// REASON_ID  製程異常 
           						scrapstmt.executeUpdate();
           						scrapstmt.close();	      	
		   
		   						//抓取寫入Interface的Group等資訊_起
	       						int groupID = 0;
		   						int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     		" where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and ORGANIZATION_ID = '"+organizationID+ "' "+  //20091123 liling add Organization_id
										 		" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 		" and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
										 		" and TO_INTRAOPERATION_STEP_TYPE = 5 "; // 取此次報廢
								Statement stateGrp=con.createStatement();
                        		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
		 
		 						if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 						{
		   							// 即時呼叫 WIP_MOVE PROCESS WORKER		  
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
					      				CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              				cs5.setInt(1,groupID);                                         //  Org ID 	
			              				cs5.setString(2,null);   // BackFlush Setup    
			              				cs5.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              				cs5.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              				cs5.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              				cs5.execute();					      
			              				String getMoveStatus = cs5.getString(4);		
			              				String getMoveErrorMsg = cs5.getString(5);								      				    
			              				cs5.close();						  
						  				if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  				{
						     				getRetScrapCode = 77;   // Error Number  
							 				getErrScrapBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 				out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"報廢錯誤原因="+getErrScrapBuffer+"<BR>");
						  				}						  					  
									}	  
									catch (Exception e) 
									{ 
										out.println("Exception1:"+e.getMessage()); 
									}  
		  						} 
							} 
				 
							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;	
							float prevQty = 0; 	         
							if (getRetScrapCode==0) // 若執行同一站報廢成功,才執行移下一站動作_起
							{  
				     			float remainQueueQty=0;
		         	  			Statement stateRM=con.createStatement();
                      			ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and ORGANIZATION_ID = '"+organizationID+ "' and OPERATION_SEQ_NUM = "+aMFGRCExpTransCode[i][4]+" ");  //20091123 liling add organization_id
			          			if (rsRM.next()) 
								{ 
									remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); 
								}
			          			rsRM.close();
	   		          			stateRM.close();
			
								if (aMFGRCExpTransCode[i][3]==null || aMFGRCExpTransCode[i][3].equals("null"))  aMFGRCExpTransCode[i][3] = "0";
            					//判斷是否有overcompletion
             					String sqlpre="  select TRANSACTION_QUANTITY from YEW_RUNCARD_TRANSACTIONS "+
						                      "  where STEP_TYPE=1 and FM_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][3]+"' "+
						                      "  and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ";
								Statement statepre=con.createStatement();
            					ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
			  						prevQty = rspre.getFloat(1);  //前次移站數
								}
		    					rspre.close();
								statepre.close();
			
								//add by Peggy 20140324
								if (rcScrapQty >0)
								{
									//runCardQtyf	=runCardQtyf -Float.parseFloat("0"+rcScrapQty);
									//解決浮點數計算問題,add by Peggy 20140417
									runCardQtyf	=(runCardQtyf *1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
									runCardQtyf	=runCardQtyf/1000;
								}
								if (runCardQtyf<0) runCardQtyf=0;
								//out.println("aMFGRCExpTransCode[i][2]="+aMFGRCExpTransCode[i][2]);
								//out.println("runCardQtyf="+runCardQtyf);
								//out.println("remainQueueQty="+remainQueueQty);
								//out.println("runCardQtyf="+runCardQtyf);
						
								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf && remainQueueQty > Float.parseFloat(aMFGRCExpTransCode[i][2]) )//若移站數大於流程卡數,表示overcompletion_By Kerwin 2007/04/11
            					{
                					//overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //移站數-流程卡數=超出數量
									//解決浮點數計算問題,add by Peggy 20140417
									overQty = (Float.parseFloat(aMFGRCExpTransCode[i][2]) *1000) - (runCardQtyf*1000) ;    //移站數-流程卡數=超出數量
									overQty = overQty/1000;
                					overFlag = "Y";   //給定超收的flag
									//out.println("21.overQty="+overQty);
            					}
								else  
								{ 
			          				if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > remainQueueQty)
					  				{
					    				//overQty = Float.parseFloat(aMFGRCExpTransCode[i][2])-remainQueueQty; 
										//解決浮點數計算問題,add by Peggy 20140417
										overQty = (Float.parseFloat(aMFGRCExpTransCode[i][2])*1000)-(remainQueueQty*1000); 
										overQty = overQty/1000;
										overFlag = "Y";   //給定超收的flag
										//out.println("22.overQty="+overQty);
					  				} 
									else 
									{
					           			overFlag = "N"; 
					         		}		 			 
			       				}
		   						toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1 
           						String Sqlrc="";
           						String Sqlrc1="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
							   	String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
							   	String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
							   	String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
							   	String Sqlrcv5= " ) ";
 
          						if (overFlag == "Y" || overFlag.equals("Y"))
          						{ 
									Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; 
								}
          						else
          						{ 
									Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; 
								}
          						PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
           						seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
	       						seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           						seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       						seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       						seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           						seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error  (2006/12/08 改為 Running)
		   						seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // 移站數量
           						seqstmt.setString(8,woUOM);
	       						seqstmt.setInt(9,Integer.parseInt(entityId));  
	       						seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
	       						seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       						seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
	       						seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       						seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       						seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		   						seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   						if (overFlag == "Y" || overFlag.equals("Y"))
            					{ 
									seqstmt.setFloat(17,overQty); 
								} // OVERCOMPLETION_TRANSACTION_QTY   
           						seqstmt.executeUpdate();
           						seqstmt.close();	      	
		   
	       						int groupID = 0;
		   						int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     		" where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and ORGANIZATION_ID = '"+organizationID+ "'"+ //20091123 liling add organization_id
										 		"   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 		"   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
										 		"   and TO_INTRAOPERATION_STEP_TYPE = 1 "; // 取此次移站的Group ID
						 		Statement stateGrp=con.createStatement();
                         		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 		if (rsGrp.next())
						 		{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 		}
						 		rsGrp.close();
						 		stateGrp.close();
								
		 						if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 						{
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
					      				CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              				cs4.setInt(1,groupID);                                         //  Org ID 	
			              				cs4.setString(2,null);   // BackFlush Setup    
			              				cs4.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              				cs4.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              				cs4.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              				cs4.execute();					      
			              				String getMoveStatus = cs4.getString(4);		
			              				String getMoveErrorMsg = cs4.getString(5);								      				    
			              				cs4.close();							  
						  				if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  				{
						     				getRetCode = 88;   // Error Number  
							 				getErrBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 				out.println("getRetCode="+getRetCode+"&nbsp;"+"移站錯誤原因="+getErrBuffer+"<BR>");
						  				}							  
									}	  
									catch (Exception e) 
									{ 
										out.println("Exception2:"+e.getMessage()); 
									}  
		  						} 	 
							}
			 	
						boolean errPRImpFlag = false; // 針對非德錫,PR Requisition Import產生的錯誤判斷	
						if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新
						{ 	 
	      					//先取得欲執行產生PO之Responsibility ID_起
	     					Statement stateResp=con.createStatement();	   
	     					ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME like 'YEW_WIP_SEMI_SU%' "); 
	     					if (rsResp.next())
	     					{
	       						respID = rsResp.getString("RESPONSIBILITY_ID");
	     					} 
							else 
							{
	              				respID = "50835"; // 找不到則預設 --> YEW_WIP_SEMI_SU 預設
	            			}
			    			rsResp.close();
			    			stateResp.close();	  	
			       
				   			PreparedStatement stmtLogOSP=con.prepareStatement("insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
					                                                        " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																			" FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID ) "+ 
																	        " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																	        " '01','START','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																			" '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"' ) ");          	                	          
                    		stmtLogOSP.executeUpdate();
                    		stmtLogOSP.close();
			
							boolean oddOSPFlag = false;  // 針對德錫,需特別處理Interface	
		    				String sqlOSPInt = " select * from PO_REQUISITIONS_INTERFACE_ALL "+
			                                   " where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+  
		                                       " and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][5]+"' and NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' ";

							//out.println("<br>1.sqlOSPInt ="+sqlOSPInt);
							Statement stateOSPInt=con.createStatement();
            				ResultSet rsOSPInt=stateOSPInt.executeQuery(sqlOSPInt);
							if (rsOSPInt.next())
							{
			        			PreparedStatement stmtLogOSP2=con.prepareStatement("insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
					                                                             " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																				 " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID, SQL_LOG ) "+ 
																	             " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																	             " '02','PR Interface Create','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																			     " '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"', ? ) ");
								stmtLogOSP2.setString(1,sqlOSPInt);           	                	          
                    			stmtLogOSP2.executeUpdate();
                    			stmtLogOSP2.close();
			
			    				try
								{	
				 	 				String sqlJudgeOSP ="";
				  					if (jobType==null || jobType.equals("1"))
				  					{
			            				sqlJudgeOSP = " select b.DESCRIPTION, b.RESOURCE_CODE, b.COST_CODE_TYPE "+
                                      				  " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, "+
					                                  " BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d, APPS.YEW_RUNCARD_ALL e "+
                                                      " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
									                  " and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					                                  " and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					                                  " and d.OPERATION_SEQ_NUM = e.NEXT_OP_SEQ_NUM and e.RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' "+
									                  " and a.OPERATION_SEQUENCE_ID = e.NEXT_OP_SEQ_ID "+
					                                  " and b.COST_CODE_TYPE = 4 "+ // 為外包
									                  " and ( b.DESCRIPTION like '%德錫%' or b.RESOURCE_CODE like '%DA%') "; // 暫時使用Description 判斷是否要產生已核准PR,否則停在Interface
			 	  					} 
									else if (jobType.equals("2"))	
				         			{
						    			sqlJudgeOSP = " select DISTINCT d.DESCRIPTION, d.RESOURCE_CODE, d.COST_CODE_TYPE "+        			              
					                                  " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									                  " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									                  " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									                  " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
										              " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
									                  " and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' "+
									                  " and d.COST_CODE_TYPE = 4 and d.ORGANIZATION_ID ='"+organizationID+"' ";
						 			}			  
                  					
									Statement stateJudgeOSP=con.createStatement();
                  					ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
				  					if (rsJudgeOSP.next()) //  判斷若製程外包站為德錫,則需另更新Interface的Suggested Vendor ID, Suggested Vendor Site ID及
				  					{
				    					PreparedStatement stmtLogOSP3=con.prepareStatement(" insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
					                                                                       " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																				           " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID, SQL_LOG ) "+ 
																	                       " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																	                       " '03','PR Dexi','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																			               " '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"', ? ) ");          	                	          
										stmtLogOSP3.setString(1,sqlJudgeOSP); 														
                    					stmtLogOSP3.executeUpdate();
                    					stmtLogOSP3.close();
				    					oddOSPFlag = true;	
														
				  					} 
									else 
									{  
										// 一般外包廠商,系統開至PR完成後,由人員自行開立採購單_起
				            			int batchId = 0;
										String errPRIntMSG = "";
										String errPRIntCLN = "";							
										Statement stateBatchID=con.createStatement();
                            			ResultSet rsBatchID=stateBatchID.executeQuery("SELECT PR_INTERFACE_BATCH_ID_S.NEXTVAL FROM dual");
	                        			if (rsBatchID.next()) batchId = rsBatchID.getInt(1);
										rsBatchID.close();
										stateBatchID.close(); 
							    		int requestID = 0;
										String devStatus = "";
	                            		String devMessage = "";	
							    		try
										{    
											out.println("呼叫Requesition Import Request<BR>");
								     		CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
	                                 		cs1.setInt(1,batchId);  //*  Group ID 	
				                     		cs1.setString(2,userMfgUserID);    //  user_id 修改人ID /	
				                     		cs1.setString(3,respID);  //*  使用的Responsibility ID --> TSC_WIP_Semi_SU /				 
	                                 		cs1.registerOutParameter(4, Types.INTEGER); 
									 		cs1.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
				                     		cs1.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
	                                 		cs1.execute();
	                                 		requestID = cs1.getInt(4);
									 		devStatus = cs1.getString(5);    //  回傳 REQUEST 執行狀況
				                     		devMessage = cs1.getString(6);   //  回傳 REQUEST 執行狀況訊息
                                     		cs1.close();
										} 
                                		catch (SQLException e)
                                		{
                                 			out.println("Exception 呼叫Requesition Import Request產生PR:"+e.getMessage());
                                		}	
							    		
										// 取批次BatchID
										String  sqlPRError = " select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
								                             " from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
								                             " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
													         " and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
													         " and a.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID="+organizationID+" "; //20091123 liling 加destination_organization_id
							    		Statement statePRError=con.createStatement();
                                		ResultSet rsPRError=statePRError.executeQuery(sqlPRError);
	                            		if (rsPRError.next()) 
										{ 
								  			errPRIntCLN = rsPRError.getString(2);
								  			errPRIntMSG = rsPRError.getString(3);
								  			errPRImpFlag = true; // 錯誤旗標
								  
								  			out.println("<font color='#FF0000'>PR Requisition Import發生錯誤</font>!!!:錯誤欄位(<font color='#0033CC'>"+errPRIntCLN+"</font>)<BR>");
								  			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
								  			out.println("<font color='#FF0000'>錯誤訊息</font>:"+errPRIntMSG+"<BR>");								  
										} 
										else 
										{
								        	out.println("Success Submit Requisition Import Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)<BR>");
											out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
											String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' ";
											Statement statePRNo=con.createStatement();
                                        	ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
	                                    	if (rsPRNo.next()) 
								        	{  
										   		out.println("<BR><font color='FF0099'>產生PR號碼</font>=<font color='FF0000'>"+rsPRNo.getString("SEGMENT1")+"</font><BR>");	
										   		PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' ");          
	                                       		stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No於流程卡檔	                         	          
							               		stmtLinkRC.setInt(2,batchId);							               
                                           		stmtLinkRC.executeUpdate();
                                           		stmtLinkRC.close(); 
											} 
											rsPRNo.close();
											statePRNo.close();						 
								       	} 
							    		rsPRError.close();
							    		statePRError.close();     
				         			}
				  					rsJudgeOSP.close();
				  					stateJudgeOSP.close();
               					}
                				catch (Exception e)
                				{
                 					out.println("Exception 取Routing對應的資源判斷是否為德錫:"+e.getMessage());
                				}	  
							}
							else 
							{ 
			       				if (jobType.equals("1"))
				   				{
								  	%>
								  	<script language="javascript">
										alert("              找不到產生的PR_Interface\n 此外包站資源設定有誤,請洽MIS查找原因 !!!");
								  	</script>			  
								  	<%	
				   				}
			       				else if (jobType.equals("2"))
			        			{
									%>
									<script language="javascript">
										alert("       重工工令找不到產生的PR_Interface\n       可能未產生此外包請購單 !!!");
									</script>			  
									<%	
				    			}
			     			}
							rsOSPInt.close();
							stateOSPInt.close();			    
		
		                    // 判斷PO_PR_異常_起
							Statement stateRQErr=con.createStatement();
							ResultSet rsRQErr=stateRQErr.executeQuery(" select ERROR_MESSAGE, COLUMN_NAME from  PO_INTERFACE_ERRORS "+
							                                          " where INTERFACE_TRANSACTION_ID = (select DISTINCT TRANSACTION_ID from PO_REQUISITIONS_INTERFACE_ALL "+
							                                          " where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									                                  " and NOTE_TO_RECEIVER='"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][5]+"' ) ");
						    if (rsRQErr.next())	
							{
								out.println("<font color='#FF0000'>REQ Import Error Message("+rsRQErr.getString(1)+");Error Coulmn("+rsRQErr.getString(2)+")</font>");
							}
							rsRQErr.close();
						    stateRQErr.close();																			   
						}
		 
        				// 若報廢及移站都成功,則更新RUNCARD 資料表相關欄位
						if (getRetScrapCode==0 && getRetCode==0)
						{
							boolean singleOp = false;  // 預設本站不為最後一站
		    				String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			      				  " DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					                      " from WIP_OPERATIONS "+
						                  " where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id='"+organizationID+"' ";	 
	        				Statement statep=con.createStatement();
            				ResultSet rsp=statep.executeQuery(sqlp);
	        				if (rsp.next())
	        				{
		     					operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
			    				operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			    				standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			    				standardOpDesc 	  = rsp.getString("DESCRIPTION");
			    				previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			    				nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
			    				if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
			    				if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
			    				if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";
			    				if (nextOpSeqNum==null || nextOpSeqNum.equals(""))
								{
				   					nextOpSeqNum = "0";		
				   					singleOp = true;
								}	
	        				} 
							else 
							{
	                 			operationSeqNum   = "0";
				     			operationSeqId    = "0";
				     			standardOpId  	  = "0";
				     			standardOpDesc   = "0"; 
	                 			previousOpSeqNum  = "0"; 
				    	 		nextOpSeqNum	  = "0"; 
					 			// 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
					 			Statement stateMax=con.createStatement();
                     			ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id='"+organizationID+"' ");
					 			if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
					 			{
					   				singleOp = true;						   			   
					 			}
					 			rsMax.close();
					 			stateMax.close();			 
	               			}
	               			rsp.close();
                   			statep.close();				   
				   
	   						String SqlQueueTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				                                 " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				                                 " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           						 " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				                                 " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						                         " LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
				                                 " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
           					PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
           					queueTransStmt.setInt(1,Integer.parseInt(aMFGRCExpTransCode[i][0])); // RUNCAD_ID          
	       					queueTransStmt.setString(2,aMFGRCExpTransCode[i][1]);                // RUNCARD_NO
           					queueTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       					queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       					queueTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
           					queueTransStmt.setInt(6,Integer.parseInt(aMFGRCExpTransCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
		   					queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           					queueTransStmt.setInt(8,Integer.parseInt(aMFGRCExpTransCode[i][5])); //TO_OPERATION_SEQ_NUM(下一站) 
	       					queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	       					queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCExpTransCode[i][2]));  // Transaction Qty
	       					queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       					queueTransStmt.setInt(12,1);             // 1=Queue		  
	       					queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       					queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       					queueTransStmt.setString(15,"042");      // From STATUSID
		   					queueTransStmt.setString(16,"GENERATED");	  // From STATUS
		   					queueTransStmt.setString(17,fndUserName);	  // Update User  
           					queueTransStmt.executeUpdate();
           					queueTransStmt.close();	    	 
		 
		 					if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
		 					{		 
		     					String SqlScrapTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           							 " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           							 " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           							 " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				           							 " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						   							 " LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
				                                     " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
           						PreparedStatement scrapTransStmt=con.prepareStatement(SqlScrapTrans); 
           						scrapTransStmt.setInt(1,Integer.parseInt(aMFGRCExpTransCode[i][0])); // RUNCAD_ID          
	       						scrapTransStmt.setString(2,aMFGRCExpTransCode[i][1]);                // RUNCARD_NO
           						scrapTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       						scrapTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       						scrapTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
           						scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCExpTransCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
		   						scrapTransStmt.setString(7,standardOpDesc);                                      //  FM_OPERATION_CODE	       	   
           						scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCExpTransCode[i][4])); //TO_OPERATION_SEQ_NUM(下一站) 
	       						scrapTransStmt.setString(9,standardOpDesc);                                      //TO_OPERATION_CODE(下一站代碼) 
	       						scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
	       						scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       						scrapTransStmt.setInt(12,5);             // 5=SCRAP(報廢)		  
	       						scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       						scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
		   						scrapTransStmt.setString(15,"042"); // From STATUSID
		   						scrapTransStmt.setString(16,"GENERATED");	  // From STATUS		   
		   						scrapTransStmt.setString(17,fndUserName);	  // Update User  
           						scrapTransStmt.executeUpdate();
           						scrapTransStmt.close();	    	 
		 					}	

           					String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?,  "+
		                                 " QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
						                 " QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+ //20090603 liling add RES_EMPLOYEE_OP清為空白,移站時才會抓系統日
		                                 " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
           					PreparedStatement rcStmt=con.prepareStatement(rcSql);
	       					rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	       					rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		   					if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
		   					{
	         					rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
	         					rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
		   					} 
							else 
							{
		            			rcStmt.setString(3,"045"); 
	                			rcStmt.setString(4,"OSPRECEIVING");
		          			}
		   					rcStmt.setFloat(5,rcScrapQty); 
		   					rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 
		   					rcStmt.setInt(7,Integer.parseInt(standardOpId));
		   					rcStmt.setString(8,standardOpDesc);
		   					rcStmt.setInt(9,Integer.parseInt(operationSeqId));
		   					rcStmt.setInt(10,Integer.parseInt(operationSeqNum));
		   					rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
		   					rcStmt.setFloat(12,Float.parseFloat(aMFGRCExpTransCode[i][2]));  // Transaction Qty
		   					rcStmt.setFloat(13,Float.parseFloat(aMFGRCExpTransCode[i][2])+rcScrapQty);  // 處理數
           					rcStmt.executeUpdate();   
           					rcStmt.close(); 
		 				}
		 				else 
						{
		        			interfaceErr = true;  // 表示報廢或移站Interface有異常,則JavaScript告知使用者
		      			}  
					}
	   			}
	  		}
	     	
			if (jobType.equals("2"))
		 	{
	        	con.commit();
	            int cc=0;
				while (true)
				{
					java.lang.Thread.sleep(5000);	 // 每作完一筆PR Import延遲五*4秒,等待Concurrent執行完畢,取結果判斷				 
					System.err.println("count:"+cc+" waiting......;");
					if (cc>3) //若等待時間超過20秒則停止作業(設PR Import20秒之內結束)
					{	    
						System.err.println("完成等待!!");
						break; 	    
					}	
					cc++;					  
				}
			}
     	}
	} 
	
	out.print("<font color='#0033CC'>流程卡已投產O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	if (!nextOpSeqNum.equals("0") && !interfaceErr) // 下一站不為最後一站且報廢或移站Interface無異常
	{
	%>
		<script LANGUAGE="JavaScript">
	       alert("流程卡移至委外加工(OSPRECEIVING)");
	   	</script>
	<%	
	} 
	else 
	{	        
	%>
		<script LANGUAGE="JavaScript">
	    	alert("Oracle報廢或移站異常,請洽MIS查明原因!!!");
	    </script>
	<%				 
	}
	
	// 使用完畢清空 2維陣列
    if (aMFGRCExpTransCode!=null)
	{ 
		arrMFGRCExpTransBean.setArray2DString(null); 
	}
}

if (actionID.equals("023") && fromStatusID.equals("044"))   // 如為n站, 第2站 --> 第 n-1 站(表示第k站為委外加工站-->產生PR入Interface)
{  
	String fndUserName = "";  //處理人員
	String woUOM = ""; // 工令移站單位
	int primaryItemID = 0;
    float runCardQtyf=0,overQty=0; 
	entityId = "0"; // 工令wip_entity_id
	boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
    if (aMFGRCMovingCode!=null)
	{	  
		if (aMFGRCMovingCode.length>0)
	  	{    
			String sqlfnd = " select USER_NAME from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 						    " where A.USER_NAME = UPPER(B.USERNAME)  and A.USER_ID = '"+userMfgUserID+ "'";
			Statement stateFndId=con.createStatement();
            ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
			if (rsFndId.next())
			{
				fndUserName = rsFndId.getString("USER_NAME"); 
			}
			rsFndId.close();
			stateFndId.close();
		   
		   	//抓取移站數量的單位_起	                     
			String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID , b.RUNCARD_QTY from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 						    " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
			Statement stateUOM=con.createStatement();
            ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
			if (rsUOM.next())
			{
				woUOM = rsUOM.getString("WO_UOM");
				entityId =  rsUOM.getString("WIP_ENTITY_ID");
				primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
				runCardQtyf = rsUOM.getFloat("RUNCARD_QTY");
			}
			rsUOM.close();
			stateUOM.close();
	       	//抓取移站數量的單位_迄   
	  	}
	  
	  	for (int i=0;i<aMFGRCMovingCode.length-1;i++)
	  	{
	   		for (int k=0;k<=choice.length-1;k++)    
       		{ 
	    		if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
	    		{
		  			if (Float.parseFloat(aMFGRCMovingCode[i][2])>0) // 若設定移站數量大於0才進行移站及報廢 
		  			{
		  				int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   				int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   				if (aMFGRCMovingCode[i][5]==null || aMFGRCMovingCode[i][5]=="0" || aMFGRCMovingCode[i][5].equals("0")) 
		   				{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
		     				toIntOpSType = 3; 
		     				aMFGRCMovingCode[i][5] = aMFGRCMovingCode[i][4]; // 無下一站的Seq No,故給本站
			 				transType = 2;
		   				} 
		   
		   				//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
		   				float  rcMQty = 0;   
		   				float  rcScrapQty = 0;   
		   				java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
		   					 
						String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY , b.RES_EMPLOYEE_OP "+
						                 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
 									     "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and c.organization_id = a.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+  //20091123 liling add organization_id
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // 取QUEUE移站數量
										 "     and b.RUNCARD_NO='"+aMFGRCMovingCode[i][1]+"' and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][3]+"' ";				 
						//out.println("sqlMQty ="+sqlMQty);				 
						Statement stateMQty=con.createStatement();
                        ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						if (rsMQty.next())
						{
							if (aMFGRCMovingCode[i][2]==null || aMFGRCMovingCode[i][2].equals("null")) aMFGRCMovingCode[i][2]=Float.toString(rcMQty);
						   	rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//原前站完工數量	
                           	txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 移站日期
						   	rcScrapQty = rcMQty - Float.parseFloat(aMFGRCMovingCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   
						   
						    String strScrapQty = nf.format(rcScrapQty);
							java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
							java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							rcScrapQty =scrapQty.floatValue();
						}
						rsMQty.close();
						stateMQty.close();

        				if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null")) txnDate=systemDate;  //20090605 liling 增加若沒key就預設systemdate
		 
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

		 				String getErrScrapBuffer = "";
		 				int getRetScrapCode = 0;
		 				if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
		 				{	
		   					toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
		   					transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
           					String SqlScrap=" insert into WIP_MOVE_TXN_INTERFACE( "+
				                            " CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				                            " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				                            " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				                            " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
						                    " GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
				                            " values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?, WIP_TRANSACTIONS_S.NEXTVAL,?,?,WIP_TRANSACTIONS_S.NEXTVAL ) ";   
           					PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
           					scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
	       					scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           					scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       					scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       					scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           					scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 改為 Running )      
		   					scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>流程卡:"+aMFGRCMovingCode[i][1]+"(2.報廢數量="+rcScrapQty+")  ");// 移站報廢數量	       	   
           					scrapstmt.setString(8,woUOM);
	       					scrapstmt.setInt(9,Integer.parseInt(entityId));  
	       					scrapstmt.setString(10,woNo);  
	       					scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       					scrapstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(本站)		  
	       					scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       					scrapstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][4])); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
	       					scrapstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
		   					scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   					scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)報廢  ( 01-11-000-7650-951-0-000 ) 
		   					scrapstmt.setInt(18,7);	// REASON_ID  製程異常
           					scrapstmt.executeUpdate();
           					scrapstmt.close();	      	
		   
		   					//抓取寫入Interface的Group等資訊_起
	       					int groupID = 0;
		   					int opSeqNo = 0;              
						 	String sqlGrp = " select WIP_TRANSACTIONS_S.CURRVAL as GROUP_ID, 1 as TO_OPERATION_SEQ_NUM from DUAL ";				 
						 	Statement stateGrp=con.createStatement();
                         	ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 	if (rsGrp.next())
						 	{
						   		groupID = rsGrp.getInt("GROUP_ID");
						   		opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 	}
						 	rsGrp.close();
						 	stateGrp.close();

		 					if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 					{
		   						int procPhase = 1;
		   						int timeOut = 10;
		   						try
		   						{	
					      			CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              			cs5.setInt(1,groupID);                                         //  Org ID 	
			              			cs5.setString(2,null);   // BackFlush Setup    
			              			cs5.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              			cs5.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              			cs5.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              			cs5.execute();					      
			              			String getMoveStatus = cs5.getString(4);		
			              			String getMoveErrorMsg = cs5.getString(5);								      				    
			              			cs5.close();	
								  
						  			if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  			{
						     			getRetScrapCode = 77;   // Error Number  
							 			getErrScrapBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 			out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"報廢錯誤原因="+getErrScrapBuffer+"<BR>");
						  			}							  					  
								}	  
								catch (Exception e) 
								{ 
									out.println("Exception4:"+e.getMessage()); 
								}  
		  					}
		 				}
		 
						String getErrBuffer = "",overFlag="";
						int getRetCode = 0; 
						float prevQty = 0; 		   		      		   		     
						if (getRetScrapCode==0)   // 若本站報廢成功,則進行移站Interface
						{ 
							// 再判斷是否已超過該站可移站數,若是,則亦表示OverComp_起--表示工令可用移站數
							float remainQueueQty=0;
							Statement stateRM=con.createStatement();
							ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id='"+organizationID+"' and OPERATION_SEQ_NUM = "+aMFGRCMovingCode[i][4]+" ");  //20091123 liling add organization_id
							if (rsRM.next()) { remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); }
							rsRM.close();
							stateRM.close();
							
							String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
										  "  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCMovingCode[i][3]+"' "+
										  "  and runcard_no = '"+aMFGRCMovingCode[i][1]+"' ";
							// out.print("sqlpre="+sqlpre);
							Statement statepre=con.createStatement();
							ResultSet rspre=statepre.executeQuery(sqlpre);
							if (rspre.next())
							{
								prevQty = rspre.getFloat(1);  //前次移站數
							}
							rspre.close();
							statepre.close();

							//add by Peggy 20140324
							if (rcScrapQty >0)
							{
								//prevQty	=prevQty -Float.parseFloat("0"+rcScrapQty);
								//解決浮點數計算問題,add by Peggy 20140417
								prevQty	=(prevQty*1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
								prevQty = prevQty/1000;

							}
							if (prevQty<0) prevQty=0;
							//out.println("aMFGRCExpTransCode[i][2]="+aMFGRCExpTransCode[i][2]);
							//out.println("prevQty="+prevQty);
							//out.println("remainQueueQty="+remainQueueQty);
							//out.println("prevQty="+prevQty);
							
							
							if (Float.parseFloat(aMFGRCMovingCode[i][2]) > prevQty && remainQueueQty > Float.parseFloat(aMFGRCMovingCode[i][2]))   //2007/04/11_By Kerwin
							{
								//overQty = Float.parseFloat(aMFGRCMovingCode[i][2]) - prevQty ;    //移站數-流程卡數=超出數量
								//解決浮點數計算問題,add by Peggy 20140417
								overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000) - (prevQty *1000);
								overQty = overQty /1000;
								overFlag = "Y";   //給定超收的flag
								//out.println("31.overQty="+overQty);
							} 
							else  
							{
								if (Float.parseFloat(aMFGRCMovingCode[i][2]) > remainQueueQty)
								{
									//overQty = Float.parseFloat(aMFGRCMovingCode[i][2])-remainQueueQty; 
									//解決浮點數計算問題,add by Peggy 20140417
									overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000)-(remainQueueQty*1000);
									overQty = overQty /1000;
									overFlag = "Y";   //給定超收的flag
									//out.println("32.overQty="+overQty);
								} 
								else 
								{
									overFlag = "N"; 
								}		
							}
	
							toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1
							String Sqlrc="";
							String Sqlrc1=" insert into WIP_MOVE_TXN_INTERFACE( "+
										  " CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
										  " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
										  " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
										  " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
							String Sqlrc2=" ,OVERCOMPLETION_TRANSACTION_QTY ";
							String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
							String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
							String Sqlrcv5= " ) ";
	 
							if (overFlag == "Y" || overFlag.equals("Y"))
							{ 
								Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; 
							}
							else
							{ 
								Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; 
							}
							PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
							seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
							seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
							seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
							seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
							seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
							seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/08 改為 Running )
							seqstmt.setFloat(7,Float.parseFloat(aMFGRCMovingCode[i][2])); // 移站數量
							seqstmt.setString(8,woUOM);
							seqstmt.setInt(9,Integer.parseInt(entityId));  
							seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
							seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
							seqstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
							seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
							seqstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
							seqstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
							seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (overFlag == "Y" || overFlag.equals("Y"))
							{ 
								seqstmt.setFloat(17,overQty); 
							} // OVERCOMPLETION_TRANSACTION_QTY   
							seqstmt.executeUpdate();
							seqstmt.close();	      	
		   
							//抓取寫入Interface的Group等資訊_起
							int groupID = 0;
							int opSeqNo = 0;              
							String sqlGrp = " select WIP_TRANSACTIONS_S.CURRVAL as GROUP_ID, 1 as TO_OPERATION_SEQ_NUM from DUAL ";
							Statement stateGrp=con.createStatement();
							ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
							if (rsGrp.next())
							{
								groupID = rsGrp.getInt("GROUP_ID");
								opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
							}
							rsGrp.close();
							stateGrp.close();
						 
							if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
							{
								int procPhase = 1;
								int timeOut = 10;
								try
								{	
									CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
									cs4.setInt(1,groupID);                                         //  Org ID 	
									cs4.setString(2,null);   // BackFlush Setup    
									cs4.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
									cs4.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
									cs4.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
									cs4.execute();					      
									String getMoveStatus = cs4.getString(4);		
									String getMoveErrorMsg = cs4.getString(5);								      				    
									cs4.close();										
										  
									if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
									{
										getRetCode = 88;   // Error Number  
										getErrBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
										out.println("getRetCode="+getRetCode+"&nbsp;"+"移站錯誤原因="+getErrBuffer+"<BR>");
									}							  
								}	  
								catch (Exception e) 
								{ 
									out.println("Exception5:"+e.getMessage()); 
								}  
							}
						}
						
						boolean errPRImpFlag = false; // 針對非德錫,PR Requisition Import產生的錯誤判斷	
						if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行PR Interface異動更新
						{ 	
							//先取得欲執行產生PO之Responsibility ID_起
							Statement stateResp=con.createStatement();	   
							ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME = 'YEW_WIP_SEMI_SU' "); 
							if (rsResp.next())
							{
								respID = rsResp.getString("RESPONSIBILITY_ID");
							} 
							else 
							{
								respID = "50767"; // 找不到則預設 --> YEW WIP Super User 預設
							}
							rsResp.close();
							stateResp.close();	  	
						 
							PreparedStatement stmtLogOSP=con.prepareStatement(" insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
																			  " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																			  " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID ) "+ 
																			  " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																			  " '01','START','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																			  " '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"' ) ");          	                	          
							stmtLogOSP.executeUpdate();
							stmtLogOSP.close();
			
							boolean oddOSPFlag = false;  // 針對德錫,需特別處理Interface			
							String sqlOSPInt = " select * from PO_REQUISITIONS_INTERFACE_ALL "+
											   " where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
											   " and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][5]+"' and NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' "; //20091123 liling 加note_to_receiver
							//out.println("sqlOSPInt ="+sqlOSPInt);
							Statement stateOSPInt=con.createStatement();
							ResultSet rsOSPInt=stateOSPInt.executeQuery(sqlOSPInt);
							if (rsOSPInt.next())
							{
								PreparedStatement stmtLogOSP2=con.prepareStatement(" insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
																			   " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																			   " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID, SQL_LOG ) "+ 
																			   " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																			   " '02','PR Interface Create','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																			   " '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"', ? ) ");
								stmtLogOSP2.setString(1,sqlOSPInt);          	                	          
								stmtLogOSP2.executeUpdate();
								stmtLogOSP.close();
								try
								{
									String sqlJudgeOSP =" select b.DESCRIPTION, b.RESOURCE_CODE, b.COST_CODE_TYPE "+
										  " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, "+
										  "      BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d, APPS.YEW_RUNCARD_ALL e "+
										  " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
										  // "   and b.ORGANIZATION_ID = '"+organizationID+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
										  "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
										  "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
										  "   and d.OPERATION_SEQ_NUM = e.NEXT_OP_SEQ_NUM "+ //e.NEXT_OP_SEQ_NUM "+
										  "   and e.RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' "+
										  "   and a.OPERATION_SEQUENCE_ID = e.NEXT_OP_SEQ_ID "+
										  "   and b.COST_CODE_TYPE = 4 "+ // 為外包
										  "   and ( b.DESCRIPTION like '%德錫%' or b.RESOURCE_CODE like 'DA%') "; // 暫時使用Description 判斷是否要產生已核准PR,否則停在Interface
									//out.println(sqlJudgeOSP+"<BR>");					   
									Statement stateJudgeOSP=con.createStatement();
									ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
									if (rsJudgeOSP.next()) //  判斷若製程外包站為德錫,則需另更新Interface的Suggested Vendor ID, Suggested Vendor Site ID及
									{
										PreparedStatement stmtLogOSP3=con.prepareStatement(" insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
																						   " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																						   " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID, SQL_LOG ) "+ 
																						   " values('"+woNo+"','"+aMFGRCMovingCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																						   " '03','PR Dexi','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCMovingCode[i][9]+"','"+aMFGRCMovingCode[i][4]+"','"+aMFGRCMovingCode[i][10]+"', "+
																						   " '"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][3]+"','"+aMFGRCMovingCode[i][5]+"','"+aMFGRCMovingCode[i][5]+"', ? ) "); 
										stmtLogOSP3.setString(1,sqlJudgeOSP);         	                	          
										stmtLogOSP3.executeUpdate();
										stmtLogOSP3.close();
										
										oddOSPFlag = true;	
										out.println(aMFGRCMovingCode[i][1]+" 移站(Moving)德錫外包寫入PR Interface,等待REQ IMP執行<BR>");
																
									} 
									else 
									{  // 一般外包廠商,系統開至PR完成後,由人員自行開立採購單_起
										out.println("一般外包廠商PR Interface,並產生PR<BR>");
										int batchId = 0;
										String errPRIntMSG = "";
										String errPRIntCLN = "";							
									
										// 取批次BatchID
										Statement stateBatchID=con.createStatement();
										ResultSet rsBatchID=stateBatchID.executeQuery("SELECT PR_INTERFACE_BATCH_ID_S.NEXTVAL FROM dual");
										if (rsBatchID.next()) batchId = rsBatchID.getInt(1);
										rsBatchID.close();
										stateBatchID.close(); 
								  
										// 一般委外加工,呼叫REQUISITION IMPORT REQUEST產生PR_起
										int requestID = 0;	
										String devStatus = "";
										String devMessage = "";						
										try
										{    
											out.println("呼叫Requesition Import Request<BR>");
											CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
											cs1.setInt(1,batchId);  //*  Group ID 	
											cs1.setString(2,userMfgUserID);    //  user_id 修改人ID /	
											cs1.setString(3,respID);  //*  使用的Responsibility ID --> TSC_WIP_Semi_SU /				 
											cs1.registerOutParameter(4, Types.INTEGER); 
											cs1.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
											cs1.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
											cs1.execute();
											requestID = cs1.getInt(4);
											devStatus = cs1.getString(5);    //  回傳 REQUEST 執行狀況
											devMessage = cs1.getString(6);   //  回傳 REQUEST 執行狀況訊息
											cs1.close();
										} //end of try
										catch (SQLException e)
										{
											out.println("Exception 呼叫Requesition Import Request產生PR:"+e.getMessage());
										}	
									
										// 取批次BatchID
										String  sqlPRError = "select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
															 "  from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
															 " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
															 "   and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
															 "   and a.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID="+organizationID+" ";  //20091123 加 note_toreeiver and destination_organization_id
										Statement statePRError=con.createStatement();
										ResultSet rsPRError=statePRError.executeQuery(sqlPRError);
										if (rsPRError.next()) 
										{ 
											errPRIntCLN = rsPRError.getString(2);
											errPRIntMSG = rsPRError.getString(3);
											errPRImpFlag = true; // 錯誤旗標
										  
											out.println("<font color='#FF0000'>PR Requisition Import發生錯誤</font>!!!:錯誤欄位(<font color='#0033CC'>"+errPRIntCLN+"</font>)<BR>");
											out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
											out.println("<font color='#FF0000'>錯誤訊息</font>:"+errPRIntMSG+"<BR>");	
											break;  // break for loop 如有錯誤,則不執行單據狀態更新							  
										} 
										else 
										{							        							
											out.println("Success Submit Requisition Import Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)  ");
											out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
											String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' ";
											out.println("sqlPRNo ="+sqlPRNo+"<BR>");
											Statement statePRNo=con.createStatement();
											ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
											if (rsPRNo.next()) 
											{  
												out.println("<BR><font color='FF0099'>產生PR號碼</font>=<font color='FF0000'>"+rsPRNo.getString("SEGMENT1")+"</font><BR>");	
												PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' ");          
												stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No於流程卡檔	                         	          
												stmtLinkRC.setInt(2,batchId);							               
												stmtLinkRC.executeUpdate();
												stmtLinkRC.close(); 
											} 
											rsPRNo.close();
											statePRNo.close();						 
										} 
										rsPRError.close();
										statePRError.close();     
									} 
									rsJudgeOSP.close();
									stateJudgeOSP.close();
								}
								catch (Exception e)
								{
									out.println("Exception 取Routing對應的資源判斷是否為德錫:"+e.getMessage());
								}	  
							} 
							else 
							{
							%>
								<script language="javascript">
									alert("              找不到產生的PR_Interface\n 此外包站資源設定有誤或未產生PR !!!");
								</script>			  
							<%		
							}
							rsOSPInt.close();
							stateOSPInt.close();	
						
							// 判斷PO_PR_異常_起
							Statement stateRQErr=con.createStatement();
							ResultSet rsRQErr=stateRQErr.executeQuery(" select ERROR_MESSAGE, COLUMN_NAME from  PO_INTERFACE_ERRORS "+
																	  " where INTERFACE_TRANSACTION_ID in (select DISTINCT TRANSACTION_ID from PO_REQUISITIONS_INTERFACE_ALL "+
																	  " where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
																	  " and NOTE_TO_RECEIVER='"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][5]+"' ) ");
							if (rsRQErr.next())	
							{
								out.println("<font color='#FF0000'>REQ Import Error Message("+rsRQErr.getString(1)+");Error Coulmn("+rsRQErr.getString(2)+")</font>");
							}
							rsRQErr.close();
							stateRQErr.close();																			   
						}
					
						if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新
						{ 
							boolean singleOp = false;  // 預設本站不為最後一站
							String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
										  " DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
										  "  from WIP_OPERATIONS "+
										  "  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id='"+organizationID+"' ";	  //20091123 liling add organization_id
							Statement statep=con.createStatement();
							ResultSet rsp=statep.executeQuery(sqlp);
							if (rsp.next())
							{
								operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
								operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
								standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
								standardOpDesc 	  = rsp.getString("DESCRIPTION");
								previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
								nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
								if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
								if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
								if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";
								if (nextOpSeqNum==null || nextOpSeqNum.equals(""))
								{ 
									nextOpSeqNum = "0";		
									singleOp = true;
								}  	
							} 
							else 
							{
								operationSeqNum   = "0";
								operationSeqId    = "0";
								standardOpId  	  = "0";
								standardOpDesc   = "0"; 
								previousOpSeqNum  = "0"; 
								nextOpSeqNum	  = "0"; 
								// 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
								Statement stateMax=con.createStatement();
								ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"'  and WIP_ENTITY_ID ="+entityId+" and organization_id='"+organizationID+"'  ");  //20091123 liling add organization_id
								if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
								{
									singleOp = true;					   
								} else out.println("下一站代碼="+rsMax.getString(1)+"<BR>");
								rsMax.close();
								stateMax.close();
							}
							rsp.close();
							statep.close(); 				   
					   
							String SqlQueueTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
												 " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
												 " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
												 " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
												 " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
												 " LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
												 " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
							PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
							queueTransStmt.setInt(1,Integer.parseInt(aMFGRCMovingCode[i][0])); // RUNCAD_ID          
							queueTransStmt.setString(2,aMFGRCMovingCode[i][1]);                // RUNCARD_NO
							queueTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
							queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
							queueTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
							queueTransStmt.setInt(6,Integer.parseInt(aMFGRCMovingCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
							queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
							queueTransStmt.setInt(8,Integer.parseInt(aMFGRCMovingCode[i][5])); //TO_OPERATION_SEQ_NUM(下一站) 
							queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
							queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCMovingCode[i][2]));  // Transaction Qty
							queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
							queueTransStmt.setInt(12,1);             // 1=Queue		  
							queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
							queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
							queueTransStmt.setString(15,"044"); // From STATUSID
							queueTransStmt.setString(16,"MOVING");	  // From STATUS
							queueTransStmt.setString(17,fndUserName);	  // Update User  
							queueTransStmt.executeUpdate();
							queueTransStmt.close();	    	 
			 
							if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
							{ 		 
								String SqlScrapTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													 " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													 " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													 " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													 " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													 " LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
													 " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
								PreparedStatement scrapTransStmt=con.prepareStatement(SqlScrapTrans); 
								scrapTransStmt.setInt(1,Integer.parseInt(aMFGRCMovingCode[i][0])); // RUNCAD_ID          
								scrapTransStmt.setString(2,aMFGRCMovingCode[i][1]);                // RUNCARD_NO
								scrapTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
								scrapTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
								scrapTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
								scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCMovingCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
								scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
								scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCMovingCode[i][4])); //TO_OPERATION_SEQ_NUM(下一站) 
								scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(下一站代碼) 
								scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
								scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
								scrapTransStmt.setInt(12,5);             // 5=SCRAP(報廢)		  
								scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
								scrapTransStmt.setString(15,"044"); // From STATUSID
								scrapTransStmt.setString(16,"MOVING");	  // From STATUS
								scrapTransStmt.setString(17,fndUserName);	  // Update User  
								scrapTransStmt.executeUpdate();
								scrapTransStmt.close();	    	 
							}
	
							/* Test for debug */
							String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
										 " QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
										 " QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP清為空白,移站時才會抓系統日
										 " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCMovingCode[i][0]+"' "; 	
							PreparedStatement rcStmt=con.prepareStatement(rcSql);
							rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
							rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
							if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (045) 流程卡委外加工中
							{
								rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
								rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
							} 
							else 
							{ 	// 否則,即更新至 045 完工入庫
								rcStmt.setString(3,"045"); 
								rcStmt.setString(4,"OSPRECEIVING");
							}
							rcStmt.setFloat(5,rcScrapQty); 
							rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 
							rcStmt.setInt(7,Integer.parseInt(standardOpId));
							rcStmt.setString(8,standardOpDesc);
							rcStmt.setInt(9,Integer.parseInt(operationSeqId));
							rcStmt.setInt(10,Integer.parseInt(operationSeqNum));
							rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
							rcStmt.setFloat(12,Float.parseFloat(aMFGRCMovingCode[i][2]));  // Transaction Qty
							rcStmt.setFloat(13,Float.parseFloat(aMFGRCMovingCode[i][2])+rcScrapQty);  // 處理數
							rcStmt.executeUpdate();   
							rcStmt.close(); 
						}
						else 
						{
							interfaceErr = true; // 報廢及移站有異常
						}  
					}
				}
			}
			con.commit();
		} // End of for (i=0;i<aMFGRCMovingCode.length;i++)
	} // end of if (aMFGRCMovingCode!=null) 
	
  	if (!interfaceErr) // 若報廢或移站皆無異常
  	{
		if (!nextOpSeqNum.equals("0"))
		{
	 	%>
	   	<script LANGUAGE="JavaScript">
	    	alert("流程卡移至委外加工(045 OSPRECEIVING)");
	   	</script>
	 	<%	
		} 
		else 
		{
	    %>
	    <script LANGUAGE="JavaScript">
			alert("已達Rounting最後一站,委外加工採購收料");
	    </script>
	    <%
	   	}
   	}
   	else 
	{ // 若報廢或移站皆無異常
    %>
		<script LANGUAGE="JavaScript">
	    	alert("Oracle報廢或移站異常,請洽MIS查明原因!!!");
	    </script>
	<%
   	}	
	out.print("<BR><font color='#0033CC'>流程卡移移至委外加工O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	
	// 使用完畢清空 2維陣列
    if (aMFGRCMovingCode!=null)
	{ 
		arrMFGRCMovingBean.setArray2DString(null); 
	}
} 

//MFG流程卡完工入庫_起	(ACTION=018) RECEIVE 選擇繼續移站  流程卡移站中045 --> 流程卡完工入庫046且此為委外加工站(已判斷本站為最後一站,如為最後一站,則收料後,會自動作TO_MOVE)
if ((actionID.equals("006") || actionID.equals("018")) && fromStatusID.equals("045"))   // 如為 n站, 即第 n-1站 --> 第 n 站(最後一站)
{  //out.print("actionID="+actionID+"<BR>");
	String fndUserName = "";  //處理人員
	String fndUserID = ""; //處理人員ID (3077)
	String employeeID = ""; // 處理人員工號ID(2487)
	String woUOM = ""; // 工令移站單位
	String compSubInventory = null;
	int primaryItemID = 0;
    float runCardQtyf=0,overQty=0; 
	entityId = "0"; // 工令wip_entity_id
	boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
    if (aMFGRCPOReceiptCode!=null)
	{	  
		if (aMFGRCPOReceiptCode.length>0)
	  	{    
			String sqlfnd = " select A.USER_ID,A.USER_NAME,A.EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 			  		        " where A.USER_NAME = UPPER(B.USERNAME) and A.USER_ID = '"+userMfgUserID+ "'";
			Statement stateFndId=con.createStatement();
            ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
			if (rsFndId.next())
			{
				fndUserName = rsFndId.getString("USER_NAME");
				fndUserID = rsFndId.getString("USER_ID"); 
				employeeID = rsFndId.getString("EMPLOYEE_ID"); 
			}
			rsFndId.close();
			stateFndId.close();

			String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID, b.RUNCARD_QTY ,a.COMPLETION_SUBINVENTORY from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 			 		        " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
			Statement stateUOM=con.createStatement();
            ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
			if (rsUOM.next())
			{
				woUOM = rsUOM.getString("WO_UOM");
				entityId =  rsUOM.getString("WIP_ENTITY_ID");
				primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
				runCardQtyf = rsUOM.getFloat("RUNCARD_QTY");
                compSubInventory = rsUOM.getString("COMPLETION_SUBINVENTORY");	  // 入庫subInventory
			}
			rsUOM.close();
			stateUOM.close();
	  	}
	  
	  	for (int i=0;i<aMFGRCPOReceiptCode.length-1;i++)
	  	{
	   		for (int k=0;k<=choice.length-1;k++)    
       		{
	    		// 判斷被Check 的Line 才執行指派作業
	    		if (choice[k]==aMFGRCPOReceiptCode[i][0] || choice[k].equals(aMFGRCPOReceiptCode[i][0]))
	    		{   
          			// 20091217 Marvie Add : yew_runcard_restxns data loss
		  			boolean rCardResExt = false;
	      			Statement stateExist=con.createStatement();	 
		  			ResultSet rsRCResExt=stateExist.executeQuery(" select RUNCARD_NO from YEW_RUNCARD_RESTXNS "+
			                                                     "  where WO_NO='"+woNo+"' and RUNCARD_NO='"+aMFGRCPOReceiptCode[i][1]+"' "+
												                 "  and OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"'  ");
		  			if (rsRCResExt.next()) rCardResExt = true;
		  			rsRCResExt.close();
		  			if (!rCardResExt) 
					{
		          		String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, QTY_IN_INPUT, CREATED_BY, LAST_UPDATED_BY, "+
                                                                      // 20100426 liling fix for REWORK WO NO RESOURCE
						                                              //  " OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, RESOURCE_ID,  "+
						                                                " OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
 																		" TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
														                "  WKCLASS_CODE, WKCLASS_NAME, WORK_EMPLOYEE, WORK_EMPID, WORK_MACHINE, WORK_MACHNO, WIP_ENTITY_ID, QTY_AC_SCRAP , TRANSACTION_DATE) "+
															     " values( '"+woNo+"', '"+aMFGRCPOReceiptCode[i][1]+"', "+aMFGRCPOReceiptCode[i][23]+", '"+userMfgUserID+"', '"+userMfgUserID+"', "+		
   															 // 20100426 liling fix for REWORK WO NO RESOURCE													              
															//     "         "+Integer.parseInt(aMFGRCPOReceiptCode[i][4])+", "+Integer.parseInt(aMFGRCPOReceiptCode[i][27])+","+Integer.parseInt(aMFGRCPOReceiptCode[i][28])+", "+
															     "         "+Integer.parseInt(aMFGRCPOReceiptCode[i][4])+", '"+aMFGRCPOReceiptCode[i][27]+"',  "+
															     "         "+aMFGRCPOReceiptCode[i][24]+", '"+aMFGRCPOReceiptCode[i][29]+"', 2 , "+
														         "         '--', 'N/A', '"+aMFGRCPOReceiptCode[i][25]+"', '0', null ,'N/A', '"+entityId+"', '"+aMFGRCPOReceiptCode[i][22]+"','"+aMFGRCPOReceiptCode[i][26]+"'  ) ";		                              
				  		PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                        
		          		pstmtResTxn.executeUpdate(); 
                  		pstmtResTxn.close(); 
					}
		  
		  			if (Float.parseFloat(aMFGRCPOReceiptCode[i][2])>=0) // 若設定移站數量大於0才進行移站及報廢
		  			{
		   				int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   				int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   				if (aMFGRCPOReceiptCode[i][5]==null || aMFGRCPOReceiptCode[i][5]=="0" || aMFGRCPOReceiptCode[i][5].equals("0")) 
		   				{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
		     				toIntOpSType = 3; 
		     				aMFGRCPOReceiptCode[i][5] = aMFGRCPOReceiptCode[i][4]; // 無下一站的Seq No,故給本站
			 				transType = 2;
		   				}  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)
		   				
						float  rcMQty = 0;   
		   				float  rcScrapQty = 0;  
		   				java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 

		   				String supplierLotNo = null;
		   				boolean prevMoveTxnErr= false;  // 前站移站資訊正常 $$$$
		   				boolean rcvPOCheck = true; // 已委外PO收料無誤	####	 
						String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY , a.WAFER_LOT_NO , b.RES_EMPLOYEE_OP   "+
						                 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
 									     "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.organization_id = c.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+ //20091123 liling add organization_id
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2  "+ 
										 "     and b.RUNCARD_NO='"+aMFGRCPOReceiptCode[i][1]+"' ";
						if (jobType==null || jobType.equals("1"))
						{  
							sqlMQty = sqlMQty + "  and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // 取QUEUE移站數量,外包收料有可能下一站是完工站 
							                     "  and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][3]+"' "; 							
						}
						else 
						{ 	
							// 重工	
							if (aMFGRCPOReceiptCode[i][3]==null || aMFGRCPOReceiptCode[i][3]=="" || aMFGRCPOReceiptCode[i][3].equals(""))		
							{ // 單站(外包)收料
								sqlMQty = sqlMQty + " and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // 外包收料有可能下一站是完工站 
								                    " and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' ";	
							}
							else 
							{	// 多站(外包)收料			        
							    sqlMQty = sqlMQty + " and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // 外包收料有可能下一站是完工站 
								                    " and c.TO_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' ";	
							}		
						}												 				 
						Statement stateMQty=con.createStatement();
                        ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						if (rsMQty.next())
						{						  
							if (aMFGRCPOReceiptCode[i][2]==null || aMFGRCPOReceiptCode[i][2].equals("null")) 
						   	{  
								aMFGRCPOReceiptCode[i][2]=Float.toString(rcMQty); } //表示移站數與收料數相同,故報廢數 = 0
						   		rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//原前站完工數量
                           		txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 移站日期	

						   		rcScrapQty = rcMQty - Float.parseFloat(aMFGRCPOReceiptCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量(in_to_move)						   
						   		supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // 供應商批號
						   
						    	String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();
						 	} 
							else 
							{ 
                            	if ( (jobType=="2" || jobType.equals("2")))
                                { 
									if (aMFGRCPOReceiptCode[i][3]==null || aMFGRCPOReceiptCode[i][3]=="" || aMFGRCPOReceiptCode[i][3].equals(""))
									{   // 無前站, 單站重工
								    	prevMoveTxnErr= false;
									} 
									else 
									{
										prevMoveTxnErr = true;    // 多站重工,異常未取到前一站移站資訊,
									}
								} 
                                else 
								{ 								         							         
									prevMoveTxnErr = true;    // 異常未取到前一站移站資訊,	
								}					 
						    }
						 	rsMQty.close();
						 	stateMQty.close();

           					if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null")) txnDate=systemDate; //20090605 liling 增加若沒key就預設systemdate
  
           					if (UserRoles.indexOf("admin")>=0) // 管理員 
		   					{
			    				rcScrapQty = Float.parseFloat(aMFGRCPOReceiptCode[i][21]);  // 2007/03/30 測試以手動輸入的報廢數 By Kerwin
		   					}			  
	       					//抓取移站數量的單位,並計算本站報廢數量_迄
		   
		 					// 先取報廢 Scrap Account ID_起//  依Organization_id 取預設的 Scrap Acc ID
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
		 					// 先取報廢 Scrap Account ID_迄	
		 	 
		 					String getErrScrapBuffer = "";
		 					int getRetScrapCode = 0;
		 					if (rcScrapQty>0 && !prevMoveTxnErr)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
		 					{	
		   						toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
		   						transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
           						String SqlScrap=" insert into WIP_MOVE_TXN_INTERFACE( "+
				           						" CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				                                " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				                                " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				                                " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
						                        "  GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
				                                " values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?, WIP_TRANSACTIONS_S.NEXTVAL ) ";   
           						PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
           						scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
	       						scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           						scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       						scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       						scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
							   	scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 改為Running ) 
							   	scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>流程卡:"+aMFGRCPOReceiptCode[i][1]+"(3.報廢數量="+rcScrapQty+") ");     	   
							   	scrapstmt.setString(8,woUOM);
							   	scrapstmt.setInt(9,Integer.parseInt(entityId));  
							   	scrapstmt.setString(10,woNo);  
							   	scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
							   	scrapstmt.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(本站)		  
							   	scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
							   	scrapstmt.setInt(14,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
							   	scrapstmt.setString(15,aMFGRCPOReceiptCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
							   	scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							   	scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)報廢  ( 01-11-000-7650-951-0-000 ) 
							   	scrapstmt.setInt(18,7);	// REASON_ID  製程異常
							   	scrapstmt.executeUpdate();
							   	scrapstmt.close();	      	
		   
		   						//抓取寫入Interface的Group等資訊_起
	       						int groupID = 0;
		   						int opSeqNo = 0;              
						 		String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     		" where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id='"+organizationID+"' "+  //20091123 liling add organization_id
										 		" and ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 		" and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
										 		" and TO_INTRAOPERATION_STEP_TYPE = 5   "; // 取此次報廢的group
						 		Statement stateGrp=con.createStatement();
                         		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 		if (rsGrp.next())
						 		{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 		}
						 		rsGrp.close();
						 		stateGrp.close();

		 						if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 						{
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
						  				CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              				cs5.setInt(1,groupID);                                         //  Org ID 	
			              				cs5.setString(2,null);   // BackFlush Setup    
			              				cs5.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              				cs5.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              				cs5.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              				cs5.execute();					      
			             	 			String getMoveStatus = cs5.getString(4);		
			              				String getMoveErrorMsg = cs5.getString(5);								      				    
			              				cs5.close();						  
						  				if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  				{
						     				getRetScrapCode = 77;   // Error Number  
							 				getErrScrapBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 				out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"報廢錯誤原因="+getErrScrapBuffer+"<BR>");
						  				}						  					  
									}	  
									catch (Exception e) 
									{ 
										out.println("Exception6:"+e.getMessage()); 
									}  
		  						}
		 					}
          					// 呼叫 Package 內Procedure Interface APIs 的方式_起(外包PO收料_RECEIVE)	
		  					int requestID = 0;
		  					int rcptReqID = 0;  // 第一個Receipt 的Request ID,作為判斷是否收料成功的RequestID
		  					String devStatus = "";
		  					String devMessage = "";
		  					String rvcGrpID = "0";
		  					respID = "";
		  
  							if (!prevMoveTxnErr) //有抓到前站正確移站資訊,才能取的compSubInventory的倉庫,否則不執行任何PO收料作業
  							{	  
		   						//先取得欲執行產生PO之Responsibility ID_起
	          					Statement stateResp=con.createStatement();	   
	          					ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME like 'YEW_PO_SEMI_SU%' "); 
	          					if (rsResp.next())
	          					{
	           						respID = rsResp.getString("RESPONSIBILITY_ID");
	          					} 
								else 
								{
	                  				respID = "50799"; // 找不到則預設 --> YEW PO SEMI Super User 預設
	                 			}
			         			rsResp.close();
			         			stateResp.close();	  	
	       
		   						//先取得欲執行產生PO之Responsibility ID_迄
           						try
		   						{			   
		      						Statement statement=con.createStatement();
			  						String sql1a=  " select *  from YEW_RUNCARD_ALL a  where WO_NO = '"+woNo+"' and RUNCARD_NO = '"+aMFGRCPOReceiptCode[i][1]+"' ";
              						ResultSet rs=statement.executeQuery(sql1a);  
              						while (rs.next())
              						{
			     						int rcvGroupID = 0;
				 						int parentTransID = 0;
  				   
                 						CallableStatement cs3 = con.prepareCall("{call TSC_WIP_RCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			
				 						cs3.setString(1,aMFGRCPOReceiptCode[i][1]);      //aMFGRCPOReceiptCode[i][1]  //RUNCARD_NO
									 	cs3.setDate(2,receivingDate);                  //收料日期
									 	cs3.setInt(3,Integer.parseInt(fndUserID));  //out.println("fndUserID="+fndUserID);   // FND_USER ID  3077   
									 	cs3.setInt(4,Integer.parseInt(aMFGRCPOReceiptCode[i][11]));  //out.println("aMFGRCPOReceiptCode[i][11]=PO_HEADER_ID="+aMFGRCPOReceiptCode[i][11]+"<BR>");// PO-HeADER_ID
									 	cs3.setInt(5,Integer.parseInt(aMFGRCPOReceiptCode[i][12]));  //out.println("aMFGRCPOReceiptCode[i][12]=PO_LINE_ID="+aMFGRCPOReceiptCode[i][12]+"<BR>");// PO_LINE_ID
									 	cs3.setFloat(6,Float.parseFloat(aMFGRCPOReceiptCode[i][9]));//out.println("aMFGRCPOReceiptCode[i][9]="+aMFGRCPOReceiptCode[i][9]+"<BR>"); // 收料數量  
									 	cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
									 	cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
									 	cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
										cs3.registerOutParameter(10, Types.VARCHAR); //  HEADER error訊息 
									 	cs3.registerOutParameter(11, Types.VARCHAR); //  LINE error訊息 
									 	cs3.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][13]));  // out.println("aMFGRCPOReceiptCode[i][13]=LINE_LOCATION_ID="+aMFGRCPOReceiptCode[i][13]);//PO_LOCATION_LINE_ID
									 	cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID --> 2487之類的
									 	cs3.setInt(14,0);   //FROM ORG_ID					
									 	cs3.setInt(15,Integer.parseInt(rs.getString("ORGANIZATION_ID"))); //Integer.parseInt(rs.getString("ORGANIZATION_ID"))// SUB_INVENTORY   INSPECTION不用給	
									 	cs3.setString(16,"");   // SUB_INVENTORY  (RECEIVE)不用給
									 	cs3.setString(17,aMFGRCPOReceiptCode[i][10]);     // out.println("aMFGRCPOReceiptCode[i][10]="+aMFGRCPOReceiptCode[i][10]);// COMMENTS aIQCReceivingBean[i][10]	短收說明
									 	cs3.setString(18,"");            // LINE查詢的_RECEIPT_NO	
									 	cs3.setString(19,"RECEIVE");      // I_TXN_TYPE 	
									 	cs3.setString(20,"");            // 上一個父異動類型為RECEIVE
									 	cs3.setString(21,"RECEIVING");  // 此次檢驗的DESTNATION TYPE CODE為 RECEIVING			      			     			     
									 	cs3.execute();
									 	// out.println("Procedure : Execute Success !!! ");
									 	statusMessageHeader = cs3.getString(7);	             
									 	statusMessageLine = cs3.getString(8);
										headerID = cs3.getInt(9);                 // 把第二次的更新 Header ID 取到
									 	errorMessageHeader = cs3.getString(10);	             
									 	errorMessageLine = cs3.getString(11);
										cs3.close();			
				 	  
	             						if (errorMessageHeader==null ) 
				 						{  
				    						errorMessageHeader = "&nbsp;";
											Statement stateRvcGrpID=con.createStatement();
				    						String sqlRvcGrpID= " select GROUP_ID  from RCV_HEADERS_INTERFACE  where ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' and LAST_UPDATED_BY = '"+fndUserID+"' "+
										 						" and GROUP_ID = (select max(GROUP_ID) from RCV_HEADERS_INTERFACE where ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' and LAST_UPDATED_BY = '"+fndUserID+"' ) ";										
											ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
											if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
											rsRvcGrpID.close();
											stateRvcGrpID.close();
				 						}				
				 						if (errorMessageLine==null ) { errorMessageLine = "&nbsp;";}	
				      					if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
					  					{					    
					     					errorMessageHeader = "&nbsp;"; 
						 					errorMessageLine = "&nbsp;"; 						 
						 		 						                      						
						       				CallableStatement cs4 = con.prepareCall("{call TSC_YEW_RVCTP_REQUEST(?,?,?,?,?,?)}");
							   				cs4.setString(1,rvcGrpID);			                        // 此次的 RCV Processor Group ID
			  	               				cs4.setInt(2,Integer.parseInt(fndUserID));                   //USER REQUEST 
							   				cs4.setInt(3,Integer.parseInt(respID));                      //RESPONSIBILITY ID 
				               				cs4.registerOutParameter(4, Types.INTEGER);                  //回傳 REQUEST_ID
							   				cs4.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
							   				cs4.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
						       				cs4.execute();
               	   		       				requestID = cs4.getInt(4);   //  回傳 REQUEST_ID
							   				devStatus = cs4.getString(5);   //  回傳 REQUEST 執行狀況
							   				devMessage = cs4.getString(6);   //  回傳 REQUEST 執行狀況訊息
				               				cs4.close();	
							   				rcptReqID = requestID;	// 把Receipt 的 Request ID給rcptReqID
						       				out.print("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'> Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
							   				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");							  	
							   				out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");							   							  							   
					  					} 
										else 
										{  
					          				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  Request RCV Transaction Fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
					          				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
					         			}	
			   						} 
			   						rs.close();
			   						statement.close();	 // 此次檢驗合格的While							 		
		      					}
		      					catch (Exception e) 
		      					{ 
									out.println("Exception7:"+e.getMessage()); 
								}		   
           						/* 20200703 Marvie Del : 1 receipt interface 可完成 receipt delivery 動作
								try
		   						{			   
		      						Statement statement=con.createStatement();
			  						String sql1a=  " select *  from YEW_RUNCARD_ALL a   where WO_NO = '"+woNo+"' and RUNCARD_NO = '"+aMFGRCPOReceiptCode[i][1]+"' ";
              						ResultSet rs=statement.executeQuery(sql1a);  
              						while (rs.next())
              						{
			     						int rcvGroupID = 0;
				 						int parentTransID = 0;
                 						
										CallableStatement cs3 = con.prepareCall("{call TSC_WIP_DELVRCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			
				 						cs3.setString(1,aMFGRCPOReceiptCode[i][1]);                    //RUNCARD_NO
				 						cs3.setDate(2,receivingDate);                   //收料日期
				 						cs3.setInt(3,Integer.parseInt(fndUserID));     // FND_USER ID  3077   
									 	cs3.setInt(4,Integer.parseInt(aMFGRCPOReceiptCode[i][11]));  
									 	cs3.setInt(5,Integer.parseInt(aMFGRCPOReceiptCode[i][12]));  
									 	cs3.setDouble(6,Double.parseDouble(aMFGRCPOReceiptCode[i][9])); // 收料數量  
									 	cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
									 	cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
									 	cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
									 	cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
									 	cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
									 	cs3.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][13]));   //PO_LOCATION_LINE_ID
									 	cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID --> 2487之類的
									 	cs3.setInt(14,0);   //FROM ORG_ID					
									 	cs3.setInt(15,Integer.parseInt(rs.getString("ORGANIZATION_ID"))); // 	
									 	cs3.setString(16,"");   // SUB_INVENTORY  (RECEIVE)不用給
									 	cs3.setString(17,aMFGRCPOReceiptCode[i][10]);      // COMMENTS aIQCReceivingBean[i][10]	短收說明
									 	cs3.setString(18,"");            // LINE查詢的_RECEIPT_NO	
									 	cs3.setString(19,"DELIVER");      // I_TXN_TYPE 	
									 	cs3.setString(20,"RECEIVE");            // 上一個父異動類型為RECEIVE
									 	cs3.setString(21,"SHOP FLOOR");  // 此次檢驗的DESTNATION TYPE CODE為 RECEIVING			      			     			     
									 	cs3.execute();
									 	// out.println("Procedure : Execute Success !!! ");
									 	statusMessageHeader = cs3.getString(7);	             
									 	statusMessageLine = cs3.getString(8);
									 	headerID = cs3.getInt(9);   // 把第二次的更新 Header ID 取到
									 	errorMessageHeader = cs3.getString(10);	             
									 	errorMessageLine = cs3.getString(11);
									 	cs3.close();			
				  
	             						if (errorMessageHeader==null ) 
				 						{ 
				    						errorMessageHeader = "&nbsp;";
											Statement stateRvcGrpID=con.createStatement();
				    						String sqlRvcGrpID= " select GROUP_ID from RCV_HEADERS_INTERFACE "+									  
                                      							" where ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' and LAST_UPDATED_BY = '"+fndUserID+"' "+
									 							" and GROUP_ID = (select max(GROUP_ID) from RCV_HEADERS_INTERFACE where ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' and LAST_UPDATED_BY = '"+fndUserID+"' ) ";
											ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
											if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
											rsRvcGrpID.close();
											stateRvcGrpID.close();
				 						}				
				 						if (errorMessageLine==null ) { errorMessageLine = "&nbsp;";}	
				      					if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
					  					{					    
					     					errorMessageHeader = "&nbsp;"; 
						 					errorMessageLine = "&nbsp;"; 				
						  	 						                      						
						       				CallableStatement cs4 = con.prepareCall("{call TSC_YEW_RVCTP_REQUEST(?,?,?,?,?,?)}");
							   				cs4.setString(1,rvcGrpID);			                        // 此次的 RCV Processor Group ID
			  	               				cs4.setInt(2,Integer.parseInt(fndUserID));                   //USER REQUEST 
							   				cs4.setInt(3,Integer.parseInt(respID));                      //RESPONSIBILITY ID 
				               				cs4.registerOutParameter(4, Types.INTEGER);                  //回傳 REQUEST_ID
							   				cs4.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
							   				cs4.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
						       				cs4.execute();
               	   		       				requestID = cs4.getInt(4);   //  回傳 REQUEST_ID
							   				devStatus = cs4.getString(5);   //  回傳 REQUEST 執行狀況
							   				devMessage = cs4.getString(6);   //  回傳 REQUEST 執行狀況訊息
				               				cs4.close();		
  
						       				out.print("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>  Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
							   				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");							   	
							   				out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");							   							  							   
					  					} 
										else 
										{  
					          				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  Request RCV Transaction Fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
					          				out.print("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>  Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
					         			}					 
			   						}
			   						rs.close();
			   						statement.close();	 // 此次檢驗合格的While							 		
		      					}
		      					catch (Exception e) 
		      					{ 
									out.println("Exception8:"+e.getMessage()); 
								}		   
			 
			  					float rcvPOQty = 0;
			  					String sqlRCVChk = "select QUANTITY_RECEIVED from PO_LINE_LOCATIONS_ALL where PO_HEADER_ID ="+Integer.parseInt(aMFGRCPOReceiptCode[i][11])+" ";
			  					Statement stateRCVChk=con.createStatement();			                 
              					ResultSet rsRCVChk=stateRCVChk.executeQuery(sqlRCVChk);  
			  					if (rsRCVChk.next() && rsRCVChk.getFloat(1)>0)
			  					{
			     					rcvPOQty = rsRCVChk.getFloat(1); // 可再判斷是否收部份;		 
				 					rcvPOCheck = true; 
			  					} 
								else 
								{
			             			String sqlRCVErr = "select ERROR_MESSAGE, TABLE_NAME, COLUMN_NAME from PO_INTERFACE_ERRORS where REQUEST_ID ="+rcptReqID+" ";
			             			Statement stateRCVErr=con.createStatement();	
						 			ResultSet rsRCVErr=stateRCVErr.executeQuery(sqlRCVErr);
						 			if (rsRCVErr.next())
						 			{
			              				out.println("<font color='#FF0000'>系統並未正確執行委外加工收料作業,請洽系統管理員處理</font><BR>");
						  				out.println("<font color='#FF0000'>錯誤訊息:("+rsRCVErr.getString(1)+")<BR>資料表("+rsRCVErr.getString(2)+") 欄位名("+rsRCVErr.getString(3)+")</font><BR>");
						  				rcvPOCheck = false; // 設定為異常,不執行移站SEQ ID及狀態更新SQL
						 			} 			             
			         			}
					 			rsRCVChk.close();
					 			stateRCVChk.close();
								
								*/  // 20200703 Marvie Del : 1 receipt interface 可完成 receipt delivery 動作
   							}
     						
							String getErrBuffer = "",overFlag="";
	 						int getRetCode = 0; 
	 						float prevQty = 0;    	 	   		     
	 						if (getRetScrapCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // 若本站報廢及委外PO收料成功,則進行移站Interface
	 						{		         
								if (getRetScrapCode==0) // 若執行同一站報廢成功,才執行移下一站動作_起
								{ 
					  				float remainQueueQty=0;
					  				Statement stateRM=con.createStatement();
                      				ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id="+organizationID+" and OPERATION_SEQ_NUM = "+aMFGRCPOReceiptCode[i][4]+" ");  //20091123 liling add organization_id
			          				if (rsRM.next()) { remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); }
			          				rsRM.close();
	   		          				stateRM.close();					  
		
           							//判斷是否有overcompletion
             						String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
						   						  " where step_type=1 and FM_OPERATION_SEQ_NUM  = "+aMFGRCPOReceiptCode[i][3]+" "+
						   						  " and runcard_no = '"+aMFGRCPOReceiptCode[i][1]+"' ";
            						// out.print("sqlpre="+sqlpre);
									Statement statepre=con.createStatement();
            						ResultSet rspre=statepre.executeQuery(sqlpre);
									if (rspre.next())
									{
			  							prevQty = rspre.getFloat(1);  //前次移站數量
									}
            						if ( (aMFGRCPOReceiptCode[i][3]==null || aMFGRCPOReceiptCode[i][3].equals("")) && prevQty==0 )
            						{  prevQty= runCardQtyf;  }   //若前一站為null表示沒有前站,且抓到的移站數為0,則預設前站數=流程卡數  2007/03/13 liling OSP重工第一站無法超收問題 

		    						rspre.close();
									statepre.close();
	 	  
									//add by Peggy 20140324
									if (rcScrapQty >0)
									{
										//prevQty	=prevQty -Float.parseFloat("0"+rcScrapQty);
										//解決浮點數計算問題,add by Peggy 20140417
										prevQty	=(prevQty*1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
										prevQty = prevQty/1000;
									}
									if (prevQty<0) prevQty=0;
									//out.println("prevQty="+prevQty);
					  
		  							if (Float.parseFloat(aMFGRCPOReceiptCode[i][2]) > prevQty && remainQueueQty > Float.parseFloat(aMFGRCPOReceiptCode[i][2])  )   //若移站數大於前次移站數量,表示overcompletion
          							{
            							//overQty = Float.parseFloat(aMFGRCPOReceiptCode[i][2]) - prevQty ;    //移站數-前次移站數量=超出數量
										//解決浮點數計算問題,add by Peggy 20140417
										overQty = (Float.parseFloat(aMFGRCPOReceiptCode[i][2])*1000) - (prevQty*1000) ;    //移站數-前次移站數量=超出數量										
										overQty = overQty /1000;
            							overFlag = "Y";   //給定超收的flag
										//out.println("1.overQty="+overQty);
          							}
									else  
									{     
					  					if (Float.parseFloat(aMFGRCPOReceiptCode[i][2]) > remainQueueQty)
					  					{
					    					//overQty = Float.parseFloat(aMFGRCPOReceiptCode[i][2])-remainQueueQty; 
											//解決浮點數計算問題,add by Peggy 20140417
											overQty = (Float.parseFloat(aMFGRCPOReceiptCode[i][2])*1000)-(remainQueueQty*1000); 
											overQty = overQty/1000;
											overFlag = "Y";   //給定超收的flag
											//out.println("2.overQty="+overQty);
					  					} 
										else 
										{
					           				overFlag = "N"; 
					         			}	    
			     					}
		   							
									toIntOpSType = 3;  // 完工移站的to InterOperation Step Type = 3
		   							transType = 1;     // 完工的 Transaction Type(改為 Move Transaction,讓MMT去決定將工單Complete)		   
		   							if (actionID.equals("006")) toIntOpSType= 1;	         // 若不為最後站,繼續移(TRANSFER)
		   							else if (actionID.equals("018")) toIntOpSType = 3;	 // 最後站,完工(RECEIVE)
		   
           							String Sqlrc="";
           							String Sqlrc1 =" insert into WIP_MOVE_TXN_INTERFACE( "+
				        						   " CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				        						   " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				        						   " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				        						   " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
		   							String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
		   							String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
           							String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
           							String Sqlrcv5= " ) ";
 
         							if (overFlag == "Y" || overFlag.equals("Y"))
          							{ 
										Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; 
									}
          							else
          							{ 
										Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; 
									}

           							PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
           							seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
	       							seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           							seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       							seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       							seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           							seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error ( 2006/12/08 改為 Running )
		   							seqstmt.setFloat(7,Float.parseFloat(aMFGRCPOReceiptCode[i][2])); // 2006/12/08 改成取轉換後移站數, 移站數量 aMFGRCPOReceiptCode[i][14]
           							seqstmt.setString(8,woUOM);
	       							seqstmt.setInt(9,Integer.parseInt(entityId));  
	       							seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
	       							seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       							seqstmt.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
	       							seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       							seqstmt.setInt(14,Integer.parseInt(aMFGRCPOReceiptCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       							seqstmt.setString(15,aMFGRCPOReceiptCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		   							seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   							if (overFlag == "Y" || overFlag.equals("Y"))
            						{ 
										seqstmt.setFloat(17,overQty); 
									} // OVERCOMPLETION_TRANSACTION_QTY              
									seqstmt.executeUpdate();
           							seqstmt.close();	  
		   
		   							//抓取寫入Interface的Group等資訊_起
	       							int groupID = 0;
		   							int opSeqNo = 0;              
									String sqlGrp = " select GROUP_ID, TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									                " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id="+organizationID+" "+ //20091123 liling add organization_id
										            " and PROCESS_STATUS = 2 "+ // 2006/11/18 By Process Status=1
										            " and ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' "; // 取此次移站的Group ID為完工
						 			if (actionID.equals("006")) sqlGrp = sqlGrp+" and TO_INTRAOPERATION_STEP_TYPE = 1 "; // 還有下一站(TRANSFER)
						 			else if (actionID.equals("018")) sqlGrp = sqlGrp+" and TO_INTRAOPERATION_STEP_TYPE = 3 ";	//完工(RECEIVE)
						
						 			Statement stateGrp=con.createStatement();
                         			ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 			if (rsGrp.next())
						 			{
						   				groupID = rsGrp.getInt("GROUP_ID");
						   				opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 			}
						 			rsGrp.close();
						 			stateGrp.close();

		 							if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 							{
		   								int procPhase = 1;
		   								int timeOut = 10;
		   								try
		   								{	
					      					CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              					cs4.setInt(1,groupID);                                         //  Org ID 	
			              					cs4.setString(2,null);   // BackFlush Setup    
			              					cs4.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              					cs4.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              					cs4.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              					cs4.execute();					      
			              					String getMoveStatus = cs4.getString(4);		
			              					String getMoveErrorMsg = cs4.getString(5);								      				    
			              					cs4.close();							  
						  					if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  					{
						     					getRetCode = 88;   // Error Number  
							 					getErrBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 					out.println("getRetCode="+getRetCode+"&nbsp;"+"移站錯誤原因="+getErrBuffer+"<BR>");
						  					}							  
										}	  
										catch (Exception e)
			 							{ 
											out.println("Exception9:"+e.getMessage()); 
										}  
		  							} // end of if (groupID>0 && opSeqNo>0)			 
								} // End of if (getRetScrapCode=0) 
								
				  //20200506 liling liling 不執行入庫動作,交由WMS執行 --起
				 /*
  								if (actionID.equals("018")) // 最後站,完工 才丟MMT Interface
  								{		 	  
		 							try
		 							{
	   									// -- 取此次MMT 的Transaction ID 作為Group ID
	              						Statement stateMSEQ=con.createStatement();	             
	              						ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
				  						if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
				  						rsMSEQ.close();
				  						stateMSEQ.close();
		  
		  								String sqlInsMMT = "insert into MTL_TRANSACTIONS_INTERFACE( "+
		                     							   "TRANSACTION_INTERFACE_ID, SOURCE_CODE, SOURCE_HEADER_ID, SOURCE_LINE_ID, PROCESS_FLAG, "+
							                               "TRANSACTION_MODE, INVENTORY_ITEM_ID, ORGANIZATION_ID, SUBINVENTORY_CODE, TRANSACTION_QUANTITY, "+
							                               "TRANSACTION_UOM, PRIMARY_QUANTITY, TRANSACTION_DATE, TRANSACTION_SOURCE_ID, TRANSACTION_TYPE_ID, "+
							                               "WIP_ENTITY_TYPE, OPERATION_SEQ_NUM, LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, "+
							                               "ATTRIBUTE1, ATTRIBUTE2, LOCK_FLAG, TRANSACTION_HEADER_ID, FINAL_COMPLETION_FLAG, VENDOR_LOT_NUMBER, TRANSACTION_SOURCE_TYPE_ID ) "+
							                               " VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 'RCV', "+     // SOURCE_CODE,
							                               " ?,?,1,"+                                                   // PROCESS_FLAG, --1 - Yes
							                               " 2,"+                                                       // TRANSACTION_MODE,  --2 - Concurrent  ,3 - Background
							                               " ?,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'), "+                                     // TRANSACTION_DATE,  20090603
							                               " ?,44, "+                                                   // TRANSACTION_TYPE_ID,    --44 WIP Assembly Completion
							                               " 1, "+                                                      // WIP_ENTITY_TYPE,   --1 - Standard discrete jobs   3 - Non-standard
							                               " ?,SYSDATE, "+                                              // LAST_UPDATE_DATE
							                               " -1, "+                                                     // LAST_UPDATED_BY
							                               " SYSDATE, "+                                                // CREATION_DATE
							                               " ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',? ,5 ) ";  // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error可以重新被Repeocess)
		  								PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
		  								mmtStmt.setInt(1,Integer.parseInt(entityId));   // SOURCE_HEADER_ID(Wip_Entity_id)
		  								mmtStmt.setInt(2,Integer.parseInt(entityId));	  // SOURCE_LINE_ID(Wip_Entity_id)
		  								mmtStmt.setInt(3,primaryItemID);	              // INVENTORY_ITEM_ID 
		  								mmtStmt.setInt(4,Integer.parseInt(organizationID));	  // ORGANIZATION_ID  
		  								mmtStmt.setString(5,compSubInventory);	      // SUBINVENTORY_CODE  
		  								mmtStmt.setFloat(6,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));     // TRANSACTION_QUANTITY 2006/12/07 aMFGRCPOReceiptCode[i][14]
		  								mmtStmt.setString(7,woUOM);	                  // TRANSACTION_UOM
		  								mmtStmt.setFloat(8,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));	  // PRIMARY_QUANTITY  (2006/12/07 aMFGRCPOReceiptCode[i][14])
		  								mmtStmt.setInt(9,Integer.parseInt(entityId));	  // TRANSACTION_SOURCE_ID(Wip_Entity_id)
		  								mmtStmt.setInt(10,Integer.parseInt(aMFGRCPOReceiptCode[i][4]));    // OPERATION_SEQ_NUM
		  								mmtStmt.setInt(11,Integer.parseInt(userMfgUserID));               // CREATED_BY
		  								mmtStmt.setString(12,oeOrderNo);                                         //ATTRIBUTE1  MO_NO
		  								mmtStmt.setString(13,aMFGRCPOReceiptCode[i][1]);                   //ATTRIBUTE2  LOT_NO (流程卡號)
		  								mmtStmt.setString(14,aMFGRCPOReceiptCode[i][1]);                  //VENDOR_LOT_NUMBER  LOT_NO (流程卡號)
          								mmtStmt.executeUpdate();
          								mmtStmt.close();		
		  
		    							String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
		                                                      "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
								                              "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ) "+ 
								                              "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?) ";
	        							PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
										mmtLotStmt.setString(1,aMFGRCPOReceiptCode[i][1]);    // LOT_NUMBER(流程卡號)
		    							mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));	   // TRANSACTION_QUANTITY (2006/12/07 aMFGRCPOReceiptCode[i][14])
		    							mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));	   // PRIMARY_QUANTITY (2006/12/07 aMFGRCPOReceiptCode[i][14])
		   						        mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	               // LAST_UPDATED_BY 								 
		    							mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	               // CREATED_BY 
										mmtLotStmt.executeUpdate();
            							mmtLotStmt.close();
									} // End of try
									catch (Exception e)
        							{
           								out.println("Exception MMT & LOT Interface:"+e.getMessage());
        							}	
   
   									//執行 MMT及MMT LOT Interface Submit Request
   									String errorMsg = "";
   									try
   									{
	  									Statement stateResp=con.createStatement();	   
	  									ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME = 'YEW_INV_SEMI_SU' "); 
	  									if (rsResp.next())
	  									{
	     									respID = rsResp.getString("RESPONSIBILITY_ID");
	  									} 
										else 
										{
	           								respID = "50757"; // 找不到則預設 --> YEW INV Super User 預設
	         							}
			 							rsResp.close();
			 							stateResp.close();	  			 
			 
	  									// -- 取此次MMT 的Transaction Header ID 作為Group Header ID
	  									String grpHeaderID = "";
	  									devStatus = "";
	  									devMessage = "";
	              						Statement statGRPID=con.createStatement();	             
	              						ResultSet rsGRPID=statGRPID.executeQuery("select TRANSACTION_HEADER_ID from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID = "+groupId+" ");
				  						if (rsGRPID.next()) grpHeaderID = rsGRPID.getString(1);
				  						rsGRPID.close();
				  						statGRPID.close();		  
	 
		         						CallableStatement cs3 = con.prepareCall("{call WIP_MTLINTERFACEPROC_PUB.processInterface(?,?,?,?)}");			 
	             						cs3.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
				 						cs3.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
	             						cs3.registerOutParameter(3, Types.VARCHAR);  //回傳 x_returnStatus
				 						cs3.registerOutParameter(4, Types.VARCHAR);  //回傳 x_errorMsg				
	             						cs3.execute();
                 						out.println("<BR>Procedure : Execute Success !!! ");	             
				 						devStatus = cs3.getString(3);    // 回傳 x_returnStatus
				 						devMessage = cs3.getString(4);   // 回傳 x_errorMsg
                 						cs3.close(); 		 
							 
				 						Statement stateError=con.createStatement();
			     						String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
                 						ResultSet rsError=stateError.executeQuery(sqlError);	
				 						if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
				 						{ 
					   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
				  	   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
					   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					   						woPassFlag="N";						   
					 						errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
				 						}
				 						rsError.close();
				 						stateError.close();
				 
				 						if (errorMsg.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
				 						{	
				   							out.println("Success Submit !!! "+"<BR>");
				   							out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   							woPassFlag="Y";	// 成功寫入的旗標
				   							con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
				 						}
	   								}// end of try
       								catch (Exception e)
       								{
           								out.println("Exception WIP_MMT_REQUEST:"+e.getMessage());
       								}	
	 							} // End of  if (actionID.equals("018")) 	 // 最後站,完工 才丟MMT Interface
						*/ //20200506 liling 不執行入庫動作,交由WMS執行 --迄
  							} // End of if (getRetScrapCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // 若本站報廢及委外PO收料都成功,則進行移站Interface
   
							if (getRetScrapCode==0 && getRetCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // 若報廢及移站及委外收料都執行成功,則執行WIP系統流程及異動更新
							{ 
           						// 若成功,則更新RUNCARD 資料表相關欄位
								boolean singleOp = false;  // 預設本站不為最後一站
		    					String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			                          " DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					      				      "  from WIP_OPERATIONS "+						  
			                                  "  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' "+ // 2006/10/26 (本站)是為了要取下一站資訊作更新
						                      "    and WIP_ENTITY_ID ="+entityId+" and organization_id="+organizationID+" ";  //20091123 liling add organization_id	 
	        					Statement statep=con.createStatement();
            					ResultSet rsp=statep.executeQuery(sqlp);
	        					if (rsp.next())
	        					{
		     						operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
			    					operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			    					standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			    					standardOpDesc 	  = rsp.getString("DESCRIPTION");
			    					previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			    					nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
			    					if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
			    					if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";		
			    					if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";
			    					if (nextOpSeqNum==null || nextOpSeqNum.equals(""))
									{ 
				  						nextOpSeqNum = "0";		
				  						singleOp = true;
				  						out.println("移站後,下一站代碼="+nextOpSeqNum);
									}  	
	       						} 
								else 
								{ 
					 				// 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
					 				Statement stateMax=con.createStatement();
                     				ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id="+organizationID+" ");  //20091123 liling add organization_id
					 				if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
					 				{
					   					singleOp = true;					   
					 				} else out.println("下一站不為最後站="+rsMax.getString(1));
					 				rsMax.close();
					 				stateMax.close();
	               				}
	               				rsp.close();
                   				statep.close(); 				   
				   
		     					String SqlQueueTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				                                     " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				                                     " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				                                     " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				                                     " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						                             " LASTUPDATE_DATE, ACTIONID, ACTIONNAME,"+
													 " osp_po_num, osp_rec_qty)"+  // 20200911 Marvie Add : trace
				                                     " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,"+
													     "SYSDATE, '"+actionID+"', '"+actionName+"',"+
														 "?, ?) ";  // 20200911 Marvie Add : trace
           						PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
           						queueTransStmt.setInt(1,Integer.parseInt(aMFGRCPOReceiptCode[i][0])); // RUNCAD_ID          
	       						queueTransStmt.setString(2,aMFGRCPOReceiptCode[i][1]);                // RUNCARD_NO
           						queueTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       						queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       						queueTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
           						queueTransStmt.setInt(6,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //FM_OPERATION_SEQ_NUM(本站) 
		   						if (standardOpDesc==null || standardOpDesc.equals("") || standardOpDesc.equals("null")) standardOpDesc="德鍚外包";	//20130123			      
		   						queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           						queueTransStmt.setInt(8,Integer.parseInt(aMFGRCPOReceiptCode[i][5])); //TO_OPERATION_SEQ_NUM(下一站) 
	       						queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	       						queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // Transaction Qty
	       						queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       						queueTransStmt.setInt(12,1);             // 1=Queue		  
	      		 				queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       						queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       						queueTransStmt.setString(15,"045"); // From STATUSID
		   						queueTransStmt.setString(16,"OSPRECEIVING");	  // From STATUS
		   						queueTransStmt.setString(17,fndUserName);	  // Update User  
	       						queueTransStmt.setString(18,aMFGRCPOReceiptCode[i][16]);  // osp_po_num  20200911 Marvie Add : trace
	       						queueTransStmt.setFloat(19,Float.parseFloat(aMFGRCPOReceiptCode[i][9]));  // osp_rec_qty  20200911 Marvie Add : trace
           						queueTransStmt.executeUpdate();
           						queueTransStmt.close();	    	 
								
								if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
								{ 		 
		   							String SqlScrapTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				                                         " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				                                         " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				                                         " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				                                         " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						                                 " LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
				                                         " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
           							PreparedStatement scrapTransStmt=con.prepareStatement(SqlScrapTrans); 
           							scrapTransStmt.setInt(1,Integer.parseInt(aMFGRCPOReceiptCode[i][0])); // RUNCAD_ID          
	       							scrapTransStmt.setString(2,aMFGRCPOReceiptCode[i][1]);                // RUNCARD_NO
           							scrapTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
	       							scrapTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       							scrapTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
           							scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)   
		   							if (standardOpDesc==null || standardOpDesc.equals("") || standardOpDesc.equals("null")) standardOpDesc="德鍚外包";	//20130123			    
		   							scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
           							scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //TO_OPERATION_SEQ_NUM(下一站) 
	       							scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(下一站代碼) 
	       							scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
	       							scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       							scrapTransStmt.setInt(12,5);             // 5=SCRAP(報廢)		  
	       							scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       							scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       							scrapTransStmt.setString(15,"045"); // From STATUSID
		   							scrapTransStmt.setString(16,"OSPRECEIVING");	  // From STATUS
		   							scrapTransStmt.setString(17,fndUserName);	  // Update User  
           							scrapTransStmt.executeUpdate();
           							scrapTransStmt.close();	    	 
		  						}  // End of if (rcScrapQty>0)	
		  
    							String errorMsg = "";		  
	       						if (errorMsg.equals(""))
	       						{ 
		      						if (actionID.equals("018")) // (RECEIVE) 表示下一站為最後一站,無需更新流程卡Operation狀態
			  						{		  
		       							String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
		                                             " QTY_IN_SCRAP=?, CLOSED_DATE=?, COMPLETION_QTY=?, "+
						                             " QTY_IN_COMPLETE=?, QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP清為空白,移站時才會抓系統日"+
		                                             " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCPOReceiptCode[i][0]+"' "; 	
                						PreparedStatement rcStmt=con.prepareStatement(rcSql);
	            						rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	            						rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		        						if (!singleOp) // 若下一站不為最後站,則維持在 (046) 流程卡待入庫中
		        						{ 
											out.println(aMFGRCPOReceiptCode[i][1]+" 下一站移至:"+getStatusRs.getString("STATUSNAME"));
	              							rcStmt.setString(3,"046"); 
	              							rcStmt.setString(4,"COMPLETING");
		        						} 
										else 
										{ 
				        					if (jobType==null || jobType.equals("1"))
											{
				          						out.println("  "+aMFGRCPOReceiptCode[i][1]+"下一站移至:CLOSING<br>");
		                  						rcStmt.setString(3,"048"); 
	                      						rcStmt.setString(4,"CLOSING");
						  						rcStmt.setFloat(5,rcScrapQty);
											} 
											else if (jobType.equals("2"))
						       				{
							     				rcStmt.setString(3,"048"); 
	                             				rcStmt.setString(4,"CLOSING");
								 				rcStmt.setFloat(5,rcScrapQty);
							   				}
						   
											// 找追溯表母流程卡的流程卡號將WIP_USED_QTY欄位作累加_起
				 							Statement stateParRC=con.createStatement();
                 							ResultSet rsParRC=stateParRC.executeQuery("select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+aMFGRCPOReceiptCode[i][1]+"' ");
				 							if (rsParRC.next())
				 							{
				    							PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCPOReceiptCode[i][2])+" where RUNCARD_NO='"+rsParRC.getString("PRIMARY_NO")+"' ");
												rcStmtUP.executeUpdate();   
                    							rcStmtUP.close(); 
				 							}
				 							rsParRC.close();
				 				
							   				// 完工入庫需一併更新YEW_WORKORDER_ALL_起							   
							   				String woSql=" update APPS.YEW_WORKORDER_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+		                  
						                                 " DATE_COMPLETED=to_char(SYSDATE,'YYYYMMDDHH24MISS'), WO_COMPLETED_QTY=WO_COMPLETED_QTY+"+Float.parseFloat(aMFGRCPOReceiptCode[i][2])+" "+
		                                                 " where WO_NO= '"+woNo+"' "; 	
                               				PreparedStatement woStmt=con.prepareStatement(woSql);
			                   				woStmt.setInt(1,Integer.parseInt(userMfgUserID));
	                           				woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
			                   				woStmt.setString(3,"048"); 
	                           				woStmt.setString(4,"CLOSING");			 
			                   				woStmt.executeUpdate();   
                               				woStmt.close();
							  
							 				//找追溯表母流程卡的工令號將WO_USED_QTY欄位作累加_起
                             				rsParRC=stateParRC.executeQuery("select PRIMARY_PARENT_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+woNo+"' ");
				             				if (rsParRC.next())
				             				{
				                 				PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCPOReceiptCode[i][2])+" where WO_NO='"+rsParRC.getString("PRIMARY_PARENT_NO")+"' ");
					             				rcStmtUP.executeUpdate();   
                                 				rcStmtUP.close(); 
				             				}
				             				rsParRC.close();
				             				stateParRC.close();				
		               					}
										rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 	   
		        						rcStmt.setFloat(7,Float.parseFloat(aMFGRCPOReceiptCode[i][2])); 	
										rcStmt.setFloat(8,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // Transaction Qty	
										rcStmt.setFloat(9,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // Transaction Qty	
										rcStmt.setFloat(10,Float.parseFloat(aMFGRCPOReceiptCode[i][2])+rcScrapQty);	 // 處理數	
                						rcStmt.executeUpdate();   
                						rcStmt.close(); 
			  						} 
									else if (actionID.equals("006")) // (TRANSFER) 表示需繼續移站,更新流程卡個OperationNum及ID
			          				{
					  	 				//20130327 LILING for D2PACK ROUTING STATUS
					      				if (nextOpSeqNum==null || nextOpSeqNum.equals("null") || nextOpSeqNum.equals("0"))
						  				{ 
											rcStatus ="046";
						     				rcStatusDesc="COMPLETING"; 
										}
						  				else
						  				{  
											rcStatus ="044";
						     				rcStatusDesc="MOVING"; 
										}
					  
			                			String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, QTY_IN_SCRAP=?, "+
						                             " PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
							                         " QTY_IN_COMPLETE=?, QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP清為空白,移站時才會抓系統日
		                                             " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCPOReceiptCode[i][0]+"' "; 	
                            			PreparedStatement rcStmt=con.prepareStatement(rcSql);
	                        			rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	                        			rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		                    			out.println(aMFGRCPOReceiptCode[i][1]+" 下一站移至:"+getStatusRs.getString("STATUSNAME"));
						      			// 否則,即更新至 046 流程卡待完工入庫
							        	out.println("nextOpSeqNum="+nextOpSeqNum);
				                    	out.println("下一站移至(Line 3246):"+rcStatusDesc);
		                            	rcStmt.setString(3,rcStatus); 
	                                	rcStmt.setString(4,rcStatusDesc);	
		                    			rcStmt.setFloat(5,rcScrapQty); 		
										rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 	
										rcStmt.setInt(7,Integer.parseInt(standardOpId));
										rcStmt.setString(8,standardOpDesc);	
										rcStmt.setInt(9,Integer.parseInt(operationSeqId));
										rcStmt.setInt(10,Integer.parseInt(operationSeqNum));	
										rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
										rcStmt.setFloat(12,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // IN_Complete Qty	
				            			rcStmt.setFloat(13,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // IN_QUEUE Qty
										rcStmt.setFloat(14,Float.parseFloat(aMFGRCPOReceiptCode[i][2])+rcScrapQty); // 處理數	
                            			rcStmt.executeUpdate();   
                            			rcStmt.close(); 									       
			         				}
		    					}  // End of if (errorMsg.equals(""))	   
		  					} // End of if (getRetScrapCode==0 && getRetCode==0 && !prevMoveTxnErr) // 若報廢及移站都執行成功,則執行系統流程及異動更新    
		  					else 
							{
		         				interfaceErr = true; // 報廢及移站有異常,JavaScript告知使用者
				 				if (prevMoveTxnErr)
				 				{
				  				%>
				   				<script language="javascript">
				     				alert("前站移站異常,請MIS查明原因!!!");
				   				</script>
				  				<%
				 				}
								else if (rcvPOCheck==false)
				        		{
				          		%>
				             	<script language="javascript">
				              		alert("委外加工收料異常,請MIS查明原因!!!");
				             	</script>
				          		<%
				        		} 
								else if (getRetScrapCode!=0)
						       	{
							    %>
				                <script language="javascript">
				                	alert("本站收料報廢異常,請MIS查明原因!!!");
				                </script>
				                <%
							   	}						
		       				}
		 				} //End of if (aMFGRCPOReceiptCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢	
        			} // End of if (choice[k]==aMFGRCPOReceiptCode[i][0] || choice[k].equals(aMFGRCPOReceiptCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新
     		} // End of for (i=0;i<aMFGRCPOReceiptCode.length;i++)
   		} // end of if (aMFGRCPOReceiptCode!=null) 
		out.print("<BR><font color='#0033CC'>流程卡收料移站O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	
    	// 使用完畢清空2維陣列
    	if (aMFGRCPOReceiptCode!=null)
		{ 
	  		arrMFGRCPOReceiptBean.setArray2DString(null); 
		}
	} // End of if (actionID.equals("012") && fromStatusID.equals("045"))
	//MFG流程卡完工入庫_迄	(ACTION=012)   流程卡移站中044 --> 流程卡待收料中045(需判斷是否本站為最後一站)
  
  	out.println("<BR>"); 
  	getStatusStat.close();
  	getStatusRs.close();  
}
catch (Exception e)
{
	e.printStackTrace();
   out.println("error 3809:"+e.getMessage());
}//end of catch
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0" >
	<tr>
    	<td width="278"><font size="2">WIP單據處理</font></td>
    	<td width="297"><font size="2">WIP查詢及報表</font></td>    
  	</tr>
  	<tr>   
    	<td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E5";    
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlE3);    	
    while(rs.next())
    {
		//out.println("FSEQ="+rs.getString("FSEQ"));
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>");  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
    out.println("error 3841:"+e.getMessage());
}//end of catch  
%>   
 		</td> 
 		<td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E6";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
    	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>"); 
} //end of try
catch (Exception e)
{
	e.printStackTrace();
    out.println("error 3866:"+e.getMessage());
}//end of catch   
%>
		</td>    
  	</tr>
</table>
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

