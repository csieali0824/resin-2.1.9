<!-- 20110127 liling 加入該item lot_no 是否曾退貨判斷 returnFlag -->
<!-- 20150205 Peggy,晶片種類,晶片尺吋,鍍層加入inactive_date is null or inactive_date > trunc(sysdate)條件-->
<!-- 20181005 Peggy,電性良品率 & 型號良率預設N/A-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean,CheckBoxBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="SalesDRQPageHeaderBean" %-->
<!--jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/-->
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrayIQCTempBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") gfPop.fHideCal();	
}

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
function redirectEntryForm(URL)
{
	document.MYFORM.action=URL;
  	document.MYFORM.submit();
}

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
	} 
	else 
	{
		document.MYFORM.action=URL;
        document.MYFORM.submit();
	}	
} 

function setSubmitClass(URL,supplierID, poNumber)
{ 
	var extInfo = "&SUPPLIERID="+supplierID+"&PONUMBER="+poNumber;
    document.MYFORM.action=URL+extInfo;
    document.MYFORM.submit(); 
}

function setSubmitDiceSize(URL)
{ 
    if (document.MYFORM.DICESIZE.value==null || document.MYFORM.DICESIZE.value=="" || document.MYFORM.DICESIZE.value=="--")
	{ 
	//
	}
	document.MYFORM.action=URL+"&DICESIZE="+document.MYFORM.DICESIZE.value;
    document.MYFORM.submit(); 
}

function setSubmitAdd(URL,xINTERFACEID,xRECEIPTNUMBER,xITEMNO,xGRAINQTY,xPRODYIELD,xAUTOORNO,xSUPLOTNO,xINSPREQ,xINDEX, xLOTCTRL,xTOTALYIELD,xRTNFLAG,xCOMMENT)
{   
	formAUTHORNO = "document.MYFORM.AUTHORNO"+xINDEX+".focus()";
  	formAUTHORNO_Write = "document.MYFORM.AUTHORNO"+xINDEX+".value";
  	xAUTHORNO = eval(formAUTHORNO_Write);  // 把值取得給java script 變數
	
  	formSUPLOTNO = "document.MYFORM.SUPLOTNO"+xINDEX+".focus()";
  	formSUPLOTNO_Write = "document.MYFORM.SUPLOTNO"+xINDEX+".value";
  	xSUPLOTNO = eval(formSUPLOTNO_Write);  // 把值取得給java script 變數    

    formCOMMENT = "document.MYFORM.COMMENT"+xINDEX+".focus()";
  	formCOMMENT_Write = "document.MYFORM.COMMENT"+xINDEX+".value";
  	xCOMMENT = eval(formCOMMENT_Write);  // 把值取得給java script 變數		 

  
  	formGRAINQTY = "document.MYFORM.GRAINQTY"+xINDEX+".focus()";
  	formGRAINQTY_Write = "document.MYFORM.GRAINQTY"+xINDEX+".value";
  	xGRAINQTY = eval(formGRAINQTY_Write);  // 把值取得給java script 變數 

  	formPRODYIELD = "document.MYFORM.PRODYIELD"+xINDEX+".focus()";
  	formPRODYIELD_Write = "document.MYFORM.PRODYIELD"+xINDEX+".value";
  	xPRODYIELD = eval(formPRODYIELD_Write);  // 把值取得給java script 變數 

  	formTOTALYIELD = "document.MYFORM.TOTALYIELD"+xINDEX+".focus()";
  	formTOTALYIELD_Write = "document.MYFORM.TOTALYIELD"+xINDEX+".value";
  	xTOTALYIELD = eval(formTOTALYIELD_Write);  // 把值取得給java script 變數 
	


  	if ( (xSUPLOTNO=="" || xSUPLOTNO=="null") && (xLOTCTRL=="Y")) // 若批號空白未填入,且為批號控管項目,則警告
  	{
    	alert("依批號控管原則,此料號為控管項目,請如實輸入\n否則將導致收料入庫異常!!!"); 
		return false;
  	}

  	if (xRTNFLAG=="Y") // 若
  	{
    	alert(xSUPLOTNO+" 此批號有退貨紀錄,請留意!!!"); 
  	}
  
  	formINSPREQ = "document.MYFORM.INSPREQ"+xINDEX+".focus()";
  	formINSPREQ_Write = "document.MYFORM.INSPREQ"+xINDEX+".value";
  	xINSPREQ = eval(formINSPREQ_Write);  // 把值取得給java script 變數
  
  	formINTERFACETRANSID = "document.MYFORM.INTERFACETRANSID"+xINDEX+".focus()";
  	formINTERFACETRANSID_Write = "document.MYFORM.INTERFACETRANSID"+xINDEX+".value";
  	xINTERFACETRANSID = eval(formINTERFACETRANSID_Write);  // 把值取得給java script 變數 
  
  	formRECNO = "document.MYFORM.RECNO"+xINDEX+".focus()";
  	formRECNO_Write = "document.MYFORM.RECNO"+xINDEX+".value";
  	xRECNO = eval(formRECNO_Write);  // 把值取得給java script 變數 
  
  	formINVITEMNO = "document.MYFORM.INVITEMNO"+xINDEX+".focus()";
  	formINVITEMNO_Write = "document.MYFORM.INVITEMNO"+xINDEX+".value";
  	xINVITEMNO = eval(formINVITEMNO_Write);  // 把值取得給java script 變數
  
  	formINVITEMDESC = "document.MYFORM.INVITEMDESC"+xINDEX+".focus()";
  	formINVITEMDESC_Write = "document.MYFORM.INVITEMDESC"+xINDEX+".value";
  	xINVITEMDESC = eval(formINVITEMDESC_Write);  // 把值取得給java script 變數 
  
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

  	if ( document.MYFORM.CLASSID.value=="01" &&  (xGRAINQTY==null || xGRAINQTY==""))
  	{
    	alert("晶片/晶粒檢驗需輸入晶粒數量!");	 
	 	formGRAINQTY ="document.MYFORM.GRAINQTY"+xINDEX+".focus()";
	 	eval(formGRAINQTY);	 
	 	return(false);
  	}

  	if ( (xPRODYIELD==null || xPRODYIELD=="")  ) //若判斷是否晶片/粒為空值,則要求填入  //20091118 LILING ADD
  	{   
    	alert("請輸入晶片/粒良率!!");	 	
	 	formPRODYIELD ="document.MYFORM.INSPREQ"+xINDEX+".focus()";
	 	eval(formPRODYIELD);
	 	return(false);
  	}

  	if ( (xTOTALYIELD==null || xTOTALYIELD=="")  ) //若判斷是否電性良率為空值,則要求填入  //20091118 LILING ADD
  	{   
    	alert("請輸入電信良率!!");	 	
	 	formTOTALYIELD ="document.MYFORM.INSPREQ"+xINDEX+".focus()";
	 	eval(formTOTALYIELD);
	 	return(false);
  	}
	
  	// -- document.MYFORM.action="../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INTERFACETRANSID"+xINDEX+"="+xINTERFACETRANSID+"&RECNO"+xINDEX+"="+xRECNO+"&INVITEMNO"+xINDEX+"="+xINVITEMNO;
  	document.MYFORM.action="../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INTERFACEID="+xINTERFACEID+"&RECEIPTNUMBER="+xRECEIPTNUMBER+"&ITEMNO="+xITEMNO+"&AUTHORNO="+xAUTHORNO+"&SUPLOTNO="+xSUPLOTNO+"&INSPREQ="+xINSPREQ+"&GRAINQTY="+xGRAINQTY+"&PRODYIELD="+xPRODYIELD+"&TOTALYIELD="+xTOTALYIELD+"&COMMENT="+xCOMMENT;
  	document.MYFORM.submit(); 
}

function setSubmitDel(URL)
{ 
	document.MYFORM.action=URL;
    document.MYFORM.submit(); 
}

