<!--20130301 Liling 修改特殊客戶批號編碼原則為 TS部門別+年月日+3碼流水碼  -->
<!--20140102 Liling 修改工單Date Release 的時間為 當日00:00:09  -->
<!--20151026 liling add wotype=5 in custlotno  -->
<!--20171115 liling add ON SEMI custlotno  -->
<!--20200506 liling add order line id 寫入工單attribute  -->
<!--20200506 liling add order line id 寫入工單attribute1 -->
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
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡已展開-> 流程卡移站中 -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSCMfgWoMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String hostInfo=request.getRequestURL().toString();//REQUEST URL
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String inspLotNo=request.getParameter("INSPLOTNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");
String customerName=request.getParameter("CUSTOMERNAME");	//20171115 liling

// MFG工令資料_參數起   
   String woNo=request.getParameter("WO_NO");   //工單號
   String runCardCountI=request.getParameter("RUNCARDCOUNTI");   //欲展之流程卡張數
   String runCardQty=request.getParameter("RUNCARDQTY");        //單張流程卡數量
   String runCardCountD=request.getParameter("RUNCARDCOUNTD");  //尾張流程卡數量
   String dividedFlag=request.getParameter("DIVIDEDFLAG");      //是否被整除 整除='Y' ,未被整除之流程卡要多加一張
   String singleControl=request.getParameter("SINGLECONTROL");   //是否為單批控管
   String runCardPrffix=request.getParameter("RUNCARDPREFIX");   //流程卡前置碼
   
   String custLot=request.getParameter("CUSTLOT");  // 客戶批號設定碼 0: 無設定, 1:需產生客戶特殊批號 2007/08/13
   String custLotNoPrefix=request.getParameter("CUSTLOT_PREFIX");  // 客戶批號前置碼 2007/08/13
   
   String runCardNo=request.getParameter("RUNCARD_NO");   //流程卡號
   String custLotNo=request.getParameter("CUSTLOT_NO");   //客戶批號 2007/08/13
   
   String classID=request.getParameter("CLASSID");
   String woType=request.getParameter("WOTYPE");
   String alternateRouting=request.getParameter("ALTERNATEROUTING");
    String systemDate ="";
   
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
   String dateCode=request.getParameter("DATECODE");   
   String dc_yyww=request.getParameter("DC_YYWW"); //add by Peggy 20220715
   String operationSeqNum   = "";  
   String operationSeqId    = "";
   String standardOpId  	= "";
   String previousOpSeqNum  = "";
   String nextOpSeqNum	    = "";
   String standardOpDesc    = "";   
   String routingRefID      = "",altBomSeqID="",altBomDest="",altRoutingDest="";
   String oeLineId      = "";
   
   String directOSP = request.getParameter("DIRECTOSP"); // 預設非為投產即外包站
   if (directOSP==null || directOSP.equals("")) directOSP = "N";

   String runCardCount=String.valueOf(runCardCountI);  //流程卡張數
   //out.print("woNo="+woNo+"<br>");
   //out.print("jobType="+jobType);
      
   if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
// MFG工令資料_參數迄

// 2005/12/03 取session 的Bean 的選取的生管指派指對應代碼 // By Kerwin

String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR 流程卡已展開-> 流程卡移站中

// 2004/07/08 取session 的Bean 的選取的檢驗方式對應代碼 // By Kerwin

//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String adminModeOption=request.getParameter("ADMINMODEOPTION");//是否為管理員模式1, 僅生成 Oracle 工令, 不展生產流程卡
String adminModeOption2=request.getParameter("ADMINMODEOPTION2");//是否為管理員模式2 , 僅展流程卡,不再生成Oracle 工令

String oriStatus=null;
String actionName=null;

String dateString="";
String seqkey="";
String seqno="";

// 2007/08/13 增加生成特殊客戶批號變數
String monDayString="";
String custLotSeqkey="";
String custLotSeqno="";
// 2007/08/13 增加生成特殊客戶批號變數

String line_No=request.getParameter("LINE_NO");

String curr=request.getParameter("CURR");

String [] choice=request.getParameterValues("CHKFLAG");

int headerID   = 0;  
int toleranceValue = 0;
String toleranceType="1";   //type=1 perenct  type=2  amount

String errorMessageHeader ="";
String errorMessageLine ="";
String statusMessageHeader ="";
String statusMessageLine ="";
String processStatus="";


String opSupplierLot = ""; // 外購後段工令,將廠商批號寫入流程卡檔

String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);

      // 為存入日期格式為US考量,將語系先設為美國
	   String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
	  //完成存檔後回復	
	  
	int indxHost = hostInfo.indexOf("8080/");    
    hostInfo = hostInfo.substring(0,indxHost+5);
	  
	 //抓取WEB系統資訊
    String webSysID ="1";
    Statement stateWS=con.createStatement();
	ResultSet rsWS=stateWS.executeQuery("select SYSID from ORADDMAN.WS_SYSTEMS where HOST_INFO='"+hostInfo+"' ");
	if (rsWS.next())
	{
	   webSysID=rsWS.getString("SYSID");	 
	   //out.println("webSysID="+webSysID);
	}
	rsWS.close();
    stateWS.close(); 
	//抓取WEB系統資訊 
