<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--20100307 Marvie Update : Add MC agree STATUSID="019" rcv_transactions.attribute12 "Y|07-MAR-2010 10:32:30|MING_LILI"-->
<!--20100927 Marvie Update : Add INV return STATUSID="029" -->
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
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") gfPop.fHideCal();	
}
var checkflag = "false";

function check(field) 
{
	if (checkflag == "false") 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = true;
		}
 		checkflag = "true";
 		return "Cancel Selected"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
 		return "Select All"; 
	}
}

function searchRepNo(svrTypeNo,statusID,pageURL) 
{   
  location.href="../jsp/TSCMfgDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&MARKETTYPE="+document.MYFORM.MARKETTYPE.value+"&WOTYPE="+document.MYFORM.WOTYPE.value ;
}

function searchIQCDocNo(statusID,pageURL) 
{   
	if (document.MYFORM.MARKETTYPE.value=="--" || document.MYFORM.MARKETTYPE.value=="")
  	{
    	alert("                     請選擇內/外銷新增檢驗批!!!\n依內外銷區分檢驗批應為QC人員檢驗之基本規範與職業道德\n            請勿造成系統維護人員之困擾,謝謝");
	  	document.MYFORM.MARKETTYPE.focus();
	  	return false;
  	}

  	if (document.MYFORM.CURRYCODE.value=="--" || document.MYFORM.CURRYCODE.value=="")   //20091117 liling add
  	{
    	alert("請選擇幣別!!");
	  	document.MYFORM.CURRYCODE.focus();
	  	return false;
  	}
	location.href="../jsp/TSIQCInspectLotEntry.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&RECEIPTSOURCE="+document.MYFORM.RECEIPTSOURCE.value+"&SUPPLYVNDID="+document.MYFORM.SUPPLYVNDID.value+"&RECEPTDATESTR="+document.MYFORM.RECEPTDATESTR.value+"&RECEPTDATEEND="+document.MYFORM.RECEPTDATEEND.value+"&PONO="+document.MYFORM.PONO.value+"&RECEIPTNO="+document.MYFORM.RECEIPTNO.value+"&MARKETTYPE="+document.MYFORM.MARKETTYPE.value+"&VENDORLOTNUM="+document.MYFORM.VENDORLOTNUM.value+"&CURRYCODE="+document.MYFORM.CURRYCODE.value;
}

