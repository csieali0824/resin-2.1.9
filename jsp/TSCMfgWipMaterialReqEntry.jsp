<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/MProcessStatusBarStart.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayWIPIssueSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();	
}
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function searchRepNo(svrTypeNo,statusID,pageURL) 
{   
  location.href="../jsp/TSCMfgDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&MARKETTYPE="+document.MYFORM.MARKETTYPE.value+"&WOTYPE="+document.MYFORM.WOTYPE.value ;
}
function searchWIPIssue(statusID,pageURL) 
{   
  location.href="../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&ISSUETYPE="+document.MYFORM.ISSUETYPE.value+"&ORGANIZATIONID="+document.MYFORM.ORGANIZATIONID.value+"&CREATEDATESTR="+document.MYFORM.CREATEDATESTR.value+"&CREATEDATEEND="+document.MYFORM.CREATEDATEEND.value+"&WIPENTITYIDCH="+document.MYFORM.WIPENTITYIDCH.value+"&OPERATION="+document.MYFORM.OPERATION.value+"&INVITEM="+document.MYFORM.INVITEM.value;
}
function submitCheck(ms1,ms2)
{  
  if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  {       
   alert("請選擇執行動作!!!")
   return(false);
  } 
  
  if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  } 
  
  if (document.MYFORM.ACTIONID.value=="025")  //表示為ISSUE動作
  { 
   flag=confirm(ms2);      
   if (flag==false)  return(false);
  }
  
  if (document.MYFORM.ACTIONID.value=="002")  //表示為CREATE動作
  { 
   alert("此處僅能選擇TEMPOARY動作!!!");      
   return(false);
  }  
  /*
  if (document.MYFORM.ACTIONID.value=="013")  //表示為選擇ABORT動作,要求使用者確認是否客戶相同,方產生新的交期詢問單
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  }
 */
   if ( document.MYFORM.ORGANIZATIONID==null || document.MYFORM.ORGANIZATIONID.value=="--" )
   { 
    alert("請選擇內外銷型別,同批領料工令需為相同型別!!!");   
    return(false);
   }  
   return(true);      
}  
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function subWindowItemFind(organizationId,invItem,itemDesc)
{    
  if (organizationId==null || organizationId=="" || organizationId=="--")
  {
     alert("請選擇內外銷型別!!!");
	 return false;
  }
  subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?ORGANIZATIONID="+organizationId+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");  
} 
function tabWindowItemFind(organizationId,invItem,itemDesc)
{      
  if (organizationId==null || organizationId=="" || organizationId=="--")
  {
     alert("請選擇內外銷型別!!!");
	 return false;
  }
      subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?ORGANIZATIONID="+organizationId+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");  
}
function setItemFindCheck(organizationId,invItem,itemDesc)
{
   if (event.keyCode==13)
   { 
    if (organizationId==null || organizationId=="" || organizationId=="--")
    {
     alert("請選擇內外銷型別!!!");
	 return false;
    }
     subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?ORGANIZATIONID="+organizationId+"&INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");  
   }
}
// Click ... 找工令資料_起
function subWinDiscreteJobFind(discreteJob,statusId)
{
  subWin=window.open("../jsp/subwindow/TSMfgWipDiscreteJobFind.jsp?JOBORRUNCARD="+discreteJob+"&STATUSID="+statusId,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes");
}
// Click找工令下站別資訊
function subWinOperationFind(wipEntityIdCh)
{ //alert("wipEntityIdCh="+wipEntityIdCh);
  if (document.MYFORM.SEARCHSTRING.value==null || document.MYFORM.SEARCHSTRING.value=="" || document.MYFORM.JOBEXISTFLAG==null || document.MYFORM.JOBEXISTFLAG=="" || document.MYFORM.JOBEXISTFLAG=="N")
  {
    alert("您尚未選擇某一存在工令,無法選擇站別作批次處理!!!");
	return false;
  }
  subWin=window.open("../jsp/subwindow/TSMfgWipOperationFind.jsp?WIPENTITYID="+wipEntityIdCh,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes");
}
// Enter ... 找工令資料_迄
// 找領料倉別
function subWindowSubInventoryFind(organizationID,subInv,subInvDesc)
{    
  //subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,scrollbars=yes");  
} 
function setSubmitQuery(URL,supplier,vendor,vendorNo,receiptDateBeg,receiptDateEnd,poNo,receiptNo)
{ 
//alert(supplier); 
//alert(document.MYFORM.SUPPLYVND.value);
  var suppID = "&SUPPLIERID="+supplier+"&RECEPTDATEBEG="+receiptDateBeg+"&RECEPTDATEEND="+receiptDateEnd;
    if ( (document.MYFORM.SUPPLYVND.value==null || document.MYFORM.SUPPLYVND.value=="") && (document.MYFORM.PONO.value==null || document.MYFORM.PONO.value=="") && (document.MYFORM.RECEIPTNO.value==null || document.MYFORM.RECEIPTNO.value=="") ) //若未輸入供應商或PO號或收料單號,則顯示警告訊息
	{
	 alert("請輸入供應商、採購單號或收料單號為來源依據!!!");
	 document.MYFORM.SUPPLYVND.focus(); 
	 return(false);
	} else {
	           if (document.MYFORM.PONO.value!=null) suppID = suppID+"&PONO="+poNo;
			   if (document.MYFORM.RECEIPTNO.value!=null) suppID = suppID+"&RECEIPTNO="+receiptNo;	
	        }
	if (supplier!=null && supplier!="")
	{
	    if (document.MYFORM.SUPPLYVND.value!=supplier)
		{
		   alert("Different Supplier!!! ");
		   return (false);
		}
		
     	document.MYFORM.action=URL+suppID;
        document.MYFORM.submit();
	} else {
	           document.MYFORM.action=URL+suppID;
               document.MYFORM.submit();
	        }	
} 
function setSubmitOrg(URL)
{
   var othLink = "&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&WIPENTITYIDCH="+document.MYFORM.WIPENTITYIDCH.value+"&OPERATION="+document.MYFORM.OPERATION.value+"&INVITEM="+document.MYFORM.INVITEM.value;
     alert(URL+"&ORGANIZATIONID="+document.MYFORM.ORGANIZATIONID.value);
     document.MYFORM.action=URL+"&ORGANIZATIONID="+document.MYFORM.ORGANIZATIONID.value;
	   alert(URL+"&ORGANIZATIONID="+document.MYFORM.ORGANIZATIONID.value);
     document.MYFORM.submit();
}
function setSubmit(URL,organizationID)
{
  if (document.MYFORM.ORGANIZATIONID.value==null || document.MYFORM.ORGANIZATIONID.value=="--")
  {
     alert("請選擇內外銷型別!!!");
	 return false;
  }
                        // 若未選擇任一Line 作動作,則警告
                        var chkFlag="FALSE";
                        if (document.MYFORM.CH.length!=null)
                        {
                          for (i=0;i<document.MYFORM.CH.length;i++)
                          {
                             if (document.MYFORM.CH[i].checked==true)
	                         {
	                           chkFlag="TURE";
	                         } 
                           }  // End of for	 
                           if (chkFlag=="FALSE" && document.MYFORM.CH.length!=null)
                           {
                             alert("請先選擇欲領料工令再送出!!!");   
                             return(false);
                           }
	                     } // End of if 
  
  if (document.MYFORM.ACTIONID.value=="025")  //表示為ISSUE動作
  { 
   flag=confirm("確認選定項目為領料項目?");      
   if (flag==false)  return(false);
  }   
     document.MYFORM.action=URL+"?ORGANIZATIONID="+organizationID;	
     document.MYFORM.submit();
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
 if((year%4==0&&year%100!=0)||(year%400==0)) 
 { 
 return true; 
 }  
 return false; 
} 

function check(field) 
{
 if (checkflag == "false") 
 {
    for (i = 0; i < field.length; i++)
    {  field[i].checked = true; }
     checkflag = "true";
   return "Cancel Selected";
}
else {
       for (i = 0; i < field.length; i++) 
       {  field[i].checked = false; }
       checkflag = "false";
       return "Select All";
	 }
}
</script>
<title>WIP Material Requirement Issue Entry</title>
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
.style18 {
	color: #000066;
	font-size: 24px;
	font-weight: bold;
	font-family: Georgia;
}
.style21 {
	font-size: 24px;
	color: #993300;
	font-family: "新細明體";
	font-weight: bold;
}
</STYLE>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
  String serverHostName=request.getServerName();
  String hostInfo=request.getRequestURL().toString();//REMOTE_HOST
   out.println(hostInfo);
   
   
   int indxHost = hostInfo.indexOf("8080/"); 
   
   hostInfo = hostInfo.substring(0,indxHost+5);
   
   out.println("hostInfo="+hostInfo);
   out.println("select SYSID from ORADDMAN.WS_SYSTEMS where HOST_INFO='"+hostInfo+"' ");
   
    //抓取WEB系統資訊
    String webSysID ="1";
    Statement stateWS=con.createStatement();
	ResultSet rsWS=stateWS.executeQuery("select SYSID from ORADDMAN.WS_SYSTEMS where HOST_INFO='"+hostInfo+"' ");
	if (rsWS.next())
	{
	   webSysID=rsWS.getString("SYSID");	 
	   out.println("webSysID="+webSysID);
	}
	rsWS.close();
    stateWS.close(); 
	//抓取WEB系統資訊 
	
	
   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");    
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String fromYear=request.getParameter("FROMYEAR");  
  if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
  String fromMonth=request.getParameter("FROMMONTH"); 
  if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
  String fromDay=request.getParameter("FROMDAY");
  if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
  queryDateFrom=fromYearString+fromMonthString+fromDayString;//設為搜尋收件起始日期的條件
  String toYear=request.getParameter("TOYEAR");
  if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  String toMonth=request.getParameter("TOMONTH");
  if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  String toDay=request.getParameter("TODAY");
  if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
  queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
  int maxrow=0;//查詢資料總筆數 
  String marketType=request.getParameter("MARKETTYPE");
  if (marketType==null || marketType.equals("--")) marketType="";
  
  String issueType=request.getParameter("ISSUETYPE");
  if (issueType==null || issueType.equals("--")) issueType="1";  // 預設以工令作領料作業
  
  String woType=request.getParameter("WOTYPE");  
  if (woType==null || woType.equals("--")) woType="%"; 
  
  String tt[][]=arrayWIPIssueSearchBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
  
  if (tt!=null)
  { 
   arrayWIPIssueSearchBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  }
  
   // 依選定內外銷別決定 Set Client Infor 於那個Parent Org ID (325) YEW_起   
   String orgOU = "";
   Statement stateOU=con.createStatement();   
   ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
   if (rsOU.next())
   {
     orgOU = rsOU.getString(1);
   }
   rsOU.close();
   stateOU.close();
   // 依選定內外銷別決定 Set Client Infor 於那個Parent Org ID (325) YEW_迄
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 //cs1.setString(1,"305"); 
	 cs1.setString(1,orgOU);  /*  41 --> 為台半半導體  42 --> 為事務機   325 --> YEW SEMI  */ 
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close(); 

  String wipEntityID = request.getParameter("WIPENTITYIDCH");
  String opSeqNum = request.getParameter("OPSEQNUM");
  String invItem = request.getParameter("INVITEM");
  String subInvDesc ="";
  String organizationID=request.getParameter("ORGANIZATIONID");
  String subInventory=request.getParameter("SUBINVENTORY");
  String wipEntityName = request.getParameter("SEARCHSTRING");
  String uom = request.getParameter("UOM");
  
  String createDateStr=request.getParameter("CREATEDATESTR");
  String createDateEnd=request.getParameter("CREATEDATEEND");
  
  if (organizationID==null || organizationID.equals("--") || organizationID.equals("null")) organizationID = "";
  
  if (createDateStr==null) createDateStr = dateBean.getYearMonthDay();
  if (createDateEnd==null) createDateEnd = dateBean.getYearMonthDay();
  
  if (opSeqNum==null || opSeqNum.equals("") || opSeqNum.equals("null")) opSeqNum = "";
  if (invItem==null || invItem.equals("") || invItem.equals("null")) invItem = "";
  if (wipEntityID==null || wipEntityID.equals("") || wipEntityID.equals("null")) wipEntityID = "";
  

  try
  {   
  
   Statement statement=con.createStatement();
   
   ResultSet rs=null;
   //out.println(" select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"' ");
   rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");   
   String sql=null;
   rs.next();
   statusDesc=rs.getString("LOCALDESC");
   statusName=rs.getString("STATUSNAME");     
   
   rs.close();  
   
   
   //取得資料總筆數
   if (UserRoles.indexOf("admin")>=0 ) //若為admin則可看到全部
   {	
      String sqlRCV = "";
	  
      if (issueType=="" || issueType.equals("") || issueType.equals("1")) // 若領料別為工令領料
	  {
      	           sqlRCV = " select count(DISTINCT a.WIP_ENTITY_ID) "+
				            " from WIP_REQUIREMENT_OPERATIONS A, MTL_SYSTEM_ITEMS B, WIP_ENTITIES C, YEW_WORKORDER_ALL D "+			                
			                " where A.WIP_ENTITY_ID = C.WIP_ENTITY_ID and A.WIP_ENTITY_ID = D.WIP_ENTITY_ID "+
							"   and B.INVENTORY_ITEM_ID = C.PRIMARY_ITEM_ID "+	
							"   and A.ORGANIZATION_ID = B.ORGANIZATION_ID "+						
							"   and A.WIP_SUPPLY_TYPE = 1 "+ // 加入Count 的條件				
							"   and to_char(A.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";					
			//if (wipEntityID==null || wipEntityID.equals("")) { sqlRCV = sqlRCV + " and A.WIP_ENTITY_ID = 0 ";  } // 若是未輸入任何條件即找無任何資料
			//else
			if (wipEntityID!=null && !wipEntityID.equals("") && !wipEntityID.equals("null")) sqlRCV = sqlRCV + " and A.WIP_ENTITY_ID ='"+wipEntityID+"' ";
			if (opSeqNum!=null && !opSeqNum.equals("") && !opSeqNum.equals("null")) sqlRCV = sqlRCV + " and A.OPERATION_SEQ_NUM = '"+opSeqNum+"' ";
			if (invItem!=null && !invItem.equals("")) sqlRCV = sqlRCV + " and B.SEGMENT1 = '"+invItem+"' ";
			if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) {  }
			else  {
			             sqlRCV = sqlRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			      }			     		  
		  out.println("sqlCOUNT="+sqlRCV+"<BR>");			
		} else if (issueType.equals("2")) // 若領料別為Item領料
		       {  						 
					       sqlRCV = " SELECT count(DISTINCT A.INVENTORY_ITEM_ID)  "+
									"   FROM MTL_SYSTEM_ITEMS A, WIP_REQUIREMENT_OPERATIONS B, YEW_WORKORDER_ALL C "+								
									"   WHERE A.SEGMENT1 = B.SEGMENT1 and B.WIP_ENTITY_ID = C.WIP_ENTITY_ID "+								
									"	  AND A.ORGANIZATION_ID=B.ORGANIZATION_ID "+
									"	  AND B.WIP_SUPPLY_TYPE = 1  "+
									"     AND to_char(B.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";							 				
				   if (invItem==null || invItem.equals("")) { sqlRCV = sqlRCV + " and A.SEGMENT1 = '0' ";  }
			       else if (invItem!=null && !invItem.equals("")) sqlRCV = sqlRCV + " and A.SEGMENT1 = '"+invItem+"' ";
			       if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			       else  {
			              sqlRCV = sqlRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			             }			        				
			   } // End of else if (issueType.equals("2")) // 若領料別為Item領料	 
			rs=statement.executeQuery(sqlRCV);		
      
   } else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0)
          { // 另外的角色是 YEW_IQC_INSPECTOR
             String sqlRCV = "";
             if (issueType=="" || issueType.equals("") || issueType.equals("1")) // 若領料別為工令領料
	         {
                   sqlRCV = " select count(DISTINCT a.WIP_ENTITY_ID) "+
				            " from WIP_REQUIREMENT_OPERATIONS A, MTL_SYSTEM_ITEMS B, "+
				            "      WIP_ENTITIES C, YEW_WORKORDER_ALL D "+			                
			                " where A.WIP_ENTITY_ID = C.WIP_ENTITY_ID and A.WIP_ENTITY_ID = D.WIP_ENTITY_ID "+
							"   and b.INVENTORY_ITEM_ID = c.PRIMARY_ITEM_ID "+	
							"   and A.ORGANIZATION_ID = B.ORGANIZATION_ID "+						
							"   and A.WIP_SUPPLY_TYPE = 1 "+ // 加入Count 的條件
							"   and D.DEPT_NO = '"+userMfgDeptNo+"' "+  //各統計人員只看得到自己製造部的工令
							"   and to_char(A.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";									
			       if (wipEntityID!=null && !wipEntityID.equals("") && !wipEntityID.equals("null")) sqlRCV = sqlRCV + " and A.WIP_ENTITY_ID ='"+wipEntityID+"' ";
			       if (opSeqNum!=null && !opSeqNum.equals("") && !opSeqNum.equals("null")) sqlRCV = sqlRCV + " and A.OPERATION_SEQ_NUM = '"+opSeqNum+"' ";
			       if (invItem!=null && !invItem.equals("")) sqlRCV = sqlRCV + " and B.SEGMENT1 = '"+invItem+"' ";
			       if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			       else  {
			               sqlRCV = sqlRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			             }				      			
			//out.println("sqlCOUNT="+sqlRCV+"<BR>");	
			} else if (issueType.equals("2")) // 若領料別為Item領料
		           {
					         sqlRCV = "  SELECT count(A.INVENTORY_ITEM_ID)  "+
									  "    FROM MTL_SYSTEM_ITEMS A, WIP_REQUIREMENT_OPERATIONS B, YEW_WORKORDER_ALL C "+								
									  "   WHERE A.SEGMENT1 = B.SEGMENT1 AND B.WIP_ENTITY_ID = C.WIP_ENTITY_ID  "+								
									  "	    AND A.ORGANIZATION_ID=B.ORGANIZATION_ID "+
									  "	    AND B.WIP_SUPPLY_TYPE = 1  "+
									  "     AND C.DEPT_NO = '"+userMfgDeptNo+"' "+  //各統計人員只看得到自己製造部的工令
									  "     AND to_char(B.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";	
							 if (invItem==null || invItem.equals("")) { sqlRCV = sqlRCV + " and A.SEGMENT1 = '0' ";  }		  	
			                 else if (invItem!=null && !invItem.equals("")) sqlRCV = sqlRCV + " and A.SEGMENT1 = '"+invItem+"' ";
			                 if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			                 else  {
			                        sqlRCV = sqlRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			                       }		          	
				   } // End of else if (issueType.equals("2")) // 若領料別為Item領料
			rs=statement.executeQuery(sqlRCV);	
         
	      } //end of else 非Admin 角色
//	} //end of 	
   rs.next();   
   maxrow=rs.getInt(1);
    
   statement.close();
   rs.close();   
   
  } //end of try
  catch (SQLException e)
  {
   out.println("ExceptionCOUNT:"+e.getMessage());
  } 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-300;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/300+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/301+1;  
  } else {
    currentPageNumber=rowNumber/300+1; 
  }	
  
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  


