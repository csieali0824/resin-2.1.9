<!--20130301 Liling �ק�S��Ȥ�帹�s�X��h�� TS�����O+�~���+3�X�y���X  -->
<!--20140102 Liling �ק�u��Date Release ���ɶ��� ���00:00:09  -->
<!--20151026 liling add wotype=5 in custlotno  -->
<!--20171115 liling add ON SEMI custlotno  -->
<!--20200506 liling add order line id �g�J�u��attribute  -->
<!--20200506 liling add order line id �g�J�u��attribute1 -->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.util.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<!--=============�H�U�Ϭq���w���{�Ҿ���==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
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
<jsp:useBean id="arrMFG2DWOExpandBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �u�O��ƭn�i�y�{�d�Υ�JWIP interface-->
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d�w�i�}-> �y�{�d������ -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSCMfgWoMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String hostInfo=request.getRequestURL().toString();//REQUEST URL
String mailHost=application.getInitParameter("MAIL_HOST"); //��Server��web.xml�����Xmail server��host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String inspLotNo=request.getParameter("INSPLOTNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//���o�e�@���B�z�����׮ץ�O�_�w��e��FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");
String customerName=request.getParameter("CUSTOMERNAME");	//20171115 liling

// MFG�u�O���_�Ѽư_   
   String woNo=request.getParameter("WO_NO");   //�u�渹
   String runCardCountI=request.getParameter("RUNCARDCOUNTI");   //���i���y�{�d�i��
   String runCardQty=request.getParameter("RUNCARDQTY");        //��i�y�{�d�ƶq
   String runCardCountD=request.getParameter("RUNCARDCOUNTD");  //���i�y�{�d�ƶq
   String dividedFlag=request.getParameter("DIVIDEDFLAG");      //�O�_�Q�㰣 �㰣='Y' ,���Q�㰣���y�{�d�n�h�[�@�i
   String singleControl=request.getParameter("SINGLECONTROL");   //�O�_����山��
   String runCardPrffix=request.getParameter("RUNCARDPREFIX");   //�y�{�d�e�m�X
   
   String custLot=request.getParameter("CUSTLOT");  // �Ȥ�帹�]�w�X 0: �L�]�w, 1:�ݲ��ͫȤ�S��帹 2007/08/13
   String custLotNoPrefix=request.getParameter("CUSTLOT_PREFIX");  // �Ȥ�帹�e�m�X 2007/08/13
   
   String runCardNo=request.getParameter("RUNCARD_NO");   //�y�{�d��
   String custLotNo=request.getParameter("CUSTLOT_NO");   //�Ȥ�帹 2007/08/13
   
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
   
   String directOSP = request.getParameter("DIRECTOSP"); // �w�]�D���벣�Y�~�]��
   if (directOSP==null || directOSP.equals("")) directOSP = "N";

   String runCardCount=String.valueOf(runCardCountI);  //�y�{�d�i��
   //out.print("woNo="+woNo+"<br>");
   //out.print("jobType="+jobType);
      
   if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
// MFG�u�O���_�Ѽƨ�

// 2005/12/03 ��session ��Bean ��������ͺޫ����������N�X // By Kerwin

String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR �~������ƾڿ�J�����P�w
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR �y�{�d�w�i�}-> �y�{�d������

// 2004/07/08 ��session ��Bean �����������覡�����N�X // By Kerwin

//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//�O�_�nSEND MAIL
String adminModeOption=request.getParameter("ADMINMODEOPTION");//�O�_���޲z���Ҧ�1, �ȥͦ� Oracle �u�O, ���i�Ͳ��y�{�d
String adminModeOption2=request.getParameter("ADMINMODEOPTION2");//�O�_���޲z���Ҧ�2 , �Ȯi�y�{�d,���A�ͦ�Oracle �u�O

String oriStatus=null;
String actionName=null;

String dateString="";
String seqkey="";
String seqno="";

// 2007/08/13 �W�[�ͦ��S��Ȥ�帹�ܼ�
String monDayString="";
String custLotSeqkey="";
String custLotSeqno="";
// 2007/08/13 �W�[�ͦ��S��Ȥ�帹�ܼ�

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


String opSupplierLot = ""; // �~�ʫ�q�u�O,�N�t�ӧ帹�g�J�y�{�d��

String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);

      // ���s�J����榡��US�Ҷq,�N�y�t���]������
	   String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
	  //�����s�ɫ�^�_	
	  
	int indxHost = hostInfo.indexOf("8080/");    
    hostInfo = hostInfo.substring(0,indxHost+5);
	  
	 //���WEB�t�θ�T
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
	//���WEB�t�θ�T 
/* 20091112 liling performance
    //����t�Τ��

    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
	if (sd.next())
	{
	   systemDate=sd.getString("SYSTEMDATE");	 
	}
	sd.close();
    statesd.close();	
	*/
	// �������� organization_code �qORG�Ѽ���
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


 java.sql.Date processDateTime = null; //�NSYSDATE�ഫ������榡�H�ť�JAPI�榡
 if (systemDate!=null && systemDate.length()>=8)
 {
   processDateTime = new java.sql.Date(Integer.parseInt(systemDate.substring(0,4))-1900,Integer.parseInt(systemDate.substring(4,6))-1,Integer.parseInt(systemDate.substring(6,8)));  // ��Receiving Date
   String systemTime = dateBean.getHourMinuteSecond();  // ��System Time
   
         Calendar calendar1 = Calendar.getInstance(); 
		 calendar1.set(dateBean.getYear(),dateBean.getMonth(),dateBean.getDay(),dateBean.getHour(), dateBean.getMinute(), dateBean.getSecond() );  // �]�w������榡(�~,��,��,��,��,��)
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
 }    // �o��J�w������..������A
 
   
   java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Ordered Date
   //java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Schedule Ship Date
   //java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Request Date
   java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Pricing Date
   java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Promise Date    
     
   
//String sourceTypeCode = "INTERNAL"; 
   int lineType = 0;  
   
String respID = "50124"; // �w�]�Ȭ� TSC_OM_Semi_SU, �P�_�Y�� Printer Org �h�]�w�� TSC_OM_Printer_SU = 50125

	 
String dateCurrent = dateBean.getYearMonthDay();	
//out.println("fromStatusID="+fromStatusID);


// formID = �򥻸�ƭ��ǨөT�w�`��='TS'
// fromStatusID = �򥻸�ƭ��Ǩ�Hidden �Ѽ�
// actionID = �e�����o�ʧ@ ID( Assign = 003 )
try
{ 
  // ���o����ʧ@�W��_�__ByKerwin 2007/02/04
  Statement getActionName=con.createStatement();  
  ResultSet getActionRs=getActionName.executeQuery("select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID = '"+actionID+"' ");  
  if (getActionRs.next())
  {
    actionName = getActionRs.getString("ACTIONNAME");
  }
  getActionRs.close();
  getActionName.close();
  // ���o����ʧ@�W��_��_ByKerwin 2007/02/04
  
           
  
  // �����o�U�@���A�Ϊ��A�y�z�ç@�y�{���A��s   
  dateString=dateBean.getYearMonthDay();
  
  monDayString=dateBean.getMonthString()+dateBean.getDayString(); // �S��Ȥ�帹�ݨD,�����r��-- Kerwin 2007/08/12
  
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

float accExpandedRCQty = 0;   // 2007/03/26 �֭p�w�i�y�{�d�ƶq,�ˮֳ̫�֭p�w�i�ƬO�_=�u�O��, �p���۵�, �hRollback RUNCARD Table Insert !!!

//MFG�y�{�d�i�} _�_	(ACTION=020)   �u�O040 --> �y�{�d042
if (actionID.equals("020"))  
{ //out.println("Step1");
    String fndUserName = "";  //�B�z�H��
	String woUOM = ""; // �u�O�������
	
	       //���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_	                     
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
	       //���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 

//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  , begin =================
   // try // update by kerwin 2007/03/26
   // {  update by kerwin 2007/03/26
     //======���������

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
			if (startDate==null || startDate.equals("")) startDate=dateBean.getYearMonthDay(); // �Y�u�O�ҥΤ�
	 } else {
	 
	         out.println("���u�O�w�����ΧR��!!!,�лP�u�O�}�ߤH���T�w");
	        }
	 rsa.close();
     statea.close(); 
//out.println("Step2"+startDate);

	  java.sql.Date startdate = null ,enddate=null ;
	  startdate = new java.sql.Date(Integer.parseInt(startDate.substring(0,4))-1900,Integer.parseInt(startDate.substring(4,6))-1,Integer.parseInt(startDate.substring(6,8)));  // ��startDate
	  enddate = new java.sql.Date(Integer.parseInt(endDate.substring(0,4))-1900,Integer.parseInt(endDate.substring(4,6))-1,Integer.parseInt(endDate.substring(6,8)));  // ��endDate


   //���OVERCOMPLETION_TOLERANCE_VALUE
     String sqlvalue = "select ALTERNATE_ROUTING as TOLERANCE_VALUE from YEW_MFG_DEFDATA where DEF_TYPE='TOLERANCE_VALUE'  and CODE= '"+woType+"'  ";	 			 
	  //out.print("sqlvalue="+sqlvalue);
	 Statement statevalue=con.createStatement();
     ResultSet rsvalue=statevalue.executeQuery(sqlvalue);
	 if (rsvalue.next())
	 {
		  	toleranceValue   = rsvalue.getInt(1);   //�W�B���u��v
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
 { // �޲z���Ҧ�2,�Ȯi�}�y�{�d,���A�ͦ�Oracle�u�O(�]�y�{�d�i�}���`:�h�d�Τ֥d,���u�O�w�ͦ�)	
    out.println("<font color='#990000'><strong>�޲z���Ҧ�2(�Ȯi�}�y�{�d,���A�ͦ�Oracle�u�O)���\����!!!</strong></font><BR>");
	woPassFlag = "Y"; // ��w���\�ͦ�Oracle �u�O���ܼƳ]�� Y 
 } 
  else
     { // ���`�Ҧ�,�n�� Descrete Job �� �I�s Mass Load Discrete Procedure ����Oracle�u�O
 
	
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
	 // �ݼзǤu��
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
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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
		 }//end if �Lalternate bill & routing  	
	   if ((altBomDest!=null && !altBomDest.equals("")) && (altRoutingDest==null || altRoutingDest.equals("")))
	     { //out.print("***type2***");
	      //out.print("inSql="+inSql);				
          instmt=con.prepareStatement(sqlbill);     
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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
	      instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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
	       instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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
	       instmt.setString(18,"Rework");	// for non-Standard job ���u�u��
	       instmt.setDate(19,enddate);    		 //LAST_UNIT_COMPLETION_DATE	   
		   instmt.setString(20,defInv);    //completion sub 
	       instmt.setDate(21,enddate);    		 //request due date	
		   instmt.setString(22,toleranceType);   							 //
		   instmt.setInt(23,toleranceValue);	   
           instmt.executeUpdate();
           instmt.close();  	   
		   
	     } // �ݭ��u�u��      	
		
		//java.lang.Thread.sleep(10000);
  }// end of try	  		  
  catch (Exception e)
  {
     out.println("Exception WIP_JOB_SCHEDULE_INTERFACE:"+e.getMessage());
  }	
    
   //���� WIP_MASS_LOAD
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
	           //respID = "50146"; // �䤣��h�w�] --> TSC WIP Super User �w�]
			   respID = "50777"; // �䤣��h�w�] --> YEW WIP Super User �w�]
	         }
			 rsResp.close();
			 stateResp.close();	 	 
	 if (groupId==null || groupId.equals(""))
	 {
	    %>
		<script language="javascript">		
		  alert("�п�JGroupID !!!\n xxx.jsp?GROUPID=xxx");
		</script>
		<%
	 } else {
                 //	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID	
				 CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MASSLOAD_REQUEST(?,?,?,?,?,?)}");			 
	             cs3.setString(1,groupId);  //*  Group ID 	
				 cs3.setString(2,userMfgUserID);    //  user_id �ק�HID /	
				 cs3.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> TSC_INV_Semi_SU /				 
	             cs3.registerOutParameter(4, Types.INTEGER);
				 cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
				 cs3.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
	             int requestID = cs3.getInt(4);
				 devStatus = cs3.getString(5);   //  �^�� REQUEST ���檬�p
				 devMessage = cs3.getString(6);   //  �^�� REQUEST ���檬�p�T��
                 cs3.close();
				 
				con.commit(); // ���W Commit �@��		
				 
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
				 while (rsError.next()) // �s�b ERROR �����
				 { 	      
					   
					   // �p�G���~���T���Q���X,�ݦA�POracle�T�{�O�_�u���u�楼����,�p������,�h�N���ͪ�PassFlag�]�� Y ,���y�{�d���i�i�}
					   String sqlOp = " select WIP_ENTITY_ID from WIP_ENTITIES where WIP_ENTITY_NAME='"+woNo+"' " ;
	                   //out.print("sqlOp �ɤ���������="+sqlOp);
	                   Statement stateOp=con.createStatement();
                       ResultSet rsOp=stateOp.executeQuery(sqlOp);
	                   if (rsOp.next())
	                   {
	             	  	 woPassFlag="Y"; //
						 out.println("<BR><font color='#993366'>�u�O���\�ͦ�!!!</font><BR><font color='RED'>REQUEST ID="+requestID+"</font>");
	                   } else {  
					             // �u���]�S�ͦ��~ Show ���~�T��_�_
					              errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR");
					              out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'> MASS LOAD Transaction fail!! </FONT></TD><TD colspan=1>"+requestID+"</TD></TR>");
				  	              out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>Error Message</FONT></TD><TD colspan=1>"+errorMsg+"</TD></TR>");
								  out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					              woPassFlag="N";
								 // �u���]�S�ͦ��~ Show ���~�T��_��	
					          }
	                   rsOp.close();
                       stateOp.close(); 					   
				  
				 } // End of while 
				 rsError.close();
				 stateError.close();
				 out.println("</TABLE>");
				 if (errorMsg.equals(""))
				 {	
				   out.println("<BR><strong><font color='#993366'>Success Submit WIP_MASSLOAD_REQUEST(�u�O���\�ͦ�!)!!!</font></strong><BR><font color='#3333FF'>RequestID = "+requestID+"</font><BR>");
				   out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   woPassFlag="Y";	// ���\�g�J���X��
				   con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
				 }
                 			 
             } //end of else groupId = null 
	}// end of try
    catch (Exception e)
    {
       out.println("Exception TSC_WIP_MASSLOAD_REQUEST:"+e.getMessage());
    }
 } // End of else if (adminModeOption2!=null && adminModeOption2.equals("YES") && UserRoles.indexOf("admin")>=0) �޲z���Ҧ�2
  

