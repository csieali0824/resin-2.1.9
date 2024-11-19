<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="StockInfoBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function reProcessFormConfirm(ms1,URL,dnDOCNo,lineNo,assignFact,ordtypeid,linetypeid)
{
	var orginalPage="?DNDOCNO="+dnDOCNo+"&LINE_NO="+lineNo+"&ASSIGN_MANUFACT="+assignFact+"&ORDER_TYPE_ID="+ordtypeid+"&LINE_TYPE="+linetypeid;
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
<title>Sales Delivery Request M Data Process</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSalesDRQMProcessNew.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String dnDocNo=request.getParameter("DNDOCNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");
// 20110310 Marvie Add : Add field  PROGRAM_NAME
String sProgramName=request.getParameter("PROGRAMNAME");
if (sProgramName==null || sProgramName.equals("")) sProgramName="";

String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String newDRQOption=request.getParameter("NEWDRQOPTION");//是否要以原單據內容產生新的交期詢問單
String oriStatus=null;
String actionName=null;
String dateString="";
String seqkey="";
String seqno="";
String firmOrderType=request.getParameter("FIRMORDERTYPE");
String firmSoldToOrg=request.getParameter("FIRMSOLDTOORG");
String firmPriceList=request.getParameter("FIRMPRICELIST");
String ShipToOrg=request.getParameter("SHIPTOORG");
String billTo = request.getParameter("BILLTO"); 
String payTermID=request.getParameter("PAYTERMID");
String fobPoint=request.getParameter("FOBPOINT");
String shipMethod=request.getParameter("SHIPMETHOD");
String line_No=request.getParameter("LINE_NO");
String custPO=request.getParameter("CUST_PO");
String curr=request.getParameter("CURR");
String prCurr=request.getParameter("PRCURR");
String [] choice=request.getParameterValues("CHKFLAG");
String sampleOrder=request.getParameter("SAMPLEORDER");
String TSC_PACKAGE=request.getParameter("TSC_PACKAGE");  //add by Peggy 20210317
if (TSC_PACKAGE==null || TSC_PACKAGE.equals("--")) TSC_PACKAGE="";
if (custPO==null) { custPO=""; }
//String YearFr=dateBean.getYearMonthDay().substring(0,4);
//String MonthFr=dateBean.getYearMonthDay().substring(4,6);
//String DayFr=dateBean.getYearMonthDay().substring(6,8);;
//java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
//java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
//java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr)); // 給Promise Date
String sourceTypeCode = "INTERNAL"; 
int lineType = 0;  
String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
String assignLNo = "";
String prodDesc = null;
String prodCodeGet = "";
int prodCodeGetLength = 0;   
//String dateCurrent = dateBean.getYearMonthDay();
String sToStatusID = "";
String sToStatusName = "";
String strRes = "";     
String choiceLine = ""; 
String CancelReason=request.getParameter("CancelReason");
if (CancelReason==null) CancelReason = "";
String salesAreaNo="",customerId="",autoCreate_Flag="",orderTypeId="", orderType="",custItemID="", custItemType = "";  
String over_lead_time_reason="",pc_lead_time=""; 
String END_CUST_SHORT_NAME="",END_CUST_ID=""; 
String end_cust_ship_to=""; 
String v_new_ssd="";
int errCnt =0; 
boolean is_exist = false; 
String sql_e="",customer="",line_remarks="";
String choose_line="";
long ship_qty=0,allot_qty=0;
// formID = 基本資料頁傳來固定常數='TS'
// fromStatusID = 基本資料頁傳來Hidden 參數
// actionID = 前頁取得動作 ID( Assign = 003 )
try 
{
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();	

 // 先取得下一狀態及狀態描述並作流程狀態更新   
	//dateString=dateBean.getYearMonthDay();
	
  	String sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	String whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
  	// 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
  	if (UserRoles.equals("admin")) 
	{
		whereStat = whereStat+"and FORMID='TS' "; //預設TS
	}  //若是管理員,則任何動作不受限制
  	else if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) 
	{
		whereStat = whereStat+"and FORMID='SH' "; // 若是上海內銷辦事處
	}
  	else 
	{
		whereStat = whereStat+"and FORMID='TS' "; // 否則一律皆為外銷流程
	}
	
  	// 2006/04/13加入特殊內銷流程,針對上海內銷_迄		
  	sqlStat = sqlStat+whereStat;
	//out.println("sqlStat="+sqlStat);
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
  	//getStatusRs.next();
  	if (getStatusRs.next()) 
	{
    	sToStatusID = getStatusRs.getString("TOSTATUSID");
		sToStatusName = getStatusRs.getString("STATUSNAME");
  	}
  	getStatusStat.close();
  	getStatusRs.close();  
  
  	String sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=? where DNDOCNO='"+dnDocNo+"'";
  	PreparedStatement pstmt=con.prepareStatement(sql);  
  	pstmt.setString(1,sToStatusID);
  	pstmt.setString(2,sToStatusName);
  	pstmt.executeUpdate();
  	pstmt.close();
  
  	//若有指派人員則找出其e-Mail
  	if (changeProdPersonID!=null) 
	{
    	Statement mailStat=con.createStatement();  
    	ResultSet mailRs=mailStat.executeQuery("select USERMAIL from ORADDMAN.WSUSER where WEBID='"+changeProdPersonID+"'");  
    	if (mailRs.next()) changeProdPersonMail=mailRs.getString("USERMAIL");
		mailRs.close();
		mailStat.close();	
  	}	
	
  	//@@@@@@@@@@取得該使用者隸屬之業務中心資料@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
  	Statement userSalesStat=con.createStatement();
	ResultSet userSalesRs=userSalesStat.executeQuery("SELECT SALES_AREA_NO,SALES_AREA_NAME,TEL,MOBILE,ZIP,ADDRESS "+
	" FROM ORADDMAN.TSSALES_AREA WHERE trim(SALES_AREA_NO)='"+userActCenterNo+"'");
  	String userSalesAreaName="",userTel="",userCell="",userAddr="",userZIP="";//Zip是電話分機代碼
  	if (userSalesRs.next()) 
	{
		userSalesAreaName=userSalesRs.getString("SALES_AREA_NAME");	  
		userTel=userSalesRs.getString("TEL");
		userCell=userSalesRs.getString("MOBILE");
		userAddr=userSalesRs.getString("ADDRESS");
		userZIP=userSalesRs.getString("ZIP");	  
  	}	 	  
  	userSalesRs.close();
  	userSalesStat.close();
  	//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
  	// 先設定Client Info_起 
  	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
 	cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
  	cs1.execute();
  	cs1.close();	 
	// 先設定Client Info_迄   
  
  	//  (ACTION=005)工廠批退交期詢問單(REJECT)_起 (ACTION=005) 即正常流至企劃(RESPONDING),且Show出批退訊息
  	if (actionID.equals("005")) 
  	{    
		try
		{
			choose_line = ""; 
			for (int k=0;k<choice.length;k++)    
			{
				choose_line += (","+choice[k]); 
				
				sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
					  "(DNDOCNO"+
					  ",ORISTATUSID"+
					  ",ORISTATUS"+
					  ",ACTIONID"+
					  ",ACTIONNAME"+
					  ",UPDATEUSERID"+
					  ",UPDATEDATE"+
					  ",UPDATETIME"+
					  ",ASSIGN_FACTORY"+
					  ",CDATETIME"+
					  ",REMARK"+
					  ",SERIALROW"+
					  ",LINE_NO"+
					  ",PROCESS_WORKTIME"+
					  ",PC_REMARK)"+
					  " select a.dndocno"+
					  ",a.lstatusid"+
					  ",a.lstatus"+
					  ",?"+
					  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
					  ",?"+
					  ",to_char(sysdate,'yyyymmdd')"+
					  ",TO_CHAR(SYSDATE,'hh24miss')"+
					  ",a.ASSIGN_MANUFACT"+
					  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
					  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no)"+
					  ",a.line_no"+
					  ",(select round((sysdate-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no and x.ORISTATUSID =a.LSTATUSID)"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+   //modify by Peggy 20201112
					  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
					  " where a.DNDOCNO=?"+
					  " and a.LINE_NO=?"+
					  " and a.LSTATUSID=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,actionID);
				pstmtDt.setString(2,actionID);
				pstmtDt.setString(3,userID);
				pstmtDt.setString(4,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
				pstmtDt.setString(5,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
				pstmtDt.setString(6,dnDocNo);
				pstmtDt.setString(7,choice[k]);
				pstmtDt.setString(8,fromStatusID);
				pstmtDt.executeQuery();
				pstmtDt.close();
					  
				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
				" set LAST_UPDATED_BY=?"+
				",LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
				",LSTATUSID=?"+
				",LSTATUS=?"+
				",SHIP_DATE=?"+
				",REASON_CODE= ? "+
				",REASONDESC=UTL_I18N.UNESCAPE_REFERENCE(?)"+ //modify by Peggy 20201112
				",PC_COMMENT=UTL_I18N.UNESCAPE_REFERENCE(case when A.ASSIGN_MANUFACT='006' THEN null ELSE PC_COMMENT END ||?)"+ //modify by Peggy 20201112
				",EDIT_CODE=? "+
				",AUTOCREATE_FLAG =?"+  
				" where a.DNDOCNO=?"+
				" and a.LINE_NO=?"+
				" and a.LSTATUSID=?";
				pstmt=con.prepareStatement(sql);
				pstmt.setString(1,userID); // 最後更新人員 
				pstmt.setString(2,sToStatusID);
				pstmt.setString(3,sToStatusName);
				pstmt.setString(4,"N/A"); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間(因為工廠批退,故不給SHIP_DATE時間)  
				//pstmt.setString(5,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k]))); // 記住各項次批退的原因
				pstmt.setString(5,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
				pstmt.setString(6,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"N/A":request.getParameter("REASON_"+choice[k])));
				pstmt.setString(7,(request.getParameter("PROC_REMARK_"+choice[k])==null?"":request.getParameter("PROC_REMARK_"+choice[k])));
				pstmt.setString(8,"R"); // 記住批退代碼"R"  //2009/03/03 LILING add
				pstmt.setString(9,"R"); // AUTOCREATE_FLAG, ADD BY Peggy 20120322
				pstmt.setString(10,dnDocNo);
				pstmt.setString(11,choice[k]);
				pstmt.setString(12,fromStatusID);
				pstmt.executeQuery();
				pstmt.close();   
				
				sql = " SELECT ORIG_SO_LINE_ID FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
                      " where a.DNDOCNO=?"+
				      " and a.LINE_NO=?"+
					  " and a.ORIG_SO_LINE_ID is not null";
				PreparedStatement statementh = con.prepareStatement(sql);
       			statementh.setString(1,dnDocNo);
      			statementh.setString(2,choice[k]);				
				ResultSet rsh=statementh.executeQuery();		
        		while (rsh.next())
        		{	
					sql=" update tsca.ta_om_request_supply a "+
						" set REQ_SUPPLY_STATUS=?"+
						",RFQ_REASON=(select REASONDESC from ORADDMAN.TSREASON where TSREASONNO=?)"+
						" where LINE_ID=?";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,"RFQ_REJECT"); 
					pstmt.setString(2,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(3,rsh.getString("ORIG_SO_LINE_ID"));
					pstmt.executeQuery();
					pstmt.close();  						
				}
				rsh.close();
				statementh.close();
			}
			
			if (!choose_line.equals(""))
			{
				CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.ACTION_REJECT_EMAIL_NOTICE(?,?)}");			 
				cs3.setString(1,dnDocNo); 
				cs3.setString(2,choose_line+","); 
				cs3.execute();
				cs3.close();			
			}
			//Step4. 再更新交期詢問主檔資料
			sql="update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=to_char(sysdate,'yyyymmddhh24miss'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss') where DNDOCNO='"+dnDocNo+"' ";     
			pstmt=con.prepareStatement(sql);       
			pstmt.setString(1,userID); // 最後更新人員
			pstmt.executeQuery();
			pstmt.close();      
			
			con.commit();
		}
		catch(Exception e)
		{	
			errCnt++;
			con.rollback();
			out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"</font>");
		}			
  	} 
 	
  	// 工廠交期確認(CONFIRM)_起 (ACTION=008)
  	if (actionID.equals("008")) 
  	{
		String actionID1 = "009";String fromStatusID1="004"; 
		try
		{
			choose_line = "";
			String line_no="",supply_source="";
			String stockArray[][]= StockInfoBean.getArray2DContent();
	
			for (int k=0;k<choice.length;k++)    
			{
				choose_line += (","+choice[k]); 
	
				//Slow Moving Stock - 全部,add by Peggy 20130417
				if (request.getParameter("REASONCODE_"+choice[k])!=null && (request.getParameter("REASONCODE_"+choice[k])).equals("08") && Float.parseFloat(request.getParameter("QTY_"+choice[k]))!=Float.parseFloat((request.getParameter("ALLOTQTY_"+choice[k])==null?"0":request.getParameter("ALLOTQTY_"+choice[k]))))
				{
					Statement statement2=con.createStatement();
					ResultSet rs2=statement2.executeQuery("SELECT MAX(line_no)+1 new_line FROM  oraddman.tsdelivery_notice_detail b where b.DNDOCNO='"+dnDocNo+"' ");
					if (rs2.next())
					{
						line_no = rs2.getString("new_line");
					}
					rs2.close();
					statement2.close();
					
					//create new line
					sql = " INSERT INTO oraddman.tsdelivery_notice_detail"+
						  " (dndocno, line_no, inventory_item_id, item_segment1, quantity, uom, list_price, request_date, ship_date,"+
						  " promise_date, line_type, primary_uom, remark,creation_date, created_by, last_update_date,"+
						  " last_updated_by, assign_manufact, assign_lno,source_type, pccfmdate, ftacpdate, sascodate, orderno,"+
						  " lstatusid, lstatus, selling_price, pcacpdate,item_description, or_lineno, moqp, rerequest_date,"+
						  " sdrq_exceed, ordered_item, ordered_item_id, item_id_type, reason_code, reasondesc, edit_code, cust_po_number,"+
						  " tsc_prod_group, nspq_check, pc_comment, spq, moq, program_name, cust_request_date, shipping_method,"+
						  " order_type_id, fob, autocreate_flag, cust_po_line_no, quote_number, end_customer, orig_line_no,end_customer_id,"+
						  " direct_ship_to_cust"+ 
						  ",BI_REGION,supplier_number)"+
						  " SELECT dndocno, ?,a.inventory_item_id, a.item_segment1,"+
						  " ?, a.uom, a.list_price, a.request_date,case when a.ASSIGN_MANUFACT='006' then a.REQUEST_DATE else  a.ship_date end,"+ 
						  " a.promise_date, a.line_type, a.primary_uom, a.remark,"+
						  " a.creation_date, a.created_by, a.last_update_date,a.last_updated_by, a.assign_manufact, a.assign_lno,"+
						  " a.source_type, a.pccfmdate, a.REQUEST_DATE,"+  
						  " a.sascodate, a.orderno,?, ?, a.selling_price, a.pcacpdate,"+
						  " a.item_description, a.or_lineno, a.moqp, a.rerequest_date,a.sdrq_exceed, a.ordered_item, a.ordered_item_id, a.item_id_type,"+
						  " ?, a.reasondesc, a.edit_code, a.cust_po_number,a.tsc_prod_group, a.nspq_check, a.pc_comment, a.spq, a.moq,"+
						  " a.program_name, a.cust_request_date, a.shipping_method, a.order_type_id, a.fob, a.autocreate_flag, a.cust_po_line_no,"+
						  " a.quote_number, a.end_customer,a.line_no,a.end_customer_id,a.direct_ship_to_cust,a.BI_REGION,a.supplier_number"+
						  " FROM oraddman.tsdelivery_notice_detail a"+
						  " WHERE a.dndocno = ? "+
						  " AND a.line_no =?"+
						  " and a.LSTATUSID=?";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,line_no);
					pstmt.setString(2,(request.getParameter("ALLOTQTY_"+choice[k])==null||request.getParameter("ALLOTQTY_"+choice[k]).equals("")?"0":request.getParameter("ALLOTQTY_"+choice[k])));
					pstmt.setString(3,"008");
					pstmt.setString(4,"CONFIRMED");
					pstmt.setString(5,request.getParameter("REASONCODE_"+choice[k]));
					pstmt.setString(6,dnDocNo);
					pstmt.setString(7,choice[k]);
					pstmt.setString(8,fromStatusID);
					pstmt.executeQuery();
					pstmt.close();

					sql = " insert into  oraddman.tsdelivery_notice_remarks "+
						  " (dndocno, line_no, customer, shipping_marks, remarks,creation_date, created_by, last_update_date,last_updated_by)"+
						  " select dndocno, ?,customer, shipping_marks, remarks,creation_date, created_by, sysdate,last_updated_by"+
						  " from oraddman.tsdelivery_notice_remarks a"+
						  " WHERE exists (select 1 from oraddman.tsdelivery_notice_detail b"+
						  " where b.dndocno =?"+
						  " AND b.line_no =?"+
						  " and b.LSTATUSID=?"+
						  " and b.dndocno=a.dndocno"+
						  " and b.line_no=a.line_no)";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,line_no);
					pstmt.setString(2,dnDocNo);
					pstmt.setString(3,choice[k]);
					pstmt.setString(4,fromStatusID);
					pstmt.executeQuery();
					pstmt.close(); 
						
					sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
						  "(DNDOCNO"+
						  ",ORISTATUSID"+
						  ",ORISTATUS"+
						  ",ACTIONID"+
						  ",ACTIONNAME"+
						  ",UPDATEUSERID"+
						  ",UPDATEDATE"+
						  ",UPDATETIME"+
						  ",ASSIGN_FACTORY"+
						  ",CDATETIME"+
						  ",REMARK"+
						  ",SERIALROW"+
						  ",LINE_NO"+
						  ",PROCESS_WORKTIME"+
						  ",ARRANGED_DATE"+
						  ",PC_REMARK)"+
						  " select a.dndocno"+
						  ",?"+
						  ",(select STATUSNAME from ORADDMAN.TSWFStatus where STATUSID=?)"+
						  ",?"+
						  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
						  ",?"+
						  ",to_char(sysdate,'yyyymmdd')"+
						  ",TO_CHAR(SYSDATE,'hh24miss')"+
						  ",a.ASSIGN_MANUFACT"+
						  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
						  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
						  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=?)"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
						  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
						  " where a.DNDOCNO=?"+
						  " and a.LINE_NO=?"+
						  " and a.LSTATUSID=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,fromStatusID1);
					pstmtDt.setString(2,fromStatusID1);
					pstmtDt.setString(3,actionID1);
					pstmtDt.setString(4,actionID1);
					pstmtDt.setString(5,userID);
					pstmtDt.setString(6,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
					pstmtDt.setString(7,line_no);
					pstmtDt.setString(8,line_no);
					pstmtDt.setString(9,"0");
					pstmtDt.setString(10,request.getParameter("FACTORYDATE_"+choice[k])); 
					pstmtDt.setString(11,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
					pstmtDt.setString(12,dnDocNo);
					pstmtDt.setString(13,choice[k]);
					pstmtDt.setString(14,fromStatusID);
					pstmtDt.executeQuery();
					pstmtDt.close();
	  			} 
				
				sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
					  "(DNDOCNO"+
					  ",ORISTATUSID"+
					  ",ORISTATUS"+
					  ",ACTIONID"+
					  ",ACTIONNAME"+
					  ",UPDATEUSERID"+
					  ",UPDATEDATE"+
					  ",UPDATETIME"+
					  ",ASSIGN_FACTORY"+
					  ",CDATETIME"+
					  ",REMARK"+
					  ",SERIALROW"+
					  ",LINE_NO"+
					  ",PROCESS_WORKTIME"+
					  ",ARRANGED_DATE"+
					  ",PC_REMARK)"+
					  " select a.dndocno"+
					  ",a.lstatusid"+
					  ",a.lstatus"+
					  ",?"+
					  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
					  ",?"+
					  ",to_char(sysdate,'yyyymmdd')"+
					  ",TO_CHAR(SYSDATE,'hh24miss')"+
					  ",a.ASSIGN_MANUFACT"+
					  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+ //modify by Peggy 20201112
					  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no)"+
					  ",a.line_no"+
					  ",(select round((sysdate-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no and x.ORISTATUSID ='002')"+
					  ",?"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
					  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
					  " where a.DNDOCNO=?"+
					  " and a.LINE_NO=?"+
					  " and a.LSTATUSID=?";
				//out.println(sql);	
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,actionID);
				pstmtDt.setString(2,actionID);
				pstmtDt.setString(3,userID);
				pstmtDt.setString(4,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
				pstmtDt.setString(5,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				pstmtDt.setString(6,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
				pstmtDt.setString(7,dnDocNo);
				pstmtDt.setString(8,choice[k]);
				pstmtDt.setString(9,fromStatusID);
				pstmtDt.executeQuery();
				pstmtDt.close();
				
				supply_source="";
				if (stockArray!=null)
				{	
					for( int j=0 ; j< stockArray.length ; j++ ) 
					{
						if (stockArray[j][0].equals(dnDocNo) && stockArray[j][1].equals(choice[k]))
						{
							if (stockArray[j][2].equals("Y"))
							{
								supply_source="STOCK";
								sql = " update tsc_po_unallocated"+
									  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+(?*1000)"+
									  " where organization_id=?"+
									  " and inventory_item_id=?"+
									  " and type_id=?"+
									  " and po_line_location_id is null";
								//out.println(sql);
								pstmt=con.prepareStatement(sql);
								pstmt.setString(1,request.getParameter("QTY_"+choice[k]));
								pstmt.setString(2,stockArray[j][8]);
								pstmt.setString(3,stockArray[j][7]);
								pstmt.setString(4,"3");
								pstmt.executeUpdate(); 
								pstmt.close();  
								break; 
							}
							else if (stockArray[j][3].equals("Y"))
							{
								supply_source="PO";
								//ship_qty = Long.parseLong(request.getParameter("QTY_"+choice[k])) *1000;
								ship_qty = Long.parseLong(""+Math.round(Double.parseDouble(request.getParameter("QTY_"+choice[k])) *1000));  //modify by Peggy 20201116								
								allot_qty =0;
								
								sql = " select po_unallocated_id,nvl(quantity,0)-nvl(rfq_allocated_quantity,0) unallot_qty "+
									  " from tsc_po_unallocated a"+
									  " where organization_id=?"+
									  " and inventory_item_id=?"+
									  " and type_id<>?"+
									  " and po_line_location_id is not null"+
									  " and nvl(quantity,0)-nvl(rfq_allocated_quantity,0)>0"+
									  " order by need_by_date";
								//out.println(sql);
								PreparedStatement statementx = con.prepareStatement(sql);
								statementx.setString(1,stockArray[j][8]);
								statementx.setString(2,stockArray[j][7]);
								statementx.setString(3,"3");
								ResultSet rsx=statementx.executeQuery();	
								while(rsx.next())
								{											  
									if (rsx.getInt("unallot_qty")>=ship_qty)
									{
										allot_qty = ship_qty;
									}
									else
									{
										allot_qty =rsx.getLong("unallot_qty"); 	
									}
									ship_qty -= allot_qty;
									
									sql = " update tsc_po_unallocated"+
										  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+?"+
										  " where po_unallocated_id=?";
									//out.println(sql);
									pstmt=con.prepareStatement(sql);
									pstmt.setString(1,""+allot_qty);
									pstmt.setString(2,rsx.getString("po_unallocated_id"));
									pstmt.executeUpdate(); 
									pstmt.close(); 
									
									if (ship_qty<=0) break;
								}
								rsx.close();
								statementx.close();	
								break;																			
							}
						}
					}
				}
				
				if (supply_source.equals("STOCK"))
				{
					sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
						  "(DNDOCNO"+
						  ",ORISTATUSID"+
						  ",ORISTATUS"+
						  ",ACTIONID"+
						  ",ACTIONNAME"+
						  ",UPDATEUSERID"+
						  ",UPDATEDATE"+
						  ",UPDATETIME"+
						  ",ASSIGN_FACTORY"+
						  ",CDATETIME"+
						  ",REMARK"+
						  ",SERIALROW"+
						  ",LINE_NO"+
						  ",PROCESS_WORKTIME"+
						  ",ARRANGED_DATE"+
						  ",PC_REMARK)"+
						  " select a.dndocno"+
						  ",?"+
						  ",(select STATUSNAME from ORADDMAN.TSWFSTATUS where STATUSID=?)"+
						  ",?"+
						  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
						  ",?"+
						  ",to_char(sysdate,'yyyymmdd')"+
						  ",TO_CHAR(SYSDATE,'hh24miss')"+
						  ",a.ASSIGN_MANUFACT"+
						  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
						  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
						  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no)"+
						  ",a.line_no"+
						  ",(select round((sysdate-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no and x.ORISTATUSID ='003')"+
						  ",?"+
						  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
						  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
						  " where a.DNDOCNO=?"+
						  " and a.LINE_NO=?"+
						  " and a.LSTATUSID=?";
					//out.println(sql);	
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,fromStatusID1);
					pstmtDt.setString(2,fromStatusID1);
					pstmtDt.setString(3,actionID1);
					pstmtDt.setString(4,actionID1);
					pstmtDt.setString(5,userID);
					pstmtDt.setString(6,"");
					pstmtDt.setString(7,""); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
					pstmtDt.setString(8,"SG Forecast Stock");
					pstmtDt.setString(9,dnDocNo);
					pstmtDt.setString(10,choice[k]);
					pstmtDt.setString(11,fromStatusID);
					pstmtDt.executeQuery();
					pstmtDt.close();
				}
				
				sql = " select tsc_rfq_recheck_ssd(a.DNDOCNO,a.LINE_NO,to_char(to_date(?,'yyyymmdd')+nvl(?,0),'yyyymmdd'),?,nvl(a.ORDER_TYPE_ID,(select x.ORDER_TYPE_ID from oraddman.tsdelivery_notice x where x.dndocno=?))) from oraddman.tsdelivery_notice_detail a where a.dndocno=? and a.line_no=?";//modify by Peggy 20200930
				PreparedStatement statementb = con.prepareStatement(sql);
				statementb.setString(1,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				statementb.setString(2,request.getParameter("totw_days_"+choice[k])); // 回T天數
				statementb.setString(3,request.getParameter("totw_days_"+choice[k])); // 回T天數
				statementb.setString(4,dnDocNo);
				statementb.setString(5,dnDocNo);
				statementb.setString(6,choice[k]);
				ResultSet rsb=statementb.executeQuery();	
				if (rsb.next())
				{	
					v_new_ssd = rsb.getString(1);
				}
				else
				{
					v_new_ssd = "ERROR";
				}
				rsb.close();
				statementb.close();
								
				//Slow Moving Stock - 全部,add by Peggy 20130417
				if (request.getParameter("REASONCODE_"+choice[k])!=null && (request.getParameter("REASONCODE_"+choice[k])).equals("08") && Float.parseFloat(request.getParameter("QTY_"+choice[k]))==Float.parseFloat((request.getParameter("ALLOTQTY_"+choice[k])==null?"0":request.getParameter("ALLOTQTY_"+choice[k]))))
				{	
					sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
					" set FTACPDATE=?"+
					",LAST_UPDATED_BY=?"+
					",LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
					",LSTATUSID=?"+
					",LSTATUS=?"+
					//",SHIP_DATE=to_char(to_date(?,'yyyymmdd')+nvl(?,0),'yyyymmdd') "+
					//",SHIP_DATE=tsc_rfq_recheck_ssd(a.DNDOCNO,a.LINE_NO,to_char(to_date(?,'yyyymmdd')+nvl(?,0),'yyyymmdd'),?,nvl(a.ORDER_TYPE_ID,(select x.ORDER_TYPE_ID from oraddman.tsdelivery_notice x where x.dndocno=?)))"+//modify by Peggy 20200930
					",SHIP_DATE=?"+ //modify by Peggy 20200930
					",REASON_CODE=?"+
					",REASONDESC=UTL_I18N.UNESCAPE_REFERENCE(?)"+  //moidfy by Peggy 20201112
					",PC_COMMENT=UTL_I18N.UNESCAPE_REFERENCE(PC_COMMENT||case when length(PC_COMMENT)>0 then ',' else '' end ||'Slow Moving '||NVL(?,0)||'K') "+   //moidfy by Peggy 20201112
					" where a.DNDOCNO=?"+
					" and a.LINE_NO=?"+
					" and a.LSTATUSID=?";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,request.getParameter("FACTORYDATE_"+choice[k])); // 設定的工廠確認日期 + 時間     
					pstmt.setString(2,userID); // 最後更新人員 
					pstmt.setString(3,"008");
					pstmt.setString(4,"CONFIRMED");
					//pstmt.setString(5,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
					//pstmt.setString(6,request.getParameter("totw_days_"+choice[k])); // 回T天數
					//pstmt.setString(7,request.getParameter("totw_days_"+choice[k])); // 回T天數
					//pstmt.setString(8,dnDocNo);
					pstmt.setString(5,v_new_ssd);
					pstmt.setString(6,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(7,(request.getParameter("REASON_"+choice[k])==null||request.getParameter("REASON_"+choice[k]).equals("--")?"":request.getParameter("REASON_"+choice[k])));
					pstmt.setString(8,(request.getParameter("ALLOTQTY_"+choice[k])==null||request.getParameter("ALLOTQTY_"+choice[k]).equals("")?"0":request.getParameter("ALLOTQTY_"+choice[k])));
					pstmt.setString(9,dnDocNo);
					pstmt.setString(10,choice[k]);
					pstmt.setString(11,fromStatusID);
					pstmt.executeQuery();
					pstmt.close();   
				
				}
				else
				{							
					sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
					" set FTACPDATE=?"+
					",LAST_UPDATED_BY=?"+
					",LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
					",LSTATUSID=case when ?=? then ? else ? end "+
					",LSTATUS=case when ?=? then ? else ? end"+
					//",SHIP_DATE=to_char(to_date(?,'yyyymmdd')+nvl(?,0),'yyyymmdd') "+
					",SHIP_DATE=?"+  //modify by Peggy 20200930
					",REASON_CODE=case when ?='08' then '00' else ? end"+
					",REASONDESC=UTL_I18N.UNESCAPE_REFERENCE(case when ?='08' then 'N/A' else ? end)"+
					",PC_COMMENT=UTL_I18N.UNESCAPE_REFERENCE(PC_COMMENT||?||case when ?='08' then case when length(PC_COMMENT)>0 then ',' else '' end ||'已轉Slow Moving '||NVL(?,0)||'K' else '' end)"+
					",SLOW_MOVING_ALLOT_QTY=?"+
					",QUANTITY=QUANTITY-?"+
					",SUPPLY_SOURCE=?"+
					" where a.DNDOCNO=?"+
					" and a.LINE_NO=?"+
					" and a.LSTATUSID=?";
					//out.println(sql);
					//out.println(request.getParameter("FACTORYDATE_"+choice[k]));
					//out.println(userID);
					//out.println(sToStatusID);
					//out.println(sToStatusName);
					//out.println(request.getParameter("FACTORYDATE_"+choice[k]));
					//out.println(request.getParameter("TOTW_DAYS_"+choice[k]));
					//out.println(request.getParameter("REASONCODE_"+choice[k]));
					//out.println(request.getParameter("REASON_"+choice[k]));
					//out.println(request.getParameter("ALLOTQTY_"+choice[k]));
					//out.println(sql);	
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1,request.getParameter("FACTORYDATE_"+choice[k])); // 設定的工廠確認日期 + 時間     
					pstmt.setString(2,userID); // 最後更新人員 
					pstmt.setString(3,supply_source);
					pstmt.setString(4,"STOCK");
					pstmt.setString(5,"008");
					pstmt.setString(6,sToStatusID);
					pstmt.setString(7,supply_source);
					pstmt.setString(8,"STOCK");
					pstmt.setString(9,"CONFIRMED");
					pstmt.setString(10,sToStatusName);
					//pstmt.setString(11,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
					//pstmt.setString(12,request.getParameter("totw_days_"+choice[k])); // 回T天數
					pstmt.setString(11,v_new_ssd); //modify by Peggy 20200930
					pstmt.setString(12,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(13,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(14,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(15,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"N/A":request.getParameter("REASON_"+choice[k])));
					pstmt.setString(16,(request.getParameter("REASON_"+choice[k])==null||request.getParameter("REASON_"+choice[k]).equals("--")?"":request.getParameter("REASON_"+choice[k])));
					pstmt.setString(17,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
					pstmt.setString(18,(request.getParameter("ALLOTQTY_"+choice[k])==null||request.getParameter("ALLOTQTY_"+choice[k]).equals("")?"0":request.getParameter("ALLOTQTY_"+choice[k])));
					pstmt.setString(19,(request.getParameter("ALLOTQTY_"+choice[k])==null||request.getParameter("ALLOTQTY_"+choice[k]).equals("")?"0":request.getParameter("ALLOTQTY_"+choice[k])));
					pstmt.setString(20,(request.getParameter("ALLOTQTY_"+choice[k])==null||request.getParameter("ALLOTQTY_"+choice[k]).equals("")?"0":request.getParameter("ALLOTQTY_"+choice[k])));
					pstmt.setString(21,supply_source);
					pstmt.setString(22,dnDocNo);
					pstmt.setString(23,choice[k]);
					pstmt.setString(24,fromStatusID);
					pstmt.executeQuery();
					pstmt.close();   
				}
	 		} 
			//Step4. 再更新交期詢問主檔資料
			sql=" update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=to_char(sysdate,'yyyymmddhh24miss'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss') "+
			    " where DNDOCNO='"+dnDocNo+"' ";     
			pstmt=con.prepareStatement(sql);         
			pstmt.setString(1,userID); // 最後更新人員
			pstmt.executeQuery();
			pstmt.close();      
	
			//add by Peggy 20130412
			if (!choose_line.equals(""))
			{
				CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.SLOW_MOVING_STOCK_EMAIL_NOTICE(?,?)}");			 
				cs3.setString(1,dnDocNo); 
				cs3.setString(2,choose_line+","); 
				cs3.execute();
				cs3.close();			
				
				//add by Peggy 20191120
				cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.FORECAST_STOCK_EMAIL_NOTICE(?,?)}");			 
				cs3.setString(1,dnDocNo); 
				cs3.setString(2,choose_line+","); 
				cs3.execute();
				cs3.close();			
				
			}	
			con.commit();
		}
		catch(Exception e)
		{
			errCnt++;	
			con.rollback();
			out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"</font>");
		}			
  	} 
	
  	//若為企劃交期回覆已確認(RESPONSE)_起 (ACTION=009)
  	if (actionID.equals("009")) 
  	{    
		try
		{
			String supply_source="";
			choose_line = "";
			String stockArray[][]= StockInfoBean.getArray2DContent();
		
			for (int k=0;k<choice.length;k++)    
			{
				//add by Peggy 20150114
				over_lead_time_reason=request.getParameter("OVER_LT_"+choice[k]);
				if (over_lead_time_reason==null) over_lead_time_reason="";
				choose_line += (","+choice[k]); 
				supply_source="";
				
				if (stockArray!=null)
				{	
					for( int j=0 ; j< stockArray.length ; j++ ) 
					{
						if (stockArray[j][0].equals(dnDocNo) && stockArray[j][1].equals(choice[k]))
						{
							if (stockArray[j][2].equals("Y"))
							{
								supply_source="STOCK";
								sql = " update tsc_po_unallocated"+
									  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+(?*1000)"+
									  " where organization_id=?"+
									  " and inventory_item_id=?"+
									  " and type_id=?"+
									  " and po_line_location_id is null";
								//out.println(sql);
								pstmt=con.prepareStatement(sql);
								pstmt.setString(1,request.getParameter("QTY_"+choice[k]));
								pstmt.setString(2,stockArray[j][8]);
								pstmt.setString(3,stockArray[j][7]);
								pstmt.setString(4,"3");
								pstmt.executeUpdate(); 
								pstmt.close();   
							}
							else if (stockArray[j][3].equals("Y"))
							{
								supply_source="PO";
								//ship_qty = Long.parseLong(request.getParameter("QTY_"+choice[k])) *1000;
								ship_qty = Long.parseLong(""+Math.round(Double.parseDouble(request.getParameter("QTY_"+choice[k])) *1000));  //modify by Peggy 20201116								
								allot_qty =0;
								
								sql = " select po_unallocated_id,nvl(quantity,0)-nvl(rfq_allocated_quantity,0) unallot_qty "+
									  " from tsc_po_unallocated a"+
									  " where organization_id=?"+
									  " and inventory_item_id=?"+
									  " and type_id<>?"+
									  " and po_line_location_id is not null"+
									  " and nvl(quantity,0)-nvl(rfq_allocated_quantity,0)>0"+
									  " order by need_by_date";
								//out.println(sql);
								PreparedStatement statementx = con.prepareStatement(sql);
								statementx.setString(1,stockArray[j][8]);
								statementx.setString(2,stockArray[j][7]);
								statementx.setString(3,"3");
								ResultSet rsx=statementx.executeQuery();	
								while(rsx.next())
								{											  
									if (rsx.getInt("unallot_qty")>=ship_qty)
									{
										allot_qty = ship_qty;
									}
									else
									{
										allot_qty =rsx.getLong("unallot_qty"); 	
									}
									ship_qty -= allot_qty;
									
									sql = " update tsc_po_unallocated"+
										  " set rfq_allocated_quantity=nvl(rfq_allocated_quantity,0)+?"+
										  " where po_unallocated_id=?";
									//out.println(sql);
									pstmt=con.prepareStatement(sql);
									pstmt.setString(1,""+allot_qty);
									pstmt.setString(2,rsx.getString("po_unallocated_id"));
									pstmt.executeUpdate(); 
									pstmt.close(); 
									
									if (ship_qty<=0) break;
								}
								rsx.close();
								statementx.close();																				
							//}
							//else if (stockArray[j][4].equals("Y"))
							//{
							//	vendor_site_id = stockArray[j][5];
							//	vendor_ssd=	stockArray[j][6];								
							}
						}
					}
				}
				
		
				sql = "insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY"+
					  "(DNDOCNO"+
					  ",ORISTATUSID"+
					  ",ORISTATUS"+
					  ",ACTIONID"+
					  ",ACTIONNAME"+
					  ",UPDATEUSERID"+
					  ",UPDATEDATE"+
					  ",UPDATETIME"+
					  ",ASSIGN_FACTORY"+
					  ",CDATETIME"+
					  ",REMARK"+
					  ",SERIALROW"+
					  ",LINE_NO"+
					  ",PROCESS_WORKTIME"+
					  ",ARRANGED_DATE"+
					  ",PC_REMARK"+
					  ",VENDOR_SITE_ID"+
					  ",VENDOR_SSD)"+
					  " select a.dndocno"+
					  ",a.lstatusid"+
					  ",a.lstatus"+
					  ",?"+
					  ",(select ACTIONNAME from ORADDMAN.TSWFACTION where ACTIONID=?)"+
					  ",?"+
					  ",to_char(sysdate,'yyyymmdd')"+
					  ",TO_CHAR(SYSDATE,'hh24miss')"+
					  ",a.ASSIGN_MANUFACT"+
					  ",TO_CHAR(SYSDATE,'yyyymmddhh24miss')"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
					  ",(select count(1)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no)"+
					  ",a.line_no"+
					  ",(select round((sysdate-to_date(CDATETIME,'yyyymmddhh24miss'))*24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.dndocno=a.dndocno and x.line_no=a.line_no and x.ORISTATUSID ='003')"+
					  ",?"+
					  ",UTL_I18N.UNESCAPE_REFERENCE(?)"+ //modify by Peggy 20201112
					  ",?"+
					  ",?"+
					  " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
					  " where a.DNDOCNO=?"+
					  " and a.LINE_NO=?"+
					  " and a.LSTATUSID=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,actionID);
				pstmtDt.setString(2,actionID);
				pstmtDt.setString(3,userID);
				pstmtDt.setString(4,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k])));
				pstmtDt.setString(5,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				pstmtDt.setString(6,(request.getParameter("REASON_"+choice[k])==null?(request.getParameter("PROC_REMARK")==null?"":request.getParameter("PROC_REMARK")):request.getParameter("REASON_"+choice[k]))+ (supply_source.equals("STOCK")?"SG Forecast Stock":""));
				pstmtDt.setString(7,"");
				pstmtDt.setString(8,"");
				pstmtDt.setString(9,dnDocNo);
				pstmtDt.setString(10,choice[k]);
				pstmtDt.setString(11,fromStatusID);
				pstmtDt.executeQuery();
				pstmtDt.close();				
				
				sql = " select tsc_rfq_recheck_ssd(a.DNDOCNO,a.LINE_NO,to_char(to_date(?,'yyyymmdd')+(nvl(?,0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id=?),1)),'yyyymmdd'),(nvl(?,0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id=?),1)),nvl(a.ORDER_TYPE_ID,(select x.ORDER_TYPE_ID from oraddman.tsdelivery_notice x where x.dndocno=?))) from oraddman.tsdelivery_notice_detail a where a.dndocno=? and a.line_no=?";//modify by Peggy 20200930
				PreparedStatement statementb = con.prepareStatement(sql);
				statementb.setString(1,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				statementb.setString(2,request.getParameter("totw_days_"+choice[k])); // 回T天數
				statementb.setString(3,(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k])));        
				statementb.setString(4,request.getParameter("totw_days_"+choice[k])); // 回T天數
				statementb.setString(5,(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k])));        
				statementb.setString(6,dnDocNo);
				statementb.setString(7,dnDocNo);
				statementb.setString(8,choice[k]);
				ResultSet rsb=statementb.executeQuery();	
				if (rsb.next())
				{	
					v_new_ssd = rsb.getString(1);
				}
				else
				{
					v_new_ssd = "ERROR";
				}
				rsb.close();
				statementb.close();
							
				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
				" set a.LAST_UPDATED_BY=?"+
				",a.LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss')"+
				",a.LSTATUSID=?"+
				",a.LSTATUS=?"+
				",a.VENDOR_SITE_ID=?"+
				",a.VENDOR_SSD=?"+
				",a.PC_OVER_LEADTIME_REASON=? "+
			    ",a.FTACPDATE=to_char(to_date(?,'yyyymmdd'),'yyyymmdd')"+
				//",a.SHIP_DATE=to_char(to_date(?,'yyyymmdd')+nvl(?,0),'yyyymmdd') "+
				//",a.SHIP_DATE=to_char(to_date(?,'yyyymmdd')+(nvl(?,0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id=?),1)),'yyyymmdd') "+
				",SHIP_DATE=?"+//modify by Peggy 20200930
				",a.REASON_CODE= ? "+
				",a.REASONDESC=UTL_I18N.UNESCAPE_REFERENCE(?)"+  //modify by Peggy 20201112
				",a.PC_COMMENT=UTL_I18N.UNESCAPE_REFERENCE(case when A.ASSIGN_MANUFACT='006' THEN null ELSE PC_COMMENT END ||?)"+  //modify by Peggy 20201112
				",a.SUPPLY_SOURCE=?"+
			    " where a.DNDOCNO=?"+
				" and a.LINE_NO=?"+
				" and a.LSTATUSID=?";	
				//out.println(sql);		
				//out.println("tsc_rfq_recheck_ssd(a.DNDOCNO,a.LINE_NO,to_char(to_date('"+request.getParameter("FACTORYDATE_"+choice[k])+"','yyyymmdd')+(nvl("+request.getParameter("totw_days_"+choice[k])+",0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id='"+(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k]))+"'),1)),'yyyymmdd'),(nvl("+request.getParameter("totw_days_"+choice[k])+",0)* nvl((select '0' from oraddman.tssg_vendor_tw a where active_flag='A' and a.vendor_site_id='"+(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k]))+"'),1)),nvl(a.ORDER_TYPE_ID,(select x.ORDER_TYPE_ID from oraddman.tsdelivery_notice x where x.dndocno='"+dnDocNo+"')))");	
				pstmt=con.prepareStatement(sql);          
				pstmt.setString(1,userID); // 最後更新人員 
				pstmt.setString(2,sToStatusID);
				pstmt.setString(3,sToStatusName);
				pstmt.setString(4,(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"":request.getParameter("VENDOR_SITE_ID_"+choice[k])));        
				pstmt.setString(5,(request.getParameter("VENDOR_SSD_"+choice[k])==null?"0":request.getParameter("VENDOR_SSD_"+choice[k])));          
				pstmt.setString(6,over_lead_time_reason);
				pstmt.setString(7,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				//pstmt.setString(8,request.getParameter("FACTORYDATE_"+choice[k])); // 預設將工廠排定日期設定為Schedule Shipment Date + 時間  
				//pstmt.setString(9,request.getParameter("totw_days_"+choice[k])); // 回T天數
				//pstmt.setString(10,(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k])));        
				//pstmt.setString(11,request.getParameter("totw_days_"+choice[k])); // 回T天數
				//pstmt.setString(12,(request.getParameter("VENDOR_SITE_ID_"+choice[k])==null?"0":request.getParameter("VENDOR_SITE_ID_"+choice[k])));        
				//pstmt.setString(13,dnDocNo);
				pstmt.setString(8,v_new_ssd);				
				pstmt.setString(9,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"00":request.getParameter("REASONCODE_"+choice[k])));
				pstmt.setString(10,(request.getParameter("REASONCODE_"+choice[k])==null||request.getParameter("REASONCODE_"+choice[k]).equals("--")?"N/A":request.getParameter("REASON_"+choice[k])));
				pstmt.setString(11,(request.getParameter("REASON_"+choice[k])==null?"":request.getParameter("REASON_"+choice[k])));
				pstmt.setString(12,supply_source);
				pstmt.setString(13,dnDocNo);
				pstmt.setString(14,choice[k]);
				pstmt.setString(15,fromStatusID);
				pstmt.executeQuery();
				pstmt.close();  				
	 		} 

			sql=" update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=to_char(sysdate,'yyyymmddhh24miss'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=to_char(sysdate,'yyyymmddhh24miss') "+
			    " where DNDOCNO='"+dnDocNo+"' ";     
			pstmt=con.prepareStatement(sql);
			pstmt.setString(1,userID); // 最後更新人員
			pstmt.executeQuery();
			pstmt.close();      
			
			if (!choose_line.equals(""))
			{
				//add by Peggy 20191120
				CallableStatement cs3 = con.prepareCall("{call TSC_RFQ_CREATE_ERP_ODR_PKG.FORECAST_STOCK_EMAIL_NOTICE(?,?)}");			 
				cs3.setString(1,dnDocNo); 
				cs3.setString(2,choose_line+","); 
				cs3.execute();
				cs3.close();			
			}			
			con.commit();
		}
		catch(Exception e)
		{	
			errCnt++;
			con.rollback();
			out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"</font>");
		}				
	   
  	}
    
	if (errCnt==0) 
	{
		int deliveryCount = 0;
		Statement stateDeliveryCNT=con.createStatement(); 
		ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+dnDocNo+"' ");
		if (rsDeliveryCNT.next())
		{
			deliveryCount = rsDeliveryCNT.getInt(1);
		}
		rsDeliveryCNT.close();
		stateDeliveryCNT.close();
		
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
		if (rs.next())
		{
			actionName=rs.getString("ACTIONNAME");
		}
		rs.close();	
		//statement.close();
	   
		rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
		if (rs.next())
		{
			oriStatus=rs.getString("STATUSNAME");
		}
		rs.close();	
		statement.close();
		
		String historySql="insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,"+
		"ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		"values(?,?,?,?,?,?,to_char(sysdate,'yyyymmdd'),to_char(sysdate,'hh24miss'),?,to_char(sysdate,'yyyymmddhh24miss'),?,?) ";
		PreparedStatement historystmt=con.prepareStatement(historySql);   
		historystmt.setString(1,dnDocNo); 
		historystmt.setString(2,fromStatusID); 
		historystmt.setString(3,oriStatus); //寫入status名稱
		historystmt.setString(4,actionID); 
		historystmt.setString(5,actionName); 
		historystmt.setString(6,userID); 
		historystmt.setString(7,prodCodeGet); //寫入工廠編號
		historystmt.setString(8,remark); // 本次處理說明欄位
		historystmt.setInt(9,deliveryCount);		
		historystmt.executeUpdate();   
		historystmt.close(); 
		out.println("<BR>Processing Sales Delivery Request value(RFQ NO.:<A HREF='TSSalesDRQDisplayPage.jsp?DNDOCNO="+dnDocNo+"'><font color=#FF0000>"+dnDocNo+"</font></A>) OK!");
		out.println("<BR>");
		out.println("<A HREF='../OraddsMainMenu.jsp'>");%><font size="2"><jsp:getProperty name="rPH" property="pgHOME"/></font><%out.println("</A>");
	}
		
	String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	PreparedStatement pstmt2=con.prepareStatement(sql2);
	pstmt2.executeUpdate(); 
	pstmt2.close();	

} //end of try
catch (Exception e)
{
	e.printStackTrace();
   	out.println("<font color='#ff0000'>Update Fail!!~" + e.getMessage()+"</font>");
}
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0" >
	<tr>
    	<td width="278"><font size="2"><jsp:getProperty name="rPH" property="pgDRQDocProcess"/></font></td>
    	<td width="297"><font size="2"><jsp:getProperty name="rPH" property="pgDRQInquiryReport"/></font></td>    
  	</tr>
		<%
		String MODEL = "'D1','D2'",FMODULE=""; 
		String ADDRESS ="",PROGRAMMERNAME="";
		int icnt =0; 
  		try  
  		{ 
			Statement statement=con.createStatement();
    		ResultSet rs=statement.executeQuery("SELECT DISTINCT FMODULE,FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER "+
			" WHERE FMODULE IN ("+MODEL+") AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 "+
			" AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"')"+
			(actionID.equals("009") && !TSC_PACKAGE.equals("")?" AND FSEQ=4 AND FMODULE='D1'" :"")+" ORDER BY FMODULE,FSEQ ");    	
    		while(rs.next())
    		{
      			ADDRESS = rs.getString("FADDRESS");
				PROGRAMMERNAME= rs.getString("FDESC");
				if (!FMODULE.equals(rs.getString("FMODULE")))
				{	
					if (icnt ==0) out.println("<tr>");
					if (icnt !=0) out.println("</table></td>");
					out.println("<td><table width='100%' border='0' cellpadding='0' cellspacing='0'>");
					FMODULE=rs.getString("FMODULE");
				}
				out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
				icnt++;
			}
      		rs.close(); 
	  		statement.close();
  		} //end of try
  		catch (Exception e)
  		{
	  		e.printStackTrace();
      		out.println(e.getMessage());
  		}//end of catch  
  		if (icnt >0) out.println("</table></td></tr>");   
		%>   
</table>
	<%
	if (actionID.equals("009") && !TSC_PACKAGE.equals(""))
	{
		ADDRESS+="&TSC_PACKAGE="+TSC_PACKAGE;
	%>
		<script language="JavaScript" type="text/JavaScript">
		if (confirm("是否要繼續ConfirmRFQ?"))
		{
			document.location.href="<%=ADDRESS%>";
		}
		</script>	
	<%
	}
	%>
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