%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("確認取消?","確認選定項目為領料項目?")' ACTION="../jsp/TSCMfgWipMaterialReqPage.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&INVITEM=<%=invItem%>&ORGANIZATIONID=<%=organizationID%>" METHOD="POST"> 
<% 

%>
<span class="style21">WIP工令領料作業</span><FONT COLOR=RED SIZE=4>&nbsp;&nbsp;領料批單據狀態:<%=statusName%>(<%=statusDesc%>)</FONT><strong><FONT COLOR=BLACK>(總共<%=maxrow%>&nbsp;筆記錄)</FONT></strong>
<BR>
<img src="../image/search.gif"><font color="#003399">為查詢必選(填)欄位,需擇一輸入</font>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF">
 <tr bgcolor="#D8DEA9"><td width="13%" nowrap>內外銷型別<img src="../image/search.gif"></td>
   <td width="41%" nowrap>
     <%
	             try
                 {   
				   //-----取內外銷別
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select ORGANIZATION_ID, CODE_DESC from apps.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MARKETTYPE'  ";								  
				   String orderType = "  ";  
				   				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				   
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(organizationID);
	               comboBoxBean.setFieldName("ORGANIZATIONID");	   
                   out.println(comboBoxBean.getRsString());
				/* 
				   out.println("<select NAME='ORGANIZATIONID' onChange='setSubmitOrg("+'"'+"../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID=060&PAGEURL="+pageURL+'"'+")'>");
                   out.println("<OPTION VALUE=-->--");     
                   while (rs.next())
                   {            
                    String s1=(String)rs.getString(1); 
                    String s2=(String)rs.getString(2); 
                        
                    if (s1.equals(organizationID)) 
                    {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                    }   
			        else 
			        {
                      out.println("<OPTION VALUE='"+s1+"'>"+s2);
                    }        
                   } //end of while
                   out.println("</select>");
				   
		         */
				   rs.close();   
				   statement.close();
				 } //end of try		 
                 catch (Exception e)
				 { out.println("Exception:"+e.getMessage()); }  
	 %>
   </td>
   <td width="9%" nowrap>領料別</td>
   <td colspan="3" nowrap>
     <%
	             try
                 {   
				   //-----取領料別來源
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select CODE, CODE_DESC from APPS.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MFG_ISSUE_TYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(issueType);
	               comboBoxBean.setFieldName("ISSUETYPE");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();
				 } //end of try		 
                 catch (Exception e)
				 { out.println("Exception:"+e.getMessage()); }  
	 %>
   </td>
 </tr>
 <tr bgcolor="#D8DEA9"><td width="13%" nowrap>工令號</td>
     <td width="41%" nowrap>
	 <INPUT type="text" name="SEARCHSTRING" size=16 <%if (wipEntityName!=null) out.println("value="+wipEntityName);%>> 
	 <input type='button' name='SUBJOBCH' value='...' onClick='subWinDiscreteJobFind(this.form.SEARCHSTRING.value,"")'>	 
	 <input type="text" name="WIPENTITYIDCH" value="<%=wipEntityID%>">
    </td>
     <td width="9%" nowrap>工令站別</td>
     <td width="37%">
	     <INPUT type="text" name="OPERATION" size=5 value='<%=opSeqNum%>'>   
       <input type='button' name='OPERCH' value='...' onClick='subWinOperationFind(this.form.WIPENTITYIDCH.value)'>
      <INPUT type="text" name="OPERDESC" size=15 value='' readonly></A></td>    	
  </tr>
  <tr bgcolor="#D8DEA9">
    <td width="13%" nowrap>工令開立日起</td>
     <td width="41%"><input name="CREATEDATESTR" tabindex="2" type="text" size="8" value="<%=createDateStr%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.CREATEDATESTR);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
     <td width="9%" nowrap>工令開立日迄</td>
	 <td width="37%"><input name="CREATEDATEEND" tabindex="3" type="text" size="8" value="<%=createDateEnd%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.CREATEDATEEND);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
  </tr>
	 <tr bgcolor="#D8DEA9">
	   <td nowrap>料號品名<% if (issueType!=null && issueType.equals("2")) { %><img src="../image/search.gif"><% } %></td>
	   <td>
	      <input type="hidden" name='ITEMID' value='' size=3>
	      <input type="text" name="INVITEM" tabindex="5" size="20" onKeyDown="setItemFindCheck(this.form.ORGANIZATIONID.value,this.form.INVITEM.value,this.form.ITEMDESC.value)"><INPUT TYPE="button" tabindex="5" value="..." onClick='subWindowItemFind(this.form.ORGANIZATIONID.value,this.form.INVITEM.value,this.form.ITEMDESC.value)'>
		  <input type="text" name="ITEMDESC" tabindex="6"  size="25" onKeyDown="setItemFindCheck(this.form.ORGANIZATIONID.value,this.form.INVITEM.value,this.form.ITEMDESC.value)">
	   </td>
	   <td colspan="2">	   
		<INPUT TYPE="hidden" NAME="WOUOM" SIZE=20 value="<%=uom%>">  
		<INPUT name="button3" tabindex='20' TYPE="button" onClick="searchWIPIssue('<%=statusID%>','<%=pageURL%>')" value='查詢' >
	   </td>	   
	 </tr>    
