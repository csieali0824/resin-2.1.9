<!--20151028 liling 修正lastupdateby ,tsc_family -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<title></title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}             
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function historyByDOCNO(pp)
{   
  subWin=window.open("TSCMfgWOHistoryDetail.jsp?INSPLOTNO="+pp,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function historyByCust(pp,qq,rr)
{   
  subWin=window.open("TSSDRQInformationQuery.jsp?CUSTOMERNO="+pp+"&CUSTOMERNAME="+qq+"&DATESETBEGIN=20000101"+"&DATESETEND=20991231"+"&CUSTOMERID="+rr,"subwin");  
}
function resultOfDOAP(repno,svrtypeno)
{   
  subWin=window.open("../jsp/subwindow/DOAPResultQuerySubWindow.jsp?REPNO="+repno+"&SVRTYPENO="+svrtypeno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function IQCInspectDetailHistQuery(inspLotNo,lineNo)
{     
    subWin=window.open("../jsp/TSIQCInspectLotHistoryDetail.jsp?INSPLOTNO="+inspLotNo+"&LINENO="+lineNo,"subwin","width=800,height=480,scrollbars=yes,menubar=no");    	
}
function ExpandBasicInfoDisplay(expand)
{       
 //alert("URL="+location.href);
 //alert("length="+location.href.indexOf("EXPAND")); 
 var subURL = location.href.substring(0,location.href.indexOf("EXPAND")-1); 
 //alert("subURL="+subURL);
 var URL = location.href;
 if (location.href.indexOf("EXPAND")<0)
 {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=URL+"&EXPAND="+expand;  
		  } else { 
                  document.DISPLAYREPAIR.action=URL+"&EXPAND="+expand;
				 }
 } else {
          if (expand=="OPEN")
		  { 
		    document.DISPLAYREPAIR.action=subURL+"&EXPAND="+expand; 
		  }
		  else
		  {
		   document.DISPLAYREPAIR.action=subURL+"&EXPAND="+expand;
		  }
        }
 //alert("LAST URL="+location.href);
 window.document.DISPLAYREPAIR.submit();
}
function popMenuMsg(itemDesc)
{
 alert("台半料號:"+itemDesc);
}
function popPrevOpMsg(prevOp)
{
 alert("前一站:"+prevOp);
}
function popNextOpMsg(nextOp)
{
 alert("下一站:"+nextOp);
}
</script>
<%
    String hostInfo=request.getRequestURL().toString();//REMOTE_HOST包含網址及應用程式名
    //out.println(hostInfo);

    String expand=request.getParameter("EXPAND");
	String organizationId = "";  // 單據的隸屬Organization_ID
    String statusId="",lstatusId="",lstatus="",lstatusDesc=""; // ??????? HeadQueryAllStatus????
	String workOrderId="",completeDate="",woRemark="",creationDate="",createdBy="",frStatID="040",statusid="",waferLotNo="";
	String waferSize="",marketCode="",woTypeCode="",status="",classID="",createdName="",creationTime="",releaseDate="";
	String jobType =""; // 標準/非標準工單(discrete/rework) Job
	String entityId="", primaryItemID = "", routingSequenceID="",wipEntityId="",waferUsedPce="";  // 主要判斷BOM_ROUTING的變數
	String alternateRouting="",alternateRoutingDesignator="",alternateRoutingDesc="";// 
	String lastUpdateDate="",lastUpdateBy="",waferAmp="",diceSize="",compSubInv="",lastUpdateName="";
	String waferResults=request.getParameter("RESULTS");
	String orderQty=request.getParameter("ORDERQTY");
	String orderUom=request.getParameter("ORDERUOM");
	
	String custLotFlag=request.getParameter("CUSTLOTFLAG"); // 2007/08/13 客戶批號旗標
	String custLot=request.getParameter("CUSTLOT"); // 2007/08/13 客戶批號 0 : 無客戶特殊批號, 1 : 客戶特殊批號
	String custLotNoPrefix=request.getParameter("CUSTLOTNOPREFIX"); // 2007/08/13 客戶批號前置碼
	
    String Limited="",altBillDesc="",supplierLotNo="",lotNo=""; 	
	String lineNum="",schShipDate="",custPartNo="",endCustName=""; // 2007/02/04 加入顯示訂單項次資訊1.1, 2.1 ...
	String overPercent="", overQuantity=""; // 2007/04/10 取出工令之超額完工資訊
	String woRemainQty="", woCompleteQty="", woScrapQty="", completeSubInv=""; // 2007/04/10 增加詳細工令參考資訊於基本資訊頁面

	if (expand==null) expand = "CLOSE";
	
	//判斷工令與Oracle是否一致_起
	 String mfgWipEntityID = "";
	 String jobEntityID = null;
	 boolean jobExists = false;
	 String sqlJob = " select a.WIP_ENTITY_ID, b.WIP_ENTITY_ID "+
	                " from APPS.YEW_WORKORDER_ALL a, WIP_DISCRETE_JOBS b, WIP_ENTITIES c "+
	                " where a.WO_NO = c.WIP_ENTITY_NAME and b.WIP_ENTITY_ID= c.WIP_ENTITY_ID "+
					"   and a.WO_NO='"+woNo+"' " ;
	 //out.print("sqlJob="+sqlJob);
	 Statement stateJob=con.createStatement();
     ResultSet rsJob=stateJob.executeQuery(sqlJob);
	 if (rsJob.next())
	 {
		mfgWipEntityID = rsJob.getString(1); // 表示先前Entity_id取錯或未取到
		jobEntityID = rsJob.getString(2);
		jobExists = true;
		
		if (mfgWipEntityID==null || mfgWipEntityID.equals("")) mfgWipEntityID = "";		
	 } 
	 rsJob.close();
     stateJob.close(); 
	 
	 
	 if (jobExists && !mfgWipEntityID.equals(jobEntityID))  // 已存在Oracle工令,但與MFG 產生的工令不一致,則更新
	 {  
	    // 工令下的流程卡對應Wip_Entity_id 更新_起
	    String woSql=" update APPS.YEW_RUNCARD_ALL set WIP_ENTITY_ID=? "+ 	             
	                 " where WO_NO = '"+woNo+"' "; 					
        PreparedStatement wostmt=con.prepareStatement(woSql);	        
        wostmt.setInt(1,Integer.parseInt(jobEntityID)); 	 
        wostmt.executeUpdate();   
        wostmt.close(); 
	    // 工令下的流程卡對應Wip_Entity_id 更新_迄
	 
	     // 工令的主檔也一併更新_起	
	     //out.println();
	     String woUpSql=" update APPS.YEW_WORKORDER_ALL set WIP_ENTITY_ID=? "+ 	             
	               " where WO_NO = '"+woNo+"' "; 	
	    // out.println(woUpSql);			
         PreparedStatement woUpstmt=con.prepareStatement(woUpSql);	        
         woUpstmt.setInt(1,Integer.parseInt(jobEntityID)); 	
         woUpstmt.executeUpdate();   
         woUpstmt.close(); 
	     // 工令的主檔也一併更新_迄	 
		 
		 con.commit(); // Commit 這個更新
	 }
   //判斷工令與Oracle是否一致_迄
  
	//
	
	


//String dateCurrent = dateBean.getYearMonthDay();

//out.println("1");

      try
      {      	
	   Statement docstatement=con.createStatement();
	   //out.println("select * from ORADDMAN.TSDELIVERY_NOTICE WHERE DNDOCNO='"+dnDocNo+"'");
	   String sqlDocs = "";
	   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MPC_User")>=0) // 管理員,所有單據皆可檢視 //add MPC_User by SHIN 20090721
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE, a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO ,  "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.WFRESIST, a.COMPLETION_SUBINVENTORY, a.CUST_PART_NO, a.END_CUST_ALNAME ,a.COMPLETION_SUBINVENTORY"+ // 2007/01/20 將晶粒Mil數及阻值由工令主檔帶出
  					"  from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
					" where a.WO_NO=b.WO_NO(+) and a.WO_NO = '"+woNo+"' ";		 
	   }
	   else if (UserRoles.indexOf("YEW_STOCKER")>=0) // 半成品倉人員不分製造部
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO ,  "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.WFRESIST, a.COMPLETION_SUBINVENTORY, a.CUST_PART_NO, a.END_CUST_ALNAME ,a.COMPLETION_SUBINVENTORY"+ // 2007/01/20 將晶粒Mil數及阻值由工令主檔帶出
  					" from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO  = '"+woNo +"' " ;	 
	   }
	   else if (UserRoles.indexOf("YEW_WIP_PACKING")>=0) // 包裝站人員不分製造部
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO ,  "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.WFRESIST, a.COMPLETION_SUBINVENTORY, a.CUST_PART_NO, a.END_CUST_ALNAME ,a.COMPLETION_SUBINVENTORY"+ // 2007/01/20 將晶粒Mil數及阻值由工令主檔帶出
  					" from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO  = '"+woNo +"' " ;	 
	   }
	   else //其它// 只有自己單位開的單據能看單據內容
	   {  
	        sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO, a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE, a.USER_NAME, a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID, a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO ,  "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.WFRESIST, a.COMPLETION_SUBINVENTORY, a.CUST_PART_NO, a.END_CUST_ALNAME ,a.COMPLETION_SUBINVENTORY"+ // 2007/01/20 將晶粒Mil數及阻值由工令主檔帶出
  					" from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO = '"+woNo+"' and A.DEPT_NO = '"+userMfgDeptNo+"'" ; 
	   }
				  
    //    if (line_No!=null && !line_No.equals("")) { sqlDocs = sqlDocs+"and to_char(b.LINE_NO) ='"+line_No+"' "; } // ????Line_No???
	//   if (lineStatusID!=null && !lineStatusID.equals("")) {  sqlDocs = sqlDocs+"and b.LSTATUSID ='"+lineStatusID+"' "; }
	   
       //out.print(sqlDocs);
       ResultSet docrs=docstatement.executeQuery(sqlDocs);
       docrs.next();
	   workOrderId=docrs.getString("WORKORDER_ID");
	   deptNo=docrs.getString("DEPT_NO");
	   marketType=docrs.getString("MARKET_TYPE");
	   woType=docrs.getString("WORKORDER_TYPE");
	   alternateRouting=docrs.getString("ALTERNATE_ROUTING");
	   //alternateRouting=docrs.getString("ALTERNATE_ROUTING");
	   routingSequenceID=docrs.getString("ROUTING_REFERENCE_ID");
//out.print("step1");
	   invItem=docrs.getString("INV_ITEM");
	   itemDesc=docrs.getString("ITEM_DESC");
	   woQty=docrs.getString("WO_QTY"); //out.println("woQty="+woQty);
	   woUom=docrs.getString("WO_UOM");
	   startDate=docrs.getString("STARTDATE");
//out.print("step2");	   
	   endDate=docrs.getString("endDate");
	   completeDate=docrs.getString("COMPLETEDATE");
	   tscPackage=docrs.getString("TSC_PACKAGE");
	   tscAmp=docrs.getString("TSC_AMP");
	   tscFamily=docrs.getString("TSC_FAMILY");
	   tscPacking=docrs.getString("TSC_PACKING");
	   waferLotNo=docrs.getString("WAFER_LOT_NO");
//out.print("step3=waferLotNo"+waferLotNo);	   
	   waferQty=docrs.getString("WAFER_QTY");    //下線數量
// out.print("step3-1");		   
	   waferIqcNo=docrs.getString("WAFER_IQC_NO");
//out.print("step3-2");	   
	   waferKind=docrs.getString("WAFER_KIND");
//out.print("step3-3");	   
	   waferVendor=docrs.getString("WAFER_VENDOR");
	   waferYld=docrs.getString("WAFER_YIELD");
	   waferAmp=docrs.getString("WAFER_AMP");
	   waferUsedPce=docrs.getString("WAFER_USED_PCE");
//out.print("waferYld="+waferYld);
	   waferLineNo=docrs.getString("WAFER_LINE_NO");
//out.print("step4="+waferLineNo);	   
	   oeOrderNo=docrs.getString("OE_ORDER_NO"); //?a°eou-×|?¥o?μ¥O
	   customerName=docrs.getString("CUSTOMER_NAME");
	   oeHeaderId =docrs.getString("ORDER_HEADER_ID");	   
	   oeLineId=docrs.getString("ORDER_LINE_ID");
//out.print("step5");	   
	   woRemark=docrs.getString("WO_REMARK");
	   statusId=docrs.getString("STATUSID");
	   status=docrs.getString("STATUS");
	   lstatusId=docrs.getString("LSTATUSID");  // 增加流程卡的狀態ID
	   lstatus=docrs.getString("LSTATUS");   // 增加流程卡的狀態
	   creationDate=docrs.getString("CREATEDATE");
	   createdBy=docrs.getString("USER_NAME");
	   releaseDate=docrs.getString("RELEASEDATE");	
	   lastUpdateDate=docrs.getString("LAST_UPDATE_DATE");	
	   lastUpdateBy=docrs.getString("LAST_UPDATED_BY");   
	   jobType=docrs.getString("JOB_TYPE");  // 標準/非標準工單(discrete/rework) Job
	   wipEntityId=docrs.getString("WIP_ENTITY_ID"); // 
	   altBillDesc=docrs.getString("ALT_BILL_DEST");
	   diceSize=docrs.getString("DICE_SIZE"); // 晶粒尺寸
	   waferElect=docrs.getString("WFRESIST"); // 阻值電壓
       supplierLotNo=docrs.getString("SUPPLIER_LOT_NO");
	   compSubInv=docrs.getString("COMPLETION_SUBINVENTORY"); // 完工入庫倉別
	   custPartNo=docrs.getString("CUST_PART_NO"); // 客戶品號
	   endCustName=docrs.getString("END_CUST_ALNAME"); // 終端客戶名
	   completeSubInv=docrs.getString("COMPLETION_SUBINVENTORY"); //完工入庫  20160914
	   //if (lstatusId==null) frStatID=statusId; // 流程卡展開後才有RUNCARD的狀態
	   //else frStatID=lstatusId; // 改成抓Runcard的狀態
//out.print("step6 statusId ="+statusId);	   
       docrs.close(); 
	   
//out.print("marketType="+marketType+"    woType="+marketType);   
	   
	     // ?????????
		
	  // if (Integer.parseInt(hStatusID)<Integer.parseInt(statusid))
	  // {
	  //     statusid=hStatusID;
	  //	   status = hStatus;		   
	  // }     
	  
	  //out.println("frStatID="+frStatID);
	 
	   if (alternateRouting!=null)
	   {
	     docrs=docstatement.executeQuery("select * from APPS.YEW_MFG_DEFDATA where DEF_TYPE='ALT_ROUTING' and CODE='"+alternateRouting+"' ");
         if (docrs.next())      
		 {        
		  alternateRoutingDesignator=docrs.getString("ALTERNATE_ROUTING");  // WIP與Oracle系統的AlternateRouting(null,OSP,)
		  alternateRouting=docrs.getString("CODE");  // WIP系統的代碼(1,2,3)
		  alternateRoutingDesc=docrs.getString("CODE_DESC");	// WIP系統的代碼描述(自制,外購,委外加工)      
		 }
	     docrs.close();
	   }	            
//out.print("Step2");	  
  if (woType!="7" && !woType.equals("7"))
  { 
	   if (waferLotNo!=null && !waferLotNo.equals("") && !waferLotNo.equals("N/A"))
	   { 
	     if (waferLineNo==null || waferLineNo.equals("")) waferLineNo="%";
	/*     String waferSql=" select TIR.RESULT_NAME||'('||TIR.RESULT_DESC||')' WAFERRESULTS,TWS.WF_SIZE_NAME WAFERSIZE,"+
		                 "        TLH.WF_RESIST WAFERELECT,  "+
		                 "        TLH.PROD_YIELD WAFERYLD,TLH.SUPPLIER_SITE_NAME WAFERVENDOR ,TLD.UOM WAFERUOM "+
				         "   from ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD, "+
				         "        ORADDMAN.TSCIQC_WAFER_SIZE TWS, ORADDMAN.TSCIQC_RESULT TIR "+
				         "  where TLD.WAFER_SIZE = TWS.WF_SIZE_ID  "+
				         "    and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.INSPLOT_NO = '"+waferIqcNo+"' "+
				         "    and TLD.LINE_NO = '"+waferLineNo+"' "+
				         "    and TLD.RESULT = TIR.RESULT_ID "; 
       */ //  2007/12/07 liling 修正資料不顯示
	     String waferSql=" select TLD.RESULT WAFERRESULTS,TWS.WF_SIZE_NAME WAFERSIZE,"+
		                 "        TLH.WF_RESIST WAFERELECT,  "+
		                 "        TLH.PROD_YIELD WAFERYLD,TLH.SUPPLIER_SITE_NAME WAFERVENDOR ,TLD.UOM WAFERUOM "+
				         "   from ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD, "+
				         "        ORADDMAN.TSCIQC_WAFER_SIZE TWS "+
				         "  where TLD.WAFER_SIZE = TWS.WF_SIZE_ID  "+
				         "    and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.INSPLOT_NO = '"+waferIqcNo+"' "+
				         "    and TLD.LINE_NO = '"+waferLineNo+"' ";
		 //out.print("waferSql"+waferSql);
	     docrs=docstatement.executeQuery(waferSql);
 
 
         if (docrs.next())
		 {   		           
	      waferResults=docrs.getString("WAFERRESULTS");
		  waferSize=docrs.getString("WAFERSIZE");
		  waferUom=docrs.getString("WAFERUOM");
		  waferElect=docrs.getString("WAFERELECT");
		  waferYld=docrs.getString("WAFERYLD");
		  waferVendor=docrs.getString("WAFERVENDOR");
		  //out.print("waferYld="+waferYld);
		 }
		 else { 
		         // 如果取不到IQC的檢驗數據,則判斷是否非工程及實驗工令	
/*	    /*  2007/12/07 liling 修正資料不顯示     
		            waferResults="N/A";
		            waferSize="N/A";
		            waferUom="N/A";
		            waferElect="N/A";
		            waferYld="N/A";
		            waferVendor="N/A";	
*/			
		      }
	     docrs.close();
	   } else {  // 後段都尚未選擇前段生產批號會查無對應IQC檢驗批資料
	            waferResults="N/A";
		        waferSize="N/A";
		        waferUom="N/A";
		        waferElect="N/A";
		        waferYld="N/A";
		        waferVendor="N/A";	               
	          }  
	  //out.print("waferYld="+waferYld); 
  } else { 
           // 如果取不到IQC的檢驗數據,則判斷是否非工程及實驗工令
		 }
//out.println("3");
	  
	   if (deptNo!=null)
	   {  	 			 			                         	  
	     docrs=docstatement.executeQuery(" select code_desc MARKETCODE from YEW_MFG_DEFDATA where DEF_TYPE='MARKETTYPE' and CODE='"+marketType+"'");
         if (docrs.next())      
		 {       
		  marketCode=docrs.getString("MARKETCODE");
		 } 
	     docrs.close();
	   } 	
	   
	   	if (woType!=null)
	   { 	 			 			                         	  
	     docrs=docstatement.executeQuery(" select code_desc WOTYPECODE from yew_mfg_defdata where def_type='WO_TYPE' and code='"+woType+"' ");
         if (docrs.next())      
		 {       
		  woTypeCode=docrs.getString("WOTYPECODE");
		 } 
	     docrs.close();
	   } 	 
	   
//20151028 lastupdate by name
	   	if (lastUpdateBy!=null)
	   { 	 			 			                         	  
	     docrs=docstatement.executeQuery(" select USER_NAME from fnd_user where user_id='"+lastUpdateBy+"' ");
         if (docrs.next())      
		 {       
		  lastUpdateName=docrs.getString("USER_NAME");
		 } 
	     docrs.close();
	   } 	
	       	 
  
//out.println("4");
   
	     if (oeLineId!="0" && !oeLineId.equals("0"))
	     {
		   String orderSql=" select oel.ORDER_QUANTITY_UOM ORDERUOM,OEL.ORDERED_QUANTITY-NVL(OEL.SHIPPING_QUANTITY,0) ORDERQTY,OEL.CUST_PO_NUMBER CUSTOMERPO, "+
		                   "        oel.LINE_NUMBER ||'.'|| oel.SHIPMENT_NUMBER as LINE_NUM, to_char(OEL.SCHEDULE_SHIP_DATE, 'YYYY/MM/DD HH24:MI:SS') as SCH_SHIPDATE " +
 					       "   from oe_order_headers_all oeh , oe_order_lines_all oel "+
					       "  where oeh.header_id=oel.header_id and oel.line_id=  '"+oeLineId+"'" ;
		 
		 
		   docrs=docstatement.executeQuery(orderSql);
           if (docrs.next())
		   {
	         orderUom=docrs.getString("ORDERUOM");
			 orderQty=docrs.getString("ORDERQTY");
			 customerPo=docrs.getString("CUSTOMERPO");    
			 lineNum=docrs.getString("LINE_NUM");         // 訂單項次
			 schShipDate=docrs.getString("SCH_SHIPDATE"); // 訂單預計出貨日
		   }
	       docrs.close();
	     }    
//out.println("5");
// 取指定流程卡上的狀態_起	 
		if (lstatus!=null)
	    { 
	     docrs=docstatement.executeQuery("select a.STATUS,a.STATUSID, b.STATUSDESC from YEW_RUNCARD_ALL a, ORADDMAN.TSWFSTATUS b where a.STATUSID = b.STATUSID and a.WO_NO='"+woNo+"' and a.RUNCARD_NO ='"+runCardNo+"' ");
         if (docrs.next())      
		 {        
		  lstatus=docrs.getString("STATUS");
		  lstatusId=docrs.getString("STATUSID");
		  lstatusDesc=docrs.getString("STATUSDESC");
		  frStatID=lstatusId; // 流程卡已展開,故取各別流程卡上的狀態
		 } else 
		       { 
			     frStatID=statusId;  // 流程卡展開後才有RUNCARD的狀態,所以抓工令的狀態				 
			   }
	     docrs.close();
	    }	
	   //out.print("status ="+status+"&nbsp;");
	   //out.print("lstatus ="+lstatus);   
// 取指定流程卡上的狀態_迄

         docstatement.close();
         docrs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	if (alternateRouting==null ||alternateRouting.equals("")) alternateRouting="";
	if (alternateRoutingDesignator==null || alternateRoutingDesignator.equals("")) alternateRoutingDesignator = "";
	if (completeDate==null ||completeDate.equals("")) completeDate="";
	if (tscPackage==null ||tscPackage.equals("")) tscPackage="";
	if (tscAmp==null ||tscAmp.equals("")) tscAmp="";
	if (tscFamily==null ||tscFamily.equals("")) tscFamily="";
	if (tscPacking==null ||tscPacking.equals("")) tscPacking="";
	if (waferLotNo==null ||waferLotNo.equals("")) waferLotNo="";
	if (waferQty==null ||waferQty.equals("")) waferQty="";
	if (waferIqcNo==null ||waferIqcNo.equals("")) waferIqcNo="";
	if (waferKind==null ||waferKind.equals("")) waferKind="";
	if (waferVendor==null ||waferVendor.equals("")) waferVendor="";
	if (waferUom==null ||waferUom.equals("")) waferUom="";
	if (waferYld==null ||waferYld.equals("")) waferYld="";
	if (waferAmp==null ||waferAmp.equals("")) waferAmp="";
	if (waferLineNo==null ||waferLineNo.equals("")) waferLineNo="";
	if (oeOrderNo==null ||oeOrderNo.equals("0")) oeOrderNo="";
	if (orderQty==null ||orderQty.equals("0")) orderQty="";
	if (orderUom==null ||orderUom.equals("0")) orderUom="";
	if (customerName==null ||customerName.equals("")) customerName="";
	if (customerPo==null ||customerPo.equals("")) customerPo="";
	if (woRemark==null ||woRemark.equals("")) woRemark="";	
	if (releaseDate==null ||releaseDate.equals("")) releaseDate="";	   
	if (altBillDesc==null || altBillDesc.equals("")) altBillDesc="";
	if (wipEntityId==null || wipEntityId.equals("")) wipEntityId="0";
	if (alternateRoutingDesc==null || alternateRoutingDesc.equals("")) alternateRoutingDesc="";
    if (supplierLotNo==null || supplierLotNo.equals("")) supplierLotNo="";
    if (waferLotNo==null || waferLotNo.equals("")) waferLotNo="";
	if (compSubInv==null || compSubInv.equals("")) compSubInv="";
	if (lineNum==null || lineNum.equals("")) lineNum=""; // 訂單項次
	if (schShipDate==null || schShipDate.equals("")) schShipDate = ""; // 預計出貨日
	if (custPartNo==null || custPartNo.equals("")) custPartNo = ""; // 客戶品號
	if (endCustName==null || endCustName.equals("")) endCustName = ""; // 終端客戶名稱 
    
    if ( (woType=="1" || woType.equals("1") )|| (woType=="2" || woType.equals("2") ) )
     { lotNo=waferLotNo; } 
     else { lotNo=supplierLotNo; }

	
	if (diceSize==null || diceSize.equals("")) diceSize = "";
	   
	if (userMfgDeptNo==null || userMfgDeptNo.equals(""))   
	{
	  %>
	     <script language="javascript">
	       alert("您不屬於任何一個製造部門,請洽相關人員設立權限!!!");
		   return false;
		 </script>
	  <%
	}
	  
%>
<style type="text/css">
<!--
.style1 {
	color: #CC3300;
	font-weight: bold;
	font-family: "Courier New";
}
.style2 {
	color: #CC0033;
	font-size: small;
}
-->
</style>
<body>
<span class="style1">
<font size="5">
 <%
  
         if (Integer.parseInt(frStatID)>= 42 && Integer.parseInt(frStatID)<=48) // 流程卡的處理狀態
	     {
	       out.println("WIP流程卡明細");
	     } 
		 else {		  
%>
     WIP工令明細 
<%
              }		  
%>
</font></span> 
&nbsp;&nbsp;<strong><span class="style2">單據狀態:</span></strong><font color="#CC0033"><strong>&nbsp;
<%//=status
         if (Integer.parseInt(frStatID)>= 42 && Integer.parseInt(frStatID)<=48) // 流程卡的處理狀態
	     {
		   out.println(lstatus+"("+lstatusDesc+")");
		 } else {
		          out.println(status);
		        }		 
%></strong></font><BR>
  <strong><font size="2">工令號:<font color="#000066"><%=woNo%></font></font></strong>&nbsp;&nbsp;&nbsp;<font color="#8000FF"></font> 
<%
     Statement seqStat=con.createStatement();
     ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from APPS.YEW_WORKORDER_ALL where WO_NO ='"+woNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
      &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByDOCNO("<%=woNo%>")'>工令單據歷程查詢(依工令號)</A></font>
 <%  } /*    
	 seqRs=seqStat.executeQuery("select COUNT (*) from APPS.YEW_WORKORDER_ALL where WO_NO ='"+woNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
       &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByCust("<%=userInspDeptID%>","<%=userInspDeptID%>","<%=classID%>")'>流程卡製程移站歷程查詢(依流程卡號)</A></font>
<%   }	   */  
	 //} //END OF DAO/DAP§Pcwμ2aGif
	 
	 seqStat.close();
     seqRs.close();
