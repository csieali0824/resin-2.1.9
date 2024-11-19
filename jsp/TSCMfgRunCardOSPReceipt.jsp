<!-- 20090603 liling 將for 人工打入異動日期,以原'作業員'RES_EMPLOYEE_OP 欄位做為異動日期-->
<!-- 20091110 Marvie performance tuning-->
<!-- 20091217 Marvie Add : yew_runcard_restxns data loss-->
<!-- 20170411 liling performance tuning -->
<!-- 20200706 Marvie : must be set -->

<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat"%>
<html>
<head>
<title>MFG System Work Order Process Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCPOReceiptBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrMFGPOResBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "取消選取"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "全部選取"; }
}
// 20200706 Marvie Add : must be set
function uncheck(field)
{
 //alert("field.length="+field.length+"   field.type="+field.type);
 if (field.length>0) {
   for (i = 0; i < field.length; i++) {
     field[i].checked = false; }
 }
 else {
   field.checked = false; }
 checkflag = "true";
 return "取消選取";
}
function submitCheck(ms1,ms2,ms3)
{  
    if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
     alert("請選擇執行動作!!!");
	 document.DISPLAYREPAIR.ACTIONID.focus(); 
	 return(false);
    }     
  return(true);  
}
function setSubmit1(URL)
{ //alert(); 
  var linkURL = "#ACTION";
  document.DISPLAYREPAIR.submit2.disabled = false;
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();
}
function setSubmit2(URL)
{ 
  var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  document.DISPLAYREPAIR.submit2.disabled = false;
  document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  document.DISPLAYREPAIR.submit();    
}
function setSubmitQtyToMove(URL, xINDEX, xPOQTY, xPO_NO, xPR_NO, xToMoveQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue, prevOpSeqNum )
{    
  //alert("可超出數="+xOverValue+"  xInInputQty="+xInInputQty+"  xToMoveQty="+xToMoveQty);    
  //var linkURL = "#ACTION";  
  formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數 (良品數) 
  
  // 2007/03/27 可手動輸入報廢數 By Kerwin
  formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  formSCRAPQTY_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  xSCRAPQTY = eval(formSCRAPQTY_Write);  // 把值取得給java script 變數(報廢數)
  // 2007/03/27 可手動輸入報廢數 By Kerwin
  
  formCONTOMOVEQTY = "document.DISPLAYREPAIR.CONTOMOVEQTY"+xINDEX+".focus()";
  formCONTOMOVEQTY_Write = "document.DISPLAYREPAIR.CONTOMOVEQTY"+xINDEX+".value";
  xCONTOMOVEQTY = eval(formCONTOMOVEQTY_Write);  // 把值取得給java script 變數
  
  formOSPRECDEF = "document.DISPLAYREPAIR.OSPRECDEF"+xINDEX+".focus()";
  formOSPRECDEF_Write = "document.DISPLAYREPAIR.OSPRECDEF"+xINDEX+".value";
  xOSPRECDEF = eval(formOSPRECDEF_Write);  // 把值取得給java script 變數
  
  formDEFFLAG = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".focus()";
  formDEFFLAG_Write = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".value";
  xDEFFLAG = eval(formDEFFLAG_Write);  // 把值取得給java script 變數
  
  formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數(處理數)
  
  formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
  formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
  xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數
  
  formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數
//alert("1"); 
       txt1=xQUEUEQTY;	    //檢查移站數量是否為數字
       for (j=0;j<txt1.length;j++)      
       { 
         c=txt1.charAt(j);
	     if ("0123456789.".indexOf(c,0)<0) 
	     {
		  alert("收料數量必需為數值型態!!");
		  eval(formQUEUEQTY); // 取得焦點		     
		  return(false);
	     }
       }
	   
	   txt10=xSCRAPQTY;	    //檢查報廢數量是否為數字
       for (j=0;j<txt10.length;j++)      
       { 
         d=txt10.charAt(j);
	     if ("0123456789.".indexOf(d,0)<0) 
	     {
		  alert("報廢數量必需為數值型態!!");
		  eval(formSCRAPQTY); // 取得焦點		     
		  return(false);
	     }
       }
	   
	   txt2=xCONTOMOVEQTY;	    //檢查移站數量是否為數字
       for (j=0;j<txt2.length;j++)      
       { 
         c=txt2.charAt(j);
	     if ("0123456789.".indexOf(c,0)<0) 
	     {
		  alert("移站數量必需為數值型態!!");
		  eval(formCONTOMOVEQTY); // 取得焦點		     
		  return(false);
	     }
       }

//alert("3"); 	   
	   txt3=xRESOURCEQTY;	 //檢查工時回報數量是否為數字
       for (j=0;j<txt3.length;j++)      
       { 
         e=txt3.charAt(j);
	     if ("0123456789.".indexOf(e,0)<0) 
	     {
		  alert("工時回報數量必需為數值型態!!");
		  eval(formRESOURCEQTY); // 取得焦點		     
		  return(false);
	     }
       }

	   txt4=xRESEMPLOYEE;	 //檢查移站日期是否為數字 20090603
       for (j=0;j<txt4.length;j++)      
       { 
         e=txt4.charAt(j);
	     if ("0123456789.".indexOf(e,0)<0) 
	     {
		  alert("移站日期錯誤!!");
		  eval(formRESEMPLOYEE); // 取得焦點		     
		  return(false);
	     }
       } 
  if (txt4.length < 8 || txt4.length > 8 )  //檢查日期長度 20090603
   {
    alert("移站日期錯誤!!!");
   //eval(formRESOURCEQTY);
   eval(formRESEMPLOYEE);
   return false;
  } 

	if (parseFloat(txt4) > parseFloat(document.DISPLAYREPAIR.SYSDATE.value))//日期不可為未來日期或已關帳月份,add by Peggy 20140303
	{
    	alert("移站日期不可大於今天!!!");
   		eval(formRESEMPLOYEE);
   		return false;
	}
	else
	{
		var isExit = false;
		for (var j = 0; j < document.DISPLAYREPAIR.ACCPERIOD.options.length; j++) 
		{
			if (document.DISPLAYREPAIR.ACCPERIOD.options[j].value ==txt4.substring(0,6))
			{
				isExit = true;
				break;
			}
		}	
		if (!isExit)
		{
			alert("移站日期錯誤(該月份未開帳)!!"); 
			eval(formRESEMPLOYEE);
			return false;
		}
	}
	
  if (eval(xRESOURCEQTY)>=40 )   //Liling 2007/08/30 add 因yew老是超打工時,故提出警示需求
  {
   alert("請注意此批工時已大於40小時 !!!");
   //eval(formRESOURCEQTY);
   eval(formRESOURCEQTY);
   return false;
  } 
 
/*
  if (xToMoveQty<xQUEUEQTY)
  {
    alert("移站數量不得大於原投入數量\n         請重新輸入!!!");	
	eval(formQUEUEQTY);
	return false;
  }
 */ 
 
  if (xQUEUEQTY==null || xQUEUEQTY=="")
  {
   alert("請輸入移站或收料數量 !!!");
   eval(formQUEUEQTY);
   return false;
  }
  
  if (xRESOURCEQTY==null || xRESOURCEQTY=="" || xRESOURCEQTY==null || xRESOURCEQTY=="")
  {
   alert("請至少輸入工時回報資訊 !!!");
   eval(formRESOURCEQTY);
   return false;
  }
  
  if (eval(xToMoveQty)<eval(xCONTOMOVEQTY))
  {
    //alert("移站數量不得大於原採購單數量\n         請重新輸入!!!");
    alert("移站數量大於原採購單數量!!!");	
	eval(xCONTOMOVEQTY);
	//return false;
  }

  if (eval(xOverValue)<eval(xCONTOMOVEQTY) )
  { 
    //alert("移站數量="+xQUEUEQTY+"\n 投產數="+xInQueueQty);	
	alert("移站數量不得大於超額完工比率\n         請重新輸入 !!!");	
	eval(xCONTOMOVEQTY);
	return false;
  }
  
  if (xSCRAPQTY>0 && eval(formCONTOMOVEQTY_Write)>eval(xToMoveQty))
  {
				    alert("警告!超額完工(OverComplete)\n不應再輸入報廢數,請再確認!!!");
					eval(formSCRAPQTY);
					return false;
  }
/*  
  // 不是第一站,則限制 良品數 + 報廢數 需等於 處理數
  if (xSCRAPQTY+xCONTOMOVEQTY!=xINPUTQTY)
  //if ((eval(xQUEUEQTY) + eval(xSCRAPQTY)) != xINPUTQTY)
  {
				               alert("良品數+報廢數必需等於處理數\n               請再確認!!!");
					           eval(formSCRAPQTY);  // setFocus 到報廢數  
					           return false;
  }
*/

  document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目	 
  document.DISPLAYREPAIR.submit2.disabled = false;
  var linkURL = "#"+xINDEX;

  if (eval(xCONTOMOVEQTY)<eval(xToMoveQty))
  {
     if (xOSPRECDEF==null || xOSPRECDEF=="")
	 {
      alert("移站數量小於原外包數量,請註記短收之原因說明!!!");
	  formOSPRECDEF = "document.DISPLAYREPAIR.OSPRECDEF"+xINDEX+".focus()";
	  eval(formOSPRECDEF);
	 } else {
	            
	           document.DISPLAYREPAIR.action=URL+"&CONTOMOVEQTY"+xINDEX+"="+xCONTOMOVEQTY+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&OSPRECDEF"+xINDEX+"="+xOSPRECDEF+"&DEFFLAG"+xINDEX+"="+xDEFFLAG+"&INPUTQTY"+xINDEX+"="+xINPUTQTY+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&RESEMPLOYEE"+xINDEX+"="+xRESEMPLOYEE+"&RUNCARDID="+xINDEX+"&PO_NUM="+xPO_NO+"&PR_NUM="+xPR_NO+linkURL;			   
               document.DISPLAYREPAIR.submit(); 
	         }
	 
  } else {                   		  
             //document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&OSPRECDEF"+xINDEX+"="+"&DEFFLAG"+xINDEX+"="+xDEFFLAG+"&RUNCARDID="+xINDEX+"&PO_NUM="+xPO_NO+"&PR_NUM="+xPR_NO+linkURL;
			 document.DISPLAYREPAIR.action=URL+"&CONTOMOVEQTY"+xINDEX+"="+xCONTOMOVEQTY+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&OSPRECDEF"+xINDEX+"="+"&DEFFLAG"+xINDEX+"="+xDEFFLAG+"&INPUTQTY"+xINDEX+"="+xINPUTQTY+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&RESEMPLOYEE"+xINDEX+"="+xRESEMPLOYEE+"&RUNCARDID="+xINDEX+"&PO_NUM="+xPO_NO+"&PR_NUM="+xPR_NO+linkURL;
             document.DISPLAYREPAIR.submit(); 
          }
  
  //document.DISPLAYREPAIR.action=URL+linkURL;
      
}
function setTabNext(tabNextIndex, URL, xINDEX, xPOQTY, xPO_NO, xPR_NO, xToMoveQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue)
{ //alert(tabNextIndex);
  //alert(xINDEX);
  formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數(良品數)
  
  formCONTOMOVEQTY = "document.DISPLAYREPAIR.CONTOMOVEQTY"+xINDEX+".focus()";
  formCONTOMOVEQTY_Write = "document.DISPLAYREPAIR.CONTOMOVEQTY"+xINDEX+".value";
  xCONTOMOVEQTY = eval(formCONTOMOVEQTY_Write);  // 把值取得給java script 變數
  
  formOSPRECDEF = "document.DISPLAYREPAIR.OSPRECDEF"+xINDEX+".focus()";
  formOSPRECDEF_Write = "document.DISPLAYREPAIR.OSPRECDEF"+xINDEX+".value";
  xOSPRECDEF = eval(formOSPRECDEF_Write);  // 把值取得給java script 變數
  
  formDEFFLAG = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".focus()";
  formDEFFLAG_Write = "document.DISPLAYREPAIR.DEFFLAG"+xINDEX+".value";
  xDEFFLAG = eval(formDEFFLAG_Write);  // 把值取得給java script 變數
  
  // 2007/03/27 可手動輸入報廢數 By Kerwin
  formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  formSCRAPQTY_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  xSCRAPQTY = eval(formSCRAPQTY_Write);  // 把值取得給java script 變數(報廢數)
  // 2007/03/27 可手動輸入報廢數 By Kerwin
  
  formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數(處理數)
  
  formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
  formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
  xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數
  
  formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數
  
  //alert("xToMoveQty="+xToMoveQty);
  
  //alert("formCONTOMOVEQTY_Write="+eval(formCONTOMOVEQTY_Write));
  
   var calScrapQty = xToMoveQty - eval(formCONTOMOVEQTY_Write);  // 預計報廢數 = 處理數 - 良品數
   //var calInQueueQty = eval(xQUEUEQTY) + eval(xSCRAPQTY);      //   處理數 = 良品數 + 報廢數
   //var calInQueueQty = Math.round((eval(xQUEUEQTY)+eval(xSCRAPQTY))*1000)/1000; // 若是第一站,則 處理數 = 良品數 + 報廢數
   var calInQueueQty = Math.round((eval(xCONTOMOVEQTY)+eval(xSCRAPQTY))*1000)/1000; //修正良品數變數,modify by Peggy 20140417

   if (event.keyCode==13 || event.keyCode==9) // event.keycode = 9 --> Tab 鍵
   { 
      if (tabNextIndex=="1")
	  {
	     //eval(formWKCLASS);  // setFocus 到不良原因說明 
		 // 2007/01/21 判斷若輸入數量小於原移站數,則表示有外包不良
		 if (eval(formCONTOMOVEQTY_Write)<eval(xToMoveQty))
		 {		    
		    //alert(eval(formCONTOMOVEQTY_Write));		
			//alert(eval(xToMoveQty));			
			document.DISPLAYREPAIR.elements['OSPRECDEF'+xINDEX].value ="電鍍報廢";
			document.DISPLAYREPAIR.elements['DEFFLAG'+xINDEX].value ="Y";
			//需再自動計算報廢數
			       
		     calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		     document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
				   
			//
			
		 } // 2007/01/21 判斷若輸入數量小於原移站數,則表示有外包不良
		 else {// 否則表示OverComplete 不會有報廢數
		        document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=0;
		      }
		eval(formSCRAPQTY);  // setFocus 到報廢數 
	  } else if (tabNextIndex=="10")
	           {
			      /*
			      if (xSCRAPQTY>0 && eval(formCONTOMOVEQTY_Write)>eval(xToMoveQty))
				  {
				    alert("警告!超額完工(OverComplete)\n不應再輸入報廢數,請再確認!!!");
					eval(formSCRAPQTY);
					return false;
				  }
				  */
				  if (calInQueueQty!=xINPUTQTY)
				  {   //alert("xINPUTQTY="+xINPUTQTY);  alert("xSCRAPQTY="+xSCRAPQTY); alert("xCONTOMOVEQTY="+xCONTOMOVEQTY);
				               alert("良品數+報廢數必需等於處理數\n            請再確認!!!");
					           eval(formSCRAPQTY);  // setFocus 到報廢數  
					           return false;
				  } 
			      eval(formWKCLASS);  // setFocus 到投入數(處理數)改成移焦點到班別,因為處理數由系統自行運算
			   }	  
	  else if (tabNextIndex=="2")
	          {			  
			    eval(formDEFFLAG);  // setFocus 到不良註記 
			  }	  
	          else if (tabNextIndex=="3")
	          {
			    eval(formWKCLASS);  // setFocus 到班別 
			  } else if (tabNextIndex=="4") 
			          {
					    eval(formRESOURCEQTY); // setFocus 到工時
					  } else if (tabNextIndex=="5")
					          {
							    eval(formRESEMPLOYEE); // setFocus 到製程處理人員
							  } else if (tabNextIndex=="6")
							         {
									   eval(formRESMACHINE);  // setFocus 到製程機台號 
									 } else if (tabNextIndex=="7")
									         {
											     setSubmitQtyToMove(URL, xINDEX, xPOQTY, xPO_NO, xPR_NO, xToMoveQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee, xOverValue);
											 }
			  
   }
}
function setQty(URL,xSingleLotQty)
{ //alert(); 
  var linkURL = "#ACTION";
  document.DISPLAYREPAIR.RECOUNTFLAG.value="Y";
  document.DISPLAYREPAIR.SINGLELOTQTY.value=xSingleLotQty;
  document.DISPLAYREPAIR.submit2.disabled = false;
  //alert(xSingleLotQty+"  "+document.DISPLAYREPAIR.SINGLELOTQTY.value);
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();
}
function setOSPSubmit(URL,ms1)
{
    var linkURL = "#ACTION";
    if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
     alert("請選擇執行動作!!!");
	 document.DISPLAYREPAIR.ACTIONID.focus(); 
	 return(false);
    }

  if (document.DISPLAYREPAIR.ACTIONID.value=="006" || document.DISPLAYREPAIR.ACTIONID.value=="018")  //TRANSFER表示為確認移站轉至OSP動作
  {
              flag=confirm(ms1);      
              if (flag==false) return(false);
			  else {
			             // 若未選擇任一Line 作動作,則警告
                        var chkFlag="FALSE";
                        if (document.DISPLAYREPAIR.CHKFLAG.length!=null)
                        {
                          for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
                          {
                             if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
	                         {
	                           chkFlag="TURE";
	                         } 
                           }  // End of for	 
                           if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                           {
                             alert(ms11);   
                             return(false);
                           }
	                     } // End of if 	
			       }
  } 
  document.DISPLAYREPAIR.submit2.disabled = true;
  document.DISPLAYREPAIR.action=URL+linkURL;
  document.DISPLAYREPAIR.submit();
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<Style type="text/css">
.koko{
    border:0;
	color:#FF0000; text-decoration:underline ;font:"Comic Sans MS"; font-style:italic; 	 
	background-color:#CCCC99;
	border-style: solid;
}
</Style>
<%
    String actionID = request.getParameter("ACTIONID"); 
    String woNo=request.getParameter("WO_NO"); 
	String runCardNo=request.getParameter("RUNCARD_NO"); 
	String operSeqNum=request.getParameter("OP_SEQ");      // 2006/12/01 供Batch作業
	String poNo=request.getParameter("PO_NO");
    String marketType=request.getParameter("MARKETTYPE");
	String woType=request.getParameter("WOTYPE");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	String startDate=request.getParameter("STARTDATE");
	String endDate=request.getParameter("ENDDATE");
	String woQty=request.getParameter("WOQTY");
	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");	
	String itemDesc=request.getParameter("ITEMDESC");		
	String woUom=request.getParameter("WOUOM");
	String waferLot=request.getParameter("WAFERLOT");
	String waferQty=request.getParameter("WAFERQTY");          //使用晶片數量
	String waferUom=request.getParameter("WAFERUOM");          //晶片單位
	String waferYld=request.getParameter("WAFERYLD");          //晶片良率
    String waferVendor=request.getParameter("WAFERVENDOR");   //晶片供應商
	String waferKind=request.getParameter("WAFERKIND");       //晶片類別
	String waferElect=request.getParameter("WAFERELECT");     //電阻系數��
	String waferPcs=request.getParameter("WAFERPCS");         //使用晶片片數���
	String waferIqcNo=request.getParameter("WAFERIQCNO");     //檢驗單號	
	String tscPackage=request.getParameter("TSCPACKAGE");     //
	String tscFamily=request.getParameter("TSCFAMILY");     //
	String tscPacking=request.getParameter("TSCPACKING");
	String tscAmp=request.getParameter("TSCAMP");		      //安培數
    String remark = request.getParameter("REMARK"); 
    String customerName=request.getParameter("CUSTOMERNAME");	
    String customerNo=request.getParameter("CUSTOMERNO");
	String customerPo=request.getParameter("CUSTOMERPO");
	String oeOrderNo=request.getParameter("OEORDERNO");	
	String deptNo=request.getParameter("DEPT_NO");	
    String deptName=request.getParameter("DEPT_NAME");	
    String preFix=request.getParameter("PREFIX");
    String oeHeaderId=request.getParameter("OEHEADERID");	
	String oeLineId=request.getParameter("OELINEID");	
	//String organizationId=request.getParameter("ORGANIZATION_ID");	
	String waferLineNo=request.getParameter("LINE_NO");
	String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
	String prevOpSeqID = "0",nextOpSeqID = "0"; // 基本頁面將上下一站的OperationSequenceID都取出,作為更新移站時判斷依據

    String runCardID=request.getParameter("RUNCARDID");
    int lineIndex = 1;	
    //if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
	if (runCardID==null) runCardID = "0";
    else lineIndex = Integer.parseInt(runCardID);
	String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));
	String ospPORecDef =request.getParameter("OSPRECDEF"+Integer.toString(lineIndex));
	String defFlag =request.getParameter("DEFFLAG"+Integer.toString(lineIndex));
	
	String convToMoveQty =request.getParameter("CONTOMOVEQTY"+Integer.toString(lineIndex)); 
	
	String inputQty=request.getParameter("INPUTQTY"+Integer.toString(lineIndex));
	
	String wkClass=request.getParameter("WKCLASS"+Integer.toString(lineIndex));
	String resourceQty=request.getParameter("RESOURCEQTY"+Integer.toString(lineIndex));	
	String resMachine=request.getParameter("RESMACHINE"+Integer.toString(lineIndex));
	String resEmployee=request.getParameter("RESEMPLOYEE"+Integer.toString(lineIndex));
	
	String scrapQty=request.getParameter("SCRAPQTY"+Integer.toString(lineIndex));		
	
	String poNum=request.getParameter("PO_NUM");
	String prNum=request.getParameter("PR_NUM");
	String overValue=""; //超額完工數	
    String [] check=request.getParameterValues("CHKFLAG");	
    String systemDate ="",sTime="";  //20090603
	String aFlag=request.getParameter("AFLAG");
	String inputQtyS="", scrapQtyS="", resourceQtyS="", resEmployeeS="";    // 20091217 Marvie Add : yew_runcard_restxns data loss
	//out.println("000="+nextOpSeqID);
    if (remark==null) remark = "";
    if (aFlag==null || aFlag=="" || aFlag.equals("") || aFlag.equals("null")) aFlag = "0"; //控制第一次頁面,將欄位清為空白.
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<% //out.println("001="+nextOpSeqID);
   // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新_起

 // 20091110 Marvie Delete : Performance Issue disable
