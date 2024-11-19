<!-- 20090505 liling 將for 人工打入異動日期,以原'作業員'RES_EMPLOYEE_OP 欄位做為異動日期-->
<!-- 20091110 Marvie performance tuning-->
<!-- 20110902 liling update AR_CUSTOMERS_V ->AR_CUSTOMERS for R12 issue  -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>MFG System Run Card Complete Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCCompleteBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrMFGCompResBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
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
 		return "取消選取"; 
	}
 	else 
	{
 		for (i = 0; i < field.length; i++) 
		{
 			field[i].checked = false; 
		}
 		checkflag = "false";
	 	return "全部選取"; 
	}
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
	var linkURL = "#ACTION";
 	var pcAcceptDate=pcAcceptDate="&PCACPDATE="+document.DISPLAYREPAIR.PCACPDATE.value; 
  	document.DISPLAYREPAIR.action=URL+pcAcceptDate;
  	document.DISPLAYREPAIR.submit()+linkURL;    
}
function setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue, xRtOverValue, xPrevQty, xRunCardQty, prevOpSeqNum, woType, nextSeqId, xMACHINEWKHour)
{   
  	//alert("可超出數="+xOverValue+"  超出數sum="+xRtOverValue+"  前站移站數="+xPrevQty); 
  	//var linkURL = "#ACTION";  
  	formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  	formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  	xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數
  
  	// 2007/03/27 可手動輸入報廢數 By Kerwin
  	formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  	formSCRAPQTY_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  	xSCRAPQTY = eval(formSCRAPQTY_Write);  // 把值取得給java script 變數
  	// 2007/03/27 可手動輸入報廢數 By Kerwin
  
  	formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  	formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  	xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數
  
  	formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  	formSCRAP_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  	xSCRAPQTY = eval(formSCRAP_Write);  // 把值取得給java script 變數
  
  	formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  	formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  	xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  	try
	{
		formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
		formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
		xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數(人工工時)
	}
	catch(err)
	{
		xRESOURCEQTY ="*";
	}

	try
	{
		formRESOURCEMACHINEQTY = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".focus()";
		formRESOURCEMACHINEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".value";
		xRESOURCEMACHINEQTY = eval(formRESOURCEMACHINEQTY_Write);  // add by Peggy 20120313,把值取得給java script 變數(機器工時)
	}
	catch(err)
	{
		xRESOURCEMACHINEQTY ="*";
	}
  
  
  	formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  	formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  	xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  	formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  	formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  	xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數
  
    txt1=xQUEUEQTY;	    //檢查移站數量是否為數字
    for (j=0;j<txt1.length;j++)      
    { 
    	c=txt1.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
			alert("移站數量必需為數值型態!!");
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
	   
	txt2=xINPUTQTY;	    //檢查投入數量是否為數字
    for (j=0;j<txt2.length;j++)      
    { 
    	d=txt2.charAt(j);
	    if ("0123456789.".indexOf(d,0)<0) 
	    {
			alert("移站數量必需為數值型態!!");
		  	eval(formINPUTQTY); // 取得焦點		     
		  	return(false);
	    }
    }
	   
	if (xRESOURCEMACHINEQTY != "*")
  	{
		txt31=xRESOURCEMACHINEQTY;	 //檢查工時回報數量是否為數字
		for (j=0;j<txt31.length;j++)      
		{ 
			e=txt31.charAt(j);
			if ("0123456789.".indexOf(e,0)<0) 
			{
				alert("機器工時回報數量必需為正數值型態!!");
				eval(formRESOURCEMACHINEQTY); // 取得焦點		     
				return(false);
			}
		}

		if (xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="" || xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="")
		{
			alert("請至少輸入機器工時回報資訊 !!!");
			eval(formRESOURCEMACHINEQTY);
			return false;
		}
	  
		if (eval(xRESOURCEMACHINEQTY)>=40 )   //Liling 2007/08/30 add 因yew老是超打工時,故提出警示需求
		{
			alert("請注意此批機器工時已大於40小時 !!!");
			eval(formRESOURCEMACHINEQTY);
			return false;
		} 
	}
	else
	{
		xRESOURCEMACHINEQTY  = "";
	}
	
	if (xRESOURCEQTY != "*")
  	{
		txt3=xRESOURCEQTY;	 //檢查工時回報數量是否為數字
		var fieldname = document.DISPLAYREPAIR.worktimes_p.value;
		for (j=0;j<txt3.length;j++)      
		{ 
			e=txt3.charAt(j);
			if ("0123456789.".indexOf(e,0)<0) 
			{
				alert(fieldname+"工時回報數量必需為數值型態!!");
				eval(formRESOURCEQTY); // 取得焦點		     
				return(false);
			}
		}
  		if (xRESOURCEQTY==null || xRESOURCEQTY=="" || xRESOURCEQTY==null || xRESOURCEQTY=="")
  		{
   			alert("請至少輸入"+fieldname+"工時回報資訊 !!!");
   			eval(formRESOURCEQTY);
   			return false;
  		}

  		if (eval(xRESOURCEQTY)>=40 )   //Liling 2007/08/30 add 因yew老是超打工時,故提出警示需求
  		{
   			alert("請注意此批"+fieldname+"工時已大於40小時 !!!");
   			//eval(formRESOURCEQTY);
   			eval(formRESOURCEQTY);
   			return false;
  		} 
	}
	else
	{
		xRESOURCEQTY = "";
	}
	
	txt4=xSCRAPQTY;	 //檢查報廢數量是否為數字
    for (j=0;j<txt4.length;j++)      
    { 
    	e=txt4.charAt(j);
	    if ("-0123456789.".indexOf(e,0)<0) 
	    {
			alert("報廢數量必需為數值型態!!");
		  	eval(formSCRAPQTY); // 取得焦點		     
		  	return(false);
	    }
    }  

	txt5=xRESEMPLOYEE;	 //檢查移站日期是否為數字 20090505
    for (j=0;j<txt5.length;j++)      
    { 
    	e=txt5.charAt(j);
	    if ("0123456789.".indexOf(e,0)<0) 
	    {
			alert("移站日期錯誤!!");
		  	eval(formRESEMPLOYEE); // 取得焦點		     
		  	return(false);
	    }
    } 
  
  	if (txt5.length < 8 || txt5.length > 8 )  //檢查日期長度 20090505
   	{
    	alert("移站日期錯誤!!!");
   		//eval(formRESOURCEQTY);
   		eval(formRESEMPLOYEE);
   		return false;
  	} 
	
	if (parseFloat(txt5) > parseFloat(document.DISPLAYREPAIR.SYSTEMDATE.value)) //日期不可為未來日期或已關帳月份,add by Peggy 20140303
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
			if (document.DISPLAYREPAIR.ACCPERIOD.options[j].value ==txt5.substring(0,6))
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
	
  	if (xQUEUEQTY==null || xQUEUEQTY=="" || xINPUTQTY==null || xINPUTQTY=="")
  	{
   		alert("請輸入投產或移站數量 !!!");
   		eval(formINPUTTY);
   		return false;
  	}
  
  	if (eval(xInQueueQty)<eval(xQUEUEQTY) || eval(xInQueueQty)<eval(xINPUTQTY))
  	{ 
    	//alert("移站數量="+xQUEUEQTY+"\n 投產數="+xInQueueQty);	
		//alert("移站數量不得大於原投入數量\n         請重新輸入 !!!");	
    	alert("注意!移站數大於投入數!!!");	
		eval(formQUEUEQTY);
		//return false;
  	}
 
  	if ((eval(xOverValue)+eval(xRunCardQty)) < eval(xQUEUEQTY) || (eval(xOverValue)+eval(xRunCardQty))<eval(xInQueueQty))
  	{ 
    	//alert("移站數量="+xQUEUEQTY+"\n 投產數="+xInQueueQty);	
		alert("移站數量不得大於超額完工比率\n         請重新輸入 !!!");	
		eval(formQUEUEQTY);
		return false;
  	}

  	if (eval(xSCRAPQTY)>0 && eval(xQUEUEQTY)>eval(xInQueueQty))
  	{
		alert("警告!超額完工(OverComplete)\n不應再輸入報廢數,請再確認!!!");
		eval(formSCRAPQTY);
		return false;
  	}
    
  	if (woType=="3" && nextSeqId==0)
  	{   
		if (eval(xQUEUEQTY)!=eval(xRunCardQty) || eval(xSCRAPQTY)!=0)
	 	{  
			alert("此為後段工令最後一站,限定良品數需為流程卡數 !!!"); 
			eval(formQUEUEQTY);
			return false;
		}  
		else 
		{ 
			eval(formSCRAPQTY);  
		}  //
  	}
  
  	var linkURL = "#"+xINDEX;
  
  	document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目	  
  	document.DISPLAYREPAIR.submit2.disabled = false;  
  	//document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&RUNCARDID="+xINDEX+linkURL;
  	document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&INPUTQTY"+xINDEX+"="+xINPUTQTY+"&SCRAPQTY"+xINDEX+"="+xSCRAPQTY+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&RESEMPLOYEE"+xINDEX+"="+xRESEMPLOYEE+"&RUNCARDID="+xINDEX+"&RESOURCEQTY_MACHINE"+xINDEX+"="+xRESOURCEMACHINEQTY+linkURL;  
  	document.DISPLAYREPAIR.submit();  
}

function setTabNext(tabNextIndex, URL, xINDEX, xInQueueQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee, xOverValue, xRtOverValue, xPrevQty, xRunCardQty, woType, nextSeqId, prevOpSeqNum, prevOpDescFlag, xMACHINEWKHour)
{ //alert(tabNextIndex);
	//alert(xINDEX);
  	formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  	formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  	xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數
  
  	formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  	formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  	xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數
  
  	// 2007/03/27 可手動輸入報廢數 By Kerwin
  	formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  	formSCRAPQTY_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  	xSCRAPQTY = eval(formSCRAPQTY_Write);  // 把值取得給java script 變數
  	// 2007/03/27 可手動輸入報廢數 By Kerwin
  
  	formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  	formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  	xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  	try
	{
		formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
		formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
		xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數(人工工時)
	}
	catch(err)
	{
		xRESOURCEQTY ="*";
	}

	try
	{
		formRESOURCEMACHINEQTY = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".focus()";
		formRESOURCEMACHINEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".value";
		xRESOURCEMACHINEQTY = eval(formRESOURCEMACHINEQTY_Write);  // add by Peggy 20120313,把值取得給java script 變數(機器工時)
	}
	catch(err)
	{
		xRESOURCEMACHINEQTY ="*";
	}
  
  	formRESMACHINE = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".focus()";
  	formRESMACHINE_Write = "document.DISPLAYREPAIR.RESMACHINE"+xINDEX+".value";
  	xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數
  
  	formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  	formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  	xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數
  
   	var calScrapQty = xInQueueQty - xQUEUEQTY;  // 預計報廢數 = 處理數 - 良品數
   	//var calInQueueQty = eval(xQUEUEQTY) + eval(xSCRAPQTY);   // 若是第一站,則 處理數 = 良品數 + 報廢數
   	var calInQueueQty = Math.round((eval(xQUEUEQTY)+eval(xSCRAPQTY))*1000)/1000; // 若是第一站,則 處理數 = 良品數 + 報廢數

   	if (event.keyCode==13) // event.keycode = 13 --> Enter 鍵 
   	{ 
    	if (tabNextIndex=="1")
	  	{
	    	// 判斷若下一站SEQ ID = 0 則表示為最後一站,且如為後段工令,則需限制移站數 = 流程卡數
		 	if (woType=="3" && nextSeqId==0)
		 	{
		    	if (eval(xQUEUEQTY)!=eval(xRunCardQty))
				{  
			   		alert("此為後段工令最後一站,限定良品數需為流程卡數 !!!"); 
			   		eval(formQUEUEQTY);
			   		return false;
				}  
				else 
			    { 
					eval(formSCRAPQTY);  
				}  // setFocus 到報廢數 
		 	} 
			else 
			{
	        	if (xQUEUEQTY<xInQueueQty) // 若良品數 < 處理數,則自動計算報廢數
				{ //alert("calScrapQty="+calScrapQty); alert("xInQueueQty="+xInQueueQty); alert("xQUEUEQTY="+xQUEUEQTY);  
		        	calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		            document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
				} 
				else 
				{ // 否則表示OverComplete 不會有報廢數
					document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=0;
				}
	            eval(formSCRAPQTY);  // setFocus 到報廢數
			}
	  	} 
		else if (tabNextIndex=="10")
	    {
			if (prevOpSeqNum=="0") // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_起
		    {
		    	calInQueueQty = Math.round(calInQueueQty*1000)/1000;  // 取到小數後3位,四捨五入	   
		        document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value = calInQueueQty
		        //alert("calInQueueQty="+calInQueueQty);
		    } 
			else 
			{
		    	// 若不是第一站,則限制 良品數 + 報廢數 不得大於 處理數
				if ((eval(xQUEUEQTY) + eval(xSCRAPQTY)) != xINPUTQTY)
				{
					alert("良品數+報廢數必需等於處理數\n            請再確認!!!");
					eval(formSCRAPQTY);  // setFocus 到報廢數  
					return false;
				}
		    } // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_迄 
			eval(formWKCLASS);  // setFocus 到投入數(處理數)改成移焦點到班別,因為處理數由系統自行運算
		}	  
	  	else if (tabNextIndex=="2")
	    {
			eval(formWKCLASS);  // setFocus 到班別 
		} 
		else if (tabNextIndex=="3") 
		{
			if (xRESOURCEMACHINEQTY!="*")
			{
		   		eval(formRESOURCEMACHINEQTY); // setFocus 到機器工時
			}
			else
			{
				xRESOURCEMACHINEQTY ="";
				eval(formRESOURCEQTY); // setFocus 到人工工時
				
			}
		} 
		else if (tabNextIndex=="4") 
		{
			if (xRESOURCEQTY !="*")
			{
		   		eval(formRESOURCEQTY); // setFocus 到人工工時
			}
			else
			{
				xRESOURCEQTY ="";
				eval(formRESEMPLOYEE); // setFocus 到製程處理人員
			}
		} 		
		else if (tabNextIndex=="5")
		{	
			eval(formRESEMPLOYEE); // setFocus 到製程處理人員
		} 
		else if (tabNextIndex=="6")
		{
			eval(formRESMACHINE);  // setFocus 到製程機台號 
		} 
		else if (tabNextIndex=="7")
		{
			setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue, xRtOverValue, xPrevQty, xRunCardQty, prevOpSeqNum, woType, nextSeqId , xMACHINEWKHour);
		}
   	} // End of if (event.keyCode==13)
   
   	if (event.keyCode==9) // event.keycode = 9 --> Tab 鍵
   	{
    	txt1=xQUEUEQTY;	    //檢查移站數量是否為數字
       	for (j=0;j<txt1.length;j++)      
       	{ 
        	c=txt1.charAt(j);
	     	if ("0123456789.".indexOf(c,0)<0) 
	     	{
		  		alert("移站數量必需為正數值型態!!");
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
		  		alert("報廢數量必需為正數值型態!!");
		  		eval(formSCRAPQTY); // 取得焦點		     
		  		return(false);
	     	}
       	}   
   
        if (tabNextIndex=="1" || tabNextIndex=="10")
		{
			if (woType=="3" && nextSeqId==0)
		    {
		    	if (eval(xQUEUEQTY)!=eval(xRunCardQty) || eval(xSCRAPQTY)!=0)
			    {  
			    	alert("此為後段工令最後一站,限定良品數需為流程卡數 !!!"); 
			        eval(formQUEUEQTY);
			        return false;
			    }  
				else 
			    { 
					eval(formSCRAPQTY);  
				}  //
		    }
            if (xQUEUEQTY<xInQueueQty) // 若良品數 < 處理數,則自動計算報廢數
			{ //alert("1");
		    	calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		        document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
			} 
			else 
			{ // 否則判斷報廢數是否為0, 不為零, 良品數 + 報廢數 = 自動計算處理數
				if (xQUEUEQTY>xInQueueQty) // 若 良品數 > 處理數,則判斷
				{   //alert(xQUEUEQTY); alert(xSCRAPQTY);
					if (eval(prevOpDescFlag)>0) // 若前一站為切割,則允許良品數>處理數, 且自動計算處理數及報廢數
					{
						calInQueueQty = Math.round(calInQueueQty*1000)/1000;  // 取到小數後3位,四捨五入	   
		                document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value = calInQueueQty
		                //alert("calInQueueQty="+calInQueueQty);  
						calScrapQty = calInQueueQty - xQUEUEQTY; // 重算報廢數,因良品數>處理數
						calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		                document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
					} 
					else 
					{
						alert("              警告\n良品數不得大於處理數 !!!");  
						eval(formQUEUEQTY);
						return false;
					}
				}
			}	
		} 
		else if (tabNextIndex=="7")
		{				     
			setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue, xRtOverValue, xPrevQty, xRunCardQty, prevOpSeqNum, woType, nextSeqId , xMACHINEWKHour);
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

function setCompleteSubmit(URL,ms1)
{
	var linkURL = "#ACTION";
    if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
    	alert("請選擇執行動作!!!");
	 	document.DISPLAYREPAIR.ACTIONID.focus(); 
	 	return(false);
    }

  	if (document.DISPLAYREPAIR.ACTIONID.value=="012")  //COMPLETE表示為確認移站轉至COMPLETE動作
  	{
    	flag=confirm(ms1);      
        if (flag==false) return(false);
		else 
		{
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

function setOSPSubmit(URL,ms1)
{
	var linkURL = "#ACTION";
    if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
    	alert("請選擇執行動作!!!");
	 	document.DISPLAYREPAIR.ACTIONID.focus(); 
	 	return(false);
    }

  	if (document.DISPLAYREPAIR.ACTIONID.value=="006" || document.DISPLAYREPAIR.ACTIONID.value=="012")  //TRANSFER表示為確認移站轉至OSP動作
  	{
    	flag=confirm(ms1);      
        if (flag==false) return(false);
		else 
		{
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
function subWinPackLabelInfo(oeOrderNo,custNo,custName,custLabelTmp,runCardNo)
{ //alert();
	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/subwindow/TSMfgPackCustLabelInfo.jsp?MONO="+oeOrderNo+"&CUSTNO="+custNo+"&CUSTNAME="+custName+"&CUSTLABELTMP="+custLabelTmp+"&RUNCARDNO="+runCardNo,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes");  
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
//String alternateRouting=request.getParameter("ALTERNATEROUTING"); 
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
String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="0",qtyInQueue="",standardOpDesc="";
String prevOpSeqID = "0",nextOpSeqID = "0"; // 基本頁面將上下一站的OperationSequenceID都取出,作為更新移站時判斷依據
String overValue=""; //超額完工數
String runCardID=request.getParameter("RUNCARDID");
int lineIndex = 1;	
//if (runCardID!=null) lineIndex = Integer.parseInt(runCardID);
if (runCardID==null) runCardID = "0";
else lineIndex = Integer.parseInt(runCardID);
String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));
String inputQty=request.getParameter("INPUTQTY"+Integer.toString(lineIndex));
String wkClass=request.getParameter("WKCLASS"+Integer.toString(lineIndex));
String resourceQty=request.getParameter("RESOURCEQTY"+Integer.toString(lineIndex));	
if (resourceQty==null) resourceQty="0";
String resMachine=request.getParameter("RESMACHINE"+Integer.toString(lineIndex));
String resEmployee=request.getParameter("RESEMPLOYEE"+Integer.toString(lineIndex));
String scrapQty=request.getParameter("SCRAPQTY"+Integer.toString(lineIndex));
String systemDate ="";
String sTime = request.getParameter("STIME");
String [] check=request.getParameterValues("CHKFLAG");
String rtOverValue ="",prevQty ="",runcardQty="";    //流程卡總超出數,前站移站數,流程卡數
if (scrapQty==null || scrapQty.equals("")) scrapQty = "0";
boolean	work_machine = false,work_person = false;//add by Peggy 20120313
String 	work_person_code = "",work_machine_code = ""; //add by Peggy 20120327
String resourceQty_machine=request.getParameter("RESOURCEQTY_MACHINE"+Integer.toString(lineIndex));	 //機器工時,add by Peggy 20120313
if (resourceQty_machine==null) resourceQty_machine="0";
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../jsp/TSCMfgRCCompleteMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<%
try
{
	int  wipCurrOpSeqID = 0; 
    String sqlOp = " select a.WIP_ENTITY_ID, b.OPERATION_SEQ_ID from WIP.WIP_ENTITIES a,APPS.YEW_RUNCARD_ALL b "+
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
}// end of try
catch (Exception e)
{
	out.println("Exception 3:"+e.getMessage());
}		   
// 若Oracle之站別資訊與MFG WIP不一致,表示人工至Oracle Move執行移站,以oracle為主,更新_迄
//out.print("runCardID="+runCardID);
boolean singLastOp = false;
String sqlNextOp = "";
sqlNextOp =" select NEXT_OP_SEQ_NUM from APPS.YEW_RUNCARD_ALL c where WO_NO='"+woNo+"' ";
	 
if (runCardID==null || runCardID.equals("0")) sqlNextOp = sqlNextOp +" and c.RUNCARD_NO ='"+runCardNo+"' ";
else  sqlNextOp = sqlNextOp + " and c.RUNCAD_ID ='"+runCardID+"' " ;
//out.print("sqlNextOp="+sqlNextOp);
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
try
{
	work_machine = false;
	work_person = false;
	work_person_code = "";
	work_machine_code = "";
  	Statement statep=con.createStatement();
	String sqlp = "select b.RESOURCE_TYPE,b.RESOURCE_CODE from WIP_OPERATION_RESOURCES a,BOM_RESOURCES b where a.resource_id=b.resource_id and a.WIP_ENTITY_ID="+entityId+" and a.operation_seq_num="+operSeqNum+"";
    ResultSet rsp=statep.executeQuery(sqlp);
	while (rsp.next())
	{
		if (rsp.getString("RESOURCE_TYPE").equals("2")) //人工工時
		{
			work_person=true;
			work_person_code = rsp.getString("RESOURCE_CODE");
		}
		else if (rsp.getString("RESOURCE_TYPE").equals("1"))
		{
			work_machine=true;
			work_machine_code = rsp.getString("RESOURCE_CODE");
		}			
	}
	rsp.close();
	statep.close(); 	
}
catch(Exception e)
{
}	 
String sqlPrevOpID = "";
if (jobType==null || jobType.equals("1"))
{
	sqlPrevOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID "+ // 取前一站OPSeqID
				  "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
			      "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
				  "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
				  "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
				  "    and a.OPERATION_SEQ_NUM  = c.PREVIOUS_OP_SEQ_NUM "+
				  "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
    if (runCardID==null || runCardID.equals("0")) sqlPrevOpID = sqlPrevOpID +" and c.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlPrevOpID = sqlPrevOpID + " and c.RUNCAD_ID ='"+runCardID+"' " ;		
} 
else if (jobType.equals("2"))	
{
	sqlPrevOpID =" select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
				 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				 " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
				 " and a.WIP_ENTITY_ID = "+entityId+" "+							
				 " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				 " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				 " and d.ORGANIZATION_ID = '"+organizationId+"' ";
	if (runCardID==null || runCardID.equals("0")) sqlPrevOpID = sqlPrevOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlPrevOpID = sqlPrevOpID + " and a.RUNCRD_ID ='"+runCardID+"' " ;						 
}							
//out.println(sqlPrevOpID);	
   
Statement statePrevOpID=con.createStatement();
ResultSet rsPrevOpID=statePrevOpID.executeQuery(sqlPrevOpID);
if (rsPrevOpID.next())
{
	prevOpSeqID = rsPrevOpID.getString("OPERATION_SEQUENCE_ID");	
}
rsPrevOpID.close();
statePrevOpID.close();	 
 
String sqlNextOpID = "";
if (jobType==null || jobType.equals("1"))
{ 
	sqlNextOpID = " select a.OPERATION_DESCRIPTION, a.OPERATION_SEQUENCE_ID,a.OPERATION_SEQ_NUM  "+ // 取前一站OPSeqID
			      "   from BOM_OPERATION_SEQUENCES a, BOM_OPERATIONAL_ROUTINGS b, YEW_RUNCARD_ALL c "+
				  "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID "+
			      "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
				  "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
			      "    and a.OPERATION_SEQ_NUM  = c.NEXT_OP_SEQ_NUM "+
			      "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' " ;
    if (runCardID==null || runCardID.equals("0")) sqlNextOpID = sqlNextOpID +" and c.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlNextOpID = sqlNextOpID + " and c.RUNCAD_ID ='"+runCardID+"' " ;	
} 
else if (jobType.equals("2")) 	
{
	sqlNextOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID ,b.OPERATION_SEQ_NUM"+
			 	  " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				  " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				  " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
				  " and a.WIP_ENTITY_ID = "+entityId+" "+							
				  " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				  " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				  " and d.ORGANIZATION_ID = '"+organizationId+"' ";
	if (runCardID==null || runCardID.equals("0")) sqlNextOpID = sqlNextOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlNextOpID = sqlNextOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ;					 
} 						
Statement stateNextOpID=con.createStatement();
ResultSet rsNextOpID=stateNextOpID.executeQuery(sqlNextOpID);
if (rsNextOpID.next())
{
	nextOpSeqID = rsNextOpID.getString("OPERATION_SEQUENCE_ID");	
	nextOpSeqNum = rsNextOpID.getString("OPERATION_SEQ_NUM");
}
rsNextOpID.close();
stateNextOpID.close();				 

// 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_起
String resourceDesc = "";
boolean ospCheckFlag = false;
String sqlJudgeOSP = "";
try
{
   	if (jobType==null || jobType.equals("1"))
   	{
    	//sqlJudgeOSP =  " select b.DESCRIPTION, b.COST_CODE_TYPE "+
        //               " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
        //               " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
		//			   // "   and b.ORGANIZATION_ID = '"+organizationId+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
		//			   "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
		//			   "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
		//			   // 20091110 Marvie Update : Performance Issue
		//			  // "   and to_char(d.OPERATION_SEQUENCE_ID) = '"+nextOpSeqID+"' "+
		//			   "   and d.OPERATION_SEQUENCE_ID = '"+nextOpSeqID+"' "+
		//			   "   and b.COST_CODE_TYPE = 4 "; // Outside Processing Checked
    	sqlJudgeOSP =" select b.DESCRIPTION, b.COST_CODE_TYPE  from WIP_OPERATION_RESOURCES a, BOM_RESOURCES b"+
                     " Where a.resource_id=b.resource_id  and a.WIP_ENTITY_ID ="+entityId+" "+
                     " and a.operation_seq_num="+nextOpSeqNum+" and b.COST_CODE_TYPE = 4 ";
   	} 
	else if (jobType.equals("2"))
    {
		sqlJudgeOSP =  " select d.DESCRIPTION , d.COST_CODE_TYPE "+
					   " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
					   " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
					   " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
					   " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
					   " and a.WIP_ENTITY_ID = "+entityId+" "+
					   " and a.RUNCARD_NO ='"+runCardNo+"' "+
					   " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
					   " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
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
		   // alert("            下一站為委外加工站\n 此工作站完工後將產生委外請、採購單!!!");
		</script>	  
<%
	}
   	rsJudgeOSP.close();
   	stateJudgeOSP.close();	   
} //end of try
catch (Exception e)
{
	out.println("Exception Runcard:"+e.getMessage());
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
%>
<%
if (woType.equals("3")) // 後段工令需取出領用半成品批號清單,寫入Array
{  //out.println("stdOpDesc="+stdOpDesc+"<BR>");
	if (stdOpDesc.indexOf("目檢")>=0)
	{ 
		String custNo = "";
	    String custName = "";
		String stationNo = "01";
		String custLabelTmp = "";
        Statement stateCust=con.createStatement();
     //   ResultSet rsCust=stateCust.executeQuery("select a.CUSTOMER_NUMBER, a.CUSTOMER_NAME, b.LABEL_TEMPFILE from AR_CUSTOMERS_V a, ORADDMAN.TSCUST_LABEL_SPECS b, OE_ORDER_HEADERS_ALL c "+ //20150707 liling update AR_CUSTOMERS
        ResultSet rsCust=stateCust.executeQuery("select a.CUSTOMER_NUMBER, a.CUSTOMER_NAME, b.LABEL_TEMPFILE from AR_CUSTOMERS a, ORADDMAN.TSCUST_LABEL_SPECS b, OE_ORDER_HEADERS_ALL c "+		
		                                         " where a.CUSTOMER_NUMBER=b.CUST_NUMBER and b.CUSTOMER_ID=c.SOLD_TO_ORG_ID "+
												 "   and c.ORDER_NUMBER='"+oeOrderNo+"' and STATNO='"+stationNo+"' and TYPE_ID='01' "); 
		//out.println("sql="+);										 
        if (rsCust.next())
	    { 
	    	custNo = rsCust.getString(1);
		   	custName = rsCust.getString(2);	
		   	custLabelTmp = rsCust.getString(3);
		   //	out.println("custNo="+custNo);  out.println("custName="+custName); out.println("custLabelTmp="+custLabelTmp);	 
	    }
	    rsCust.close();
	    stateCust.close();
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
	<td width="5%" nowrap>
	    <font color="#000066">
	     目檢站客戶標籤資訊<input type='button' name='SUBLOTCH' value='...' onClick='subWinInspLabelInfo("<%=oeOrderNo%>","<%=custNo%>","<%=custName%>","<%=custLabelTmp%>","<%=runCardNo%>")'>             
	    </font>
	</td>
    <td colspan="3">	  
	  <!--%<div align="center"><img src="/oradds/jsp/subwindow/TSMfgCustLabelBarCodeDraw.jsp?DATA=<%=runCardNo%>&CODE=<%="3"%>&WIDTH=0.5&HEIGHT=25" align="left"/></div>%-->
	</td>
	</tr>
</table>
<%
	} // (stdOpDesc.indexOf("目檢")>=0) 
	else if (stdOpDesc.indexOf("包裝")>=0)
	{
		String custNo = "";
	    String custName = "";
		String stationNo = "02";
		String custLabelTmp = "";
        Statement stateCust=con.createStatement();
		// 20110902 liling update AR_CUSTOMERS_V ->AR_CUSTOMERS for R12 issue
        //ResultSet rsCust=stateCust.executeQuery("select a.CUSTOMER_NUMBER, a.CUSTOMER_NAME, b.LABEL_TEMPFILE from AR_CUSTOMERS_V a, ORADDMAN.TSCUST_LABEL_SPECS b, OE_ORDER_HEADERS_ALL c "+
        ResultSet rsCust=stateCust.executeQuery("select a.CUSTOMER_NUMBER, a.CUSTOMER_NAME, b.LABEL_TEMPFILE from AR_CUSTOMERS a, ORADDMAN.TSCUST_LABEL_SPECS b, OE_ORDER_HEADERS_ALL c "+
		                                        " where a.CUSTOMER_NUMBER=b.CUST_NUMBER and b.CUSTOMER_ID=c.SOLD_TO_ORG_ID "+
										        "   and c.ORDER_NUMBER='"+oeOrderNo+"' and STATNO='"+stationNo+"' and TYPE_ID='01' "); 
		//out.println("sql="+);										 
        if (rsCust.next())
	    { 
	    	custNo = rsCust.getString(1);
		    custName = rsCust.getString(2);	
		    custLabelTmp = rsCust.getString(3);
		    //out.println("custNo="+custNo);  out.println("custName="+custName); out.println("custLabelTmp="+custLabelTmp);	 
	    }
	    rsCust.close();
	    stateCust.close();	 
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
	<tr bgcolor="#CCCC99"> 
		<td width="5%" nowrap>
	    	<font color="#000066">
	           包裝站客戶標籤資訊<input type='button' name='SUBLOTCH' value='...' onClick='subWinPackLabelInfo("<%=oeOrderNo%>","<%=custNo%>","<%=custName%>","<%=custLabelTmp%>","<%=runCardNo%>")'>             
	           </font>
	    </td>
        <td colspan="3">	  
	    <!--% <div align="center"><img src="/oradds/jsp/subwindow/TSMfgCustLabelBarCodeDraw.jsp?DATA=<%=runCardNo%>&CODE=<%="3"%>&WIDTH=0.5&HEIGHT=25" align="left"/></div>%-->
	    </td>
	</tr>
</table>
<%
	} // End of else if ()
} // end of if (woType.equals("3"))
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      流程卡明細 :
<%
out.println("entityId("+entityId+")");
try
{   
	String oneDArray[]= {"流程卡識別碼","流程卡號","前一站","目前站別","移站數量","下一站","流程卡狀態","展開日期"};  // 先將內容明細的標頭,給一維陣列		 	     			  
   	arrMFGRCCompleteBean.setArrayString(oneDArray);
	// 先取 該詢問單筆數
	int rowLength = 0;
	Statement stateCNT=con.createStatement();
    String sqlCNT = "select count(RUNCAD_ID) from YEW_RUNCARD_ALL where WO_NO='"+woNo+"' and STATUSID = '"+frStatID+"' "+
	                "   and OPERATION_SEQ_NUM="+operSeqNum+" ";	
    ResultSet rsCNT=stateCNT.executeQuery(sqlCNT);	
	if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	rsCNT.close();
	stateCNT.close();
	  
	//choice = new String[rowLength+1][2];  // 給定暫存二維陣列的列數
	String b[][]=new String[rowLength+1][12]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	String r[][]=new String[rowLength+1][21]; // 宣告一二維陣列,分別是(=列)X(資料欄數+1= 行)
	  
	//array2DEstimateFactoryBean.setArray2DString(oneDArray); // 先把標頭置入二維第一列
	//b[0][0]="Line no.";b[0][1]="Inventory Item";b[0][2]="Quantity";b[0][3]="UOM";b[0][4]="Request Date";b[0][5]="Remark";b[0][6]="Product Manufactory";
	out.println("<TABLE cellSpacing='0' bordercolordark='#B1A289' cellPadding='0' width='100%' align='center' bordercolorlight='#CCCC99'  border='1'>");
	out.print("<TR bgcolor='#CCCC99'>");
	out.print("<td nowrap><font color='#FFFFFF'>");
%>
	<input name="button" type=button onClick="this.value=check(this.form.CHKFLAG)" value='選擇全部'>
<%
	out.print("</font></td>");
	out.println("<td><font color='#990000'>識別碼</font></td>");
	out.println("<td><font color='#990000'>流程卡號</font></td>");
	out.println("<td><font color='#990000'>流程卡數量</font></td>");
	out.println("<td>&nbsp;</td>");
	out.println("<td><font color='#990000'>良品數</font><img src='../image/point.gif'></td>");
	out.println("<td><font color='#990000'>報廢數</font></td>"); // 2007/01/26 加入管理員可手動輸入報廢數
	out.println("<td><font color='#990000'>處理數</font></td>");
	out.println("<td><font color='#990000'>班別</font></td>");
	if (work_machine) //add by Peggy 20120313
	{
		out.println("<td><font color='#990000'>機器工時</font><img src='../image/point.gif'></td>");
	}		
	if (work_person) //add by Peggy 20120313
	{
		if (work_machine || work_person_code.length() >3)
		{
			out.println("<td><font color='#990000'>人工工時</font><img src='../image/point.gif'><input type='hidden' name='worktimes_p' value='人工'></td>");
		}
		else
		{
			out.println("<td><font color='#990000'>機器工時</font><img src='../image/point.gif'><input type='hidden' name='worktimes_p' value='機器'></td>");
		}
	}
	out.println("<td><font color='#990000'>日期</font></td>");
	out.println("<td><font color='#990000'>機號</font></td>");
	out.println("<td><font color='#990000'>前一站</font></td>");	   
	out.println("<td nowrap><font color='#990000'>目前站別</font></td>");
	if (ospCheckFlag) out.println("<td><font color='#990000'><em>下一站(委外加工站)</em></font></td>");
	else out.println("<td><font color='#990000'>下一站</font></td>");
   	out.print("<td><font color='#990000'>狀態</font></td></TR>");    
	int k=0;
	//out.println("entityId="+entityId);
	String sqlEst = "";
	String fromEst = "";
	String whereEst = "";
	String orderEst = "";
	String defToMoveQty = "0"; // 2007/01/10  
	int prevOpDescFlag = prevOpDesc.indexOf("切割"); // 2007/04/13 判斷前站是否為切割站,是則可允許
	String keydownlink= "";

    //抓取系統日期  20090505 liling for 人工打入異動日期,預設系統日
    Statement statesd=con.createStatement();
	ResultSet sd=statesd.executeQuery("select TO_CHAR(sysdate,'YYYYMMDD') as SYSTEMDATE,  substr(to_char(sysdate,'yyyymmddhh24miss'),9,6) STIME  from dual" );
	if (sd.next())
    {
		systemDate=sd.getString("SYSTEMDATE");	
        sTime=sd.getString("STIME");
	}
	sd.close();
    statesd.close(); 
 
	// 20091110 Marvie Add : Performance Issue
	String overValue1 = "0";
    String sqlOver=" SELECT (overcompletion_tolerance_value / 100) "+
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
	{ 	
		sqlEst = " select YRA.PRIMARY_ITEM_ID, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,  "+
        		 "       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM, "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
				 "       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
				 "       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID, "+
				 "       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP "+
				 "       ,YRA.RES_MACHINE_WKHOUR_OP,YRA.PREVIOUS_OP_SEQ_ID"; //機器工時,add by Peggy 20120315
		fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  ";
		whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+ 
				   "    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID  "+					
				   "    and WIPO.WIP_ENTITY_ID= "+entityId+" and STATUSID = '"+frStatID+"' "+
				   "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
		orderEst = "  order by YRA.RUNCAD_ID";	
		if (jobType==null || jobType.equals("1")) // 標準(discrete Job)
		{	
			whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
		} 
		else 
		{ //  非標準工單(rework Job)
		    whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
		}				
		sqlEst = sqlEst + fromEst + whereEst + orderEst;	
	}
	else 
	{   
		sqlEst = " select YRA.PRIMARY_ITEM_ID, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM,WIPO.OPERATION_SEQUENCE_ID,  "+
        		 "       WIPO.PREVIOUS_OPERATION_SEQ_NUM,WIPO.NEXT_OPERATION_SEQ_NUM, "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
				 "       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
				 "       BOS.OPERATION_DESCRIPTION,YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID, "+
				 "       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP "+
				 "       ,YRA.RES_MACHINE_WKHOUR_OP,YRA.PREVIOUS_OP_SEQ_ID"; //機器工時,add by Peggy 20120315
		fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA,BOM_OPERATION_SEQUENCES BOS  ";
		whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+ 
			       "    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+					
				   "    and WIPO.WIP_ENTITY_ID= "+entityId+" "+					
				   "    and STATUSID = '"+frStatID+"' "+
				   "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
		orderEst = "  order by YRA.RUNCAD_ID";		
			 		 
		if (UserRoles.indexOf("YEW_WIP_PACKING")<0)  // 若不是包裝站人員,則需要再區分各製造部 
		{   
			whereEst =  whereEst + " and YRA.DEPT_NO = '"+userMfgDeptNo+"' ";  }
			if (jobType==null || jobType.equals("1")) // 標準工單/(discrete job)
		    {	
				whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
			} 
			else 
			{ // 非標準工單(rework) Job)
			    whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
			}
			sqlEst = sqlEst + fromEst + whereEst + orderEst;
		}
       	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery(sqlEst);	   
	   	while (rs.next())
	   	{
			//抓取該流程卡,totoal可超出數
          	runcardQty=rs.getString("RUNCARD_QTY");
		  	if (woType.equals("3") && nextOpSeqId==0)   
		  	{  
				defToMoveQty = runcardQty; 
			}
		  	else 
			{ 
				defToMoveQty = rs.getString("QTY_IN_TOMOVE");  
			} 
          	overValue = rs.getString("OVER_VALUE");
		  	//抓取該流程卡,已報之超出數
          	String sqlRtOver="SELECT SUM(OVERCOMPLETE_QTY) FROM YEW_RUNCARD_TRANSACTIONS where STEP_TYPE=1 AND RUNCARD_NO= '"+rs.getString("RUNCARD_NO")+"' ";
	     	// out.print("<br>sqlRtOver="+sqlRtOver);
		  	Statement stateRtOver=con.createStatement();	   
	      	ResultSet rsRtOver=stateRtOver.executeQuery(sqlRtOver); 
	      	if (rsRtOver.next())
	      	{
	        	rtOverValue = rsRtOver.getString(1);
	       	}	
		  	if (rtOverValue==null || rtOverValue.equals("")) rtOverValue="0";
		  	rsRtOver.close();
		  	stateRtOver.close();	
        
           	//抓取前站移站數,判斷是否超收 
            String sqlpre=" select TRANSACTION_QUANTITY from yew_runcard_transactions "+
					   	  "  where step_type=1 and FM_OPERATION_SEQ_NUM  = "+rs.getString("PREVIOUS_OPERATION_SEQ_NUM")+" "+
						  "    and runcard_no = '"+rs.getString("RUNCARD_NO")+"' ";
			//out.print("<br>sqlpre="+sqlpre);
			Statement statepre=con.createStatement();
            ResultSet rspre=statepre.executeQuery(sqlpre);
			if (rspre.next())
			{  
				prevQty = rspre.getString(1); 
			} //前次移站數量
		    rspre.close();
			statepre.close();
           	// out.print("<br>prevQty="+prevQty);

	    	out.print("<TR bgcolor='#CCCC99'>");		
			out.println("<TD width='1%'><a name='#"+rs.getString("RUNCAD_ID")+"'><div align='center'>");
		
			out.print("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("RUNCAD_ID")+"' ");
			if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
			{ 
		  		for (int j=0;j<check.length;j++) 
				{ 
					if (check[j]==rs.getString("RUNCAD_ID") || check[j].equals(rs.getString("RUNCAD_ID"))) out.println("checked");  
				}
		  		if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); // 給定生產日期即設定欲結轉
			} else if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
			if (rowLength==1) out.println("checked >"); 	else out.println(" >");		
			out.println("</div></a></TD>");
			out.println("<TD nowrap>");
			out.print(rs.getString("RUNCAD_ID")+"</TD>");		
			out.println("<TD nowrap>");
			out.print(rs.getString("RUNCARD_NO")+"</TD>");
			out.println("<TD nowrap>");
			out.print(rs.getString("RUNCARD_QTY")+"</TD>");		
			out.print("<TD nowrap>"); // 按鈕 Set
			out.println("<INPUT TYPE='button' value='Set' onClick='setSubmitQtyToMove("+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")'>");                                                         
			out.println("</TD>");     // 按鈕 Set		
			out.print("<TD nowrap>"); // 移站數量  // 2007/01/10 修改後段預設帶入移站數=流程卡數於最後一站		
			keydownlink = "setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
			if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
			{ 
				//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+queueQty+"' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
				out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+queueQty+"' size=5 onKeyDown="+keydownlink+">");
			}
			else 
			{ 
		    	if (rs.getString("QTY_IN_TOMOVE")==null)
				{
			    	//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>");  
					out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">");
				}
			  	else
				{
					//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+defToMoveQty+"' size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+defToMoveQty+"' size=5 onKeyDown="+keydownlink+">");
				}
			}				  
			out.println("</TD>");  // 移站數量(良品數)
		
		  	out.print("<TD nowrap>"); // 報廢數量
			keydownlink = "setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
		  	if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		  	{ 
				//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+scrapQty+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
				out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+scrapQty+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
			}
		  	else 
			{ 
		    	if (rs.getString("QTY_IN_SCRAP")==null || rs.getString("QTY_IN_SCRAP").equals("0"))
				{
			    	//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
				}
			    else 
				{ 
					if (rs.getFloat("QTY_IN_TOMOVE")+rs.getFloat("QTY_IN_SCRAP")!=rs.getFloat("QTY_IN_QUEUE"))
					{ // 若 良品數+報廢數 != 處理數, 則畫面顯示之報廢數 = 0
						//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>");
						out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='0' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
					} 
					else 
					{
						//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
						out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
					}	
				}  
			}
		  	out.println("</TD>");
				
			out.print("<TD nowrap>"); // 投入數量(處理數)	
			keydownlink = "setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
			if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
			{ 
				//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+inputQty+"' size=5 class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
				out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+inputQty+"' size=5 class='koko' onKeyDown="+keydownlink+">");
			}
			else 
			{ 
				// 2007/04/04 第一站之後,原處理數(投入數)預設為前一站之良品數(移站數)
			  	if (rs.getString("QTY_IN_TOMOVE")==null || rs.getString("QTY_IN_TOMOVE").equals("0"))
				{
			    	//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 class='koko' onKeyDown="+keydownlink+">");
				}
			   	else 
				{
					//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 class='koko' onKeyDown="+keydownlink+">");
				}
			}				  
			out.println("</TD>");  // 投入數量
		
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
            catch (Exception e) 
			{ 
				out.println("Exception2:"+e.getMessage()); 
			}
			out.println("</TD>");
			//班別,自動依處理時間判段所屬班別_迄
		
			//製程工時增加機器工時,modify by Peggy 20120313
			if (work_machine)
			{
				out.println("<TD nowrap>");
				keydownlink = "setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
				if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
				{ 
					out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty_machine+"' size=5 onKeyDown="+keydownlink+">");
				}
				else 
				{ 
					if (rs.getString("RES_MACHINE_WKHOUR_OP")==null || !rs.getString("PREVIOUS_OP_SEQ_ID").equals(prevOpSeqID))
					{
						out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">");
					}
					else 
					{
						out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_WKHOUR_OP")+"' size=5 onKeyDown="+keydownlink+">");
					}
				}				   
				out.println("</TD>");	
			}
			
			//製程工時改為人工工時,modify by Peggy 20120313
			if (work_person)
			{
				out.println("<TD nowrap>");
				keydownlink = "setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
				if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
				{ 
					//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty+"' size=5 onKeyDown="+keydownlink+">");
				}
				else 
				{ 
					if (rs.getString("RES_WKHOUR_OP")==null || !rs.getString("PREVIOUS_OP_SEQ_ID").equals(prevOpSeqID))
					{
						//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
						out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">");
					}
					else 
					{
						//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_WKHOUR_OP")+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
						out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_WKHOUR_OP")+"' size=5 onKeyDown="+keydownlink+">");
					}
				}				   
				out.println("</TD>");	
			} 
		
			//異動日期_起
			out.println("<TD nowrap>");
			keydownlink ="setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
		    if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		    { 
				//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resEmployee+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
				out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resEmployee+"' size=7 onKeyDown="+keydownlink+">");
			}
		    else 
			{ 
		    	if (rs.getString("RES_EMPLOYEE_OP")==null)
				{
			    	//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+systemDate+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>");  
					out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+systemDate+"' size=7 onKeyDown="+keydownlink+">");					
				}
			    else
				{
					//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_EMPLOYEE_OP")+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_EMPLOYEE_OP")+"' size=7 onKeyDown="+keydownlink+">");
				}
			}
			out.println("</TD>");
			//異動日期_迄

			// 機台編號_起
		    out.println("<TD nowrap>");
			keydownlink = "setTabNext('7',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
		    if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		    { 
				//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resMachine+"' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>");
				out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resMachine+"' size=5 onKeyDown="+keydownlink+">");
			}
		    else 
			{
		    	if (rs.getString("RES_MACHINE_OP")==null)
				{
			    	//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>");  
					out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">");
				}
			    else 
				{
					//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+rtOverValue+'"'+","+'"'+prevQty+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+nextOpSeqId+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+prevOpDescFlag+'"'+")>"); 
					out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown="+keydownlink+">");
				}
			}
			out.println("</TD>");
			
			// 機台編號_迄
			out.println("<TD nowrap>"+prevOpDesc+"</TD><TD nowrap><font color='#0000FF'>"+currOpDesc+"</font></TD>");
			if (ospCheckFlag)
			{ 
				out.print("<TD nowrap><font color='#990000'><em>"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"("+resourceDesc+")"+"</em></font></TD>");
			}
			else
			{
				out.print("<TD nowrap>"+nextOpDesc+"</TD>");
			}
			out.print("<TD nowrap>"+rs.getString("STATUS")+"</TD>");
			//out.println("<TD nowrap>"+rs.getString("CREATION_DATE")+"</TD>");
			out.println("</TR>");
		
			// ############################  WIP Resource Operation API資料取得 _迄 ##############################
        	// 20091110 Marvie Add : Performance Issue
        	if (k==0)
			{
           		try
           		{
              		String sqlOPRes = "";
              		if (jobType==null || jobType.equals("1"))
              		{
                    	//sqlOPRes =" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
				        //      	  "        a.SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
						//	      "        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
				        //         "        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
                        //          " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                        //          " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					    //          // "   and b.ORGANIZATION_ID = '"+organizationId+"' "+ // Update 2006/11/08 因為資源分Organization,但其他表不分
					    //          "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					    //          "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					    //          "   and d.OPERATION_SEQUENCE_ID = '"+rs.getString("OPERATION_SEQUENCE_ID")+"' ";
						sqlOPRes =	" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
								"        a.SCHEDULED_FLAG SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
								"        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
								"        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
								"        ,b.RESOURCE_TYPE"+ //add by Peggy 20120313
								" from WIP_OPERATION_RESOURCES a, BOM_RESOURCES b"+
								" Where a.resource_id=b.resource_id"+
								" and a.WIP_ENTITY_ID = "+entityId+" "+
								" and a.operation_seq_num="+operSeqNum+"";
              		} 
					else if (jobType.equals("2"))
                    {
		            	sqlOPRes =  " select c.RESOURCE_SEQ_NUM, c.RESOURCE_ID, c.USAGE_RATE_OR_AMOUNT, c.BASIS_TYPE, "+
				                    "        c.SCHEDULE_FLAG, c.AUTOCHARGE_TYPE, c.STANDARD_RATE_FLAG, c.SCHEDULE_SEQ_NUM, "+
							        "        c.PRINCIPLE_FLAG, c.ASSIGNED_UNITS, "+
									"        d.UNIT_OF_MEASURE, d.AUTOCHARGE_TYPE "+
									"        ,d.RESOURCE_TYPE"+ //add by Peggy 20120313
			               			" from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  			        " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							        " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
							        " and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							        " and a.WIP_ENTITY_ID = "+entityId+" "+
							        " and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
							        " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							        " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
							        " and d.ORGANIZATION_ID = '"+organizationId+"' "; 
			        	if (runCardID==null || runCardID.equals("0")) sqlOPRes = sqlOPRes +" and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' ";
                        else  sqlOPRes = sqlOPRes + " and a.RUNCAD_ID ='"+rs.getString("RUNCAD_ID")+"' " ;					
		            }		
              		Statement stateOPRes=con.createStatement();
              		ResultSet rsOPRes=stateOPRes.executeQuery(sqlOPRes);
				int icnt=0;
              	//if (rsOPRes.next())
				while (rsOPRes.next())
				{ 	
					if (icnt==0)
					{
						r[k][0]="";
						r[k][1]="";
						r[k][10]="";
						r[k][18]="";
						r[k][19]="";
						r[k][20]="";
						icnt++;
					}
					//modify by Peggy 20120313
					if (rsOPRes.getString("RESOURCE_TYPE").equals("2")) //人工工時
					{                 
						r[k][0]=rsOPRes.getString("RESOURCE_SEQ_NUM");
						r[k][1]=rsOPRes.getString("RESOURCE_ID");
						r[k][10]=rsOPRes.getString("UNIT_OF_MEASURE");
					}
					else if (rsOPRes.getString("RESOURCE_TYPE").equals("1")) //機器工時
					{
						r[k][18]=rsOPRes.getString("RESOURCE_SEQ_NUM");
						r[k][19]=rsOPRes.getString("RESOURCE_ID");
						r[k][20]=rsOPRes.getString("UNIT_OF_MEASURE");
					}
					r[k][3]=rsOPRes.getString("USAGE_RATE_OR_AMOUNT");
					r[k][4]=rsOPRes.getString("BASIS_TYPE");
					r[k][5]=rsOPRes.getString("SCHEDULE_FLAG");
					r[k][6]=rsOPRes.getString("AUTOCHARGE_TYPE");
					r[k][7]=rsOPRes.getString("STANDARD_RATE_FLAG");
					r[k][8]=rsOPRes.getString("SCHEDULE_SEQ_NUM");
					r[k][9]=rsOPRes.getString("PRINCIPLE_FLAG");
					r[k][11]=rsOPRes.getString("AUTOCHARGE_TYPE");
					r[k][12]=rs.getString("RUNCAD_ID");	
					r[k][13]=rs.getString("OPERATION_SEQ_NUM");
					r[k][14]=rsOPRes.getString("ASSIGNED_UNITS");   
					r[k][15]=rs.getString("OPERATION_SEQUENCE_ID");
					r[k][16]=rs.getString("PRIMARY_ITEM_ID");
					r[k][17]=rs.getString("RUNCARD_NO");  
					arrMFGCompResBean.setArray2DString(r);
				}
				rsOPRes.close();
				stateOPRes.close();	   
			} //end of try
			catch (Exception e)
			{
				out.println("Exception Resource:"+e.getMessage());
			}	   
		} 
		else 
		{
			r[k][0]=r[0][0];
			r[k][1]=r[0][1];
			r[k][3]=r[0][3];
			r[k][4]=r[0][4];
			r[k][5]=r[0][5];
			r[k][6]=r[0][6];
			r[k][7]=r[0][7];
			r[k][8]=r[0][8];
			r[k][9]=r[0][9];
			r[k][10]=r[0][10];
			r[k][11]=r[0][11];
			r[k][12]=rs.getString("RUNCAD_ID");	  //20091110 RUNCARD_ID / NO 每一批不同,故不能與第一批一樣
			r[k][13]=r[0][13];
			r[k][14]=r[0][14];   
			r[k][15]=r[0][15];
			r[k][16]=r[0][16];
			r[k][17]=rs.getString("RUNCARD_NO");
			r[k][18]=r[0][18];
			r[k][19]=r[0][19];   
			r[k][20]=r[0][20];
			arrMFGCompResBean.setArray2DString(r);
		}  // end if(k==0)
	
		// ############################  WIP Resource Operation API資料取得 _迄 ############################## 		
		b[k][0]=rs.getString("RUNCAD_ID");
		b[k][1]=rs.getString("RUNCARD_NO");
		b[k][2]=rs.getString("QTY_IN_TOMOVE");
		b[k][3]=rs.getString("PREVIOUS_OPERATION_SEQ_NUM");
		b[k][4]=rs.getString("OPERATION_SEQ_NUM");
		b[k][5]=rs.getString("NEXT_OPERATION_SEQ_NUM");
		b[k][6]=rs.getString("STATUS");		 
		b[k][7]=rs.getString("CREATION_DATE");
		b[k][8]=rs.getString("ORGANIZATION_ID");
		b[k][9]=rs.getString("OPERATION_SEQUENCE_ID");
		b[k][10]=rs.getString("OPERATION_DESCRIPTION");
		b[k][11]=rs.getString("QTY_IN_SCRAP");
		arrMFGRCCompleteBean.setArray2DString(b);
		k++;
	}    	   	   	 
	out.println("</TABLE>");
	statement.close();
	rs.close();  
	         
	if (runCardID !=null && scrapQty!=null && !scrapQty.equals(""))
	{
		String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_SCRAP=?, QTY_AC_SCRAP=? ,LAST_UPDATED_BY = ?, LAST_UPDATE_DATE=to_char(SYSDATE,'yyyymmddhh24miss')"+
					 " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
		//out.println("sql="+sql);
		PreparedStatement pstmt=con.prepareStatement(sql);  
		pstmt.setString(1,scrapQty);     // 本次報廢數量更新
		pstmt.setString(2,scrapQty);     // 本次User報廢數量更新		  
		pstmt.setInt(3,Integer.parseInt(userMfgUserID));     //add by peggy 20120315  
		pstmt.executeUpdate(); 
		pstmt.close();
	  
	} // End of if 報廢數寫入
	
	//out.println(array2DEstimateFactoryBean.getArray2DString()); // 把內容印出來
	if (runCardID !=null && queueQty!=null && !queueQty.equals(""))
	{
		String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_TOMOVE=?, PREVIOUS_OP_SEQ_ID=?, NEXT_OP_SEQ_ID=?, QTY_IN_INPUT=? ,RES_EMPLOYEE_OP=? ,RES_WKHOUR_OP=?,RES_MACHINE_WKHOUR_OP=? ,RES_WKCLASS_OP =?,LAST_UPDATED_BY = ?, LAST_UPDATE_DATE=to_char(SYSDATE,'yyyymmddhh24miss')"+
				   " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
		//out.println("sql="+sql);
		PreparedStatement pstmt=con.prepareStatement(sql);  
		pstmt.setString(1,queueQty);     // 本次移站數量更新
		pstmt.setInt(2,Integer.parseInt(prevOpSeqID));  // 本次前一站ID更新
		pstmt.setInt(3,Integer.parseInt(nextOpSeqID));  // 本次下一站ID更新
		pstmt.setFloat(4,Float.parseFloat(queueQty)+Float.parseFloat(scrapQty));     // 本次處理數量更新
		pstmt.setString(5,resEmployee);     // 異動日期更新
		pstmt.setString(6,resourceQty);  //人工工時,add by Peggy 20120313
		pstmt.setString(7,resourceQty_machine);  //機器工時,add by Peggy 20120313
		pstmt.setString(8,wkClass);  //班別,add by Peggy 20120313
		pstmt.setInt(9,Integer.parseInt(userMfgUserID));     //add by peggy 20120315  
		pstmt.executeUpdate(); 
		pstmt.close();
		  
		// %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _起
		for (int rr=0;rr<r.length;rr++)
		{
			if (runCardID==r[rr][12] || runCardID.equals(r[rr][12]) )
			{ 
				String sqlResRowID =" select a.ROWID, b.ORGANIZATION_CODE from WIP_OPERATION_RESOURCES a, MTL_PARAMETERS b "+
				                       " where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.WIP_ENTITY_ID="+entityId+" "+
									   "   and a.OPERATION_SEQ_NUM='"+r[rr][13]+"' and (a.RESOURCE_SEQ_NUM='"+r[rr][0]+"' or  a.RESOURCE_SEQ_NUM='"+r[rr][18]+"')"; //modify by Peggy 20120313
	            Statement stateResRowID=con.createStatement();
                ResultSet rsResRowID=stateResRowID.executeQuery(sqlResRowID);
				if (rsResRowID.next())
				{
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
				    stateExist.close();
						
					// -- 取此Organization對應的ACCT_PERIOD_ID
					if (intResExist || rCardResExt || resResExist) 
					{  
					} // 若已經回報過工時資源檔,則不再寫一次 } //20090505 update transacion_date不抓 sysdate
					else 
					{
						String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, QTY_IN_INPUT, CREATED_BY, LAST_UPDATED_BY, "+
						                 " OPERATION_SEQ_NUM,  AUTOCHARGE_TYPE, WKCLASS_CODE, WKCLASS_NAME, WORK_EMPLOYEE, WORK_EMPID, WORK_MACHINE, WORK_MACHNO, WIP_ENTITY_ID, QTY_AC_SCRAP , TRANSACTION_DATE  ";
						if (work_person) resTxnSql += ", RESOURCE_SEQ_NUM, RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM";
						if (work_machine) resTxnSql += ",MACHINE_RESOURCE_SEQ_NUM,MACHINE_RESOURCE_ID,MACHINE_TRANSACTION_QUANTITY,MACHINE_TRANSACTION_UOM ";//add by Peggy 20120313
						resTxnSql += " )"+
								     " values( '"+woNo+"', '"+r[rr][17]+"', "+inputQty+", '"+userMfgUserID+"', '"+userMfgUserID+"', "+															              
								     "         "+Integer.parseInt(r[rr][13])+", 2 , '"+wkClass+"', 'N/A', '"+resEmployee+"', '0','"+resMachine+"','N/A', '"+entityId+"', '"+scrapQty+"','"+resEmployee+"'||'"+sTime+"' ";		                              
						if (work_person)  resTxnSql += ", "+(r[rr][0].equals("")?null:r[rr][0])+", "+(r[rr][1].equals("")?0:Integer.parseInt(r[rr][1]))+", "+resourceQty+", '"+r[rr][10]+"'";  //add by Peggy 20120313
						if (work_machine) resTxnSql += ", "+(r[rr][18].equals("")?null:r[rr][18])+", "+(r[rr][19].equals("")?0:Integer.parseInt(r[rr][19]))+", "+resourceQty_machine+", '"+r[rr][20]  +"'"; //add by Peggy 20120313
						resTxnSql += ")";
						PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                        
		                pstmtResTxn.executeUpdate(); 
                     	pstmtResTxn.close(); 
						
						if (!resourceQty.equals("") && Float.parseFloat(resourceQty)>0) // if (回報工時>0才寫Interface ) 2007/02/12
						{ 
					    	String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                  " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, ORGANIZATION_CODE, WIP_ENTITY_ID, "+
										  " ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
										  " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
										  " WIP_ENTITY_NAME, PRIMARY_ITEM_ID, ATTRIBUTE2 ) "+
										  " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
									      "         1, 1, 1, '"+organizationId+"', '"+rsResRowID.getString("ORGANIZATION_CODE")+"', '"+entityId+"', "+
										  "         1, to_date('"+resEmployee+"'||'"+sTime+"','yyyymmddhh24miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
										  "         "+Integer.parseInt(r[rr][1])+", "+resourceQty+", '"+r[rr][10]+"', 2 , "+
										  "         '"+woNo+"', "+r[rr][16]+", '"+r[rr][17]+"' ) ";		                              
						    PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                    pstmtRes.executeUpdate(); 
                            pstmtRes.close();
						} 
						if (!resourceQty_machine.equals("") && Float.parseFloat(resourceQty_machine)>0) //add by Peggy 20120313
						{
					    	String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                  " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, ORGANIZATION_CODE, WIP_ENTITY_ID, "+
										  " ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
										  " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, "+
										  " WIP_ENTITY_NAME, PRIMARY_ITEM_ID, ATTRIBUTE2 ) "+
										  " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
										  "         1, 1, 1, '"+organizationId+"', '"+rsResRowID.getString("ORGANIZATION_CODE")+"', '"+entityId+"', "+
										  "         1, to_date('"+resEmployee+"'||'"+sTime+"','yyyymmddhh24miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][18])+", "+
										  "         "+Integer.parseInt(r[rr][19])+", "+resourceQty_machine+", '"+r[rr][20]+"', 2 , "+
										  "         '"+woNo+"', "+r[rr][16]+", '"+r[rr][17]+"' ) ";		                              
						  	PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                    pstmtRes.executeUpdate(); 
                            pstmtRes.close();
						}
					} 
				}	  
				rsResRowID.close();
				stateResRowID.close();	  
			}
		}		  
    }  
} //end of try
catch (Exception e)
{
	out.println("Exception3:"+e.getMessage());
}
String a[][]=arrMFGRCCompleteBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
if (a!=null) 
{		  
	//out.println(a[0][0]+""+a[0][1]+""+a[0][2]+""+a[0][3]+""+a[0][4]+"<BR>"); 
}	//enf of a!=null if		
%> 
 </font>      
  </tr>       
