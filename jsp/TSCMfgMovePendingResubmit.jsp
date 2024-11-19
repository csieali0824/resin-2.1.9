<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
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
                  { //alert(orginalPage);
				    //alert(URL);
				     // return (true); 
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

<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
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
   String runCardNo=request.getParameter("RUNCARD_NO");   //工單號
   String fndUserName=request.getParameter("FNDUSERNAME"); 
   String fmOperSeqNo=request.getParameter("FMOPERSEQNO"); 
   String transID=request.getParameter("TRANSID"); 
   
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

   String runCardCount=String.valueOf(runCardCountI);  //流程卡張數
   //out.print("woNo="+woNo+"<br>");
   //out.print("尾批數量="+runCardCountD);
      
   if(woPassFlag==null || woPassFlag.equals("")) woPassFlag="N";   
   
// MFG工令資料_參數迄


//String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
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
		   //out.println("processDateTime  = "+processDateTime);
		 }
		 rsDate.close();
         stateDate.close();	   
 }    // 得到入庫執行日期..日期型態
 
  java.sql.Date receivingDate = null; //將SYSDATE轉換成日期格式以符丟入API格式
 if (systemDate!=null && systemDate.length()>=8)
 {
   receivingDate = new java.sql.Date(Integer.parseInt(systemDate.substring(0,4))-1900,Integer.parseInt(systemDate.substring(4,6))-1,Integer.parseInt(systemDate.substring(6,8)));  // 給Receiving Date
   String systemTime = dateBean.getHourMinuteSecond();  // 給System Time
   
         String sqlDate="  select TO_DATE('"+systemDate+ systemTime+"','YYYYMMDDHH24MISS') from DUAL   ";  					
         Statement stateDate=con.createStatement();
         ResultSet rsDate=stateDate.executeQuery(sqlDate);
		 if (rsDate.next())
		 { receivingDate  = rsDate.getDate(1);  }
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
 // getStatusRs.next();
  
//out.println("Step0");

//MFG流程卡完工入庫_起	(ACTION=018) RECEIVE   流程卡移站中045 --> 流程卡完工入庫046且此為委外加工站(已判斷本站為最後一站,如為最後一站,則收料後,會自動作TO_MOVE)
if (fromStatusID==null || fromStatusID.equals("045"))   // 如為 n站, 即第 n-1站 --> 第 n 站(最後一站)
{  
   
		   //out.println("<BR>*****%%%%%%%%%%%%%%%%%%% 正常完工流程卡屬性2更新  %%%%%%%%%%%%%%%**********  起<BR>");
	
	       String getErrBuffer = "";
	       int getRetCode = 0;  
		   //抓取寫入Interface的Group等資訊_起
	       int groupID = 0;
		   int opSeqNo = 0;  
		   entityId = "0";    
		   float overCompQty = 0;        
						 String sqlGrp = " select WIP_TRANSACTIONS_S.NEXTVAL, TO_OPERATION_SEQ_NUM, TRANSACTION_QUANTITY, WIP_ENTITY_ID "+
						                 "   from WIP.WIP_MOVE_TXN_INTERFACE "+
 									     " where ( WIP_ENTITY_NAME = '"+woNo+ "' or ATTRIBUTE2='"+runCardNo+"' ) and PROCESS_STATUS = 3 "+ // 已經Error 的狀態
										 "   and TO_INTRAOPERATION_STEP_TYPE in (1, 3, 5) and CREATED_BY_NAME = '"+fndUserName+"' "+
										 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+fmOperSeqNo+"' and TRANSACTION_ID = "+transID+" "; // 取此次移站的Group ID
						 Statement stateGrp=con.createStatement();
                         ResultSet rsGrp=stateGrp.executeQuery(sqlGrp);
						 if (rsGrp.next())
						 {
						   groupID = rsGrp.getInt(1); // 取到下一個 Group ID 作為更新及MoveWorker依據
						   opSeqNo = rsGrp.getInt("TO_OPERATION_SEQ_NUM");
						   entityId = rsGrp.getString(4); // entityId
						   // 超收數量計入超收欄位
						    String sqlUp = "update WIP_MOVE_TXN_INTERFACE "+
						                   "   set GROUP_ID="+groupID+", PROCESS_STATUS = '1', PROCESS_PHASE='1' "+										   
						                   " where WIP_ENTITY_NAME = '"+woNo+ "' and CREATED_BY_NAME = '"+fndUserName+"' "+
										   "   and to_char(FM_OPERATION_SEQ_NUM) = '"+fmOperSeqNo+"' and TRANSACTION_ID = "+transID+"  ";
						    PreparedStatement seqstmt=con.prepareStatement(sqlUp);
						    seqstmt.executeUpdate();
                            seqstmt.close();	
						   // 補上PO 收料的流程卡號,ATTRIBUTE2_迄
						 }
						 rsGrp.close();
						 stateGrp.close();
						 
					out.println("移站的groupID="+groupID+"<BR>");	 
						 
	     //抓取寫入Interface的Group等資訊_迄		
		      
		 if (groupID>0 && opSeqNo>0)  // 表示取到正確的groupID及opSeqNo
		 {
		   // 即時呼叫 WIP_MOVE PROCESS WORKER
		   
		   int procPhase = 1;
		   int timeOut = 10;
		   try
		   {	
						  CallableStatement cs4 = con.prepareCall("{call WIP_MOVPROC_PRIV.Move_Worker(?,?,?,?,?,?)}");			
						  cs4.registerOutParameter(1, Types.VARCHAR); //  傳回值        ERROR BUFFER
						  cs4.registerOutParameter(2, Types.INTEGER); //  傳回值		RETURN CODE				   
					      cs4.setInt(3,groupID);                                         //  Org ID 	
					      cs4.setInt(4,procPhase);    // 1 Move Validation 2.Move Processing 3.Opeariotn Backflush Setup     
						  cs4.setInt(5,timeOut); 
						  cs4.setInt(6,opSeqNo);                // TO_OPERATION_SEQ_NUM				 					      						   	 					     
					      cs4.execute();					      
					      getErrBuffer = cs4.getString(1);		
						  getRetCode = cs4.getInt(2);								      				    
					      cs4.close();						  
						  out.println("getRetCode="+getRetCode+"&nbsp;"+"getErrBuffer="+getErrBuffer+"<BR>");	
						  // 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_起  
						  String sqlGrpMsg = " select GROUP_ID from WIP.WIP_MOVE_TRANSACTIONS "+
 									         " where WIP_ENTITY_ID = '"+entityId+"' "+
											 "   and to_char(FM_OPERATION_SEQ_NUM) = '"+fmOperSeqNo+"' "+
										     "   and TRANSACTION_ID = "+transID+"  "+  // 移站ID
										     "   and TO_INTRAOPERATION_STEP_TYPE in (1,3,5) and  GROUP_ID = "+groupID+" ";   // 取此次移站
						  Statement stateGrpMsg=con.createStatement();
						  ResultSet rsGrpMsg=stateGrpMsg.executeQuery(sqlGrpMsg);
						  if (rsGrpMsg.next())  // 若存在,表示有錯誤訊息,但仍成功寫入Move Transaction, 更正getRetCode = 0
						  {
						    getRetCode = 0; 
							if (getErrBuffer!=null && !getErrBuffer.equals("null")) out.println("含錯誤訊息,仍成功寫入移站數Interface!!!");
						  } else {
						           out.println("<font color='#FF0000'>Oracle移站或完工含錯誤訊息,請洽詢MIS查明原因!!!\n工令號("+woNo+")</font>");
						         }
						  rsGrpMsg.close();
						  stateGrpMsg.close();
						  // 機車,訊息不準確,需再判斷是否MOVE_TRANSACTION依流程卡是否正確以被寫入,如已寫入,則仍執行正常移站作業 //_迄		  	  
			}	  
			catch (Exception e) { out.println("Exception:"+e.getMessage()); }  
		 } // end of if (groupID>0 && opSeqNo>0)			 
		 // *****%%%%%%%%%%%%%% 正常完工數量  %%%%%%%%%%%%**********  迄
	

    //out.print("流程卡完工入庫O.K.(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")");
	out.print("<BR><font color='#0033CC'>工令Move Pending處理完畢</font><font color='#CC3333'>(WO_NO="+woNo+" Wip_Entity_ID="+entityId+")</font>");
	
   

} // End of if (fromStatusID.equals("045"))
//MFG流程卡完工入庫_迄	(ACTION=012)   流程卡移站中044 --> 流程卡待收料中045(需判斷是否本站為最後一站)
  
  out.println("<BR>");
   

  getStatusStat.close();
  getStatusRs.close();  
  //pstmt.close();       
  
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
    String MODEL = "E4";    
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