/* 20091112 liling performance
    //抓取系統日期

    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
	if (sd.next())
	{
	   systemDate=sd.getString("SYSTEMDATE");	 
	}
	sd.close();
    statesd.close();	
	*/
	// 取對應的 organization_code 從ORG參數檔
	String organCode ="";
	String organizationID = "";
    Statement stateOrgCode=con.createStatement();
	//out.println("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' ");
    ResultSet rsOrgCode=stateOrgCode.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE ,a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
	if (rsOrgCode.next())
	{
	   organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
	   organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
       systemDate=rsOrgCode.getString("SYSTEMDATE");
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
  
  monDayString=dateBean.getMonthString()+dateBean.getDayString(); // 特殊客戶批號需求,取月日字串-- Kerwin 2007/08/12
  
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

float accExpandedRCQty = 0;   // 2007/03/26 累計已展流程卡數量,檢核最後累計已展數是否=工令數, 如不相等, 則Rollback RUNCARD Table Insert !!!

//MFG流程卡展開 _起	(ACTION=020)   工令040 --> 流程卡042
if (actionID.equals("020"))  
{ //out.println("Step1");
    String fndUserName = "";  //處理人員
	String woUOM = ""; // 工令移站單位
	
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

//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  , begin =================
   // try // update by kerwin 2007/03/26
   // {  update by kerwin 2007/03/26
     //======取不足欄位

     //out.print("Step1");
	
     String sqla = " select DEPT_NO,JOB_TYPE,WORKORDER_TYPE,INVENTORY_ITEM_ID,INV_ITEM,ITEM_DESC,WO_QTY,SCHEDULE_STRART_DATE STARTDATE,ROUTING_REFERENCE_ID,CUST_LOT,UPPER(NVL(END_CUST_ALNAME,'X')) CUSTOMERNAME,ORDER_LINE_ID, "+
	 			   "        SCHEDULE_END_DATE ENDDATE, CREATE_BY,ORGANIZATION_ID,COMPLETION_SUBINVENTORY, ALTERNATE_ROUTING_DESIGNATOR, ALT_BILL_DEST, SUPPLIER_LOT_NO, WO_UOM "+
				   "   from YEW_WORKORDER_ALL where WO_STATUS = 'O' and WO_NO = '"+woNo+"' ";
	 //out.println("<br>sqla="+sqla);
	 Statement statea=con.createStatement();
     ResultSet rsa=statea.executeQuery(sqla);
	 if (rsa.next())
	 {
		  	deptNo     		 = rsa.getString("DEPT_NO");  
		    jobType    		 = rsa.getString("JOB_TYPE"); 	
			woType    		 = rsa.getString("WORKORDER_TYPE");		
		 	itemId    	 	 = rsa.getString("INVENTORY_ITEM_ID"); 
			invItem   		 = rsa.getString("INV_ITEM"); 
			itemDesc 		 = rsa.getString("ITEM_DESC"); 	
			woQty 			 = rsa.getString("WO_QTY"); 	
			startDate 		 = rsa.getString("STARTDATE"); 	
			endDate 		 = rsa.getString("ENDDATE"); 	
			organizationId   = rsa.getString("ORGANIZATION_ID");  
			defInv			 = rsa.getString("COMPLETION_SUBINVENTORY");
			altBomDest       = rsa.getString("ALT_BILL_DEST");			
			altRoutingDest   = rsa.getString("ALTERNATE_ROUTING_DESIGNATOR");
			routingRefID     = rsa.getString("ROUTING_REFERENCE_ID");	
			opSupplierLot    = rsa.getString("SUPPLIER_LOT_NO");
			woUOM            = rsa.getString("WO_UOM"); 
            custLot          = rsa.getString("CUST_LOT"); 		//20160120 liling	
			customerName     = rsa.getString("CUSTOMERNAME");    //20171115 
			oeLineId         = rsa.getString("ORDER_LINE_ID");    //20200506
			if (startDate==null || startDate.equals("")) startDate=dateBean.getYearMonthDay(); // 若工令啟用日
	 } else {
	 
	         out.println("此工令已取消或刪除!!!,請與工令開立人員確定");
	        }
	 rsa.close();
     statea.close(); 
//out.println("Step2"+startDate);

	  java.sql.Date startdate = null ,enddate=null ;
	  startdate = new java.sql.Date(Integer.parseInt(startDate.substring(0,4))-1900,Integer.parseInt(startDate.substring(4,6))-1,Integer.parseInt(startDate.substring(6,8)));  // 給startDate
	  enddate = new java.sql.Date(Integer.parseInt(endDate.substring(0,4))-1900,Integer.parseInt(endDate.substring(4,6))-1,Integer.parseInt(endDate.substring(6,8)));  // 給endDate


   //抓取OVERCOMPLETION_TOLERANCE_VALUE
     String sqlvalue = "select ALTERNATE_ROUTING as TOLERANCE_VALUE from YEW_MFG_DEFDATA where DEF_TYPE='TOLERANCE_VALUE'  and CODE= '"+woType+"'  ";	 			 
	  //out.print("sqlvalue="+sqlvalue);
	 Statement statevalue=con.createStatement();
     ResultSet rsvalue=statevalue.executeQuery(sqlvalue);
	 if (rsvalue.next())
	 {
		  	toleranceValue   = rsvalue.getInt(1);   //超額完工比率
	 } 
	 rsvalue.close();
     statevalue.close(); 	
	 

     String sqlf = "select WIP_INTERFACE_S.NEXTVAL, WIP_JOB_SCHEDULE_INTERFACE_S.NEXTVAL, WIP_ENTITIES_S.NEXTVAL from dual";	 			 
	 //out.print("sqlf="+sqlf);
	 Statement statef=con.createStatement();
     ResultSet rsf=statef.executeQuery(sqlf);
	 if (rsf.next())
	 {
		  	interfaceId   = rsf.getString(1); 
		 	groupId       = rsf.getString(2); 
			entityId      = rsf.getString(3);
	 }
	 rsf.close();
     statef.close(); 	
	 
 	//out.print("interfaceId="+interfaceId);
	
 if (adminModeOption2!=null && adminModeOption2.equals("YES") && ( UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0 ) )
 { // 管理員模式2,僅展開流程卡,不再生成Oracle工令(因流程卡展開異常:多卡或少卡,但工令已生成)	
    out.println("<font color='#990000'><strong>管理員模式2(僅展開流程卡,不再生成Oracle工令)成功執行!!!</strong></font><BR>");
	woPassFlag = "Y"; // 把已成功生成Oracle 工令的變數設為 Y 
 } 
  else
     { // 正常模式,要丟 Descrete Job 並 呼叫 Mass Load Discrete Procedure 產生Oracle工令
 
	
  try  // add by kerwin 2007/03/26
  {	    // add by kerwin 2007/03/26
	//out.print("groupId="+groupId+"<BR>");
	int loadType = 1; // Default for Standard Job
	int statusType = 3; // Default for Standard Job
	String allowExplosion = "Y";  // Default for Standard Job
	String inSql= "",sqlbill="",sqlRouting="",sqlBandR="";
	PreparedStatement instmt=null;
	if (jobType==null || jobType.equals("1")) 
	{ 
	 // 屬標準工單
	  inSql=" insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
					"        FIRST_UNIT_START_DATE, GROUP_ID, COMPLETION_SUBINVENTORY,CREATED_BY,CREATION_DATE,JOB_NAME,"+					
					"	 	 LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID, "+
					"		 PRIMARY_ITEM_ID,PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION,DUE_DATE, "+
					"		 OVERCOMPLETION_TOLERANCE_TYPE,OVERCOMPLETION_TOLERANCE_VALUE , "+
					"        DATE_RELEASED,ATTRIBUTE1) "+   //20140102 add DATE_RELEASED //20200506 liling add ATTRIBUTE1
					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,trunc(sysdate)+0.0001,?) ";  
	   sqlbill=" insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
					"        FIRST_UNIT_START_DATE, GROUP_ID, COMPLETION_SUBINVENTORY,CREATED_BY,CREATION_DATE,JOB_NAME,"+					
					"	 	 LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID, "+
					"		 PRIMARY_ITEM_ID,PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION,DUE_DATE,  "+
					"		 ALTERNATE_BOM_DESIGNATOR ,OVERCOMPLETION_TOLERANCE_TYPE,OVERCOMPLETION_TOLERANCE_VALUE,  "+
					"        DATE_RELEASED,ATTRIBUTE1) "+   //20140102 add DATE_RELEASED //20200506 liling add ATTRIBUTE1
					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,trunc(sysdate)+0.0001,?) ";   
	   sqlRouting=" insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
					"        FIRST_UNIT_START_DATE, GROUP_ID, COMPLETION_SUBINVENTORY,CREATED_BY,CREATION_DATE,JOB_NAME,"+					
					"	 	 LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID, "+
					"		 PRIMARY_ITEM_ID,PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION,DUE_DATE, "+
					"		 ALTERNATE_ROUTING_DESIGNATOR ,OVERCOMPLETION_TOLERANCE_TYPE,OVERCOMPLETION_TOLERANCE_VALUE, "+
					"        DATE_RELEASED,ATTRIBUTE1) "+   //20140102 add DATE_RELEASED //20200506 liling add ATTRIBUTE1
					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,trunc(sysdate)+0.0001,?) ";   
	   sqlBandR=" insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
					"        FIRST_UNIT_START_DATE, GROUP_ID, COMPLETION_SUBINVENTORY,CREATED_BY,CREATION_DATE,JOB_NAME,"+					
					"	 	 LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID, "+
					"		 PRIMARY_ITEM_ID,PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION,DUE_DATE, "+
					"        ALTERNATE_BOM_DESIGNATOR,ALTERNATE_ROUTING_DESIGNATOR ,OVERCOMPLETION_TOLERANCE_TYPE,OVERCOMPLETION_TOLERANCE_VALUE, "+
					"        DATE_RELEASED,ATTRIBUTE1) "+  //20140102 add DATE_RELEASED //20200506 liling add ATTRIBUTE1
					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,trunc(sysdate)+0.0001,?) ";    

	    if ((altBomDest==null || altBomDest.equals("")) && (altRoutingDest==null || altRoutingDest.equals("")))
	     {
	      //out.print("inSql="+inSql);				
          instmt=con.prepareStatement(inSql);     
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
          instmt.setInt(2,Integer.parseInt(groupId)); 
	      instmt.setString(3,defInv);   							//completion sub  
	      instmt.setInt(4,Integer.parseInt(userMfgUserID));     //create by
	      instmt.setDate(5,processDateTime);    		 //create date
	      instmt.setString(6,woNo);   							 //job name
	      instmt.setDate(7,processDateTime);         //lastupdate date
	      instmt.setInt(8,Integer.parseInt(userMfgUserID));    //lastupdate by
	      instmt.setInt(9,Integer.parseInt(entityId));         //wip_entity_id
	      instmt.setInt(10,Integer.parseInt(entityId));         //heaer_id
	      instmt.setInt(11,loadType);    						//load_type   1=create Standard Job   3=update 4=Create non-Standard job
	      instmt.setFloat(12,Float.parseFloat(woQty));   			 //net_qty
	      instmt.setInt(13,Integer.parseInt(organizationId));    //organization_id
	      instmt.setInt(14,Integer.parseInt(itemId));    //primary item id
	      instmt.setInt(15,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	      instmt.setInt(16,1);    //process_status   1 =Pending  3=error
	      instmt.setFloat(17,Float.parseFloat(woQty));    //start qty
	      instmt.setInt(18,statusType);    //status_type      1=unlease 3=release 6=Hold
	      instmt.setString(19,allowExplosion);    //ALLOW_EXPLOSION      Y=ALLOW_EXPLOSION N=NOT ALLOW_EXPLOSION
	      instmt.setDate(20,enddate);    //Request Due Date  
		  instmt.setString(21,toleranceType);   							 //
		  instmt.setInt(22,toleranceValue);
		  instmt.setString(23,oeLineId);  //20200506
          instmt.executeUpdate();
          instmt.close(); 
		 }//end if 無alternate bill & routing  	
	   if ((altBomDest!=null && !altBomDest.equals("")) && (altRoutingDest==null || altRoutingDest.equals("")))
	     { //out.print("***type2***");
	      //out.print("inSql="+inSql);				
          instmt=con.prepareStatement(sqlbill);     
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
          instmt.setInt(2,Integer.parseInt(groupId)); 
	      instmt.setString(3,defInv);   							//completion sub  
	      instmt.setInt(4,Integer.parseInt(userMfgUserID));     //create by
	      instmt.setDate(5,processDateTime);    		 //create date
	      instmt.setString(6,woNo);   							 //job name
	      instmt.setDate(7,processDateTime);         //lastupdate date
	      instmt.setInt(8,Integer.parseInt(userMfgUserID));    //lastupdate by
	      instmt.setInt(9,Integer.parseInt(entityId));         //wip_entity_id
	      instmt.setInt(10,Integer.parseInt(entityId));         //heaer_id
	      instmt.setInt(11,loadType);    						//load_type   1=create Standard Job   3=update 4=Create non-Standard job
	      instmt.setFloat(12,Float.parseFloat(woQty));   			 //net_qty
	      instmt.setInt(13,Integer.parseInt(organizationId));    //organization_id
	      instmt.setInt(14,Integer.parseInt(itemId));    //primary item id
	      instmt.setInt(15,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	      instmt.setInt(16,1);    //process_status   1 =Pending  3=error
	      instmt.setFloat(17,Float.parseFloat(woQty));    //start qty
	      instmt.setInt(18,statusType);    //status_type      1=unlease 3=release 6=Hold
	      instmt.setString(19,allowExplosion);    //ALLOW_EXPLOSION      Y=ALLOW_EXPLOSION N=NOT ALLOW_EXPLOSION
	      instmt.setDate(20,enddate);    //Request Due Date  	  
	      instmt.setString(21,altBomDest);    // 	
		  instmt.setString(22,toleranceType);   							 //
		  instmt.setInt(23,toleranceValue);		
		  instmt.setString(24,oeLineId);  //20200506     
          instmt.executeUpdate();
          instmt.close(); 
		 }//end if alternate bill	   
	   if ((altBomDest==null || altBomDest.equals("")) && (altRoutingDest!=null && !altRoutingDest.equals("")))
	     { 
	      //out.print("inSql="+inSql);				
          instmt=con.prepareStatement(sqlRouting);     
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
          instmt.setInt(2,Integer.parseInt(groupId)); 
	      instmt.setString(3,defInv);   							//completion sub  
	      instmt.setInt(4,Integer.parseInt(userMfgUserID));     //create by
	      instmt.setDate(5,processDateTime);    		 //create date
	      instmt.setString(6,woNo);   							 //job name
	      instmt.setDate(7,processDateTime);         //lastupdate date
	      instmt.setInt(8,Integer.parseInt(userMfgUserID));    //lastupdate by
	      instmt.setInt(9,Integer.parseInt(entityId));         //wip_entity_id
	      instmt.setInt(10,Integer.parseInt(entityId));         //heaer_id
	      instmt.setInt(11,loadType);    						//load_type   1=create Standard Job   3=update 4=Create non-Standard job
	      instmt.setFloat(12,Float.parseFloat(woQty));   			 //net_qty
	      instmt.setInt(13,Integer.parseInt(organizationId));    //organization_id
	      instmt.setInt(14,Integer.parseInt(itemId));    //primary item id
	      instmt.setInt(15,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	      instmt.setInt(16,1);    //process_status   1 =Pending  3=error
	      instmt.setFloat(17,Float.parseFloat(woQty));    //start qty
	      instmt.setInt(18,statusType);    //status_type      1=unlease 3=release 6=Hold
	      instmt.setString(19,allowExplosion);    // 
	      instmt.setDate(20,enddate);    //Request Due Date   	  	  
	      instmt.setString(21,altRoutingDest);    // 
		  instmt.setString(22,toleranceType);   							 //
		  instmt.setInt(23,toleranceValue);		
		  instmt.setString(24,oeLineId);  //20200506  		  		  
          instmt.executeUpdate();
          instmt.close(); 
		 }//end if alternate routing  
	  if ((altBomDest!=null && !altBomDest.equals("")) && (altRoutingDest!=null && !altRoutingDest.equals("")))
	     { 
	      //out.print("inSql="+inSql);				
          instmt=con.prepareStatement(sqlBandR);     
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
          instmt.setInt(2,Integer.parseInt(groupId)); 
	      instmt.setString(3,defInv);   							//completion sub  
	      instmt.setInt(4,Integer.parseInt(userMfgUserID));     //create by
	      instmt.setDate(5,processDateTime);    		 //create date
	      instmt.setString(6,woNo);   							 //job name
	      instmt.setDate(7,processDateTime);         //lastupdate date
	      instmt.setInt(8,Integer.parseInt(userMfgUserID));    //lastupdate by
	      instmt.setInt(9,Integer.parseInt(entityId));         //wip_entity_id
	      instmt.setInt(10,Integer.parseInt(entityId));         //heaer_id
	      instmt.setInt(11,loadType);    						//load_type   1=create Standard Job   3=update 4=Create non-Standard job
	      instmt.setFloat(12,Float.parseFloat(woQty));   			 //net_qty
	      instmt.setInt(13,Integer.parseInt(organizationId));    //organization_id
	      instmt.setInt(14,Integer.parseInt(itemId));    //primary item id
	      instmt.setInt(15,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	      instmt.setInt(16,1);    //process_status   1 =Pending  3=error
	      instmt.setFloat(17,Float.parseFloat(woQty));    //start qty
	      instmt.setInt(18,statusType);    //status_type      1=unlease 3=release 6=Hold
	      instmt.setString(19,allowExplosion);    //ALLOW_EXPLOSION      Y=ALLOW_EXPLOSION N=NOT ALLOW_EXPLOSION
	      instmt.setDate(20,enddate);    //Request Due Date  		  
	      instmt.setString(21,altBomDest);    // 	
	      instmt.setString(22,altRoutingDest);    // 
		  instmt.setString(23,toleranceType);   							 //
		  instmt.setInt(24,toleranceValue);		
		  instmt.setString(25,oeLineId);  //20200506  
          instmt.executeUpdate();
          instmt.close(); 
		 }//end if have alternate bill & routing 
  	   
	} 
	else { 
	       loadType = 4;    // Non-Statdard Job
	       statusType = 1; // UnRelease 
		   allowExplosion = "N"; // not Allow Explosion
		   inSql="insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
					"       FIRST_UNIT_START_DATE, GROUP_ID, "+					
					"      "+
					"		CREATED_BY,CREATION_DATE,JOB_NAME,LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID, "+
					"		LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID,PRIMARY_ITEM_ID,  "+
					"		PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,CLASS_CODE,LAST_UNIT_COMPLETION_DATE, "+
					"       COMPLETION_SUBINVENTORY,DUE_DATE,OVERCOMPLETION_TOLERANCE_TYPE ,OVERCOMPLETION_TOLERANCE_VALUE) "+
					"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "; 
	       //out.print("inSql="+inSql);				
           instmt=con.prepareStatement(inSql);     
           // instmt.setInt(1,Integer.parseInt(interfaceId));
	       //    out.print("interfaceId="+interfaceId+"<br>");	
	       instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
           instmt.setInt(2,Integer.parseInt(groupId)); 

	       //out.print("groupId="+groupId+"<br>");	    
	       //instmt.setString(3,"Y"); 								 //ALLOW_EXPLOSION
          // instmt.setInt(3,Integer.parseInt(itemId));              //BOM_REFERENCE_ID
	      // instmt.setString(3,defInv);   							//completion sub  
	       instmt.setInt(3,Integer.parseInt(userMfgUserID));     //create by
	       instmt.setDate(4,processDateTime);    		 //create date
	       instmt.setString(5,woNo);   							 //job name
	       instmt.setDate(6,processDateTime);         //lastupdate date
	       instmt.setInt(7,Integer.parseInt(userMfgUserID));    //lastupdate by
	       instmt.setInt(8,Integer.parseInt(entityId));         //wip_entity_id
	       instmt.setInt(9,Integer.parseInt(entityId));         //heaer_id
	       instmt.setInt(10,loadType);    						//load_type   1=create Standard Job 3=update 4=Create non-Standard job
	       instmt.setFloat(11,Float.parseFloat(woQty));   			 //net_qty
	       instmt.setInt(12,Integer.parseInt(organizationId));    //organization_id
	       instmt.setInt(13,Integer.parseInt(itemId));    //primary item id
	       instmt.setInt(14,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	       instmt.setInt(15,1);    //process_status   1 =Pending  3=error
	       instmt.setFloat(16,Float.parseFloat(woQty));    //start qty
	       instmt.setInt(17,statusType);    //status_type      1=unlease 3=release 6=Hold
	      // instmt.setString(18,"N");    //ALLOW_EXPLOSION      Y=ALLOW_EXPLOSION N=NOT ALLOW_EXPLOSION
	       instmt.setString(18,"Rework");	// for non-Standard job 重工工單
	       instmt.setDate(19,enddate);    		 //LAST_UNIT_COMPLETION_DATE	   
		   instmt.setString(20,defInv);    //completion sub 
	       instmt.setDate(21,enddate);    		 //request due date	
		   instmt.setString(22,toleranceType);   							 //
		   instmt.setInt(23,toleranceValue);	   
           instmt.executeUpdate();
           instmt.close();  	   
		   
	     } // 屬重工工單      	
		
		//java.lang.Thread.sleep(10000);
  }// end of try	  		  
  catch (Exception e)
  {
     out.println("Exception WIP_JOB_SCHEDULE_INTERFACE:"+e.getMessage());
  }	
    
   //執行 WIP_MASS_LOAD
   try
   {  
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
	 } else {
                 //	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
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
				 
				con.commit(); // 馬上 Commit 一次		
				 
 		 	    String sqlf1 = " select INTERFACE_ID from WIP_JOB_SCHEDULE_INTERFACE where GROUP_ID= "+groupId;
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
			     String sqlError= " select ERROR from WIP_INTERFACE_ERRORS where INTERFACE_ID= "+interfaceId+" and CREATED_BY="+userMfgUserID+" " ;						            
                 out.println("<TABLE width='70%'>");                         
                 ResultSet rsError=stateError.executeQuery(sqlError);				 
				 while (rsError.next()) // 存在 ERROR 的資料
				 { 	      
					   
					   // 如果錯誤的訊息被釋出,需再與Oracle確認是否真的工單未產生,如仍產生,則將產生的PassFlag設成 Y ,讓流程卡仍可展開
					   String sqlOp = " select WIP_ENTITY_ID from WIP_ENTITIES where WIP_ENTITY_NAME='"+woNo+"' " ;
	                   //out.print("sqlOp 補不足資料欄位="+sqlOp);
	                   Statement stateOp=con.createStatement();
                       ResultSet rsOp=stateOp.executeQuery(sqlOp);
	                   if (rsOp.next())
	                   {
	             	  	 woPassFlag="Y"; //
						 out.println("<BR><font color='#993366'>工令成功生成!!!</font><BR><font color='RED'>REQUEST ID="+requestID+"</font>");
	                   } else {  
					             // 真的也沒生成才 Show 錯誤訊息_起
					              errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR");
					              out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'> MASS LOAD Transaction fail!! </FONT></TD><TD colspan=1>"+requestID+"</TD></TR>");
				  	              out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>Error Message</FONT></TD><TD colspan=1>"+errorMsg+"</TD></TR>");
								  out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					              woPassFlag="N";
								 // 真的也沒生成才 Show 錯誤訊息_迄	
					          }
	                   rsOp.close();
                       stateOp.close(); 					   
				  
				 } // End of while 
				 rsError.close();
				 stateError.close();
				 out.println("</TABLE>");
				 if (errorMsg.equals(""))
				 {	
				   out.println("<BR><strong><font color='#993366'>Success Submit WIP_MASSLOAD_REQUEST(工令成功生成!)!!!</font></strong><BR><font color='#3333FF'>RequestID = "+requestID+"</font><BR>");
				   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   woPassFlag="Y";	// 成功寫入的旗標
				   con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
				 }
                 			 
             } //end of else groupId = null 
	}// end of try
    catch (Exception e)
    {
       out.println("Exception TSC_WIP_MASSLOAD_REQUEST:"+e.getMessage());
    }
 } // End of else if (adminModeOption2!=null && adminModeOption2.equals("YES") && UserRoles.indexOf("admin")>=0) 管理員模式2
  

if (adminModeOption!=null && adminModeOption.equals("YES") && ( UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) )
{ // 管理員模式,僅生成Oracle工令,不重展流程卡(因流程卡已展開並投產打印標籤)
     out.println("<BR><font color='#FF0000'>管理員模式,僅生成Oracle工令,不重展流程卡成功!!!</font><BR>");
	 
	 String woSql="update APPS.YEW_WORKORDER_ALL set RELEASE_DATE=?, RELEASED_BY=?, WO_STATUS=?, STATUSID=?, STATUS=?, WIP_ENTITY_ID=? , DATE_CODE=? ,DC_YYWW=? "+
	             "where WO_NO= '"+woNo+"' "; 	
     PreparedStatement wostmt=con.prepareStatement(woSql);
	 //out.print("woSql="+woSql);        
     wostmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
	 wostmt.setInt(2,Integer.parseInt(userMfgUserID));
	 wostmt.setString(3,"R"); 
	 //wostmt.setString(4,"042"); 
	 //wostmt.setString(5,"流程卡生成"); 
	 wostmt.setString(4,getStatusRs.getString("TOSTATUSID")); 
	 wostmt.setString(5,getStatusRs.getString("STATUSNAME"));
	 wostmt.setInt(6,Integer.parseInt(entityId));	
	 wostmt.setString(7,dateCode);
	 wostmt.setString(8,dc_yyww); //add by Peggy 20220715
     wostmt.executeUpdate();   
     wostmt.close(); 
	 
	 con.commit(); // 馬上 Commit 一次	
} 
else 
   {   // 否則,一律生成工令後需展開流程卡 

//out.println("Step1");

       java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.0000"); // 取小數後四位, 作為計算餘數的基準
	   java.math.BigDecimal bd = null;  
       java.math.BigDecimal strAccRunCardQty = null;

//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  ,end =================  
//=========開始執行流程卡insert into作業 ======================================== 
if (woPassFlag=="Y" || woPassFlag.equals("Y"))   //Job Schedule Interface要先insert成功才丟流程卡
{   //out.print("woPassFlag=Y"+"step3"); 
  try
  { //out.print("step4"); out.println("singleControl="+singleControl);
    //out.println("step5="+dividedFlag);
   if (singleControl=="Y" || singleControl.equals("Y")) // 該生產型號屬單批作業管制之工令
   { //out.print("step5");
     //out.print("step1-- "+"dividedFlag="+dividedFlag+"  runCardCountI="+runCardCountI+"<br>");
     if (dividedFlag=="N" || dividedFlag.equals("N"))  // 未展開流程卡
     { //out.print("step7");
	   runCardCountI=Integer.toString(Integer.parseInt(runCardCountI)+1);
       //out.print("step8");   
	 }	

	  String sqlOp = " select a.WIP_ENTITY_ID from WIP_DISCRETE_JOBS a, WIP_ENTITIES b "+
	                 "  where a.WIP_ENTITY_ID=b.WIP_ENTITY_ID and b.WIP_ENTITY_NAME='"+woNo+"' " ;
	 //out.print("sqlOp 補不足資料欄位="+sqlOp);	
	 Statement stateOp=con.createStatement();
     ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 if (rsOp.next())
	 {
		  	entityId   = rsOp.getString(1);  					
	 }
	 rsOp.close();
     stateOp.close(); 
	 
     //out.println("entityId ====== "+entityId+"<BR>");

     String sqlp = " select OPERATION_SEQ_NUM,OPERATION_SEQUENCE_ID,STANDARD_OPERATION_ID,  "+
        			"       DESCRIPTION,PREVIOUS_OPERATION_SEQ_NUM,NEXT_OPERATION_SEQ_NUM   "+
					"  from WIP_OPERATIONS where previous_operation_seq_num is null and WIP_ENTITY_ID ="+entityId;
     //out.print("sqlp="+sqlp+"<BR>");
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
			if (nextOpSeqNum==null || nextOpSeqNum.equals("")) nextOpSeqNum = "0";			
	 } else {
	             operationSeqNum   = "0";
				 operationSeqId    = "0";
				 standardOpId  	  = "0";
				 standardOpDesc   = "0"; 
	             previousOpSeqNum  = "0"; 
				 nextOpSeqNum	  = "0"; 
	        }
	 rsp.close();
     statep.close(); 	 
	 
	 // 2006/12/01   先取工令對應正確的WIP_OPERATIONS 資訊_迄
	 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      int b=Integer.parseInt(runCardCountI);   // 張數
	  // 20091109 Marvie Delete : Performance Issue
      //String t[][]=new String[b+2][4];  //目前只有四項 "","WO_NO","RUNCARD_NO","RUNCADQTY"
      
   int i=0,j=0;   
   for (i=0;i<b;i++)
   {  
      // 20091109 Marvie Delete : Performance Issue
	 //  for (j=0;j<4;j++)
	 //  {  	   
              /*============取RUNCARD_NO,起====================*/
              if (singleControl=="Y" || singleControl.equals("Y"))
              { 
                dateString=dateBean.getYearMonthDay();   
				//seqkey="TS"+userActCenterNo+dateString;  //qcAreaNo
				seqkey=runCardPrffix+"-"+dateString.substring(2,8);  //內外銷別+部門+年月日
                if (classID==null || classID.equals("--")) 
				{
					seqkey=runCardPrffix+"-"+dateString.substring(2,8); // 抓年月日8碼
				}
                else 
				{
					seqkey=runCardPrffix+"-"+dateString.substring(2,8);     // 抓年月日8碼單號   
				}
				if (runCardPrffix.equals("D0") && dateString.substring(2,8).equals("111215"))
				{
					seqkey=runCardPrffix+"-"+"111216";  //內外銷別+部門+年月日
				}				
                //====先取得流水號=====  
                Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+seqkey+"' and TYPE='RC' ");   
                if (rs.next()==false)
                {  
                  String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
                  PreparedStatement seqstmt=con.prepareStatement(seqSql);     
                  seqstmt.setString(1,seqkey);
                  seqstmt.setInt(2,1);   	
				  seqstmt.setString(3,"RC"); 
                  seqstmt.executeUpdate();
                  seqno=seqkey+"-"+"001";
                  seqstmt.close();   
                } 
                else 
                {
                  int lastno=rs.getInt("LASTNO");
                // 20091109 Marvie Update : Performance Issue
                //  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where substr(RUNCARD_NO,1,9)='"+seqkey+"' and to_number(substr(RUNCARD_NO,11,3))= '"+lastno+"' ";
                  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where RUNCARD_NO='"+seqno+"' ";
                  ResultSet rs2=statement.executeQuery(sqla1); 	
                  //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                  if (rs2.next())
                  {   	     
                    lastno++;
                    String numberString = Integer.toString(lastno);
                    String lastSeqNumber="000"+numberString;
                    lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
                    seqno=seqkey+"-"+lastSeqNumber;     
   
                    String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE='RC' ";   
                    PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                    seqstmt.setInt(1,lastno);  
                    seqstmt.executeUpdate();   
                    seqstmt.close(); 
                  } 
                  else
                  {
                      //===========(處理跳號問題)否則以實際RUNCARD檔內最大流水號為目前RUNCARD的lastno內容(會依編碼別)
                       // 20091109 Marvie Update : Performance Issue
                     // String sSqlSeq = "select to_number(substr(max(RUNCARD_NO),11,3)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(RUNCARD_NO,1,9)='"+seqkey+"' ";
                      String sSqlSeq = "select substr(max(RUNCARD_NO),11,3) as LASTNO from APPS.YEW_RUNCARD_ALL where RUNCARD_NO like '"+seqkey+"%' ";
                      ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                  if (rs3.next()==true)
	                  {
                       int lastno_r=rs3.getInt("LASTNO");	  
	                   lastno_r++;	  
	                   String numberString_r = Integer.toString(lastno_r);
                       String lastSeqNumber_r="000"+numberString_r;
                       lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
                       seqno=seqkey+"-"+lastSeqNumber_r;  	 
	                   String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE='RC' ";   
                       PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                       seqstmt.setInt(1,lastno_r);	
                       seqstmt.executeUpdate();   
                       seqstmt.close();  
	                  }  // End of if (rs3.next()==true)   
                  } // End of Else  //===========(處理跳號問題)
              } // End of Else    
	        //docNo = seqno; // 把取到的號碼給本次輸入
	     runCardNo = seqno; // 把取到的號碼給本次輸入
	   
	     // 2007/08/12 針對特殊客戶批號,判斷若為後段工令,且 需生成特殊客戶批號,則取號_起
		//   if (woType.equals("3") && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號	
		   if ( (woType.equals("3") || woType.equals("5") )&& !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號		//20151026 liling add type=5   
		   {
		     //20130301
		     //   custLotSeqkey=custLotNoPrefix+monDayString;  //特殊客戶批號+月日  
 			     custLotSeqkey=custLotNoPrefix+dateString.substring(2,8);  //特殊客戶批號+年月日  
				 
                //====先取得流水號=====  
                //Statement state1=con.createStatement();
                rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+custLotSeqkey+"' and TYPE='CL' ");   
                if (rs.next()==false)
                {  
                  String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
                  PreparedStatement seqstmt=con.prepareStatement(seqSql);     
                  seqstmt.setString(1,custLotSeqkey);
                  seqstmt.setInt(2,1);   	
				  seqstmt.setString(3,"CL"); 
                  seqstmt.executeUpdate();
               //   custLotSeqno=custLotSeqkey+"01";
			      custLotSeqno=custLotSeqkey+"001";  //20130301 CUST LOT 流水碼改3碼 liling
                  seqstmt.close();                
                } 
                else 
                {
                  int lastno=rs.getInt("LASTNO");
                //  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";				  
                  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";
                  ResultSet rs2=statement.executeQuery(sqla1); 	
                  //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                  if (rs2.next())
                  {   	     
                    lastno++;
                    String numberString = Integer.toString(lastno);
				 //20130301 CUST LOT 流水碼改3碼 liling
                 //   String lastSeqNumber="00"+numberString;
                 //    lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
                    String lastSeqNumber="000"+numberString;
                    lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);					    
                    custLotSeqno=custLotSeqkey+lastSeqNumber;
					
					
                    String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                    PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                    seqstmt.setInt(1,lastno);  
                    seqstmt.executeUpdate();   
                    seqstmt.close(); 
					//out.print ("seqSql="+seqSql);
                  } 
                  else
                  {
                      //===========(處理跳號問題)否則以實際RUNCARD檔內最大流水號為目前RUNCARD的lastno內容(會依編碼別)
                     //20130301 
					 // String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),11,2)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' ";
                      String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),10,3)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,9)='"+custLotSeqkey+"' ";
					  ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                  if (rs3.next()==true)
	                  {
                       int lastno_r=rs3.getInt("LASTNO");	  
	                   lastno_r++;	  
	                   String numberString_r = Integer.toString(lastno_r);
				    //20130301 CUST LOT 流水碼改3碼 liling					   
                   //    String lastSeqNumber_r="00"+numberString_r;
                   //    lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
                       String lastSeqNumber_r="000"+numberString_r;
                       lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);					   
                       custLotSeqno = custLotSeqkey + lastSeqNumber_r;  	 
	                   String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                       PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                       seqstmt.setInt(1,lastno_r);	
                       seqstmt.executeUpdate();   
                       seqstmt.close();  
	                  }  // End of if (rs3.next()==true)   
                  } // End of Else  //===========(處理跳號問題)
			  }  // End of //====先取得流水號===== 
			  
			  custLotNo = custLotSeqno; // 把取到的號碼給本次輸入的特殊客戶批號
	    } 	   
	    else // end of if (woType.equals("3") && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號
	       {
		       custLotNo = ""; // 不是屬於後段工令且未指定要產生特殊批號,則特殊客戶批號給空值
		   }	
	   // 2007/08/12 針對特殊客戶批號,判斷若為後段工令,且 需生成特殊客戶批號,則取號_迄
 
	   // 20171115 ON SEMI 特殊客戶批號___START	 
	   if ( (woType.equals("3") || woType.equals("5") ) && ( customerName.equals("ON SEMICONDUCTOR") || customerName.equals("ON SEMI")) )// ON SEMI特殊CUST LOTNO
	   //if ( (woType.equals("3") || woType.equals("5") ) )// ON SEMI特殊CUST LOTNO	   
	   {
		   custLotNo = runCardNo.substring(0,2)+dateString.substring(3,8)+runCardNo.substring(runCardNo.length()-3);	
		}	
	    else  
	   {
		   custLotNo = ""; // 不是屬於後段工令且未指定要產生特殊批號,則特殊客戶批號給空值
       }				    
	   //  20171115 ON SEMI 特殊客戶批號___END   	 
       //out.print("<br>2customerName="+customerName+"*"+"custLotNo="+custLotNo+"*");	   

	   
     } // End of if (singleControl=="Y" || singleControl=="") 	%%%%%%%