</table>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->
<BR>
<table align="left"><tr><td colspan="3">
   <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
   <a name='#ACTION'>
<%
try
{ 
	String sqlAction = null;
	if (!singLastOp) //  不為最後一站,則可執行Transfer
	{ 
		if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		{
			sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID = '023' "; 	
		}
		else 
		{ //不為最後一站,則可執行Transfer
	    	sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID = '006' "; 	   
		}
	}
	else 
	{  //  本站為最後一站,則可執行Complete
		if (ospCheckFlag)  //判斷下一站委外加工站,則選擇動作為OSPROCESS
		{
			sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID = '023' "; 	
		}
		else 
		{ //為最後一站則可執行Transfer
	        sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' "; 	   
		}	           
	}
    Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlAction);
	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRunCardComplete.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+"&EXPAND="+expand+'"'+")'>");				  				  
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
	} //end of while
	out.println("</select>"); 
	   
	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	rs.next();
	if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	{
    	if (!ospCheckFlag) // 若下一站不為委外加工站,則呼叫正常移站處理頁面_起
		{
			out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgRCCompleteMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行流程卡入庫作業?"+'"'+")'>"); 
		} 
		else 
		{
		    out.println("<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("+'"'+"../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+'"'+","+'"'+"確認執行移至委外加工站?"+'"'+")'>"); 
		} // 若下一站不為委外加工站,則呼叫正常移站處理頁面_迄
		out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
		 
	    if (UserRoles.indexOf("admin")>=0 ) // 若是管理員模式,可設定手動給定報廢數量
	    { 
			out.println("<INPUT TYPE='checkBox' NAME='ADMINMODEOPTION' VALUE='YES'>");%>管理員模式<%
		}
	} 
    rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
</a></td></tr></table>
<!-- 表單參數 --> 
<INPUT type="hidden" SIZE=5 name="RUNCARD_NO" value="<%=runCardNo%>" readonly>
<INPUT type="hidden" SIZE=5 name="RUNCARDID" value="<%=runCardID%>" readonly>
<INPUT type="hidden" SIZE=5 name="OP_SEQ" value="<%=operSeqNum%>" readonly>
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
<INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
<INPUT type="hidden" SIZE=5 name="SYSTEMDATE" value="<%=systemDate%>" readonly>
</FORM>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
