<!-- 20091217 Marvie Add : yew_runcard_restxns data loss-->
<!-- 20130123 liling Add : yew_runcard_transactions FM_OPERATION_CODE loss-->
<!-- 20130327 liling modity : OSP�ᦳ�h���̨�runcard status �n�P�_��044 moving -->
<!-- 20200506 liling ������J�w�ʧ@,���WMS���� 6/27��s�t��-->
<!-- 20200703 Marvie : 1 receipt interface �i���� receipt delivery �ʧ@ -->
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
<jsp:useBean id="arrMFG2DWOExpandBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �u�O��ƭn�i�y�{�d�Υ�JWIP interface-->
<jsp:useBean id="arrMFG2DRunCardBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d�w�i�}-> �y�{�d������ -->
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d������-> �y�{�d������ -->
<jsp:useBean id="arrMFGRCPOReceiptBean" scope="session" class="Array2DimensionInputBean"/><!--FOR �y�{�d������-> �y�{�d�~�]�ݦ��Ƥ� -->
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d������-> �y�{�d���u�J�w -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<FORM ACTION="TSCMfgWoMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //��Server��web.xml�����Xmail server��host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String inspLotNo=request.getParameter("INSPLOTNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//���o�e�@���B�z�����׮ץ�O�_�w��e��FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");

// MFG�u�O���_�Ѽư_   
String woNo=request.getParameter("WO_NO");   //�u�渹
String runCardCountI=request.getParameter("RUNCARDCOUNTI");   //���i���y�{�d�i��
String runCardQty=request.getParameter("RUNCARDQTY");        //��i�y�{�d�ƶq
String runCardCountD=request.getParameter("RUNCARDCOUNTD");  //���i�y�{�d�ƶq
String dividedFlag=request.getParameter("DIVIDEDFLAG");      //�O�_�Q�㰣 �㰣='Y' ,���Q�㰣���y�{�d�n�h�[�@�i
String singleControl=request.getParameter("SINGLECONTROL");   //�O�_����山��
String runCardPrffix=request.getParameter("RUNCARDPREFIX");   //�y�{�d�e�m�X
String runCardNo=request.getParameter("RUNCARD_NO");   //�y�{�d��
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
String runCardCount=String.valueOf(runCardCountI);  //�y�{�d�i��
      
if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR �~������ƾڿ�J�����P�w
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR �y�{�d�w�i�}-> �y�{�d������
String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR �y�{�d������-> �y�{�d������
String aMFGRCPOReceiptCode[][]=arrMFGRCPOReceiptBean.getArray2DContent(); // FOR �y�{�d������-> �y�{�d�~�]�ݦ��Ƥ�
String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR �y�{�d������-> �y�{�d���u�J�w
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//�O�_�nSEND MAIL
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

// ���s�J����榡��US�Ҷq,�N�y�t���]������
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
	}
	rsDate.close();
    stateDate.close();	   
}   
 
java.sql.Date receivingDate = null; //�NSYSDATE�ഫ������榡�H�ť�JAPI�榡
if (systemDate!=null && systemDate.length()>=8)
{
	receivingDate = new java.sql.Date(Integer.parseInt(systemDate.substring(0,4))-1900,Integer.parseInt(systemDate.substring(4,6))-1,Integer.parseInt(systemDate.substring(6,8)));  // ��Receiving Date
   	String systemTime = dateBean.getHourMinuteSecond();  // ��System Time
   
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
   
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Promise Date    
int lineType = 0;  
String respID = "50124"; // �w�]�Ȭ� TSC_OM_Semi_SU, �P�_�Y�� Printer Org �h�]�w�� TSC_OM_Printer_SU = 50125
String dateCurrent = dateBean.getYearMonthDay();	

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
  
  	String sqlStat = "";
  	String whereStat = "";
	//out.println("FORMID="+formID);
  	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
   	
  	sqlStat = sqlStat+whereStat;
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
  	getStatusRs.next();

	//MFG�y�{�d������_�_	(ACTION=023)   �y�{�d�w�i�}042->�y�{�d�e�~�[�u�ݦ���(045)
	if (actionID.equals("023") && fromStatusID.equals("042"))   // �p��n��, �Y �Ĥ@�� --> �ĤG�� --> �� n-1 ��(��ܲĤG���Y���e�~�[�u��)
	{   
    	String fndUserName = "";  //�B�z�H��
		String woUOM = ""; // �u�O�������
		int primaryItemID = 0; // �Ƹ�ID
    	float runCardQtyf=0,overQty=0; 
		entityId = "0"; // �u�Owip_entity_id
		boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
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
	    			if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RUNCARD_ID = �}�C���e
	    			{
		  				if (Float.parseFloat(aMFGRCExpTransCode[i][2])>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
		  				{
		   					int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   					int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   					if (aMFGRCExpTransCode[i][5]==null || aMFGRCExpTransCode[i][5]=="0" || aMFGRCExpTransCode[i][5].equals("0")) 
		   					{
		     					toIntOpSType = 3; 
		     					aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // �L�U�@����Seq No,�G������
			 					transType = 1; //(���u�ѤJ�w��۰ʰ���,�G���]��1)
		   					}
		   					//����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
		   					float  rcMQty = 0;   
		   					float  rcScrapQty = 0;     
		   					java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 
		               
						 	String sqlMQty = " select b.QTY_IN_QUEUE,b.RES_EMPLOYEE_OP from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
 									         " where a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										     "   and b.RUNCARD_NO='"+aMFGRCExpTransCode[i][1]+"' ";
						 	Statement stateMQty=con.createStatement();
                         	ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						 	if (rsMQty.next())
						 	{
						   		if (aMFGRCExpTransCode[i][2]==null || aMFGRCExpTransCode[i][2].equals("null")) aMFGRCExpTransCode[i][2]=Float.toString(rcMQty);
						   		rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		//��미�ƶq	
                           		txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 �������	
    
						   		rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
						   
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
		 
		   						// *****%%%%%%%%%%%%%% �������o�ƶq  %%%%%%%%%%%%**********  �_
		   						toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
		   						transType = 1; // ���o��Transaction Type = 1(Move Transaction)
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
           						scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 �אּ Running )      
		   						scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>�y�{�d:"+aMFGRCExpTransCode[i][1]+"(1.���o�ƶq="+rcScrapQty+")  ");       	   
           						scrapstmt.setString(8,woUOM);
	       						scrapstmt.setInt(9,Integer.parseInt(entityId));  
	       						scrapstmt.setString(10,woNo);  
	       						scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
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
 									     		" where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and ORGANIZATION_ID = '"+organizationID+ "' "+  //20091123 liling add Organization_id
										 		" and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 		" and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
										 		" and TO_INTRAOPERATION_STEP_TYPE = 5 "; // ���������o
								Statement stateGrp=con.createStatement();
                        		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();
		 
		 						if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 						{
		   							// �Y�ɩI�s WIP_MOVE PROCESS WORKER		  
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
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
							 				out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"���o���~��]="+getErrScrapBuffer+"<BR>");
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
							if (getRetScrapCode==0) // �Y����P�@�����o���\,�~���沾�U�@���ʧ@_�_
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
            					//�P�_�O�_��overcompletion
             					String sqlpre="  select TRANSACTION_QUANTITY from YEW_RUNCARD_TRANSACTIONS "+
						                      "  where STEP_TYPE=1 and FM_OPERATION_SEQ_NUM = '"+aMFGRCExpTransCode[i][3]+"' "+
						                      "  and RUNCARD_NO = '"+aMFGRCExpTransCode[i][1]+"' ";
								Statement statepre=con.createStatement();
            					ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
			  						prevQty = rspre.getFloat(1);  //�e��������
								}
		    					rspre.close();
								statepre.close();
			
								//add by Peggy 20140324
								if (rcScrapQty >0)
								{
									//runCardQtyf	=runCardQtyf -Float.parseFloat("0"+rcScrapQty);
									//�ѨM�B�I�ƭp����D,add by Peggy 20140417
									runCardQtyf	=(runCardQtyf *1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
									runCardQtyf	=runCardQtyf/1000;
								}
								if (runCardQtyf<0) runCardQtyf=0;
								//out.println("aMFGRCExpTransCode[i][2]="+aMFGRCExpTransCode[i][2]);
								//out.println("runCardQtyf="+runCardQtyf);
								//out.println("remainQueueQty="+remainQueueQty);
								//out.println("runCardQtyf="+runCardQtyf);
						
								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf && remainQueueQty > Float.parseFloat(aMFGRCExpTransCode[i][2]) )//�Y�����Ƥj��y�{�d��,���overcompletion_By Kerwin 2007/04/11
            					{
                					//overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //������-�y�{�d��=�W�X�ƶq
									//�ѨM�B�I�ƭp����D,add by Peggy 20140417
									overQty = (Float.parseFloat(aMFGRCExpTransCode[i][2]) *1000) - (runCardQtyf*1000) ;    //������-�y�{�d��=�W�X�ƶq
									overQty = overQty/1000;
                					overFlag = "Y";   //���w�W����flag
									//out.println("21.overQty="+overQty);
            					}
								else  
								{ 
			          				if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > remainQueueQty)
					  				{
					    				//overQty = Float.parseFloat(aMFGRCExpTransCode[i][2])-remainQueueQty; 
										//�ѨM�B�I�ƭp����D,add by Peggy 20140417
										overQty = (Float.parseFloat(aMFGRCExpTransCode[i][2])*1000)-(remainQueueQty*1000); 
										overQty = overQty/1000;
										overFlag = "Y";   //���w�W����flag
										//out.println("22.overQty="+overQty);
					  				} 
									else 
									{
					           			overFlag = "N"; 
					         		}		 			 
			       				}
		   						toIntOpSType = 1;  // ������to InterOperation Step Type = 1 
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
           						seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error  (2006/12/08 �אּ Running)
		   						seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // �����ƶq
           						seqstmt.setString(8,woUOM);
	       						seqstmt.setInt(9,Integer.parseInt(entityId));  
	       						seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
	       						seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       						seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
	       						seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       						seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       						seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
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
										 		"   and TO_INTRAOPERATION_STEP_TYPE = 1 "; // ������������Group ID
						 		Statement stateGrp=con.createStatement();
                         		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 		if (rsGrp.next())
						 		{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 		}
						 		rsGrp.close();
						 		stateGrp.close();
								
		 						if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 						{
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
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
							 				out.println("getRetCode="+getRetCode+"&nbsp;"+"�������~��]="+getErrBuffer+"<BR>");
						  				}							  
									}	  
									catch (Exception e) 
									{ 
										out.println("Exception2:"+e.getMessage()); 
									}  
		  						} 	 
							}
			 	
						boolean errPRImpFlag = false; // �w��D�w��,PR Requisition Import���ͪ����~�P�_	
						if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s
						{ 	 
	      					//�����o�����沣��PO��Responsibility ID_�_
	     					Statement stateResp=con.createStatement();	   
	     					ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME like 'YEW_WIP_SEMI_SU%' "); 
	     					if (rsResp.next())
	     					{
	       						respID = rsResp.getString("RESPONSIBILITY_ID");
	     					} 
							else 
							{
	              				respID = "50835"; // �䤣��h�w�] --> YEW_WIP_SEMI_SU �w�]
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
			
							boolean oddOSPFlag = false;  // �w��w��,�ݯS�O�B�zInterface	
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
					                                  " and b.COST_CODE_TYPE = 4 "+ // ���~�]
									                  " and ( b.DESCRIPTION like '%�w��%' or b.RESOURCE_CODE like '%DA%') "; // �Ȯɨϥ�Description �P�_�O�_�n���ͤw�֭�PR,�_�h���bInterface
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
				  					if (rsJudgeOSP.next()) //  �P�_�Y�s�{�~�]�����w��,�h�ݥt��sInterface��Suggested Vendor ID, Suggested Vendor Site ID��
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
										// �@��~�]�t��,�t�ζ}��PR������,�ѤH���ۦ�}�߱��ʳ�_�_
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
											out.println("�I�sRequesition Import Request<BR>");
								     		CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
	                                 		cs1.setInt(1,batchId);  //*  Group ID 	
				                     		cs1.setString(2,userMfgUserID);    //  user_id �ק�HID /	
				                     		cs1.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> TSC_WIP_Semi_SU /				 
	                                 		cs1.registerOutParameter(4, Types.INTEGER); 
									 		cs1.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
				                     		cs1.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
	                                 		cs1.execute();
	                                 		requestID = cs1.getInt(4);
									 		devStatus = cs1.getString(5);    //  �^�� REQUEST ���檬�p
				                     		devMessage = cs1.getString(6);   //  �^�� REQUEST ���檬�p�T��
                                     		cs1.close();
										} 
                                		catch (SQLException e)
                                		{
                                 			out.println("Exception �I�sRequesition Import Request����PR:"+e.getMessage());
                                		}	
							    		
										// ���妸BatchID
										String  sqlPRError = " select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
								                             " from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
								                             " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
													         " and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
													         " and a.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID="+organizationID+" "; //20091123 liling �[destination_organization_id
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
										   		out.println("<BR><font color='FF0099'>����PR���X</font>=<font color='FF0000'>"+rsPRNo.getString("SEGMENT1")+"</font><BR>");	
										   		PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' ");          
	                                       		stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No��y�{�d��	                         	          
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
                 					out.println("Exception ��Routing�������귽�P�_�O�_���w��:"+e.getMessage());
                				}	  
							}
							else 
							{ 
			       				if (jobType.equals("1"))
				   				{
								  	%>
								  	<script language="javascript">
										alert("              �䤣�첣�ͪ�PR_Interface\n ���~�]���귽�]�w���~,�Ь�MIS�d���] !!!");
								  	</script>			  
								  	<%	
				   				}
			       				else if (jobType.equals("2"))
			        			{
									%>
									<script language="javascript">
										alert("       ���u�u�O�䤣�첣�ͪ�PR_Interface\n       �i�ॼ���ͦ��~�]���ʳ� !!!");
									</script>			  
									<%	
				    			}
			     			}
							rsOSPInt.close();
							stateOSPInt.close();			    
		
		                    // �P�_PO_PR_���`_�_
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
		 
        				// �Y���o�β��������\,�h��sRUNCARD ��ƪ�������
						if (getRetScrapCode==0 && getRetCode==0)
						{
							boolean singleOp = false;  // �w�]���������̫�@��
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
					 			// �����Y���̫�@��,�G�ݧ�s���A�� 046 (���u�J�w)					 
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
		 
		 					if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
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
		 					}	

           					String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?,  "+
		                                 " QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
						                 " QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+ //20090603 liling add RES_EMPLOYEE_OP�M���ť�,�����ɤ~�|��t�Τ�
		                                 " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
           					PreparedStatement rcStmt=con.prepareStatement(rcSql);
	       					rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	       					rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		   					if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
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
		   					rcStmt.setFloat(13,Float.parseFloat(aMFGRCExpTransCode[i][2])+rcScrapQty);  // �B�z��
           					rcStmt.executeUpdate();   
           					rcStmt.close(); 
		 				}
		 				else 
						{
		        			interfaceErr = true;  // ��ܳ��o�β���Interface�����`,�hJavaScript�i���ϥΪ�
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
					java.lang.Thread.sleep(5000);	 // �C�@���@��PR Import����*4��,����Concurrent���槹��,�����G�P�_				 
					System.err.println("count:"+cc+" waiting......;");
					if (cc>3) //�Y���ݮɶ��W�L20��h����@�~(�]PR Import20��������)
					{	    
						System.err.println("��������!!");
						break; 	    
					}	
					cc++;					  
				}
			}
     	}
	} 
	
	out.print("<font color='#0033CC'>�y�{�d�w�벣O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	if (!nextOpSeqNum.equals("0") && !interfaceErr) // �U�@�������̫�@���B���o�β���Interface�L���`
	{
	%>
		<script LANGUAGE="JavaScript">
	       alert("�y�{�d���ܩe�~�[�u(OSPRECEIVING)");
	   	</script>
	<%	
	} 
	else 
	{	        
	%>
		<script LANGUAGE="JavaScript">
	    	alert("Oracle���o�β������`,�Ь�MIS�d����]!!!");
	    </script>
	<%				 
	}
	
	// �ϥΧ����M�� 2���}�C
    if (aMFGRCExpTransCode!=null)
	{ 
		arrMFGRCExpTransBean.setArray2DString(null); 
	}
}

if (actionID.equals("023") && fromStatusID.equals("044"))   // �p��n��, ��2�� --> �� n-1 ��(��ܲ�k�����e�~�[�u��-->����PR�JInterface)
{  
	String fndUserName = "";  //�B�z�H��
	String woUOM = ""; // �u�O�������
	int primaryItemID = 0;
    float runCardQtyf=0,overQty=0; 
	entityId = "0"; // �u�Owip_entity_id
	boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
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
		   
		   	//��������ƶq�����_�_	                     
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
	       	//��������ƶq�����_��   
	  	}
	  
	  	for (int i=0;i<aMFGRCMovingCode.length-1;i++)
	  	{
	   		for (int k=0;k<=choice.length-1;k++)    
       		{ 
	    		if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
	    		{
		  			if (Float.parseFloat(aMFGRCMovingCode[i][2])>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o 
		  			{
		  				int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   				int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   				if (aMFGRCMovingCode[i][5]==null || aMFGRCMovingCode[i][5]=="0" || aMFGRCMovingCode[i][5].equals("0")) 
		   				{ // �Y�L�U�@���Ǹ�,�h��ܥ����Y���̲ׯ�,�����ʧ@�]�w�����u
		     				toIntOpSType = 3; 
		     				aMFGRCMovingCode[i][5] = aMFGRCMovingCode[i][4]; // �L�U�@����Seq No,�G������
			 				transType = 2;
		   				} 
		   
		   				//����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
		   				float  rcMQty = 0;   
		   				float  rcScrapQty = 0;   
		   				java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 
		   					 
						String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY , b.RES_EMPLOYEE_OP "+
						                 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
 									     "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and c.organization_id = a.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+  //20091123 liling add organization_id
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // ��QUEUE�����ƶq
										 "     and b.RUNCARD_NO='"+aMFGRCMovingCode[i][1]+"' and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][3]+"' ";				 
						//out.println("sqlMQty ="+sqlMQty);				 
						Statement stateMQty=con.createStatement();
                        ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						if (rsMQty.next())
						{
							if (aMFGRCMovingCode[i][2]==null || aMFGRCMovingCode[i][2].equals("null")) aMFGRCMovingCode[i][2]=Float.toString(rcMQty);
						   	rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//��e�����u�ƶq	
                           	txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 �������
						   	rcScrapQty = rcMQty - Float.parseFloat(aMFGRCMovingCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
						   
						    String strScrapQty = nf.format(rcScrapQty);
							java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
							java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							rcScrapQty =scrapQty.floatValue();
						}
						rsMQty.close();
						stateMQty.close();

        				if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null")) txnDate=systemDate;  //20090605 liling �W�[�Y�Skey�N�w�]systemdate
		 
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
		 				if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
		 				{	
		   					toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
		   					transType = 1; // ���o��Transaction Type = 1(Move Transaction)
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
           					scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 �אּ Running )      
		   					scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>�y�{�d:"+aMFGRCMovingCode[i][1]+"(2.���o�ƶq="+rcScrapQty+")  ");// �������o�ƶq	       	   
           					scrapstmt.setString(8,woUOM);
	       					scrapstmt.setInt(9,Integer.parseInt(entityId));  
	       					scrapstmt.setString(10,woNo);  
	       					scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       					scrapstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(����)		  
	       					scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       					scrapstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][4])); // TO_OPERATION_SEQ_NUM  //���o�Y��From = To
	       					scrapstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
		   					scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   					scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)���o  ( 01-11-000-7650-951-0-000 ) 
		   					scrapstmt.setInt(18,7);	// REASON_ID  �s�{���`
           					scrapstmt.executeUpdate();
           					scrapstmt.close();	      	
		   
		   					//����g�JInterface��Group����T_�_
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

		 					if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 					{
		   						int procPhase = 1;
		   						int timeOut = 10;
		   						try
		   						{	
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
							 			out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"���o���~��]="+getErrScrapBuffer+"<BR>");
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
						if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface
						{ 
							// �A�P�_�O�_�w�W�L�ӯ��i������,�Y�O,�h����OverComp_�_--��ܤu�O�i�β�����
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
								prevQty = rspre.getFloat(1);  //�e��������
							}
							rspre.close();
							statepre.close();

							//add by Peggy 20140324
							if (rcScrapQty >0)
							{
								//prevQty	=prevQty -Float.parseFloat("0"+rcScrapQty);
								//�ѨM�B�I�ƭp����D,add by Peggy 20140417
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
								//overQty = Float.parseFloat(aMFGRCMovingCode[i][2]) - prevQty ;    //������-�y�{�d��=�W�X�ƶq
								//�ѨM�B�I�ƭp����D,add by Peggy 20140417
								overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000) - (prevQty *1000);
								overQty = overQty /1000;
								overFlag = "Y";   //���w�W����flag
								//out.println("31.overQty="+overQty);
							} 
							else  
							{
								if (Float.parseFloat(aMFGRCMovingCode[i][2]) > remainQueueQty)
								{
									//overQty = Float.parseFloat(aMFGRCMovingCode[i][2])-remainQueueQty; 
									//�ѨM�B�I�ƭp����D,add by Peggy 20140417
									overQty = (Float.parseFloat(aMFGRCMovingCode[i][2])*1000)-(remainQueueQty*1000);
									overQty = overQty /1000;
									overFlag = "Y";   //���w�W����flag
									//out.println("32.overQty="+overQty);
								} 
								else 
								{
									overFlag = "N"; 
								}		
							}
	
							toIntOpSType = 1;  // ������to InterOperation Step Type = 1
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
							seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/08 �אּ Running )
							seqstmt.setFloat(7,Float.parseFloat(aMFGRCMovingCode[i][2])); // �����ƶq
							seqstmt.setString(8,woUOM);
							seqstmt.setInt(9,Integer.parseInt(entityId));  
							seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
							seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
							seqstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
							seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
							seqstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
							seqstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
							seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (overFlag == "Y" || overFlag.equals("Y"))
							{ 
								seqstmt.setFloat(17,overQty); 
							} // OVERCOMPLETION_TRANSACTION_QTY   
							seqstmt.executeUpdate();
							seqstmt.close();	      	
		   
							//����g�JInterface��Group����T_�_
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
						 
							if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
							{
								int procPhase = 1;
								int timeOut = 10;
								try
								{	
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
										out.println("getRetCode="+getRetCode+"&nbsp;"+"�������~��]="+getErrBuffer+"<BR>");
									}							  
								}	  
								catch (Exception e) 
								{ 
									out.println("Exception5:"+e.getMessage()); 
								}  
							}
						}
						
						boolean errPRImpFlag = false; // �w��D�w��,PR Requisition Import���ͪ����~�P�_	
						if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����PR Interface���ʧ�s
						{ 	
							//�����o�����沣��PO��Responsibility ID_�_
							Statement stateResp=con.createStatement();	   
							ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME = 'YEW_WIP_SEMI_SU' "); 
							if (rsResp.next())
							{
								respID = rsResp.getString("RESPONSIBILITY_ID");
							} 
							else 
							{
								respID = "50767"; // �䤣��h�w�] --> YEW WIP Super User �w�]
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
			
							boolean oddOSPFlag = false;  // �w��w��,�ݯS�O�B�zInterface			
							String sqlOSPInt = " select * from PO_REQUISITIONS_INTERFACE_ALL "+
											   " where WIP_ENTITY_ID = '"+entityId+"' and DESTINATION_TYPE_CODE = 'SHOP FLOOR' and INTERFACE_SOURCE_CODE ='WIP' "+
											   " and DESTINATION_ORGANIZATION_ID = '"+organizationID+"' and WIP_OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][5]+"' and NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' "; //20091123 liling �[note_to_receiver
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
										  // "   and b.ORGANIZATION_ID = '"+organizationID+"' "+ // Update 2006/11/08 �]���귽��Organization,����L����
										  "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
										  "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
										  "   and d.OPERATION_SEQ_NUM = e.NEXT_OP_SEQ_NUM "+ //e.NEXT_OP_SEQ_NUM "+
										  "   and e.RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' "+
										  "   and a.OPERATION_SEQUENCE_ID = e.NEXT_OP_SEQ_ID "+
										  "   and b.COST_CODE_TYPE = 4 "+ // ���~�]
										  "   and ( b.DESCRIPTION like '%�w��%' or b.RESOURCE_CODE like 'DA%') "; // �Ȯɨϥ�Description �P�_�O�_�n���ͤw�֭�PR,�_�h���bInterface
									//out.println(sqlJudgeOSP+"<BR>");					   
									Statement stateJudgeOSP=con.createStatement();
									ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
									if (rsJudgeOSP.next()) //  �P�_�Y�s�{�~�]�����w��,�h�ݥt��sInterface��Suggested Vendor ID, Suggested Vendor Site ID��
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
										out.println(aMFGRCMovingCode[i][1]+" ����(Moving)�w���~�]�g�JPR Interface,����REQ IMP����<BR>");
																
									} 
									else 
									{  // �@��~�]�t��,�t�ζ}��PR������,�ѤH���ۦ�}�߱��ʳ�_�_
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
								  
										// �@��e�~�[�u,�I�sREQUISITION IMPORT REQUEST����PR_�_
										int requestID = 0;	
										String devStatus = "";
										String devMessage = "";						
										try
										{    
											out.println("�I�sRequesition Import Request<BR>");
											CallableStatement cs1 = con.prepareCall("{call TSC_WIPOSP_REQIMP_REQUEST(?,?,?,?,?,?)}");			 
											cs1.setInt(1,batchId);  //*  Group ID 	
											cs1.setString(2,userMfgUserID);    //  user_id �ק�HID /	
											cs1.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> TSC_WIP_Semi_SU /				 
											cs1.registerOutParameter(4, Types.INTEGER); 
											cs1.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
											cs1.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
											cs1.execute();
											requestID = cs1.getInt(4);
											devStatus = cs1.getString(5);    //  �^�� REQUEST ���檬�p
											devMessage = cs1.getString(6);   //  �^�� REQUEST ���檬�p�T��
											cs1.close();
										} //end of try
										catch (SQLException e)
										{
											out.println("Exception �I�sRequesition Import Request����PR:"+e.getMessage());
										}	
									
										// ���妸BatchID
										String  sqlPRError = "select a.PROCESS_FLAG, b.COLUMN_NAME, b.ERROR_MESSAGE "+
															 "  from PO_REQUISITIONS_INTERFACE_ALL a, PO_INTERFACE_ERRORS b "+
															 " where a.REQUEST_ID = b.REQUEST_ID and a.TRANSACTION_ID=b.INTERFACE_TRANSACTION_ID "+
															 "   and a.INTERFACE_SOURCE_CODE = 'WIP' and a.PROCESS_FLAG = 'ERROR' "+
															 "   and a.NOTE_TO_RECEIVER = '"+aMFGRCMovingCode[i][1]+"' and DESTINATION_ORGANIZATION_ID="+organizationID+" ";  //20091123 �[ note_toreeiver and destination_organization_id
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
											break;  // break for loop �p�����~,�h�������ڪ��A��s							  
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
												out.println("<BR><font color='FF0099'>����PR���X</font>=<font color='FF0000'>"+rsPRNo.getString("SEGMENT1")+"</font><BR>");	
												PreparedStatement stmtLinkRC=con.prepareStatement("update YEW_RUNCARD_ALL set OSP_PR_NUM=?, PR_BATCH_ID=? where WO_NO='"+woNo+"' and RUNCARD_NO = '"+aMFGRCMovingCode[i][1]+"' ");          
												stmtLinkRC.setString(1,rsPRNo.getString("SEGMENT1")); //Line PR No��y�{�d��	                         	          
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
									out.println("Exception ��Routing�������귽�P�_�O�_���w��:"+e.getMessage());
								}	  
							} 
							else 
							{
							%>
								<script language="javascript">
									alert("              �䤣�첣�ͪ�PR_Interface\n ���~�]���귽�]�w���~�Υ�����PR !!!");
								</script>			  
							<%		
							}
							rsOSPInt.close();
							stateOSPInt.close();	
						
							// �P�_PO_PR_���`_�_
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
					
						if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s
						{ 
							boolean singleOp = false;  // �w�]���������̫�@��
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
								// �����Y���̫�@��,�G�ݧ�s���A�� 046 (���u�J�w)					 
								Statement stateMax=con.createStatement();
								ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCMovingCode[i][4]+"'  and WIP_ENTITY_ID ="+entityId+" and organization_id='"+organizationID+"'  ");  //20091123 liling add organization_id
								if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
								{
									singleOp = true;					   
								} else out.println("�U�@���N�X="+rsMax.getString(1)+"<BR>");
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
							queueTransStmt.setInt(6,Integer.parseInt(aMFGRCMovingCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
							queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
							queueTransStmt.setInt(8,Integer.parseInt(aMFGRCMovingCode[i][5])); //TO_OPERATION_SEQ_NUM(�U�@��) 
							queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
							queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCMovingCode[i][2]));  // Transaction Qty
							queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
							queueTransStmt.setInt(12,1);             // 1=Queue		  
							queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
							queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
							queueTransStmt.setString(15,"044"); // From STATUSID
							queueTransStmt.setString(16,"MOVING");	  // From STATUS
							queueTransStmt.setString(17,fndUserName);	  // Update User  
							queueTransStmt.executeUpdate();
							queueTransStmt.close();	    	 
			 
							if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
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
								scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCMovingCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
								scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
								scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCMovingCode[i][4])); //TO_OPERATION_SEQ_NUM(�U�@��) 
								scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(�U�@���N�X) 
								scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
								scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
								scrapTransStmt.setInt(12,5);             // 5=SCRAP(���o)		  
								scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
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
										 " QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP�M���ť�,�����ɤ~�|��t�Τ�
										 " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCMovingCode[i][0]+"' "; 	
							PreparedStatement rcStmt=con.prepareStatement(rcSql);
							rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
							rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
							if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (045) �y�{�d�e�~�[�u��
							{
								rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
								rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
							} 
							else 
							{ 	// �_�h,�Y��s�� 045 ���u�J�w
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
							rcStmt.setFloat(13,Float.parseFloat(aMFGRCMovingCode[i][2])+rcScrapQty);  // �B�z��
							rcStmt.executeUpdate();   
							rcStmt.close(); 
						}
						else 
						{
							interfaceErr = true; // ���o�β��������`
						}  
					}
				}
			}
			con.commit();
		} // End of for (i=0;i<aMFGRCMovingCode.length;i++)
	} // end of if (aMFGRCMovingCode!=null) 
	
  	if (!interfaceErr) // �Y���o�β����ҵL���`
  	{
		if (!nextOpSeqNum.equals("0"))
		{
	 	%>
	   	<script LANGUAGE="JavaScript">
	    	alert("�y�{�d���ܩe�~�[�u(045 OSPRECEIVING)");
	   	</script>
	 	<%	
		} 
		else 
		{
	    %>
	    <script LANGUAGE="JavaScript">
			alert("�w�FRounting�̫�@��,�e�~�[�u���ʦ���");
	    </script>
	    <%
	   	}
   	}
   	else 
	{ // �Y���o�β����ҵL���`
    %>
		<script LANGUAGE="JavaScript">
	    	alert("Oracle���o�β������`,�Ь�MIS�d����]!!!");
	    </script>
	<%
   	}	
	out.print("<BR><font color='#0033CC'>�y�{�d�����ܩe�~�[�uO.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	
	// �ϥΧ����M�� 2���}�C
    if (aMFGRCMovingCode!=null)
	{ 
		arrMFGRCMovingBean.setArray2DString(null); 
	}
} 