/*
    int currOperSeqID = 0;
   
     String sqlRC = " select max(a.OPERATION_SEQUENCE_ID) from WIP_OPERATIONS a, WIP.WIP_ENTITIES b "+
	                " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and  b.WIP_ENTITY_NAME='"+woNo+"' and a.REQUEST_ID is null ";
	 //out.print("sqlRC 補不足資料欄位="+sqlRC);
	 Statement stateRC=con.createStatement();
     ResultSet rsRC=stateRC.executeQuery(sqlRC);
	 if (rsRC.next())
	 {
		currOperSeqID = rsRC.getInt(1); // 取目前真正的WIP 目前站別(預防使用者自行由Oracle執行移站,WIP系統之移站資訊與Oracle工單不一致
	 }
	 rsRC.close();
     stateRC.close(); 	 
*/
     if (aFlag=="0" || aFlag.equals("0"))
     {
      // 20090629 外包收料常因前站的日期欄位未清空白,導致收料日期錯誤
	   String sqlNLS="update YEW_RUNCARD_ALL set RES_EMPLOYEE_OP='' where STATUSID='045' and WO_NO='"+woNo+"' ";     
       PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	   pstmtNLS.executeUpdate(); 
       pstmtNLS.close();
       aFlag="1";
	  //完成存檔後回復	
     }



 // 直接至Oracle作移站_上線後不允許(因會導致工令對應不到流程卡移站)_起
 /*
 try
 {
     int  wipCurrOpSeqID = 0; 
     String sqlOp = " select a.WIP_ENTITY_ID, b.OPERATION_SEQ_ID from WIP.WIP_ENTITIES a, APPS.YEW_RUNCARD_ALL b "+
	                " where a.WIP_ENTITY_NAME = b.WO_NO and a.WIP_ENTITY_NAME='"+woNo+"' " ;
	 //out.print("sqlOp 補不足資料欄位="+sqlOp);
	 Statement stateOp=con.createStatement();
     ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 if (rsOp.next())
	 {
		  	entityId   = rsOp.getString(1);  
			wipCurrOpSeqID = rsOp.getInt(2);			
	 }
	 rsOp.close();
     stateOp.close(); 
	 
  if (currOperSeqID != wipCurrOpSeqID && currOperSeqID>0) // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新
  {  //out.println("111="+nextOpSeqID);
	 String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					"  from WIP_OPERATIONS where OPERATION_SEQUENCE_ID = "+currOperSeqID+" and WIP_ENTITY_ID ="+entityId+" ";	 
	 Statement statep=con.createStatement();
     ResultSet rsp=statep.executeQuery(sqlp);
	 if (rsp.next())
	 {
		  	operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");  
			operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			standardOpDesc 	  = rsp.getString("DESCRIPTION");
			previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
			if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
			if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
			if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";			
			if (nextOpSeqNum==null || nextOpSeqNum.equals("")) nextOpSeqNum = "0";		
			
	 } else {
	             operationSeqNum   = "0";
				 operationSeqId    = "0";
				 standardOpId  	  = "0";
				 standardOpDesc   = "0"; 
	             previousOpSeqNum  = "0"; 
				 nextOpSeqNum	  = "0"; 
	        }
	 rsp.close();
     statep.close(); 
	 
    String woSql=" update APPS.YEW_RUNCARD_ALL set OPERATION_SEQ_NUM=?, OPERATION_SEQ_ID=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, "+
	             "  NEXT_OP_SEQ_NUM=?, PREVIOUS_OP_SEQ_NUM=? "+
	             " where WO_NO= '"+woNo+"' and RUNCARD_NO = '"+runCardNo+"' "; 	
    PreparedStatement wostmt=con.prepareStatement(woSql);    
	wostmt.setInt(1,Integer.parseInt(operationSeqNum));
	wostmt.setInt(2,Integer.parseInt(operationSeqId)); 
	wostmt.setInt(3,Integer.parseInt(standardOpId)); 
	wostmt.setString(4,standardOpDesc); 
	wostmt.setInt(5,Integer.parseInt(nextOpSeqNum));
	wostmt.setInt(6,Integer.parseInt(previousOpSeqNum));
    wostmt.executeUpdate();   
    wostmt.close(); 
	
   }  // End of if (currOperSeqID != wipCurrOpSeqID) // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新	
//out.println("222="+nextOpSeqID);	
  }// end of try
  catch (Exception e)
  {
     out.println("Exception Oracle之站別資訊與MFG WIP不一致:"+e.getMessage());
  }		   
  // 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新_迄
*/  // 直接至Oracle作移站_上線後不允許(因會導致工令對應不到流程卡移站)_迄

     boolean singLastOp = false;
     String sqlNextOp = "";
	 sqlNextOp =" select NEXT_OP_SEQ_NUM from APPS.YEW_RUNCARD_ALL c where WO_NO='"+woNo+"' ";
	 if (runCardID==null || runCardID.equals("0")) sqlNextOp = sqlNextOp +" and c.RUNCARD_NO ='"+runCardNo+"' ";
	 else  sqlNextOp = sqlNextOp + " and c.RUNCAD_ID ='"+runCardID+"' " ;
	 //out.print("sqlRC 補不足資料欄位="+sqlRC);
	 Statement stateNextOp=con.createStatement();
     ResultSet rsNextOp=stateNextOp.executeQuery(sqlNextOp);
	 if (rsNextOp.next() && rsNextOp.getString("NEXT_OP_SEQ_NUM").equals("0")) // 若下一站未找到,表示本站為最後一站
	 {
		singLastOp = true; //out.println("TRUE");// 表示singLastOp
		%>
	    <script language="javascript">
		    //alert("          本站為製程最後一站\n 此工作站完工後流程卡即完工!!!");
		</script>	  
	  <%
	 }
	 rsNextOp.close();
     stateNextOp.close();  
	 
   String sqlPrevOpID = "";
   if (jobType==null || jobType.equals("1"))
   {    /*20170411 liling performance issue
         sqlPrevOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
					    "    and a.OPERATION_SEQ_NUM  = c.PREVIOUS_OP_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
        if (runCardID==null || runCardID.equals("0")) sqlPrevOpID = sqlPrevOpID +" and c.RUNCARD_NO ='"+runCardNo+"' ";
        else  sqlPrevOpID = sqlPrevOpID + " and c.RUNCAD_ID ='"+runCardID+"' " ;
		*/	
         sqlPrevOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID  "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
					    "    and a.OPERATION_SEQ_NUM  = c.PREVIOUS_OP_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' "+
				        "    and c.RUNCARD_NO ='"+runCardNo+"' ";									
			
   } else if (jobType.equals("2"))
          {
		  /*
		        sqlPrevOpID =" select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							 "      BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							 " and a.WIP_ENTITY_ID = "+entityId+" "+							
							 " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							 " and a.PREVIOUS_OP_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							 " and d.ORGANIZATION_ID = '"+organizationId+"' ";
			   if (runCardID==null || runCardID.equals("0")) sqlPrevOpID = sqlPrevOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
               else  sqlPrevOpID = sqlPrevOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ;	
			   */
		        sqlPrevOpID =" select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							 "      BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							 " and a.WIP_ENTITY_ID = "+entityId+" "+							
							 " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							 " and a.PREVIOUS_OP_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							 " and d.ORGANIZATION_ID = '"+organizationId+"' "+
				             " and c.RUNCARD_NO ='"+runCardNo+"' ";								 			   
							 
		  }	
