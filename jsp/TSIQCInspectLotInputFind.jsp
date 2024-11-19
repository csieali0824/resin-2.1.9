<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean,CheckBoxBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();	
}
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
      subWin=window.open("../jsp/subwindow/TSCVendorInfoFind.jsp?SUPPLYVNDNO="+vndNo+"&SUPPLYVND="+vndName,"subwin","width=640,height=480,scrollbars=yes,menubar=no,status=yes"); 
   }
}
// Enter ... 找廠商基本資料_迄
function setSubmit2(URL)
{    
 document.MYFORM.TSINVOICENO.value ="";
 document.MYFORM.CUSTOMERNO.value ="";
 document.MYFORM.CUSTOMERNAME.value ="";
 document.MYFORM.SHIPTOORG.value ="";
 document.MYFORM.SHIPADDRESS.value ="";
 document.MYFORM.SHIPDATE.value ="";
 document.MYFORM.SHIPMETHOD.value ="";
 document.MYFORM.FOBPOINT.value ="";
 document.MYFORM.PAYMENTTERM.value ="";
 document.MYFORM.CHKDEL.value='N'; 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmitQuery(URL,supplier,vendor)
{ 
//alert(supplier); 
//alert(document.MYFORM.SUPPLYVND.value);
  var suppID = "&SUPPLIERID="+supplier;
    if ( (document.MYFORM.SUPPLYVND.value==null || document.MYFORM.SUPPLYVND.value=="") && (document.MYFORM.PONO.value==null || document.MYFORM.PONO.value=="")  ) //若未輸入供應商或PO號,則顯示警告訊息
	{
	 alert("請輸入供應商或採購單號為收料查詢依據!!!");
	 document.MYFORM.SUPPLYVND.focus(); 
	 return(false);
	}
	if (supplier!=null && supplier!="")
	{
	    if (document.MYFORM.SUPPLYVND.value!=supplier)
		{
		   alert("Dirrerent Supplier!!! ");
		   return (false);
		}
		
     	document.MYFORM.action=URL+suppID;
        document.MYFORM.submit();
	} else {
	           document.MYFORM.action=URL;
               document.MYFORM.submit();
	        }	
} 
function setSubmitClass(URL)
{ 
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
}
function setSubmitAdd(URL,xINTERFACEID,xRECEIPTNUMBER,xITEMNO,xAUTOORNO,xSUPLOTNO,xINSPREQ,xINDEX)
{   
  formAUTHORNO = "document.MYFORM.AUTHORNO"+xINDEX+".focus()";
  formAUTHORNO_Write = "document.MYFORM.AUTHORNO"+xINDEX+".value";
  xAUTHORNO = eval(formAUTHORNO_Write);  // 把值取得給java script 變數
  
  formSUPLOTNO = "document.MYFORM.SUPLOTNO"+xINDEX+".focus()";
  formSUPLOTNO_Write = "document.MYFORM.SUPLOTNO"+xINDEX+".value";
  xSUPLOTNO = eval(formSUPLOTNO_Write);  // 把值取得給java script 變數     
  
  formINSPREQ = "document.MYFORM.INSPREQ"+xINDEX+".focus()";
  formINSPREQ_Write = "document.MYFORM.INSPREQ"+xINDEX+".value";
  xINSPREQ = eval(formINSPREQ_Write);  // 把值取得給java script 變數
  
  formINTERFACETRANSID = "document.MYFORM.INTERFACETRANSID"+xINDEX+".focus()";
  formINTERFACETRANSID_Write = "document.MYFORM.INTERFACETRANSID"+xINDEX+".value";
  xINTERFACETRANSID = eval(formINTERFACETRANSID_Write);  // 把值取得給java script 變數 
  
  //alert("xINTERFACETRANSID="+xINTERFACETRANSID);  
  
  formRECNO = "document.MYFORM.RECNO"+xINDEX+".focus()";
  formRECNO_Write = "document.MYFORM.RECNO"+xINDEX+".value";
  xRECNO = eval(formRECNO_Write);  // 把值取得給java script 變數 
  
  //alert("xRECNO="+xRECNO);
  
  formINVITEMNO = "document.MYFORM.INVITEMNO"+xINDEX+".focus()";
  formINVITEMNO_Write = "document.MYFORM.INVITEMNO"+xINDEX+".value";
  xINVITEMNO = eval(formINVITEMNO_Write);  // 把值取得給java script 變數
  
  //alert("xINVITEMNO="+xINVITEMNO); 
  
  formINVITEMDESC = "document.MYFORM.INVITEMDESC"+xINDEX+".focus()";
  formINVITEMDESC_Write = "document.MYFORM.INVITEMDESC"+xINDEX+".value";
  xINVITEMDESC = eval(formINVITEMDESC_Write);  // 把值取得給java script 變數 
  
  //alert("xINVITEMDESC="+xINVITEMDESC);  
  
  if ( (xAUTHORNO==null || xAUTHORNO==""))
  {
     alert("請輸入零件承認編號!!");	 
	 formAUTHORNO ="document.MYFORM.AUTHORNO"+xINDEX+".focus()";
	 eval(formAUTHORNO);	 
	 return(false);
  }  
  
  if ( (xINSPREQ==null || xINSPREQ=="")  ) //若判斷是否檢驗為空值,則要求填入
  {   
     alert("請輸入是否為需要檢驗項目(Y/N)!?");	 	
	 formINSPREQ ="document.MYFORM.INSPREQ"+xINDEX+".focus()";
	 eval(formINSPREQ);
	 return(false);
  }
  
  if ( document.MYFORM.CLASSID.value=="01" &&  (xSUPLOTNO==null || xSUPLOTNO==""))
  {
     alert("晶片/晶粒檢驗需輸入供應商批號(Supplier Lot No.)!");	 
	 formSUPLOTNO ="document.MYFORM.SUPLOTNO"+xINDEX+".focus()";
	 eval(formSUPLOTNO);	 
	 return(false);
  }
  /*
  formAUTHORNO_Write = "document.MYFORM.AUTHORNO"+xINDEX+".value";
  formAUTHORNO_Write=xAUTHORNO;
  eval(formAUTHORNO_Write);
  
  formSUPLOTNO_Write = "document.MYFORM.SUPLOTNO"+xINDEX+".value";
  formSUPLOTNO_Write=xSUPLOTNO;
  eval(formSUPLOTNO_Write);
  
  formINSPREQ_Write = "document.MYFORM.INSPREQ"+xINDEX+".value";
  formINSPREQ_Write=xINSPREQ; 
  eval(formINSPREQ_Write);  
  */
  //document.MYFORM.action=URL;
  // -- document.MYFORM.action="../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INTERFACETRANSID"+xINDEX+"="+xINTERFACETRANSID+"&RECNO"+xINDEX+"="+xRECNO+"&INVITEMNO"+xINDEX+"="+xINVITEMNO;
  document.MYFORM.action="../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INTERFACEID="+xINTERFACEID+"&RECEIPTNUMBER="+xRECEIPTNUMBER+"&ITEMNO="+xITEMNO+"&AUTHORNO="+xAUTHORNO+"&SUPLOTNO="+xSUPLOTNO+"&INSPREQ="+xINSPREQ;
  document.MYFORM.submit(); 
}
function setSubmitDel(URL)
{ 
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
}

function setSubmitSave(URL)
{ 
    document.MYFORM.action=URL;
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
function popMenuMsg(itemDesc)
{
 alert("台半料號:"+itemDesc);
}
</script>
<html>
<head>
<title>IQC Receipt Inspect Lot Input</title>
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
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>

<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "";
String sSqlCNT = "";
String sSqlCNTITEM = "";
String sWhere = "";
String sWhereGP = "";
String sOrderBy = "";

String havingGrp = "";

//String fjamDesc = ""; 

//String link2ExcelURL = "";


int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;

float CASECOUNTORG=0;

//String RepLocale=(String)session.getAttribute("LOCALE"); 		
String SWHERECOND = "";
int CaseCount = 0;
int CaseCountORG =0;
float CaseCountPCT = 0;

String colorStr = "";


String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");

String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");
      if (dateSetBegin==null) dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null) dateSetEnd=YearTo+MonthTo+DayTo; 
	 
String [] selectFlag=request.getParameterValues("SELECTFLAG");	  

String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String query=request.getParameter("QUERY");

String organizationId=request.getParameter("ORGANIZATIONID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
 
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE");  
  
 
   String [] check=request.getParameterValues("CHKFLAG");
   
//Kerwin For IQC variable   

   int commitmentMonth=0;
   arrayIQCDocumentInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
   String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
   String isModelSelected=request.getParameter("ISMODELSELECTED");  
   
    String [] addItems=request.getParameterValues("ADDITEMS");	
	
	String interfaceTransID=request.getParameter("INTERFACETRANSID"+Integer.toString(rs1__index+1));
	String recNo=request.getParameter("RECNO"+Integer.toString(rs1__index+1));
	String invItemNo=request.getParameter("INVITEMNO"+Integer.toString(rs1__index+1));
	String invItemDesc=request.getParameter("INVITEMDESC"+Integer.toString(rs1__index+1));
	String transactQty=request.getParameter("TRANSACTQTY"+Integer.toString(rs1__index+1));
	String transactUOM=request.getParameter("TRANSACTUOM"+Integer.toString(rs1__index+1));
	String supSiteID=request.getParameter("SUPSITEID"+Integer.toString(rs1__index+1));
	String authorNumber=request.getParameter("AUTHORNO"+Integer.toString(rs1__index+1)); 
    String supLotNumber=request.getParameter("SUPLOTNO"+Integer.toString(rs1__index+1));
    String inspReqFlag=request.getParameter("INSPREQ"+Integer.toString(rs1__index+1));
	String rCardNo=request.getParameter("RCARDNO"+Integer.toString(rs1__index+1));
	String receiptDate=request.getParameter("RECEIPTDATE"+Integer.toString(rs1__index+1));
	
	//out.println(recNo);
	
	String interfaceID=request.getParameter("INTERFACEID");
	String receiptNumber=request.getParameter("RECEIPTNUMBER");
	String itemNo=request.getParameter("ITEMNO");
	String authorNo=request.getParameter("AUTHORNO"); 
    String supLotNo=request.getParameter("SUPLOTNO");
    String inspReq=request.getParameter("INSPREQ");
	
	if (interfaceID==null || interfaceID.equals("")) interfaceID = "";
	if (receiptNumber==null || receiptNumber.equals("")) receiptNumber = "";
	if (itemNo==null || itemNo.equals("")) itemNo = "";
	if (authorNumber==null || authorNumber.equals("")) authorNumber = "";
	if (supLotNumber==null || supLotNumber.equals("")) supLotNumber = "";
	if (inspReqFlag==null || inspReqFlag.equals("")) inspReqFlag = "";
	
	
	String iNo=request.getParameter("INO");
	//String invItemNo=request.getParameter("INVITEMNO"),invItemDesc=request.getParameter("INVITEMDESC"),transactQty=request.getParameter("TRANSACTQTY"),transactUOM=request.getParameter("TRANSACTUOM"),supSiteID=request.getParameter("SUPSITEID"),rCardNo=request.getParameter("RCARDNO"),receiptDate=request.getParameter("RECEIPTDATE");
	String supplier=request.getParameter("SUPPLIER");
	//authorNo=request.getParameter("AUTHORNO"),supLotNo=request.getParameter("SUPLOTNO"),inspReq=request.getParameter("INSPREQ"),
    String [] allMonth={iNo,interfaceID,receiptNumber,itemNo,invItemDesc,transactQty,supSiteID,authorNo,supLotNo,inspReq};
    String entry=request.getParameter("ENTRY");         
    if (entry==null || entry.equals("") )  {  }
    else { arrayIQCDocumentInputBean.setArray2DString(null); } 
  
  //if (custINo==null || custINo.equals("")) custINo = "1";
  if (iNo==null || iNo.equals("")) iNo = "1"; 
  
  if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細


   String seqno=null;
   String seqkey=null;
   String dateString=null;
   
   int inpLen = 0;  // 全域變數 inpLen 
   
   String classID=request.getParameter("CLASSID"); 
   String inspLotNo=request.getParameter("INSPLOTNO");
   String supplyVndID=request.getParameter("SUPPLYVNDID");
   String supplyVndNo=request.getParameter("SUPPLYVNDNO");
   String supplyVnd=request.getParameter("SUPPLYVND");
   String supplierID=request.getParameter("SUPPLIERID");
   String supplierName=request.getParameter("SUPPLIERNAME");
   //String supSiteID=request.getParameter("SUPSITEID");   //已宣告
   String supSiteName=request.getParameter("SUPSITENAME");   
   String roundCard=request.getParameter("ROUNDCARD");
   
   String receptDateStr=request.getParameter("RECEPTDATEBEG");
   String receptDateEnd=request.getParameter("RECEPTDATEEND");
   String poNo=request.getParameter("PONO");
   String receiptNo=request.getParameter("RECEIPTNO");
   String roundCardNo=request.getParameter("ROUNDCARDNO");
   String poNumber=request.getParameter("PONUMBER");
   String packMethod=request.getParameter("PACKMETHOD");   
   String invItem=request.getParameter("INVITEM");
   String itemDesc=request.getParameter("ITEMDESC");
   String inspectDate=request.getParameter("INSPECTDATE");
   
   String prodName=request.getParameter("PRODNAME");
   String prodModel=request.getParameter("PRODMODEL");
   String sampleQty=request.getParameter("SAMPLEQTY");
   String wfThick=request.getParameter("WFTHICK");
   String wfResist=request.getParameter("WFRESIST");   
   
   String wfTypeID=request.getParameter("WFTYPEID");
   String wfSizeID=request.getParameter("WFSIZEID");  
   String diceSize=request.getParameter("DICESIZE");
   String wfPlatID=request.getParameter("WFPLATID"); 
   String waiveLot=request.getParameter("WAIVELOT");
   String remark=request.getParameter("REMARK");
   
   String vendor=request.getParameter("VENDOR");
   String iMatCode=request.getParameter("IMATCODE");
     
   String insertPage=request.getParameter("INSERT");   
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  
  //out.println("itemDesc="+itemDesc);
  
   
  if (statusCode==null || statusCode.equals("")) statusCode="";  
  
  if (receptDateStr==null || receptDateStr.equals("")) receptDateStr=dateBean.getYearMonthDay();
  if (receptDateEnd==null || receptDateEnd.equals("")) receptDateEnd=dateBean.getYearMonthDay();
  if (inspectDate==null || inspectDate.equals("")) inspectDate=dateBean.getYearMonthDay();
  
  if (classID==null || classID.equals("--")) classID = "01"; // 預設給晶片晶粒類別檢驗批單號
  if (poNo==null || poNo.equals("")) poNo = "";
  if (poNumber==null || poNumber.equals("")) poNumber = "";
  if (packMethod==null) packMethod = "";
  if (receiptNo==null || receiptNo.equals("")) receiptNo = "";
  
  if (supplyVndID==null || supplyVndID.equals("")) supplyVndID = "";
   if (supplyVndNo==null || supplyVndNo.equals("")) supplyVndNo = "";
  if (supplyVnd==null || supplyVnd.equals("")) supplyVnd = "";
  if (supplierID==null || supplierID.equals("")) supplierID = "";
  if (supplierName==null || supplierName.equals("")) supplierName = "";
  if (supSiteID==null || supSiteID.equals("")) supSiteID = "";
  if (supSiteName==null || supSiteName.equals("")) supSiteName = "";
  if (roundCard==null || roundCard.equals("")) roundCard = "";
  
  if (roundCardNo==null || roundCardNo.equals("")) roundCardNo = "";
  if (invItem==null || invItem.equals("")) invItem = "";
  if (itemDesc==null || itemDesc.equals("")) itemDesc = "";
  if (supLotNo==null || supLotNo.equals("")) supLotNo = "";
  if (authorNo==null || authorNo.equals("")) authorNo = "";
  if (prodName==null) prodName = "";
  if (prodModel==null) prodModel = "";
  if (sampleQty==null) sampleQty= "";
  if (wfThick==null) wfThick = "";
  if (wfResist==null) wfResist = "";
  if (diceSize==null) diceSize = "";
  
  if (waiveLot==null) waiveLot = "N";
  
  if (remark==null) remark = "";
  
  
  if (query==null || query.equals("")) query = "Y";

  int iDetailRowCount = 0;    
  
  if (organizationId==null) organizationId=""; // 給初值 

   
 
%>

<style type="text/css">
<!--
.style14 {color: #003300}
.style18 {
	font-size: large;
	color: #CC3300;
	font-weight: bold;
}
.style20 {
	color: #CC3300;
	font-size: large;
	font-weight: bold;
	font-family: Tahoma, Georgia;
}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
  
<FORM ACTION="TSIQCInspectLotInput.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<span class="style17">TSC</span><span class="style18">&nbsp;品管IQC進料檢驗批新增</span><BR>
<A HREF="/oradds/OraddsMainMenu.jsp">回首頁</A>
<%
 
  sWhereGP = " ";
 
 

/*  找尋合法的收料批資訊 */

           sSql =  " select /*+ ORDERED index(a RCV_TRANSACTIONS_T1)  */ "+
		                   "INTERFACE_TRANSACTION_ID, SUPPLIER_ID, SUPPLIER, SUPPLIER_SITE_ID, SUPPLIER_SITE, RECEIPT_NUM, "+
						   "to_char(RECEIPT_DATE,'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, TRANSACTION_DATE, WIP_ENTITY_ID,  "+
		                   "PO_NUM, SOURCE_DOC_QTY, TRANSACT_QTY, TRANSACT_UOM, ITEM_ID, b.SEGMENT1, ITEM_DESC, "+
						   "VENDOR_LOT_NUM, PACKING_SLIP, a.ORGANIZATION_ID ";
   String sFrom =  " from APPS.RCV_VRC_TXS_V a, MTL_SYSTEM_ITEMS b " ; 

   sWhere =  "  where a.ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID and a.TRANSACTION_TYPE='RECEIVE' and a.DESTINATION_TYPE_CODE = 'RECEIVING'  "+ // 暫收
             "    and a.ATTRIBUTE6 IS NULL "; // 排除掉那些已經作開單,但狀態不為批退供應商(AWAITRECEIPT)的
			 
 sOrderBy =  " order by a.TRANSACTION_DATE, a.PO_NUM ";			 
 //if (receptDateStr!=null) sWhere=sWhere+" and to_char(a.TRANSACTION_DATE,'YYYYMMDD') >="+"'"+receptDateStr+"'";
 if (receptDateStr!=null && receptDateEnd!=null) sWhere=sWhere+" and to_char(a.TRANSACTION_DATE,'YYYYMMDD') between "+"'"+receptDateStr+"'"+" and "+"'"+receptDateEnd+"'";  
 
 if ((supplyVnd==null || supplyVnd.equals("")) && (poNo==null || poNo.equals(""))) 
 { sWhere=sWhere+" and a.SUPPLIER ='0' "; } // 如果沒有輸入特定SUPPLIER 則SQL亦查不到
 else if (supplyVnd!=null && !supplyVnd.equals("")) { sWhere=sWhere+" and a.SUPPLIER ='"+supplyVnd+"'"; }
 
 if ( (supplyVnd==null || supplyVnd.equals("")) && (poNo==null || poNo.equals("")) ) 
 { sWhere=sWhere+" and a.PO_NUM ='0' "; } // 如果沒有輸入特定PO_NUMBER 則SQL亦查不到
 else if (poNo!=null && !poNo.equals("")) { sWhere=sWhere+" and a.PO_NUM ='"+poNo+"'"; }
 
 if (receiptNo!=null && !receiptNo.equals("")) { sWhere=sWhere+" and a.RECEIPT_NUM ='"+receiptNo+"'"; }
 if (invItem!=null && !invItem.equals("")) { sWhere=sWhere+" and b.SEGMENT1 ='"+invItem+"'";	}
 if (itemDesc!=null && !itemDesc.equals("")) { sWhere=sWhere+" and a.ITEM_DESC ='"+itemDesc+"'";	}
 

  sSql = sSql + sFrom + sWhere + sOrderBy ; 


sqlGlobal = sSql;



%>&nbsp;<img src="../image/search.gif"><font color="#003399">為查詢必選(填)欄位,需擇一輸入</font>  
<table width="100%" border="0" cellpadding="0" cellspacing="1" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF">
 <tr bgcolor="#DAE089"><td width="8%" nowrap>供應商<img src="../image/search.gif"></td>
     <td width="20%" nowrap>
	 <input type="hidden" size="5" name="SUPPLYVNDID" maxlength="10" value="<%=supplyVndID%>">
	 <input type="text" size="5" name="SUPPLYVNDNO" maxlength="10" value="<%=supplyVndNo%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">
	 <INPUT TYPE="button" value="..." onClick='subWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)'>
	 <input type="text" size="25" name="SUPPLYVND" maxlength="50" value="<%=supplyVnd%>" onKeyDown="setWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)">	  
	 </td>
     <td width="6%" nowrap>收料日起</td>
     <td width="29%"><input name="RECEPTDATEBEG" tabindex="2" type="text" size="8" value="<%=receptDateStr%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATEBEG);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
     <td width="7%" nowrap>收料日迄</td>
	 <td width="30%"><input name="RECEPTDATEEND" tabindex="2" type="text" size="8" value="<%=receptDateEnd%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATEEND);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
    </tr>
	 <tr bgcolor="#DAE089">
	   <td nowrap>採購單號<img src="../image/search.gif"></td><td><input type="text" size="15" name="PONO" tabindex='4' maxlength="20" value="<%=poNo%>" onKeyDown="setSubmit1a('../jsp/TSCIQCInspectLotInput.jsp')"></td>
	   <td nowrap>收料單號<img src="../image/search.gif"></td><td><input type="text" size="15" name="RECEIPTNO" tabindex='5' maxlength="20" value="<%=receiptNo%>" onKeyDown="setSubmit1a('../jsp/TSCIQCInspectLotInput.jsp')"></td>
	   <td nowrap>流程卡編號</td><td><input type="text" size="15" name="ROUNDCARD" tabindex='6' maxlength="20" value="<%=roundCard%>"></td>
	 </tr>
    <tr bgcolor="#DAE089">
	    <td nowrap>台半料號</td><td><input type="text" size="30" name="INVITEM" tabindex='7' maxlength="30" value="<%=invItem.toUpperCase()%>" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)"><INPUT TYPE="button" tabindex="12" value="..." onClick="subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)"></td>
		<td nowrap>料號說明</td><td colspan="1"><input type="text" size="30" name="ITEMDESC" tabindex='4' maxlength="50" value="<%=itemDesc.toUpperCase()%>" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)"><INPUT TYPE="button" tabindex="14"  value="..." onClick="subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)"></td>
		<td colspan="2"><INPUT name="button3" tabindex='20' TYPE="button" onClick='setSubmitQuery("../jsp/TSIQCInspectLotInput.jsp?QUERY=Y",this.form.SUPPLYVND.value,this.form.VENDOR.value)'  value='資料帶出' ></td>
    </tr>
  </table>
<HR>  
<input name="FORMID" type="HIDDEN" value="QC">	
<input name="FROMSTATUSID" type="HIDDEN" value="020">
<input name="FROMPAGE" type="HIDDEN" value="TSIQCInspectLotInput.jsp"> 
<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
<input name="INSPLOTNO" type="HIDDEN" value="<%=inspLotNo%>">

<input name="VENDOR" type="hidden" size="25" value="<%=supplierName%>" readonly>
<input name="QCDEPTID" type="HIDDEN" value="<%=userInspDeptID%>">
<input name="QCINSPECTOR" type="HIDDEN" value="<%=userInspectorName%>">
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>"  size="5">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
<%

%>


