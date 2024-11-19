<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="shpArray2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/> 
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}
function callInv()
{        
    window.open("../jsp/subwindow/TSSHPInvoiceQuerySub.jsp?TSINVOICENO="+document.MYFORM.TSINVOICENO.value+"&ACTION=001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
// By Kerwin Additional Function
function CREATEPO()
{
   subWin=window.open("../jsp/TSSHPCreatePO4DropShipOrder.jsp","subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function POAPPROVER(PO_ID,PO_NO)
{
   subWin=window.open("../jsp/TSSHSendMailToPOApprover.jsp?PO_ID="+PO_ID+"&PO_NO="+PO_NO,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function setSubmitNOTIFYMO(MO_NO,typeCode,lineNo)
{
   subWin=window.open("../jsp/TSSHPSendMailToMOOwner.jsp?MO_NO="+MO_NO+"&TYPE_CODE="+typeCode+"&LINE_NO="+lineNo,"subwin","width=340,height=200,scrollbars=yes,menubar=no");
}
// By Kerwin Additional Function
function POActionHistoryQuery(getDocumentID, MoNo, LineNo, SchShipDate)
{     
  subWin=window.open("../jsp/OraclePOActionHistory.jsp?DOCUMENTID="+getDocumentID+"&MONO="+MoNo+"&LINENO="+LineNo+"&SCHSHIPDATE="+SchShipDate,"subwin"); 
}

function setSubmit1(URL)
{ 

  if (document.MYFORM.SALESORDERNO.value ==""  && document.MYFORM.CUSTOMERNO.value=="" )
  {
    alert("您必須輸入銷售訂單號或客戶代號!!!");
	return false; 
  } 
  else
  {
 
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
}

function setSubmit1a(URL)
{ 

 if (event.keyCode==13)
 {
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
}


function setSubmit2(URL)  //清除畫面條件,重新查詢!
{    
 document.MYFORM.SALESORDERNO.value ="";
 //document.MYFORM.TSINVOICENO.value ="";
 document.MYFORM.CUSTOMERNO.value ="";
 document.MYFORM.CUSTOMERNAME.value ="";
 document.MYFORM.SHIPTOORG.value ="";
 document.MYFORM.SHIPADDRESS.value ="";
 //document.MYFORM.SHIPDATE.value ="";
 document.MYFORM.SHIPMETHOD.value ="";
 document.MYFORM.FOBPOINT.value ="";
 document.MYFORM.PAYTERM.value ="";
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit3(URL)  //存檔 
{
  if(document.MYFORM.SHIPDATE.value <= document.MYFORM.SYSTEMDATE.value)
   {
    // 檢查日期是否符合日期格式 
      var datetime;
      var year,month,day;
      var gone,gtwo;
      if(document.MYFORM.SHIPDATE.value!="")
      {
        datetime=document.MYFORM.SHIPDATE.value;
        if(datetime.length==8)
        {
           year=datetime.substring(0,4);
           if(isNaN(year)==true)
	   {
                    alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                    document.MYFORM.SHIPDATE.focus();
                    return(false);
           }
           gone=datetime.substring(4,5);
           month=datetime.substring(4,6);
           if(isNaN(month)==true)
	   {
               alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
               document.MYFORM.SHIPDATE.focus();
               return(false);
           }
           gtwo=datetime.substring(7,8);
           day=datetime.substring(6,8);
           if(isNaN(day)==true)
	   {
             alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
             document.MYFORM.SHIPDATE.focus();
             return(false);
           }
         //   if((gone=="-")&&(gtwo=="-"))
	 //	{
	 //alert(day);
          if(month<1||month>12) 
	  { 
            alert("Month must between 01 and 12 !!"); 
            document.MYFORM.SHIPDATE.focus();   
            return(false); 
          } 
          if(day<1||day>31)
	  { 
            alert("Day must between 01 and 31!!");
            document.MYFORM.SHIPDATE.focus(); 
            return(false); 
          }else{
                 if(month==2)
		 {  
                    if(isLeapYear(year)&&day>29)
		    { 
                      alert("February between 01 and 29 !!"); 
                      document.MYFORM.SHIPDATE.focus();
                      return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
		    { 
                     alert("February between 01 and 29 !!");
                     document.MYFORM.SHIPDATE.focus(); 
                     return(false); 
                    } 
                 } // End of if(month==2)
                 if((month==4||month==6||month==9||month==11)&&(day>30))
		 { 
                   alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   document.MYFORM.SHIPDATE.focus(); 
                   return(false); 
                 } 
              } // End of else 
                  // }else // End of if((gone=="-")&&(gtwo=="-"))
                  //    {
                  //      alert("??入日期!格式?(yyyy-mm-dd) \n例(2001-01-01)");
                  //      checktext.focus();
                  //      return false;
                  //    }
        }else{ // End Else of if(datetime.length==10)
                alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
                document.MYFORM.SHIPDATE.focus();
                return(false);
             }
  }else{ // End of if(Trim(checktext.value)!="")
         //return true;
       }
 document.MYFORM.action=URL;
 document.MYFORM.submit();
 }//SHIPDATE <=SYSTEMDATE
else
  {
    alert("shipdate can not > Today");
     document.MYFORM.SHIPDATE.focus();
     return(false);
  }  

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
function checkAll(field) 
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
function setqtyChk(xSalesOrder,xLineID,xINDEX,xUNSHIPQTY,xUNDELIVERYQTY,xALLOWQTY,xALLOW_QTY,xACCSHP_QTY)
{

  formRCV_QTY = "document.MYFORM.RCV_QTY"+xINDEX+".focus()";

  formRCV_QTY_Write = "document.MYFORM.RCV_QTY"+xINDEX+".value";

  formSELECTFLAG = "document.MYFORM.elements.SELECTFLAG"+xINDEX+".checked = true";

  xRCV_QTY = eval(formRCV_QTY_Write);



  if (xALLOWQTY !=null && xALLOWQTY !="" && xALLOWQTY != undefined && xALLOWQTY != false)
  {

      txt1=xRCV_QTY;	
      for (j=0;j<txt1.length;j++)      
      { 
        c=txt1.charAt(j);
	   if ("0123456789.".indexOf(c,0)<0) 
	      {
		 alert("The data that you inputed should be numerical!!");    
		 return(false);
	      }
      }

      if (parseInt(Math.round(xUNSHIPQTY))==parseInt(Math.round(xUNDELIVERYQTY)))
	  {   

          //if (xRCV_QTY > parseInt(xALLOW_QTY) || xRCV_QTY == null || xRCV_QTY == "")
	      //{  --> 改成判斷剩餘可出數量
          //if (xRCV_QTY > parseInt(xACCSHP_QTY) || xRCV_QTY == null || xRCV_QTY == "")
	   if (parseFloat(xRCV_QTY) > parseFloat(xACCSHP_QTY) || xRCV_QTY == null || xRCV_QTY == "")
	   //if (xRCV_QTY > xACCSHP_QTY || xRCV_QTY == null || xRCV_QTY == "")

	      {  
            //alert("xRCV_QTY="+xRCV_QTY+"  xACCSHP_QTY="+xACCSHP_QTY);
	        alert("No Enough Qty to allow Shipping");

                 eval(formRCV_QTY);
 
	         return(false);  
              }
              else
              {
                  //alert("success5");
                 //alert(eval(formRCV_QTY_Write));
                 eval (formSELECTFLAG);
                 //formSELECTFLAG = true;
                 //formRCV_QTY_Write = xRCV_QTY;
                 //alert(eval (formSELECTFLAG));
                 //document.MYFORM.action="TSSHPInvoiceAdd.jsp?RCV_QTY"+xINDEX+"="+xRCV_QTY;
				 document.MYFORM.action="../jsp/TSSHPInvoiceAdd.jsp?INSERT=Y&SALESORDERNO="+xSalesOrder+"&LINE_ID="+xLineID+"&RCVQTY="+eval(formRCV_QTY_Write);
                 document.MYFORM.submit();
                 //alert(xRCV_QTY);
                 
               }
          }	
      else 
	  {  
 	     alert("MO Qty not equal PO Qty,please Check!!");
             document.write(document.MYFORM.NOEQUAL.values)="Y";
             eval(formRCV_QTY);
	     return(false); 
          }

  } else
  {
	     alert("No Qty to allow Shipping");
             eval(formRCV_QTY);
	     return(false);  
  }

}

function setqtyChk1a(xSalesOrder,xLineID,xINDEX,xUNSHIPQTY,xUNDELIVERYQTY,xALLOWQTY,xALLOW_QTY,xACCSHP_QTY)  //enter
{
 if (event.keyCode==13)
 {

  formRCV_QTY = "document.MYFORM.RCV_QTY"+xINDEX+".focus()";
  formRCV_QTY_Write = "document.MYFORM.RCV_QTY"+xINDEX+".value";

  formSELECTFLAG = "document.MYFORM.elements.SELECTFLAG"+xINDEX+".checked = true";

  xRCV_QTY = eval(formRCV_QTY_Write);

  if (xALLOWQTY !=null && xALLOWQTY !="" && xALLOWQTY != undefined && xALLOWQTY != false)
  {

      txt1=xRCV_QTY;	
      for (j=0;j<txt1.length;j++)      
      { 
        c=txt1.charAt(j);
	   if ("0123456789.".indexOf(c,0)<0) 
	      {
		 alert("The data that you inputed should be numerical!!");    
		 return(false);
	      }
      }

      if (parseInt(Math.round(xUNSHIPQTY))==parseInt(Math.round(xUNDELIVERYQTY)))
	  {   

          //if (xRCV_QTY > parseInt(xALLOW_QTY) || xRCV_QTY == null || xRCV_QTY == "")
	      //{  --> 改成判斷剩餘可出數量
          if (xRCV_QTY > parseInt(xACCSHP_QTY) || xRCV_QTY == null || xRCV_QTY == "")
	      {  
	         alert("No Enough Qty to allow Shipping");

                 eval(formRCV_QTY);
 
	         return(false);  
              }
              else
              {
                 eval (formSELECTFLAG);
				 document.MYFORM.action="../jsp/TSSHPInvoiceAdd.jsp?INSERT=Y&SALESORDERNO="+xSalesOrder+"&LINE_ID="+xLineID+"&RCVQTY="+eval(formRCV_QTY_Write);
                 document.MYFORM.submit();
               }
          }	
      else 
	  {  
 	     alert("MO Qty not equal PO Qty,please Check!!");
             document.write(document.MYFORM.NOEQUAL.values)="Y";
             eval(formRCV_QTY);
	     return(false); 
          }

  } else
  {
	     alert("No Qty to allow Shipping");
             eval(formRCV_QTY);
	     return(false);  
  }
 }
}


function chkStatus()
{    
   document.MYFORM.action="../jsp/TSSHPInvoiceQuery.jsp";
   document.MYFORM.submit();
} 

function setSubmit4(URL)
{
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function alertDifferCustomer()
{  
  //document.MYFORM.elements["TEST"].value="";
  document.write(document.MYFORM.SALESORDERNO.values)="";
  //document.MYFORM.SALESORDERNO.focus();
}  
</script>
<html>
<head>

<title>Invoice Add Shippint Detail</title>
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
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


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String invItem=request.getParameter("INVITEM");
String dnDocNo=request.getParameter("DNDOCNO");

String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");

  String customerId=request.getParameter("CUSTOMERID");
  String customerNo=request.getParameter("CUSTOMERNO");
  String customerName=request.getParameter("CUSTOMERNAME");
  String custActive=request.getParameter("CUSTACTIVE");
  
  String salesAreaNo=request.getParameter("SALESAREANO");
  String salesOrderNo=request.getParameter("SALESORDERNO");
  String preOrderType=request.getParameter("PREORDERTYPE");
  String custPONo=request.getParameter("CUSTPONO");
  String createdBy=request.getParameter("CREATEDBY");
  String salesPerson=request.getParameter("SALESPERSON");
  String prodManufactory=request.getParameter("PRODMANUFACTORY");
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE");  
  String wshStatusCode=request.getParameter("WSHSTATUS"); 
  
   String ShipToOrg = request.getParameter("SHIPTOORG"); 
   String shipAddress = request.getParameter("SHIPADDRESS");
   String billAddress = request.getParameter("BILLADDRESS");
   String shipCountry = request.getParameter("SHIPCOUNTRY"); 
   String billCountry = request.getParameter("BILLCOUNTRY"); 
   String line_No=request.getParameter("LINE_NO");
   String shipTo = request.getParameter("SHIP_TO"); 
   String billTo = request.getParameter("BILLTO"); 
   String deliverTo = request.getParameter("DELIVERTO");
   String shipMethod = request.getParameter("SHIPMETHOD");
   String fobPoint = request.getParameter("FOBPOINT");
   String paymentTerm = request.getParameter("PAYTERM");
   String pTermDesc = "";
  // String payTerm = request.getParameter("PAYTERM");
   String payTermID = request.getParameter("PAYTERMID");
   
   String promiseDate = request.getParameter("PROMISEDATE");
   String custItemNo = request.getParameter("CUSTITEMNO");
   String custItemID = request.getParameter("CUSTOMERID");
   String custItemType = request.getParameter("CUSTITEMTYPE");
   String [] check=request.getParameterValues("CHKFLAG");
   String inventoryItemId = request.getParameter("INVENTORY_ITEM_ID");    

   String rcv_Qty = request.getParameter("RCV_QTY"+Integer.toString(rs1__index+1));
   String tsInvoiceNo = request.getParameter("TSINVOICENO"); 
   String shipDate = request.getParameter("SHIPDATE");
   String systemDate = request.getParameter("SYSTEMDATE");
   String tsCustomerID = request.getParameter("TSCUSTITEMID");
   //String poNum = request.getParameter("PO_NUM");  
   
   String poHeaderId = request.getParameter("PO_HEADER_ID");     
   String lineLocationId = request.getParameter("LINE_LOCATION_ID");     
   String poLineId = request.getParameter("PO_LINE_ID");  
   String custAROverdue = request.getParameter("CUSTOMERAROVERDUE");
   String [] selectFlag=request.getParameterValues("SELECTFLAG");
   String noEqual="";
   String unship_Qty = request.getParameter("UNSHIP_QTY");   
   String undelivery_Qty = request.getParameter("UNDELIVERY_QTY");
   String allow_Qty = request.getParameter("ALLOW_QTY");
   String countInv = request.getParameter("COUNTINV"); 
   String countWsh = request.getParameter("COUNTWSH"); 
   String headerId = request.getParameter("HEADER_ID");    
   String lineId = request.getParameter("LINE_ID");  
   String rowCnt = request.getParameter("ROWCNT");
   String rcvQty = request.getParameter("RCVQTY");
   String ncustomerNo = request.getParameter("CUSTOMERNO");
   String nShipToOrg = request.getParameter("SHIPTOORG");
   String nshipMethod = request.getParameter("SHIPMETHOD");
   String nfobPoint = request.getParameter("FOBPOINT");
   String npaymentTerm = request.getParameter("PAYTERM");   
   String chkCombine="";   
   String salesOrderCustNo = "";
   
   String [] addItems=request.getParameterValues("ADDITEMS");
   String isModelSelected=request.getParameter("ISMODELSELECTED");  
   String thTime_allow_Qty = "0";
   String insertPage=request.getParameter("INSERT"); 
   
   String oriInvCustNo = "";
   
   int cntInvNo = 0;
   int cntWsh = 0;
   
   int rowCntNo = 0;
   
   if (rowCnt!=null) rowCntNo = Integer.parseInt(rowCnt);
   if (allow_Qty==null) allow_Qty = "0";    
  	
   double base=0;		//換算計量單位的基數
   double undeliveryQty =0;
   double allowQty = 0;
   double thTime_allowQty = 0; 


  String sqlGlobal = "";
  String sWhereGlobal = "";
  
  if (customerId==null || customerId.equals("")) customerId="0";
  if (customerNo==null || customerNo.equals("")) customerNo="";
  if (customerName==null || customerName.equals("")) customerName="";
  if (custPONo==null || custPONo.equals("")) custPONo="";
  if (createdBy==null || createdBy.equals("")) createdBy="";
  if (salesPerson==null || salesPerson.equals("")) salesPerson="";
  if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";

  if (statusCode==null || statusCode.equals("")) statusCode="";
  if (wshStatusCode==null || wshStatusCode.equals("")) wshStatusCode="";
  if (rcv_Qty ==null || rcv_Qty.equals("")) rcv_Qty="";

  //out.println(rs1__index+1);

  //out.println(rcv_Qty+"<BR>");
  
  if (ShipToOrg==null) ShipToOrg = "";
  if (shipAddress==null) shipAddress = "";
  if (shipMethod==null) shipMethod = "";
  if (fobPoint==null) fobPoint = "";
  if (paymentTerm==null) paymentTerm = "";
  
  if (nShipToOrg==null) nShipToOrg = "";
  if (nshipMethod==null) nshipMethod = "";
  if (nfobPoint==null) nfobPoint = "";
  if (npaymentTerm==null) npaymentTerm = "";  
  

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  
  if (tsInvoiceNo==null) tsInvoiceNo = "";
  if (oriInvCustNo==null) oriInvCustNo = "";
  
  int iDetailRowCount = 0;

  if (shipDate==null || shipDate.equals("")) shipDate = dateBean.getYearMonthDay();
  if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
  
  
  if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
  {     
	shpArray2DTemporaryBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  }


    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();

	  // 為存入日期格式為US考量,將語系先設為美國
	  String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
      PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	  pstmtNLS.executeUpdate(); 
      pstmtNLS.close();

      //抓取系統日期
/*20060407
    String sql=" select UPPER(STATUS) as PERIOD_STATUS from APPS.ORG_ACCT_PERIODS_V "+
               " where ORGANIZATION_ID="+organizationId+" and PERIOD_NAME = TO_CHAR(TO_DATE("+shipDate+",'YYYYMMDD'),'MON-YY') ";
  
    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE from dual" );
	if (sd.next())
	 {
	   systemDate=sd.getString("SYSTEMDATE");	 
	  }
	sd.close();
    statesd.close();	
*/
	 
	 //String shpSalesOrderItemArray[][]=null;
	 //String oneDArray[]= {"","","客戶訂單號","訂單項次ID","出貨數"};  
	 String oneDArray[]= {"","No.","Sales Order No.","Line ID","Ship Q'ty"}; 
     shpArray2DTemporaryBean.setArrayString(oneDArray);	
	 
	 
	 String shpSalesOrderItemArray[][] = new String[rowCntNo][]; // 宣告一維陣列,將Contact設定資訊置入Array[row][column]
	 
	 String at[][]=shpArray2DTemporaryBean.getArray2DContent(); // 取二維陣列內容
     if (at!=null)
     {
      //out.println(array2DMOContactInfoBean.getArrayString()); // 把內容印出來
	  //out.println("at[0][0]="+at[0][0]+ " at[0][1]=" +at[0][3]+" at[0][3]=" +at[0][12]+"<BR>"); 
	  //out.println("at[1][0]="+at[1][0]+ " at[1][1]=" +at[1][3]+" at[1][3]=" +at[1][12]+"<BR>");
	  //out.println("at[2][0]="+at[2][0]+ " at[2][1]=" +at[2][3]+" at[2][3]=" +at[2][12]+"<BR>");
	  for (int ac=0;ac<at.length;ac++)
	  {   //out.println("Column="+at[ac].length+"<BR>");  	        
          for (int subac=1;subac<at[ac].length;subac++)
	      {
			//out.println("at[ac].length="+at[ac].length+"<BR>");
			  if (request.getParameter("MONTH"+ac+"-"+subac)!=null && request.getParameter("MONTH"+ac+"-"+subac).trim()!="")
		      { 
			   at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位		
			  }
			   
		   }  //end for array second layer count
	  } //end for array first layer count
	  shpArray2DTemporaryBean.setArray2DString(at);  //reset Array
     }
	 
	 
   if (addItems!=null) //若有選取則表示要刪除
   { 
    String a[][]=shpArray2DTemporaryBean.getArray2DContent();//重新取得陣列內容  
	//out.println("Step2:"+a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");      
    if (a!=null && addItems.length>0)      
    { 		 
	 if (a.length>addItems.length)
	 {	  	  	    
       String t[][]=new String[a.length-addItems.length][a[0].length];     
	   int cc=0; 
	   for (int m=0;m<a.length;m++)
	   {
	    String inArray="N";		
		for (int n=0;n<addItems.length;n++)  
		{
		 if (addItems[n].equals(a[m][0])) inArray="Y";
		} //end of for addItems.length  		 
		if (inArray.equals("N")) 
		{
		 if (a[m][1]!=null && a[m][1].trim() != "") // 除去那些Excel cell為null的_起
		 {
		   for (int gg=0;gg<4;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
		   {                          // 目前共7個{ iNo,invItem,itemDesc,orderQty,uom,requestDate,lnRemark }      
    		 // t[cc][gg]=a[m][gg];  //原先直接將暫存內容置入,
			 if (gg==0)
			 {
			   t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算
			 }
			 else {
			        t[cc][gg]=a[m][gg];         
			      }
	       }
		   cc++;	
		 } // End of if (a[m][1]!=null && a[m][1].trim() != "") // 除去那些Excel cell為null的_迄  	     
		}  
	   } //end of if a.length		
	   //out.println("Step3:"+a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");     
	   shpArray2DTemporaryBean.setArray2DString(t);	  
	 } else { 	//else (a!=null && addItems.length>0 )  			 
	          //arrayRFQDocumentInputBean.setArray2DString(null); //若陣列內容不為空,且addItems.length>0,則將陣列內容清空
			   if (a.length==addItems.length)
			   {  
			     shpArray2DTemporaryBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空 
			   } // End of if (a.length==addItems.length)
			   //out.println("Step4:"+a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");
	        }  
	}//end of if a!=null
   } //end of if (addsItem!=null)
else {
       
     } 
	 
	 if (salesOrderNo!=null && lineId!=null && rcvQty!=null)
	 {
	       int i=0,j=0,k=0;
	       if (at!=null) 
		   { 
		       String b[][]=new String[at.length+1][at[i].length];	
			 
			   for (i=0;i<at.length;i++)			   
			   { 
			    if (at[i][3]!=null && at[i][3].trim()!="")	// 除去那些為null的 Excel表cell    			 
			    {
			      //out.println("a[i][1]="+a[i][1]+"<BR>");
				  //out.println("a[i][2]="+a[i][2]+"<BR>");
			      for (j=0;j<at[i].length;j++)
			      { //out.println("step4");
			         
					  b[i][j]=at[i][j];	
					 			    
                   //if (a[k][0].equals(orderQty)) { dupFLAG = "TRUE"; }					 			
			      } // End of for (j=0)
			      k++;			
				 }    
			   }// End of for (i=0) 
			  
			  b[k][0]=Integer.toString(k+1);
			  b[k][1]=salesOrderNo;
			  b[k][2]=lineId;
			  b[k][3]=rcvQty;
			  //b[k][4]="";b[k][5]="";b[k][6]="";b[k][7]="";b[k][8]="";b[k][9]="";b[k][10]="";b[k][11]="";
			  //b[k][12]="";
			  //b[k][13]="";b[k][14]="";b[k][15]="";b[k][16]="";b[k][17]="";b[k][18]="";b[k][19]="";b[k][20]="";
			  //b[k][21]="";b[k][22]="";b[k][23]="";b[k][24]="";
	          shpArray2DTemporaryBean.setArray2DString(b);
			  shpArray2DTemporaryBean.setArray2DCheck(b);
			  
			  // out.println("b[0][0]="+b[0][0]+ " b[0][1]=" +b[0][1]+" b[0][2]=" +b[0][2]+" b[0][3]=" +b[0][3]+"<BR>"); 
	          // out.println("b[1][0]="+b[1][0]+ " b[1][1]=" +b[1][1]+" b[1][2]=" +b[1][2]+" b[1][3]=" +b[1][3]+"<BR>");
	           //out.println("ta[2][0]="+at[2][0]+ " at[2][1]=" +at[2][1]+" at[2][2]=" +at[2][2]+"<BR>");
			  
		   }  //End of if (at!=null)
		   else
		      { 
			     String c[][] = new String[rowCntNo][4]; // 宣告二維陣列,將Contact設定資訊置入Array[row][column]
				 c[0][0] = "1";
				 c[0][1] = salesOrderNo;
				 c[0][2] = lineId;
				 c[0][3] = rcvQty;
				 //c[0][4]="";c[0][5]="";c[0][6]="";c[0][7]="";c[0][8]="";c[0][9]="";c[0][10]="";c[0][11]="";
			     //c[0][12]="";
			     //c[0][13]="";c[0][14]="";c[0][15]="";c[0][16]="";c[0][17]="";c[0][18]="";c[0][19]="";c[0][20]="";
			     //c[0][21]="";c[0][22]="";c[0][23]="";c[0][24]="";
				 shpArray2DTemporaryBean.setArray2DString(c);
			     shpArray2DTemporaryBean.setArray2DCheck(c);
				// out.println("c[0][0]="+c[0][0]+ " c[0][1]=" +c[0][1]+" c[0][2]=" +c[0][2]+" c[0][3]=" +c[0][3]+"<BR>"); 
			  }
	 } //End of if (salesOrderNo!=null && lineId!=null && rcvQty!=null)
  //out.println("KKKK");
%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style2 {
	color: #FF0099;
	font-weight: bold;
	font-family: Arial, Helvetica, sans-serif;
}
.style12 {color: #CC0066}
.noborder{
    border:0;
	color:#CC0066;	
	background-color:#EAFAFA;	
}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>  
<FORM ACTION="../jsp/TSSHPInvoiceAdd.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgShipType"/>
<jsp:getProperty name="rPH" property="pgInvoiceNo"/>
<jsp:getProperty name="rPH" property="pgDetail"/><jsp:getProperty name="rPH" property="pgAdd"/></strong></font>
<%

    try
	{
	  if (tsInvoiceNo!=null)
      {
         //判斷此INVOICE是否"CLOSED" "CLOSED"的INVOICE回到查詢頁面
         Statement statefnds=con.createStatement();
         ResultSet rsfnds=statefnds.executeQuery("select STATUS from APPS.TSC_DROPSHIP_SHIP_HEADER where TSINVOICENO = upper('"+tsInvoiceNo+"') ");
		 if (rsfnds.next())
		 { statusCode = rsfnds.getString("STATUS"); }		
		 rsfnds.close();
         statefnds.close();	
		  //out.println("statusCode"+statusCode);

         //判斷此INVOICE是否於WSH_NEW_DELIVERIES中"CLOSED" "CLOSED"的INVOICE回到查詢頁面
         Statement statefndsa=con.createStatement();
         ResultSet rsfndsa=statefndsa.executeQuery("select STATUS_CODE as WSHSTATUS from APPS.WSH_NEW_DELIVERIES where NAME = upper('"+tsInvoiceNo+"') ");
		 if (rsfndsa.next())
		 { 
		  wshStatusCode    = rsfndsa.getString("WSHSTATUS");
		 }
		 rsfndsa.close();
         statefndsa.close();	
		  //out.println("wshStatusCode"+wshStatusCode);

    } //end if  (tsInvoiceNo!=null)		
	    if (statusCode =="CLOSED" || statusCode.equals("CLOSED"))
		{
		 %>
		   <script language="javascript">
		     alert("This Drop Ship Invoice Already Closed!!");
			 chkStatus();
		   </script>
		 <%
		  }				   
      if (wshStatusCode =="CLOSED" || wshStatusCode.equals("CLOSED"))
		 {
		 %>
		   <script language="javascript">
		     alert("This Invoice Already Closed!!");
			 chkStatus();
		   </script>
		 <%
		  }			   
	   
	  	} //end of try
    catch (Exception e)
    {
          out.println("Exception a0:"+e.getMessage());
    }   
try
{
           //查詢在tsc_dropship_ship_header中,是否已存在該invoice no,若存在要帶出相關客戶資訊做比對
		   String sqlc = " select COUNT(TDSH.TSINVOICENO) as COUNTINV from APPS.TSC_DROPSHIP_SHIP_HEADER TDSH  where TDSH.TSINVOICENO= upper('"+tsInvoiceNo+"') and STATUS !='CLOSED'";
           //out.println("<BR>sqlOrdCust="+sqlc);
           Statement statect=con.createStatement();
           ResultSet rsct=statect.executeQuery(sqlc);
		   if (rsct.next())
		   { countInv  = rsct.getString("COUNTINV"); cntInvNo = rsct.getInt("COUNTINV");   }  
		   rsct.close();
           statect.close();		
 
           //查詢在WSH_NEW_DELIVERIES中,是否已存在該invoice no,若存在要帶出相關客戶資訊做比對
		   String sqlw = " SELECT count(DISTINCT wnd.delivery_id) as COUNTWSH  "+
          				 "    FROM apps.wsh_delivery_assignments wda, apps.wsh_delivery_details wdd, "+
                		 "         apps.wsh_new_deliveries wnd, apps.ra_customers ra "+
         				 "    WHERE wda.delivery_detail_id = wdd.delivery_detail_id "+
            			 "      AND wda.delivery_id = wnd.delivery_id  AND ra.customer_id = wnd.customer_id "+
						 "      AND wnd.name= upper('"+tsInvoiceNo+"') ";
           //out.println("<BR>sqlw="+sqlw);
           Statement statecw=con.createStatement();
           ResultSet rscw=statecw.executeQuery(sqlw);
		   if (rscw.next())
		   { countWsh  = rscw.getString("COUNTWSH"); cntWsh  = rscw.getInt("COUNTWSH");  }  
		   rscw.close();
           statecw.close();  
		   
		   
		 if (countWsh !="0" || !countWsh.equals("0") )		//有INVOICE存在,則抓INVOICE的客戶資訊
	     { 
		   String customerID = "0";
		   String sqlwsh = " select distinct WND.NAME ,WND.CUSTOMER_ID,WND.FOB_CODE,WND.SHIP_METHOD_CODE ,WDD.SHIP_TO_SITE_USE_ID,RA.CUSTOMER_NAME,RA.CUSTOMER_NUMBER "+
								" from APPS.WSH_DELIVERY_ASSIGNMENTS WDA, APPS.WSH_DELIVERY_DETAILS WDD, APPS.WSH_NEW_DELIVERIES WND ,APPS.RA_CUSTOMERS RA "+
								" where WDA.DELIVERY_DETAIL_ID=WDD.DELIVERY_DETAIL_ID  and WDA.DELIVERY_ID=WND.DELIVERY_ID "+
								" 	  and RA.CUSTOMER_ID=WND.CUSTOMER_ID  and WND.NAME = upper('"+tsInvoiceNo+"') ";
          // out.println("<BR>sqlInvCust="+sqlwsh);
           Statement stateWsh=con.createStatement();
           ResultSet rsWsh=stateWsh.executeQuery(sqlwsh);
		   if (rsWsh.next())
		   {
		      customerID     = rsWsh.getString("CUSTOMER_ID");
		      customerNo     = rsWsh.getString("CUSTOMER_NUMBER");
			  customerName   = rsWsh.getString("CUSTOMER_NAME");
			  ShipToOrg      = rsWsh.getString("SHIP_TO_SITE_USE_ID");
			//  shipAddress    = ""; //rsWsh.getString("SHIPADDRESS");
			  shipMethod     = rsWsh.getString("SHIP_METHOD_CODE");
			  fobPoint       = rsWsh.getString("FOB_CODE");
			 // paymentTerm    = ""; //rsWsh.getString("PAYTERM");
			 
			 oriInvCustNo = customerNo;  // 若舊發票已存在,則將發票對應的客戶代號存起來...
			 
			
			 String sqlGetWAdd = "select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1,  "+		
				                 "       a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION, "+  
					             "       a.ATTRIBUTE1, d.CURRENCY_CODE, f.MASTER_GROUP_ID "+
					             "  from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c, "+  
					             "       SO_PRICE_LISTS d, TSC_OM_GROUP e, TSC_OM_GROUP_MASTER f "+				  
					             " where a.ADDRESS_ID = b.ADDRESS_ID and a.STATUS=b.STATUS and a.STATUS='A' and a.PAYMENT_TERM_ID = c.TERM_ID(+) "+		
					             "   and a.PRIMARY_FLAG='Y' and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+		
							                                                "where to_char(CUST_ACCOUNT_ID) ='"+customerID+"') "+
	                             "   and a.PRICE_LIST_ID = d.PRICE_LIST_ID "+
   	                             "   and a.ATTRIBUTE1 = e.GROUP_ID(+) "+
       	                         "   and e.MASTER_GROUP_ID = f.MASTER_GROUP_ID(+) "+
				                 " order by a.SITE_USE_CODE DESC";
			Statement stateGetWAdd=con.createStatement();
            ResultSet rsGetWAdd=stateGetWAdd.executeQuery(sqlGetWAdd);  
			if (rsGetWAdd.next())
			{
			  shipAddress    =  rsGetWAdd.getString("ADDRESS1");
			  paymentTerm    =  rsGetWAdd.getString("PAYMENT_TERM_NAME");
			  if (shipMethod==null) shipMethod = rsGetWAdd.getString("SHIP_VIA");
			  if (fobPoint==null) fobPoint = rsGetWAdd.getString("FOB_POINT");
			}
			rsGetWAdd.close();
			stateGetWAdd.close(); 
	       }
	       rsWsh.close();
           stateWsh.close();	 
        }//(countWsh !="0" || !countWsh.equals("0") )   
	       	  
	  
	    if (countInv !="0" || !countInv.equals("0") )		//有INVOICE存在,則抓INVOICE的客戶資訊
	 	{
		   String sqlInvCust = " select TDSH.CUSTOMERNO,TDSH.CUSTOMERNAME,TDSH.SHIPTOORG,TDSH.SHIPMETHOD,TDSH.FOBPOINT,TDSH.PAYTERM,TDSH.SHIPADDRESS "+
		                       "  from APPS.TSC_DROPSHIP_SHIP_HEADER TDSH  "+
                               " where TDSH.TSINVOICENO= upper('"+tsInvoiceNo+"') and TDSH.STATUS !='CLOSED' ";
           //out.println("<BR>sqlInvCust="+sqlInvCust);
           Statement stateInvCust=con.createStatement();
           ResultSet rsInvCust=stateInvCust.executeQuery(sqlInvCust);
		   if (rsInvCust.next())
		   {
		      customerNo     = rsInvCust.getString("CUSTOMERNO");
			  customerName   = rsInvCust.getString("CUSTOMERNAME");
			  ShipToOrg      = rsInvCust.getString("SHIPTOORG");
			  shipAddress    = rsInvCust.getString("SHIPADDRESS");
			  shipMethod     = rsInvCust.getString("SHIPMETHOD");
			  fobPoint       = rsInvCust.getString("FOBPOINT");
			  paymentTerm    = rsInvCust.getString("PAYTERM");
			  oriInvCustNo = customerNo;  // 若DropShip發票已存在,則將發票對應的客戶代號存起來...
		  
		   }
		   rsInvCust.close();
           stateInvCust.close();	
		   
	    }//if (countInv !="0" || !countInv.equals("0") )

    
		  
	    //若是新增invoice,客戶資訊要抓mo單info(即舊發票出貨及新Drop Ship檔都無資料;不為併單,則取MO客戶資料)_起
         String sqlMOrdCust = "select CUSTOMER_NUMBER,SOLD_TO,SHIP_TO_ORG_ID,SHIP_TO_ADDRESS1,SHIPPING_METHOD_CODE,FOB_POINT_CODE ,PAYMENT_TERM_ID,TERMS "+
                              "from OE_ORDER_HEADERS_V "+
                              "where ORDER_NUMBER= '"+salesOrderNo+"' ";
         //out.println("<BR>sqlOrdCust="+sqlOrdCust);
         Statement stateMOrdCust=con.createStatement();
         ResultSet rsMOrdCust=stateMOrdCust.executeQuery(sqlMOrdCust);
		 if (rsMOrdCust.next())
		 {
		    salesOrderCustNo = rsMOrdCust.getString("CUSTOMER_NUMBER");						
		 } else {
		           if (salesOrderNo!=null && !salesOrderNo.equals(""))
				   {
		            %>			
		            <script language="javascript">
			         //alertDifferCustomer();		
		             alert("<jsp:getProperty name='rPH' property='pgAlertNotExistsMO'/>");			 	 
		            </script>			
		           <%			
				   } // End of if (salesOrderNo!=null && !salesOrderNo.equals(""))
		        }
		 rsMOrdCust.close();
         stateMOrdCust.close();	
	    //若是新增invoice,客戶資訊要抓mo單info(即舊發票出貨及新Drop Ship檔都無資料;不為併單,則取MO客戶資料)_迄
	  
	   if (salesOrderNo!=null && (countInv=="0" || countInv.equals("0")) && (countWsh=="0" || countWsh.equals("0")))  
       {  
	     
	     //若是新增invoice,客戶資訊要抓mo單info(即舊發票出貨及新Drop Ship檔都無資料;不為併單,則取MO客戶資料)
         String sqlOrdCust = "select CUSTOMER_NUMBER,SOLD_TO,SHIP_TO_ORG_ID,SHIP_TO_ADDRESS1,SHIPPING_METHOD_CODE,FOB_POINT_CODE ,PAYMENT_TERM_ID,TERMS "+
                             "from OE_ORDER_HEADERS_V "+
                             "where ORDER_NUMBER= '"+salesOrderNo+"' ";
         //out.println("<BR>sqlOrdCust="+sqlOrdCust);
         Statement stateOrdCust=con.createStatement();
         ResultSet rsOrdCust=stateOrdCust.executeQuery(sqlOrdCust);
		 if (rsOrdCust.next())
		 {
		    customerNo     = rsOrdCust.getString("CUSTOMER_NUMBER");
			customerName   = rsOrdCust.getString("SOLD_TO");
			ShipToOrg      = rsOrdCust.getString("SHIP_TO_ORG_ID");
			shipAddress    = rsOrdCust.getString("SHIP_TO_ADDRESS1");
			shipMethod     = rsOrdCust.getString("SHIPPING_METHOD_CODE");
			fobPoint       = rsOrdCust.getString("FOB_POINT_CODE");
			paymentTerm    = rsOrdCust.getString("TERMS");			
		  }
		  rsOrdCust.close();
          stateOrdCust.close();	
		  
	   } 
	  else	
	  if (salesOrderNo!=null && salesOrderCustNo!="" && cntWsh > 0)
      {  
         /* 
		   String sqlwsh = " select distinct WND.NAME ,WND.CUSTOMER_ID,WND.FOB_CODE,WND.SHIP_METHOD_CODE ,WDD.SHIP_TO_SITE_USE_ID,RA.CUSTOMER_NAME,RA.CUSTOMER_NUMBER "+
								" from APPS.WSH_DELIVERY_ASSIGNMENTS WDA, APPS.WSH_DELIVERY_DETAILS WDD, APPS.WSH_NEW_DELIVERIES WND ,APPS.RA_CUSTOMERS RA "+
								" where WDA.DELIVERY_DETAIL_ID=WDD.DELIVERY_DETAIL_ID  and WDA.DELIVERY_ID=WND.DELIVERY_ID "+
								" 	  and RA.CUSTOMER_ID=WND.CUSTOMER_ID  and WND.NAME = upper('"+tsInvoiceNo+"') ";
           //out.println("<BR>sqlInvCust="+sqlInvCust);
           Statement stateWsh=con.createStatement();
           ResultSet rsWsh=stateWsh.executeQuery(sqlwsh);
		   if (rsWsh.next())
		   {
		      ncustomerNo     = rsWsh.getString("CUSTOMER_NUMBER");
			  nShipToOrg      = rsWsh.getString("SHIP_TO_SITE_USE_ID");
			  nshipMethod     = rsWsh.getString("SHIP_METHOD_CODE");
			  nfobPoint       = rsWsh.getString("FOB_CODE");
			  //npaymentTerm    = rsWsh.getString("PAYTERM");		  
		   }
		   rsWsh.close();
           stateWsh.close();	
		   */
      }  
		// out.println("cntInvNo= "+cntInvNo+"   cntWsh="+cntWsh);
	//   if ((salesOrderNo!=null || salesOrderNo!="") && (countInv!="0" || !countInv.equals("0")))  //若是舊invoice,客戶資訊要抓出來比對  20060407	   		 
	  else if (salesOrderNo!=null && salesOrderCustNo!="" && cntInvNo >0) //若是舊invoice,客戶資訊要抓出來比對
       { 
		 /*
		  
		  String sql2=" select TDSH.CUSTOMERNO,TDSH.CUSTOMERNAME,TDSH.SHIPTOORG,TDSH.SHIPMETHOD,TDSH.FOBPOINT,TDSH.PAYTERM,TDSH.SHIPADDRESS "+
		              "  from APPS.TSC_DROPSHIP_SHIP_HEADER TDSH  ";
          String swh2= " where TDSH.TSINVOICENO= upper('"+tsInvoiceNo+"') and TDSH.STATUS !='CLOSED' ";	  
		
			
		 String sqla = sql2+swh2;
         Statement stateOrdCustn=con.createStatement();
         ResultSet rsOrdCustn=stateOrdCustn.executeQuery(sqla);
		 //out.println(sqla);
		 if (rsOrdCustn.next())
		 {
		    ncustomerNo     = rsOrdCustn.getString("CUSTOMERNO");
			customerName    = rsOrdCustn.getString("CUSTOMERNAME");
			nShipToOrg      = rsOrdCustn.getString("SHIPTOORG");
			nshipMethod     = rsOrdCustn.getString("SHIPMETHOD");
			nfobPoint       = rsOrdCustn.getString("FOBPOINT");
			npaymentTerm    = rsOrdCustn.getString("PAYTERM");	
			shipAddress     = rsOrdCustn.getString("SHIPADDRESS");			
			
		 }
		 rsOrdCustn.close();
         stateOrdCustn.close();
		 
		*/ 
		   		   
	  }	//end 若是舊invoice,客戶資訊要抓出來比對	
		  
      if (customerNo!=null && (salesOrderCustNo!=null && !salesOrderCustNo.equals("")) )
	  {   
	    //out.println("customerNo="+customerNo);
		//out.println("salesOrderCustNo="+salesOrderCustNo);
        if (salesOrderCustNo!=customerNo && !salesOrderCustNo.equals(customerNo))
	    {
		    %>			
		    <script language="javascript">
			 //alertDifferCustomer();		
		     alert("<jsp:getProperty name='rPH' property='pgAlertInvCustDiffMOCust'/>");			 	 
		    </script>			
		    <%			  
			chkCombine = "N"; // 設定為不能出貨...因為發票客戶與訂單客戶不相同
	    }
	  }	

	} //end of try
    catch (Exception e)
    {
          out.println("Exception a1:"+e.getMessage());
    }   

  
try
{

/*  找尋合法的訂單資訊 */

	sSql =  " select distinct OOH.ORDER_NUMBER as ORDER_NUM, OOL.LINE_NUMBER as LINE_NUM,MSI.SEGMENT1 as INV_ITEM ,MSI.DESCRIPTION as ITEM_DESC, "+
    	    "        OOL.ORDERED_ITEM, OOL.INVENTORY_ITEM_ID,OOL.ORDER_QUANTITY_UOM as UOM,OOL.LINE_ID,ODS.LINE_LOCATION_ID, "+
	   		"	     OOL.ORDERED_QUANTITY as ORDER_QTY,NVL (OOL.SHIPPED_QUANTITY, 0) as SHIP_QTY,   "+
       		"        OOL.ORDERED_QUANTITY - nvl (OOL.SHIPPED_QUANTITY, 0) UNSHIP_QTY, "+
			"		 OOH.SOLD_TO_ORG_ID as CUSTOMERID,OOH.SOLD_TO as CUSTOMERNAME,OOH.HEADER_ID,OOL.LINE_ID,OOH.SHIP_TO,OOH.INVOICE_TO_LOCATION as BILLTO,  "+
 			"		 OOH.CUSTOMER_NUMBER as CUSTOMERNO,OOH.SOLD_TO_ORG_ID as CUSTOMERID,OOH.SHIP_TO_ORG_ID as SHIPTOORG,OOL.SHIPPING_METHOD_CODE as SHIPMETHOD, "+
			"        OOL.FOB_POINT_CODE as FOBPOINT,OOL.TERMS as PAYTERM, OOH.SHIP_TO_ADDRESS1 as SHIPTOADD,	"+
			"        to_number(to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD'))-to_number(to_char(SYSDATE,'YYYYMMDD')) as SSHIP_DATE_JG, "+
			"        to_char(OOL.SCHEDULE_SHIP_DATE,'YYYYMMDD') as SCHEDULE_SHIP_DATE, "+
			"        OOH.SHIP_FROM_ORG_ID as WAREHOUSE_H, OOL.SHIP_FROM_ORG_ID as WAREHOUSE_D, OOH.CREATED_BY ";	

String sFrom = " from APPS.OE_ORDER_HEADERS_V OOH,APPS.OE_ORDER_LINES_V OOL,APPS.OE_DROP_SHIP_SOURCES ODS,APPS.MTL_SYSTEM_ITEMS MSI  ";

   sSqlCNT = "  select distinct count(distinct ooh.order_number) as CASECOUNT "; //計算MO總張數
   sSqlCNTITEM = "  select distinct count(ool.line_number) as iDetailRowCount ";  //計算總筆數

   sWhere = " where OOH.HEADER_ID=OOL.HEADER_ID   "+ 
            "   and ODS.LINE_ID=OOL.LINE_ID  "+
			"	and OOL.CANCELLED_FLAG !='Y' AND OOL.FLOW_STATUS_CODE !='SHIPPED' "+
			"	and OOL.FLOW_STATUS_CODE != 'CLOSED' "+
	        "   and OOL.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
			"	and OOH.SHIP_FROM_ORG_ID=MSI.ORGANIZATION_ID ";

 //若Invoice已有併單標準,應加入過濾條件	
/*
String sWhere2 ="	AND OOH.CUSTOMER_NUMBER=nvl(TDSH.CUSTOMERNO,OOH.CUSTOMER_NUMBER) "+
 	 			"	AND OOH.SHIP_TO_ORG_ID=nvl(TDSH.SHIPTOORG,OOH.SHIP_TO_ORG_ID) "+
 	 			"	AND OOH.SHIPPING_METHOD_CODE=nvl(TDSH.SHIPMETHOD,OOH.SHIPPING_METHOD_CODE) "+
	 			"	AND OOH.FOB_POINT_CODE=nvl(TDSH.FOBPOINT,OOH.FOB_POINT_CODE) "+
	 			"	AND OOH.TERMS=nvl(TDSH.PAYTERM,OOH.TERMS) "+	
				"	AND	TDSH.TSINVOICENO = upper('"+tsInvoiceNo+"') ";	
*/
String sWhere2 ="	AND OOH.CUSTOMER_NUMBER=nvl("+ncustomerNo+",OOH.CUSTOMER_NUMBER) "+
 	 			"	AND OOH.SHIP_TO_ORG_ID=nvl("+nShipToOrg+",OOH.SHIP_TO_ORG_ID) "+
 	 			"	AND OOH.SHIPPING_METHOD_CODE=nvl('"+nshipMethod+"',OOH.SHIPPING_METHOD_CODE) "+
	 			"	AND OOH.FOB_POINT_CODE=nvl('"+nfobPoint+"',OOH.FOB_POINT_CODE) "+
	 			"	AND OOH.TERMS=nvl('"+npaymentTerm+"',OOH.TERMS) ";

			
 //sOrderBy = " group by OOH.ORDER_NUMBER , OOL.LINE_NUMBER ,MSI.SEGMENT1,MSI.DESCRIPTION, "+
 //           "          OOL.ORDERED_ITEM, OOL.INVENTORY_ITEM_ID,OOL.ORDER_QUANTITY_UOM,OOL.LINE_ID,ODS.LINE_LOCATION_ID "+
 sOrderBy =		    " order by OOH.ORDER_NUMBER,OOL.LINE_NUMBER ";			

 if (salesOrderNo ==null || salesOrderNo.equals("") ) { sWhere = sWhere+" and OOH.ORDER_NUMBER='0' " ;}
 else { sWhere = sWhere+" and OOH.ORDER_NUMBER = '"+salesOrderNo+"' " ;}
   
 // 若為既存invoice(countInv !=0)則加入併單條件select
/*
 if ((countInv =="0" || countInv.equals("0")) && (countWsh =="0" || countWsh.equals("0")) ) 
   {  sWhere = sWhere+"" ;}
 //else {sWhere = sWhere+ sWhere2 ; } 
else{
  out.println("swhere="+sWhere+ sWhere2);
   }
*/

  sSql = sSql + sFrom + sWhere + sOrderBy ;
  sSqlCNT = sSqlCNT  + sFrom + sWhere ;
  sSqlCNTITEM = sSqlCNTITEM + sFrom + sWhere ;
  //out.println("sSqlCNT ="+sSqlCNT ); 
  //out.println("sSqlCNT ="+sSqlCNTITEM ); 
  //out.println("sSqlMO="+sSql); 
     

//計算mo張數
       Statement statement2=con.createStatement();
       ResultSet rs2=statement2.executeQuery(sSqlCNTITEM);
       if (rs2.next())
       {
        CaseCountORG = rs2.getInt("iDetailRowCount");     
       }
        rs2.close();
        statement2.close(); 

     	 
//計算item筆數	
         Statement statement3=con.createStatement();
         ResultSet rs3=statement3.executeQuery(sSqlCNT);
		 if (rs3.next())
		 {
		   //CaseCountORG = CaseCount;
		   CaseCount = rs3.getInt("CASECOUNT");
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   rs3.close();
		   statement3.close();
		 }
		} //end of try
        catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        }
   

sqlGlobal = sSql;
Statement statementTC=con.createStatement(); 
ResultSet rsTC=statementTC.executeQuery(sSql);
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  
//int RpRepair_numRows = 0;


		  

// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;


if (rs_isEmptyTC) {
  rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) {
  rs_numRows = 1;
}

String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = rsTC;
int       MM_rsCount = rs_total;
int       MM_size = rs_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) {
    rs_hasDataTC = MM_rs.next();
  }
  if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    rs_hasDataTC = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!rs_hasDataTC) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!rs_hasDataTC && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  rsTC.close();
  rsTC = statementTC.executeQuery(sSql);
  rs_hasDataTC = rsTC.next();
  MM_rs = rsTC;

  // move the cursor to the selected record
  for (i=0; rs_hasDataTC && i < MM_offset; i++) {
    rs_hasDataTC = MM_rs.next();
  }
}

// *** Move To Record: update recordset stats

// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  rs_first = Math.min(rs_first, MM_rsCount);
  rs_last  = Math.min(rs_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
}

%>  
  <table cellSpacing='0' high='20'  bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
      <td width="15%" colspan="1" ><strong><font color="#006666"  ><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/></font>
      </strong></td> 
		<td colspan="6"><strong>
		<input name="TSINVOICENO" type="text" class="noborder" tabindex='4' value="<%=tsInvoiceNo.toUpperCase()%>" size="15" maxlength="20" readonly>
		</strong>
		<% if (tsInvoiceNo!=null) {
		%><a href='javaScript:callInv()' ><img src="../image/docicon.gif" width="14" height="15" border="0"></a>
		
		<% } %>
		</td>
		
	 </tr>
	 <tr>
	   <td height="20"><font color="#006666"  ><strong>
       <jsp:getProperty name="rPH" property="pgSalesOrderNo"/></strong></font></td> 
	   <td colspan="6">
	        <input type="text" size="15" name="SALESORDERNO" value="<%=salesOrderNo%>"  onKeyDown='setSubmit1a("../jsp/TSSHPInvoiceAdd.jsp")'><font color="#006666"  ></font>
			<INPUT TYPE="button" name="QUERY" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit1("../jsp/TSSHPInvoiceAdd.jsp?INSERT=Y")' > 
            <input type="reset" name="RESET" align="middle"  value='<jsp:getProperty name="rPH" property="pgReset"/>' onClick='setSubmit2("../jsp/TSSHPInvoiceAdd.jsp")' >            
	   </td>
			
	 </tr>	 	 
	 <tr>
	   <td><font color="#006666"  ><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></td>
	   <td colspan="6">
	        <input type="text" size="10" name="CUSTOMERNO" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)'  value="<%=customerNo%>" class="noborder" readonly>
			<input type="text" size="50" name="CUSTOMERNAME" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=customerName%>" class="noborder" readonly>
	   </td>
	 </tr>
	 <tr>
	    <td nowrap colspan="1"><font color="#006666"  ><strong><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font>
         
        </td> 
		<td colspan="6">
		   <div align="left">
		   <font color="#006666"  ><strong> </strong></font>
		   <input type="text" size="10" name="SHIPTOORG" tabindex='4' onKeyDown='setShipToFind("SHIP_TO",this.form.CUSTOMERID.value,this.form.SHIPTOORG.value)' value="<%=ShipToOrg%>" class="noborder" readonly>		
		   <INPUT TYPE="text" NAME="SHIPADDRESS" tabindex='6' SIZE=100 value="<%=shipAddress%>" class="noborder" readonly> 
		   </div>
		</td>
    </tr>		 
	<tr>
	  <td>
		   <div align="left">
		   <font color="#006666"  ><strong><jsp:getProperty name="rPH" property="pgShippingMethod"/> </strong></font>
		   </div>
      </td>
	  <td width="10%">   
		     <input type="text" size="10" name="SHIPMETHOD" tabindex='17' value="<%=shipMethod%>" class="noborder" readonly>
      </td> 	  
		<td width="5%"><div align="center">
		   <font color="#006666"   ><strong><jsp:getProperty name="rPH" property="pgFOB"/> </strong></font></div>
		</td>
	  <td width="15%">
		     <input type="text" size="15" name="FOBPOINT" tabindex='15' value="<%=fobPoint%>" class="noborder"  readonly>
	  </td>
		<td width="8%"><div align="center">
		   <font color="#006666"  ><strong><jsp:getProperty name="rPH" property="pgPaymentTerm"/> </strong></font></div>
		</td>
	  <td width="22%">
		  <input type="text" size="28" name="PAYTERM" tabindex='12' value="<%=paymentTerm%>" class="noborder"  readonly>
	      <input type="hidden" size="10" name="PAYTERMID" tabindex='13' value="<%=payTermID%>" class="noborder" >
	  </td>
</td>
</tr>   
  </table>  
  <table cellspacing="0" bordercolordark="#99CCCC" cellpadding="1" width="100%" align="center" bordercolorlight="#CCffCC" border="1">
    <tr bgcolor="#99CC99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000"  >&nbsp;</font></div></td> 
	  <td width="0%" height="22" nowrap><div align="center"><font color="#006666"  >&nbsp;</font></div></td> 
                           
      <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></div></td>
      <td width="2%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgDetail"/><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td>            
      <td width="10%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgPart"/></font></div></td> 
	  <td width="10%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgMRDesc"/></font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="3%" nowrap><div align="center"><font color="#006666"  ><A>Line ID</A></font></div></td> 
	  <td width="3%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgUOM"/></font></div></td> 
	  <td width="3%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgQty"/><BR><jsp:getProperty name="rPH" property="pgKPC"/></font></div></td>   	
	  <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgThAccShpQty"/></font></div></td>  
	  <td width="2%" nowrap><div align="center"><font color="#006666"  >&nbsp;</font></div></td> 	     
	  <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgPono"/></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgPono"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgUOM"/></font></div></td>	  
	  <td width="5%" nowrap><div align="center"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgAvailableShip"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td>  
	   
	</tr>

	<% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
	{ 
	    // By Kerwin 針對是否達預計出貨日的訂單未轉請採購單,決定可供使用者手動呼叫轉單程式_起
		int schShipDateJG = rsTC.getInt("SSHIP_DATE_JG");
		String schShipDate =rsTC.getString("SCHEDULE_SHIP_DATE"); // 取預計出貨日
		String documentID = ""; // 取出 Workflow ItemKey
		String poNum = "";
		
		String errMOOwnerMail = "";
		
		// By Kerwin 針對是否達預計出貨日的訂單未轉請採購單,決定可供使用者手動呼叫轉單程式_迄
		
		// By Kerwin Check if 1152 DropShip MO warehouse Error Notify function_起
		if (rsTC.getString("WAREHOUSE_H").equals("44") && rsTC.getString("WAREHOUSE_D").equals("44"))
		{}
		else
		{ // 不為 I8 倉
		
		     
		     Statement stateUser=con.createStatement();
             ResultSet rsUser=stateUser.executeQuery("select USERMAIL from FND_USER a, ORADDMAN.WSUSER b "+
			                                         " where upper(a.USER_NAME) = upper(b.USERNAME) and a.USER_ID = '"+rsTC.getInt("CREATED_BY")+"' ");
             if (rsUser.next())
	         {           
			   errMOOwnerMail = rsUser.getString("USERMAIL");		   	  
	         }
             rsUser.close();   // CLOSED FIND PO_UOM
             stateUser.close();
			 		 
	
		} // End of if (!rsTC.getInt("WAREHOUSE_H").equals("44") && !rsTC.getInt("WAREHOUSE_D").equals("44"))
		// By Kerwin Check if 1152 DropShip MO warehouse Error Notify function_迄
        
        String moLineId=rsTC.getString("LINE_ID");
        String moLocationId=rsTC.getString("LINE_LOCATION_ID");
//抓取對應MO的PO資訊
        String sqlpo =  " select distinct POH.SEGMENT1 PO_NUM, POH.PO_HEADER_ID, PLL.LINE_LOCATION_ID, ODS.LINE_ID, ODS.PO_LINE_ID, "+
						"                PRL.QUANTITY as PO_QTY,PLL.QUANTITY_RECEIVED, "+
						"				 (PRL.QUANTITY) - NVL (PLL.QUANTITY_RECEIVED,0) UNDELIVERY_QTY, "+
						"				 (PLL.QUANTITY) - NVL (PLL.QUANTITY_RECEIVED,0)-sum(nvl(D.RCVQTY,0)) as ALLOW_QTY "+						
						" from OE_DROP_SHIP_SOURCES ODS,PO_HEADERS_ALL POH,PO_LINE_LOCATIONS_ALL PLL,TSC_DROPSHIP_SHIP_LINE D ,PO_REQUISITION_LINES_ALL PRL  "+
						" where ODS.PO_HEADER_ID = POH.PO_HEADER_ID and pll.line_location_id=d.PO_LOCATION_LINE_ID(+) "+
						"      AND ODS.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID AND POH.PO_HEADER_ID = PLL.PO_HEADER_ID "+
						"      AND PLL.CLOSED_CODE != 'CLOSED' AND POH.AUTHORIZATION_STATUS in ('APPROVED')  "+
						"	   AND nvl(D.LINE_STATUS(+),'OPEN') ='OPEN' "+
						"      AND ODS.LINE_ID= "+moLineId+" and pll.LINE_LOCATION_ID="+moLocationId +
                        "      AND PRL.REQUISITION_LINE_ID  = ODS.REQUISITION_LINE_ID "+  //liling 20081022
						" group by POH.SEGMENT1, POH.PO_HEADER_ID, PLL.LINE_LOCATION_ID, ODS.LINE_ID, ODS.PO_LINE_ID,PRL.QUANTITY , "+
						"         PLL.QUANTITY_RECEIVED,(PLL.QUANTITY) - NVL (PLL.QUANTITY_RECEIVED,0) ";							
         //out.println("<BR>sqlInvNo="+sqlpo);
         Statement statepo=con.createStatement();
         ResultSet rspo=statepo.executeQuery(sqlpo);
		 //out.println("sSqlPO="+sqlpo); 
		 if (rspo.next())
		 {
		    poNum     		= rspo.getString("PO_NUM");
			poHeaderId      = rspo.getString("PO_HEADER_ID");
			lineLocationId  = rspo.getString("LINE_LOCATION_ID");
			poLineId 		= rspo.getString("PO_LINE_ID");
			undelivery_Qty	= rspo.getString("UNDELIVERY_QTY");
			allow_Qty 		= rspo.getString("ALLOW_Qty");			
			//out.println("ALLOW_Qty="+rspo.getDouble("ALLOW_Qty")+"<BR>");
			//out.println("rcvQty="+rcvQty+"<BR>");			
		  }	  		   
     rspo.close();   // CLOSED FIND PO_UOM
     statepo.close();	
	 
	     // Add By Kerwin For Drip down Available Information_2007/08/24
		 // 2007/08/24  ToolTip_Start
		   
		     String detailHdr = null;
		     String detailLot = null;
			 int poCount = 0;
			 String PO_NO = "";
			 String poStatus="";
			 String poHeaderID ="";
			 
		     Statement stateCI=con.createStatement();
		     String sqlCI = "select b.SEGMENT1 as PR_NO, b.AUTHORIZATION_STATUS as PR_STATUS, "+
			                "       c.SEGMENT1 as PO_NO, c.AUTHORIZATION_STATUS as PO_STATUS, "+
							"       c.PO_HEADER_ID "+
                            "  from OE_DROP_SHIP_SOURCES a, PO_REQUISITION_HEADERS_ALL b, PO_HEADERS_ALL c  ";			                      														  
			 String whereCI = "where a.REQUISITION_HEADER_ID = b.REQUISITION_HEADER_ID and a.PO_HEADER_ID = c.PO_HEADER_ID "+
			                  "  and a.HEADER_ID = '"+rsTC.getString("HEADER_ID")+"' and a.LINE_ID = '"+rsTC.getString("LINE_ID")+"' "+
							  "     ";
			 sqlCI = sqlCI + whereCI;
			 detailHdr = "<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
			 //detailHdr = "<table border=1>";
			 detailLot = "";
		     ResultSet rsCI=stateCI.executeQuery(sqlCI);
			 if (rsCI.next())
			 {
			    PO_NO = rsCI.getString("PO_NO");
				poHeaderID = rsCI.getString("PO_HEADER_ID");
				poStatus=rsCI.getString("PO_STATUS");
			    detailLot = detailLot +"<tr><td>"+rsCI.getString("PR_NO")+"</td><td><div align=right>"+rsCI.getString("PR_STATUS")+"</div></td><td><div align=right>"+rsCI.getString("PO_NO")+"</div></td><td><div align=right>"+rsCI.getString("PO_STATUS")+"</div></td></tr>";  // PR and PO Approve Status
				poCount++;
			 }
			 rsCI.close();
			 stateCI.close();
			 
			 detailLot = detailLot + "</table>";				   
			 detailHdr = detailHdr + detailLot;
		  
		// 2007/08/24 ToolTip_End
	 
	 String sqlDoc =    " select DISTINCT substr(CONTEXT, 1, instr(CONTEXT, ':') - 1) ||':'|| substr(substr(wfn.CONTEXT, instr(wfn.CONTEXT, ':') + 1,length(wfn.CONTEXT) - 2),1, instr(substr(wfn.CONTEXT, instr(wfn.CONTEXT, ':') + 1,length(wfn.CONTEXT) - 2), ':') - 1) as DOCUMENT_ID "+  // By Kerwin for get PO Action History
						" from OE_DROP_SHIP_SOURCES ODS,PO_HEADERS_ALL POH,PO_LINE_LOCATIONS_ALL PLL,TSC_DROPSHIP_SHIP_LINE D,  "+
						"      WF_NOTIFICATIONS wfn "+
						" where ODS.PO_HEADER_ID = POH.PO_HEADER_ID and pll.line_location_id=d.PO_LOCATION_LINE_ID(+) "+
						"      AND ODS.LINE_LOCATION_ID = PLL.LINE_LOCATION_ID AND POH.PO_HEADER_ID = PLL.PO_HEADER_ID "+
						"      AND PLL.CLOSED_CODE != 'CLOSED' AND nvl(D.LINE_STATUS(+),'OPEN') ='OPEN' "+
						"      and POH.WF_ITEM_KEY = substr(substr(wfn.CONTEXT, instr(wfn.CONTEXT, ':') + 1,length(wfn.CONTEXT) - 2),1, instr(substr(wfn.CONTEXT, instr(wfn.CONTEXT, ':') + 1,length(wfn.CONTEXT) - 2), ':') - 1) "+
						"      and wfn.MESSAGE_TYPE = POH.WF_ITEM_TYPE "+
						"      AND ODS.LINE_ID= "+moLineId+" and pll.LINE_LOCATION_ID="+moLocationId + "";		
	 //out.println("<BR>sqlDoc="+sqlDoc);				
	 Statement stateDoc=con.createStatement();
     ResultSet rsDoc=stateDoc.executeQuery(sqlDoc);
     if (rsDoc.next())
	 {
	     documentID = rsDoc.getString("DOCUMENT_ID"); //By Kerwin for get PO Action History
		 //documentID = rsDoc.getString("PO_HEADER_ID"); //By Kerwin for get PO Action History
	 } else {
	            Statement stateDoc2=con.createStatement();
                ResultSet rsDoc2=stateDoc2.executeQuery("select WF_ITEM_KEY from PO_HEADERS_ALL where to_char(PO_HEADER_ID) = '"+poHeaderId+"' ");
				if (rsDoc2.next())  documentID = "POAPPRV:"+rsDoc2.getString(1);
				rsDoc2.close();
				stateDoc2.close();   
	        }
     rsDoc.close();   // CLOSED FIND PO_UOM
     stateDoc.close();
/***********判斷MO數量與PO數量,是否相等,否則黃色標示  */	
//取PO的UOM
	String poUom="";
	String sqla=" select POL.UNIT_MEAS_LOOKUP_CODE as PO_UOM from po_lines_all pol , po_line_locations_all pll "+
                " where pol.po_line_id=pll.po_line_id "+
                "     and pll.po_line_id= "+poLineId ;
				
	    Statement statementsqla=con.createStatement();
        ResultSet rssqla=statementsqla.executeQuery(sqla);
        if (rssqla.next())
         {  poUom = rssqla.getString("PO_UOM");}
        //rssqla.close();
        //statementsqla.close();
		//out.println("sqla="+sqla) ;
		//out.println("poUom="+poUom) ;
		

    double unshipQty = Double.parseDouble(rsTC.getString("UNSHIP_QTY")) ; 
 	DecimalFormat df = new DecimalFormat("0");

//判斷item_uom若為"KPC",則轉換成PCE數量=>*1000	
		if (rsTC.getString("UOM") ==poUom || rsTC.getString("UOM").equals(poUom)) 
		  { base=1; }
		if (rsTC.getString("UOM").equals("PCE") && poUom.equals("KPC")) 
		  { base=1000; }	  
		if (rsTC.getString("UOM").equals("KPC") && poUom.equals("PCE")) 
		  { base = 0.001;  }	
//因為欄位值null,填'0'		 undelivery_Qty  
//		if (rspo.getString("UNDELIVERY_QTY") == null || rspo.getString("UNDELIVERY_QTY").equals("") || rspo.getString("UNDELIVERY_QTY").equals("null"))
		if (undelivery_Qty == null || undelivery_Qty.equals("") || undelivery_Qty.equals("null"))
		  
		   {  undeliveryQty = 0; }
		else 
		   {  
		   //double a  = 15.15 ;
		   //double b  = 1000;
		   //a=a *b;
		   //out.println("gogo"+a);
		    
		   undeliveryQty = Double.parseDouble(undelivery_Qty)*base;	
		   
		   
		   //DecimalFormat df = new DecimalFormat("0");
              //double showNum = 27.04;
		//double aaa =df.format(undeliveryQty);
         // out.println("aaa"+aaa);
		//out.println("unshipQty="+df.format(unshipQty)+"zz");
		//out.println("undeliveryQty="+df.format(undeliveryQty)+"zz");
		//if(df.format(unshipQty).equals(df.format(undeliveryQty))  ){
		//out.println("asdf");
		//}
 //out.println("asdf");
		      allowQty = Double.parseDouble(allow_Qty)*base;	
			  thTime_allowQty = thTime_allowQty*base;	
		    }
 //out.println("unshipQty="+unshipQty);
 //out.println("undeliveryQty="+undeliveryQty);
//若salesOrder數量!=PO未到貨數量,則用黃色警示
      if ( unshipQty  ==  undeliveryQty ||df.format(unshipQty).equals(df.format(undeliveryQty)) )
	   {	 
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCFFCC";
	     }
	    else{
	       colorStr = "CCFFFF"; }
		}
	  else 
	   { 
	     if (poStatus.equals("IN PROCESS"))
		 {
		    colorStr = "#99CCFF";
		 } else {
	              colorStr = "#FFFF00";
	              noEqual="Y";  
			    }
       }
/***********判斷MO數量與PO數量,是否相等,否則黃色標示  END */	 
   
	 rcv_Qty = request.getParameter("RCV_QTY"+Integer.toString(rs1__index+1));

         String checkedON = "";
         String checkedQty ="";
         double checkedQtya = 0;


         if (rcv_Qty == null || rcv_Qty.equals("") || rcv_Qty.equals("null"))
          {
               checkedON="";
			  //checkedQty=""; //20060425 disable
              //checkedQtya=Double.parseDouble(allow_Qty)-thTime_allowQty; //20060425 update 欄位先帶出可出數量
			  checkedQty = allow_Qty;
			//out.println("checkedQty="+checkedQty);
          }
         else
          {
              checkedON="CHECKED";
              checkedQty = request.getParameter("RCV_QTY"+Integer.toString(rs1__index+1));
          }
		  
/**************************************///依併單條件判斷能否 check box       
		 customerNo     = rsTC.getString("CUSTOMERNO");
		 ShipToOrg      = rsTC.getString("SHIPTOORG");
		 shipMethod     = rsTC.getString("SHIPMETHOD");
		 fobPoint       = rsTC.getString("FOBPOINT");
		 paymentTerm    = rsTC.getString("PAYTERM");
	 // if ( countInv!=null && ShipToOrg!=null && shipMethod!=null && fobPoint!=null && paymentTerm!=null && customerNo!=null && ncustomerNo!=null && nShipToOrg!=null && nshipMethod!=null && nfobPoint!=null && npaymentTerm!=null) 
	 // {} 
	  /*
	   if ((countInv!="0" && !countInv.equals("0")) && ((!customerNo.equals(ncustomerNo)) ||
	  												   (!ShipToOrg.equals(nShipToOrg))	 ||
													 //  (!shipMethod.equals(nshipMethod)) ||
													   (!fobPoint.equals(nfobPoint))     ||
													   (!paymentTerm.equals(npaymentTerm)) ) )							   
	   */
		if ((countInv!="0" && !countInv.equals("0")) && (!salesOrderCustNo.equals(oriInvCustNo)))
 		{ //out.println("salesOrderCustNo="+salesOrderCustNo);
		  //out.println(" oriInvCustNo="+oriInvCustNo);
		  //out.println(" countInv="+countInv);
		  // out.print("Set Combine to N");  
		  chkCombine="N";
		}
		else if ((countWsh!="0" && !countWsh.equals("0")) && (!salesOrderCustNo.equals(oriInvCustNo)))
 		{ //out.println("salesOrderCustNo="+salesOrderCustNo);
		  //out.println(" oriInvCustNo="+oriInvCustNo);
		  //out.println(" countInv="+countInv);
		  // out.print("Set Combine to N");  
		  chkCombine="N";
		}						
		else { chkCombine="Y";  }			  
		//out.print("countInv="+countInv+"customerNo="+paymentTerm+"npaymentTerm="+npaymentTerm);   
  
    %>
   <font face="Arial, Helvetica, sans-serif"> </font><tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#99CC99" width="2%"><div align="center"><font color="#006666"   face="Arial, Helvetica, sans-serif"><a name='#<%//=rsTC.getString("ORDER_NUM")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td width="1%"> <div align="center"><font color="#000000"   face="Arial, Helvetica, sans-serif">
	  <% if (chkCombine=="Y"|| chkCombine.equals("Y")) { %>	  
	       <input type="hidden" name="SELECTFLAG<%=Integer.toString(rs1__index+1)%>" <%=checkedON%> >  </font></div>
	  <%  } else out.println("&nbsp;"); %>
	  <a href='javaScript:POActionHistoryQuery("<%=documentID%>","<%=salesOrderNo%>","<%=rsTC.getString("LINE_NUM")%>", "<%=schShipDate%>")'><img src="../image/point_arrow.gif" border="0"></a>			   
	  </td>	     		
      <%
	    //Tool Tip
	  %>
      <td width="5%" nowrap><div align="center" class="style4"> 
	   <%
	     if (poCount>0)
		 { // 表示以轉出請採購單
	   %>
	      <a onmouseover='this.T_STICKY=true;this.T_WIDTH=350;this.T_CLICKCLOSE=false;this.T_BGCOLOR="#CCFF66";this.T_SHADOWCOLOR="#FFFF99";this.T_TITLE="PR No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PR Approve Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PO No&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PO Approve Status";this.T_OFFSETY=-32;return escape("<%=detailHdr%>")'>
	      <%=rsTC.getString("ORDER_NUM")%>
		  </a>
	   <%
	     } else { // 若無找到產生的PO,且MO 倉別不為I8
		          if ( !(rsTC.getString("WAREHOUSE_H").equals("44") && rsTC.getString("WAREHOUSE_D").equals("44")))
				  {
				      %>
	                   <a onmouseover='this.T_STICKY=true;this.T_WIDTH=250;this.T_CLICKCLOSE=false;this.T_BGCOLOR="#CCFF66";this.T_SHADOWCOLOR="#FFFF99";this.T_OFFSETY=-32;return escape("<%="Error Warehouse...<BR>Click button for E-Mail notify MO Created owner"%>")'>
	                    <%=rsTC.getString("ORDER_NUM")%>
		               </a>
					   <input type='button' name='NOTIFYMO' value='Notify' onClick="setSubmitNOTIFYMO(<%=rsTC.getString("ORDER_NUM")%>,<%="WHS"%>,"<%=rsTC.getString("LINE_NUM")%>")">
	                  <%
				  } else {
				           out.println(rsTC.getString("ORDER_NUM"));
				         }
		        }
	   %>
		  </div>
	  </td>
	  <td width="2%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("LINE_NUM")%></font></div></td>
	  <td width="10%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td width="10%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("ITEM_DESC")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("ORDERED_ITEM")%></font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("LINE_ID")%></font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("UOM")%></font></div></td>
      <td width="3%" nowrap><div align="center"><font color="#CC3366">
      <%   if(chkCombine=="Y"|| chkCombine.equals("Y")) { %>  		  
	    <input type="text" size="8" name="RCV_QTY<%=Integer.toString(rs1__index+1)%>" value='<%=checkedQty%>' ></font></div>
       <%  } else out.println("&nbsp;"); %>		
	  </td>  
	  <td width="5%" nowrap><div align="center"><font color="#CC3366">
	        <%//=thTime_allowQty
			  double accThQty = 0;
			  if (salesOrderNo!=null && lineId!=null && rcvQty!=null)
              {  // 若設定該項次才計算剩餘數量
			       
			       // 取前次陣列內本次累出數量_起
			       String p[][]=shpArray2DTemporaryBean.getArray2DContent();//重新取得陣列內容				  
			       for (int i=0;i<p.length;i++)			   
			       {  //out.println("p[i][3] ="+p[i][3]);
				     
				      if (p[i][3]!=null && !p[i][3].equals("")) // 數量不為零
					  { 
					    if (p[i][1].equals(rsTC.getString("ORDER_NUM")) && p[i][2].equals(rsTC.getString("LINE_ID")))
						{
						  accThQty = accThQty + Double.parseDouble(p[i][3]); 
						}  
					  }	
					  //out.println("accThQty ="+accThQty);
				   } // End of for
			       // 取前次陣列內本次累出數量_迄
			       // if (rcvQty!=null) thTime_allowQty = Float.parseFloat(allow_Qty)-accThQty;	//20060420
				   //out.println(allow_Qty);out.println(accThQty);
			       if (rcvQty!=null) thTime_allowQty = Double.parseDouble(allow_Qty)-accThQty;	
			       else thTime_allowQty = Double.parseDouble(allow_Qty);
			  }  else {// 若不是按下 Set鍵,仍計算累出數量
			            //thTime_allowQty = Double.parseDouble(allow_Qty);
					    // 取前次陣列內本次累出數量_起
			            String p[][]=shpArray2DTemporaryBean.getArray2DContent();//重新取得陣列內容		
						if (p!=null)		
						{  
			             for (int i=0;i<p.length;i++)			   
			             {  //out.println("p[i][3] ="+p[i][3]);
				     
				          if (p[i][3]!=null && !p[i][3].equals("")) // 數量不為零
					      { 
					       if (p[i][1].equals(rsTC.getString("ORDER_NUM")) && p[i][2].equals(rsTC.getString("LINE_ID")))
						   {
						     accThQty = accThQty + Double.parseDouble(p[i][3]); 
						   }  
					      }	
					      //out.println("accThQty ="+accThQty);
				         } // End of for
						} //End of if (p!=null)
			            // 取前次陣列內本次累出數量_迄
						if (allow_Qty!=null)
						{
						  thTime_allowQty = Double.parseDouble(allow_Qty)-accThQty;
						 }
			          } //End of else
			//out.println(thTime_allowQty+"<BR>");
			out.println(accThQty+"<BR>");
			%></font></div>
	  </td> 
	  <td width="2%" nowrap><div align="center"><font color="#CC3366">
	  
	  <%   if(chkCombine=="Y"|| chkCombine.equals("Y")) { %>  	  
	   <INPUT TYPE="button" value="set" NAME='CRCVQTY<%=Integer.toString(rs1__index+1)%>' onClick='setqtyChk("<%=rsTC.getString("ORDER_NUM")%>","<%=rsTC.getString("LINE_ID")%>","<%=Integer.toString(rs1__index+1)%>","<%=unshipQty%>","<%=undeliveryQty%>","<%=allowQty%>","<%=allow_Qty%>","<%=thTime_allowQty%>")'> </font></div>
	  <%   }  else out.println("&nbsp;");%>		   
	  </td>  	  
	  <td width="5%" nowrap><div align="center"><font color="#CC3366"><%=rsTC.getString("UNSHIP_QTY")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#CC3366">
	     <%//=poNum 2007/08/30 By Kerwin
		    if (PO_NO==null || PO_NO.equals("") || PO_NO.equals("null"))
			{  //out.println("poNum="+poNum);
			   if (noEqual.equals("Y") && schShipDateJG<=0 && schShipDate!=null)
	           {  // 若顯示尚未結轉PR-PO , 則允許使用者手動呼叫轉請採購程式
			     if (rsTC.getString("WAREHOUSE_H").equals("44") && rsTC.getString("WAREHOUSE_D").equals("44"))
				 {
			       %>
			       <input type="button" name="CRDSPO" value="執行轉請採購程式" onClick="CREATEPO()">
			       <% 
				 }
			   } else if (schShipDate==null || schShipDate.equals(""))
			          {
					     out.println("Sales not enter SSD");
					  }
			          else {
			                 out.println("Not Available for SSD");
			               }
			} else if (poStatus.equals("IN PROCESS")) {
			                         %>
			                            <input type="button" name="ASKPOAP" value="通知PO核准人員" onClick='POAPPROVER("<%=poHeaderID%>","<%=PO_NO%>")'>
			                         <% 
			
			             } else			
			                   {
			                    out.println(PO_NO);
			                   }		
		 %></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#CC3366"><%=undelivery_Qty%></font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#CC3366"><%=poUom%></font></div></td>	  	  
	  <td width="5%" nowrap><div align="center"><font color="#CC3366"><%=allow_Qty%></font></div></td>	                             
    </tr>
    <%
  //out.println(Integer.toString(rs1__index+1));
  //out.println(request.getParameter("RCV_QTY"+Integer.toString(rs1__index+1)));
  //out.println(request.getChecked("SELECTFLAG"+Integer.toString(rs1__index+1)).booleanValue());

  //out.println(request.getParameter("RCV_QTY"));

  rssqla.close();   // CLOSED FIND PO_UOM
  statementsqla.close();	// CLOSED FIND PO_UOM


  rs1__index++;
  rs_hasDataTC = rsTC.next();
  

} 
%>  
    <tr bgcolor="#99CC99"> 
      <td height="23" colspan="17" ><span class="style12"><font color="#006666"  ><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color="#006666"  ><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#000066' face="Arial"><strong><%=CaseCountORG%></strong></font>
	 </span></td>      
    </tr>  
  </table>
  <span class="style12"><!--%每頁筆●顯示筆到筆總共有資料%-->
  </span>
  <div align="center"> <span class="style12"><font color="#993366"  >
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong><% } /* end RpRepair_isEmpty */ %> </font> </span></div>
	
<span class="style12"><!--選擇全部,存檔 --></span>
<table>

 </table>
<span class="style12"><input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input type="hidden" size="1" name="CUSTOMERAROVERDUE" value="<%=custAROverdue%>">
<input type="hidden"   name="SHIPCOUNTRY" value="<%=shipCountry%>">
<input type="hidden" size="1" name="AROVERDUEDESC" value="<%=%>">
<input type="hidden" size="1" name="HEADERID" value="<%=headerId%>">
<input type="hidden" size="1" name="LINEID" value="<%=lineId%>">
<input type="hidden" size="5" name="ROWCNT" value="<%=CaseCountORG%>">
<input type="hidden" size="5" name="NOEQUAL" value="<%=noEqual%>">
<input type="hidden" size="5" name="SYSTEMDATE" value="<%=systemDate%>">
<input name="ISMODELSELECTED" type="HIDDEN" value="<%=isModelSelected%>" size=2>  <!--做為判斷是否已選取新增機型明細-->
</span>

<span style="color: #CC0066"><iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</span>

<table >
 <tr bgcolor="#CCFFCC">
  <td colspan="3">
     <input name="button2" tabindex='19' type=button onClick="this.value=checkAll(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
     <font color="#336699"  >-----<jsp:getProperty name="rPH" property="pgLDetailSave"/>-----------------------------------------------</font>
  </td>
 </tr>
 <tr bgcolor="#CCFFCC">
  <td colspan="3"> 
   <%
      int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=shpArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		//out.println(a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");	  
		        div1=a.length;
				div2=a[0].length;				
	        	shpArray2DTemporaryBean.setFieldName("ADDITEMS");
				//shpArray2DTemporaryBean.setSelection(a[0][0]);						
				//out.println(arrayRFQDocumentInputBean.getArray2DString());
				//out.println(arrayRFQDocumentInputBean.getArray2D2KeyString());  // 用Item 及Item Description 作為Key 的Method		
				out.println(shpArray2DTemporaryBean.getArray2DShipString());  // 用Item 及Item Description 作為Key 的Method
				isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y" 	
						
								
						  		 				
		 }	//enf of a!=null if	
		
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }

  %>
  </td>
 </tr> 
 <tr bgcolor="#CCFFCC">
   <td colspan="3">
		  <INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmit4("../jsp/TSSHPInvoiceAdd.jsp?INSERT=Y")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
           <% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) 
			{
		   %>
		   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='#336699' size='2'>------<jsp:getProperty name="rPH" property="pgLCheckDelete"/>-----------------------------------------------</font>
		  
		   <%
		    }
		   %>
   </td>
 </tr>
 <tr>  

	  <td width="20%" bgcolor="#FFCCCC"><div align="left" class="style2">
		   <span class="style12"><font><jsp:getProperty name="rPH" property="pgChoice"/><jsp:getProperty name="rPH" property="pgShipDate"/> </font></span></div>
	  </td> 
	  <td width="20%" bgcolor="#FFCCCC">	  
		  <span class="style12">
   	     <input type="text" size="10" name="SHIPDATE" value="<%=shipDate%>" <%if (cntInvNo>0) out.println("readonly");%> > 		 
		  <%
		    if (cntInvNo>0)
			{
			}
			else
			{
		  %>
		  <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SHIPDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> </span>
		  <%
		    }
		  %>
	  </td>	

	<td bgcolor="#FFCCCC">
	   <div align="left"><span class="style12"><input name="SAVE" type="button"  onClick="setSubmit3('../jsp/TSSHPInvoiceSave.jsp')" value='<jsp:getProperty name="rPH" property="pgSave"/>'></span></div>
	</td>
 </tr>
</table>

</FORM>
<span class="style12"><BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</span>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
<%

  rsTC.close();
  statementTC.close();
  //rsAct.close();
  //stateAct.close();  // 結束Statement Con
  //ConnRpRepair.close();
%>