%> 
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr> 
    <td width="22%"><font color="#990000">內外銷別:&nbsp;<%=marketCode%></font></td>
	<td width="32%"><font color="#990000">工令類別:&nbsp;<%=woTypeCode%></font></td>
    <td width="24%"><font color="#990000">Alernate Routing:&nbsp;<%=alternateRouting+"("+alternateRoutingDesignator+"  "+alternateRoutingDesc+")  "%></font></td>
	<td width="22%"><font color="#990000">Alernate BOM:&nbsp;<%=altBillDesc%></font></td>
</tr>	
<tr>
    <td><font color="#990000">料號:&nbsp;<%=invItem%></font></td>	
	<td><font color="#990000">品名:&nbsp;<%=itemDesc%></font></td>	
	<td><font color="#990000">生產數量:&nbsp;<%=woQty%>&nbsp;<%=woUom%></font></td>
	<td><font color="#990000">晶粒尺寸:&nbsp;<%=diceSize%> mil</font></td>
</tr>
<tr>	
	<td nowrap><font color="#990000">預計投入日:&nbsp;<%=startDate%></font></td>
	<td nowrap><font color="#990000">預計完工日:&nbsp;<%=endDate%></font></td>
	<td nowrap><font color="#990000">實際完工日:&nbsp;<%=completeDate%></font></td>
	<td nowrap><font color="#990000">流程卡展開日:&nbsp;<%=releaseDate%></font></td>
  </tr>
  <tr> 
    <td ><font color="#990000">批號:&nbsp;<%=lotNo%></font></td>
    <td ><font color="#990000">供應商:&nbsp;<%=waferVendor%></font></td>
	<td ><font color="#990000">晶片種類:&nbsp;<%=waferKind%></font></td>
	<td ><font color="#990000">電阻系數:&nbsp;<%=waferElect%></font></td>
 </tr>
 <tr>	
	<td ><font color="#990000">下線片數:&nbsp;<%=waferUsedPce%>&nbsp;單位:&nbsp;<%=waferUom%></font></td>
	<td ><font color="#990000">檢驗批單號:&nbsp;<%=waferIqcNo%></font></td>
	<td nowrap><font color="#990000">來料情況:&nbsp;<%=waferResults%></font></td>
	<td ><font color="#990000">試作良率:&nbsp;<%=waferYld%>&nbsp;%</font></td>
  </tr>
  <tr> 
	<td><font color="#990000">銷售訂單號:&nbsp;<%=oeOrderNo%></font><BR>
	    <font color="#990000">訂單項次:&nbsp;<%=lineNum%></font>	
	</td>
    <td nowrap><font color="#990000">客戶名稱:&nbsp;<%=customerName%></font><BR>
	           <font color="#990000">終端客戶:&nbsp;<%=endCustName%></font>
	</td>
	<td><font color="#990000">客戶訂單號:&nbsp;<%=customerPo%></font><BR>
	    <font color="#990000">客戶品號:&nbsp;<%=custPartNo%></font>
	</td>
	<td><font color="#990000">訂單數量:&nbsp;<%=orderQty%>&nbsp;&nbsp;<%=orderUom%></font><BR>
	    <font color="#990000">預計出貨日:&nbsp;<%=schShipDate%></font>
	</td>
  </tr>  
  <tr>
    <td><font color="#990000">TSC Package:&nbsp;<%=tscPackage%></font></td>
	<td><font color="#990000">TSC Family:&nbsp;<%=tscFamily%></font></td>
	<td><font color="#990000">安培數(TSC Amp):&nbsp;<%=tscAmp%></font></td>
	<td><font color="#990000">包裝別:&nbsp;<%=tscPacking%></font></td>
  </tr>	
  <%
     // 判斷是否為後段工令要顯示客戶批號_起
	 if (woType.equals("3")) 
	 {
	     Statement statCLot=con.createStatement();
         ResultSet rsCLot=statCLot.executeQuery("select decode(CUST_LOT,'0','No','1','Yes',CUST_LOT), CUST_LOT from APPS.YEW_WORKORDER_ALL where WO_NO ='"+woNo+"' ");
         if (rsCLot.next())
		 {  
		   custLotFlag = rsCLot.getString(1); // 取出是否產生客戶批號
		   custLot =  rsCLot.getString(2);
		   if (custLotFlag.equals("Yes"))
		   {
		      Statement statCLotP=con.createStatement();
              ResultSet rsCLotP=statCLotP.executeQuery("select CUSTLOT_PREFIX from YEW_RUNCARD_PREFIX where WO_TYPE='3' and DEPT_NO ='"+deptNo+"' ");
              if (rsCLotP.next())
		      {  
		       custLotNoPrefix = rsCLotP.getString(1); // 取出產生客戶批號前置號
              }
		      rsCLotP.close();
		      statCLotP.close();
		   } else {
		             custLotNoPrefix = "N/A"; // 未設定為特殊客戶批號
		          }
         }
		 rsCLot.close();
		 statCLot.close();		 
		
  %>
  <tr>
    <td colspan="2"><font color="#990000">客戶特殊批號:&nbsp;
	   <%=custLotFlag%></font></td>
	<td colspan="2"><font color="#990000">客戶批號前置碼:&nbsp;<%=custLotNoPrefix%></font></td>
  </tr>
  <%
     }  // end of if (woType.equals("3"))
     // 判斷是否為後段工令要顯示客戶批號_迄
  %>
  <tr> 
    <td colspan="4"><font color="#990000">
      流程卡明細: 
	  <%  
	     // 由Procedure判斷是否與Oracle 移站資訊一致,並傳回站別資訊_起
	     int stdOpId = 0; String stdOpDesc = "";
	     int opSeqId =0,opSeqNum=0,prevOpSeqId=0,prevOpSeqNo=0,nextOpSeqId=0,nextOpSeqNo=0;
	     float prevTransQty=0;
	     String ospDesc = "",ospResCode="",currOSPflag="",nextOSPflag="",nextLastflag="",identicalFlag="";
	     String judgeStatusId ="", judgeStatus ="";
	     String synchMessage = ""; 
	     String nonStdJobOPflag = "",nonStdJobReleaseflag=""; 
		 
		 // 2006/12/31 加入前一站,本站,下一站的站別描述
		 //  **  2006/12/31 By Kerwin Update For Performance Issue, 改由 Procedure 取得  ** //
		 String currOpDesc="",nextOpDesc="",prevOpDesc="";		 
		 
		   //呼叫Procedure_起
		   if (runCardNo!=null && !runCardNo.equals("") && !runCardNo.equals("null") && !statusId.equals("040") && !statusId.equals("041")) // 若為流程卡展開..則不顯示流程卡明細_起 //展卡狀態改為040+041 SHIN20090803
           { //out.println("runCardNo="+runCardNo);
	        //out.println("jobType="+jobType);
	 
	        // 改成至流程卡明細之後宣告各個變數
	   
	             CallableStatement cs1 = con.prepareCall("{call TSC_WIP_RUNCARD_SYNCH(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	             cs1.setString(1,woNo);     //*  工令	
				 cs1.setString(2,runCardNo);    //  流程卡 /	
				 cs1.setString(3,jobType);  //*  工令類型 1= 標準 , 2 = 非標準(重工) /		
				 cs1.setString(4,"N");      //*  是否要更新,如與Oracle不一致 /				 
	             cs1.registerOutParameter(5, Types.INTEGER);       // 回傳 o_std_op_id
				 cs1.registerOutParameter(6, Types.VARCHAR);       // 回傳 o_std_op_desc
				 cs1.registerOutParameter(7, Types.INTEGER);       // 回傳 o_opseq_id 
				 cs1.registerOutParameter(8, Types.INTEGER);       // 回傳 o_opseq_num
				 cs1.registerOutParameter(9, Types.INTEGER);       // 回傳 o_prevop_seq_id
				 cs1.registerOutParameter(10, Types.INTEGER);      // 回傳 o_prevop_seq_num
				 cs1.registerOutParameter(11, Types.INTEGER);      // 回傳 o_nextop_seq_id
				 cs1.registerOutParameter(12, Types.INTEGER);      // 回傳 o_nextop_seq_num
				 cs1.registerOutParameter(13, Types.NUMERIC);      // 回傳 o_prev_trans_qty   -- 回傳前站移站數
				 cs1.registerOutParameter(14, Types.VARCHAR);      // 回傳 o_osp_desc         -- 外包資源描述
				 cs1.registerOutParameter(15, Types.VARCHAR);      // 回傳 o_osp_rescode      -- 外包資源碼
				 cs1.registerOutParameter(16, Types.VARCHAR);      // 回傳 o_currosp_flag     -- 回傳本站為外包站
				 cs1.registerOutParameter(17, Types.VARCHAR);      // 回傳 o_nextosp_flag     -- 回傳下一站為外包站
				 cs1.registerOutParameter(18, Types.VARCHAR);      // 回傳 o_nextlst_flag     -- 回傳下一站為最終站
				 cs1.registerOutParameter(19, Types.VARCHAR);      // 回傳 o_identical_flag   -- 與ORACLE移站資訊一致
				 cs1.registerOutParameter(20, Types.VARCHAR);      // 回傳 p_wip_statusid     -- WIP 系統正確狀態ID  
				 cs1.registerOutParameter(21, Types.VARCHAR);      // 回傳 p_wip_status       -- WIP 系統狀態
				 cs1.registerOutParameter(22, Types.VARCHAR);      // 回傳 p_synch_message    -- 異常訊息
				 cs1.registerOutParameter(23, Types.VARCHAR);      // 回傳 o_nonstdjob_op     -- 非標準工令是否訂定operation
				 cs1.registerOutParameter(24, Types.VARCHAR);      // 回傳 o_nonstdjob_re     -- 非標準工令是否Released
				 cs1.registerOutParameter(25, Types.VARCHAR);      // 回傳 o_wip_entity_id    -- 工令識別碼
				 cs1.registerOutParameter(26, Types.VARCHAR);      // 回傳 o_primary_item_id  -- 工令製成品識別碼
				 cs1.registerOutParameter(27, Types.VARCHAR);      // 回傳 o_organization_id  -- 工令組織別
				 cs1.registerOutParameter(28, Types.VARCHAR);      // 回傳 o_prevop_seq_desc  -- 前一站站別描述
				 cs1.registerOutParameter(29, Types.VARCHAR);      // 回傳 o_nextop_seq_desc  -- 下一站站別描述
	             cs1.execute();
                 //out.println("Procedure : Execute Success !!! ");
	             stdOpId = cs1.getInt(5); //out.println("stdOpId="+stdOpId+"<BR>");
				 stdOpDesc = cs1.getString(6); // out.println("stdOpDesc="+stdOpDesc+"<BR>");  //  回傳 REQUEST 執行狀況
				 opSeqId = cs1.getInt(7);  //out.println("opSeqId="+opSeqId+"<BR>");  //  
				 opSeqNum = cs1.getInt(8);  //out.println("opSeqNum="+opSeqNum+"<BR>");  //  
				 prevOpSeqId = cs1.getInt(9);  //out.println("prevOpSeqId="+prevOpSeqId+"<BR>"); //  
				 prevOpSeqNo = cs1.getInt(10);  //out.println("prevOpSeqNo="+prevOpSeqNo+"<BR>"); // 
				 nextOpSeqId = cs1.getInt(11);  //out.println("nextOpSeqId="+nextOpSeqId+"<BR>"); //  // 
				 nextOpSeqNo = cs1.getInt(12); //out.println("nextOpSeqNo="+nextOpSeqNo+"<BR>");  // 
				 prevTransQty = cs1.getFloat(13);  //out.println("prevTransQty="+prevTransQty+"<BR>");  //  
				 ospDesc = cs1.getString(14);  //out.println("ospDesc="+ospDesc+"<BR>"); // 
				 ospResCode = cs1.getString(15); //out.println("ospResCode="+ospResCode+"<BR>");  // 
				 currOSPflag = cs1.getString(16); //out.println("currOSPflag="+currOSPflag+"<BR>");  // 
				 nextOSPflag = cs1.getString(17); //out.println("nextOSPflag="+nextOSPflag+"<BR>");   // 
				 nextLastflag = cs1.getString(18); //out.println("nextLastflag="+nextLastflag+"<BR>");  // 
				 identicalFlag = cs1.getString(19); //out.println("identicalFlag="+identicalFlag+"<BR>");  // 
				 judgeStatusId = cs1.getString(20); //out.println("judgeStatusId="+judgeStatusId+"<BR>");  // 
				 judgeStatus = cs1.getString(21);  //out.println("judgeStatus="+judgeStatus+"<BR>"); // 
				 synchMessage = cs1.getString(22); //out.println("synchMessage="+synchMessage+"<BR>");  // 
				 nonStdJobOPflag = cs1.getString(23); //out.println("nonStdJobOPflag="+nonStdJobOPflag+"<BR>");  // 
				 nonStdJobReleaseflag = cs1.getString(24); //out.println("nonStdJobReleaseflag="+nonStdJobReleaseflag+"<BR>");  // 
				 entityId = cs1.getString(25);             // 回傳工令的Wip Entity Id
				 primaryItemID = cs1.getString(26);        // 回傳工令的Primary Item Id
				 organizationId = cs1.getString(27);       // 回傳工令的OrganizationId	
				 prevOpDesc = cs1.getString(28); 		   // 回傳前一站站別描述
				 nextOpDesc = cs1.getString(29);	       // 回傳下一站站別描述
				 currOpDesc = stdOpDesc ;                  // 回傳本站站別描述
                 cs1.close();
				 
				// out.println("nextOSPflag="+nextOSPflag); //
		  } // End of if (runCardNo==null || runCardNo.equals("")) // 若為流程卡展開..則不顯示流程卡明細_迄	 
		 
		 //呼叫Procedure_迄	 
		 
		//20120717 liling add form no organization_id respone 
       if(organizationId == null || organizationId.equals("null") || organizationId.equals("") || organizationId == "") 
       {  
              Statement statOrg=con.createStatement();
              ResultSet rsOrg=statOrg.executeQuery("select organization_id from yew_workorder_all where wo_no ='"+woNo+"' ");
              if (rsOrg.next())
              {  
               organizationId = rsOrg.getString(1); // 取出產生客戶批號前置號
              }
              rsOrg.close();
              statOrg.close();       
       };		 
	  
	   if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	   {
	  %>
	    <a href='javaScript:ExpandBasicInfoDisplay("CLOSE")' onmouseover='this.T_WIDTH=150;this.T_OPACITY=80;return escape("點擊圖示收合項目明細")'><img src='../image/folder_lock.gif' style="vertical-align:middle " align="middle" border='0'></a>
	  <%
	   } else {	   
	  %>	
	    <a href='javaScript:ExpandBasicInfoDisplay("OPEN")' onmouseover='this.T_WIDTH=150;this.T_OPACITY=80;return escape("點擊圖示展開項目明細")'><img src='../image/folder_open.gif' style="vertical-align:middle " align="middle" border='0'></a>
	  <%
	          }
	  %>
<% 
 if (expand==null || expand.equals("OPEN") || expand.equals("null"))
 {
%> 
 <% //out.println("runCardNo="+runCardNo);
	
	 if (runCardNo!=null && !runCardNo.equals("") && !runCardNo.equals("null") && !statusId.equals("040") && !statusId.equals("041")) // 若為流程卡展開..則不顯示流程卡明細_起 //展卡狀態改為040+041 SHIN20090803
     {      //out.println("runCardNo="+runCardNo);
	        //out.println("jobType="+jobType); 
		 
  /*		 
	out.println("<table width=97% bgcolor='#FFFFCC'><tr><td>nonStdJobOPflag</td><td>nonStdJobReleaseflag</td><td>currOSPflag</td><td>nextOSPflag</td><td>identicalFlag</td><td>judgeStatusId</td><td>judgeStatus</td><td>nextLastflag</td></tr>");			 
	out.println("<tr><td>"+nonStdJobOPflag+"</td><td>"+nonStdJobReleaseflag+"</td><td>"+currOSPflag+"</td><td>"+nextOSPflag+"</td><td>"+identicalFlag+"</td><td>"+judgeStatusId+"</td><td>"+judgeStatus+"</td><td>"+nextLastflag+"</td></tr></table>");
	out.println("<table width=97% bgcolor='#FFFFCC'><tr><td>stdOpId</td><td>stdOpDesc</td><td>opSeqId</td><td>opSeqNum</td><td>prevOpSeqId</td><td>prevOpSeqNo</td><td>nextOpSeqId</td><td>nextOpSeqNo</td><td>prevTransQty</td><td>ospDesc</td><td>ospResCode</td><td>ospResCode</td></tr>");
	out.println("<tr><td>"+stdOpId+"</td><td>"+stdOpDesc+"</td><td>"+opSeqId+"</td><td>"+opSeqNum+"</td><td>"+prevOpSeqId+"</td><td>"+prevOpSeqNo+"</td><td>"+nextOpSeqId+"</td><td>"+nextOpSeqNo+"</td><td>"+prevTransQty+"</td><td>"+ospDesc+"</td><td>"+ospResCode+"</td><td>"+ospResCode+"</td></tr></table>");	
	out.println("<table width=97% bgcolor='#FFFFCC'><tr><td>synchMessage</td>");
	out.println("<tr><td>"+synchMessage+"</td></tr></table>");
	 // 由Procedure判斷是否與Oracle 移站資訊一致,並傳回站別資訊_迄
  */
	   
	  try
      {   
	   out.println("<TABLE cellSpacing='0' bordercolordark='#996666'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
	   out.println("<tr bgcolor='#BDA279'><td nowrap><font color='WHITE'>&nbsp;</font></td><td nowrap><font color='WHITE'>");	   
	   %>
	   流程卡識別碼
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   流程卡號
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   料號說明
	   <%
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   流程卡數量
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   前一站
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   前站報廢數
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   本站說明
	   <% 
	   out.println("</font></td><td nowrap><font color='WHITE'>");
	   %>
	   下一站
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   流程卡狀態
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   展開日期
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>
	   組織識別碼
	   <% 
	   out.println("</font></td>");
	   out.println("<td nowrap><font color='WHITE'>");	   
	   %>	 
	   客戶批號
	   <% 
	     out.println("</font></td></TR>");    
	     String jamString="";
         Statement statement=con.createStatement();
         String sqlDTL = "";
		 String whereDTL = "";
		 String orderDTL = "order by RUNCAD_ID ";
	     if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("MPC_User")>=0) // 管理員,所有單據皆可檢視 //add MPC_User by SHIN 20090721
         { 
		   //sqlDTL ="select a.WIP_ENTITY_ID, a.RUNCAD_ID, a.RUNCARD_NO, a.ITEM_DESC, a.PRIMARY_ITEM_ID, a.INV_ITEM, a.QTY_IN_QUEUE, a.PREVIOUS_OP_SEQ_NUM, a.OPERATION_SEQ_NUM, a.STANDARD_OP_DESC, a.NEXT_OP_SEQ_NUM, a.STATUS, to_char(to_date(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE, a.ORGANIZATION_ID, b.DESCRIPTION "+
		   sqlDTL ="select a.RUNCARD_QTY, b.WIP_ENTITY_ID, a.RUNCAD_ID, a.RUNCARD_NO, a.ITEM_DESC, a.PRIMARY_ITEM_ID, a.INV_ITEM, b.QUANTITY_IN_QUEUE, b.PREVIOUS_OPERATION_SEQ_NUM, a.QTY_IN_SCRAP, b.OPERATION_SEQ_NUM, b.DESCRIPTION as STANDARD_OP_DESC, b.NEXT_OPERATION_SEQ_NUM, a.STATUS, to_char(to_date(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE, a.ORGANIZATION_ID, b.DESCRIPTION, decode(a.CUST_LOT_NO,'null','N/A','','N/A',a.CUST_LOT_NO) as CUST_LOT_NO "+
		           "from APPS.YEW_RUNCARD_ALL a, WIP.WIP_OPERATIONS b ";
		   whereDTL ="where a.WO_NO='"+woNo+"'  "+				     
				     " ";
		   if (jobType==null || jobType.equals("1")) // 標準/非標準工單(discrete/rework) Job)
		   {
		     whereDTL = whereDTL +"and a.OPERATION_SEQ_ID = b.OPERATION_SEQUENCE_ID and b.WIP_ENTITY_ID = a.WIP_ENTITY_ID ";
		   } else { 
		           whereDTL = whereDTL +" and a.STANDARD_OP_ID = b.STANDARD_OPERATION_ID and a.WIP_ENTITY_ID = b.WIP_ENTITY_ID ";
		          }	   
		   sqlDTL = sqlDTL + whereDTL + orderDTL;
		 }
         else if (UserRoles.indexOf("YEW_STOCKER")>=0) // ????????Assigning?RESPONDING
         {
		   sqlDTL ="select a.RUNCARD_QTY, b.WIP_ENTITY_ID, a.RUNCAD_ID, a.RUNCARD_NO, a.ITEM_DESC, a.PRIMARY_ITEM_ID, a.INV_ITEM, b.QUANTITY_IN_QUEUE, b.PREVIOUS_OPERATION_SEQ_NUM, a.QTY_IN_SCRAP, b.OPERATION_SEQ_NUM, b.DESCRIPTION as STANDARD_OP_DESC, b.NEXT_OPERATION_SEQ_NUM, a.STATUS, to_char(to_date(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE, a.ORGANIZATION_ID, b.DESCRIPTION, decode(a.CUST_LOT_NO,'null','N/A','','N/A',a.CUST_LOT_NO) as CUST_LOT_NO "+
		           "from APPS.YEW_RUNCARD_ALL a, WIP.WIP_OPERATIONS b ";
		  whereDTL ="where WO_NO='"+woNo+"' ";						   
					
			if (jobType==null || jobType.equals("1")) // 標準/非標準工單(discrete/rework) Job)
		    {
		     whereDTL = whereDTL +"and a.OPERATION_SEQ_ID = b.OPERATION_SEQUENCE_ID and b.WIP_ENTITY_ID = a.WIP_ENTITY_ID ";
		    } else { 
		             whereDTL = whereDTL +" and a.STANDARD_OP_ID = b.STANDARD_OPERATION_ID and a.WIP_ENTITY_ID = b.WIP_ENTITY_ID(+) ";
		           }	
			sqlDTL = sqlDTL + whereDTL + orderDTL;      
		 }
         else { //out.println("UserRoles="+UserRoles);
		        sqlDTL ="select a.RUNCARD_QTY, b.WIP_ENTITY_ID, a.RUNCAD_ID, a.RUNCARD_NO, a.ITEM_DESC, a.PRIMARY_ITEM_ID, a.INV_ITEM, b.QUANTITY_IN_QUEUE, b.PREVIOUS_OPERATION_SEQ_NUM, a.QTY_IN_SCRAP, b.OPERATION_SEQ_NUM, b.DESCRIPTION as STANDARD_OP_DESC, b.NEXT_OPERATION_SEQ_NUM, a.STATUS, to_char(to_date(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE, a.ORGANIZATION_ID, b.DESCRIPTION, decode(a.CUST_LOT_NO,'null','N/A','','N/A',a.CUST_LOT_NO) as CUST_LOT_NO "+
		                "from APPS.YEW_RUNCARD_ALL a, WIP.WIP_OPERATIONS b ";
				whereDTL ="where a.WO_NO='"+woNo+"'  "+						
						  "  and ( a.DEPT_NO = '"+userMfgDeptNo+"' ) ";
				if (jobType==null || jobType.equals("1")) // 標準/非標準工單(discrete/rework) Job)
		        {
		         whereDTL = whereDTL +"and a.OPERATION_SEQ_ID = b.OPERATION_SEQUENCE_ID and b.WIP_ENTITY_ID = a.WIP_ENTITY_ID ";
		        } else { 
		                 whereDTL = whereDTL +"and a.STANDARD_OP_ID = b.STANDARD_OPERATION_ID and a.WIP_ENTITY_ID = b.WIP_ENTITY_ID ";
		               }
				sqlDTL = sqlDTL + whereDTL + orderDTL;	 	   
			  }
		 //out.println(sqlDTL);	  
         ResultSet rs=statement.executeQuery(sqlDTL);	   
	     while (rs.next())
	     {		
		  organizationId = rs.getString("ORGANIZATION_ID");  // 單據的OrganizationID		
		  entityId = rs.getString("WIP_ENTITY_ID"); // 取工單ID
		  primaryItemID = rs.getString("PRIMARY_ITEM_ID"); // 取工單製成品料號ID,作為各頁面去下一站OpeationSeqID依據			  
		  
		  //out.println("select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO='"+rs.getString("ASSIGN_MANUFACT")+"'");
	      out.print("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
		  out.println("<TD><font color='#990000'>");			
		%>
		  <a href='javaScript:IQCInspectDetailHistQuery("<%=woNo%>","<%=rs.getString("RUNCAD_ID")%>")' onmouseover='this.T_WIDTH=120;this.T_OPACITY=80;return escape("查詢項次處理歷程")'><img src='../image/point_arrow.gif' border='0'></a>
		<%
		  out.println("</font></TD>");
		  out.println("<TD><font color='#990000'>");
		  //if (rs.getString("PO_QTY")=="Y" || rs.getString("SDRQ_EXCEED").equals("Y"))
		  //{  out.println("<font color='RED'><strong>#</strong></font>"); }		
		  out.println(rs.getString("RUNCAD_ID")+"</font></TD>");
		  out.println("<TD><font color='#990000'>"+rs.getString("RUNCARD_NO")+"</font></TD>");
		  out.print("<TD><font color='#990000'>"); // 料號的ToolTip_起
		  out.print("<a href=javaScript:popMenuMsg('"+rs.getString("INV_ITEM")+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+rs.getString("INV_ITEM")+"\""+")'>"); // 寬度,透明度 //
		  out.print(rs.getString("ITEM_DESC")); 
		  out.println("</a>");	
		  out.print("</font></TD>"); // 料號的ToolTip_迄
		  out.println("<TD><font color='#990000'>"+rs.getString("RUNCARD_QTY")+"</font></TD>"); // 數量
		  //前一站的_ToolTip_起
		  out.print("<TD><font color='#990000'>");
		  String operationDesc = "N/A";
		  String operationSeqNo = "0";
		  if (rs.getString("PREVIOUS_OPERATION_SEQ_NUM")!=null && !rs.getString("PREVIOUS_OPERATION_SEQ_NUM").equals(""))
		  {     
		     /*
		        try {	
				    			      
			          String sqlOp = "";
					  if (jobType==null || jobType.equals("1"))
					  {
					        sqlOp =  " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					                 "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					                 "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
									 "    and c.PREVIOUS_OP_SEQ_NUM = '"+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+"' "+
									 "    and c.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
									 "    and to_char(a.OPERATION_SEQ_NUM) = '"+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+"' "+
									 "    and b.ASSEMBLY_ITEM_ID ='"+rs.getString("PRIMARY_ITEM_ID")+"' " ;	       // 取前一站的說明              
					  } else if (jobType.equals("2"))	
					         {
							   sqlOp = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							           " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									   " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									   " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									   " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
									   " and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
									   " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
									   " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
									   " and d.ORGANIZATION_ID = '"+organizationId+"' ";
							 }			 
					  //out.println(sqlOp);
	                  Statement stateOp=con.createStatement();
                      ResultSet rsOp=stateOp.executeQuery(sqlOp);
	                  if (rsOp.next())
	                  {
		  	           operationDesc = rsOp.getString("OPERATION_DESCRIPTION");  					   				   	
	                  }
	                  rsOp.close();
                      stateOp.close(); 
			    }// end of try
                catch (Exception e)
                {
                 out.println("Exception :"+e.getMessage());
                }
			 */	
			 operationDesc = prevOpDesc;  // 2006/12/31 為 Performance Issue 由 Procedure 取各站別說明
		  } else { operationDesc = "N/A"; }		
		  out.print("<a href=javaScript:popPrevOpMsg('"+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+operationDesc+"\""+")'>"); // 寬度,透明度 //		        
		  out.print(rs.getString("PREVIOUS_OPERATION_SEQ_NUM")); // 前一站
		  out.println("</a>");	
		  out.println("</font></TD>"); //前一站的_ToolTip_迄
		  out.print("<TD><font color='#990000'>"); // 前站報廢數_起
		  if (rs.getString("QTY_IN_SCRAP")==null || rs.getString("QTY_IN_SCRAP").equals("")) out.print("0"); else out.print(rs.getString("QTY_IN_SCRAP"));  // 前站報廢數
		  out.println("</font></TD>");             // 前站報廢數_迄
		  out.print("<TD><font color='#990000'>"+"("+rs.getString("OPERATION_SEQ_NUM")+")"+rs.getString("STANDARD_OP_DESC")+"</font></TD>");
		  out.println("<TD NOWRAP><font color='#990000'>");	
		  String nextOperDesc = "N/A";
		  if (rs.getString("NEXT_OPERATION_SEQ_NUM")!=null && !rs.getString("NEXT_OPERATION_SEQ_NUM").equals("") && !rs.getString("NEXT_OPERATION_SEQ_NUM").equals("null"))
		  {    
		     /* 
		        try {
				      String sqlOpNext = "";
				      if (jobType==null || jobType.equals("1"))
					  {
			                sqlOpNext =   " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取下一站OPSeqID
					                       "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					                       "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
										   "    and c.NEXT_OP_SEQ_NUM = '"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"' "+
									       "    and c.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
					                       "    and to_char(a.OPERATION_SEQ_NUM) = '"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"' "+
										   "    and b.ASSEMBLY_ITEM_ID='"+rs.getString("PRIMARY_ITEM_ID")+"' " ; // 取下一站的說明
					  }	else if (jobType.equals("2"))
					         {
							   sqlOpNext = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							               " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									       " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									       " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									       " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
									       " and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
									       " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
										   " and b.RESOURCE_SEQ_NUM != 10 "+
									       " and d.ORGANIZATION_ID = '"+organizationId+"' ";
							 }				   
					  //out.println(sqlOpNext);	                  
	                  Statement stateOpNext=con.createStatement();
                      ResultSet rsOpNext=stateOpNext.executeQuery(sqlOpNext);
	                  if (rsOpNext.next())
	                  {
		  	           nextOperDesc = rsOpNext.getString("OPERATION_DESCRIPTION");  
					   //nextOpSeqID = rsOpNext.getString("OPERATION_SEQUENCE_ID"); 					   	
	                  }
	                  rsOpNext.close();
                      stateOpNext.close(); 
			    }// end of try
                catch (Exception e)
                {
                 out.println("Exception :"+e.getMessage());
                }
			 */				 
			 nextOperDesc = nextOpDesc; // 2006/12/31 為了 Performance Issue 各站別資訊由Procedure取得
		  } else { nextOperDesc = "N/A"; }		
		  out.print("<a href=javaScript:popNextOpMsg('"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+nextOperDesc+"\""+")'>"); // 寬度,透明度 //		        
		  out.print(rs.getString("NEXT_OPERATION_SEQ_NUM")); // 下一站
		  out.println("</a>");	
		  //out.println(rs.getString("NEXT_OPERATION_SEQ_NUM"));			  
		  out.println("</font></TD>");
		  out.println("<TD NOWRAP><font color='#990000'>");
		  out.println(rs.getString("STATUS"));	// ???Line????
		  out.println("</font></TD>");
		  out.println("<TD NOWRAP><font color='#990000'>");
		  out.println(rs.getString("CREATION_DATE"));	// ???展開日期
		  out.println("</font></TD>");
		  out.println("<TD NOWRAP><font color='#990000'>");
		  out.println(rs.getString("ORGANIZATION_ID"));	 // 組織代碼
		  out.println("</font></TD>");
		  out.print("<TD><font color='#990000'>"+rs.getString("CUST_LOT_NO")+"</font></TD>"); // 2007/08/12 增加顯示客戶批號
		  out.println("</TR>");		
	    }    	   	   	 
	    out.println("</TABLE>");
	    statement.close();
        rs.close();        
	  
        } //end of try
        catch (Exception e)
        {
         out.println("Exception:"+e.getMessage());
        }
		
	 } // End of if (runCardNo==null || runCardNo.equals("")) // 若為流程卡展開..則不顯示流程卡明細_迄	
   %> 
<%  
	} // End of if (expand==null || expand.equals("OPEN") || expand.equals("null"))
%> 
	 </font>
	</td>      
  </tr>
  <%
     if (Integer.parseInt(frStatID)>= 42 && Integer.parseInt(frStatID)<=48) // 工令生成或流程卡展開前,無Oracle工令資訊
	 {
     // 計算超額完工率及數量_2007/04/10_By Kerwin_起
	                  Statement stateOverComp=con.createStatement();
                      ResultSet rsOverComp=stateOverComp.executeQuery("select OVERCOMPLETION_TOLERANCE_VALUE, (OVERCOMPLETION_TOLERANCE_VALUE/100)*START_QUANTITY as OVERQTY, "+
					                                                   "      (START_QUANTITY-QUANTITY_SCRAPPED) as REMAINQTY, QUANTITY_COMPLETED, QUANTITY_SCRAPPED, COMPLETION_SUBINVENTORY "+
																	   //20091110 Marvie performance issue
					                                                 //  " from WIP_DISCRETE_JOBS where to_char(WIP_ENTITY_ID) = '"+entityId+"' ");
					                                                   " from WIP_DISCRETE_JOBS where WIP_ENTITY_ID = '"+entityId+"' ");
	                  if (rsOverComp.next())
	                  {
		  	           overPercent = rsOverComp.getString("OVERCOMPLETION_TOLERANCE_VALUE");  // 超額完工率
					   overQuantity = rsOverComp.getString("OVERQTY"); // 超額完工數
					   woRemainQty = rsOverComp.getString("REMAINQTY"); // 工令剩餘數	
					   woCompleteQty = rsOverComp.getString("QUANTITY_COMPLETED"); // 工令完工數
					   woScrapQty = rsOverComp.getString("QUANTITY_SCRAPPED"); // 工令報廢數
					   completeSubInv = rsOverComp.getString("COMPLETION_SUBINVENTORY");  // 完工入庫別					   	
	                  }
	                  rsOverComp.close();
                      stateOverComp.close(); 
	 // 計算超額完工率及數量_2007/04/10_By Kerwin_迄
	}
  %>
  <tr> 
    <td colspan="1"><font color="#990000">工令剩餘數:&nbsp;<%=woRemainQty%></font></td> <td colspan="1"><font color="#990000">工令完工數:&nbsp;<%=woCompleteQty%></font></td><td colspan="1"><font color="#990000">工令報廢數:&nbsp;<%=woScrapQty%></font></td> <td colspan="1"><font color="#990000">完工入庫別:&nbsp;<%=completeSubInv%></font></td>     
  </tr>
  <tr> 
    <td colspan="2"><font color="#990000">工令超額完工率:&nbsp;<%=overPercent+"%"%></font></td> <td colspan="2"><font color="#990000">工令超額完工數:&nbsp;<%=overQuantity%></font></td>    
  </tr>
  <tr> 
    <td colspan="4"><font color="#990000">備註:&nbsp;<%=woRemark%></font></td>   
  </tr>	
</table>
  <table table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">  
  <tr> 
    <td width="8%" nowrap><font color="#990000">
      設立人員:</font></td>
    <td width="14%" nowrap><font color="#990000">&nbsp;<%=createdBy%></font></td>
    <td width="8%" nowrap><font color="#990000">
      設立日期:</font></td>
    <td width="21%" nowrap><font color="#990000">&nbsp;
	  <%=creationDate%></font></td>
    <td width="9%" nowrap><font color="#990000">
	  前次處理人員</font>    </td>
	<td width="11%" nowrap><font color="#990000">&nbsp;
	  <%=lastUpdateName%></font></td>
	  <td width="9%" nowrap><font color="#990000">
	  前次處理日期</font>    </td>
	<td width="20%" nowrap><font color="#990000">&nbsp;
	  <%=lastUpdateDate%></font></td>
  </tr>
  <tr>
    <td><font color="#000099">系統提示:</font></td>
    <td colspan="7"><font color="#990000"></font>
	  <%
	     if (Integer.parseInt(frStatID)>= 42 && Integer.parseInt(frStatID)<=48) // 工令生成或流程卡展開前,無Oracle工令資訊
	     {
	       if (prevOpDesc.indexOf("切割")>0)
		   {
		     out.println("<font color='#000099'>"+"前一站為工令切割站,本站良品數可輸入大於等於或小於處理數!!!"+"</font><BR>");
		   } else if (prevOpSeqNo!=0) 
		          {
		            out.println("<font color='#000099'>"+"本站為製程中間站,故限制良品數<=處理數;良品數+報廢數=處理數"+"</font><BR>");
		          } else if (prevOpSeqNo==0)
				         {
		                  out.println("<font color='#000099'>"+"本站為製程第一站,處理數預設為(流程卡數);良品數+報廢數=處理數"+"</font><BR>");
		                 } else {
						            out.println("<font color='#000099'>"+"&nbsp;"+"</font><BR>");
						        } // 
		}
	  %>
	  <%
	     if (nextLastflag!=null && !nextLastflag.equals("N"))  // nextLastflag = "Y" 表示無下一站,故本站為最後一站
		 {
		    if (compSubInv==null || compSubInv.equals(""))
			{
			   %>
			      <script language="javascript">
				     alert("本站為製程最終站,此工令無預設入庫倉別\n 仍執行系統完工將導致入庫作業失敗!!!");
				  </script>
			   <%			    
			     out.println("<font color='#FF0000'><strong><em>"+"製程最終站工令,但無入庫倉別,請洽相關人員!!!"+"</em></strong></font>");			    
			}
			else {
		           if (jobType.equals("1"))
				   {
				    if (Integer.parseInt(frStatID)>41) //狀態非WO生成040,041 Update by SHIN 20090721
					{ 
				     out.println("<font color='#000099'>"+"本站為此工令製程最終站!!!"+"</font>");
					} else if (Integer.parseInt(frStatID)==41) // 表示是展開流程卡作業 Update by SHIN 20090721
					       {
						        // 判斷如Oracle 工令已存在與此張生產系統工令號一致, 則表示此為已生成Oracle工令,此次需由管理員執行管理員模式2僅展開流程卡
								 String sqlAd2 = " select WIP_ENTITY_NAME from WIP_ENTITIES   "+							            
									             "  where WIP_ENTITY_NAME = '"+woNo+"' ";
								 Statement stateAd2=con.createStatement();
                                 ResultSet rsAd2=stateAd2.executeQuery(sqlAd2);
								 if (rsAd2.next())
								 {
								   out.println("<font color='#000099'>"+"此工令號已存在於Oracle,請管理員以管理員模式展開流程卡!!!"+"</font>");
								 }
								 rsAd2.close();
								 stateAd2.close();
								// 判斷如Oracle 工令已存在與此張生產系統工令號一致, 則表示此為已生成Oracle工令,此次需由管理員執行管理員模式2僅展開流程卡
							 			   
					  
						   } // end of if (Integer.parseInt(frStatID)==40)
						   else {
						            out.println("<font color='#000099'>"+"&nbsp;"+"</font><BR>");
						        } //
				   } else if (jobType.equals("2"))
				          {
						    if (Integer.parseInt(frStatID)<42)
	                       	{
							  out.println("<font color='#000099'>"+"生成工令後,請記得於Oracle給定重工製程並Release工令,方能正常投產執行製程移轉!!!"+"</font>");
							} else {
						            out.println("<font color='#000099'>"+"&nbsp;"+"</font><BR>");
						           } //
						  }
				 }
		 } else if (nextOSPflag!=null && !nextOSPflag.equals("N")) // nextLastflag = "Y" 表示下一站為外包站
		        {
				   out.println("<font color='#000099'>"+"下一站為此工令製程外包站!!!"+"</font>");
				} else if (currOSPflag!=null && !currOSPflag.equals("N")) // currLastflag = "Y" 表示本站為外包站
		               {
				         out.println("<font color='#000099'>"+"本站為此工令製程外包站!!!"+"</font>");
				       }				
	  %>
	  <%
	   // } // End of if (Integer.parseInt(frStatID)>=42)
	  %>
	</td>
  </tr>
</table>   
<% //if (frStatID.equals("009"))  { %>
&nbsp;&nbsp;&nbsp;<font color="RED">標誌圖示<strong><img src="../image/point.gif"></strong>表示必選(填)欄位,請務必輸入</font>
<%      //  } %>
  <!--3o?u?O¥I°I-->
  <!-- ai3a°N?A -->  
    <input name="WO_NO" type="hidden" value="<%=woNo%>" >
    <input name="FORMID" type="HIDDEN" value="WO" > 
	<input name="FROMSTATUSID" type="hidden" value="<%=frStatID%>" >   
	<input name="PREVIOUSPAGEADDRESS" type="HIDDEN" value=""> 
	<input name="PREORDERTYPE" type="HIDDEN" value="<%=%>"> 
	<input name="JOB_TYPE" type="HIDDEN" value="<%=jobType%>"> 	
  <!-- add 2006-09-17  -->
   <input nmae="EXPAND" type="hidden" value="<%=expand%>">
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