// out.println(sqlPrevOpID);		  			
   Statement statePrevOpID=con.createStatement();
   ResultSet rsPrevOpID=statePrevOpID.executeQuery(sqlPrevOpID);
   if (rsPrevOpID.next())
   {
      prevOpSeqID = rsPrevOpID.getString("OPERATION_SEQUENCE_ID");	
   }
   rsPrevOpID.close();
   statePrevOpID.close();	 
 
   int currOpSeqID = 0; // 取本站 OpSeqID
   String sqlCurrOpID = "";
   if (jobType==null || jobType.equals("1"))
   {
      /*  20170411 liling performance issue
          sqlCurrOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.RUNCARD_NO ='"+runCardNo+"' "+
						"    and c.ORGANIZATION_ID = '"+organizationId+"' "+
					    "    and a.OPERATION_SEQ_NUM  = c.OPERATION_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;					
        if (runCardID==null || runCardID.equals("0")) sqlCurrOpID = sqlCurrOpID +" and c.RUNCARD_NO ='"+runCardNo+"' ";
        else  sqlCurrOpID = sqlCurrOpID + " and c.RUNCAD_ID ='"+runCardID+"' " ;
        */
		 sqlCurrOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.RUNCARD_NO ='"+runCardNo+"' "+
						"    and c.ORGANIZATION_ID = '"+organizationId+"' "+
					    "    and a.OPERATION_SEQ_NUM  = c.OPERATION_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' "+
				        "    and c.RUNCARD_NO ='"+runCardNo+"' ";									
				
   } else if (jobType.equals("2"))
            { 
              /*  20170411 liling performance issue
		       sqlCurrOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							 " and a.WIP_ENTITY_ID = "+entityId+" "+							
							 " and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							 " and a.OPERATION_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							 " and d.ORGANIZATION_ID = '"+organizationId+"' ";
			   if (runCardID==null || runCardID.equals("0")) sqlCurrOpID = sqlCurrOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
               else  sqlCurrOpID = sqlCurrOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ;	
			   */
		       sqlCurrOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							 " and a.WIP_ENTITY_ID = "+entityId+" "+							
							 " and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							 " and a.OPERATION_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							 " and d.ORGANIZATION_ID = '"+organizationId+"' "+
				             " and c.RUNCARD_NO ='"+runCardNo+"' ";								 		   
		    } 						
   Statement stateCurrOpID=con.createStatement();
   ResultSet rsCurrOpID=stateCurrOpID.executeQuery(sqlCurrOpID);
   if (rsCurrOpID.next())
   {
      currOpSeqID = rsCurrOpID.getInt("OPERATION_SEQUENCE_ID");	
   }
   rsCurrOpID.close();
   stateCurrOpID.close();	

   String sqlNextOpID = "";
   if (jobType==null || jobType.equals("1"))
   {   
    /*
          sqlNextOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
					    "    and a.OPERATION_SEQ_NUM  = c.NEXT_OP_SEQ_NUM "+
					    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
       if (runCardID==null || runCardID.equals("0")) sqlNextOpID = sqlNextOpID +" and c.RUNCARD_NO ='"+runCardNo+"' ";
       else  sqlNextOpID = sqlNextOpID + " and c.RUNCAD_ID ='"+runCardID+"' " ;	
	   */
          sqlNextOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
					    "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
					    "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
					    "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
					    "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
					    "    and a.OPERATION_SEQ_NUM  = c.NEXT_OP_SEQ_NUM "+
				 	    "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' "+
			        	"    and c.RUNCARD_NO ='"+runCardNo+"' ";							
							   
   } else if (jobType.equals("2")) 	
          {
		       sqlNextOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
							 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							 " and a.WIP_ENTITY_ID = "+entityId+" "+							
							 " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							 " and a.NEXT_OP_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							 " and d.ORGANIZATION_ID = '"+organizationId+"' ";
			 if (runCardID==null || runCardID.equals("0")) sqlNextOpID = sqlNextOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
             else  sqlNextOpID = sqlNextOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ;	
			//out.println(sqlNextOpID);		 
		  }						
   Statement stateNextOpID=con.createStatement();
   //out.println("sqlNextOpID="+sqlNextOpID);	 
   ResultSet rsNextOpID=stateNextOpID.executeQuery(sqlNextOpID);
   if (rsNextOpID.next())
   {
      nextOpSeqID = rsNextOpID.getString("OPERATION_SEQUENCE_ID");	
   }
   rsNextOpID.close();
   stateNextOpID.close();				 
	 
//out.println("333="+sqlNextOpID);	 
 // 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_起
 String resourceDesc = "";
 boolean ospCheckFlag = false;
 try
 {

   String sqlJudgeOSP = "";
   if (jobType==null || jobType.equals("1"))
   {
           sqlJudgeOSP =" select b.DESCRIPTION, b.COST_CODE_TYPE "+
                       " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                       " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					   // "   and b.ORGANIZATION_ID = '"+organizationId+"' "+
					   "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					   "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					   // 20091110 Marvie Update : Performance Issue
					   //"   and to_char(d.OPERATION_SEQUENCE_ID) = '"+nextOpSeqID+"' "+
					   "   and d.OPERATION_SEQUENCE_ID = "+nextOpSeqID+
					   "   and b.COST_CODE_TYPE = 4 "; // Outside Processing Checked
					   
   } else if (jobType.equals("2"))
          {
		     sqlJudgeOSP =  " select d.DESCRIPTION , d.COST_CODE_TYPE "+
							" from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
							" BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							" where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							" and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							" and a.WIP_ENTITY_ID = "+entityId+" "+
							" and a.RUNCARD_NO ='"+runCardNo+"' "+
							" and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							" and a.NEXT_OP_SEQ_NUM = b.RESOURCE_SEQ_NUM "+
							" and d.ORGANIZATION_ID = '"+organizationId+"' "; 
			if (runCardID==null || runCardID.equals("0")) sqlJudgeOSP = sqlJudgeOSP +" and a.RUNCARD_NO ='"+runCardNo+"' ";
            else  sqlJudgeOSP = sqlJudgeOSP + " and a.RUNCAD_ID ='"+runCardID+"' " ;					
		  }		
  //out.println(sqlJudgeOSP);					   
   Statement stateJudgeOSP=con.createStatement();
   ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
   if (rsJudgeOSP.next())
   { 			
      resourceDesc = rsJudgeOSP.getString("DESCRIPTION");   // 外包站說明顯示於下一站的右方
	  ospCheckFlag = true;
	  %>
	    <script language="javascript">
		    alert("          下一站為委外加工站\n 此工作站完工後將產生委外請、採購單!!!");
		</script>	  
	  <%
   }
   rsJudgeOSP.close();
   stateJudgeOSP.close();	   
 } //end of try
 catch (Exception e)
 {
  out.println("Exception runcard:"+e.getMessage());
 }	   
 
