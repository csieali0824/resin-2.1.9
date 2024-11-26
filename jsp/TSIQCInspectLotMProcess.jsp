<%@ page contentType="text/html; charset=utf-8"  language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/IQCInclude/MProcessStatusBarStart.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->
<script language="JavaScript" type="text/JavaScript">
function reProcessFormConfirm(ms1,URL,dnDOCNo,lineNo)
{
	var orginalPage="?INSPLOTNO="+dnDOCNo+"&LINE_NO="+lineNo;
    flag=confirm(ms1);      
    if (flag==false) return(false);
	else
    { //alert(orginalPage);
		document.MPROCESSFORM.action=URL+orginalPage;
     	document.MPROCESSFORM.submit();
	} 
}
function ProcessFormQuery(URL,statusId,pageURL)
{
	document.MPROCESSFORM.action=URL+"?STATUSID="+statusId+"&PAGEURL="+pageURL;
    document.MPROCESSFORM.submit();
} 
function alertItemExistsMsg(msItemExists)
{
	alert(msItemExists);
}
</script>
<html>
<head>
<title>IQC System Inspection Lot Mass Process Page</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrIQC2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 品管檢驗單草稿文件-->
<jsp:useBean id="arrIQC2DInspectingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 品管檢驗數據輸入完成判定-->
<jsp:useBean id="arrIQC2DAuthorizingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 檢驗批採購主管授權-->
<jsp:useBean id="arrIQC2DApprovingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 檢驗批工廠主管授權-->
<jsp:useBean id="arrIQC2DWaivingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 物管接收批退檢驗批特採申請核准-->
<jsp:useBean id="arrIQC2DWaiveApprovedBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 檢驗批特採申請廠主管核准-->
<jsp:useBean id="arrIQC2DReceivingBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 倉管接收檢驗合格入庫-->
<jsp:useBean id="arrIQC2DReturningBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 倉管接收檢驗判退批退供應商-->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM ACTION="TSIQCInspectLotMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
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
// 晶片晶粒檢測內容_參數起  
String wfSizeID=request.getParameter("WFSIZEID"); 
String diceSize=request.getParameter("DICESIZE"); 
String wfPlatID=request.getParameter("WFPLATID");
String exWfSizeID=request.getParameter("EXWFSIZEID"); 
String exDiceSize=request.getParameter("EXDICESIZE"); 
String exWfThick=request.getParameter("EXWFTHICK"); 
String exWfResist=request.getParameter("EXWFRESIST"); 
String exWfPlatID=request.getParameter("EXWFPLATID"); 
String surDefect=request.getParameter("SURDEFECT");
String shortage=request.getParameter("SHORTAGE");
String pullDMIN=request.getParameter("PULLDMIN");
String peeling=request.getParameter("MATPEEL");
String voidBub=request.getParameter("VOIDBUB");
String oxid=request.getParameter("OXID");
String diceShtRate=request.getParameter("DICESHTRAT");
String wfShtQty=request.getParameter("WFSHTQTY");      
String totalYield=request.getParameter("TOTALYIELD");
String product=request.getParameter("PRODUCT");
String prodYield=request.getParameter("PRODYIELD");
// 晶片晶粒檢測內容_參數迄 
String result=request.getParameter("RESULT");
String qcRemark = "";  //20170322

if (actionID==null) 
{ 
}
else if (actionID.equals("016"))  // 選擇ACCEPT , 則為 檢驗合格
{ 
	result = "01";	
}  
else if (actionID.equals("005"))  // 選擇REJECT , 則為 檢驗判退
{ 
    result = "02"; 
} 
String waiveNo=request.getParameter("WAIVENO");  // 檢驗批皆為特採->特採編號
String subInventory=request.getParameter("SUBINVENTORY"); // 入庫倉別
String aIQCTemporaryCode[][]=arrIQC2DTemporaryBean.getArray2DContent();//取得aSalesTemporaryCode目前陣列內容(業務草稿文件陣列內容)
String aIQCInspectingCode[][]=arrIQC2DInspectingBean.getArray2DContent(); // FOR 品管檢驗數據輸入完成判定
String aIQCAuthorizingCode[][]=arrIQC2DAuthorizingBean.getArray2DContent(); // FOR 檢驗批採購主管授權
String aIQCApprovingCode[][]=arrIQC2DApprovingBean.getArray2DContent();     // FOR 檢驗批工廠主管授權
String aIQCWaivingCode[][]=arrIQC2DWaivingBean.getArray2DContent();         // FOR 物管接收批退檢驗批特採申請核准
String aIQCWaiveApprovedCode[][]=arrIQC2DWaiveApprovedBean.getArray2DContent(); // FOR 檢驗批特採廠主管核准
String aIQCReceivingBean[][]=arrIQC2DReceivingBean.getArray2DContent();  // FOR 倉管接收檢驗合格入庫 -- > Oracle Receiving API
String aIQCReturningBean[][]=arrIQC2DReturningBean.getArray2DContent();  // FOR 倉管接收檢驗判退批退供應商 -->  Oracle Returning API
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String newDRQOption=request.getParameter("NEWDRQOPTION");//是否要以原單據內容產生新的交期詢問單
String oriStatus=null;
String actionName=null;
String dateString="";
String seqkey="";
String seqno="";
String line_No=request.getParameter("LINE_NO");
String curr=request.getParameter("CURR");
String [] choice=request.getParameterValues("CHKFLAG");
int headerID   = 0;  
int requestID  = 0;
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
}    // 得到入庫執行日期..日期型態
   
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date     
   
int lineType = 0;  
String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
String assignLNo = "";
String prodDesc = null;
String prodCodeGet = "";
int prodCodeGetLength = 0;   
String dateCurrent = dateBean.getYearMonthDay();	