function submitCheck(ms1,ms2)
{  
	if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  	{       
   		alert("請選擇執行動作!!!")
   		return(false);
  	} 
  	if (document.MYFORM.ACTIONID.value=="001")  //表示為TEMPORARY動作
  	{ 
   		flag=confirm(ms2);      
   		if (flag==false)  return(false);
  	}
  	if (document.MYFORM.ACTIONID.value=="002")  //表示為CREATE動作
  	{ 
   		alert("此處僅能選擇TEMPOARY動作!!!");      
   		return(false);
  	}
  	if (document.MYFORM.ACTIONID.value=="004")  // AGREE
  	{ 
   		flag=confirm("確認同意檢驗?");
   		if (flag==false)  return(false);
  	} 
  	if (document.MYFORM.ACTIONID.value=="005")  // REJECT
  	{ 
   		flag=confirm("確認不同意檢驗?");
   		if (flag==false)  return(false);
  	} 
  	// 20100927 Marvie Add : Add INV return
  	if (document.MYFORM.ACTIONID.value=="019")  // RETURN
  	{
   		flag=confirm("確認退回廠商?");
   		if (flag==false)  return(false);
  	}
  	return(true);
}
function NeedConfirm()
{ 
	flag=confirm("是否確定刪除?"); 
 	return flag;
}
function subWindowItemFind(invItem,itemDesc)
{    
	subWin=window.open("../jsp/subwindow/TSCInvItemInfoFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");  
} 
function tabWindowItemFind(invItem,itemDesc)
{      
	subWin=window.open("../jsp/subwindow/TSCInvItemInfoFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes");  
}
function setItemFindCheck(invItem,itemDesc)
{
	if (event.keyCode==13)
   	{ 
    	subWin=window.open("../jsp/subwindow/TSCInvItemInfoFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes"); 
   	}
}
// Click ... 找廠商基本資料_起
function subWindowSupplierFind(vndNo, vndName)
{
	subWin=window.open("../jsp/subwindow/TSCVendorInfoFind.jsp?SUPPLYVNDNO="+vndNo+"&SUPPLYVND="+vndName,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes"); 
}
// Click ... 找廠商基本資料_迄
// Enter ... 找廠商基本資料_起
function setWindowSupplierFind(vndNo, vndName)
{
	if (event.keyCode==13) // 若於欄位內按下Enter
   	{ 
    	subWin=window.open("../jsp/subwindow/TSCVendorInfoFind.jsp?SUPPLYVNDNO="+vndNo+"&SUPPLYVND="+vndName,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes"); 
   	}
}
// Enter ... 找廠商基本資料_迄
function setSubmitQuery(URL,supplier,vendor,vendorNo,receiptDateBeg,receiptDateEnd,poNo,receiptNo)
{ 
	var suppID = "&SUPPLIERID="+supplier+"&RECEPTDATEBEG="+receiptDateBeg+"&RECEPTDATEEND="+receiptDateEnd;
    if ( (document.MYFORM.SUPPLYVND.value==null || document.MYFORM.SUPPLYVND.value=="") && (document.MYFORM.PONO.value==null || document.MYFORM.PONO.value=="") && (document.MYFORM.RECEIPTNO.value==null || document.MYFORM.RECEIPTNO.value=="") ) //若未輸入供應商或PO號或收料單號,則顯示警告訊息
	{
		alert("請輸入供應商、採購單號或收料單號為來源依據!!!");
	 	document.MYFORM.SUPPLYVND.focus(); 
	 	return(false);
	} 
	else 
	{
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
	} 
	else 
	{
		document.MYFORM.action=URL+suppID;
        document.MYFORM.submit();
	}	
} 
function setSubmit1a()
{
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


function checkValue(irow)
{
	if (document.MYFORM.SOURCEID.value == "020")
	{
		var len = document.MYFORM.CH.length;
		var sitem = document.getElementById(irow+"_6").value;
		var svendor = document.getElementById(irow+"_4").value;
		for (i = 0; i < len; i++) 
		{
			if ((document.MYFORM.CH[i].checked == true) && ((i+1) != irow))
			{
				var vitem = document.getElementById((i+1)+"_6").value;
				var vendor = document.getElementById((i+1)+"_4").value;
				if (sitem.substr(0,3)=="10-" || sitem.substr(0,3)=="11-" || vitem.substr(0,3)=="10-" || vitem.substr(0,3)=="11-") 
				{
					if (sitem != vitem)
					{
						alert("料號必須相同!!");
						document.MYFORM.CH[(irow-1)].checked=false;
						return false;
					}
				}
				else if (svendor != vendor)
				{
					alert("供應商必須相同!!");
					document.MYFORM.CH[(irow-1)].checked=false;
					return false;
				}
			}
		}
	}
}
</script>
<title>IQC Receipt Inspect Lot Entry</title>
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
.style19 {
	color: #990000;
	font-size: 24px;
}
</STYLE>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
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
String curryCode=request.getParameter("CURRYCODE");
if (curryCode==null || curryCode.equals("--")) curryCode="CNY";
String receiptSource=request.getParameter("RECEIPTSOURCE");
if (receiptSource==null || receiptSource.equals("--")) receiptSource="1";
String woType=request.getParameter("WOTYPE");  
if (woType==null || woType.equals("--")) woType="%"; 
String vendorLotNum=request.getParameter("VENDORLOTNUM"); 
if (vendorLotNum==null || vendorLotNum.equals("")) vendorLotNum = "";
String tt[][]=arrayIQCDocumentInputBean.getArray2DContent();    // FOR 品管檢驗數據輸入完成判定
if (tt!=null)
{ 
	arrayIQCDocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
}
// 依選定內外銷別決定 Set Client Infor 於那個Parent Org ID (305) YEW 
String orgOU = "";
Statement stateOU=con.createStatement();   
ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
if (rsOU.next())
{
	orgOU = rsOU.getString(1);
}
rsOU.close();
stateOU.close();

//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
cs1.setString(1,orgOU);  /*  41 --> 為台半半導體  42 --> 為事務機   325 --> YEW SEMI  */ 
cs1.execute();
cs1.close(); 

String supplyVndID = request.getParameter("SUPPLYVNDID");
String supplyVndNo = request.getParameter("SUPPLYVNDNO");
String supplyVnd = request.getParameter("SUPPLYVND");
String supplierName ="";
String receptDateStr=request.getParameter("RECEPTDATESTR");
String receptDateEnd=request.getParameter("RECEPTDATEEND");
String poNo = request.getParameter("PONO");
String receiptNo = request.getParameter("RECEIPTNO");
if (receptDateStr==null) receptDateStr = dateBean.getYearMonthDay();
if (receptDateEnd==null) receptDateEnd = dateBean.getYearMonthDay();
if (supplyVndID==null) supplyVndID = "";
if (supplyVndNo==null) supplyVndNo = "";
if (poNo==null) poNo = "";
if (receiptNo==null) receiptNo = "";
if (supplyVnd==null || supplyVnd.equals("")) supplyVnd = "";

try
{       
	Statement statement=con.createStatement();
   	ResultSet rs=null;
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
      	if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1")) // 若暫收來源為PO(採購單)收料
	  	{         
 			sqlRCV =" select COUNT(rt.interface_transaction_id)  "+
  				 	"   from rcv_transactions rt, rcv_shipment_headers rsh, rcv_shipment_lines rsl,PO_VENDOR_SITES_ALL POVS,  "+
       				"         po_headers_all poh, po_line_locations_all poll, po_vendors pov, mtl_system_items_b i  "+
  				    " where rsh.shipment_header_id = rt.shipment_header_id  and rsl.shipment_line_id = rt.shipment_line_id "+
   					"   and poh.po_header_id = rt.po_header_id    and poll.line_location_id = rt.po_line_location_id "+
   					"   and pov.vendor_id = rt.vendor_id and povs.vendor_site_id = rt.vendor_site_id   and i.inventory_item_id = rsl.item_id    and i.organization_id = rt.organization_id "+
					"   and i.INVENTORY_ITEM_FLAG='Y' "+  //20140505 liling 費用類不該出現
                    "   and rt.TRANSACTION_TYPE='RECEIVE' and rt.DESTINATION_TYPE_CODE = 'RECEIVING'  "+
  					"   and not exists ( select shipment_line_id  from rcv_transactions "+
					"                     where shipment_line_id = rt.shipment_line_id  and (transaction_type != 'RECEIVE' or destination_type_code != 'RECEIVING') ) "+
 					"   and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d "+
					"				       where LSTATUSID != '013'  and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  "+
  					"   and rt.transaction_date between to_date('"+receptDateStr+"','YYYYMMDD') and to_date('"+receptDateEnd+"235959','YYYYMMDDHH24MISS') ";
			if (supplyVndID!=null && !supplyVndID.equals("")) sqlRCV = sqlRCV + " and RT.VENDOR_ID ='"+supplyVndID+"' ";
			if (poNo!=null && !poNo.equals("")) sqlRCV = sqlRCV + " and POH.SEGMENT1 = '"+poNo+"' ";
			if (receiptNo!=null && !receiptNo.equals("")) sqlRCV = sqlRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{    
				sqlRCV = sqlRCV + " and RT.ORGANIZATION_ID = '"+marketType+"' ";   
			}  // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				sqlRCV = sqlRCV + " and RT.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}	

		    if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))   //20091117 liling add
			{ 
				sqlRCV = sqlRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
	        else  
			{
		    	sqlRCV = sqlRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
		    }

			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				sqlRCV = sqlRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}     
			// 20100307 Marvie Add : Add MC agree
			if (statusID.equals("019")) sqlRCV = sqlRCV + " and rt.attribute12 is null ";
			else if (statusID.equals("029")) sqlRCV = sqlRCV + " and substr(rt.attribute12,1,1)='N' ";   // 20100927 Marvie Add : Add INV return
			else sqlRCV = sqlRCV + " and substr(rt.attribute12,1,1)='Y' ";
		} 
		else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		{  	
			sqlRCV = " SELECT count(RT.INTERFACE_TRANSACTION_ID)  "+
					 "   FROM RCV_TRANSACTIONS RT ,RCV_SHIPMENT_HEADERS RSH,RCV_SHIPMENT_LINES  RSL, "+
					 "		 OE_ORDER_HEADERS_ALL OOHA,RA_CUSTOMERS  RC ,MTL_SYSTEM_ITEMS MSI  "+
					 "   WHERE  RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID  "+
				  	 "     AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID       "+
					 "     AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
					 "     AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
				 	 "	  AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
					 "	  AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  ";
			if (receiptNo!=null && !receiptNo.equals("")) sqlRCV = sqlRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--"))
			{    
				sqlRCV = sqlRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' ";   
			}  // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				sqlRCV = sqlRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}		
			if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))   //20091117 liling add
			{ 
				sqlRCV = sqlRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
			else  
			{
				sqlRCV = sqlRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			}
	  		if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				sqlRCV = sqlRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}		  	        				
		} // End of else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料	     
		rs=statement.executeQuery(sqlRCV);		
	} 
	else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 || UserRoles.indexOf("YEW_IQC_MC")>=0 || UserRoles.indexOf("YEW_MFG_PC")>=0 || UserRoles.indexOf("YEW_IQC_QUERY")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0)     // 20100927 Marvie Add : Add INV return
    {  
		// 另外的角色是 YEW_IQC_INSPECTOR
        String sqlRCV = "";
        if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1")) // 若暫收來源為PO(採購單)收料
	    {
 			sqlRCV = " select COUNT(rt.interface_transaction_id)  "+
  					 "   from rcv_transactions rt, rcv_shipment_headers rsh, rcv_shipment_lines rsl,PO_VENDOR_SITES_ALL POVS,  "+
       				 "         po_headers_all poh, po_line_locations_all poll, po_vendors pov, mtl_system_items_b i  "+
  				     " where rsh.shipment_header_id = rt.shipment_header_id  and rsl.shipment_line_id = rt.shipment_line_id "+
   					 "   and poh.po_header_id = rt.po_header_id    and poll.line_location_id = rt.po_line_location_id "+
   					 "   and pov.vendor_id = rt.vendor_id and povs.vendor_site_id = rt.vendor_site_id   and i.inventory_item_id = rsl.item_id    and i.organization_id = rt.organization_id "+
					 "   and i.INVENTORY_ITEM_FLAG='Y' "+  //20140505 liling 費用類不該出現					 
                     "   and rt.TRANSACTION_TYPE='RECEIVE' and rt.DESTINATION_TYPE_CODE = 'RECEIVING'  "+
  					 "   and not exists ( select shipment_line_id  from rcv_transactions "+
					 "                     where shipment_line_id = rt.shipment_line_id  and (transaction_type != 'RECEIVE' or destination_type_code != 'RECEIVING') ) "+
 					 "   and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d "+
					 "				       where LSTATUSID != '013'  and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  "+
  					 "   and rt.transaction_date between to_date('"+receptDateStr+"','YYYYMMDD') and to_date('"+receptDateEnd+"235959','YYYYMMDDHH24MISS') ";
			if (supplyVndID!=null && !supplyVndID.equals("")) sqlRCV = sqlRCV + " and RT.VENDOR_ID ='"+supplyVndID+"' ";
			if (poNo!=null && !poNo.equals("")) sqlRCV = sqlRCV + " and POH.SEGMENT1 = '"+poNo+"' ";
			if (receiptNo!=null && !receiptNo.equals("")) sqlRCV = sqlRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";			          if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{    
				sqlRCV = sqlRCV + " and rt.ORGANIZATION_ID = '"+marketType+"' ";   
			}  // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				sqlRCV = sqlRCV + " and rt.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}	
			if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))   //20091117 liling add
			{ 
				sqlRCV = sqlRCV + " and rt.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
			else  
			{
				sqlRCV = sqlRCV + " and rt.CURRENCY_CODE = '"+curryCode+"' "; 
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				sqlRCV = sqlRCV + " and rt.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}				      			
	        // 20100307 Marvie Add : Add MC agree
			if (statusID.equals("019")) sqlRCV = sqlRCV + " and rt.attribute12 is null ";
			else if (statusID.equals("029")) sqlRCV = sqlRCV + " and substr(rt.attribute12,1,1)='N' ";   // 20100927 Marvie Add : Add INV return
			else sqlRCV = sqlRCV + " and substr(rt.attribute12,1,1)='Y' ";
		} 
		else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		{
			sqlRCV = " SELECT count(RT.INTERFACE_TRANSACTION_ID)  "+
					 "   FROM RCV_TRANSACTIONS RT ,RCV_SHIPMENT_HEADERS RSH,RCV_SHIPMENT_LINES  RSL, "+
					 "		 OE_ORDER_HEADERS_ALL OOHA,RA_CUSTOMERS  RC ,MTL_SYSTEM_ITEMS MSI   "+
					 "   WHERE  RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID  "+
					 "     AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID       "+
					 "     AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
					 "     AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
					 "	  AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
					 "	  AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  ";
			if (receiptNo!=null && !receiptNo.equals("")) sqlRCV = sqlRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{ 
				sqlRCV = sqlRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; 
			}
			else  
			{
				sqlRCV = sqlRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			}	
			if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))   //20091117 liling add
			{ 
				sqlRCV = sqlRCV+ " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
			else  
			{
				sqlRCV = sqlRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				sqlRCV = sqlRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}				          	
		} // End of else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		rs=statement.executeQuery(sqlRCV);	
	} //end of else 非Admin 角色
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
} 
else 
{
	if (scrollRow.equals("LAST")) 
   	{  	 	 
		qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 	rowNumber=maxrow-300;	 	 	   
   	} 
	else 
	{     
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
} 
else 
{
	currentPageNumber=rowNumber/300+1; 
}	
if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
// 20100307 Marvie Add : Add MC agree
String nextPageLink;
if (statusID.equals("019") || statusID.equals("029"))
	nextPageLink="../jsp/TSIQCInspectLotMInsert.jsp?UPDATE=Y";
else
	nextPageLink="../jsp/TSIQCInspectLotInput.jsp?SULLPYVNDID="+supplyVndID+"&RECEPTDATESTR="+receptDateStr+"&RECEPTDATEEND="+receptDateEnd+"&PONO="+poNo+"&RECEIPTNO="+receiptNo;

// 20100927 Marvie Add : Add INV return
String titleStatus;
if (statusID.equals("020")) titleStatus="(物管同意)";
else if (statusID.equals("029")) titleStatus="(物管不同意)";
else titleStatus="";
%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("確認取消?","確認選定項目為檢驗批?")' ACTION="<%=nextPageLink%>" METHOD="POST"> 
<% 
%>
<span class="style18">TSC</span><span class="style19">採購單暫收區收料單據查詢<%=titleStatus%></span>
<BR>
<input type="hidden" name="SOURCEID" value="<%=statusID%>">
<img src="../image/search.gif"><font color="#003399">為查詢必選(填)欄位,需擇一輸入</font>
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF">
 <tr bgcolor="#D8DEA9"><td width="6%" nowrap>內外銷型別<img src="../image/search.gif"></td>
   <td width="10%" nowrap>
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
	rs=statement.executeQuery(sqlOrgInf);
	comboBoxBean.setRs(rs);
	comboBoxBean.setSelection(marketType);
	comboBoxBean.setFieldName("MARKETTYPE");	   
	out.println(comboBoxBean.getRsString());
	rs.close();   
	statement.close();
} //end of try		 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage()); 
}  
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;幣別&nbsp;
<%
try
{   
	//-----20091117 Liling 取幣別
	Statement statementC=con.createStatement();
	ResultSet rsC=null;	
	String sqlCurry = " select  CODE_DESC, CODE_DESC from yew_mfg_defdata where DEF_TYPE='CURR_CODE' ";

   	rsC=statementC.executeQuery(sqlCurry);
   	comboBoxBean.setRs(rsC);
   	comboBoxBean.setSelection(curryCode);
   	comboBoxBean.setFieldName("CURRYCODE");	   
   	out.println(comboBoxBean.getRsString());
   	rsC.close();   
   	statementC.close();
} //end of try		 
catch (Exception e)
{ 
	out.println("Exception sqlCurry:"+e.getMessage()); 
}
%>
	</td>
   	<td width="9%" nowrap>收料來源</td>
   	<td colspan="1" nowrap>