</table>

<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</FONT><FONT COLOR=BLACK SIZE=2></FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'><strong><FONT COLOR=RED SIZE=2 face="Georgia">總共<%=maxrow%>&nbsp;筆記錄</FONT> </strong> 
	</td>    
  </tr>
</table>
<A HREF="../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&WIPENTITYIDCH=<%=wipEntityID%>&SCROLLROW=FIRST&ORGANIZATIONID=<%=organizationID%>&CREATEDATESTR=<%=createDateStr%>&CREATEDATEEND=<%=createDateEnd%>&OPSEQNUM=<%=opSeqNum%>&INVITEM=<%=invItem%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&WIPENTITYIDCH=<%=wipEntityID%>&SCROLLROW=LAST&ORGANIZATIONID=<%=organizationID%>&CREATEDATESTR=<%=createDateStr%>&CREATEDATEEND=<%=createDateEnd%>&OPSEQNUM=<%=opSeqNum%>&INVITEM=<%=invItem%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&WIPENTITYIDCH=<%=wipEntityID%>&SCROLLROW=300&ORGANIZATIONID=<%=organizationID%>&CREATEDATESTR=<%=createDateStr%>&CREATEDATEEND=<%=createDateEnd%>&OPSEQNUM=<%=opSeqNum%>&INVITEM=<%=invItem%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/../jsp/TSCMfgWipMaterialReqEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&WIPENTITYIDCH=<%=wipEntityID%>&SCROLLROW=-300&ORGANIZATIONID=<%=organizationID%>&CREATEDATESTR=<%=createDateStr%>&CREATEDATEEND=<%=createDateEnd%>&OPSEQNUM=<%=opSeqNum%>&INVITEM=<%=invItem%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;
<%   
 try
  {   
   //out.println("Step1"); 
   //out.println("UserRoles="+UserRoles);
    
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
   String sqlRCV ="";
   String whereRCV ="";
   String orderRCV = "";
   if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部收料單
   {  	//out.println("UserRoles="+UserRoles);  
      if (issueType=="" || issueType.equals("") || issueType.equals("1")) // 若領廖來源為工令領料
	  {    	          	  
		  	       sqlRCV = " select DISTINCT A.WIP_ENTITY_ID , C.WIP_ENTITY_NAME as 工令號, decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷') as 內外銷, B.SEGMENT1 as 製成品號, B.DESCRIPTION as 品號說明, C.CREATION_DATE as 工立開立日期 "+
			                "   from WIP_REQUIREMENT_OPERATIONS A, MTL_SYSTEM_ITEMS B, WIP_ENTITIES C, YEW_WORKORDER_ALL D ";				           
			     whereRCV = " where A.WIP_ENTITY_ID = C.WIP_ENTITY_ID and A.WIP_ENTITY_ID = D.WIP_ENTITY_ID "+ 
				            "   and B.INVENTORY_ITEM_ID = C.PRIMARY_ITEM_ID "+	
							"   and A.ORGANIZATION_ID = B.ORGANIZATION_ID "+						
							"   and A.WIP_SUPPLY_TYPE = 1 "+ // 一般物料(非Phatom件)的條件	
							"   and to_char(A.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";		
			     orderRCV = " order by decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷'), C.CREATION_DATE ";
				 
			//if (wipEntityID==null || wipEntityID.equals("")) { sqlRCV = sqlRCV + " and A.WIP_ENTITY_ID = 0 ";  } // 若是未輸入任何條件即找無任何資料
			//else 
			if (wipEntityID!=null && !wipEntityID.equals("") && !wipEntityID.equals("null")) whereRCV = whereRCV + " and A.WIP_ENTITY_ID ='"+wipEntityID+"' ";
			if (opSeqNum!=null && !opSeqNum.equals("")) whereRCV = whereRCV + " and A.OPERATION_SEQ_NUM = '"+opSeqNum+"' ";
			if (invItem!=null && !invItem.equals("")) whereRCV = whereRCV + " and B.SEGMENT1 = '"+invItem+"' ";
			if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			else  {
			             whereRCV = whereRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			      }		  
			sqlRCV = sqlRCV + whereRCV + orderRCV;
			out.println(sqlRCV);
	    } else if (issueType.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		       { 					
					     sqlRCV = " SELECT A.INVENTORY_ITEM_ID, A.SEGMENT1 as 領用品名, decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷') as 內外銷   "+
								  "   FROM MTL_SYSTEM_ITEMS A, WIP_REQUIREMENT_OPERATIONS B, YEW_WORKORDER_ALL C ";								
						whereRCV =  "   WHERE A.SEGMENT1 = B.SEGMENT1 and B.WIP_ENTITY_ID = C.WIP_ENTITY_ID "+								
									"	  AND A.ORGANIZATION_ID=B.ORGANIZATION_ID "+
									"	  AND B.WIP_SUPPLY_TYPE = 1 "+
									"     AND to_char(B.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";	
						orderRCV = "order by decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷'), A.INVENTORY_ITEM_ID ";
			            if (invItem==null || invItem.equals("")) { whereRCV = whereRCV + " and A.SEGMENT1 = '0' ";  }		  	
			            else if (invItem!=null && !invItem.equals("")) whereRCV = whereRCV + " and A.SEGMENT1 = '"+invItem+"' ";
			            if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			            else  {
			                    whereRCV = whereRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			                  }				     
			            sqlRCV = sqlRCV + whereRCV + orderRCV;			  
				  //out.println(sqlRCV);				  
			   } // End of else if (issueType.equals("2"))
		    rs=statement.executeQuery(sqlRCV); 	      
   } else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 )
          {   //out.println("UserRoles="+UserRoles); 
            if (issueType=="" || issueType.equals("") || issueType.equals("1")) // 若暫收來源為PO(採購單)收料
	        {          
				   sqlRCV = " select A.WIP_ENTITY_ID , C.WIP_ENTITY_NAME as 工令號, decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷') as 內外銷, B.SEGMENT1 as 製成品號, B.DESCRIPTION as 品號說明, C.CREATION_DATE as 工立開立日期 "+
			                " from WIP_REQUIREMENT_OPERATIONS A, MTL_SYSTEM_ITEMS B, "+
				            "      WIP_ENTITIES C, YEW_WORKORDER_ALL D ";
			     whereRCV = " where A.WIP_ENTITY_ID = C.WIP_ENTITY_ID and A.WIP_ENTITY_ID = D.WIP_ENTITY_ID "+
				            "   and b.INVENTORY_ITEM_ID = c.PRIMARY_ITEM_ID "+	
							"   and A.ORGANIZATION_ID = B.ORGANIZATION_ID "+	
							"   and D.DEPT_NO = '"+userMfgDeptNo+"' "+  // 各製造部統計只能看到自己所屬部門的工令					
							"   and A.WIP_SUPPLY_TYPE = 1 "+ // 一般物料(非Phatom件)的條件
							"   and to_char(A.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";		
			     orderRCV = " order by decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷'), C.CREATION_DATE ";
				 
				 if (wipEntityID!=null && !wipEntityID.equals("") && !wipEntityID.equals("null")) whereRCV = whereRCV + " and A.WIP_ENTITY_ID ='"+wipEntityID+"' ";
			     if (opSeqNum!=null && !opSeqNum.equals("")) whereRCV = whereRCV + " and A.OPERATION_SEQ_NUM = '"+opSeqNum+"' ";
			     if (invItem!=null && !invItem.equals("")) whereRCV = whereRCV + " and B.SEGMENT1 = '"+invItem+"' ";
			     if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			     else  {
			             whereRCV = whereRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			           }		  
			     sqlRCV = sqlRCV + whereRCV + orderRCV;
			     out.println(sqlRCV);
			 } else if (issueType.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		            { 
					    sqlRCV = " SELECT A.INVENTORY_ITEM_ID, A.SEGMENT1 as 領用品名, decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷') as 內外銷   "+
								 "   FROM MTL_SYSTEM_ITEMS A, WIP_REQUIREMENT_OPERATIONS B, YEW_WORKORDER_ALL C ";								
						whereRCV =  "   WHERE A.SEGMENT1 = B.SEGMENT1 and B.WIP_ENTITY_ID = C.WIP_ENTITY_ID "+								
									"	  AND A.ORGANIZATION_ID=B.ORGANIZATION_ID "+
									"	  AND B.WIP_SUPPLY_TYPE = 1  "+
									"     AND C.DEPT_NO = '"+userMfgDeptNo+"' "+  // 各製造部統計只能看到自己所屬部門的工令	
									"     AND to_char(B.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";	
						orderRCV = "order by decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷'), A.INVENTORY_ITEM_ID ";
						
						if (invItem==null || invItem.equals("")) { whereRCV = whereRCV + " and A.SEGMENT1 = '0' ";  }		  	
			            else if (invItem!=null && !invItem.equals("")) whereRCV = whereRCV + " and A.SEGMENT1 = '"+invItem+"' ";
			            if (organizationID==null || organizationID.equals("") || organizationID.equals("--")) { }
			            else  {
			                    whereRCV = whereRCV + " and A.ORGANIZATION_ID = "+organizationID+" "; // 取到的organizationID
			                  }				     
			            sqlRCV = sqlRCV + whereRCV + orderRCV;		 
						 //out.println(sqlRCV);	
					} // End of else if (issueType.equals("2"))
		        rs=statement.executeQuery(sqlRCV); 	      	 
          }   // 非管理員權限 out.println("UserRoles="+UserRoles); 
   //out.println("sqlArr=TT"); 
   if (rowNumber==1 || rowNumber<0)
   { 
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   
/*  
   
   // 將sql Result 存到arrayIQCSearchBean 內,作為下一頁候選依據_起
   String sqlArr ="";
     if (issueType=="" || issueType.equals("") || issueType.equals("1")) // 若暫收來源為PO(採購單)收料
	 {
	            " select DISTINCT A.WIP_ENTITY_ID , C.WIP_ENTITY_NAME as 工令號, decode(C.ORGANIZATION_ID,326,'內銷',327,'外銷') as 內外銷, B.SEGMENT1 as 製成品號, B.DESCRIPTION as 品號說明, C.CREATION_DATE as 工立開立日期 "+
			                "   from WIP_REQUIREMENT_OPERATIONS A, MTL_SYSTEM_ITEMS B, WIP_ENTITIES C  ";				           
			     whereRCV = " where A.WIP_ENTITY_ID = C.WIP_ENTITY_ID and B.INVENTORY_ITEM_ID = C.PRIMARY_ITEM_ID "+	
							"   and A.ORGANIZATION_ID = B.ORGANIZATION_ID "+						
							"   and A.WIP_SUPPLY_TYPE = 1 "+ // 一般物料(非Phatom件)的條件	
							"   and to_char(A.CREATION_DATE,'YYYYMMDD') between '"+createDateStr+"' and '"+createDateEnd+"' ";		
			     orderRCV = " order by C.CREATION_DATE ";
	 
	        sqlArr = " select A.WIP_ENTITY_ID , C.WIP_ENTITY_NAME, A. "+
		             "       A.INTERFACE_TRANSACTION_ID, A.SUPPLIER_ID, A.SUPPLIER, A.SUPPLIER_SITE_ID, A.SUPPLIER_SITE, A.RECEIPT_NUM, "+
				     "       to_char(A.RECEIPT_DATE,'YYYYMMDDHH24MISS') as RECEIPT_DATE, to_char(A.TRANSACTION_DATE,'YYYYMMDDHH24MISS') as TRANSACTION_DATE, A.WIP_ENTITY_ID,  "+
		             "       A.PO_NUM, A.SOURCE_DOC_QTY, A.TRANSACT_QTY, A.TRANSACT_UOM, A.ITEM_ID, B.SEGMENT1, A.ITEM_DESC, "+
				     "       A.VENDOR_LOT_NUM, A.PACKING_SLIP, A.ORGANIZATION_ID "+
					 "  from APPS.RCV_VRC_TXS_V A, MTL_SYSTEM_ITEMS B "+
					 "      ,( select count(SHIPMENT_LINE_ID) as COUNT_RCV, SHIPMENT_LINE_ID from RCV_TRANSACTIONS where TRANSACTION_TYPE='RECEIVE' group by SHIPMENT_LINE_ID ) C ";
	 } else if (issueType.equals("2")) // 若暫收來源為RMA(銷貨退回)
	        { 
			    sqlArr = " SELECT RT.INTERFACE_TRANSACTION_ID, RSH.RECEIPT_NUM ,OOHA.ORDER_NUMBER as PO_NUM, RC.PARTY_ID as SUPPLIER_SITE_ID, RC.CUSTOMER_NAME as SUPPLIER_SITE, "+
				         "        RC.CUSTOMER_NUMBER as SUPPLIER_ID, RC.CUSTOMER_NAME as SUPPLIER, RT.ORGANIZATION_ID, to_char(RT.TRANSACTION_DATE,'YYYYMMDDHH24MISS') as RECEIPT_DATE, "+
						 "        MSI.SEGMENT1 ,MSI.DESCRIPTION as ITEM_DESC, RT.QUANTITY as TRANSACT_QTY, RT.UNIT_OF_MEASURE , to_char(RT.TRANSACTION_DATE,'YYYYMMDDHH24MISS') as TRANSACTION_DATE, "+
						 "		  RSH.SHIPMENT_HEADER_ID, RSH.CUSTOMER_ID, RSL.SHIPMENT_LINE_ID, RT.SUBINVENTORY, RT.SOURCE_DOC_QUANTITY as SOURCE_DOC_QTY, "+
						 "		  RT.ORGANIZATION_ID ,RT.SOURCE_DOCUMENT_CODE SOURCE_TYPE, RT.WIP_ENTITY_ID, RSL.ITEM_ID, "+
						 "        RT.SOURCE_DOC_UNIT_OF_MEASURE as TRANSACT_UOM, 'N/A' as VENDOR_LOT_NUM, 'N/A' as PACKING_SLIP "+
						 "   FROM RCV_TRANSACTIONS RT ,RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL, "+
						 "		  OE_ORDER_HEADERS_ALL OOHA, RA_CUSTOMERS RC ,MTL_SYSTEM_ITEMS MSI ";				 
			}
	 sqlArr = sqlArr + whereRCV + orderRCV;
	 //out.println(sqlArr+"<BR>");
	 Statement stateArr=con.createStatement();	
	 ResultSet rsArr = stateArr.executeQuery(sqlArr);			 
     int iSeq=0;
     String a[][]=new String[maxrow+1][20]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
     while (rsArr.next())
	 {	   
		//out.println("TTT<BR>");	  
	    a[iSeq][0]=Integer.toString(iSeq+1);a[iSeq][1]=rsArr.getString("INTERFACE_TRANSACTION_ID");a[iSeq][2]=rsArr.getString("SUPPLIER_ID");a[iSeq][3]=rsArr.getString("SUPPLIER");
		a[iSeq][4]=rsArr.getString("SUPPLIER_SITE_ID");a[iSeq][5]=rsArr.getString("SUPPLIER_SITE");a[iSeq][6]=rsArr.getString("RECEIPT_NUM");a[iSeq][7] = rsArr.getString("RECEIPT_DATE");
		a[iSeq][8] = rsArr.getString("TRANSACTION_DATE");a[iSeq][9] = rsArr.getString("WIP_ENTITY_ID");a[iSeq][10] = rsArr.getString("PO_NUM");a[iSeq][11] = rsArr.getString("SOURCE_DOC_QTY");
		a[iSeq][12] = rsArr.getString("TRANSACT_QTY");a[iSeq][13] = rsArr.getString("TRANSACT_UOM");a[iSeq][14] = rsArr.getString("ITEM_ID");a[iSeq][15] = rsArr.getString("SEGMENT1");
		a[iSeq][16] = rsArr.getString("ITEM_DESC");a[iSeq][17] = rsArr.getString("VENDOR_LOT_NUM");a[iSeq][18] = rsArr.getString("PACKING_SLIP");a[iSeq][19] = rsArr.getString("ORGANIZATION_ID");
		
		if (rsArr.getString("VENDOR_LOT_NUM")==null || rsArr.getString("VENDOR_LOT_NUM").equals("") || rsArr.getString("VENDOR_LOT_NUM").equals("null"))
		{ 
		   a[iSeq][17] = "";
	    }  // 若當初未給廠商批號,則給空值予array		
	    arrayIQCSearchBean.setArray2DString(a);		
		//out.println("RRR<BR>");
		
		iSeq++;
	 } 
	 rsArr.close();
	 stateArr.close(); 
   // 將sql Result 存到arrayIQCSearchBean 內,作為下一頁候選依據_迄
   //out.println("UUU<BR>");
   
*/   
   
   String sKeyArray[]=new String[1];   
   sKeyArray[0]="WIP_ENTITY_ID";
   //sKeyArray[1]="RECEIPT_NUM";
   //sKeyArray[2]="PO_NO";
   //sKeyArray[1]="LINE";
   //sKeyArray[2]="ASSIGN_MANUFACT";
   //sKeyArray[3]="ORDER_TYPE_ID";
   //sKeyArray[4]="LINE_TYPE";   
   
   	
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);   
   //qryAllChkBoxEditBean.setSearchKey("INTERFACE_TRANSACTION_ID");
   qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   //qryAllChkBoxEditBean.setRowColor1("B0E0E6"); 
   qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(300);      
   out.println(qryAllChkBoxEditBean.getRsString());
 //  out.print("woNo="+WO_NO);
   statement.close();
   rs.close();   
  //out.println("VVV<BR>");
   //取得維修處理狀態      
  } //end of try  
  catch (Exception e)
  {
   e.printStackTrace();
   out.println("Exception queryAllChkBoxEditBean:"+e.getMessage());   
  }
 
	  try
      {       
       //2005-05-13 add 038		   
	      
	   if (statusID.equals("060"))
	   { 
	     String sqlAct = null;
		 String whereAct = null;
		 sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		 whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x1.ACTIONID = '025'";			 		 
		 
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_迄		  
	     sqlAct = sqlAct + whereAct;
         Statement statement=con.createStatement();
         ResultSet rs=statement.executeQuery(sqlAct);
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 out.println("</font></strong></td><TR><TR><td>");%>備註<%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
         // 2005-05-13 add 038 
		// if ((statusID.equals("003") && userActCenterNo.equals("001")) || UserRoles.equals("admin"))
		 
	     out.println("<strong><font color='#FF0000'>");%>執行動作-><%out.println("</font></strong>");
         out.println(comboBoxBean.getRsString());    
		 
		 String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		 String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
		 // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		 if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //若是管理員,則任何動作不受限制
		 else {
		          whereCnt = whereCnt+"and FORMID='WO' "; // 否則一律皆為外銷流程
		      }
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_迄	
		 sqlCnt = sqlCnt + whereCnt;
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           //out.println("<INPUT TYPE='button' NAME='submit' value='Submit'>");
		   %>
		    <INPUT name="SETSUBMIT" tabindex='20' TYPE="button" onClick='setSubmit("../jsp/TSCMfgWipMaterialReqPage.jsp",this.form.ORGANIZATIONID.value)'  value='Submit' >  
		   <%
		   if (statusID.equals("003") || statusID.equals("004") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>寄發郵件通知<%
           }			 
	     } 
		 
		 statement.close();		 
         rs.close();       
		} //end of if "003":"008":"010":"006":"015":"016":"017" 
       } //end of try
       catch (Exception e)
       {
	    e.printStackTrace();
        out.println("ExceptionAAA:"+e.getMessage());
       }	 	   
%>
<input type='hidden' name='JOBEXISTFLAG' value=''> 
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