try
{ 
	// 先取得下一狀態及狀態描述並作流程狀態更新   
  	dateString=dateBean.getYearMonthDay();
  	String sqlStat = "";
  	String whereStat = "";
  	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
	whereStat ="WHERE FORMID = 'QC' and FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
	sqlStat = sqlStat+whereStat;
	Statement getStatusStat=con.createStatement();  
	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
	getStatusRs.next();  
	String sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set LAST_UPDATE_DATE=?  where INSPLOT_NO='"+inspLotNo+"'";
	PreparedStatement pstmt=con.prepareStatement(sql);   
	pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); //寫入STATUSID  
	pstmt.executeUpdate();
	pstmt.close();     
 	 
	// 	先設定Client Info_起 
  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
  	cs1.execute();
  	cs1.close();	 
	//  先設定Client Info_迄   
  
  	//IQC品管檢驗草稿文件處理(CREATE)_起	(ACTION=002) From_Status= Temporary TO_Status = Inspecting
  	if (actionID.equals("002")) 
  	{       
    	//Step3. 再更新交期詢問主檔資料
     	sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	     	"where INSPLOT_NO='"+inspLotNo+"' ";     
     	pstmt=con.prepareStatement(sql);      
     	pstmt.setString(1,userID); // 最後更新人員
	 	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
     	pstmt.executeUpdate(); 
     	pstmt.close();      
	 	// 再更新交期詢問主檔資料
	
		// 再判斷是否已經不存在任一筆Detail,若是,則一併刪除主檔_起
	    Statement stateCNTLEFT=con.createStatement();
	    ResultSet rsCNTLEFT=stateCNTLEFT.executeQuery("select count(*) from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where INSPLOT_NO='"+inspLotNo+"' ");
        rsCNTLEFT.next();
        int countLeft=rsCNTLEFT.getInt(1);   
        stateCNTLEFT.close();
        rsCNTLEFT.close();
			 
		if (countLeft==0)
		{
			sql="delete ORADDMAN.TSCIQC_LOTINSPECT_HEADER where INSPLOT_NO='"+inspLotNo+"' ";     
            pstmt=con.prepareStatement(sql);              
            pstmt.executeUpdate(); 
            pstmt.close();      
		}
	}  //END OF 002 ACTION=002 IF  
  	//業務交期詢問單草稿(CREATE)_迄	(ACTION=002)
  
	//若為採購主管核准檢驗批單據(AUTHORIZE)_起 (ACTION=026) from_Status = Authorizing  to_status = Approving
  	if (actionID.equals("026")) 
  	{     
    	if (aIQCAuthorizingCode!=null) // 判斷該次有分派細項才進行明細表更新
   	 	{
	 		for (int i=0;i<aIQCAuthorizingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	    			{ 			
						Statement statement=con.createStatement();
            			ResultSet rs=null;		        
			  
			  			sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, "+
			      			" LSTATUSID=?, LSTATUS=?, COMMENTS=?  "+		          
	              			"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCAuthorizingCode[i][0]+"' ";     
              			pstmt=con.prepareStatement(sql);
		      			pstmt.setString(1,userID); // 最後更新人員工號ID
		      			pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		      			pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		      			pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態
		      			pstmt.setString(5,""); // Comments	      
              			pstmt.executeUpdate(); 
              			pstmt.close();  
			  			  
						// 處理歷程檔寫入	  
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCAuthorizingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			            		        " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		"values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCAuthorizingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCAuthorizingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
             			historystmt.close();   
					} // End of if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCAuthorizingCode!=null)
	     // 再更新IQC檢驗批主檔資料
		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?, STATUS=?, LAST_UPDATED_BY=?, LAST_UPDATE_DATE=? "+
		    " where INSPLOT_NO='"+inspLotNo+"' ";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS
		pstmt.setString(3,userID); // 最後更新人員
	    pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 	  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCAuthorizingCode!=null)
		{ 
	  		arrIQC2DAuthorizingBean.setArray2DString(null); 
		}
	
	 	Statement stateReProcess=con.createStatement(); 
        String reProcSql=" select b.INSPLOT_NO, b.LINE_NO from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a ,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO=b.INSPLOT_NO and b.LSTATUSID='026' ";

		if (UserRoles.indexOf("PUR_MGR")>=0 ) 
        { 
			reProcSql=reProcSql+" and a.IQC_CLASS_CODE !='04' ";  
		}
        else if  (UserRoles.indexOf("PUR_OUT_MGR")>=0 ) 
        { 
			reProcSql=reProcSql+" and a.IQC_CLASS_CODE = '04' ";  
		}
        else if  (UserRoles.indexOf("PUR_ALL_MGR")>=0 ) 
        { 
			reProcSql=reProcSql+" ";  
		}
        else
        { 
			reProcSql=reProcSql+" ";  
		}
     	ResultSet rsReProcess=stateReProcess.executeQuery(reProcSql);  // 取任一筆未處理INSP單據做核准的Line_No
	 	if (rsReProcess.next())
	 	{
	  		String reInspLotNo = rsReProcess.getString("INSPLOT_NO");
	  		String reLineNo = rsReProcess.getString("LINE_NO");	 
	 %>
	   <script LANGUAGE="JavaScript">
	       reProcessFormConfirm("處理下一筆檢驗批核准驗收單?","../jsp/TSIQCInspectLotAuthorizingPage.jsp","<%=reInspLotNo%>","<%=reLineNo%>");
	   </script>
	 <%
	 	} // end of if (rsReProcess.next())
		else 
		{ // 不存在則回到Query Status
	       %>
	          <script LANGUAGE="JavaScript">
	            ProcessFormQuery("../jsp/TSIQCInspectLotQueryAllStatus.jsp","026","TSIQCInspectLotAuthorizingPage.jsp");
	          </script>
	       <%
	 	}
	 	rsReProcess.close();
	 	stateReProcess.close();
	} //若為採購主管核准檢驗批單據(AUTHORIZE)_起 (ACTION=026) from_Status = Authorizing  to_status = Approving
// 採購主管核准檢驗批(AUTHORIZE)_迄 (ACTION=026)   
  
// 採購主管不同意檢驗批_系統執行REJECT_迄 (ACTION=005 && STATUSID=026) 
  	if (actionID.equals("005") && fromStatusID.equals("026")) 
  	{
    	if (aIQCAuthorizingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCAuthorizingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	    			{ 	 		
				   		//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
				   		String fndUserID = "";
				   		String fndEmpID = "";
		   				// 呼叫 Package 內Procedure Interface APIs 的方式_起(檢驗判退_REJECT)
		   				String devStatus = "";
		   				String devMessage = "";	
		   				String rvcGrpID = "0";
		   				boolean errRCVFlag = false;
		   				boolean acceptRcvOK  = true;
		   				respID = "";
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
			  				String sql1a= " select INSPLOT_NO as SELECTFLAG, INSPLOT_NO ,RECEIPT_QTY ,SUPPLIER_LOT_NO, "+
			                	        " PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIPMENT_LINE_ID, "+
			                    	    " EMPLOYEE_ID, ORGANIZATION_ID, RECEIPT_NO, INTERFACE_TRANSACTION_ID, "+
										" substr(INSPLOT_NO,4,2) as INSP_CLASS, INSPECTOR "+
                            			" from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL "+
                            			" where INSPLOT_NO = '"+inspLotNo+"' and LINE_NO = '"+aIQCAuthorizingCode[i][0]+"' ";
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next())
              				{
			     				int rcvGroupID = 0;
				 				int parentTransID = 0;
				 				// 2007/01/24 更改 REJ 人員為檢驗員_起
				         		String sqlfnd = " select USER_ID, EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 											    " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+rs.getString("INSPECTOR")+ "'";
						 		Statement stateFndId=con.createStatement();
                         		ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 		if (rsFndId.next())
						 		{
						   			fndUserID = rsFndId.getString("USER_ID"); 
						   			fndEmpID = rsFndId.getString("EMPLOYEE_ID");
						 		}
						 		rsFndId.close();
						 		stateFndId.close();
				 				// 2007/01/24 更改 REJ 人員為檢驗員_迄				 
				 
				 				String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle				 
				 				if (inspClass!="06" && !inspClass.equals("06"))
				 				{
									// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
									String employeeID = "";
									if (fndEmpID==null || fndEmpID.equals("")) 
									{ 
					  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
					  					{  
                         					//employeeID = "5675";    // 20100316 Marvie Update : ZHANG_YUJING/5675
											employeeID = "5676";    // 20131008 Peggy Update : XING_ENFANG/5676
					  					}
					  					else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
									}
									else 
									{
					       				employeeID = fndEmpID;
					     			}   
				 					// 2006/12/19 若Oracle未將收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID				 				 
                    				CallableStatement cs3 = con.prepareCall("{call TSIQC_RCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			
				    				cs3.setString(1,inspLotNo);    out.println(inspLotNo);          //檢驗批單號
									cs3.setDate(2,receivingDate);  out.println(receivingDate);      //收料日期
									cs3.setInt(3,Integer.parseInt(fndUserID));  out.println(receivingDate);    // FND_USER ID    
									cs3.setInt(4,Integer.parseInt(rs.getString("PO_HEADER_ID")));  
									cs3.setInt(5,Integer.parseInt(rs.getString("PO_LINE_ID")));  
									cs3.setFloat(6,rs.getFloat("RECEIPT_QTY"));  
									cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
									cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
									cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
									cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
									cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
									cs3.setInt(12,Integer.parseInt(rs.getString("PO_LINE_LOCATION_ID")));   //PO_LOCATION_LINE_ID
									cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID
									cs3.setInt(14,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   //ORGANIZATION_ID					
									cs3.setString(15,"");                           // SUB_INVENTORY   INSPECTION不用給	
									cs3.setString(16,rs.getString("SUPPLIER_LOT_NO"));   // SULLPIER_LOT_NO	
									cs3.setString(17,aIQCAuthorizingCode[i][7]);      // COMMENTS aIQCReceivingBean[i][7]	
									cs3.setString(18,rs.getString("RECEIPT_NO"));   // LINE查詢的_RECEIPT_NO	
									cs3.setString(19,"REJECT");      // 檢驗判退	
									cs3.setString(20,"RECEIVE");     // 上一個父異動類型為RECEIVE
									cs3.setString(21,"RECEIVING");  // 此次檢驗的DESTNATION TYPE CODE為 RECEIVING
									cs3.setInt(22,rs.getInt("INTERFACE_TRANSACTION_ID")); //out.println("INTERFACE_TRANSACTION_ID="+rs.getString("INTERFACE_TRANSACTION_ID")+"<BR>");  // 原先的Parent Interface Trans ID		      			     			     
									cs3.setInt(23,rs.getInt("SHIPMENT_LINE_ID")); //out.println("INTERFACE_TRANSACTION_ID="+rs.getString("INTERFACE_TRANSACTION_ID")+"<BR>"); 
									cs3.execute();
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
				     					String sqlRvcGrpID=  " select max(GROUP_ID) "+
                                        				     " from RCV_TRANSACTIONS_INTERFACE "+
                                          					 " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='REJECT' "+
					     									 "   and PROCESSING_STATUS_CODE ='PENDING' ";
				  	 					ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
					 					if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
					 					rsRvcGrpID.close();
					 					stateRvcGrpID.close();
				    				}				
				    				if (errorMessageLine==null ) 
				    				{ 
										errorMessageLine = "&nbsp;";
									}	
				      				if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
					  				{					    
					     				errorMessageHeader = "&nbsp;"; 
						 				errorMessageLine = "&nbsp;"; 		
						       			
										CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
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
							   			out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
							   			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
							   			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
							   
							   			// 2006/12/19 判斷是否入 RCV ACCEPT Interface 成功_起
							   			String sqlRcvOK = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS_INTERFACE "+
                                        		          " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' "+
												 		  "   and TRANSACTION_TYPE ='REJECT' and GROUP_ID = "+rvcGrpID+" "+
					  			   	             		  "   and PROCESSING_STATUS_CODE ='ERROR'  "; // 找錯誤的
				               			Statement stateRcvOK=con.createStatement();
                               			ResultSet rsRcvOK=stateRcvOK.executeQuery(sqlRcvOK);
				               			if (rsRcvOK.next())
				               			{
				                 			acceptRcvOK  = false;
								 			out.println("<BR>IQC檢驗批單號("+inspLotNo+")之收料單號("+rs.getString("RECEIPT_NO")+")批退發生錯誤,未成功執行批退異動作業!!");
				               			}
				               			rsRcvOK.close();
				              			stateRcvOK.close();
						      			// 2006/12/19 判斷是否入 RCV ACCEPT Interface 成功_迄   
					  				} 
									else 
									{  
					           			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Request RCV Transaction Fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
					           			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
							   			errRCVFlag = true;
					         		}	
				  				} // End of if (inspCLass!="06" && !inspClass.equals("06")) // 判斷不為RMA的才作REJECT 入oracle
			   				} // End of While			          							 
					   		rs.close();
					   		statement.close();	 // 此次檢驗判退的While							 		
		      			}	// End of try
		      			catch (Exception e) 
		      			{ 
							out.println("Exception:"+e.getMessage()); 
						}		   
		      			// 呼叫 Package 內Procedure Interface APIs的方式_迄(檢驗判退_REJECT)		
		
	           			//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
						if (!errRCVFlag && acceptRcvOK) // 若成功執行RCV Request及正確入RCV Transaction Interface才執行更新IQC資訊
						{   
		      				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCAuthorizingCode[i][0]+"' ";     
              				pstmt=con.prepareStatement(sql);           
		      				pstmt.setString(1,userID); // 最後更新人員 
		      				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		      				pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		      				pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態 			   
              				pstmt.executeUpdate(); 
              				pstmt.close();  
			  
			   				sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
               				pstmt=con.prepareStatement(sql);   
               				pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
              	 			pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS 			   
               				pstmt.executeUpdate();
               				pstmt.close(); 			  
			 			} // End of if (!errRCVFlag && acceptRcvOK)
			 
		   				// 處理歷程檔寫入_起	 
		     	 		Statement statement=con.createStatement();
              			ResultSet rs=null;	 
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCAuthorizingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			            			      " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		  "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCAuthorizingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
             	 		historystmt.setString(11,aIQCAuthorizingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
             	 		historystmt.executeUpdate(); 
              			historystmt.close();   
		    			// 處理歷程檔寫入_迄 
					} // End of if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCAuthorizingCode!=null)  
	    
		//out.println("Step5.."); 
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        { 
	    	Statement stateList=con.createStatement();
			String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
				             " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
								                             "   where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        while (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統採購主管不同意合格檢驗批判退通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:採購主管不同意合格檢驗批判退-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotReturningPage.jsp?INSPLOTNO="+inspLotNo+"&LSTATUSID=024");//				   
                sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	   
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	    // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目
	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set RESULT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	        "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql);     
		pstmt.setString(1,"REJECT"); // 檢驗不合格批退   
        pstmt.setString(2,userID); // 最後更新人員
	    pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
	    if (aIQCAuthorizingCode!=null)
	    { 
	    	arrIQC2DAuthorizingBean.setArray2DString(null); 
	    }
		Statement stateReProcess=con.createStatement(); 
        String reProcSql=" select b.INSPLOT_NO, b.LINE_NO from ORADDMAN.TSCIQC_LOTINSPECT_HEADER a ,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL b where a.INSPLOT_NO=b.INSPLOT_NO and b.LSTATUSID='026' ";

		if (UserRoles.equals("PUR_MGR") ) 
        {
        	reProcSql=reProcSql+" and a.IQC_CLASS_CODE !='04' ";  // 
        }
        else if  (UserRoles.equals("PUR_OUT_MGR") ) 
        {
        	reProcSql=reProcSql+" and a.IQC_CLASS_CODE = '04' ";  // 
        }
        else
        {
        	reProcSql=reProcSql+" ";
        }
        ResultSet rsReProcess=stateReProcess.executeQuery(reProcSql);
	    if (rsReProcess.next())
	    {
	    	String reInspLotNo = rsReProcess.getString("INSPLOT_NO");
	        String reLineNo = rsReProcess.getString("LINE_NO");	 
	    %>
	        <script LANGUAGE="JavaScript">
	          reProcessFormConfirm("處理下一筆檢驗批核准驗收單?","../jsp/TSIQCInspectLotAuthorizingPage.jsp","<%=reInspLotNo%>","<%=reLineNo%>");
	        </script>
	    <%
	    } // end of if (rsReProcess.next())
	    else 
		{ // 不存在則回到Query Status
	    %>
	             <script LANGUAGE="JavaScript">
	               ProcessFormQuery("../jsp/TSIQCInspectLotQueryAllStatus.jsp","026","TSIQCInspectLotAuthorizingPage.jsp");
	             </script>
	    <%
	    }
	    rsReProcess.close();
	    stateReProcess.close();
  	} //若為採購主管不同意檢驗批(REJECT)_迄
	// 採購主管不同意檢驗批_系統執行REJECT_迄 (ACTION=005 && STATUSID=026)  
  	
	//若為工廠主管核准檢驗批單據(APPROVE)_迄 (ACTION=027) from_Status = Approving  to_status = Receiving
  	if (actionID.equals("027")) 
  	{
		//out.println("actionID="+actionID); 
    	if (aIQCApprovingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCApprovingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCApprovingCode[i][0] || choice[k].equals(aIQCApprovingCode[i][0]))
	    			{   				
		   				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
	       				String fndUserID = "";
		   				String fndEmpID = "";
		
		   				// 呼叫 Package 內Procedure Interface APIs 的方式_起(檢驗合格_ACCEPT)
		   				String devStatus = "";
		   				String devMessage = "";	
		   				String rvcGrpID = "0";
		   				boolean errRCVFlag = false;
		   				boolean acceptRcvOK = true;
		   				respID = "";
		      			//先取得欲執行產生PO之Responsibility ID_起
	          			Statement stateResp=con.createStatement();	   
	          			ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME = 'YEW_PO_SEMI_SU' "); 
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
           				
						try
		   				{			   
		      				Statement statement=con.createStatement();
							 String sql1a=  "  select TLD.INSPLOT_NO as SELECTFLAG, TLD.INSPLOT_NO ,TLD.RECEIPT_QTY ,TLD.SUPPLIER_LOT_NO,  "+
	   										"   	 TLD.INV_ITEM_ID,TLD.PO_HEADER_ID, TLD.PO_LINE_ID, TLD.PO_LINE_LOCATION_ID,TLD.SHIPMENT_HEADER_ID,TLD.SHIPMENT_LINE_ID,  "+
	   										"		 MSI.PRIMARY_UOM_CODE UOM_CODE, TLD.UOM , "+
                							"        TLD.EMPLOYEE_ID, TLD.ORGANIZATION_ID, TLD.RECEIPT_NO, TLD.INTERFACE_TRANSACTION_ID,TLD.SHIP_TO_LOCATION_ID,  "+
	   										"		 substr(TLD.INSPLOT_NO,4,2) as INSP_CLASS, TLD.INSPECTOR,RT.TRANSACTION_ID PARN_ID, "+
											"        RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RCV_ID,rcv_interface_groups_s.NEXTVAL GROUP_ID "+
					 						" , TLD.TO_ORGANIZATION_ID"+
  											"   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,RCV_TRANSACTIONS RT ,MTL_SYSTEM_ITEMS MSI "+
											"  where TLD.INSPLOT_NO = '"+inspLotNo+"'  and TLD.LINE_NO = '"+aIQCApprovingCode[i][0]+"' "+
  											"    and TLD.SHIPMENT_LINE_ID =RT.SHIPMENT_LINE_ID and rt.TRANSACTION_TYPE='RECEIVE' "+
                							"    AND TLD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID  AND TLD.TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID "+  //20100520 LILING ADD
											"    AND TLD.LSTATUSID<>'"+getStatusRs.getString("TOSTATUSID")+"' AND TLD.LSTATUS<>'"+getStatusRs.getString("STATUSNAME")+"'";//add by Peggy 20130918
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next())
              				{  
			    				int rcvGroupID = 0;
								int parentTransID = 0;	
								String sInspector = rs.getString("INSPECTOR");
								//if (sInspector==null || sInspector.equals("RU_XIAOHONG"))  sInspector = "ZHANG_YUJING";
								if (sInspector==null || sInspector.equals("RU_XIAOHONG") || sInspector.equals("ZHANG_YUJING"))  sInspector = "XING_ENFANG";  //ZHANG_YUJING change to XING_ENFANG,20131008 update by Peggy 

								// 20100408 Marvie Update : RU_XIAOHONG -> ZHANG_YUJING
								String sqlfnd = "select USER_ID, EMPLOYEE_ID from APPS.FND_USER"+
 						        				" where USER_NAME = UPPER('"+sInspector+"')";
								Statement stateFndId=con.createStatement();
                				ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
								if (rsFndId.next())
								{
				  					fndUserID = rsFndId.getString("USER_ID");
				  					fndEmpID = rsFndId.getString("EMPLOYEE_ID"); 
								}
								rsFndId.close();
								stateFndId.close();			

				 				String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle
				 				if (inspClass!="06" && !inspClass.equals("06"))
				 				{
									// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
									String employeeID = "";
									if (fndEmpID==null || fndEmpID.equals("")) 
									{ 
					  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
					  					{	  
                         					//employeeID = "5675";    // 20100316 Marvie Update : ZHANG_YUJING/5675
											employeeID = "5676";    // 20131008 Peggy Update : XING_ENFANG/5676
					  					}
					  					else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
									}
									else 
									{
					  					employeeID = fndEmpID; // 以IQC檢驗人員為ACC Created By
									}   
			        				// 2006/12/19 若Oracle未將收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
									
									//  20091119 liling 直接丟interface table 不再call package
                   					String rcvIsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
    							   					"      LAST_UPDATED_BY, CREATED_BY, EMPLOYEE_ID, "+
    							   					"     TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
    							  					"     PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
    							   					"     TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
								   					"     SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
    							   					"     RECEIPT_SOURCE_CODE) "+
                                  					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?) ";
  									PreparedStatement pstmtI=con.prepareStatement(rcvIsql);  
  									pstmtI.setInt(1,rs.getInt("RCV_ID"));  // INTERFACE_TRANSACTION_ID
                    				pstmtI.setString(2,fndUserID);  // GROUP_ID  固定丟USER的 USER_ID識別
									pstmtI.setInt(3,rs.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
                    				pstmtI.setString(4,fndUserID);  //  LAST_UPDATED_BY
				    				pstmtI.setString(5,fndUserID);  // CREATED_BY
									pstmtI.setString(6,employeeID);  // EMPLOYEE_ID
									pstmtI.setString(7,"ACCEPT");  // TRANSACTION_TYPE
									pstmtI.setDate(8,receivingDate);  // TRANSACTION_DATE
									pstmtI.setString(9,"PENDING");  // PROCESSING_STATUS_CODE
									pstmtI.setString(10,"BATCH");  // PROCESSING_MODE_CODE
									pstmtI.setString(11,"PENDING");  // TRANSACTION_STATUS_CODE
									pstmtI.setInt(12,rs.getInt("PO_LINE_ID"));  // PO_LINE_ID
									pstmtI.setInt(13,rs.getInt("INV_ITEM_ID"));  // PO_LINE_ID
									pstmtI.setFloat(14,rs.getFloat("RECEIPT_QTY"));  // QUANTITY
									pstmtI.setString(15,rs.getString("UOM"));  // UNIT_OF_MEASURE
									pstmtI.setInt(16,rs.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
									pstmtI.setInt(17,rs.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
									// 20100506 Marvie Update : fix bug
									pstmtI.setInt(18,rs.getInt("TO_ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
									pstmtI.setString(19,"Y");  // VALIDATION_FLAG
									pstmtI.setString(20,"RECEIVING");  // DESTINATION_TYPE_CODE
									pstmtI.setInt(21,rs.getInt("SHIP_TO_LOCATION_ID"));  // SHIP_TO_LOCATION_ID
									//pstmtI.setString(22,rs.getString("UOM_CODE"));  // UOM_CODE
									pstmtI.setString(22,rs.getString("UOM"));  //改抓PO的UOM,modify by Peggy 20111230
									pstmtI.setInt(23,rs.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
									pstmtI.setInt(24,rs.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
									pstmtI.setString(25,inspLotNo);  // ATTRIBUTE6
									pstmtI.setString(26,rs.getString("SUPPLIER_LOT_NO"));  // VENDOR_LOT_NUM
                    				pstmtI.setString(27,"VENDOR");   // RECEIPT_SOURCE_CODE
  									pstmtI.executeUpdate(); 
 									pstmtI.close();
// 20091119 
				    				int currTrIDSeq = 0;
				    				String sqlTrSeq = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS_INTERFACE "+
                                    				  " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = "+fndUserID+" and TRANSACTION_TYPE ='ACCEPT' "+
					  			   	 				 "    and PROCESSING_STATUS_CODE not in ('ERROR','COMPLETED') ";
				    				Statement stateTrSeq=con.createStatement();
                    				ResultSet rsTrSeq=stateTrSeq.executeQuery(sqlTrSeq);
				    				if (rsTrSeq.next())
				    				{
				      					currTrIDSeq = rsTrSeq.getInt(1);
				    				}
				    				rsTrSeq.close();
				    				stateTrSeq.close();
				 	  
	               					if (errorMessageHeader==null ) 
				   					{ 
				    					errorMessageHeader = "&nbsp;";	
				   					} //errorMessageHeader==null

				   					if (errorMessageLine==null ) 
				   					{ 
										errorMessageLine = "&nbsp;";
									}	

				  				} // End of if (inspClass!="" && !inspClass.equals("06"))   // 判段不為RMA才作ORacle ACCEPT
			   				} // End of While			          							 
			   				rs.close();
			   				statement.close();	 // 此次檢驗合格的While							 		
		      			}	// End of try
		      			catch (Exception e) 
		      			{ 
							out.println("Exception:"+e.getMessage()); 
						}		   
		      			// 呼叫 Package 內Procedure Interface APIs的方式_迄(檢驗合格_ACCEPT)			
	   					//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
	 					if (!errRCVFlag && acceptRcvOK) // 成功執行RCV REQUEST 及執行後無Interface異常,則更新此張 IQC 單號資訊
	 					{  // 2007/01/15 改為AVP 同意驗收
							sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?, "+
		    					"  LSTATUSID=?, LSTATUS=?, RESULT=?, COMMENTS=? "+
	        					"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCApprovingCode[i][0]+"' ";     
        					pstmt=con.prepareStatement(sql);
							pstmt.setString(1,UserName); //同意人員姓名
							pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
							pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
							pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態		
							pstmt.setString(5,"ACCEPT"); // 最後判定
							pstmt.setString(6,aIQCApprovingCode[i][7]); // Comment
        					pstmt.executeUpdate(); 
        					pstmt.close();   		
	  					} 			
						Statement statement=con.createStatement();
            			ResultSet rs=null;		  
			  			  
						// 處理歷程檔寫入	  
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCApprovingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo);  //out.println("inspLotNo="+inspLotNo);
					  	historystmt.setString(2,aIQCApprovingCode[i][0]); //out.println("aIQCApprovingCode[i][0]="+aIQCApprovingCode[i][0]);  // Line_No
					  	historystmt.setString(3,fromStatusID); //out.println("fromStatusID="+fromStatusID);
					  	historystmt.setString(4,oriStatus); //out.println("oriStatus="+oriStatus); //寫入status名稱
					  	historystmt.setString(5,actionID); //out.println("actionID="+actionID); //寫入status名稱
					  	historystmt.setString(6,actionName); //out.println("actionName="+actionName);
					  	historystmt.setString(7,UserName); //out.println("UserName="+UserName);
					  	historystmt.setString(8,dateBean.getYearMonthDay());  
					  	historystmt.setString(9,dateBean.getHourMinuteSecond()); 
					  	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					  	historystmt.setString(11,aIQCApprovingCode[i][7]); //out.println("aIQCApprovingCode[i][7]="+aIQCApprovingCode[i][7]);  // Comments
					  	historystmt.setInt(12,deliveryCount);	//out.println("deliveryCount="+deliveryCount);	      
					  	historystmt.executeUpdate(); 
					  	historystmt.close();   		 
					} // End of if (choice[k]==aIQCApprovingCode[i][0] || choice[k].equals(aIQCApprovingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCApprovingCode!=null)      
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        { 
	    	Statement stateList=con.createStatement();
			String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
			                 " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
								                             "   where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
            ResultSet rsList=stateList.executeQuery(sqlList); // 發給各倉管人員作入庫
	        while (rsList.next())
	        {         
				sendMailBean.setMailHost(mailHost);
			   	sendMailBean.setReception(rsList.getString("USERMAIL"));		        
			   	sendMailBean.setFrom(UserName);   	 	 
			   	sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統廠主管授權核准通知"));                  
			   	sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:合格檢驗批廠主管授權核准通知-檢驗批單號("+inspLotNo+")"));   	 
			   	sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotQueryAllStatus.jsp?SEARCHSTRING="+inspLotNo+"&STATUSID=023&PAGEURL=TSIQCInspectLotReceivingPage.jsp");//				   
			   	sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	   
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	    // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目
		 
		// 再更新IQC檢驗批主檔資料
		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?, STATUS=?, LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?,RESULT=? "+
		    " where INSPLOT_NO='"+inspLotNo+"' ";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS
		pstmt.setString(3,UserName);   // 最後更新人員
	    pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		pstmt.setString(5,"ACCEPT"); // 同意 	  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCApprovingCode!=null)
		{ 
	  		arrIQC2DApprovingBean.setArray2DString(null); 
		}
	
	 	Statement stateReProcess=con.createStatement(); 
     	ResultSet rsReProcess=stateReProcess.executeQuery("select INSPLOT_NO, LINE_NO from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where LSTATUSID='027' ");  // 取任一筆未處理INSP單據做核准的Line_No
	 	if (rsReProcess.next())
	 	{
	  		String reInspLotNo = rsReProcess.getString("INSPLOT_NO");
	  		String reLineNo = rsReProcess.getString("LINE_NO");	 
	 %>
	   <script LANGUAGE="JavaScript">
	       reProcessFormConfirm("處理下一筆檢驗批核准驗收單?","../jsp/TSIQCInspectLotApprovingPage.jsp","<%=reInspLotNo%>","<%=reLineNo%>");
	   </script>
	 <%
	 	} // end of if (rsReProcess.next())
	 	else 
		{ // 不存在則回到Query Status
	       %>
	          <script LANGUAGE="JavaScript">
	            ProcessFormQuery("../jsp/TSIQCInspectLotQueryAllStatus.jsp","027","TSIQCInspectLotApprovingPage.jsp");
	          </script>
	       <%
	 	}
	 	rsReProcess.close();
	 	stateReProcess.close();
  	} //若為工廠主管核准檢驗批單據(APPROVE)_迄 (ACTION=027) from_Status = Authorizing  to_status = Approving
  // 工廠主管核准檢驗批(APPROVE)_迄 (ACTION=027) 

	// 工廠主管不同意檢驗批_系統執行REJECT_迄 (ACTION=005 && STATUSID=027) 
  	if (actionID.equals("005") && fromStatusID.equals("027")) 
  	{
    	if (aIQCApprovingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCApprovingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCApprovingCode[i][0] || choice[k].equals(aIQCApprovingCode[i][0]))
	    			{ 	  		
						//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
					   	String fndUserID = "";
					   	String fndEmpID = "";
				        //抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄
		
		   				// 呼叫 Package 內Procedure Interface APIs 的方式_起(檢驗判退_REJECT)
		   				String devStatus = "";
		   				String devMessage = "";	
		   				String rvcGrpID = "0";
		   				boolean errRCVFlag = false;
		   				boolean acceptRcvOK  = true;
		   				respID = "";
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
 							String sql1a=   "  select TLD.INSPLOT_NO as SELECTFLAG, TLD.INSPLOT_NO ,TLD.RECEIPT_QTY ,TLD.SUPPLIER_LOT_NO,  "+
	   										"   	 TLD.INV_ITEM_ID,TLD.PO_HEADER_ID, TLD.PO_LINE_ID, TLD.PO_LINE_LOCATION_ID,TLD.SHIPMENT_HEADER_ID,TLD.SHIPMENT_LINE_ID,  "+
	   										"		 MSI.PRIMARY_UOM_CODE UOM_CODE, TLD.UOM, "+
                							"        TLD.EMPLOYEE_ID, TLD.ORGANIZATION_ID, TLD.RECEIPT_NO, TLD.INTERFACE_TRANSACTION_ID,TLD.SHIP_TO_LOCATION_ID,  "+
	   										"		 substr(TLD.INSPLOT_NO,4,2) as INSP_CLASS, TLD.INSPECTOR,RT.TRANSACTION_ID PARN_ID, "+
											"        RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RCV_ID,rcv_interface_groups_s.NEXTVAL GROUP_ID "+
  											"   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,RCV_TRANSACTIONS RT ,MTL_SYSTEM_ITEMS MSI "+
											"  where TLD.INSPLOT_NO = '"+inspLotNo+"'  and TLD.LINE_NO = '"+aIQCApprovingCode[i][0]+"' "+
                							"    AND TLD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID  AND TLD.TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID "+ //20100520 LILING
  											"    and TLD.SHIPMENT_LINE_ID =RT.SHIPMENT_LINE_ID and rt.TRANSACTION_TYPE='RECEIVE' "+
											"    AND TLD.LSTATUSID<>'"+getStatusRs.getString("TOSTATUSID")+"' AND TLD.LSTATUS<>'"+getStatusRs.getString("STATUSNAME")+"'"; //add by Peggy 20130918
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next())
              				{
			     				int rcvGroupID = 0;
				 				int parentTransID = 0;
				 				// 2007/01/24 更改 REJ 人員為檢驗員_起
				         		String sqlfnd = " select USER_ID, EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 								   	            " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+rs.getString("INSPECTOR")+ "'";
						 		Statement stateFndId=con.createStatement();
                         		ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 		if (rsFndId.next())
						 		{
						   			fndUserID = rsFndId.getString("USER_ID"); 
						   			fndEmpID = rsFndId.getString("EMPLOYEE_ID");
						 		}
						 		rsFndId.close();
						 		stateFndId.close();
				 				// 2007/01/24 更改 REJ 人員為檢驗員_迄
				 				String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle
				 
				 				if (inspClass!="06" && !inspClass.equals("06"))
				 				{
			        				try
				    				{ //out.println("ID1="+"<BR>");			  	  
				      					//out.println("ID3="+"<BR>");				 
				    				} //end of try
                   					catch (Exception e)
                    				{
	                 					e.printStackTrace();
                     					out.println(e.getMessage());
                    				}//end of catch    	
					
									// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
									String employeeID = "";
									if (fndEmpID==null || fndEmpID.equals("")) 
									{ 
					  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
					  					{  
                         					//employeeID = "5675";     // 20100316 Marvie Update : ZHANG_YUJING/5675
											employeeID = "5676";    // 20131008 Peggy Update : XING_ENFANG/5676
					  					}
					 	 				else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
									}
									else 
									{
					       				employeeID = fndEmpID;
					     			}   
			    					// 2006/12/19 若Oracle未將收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
				 				 
									//  20091119 liling 直接丟interface table 不再call package
                   					String rcvIsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
    							   					"      LAST_UPDATED_BY, CREATED_BY, EMPLOYEE_ID, "+
    							 					"     TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
    							   					"     PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
    							   					"     TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
								   					"     SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
    							   					"     RECEIPT_SOURCE_CODE) "+
                                   					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?) ";
  									PreparedStatement pstmtI=con.prepareStatement(rcvIsql);  
  									pstmtI.setInt(1,rs.getInt("RCV_ID"));  // INTERFACE_TRANSACTION_ID
                    				pstmtI.setString(2,fndUserID);  // GROUP_ID  固定丟USER的 USER_ID識別
									pstmtI.setInt(3,rs.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
                    				pstmtI.setString(4,fndUserID);  //  LAST_UPDATED_BY
				    				pstmtI.setString(5,fndUserID);  // CREATED_BY
									pstmtI.setString(6,employeeID);  // EMPLOYEE_ID
									pstmtI.setString(7,"REJECT");  // TRANSACTION_TYPE
									pstmtI.setDate(8,receivingDate);  // TRANSACTION_DATE
									pstmtI.setString(9,"PENDING");  // PROCESSING_STATUS_CODE
									pstmtI.setString(10,"BATCH");  // PROCESSING_MODE_CODE
									pstmtI.setString(11,"PENDING");  // TRANSACTION_STATUS_CODE
									pstmtI.setInt(12,rs.getInt("PO_LINE_ID"));  // PO_LINE_ID
									pstmtI.setInt(13,rs.getInt("INV_ITEM_ID"));  // PO_LINE_ID
									pstmtI.setFloat(14,rs.getFloat("RECEIPT_QTY"));  // QUANTITY
									pstmtI.setString(15,rs.getString("UOM"));  // UNIT_OF_MEASURE
									pstmtI.setInt(16,rs.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
									pstmtI.setInt(17,rs.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
									pstmtI.setInt(18,rs.getInt("ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
									pstmtI.setString(19,"Y");  // VALIDATION_FLAG
									pstmtI.setString(20,"RECEIVING");  // DESTINATION_TYPE_CODE
									pstmtI.setInt(21,rs.getInt("SHIP_TO_LOCATION_ID"));  // SHIP_TO_LOCATION_ID
									//pstmtI.setString(22,rs.getString("UOM_CODE"));  // UOM_CODE
									pstmtI.setString(22,rs.getString("UOM"));  //抓PO的UOM,modify by Peggy 20111230
									pstmtI.setInt(23,rs.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
									pstmtI.setInt(24,rs.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
									pstmtI.setString(25,inspLotNo);  // ATTRIBUTE6
									pstmtI.setString(26,rs.getString("SUPPLIER_LOT_NO"));  // VENDOR_LOT_NUM
									pstmtI.setString(27,"VENDOR");   // RECEIPT_SOURCE_CODE
									pstmtI.executeUpdate(); 
									pstmtI.close();
	                				
									if (errorMessageHeader==null ) 
				    				{ 
										errorMessageHeader = "&nbsp;";
				    				} // (errorMessageHeader==null ) 		
				    				if (errorMessageLine==null ) 
				    				{ errorMessageLine = "&nbsp;";}	
				  				} // End of if (inspCLass!="06" && !inspClass.equals("06")) // 判斷不為RMA的才作REJECT 入oracle
			   				} // End of While			          							 
			   				rs.close();
			   				statement.close();	 // 此次檢驗判退的While							 		
		      			}	// End of try
		      			catch (Exception e) 
		      			{ 
							out.println("Exception:"+e.getMessage()); 
						}		   
		     			// 呼叫 Package 內Procedure Interface APIs的方式_迄(檢驗判退_REJECT)		
		
	           			//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
						if (!errRCVFlag && acceptRcvOK) // 若成功執行RCV Request及正確入RCV Transaction Interface才執行更新IQC資訊
						{   
		      				sql=" update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				" where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCApprovingCode[i][0]+"' ";     
              				pstmt=con.prepareStatement(sql);           
		      				pstmt.setString(1,userID); // 最後更新人員 
		      				pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		     	 			pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		      				pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態 
             				pstmt.executeUpdate(); 
              				pstmt.close();  
			  
						   	sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
						   	pstmt=con.prepareStatement(sql);   
						   	pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
						   	pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
						   	pstmt.executeUpdate();
						   	pstmt.close(); 			  
			 			} // End of if (!errRCVFlag && acceptRcvOK)
			 
		   				// 處理歷程檔寫入_起	 
		      			Statement statement=con.createStatement();
              			ResultSet rs=null;	 
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCApprovingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			            		          " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		  "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCApprovingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			 			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCApprovingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
             		 	historystmt.close();   
		    			// 處理歷程檔寫入_迄 
					} // End of if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCAuthorizingCode!=null)  
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        {               
	    	Statement stateList=con.createStatement();
			String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
				             " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
						     "   where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        if (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統廠主管不同意檢驗批判退通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:廠主管不同意檢驗批判退-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotQueryAllStatus.jsp?SEARCHSTRING="+inspLotNo+"&STATUSID=024&PAGEURL=TSIQCInspectLotReturningPage.jsp");//				   
                sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	   
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	     // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目

	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set RESULT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	         "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql);     
		pstmt.setString(1,"REJECT"); // 檢驗不合格批退   
        pstmt.setString(2,userID); // 最後更新人員
	    pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
	    if (aIQCAuthorizingCode!=null)
	    { 
	    	arrIQC2DAuthorizingBean.setArray2DString(null); 
	    }
  	} //若為工廠主管不同意檢驗批(REJECT)_迄
	// 廠主管不同意檢驗批_系統執行REJECT_迄 (ACTION=005 && STATUSID=027)   
  
  	//若為品管檢驗明細輸入判定允收(ACCEPT),則執行以下動作,
  	//品管檢驗明細輸入(ACCEPT)_起	(ACTION=016)  允收 from_status = Inspecting to_statu = Receiving
  	if (actionID.equals("016")) 
  	{             
		//Step1. 若為品管檢驗明細輸入判定允收(ACTION=ACCEPT)
		if (aIQCInspectingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{ 
	 		for (int i=0;i<aIQCInspectingCode.length-1;i++)
		 	{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{   
					// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCInspectingCode[i][0] || choice[k].equals(aIQCInspectingCode[i][0]))
	    			{ 		
						if (product!=null && product.length()>80)
						{ 
			   				product = product.substring(0,80); // (避免宜蘭豬頭使用者建立過長料號描述)
						}
	    				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set INSPECT_DATE=?,INSPECTOR=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?, "+
		    				" LSTATUSID=?,LSTATUS=?, "+
		    				" PRODUCTS=?, WAFER_SIZE=?, DICE_SIZE=?, TOTAL_YIELD=?,PROD_YIELD=?, RESULT=? ,INSPECT_REMARK=? "+
	        				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ";     
        				pstmt=con.prepareStatement(sql);
	    				pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 檢驗日期 
						pstmt.setString(2,UserName); // 登入處理人員即為檢驗員  
						pstmt.setString(3,userID); // 最後更新人員工號ID
						pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						pstmt.setString(5,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
						pstmt.setString(6,getStatusRs.getString("STATUSNAME")); // Line 的狀態
						pstmt.setString(7,product); // 適用型號	(避免宜蘭豬頭使用者建立過長料號描述)	
						pstmt.setString(8,wfSizeID); // 晶片尺寸
						pstmt.setString(9,exDiceSize); // 晶粒尺寸			
						pstmt.setString(10,totalYield); // 電性良品率
						pstmt.setString(11,prodYield); // 型號良率		
						pstmt.setString(12,result); // 最後判定
        				if (remark==null || remark.equals("null") || remark=="" || remark.equals("")) remark="N/A";
	    				pstmt.setString(13,remark); // 不良原因說明 //20091204 liling add
       	 				pstmt.executeUpdate(); 
        				pstmt.close();   		
	
            			// 處理歷程檔寫入_起	
			  			Statement statement=con.createStatement();
              			ResultSet rs=null;	  
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    		" ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                       			 "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCInspectingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			 		 	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCInspectingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
              			historystmt.close();   
		 	 			// 處理歷程檔寫入_起 
	   				} // End of if (choice[k]==aIQCInspectingCode[i][0] || choice[k].equals(aIQCInspectingCode[i][0]))
	  			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有Check才指派生產地
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCInspectingCode!=null) 
	  
	  	//Step4. 取得本張單據分配的工廠組合字串_起 
	 	//Step4. 再更新IQC檢驗批主檔資料
     	sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set INSPECT_DATE=?,INSPECTOR=?, RESULT=? ,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?, "+
	     " PROD_MODEL=?, PROD_NAME=?, WAFER_SIZE=?, DICE_SIZE=?, WF_THICK=?, WF_RESIST=?, PLAT_LAYER=?,TOTAL_YIELD=?,PROD_YIELD=? "+
	     "where INSPLOT_NO='"+inspLotNo+"' ";     
     	pstmt=con.prepareStatement(sql);   
	 	pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 檢驗日期 
	 	pstmt.setString(2,UserName); // 登入處理人員即為檢驗員     
	 	pstmt.setString(3,"ACCEPT"); // 檢驗合格 允收
     	pstmt.setString(4,userID); // 最後更新人員
	 	pstmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間  
	 	pstmt.setString(6,product); // 適用型號
	 	pstmt.setString(7,""); // 物料名稱:
	 	pstmt.setString(8,wfSizeID); // 晶片尺寸
	 	pstmt.setString(9,exDiceSize); // 晶粒尺寸
	 	pstmt.setString(10,exWfThick); // 晶片厚度
	 	pstmt.setString(11,exWfResist); // 電阻系數
	 	pstmt.setString(12,wfPlatID); // 鍍層
	 	pstmt.setString(13,totalYield); // 電性良品率
	 	pstmt.setString(14,prodYield); // 型號良率		    
     	pstmt.executeUpdate(); 
     	pstmt.close();      
	 	// 再更新IQC檢驗批主檔資料
	
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCInspectingCode!=null)
		{ 
	  		arrIQC2DInspectingBean.setArray2DString(null); 
		}
  	}  //END OF 016_ACTION IF  
 	//品管檢驗合格判定,送予倉管(ACCEPT)_迄(ACTION=016)  
  
  	//  (ACTION=005)品管檢驗不合格判退檢驗批單(REJECT)_起 (ACTION=005) from_Status = Inspecting to_status = Confirming
  	if (actionID.equals("005")) 
  	{ 
    	if (aIQCInspectingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCInspectingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCInspectingCode[i][0] || choice[k].equals(aIQCInspectingCode[i][0]))
	    			{ 			
			  			if (product!=null && !product.equals("null") && product.length()>80  )
			 		 	{	
			   				product = product.substring(0,80); // (避免宜蘭豬頭使用者建立過長料號描述)
			  			}	
				  
			  			sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set INSPECT_DATE=?,INSPECTOR=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?, "+
		          			" PRODUCTS=?, WAFER_SIZE=?, DICE_SIZE=?, TOTAL_YIELD=?,PROD_YIELD=?, RESULT=?, INSPECT_REMARK=? "+
	              			"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ";     
              			pstmt=con.prepareStatement(sql);
	          			pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 檢驗日期 
		      			pstmt.setString(2,UserName); // 登入處理人員即為檢驗員  
		      			pstmt.setString(3,userID); // 最後更新人員工號ID
		      			pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		      			pstmt.setString(5,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		      			pstmt.setString(6,getStatusRs.getString("STATUSNAME")); // Line 的狀態
		      			pstmt.setString(7,product); // 適用型號	product.substring(0,80)	
		      			pstmt.setString(8,wfSizeID); // 晶片尺寸
		      			pstmt.setString(9,exDiceSize); // 晶粒尺寸			
		      			pstmt.setString(10,totalYield); // 電性良品率
		      			pstmt.setString(11,prodYield); // 型號良率		
		      			pstmt.setString(12,result); // 最後判定
			  			pstmt.setString(13,remark); // 不良原因說明
              			pstmt.executeUpdate(); 
              			pstmt.close();  
			  
			 			// 處理歷程檔寫入_起
			  			Statement statement=con.createStatement();
              			ResultSet rs=null;			  
			 	 		statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			            		        " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		"values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCInspectingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCInspectingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
              			historystmt.close();   
		  				// 處理歷程檔寫入_迄
					} // End of if (choice[k]==aIQCWaivingCode[i][0] || choice[k].equals(aIQCWaivingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCWaivingCode!=null)    
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        { 
	    	Statement stateList=con.createStatement();
	        String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSC_MC_USER b where a.USERNAME = b.MC_USERID and b.TSC_DEPT_ID = 'YEW_MC' ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        while (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統品管檢驗不合格通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:品管檢驗批檢驗不合格-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotWaivingPage.jsp?INSPLOTNO="+inspLotNo+"&LSTATUSID=022");//				   
                sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	   
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	    // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目		
		 
	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set INSPECT_DATE=?,INSPECTOR=?,RESULT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?, "+
	         " PROD_MODEL=?, PROD_NAME=?, WAFER_SIZE=?, DICE_SIZE=?, WF_THICK=?, WF_RESIST=?, PLAT_LAYER=?,TOTAL_YIELD=?,PROD_YIELD=? "+
	         "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql);   
	    pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 檢驗日期 
	    pstmt.setString(2,UserName); // 登入處理人員即為檢驗員     
	    pstmt.setString(3,"REJECT"); // 檢驗不合格 批退
        pstmt.setString(4,userID); // 最後更新人員
	    pstmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間  
	    pstmt.setString(6,product); // 適用型號
	    pstmt.setString(7,""); // 物料名稱:
	    pstmt.setString(8,wfSizeID); // 晶片尺寸
	    pstmt.setString(9,exDiceSize); // 晶粒尺寸
	    pstmt.setString(10,exWfThick); // 晶片厚度
	    pstmt.setString(11,exWfResist); // 電阻系數
	    pstmt.setString(12,wfPlatID); // 鍍層
	    pstmt.setString(13,totalYield); // 電性良品率
	    pstmt.setString(14,prodYield); // 型號良率	      
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料
		 
		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCInspectingCode!=null)
		{ 
	  		arrIQC2DInspectingBean.setArray2DString(null); 
		}
  	} //若為品管檢驗不合格判退檢驗批單(REJECT)_起 (ACTION=005) from_Status = Inspecting to_status = Confirming
  	// 品管檢驗不合格判退(REJECT)_迄 (ACTION=005)   
  
	// 品管刪除檢驗批單據(CANCEL)_起 (ACTION=021) 刪除
  	if (actionID.equals("021")) 
  	{ 
    	if (aIQCInspectingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCInspectingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{ 
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCInspectingCode[i][0] || choice[k].equals(aIQCInspectingCode[i][0]))
	    			{ 	
			  			sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+		         
	              			"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ";     
              			pstmt=con.prepareStatement(sql);
		      			pstmt.setString(1,userID); // 最後更新人員工號ID
		      			pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		      			pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		      			pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態		     
              			pstmt.executeUpdate(); 
              			pstmt.close();  
			  
			  			Statement statement=con.createStatement();
              			ResultSet rs=null;			  
			  			// 處理歷程檔寫入_起	  
			  			statement=con.createStatement();
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
              			rs.next();
              			actionName=rs.getString("ACTIONNAME");
   
              			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
              			rs.next();
              			oriStatus=rs.getString("STATUSNAME");   
              			statement.close();
              			rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCInspectingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    		" ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		"values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCInspectingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCInspectingCode[i][7]); // Comments
			 			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
              			historystmt.close();   
		  				// 處理歷程檔寫入_迄		  
					} // End of if (choice[k]==aIQCWaivingCode[i][0] || choice[k].equals(aIQCWaivingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCWaivingCode!=null)      

		// 寄送 E-Mail_起   -----------------> 送給IQC通知取消
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        {               
	    	Statement stateList=con.createStatement();
	        String sqlList = " SELECT DISTINCT a.USERMAIL, a.USERNAME FROM ORADDMAN.WSUSER a   "+
							 "   WHERE UPPER(a.USERNAME) IN (SELECT UPPER(QCUSER_NAME) FROM ORADDMAN.TSCIQC_INSPECT_USER )	"+	
  						   	 "   AND A.USERMAIL IS NOT NULL AND A.LOCKFLAG='N'	 ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        if (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統品管取消檢驗批通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:品管取消檢驗批-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotCanceledPage.jsp?INSPLOTNO="+inspLotNo+"&LSTATUSID=013");//				   
                sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	   
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	    // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目	    

		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCInspectingCode!=null)
		{ 
	  		arrIQC2DInspectingBean.setArray2DString(null); 
		}
	} // from_Status =021 Inspecting to_status =013 CANCELED 
	// 品管刪除檢驗批單據(CANCEL)_迄 (ACTION=021)

	//若為物管將不合格檢驗批送審廠主管核准(APPLY)_起 (ACTION=011) from_Status = 022  to_status = Waiving 
  	if (actionID.equals("011"))  
  	{     
    	if (aIQCWaivingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCWaivingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCWaivingCode[i][0] || choice[k].equals(aIQCWaivingCode[i][0]))
	    			{ 			
						Statement statement=con.createStatement();
            			ResultSet rs=null;		        
			  
			  			sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?, "+
			      			" LSTATUSID=?, LSTATUS=?, LWAIVE_NO=?  "+		          
	              			"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaivingCode[i][0]+"' ";     
              			pstmt=con.prepareStatement(sql);
		      			pstmt.setString(1,userID); // 最後更新人員工號ID
		      			pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		      			pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
					  	pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態
					  	pstmt.setString(5,aIQCWaivingCode[i][7]); // Comments	      
					  	pstmt.executeUpdate(); 
					  	pstmt.close();  
			  			  
						// 處理歷程檔寫入	  
					  	statement=con.createStatement();
					  	rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
					  	rs.next();
					  	actionName=rs.getString("ACTIONNAME");
		   
					  	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					  	rs.next();
					  	oriStatus=rs.getString("STATUSNAME");   
					  	statement.close();
					 	rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaivingCode[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	         		 	{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	         			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW,WAIVE_REMARK) "+  //add WAIVE_REMARK by Peggy 20170612
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCWaivingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
             			historystmt.setString(5,actionID); 
					  	historystmt.setString(6,actionName);
					  	historystmt.setString(7,UserName);
					  	historystmt.setString(8,dateBean.getYearMonthDay()); 
					 	historystmt.setString(9,dateBean.getHourMinuteSecond()); 
					 	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					  	historystmt.setString(11,aIQCWaivingCode[i][7]); // Waive No.
					  	historystmt.setInt(12,deliveryCount);		      
					  	historystmt.setString(13,(remark==null?"N/A":remark)); //add by 20170612
					  	historystmt.executeUpdate(); 
					  	historystmt.close();   		 
					} // End of if (choice[k]==aIQCAuthorizingCode[i][0] || choice[k].equals(aIQCAuthorizingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCAuthorizingCode!=null)      
	    // 再更新IQC檢驗批主檔資料
		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?, STATUS=?, LAST_UPDATED_BY=?, LAST_UPDATE_DATE=?,WAIVE_NO=? "+
		     " where INSPLOT_NO='"+inspLotNo+"' ";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS
		pstmt.setString(3,userID); // 最後更新人員
	    pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 	 
		pstmt.setString(5,waiveNo); // 特採單號 	  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCWaivingCode!=null)
		{ 
	  		arrIQC2DWaivingBean.setArray2DString(null); 
		}
  	} //物管將不合格檢驗批送審廠主管核准(APPLY)_起 (ACTION=011) from_Status = 022  to_status = Waiving
	// 物管將不合格檢驗批送審廠主管核准(APPLY)_迄 (ACTION=011)    

	//  (ACTION=017)工廠主管核准檢驗批為特採(WAIVE)_起 (ACTION=017) from status = Conforming to_status = Receiving
  	if (actionID.equals("017")) 
  	{ 
		//out.println("ACTIONID="+actionID);
   		if (aIQCWaiveApprovedCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCWaiveApprovedCode.length-1;i++)
	 		{ 
	   			for (int k=0;k<=choice.length-1;k++)    
      	 		{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCWaiveApprovedCode[i][0] || choice[k].equals(aIQCWaiveApprovedCode[i][0]))
	    			{ 
	       				String fndUserID = "";
		   				String fndEmpID = "";
					   	String devStatus = "";
					   	String devMessage = "";	
					   	String rvcGrpID = "0";
					   	boolean errRCVFlag = false;
					   	boolean acceptRcvOK = true;
					   	respID = "";
		      			//先取得欲執行產生PO之Responsibility ID_起
	          			Statement stateResp=con.createStatement();	 
	          			ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME = 'YEW_PO_SEMI_SU' "); 
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
 							String sql1a= "  select TLD.INSPLOT_NO as SELECTFLAG, TLD.INSPLOT_NO ,TLD.RECEIPT_QTY ,TLD.SUPPLIER_LOT_NO,  "+
	   									"   	 TLD.INV_ITEM_ID,TLD.PO_HEADER_ID, TLD.PO_LINE_ID, TLD.PO_LINE_LOCATION_ID,TLD.SHIPMENT_HEADER_ID,TLD.SHIPMENT_LINE_ID,  "+
	   									"		 MSI.PRIMARY_UOM_CODE UOM_CODE, TLD.UOM, "+
                        				"        TLD.EMPLOYEE_ID, TLD.ORGANIZATION_ID, TLD.RECEIPT_NO, TLD.INTERFACE_TRANSACTION_ID,TLD.SHIP_TO_LOCATION_ID,  "+
	   									"		 substr(TLD.INSPLOT_NO,4,2) as INSP_CLASS, TLD.INSPECTOR,RT.TRANSACTION_ID PARN_ID, "+
										"        RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RCV_ID,rcv_interface_groups_s.NEXTVAL GROUP_ID "+
  										"   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,RCV_TRANSACTIONS RT ,MTL_SYSTEM_ITEMS MSI "+
										"  where TLD.INSPLOT_NO = '"+inspLotNo+"'  and TLD.LINE_NO = '"+aIQCWaiveApprovedCode[i][0]+"' "+
                        				"    AND TLD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID  AND TLD.TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID "+ //20100520 LILING
  										"    and TLD.SHIPMENT_LINE_ID =RT.SHIPMENT_LINE_ID and rt.TRANSACTION_TYPE='RECEIVE' "+
										"    and TLD.LSTATUSID <>'"+getStatusRs.getString("TOSTATUSID") +"' and TLD.LSTATUS <>'"+getStatusRs.getString("STATUSNAME")+"'"; //add by Peggy 20130918
		      				Statement statement=con.createStatement();                  
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next())
              				{  
			     				int rcvGroupID = 0;
				 				int parentTransID = 0;		
				 
				         		String sqlfnd = " select USER_ID, EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 						        	         " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+rs.getString("INSPECTOR")+"' ";
						 		Statement stateFndId=con.createStatement();
                        	 	ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						 		if (rsFndId.next())
						 		{
						   			fndUserID = rsFndId.getString("USER_ID"); 
						   			fndEmpID = rsFndId.getString("EMPLOYEE_ID");
						 		}
						 		rsFndId.close();
						 		stateFndId.close();
				 				String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle
				 				if (inspClass!="06" && !inspClass.equals("06"))
				 				{
			        				try
				    				{ 
				    				} //end of try
                    				catch (Exception e)
                    				{
	                  					e.printStackTrace();
                      					out.println(e.getMessage());
                    				}//end of catch 
					
				 					// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
									String employeeID = "";
									if (fndEmpID==null || fndEmpID.equals("")) 
									{ 
					  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
					  					{  
                         					//employeeID = "5675";   // 20100316 Marvie Update : ZHANG_YUJING/5675
											employeeID = "5676";    // 20131008 Peggy Update : XING_ENFANG/5676
					  					}
					  					else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
									}
									else 
									{
					       				employeeID = fndEmpID;
					     			}   
									//  20091119 liling 直接丟interface table 不再call package
                   					String rcvIsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
    							   					"      LAST_UPDATED_BY, CREATED_BY, EMPLOYEE_ID, "+
    							   					"     TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
    							   					"     PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
    							   					"     TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
								   					"     SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
    							   					"     RECEIPT_SOURCE_CODE) "+
                                   					" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?) ";
  									PreparedStatement pstmtI=con.prepareStatement(rcvIsql);  
  									pstmtI.setInt(1,rs.getInt("RCV_ID"));  // INTERFACE_TRANSACTION_ID
                    				pstmtI.setString(2,fndUserID);  // GROUP_ID  固定丟USER的 USER_ID識別
									pstmtI.setInt(3,rs.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
									pstmtI.setString(4,fndUserID);  //  LAST_UPDATED_BY
									pstmtI.setString(5,fndUserID);  // CREATED_BY
									pstmtI.setString(6,employeeID);  // EMPLOYEE_ID
									pstmtI.setString(7,"ACCEPT");  // TRANSACTION_TYPE  //WAVIE 在ERP仍視為ACC
									pstmtI.setDate(8,receivingDate);  // TRANSACTION_DATE
									pstmtI.setString(9,"PENDING");  // PROCESSING_STATUS_CODE
									pstmtI.setString(10,"BATCH");  // PROCESSING_MODE_CODE
									pstmtI.setString(11,"PENDING");  // TRANSACTION_STATUS_CODE
									pstmtI.setInt(12,rs.getInt("PO_LINE_ID"));  // PO_LINE_ID
									pstmtI.setInt(13,rs.getInt("INV_ITEM_ID"));  // PO_LINE_ID
									pstmtI.setFloat(14,rs.getFloat("RECEIPT_QTY"));  // QUANTITY
									pstmtI.setString(15,rs.getString("UOM"));  // UNIT_OF_MEASURE
									pstmtI.setInt(16,rs.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
									pstmtI.setInt(17,rs.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
									pstmtI.setInt(18,rs.getInt("ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
									pstmtI.setString(19,"Y");  // VALIDATION_FLAG
									pstmtI.setString(20,"RECEIVING");  // DESTINATION_TYPE_CODE
									pstmtI.setInt(21,rs.getInt("SHIP_TO_LOCATION_ID"));  // SHIP_TO_LOCATION_ID
									//pstmtI.setString(22,rs.getString("UOM_CODE"));  // UOM_CODE
									pstmtI.setString(22,rs.getString("UOM"));  //抓PO的UOM,modify by Peggy 20111230
									pstmtI.setInt(23,rs.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
									pstmtI.setInt(24,rs.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
									pstmtI.setString(25,inspLotNo);  // ATTRIBUTE6
									pstmtI.setString(26,rs.getString("SUPPLIER_LOT_NO"));  // VENDOR_LOT_NUM
									pstmtI.setString(27,"VENDOR");   // RECEIPT_SOURCE_CODE
									pstmtI.executeUpdate(); 
									pstmtI.close();
				    				
									int currTrIDSeq = 0;
				    				String sqlTrSeq = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS_INTERFACE "+
                                      " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='ACCEPT' "+
					  			   	  "    and PROCESSING_STATUS_CODE not in ('ERROR','COMPLETED') ";
				    				Statement stateTrSeq=con.createStatement();
                    				ResultSet rsTrSeq=stateTrSeq.executeQuery(sqlTrSeq);
				    				if (rsTrSeq.next())
				    				{
				      					currTrIDSeq = rsTrSeq.getInt(1);
				    				}
				    				rsTrSeq.close();
				    				stateTrSeq.close();
	               					
									if (errorMessageHeader==null ) 
				   					{ 
				    					errorMessageHeader = "&nbsp;";	
				   					}				
				   					if (errorMessageLine==null ) 
				   					{
										errorMessageLine = "&nbsp;";
									}	
				  				} // End of if (inspClass!="" && !inspClass.equals("06"))   // 判段不為RMA才作ORacle ACCEPT
			   				} // End of While			          							 
			   				rs.close();
			   				statement.close();	 // 此次檢驗合格的While							 		
		      			}	// End of try
		      			catch (Exception e) 
		      			{ 
							out.println("Exception:"+e.getMessage()); 
						}		   
	 
	 					if (!errRCVFlag && acceptRcvOK) // 成功執行RCV REQUEST 及執行後無Interface異常,則更新此張 IQC 單號資訊
	 					{	
	           				//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
		      				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set RESULT=?,WAIVE_ITEM=?,LWAIVE_NO=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaiveApprovedCode[i][0]+"' ";     
						 	pstmt=con.prepareStatement(sql);  
						  	pstmt.setString(1,"WAIVE"); // 結果為特採  
						  	pstmt.setString(2,"Y"); // 特採編號         
						  	pstmt.setString(3,waiveNo); // 如無個別給定特採,則設定為與頭檔給定編號一致 
						  	pstmt.setString(4,userID); // 最後更新人員
						  	pstmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						  	pstmt.setString(6,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
						  	pstmt.setString(7,getStatusRs.getString("STATUSNAME")); // Line 的狀態 
						  	pstmt.executeUpdate(); 
						  	pstmt.close();  
	 					}	 // 若成功執行特採核准才更新狀態	  
			
					  	Statement statement=con.createStatement();
					  	ResultSet rs=null;	  
					 	// 處理歷程檔寫入_起	  
					  	statement=con.createStatement();
					  	rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
					  	rs.next();
					  	actionName=rs.getString("ACTIONNAME");
   
					  	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					  	rs.next();
					  	oriStatus=rs.getString("STATUSNAME");   
					  	statement.close();
					  	rs.close();	
			  
					  	int deliveryCount = 0;
					  	Statement stateDeliveryCNT=con.createStatement(); 
					  	ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaiveApprovedCode[i][0]+"' ");
					  	if (rsDeliveryCNT.next())
					  	{
							deliveryCount = rsDeliveryCNT.getInt(1);
					  	}
					  	rsDeliveryCNT.close();
					  	stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
					  	historystmt.setString(1,inspLotNo); 
					  	historystmt.setString(2,aIQCWaiveApprovedCode[i][0]);  // Line_No
					  	historystmt.setString(3,fromStatusID); 
					  	historystmt.setString(4,oriStatus); //寫入status名稱
					  	historystmt.setString(5,actionID); 
					  	historystmt.setString(6,actionName);
					  	historystmt.setString(7,UserName);
					  	historystmt.setString(8,dateBean.getYearMonthDay()); 
					  	historystmt.setString(9,dateBean.getHourMinuteSecond()); 
					  	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					  	historystmt.setString(11,aIQCWaiveApprovedCode[i][7]); // Comments
					  	historystmt.setInt(12,deliveryCount);		      
					  	historystmt.executeUpdate(); 
					  	historystmt.close();   
					} // End of if (choice[k]==aIQCWaiveApprovedCode[i][0] || choice[k].equals(aIQCWaiveApprovedCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCWaiveApprovedCode!=null)  
	    
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        {               
	    	Statement stateList=con.createStatement();
	        String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
			                 " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
							  "   where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        while (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統物管申請特採核可通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:物管申請特採核可入庫-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotReceivingPage.jsp?INSPLOTNO="+inspLotNo+"&LSTATUSID=023");//				   
                sendMailBean.sendMail();
	        } 
	        rsList.close();
	        stateList.close();	     
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
		// 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目		 			 
	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set RESULT=?,WAIVE_LOT=?,WAIVE_NO=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	        "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql); 
		pstmt.setString(1,"WAIVE"); // 結果為特採 
		pstmt.setString(2,"Y"); // 特採批設定為 'Y'  -->因為執行為 WAIVE
		pstmt.setString(3,waiveNo); // 特採編號    
        pstmt.setString(4,userID); // 最後更新人員
	    pstmt.setString(5,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料
		 
		sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
        pstmt=con.prepareStatement(sql);   
        pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
        pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
        pstmt.executeUpdate();
        pstmt.close(); 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCWaiveApprovedCode!=null)
		{ 
	  		arrIQC2DWaiveApprovedBean.setArray2DString(null);  //
		}
  	} //若為核定檢驗批為特採(WAIVE)_迄   from status = Conforming to_status = Receiving

  	// 廠主管不同意核准特採檢驗批判退__由物管批退(特採)_起(REJECT)_起 (ACTION=004)
  	if (actionID.equals("004"))
  	{
		//out.println("actionID="+actionID);
    	if (aIQCWaivingCode!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	 		for (int i=0;i<aIQCWaivingCode.length-1;i++)
	 		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCWaivingCode[i][0] || choice[k].equals(aIQCWaivingCode[i][0]))
	    			{ 		
		   				//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
	       				String fndUserID = "";
		   				String fndEmpID = "";
		   				String devStatus = "";
		   				String devMessage = "";	
		   				String rvcGrpID = "0";
		   				boolean errRCVFlag = false;
		   				boolean acceptRcvOK  = true;
           				
						try
		   				{
		      				Statement statement=con.createStatement();
 							String sql1a= "  select TLD.INSPLOT_NO as SELECTFLAG, TLD.INSPLOT_NO ,TLD.RECEIPT_QTY ,TLD.SUPPLIER_LOT_NO,  "+
	   									"   	 TLD.INV_ITEM_ID,TLD.PO_HEADER_ID, TLD.PO_LINE_ID, TLD.PO_LINE_LOCATION_ID,TLD.SHIPMENT_HEADER_ID,TLD.SHIPMENT_LINE_ID,  "+
                						"         MSI.PRIMARY_UOM_CODE UOM_CODE, TLD.UOM, "+
                						"        TLD.EMPLOYEE_ID, TLD.ORGANIZATION_ID, TLD.RECEIPT_NO, TLD.INTERFACE_TRANSACTION_ID,TLD.SHIP_TO_LOCATION_ID,  "+
	   									"		 substr(TLD.INSPLOT_NO,4,2) as INSP_CLASS, TLD.INSPECTOR,RT.TRANSACTION_ID PARN_ID, "+
										"        RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RCV_ID,rcv_interface_groups_s.NEXTVAL GROUP_ID "+
  										"   from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD,RCV_TRANSACTIONS RT ,MTL_SYSTEM_ITEMS MSI "+
										"  where TLD.INSPLOT_NO = '"+inspLotNo+"'  and TLD.LINE_NO = '"+aIQCWaivingCode[i][0]+"' "+
                						"    AND TLD.INV_ITEM_ID = MSI.INVENTORY_ITEM_ID  AND TLD.TO_ORGANIZATION_ID = MSI.ORGANIZATION_ID "+ //20100520 LILING
  										"    and TLD.SHIPMENT_LINE_ID =RT.SHIPMENT_LINE_ID and rt.TRANSACTION_TYPE='RECEIVE' "+
										"    and TLD.LSTATUSID <>'"+getStatusRs.getString("TOSTATUSID") +"' and TLD.LSTATUS <>'"+getStatusRs.getString("STATUSNAME")+"'"; //add by Peggy 20130918
              				ResultSet rs=statement.executeQuery(sql1a);  
             				while (rs.next())
              				{
			    				int rcvGroupID = 0;
								int parentTransID = 0;
								String sInspector = rs.getString("INSPECTOR");
								//if (sInspector==null || sInspector.equals("RU_XIAOHONG")) sInspector = "ZHANG_YUJING";
								if (sInspector==null || sInspector.equals("RU_XIAOHONG") || sInspector.equals("ZHANG_YUJING")) sInspector = "XING_ENFANG"; //ZHANG_YUJING change to XING_ENFANG,20131008 update by Peggy 
								String sqlfnd = "select USER_ID, EMPLOYEE_ID from APPS.FND_USER"+
 						        			" where USER_NAME = UPPER('"+sInspector+"')";
								Statement stateFndId=con.createStatement();
               	 				ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
								if (rsFndId.next())
								{
				  					fndUserID = rsFndId.getString("USER_ID"); 
				  					fndEmpID = rsFndId.getString("EMPLOYEE_ID");
								}
								rsFndId.close();
								stateFndId.close();
				 
								String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle
								if (inspClass!="06" && !inspClass.equals("06"))
								{
			      					// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
				  					String employeeID = "";
				  					if (fndEmpID==null || fndEmpID.equals("")) 
				  					{ 
					 					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
						 				{  
                       						//employeeID = "5675";     // 20100316 Marvie Update : ZHANG_YUJING/5675
											employeeID = "5676";    // 20131008 Peggy Update : XING_ENFANG/5676
					 					}
					 					else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
				  					}
				  					else 
									{
										employeeID = fndEmpID;
				  					}   
									//  20091119 liling 直接丟interface table 不再call package
									String rcvIsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
									   "      LAST_UPDATED_BY, CREATED_BY, EMPLOYEE_ID, "+
									   "     TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
									   "     PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
									   "     TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
									   "     SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
									   "     RECEIPT_SOURCE_CODE) "+
									   " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?) ";
									PreparedStatement pstmtI=con.prepareStatement(rcvIsql);  
									pstmtI.setInt(1,rs.getInt("RCV_ID"));  // INTERFACE_TRANSACTION_ID
									pstmtI.setString(2,fndUserID);  // GROUP_ID  固定丟USER的 USER_ID識別
									pstmtI.setInt(3,rs.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
									pstmtI.setString(4,fndUserID);  //  LAST_UPDATED_BY
									pstmtI.setString(5,fndUserID);  // CREATED_BY
									pstmtI.setString(6,employeeID);  // EMPLOYEE_ID
									pstmtI.setString(7,"REJECT");  // TRANSACTION_TYPE
									pstmtI.setDate(8,receivingDate);  // TRANSACTION_DATE
									pstmtI.setString(9,"PENDING");  // PROCESSING_STATUS_CODE
									pstmtI.setString(10,"BATCH");  // PROCESSING_MODE_CODE
									pstmtI.setString(11,"PENDING");  // TRANSACTION_STATUS_CODE
									pstmtI.setInt(12,rs.getInt("PO_LINE_ID"));  // PO_LINE_ID
									pstmtI.setInt(13,rs.getInt("INV_ITEM_ID"));  // PO_LINE_ID
									pstmtI.setFloat(14,rs.getFloat("RECEIPT_QTY"));  // QUANTITY
									pstmtI.setString(15,rs.getString("UOM"));  // UNIT_OF_MEASURE
									pstmtI.setInt(16,rs.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
									pstmtI.setInt(17,rs.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
									pstmtI.setInt(18,rs.getInt("ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
									pstmtI.setString(19,"Y");  // VALIDATION_FLAG
									pstmtI.setString(20,"RECEIVING");  // DESTINATION_TYPE_CODE
									pstmtI.setInt(21,rs.getInt("SHIP_TO_LOCATION_ID"));  // SHIP_TO_LOCATION_ID
									//pstmtI.setString(22,rs.getString("UOM_CODE"));  // UOM_CODE
									pstmtI.setString(22,rs.getString("UOM"));  //抓PO的UOM,modify by Peggy 20111230
									pstmtI.setInt(23,rs.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
									pstmtI.setInt(24,rs.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
									pstmtI.setString(25,inspLotNo);  // ATTRIBUTE6
									pstmtI.setString(26,rs.getString("SUPPLIER_LOT_NO"));  // VENDOR_LOT_NUM
									pstmtI.setString(27,"VENDOR");   // RECEIPT_SOURCE_CODE
									pstmtI.executeUpdate(); 
									pstmtI.close();
									if (errorMessageHeader==null ) 
									{ 
										errorMessageHeader = "&nbsp;";
									}				
									if (errorMessageLine==null ) 
									{ 
										errorMessageLine = "&nbsp;";
									}	
								} // End of if (inspCLass!="06" && !inspClass.equals("06")) // 判斷不為RMA的才作REJECT 入oracle
							} // End of While			          							 
							rs.close();
							statement.close();	 // 此次檢驗判退的While							 		
						}	// End of try
		      			catch (Exception e) 
		      			{ 
			    			out.println("Exception:"+e.getMessage());
							acceptRcvOK  = false;           // 20100316 Marvie Add : error processing
			  			}		   

						if (!errRCVFlag && acceptRcvOK) // 若成功執行RCV Request及正確入RCV Transaction Interface才執行更新IQC資訊
						{   
		      				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaivingCode[i][0]+"' ";     
						  	pstmt=con.prepareStatement(sql);           
						  	pstmt.setString(1,userID); // 最後更新人員 
						  	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						  	pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
						  	pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態 
						  	pstmt.executeUpdate(); 
						  	pstmt.close();  
			  
			   				sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
               				pstmt=con.prepareStatement(sql);   
               				pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
               				pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
               				pstmt.executeUpdate();
               				pstmt.close(); 			  
			 			} // End of if (!errRCVFlag && acceptRcvOK)
			 
					   	// 處理歷程檔寫入_起	 
						Statement statement=con.createStatement();
						ResultSet rs=null;	 
						statement=con.createStatement();
						rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
						rs.next();
						actionName=rs.getString("ACTIONNAME");
   
					  	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					  	rs.next();
					  	oriStatus=rs.getString("STATUSNAME");   
					  	statement.close();
					  	rs.close();	
			  
					  	int deliveryCount = 0;
					  	Statement stateDeliveryCNT=con.createStatement(); 
					  	ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCWaivingCode[i][0]+"' ");
					  	if (rsDeliveryCNT.next())
					  	{
							deliveryCount = rsDeliveryCNT.getInt(1);
					  	}
					  	rsDeliveryCNT.close();
					  	stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			                    " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
              			PreparedStatement historystmt=con.prepareStatement(historySql);   
              			historystmt.setString(1,inspLotNo); 
			  			historystmt.setString(2,aIQCWaivingCode[i][0]);  // Line_No
              			historystmt.setString(3,fromStatusID); 
              			historystmt.setString(4,oriStatus); //寫入status名稱
              			historystmt.setString(5,actionID); 
              			historystmt.setString(6,actionName);
			  			historystmt.setString(7,UserName);
			  			historystmt.setString(8,dateBean.getYearMonthDay()); 
              			historystmt.setString(9,dateBean.getHourMinuteSecond()); 
			  			historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              			historystmt.setString(11,aIQCWaivingCode[i][7]); // Comments
			  			historystmt.setInt(12,deliveryCount);		      
              			historystmt.executeUpdate(); 
              			historystmt.close();   
		    			// 處理歷程檔寫入_迄 
					} // End of if (choice[k]==aIQCWaiveApprovedCode[i][0] || choice[k].equals(aIQCWaiveApprovedCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
     		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCWaiveApprovedCode!=null)  
	    // 寄送 E-Mail_起   -----------------> 送給物管人員確認是否為特採項目
		if (sendMailOption!=null && sendMailOption.equals("YES"))
        {               
	    	Statement stateList=con.createStatement();
			String sqlList = "select DISTINCT a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a "+
			                 " where upper(a.USERNAME) in (select upper(USER_NAME) from ORADDMAN.TSC_WAREHOUSE_USER "+
			                 "   where TSC_DEPT_ID = 'YEW' and STOCK_CODE in ('00','01') and RECEPT_EMAIL = 'Y' ) ";
            ResultSet rsList=stateList.executeQuery(sqlList);
	        while (rsList.next())
	        {         
            	sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsList.getString("USERMAIL"));		        
                sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統物管同意不合格檢驗批判退通知"));                  
		        sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:物管同意不合格檢驗批判退-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotReturningPage.jsp?INSPLOTNO="+inspLotNo+"&LSTATUSID=024");//				   				   			   
                sendMailBean.sendMail();
	        } //While (rsList.next())
	        rsList.close();
	        stateList.close();	 
				
			// 通知採購人員批退訊息              
			Statement stateListPur=con.createStatement();
			ResultSet rsListPur=stateListPur.executeQuery("select EMAIL_ADDRESS, USER_NAME from FND_USER where USER_NAME in ('SONG_CHUNPING', 'LIU_RONGHAI', 'ZHANG_XIA' ,'PANG_CAIHONG') ");	
			while (rsListPur.next())									 
			{
				sendMailBean.setMailHost(mailHost);
                sendMailBean.setReception(rsListPur.getString("EMAIL_ADDRESS"));		        
            	sendMailBean.setFrom(UserName);   	 	 
                sendMailBean.setSubject(CodeUtil.unicodeToBig5("IQC 檢驗系統不合格檢驗批判退通知"));                  
		        sendMailBean.setUrlName("Dear "+rsListPur.getString("USER_NAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自IQC品管檢驗系統的郵件:不合格檢驗批判退通知-檢驗批單號("+inspLotNo+")"));   	 
                sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSIQCInspectLotClosedPage.jsp?INSPLOTNO="+inspLotNo);//				   				  			   
                sendMailBean.sendMail();
			}
	        rsListPur.close();
			stateListPur.close();
	    } // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
	    // 寄送 E-Mail_迄      ----------------------> 送給物管人員確認是否為特採項目
	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set RESULT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	         "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql);     
		pstmt.setString(1,"REJECT"); // 檢驗不合格批退   
        pstmt.setString(2,userID); // 最後更新人員
	    pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料		 
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
	    if (aIQCWaivingCode!=null)
	    { 
	    	arrIQC2DWaivingBean.setArray2DString(null); 
	    }
  	} //若為工廠交期確認中(decode(AGREE)REJECT)_迄
  
	//若為倉管允收入庫確認(RECEIVE)_起 (ACTION=018) Oracle Receiving
  	if (actionID.equals("018"))  
  	{ 		 
		String fndUserID = "";
	 	String fndEmpID = "";
		String sqlfnd = " select USER_ID, EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B "+
						 " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
		Statement stateFndId=con.createStatement();
		ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
		if (rsFndId.next())
		{
			fndUserID = rsFndId.getString("USER_ID"); 
			fndEmpID = rsFndId.getString("EMPLOYEE_ID");
		}
		rsFndId.close();
		stateFndId.close();
	 	//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄					 
	 	
		if (aIQCReceivingBean!=null) // 判斷該次有分派細項才進行明細表更新
     	{
	  		for (int i=0;i<aIQCReceivingBean.length-1;i++)
	  		{
	   			for (int k=0;k<=choice.length-1;k++)    
       			{
		    		// 判斷被Check 的Line 才執行指派作業
	    			if (choice[k]==aIQCReceivingBean[i][0] || choice[k].equals(aIQCReceivingBean[i][0]))
	    			{ 	 
						String devStatus = "";
					   	String devMessage = "";	
					   	String rvcGrpID = "0";
					   	respID = "";
		   				//先取得欲執行產生PO之Responsibility ID_起
	          			Statement stateResp=con.createStatement();	   
	          			ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME = 'YEW_PO_SEMI_SU' "); 
	          			if (rsResp.next())
	          			{
	           				respID = rsResp.getString("RESPONSIBILITY_ID");
	          			} 
						else 
						{
	                  		respID = "50761"; // 找不到則預設 --> YEW PO SEMI Super User 預設
	                 	}
			         	rsResp.close();
			         	stateResp.close();	  	
	       				
						//先取得欲執行產生PO之Responsibility ID_迄	
		   				boolean errRCVFlag = false;	
           				try
		  	 			{				   
		      				Statement statement=con.createStatement();
			  				String sql1a=  " select INSPLOT_NO as SELECTFLAG, INSPLOT_NO ,RECEIPT_QTY ,SUPPLIER_LOT_NO, INV_ITEM_ID, UOM,  "+
			                        " PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIPMENT_LINE_ID,  "+
			                        " EMPLOYEE_ID, ORGANIZATION_ID, RECEIPT_NO, INTERFACE_TRANSACTION_ID, "+
									" substr(INSPLOT_NO,4,2) as INSP_CLASS, SUBINVENTORY, PART_TRANS_FLAG, RESULT "+
									", TO_ORGANIZATION_ID ,EXPIRATION_DATE ,INSPECT_REMARK "+  //20170321 liling add 
                            		" from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL "+
                            		" where INSPLOT_NO = '"+inspLotNo+"' "+
									" and LINE_NO = '"+aIQCReceivingBean[i][0]+"' ";
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next())
              				{   
			     				int rcvGroupID = 0;
				 				int parentTransID = 0;	
				 				String inspClass = rs.getString("INSP_CLASS"); // 檢驗類別 若 = 06 則為 RMA 銷退,不作 ACCEPT入Oracle

				 				if (inspClass!="06" && !inspClass.equals("06"))
				 				{ 			
			       					try
				   					{   
										//找原ACCEPT 的 INTERFACE TRANSACTION ID
										Statement stateITID=con.createStatement();
										String sql1b=  " select INTERFACE_TRANSACTION_ID "+
													   " from RCV_TRANSACTIONS "+
													   " where TRANSACTION_TYPE = 'ACCEPT' and INTERFACE_SOURCE_CODE = 'RCV' and DESTINATION_TYPE_CODE = 'RECEIVING' "+
													   "   and PO_HEADER_ID = "+rs.getInt("PO_HEADER_ID")+" and PO_LINE_ID = "+rs.getInt("PO_LINE_ID")+" "+
													   "   and PO_LINE_LOCATION_ID = "+rs.getInt("PO_LINE_LOCATION_ID")+" "+
								   					   "   and SHIPMENT_LINE_ID="+rs.getInt("SHIPMENT_LINE_ID")+"  ";
										ResultSet rsITID=stateITID.executeQuery(sql1b);	
										if (rsITID.next())
										{
					    					parentTransID = rsITID.getInt(1); 
										}
										rsITID.close();
										stateITID.close();		   
				 					} //end of try
                 					catch (Exception e)
                 					{
	                 					e.printStackTrace();
                     					out.println(e.getMessage());
                 					}//end of catch    	
									String employeeID = "";
									if (fndEmpID==null || fndEmpID.equals("")) 
									{ 
					  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
					  					{  
					     					employeeID = "5995";
					  					}
					  					else 
										{  
											employeeID = rs.getString("EMPLOYEE_ID");  
										}
									}
									else 
									{
					       				employeeID = fndEmpID;
					     			}   
				 
				 					// 2007/01/12_修正SubInventory 異常起
				 					if (rs.getString("SUBINVENTORY")==null || rs.getString("SUBINVENTORY").equals("") || rs.getString("SUBINVENTORY").equals("null"))
				 					{  // 若是未指定 Line 的 入庫倉別, 則以 Header 的 subInventory 為主
				    					subInventory = subInventory;
										if (subInventory==null || subInventory.equals("") || subInventory.equals("null"))
										{
					   				%>
					     <script language="javascript">
						    alert("您的處理項次內含有未設定入庫倉別的內容\n    該筆資料將不執行入庫作業");
						 </script>
					   				<%
					   						out.println("<strong><font color='#FF0000'>項次"+aIQCReceivingBean[i][0]+"未執行收料入庫作業<font></strong><BR>");
										}
				 					} 
									else 
									{ // 否則,以個別給 Line 的 入庫倉別為值
				          				subInventory = rs.getString("SUBINVENTORY"); 
				        			}
				 					// 2007/01/12_修正SubInventory 異常迄
				 		   
									CallableStatement cs3 = con.prepareCall("{call TSIQC_RCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			
									cs3.setString(1,inspLotNo);  //out.println("inspLotNo="+inspLotNo);                  //檢驗批單號
									cs3.setDate(2,receivingDate); //out.println("receivingDate="+receivingDate);    //收料日期
									cs3.setInt(3,Integer.parseInt(fndUserID));     // FND_USER ID    
									cs3.setInt(4,Integer.parseInt(rs.getString("PO_HEADER_ID")));  
									cs3.setInt(5,Integer.parseInt(rs.getString("PO_LINE_ID")));  
									cs3.setFloat(6,rs.getFloat("RECEIPT_QTY"));  
									cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
									cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
									cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
									cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
									cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
									cs3.setInt(12,Integer.parseInt(rs.getString("PO_LINE_LOCATION_ID")));   //PO_LOCATION_LINE_ID
									cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID
									// 20100409 Marvie Update : organization_id change
									//cs3.setInt(14,Integer.parseInt(rs.getString("ORGANIZATION_ID")));					
									cs3.setInt(14,Integer.parseInt(rs.getString("TO_ORGANIZATION_ID")));   //ORGANIZATION_ID					
									cs3.setString(15,subInventory);                      // SUB_INVENTORY	DELIVER一定要給
									cs3.setString(16,rs.getString("SUPPLIER_LOT_NO"));   // SULLPIER_LOT_NO	
									cs3.setString(17,aIQCReceivingBean[i][7]);      // COMMENTS aIQCReceivingBean[i][7]	
									cs3.setString(18,rs.getString("RECEIPT_NO"));   // LINE查詢的_RECEIPT_NO	
									cs3.setString(19,"DELIVER");      // 允收入庫
									cs3.setString(20,"ACCEPT");      // 上一個父異動類型為ACCEPT
									cs3.setString(21,"INVENTORY");    // 此次的DESTNATION TYPE CODE為 INVENTORY
									cs3.setInt(22,parentTransID);     //ACCEPT 類型的原Interface Transaction ID	
									cs3.setInt(23,rs.getInt("SHIPMENT_LINE_ID"));     //ACCEPT 類型的原Interface Transaction IDSHIPMENT_LINE_ID	      			     			     
									cs3.execute();
									statusMessageHeader = cs3.getString(7);	             
									statusMessageLine = cs3.getString(8);
									headerID = cs3.getInt(9);   // 把第二次的更新 Header ID 取到
									errorMessageHeader = cs3.getString(10);	             
									errorMessageLine = cs3.getString(11);				 
									cs3.close();		
				 
				  					int currTrIDSeq = 0;
				  					String sqlTrSeq = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS_INTERFACE "+
                                    					" where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='DELIVER' "+
														"   and PROCESSING_STATUS_CODE ='PENDING' ";
				  					Statement stateTrSeq=con.createStatement();
                  					ResultSet rsTrSeq=stateTrSeq.executeQuery(sqlTrSeq);
				  					if (rsTrSeq.next())
				  					{
				   						currTrIDSeq = rsTrSeq.getInt(1);
				  					}
				  					rsTrSeq.close();
				 	 				stateTrSeq.close();
			
									if (rs.getString("SUPPLIER_LOT_NO")!=null && !rs.getString("SUPPLIER_LOT_NO").equals("") && !rs.getString("SUPPLIER_LOT_NO").equals("null"))
									{ // Vndor Lot No 欄位不為空值表示為批號控管項目,故寫LOT 號
              							String expirationDate =rs.getString("EXPIRATION_DATE");   //20110120 liling
			  							String sqlLotCrtl = "select count(LOT_CONTROL_CODE) from MTL_SYSTEM_ITEMS"+
		                          							" where ORGANIZATION_ID = "+rs.getString("TO_ORGANIZATION_ID")+
				  		            						" and INVENTORY_ITEM_ID ="+rs.getString("INV_ITEM_ID")+
								   							 " and LOT_CONTROL_CODE = 2";
              							Statement stateLotCrtl=con.createStatement();
              							ResultSet rsLotCrtl=stateLotCrtl.executeQuery(sqlLotCrtl);
			  							if (rsLotCrtl.next() && rsLotCrtl.getInt(1)>0)
			  							{	
										  
										  
										   String sqlInsMMT ="";	
										   
										   qcRemark = 	rs.getString("INSPECT_REMARK");  //20170321 把qc備註加至lot attriubte3 ,以供後續M1/M2晶片庫存資訊顯示										    
										   if (  qcRemark ==null || qcRemark.equals("")  || qcRemark.equals("null"))
                                           {  
				 							// 2006/10/24依 Lot Controlled料項需寫入mtl_transaction_lots_temp_起
				  							 sqlInsMMT = "insert into MTL_TRANSACTION_LOTS_TEMP( "+
                                     						 "   last_update_date, last_updated_by , creation_date , created_by ,"+
                                     						 "   last_update_login, transaction_quantity, primary_quantity, lot_number, "+
									  						 "   product_code, product_transaction_id, transaction_temp_id, LOT_EXPIRATION_DATE ) "+  //20110120 liling add LOT_EXPIRATION_DATE 
									  						 " VALUES(SYSDATE, ?, SYSDATE, ?, -1, ?, ?, ?, "+
									  						 " 'RCV', ?, ? ,to_date("+expirationDate+",'yyyy/mm/dd')) ";
										        
										    }
										    else   //qc備註非空值要寫入ATTRIBUTE3
											{		
                                              sqlInsMMT = "insert into MTL_TRANSACTION_LOTS_TEMP( "+
                                     						 "   last_update_date, last_updated_by , creation_date , created_by ,"+
                                     						 "   last_update_login, transaction_quantity, primary_quantity, lot_number, "+
									  						 "   product_code, product_transaction_id, transaction_temp_id, LOT_EXPIRATION_DATE,ATTRIBUTE3 ) "+  //20110120 liling add LOT_EXPIRATION_DATE 
									  						 " VALUES(SYSDATE, ?, SYSDATE, ?, -1, ?, ?, ?, "+
									  						 " 'RCV', ?, ? ,to_date("+expirationDate+",'yyyy/mm/dd'),'"+qcRemark+"') ";											
											}																									 
                  							PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
										  	mmtStmt.setInt(1,Integer.parseInt(fndUserID));   // last_updated_by 
										  	mmtStmt.setInt(2,Integer.parseInt(fndUserID));   // created_by 
										  	mmtStmt.setFloat(3,rs.getFloat("RECEIPT_QTY"));      // transaction_quantity 
										  	mmtStmt.setFloat(4,Float.parseFloat(aIQCReceivingBean[i][10]));	  // primary_quantity  
										  	mmtStmt.setString(5,rs.getString("SUPPLIER_LOT_NO"));	      // VENDOR_LOT_NUMBER 
										  	mmtStmt.setInt(6,currTrIDSeq);	      // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
										  	mmtStmt.setInt(7,currTrIDSeq);	      // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
										  	mmtStmt.executeUpdate();
										  	mmtStmt.close();
										   
											 												 
				 
									 		// 2006/10/24依 Lot Controlled料項需寫入rcv_lots_interface _起
									  		String sqlInsRCVLOT = "insert into RCV_LOTS_INTERFACE( last_update_date , "+
															"  last_updated_by , creation_date , created_by , last_update_login , "+
															"  quantity , primary_quantity , lot_num ,transaction_date, interface_transaction_id,EXPIRATION_DATE ) "+ //20110120 liling add EXPIRATION_DATE 
															" VALUES(SYSDATE , ?, SYSDATE, ?, -1, "+
															" ?, ?, ?, SYSDATE, ?,to_date("+expirationDate+",'yyyy/mm/dd')) ";
				  							PreparedStatement rcvLotStmt=con.prepareStatement(sqlInsRCVLOT); 	
		          							rcvLotStmt.setInt(1,Integer.parseInt(fndUserID));   // last_updated_by 
		          							rcvLotStmt.setInt(2,Integer.parseInt(fndUserID));   // created_by 
		          							rcvLotStmt.setFloat(3,rs.getFloat("RECEIPT_QTY"));      // transaction_quantity 
										    rcvLotStmt.setFloat(4,Float.parseFloat(aIQCReceivingBean[i][10]));	    // primary_quantity  
										    rcvLotStmt.setString(5,rs.getString("SUPPLIER_LOT_NO"));	      // VENDOR_LOT_NUMBER 
										    rcvLotStmt.setInt(6,currTrIDSeq);	           // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
										    rcvLotStmt.executeUpdate();
										    rcvLotStmt.close();				
			  							} // if (rsLotCrtl.next() && rsLotCrtl.getInt(1)>0) 料號主檔內設定為lot control
									} // End of if (rs.getString("SUPPLIER_LOT_NO")!=null && !rs.getString("SUPPLIER_LOT_NO").equals("") && !rs.getString("SUPPLIER_LOT_NO").equals("null"))
				 	  
	             					if (errorMessageHeader==null ) 
				 					{  
										errorMessageHeader = "&nbsp;";
				 
				    					Statement stateRvcGrpID=con.createStatement();				
				    					String sqlRvcGrpID=  " select max(GROUP_ID) "+
                                         						" from RCV_TRANSACTIONS_INTERFACE "+
                                         						" where ATTRIBUTE6 = '"+inspLotNo+"' AND LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='DELIVER' "+
										 						"   and PROCESSING_STATUS_CODE = 'PENDING' ";
										ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
										if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
										rsRvcGrpID.close();
										stateRvcGrpID.close();
				 					}				
				 					if (errorMessageLine==null ) 
				 					{ 
										errorMessageLine = "&nbsp;";
									}	
				 
				 					if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;") ) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
				 					{					    
					     				errorMessageHeader = "&nbsp;"; 
						 				errorMessageLine = "&nbsp;"; 	
						       			CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
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
									   	out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
							   			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
							   			out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
							   			try 
										{
							          		Statement stateError=con.createStatement();
			                          		String sqlError= " select INTERFACE_TRANSACTION_ID "+			                         
                                                       " from RCV_TRANSACTIONS_INTERFACE "+
                                                       " where INTERFACE_TRANSACTION_ID = "+currTrIDSeq+
													   "   and ( PROCESSING_STATUS_CODE='ERROR' or TRANSACTION_STATUS_CODE='ERROR' ) ";	
                                      		ResultSet rsError=stateError.executeQuery(sqlError);	  
				                      		if (!rsError.next()) // 不存在 ERROR 的資料
				                      		{ 									 
							            		// 成功..則更新原Receiving Attribute6 = 檢驗批單號_起
									    		sql="update RCV_TRANSACTIONS set ATTRIBUTE6=? "+
	                                        		"where INTERFACE_TRANSACTION_ID='"+rs.getString("INTERFACE_TRANSACTION_ID")+"' "+
										    		"and TRANSACTION_TYPE in ('RECEIVE', 'DELIVER') and USER_ENTERED_FLAG = 'Y' and INTERFACE_SOURCE_CODE = 'RCV' "+
										    		"and SOURCE_DOCUMENT_CODE = 'PO' ";     
												pstmt=con.prepareStatement(sql);  
												pstmt.setString(1,inspLotNo); // Attribute6 作為新增依 Receiving 排除 		                               
												pstmt.executeUpdate(); 
												pstmt.close();  	
												errRCVFlag = false;								  
							           			 // 成功..則更新原Receiving Attribute6 = 檢驗批單號_迄
												out.println("<BR>收料單號(<font color='BLUE'>"+rs.getString("RECEIPT_NO")+"LotNo:"+rs.getString("SUPPLIER_LOT_NO")+"</font>)已成功收料入庫<BR>");
									  		} 
											else 
											{
									        	errRCVFlag = true;
											   	out.println("<BR>收料單號(<font color='BLUE'>"+rs.getString("RECEIPT_NO")+"LotNo:"+rs.getString("SUPPLIER_LOT_NO")+"</font>)入庫異常<BR>");
									        }
				                      		rsError.close();
				                     		stateError.close();	
							       		}// End of try
		                           		catch (Exception e) 
		                           		{ 
											out.println("Exception:"+e.getMessage()); 
										}								   
				      				} 
									else 
									{  
					             		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Request RCV Transaction Fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
					             		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
					        		}		
				   				} // End of if (inspClass!="" && !inspClass.equals("06"))	  
				   				else 
								{				          
						    		try
				            		{
				               			//找原ACCEPT 的 INTERFACE TRANSACTION ID					   
				               			Statement stateITID=con.createStatement();
				               			String sql1b=   " SELECT RT.TRANSACTION_ID, RT.INTERFACE_TRANSACTION_ID as ID,RSH.RECEIPT_NUM ,OOHA.ORDER_NUMBER,RC.CUSTOMER_NAME, "+
						   		       	       "        MSI.SEGMENT1, MSI.INVENTORY_ITEM_ID, MSI.DESCRIPTION, RT.QUANTITY ,RT.UNIT_OF_MEASURE ,RT.TRANSACTION_DATE, "+
									           "		RT.VENDOR_LOT_NUM, RSH.SHIPMENT_HEADER_ID, RSH.CUSTOMER_ID, RSL.SHIPMENT_LINE_ID,RT.SUBINVENTORY, "+
									           "		RT.ORGANIZATION_ID ,RT.SOURCE_DOCUMENT_CODE, RT.UOM_CODE, RT.EMPLOYEE_ID, RT.PRIMARY_QUANTITY, RT.PRIMARY_UNIT_OF_MEASURE, "+
									           "        RSL.TO_ORGANIZATION_ID, RSL.DELIVER_TO_LOCATION_ID, RT.OE_ORDER_HEADER_ID, RT.OE_ORDER_LINE_ID, RT.CUSTOMER_ID, RT.CUSTOMER_SITE_ID "+
									           "   FROM RCV_TRANSACTIONS RT ,RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES  RSL, "+
									           "		OE_ORDER_HEADERS_ALL OOHA,RA_CUSTOMERS  RC ,MTL_SYSTEM_ITEMS MSI "+
						                       "   WHERE  RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID  "+
									           "     AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID       "+
									           "     AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
									           "     AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
									           "	 AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
									           "	 AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  "+
									           "     and RSL.SHIPMENT_LINE_ID="+rs.getInt("SHIPMENT_LINE_ID")+"  "+
									           "     and RT.INTERFACE_TRANSACTION_ID = "+rs.getInt("INTERFACE_TRANSACTION_ID")+" ";
					          			ResultSet rsITID=stateITID.executeQuery(sql1b);	
					          			if (rsITID.next())
					          			{
						    				String sqlRMA=" insert into RCV_TRANSACTIONS_INTERFACE(PARENT_TRANSACTION_ID, INTERFACE_TRANSACTION_ID, GROUP_ID, LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, "+
							             				 "                                        TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE, QUANTITY, UNIT_OF_MEASURE, INTERFACE_SOURCE_CODE, "+
														  "                                        ITEM_ID, UOM_CODE, EMPLOYEE_ID, AUTO_TRANSACT_CODE, PRIMARY_QUANTITY, RECEIPT_SOURCE_CODE, TO_ORGANIZATION_ID, SOURCE_DOCUMENT_CODE, DESTINATION_TYPE_CODE, DELIVER_TO_LOCATION_ID, "+
														  "                                        SUBINVENTORY, EXPECTED_RECEIPT_DATE, OE_ORDER_HEADER_ID, OE_ORDER_LINE_ID, CUSTOMER_ID, CUSTOMER_SITE_ID, VALIDATION_FLAG, ATTRIBUTE6 ) "+
														  "         values( "+rsITID.getInt("TRANSACTION_ID")+", RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL, RCV_INTERFACE_GROUPS_S.NEXTVAL, SYSDATE, "+fndUserID+", SYSDATE, "+fndUserID+", "+
														  "                 'DELIVER', SYSDATE, 'PENDING', 'BATCH', 'PENDING', "+rsITID.getFloat("QUANTITY")+", '"+rsITID.getString("UNIT_OF_MEASURE")+"', 'RCV', "+
														  "                 "+rsITID.getInt("INVENTORY_ITEM_ID")+", '"+rsITID.getString("UOM_CODE")+"', "+rsITID.getString("EMPLOYEE_ID")+", 'DELIVER', "+rsITID.getFloat("PRIMARY_QUANTITY")+", 'CUSTOMER', "+rsITID.getInt("TO_ORGANIZATION_ID")+", 'RMA', 'INVENTORY', "+rsITID.getInt("DELIVER_TO_LOCATION_ID")+",  "+
														  "                 '"+subInventory+"', SYSDATE, "+rsITID.getInt("OE_ORDER_HEADER_ID")+", "+rsITID.getInt("OE_ORDER_LINE_ID")+", "+rsITID.getInt("CUSTOMER_ID")+","+rsITID.getInt("CUSTOMER_SITE_ID")+", 'Y', '"+inspLotNo+"' ) ";										      
						    				PreparedStatement pRMAstmt=con.prepareStatement(sqlRMA);  			                                             
                            				pRMAstmt.executeUpdate(); 
                            				pRMAstmt.close();  	
							    			int currTrIDSeq = 0;
				                			String sqlTrSeq = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS_INTERFACE "+
                                            			      " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='DELIVER' "+
									              			  "    and PROCESSING_STATUS_CODE ='PENDING' ";
				                			Statement stateTrSeq=con.createStatement();
                               				ResultSet rsTrSeq=stateTrSeq.executeQuery(sqlTrSeq);
				                			if (rsTrSeq.next())
				                			{
				                   				currTrIDSeq = rsTrSeq.getInt(1);
				                			}
				                			rsTrSeq.close();
				                			stateTrSeq.close();
			     							if (rsITID.getString("VENDOR_LOT_NUM")!=null && !rsITID.getString("VENDOR_LOT_NUM").equals("") && !rsITID.getString("VENDOR_LOT_NUM").equals("null"))
			     							{   // Vndor Lot No 欄位不為空值表示為批號控管項目,故寫LOT 號
					   							String sqlLotCrtl = " select count(LOT_CONTROL_CODE) from MTL_SYSTEM_ITEMS "+		  
		                                   					"  where ORGANIZATION_ID = "+rsITID.getString("ORGANIZATION_ID")+" "+
				  		                   					"    and INVENTORY_ITEM_ID ="+rsITID.getString("INVENTORY_ITEM_ID")+" "+
								         					  "    and LOT_CONTROL_CODE = 2 ";			  	  
                       							Statement stateLotCrtl=con.createStatement();
                       							ResultSet rsLotCrtl=stateLotCrtl.executeQuery(sqlLotCrtl);
			           							if (rsLotCrtl.next() && rsLotCrtl.getInt(1)>0)
			          							{														
				                 					String sqlInsMMT = "insert into MTL_TRANSACTION_LOTS_TEMP( "+
                                                    "   last_update_date, last_updated_by , creation_date , created_by ,"+
                                                    "   last_update_login, transaction_quantity, primary_quantity, lot_number, "+
									                "   product_code, product_transaction_id, transaction_temp_id ) "+  
									                " VALUES(SYSDATE, ?, SYSDATE, ?, -1, ?, ?, ?, "+
									                " 'RCV', ?, ? ) "; 
                                 					PreparedStatement mmtStmt=con.prepareStatement(sqlInsMMT); 	
		                         					mmtStmt.setInt(1,Integer.parseInt(fndUserID));   // last_updated_by 
		                         					mmtStmt.setInt(2,Integer.parseInt(fndUserID));   // created_by 
		                         					mmtStmt.setFloat(3,Float.parseFloat(rsITID.getString("QUANTITY")));      // transaction_quantity  
		                         					mmtStmt.setFloat(4,Float.parseFloat( aIQCReceivingBean[i][10]));	  // primary_quantity  
		                         					mmtStmt.setString(5,rsITID.getString("VENDOR_LOT_NUM"));	      // VENDOR_LOT_NUMBER 
				                 					mmtStmt.setInt(6,currTrIDSeq);	      // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
				                 					mmtStmt.setInt(7,currTrIDSeq);	      // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
                                			 		mmtStmt.executeUpdate();
                                 					mmtStmt.close();					 
				                 					// 2006/10/24依 Lot Controlled料項需寫入mtl_transaction_lots_temp_迄						  
						 
				                 					String sqlInsRCVLOT = "insert into RCV_LOTS_INTERFACE( last_update_date , "+
				                                       "  last_updated_by , creation_date , created_by , last_update_login , "+
				                                       "  quantity , primary_quantity , lot_num ,transaction_date, interface_transaction_id ) "+
									            	   " VALUES(SYSDATE , ?, SYSDATE, ?, -1, "+
									                   " ?, ?, ?, SYSDATE, ?) ";
				                 					PreparedStatement rcvLotStmt=con.prepareStatement(sqlInsRCVLOT); 	
		                         					rcvLotStmt.setInt(1,Integer.parseInt(fndUserID));   // last_updated_by 
		                         					rcvLotStmt.setInt(2,Integer.parseInt(fndUserID));   // created_by 
		                         					rcvLotStmt.setFloat(3,Float.parseFloat(rsITID.getString("QUANTITY")));      // transaction_quantity  
  								 					rcvLotStmt.setFloat(4,Float.parseFloat(aIQCReceivingBean[i][10]));	    // primary_quantity 
		                         					rcvLotStmt.setString(5,rsITID.getString("VENDOR_LOT_NUM"));	      // VENDOR_LOT_NUMBER 
				                 					rcvLotStmt.setInt(6,currTrIDSeq);	           // RCV_TRANSACTIONS_INTERFACE_S.CURRVAL
                                 					rcvLotStmt.executeUpdate();
                                					rcvLotStmt.close();	
					    						} // end of if (rsLotCrtl.next() && rsLotCrtl.getInt(1)>0)			      			 	   
				     						} // End of if // Vndor Lot No 欄位不為空值表示為批號控管項目,故寫LOT 號	 
			    			  
						    				Statement stateRvcGrpID=con.createStatement();				
				            				String sqlRvcGrpID=  " select max(GROUP_ID) "+
                                                 " from RCV_TRANSACTIONS_INTERFACE "+
                                                 " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' and TRANSACTION_TYPE ='DELIVER' "+
									              //"   and INTERFACE_TRANSACTION_ID = "+currTrIDSeq+" "+
										         "  and PROCESSING_STATUS_CODE = 'PENDING' ";
					        				ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
					        				if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
					        				rsRvcGrpID.close();
					        				stateRvcGrpID.close();
						  
						       				CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
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
							   	
							   				out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
							   				out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
							   				out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");						  
						    			} // End of if (rsITID.next())
					        			rsITID.close();
					        			stateITID.close();
					     			} //end of try
                         			catch (Exception e)
                         			{
	                         			e.printStackTrace();
                             			out.println(e.getMessage());
                         			}//end of catch    		   
				    			} // End of else (inspClass=="06")	 
			
			 					if (inspClass!="06" && !inspClass.equals("06")) // 不為RMA類型的收料,作重分轉出轉入_起
			 					{
			   						String classCodeID = inspLotNo.substring(3,5); 
			   						if (classCodeID=="01" || classCodeID.equals("01")) // 晶片(粒)作重分轉出入
			  						{
							           //#########################====== 購買晶粒料號,自動執行重分轉出/入 起 =============   liling   
			    						try
			    						{   
											//判斷要有入庫才執行重分轉出入  2007/03/21 liling
										 	String deliveryFlag="N";
										 	String sqlTxnIda =" select TRANSACTION_ID from RCV_TRANSACTIONS where attribute6 = '"+inspLotNo+"' "+
														  "    and TRANSACTION_TYPE='DELIVER' and GROUP_ID = "+rvcGrpID+" ";
											Statement stateTxnIda=con.createStatement();
											ResultSet rsTxnIda=stateTxnIda.executeQuery(sqlTxnIda);
				 							if (rsTxnIda.next())
				  							{  
												deliveryFlag = "Y";  
											}
				 							rsTxnIda.close();
				 							stateTxnIda.close();

											String partTransFlag=rs.getString("PART_TRANS_FLAG");
											String assyItemId=aIQCReceivingBean[i][9];
											String invItemId=rs.getString("INV_ITEM_ID");
											String supplierLotNo=rs.getString("SUPPLIER_LOT_NO");
											String receiptUom=rs.getString("UOM");
											String groupId = "";
				 
				 							if (supplierLotNo==null || supplierLotNo.equals("null")) 
				 							{  
												supplierLotNo=""; 
											}
			      							if ((partTransFlag == "Y"|| partTransFlag.equals("Y")) && (deliveryFlag == "Y"|| deliveryFlag.equals("Y")))  //需執行重分之晶粒
			      							{   
				    							try
					 							{					 
					 	  							String partInId="",partOutId="";
						  							String sqlTxnId = "SELECT A.DISPOSITION_ID PART_IN ,B.DISPOSITION_ID PART_OUT   "+
 																	"  FROM APPS.MTL_GENERIC_DISPOSITIONS A, APPS.MTL_GENERIC_DISPOSITIONS B "+
 																	" WHERE A.ORGANIZATION_ID="+rs.getString("ORGANIZATION_ID")+" AND B.ORGANIZATION_ID="+rs.getString("ORGANIZATION_ID")+" "+
   										   							 "   AND A.SEGMENT1='重分轉入'  AND B.SEGMENT1='重分轉出' ";
						  							Statement stateTxnId=con.createStatement();
            		     							ResultSet rsTxnId=stateTxnId.executeQuery(sqlTxnId);
						  							if (rsTxnId.next())
						  							{
						     							partInId = rsTxnId.getString(1);  //轉入
						     							partOutId = rsTxnId.getString(2);  //轉出
						  							}
						  							rsTxnId.close();
						  							stateTxnId.close();
		              								Statement stateMSEQ=con.createStatement();	             
		              								ResultSet rsMSEQ=stateMSEQ.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
					  								if (rsMSEQ.next()) groupId = rsMSEQ.getString(1);
					  								rsMSEQ.close();
					  								stateMSEQ.close();
				  
					  								String sqlInsMMT1 = " Insert into mtl_transactions_interface(transaction_interface_id,process_flag,transaction_mode ,lock_flag , "+
           																"			transaction_uom,transaction_date,source_code,source_line_id,source_header_id, "+
		   																"			transaction_source_name,transaction_source_id , "+
   		   																"			last_update_date,last_updated_by,creation_date ,created_by ,inventory_item_id ,subinventory_code, "+
		   																"			organization_id,transaction_quantity,primary_quantity,transaction_type_id ,transaction_reference,vendor_lot_number "+
																		"           ) "+
										    							"   VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 1, 3, 2 ,"+     // PROCESS_FLAG, --1 - Yes ,TRANSACTION_MODE,2: Concurrent ,3: Background
										   							 	" 			?,sysdate,?,?,?,?,?,sysdate,?,sysdate,?,?,?,?,?,?,?,?,?) "; // By Kerwin Add for Process Interface
											
					  								PreparedStatement mmtStmt1=con.prepareStatement(sqlInsMMT1); 	
					  								mmtStmt1.setString(1,receiptUom);   					// Stransaction_uom
													mmtStmt1.setString(2,invItemId);	                    // source_code 
													mmtStmt1.setInt(3,Integer.parseInt(invItemId));	    // source_line_id  
													mmtStmt1.setInt(4,Integer.parseInt(invItemId));	    // source_header_id  
													mmtStmt1.setString(5,"重分轉出");	      			// transaction_source_name  
													mmtStmt1.setInt(6,Integer.parseInt(partOutId));    						 	// transaction_source_id
													mmtStmt1.setInt(7,Integer.parseInt(fndUserID));		     // last_updated_by
													mmtStmt1.setInt(8,Integer.parseInt(fndUserID));	  		 // created_by
													mmtStmt1.setInt(9,Integer.parseInt(invItemId));	 			 // invItemId
						  							if (subInventory==null || subInventory.equals("")) subInventory="00";
													mmtStmt1.setString(10,subInventory);    							// subinventory
													mmtStmt1.setInt(11,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   // ORGANIZATION_ID
													mmtStmt1.setFloat(12,0-rs.getFloat("RECEIPT_QTY"));     //RECEIPT_QTY
													mmtStmt1.setFloat(13,0-Float.parseFloat(aIQCReceivingBean[i][10]));     //RECEIPT_QTY primaryQty
													mmtStmt1.setInt(14,109);                                //transaction_type_id //注意上線後要確認
													mmtStmt1.setString(15,inspLotNo+aIQCReceivingBean[i][0]);                //transaction_reference IQCNO+LINENO
													mmtStmt1.setString(16,supplierLotNo);                //transaction_reference IQCNO+LINENO
													mmtStmt1.executeUpdate();
													mmtStmt1.close();	
		  
		  			  								String sqlInsMMTLot = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
		                         				  			"  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
								  				 			 "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ) "+ 
								  				  				"  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?) ";
	       			 								PreparedStatement mmtLotStmt=con.prepareStatement(sqlInsMMTLot); 
													mmtLotStmt.setString(1,supplierLotNo);    // LOT_NUMBER
													mmtLotStmt.setFloat(2,rs.getFloat("RECEIPT_QTY"));	   // TRANSACTION_QUANTITY
													mmtLotStmt.setFloat(3,Float.parseFloat(aIQCReceivingBean[i][10]));	   // PRIMARY_QUANTITY 
													mmtLotStmt.setInt(4,Integer.parseInt(fndUserID));	       // LAST_UPDATED_BY 								 
													mmtLotStmt.setInt(5,Integer.parseInt(fndUserID));	       // CREATED_BY 
													mmtLotStmt.executeUpdate();
													mmtLotStmt.close();
						
													// -- 取此次重分轉入  MMT 的Transaction ID 作為Group ID
													Statement stateMSEQ2=con.createStatement();	             
													ResultSet rsMSEQ2=stateMSEQ2.executeQuery("select MTL_MATERIAL_TRANSACTIONS_S.NEXTVAL from dual");
													if (rsMSEQ2.next()) groupId = rsMSEQ2.getString(1);
													rsMSEQ2.close();
													stateMSEQ2.close();
				  
													String sqlInsMMT2 = " Insert into mtl_transactions_interface(transaction_interface_id,process_flag,transaction_mode ,lock_flag , "+
																		"			transaction_uom,transaction_date,source_code,source_line_id,source_header_id, "+
																		"			transaction_source_name,transaction_source_id , "+
																		"			last_update_date,last_updated_by,creation_date ,created_by ,inventory_item_id ,subinventory_code, "+
																		"			organization_id,transaction_quantity,primary_quantity,transaction_type_id ,transaction_reference,vendor_lot_number "+
																		"           ) "+
																		"   VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL, 1, 3, 2 ,"+     // PROCESS_FLAG, --1 - Yes ,TRANSACTION_MODE,2: Concurrent ,3: Background
																		" 			?,sysdate,?,?,?,?,?,sysdate,?,sysdate,?,?,?,?,?,?,?,?,?) "; // Add By Kerwin for Process Interface
													PreparedStatement mmtStmt2=con.prepareStatement(sqlInsMMT2); 	
													mmtStmt2.setString(1,receiptUom);   					// Stransaction_uom
													//mmtStmt2.setDate(2,receivingDate);					// Transaction date
													mmtStmt2.setString(2,assyItemId);	                    // source_code 
													mmtStmt2.setInt(3,Integer.parseInt(assyItemId));	    // source_line_id  
													mmtStmt2.setInt(4,Integer.parseInt(assyItemId));	    // source_header_id  						
													mmtStmt2.setString(5,"重分轉入");	      			// transaction_source_name  
													mmtStmt2.setInt(6,Integer.parseInt(partInId));    			// transaction_source_id    
													mmtStmt2.setInt(7,Integer.parseInt(fndUserID));		     // last_updated_by
													mmtStmt2.setInt(8,Integer.parseInt(fndUserID));	  		 // created_by
													mmtStmt2.setInt(9,Integer.parseInt(assyItemId));	 			 // invItemId
													 if (subInventory==null || subInventory.equals("")) subInventory="00";
													mmtStmt2.setString(10,subInventory);    							// subinventory
													mmtStmt2.setInt(11,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   // ORGANIZATION_ID
													mmtStmt2.setFloat(12,rs.getFloat("RECEIPT_QTY"));     //RECEIPT_QTY
													mmtStmt2.setFloat(13,Float.parseFloat(aIQCReceivingBean[i][10]));     //RECEIPT_QTY	primary qty					
													mmtStmt2.setInt(14,124);                                        		//transaction_type_id
													mmtStmt2.setString(15,inspLotNo+aIQCReceivingBean[i][0]);                //transaction_reference IQCNO+LINENO
													mmtStmt2.setString(16,supplierLotNo);                //transaction_reference IQCNO+LINENO
													mmtStmt2.executeUpdate();
													mmtStmt2.close();							
		  
													//out.println("Step4. 寫入MMT Lot Interface<BR>");
													String sqlInsMMTLot2 = "  insert into MTL_TRANSACTION_LOTS_INTERFACE( "+
																			  "  TRANSACTION_INTERFACE_ID, LOT_NUMBER, TRANSACTION_QUANTITY, PRIMARY_QUANTITY, "+	
																			  "  LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY ) "+ 
																			  "  VALUES (MTL_MATERIAL_TRANSACTIONS_S.CURRVAL,?,?,?,SYSDATE,?,SYSDATE,?) ";
													PreparedStatement mmtLotStmt2=con.prepareStatement(sqlInsMMTLot2); 
													mmtLotStmt2.setString(1,supplierLotNo);    // LOT_NUMBER
													mmtLotStmt2.setFloat(2,rs.getFloat("RECEIPT_QTY"));	   // TRANSACTION_QUANTITY
													mmtLotStmt2.setFloat(3,Float.parseFloat(aIQCReceivingBean[i][10]));	   // PRIMARY_QUANTITY 
													mmtLotStmt2.setInt(4,Integer.parseInt(fndUserID));	       // LAST_UPDATED_BY 								 
													mmtLotStmt2.setInt(5,Integer.parseInt(fndUserID));	       // CREATED_BY 
													mmtLotStmt2.executeUpdate();
													mmtLotStmt2.close();
												} // End of try
												catch (Exception e)
												{
													out.println("Exception MMT & LOT Interface:"+e.getMessage());
												}	
				   								//執行 MMT及MMT LOT Submit Request
				   								String errorMsg = "";
				   								try
				   								{
					  								Statement stateRespa=con.createStatement();	   
					  								ResultSet rsRespa=stateRespa.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '401' and RESPONSIBILITY_NAME = 'YEW_INV_SEMI_SU' "); 
					  								if (rsRespa.next())
					  								{
					     								respID = rsRespa.getString("RESPONSIBILITY_ID");
					  								} 
													else 
													{
					           							respID = "50757"; // 找不到則預設 --> YEW INV Super User 預設
					         						}
					  								rsRespa.close();
					  								stateRespa.close();	  			 
			 
												 	// -- 取此次MMT 的Transaction Header ID 作為Group Header ID
												  	String grpHeaderID = "";
												  	devStatus = "";
												  	devMessage = "";
												  	Statement statGRPID=con.createStatement();	             
												  	ResultSet rsGRPID=statGRPID.executeQuery("select TRANSACTION_HEADER_ID from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID = "+groupId+" ");
												  	if (rsGRPID.next()) grpHeaderID = rsGRPID.getString(1);
												  	rsGRPID.close();
												  	statGRPID.close();
				 
												 	//	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
												 	CallableStatement cs3a = con.prepareCall("{call TSC_WIP_MMT_REQUEST(?,?,?,?,?,?)}");			 
												 	cs3a.setString(1,grpHeaderID);     //*  Group ID 	
													cs3a.setString(2,fndUserID);    //  user_id 修改人ID /	
													cs3a.setString(3,respID);  //*  使用的Responsibility ID --> YEW_INV_Semi_SU /				 
													cs3a.registerOutParameter(4, Types.INTEGER); 
													cs3a.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
													cs3a.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE
													cs3a.execute();
													requestID = cs3a.getInt(4);
													devStatus = cs3a.getString(5);   //  回傳 REQUEST 執行狀況
													devMessage = cs3a.getString(6);   //  回傳 REQUEST 執行狀況訊息
													cs3a.close();
				 				 
					 								Statement stateError=con.createStatement();
				     								String sqlError= " select ERROR_CODE, ERROR_EXPLANATION from MTL_TRANSACTIONS_INTERFACE where TRANSACTION_INTERFACE_ID= "+groupId+" " ;	
	                 								ResultSet rsError=stateError.executeQuery(sqlError);	
					 								if (rsError.next() && rsError.getString("ERROR_CODE")!=null && !rsError.getString("ERROR_CODE").equals("")) // 存在 ERROR 的資料,對Interface而言會寫ErrorCode欄位
					 								{ 
													   	out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>MMT Transaction fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
													   	out.println("<TR bgcolor='#FFFFCC'><TD colspan=1><font color='#000099'>Error Message</FONT></TD><TD colspan=1><font color='#CC3366'>"+rsError.getString("ERROR_CODE")+"</FONT></TD><TD colspan=1><font color='#CC3399'>"+rsError.getString("ERROR_EXPLANATION")+"</FONT></TD></TR>");					   
													   	out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					   									errorMsg = errorMsg+"&nbsp;"+ rsError.getString("ERROR_EXPLANATION");	  				  
					 								}
					 								rsError.close();
					 								stateError.close();
				 
					 								if (errorMsg.equals("")) //若ErrorMessage為空值,則表示Interface成功被寫入MMT,回應成功Request ID
					 								{	
					   									out.println("Success MMT Submit !!! "+"<BR>");
					   									out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	
					   									con.commit(); // 若成功,則作Commit,,讓取Entity_ID無誤				   			  
					 								}
			        							} //end of try
		            							catch (Exception e) 
		            							{ 
													out.println("Exception 執行MMT Submit Request:"+e.getMessage()); 
												}	
				   							}  // end parttransFlag ='Y'	
			      						} //end of try
		          						catch (Exception e) 
		          						{ 
											out.println("Exception part 2:"+e.getMessage()); 
										}		
				 					} // End of if (classCodeID=="01" || classCodeID.equals("01")) // 晶片(粒)作重分轉出入		  	   
			    				} // End of if (inspClass!="06" && !inspClass.equals("06"))
			    				//###################====== 購買晶粒料號,自動執行重分轉出/入 迄 =============   liling  			    
			  				} // End of While		         
							rs.close();
			   				statement.close();  // 針對此次While的更新及處理							 				
		      			}	// End of try
		      			catch (Exception e) 
		      			{ 
							out.println("Exception:"+e.getMessage()); 
						}		   
		     			// 呼叫 Package 內Procedure 的方式_迄(允收入庫_DELIVER) 			   
		   
						if (!errRCVFlag)
						{	   
	           				//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
		      				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set COMMENTS=?,LWAIVE_NO=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCReceivingBean[i][0]+"' ";     
              				pstmt=con.prepareStatement(sql);  
						  	pstmt.setString(1,aIQCReceivingBean[i][7]); // COMMENT 			       
						  	pstmt.setString(2,waiveNo); // 如無個別給定特採,則設定為與頭檔給定編號一致 
						  	pstmt.setString(3,userID); // 最後更新人員
						  	pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						  	pstmt.setString(5,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
						  	pstmt.setString(6,getStatusRs.getString("STATUSNAME")); // Line 的狀態 			   
						  	pstmt.executeUpdate(); 
						  	pstmt.close(); 
			  
			   				sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set STATUSID=?,STATUS=? where INSPLOT_NO='"+inspLotNo+"'";
               				pstmt=con.prepareStatement(sql);   
               				pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
               				pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
              	 			pstmt.executeUpdate();
               				pstmt.close(); 			  
		    			} // End of if (!errRCVFlag)
			
						// 處理歷程檔寫入_起	
			  			Statement statement=con.createStatement();
             	 		ResultSet rs=null;	  
			  			statement=con.createStatement();
             			rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
						rs.next();
						actionName=rs.getString("ACTIONNAME");
   
					    rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
					    rs.next();
					    oriStatus=rs.getString("STATUSNAME");   
					    statement.close();
					    rs.close();	
			  
			  			int deliveryCount = 0;
	          			Statement stateDeliveryCNT=con.createStatement(); 
              			ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCReceivingBean[i][0]+"' ");
	          			if (rsDeliveryCNT.next())
	          			{
	            			deliveryCount = rsDeliveryCNT.getInt(1);
	          			}
	          			rsDeliveryCNT.close();
	          			stateDeliveryCNT.close();
			  
			  			// 再寫入IQC檢驗批歷程檔資料	
		      			String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
			            		        " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
		                        		"values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
					 	PreparedStatement historystmt=con.prepareStatement(historySql);   
					  	historystmt.setString(1,inspLotNo); 
					  	historystmt.setString(2,aIQCReceivingBean[i][0]);  // Line_No
					  	historystmt.setString(3,fromStatusID); 
					  	historystmt.setString(4,oriStatus); //寫入status名稱
					  	historystmt.setString(5,actionID); 
					  	historystmt.setString(6,actionName);
					  	historystmt.setString(7,UserName);
					  	historystmt.setString(8,dateBean.getYearMonthDay()); 
					  	historystmt.setString(9,dateBean.getHourMinuteSecond()); 
					  	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
					  	historystmt.setString(11,aIQCReceivingBean[i][7]); // Comments
					  	historystmt.setInt(12,deliveryCount);		      
					  	historystmt.executeUpdate(); 
					  	historystmt.close();   
						// 處理歷程檔寫入_迄 
					} // End of if (choice[k]==aIQCReceivingCode[i][0] || choice[k].equals(aIQCReceivingCode[i][0]))
	   			} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
      		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCReceivingCode!=null)      
	    //Step4. 再更新IQC檢驗批主檔資料
        sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set INSPECT_REMARK=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	        "where INSPLOT_NO='"+inspLotNo+"' ";     
        pstmt=con.prepareStatement(sql); 
		pstmt.setString(1,remark); // 結果為特採 			 
        pstmt.setString(2,userID); // 最後更新人員
	    pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
        pstmt.executeUpdate(); 
        pstmt.close();      
	    // 再更新IQC檢驗批主檔資料	  
		 
		//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCReceivingBean!=null)
		{ 
	  		arrIQC2DReceivingBean.setArray2DString(null); 
		}
  	} //若為倉管允收入庫確認(RECEIVE)_迄 (ACTION=018)
    
	//若為倉管批退供應商確認(RETURN)_起 (ACTION=019)
  	if (actionID.equals("019")) 
  	{ 	
    	// 設定倉管人員的Client Info_起			
    	try
		{
      		//CallableStatement csCINF = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
			CallableStatement csCINF = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
      		csCINF.setString(1,userWSOrgID);  // 取品管人員隸屬OrgID
      		csCINF.execute();
      		csCINF.close();  
    	}	
		catch (Exception e) 
		{ 
			out.println("Exception 1:"+e.getMessage()); 
		}	
		// 設定倉管人員的Client Info_迄
  
    	//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_起
		String fndUserID = "";
		String fndEmpID = "";
		String sqlfnd = "select USER_ID, EMPLOYEE_ID from APPS.FND_USER A, ORADDMAN.WSUSER B"+
 			      	  " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
		Statement stateFndId=con.createStatement();
    	ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
		if (rsFndId.next())
		{
	  		fndUserID = rsFndId.getString("USER_ID"); 
	  		fndEmpID = rsFndId.getString("EMPLOYEE_ID");
		}
		rsFndId.close();
		stateFndId.close();
		//抓取login 的user id 做為 run "Receiving Transaction Processor"的 requestor_迄					 

		if (aIQCReturningBean!=null) // 判斷該次有分派細項才進行明細表更新
    	{
	  		for (int i=0;i<aIQCReturningBean.length-1;i++)
	  		{
	    		for (int k=0;k<=choice.length-1;k++)    
        		{
	      			if (choice[k]==aIQCReturningBean[i][0] || choice[k].equals(aIQCReturningBean[i][0]))
	      			{ 		
		    			// 呼叫 Package 內Procedure 的方式_起	
						String devStatus = "";
						String devMessage = "";	
						String rvcGrpID = "0";
						String interTxnId = "";
						boolean errRTNFlag = false;
						respID = "";
						//先取得欲執行產生PO之Responsibility ID_起
						Statement stateResp=con.createStatement();	   
						ResultSet rsResp=stateResp.executeQuery("select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '201' and RESPONSIBILITY_NAME = 'YEW_PO_SEMI_SU' "); 
	        			if (rsResp.next())
	       	 			{
	          				respID = rsResp.getString("RESPONSIBILITY_ID");
	        			} 
						else 
						{
	          				respID = "50761"; // 找不到則預設 --> YEW PO SEMI Super User 預設
	        			}
						rsResp.close();
						stateResp.close();	  	
	        			//先取得欲執行產生PO之Responsibility ID_迄		
            			
						try
		   				{			   
		      				Statement statement=con.createStatement();
			  				String sql1a=  " select INSPLOT_NO as SELECTFLAG, INSPLOT_NO ,RECEIPT_QTY ,SUPPLIER_LOT_NO, "+
			                        " PO_HEADER_ID, PO_LINE_ID, PO_LINE_LOCATION_ID, SHIPMENT_LINE_ID, "+
			                        " EMPLOYEE_ID, ORGANIZATION_ID, RECEIPT_NO, INTERFACE_TRANSACTION_ID "+
                            		" from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL "+
                           	 		" where INSPLOT_NO = '"+inspLotNo+"' and LINE_NO = '"+aIQCReturningBean[i][0]+"' "+
						    		" and LSTATUSID = '024'"; // 只針對狀態是待批退中的檢驗批及項次                          
              				ResultSet rs=statement.executeQuery(sql1a);  
              				while (rs.next() && !errRTNFlag)
              				{
								interTxnId = rs.getString("INTERFACE_TRANSACTION_ID") ;
								int parentTransID = 0;
								int fromOrgID = 0;
			    				try
								{
			  	  					Statement stateGroupId=con.createStatement();
			      					String sqlGroupId="select TRANSACTION_ID, organization_id FROM_ORGANIZATION_ID"+			                         
                                     			" from rcv_transactions"+
                                   				 " where TRANSACTION_TYPE = 'REJECT' and DESTINATION_TYPE_CODE='RECEIVING'"+
									  				" and source_document_code = 'PO'"+
												  " and SHIPMENT_LINE_ID = "+rs.getString("SHIPMENT_LINE_ID");	
                  					ResultSet rsGroupId=stateGroupId.executeQuery(sqlGroupId);	  
				  					if (rsGroupId.next())
				  					{ 				     
										parentTransID = rsGroupId.getInt("TRANSACTION_ID");
										fromOrgID = rsGroupId.getInt("FROM_ORGANIZATION_ID");
				  					}
				  					rsGroupId.close();
				  					stateGroupId.close();
								} //end of try
               	 				catch (Exception e)
                				{
	              					e.printStackTrace();
                  					out.println(e.getMessage());
               					}//end of catch    		
								// 20100316 Marvie Add : error processing
                				if (parentTransID==0)
								{
				  					errRTNFlag = true;
				  					out.println("<BR>Get transaction type REJECT ERROR!!!<BR>");
								}			

								// 2006/12/19 若Oracle未將原收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
								String employeeID = "";
								if (fndEmpID==null || fndEmpID.equals("")) 
								{ 
				  					if (rs.getString("EMPLOYEE_ID")==null || rs.getString("EMPLOYEE_ID").equals(""))
				  					{  
										employeeID = "3077";  // 若是RCV及操作人員皆無EmpID則以開發人員為EMpID
				  					}
									else 
									{  
										employeeID = rs.getString("EMPLOYEE_ID");  
									}
								}
								else 
								{
									employeeID = fndEmpID;
								}	   
								// 2006/12/19 若Oracle未將收料人員 Employee ID 寫入RCV_TRANSACTIONS ,則取登錄IQC物管人員為EMPLOYEE ID
					
								if (!errRTNFlag)    // 20100316 Marvie Add : error processing
								{
									CallableStatement cs3 = con.prepareCall("{call TSIQC_RETRCV_API_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			
									cs3.setString(1,inspLotNo);                    //檢驗批單號
									cs3.setDate(2,receivingDate);                  //收料日期
									cs3.setInt(3,Integer.parseInt(fndUserID));     // FND_USER ID    
									cs3.setInt(4,Integer.parseInt(rs.getString("PO_HEADER_ID")));                        // PO_HEADER_ID_查詢依據  
									cs3.setInt(5,Integer.parseInt(rs.getString("PO_LINE_ID")));                          // PO_LINE_ID_查詢依據 
									cs3.setFloat(6,rs.getFloat("RECEIPT_QTY"));  
									cs3.registerOutParameter(7, Types.VARCHAR); //   HEADER處理訊息 
									cs3.registerOutParameter(8, Types.VARCHAR); //   LINE處理訊息  
									cs3.registerOutParameter(9, Types.INTEGER); //   PO_LINE_ID 
									cs3.registerOutParameter(10, Types.VARCHAR); //   HEADER error訊息 
									cs3.registerOutParameter(11, Types.VARCHAR); //   LINE error訊息 
									cs3.setInt(12,Integer.parseInt(rs.getString("PO_LINE_LOCATION_ID")));                 //PO_LOCATION_LINE_ID_查詢依據
									cs3.setInt(13,Integer.parseInt(employeeID));   //EMPLOYEE_ID
									cs3.setInt(14,Integer.parseInt(rs.getString("ORGANIZATION_ID")));   //ORGANIZATION_ID
									cs3.setString(15,"");   // SUB_INVENTORY	
									cs3.setString(16,rs.getString("SUPPLIER_LOT_NO"));   // SULLPIER_LOT_NO	
									cs3.setString(17,aIQCReturningBean[i][7]);   // COMMENTS aIQCReceivingBean[i][7]	
									cs3.setString(18,rs.getString("RECEIPT_NO"));                                         // RECEIPT_NO_查詢依據
									cs3.setInt(19,0);       // 原RECEIVING 的GROUP ID,讓入庫可成對 RECEIVE <--> DELIVER
									cs3.setInt(20,453724);   // 原RECEIVING 的TRANSACTION ID,讓入庫可成對 RECEIVE <--> RETURN	 // 無所謂,不用傳,由Procedure的SQL去找即可
									cs3.setInt(21,fromOrgID);       // 原RECEIVING 的FROM ORG ID,讓入庫可成對 RECEIVE <--> RETURN	
									cs3.setInt(22,rs.getInt("INTERFACE_TRANSACTION_ID"));       // INTERFACE_TRANSACTION_ID 	
									cs3.setInt(23,rs.getInt("SHIPMENT_LINE_ID"));      // SHIPMENT_LINE_ID  			     			     
									cs3.execute();
									statusMessageHeader = cs3.getString(7);	             
									statusMessageLine = cs3.getString(8);
									headerID = cs3.getInt(9);   // 把第二次的更新 Header ID 取到
									errorMessageHeader = cs3.getString(10);	             
									errorMessageLine = cs3.getString(11);				 
									cs3.close();			
									if (errorMessageHeader==null) 
									{ 
										errorMessageHeader = "&nbsp;";
										Statement stateRvcGrpID=con.createStatement();
										String sqlRvcGrpID="select max(GROUP_ID) "+
											" from RCV_TRANSACTIONS_INTERFACE "+
										   " where ATTRIBUTE6 = '"+inspLotNo+"' and LAST_UPDATED_BY = '"+fndUserID+"' "+
										   "   and TRANSACTION_TYPE = 'RETURN TO VENDOR' and SHIPMENT_LINE_ID = "+rs.getString("SHIPMENT_LINE_ID")+" ";
										ResultSet rsRvcGrpID=stateRvcGrpID.executeQuery(sqlRvcGrpID);
										if (rsRvcGrpID.next()) rvcGrpID = rsRvcGrpID.getString(1);
										rsRvcGrpID.close();
										stateRvcGrpID.close();
									}				
									if (errorMessageLine==null ) 
									{ 
										errorMessageLine = "&nbsp;";
									}	
								} // End of if (!errRTNFlag)
							} // End of While	 
				
							if (!errRTNFlag) // 20100316 Marvie Add : error processing
							{
								if ((errorMessageHeader==null || errorMessageHeader=="" || errorMessageHeader.equals("&nbsp;")) && (errorMessageLine==null || errorMessageLine=="" || errorMessageLine.equals("&nbsp;"))) 
								{					    
									errorMessageHeader = "&nbsp;"; 
									errorMessageLine = "&nbsp;"; 
									CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
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
									out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
									out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
									out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");			
									
									// 判斷是否成功執行Interface_起
									try 
									{					   
										Statement stateError=con.createStatement();
										String sqlError="select INTERFACE_TRANSACTION_ID "+			                         
														" from RCV_TRANSACTIONS_INTERFACE "+
														" where INTERFACE_TRANSACTION_ID ="+interTxnId+" and PROCESSING_STATUS_CODE='ERROR' "+
														"   and TRANSACTION_TYPE ='RETURN TO VENDOR' ";	
													 
										ResultSet rsError=stateError.executeQuery(sqlError);	  
										if (!rsError.next()) // 不存在 ERROR 的資料
										{ 									 
											// 成功..則更新原Receiving Attribute6 = 檢驗批單號_起
											sql="update RCV_TRANSACTIONS set ATTRIBUTE6=? "+
												 "where INTERFACE_TRANSACTION_ID='"+interTxnId+"' "+
												 "and TRANSACTION_TYPE in ('RETURN TO VENDOR') and USER_ENTERED_FLAG = 'Y' "+
												"and SOURCE_DOCUMENT_CODE = 'PO' "; 
											pstmt=con.prepareStatement(sql);  
											pstmt.setString(1,inspLotNo); // Attribute6 作為新增依 Receiving 排除 		                               
											pstmt.executeUpdate(); 
											pstmt.close();  	
											errRTNFlag = false;								  
											// 成功..則更新原Receiving Attribute6 = 檢驗批單號_迄
										} 
										else 
										{
											errRTNFlag = true; // 失敗
										}
										rsError.close();
										stateError.close();	
									} // End of try
									catch (Exception e) 
									{ 
										out.println("Exception 2:"+e.getMessage()); 
									}	
									// 判斷是否成功執行Interface_迄
								} 
								else 
								{  
									out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Fail!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
									out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+errorMessageLine+"</TD></TR>");
								}
							} // End of if (!errRTNFlag)
						}
						catch (Exception e) 
						{ 
							out.println("Exception 3:"+e.getMessage()); 
						}		   
		   				 // 呼叫 Package 內Procedure 的方式_迄   
	        			//Step2. 先更新明細檔資料, 依生產工廠給定取到的流水批號,條件是詢問單號及項次
						if (!errRTNFlag) // 成功執行退料才改變狀態
						{  
		      				sql="update ORADDMAN.TSCIQC_LOTINSPECT_DETAIL set COMMENTS=?,LWAIVE_NO=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	              				"where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCReturningBean[i][0]+"' ";     
              				pstmt=con.prepareStatement(sql);  
			  				pstmt.setString(1,aIQCReturningBean[i][7]); // COMMENT 			       
						  	pstmt.setString(2,waiveNo); // 如無個別給定特採,則設定為與頭檔給定編號一致 
						  	pstmt.setString(3,userID); // 最後更新人員
						  	pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						  	pstmt.setString(5,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
						  	pstmt.setString(6,getStatusRs.getString("STATUSNAME")); // Line 的狀態 
						  	pstmt.executeUpdate(); 
						  	pstmt.close(); 
			  
			  				//Step4. 再更新IQC檢驗批主檔資料
              				sql="update ORADDMAN.TSCIQC_LOTINSPECT_HEADER set INSPECT_REMARK=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?, "+
		          				"      STATUSID=?, STATUS=? "+
	              				" where INSPLOT_NO='"+inspLotNo+"' ";     
						  	pstmt=con.prepareStatement(sql); 
						  	pstmt.setString(1,remark); // 結果為特採 			 
						  	pstmt.setString(2,userID); // 最後更新人員
						  	pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
						  	pstmt.setString(4,getStatusRs.getString("TOSTATUSID")); // Header 的狀態ID
						  	pstmt.setString(5,getStatusRs.getString("STATUSNAME")); // Header 的狀態     
						  	pstmt.executeUpdate(); 
						  	pstmt.close();      
	          				// 再更新IQC檢驗批主檔資料				  
						} // end of if (!errRCVFlag)
			  
						// 處理歷程檔寫入_起
						Statement statement=con.createStatement();
						ResultSet rs=null;		  
						statement=con.createStatement();
						rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
						rs.next();
						actionName=rs.getString("ACTIONNAME");
   
						rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
						rs.next();
						oriStatus=rs.getString("STATUSNAME");   
						statement.close();
						rs.close();	
			  
						int deliveryCount = 0;
						Statement stateDeliveryCNT=con.createStatement(); 
						ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSCIQC_LOTINSPECT_HISTORY where INSPLOT_NO='"+inspLotNo+"' and LINE_NO='"+aIQCReturningBean[i][0]+"' ");
						if (rsDeliveryCNT.next())
						{
	          				deliveryCount = rsDeliveryCNT.getInt(1);
	        			}
						rsDeliveryCNT.close();
						stateDeliveryCNT.close();
			  
						// 再寫入IQC檢驗批歷程檔資料	
						String historySql="insert into ORADDMAN.TSCIQC_LOTINSPECT_HISTORY(INSPLOT_NO, LINE_NO, ORISTATUSID, ORISTATUS, "+
											 " ACTIONID, ACTIONNAME, UPDATEUSERID, UPDATEDATE, UPDATETIME, CDATETIME, PROCESS_REMARK, SERIALROW) "+
											"values(?,?,?,?,?,?,?,?,?,?,?,?) ";	             
						PreparedStatement historystmt=con.prepareStatement(historySql);   
						historystmt.setString(1,inspLotNo); 
						historystmt.setString(2,aIQCReturningBean[i][0]);  // Line_No
						historystmt.setString(3,fromStatusID); 
						historystmt.setString(4,oriStatus); //寫入status名稱
						historystmt.setString(5,actionID); 
						historystmt.setString(6,actionName);
						historystmt.setString(7,UserName);
						historystmt.setString(8,dateBean.getYearMonthDay()); 
						historystmt.setString(9,dateBean.getHourMinuteSecond()); 
						historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
						historystmt.setString(11,aIQCReturningBean[i][7]); // Comments
						historystmt.setInt(12,deliveryCount);		      
						historystmt.executeUpdate(); 
						historystmt.close();
						// 處理歷程檔寫入_迄 
		  			} // End of if (choice[k]==aIQCWaivingCode[i][0] || choice[k].equals(aIQCWaivingCode[i][0]))
	    		} // End of for (int k=0;k<choice.length;k++) // 判斷使用者有細項Check才 更新明細  
      		} // End of for (i=0;i<aFactory.length;i++)
		} // end of if (aIQCWaivingCode!=null)  
	
    	//###***** 完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) *****### //
		if (aIQCReturningBean!=null)
		{ 
	  		arrIQC2DReturningBean.setArray2DString(null); 
		}
  	} //若為倉管批退供應商(RETURN)_迄 (ACTION=019)  
  	out.println("<BR>Processing IQC Inspection Lot value(INSPLOTNO:<A HREF='TSIQCInspectLotDisplayPage.jsp?INSPECTLOTNO="+inspLotNo+"'><font color=#FF0000>"+inspLotNo+"</font></A>) OK!");
  	out.println("<BR>");  
  	getStatusStat.close();
  	getStatusRs.close();  
  	pstmt.close();       
} //end of try
catch (Exception e)
{
	e.printStackTrace();
  	out.println(e.getMessage());
} //end of catch
%>

<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="60%" align="LEFT" borderColorLight="#ffffff" border="1">
  <tr>
    <td width="278"><font size="2">IQC品管檢驗批單據處理</font></td>
    <td width="297"><font size="2">IQC品管檢驗批單查詢及報表</font></td>    
  </tr>
  <tr>   
    <td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E1";    
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    	
    while(rs.next())
    {
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
    String MODEL = "E2";    
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
<%@ include file="/jsp/IQCInclude/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