if (adminModeOption!=null && adminModeOption.equals("YES") && ( UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0) )
{ // �޲z���Ҧ�,�ȥͦ�Oracle�u�O,�����i�y�{�d(�]�y�{�d�w�i�}�ç벣���L����)
     out.println("<BR><font color='#FF0000'>�޲z���Ҧ�,�ȥͦ�Oracle�u�O,�����i�y�{�d���\!!!</font><BR>");
	 
	 String woSql="update APPS.YEW_WORKORDER_ALL set RELEASE_DATE=?, RELEASED_BY=?, WO_STATUS=?, STATUSID=?, STATUS=?, WIP_ENTITY_ID=? , DATE_CODE=? ,DC_YYWW=? "+
	             "where WO_NO= '"+woNo+"' "; 	
     PreparedStatement wostmt=con.prepareStatement(woSql);
	 //out.print("woSql="+woSql);        
     wostmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
	 wostmt.setInt(2,Integer.parseInt(userMfgUserID));
	 wostmt.setString(3,"R"); 
	 //wostmt.setString(4,"042"); 
	 //wostmt.setString(5,"�y�{�d�ͦ�"); 
	 wostmt.setString(4,getStatusRs.getString("TOSTATUSID")); 
	 wostmt.setString(5,getStatusRs.getString("STATUSNAME"));
	 wostmt.setInt(6,Integer.parseInt(entityId));	
	 wostmt.setString(7,dateCode);
	 wostmt.setString(8,dc_yyww); //add by Peggy 20220715
     wostmt.executeUpdate();   
     wostmt.close(); 
	 
	 con.commit(); // ���W Commit �@��	
} 
else 
   {   // �_�h,�@�ߥͦ��u�O��ݮi�}�y�{�d 

//out.println("Step1");

       java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.0000"); // ���p�ƫ�|��, �@���p��l�ƪ����
	   java.math.BigDecimal bd = null;  
       java.math.BigDecimal strAccRunCardQty = null;

//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  ,end =================  
//=========�}�l����y�{�dinsert into�@�~ ======================================== 
if (woPassFlag=="Y" || woPassFlag.equals("Y"))   //Job Schedule Interface�n��insert���\�~��y�{�d
{   //out.print("woPassFlag=Y"+"step3"); 
  try
  { //out.print("step4"); out.println("singleControl="+singleControl);
    //out.println("step5="+dividedFlag);
   if (singleControl=="Y" || singleControl.equals("Y")) // �ӥͲ������ݳ��@�~�ި�u�O
   { //out.print("step5");
     //out.print("step1-- "+"dividedFlag="+dividedFlag+"  runCardCountI="+runCardCountI+"<br>");
     if (dividedFlag=="N" || dividedFlag.equals("N"))  // ���i�}�y�{�d
     { //out.print("step7");
	   runCardCountI=Integer.toString(Integer.parseInt(runCardCountI)+1);
       //out.print("step8");   
	 }	

	  String sqlOp = " select a.WIP_ENTITY_ID from WIP_DISCRETE_JOBS a, WIP_ENTITIES b "+
	                 "  where a.WIP_ENTITY_ID=b.WIP_ENTITY_ID and b.WIP_ENTITY_NAME='"+woNo+"' " ;
	 //out.print("sqlOp �ɤ���������="+sqlOp);	
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
	 
	 // 2006/12/01   �����u�O�������T��WIP_OPERATIONS ��T_��
	 
// %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      int b=Integer.parseInt(runCardCountI);   // �i��
	  // 20091109 Marvie Delete : Performance Issue
      //String t[][]=new String[b+2][4];  //�ثe�u���|�� "","WO_NO","RUNCARD_NO","RUNCADQTY"
      
   int i=0,j=0;   
   for (i=0;i<b;i++)
   {  
      // 20091109 Marvie Delete : Performance Issue
	 //  for (j=0;j<4;j++)
	 //  {  	   
              /*============��RUNCARD_NO,�_====================*/
              if (singleControl=="Y" || singleControl.equals("Y"))
              { 
                dateString=dateBean.getYearMonthDay();   
				//seqkey="TS"+userActCenterNo+dateString;  //qcAreaNo
				seqkey=runCardPrffix+"-"+dateString.substring(2,8);  //���~�P�O+����+�~���
                if (classID==null || classID.equals("--")) 
				{
					seqkey=runCardPrffix+"-"+dateString.substring(2,8); // ��~���8�X
				}
                else 
				{
					seqkey=runCardPrffix+"-"+dateString.substring(2,8);     // ��~���8�X�渹   
				}
				if (runCardPrffix.equals("D0") && dateString.substring(2,8).equals("111215"))
				{
					seqkey=runCardPrffix+"-"+"111216";  //���~�P�O+����+�~���
				}				
                //====�����o�y����=====  
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
                  //===(�B�z�������D)�Yrprepair��rpdocseq�Ҧs�b�ۦP�̤j��=========�̭�覡���̤j�� //
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
                      //===========(�B�z�������D)�_�h�H���RUNCARD�ɤ��̤j�y�������ثeRUNCARD��lastno���e(�|�̽s�X�O)
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
                  } // End of Else  //===========(�B�z�������D)
              } // End of Else    
	        //docNo = seqno; // ����쪺���X��������J
	     runCardNo = seqno; // ����쪺���X��������J
	   
	     // 2007/08/12 �w��S��Ȥ�帹,�P�_�Y����q�u�O,�B �ݥͦ��S��Ȥ�帹,�h����_�_
		//   if (woType.equals("3") && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹	
		   if ( (woType.equals("3") || woType.equals("5") )&& !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹		//20151026 liling add type=5   
		   {
		     //20130301
		     //   custLotSeqkey=custLotNoPrefix+monDayString;  //�S��Ȥ�帹+���  
 			     custLotSeqkey=custLotNoPrefix+dateString.substring(2,8);  //�S��Ȥ�帹+�~���  
				 
                //====�����o�y����=====  
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
			      custLotSeqno=custLotSeqkey+"001";  //20130301 CUST LOT �y���X��3�X liling
                  seqstmt.close();                
                } 
                else 
                {
                  int lastno=rs.getInt("LASTNO");
                //  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";				  
                  String sqla1 = "select * from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' and to_number(substr(CUST_LOT_NO,11,2))= '"+lastno+"' ";
                  ResultSet rs2=statement.executeQuery(sqla1); 	
                  //===(�B�z�������D)�Yrprepair��rpdocseq�Ҧs�b�ۦP�̤j��=========�̭�覡���̤j�� //
                  if (rs2.next())
                  {   	     
                    lastno++;
                    String numberString = Integer.toString(lastno);
				 //20130301 CUST LOT �y���X��3�X liling
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
                      //===========(�B�z�������D)�_�h�H���RUNCARD�ɤ��̤j�y�������ثeRUNCARD��lastno���e(�|�̽s�X�O)
                     //20130301 
					 // String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),11,2)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,10)='"+custLotSeqkey+"' ";
                      String sSqlSeq = "select to_number(substr(max(CUST_LOT_NO),10,3)) as LASTNO from APPS.YEW_RUNCARD_ALL where substr(CUST_LOT_NO,1,9)='"+custLotSeqkey+"' ";
					  ResultSet rs3=statement.executeQuery(sSqlSeq);	
	                  if (rs3.next()==true)
	                  {
                       int lastno_r=rs3.getInt("LASTNO");	  
	                   lastno_r++;	  
	                   String numberString_r = Integer.toString(lastno_r);
				    //20130301 CUST LOT �y���X��3�X liling					   
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
                  } // End of Else  //===========(�B�z�������D)
			  }  // End of //====�����o�y����===== 
			  
			  custLotNo = custLotSeqno; // ����쪺���X��������J���S��Ȥ�帹
	    } 	   
	    else // end of if (woType.equals("3") && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹
	       {
		       custLotNo = ""; // ���O�ݩ��q�u�O�B�����w�n���ͯS��帹,�h�S��Ȥ�帹���ŭ�
		   }	
	   // 2007/08/12 �w��S��Ȥ�帹,�P�_�Y����q�u�O,�B �ݥͦ��S��Ȥ�帹,�h����_��
 
	   // 20171115 ON SEMI �S��Ȥ�帹___START	 
	   if ( (woType.equals("3") || woType.equals("5") ) && ( customerName.equals("ON SEMICONDUCTOR") || customerName.equals("ON SEMI")) )// ON SEMI�S��CUST LOTNO
	   //if ( (woType.equals("3") || woType.equals("5") ) )// ON SEMI�S��CUST LOTNO	   
	   {
		   custLotNo = runCardNo.substring(0,2)+dateString.substring(3,8)+runCardNo.substring(runCardNo.length()-3);	
		}	
	    else  
	   {
		   custLotNo = ""; // ���O�ݩ��q�u�O�B�����w�n���ͯS��帹,�h�S��Ȥ�帹���ŭ�
       }				    
	   //  20171115 ON SEMI �S��Ȥ�帹___END   	 
       //out.print("<br>2customerName="+customerName+"*"+"custLotNo="+custLotNo+"*");	   

	   
     } // End of if (singleControl=="Y" || singleControl=="") 	%%%%%%%
//out.println("b="+seqno);

//out.println("runCardNo="+runCardNo);
    //=========�� runcard �渹,��==========================================     
    if ((dividedFlag=="N" || dividedFlag.equals("N"))  && (i==(b-1)))   //�Y���㰣��,�N���i�y�{�d�ƶq���̫�@�i�d�W
    { 
     runCardQty=runCardCountD;
	}   
  // 20091109 Marvie Delete : Performance Issue
//  } // End of for (j=0)

   //=====�ɤ���������,�_====================
   //RUNCARD_ID
  // out.print("�����u�O������Entity_ID="+entityId);	
  try
  { 
     String sqli = " select APPS.YEW_RUNCARD_ALL_S.nextval AS RUNCARD_ID from dual " ;
	 //out.print("sqli �ɤ���������="+sqli);
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
     out.println("Exception ���u�O���͹�����BOM Operation��T:"+e.getMessage());
   }	 
	 		
   //=====����������,��====================	                 
   // $$$$$$$$$$ �̳��@�~�ި�Ͳ������i�}�y�{�d���g�J�y�{�d��ƪ� $$$$$$$$$$$ //	
   int runCardSeq = 0;	
   
  // java.lang.Math mathAbs = new java.lang.Math();  
 
  try
  {		// out.print("RUNCARD�g�J WIP entityId="+entityId);
   float rCardQtyAck = java.lang.Math.abs(Float.parseFloat(runCardQty)); // �P�_�y�{�d�ƬO�_>0
   
   if (rCardQtyAck>0) // 2007/01/27 �קK����=0,�ѧP�_�y�{�d�� > 0 �ɤ~�g�J�y�{�d�D��
   {
   	    
        runCardSeq = i+1;
        out.print("<BR>�y�{�d��"+runCardSeq+"�i,�d��="+runCardNo+" QTY="+java.lang.Math.abs(Float.parseFloat(runCardQty)));		
	    String Sqlrc="insert into APPS.YEW_RUNCARD_ALL(RUNCAD_ID,WO_NO,RUNCARD_NO,PRIMARY_ITEM_ID,INV_ITEM,ITEM_DESC, "+
				     "            RUNCARD_STATUS,QTY_IN_QUEUE,CREATE_BY,CREATION_DATE,STATUSID,STATUS,DEPT_NO,ORGANIZATION_ID,WIP_ENTITY_ID, "+
				     "            OPERATION_SEQ_NUM,OPERATION_SEQ_ID,STANDARD_OP_ID,STANDARD_OP_DESC,NEXT_OP_SEQ_NUM, PREVIOUS_OP_SEQ_NUM, RUNCARD_QTY, ROUTING_REFERENCE_ID , LINE_NUM, WEB_SYSID, SUPPLIER_LOT_NO, CUST_LOT_NO,RC_DATE_CODE,DC_YYWW)   "+  //20091123 liling �[ RC_DATE_CODE
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
	    //seqstmt.setString(12,"�y�{�d�ͦ�"); 
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
	 	seqstmt.setString(27,custLotNo); // 2007/08/13 �̤u�O���w�O�_�t�X���ͫȤ�S��帹
		seqstmt.setString(28,dateCode);   //20091123 �i�d�g�JDATE CODE 
		seqstmt.setString(29,dc_yyww);    //20220715 by Peggy
        seqstmt.executeUpdate();
        seqstmt.close();   	
	
        // Error1. YEW_RUNCARD_ALL �S��Release_date���������,Liling �˿��F,�󥿬� APPS.YEW_WORKORDER_ALL 
        String woSql="update APPS.YEW_WORKORDER_ALL set RELEASE_DATE=?, RELEASED_BY=?, WO_STATUS=?, STATUSID=?, STATUS=?, WIP_ENTITY_ID=? , DATE_CODE=?,DC_YYWW=? "+  
	                 "where WO_NO= '"+woNo+"' "; 	
        PreparedStatement wostmt=con.prepareStatement(woSql);
	    //out.print("woSql="+woSql);        
        wostmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
	    wostmt.setInt(2,Integer.parseInt(userMfgUserID));
	    wostmt.setString(3,"R"); 
	    //wostmt.setString(4,"042"); 
	    //wostmt.setString(5,"�y�{�d�ͦ�"); 
	    wostmt.setString(4,getStatusRs.getString("TOSTATUSID")); 
	    wostmt.setString(5,getStatusRs.getString("STATUSNAME"));
	    wostmt.setInt(6,Integer.parseInt(entityId));	
	    wostmt.setString(7,dateCode);
	    wostmt.setString(8,dc_yyww);  //add by Peggy 20220715
        wostmt.executeUpdate();   
        wostmt.close(); 
		
		 // %%%%%%%%%%%%%%%%%%% �g�JRun card Transaction %%%%%%%%%%%%%%%%%%%_�_ 	
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
           queueTransStmt.setInt(6,Integer.parseInt(operationSeqNum));          //FM_OPERATION_SEQ_NUM(����)    
		   queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           queueTransStmt.setInt(8,Integer.parseInt(nextOpSeqNum));             //TO_OPERATION_SEQ_NUM(�U�@��) 
	       queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
	       queueTransStmt.setFloat(10,java.lang.Math.abs(Float.parseFloat(runCardQty)));  // Transaction Qty
	       queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       queueTransStmt.setInt(12,1);             // 1=Queue		  
	       queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       queueTransStmt.setString(15,"040");      // From StatusId (CREATING)
		   queueTransStmt.setString(16,"CREATING");	  // From STATUS
		   queueTransStmt.setString(17,fndUserName);	  // Update User 
		   queueTransStmt.setFloat(18,0);
           queueTransStmt.executeUpdate();
           queueTransStmt.close();	    	 
		 
		 // %%%%%%%%%%%%%%%%%%% �g�JRun card Transaction %%%%%%%%%%%%%%%%%%%_�� 	
		 
		 accExpandedRCQty = accExpandedRCQty + java.lang.Math.abs(Float.parseFloat(runCardQty)); //  �֥[�w�i�y�{�d��... By Kerwin 2007/03/26
		 	
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
     } // if (rCardQtyAck>0) // 2007/01/27 �קK����=0,�ѧP�_�y�{�d�� > 0 �ɤ~�g�J�y�{�d�D��
	 
   }// end of try
   catch (Exception e)
   {
     out.println("Exception ���@�~�ި�g�J�y�{�d:"+e.getMessage());
   }	
	   //out.print("Runcard no="+runCardNo+"    Qty="+runCardQty+"<br>");
  }// End of for (i=0)   
  

 } //end if (singleControl=="Y" || singleControl.equals("Y"))
 else  
 {  
  
  // ���̳��@�~�ި�q�Ͳ����y�{�d_�_  

   //out.print("<br>TTTTTT runCardNo="+runCardNo+"  "+woQty+"<br>"); 
    //  runCardNo=runCardNo.substring(0,9)+"-"+runCardNo.substring(9,12); // �����@�i�u�O�������ͤ@�i�y�{�d
   if (alternateRouting!=null && alternateRouting.equals("2"))
   { // �~�ʤu�O  ###############################################3   
   
        runCardNo=woNo.substring(0,9)+"-"+woNo.substring(9,12); // �����@�i�u�O�������ͤ@�i�y�{�d   
        
        String sqlRC = " select * from YEW_RUNCARD_ALL where RUNCARD_NO = '"+runCardNo+"' " ;
	    Statement stateRC=con.createStatement();
		ResultSet rsRC=stateRC.executeQuery(sqlRC);
		if (!rsRC.next())
		{ // �Y�y�{�d���s�b,�h�i�Τu�O��-�y�{�d�Ǹ�	�@���~�ʬy�{�d��   
		   out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>");  
		} else { 
		         // �_�h,�̫e�m�X��̤j�y�{�d��_�_
		            //====�����o�y����=====  
					seqkey=woNo.substring(0,9); // �u�O�̤j��
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
                       //===(�B�z�������D)�Yrprepair��rpdocseq�Ҧs�b�ۦP�̤j��=========�̭�覡���̤j�� //
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
                           //===========(�B�z�������D)�_�h�H���RUNCARD�ɤ��̤j�y�������ثeRUNCARD��lastno���e(�|�̽s�X�O)
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
                        } // End of Else  //===========(�B�z�������D)
                    } // End of Else  					
					runCardNo=seqno; // ����쪺����̤j�y�{�d�������i�~�ʬy�{�d��
					out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>"); 
					%>
					   <script language="jscript">
					      alert("���i�~�ʤu�O�y�{�d���w�Q�䥦�u�O�ϥ�\n�N�H����̤j���@���y�{�d��!!!");
					   </script> 
					<%
				    // �_�h,�̫e�m�X��̤j�y�{�d��_��
		        } // End of else(���X�w�Q�䥦�@��u�O�Ҩϥ�)  
		rsRC.close();
		stateRC.close();
		
		// 2007/08/13  �w���q�u�O,�P�_�Y���w���ͯS��Ȥ�帹�h���X�帹_�_
		//if (woType.equals("3") && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹
		if ((woType.equals("3")||woType.equals("5")) && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹	//20151026 liling add type=5
		{
		            custLotSeqkey=custLotNoPrefix+monDayString; // ����e�m�Ȥ�S��帹
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
                       //===(�B�z�������D)�Yrprepair��rpdocseq�Ҧs�b�ۦP�̤j��=========�̭�覡���̤j�� //
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
                           //===========(�B�z�������D)�_�h�H���RUNCARD�ɤ��̤j�y�������ثeRUNCARD��lastno���e(�|�̽s�X�O)
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
                        } // End of Else  //===========(�B�z�������D)
                    } // End of Else  					
					custLotNo=custLotSeqno; // ����쪺����̤j�Ȥ�S��帹�����i�~�ʤu�O�S��Ȥ�帹
		} // End of if (woType.equals("3") && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹
		else {
			       custLotNo= ""; // �Y�D��q�Υ������n���S��Ȥ�帹,�h���ŭ�
			 }
        // 2007/08/13  �w���q�u�O,�P�_�Y���w���ͯS��Ȥ�帹�h���X�帹_��
   }
   else { // ��L�@��ۻs�u�O,��i�y�{�d�H�y�{�d���P�u�O���h -  ########################################3
          runCardNo=woNo.substring(0,9)+"-"+woNo.substring(9,12); // �����@�i�u�O�������ͤ@�i�y�{�d		  
          out.print("<br>runCardNo="+runCardNo+"  QTY="+woQty+"<br>"); 
		   // 2007/08/13  �w���q�u�O,�P�_�Y���w���ͯS��Ȥ�帹�h���X�帹_�_
		  // if (woType.equals("3") && !custLot.equals("0"))  // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹
		   if ((woType.equals("3")||woType.equals("5")) && !custLot.equals("0"))  // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹		 //20151026 liling add type=5  
	   	   {
		            custLotSeqkey=custLotNoPrefix+monDayString; // ����e�m�Ȥ�S��帹
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
                       //===(�B�z�������D)�Yrprepair��rpdocseq�Ҧs�b�ۦP�̤j��=========�̭�覡���̤j�� //
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
                           //===========(�B�z�������D)�_�h�H���RUNCARD�ɤ��̤j�y�������ثeRUNCARD��lastno���e(�|�̽s�X�O)
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
                        } // End of Else  //===========(�B�z�������D)
                    } // End of Else  					
					custLotNo=custLotSeqno; // ����쪺����̤j�Ȥ�S��帹�����i�ۻs�u�O�S��Ȥ�帹
		    } // End of if (woType.equals("3") && !custLot.equals("0")) // 0��O�@��Ȥ�, �D0�i�w�q�h���S��Ȥ�帹
			else {
			       custLotNo= ""; // �Y�D��q�Υ������n���S��Ȥ�帹,�h���ŭ�
			     }
            // 2007/08/13  �w���q�u�O,�P�_�Y���w���ͯS��Ȥ�帹�h���X�帹_��
        } // end of else
   //=====�ɤ���������,�_====================
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


  try // ���̳��@�~�ި�q�Ͳ����y�{�d ******** �����@�i�u�O���ͤ@�i�y�{�d;
  {	// �g�J�y�{�d�D��	
  
   if (operationSeqNum  == null || operationSeqNum.equals(""))   operationSeqNum="0";
   if (operationSeqId   == null || operationSeqId.equals(""))     operationSeqId="0";
   if (standardOpId     == null || standardOpId.equals(""))         standardOpId="0";
   if (nextOpSeqNum     == null || nextOpSeqNum.equals(""))         nextOpSeqNum="0";
   if (previousOpSeqNum == null || previousOpSeqNum.equals("")) previousOpSeqNum="0";  

    //out.print("step6<BR>");		
	String Sqlrc="insert into APPS.YEW_RUNCARD_ALL(RUNCAD_ID,WO_NO,RUNCARD_NO,PRIMARY_ITEM_ID,INV_ITEM,ITEM_DESC, "+
				 "            RUNCARD_STATUS,QTY_IN_QUEUE,CREATE_BY,CREATION_DATE,STATUSID,STATUS,DEPT_NO,ORGANIZATION_ID,WIP_ENTITY_ID, "+
				 "            OPERATION_SEQ_NUM,OPERATION_SEQ_ID,STANDARD_OP_ID,STANDARD_OP_DESC,NEXT_OP_SEQ_NUM, PREVIOUS_OP_SEQ_NUM, RUNCARD_QTY, ROUTING_REFERENCE_ID,LINE_NUM,WEB_SYSID, SUPPLIER_LOT_NO, CUST_LOT_NO,RC_DATE_CODE,DC_YYWW)   "+  //20091123 liling �[ RC_DATE_CODE
				 "     values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";   
    PreparedStatement seqstmt=con.prepareStatement(Sqlrc); 
    seqstmt.setString(1,runCardId);
    seqstmt.setString(2,woNo);
	seqstmt.setString(3,runCardNo); 
	seqstmt.setString(4,itemId);
    seqstmt.setString(5,invItem);
	seqstmt.setString(6,itemDesc); 
	seqstmt.setString(7,"O");      //runcaard status O=Open
    seqstmt.setFloat(8,java.lang.Math.abs(Float.parseFloat(woQty)));    //������山�ު��ƶq���u�O�ƶq
	seqstmt.setString(9,userMfgUserID); 
	seqstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //creation date
    //seqstmt.setString(11,"042");
	//seqstmt.setString(12,"�y�{�d�ͦ�"); 
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
	seqstmt.setString(27,custLotNo); // 2007/08/13 �̫Ȥ�S��帹�����ͪ��Ȥ�帹
    seqstmt.setString(28,dateCode);  //20091123 liling �[ RC_DATE_CODE
    seqstmt.setString(29,dc_yyww);   //20220715 by Peggy 
    seqstmt.executeUpdate();
    seqstmt.close();   	
	
	      // %%%%%%%%%%%%%%%%%%% �g�JRun card Transaction %%%%%%%%%%%%%%%%%%%_�_ 	
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
           queueTransStmt.setInt(6,Integer.parseInt(operationSeqNum));          //FM_OPERATION_SEQ_NUM(����)    
		   queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           queueTransStmt.setInt(8,Integer.parseInt(nextOpSeqNum));             //TO_OPERATION_SEQ_NUM(�U�@��) 
	       queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
	       queueTransStmt.setFloat(10,java.lang.Math.abs(Float.parseFloat(woQty)));  // Transaction Qty
	       queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       queueTransStmt.setInt(12,1);             // 1=Queue		  
	       queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       queueTransStmt.setString(15,"040");      // From StatusId (CREATING)
		   queueTransStmt.setString(16,"CREATING");	  // From STATUS
		   queueTransStmt.setString(17,fndUserName);	  // Update User 
		   queueTransStmt.setFloat(18,0);
           queueTransStmt.executeUpdate();
           queueTransStmt.close();	    	 
		 
		 // %%%%%%%%%%%%%%%%%%% �g�JRun card Transaction %%%%%%%%%%%%%%%%%%%_�� 
	
	//out.print("Runcard no="+runCardNo+"    Qty="+woQty+"<br>");
    // Error1. YEW_RUNCARD_ALL �S��Release_date���������,Liling �˿��F,�󥿬� APPS.YEW_WORKORDER_ALL 
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
	
	
	// ----------------- By Kerwin �ˮ֤w�i�}���d�O�_�w�g=�u�O�ƶq
	accExpandedRCQty = accExpandedRCQty + java.lang.Math.abs(Float.parseFloat(woQty)); //  �֥[�w�i�y�{�d��... By Kerwin 2007/03/26
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
  // ���̳��@�~�ި�q�Ͳ����y�{�d_�� 
 }// end of try
 catch (Exception e)
 {
     out.println("Exception 6:"+e.getMessage());
 }  

 }	//end of  woPassflag (if (woPassflag.equals("Y"))

} // End of if not (adminModeOption!=null && adminModeOption.equals("YES") && UserRole.equals("admin"))

    //out.print("�y�{�d�i�}O.K.("+entityId+")");	
	
  //out.println("accExpandedRCQty="+accExpandedRCQty);
  //out.println("runCardQty="+runCardQty);	
  
 if (accExpandedRCQty != Float.parseFloat(woQty))  // �p�G�P�_�֭p�w�i�d�� ������ �u�O�� , ��ܦ����i�d�t�����`,���F Rollback Runcard 
 { out.println("accExpandedRCQty="+accExpandedRCQty);
   
     con.rollback();   // ���^�h��~�g�J���y�{�d��,�y�{�d���ʾ��{��
   
               %>
 	             <script LANGUAGE="JavaScript">
				   alert("�y�{�d�i�}���`,�֭p�y�{�d�`��(<%=accExpandedRCQty%>)������u�O��(<%=Float.parseFloat(woQty)%>)\n                 �����ͬy�{�d�D��!!!");
				   alert("�гq���޲z��,�H�޲z���Ҧ���U�i�}�y�{�d!!!");
	               //reProcessQueryConfirm("���y�{�d�w���ܩe�~�[�u,�~�����e�~�[�u���ʦ��Ƨ@�~?","../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=045&PAGEURL=TSCMfgRunCardOSPReceipt.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	             </script>
	           <%
 } else { 	
                                boolean wipNameCreated = false;
                                // �P�_�pOracle �u�O�w�s�b�P���i�Ͳ��t�Τu�O���@�P, �h��ܦ����w�ͦ�Oracle�u�O,�����ݥѺ޲z������޲z���Ҧ�2�Ȯi�}�y�{�d
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
             if (wipNameCreated==false) // �P�_�YOracle�u�O���ͦ�
             {
			    out.print("<BR><font color='#0033CC'>�]Oracle�u�O���s�b,Rollback �y�{�d�i�}.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")<BR> �H�W�y�{�d���g�J�D�� !!!</font>");
			    con.rollback();   // ���^�h��~�g�J���y�{�d��,�y�{�d���ʾ��{�� ,�YOracle�u�O���ͦ�
             } else {
	                  out.print("<BR><font color='#0033CC'>�y�{�d�i�}O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
					}  
	    } // End of else
	
    // �ϥΧ����M�� 2���}�C
    if (aMFGWoExpandCode!=null)
	{ 
	  arrMFG2DWOExpandBean.setArray2DString(null); 
	} 
 
}  //END OF 020_ACTION IF  
//�y�{�d�i�})_��	(ACTION=020)  

//MFG�y�{�d�벣�����e�~�[�u_�_	(ACTION=024)  �y�{�d�w�i�}042->�y�{�d�e�~�[�u�� 045
if (actionID.equals("024") && fromStatusID.equals("042"))   // �p��n��, �Y �Ĥ@��(�e�~�[�u��) --> �ĤG�� --> �� n-1 ��
{   //out.println("fromStatusID="+fromStatusID);
    String fndUserName = "";  //�B�z�H��
	String woUOM = ""; // �u�O�������
	int primaryItemID = 0; // �Ƹ�ID
	entityId = "0"; // �u�Owip_entity_id
	boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
    if (aMFGRCExpTransCode!=null)
	{	  
	  if (aMFGRCExpTransCode.length>0)
	  {    
	       //���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_
	                     
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
	       //���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 
		   
		   //��������ƶq�����_�_	                     
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
	       //��������ƶq�����_��   
	  
	  } // End of if (aMFGRCExpTransCode.length>0)  
	  
	  
	  for (int i=0;i<aMFGRCExpTransCode.length-1;i++)
	  {
	   for (int k=0;k<=choice.length-1;k++)    
       { //out.println("choice[k]="+choice[k]);  
	    // �P�_�QCheck ��Line �~��������@�~
	    if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RUNCARD_ID = �}�C���e
	    { //out.println("aMFGRCExpTransCode[i][0]="+aMFGRCExpTransCode[i][0]);	   
          //out.print("woNo2="+woNo+"<br>");

		  if (Float.parseFloat(aMFGRCExpTransCode[i][2])>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
		  {
	  
		   int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   if (aMFGRCExpTransCode[i][5]==null || aMFGRCExpTransCode[i][5]=="0" || aMFGRCExpTransCode[i][5].equals("0")) 
		   { // �Y�L�U�@���Ǹ�,�h��ܥ����Y���̲ׯ�,�����ʧ@�]�w�����u
		    // out.println("Last Operation");
		     toIntOpSType = 3;   //
		     aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // �L�U�@����Seq No,�G������
			 transType = 1; //(���u�ѤJ�w��۰ʰ���,�G���]��1)
		   }  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)
/* 2006/12/26 liling			   
		   //����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
		   float  rcMQty = 0;   
		   float  rcScrapQty = 0;     
		   java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 
		               
						 String sqlMQty = " select b.QTY_IN_QUEUE from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 									     " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "   and b.RUNCARD_NO='"+aMFGRCExpTransCode[i][1]+"' ";
						 Statement stateMQty=con.createStatement();
                         ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						 if (rsMQty.next())
						 {
						   if (aMFGRCExpTransCode[i][2]==null || aMFGRCExpTransCode[i][2].equals("null")) aMFGRCExpTransCode[i][2]=Float.toString(rcMQty);
						   rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		//��미�ƶq			
						   rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
						   
						    String strScrapQty = nf.format(rcScrapQty);
							java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
							java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							rcScrapQty =scrapQty.floatValue();
							
							//out.println("java�|�ˤ��J����p�ƤT��rcScrapQty="+rcScrapQty+"<BR>");
						 }
						 rsMQty.close();
						 stateMQty.close();
	       //��������ƶq�����,�íp�⥻�����o�ƶq_��
		   
		 String getErrScrapBuffer = "";
		 int getRetScrapCode = 0;   
		 if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���oInterface
		 {		 
		   // �������o Scrap Account ID_�_// ��Organization_id ���w�]�� Scrap Acc ID
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
		   // �������o Scrap Account ID_��
		 
		   // *****%%%%%%%%%%%%%% �������o�ƶq %%%%%%%%%%%%**********  �_
		   toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
		   transType = 1; // ���o��Transaction Type = 1(Move Transaction)
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
		   scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�������o�ƶq="+rcScrapQty+"<BR>");// �������o�ƶq	       	   
           scrapstmt.setString(8,woUOM);
	       scrapstmt.setInt(9,Integer.parseInt(entityId));  
	       scrapstmt.setString(10,woNo);  
	       scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
		   //seqstmt.setInt(12,20);
	       scrapstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(����)		  
	       scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       scrapstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][4])); // TO_OPERATION_SEQ_NUM  //���o�Y��From = To
	       scrapstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
		   scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)���o ( 01-11-000-7650-951-0-000 ) 
		   scrapstmt.setInt(18,7);	// REASON_ID  �s�{���` 
           scrapstmt.executeUpdate();
           scrapstmt.close();	      	
		   
		   //����g�JInterface��Group����T_�_
	       int groupID = 0;
		   int opSeqNo = 0;              
						String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
										 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
										 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // ���������o
						Statement stateGrp=con.createStatement();
                        ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						if (rsGrp.next())
						{
						   groupID = rsGrp.getInt("GROUP_ID");
						   opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						}
						rsGrp.close();
						stateGrp.close();
	     //����g�JInterface��Group����T_��  		
		 out.println("<BR>���o��groupID ="+groupID+"<BR>");
		 
		 if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 {
		   // �Y�ɩI�s WIP_MOVE PROCESS WORKER		  
		   int procPhase = 1;
		   int timeOut = 10;
		   try
		   {	
		             /*
						  CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
						  cs5.registerOutParameter(1, Types.VARCHAR); //  �Ǧ^��        ERROR BUFFER
						  cs5.registerOutParameter(2, Types.INTEGER); //  �Ǧ^��		RETURN CODE				   
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
			              cs5.registerOutParameter(4, Types.VARCHAR); //  �Ǧ^��     STATUS
			              cs5.registerOutParameter(5, Types.VARCHAR); //  �Ǧ^��		ERROR MESSAGE					 					      						   	 					     
			              cs5.execute();					      
			              String getMoveStatus = cs5.getString(4);		
			              String getMoveErrorMsg = cs5.getString(5);								      				    
			              cs5.close();						  
						  if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  {
						     getRetScrapCode = 77;   // Error Number  
							 getErrScrapBuffer = getMoveErrorMsg; // ����~�T������ӧP�_��Buffer
						  }						  					  
						  out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"���o���~��]="+getErrScrapBuffer+"<BR>");
				     /*		  
						  if (getRetScrapCode>0)
						  {
						            String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
									                   "where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
								    Statement stateTxnMsg=con.createStatement();
						            ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
						            if (rsTxnMsg.next())  // �Y�s�b,��ܦ����~�T��,�������\�g
									{
									  getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
									}
						            rsTxnMsg.close();
									stateTxnMsg.close(); 
						  }		
						  // ����,�T�����ǽT,�ݦA�P�_�O�_MOVE_TRANSACTION�̬y�{�d�O�_���T�H�Q�g�J,�p�w�g�J,�h�����楿�`�����@�~ //_�_  
						  String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
 									         " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+
											 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' "+
											 "   and PRIMARY_QUANTITY = "+rcScrapQty+"  "+  // ���o��
										     "   and TO_INTRAOPERATION_STEP_TYPE = 5 and GROUP_ID="+groupID+" ";   // ���������o
						  Statement stateGrpMsg=con.createStatement();
						  ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
						  if (rsGrpMsg.next())  // �Y�s�b,��ܦ����~�T��,�������\�g�JMove Transaction, ��getRetScrapCode = 0
						  {
						    getRetScrapCode = 0; 
							if (getErrScrapBuffer!=null && !getErrScrapBuffer.equals("null")) out.println("�t���~�T��,�����\�g�J���o��Interface!!!");
						  } else {
						           
						         }
						  rsGrpMsg.close();
						  stateGrpMsg.close();
						  // ����,�T�����ǽT,�ݦA�P�_�O�_MOVE_TRANSACTION�̬y�{�d�O�_���T�H�Q�g�J,�p�w�g�J,�h�����楿�`�����@�~ //_�� 
				    */
/* 2006/12/26 liling
			}	  
			catch (Exception e) { out.println("Exception���o��groupID:"+e.getMessage()); }  
		  } // end of if (groupID>0 && opSeqNo>0)			 
		 // *****%%%%%%%%%%%%%% �������o�ƶq�ƶq  %%%%%%%%%%%%**********  ��
		 
		} // End of if (rcScrapQty>0)
				 
		String getErrBuffer = "";
		int getRetCode = 0;		         
		if (getRetScrapCode==0) // �Y����P�@�����o���\,�~���沾�U�@���ʧ@_�_
		{  
		   //toIntOpSType = 1;  // ������to InterOperation Step Type = 1 
		   // *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  �_
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
		   seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // �����ƶq
	       //seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
		   //out.println("�ƶq="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
           seqstmt.setString(8,woUOM);
	       seqstmt.setInt(9,Integer.parseInt(entityId));  
	       seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
	       seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP  //liling
		   //seqstmt.setInt(12,20);
	       seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
		   //out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
	       seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
		   seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
           seqstmt.executeUpdate();
           seqstmt.close();	      	
		   
		   //����g�JInterface��Group����T_�_
	       int groupID = 0;
		   int opSeqNo = 0;              
						String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
										 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
										 "   and TO_INTRAOPERATION_STEP_TYPE in (1, 3) "; // ������������Group ID
						 Statement stateGrp=con.createStatement();
                         ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 if (rsGrp.next())
						 {
						   groupID = rsGrp.getInt("GROUP_ID");
						   opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 }
						 rsGrp.close();
						 stateGrp.close();
	     //����g�J����Interface��Group����T_��
		 out.println("<BR>������groupID ="+groupID+"<BR>");
		
		 if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 {
		   // �Y�ɩI�s WIP_MOVE PROCESS WORKER
		   
		   int procPhase = 1;
		   int timeOut = 10;
		   try
		   {	
		               /*
						  CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  �Ǧ^��        ERROR BUFFER
						  cs4.registerOutParameter(2, Types.INTEGER); //  �Ǧ^��		RETURN CODE				   
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
			              cs4.registerOutParameter(4, Types.VARCHAR); //  �Ǧ^��     STATUS
			              cs4.registerOutParameter(5, Types.VARCHAR); //  �Ǧ^��		ERROR MESSAGE					 					      						   	 					     
			              cs4.execute();					      
			              String getMoveStatus = cs4.getString(4);		
			              String getMoveErrorMsg = cs4.getString(5);								      				    
			              cs4.close();							  
						  if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  {
						     getRetCode = 88;   // Error Number  
							 getErrBuffer = getMoveErrorMsg; // ����~�T������ӧP�_��Buffer
						  }							  
						  out.println("getRetCode="+getRetCode+"&nbsp;"+"�������~��]="+getErrBuffer+"<BR>");
					  /*	  
						  if (getRetCode>0)
						  {
						            String sqlTxnMsg = "select ERROR_MESSAGE, ERROR_COLUMN from WIP_TXN_INTERFACE_ERRORS "+
									                   "where TRANSACTION_ID=(select TRANSACTION_ID from WIP_MOVE_TXN_INTERFACE where GROUP_ID= "+groupID+") ";
								    Statement stateTxnMsg=con.createStatement();
						            ResultSet rsTxnMsg=stateTxnMsg.executeQuery(sqlTxnMsg);
						            if (rsTxnMsg.next())  // �Y�s�b,��ܦ����~�T��,�������\�g
									{
									  getErrScrapBuffer = getErrScrapBuffer+"("+rsTxnMsg.getString(1)+")"+"Error Column("+rsTxnMsg.getString(2)+")";
									}
						            rsTxnMsg.close();
									stateTxnMsg.close(); 
						  }		
						  // ����,�T�����ǽT,�ݦA�P�_�O�_MOVE_TRANSACTION�̬y�{�d�O�_���T�H�Q�g�J,�p�w�g�J,�h�����楿�`�����@�~ //_�_  
						  String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
 									         " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+
											 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' "+
											 "   and PRIMARY_QUANTITY = "+Float.parseFloat(aMFGRCExpTransCode[i][2])+"  "+  // ������
										     "   and TO_INTRAOPERATION_STEP_TYPE in (1, 3) and  GROUP_ID = "+groupID+" ";   // ����������
						  Statement stateGrpMsg=con.createStatement();
						  ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
						  if (rsGrpMsg.next())  // �Y�s�b,��ܦ����~�T��,�������\�g�JMove Transaction, ��getRetScrapCode = 0
						  {
						    getRetCode = 0; 
							if (getErrBuffer!=null && !getErrBuffer.equals("null")) out.println("�t���~�T��,�����\�g�J������Interface!!!");
						  } else {
						           
						         }
						  rsGrpMsg.close();
						  stateGrpMsg.close();
						  // ����,�T�����ǽT,�ݦA�P�_�O�_MOVE_TRANSACTION�̬y�{�d�O�_���T�H�Q�g�J,�p�w�g�J,�h�����楿�`�����@�~ //_��			  	  
					   */
/* 2006/12/26 liling
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		  } // end of if (groupID>0 && opSeqNo>0)			 
		 // *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  ��
		 
		} // End of if (getRetScrapCode=0) 	
*/ //2006/12/26 liling	 

	
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@		
    boolean errPRImpFlag = false; // �w��D�w��,PR Requisition Import���ͪ����~�P�_
    int getRetScrapCode = 0,getRetCode=0,rcScrapQty=0;
//	if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����PR Interface���ʧ�s
//	{ 	
       // out.println("�����sPR_INTERFACE_0");
		 //�����o�����沣��PO��Responsibility ID_�_
	     Statement stateResp=con.createStatement();	   
	     ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME = 'YEW_WIP_SEMI_SU' "); 
	     if (rsResp.next())
	     {
	       respID = rsResp.getString("RESPONSIBILITY_ID");
	     } else {
	              respID = "50777"; // �䤣��h�w�] --> YEW WIP Super User �w�]
	            }
			    rsResp.close();
			    stateResp.close();	  	
	     //�����o�����沣��PO��Responsibility ID_��
		    // ���X����ʳ�(PR_INTERFACE)����T�ç�s��ATTRIBUTE2_�_
		    //out.println("�����sPR_INTERFACE_1");
			boolean oddOSPFlag = false;  // �w��w��,�ݯS�O�B�zInterface			
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
			{   //out.println("�����sPR_INTERFACE_2");
			    try
				{
			      String sqlJudgeOSP ="";
				  if (jobType==null || jobType.equals("1"))
				  {
				         sqlJudgeOSP =" select b.DESCRIPTION, b.RESOURCE_CODE, b.COST_CODE_TYPE "+
                                      " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, "+
					                  "      BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d, APPS.YEW_RUNCARD_ALL e "+
                                      " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					                  // "   and b.ORGANIZATION_ID = '"+organizationID+"' "+ // Update 2006/11/08 �]���귽��Organization,����L����
									  "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					                  "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					                  "   and d.OPERATION_SEQ_NUM = e.NEXT_OP_SEQ_NUM "+ //e.NEXT_OP_SEQ_NUM "+
									  "   and e.RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' "+
									  "   and a.OPERATION_SEQUENCE_ID = e.NEXT_OP_SEQ_ID "+
					                  "   and b.COST_CODE_TYPE = 4 "+ // ���~�]
									  "   and ( b.DESCRIPTION like '%�w��%' or b.RESOURCE_CODE like '%DA%') "; // �Ȯɨϥ�Description �P�_�O�_�n���ͤw�֭�PR,�_�h���bInterface
				  } else {
				          sqlJudgeOSP = " select DISTINCT d.DESCRIPTION, d.RESOURCE_CODE, d.COST_CODE_TYPE "+        			              
					                    "   from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									    "        BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									    "  where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									    "    and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // �]�����u�u�O�i��LBOM��
										"    and b.RESOURCE_ID = d.RESOURCE_ID "+
										//"    and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+ // �u���@��,�]���벣���Y�����u��(2006/11/22)
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
				  if (rsJudgeOSP.next()) //  �P�_�Y�s�{�~�]�����w��,�h�ݥt��sInterface��Suggested Vendor ID, Suggested Vendor Site ID��
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
				    
				    // �Y�O���H�w����ަ������q ,�ʺA���X��VNEDOR_ID �Ψ�SITE_ID_�_
				    int dexiVendorID = 0;
				    int dexiVndSiteID = 0;
				    Statement stateDEXI=con.createStatement();
                    ResultSet rsDEXI=stateDEXI.executeQuery("select a.VENDOR_ID, b.VENDOR_SITE_ID from po_vendors a, po_vendor_sites_all b where a.VENDOR_ID = b.VENDOR_ID and trim(a.VENDOR_NAME) = '���H�w����ަ������q' ");
				    if (rsDEXI.next())
				    {
				      dexiVendorID = rsDEXI.getInt(1);
					  dexiVndSiteID = rsDEXI.getInt(2); 
				    }
				    rsDEXI.close();
				    stateDEXI.close();
				    // �Y�O���H�w����ަ������q ,�ʺA���X��VNEDOR_ID �Ψ�SITE_ID_��					
					
					//out.print("dexiVendorID="+dexiVendorID+"  "+dexiVndSiteID);
					oddOSPFlag = true;	
					out.println("�w���~�]�g�JPR Interface,����REQ IMP����<BR>");
				 
					
					String sqlUpPRInt = "  update PO_REQUISITIONS_INTERFACE_ALL set LINE_ATTRIBUTE2=?, SUGGESTED_VENDOR_ID=?, SUGGESTED_VENDOR_SITE_ID=?, AUTOSOURCE_FLAG=?, NOTE_TO_RECEIVER=? "+
				                        "  where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									    "    and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ";
										 
			        
                    PreparedStatement stmtLinkOSP=con.prepareStatement(sqlUpPRInt);          
	                stmtLinkOSP.setString(1,woNo);                  //out.println("�u�O��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �u�O�� 
	                stmtLinkOSP.setInt(2,dexiVendorID);             // SUGGESTED_VENDOR_ID(�w��)
				    stmtLinkOSP.setInt(3,dexiVndSiteID);	        // SUGGESTED_VENDOR_SITE_ID(�w��)
					stmtLinkOSP.setString(4,"Y");                   // API��󭭨�,�n��Suggest Vendor ID�ݳ]�w��P  //20061225 liling �אּY ,�]����P�|�줣���� 	
					stmtLinkOSP.setString(5,aMFGRCExpTransCode[i][1]);// out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // NOTE_TO_RECEIVER = �y�{�d��  	          
                    stmtLinkOSP.executeUpdate();
                    stmtLinkOSP.close();		
				 	out.println("��s PR Interface Success!!<BR>");	
					// For MIS Testing Only �ٱo�·ХhRequest���檽���I�s_�_------------------------------�W�u�Ჾ��	
					         int batchId = 0;
							 String errPRIntMSG = "";
							 String errPRIntCLN = ""; 	
					         int requestID = 0;
							 
							// ���妸BatchID
							Statement stateBatchID=con.createStatement();
                            ResultSet rsBatchID=stateBatchID.executeQuery("SELECT PR_INTERFACE_BATCH_ID_S.NEXTVAL FROM dual");
	                        if (rsBatchID.next()) batchId = rsBatchID.getInt(1);
							rsBatchID.close();
							stateBatchID.close(); 
							// ���妸BatchID
							
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
								  
								  //   out.println("�I�sCreate PO for OSP Dexi Request Line 1496<BR>");
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
                                // out.println("Exception �I�sCreate PO for OSP Dexi Request:"+e.getMessage());
                                }	
							  // �@��e�~�[�u,�I�sREQUISITION IMPORT REQUEST����PR_��
							  //con.commit();
							  //java.lang.Thread.sleep(15000);	 // ����Q����,����Concurrent���槹��,�����G�P�_		
							  // �̫�A�P�_�O�_�@��~�]PR �O�_���Q����_�_
							    // ���妸BatchID
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
								  errPRImpFlag = true; // ���~�X��
								  
								  out.println("<font color='#FF0000'>Create PO for OSP Dexi Request�o�Ϳ��~</font>!!!:���~���(<font color='#0033CC'>"+errPRIntCLN+"</font>)<BR>");
								  out.println("<font color='#FF0000'>���~�T��</font>:"+errPRIntMSG+"<BR>");								  
								} else {
								        //out.println("Success Submit Create PO for OSP Dexi Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)<BR>");
										String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
										//out.println("sqlPRNo ="+sqlPRNo+"<BR>");
										Statement statePRNo=con.createStatement();
                                        ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
	                                    if (rsPRNo.next()) 
								        {  //out.println("����PR���X="+rsPRNo.getString("SEGMENT1")+"<BR>");
										   PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ");          
	                                       stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No��y�{�d��	                         	          
							               stmtLinkRC.setInt(2,batchId);							               
                                           stmtLinkRC.executeUpdate();
                                           stmtLinkRC.close(); 
										}	
										rsPRNo.close();
										statePRNo.close();						 
								       } // End of else
							    rsPRError.close();
							    statePRError.close();     
							 // �̫�A�P�_�O�_�@��~�]PR �O�_���Q����_��					  
							  
						// For MIS Testing Only �ٱo�·ХhRequest���檽���I�s_��------------------------------�W�u�Ჾ��
					
												
				  } else {  // �@��~�]�t��,�t�ζ}��PR������,�ѤH���ۦ�}�߱��ʳ�_�_
				            out.println("�@��~�]�t��PR Interface,�ò���PR<BR>");
				           	 int batchId = 0;
							 String errPRIntMSG = "";
							 String errPRIntCLN = ""; 						
							
							// ���妸BatchID
							Statement stateBatchID=con.createStatement();
                            ResultSet rsBatchID=stateBatchID.executeQuery("SELECT PR_INTERFACE_BATCH_ID_S.NEXTVAL FROM dual");
	                        if (rsBatchID.next()) batchId = rsBatchID.getInt(1);
							rsBatchID.close();
							stateBatchID.close(); 
							// ���妸BatchID
						/*	
				            String sqlUpPRInt = "  update PO_REQUISITIONS_INTERFACE_ALL set LINE_ATTRIBUTE2=?, BATCH_ID=?, NOTE_TO_RECEIVER=? "+
				                                "  where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
									            "    and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][5]+"' ";
			                PreparedStatement stmtLinkOSP=con.prepareStatement(sqlUpPRInt);          
	                        stmtLinkOSP.setString(1,woNo);    //out.println("�u�O��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �u�O�� 	                         	          
							stmtLinkOSP.setInt(2,batchId);
							stmtLinkOSP.setString(3,aMFGRCExpTransCode[i][1]); //out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // NOTE_TO_RECEIVER = �y�{�d�� 
                            stmtLinkOSP.executeUpdate();
                            stmtLinkOSP.close();									
						*/	        
							    
							  // �@��e�~�[�u,�I�sREQUISITION IMPORT REQUEST����PR_�_
							    int requestID = 0;
								String devStatus = "";
	                            String devMessage = "";	
							    try
								{   
									 out.println("�I�sRequesition Import Request<BR>");
								     //out.println("userMfgUserID="+userMfgUserID+"<BR>");
								     //out.println("respID="+respID+"<BR>");
								     CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
	                                 cs1.setInt(1,batchId);  //*  Group ID 	
				                     cs1.setString(2,userMfgUserID);    //  user_id �ק�HID /	
				                     cs1.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> TSC_WIP_Semi_SU /				 
	                                 cs1.registerOutParameter(4, Types.INTEGER); 
									 cs1.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
				                     cs1.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
	                                 cs1.execute();
                                     //out.println("Procedure : Execute Success !!! ");
	                                 requestID = cs1.getInt(4);
									 devStatus = cs1.getString(5);    //  �^�� REQUEST ���檬�p
				                     devMessage = cs1.getString(6);   //  �^�� REQUEST ���檬�p�T��
                                     cs1.close();
								
								} //end of try
                                catch (SQLException e)
                                {
                                 out.println("Exception �I�sRequesition Import Request:"+e.getMessage());
                                }	
							  // �@��e�~�[�u,�I�sREQUISITION IMPORT REQUEST����PR_��
							  con.commit();
							  // java.lang.Thread.sleep(15000);	 // ����Q����,����Concurrent���槹��,�����G�P�_
							  
							  // �̫�A�P�_�O�_�@��~�]PR �O�_���Q����_�_
							    // ���妸BatchID
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
								  errPRImpFlag = true; // ���~�X��
								  
								  out.println("<font color='#FF0000'>PR Requisition Import�o�Ϳ��~</font>!!!:���~���(<font color='#0033CC'>"+errPRIntCLN+"</font>)<BR>");
								  out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
								  out.println("<font color='#FF0000'>���~�T��</font>:"+errPRIntMSG+"<BR>");								  
								} else {
								        out.println("Success Submit Requisition Import Request !!! Request ID:(<font color='#0033CC'>"+requestID+"</font>)<BR>");
										out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");
										String  sqlPRNo = "select a.SEGMENT1 from PO_REQUISITION_HEADERS_ALL a, PO_REQUISITION_LINES_ALL b where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and b.NOTE_TO_RECEIVER = '"+aMFGRCExpTransCode[i][1]+"' ";
										out.println("sqlPRNo ="+sqlPRNo+"<BR>");
										Statement statePRNo=con.createStatement();
                                        ResultSet rsPRNo=statePRNo.executeQuery(sqlPRNo);
	                                    if (rsPRNo.next()) 
								        {  out.println("����PR���X="+rsPRNo.getString("SEGMENT1")+"<BR>");
										   PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ");          
	                                       stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No��y�{�d��	                         	          
							               stmtLinkRC.setInt(2,batchId);							               
                                           stmtLinkRC.executeUpdate();
                                           stmtLinkRC.close(); 
										}	
										rsPRNo.close();
										statePRNo.close();						 
								       } // End of else
							    rsPRError.close();
							    statePRError.close();     
							 // �̫�A�P�_�O�_�@��~�]PR �O�_���Q����_��
						 } // �@��~�]�t��,�t�ζ}��PR������,�ѤH���ۦ�}�߱��ʳ�_��				  
				         rsJudgeOSP.close();
				         stateJudgeOSP.close();									  
				  
				  
                } //end of try
                catch (Exception e)
                {
                 out.println("Exception ��Routing�������귽�P�_�O�_���w��:"+e.getMessage());
                }	  			     	   
			     
			} // �����sPR_INTERFACE_��
			rsOSPInt.close();
			stateOSPInt.close();			    
		//out.println("�����sPR_INTERFACE_4");			
		// ���X����ʳ�(PR_INTERFACE)����T�ç�s��ATTRIBUTE2_��
		                                // �P�_PO_PR_���`_�_
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
							            // �P�_PO_PR_���`_��		
//	} // End of if (getRetScrapCode==0 && getRetCode==0)
// @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
			
		 
        // �Y���o�β��������\,�h��sRUNCARD ��ƪ�������
//  2006/12/26 liling		if (getRetScrapCode==0 && getRetCode==0 && !errPRImpFlag)
        if ( !errPRImpFlag )
		{   // �����\������,�e�@��,����,�U�@��������TRUNCARD_ALL��ƪ��s
			//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
			boolean singleOp = false;  // �w�]���������̫�@��
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
				   out.println("�U�@���N�X="+nextOpSeqNum);
				}	
	        } else {
	                 operationSeqNum   = "0";
				     operationSeqId    = "0";
				     standardOpId  	  = "0";
				     standardOpDesc   = "0"; 
	                 previousOpSeqNum  = "0"; 
				     nextOpSeqNum	  = "0"; 
					 // �����Y���̫�@��,�G�ݧ�s���A�� 046 (���u�J�w)					 
					 Statement stateMax=con.createStatement();
                     ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
					 if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
					 {
					   singleOp = true;						   			   
					 } else out.println("�U�@���N�X="+rsMax.getString(1));
					 rsMax.close();
					 stateMax.close();
					 
					 
	               }
	               rsp.close();
                   statep.close();				   
				   
		  // %%%%%%%%%%%%%%%%%%% �g�JRun card Move Transaction %%%%%%%%%%%%%%%%%%%_�_
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
           queueTransStmt.setInt(6,Integer.parseInt(aMFGRCExpTransCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
		   queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           queueTransStmt.setInt(8,Integer.parseInt(aMFGRCExpTransCode[i][5])); //TO_OPERATION_SEQ_NUM(�U�@��) 
	       queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
	       queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCExpTransCode[i][2]));  // Transaction Qty
	       queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       queueTransStmt.setInt(12,1);             // 1=Queue		  
	       queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       queueTransStmt.setString(15,"042");      // From STATUSID
		   queueTransStmt.setString(16,"GENERATED");	  // From STATUS
		   queueTransStmt.setString(17,fndUserName);	  // Update User  
           queueTransStmt.executeUpdate();
           queueTransStmt.close();	    	 
		 
		 // %%%%%%%%%%%%%%%%%%% �g�JRun card Move Transaction %%%%%%%%%%%%%%%%%%%_�� 
		 	
		 if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
		 {		 
		   // %%%%%%%%%%%%%%%%%%% �g�JRun card Scrap Transaction %%%%%%%%%%%%%%%%%%%_�_
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
           scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCExpTransCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
		   scrapTransStmt.setString(7,standardOpDesc);                                      //  FM_OPERATION_CODE	       	   
           scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCExpTransCode[i][4])); //TO_OPERATION_SEQ_NUM(�U�@��) 
	       scrapTransStmt.setString(9,standardOpDesc);                                      //TO_OPERATION_CODE(�U�@���N�X) 
	       scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty 
	       scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       scrapTransStmt.setInt(12,5);             // 5=SCRAP(���o)		  
	       scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
		   scrapTransStmt.setString(15,"042"); // From STATUSID
		   scrapTransStmt.setString(16,"GENERATED");	  // From STATUS		   
		   scrapTransStmt.setString(17,fndUserName);	  // Update User  
           scrapTransStmt.executeUpdate();
           scrapTransStmt.close();	    	 
		 
		  // %%%%%%%%%%%%%%%%%%% �g�JRun card Scrap Transaction %%%%%%%%%%%%%%%%%%%_�� 
		 
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
		   if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
		   {
	         rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
	         rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
		   } else { // �_�h,�Y��s�� 045 �~�]���Ƨ��u�J�w
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
		         interfaceErr = true; // ��ܲ���Interface�����`
				 out.println("���o�B��������PR�BPO���`!!! ���A����s");
		      } // End of else
			  
		} // end of if (aMFGRCExpTransCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o   
		 out.print("<font color='#0033CC'>�y�{�d("+aMFGRCExpTransCode[i][1]+")�w�벣�ée�~�[�uO.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	   } // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID����}�C���e
	  } // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s
	      
		   if (jobType.equals("2"))
		   {
	                con.commit();
	                int cc=0;
					while (true)
					{
					  java.lang.Thread.sleep(5000);	 // �C�@���@��PR Import����*6��,����Concurrent���槹��,�����G�P�_				 
					  System.err.println("count:"+cc+" waiting......;");
					  if (cc>6) //�Y���ݮɶ��W�L3�����h����@�~(�]PR Import30��������)
					  {	    
						//telnetBean_PROD.disconnect(); 
						System.err.println("��������PR ����!!");
						break; 	    
					  }	
					  cc++;					  
					} //enf of while -> ���ݰj��	  
	       } // End of if (jobType.equals("2"))
     } // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
	} // end of if (aMFGRCExpTransCode!=null) 
	
	//out.print("�y�{�d�벣O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");
	
	
	if (!nextOpSeqNum.equals("0") && !interfaceErr) // �Y�U�@��������̫�@���BInterface�L���`
	{
	 %>
	   <script LANGUAGE="JavaScript">
	       alert("�y�{�d������(MOVING)");
	       //reProcessFormConfirm("�O�_�~����榹�i�y�{�d�����@�~?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	   </script>
	 <%	
	} else { 
	         if (nextOpSeqNum.equals("0") && fromStatusID.equals("042"))
			 {
			   %>
	             <script LANGUAGE="JavaScript">
				   alert("�y�{�d���ܩe�~�[�u(045 OSPRECEIVING)");
	               //reProcessQueryConfirm("���y�{�d�w���ܩe�~�[�u,�~�����e�~�[�u���ʦ��Ƨ@�~?","../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=045&PAGEURL=TSCMfgRunCardOSPReceipt.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
	             </script>
	           <%
			   
			 } else {
	                   %>
	                      <script LANGUAGE="JavaScript">
	                        alert("Oracle�������`..�Ь�MIS�d����]!!!");
	                      </script>
	                   <%	
					}
	       }
	
	// �ϥΧ����M�� 2���}�C
    if (aMFGRCExpTransCode!=null)
	{ 
	  arrMFGRCExpTransBean.setArray2DString(null); 
	}

}
//MFG�y�{�d������_�_	(ACTION=024)  �y�{�d�w�i�}042->�y�{�d�e�~�[�u�� 045  // �p��n��, �Y �Ĥ@�� --> �ĤG�� --> �� n-1 ��

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
    <td width="278"><font size="2">WIP��ڳB�z</font></td>
    <td width="297"><font size="2">WIP�d�ߤγ���</font></td>    
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
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>