function setSubmitSave(URL)
{ 
	if (document.MYFORM.CLASSID.value=="" || document.MYFORM.CLASSID.value=="--")
   	{ 
    	alert("請選擇檢驗類別...");
	 	document.MYFORM.CLASSID.focus();
     	return false;
   	}
   
  	if (document.MYFORM.CLASSID.value=="01") // 若檢驗類型為晶片晶粒類,則要求必填欄位
  	{
    	var chkWFTYPEID = "false";
    	for (i=0;i<document.MYFORM.WFTYPEID.length;i++)
    	{
	  		if (document.MYFORM.WFTYPEID[i].checked==true)
	  		{ 
	   			chkWFTYPEID = "true";
	  		} 
     	}   // end of for   
   		if (chkWFTYPEID=="false")
   		{ 
     		alert("請選擇一種晶片種類...");
     		return false;
   		}
   
    	var chkWFSIZEID = "false";
    	for (i=0;i<document.MYFORM.WFSIZEID.length;i++)
    	{
	  		if (document.MYFORM.WFSIZEID[i].checked==true)
	  		{
	   			chkWFSIZEID = "true";
	  		} 
   		}   // end of for 
   		if (chkWFSIZEID=="false")
   		{ 
     		alert("請選擇一種晶片尺寸...");
     		return false;
   		}
   
    	var chkWFPLATID = "false";
    	for (i=0;i<document.MYFORM.WFPLATID.length;i++)
    	{
	  		if (document.MYFORM.WFPLATID[i].checked==true)
	  		{
	   			chkWFPLATID = "true";
	  		} 
   		}   // end of for 
   		if (chkWFPLATID=="false")
   		{ 
     		alert("請選擇一種鍍層種類...");
     		return false;
   		}
   		
		if (document.MYFORM.WFTHICK.value=="" || document.MYFORM.WFTHICK.value=="--")
   		{ 
     		alert("請輸入晶片厚度...");
	 		document.MYFORM.WFTHICK.focus();
     		return false;
   		}

   		if (document.MYFORM.DICESIZE.value=="" || document.MYFORM.DICESIZE.value=="--")
   		{ 
     		alert("請輸入晶粒尺寸...");
	 		document.MYFORM.DICESIZE.focus();
     		return false;
   		}
   
   		if (document.MYFORM.WFRESIST.value==null || document.MYFORM.WFRESIST.value=="")
   		{ 
     		alert("請輸入阻值或電壓...");
	 		document.MYFORM.WFRESIST.focus();
     		return false;
   		}
		
		//add by Peggy 20121220
		if (document.MYFORM.HEADERTOTALYIELD.value==null || document.MYFORM.HEADERTOTALYIELD.value=="")
		{
			alert("請輸入電性良品率!!");
			document.MYFORM.HEADERTOTALYIELD.focus();
			return false;
		}

		//add by Peggy 20121220
		if (document.MYFORM.HEADERPRODYIELD.value==null || document.MYFORM.HEADERPRODYIELD.value=="")
		{
			alert("請輸入型號良率!!");
			document.MYFORM.HEADERPRODYIELD.focus();
			return false;
		}
  	}

	//add by Peggy 20121214
	if (document.MYFORM.ACTIONID.value == null || document.MYFORM.ACTIONID.value =="--" || document.MYFORM.ACTIONID.value=="")
	{
		alert("請選擇執行動作!!");
		document.MYFORM.ACTIONID.focus();
		return false;
	}
	else if (document.MYFORM.ACTIONID.value == "005" && (document.MYFORM.NGREASON.value == null || document.MYFORM.NGREASON.value ==""))
	{
		alert("請輸入不良原因!!");
		document.MYFORM.NGREASON.focus();
		return false;
	}
	
   	flag=confirm("是否確認新增IQC檢驗批?");      
   	if (flag==false) return(false);
   	else 
	{
    	document.MYFORM.action=URL;
        document.MYFORM.submit(); 
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

function popMenuMsg(itemDesc)
{
	alert("台半料號:"+itemDesc);
}

function alertBKRule(URL,msl)
{
	alert(msl);
  	document.MYFORM.action=URL;
  	document.MYFORM.submit(); 
}

function setAction(actionCode)
{
	/*
	if (actionCode=="005")
	{
		document.getElementById("tr1").style.visibility="visible";
		document.getElementById("dv1").style.visibility="visible";
		document.MYFORM.SENDMAILOPTION.style.visibility="visible";
	}
	else
	{
		document.getElementById("tr1").style.visibility="hidden";
		document.getElementById("dv1").style.visibility="hidden";
		document.MYFORM.SENDMAILOPTION.style.visibility="hidden";
	}
	*/
}

function setPRODYIELD()
{
	var totlines = document.MYFORM.TOTLINES.value;
	for (var i =1 ; i <= totlines ; i ++)
	{
		document.MYFORM.elements["PRODYIELD"+i].value = document.MYFORM.HEADERPRODYIELD.value;
	}
}

function setTOTALYIELD()
{
	var totlines = document.MYFORM.TOTLINES.value;
	for (var i =1 ; i <= totlines ; i ++)
	{
		document.MYFORM.elements["TOTALYIELD"+i].value = document.MYFORM.HEADERTOTALYIELD.value;
	}
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
int rs1__index = 0;
String sSql = "";
String sSqlCNT = "";
String sSqlCNTITEM = "";
String sWhere = "";
String sWhereGP = "";
String sOrderBy = "";
String havingGrp = "";
int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;
float CASECOUNTORG=0;
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
String marketType=request.getParameter("MARKETTYPE");
if (marketType==null || marketType.equals("--")) marketType="";
String interID=request.getParameter("ID");
if (interID==null) interID = "";
String [] choice=request.getParameterValues("CH");
String choiceArr=request.getParameter("CHOICEARRAY");
if ((choiceArr==null || choiceArr.equals(""))) 
{  
	if (choice!=null)
    { 
		choiceArr = Integer.toString(choice.length);
	} 
	else 
	{
		choiceArr = "1";  // 表示只單點一筆作檢驗
	}
}
String receiptSource=request.getParameter("RECEIPTSOURCE");
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
String grainQuantity=request.getParameter("GRAINQTY"+Integer.toString(rs1__index+1)); 
String wPodYield=request.getParameter("PRODYIELD"+Integer.toString(rs1__index+1)); 
String wTotalYield=request.getParameter("TOTALYIELD"+Integer.toString(rs1__index+1)); 
String authorNumber=request.getParameter("AUTHORNO"+Integer.toString(rs1__index+1)); 
String supLotNumber=request.getParameter("SUPLOTNO"+Integer.toString(rs1__index+1));
String inspReqFlag=request.getParameter("INSPREQ"+Integer.toString(rs1__index+1));
String rCardNo=request.getParameter("RCARDNO"+Integer.toString(rs1__index+1));
String receiptDate=request.getParameter("RECEIPTDATE"+Integer.toString(rs1__index+1));
String commentDesc=request.getParameter("COMMENT"+Integer.toString(rs1__index+1)); //add by Peggy 20121219

String interfaceID=request.getParameter("INTERFACEID");
String receiptNumber=request.getParameter("RECEIPTNUMBER");
String itemNo=request.getParameter("ITEMNO");
String authorNo=request.getParameter("AUTHORNO"); 
String supLotNo=request.getParameter("SUPLOTNO");
String inspReq=request.getParameter("INSPREQ");
String comment=request.getParameter("COMMENT");
String grainQty=request.getParameter("GRAINQTY"); //2007/04/06 liling
String prodYield=request.getParameter("PRODYIELD"); //line 的晶片良率
String totalYield=request.getParameter("TOTALYIELD");
String returnFlag=request.getParameter("RETURNFLAG");  //20110127
if (interfaceID==null || interfaceID.equals("")) interfaceID = "";
if (receiptNumber==null || receiptNumber.equals("")) receiptNumber = "";
if (itemNo==null || itemNo.equals("")) itemNo = "";
if (authorNumber==null || authorNumber.equals("")) authorNumber = "";
if (supLotNumber==null || supLotNumber.equals("")) supLotNumber = "";
if (inspReqFlag==null || inspReqFlag.equals("")) inspReqFlag = "";
if (grainQuantity==null || grainQuantity.equals("")) grainQuantity = "";
if (commentDesc==null || commentDesc.equals("")) commentDesc = "";
String iNo=request.getParameter("INO");
String supplier=request.getParameter("SUPPLIER");
String entry=request.getParameter("ENTRY");         
if (entry!=null && !entry.equals("") )  
{  
	arrayIQCDocumentInputBean.setArray2DString(null); 
} 
  
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
String supSiteName=request.getParameter("SUPSITENAME");   
String roundCard=request.getParameter("ROUNDCARD");
String receptDateStr=request.getParameter("RECEPTDATESTR");
String receptDateEnd=request.getParameter("RECEPTDATEEND");
String poNo=request.getParameter("PONO");
String receiptNo=request.getParameter("RECEIPTNO");
String waferAmp=request.getParameter("WAFERAMP");
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
String NGREASON=request.getParameter("NGREASON");  //add by Peggy 20121218
String vendor=request.getParameter("VENDOR");
String iMatCode=request.getParameter("IMATCODE");
String insertPage=request.getParameter("INSERT");   
String defInsItemDesc = "";
String sqlGlobal = "";
String sWhereGlobal = "";
if (receiptSource==null || receiptSource.equals("--")) 
{  
	if (classID!=null && !classID.equals("06")) // 不為RMA類型
    {  
    	receiptSource="1";
	} 
	else 
	{  
		receiptSource="2";
	}
}
if (statusCode==null || statusCode.equals("")) statusCode="";  
if (receptDateStr==null || receptDateStr.equals("")) receptDateStr=dateBean.getYearMonthDay();
if (receptDateEnd==null || receptDateEnd.equals("")) receptDateEnd=dateBean.getYearMonthDay();
if (inspectDate==null || inspectDate.equals("")) inspectDate=dateBean.getYearMonthDay();
if (classID==null || classID.equals("--")) classID = ""; // 預設給晶片晶粒類別檢驗批單號
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
if (waferAmp==null || waferAmp.equals("")) waferAmp = "";
if (invItem==null || invItem.equals("")) invItem = "";
if (itemDesc==null || itemDesc.equals("")) itemDesc = "";
if (supLotNo==null || supLotNo.equals("")) supLotNo = "";
if (authorNo==null || authorNo.equals("")) authorNo = "";
if (comment==null || comment.equals("")) comment = "";
if (prodName==null) prodName =  "";             // 2007/01/06 以 檢驗物品名稱作為預設值
if (prodModel==null) prodModel = "";
if (sampleQty==null) sampleQty= "";
if (wfThick==null) wfThick = "";
if (wfResist==null) wfResist = "";
if (diceSize==null) diceSize = "";
if (wfPlatID==null) wfPlatID = "";
if (totalYield==null) totalYield = "";
if (prodYield==null) prodYield = "";
if (grainQty==null) grainQty = "";
if (waiveLot==null) waiveLot = "N";
if (remark==null) remark = "";
if (NGREASON==null) NGREASON=""; //add by Peggy 20121218
if (query==null || query.equals("")) query = "Y";
if (returnFlag==null || returnFlag.equals("")) returnFlag="N";
if (returnFlag=="Y" || returnFlag.equals("Y"))  colorStr="#FF6600";
int iDetailRowCount = 0;    
if (organizationId==null) organizationId=""; // 給初值 
String headerProdYield=request.getParameter("HEADERPRODYIELD");  //add by Peggy 20121220
if (headerProdYield==null)
{
	headerProdYield="";
	if (classID==null || classID.equals("") || classID.equals("01"))
	{
		headerProdYield="N/A";
	}
}
String headerTotalYield=request.getParameter("HEADERTOTALYIELD");//add by Peggy 20121220
if (headerTotalYield==null)
{
	headerTotalYield="";
	if (classID==null || classID.equals("") || classID.equals("01"))
	{
		headerTotalYield="N/A";
	}
}
String [] allMonth={iNo,interfaceID,receiptNumber,itemNo,invItemDesc,transactQty,grainQty,prodYield,supSiteID,authorNo,supLotNo,inspReq,totalYield,comment};
// 2006/11/02 取得使用由上一頁選取的Interface Transaction ID作為此次查詢條件_起
String arrIQCSearch[][]=arrayIQCSearchBean.getArray2DContent();//取得待收料陣列內容
String arrIQCTemp[][]=arrayIQCTempBean.getArray2DContent();//取得待收料陣列內容
String tempCal[][]=new String[Integer.parseInt(choiceArr)+1][23]; // 宣告一二維陣列,分別是(列)X(資料欄數+1= 行) //20091118 LILING ADD +2=23
String candidate[][]=new String[Integer.parseInt(choiceArr)+1][20]; // 宣告一二維陣列,分別是(列)X(資料欄數+1= 行) 
String actionID=request.getParameter("ACTIONID"); //add by Peggy 20121213
if (insertPage==null || actionID == null || actionID.equals("")) actionID ="";

String iDCodeGet=request.getParameter("IDCODEGET");
if (iDCodeGet==null || iDCodeGet.equals("")) iDCodeGet = "";
String IDDesc = null;   
int iDCodeGetLength = 0; 
if (choice==null || choice[0].equals(null))    // 2006/11/02 for fileter user don't choosen any item to process // 2004/11/25
{ 
	if (interID!=null && !interID.equals(""))  
	{ 
		iDCodeGet = interID;   // 表示使用者直接點icon 進入	   
	   	for (int m=0;m<arrIQCSearch.length-1;m++) 
	   	{	 
	    	if (iDCodeGet.equals(arrIQCSearch[m][1]))
	    	{
	        	candidate[0][0]=arrIQCSearch[m][0];
				candidate[0][1]=arrIQCSearch[m][1];
				candidate[0][2]=arrIQCSearch[m][2];
				candidate[0][3]=arrIQCSearch[m][3];
				candidate[0][4]=arrIQCSearch[m][4];
				candidate[0][5]=arrIQCSearch[m][5];
				candidate[0][6]=arrIQCSearch[m][6];
				candidate[0][7]=arrIQCSearch[m][7];
				candidate[0][8]=arrIQCSearch[m][8];
				candidate[0][9]=arrIQCSearch[m][9];
				candidate[0][10]=arrIQCSearch[m][10];
				candidate[0][11]=arrIQCSearch[m][11];
				candidate[0][12]=arrIQCSearch[m][12];
				candidate[0][13]=arrIQCSearch[m][13];
				candidate[0][14]=arrIQCSearch[m][14];
				candidate[0][15]=arrIQCSearch[m][15];
				candidate[0][16]=arrIQCSearch[m][16];
				candidate[0][17]=arrIQCSearch[m][17];
				candidate[0][18]=arrIQCSearch[m][18];
				candidate[0][19]=arrIQCSearch[m][19];
				defInsItemDesc = candidate[0][16];   // 2007/01/06 以預設檢驗的物料品名為預設值
			}
	   	} 
	   	System.arraycopy(candidate,0,tempCal,0,candidate.length-1); // 把上次的原後選陣列保留至清單內
	   	arrayIQCTempBean.setArray2DString(candidate);	  
	}
	else 
	{
	 	System.arraycopy(arrIQCTemp,0,tempCal,0,arrIQCTemp.length-1); // 把上次的原後選陣列保留至清單內			
		arrayIQCTempBean.setArray2DString(tempCal);
	}
} 
else 
{
	for (int k=0;k<choice.length;k++)    
    {  
		IDDesc = choice[k];
	    iDCodeGet = iDCodeGet+"'"+IDDesc+"'"+",";	
			  
		for (int m=0;m<arrIQCSearch.length-1;m++) 
		{			   
			if (choice[k].equals(arrIQCSearch[m][1])) // 判斷若選定的InterfaceTransID等於待收料內容,才加入Array
			{
				tempCal[k][0]=arrIQCSearch[m][0];
				tempCal[k][1]=arrIQCSearch[m][1];
				tempCal[k][2]=arrIQCSearch[m][2];
				tempCal[k][3]=arrIQCSearch[m][3];
				tempCal[k][4]=arrIQCSearch[m][4];
				tempCal[k][5]=arrIQCSearch[m][5];
				tempCal[k][6]=arrIQCSearch[m][6];
				tempCal[k][7]=arrIQCSearch[m][7];
				tempCal[k][8]=arrIQCSearch[m][8];
				tempCal[k][9]=arrIQCSearch[m][9];
				tempCal[k][10]=arrIQCSearch[m][10];
				tempCal[k][11]=arrIQCSearch[m][11];
				tempCal[k][12]=arrIQCSearch[m][12];
				tempCal[k][13]=arrIQCSearch[m][13];
				tempCal[k][14]=arrIQCSearch[m][14];
				tempCal[k][15]=arrIQCSearch[m][15];
				tempCal[k][16]=arrIQCSearch[m][16];
				tempCal[k][17]=arrIQCSearch[m][17];
				tempCal[k][18]=arrIQCSearch[m][18];
				tempCal[k][19]=arrIQCSearch[m][19];
				defInsItemDesc = tempCal[k][16]; // 2007/01/06 以預設檢驗的物料品名為預設值
			}
		}		  
	}	   
	arrayIQCTempBean.setArray2DString(tempCal);
    System.arraycopy(tempCal,0,candidate,0,tempCal.length-1); // 把陣列保留至後選清單內	
			
	if (iDCodeGet.length()>0)
    {
    	iDCodeGetLength = iDCodeGet.length()-1;
        iDCodeGet = iDCodeGet.substring(0,iDCodeGetLength);
	} 		   
}
// 自己這頁已選的不入候選清單內_起
String g[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容	 
String idCardDesc = null; // ItemDesc
String idCardGet = request.getParameter("IDCARDGET");   // itemCodeGet
int idCardGetLength = 0;   // itemCodeGetLength   
if (idCardGet==null || idCardGet.equals("")) 
{  
	idCardGet = ""; 
}

if (g!=null) 
{	
	if (g.length>0)
	{
		for (int i=0;i<g.length;i++)
		{
			idCardDesc = g[i][1];
			idCardGet = idCardGet+"'"+idCardDesc+"'"+",";
		}
	    // 取得not in 條件_起
		if (idCardGet.length()>0)
        { 
        	idCardGetLength = idCardGet.length()-1;
            idCardGet = idCardGet.substring(0,idCardGetLength); 
        } 
   	}
} 
	
CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
cs1.setString(1,"305");  /*  41 --> 為台半半導體  42 --> 為事務機   305 --> YEW SEMI  */ 
cs1.execute();
cs1.close();
	 
//  設定Array 初始內容_起 
if (insertPage==null) 
{    
	arrayIQCDocumentInputBean.setArray2DString(null);
} 
else 
{
	String sp[][]=arrayIQCDocumentInputBean.getArray2DContent();     
	if (sp != null)
	{
		inpLen = sp.length;
	} 
}
  
try 
{   
	String at[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容     
   	if (at!=null) 
   	{
    	for (int ac=0;ac<at.length;ac++)
	  	{    	        
        	for (int subac=1;subac<at[ac].length;subac++)
	      	{
		    	String temp_at = request.getParameter("MONTH"+ac+"-"+subac);  //判斷是否Array為空的值
			  	if (temp_at!=null)
			  	{
		       		at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
			  	}
		   	}
	  	} 
   	  	arrayIQCDocumentInputBean.setArray2DString(at);  //reset Array
   	} 
   
  	if (addItems!=null) //若有選取則表示要作刪除
  	{ 
    	String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//重新取得陣列內容        
    	if (a!=null && addItems.length>0)      
    	{ 		 
	 		if (a.length>addItems.length)
	 		{	  	  	    
       			String t[][]=new String[a.length-addItems.length][a[0].length];   
	   			int cc=0; 
	   			for (int m=0;m<a.length;m++) // 處理列
	   			{
	    			String inArray="N";		
					for (int n=0;n<addItems.length;n++)  // 處理行
					{
		 				if (addItems[n].equals(a[m][0])) inArray="Y"; 
					}
					if (inArray.equals("N"))  // 沒被刪除的放進來
					{
		  				for (int gg=0;gg<14;gg++)  
		  				{  
			 				if (gg==0)
			 				{
			   					t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算			  
			 				}
			 				else 
							{
			        			t[cc][gg]=a[m][gg];         
			      			}
	      				}
		 				cc++;			     
					}  
	   			}
	   			arrayIQCDocumentInputBean.setArray2DString(t);	  
	 		} 
			else 
			{
				if (a.length==addItems.length)
			   	{ 
			    	arrayIQCDocumentInputBean.setArray2DString(null); 
				 	inpLen = 0;
			   	}
	        }  
		}
	} 
}
catch (Exception e)
{
   out.println("Exception:"+e.getMessage());
}     

try
{
	//add by Peggy 20121206
	String sqlx = " SELECT d.iqc_class_code, c.*  FROM (SELECT *  FROM (SELECT DISTINCT b.inv_item_id,a.IMATCODE, a.wafer_amp, a.wafer_type,"+
				  " a.wafer_size, a.dice_size, a.wf_thick, a.wf_resist, a.plat_layer, a.creation_date  FROM oraddman.tsciqc_lotinspect_header a, oraddman.tsciqc_lotinspect_detail b"+
				  " WHERE  a.insplot_no = b.insplot_no  AND (a.wafer_amp IS NOT NULL or  a.wafer_type IS NOT NULL or  a.wafer_size IS NOT NULL or  a.dice_size IS NOT NULL or a.wf_thick IS NOT NULL or a.wf_resist IS NOT NULL)  AND a.supplier_id = '"+tempCal[0][2]+"'"+
				  " AND b.inv_item_id = '"+tempCal[0][14]+"' order by a.creation_date desc) WHERE ROWNUM = 1) c, (SELECT inv_item_id, iqc_class_code"+
				  " FROM (SELECT DISTINCT y.inv_item_id, x.iqc_class_code, ROW_NUMBER ()  OVER (PARTITION BY y.inv_item_id ORDER BY  x.creation_date DESC) rownumber"+
				  " FROM oraddman.tsciqc_lotinspect_header x, oraddman.tsciqc_lotinspect_detail y  WHERE x.insplot_no = y.insplot_no"+
				  " AND y.inv_item_id ='"+ tempCal[0][14]+"')  WHERE rownumber = 1) d"+
				  " WHERE d.inv_item_id = c.inv_item_id(+)";
	Statement statementx=con.createStatement();
	ResultSet rsx=statementx.executeQuery(sqlx);
	if (rsx.next())
	{    
		if (classID==null || classID.equals("")) classID=rsx.getString("IQC_CLASS_CODE");  
		if (classID==null) classID="01";
		if (iMatCode==null || iMatCode.equals("")) iMatCode=rsx.getString("iMatCode");  //add by Peggy 20121220
		if (iMatCode==null) iMatCode="";  //add by Peggy 20121220
		if (waferAmp==null || waferAmp.equals("")) waferAmp=rsx.getString("wafer_amp");
		if (waferAmp==null)  waferAmp="";
		if (wfThick==null || wfThick.equals("")) wfThick=rsx.getString("wf_thick");
		if (wfThick==null) wfThick="";
		if (wfResist==null || wfResist.equals("")) wfResist=rsx.getString("wf_resist");   
		if (wfResist==null) wfResist="";
		if (wfTypeID==null || wfTypeID.equals("")) wfTypeID=rsx.getString("wafer_type");
		if (wfTypeID==null) wfTypeID="";
		if (wfSizeID==null || wfSizeID.equals("")) wfSizeID=rsx.getString("wafer_size");  
		if (wfSizeID==null) wfSizeID="";
		if (diceSize==null || diceSize.equals("")) diceSize=rsx.getString("dice_size");
		if (diceSize==null) diceSize="";
		if (wfPlatID==null || wfPlatID.equals("")) wfPlatID=rsx.getString("plat_layer"); 
		if (wfPlatID==null) wfPlatID="";
	}
	rsx.close();
	statementx.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
  
try
{ 
	if (inspLotNo==null || inspLotNo.equals(""))
  	{  
   		dateString=dateBean.getYearMonthDay();   
   		if (classID==null || classID.equals("--")) seqkey="IQC"+classID+dateString; //但仍以預設為使用者地區
   		else seqkey="IQC"+classID+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號   
   		Statement statement=con.createStatement();
   		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSQCDOCSEQ where header='"+seqkey+"' and TYPE_CODE ='IQC' ");
  
   		if (rs.next()==false)
   		{   
			String seqSql="insert into ORADDMAN.TSQCDOCSEQ values(?,?,?)";   
			PreparedStatement seqstmt=con.prepareStatement(seqSql);     
			seqstmt.setString(1,seqkey);
			seqstmt.setInt(2,1);   
			seqstmt.setString(3,"IQC");
	
			seqstmt.executeUpdate();
			seqno=seqkey+"-001";
			seqstmt.close();   
   		} 
   		else 
   		{
    		int lastno=rs.getInt("LASTNO");
    		String sql = "select * from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where substr(INSPLOT_NO,1,13)='"+seqkey+"' and to_number(substr(INSPLOT_NO,15,3))= '"+lastno+"' ";
    		ResultSet rs2=statement.executeQuery(sql); 
    		if (rs2.next())
    		{         
      			lastno++;
      			String numberString = Integer.toString(lastno);
      			String lastSeqNumber="000"+numberString;
      			lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
      			seqno=seqkey+"-"+lastSeqNumber;     
   
      			String seqSql="update ORADDMAN.TSQCDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE_CODE ='IQC' ";   
      			PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      			seqstmt.setInt(1,lastno);   
	
      			seqstmt.executeUpdate();   
      			seqstmt.close(); 
    		} 
    		else
    		{
      			//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
      			String sSqlSeq = "select to_number(substr(max(INSPLOT_NO),15,3)) as LASTNO from ORADDMAN.TSCIQC_LOTINSPECT_HEADER where substr(INSPLOT_NO,1,13)='"+seqkey+"' ";
      			ResultSet rs3=statement.executeQuery(sSqlSeq);
	 
	  			if (rs3.next()==true)
	  			{
       				int lastno_r=rs3.getInt("LASTNO");
	   				lastno_r++;
	  
	   				String numberString_r = Integer.toString(lastno_r);
       				String lastSeqNumber_r="000"+numberString_r;
       				lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       				seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	   				String seqSql="update ORADDMAN.TSQCDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE_CODE ='IQC' ";   
       				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       				seqstmt.setInt(1,lastno_r);   
	
       				seqstmt.executeUpdate();   
       				seqstmt.close();  
	  			}
				rs3.close();  //add by Peggy 20130710
     		}
			rs2.close(); //add by Peggy 20130710
    	}
		rs.close(); //add by Peggy 20130710
		statement.close();//add by Peggy 20130710
		
		inspLotNo = seqno; // 把取到的號碼給本次輸入
  	}
  	else 
	{
    	String inspLotNoSub = inspLotNo.substring(5,inspLotNo.length());
        inspLotNo = "IQC"+classID+inspLotNoSub;
	}	 
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>

<% /* 建立本頁面資料庫連線  */ %>
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
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<FORM ACTION="TSIQCInspectLotInput.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
sWhereGP = " ";  
sSql =  " select /*+ ORDERED index(a RCV_TRANSACTIONS_T1)  */ "+
        "INTERFACE_TRANSACTION_ID, SUPPLIER_ID, SUPPLIER, SUPPLIER_SITE_ID, SUPPLIER_SITE, RECEIPT_NUM, "+
		"to_char(RECEIPT_DATE,'YYYY/MM/DD HH24:MI:SS') as RECEIPT_DATE, TRANSACTION_DATE, WIP_ENTITY_ID,  "+
		"PO_NUM, SOURCE_DOC_QTY, TRANSACT_QTY, TRANSACT_UOM, ITEM_ID, b.SEGMENT1, ITEM_DESC, "+
		"VENDOR_LOT_NUM, PACKING_SLIP, a.ORGANIZATION_ID ";
String sFrom =  " from APPS.RCV_VRC_TXS_V a, MTL_SYSTEM_ITEMS b " ;
sSqlCNT     = "  select count(distinct RECEIPT_NUM) as CASECOUNT ";
sSqlCNTITEM = "  select count(RECEIPT_NUM) as iDetailRowCount ";
sWhere = " where a.ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID and a.TRANSACTION_TYPE='RECEIVE' and a.DESTINATION_TYPE_CODE = 'RECEIVING'  "+ // 暫收
         " and a.ATTRIBUTE6 IS NULL "; // 排除掉那些已經作開單,但狀態不為批退供應商(AWAITRECEIPT)的
sOrderBy =  " order by a.TRANSACTION_DATE, a.PO_NUM ";			 
 
if ((supplyVnd==null || supplyVnd.equals("") || supplyVnd.equals("null")) && (poNo==null || poNo.equals("") || poNo.equals("null"))) 
{  
} 
else if (supplyVnd!=null && !supplyVnd.equals("") && !supplyVnd.equals("null")) 
{ 
	sWhere+=" and a.SUPPLIER ='"+supplyVnd+"'"; 
}
 
if ( (supplyVnd==null || supplyVnd.equals("") || supplyVnd.equals("null")) && (poNo==null || poNo.equals("") || poNo.equals("null")) ) 
{  
} 
else if (poNo!=null && !poNo.equals("")) 
{ 
	sWhere+=" and a.PO_NUM ='"+poNo+"'"; 
}
 
if (receiptNo!=null && !receiptNo.equals("") && !receiptNo.equals("null")) 
{ 
	sWhere+=" and a.RECEIPT_NUM ='"+receiptNo+"'"; 
}
if (invItem!=null && !invItem.equals("")) 
{ 
	sWhere+=" and b.SEGMENT1 ='"+invItem+"'";	
}
if (itemDesc!=null && !itemDesc.equals("")) 
{ 
	sWhere+=" and a.ITEM_DESC ='"+itemDesc+"'";	
}

// 2006/11/02 取得使用由上一頁選取的Interface Transaction ID作為此次查詢條件_迄
if (iDCodeGet!=null && !iDCodeGet.equals("")) 
{ 
	sWhere+=" and to_char(INTERFACE_TRANSACTION_ID) in ("+iDCodeGet+") ";  
}

if (marketType==null || marketType.equals("") || marketType.equals("--")) 
{ 
}
else  
{
	sWhere+= " and a.ORGANIZATION_ID = '"+marketType+"' "; 
}
sSql = sSql + sFrom + sWhere + sOrderBy ;
sSqlCNT = sSqlCNT  + sFrom + sWhere ;
sSqlCNTITEM = sSqlCNTITEM + sFrom + sWhere ;
sqlGlobal = sSql;

%>
 <tr bgcolor="#DAE089"><td width="8%" nowrap></td>
     <td width="20%" nowrap>
	 <input type="hidden" size="5" name="SUPPLYVNDID" maxlength="10" value="<%=supplyVndID%>">
	 <input type="hidden" size="5" name="SUPPLYVNDNO" maxlength="10" value="<%=supplyVndNo%>">
	 <!--%<INPUT TYPE="button" value="..." onClick='subWindowSupplierFind(this.form.SUPPLYVNDNO.value,this.form.SUPPLYVND.value)'> %-->
	 <input type="hidden" size="25" name="SUPPLYVND" maxlength="50" value="<%=supplyVnd%>">	  
	 </td>
     <td width="6%" nowrap></td>
     <td width="29%"><input name="RECEPTDATESTR" tabindex="2" type="hidden" size="8" value="<%=receptDateStr%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATESTR);return false;'></A></td>
     <td width="7%" nowrap></td>
	 <td width="30%"><input name="RECEPTDATEEND" tabindex="2" type="hidden" size="8" value="<%=receptDateEnd%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATEEND);return false;'></A></td>
    </tr>
	 <tr bgcolor="#DAE089">
	   <td nowrap></td><td><input type="hidden" size="15" name="PONO" tabindex='4' maxlength="20" value="<%=poNo%>"></td>
	   <td nowrap></td><td><input type="hidden" size="15" name="RECEIPTNO" tabindex='5' maxlength="20" value="<%=receiptNo%>"></td>
	   <td nowrap></td><td><input type="hidden" size="15" name="ROUNDCARD" tabindex='6' maxlength="20" value="<%=roundCard%>"></td>
	 </tr>
    <tr bgcolor="#DAE089">
	    <td nowrap></td><td><input type="hidden" size="30" name="INVITEM" tabindex='7' maxlength="30" value="<%=invItem.toUpperCase()%>" ><!--%<INPUT TYPE="button" tabindex="12" value="..." onClick="subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)">%--></td>
		<td nowrap></td><td colspan="1"><input type="hidden" size="30" name="ITEMDESC" tabindex='4' maxlength="50" value="<%=itemDesc.toUpperCase()%>"><!--%<INPUT TYPE="button" tabindex="14"  value="..." onClick="subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)">%--></td>
		<td colspan="2"><!--%<INPUT name="button3" tabindex='20' TYPE="button" onClick='setSubmitQuery("../jsp/TSIQCInspectLotInput.jsp?QUERY=Y",this.form.SUPPLYVND.value,this.form.VENDOR.value)'  value='資料帶出' >%--></td>
    </tr>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
    <tr>      
      <td width="19%"><span class="style20">IQC檢驗批單號:</span><font face="Arial" size="2" color="#003366"><span class="style1">&nbsp;</span><strong><font face="Georgia" size="+1"><%=inspLotNo%></font></strong></font>&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600">為必選(填)欄位,請務必輸入</font></td>      	 
	</tr>
<%
for (int pp=0;pp<tempCal.length-1;pp++)
{
	supplierID = tempCal[pp][2];
	supplierName =tempCal[pp][3];
	supSiteID = tempCal[pp][4];
	supSiteName = tempCal[pp][5];
	poNumber = tempCal[pp][10];
%>	 
	<script language="javascript">
		window.document.MYFORM.SUPPLYVND.value="<%=tempCal[pp][3]%>";// 把這次查詢的條件供應商名稱再給
	</script>
<% 
}
%>
</table>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
	<tr bgcolor="#CCCC99"><td width="7%" nowrap="nowrap">檢驗類別<img src="../image/point.gif"></td>
     <td width="16%">
<%	    	     		 		 
try
{ 	   		 
	String sSqlC = "";
	String sWhereC = "";		  
	sSqlC = "select Unique CLASS_ID as x ,CLASS_CODE||'('||CLASS_NAME||')' from ORADDMAN.TSCIQC_CLASS ";		  
	sWhereC= "where CLASS_ID IS NOT NULL  order by x";	
	sSqlC = sSqlC+sWhereC;		  
    Statement statementC=con.createStatement();
    ResultSet rsC=statementC.executeQuery(sSqlC);
	out.println("<select NAME='CLASSID' onChange='setSubmitClass("+'"'+"../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INSPLOTNO="+'"'+","+'"'+supplierID+'"'+","+'"'+poNumber+'"'+")'>");
    out.println("<OPTION VALUE=-->--"); 
	while (rsC.next())
    {            
    	String s1=(String)rsC.getString(1); 
        String s2=(String)rsC.getString(2); 
        if (s1.equals(classID)) 
        {
        	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
        }   
		else 
		{
        	out.println("<OPTION VALUE='"+s1+"'>"+s2);
        }        
	}
    out.println("</select>"); 
    rsC.close();      
	statementC.close();		 
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
}			
%>
	 </td>
     <td width="13%" nowrap="nowrap">供應商<img src="../image/point.gif"></td>
     <td width="28%"><input name="SUPPLIERID" tabindex="2" type="text" size="5" value="<%=supplierID%>" readonly>
<%
if (choice!=null)
{
	for (int p=0;p<choice.length-1;p++)
	{
		for (int m=0;m<arrIQCSearch.length-1;m++) 
		{	
			if (choice[p]==arrIQCSearch[m][1] || choice[p].equals(arrIQCSearch[m][1]))
			{
				if (arrIQCSearch[m][2]!=supplierID && !arrIQCSearch[m][2].equals(supplierID))	
				{  
%>
				<script language="javascript">
					alertBKRule("../jsp/TSIQCInspectLotEntry.jsp?STATUSID=020&PAGEURL=TSIQCInspectLotInput.jsp","本次檢驗批清單內含不同廠商,違反檢驗規範\n      請重新選擇收料項目檢驗");	
				</script>
<%
				} 
			} 
		}		    
	}	
}
%>
<input name="SUPPLIERNAME" type="hidden" size="25" value="<%=supplierName%>" readonly><% if (supplierName==null) out.println("&nbsp;"); else out.println(supplierName); %><input name="SUPSITEID" type="hidden" size="5" value="<%=supSiteID%>" readonly><input name="SUPSITENAME" type="hidden" size="5" value="<%=supSiteName%>" readonly></td>
	<td width="12%" nowrap="nowrap">檢驗日期<img src="../image/point.gif"></td>
	<td width="29%"><input name="INSPECTDATE" tabindex="3" type="text" size="8" value="<%=inspectDate%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.INSPECTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
    </tr>
	<tr bgcolor="#CCCC99">
	   <input type="hidden" size="15" name="PONUMBER" tabindex='4' maxlength="20" value="<%=poNumber%>">
	   <td nowrap="nowrap">特採檢驗批</td>
	   <td colspan="1">
	     <select name="WAIVELOT">
	       <option value="<%if (waiveLot==null || waiveLot.equals("")) out.print(""); else  out.print("Y"); %>">Y(是)</option>
	       <option value="<%if (waiveLot==null || waiveLot.equals("")) out.print("N");else  out.print(waiveLot); %>" selected>N(否)</option>
	     </select>
	   </td>
	   <td>包裝方式</td><td><input type="text" size="15" name="PACKMETHOD" tabindex='4' maxlength="20" value="<%=packMethod%>"></td>
	   <td nowrap="nowrap">原料種類<% if (classID.equals("03")) out.print("<img src='../image/point.gif'>"); %></td>
	   <td colspan="1">
<%	    	     		 		 
try
{ 	   		 
	String sSqlC = "";
	String sWhereC = "";		  
	sSqlC = "select Unique IMAT_CODE as x ,IMAT_CODE||'('||IMAT_NAME||')' from ORADDMAN.TSCIQC_IMATCODE ";		  
	sWhereC= "where IMAT_ID IS NOT NULL  order by x";	
	sSqlC = sSqlC+sWhereC;		  
    Statement statementC=con.createStatement();
    ResultSet rsC=statementC.executeQuery(sSqlC);		  
    comboBoxBean.setRs(rsC);
	if (iMatCode!=null && !iMatCode.equals("--")) comboBoxBean.setSelection(iMatCode);		  		  		  
	comboBoxBean.setFieldName("IMATCODE");	   
    out.println(comboBoxBean.getRsString());		 
    rsC.close();      
	statementC.close();		 
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
}			
%>
	</td>
	</tr>
	<tr bgcolor="#CCCC99">
	  <td>物料名稱</td><td nowrap><input type="text" size="25" name="PRODNAME" tabindex='12' maxlength="30" value="<% if (prodName==null || prodName.equals("")) out.print(defInsItemDesc); else out.print(prodName); %>"></td><td>適用型號</td><td><input type="text" size="15" name="PRODMODEL" tabindex='12' maxlength="30" value="<%=prodModel%>"></td><td>抽樣數</td><td><input type="text" size="10" name="SAMPLEQTY" tabindex='12' maxlength="30" value="<%=sampleQty%>"></td>
	</tr> 
<%
if (classID.equals("01")) // 若是晶片晶粒的檢驗才顯示_起
{
%>
    <tr bgcolor="#CCCC99">	    
	    <td nowrap>晶片種類<% if (classID.equals("01")) out.print("<img src='../image/point.gif'>"); %></td>
		<td colspan="3" nowrap>
<%
	try
	{       
		Statement statement=con.createStatement();
    	//ResultSet rs=statement.executeQuery("select WF_TYPE_ID as WFTYPEID,WF_TYPE_NAME from ORADDMAN.TSCIQC_WAFER_TYPE order by WF_TYPE_ID");
		ResultSet rs=statement.executeQuery("select WF_TYPE_ID as WFTYPEID,WF_TYPE_NAME from ORADDMAN.TSCIQC_WAFER_TYPE where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate)) order by WF_TYPE_ID"); //modify by Peggy 20150205
    	checkBoxBean.setRs(rs);
    	if (wfTypeID != null)
   		checkBoxBean.setChecked(wfTypeID);
	    checkBoxBean.setFieldName("WFTYPEID");	   
	    checkBoxBean.setColumn(7); //傳參數給bean以回傳checkBox的列數
        out.println(checkBoxBean.getRsString());
	    statement.close();
        rs.close();       
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
	}
%>
		</td>
		<td nowrap>晶片安培數<input type="text" size="5" name="WAFERAMP" tabindex='4' maxlength="10" value="<%=waferAmp.toUpperCase()%>"></td>	
		<td nowrap>晶粒尺寸<% if (classID.equals("01")) out.print("<img src='../image/point.gif'>"); %>
<%	    	     		 		 
	try
	{ 	   		 
		String sSqlMIL = "";
		String sWhereMIL = "";		  
		sSqlMIL = "select Unique DICE_MIL as x ,DICE_MIL from APPS.YEW_WFDICE_FACTOR ";		  
		sWhereMIL= "where DICE_MIL IS NOT NULL order by to_number(DICE_MIL)";	
		sSqlMIL = sSqlMIL+sWhereMIL;		  
        Statement statementMIL=con.createStatement();
        ResultSet rsMIL=statementMIL.executeQuery(sSqlMIL);
		out.println("<select NAME='DICESIZE' onChange='setSubmitDiceSize("+'"'+"../jsp/TSIQCInspectLotInput.jsp?INSERT=Y&INSPLOTNO="+'"'+")'>");
        out.println("<OPTION VALUE=-->--");     
        while (rsMIL.next())
        {            
        	String s1=(String)rsMIL.getString(1); 
            String s2=(String)rsMIL.getString(2); 
            if (s1.equals(diceSize)) 
            {
            	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            }   
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
        } 
        out.println("</select>"); 
        rsMIL.close();      
		statementMIL.close();		 
	} 
	catch (Exception e)
	{
    	out.println("Exception:"+e.getMessage());		  
	}			
%>
	<input type="hidden" size="10" name="DICESIZE2" maxlength="30" value="<%=diceSize%>">mil		  
	</td>			
</tr>
<tr bgcolor="#CCCC99">
  <td nowrap>晶片尺寸<% if (classID.equals("01")) out.print("<img src='../image/point.gif'>"); %></td>
	  <td nowrap>
<%
	try
    {       
    	Statement statement=con.createStatement();
		//ResultSet rs=statement.executeQuery("select WF_SIZE_ID as WFSIZEID,WFSIZE_REMARK from ORADDMAN.TSCIQC_WAFER_SIZE order by WF_SIZE_ID");
		ResultSet rs=statement.executeQuery("select WF_SIZE_ID as WFSIZEID,WFSIZE_REMARK from ORADDMAN.TSCIQC_WAFER_SIZE where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate)) order by WF_SIZE_ID");  //mofify by Peggy 20150205
		checkBoxBean.setRs(rs);
		if (wfSizeID != null)
		checkBoxBean.setChecked(wfSizeID);
		checkBoxBean.setFieldName("WFSIZEID");	   
		checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
		out.println(checkBoxBean.getRsString());
	    statement.close();
        rs.close();       
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
	}
%>
	  </td>
	  <td nowrap="nowrap">晶片厚度<% if (classID.equals("01")) out.print("<img src='../image/point.gif'>"); %></td><td><input type="text" size="15" name="WFTHICK" maxlength="20" value="<%=wfThick%>">μm</td>
	  <td nowrap="nowrap">阻值(電壓)<% if (classID.equals("01")) out.print("<img src='../image/point.gif'>"); %></td>
	  <td>
<%	    	     		 		 
	try
	{ 	   		 
		String sSqlVTG = "";
		String sWhereVTG = "";		  
		sSqlVTG = "select Unique VOTAGE_RESIST as x ,VOTAGE_RESIST from APPS.YEW_WFDICE_FACTOR ";		  
		sWhereVTG= "where DICE_MIL = '"+diceSize+"' order by VOTAGE_RESIST ";	
		sSqlVTG = sSqlVTG+sWhereVTG;		  
        Statement statementVTG=con.createStatement();
        ResultSet rsVTG=statementVTG.executeQuery(sSqlVTG);		   
        comboBoxBean.setRs(rsVTG);
		if (wfResist!=null && !wfResist.equals("--")) comboBoxBean.setSelection(wfResist);		  		  		  
	    comboBoxBean.setFieldName("WFRESIST");	   
        out.println(comboBoxBean.getRsString());		   
        rsVTG.close();      
		statementVTG.close();		 
	}
	catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());		  
	}			
%>
	  <input type="hidden" size="15" name="WFRESIST2" tabindex='4' maxlength="20" value="<%=wfResist%>">Ω-cm/V</td>
	</tr>
	<tr bgcolor="#CCCC99">
		<td colspan="1">鍍層:</td>
		<td colspan="1"><font color="#990000">	   
<%
	try
    {       
    	Statement statement=con.createStatement();
        //ResultSet rs=statement.executeQuery("select WF_PLAT_ID as WFPLATID,WF_PLAT_CODE from ORADDMAN.TSCIQC_WAFER_PLAT order by WF_PLAT_ID");
		ResultSet rs=statement.executeQuery("select WF_PLAT_ID as WFPLATID,WF_PLAT_CODE from ORADDMAN.TSCIQC_WAFER_PLAT  where (INACTIVE_DATE is null or INACTIVE_DATE > trunc(sysdate)) order by WF_PLAT_ID"); //modify by Peggy 20150205
        checkBoxBean.setRs(rs);
		if (wfPlatID != null)
   	    checkBoxBean.setChecked(wfPlatID);
	    checkBoxBean.setFieldName("WFPLATID");	   
	    checkBoxBean.setColumn(3); //傳參數給bean以回傳checkBox的列數
        out.println(checkBoxBean.getRsString());
	    statement.close();
        rs.close();       
	}
	catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
	}
%>
	   </font>
	   </td> 
       <td>電性良品率(Total Yield):</td>
	   <TD><INPUT TYPE="TEXT" NAME="HEADERTOTALYIELD" SIZE=10 maxlength="10" value="<%=headerTotalYield%>" onKeyUp="setTOTALYIELD();"> %</TD>
	   <td>型號良率(Product Yiels):</td>
	   <td><INPUT TYPE="TEXT" NAME="HEADERPRODYIELD" SIZE=10 maxlength="10" value="<%=headerProdYield%>" onKeyUp="setPRODYIELD();"> %</td>
	</tr>	
<%
} 
%>
	<tr bgcolor="#CCCC99">	   
		<td nowrap="nowrap">備註</td><td colspan="5"><input type="text" size="80" name="REMARK" maxlength="50" value="<%=remark%>"></td>
	</tr>
</table> 
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
	<tr bgcolor="#CCCC99"> 
		<td width="5%" height="22" nowrap><div align="center" class="style14">&nbsp;</div></td> 
	   	<!--<td width="8%" nowrap><div align="center" class="style14">識別碼</div></td>-->
      	<td width="8%" nowrap><div align="center" class="style14">採購單號</div></td>
      	<td width="8%" nowrap><div align="center" class="style14">收料單號</div></td>
      	<td width="18%" nowrap><div align="center" class="style14">料號說明</div></td> 
	  	<td width="5%" nowrap><div align="center" class="style14">數量</div></td> 
	  	<td width="5%" nowrap><div align="center" class="style14">單位</div></td> 
	  	<td width="8%" nowrap><div align="center" class="style14">供應商</font></div></td> 
<% if (classID.equals("01"))
{ 
%>
		<td width="3%" nowrap><div align="center" class="style14">晶片數量</div></td> 
      	<td width="3%" nowrap><div align="center" class="style14">晶片良率</div></td> 
      	<td width="3%" nowrap><div align="center" class="style14">電性良率</div></td> 
<% 
} 
%>
	  	<td width="9%" nowrap><div align="center" class="style14">零件承認編號</div></td> 
	 	<td width="12%" nowrap><div align="center" class="style14">供應商(晶片)批號</div></td> 
	 	<td width="7%" nowrap><div align="center" class="style14">免驗料件<img src='../image/point.gif'></div></td> 
	 	<td width="6%" nowrap><div align="center" class="style14">收料日期</div></td>  	 
      	<td width="3%" nowrap><div align="center" class="style14">說明</div></td> 
	 	<td width="5%" nowrap><div align="center" class="style14">&nbsp;</div></td> 	 			 		
    </tr>	
<% 
if (tempCal!=null)
{
	String aIQC[][]=arrayIQCDocumentInputBean.getArray2DContent();
	for (int qq=0;qq<tempCal.length-1;qq++)
	{
		organizationId = tempCal[qq][19];
	    String sqlASL = " select ATTRIBUTE1, ATTRIBUTE2 from PO_APPROVED_SUPPLIER_LIST "+		  
		                " where USING_ORGANIZATION_ID = "+tempCal[qq][19]+" and VENDOR_ID = "+tempCal[qq][2]+" "+
						" and ITEM_ID ="+tempCal[qq][14]+" and DISABLE_FLAG IS NULL ";	
        Statement stateASL=con.createStatement();
        ResultSet rsASL=stateASL.executeQuery(sqlASL);
		if (rsASL.next())
		{
			inspReqFlag = rsASL.getString(1); // 取免驗標記
			authorNumber = rsASL.getString(2); // 取免驗編號
		} 
		else 
		{
			inspReqFlag = "N"; 
		}
	    rsASL.close();
		stateASL.close();
		String lotCtrl = "N"; // 預設為否
		String sqlLotCrtl = "  select decode(LOT_CONTROL_CODE, '1','N','2','Y','N') from MTL_SYSTEM_ITEMS "+		  
		                    "  where ORGANIZATION_ID = "+tempCal[qq][19]+" "+
						    "  and INVENTORY_ITEM_ID ="+tempCal[qq][14]+" ";	
		  	  
        Statement stateLotCrtl=con.createStatement();
        ResultSet rsLotCrtl=stateLotCrtl.executeQuery(sqlLotCrtl);
		if (rsLotCrtl.next())
		{
			lotCtrl = rsLotCrtl.getString(1); // 取批號控管(是/否)			
		} 
	    rsLotCrtl.close();
		stateLotCrtl.close();		 
	    String sFlag = "true";
		if (interfaceID!=null && tempCal[qq][1]!=null && interfaceID.equals(tempCal[qq][1]))
			sFlag = "false";
        else if (aIQC!=null) 
		{
			for (int n1=0;n1<aIQC.length;n1++) 
			{
		    	if (aIQC[n1][1]!=null && aIQC[n1][1].equals(tempCal[qq][1])) sFlag = "false"; 
		    }
		}
%>		
   <font face="Arial"> 
   <tr bgcolor="<%=colorStr%>">       
	  <td width="5%"><div align="center"><font size="2" color="#686731">
	  <input name="INO" type="hidden" size="2" <%if (iNo==null) out.println("value=1"); else out.print("value="+tempCal[qq][0]);%>> 
	  <input name="INTERFACETRANSID<%=Integer.toString(rs1__index+1)%>" type="hidden" size="5" value="<%if (interfaceTransID==null) out.print(tempCal[qq][1]); else out.print(interfaceTransID);%>">	    
	  <%out.println(rs1__index+1);%>
	  </font></div> </td>  
	  <!--<td width="8%" nowrap><div align="center"><font color="#686731"><%=tempCal[qq][1]%></font></div></td>欄位太多,新增按鈕超出螢幕,故隱藏識別碼欄位,modify by Peggy 20130131-->   	        
	  <td width="8%" nowrap><div align="center"><font color="#686731"><%=tempCal[qq][10]%></font></div></td><!--add po_no by Peggy 20130131-->  	        
      <td width="8%" nowrap><div align="center"><font color="#686731"><input name="RECNO<%=Integer.toString(rs1__index+1)%>" type="hidden" size="5" value="<%if (recNo==null) out.print(tempCal[qq][6]); else out.print(recNo);%>"><%=tempCal[qq][6]%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font color="#686731"><input name="INVITEMNO<%=Integer.toString(rs1__index+1)%>" type="hidden" size="5" value="<%if (invItemNo==null) out.print(tempCal[qq][15]); else out.print(invItemNo);%>"><input name="INVITEMDESC<%=Integer.toString(rs1__index+1)%>" type="hidden" size="5" value="<%if (invItemDesc==null) out.print(tempCal[qq][16]); else out.print(invItemDesc);%>">
<%
		out.print("<a href=javaScript:popMenuMsg('"+tempCal[qq][15]+"') onmouseover='this.T_WIDTH=150;this.T_OPACITY=150;return escape("+"\""+tempCal[qq][15]+"\""+")'>"); // 寬度,透明度 //
	 	out.print(tempCal[qq][16]);
		out.println("</a>");
%></font></div>
	  </td>	  
	  <td width="5%" nowrap><div align="center"><font color="#686731"><input name="TRANSACTQTY<%=Integer.toString(rs1__index+1)%>" type="hidden" size="2" <%if (transactQty==null) out.print("value="); else out.print("value="+transactQty);%>><%=tempCal[qq][12]%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#686731"><input name="TRANSACTUOM<%=Integer.toString(rs1__index+1)%>" type="hidden" size="2" <%if (transactUOM==null) out.print("value="); else out.print("value="+transactUOM);%>><%=tempCal[qq][13]%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#686731"><input name="SUPSITEID<%=Integer.toString(rs1__index+1)%>" type="hidden" size="2" <%if (supSiteID==null) out.print("value="); else out.print("value="+supSiteID);%>><input name="SUPPLIER" type="hidden" size="2" <%if (supplier==null) out.print("value="); else out.print("value="+supplier);%>><%=tempCal[qq][5]%></font></div></td>
<% 	
		if (classID.equals("01"))
      	{ 
%>
      <td width="3%" nowrap><div align="center"> <font color="#686731"><input type="text" size="5" name="GRAINQTY<%=Integer.toString(rs1__index+1)%>" tabindex='20' maxlength="10" value="<% if (tempCal[qq][20]==null || tempCal[qq][20].equals("")) out.print(""); else out.print(tempCal[qq][20]); %>"></font></div></td>
      <td width="3%" nowrap><div align="center"> <font color="#686731"><input type="text" size="5" name="PRODYIELD<%=Integer.toString(rs1__index+1)%>" tabindex='21' maxlength="10" value="<% if (tempCal[qq][21]==null || tempCal[qq][21].equals("")) out.print(headerProdYield); else out.print(tempCal[qq][21]); %>"></font></div></td>
      <td width="3%" nowrap><div align="center"> <font color="#686731"><input type="text" size="5" name="TOTALYIELD<%=Integer.toString(rs1__index+1)%>" tabindex='22' maxlength="10" value="<% if (tempCal[qq][22]==null || tempCal[qq][22].equals("")) out.print(headerTotalYield); else out.print(tempCal[qq][22]); %>"></font></div></td>
<% 
		}
		else
		{   
%>
      <input type="hidden" size="5" name="GRAINQTY<%=Integer.toString(rs1__index+1)%>" tabindex='20' maxlength="10" value="<%=tempCal[qq][12]%>">
      <input type="hidden" size="5" name="PRODYIELD<%=Integer.toString(rs1__index+1)%>" tabindex='20' maxlength="10" value="<%=tempCal[qq][12]%>">
      <input type="hidden" size="5" name="TOTALYIELD<%=Integer.toString(rs1__index+1)%>" tabindex='20' maxlength="10" value="<%=tempCal[qq][12]%>">
<%
		}
%>
	  <td width="9%" nowrap><div align="center"><font color="#686731"><input type="text" size="8" name="AUTHORNO<%=Integer.toString(rs1__index+1)%>" tabindex='23' maxlength="20" value="<%=%>"></font></div></td>
	  <td width="12%" nowrap><div align="center"><font color="#686731"><input type="text" size="12" name="SUPLOTNO<%=Integer.toString(rs1__index+1)%>" tabindex='24' maxlength="20" value="<% if (tempCal[qq][17]==null || tempCal[qq][17].equals("")) out.print(""); else out.print(tempCal[qq][17]); %>"></font></div>
<%  
		String sqlfnd = "  SELECT COUNT(MMT.TRANSACTION_ID)  FROM MTL_MATERIAL_TRANSACTIONS MMT, MTL_TRANSACTION_LOT_NUMBERS MTN "+
  	  			        "   WHERE MMT.TRANSACTION_TYPE_ID=36  AND MMT.ORGANIZATION_ID=MTN.ORGANIZATION_ID  "+
                        "     AND MMT.TRANSACTION_ID = MTN.TRANSACTION_ID AND MMT.INVENTORY_ITEM_ID = MTN.INVENTORY_ITEM_ID "+
     				    "     AND MMT.ORGANIZATION_ID='"+tempCal[qq][19]+"' AND MMT.INVENTORY_ITEM_ID='"+tempCal[qq][14]+"' "+
	 				    "     AND MTN.LOT_NUMBER = '"+tempCal[qq][17]+"'  ";
		Statement stateFndId=con.createStatement();
        ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
	    if (rsFndId.next())
	    {
	    	if (rsFndId.getInt(1) > 0) 
            { 
				returnFlag="Y";
			}
        	else  
            { 
				returnFlag="N";
			} 
	    }
	    rsFndId.close();
   	    stateFndId.close();
%>
        <input name="RTNFLAG<%=Integer.toString(rs1__index+1)%>" type="hidden" size="1" value="<%=returnFlag%>">
      </td>
	  <td width="7%" nowrap><div align="center"><font color="#686731">	   
	        <input type="text" size="5" name="INSPREQ<%=Integer.toString(rs1__index+1)%>" tabindex='25' maxlength="20" value="<%if (inspReqFlag==null) out.print("N"); else if (inspReqFlag.equals("N")) out.print("N"); else { out.print("Y"); }%>"></font></div>
            
	  </td>
	  <div align="center"><font color="#686731"><input type="hidden" tabindex='26' name="RCARDNO<%=Integer.toString(rs1__index+1)%>" size="2" value="<%=%>"></font></div>	
	  <td width="6%" nowrap><div align="center"><font color="#686731"><input type="hidden" tabindex='27' name="RECEIPTDATE<%=Integer.toString(rs1__index+1)%>" size="2" value="<%if (receiptDate==null) out.print(""); else out.print(receiptDate);%>"><%=tempCal[qq][7].substring(0,10)%></font></div></td>		  
	  <td width="6%" nowrap><div align="center"><font color="#686731"><input type="text" tabindex='28' name="COMMENT<%=Integer.toString(rs1__index+1)%>" size="6" value="<%=%>"></font></div></td>	  
	  <td width="5%"><div align="center">
<% 
		if (sFlag.equals("true"))
      	{ 
%>
	    <INPUT TYPE="button" name='INSPADD<%=Integer.toString(rs1__index+1)%>' tabindex="28" value='新增' onClick='setSubmitAdd("../jsp/TSIQCInspectLotInput.jsp?INSERT=Y","<%=tempCal[qq][1]%>","<%=tempCal[qq][6]%>","<%=tempCal[qq][15]%>","<%=tempCal[qq][20]%>","<%=tempCal[qq][21]%>","<%=authorNumber%>","<%=supLotNumber%>","<%=inspReqFlag%>","<%=Integer.toString(rs1__index+1)%>","<%=lotCtrl%>","<%=tempCal[qq][22]%>","<%=returnFlag%>","<%=commentDesc%>")'>
<% 
		}
		else
		{   
%>
	    <INPUT TYPE="button" name='INSPADD<%=Integer.toString(rs1__index+1)%>' tabindex="28" value='新增' disabled onClick='setSubmitAdd("../jsp/TSIQCInspectLotInput.jsp?INSERT=Y","<%=tempCal[qq][1]%>","<%=tempCal[qq][6]%>","<%=tempCal[qq][15]%>","<%=tempCal[qq][20]%>","<%=tempCal[qq][21]%>","<%=authorNumber%>","<%=supLotNumber%>","<%=inspReqFlag%>","<%=Integer.toString(rs1__index+1)%>","<%=lotCtrl%>","<%=tempCal[qq][22]%>","<%=returnFlag%>","<%=commentDesc%>"))'>
<% 
		}
%>
	  </div></td>	
    </tr></font>
<%
		rs1__index++; // 累加索引值
   	}
}
%>
 <tr bgcolor="#CCCC99">
	 <td colspan="13"><div align="center"><strong>
<%
try
{
	//String oneDArray[]= {"","序號","收料識別碼","收料單號","台半料號","料號說明","數量","供應商出貨地碼","轉換數量","晶片良率","電性良率","零件承認編號","供應商批號","免驗料件"}; 		 	     			  
	String oneDArray[]= {"","序號","收料識別碼","收料單號","台半料號","料號說明","數量","供應商出貨地碼","轉換數量","晶片良率","電性良率","零件承認編號","供應商批號","免驗料件","說明"}; //add by Peggy 20121218 		 	     			      
	arrayIQCDocumentInputBean.setArrayString(oneDArray);
	String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容  	   			    
	int i=0,j=0,k=0;
    String dupFLAG="FALSE";		 
	if (( (invItemNo!=null && !invItemNo.equals("")) || (invItemDesc!=null && !invItemDesc.equals("")) ) && recNo!=null && !recNo.equals("") && bringLast==null)
	{ 
		String sqlUOM = ""; 
		if (interfaceID!=null && !interfaceID.equals("") && receiptNumber!=null && !receiptNumber.equals("")) // 若取得interfaceTransID,抓相關內容放進ArrayBean
		{ 	
			for (int rr=0;rr<tempCal.length-1;rr++)
			{	
				if (tempCal[rr][1].equals(interfaceID))
				{	   	      			  
			    	invItemDesc = tempCal[rr][16]; 
			      	transactQty =  tempCal[rr][12]; 
			      	supSiteID =  tempCal[rr][4]; 
			      	receiptDate =  tempCal[rr][7];
				}
			}
	 	}
			  
		if (a!=null) 
		{
			int irow=1;
			for (int m=0;m<a.length;m++)
			{
				if (a[m][1].equals(interfaceID)) irow=0;  //add by Peggy 20121220
			}
			String b[][]=new String[a.length+irow][a[i].length];		    			 
			for (i=0;i<a.length;i++)
			{
				for (j=0;j<a[i].length;j++)
			  	{
			    	if (a[i][j]!=null && !a[i][j].equals("") && !a[i][j].equals("null")) 
					{
			      		b[i][j]=a[i][j];	
					}
			  	}
			   	if (b[k][1]!=null && !b[k][1].equals("") && !b[k][1].equals("null")) 
			   	{
			    	k++;
			   	}
			}
			if (authorNo==null || authorNo.equals("")) authorNo = "";

			if (irow>0)  //add by Peggy 20121220
			{
				iNo = Integer.toString(k+1);  
				b[k][0]=iNo;
				b[k][1]=interfaceID; 
				b[k][2]=receiptNumber; 
				b[k][3]=itemNo; 
				b[k][4]=invItemDesc; 
				b[k][5]=transactQty;
				b[k][6]=supSiteID;
				b[k][7]=grainQty;
				b[k][8]=prodYield;
				b[k][9]=totalYield;
				b[k][10]=authorNo;
				b[k][11]=supLotNo;
				b[k][12]=inspReq;
				b[k][13]=comment;//add by Peggy 20121218				

			}
			arrayIQCDocumentInputBean.setArray2DString(b);
		} 
		else 
		{
			if (interfaceID!=null && !interfaceID.equals(""))
			{        
				String c[][]={{iNo,interfaceID,receiptNumber,itemNo,invItemDesc,transactQty,supSiteID,grainQty,totalYield,prodYield,authorNo,supLotNo,inspReq,comment}};						             			 
		        arrayIQCDocumentInputBean.setArray2DString(c); 	
			}	 	                
		}  
	} 
	else 
	{
		if (a!=null) 
		{
			arrayIQCDocumentInputBean.setArray2DString(a);     			       	                
		} 
	}
	Statement chkstat=con.createStatement();
    ResultSet chkrs=null;
	String T2[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
	String tp[]=arrayIQCDocumentInputBean.getArrayContent();
	if  (T2!=null) 
	{  		   
		String temp[][]=new String[T2.length][T2[0].length];		    
		for (int ti=0;ti<T2.length;ti++)
		{
			for (int tj=0;tj<T2[ti].length;tj++)  
			{				 
				temp[ti][tj]=T2[ti][tj];
			}
		}		
		int ti = 0;
        int tj = 0;
        temp[ti][tj]="N";	
	    arrayIQCDocumentInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
	} 
	else 
	{    		      		     
		arrayIQCDocumentInputBean.setArray2DCheck(null);
	}
	if (chkrs!=null) chkrs.close();
	chkstat.close();		  
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>      
<%
try 
{
	String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
	float total=0;
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
}
%>	
<%
try 
{
	String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
	float total=0;
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
}
%></strong></div>
	</td>
   </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% 
	%>
    <!--strong>No Record Found</strong-->    
    </font> </div>
	
<!--選擇全部,存檔 -->

<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input type="hidden" name="CHKDEL"  maxlength="5" size="5" value="<%=""%>">
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<table border="1" cellSpacing="0" cellPadding="0" width="100%" align="center" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
 <tr bgcolor="#CCCC99">
  <td colspan="3">     
     <input name="button" tabindex='19' type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
     <font color="#336699" size="2">-----DETAIL you choosed to be saved-----------------------------------------------------------------------------------------------------------</font>
  </td>  
 </tr>
 <tr bgcolor="#CCCC99">
  <td colspan="3"> 
<%
int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
try
{	
	String a[][]=arrayIQCDocumentInputBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
    if (a!=null) 
	{		//out.println(a[0][0]+ " " +a[0][1]+" " +a[0][2]+" " +a[0][3]+" " +a[0][4]+" " +a[0][5]+" " +a[0][6]+"<BR>");	  
		div1=a.length;
		div2=a[0].length;				
	    arrayIQCDocumentInputBean.setFieldName("ADDITEMS");
		out.println(arrayIQCDocumentInputBean.getArray2DIQCString());  // 用Item 及Item Description 作為Key 的Method
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
 <tr bgcolor="#CCCC99">
   <td colspan="3">
		  <INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmitDel("../jsp/TSIQCInspectLotInput.jsp?INSERT=Y")'  value='刪除' >
<% 
if (isModelSelected =="Y" || isModelSelected.equals("Y")) 
{
%>
<font color='#336699' size='2'>-----CLICK checkbox and choice to delete------------------------------------------------------------------------------------------------------</font>		  
<%
}
//  設定Array 初始內容_起 
%>
   </td>
 </tr>
</table>
<HR>
<table width="100%" align="center" border="1" cellSpacing="0" cellPadding="0" bordercolorlight="#FFFFFF" bordercolordark="#B9BB99">
	<tr bgcolor="#CCCC99">
 		<td width="10%">處理人員</td><td width="30%"><%=UserName%></td>
 		<td width="10%">處理日期</td><td width="20%"><% out.println(dateBean.getYearMonthDay()); %></td> 
		<td width="10%">處理時間</td><td width="20%"><%out.println(dateBean.getHourMinuteSecond());%></td>  
	</tr>
<%
try
{  
	out.println("<tr bgcolor='#CCCC99'>");
 	out.println("<td>執行動作</td>");

	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("select x1.ACTIONID, x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='QC' and FROMSTATUSID='021' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID <>'021' and  x1.LOCALE='886' order by 2");
	out.println("<td>");
	out.println("<select NAME='ACTIONID' onChange='setAction(this.form.ACTIONID.value);'>");
	out.println("<OPTION VALUE=-->--");
	while (rs.next())
	{            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
        	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } 
		else 
		{
        	out.println("<OPTION VALUE='"+s1+"'>"+s2);
        }        
	}
	out.println("</select>"); 
	rs.close();
	statement.close();
	
	out.println("<INPUT name='button2' tabindex='20' TYPE='button' onClick='setSubmitSave("+'"'+"../jsp/TSIQCInspectLotMInsert.jsp?INSERT=Y"+'"'+")' value='Submit' ><INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked><span id='dv1'>郵件通知</span><br><font size=2 color=#ff0000>(註:有關USD退貨請ACCEPT後再開出庫單)</font></td>");   
   	out.println("<td>檢驗單位</td><td><font face='Arial'>"+userInspDeptID+"("+userInspDeptName+")"+"</font></td>");
   	out.println("<td>檢驗人員</td><td><font face='Arial'>"+userInspectorID+"("+userInspectorName+")"+"</font></td>");
 	out.println("</tr>");
}
catch(Exception e)
{
	out.println("Error:"+e.getMessage());
}
%>
	<tr id="tr1" bgcolor="#99CC99"> 
    	<td style="color:#FF0000">不良原因說明:</td>
        <td colspan="5"><INPUT TYPE="TEXT"   NAME="NGREASON"   SIZE=100 maxlength="60" value="<%=NGREASON%>"></td>
    </tr>          
	
</table>
<input name="TOTLINES" type="HIDDEN" value="<%=rs1__index+1%>">
<input name="FORMID" type="HIDDEN" value="QC">	
<input name="FROMSTATUSID" type="HIDDEN" value="020">
<input name="FROMPAGE" type="HIDDEN" value="TSIQCInspectLotInput.jsp"> 
<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
<input name="INSPLOTNO" type="HIDDEN" value="<%=inspLotNo%>">
<input name="RECEIPTSOURCE" type="HIDDEN" value="<%=receiptSource%>">
<input name="VENDOR" type="hidden" size="25" value="<%=supplierName%>" readonly>
<input name="QCDEPTID" type="HIDDEN" value="<%=userInspDeptID%>">
<input name="QCINSPECTOR" type="HIDDEN" value="<%=userInspectorName%>">
<input type="hidden" name="ORGANIZATIONID" value="<%=organizationId%>"  size="5">
<input type="hidden" name="IDCODEGET" value="<%=iDCodeGet%>"  size="5">
<input type="hidden" name="CHOICEARRAY" value="<%=choiceArr%>"  size="5">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
