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
<jsp:useBean id="arrayLotIssueCheckBean" scope="session" class="ArrayCheckBoxBean"/>   <!--FOR 後段流程卡待投產 Match實際完工前段批號-->
<jsp:useBean id="arrMFGRCMovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡移站中 -->
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡移站中-> 流程卡完工入庫 -->
<jsp:useBean id="arrMFGRsUpdateBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 流程卡已展開-> 工時異動 liling --> 
<jsp:useBean id="arrMFGResourceBean" scope="session" class="Array2DimensionInputBean"/>
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
   
String runCardId=request.getParameter("RUNCARD_ID");
String interfaceId="";
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
float resourceQty = 0;
float machine_resourceQty = 0;//add by Peggy 20120604

String runCardCount=String.valueOf(runCardCountI);  //流程卡張數
String dateCodeSet = request.getParameter("DATECODE");  // 批次給定的投產DateCode
if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   

String aMFGWoExpandCode[][]=arrMFG2DWOExpandBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
String aMFGRCExpTransCode[][]=arrMFGRCExpTransBean.getArray2DContent();  // FOR 流程卡已展開-> 流程卡移站中
String aMFGRCMovingCode[][]=arrMFGRCMovingBean.getArray2DContent();      // FOR 流程卡移站中-> 流程卡移站中
String aMFGRCCompleteCode[][]=arrMFGRCCompleteBean.getArray2DContent();  // FOR 流程卡移站中-> 流程卡完工入庫
String aMFGRsUpdateCode[][]=arrMFGRsUpdateBean.getArray2DContent();  	// FOR 流程卡已展開-> 工時異動 liling
String aMFGLotMatchCode[][]=arrayLotIssueCheckBean.getArray2DContent();  // FOR 後段流程卡待投產 Match實際完工前段批號

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
	}
	rsDate.close();
	stateDate.close();	   
}    // 得到入庫執行日期..日期型態
 
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
//java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
//java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date    
	 
String dateCurrent = dateBean.getYearMonthDay();	

