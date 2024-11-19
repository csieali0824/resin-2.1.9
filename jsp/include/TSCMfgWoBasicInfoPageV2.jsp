<!--  20150522 liling update CUSTOMER_LINE_NUMBER  -->
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
function historyByWO(pp)
{   
  subWin=window.open("TSCMfgWOHistoryDetail.jsp?WONO="+pp,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function historyByCust(pp,qq,rr)
{   
  subWin=window.open("TSSDRQInformationQuery.jsp?CUSTOMERNO="+pp+"&CUSTOMERNAME="+qq+"&DATESETBEGIN=20000101"+"&DATESETEND=20991231"+"&CUSTOMERID="+rr,"subwin");  
}
function resultOfDOAP(repno,svrtypeno)
{   
  subWin=window.open("../jsp/subwindow/DOAPResultQuerySubWindow.jsp?REPNO="+repno+"&SVRTYPENO="+svrtypeno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function WorkOrderDetailHistQuery(woNo,runCardNo)
{     
    subWin=window.open("../jsp/TSCMfgRCHistoryDetail.jsp?woNo="+woNo+"&RUNCARDNO="+runCardNo,"subwin","width=900,height=480,scrollbars=yes,menubar=no");    	
}
function IQCInspectDetailHistQuery(inspLotNo,lineNo,waferLotNo)
{     
    subWin=window.open("../jsp/TSIQCInspectLotHistory.jsp?INSPLOTNO="+inspLotNo+"&LINE_NO="+lineNo+"&VENDORLOTNO="+waferLotNo,"subwin","width=900,height=480,scrollbars=yes,menubar=no");    	
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
    String expand=request.getParameter("EXPAND");
    String statusId=""; // ??????? HeadQueryAllStatus????
	String workOrderId="",completeDate="",woRemark="",creationDate="",createdBy="",frStatID="",statusid="",waferLotNo="";
	String waferSize="",marketCode="",woTypeCode="",status="",classID="",createdName="",creationTime="",releaseDate="";
	String entityId="0",WONO0="",WONO1="",WONO2="",WONO3="",WONO4="",WONO5="",waferUsedPce="";
	String waferResults=request.getParameter("RESULTS");
	String orderQty=request.getParameter("ORDERQTY");
	String orderUom=request.getParameter("ORDERUOM");
	String alternateRoutingDesignator="",alternateRoutingDesc="",alterRouting="";// 
    String Limited="",altBillDesc="",supplierLotNo="",lotNo="",diceSize=""; 	
	
	String lineNum="",schShipDate="",custPartNo="",endCustName=""; // 2007/02/04 加入顯示訂單項次資訊1.1, 2.1 ...
	String lastUpdatedBy="",lastUpdateDate=""; 
    String jobType=""; // 一般或重工工令

	if (expand==null) expand = "CLOSE";
	



//String dateCurrent = dateBean.getYearMonthDay();

//out.println("1");

      try
      {      	
	   Statement docstatement=con.createStatement();
	   //out.println("select * from ORADDMAN.TSDELIVERY_NOTICE WHERE DNDOCNO='"+dnDocNo+"'");
	   String sqlDocs = "";
	   if (UserRoles.indexOf("admin")>=0) // 管理員,所有單據皆可檢視
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR, a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE, a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO , "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.CUST_PART_NO, a.END_CUST_ALNAME "+
  					"  from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b "+
					" where a.WO_NO=b.WO_NO(+) and a.WO_NO = '"+woNo+"' ";		 
	   }
	   else if (UserRoles.indexOf("YEW_STOCKER")>=0 || UserRoles.indexOf("YEW_WIP_PACKING")>=0 ) // 半成品倉人員不分製造部
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO , "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.CUST_PART_NO, a.END_CUST_ALNAME "+
  					" from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO  = '"+woNo +"' " ;	 
	   }
	   else if (UserRoles.indexOf("YEW_WIP_QUERY")>=0) // 查詢群組的人員
	   { 
	     sqlDocs="select a.WIP_ENTITY_ID, a.JOB_TYPE, a.WORKORDER_ID,a.WO_NO,a.DEPT_NO,a.MARKET_TYPE,a.WORKORDER_TYPE,a.ALTERNATE_ROUTING_DESIGNATOR,a.ALTERNATE_ROUTING, a.INV_ITEM,a.ITEM_DESC,a.WO_QTY,a.WO_UOM, "+
	   				" TO_CHAR(TO_DATE(a.SCHEDULE_STRART_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') STARTDATE, TO_CHAR(TO_DATE(a.SCHEDULE_END_DATE,'YYYY/MM/DD HH24:MI:SS'),'YYYY/MM/DD HH24:MI:SS') ENDDATE,  "+
	   				" TO_CHAR (TO_DATE (DATE_COMPLETED, 'YYYYMMDDHH24MISS'),'YYYY/MM/DD') COMPLETEDATE,a.TSC_PACKAGE,a.TSC_AMP,a.TSC_FAMILY,a.TSC_PACKING,a.WAFER_LOT_NO,a.WAFER_QTY, "+
	   				" a.WAFER_IQC_NO,a.WAFER_KIND,a.WAFER_VENDOR,a.WAFER_YIELD,a.WAFER_AMP,a.OE_ORDER_NO,a.CUSTOMER_NAME,a.ORDER_HEADER_ID,a.ORDER_LINE_ID,  "+
	   				" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATEDATE,a.USER_NAME,a.TSC_PACKING,  "+
	   				" TO_CHAR(TO_DATE(a.RELEASE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as RELEASEDATE, a.RELEASED_BY, a.DISABLE_DATE,a.WO_REMARK,a.WAFER_LINE_NO,a.STATUSID,a.STATUS, "+
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID,a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO , "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.CUST_PART_NO, a.END_CUST_ALNAME "+
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
					" b.STATUSID as LSTATUSID, b.STATUS as LSTATUS, a.ROUTING_REFERENCE_ID, a.WAFER_USED_PCE,  a.ALT_BILL_DEST,a.SUPPLIER_LOT_NO , "+
					" TO_CHAR(TO_DATE(a.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as LAST_UPDATE_DATE, a.LAST_UPDATED_BY, "+
					" a.DICE_SIZE, a.CUST_PART_NO, a.END_CUST_ALNAME "+
  				//  " from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO = '"+woNo+"' and A.DEPT_NO = '"+userMfgDeptNo+"'" ;
					" from APPS.YEW_WORKORDER_ALL a, APPS.YEW_RUNCARD_ALL b where a.WO_NO=b.WO_NO(+) and a.WO_NO = '"+woNo+"' and A.DEPT_NO in ("+UserMfgDeptSet+") " ;  // 2007/05/09 By Kerwin  改成可跨製造部門查詢,若使用者擁有兩部門權限
	   }
				  
   //    if (line_No!=null && !line_No.equals("")) { sqlDocs = sqlDocs+"and to_char(b.LINE_NO) ='"+line_No+"' "; } // ????Line_No???
	//   if (lineStatusID!=null && !lineStatusID.equals("")) {  sqlDocs = sqlDocs+"and b.LSTATUSID ='"+lineStatusID+"' "; }
	  // out.println(sqlDocs);	   

       ResultSet docrs=docstatement.executeQuery(sqlDocs);
       docrs.next();
	   workOrderId=docrs.getString("WORKORDER_ID");
	   deptNo=docrs.getString("DEPT_NO");
	   marketType=docrs.getString("MARKET_TYPE");
	   woType=docrs.getString("WORKORDER_TYPE");
	   alternateRouting=docrs.getString("ALTERNATE_ROUTING_DESIGNATOR");
       //out.print("step1");
	   invItem=docrs.getString("INV_ITEM");
	   itemDesc=docrs.getString("ITEM_DESC");
	   woQty=docrs.getString("WO_QTY");
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
	   diceSize=docrs.getString("DICE_SIZE"); // 晶粒尺寸
//out.print("step3");	   
	   waferQty=docrs.getString("WAFER_QTY");    //下線數量
	   waferUsedPce=docrs.getString("WAFER_USED_PCE");  //下線片數	   
// out.print("step3-1");		   
	   waferIqcNo=docrs.getString("WAFER_IQC_NO");
//out.print("step3-2");	   
	   waferKind=docrs.getString("WAFER_KIND");
//out.print("step3-3");	   
	   waferVendor=docrs.getString("WAFER_VENDOR");
	   waferYld=docrs.getString("WAFER_YIELD");
//out.print("step3-4");
	   waferLineNo=docrs.getString("WAFER_LINE_NO");
//out.print("step4");	   
	   oeOrderNo=docrs.getString("OE_ORDER_NO"); //
	   customerName=docrs.getString("CUSTOMER_NAME");
	   oeHeaderId =docrs.getString("ORDER_HEADER_ID");	   
	   oeLineId=docrs.getString("ORDER_LINE_ID");
//out.print("step5");	   
	   woRemark=docrs.getString("WO_REMARK");
	   statusId=docrs.getString("STATUSID");
	   status=docrs.getString("STATUS");
	   creationDate=docrs.getString("CREATEDATE");
	   createdBy=docrs.getString("USER_NAME");
	   releaseDate=docrs.getString("RELEASEDATE");
	   altBillDesc=docrs.getString("ALT_BILL_DEST");  
	   supplierLotNo=docrs.getString("SUPPLIER_LOT_NO");
	   custPartNo=docrs.getString("CUST_PART_NO"); // 客戶品號
	   endCustName=docrs.getString("END_CUST_ALNAME"); // 終端客戶名
	   entityId=docrs.getString("WIP_ENTITY_ID");
	   alterRouting=docrs.getString("ALTERNATE_ROUTING"); // 判斷自製或外購工令
	   lastUpdatedBy=docrs.getString("LAST_UPDATED_BY");   // 最後更新人員
	   lastUpdateDate=docrs.getString("LAST_UPDATE_DATE"); // // 最後更新日期
	   frStatID=statusId; 
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
	   
	             
	   if (waferLotNo!=null && !waferLotNo.equals("") && !waferLotNo.equals("N/A"))
	   { 
	     if (waferLineNo==null || waferLineNo.equals("")) waferLineNo="%";
	  /*   String waferSql=" select TIR.RESULT_NAME||'('||TIR.RESULT_DESC||')' WAFERRESULTS,TWS.WF_SIZE_NAME WAFERSIZE,"+
		                 "        TLH.WF_RESIST WAFERELECT,  "+
		                 "        TLH.PROD_YIELD WAFERYLD,TLH.SUPPLIER_SITE_NAME WAFERVENDOR ,TLD.UOM WAFERUOM "+
				         "   from ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD, "+
				         "        ORADDMAN.TSCIQC_WAFER_SIZE TWS, ORADDMAN.TSCIQC_RESULT TIR "+
				         "  where TLD.WAFER_SIZE = TWS.WF_SIZE_ID  "+
				         "    and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.INSPLOT_NO = '"+waferIqcNo+"' "+
				         "    and TLD.LINE_NO = '"+waferLineNo+"' "+
				         "     and TLD.RESULT = TIR.RESULT_ID "; 
       */ //  2007/12/07 liling 修正資料不顯示
	     String waferSql=" select TLD.RESULT WAFERRESULTS,TWS.WF_SIZE_NAME WAFERSIZE,"+
		                 "        TLH.WF_RESIST WAFERELECT,  "+
		                 "        TLH.PROD_YIELD WAFERYLD,TLH.SUPPLIER_SITE_NAME WAFERVENDOR ,TLD.UOM WAFERUOM "+
				         "   from ORADDMAN.TSCIQC_LOTINSPECT_HEADER TLH,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL TLD, "+
				         "        ORADDMAN.TSCIQC_WAFER_SIZE TWS "+
				         "  where TLD.WAFER_SIZE = TWS.WF_SIZE_ID  "+
				         "    and TLH.INSPLOT_NO=TLD.INSPLOT_NO and TLD.INSPLOT_NO = '"+waferIqcNo+"' "+
				         "    and TLD.LINE_NO = '"+waferLineNo+"' ";
	     docrs=docstatement.executeQuery(waferSql);
   // out.print("waferSql="+waferSql);
 
         if (docrs.next())
		 {   		           
	      waferResults=docrs.getString("WAFERRESULTs");
		  waferSize=docrs.getString("WAFERSIZE");
		  waferUom=docrs.getString("WAFERUOM");
		  waferElect=docrs.getString("WAFERELECT");
		  waferYld=docrs.getString("WAFERYLD");
		  waferVendor=docrs.getString("WAFERVENDOR");
		 }
		 else { /*  2007/12/07 liling 修正資料不顯示
		        waferResults="N/A";
		        waferSize="N/A";
		        waferUom="";
		        waferElect="N/A";
		        waferYld="N/A";
		        waferVendor="N/A"; */
		      }
	     docrs.close();
	   } 	  
	   
// out.println("3");
	  
	   if (deptNo!=null)
	   {  	 			 			                         	  
	     docrs=docstatement.executeQuery(" select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"'");
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
	     
//out.println("4");
   
	     if (oeLineId!="0" && !oeLineId.equals("0"))
	     {
		//   String orderSql=" select oel.ORDER_QUANTITY_UOM ORDERUOM,OEL.ORDERED_QUANTITY-NVL(OEL.SHIPPING_QUANTITY,0) ORDERQTY,OEL.CUST_PO_NUMBER CUSTOMERPO, "+  //20150522 liling update CUSTOMER_LINE_NUMBER
		   String orderSql=" select oel.ORDER_QUANTITY_UOM ORDERUOM,OEL.ORDERED_QUANTITY-NVL(OEL.SHIPPING_QUANTITY,0) ORDERQTY,OEL.CUSTOMER_LINE_NUMBER CUSTOMERPO, "+		
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
/*	 
		if (lastUpdateBy!=null)
	    { 		 			 			                         	  

	     docrs=docstatement.executeQuery("select * from ORADDMAN.WSUSER where WEBID='"+lastUpdateBy+"' and LOCKFLAG='N' ");
         if (docrs.next())      
		 {        
		  lastUserName=docrs.getString("USERNAME");	      
		 } else { lastUserName=lastUpdateBy;	 }
	     docrs.close();
	    }
		
		if (createdBy!=null)
	    {
	     docrs=docstatement.executeQuery("select * from ORADDMAN.WSUSER where WEBID='"+createdBy+"' and LOCKFLAG='N' ");
         if (docrs.next())      
		 {        
		  createdName=docrs.getString("USERNAME");	      
		 } else { createdName=createdBy;	 }
	     docrs.close();
	    }
		 
	 
		 docstatement.close();
         docrs.close();
*/ 
         docstatement.close();
         docrs.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
	   
	if(alternateRouting==null ||alternateRouting.equals("")) alternateRouting="";
	if(completeDate==null ||completeDate.equals("")) completeDate="";
	if(tscPackage==null ||tscPackage.equals("")) tscPackage="";
	if(tscAmp==null ||tscAmp.equals("")) tscAmp="";
	if(tscFamily==null ||tscFamily.equals("")) tscFamily="";
	if(tscPacking==null ||tscPacking.equals("")) tscPacking="";
	if(waferQty==null ||waferQty.equals("")) waferQty="";
	if(waferIqcNo==null ||waferIqcNo.equals("")) waferIqcNo="";
	if(waferKind==null ||waferKind.equals("")) waferKind="";
	if(waferVendor==null ||waferVendor.equals("")) waferVendor="";
	if(waferUom==null ||waferUom.equals("")) waferUom="";
	if(waferYld==null ||waferYld.equals("")) waferYld="";
	if(waferLineNo==null ||waferLineNo.equals("")) waferLineNo="";
	if(oeOrderNo==null ||oeOrderNo.equals("0")) oeOrderNo="";
	if(orderQty==null ||orderQty.equals("0")) orderQty="";
	if(orderUom==null ||orderUom.equals("0")) orderUom="";
	if(customerName==null ||customerName.equals("")) customerName="";
	if(customerPo==null ||customerPo.equals("")) customerPo="";
	if(woRemark==null ||woRemark.equals("")) woRemark="";	
	if(releaseDate==null ||releaseDate.equals("")) releaseDate="";	   
	if(altBillDesc==null || altBillDesc.equals("")) altBillDesc="";
	if (alternateRoutingDesc==null || alternateRoutingDesc.equals("")) alternateRoutingDesc="";
	if (waferResults==null || waferResults.equals("")) waferResults="";
	if (waferElect==null || waferElect.equals("")) waferElect="";
    if (supplierLotNo==null || supplierLotNo.equals("")) supplierLotNo="";
    if(waferLotNo==null ||waferLotNo.equals("")) waferLotNo="";
	if (lineNum==null || lineNum.equals("")) lineNum=""; // 訂單項次
	if (schShipDate==null || schShipDate.equals("")) schShipDate = ""; // 預計出貨日
	if (custPartNo==null || custPartNo.equals("")) custPartNo = ""; // 客戶品號
	if (endCustName==null || endCustName.equals("")) endCustName = ""; // 終端客戶名稱
	
	if (entityId==null || entityId.equals("")) entityId = "0";
    
    if ( (woType=="1" || woType.equals("1") )|| (woType=="2" || woType.equals("2") ) )
    { lotNo=waferLotNo; } 
    else { lotNo=supplierLotNo; }
	
	if (diceSize==null || diceSize.equals("")) diceSize = "";
		  
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
<span class="style1"><font size="5">WIP工令明細</font></span> 
&nbsp;&nbsp;<strong><span class="style2">單據狀態:</span></strong><font color="#CC0033"><strong>&nbsp;<%=status%></strong></font><BR>
  <strong><font size="2">&nbsp;&nbsp;工令號:<font color="#000066"><%=woNo%></font></font></strong>&nbsp;&nbsp;&nbsp;<font color="#8000FF"></font> 
<%  
     Statement seqStat=con.createStatement();
     ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from APPS.YEW_WORKORDER_ALL where WO_NO ='"+woNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  
 %>
      &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByWO("<%=woNo%>")'>工令單據歷程查詢(依工令號)</A></font>
 <%  }  /*   
	 seqRs=seqStat.executeQuery("select COUNT (*) from APPS.YEW_WORKORDER_ALL where WO_NO ='"+woNo+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
       &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6'><A HREF='javaScript:historyByCust("<%=userInspDeptID%>","<%=userInspDeptID%>","<%=classID%>")'>流程卡製程移站歷程查詢(依流程卡號)</A></font>
<%   }	    */ 
	 //} //END OF DAO/DAP§Pcwμ2aGif
	 
	 seqStat.close();
     seqRs.close();
	 
%> 
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight='#ffffff' border="1">
  <tr> 
    <td width="26%"><font color="#990000">內外銷別:</font><font color="#990000">&nbsp;<%=marketCode%></font></td>
	<td width="26%"><font color="#990000">工令類別:&nbsp;<%=woTypeCode%></font></td>
    <td width="24%"><font color="#990000">Alernate Routing:&nbsp;<%=alternateRouting+"("+alternateRoutingDesignator+"  "+alternateRoutingDesc+")  "%></font></td>
	<td width="24%"><font color="#990000">Alernate BOM:&nbsp;<%=altBillDesc%></font></td>
</tr>	
<tr>
    <td><font color="#990000">料號:&nbsp;<%=invItem%></font></td>	
	<td><font color="#990000">品名:&nbsp;<%=itemDesc%></font></td>	
	<td><font color="#990000">生產數量:<%=woQty%>&nbsp;<%=woUom%></font></td>
	<td><font color="#990000">晶粒尺寸:&nbsp;<%=diceSize%> mil</font></td>
</tr>
<tr>	
	<td><font color="#990000">預計投入日:&nbsp;<%=startDate%></font></td>
	<td><font color="#990000">預計完工日:&nbsp;<%=endDate%></font></td>
	<td><font color="#990000">實際完工日:&nbsp;<%=completeDate%></font></td>
	<td><font color="#990000">流程卡展開日:&nbsp;<%=releaseDate%></font></td>
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
	<td ><font color="#990000">來料情況:&nbsp;<%=waferResults%></font></td>
	<td ><font color="#990000">試作良率:&nbsp;<%=waferYld%></font></td>
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
	<td><font color="#990000">TSC Family:&nbsp;<%=tscPackage%></font></td>
	<td><font color="#990000">安培數:&nbsp;<%=tscAmp%></font></td>
	<td><font color="#990000">包裝別:&nbsp;<%=tscPacking%></font></td>
  </tr>	
  <tr> 
    <td colspan="4"> 
	  <%   
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
			  
	 if (entityId=="0" || entityId.equals("0")) out.println("<font color='#000099'><strong>尚未生成Oracle工令並展開流程卡</strong></font><BR>");
		
			   
     if (expand==null || expand.equals("OPEN") || expand.equals("null"))
     { 
	   try
       {       
	  
	   %>
	   <TABLE cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
	     <tr bgcolor='#BDA279'>
		 <td nowrap width="1%"  align="center"><font color='#FFFFFF'>&nbsp;</font></td>
		 <td nowrap width="14%" align="center"><font color='#FFFFFF'>IQC NO.</font></td>
		 <td nowrap width="7%" align="center"><font color='#FFFFFF'>IQC 項次</font></td>
		 <td nowrap width="21%" align="center"><font color='#FFFFFF'>晶片批號</font></td>
		 <td nowrap width="14%" align="center"><font color='#FFFFFF'>切割工令號</font></td>
		 <td nowrap width="14%" align="center"><font color='#FFFFFF'>前段工令號</font></td>
		 <td nowrap width="14%" align="center"><font color='#FFFFFF'>後段工令號</font></td>
		 <td nowrap width="15%" align="center"><font color='#FFFFFF'>銷售訂單號</font></td>
		</tr>
	   <% 
	     String jamString="";
         //Statement statement=con.createStatement();
         String sqlDTL="",sqlDTL1="",sqlDTL2="";
		 
		 // Step1. 先由後段工令作為條件
		if (woType.equals("3") || oeOrderNo.length()>1) // 後段可能含重工及工程實驗工令
		{ 		  
		    //backEndWoNo = rsBE.getString("WO_NO");	
			//oeOrderNo = rsBE.getString("OE_ORDER_NO");	
			//String supplierLotNo = rsBE.getString("SUPPLIER_LOT_NO"); // 如果是後段外購工令則取出外購廠商批號
			 String runcardHdr = null;
			 String runcardLot = null;
//out.println("1"+entityId); 
			 Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
             ResultSet rsCNT = stmt.executeQuery(" select /*+INDEX_FFS(MTL_MATERIAL_TRANSACTIONS MTL_MATERIAL_TRANSACTIONS_U2)*/ "+
			                                     " DISTINCT MTLN.LOT_NUMBER, MTLN.TRANSACTION_QUANTITY "+
			                                     "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							                     "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA "+						
			                                     " where MMT.TRANSACTION_SOURCE_ID = "+entityId+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							                     "   and MMT.TRANSACTION_TYPE_ID = 35 "+  //發料
							                     "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							                     "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							                     "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							                     "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							                     "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							                     "   and YWA.WO_NO = YRA.WO_NO(+) ");
			 rsCNT.last();
			 int rowCount = rsCNT.getRow(); // 取得資料筆數,如大於零表示此後段工令已領前段半成品批號
			// rsCNT.close();
			// stmt.close();			  
			 
			 String sqlFE = "";
			 if (rowCount>0)
			 { // out.println("rowCount1="+rowCount);  
			  /*
			    String sqlFERC = " select   "+
			                     " DISTINCT MTLN.LOT_NUMBER, MTLN.TRANSACTION_QUANTITY "+
			                     "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							     "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA ";	  
			      								  					
			    String whereFE = " where MMT.TRANSACTION_SOURCE_ID = "+entityId+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							     "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							     "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							     "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							     "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							     "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							     "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							     "   and YWA.WO_NO = YRA.WO_NO(+) ";
				   sqlFE = sqlFE + whereFE; // 取工令號的
				  sqlFERC = sqlFERC + whereFE; // 取流程卡號的
				*/
				      sqlFE =  " select DISTINCT YRA.WO_NO, YRA.WIP_ENTITY_ID, YWA.WAFER_LOT_NO, YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO "+
			                     "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							     "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA ";  
			    String whereFE = " where MMT.TRANSACTION_SOURCE_ID = "+entityId+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							     "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							     "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							     "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							     "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							     "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							     "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							     "   and YWA.WO_NO = YRA.WO_NO(+) ";
				 sqlFE = sqlFE + whereFE; // 取工令號的
				 // runcardHdr = "<table><tr><td>領用批號</td><td>領用數量</td></tr>";
				  runcardHdr = "<table>";				 
				  runcardLot = "";
				 // Statement stateFERC=con.createStatement();
		        // ResultSet rsFERC=stateFERC.executeQuery(sqlFERC);
				  rsCNT.first();
				  while (rsCNT.next())
				  {
				     runcardLot = runcardLot +"<tr><td>"+rsCNT.getString("LOT_NUMBER")+"</td><td>"+rsCNT.getString("TRANSACTION_QUANTITY")+"</td></tr>";  // 組合前段予後段領用的批號
				  }
				  runcardLot = runcardLot + "</table>";
				  //rsFERC.close();
				  //stateFERC.close();
				  runcardHdr = runcardHdr + runcardLot;
			 } else {// out.println("rowCount2="+rowCount);
			         
			          if (alterRouting.equals("1"))
					  {
			             sqlFE =  " select DISTINCT MTLN.LOT_NUMBER as WO_NO, 0 as WIP_ENTITY_ID,  '未領用前段批號' as WAFER_LOT_NO, '舊庫存批號' as WAFER_IQC_NO, 0 as WAFER_LINE_NO "+
			                     "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN  "+									
			                     " where MMT.TRANSACTION_SOURCE_ID = "+entityId+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							     "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							     "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							     "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							     "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							     "   and MTLN.TRANSACTION_QUANTITY < 0 "; // 發料,故異動數量小於零
					  } else { // 外購工令
					            sqlFE =  " select DISTINCT MTLN.LOT_NUMBER as WO_NO, 0 as WIP_ENTITY_ID,  MTLN.LOT_NUMBER as WAFER_LOT_NO, INSPLOT_NO as WAFER_IQC_NO, LINE_NO as WAFER_LINE_NO "+
			                     "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN,   "+	
								 "       ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQCD "+								
			                     " where MMT.TRANSACTION_SOURCE_ID = "+entityId+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							     "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							     "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							     "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							     "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							     "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
								 "   and MMT.INVENTORY_ITEM_ID = IQCD.INV_ITEM_ID "+
								 "   and MTLN.LOT_NUMBER = IQCD.SUPPLIER_LOT_NO(+) ";
					         }					  
					 
			        } // End of else
				   rsCNT.close();
			       stmt.close();	
			      // 取得後段工令領用前段半成品批號_起
			 
		          Statement stateFE=con.createStatement();
		          ResultSet rsFE=stateFE.executeQuery(sqlFE);
			      while (rsFE.next())
			      {
			        // Step2. 再找前段對應切割工令的領料資料
				    String cutWoNo = "";    //
				    waferLotNo = rsFE.getString("WAFER_LOT_NO");        //
				    String waferIQCNo = rsFE.getString("WAFER_IQC_NO"); // 
				    String waferIQCLine = rsFE.getString("WAFER_LINE_NO"); // 
			        Statement stateCU=con.createStatement();
		            ResultSet rsCU=stateCU.executeQuery("select DISTINCT YRA.WO_NO, YWA.WAFER_LOT_NO, YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO "+
			                                            "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+
							                            "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA "+
			                                            " where MMT.TRANSACTION_SOURCE_ID = "+rsFE.getString("WIP_ENTITY_ID")+" and MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							                            "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							                            "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
													    "   and MMT.TRANSACTION_TYPE_ID = 35 and YRA.WIP_ENTITY_ID = MMT.TRANSACTION_SOURCE_ID "+
													    "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							                            "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID and YWA.WO_NO = YRA.WO_NO(+) "+
													    "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER ");
			       if (rsCU.next())  // 因為一個前段工令,基本上對應一個切割工令
				   {
				    cutWoNo = rsCU.getString("WO_NO");
					waferLotNo = rsCU.getString("WAFER_LOT_NO");
					waferIQCNo = rsCU.getString("WAFER_IQC_NO");
					waferIQCLine = rsCU.getString("WAFER_LINE_NO");
				   } else {
				            // Step3. 由MFG Travel 再取得切割工令_
					     	 String sqlCUT="select PRIMARY_NO, PRIMARY_PARENT_NO "+
		                                  "  from YEW_MFG_TRAVELS_ALL  "+
		                                  " where EXTEND_NO = '"+rsFE.getString("WO_NO")+"' ";
		                     Statement stateCUT=con.createStatement();
		                     ResultSet rsCUT=stateCUT.executeQuery(sqlCUT);	
		                     if (rsCUT.next())
		                     {
					           cutWoNo = rsCUT.getString("PRIMARY_NO");						 
					         } else {
					                 cutWoNo = "無切割工令";
					                }
					                rsCUT.close();
					                stateCUT.close();   					  
				         }
		          rsCU.close();
				  stateCU.close();
			 
			
	    /*  // By Liling 2007/02/04
		  sqlDTL1="SELECT distinct a.wono0, a.wono1, b.wono2, c.wono3, c.wono4, c.wono5  "+
 				 "  FROM (SELECT order_no wono0, primary_no wono1, extend_no wono2 FROM yew_mfg_travels_all  "+
         		 " 		   WHERE primary_type = '0') a,     "+
       			 "       (SELECT PRIMARY_PARENT_NO wono2, extend_no wono3 FROM yew_mfg_travels_all  "+
        		 "		   WHERE primary_type = '1'  "+
				 " 	       UNION  "+
				 "        SELECT primary_parent_no AS wono1, extend_no wono3  FROM yew_mfg_travels_all   "+
 		 		 "         WHERE extend_type = '2'  ) b,     "+
	   			 "       (SELECT PRIMARY_PARENT_NO wono3, extend_no wono4, order_no wono5 FROM yew_mfg_travels_all "+ 
                 "         WHERE primary_type = '2') c "+
		         " WHERE a.wono2 = b.wono2(+) AND b.wono3 = c.wono3(+) ";
		 
		 
	     if (woType=="1" || woType.equals("1")) // 切割
          {  
		    //sqlDTL= sqlDTL1+" AND b.wono2='"+woNo+"' "+sqlDTL2  ;
		     sqlDTL= sqlDTL1+" AND b.wono2='"+woNo+"' "  ;
			
		  }
		 else if  (woType=="2" || woType.equals("2")) //前段
          {  
		   //  sqlDTL= sqlDTL1+" AND c.wono3='"+woNo+"' "+sqlDTL2+" AND c.wono3='"+woNo+"' " ;
		    sqlDTL= sqlDTL1+" AND c.wono3='"+woNo+"' " ;			
		  }
		 else if  (woType=="3" || woType.equals("3")) //後段
          {  
		  //  sqlDTL= sqlDTL1+" AND c.wono4='"+woNo+"' "+sqlDTL2+" AND c.wono4='"+woNo+"' " ;
		    sqlDTL= sqlDTL1+" AND c.wono4='"+woNo+"' " ;
		  }
	    
		 //out.print("sqlDTL="+sqlDTL);
         ResultSet rs=statement.executeQuery(sqlDTL);	   
	     while (rs.next())
	     {	 
		    WONO0 = rs.getString("WONO0"); //  IQC NO		
		    WONO1 = rs.getString("WONO1"); //  晶片批號
		    WONO2 = rs.getString("WONO2"); //  切割工令
		    WONO3 = rs.getString("WONO3"); //  前段工令
		    WONO4 = rs.getString("WONO4"); //  後段工令
		    WONO5 = rs.getString("WONO5"); //  銷售訂單號
	   */ 
		  //out.println("select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO='"+rs.getString("ASSIGN_MANUFACT")+"'");
           %> 
		      <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>		  
		       <TD align="center"><font color='#990000'>&nbsp;</font></TD>	
			   <TD align="center"><a href='javaScript:IQCInspectDetailHistQuery("<%=waferIQCNo%>","<%=waferIQCLine%>","<%=waferLotNo%>")'><font color='#990000'><%=waferIQCNo%></font></a></TD>  
			   <TD align="center"><font color='#990000'><%=waferIQCLine%></font></TD>	      
			   <TD align="center"><font color='#990000'><%=waferLotNo%></font></TD>	
			   <TD align="center"><font color='#990000'><%=cutWoNo%></font></TD>	
			   <TD align="center"><font color='#990000'><%=rsFE.getString("WO_NO")%></font></TD>	
			   <TD align="center"><a onmouseover='this.T_STICKY=true;this.T_TEMP=3500;this.T_WIDTH=200;this.T_CLICKCLOSE=true;this.T_SHADOWCOLOR="#6699CC";this.T_TITLE="半成品批號&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;數量";this.T_OFFSETY=-32;return escape("<%=runcardHdr%>")'><font color='#990000'><%=woNo%></font></a></TD>	
			   <TD align="center"><font color='#990000'><%=oeOrderNo%></font></TD>
			  </TR>
	       <%	 
	        }    // end of while	  
		    rsFE.close(); 
		    stateFE.close();	   	 
	      %>
		</TABLE>
		  <%          
//out.println("2"); 		   
		 }  //End of if (woType.equals("3") || oeOrderNo.length()>1) // 後段可能含重工及工程實驗工令
		 else if (woType.equals("2")) // 如為前段工令
		      {    
			     // Step1. 先取得有以此前段工令批號的後段工令ID
			       String sqlFE = "select DISTINCT MMT.TRANSACTION_SOURCE_ID, YWA.WAFER_LOT_NO, YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO "+
			                      "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							      "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA "+						
			                      " where MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							      "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							      "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							      "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							      "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							      "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							      "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							      "   and YWA.WO_NO = YRA.WO_NO(+) "+
							      "   and YWA.WO_NO = '"+woNo+"' ";
		           Statement stateFE=con.createStatement();
		           ResultSet rsFE=stateFE.executeQuery(sqlFE);
			       while (rsFE.next())
				   {   // Step2. 以此後段工令 ID 取前段工令資訊
				       String cutWoNo = "&nbsp;";
				       String BackEndWoNo = "";
			           String sqlBE="select YWA.OE_ORDER_NO, YWA.WO_NO  "+
		                            "  from YEW_WORKORDER_ALL YWA "+
		                            " where YWA.WIP_ENTITY_ID = '"+rsFE.getString("TRANSACTION_SOURCE_ID")+"' and YWA.STATUSID !='050' ";
		               Statement stateBE=con.createStatement();
		               ResultSet rsBE=stateBE.executeQuery(sqlBE);	
		               if (rsBE.next())
		               {
					      oeOrderNo = rsBE.getString("OE_ORDER_NO");
						  BackEndWoNo = rsBE.getString("WO_NO");
					   }
					   rsBE.close();
					   stateBE.close();
					   
					   String waferIQCNo = rsFE.getString("WAFER_IQC_NO");
					   String waferIQCLine = rsFE.getString("WAFER_LINE_NO");
					   waferLotNo = rsFE.getString("WAFER_LOT_NO");		
					   
					   // Step3. 由MFG Travel 再取得切割工令_
					   	String sqlCU="select PRIMARY_NO, PRIMARY_PARENT_NO "+
		                            "  from YEW_MFG_TRAVELS_ALL  "+
		                            " where EXTEND_NO = '"+woNo+"' ";
		               Statement stateCU=con.createStatement();
		               ResultSet rsCU=stateCU.executeQuery(sqlCU);	
		               if (rsCU.next())
		               {
					      cutWoNo = rsCU.getString("PRIMARY_NO");						 
					   } else {
					             cutWoNo = "無切割工令";
					          }
					   rsCU.close();
					   stateCU.close();   
			    
				  %>
				      <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>		  
		               <TD align="center"><font color='#990000'>&nbsp;</font></TD>	
			           <TD align="center"><a href='javaScript:IQCInspectDetailHistQuery("<%=waferIQCNo%>","<%=waferIQCLine%>","<%=waferLotNo%>")'><font color='#990000'><%=waferIQCNo%></font></a></TD>  
			           <TD align="center"><font color='#990000'><%=waferIQCLine%></font></TD>	      
			           <TD align="center"><font color='#990000'><%=waferLotNo%></font></TD>	
			           <TD align="center"><font color='#990000'><%=cutWoNo%></font></TD>	
			           <TD align="center"><font color='#990000'><%=woNo%></font></TD>	
			           <TD align="center"><font color='#990000'><%=BackEndWoNo%></font></TD>	
			           <TD align="center"><font color='#990000'><%=oeOrderNo%></font></TD>
			          </TR>
	               <%
				  } // End of while (rsFE.next())
				  rsFE.close();
				  stateFE.close();
//out.println("3"); 				  
				 %>
		        </TABLE>
		         <%  
			  }	 // End of if (woType.equals("2"))	
			  else if (woType.equals("1"))
			       {
				       // Step1. 找 切割工令給前段工令領用之切割批號_起
					     String sqlFE = "select DISTINCT MMT.TRANSACTION_SOURCE_ID, YWA.WAFER_LOT_NO, YWA.WAFER_IQC_NO, YWA.WAFER_LINE_NO "+
			                            "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							            "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA "+						
			                            " where MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							            "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							            "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							            "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							            "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							            "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							            "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							            "   and YWA.WO_NO = YRA.WO_NO(+) "+
							            "   and YWA.WO_NO = '"+woNo+"' ";
						Statement stateFE=con.createStatement();
		                ResultSet rsFE=stateFE.executeQuery(sqlFE);
			            if (rsFE.next()) // 原則上,一張切割工令予一張前段工令領用一個批號
						{
						     String waferIQCNo = rsFE.getString("WAFER_IQC_NO");
					         String waferIQCLine = rsFE.getString("WAFER_LINE_NO");
					         waferLotNo = rsFE.getString("WAFER_LOT_NO");	
							 
							  String frontWoNo = "";
							  Statement stateFR=con.createStatement();
		                      ResultSet rsFR=stateFR.executeQuery("select YWA.WO_NO  "+
		                                                          "  from YEW_WORKORDER_ALL YWA "+
		                                                          " where YWA.WIP_ENTITY_ID = '"+rsFE.getString("TRANSACTION_SOURCE_ID")+"' "+
																  "   and YWA.STATUSID != '050' ");	 // 不能是取消的
		                      if (rsFR.next())
		                      {	
							    frontWoNo = rsFR.getString("WO_NO");
								String BackEndWoNo = "";
							    String sqlBE = "select DISTINCT MMT.TRANSACTION_SOURCE_ID "+
			                                   "  from MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTLN, "+	
							                   "       YEW_RUNCARD_ALL YRA, YEW_WORKORDER_ALL YWA "+						
			                                   " where MMT.TRANSACTION_SOURCE_TYPE_ID = 5 "+
							                   "   and MMT.TRANSACTION_TYPE_ID = 35 "+
							                   "   and MMT.TRANSACTION_SOURCE_ID = MTLN.TRANSACTION_SOURCE_ID "+  // 同一工令號
							                   "   and MMT.TRANSACTION_SOURCE_TYPE_ID = MTLN.TRANSACTION_SOURCE_TYPE_ID "+   // 同樣是 WIP 的 
							                   "   and MMT.INVENTORY_ITEM_ID = MTLN.INVENTORY_ITEM_ID "+
							                   "   and MTLN.TRANSACTION_QUANTITY < 0 "+ // 發料,故異動數量小於零
							                   "   and YRA.RUNCARD_NO = MTLN.LOT_NUMBER "+
							                   "   and YWA.WO_NO = YRA.WO_NO(+) "+
							                   "   and YWA.WO_NO = '"+frontWoNo+"' "; 
								 Statement stateBE=con.createStatement();			   
								 ResultSet rsBE=stateBE.executeQuery(sqlBE);
								 if (rsBE.next())
		                         {					           
					  			   
		                           Statement stateBackEnd=con.createStatement();
		                           ResultSet rsBackEnd=stateBackEnd.executeQuery("select YWA.OE_ORDER_NO, YWA.WO_NO  "+
		                                                                         "  from YEW_WORKORDER_ALL YWA "+
		                                                                         " where YWA.WIP_ENTITY_ID = '"+rsBE.getString("TRANSACTION_SOURCE_ID")+"' ");	
		                           if (rsBackEnd.next())
		                           {
					                oeOrderNo = rsBackEnd.getString("OE_ORDER_NO");	
									BackEndWoNo = rsBackEnd.getString("WO_NO");					           
					               }
					               rsBackEnd.close();
					               stateBackEnd.close();
						         } // End of While (rsBE.next())
					             rsBE.close();
					             stateBE.close();
						  %>
				           <TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>		  
		                     <TD align="center"><font color='#990000'>&nbsp;</font></TD>	
			                 <TD align="center"><a href='javaScript:IQCInspectDetailHistQuery("<%=waferIQCNo%>","<%=waferIQCLine%>","<%=waferLotNo%>")'><font color='#990000'><%=waferIQCNo%></font></a></TD>  
			                 <TD align="center"><font color='#990000'><%=waferIQCLine%></font></TD>	      
			                 <TD align="center"><font color='#990000'><%=waferLotNo%></font></TD>	
			                 <TD align="center"><font color='#990000'><%=woNo%></font></TD>	
			                 <TD align="center"><font color='#990000'><%=frontWoNo%></font></TD>	
			                 <TD align="center"><font color='#990000'><%=BackEndWoNo%></font></TD>	
			                 <TD align="center"><font color='#990000'><%=oeOrderNo%></font></TD>
			               </TR>
	                      <%						      
						     } // End of if (rsFR.next())
							 rsFR.close();
							 stateFR.close();
						} // End of if (rsFE.next())
				        rsFE.close();
				        stateFE.close();
					   %>
		                </TABLE>
		               <% 
				   }  // End of if (woType.equals("1"))
//out.println("4"); 		   
         } //end of try
         catch (SQLException e)
         {
           out.println("Exception WorkOrderLifeCycle:"+e.getMessage());
         } 
	  } // End of if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	 %> 
  <tr> 
    <td colspan="4"><font color="#990000">備註:&nbsp;<%=woRemark%></font></td>   
  </tr>	
</table>
  <table table cellSpacing="0" bordercolordark="#996666" cellPadding="1" width="97%" align="center" borderColorLight="#FFFFFF" border="1">  
  <tr> 
    <td width="10%"><font color="#990000">
      設立人員:</font></td>
    <td width="12%"><font color="#990000">&nbsp;<%=createdBy%></font></td>
    <td width="10%"><font color="#990000">
      設立日期:</font></td>
    <td width="12%" nowrap><font color="#990000">&nbsp;
	  <%=creationDate%></font></td>
	<td width="10%"><font color="#990000">
      最後處理人員:</font></td>
    <td width="10%"><font color="#990000">&nbsp;
	  <%=lastUpdatedBy%></font>
    </td>
	<td width="10%"><font color="#990000">
      最後處理日期:</font></td>
    <td width="10%" nowrap><font color="#990000">&nbsp;
	  <%=lastUpdateDate%></font>
    </td>
  </tr>
</table>   
<% //if (frStatID.equals("009"))  { %>
<%      //  } %>
  <!--3o?u?O¥I°I-->
  <!-- ai3a°N?A -->  
    <input name="WO_NO" type="hidden" value="<%=woNo%>" >
    <input name="FORMID" type="HIDDEN" value="WO" > 
	<input name="FROMSTATUSID" type="hidden" value="<%=frStatID%>" >   
	<input name="PREVIOUSPAGEADDRESS" type="HIDDEN" value=""> 
	<input name="PREORDERTYPE" type="HIDDEN" value="<%=%>"> 
  <!-- add 2006-09-17  -->
   <input nmae="EXPAND" type="hidden" value="<%=expand%>">
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

