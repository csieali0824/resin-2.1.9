<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.math.BigDecimal,java.text.DecimalFormat" %>
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

<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡移站中 -->

<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSCMfgRCMovingMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
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
   String sTime = request.getParameter("STIME");

   String runCardCount=String.valueOf(runCardCountI);  //流程卡張數
   //out.print("woNo="+woNo+"<br>");
   //out.print("尾批數量="+runCardCountD);
      
   if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
// MFG工令資料_參數迄

// 2005/12/03 取session 的Bean 的選取的生管指派指對應代碼 // By Kerwin


String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR 流程卡移站中-> 流程卡移站中


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

      // 為存入日期格式為US考量,將語系先設為美國
	   String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
	  //完成存檔後回復	  

    //抓取系統日期
    String systemDate ="",txnDate="";
/* //20091123 liling performance issue :移往下段取 
    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE ,  substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME from dual" );
	if (sd.next())
	{
	   systemDate=sd.getString("SYSTEMDATE");
       sTime=sd.getString("STIME");	 
	}
	sd.close();
    statesd.close();	
	*/
	// 取對應的 organization_code 從ORG參數檔
	String organCode ="";
	String organizationID = "";
    Statement stateOrgCode=con.createStatement();
	//out.println("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' ");
	ResultSet rsOrgCode=stateOrgCode.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE ,  substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME,a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
	if (rsOrgCode.next())
	{
	   organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
	   organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
	   systemDate=rsOrgCode.getString("SYSTEMDATE");
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

//MFG流程卡移站中_起	(ACTION=006)   流程卡移站中044 --> 流程卡移站中044
if (actionID.equals("006") && fromStatusID.equals("044"))   // 如為n站, 第2站 --> 第 n-1 站
{   //out.println("fromStatusID="+fromStatusID);
    String fndUserName = "";  //處理人員
	String woUOM = ""; // 工令移站單位
	int primaryItemID = 0;
    float runCardQtyf=0,overQty=0,overSRQty=0; 
	entityId = "0"; // 工令wip_entity_id
	boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
    if (aMFGRCMovingCode!=null)
	{	  
	  if (aMFGRCMovingCode.length>0)
	  {    
	      //抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
	                     
						 String sqlfnd = " select USER_NAME from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 									     " where A.USER_NAME = UPPER(B.USERNAME)  and USER_ID = '"+userMfgUserID+ "'";
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
		                
						 String sqlMQty = " select b.QTY_IN_QUEUE,RES_EMPLOYEE_OP, TRANSACTION_QUANTITY as PREVCOMPQTY "+
						                 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
                                         //20091123 liling add organization_id
 									    // "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
									     "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and c.organization_id = a.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
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
                           txnDate = rsMQty.getString("RES_EMPLOYEE_OP");		//移站日期	
                            
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
		   
               if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null"))  //20090605 liling 增加若沒key就預設systemdate
               txnDate=systemDate;
		     // if (UserRoles.indexOf("admin")>=0) // 管理員 
		     // {
			    rcScrapQty = Float.parseFloat(aMFGRCMovingCode[i][11]);  // 2007/03/30 測試以手動輸入的報廢數 By Kerwin
			 // }
		   
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
		 String overSRFlag="";
		 // 2007/04/17 報廢時超額數量判段_By Kerwin_起
		             // 判斷是否已超過該站可移站數,若是,則亦表示OverComp_起--表示工令可用移站數
				      float remainSRQueueQty=0;
		         	  Statement stateSRM=con.createStatement();
                      ResultSet rsSRM=stateSRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" and OPERATION_SEQ_NUM = "+aMFGRCMovingCode[i][4]+" ");  //20091123 Liling add oranization_id
			          if (rsSRM.next()) { remainSRQueueQty = rsSRM.getFloat("QUANTITY_IN_QUEUE"); }
			          rsSRM.close();
	   		          stateSRM.close();
			         // 判斷是否已超過該站可移站數,若是,則亦表示OverComp_迄--表示工令可用移站數
			          if (Float.parseFloat(aMFGRCMovingCode[i][11]) > remainSRQueueQty)//若報廢數大於可移數,表示報廢overcompletion
		              {
					     overSRQty = Float.parseFloat(aMFGRCMovingCode[i][11])-remainSRQueueQty; 
						 // 取到小數後3位,四捨五入
						 String strOverSRQty = nf.format(overSRQty);
				         java.math.BigDecimal bd = new java.math.BigDecimal(strOverSRQty);
				         java.math.BigDecimal overCompSRQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				         overSRQty = overCompSRQty.floatValue();
						 //out.println("remainQueueQty="+remainQueueQty);
						 //out.println("aMFGRCExpTransCode[i][2]="+aMFGRCExpTransCode[i][2]);
						 overSRFlag = "Y";   //給定超收的flag
						 if (overSRQty==0) // By Kerwin 2007/04/17
				         {
				           overSRFlag = "N";   //若計算四捨五入後三位後仍為0,則給定超收的flag = N
				         }
					  
					  } // End of if (Float.parseFloat(aMFGRCExpTransCode[i][11]) > remainQueueQty)
		 // 2007/04/17 報廢時超額數量判段_By Kerwin_迄
		 	 
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
						   "            GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ";
		   String SqlSc2 = "           ,OVERCOMPLETION_TRANSACTION_QTY ";			   
		   String SqlSc3 = "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?,WIP_TRANSACTIONS_S.NEXTVAL ";  
		   String SqlSc4 = " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
		   String SqlSc5 = " ) ";    
						// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
		   if (overSRFlag == "Y" || overSRFlag.equals("Y"))
           { SqlScrap=SqlScrap+SqlSc2+SqlSc5+SqlSc3+SqlSc4+SqlSc5; }
           else
           { SqlScrap=SqlScrap+SqlSc5+SqlSc3+SqlSc5; }
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
		   if (overSRFlag == "Y" || overSRFlag.equals("Y"))
           { scrapstmt.setFloat(19,overSRQty); }  // 報廢的OVERCOMPLETION_TRANSACTION_QTY
           scrapstmt.executeUpdate();
           scrapstmt.close();	      	
		   
		   //抓取寫入Interface的Group等資訊_起
	       int groupID = 0;
		   int opSeqNo = 0;              
						 String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" "+  //20091123 Liling add organization_id
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
						  
					  
			}	  
			catch (Exception e) { out.println("Exception3:"+e.getMessage()); }  
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
            
			//add by Peggy 20140324
			//prevQty	=prevQty -Float.parseFloat("0"+rcScrapQty);
			//解決浮點數計算問題,add by Peggy 20140417
			prevQty	=(prevQty*1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
			prevQty	=prevQty/1000;			
			if (prevQty<0) prevQty=0;
			//out.println("prevQty="+prevQty);
						
            //判斷是否有overcompletion
			if (Float.parseFloat(aMFGRCMovingCode[i][2]) > prevQty )   //若移站數大於流程卡數,表示overcompletion
            {   //out.print("<br>前站移站數="+prevQty);
                //overQty = Float.parseFloat(aMFGRCMovingCode[i][2]) - prevQty ;    //移站數-流程卡數=超出數量
				//解決浮點數計算問題,add by Peggy 20140417
				overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000) - (prevQty*1000) ;    //移站數-流程卡數=超出數量
				overQty =overQty/1000;
				String strOverQty = nf.format(overQty);
				java.math.BigDecimal bd = new java.math.BigDecimal(strOverQty);
				java.math.BigDecimal overCompQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				overQty = overCompQty.floatValue();		
				//out.println("1.overQty="+overQty);				
                overFlag = "Y";   //給定超收的flag
				if (overQty==0) // By Kerwin 2007/04/17
				{
				   overFlag = "N";   //若計算四捨五入後三位後仍為0,則給定超收的flag = N
				}
            } else  { 
			
			          // 再判斷是否已超過該站可移站數,若是,則亦表示OverComp_起
					  float remainQueueQty=0;
					  Statement stateRM=con.createStatement();
                      ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" and OPERATION_SEQ_NUM = "+aMFGRCMovingCode[i][4]+" ");  //20091123 Liling add organization_id
			          if (rsRM.next()) { remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); }
			          rsRM.close();
	   		          stateRM.close();					  
					  // 再判斷是否已超過該站可移站數,若是,則亦表示OverComp_迄
					  
					  if (Float.parseFloat(aMFGRCMovingCode[i][2]) > remainQueueQty)
					  {
					    //overQty = Float.parseFloat(aMFGRCMovingCode[i][2])-remainQueueQty; 
						//解決浮點數計算問題,add by Peggy 20140417
						overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000)-(remainQueueQty*1000); 
						overQty = overQty/1000;
						 // 取到小數後3位,四捨五入
						String strOverQty = nf.format(overQty);
				        java.math.BigDecimal bd = new java.math.BigDecimal(strOverQty);
				        java.math.BigDecimal overCompQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				        overQty = overCompQty.floatValue();	
						//out.println("2.overQty="+overQty);	
						overFlag = "Y";   //給定超收的flag
						if (overQty==0) // By Kerwin 2007/04/17
				        {
				         overFlag = "N";   //若計算四捨五入後三位後仍為0,則給定超收的flag = N
				        }
						
					  } else {
					           overFlag = "N";
					         }				 
				    }
            //out.print("<br>overQty="+overQty);    
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
 									     " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" "+  //20091123 Liling add organization_id
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
			catch (Exception e) { out.println("Exception4:"+e.getMessage()); }  
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
						  "  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id= "+organizationID+"  ";  //20091123 Liling add organization_id 
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
                     ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"'  and WIP_ENTITY_ID ="+entityId+" and organization_id= "+organizationID+" ");
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
                           //20091123 liling add wip_enity_id /organization_id
                           "    and wip_entity_id = "+entityId+" and organization_id= "+organizationID+" "+
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
						   "            LASTUPDATE_DATE , OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME, QTY_AC_SCRAP, QTY_AC_TOMOVE ) "+  // 2007/04/03 增加寫入報廢數及良品數
				           "     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"', '"+aMFGRCMovingCode[i][11]+"', '"+aMFGRCMovingCode[i][2]+"') ";  						
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
						   "            LASTUPDATE_DATE, ACTIONID, ACTIONNAME , QTY_AC_SCRAP, QTY_AC_TOMOVE ) "+  // 2007/04/03 增加寫入報廢數及良品數
				           "     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"', '"+aMFGRCMovingCode[i][11]+"', '"+aMFGRCMovingCode[i][2]+"') ";  						
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
						" QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+   //20090428 liling add RES_EMPLOYEE_OP清為空白,移站時才會抓系統日"+
                        " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCMovingCode[i][0]+"' "; 
            //out.print("rcSql="+rcSql);	
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
		   rcStmt.setFloat(13,Float.parseFloat(aMFGRCMovingCode[i][2])+rcScrapQty);  // 處理數
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


  out.println("<BR>");
  //out.println("<A HREF='../ORADDSMainMenu.jsp'>");%><font size="2">回首頁</font><%out.println("</A>");
   
  getStatusStat.close();
  getStatusRs.close();  
  //pstmt.close();       
  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
   out.println("Exception5:"+e.getMessage());
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
      out.println("Exception1:"+e.getMessage());
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
      out.println("Exception2:"+e.getMessage());
  }//end of catch   
   
  
   
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

