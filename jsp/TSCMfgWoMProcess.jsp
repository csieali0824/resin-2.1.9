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
	var orginalPage="?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo;
	flag=confirm(ms1);
	if (flag==false) return(false);
	else
	{ //alert(orginalPage);
		//alert(URL);
		// return (true); 
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
<jsp:useBean id="arrayLotIssueCheckBean" scope="session" class="ArrayCheckBoxBean"/>   <!--FOR 後段流程卡待投產 Match實際完工前段批號-->
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡移站中 -->
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡完工入庫 -->
<jsp:useBean id="arrMFGRCDeleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡已展開-> 流程卡刪除 liling --> 
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
String routingRefID      = "0";

String runCardCount=String.valueOf(runCardCountI);  //流程卡張數

String dateCodeSet = request.getParameter("DATECODE");  // 批次給定的投產DateCode

//out.print("woNo="+woNo+"<br>");
//out.print("尾批數量="+runCardCountD);

if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   

// MFG工令資料_參數迄

// 2005/12/03 取session 的Bean 的選取的生管指派指對應代碼 // By Kerwin

String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR 流程卡已展開-> 流程卡移站中
String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR 流程卡移站中-> 流程卡移站中
String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR 流程卡移站中-> 流程卡完工入庫
String aMFGRCDeleteCode[][]=arrMFGRCDeleteBean.getArray2DContent();  	// FOR 流程卡已展開-> 流程卡刪除 liling
String aMFGLotMatchCode[][]=arrayLotIssueCheckBean.getArray2DContent();  // FOR 後段流程卡待投產 Match實際完工前段批號

// 2004/07/08 取session 的Bean 的選取的檢驗方式對應代碼 // By Kerwin

//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String adminModeOption=request.getParameter("ADMINMODEOPTION");//是否為管理員模式

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

String errorFlag ="";

// 為存入日期格式為US考量,將語系先設為美國
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
//完成存檔後回復	  

//抓取系統日期
String systemDate ="";
Statement statesd=con.createStatement();
ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
if (sd.next())
{
	systemDate=sd.getString("SYSTEMDATE");	 
}
sd.close();
statesd.close();	

// 取對應的 organization_code 從ORG參數檔
String organCode ="";
String organizationID = "";
Statement stateOrgCode=con.createStatement();
//out.println("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' ");
ResultSet rsOrgCode=stateOrgCode.executeQuery("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
if (rsOrgCode.next())
{
	organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
	organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
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
		//out.println("processDateTime  = "+processDateTime);
	}
	rsDate.close();
	stateDate.close();	   
}    // 得到入庫執行日期..日期型態


java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
//java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
//java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date    


//String sourceTypeCode = "INTERNAL"; 
int lineType = 0;  

String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125


String dateCurrent = dateBean.getYearMonthDay();	
//out.println("fromStatusID="+fromStatusID);


// formID = 基本資料頁傳來固定常數='TS'
// fromStatusID = 基本資料頁傳來Hidden 參數
// actionID = 前頁取得動作 ID( Assign = 003 )
try
{ 
	errorFlag ="000000";
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
	//out.println("sqlStat="+sqlStat);
	//"select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
	Statement getStatusStat=con.createStatement();  
	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
	getStatusRs.next();

	//out.println("Step0");

	// Move TSCMfgWoExpandMProcess.jsp
	
	errorFlag ="042>044";
	//MFG流程卡移站中_起	(ACTION=006)   流程卡已展開042->流程卡移站中 044
	if (actionID.equals("006") && fromStatusID.equals("042"))   // 如為n站, 即 第一站 --> 第二站 --> 第 n-1 站
	{   //out.println("fromStatusID="+fromStatusID);
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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起	                     
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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄 

				//抓取移站數量的單位_起	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID ,a.OE_ORDER_NO  "+
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
					//out.println("entityId="+entityId+ "" +"woNo="+woNo+"<BR>");
				}
				rsUOM.close();
				stateUOM.close();
				//抓取移站數量的單位_迄   

			} // End of if (aMFGRCExpTransCode.length>0)  


			for (int i=0;i<aMFGRCExpTransCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
					// 判斷被Check 的Line 才執行指派作業
					if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RUNCARD_ID = 陣列內容
					{ //out.println("aMFGRCExpTransCode[i][0]="+aMFGRCExpTransCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");
						if (Float.parseFloat(aMFGRCExpTransCode[i][2])>0) // 若設定移站數量大於0才進行移站及報廢
						{

							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCExpTransCode[i][5]==null || aMFGRCExpTransCode[i][5]=="0" || aMFGRCExpTransCode[i][5].equals("0")) 
							{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
								toIntOpSType = 3; 
								aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // 無下一站的Seq No,故給本站
								transType = 1; //(完工由入庫後自動執行,故仍設為1)
							}  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)

							//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
							float  rcMQty = 0;   
							float  rcScrapQty = 0;   
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位     

							String sqlMQty = " select b.QTY_IN_QUEUE from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
										 " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "   and b.RUNCARD_NO='"+aMFGRCExpTransCode[i][1]+"' ";
							Statement stateMQty=con.createStatement();
							ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
							if (rsMQty.next())
							{
								if (aMFGRCExpTransCode[i][2]==null || aMFGRCExpTransCode[i][2].equals("null")) aMFGRCExpTransCode[i][2]=Float.toString(rcMQty);
								rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		//原投站數量			
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   
								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();

								//out.println("java四捨五入後取小數三位rcScrapQty="+rcScrapQty+"<BR>");  
							}
							rsMQty.close();
							stateMQty.close();
							//抓取移站數量的單位,並計算本站報廢數量_迄

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
								// 先取報廢 Scrap Account ID_迄

								// *****%%%%%%%%%%%%%% 移站報廢數量 %%%%%%%%%%%%**********  起
								toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
								transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
								String SqlScrap="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
												"            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
												"     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?, WIP_TRANSACTIONS_S.NEXTVAL) ";   
								// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
								PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
								scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/07 改為 2, 原為 1)     
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>流程卡:"+aMFGRCExpTransCode[i][1]+"(報廢數量="+rcScrapQty+")<BR>");        	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
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
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 -- By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // 取此次報廢
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入Interface的Group等資訊_迄  		
								//out.println("<BR>報廢的groupID ="+groupID+"<BR>");
								//out.println("Step1");	 
								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER		  
									int procPhase = 1;
									int timeOut = 10;
									try
									{	        /*
										CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
										cs5.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
										cs5.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
										cs5.setInt(3,groupID);                                         //  Org ID 	
										cs5.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
										cs5.setInt(5,timeOut); 
										cs5.setInt(6,opSeqNo);                // User ID 					 					      						   	 					     
										cs5.execute();					      
										getErrScrapBuffer = cs5.getString(1);		
										getRetScrapCode = cs5.getInt(2);								      				    
										cs5.close();	
										*/

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
			  

										/*
										if (getRetScrapCode>0)
										{
											String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
											"where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
											Statement stateTxnMsg=con.createStatement();
											ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
											if (rsTxnMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫
											{
												getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
											}
											rsTxnMsg.close();
											stateTxnMsg.close(); 
										}					  			  	  
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_起  
										String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
										" where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+
										"   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' "+
										"   and PRIMARY_QUANTITY = "+rcScrapQty+"  "+  // 報廢數
										"   and TO_INTRAOPERATION_STEP_TYPE = 5 and GROUP_ID="+groupID+" ";   // 取此次報廢
										Statement stateGrpMsg=con.createStatement();
										ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
										if (rsGrpMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫入Move Transaction, 更正getRetScrapCode = 0
										{
											getRetScrapCode = 0; 
											if (getErrScrapBuffer!=null && !getErrScrapBuffer.equals("null")) out.println("含錯誤訊息,仍成功寫入報廢數Interface!!!");
										} else {

										}
										rsGrpMsg.close();
										stateGrpMsg.close();
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_迄 
										*/
									}	  
									catch (Exception e) { out.println("Exception報廢的groupID:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
							// *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄

							} // End of if (rcScrapQty>0)

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;	
							// float prevQty = 0; 	         
							if (getRetScrapCode==0) // 若執行同一站報廢成功,才執行移下一站動作_起
							{ 

								//判斷是否有overcompletion
								//抓取流程卡數量
								Statement stateRc=con.createStatement();
								ResultSet rsRc=stateRc.executeQuery(" SELECT runcard_qty   FROM yew_runcard_all  WHERE runcard_no = '"+aMFGRCExpTransCode[i][1]+ "'");
								if (rsRc.next())
								{ runCardQtyf = rsRc.getFloat("RUNCARD_QTY"); }
								rsRc.close();
								stateRc.close();

								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf )   //若移站數大於流程卡數,表示overcompletion
								{
									overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //移站數-流程卡數=超出數量
									overFlag = "Y";   //給定超收的flag
								}else  { overFlag = "N"; }
								//out.print("overQty="+overQty);    
								//out.println("Step2");
								toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1 
								// *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  起
								String Sqlrc="";
								String Sqlrc1="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
								String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
								String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
								String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
								String Sqlrcv5= " ) ";

								if (overFlag == "Y" || overFlag.equals("Y"))
								{ Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; }
								else
								{ Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; }

								PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
								seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/07 改為 2, 原為 1)    
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // 移站數量
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
								//out.println("數量="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);   //out.println("woUOM="+woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
								seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//抓取寫入Interface的Group等資訊_起
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID, TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 -- By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 1 "; // 取此次移站的Group ID
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
									//out.println("Get Move.PRI Work Group="+groupID+"<BR>");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入移站Interface的Group等資訊_迄
								//out.println("<BR>移站的groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	  /*
										CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
										cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
										cs4.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
										cs4.setInt(3,groupID);                                         //  Org ID 	
										cs4.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
										cs4.setInt(5,timeOut); 
										cs4.setInt(6,opSeqNo);                // User ID 					 					      						   	 					     
										cs4.execute();					      
										getErrBuffer = cs4.getString(1);		
										getRetCode = cs4.getInt(2);								      				    
										cs4.close();	
										*/
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
  
										//out.println("getRetCode="+getRetCode+"&nbsp;"+"getErrBuffer="+getErrBuffer+"<BR>");

										/*	  
										if (getRetCode>0)
										{
											String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
															   "where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
											Statement stateTxnMsg=con.createStatement();
											ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
											if (rsTxnMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫
											{
												getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
											}
											rsTxnMsg.close();
											stateTxnMsg.close(); 
										}		
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_起  
										String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
														 " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+
														 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' "+
														 "   and PRIMARY_QUANTITY = "+Float.parseFloat(aMFGRCExpTransCode[i][2])+"  "+  // 移站數
														 "   and TO_INTRAOPERATION_STEP_TYPE = 1 and  GROUP_ID = "+groupID+" ";   // 取此次移站
										Statement stateGrpMsg=con.createStatement();
										ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
										if (rsGrpMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫入Move Transaction, 更正getRetScrapCode = 0
										{
										getRetCode = 0; 
										if (getErrBuffer!=null && !getErrBuffer.equals("null")) out.println("含錯誤訊息,仍成功寫入移站數Interface!!!");
										} else {

										}
										rsGrpMsg.close();
										stateGrpMsg.close();
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_迄			  	  
										*/
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
									// *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  迄

							} // End of if (getRetScrapCode=0) 		 	

							// 若報廢及移站都成功,則更新RUNCARD 資料表相關欄位
							if (getRetScrapCode==0 && getRetCode==0)
							{   // 取成功移站後,前一站,本站,下一站相關資訊RUNCARD_ALL資料表更新
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // 預設本站不為最後一站
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
											"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
											"  from WIP_OPERATIONS "+
											"  where previous_operation_seq_num = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ";	 
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
										out.println("下一站代碼="+nextOpSeqNum);
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
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
									if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
									{
										singleOp = true;						   			   
									} else out.println("下一站代碼="+rsMax.getString(1));
									rsMax.close();
									stateMax.close();


								}
								rsp.close();
								statep.close();				   

								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_起
								//先抓wip_move_transaction中的 OVERCOMPLETION_PRIMARY_QTY
								float overValue=0;
								if (overFlag=="Y" || overFlag.equals("Y"))
								{ 
									String sqlOver=" select OVERCOMPLETION_PRIMARY_QTY from wip_move_transactions where TO_INTRAOPERATION_STEP_TYPE= 1 "+
									"    and ATTRIBUTE2= '"+aMFGRCExpTransCode[i][1]+"' and FM_OPERATION_SEQ_NUM = "+aMFGRCExpTransCode[i][4]+" ";
									Statement stateOver=con.createStatement();	   
									ResultSet rsOver=stateOver.executeQuery(sqlOver); 
									if (rsOver.next())
									{ overValue = rsOver.getFloat(1); }
									rsOver.close();
									stateOver.close();	
								} else overValue=0;
								//out.println("Step3");
								String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE, OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME ) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
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
								queueTransStmt.setFloat(18,overValue);  // overcompletion  Qty
								queueTransStmt.executeUpdate();
								queueTransStmt.close();	    	 
								//out.println("Step4");		 
								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 

								if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
								{		 
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_起
									String SqlScrapTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
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

									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_迄 

								}	// End of if (rcScrapQty>0)	 				   

								String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
										" QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
										" QTY_IN_QUEUE=?, RC_DATE_CODE= '"+dateCodeSet+"' "+      // 2007/11/22 By Kerwin add for Batch Update DateCode
										" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
								PreparedStatement rcStmt=con.prepareStatement(rcSql);
								//out.print("rcSql="+rcSql);           
								rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
								rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
								if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
								{
									rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
									rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
								} else { // 否則,即更新至 046 完工入庫
									rcStmt.setString(3,"046"); 
									rcStmt.setString(4,"COMPLETING");
								}
								rcStmt.setFloat(5,rcScrapQty); 
								rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 
								rcStmt.setInt(7,Integer.parseInt(standardOpId));
								rcStmt.setString(8,standardOpDesc);
								rcStmt.setInt(9,Integer.parseInt(operationSeqId));
								rcStmt.setInt(10,Integer.parseInt(operationSeqNum));
								rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
								rcStmt.setFloat(12,Float.parseFloat(aMFGRCExpTransCode[i][2]));  // Transaction Qty
								rcStmt.executeUpdate();   
								rcStmt.close(); 
								//out.println("StepMatch 1:");
								// 若為後段工令,則再寫匹配的前段批號_起		   
								if (aMFGLotMatchCode!=null)
								{
									if (woType.equals("3"))
									{
										// String oeOrderNo = "0";
										String oeLineId = "0";
										String frontWoNo = "0";
										String orgWoQty = "0";
										for (int m=0;m<aMFGLotMatchCode.length;m++)
										{

											Statement stateMId=con.createStatement();
											ResultSet rsMId=stateMId.executeQuery("select ORDER_NO, ORDER_LINE_ID, EXTENDED_QTY from YEW_MFG_TRAVELS_ALL where EXTEND_NO='"+woNo+"' and EXTEND_TYPE ='3' and PRIMARY_NO='N/A' ");
											if (rsMId.next())
											{
												oeOrderNo = rsMId.getString("ORDER_NO"); 
												oeLineId = rsMId.getString("ORDER_LINE_ID"); 
												orgWoQty = rsMId.getString("EXTENDED_QTY"); 
												Statement stateWO=con.createStatement();
												ResultSet rsWO=stateWO.executeQuery("select WO_NO from YEW_RUNCARD_ALL where RUNCARD_NO='"+aMFGLotMatchCode[m][0]+"' ");
												if (rsWO.next())
												{
													frontWoNo = rsWO.getString("WO_NO");
												}
												rsWO.close();
												stateWO.close();
												// 刪除原寫入的Template

												PreparedStatement stmtDel=con.prepareStatement("delete from YEW_MFG_TRAVELS_ALL where EXTEND_NO='"+woNo+"' and EXTEND_TYPE ='3' and ( PRIMARY_NO in ('N/A',null) or EXTENDED_QTY = 0 ) "); 
												stmtDel.executeUpdate();   
												stmtDel.close(); 

											}
											rsMId.close();
											stateMId.close(); 
											// 並寫入一筆連結表資料_起
											//out.println("StepMatch 5:");
											if (Float.parseFloat(orgWoQty)>0) // 2006/12/20 加入 批配前段批號 >0 才寫
											{
												String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO, ORDER_LINE_ID, PRIMARY_LOT_QTY ) "+
													   "values(?,?,?,?,?,?,?,?,?,?,?) ";   
												PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
												seqstmtIns.setString(1,aMFGLotMatchCode[m][0]); //out.println("aMFGLotMatchCode[m][0]="+aMFGLotMatchCode[m][0]); // 前段流程卡號
												seqstmtIns.setString(2,"2");   //out.println("2"); // 一律由前段工令產生後段工令
												seqstmtIns.setString(3,woNo);  //out.println("woNo="+woNo);
												seqstmtIns.setString(4,woType); //out.println("woType="+woType);
												seqstmtIns.setFloat(5,Float.parseFloat(orgWoQty));  //out.println("orgWoQty="+orgWoQty);   	
												seqstmtIns.setString(6,oeOrderNo);
												seqstmtIns.setString(7,userMfgUserID);
												seqstmtIns.setString(8,userMfgUserID);
												seqstmtIns.setString(9,frontWoNo); // 主要父序號
												seqstmtIns.setString(10,oeLineId); // 原訂單項次號
												seqstmtIns.setString(11,aMFGLotMatchCode[m][1]); // 原完工批號數量
												seqstmtIns.executeUpdate();   
												seqstmtIns.close(); 
												// 並寫入一筆連結表資料_迄
												//out.println("StepMatch 2.1:");
											} // End of if (Float.parseFloat(orgWoQty)>0)  //2006/12/20 加入 批配前段批號 >0 才寫
										} // End of for
									} // end of if (woType.equals("3")		 
								} // End o if (aMFGLotMatchCode!=null)           
								//out.println("StepMatch 3:<BR>");   
								// 若為後段工令,則再寫匹配的前段批號_迄


							} // end of if (getRetScrapCode==0 && getRetCode==0)  -- 報廢及移站都成功執行 
							else {
							interfaceErr = true; // 表示移站Interface有異常
							} // End of else

						} // end of if (aMFGRCExpTransCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢   
						out.print("<font color='#0033CC'>流程卡("+aMFGRCExpTransCode[i][1]+")已投產O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font><BR>");   
					} // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID等於陣列內容
				} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新

			} // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
		} // end of if (aMFGRCExpTransCode!=null) 

		//out.print("流程卡投產O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		if (!nextOpSeqNum.equals("0") && !interfaceErr) // 若下一站不等於最後一站且Interface無異常
		{
%>
<script LANGUAGE="JavaScript">
// reProcessFormConfirm("是否繼續執行此張流程卡移站作業?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%	
		} else {
%>
<script LANGUAGE="JavaScript">
alert("Oracle移站異常..請洽MIS查明原因!!!");
</script>
<%	
		}

		// 使用完畢清空 2維陣列
		if (aMFGRCExpTransCode!=null)
		{ 
			arrMFGRCExpTransBean.setArray2DString(null); 	  
			if (woType.equals("3")) // 後段工令,需於投產時匹配前段完工批號
			{
				arrayLotIssueCheckBean.setArray2DString(null); // 把後段工令對應的領料批號亦清空
			}
		}

		//out.println("<BR>Done");
	}
	//MFG流程卡移站中_迄	(ACTION=006)   流程卡已展開042->流程卡移站中044   // 如為n站, 即 第一站 --> 第二站 --> 第 n-1 站

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="042>046";
	//MFG流程卡已投產_起	(ACTION=012)   流程卡已展開042-> 流程卡入庫 046 第一站即為完工站
	if (actionID.equals("012") && fromStatusID.equals("042"))   // 如為n站, 即 第一站 --> 第 n 站
	{   //out.println("fromStatusID="+fromStatusID);
		String fndUserName = "";  //處理人員
		String woUOM = ""; // 工令移站單位
		String altRouting = "1"; //
		String opSupplierLot = "";
		int primaryItemID = 0; // 料號ID
		float runCardQtyf=0,overQty=0; 
		entityId = "0"; // 工令wip_entity_id
		boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
		if (aMFGRCExpTransCode!=null)
		{	  
			if (aMFGRCExpTransCode.length>0)
			{    
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起

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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄 

				//抓取移站數量的單位_起	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID ,a.OE_ORDER_NO, b.QTY_IN_QUEUE, "+
							 "        a.ALTERNATE_ROUTING, a.SUPPLIER_LOT_NO, a.ORGANIZATION_ID "+ // 2007/01/18 若判斷為後段外購工令,則以廠商批號寫入MMT
							 "  from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
							 " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
				//out.print("sqlUOM="+sqlUOM);
				Statement stateUOM=con.createStatement();
				ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
				if (rsUOM.next())
				{
					woUOM = rsUOM.getString("WO_UOM");
					entityId =  rsUOM.getString("WIP_ENTITY_ID");
					primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
					oeOrderNo = rsUOM.getString("OE_ORDER_NO");
					altRouting = rsUOM.getString("ALTERNATE_ROUTING");
					opSupplierLot = rsUOM.getString("SUPPLIER_LOT_NO");
					organizationId = rsUOM.getString("ORGANIZATION_ID");

				}
				rsUOM.close();
				stateUOM.close();
				//抓取移站數量的單位_迄   
				//out.print("<br>1.移站數="+Float.parseFloat(aMFGRCExpTransCode[i][2]));


			} // End of if (aMFGRCExpTransCode.length>0)  


			for (int i=0;i<aMFGRCExpTransCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
					// 判斷被Check 的Line 才執行指派作業
					if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RUNCARD_ID = 陣列內容
					{ //out.println("aMFGRCExpTransCode[i][0]="+aMFGRCExpTransCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");
						if (Float.parseFloat(aMFGRCExpTransCode[i][2])>0) // 若設定移站數量大於0才進行移站及報廢
						{

							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCExpTransCode[i][5]==null || aMFGRCExpTransCode[i][5]=="0" || aMFGRCExpTransCode[i][5].equals("0")) 
							{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
								toIntOpSType = 3; 
								aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // 無下一站的Seq No,故給本站
								transType = 1; //(完工由入庫後自動執行,故仍設為1)
							}  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)

							//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
							float  rcMQty = 0;   
							float  rcScrapQty = 0; 
							String compSubInventory = null;    
							String supplierLotNo = null; 
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
								
							String sqlMQty = " select b.QTY_IN_QUEUE, b.RUNCARD_QTY,"+  // 展開即完工入庫,故不關連WIP_MOVE_TRANSACTIONS
										 "         a.COMPLETION_SUBINVENTORY, a.WAFER_LOT_NO  ,a.OE_ORDER_NO "+
										 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
										 "   where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+	
										 "     and b.RUNCARD_NO='"+aMFGRCExpTransCode[i][1]+"' ";									

							//out.print("sqlMQty="+sqlMQty);			 
							Statement stateMQty=con.createStatement();
							ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
							if (rsMQty.next())
							{
								if (aMFGRCExpTransCode[i][2]==null || aMFGRCExpTransCode[i][2].equals("null")) aMFGRCExpTransCode[i][2]=Float.toString(rcMQty);
								rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		                  //原投站數量			
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   
								compSubInventory = rsMQty.getString("COMPLETION_SUBINVENTORY");	  // 入庫subInventory
								supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // 供應商批號
								//oeOrderNo = rsMQty.getString("OE_ORDER_NO");	              // 供應商批號

								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();

								//out.println("java四捨五入後取小數三位rcScrapQty="+rcScrapQty+"<BR>");	
								//out.println("adminModeOption="+adminModeOption);
								if (adminModeOption!=null && adminModeOption.equals("YES") && UserRoles.indexOf("admin")>=0)
								{
									rcScrapQty = Float.parseFloat(aMFGRCExpTransCode[i][11]); // 管理員模式,且手動給定了報廢數,則以給定的報廢數入Scrap
									userMfgUserID = "5753"; // 山東廠包裝站,PANG_LIPING
								}
												   
							}
							rsMQty.close();
							stateMQty.close();
							//抓取移站數量的單位,並計算本站報廢數量_迄


							// out.println("sqlMQty ="+sqlMQty);

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
								// 先取報廢 Scrap Account ID_迄

								// *****%%%%%%%%%%%%%% 移站報廢數量 %%%%%%%%%%%%**********  起
								toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
								transType = 1;     // 報廢的Transaction Type = 1(Move Transaction)
								String SqlScrap="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
												"            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
												"     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?,WIP_TRANSACTIONS_S.NEXTVAL ) ";   
								// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
								PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
								scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	    (2006/12/07 改為 Running)原為1   
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>流程卡:"+aMFGRCExpTransCode[i][1]+"(報廢數量="+rcScrapQty+")<BR>");  	       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1);     // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
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
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/11/18 By Process --> Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // 取此次報廢
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入Interface的Group等資訊_迄  		
								//out.println("<BR>報廢的groupID ="+groupID+"<BR>");

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
									catch (Exception e) { out.println("Exception報廢的groupID:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄

							} // End of if (rcScrapQty>0)

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;		         
							if (getRetScrapCode==0) // 若執行同一站報廢成功,才執行移下一站動作_起
							{  
								Statement stateRc=con.createStatement();
								ResultSet rsRc=stateRc.executeQuery(" SELECT runcard_qty FROM yew_runcard_all  WHERE runcard_no = '"+aMFGRCExpTransCode[i][1]+ "'");
								if (rsRc.next())
								{ runCardQtyf = rsRc.getFloat("RUNCARD_QTY"); }
								rsRc.close();
								stateRc.close();

								//out.print("<br>runCardQtyf="+runCardQtyf);
								// out.print("<br>move qty="+aMFGRCExpTransCode[i][2]); 
								//判斷是否有overcompletion
								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf )   //若移站數大於流程卡數,表示overcompletion
								{
									overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //移站數-流程卡數=超出數量
									overFlag = "Y";   //給定超收的flag
								}else  { overFlag = "N"; }
								// out.print("overQty="+overQty);    
								//toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1 
								// *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  起
								toIntOpSType = 3;  // 完工移站的to InterOperation Step Type = 3
								transType = 1;     // 完工的 Transaction Type(改為 Move Transaction,讓MMT去決定將工單Complete)
								String Sqlrc="";
								String Sqlrc1="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
								String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
								String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
								String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
								String Sqlrcv5= " ) ";

								if (overFlag == "Y" || overFlag.equals("Y"))
								{ Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; }
								else
								{ Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; }
								//out.print("Sqlrc="+Sqlrc);
								PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
								seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/07改為 Running) 原為 1
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // 移站數量
								//seqstmt.setFloat(7,transactionQty); // 移站數量  2006/12/22
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
								//out.println("數量="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
								seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//抓取寫入Interface的Group等資訊_起
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 --> By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 3 "; // 取此次移站的Group ID為完工
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入移站Interface的Group等資訊_迄
								//out.println("<BR>移站的groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  迄

							} // End of if (getRetScrapCode==0) 		 	
					
							// 若報廢及移站都成功,則更新RUNCARD 資料表相關欄位
							if (getRetScrapCode==0 && getRetCode==0)
							{   // 取成功移站後,前一站,本站,下一站相關資訊RUNCARD_ALL資料表更新
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // 預設本站不為最後一站
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
												"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
												"  from WIP_OPERATIONS "+
												"  where PREVIOUS_OPERATION_SEQ_NUM is null and WIP_ENTITY_ID ="+entityId+" ";	// 投產移站即完工(只有一站) 
								//out.println("下一站代碼="+sqlp);
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
										//out.println("下一站代碼="+nextOpSeqNum);
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
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
									if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
									{
										singleOp = true;						   			   
									} //else out.println("下一站代碼="+rsMax.getString(1));
									rsMax.close();
									stateMax.close();

								}
								rsp.close();
								statep.close();				   

								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_起
								//先抓wip_move_transaction中的 OVERCOMPLETION_PRIMARY_QTY
								float overValue=0;
								if (overFlag=="Y" || overFlag.equals("Y"))
								{ 
									String sqlOver=" select OVERCOMPLETION_PRIMARY_QTY from wip_move_transactions where TO_INTRAOPERATION_STEP_TYPE=1 "+
													"    and ATTRIBUTE2= '"+aMFGRCExpTransCode[i][1]+"' and FM_OPERATION_SEQ_NUM = "+aMFGRCExpTransCode[i][4]+" ";
									Statement stateOver=con.createStatement();	   
									ResultSet rsOver=stateOver.executeQuery(sqlOver); 
									if (rsOver.next())
									{ overValue = rsOver.getFloat(1); }
									rsOver.close();
									stateOver.close();	
								} else overValue=0;

								String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE , OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME ) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
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
								queueTransStmt.setFloat(18,overValue);  // OVERCOMPLETE_QTY 
								queueTransStmt.executeUpdate();
								queueTransStmt.close();	    	 
								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 

								if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
								{		 
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_起
									String SqlScrapTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
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
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_迄 

								}	// End of if (rcScrapQty>0)	 	

								// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_起	
								try
								{ //out.println("Step1. 寫入MMT Interface<BR>");	

									// -- 取此次MMT 的Transaction ID 作為Group ID
									Statement stateMSEQ=con.createStatement();	             
									ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
									if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
									rsMSEQ.close();
									stateMSEQ.close();

									if (woType.equals("3"))	
									{ 
										if (altRouting==null || altRouting.equals("") || altRouting.equals("1")) 
										{
											opSupplierLot = aMFGRCExpTransCode[i][1];	 // 一般自製工令,以流程卡作為批號
										} 
										else if (altRouting.equals("2")) 
										{  
											//opSupplierLot = aMFGRCExpTransCode[i][1]; 以PO收料廠商批號作入系統的批號		
										}  
									} else {
										opSupplierLot = aMFGRCExpTransCode[i][1];	 // 一般自製工令,以流程卡作為批號
									}  

									//out.println("Stepa.寫入MMT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
									//out.println("Step supplierLotNo = "+supplierLotNo+"<BR>");	  
									String sqlInsMMT = "insert into MTL_TRANSACTIONS_INTERFACE( "+
												"TRANSACTION_INTERFACE_ID, SOURCE_CODE, SOURCE_HEADER_ID, SOURCE_LINE_ID, PROCESS_FLAG, "+
												"TRANSACTION_MODE, INVENTORY_ITEM_ID, ORGANIZATION_ID, SUBINVENTORY_CODE, TRANSACTION_QUANTITY, "+
												"TRANSACTION_UOM, PRIMARY_QUANTITY, TRANSACTION_DATE, TRANSACTION_SOURCE_ID, TRANSACTION_TYPE_ID, "+
												"WIP_ENTITY_TYPE, OPERATION_SEQ_NUM, LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, "+
												"ATTRIBUTE1, ATTRIBUTE2, LOCK_FLAG, TRANSACTION_HEADER_ID, FINAL_COMPLETION_FLAG, VENDOR_LOT_NUMBER, TRANSACTION_SOURCE_TYPE_ID ) "+
												" VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 'WIP', "+     // SOURCE_CODE,
												" ?,?,1,"+                                                   // PROCESS_FLAG, --1 - Yes
												" 2,"+                                                       // TRANSACTION_MODE,  --2 - Concurrent  ,3 - Background
												" ?,?,?,?,?,?,SYSDATE, "+                                    // TRANSACTION_DATE,
												" ?,44, "+                                                   // TRANSACTION_TYPE_ID,    --44 WIP Assembly Completion
												" 1, "+                                                      // WIP_ENTITY_TYPE,   --1 - Standard discrete jobs   3 - Non-standard
												" ?,SYSDATE, "+                                              // LAST_UPDATE_DATE
												" -1, "+                                                     // LAST_UPDATED_BY
												" SYSDATE, "+                                                // CREATION_DATE
												" ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',?, 5 ) ";  // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error可以重新被Repeocess)
									// TRANSACTION_SOURCE_TYPE_ID = 5 = WIP
									PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
									mmtStmt.setInt(1,Integer.parseInt(entityId));   // SOURCE_HEADER_ID(Wip_Entity_id)
									mmtStmt.setInt(2,Integer.parseInt(entityId));	  // SOURCE_LINE_ID(Wip_Entity_id)
									mmtStmt.setInt(3,primaryItemID);	              // INVENTORY_ITEM_ID 
									mmtStmt.setInt(4,Integer.parseInt(organizationID));	  // ORGANIZATION_ID  
									mmtStmt.setString(5,compSubInventory);	      // SUBINVENTORY_CODE  
									mmtStmt.setFloat(6,Float.parseFloat(aMFGRCExpTransCode[i][2]));     // TRANSACTION_QUANTITY
									mmtStmt.setString(7,woUOM);	                  // TRANSACTION_UOM
									mmtStmt.setFloat(8,Float.parseFloat(aMFGRCExpTransCode[i][2]));	  // PRIMARY_QUANTITY 
									mmtStmt.setInt(9,Integer.parseInt(entityId));	  // TRANSACTION_SOURCE_ID(Wip_Entity_id)
									mmtStmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][4]));    // OPERATION_SEQ_NUM
									mmtStmt.setInt(11,Integer.parseInt(userMfgUserID));               // CREATED_BY
									mmtStmt.setString(12,oeOrderNo);                          //ATTRIBUTE1  MO_NO
									mmtStmt.setString(13,opSupplierLot);                      //ATTRIBUTE2 LOT_NO (流程卡號) 
									mmtStmt.setString(14,opSupplierLot);                      //VENDOR_LOT_NUMBER  SUPPLIER_LOT_NO
									mmtStmt.executeUpdate();
									mmtStmt.close();		

									out.println("Step2. 寫入MMT Lot Interface<BR>");
									String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
										  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
										  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, ATTRIBUTE1, ATTRIBUTE2 ) "+ 
										  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?) ";
									PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
									mmtLotStmt.setString(1,opSupplierLot);    // LOT_NUMBER(流程卡號)
									mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCExpTransCode[i][2]));	   // TRANSACTION_QUANTITY
									mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCExpTransCode[i][2]));	   // PRIMARY_QUANTITY 
									mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	       // LAST_UPDATED_BY 								 
									mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
									mmtLotStmt.setString(6,oeOrderNo);                           //ATTRIBUTE1  MO_NO
									mmtLotStmt.setString(7,opSupplierLot);                       //ATTRIBUTE2 LOT_NO (流程卡號)
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
									/*		  		    

									out.println("Step3. 呼叫TSC WIP_MMT_REQUEST <BR>");	
									//	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
									CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MMT_REQUEST(?,?,?,?,?,?)}");			 
									cs3.setString(1,grpHeaderID);     //*  Group ID 	
									cs3.setString(2,userMfgUserID);    //  user_id 修改人ID /	
									cs3.setString(3,respID);  //*  使用的Responsibility ID --> YEW_INV_Semi_SU /				 
									cs3.registerOutParameter(4, Types.INTEGER); 
									cs3.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
									cs3.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");
									int requestID = cs3.getInt(4);
									devStatus = cs3.getString(5);   //  回傳 REQUEST 執行狀況
									devMessage = cs3.getString(6);   //  回傳 REQUEST 執行狀況訊息
									cs3.close();
									*/			 
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
								// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄

								//抓不足欄位資料  ORDER NO
								String orderHeaderId="",orderLineId=""; 
								String sqlfnd = " select YWA.OE_ORDER_NO,YWA.ORDER_HEADER_ID,YWA.ORDER_LINE_ID,YWA.INV_ITEM   "+
												"   from APPS.YEW_WORKORDER_ALL YWA ,APPS.YEW_RUNCARD_ALL YRA   "+
												"  where YWA.WO_NO=YRA.WO_NO and YRA.RUNCARD_NO= '"+aMFGRCExpTransCode[i][1]+"' ";	 		
								//out.println(sqlfnd);				
								Statement stateFndId=con.createStatement();
								ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
								if (rsFndId.next())
								{
									oeOrderNo = rsFndId.getString("OE_ORDER_NO"); 
									orderHeaderId = rsFndId.getString("ORDER_HEADER_ID");
									orderLineId = rsFndId.getString("ORDER_LINE_ID");
									invItem = rsFndId.getString("INV_ITEM");
									//out.print("2.oeOrderNo="+oeOrderNo+"<br>"); 
								} else {  oeOrderNo = "0"; }
								rsFndId.close();
								stateFndId.close(); 

								if ((woType=="3" || woType.equals("3") || oeOrderNo.length()>1) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface需成功寫入才寫Reservaton
								{
									String sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
									float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;

									try
									{ 			
										//out.println("orderno="+oeOrderNo+"  orderLineId="+orderLineId);

										//抓不足欄位資料  mtl_sales_orders HEADER_ID
										String sqlfndb = "SELECT sales_order_id FROM mtl_sales_orders a, oe_order_headers_all b ,oe_transaction_types_tl c  "+
										" WHERE a.segment1 = b.order_number  and b.order_number='"+oeOrderNo+"' and b.SHIP_FROM_ORG_ID = "+organizationId+" "+
										"   and a.segment2=c.name  and c.transaction_type_id=b.order_type_id   and c.language='US' ";

										//out.println(sqlfndb);
										Statement stateFndIdb=con.createStatement();
										ResultSet rsFndIdb=stateFndIdb.executeQuery(sqlfndb);
										if (rsFndIdb.next())
										{
											sourceHeaderId = rsFndIdb.getString("sales_order_id"); 
										}
										rsFndIdb.close();
										stateFndIdb.close(); 

										Statement stateSplit=con.createStatement();
										ResultSet rsSplit=stateSplit.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID="+orderHeaderId+" and SPLIT_FROM_LINE_ID ="+orderLineId+" and OPEN_FLAG='Y' ");
										if (rsSplit.next())
										{
											orderLineId = rsSplit.getString("LINE_ID"); // 2007/01/30 By Kerwin for Split Line Close,Find Split lind Id
										}
										rsSplit.close();
										stateSplit.close(); 

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
										else if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > avaiResvQty)   //流程卡數>可保留數
										{
											resvFlag ="Y";
											resTxnQty=avaiResvQty;               //resversion qty=剩餘可保留數
											out.print("<br>入庫數大於訂單數,執行訂單數保留!");
											//out.print("HostQQQ");
										}
										else
										{
											resTxnQty =  Float.parseFloat(aMFGRCExpTransCode[i][2]) ;   //resversion qty=流程卡數量
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

											out.println("<br>Step4. 寫入Reservations Interfac<BR>");	
											String sqlInsRSIN = "  insert into MTL_RESERVATIONS_INTERFACE( "+
												" RESERVATION_INTERFACE_ID,RESERVATION_BATCH_ID,REQUIREMENT_DATE  "+
												" ,ORGANIZATION_ID,TO_ORGANIZATION_ID,INVENTORY_ITEM_ID,ITEM_SEGMENT1 "+
												" ,DEMAND_SOURCE_TYPE_ID,RESERVATION_UOM_CODE,RESERVATION_QUANTITY,SUPPLY_SOURCE_TYPE_ID "+
												" ,ROW_STATUS_CODE,LOCK_FLAG,RESERVATION_ACTION_CODE,TRANSACTION_MODE,VALIDATION_FLAG "+
												" ,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY "+
												" ,SUBINVENTORY_CODE,TO_DEMAND_SOURCE_TYPE_ID,TO_SUPPLY_SOURCE_TYPE_ID "+
												" ,LOT_NUMBER,DEMAND_SOURCE_HEADER_ID,DEMAND_SOURCE_LINE_ID) "+ 
												"  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,?,sysdate,?,?,?,?,?,?,?) ";			
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
											rsInStmt.setString(22,opSupplierLot);	                        //lot number
											//  out.print("<br>sourceHeaderId="+sourceHeaderId);	
											rsInStmt.setInt(23,Integer.parseInt(sourceHeaderId));	       //DEMAND_SOURCE_HEADER_ID  sourceHeaderId
											rsInStmt.setInt(24,Integer.parseInt(orderLineId));           //DEMAND_SOURCE_LINE_ID   order_line_id
											//  out.print("<br>orderLineId="+orderLineId);		

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
											cs3.setString(6,opSupplierLot);  //*  RUNCARD NO (可能是外購廠商批號)	
											cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
											cs3.execute();
											out.println("Procedure : Execute Success !!! ");
											int requestID = cs3.getInt(3);
											devStatus = cs3.getString(4);   //  回傳 REQUEST 執行狀況
											devMessage = cs3.getString(5);   //  回傳 REQUEST 執行狀況訊息
											cs3.close();

											//java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷		 	  				 

											/*   // 2007/01/20 改為引用 Oracle 標準的 Reservation Processor		 		 	  				 
											CallableStatement cs3 = con.prepareCall("{call INV_RESERVATIONS_INTERFACE.rsv_interface_manager(?,?,?,?,?)}");
											cs3.registerOutParameter(1, Types.VARCHAR);                  // x_errbuf
											cs3.registerOutParameter(2, Types.INTEGER);                  // x_retcode			 
											cs3.setInt(3,1);                                //   p_api_version_number	
											cs3.setString(4,"F");                           //*  fnd_api.g_false					
											cs3.setString(5,"N");				             //   p_form_mode
											cs3.execute();
											 out.println("Procedure : 執行Oracle庫存保留Procedure !!! ");					 			 
											int requestID = cs3.getInt(2);	  // 把 Return Code 給 Request ID				
											devMessage = cs3.getString(1);   // 回傳 x_errbuf 執行狀況 ( x_errbuf )	
											devStatus = Integer.toString(cs3.getInt(2));       // 回傳 x_retcode ( x_retcode )		
											 cs3.close();	  
											*/	 

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

								// 判斷完成MMT亦被寫入後,方更新該流程卡狀態至工令待結案	 
								if (errorMsg.equals("") && woPassFlag.equals("Y"))
								{ 
									// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄	
									String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
												" QTY_IN_SCRAP=?, "+
												// " PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
												" CLOSED_DATE=?, COMPLETION_QTY=?, QTY_IN_COMPLETE=? "+
												" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
									PreparedStatement rcStmt=con.prepareStatement(rcSql);
									//out.print("rcSql="+rcSql);           
									rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
									rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
									{ //out.println("第一站不為最後一站");
										rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
										rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));				
									} else { // 否則,即更新至 048 完工入庫
										//out.println("第一站為最後一站");
										rcStmt.setString(3,"048"); 
										rcStmt.setString(4,"CLOSING");					   
									}
									rcStmt.setFloat(5,rcScrapQty); //out.println("rcScrapQty="+rcScrapQty);
									rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //out.println("rcScrapQty="+rcScrapQty);
									rcStmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2]));  //out.println("aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]);	
									rcStmt.setFloat(8,Float.parseFloat(aMFGRCExpTransCode[i][2]));  //out.println("aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]);		    
									rcStmt.executeUpdate();   
									rcStmt.close(); 

									// 找追溯表母流程卡的流程卡號將WIP_USED_QTY欄位作累加_起
									Statement stateParRC=con.createStatement();
									//String sqlParRC= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
									//out.println("sqlParRC="+sqlParRC+"<BR>");					                                     
									ResultSet rsParRC=stateParRC.executeQuery("select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+aMFGRCExpTransCode[i][1]+"' ");
									if (rsParRC.next())
									{
										PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCExpTransCode[i][2])+" where RUNCARD_NO='"+rsParRC.getString("PRIMARY_NO")+"' ");
										rcStmtUP.executeUpdate();   
										rcStmtUP.close(); 
									}
									rsParRC.close();
											
									// 找追溯表母流程卡的流程卡號將WIP_USED_QTY欄位作累加_起

									String woSql=" update APPS.YEW_WORKORDER_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+		                  
												// " PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
												" DATE_COMPLETED=to_char(SYSDATE,'YYYYMMDDHH24MISS'), WO_COMPLETED_QTY=WO_COMPLETED_QTY+"+Float.parseFloat(aMFGRCExpTransCode[i][2])+" "+
												" where WO_NO= '"+woNo+"' "; 	
									PreparedStatement woStmt=con.prepareStatement(woSql);
									woStmt.setInt(1,Integer.parseInt(userMfgUserID));
									woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									woStmt.setString(3,"048"); 
									woStmt.setString(4,"CLOSING");			 
									//woStmt.setFloat(5,Float.parseFloat(aMFGRCExpTransCode[i][2])); 
									//woStmt.setFloat(6,Float.parseFloat(aMFGRCExpTransCode[i][2]));
									woStmt.executeUpdate();   
									woStmt.close();

									//找追溯表母流程卡的工令號將WO_USED_QTY欄位作累加_起
									//Statement stateParRC=con.createStatement();
									//String sqlParRC= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
									//out.println("sqlParRC="+sqlParRC+"<BR>");					                                     
									rsParRC=stateParRC.executeQuery("select PRIMARY_PARENT_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+woNo+"' ");
									if (rsParRC.next())
									{
										PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCExpTransCode[i][2])+" where WO_NO='"+rsParRC.getString("PRIMARY_PARENT_NO")+"' ");   //20061128 LILING UPDATE YEW_WORKORDER_ALL ->YEW_RUNCARD_ALL
										rcStmtUP.executeUpdate();   
										rcStmtUP.close(); 
									}
									rsParRC.close();
									stateParRC.close();				
									// 找追溯表母流程卡的工令號將WO_USED_QTY欄位作累加_迄

								}  // End of if (errorMsg.equals(""))			  

							} // end of if (getRetScrapCode==0 && getRetCode==0)   
							else {
								interfaceErr = true; // 表示移站Interface有異常
							} // End of else

						} // end of if (aMFGRCExpTransCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢   
						out.print("<BR><font color='#0033CC'>流程卡("+aMFGRCExpTransCode[i][1]+")已入庫O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");   
					} // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID等於陣列內容
				} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新

			} // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
		} // end of if (aMFGRCExpTransCode!=null) 

		//out.print("流程卡投產O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		if (!nextOpSeqNum.equals("0") && !interfaceErr) // 若下一站不等於最後一站且Interface無異常
		{
%>
<script LANGUAGE="JavaScript">
alert("此流程卡已至製程最終站");
//reProcessFormConfirm("此流程卡已至製程最終站,是否繼續執行此張流程卡移站作業?","../jsp/TSCMfgRunCardComplete.jsp","<!--%=woNo%>","<!--%=runCardNo%-->");
</script>
<%	
		} else {
%>
<script LANGUAGE="JavaScript">
alert("此流程卡已完工並入庫(CLOSING)..請繼續執行此張工令或流程卡結案作業!!!");
</script>
<%	
		}

		// 使用完畢清空 2維陣列
		if (aMFGRCExpTransCode!=null)
		{ 
			arrMFGRCExpTransBean.setArray2DString(null); 
		}

		//out.println("<BR>Done");
	}
	//MFG流程卡投產中_迄 (ACTION=012)   流程卡已展開042 --> 流程卡移站中046 // 如為n站, 即 第一站 -->  第 n 站

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="044>044";
	//MFG流程卡移站中_起	(ACTION=006)   流程卡移站中044 --> 流程卡移站中044
	if (actionID.equals("006") && fromStatusID.equals("044"))   // 如為n站, 第2站 --> 第 n-1 站
	{   //out.println("fromStatusID="+fromStatusID);
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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起

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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄 

				//抓取移站數量的單位_起	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID, a.OE_ORDER_NO from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
							 " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
				Statement stateUOM=con.createStatement();
				ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
				if (rsUOM.next())
				{
					woUOM = rsUOM.getString("WO_UOM");
					entityId =  rsUOM.getString("WIP_ENTITY_ID");
					primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
					oeOrderNo = rsUOM.getString("OE_ORDER_NO");
				}
				rsUOM.close();
				stateUOM.close();
				//抓取移站數量的單位_迄   

			} // End of if (aMFGRCMovingCode.length>0) 	  

			for (int i=0;i<aMFGRCMovingCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
					// 判斷被Check 的Line 才執行指派作業
					if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
					{ //out.println("aMFGRCMovingCode[i][0]="+aMFGRCMovingCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");

						if (Float.parseFloat(aMFGRCMovingCode[i][2])>0) // 若設定移站數量大於0才進行移站及報廢 
						{

							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCMovingCode[i][5]==null || aMFGRCMovingCode[i][5]=="0" || aMFGRCMovingCode[i][5].equals("0")) 
							{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
								toIntOpSType = 3; 
								aMFGRCMovingCode[i][5] = aMFGRCMovingCode[i][4]; // 無下一站的Seq No,故給本站
								transType = 2;
							}  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)

							//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
							float  rcMQty = 0;   
							float  rcScrapQty = 0;    
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 

							String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY "+
										 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
										 "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // 取QUEUE移站數量
										 "     and b.RUNCARD_NO='"+aMFGRCMovingCode[i][1]+"' and to_char(c.FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][3]+"' ";
							//out.println("sqlMQty ="+sqlMQty);				 
							Statement stateMQty=con.createStatement();
							ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
							if (rsMQty.next())
							{

								if (aMFGRCMovingCode[i][2]==null || aMFGRCMovingCode[i][2].equals("null")) aMFGRCMovingCode[i][2]=Float.toString(rcMQty);
								rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//原前站完工數量	
								//out.println("rcMQty ="+rcMQty);		
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCMovingCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   

								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();

								//out.println("java四捨五入後取小數三位rcScrapQty="+rcScrapQty+"<BR>");
							}
							rsMQty.close();
							stateMQty.close();
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
							if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
							{	
								// *****%%%%%%%%%%%%%% 移站報廢數量  %%%%%%%%%%%%**********  起
								toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
								transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
								String SqlScrap="insert into WIP_MOVE_TXN_INTERFACE( "+
											"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
											"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
											"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
											"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
											"            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
											"     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?,WIP_TRANSACTIONS_S.NEXTVAL ) ";   
								// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
								PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
								scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  ( 2006/12/08 改為 RUNNING )   
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>流程卡:"+aMFGRCMovingCode[i][1]+"(報廢數量="+rcScrapQty+")<BR>");	       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
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
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // 取此次報廢的group
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入Interface的Group等資訊_迄  
								//out.println("<BR>報廢的groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	     /*
										CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
										cs5.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
										cs5.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
										cs5.setInt(3,groupID);                                         //  Org ID 	
										cs5.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
										cs5.setInt(5,timeOut); 
										cs5.setInt(6,opSeqNo);                // User ID 					 					      						   	 					     
										cs5.execute();					      
										getErrScrapBuffer = cs5.getString(1);		
										getRetScrapCode = cs5.getInt(2);								      				    
										cs5.close();						  
										*/
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

										/*	   						 
										if (getRetScrapCode>0)
										{
											String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
														   "where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
											Statement stateTxnMsg=con.createStatement();
											ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
											if (rsTxnMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫
											{
												getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
											}
											rsTxnMsg.close();
											stateTxnMsg.close(); 
										}		
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_起  
										String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
														 " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+
														 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"' "+
														 "   and PRIMARY_QUANTITY = "+rcScrapQty+"  "+  // 報廢數
														 "   and TO_INTRAOPERATION_STEP_TYPE = 5 and GROUP_ID="+groupID+" ";   // 取此次報廢
										Statement stateGrpMsg=con.createStatement();
										ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
										if (rsGrpMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫入Move Transaction, 更正getRetScrapCode = 0
										{
											getRetScrapCode = 0; 
											if (getErrScrapBuffer!=null && !getErrScrapBuffer.equals("null")) out.println("含錯誤訊息,仍成功寫入報廢數Interface!!!");
										} else {
												
										}
										rsGrpMsg.close();
										stateGrpMsg.close();
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_迄			  	  
										*/
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄	

							} // End of if (rcScrapQty>0)	

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;  
							float prevQty = 0;		   		     
							if (getRetScrapCode==0)   // 若本站報廢成功,則進行移站Interface
							{  // *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  起
								//判斷是否有overcompletion
								String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
								"  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCMovingCode[i][3]+"' "+
								"    and runcard_no = '"+aMFGRCMovingCode[i][1]+"' ";
								//out.print("<br>sqlpre="+sqlpre);
								Statement statepre=con.createStatement();
								ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
									prevQty = rspre.getFloat(1);  //前次移站數
								}
								rspre.close();
								statepre.close();

								//判斷是否有overcompletion
								if (Float.parseFloat(aMFGRCMovingCode[i][2]) > prevQty )   //若移站數大於流程卡數,表示overcompletion
								{   //out.print("<br>前站移站數="+prevQty);
									overQty = Float.parseFloat(aMFGRCMovingCode[i][2]) - prevQty ;    //移站數-流程卡數=超出數量
									overFlag = "Y";   //給定超收的flag
								}else  { overFlag = "N"; }
								//out.print("<br>overQty="+overQty);    
								toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1
								String Sqlrc="";
								String Sqlrc1="insert into WIP_MOVE_TXN_INTERFACE( "+
											"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
											"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
											"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
											"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
								String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
								String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
								String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
								String Sqlrcv5= " ) ";

								if (overFlag == "Y" || overFlag.equals("Y"))
								{ Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; }
								else
								{ Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; }
								//out.print("Sqlrc="+Sqlrc);

								PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
								seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/08 改為 2)
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCMovingCode[i][2])); // 移站數量
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCMovingCode[i][2])); 
								//out.println("數量="+aMFGRCMovingCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCMovingCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
								seqstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//抓取寫入Interface的Group等資訊_起
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
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

								//out.println("<BR>移站的groupID ="+groupID+"<BR>");	 

								//抓取寫入Interface的Group等資訊_迄		

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	
										/*
										CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
										cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
										cs4.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
										cs4.setInt(3,groupID);                                         //  Org ID 	
										cs4.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
										cs4.setInt(5,timeOut); 
										cs4.setInt(6,opSeqNo);                // User ID 					 					      						   	 					     
										cs4.execute();					      
										getErrBuffer = cs4.getString(1);		
										getRetCode = cs4.getInt(2);								      				    
										cs4.close();						  
										out.println("getRetCode="+getRetCode+"&nbsp;"+"getErrBuffer="+getErrBuffer+"<BR>");
										*/
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

										/*	  
										if (getRetCode>0)
										{
											String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
															   "where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
											Statement stateTxnMsg=con.createStatement();
											ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
											if (rsTxnMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫
											{
												getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
											}
											rsTxnMsg.close();
											stateTxnMsg.close(); 
										}		
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_起  
										String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
														 " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+
														 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"' "+
														 "   and PRIMARY_QUANTITY = "+Float.parseFloat(aMFGRCMovingCode[i][2])+"  "+  // 移站數
														 "   and TO_INTRAOPERATION_STEP_TYPE = 1 and  GROUP_ID = "+groupID+" ";   // 取此次移站
										Statement stateGrpMsg=con.createStatement();
										ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
										if (rsGrpMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫入Move Transaction, 更正getRetCode = 0
										{
											getRetCode = 0; 
											if (getErrBuffer!=null && !getErrBuffer.equals("null")) out.println("含錯誤訊息,仍成功寫入移站數Interface!!!");
										} else {
											   
										}
										rsGrpMsg.close();
										stateGrpMsg.close();
										// 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_迄			  	  
										*/
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  迄

							} // End of if (getRetScrapCode==0)   // 若本站報廢成功,則進行移站Interface

							if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新
							{ 
								// 若成功,則更新RUNCARD 資料表相關欄位
								// 取成功移站後,前一站,本站,下一站相關資訊RUNCARD_ALL資料表更新
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // 預設本站不為最後一站
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
												"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
												"  from WIP_OPERATIONS "+
												"  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ";	 
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
										out.println("下一站代碼="+nextOpSeqNum);
									}  	
								} else {
									operationSeqNum   = "0";
									operationSeqId    = "0";
									standardOpId  	  = "0";
									standardOpDesc   = "0"; 
									previousOpSeqNum  = "0"; 
									nextOpSeqNum	  = "0"; 
									// 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
									Statement stateMax=con.createStatement();
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"'  and WIP_ENTITY_ID ="+entityId+" ");
									if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
									{
										singleOp = true;					   
									} else out.println("下一站代碼="+rsMax.getString(1));
									rsMax.close();
									stateMax.close();

								}
								rsp.close();
								statep.close(); 				   

								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_起
								float overValue=0;

								if (overFlag =="Y" || overFlag.equals("Y"))
								{  //out.print("FM_OPERATION_SEQ_NUM="+aMFGRCMovingCode[i][4]);
									String sqlOver=" select OVERCOMPLETION_PRIMARY_QTY from wip_move_transactions where TO_INTRAOPERATION_STEP_TYPE=1 "+
													"    and ATTRIBUTE2= '"+aMFGRCMovingCode[i][1]+"' and FM_OPERATION_SEQ_NUM = "+aMFGRCMovingCode[i][4]+" ";
									Statement stateOver=con.createStatement();	   
									ResultSet rsOver=stateOver.executeQuery(sqlOver); 
									if (rsOver.next())
									{ overValue = rsOver.getFloat(1); }
									rsOver.close();
									stateOver.close();	
								} else overValue=0;

								String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE , OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
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
								queueTransStmt.setFloat(18,overValue);    //OVERCOMPLETE_QTY
								queueTransStmt.executeUpdate();
								queueTransStmt.close();	    	 
								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 	

								if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
								{ 		 
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_起
									String SqlScrapTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
															"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
															"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
															"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
															"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
															"            LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
															"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
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

									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_迄 
								}  // End of if (rcScrapQty>0)					    

								String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
											" QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
											" QTY_IN_QUEUE=? "+
											" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCMovingCode[i][0]+"' "; 	
								PreparedStatement rcStmt=con.prepareStatement(rcSql);
								//out.print("rcSql="+rcSql);           
								rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
								rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
								if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
								{
									rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
									rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
								} else { // 否則,即更新至 046 完工入庫
									rcStmt.setString(3,"046"); 
									rcStmt.setString(4,"COMPLETING");
								}
								rcStmt.setFloat(5,rcScrapQty); 
								rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 
								rcStmt.setInt(7,Integer.parseInt(standardOpId));
								rcStmt.setString(8,standardOpDesc);
								rcStmt.setInt(9,Integer.parseInt(operationSeqId));
								rcStmt.setInt(10,Integer.parseInt(operationSeqNum));
								rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
								rcStmt.setFloat(12,Float.parseFloat(aMFGRCMovingCode[i][2])); 
								rcStmt.executeUpdate();   
								rcStmt.close(); 

							} // End of if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新  
							else {
								interfaceErr = true; //  報廢或移站有異常,則JavaScript告知使用者
							}

						} // End of if (aMFGRCMovingCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢
						out.print("<font color='#0033CC'>流程卡("+aMFGRCMovingCode[i][1]+")移站O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font><BR>");   
					} // End of if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新

			} // End of for (i=0;i<aMFGRCMovingCode.length;i++)
		} // end of if (aMFGRCMovingCode!=null) 

		if (!interfaceErr)  // 如果報廢或移站都無異常,則再判斷是否為最後站
		{
			if (!nextOpSeqNum.equals("0"))
			{
%>
<script LANGUAGE="JavaScript">
alert("MOVING");
//reProcessFormConfirm("是否繼續執行此張流程卡移站作業?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%	
			} else {
%>
<script LANGUAGE="JavaScript">
alert("已達Rounting最後一站");
//reProcessFormConfirm("         已達Rounting最後一站\n 是否繼續執行此張流程卡完工入庫作業?","../jsp/TSCMfgRunCardComplete.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%
			}
		}	else {  // 否則,Java Script 告知使用者Interface異常
%>
<script LANGUAGE="JavaScript">
alert("Oracle報廢或移站異常,請洽MIS查明原因!!!");
</script>
<%  
		}


		// 使用完畢清空 2維陣列
		if (aMFGRCMovingCode!=null)
		{ 
			arrMFGRCMovingBean.setArray2DString(null); 
		}

	} 
	//MFG流程卡移站中_迄	(ACTION=006)   流程卡移站中044 --> 流程卡移站中044

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="044>046";
	//MFG流程卡完工入庫_起	(ACTION=012)   流程卡移站中044 --> 流程卡完工入庫046(需判斷是否本站為最後一站)
	if (actionID.equals("012") && fromStatusID.equals("046"))   // 如為 n站, 即第 n-1站 --> 第 n 站
	{  
		String fndUserName = "";  //處理人員
		String woUOM = ""; // 工令移站單位
		String compSubInventory = null;
		String altRouting = "1"; //
		String opSupplierLot = "";
		int primaryItemID = 0;
		float runCardQtyf=0,overQty=0; 
		entityId = "0"; // 工令wip_entity_id
		boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
		if (aMFGRCCompleteCode!=null)
		{	  
			if (aMFGRCCompleteCode.length>0)
			{    
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起

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
				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄 

				//抓取移站數量的單位_起	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID ,a.OE_ORDER_NO,a.COMPLETION_SUBINVENTORY, "+
							 "                 a.ALTERNATE_ROUTING, a.SUPPLIER_LOT_NO, a.ORGANIZATION_ID "+
							 "   from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
							 " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
				Statement stateUOM=con.createStatement();
				ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
				if (rsUOM.next())
				{
					woUOM = rsUOM.getString("WO_UOM");
					entityId =  rsUOM.getString("WIP_ENTITY_ID");
					primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
					oeOrderNo = rsUOM.getString("OE_ORDER_NO");
					compSubInventory = rsUOM.getString("COMPLETION_SUBINVENTORY");	  // 入庫subInventory
					altRouting = rsUOM.getString("ALTERNATE_ROUTING");
					opSupplierLot = rsUOM.getString("SUPPLIER_LOT_NO");
					organizationId = rsUOM.getString("ORGANIZATION_ID");
				}
				rsUOM.close();
				stateUOM.close();
				//抓取移站數量的單位_迄   	  
			} // End of if (aMFGRCCompleteCode.length>0) 	
			for (int i=0;i<aMFGRCCompleteCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
				// 判斷被Check 的Line 才執行指派作業
					if (choice[k]==aMFGRCCompleteCode[i][0] || choice[k].equals(aMFGRCCompleteCode[i][0]))
					{ //out.println("aMFGRCCompleteCode[i][0]="+aMFGRCCompleteCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");  

						if (Float.parseFloat(aMFGRCCompleteCode[i][2])>=0) // 若設定移站數量大於0才進行移站及報廢
						{
							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCCompleteCode[i][5]==null || aMFGRCCompleteCode[i][5]=="0" || aMFGRCCompleteCode[i][5].equals("0")) 
							{ // 若無下一站序號,則表示本站即為最終站,相關動作設定為完工
								toIntOpSType = 3; 
								aMFGRCCompleteCode[i][5] = aMFGRCCompleteCode[i][4]; // 無下一站的Seq No,故給本站
								transType = 2;
							}  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)

							//抓取個別流程卡移站數量的單位,並計算本站報廢數量_起	
							float  rcMQty = 0;   
							float  rcScrapQty = 0;  
							String supplierLotNo = null;   
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 

							String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY, "+
										 "         a.COMPLETION_SUBINVENTORY, a.WAFER_LOT_NO "+
										 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
										 "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 "+
										 "     and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // 取QUEUE移站數量若前一站為外包站,仍為1
										 "     and b.RUNCARD_NO='"+aMFGRCCompleteCode[i][1]+"' and to_char(c.FM_OPERATION_SEQ_NUM) = '"+aMFGRCCompleteCode[i][3]+"' ";        
							/* 
							String sqlMQty = " select b.QTY_IN_QUEUE, (c.QUANTITY_COMPLETED-c.QUANTITY_SCRAPPED) as PREVCOMPQTY, "+
										  "        a.COMPLETION_SUBINVENTORY, a.WAFER_LOT_NO "+
										  "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_OPERATIONS c "+
										  "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										  "     and b.RUNCARD_NO='"+aMFGRCCompleteCode[i][1]+"' and to_char(c.OPERATION_SEQ_NUM) = '"+aMFGRCCompleteCode[i][3]+"' ";
							*/
							//out.println("sqlMQty ="+sqlMQty);				 
							Statement stateMQty=con.createStatement();
							ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
							if (rsMQty.next())
							{
								if (aMFGRCCompleteCode[i][2]==null || aMFGRCCompleteCode[i][2].equals("null")) aMFGRCCompleteCode[i][2]=Float.toString(rcMQty);
								rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//原前站完工數量	
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCCompleteCode[i][2]);  // 報廢數量 = 原投站數量 - 輸入移站數量						   
								supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // 供應商批號
								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();
								//out.println("java四捨五入後取小數三位rcScrapQty="+rcScrapQty+"<BR>");
								if (fndUserName.equals("kerwin"))
								{
									//rcScrapQty = 0;
								}
								//out.println("adminModeOption="+adminModeOption);
								if (adminModeOption!=null && adminModeOption.equals("YES") && UserRoles.indexOf("admin")>=0)
								{
									rcScrapQty = Float.parseFloat(aMFGRCCompleteCode[i][11]); // 管理員模式,且手動給定了報廢數,則以給定的報廢數入Scrap

									userMfgUserID = "5753"; // 山東包裝站,PANG_LIPING
								}
							}
							rsMQty.close();
							stateMQty.close();
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
							if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
							{	
								//out.println("// *****%%%%%%%%%%%%%% 移站報廢數量  %%%%%%%%%%%%**********  起");
								toIntOpSType = 5;  // 報廢的to InterOperation Step Type = 5
								transType = 1; // 報廢的Transaction Type = 1(Move Transaction)
								String SqlScrap="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
												"            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ) "+
												"     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?, WIP_TRANSACTIONS_S.NEXTVAL ) ";   
												// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
								PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
								scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  (2006/12/08 改為 Running )     
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>流程卡:"+aMFGRCCompleteCode[i][1]+"(報廢數量="+rcScrapQty+")<BR>");       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								scrapstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(本站)		  
								scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								scrapstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][4])); // TO_OPERATION_SEQ_NUM  //報廢即為From = To
								scrapstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
								scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)報廢  ( 01-11-000-7650-951-0-000 ) 
								scrapstmt.setInt(18,7);	// REASON_ID  製程異常
								scrapstmt.executeUpdate();
								scrapstmt.close();	      	

								//抓取寫入Interface的Group等資訊_起
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // 取此次報廢的group
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
								//抓取寫入Interface的Group等資訊_迄  
								//out.println("<BR>報廢的groupID ="+groupID+"<BR>");	 

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	
										/*
										CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
										cs5.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
										cs5.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
										cs5.setInt(3,groupID);                                         //  Org ID 	
										cs5.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
										cs5.setInt(5,timeOut); 
										cs5.setInt(6,opSeqNo);                // User ID 					 					      						   	 					     
										cs5.execute();					      
										getErrScrapBuffer = cs5.getString(1);		
										getRetScrapCode = cs5.getInt(2);								      				    
										cs5.close();					
										*/
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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄	

							} // End of if (rcScrapQty>0)	

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0; 
							float prevQty = 0; 		   		     
							if (getRetScrapCode==0)   // 若本站報廢成功,則進行移站Interface
							{  // *****%%%%%%%%%%%%%% 正常完工數量  %%%%%%%%%%%%**********  起
								//判斷是否有overcompletion
								String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
												"  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCCompleteCode[i][3]+"' "+
												"    and runcard_no = '"+aMFGRCCompleteCode[i][1]+"' ";
								Statement statepre=con.createStatement();
								ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
									prevQty = rspre.getFloat(1);  //前次移站數量
								}
								rspre.close();
								statepre.close();
								//out.print("<br>prevQty="+prevQty);

								if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > prevQty )   //若移站數大於前次移站數,表示overcompletion
								{
									overQty = Float.parseFloat(aMFGRCCompleteCode[i][2]) - prevQty ;    //移站數-流程卡數=超出數量
									overFlag = "Y";   //給定超收的flag
								}else  { overFlag = "N"; }
								//out.print("<br>overQty="+overQty);    

								toIntOpSType = 3;  // 完工移站的to InterOperation Step Type = 3
								transType = 1;     // 完工的 Transaction Type(改為 Move Transaction,讓MMT去決定將工單Complete)
								//out.println("<BR>//1. *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  起");
								String Sqlrc="";
								String Sqlrc1="insert into WIP_MOVE_TXN_INTERFACE( "+
												"            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
												"            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
												"            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
												"            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ";
								String Sqlrc2=" 			,OVERCOMPLETION_TRANSACTION_QTY ";
								String Sqlrc3= "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL  ";   
								String Sqlrcv4= " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
								String Sqlrcv5= " ) ";

								if (overFlag == "Y" || overFlag.equals("Y"))
								{ Sqlrc=Sqlrc1+Sqlrc2+Sqlrcv5+Sqlrc3+Sqlrcv4+Sqlrcv5; }
								else
								{ Sqlrc=Sqlrc1+Sqlrcv5+Sqlrc3+Sqlrcv5; }

								PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
								seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
								// seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
								// seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
								seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
								seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
								seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
								seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error ( 2006/12/08 改為 Running )
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); // 移站數量
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCMovingCode[i][2])); 
								//out.println("數量="+aMFGRCMovingCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCMovingCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
								seqstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("流程卡號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 流程卡號 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//抓取寫入Interface的Group等資訊_起
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCCompleteCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
											 "   and TO_INTRAOPERATION_STEP_TYPE = 3 "; // 取此次移站的Group ID
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();

								out.println("<BR>完工的groupID ="+groupID+"<BR>");	 

								//抓取寫入Interface的Group等資訊_迄		

								if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
								{
									// 即時呼叫 WIP_MOVE PROCESS WORKER

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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% 正常完工數量  %%%%%%%%%%%%**********  迄

							} // End of if (getRetScrapCode==0)   // 若本站報廢成功,則進行移站Interface

							if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新
							{ 
								// 若成功,則更新RUNCARD 資料表相關欄位
								// 取成功移站後,前一站,本站,下一站相關資訊RUNCARD_ALL資料表更新
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // 預設本站不為最後一站
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
												"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
												"  from WIP_OPERATIONS "+
												"  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCCompleteCode[i][4]+"' "+ // 因已成功(getRetScrapCode==0 && getRetCode==0.故前一站為本站)
												"    and WIP_ENTITY_ID ="+entityId+" ";	 
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
										out.println("下一站代碼="+nextOpSeqNum);
									}  	
								} else { // 取不到,表示無下一站,本站即為下一站,故保留此流程卡最後站資訊

									// 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
									Statement stateMax=con.createStatement();
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCCompleteCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
									if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
									{
										singleOp = true;					   
									} else out.println("下一站代碼="+rsMax.getString(1));
									rsMax.close();
									stateMax.close();					 
								}
								rsp.close();
								statep.close(); 				   

								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_起
								float overValue=0;
								if (overFlag=="Y" || overFlag.equals("Y"))
								{ 
									String sqlOver=" select OVERCOMPLETION_PRIMARY_QTY from wip_move_transactions where TO_INTRAOPERATION_STEP_TYPE=1 "+
												"    and ATTRIBUTE2= '"+aMFGRCCompleteCode[i][1]+"' and FM_OPERATION_SEQ_NUM = "+aMFGRCCompleteCode[i][4]+" ";
									Statement stateOver=con.createStatement();	   
									ResultSet rsOver=stateOver.executeQuery(sqlOver); 
									if (rsOver.next())
									{ overValue = rsOver.getFloat(1); }
									rsOver.close();
									stateOver.close();	
								} else overValue=0;

								String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
													"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
													"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
													"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
													"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
													"            LASTUPDATE_DATE, OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME ) "+
													"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
								PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
								queueTransStmt.setInt(1,Integer.parseInt(aMFGRCCompleteCode[i][0])); // RUNCAD_ID          
								queueTransStmt.setString(2,aMFGRCCompleteCode[i][1]);                // RUNCARD_NO
								queueTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
								queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
								queueTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
								queueTransStmt.setInt(6,Integer.parseInt(aMFGRCCompleteCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
								queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
								queueTransStmt.setInt(8,Integer.parseInt(aMFGRCCompleteCode[i][5])); //TO_OPERATION_SEQ_NUM(下一站) 
								queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
								queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCCompleteCode[i][2]));  // Transaction Qty
								queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
								queueTransStmt.setInt(12,1);             // 1=Queue		  
								queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
								queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
								queueTransStmt.setString(15,"046"); // From STATUSID
								queueTransStmt.setString(16,"COMPLETING");	  // From STATUS
								queueTransStmt.setString(17,fndUserName);	  // Update User 
								queueTransStmt.setFloat(18,overValue);
								queueTransStmt.executeUpdate();
								queueTransStmt.close();	    	 
								// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 	

								if (rcScrapQty>0)  // 判斷若報廢數量大於零,則呼叫寫入報廢 RUNCARD Transaction
								{ 		 
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_起
									String SqlScrapTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
											"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
											"            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
											"            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
											"            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
											"            LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
											"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
									PreparedStatement scrapTransStmt=con.prepareStatement(SqlScrapTrans); 
									scrapTransStmt.setInt(1,Integer.parseInt(aMFGRCCompleteCode[i][0])); // RUNCAD_ID          
									scrapTransStmt.setString(2,aMFGRCCompleteCode[i][1]);                // RUNCARD_NO
									scrapTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
									scrapTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
									scrapTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
									scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCCompleteCode[i][4])); //FM_OPERATION_SEQ_NUM(本站)    
									scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
									scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCCompleteCode[i][4])); //TO_OPERATION_SEQ_NUM(下一站) 
									scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(下一站代碼) 
									scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
									scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
									scrapTransStmt.setInt(12,5);             // 5=SCRAP(報廢)		  
									scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
									scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
									scrapTransStmt.setString(15,"046"); // From STATUSID
									scrapTransStmt.setString(16,"COMPLETING");	  // From STATUS
									scrapTransStmt.setString(17,fndUserName);	  // Update User  
									scrapTransStmt.executeUpdate();
									scrapTransStmt.close();	    	 
									// %%%%%%%%%%%%%%%%%%% 寫入Run card Scrap Transaction %%%%%%%%%%%%%%%%%%%_迄 
								}  // End of if (rcScrapQty>0)	

								// ###################### 寫入 Reservations Interface  ################### 起   liling add 2006/10/30

								// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_起		  
								try
								{ //out.println("Step1. 寫入MMT Interface<BR>");			 

									// -- 取此次MMT 的Transaction ID 作為Group ID
									Statement stateMSEQ=con.createStatement();	             
									ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
									if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
									rsMSEQ.close();
									stateMSEQ.close();

									if (woType.equals("3"))	
									{   
										if (altRouting.equals("2")) { opSupplierLot=opSupplierLot; } // 如果後段工令且為外購,則以廠商批號作為寫入MMT 及LOT及 RESERVATION依據	
										else { // 後段工令自製
											opSupplierLot=aMFGRCCompleteCode[i][1]; // 流程卡號為批號
										}
									}	else { // 切割及前段工令
										//supplierLotNo = opSupplierLot; 
										opSupplierLot=aMFGRCCompleteCode[i][1];
									}  		  
									//out.println("Stepa.寫入MMT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
									//out.println("Step compSubInventory = "+compSubInventory+"<BR>");	  
									String sqlInsMMT = "insert into MTL_TRANSACTIONS_INTERFACE( "+
										 "TRANSACTION_INTERFACE_ID, SOURCE_CODE, SOURCE_HEADER_ID, SOURCE_LINE_ID, PROCESS_FLAG, "+
										 "TRANSACTION_MODE, INVENTORY_ITEM_ID, ORGANIZATION_ID, SUBINVENTORY_CODE, TRANSACTION_QUANTITY, "+
										 "TRANSACTION_UOM, PRIMARY_QUANTITY, TRANSACTION_DATE, TRANSACTION_SOURCE_ID, TRANSACTION_TYPE_ID, "+
										 "WIP_ENTITY_TYPE, OPERATION_SEQ_NUM, LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, "+
										 "ATTRIBUTE1, ATTRIBUTE2, LOCK_FLAG, TRANSACTION_HEADER_ID, FINAL_COMPLETION_FLAG, VENDOR_LOT_NUMBER, TRANSACTION_SOURCE_TYPE_ID ) "+
										 " VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 'WIP', "+     // SOURCE_CODE,
										 " ?,?,1,"+                                                   // PROCESS_FLAG, --1 - Yes
										 " 2,"+                                                       // TRANSACTION_MODE,  --2 - Concurrent  ,3 - Background
										 " ?,?,?,?,?,?,SYSDATE, "+                                    // TRANSACTION_DATE,
										 " ?,44, "+                                                   // TRANSACTION_TYPE_ID,    --44 WIP Assembly Completion
										 " 1, "+                                                      // WIP_ENTITY_TYPE,   --1 - Standard discrete jobs   3 - Non-standard
										 " ?,SYSDATE, "+                                              // LAST_UPDATE_DATE
										 " -1, "+                                                     // LAST_UPDATED_BY
										 " SYSDATE, "+                                                // CREATION_DATE
										 " ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',?, 5 ) ";   // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error可以重新被Repeocess)
															   // TRANSACTION_SOURCE_TYPE_ID = 5 = WIP
									PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
									mmtStmt.setInt(1,Integer.parseInt(entityId));   // SOURCE_HEADER_ID(Wip_Entity_id)
									mmtStmt.setInt(2,Integer.parseInt(entityId));	  // SOURCE_LINE_ID(Wip_Entity_id)
									mmtStmt.setInt(3,primaryItemID);	              // INVENTORY_ITEM_ID 
									mmtStmt.setInt(4,Integer.parseInt(organizationID));	  // ORGANIZATION_ID  
									mmtStmt.setString(5,compSubInventory);	      // SUBINVENTORY_CODE  
									mmtStmt.setFloat(6,Float.parseFloat(aMFGRCCompleteCode[i][2]));  //out.println("TRANSACTION_QUANTITY aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]+"<BR>");    // TRANSACTION_QUANTITY
									mmtStmt.setString(7,woUOM);	                  // TRANSACTION_UOM
									mmtStmt.setFloat(8,Float.parseFloat(aMFGRCCompleteCode[i][2]));	//out.println("PRIMARY_QUANTITY aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]+"<BR>");  // PRIMARY_QUANTITY 
									mmtStmt.setInt(9,Integer.parseInt(entityId));	  // TRANSACTION_SOURCE_ID(Wip_Entity_id)
									mmtStmt.setInt(10,Integer.parseInt(aMFGRCCompleteCode[i][4]));   //out.println("OPERATION_SEQ_NUM aMFGRCCompleteCode[i][4]="+aMFGRCCompleteCode[i][4]+"<BR>");  // OPERATION_SEQ_NUM
									mmtStmt.setInt(11,Integer.parseInt(userMfgUserID));               // CREATED_BY
									mmtStmt.setString(12,oeOrderNo);                                   //ATTRIBUTE1  MO_NO
									mmtStmt.setString(13,opSupplierLot);                              //ATTRIBUTE2  LOT_NO (流程卡號)
									mmtStmt.setString(14,opSupplierLot);                              //VENDOR_LOT_NUMBER  SUPPLIER_LOT_NO
									mmtStmt.executeUpdate();
									mmtStmt.close();		

									//out.println("Step2. 寫入MMT Lot Interface<BR>");
									String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
										  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
										  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ,ATTRIBUTE1, ATTRIBUTE2 ) "+ 
										  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?) ";
									PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
									mmtLotStmt.setString(1,opSupplierLot);                                 // LOT_NUMBER(流程卡號)
									mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	   // TRANSACTION_QUANTITY
									mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCCompleteCode[i][2]));	   // PRIMARY_QUANTITY 
									mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	//out.println("userMfgUserID"+userMfgUserID);    // LAST_UPDATED_BY 								 
									mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
									mmtLotStmt.setString(6,oeOrderNo);                             //ATTRIBUTE1  MO_NO
									mmtLotStmt.setString(7,opSupplierLot);                         //ATTRIBUTE2  LOT_NO (流程卡號)
									mmtLotStmt.executeUpdate();
									mmtLotStmt.close();
									//out.println("Stepb.寫入MMT LOT 之TRANSACTION_INTERFACE_ID="+groupId+"<BR>");	

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
									ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME like 'YEW_INV_SEMI_SU%' "); 
									if (rsResp.next())
									{
										respID = rsResp.getString("RESPONSIBILITY_ID");
									} else {
										respID = "50776"; // 找不到則預設 --> YEW INV Super User 預設
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

									/*			  
									//out.println("Step3. 呼叫TSC WIP_MMT_REQUEST <BR>");	
									//	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
									CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MMT_REQUEST(?,?,?,?,?,?)}");			 
									cs3.setString(1,grpHeaderID);     //*  Group ID 	
									cs3.setString(2,userMfgUserID);    //  user_id 修改人ID /	
									cs3.setString(3,respID);  //*  使用的Responsibility ID --> YEW_INV_Semi_SU /				 
									cs3.registerOutParameter(4, Types.INTEGER); 
									cs3.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
									cs3.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");
									int requestID = cs3.getInt(4);
									devStatus = cs3.getString(5);   //  回傳 REQUEST 執行狀況
									devMessage = cs3.getString(6);   //  回傳 REQUEST 執行狀況訊息
									cs3.close();
									*/			 
									//java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷		 	  				 

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
 
									Statement stateError=con.createStatement();
									String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
									//out.println("sqlError="+sqlError+"<BR>");					                                     
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
										out.println("Success Submit !!! <BR>");
										out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
										woPassFlag="Y";	// 成功寫入的旗標
										con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
									}

								}// end of try
								catch (Exception e)
								{
									out.println("Exception WIP_MMT_REQUEST:"+e.getMessage());
								}	
								// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄		

								//抓不足欄位資料  ORDER NO
								String orderHeaderId="",orderLineId=""; 
								String sqlfnd = " select YWA.OE_ORDER_NO,YWA.ORDER_HEADER_ID,YWA.ORDER_LINE_ID,YWA.INV_ITEM   "+
										"   from APPS.YEW_WORKORDER_ALL YWA ,APPS.YEW_RUNCARD_ALL YRA   "+
										"  where YWA.WO_NO=YRA.WO_NO and YRA.RUNCARD_NO= '"+aMFGRCCompleteCode[i][1]+"' ";	 		
								//out.println(sqlfnd);				
								Statement stateFndId=con.createStatement();
								ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
								if (rsFndId.next())
								{
									oeOrderNo = rsFndId.getString("OE_ORDER_NO"); 
									orderHeaderId = rsFndId.getString("ORDER_HEADER_ID");
									orderLineId = rsFndId.getString("ORDER_LINE_ID");
									invItem = rsFndId.getString("INV_ITEM");
									//out.print("2.oeOrderNo="+oeOrderNo+"<br>"); 
								} else {  oeOrderNo = "0"; }
								rsFndId.close();
								stateFndId.close(); 

								//out.println("oeOrderNo="+oeOrderNo);	

								// 2007/01/30 除 後段工令 外,重工或工程實驗如有MO號,仍需作 Reservation_By Kerwin
								if ((woType=="3" || woType.equals("3") || oeOrderNo.length()>1) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface需成功寫入才寫Reservaton
								{
									String sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
									float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;

									try
									{ 
										//out.println("orderno="+oeOrderNo+"  orderLineId="+orderLineId);

										//抓不足欄位資料  mtl_sales_orders HEADER_ID
										String sqlfndb = "SELECT sales_order_id FROM mtl_sales_orders a, oe_order_headers_all b ,oe_transaction_types_tl c  "+
										" WHERE a.segment1 = b.order_number  and b.order_number='"+oeOrderNo+"' and b.SHIP_FROM_ORG_ID = "+organizationId+" "+
										"   and a.segment2=c.name   and c.transaction_type_id=b.order_type_id   and c.language='US' ";
										//out.println("sqlfndb ="+sqlfndb +"<BR>");
										Statement stateFndIdb=con.createStatement();
										ResultSet rsFndIdb=stateFndIdb.executeQuery(sqlfndb);
										if (rsFndIdb.next())
										{
											sourceHeaderId = rsFndIdb.getString("sales_order_id"); 
										}
										rsFndIdb.close();
										stateFndIdb.close(); 		

										//out.println("sqlfndb ="+sqlfndb +"<BR>");
										Statement stateSplit=con.createStatement();
										ResultSet rsSplit=stateSplit.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID="+orderHeaderId+" and SPLIT_FROM_LINE_ID ="+orderLineId+" and OPEN_FLAG='Y' ");
										if (rsSplit.next())
										{
											orderLineId = rsSplit.getString("LINE_ID"); // 2007/01/30 By Kerwin for Split Line Close,Find Split lind Id
										}
										rsSplit.close();
										stateSplit.close(); 

										//out.println("  orderLineId="+orderLineId);		

										//抓已存在的reservation qty 與訂單相比  mtl_sales_orders HEADER_ID
										String sqlfndb1 =" select sum(decode(MTR.RESERVATION_UOM_CODE,'PCE',MTR.RESERVATION_QUANTITY/1000,MTR.RESERVATION_QUANTITY )) RESV_QTY, "+
												"        sum(decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY)) ORDER_QTY , "+
												"        to_char(trunc(SCHEDULE_SHIP_DATE),'YYYYMMDD') SCHEDULE_SHIP_DATE "+
												"	from MTL_RESERVATIONS MTR , OE_ORDER_LINES_ALL OOL  "+
												"	where MTR.DEMAND_SOURCE_LINE_ID(+) = OOL.LINE_ID and OOL.LINE_ID = "+orderLineId+"  "+
												"  group by SCHEDULE_SHIP_DATE ";
										//out.println("sqlfndb1="+sqlfndb1+"<BR>");
										Statement stateFndIdb1=con.createStatement();
										ResultSet rsFndIdb1=stateFndIdb1.executeQuery(sqlfndb1);
										if (rsFndIdb1.next())
										{
											requireDate = rsFndIdb1.getString("SCHEDULE_SHIP_DATE");     //需求日
											resvQty = rsFndIdb1.getFloat("RESV_QTY");    //己被保留數			  
											orderQty = rsFndIdb1.getFloat("ORDER_QTY");  //訂單數
											//out.println("resvQty="+resvQty);
											//if (resvQty==null) resvQty = 0; // 2007/01/07 保留的數量若為取到,則給0, By Kerwin			  
											avaiResvQty = orderQty - resvQty ;           //可保留數  = 訂單數量 - 已保留數
										}
										rsFndIdb1.close();
										stateFndIdb1.close(); 
										if (avaiResvQty<=0)
										{
											resvFlag ="N";
											out.print("<br>無訂單量可供Reservation,無需再執行訂單保留!");
										}
										else if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > avaiResvQty)   //流程卡數>可保留數
										{
											resvFlag ="Y";
											resTxnQty=avaiResvQty;               //resversion qty=剩餘可保留數
											out.print("<br>入庫數大於訂單數,執行訂單數保留!");
										}
										else
										{
											resTxnQty =  Float.parseFloat(aMFGRCCompleteCode[i][2]) ;   //resversion qty=流程卡數量
											out.print("<br>執行訂單數保留成功!");
											resvFlag ="Y";
										} 	 
									}// end of try
									catch (SQLException e)
									{
										out.println("Exception RESERVATIONS confirm:"+e.getMessage());
									}	

									//out.println("requireDate="+requireDate);
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
											requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // 給requireDate
											//out.println("<br>requirementDate="+requirementDate);		  

											//out.println("<br>Step4. 寫入Reservations Interface ");	
											String sqlInsRSIN = "  insert into MTL_RESERVATIONS_INTERFACE( "+
												"  RESERVATION_INTERFACE_ID,RESERVATION_BATCH_ID,REQUIREMENT_DATE  "+
												" ,ORGANIZATION_ID,TO_ORGANIZATION_ID,INVENTORY_ITEM_ID,ITEM_SEGMENT1 "+
												" ,DEMAND_SOURCE_TYPE_ID,RESERVATION_UOM_CODE,RESERVATION_QUANTITY,SUPPLY_SOURCE_TYPE_ID "+
												" ,ROW_STATUS_CODE,LOCK_FLAG,RESERVATION_ACTION_CODE,TRANSACTION_MODE,VALIDATION_FLAG "+
												" ,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY "+
												" ,SUBINVENTORY_CODE,TO_DEMAND_SOURCE_TYPE_ID,TO_SUPPLY_SOURCE_TYPE_ID "+
												" ,LOT_NUMBER,DEMAND_SOURCE_HEADER_ID,DEMAND_SOURCE_LINE_ID) "+ 
												"  VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,?,sysdate,?,?,?,?,?,?,?) ";			
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
											//	rsInStmt.setFloat(10,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	       //RESERVATION_QUANTITY
											rsInStmt.setFloat(10,resTxnQty);  //out.println("resTxnQty="+resTxnQty);	       //RESERVATION_QUANTITY		
											// out.print("<br>SOURCE_TYPE_ID");	
											rsInStmt.setInt(11,13);	       // SUPPLY_SOURCE_TYPE_ID  13:inventory
											rsInStmt.setInt(12,1);	       //--ROW_STATUS_CODE 1-active 2-inactive
											rsInStmt.setInt(13,2);	       //LOCK_FLAG 1-yes 2-no
											rsInStmt.setInt(14,1);	       //RESERVATION_ACTION_CODE --  ( 1=Insert, 2=Update, 3=Delete, 4=Transfer )
											rsInStmt.setInt(15,3);	       //RANSACTION_MODE 3-background ( 3-background   1 -ONLINE  2 -CONCURRENT  )
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
											rsInStmt.setString(22,opSupplierLot);	                      //lot number...若為後段外購,則為廠商批號,否則皆為流程卡號
											//  out.print("<br>sourceHeaderId="+sourceHeaderId);	
											rsInStmt.setInt(23,Integer.parseInt(sourceHeaderId));	     //DEMAND_SOURCE_HEADER_ID  sourceHeaderId
											rsInStmt.setInt(24,Integer.parseInt(orderLineId));           //DEMAND_SOURCE_LINE_ID   order_line_id
											//  out.print("<br>orderLineId="+orderLineId);				
											rsInStmt.executeUpdate();
											rsInStmt.close();
											//out.print(" Insert into Interface Success!!");	
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

											//out.println("<br>Step5. 呼叫TSC_YEW_INVRSVIN_REQUEST <BR>");	
											//	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
											CallableStatement cs3 = con.prepareCall("{call TSC_YEW_INVRSVIN_REQUEST(?,?,?,?,?,?,?)}");			 
											cs3.setString(1,userMfgUserID);    //  user_id 修改人ID /	
											cs3.setString(2,respID);  //*  使用的Responsibility ID --> YEW_INV_Semi_SU /				 
											cs3.registerOutParameter(3, Types.INTEGER); 
											cs3.registerOutParameter(4, Types.VARCHAR);                  //回傳 DEV_STATUS
											cs3.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_MASSAGE
											cs3.setString(6,opSupplierLot);  //*  RUNCARD NO (可能是外購廠商批號後段自製為廠商批號)	
											cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
											cs3.execute();
											//out.println("Procedure : Execute Success !!! ");
											int requestID = cs3.getInt(3);
											devStatus = cs3.getString(4);   //  回傳 REQUEST 執行狀況
											devMessage = cs3.getString(5);   //  回傳 REQUEST 執行狀況訊息
											cs3.close();

											//java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷		 	  				 

											/*   // 2007/01/20 改為引用 Oracle 標準的 Reservation Processor		 		 	  				 
											CallableStatement cs3 = con.prepareCall("{call INV_RESERVATIONS_INTERFACE.rsv_interface_manager(?,?,?,?,?)}");
											cs3.registerOutParameter(1, Types.VARCHAR);                  // x_errbuf
											cs3.registerOutParameter(2, Types.INTEGER);                  // x_retcode			 
											cs3.setInt(3,1);                                //   p_api_version_number	
											cs3.setString(4,"F");                           //*  fnd_api.g_false					
											cs3.setString(5,"N");				             //   p_form_mode
											cs3.execute();
											 out.println("Procedure : 執行Oracle庫存保留Procedure !!! ");					 			 
											int requestID = cs3.getInt(2);	  // 把 Return Code 給 Request ID				
											devMessage = cs3.getString(1);   // 回傳 x_errbuf 執行狀況 ( x_errbuf )	
											devStatus = Integer.toString(cs3.getInt(2));       // 回傳 x_retcode ( x_retcode )		
											 cs3.close();	  
											*/ 
	 
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
									}//resvFlag!="N"		 
								} //end if woType=3 
								// ###################### 寫入 Reservations Interface Manager  迄################### 迄		  

								// 判斷完成MMT亦被寫入後,方更新該流程卡狀態至工令待結案	 
								if (errorMsg.equals(""))
								{ 
									// #########################  流程卡完工後,呼叫寫入MMT及Material Transaction Lot Interface作庫存異動_迄		  

									String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
												 " QTY_IN_SCRAP=?, CLOSED_DATE=?, COMPLETION_QTY=?, QTY_IN_COMPLETE=?  "+
												//" PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=? "+
												" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCCompleteCode[i][0]+"' "; 	
									PreparedStatement rcStmt=con.prepareStatement(rcSql);
									//out.print("rcSql="+rcSql);           
									rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
									rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
									{
										rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
										rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
										//rcStmt.setString(3,"048"); 
										//rcStmt.setString(4,"CLOSING");
										// rcStmt.setFloat(5,Float.parseFloat(aMFGRCCompleteCode[i][2]));
										rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling 修正此為報廢數欄位,而非移轉數			  
									} else { // 否則,即更新至 048工令結案中
										rcStmt.setString(3,"048"); 
										rcStmt.setString(4,"CLOSING");
										//rcStmt.setFloat(5,Float.parseFloat(aMFGRCCompleteCode[i][2]));
										rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling 修正此為報廢數欄位,而非移轉數			  
									}
									rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									rcStmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	
									rcStmt.setFloat(8,Float.parseFloat(aMFGRCCompleteCode[i][2])); 			
									rcStmt.executeUpdate();   
									rcStmt.close(); 

									// 找追溯表母流程卡的流程卡號將WIP_USED_QTY欄位作累加_起
									Statement stateParRC=con.createStatement();
									//String sqlParRC= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
									//out.println("sqlParRC="+sqlParRC+"<BR>");					                                     
									ResultSet rsParRC=stateParRC.executeQuery("select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+aMFGRCCompleteCode[i][1]+"' ");
									if (rsParRC.next())
									{
										PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" where RUNCARD_NO='"+rsParRC.getString("PRIMARY_NO")+"' ");
										rcStmtUP.executeUpdate();   
										rcStmtUP.close(); 
									}
									rsParRC.close();
									//stateParRC.close();				
									// 找追溯表母流程卡的流程卡號將WIP_USED_QTY欄位作累加_起

									String woSql=" update APPS.YEW_WORKORDER_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+		                  
									// " PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
										" DATE_COMPLETED=to_char(SYSDATE,'YYYYMMDDHH24MISS'), WO_COMPLETED_QTY=WO_COMPLETED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" "+
										" where WO_NO= '"+woNo+"' "; 	
									PreparedStatement woStmt=con.prepareStatement(woSql);
									woStmt.setInt(1,Integer.parseInt(userMfgUserID));
									woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									woStmt.setString(3,"048"); 
									woStmt.setString(4,"CLOSING");			 
									//woStmt.setFloat(5,Float.parseFloat(aMFGRCCompleteCode[i][2])); 
									//woStmt.setFloat(6,Float.parseFloat(aMFGRCCompleteCode[i][2]));
									woStmt.executeUpdate();   
									woStmt.close();

									//找追溯表母流程卡的工令號將WO_USED_QTY欄位作累加_起
									//Statement stateParRC=con.createStatement();
									//String sqlParRC= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
									//out.println("sqlParRC="+sqlParRC+"<BR>");					                                     
									rsParRC=stateParRC.executeQuery("select PRIMARY_PARENT_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+woNo+"' ");
									if (rsParRC.next())
									{
										PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" where WO_NO='"+rsParRC.getString("PRIMARY_PARENT_NO")+"' ");
										rcStmtUP.executeUpdate();   
										rcStmtUP.close(); 
									}
									rsParRC.close();
									stateParRC.close();				
									// 找追溯表母流程卡的工令號將WO_USED_QTY欄位作累加_迄

								}  // End of if (errorMsg.equals(""))	   

							} // End of if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行系統流程及異動更新 
							else {
								interfaceErr = true;   // 表示報廢或完工入庫Interface有異常
							}   

						} //End of if (aMFGRCCompleteCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢	
						out.print("<BR><font color='#0033CC'>流程卡("+aMFGRCCompleteCode[i][1]+")完工入庫O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>"); 
					} // End of if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新

			} // End of for (i=0;i<aMFGRCMovingCode.length;i++)

		} // end of if (aMFGRCCompleteCode!=null) 
		//out.print("流程卡完工入庫O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		// 使用完畢清空2維陣列
		if (aMFGRCCompleteCode!=null)
		{ 
			arrMFGRCCompleteBean.setArray2DString(null); 
		}

	} // End of if (actionID.equals("012") && fromStatusID.equals("046"))
	//MFG流程卡完工入庫_迄	(ACTION=012)   流程卡移站中044 --> 流程卡完工入庫046(需判斷是否本站為最後一站)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="040>050";
	//=======未展流程卡工令刪除...起	(ACTION=021)   工令生成040 --> 工令刪除中050   add by liling 2006/10/19
	if (actionID.equals("021") && fromStatusID.equals("040"))
	{   
		errorFlag ="040>050:000";
		String woSql=" update APPS.YEW_WORKORDER_ALL set WO_STATUS=?,DISABLE_DATE=?,STATUSID=?,STATUS=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
					" where WO_NO= '"+woNo+"' "; 	
		errorFlag ="040>050:005";
		PreparedStatement woStmt=con.prepareStatement(woSql);
		//out.print("woSql="+woSql); 
		errorFlag ="040>050:010";
		woStmt.setString(1,"D");   //D:Disable
		errorFlag ="040>050:020";
		woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		errorFlag ="040>050:030";
		woStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
		errorFlag ="040>050:040";
		woStmt.setString(4,getStatusRs.getString("STATUSNAME"));
		errorFlag ="040>050:050";
		woStmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
		errorFlag ="040>050:060:userMfgUserID="+userMfgUserID;
		woStmt.setInt(6,Integer.parseInt(userMfgUserID));
		errorFlag ="040>050:450";
		woStmt.executeUpdate();
		errorFlag ="040>050:480";
		woStmt.close(); 

		errorFlag ="040>050:500";
		String sqlTrans="insert into APPS.YEW_WO_TRANSACTIONS(WO_NO,UPDATED_REASON,CREATION_DATE,CREATION_BY) "+
					"     values(?,?,?,?) ";  	
		//out.print("sqlTrans="+sqlTrans); 			   					
		PreparedStatement transStmt=con.prepareStatement(sqlTrans); 
		transStmt.setString(1,woNo); // wono       
		transStmt.setString(2,getStatusRs.getString("STATUSNAME"));  //reason         
		transStmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());   //update date
		transStmt.setInt(4,Integer.parseInt(userMfgUserID));                // update user
		transStmt.executeUpdate();
		transStmt.close();	

		errorFlag ="040>050:1000";
		String sqlTravels=" delete from YEW_MFG_TRAVELS_ALL  WHERE EXTEND_NO= '"+woNo+"' ";
		//out.print("sqlTravels="+sqlTravels); 			   					
		PreparedStatement travelsStmt=con.prepareStatement(sqlTravels); 
		travelsStmt.executeUpdate();
		travelsStmt.close();	  

	}
	//========未展流程卡工令刪除....迄	(ACTION=021)   工令生成040 --> 工令刪除中050

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="042>050";
	//=======未投產流程卡刪除,工令數量減少...起	(ACTION=021)   流程卡展開042 -->流程卡刪除中050   add by liling 2006/10/31
	if (actionID.equals("021") && fromStatusID.equals("042"))   // 
	{  
		if (aMFGRCDeleteCode!=null) 
		{

			float newWoQty=0;
			float tot_del_qty=0,wipQueueQty=0;
			String qtyIssued="",minOpNum="";
			String interfaceFlag="";
			int loadType = 3; // Default for UPDATE Job 
			int statusType = 3; // Default for Standard Job
			String allowExplosion = "Y";  // Default for Standard Job
			String inSql= "";



			if (woPassFlag==null || woPassFlag.equals("")) woPassFlag="Y";


			for (int j=0;j<aMFGRCDeleteCode.length-1;j++)     
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
					if (choice[k]==aMFGRCDeleteCode[j][0] || choice[k].equals(aMFGRCDeleteCode[j][0]))
					{
						tot_del_qty=tot_del_qty+(Float.parseFloat(aMFGRCDeleteCode[j][6]));  //選擇要刪除的流程卡數量
						//out.print("<br>未轉前tot_del_qty="+tot_del_qty); 

						//取小數三位   20070316 liling
						java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位
						String strTotDelQty = nf.format(tot_del_qty);
						java.math.BigDecimal bd = new java.math.BigDecimal(strTotDelQty);
						java.math.BigDecimal delQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
						tot_del_qty =delQty.floatValue();
						//out.print("<br>轉換後tot_del_qty="+tot_del_qty);
					} 
				} 
			}
			//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  , begin =================
			try
			{
				//======取不足欄位
				//out.print("Step1");
				String sqla = " select YWA.DEPT_NO,YWA.JOB_TYPE,YWA.INVENTORY_ITEM_ID,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.SCHEDULE_STRART_DATE STARTDATE, "+
				"        YWA.WIP_ENTITY_ID,YWA.SCHEDULE_END_DATE ENDDATE,YWA.CREATE_BY,YWA.ORGANIZATION_ID,YWA.COMPLETION_SUBINVENTORY,YWA.ROUTING_REFERENCE_ID,  "+
				"        min(to_number(WIO.OPERATION_SEQ_NUM)) MIN_OP_NUM  "+
				"   from  YEW_WORKORDER_ALL ywa,wip_operations wio	where WO_STATUS = 'R'  and ywa.wip_entity_id = wio.wip_entity_id  "+
				"     and ywa.organization_id = wio.organization_id   and WO_NO = '"+woNo+"' "+
				" group by YWA.DEPT_NO,YWA.JOB_TYPE,YWA.INVENTORY_ITEM_ID,YWA.INV_ITEM,YWA.ITEM_DESC,YWA.WO_QTY,YWA.SCHEDULE_STRART_DATE,  "+
				"           YWA.WIP_ENTITY_ID,YWA.SCHEDULE_END_DATE,YWA.CREATE_BY,YWA.ORGANIZATION_ID,YWA.COMPLETION_SUBINVENTORY,YWA.ROUTING_REFERENCE_ID   ";
				//out.print("sqla="+sqla);
				Statement statea=con.createStatement();
				ResultSet rsa=statea.executeQuery(sqla);
				if (rsa.next())
				{
					deptNo     		 = rsa.getString("DEPT_NO");  
					jobType    		 = rsa.getString("JOB_TYPE"); 			
					itemId    	 	 = rsa.getString("INVENTORY_ITEM_ID"); 
					invItem   		 = rsa.getString("INV_ITEM"); 
					itemDesc 		 = rsa.getString("ITEM_DESC"); 	
					woQty 			 = rsa.getString("WO_QTY"); 	
					startDate 		 = rsa.getString("STARTDATE"); 	
					entityId		 = rsa.getString("WIP_ENTITY_ID");
					endDate 		 = rsa.getString("ENDDATE"); 	
					organizationId   = rsa.getString("ORGANIZATION_ID");  
					defInv			 = rsa.getString("COMPLETION_SUBINVENTORY");
					routingRefID     = rsa.getString("ROUTING_REFERENCE_ID");
					minOpNum         = rsa.getString("MIN_OP_NUM");
				}
				rsa.close();
				statea.close(); 

				//取工令第一站剩餘queue數量
				String sqlb = " select QUANTITY_IN_QUEUE from wip_operations  where wip_entity_id = "+entityId+" and organization_id = "+organizationId+" and OPERATION_SEQ_NUM="+minOpNum+"  ";
				// out.print("<br>sqlb="+sqlb);
				Statement stateb=con.createStatement();
				ResultSet rsb=stateb.executeQuery(sqlb);
				if (rsb.next())
				{	wipQueueQty	 = rsb.getFloat("QUANTITY_IN_QUEUE");   }
					rsb.close();
					stateb.close(); 


					//out.print("<br>wipQueueQty="+wipQueueQty+"  tot_del_qty="+tot_del_qty);
					if (wipQueueQty < tot_del_qty)   //若工令首站queue剩餘數不足,修改queue數量=總刪卡數,以防止刪卡失敗
					{
						String woSqlq=" update wip_operations  set QUANTITY_IN_QUEUE = "+tot_del_qty+" "+
						"   where wip_entity_id = "+entityId+" and organization_id = "+organizationId+" and OPERATION_SEQ_NUM="+minOpNum+"  ";
						//out.print("<br>woSqlq="+woSqlq); 
						PreparedStatement woStmtq=con.prepareStatement(woSqlq);
						woStmtq.executeUpdate();   
						woStmtq.close(); 		
					}

					java.sql.Date startdate = null;
					startdate = new java.sql.Date(Integer.parseInt(startDate.substring(0,4))-1900,Integer.parseInt(startDate.substring(4,6))-1,Integer.parseInt(startDate.substring(6,8)));  // 給startDate

					newWoQty=(Float.parseFloat(woQty)-tot_del_qty);   //取得刪除流程卡數量
					//out.print("<br>new qty="+newWoQty);

					//取小數三位   20070316 liling
					java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位
					String strNewWoQty = nf.format(newWoQty);
					java.math.BigDecimal bd = new java.math.BigDecimal(strNewWoQty);
					java.math.BigDecimal newQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
					newWoQty =newQty.floatValue();
					//out.print("<br>轉換後newWoQty="+newWoQty+"<br>");



					//out.print("interfaceId="+interfaceId);
					PreparedStatement instmt=null;

					//若數量為'0',判斷是否有領料,若無領料則做canceled
					if (newWoQty==0)
					{
						String sqlfa = "select sum(QUANTITY_ISSUED) qty_issued from WIP_REQUIREMENT_OPERATIONS where WIP_ENTITY_ID = "+entityId+" ";	 			 
						//out.print("sqlf="+sqlfa);
						Statement statefa=con.createStatement();
						ResultSet rsfa=statefa.executeQuery(sqlfa);
						if (rsfa.next())
						{
							qtyIssued   = rsfa.getString(1); 
						}
						rsfa.close();
						statefa.close(); 

						if (qtyIssued==null || qtyIssued.equals("") || qtyIssued=="0" || qtyIssued.equals("0"))
						{
							statusType=4 ;                       //2007/04/05 liling update  7->4  
							newWoQty=Float.parseFloat(woQty);    //若刪除的數量=工令數量,則工令數量不變,但狀態改為'canceled'
							woPassFlag="Y";
							//out.print("statusType="+statusType);
							//out.print("woPassFlag="+woPassFlag);
						}
						else
						{
							%><script LANGUAGE="JavaScript">
							alert("原物料未退料,請先執行退料!!");
							</script>
							<%	
							woPassFlag="N";    //2007/04/05 liling update 
						} 
					}	//newWoQty=0 
					else woPassFlag="Y";	
					//	if ((jobType==null || jobType.equals("1")) || ( woPassFlag !="N" && !woPassFlag.equals("N")))
					if ( woPassFlag =="N" || woPassFlag.equals("N"))
					{}
					else
					{  //out.print("<br>insert into WIP_JOB_SCHEDULE_INTERFACE");

						String sqlf = "select WIP_INTERFACE_S.NEXTVAL, WIP_JOB_SCHEDULE_INTERFACE_S.NEXTVAL from dual";	 			 
						//out.print("sqlf="+sqlf);
						Statement statef=con.createStatement();
						ResultSet rsf=statef.executeQuery(sqlf);
						if (rsf.next())
						{
							interfaceId   = rsf.getString(1); 
							groupId       = rsf.getString(2); 
							//entityId      = rsf.getString(3);
						}
						rsf.close();
						statef.close(); 	

						// 屬標準工單
						inSql="insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
								"       FIRST_UNIT_START_DATE,GROUP_ID,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY,  "+
								"       WIP_ENTITY_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID,PRIMARY_ITEM_ID,  "+
								"       PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION) "+
								"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "; 
						//out.print("inSql="+inSql);				
						instmt=con.prepareStatement(inSql);     
						instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
						instmt.setInt(2,Integer.parseInt(groupId)); 
						instmt.setDate(3,processDateTime);         //lastupdate date
						instmt.setInt(4,Integer.parseInt(userMfgUserID));    //lastupdate by
						instmt.setDate(5,processDateTime);    		 //create date
						instmt.setInt(6,Integer.parseInt(userMfgUserID));     //create by
						instmt.setInt(7,Integer.parseInt(entityId));         //WIP_ENTITY_ID
						instmt.setInt(8,loadType);    						//load_type   1=create Standard Job   3=update 4=Create non-Standard job
						instmt.setFloat(9,newWoQty);   			            //net_qty
						instmt.setInt(10,Integer.parseInt(organizationId));    //organization_id
						instmt.setInt(11,Integer.parseInt(itemId));                  //item id
						instmt.setInt(12,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
						instmt.setInt(13,1);    //process_status   1 =Pending  3=error
						instmt.setFloat(14,newWoQty);   			            //start qty
						instmt.setInt(15,statusType);    //status_type      1=unlease 3=release 6=Hold  7.canceled
						instmt.setString(16,allowExplosion);    //ALLOW_EXPLOSION      Y=ALLOW_EXPLOSION N=NOT ALLOW_EXPLOSION
						instmt.executeUpdate();
						instmt.close();  
						interfaceFlag="Y";
						out.print("<br>insert into WIP_JOB_SCHEDULE_INTERFACE success!!");	

					} 
					//java.lang.Thread.sleep(10000);
				}// end of try	  		  
				catch (Exception e)
				{
					out.println("Exception WIP_JOB_SCHEDULE_INTERFACE:"+e.getMessage());
				}	

				//執行 WIP_MASS_LOAD
				try
				{
					if (interfaceFlag=="Y" || interfaceFlag.equals("Y"))
					{
					//out.print("<br>call mass load!!");
					String devStatus = "";
					String devMessage = "";
					Statement stateResp=con.createStatement();
					String sqlResp = "select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME like 'YEW_WIP_SEMI_SU%' "; 
					//out.println("sqlResp="+sqlResp);
					ResultSet rsResp=stateResp.executeQuery(sqlResp); 
					if (rsResp.next())
					{
						respID = rsResp.getString("RESPONSIBILITY_ID");
					} else {
						//respID = "50146"; // 找不到則預設 --> TSC WIP Super User 預設
						respID = "50777"; // 找不到則預設 --> YEW WIP Super User 預設
					}
					rsResp.close();
					stateResp.close();	 

					if (groupId==null || groupId.equals(""))
					{
%>
<script language="javascript">		
alert("請輸入GroupID !!!\n xxx.jsp?GROUPID=xxx");
</script>
<%
					} 
					else 
					{
						//	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID
						/*	 	
						CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MASSLOAD_REQUEST(?,?,?,?)}");			 
						cs3.setString(1,groupId);  //*  Group ID 	
						cs3.setString(2,userMfgUserID);    //  user_id 修改人ID /	
						cs3.setString(3,respID);  //*  使用的Responsibility ID --> TSC_INV_Semi_SU /				 
						cs3.registerOutParameter(4, Types.INTEGER); 
						cs3.execute();
						// out.println("Procedure : Execute Success !!! ");
						int requestID = cs3.getInt(4);
						cs3.close();

						java.lang.Thread.sleep(5000);	 // 延遲五秒,等待Concurrent執行完畢,取結果判斷	
						*/

						CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MASSLOAD_REQUEST(?,?,?,?,?,?)}");			 
						cs3.setString(1,groupId);  //*  Group ID 	
						cs3.setString(2,userMfgUserID);    //  user_id 修改人ID /	
						cs3.setString(3,respID);  //*  使用的Responsibility ID --> TSC_INV_Semi_SU /				 
						cs3.registerOutParameter(4, Types.INTEGER);
						cs3.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
						cs3.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
						cs3.execute();
						// out.println("Procedure : Execute Success !!! ");
						int requestID = cs3.getInt(4);
						devStatus = cs3.getString(5);   //  回傳 REQUEST 執行狀況
						devMessage = cs3.getString(6);   //  回傳 REQUEST 執行狀況訊息
						cs3.close(); 

						String sqlf1 = " select INTERFACE_ID from WIP_JOB_SCHEDULE_INTERFACE where group_id= "+groupId;
						//out.print("sqlf1="+sqlf1);
						Statement statef1=con.createStatement();
						ResultSet rsf1=statef1.executeQuery(sqlf1);
						if (rsf1.next())
						{ 
							interfaceId  = rsf1.getString("INTERFACE_ID"); 
							// out.print("<br>"+"interfaceId="+interfaceId);
						}
						rsf1.close();
						statef1.close();

						String errorMsg = "";
						 
						Statement stateError=con.createStatement();
						String sqlError= " select ERROR from WIP_INTERFACE_ERRORS where INTERFACE_ID= "+interfaceId+" " ;	
						//out.println("Step3"+"<BR>");					            
						out.println("<TABLE width='70%'>");                         
						ResultSet rsError=stateError.executeQuery(sqlError);				 
						while (rsError.next()) // 存在 ERROR 的資料
						{ 
							errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>WIP_INTERFACE Transaction fail!! </FONT></TD><TD colspan=1>"+requestID+"</TD></TR>");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>Error Message</FONT></TD><TD colspan=1>"+errorMsg+"</TD></TR>");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
							woPassFlag="N";	
							out.println("<BR>rsError="+woPassFlag);	   
							// 如果錯誤的訊息被釋出,需再與Oracle確認是否真的工單未產生,如仍產生,則將產生的PassFlag設成 Y ,讓流程卡仍可展開
							//   String sqlOp = " select WIP_ENTITY_ID from WIP.WIP_ENTITIES where WIP_ENTITY_NAME='"+woNo+"' " ;
							//out.print("sqlOp 補不足資料欄位="+sqlOp);
							//    Statement stateOp=con.createStatement();
							//    ResultSet rsOp=stateOp.executeQuery(sqlOp);
							//     if (rsOp.next())
							//      {
							// 	  	 woPassFlag="N"; //2007/04/05 liling update 
							//		 out.println("<BR><font color='#993366'>工令修改完成,但含異常訊息!!!</font><BR>");
							//       }
							//       rsOp.close();
							//       stateOp.close(); 

						}
						rsError.close();
						stateError.close();
						out.println("</TABLE>");
						if (errorMsg.equals(""))
						{	
							out.println("<BR><font color='#993366'>Success Submit WIP_MASSLOAD_REQUEST!!!</font><font color='#3333FF'>RequestID = "+requestID+"</font><BR>");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
							woPassFlag="Y";	// 成功寫入的旗標
							con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
						}

					}//end of else
				}//wopassflag		   
			}// end of try
			catch (Exception e)
			{
				out.println("Exception TSC_WIP_MASSLOAD_REQUEST:"+e.getMessage());
			}
			//out.println("<BR>1.rsError="+woPassFlag+" interfaceFlag"+interfaceFlag);	
			//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  , end =================   	
			//=================  update runcard status  , begin ================= 		 
			if (( woPassFlag =="Y" || woPassFlag.equals("Y")) && (interfaceFlag=="Y" || interfaceFlag.equals("Y")) )

			{ //out.print("statusType="+statusType);
				String woSqla="update APPS.YEW_WORKORDER_ALL set WO_QTY=?, LAST_UPDATE_DATE=?, LAST_UPDATED_BY=? ";
				if( statusType==4 )
				{ woSqla=woSqla+"  , WO_STATUS=?, STATUSID=?,  STATUS=? " ;}
				else{woSqla=woSqla+" ";} 
				String woSqlbb ="  where WO_NO= '"+woNo+"' "; 	
				woSqla=woSqla+woSqlbb;

				PreparedStatement woStmta=con.prepareStatement(woSqla);
				//out.print("woSqla="+woSqla); 
				woStmta.setFloat(1,newWoQty);   //修改後工令數量
				woStmta.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
				woStmta.setInt(3,Integer.parseInt(userMfgUserID));
				if ( statusType==4 )
				{ 
					woStmta.setString(4,"D");
					woStmta.setString(5,"050");
					woStmta.setString(6,"CANCELED");


					String woSqlb=" delete YEW_MFG_TRAVELS_ALL  where EXTEND_NO = '"+woNo+"' ";
					PreparedStatement woStmtb=con.prepareStatement(woSqlb);
					//out.print("woSqla="+woSqla); 
					// woStmtc.setFloat(1,newWoQty);   //修改後工令數量
					woStmtb.executeUpdate();   
					woStmtb.close(); 		

				}
				woStmta.executeUpdate();   
				woStmta.close(); 
				if(jobType=="1" || jobType.equals("1"))
				{
					String woSqlc=" update YEW_MFG_TRAVELS_ALL  set EXTENDED_QTY = ? "+
					"    where EXTEND_NO = '"+woNo+"' "; 	
					PreparedStatement woStmtc=con.prepareStatement(woSqlc);
					//out.print("woSqla="+woSqla); 
					woStmtc.setFloat(1,newWoQty);   //修改後工令數量
					woStmtc.executeUpdate();   
					woStmtc.close(); 		
				}     
				for (int i=0;i<aMFGRCDeleteCode.length-1;i++)     
				{
					for (int y=0;y<=choice.length-1;y++)    
					{ //out.println("choice[k]="+choice[k]);  
						if (choice[y]==aMFGRCDeleteCode[i][0] || choice[y].equals(aMFGRCDeleteCode[i][0]))
						{

							String woSqlb="update APPS.YEW_WO_TRANSACTIONS set WO_NO=?,ORGANIAL_QTY=?,ORGANIAL_REASON=?,CREATION_DATE=?,CREATION_BY=?,UPDATED_QTY=?,UPDATED_REASON=? "+
							" where WO_NO= '"+aMFGRCDeleteCode[i][1]+"' "; 	
							PreparedStatement woStmtb=con.prepareStatement(woSqlb);
							//out.print("woSqlb="+woSqlb); 
							woStmtb.setString(1,aMFGRCDeleteCode[i][1]);   //wono
							woStmtb.setFloat(2,Float.parseFloat(woQty));   //ORGANIAL_QTY 
							woStmtb.setString(3,"RUNCARD CANCELED");   //修改後工令數量
							woStmtb.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
							woStmtb.setInt(5,Integer.parseInt(userMfgUserID));
							woStmtb.setFloat(6,newWoQty);   // newWoQty		   
							woStmtb.setString(7,aMFGRCDeleteCode[i][2]);   //RUNCARD
							woStmtb.executeUpdate();   
							woStmtb.close(); 

							String woSql="update APPS.YEW_RUNCARD_ALL set RUNCARD_STATUS=?,DISABLE_DATE=?,STATUSID=?,STATUS=?,LAST_UPDATE_DATE=?,LAST_UPDATED_BY=? "+
							" where RUNCARD_NO= '"+aMFGRCDeleteCode[i][2]+"' "; 	
							PreparedStatement woStmt=con.prepareStatement(woSql);
							//out.print("woSql="+woSql); 
							woStmt.setString(1,"D");   //D:Disable
							woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
							woStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
							woStmt.setString(4,getStatusRs.getString("STATUSNAME"));
							woStmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
							woStmt.setInt(6,Integer.parseInt(userMfgUserID));
							woStmt.executeUpdate();   
							woStmt.close(); 

							// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_起
							String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
												"            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
												"            TRANSACTION_DATE,TRANSACTION_QUANTITY, RCSTATUSID, RCSTATUS, LASTUPDATE_BY,LASTUPDATE_DATE, ACTIONID, ACTIONNAME )  "+
												"     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') "; 
							//out.print("SqlQueueTrans="+SqlQueueTrans);			    						
							PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
							queueTransStmt.setInt(1,Integer.parseInt(aMFGRCDeleteCode[i][0]));   // RUNCAD_ID   
							queueTransStmt.setString(2,aMFGRCDeleteCode[i][2]);                // RUNCARD_NO
							queueTransStmt.setInt(3,Integer.parseInt(aMFGRCDeleteCode[i][4]));   // ORGANIZATION_ID
							queueTransStmt.setInt(4,Integer.parseInt(aMFGRCDeleteCode[i][3]));   // WIP_ENTITY_ID
							queueTransStmt.setInt(5,Integer.parseInt(aMFGRCDeleteCode[i][5]));   // PRIMARY_ITEM_ID
							queueTransStmt.setFloat(6,Float.parseFloat(aMFGRCDeleteCode[i][6]));  // Transaction Qty
							queueTransStmt.setString(7,"050");      // From STATUSID
							queueTransStmt.setString(8,"CANCELED");	  // From STATUS
							queueTransStmt.setString(9,userMfgUserName);	  // Update User  
							queueTransStmt.executeUpdate();
							queueTransStmt.close();	

							//out.print("insert into APPS.YEW_RUNCARD_TRANSACTIONS completed!!");
							out.print("<br>  工令:"+woNo+"     流程卡號:"+aMFGRCDeleteCode[i][2]+"    數量:"+aMFGRCDeleteCode[i][6]+"  己刪除!!"); 
						}//end if
					}//end for y  	 
				} //end for
			} //if (( woPassFlag =="Y" || woPassFlag.equals("Y")) && (interfaceFlag=="Y" || interfaceFlag.equals("Y")) )
			// %%%%%%%%%%%%%%%%%%% 寫入Run card Move Transaction %%%%%%%%%%%%%%%%%%%_迄 

		}//arrMFGRCDeleteBean !=null	 	  
	}
	//========未投產流程卡刪除,工令數量減少...迄	(ACTION=021)   流程卡展開042 -->流程卡刪除中050   add by liling 2006/10/31

	errorFlag ="99999";
	out.println("<BR>");
	//out.println("<A HREF='../ORADDSMainMenu.jsp'>");%><font size="2">回首頁</font><%out.println("</A>");

	getStatusStat.close();
	getStatusRs.close();  
	//pstmt.close();       

} //end of try
catch (Exception e)
{
	e.printStackTrace();
	out.println("errorFlag="+errorFlag+"<br>"+e.getMessage());
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
{ out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
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
	out.println(e.getMessage());
}//end of catch  

%>   
</td> 
<td>
<%
try  
{ out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
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
	out.println(e.getMessage());
}//end of catch   

// 若後段工令,其前段工令完工批號(流程卡號)確認後陣列清除
if (woType.equals("3"))
{
	if (aMFGLotMatchCode!=null)
	{
		arrayLotIssueCheckBean.setArray2DString(null); // 把後段工令對應的領料批號亦清空
	}
}

%></td>    
</tr>
</table>
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

