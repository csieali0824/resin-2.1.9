<!--20090505 liling �s�W txnDate+sTime �t�ήɶ�,���key�����ʤ�,�s��YEW_RUNCARD_ALL \RES_EMPLOYEE_OP,���槹���M���ť�->
<!--20200506 liling ������J�w�ʧ@,���WMS���� 6/27��s�t��-->
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
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR �y�{�d������-> �y�{�d���u�J�w -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSCMfgRCCompleteMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
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
String sTime = request.getParameter("STIME");

String runCardCount=String.valueOf(runCardCountI);  //�y�{�d�i��
//out.print("woNo="+woNo+"<br>");
//out.print("����ƶq="+runCardCountD);
if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
// MFG�u�O���_�Ѽƨ�

// 2005/12/03 ��session ��Bean ��������ͺޫ����������N�X // By Kerwin

String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR �y�{�d������-> �y�{�d���u�J�w


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

// ���s�J����榡��US�Ҷq,�N�y�t���]������
String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
//�����s�ɫ�^�_	  

//����t�Τ��
String systemDate ="",txnDate="";  //20090505

// �������� organization_code �qORG�Ѽ���
String organCode ="";
String organizationID = "";
Statement stateOrgCode=con.createStatement();
//out.println("select a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' ");
ResultSet rsOrgCode=stateOrgCode.executeQuery("select  TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE , substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME ,a.ORGANIZATION_CODE, a.ORGANIZATION_ID from MTL_PARAMETERS a, APPS.YEW_WORKORDER_ALL b where a.ORGANIZATION_ID = b.ORGANIZATION_ID and b.WO_NO = '"+woNo+"' " );
if (rsOrgCode.next())
{
   organCode=rsOrgCode.getString("ORGANIZATION_CODE");	 
   organizationID =rsOrgCode.getString("ORGANIZATION_ID");	
   systemDate=rsOrgCode.getString("SYSTEMDATE");	
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
		//out.println("processDateTime  = "+processDateTime);
	}
	rsDate.close();
	stateDate.close();	   
}    // �o��J�w������..������A
 
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // ��Promise Date    
     
   
//String sourceTypeCode = "INTERNAL"; 
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

	//MFG�y�{�d���u�J�w_�_	(ACTION=012)   �y�{�d������044 --> �y�{�d���u�J�w046(�ݧP�_�O�_�������̫�@��)
	if (actionID.equals("012") && fromStatusID.equals("046"))   // �p�� n��, �Y�� n-1�� --> �� n ��
	{  
    	String fndUserName = "";  //�B�z�H��
		String woUOM = ""; // �u�O�������
		String compSubInventory = null;
		String altRouting = "1"; //
		String opSupplierLot = "";
		int primaryItemID = 0;
		float runCardQtyf=0,overQty=0,overSRQty=0; 
		entityId = "0"; // �u�Owip_entity_id
		boolean interfaceErr = false;  // �P�_�䤤 Interface �����`���X��
		if (aMFGRCCompleteCode!=null)
		{	  
	  		if (aMFGRCCompleteCode.length>0)
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
		   
		   		//��������ƶq�����_�_	                     
				String sqlUOM = " select DISTINCT a.WO_UOM, b.WIP_ENTITY_ID, b.PRIMARY_ITEM_ID ,a.OE_ORDER_NO,a.COMPLETION_SUBINVENTORY, "+
						        " a.ALTERNATE_ROUTING, a.SUPPLIER_LOT_NO, a.ORGANIZATION_ID "+
						        " from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
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
	  		}
	  
	  		for (int i=0;i<aMFGRCCompleteCode.length-1;i++)
	  		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
	    			if (choice[k]==aMFGRCCompleteCode[i][0] || choice[k].equals(aMFGRCCompleteCode[i][0]))
	    			{
						if (Float.parseFloat(aMFGRCCompleteCode[i][2])>=0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o
					  	{
							int toIntOpSType = 1; 
						   	int transType = 1;    
						   	if (aMFGRCCompleteCode[i][5]==null || aMFGRCCompleteCode[i][5]=="0" || aMFGRCCompleteCode[i][5].equals("0")) 
						   	{ 
								toIntOpSType = 3; 
							 	aMFGRCCompleteCode[i][5] = aMFGRCCompleteCode[i][4]; // �L�U�@����Seq No,�G������
							 	transType = 2;
		   					}
		   
							float  rcMQty = 0;   
						   	float  rcScrapQty = 0;  
						   	String supplierLotNo = null;   
		   					java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // ���p�ƫ�T�� 
		   
		                 	String sqlMQty = " select b.QTY_IN_QUEUE, TRANSACTION_QUANTITY as PREVCOMPQTY, "+
						                     " a.COMPLETION_SUBINVENTORY, a.WAFER_LOT_NO , b.RES_EMPLOYEE_OP "+
						                     " from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b, WIP_MOVE_TRANSACTIONS c "+
									         " where b.WIP_ENTITY_ID = c.WIP_ENTITY_ID and c.organization_id = a.organization_id and a.WO_NO = b.WO_NO and a.WO_NO = '"+woNo+ "' "+
										     " and b.RUNCARD_NO= c.ATTRIBUTE2 "+
										     " and c.TO_INTRAOPERATION_STEP_TYPE = 1 "+ // ��QUEUE�����ƶq�Y�e�@�����~�]��,����1
										     " and b.RUNCARD_NO='"+aMFGRCCompleteCode[i][1]+"' and to_char(c.FM_OPERATION_SEQ_NUM) = '"+aMFGRCCompleteCode[i][3]+"' ";        
						 	Statement stateMQty=con.createStatement();
                         	ResultSet rsMQty=stateMQty.executeQuery(sqlMQty);
						 	if (rsMQty.next())
						 	{
						   		if (aMFGRCCompleteCode[i][2]==null || aMFGRCCompleteCode[i][2].equals("null")) aMFGRCCompleteCode[i][2]=Float.toString(rcMQty);
						   		rcMQty = rsMQty.getFloat("PREVCOMPQTY");		//��e�����u�ƶq	
						   		rcScrapQty = rcMQty - Float.parseFloat(aMFGRCCompleteCode[i][2]);  // ���o�ƶq = ��미�ƶq - ��J�����ƶq						   
						   		supplierLotNo = rsMQty.getString("WAFER_LOT_NO");	              // �����ӧ帹
                           		txnDate = rsMQty.getString("RES_EMPLOYEE_OP");	                  // 20090505 �������		
						    	String strScrapQty = nf.format(rcScrapQty);
								java.math.BigDecimal bd = new java.math.BigDecimal(strScrapQty);
								java.math.BigDecimal scrapQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
								rcScrapQty =scrapQty.floatValue();
							   	rcScrapQty = Float.parseFloat(aMFGRCCompleteCode[i][11]); // �޲z���Ҧ�,�B��ʵ��w�F���o��,�h�H���w�����o�ƤJScrap
						 	}
						 	rsMQty.close();
						 	stateMQty.close();
		 					
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

		 					String overSRFlag="";
				      		float remainSRQueueQty=0;
		         	  		Statement stateSRM=con.createStatement();
                      		ResultSet rsSRM=stateSRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+"  and OPERATION_SEQ_NUM = "+aMFGRCCompleteCode[i][4]+" "); //20091123 liling add organization_id
			          		if (rsSRM.next()) 
							{ 
								remainSRQueueQty = rsSRM.getFloat("QUANTITY_IN_QUEUE"); 
							}
			          		rsSRM.close();
	   		          		stateSRM.close();
			          
					  		if (Float.parseFloat(aMFGRCCompleteCode[i][11]) > remainSRQueueQty)//�Y���o�Ƥj��i����,��ܳ��oovercompletion
		              		{
					     		overSRQty = Float.parseFloat(aMFGRCCompleteCode[i][11])-remainSRQueueQty; 
						 		String strOverSRQty = nf.format(overSRQty);
				         		java.math.BigDecimal bd = new java.math.BigDecimal(strOverSRQty);
				         		java.math.BigDecimal overCompSRQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				         		overSRQty = overCompSRQty.floatValue();
						 		overSRFlag = "Y";   //���w�W����flag
						 		if (overSRQty==0) // By Kerwin 2007/04/17
				         		{
				           			overSRFlag = "N";   //�Y�p��|�ˤ��J��T��ᤴ��0,�h���w�W����flag = N
				         		}
					  		}
		 	 
		 					String getErrScrapBuffer = "";
		 					int getRetScrapCode = 0;
		 					if (rcScrapQty>0)  
		 					{	
		   						toIntOpSType = 5;  // ���o��to InterOperation Step Type = 5
		   						transType = 1; // ���o��Transaction Type = 1(Move Transaction)
           						String SqlScrap=" insert into WIP_MOVE_TXN_INTERFACE( "+
				           						" CREATED_BY_NAME, CREATION_DATE, LAST_UPDATE_DATE, LAST_UPDATED_BY_NAME, ORGANIZATION_CODE, ORGANIZATION_ID, "+
				                                " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_DATE, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
				                                " WIP_ENTITY_ID, WIP_ENTITY_NAME, FM_INTRAOPERATION_STEP_TYPE, FM_OPERATION_SEQ_NUM, "+
				                                " TO_INTRAOPERATION_STEP_TYPE, TO_OPERATION_SEQ_NUM, ATTRIBUTE2, TRANSACTION_TYPE, "+
						   						" GROUP_ID, SCRAP_ACCOUNT_ID, REASON_ID, TRANSACTION_ID ";
		   						String SqlSc2 = " ,OVERCOMPLETION_TRANSACTION_QTY ";			
		   						String SqlSc3 = " values(?,SYSDATE,SYSDATE,?,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,WIP_TRANSACTIONS_S.NEXTVAL,?,?, WIP_TRANSACTIONS_S.NEXTVAL ";   
		   						String SqlSc4 = " ,? ";  //OVERCOMPLETION_TRANSACTION_QTY
		   						String SqlSc5 = " ) ";    
		   						if (overSRFlag == "Y" || overSRFlag.equals("Y"))
           						{ 
									SqlScrap=SqlScrap+SqlSc2+SqlSc5+SqlSc3+SqlSc4+SqlSc5; 
								}
           						else
           						{ 
									SqlScrap=SqlScrap+SqlSc5+SqlSc3+SqlSc5; 
								}

           						PreparedStatement scrapstmt=con.prepareStatement(SqlScrap); 
           						scrapstmt.setString(1,fndUserName);    //out.println("fndUserName="+fndUserName); // CREATED_BY_NAME
							   	scrapstmt.setString(2,fndUserName);    //out.println("fndUserName="+fndUserName);  // LAST_UPDATED_BY_NAME
							   	scrapstmt.setString(3,organCode);      //out.println("organCode="+organCode);   // ORGANIZATION_CODE
							   	scrapstmt.setInt(4,Integer.parseInt(organizationID)); //out.println("organizationID="+organizationID);   // ORGANIZATION_ID
							   	scrapstmt.setInt(5,1);      //PROCESS_PHASE   1=Move Validation, 2=Move Processing, 3= Operation Backflush Setup
							   	scrapstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error	  (2006/12/08 �אּ Running )     
							   	scrapstmt.setFloat(7,rcScrapQty); out.println("<BR>�y�{�d:"+aMFGRCCompleteCode[i][1]+"(���o�ƶq="+rcScrapQty+")  ");       	   
							   	scrapstmt.setString(8,woUOM);
							   	scrapstmt.setInt(9,Integer.parseInt(entityId));  
							   	scrapstmt.setString(10,woNo);  
							   	scrapstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       						scrapstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); //out.println("FMOPSEQ="+aMFGRCMovingCode[i][4]); // LAST_UPDATE_DATE// FM_OPERATION_SEQ_NUM(����)		  
	       						scrapstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       						scrapstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][4])); // TO_OPERATION_SEQ_NUM  //���o�Y��From = To
	       						scrapstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
		   						scrapstmt.setInt(16,transType);	// TRANSACTION_TYPE   1= Move transaction,  2=Move Completion, 3=Move Return 
		   						scrapstmt.setInt(17,scrpAccID);	// SCRAP_ACCOUNT_ID  (I)���o  ( 01-11-000-7650-951-0-000 ) 
		   						scrapstmt.setInt(18,7);	// REASON_ID  �s�{���`
		   						if (overSRFlag == "Y" || overSRFlag.equals("Y"))
           						{ 
									scrapstmt.setFloat(19,overSRQty); 
								} 
           						scrapstmt.executeUpdate();
           						scrapstmt.close();	      	
		   
							    //����g�JInterface��Group����T_�_
							    int groupID = 0;
							    int opSeqNo = 0;              
						 		String sqlGrp = " select GROUP_ID,TO_OPERATION_SEQ_NUM  from WIP.WIP_MOVE_TXN_INTERFACE "+
 									            " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" "+   //20091123 liling add organization_id
										        " and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
										        " and TO_INTRAOPERATION_STEP_TYPE = 5 "; // ���������o��group
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
										out.println("Exception:"+e.getMessage()); 
									}  
		  						}
		 					} 
		 
		 					String getErrBuffer = "",overFlag="";
		 					int getRetCode = 0; 
		 					float prevQty = 0; 		   		     
		 					if (getRetScrapCode==0)   // �Y�������o���\,�h�i�沾��Interface
		 					{
             					String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
						   					  "  where step_type=1 and FM_OPERATION_SEQ_NUM  = '"+aMFGRCCompleteCode[i][3]+"' "+
						   					  "  and runcard_no = '"+aMFGRCCompleteCode[i][1]+"' ";
								Statement statepre=con.createStatement();
            					ResultSet rspre=statepre.executeQuery(sqlpre);
								if (rspre.next())
								{
			  						prevQty = rspre.getFloat(1);  //�e�������ƶq
								}
								rspre.close();
								statepre.close();

								prevQty	=(prevQty*1000) -(Float.parseFloat("0"+rcScrapQty)*1000);
								prevQty	=prevQty/1000;
								if (prevQty<0) prevQty=0;

								if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > prevQty )   //�Y�����Ƥj��e��������,���overcompletion
            					{
									overQty = (Float.parseFloat(aMFGRCCompleteCode[i][2])*1000) - (prevQty*1000) ;    //������-�y�{�d��=�W�X�ƶq
									overQty =overQty/1000;
									String strOverQty = nf.format(overQty);
									java.math.BigDecimal bd = new java.math.BigDecimal(strOverQty);
									java.math.BigDecimal overCompQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
									overQty = overCompQty.floatValue();	
                					overFlag = "Y";   //���w�W����flag
									if (overQty==0) // By Kerwin 2007/04/17
									{
				  						overFlag = "N";   //�Y�p��|�ˤ��J��T��ᤴ��0,�h���w�W����flag = N
									}
            					} 
								else  
								{
			          				// �A�P�_�O�_�w�W�L�ӯ��i������,�Y�O,�h����OverComp_�_
					  				float remainQueueQty=0;
					  				Statement stateRM=con.createStatement();
                      				ResultSet rsRM=stateRM.executeQuery(" select QUANTITY_IN_QUEUE from WIP_OPERATIONS where WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+"  and OPERATION_SEQ_NUM = "+aMFGRCCompleteCode[i][4]+" ");  //20091123 liling add organization_id
			          				if (rsRM.next()) 
									{ 
										remainQueueQty = rsRM.getFloat("QUANTITY_IN_QUEUE"); 
									}
			          				rsRM.close();
	   		          				stateRM.close();					  
					  
					  				if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > remainQueueQty)
					  				{
										overQty = (Float.parseFloat(aMFGRCCompleteCode[i][2])*1000)-(remainQueueQty*1000);
										overQty = overQty/1000; 
										String strOverQty = nf.format(overQty);
										java.math.BigDecimal bd = new java.math.BigDecimal(strOverQty);
										java.math.BigDecimal overCompQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
										overQty = overCompQty.floatValue();
										overFlag = "Y";   //���w�W����flag
										if (overQty==0) // By Kerwin 2007/04/17
										{
											overFlag = "N";   //�Y�p��|�ˤ��J��T��ᤴ��0,�h���w�W����flag = N
										}
					  				} 
									else 
									{
					           			overFlag = "N"; 
					         		}
				   				}
								
							   	toIntOpSType = 3;  // ���u������to InterOperation Step Type = 3
							   	transType = 1;     // ���u�� Transaction Type(�אּ Move Transaction,��MMT�h�M�w�N�u��Complete)
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
           						seqstmt.setInt(6,2);      //PROCESS_STATUS 1=PENDING , 2=RUNNING , 3=Error ( 2006/12/08 �אּ Running )
		   						seqstmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); // �����ƶq
           						seqstmt.setString(8,woUOM);
	       						seqstmt.setInt(9,Integer.parseInt(entityId));  
	       						seqstmt.setString(10,woNo);  //out.println("�u�O��="+woNo);
	       						seqstmt.setInt(11,1); // FM_INTRAOPERATION_STEP_TYPE 1=Queue 2=RUN, 3=TO_MOVE, 5=SCRAP
	       						seqstmt.setInt(12,Integer.parseInt(aMFGRCCompleteCode[i][4])); // FM_OPERATION_SEQ_NUM(����)
	       						seqstmt.setInt(13,toIntOpSType); // TO_INTRAOPERATION_STEP_TYPE  1=Queue 2=RUN, 3=TO_MOVE(���u), 5=SCRAP(���o)
	       						seqstmt.setInt(14,Integer.parseInt(aMFGRCCompleteCode[i][5])); // TO_OPERATION_SEQ_NUM  // Integer.parseInt(aMFGRCMovingCode[i][5])
	       						seqstmt.setString(15,aMFGRCCompleteCode[i][1]);	//out.println("�y�{�d��="+aMFGRCMovingCode[i][1]); // ATTRIBUTE2 �y�{�d�� 
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
 									            " where WIP_ENTITY_NAME = '"+woNo+ "' and WIP_ENTITY_ID = "+entityId+" and organization_id= "+organizationID+" "+  //20091123 liling add organization_id
										        " and ATTRIBUTE2 = '"+aMFGRCCompleteCode[i][1]+"' "+ // 2006/11/17 By RunCardNo
										        " and PROCESS_STATUS = 2 "+ // 2006/12/08 By Process Status=2
										        " and TO_INTRAOPERATION_STEP_TYPE = 3 "; // ������������Group ID
						 		Statement stateGrp=con.createStatement();
                         		ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 		if (rsGrp.next())
						 		{
						   			groupID = rsGrp.getInt("GROUP_ID");
						   			opSeqNo =  rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						 		}
						 		rsGrp.close();
						 		stateGrp.close();
						 
								out.println("  ���u��groupID ="+groupID+"   ");	 
		 						
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
										out.println("Exception:"+e.getMessage()); 
									}  
		  						} 
							}
			  
							if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s
							{ 
								boolean singleOp = false;  // �w�]���������̫�@��
								String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
											  " DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
											  " from WIP_OPERATIONS "+
											  " where PREVIOUS_OPERATION_SEQ_NUM = '"+aMFGRCCompleteCode[i][4]+"' "+ // �]�w���\(getRetScrapCode==0 && getRetCode==0.�G�e�@��������)
											  " and WIP_ENTITY_ID ="+entityId+" and organization_id= "+organizationID+" ";	  //20091123 liling add organization_id
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
					 				Statement stateMax=con.createStatement();
                     				ResultSet rsMax=stateMax.executeQuery("select NEXT_OPERATION_SEQ_NUM from WIP_OPERATIONS where OPERATION_SEQ_NUM = '"+aMFGRCCompleteCode[i][4]+"' and WIP_ENTITY_ID ="+entityId+" and organization_id= "+organizationID+"  ");  //20091123 liling add organization_id
					 				if (rsMax.next() && (rsMax.getString(1)==null || rsMax.getString(1).equals("")) )
					 				{
					   					singleOp = true;					   
					 				} 
									else out.println("�U�@���N�X="+rsMax.getString(1));
					 				
									rsMax.close();
					 				stateMax.close();					 
	               				}
	               				rsp.close();
                   				statep.close(); 				   

          						float overValue=0;
          						if (overFlag=="Y" || overFlag.equals("Y"))
          						{ 
				            		String sqlOver=" select OVERCOMPLETION_PRIMARY_QTY from wip_move_transactions where TO_INTRAOPERATION_STEP_TYPE=1 "+
                           						   " and wip_entity_id = "+entityId+" and organization_id= "+organizationID+" "+
			  			                           " and ATTRIBUTE2= '"+aMFGRCCompleteCode[i][1]+"' and FM_OPERATION_SEQ_NUM = "+aMFGRCCompleteCode[i][4]+" ";
		    						Statement stateOver=con.createStatement();	   
	        						ResultSet rsOver=stateOver.executeQuery(sqlOver); 
	        						if (rsOver.next())
	        						{ 
										overValue = rsOver.getFloat(1); 
									}
		    						rsOver.close();
		    						stateOver.close();	
           						} else overValue=0;

		   						String SqlQueueTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				                                     " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				                                     " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				                                     " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				                                     " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						                             " LASTUPDATE_DATE, OVERCOMPLETE_QTY, ACTIONID, ACTIONNAME , QTY_AC_SCRAP, QTY_AC_TOMOVE ) "+  // 2007/04/03 �W�[�g�J���o�ƤΨ}�~��
				                                     " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE,?, '"+actionID+"', '"+actionName+"', '"+aMFGRCCompleteCode[i][11]+"', '"+aMFGRCCompleteCode[i][2]+"') ";  						
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
		 
								if (rcScrapQty>0)  // �P�_�Y���o�ƶq�j��s,�h�I�s�g�J���o RUNCARD Transaction
								{ 		 
		  							// %%%%%%%%%%%%%%%%%%% �g�JRun card Scrap Transaction %%%%%%%%%%%%%%%%%%%_�_
		   							String SqlScrapTrans=" insert into APPS.YEW_RUNCARD_TRANSACTIONS( "+
				           								 " RUNCAD_ID, RC_TRANSACTION_ID, RUNCARD_NO, ORGANIZATION_ID, WIP_ENTITY_ID, PRIMARY_ITEM_ID, "+
				           								 " TRANSACTION_DATE, FM_OPERATION_SEQ_NUM, FM_OPERATION_CODE, TO_OPERATION_SEQ_NUM, TO_OPERATION_CODE, "+
				           								 " TRANSACTION_QUANTITY, TRANSACTION_UOM, STEP_TYPE, STEP_TYPE_DESC, "+
				           								 " CUSTOMER_LOT_NO, RCSTATUSID, RCSTATUS, LASTUPDATE_BY, "+
						   								 " LASTUPDATE_DATE, ACTIONID, ACTIONNAME , QTY_AC_SCRAP, QTY_AC_TOMOVE ) "+  // 2007/04/03 �W�[�g�J���o�ƤΨ}�~��
				                                         " values(?,YEW_RCARD_TRANSACTIONS_S.NEXTVAL,?,?,?,?,to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss'),?,?,?,?,?,?,?,?,?,?,?,?,SYSDATE, '"+actionID+"', '"+actionName+"', '"+aMFGRCCompleteCode[i][11]+"', '"+aMFGRCCompleteCode[i][2]+"') ";  						
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
		  						}  // End of if (rcScrapQty>0)	
								
		  //20200506 liling ������J�w�ʧ@,���WMS����--�_
		 /*
		 						try
		 						{
	              					Statement stateMSEQ=con.createStatement();	             
	              					ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
				  					if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
				  					rsMSEQ.close();
				  					stateMSEQ.close();
				  
		  							if (woType.equals("3"))	
		  							{   
		    							if (altRouting.equals("2")) 
										{ 
											opSupplierLot=opSupplierLot; 
										} // �p�G��q�u�O�B���~��,�h�H�t�ӧ帹�@���g�JMMT ��LOT�� RESERVATION�̾�	
										else 
										{ // ��q�u�O�ۻs
			       							opSupplierLot=aMFGRCCompleteCode[i][1]; // �y�{�d�����帹
			     						}
		  							}	
									else 
									{  // ���ΤΫe�q�u�O
		           						opSupplierLot=aMFGRCCompleteCode[i][1];
		         					}  		  
		  							
									String sqlInsMMT = "insert into MTL_TRANSACTIONS_INTERFACE"+
		                                               "(TRANSACTION_INTERFACE_ID"+
													   ",SOURCE_CODE"+
													   ",SOURCE_HEADER_ID"+
													   ",SOURCE_LINE_ID"+
													   ",PROCESS_FLAG"+
							                           ",TRANSACTION_MODE"+
													   ",INVENTORY_ITEM_ID"+
													   ",ORGANIZATION_ID"+
													   ",SUBINVENTORY_CODE"+
													   ",TRANSACTION_QUANTITY"+
													   ",TRANSACTION_UOM"+
													   ",PRIMARY_QUANTITY"+
													   ",TRANSACTION_DATE"+
													   ",TRANSACTION_SOURCE_ID"+
													   ",TRANSACTION_TYPE_ID"+
													   ",WIP_ENTITY_TYPE"+
													   ",OPERATION_SEQ_NUM"+
													   ",LAST_UPDATE_DATE"+
													   ",LAST_UPDATED_BY"+
													   ",CREATION_DATE"+
													   ",CREATED_BY"+
													   ",ATTRIBUTE1"+
													   ",ATTRIBUTE2"+
													   ",LOCK_FLAG"+
													   ",TRANSACTION_HEADER_ID"+
													   ",FINAL_COMPLETION_FLAG"+
													   ",VENDOR_LOT_NUMBER"+
													   ",TRANSACTION_SOURCE_TYPE_ID) "+
							                           " VALUES "+
													   "(MTL_MATERIAL_TRANSACTIONS_S.CURRVAL"+
													   ",'WIP'"+
													   ",?"+
													   ",?"+
													   ",1"+
													   ",2"+
													   ",?"+
													   ",?"+
													   ",?"+
													   ",?"+
													   ",?"+
													   ",?"+
													   ",to_date('"+txnDate+"'||'"+sTime+"','yyyymmddhh24miss')"+
													   ",?"+
													   ",44"+
													   ",1"+
													   ",?"+
													   ",SYSDATE"+
													   ",-1"+
													   ",SYSDATE"+
													   ",?"+
													   ",?"+
													   ",?"+
													   ",1"+
													   ",MTL_MATERIAL_TRANSACTIONS_S.CURRVAL"+
													   ",'Y'"+
													   ",?"+
													   ",5) ";   // CREATION_BY, LOT_NO, MO_NO, LOCK_FLAG = 2(Interface Error�i�H���s�QRepeocess)
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

		  
									//�줣������� DATE_CODE by SHIN20090730
									String runcardDateCode   = "";
									String sqlfnd = " select RC_DATE_CODE from APPS.YEW_RUNCARD_ALL where RUNCARD_NO= '"+aMFGRCCompleteCode[i][1]+"' ";	 		
									Statement stateFndDC=con.createStatement();
									ResultSet rsFndDC=stateFndDC.executeQuery(sqlfnd);
									if (rsFndDC.next())
									{
										runcardDateCode = rsFndDC.getString("RC_DATE_CODE");
										out.print("  RC_DATE_CODE="+runcardDateCode+"<br>"); 
									}
									rsFndDC.close();
									stateFndDC.close(); 

		  							//out.println("Step2. �g�JMMT Lot Interface<BR>"); �[�JDATE_CODE by SHIN20090730
		    						String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
		                                                  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
								                          "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ,ATTRIBUTE1, ATTRIBUTE2, DATE_CODE) "+ 
								                          "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?,?,?,?) ";
	        						PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
									mmtLotStmt.setString(1,opSupplierLot);                                 // LOT_NUMBER(�y�{�d��)
		    						mmtLotStmt.setFloat(2,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	   // TRANSACTION_QUANTITY
		    						mmtLotStmt.setFloat(3,Float.parseFloat(aMFGRCCompleteCode[i][2]));	   // PRIMARY_QUANTITY 
		    						mmtLotStmt.setInt(4,Integer.parseInt(userMfgUserID));	//out.println("userMfgUserID"+userMfgUserID);    // LAST_UPDATED_BY 								 
		    						mmtLotStmt.setInt(5,Integer.parseInt(userMfgUserID));	       // CREATED_BY 
									mmtLotStmt.setString(6,oeOrderNo);                             //ATTRIBUTE1  MO_NO
		    						mmtLotStmt.setString(7,opSupplierLot);                         //ATTRIBUTE2  LOT_NO (�y�{�d��)
		    						mmtLotStmt.setString(8,runcardDateCode);                       //DATE_CODE
									mmtLotStmt.executeUpdate();
            						mmtLotStmt.close();
								} // End of try
								catch (Exception e)
        						{
           							out.println("Exception MMT & LOT Interface:"+e.getMessage());
        						}	


   								String errorMsg = "";
   								try
   								{
							  		Statement stateResp=con.createStatement();	   
							  		ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME like 'YEW_INV_SEMI_SU%' "); 
							  		if (rsResp.next())
							  		{
	     								respID = rsResp.getString("RESPONSIBILITY_ID");
	  								} 
									else 
									{
	           							respID = "50776"; // �䤣��h�w�] --> YEW INV Super User �w�]
	         						}
			 						rsResp.close();
			 						stateResp.close();	  

	  								String grpHeaderID = "";
	  								String devStatus = "";
	  								String devMessage = "";
	              					
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
                 					out.println("Procedure : Execute Success !!! ");	             
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
				   						out.println("Success Submit !!!  ");
				   						out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
				   						woPassFlag="Y";	// ���\�g�J���X��
				   						con.commit(); // �Y���\,�h�@Commit,,����Entity_ID�L�~				   			  
				 					}
	   							}// end of try
       							catch (Exception e)
       							{
           							out.println("Exception WIP_MMT_REQUEST:"+e.getMessage());
       							}	

       							//�줣�������  ORDER NO
	    						String orderHeaderId="",orderLineId=""; 
								String sqlfnd = " select YWA.OE_ORDER_NO,YWA.ORDER_HEADER_ID,YWA.ORDER_LINE_ID,YWA.INV_ITEM  "+
 						                        " from APPS.YEW_WORKORDER_ALL YWA ,APPS.YEW_RUNCARD_ALL YRA   "+
						                        " where YWA.WO_NO=YRA.WO_NO and YRA.RUNCARD_NO= '"+aMFGRCCompleteCode[i][1]+"' ";	 		
								Statement stateFndId=con.createStatement();
        						ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
								if (rsFndId.next())
								{
			  						oeOrderNo = rsFndId.getString("OE_ORDER_NO"); 
			  						orderHeaderId = rsFndId.getString("ORDER_HEADER_ID");
			  						orderLineId = rsFndId.getString("ORDER_LINE_ID");
			  						invItem = rsFndId.getString("INV_ITEM");
								} 
								else 
								{  
									oeOrderNo = "0"; 
								}
								rsFndId.close();
								stateFndId.close(); 
	
								// 2007/01/30 �� ��q�u�O �~,���u�Τu�{����p��MO��,���ݧ@ Reservation_By Kerwin
    							if ((woType=="3" || woType.equals("3") || oeOrderNo.length()>1) && (woPassFlag=="Y" || woPassFlag.equals("Y")))  //interface�ݦ��\�g�J�~�gReservaton
    							{
	   								String sourceHeaderId="",rsInterfaceId="",requireDate="",resvFlag="";
	   								float  resvQty=0,orderQty=0,avaiResvQty=0,resTxnQty=0;
       								int resvType=1,resOrderLineId=0;
									//float wipResQty=Float.parseFloat(aMFGRCCompleteCode[i][2]);  //add by Peggy 20191004
									float wipResQty=Float.parseFloat(aMFGRCCompleteCode[i][2])*1000;  //add by Peggy 20191004

									String sqlfndb = " SELECT sales_order_id FROM mtl_sales_orders a, oe_order_headers_all b ,oe_transaction_types_tl c ,oe_order_lines_all ool "+
													 " WHERE a.segment1 = TO_CHAR(b.order_number)  and b.order_number='"+oeOrderNo+"' and ool.SHIP_FROM_ORG_ID = "+organizationId+" "+
													 " and a.segment2=c.name   and c.transaction_type_id=b.order_type_id   and c.language='US' "+
													 " AND ool.header_id = b.header_id AND ool.inventory_item_id='"+primaryItemID+"' ";
									Statement stateFndIdb=con.createStatement();
									ResultSet rsFndIdb=stateFndIdb.executeQuery(sqlfndb);
									if (rsFndIdb.next())
									{
										sourceHeaderId = rsFndIdb.getString("sales_order_id"); 
									}
									rsFndIdb.close();
									stateFndIdb.close(); 		

									resvFlag ="N";
									//Statement stateSplit=con.createStatement();
									//ResultSet rsSplit=stateSplit.executeQuery("select LINE_ID from OE_ORDER_LINES_ALL where HEADER_ID="+orderHeaderId+" and SPLIT_FROM_LINE_ID ="+orderLineId+" and OPEN_FLAG='Y' ");
									//if (rsSplit.next())
									//{
									//	orderLineId = rsSplit.getString("LINE_ID"); // 2007/01/30 By Kerwin for Split Line Close,Find Split lind Id
									//}
									//rsSplit.close();
									//stateSplit.close(); 
									
									////��w�s�b��reservation qty �P�q��ۤ�  mtl_sales_orders HEADER_ID
									//String sqlfndb1 =" select nvl(sum(decode(MTR.RESERVATION_UOM_CODE,'PCE',MTR.RESERVATION_QUANTITY/1000,MTR.RESERVATION_QUANTITY )),0) RESV_QTY, "+
									//				 " nvl(sum(decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY)),0) ORDER_QTY , "+
									//				 " to_char(trunc(SCHEDULE_SHIP_DATE),'YYYYMMDD') SCHEDULE_SHIP_DATE "+
									//				 " from MTL_RESERVATIONS MTR "+
									//				 ",OE_ORDER_LINES_ALL OOL  "+
									//				 " where MTR.DEMAND_SOURCE_LINE_ID(+) = OOL.LINE_ID"+
									//				 " and OOL.LINE_ID = "+orderLineId+"  "+
									//				 " having nvl(sum(decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY)),0)-nvl(sum(decode(MTR.RESERVATION_UOM_CODE,'PCE',MTR.RESERVATION_QUANTITY/1000,MTR.RESERVATION_QUANTITY )),0)>0"+
									//				 "  group by SCHEDULE_SHIP_DATE ";
									String sqlfndb1 =" select ool.line_id"+
									                 " ,nvl(MTR.RESV_QTY,0) RESV_QTY"+
													 //", decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY) ORDER_QTY"+
													 ", decode(OOL.ORDER_QUANTITY_UOM,'KPC',OOL.ORDERED_QUANTITY*1000,OOL.ORDERED_QUANTITY) ORDER_QTY"+
													 ",to_char(SCHEDULE_SHIP_DATE,'YYYYMMDD') SCHEDULE_SHIP_DATE"+
                                                     " from (SELECT DEMAND_SOURCE_LINE_ID"+
													 //"      , nvl(sum(decode(RESERVATION_UOM_CODE,'PCE',RESERVATION_QUANTITY/1000,RESERVATION_QUANTITY )),0) RESV_QTY "+
													 "      , nvl(sum(decode(RESERVATION_UOM_CODE,'KPC',RESERVATION_QUANTITY*1000,RESERVATION_QUANTITY )),0) RESV_QTY "+
  													 "       FROM MTL_RESERVATIONS GROUP BY DEMAND_SOURCE_LINE_ID)  MTR "+
                                                     " ,OE_ORDER_LINES_ALL OOL "+
                                                     " where MTR.DEMAND_SOURCE_LINE_ID(+) = OOL.LINE_ID"+
                                                     " and "+orderLineId+" in (OOL.LINE_ID, OOL.SPLIT_FROM_LINE_ID)"+
                                                     " and OOL.OPEN_FLAG='Y'"+
                                                     //" and decode(OOL.ORDER_QUANTITY_UOM,'PCE',OOL.ORDERED_QUANTITY/1000,OOL.ORDERED_QUANTITY)- nvl(MTR.RESV_QTY,0)>0"+
													 " and decode(OOL.ORDER_QUANTITY_UOM,'KPC',OOL.ORDERED_QUANTITY*1000,OOL.ORDERED_QUANTITY)- nvl(MTR.RESV_QTY,0)>0"+
                                                     " ORDER BY DECODE(ool.line_id,"+orderLineId+",1,2)";
									Statement stateFndIdb1=con.createStatement();
									ResultSet rsFndIdb1=stateFndIdb1.executeQuery(sqlfndb1);
									while (rsFndIdb1.next())
									{
										while (wipResQty>0)
										{
											requireDate = rsFndIdb1.getString("SCHEDULE_SHIP_DATE");     //�ݨD��
											resvQty = rsFndIdb1.getFloat("RESV_QTY");    //�v�Q�O�d��			  
											orderQty = rsFndIdb1.getFloat("ORDER_QTY");  //�q���
											avaiResvQty = orderQty - resvQty ;           //�i�O�d��  = �q��ƶq - �w�O�d��
											resOrderLineId = rsFndIdb1.getInt("line_id");  //add by Peggy 20191007
											
											//if (avaiResvQty<=0)
											//{
											//	resvFlag ="N";
											//	//out.print("<br>�L�q��q�i��Reservation,�L�ݦA����q��O�d!");
											//}
											//else if (Float.parseFloat(aMFGRCCompleteCode[i][2]) > avaiResvQty)   //�y�{�d��>�i�O�d��
											//else if (wipResQty > avaiResvQty)   //�y�{�d��>�i�O�d��
											if (wipResQty > avaiResvQty)   //�y�{�d��>�i�O�d��
											{
												resvFlag ="Y";
												resTxnQty = avaiResvQty;               //resversion qty=�Ѿl�i�O�d��
												//resTxnQty = resTxnQty * (woUOM.equals("KPC")?1000:1);
												//wipResQty = wipResQty * (woUOM.equals("KPC")?1000:1);
												wipResQty -=resTxnQty;
												//resTxnQty = resTxnQty / (woUOM.equals("KPC")?1000:1);
												//wipResQty = wipResQty / (woUOM.equals("KPC")?1000:1);
												//out.print("<br>�J�w�Ƥj��q���,����q��ƫO�d!");
											}
											else
											{
												//resTxnQty =  Float.parseFloat(aMFGRCCompleteCode[i][2]) ;   //resversion qty=�y�{�d�ƶq
												resTxnQty = wipResQty;  //modify by Peggy 20191004
												wipResQty=0;
												//out.print("<br>����q��ƫO�d���\!");
												resvFlag ="Y";
											} 
										
											//�P�_�P�@line_id�O�_�ΦP�@lot no ,�Y���P�@lot�h reservetion��update
											String revSql="select reservation_id from MTL_RESERVATIONS where lot_number= '"+opSupplierLot+"' and DEMAND_SOURCE_LINE_ID= "+orderLineId+" ";
											Statement stateRevType=con.createStatement();
											ResultSet rsRevType=stateRevType.executeQuery(revSql);
											if (rsRevType.next())
											{   
												resvType = 2;  
											}    //resvType 1=insert,2=update 
											else resvType=1;
			
											rsRevType.close();
											stateRevType.close(); 		 
											//out.print("sesseion2,type="+resvType);
			
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
													rsInStmt.setInt(1,Integer.parseInt(rsInterfaceId));	   // TO_ORGANIZATION_ID
													rsInStmt.setInt(2,Integer.parseInt(rsInterfaceId));		 
													rsInStmt.setDate(3,requirementDate);    //REQUIREMENT_DATE 
													rsInStmt.setInt(4,Integer.parseInt(organizationID));	   // ORGANIZATION_ID
													rsInStmt.setInt(5,Integer.parseInt(organizationID));	   // TO_ORGANIZATION_ID
													rsInStmt.setInt(6,primaryItemID);	                       // INVENTORY_ITEM_ID 								 
													rsInStmt.setString(7,invItem);	       						//ITEM_SEGMENT1
													rsInStmt.setInt(8,2);	      							    //DEMAND_SOURCE_TYPE_ID  2:sales order
													rsInStmt.setString(9,woUOM );	       //RESERVATION_UOM_CODE
													//rsInStmt.setFloat(10,resTxnQty);  //out.println("resTxnQty="+resTxnQty);	       //RESERVATION_QUANTITY		
													rsInStmt.setFloat(10,(resTxnQty / (woUOM.equals("KPC")?1000:1)));  //out.println("resTxnQty="+resTxnQty);	       //RESERVATION_QUANTITY		
													rsInStmt.setInt(11,13);	       // SUPPLY_SOURCE_TYPE_ID  13:inventory
													rsInStmt.setInt(12,1);	       //--ROW_STATUS_CODE 1-active 2-inactive
													rsInStmt.setInt(13,2);	       //LOCK_FLAG 1-yes 2-no
													rsInStmt.setInt(14,resvType);	       //RESERVATION_ACTION_CODE --  ( 1=Insert, 2=Update, 3=Delete, 4=Transfer )
													rsInStmt.setInt(15,3);	       //RANSACTION_MODE 3-background ( 3-background   1 -ONLINE  2 -CONCURRENT  )
													rsInStmt.setInt(16,1);	       //VALIDATION_FLAG 1-yes 2-no
													rsInStmt.setInt(17,Integer.parseInt(userMfgUserID));	       //LAST_UPDATE_BY
													rsInStmt.setInt(18,Integer.parseInt(userMfgUserID));	       //CREATE_BY
													rsInStmt.setString(19,compSubInventory);	                   //subinventory
													rsInStmt.setInt(20,2);	       //TO_DEMAND_SOURCE_TYPE_ID 2:sales order
													rsInStmt.setInt(21,13);	       //TO_SUPPLY_SOURCE_TYPE_ID 13:inventory
													rsInStmt.setString(22,opSupplierLot);	                      //lot number...�Y����q�~��,�h���t�ӧ帹,�_�h�Ҭ��y�{�d��
													rsInStmt.setInt(23,Integer.parseInt(sourceHeaderId));	     //DEMAND_SOURCE_HEADER_ID  sourceHeaderId
													//rsInStmt.setInt(24,Integer.parseInt(orderLineId));           //DEMAND_SOURCE_LINE_ID   order_line_id
													rsInStmt.setInt(24,resOrderLineId);                           //DEMAND_SOURCE_LINE_ID   order_line_id
													rsInStmt.executeUpdate();
													rsInStmt.close();
												}// end of try
												catch (Exception e)
												{
													out.println("Exception RESERVATIONS_REQUEST:"+e.getMessage());
												}	
			
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
													} 
													else 
													{
														respID = "50776"; // �䤣��h�w�] --> YEW INV Super User �w�]
													}
													rsResp.close();
													stateResp.close();	  
			  
													CallableStatement cs3 = con.prepareCall("{call TSC_YEW_INVRSVIN_REQUEST(?,?,?,?,?,?,?)}");			 
													cs3.setString(1,userMfgUserID);    //  user_id �ק�HID /	
													cs3.setString(2,respID);  //*  �ϥΪ�Responsibility ID --> YEW_INV_Semi_SU /				 
													cs3.registerOutParameter(3, Types.INTEGER); 
													cs3.registerOutParameter(4, Types.VARCHAR);                  //�^�� DEV_STATUS
													cs3.registerOutParameter(5, Types.VARCHAR);                  //�^�� DEV_MASSAGE
													cs3.setString(6,opSupplierLot);  //*  RUNCARD NO (�i��O�~�ʼt�ӧ帹��q�ۻs���t�ӧ帹)	
													cs3.setString(7,rsInterfaceId);  //   Reservation  Id /	
													cs3.execute();
													int requestID = cs3.getInt(3);
													devStatus = cs3.getString(4);   //  �^�� REQUEST ���檬�p
													devMessage = cs3.getString(5);   //  �^�� REQUEST ���檬�p�T��
													cs3.close();
						 
									 
													Statement stateError=con.createStatement();
													String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_RESERVATIONS_INTERFACE where RESERVATION_INTERFACE_ID= "+rsInterfaceId+" " ;	
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
										}
										if (wipResQty==0) break;
									}
									rsFndIdb1.close();
									stateFndIdb1.close();
									//add by Peggy 20191005
									if (wipResQty==0)
									{
										out.print("<br>����q��ƫO�d���\!");
									}
									else if (wipResQty>0)
									{
										if ((wipResQty / (woUOM.equals("KPC")?1000:1))==Float.parseFloat(aMFGRCCompleteCode[i][2]))
										{
											out.print("<br>�L�q��q�i��Reservation,�L�ݦA����q��O�d!");
										}
										else
										{
											out.print("<br>�J�w�Ƥj��q���,����q��ƫO�d"+(wipResQty / (woUOM.equals("KPC")?1000:1))+"K!");
										}
									}
									
	 							} //end if woType=3 
  */ //20200506 liling ������J�w�ʧ@,���WMS����
  String errorMsg = "";
	       						if (errorMsg.equals(""))
	       						{ 
		        					String rcSql=" update APPS.YEW_RUNCARD_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+
		                                         " QTY_IN_SCRAP=?, CLOSED_DATE=?, COMPLETION_QTY=?, QTY_IN_COMPLETE=?, QTY_IN_INPUT=? , RES_EMPLOYEE_OP='' "+  //20090505 liling add RES_EMPLOYEE_OP�M���ť�,�����ɤ~�|��t�Τ�
		                                         " where WO_NO= '"+woNo+"' and RUNCAD_ID='"+aMFGRCCompleteCode[i][0]+"' "; 	
                					PreparedStatement rcStmt=con.prepareStatement(rcSql);
	            					rcStmt.setInt(1,Integer.parseInt(userMfgUserID));
	            					rcStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		        					if (!singleOp) // �Y���������̫᯸(Routing�u���@���|�o�ͦ����p),�h�����b (044) ������
		        					{
	              						rcStmt.setString(3,getStatusRs.getString("TOSTATUSID")); 
	              						rcStmt.setString(4,getStatusRs.getString("STATUSNAME"));
				  						rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling �ץ��������o�����,�ӫD�����			  
		        					} 
									else 
									{ // �_�h,�Y��s�� 048�u�O���פ�
		                				rcStmt.setString(3,"048"); 
	                    				rcStmt.setString(4,"CLOSING");
				        				rcStmt.setFloat(5,rcScrapQty);	 //2006/12/11 liling �ץ��������o�����,�ӫD�����			  
		               				}
									rcStmt.setString(6,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
		        					rcStmt.setFloat(7,Float.parseFloat(aMFGRCCompleteCode[i][2])); 	
									rcStmt.setFloat(8,Float.parseFloat(aMFGRCCompleteCode[i][2])); 
									rcStmt.setFloat(9,Float.parseFloat(aMFGRCCompleteCode[i][2])+rcScrapQty); 	 // �B�z��		
			    					rcStmt.executeUpdate();   
                					rcStmt.close(); 
				
									// ��l������y�{�d���y�{�d���NWIP_USED_QTY���@�֥[_�_
				 					Statement stateParRC=con.createStatement();
                 					ResultSet rsParRC=stateParRC.executeQuery("select PRIMARY_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+aMFGRCCompleteCode[i][1]+"' ");
				 					if (rsParRC.next())
				 					{
				    					PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" where RUNCARD_NO='"+rsParRC.getString("PRIMARY_NO")+"' ");
										rcStmtUP.executeUpdate();   
                    					rcStmtUP.close(); 
				 					}
				 					rsParRC.close();
				
			  						String woSql=" update APPS.YEW_WORKORDER_ALL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, STATUSID=?, STATUS=?, "+		                  
						                         " DATE_COMPLETED=to_char(SYSDATE,'YYYYMMDDHH24MISS'), WO_COMPLETED_QTY=WO_COMPLETED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" "+
		                                         " where WO_NO= '"+woNo+"' "; 	
              						PreparedStatement woStmt=con.prepareStatement(woSql);
			  						woStmt.setInt(1,Integer.parseInt(userMfgUserID));
	          						woStmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
			  						woStmt.setString(3,"048"); 
	          						woStmt.setString(4,"CLOSING");			 
			  						woStmt.executeUpdate();   
              						woStmt.close();
			  
                             		rsParRC=stateParRC.executeQuery("select PRIMARY_PARENT_NO from YEW_MFG_TRAVELS_ALL where EXTEND_NO = '"+woNo+"' ");
				             		if (rsParRC.next())
				             		{
				                 		PreparedStatement rcStmtUP=con.prepareStatement("update YEW_RUNCARD_ALL set WIP_USED_QTY =WIP_USED_QTY+"+Float.parseFloat(aMFGRCCompleteCode[i][2])+" where WO_NO='"+rsParRC.getString("PRIMARY_PARENT_NO")+"' ");
					             		rcStmtUP.executeUpdate();   
                                 		rcStmtUP.close(); 
				             		}
				             		rsParRC.close();
				             		stateParRC.close();				
		     					}  // End of if (errorMsg.equals(""))	   
		  
		  					} // End of if (getRetScrapCode==0 && getRetCode==0) // �Y���o�β��������榨�\,�h����t�άy�{�β��ʧ�s 
		  					else 
							{
		          				interfaceErr = true;   // ��ܳ��o�Χ��u�J�wInterface�����`
		       				}   
		 				} //End of if (aMFGRCCompleteCode[i][2]>0) // �Y�]�w�����ƶq�j��0�~�i�沾���γ��o	
		 				out.print("<BR><font color='#0033CC'>�y�{�d("+aMFGRCCompleteCode[i][1]+")���u�J�wO.K.</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")<br><br></font>"); 
        			} // End of if (choice[k]==aMFGRCMovingCode[i][0] || choice[k].equals(aMFGRCMovingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // �P�_�ϥΪ̦�Check�~��s
     		} // End of for (i=0;i<aMFGRCMovingCode.length;i++)
   		} // end of if (aMFGRCCompleteCode!=null) 

    	// �ϥΧ����M��2���}�C
    	if (aMFGRCCompleteCode!=null)
		{ 
	  		arrMFGRCCompleteBean.setArray2DString(null); 
		}
	} // End of if (actionID.equals("012") && fromStatusID.equals("046"))
  	out.println("<BR>");
   
  	getStatusStat.close();
  	getStatusRs.close();  
} //end of try
catch (Exception e)
{
	e.printStackTrace();
   	out.println(e.getMessage());
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
    out.println(e.getMessage());
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
    out.println(e.getMessage());
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

