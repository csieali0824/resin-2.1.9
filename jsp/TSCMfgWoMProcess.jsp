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
<jsp:useBean id="arrMFG2DRunCardBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d�w�i�}-> �y�{�d������ -->
<jsp:useBean id="arrayLotIssueCheckBean" scope="session" class="ArrayCheckBoxBean"/>   <!--FOR ��q�y�{�d�ݧ벣 Match��ڧ��u�e�q�帹-->
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d������-> �y�{�d������ -->
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d������-> �y�{�d���u�J�w -->
<jsp:useBean id="arrMFGRCDeleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d�w�i�}-> �y�{�d�R�� liling --> 
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
String routingRefID      = "0";

String runCardCount=String.valueOf(runCardCountI);  //�y�{�d�i��

String dateCodeSet = request.getParameter("DATECODE");  // �妸���w���벣DateCode

//out.print("woNo="+woNo+"<br>");
//out.print("����ƶq="+runCardCountD);

if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   

// MFG�u�O���_�Ѽƨ�

// 2005/12/03 ��session ��Bean ��������ͺޫ����������N�X // By Kerwin

String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR �~������ƾڿ�J�����P�w
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR �y�{�d�w�i�}-> �y�{�d������
String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR �y�{�d������-> �y�{�d������
String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR �y�{�d������-> �y�{�d���u�J�w
String aMFGRCDeleteCode[][]=arrMFGRCDeleteBean.getArray2DContent();  	// FOR �y�{�d�w�i�}-> �y�{�d�R�� liling
String aMFGLotMatchCode[][]=arrayLotIssueCheckBean.getArray2DContent();  // FOR ��q�y�{�d�ݧ벣 Match��ڧ��u�e�q�帹

// 2004/07/08 ��session ��Bean �����������覡�����N�X // By Kerwin

//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//�O�_�nSEND MAIL
String adminModeOption=request.getParameter("ADMINMODEOPTION");//�O�_���޲z���Ҧ�

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

// ���s�J����榡��US�Ҷq,�N�y�t���]������
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
//�����s�ɫ�^�_	  

//����t�Τ��
String systemDate ="";
Statement statesd=con.createStatement();
ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
if (sd.next())
{
	systemDate=sd.getString("SYSTEMDATE");	 
}
sd.close();
statesd.close();	

// �������� organization_code �qORG�Ѽ���
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
	errorFlag ="000000";
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
	//out.println("sqlStat="+sqlStat);
	//"select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
	Statement getStatusStat=con.createStatement();  
	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
	getStatusRs.next();

	//out.println("Step0");

	// Move TSCMfgWoExpandMProcess.jsp
	
	errorFlag ="042>044";
	//MFG�y�{�d������_�_	(ACTION=006)   �y�{�d�w�i�}042->�y�{�d������ 044
	if (actionID.equals("006") && fromStatusID.equals("042"))   // �p��n��, �Y �Ĥ@�� --> �ĤG�� --> �� n-1 ��
	{   //out.println("fromStatusID="+fromStatusID);
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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_	                     
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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 

				//��������ƶq�����_�_	                     
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
								toIntOpSType = 3; 
								aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // �L�U�@����Seq No,�G������
								transType = 1; //(���u�ѤJ�w��۰ʰ���,�G���]��1)
							}  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)

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
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	 (2006/12/07 �אּ 2, �쬰 1)     
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�y�{�d:"+aMFGRCExpTransCode[i][1]+"(���o�ƶq="+rcScrapQty+")<BR>");        	   
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
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 -- By Process Status=1
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
								//out.println("<BR>���o��groupID ="+groupID+"<BR>");
								//out.println("Step1");	 
								if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
								{
									// �Y�ɩI�s WIP_MOVE PROCESS WORKER		  
									int procPhase = 1;
									int timeOut = 10;
									try
									{	        /*
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
										*/

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
									}	  
									catch (Exception e) { out.println("Exception���o��groupID:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
							// *****%%%%%%%%%%%%%% �������o�ƶq�ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (rcScrapQty>0)

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;	
							// float prevQty = 0; 	         
							if (getRetScrapCode==0) // �Y����P�@�����o���\,�~���沾�U�@���ʧ@_�_
							{ 

								//�P�_�O�_��overcompletion
								//����y�{�d�ƶq
								Statement stateRc=con.createStatement();
								ResultSet rsRc=stateRc.executeQuery(" SELECT runcard_qty   FROM yew_runcard_all  WHERE runcard_no = '"+aMFGRCExpTransCode[i][1]+ "'");
								if (rsRc.next())
								{ runCardQtyf = rsRc.getFloat("RUNCARD_QTY"); }
								rsRc.close();
								stateRc.close();

								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf )   //�Y�����Ƥj��y�{�d��,���overcompletion
								{
									overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //������-�y�{�d��=�W�X�ƶq
									overFlag = "Y";   //���w�W����flag
								}else  { overFlag = "N"; }
								//out.print("overQty="+overQty);    
								//out.println("Step2");
								toIntOpSType = 1;  // ������to InterOperation Step Type = 1 
								// *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  �_
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
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/07 �אּ 2, �쬰 1)    
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // �����ƶq
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
								//out.println("�ƶq="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);   //out.println("woUOM="+woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
								seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//����g�JInterface��Group����T_�_
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID, TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 -- By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 1 "; // ������������Group ID
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
								//����g�J����Interface��Group����T_��
								//out.println("<BR>������groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
								{
									// �Y�ɩI�s WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	  /*
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
										*/
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
  
										//out.println("getRetCode="+getRetCode+"&nbsp;"+"getErrBuffer="+getErrBuffer+"<BR>");

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
														 "   and TO_INTRAOPERATION_STEP_TYPE = 1 and  GROUP_ID = "+groupID+" ";   // ����������
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
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
									// *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (getRetScrapCode=0) 		 	

							// �Y���o�β��������\,�h��sRUNCARD ��ƪ�������
							if (getRetScrapCode==0 && getRetCode==0)
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
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
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
								//����wip_move_transaction���� OVERCOMPLETION_PRIMARY_QTY
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
								queueTransStmt.setFloat(18,overValue);  // overcompletion  Qty
								queueTransStmt.executeUpdate();
								queueTransStmt.close();	    	 
								//out.println("Step4");		 
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
										" QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
										" QTY_IN_QUEUE=?, RC_DATE_CODE= '"+dateCodeSet+"' "+      // 2007/11/22 By Kerwin add for Batch Update DateCode
										" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
								PreparedStatement rcStmt=con.prepareStatement(rcSql);
								//out.print("rcSql="+rcSql);           
								rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
								rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
								if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
								{
									rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
									rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
								} else { // �_�h,�Y��s�� 046 ���u�J�w
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
								// �Y����q�u�O,�h�A�g�ǰt���e�q�帹_�_		   
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
												// �R����g�J��Template

												PreparedStatement stmtDel=con.prepareStatement("delete from YEW_MFG_TRAVELS_ALL where EXTEND_NO='"+woNo+"' and EXTEND_TYPE ='3' and ( PRIMARY_NO in ('N/A',null) or EXTENDED_QTY = 0 ) "); 
												stmtDel.executeUpdate();   
												stmtDel.close(); 

											}
											rsMId.close();
											stateMId.close(); 
											// �üg�J�@���s������_�_
											//out.println("StepMatch 5:");
											if (Float.parseFloat(orgWoQty)>0) // 2006/12/20 �[�J ��t�e�q�帹 >0 �~�g
											{
												String seqSqlIns="insert into YEW_MFG_TRAVELS_ALL(PRIMARY_NO, PRIMARY_TYPE, EXTEND_NO, EXTEND_TYPE, EXTENDED_QTY, ORDER_NO, CREATED_BY, LAST_UPDATED_BY, PRIMARY_PARENT_NO, ORDER_LINE_ID, PRIMARY_LOT_QTY ) "+
													   "values(?,?,?,?,?,?,?,?,?,?,?) ";   
												PreparedStatement seqstmtIns=con.prepareStatement(seqSqlIns);        
												seqstmtIns.setString(1,aMFGLotMatchCode[m][0]); //out.println("aMFGLotMatchCode[m][0]="+aMFGLotMatchCode[m][0]); // �e�q�y�{�d��
												seqstmtIns.setString(2,"2");   //out.println("2"); // �@�ߥѫe�q�u�O���ͫ�q�u�O
												seqstmtIns.setString(3,woNo);  //out.println("woNo="+woNo);
												seqstmtIns.setString(4,woType); //out.println("woType="+woType);
												seqstmtIns.setFloat(5,Float.parseFloat(orgWoQty));  //out.println("orgWoQty="+orgWoQty);   	
												seqstmtIns.setString(6,oeOrderNo);
												seqstmtIns.setString(7,userMfgUserID);
												seqstmtIns.setString(8,userMfgUserID);
												seqstmtIns.setString(9,frontWoNo); // �D�n���Ǹ�
												seqstmtIns.setString(10,oeLineId); // ��q�涵����
												seqstmtIns.setString(11,aMFGLotMatchCode[m][1]); // �짹�u�帹�ƶq
												seqstmtIns.executeUpdate();   
												seqstmtIns.close(); 
												// �üg�J�@���s������_��
												//out.println("StepMatch 2.1:");
											} // End of if (Float.parseFloat(orgWoQty)>0)  //2006/12/20 �[�J ��t�e�q�帹 >0 �~�g
										} // End of for
									} // end of if (woType.equals("3")		 
								} // End o if (aMFGLotMatchCode!=null)           
								//out.println("StepMatch 3:<BR>");   
								// �Y����q�u�O,�h�A�g�ǰt���e�q�帹_��


							} // end of if (getRetScrapCode==0 && getRetCode==0)  -- ���o�β��������\���� 
							else {
							interfaceErr = true; // ��ܲ���Interface�����`
							} // End of else

						} // end of if (aMFGRCExpTransCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o   
						out.print("<font color='#0033CC'>�y�{�d("+aMFGRCExpTransCode[i][1]+")�w�벣O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font><BR>");   
					} // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID����}�C���e
				} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s

			} // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
		} // end of if (aMFGRCExpTransCode!=null) 

		//out.print("�y�{�d�벣O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		if (!nextOpSeqNum.equals("0") && !interfaceErr) // �Y�U�@��������̫�@���BInterface�L���`
		{
%>
<script LANGUAGE="JavaScript">
// reProcessFormConfirm("�O�_�~����榹�i�y�{�d�����@�~?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%	
		} else {
%>
<script LANGUAGE="JavaScript">
alert("Oracle�������`..�Ь�MIS�d����]!!!");
</script>
<%	
		}

		// �ϥΧ����M�� 2���}�C
		if (aMFGRCExpTransCode!=null)
		{ 
			arrMFGRCExpTransBean.setArray2DString(null); 	  
			if (woType.equals("3")) // ��q�u�O,�ݩ�벣�ɤǰt�e�q���u�帹
			{
				arrayLotIssueCheckBean.setArray2DString(null); // ���q�u�O��������Ƨ帹��M��
			}
		}

		//out.println("<BR>Done");
	}
	//MFG�y�{�d������_��	(ACTION=006)   �y�{�d�w�i�}042->�y�{�d������044   // �p��n��, �Y �Ĥ@�� --> �ĤG�� --> �� n-1 ��

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="042>046";
	//MFG�y�{�d�w�벣_�_	(ACTION=012)   �y�{�d�w�i�}042-> �y�{�d�J�w 046 �Ĥ@���Y�����u��
	if (actionID.equals("012") && fromStatusID.equals("042"))   // �p��n��, �Y �Ĥ@�� --> �� n ��
	{   //out.println("fromStatusID="+fromStatusID);
		String fndUserName = "";  //�B�z�H��
		String woUOM = ""; // �u�O�������
		String altRouting = "1"; //
		String opSupplierLot = "";
		int primaryItemID = 0; // �Ƹ�ID
		float runCardQtyf=0,overQty=0; 
		entityId = "0"; // �u�Owip_entity_id
		boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
		if (aMFGRCExpTransCode!=null)
		{	  
			if (aMFGRCExpTransCode.length>0)
			{    
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_

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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 

				//��������ƶq�����_�_	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID ,a.OE_ORDER_NO, b.QTY_IN_QUEUE, "+
							 "        a.ALTERNATE_ROUTING, a.SUPPLIER_LOT_NO, a.ORGANIZATION_ID "+ // 2007/01/18 �Y�P�_����q�~�ʤu�O,�h�H�t�ӧ帹�g�JMMT
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
				//��������ƶq�����_��   
				//out.print("<br>1.������="+Float.parseFloat(aMFGRCExpTransCode[i][2]));


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
								toIntOpSType = 3; 
								aMFGRCExpTransCode[i][5] = aMFGRCExpTransCode[i][4]; // �L�U�@����Seq No,�G������
								transType = 1; //(���u�ѤJ�w��۰ʰ���,�G���]��1)
							}  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)

							//����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
							float  rcMQty = 0;   
							float  rcScrapQty = 0; 
							String compSubInventory = null;    
							String supplierLotNo = null; 
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 
								
							String sqlMQty = " select b.QTY_IN_QUEUE, b.RUNCARD_QTY,"+  // �i�}�Y���u�J�w,�G�����sWIP_MOVE_TRANSACTIONS
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
								rcMQty = rsMQty.getFloat("QTY_IN_QUEUE");		                  //��미�ƶq			
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCExpTransCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
								compSubInventory = rsMQty.getString("COMPLETION_SUBINVENTORY");	  // �J�wsubInventory
								supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // �����ӧ帹
								//oeOrderNo = rsMQty.getString("OE_ORDER_NO");	              // �����ӧ帹

								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();

								//out.println("java�|�ˤ��J����p�ƤT��rcScrapQty="+rcScrapQty+"<BR>");	
								//out.println("adminModeOption="+adminModeOption);
								if (adminModeOption!=null && adminModeOption.equals("YES") && UserRoles.indexOf("admin")>=0)
								{
									rcScrapQty = Float.parseFloat(aMFGRCExpTransCode[i][11]); // �޲z���Ҧ�,�B��ʵ��w�F���o��,�h�H���w�����o�ƤJScrap
									userMfgUserID = "5753"; // �s�F�t�]�˯�,PANG_LIPING
								}
												   
							}
							rsMQty.close();
							stateMQty.close();
							//��������ƶq�����,�íp�⥻�����o�ƶq_��


							// out.println("sqlMQty ="+sqlMQty);

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
								transType = 1;     // ���o��Transaction Type = 1(Move Transaction)
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
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	    (2006/12/07 �אּ Running)�쬰1   
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�y�{�d:"+aMFGRCExpTransCode[i][1]+"(���o�ƶq="+rcScrapQty+")<BR>");  	       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1);     // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
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
											 "   and PROCESS_STATUS = 2 "+ // 2006/11/18 By Process --> Status=1
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
								//out.println("<BR>���o��groupID ="+groupID+"<BR>");

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
									catch (Exception e) { out.println("Exception���o��groupID:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% �������o�ƶq�ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (rcScrapQty>0)

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;		         
							if (getRetScrapCode==0) // �Y����P�@�����o���\,�~���沾�U�@���ʧ@_�_
							{  
								Statement stateRc=con.createStatement();
								ResultSet rsRc=stateRc.executeQuery(" SELECT runcard_qty FROM yew_runcard_all  WHERE runcard_no = '"+aMFGRCExpTransCode[i][1]+ "'");
								if (rsRc.next())
								{ runCardQtyf = rsRc.getFloat("RUNCARD_QTY"); }
								rsRc.close();
								stateRc.close();

								//out.print("<br>runCardQtyf="+runCardQtyf);
								// out.print("<br>move qty="+aMFGRCExpTransCode[i][2]); 
								//�P�_�O�_��overcompletion
								if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > runCardQtyf )   //�Y�����Ƥj��y�{�d��,���overcompletion
								{
									overQty = Float.parseFloat(aMFGRCExpTransCode[i][2]) - runCardQtyf ;    //������-�y�{�d��=�W�X�ƶq
									overFlag = "Y";   //���w�W����flag
								}else  { overFlag = "N"; }
								// out.print("overQty="+overQty);    
								//toIntOpSType = 1;  // ������to InterOperation Step Type = 1 
								// *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  �_
								toIntOpSType = 3;  // ���u������to InterOperation Step Type = 3
								transType = 1;     // ���u�� Transaction Type(�אּ Move Transaction,��MMT�h�M�w�N�u��Complete)
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
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/07�אּ Running) �쬰 1
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2])); // �����ƶq
								//seqstmt.setFloat(7,transactionQty); // �����ƶq  2006/12/22
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCExpTransCode[i][2])); 
								//out.println("�ƶq="+aMFGRCExpTransCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCExpTransCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCExpTransCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCExpTransCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCExpTransCode[i][5])
								seqstmt.setString(15,aMFGRCExpTransCode[i][1]);	//out.println("�y�{�d��="+aMFGRCExpTransCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//����g�JInterface��Group����T_�_
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCExpTransCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 --> By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 3 "; // ������������Group ID�����u
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
								//out.println("<BR>������groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
								{
									// �Y�ɩI�s WIP_MOVE PROCESS WORKER

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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (getRetScrapCode==0) 		 	
					
							// �Y���o�β��������\,�h��sRUNCARD ��ƪ�������
							if (getRetScrapCode==0 && getRetCode==0)
							{   // �����\������,�e�@��,����,�U�@��������TRUNCARD_ALL��ƪ��s
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // �w�]���������̫�@��
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
												"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
												"  from WIP_OPERATIONS "+
												"  where PREVIOUS_OPERATION_SEQ_NUM is null and WIP_ENTITY_ID ="+entityId+" ";	// �벣�����Y���u(�u���@��) 
								//out.println("�U�@���N�X="+sqlp);
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
										//out.println("�U�@���N�X="+nextOpSeqNum);
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
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCExpTransCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
									if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
									{
										singleOp = true;						   			   
									} //else out.println("�U�@���N�X="+rsMax.getString(1));
									rsMax.close();
									stateMax.close();

								}
								rsp.close();
								statep.close();				   

								// %%%%%%%%%%%%%%%%%%% �g�JRun card Move Transaction %%%%%%%%%%%%%%%%%%%_�_
								//����wip_move_transaction���� OVERCOMPLETION_PRIMARY_QTY
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
								queueTransStmt.setFloat(18,overValue);  // OVERCOMPLETE_QTY 
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

								// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_�_	
								try
								{ //out.println("Step1. �g�JMMT Interface<BR>");	

									// -- ������MMT ��Transaction ID �@��Group ID
									Statement stateMSEQ=con.createStatement();	             
									ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
									if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
									rsMSEQ.close();
									stateMSEQ.close();

									if (woType.equals("3"))	
									{ 
										if (altRouting==null || altRouting.equals("") || altRouting.equals("1")) 
										{
											opSupplierLot = aMFGRCExpTransCode[i][1];	 // �@��ۻs�u�O,�H�y�{�d�@���帹
										} 
										else if (altRouting.equals("2")) 
										{  
											//opSupplierLot = aMFGRCExpTransCode[i][1]; �HPO���Ƽt�ӧ帹�@�J�t�Ϊ��帹		
										}  
									} else {
										opSupplierLot = aMFGRCExpTransCode[i][1];	 // �@��ۻs�u�O,�H�y�{�d�@���帹
									}  

									//out.println("Stepa.�g�JMMT ��TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
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
												" ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',?, 5 ) ";  // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error�i�H���s�QRepeocess)
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
									mmtStmt.setString(13,opSupplierLot);                      //ATTRIBUTE2 LOT_NO (�y�{�d��) 
									mmtStmt.setString(14,opSupplierLot);                      //VENDOR_LOT_NUMBER  SUPPLIER_LOT_NO
									mmtStmt.executeUpdate();
									mmtStmt.close();		

									out.println("Step2. �g�JMMT Lot Interface<BR>");
									String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
										  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
										  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, ATTRIBUTE1, ATTRIBUTE2 ) "+ 
										  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?) ";
									PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
									mmtLotStmt.setString(1,opSupplierLot);    // LOT_NUMBER(�y�{�d��)
									mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCExpTransCode[i][2]));	   // TRANSACTION_QUANTITY
									mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCExpTransCode[i][2]));	   // PRIMARY_QUANTITY 
									mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	       // LAST_UPDATED_BY 								 
									mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
									mmtLotStmt.setString(6,oeOrderNo);                           //ATTRIBUTE1  MO_NO
									mmtLotStmt.setString(7,opSupplierLot);                       //ATTRIBUTE2 LOT_NO (�y�{�d��)
									mmtLotStmt.executeUpdate();
									mmtLotStmt.close();
									out.println("Stepb.�g�JMMT LOT ��TRANSACTION_INTERFACE_ID="+groupId+"<BR>");

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
									} else {
										respID = "50757"; // �䤣��h�w�] --> YEW INV Super User �w�]
									}
									rsResp.close();
									stateResp.close();	  			 

									// -- ������MMT ��Transaction Header ID �@��Group Header ID
									String grpHeaderID = "";
									String devStatus = "";
									String devMessage = "";
									Statement statGRPID=con.createStatement();	             
									ResultSet rsGRPID=statGRPID.executeQuery("select TRANSACTION_HEADER_ID from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID = "+groupId+" ");
									if (rsGRPID.next()) grpHeaderID = rsGRPID.getString(1);
									rsGRPID.close();
									statGRPID.close();	
									/*		  		    

									out.println("Step3. �I�sTSC WIP_MMT_REQUEST <BR>");	
									//	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID	
									CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MMT_REQUEST(?,?,?,?,?,?)}");			 
									cs3.setString(1,grpHeaderID);     //*  Group ID 	
									cs3.setString(2,userMfgUserID);    //  user_id �ק�HID /	
									cs3.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> YEW_INV_Semi_SU /				 
									cs3.registerOutParameter(4, Types.INTEGER); 
									cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
									cs3.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");
									int requestID = cs3.getInt(4);
									devStatus = cs3.getString(5);   //  �^�� REQUEST ���檬�p
									devMessage = cs3.getString(6);   //  �^�� REQUEST ���檬�p�T��
									cs3.close();
									*/			 
									CallableStatement cs3 = con.prepareCall("{call WIP_MTLINTERFACEPROC_PUB.processInterface(?,?,?,?)}");			 
									cs3.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
									cs3.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
									cs3.registerOutParameter(3, Types.VARCHAR);  //�^�� x_returnStatus
									cs3.registerOutParameter(4, Types.VARCHAR);  //�^�� x_errorMsg				
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");	             
									devStatus = cs3.getString(3);    // �^�� x_returnStatus
									devMessage = cs3.getString(4);   // �^�� x_errorMsg
									cs3.close();

									//java.lang.Thread.sleep(5000);	 // ���𤭬�,����Concurrent���槹��,�����G�P�_				 

									Statement stateError=con.createStatement();
									String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
									//out.println("sqlError="+sqlError+"<BR>");					                                     
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
								// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_��

								//�줣�������  ORDER NO
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

								if ((woType=="3" || woType.equals("3") || oeOrderNo.length()>1) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface�ݦ��\�g�J�~�gReservaton
								{
									String sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
									float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;

									try
									{ 			
										//out.println("orderno="+oeOrderNo+"  orderLineId="+orderLineId);

										//�줣�������  mtl_sales_orders HEADER_ID
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

										//��w�s�b��reservation qty �P�q��ۤ�  mtl_sales_orders HEADER_ID
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
											requireDate = rsFndIdb1.getString("SCHEDULE_SHIP_DATE");     //�ݨD��
											resvQty = rsFndIdb1.getFloat("RESV_QTY");    //�v�Q�O�d��
											orderQty = rsFndIdb1.getFloat("ORDER_QTY");  //�q���
											//out.println("requireDate="+requireDate);
											//out.println("resvQty="+resvQty);
											//out.println("orderQty="+orderQty);
											avaiResvQty = orderQty - resvQty ;           //�i�O�d��  
											//out.println("avaiResvQty="+avaiResvQty);
										}
										rsFndIdb1.close();
										stateFndIdb1.close(); 

										//out.println("aMFGRCCompleteCode[i][2]="+aMFGRCExpTransCode[i][2]);

										if (avaiResvQty<=0)
										{
											resvFlag ="N";
											out.print("<br>�L�q��q�i��Reservation,������q��O�d!");
											//out.print("HostTTT");
										}
										else if (Float.parseFloat(aMFGRCExpTransCode[i][2]) > avaiResvQty)   //�y�{�d��>�i�O�d��
										{
											resvFlag ="Y";
											resTxnQty=avaiResvQty;               //resversion qty=�Ѿl�i�O�d��
											out.print("<br>�J�w�Ƥj��q���,����q��ƫO�d!");
											//out.print("HostQQQ");
										}
										else
										{
											resTxnQty =  Float.parseFloat(aMFGRCExpTransCode[i][2]) ;   //resversion qty=�y�{�d�ƶq
											//out.print("<br>����q��ƫO�d���\!");
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
											//�줣�������  RESERVATION_INTERFACE_ID

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
												requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // ��requireDate
											} else {
												requireDate = dateBean.getYearMonthDay(); 
												requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // ��requireDate  
											}

											out.println("<br>Step4. �g�JReservations Interfac<BR>");	
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

										//���� RESERVATIONS Interface Manager
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
												respID = "50776"; // �䤣��h�w�] --> YEW INV Super User �w�]
											}
											rsResp.close();
											stateResp.close();	  

											out.println("<br>Step5. �I�sTSC_YEW_INVRSVIN_REQUEST <BR>");	
											//	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID	
											CallableStatement cs3 = con.prepareCall("{call TSC_YEW_INVRSVIN_REQUEST(?,?,?,?,?,?,?)}");			 
											cs3.setString(1,userMfgUserID);    //  user_id �ק�HID /	
											cs3.setString(2,respID);  //*  �ϥΪ�Responsibility ID --> YEW_INV_Semi_SU /				 
											cs3.registerOutParameter(3, Types.INTEGER); 
											cs3.registerOutParameter(4, Types.VARCHAR);                  //�^�� DEV_STATUS
											cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_MASSAGE
											cs3.setString(6,opSupplierLot);  //*  RUNCARD NO (�i��O�~�ʼt�ӧ帹)	
											cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
											cs3.execute();
											out.println("Procedure : Execute Success !!! ");
											int requestID = cs3.getInt(3);
											devStatus = cs3.getString(4);   //  �^�� REQUEST ���檬�p
											devMessage = cs3.getString(5);   //  �^�� REQUEST ���檬�p�T��
											cs3.close();

											//java.lang.Thread.sleep(5000);	 // ���𤭬�,����Concurrent���槹��,�����G�P�_		 	  				 

											/*   // 2007/01/20 �אּ�ޥ� Oracle �зǪ� Reservation Processor		 		 	  				 
											CallableStatement cs3 = con.prepareCall("{call INV_RESERVATIONS_INTERFACE.rsv_interface_manager(?,?,?,?,?)}");
											cs3.registerOutParameter(1, Types.VARCHAR);                  // x_errbuf
											cs3.registerOutParameter(2, Types.INTEGER);                  // x_retcode			 
											cs3.setInt(3,1);                                //   p_api_version_number	
											cs3.setString(4,"F");                           //*  fnd_api.g_false					
											cs3.setString(5,"N");				             //   p_form_mode
											cs3.execute();
											 out.println("Procedure : ����Oracle�w�s�O�dProcedure !!! ");					 			 
											int requestID = cs3.getInt(2);	  // �� Return Code �� Request ID				
											devMessage = cs3.getString(1);   // �^�� x_errbuf ���檬�p ( x_errbuf )	
											devStatus = Integer.toString(cs3.getInt(2));       // �^�� x_retcode ( x_retcode )		
											 cs3.close();	  
											*/	 

											Statement stateError=con.createStatement();
											String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
											//out.println("sqlError="+sqlError+"<BR>");					                                     
											ResultSet rsError=stateError.executeQuery(sqlError);	
											if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // �s�b ERROR �����,��Interface�Ө��|�gErrorCode���
											{ 
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RESERVATIONS Transaction fail!! </FONT></TD><TD colspan=3>"+rsInterfaceId+"</TD></TR>");
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
												woPassFlag="N";						   
												errorMsgResv = errorMsgResv+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
											}
											rsError.close();
											stateError.close();

											if (errorMsgResv.equals("")) //�YErrorMessage���ŭ�,�h���Interface���\�Q�g�JMMT,�^�����\Request ID
											{	
												out.println("Success Submit !!! RequestID = "+requestID);
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
												woPassFlag="Y";	// ���\�g�J���X��
												con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
											}

										}// end of try
										catch (Exception e)
										{
											out.println("Exception INVRSVIN_REQUEST:"+e.getMessage());
										}	
									}// end if resvFlag !="N" 
								} //end if woType=3 


									// ###################### �g�J Reservations Interface Manager  ��################### ��	

								// �P�_����MMT��Q�g�J��,���s�Ӭy�{�d���A�ܤu�O�ݵ���	 
								if (errorMsg.equals("") && woPassFlag.equals("Y"))
								{ 
									// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_��	
									String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
												" QTY_IN_SCRAP=?, "+
												// " PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
												" CLOSED_DATE=?, COMPLETION_QTY=?, QTY_IN_COMPLETE=? "+
												" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCExpTransCode[i][0]+"' "; 	
									PreparedStatement rcStmt=con.prepareStatement(rcSql);
									//out.print("rcSql="+rcSql);           
									rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
									rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
									{ //out.println("�Ĥ@�������̫�@��");
										rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
										rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));				
									} else { // �_�h,�Y��s�� 048 ���u�J�w
										//out.println("�Ĥ@�����̫�@��");
										rcStmt.setString(3,"048"); 
										rcStmt.setString(4,"CLOSING");					   
									}
									rcStmt.setFloat(5,rcScrapQty); //out.println("rcScrapQty="+rcScrapQty);
									rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());  //out.println("rcScrapQty="+rcScrapQty);
									rcStmt.setFloat(7,Float.parseFloat(aMFGRCExpTransCode[i][2]));  //out.println("aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]);	
									rcStmt.setFloat(8,Float.parseFloat(aMFGRCExpTransCode[i][2]));  //out.println("aMFGRCCompleteCode[i][2]="+aMFGRCCompleteCode[i][2]);		    
									rcStmt.executeUpdate();   
									rcStmt.close(); 

									// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_
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
											
									// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_

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

									//��l������y�{�d���u�O���NWO_USED_QTY���@�֥[_�_
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
									// ��l������y�{�d���u�O���NWO_USED_QTY���@�֥[_��

								}  // End of if (errorMsg.equals(""))			  

							} // end of if (getRetScrapCode==0 && getRetCode==0)   
							else {
								interfaceErr = true; // ��ܲ���Interface�����`
							} // End of else

						} // end of if (aMFGRCExpTransCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o   
						out.print("<BR><font color='#0033CC'>�y�{�d("+aMFGRCExpTransCode[i][1]+")�w�J�wO.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");   
					} // End of if (choice[k]==aMFGRCExpTransCode[i][0] || choice[k].equals(aMFGRCExpTransCode[i][0])) // RunCardID����}�C���e
				} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s

			} // End of for (i=0;i<aMFGRCExpTransCode.length;i++)
		} // end of if (aMFGRCExpTransCode!=null) 

		//out.print("�y�{�d�벣O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		if (!nextOpSeqNum.equals("0") && !interfaceErr) // �Y�U�@��������̫�@���BInterface�L���`
		{
%>
<script LANGUAGE="JavaScript">
alert("���y�{�d�w�ܻs�{�̲ׯ�");
//reProcessFormConfirm("���y�{�d�w�ܻs�{�̲ׯ�,�O�_�~����榹�i�y�{�d�����@�~?","../jsp/TSCMfgRunCardComplete.jsp","<!--%=woNo%>","<!--%=runCardNo%-->");
</script>
<%	
		} else {
%>
<script LANGUAGE="JavaScript">
alert("���y�{�d�w���u�äJ�w(CLOSING)..���~����榹�i�u�O�άy�{�d���ק@�~!!!");
</script>
<%	
		}

		// �ϥΧ����M�� 2���}�C
		if (aMFGRCExpTransCode!=null)
		{ 
			arrMFGRCExpTransBean.setArray2DString(null); 
		}

		//out.println("<BR>Done");
	}
	//MFG�y�{�d�벣��_�� (ACTION=012)   �y�{�d�w�i�}042 --> �y�{�d������046 // �p��n��, �Y �Ĥ@�� -->  �� n ��

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="044>044";
	//MFG�y�{�d������_�_	(ACTION=006)   �y�{�d������044 --> �y�{�d������044
	if (actionID.equals("006") && fromStatusID.equals("044"))   // �p��n��, ��2�� --> �� n-1 ��
	{   //out.println("fromStatusID="+fromStatusID);
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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_

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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 

				//��������ƶq�����_�_	                     
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
				//��������ƶq�����_��   

			} // End of if (aMFGRCMovingCode.length>0) 	  

			for (int i=0;i<aMFGRCMovingCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
					// �P�_�QCheck ��Line �~��������@�~
					if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
					{ //out.println("aMFGRCMovingCode[i][0]="+aMFGRCMovingCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");

						if (Float.parseFloat(aMFGRCMovingCode[i][2])>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o 
						{

							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCMovingCode[i][5]==null || aMFGRCMovingCode[i][5]=="0" || aMFGRCMovingCode[i][5].equals("0")) 
							{ // �Y�L�U�@���Ǹ�,�h��ܥ����Y���̲ׯ�,�����ʧ@�]�w�����u
								toIntOpSType = 3; 
								aMFGRCMovingCode[i][5] = aMFGRCMovingCode[i][4]; // �L�U�@����Seq No,�G������
								transType = 2;
							}  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)

							//����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
							float  rcMQty = 0;   
							float  rcScrapQty = 0;    
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 

							String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY "+
										 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
										 "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // ��QUEUE�����ƶq
										 "     and b.RUNCARD_NO='"+aMFGRCMovingCode[i][1]+"' and to_char(c.FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][3]+"' ";
							//out.println("sqlMQty ="+sqlMQty);				 
							Statement stateMQty=con.createStatement();
							ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
							if (rsMQty.next())
							{

								if (aMFGRCMovingCode[i][2]==null || aMFGRCMovingCode[i][2].equals("null")) aMFGRCMovingCode[i][2]=Float.toString(rcMQty);
								rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//��e�����u�ƶq	
								//out.println("rcMQty ="+rcMQty);		
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCMovingCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   

								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();

								//out.println("java�|�ˤ��J����p�ƤT��rcScrapQty="+rcScrapQty+"<BR>");
							}
							rsMQty.close();
							stateMQty.close();
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
							if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
							{	
								// *****%%%%%%%%%%%%%% �������o�ƶq  %%%%%%%%%%%%**********  �_
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
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  ( 2006/12/08 �אּ RUNNING )   
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�y�{�d:"+aMFGRCMovingCode[i][1]+"(���o�ƶq="+rcScrapQty+")<BR>");	       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
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
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=1
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // ���������o��group
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
								//out.println("<BR>���o��groupID ="+groupID+"<BR>");

								if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
								{
									// �Y�ɩI�s WIP_MOVE PROCESS WORKER

									int procPhase = 1;
									int timeOut = 10;
									try
									{	     /*
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
										*/
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
														 " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+
														 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"' "+
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
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% �������o�ƶq�ƶq  %%%%%%%%%%%%**********  ��	

							} // End of if (rcScrapQty>0)	

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0;  
							float prevQty = 0;		   		     
							if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface
							{  // *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  �_
								//�P�_�O�_��overcompletion
								String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
								"  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCMovingCode[i][3]+"' "+
								"    and runcard_no = '"+aMFGRCMovingCode[i][1]+"' ";
								//out.print("<br>sqlpre="+sqlpre);
								Statement statepre=con.createStatement();
								ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
									prevQty = rspre.getFloat(1);  //�e��������
								}
								rspre.close();
								statepre.close();

								//�P�_�O�_��overcompletion
								if (Float.parseFloat(aMFGRCMovingCode[i][2]) > prevQty )   //�Y�����Ƥj��y�{�d��,���overcompletion
								{   //out.print("<br>�e��������="+prevQty);
									overQty = Float.parseFloat(aMFGRCMovingCode[i][2]) - prevQty ;    //������-�y�{�d��=�W�X�ƶq
									overFlag = "Y";   //���w�W����flag
								}else  { overFlag = "N"; }
								//out.print("<br>overQty="+overQty);    
								toIntOpSType = 1;  // ������to InterOperation Step Type = 1
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
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error (2006/12/08 �אּ 2)
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCMovingCode[i][2])); // �����ƶq
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCMovingCode[i][2])); 
								//out.println("�ƶq="+aMFGRCMovingCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCMovingCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCMovingCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCMovingCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
								seqstmt.setString(15,aMFGRCMovingCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//����g�JInterface��Group����T_�_
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
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

								//out.println("<BR>������groupID ="+groupID+"<BR>");	 

								//����g�JInterface��Group����T_��		

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
														 " where WIP_ENTITY_ID = "+entityId+" and ATTRIBUTE2 = '"+aMFGRCMovingCode[i][1]+"' "+
														 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"' "+
														 "   and PRIMARY_QUANTITY = "+Float.parseFloat(aMFGRCMovingCode[i][2])+"  "+  // ������
														 "   and TO_INTRAOPERATION_STEP_TYPE = 1 and  GROUP_ID = "+groupID+" ";   // ����������
										Statement stateGrpMsg=con.createStatement();
										ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
										if (rsGrpMsg.next())  // �Y�s�b,��ܦ����~�T��,�������\�g�JMove Transaction, ��getRetCode = 0
										{
											getRetCode = 0; 
											if (getErrBuffer!=null && !getErrBuffer.equals("null")) out.println("�t���~�T��,�����\�g�J������Interface!!!");
										} else {
											   
										}
										rsGrpMsg.close();
										stateGrpMsg.close();
										// ����,�T�����ǽT,�ݦA�P�_�O�_MOVE_TRANSACTION�̬y�{�d�O�_���T�H�Q�g�J,�p�w�g�J,�h�����楿�`�����@�~ //_��			  	  
										*/
									}	  
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface

							if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s
							{ 
								// �Y���\,�h��sRUNCARD ��ƪ�������
								// �����\������,�e�@��,����,�U�@��������TRUNCARD_ALL��ƪ��s
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // �w�]���������̫�@��
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
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCMovingCode[i][4]+"'  and WIP_ENTITY_ID ="+entityId+" ");
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
								queueTransStmt.setFloat(18,overValue);    //OVERCOMPLETE_QTY
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

									// %%%%%%%%%%%%%%%%%%% �g�JRun card Scrap Transaction %%%%%%%%%%%%%%%%%%%_�� 
								}  // End of if (rcScrapQty>0)					    

								String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
											" QTY_IN_SCRAP=?, PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=?, "+
											" QTY_IN_QUEUE=? "+
											" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCMovingCode[i][0]+"' "; 	
								PreparedStatement rcStmt=con.prepareStatement(rcSql);
								//out.print("rcSql="+rcSql);           
								rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
								rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
								if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
								{
									rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
									rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
								} else { // �_�h,�Y��s�� 046 ���u�J�w
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

							} // End of if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s  
							else {
								interfaceErr = true; //  ���o�β��������`,�hJavaScript�i���ϥΪ�
							}

						} // End of if (aMFGRCMovingCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
						out.print("<font color='#0033CC'>�y�{�d("+aMFGRCMovingCode[i][1]+")����O.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font><BR>");   
					} // End of if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s

			} // End of for (i=0;i<aMFGRCMovingCode.length;i++)
		} // end of if (aMFGRCMovingCode!=null) 

		if (!interfaceErr)  // �p�G���o�β������L���`,�h�A�P�_�O�_���̫᯸
		{
			if (!nextOpSeqNum.equals("0"))
			{
%>
<script LANGUAGE="JavaScript">
alert("MOVING");
//reProcessFormConfirm("�O�_�~����榹�i�y�{�d�����@�~?","../jsp/TSCMfgRunCardMoving.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%	
			} else {
%>
<script LANGUAGE="JavaScript">
alert("�w�FRounting�̫�@��");
//reProcessFormConfirm("         �w�FRounting�̫�@��\n �O�_�~����榹�i�y�{�d���u�J�w�@�~?","../jsp/TSCMfgRunCardComplete.jsp","<!--%=woNo%-->","<!--%=runCardNo%-->");
</script>
<%
			}
		}	else {  // �_�h,Java Script �i���ϥΪ�Interface���`
%>
<script LANGUAGE="JavaScript">
alert("Oracle���o�β������`,�Ь�MIS�d����]!!!");
</script>
<%  
		}


		// �ϥΧ����M�� 2���}�C
		if (aMFGRCMovingCode!=null)
		{ 
			arrMFGRCMovingBean.setArray2DString(null); 
		}

	} 
	//MFG�y�{�d������_��	(ACTION=006)   �y�{�d������044 --> �y�{�d������044

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="044>046";
	//MFG�y�{�d���u�J�w_�_	(ACTION=012)   �y�{�d������044 --> �y�{�d���u�J�w046(�ݧP�_�O�_�������̫�@��)
	if (actionID.equals("012") && fromStatusID.equals("046"))   // �p�� n��, �Y�� n-1�� --> �� n ��
	{  
		String fndUserName = "";  //�B�z�H��
		String woUOM = ""; // �u�O�������
		String compSubInventory = null;
		String altRouting = "1"; //
		String opSupplierLot = "";
		int primaryItemID = 0;
		float runCardQtyf=0,overQty=0; 
		entityId = "0"; // �u�Owip_entity_id
		boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
		if (aMFGRCCompleteCode!=null)
		{	  
			if (aMFGRCCompleteCode.length>0)
			{    
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�_

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
				//���login ��user id ���� run "Receiving Transaction Processor"�� requestor_�� 

				//��������ƶq�����_�_	                     
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
					compSubInventory = rsUOM.getString("COMPLETION_SUBINVENTORY");	  // �J�wsubInventory
					altRouting = rsUOM.getString("ALTERNATE_ROUTING");
					opSupplierLot = rsUOM.getString("SUPPLIER_LOT_NO");
					organizationId = rsUOM.getString("ORGANIZATION_ID");
				}
				rsUOM.close();
				stateUOM.close();
				//��������ƶq�����_��   	  
			} // End of if (aMFGRCCompleteCode.length>0) 	
			for (int i=0;i<aMFGRCCompleteCode.length-1;i++)
			{
				for (int k=0;k<=choice.length-1;k++)    
				{ //out.println("choice[k]="+choice[k]);  
				// �P�_�QCheck ��Line �~��������@�~
					if (choice[k]==aMFGRCCompleteCode[i][0] || choice[k].equals(aMFGRCCompleteCode[i][0]))
					{ //out.println("aMFGRCCompleteCode[i][0]="+aMFGRCCompleteCode[i][0]);	   
						//out.print("woNo2="+woNo+"<br>");  

						if (Float.parseFloat(aMFGRCCompleteCode[i][2])>=0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
						{
							int toIntOpSType = 1; //TO_INTRAOPERATION_STEP_TYPE(1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP)
							int transType = 1;    // TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
							if (aMFGRCCompleteCode[i][5]==null || aMFGRCCompleteCode[i][5]=="0" || aMFGRCCompleteCode[i][5].equals("0")) 
							{ // �Y�L�U�@���Ǹ�,�h��ܥ����Y���̲ׯ�,�����ʧ@�]�w�����u
								toIntOpSType = 3; 
								aMFGRCCompleteCode[i][5] = aMFGRCCompleteCode[i][4]; // �L�U�@����Seq No,�G������
								transType = 2;
							}  // �Y�L�U�@��,��ܥ����O�̫�@��,toStepType �]��3	, transaction Type �]��2(Move Completion)

							//����ӧO�y�{�d�����ƶq�����,�íp�⥻�����o�ƶq_�_	
							float  rcMQty = 0;   
							float  rcScrapQty = 0;  
							String supplierLotNo = null;   
							java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 

							String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY, "+
										 "         a.COMPLETION_SUBINVENTORY, a.WAFER_LOT_NO "+
										 "    from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
										 "   where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										 "     and b.RUNCARD_NO= c.ATTRIBUTE2 "+
										 "     and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // ��QUEUE�����ƶq�Y�e�@�����~�]��,����1
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
								rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//��e�����u�ƶq	
								rcScrapQty = rcMQty - Float.parseFloat(aMFGRCCompleteCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
								supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // �����ӧ帹
								String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();
								//out.println("java�|�ˤ��J����p�ƤT��rcScrapQty="+rcScrapQty+"<BR>");
								if (fndUserName.equals("kerwin"))
								{
									//rcScrapQty = 0;
								}
								//out.println("adminModeOption="+adminModeOption);
								if (adminModeOption!=null && adminModeOption.equals("YES") && UserRoles.indexOf("admin")>=0)
								{
									rcScrapQty = Float.parseFloat(aMFGRCCompleteCode[i][11]); // �޲z���Ҧ�,�B��ʵ��w�F���o��,�h�H���w�����o�ƤJScrap

									userMfgUserID = "5753"; // �s�F�]�˯�,PANG_LIPING
								}
							}
							rsMQty.close();
							stateMQty.close();
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
							if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
							{	
								//out.println("// *****%%%%%%%%%%%%%% �������o�ƶq  %%%%%%%%%%%%**********  �_");
								toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
								transType = 1; // ���o��Transaction Type = 1(Move Transaction)
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
								scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  (2006/12/08 �אּ Running )     
								scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�y�{�d:"+aMFGRCCompleteCode[i][1]+"(���o�ƶq="+rcScrapQty+")<BR>");       	   
								scrapstmt.setString(8,woUOM);
								scrapstmt.setInt(9,Integer.parseInt(entityId));  
								scrapstmt.setString(10,woNo);  
								scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								scrapstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(����)		  
								scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								scrapstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][4])); // TO_OPERATION_SEQ_NUM  //���o�Y��From = To
								scrapstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
								scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)���o  ( 01-11-000-7650-951-0-000 ) 
								scrapstmt.setInt(18,7);	// REASON_ID  �s�{���`
								scrapstmt.executeUpdate();
								scrapstmt.close();	      	

								//����g�JInterface��Group����T_�_
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
											 "   and TO_INTRAOPERATION_STEP_TYPE = 5 "; // ���������o��group
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
								//out.println("<BR>���o��groupID ="+groupID+"<BR>");	 

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
										*/
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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% �������o�ƶq�ƶq  %%%%%%%%%%%%**********  ��	

							} // End of if (rcScrapQty>0)	

							String getErrBuffer = "",overFlag="";
							int getRetCode = 0; 
							float prevQty = 0; 		   		     
							if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface
							{  // *****%%%%%%%%%%%%%% ���`���u�ƶq  %%%%%%%%%%%%**********  �_
								//�P�_�O�_��overcompletion
								String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
												"  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCCompleteCode[i][3]+"' "+
												"    and runcard_no = '"+aMFGRCCompleteCode[i][1]+"' ";
								Statement statepre=con.createStatement();
								ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
									prevQty = rspre.getFloat(1);  //�e�������ƶq
								}
								rspre.close();
								statepre.close();
								//out.print("<br>prevQty="+prevQty);

								if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > prevQty )   //�Y�����Ƥj��e��������,���overcompletion
								{
									overQty = Float.parseFloat(aMFGRCCompleteCode[i][2]) - prevQty ;    //������-�y�{�d��=�W�X�ƶq
									overFlag = "Y";   //���w�W����flag
								}else  { overFlag = "N"; }
								//out.print("<br>overQty="+overQty);    

								toIntOpSType = 3;  // ���u������to InterOperation Step Type = 3
								transType = 1;     // ���u�� Transaction Type(�אּ Move Transaction,��MMT�h�M�w�N�u��Complete)
								//out.println("<BR>//1. *****%%%%%%%%%%%%%% ���`�����ƶq  %%%%%%%%%%%%**********  �_");
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
								seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error ( 2006/12/08 �אּ Running )
								//  seqstmt.setDate(9,processDateTime);  // TRANSACTION_DATE
								seqstmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); // �����ƶq
								//seqstmt.setInt(10,Integer.parseInt(aMFGRCMovingCode[i][2])); 
								//out.println("�ƶq="+aMFGRCMovingCode[i][2]); //queue to Move Qty creation date  dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
								seqstmt.setString(8,woUOM);
								seqstmt.setInt(9,Integer.parseInt(entityId));  
								seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
								seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
								//seqstmt.setInt(12,20);
								seqstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
								//out.println("FM_OPERATION_SEQ_NUM="+aMFGRCMovingCode[i][4]);
								seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								seqstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
								seqstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
								seqstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
								if (overFlag == "Y" || overFlag.equals("Y"))
								{ seqstmt.setFloat(17,overQty); } // OVERCOMPLETION_TRANSACTION_QTY   
								seqstmt.executeUpdate();
								seqstmt.close();	      	

								//����g�JInterface��Group����T_�_
								int groupID = 0;
								int opSeqNo = 0;              
								String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
											 " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" "+
											 "   and ATTRIBUTE2 = '"+aMFGRCCompleteCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
											 "   and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
											 "   and TO_INTRAOPERATION_STEP_TYPE = 3 "; // ������������Group ID
								Statement stateGrp=con.createStatement();
								ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
								if (rsGrp.next())
								{
									groupID = rsGrp.getInt("GROUP_ID");
									opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
								}
								rsGrp.close();
								stateGrp.close();

								out.println("<BR>���u��groupID ="+groupID+"<BR>");	 

								//����g�JInterface��Group����T_��		

								if (groupID>0 && opSeqNo>0)  // ��ܨ��쥿�T��groupID��opSeqNo
								{
									// �Y�ɩI�s WIP_MOVE PROCESS WORKER

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
									catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
								} // end of if (groupID>0 && opSeqNo>0)			 
								// *****%%%%%%%%%%%%%% ���`���u�ƶq  %%%%%%%%%%%%**********  ��

							} // End of if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface

							if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s
							{ 
								// �Y���\,�h��sRUNCARD ��ƪ�������
								// �����\������,�e�@��,����,�U�@��������TRUNCARD_ALL��ƪ��s
								//String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
								boolean singleOp = false;  // �w�]���������̫�@��
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
												"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
												"  from WIP_OPERATIONS "+
												"  where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCCompleteCode[i][4]+"' "+ // �]�w���\(getRetScrapCode==0 && getRetCode==0.�G�e�@��������)
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
										out.println("�U�@���N�X="+nextOpSeqNum);
									}  	
								} else { // ������,��ܵL�U�@��,�����Y���U�@��,�G�O�d���y�{�d�̫᯸��T

									// �����Y���̫�@��,�G�ݧ�s���A�� 046 (���u�J�w)					 
									Statement stateMax=con.createStatement();
									ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where to_char(OPERATION_SEQ_NUM) = '"+aMFGRCCompleteCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" ");
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
								queueTransStmt.setInt(6,Integer.parseInt(aMFGRCCompleteCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
								queueTransStmt.setString(7,standardOpDesc);                          //  FM_OPERATION_CODE	       	   
								queueTransStmt.setInt(8,Integer.parseInt(aMFGRCCompleteCode[i][5])); //TO_OPERATION_SEQ_NUM(�U�@��) 
								queueTransStmt.setString(9,"");                                           //TO_OPERATION_CODE(�U�@���N�X) 
								queueTransStmt.setFloat(10,Float.parseFloat(aMFGRCCompleteCode[i][2]));  // Transaction Qty
								queueTransStmt.setString(11,woUOM);      // Transaction_UOM		   
								queueTransStmt.setInt(12,1);             // 1=Queue		  
								queueTransStmt.setString(13,"QUEUE");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
								queueTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
								queueTransStmt.setString(15,"046"); // From STATUSID
								queueTransStmt.setString(16,"COMPLETING");	  // From STATUS
								queueTransStmt.setString(17,fndUserName);	  // Update User 
								queueTransStmt.setFloat(18,overValue);
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
									scrapTransStmt.setInt(1,Integer.parseInt(aMFGRCCompleteCode[i][0])); // RUNCAD_ID          
									scrapTransStmt.setString(2,aMFGRCCompleteCode[i][1]);                // RUNCARD_NO
									scrapTransStmt.setInt(3,Integer.parseInt(organizationID));           // ORGANIZATION_ID
									scrapTransStmt.setInt(4,Integer.parseInt(entityId));                 // WIP_ENTITY_ID
									scrapTransStmt.setInt(5,primaryItemID);                              // PRIMARY_ITEM_ID
									scrapTransStmt.setInt(6,Integer.parseInt(aMFGRCCompleteCode[i][4])); //FM_OPERATION_SEQ_NUM(����)    
									scrapTransStmt.setString(7,standardOpDesc);                                           //  FM_OPERATION_CODE	       	   
									scrapTransStmt.setInt(8,Integer.parseInt(aMFGRCCompleteCode[i][4])); //TO_OPERATION_SEQ_NUM(�U�@��) 
									scrapTransStmt.setString(9,standardOpDesc);                                           //TO_OPERATION_CODE(�U�@���N�X) 
									scrapTransStmt.setFloat(10,rcScrapQty);  // Transaction Qty
									scrapTransStmt.setString(11,woUOM);      // Transaction_UOM		   
									scrapTransStmt.setInt(12,5);             // 5=SCRAP(���o)		  
									scrapTransStmt.setString(13,"SCRAP");    // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
									scrapTransStmt.setString(14,"");         // CUSTOMER_LOT_NO
									scrapTransStmt.setString(15,"046"); // From STATUSID
									scrapTransStmt.setString(16,"COMPLETING");	  // From STATUS
									scrapTransStmt.setString(17,fndUserName);	  // Update User  
									scrapTransStmt.executeUpdate();
									scrapTransStmt.close();	    	 
									// %%%%%%%%%%%%%%%%%%% �g�JRun card Scrap Transaction %%%%%%%%%%%%%%%%%%%_�� 
								}  // End of if (rcScrapQty>0)	

								// ###################### �g�J Reservations Interface  ################### �_   liling add 2006/10/30

								// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_�_		  
								try
								{ //out.println("Step1. �g�JMMT Interface<BR>");			 

									// -- ������MMT ��Transaction ID �@��Group ID
									Statement stateMSEQ=con.createStatement();	             
									ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
									if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
									rsMSEQ.close();
									stateMSEQ.close();

									if (woType.equals("3"))	
									{   
										if (altRouting.equals("2")) { opSupplierLot=opSupplierLot; } // �p�G��q�u�O�B���~��,�h�H�t�ӧ帹�@���g�JMMT ��LOT�� RESERVATION�̾�	
										else { // ��q�u�O�ۻs
											opSupplierLot=aMFGRCCompleteCode[i][1]; // �y�{�d�����帹
										}
									}	else { // ���ΤΫe�q�u�O
										//supplierLotNo = opSupplierLot; 
										opSupplierLot=aMFGRCCompleteCode[i][1];
									}  		  
									//out.println("Stepa.�g�JMMT ��TRANSACTION_INTERFACE_ID="+groupId+"<BR>");
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
										 " ?,?,?,1,MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,'Y',?, 5 ) ";   // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error�i�H���s�QRepeocess)
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
									mmtStmt.setString(13,opSupplierLot);                              //ATTRIBUTE2  LOT_NO (�y�{�d��)
									mmtStmt.setString(14,opSupplierLot);                              //VENDOR_LOT_NUMBER  SUPPLIER_LOT_NO
									mmtStmt.executeUpdate();
									mmtStmt.close();		

									//out.println("Step2. �g�JMMT Lot Interface<BR>");
									String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
										  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
										  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ,ATTRIBUTE1, ATTRIBUTE2 ) "+ 
										  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?) ";
									PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
									mmtLotStmt.setString(1,opSupplierLot);                                 // LOT_NUMBER(�y�{�d��)
									mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	   // TRANSACTION_QUANTITY
									mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCCompleteCode[i][2]));	   // PRIMARY_QUANTITY 
									mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	//out.println("userMfgUserID"+userMfgUserID);    // LAST_UPDATED_BY 								 
									mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
									mmtLotStmt.setString(6,oeOrderNo);                             //ATTRIBUTE1  MO_NO
									mmtLotStmt.setString(7,opSupplierLot);                         //ATTRIBUTE2  LOT_NO (�y�{�d��)
									mmtLotStmt.executeUpdate();
									mmtLotStmt.close();
									//out.println("Stepb.�g�JMMT LOT ��TRANSACTION_INTERFACE_ID="+groupId+"<BR>");	

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
									ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME like 'YEW_INV_SEMI_SU%' "); 
									if (rsResp.next())
									{
										respID = rsResp.getString("RESPONSIBILITY_ID");
									} else {
										respID = "50776"; // �䤣��h�w�] --> YEW INV Super User �w�]
									}
									rsResp.close();
									stateResp.close();	  


									// -- ������MMT ��Transaction Header ID �@��Group Header ID
									String grpHeaderID = "";
									String devStatus = "";
									String devMessage = "";
									Statement statGRPID=con.createStatement();	             
									ResultSet rsGRPID=statGRPID.executeQuery("select TRANSACTION_HEADER_ID from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID = "+groupId+" ");
									if (rsGRPID.next()) grpHeaderID = rsGRPID.getString(1);
									rsGRPID.close();
									statGRPID.close();		  

									/*			  
									//out.println("Step3. �I�sTSC WIP_MMT_REQUEST <BR>");	
									//	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID	
									CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MMT_REQUEST(?,?,?,?,?,?)}");			 
									cs3.setString(1,grpHeaderID);     //*  Group ID 	
									cs3.setString(2,userMfgUserID);    //  user_id �ק�HID /	
									cs3.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> YEW_INV_Semi_SU /				 
									cs3.registerOutParameter(4, Types.INTEGER); 
									cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_STATUS
									cs3.registerOutParameter(6, Types.VARCHAR);                  //�^�� DEV_MASSAGE
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");
									int requestID = cs3.getInt(4);
									devStatus = cs3.getString(5);   //  �^�� REQUEST ���檬�p
									devMessage = cs3.getString(6);   //  �^�� REQUEST ���檬�p�T��
									cs3.close();
									*/			 
									//java.lang.Thread.sleep(5000);	 // ���𤭬�,����Concurrent���槹��,�����G�P�_		 	  				 

									CallableStatement cs3 = con.prepareCall("{call WIP_MTLINTERFACEPROC_PUB.processInterface(?,?,?,?)}");			 
									cs3.setInt(1,Integer.parseInt(grpHeaderID));     //   p_txnIntID	
									cs3.setString(2,"T");          //   fnd_api.g_false = "TRUE"					 			 
									cs3.registerOutParameter(3, Types.VARCHAR);  //�^�� x_returnStatus
									cs3.registerOutParameter(4, Types.VARCHAR);  //�^�� x_errorMsg				
									cs3.execute();
									out.println("Procedure : Execute Success !!! ");	             
									devStatus = cs3.getString(3);    // �^�� x_returnStatus
									devMessage = cs3.getString(4);   // �^�� x_errorMsg
									cs3.close(); 
 
									Statement stateError=con.createStatement();
									String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
									//out.println("sqlError="+sqlError+"<BR>");					                                     
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
										out.println("Success Submit !!! <BR>");
										out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
										woPassFlag="Y";	// ���\�g�J���X��
										con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
									}

								}// end of try
								catch (Exception e)
								{
									out.println("Exception WIP_MMT_REQUEST:"+e.getMessage());
								}	
								// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_��		

								//�줣�������  ORDER NO
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

								// 2007/01/30 �� ��q�u�O �~,���u�Τu�{����p��MO��,���ݧ@ Reservation_By Kerwin
								if ((woType=="3" || woType.equals("3") || oeOrderNo.length()>1) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface�ݦ��\�g�J�~�gReservaton
								{
									String sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
									float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;

									try
									{ 
										//out.println("orderno="+oeOrderNo+"  orderLineId="+orderLineId);

										//�줣�������  mtl_sales_orders HEADER_ID
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

										//��w�s�b��reservation qty �P�q��ۤ�  mtl_sales_orders HEADER_ID
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
											requireDate = rsFndIdb1.getString("SCHEDULE_SHIP_DATE");     //�ݨD��
											resvQty = rsFndIdb1.getFloat("RESV_QTY");    //�v�Q�O�d��			  
											orderQty = rsFndIdb1.getFloat("ORDER_QTY");  //�q���
											//out.println("resvQty="+resvQty);
											//if (resvQty==null) resvQty = 0; // 2007/01/07 �O�d���ƶq�Y������,�h��0, By Kerwin			  
											avaiResvQty = orderQty - resvQty ;           //�i�O�d��  = �q��ƶq - �w�O�d��
										}
										rsFndIdb1.close();
										stateFndIdb1.close(); 
										if (avaiResvQty<=0)
										{
											resvFlag ="N";
											out.print("<br>�L�q��q�i��Reservation,�L�ݦA����q��O�d!");
										}
										else if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > avaiResvQty)   //�y�{�d��>�i�O�d��
										{
											resvFlag ="Y";
											resTxnQty=avaiResvQty;               //resversion qty=�Ѿl�i�O�d��
											out.print("<br>�J�w�Ƥj��q���,����q��ƫO�d!");
										}
										else
										{
											resTxnQty =  Float.parseFloat(aMFGRCCompleteCode[i][2]) ;   //resversion qty=�y�{�d�ƶq
											out.print("<br>����q��ƫO�d���\!");
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
											//�줣�������  RESERVATION_INTERFACE_ID
											Statement stateFndIdc=con.createStatement();
											ResultSet rsFndIdc=stateFndIdc.executeQuery("select MTL_RESERVATIONS_INTERFACE_S.NEXTVAL from dual");
											if (rsFndIdc.next())
											{
												rsInterfaceId = rsFndIdc.getString(1); 
											}
											rsFndIdc.close();
											stateFndIdc.close();	

											java.sql.Date requirementDate = null;
											requirementDate = new java.sql.Date(Integer.parseInt(requireDate.substring(0,4))-1900,Integer.parseInt(requireDate.substring(4,6))-1,Integer.parseInt(requireDate.substring(6,8)));  // ��requireDate
											//out.println("<br>requirementDate="+requirementDate);		  

											//out.println("<br>Step4. �g�JReservations Interface ");	
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
											rsInStmt.setString(22,opSupplierLot);	                      //lot number...�Y����q�~��,�h���t�ӧ帹,�_�h�Ҭ��y�{�d��
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

										//���� RESERVATIONS Interface Manager

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
												respID = "50776"; // �䤣��h�w�] --> YEW INV Super User �w�]
											}
											rsResp.close();
											stateResp.close();	  

											//out.println("<br>Step5. �I�sTSC_YEW_INVRSVIN_REQUEST <BR>");	
											//	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID	
											CallableStatement cs3 = con.prepareCall("{call TSC_YEW_INVRSVIN_REQUEST(?,?,?,?,?,?,?)}");			 
											cs3.setString(1,userMfgUserID);    //  user_id �ק�HID /	
											cs3.setString(2,respID);  //*  �ϥΪ�Responsibility ID --> YEW_INV_Semi_SU /				 
											cs3.registerOutParameter(3, Types.INTEGER); 
											cs3.registerOutParameter(4, Types.VARCHAR);                  //�^�� DEV_STATUS
											cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_MASSAGE
											cs3.setString(6,opSupplierLot);  //*  RUNCARD NO (�i��O�~�ʼt�ӧ帹��q�ۻs���t�ӧ帹)	
											cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
											cs3.execute();
											//out.println("Procedure : Execute Success !!! ");
											int requestID = cs3.getInt(3);
											devStatus = cs3.getString(4);   //  �^�� REQUEST ���檬�p
											devMessage = cs3.getString(5);   //  �^�� REQUEST ���檬�p�T��
											cs3.close();

											//java.lang.Thread.sleep(5000);	 // ���𤭬�,����Concurrent���槹��,�����G�P�_		 	  				 

											/*   // 2007/01/20 �אּ�ޥ� Oracle �зǪ� Reservation Processor		 		 	  				 
											CallableStatement cs3 = con.prepareCall("{call INV_RESERVATIONS_INTERFACE.rsv_interface_manager(?,?,?,?,?)}");
											cs3.registerOutParameter(1, Types.VARCHAR);                  // x_errbuf
											cs3.registerOutParameter(2, Types.INTEGER);                  // x_retcode			 
											cs3.setInt(3,1);                                //   p_api_version_number	
											cs3.setString(4,"F");                           //*  fnd_api.g_false					
											cs3.setString(5,"N");				             //   p_form_mode
											cs3.execute();
											 out.println("Procedure : ����Oracle�w�s�O�dProcedure !!! ");					 			 
											int requestID = cs3.getInt(2);	  // �� Return Code �� Request ID				
											devMessage = cs3.getString(1);   // �^�� x_errbuf ���檬�p ( x_errbuf )	
											devStatus = Integer.toString(cs3.getInt(2));       // �^�� x_retcode ( x_retcode )		
											 cs3.close();	  
											*/ 
	 
											Statement stateError=con.createStatement();
											String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
											//out.println("sqlError="+sqlError+"<BR>");					                                     
											ResultSet rsError=stateError.executeQuery(sqlError);	
											if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // �s�b ERROR �����,��Interface�Ө��|�gErrorCode���
											{ 
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RESERVATIONS Transaction fail!! </FONT></TD><TD colspan=3>"+rsInterfaceId+"</TD></TR>");
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
												woPassFlag="N";						   
												errorMsgResv = errorMsgResv+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
											}
											rsError.close();
											stateError.close();

											if (errorMsgResv.equals("")) //�YErrorMessage���ŭ�,�h���Interface���\�Q�g�JMMT,�^�����\Request ID
											{	
												out.println("Success Submit !!! RequestID = "+requestID);
												out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
												woPassFlag="Y";	// ���\�g�J���X��
												con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
											}

										}// end of try
										catch (Exception e)
										{
											out.println("Exception INVRSVIN_REQUEST:"+e.getMessage());
										}	
									}//resvFlag!="N"		 
								} //end if woType=3 
								// ###################### �g�J Reservations Interface Manager  ��################### ��		  

								// �P�_����MMT��Q�g�J��,���s�Ӭy�{�d���A�ܤu�O�ݵ���	 
								if (errorMsg.equals(""))
								{ 
									// #########################  �y�{�d���u��,�I�s�g�JMMT��Material Transaction Lot Interface�@�w�s����_��		  

									String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
												 " QTY_IN_SCRAP=?, CLOSED_DATE=?, COMPLETION_QTY=?, QTY_IN_COMPLETE=?  "+
												//" PREVIOUS_OP_SEQ_NUM=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, OPERATION_SEQ_ID=?, OPERATION_SEQ_NUM=?, NEXT_OP_SEQ_NUM=? "+
												" where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCCompleteCode[i][0]+"' "; 	
									PreparedStatement rcStmt=con.prepareStatement(rcSql);
									//out.print("rcSql="+rcSql);           
									rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
									rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
									{
										rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
										rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
										//rcStmt.setString(3,"048"); 
										//rcStmt.setString(4,"CLOSING");
										// rcStmt.setFloat(5,Float.parseFloat(aMFGRCCompleteCode[i][2]));
										rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling �ץ��������o�����,�ӫD�����			  
									} else { // �_�h,�Y��s�� 048�u�O���פ�
										rcStmt.setString(3,"048"); 
										rcStmt.setString(4,"CLOSING");
										//rcStmt.setFloat(5,Float.parseFloat(aMFGRCCompleteCode[i][2]));
										rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling �ץ��������o�����,�ӫD�����			  
									}
									rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
									rcStmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	
									rcStmt.setFloat(8,Float.parseFloat(aMFGRCCompleteCode[i][2])); 			
									rcStmt.executeUpdate();   
									rcStmt.close(); 

									// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_
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
									// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_

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

									//��l������y�{�d���u�O���NWO_USED_QTY���@�֥[_�_
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
									// ��l������y�{�d���u�O���NWO_USED_QTY���@�֥[_��

								}  // End of if (errorMsg.equals(""))	   

							} // End of if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s 
							else {
								interfaceErr = true;   // ��ܳ��o�Χ��u�J�wInterface�����`
							}   

						} //End of if (aMFGRCCompleteCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o	
						out.print("<BR><font color='#0033CC'>�y�{�d("+aMFGRCCompleteCode[i][1]+")���u�J�wO.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>"); 
					} // End of if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
				} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s

			} // End of for (i=0;i<aMFGRCMovingCode.length;i++)

		} // end of if (aMFGRCCompleteCode!=null) 
		//out.print("�y�{�d���u�J�wO.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");


		// �ϥΧ����M��2���}�C
		if (aMFGRCCompleteCode!=null)
		{ 
			arrMFGRCCompleteBean.setArray2DString(null); 
		}

	} // End of if (actionID.equals("012") && fromStatusID.equals("046"))
	//MFG�y�{�d���u�J�w_��	(ACTION=012)   �y�{�d������044 --> �y�{�d���u�J�w046(�ݧP�_�O�_�������̫�@��)

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="040>050";
	//=======���i�y�{�d�u�O�R��...�_	(ACTION=021)   �u�O�ͦ�040 --> �u�O�R����050   add by liling 2006/10/19
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
	//========���i�y�{�d�u�O�R��....��	(ACTION=021)   �u�O�ͦ�040 --> �u�O�R����050

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	errorFlag ="042>050";
	//=======���벣�y�{�d�R��,�u�O�ƶq���...�_	(ACTION=021)   �y�{�d�i�}042 -->�y�{�d�R����050   add by liling 2006/10/31
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
						tot_del_qty=tot_del_qty+(Float.parseFloat(aMFGRCDeleteCode[j][6]));  //��ܭn�R�����y�{�d�ƶq
						//out.print("<br>����etot_del_qty="+tot_del_qty); 

						//���p�ƤT��   20070316 liling
						java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T��
						String strTotDelQty = nf.format(tot_del_qty);
						java.math.BigDecimal bd = new java.math.BigDecimal(strTotDelQty);
						java.math.BigDecimal delQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
						tot_del_qty =delQty.floatValue();
						//out.print("<br>�ഫ��tot_del_qty="+tot_del_qty);
					} 
				} 
			}
			//=================  insert into WIP_JOB_SCHEDULE_INTERFACE  , begin =================
			try
			{
				//======���������
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

				//���u�O�Ĥ@���Ѿlqueue�ƶq
				String sqlb = " select QUANTITY_IN_QUEUE from wip_operations  where wip_entity_id = "+entityId+" and organization_id = "+organizationId+" and OPERATION_SEQ_NUM="+minOpNum+"  ";
				// out.print("<br>sqlb="+sqlb);
				Statement stateb=con.createStatement();
				ResultSet rsb=stateb.executeQuery(sqlb);
				if (rsb.next())
				{	wipQueueQty	 = rsb.getFloat("QUANTITY_IN_QUEUE");   }
					rsb.close();
					stateb.close(); 


					//out.print("<br>wipQueueQty="+wipQueueQty+"  tot_del_qty="+tot_del_qty);
					if (wipQueueQty < tot_del_qty)   //�Y�u�O����queue�Ѿl�Ƥ���,�ק�queue�ƶq=�`�R�d��,�H����R�d����
					{
						String woSqlq=" update wip_operations  set QUANTITY_IN_QUEUE = "+tot_del_qty+" "+
						"   where wip_entity_id = "+entityId+" and organization_id = "+organizationId+" and OPERATION_SEQ_NUM="+minOpNum+"  ";
						//out.print("<br>woSqlq="+woSqlq); 
						PreparedStatement woStmtq=con.prepareStatement(woSqlq);
						woStmtq.executeUpdate();   
						woStmtq.close(); 		
					}

					java.sql.Date startdate = null;
					startdate = new java.sql.Date(Integer.parseInt(startDate.substring(0,4))-1900,Integer.parseInt(startDate.substring(4,6))-1,Integer.parseInt(startDate.substring(6,8)));  // ��startDate

					newWoQty=(Float.parseFloat(woQty)-tot_del_qty);   //���o�R���y�{�d�ƶq
					//out.print("<br>new qty="+newWoQty);

					//���p�ƤT��   20070316 liling
					java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T��
					String strNewWoQty = nf.format(newWoQty);
					java.math.BigDecimal bd = new java.math.BigDecimal(strNewWoQty);
					java.math.BigDecimal newQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
					newWoQty =newQty.floatValue();
					//out.print("<br>�ഫ��newWoQty="+newWoQty+"<br>");



					//out.print("interfaceId="+interfaceId);
					PreparedStatement instmt=null;

					//�Y�ƶq��'0',�P�_�O�_�����,�Y�L��ƫh��canceled
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
							newWoQty=Float.parseFloat(woQty);    //�Y�R�����ƶq=�u�O�ƶq,�h�u�O�ƶq����,�����A�אּ'canceled'
							woPassFlag="Y";
							//out.print("statusType="+statusType);
							//out.print("woPassFlag="+woPassFlag);
						}
						else
						{
							%><script LANGUAGE="JavaScript">
							alert("�쪫�ƥ��h��,�Х�����h��!!");
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

						// �ݼзǤu��
						inSql="insert into WIP_JOB_SCHEDULE_INTERFACE (   "+
								"       FIRST_UNIT_START_DATE,GROUP_ID,LAST_UPDATE_DATE,LAST_UPDATED_BY,CREATION_DATE,CREATED_BY,  "+
								"       WIP_ENTITY_ID,LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID,PRIMARY_ITEM_ID,  "+
								"       PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION) "+
								"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "; 
						//out.print("inSql="+inSql);				
						instmt=con.prepareStatement(inSql);     
						instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE �w�p��J��	  
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

				//���� WIP_MASS_LOAD
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
					} 
					else 
					{
						//	Step1. �g�J Schedult Discrete Job API submit request ��Procedure �è��^ Oracle Request ID
						/*	 	
						CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MASSLOAD_REQUEST(?,?,?,?)}");			 
						cs3.setString(1,groupId);  //*  Group ID 	
						cs3.setString(2,userMfgUserID);    //  user_id �ק�HID /	
						cs3.setString(3,respID);  //*  �ϥΪ�Responsibility ID --> TSC_INV_Semi_SU /				 
						cs3.registerOutParameter(4, Types.INTEGER); 
						cs3.execute();
						// out.println("Procedure : Execute Success !!! ");
						int requestID = cs3.getInt(4);
						cs3.close();

						java.lang.Thread.sleep(5000);	 // ���𤭬�,����Concurrent���槹��,�����G�P�_	
						*/

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
						while (rsError.next()) // �s�b ERROR �����
						{ 
							errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>WIP_INTERFACE Transaction fail!! </FONT></TD><TD colspan=1>"+requestID+"</TD></TR>");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=1 nowrap><font color='#000099'>Error Message</FONT></TD><TD colspan=1>"+errorMsg+"</TD></TR>");
							out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
							woPassFlag="N";	
							out.println("<BR>rsError="+woPassFlag);	   
							// �p�G���~���T���Q���X,�ݦA�POracle�T�{�O�_�u���u�楼����,�p������,�h�N���ͪ�PassFlag�]�� Y ,���y�{�d���i�i�}
							//   String sqlOp = " select WIP_ENTITY_ID from WIP.WIP_ENTITIES where WIP_ENTITY_NAME='"+woNo+"' " ;
							//out.print("sqlOp �ɤ���������="+sqlOp);
							//    Statement stateOp=con.createStatement();
							//    ResultSet rsOp=stateOp.executeQuery(sqlOp);
							//     if (rsOp.next())
							//      {
							// 	  	 woPassFlag="N"; //2007/04/05 liling update 
							//		 out.println("<BR><font color='#993366'>�u�O�ק粒��,���t���`�T��!!!</font><BR>");
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
							woPassFlag="Y";	// ���\�g�J���X��
							con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
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
				woStmta.setFloat(1,newWoQty);   //�ק��u�O�ƶq
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
					// woStmtc.setFloat(1,newWoQty);   //�ק��u�O�ƶq
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
					woStmtc.setFloat(1,newWoQty);   //�ק��u�O�ƶq
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
							woStmtb.setString(3,"RUNCARD CANCELED");   //�ק��u�O�ƶq
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

							// %%%%%%%%%%%%%%%%%%% �g�JRun card Move Transaction %%%%%%%%%%%%%%%%%%%_�_
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
							out.print("<br>  �u�O:"+woNo+"     �y�{�d��:"+aMFGRCDeleteCode[i][2]+"    �ƶq:"+aMFGRCDeleteCode[i][6]+"  �v�R��!!"); 
						}//end if
					}//end for y  	 
				} //end for
			} //if (( woPassFlag =="Y" || woPassFlag.equals("Y")) && (interfaceFlag=="Y" || interfaceFlag.equals("Y")) )
			// %%%%%%%%%%%%%%%%%%% �g�JRun card Move Transaction %%%%%%%%%%%%%%%%%%%_�� 

		}//arrMFGRCDeleteBean !=null	 	  
	}
	//========���벣�y�{�d�R��,�u�O�ƶq���...��	(ACTION=021)   �y�{�d�i�}042 -->�y�{�d�R����050   add by liling 2006/10/31

	errorFlag ="99999";
	out.println("<BR>");
	//out.println("<A HREF='../ORADDSMainMenu.jsp'>");%><font size="2">�^����</font><%out.println("</A>");

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

// �Y��q�u�O,��e�q�u�O���u�帹(�y�{�d��)�T�{��}�C�M��
if (woType.equals("3"))
{
	if (aMFGLotMatchCode!=null)
	{
		arrayLotIssueCheckBean.setArray2DString(null); // ���q�u�O��������Ƨ帹��M��
	}
}

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