//out.println("b="+seqno);

//out.println("runCardNo="+runCardNo);
    //=========取 runcard 單號,迄==========================================     
    if ((dividedFlag=="N" || dividedFlag.equals("N"))  && (i==(b-1)))   //若不整除時,將未張流程卡數量放到最後一張卡上
    { 
     runCardQty=runCardCountD;
	}   
  // 20091109 Marvie Delete : Performance Issue
//  } // End of for (j=0)

   //=====補不足資料欄位,起====================
   //RUNCARD_ID
  // out.print("對應工令號的的Entity_ID="+entityId);	
  try
  { 
     String sqli = " select APPS.YEW_RUNCARD_ALL_S.nextval AS RUNCARD_ID from dual " ;
	 //out.print("sqli 補不足資料欄位="+sqli);
	 Statement statei=con.createStatement();
     ResultSet rsi=statei.executeQuery(sqli);
	 if (rsi.next())
	 {
		  	runCardId   = rsi.getString("RUNCARD_ID");
	 }
	 rsi.close();
     statei.close(); 	
	 
//out.print("WIP entityId="+entityId);	 
	 //String sqlOp = " select MAX(WIP_ENTITY_ID) from WIP.WIP_OPERATION_RESOURCES " ;
	  
   }// end of try
   catch (Exception e)
   {
     out.println("Exception 取工令產生對應的BOM Operation資訊:"+e.getMessage());
   }	 
	 		
   //=====不足資料欄位,迄====================	                 
   // $$$$$$$$$$ 依單批作業管制生產型號展開流程卡號寫入流程卡資料表 $$$$$$$$$$$ //	
   int runCardSeq = 0;	
   
  // java.lang.Math mathAbs = new java.lang.Math();  
 
  try
  {		// out.print("RUNCARD寫入 WIP entityId="+entityId);
   float rCardQtyAck = java.lang.Math.abs(Float.parseFloat(runCardQty)); // 判斷流程卡數是否>0
   
   if (rCardQtyAck>0) // 2007/01/27 避免尾數=0,由判斷流程卡數 > 0 時才寫入流程卡主檔
   {
   	    
        runCardSeq = i+1;
        out.print("<BR>流程卡第"+runCardSeq+"張,卡號="+runCardNo+" QTY="+java.lang.Math.abs(Float.parseFloat(runCardQty)));		
	    String Sqlrc="insert into APPS.YEW_RUNCARD_ALL(RUNCAD_ID,WO_NO,RUNCARD_NO,PRIMARY_ITEM_ID,INV_ITEM,ITEM_DESC, "+
				     "            RUNCARD_STATUS,QTY_IN_QUEUE,CREATE_BY,CREATION_DATE,STATUSID,STATUS,DEPT_NO,ORGANIZATION_ID,WIP_ENTITY_ID, "+
				     "            OPERATION_SEQ_NUM,OPERATION_SEQ_ID,STANDARD_OP_ID,STANDARD_OP_DESC,NEXT_OP_SEQ_NUM, PREVIOUS_OP_SEQ_NUM, RUNCARD_QTY, ROUTING_REFERENCE_ID , LINE_NUM, WEB_SYSID, SUPPLIER_LOT_NO, CUST_LOT_NO,RC_DATE_CODE,DC_YYWW)   "+  //20091123 liling 加 RC_DATE_CODE
				     "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";   
        PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
        seqstmt.setString(1,runCardId);
        seqstmt.setString(2,woNo);
	    seqstmt.setString(3,runCardNo); 
	    seqstmt.setString(4,itemId);
        seqstmt.setString(5,invItem);
	    seqstmt.setString(6,itemDesc); 
	    seqstmt.setString(7,"O");      //runcaard status O=Open
        seqstmt.setFloat(8,java.lang.Math.abs(Float.parseFloat(runCardQty)));
   	    seqstmt.setString(9,userMfgUserID); 
	    seqstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //creation date
        //seqstmt.setString(11,"042");
	    //seqstmt.setString(12,"流程卡生成"); 
	    seqstmt.setString(11,getStatusRs.getString("TOSTATUSID")); 
	    seqstmt.setString(12,getStatusRs.getString("STATUSNAME"));	 
	    seqstmt.setString(13,deptNo);
	    seqstmt.setString(14,organizationId);
	    seqstmt.setInt(15,Integer.parseInt(entityId));	
	    seqstmt.setInt(16,Integer.parseInt(operationSeqNum));
	    seqstmt.setInt(17,Integer.parseInt(operationSeqId));
	    seqstmt.setInt(18,Integer.parseInt(standardOpId));
	    seqstmt.setString(19,standardOpDesc);
	    seqstmt.setInt(20,Integer.parseInt(nextOpSeqNum));
        seqstmt.setInt(21,Integer.parseInt(previousOpSeqNum));
	    seqstmt.setFloat(22,java.lang.Math.abs(Float.parseFloat(runCardQty)));
	    seqstmt.setInt(23,java.lang.Math.abs(Integer.parseInt(routingRefID)));
	    seqstmt.setInt(24,runCardSeq);
	    seqstmt.setInt(25,Integer.parseInt(webSysID));
	    seqstmt.setString(26,opSupplierLot);	
	 	seqstmt.setString(27,custLotNo); // 2007/08/13 依工令指定是否配合產生客戶特殊批號
		seqstmt.setString(28,dateCode);   //20091123 展卡寫入DATE CODE 
		seqstmt.setString(29,dc_yyww);    //20220715 by Peggy
        seqstmt.executeUpdate();
        seqstmt.close();   	
	
        // Error1. YEW_RUNCARD_ALL 沒有Release_date等相關欄位,Liling 弄錯了,更正為 APPS.YEW_WORKORDER_ALL 
        String woSql="update APPS.YEW_WORKORDER_ALL set RELEASE_DATE=?, RELEASED_BY=?, WO_STATUS=?, STATUSID=?, STATUS=?, WIP_ENTITY_ID=? , DATE_CODE=?,DC_YYWW=? "+  
	                 "where WO_NO= '"+woNo+"' "; 	
        PreparedStatement wostmt=con.prepareStatement(woSql);
	    //out.print("woSql="+woSql);        
        wostmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
	    wostmt.setInt(2,Integer.parseInt(userMfgUserID));
	    wostmt.setString(3,"R"); 
	    //wostmt.setString(4,"042"); 
	    //wostmt.setString(5,"流程卡生成"); 
	    wostmt.setString(4,getStatusRs.getString("TOSTATUSID")); 
	    wostmt.setString(5,getStatusRs.getString("STATUSNAME"));
	    wostmt.setInt(6,Integer.parseInt(entityId));	
	    wostmt.setString(7,dateCode);
	    wostmt.setString(8,dc_yyww);  //add by Peggy 20220715
        wostmt.executeUpdate();   
        wostmt.close(); 
		
		 // %%%%%%%%%%%%%%%%%%% 寫入Run card Transaction %%%%%%%%%%%%%%%%%%%_起 	
		   String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           "            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           "            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           "            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				           "            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						   "            LASTUPDATE_DATE, OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME ) "+
				           "     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
           PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
           queueTransStmt.setInt(1,Integer.parseInt(runCardId)); // RUNCAD_ID          
	       queueTransStmt.setString(2,runCardNo);                // RUNCARD_NO
           queueTransStmt.setInt(3,Integer.parseInt(organizationId));           // ORGANIZATION_ID
	       queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       queueTransStmt.setInt(5,Integer.parseInt(itemId));                   // PRIMARY_ITEM_ID
           queueTransStmt.setInt(6,Integer.parseInt(operationSeqNum));          //FM_OPERATION_SEQ_NUM(本站)    
		   queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           queueTransStmt.setInt(8,Integer.parseInt(nextOpSeqNum));             //TO_OPERATION_SEQ_NUM(下一站) 
	       queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	       queueTransStmt.setFloat(10,java.lang.Math.abs(Float.parseFloat(runCardQty)));  // Transaction Qty
	       queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       queueTransStmt.setInt(12,1);             // 1=Queue		  
	       queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       queueTransStmt.setString(15,"040");      // From StatusId (CREATING)
		   queueTransStmt.setString(16,"CREATING");	  // From STATUS
		   queueTransStmt.setString(17,fndUserName);	  // Update User 
		   queueTransStmt.setFloat(18,0);
           queueTransStmt.executeUpdate();
           queueTransStmt.close();	    	 
		 
		 // %%%%%%%%%%%%%%%%%%% 寫入Run card Transaction %%%%%%%%%%%%%%%%%%%_迄 	
		 
		 accExpandedRCQty = accExpandedRCQty + java.lang.Math.abs(Float.parseFloat(runCardQty)); //  累加已展流程卡數... By Kerwin 2007/03/26
		 	
		 // accExpandedRCQty = accExpandedRCQty -1; // test by Kerwin for rollback testing
		   try
		   {			         
				    bd = new java.math.BigDecimal(accExpandedRCQty);
				    strAccRunCardQty = bd.setScale(4, java.math.BigDecimal.ROUND_HALF_UP);
				    accExpandedRCQty = Math.abs(strAccRunCardQty.floatValue());				    
		   } //end of try
           catch (NumberFormatException e)
           {
              System.out.println("Exception: Remainder Round to 4 digit "+e.getMessage());
           }
		//out.println("accExpandedRCQty ="+accExpandedRCQty+"<BR>");
     } // if (rCardQtyAck>0) // 2007/01/27 避免尾數=0,由判斷流程卡數 > 0 時才寫入流程卡主檔
	 
   }// end of try
   catch (Exception e)
   {
     out.println("Exception 單批作業管制寫入流程卡:"+e.getMessage());
   }	
	   //out.print("Runcard no="+runCardNo+"    Qty="+runCardQty+"<br>");
  }// End of for (i=0)   
  

 } //end if (singleControl=="Y" || singleControl.equals("Y"))
 else  
 {  
  
  // 不依單批作業管制量生產之流程卡_起  

   //out.print("<br>TTTTTT runCardNo="+runCardNo+"  "+woQty+"<br>"); 
    //  runCardNo=runCardNo.substring(0,9)+"-"+runCardNo.substring(9,12); // 直接一張工令對應產生一張流程卡
   if (alternateRouting!=null && alternateRouting.equals("2"))
   { // 外購工令  ###############################################3   
   
        runCardNo=woNo.substring(0,9)+"-"+woNo.substring(9,12); // 直接一張工令對應產生一張流程卡   
        
        String sqlRC = " select * from YEW_RUNCARD_ALL where RUNCARD_NO = '"+runCardNo+"' " ;
	    Statement stateRC=con.createStatement();
		ResultSet rsRC=stateRC.executeQuery(sqlRC);
		if (!rsRC.next())
		{ // 若流程卡不存在,則可用工令號-流程卡序號	作為外購流程卡號   
		   out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>");  
		} else { 
		         // 否則,依前置碼找最大流程卡號_起
		            //====先取得流水號=====  
					seqkey=woNo.substring(0,9); // 工令最大號
                    Statement statement=con.createStatement();
                    ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+seqkey+"' and TYPE='RC' ");   
                    if (rs.next()==false)
                    {  
                      String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
                      PreparedStatement seqstmt=con.prepareStatement(seqSql);     
                      seqstmt.setString(1,seqkey);
                      seqstmt.setInt(2,1);   	
				      seqstmt.setString(3,"RC"); 
                      seqstmt.executeUpdate();
                      seqno=seqkey+"-"+"001";
                      seqstmt.close();   
                    } 
                    else 
                    {
                       int lastno=rs.getInt("LASTNO");
                       // 20091111 Liling Update : Performance Issue
                       //String sqla2 = "select * from APPS.YEW_RUNCARD_ALL where substr(RUNCARD_NO,1,9)='"+seqkey+"' and to_number(substr(RUNCARD_NO,11,3))= '"+lastno+"' ";
                       String sqla2 = "select * from APPS.YEW_RUNCARD_ALL where RUNCARD_NO='"+seqno+"' ";
                       ResultSet rs2=statement.executeQuery(sqla2);
                       //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                       if (rs2.next())
                       {   	     
                         lastno++;
                         String numberString = Integer.toString(lastno);
                         String lastSeqNumber="000"+numberString;
                         lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
                         seqno=seqkey+"-"+lastSeqNumber;     
   
                         String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE='RC' ";   
                         PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                         seqstmt.setInt(1,lastno);  
                         seqstmt.executeUpdate();   
                         seqstmt.close(); 
                       } 
                       else
                       {
                           //===========(處理跳號問題)否則以實際RUNCARD檔內最大流水號為目前RUNCARD的lastno內容(會依編碼別)
                           // 20091111 Liling Update : Performance Issue
                           // String sSqlSeq = "select to_number(substr(max(RUNCARD_NO),11,3)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(RUNCARD_NO,1,9)='"+seqkey+"' ";
                            String sSqlSeq = "select substr(max(RUNCARD_NO),11,3) as LASTNO from APPS.YEW_RUNCARD_ALL where RUNCARD_NO like '"+seqkey+"%' ";
                           ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                       if (rs3.next()==true)
	                       {
                               int lastno_r=rs3.getInt("LASTNO");	  
	                           lastno_r++;	  
	                           String numberString_r = Integer.toString(lastno_r);
                               String lastSeqNumber_r="000"+numberString_r;
                               lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
                               seqno=seqkey+"-"+lastSeqNumber_r;  	 
	                           String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE='RC' ";   
                               PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                               seqstmt.setInt(1,lastno_r);	
                               seqstmt.executeUpdate();   
                               seqstmt.close();  
	                       }  // End of if (rs3.next()==true)   
                        } // End of Else  //===========(處理跳號問題)
                    } // End of Else  					
					runCardNo=seqno; // 把取到的本日最大流程卡號當成此張外購流程卡號
					out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>"); 
					%>
					   <script language="jscript">
					      alert("此張外購工令流程卡號已被其它工令使用\n將以本日最大號作為流程卡號!!!");
					   </script> 
					<%
				    // 否則,依前置碼找最大流程卡號_迄
		        } // End of else(號碼已被其它一般工令所使用)  
		rsRC.close();
		stateRC.close();
		
		// 2007/08/13  針對後段工令,判斷若指定產生特殊客戶批號則給出批號_起
		//if (woType.equals("3") && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號
		if ((woType.equals("3")||woType.equals("5")) && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號	//20151026 liling add type=5
		{
		            custLotSeqkey=custLotNoPrefix+monDayString; // 本日前置客戶特殊批號
                    Statement statement=con.createStatement();
                    ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+custLotSeqkey+"' and TYPE='CL' ");   
                    if (rs.next()==false)
                    {  
                      String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
                      PreparedStatement seqstmt=con.prepareStatement(seqSql);     
                      seqstmt.setString(1,custLotSeqkey);
                      seqstmt.setInt(2,1);   	
				      seqstmt.setString(3,"CL"); 
                      seqstmt.executeUpdate();
                      custLotSeqno=custLotSeqkey+"01";
                      seqstmt.close();   
                    } 
                    else 
                    {
                       int lastno=rs.getInt("LASTNO");
                       String sqla2 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";
                       ResultSet rs2=statement.executeQuery(sqla2); 	
                       //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                       if (rs2.next())
                       {   	     
                         lastno++;
                         String numberString = Integer.toString(lastno);
                         String lastSeqNumber="00"+numberString;
                         lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
                         custLotSeqno=custLotSeqkey+lastSeqNumber;     
   
                         String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                         PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                         seqstmt.setInt(1,lastno);  
                         seqstmt.executeUpdate();   
                         seqstmt.close(); 
                       } 
                       else
                       {
                           //===========(處理跳號問題)否則以實際RUNCARD檔內最大流水號為目前RUNCARD的lastno內容(會依編碼別)
                           String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),11,2)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' ";
                           ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                       if (rs3.next()==true)
	                       {
                               int lastno_r=rs3.getInt("LASTNO");	  
	                           lastno_r++;	  
	                           String numberString_r = Integer.toString(lastno_r);
                               String lastSeqNumber_r="00"+numberString_r;
                               lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
                               custLotSeqno=custLotSeqkey+lastSeqNumber_r;  	 
	                           String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                               PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                               seqstmt.setInt(1,lastno_r);	
                               seqstmt.executeUpdate();   
                               seqstmt.close();  
	                       }  // End of if (rs3.next()==true)   
                        } // End of Else  //===========(處理跳號問題)
                    } // End of Else  					
					custLotNo=custLotSeqno; // 把取到的本日最大客戶特殊批號當成此張外購工令特殊客戶批號
		} // End of if (woType.equals("3") && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號
		else {
			       custLotNo= ""; // 若非後段或未指明要給特殊客戶批號,則給空值
			 }
        // 2007/08/13  針對後段工令,判斷若指定產生特殊客戶批號則給出批號_迄
   }
   else { // 其他一般自製工令,單張流程卡以流程卡號與工令號多 -  ########################################3
          runCardNo=woNo.substring(0,9)+"-"+woNo.substring(9,12); // 直接一張工令對應產生一張流程卡		  
          out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>"); 
		   // 2007/08/13  針對後段工令,判斷若指定產生特殊客戶批號則給出批號_起
		  // if (woType.equals("3") && !custLot.equals("0"))  // 0表是一般客戶, 非0可定義多筆特殊客戶批號
		   if ((woType.equals("3")||woType.equals("5")) && !custLot.equals("0"))  // 0表是一般客戶, 非0可定義多筆特殊客戶批號		 //20151026 liling add type=5  
	   	   {
		            custLotSeqkey=custLotNoPrefix+monDayString; // 本日前置客戶特殊批號
                    Statement statement=con.createStatement();
                    ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+custLotSeqkey+"' and TYPE='CL' ");   
                    if (rs.next()==false)
                    {  
                      String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
                      PreparedStatement seqstmt=con.prepareStatement(seqSql);     
                      seqstmt.setString(1,custLotSeqkey);
                      seqstmt.setInt(2,1);   	
				      seqstmt.setString(3,"CL"); 
                      seqstmt.executeUpdate();
                      custLotSeqno=custLotSeqkey+"01";
                      seqstmt.close();   
                    } 
                    else 
                    {
                       int lastno=rs.getInt("LASTNO");
                       String sqla2 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";
                       ResultSet rs2=statement.executeQuery(sqla2); 	
                       //===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
                       if (rs2.next())
                       {   	     
                         lastno++;
                         String numberString = Integer.toString(lastno);
                         String lastSeqNumber="00"+numberString;
                         lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-2);
                         custLotSeqno=custLotSeqkey+lastSeqNumber;     
   
                         String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                         PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                         seqstmt.setInt(1,lastno);  
                         seqstmt.executeUpdate();   
                         seqstmt.close(); 
                       } 
                       else
                       {
                           //===========(處理跳號問題)否則以實際RUNCARD檔內最大流水號為目前RUNCARD的lastno內容(會依編碼別)
                           String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),11,2)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' ";
                           ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                       if (rs3.next()==true)
	                       {
                               int lastno_r=rs3.getInt("LASTNO");	  
	                           lastno_r++;	  
	                           String numberString_r = Integer.toString(lastno_r);
                               String lastSeqNumber_r="00"+numberString_r;
                               lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-2);
                               custLotSeqno=custLotSeqkey+lastSeqNumber_r;  	 
	                           String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+custLotSeqkey+"' and TYPE='CL' ";   
                               PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                               seqstmt.setInt(1,lastno_r);	
                               seqstmt.executeUpdate();   
                               seqstmt.close();  
	                       }  // End of if (rs3.next()==true)   
                        } // End of Else  //===========(處理跳號問題)
                    } // End of Else  					
					custLotNo=custLotSeqno; // 把取到的本日最大客戶特殊批號當成此張自製工令特殊客戶批號
		    } // End of if (woType.equals("3") && !custLot.equals("0")) // 0表是一般客戶, 非0可定義多筆特殊客戶批號
			else {
			       custLotNo= ""; // 若非後段或未指明要給特殊客戶批號,則給空值
			     }
            // 2007/08/13  針對後段工令,判斷若指定產生特殊客戶批號則給出批號_迄
        } // end of else
   //=====補不足資料欄位,起====================
   //RUNCARD_ID

     String sqli = " select APPS.YEW_RUNCARD_ALL_S.nextval AS RUNCARD_ID from dual " ;
	 Statement statei=con.createStatement();
     ResultSet rsi=statei.executeQuery(sqli);
	 if (rsi.next())
	 {	
	   runCardId   = rsi.getString("RUNCARD_ID"); 	  
	 }
	 rsi.close();
     statei.close();


  try // 不依單批作業管制量生產之流程卡 ******** 直接一張工令產生一張流程卡;
  {	// 寫入流程卡主檔	
  
   if (operationSeqNum  == null || operationSeqNum.equals(""))   operationSeqNum="0";
   if (operationSeqId   == null || operationSeqId.equals(""))     operationSeqId="0";
   if (standardOpId     == null || standardOpId.equals(""))         standardOpId="0";
   if (nextOpSeqNum     == null || nextOpSeqNum.equals(""))         nextOpSeqNum="0";
   if (previousOpSeqNum == null || previousOpSeqNum.equals("")) previousOpSeqNum="0";  

    //out.print("step6<BR>");		
	String Sqlrc="insert into APPS.YEW_RUNCARD_ALL(RUNCAD_ID,WO_NO,RUNCARD_NO,PRIMARY_ITEM_ID,INV_ITEM,ITEM_DESC, "+
				 "            RUNCARD_STATUS,QTY_IN_QUEUE,CREATE_BY,CREATION_DATE,STATUSID,STATUS,DEPT_NO,ORGANIZATION_ID,WIP_ENTITY_ID, "+
				 "            OPERATION_SEQ_NUM,OPERATION_SEQ_ID,STANDARD_OP_ID,STANDARD_OP_DESC,NEXT_OP_SEQ_NUM, PREVIOUS_OP_SEQ_NUM, RUNCARD_QTY, ROUTING_REFERENCE_ID,LINE_NUM,WEB_SYSID, SUPPLIER_LOT_NO, CUST_LOT_NO,RC_DATE_CODE,DC_YYWW)   "+  //20091123 liling 加 RC_DATE_CODE
				 "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";   
    PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
    seqstmt.setString(1,runCardId);
    seqstmt.setString(2,woNo);
	seqstmt.setString(3,runCardNo); 
	seqstmt.setString(4,itemId);
    seqstmt.setString(5,invItem);
	seqstmt.setString(6,itemDesc); 
	seqstmt.setString(7,"O");      //runcaard status O=Open
    seqstmt.setFloat(8,java.lang.Math.abs(Float.parseFloat(woQty)));    //不受單批控管的數量為工令數量
	seqstmt.setString(9,userMfgUserID); 
	seqstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //creation date
    //seqstmt.setString(11,"042");
	//seqstmt.setString(12,"流程卡生成"); 
	seqstmt.setString(11,getStatusRs.getString("TOSTATUSID")); 
	seqstmt.setString(12,getStatusRs.getString("STATUSNAME")); 
	seqstmt.setString(13,deptNo);
	seqstmt.setString(14,organizationId);
	seqstmt.setInt(15,Integer.parseInt(entityId));
	seqstmt.setInt(16,Integer.parseInt(operationSeqNum));
	seqstmt.setInt(17,Integer.parseInt(operationSeqId));
	seqstmt.setInt(18,Integer.parseInt(standardOpId));
	seqstmt.setString(19,standardOpDesc);
	seqstmt.setInt(20,Integer.parseInt(nextOpSeqNum));
	seqstmt.setInt(21,Integer.parseInt(previousOpSeqNum));
	seqstmt.setFloat(22,java.lang.Math.abs(Float.parseFloat(woQty)));
	seqstmt.setInt(23,Integer.parseInt(routingRefID));	
	seqstmt.setInt(24,1);
	seqstmt.setInt(25,Integer.parseInt(webSysID));
	seqstmt.setString(26,opSupplierLot);
	seqstmt.setString(27,custLotNo); // 2007/08/13 依客戶特殊批號給產生的客戶批號
    seqstmt.setString(28,dateCode);  //20091123 liling 加 RC_DATE_CODE
    seqstmt.setString(29,dc_yyww);   //20220715 by Peggy 
    seqstmt.executeUpdate();
    seqstmt.close();   	
	
	      // %%%%%%%%%%%%%%%%%%% 寫入Run card Transaction %%%%%%%%%%%%%%%%%%%_起 	
		   String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           "            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           "            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           "            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				           "            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						   "            LASTUPDATE_DATE, OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME ) "+
				           "     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"') ";  						
           PreparedStatement queueTransStmt=con.prepareStatement(SqlQueueTrans); 
           queueTransStmt.setInt(1,Integer.parseInt(runCardId)); // RUNCAD_ID          
	       queueTransStmt.setString(2,runCardNo);                // RUNCARD_NO
           queueTransStmt.setInt(3,Integer.parseInt(organizationId));           // ORGANIZATION_ID
	       queueTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
	       queueTransStmt.setInt(5,Integer.parseInt(itemId));                   // PRIMARY_ITEM_ID
           queueTransStmt.setInt(6,Integer.parseInt(operationSeqNum));          //FM_OPERATION_SEQ_NUM(本站)    
		   queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           queueTransStmt.setInt(8,Integer.parseInt(nextOpSeqNum));             //TO_OPERATION_SEQ_NUM(下一站) 
	       queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(下一站代碼) 
	       queueTransStmt.setFloat(10,java.lang.Math.abs(Float.parseFloat(woQty)));  // Transaction Qty
	       queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       queueTransStmt.setInt(12,1);             // 1=Queue		  
	       queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       queueTransStmt.setString(15,"040");      // From StatusId (CREATING)
		   queueTransStmt.setString(16,"CREATING");	  // From STATUS
		   queueTransStmt.setString(17,fndUserName);	  // Update User 
		   queueTransStmt.setFloat(18,0);
           queueTransStmt.executeUpdate();
           queueTransStmt.close();	    	 
		 
		 // %%%%%%%%%%%%%%%%%%% 寫入Run card Transaction %%%%%%%%%%%%%%%%%%%_迄 
	
	//out.print("Runcard no="+runCardNo+"    Qty="+woQty+"<br>");
    // Error1. YEW_RUNCARD_ALL 沒有Release_date等相關欄位,Liling 弄錯了,更正為 APPS.YEW_WORKORDER_ALL 
    String woSql=" update APPS.YEW_WORKORDER_ALL set RELEASE_DATE=? ,RELEASED_BY=?, WO_STATUS=?,STATUSID=?,STATUS=?,WIP_ENTITY_ID=? ,DATE_CODE=?, DC_YYWW=?"+
	             " where WO_NO= '"+woNo+"' "; 	
    PreparedStatement wostmt=con.prepareStatement(woSql);
	//out.print("woSql="+woSql);        
    wostmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
	wostmt.setInt(2,Integer.parseInt(userMfgUserID));
	wostmt.setString(3,"R"); 	
	wostmt.setString(4,getStatusRs.getString("TOSTATUSID")); 
	wostmt.setString(5,getStatusRs.getString("STATUSNAME")); 
	wostmt.setInt(6,Integer.parseInt(entityId));
	wostmt.setString(7,dateCode);		
	wostmt.setString(8,dc_yyww); //add by Peggy 20220715		
    wostmt.executeUpdate();   
    wostmt.close(); 
	
	
	// ----------------- By Kerwin 檢核已展開的卡是否已經=工令數量
	accExpandedRCQty = accExpandedRCQty + java.lang.Math.abs(Float.parseFloat(woQty)); //  累加已展流程卡數... By Kerwin 2007/03/26
	       try
		   {			         
				    bd = new java.math.BigDecimal(accExpandedRCQty);
				    strAccRunCardQty = bd.setScale(4, java.math.BigDecimal.ROUND_HALF_UP);
				    accExpandedRCQty = Math.abs(strAccRunCardQty.floatValue());				    
		   } //end of try
           catch (NumberFormatException e)
           {
              System.out.println("Exception: Remainder Round to 4 digit "+e.getMessage());
           }
	
   }// end of try
   catch (Exception e)
   {
     out.println("Exception 5.5:"+e.getMessage());
   }	  
  
  } //end of else if (singleControl=="Y" || singleControl.equals("Y"))
  // 不依單批作業管制量生產之流程卡_迄 
 }// end of try
 catch (Exception e)
 {
     out.println("Exception 6:"+e.getMessage());
 }  

 }	//end of  woPassflag (if (woPassflag.equals("Y"))

} // End of if not (adminModeOption!=null && adminModeOption.equals("YES") && UserRole.equals("admin"))

    //out.print("流程卡展開O.K.("+entityId+")");	
	
  //out.println("accExpandedRCQty="+accExpandedRCQty);
  //out.println("runCardQty="+runCardQty);	
  
 if (accExpandedRCQty != Float.parseFloat(woQty))  // 如果判斷累計已展卡數 不等於 工令數 , 表示此次展卡含有異常,除了 Rollback Runcard 
 { out.println("accExpandedRCQty="+accExpandedRCQty);
   
     con.rollback();   // 捲回去剛才寫入的流程卡檔,流程卡異動歷程檔
   
               %>
 	             <script LANGUAGE="JavaScript">
				   alert("流程卡展開異常,累計流程卡總數(<%=accExpandedRCQty%>)不等於工令數(<%=Float.parseFloat(woQty)%>)\n                 未產生流程卡主檔!!!");
				   alert("請通知管理員,以管理員模式協助展開流程卡!!!");
	               //reProcessQueryConfirm("此流程卡已移至委外加工,繼續執行委外加工採購收料作業?","../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=045&PAGEURL=TSCMfgRunCardOSPReceipt.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	             </script>
	           <%
 } else { 	
                                boolean wipNameCreated = false;
                                // 判斷如Oracle 工令已存在與此張生產系統工令號一致, 則表示此為已生成Oracle工令,此次需由管理員執行管理員模式2僅展開流程卡
								 String sqlAd2 = " select WIP_ENTITY_NAME from WIP_ENTITIES   "+							            
									             "  where WIP_ENTITY_NAME = '"+woNo+"' ";
								 Statement stateAd2=con.createStatement();
                                 ResultSet rsAd2=stateAd2.executeQuery(sqlAd2);
								 if (rsAd2.next())
								 {
								   wipNameCreated = true;
								 } else wipNameCreated = false;
								 rsAd2.close();
								 stateAd2.close();
             if (wipNameCreated==false) // 判斷若Oracle工令未生成
             {
			    out.print("<BR><font color='#0033CC'>因Oracle工令不存在,Rollback 流程卡展開.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")<BR> 以上流程卡未寫入主檔 !!!</font>");
			    con.rollback();   // 捲回去剛才寫入的流程卡檔,流程卡異動歷程檔 ,若Oracle工令未生成
             } else {
	                  out.print("<BR><font color='#0033CC'>流程卡展開O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
					}  
	    } // End of else
	
    // 使用完畢清空 2維陣列
    if (aMFGWoExpandCode!=null)
	{ 
	  arrMFG2DWOExpandBean.setArray2DString(null); 
	} 
 
}  //END OF 020_ACTION IF  
//流程卡展開)_迄	(ACTION=020)  

