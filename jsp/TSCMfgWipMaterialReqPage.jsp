<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>WIP Material Requirement Issue Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean,CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<jsp:useBean id="array2DWIPIssueByItemBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DWIPIssueByWoBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrayWIPEntityIDBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
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
function NeedConfirm()
{ 
 flag=confirm("是否確定刪除?"); 
 return flag;
}
function calDefaultIssQty(xINDEX,minPQty,remainIssQty,remainInvQty,remainLotQty)
{    
  formMINPQTY = "document.DISPLAYREPAIR.MINPQTY"+xINDEX+".focus()";
  formMINPQTY_Write = "document.DISPLAYREPAIR.MINPQTY"+xINDEX+".value";
  xMINPQTY = eval(formMINPQTY_Write);  // 把值取得給java script 變數
  
  formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數 
  
  formSUBINVENTORY = "document.DISPLAYREPAIR.SUBINVENTORY"+xINDEX+".focus()";
  formSUBINVENTORY_Write = "document.DISPLAYREPAIR.SUBINVENTORY"+xINDEX+".value";
  xSUBINVENTORY = eval(formSUBINVENTORY_Write);  // 把值取得給java script 變數  
  
  if (eval(formSUBINVENTORY_Write)==null || eval(formSUBINVENTORY_Write)=="")
  {
    if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
    {    
      alert("請先選擇領料倉別!!!");	
	  document.DISPLAYREPAIR.elements['SUBINVENTORY'+xINDEX].focus();
	  return false;
	}	
  }
  
  // 預計本次待領用量 = ceiling最小包裝量(累計工令待領量 - 儲位剩餘量)    天花板函數
  var calculateIssQty = 0; // 
  //var calculateLotQty = remainLotQty;
  if (remainInvQty=="0.0" || eval(remainInvQty)==0) 
  {
    if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
    { 
     alert("庫存餘額不足,此筆工令所需料品無法執行領料作業!!!");
	 return false;
	}
  }
  else{   
          if (minPQty=="0.0" || eval(minPQty)==0)
          {
		    if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
            { 
             alert("  此料號於料件主檔無最小包裝量設定\n請手動輸入最小包裝量方能計算本次預計領用量!!!");
			}
			//eval(formMINPQTY);	// 讓最小包裝欄位取得焦點		
          } else {
		            
					var movInvQty =0 ;
					var movLotQty =0 ;
					
					var quotQty =  remainIssQty/minPQty; // 商
					var remdQty =  remainIssQty%minPQty; // 餘數
					//alert("quotQty商="+quotQty);
					//alert("remdQty餘="+remdQty);
					if (eval(remdQty) > 0)
					{ // 餘數不為零,要取最小包裝量計算
					   calculateIssQty = (Math.ceil(quotQty))*minPQty; // 本次預計領用量 = (商 + 1)*最小包裝量
					   //alert("calculateIssQty(餘數<>0)="+calculateIssQty);
					} else { // 餘數=0
					          //alert("calculateIssQty(餘數=0)="+calculateIssQty);
					          calculateIssQty =quotQty*minPQty; // 本次預計領用量 = (商)*最小包裝量
					        }
					//formINPUTQTY_Write = calculateIssQty;
					var reLotQtyTmp = remainLotQty;// 先把剩餘儲位數量給暫存;					
					remainLotQty = remainLotQty - calculateIssQty; // 剩餘儲位量 = 原儲位剩餘量 - 本次計算預計領用量
					//alert("remainLotQty 1 ="+remainLotQty);
					if (eval(remainLotQty)<0)  // 若計算剩餘儲位量<0 則將顯示值設為零,其餘扣除庫存可用數
					{    
					    remainInvQty=remainInvQty-Math.abs(remainLotQty); // 庫存可用量 = 原庫存可用量 - 不足儲位剩餘量
						//remainInvQty=remainInvQty-calculateIssQty+
						//alert("remainInvQty 2 ="+remainInvQty);
					    //remainLotQty=0;	
						movInvQty = Math.abs(remainLotQty); // 把儲位不足的剩餘量作為此次要Move的庫存異動量	
						movLotQty = Math.abs(reLotQtyTmp); // 本次的儲位移動數即為暫存數		
						remainLotQty=0;	  // 儲位剩餘量 就扣完
					} else {
					          
					          movInvQty = 0; // 因為儲位仍有足夠量,故本次要Move的庫存異動量=0
					          movLotQty = Math.abs(calculateIssQty); // 此次要Move的儲位異動量 = 計算的預計領用量
							  //alert("movLotQty 3 ="+movLotQty);
					        }
					 
					
					 //getInputQty(xINDEX,remainInvQty, movInvQty, remainLotQty, movLotQty, calculateIssQty); // 把值傳給給預計值函數(庫存可用量,剩餘儲位量,本列預計領用量)
					 if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
                     { 			
					   //formINPUTQTY_Write=calculateIssQty;
					   //alert(formINPUTQTY_Write);
					  // document.form.elements['name'];
					   document.DISPLAYREPAIR.elements['REINVQTY'+xINDEX].value =remainInvQty;   // On Day Effort
					   document.DISPLAYREPAIR.elements['MOVINVQTY'+xINDEX].value =movInvQty;
					   document.DISPLAYREPAIR.elements['RELOTQTY'+xINDEX].value =remainLotQty;
					   document.DISPLAYREPAIR.elements['MOVLOTQTY'+xINDEX].value =movLotQty;
					   document.DISPLAYREPAIR.elements['MINPQTY'+xINDEX].value =minPQty;
					   document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value =calculateIssQty; // On Day Effort
					   document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].focus();
					   //getInputQty(xINDEX, remainInvQty, movInvQty, remainLotQty, movLotQty, calculateIssQty); // 把值傳給給預計值函數(庫存可用量,剩餘儲位量,本列預計領用量)					 	  
				 	 }	
		          }
      }
} 
function setInputAdd(URL,xINDEX,xIDCODEGET,minPQty,remainIssQty,remainInvQty,remainLotQty)
{
  formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數
  
  formSUBINVENTORY = "document.DISPLAYREPAIR.SUBINVENTORY"+xINDEX+".focus()";
  formSUBINVENTORY_Write = "document.DISPLAYREPAIR.SUBINVENTORY"+xINDEX+".value";
  xSUBINVENTORY = eval(formSUBINVENTORY_Write);  // 把值取得給java script 變數  
  //alert("minPQty="+minPQty);
  //alert("remainIssQty="+remainIssQty);
  //alert("remainInvQty="+remainInvQty);
  //alert("remainLotQty="+remainLotQty);
  
  if (eval(formSUBINVENTORY_Write)==null || eval(formSUBINVENTORY_Write)=="")
  {
    alert("請先選擇領料倉別!!!");
	document.DISPLAYREPAIR.elements['SUBINVENTORY'+xINDEX].focus();
	return false;
  }
  
  // 預計本次待領用量 = ceiling最小包裝量(累計工令待領量 - 儲位剩餘量)    天花板函數
  var calculateIssQty = 0; // 
  //var calculateLotQty = remainLotQty;
  if (remainInvQty=="0.0" || eval(remainInvQty)==0) 
  {    
     alert("庫存餘額不足,此筆工令所需料品無法執行領料作業!!!");
	 return false;	 
  }
  else{   
          if (minPQty=="0.0" || eval(minPQty)==0)
          {
		     
             alert("  此料號於料件主檔無最小包裝量設定\n請手動輸入最小包裝量方能計算本次預計領用量!!!");
			 
			//eval(formMINPQTY);	// 讓最小包裝欄位取得焦點		
          } else {
		            
					var movInvQty =0 ;
					var movLotQty =0 ;
					
					var quotQty =  remainIssQty/minPQty; // 商
					var remdQty =  remainIssQty%minPQty; // 餘數
					//alert("quotQty商="+quotQty);
					//alert("remdQty餘="+remdQty);
					if (eval(remdQty) > 0)
					{ // 餘數不為零,要取最小包裝量計算
					   calculateIssQty = (Math.ceil(quotQty))*minPQty; // 本次預計領用量 = (商 + 1)*最小包裝量
					   //alert("calculateIssQty(餘數<>0)="+calculateIssQty);
					} else { // 餘數=0
					          //alert("calculateIssQty(餘數=0)="+calculateIssQty);
					          calculateIssQty =quotQty*minPQty; // 本次預計領用量 = (商)*最小包裝量
					        }
					//formINPUTQTY_Write = calculateIssQty;
					var reLotQtyTmp = remainLotQty;// 先把剩餘儲位數量給暫存;					
					remainLotQty = remainLotQty - calculateIssQty; // 剩餘儲位量 = 原儲位剩餘量 - 本次計算預計領用量
					//alert("remainLotQty 1 ="+remainLotQty);
					if (eval(remainLotQty)<0)  // 若計算剩餘儲位量<0 則將顯示值設為零,其餘扣除庫存可用數
					{    
					    remainInvQty=remainInvQty-Math.abs(remainLotQty); // 庫存可用量 = 原庫存可用量 - 不足儲位剩餘量
						//remainInvQty=remainInvQty-calculateIssQty+
						//alert("remainInvQty 2 ="+remainInvQty);
					    //remainLotQty=0;	
						movInvQty = Math.abs(remainLotQty); // 把儲位不足的剩餘量作為此次要Move的庫存異動量	
						movLotQty = Math.abs(reLotQtyTmp); // 本次的儲位移動數即為暫存數		
						remainLotQty=0;	  // 儲位剩餘量 就扣完
					} else {
					          
					          movInvQty = 0; // 因為儲位仍有足夠量,故本次要Move的庫存異動量=0
					          movLotQty = Math.abs(calculateIssQty); // 此次要Move的儲位異動量 = 計算的預計領用量
							  //alert("movLotQty 3 ="+movLotQty);
					        }					 
					
					   document.DISPLAYREPAIR.elements['REINVQTY'+xINDEX].value =remainInvQty;   // On Day Effort
					   document.DISPLAYREPAIR.elements['MOVINVQTY'+xINDEX].value =movInvQty;
					   document.DISPLAYREPAIR.elements['RELOTQTY'+xINDEX].value =remainLotQty;
					   document.DISPLAYREPAIR.elements['MOVLOTQTY'+xINDEX].value =movLotQty;
					   document.DISPLAYREPAIR.elements['MINPQTY'+xINDEX].value =minPQty;
					   document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value =calculateIssQty; // On Day Effort
					   document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].focus();
					   //getInputQty(xINDEX, remainInvQty, movInvQty, remainLotQty, movLotQty, calculateIssQty); // 把值傳給給預計值函數(庫存可用量,剩餘儲位量,本列預計領用量)					 	  
				 	 	
		          }
      } // End of 計算各Item的各欄位數量
  
  document.DISPLAYREPAIR.action=URL+"&IDCODEGET="+xIDCODEGET+"&XINDEX="+xINDEX;
  document.DISPLAYREPAIR.submit();
  
}
function subWindowSubInventoryFind(organizationID,subInv,subInvDesc,xIndex, invItemID)
{    
  //subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  subWin=window.open("../jsp/subwindow/TSCWipSubOnHandFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc+"&XINDEX="+xIndex+"&INVITEMID="+invItemID,"subwin","width=640,height=480,status=yes,menubar=yes,scrollbars=yes");  
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<style type="text/css">
<!--

-->
</style>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
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
.style4 {
	font-size: 18px;
	color: #993300;
}
</STYLE>
</head>
<%
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM action="../jsp/TSCMfgWipMaterialReqPage.jsp" method="post" name="DISPLAYREPAIR">
<%

   int iSeqNum = 0;

  String serverHostName=request.getServerName();
  String pageCh=request.getParameter("PAGECH");
  String customerID=request.getParameter("CUSTOMERID");
  String organizationID=request.getParameter("ORGANIZATIONID");
  String iDCodeGet=request.getParameter("IDCODEGET");
  
  String xIndex=request.getParameter("XINDEX");
  
  String insertPage=request.getParameter("INSERT");  
  
  String [] choice=request.getParameterValues("CH");
  
  String subInventory = request.getParameter("SUBINVENTORY");
  
  out.println(serverHostName);
  
   if (xIndex==null || xIndex.equals("")) xIndex = "0";
  
   int commitmentMonth=0;
   array2DWIPIssueByItemBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
   String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
   String isModelSelected=request.getParameter("ISMODELSELECTED");  
   
     String [] addItems=request.getParameterValues("ADDITEMS");	
  
    String iNo=request.getParameter("INO");
  
    String movInvQty=request.getParameter("MOVINVQTY"+xIndex);
    String movLotQty=request.getParameter("MOVLOTQTY"+xIndex);
	String minPQty=request.getParameter("MINPQTY"+xIndex);
    String invItemID="";
	String invItemNo=request.getParameter("INVITEMNO"+xIndex);
	String invItemDesc=request.getParameter("INVITEMDESC"+xIndex);
	String transactQty=request.getParameter("INPUTQTY"+xIndex);
	String transactUOM=request.getParameter("TRANSACTUOM"+xIndex);
	String whsCode = request.getParameter("SUBINVENTORY"+xIndex);
	
	out.println("transactQty="+transactQty);
	out.println("movInvQty="+movInvQty);
	out.println("movLotQty="+movLotQty);
	
	int inpLen = 0;
	 
  
   String seqno=null;
   String seqkey=null;
   String dateString=null;
   String issueWipNo = "";
   String locatorID = "000";
   
  if (pageCh==null || pageCh.equals("")) pageCh = "ITEM";
  
  //if (subInventory)
  
 
  
  //if (custINo==null || custINo.equals("")) custINo = "1";
  if (iNo==null || iNo.equals("")) iNo = "1"; 
  
  if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
  
  
  String sqlTC = "";
  
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
  
  
  //int chCount = choice.length;
  //if (choice==null) chCount = 0;
  
  //String wipEntityCh[]=new String[chCount]; // 宣告一維陣列
  
  if (iDCodeGet==null || iDCodeGet.equals("null")) iDCodeGet= "";
  String IDDesc = null;   
  int iDCodeGetLength = 0;   
  //out.println("user choice 2 ");  
  if (choice!=null)
  {
     for (int k=0;k<choice.length;k++)    
     {  
	   IDDesc = choice[k];
	   iDCodeGet = iDCodeGet+IDDesc+",";	
	   //wipEntityCh[k]=choice[k];
     }
	 
	  if (iDCodeGet.length()>0)
      { //out.println(iDCodeGet);     
        iDCodeGetLength = iDCodeGet.length()-1;
        iDCodeGet = iDCodeGet.substring(0,iDCodeGetLength);
      } 
	  //arrayWIPEntityIDBean.setArrayString(wipEntityCh);	 //	將選擇的WipEntityID 放入Array內
  }
  //
  out.println(iDCodeGet); 
  
    String [] allMonth={iNo,iDCodeGet,invItemID,invItemNo,invItemDesc,transactUOM,whsCode,movInvQty,movLotQty,minPQty,transactQty};
    String entry=request.getParameter("ENTRY");         
    if (entry==null || entry.equals("") )  {  }
    else { array2DWIPIssueByItemBean.setArray2DString(null); } 
  
   // 自己這頁已選的不入候選清單內_起 array2DWIPIssueByItemBean
  String g[][]=array2DWIPIssueByItemBean.getArray2DContent();//取得目前陣列內容	 
  
  if (array2DWIPIssueByItemBean!=null)
  {
    //out.println("&nbsp;"+arrIQCSearch[0][0]);out.println("&nbsp;"+arrIQCSearch[0][1]);out.println("&nbsp;"+arrIQCSearch[0][2]);out.println("&nbsp;"+arrIQCSearch[0][3]);out.println("&nbsp;"+arrIQCSearch[0][4]);out.println(arrIQCSearch[0][5]+"<BR>");
	//out.println("&nbsp;"+arrIQCSearch[1][0]);out.println("&nbsp;"+arrIQCSearch[1][1]);out.println("&nbsp;"+arrIQCSearch[1][2]);out.println("&nbsp;"+arrIQCSearch[1][3]);out.println("&nbsp;"+arrIQCSearch[1][4]);out.println(arrIQCSearch[1][5]+"<BR>");
	//out.println("&nbsp;"+arrIQCSearch[2][0]);out.println("&nbsp;"+arrIQCSearch[2][1]);out.println("&nbsp;"+arrIQCSearch[2][2]);out.println("&nbsp;"+arrIQCSearch[2][3]);out.println("&nbsp;"+arrIQCSearch[2][4]);out.println(arrIQCSearch[2][5]+"<BR>");
  }
  
  
  
 //  設定Array 初始內容_起 
  if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
  {    
	array2DWIPIssueByItemBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  } else {
            
          String sp[][]=array2DWIPIssueByItemBean.getArray2DContent();//若為輸入模式,且內容不為null,則將陣列entity給全域變數 inpLen     
		  if (sp != null)
		  {
		   inpLen = sp.length; // 把已輸入的內容個數傳給此全域變數,做為判斷是否可重選樣本訂單依據
		   //out.println("inpLen ="+inpLen);
		  } 
         }
  
 try 
 {   
 
   String at[][]=array2DWIPIssueByItemBean.getArray2DContent();//取得目前陣列內容     
  //*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
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
		   }  //end for array second layer count
	  } //end for array first layer count
   	  array2DWIPIssueByItemBean.setArray2DString(at);  //reset Array
   }   //end if of array !=null
   //********************************************************************
   
   // 把 at.length() 值給 custINo作為目前預設的項次編號 kerwin 2006/02/17
   //if (custINo==null || custINo.equals("")) custINo="1";
   //else custINo = at.length();
 
  if (addItems!=null) //若有選取則表示要作刪除
  { 
    String a[][]=array2DWIPIssueByItemBean.getArray2DContent();//重新取得陣列內容        
    if (a!=null && addItems.length>0)      
    { 		 
	 if (a.length>addItems.length)
	 {	  	  	    
       String t[][]=new String[a.length-addItems.length][a[0].length];   // 新陣列的大小= [原始列-選擇刪除列][行]  = [列][行]   
	   int cc=0; 
	   for (int m=0;m<a.length;m++) // 處理列
	   {
	    String inArray="N";		
		for (int n=0;n<addItems.length;n++)  // 處理行
		{
		 if (addItems[n].equals(a[m][0])) inArray="Y"; // *** 指的是 比較 刪除的 CheckBox(AddItems) 被選起來 ***
		} //end of for addItems.length  		 
		if (inArray.equals("N"))  // 沒被刪除的放進來
		{
		  for (int gg=0;gg<10;gg++) //置入陣列中元素數(注意..此處決定了陣列的Entity數目,若不同Entity數,必需修改此處,否則Delete 不Work)
		  {                          // 目前共10個{ iNo,interfaceID,receiptNumber,invItemNo,invItemDesc,transactQty,supSiteID,authorNo,supLotNo,inspReq }      
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
		}  
	   } //end of if a.length		     
	   array2DWIPIssueByItemBean.setArray2DString(t);	  
	 } else { 	//else (a!=null && addItems.length>0 )  			 
	          //array2DWIPIssueByItemBean.setArray2DString(null); //若陣列內容不為空,且addItems.length>0,則將陣列內容清空
			   if (a.length==addItems.length)
			   { 
			     array2DWIPIssueByItemBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空 
				 inpLen = 0; // 清空,則重設為零
			   } // End of if (a.length==addItems.length)
	        }  
	}//end of if a!=null
  } 
 
    if ( bringLast!=null  && bringLast.equals("Y"))  //若要帶出前一版本資料則執行以下動作
    {
   
    } //enf of bringLast if   
  //dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
   out.println("Exception:"+e.getMessage());
}   
  