<%
try
{   
	//-----取暫收區來源
	Statement statement=con.createStatement();
	ResultSet rs=null;	
	String sqlOrgInf = " select CODE, CODE_DESC from apps.YEW_MFG_DEFDATA ";
	String whereOType = " where DEF_TYPE='RECEIPT_SOURCE' ";
   	if (statusID.equals("019") || statusID.equals("029"))  whereOType = whereOType + " AND CODE='1' ";
   	String orderType = "  ";
				   
   	sqlOrgInf = sqlOrgInf + whereOType;
   	rs=statement.executeQuery(sqlOrgInf);
   	comboBoxBean.setRs(rs);
   	comboBoxBean.setSelection(receiptSource);
   	comboBoxBean.setFieldName("RECEIPTSOURCE");	   
   	out.println(comboBoxBean.getRsString());
   	rs.close();   
   	statement.close();
} //end of try		 
catch (Exception e)
{ 
	out.println("Exception:"+e.getMessage()); 
}  
%>
	</td>
  	<td width="9%" nowrap>供應商批號</td>
   	<td colspan="1" nowrap><input type="text" size="25" name="VENDORLOTNUM" maxlength="30" value="<%=vendorLotNum%>"></td>
 </tr>
 <tr bgcolor="#D8DEA9"><td width="6%" nowrap>供應商</td>
     <td width="29%" nowrap>
	 <input type="hidden" size="5" name="SUPPLYVNDID" maxlength="10" value="<%=supplyVndID%>">
	 <input type="text" size="5" name="SUPPLYVNDNO" maxlength="10" value="<%=supplyVndNo%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">
	 <INPUT TYPE="button" value="..." onClick='subWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)'>
	 <input type="text" size="25" name="SUPPLYVND" maxlength="50" value="<%=supplyVnd%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">	  
    </td>
     <td width="9%" nowrap>收料日起</td>
     <td width="20%"><input name="RECEPTDATESTR" tabindex="2" type="text" size="8" value="<%=receptDateStr%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATESTR);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
     <td width="9%" nowrap>收料日迄</td>
	 <td width="27%"><input name="RECEPTDATEEND" tabindex="3" type="text" size="8" value="<%=receptDateEnd%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATEEND);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
  </tr>
	 <tr bgcolor="#D8DEA9">
	   <td nowrap>採購單號</td><td><input type="text" size="15" name="PONO" tabindex='4' maxlength="20" value="<%=poNo%>" onKeyDown="setSubmit1a('../jsp/TSCIQCInspectLotInput.jsp')"></td>
	   <td>收料單號</td><td><input type="text" size="15" name="RECEIPTNO" tabindex='5' maxlength="20" value="<%=receiptNo%>" onKeyDown="setSubmit1a('../jsp/TSCIQCInspectLotInput.jsp')"></td>	   
	   <td colspan="2" rowspan="2">
	       <!--%<INPUT name="button3" tabindex='20' TYPE="button" onClick='setSubmitQuery("../jsp/TSIQCInspectLotInput.jsp?QUERY=Y",this.form.SUPPLYVND.value,this.form.VENDOR.value,this.form.SUPPLYVNDNO.value,this.form.RECEPTDATEBEG.value,this.form.RECEPTDATEEND.value,this.form.PONO.value,this.form.RECEIPTNO.value)'  value='查詢' >%-->
		   <INPUT name="button3" tabindex='20' TYPE="button" onClick="searchIQCDocNo('<%=statusID%>','<%=pageURL%>')" value='查詢' >
	   </td>
	 </tr>    