//MFG流程卡投產直接委外加工_起	(ACTION=024)  流程卡已展開042->流程卡委外加工中 045
if (actionID.equals("024") && fromStatusID.equals("042"))   // 如為n站, 即 第一站(委外加工站) --> 第二站 --> 第 n-1 站
{   //out.println("fromStatusID="+fromStatusID);
    String fndUserName = "";  //處理人員
	String woUOM = ""; // 工令移站單位
	int primaryItemID = 0; // 料號ID
	entityId = "0"; // 工令wip_entity_id
	boolean interfaceErr = false;  // 判斷其中 Interface 有異常的旗標
    if (aMFGRCExpTransCode!=null)
	{	  
	  if (aMFGRCExpTransCode.length>0)
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
						 String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID "+
						                "  from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 									     " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "'";
						 Statement stateUOM=con.createStatement();
                         ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
						 if (rsUOM.next())
						 {
						   woUOM = rsUOM.getString("WO_UOM");
						   entityId =  rsUOM.getString("WIP_ENTITY_ID");
						   primaryItemID = rsUOM.getInt("PRIMARY_ITEM_ID");
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
		    // out.println("Last Operation");
		     toIntOpSType = 3;   //
		     aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // 無下一站的Seq No,故給本站
			 transType = 1; //(完工由入庫後自動執行,故仍設為1)
		   }  // 若無下一站,表示本站是最後一站,toStepType 設成3	, transaction Type 設為2(Move Completion)
/* 2006/12/26 liling			   
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
           scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  (2006/12/08 RUNNING )     
		   scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>此站報廢數量="+rcScrapQty+"<BR>");// 移站報廢數量	       	   
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
										 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
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
		 out.println("<BR>報廢的groupID ="+groupID+"<BR>");
		 
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
						  out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"getErrScrapBuffer="+getErrScrapBuffer+"<BR>");			  	  
					 */
/* 2006/12/26 liling
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
						  }						  					  
						  out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"報廢錯誤原因="+getErrScrapBuffer+"<BR>");
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
/* 2006/12/26 liling
			}	  
			catch (Exception e) { out.println("Exception報廢的groupID:"+e.getMessage()); }  
		  } // end of if (groupID>0 && opSeqNo>0)			 
		 // *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄
		 
		} // End of if (rcScrapQty>0)
				 
		String getErrBuffer = "";
		int getRetCode = 0;		         
		if (getRetScrapCode==0) // 若執行同一站報廢成功,才執行移下一站動作_起
		{  
		   //toIntOpSType = 1;  // 移站的to InterOperation Step Type = 1 
		   // *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  起
           String Sqlrc="insert into WIP_MOVE_TXN_INTERFACE( "+
				        "            CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				        "            PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				        "            WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				        "            TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, GROUP_ID, TRANSACTION_ID ) "+
				        "     values(?,SYSDATE,SYSDATE,?,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL, WIP_TRANSACTIONS_S.NEXTVAL ) ";   
						// "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";  
           PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
           seqstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
          // seqstmt.setDate(2,processDateTime);  out.println("processDateTime="+processDateTime); // CREATION_DATE
	      // seqstmt.setDate(3,processDateTime);  out.println("processDateTime="+processDateTime); // LAST_UPDATE_DATE 
	       seqstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
           seqstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
	       seqstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
	       seqstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
           seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error
	     //  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
		   seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // 移站數量
	       //seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
		   //out.println("數量="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
           seqstmt.setString(8,woUOM);
	       seqstmt.setInt(9,Integer.parseInt(entityId));  
	       seqstmt.setString(10,woNo);  //out.println("工令號="+woNo);
	       seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP  //liling
		   //seqstmt.setInt(12,20);
	       seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(本站)
		   //out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
	       seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(完工), 5=SCRAP(報廢)
	       seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("流程卡號="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 流程卡號 
		   seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
           seqstmt.executeUpdate();
           seqstmt.close();	      	
		   
		   //抓取寫入Interface的Group等資訊_起
	       int groupID = 0;
		   int opSeqNo = 0;              
						String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
										 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
										 "   and TO_INTRAOPERATION_STEP_TYPE in (1, 3) "; // 取此次移站的Group ID
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
		 out.println("<BR>移站的groupID ="+groupID+"<BR>");
		
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
/* 2006/12/26 liling
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
						  }							  
						  out.println("getRetCode="+getRetCode+"&nbsp;"+"移站錯誤原因="+getErrBuffer+"<BR>");
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
										     "   and TO_INTRAOPERATION_STEP_TYPE in (1, 3) and  GROUP_ID = "+groupID+" ";   // 取此次移站
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
/* 2006/12/26 liling
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		  } // end of if (groupID>0 && opSeqNo>0)			 
		 // *****%%%%%%%%%%%%%% 正常移站數量  %%%%%%%%%%%%**********  迄
		 
		} // End of if (getRetScrapCode=0) 	
*/ //2006/12/26 liling	 

	
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@		
    boolean errPRImpFlag = false; // 針對非德錫,PR Requisition Import產生的錯誤判斷
    int getRetScrapCode = 0,getRetCode=0,rcScrapQty=0;
//	if (getRetScrapCode==0 && getRetCode==0) // 若報廢及移站都執行成功,則執行PR Interface異動更新
//	{ 	
       // out.println("執行更新PR_INTERFACE_0");
		 //先取得欲執行產生PO之Responsibility ID_起
	     Statement stateResp=con.createStatement();	   
	     ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME = 'YEW_WIP_SEMI_SU' "); 
	     if (rsResp.next())
	     {
	       respID = rsResp.getString("RESPONSIBILITY_ID");
	     } else {
	              respID = "50777"; // 找不到則預設 --> YEW WIP Super User 預設
	            }
			    rsResp.close();
			    stateResp.close();	  	
	     //先取得欲執行產生PO之Responsibility ID_迄
		    // 取出轉請購單(PR_INTERFACE)內資訊並更新其ATTRIBUTE2_起
		    //out.println("執行更新PR_INTERFACE_1");
			boolean oddOSPFlag = false;  // 針對德錫,需特別處理Interface			
          //20091118 liling update for performance issue		
		  //  String sqlOSPInt = " select * from PO_REQUISITIONS_INTERFACE_ALL "+
		  //	                   " where to_char(WIP_ENTITY_ID) = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
		  //                     " and to_char(DESTINATION_ORGANIZATION_ID) = '"+aMFGRCExpTransCode[i][8]+"' and to_char(WIP_OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][5]+"' ";
		    String sqlOSPInt = " select * from PO_REQUISITIONS_INTERFACE_ALL "+
			                   " where WIP_ENTITY_ID = "+entityId+" and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
		                       " and DESTINATION_ORGANIZATION_ID = '"+aMFGRCExpTransCode[i][8]+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ";
			//out.println("sqlOSPInt ="+sqlOSPInt);
			Statement stateOSPInt=con.createStatement();
            ResultSet rsOSPInt=stateOSPInt.executeQuery(sqlOSPInt);
			if (rsOSPInt.next())
			{   //out.println("執行更新PR_INTERFACE_2");
			    try
				{
			      String sqlJudgeOSP ="";
				  if (jobType==null || jobType.equals("1"))
				  {
				         sqlJudgeOSP =" select b.DESCRIPTION, b.RESOURCE_CODE, b.COST_CODE_TYPE "+
                                      " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, "+
					                  "      BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d, APPS.YEW_RUNCARD_ALL e "+
                                      " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					                  // "   and b.ORGANIZATION_ID = '"+organizationID+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
									  "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					                  "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					                  "   and d.OPERATION_SEQ_NUM = e.NEXT_OP_SEQ_NUM "+ //e.NEXT_OP_SEQ_NUM "+
									  "   and e.RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' "+
									  "   and a.OPERATION_SEQUENCE_ID = e.NEXT_OP_SEQ_ID "+
					                  "   and b.COST_CODE_TYPE = 4 "+ // 為外包
									  "   and ( b.DESCRIPTION like '%德錫%' or b.RESOURCE_CODE like '%DA%') "; // 暫時使用Description 判斷是否要產生已核准PR,否則停在Interface
				  } else {
				          sqlJudgeOSP = " select DISTINCT d.DESCRIPTION, d.RESOURCE_CODE, d.COST_CODE_TYPE "+        			              
					                    "   from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									    "        BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									    "  where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									    "    and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 因為重工工令可能無BOM表
										"    and b.RESOURCE_ID = d.RESOURCE_ID "+
										//"    and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+ // 只有一站,因為投產站即為完工站(2006/11/22)
										//"    and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM "+
									    "    and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' "+
									    "    and d.COST_CODE_TYPE = 4 and d.ORGANIZATION_ID ='"+organizationID+"' ";
										//"    and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM ";	
						  if (directOSP==null || directOSP.equals("N"))
						  {  sqlJudgeOSP = sqlJudgeOSP + " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM ";  }
						  else if (directOSP.equals("Y")) {  sqlJudgeOSP = sqlJudgeOSP + " and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM ";  }
				         }				  
                  //out.println(sqlJudgeOSP+"<BR>");					   
                  Statement stateJudgeOSP=con.createStatement();
                  ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
                  //out.print("stepaa");
				  if (rsJudgeOSP.next()) //  判斷若製程外包站為德錫,則需另更新Interface的Suggested Vendor ID, Suggested Vendor Site ID及
				  {
				     PreparedStatement stmtLogOSP3=con.prepareStatement("insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
					                                                             " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																				 " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID, SQL_LOG ) "+ 
																	 " values('"+woNo+"','"+aMFGRCExpTransCode[i][1]+"','NA','044','MOVING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																	        " '03','PR Dexi','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCExpTransCode[i][9]+"','"+aMFGRCExpTransCode[i][4]+"','"+aMFGRCExpTransCode[i][10]+"', "+
																			" '"+aMFGRCExpTransCode[i][3]+"','"+aMFGRCExpTransCode[i][3]+"','"+aMFGRCExpTransCode[i][5]+"','"+aMFGRCExpTransCode[i][5]+"',?) "); 
					//out.print("<br>sqlJudgeOSP="+sqlJudgeOSP);
                    stmtLogOSP3.setString(1,sqlJudgeOSP); 														         	                	          
                    stmtLogOSP3.executeUpdate();
                    stmtLogOSP3.close();
				    
				    // 若是陽信德錫科技有限公司 ,動態取出其VNEDOR_ID 及其SITE_ID_起
				    int dexiVendorID = 0;
				    int dexiVndSiteID = 0;
				    Statement stateDEXI=con.createStatement();
                    ResultSet rsDEXI=stateDEXI.executeQuery("select a.VENDOR_ID, b.VENDOR_SITE_ID from po_vendors a, po_vendor_sites_all b where a.VENDOR_ID = b.VENDOR_ID and trim(a.VENDOR_NAME) = '陽信德錫科技有限公司' ");
				    if (rsDEXI.next())
				    {
				      dexiVendorID = rsDEXI.getInt(1);
					  dexiVndSiteID = rsDEXI.getInt(2); 
				    }
				    rsDEXI.close();
				    stateDEXI.close();
				    // 若是陽信德錫科技有限公司 ,動態取出其VNEDOR_ID 及其SITE_ID_迄					
					
					//out.print("dexiVendorID="+dexiVendorID+"  "+dexiVndSiteID);
					oddOSPFlag = true;	
					out.println("德錫外包寫入PR Interface,等待REQ IMP執行<BR>");
				 
					
					String sqlUpPRInt = "  update PO_REQUISITIONS_INTERFACE_ALL set LINE_ATTRIBUTE2=?, SUGGESTED_VENDOR_ID=?, SUGGESTED_VENDOR_SITE_ID=?, AUTOSOURCE_FLAG=?, NOTE_TO_RECEIVER=? "+
				                        "  where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									    "    and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ";
										 
			        
                    PreparedStatement stmtLinkOSP=con.prepareStatement(sqlUpPRInt);          
	                stmtLinkOSP.setString(1,woNo);                  //out.println("工令號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 工令號 
	                stmtLinkOSP.setInt(2,dexiVendorID);             // SUGGESTED_VENDOR_ID(德錫)
				    stmtLinkOSP.setInt(3,dexiVndSiteID);	        // SUGGESTED_VENDOR_SITE_ID(德錫)
					stmtLinkOSP.setString(4,"Y");                   // API文件限制,要給Suggest Vendor ID需設定為P  //20061225 liling 改為Y ,因為用P會抓不到單價 	
					stmtLinkOSP.setString(5,aMFGRCExpTransCode[i][1]);// out.println("流程卡號="+aMFGRCMovingCode[i][1]); // NOTE_TO_RECEIVER = 流程卡號  	          
                    stmtLinkOSP.executeUpdate();
                    stmtLinkOSP.close();		
				 	out.println("更新 PR Interface Success!!<BR>");	
					// For MIS Testing Only 省得麻煩去Request執行直接呼叫_起------------------------------上線後移除	
					         int batchId = 0;
							 String errPRIntMSG = "";
							 String errPRIntCLN = ""; 	
					         int requestID = 0;
							 
							// 取批次BatchID
							Statement stateBatchID=con.createStatement();
                            ResultSet rsBatchID=stateBatchID.executeQuery("SELECT PR_INTERFACE_BATCH_ID_S.NEXTVAL FROM dual");
	                        if (rsBatchID.next()) batchId = rsBatchID.getInt(1);
							rsBatchID.close();
							stateBatchID.close(); 
							// 取批次BatchID
							
							    try
								{   
								     String orgOU = "";
                                      Statement stateOU=con.createStatement();   
                                      ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
                                      if (rsOU.next())
                                      {
                                         orgOU = rsOU.getString(1);
                                      }
                                      rsOU.close();
                                      stateOU.close();									  
									  
									 PreparedStatement stmtLogDxOSP=con.prepareStatement("insert into YEW_MFG_OSPPROC_LOG(WO_NO, RUNCARD_NO, TYPE_CODE, FROM_STATUSID, FROM_STATUS, TO_STATUSID, TO_STATUS, "+
					                                                             " PROC_STEP, PROC_STEP_DESC, PR_NUM, PO_NUM, CREATION_DATE, CREATED_BY, FR_OPSEQ_ID, FR_OPSEQ_NUM, FR_OPSEQ_DESC, "+
																				 " FR_PREVOP_SEQ_NUM, FR_PREVOP_SEQ_ID, FR_NEXTOP_SEQ_NUM, FR_NEXTOP_SEQ_ID ) "+ 
																	   " values('"+woNo+"','"+aMFGRCExpTransCode[i][1]+"','NA','042','GENERATING','"+getStatusRs.getString("TOSTATUSID")+"','"+getStatusRs.getString("STATUSNAME")+"', "+
																	            " '04','PO Dexi Creating','0','0',SYSDATE,'"+userMfgUserID+"','"+aMFGRCExpTransCode[i][9]+"','"+aMFGRCExpTransCode[i][4]+"','"+aMFGRCExpTransCode[i][10]+"', "+
																			    " '"+aMFGRCExpTransCode[i][3]+"','"+aMFGRCExpTransCode[i][3]+"','"+aMFGRCExpTransCode[i][5]+"','"+aMFGRCExpTransCode[i][5]+"' ) ");          	                	          
                                     stmtLogDxOSP.executeUpdate();
                                     stmtLogDxOSP.close();		 
								  
								  //   out.println("呼叫Create PO for OSP Dexi Request Line 1496<BR>");
								    //out.println("userMfgUserID="+userMfgUserID+"<BR>");
								    //out.println("respID="+respID+"<BR>");
								  /*	
								     CallableStatement cs1 = con.prepareCall("{call YEW_WIP_OSP_Pkg.CREATE_PO(?,?,?)}");	
									 cs1.registerOutParameter(1, Types.VARCHAR); 
									 cs1.registerOutParameter(2, Types.VARCHAR); 	                                
				                     cs1.setInt(3,Integer.parseInt(orgOU));  //*  ParOrgID //	                                 
	                                 cs1.execute();
                                     //out.println("Procedure : Execute Success !!! ");	                                 
                                     cs1.close();
								  */
								} //end of try
                                catch (SQLException e)
                                {
                                // out.println("Exception 呼叫Create PO for OSP Dexi Request:"+e.getMessage());
                                }	
							  // 一般委外加工,呼叫REQUISITION IMPORT REQUEST產生PR_迄
							  //con.commit();
							  //java.lang.Thread.sleep(15000);	 // 延遲十五秒,等待Concurrent執行完畢,取結果判斷		
							  // 最後再判斷是否一般外包PR 是否順利產生_起
							    // 取批次BatchID
								String  sqlPRError = "select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
								                     "  from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
								                     " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
													 "   and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
													 "   and a.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
							    Statement statePRError=con.createStatement();
                                ResultSet rsPRError=statePRError.executeQuery(sqlPRError);
	                            if (rsPRError.next()) 
								{ 
								  errPRIntCLN = rsPRError.getString(2);
								  errPRIntMSG = rsPRError.getString(3);
								  errPRImpFlag = true; // 錯誤旗標
								  
								  out.println("<font color='#FF0000'>Create PO for OSP Dexi Request發生錯誤</font>!!!:錯誤欄位(<font color='#0033CC'>"+errPRIntCLN+"</font>)<BR>");
								  out.println("<font color='#FF0000'>錯誤訊息</font>:"+errPRIntMSG+"<BR>");								  
								} else {
								        //out.println("Success Submit Create PO for OSP Dexi Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)<BR>");
										String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
										//out.println("sqlPRNo ="+sqlPRNo+"<BR>");
										Statement statePRNo=con.createStatement();
                                        ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
	                                    if (rsPRNo.next()) 
								        {  //out.println("產生PR號碼="+rsPRNo.getString("SEGMENT1")+"<BR>");
										   PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ");          
	                                       stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No於流程卡檔	                         	          
							               stmtLinkRC.setInt(2,batchId);							               
                                           stmtLinkRC.executeUpdate();
                                           stmtLinkRC.close(); 
										}	
										rsPRNo.close();
										statePRNo.close();						 
								       } // End of else
							    rsPRError.close();
							    statePRError.close();     
							 // 最後再判斷是否一般外包PR 是否順利產生_迄					  
							  
						// For MIS Testing Only 省得麻煩去Request執行直接呼叫_迄------------------------------上線後移除
					
												
				  } else {  // 一般外包廠商,系統開至PR完成後,由人員自行開立採購單_起
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
							// 取批次BatchID
						/*	
				            String sqlUpPRInt = "  update PO_REQUISITIONS_INTERFACE_ALL set LINE_ATTRIBUTE2=?, BATCH_ID=?, NOTE_TO_RECEIVER=? "+
				                                "  where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									            "    and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ";
			                PreparedStatement stmtLinkOSP=con.prepareStatement(sqlUpPRInt);          
	                        stmtLinkOSP.setString(1,woNo);    //out.println("工令號="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 工令號 	                         	          
							stmtLinkOSP.setInt(2,batchId);
							stmtLinkOSP.setString(3,aMFGRCExpTransCode[i][1]); //out.println("流程卡號="+aMFGRCMovingCode[i][1]); // NOTE_TO_RECEIVER = 流程卡號 
                            stmtLinkOSP.executeUpdate();
                            stmtLinkOSP.close();									
						*/	        
							    
							  // 一般委外加工,呼叫REQUISITION IMPORT REQUEST產生PR_起
							    int requestID = 0;
								String devStatus = "";
	                            String devMessage = "";	
							    try
								{   
									 out.println("呼叫Requesition Import Request<BR>");
								     //out.println("userMfgUserID="+userMfgUserID+"<BR>");
								     //out.println("respID="+respID+"<BR>");
								     CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
	                                 cs1.setInt(1,batchId);  //*  Group ID 	
				                     cs1.setString(2,userMfgUserID);    //  user_id 修改人ID /	
				                     cs1.setString(3,respID);  //*  使用的Responsibility ID --> TSC_WIP_Semi_SU /				 
	                                 cs1.registerOutParameter(4, Types.INTEGER); 
									 cs1.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
				                     cs1.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
	                                 cs1.execute();
                                     //out.println("Procedure : Execute Success !!! ");
	                                 requestID = cs1.getInt(4);
									 devStatus = cs1.getString(5);    //  回傳 REQUEST 執行狀況
				                     devMessage = cs1.getString(6);   //  回傳 REQUEST 執行狀況訊息
                                     cs1.close();
								
								} //end of try
                                catch (SQLException e)
                                {
                                 out.println("Exception 呼叫Requesition Import Request:"+e.getMessage());
                                }	
							  // 一般委外加工,呼叫REQUISITION IMPORT REQUEST產生PR_迄
							  con.commit();
							  // java.lang.Thread.sleep(15000);	 // 延遲十五秒,等待Concurrent執行完畢,取結果判斷
							  
							  // 最後再判斷是否一般外包PR 是否順利產生_起
							    // 取批次BatchID
								String  sqlPRError = "select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
								                     "  from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
								                     " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
													 "   and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
													 "   and and a.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
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
								} else {
								        out.println("Success Submit Requisition Import Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)<BR>");
										out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
										String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
										out.println("sqlPRNo ="+sqlPRNo+"<BR>");
										Statement statePRNo=con.createStatement();
                                        ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
	                                    if (rsPRNo.next()) 
								        {  out.println("產生PR號碼="+rsPRNo.getString("SEGMENT1")+"<BR>");
										   PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ");          
	                                       stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No於流程卡檔	                         	          
							               stmtLinkRC.setInt(2,batchId);							               
                                           stmtLinkRC.executeUpdate();
                                           stmtLinkRC.close(); 
										}	
										rsPRNo.close();
										statePRNo.close();						 
								       } // End of else
							    rsPRError.close();
							    statePRError.close();     
							 // 最後再判斷是否一般外包PR 是否順利產生_迄
						 } // 一般外包廠商,系統開至PR完成後,由人員自行開立採購單_迄				  
				         rsJudgeOSP.close();
				         stateJudgeOSP.close();									  
				  
				  
                } //end of try
                catch (Exception e)
                {
                 out.println("Exception 取Routing對應的資源判斷是否為德錫:"+e.getMessage());
                }	  			     	   
			     
			} // 執行更新PR_INTERFACE_迄
			rsOSPInt.close();
			stateOSPInt.close();			    
		//out.println("執行更新PR_INTERFACE_4");			
		// 取出轉請購單(PR_INTERFACE)內資訊並更新其ATTRIBUTE2_迄
		                                // 判斷PO_PR_異常_起
							            Statement stateRQErr=con.createStatement();
							            ResultSet rsRQErr=stateRQErr.executeQuery("select ERROR_MESSAGE, COLUMN_NAME from  PO_INTERFACE_ERRORS "+
							                                                "where INTERFACE_TRANSACTION_ID = (select TRANSACTION_ID from PO_REQUISITIONS_INTERFACE_ALL "+
							                                                                                   "where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									                                                                           "  and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ) ");
						            	if (rsRQErr.next())	
							            {
							              out.println("<font color='#FF0000'>REQ Import Error Message("+rsRQErr.getString(1)+");Error Coulmn("+rsRQErr.getString(2)+")</font>");
							            }
							            rsRQErr.close();
						              	stateRQErr.close();																			   
							            // 判斷PO_PR_異常_迄		