// 若單號未取得,則呼叫取號程序
try
{ 
  // 內銷的Loation Id若為內銷
  if (organizationID.equals("326")) locatorID = userMfgDemLoc;
  else if (organizationID.equals("327")) locatorID = userMfgExpLoc;  
  // 否則為外銷LocationId
  

  if (issueWipNo==null || issueWipNo.equals(""))
  {  
   dateString=dateBean.getYearMonthDay();   
   //seqkey="TS"+userActCenterNo+dateString;  //qcAreaNo
   //out.println("qcAreaNo="+qcAreaNo);
   if (organizationID==null || organizationID.equals("--")) seqkey="WI"+locatorID+dateString; //但仍以預設為使用者地區
   else seqkey="WI"+locatorID+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號   
   //====先取得流水號=====  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select * from APPS.YEW_WIP_DOCSEQ where header='"+seqkey+"' and TYPE ='WI' ");
  
   if (rs.next()==false)
   {   
    String seqSql="insert into APPS.YEW_WIP_DOCSEQ values(?,?,?)";   
    PreparedStatement seqstmt=con.prepareStatement(seqSql);     
    seqstmt.setString(1,seqkey);
    seqstmt.setInt(2,1);   
	seqstmt.setString(3,"WI");
	
    seqstmt.executeUpdate();
    seqno=seqkey+"-001";
    seqstmt.close();   
   } 
   else 
   {
    int lastno=rs.getInt("LASTNO");
      
    String sql = "select * from APPS.YEW_ISSUEREQ_ALL where substr(WISSUE_NO,1,13)='"+seqkey+"' and to_number(substr(WISSUE_NO,15,3))= '"+lastno+"' ";
    ResultSet rs2=statement.executeQuery(sql); 
    //===(處理跳號問題)若TSCIQC_LOTINSPECT_HEADER及TSDOCSEQ皆存在相同最大號=========依原方式取最大號 //
    if (rs2.next())
    {         
      lastno++;
      String numberString = Integer.toString(lastno);
      String lastSeqNumber="000"+numberString;
      lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
      seqno=seqkey+"-"+lastSeqNumber;     
   
      String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE ='WI' ";   
      PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      seqstmt.setInt(1,lastno);   
	
      seqstmt.executeUpdate();   
      seqstmt.close(); 
    } 
    else
    {
      //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
      String sSqlSeq = "select to_number(substr(max(WISSUE_NO),15,3)) as LASTNO from APPS.YEW_ISSUEREQ_ALL where substr(WISSUE_NO,1,13)='"+seqkey+"' ";
      ResultSet rs3=statement.executeQuery(sSqlSeq);
	 
	  if (rs3.next()==true)
	  {
       int lastno_r=rs3.getInt("LASTNO");
	  
	   lastno_r++;
	  
	   String numberString_r = Integer.toString(lastno_r);
       String lastSeqNumber_r="000"+numberString_r;
       lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	   String seqSql="update APPS.YEW_WIP_DOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"' and TYPE ='WI' ";   
       PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       seqstmt.setInt(1,lastno_r);   
	
       seqstmt.executeUpdate();   
       seqstmt.close();  
	  }  // End of if (rs3.next()==true)
   
     } // End of Else  //===========(處理跳號問題)
    } // End of Else    
	//docNo = seqno; // 把取到的號碼給本次輸入
	issueWipNo = seqno; // 把取到的號碼給本次輸入
	//out.println("issueWipNo ="+issueWipNo);
  } // End of if (docNo==null || docNo.equals(""))	
  else {
          String issueWipNoSub = issueWipNo.substring(5,issueWipNo.length());
		  //out.println("inspLotNoSub="+inspLotNoSub);
          issueWipNo = "WO"+locatorID+issueWipNoSub;
		  //out.println("inspLotNoSub ="+inspLotNoSub);
       }	 
 } //end of try
 catch (Exception e)
 {
  out.println("Exception:"+e.getMessage());
 }
 //out.println(customerId);
 //out.println(customerIdTmp);
  
  String wipIssueByItemInfo[]=new String[10]; // 宣告一維陣列,將IssueByItem設定資訊置入Array
  String wipIssueByWoInfo[]=new String[10];   // 宣告一維陣列,將IssueByWo設定資訊置入Array
  
  String p[]=array2DWIPIssueByItemBean.getArrayContent(); // 取一維陣列內容
  if (p!=null)
  {
    //out.println(array2DWIPIssueByItemBean.getArrayString()); // 把內容印出來
	//out.println("a[0]="+a[0]+ " a[1]=" +a[1]+" a[2]=" +a[2]+" a[3]="+a[3]+ " a[4]=" +a[4]+" a[5]=" +a[5]+"<BR>"); 
  }
  
  String q[]=array2DWIPIssueByWoBean.getArrayContent(); // 取一維陣列內容
  if (q!=null)
  {
    //out.println(array2DWIPIssueByItemBean.getArrayString()); // 把內容印出來
	//out.println("b[0]="+b[0]+ " b[1]=" +b[1]+" b[2]=" +b[2]+" b[3]=" +b[3]+" b[4]="+b[4]+ " b[5]=" +b[5]+" b[6]=" +b[6]+" b[7]=" +b[7]+" b[8]=" +b[8]+" b[9]=" +b[9]+"<BR>"); 
  }
  
  String sqlItem = "";
  String whereItem = "";
 String orderItem = "";
 Statement stateTC=null;
 ResultSet rsTC =null;

 
 if (pageCh.equals("ITEM"))
 { 
    sqlItem = " select SUM(WRO.REQUIRED_QUANTITY) as REQUIRED_QUANTITY, "+
	                 " SUM(WRO.QUANTITY_ISSUED) as QUANTITY_ISSUED, WRO.SEGMENT1, MSI.PRIMARY_UOM_CODE, WRO.QUANTITY_PER_ASSEMBLY, "+
					 " MSI.INVENTORY_ITEM_ID, MSI.DESCRIPTION, decode(MSI.LOT_CONTROL_CODE, '1','N','2','Y','N') as LOT_CONTROL_CODE "+
	                 " from WIP_REQUIREMENT_OPERATIONS WRO, MTL_SYSTEM_ITEMS MSI, WIP_ENTITIES WE ";
	whereItem = " where WRO.INVENTORY_ITEM_ID = MSI.INVENTORY_ITEM_ID "+
	            "   and WRO.WIP_ENTITY_ID = WE.WIP_ENTITY_ID "+
				"   and WRO.WIP_SUPPLY_TYPE = 1 and MSI.ORGANIZATION_ID = '"+organizationID+"' "+
				"   and WRO.WIP_ENTITY_ID in ("+iDCodeGet+") ";
	orderItem = " group by WRO.SEGMENT1, MSI.PRIMARY_UOM_CODE, WRO.QUANTITY_PER_ASSEMBLY, MSI.INVENTORY_ITEM_ID, MSI.DESCRIPTION, MSI.LOT_CONTROL_CODE "+
	            " order by WRO.SEGMENT1 ";	     
	
	//if () 
	sqlItem = sqlItem + whereItem + orderItem;
	sqlTC = sqlItem;
	stateTC=con.createStatement(); 
    rsTC = stateTC.executeQuery(sqlTC);
  
 } // End of if (deliverTo==null || deliverTo.equals("") || deliverTo.equals("null"))
 else {       
         //若前一頁未取得DELIVER_TO 則,本頁預設由CUSTOMER_ID取_迄
		 
		 sqlItem = sqlItem + whereItem + orderItem;
	     sqlTC = sqlItem;
	     stateTC=con.createStatement(); 
         rsTC = stateTC.executeQuery(sqlTC);  
  
      } // End of if (pageCh.equals("WO"))
  
  //out.println(deliverTo);
 /* 
  String a[]=array2DWIPIssueByItemBean.getArrayContent(); // 取一維陣列內容
  if (a!=null)
  {
    //out.println(array2DWIPIssueByItemBean.getArrayString()); // 把內容印出來
	out.println("a[0]="+a[0]+ " a[1]=" +a[1]+" a[2]=" +a[2]+" a[3]=" +a[3]+" a[4]=" +a[4]+" a[5]=" +a[5]+" a[6]=" +a[6]+"<BR>"); 
  }
  */
  String imgBaseL = "images/tl_j.gif";
  String imgBaseC = "images/tc_j.gif";
  String imgBaseR = "images/tr_j.gif";
  String imgChoseL = "images/ttl_j.gif";
  String imgChoseC = "images/ttc_j.gif";
  String imgChoseR = "images/ttr_j.gif";
  
 