//MFG�y�{�d���u�J�w_�_	(ACTION=018) RECEIVE ����~�򲾯�  �y�{�d������045 --> �y�{�d���u�J�w046�B�����e�~�[�u��(�w�P�_�������̫�@��,�p���̫�@��,�h���ƫ�,�|�۰ʧ@TO_MOVE)
if ((actionID.equals("006") || actionID.equals("018")) && fromStatusID.equals("045"))   // �p�� n��, �Y�� n-1�� --> �� n ��(�̫�@��)
{  //out.print("actionID="+actionID+"<BR>");
	String fndUserName = "";  //�B�z�H��
	String fndUserID = ""; //�B�z�H��ID (3077)
	String employeeID = ""; // �B�z�H���u��ID(2487)
	String woUOM = ""; // �u�O�������
	String compSubInventory = null;
	int primaryItemID = 0;
    float runCardQtyf=0,overQty=0; 
	entityId = "0"; // �u�Owip_entity_id
	boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
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
                compSubInventory = rsUOM.getString("COMPLETION_SUBINVENTORY");	  // �J�wsubInventory
			}
			rsUOM.close();
			stateUOM.close();
	  	}
	  
	  	for (int i=0;i<aMFGRCPOReceiptCode.length-1;i++)
	  	{
	   		for (int k=0;k<=choice.length-1;k++)    
       		{
	    		// �P�_�QCheck ��Line �~��������@�~
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
		  
		  			if (Float.parseFloat(aMFGRCPOReceiptCode[i][2])>=0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
		  			{
		   				int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
		   				int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   				if (aMFGRCPOReceiptCode[i][5]==null || aMFGRCPOReceiptCode[i][5]=="0" || aMFGRCPOReceiptCode[i][5].equals("0")) 
		   				{ // �Y�L�U�@���Ǹ�,�h��ܥ����Y���̲ׯ�,�����ʧ@�]�w�����u
		     				toIntOpSType = 3; 
		     				aMFGRCPOReceiptCode[i][5] = aMFGRCPOReceiptCode[i][4]; // �L�U�@����Seq No,�G������
			 				transType = 2;
		   				}  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)
		   				
						float  rcMQty = 0;   
		   				float  rcScrapQty = 0;  
		   				java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 

		   				String supplierLotNo = null;
		   				boolean prevMoveTxnErr= false;  // �e��������T���` $$$$
		   				boolean rcvPOCheck = true; // �w�e�~PO���ƵL�~	####	 
						String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY , a.WAFER_LOT_NO , b.RES_EMPLOYEE_OP   "+
						                 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
 									     "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.organization_id = c.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+ //20091123 liling add organization_id
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2  "+ 
										 "     and b.RUNCARD_NO='"+aMFGRCPOReceiptCode[i][1]+"' ";
						if (jobType==null || jobType.equals("1"))
						{  
							sqlMQty = sqlMQty + "  and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // ��QUEUE�����ƶq,�~�]���Ʀ��i��U�@���O���u�� 
							                     "  and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][3]+"' "; 							
						}
						else 
						{ 	
							// ���u	
							if (aMFGRCPOReceiptCode[i][3]==null || aMFGRCPOReceiptCode[i][3]=="" || aMFGRCPOReceiptCode[i][3].equals(""))		
							{ // �毸(�~�])����
								sqlMQty = sqlMQty + " and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // �~�]���Ʀ��i��U�@���O���u�� 
								                    " and c.FM_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' ";	
							}
							else 
							{	// �h��(�~�])����			        
							    sqlMQty = sqlMQty + " and c.TO_INTRAOPERATION_STEP_TYPE in ( 1,3 ) "+ // �~�]���Ʀ��i��U�@���O���u�� 
								                    " and c.TO_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' ";	
							}		
						}												 				 
						Statement stateMQty=con.createStatement();
                        ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						if (rsMQty.next())
						{						  
							if (aMFGRCPOReceiptCode[i][2]==null || aMFGRCPOReceiptCode[i][2].equals("null")) 
						   	{  
								aMFGRCPOReceiptCode[i][2]=Float.toString(rcMQty); } //��ܲ����ƻP���ƼƬۦP,�G���o�� = 0
						   		rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//��e�����u�ƶq
                           		txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090603 �������	

						   		rcScrapQty = rcMQty - Float.parseFloat(aMFGRCPOReceiptCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq(in_to_move)						   
						   		supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // �����ӧ帹
						   
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
									{   // �L�e��, �毸���u
								    	prevMoveTxnErr= false;
									} 
									else 
									{
										prevMoveTxnErr = true;    // �h�����u,���`������e�@��������T,
									}
								} 
                                else 
								{ 								         							         
									prevMoveTxnErr = true;    // ���`������e�@��������T,	
								}					 
						    }
						 	rsMQty.close();
						 	stateMQty.close();

           					if ( txnDate==null || txnDate=="" || txnDate.equals("") || txnDate=="null" || txnDate.equals("null")) txnDate=systemDate; //20090605 liling �W�[�Y�Skey�N�w�]systemdate
  
           					if (UserRoles.indexOf("admin")>=0) // �޲z�� 
		   					{
			    				rcScrapQty = Float.parseFloat(aMFGRCPOReceiptCode[i][21]);  // 2007/03/30 ���եH��ʿ�J�����o�� By Kerwin
		   					}			  
	       					//��������ƶq�����,�íp�⥻�����o�ƶq_��
		   
		 					// �������o Scrap Account ID_�_//  ��Organization_id ���w�]�� Scrap Acc ID
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
		 	 
		 					String getErrScrapBuffer = "";
		 					int getRetScrapCode = 0;
		 					if (rcScrapQty>0 && !prevMoveTxnErr)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
		 					{	
		   						toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
		   						transType = 1; // ���o��Transaction Type = 1(Move Transaction)
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
							   	scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/08 �אּRunning ) 
							   	scrapstmt.setFloat(7,rcScrapQty); out.print("<BR>�y�{�d:"+aMFGRCPOReceiptCode[i][1]+"(3.���o�ƶq="+rcScrapQty+") ");     	   
							   	scrapstmt.setString(8,woUOM);
							   	scrapstmt.setInt(9,Integer.parseInt(entityId));  
							   	scrapstmt.setString(10,woNo);  
							   	scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
							   	scrapstmt.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(����)		  
							   	scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
							   	scrapstmt.setInt(14,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); // TO_OPERATION_SEQ_NUM  //���o�Y��From = To
							   	scrapstmt.setString(15,aMFGRCPOReceiptCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
							   	scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							   	scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)���o  ( 01-11-000-7650-951-0-000 ) 
							   	scrapstmt.setInt(18,7);	// REASON_ID  �s�{���`
							   	scrapstmt.executeUpdate();
							   	scrapstmt.close();	      	
		   
		   						//����g�JInterface��Group����T_�_
	       						int groupID = 0;
		   						int opSeqNo = 0;              
						 		String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     		" where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id='"+organizationID+"' "+  //20091123 liling add organization_id
										 		" and ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										 		" and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
										 		" and TO_INTRAOPERATION_STEP_TYPE = 5   "; // ���������o��group
						 		Statement stateGrp=con.createStatement();
                         		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 		if (rsGrp.next())
						 		{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 		}
						 		rsGrp.close();
						 		stateGrp.close();

		 						if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 						{
		   							int procPhase = 1;
		   							int timeOut = 10;
		   							try
		   							{	
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
							 				out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"���o���~��]="+getErrScrapBuffer+"<BR>");
						  				}						  					  
									}	  
									catch (Exception e) 
									{ 
										out.println("Exception6:"+e.getMessage()); 
									}  
		  						}
		 					}
          					// �I�s Package ��Procedure Interface APIs ���覡_�_(�~�]PO����_RECEIVE)	
		  					int requestID = 0;
		  					int rcptReqID = 0;  // �Ĥ@��Receipt ��Request ID,�@���P�_�O�_���Ʀ��\��RequestID
		  					String devStatus = "";
		  					String devMessage = "";
		  					String rvcGrpID = "0";
		  					respID = "";
		  
  							if (!prevMoveTxnErr) //�����e�����T������T,�~�����compSubInventory���ܮw,�_�h���������PO���Ƨ@�~
  							{	  
		   						//�����o�����沣��PO��Responsibility ID_�_
	          					Statement stateResp=con.createStatement();	   
	          					ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME like 'YEW_PO_SEMI_SU%' "); 
	          					if (rsResp.next())
	          					{
	           						respID = rsResp.getString("RESPONSIBILITY_ID");
	          					} 
								else 
								{
	                  				respID = "50799"; // �䤣��h�w�] --> YEW PO SEMI Super User �w�]
	                 			}
			         			rsResp.close();
			         			stateResp.close();	  	
	       
		   						//�����o�����沣��PO��Responsibility ID_��
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
									 	cs3.setDate(2,receivingDate);                  //���Ƥ��
									 	cs3.setInt(3,Integer.parseInt(fndUserID));  //out.println("fndUserID="+fndUserID);   // FND_USER ID  3077   
									 	cs3.setInt(4,Integer.parseInt(aMFGRCPOReceiptCode[i][11]));  //out.println("aMFGRCPOReceiptCode[i][11]=PO_HEADER_ID="+aMFGRCPOReceiptCode[i][11]+"<BR>");// PO-HeADER_ID
									 	cs3.setInt(5,Integer.parseInt(aMFGRCPOReceiptCode[i][12]));  //out.println("aMFGRCPOReceiptCode[i][12]=PO_LINE_ID="+aMFGRCPOReceiptCode[i][12]+"<BR>");// PO_LINE_ID
									 	cs3.setFloat(6,Float.parseFloat(aMFGRCPOReceiptCode[i][9]));//out.println("aMFGRCPOReceiptCode[i][9]="+aMFGRCPOReceiptCode[i][9]+"<BR>"); // ���Ƽƶq  
									 	cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER�B�z�T�� 
									 	cs3.registerOutParameter(8, Types.VARCHAR); //   LINE�B�z�T��  
									 	cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
										cs3.registerOutParameter(10, Types.VARCHAR); //  HEADER error�T�� 
									 	cs3.registerOutParameter(11, Types.VARCHAR); //  LINE error�T�� 
									 	cs3.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][13]));  // out.println("aMFGRCPOReceiptCode[i][13]=LINE_LOCATION_ID="+aMFGRCPOReceiptCode[i][13]);//PO_LOCATION_LINE_ID
									 	cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID --> 2487������
									 	cs3.setInt(14,0);   //FROM ORG_ID					
									 	cs3.setInt(15,Integer.parseInt(rs.getString("ORGANIZATION_ID"))); //Integer.parseInt(rs.getString("ORGANIZATION_ID"))// SUB_INVENTORY   INSPECTION���ε�	
									 	cs3.setString(16,"");   // SUB_INVENTORY  (RECEIVE)���ε�
									 	cs3.setString(17,aMFGRCPOReceiptCode[i][10]);     // out.println("aMFGRCPOReceiptCode[i][10]="+aMFGRCPOReceiptCode[i][10]);// COMMENTS aIQCReceivingBean[i][10]	�u������
									 	cs3.setString(18,"");            // LINE�d�ߪ�_RECEIPT_NO	
									 	cs3.setString(19,"RECEIVE");      // I_TXN_TYPE 	
									 	cs3.setString(20,"");            // �W�@�Ӥ�����������RECEIVE
									 	cs3.setString(21,"RECEIVING");  // �������窺DESTNATION TYPE CODE�� RECEIVING			      			     			     
									 	cs3.execute();
									 	// out.println("Procedure : Execute Success !!! ");
									 	statusMessageHeader = cs3.getString(7);	             
									 	statusMessageLine = cs3.getString(8);
										headerID = cs3.getInt(9);                 // ��ĤG������s Header ID ����
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
							   				cs4.setString(1,rvcGrpID);			                        // ������ RCV Processor Group ID
			  	               				cs4.setInt(2,Integer.parseInt(fndUserID));                   //USER REQUEST 
							   				cs4.setInt(3,Integer.parseInt(respID));                      //RESPONSIBILITY ID 
				               				cs4.registerOutParameter(4, Types.INTEGER);                  //�^�� REQUEST_ID
							   				cs4.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
							   				cs4.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
						       				cs4.execute();
               	   		       				requestID = cs4.getInt(4);   //  �^�� REQUEST_ID
							   				devStatus = cs4.getString(5);   //  �^�� REQUEST ���檬�p
							   				devMessage = cs4.getString(6);   //  �^�� REQUEST ���檬�p�T��
				               				cs4.close();	
							   				rcptReqID = requestID;	// ��Receipt �� Request ID��rcptReqID
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
			   						statement.close();	 // ��������X�檺While							 		
		      					}
		      					catch (Exception e) 
		      					{ 
									out.println("Exception7:"+e.getMessage()); 
								}		   
           						/* 20200703 Marvie Del : 1 receipt interface �i���� receipt delivery �ʧ@
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
				 						cs3.setDate(2,receivingDate);                   //���Ƥ��
				 						cs3.setInt(3,Integer.parseInt(fndUserID));     // FND_USER ID  3077   
									 	cs3.setInt(4,Integer.parseInt(aMFGRCPOReceiptCode[i][11]));  
									 	cs3.setInt(5,Integer.parseInt(aMFGRCPOReceiptCode[i][12]));  
									 	cs3.setDouble(6,Double.parseDouble(aMFGRCPOReceiptCode[i][9])); // ���Ƽƶq  
									 	cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER�B�z�T�� 
									 	cs3.registerOutParameter(8, Types.VARCHAR); //   LINE�B�z�T��  
									 	cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
									 	cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error�T�� 
									 	cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error�T�� 
									 	cs3.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][13]));   //PO_LOCATION_LINE_ID
									 	cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID --> 2487������
									 	cs3.setInt(14,0);   //FROM ORG_ID					
									 	cs3.setInt(15,Integer.parseInt(rs.getString("ORGANIZATION_ID"))); // 	
									 	cs3.setString(16,"");   // SUB_INVENTORY  (RECEIVE)���ε�
									 	cs3.setString(17,aMFGRCPOReceiptCode[i][10]);      // COMMENTS aIQCReceivingBean[i][10]	�u������
									 	cs3.setString(18,"");            // LINE�d�ߪ�_RECEIPT_NO	
									 	cs3.setString(19,"DELIVER");      // I_TXN_TYPE 	
									 	cs3.setString(20,"RECEIVE");            // �W�@�Ӥ�����������RECEIVE
									 	cs3.setString(21,"SHOP FLOOR");  // �������窺DESTNATION TYPE CODE�� RECEIVING			      			     			     
									 	cs3.execute();
									 	// out.println("Procedure : Execute Success !!! ");
									 	statusMessageHeader = cs3.getString(7);	             
									 	statusMessageLine = cs3.getString(8);
									 	headerID = cs3.getInt(9);   // ��ĤG������s Header ID ����
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
							   				cs4.setString(1,rvcGrpID);			                        // ������ RCV Processor Group ID
			  	               				cs4.setInt(2,Integer.parseInt(fndUserID));                   //USER REQUEST 
							   				cs4.setInt(3,Integer.parseInt(respID));                      //RESPONSIBILITY ID 
				               				cs4.registerOutParameter(4, Types.INTEGER);                  //�^�� REQUEST_ID
							   				cs4.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
							   				cs4.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
						       				cs4.execute();
               	   		       				requestID = cs4.getInt(4);   //  �^�� REQUEST_ID
							   				devStatus = cs4.getString(5);   //  �^�� REQUEST ���檬�p
							   				devMessage = cs4.getString(6);   //  �^�� REQUEST ���檬�p�T��
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
			   						statement.close();	 // ��������X�檺While							 		
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
			     					rcvPOQty = rsRCVChk.getFloat(1); // �i�A�P�_�O�_������;		 
				 					rcvPOCheck = true; 
			  					} 
								else 
								{
			             			String sqlRCVErr = "select ERROR_MESSAGE, TABLE_NAME, COLUMN_NAME from PO_INTERFACE_ERRORS where REQUEST_ID ="+rcptReqID+" ";
			             			Statement stateRCVErr=con.createStatement();	
						 			ResultSet rsRCVErr=stateRCVErr.executeQuery(sqlRCVErr);
						 			if (rsRCVErr.next())
						 			{
			              				out.println("<font color='#FF0000'>�t�Ψå����T����e�~�[�u���Ƨ@�~,�Ь��t�κ޲z���B�z</font><BR>");
						  				out.println("<font color='#FF0000'>���~�T��:("+rsRCVErr.getString(1)+")<BR>��ƪ�("+rsRCVErr.getString(2)+") ���W("+rsRCVErr.getString(3)+")</font><BR>");
						  				rcvPOCheck = false; // �]�w�����`,�����沾��SEQ ID�Ϊ��A��sSQL
						 			} 			             
			         			}
					 			rsRCVChk.close();
					 			stateRCVChk.close();
								
								*/  // 20200703 Marvie Del : 1 receipt interface �i���� receipt delivery �ʧ@
   							}
     						
							String getErrBuffer = "",overFlag="";
	 						int getRetCode = 0; 
	 						float prevQty = 0;    	 	   		     
	 						if (getRetScrapCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // �Y�������o�Ωe�~PO���Ʀ��\,�h�i�沾��Interface
	 						{		         
								if (getRetScrapCode==0) // �Y����P�@�����o���\,�~���沾�U�@���ʧ@_�_
								{ 
					  				float remainQueueQty=0;
					  				Statement stateRM=con.createStatement();
                      				ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id="+organizationID+" and OPERATION_SEQ_NUM = "+aMFGRCPOReceiptCode[i][4]+" ");  //20091123 liling add organization_id
			          				if (rsRM.next()) { remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); }
			          				rsRM.close();
	   		          				stateRM.close();					  
		
           							//�P�_�O�_��overcompletion
             						String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
						   						  " where step_type=1 and FM_OPERATION_SEQ_NUM  = "+aMFGRCPOReceiptCode[i][3]+" "+
						   						  " and runcard_no = '"+aMFGRCPOReceiptCode[i][1]+"' ";
            						// out.print("sqlpre="+sqlpre);
									Statement statepre=con.createStatement();
            						ResultSet rspre=statepre.executeQuery(sqlpre);
									if (rspre.next())
									{
			  							prevQty = rspre.getFloat(1);  //�e�������ƶq
									}
            						if ( (aMFGRCPOReceiptCode[i][3]==null || aMFGRCPOReceiptCode[i][3].equals("")) && prevQty==0 )
            						{  prevQty= runCardQtyf;  }   //�Y�e�@����null��ܨS���e��,�B��쪺�����Ƭ�0,�h�w�]�e����=�y�{�d��  2007/03/13 liling OSP���u�Ĥ@���L�k�W�����D 

		    						rspre.close();
									statepre.close();
	 	  
									//add by Peggy 20140324
									if (rcScrapQty >0)
									{
										//prevQty	=prevQty -Float.parseFloat("0"+rcScrapQty);
										//�ѨM�B�I�ƭp����D,add by Peggy 20140417
										prevQty	=(prevQty*1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
										prevQty = prevQty/1000;
									}
									if (prevQty<0) prevQty=0;
									//out.println("prevQty="+prevQty);
					  
		  							if (Float.parseFloat(aMFGRCPOReceiptCode[i][2]) > prevQty && remainQueueQty > Float.parseFloat(aMFGRCPOReceiptCode[i][2])  )   //�Y�����Ƥj��e�������ƶq,���overcompletion
          							{
            							//overQty = Float.parseFloat(aMFGRCPOReceiptCode[i][2]) - prevQty ;    //������-�e�������ƶq=�W�X�ƶq
										//�ѨM�B�I�ƭp����D,add by Peggy 20140417
										overQty = (Float.parseFloat(aMFGRCPOReceiptCode[i][2])*1000) - (prevQty*1000) ;    //������-�e�������ƶq=�W�X�ƶq										
										overQty = overQty /1000;
            							overFlag = "Y";   //���w�W����flag
										//out.println("1.overQty="+overQty);
          							}
									else  
									{     
					  					if (Float.parseFloat(aMFGRCPOReceiptCode[i][2]) > remainQueueQty)
					  					{
					    					//overQty = Float.parseFloat(aMFGRCPOReceiptCode[i][2])-remainQueueQty; 
											//�ѨM�B�I�ƭp����D,add by Peggy 20140417
											overQty = (Float.parseFloat(aMFGRCPOReceiptCode[i][2])*1000)-(remainQueueQty*1000); 
											overQty = overQty/1000;
											overFlag = "Y";   //���w�W����flag
											//out.println("2.overQty="+overQty);
					  					} 
										else 
										{
					           				overFlag = "N"; 
					         			}	    
			     					}
		   							
									toIntOpSType = 3;  // ���u������to InterOperation Step Type = 3
		   							transType = 1;     // ���u�� Transaction Type(�אּ Move Transaction,��MMT�h�M�w�N�u��Complete)		   
		   							if (actionID.equals("006")) toIntOpSType= 1;	         // �Y�����̫᯸,�~��(TRANSFER)
		   							else if (actionID.equals("018")) toIntOpSType = 3;	 // �̫᯸,���u(RECEIVE)
		   
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
           							seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error ( 2006/12/08 �אּ Running )
		   							seqstmt.setFloat(7,Float.parseFloat(aMFGRCPOReceiptCode[i][2])); // 2006/12/08 �令���ഫ�Ჾ����, �����ƶq aMFGRCPOReceiptCode[i][14]
           							seqstmt.setString(8,woUOM);
	       							seqstmt.setInt(9,Integer.parseInt(entityId));  
	       							seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
	       							seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       							seqstmt.setInt(12,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
	       							seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       							seqstmt.setInt(14,Integer.parseInt(aMFGRCPOReceiptCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
	       							seqstmt.setString(15,aMFGRCPOReceiptCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
		   							seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   							if (overFlag == "Y" || overFlag.equals("Y"))
            						{ 
										seqstmt.setFloat(17,overQty); 
									} // OVERCOMPLETION_TRANSACTION_QTY              
									seqstmt.executeUpdate();
           							seqstmt.close();	  
		   
		   							//����g�JInterface��Group����T_�_
	       							int groupID = 0;
		   							int opSeqNo = 0;              
									String sqlGrp = " select GROUP_ID, TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									                " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id="+organizationID+" "+ //20091123 liling add organization_id
										            " and PROCESS_STATUS = 2 "+ // 2006/11/18 By Process Status=1
										            " and ATTRIBUTE2 = '"+aMFGRCPOReceiptCode[i][1]+"' "; // ������������Group ID�����u
						 			if (actionID.equals("006")) sqlGrp = sqlGrp+" and TO_INTRAOPERATION_STEP_TYPE = 1 "; // �٦��U�@��(TRANSFER)
						 			else if (actionID.equals("018")) sqlGrp = sqlGrp+" and TO_INTRAOPERATION_STEP_TYPE = 3 ";	//���u(RECEIVE)
						
						 			Statement stateGrp=con.createStatement();
                         			ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 			if (rsGrp.next())
						 			{
						   				groupID = rsGrp.getInt("GROUP_ID");
						   				opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 			}
						 			rsGrp.close();
						 			stateGrp.close();

		 							if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
		 							{
		   								int procPhase = 1;
		   								int timeOut = 10;
		   								try
		   								{	
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
							 					out.println("getRetCode="+getRetCode+"&nbsp;"+"�������~��]="+getErrBuffer+"<BR>");
						  					}							  
										}	  
										catch (Exception e)
			 							{ 
											out.println("Exception9:"+e.getMessage()); 
										}  
		  							} // end of if (groupID>0 && opSeqNo>0)			 
								} // End of if (getRetScrapCode=0) 
								
				  //20200506 liling liling ������J�w�ʧ@,���WMS���� --�_
				 /*
  								if (actionID.equals("018")) // �̫᯸,���u �~��MMT Interface
  								{		 	  
		 							try
		 							{
	   									// -- ������MMT ��Transaction ID �@��Group ID
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
							                               " ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',? ,5 ) ";  // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error�i�H���s�QRepeocess)
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
		  								mmtStmt.setString(13,aMFGRCPOReceiptCode[i][1]);                   //ATTRIBUTE2  LOT_NO (�y�{�d��)
		  								mmtStmt.setString(14,aMFGRCPOReceiptCode[i][1]);                  //VENDOR_LOT_NUMBER  LOT_NO (�y�{�d��)
          								mmtStmt.executeUpdate();
          								mmtStmt.close();		
		  
		    							String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
		                                                      "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
								                              "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ) "+ 
								                              "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?) ";
	        							PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
										mmtLotStmt.setString(1,aMFGRCPOReceiptCode[i][1]);    // LOT_NUMBER(�y�{�d��)
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
   
   									//���� MMT��MMT LOT Interface Submit Request
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
	           								respID = "50757"; // �䤣��h�w�] --> YEW INV Super User �w�]
	         							}
			 							rsResp.close();
			 							stateResp.close();	  			 
			 
	  									// -- ������MMT ��Transaction Header ID �@��Group Header ID
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
	             						cs3.registerOutParameter(3, Types.VARCHAR);  //�^�� x_returnStatus
				 						cs3.registerOutParameter(4, Types.VARCHAR);  //�^�� x_errorMsg				
	             						cs3.execute();
                 						out.println("<BR>Procedure : Execute Success !!! ");	             
				 						devStatus = cs3.getString(3);    // �^�� x_returnStatus
				 						devMessage = cs3.getString(4);   // �^�� x_errorMsg
                 						cs3.close(); 		 
							 
				 						Statement stateError=con.createStatement();
			     						String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
                 						ResultSet rsError=stateError.executeQuery(sqlError);	
				 						if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // �s�b ERROR �����,��Interface�Ө��|�gErrorCode���
				 						{ 
					   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
				  	   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
					   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					   						woPassFlag="N";						   
					 						errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
				 						}
				 						rsError.close();
				 						stateError.close();
				 
				 						if (errorMsg.equals("")) //�YErrorMessage���ŭ�,�h���Interface���\�Q�g�JMMT,�^�����\Request ID
				 						{	
				   							out.println("Success Submit !!! "+"<BR>");
				   							out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   							woPassFlag="Y";	// ���\�g�J���X��
				   							con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
				 						}
	   								}// end of try
       								catch (Exception e)
       								{
           								out.println("Exception WIP_MMT_REQUEST:"+e.getMessage());
       								}	
	 							} // End of  if (actionID.equals("018")) 	 // �̫᯸,���u �~��MMT Interface
						*/ //20200506 liling ������J�w�ʧ@,���WMS���� --��
  							} // End of if (getRetScrapCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // �Y�������o�Ωe�~PO���Ƴ����\,�h�i�沾��Interface
   
							if (getRetScrapCode==0 && getRetCode==0 && rcvPOCheck==true && !prevMoveTxnErr) // �Y���o�β����Ωe�~���Ƴ����榨�\,�h����WIP�t�άy�{�β��ʧ�s
							{ 
           						// �Y���\,�h��sRUNCARD ��ƪ�������
								boolean singleOp = false;  // �w�]���������̫�@��
		    					String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			                          " DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					      				      "  from WIP_OPERATIONS "+						  
			                                  "  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' "+ // 2006/10/26 (����)�O���F�n���U�@����T�@��s
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
				  						out.println("������,�U�@���N�X="+nextOpSeqNum);
									}  	
	       						} 
								else 
								{ 
					 				// �����Y���̫�@��,�G�ݧ�s���A�� 046 (���u�J�w)					 
					 				Statement stateMax=con.createStatement();
                     				ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCPOReceiptCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id="+organizationID+" ");  //20091123 liling add organization_id
					 				if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
					 				{
					   					singleOp = true;					   
					 				} else out.println("�U�@�������̫᯸="+rsMax.getString(1));
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
           						queueTransStmt.setInt(6,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //FM_OPERATION_SEQ_NUM(����) 
		   						if (standardOpDesc==null || standardOpDesc.equals("") || standardOpDesc.equals("null")) standardOpDesc="�w��~�]";	//20130123			      
		   						queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
           						queueTransStmt.setInt(8,Integer.parseInt(aMFGRCPOReceiptCode[i][5])); //TO_OPERATION_SEQ_NUM(�U�@��) 
	       						queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
	       						queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCPOReceiptCode[i][2]));  // Transaction Qty
	       						queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       						queueTransStmt.setInt(12,1);             // 1=Queue		  
	      		 				queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       						queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
	       						queueTransStmt.setString(15,"045"); // From STATUSID
		   						queueTransStmt.setString(16,"OSPRECEIVING");	  // From STATUS
		   						queueTransStmt.setString(17,fndUserName);	  // Update User  
	       						queueTransStmt.setString(18,aMFGRCPOReceiptCode[i][16]);  // osp_po_num  20200911 Marvie Add : trace
	       						queueTransStmt.setFloat(19,Float.parseFloat(aMFGRCPOReceiptCode[i][9]));  // osp_rec_qty  20200911 Marvie Add : trace
           						queueTransStmt.executeUpdate();
           						queueTransStmt.close();	    	 
								
								if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
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
           							scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //FM_OPERATION_SEQ_NUM(����)   
		   							if (standardOpDesc==null || standardOpDesc.equals("") || standardOpDesc.equals("null")) standardOpDesc="�w��~�]";	//20130123			    
		   							scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
           							scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCPOReceiptCode[i][4])); //TO_OPERATION_SEQ_NUM(�U�@��) 
	       							scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(�U�@���N�X) 
	       							scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
	       							scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
	       							scrapTransStmt.setInt(12,5);             // 5=SCRAP(���o)		  
	       							scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
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
		      						if (actionID.equals("018")) // (RECEIVE) ��ܤU�@�����̫�@��,�L�ݧ�s�y�{�dOperation���A
			  						{		  
		       							String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
		                                             " QTY_IN_SCRAP=?, CLOSED_DATE=?, COMPLETION_QTY=?, "+
						                             " QTY_IN_COMPLETE=?, QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP�M���ť�,�����ɤ~�|��t�Τ�"+
		                                             " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCPOReceiptCode[i][0]+"' "; 	
                						PreparedStatement rcStmt=con.prepareStatement(rcSql);
	            						rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	            						rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		        						if (!singleOp) // �Y�U�@�������̫᯸,�h�����b (046) �y�{�d�ݤJ�w��
		        						{ 
											out.println(aMFGRCPOReceiptCode[i][1]+" �U�@������:"+getStatusRs.getString("STATUSNAME"));
	              							rcStmt.setString(3,"046"); 
	              							rcStmt.setString(4,"COMPLETING");
		        						} 
										else 
										{ 
				        					if (jobType==null || jobType.equals("1"))
											{
				          						out.println("  "+aMFGRCPOReceiptCode[i][1]+"�U�@������:CLOSING<br>");
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
						   
											// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_
				 							Statement stateParRC=con.createStatement();
                 							ResultSet rsParRC=stateParRC.executeQuery("select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+aMFGRCPOReceiptCode[i][1]+"' ");
				 							if (rsParRC.next())
				 							{
				    							PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCPOReceiptCode[i][2])+" where RUNCARD_NO='"+rsParRC.getString("PRIMARY_NO")+"' ");
												rcStmtUP.executeUpdate();   
                    							rcStmtUP.close(); 
				 							}
				 							rsParRC.close();
				 				
							   				// ���u�J�w�ݤ@�֧�sYEW_WORKORDER_ALL_�_							   
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
							  
							 				//��l������y�{�d���u�O���NWO_USED_QTY���@�֥[_�_
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
										rcStmt.setFloat(10,Float.parseFloat(aMFGRCPOReceiptCode[i][2])+rcScrapQty);	 // �B�z��	
                						rcStmt.executeUpdate();   
                						rcStmt.close(); 
			  						} 
									else if (actionID.equals("006")) // (TRANSFER) ��ܻ��~�򲾯�,��s�y�{�d��OperationNum��ID
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
							                         " QTY_IN_COMPLETE=?, QTY_IN_QUEUE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090603 liling add RES_EMPLOYEE_OP�M���ť�,�����ɤ~�|��t�Τ�
		                                             " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCPOReceiptCode[i][0]+"' "; 	
                            			PreparedStatement rcStmt=con.prepareStatement(rcSql);
	                        			rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	                        			rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		                    			out.println(aMFGRCPOReceiptCode[i][1]+" �U�@������:"+getStatusRs.getString("STATUSNAME"));
						      			// �_�h,�Y��s�� 046 �y�{�d�ݧ��u�J�w
							        	out.println("nextOpSeqNum="+nextOpSeqNum);
				                    	out.println("�U�@������(Line 3246):"+rcStatusDesc);
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
										rcStmt.setFloat(14,Float.parseFloat(aMFGRCPOReceiptCode[i][2])+rcScrapQty); // �B�z��	
                            			rcStmt.executeUpdate();   
                            			rcStmt.close(); 									       
			         				}
		    					}  // End of if (errorMsg.equals(""))	   
		  					} // End of if (getRetScrapCode==0 && getRetCode==0 && !prevMoveTxnErr) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s    
		  					else 
							{
		         				interfaceErr = true; // ���o�β��������`,JavaScript�i���ϥΪ�
				 				if (prevMoveTxnErr)
				 				{
				  				%>
				   				<script language="javascript">
				     				alert("�e���������`,��MIS�d����]!!!");
				   				</script>
				  				<%
				 				}
								else if (rcvPOCheck==false)
				        		{
				          		%>
				             	<script language="javascript">
				              		alert("�e�~�[�u���Ʋ��`,��MIS�d����]!!!");
				             	</script>
				          		<%
				        		} 
								else if (getRetScrapCode!=0)
						       	{
							    %>
				                <script language="javascript">
				                	alert("�������Ƴ��o���`,��MIS�d����]!!!");
				                </script>
				                <%
							   	}						
		       				}
		 				} //End of if (aMFGRCPOReceiptCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o	
        			} // End of if (choice[k]==aMFGRCPOReceiptCode[i][0] || choice[k].equals(aMFGRCPOReceiptCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s
     		} // End of for (i=0;i<aMFGRCPOReceiptCode.length;i++)
   		} // end of if (aMFGRCPOReceiptCode!=null) 
		out.print("<BR><font color='#0033CC'>�y�{�d���Ʋ���O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	
    	// �ϥΧ����M��2���}�C
    	if (aMFGRCPOReceiptCode!=null)
		{ 
	  		arrMFGRCPOReceiptBean.setArray2DString(null); 
		}
	} // End of if (actionID.equals("012") && fromStatusID.equals("045"))
	//MFG�y�{�d���u�J�w_��	(ACTION=012)   �y�{�d������044 --> �y�{�d�ݦ��Ƥ�045(�ݧP�_�O�_�������̫�@��)
  
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
    	<td width="278"><font size="2">WIP��ڳB�z</font></td>
    	<td width="297"><font size="2">WIP�d�ߤγ���</font></td>    
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
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