//add by Peggy 20140303
try
{
	Statement stateX=con.createStatement();
	String sqlX = " SELECT SUBSTR(TO_CHAR(PERIOD_START_DATE,'yyyymmdd'),1,6)  FROM INV.ORG_ACCT_PERIODS A where ORGANIZATION_ID='"+organizationId+"' and OPEN_FLAG='Y'"; 
	ResultSet rsX=stateX.executeQuery(sqlX);
	out.println("<select NAME='ACCPERIOD' style='visibility: hidden;'>");				  			  
	out.println("<OPTION VALUE=-->--");     
	while (rsX.next())
	{  
		String s1=(String)rsX.getString(1); 
		String s2=(String)rsX.getString(1); 
		out.println("<OPTION VALUE='"+s1+"'>"+s2);
	}
	out.println("</select>");
	stateX.close();		  		  
	rsX.close();
}
catch(Exception e){out.println("Exception11:get date period error!");}
 
 // 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_迄 
 
 // 若本站為外包站,取外包料號_起
 int ospInvItemID = 0;
 float usageRateAmount = 0;
 try
 {
   if (jobType ==null || jobType.equals("1"))
   {
      String sqlOSPItem = " select a.USAGE_RATE_OR_AMOUNT, b.PURCHASE_ITEM_ID "+
                          " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                          " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					     // "   and b.ORGANIZATION_ID = '"+organizationId+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
						  "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					      "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
                         //20091110 Marvie
					     // "   and to_char(d.OPERATION_SEQUENCE_ID) = '"+currOpSeqID+"' "+
					      "   and d.OPERATION_SEQUENCE_ID = '"+currOpSeqID+"' "+
						  "   and b.COST_CODE_TYPE = 4 ";
     //out.println(sqlOSPItem);					   
      Statement stateOSPItem=con.createStatement();
      ResultSet rsOSPItem=stateOSPItem.executeQuery(sqlOSPItem);
      if (rsOSPItem.next())
      { 			
         ospInvItemID = rsOSPItem.getInt("PURCHASE_ITEM_ID");   // 外包料號,供下方計算換算比率使用	 
		 usageRateAmount = rsOSPItem.getFloat("USAGE_RATE_OR_AMOUNT"); 
      } 
      rsOSPItem.close();
      stateOSPItem.close();	  
	} else { //jobType.equals("2")  重工工單
	                String sqlOSPRes = " select DISTINCT d.PURCHASE_ITEM_ID, c.USAGE_RATE_OR_AMOUNT "+        			              
					                "   from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
									"        BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
									"  where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
									"    and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
									"    and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO = '"+runCardNo+"' "+
									"    and d.COST_CODE_TYPE = 4 ";
									//"    and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM ";
					//out.println("<font color='FF0000'>sqlOSPRes=="+sqlOSPRes+"</font>");					 
	                Statement stateOSPRes=con.createStatement();
                    ResultSet rsOSPRes=stateOSPRes.executeQuery(sqlOSPRes);
					if (rsOSPRes.next())
					{
					   ospInvItemID = rsOSPRes.getInt("PURCHASE_ITEM_ID");   // 外包料號,供下方計算換算比率使用	  	 
					   usageRateAmount = rsOSPRes.getFloat("USAGE_RATE_OR_AMOUNT");                   
					}
					rsOSPRes.close();
					stateOSPRes.close();	
	          
	       } 
 } //end of try
 catch (Exception e)
 {
  out.println("Exception runcard:"+e.getMessage());
 }	
 
 // 若本站為外包站,取外包料號_迄	 
	 
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      流程卡明細 : 
	  <%
	  out.println("entityId("+entityId+")");
	  try
      {   
	    String oneDArray[]= {"流程卡識別碼","流程卡號","前一站","目前站別","移站收料數量","下一站","流程卡狀態","展開日期"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrMFGRCPOReceiptBean.setArrayString(oneDArray);		
		// 先取 該詢問單筆數
	     int rowLength = 0;
	     Statement stateCNT=con.createStatement();
         String sqlCNT = "select count(RUNCAD_ID) from YEW_RUNCARD_ALL where WO_NO='"+woNo+"' and STATUSID = '"+frStatID+"' "+	
		                 "   and OPERATION_SEQ_NUM="+operSeqNum+" ";	
				 /*		 			 
		            if (runCardNo!=null && !runCardNo.equals("")) // 2006/10/31 限制單筆處理移站流程卡_起
				    {
						     sqlCNT = sqlCNT + " and RUNCARD_NO='"+runCardNo+"' "; 
				    } else {
						      sqlCNT = sqlCNT + " and RUNCAD_ID='"+runCardID+"' "; 
					       } // 2006/10/31 限制單筆處理移站流程卡_迄
				 */
         ResultSet rsCNT=stateCNT.executeQuery(sqlCNT);		
	     if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     rsCNT.close();
	     stateCNT.close();
	     //out.println("rowLength="+rowLength);
	   //choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	   // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行) ..2006/12/31 加入ospCheckFlag --> b[k][19], singLastOp = b[k][20]
       // 20091217 Marvie Add : yew_runcard_restxns data loss  b[k][22]=scrapQtyS   b[k][23]=inputQtyS   b[k][24]=resourceQtyS
	   //                       b[k][25]=resEmployeeS   b[k][26]=transaction_date   b[k][27]=RESOURCE_SEQ_NUM
	   //                       b[k][28]=RESOURCE_ID  b[k][29]=TRANSACTION_UOM
	   String b[][]=new String[rowLength+1][30];
	   String r[][]=new String[rowLength+1][18]; // 宣告一二維陣列,分別是(=列)X(資料欄數+1= 行)
	  
	   //array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	   //b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	   out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
	   out.print("<TR bgcolor='#CCCC99'>");
	   out.print("<td nowrap><font color='#FFFFFF'>");
	   %>
	   <!-- 20200726 Marvie Update : must be set -->
	   <!--<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>  -->
	   <input name="button" type=button onClick="this.value=uncheck(this.form.CHKFLAG)" value='取消選取'>
	   <%
	   out.println("</td>");
	   out.println("<td><font color='#990000'>ID</font></td>");
	   out.println("<td><font color='#990000'>");	  
	   out.println("流程卡</font></td><td><font color='#990000'>PO數量</font></td><td><font color='#990000'>換算收料數</font></td><td><font color='#990000'>單位</font></td><td nowrap><font color='#990000'>外包短收說明</font></td><td><font color='#990000'>外包不良</font></td><td><font color='#990000'>良品數</font><img src='../image/point.gif'></td>");
	   out.println("<td><font color='#990000'>報廢數</font></td>"); // 2007/01/26 加入管理員可手動輸入報廢數
	   out.println("<td><font color='#990000'>單位</font></td><td><font color='#990000'>處理數</font></td><td><font color='#990000'>班別</font></td><td><font color='#990000'>工時</font><img src='../image/point.gif'></td><td><font color='#990000'>日期</font></td><td><font color='#990000'>機號</font></td><td><font color='#990000'>前一站</font></td><td nowrap><font color='#990000'>目前站別</font></td>");
	   if (ospCheckFlag) out.println("<td><font color='#990000'><em>下一站(委外加工站)</em></font></td>");
	   else out.print("<td><font color='#990000'>下一站</font></td></TR>");
	  // out.print("<td>流程卡狀態</td>");    
	   int k=0;
	   //out.println("entityId="+entityId);
	   String sqlEst = "";
	   String fromEst = "";
	   String whereEst = "";
	   String orderEst = "";

      //抓取系統日期  20090603 liling for 人工打入異動日期,預設系統日
      
      Statement statesd=con.createStatement();
	  ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE ,   substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME  from dual" );
	  if (sd.next())
      {
	    systemDate=sd.getString("SYSTEMDATE");	 
	    sTime=sd.getString("STIME");
	  }
	  sd.close();
      statesd.close();  

	  // 20091110 Marvie Add : Performance Issue
	  String overValue1 = "0";
      String sqlOver=" SELECT (overcompletion_tolerance_value / 100 + 1)  "+
  					 "   FROM wip_discrete_jobs WHERE wip_entity_id = "+entityId+
   					 "    AND organization_id = "+organizationId+" ";
      //out.print("<br>sqlOver="+sqlOver);
	  Statement stateOver=con.createStatement();
	  ResultSet rsOver=stateOver.executeQuery(sqlOver); 
	  if (rsOver.next())
	  {
	    overValue1 = rsOver.getString(1);
	  }	
	  rsOver.close();
	  stateOver.close();


	   if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   {  //20091110 Marvie performace add 	OVER_VALUE
		  sqlEst = " select YRA.OSP_REC_QTY, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,WIPO.STANDARD_OPERATION_ID,WIPO.DESCRIPTION,  "+
        			"       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM,YRA.RUNCARD_NO, YRA.OSP_REC_DEFFLAG,  "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
					"       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID , YRA.OSP_REC_DEFREASON, "+
					"       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP,  "+
					"       YRA.PRIMARY_ITEM_ID, YRA.OSP_PO_NUM ,YRA.PREVIOUS_OP_SEQ_ID"; // 取ITEM_ID作外包數轉換依據
		  fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  ";
		 whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+ 
					"    and WIPO.WIP_ENTITY_ID = YRA.WIP_ENTITY_ID  "+					
					"    and WIPO.WIP_ENTITY_ID = "+entityId+" and STATUSID = '"+frStatID+"' "+
				    "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
		 orderEst = "  order by YRA.RUNCAD_ID";		
		 /*		
				if (runCardNo!=null && !runCardNo.equals("")) // 2006/10/31 限制單筆處理移站流程卡_起
				{
						     whereEst = whereEst + " and YRA.RUNCARD_NO='"+runCardNo+"' "; 
				} else {
						      whereEst = whereEst + " and YRA.RUNCAD_ID='"+runCardID+"' "; 
					   } // 2006/10/31 限制單筆處理移站流程卡_迄	
		 */			
		        if (jobType==null || jobType.equals("1")) // 標準(discrete Job)
		        {	
				   whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
				} else { //  非標準工單(rework Job)
				         // whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
						 whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
				       }
				
		  sqlEst = sqlEst + fromEst + whereEst + orderEst;		
	   }
	   else if (UserRoles.indexOf("YEW_STOCKER")>=0) // 若是倉管人員,可看到所有單據
	        {    //20091110 Marvie performace add 	OVER_VALUE
		        sqlEst = " select YRA.OSP_REC_QTY, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,WIPO.STANDARD_OPERATION_ID,WIPO.DESCRIPTION,  "+
        		          "       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM,YRA.RUNCARD_NO, YRA.OSP_REC_DEFFLAG,  "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
					      "       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					      "       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID , YRA.OSP_REC_DEFREASON, "+
						  "       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP, "+
					      "       YRA.PRIMARY_ITEM_ID, YRA.OSP_PO_NUM ,YRA.PREVIOUS_OP_SEQ_ID "; // 取ITEM_ID作外包數轉換依據
		        fromEst = "  from WIP_OPERATIONS WIPO , YEW_RUNCARD_ALL YRA, BOM_OPERATION_SEQUENCES BOS  ";
		       whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+ 
					      "    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID  "+					
					      "    and WIPO.WIP_ENTITY_ID= "+entityId+" and STATUSID = '"+frStatID+"' "+
				          "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
		       orderEst = "  order by YRA.RUNCAD_ID";	
			   /*	
				if (runCardNo!=null && !runCardNo.equals("")) // 2006/10/31 限制單筆處理移站流程卡_起
				{
						     whereEst = whereEst + " and YRA.RUNCARD_NO='"+runCardNo+"' "; 
				} else {
						      whereEst = whereEst + " and YRA.RUNCAD_ID='"+runCardID+"' "; 
					   } // 2006/10/31 限制單筆處理移站流程卡_迄	
			   */	
		        if (jobType==null || jobType.equals("1")) // 標準(discrete Job)
		        {	
				   whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
				} else { //  非標準工單(rework Job)
				         //whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
						 whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
				       }
				
		        sqlEst = sqlEst + fromEst + whereEst + orderEst;	
			}
	        else {   //20091110 Marvie performace add 	OVER_VALUE	         
		            sqlEst = " select YRA.OSP_REC_QTY, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,WIPO.STANDARD_OPERATION_ID,WIPO.DESCRIPTION,  "+
        			         "       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM,YRA.RUNCARD_NO, YRA.OSP_REC_DEFFLAG,  "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
					         "       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					         "       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID , YRA.OSP_REC_DEFREASON, "+
							 "       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP, "+
					         "       YRA.PRIMARY_ITEM_ID, YRA.OSP_PO_NUM ,YRA.PREVIOUS_OP_SEQ_ID "; // 取ITEM_ID作外包數轉換依據
		            fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA, BOM_OPERATION_SEQUENCES BOS  ";
		            whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+
				               "    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+					
					           "    and WIPO.WIP_ENTITY_ID= "+entityId+" and YRA.DEPT_NO = '"+userMfgDeptNo+"' "+
							   "    and STATUSID = '"+frStatID+"' "+
				               "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
					orderEst = "  order by YRA.RUNCAD_ID";		
				/*	   
				   if (runCardNo!=null && !runCardNo.equals("")) // 2006/10/31 限制單筆處理移站流程卡_起
				   {
						     whereEst = whereEst + " and YRA.RUNCARD_NO='"+runCardNo+"' "; 
				   } else {
						      whereEst = whereEst + " and YRA.RUNCAD_ID='"+runCardID+"' "; 
					      } // 2006/10/31 限制單筆處理移站流程卡_迄				           
			    */     	   
				   if (jobType==null || jobType.equals("1")) // 標準工單/(discrete job)
		           {	
				     whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
				   } else { // 非標準工單(rework) Job)
				            //whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
							whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
				          }
			       sqlEst = sqlEst + fromEst + whereEst + orderEst; 		
			     }
	   //out.println("0=="+sqlEst); 
	   float convInQueueQty = 0;
	   //float convToMoveQty = 0;
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlEst);	   
	   while (rs.next())
	   { 
	    //out.println("k1="+k); 
          // 20091110 Marvie Update : Performance Issue :已於sql中計算了,此處不用再另算一次
        /*
		  //抓取工令上的超收比率,供移站數量判斷
          String sqlOver=" SELECT (wdj.overcompletion_tolerance_value / 100 + 1) * (yra.runcard_qty) "+
  					     "   FROM wip_discrete_jobs wdj, yew_runcard_all yra  WHERE wdj.wip_entity_id = yra.wip_entity_id "+
   						 "    AND wdj.organization_id = yra.organization_id  AND yra.runcard_no = '"+rs.getString("RUNCARD_NO")+"' ";
	      //out.print("sqlOver="+sqlOver);
		  Statement stateOver=con.createStatement();	   
	      ResultSet rsOver=stateOver.executeQuery(sqlOver); 
	      if (rsOver.next())
	      {
	        overValue = rsOver.getString(1);
	       }else overValue = rs.getString("RUNCARD_QTY") ;  //若無值設則等於流程卡數量	
		  if (overValue==null || overValue.equals("")) 	overValue = rs.getString("RUNCARD_QTY") ;   //預防沒有打超收比率的工令,抓不到值故設定流程卡數
         // out.print("overValue="+overValue);
		  rsOver.close();
		  stateOver.close();	
	    */
        overValue = rs.getString("OVER_VALUE");
		float convBaseRate = 1;
		String fromConvUOM = "";
		java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
	    String sqlPO = " select a.PO_HEADER_ID, c.ITEM_ID, b.PO_LINE_ID, b.LINE_LOCATION_ID ,a.SEGMENT1, b.QUANTITY, b.UNIT_MEAS_LOOKUP_CODE, d.SEGMENT1 as PR_NUMBER "+
		               " from PO_HEADERS_ALL a, PO_LINE_LOCATIONS_ALL b, PO_REQUISITION_LINES_ALL c, PO_REQUISITION_HEADERS_ALL d "+
					   " where a.PO_HEADER_ID = b.PO_HEADER_ID and b.NOTE_TO_RECEIVER = c.NOTE_TO_RECEIVER "+
					   "   and c.REQUISITION_HEADER_ID=d.REQUISITION_HEADER_ID "+
					   "   and a.SEGMENT1 = '"+rs.getString("OSP_PO_NUM")+"' "+
					   "   and b.NOTE_TO_RECEIVER='"+rs.getString("RUNCARD_NO")+"' and c.WIP_ENTITY_ID = "+entityId+" ";
		//out.println("sqlPO="+sqlPO);			   
		Statement statePO=con.createStatement();
        ResultSet rsPO=statePO.executeQuery(sqlPO);	
	    if (rsPO.next()) 
		{	
		   //prNum=rsPO.getString("PR_NUMBER");
		   //poNum=rsPO.getString("SEGMENT1");		
		   
		    // 以Procedure WIP_OSP.ConvertToPrimaryMoveQty 取換算移站數_起		      
		        CallableStatement csCPQ = con.prepareCall("{? = call WIP_OSP.ConvertToPrimaryMoveQty(?,?,?,?,?,?)}");	
		        //CallableStatement csRes = con.prepareCall("{call WIP_OSP.ConvertToPrimaryMoveQty(?,?,?,?,?,?)}");
				csCPQ.registerOutParameter(1, Types.DECIMAL);                   //  傳回值 為數值型態
			    csCPQ.setInt(2,rsPO.getInt("ITEM_ID"));                         // 外包的料號  //  p_item_id 	
				csCPQ.setInt(3,Integer.parseInt(organizationId));               //  p_organization_id
				csCPQ.setFloat(4,rsPO.getFloat("QUANTITY"));                    //  p_quantity	 	
				csCPQ.setString(5,rsPO.getString("UNIT_MEAS_LOOKUP_CODE"));	                                     //  p_uom_code	
				csCPQ.setString(6,woUom);	    //  p_primary_uom_code	
				csCPQ.setFloat(7,usageRateAmount);       						   	 					     
				csCPQ.execute();					      
			    float orgToMoveQty = csCPQ.getFloat(1);		// 取得的換算移站數			
				//out.println("<BR>Proc 轉換的原移站數量1 = "+convToMoveQty+"<BR>");   					    
				csCPQ.close();
				
				// 讓 Java 取小數3位 換算_起
				String strConvToMoveQty = nf.format(orgToMoveQty);
				java.math.BigDecimal bd = new java.math.BigDecimal(strConvToMoveQty);
				java.math.BigDecimal toMoveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				orgToMoveQty =toMoveQty.floatValue();
				// 讓 Java 取小數3位 換算_迄				
		    // 以Procedure WIP_OSP.ConvertToPrimaryMoveQty 取換算移站數_迄   
              //  out.print("<br>orgToMoveQty="+orgToMoveQty);
		    		   
		/*
		  // 取轉換率換算後的移站數_起
	        String sqlConRate = "select FROM_UNIT_OF_MEASURE, CONVERSION_RATE from MTL_UOM_CLASS_CONVERSIONS where INVENTORY_ITEM_ID = "+ospInvItemID+" and TO_UNIT_OF_MEASURE = '"+rsPO.getString("UNIT_MEAS_LOOKUP_CODE")+"' ";
			//out.println("1"+sqlConRate);
			Statement stateConRate=con.createStatement();
            ResultSet rsConRate=stateConRate.executeQuery(sqlConRate);
			if (rsConRate.next())
			{
			   //convInQueueQty = rs.getFloat("QTY_IN_TOMOVE")/rsConRate.getFloat("CONVERSION_RATE");
			    convInQueueQty = rs.getFloat("QTY_IN_QUEUE")*1000/rsConRate.getFloat("CONVERSION_RATE");
			   //if (rsPO.getString("UNIT_MEAS_LOOKUP_CODE")=="KPC" || rsPO.getString("UNIT_MEAS_LOOKUP_CODE").equals("KPC"))
			   //{
			   //  convInQueueQty = rs.getFloat("QTY_IN_QUEUE")*1000/rsConRate.getFloat("CONVERSION_RATE");
			   //} else {  convInQueueQty = rs.getFloat("QTY_IN_QUEUE")/rsConRate.getFloat("CONVERSION_RATE"); }
			   fromConvUOM = rsConRate.getString("FROM_UNIT_OF_MEASURE");
			   
			   if (woUom != fromConvUOM) // 若原工單之計量單位與外包採購單不同,則取其轉換率_起
			   {
			      String sqlBaseRate = "select CONVERSION_RATE from MTL_UOM_CONVERSIONS where INVENTORY_ITEM_ID = 0 and UOM_CLASS = 'Quantity' and UNIT_OF_MEASURE ='"+woUom+"' ";
				  //out.println("sqlBaseRate="+sqlBaseRate);
				  Statement stateBaseRate=con.createStatement();
                  ResultSet rsBaseRate=stateBaseRate.executeQuery(sqlBaseRate);
			      if (rsBaseRate.next())
				  {
				    convBaseRate = rsBaseRate.getFloat(1);
				  } 
				  rsBaseRate.close();
				  stateBaseRate.close();
			   } // 若原工單之計量單位與外包採購單不同,則取其轉換率_迄
			    
			   //out.println("<font color='#FF0000'>convInQueueQty=</font>"+convInQueueQty);
			   if (queueQty==null || queueQty.equals("0")) 
			   { 
			     
			     convToMoveQty = convInQueueQty*rsConRate.getFloat("CONVERSION_RATE")/convBaseRate;
				            String strConvToMoveQty = nf.format(convToMoveQty);
				            java.math.BigDecimal bd = new java.math.BigDecimal(strConvToMoveQty);
							java.math.BigDecimal toMoveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							convToMoveQty =toMoveQty.floatValue();
				 //out.println("queueQty=null 1 "+convToMoveQty);
			   } else { //out.println("convBaseRate !=null 1 "+convBaseRate);
			            //out.println("CONVERSION_RATE !=null 1 "+rsConRate.getFloat("CONVERSION_RATE"));
			            //convToMoveQty = Float.parseFloat(queueQty)*rsConRate.getFloat("CONVERSION_RATE")/convBaseRate;  // 2006/11/30 會換算錯的移站數
						 convToMoveQty = convInQueueQty*rsConRate.getFloat("CONVERSION_RATE")/convBaseRate;
						    String strConvToMoveQty = nf.format(convToMoveQty);
				            java.math.BigDecimal bd = new java.math.BigDecimal(strConvToMoveQty);
							java.math.BigDecimal toMoveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							convToMoveQty =toMoveQty.floatValue();
							//out.println("convToMoveQty="+convToMoveQty);
							//out.println("queueQty !=null 1 "+queueQty);
			          }
			} else {  // 抓不到,是屬於Quantity類(Intra-Class)
			            String sqlConIntrRate = "select UNIT_OF_MEASURE, CONVERSION_RATE from MTL_UOM_CONVERSIONS where DISABLE_DATE is null and INVENTORY_ITEM_ID = "+ospInvItemID+" and UNIT_OF_MEASURE = '"+rsPO.getString("UNIT_MEAS_LOOKUP_CODE")+"' ";
		                //out.println("sqlConIntrRate="+sqlConIntrRate);
			            Statement stateConIntrRate=con.createStatement();
                        ResultSet rsConIntrRate=stateConIntrRate.executeQuery(sqlConIntrRate);
						if (rsConIntrRate.next())
						{
						    convInQueueQty = rs.getFloat("QTY_IN_TOMOVE")/rsConIntrRate.getFloat("CONVERSION_RATE");
			                fromConvUOM = rsConIntrRate.getString("UNIT_OF_MEASURE");
							
						    if (woUom != fromConvUOM) // 若原工單之計量單位與外包採購單不同,則取其轉換率_起
			                {
			                   String sqlBaseRate = "select CONVERSION_RATE from MTL_UOM_CONVERSIONS where INVENTORY_ITEM_ID = 0 and UOM_CLASS = 'Quantity' and UNIT_OF_MEASURE ='"+woUom+"' ";
				               //out.println("sqlBaseRate="+sqlBaseRate);
				               Statement stateBaseRate=con.createStatement();
                               ResultSet rsBaseRate=stateBaseRate.executeQuery(sqlBaseRate);
			                   if (rsBaseRate.next())
				               {
				                convBaseRate = rsBaseRate.getFloat(1);
				               } 
				               rsBaseRate.close();
				               stateBaseRate.close();
			                } // 若原工單之計量單位與外包採購單不同,則取其轉換率_迄
			   
			                //out.println("<font color='#FF0000'>convInQueueQty=</font>"+convInQueueQty);
			                if (queueQty==null || queueQty.equals("0")) 
			                {
			                 convToMoveQty = convInQueueQty*rsConIntrRate.getFloat("CONVERSION_RATE")/convBaseRate;
							      String strConvToMoveQty = nf.format(convToMoveQty);
				                  java.math.BigDecimal bd = new java.math.BigDecimal(strConvToMoveQty);
							      java.math.BigDecimal toMoveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							      convToMoveQty =toMoveQty.floatValue();
								  //out.println("convToMoveQty=null 2 "+convToMoveQty);
			                } else {
			                        convToMoveQty = convInQueueQty*rsConIntrRate.getFloat("CONVERSION_RATE")/convBaseRate; 
									 String strConvToMoveQty = nf.format(convToMoveQty);
				                     java.math.BigDecimal bd = new java.math.BigDecimal(strConvToMoveQty);
							         java.math.BigDecimal toMoveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
							         convToMoveQty =toMoveQty.floatValue();
									 //out.println("queueQty!=null 2 "+convToMoveQty);
			                       }					   
						 } //  End of if rsConIntrRate.next()
			             rsConIntrRate.close();
						 stateConIntrRate.close();
			
			       }
			       rsConRate.close();
			       stateConRate.close();
	      // 取轉換率換算後的移站數_迄
		 */ 
		  
		if (convToMoveQty=="0") convToMoveQty=rs.getString("QTY_IN_QUEUE");	
		
	    out.print("<TR bgcolor='#CCCC99'>");		
		out.println("<TD width='1%'><a name='#"+rs.getString("RUNCAD_ID")+"'><div align='center'>");
		// 20200706 Marvie Update : must be set
		//out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("RUNCAD_ID")+"' ");
		out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("RUNCAD_ID")+"' onclick='return false;' ");
		if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
		{  //out.println("111"); 
		  for (int j=0;j<check.length;j++) { if (check[j]==rs.getString("RUNCAD_ID") || check[j].equals(rs.getString("RUNCAD_ID"))) out.println("checked");  }
		  if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); // 給定生產日期即設定欲結轉
		} 
		else if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
		// 20200706 Marvie Delete : must be set
		//if (rowLength==1) out.println("checked >"); 	else 
		out.println(" >");
		out.println("</div></a></TD>");
		out.println("<TD nowrap>");		
		out.print(rs.getString("RUNCAD_ID")+"</TD>");		
		out.println("<TD nowrap>");
		//out.print("<a onmouseover='this.T_WIDTH=80;this.T_OPACITY=150;return escape("+"\""+rsPO.getString("SEGMENT1")+"\""+")'>"); // 寬度,透明度 //
		out.print("<a onmouseover='this.T_STICKY=true;this.T_TEMP=2000;this.T_WIDTH=80;this.T_CLICKCLOSE=true;this.T_SHADOWCOLOR="+"\"#6699CC"+"\";this.T_TITLE="+"\"採購單號"+"\";this.T_OFFSETY=-32;return escape("+"\""+rsPO.getString("SEGMENT1")+"\""+")'>"); // 寬度,透明度 //
		out.print("<font color='#330066'>"+rs.getString("RUNCARD_NO")+"</font></a></TD>");
		//out.println("<TD nowrap>"); // 2007/01/21 將PO號置入流程卡的 PopMenu		
		//out.print("<font color='#993366'>"+rsPO.getString("SEGMENT1")+"</font></TD>"); // 加PO號 -- 2007/01/21 將PO號置入流程卡的 PopMenu	
		out.println("<TD nowrap>");
		out.print(rsPO.getString("QUANTITY")+"</TD>"); // PO數量		
    /*
	    if (rs.getString("OSP_REC_QTY")==null || rs.getString("OSP_REC_QTY").equals("0"))
		{
		  out.print(rsPO.getString("QUANTITY")+"</TD>"); // OSP_REC_QTY為零,則帶PO數量
		} else { 
		        out.print(rs.getString("OSP_REC_QTY")+"</TD>");  // OSP_REC_QTY 
		       }
	*/
		out.print("<TD nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitQtyToMove("+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")'>");
		
		//out.println(overValue);
		// PO 收料數量
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{ 	
		    // 以Procedure WIP_OSP.ConvertToPrimaryMoveQty 取換算移站數_起		      
		        CallableStatement csUPQ = con.prepareCall("{? = call WIP_OSP.ConvertToPrimaryMoveQty(?,?,?,?,?,?)}");	
		        //CallableStatement csRes = con.prepareCall("{call WIP_OSP.ConvertToPrimaryMoveQty(?,?,?,?,?,?)}");
				csUPQ.registerOutParameter(1,Types.DECIMAL);                   //  傳回值 為數值型態
			    csUPQ.setInt(2,rsPO.getInt("ITEM_ID"));                         // 外包的料號  //  p_item_id 	
				csUPQ.setInt(3,Integer.parseInt(organizationId));               //  p_organization_id
				csUPQ.setFloat(4,Float.parseFloat(convToMoveQty));              //  使用者輸入的換算移站數	 	
				csUPQ.setString(5,woUom);	                                     //  p_uom_code	
				csUPQ.setString(6,rsPO.getString("UNIT_MEAS_LOOKUP_CODE"));	     //  p_primary_uom_code	
				csUPQ.setFloat(7,usageRateAmount);       						   	 					     
				csUPQ.execute();					      
			    queueQty = csUPQ.getString(1);		// 取得的換算移站數			
				//out.println("<BR>Proc 依輸入的移站數轉換的收料數量 = "+queueQty+"<BR>"); 				  					    
				csUPQ.close();
				//out.println("ItemID="+rsPO.getInt("ITEM_ID")+" organizationId="+organizationId+" convToMoveQty="+convToMoveQty+" "+woUom+" rsPO.getString(UNIT_MEAS_LOOKUP_CODE')="+rsPO.getString("UNIT_MEAS_LOOKUP_CODE")+" usageRateAmount="+usageRateAmount);
				int dotPos = queueQty.indexOf(".");  // 取小數點位置,如傳回-1,表示為整數
                //out.println("dotPos="+dotPos);
				if (queueQty==null && queueQty.equals("")) 
				{  // 因為外包料件換算係數設定有問題,此Procedure取回的值為Null,
				   queueQty = "0";   // 把原來的移站數給換算移站數
				   out.println("<br>strConvToMoveQty="+strConvToMoveQty);
				   %>
				      <script language="javascript">
					      alert("此外包料件換算係數設定有問題!!!\n您的收料可能含有異常!!!");
					  </script>
				   <%
				}
			/*	
				// 讓 Java 取小數3位 換算_起
				String strQueueQty = nf.format(Float.parseFloat(queueQty));
				java.math.BigDecimal ubd = new java.math.BigDecimal(strQueueQty);
				java.math.BigDecimal queueQtyStr = ubd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);				
				// 讓 Java 取小數3位 換算_迄
		    */ 		
			
		     String queueQtyStr = queueQty;				
		   		 
		    // 以Procedure WIP_OSP.ConvertToPrimaryMoveQty 取換算移站數_迄
		   out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='hidden' value='"+queueQtyStr+"' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
		   out.println(queueQtyStr);
		}
		else { 
		      if (rs.getString("OSP_REC_QTY")==null || rs.getString("OSP_REC_QTY").equals("0"))
			  {  
			   out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='hidden' value='"+rsPO.getString("QUANTITY")+"' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");  			  
			   out.println(rsPO.getString("QUANTITY"));
			  }
			  else 
			      {  
				   out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='hidden' value='"+rs.getString("OSP_REC_QTY")+"' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 			  
				    out.println(rs.getString("OSP_REC_QTY"));
				  }
			 }				  
		out.println("</TD>");		
		// PO 收料數量
		
		out.println("<TD nowrap>");
		out.print(rsPO.getString("UNIT_MEAS_LOOKUP_CODE")+"</TD>");  // PO單位
		out.println("<TD nowrap>");
		
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定短收不良原因
		{ out.print("<input name='OSPRECDEF"+rs.getString("RUNCAD_ID")+"' type='text' value='"+ospPORecDef+"' size=8 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); }
		else { 
		      if (rs.getString("OSP_REC_DEFREASON")==null)
			    out.print("<input name='OSPRECDEF"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=8 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");  
			  else out.print("<input name='OSPRECDEF"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("OSP_REC_DEFREASON")+"' size=8 onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
			 }				  
		out.println("</TD>");  // PO短收不良原因
		
		out.print("<TD nowrap>"); // 不包不良註明_起		
		out.print("<select name='DEFFLAG"+rs.getString("RUNCAD_ID")+"' size='1'>");
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{
		  if (defFlag==null || defFlag.equals("N"))
		  {
		   out.print("<option value='N' selected>否</option><option value='Y'>是</option>");
		  } else {
		           out.print("<option value='N'>否</option><option value='Y' selected>是</option>"); 
		         }
		}	
		else if (runCardID!=rs.getString("RUNCAD_ID")) 
		     {    //out.print("<option value='N'>否</option><option value='Y' selected>是</option>");
			    		            
				           if (rs.getString("OSP_REC_DEFFLAG").equals("Y"))
					       {
				              out.print("<option value='Y' selected>是</option><option value='N'>否</option>");
				           } else {
						            out.print("<option value='N' selected>否</option><option value='Y'>是</option>");
						          }				 
		     }			
		out.print("</select>");
		out.println("</TD>");  // 不包不良註明_迄
		
		out.println("<TD nowrap>");
		//out.print(convToMoveQty); 預計換算移站數_起(良品數) 
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID")))
		{
		   out.print("<input name='CONTOMOVEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+convToMoveQty+"' size=5 onfocus=this.select() onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
		} else {
		          if (rs.getString("QTY_IN_TOMOVE")==null || rs.getString("QTY_IN_TOMOVE").equals("0"))
			      { 
				     out.print("<input name='CONTOMOVEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 onfocus=this.select() onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
				  } else {
				           out.print("<input name='CONTOMOVEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_TOMOVE")+"' size=5 onfocus=this.select() onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
				         }
		       }
		out.println("</TD>");   // 預計換算移站數(良品數)	
		
		 
		  //out.print("<TD nowrap>"+rs.getString("QTY_IN_SCRAP")+"</TD>");  
		  
		  //out.print("<TD nowrap>"+"</TD>");
		 out.print("<TD nowrap>"); // 報廢數量
		  if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		  { out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+scrapQty+"' size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
            scrapQtyS = scrapQty;     // 20091217 Marvie Add : yew_runcard_restxns data loss
		  }
		  else { 
		        if (rs.getString("QTY_IN_SCRAP")==null || rs.getString("QTY_IN_SCRAP").equals("0"))
			    { out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
                  scrapQtyS = "0";     // 20091217 Marvie Add : yew_runcard_restxns data loss
                }
			    else { 
				        if (rs.getFloat("QTY_IN_TOMOVE")+rs.getFloat("QTY_IN_SCRAP")!=rs.getFloat("QTY_IN_QUEUE"))
					    { // 若 良品數+報廢數 != 處理數, 則畫面顯示之報廢數 = 0
                         //20091123 liling fix 第一次進入的畫面應顯示0 ,而非報廢數
						 //  out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
						   out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
                           scrapQtyS = "0";     // 20091217 Marvie Add : yew_runcard_restxns data loss
						} else {
				                out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
                                scrapQtyS = rs.getString("QTY_IN_SCRAP");     // 20091217 Marvie Add : yew_runcard_restxns data loss
							   }
					 }
			   }
		out.println("</TD>");
		
			
		out.println("<TD nowrap>");
		out.print(woUom);
		out.println("</TD>");          // 預計換算移站單位
		
		//  out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='hidden' value='"+inputQty+"' size=5>"); //隱藏處理數 (2007/04/04)改為與其它頁面一致
		out.print("<TD nowrap>"); // 投入數量	(處理數)	
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{ out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+inputQty+"' size=5 readonly class='koko' >");
          inputQtyS = inputQty;     // 20091217 Marvie Add : yew_runcard_restxns data loss
	    }
		else { 		      
              inputQtyS = rs.getString("QTY_IN_QUEUE");     // 20091217 Marvie Add : yew_runcard_restxns data loss
			  // 2007/04/04 第一站之後,原處理數(投入數)預設為前一站之良品數(移站數)
			  if (rs.getString("QTY_IN_TOMOVE")==null || rs.getString("QTY_IN_TOMOVE").equals("0"))
			    out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 readonly class='koko' >");  
			  else out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 readonly class='koko' >");
			 }				  
		out.println("</TD>");  // 投入數量 (處理數)
		
		
		//班別,是否?自動依處理時間判段所屬班別_起
		out.println("<TD nowrap>");
		         try
                 {   
				   //-----取班別資訊
		           Statement stateWClass=con.createStatement();
                   ResultSet rsWClass=null;	
			       String sqlWClass = " select WKCLASS_CODE, WKCLASS_NAME||'('||WKCLASS_DESC||')' from APPS.YEW_MFG_WORKCLASS ";
			       String whereWClass = " where WORKCLASS_TYPE='1'  ";								  
				   String orderWClass = "  ";  				   
				   sqlWClass = sqlWClass + whereWClass;
				   //out.println(sqlOrgInf);
                   rsWClass=stateWClass.executeQuery(sqlWClass);
		           comboBoxBean.setRs(rsWClass);
		           comboBoxBean.setSelection(wkClass);
	               comboBoxBean.setFieldName("WKCLASS"+rs.getString("RUNCAD_ID"));	   
                   out.println(comboBoxBean.getRsString());
		           rsWClass.close();   
				   stateWClass.close();			
					 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }
		out.println("</TD>");
		//班別,自動依處理時間判段所屬班別_迄
		
		//製程處理工時_起
		out.println("<TD nowrap>");
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{ 	
			out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty+"' size=4 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
        	resourceQtyS = resourceQty;     // 20091217 Marvie Add : yew_runcard_restxns data loss
		}
		else 
		{ 
			if (rs.getString("RES_WKHOUR_OP")==null || !rs.getString("PREVIOUS_OP_SEQ_ID").equals(prevOpSeqID)) //add by Peggy 20120411
			{  
				out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' size=4 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");  
            	resourceQtyS = "0";     // 20091217 Marvie Add : yew_runcard_restxns data loss
			}
			else 
			{
				out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' size=4 value='"+rs.getString("RES_WKHOUR_OP")+"' size=5 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
                resourceQtyS = rs.getString("RES_WKHOUR_OP");     // 20091217 Marvie Add : yew_runcard_restxns data loss
			}
		}				   
		out.println("</TD>");	 
		//製程處理工時_迄
		//異動日期_起  20090603 update by liling
		out.println("<TD nowrap>");
		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		{ 
			out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resEmployee+"' size=7 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");
			resEmployeeS = resEmployee;     // 20091217 Marvie Add : yew_runcard_restxns data loss
		}
		else 
		{ 
			if (rs.getString("RES_EMPLOYEE_OP")==null)
			{ 
				out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+systemDate+"' size=7 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+")>");  
				resEmployeeS = systemDate;     // 20091217 Marvie Add : yew_runcard_restxns data loss
			}
			else 
			{
				out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_EMPLOYEE_OP")+"' size=7 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
				resEmployeeS = rs.getString("RES_EMPLOYEE_OP");     // 20091217 Marvie Add : yew_runcard_restxns data loss
			}
		}
		out.println("</TD>");
		//異動日期_起  20090603 update by liling

		// 機台編號_起
		      out.println("<TD nowrap>");
		      if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		      { out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resMachine+"' size=5 onKeyDown=setTabNext('7',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); }
		      else { 
		             if (rs.getString("RES_MACHINE_OP")==null)
			            out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('7',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>");  
			         else out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown=setTabNext('7',"+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rsPO.getString("QUANTITY")+'"'+","+'"'+rsPO.getString("SEGMENT1")+'"'+","+'"'+rsPO.getString("PR_NUMBER")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+")>"); 
			       }
		out.println("</TD>");
		// 機台編號_迄
		
/*  2006/12/31 By Kerwin Update For Performance Issue, 改由 Procedure 取得
//---------------2006/12/21 抓取站別中文名稱顯示----------起
      		String currOpDesc="",nextOpDesc="",prevOpDesc="";
	  		String sqlpa = " select a.DESCRIPTION CURROP  from WIP_OPERATIONS a  where a.OPERATION_SEQ_NUM = "+rs.getString("OPERATION_SEQ_NUM")+"  and a.WIP_ENTITY_ID = "+entityId+" ";
	  		String sqlpb = " select a.DESCRIPTION PREVOP  from WIP_OPERATIONS a  where a.OPERATION_SEQ_NUM = "+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+"  and a.WIP_ENTITY_ID = "+entityId+" ";
	  		String sqlpc = " select a.DESCRIPTION NEXTOP  from WIP_OPERATIONS a  where a.OPERATION_SEQ_NUM = "+rs.getString("NEXT_OPERATION_SEQ_NUM")+"  and a.WIP_ENTITY_ID = "+entityId+" ";

	 		Statement statepa=con.createStatement();
      		ResultSet rspa=statepa.executeQuery(sqlpa);
	  		if (rspa.next())
	  		{
		  		currOpDesc   = rspa.getString("CURROP");  
				if (currOpDesc==null || currOpDesc.equals("")) currOpDesc = "&nbsp;";
	  			} else { currOpDesc  = "&nbsp;";   }
	  		rspa.close();
      		statepa.close(); 
           
	 		Statement statepb=con.createStatement();
      		ResultSet rspb=statepb.executeQuery(sqlpb);
	  		if (rspb.next())
	  		{
		  		prevOpDesc   = rspb.getString("PREVOP");  
				if (prevOpDesc==null || prevOpDesc.equals("")) prevOpDesc = "&nbsp;";
	  			} else { prevOpDesc  = "&nbsp;";   }
	  		rspb.close();
      		statepb.close(); 

	 		Statement statepc=con.createStatement();
      		ResultSet rspc=statepc.executeQuery(sqlpc);
	  		if (rspc.next())
	  		{
		  		nextOpDesc   = rspc.getString("NEXTOP");  
				if (nextOpDesc==null || nextOpDesc.equals("")) nextOpDesc = "&nbsp;";
	  			} else { nextOpDesc  = "&nbsp;";   }
	  		rspc.close();
      		statepc.close(); 


//---------------2006/12/21 抓取站別中文名稱顯示----------迄
*/		
		out.println("<TD nowrap>"+prevOpDesc+"</TD><TD nowrap><font color='#0000FF'>"+currOpDesc+"</font></TD>");
		if (ospCheckFlag) out.print("<TD nowrap><font color='#990000'><em>"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"("+resourceDesc+")"+"</em></font></TD>");
		else out.print("<TD nowrap>"+nextOpDesc+"</TD>");
		//out.print("<TD nowrap>"+rs.getString("STATUS")+"</TD>");
		out.println("</TR>");
		
		// ############################  WIP Resource Operation API資料取得 _迄 ##############################
		   // String resourceDesc = "";
           // boolean ospCheckFlag = false;

        // 20091110 Marvie Add : Performance Issue
        if (k==0)
		{
           try
           {
              String sqlOPRes = "";
              if (jobType==null || jobType.equals("1"))
              {
                    sqlOPRes =" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
				              "        a.SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
							  "        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
				              "        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
                              " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                              " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					          // "   and b.ORGANIZATION_ID = '"+organizationId+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
					          "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					          "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
							  // 20091110 Marive update
					          //"   and to_char(d.OPERATION_SEQUENCE_ID) = '"+rs.getString("OPERATION_SEQUENCE_ID")+"' "+
					          "   and d.OPERATION_SEQUENCE_ID = '"+rs.getString("OPERATION_SEQUENCE_ID")+"' "+
					          "    "; // Outside Processing Checked
					   
              } else if (jobType.equals("2"))
                      {
		                     sqlOPRes =  " select c.RESOURCE_SEQ_NUM, c.RESOURCE_ID, c.USAGE_RATE_OR_AMOUNT, c.BASIS_TYPE, "+
				                         "        c.SCHEDULE_FLAG, c.AUTOCHARGE_TYPE, c.STANDARD_RATE_FLAG, c.SCHEDULE_SEQ_NUM, "+
							             "        c.PRINCIPLE_FLAG, c.ASSIGNED_UNITS, "+
										 "        d.UNIT_OF_MEASURE, d.AUTOCHARGE_TYPE "+
			               				 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  			             " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							             " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							             " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							             " and a.WIP_ENTITY_ID = "+entityId+" "+
							             " and a.RUNCARD_NO ='"+runCardNo+"' "+
							             " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							             " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
							             " and d.ORGANIZATION_ID = '"+organizationId+"' "; 
			             if (runCardID==null || runCardID.equals("0")) sqlOPRes = sqlOPRes +" and a.RUNCARD_NO ='"+runCardNo+"' ";
                         else  sqlOPRes = sqlOPRes + " and a.RUNCAD_ID ='"+rs.getString("RUNCAD_ID")+"' " ;					
		              }		
              //out.println("<BR>sqlOPRes="+sqlOPRes);					   
              Statement stateOPRes=con.createStatement();
              ResultSet rsOPRes=stateOPRes.executeQuery(sqlOPRes);
              if (rsOPRes.next())
              { 	                  
					r[k][0]=rsOPRes.getString("RESOURCE_SEQ_NUM");r[k][1]=rsOPRes.getString("RESOURCE_ID");r[k][3]=rsOPRes.getString("USAGE_RATE_OR_AMOUNT");r[k][4]=rsOPRes.getString("BASIS_TYPE");
					r[k][5]=rsOPRes.getString("SCHEDULE_FLAG");r[k][6]=rsOPRes.getString("AUTOCHARGE_TYPE");r[k][7]=rsOPRes.getString("STANDARD_RATE_FLAG");r[k][8]=rsOPRes.getString("SCHEDULE_SEQ_NUM");
					r[k][9]=rsOPRes.getString("PRINCIPLE_FLAG");r[k][10]=rsOPRes.getString("UNIT_OF_MEASURE");r[k][11]=rsOPRes.getString("AUTOCHARGE_TYPE");r[k][12]=rs.getString("RUNCAD_ID");	
					r[k][13]=rs.getString("OPERATION_SEQ_NUM");r[k][14]=rsOPRes.getString("ASSIGNED_UNITS");   
					r[k][15]=rs.getString("OPERATION_SEQUENCE_ID");r[k][16]=rs.getString("PRIMARY_ITEM_ID");r[k][17]=rs.getString("RUNCARD_NO"); 
					arrMFGPOResBean.setArray2DString(r);
					//out.println("r[k][10]="+r[k][10]);
              }
              rsOPRes.close();
              stateOPRes.close();	   
          } //end of try
          catch (Exception e)
          {
		     e.printStackTrace();
             out.println("Exception runcard:"+e.getMessage());
          }	   
        // 20091110 Marvie Add : Performance Issue
		} else {
					r[k][0]=r[0][0];r[k][1]=r[0][1];r[k][3]=r[0][3];r[k][4]=r[0][4];
					r[k][5]=r[0][5];r[k][6]=r[0][6];r[k][7]=r[0][7];r[k][8]=r[0][8];
					r[k][9]=r[0][9];r[k][10]=r[0][10];r[k][11]=r[0][11];
                    r[k][12]=rs.getString("RUNCAD_ID");    //20091110 RUNCARD_ID / NO 每一批不同,故不能與第一批一樣
					r[k][13]=r[0][13];r[k][14]=r[0][14];   
					r[k][15]=r[0][15];r[k][16]=r[0][16];
                    r[k][17]=rs.getString("RUNCARD_NO"); 
					arrMFGPOResBean.setArray2DString(r);
        //out.println("<br>2.  r["+k+"][0]="+r[k][0]);
		}  //end if (k==0)

		
	  // ############################  WIP Resource Operation API資料取得 _迄 ##############################
		// out.println("ospCheckFlag="+Boolean.toString(ospCheckFlag)); out.println("singLastOp="+Boolean.toString(singLastOp));
		 b[k][0]=rs.getString("RUNCAD_ID");b[k][1]=rs.getString("RUNCARD_NO");b[k][2]=rs.getString("QTY_IN_TOMOVE");b[k][3]=rs.getString("PREVIOUS_OPERATION_SEQ_NUM");b[k][4]=rs.getString("OPERATION_SEQ_NUM");b[k][5]=rs.getString("NEXT_OPERATION_SEQ_NUM");b[k][6]=rs.getString("STATUS");		 
		 b[k][7]=rs.getString("CREATION_DATE");b[k][8]=rs.getString("ORGANIZATION_ID");b[k][9]=rs.getString("OSP_REC_QTY");b[k][10]=rs.getString("OSP_REC_DEFREASON");
		 b[k][11]=rsPO.getString("PO_HEADER_ID");b[k][12]=rsPO.getString("PO_LINE_ID");b[k][13]=rsPO.getString("LINE_LOCATION_ID");b[k][14]=rs.getString("QTY_IN_QUEUE");
		 b[k][15]=rsPO.getString("PR_NUMBER");b[k][16]=rsPO.getString("SEGMENT1");b[k][17]=convToMoveQty; // 把給定或換算的移站數給Array
		 b[k][18]=queueQty;b[k][19]=Boolean.toString(ospCheckFlag);b[k][20]=Boolean.toString(singLastOp);  // 2006/12/31 把下一站資訊給 b[k][19], 是否最後一站給 b[k][20]
		 b[k][21]=rs.getString("QTY_IN_SCRAP");
		 // 20091217 Marvie Add : yew_runcard_restxns data loss
		 b[k][22]=scrapQtyS;
		 b[k][23]=inputQtyS;
		 b[k][24]=resourceQtyS;
		 b[k][25]=resEmployeeS;
		 b[k][26]=resEmployeeS+sTime;
		 b[k][27]=r[k][0];     // RESOURCE_SEQ_NUM
		 b[k][28]=r[k][1];     // RESOURCE_ID
		 b[k][29]=r[k][10];    // TRANSACTION_UOM
//out.println("<br>scrapQtyS="+scrapQtyS+"<br>");
//out.println("<br>inputQtyS="+inputQtyS+"<br>");
//out.println("<br>resourceQtyS="+resourceQtyS+"<br>");
//out.println("<br>resEmployeeS="+resEmployeeS+"<br>");
//out.println("<br>resEmployeeS+sTime="+resEmployeeS+sTime+"<br>");
		 /*
		 if (rs.getString("OSP_REC_QTY")==null || rs.getString("OSP_REC_QTY").equals("0"))
		 {
		   b[k][9] = rsPO.getString("QUANTITY"); // 若未點擊Set 即直接作RECEIVE動作,則,將原PO數量作為收料數量
		   queueQty = b[k][9];
		 }
		 */
		 arrMFGRCPOReceiptBean.setArray2DString(b);		 
		 k++;
		 //out.println("k2="+k); 
		 } // End of if (rsPO.next())
		 
		 rsPO.close();
		 statePO.close();
	   }// End of While 	   	   	 
	   out.println("</TABLE>");
	   statement.close();
       rs.close();  	         
     // out.println("runCardID"+runCardID);
 
        if (runCardID !=null && scrapQty!=null && !scrapQty.equals(""))
	    { //out.println("COMMENT UPDATE="+comment);
		  
		   
	        String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_SCRAP=?, QTY_AC_SCRAP=? ,RES_EMPLOYEE_OP=?"+
		                 " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
//out.println("<BR>sql="+sql+"<BR>");
//out.println("<BR>resEmployee="+resEmployee+"<BR>");
	        PreparedStatement pstmt=con.prepareStatement(sql);  
            pstmt.setString(1,scrapQty);     // 本次報廢數量更新
			pstmt.setString(2,scrapQty);     // 本次User報廢數量更新
			pstmt.setString(3,resEmployee);  // 20090603 異動日期		  
		    pstmt.executeUpdate(); 
            pstmt.close();
		   
		} // End of if 報廢數寫入
 
	   //out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	    if (runCardID !=null && queueQty!=null && !queueQty.equals("")) // 一併更新串連PR及PO資訊
		//if (runCardNo !=null && queueQty!=null && !queueQty.equals("")) // 一併更新串連PR及PO資訊
	    { //out.println("要移的數量convToMoveQty="+convToMoveQty);		  
		  
		 //if (defFlag==null || defFlag.equals("")) defFlag="N";
		
		 for (int kk=0;kk<b.length;kk++) // 依批次處理的PO或PR號碼
		 {		 	
		  if (runCardID==b[kk][0] || runCardID.equals(b[kk][0]))
		  {	// out.println("queueQty="+queueQty);
	        String sql = "update APPS.YEW_RUNCARD_ALL set OSP_REC_QTY=?, OSP_REC_DEFREASON=?, OSP_PR_NUM =?, OSP_PO_NUM=?, OSP_REC_DEFFLAG=?, "+
		                 " QTY_IN_TOMOVE=?, QTY_IN_INPUT=? "+
		                 " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
		    //out.println("queueQty="+queueQty);
			//out.println("defFlag="+defFlag);
		    //out.println("convToMoveQty="+convToMoveQty);
	        PreparedStatement pstmt=con.prepareStatement(sql);        
		    pstmt.setFloat(1,Float.parseFloat(queueQty));  // 本次收料數量更新(queueQty)
		    pstmt.setString(2,ospPORecDef);  // 本次不良原因輸入
		    pstmt.setString(3,b[kk][15]);  // PR_NUM
		    pstmt.setString(4,b[kk][16]);  // PO_NO 依傳入的PO號碼
		    pstmt.setString(5,defFlag);  // Defect Flag
		    pstmt.setFloat(6,Float.parseFloat(b[kk][17])); // Qty To Move 要移站的數量
			pstmt.setFloat(7,Float.parseFloat(queueQty)+Float.parseFloat(scrapQty));     // 本次處理數量更新
		    pstmt.executeUpdate(); 
            pstmt.close();
			
			//out.println("b[kk][2]="+b[kk][2]);
			
		  } // End of if (runCardID==b[kk][0])
		 } // End of for ()
		 
		  // %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _起
	  
//out.println("<BR>runCardID="+runCardID+"<BR>");
		    for (int rr=0;rr<r.length;rr++)
			{
//out.println("<BR>r["+rr+"][12]="+r[rr][12]+"<BR>");
			  if (runCardID==r[rr][12] || runCardID.equals(r[rr][12]) )
			  {   //out.println("RESOURCE_SEQ_NUM="+r[rr][0]+" RESOURCE_ID="+r[rr][1]+" USAGE_RATE_OR_AMOUNT="+r[rr][2]+" UNIT_OF_MEASURE="+r[rr][10]);
			      //out.println("OPERATION_SEQ_NUM="+r[rr][13]+" AUTOCHARGE_TYPE="+r[rr][6]+" SCHEDULE_SEQ_NUM="+r[rr][8]+" AUTOCHARGE_TYPE="+r[rr][11]);
				  //out.println("OPERATION_SEQ_ID="+r[rr][15]);
				  
				   String sqlResRowID =" select a.ROWID, b.ORGANIZATION_CODE from WIP_OPERATION_RESOURCES a, MTL_PARAMETERS b "+
				                       " where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.WIP_ENTITY_ID="+entityId+" "+
									   "   and a.OPERATION_SEQ_NUM='"+r[rr][13]+"' and a.RESOURCE_SEQ_NUM='"+r[rr][0]+"' ";
//out.println("<BR>sqlResRowID="+sqlResRowID+"<BR>");
	               Statement stateResRowID=con.createStatement();
                   ResultSet rsResRowID=stateResRowID.executeQuery(sqlResRowID);
				   if (rsResRowID.next())
				   {	//String resourceQty = "0.5";	  
				        String groupId = "0";  
						String respID = "0";    
			            
						
						boolean intResExist = false; // 找到 Interface 內的有待回報的
						boolean rCardResExt = false; // 或者找到流程卡已寫入異動的..						
						boolean resResExist = false; // 或者改流程卡找到已更新至工單資源回報的
	                    Statement stateExist=con.createStatement();	 
						            
	                    ResultSet rsIntExist=stateExist.executeQuery(" select ATTRIBUTE2 from WIP_COST_TXN_INTERFACE "+
						                                             " where WIP_ENTITY_ID="+entityId+" and ORGANIZATION_ID = "+organizationId+" "+
																     "   and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' ");
				        if (rsIntExist.next()) intResExist = true;
				        rsIntExist.close();
						//out.println("rsIntExist=TTT");
						ResultSet rsRCResExt=stateExist.executeQuery(" select RUNCARD_NO from YEW_RUNCARD_RESTXNS "+
						                                             " where WO_NO='"+woNo+"' and RUNCARD_NO='"+r[rr][17]+"' "+
																     "   and OPERATION_SEQ_NUM = '"+r[rr][13]+"'  ");
				        if (rsRCResExt.next()) rCardResExt = true;
				        rsRCResExt.close();
						ResultSet rsResExist=stateExist.executeQuery(" select ATTRIBUTE2 from WIP_OPERATION_RESOURCES "+
						                                             " where WIP_ENTITY_ID="+entityId+" and ORGANIZATION_ID = "+organizationId+" "+
																     " and OPERATION_SEQ_NUM="+Integer.parseInt(r[rr][13])+" and ATTRIBUTE2='"+r[rr][17]+"' ");
				        if (rsResExist.next()) resResExist = true;
				        rsResExist.close();					
						//out.println("rsIntExist=QQQ");
				        stateExist.close();
						
					    // -- 取此Organization對應的ACCT_PERIOD_ID
						
						 
						if (intResExist || rCardResExt || resResExist) {  } // 若已經回報過工時資源檔,則不再寫一次 }
						else { // ######### Step1.寫 Resource Cost Txn Interface #############
						       // ORG_ACCT_PERIODS_V --> 若需要Account Period ID 的View 
							      // Step2. ################ 寫 APPS.YEW_RUNCARD_RESTXNS WIP系統RunCard Resource Transaction  ################  
							      String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, QTY_IN_INPUT, CREATED_BY, LAST_UPDATED_BY, "+
						                                                                " OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, "+
																	                    " AUTOCHARGE_TYPE, WKCLASS_CODE, WKCLASS_NAME, WORK_EMPLOYEE, WORK_EMPID, WORK_MACHINE, WORK_MACHNO, WIP_ENTITY_ID, QTY_AC_SCRAP , TRANSACTION_DATE) "+
															                    " values( '"+woNo+"', '"+r[rr][17]+"', "+inputQty+", '"+userMfgUserID+"', '"+userMfgUserID+"', "+															              
															                    "         "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
															                    "         "+Integer.parseInt(r[rr][1])+", "+resourceQty+", '"+r[rr][10]+"', 2 , "+
														                        "         '"+wkClass+"', 'N/A', '"+resEmployee+"', '0','"+resMachine+"','N/A', '"+entityId+"', '"+scrapQty+"','"+resEmployee+"'||'"+sTime+"'  ) ";		                              
//out.println("<BR>resTxnSql="+resTxnSql+"<BR>");
						          PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                        
		                          pstmtResTxn.executeUpdate(); 
                                  pstmtResTxn.close(); 
                                //  con.commit; 
/* 20091110 Liling disable performance issue:OSP工時為0就固定不丟INTERFACE 了								   
							   if (Float.parseFloat(resourceQty)>0) // if (回報工時>0才寫Interface ) 2007/02/12
							   {
							     int acctPeriodID = 0; 
	                             Statement stateACP=con.createStatement();	             
	                             ResultSet rsACP=stateACP.executeQuery("select ACCT_PERIOD_ID from ORG_ACCT_PERIODS_V where ORGANIZATION_ID = "+organizationId+" ");
				                 if (rsACP.next()) acctPeriodID = rsACP.getInt(1);
				                 rsACP.close();
				                 stateACP.close();
					             String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                                                          " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, ORGANIZATION_CODE, WIP_ENTITY_ID, "+
																	              " ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
																	              " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
																		          " WIP_ENTITY_NAME, ACCT_PERIOD_ID, PRIMARY_ITEM_ID, ATTRIBUTE2 ) "+
															              " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
															              "         1, 1, 1, '"+organizationId+"', '"+rsResRowID.getString("ORGANIZATION_CODE")+"', '"+entityId+"', "+
															              "         1, to_date('"+resEmployee+"'||'"+sTime+"','yyyymmddhh24miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
															              "         "+Integer.parseInt(r[rr][1])+", "+resourceQty+", '"+r[rr][10]+"', 2 , "+
														                  "         '"+woNo+"', "+acctPeriodID+", "+r[rr][16]+", '"+r[rr][17]+"' ) ";		                              
						          PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                          pstmtRes.executeUpdate(); 
                                  pstmtRes.close();
							      //out.println("rsIntExist=RRR");	
							      //out.println("rsIntExist=OOO");
								} // End of if (回報工時>0才寫Interface ) 
*/
							 } // End of else { 未回報過才寫WIP_COST_TXN_INTERFACE }
					  
				 	} //end of if (rsResRowID.next())	  
					rsResRowID.close();
					stateResRowID.close();	  
							
			  }// end of if (runCardID.equals(r[rr][12]))
			}		  
		  // %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _迄
	  
        } // End of if (runCardNo!=null && queueQty!=null) 
       } //end of try
       catch (Exception e)
       {
	    e.printStackTrace();
        out.println("Exception Update RunCardID Set Information:"+e.getMessage());
       }
	   
	     String a[][]=arrMFGRCPOReceiptBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
         if (a!=null) 
		 {		  
		    //  out.println(a[0][0]+" ; "+a[0][1]+" ; "+a[0][2]+" ; "+a[0][3]+" ; "+a[0][4]+"<BR>"); 
		 }	//enf of a!=null if		
		
    %> 
 </font>      
  </tr>       
</table>

<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->

<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF" border="0">          
   <tr bgcolor="#CCCC99"> 
     <td width="10%" nowrap>本次收料處理說明:</td>
	 <td>
        <INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
		<INPUT type="hidden" name="WORKTIME" value="0">
        <INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 >           
     </td>
   </tr>          
</table>

<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
    <%
	  try
      {  //out.println("frStatID="+frStatID);
	   //out.println("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");     
	   String sqlAction = null;
	   if (!singLastOp) //  不為最後一站,則可執行Transfer
	   { 
	     if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		 {
		     sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018') "; 	
		 }
		 else { //不為最後一站,則可執行Transfer(亦執行收料完後,會自動移站,針對產生出來的移站Transaction要去加Attribute2流程卡)
	           sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('006') "; 	   
		      }
	   }
	   else {  //out.println("1");//  本站為最後一站,則可執行Complete
	           if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		       {//out.println("2");
		         sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('023') "; 	
		       }
		       else {//out.println("3"); //不為最後一站,則可執行收料
	                 sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('018') "; 	   
		            }	           
	        }
	   //out.println(sqlAction);	
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery(sqlAction);
       //comboBoxBean.setRs(rs);
	   //comboBoxBean.setFieldName("ACTIONID");	   
       //out.println(comboBoxBean.getRsString());	   
	   out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRunCardOSPReceipt.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+"&EXPAND="+expand+'"'+")'>");				  				  
	   out.println("<OPTION VALUE=-->--");     
	   while (rs.next())
	   {            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(actionID)) 
  		{
          out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
        } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
               }        
	   } //end of while
	   out.println("</select>"); 
	   
	   
	   rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   rs.next();
	   if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	   {
	     if (!ospCheckFlag) // 若下一站不為委外加工站,則呼叫正常移站處理頁面_起
		 {
            //out.println("<INPUT TYPE='submit' NAME='submit2' value='Submit'>");
			if (!singLastOp) // 下一站不為最後一站
			{			  
			  out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行外包收料入庫作業並繼續移站?"+'"'+")'>");
			} else {			         
					 out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行外包收料入庫作業?"+'"'+")'>");
			       }
		 } else {
		          if (!singLastOp) // 下一站不為最後一站
			      {
		            out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行移至委外加工站?"+'"'+")'>");
				  } else {
				            out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行移至委外加工站?"+'"'+")'>"); 
				         } 
		        } // 若下一站不為委外加工站,則呼叫正常移站處理頁面_迄
		 out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
	   } 
       rs.close();       
	   statement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></a></td></tr></table>
 <!-- 表單參數 --> 
 <INPUT type="hidden" SIZE=5 name="RUNCARD_NO" value="<%=runCardNo%>" readonly>
 <INPUT type="hidden" SIZE=5 name="PO_NO" value="<%=poNo%>" readonly>
 <INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
 <INPUT type="hidden" SIZE=5 name="OP_SEQ" value="<%=operSeqNum%>" readonly>
 <INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
 <INPUT type="hidden" SIZE=5 name="AFLAG" value="<%=aFlag%>" readonly>
   <input type="hidden" NAME="SYSDATE" value="<%=systemDate%>"> 
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>