%>
<table width='85%'  cellspacing=0 cellpadding=2 border=0>
<tr><td align='left' colspan=3>
</td></tr>
<tr ><td><font size="5" color="#003399" face="Georgia"><strong>WIP工令領料申請單</strong></font><strong>(<font color="#993300" size="3"><%=issueWipNo%></font>)</strong></td>
</tr>
</table>
<BR />
<TABLE WIDTH='85%'  CELLSPACING=0 CELLPADDING=0 border=0>
<TR>
<TD align=left width="100%">
 <TABLE CELLSPACING=0 CELLPADDING=0 border=0 align="left">
   <TR>   
    <td width=9><img src='<% if (pageCh.equals("ITEM")) out.print(imgChoseL); else out.println(imgBaseL); %>' width=9 height=27></td><td background='<% if (pageCh.equals("ITEM")) out.print(imgChoseC); else out.println(imgBaseC); %>'>
	<a href="../jsp/TSCMfgWipMaterialReqPage.jsp?PAGECH=ITEM&ORGANIZATIONID=<%=organizationID%>&IDCODEGET=<%=iDCodeGet%>&NLOCATIONID=<%=%>&NOTIFYLOCATION=<%=%>&NSHIPCONTID=<%=%>&SHIPCONTACT=<%=%>&DELIVERCUSTOMER=<%=%>&DELIVERLOCATION=<%=%>&DELIVERTO=<%=%>&DELIVERADDRESS=<%=%>&CUSTOMERID=<%=%>"><font color=black>
	工令料號    
	</font></a>
	</td>
    <td width=9><img src='<% if (pageCh.equals("ITEM")) out.print(imgChoseR); else out.println(imgBaseR); %>' width=9 height=27></td>	
    <td width=9><img src='<% if (pageCh.equals("WO")) out.print(imgChoseL); else out.println(imgBaseL); %>' width=9 height=27></td><td background='<% if (pageCh.equals("WO")) out.print(imgChoseC); else out.println(imgBaseC); %>'>
	<a href="../jsp/TSCMfgWipMaterialReqPage.jsp?PAGECH=WO&ORGANIZATIONID=<%=organizationID%>&IDCODEGET=<%=iDCodeGet%>&NLOCATIONID=<%=%>&NOTIFYLOCATION=<%=%>&NSHIPCONTID=<%=%>&SHIPCONTACT=<%=%>&DELIVERCUSTOMER=<%=%>&DELIVERLOCATION=<%=%>&DELIVERTO=<%=%>&DELIVERADDRESS=<%=%>&CUSTOMERID=<%=%>&DCUSTOMERID=<%=%>&DELIVERCUSTOMER=<%=%>"><font color=black>
	工令站別
	</font></a>
	</td><td width=9><img src='<% if (pageCh.equals("WO")) out.print(imgChoseR); else out.println(imgBaseR); %>' width=9 height=27></td>
   </TR>
  </TABLE>