//	} // End of if (getRetScrapCode==0 && getRetCode==0)
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			
		 
        // 若報廢及移站都成功,則更新RUNCARD 資料表相關欄位
//  2006/12/26 liling		if (getRetScrapCode==0 && getRetCode==0 && !errPRImpFlag)
        if ( !errPRImpFlag )
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
	        } else {
	                 operationSeqNum   = "0";
				     operationSeqId    = "0";
				     standardOpId  	  = "0";
				     standardOpDesc   = "0"; 
	                 previousOpSeqNum  = "0"; 
				     nextOpSeqNum	  = "0"; 
					 // 本站即為最後一站,故需更新狀態至 046 (完工入庫)					 
					 Statement stateMax=con.createStatement();
                     ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
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
		   String SqlQueueTrans="insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           "            RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           "            TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           "            TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				           "            CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						   "            LASTUPDATE_DATE, ACTIONID, ACTIONNAME ) "+
				           "     values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,SYSDATE,?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"') ";  						
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
		                " QTY_IN_SCRAP=? , "+
					//	", PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
						" QTY_IN_QUEUE=? "+
		                " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
           PreparedStatement rcStmt=con.prepareStatement(rcSql);
	       //out.print("rcSql="+rcSql);           
	       rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	       rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		   if (!singleOp) // 若本站不為最後站(Routing只有一站會發生此狀況),則維持在 (044) 移站中
		   {
	         rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
	         rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
		   } else { // 否則,即更新至 045 外包收料完工入庫
		            rcStmt.setString(3,"045"); 
	                rcStmt.setString(4,"OSPRECEIVING");
		          }
		   rcStmt.setFloat(5,rcScrapQty); 