</table>
<input name="VENDOR" type="hidden" size="25" value="<%=supplierName%>" readonly>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</FONT><FONT COLOR=BLACK SIZE=2></FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'><strong><FONT COLOR=RED SIZE=2 face="Georgia">總共<%=maxrow%>&nbsp;筆記錄</FONT> </strong> 
	</td>    
  </tr>
</table>
<A HREF="../jsp/TSIQCInspectLotEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SUPPLYVNDID=<%=supplyVndID%>&SCROLLROW=FIRST&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&PONO=<%=poNo%>&RECEIPTNO=<%=receiptNo%>&MARKETTYPE=<%=marketType%>&VENDORLOTNUM=<%=vendorLotNum%>&CURRYCODE=<%=curryCode%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectLotEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SUPPLYVNDID=<%=supplyVndID%>&SCROLLROW=LAST&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&PONO=<%=poNo%>&RECEIPTNO=<%=receiptNo%>&MARKETTYPE=<%=marketType%>&VENDORLOTNUM=<%=vendorLotNum%>&CURRYCODE=<%=curryCode%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSIQCInspectLotEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SUPPLYVNDID=<%=supplyVndID%>&SCROLLROW=300&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&PONO=<%=poNo%>&RECEIPTNO=<%=receiptNo%>&MARKETTYPE=<%=marketType%>&VENDORLOTNUM=<%=vendorLotNum%>&CURRYCODE=<%=curryCode%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/../jsp/TSIQCInspectLotEntry.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SUPPLYVNDID=<%=supplyVndID%>&SCROLLROW=-300&RECEPTDATESTR=<%=receptDateStr%>&RECEPTDATEEND=<%=receptDateEnd%>&PONO=<%=poNo%>&RECEIPTNO=<%=receiptNo%>&MARKETTYPE=<%=marketType%>&VENDORLOTNUM=<%=vendorLotNum%>&CURRYCODE=<%=curryCode%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;
<%   
try
{ 
	Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   	ResultSet rs=null;
   	String sql=null;  
   	String sqlRCV ="";
   	String whereRCV ="";
   	String orderRCV = "";
   	if (UserRoles.indexOf("admin")>=0) //若角色為admin則可看到全部收料單
   	{  	
    	if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1")) // 若暫收來源為PO(採購單)收料
	  	{         
 			sqlRCV = " select rt.interface_transaction_id AS ID, rsh.receipt_num AS 收料單號, poh.segment1 AS 採購單號,  "+
       				 "        POVS.VENDOR_SITE_CODE as 供應商, rt.currency_code as 幣別,i.segment1 AS 料號, rsl.item_description as 料號說明,  "+
        			 "        rt.vendor_lot_num as 供應商批號,to_char(poll.need_by_date,'yyyy/mm/dd') as PO預交日, rt.quantity 收料數量,poll.quantity as 採購單數量 ,  "+
	    			 "        rt.unit_of_measure as 單位, to_char(rsl.creation_date,'YYYY/MM/DD HH24:MI:SS') as 收料日期  "+
  					 "   from rcv_transactions rt, rcv_shipment_headers rsh, rcv_shipment_lines rsl,PO_VENDOR_SITES_ALL POVS,  "+
       				 "         po_headers_all poh, po_line_locations_all poll, po_vendors pov, mtl_system_items_b i  ";
  			whereRCV = " where rsh.shipment_header_id = rt.shipment_header_id  and rsl.shipment_line_id = rt.shipment_line_id "+
   					 "   and poh.po_header_id = rt.po_header_id    and poll.line_location_id = rt.po_line_location_id "+
   					 "   and pov.vendor_id = rt.vendor_id and povs.vendor_site_id = rt.vendor_site_id   and i.inventory_item_id = rsl.item_id    and i.organization_id = rt.organization_id "+
					 "   and i.INVENTORY_ITEM_FLAG='Y' "+  //20140505 liling 費用類不該出現					 
                     "   and rt.TRANSACTION_TYPE='RECEIVE' and rt.DESTINATION_TYPE_CODE = 'RECEIVING'  "+
  					 "   and not exists ( select shipment_line_id  from rcv_transactions "+
					 "                     where shipment_line_id = rt.shipment_line_id  and (transaction_type != 'RECEIVE' or destination_type_code != 'RECEIVING') ) "+
 					 "   and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d "+
					 "				       where LSTATUSID != '013'  and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  "+
  					 "   and rt.transaction_date between to_date('"+receptDateStr+"','YYYYMMDD') and to_date('"+receptDateEnd+"235959','YYYYMMDDHH24MISS') ";
            orderRCV = " order by pov.vendor_name, i.segment1, rsl.creation_date  ";
			if (supplyVndID!=null && !supplyVndID.equals("")) whereRCV = whereRCV + " and pov.vendor_id ='"+supplyVndID+"' ";
			if (poNo!=null && !poNo.equals("")) whereRCV = whereRCV + " and poh.segment1 = '"+poNo+"' ";
			if (receiptNo!=null && !receiptNo.equals("")) whereRCV = whereRCV + " and rsh.receipt_num = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--"))
			{ 
				whereRCV = whereRCV + " and rt.ORGANIZATION_ID = '"+marketType+"' "; 
			} // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				whereRCV = whereRCV + " AND rt.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}
            //20091117 liling add curryCode for YEW issue
			if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))
			{ 
				whereRCV = whereRCV + " and rt.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
			else  
			{
				whereRCV = whereRCV + " and rt.CURRENCY_CODE = '"+curryCode+"' "; 
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				whereRCV = whereRCV + " and rt.vendor_lot_num = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}
			// 20100307 Marvie Add : Add MC agree
			if (statusID.equals("019")) whereRCV = whereRCV + " and rt.attribute12 is null ";
			else if (statusID.equals("029")) whereRCV = whereRCV + " and substr(rt.attribute12,1,1)='N' ";   // 20100927 Marvie Add : Add INV return
			else whereRCV = whereRCV + " and substr(rt.attribute12,1,1)='Y' ";
			sqlRCV = sqlRCV + whereRCV + orderRCV;
	    } 
		else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		{ 					
			sqlRCV = " SELECT RT.INTERFACE_TRANSACTION_ID as ID, RSH.RECEIPT_NUM ,OOHA.ORDER_NUMBER, RC.CUSTOMER_NAME, "+
			 		 "        MSI.SEGMENT1, MSI.DESCRIPTION, RT.QUANTITY, RT.UNIT_OF_MEASURE , RT.TRANSACTION_DATE, "+
					 "		 RSH.SHIPMENT_HEADER_ID, RSH.CUSTOMER_ID, RSL.SHIPMENT_LINE_ID, RT.SUBINVENTORY, "+
					 "		 RT.ORGANIZATION_ID , RT.SOURCE_DOCUMENT_CODE  SOURCE_TYPE "+
					 "   FROM RCV_TRANSACTIONS RT , RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL, "+
					 "		 OE_ORDER_HEADERS_ALL OOHA, RA_CUSTOMERS RC , MTL_SYSTEM_ITEMS MSI ";
			whereRCV = "   WHERE RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID  "+
					   "     AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID       "+
					   "     AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
					   "     AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
					   "	  AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
					   "	  AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  "+
					   " and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d where LSTATUSID != '013' "+  //2009/04/10 修改為 not exists  from speed
                       "                     and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  ";
			if (receiptNo!=null && !receiptNo.equals("")) whereRCV = whereRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{ 
				whereRCV = whereRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; 
			}  // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				whereRCV = whereRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				whereRCV = whereRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			} 
			sqlRCV = sqlRCV + whereRCV + orderRCV;			  
		} // End of else if (receiptSource.equals("2"))
		rs=statement.executeQuery(sqlRCV); 		  		
   	} 
	else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 || UserRoles.indexOf("YEW_IQC_MC")>=0 || UserRoles.indexOf("YEW_MFG_PC")>=0 || UserRoles.indexOf("YEW_IQC_QUERY")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0)    // 20100927 Marvie Add : Add INV return
    {   
    	if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1")) // 若暫收來源為PO(採購單)收料
	    {          
 			sqlRCV = " select rt.interface_transaction_id AS ID, rsh.receipt_num AS 收料單號, poh.segment1 AS 採購單號,  "+
       				 "        POVS.VENDOR_SITE_CODE as 供應商, rt.currency_code as 幣別,i.segment1 AS 料號, rsl.item_description as 料號說明,  "+
        			 "        rt.vendor_lot_num as 供應商批號,to_char(poll.need_by_date,'yyyy/mm/dd') as PO預交日, rt.quantity 收料數量,poll.quantity as 採購單數量 ,  "+
	    			 "        rt.unit_of_measure as 單位, to_char(rsl.creation_date,'YYYY/MM/DD HH24:MI:SS') as 收料日期  "+
  					 "   from rcv_transactions rt, rcv_shipment_headers rsh, rcv_shipment_lines rsl,PO_VENDOR_SITES_ALL POVS,  "+
       				 "         po_headers_all poh, po_line_locations_all poll, po_vendors pov, mtl_system_items_b i  ";
  		 	whereRCV = " where rsh.shipment_header_id = rt.shipment_header_id  and rsl.shipment_line_id = rt.shipment_line_id "+
   					 "   and poh.po_header_id = rt.po_header_id    and poll.line_location_id = rt.po_line_location_id "+
   					 "   and pov.vendor_id = rt.vendor_id and povs.vendor_site_id = rt.vendor_site_id   and i.inventory_item_id = rsl.item_id    and i.organization_id = rt.organization_id "+
				 	 "   and i.INVENTORY_ITEM_FLAG='Y' "+  //20140505 liling 費用類不該出現					 
                     "   and rt.TRANSACTION_TYPE='RECEIVE' and rt.DESTINATION_TYPE_CODE = 'RECEIVING'  "+
  					 "   and not exists ( select shipment_line_id  from rcv_transactions "+
					 "                     where shipment_line_id = rt.shipment_line_id  and (transaction_type != 'RECEIVE' or destination_type_code != 'RECEIVING') ) "+
 					 "   and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d "+
					 "				       where LSTATUSID != '013'  and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  "+
  					 "   and rt.transaction_date between to_date('"+receptDateStr+"','YYYYMMDD') and to_date('"+receptDateEnd+"235959','YYYYMMDDHH24MISS') ";
            orderRCV = " order by pov.vendor_name, i.segment1, rsl.creation_date  ";
			if (supplyVndID!=null && !supplyVndID.equals("")) whereRCV = whereRCV + " and pov.vendor_id ='"+supplyVndID+"' ";
			if (poNo!=null && !poNo.equals("")) whereRCV = whereRCV + " and poh.segment1 = '"+poNo+"' ";
			if (receiptNo!=null && !receiptNo.equals("")) whereRCV = whereRCV + " and rsh.receipt_num = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{ 
				whereRCV = whereRCV + " and RT.ORGANIZATION_ID = '"+marketType+"' "; 
			} // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				whereRCV = whereRCV + " and RT.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}
			if (curryCode==null || curryCode.equals("") || curryCode.equals("--"))  //20091117 liling add
			{ 
				whereRCV = whereRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			} 
			else  
			{
				whereRCV = whereRCV + " and RT.CURRENCY_CODE = '"+curryCode+"' "; 
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				whereRCV = whereRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}	   
			// 20100307 Marvie Add : Add MC agree
			if (statusID.equals("019")) whereRCV = whereRCV + " and rt.attribute12 is null ";
			else if (statusID.equals("029")) whereRCV = whereRCV + " and substr(rt.attribute12,1,1)='N' ";   // 20100927 Marvie Add : Add INV return
			else whereRCV = whereRCV + " and substr(rt.attribute12,1,1)='Y' ";
			sqlRCV = sqlRCV + whereRCV + orderRCV;
		} 
		else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)收料
		{
			sqlRCV = " SELECT RT.INTERFACE_TRANSACTION_ID as ID,RSH.RECEIPT_NUM ,OOHA.ORDER_NUMBER,RC.CUSTOMER_NAME, "+
					"        MSI.SEGMENT1,MSI.DESCRIPTION,RT.QUANTITY ,RT.UNIT_OF_MEASURE ,RT.TRANSACTION_DATE, "+
					"		 RSH.SHIPMENT_HEADER_ID, RSH.CUSTOMER_ID, RSL.SHIPMENT_LINE_ID,RT.SUBINVENTORY, "+
					"		 RT.ORGANIZATION_ID ,RT. SOURCE_DOCUMENT_CODE  SOURCE_TYPE "+
					"   FROM RCV_TRANSACTIONS RT ,RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES  RSL, "+
					"		 OE_ORDER_HEADERS_ALL OOHA,RA_CUSTOMERS  RC ,MTL_SYSTEM_ITEMS MSI ";
			whereRCV = "   WHERE  RT.SHIPMENT_HEADER_ID=RSH.SHIPMENT_HEADER_ID  "+
					"     AND RT.SHIPMENT_LINE_ID=RSL.SHIPMENT_LINE_ID       "+
					"     AND RSH.SHIPMENT_HEADER_ID=RSL.SHIPMENT_HEADER_ID  "+
					"     AND RSH.RECEIPT_SOURCE_CODE='CUSTOMER' AND MSI.INVENTORY_ITEM_ID=RSL.ITEM_ID "+
					"	  AND MSI.ORGANIZATION_ID=RSH.ORGANIZATION_ID AND MSI.ORGANIZATION_ID=RT.ORGANIZATION_ID "+
					"	  AND RT.TRANSACTION_TYPE='RECEIVE' AND OOHA.HEADER_ID=RT.OE_ORDER_HEADER_ID AND RC.CUSTOMER_ID=RT.CUSTOMER_ID  "+
			        "  and not exists ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL d where LSTATUSID != '013' "+  //2009/04/10 修改為 not exists  from speed
                    "                     and d.INTERFACE_TRANSACTION_ID = rt.INTERFACE_TRANSACTION_ID )  ";
			if (receiptNo!=null && !receiptNo.equals("")) whereRCV = whereRCV + " and RSH.RECEIPT_NUM = '"+receiptNo+"' ";
			if (marketType==null || marketType.equals("") || marketType.equals("--")) 
			{ 
				whereRCV = whereRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; 
			}  // 2007/03/28 加入此條件,避免勞秀琴合併內外銷
			else  
			{
				whereRCV = whereRCV + " and RSH.ORGANIZATION_ID = '"+marketType+"' "; // 取到的organizationID
			}
			if (vendorLotNum==null || vendorLotNum.equals(""))	
			{
			}
			else 
			{
				whereRCV = whereRCV + " and RT.VENDOR_LOT_NUM = '"+vendorLotNum+"' "; // 輸入的Vendor Lot Num 查詢
			}
			sqlRCV = sqlRCV + whereRCV + orderRCV;
		} // End of else if (receiptSource.equals("2"))
		rs=statement.executeQuery(sqlRCV); 	 
	 
	}   // 非管理員權限 
	//	out.print("sqlRCV="+sqlRCV); 	
	//out.println("UserRoles="+UserRoles); 
   	if (rowNumber==1 || rowNumber<0)
   	{ 
    	rs.beforeFirst(); //移至第一筆資料列  
   	} 
	else 
	{ 
		if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
		{
			rs.absolute(rowNumber); //移至指定資料列	 
		}	
	}
	// 將sql Result 存到arrayIQCSearchBean 內,作為下一頁候選依據_起
	String sqlArr ="";
	if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1")) // 若暫收來源為PO(採購單)收料
	{     
		sqlArr = " select RT.INTERFACE_TRANSACTION_ID , POV.VENDOR_ID ,POV.VENDOR_NAME ,RT.VENDOR_SITE_ID,POVS.VENDOR_SITE_CODE ,RSH.RECEIPT_NUM, "+
				 "        RT.TRANSACTION_DATE RECEIPT_DATE,RT.TRANSACTION_DATE,POH.SEGMENT1 PO_NUM,RT.SOURCE_DOC_QUANTITY,RT.QUANTITY , RT.UNIT_OF_MEASURE, "+
				 "        I.INVENTORY_ITEM_ID,I.SEGMENT1,I.DESCRIPTION,trim(RT.VENDOR_LOT_NUM) VENDOR_LOT_NUM,RSH.PACKING_SLIP,RT.ORGANIZATION_ID,RT.WIP_ENTITY_ID  "+
				 "      , RT.TRANSACTION_ID, RT.PO_HEADER_ID, RT.PO_LINE_ID, RT.PO_LINE_LOCATION_ID"+
				 "   from RCV_TRANSACTIONS RT, RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL, PO_HEADERS_ALL POH, PO_VENDOR_SITES_ALL POVS,  "+
				 "        PO_LINE_LOCATIONS_ALL POLL, PO_VENDORS POV, MTL_SYSTEM_ITEMS_B I   ";
	} 
	else if (receiptSource.equals("2")) // 若暫收來源為RMA(銷貨退回)
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
	Statement stateArr=con.createStatement();	
	ResultSet rsArr = stateArr.executeQuery(sqlArr);
	int iSeq=0;
	// 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	String a[][]=new String[maxrow+1][24];
	while (rsArr.next())
	{
		a[iSeq][0]  = Integer.toString(iSeq+1);
		a[iSeq][1]  = rsArr.getString("INTERFACE_TRANSACTION_ID");
		a[iSeq][2]  = rsArr.getString("VENDOR_ID");
		a[iSeq][3]  = rsArr.getString("VENDOR_NAME");
		a[iSeq][4]  = rsArr.getString("VENDOR_SITE_ID");
		a[iSeq][5]  = rsArr.getString("VENDOR_SITE_CODE");
		a[iSeq][6]  = rsArr.getString("RECEIPT_NUM");
		a[iSeq][7]  = rsArr.getString("RECEIPT_DATE");
		a[iSeq][8]  = rsArr.getString("TRANSACTION_DATE");
		a[iSeq][9]  = rsArr.getString("WIP_ENTITY_ID");
		a[iSeq][10] = rsArr.getString("PO_NUM");
		a[iSeq][11] = rsArr.getString("SOURCE_DOC_QUANTITY");
		a[iSeq][12] = rsArr.getString("QUANTITY"); // TXN_QTY
		a[iSeq][13] = rsArr.getString("UNIT_OF_MEASURE");  //TXN_UOM
		a[iSeq][14] = rsArr.getString("INVENTORY_ITEM_ID");
		a[iSeq][15] = rsArr.getString("SEGMENT1");
		a[iSeq][16] = rsArr.getString("DESCRIPTION");
		a[iSeq][17] = rsArr.getString("VENDOR_LOT_NUM");
		a[iSeq][18] = rsArr.getString("PACKING_SLIP");
		a[iSeq][19] = rsArr.getString("ORGANIZATION_ID");
		// 20100307 Marvie Add : Add MC agree
		if (receiptSource=="" || receiptSource.equals("") || receiptSource.equals("1"))
		{
			a[iSeq][20] = rsArr.getString("TRANSACTION_ID");
			a[iSeq][21] = rsArr.getString("PO_HEADER_ID");
			a[iSeq][22] = rsArr.getString("PO_LINE_ID");
			a[iSeq][23] = rsArr.getString("PO_LINE_LOCATION_ID");
		}
		if (rsArr.getString("VENDOR_LOT_NUM")==null || rsArr.getString("VENDOR_LOT_NUM").equals("") || rsArr.getString("VENDOR_LOT_NUM").equals("null"))
		{ 
			a[iSeq][17] = "";
		}  // 若當初未給廠商批號,則給空值予array		
		arrayIQCSearchBean.setArray2DString(a);		
		iSeq++;
	} 
	rsArr.close();
	stateArr.close(); 
   
	String sKeyArray[]=new String[1];   
	sKeyArray[0]="ID";
	if (pageURL!=null && !pageURL.equals("") && !pageURL.equals("null") && statusID.equals("020") && (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 || UserRoles.indexOf("admin")>=0))
		qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
	else
		qryAllChkBoxEditBean.setPageURL("");
	qryAllChkBoxEditBean.setPageURL2("");     
	qryAllChkBoxEditBean.setHeaderArray(null);   
	qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
	qryAllChkBoxEditBean.setFieldName("CH");
	qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
	qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
	qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
	qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
	qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
	qryAllChkBoxEditBean.setRs(rs);   
	qryAllChkBoxEditBean.setScrollRowNumber(300);  
	qryAllChkBoxEditBean.setOnClickJS("checkValue");  //add by Peggy 20121210
	//20110311 add by Peggychen
	if (pageURL != null && pageURL.indexOf("TSIQCInspectLotInput.jsp") >=0)
	{ 
		qryAllChkBoxEditBean.setHideURL("Y");
	}
	else
	{
		qryAllChkBoxEditBean.setHideURL("N");
	}
	out.println(qryAllChkBoxEditBean.getRs2String());
	statement.close();
	rs.close();  
} //end of try  
catch (Exception e)
{
	e.printStackTrace();
   	out.println("Exception queryAllChkBoxEditBean:"+e.getMessage());   
}
 