</TD>
</TR>
</TABLE>
<%
 if (pageCh.equals("ITEM"))
 {
   //moContactInfo[0] = notifyContact;
   //moContactInfo[1] = notifyLocation;
   //moContactInfo[2] = shipContact;
   //array2DWIPIssueByItemBean.setArrayString(moContactInfo);     
%>
<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
<tr bgcolor="#D5D8A7">
<td width="3">&nbsp;</td>
<td width="14%" nowrap><font color="#993300"><b>料號品名</b></font></td>
<td width="3%" nowrap><font color='#993300'>單位</font></td>
<td width="3%" nowrap><font color='#993300'>批號控管</font></td>
<td width="9%" nowrap><font color='#993300'>組裝單位量</font></td>
<td width="11%" nowrap><font color='#993300'>累計工令需求量</font></td>
<td width="11%" nowrap><font color='#993300'>累計工令已領量</font></td>
<td width="11%" nowrap><font color='#993300'>累計工令待領量</font></td>
<td width="7%" nowrap><font color='#993300'>庫存可用量</font></td>
<td width="7%" nowrap><font color='#993300'>儲位剩餘量</font></td>
<td width="6%" nowrap><font color='#993300'>領料倉別</font></td>
<td width="7%" nowrap><font color='#993300'>最小包裝量</font></td>
<td width="11%" nowrap><font color='#993300'>預計領用量</font></td>
</tr>
<%
   String colorStr = "";
   while (rsTC.next())
   {
      if ((iSeqNum % 2) == 0){
	       colorStr = "#D5D8A7";
	    }
	    else{
	          colorStr = "#DFE0AD"; }
     iSeqNum++; 
	 invItemID = rsTC.getString("INVENTORY_ITEM_ID");
	 invItemNo = rsTC.getString("SEGMENT1");
	 invItemDesc = rsTC.getString("DESCRIPTION");
	 //transactUOM =  rsTC.getString("DESCRIPTION");
%>
<tr bgcolor="<%=colorStr%>">
<td nowrap align=center width="3%"><font color='#993300'><%=iSeqNum%></font></td>
<td nowrap align=right><font color='#993300'><%=rsTC.getString("SEGMENT1")%></font></td>
<td nowrap align=right><font color='#993300'><%=rsTC.getString("PRIMARY_UOM_CODE")%><input name="TRANSACTUOM<%=iSeqNum%>" type="hidden" value="<%=rsTC.getString("PRIMARY_UOM_CODE")%>" size="5" /></font></td>
<td nowrap align=right><font color='#993300'><%=rsTC.getString("LOT_CONTROL_CODE")%></font></td>
<td nowrap align=right><font color='#993300'><%=rsTC.getString("QUANTITY_PER_ASSEMBLY")%></font></td>
<td align=right><font color='#993300'><b><%=rsTC.getString("REQUIRED_QUANTITY")%></b></font></td>
<td align=right><font color='#993300'><b><%=rsTC.getString("QUANTITY_ISSUED")%></b></font></td>
<td align=right><font color='#993300'><b><%=rsTC.getFloat("REQUIRED_QUANTITY")-rsTC.getFloat("QUANTITY_ISSUED")%><input name="REISSQTY<%=iSeqNum%>" type="hidden" value="<%=rsTC.getFloat("REQUIRED_QUANTITY")-rsTC.getFloat("QUANTITY_ISSUED")%>" size="5" /></b></font></td>
<td align=right nowrap><font color='#993300'><b>
          <%//
		       // 取不分倉別的庫存可用數_起
			    /*
			      CallableStatement csOnHand = con.prepareCall("{? = call INV_ITEM_INQ.GET_AVAILABLE_QTY(?,?,?,?,?,?,?,?,?,?)}");
			      csOnHand.registerOutParameter(1, Types.NUMERIC);        // 回傳 OnHandQty 			   	
			      csOnHand.setInt(2,Integer.parseInt(organizationID));    //  OrganizationID			  
			      csOnHand.setInt(3,rsTC.getInt("INVENTORY_ITEM_ID"));    //  p_inventory_item_id 			   
			      csOnHand.setString(4,"NULL");                           //  p_revision	
			      csOnHand.setString(5,"NULL");                           //  p_subinventory_code
			      csOnHand.setInt(6,0);                                   //  p_locator_id   
			      csOnHand.setString(7,"NULL");                           //  p_lot_number
			      csOnHand.setInt(8,0);                                   //  p_cost_group_id		
			      csOnHand.setString(9,"FALSE");                          //  p_revision_control 
			      csOnHand.setString(10,"TRUE");                          //  p_lot_control	
			      csOnHand.setString(11,"FALSE");                         //  p_serial_control 
				  csOnHand.execute();
			      float onHandQty = csOnHand.getFloat(1);                 //
				  csOnHand.close();
				  out.println(onHandQty);	
				*/  
				float reInvQty = 0;
				String sqlOnHand = "select sum(PRIMARY_TRANSACTION_QUANTITY) from MTL_ONHAND_QUANTITIES_DETAIL where INVENTORY_ITEM_ID ="+rsTC.getInt("INVENTORY_ITEM_ID")+" and ORGANIZATION_ID="+organizationID+"  ";	
				Statement stateOnHand=con.createStatement(); 
                ResultSet rsOnHand = stateOnHand.executeQuery(sqlOnHand); 
				if (rsOnHand.next()) 
				{
			     out.println(rsOnHand.getFloat(1));
				 reInvQty = rsOnHand.getFloat(1);
				}
				rsOnHand.close();
				stateOnHand.close();
				 
		  %><input type="text" name="REINVQTY<%=iSeqNum%>" size="3" value="<%=reInvQty%>" />
		    <input type="text" name="MOVINVQTY<%=iSeqNum%>" size="3" value="<%=%>" />
		  </b></font></td>
<td align=right nowrap><font color='#993300'><b>
          <%//  
		        float reLotQty = 0;
		        String sqlOnLoc = " select sum(PRIMARY_TRANSACTION_QUANTITY) from MTL_ONHAND_QUANTITIES_DETAIL "+
				                  " where INVENTORY_ITEM_ID ="+rsTC.getInt("INVENTORY_ITEM_ID")+" "+
								  "   and ORGANIZATION_ID="+organizationID+"  "+                 // 取內外銷下
								  "   and LOCATOR_ID in ("+userMfgDemLoc+","+userMfgExpLoc+") "; // 使用者所屬製造部下的Location
				Statement stateOnLoc=con.createStatement(); 
                ResultSet rsOnLoc = stateOnLoc.executeQuery(sqlOnLoc); 
				//out.println(sqlOnLoc);
				if (rsOnLoc.next()) 
				{
			     //out.println(rsOnLoc.getFloat(1));
				 reLotQty = rsOnLoc.getFloat(1);
				}
				rsOnLoc.close();
				stateOnLoc.close();
		  
		  %><input type="text" name="RELOTQTY<%=iSeqNum%>" size="5" value="<%=reLotQty%>" class="selStyle" />
		   <input type="text" name="MOVLOTQTY<%=iSeqNum%>" size="3" value="<%=%>" />
		  </b></font></td>
<td nowrap><font color='#993300'><b>
        <INPUT TYPE="TEXT" id="SUBINVENTORY<%=iSeqNum%>" name="SUBINVENTORY<%=iSeqNum%>" SIZE='3' value="<%=%>" >
		<input type='button' name='SUBINVCH<%=iSeqNum%>' value='...' onClick='subWindowSubInventoryFind(<%=organizationID%>,this.form.SUBINVENTORY<%=iSeqNum%>.value,this.form.SUBINVDESC.value,"<%=iSeqNum%>","<%=invItemID%>")'>	
		<INPUT TYPE="hidden" id="SUBINVDESC<%=iSeqNum%>" name="SUBINVDESC<%=iSeqNum%>" SIZE=3 value="<%=%>">	 
</b></font>
</td>
<td align=right><font color='#993300'><b>
          <%out.println("&nbsp;");
		     float minPackQty = 0;
		     // 取料件標準的最小包裝量
			 String sqlMinPQty = "select FIXED_LOT_MULTIPLIER from MTL_SYSTEM_ITEMS where ORGANIZATION_ID = "+organizationID+" ";
		     Statement stateMinPQty=con.createStatement(); 
             ResultSet rsMinPQty = stateMinPQty.executeQuery(sqlMinPQty); 
		     //out.println(sqlMinPQty);
			 if (rsMinPQty.next()) 
		     {
			    minPackQty = rsMinPQty.getFloat(1);  
			 }
			 rsMinPQty.close();
			 stateMinPQty.close();
		    
		  %><input name="MINPQTY<%=iSeqNum%>" size='3' value="<%=minPackQty%>" onkeydown='calDefaultIssQty("<%=iSeqNum%>", this.value, this.form.REISSQTY<%=iSeqNum%>.value, this.form.REINVQTY<%=iSeqNum%>.value, this.form.RELOTQTY<%=iSeqNum%>.value)' /></b></font>
</td>
<td nowrap><font color='#993300'><b>
 <input type="text" name="INPUTQTY<%=iSeqNum%>" value="<%=%>" size="5" />
 <input type="button" name="SETQTY<%=iSeqNum%>" value="新增" size="5" onclick='setInputAdd("../jsp/TSCMfgWipMaterialReqPage.jsp?INSERT=Y&ORGANIZATIONID=<%=organizationID%>","<%=iSeqNum%>",this.form.IDCODEGET.value, this.form.MINPQTY<%=iSeqNum%>.value, this.form.REISSQTY<%=iSeqNum%>.value, "<%=reInvQty%>", "<%=reLotQty%>" )' /></b></font>
</td>
</tr>
<%
  } //end of while (rsTC.next())
  rsTC.close();
  stateTC.close();
%>
<tr bgcolor="#D5D8A7">
<td width="3%" align=center nowrap><font color='#993300'><b></b></font></td>
<td colspan="12"><font color='#993300'><b></b></font></td>
</tr>
<tr bgcolor="#D5D8A7">
  <td colspan="13"><div align="center"><strong>
     <%
	  try
      {	     
        String oneDArray[]= {"","項次","工令資訊","料號識別碼","台半料號","料號說明","單位","領用倉別","庫存領用數","儲位領用數","最小包裝量","預計領用數量"}; 		 	     			  
    	array2DWIPIssueByItemBean.setArrayString(oneDArray);
	     String a[][]=array2DWIPIssueByItemBean.getArray2DContent();//取得目前陣列內容  	   			    
		 int i=0,j=0,k=0;
         String dupFLAG="FALSE";		 
		
	     if (( (invItemNo!=null && !invItemNo.equals("")) || (invItemDesc!=null && !invItemDesc.equals("")) ) && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
		 {  out.println("step1"); 		  
		   
			  
		   // 依使用者輸入的料號ID取其單位 			    
		   if (a!=null) 
		   { out.println("step2");
		     String b[][]=new String[a.length+1][a[i].length];		    			 
			 for (i=0;i<a.length;i++)
			 { //out.println("step3");
			  for (j=0;j<a[i].length;j++)
			  { //out.println("step4");
			    if (a[i][j]!=null && !a[i][j].equals("") && !a[i][j].equals("null")) // 判斷 array內容,不為 null或空值才存入陣列
				{
			      b[i][j]=a[i][j];	
				}  //  不為 null或空值才存入陣列 			    
                //if (a[k][0].equals(orderQty)) { dupFLAG = "TRUE"; }					 			
			  } // End of for (j=0)
			  
			   if (b[k][1]!=null && !b[k][1].equals("") && !b[k][1].equals("null")) //判斷invItemID內容,不為null或空值才累加_起 
			   {
			     k++;
			   } // 判斷invItemID內容,不為null或空值才累加_迄
			 }// End of for (i=0) 
			 
			  iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
			  //out.println(iNo);
			  b[k][0]=iNo;
			  b[k][1]=iDCodeGet;
			  b[k][2]=invItemID;
			  b[k][3]=invItemNo;b[k][4]=invItemDesc;b[k][5]=transactUOM;b[k][6]=whsCode;b[k][7]=movInvQty;b[k][8]=movLotQty;b[k][9]=minPQty;b[k][10]=transactQty;
			  array2DWIPIssueByItemBean.setArray2DString(b);
			 			 			 			 						 			 	   			              
		   } else {	//out.println("step5: 若為第一筆資料,則填入抬頭");	    
		           if (iDCodeGet!=null && !iDCodeGet.equals(""))
				   {        
			        String c[][]={{iNo,iDCodeGet,invItemID,invItemNo,invItemDesc,transactUOM,whsCode,movInvQty,movLotQty,minPQty,transactQty}};						             			 
		            array2DWIPIssueByItemBean.setArray2DString(c); 	
					//out.println("iNo="+iNo); //out.println("interfaceID="+interfaceID);	
				   } // End of if				 	                
		          }  
				                   	                       		        		  
		 } else { //out.println("step6:未輸入欄位內容作 Add ,表示點擊刪除鍵");
		          if (a!=null) 
		          { //out.println("step7:若陣列內原已有存入內容,則把內容在置入");
		           array2DWIPIssueByItemBean.setArray2DString(a);     			       	                
		          } 
		        }
		 //end if of chooseItem is null
		 /*
		 custINo = Integer.toString(Integer.parseInt(custINo) + 1);
		 out.println("custINo="+custINo);
		 if (custINo==iNo)
		 {		 
		   //custINo = iNo;
		 } else {
		          custINo = iNo;
		        }
		 out.println("custINo="+custINo);
		 out.println("iNo="+iNo);
		 
		 */
		 //###################針對目前陣列內容進行檢查機制#############################		  
		  Statement chkstat=con.createStatement();
          ResultSet chkrs=null;
		  String T2[][]=array2DWIPIssueByItemBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  String tp[]=array2DWIPIssueByItemBean.getArrayContent();
		  if  (T2!=null) 
		  {  		   
		    //-------------------------取得轉存用陣列-------------------- 		    
	        String temp[][]=new String[T2.length][T2[0].length];		    
			 for (int ti=0;ti<T2.length;ti++)
			 {
			    for (int tj=0;tj<T2[ti].length;tj++)  
			   {				 
				  temp[ti][tj]=T2[ti][tj];
				}
		      }		
		    //--------------------------------------------------------------------
			int ti = 0;
            int tj = 0;
            
             temp[ti][tj]="N";	
		     array2DWIPIssueByItemBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  } else {    		      		     
		           array2DWIPIssueByItemBean.setArray2DCheck(null);
		         }	 //end if of T2!=null	   
		  if (chkrs!=null) chkrs.close();
		  chkstat.close();		  
		 //##############################################################	    	 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
     %>      
	 <%
	   
	 %>	
	<%
	    try 
		{   // 如果INSERT 傳入參數不為 Y ,表示不為輸入模式,清空 Array
	       if (insertPage==null || insertPage.equals("")) // 若輸入模式離開此頁面,則BeanArray內容清空
           {    
	          array2DWIPIssueByItemBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
           } 
		 
	    } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
	 %></strong></div>
	</td>
   </tr>
</table>
<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
<tr bgcolor="#D5D8A7">
  <td>
     <input name="button" tabindex='42' type=button onClick="this.value=check(this.form.ADDITEMS)" value='選擇全部'>
     <font color="#336699" size="2">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
  </td>
</tr>
<tr bgcolor="#D5D8A7">
  <td>  
  <% 
      int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  try
      {	
	    String a[][]=array2DWIPIssueByItemBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		        div1=a.length;
				div2=a[0].length;				
	        	array2DWIPIssueByItemBean.setFieldName("ADDITEMS");			
				//out.println(arrayRFQDocumentInputBean.getArray2DString());				
				out.println(array2DWIPIssueByItemBean.getArray2DWipIssString());  // 用Item 及Item Description 作為Key 的Method				
				isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y" 			
				
				inpLen = div1; // 第一筆Item 被寫入時
						  		 				
		 }	//enf of a!=null if		
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </td>
    </tr>
	<tr bgcolor="#D5D8A7">
	    <td>
		  <INPUT name="button2" tabindex='43' TYPE="button" onClick='setSubmit3("../jsp/TSCMfgWoCreate.jsp?INSERT=Y")'  value='刪除' >
          <% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699' size='2'>-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------"); 
		  %>
      </td>
	</tr>
 </table>
<HR>
<table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
<tr bgcolor="#CCCC99">
 <td>
  申請人員 
 </td>
 <td width="18%"> 
   <%=UserName%>	 
 </td>
 <td width="16%">
  申請日期
 </td>
 <td width="15%"> 
   <% out.println(dateBean.getYearMonthDay()); %>	 
 </td> 
 <td width="16%">
  申請時間 
 </td>
 <td width="19%"> 
    <%out.println(dateBean.getHourMinuteSecond());%>	 
 </td>  
</tr>
<tr bgcolor="#CCCC99">
 <td width="16%">
  執行動作
 </td>
 <td colspan="1"> 
    <select NAME=ACTIONID style='font-size:12'><OPTION VALUE=-->--<OPTION VALUE='002' SELECTED>CREATE</select>
	   <INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmitSave("../jsp/TSMfgMaterialReqInsert.jsp?INSERT=Y")'  value='Submit' >         
   </td>   
   <td>
     申請單位 
   </td>
   <td width="15%" colspan="1">    
    <font face="Arial">
	  <%=userMfgDeptNo+"("+userMfgDeptName+")"%>
	</font>	    	 
   </td>
   <td>
     倉管人員 
   </td>
   <td width="15%" colspan="1">    
    <font face="Arial">
	  <%=userInspectorID+"("+userInspectorName+")"%>
	</font>	    	 
   </td>
 </tr>
</table>
<%

 } else if (pageCh.equals("WO"))
        {
		   //moDeliverInfo[3] = deliverCustomer;
		   //moDeliverInfo[4] = deliverLocation;
		   //moDeliverInfo[5] = deliverTo;
		   //moDeliverInfo[6] = deliverAddress;
		  // array2DMODeliverInfoBean.setArrayString(moDeliverInfo);
		   
		   
%>
<table border=0 cellspacing=1 cellpadding=4 width='100%' bgcolor="#CCCC99">
<tr class='head'>
<td nowrap><font color='#993300'>&nbsp;</font></td>
<td nowrap><font color='#993300'><b>工令</b></font></td>
<td nowrap><font color='#993300'><b>站別</b></font></td>
<td nowrap><font color='#993300'><b>料號品名</b></font></td>
<td nowrap><font color='#993300'>組裝單位用量</font></td>
<td nowrap><font color='#993300'>累計工令需求用量</font></td>
<td nowrap><font color='#993300'>累計工令已領用量</font></td>
<td nowrap><font color='#993300'>累計工令待領用量</font></td>
<td nowrap><font color='#993300'>庫存可用量</font></td>
<td nowrap><font color='#993300'>最小包裝量</font></td>
<td nowrap><font color='#993300'>儲位剩餘量</font></td>
<td nowrap><font color='#993300'>本次預計領用量</font></td>
</tr>
<tr class='head'>
<%
 
%>
<td><font color='#993300'><%=iSeqNum%></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b><%=%></b></font></td>
<td><font color='#993300'><b>
 <input type="button" name="SETQTY" value="Set" size="5" /><input type="text" name="INPUTQTY" value="<%=%>" size="8" /></b></font></td>
</tr>
</table>
<INPUT TYPE="button" tabindex='9'  value="OK" onClick='setDeliverOK("Y")'>
<INPUT TYPE="button" tabindex='10'  value="Cancel" onClick='setDeliverCancel("N")'>
<%
  }  // End of else if (pageCh.equals("WO"))
  
 
%>

<INPUT TYPE="hidden" NAME="SUBINVDESC" SIZE=40 value="<%=%>">
<INPUT TYPE="hidden" NAME="ORGANIZATIONID" SIZE=40 value="<%=organizationID%>">
<INPUT TYPE="hidden" NAME="IDCODEGET" SIZE=40 value="<%=iDCodeGet%>">
<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
</FORM>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