/*		   
		   rcStmt.setInt(6,Integer.parseInt(previousOpSeqNum)); 
		   rcStmt.setInt(7,Integer.parseInt(standardOpId));
		   rcStmt.setString(8,standardOpDesc);
		   rcStmt.setInt(9,Integer.parseInt(operationSeqId));
		   rcStmt.setInt(10,Integer.parseInt(operationSeqNum));
		   rcStmt.setInt(11,Integer.parseInt(nextOpSeqNum));
*/		   
		   rcStmt.setFloat(6,Float.parseFloat(aMFGRCExpTransCode[i][2]));  // Transaction Qty
           rcStmt.executeUpdate();   
           rcStmt.close(); 
		   
		 } // end of if (getRetScrapCode==0 && getRetCode==0 && !errPRImpFlag)   
		 else {
		         interfaceErr = true; // 表示移站Interface有異常
				 out.println("報廢、移站或轉PR、PO異常!!! 狀態未更新");
		      } // End of else
			  
		} // end of if (aMFGRCExpTransCode[i][2]>0) // 若設定移站數量大於0才進行移站及報廢   
		 out.print("<font color='#0033CC'>流程卡("+aMFGRCExpTransCode[i][1]+")已投產並委外加工O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	   } // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID等於陣列內容
	  } // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才更新
	      
		   if (jobType.equals("2"))
		   {
	                con.commit();
	                int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);	 // 每作完一筆PR Import延遲五*6秒,等待Concurrent執行完畢,取結果判斷				 
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>6) //若等待時間超過3分鐘則停止作業(設PR Import30秒之內結束)
					  {	    
						//telnetBean_PROD.disconnect(); 
						System.err.println("完成等待PR 產生!!");
						break; 	    
					  }	
					  cc++;					  
					} //enf of while -> 等待迴圈	  
	       } // End of if (jobType.equals("2"))
     } // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
	} // end of if (aMFGRCExpTransCode!=null) 
	
	//out.print("流程卡投產O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");
	
	
	if (!nextOpSeqNum.equals("0") && !interfaceErr) // 若下一站不等於最後一站且Interface無異常
	{
	 %>
	   <script LANGUAGE="JavaScript">
	       alert("流程卡移站中(MOVING)");
	       //reProcessFormConfirm("是否繼續執行此張流程卡移站作業?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	   </script>
	 <%	
	} else { 
	         if (nextOpSeqNum.equals("0") && fromStatusID.equals("042"))
			 {
			   %>
	             <script LANGUAGE="JavaScript">
				   alert("流程卡移至委外加工(045 OSPRECEIVING)");
	               //reProcessQueryConfirm("此流程卡已移至委外加工,繼續執行委外加工採購收料作業?","../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=045&PAGEURL=TSCMfgRunCardOSPReceipt.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	             </script>
	           <%
			   
			 } else {
	                   %>
	                      <script LANGUAGE="JavaScript">
	                        alert("Oracle移站異常..請洽MIS查明原因!!!");
	                      </script>
	                   <%	
					}
	       }
	
	// 使用完畢清空 2維陣列
    if (aMFGRCExpTransCode!=null)
	{ 
	  arrMFGRCExpTransBean.setArray2DString(null); 
	}

}
//MFG流程卡移站中_起	(ACTION=024)  流程卡已展開042->流程卡委外加工中 045  // 如為n站, 即 第一站 --> 第二站 --> 第 n-1 站

  out.println("<BR>");
  getStatusStat.close();
  getStatusRs.close();  
  //pstmt.close();       
  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
   out.println("1"+e.getMessage());
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
      out.println("2"+e.getMessage());
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
      out.println("3"+e.getMessage());
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