// formID = 基本資料頁傳來固定常數='TS'
// fromStatusID = 基本資料頁傳來Hidden 參數
// actionID = 前頁取得動作 ID( Assign = 003 )
try
{ 
	// 先取得下一狀態及狀態描述並作流程狀態更新   
  	dateString=dateBean.getYearMonthDay();
  
  	String sqlStat = "";
  	String whereStat = "";
  	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
  	sqlStat = sqlStat+whereStat;
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
  	getStatusRs.next();
 
	//=======工時異動========================================起    
	if (actionID.equals("022") && fromStatusID.equals("042"))   
	{  
 		float wipRsQty=0,wipMachineRsQty=0;

    	String runCardID=request.getParameter("RUNCARDID");
  		if (aMFGRsUpdateCode!=null) 
    	{
     		String r[][]=new String[aMFGRsUpdateCode.length+1][21]; // 宣告一二維陣列,分別是(=列)X(資料欄數+1= 行)	
	 		for (int i=0;i<aMFGRsUpdateCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{	  
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aMFGRsUpdateCode[i][0] || choice[k].equals(aMFGRsUpdateCode[i][0]))
	    			{ 	
						// ############################  WIP Resource Operation API資料取得 _起 ##############################
           				try
           				{
              				String sqlOPRes = "";
              				if (jobType==null || jobType.equals("1"))
              				{
                    			//sqlOPRes =" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
				              	//		"        a.SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
							  	//		"        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
				              	//		"        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
                              	//		" from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                              	//		" where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					          	//		"   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					          	//		"   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					          	//		"   and to_char(d.OPERATION_SEQUENCE_ID) = "+aMFGRsUpdateCode[i][10]+" "+
					          	//		"    "; // Outside Processing Checked
								//add by Peggy 20120604
								sqlOPRes =	" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
											"        a.SCHEDULED_FLAG SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
											"        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
											"        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
											"        ,b.RESOURCE_TYPE"+ //add by Peggy 20120313
											" from WIP_OPERATION_RESOURCES a, BOM_RESOURCES b"+
											" Where a.resource_id=b.resource_id"+
											" and a.WIP_ENTITY_ID = "+aMFGRsUpdateCode[i][9]+" "+
											" and a.operation_seq_num="+aMFGRsUpdateCode[i][2]+"";
              				} 
							else if (jobType.equals("2"))
                      		{ 
		                     	sqlOPRes =  " select c.RESOURCE_SEQ_NUM, c.RESOURCE_ID, c.USAGE_RATE_OR_AMOUNT, c.BASIS_TYPE, "+
				                         "        c.SCHEDULE_FLAG, c.AUTOCHARGE_TYPE, c.STANDARD_RATE_FLAG, c.SCHEDULE_SEQ_NUM, "+
							             "        c.PRINCIPLE_FLAG, c.ASSIGNED_UNITS, "+
										 "        d.UNIT_OF_MEASURE, d.AUTOCHARGE_TYPE "+
										"        ,d.RESOURCE_TYPE"+ //add by Peggy 20120604
			               				 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  			             " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							             " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							             " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							             " and a.WIP_ENTITY_ID = "+aMFGRsUpdateCode[i][9]+" "+
							             " and a.RUNCARD_NO ='"+aMFGRsUpdateCode[i][3]+"' "+
							             " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							             " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
							             " and d.ORGANIZATION_ID = '"+aMFGRsUpdateCode[i][11]+"' "; 
			             		if (runCardID==null || runCardID.equals("0")) sqlOPRes = sqlOPRes +" and a.RUNCARD_NO ='"+aMFGRsUpdateCode[i][3]+"' ";
                         		else  sqlOPRes = sqlOPRes + " and a.RUNCAD_ID ='"+aMFGRsUpdateCode[i][1]+"' " ;					
		              		}
							//out.println(sqlOPRes);		
              				Statement stateOPRes=con.createStatement();
              				ResultSet rsOPRes=stateOPRes.executeQuery(sqlOPRes);
              				//if (rsOPRes.next())
							//{
							int icnt=0;
							while (rsOPRes.next())
							{ 	
								if (icnt==0)
								{
									r[k][0]="";
									r[k][1]="";
									r[k][10]="";
									r[k][18]="";
									r[k][19]="";
									r[k][20]="";
									icnt++;
								}
								//modify by Peggy 20120604
								if (rsOPRes.getString("RESOURCE_TYPE").equals("2")) //人工工時
								{                 
									r[k][0]=rsOPRes.getString("RESOURCE_SEQ_NUM");
									r[k][1]=rsOPRes.getString("RESOURCE_ID");
									r[k][10]=rsOPRes.getString("UNIT_OF_MEASURE");
								}
								else if (rsOPRes.getString("RESOURCE_TYPE").equals("1")) //機器工時
								{
									r[k][18]=rsOPRes.getString("RESOURCE_SEQ_NUM");
									r[k][19]=rsOPRes.getString("RESOURCE_ID");
									r[k][20]=rsOPRes.getString("UNIT_OF_MEASURE");
								}
								//r[k][0]=rsOPRes.getString("RESOURCE_SEQ_NUM");
								//r[k][1]=rsOPRes.getString("RESOURCE_ID");
								r[k][3]=rsOPRes.getString("USAGE_RATE_OR_AMOUNT");
								r[k][4]=rsOPRes.getString("BASIS_TYPE");
								r[k][5]=rsOPRes.getString("SCHEDULE_FLAG");
								r[k][6]=rsOPRes.getString("AUTOCHARGE_TYPE");
								r[k][7]=rsOPRes.getString("STANDARD_RATE_FLAG");
								r[k][8]=rsOPRes.getString("SCHEDULE_SEQ_NUM");
								r[k][9]=rsOPRes.getString("PRINCIPLE_FLAG");
								//r[k][10]=rsOPRes.getString("UNIT_OF_MEASURE");
								r[k][11]=rsOPRes.getString("AUTOCHARGE_TYPE");
								r[k][12]=aMFGRsUpdateCode[i][1] ;  //rs.getString("RUNCAD_ID");	        
								r[k][13]=aMFGRsUpdateCode[i][2] ;    //rs.getString("OPERATION_SEQ_NUM");
								r[k][14]=rsOPRes.getString("ASSIGNED_UNITS");   
								r[k][15]=aMFGRsUpdateCode[i][10] ;    //rs.getString("OPERATION_SEQUENCE_ID");
								r[k][16]=aMFGRsUpdateCode[i][12] ;    //rs.getString("PRIMARY_ITEM_ID");
								r[k][17]=aMFGRsUpdateCode[i][3] ;    //rs.getString("RUNCARD_NO");
								arrMFGResourceBean.setArray2DString(r);
              				}
              				rsOPRes.close();
              				stateOPRes.close();	   
          				} //end of try
          				catch (Exception e)
          				{
             				out.println("Exception runcard:"+e.getMessage());
          				}	   
						// ############################  WIP Resource Operation API資料取得 _迄 ##############################

	   					// %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _起
		    			for (int rr=0;rr<choice.length;rr++)
						{ 
			  				if (aMFGRsUpdateCode[i][1]==r[rr][12] || aMFGRsUpdateCode[i][1].equals(r[rr][12]) )  //(runcad_id)
			  				{ 
                  				//計算異動數量____起   2006/12/28
               					// 取Oracle已回報人工工時累計  
                				String wipRs =  "  select "+ aMFGRsUpdateCode[i][14]+"- sum(TRANSACTION_QUANTITY) from wip_transactions "+
												"  where TRANSACTION_TYPE =1  "+
												"  and wip_entity_id = "+aMFGRsUpdateCode[i][9]+" "+
 												"  and ATTRIBUTE2 = '"+aMFGRsUpdateCode[i][3]+"'  "+
												"  and OPERATION_SEQ_NUM = "+aMFGRsUpdateCode[i][2]+" "+
												"  and RESOURCE_SEQ_NUM = '" + r[rr][0]+"'";
								//out.println("aa="+wipRs);
                				Statement stateWipRs=con.createStatement();
	  		    				ResultSet rsWipRs=stateWipRs.executeQuery(wipRs);
			    				if (rsWipRs.next())
		    	 				{
			       					//wipRsQty  = rsWipRs.getFloat(1); 
									resourceQty = rsWipRs.getFloat(1); 
                 				}
								else
								{
									resourceQty = Float.parseFloat(aMFGRsUpdateCode[i][14]);
								}
	            				rsWipRs.close();
                				stateWipRs.close();
                				//resourceQty = (Float.parseFloat(aMFGRsUpdateCode[i][14])-wipRsQty) ;  //差異值=輸入值-原報人工工時
 		           				java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.00"); // 取小數後二位 
				   				String strResourceQty = nf.format(resourceQty);
				   				java.math.BigDecimal bd = new java.math.BigDecimal(strResourceQty);
				   				java.math.BigDecimal rsQty = bd.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				   				resourceQty =rsQty.floatValue();
								//out.println("resourceQty="+resourceQty);

								//add by Peggy 20120605
								String wipRss =  "  select "+aMFGRsUpdateCode[i][17]+" - sum(TRANSACTION_QUANTITY) from wip_transactions "+
												"  where TRANSACTION_TYPE =1  "+
												"  and wip_entity_id = "+aMFGRsUpdateCode[i][9]+" "+
 												"  and ATTRIBUTE2 = '"+aMFGRsUpdateCode[i][3]+"'  "+
												"  and OPERATION_SEQ_NUM = "+aMFGRsUpdateCode[i][2]+" "+
												"  and RESOURCE_SEQ_NUM = '" + r[rr][18]+"'";
                				Statement stateWipRss=con.createStatement();
	  		    				ResultSet rsWipRss=stateWipRss.executeQuery(wipRss);
			    				if (rsWipRss.next())
		    	 				{
			       					//wipMachineRsQty  = rsWipRss.getFloat(1); 
									machine_resourceQty = rsWipRss.getFloat(1); 
                 				}
								else
								{
									machine_resourceQty = Float.parseFloat(aMFGRsUpdateCode[i][17]);
								}
	            				rsWipRss.close();
                				stateWipRss.close();
                				//machine_resourceQty = (Float.parseFloat(aMFGRsUpdateCode[i][17])-wipMachineRsQty) ;  //差異值=輸入值-原報機器工時
				   				String strMachineResourceQty = nf.format(machine_resourceQty);
				   				bd = new java.math.BigDecimal(strMachineResourceQty );
				   				java.math.BigDecimal rsMachineQty = bd.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				   				machine_resourceQty  =rsMachineQty.floatValue();
								//out.println("machine_resourceQty="+machine_resourceQty);

				   				String sqlResRowID =" select a.ROWID, b.ORGANIZATION_CODE "+
				                     			    " from WIP_OPERATION_RESOURCES a, MTL_PARAMETERS b "+
				                                    " where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.WIP_ENTITY_ID="+aMFGRsUpdateCode[i][9]+" "+
									                "   and a.OPERATION_SEQ_NUM='"+r[rr][13]+"' and a.RESOURCE_SEQ_NUM='"+r[rr][0]+"' ";
	               				Statement stateResRowID=con.createStatement();
                   				ResultSet rsResRowID=stateResRowID.executeQuery(sqlResRowID);
				   				if (rsResRowID.next())
				   				{	  
				        			String groupId = "0";  
									String respID = "0";    
									int acctPeriodID = 0; 
									String wkCode="";
						
									boolean intResExist = false;
									boolean resResExist = false; 
	                    			Statement stateExist=con.createStatement();	 
	                    			ResultSet rsIntExist=stateExist.executeQuery(" select ATTRIBUTE2 from WIP_COST_TXN_INTERFACE "+
						                                             			 " where WIP_ENTITY_ID="+aMFGRsUpdateCode[i][9]+" and ORGANIZATION_ID = "+aMFGRsUpdateCode[i][11]+" "+
																                 " and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' "+
																				 " and RESOURCE_SEQ_NUM='"+Integer.parseInt(r[rr][0])+"'");  //modif by Peggy 20120605
				        			if (rsIntExist.next()) intResExist = true;
				        			rsIntExist.close();
									
									ResultSet rsResExist=stateExist.executeQuery(" select ATTRIBUTE2 from WIP_OPERATION_RESOURCES "+
						                                                         " where WIP_ENTITY_ID="+aMFGRsUpdateCode[i][9]+" and ORGANIZATION_ID = "+aMFGRsUpdateCode[i][11]+" "+
																                 " and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' "+
																				 " and RESOURCE_SEQ_NUM='"+Integer.parseInt(r[rr][0])+"'"); //modif by Peggy 20120605
				        			if (rsResExist.next()) resResExist = true;
				        			rsResExist.close();					
				        			stateExist.close();
									//out.println("intResExist="+intResExist);
									//out.println("resResExist="+resResExist);
									if (!intResExist && !resResExist) 
									{
						       			// ORG_ACCT_PERIODS_V --> 若需要Account Period ID 的View 
	                          	 		Statement stateACP=con.createStatement();	             
	                           			ResultSet rsACP=stateACP.executeQuery("select ACCT_PERIOD_ID from ORG_ACCT_PERIODS_V where ORGANIZATION_ID = "+aMFGRsUpdateCode[i][11]+" ");
				               			if (rsACP.next()) acctPeriodID = rsACP.getInt(1);
				               			rsACP.close();
				               			stateACP.close();
					           			String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                                                       " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, WIP_ENTITY_ID, "+
																	           " ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
																	           " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
																		       " WIP_ENTITY_NAME, ACCT_PERIOD_ID, PRIMARY_ITEM_ID, ATTRIBUTE2, ORGANIZATION_CODE ) "+
															           " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
															           "         1, 1, 1, '"+aMFGRsUpdateCode[i][11]+"', '"+aMFGRsUpdateCode[i][9]+"', "+    //[11]organization_id ,[9]=wip_entity_id
															           "         1, to_date("+aMFGRsUpdateCode[i][8]+",'YYYYMMDDhh24Miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
															           "         "+Integer.parseInt(r[rr][1])+", "+resourceQty+", '"+r[rr][10]+"', 2 , "+     //[5]=resource qty
														               "         '"+woNo+"', "+acctPeriodID+", "+r[rr][16]+", '"+r[rr][17]+"' , '"+rsResRowID.getString(2)+"' ) ";		                              
										//out.println(resSql);
						       			PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                       			pstmtRes.executeUpdate(); 
                               			pstmtRes.close();
									}
									
									boolean intResExist1 = false;
									boolean resResExist1 = false; 
	                    			Statement stateExist1=con.createStatement();	 
	                    			ResultSet rsIntExist1=stateExist1.executeQuery(" select ATTRIBUTE2 from WIP_COST_TXN_INTERFACE "+
						                                             			 " where WIP_ENTITY_ID="+aMFGRsUpdateCode[i][9]+" and ORGANIZATION_ID = "+aMFGRsUpdateCode[i][11]+" "+
																                 " and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' "+
																				 " and RESOURCE_SEQ_NUM='"+Integer.parseInt(r[rr][18])+"'");  //modif by Peggy 20120605
				        			if (rsIntExist1.next()) intResExist1 = true;
				        			rsIntExist1.close();
									
									ResultSet rsResExist1=stateExist1.executeQuery(" select ATTRIBUTE2 from WIP_OPERATION_RESOURCES "+
						                                                         " where WIP_ENTITY_ID="+aMFGRsUpdateCode[i][9]+" and ORGANIZATION_ID = "+aMFGRsUpdateCode[i][11]+" "+
																                 " and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' "+
																				 " and RESOURCE_SEQ_NUM='"+Integer.parseInt(r[rr][18])+"'"); //modif by Peggy 20120605
				        			if (rsResExist1.next()) resResExist1 = true;
				        			rsResExist1.close();					
				        			stateExist1.close();
									//out.println("intResExist1="+intResExist1);
									//out.println("resResExist1="+resResExist1);
						
									if (!intResExist1 && !resResExist1) 
									{
										//add by peggy 20120604
					           			String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                                                       " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, WIP_ENTITY_ID, "+
																	           " ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
																	           " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
																		       " WIP_ENTITY_NAME, ACCT_PERIOD_ID, PRIMARY_ITEM_ID, ATTRIBUTE2, ORGANIZATION_CODE ) "+
															           " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
															           "         1, 1, 1, '"+aMFGRsUpdateCode[i][11]+"', '"+aMFGRsUpdateCode[i][9]+"', "+    //[11]organization_id ,[9]=wip_entity_id
															           "         1, to_date("+aMFGRsUpdateCode[i][8]+",'YYYYMMDDhh24Miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][18])+", "+
															           "         "+Integer.parseInt(r[rr][19])+", "+machine_resourceQty+", '"+r[rr][20]+"', 2 , "+     //[5]=resource qty
														               "         '"+woNo+"', "+acctPeriodID+", "+r[rr][16]+", '"+r[rr][17]+"' , '"+rsResRowID.getString(2)+"' ) ";		                              
										//out.println(resSql);
								       	PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                       			pstmtRes.executeUpdate(); 
                               			pstmtRes.close();
									}
									
									if ((!intResExist && !resResExist) || (!intResExist1 && !resResExist1)) 
									{
							   			String wkClass=aMFGRsUpdateCode[i][4];
							   			String resEmployee=aMFGRsUpdateCode[i][6];
							   			String resMachine=aMFGRsUpdateCode[i][7];
							   
							   	  		Statement statewkCode=con.createStatement();
							     		ResultSet rswkCode=statewkCode.executeQuery("select WKCLASS_CODE from  APPS.YEW_MFG_WORKCLASS where WKCLASS_NAME= '"+wkClass+"' ");
								 		if (rswkCode.next())
								 		{
											wkCode  = rswkCode.getString("WKCLASS_CODE");
								  		}
								 		rswkCode.close();
 						         		statewkCode.close();
	
                               			if (wkClass==null || wkClass.equals("null")) wkClass="";
							   			if (resEmployee==null || resEmployee.equals("null")) resEmployee="";
							   			if (resMachine==null || resMachine.equals("null")) resMachine="";
							   			if (wkCode==null || wkCode.equals("--")) wkCode="";
							 
							   			String delTxnSql=" delete from yew_runcard_restxns where runcard_no='"+r[rr][17]+"' and OPERATION_SEQ_NUM= "+Integer.parseInt(r[rr][13]);
										if (!intResExist && !resResExist)	delTxnSql+=	" and RESOURCE_SEQ_NUM = "+Integer.parseInt(r[rr][0])+" ";
										if (!intResExist1 && !resResExist1)	delTxnSql+=	" and MACHINE_RESOURCE_SEQ_NUM = "+Integer.parseInt(r[rr][18])+" ";
							   			PreparedStatement pstmtdelTxn=con.prepareStatement(delTxnSql); 
		                       			pstmtdelTxn.executeUpdate(); 
                              			pstmtdelTxn.close(); 
							   			String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, CREATED_BY, LAST_UPDATED_BY, "+
						                                                             " OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
																	                 " AUTOCHARGE_TYPE, WKCLASS_CODE, WKCLASS_NAME, WORK_EMPLOYEE, WORK_EMPID, WORK_MACHINE, WORK_MACHNO ,LAST_UPDATE_DATE "+
																					 " ,MACHINE_RESOURCE_SEQ_NUM,MACHINE_RESOURCE_ID,MACHINE_TRANSACTION_QUANTITY,MACHINE_TRANSACTION_UOM)"+
															                 " values( '"+woNo+"', '"+r[rr][17]+"', '"+userMfgUserID+"', '"+userMfgUserID+"', "+															              
															                 "         "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
															                 "         "+Integer.parseInt(r[rr][1])+", "+aMFGRsUpdateCode[i][14]+", '"+r[rr][10]+"', "+
														                     "          2 ,'"+wkCode+"', 'N/A', '"+resEmployee+"', '0','"+resMachine+"','N/A', to_char(SYSDATE,'YYYYMMDDhh24Miss') "+		                              
																			 ", "+(r[rr][18].equals("")?null:r[rr][18])+", "+(r[rr][19].equals("")?0:Integer.parseInt(r[rr][19]))+", "+aMFGRsUpdateCode[i][17]+", '"+r[rr][20]  +"')"; //add by Peggy 20120604
										//out.println(resTxnSql);
						       			PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql); 
		                       			pstmtResTxn.executeUpdate(); 
                               			pstmtResTxn.close(); 
                              			out.print("<br>工令:"+woNo+"  流程卡號:"+r[rr][17]+"  站別:"+r[rr][13]+"  機器工時:"+(new java.text.DecimalFormat("###,##0.###")).format(Float.parseFloat(aMFGRsUpdateCode[i][17]))+"    人工工時:"+(new java.text.DecimalFormat("###,##0.###")).format(Float.parseFloat(aMFGRsUpdateCode[i][14]))+"");
								 	}
				 				} 	  
								rsResRowID.close();
								stateResRowID.close();	  
			  				}
						}		  
					}
	   			}
     		}
	  	}
	}
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
}
   
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