try
{        
	if (UserRoles.indexOf("admin")>=0 || (statusID.equals("020") && UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0) || (statusID.equals("019") && UserRoles.indexOf("YEW_IQC_MC")>=0) || (statusID.equals("029") && UserRoles.indexOf("YEW_STOCKER")>=0))     // 20100927 Marvie Update : Add INV return
	{ 
		String sqlAct = null;
		String whereAct = null;
		sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";
        if (statusID.equals("020"))	whereAct = whereAct + " and x1.ACTIONID = '001'";
	    sqlAct = sqlAct + whereAct;
        Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sqlAct);
        comboBoxBean.setRs(rs);
	    comboBoxBean.setFieldName("ACTIONID");	 
		out.println("</font></strong></td><TR><TR><td>");%>備註<%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
	    out.println("<strong><font color='#FF0000'>");%>執行動作-><%out.println("</font></strong>");
        out.println(comboBoxBean.getRsString());    
		String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
		if (UserRoles.indexOf("admin")>=0) whereCnt = whereCnt+"";  //若是管理員,則任何動作不受限制
	 	else if (UserRoles.indexOf("YEW_IQC_INSPECTOR")>=0 || UserRoles.indexOf("YEW_STOCKER")>=0)   // 20100927 Marvie Update : Add INV return
			whereCnt = whereCnt+" and FORMID='QC'"; // 否則一律皆為外銷流程
		sqlCnt = sqlCnt + whereCnt;
	    rs=statement.executeQuery(sqlCnt);
	    rs.next();
	    if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
		{	      
        	out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
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
</FORM>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
