<!-- 20071211 liling 待移轉工令datecode 由workorder date_code欄位取得 -->
<!-- 20090424 liling 將for 人工打入異動日期,以原'作業員'RES_EMPLOYEE_OP 欄位做為異動日期-->
<!-- 20091110 Marvie performance tuning-->
<!-- 20170411 liling performance tuning -->
<!-- 20201021 liling 晶片item type 改為DICE 加入dice 判斷是否有領料 -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>MFG System Run Card Transfer Page</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ArrayCheckBoxBean,CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
</head>
<jsp:useBean id="arrMFGRCExpTransBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="arrayLotIssueCheckBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrMFGResourceBean" scope="session" class="Array2DimensionInputBean"/>
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
function setSubmit(URL,ms1,chkMoveQtyFlag,chkLotFlag,woType,backEndIssFlag)
{ 
	var linkURL = "#ACTION";
  	// 2007/04/09 增加若屬後段工令,則一律要求必須 "執行" Oracle領料作業 方能執行WIP移站作業_起
  	if ((woType=="3") || (woType=="2"))// 若為後段工令 ,20120208 加入前段判斷
  	{
   		if (backEndIssFlag=="N")
   		{
        	alert("  警告!!!此工令,您尚未於ORACLE系統領料\n   煩請先確認領料後,方能執行後段製程移站作業!!!");
	    	document.DISPLAYREPAIR.SUBLOTCH.focus(); 
	    	return(false);
   		}
  	}
  	// 2007/04/09 增加若屬後段工令,則一律要求必須 "執行" Oracle領料作業 方能執行WIP移站作業_迄 
  	if (chkMoveQtyFlag=="N")
  	{
	   // alert("請給定投產移站數量!!!");
	    //document.DISPLAYREPAIR.ACTIONID.focus(); 
	   // return(false); // 2007/01/05
  	} 
  	if (document.DISPLAYREPAIR.ACTIONID.value=="006")  //TRANSFER表示為確認移站轉至MOVING動作
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
                } 
                if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                {
                	alert("請選擇項目後再進行投產動作!!!");  
					document.DISPLAYREPAIR.ACTION.value = "--"; 
                    return(false);
                }
	        }
		}
  	} 
  	if (document.DISPLAYREPAIR.ACTIONID.value=="012")  //COMPLETE表示為確認移站完成COMPLETE動作
  	{
    	flag=confirm("確認流程卡完工移站?");      
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
                } 
                if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                {
                	alert("請選擇項目後再進行投產動作!!!");    
					document.DISPLAYREPAIR.ACTION.value = "--"; 
                    return(false);
                }
	        } // End of if 	
		}
  	} 
  	document.DISPLAYREPAIR.submit2.disabled = true;
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();
}
function setSubmit1(URL)
{ 
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

x = new Array(10, 3, -6, 8, 10, -7, 5, -3, 0,0,0,0,0,0,0,0,0,0,0,0);
y = new Array(-12, 6, -3, 10, -9, -2, 8, 2,0,0,0,0,0,0,0,0,0,0,0,0);
count = 0;
function purupuruWin()
{
	if (x[count] != 0) moveBy(x[count],y[count]);
   	count++;
   	if (count >= x.length) count = 0;
   	setTimeout("purupuruWin()",100);
   	winReset();
}

var quakeID=0; 
var deltaX=0; 
var deltaY=0; 
function tremor(dir) 
{ // -10 to 10 
	with(Math) return ceil(random()*10)*2*(floor(random()*2)-.5); 
} 

function winQuake() 
{ 
	clearTimeout(quakeID); 
	for (i=0;i<=((Math.random()*35)+5);i++)
 	{ 
  		xShift = tremor(); 
  		yShift = tremor(); 
  		window.moveBy(xShift,yShift);   
  		deltaX -= xShift; 
  		deltaY -= yShift; 
  	} 
  	winReset(); 
 	quakeID=setTimeout("winQuake()",Math.ceil(Math.random()*3500)+250); 
  	window.moveTo(0,0);   
} 

function winReset() 
{ 
	window.moveBy(deltaX,deltaY);    
   	deltaX=0; deltaY=0; 
}

function shake(n) 
{  	
	if (self.moveBy) 
	{  
		for (i = 10; i > 0; i--) 
		{  
			for (j = n; j > 0; j--) 
			{  
				self.moveBy(0,i);  
				self.moveBy(i,0);  
				self.moveBy(0,-i);  
				self.moveBy(-i,0);  
        	}  
    	}  
	}  
}

function setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee, xOverValue, xRunCardQty, xSCRAPQty , prevOpSeqNum, woType, destStdDesc , xMACHINEWKHour)
{
	//alert("可超出數="+xOverValue+"  xInQueueQty="+xInQueueQty+"  xInQueueQty="+xInQueueQty);    
  	//var linkURL = "#ACTION";  
  	formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()";
  	formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  	xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數(良品數)
  
  	formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  	formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  	xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數(處理數)
  
  	formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  	formSCRAP_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  	xSCRAPQTY = eval(formSCRAP_Write);  // 把值取得給java script 變數(報廢數)
  
  	formWKCLASS = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".focus()";
  	formWKCLASS_Write = "document.DISPLAYREPAIR.WKCLASS"+xINDEX+".value";
  	xWKCLASS = eval(formWKCLASS_Write);  // 把值取得給java script 變數
  
  	try
	{
		formRESOURCEQTY = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".focus()";
		formRESOURCEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY"+xINDEX+".value";
		xRESOURCEQTY = eval(formRESOURCEQTY_Write);  // 把值取得給java script 變數
	}
	catch(err)
	{
		xRESOURCEQTY = "*";
	}
	 
	try
	{ 
		formRESOURCEMACHINEQTY = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".focus()";
		formRESOURCEMACHINEQTY_Write = "document.DISPLAYREPAIR.RESOURCEQTY_MACHINE"+xINDEX+".value";
		xRESOURCEMACHINEQTY = eval(formRESOURCEMACHINEQTY_Write);  //add by Peggy 20120313,把值取得給java script 變數(機器工時)
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
			alert("移站數量必需為正數值型態!!");
		  	eval(formQUEUEQTY); // 取得焦點		     
		  	return(false);
	    }
    }
	   
	txt10=xSCRAPQTY;	    //檢查報廢數量是否為數字
    for (j=0;j<txt10.length;j++)      
    { 
    	c=txt10.charAt(j);
	    if ("0123456789.".indexOf(c,0)<0) 
	    {
			alert("報廢數量必需為正數值型態!!");
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
			alert("移站數量必需為正數值型態!!");
		  	eval(formINPUTQTY); // 取得焦點		     
		  	return(false);
	    }
    }
	
	if (xRESOURCEMACHINEQTY != "*")
	{ 
		txt31=xRESOURCEMACHINEQTY;	 //檢查機器工時回報數量是否為數字,add by Peggy 20120313
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
  		if (xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="" || xRESOURCEMACHINEQTY==null || xRESOURCEMACHINEQTY=="") //add by Peggy 20120313
  		{
			alert("請至少輸入機器工時回報資訊 !!!");
			//eval(formRESOURCEQTY);
			eval(formRESOURCEMACHINEQTY);
			return false;
		}
		//if (eval(xRESOURCEMACHINEQTY)>=40 )  //add by Peggy 20120313
		if (eval(xRESOURCEMACHINEQTY)>=72 )  //add by Peggy 20161019
		{
			alert("請注意此批機器工時已大於72小時 !!!");
			//eval(formRESOURCEQTY);
			eval(formRESOURCEMACHINEQTY);
			return false;
		} 
	}
	else
	{
		xRESOURCEMACHINEQTY = "";
	}	
	   
	if (xRESOURCEQTY != "*")
  	{
		txt3=xRESOURCEQTY;	 //檢查人工工時回報數量是否為數字
		var fieldname = document.DISPLAYREPAIR.worktimes_p.value;
		for (j=0;j<txt3.length;j++)      
		{ 
			e=txt3.charAt(j);
			if ("0123456789.".indexOf(e,0)<0) 
			{
				alert(fieldname+"工時回報數量必需為正數值型態!!");
				eval(formRESOURCEQTY); // 取得焦點		     
				return(false);
			}
		}  
  		if (xRESOURCEQTY==null || xRESOURCEQTY=="" || xRESOURCEQTY==null || xRESOURCEQTY=="")
  		{
   			alert("請至少輸入"+fieldname+"工時回報資訊 !!!");
   			//eval(formRESOURCEQTY);
   			eval(formRESOURCEQTY);
   			return false;
  		}
  		//if (eval(xRESOURCEQTY)>=40 )   //Liling 2007/08/30 add 因yew老是超打工時,故提出警示需求
		if (eval(xRESOURCEQTY)>=72 )   //20161019 Peggy
  		{
   			alert("請注意此批"+fieldname+"工時已大於72小時 !!!");
   			//eval(formRESOURCEQTY);
   			eval(formRESOURCEQTY);
   			return false;
  		} 
	}
	else
	{
		xRESOURCEQTY ="";
	}
		  
	txt4=xSCRAPQTY;	 //檢查報廢數量是否為數字
    for (j=0;j<txt4.length;j++)      
    { 
    	e=txt4.charAt(j);
	    if ("0123456789.".indexOf(e,0)<0) 
	    {
			alert("報廢數量必需為正數值型態!!");
		  	eval(formSCRAPQTY); // 取得焦點		     
		  	return(false);
	    }
  	} 

	txt5=xRESEMPLOYEE;	 //檢查移站日期是否為數字 20090424
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
  	
	if (txt5.length < 8 || txt5.length > 8 )  //檢查日期長度 20090424
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
		eval(formQUEUEQTY);
		//return false;
  	}

  	if (eval(xOverValue)<eval(xQUEUEQTY)+eval(xSCRAPQty) || eval(xOverValue)<eval(xInQueueQty)+eval(xSCRAPQty)) // 2007/04/10 By Kerwin (良品數+報廢數)不得大於超額完工數(平均流程卡)
  	{ 
    	//alert("移站數量="+xQUEUEQTY+"\n 投產數="+xInQueueQty);	
		alert("移站數量不得大於超額完工比率\n         請重新輸入 !!!");	
		eval(formQUEUEQTY);
		return false;
  	}
 
  	var calScrapQty = xInQueueQty - xQUEUEQTY;  // 預計報廢數 = 處理數 - 良品數   
  	//var calInQueueQty = eval(xQUEUEQTY) + eval(xSCRAPQTY);   // 若是第一站,則 處理數 = 良品數 + 報廢數
  	var calInQueueQty = Math.round((eval(xQUEUEQTY)+eval(xSCRAPQTY))*1000)/1000; // 若是第一站,則 處理數 = 良品數 + 報廢數
  
  	if (prevOpSeqNum=="0") // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_起
  	{
		calInQueueQty = Math.round(calInQueueQty*1000)/1000;  // 取到小數後3位,四捨五入	   
		document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value = calInQueueQty
		//alert("calInQueueQty="+calInQueueQty);
		calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數 
  	} 
	else 
	{
		// 若不是第一站,則限制 良品數 + 報廢數 不得大於 處理數
		if (calInQueueQty > xINPUTQTY)
		{
			alert("良品數+報廢數不得大於處理數\n       請再確認!!!");
			eval(formSCRAPQTY);  // setFocus 到報廢數  
			return false;
		}
	} // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_迄 
		  
  	if (woType=="3" && eval(prevOpSeqNum)==0) // 若後段第一站,則需限制良品數需 >= 流程卡數
  	{
		if ( xQUEUEQTY < xRunCardQty )
	 	{  
			alert("        此為後段工令第一站\n限定良品數必需大於或等於流程卡數 !!!"); 
			eval(formQUEUEQTY);
			return false;
	 	}  	
		else 
		{ 
			eval(formSCRAPQTY); 
		}  // setFocus 到報廢數
  	}
  
  	if (woType=="3" && eval(destStdDesc)>=0)
   	{
		if (eval(xQUEUEQTY)!=eval(xRunCardQty))
		{  
			alert("此為後段工令目檢站,限定良品數需為流程卡數 !!!"); 
			//winQuake(); // 晃動畫面
			shake(3); // 地震畫面
			eval(formQUEUEQTY);
			return false;
		}  
		else  
		{  
			eval(formSCRAPQTY); 
		}  // setFocus 到報廢數 		    
   	}	
  
  	var linkURL = "#"+xINDEX;
  	document.DISPLAYREPAIR.submit2.disabled = false;
  	document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目	 
  	document.DISPLAYREPAIR.action=URL+"&QUEUEQTY"+xINDEX+"="+xQUEUEQTY+"&INPUTQTY"+xINDEX+"="+xINPUTQTY+"&SCRAPQTY"+xINDEX+"="+xSCRAPQTY+"&WKCLASS"+xINDEX+"="+xWKCLASS+"&RESOURCEQTY"+xINDEX+"="+xRESOURCEQTY+"&RESMACHINE"+xINDEX+"="+xRESMACHINE+"&RESEMPLOYEE"+xINDEX+"="+xRESEMPLOYEE+"&RUNCARDID="+xINDEX+"&RESOURCEQTY_MACHINE"+xINDEX+"="+xRESOURCEMACHINEQTY+linkURL;  
  	document.DISPLAYREPAIR.submit();   
}

function setTabNext(tabNextIndex, URL, xINDEX, xInQueueQty, xScrapQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee ,xOverValue, xRunCardQty, woType, destStdDesc, prevOpSeqNum, xMACHINEWKHour)
{ 
	formQUEUEQTY = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".focus()"; 
  	formQUEUEQTY_Write = "document.DISPLAYREPAIR.QUEUEQTY"+xINDEX+".value";
  	xQUEUEQTY = eval(formQUEUEQTY_Write);  // 把值取得給java script 變數(良品數)

  	// 2007/03/27 可手動輸入報廢數
  	formSCRAPQTY = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".focus()";
  	formSCRAPQTY_Write = "document.DISPLAYREPAIR.SCRAPQTY"+xINDEX+".value";
  	xSCRAPQTY = eval(formSCRAPQTY_Write);  // 把值取得給java script 變數(報廢數)
  	// 2007/03/27 可手動輸入報廢數
  
  	formINPUTQTY = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".focus()";
  	formINPUTQTY_Write = "document.DISPLAYREPAIR.INPUTQTY"+xINDEX+".value";
  	xINPUTQTY = eval(formINPUTQTY_Write);  // 把值取得給java script 變數(處理數)
  
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
  	xRESMACHINE = eval(formRESMACHINE_Write);  // 把值取得給java script 變數(機號)
  
  	formRESEMPLOYEE = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".focus()";
  	formRESEMPLOYEE_Write = "document.DISPLAYREPAIR.RESEMPLOYEE"+xINDEX+".value";
  	xRESEMPLOYEE = eval(formRESEMPLOYEE_Write);  // 把值取得給java script 變數(異動日期)
  
  	var calScrapQty = xInQueueQty - xQUEUEQTY;  // 預計報廢數 = 處理數 - 良品數  
  	var calInQueueQty = Math.round((eval(xQUEUEQTY)+eval(xSCRAPQTY))*1000)/1000; // 若是第一站,則 處理數 = 良品數 + 報廢數
   	if (event.keyCode==13) // event.keycode = 9 --> Tab 鍵, event.keyCode==13 --> Enter 鍵
   	{
    	if (tabNextIndex=="1")
	  	{
			// 判斷若下一站SEQ ID = 0 則表示為最後一站,且如為後段工令,則需限制移站數() = 流程卡數
		 	if (woType=="3" && eval(destStdDesc)>=0)
			{
		    	if (eval(xQUEUEQTY)!=eval(xRunCardQty))
				{  
			   		alert("此為後段工令目檢站,限定良品數需為流程卡數 !!!"); 
			   		eval(formQUEUEQTY);
			   		return false;
				}  
				else 
				{ 
			    	eval(formSCRAPQTY); 
				}  // setFocus 到報廢數					 
		 	} 
			else if (woType=="3" && prevOpSeqNum=="0") // 若後段第一站,則需限制良品數需 >= 流程卡數
		    {
				if ( eval(xQUEUEQTY) < eval(xRunCardQty) )
			    {  
			    	alert("        此為後段工令第一站\n限定良品數必需大於或等於流程卡數 !!!"); 
			        eval(formQUEUEQTY);
			        return false;
			    }   
			    eval(formSCRAPQTY);  // setFocus 到報廢數					  
			}		 
		    else 
			{
		    	if (xQUEUEQTY<xInQueueQty) // 若良品數 < 處理數,則自動計算報廢數
				{ 
		        	calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		            document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
				} 
				else 
				{ // 否則表示OverComplete 不會有報廢數
					document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=0;
				}
	            eval(formSCRAPQTY);  // setFocus 到報廢數  
			} 
				 
			if (prevOpSeqNum=="0") // 若為第一站,則一律自動計算處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_起
			{ 
		  		calInQueueQty = Math.round(calInQueueQty*1000)/1000;  // 取到小數後3位,四捨五入	   
		  		document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value = calInQueueQty // 預設計算的處理數
			} 
			else 
			{
		    	// 若不是第一站,則限制 良品數 + 報廢數 不得大於 處理數
				if ((eval(xQUEUEQTY) + eval(xSCRAPQTY)) > xINPUTQTY)
				{
					alert("良品數+報廢數不得大於處理數\n       請再確認!!!");
					eval(formQUEUEQTY);  // setFocus 到良品數  
					return false;
				}
		    } // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_迄 
			eval(formSCRAPQTY);  // setFocus 到報廢數 
	  	}  
		else if (tabNextIndex=="10")
	    { 
			if (prevOpSeqNum=="0") // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_起
		    {
		    	calInQueueQty = Math.round(calInQueueQty*1000)/1000;  // 取到小數後3位,四捨五入	   
		        document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value = calInQueueQty
				eval(formWKCLASS);  // setFocus 到投入數(處理數)改成移焦點到班別,因為處理數由系統自行運算
		    } 
			else 
			{
		    	// 若不是第一站,則限制 良品數 + 報廢數 不得大於 處理數
				if ((eval(xQUEUEQTY) + eval(xSCRAPQTY)) > xINPUTQTY)
				{
					alert("良品數+報廢數不得大於處理數\n       請再確認!!!");
					eval(formSCRAPQTY);  // setFocus 到報廢數  
					return false;
				}
		    } // 若為第一站,則一律處理數 = 良品數 + 報廢數(2007/04/03 By Kerwin)_迄 			      
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
		    setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue , document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value, prevOpSeqNum, woType, destStdDesc, xMACHINEWKHour);
		}
   	} 
   
   	if (event.keyCode==9)  
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
        	c=txt10.charAt(j);
	     	if ("0123456789.".indexOf(c,0)<0) 
	     	{
		  		alert("報廢數量必需為正數值型態!!");
		  		eval(formSCRAPQTY); // 取得焦點		     
		  		return(false);
	     	}
       	}
           
		if (tabNextIndex=="1" || tabNextIndex=="10")
		{
			if (woType=="3" && eval(destStdDesc)>=0)
	        {
		    	if (eval(xQUEUEQTY)!=eval(xRunCardQty))
			    {  
			    	alert("此為後段工令目檢站,限定良品數需為流程卡數 !!!"); 
			        eval(formQUEUEQTY);
			        return false;
			    }  
			    else  
				{  
			    	eval(formSCRAPQTY); 
				}  // setFocus 到報廢數 		    
		    } 
		   
            if (xQUEUEQTY<xInQueueQty) // 若良品數 < 處理數,則自動計算報廢數
			{
		    	calScrapQty = Math.round(calScrapQty*1000)/1000;  // 取到小數後3位,四捨五入	           
		        document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=calScrapQty;   // 預設計算的報廢數
			} 
			else
			{ // 否則判斷報廢數是否為0, 不為零, 良品數 + 報廢數 = 自動計算處理數
				if (document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value!="0")
				{
					document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value=calInQueueQty;
				} 
				else 
				{
					document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value=0; 
				    document.DISPLAYREPAIR.elements['INPUTQTY'+xINDEX].value=xQUEUEQTY;
				}
			} //
		} 
		else if (tabNextIndex=="7")
		{
			setSubmitQtyToMove(URL, xINDEX, xInQueueQty, xInInputQty, xWKClass, xWKHour, xWKMachine, xWKEmployee , xOverValue , document.DISPLAYREPAIR.elements['SCRAPQTY'+xINDEX].value, prevOpSeqNum, woType, destStdDesc, xMACHINEWKHour);
		}
   	}
}
function setQty(URL,xSingleLotQty)
{ 
	var linkURL = "#ACTION"; 
  	document.DISPLAYREPAIR.submit2.disabled = false;
  	document.DISPLAYREPAIR.RECOUNTFLAG.value="Y";
  	document.DISPLAYREPAIR.SINGLELOTQTY.value=xSingleLotQty;
  	//alert(xSingleLotQty+"  "+document.DISPLAYREPAIR.SINGLELOTQTY.value);
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();
}
function setOSPSubmit(URL,ms1,chkMoveQtyFlag,chkLotFlag,woType)
{
	var linkURL = "#ACTION";	
  	if (woType=="3") // 若為後段工令
  	{
   		if (chkLotFlag=="N")
   		{
        	alert("請您先確認後段領料批號!!!");
	    	document.DISPLAYREPAIR.SUBLOTCH.focus(); 
	    	return(false);
   		}
  	}	
	if (chkMoveQtyFlag=="N")
	{
	    //alert("請給定投產數量!!!");
	    //document.DISPLAYREPAIR.ACTIONID.focus(); 
	    //return(false); // 2007/01/05 
	}
	
    if (document.DISPLAYREPAIR.ACTIONID.value==null || document.DISPLAYREPAIR.ACTIONID.value=="--")
    {
    	alert("請選擇執行動作!!!");
	 	document.DISPLAYREPAIR.ACTIONID.focus(); 
	 	return(false);
    }

  	if (document.DISPLAYREPAIR.ACTIONID.value=="006" || document.DISPLAYREPAIR.ACTIONID.value=="024" || document.DISPLAYREPAIR.ACTIONID.value=="023" )  
  	{   //TRANSFER(006)表示為確認移站轉至OSP動作 或投產(024)即自動外包(工令Release)或下一站移至外包站(023)
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
               	} 
                if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
                {
                	alert("請選擇項目再執行投產動作 !!!");   
					document.DISPLAYREPAIR.ACTIONID.value = "--";
                    return(false);
                }
	        }
		}
  	}
  	document.DISPLAYREPAIR.submit2.disabled = true;
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();
}
function subWinFrontLotFind(entityId,invItem,woQty,accLotQty)
{
  	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/subwindow/TSMfgWipIssueLotFind.jsp?WIPENTITYID="+entityId+"&BENDITEM="+invItem+"&WOQTY="+woQty+"&ACCLOTQTY="+accLotQty,"subwin","width=640,height=480,status=yes,scrollbars=yes,menubar=yes");  
}
function setLotChReset(URL)
{ 
	var linkURL = "#ACTION";	
  	var lotReset = "N"; 
 
  	flag=confirm("是否重選前段半成品批號???");      
  	if (flag==false) return(false);
  	else 
	{	
		lotReset = "Y"; 		  		 
	}
   	document.DISPLAYREPAIR.action=URL+"&RESETLOTCH="+lotReset+linkURL;
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
String systemDate ="";
String resetLotCh = request.getParameter("RESETLOTCH"); // 重置後段選擇的批號
String sTime = request.getParameter("STIME");

if (resetLotCh==null) resetLotCh="N";
else if (resetLotCh.equals("Y")) arrayLotIssueCheckBean.setArray2DString(null); //將陣列內容清空
	
String chkBELot=request.getParameter("CHKBELOT"); // 檢查後段工令是否選擇前段批號(必選欄位=Y,否則前後段無法連結關係)
if (chkBELot==null || chkBELot.equals("")) chkBELot = "N";
String waferLineNo=request.getParameter("LINE_NO");
String operationSeqNum = "",operationSeqId="",standardOpId="",previousOpSeqNum="",nextOpSeqNum="",qtyInQueue="",standardOpDesc="";
String prevOpSeqID = "0",nextOpSeqID = "0"; // 基本頁面將上下一站的OperationSequenceID都取出,作為更新移站時判斷依據
if (operSeqNum==null || operSeqNum.equals("0"))
{
	operSeqNum="10"; 
}
String runCardID=request.getParameter("RUNCARDID");
int lineIndex = 1;	
if (runCardID==null) runCardID = "0";
else lineIndex = Integer.parseInt(runCardID);
String queueQty=request.getParameter("QUEUEQTY"+Integer.toString(lineIndex));
String inputQty=request.getParameter("INPUTQTY"+Integer.toString(lineIndex));
String wkClass=request.getParameter("WKCLASS"+Integer.toString(lineIndex));
String resourceQty=request.getParameter("RESOURCEQTY"+Integer.toString(lineIndex));	
if (resourceQty==null) resourceQty="0";
String resourceQty_machine=request.getParameter("RESOURCEQTY_MACHINE"+Integer.toString(lineIndex));	 //機器工時,add by Peggy 20120313
if (resourceQty_machine==null) resourceQty_machine="0";
String resMachine=request.getParameter("RESMACHINE"+Integer.toString(lineIndex));
String resEmployee=request.getParameter("RESEMPLOYEE"+Integer.toString(lineIndex));
String scrapQty=request.getParameter("SCRAPQTY"+Integer.toString(lineIndex));
String [] check=request.getParameterValues("CHKFLAG");
String runcardQty="";    //流程卡總超出數,前站移站數,流程卡數
String directOSP = request.getParameter("DIRECTOSP"); // 預設非為投產即外包站   
if (directOSP==null || directOSP.equals("")) directOSP = "N";
String overValue=""; //超額完工數
if (scrapQty==null || scrapQty.equals("")) scrapQty = "0";
String dateCode1="";  //20071106 liling
String dateCode=request.getParameter("DATECODE"+Integer.toString(lineIndex));
String dateCodeFlag=request.getParameter("DATECODEFLAG");
String altRoutingDest="",packageCode=""; 
if (dateCodeFlag==null || dateCodeFlag.equals("")) dateCodeFlag="N";  
String dateCodeSet = request.getParameter("DATECODE");  // 批次給定的投產DateCode
boolean	work_machine = false,work_person = false;//add by Peggy 20120313
String 	work_person_code = "",work_machine_code = ""; //add by Peggy 20120327
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("取消確認","是否送出","請選擇執行動作")' ACTION="../JSP-bk/jsp/TSCMfgRCTransferMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>" METHOD="post">
<!--=============以下區段為取得工令設立基本資料==========-->
<%@ include file="/jsp/include/TSCMfgWoBasicInfoPage.jsp"%>
<!--=================================-->
<%
// 若發現工單展開產生之工令 Entity Id與寫入Run Card主檔不同,此時更新Run Card主檔_起
boolean wip_entity_err = false;
String sqlRC = " select WIP_ENTITY_ID from APPS.YEW_RUNCARD_ALL "+
               " where (OPERATION_SEQ_NUM = 0 OR OPERATION_SEQ_ID=0 OR STANDARD_OP_ID=0 )"+
  			   "   and WO_NO='"+woNo+"' and RUNCARD_NO = '"+runCardNo+"' " ;
Statement stateRC=con.createStatement();
ResultSet rsRC=stateRC.executeQuery(sqlRC);
if (rsRC.next())
{
	wip_entity_err = true; // 表示先前Entity_id取錯或未取到
}
rsRC.close();
stateRC.close(); 

if (wip_entity_err==true )  // 表示先前Entity_id取錯,作更新正確的ENtity ID及取正確的Opeartion 資訊
{  
	try
   	{
    	String sqlOp = " select b.WIP_ENTITY_ID from WIP_DISCRETE_JOBS b, WIP_ENTITIES a where b.WIP_ENTITY_ID = a.WIP_ENTITY_ID and a.WIP_ENTITY_NAME='"+woNo+"' " ;
	 	Statement stateOp=con.createStatement();
     	ResultSet rsOp=stateOp.executeQuery(sqlOp);
	 	if (rsOp.next())
	 	{
	   		entityId   = rsOp.getString(1);	   	
	 	}
	 	rsOp.close();
     	stateOp.close(); 
	 
	 	String sqlp = " select OPERATION_SEQ_NUM, OPERATION_SEQUENCE_ID, STANDARD_OPERATION_ID,  "+
        			"       DESCRIPTION, PREVIOUS_OPERATION_SEQ_NUM, NEXT_OPERATION_SEQ_NUM   "+
					"  from WIP_OPERATIONS where PREVIOUS_OPERATION_SEQ_NUM is null and WIP_ENTITY_ID ="+entityId+" ";	
					
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
			
			operSeqNum = operationSeqNum; // 把正確的 OP Sequence Num 給表單參數
			if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
			if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
			if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";
			if (nextOpSeqNum==null || nextOpSeqNum.equals("")) nextOpSeqNum = "0";			
	 	} 
		else 
		{
	    	operationSeqNum   = "0";
			operationSeqId    = "0";
			standardOpId  	  = "0";
			standardOpDesc   = "0"; 
	        previousOpSeqNum  = "0"; 
			nextOpSeqNum	  = "0"; 			 
	  	}
	 	rsp.close();
     	statep.close(); 
 		
		// 流程卡投產第一站, 故若使用分次投產若展開時未取得正確移站資訊,則需依(流程卡號)更新	 
    	String woSql=" update APPS.YEW_RUNCARD_ALL set WIP_ENTITY_ID=?, "+ 
	            	 " OPERATION_SEQ_NUM=?, OPERATION_SEQ_ID=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, NEXT_OP_SEQ_NUM=?, PREVIOUS_OP_SEQ_NUM=?  "+
	            	 " where WO_NO = '"+woNo+"' and OPERATION_SEQ_NUM = 0 "; 	
    	PreparedStatement wostmt=con.prepareStatement(woSql);	        
    	wostmt.setInt(1,Integer.parseInt(entityId)); 
		wostmt.setInt(2,Integer.parseInt(operationSeqNum));
		wostmt.setInt(3,Integer.parseInt(operationSeqId)); 
		wostmt.setInt(4,Integer.parseInt(standardOpId)); 
		wostmt.setString(5,standardOpDesc); 
		wostmt.setInt(6,Integer.parseInt(nextOpSeqNum));
		wostmt.setInt(7,Integer.parseInt(previousOpSeqNum));
    	wostmt.executeUpdate();   
    	wostmt.close(); 
	
		// 工令的主檔也一併更新_起	
		String woUpSql=" update APPS.YEW_WORKORDER_ALL set WIP_ENTITY_ID=? "+ 	             
	               " where WO_NO = '"+woNo+"' "; 	
    	PreparedStatement woUpstmt=con.prepareStatement(woUpSql);	        
    	woUpstmt.setInt(1,Integer.parseInt(entityId)); 	
    	woUpstmt.executeUpdate();   
    	woUpstmt.close(); 
   	}// end of try
   	catch (Exception e)
   	{
    	out.println("Exception 3:"+e.getMessage());
   	}		
} 

//非標準工單判斷是否於Oracle執行Release及新增Operation_起
boolean wipRelease = true;
boolean poReceiptOSP = true;
if (jobType.equals("2")) // 非標準工單,判斷是否於Oracle執行Release及新增Operation
{
	String sqlRes = " select a.STATUS_TYPE, b.OPERATION_SEQ_NUM "+        			              
	                "   from WIP_DISCRETE_JOBS a, WIP_OPERATION_RESOURCES b "+
				    "  where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and a.WIP_ENTITY_ID ="+entityId+" ";								 
	Statement stateRes=con.createStatement();
    ResultSet rsRes=stateRes.executeQuery(sqlRes);
	if (!rsRes.next())
	{
%>
		<script language="javascript">
			alert("        非標準工單(重工工令)!!!\n     您尚未設定此工令製程資訊\n請先至Oracle Job/Schedule Details新增");
		</script>		  
<% 
		wipRelease = false; // 未Release,且未設定Resource
	} 
	else
	{
		//WIP_MOVE   CONSTANT NUMBER := 1;
        //MANUAL     CONSTANT NUMBER := 2;
        //PO_RECEIPT CONSTANT NUMBER := 3;
        //PO_MOVE    CONSTANT NUMBER := 4;
		// --> 此處務必要求使用者設為 3 , 於待投產處理方能保證產生 PR Line 於 Interface Table
		String sqlResOSP = " select b.AUTOCHARGE_TYPE "+        			              
					       "   from WIP_OPERATION_RESOURCES b, BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
						   "  where b.WIP_ENTITY_ID ="+entityId+" "+
						   "    and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 因為重工工令可能無BOM表
						   "    and b.RESOURCE_ID = d.RESOURCE_ID "+
						   "    and d.COST_CODE_TYPE = 4 ";	  // 外包站資源(OSP)
		Statement stateResOSP=con.createStatement();
        ResultSet rsResOSP=stateResOSP.executeQuery(sqlResOSP);
		if (rsResOSP.next()) 
		{  // 檢查 外包資源是否設定為 PO Receipt
			if (!rsResOSP.getString(1).equals("3")) // 如果不為 PO Receipt
			{						      
%>
		     	<script language="javascript">
					alert("        非標準工單(重工工令)!!!\n您的工令外包站未設定成 PO Receipt\n請先至Oracle變更工令外包Operation");
			    </script>		  
<%	
				poReceiptOSP = false; // 如果不為 PO Receipt
			}
		} 
		rsResOSP.close();
		stateResOSP.close();
						   
		if (rsRes.getString(1).equals("1"))
		{
%>
			<script language="javascript">
				alert("     非標準工單(重工工令)!!!\n        您尚未釋出此工令\n請先至Oracle設定工令狀態為Released");
			</script>		  
<%							
			wipRelease = false; // 未Release
		}  
	}
	rsRes.close();
	stateRes.close();
} 

try
{
	//抓取DATE CODE begin
 	if (dateCodeFlag=="N" || dateCodeFlag.equals("N"))    //沒有按下重算單批數量才抓單批數量
   	{
    	String sqldc = " select date_code from yew_workorder_all where wo_no= '"+woNo+"' " ;
	 	Statement statedc=con.createStatement();
     	ResultSet rsdc=statedc.executeQuery(sqldc);
	 	if (rsdc.next())
		{ 	
			dateCode1   = rsdc.getString("DATE_CODE"); 
		}
	 	if (dateCode1==null || dateCode1.equals("")) dateCode1=""; 
	 	rsdc.close();
     	statedc.close(); 
	 
	 	// 2007/11/22 Kerwin Add 判斷若使用者未給定批次DateCodeSet,則以系統預設取得之DateCode作為設定值
	 	if (dateCodeSet==null || dateCodeSet.equals("")) 
	 	{	
	  		dateCodeSet = dateCode1;
	 	}
  	}
}
catch (Exception e)
{
	out.println("Exception DATE CODE:"+e.getMessage());
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
 
// -9888888888888888888 若使用者同批投產多張流程卡,個別更新選擇RUNCARD_ID 的移站資訊,確保批次移站無誤 8888888888888888888889_起
try
{
	//out.println("runCardNo="+runCardNo);
	if (runCardNo!=null && runCardNo != "0")
	{
		//與下列sql合併成同一句,modify by Peggy 20120314
		//String sqlOp = " select WIP_ENTITY_ID from WIP.WIP_ENTITIES where WIP_ENTITY_NAME='"+woNo+"' " ;
	  	//Statement stateOp=con.createStatement();
      	//ResultSet rsOp=stateOp.executeQuery(sqlOp);
	  	//if (rsOp.next())
	  	//{
		//	entityId = rsOp.getString(1);
	  	//} 
		//else 
		//{
	    //	entityId = "0";
	    //}
	  	//rsOp.close();
      	//stateOp.close(); 

		work_machine = false;
		work_person = false;
		work_person_code = "";
		work_machine_code = "";
	  	String sqlp = " select a.WIP_ENTITY_ID,a.OPERATION_SEQ_NUM, a.OPERATION_SEQUENCE_ID, a.STANDARD_OPERATION_ID,  "+
        			  "  a.DESCRIPTION, a.PREVIOUS_OPERATION_SEQ_NUM, a.NEXT_OPERATION_SEQ_NUM,d.RESOURCE_TYPE,d.RESOURCE_CODE "+
					  "  from WIP_OPERATIONS a,WIP.WIP_ENTITIES b ,WIP_OPERATION_RESOURCES c,BOM_RESOURCES  d"+
					  "  where a.PREVIOUS_OPERATION_SEQ_NUM is null and a.WIP_ENTITY_ID = b.WIP_ENTITY_ID"+
					  "  and  b.WIP_ENTITY_NAME='"+woNo+"' and  a.WIP_ENTITY_ID= c.WIP_ENTITY_ID   and a.OPERATION_SEQ_NUM =c.operation_seq_num and c.resource_id=d.resource_id";
	  	Statement statep=con.createStatement();
		//out.println("sqlp="+sqlp);
		int recnt=0;
      	ResultSet rsp=statep.executeQuery(sqlp);
	  	while (rsp.next())
	  	{
			entityId          = rsp.getString("WIP_ENTITY_ID");
			operationSeqNum   = rsp.getString("OPERATION_SEQ_NUM");
			operationSeqId    = rsp.getString("OPERATION_SEQUENCE_ID");
			standardOpId  	  = rsp.getString("STANDARD_OPERATION_ID");
			standardOpDesc 	  = rsp.getString("DESCRIPTION");
			previousOpSeqNum  = rsp.getString("PREVIOUS_OPERATION_SEQ_NUM");
			nextOpSeqNum	  = rsp.getString("NEXT_OPERATION_SEQ_NUM");
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
			recnt++;		
	  	} 
		if (recnt==0)
		{
			entityId          = "0";
	    	operationSeqNum   = "0";
			standardOpId  	  = "0";
			standardOpDesc    = "0"; 
	        previousOpSeqNum  = "0"; 
			nextOpSeqNum	  = "0"; 
	    }
		if (operationSeqNum==null || operationSeqNum.equals("")) operationSeqNum = "0";
		if (operationSeqId==null || operationSeqId.equals("")) operationSeqId = "0";
		if (previousOpSeqNum==null || previousOpSeqNum.equals("")) previousOpSeqNum="0";
		if (nextOpSeqNum==null || nextOpSeqNum.equals("")) nextOpSeqNum = "0";	
	  	rsp.close();
      	statep.close(); 
	} 
}
catch (Exception e)
{
	out.println("Exception 找不到此張工令,工令未生成:"+e.getMessage());
}

// -9888888888888888888 若使用者同批投產多張流程卡,各別更新選擇RUNCARD_ID 的移站資訊,確保批次移站無誤 8888888888888888888889_迄
boolean singLastOp = false;
String sqlNextOp = "";
sqlNextOp =" select NEXT_OP_SEQ_NUM from APPS.YEW_RUNCARD_ALL c where WO_NO='"+woNo+"' ";
if (runCardID==null || runCardID.equals("0"))
{
	sqlNextOp = sqlNextOp +" and c.RUNCARD_NO ='"+runCardNo+"' ";
}
else  
{
	sqlNextOp = sqlNextOp + " and c.RUNCAD_ID ='"+runCardID+"' " ;
}
Statement stateNextOp=con.createStatement();
ResultSet rsNextOp=stateNextOp.executeQuery(sqlNextOp);
if (rsNextOp.next() && rsNextOp.getString("NEXT_OP_SEQ_NUM").equals("0")) // 若下一站未找到,表示本站為最後一站
{
	singLastOp = true; //out.println("TRUE");// 表示singLastOp
%>
<!--<script language="javascript">
		   alert("          本站為製程最後一站\n 此工作站完工後流程卡即完工!!!");
		</script>-->
<%
}
rsNextOp.close();
stateNextOp.close(); 
	 
String sqlPrevOpID = "";
if (jobType==null || jobType.equals("1"))
{
   /* 20170411 liling performance issue
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
				  "  where a.ROUTING_SEQUENCE_ID = b.ROUTING_SEQUENCE_ID   "+
				  "    and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
				  "    and c.ORGANIZATION_ID = '"+organizationId+"' "+	
				  "    and a.OPERATION_SEQ_NUM  = c.PREVIOUS_OP_SEQ_NUM "+
				  "    and b.ASSEMBLY_ITEM_ID ='"+primaryItemID+"' "+
				  "    and c.RUNCARD_NO ='"+runCardNo+"' ";					  	
} 
else if (jobType.equals("2"))	
{
   /* 20170411 liling performance issue
	sqlPrevOpID =" select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
				 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				 " and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 可能重工製成品並無BOM
				 " and b.RESOURCE_ID = d.RESOURCE_ID "+
				 " and a.WIP_ENTITY_ID = "+entityId+" "+							
				 " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				 " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				 " and d.ORGANIZATION_ID = '"+organizationId+"' ";
	if (runCardID==null || runCardID.equals("0")) sqlPrevOpID = sqlPrevOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlPrevOpID = sqlPrevOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ; 
	*/
	sqlPrevOpID =" select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
				 " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				 " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				 " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				 " and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 可能重工製成品並無BOM
				 " and b.RESOURCE_ID = d.RESOURCE_ID "+
				 " and a.WIP_ENTITY_ID = "+entityId+" "+							
				 " and a.PREVIOUS_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				 " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				 " and d.ORGANIZATION_ID = '"+organizationId+"' "+
   			     " and c.RUNCARD_NO ='"+runCardNo+"' ";					 						 
}	
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
   /* 20170411 liing performance issue
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
				  "    and c.RUNCARD_NO ='"+runCardNo+"' ";					  
}
else if (jobType.equals("2")) 	
{
   /* 20170411 liing performance issue
	sqlNextOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
	 			  " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				  " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				  " and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 可能重工製成品並無BOM
				  " and b.RESOURCE_ID = d.RESOURCE_ID "+
				  " and a.WIP_ENTITY_ID = "+entityId+" "+							
				  " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				  " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				  " and d.ORGANIZATION_ID = '"+organizationId+"' ";
	if (runCardID==null || runCardID.equals("0")) sqlNextOpID = sqlNextOpID +" and a.RUNCARD_NO ='"+runCardNo+"' ";
    else  sqlNextOpID = sqlNextOpID + " and a.RUNCAD_ID ='"+runCardID+"' " ;	
	*/		
	sqlNextOpID = " select d.DESCRIPTION as OPERATION_DESCRIPTION, c.OPERATION_SEQUENCE_ID "+
	 			  " from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  " BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
				  " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
				  " and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 可能重工製成品並無BOM
				  " and b.RESOURCE_ID = d.RESOURCE_ID "+
				  " and a.WIP_ENTITY_ID = "+entityId+" "+							
				  " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
				  " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
				  " and d.ORGANIZATION_ID = '"+organizationId+"' "+		
				  " and c.RUNCARD_NO ='"+runCardNo+"' ";					  	 
}   						
Statement stateNextOpID=con.createStatement();
ResultSet rsNextOpID=stateNextOpID.executeQuery(sqlNextOpID);
if (rsNextOpID.next())
{
	nextOpSeqID = rsNextOpID.getString("OPERATION_SEQUENCE_ID");	
}
rsNextOpID.close();
stateNextOpID.close();				 
	 
// 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_起
String resourceDesc = "";
boolean ospCheckFlag = false;
try
{
	String sqlJudgeOSP = "";
   	if (jobType==null || jobType.equals("1"))
   	{ 
    	//sqlJudgeOSP =" select b.DESCRIPTION, b.COST_CODE_TYPE "+
        //             " from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
        //             " where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
		//	   		 "   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
		//			 "   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
		//			 "   and d.OPERATION_SEQUENCE_ID = '"+nextOpSeqID+"' "+
		//			 "   and b.COST_CODE_TYPE = 4 "; // Outside Processing Checked
		//modify by Peggy 20120315
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
					   " and b.RESOURCE_ID = c.RESOURCE_ID(+) "+  // 可能重工製成品並無BOM
					   " and b.RESOURCE_ID = d.RESOURCE_ID "+
					   " and a.WIP_ENTITY_ID = "+entityId+" "+
					   " and a.RUNCARD_NO ='"+runCardNo+"' "+
					   " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
					   " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
					   " and d.ORGANIZATION_ID = '"+organizationId+"' "; 
		if (runCardID==null || runCardID.equals("0")) sqlJudgeOSP = sqlJudgeOSP +" and a.RUNCARD_NO ='"+runCardNo+"' ";
        else  sqlJudgeOSP = sqlJudgeOSP + " and a.RUNCAD_ID ='"+runCardID+"' " ;					
	}				   
   
   	Statement stateJudgeOSP=con.createStatement();
   	ResultSet rsJudgeOSP=stateJudgeOSP.executeQuery(sqlJudgeOSP);
   	if (rsJudgeOSP.next())
   	{ 			
    	resourceDesc = rsJudgeOSP.getString("DESCRIPTION");   // 外包站說明顯示於下一站的右方
	  	ospCheckFlag = true;
%>
	    <script language="javascript">
		    alert("            下一站為委外加工站\n 此工作站完工後將產生委外請、採購單!!!");
		</script>	  
<%
   	} 
	else 
	{ 
    } // 判斷若為重工型式工單,則在看是否下一站為外包站_迄
   	rsJudgeOSP.close();
   	stateJudgeOSP.close();	   
} 
catch (Exception e)
{
	out.println("Exception Runcard ospCheckFlag:"+e.getMessage());
}	   
 
// 由BOM表判斷是否下一站對應之站別ID為COST_CODE_TYPE = 4 (Resource 的 Outside Processing Checked)即為外包站_迄 
boolean dirOspFlag = false;
String dirOSPResDesc = "";
try
{
	// 判斷投產站即為委外加工站_起
    if (jobType.equals("1") || jobType.equals("2"))
	{
		String sqlOSPRes = " select DISTINCT d.RESOURCE_CODE, d.DESCRIPTION, c.OPERATION_SEQUENCE_ID "+        			              
		                   "   from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
			  			   "        BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
						   "  where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID "+
						   "    and b.RESOURCE_ID = c.RESOURCE_ID(+) "+ // 可能製成品並無BOM
						   "    and b.RESOURCE_ID = d.RESOURCE_ID "+
						   "    and a.WIP_ENTITY_ID = "+entityId+" and a.RUNCARD_NO = '"+runCardNo+"' "+
						   "    and d.COST_CODE_TYPE = 4 "+
						   "    and d.ORGANIZATION_ID ='"+organizationId+"' "+
						   "    and a.OPERATION_SEQ_NUM = b.OPERATION_SEQ_NUM ";
		Statement stateOSPRes=con.createStatement();
        ResultSet rsOSPRes=stateOSPRes.executeQuery(sqlOSPRes);
		if (rsOSPRes.next())
		{
			dirOSPResDesc = rsOSPRes.getString("DESCRIPTION");   // 外包站說明顯示於下一站的右方
	        dirOspFlag = true;
			directOSP = "Y";
			operationSeqId = rsOSPRes.getString("OPERATION_SEQUENCE_ID");
			if (operationSeqId==null) // 表示(重工)製成品並無BOM表,其餘已由WIP_OPERATIONS取Operation資訊
			{ 
				operationSeqId = "0";						 
			}				   
%>
	        <script language="javascript">
		    	alert("            投產站即為委外加工站\n 此工作站移站將產生委外請、採購單!!!");
		    </script>	  
<%
		}
		rsOSPRes.close();
		stateOSPRes.close();			 
	} 
	 
	//out.println("xxx"+entityId+"xx"+operationSeqNum+"xx"+operationSeqId+"xx"+standardOpId+"xx"+standardOpDesc+"xx"+nextOpSeqNum+"xx"+previousOpSeqNum);
	String woSql=" update APPS.YEW_RUNCARD_ALL set WIP_ENTITY_ID=?, OPERATION_SEQ_NUM=?, OPERATION_SEQ_ID=?, STANDARD_OP_ID=?, STANDARD_OP_DESC=?, NEXT_OP_SEQ_NUM=?, PREVIOUS_OP_SEQ_NUM=?  "+
	             " where WO_NO = '"+woNo+"' and OPERATION_SEQ_NUM=0 ";
    PreparedStatement wostmt=con.prepareStatement(woSql);	        
    wostmt.setInt(1,Integer.parseInt(entityId)); 
	wostmt.setInt(2,Integer.parseInt(operationSeqNum));
	wostmt.setInt(3,Integer.parseInt(operationSeqId)); 
	wostmt.setInt(4,Integer.parseInt(standardOpId)); 
	wostmt.setString(5,standardOpDesc); 
	wostmt.setInt(6,Integer.parseInt(nextOpSeqNum));
	wostmt.setInt(7,Integer.parseInt(previousOpSeqNum));
    wostmt.executeUpdate();   
    wostmt.close();
} //end of try
catch (Exception e)
{
	out.println("Exception runcard dirOSPResDesc:"+e.getMessage());
}	  

float accLotQty = 0;
try
{    
	if (woType.equals("3")) // 後段工令需取出領用半成品批號清單,寫入Array
	{  
		String rr[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前領料批陣列內容 		    		                       		    		  	   
      	if (rr!=null) 
	  	{	 // 如果使用者已有手動給定或確認領料批,則以實際領料批內容為主
	    	String oneDArray[]= {"","領用批號","數量","領用日期","ERP領用"}; 		 	     			  
    	   	arrayLotIssueCheckBean.setArrayString(oneDArray);	
		    
		  	if (rr[0][0]!=null && !rr[0][0].equals("") && !rr[0][0].equals("null"))
		  	{
		    	for (int gg=0;gg<rr.length;gg++)
		    	{
		     		accLotQty = accLotQty + Float.parseFloat(rr[gg][1]); //累加已領數量
		    	}
		  	} 
	  	}	
		else
	    {
	 		String oneDArray[]= {"","領用批號","數量","領用日期","ERP領用"}; 		 	     			  
    	    arrayLotIssueCheckBean.setArrayString(oneDArray);	 
		    // 如果使用者先於WIP工單領料作業已領料,則以領料內容預設作為陣列內容	
	        int rowCount = 0; 
	         
	        Statement statement=con.createStatement();	   
	        ResultSet rsCnt=statement.executeQuery(" select count(DISTINCT LOT_NUMBER) from MTL_MATERIAL_TRANSACTIONS a, MTL_TRANSACTION_LOT_NUMBERS b "+
	                                                " where a.TRANSACTION_ID = b.TRANSACTION_ID  and a.TRANSACTION_SOURCE_ID = b.TRANSACTION_SOURCE_ID "+ 
											        "   and a.TRANSACTION_TYPE_ID = 35 and a.TRANSACTION_SOURCE_ID = "+wipEntityId+" "); 
            if (rsCnt.next())
	        {
	        	rowCount = rsCnt.getInt(1);
	        }
	        rsCnt.close();
	      	if (rowCount>0)
		  	{
	        	String lotLabel[][]=new String[rowCount][4]; // 宣告一二維陣列,分別是(列數+1)X(4= 行)
	         	int tt=0; 	   
             	String sql=" select b.LOT_NUMBER, abs(b.TRANSACTION_QUANTITY), to_char(b.TRANSACTION_DATE,'YYYY/MM/DD HH24:MI:SS') "+
	                       " from MTL_MATERIAL_TRANSACTIONS a, MTL_TRANSACTION_LOT_NUMBERS b "+ 
				           " where a.TRANSACTION_ID = b.TRANSACTION_ID  and a.TRANSACTION_SOURCE_ID = b.TRANSACTION_SOURCE_ID "+ 
				           "   and a.TRANSACTION_TYPE_ID = 35 "+
				           "   and a.TRANSACTION_SOURCE_ID = "+wipEntityId+" "+
				           " order by b.TRANSACTION_DATE ";
	         	ResultSet rs=statement.executeQuery(sql);            
	         	while (rs.next())
	         	{
	            	lotLabel[tt][0]=rs.getString("LOT_NUMBER");lotLabel[tt][1]=rs.getString(2);lotLabel[tt][2]=rs.getString(3);lotLabel[tt][3]="Y";	
		        	arrayLotIssueCheckBean.setArray2DString(lotLabel);	
		        	accLotQty = accLotQty + rs.getFloat(2);		   
		        	tt++;
	         	}
	         	rs.close();
	         	statement.close();
			}
		
		    String qq[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前領料批陣列內容 		   
			if (qq!=null) // 使用者於Oracle已作WIP領料作業,顯示領料內容
			{ 
				if (qq[0][0]!=null && !qq[0][0].equals("") && !qq[0][0].equals("null"))
			 	{
			 	}
			}			
	    }
	}
}
catch (Exception e)
{
	out.println("Exception Get SemiItemLot:"+e.getMessage());
}

if (woType.equals("3")) // 後段工令需取出領用半成品批號清單,寫入Array
{
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
	<td width="5%" nowrap>
	    <font color="#000066">
	     <a onmouseover='this.T_WIDTH=200;this.T_OPACITY=80;return escape("點擊選擇實際領用半成品批號")'><input type='button' name='SUBLOTCH' value='Lot Control' onClick='subWinFrontLotFind("<%=entityId%>","<%=primaryItemID%>","<%=woQty%>","<%=accLotQty%>")'></a>
	    </font>
	</td>
    <td colspan="3">	  
<%
	String oneDArray[]= {"","領用批號","數量","領用日期","ERP領用"}; 		 	     			  
    arrayLotIssueCheckBean.setArrayString(oneDArray);
	  
	String ww[][]=arrayLotIssueCheckBean.getArray2DContent();//取得目前陣列內容
    if (ww!=null) 
	{	
		arrayLotIssueCheckBean.setTrBgColor("#BDA279");	  
	    out.println(arrayLotIssueCheckBean.getArrayWip2DString());	
		if (resetLotCh!=null && !resetLotCh.equals(""))	
		{
		}			
%>
		<a onmouseover='this.T_WIDTH=200;this.T_OPACITY=80;return escape("點擊重置領用半成品批號")'><input type="button" name="RESETLOTCH" value="重置"  onClick='setLotChReset("../jsp/TSCMfgRunCardTransfer.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>&EXPAND=<%=expand%>")'></a>
<%   
	}	
%>
	</td>
	</tr>
</table>
<%
} 

// 2012/02/08 判斷是否前段工令已領用晶片,已領料方能執行製程移站_起 ---> By liling
String backEndIssFlag = "N";
if (woType.equals("2")) //  
{ 
	Statement stmtc=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
    ResultSet rsCNTc = stmtc.executeQuery(" SELECT 1  FROM wip_requirement_operations wro,mtl_system_items msi "+
	  									  "  WHERE wro.organization_id=msi.organization_id  AND MSI.INVENTORY_ITEM_ID = WRO.INVENTORY_ITEM_ID "+
										  "    AND MSI.ITEM_TYPE IN ('CHIP','WAFER','SA','DICE')  AND wro.WIP_ENTITY_ID= '"+wipEntityId+"' "+    //20201021 Liling add DICE
 										  "    HAVING SUM(QUANTITY_ISSUED) > 0  GROUP BY wro.WIP_ENTITY_ID	");
												 
	rsCNTc.last();
	int rowCountc = rsCNTc.getRow(); // 取得資料筆數,如大於零表示此後段工令已領前段半成品批號
	if (rowCountc>0)
	{
		backEndIssFlag = "Y"; // 如已領用半成品,則設定為Y
	}
	else
	{
%>
		<script language="javascript">
			alert("        請注意,此工單尚未領晶片!!!");
		</script>		  
<%
		backEndIssFlag = "N";
	}
	rsCNTc.close();
	stmtc.close();
} 
// 2012/02/08 判斷是否前段工令已領用晶片,已領料方能執行製程移站_迄 ---> By liling
// 2007/04/09 判斷是否後段工令已領用前段半成品批,已領料方能執行製程移站_起 ---> By Kerwin
//String backEndIssFlag = "N";
if (woType.equals("3")) //  
{ 
	Statement stmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
    ResultSet rsCNT = stmt.executeQuery(" select b.LOT_NUMBER "+
	                                    "   from MTL_MATERIAL_TRANSACTIONS a, MTL_TRANSACTION_LOT_NUMBERS b, "+ 
										"        MTL_SYSTEM_ITEMS c "+
				                        " where a.TRANSACTION_ID = b.TRANSACTION_ID  and a.TRANSACTION_SOURCE_ID = b.TRANSACTION_SOURCE_ID "+ 
				                        "   and a.TRANSACTION_TYPE_ID = 35 "+
										"   and a.ORGANIZATION_ID = c.ORGANIZATION_ID "+
										"   and a.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
										"   and substr(c.SEGMENT1,5,1) = '-' and (c.ITEM_TYPE ='SA' or c.ITEM_TYPE ='FG' ) "+ // 領用半成品批號
				                        "   and a.TRANSACTION_SOURCE_ID = "+wipEntityId+" ");
	rsCNT.last();
	int rowCount = rsCNT.getRow(); // 取得資料筆數,如大於零表示此後段工令已領前段半成品批號
	if (rowCount>0)
	{
		backEndIssFlag = "Y"; // 如已領用半成品,則設定為Y
	}
	rsCNT.close();
	stmt.close();
}
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="3"><font color="#000066">
      流程卡明細 : 
<%
	out.println("entityId("+entityId+")");
	String chkMoveQtyFlag = "N";
	//out.println("prevOpSeqNo="+prevOpSeqNo);
	try
    {   
		String oneDArray[]= {"流程卡識別碼","流程卡號","前一站","目前站別","移站數量","下一站","流程卡狀態","展開日期"};  // 先將內容明細的標頭,給一維陣列		 	     			  
    	arrMFGRCExpTransBean.setArrayString(oneDArray);
		// 先取 該詢問單筆數
	    int rowLength = 0;
	    Statement stateCNT=con.createStatement();
		String sqlCNT = "select count(RUNCAD_ID) from YEW_RUNCARD_ALL where WO_NO='"+woNo+"' and STATUSID = '"+frStatID+"' "+
		                 "   and OPERATION_SEQ_NUM="+operSeqNum+" ";	
						 	
        ResultSet rsCNT=stateCNT.executeQuery(sqlCNT);	
	    if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	    rsCNT.close();
	    stateCNT.close();
	  
	   	String b[][]=new String[rowLength+1][12]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	   	String r[][]=new String[rowLength+1][21]; // 宣告一二維陣列,分別是(=列)X(資料欄數+1= 行)
	    
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
				//舊單輸入的是機器工時
				out.println("<td><font color='#990000'>機器工時</font><img src='../image/point.gif'><input type='hidden' name='worktimes_p' value='機器'></td>");
			}
		}
	   	out.println("<td><font color='#990000'>日期</font></td>");
	   	out.println("<td><font color='#990000'>機號</font></td>");
	   	out.println("<td><font color='#990000'>前一站</font></td>");
	   	if (dirOspFlag)
	   	{
	   		out.println("<td nowrap><font color='#990000'><em>目前站別(投產委外加工站)</em></font></td>");
		}
	   	else
		{
			out.println("<td nowrap><font color='#990000'>目前站別</font></td>");
		}
	   	if (ospCheckFlag)
		{
			out.println("<td><font color='#990000'><em>下一站(委外加工站)</em></font></td>");
		}
	   	else
		{
			out.println("<td><font color='#990000'>下一站</font></td>");
		}
	   	out.print("<td><font color='#990000'>狀態</font></td></TR>");   
	   	int k=0;
	   	String sqlEst = "";
	   	String fromEst = "";
	   	String whereEst = "";
	   	String orderEst = "";
	   	String defToMoveQty = "0"; // 2007/01/10 

      	//抓取系統日期  20090424 liling for 人工打入異動日期,預設系統日
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
      	String sqlOver=" SELECT  (overcompletion_tolerance_value / 100 + 1) "+
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

	   	int destStdDesc = 0; // 2007/02/07 避免重工工令無取得()
	   	//out.println("stdOpDesc="+stdOpDesc);
	   	if (stdOpDesc !=null && stdOpDesc.length()>0) destStdDesc = stdOpDesc.indexOf("目檢");    
	   
	   	if (UserRoles.indexOf("admin")>=0) // 若是管理員,可設定任一項目為特採
	   	{  
			sqlEst = " select YRA.PRIMARY_ITEM_ID, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM, WIPO.OPERATION_SEQUENCE_ID,  "+
        	        "       WIPO.PREVIOUS_OPERATION_SEQ_NUM, WIPO.NEXT_OPERATION_SEQ_NUM, "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
					"       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION, YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID, "+
					"       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP "+
					"       ,YRA.RES_MACHINE_WKHOUR_OP";//機器工時,add by Peggy 20120315
		  	fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA, BOM_OPERATION_SEQUENCES BOS  ";
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
			sqlEst = " select YRA.PRIMARY_ITEM_ID, YRA.RUNCARD_QTY, YRA.RUNCAD_ID, YRA.RUNCARD_NO, WIPO.OPERATION_SEQ_NUM, WIPO.OPERATION_SEQUENCE_ID,  "+
        	      	"       WIPO.PREVIOUS_OPERATION_SEQ_NUM, WIPO.NEXT_OPERATION_SEQ_NUM, "+overValue1+"*YRA.RUNCARD_QTY as OVER_VALUE, "+
					"       YRA.QTY_IN_QUEUE, to_char(to_date(YRA.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE,  "+
					"       BOS.OPERATION_DESCRIPTION,YRA.QTY_IN_TOMOVE, YRA.STATUS, YRA.ORGANIZATION_ID, "+
					"       YRA.QTY_IN_INPUT, YRA.RES_WKCLASS_OP, YRA.RES_WKHOUR_OP, YRA.RES_MACHINE_OP, YRA.RES_EMPLOYEE_OP, NVL(YRA.QTY_IN_SCRAP,0) as QTY_IN_SCRAP "+
					"       ,YRA.RES_MACHINE_WKHOUR_OP"; //機器工時,add by Peggy 20120315
		    fromEst = "  from WIP_OPERATIONS WIPO ,YEW_RUNCARD_ALL YRA, BOM_OPERATION_SEQUENCES BOS  ";
		    whereEst = "  where YRA.PREVIOUS_OP_SEQ_NUM >= 0 "+ 
			      	   "    and WIPO.WIP_ENTITY_ID =YRA.WIP_ENTITY_ID "+
					   //" and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID  "+			// Update By Kerwin		
				       "    and WIPO.WIP_ENTITY_ID= "+entityId+" and YRA.DEPT_NO = '"+userMfgDeptNo+"' "+
					   "    and STATUSID = '"+frStatID+"' "+
				       "    and YRA.OPERATION_SEQ_NUM="+operSeqNum+" ";  // 2006/12/01 For Batch 作業
			orderEst = "  order by YRA.RUNCAD_ID";	
			if (jobType==null || jobType.equals("1")) // 標準工單/(discrete job)
		    {	
				whereEst = whereEst+" and BOS.OPERATION_SEQUENCE_ID=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID=YRA.OPERATION_SEQ_ID ";	
			} 
			else 
			{
				// 非標準工單(rework) Job)
				whereEst = whereEst+" and YRA.STANDARD_OP_ID = WIPO.STANDARD_OPERATION_ID and BOS.OPERATION_SEQUENCE_ID(+)=WIPO.OPERATION_SEQUENCE_ID and WIPO.OPERATION_SEQUENCE_ID IS NULL ";
			}
			sqlEst = sqlEst + fromEst + whereEst + orderEst;		
		}
	   	//out.println(sqlEst); 
		String keydownlink=""; //add by Peggy 20120315
       	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery(sqlEst);	   
	   	while (rs.next())
	   	{
	    	runcardQty=rs.getString("RUNCARD_QTY");
	   
	      	// 2007/01/10 如為後段工令,且無下一站,則移站數=流程卡數
		  	if (woType.equals("3"))   
		  	{ 
		    	if (stdOpDesc!=null && stdOpDesc.indexOf("目檢")>=0)
	         	{  
		       		defToMoveQty = rs.getString("RUNCARD_QTY"); // 目檢站,預設為流程卡數
			 	} 
				else 
				{ 
			    	defToMoveQty = rs.getString("QTY_IN_TOMOVE");  // 
				}
		  	}
		  	else 
			{ 
				defToMoveQty = rs.getString("QTY_IN_TOMOVE");  
			} 
		  // 2007/01/10 如為後段工令,且無下一站,則移站數=流程卡數
	   
			overValue = rs.getString("OVER_VALUE");
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
			} 
			else if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) out.println("checked"); //第一筆給定生產日期即設定欲結轉  
			if (rowLength==1) out.println("checked >"); 	else out.println(" >");		
			out.println("</div></a></TD>");
			out.println("<TD nowrap>"+rs.getString("RUNCAD_ID")+"</TD>");		
			out.println("<TD nowrap>"+rs.getString("RUNCARD_NO")+"</TD>");
			out.println("<TD nowrap>"+rs.getString("RUNCARD_QTY")+"</TD>");
			out.print("<TD nowrap><INPUT TYPE='button' value='Set' onClick='setSubmitQtyToMove("+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")'></TD>");     // 按鈕 Set
			out.print("<TD nowrap>"); // 移站數量	(良品數)	
			keydownlink ="setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
			if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
			{ 
				//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+queueQty+"' onfocus=this.select() size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
				out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+queueQty+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">"); 
			} 
			else 
			{ 
		    	if (rs.getString("QTY_IN_TOMOVE")==null)
				{
			    	//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' onfocus=this.select() size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");  
					out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
				}	
			  	else 
				{
					//out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+defToMoveQty+"' onfocus=this.select() size=5 onKeyDown=setTabNext('1',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='QUEUEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+defToMoveQty+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">");
				}
			}				  
			out.println("</TD>");  // 移站數量(良品數)
			out.print("<TD nowrap>"); // 報廢數量
			keydownlink ="setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
		  	if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		  	{ 
				//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+scrapQty+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
				out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+scrapQty+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">"); 
			}
		  	else 
			{ 
		    	if (rs.getString("QTY_IN_SCRAP")==null || rs.getString("QTY_IN_SCRAP").equals("0"))
				{
			    	//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">"); 
				}
			    else
				{
					//out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown=setTabNext('10',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='SCRAPQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_SCRAP")+"' onfocus=this.select() size=5 onKeyDown="+keydownlink+">"); 
				}
			}
			out.println("</TD>");
			out.print("<TD nowrap>"); // 投入數量(處理數)	
			keydownlink ="setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";		 
			if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
			{ 
		 		//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+inputQty+"' size=5 readonly class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");		 
				out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+inputQty+"' size=5 readonly class='koko' onKeyDown="+keydownlink+">");		 
	    	}
			else 
			{ 
		    	if (rs.getString("QTY_IN_INPUT")==null || rs.getString("QTY_IN_INPUT").equals("0"))
				{
			    	//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 readonly class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");  				
					out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_QUEUE")+"' size=5 readonly class='koko' onKeyDown="+keydownlink+">");	
				}
			  	else
				{ 
			    	//out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_INPUT")+"' size=5 readonly class='koko' onKeyDown=setTabNext('2',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");	
					out.print("<input name='INPUTQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("QTY_IN_INPUT")+"' size=5 readonly class='koko' onKeyDown="+keydownlink+">");	
				}					
			}				  
			out.println("</TD>");  // 投入數量(處理數)
		
			//班別,是否?自動依處理時間判段所屬班別_起
			out.println("<TD nowrap>");
		    try
            {   				 
				//-----取班別資訊
				keydownlink ="setTabNext('3',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";		 
		        Statement stateWClass=con.createStatement();
			    String sqlWClass = " select WKCLASS_CODE, WKCLASS_NAME||'('||WKCLASS_DESC||')' from APPS.YEW_MFG_WORKCLASS where WORKCLASS_TYPE='1'";
                ResultSet rsWClass =stateWClass.executeQuery(sqlWClass);
		        comboBoxBean.setRs(rsWClass);
				if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
				{ 
		        	comboBoxBean.setSelection(wkClass);
				}
				else 
				{ 
					//add by Peggy 20120410
					if (rs.getString("res_wkclass_op") ==null || rs.getString("res_wkclass_op").equals(""))
					{
						comboBoxBean.setSelection(wkClass);
					}
					else
					{
						comboBoxBean.setSelection(rs.getString("res_wkclass_op"));	
					}
				}				   
	            comboBoxBean.setFieldName("WKCLASS"+rs.getString("RUNCAD_ID"));	
				comboBoxBean.setOnChangeJS(keydownlink);
                out.println(comboBoxBean.getRsString());
		        rsWClass.close();   
				stateWClass.close();			
            } //end of try		 
            catch (Exception e) 
			{ 
				out.println("Exception WorkClass:"+e.getMessage()); 
			}
			out.println("</TD>");
		
			//製程工時增加機器工時,modify by Peggy 20120313
			if (work_machine)
			{
				out.println("<TD nowrap>");
				keydownlink = "setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
				if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
				{ 
					//out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty_machine+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty_machine+"' size=5 onKeyDown="+keydownlink+">"); 
				}
				else 
				{ 
					if (rs.getString("RES_MACHINE_WKHOUR_OP")==null)
					{
						//out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");  
						out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">"); 
					}
					else
					{ 
						//out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown=setTabNext('4',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
						out.print("<input name='RESOURCEQTY_MACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_WKHOUR_OP")+"' size=5 onKeyDown="+keydownlink+">"); 
					}
				}				   
				out.println("</TD>");	
			}
			
			//製程工時改為人工工時,modify by Peggy 20120313
			if (work_person)
			{
				out.println("<TD nowrap>");
				keydownlink = "setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")";
				if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
				{ 
					//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty+"' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resourceQty+"' size=5 onKeyDown="+keydownlink+">"); 
				}
				else 
				{ 
					if (rs.getString("RES_WKHOUR_OP")==null)
					{
						//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");  
						out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">"); 
					}
					else
					{ 
						//out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_WKHOUR_OP")+"' size=5 onKeyDown=setTabNext('3',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
						out.print("<input name='RESOURCEQTY"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_WKHOUR_OP")+"' size=5 onKeyDown="+keydownlink+">");
					}
				}				   
				out.println("</TD>");	
			} 
			
			//異動日期_起 20090424 liling update
			out.println("<TD nowrap>");
			keydownlink = "setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")"; 
		    if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		    { 
				//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resEmployee+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
				out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resEmployee+"' size=7 onKeyDown="+keydownlink +">"); 
			}
		    else 
			{ 
		    	if (rs.getString("RES_EMPLOYEE_OP")==null)
				{
			    	//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+systemDate+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+")>");  
					out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+systemDate+"' size=7 onKeyDown="+keydownlink +">"); 
				}
			    else
				{
					//out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_EMPLOYEE_OP")+"' size=6 onKeyDown=setTabNext('5',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='RESEMPLOYEE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_EMPLOYEE_OP")+"' size=7 onKeyDown="+keydownlink +">"); 
				}
			}
			out.println("</TD>");
		
			// 機台編號_起
		    out.println("<TD nowrap>");
			keydownlink = "setTabNext('7',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+","+'"'+rs.getString("RES_MACHINE_WKHOUR_OP")+'"'+")"; 
		    if (runCardID==rs.getString("RUNCAD_ID") || runCardID.equals(rs.getString("RUNCAD_ID"))) // 若是處理項次,則予此次給定comments
		    { 
				//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resMachine+"' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
				out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+resMachine+"' size=5 onKeyDown="+keydownlink+">");
			}
		    else 
			{ 
		    	if (rs.getString("RES_MACHINE_OP")==null)
				{
			    	//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>");  
					out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='' size=5 onKeyDown="+keydownlink+">");
				}
			    else
				{
					//out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown=setTabNext('6',"+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARDID="+rs.getString("RUNCAD_ID")+"&EXPAND="+expand+'"'+","+'"'+rs.getString("RUNCAD_ID")+'"'+","+'"'+rs.getString("QTY_IN_QUEUE")+'"'+","+'"'+rs.getString("QTY_IN_SCRAP")+'"'+","+'"'+rs.getString("QTY_IN_INPUT")+'"'+","+'"'+rs.getString("RES_WKCLASS_OP")+'"'+","+'"'+rs.getString("RES_WKHOUR_OP")+'"'+","+'"'+rs.getString("RES_MACHINE_OP")+'"'+","+'"'+rs.getString("RES_EMPLOYEE_OP")+'"'+","+'"'+overValue+'"'+","+'"'+runcardQty+'"'+","+'"'+woType+'"'+","+'"'+destStdDesc+'"'+","+'"'+prevOpSeqNo+'"'+")>"); 
					out.print("<input name='RESMACHINE"+rs.getString("RUNCAD_ID")+"' type='text' value='"+rs.getString("RES_MACHINE_OP")+"' size=5 onKeyDown="+keydownlink+">");
				}
			}
			out.println("</TD>");

			out.println("<TD nowrap>"+prevOpDesc+"</TD>");
			if (dirOspFlag)	
			{
				out.println("<TD nowrap><font color='#990000'><em>"+rs.getString("OPERATION_SEQ_NUM")+"("+dirOSPResDesc+")"+"</em></font></TD>");
			}
			else 
			{
				out.println("<TD nowrap><font color='#0000FF'>"+currOpDesc+"</font></TD>");
			}
			if (ospCheckFlag)
			{
				out.print("<TD nowrap><font color='#990000'><em>"+rs.getString("NEXT_OPERATION_SEQ_NUM")+"("+resourceDesc+")"+"</em></font></TD>");
			}
			else
			{
				out.print("<TD nowrap>"+nextOpDesc+"</TD>");
			}
			out.print("<TD nowrap>"+rs.getString("STATUS")+"</TD>");
			out.println("</TR>");
%>

<%
			// ############################  WIP Resource Operation API資料取得 _迄 ##############################
        	// 20091110 Marvie Add : Performance Issue
        	if (k==0)
			{		  
           		try
           		{
					String sqlOPRes="";
              		if (jobType==null || jobType.equals("1"))
              		{
						/*
                    	sqlOPRes =	" select a.RESOURCE_SEQ_NUM, a.RESOURCE_ID, a.USAGE_RATE_OR_AMOUNT, a.BASIS_TYPE, "+
				             	 	"        a.SCHEDULE_FLAG, a.AUTOCHARGE_TYPE, a.STANDARD_RATE_FLAG, a.SCHEDULE_SEQ_NUM, "+
							  		"        a.PRINCIPLE_FLAG, a.ASSIGNED_UNITS, "+
				              		"        b.UNIT_OF_MEASURE, b.AUTOCHARGE_TYPE "+
									"        ,b.RESOURCE_TYPE"+ //add by Peggy 20120313
                              		" from BOM_OPERATION_RESOURCES a, BOM_RESOURCES b, BOM_DEPARTMENT_RESOURCES c, BOM_OPERATION_SEQUENCES d "+
                              		" where a.RESOURCE_ID = b.RESOURCE_ID and b.RESOURCE_ID = c.RESOURCE_ID "+
					          		"   and c.DEPARTMENT_ID = d.DEPARTMENT_ID "+
					          		"   and a.OPERATION_SEQUENCE_ID = d.OPERATION_SEQUENCE_ID "+
					          		"   and d.OPERATION_SEQUENCE_ID = '"+rs.getString("OPERATION_SEQUENCE_ID")+"' ";
						*/
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
		            	sqlOPRes =  " select c.RESOURCE_SEQ_NUM, c.RESOURCE_ID, c.USAGE_RATE_OR_AMOUNT, c.BASIS_TYPE, c.SCHEDULE_FLAG, c.AUTOCHARGE_TYPE, c.STANDARD_RATE_FLAG, c.SCHEDULE_SEQ_NUM, "+
							        "        c.PRINCIPLE_FLAG, c.ASSIGNED_UNITS, d.UNIT_OF_MEASURE, d.AUTOCHARGE_TYPE "+
									"        ,d.RESOURCE_TYPE"+ //add by Peggy 20120313
			               			" from YEW_RUNCARD_ALL a, WIP_OPERATION_RESOURCES b, "+
				  			        "      BOM_OPERATION_RESOURCES c, BOM_RESOURCES d "+
							        " where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and b.RESOURCE_ID = c.RESOURCE_ID and c.RESOURCE_ID = d.RESOURCE_ID "+
							        " and a.WIP_ENTITY_ID = "+entityId+" "+
							        " and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' "+
							        " and a.NEXT_OP_SEQ_NUM = b.OPERATION_SEQ_NUM "+
							        " and b.RESOURCE_SEQ_NUM != 10 "+   // 10為固定人工資源
							        " and d.ORGANIZATION_ID = '"+organizationId+"' "; 
			        	if (runCardID==null || runCardID.equals("0")) sqlOPRes = sqlOPRes +" and a.RUNCARD_NO ='"+rs.getString("RUNCARD_NO")+"' ";
                        else  sqlOPRes = sqlOPRes + " and a.RUNCAD_ID ='"+rs.getString("RUNCAD_ID")+"' " ;					
		           	}
					//out.println("sqlOPRes="+sqlOPRes);		
              		Statement stateOPRes=con.createStatement();
              		ResultSet rsOPRes=stateOPRes.executeQuery(sqlOPRes);
              		//if (rsOPRes.next())
					int icnt=0;
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
						arrMFGResourceBean.setArray2DString(r);
              		}
              		rsOPRes.close();
              		stateOPRes.close();	   
          		} //end of try
          		catch (Exception e)
          		{
             		out.println("Exception Runcard Res:"+e.getMessage());
          		}	   
        	// 20091110 Marvie Add : Performance Issue
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
                r[k][12]=rs.getString("RUNCAD_ID");   //20091110 RUNCARD_ID / NO 每一批不同,故不能與第一批一樣
				r[k][13]=r[0][13];
				r[k][14]=r[0][14];   
				r[k][15]=r[0][15];
				r[k][16]=r[0][16];
                r[k][17]=rs.getString("RUNCARD_NO");
				r[k][18]=r[0][18];
				r[k][19]=r[0][19];   
				r[k][20]=r[0][20];
				arrMFGResourceBean.setArray2DString(r);
			}  
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
		 	arrMFGRCExpTransBean.setArray2DString(b);
		 	k++;
	   	}    	   	   	 
	   	out.println("</TABLE>");
	   	statement.close();
       	rs.close();  
		
		if (runCardID !=null && scrapQty!=null && !scrapQty.equals(""))
	    {
	    	String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_SCRAP=?, QTY_AC_SCRAP=? ,LAST_UPDATED_BY = ?, LAST_UPDATE_DATE=to_char(SYSDATE,'yyyymmddhh24miss')"+
		                 " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
	        PreparedStatement pstmt=con.prepareStatement(sql);  
            pstmt.setString(1,scrapQty);     // 本次報廢數量更新
			pstmt.setString(2,scrapQty);     // 本次User報廢數量更新		  
			pstmt.setInt(3,Integer.parseInt(userMfgUserID));     //add by peggy 20120315  
		    pstmt.executeUpdate(); 
            pstmt.close();
		} // End of if 報廢數寫入   
		
	    if (runCardID !=null && queueQty!=null && !queueQty.equals("")) // (良品數)
	    {
			if (jobType.equals("1"))
		  	{
	        	String sql = "update APPS.YEW_RUNCARD_ALL set QTY_IN_TOMOVE=?, PREVIOUS_OP_SEQ_ID=?, NEXT_OP_SEQ_ID=?, QTY_IN_INPUT=?,RES_EMPLOYEE_OP=?,RES_WKHOUR_OP=?,RES_MACHINE_WKHOUR_OP=?,RES_WKCLASS_OP =? ,LAST_UPDATED_BY = ?, LAST_UPDATE_DATE=to_char(SYSDATE,'yyyymmddhh24miss')"+
		                  " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
	         	PreparedStatement pstmt=con.prepareStatement(sql);  
             	pstmt.setString(1,queueQty);     // 本次移站數量更新
		     	pstmt.setInt(2,Integer.parseInt(prevOpSeqID));  // 本次前一站ID更新
		     	pstmt.setInt(3,Integer.parseInt(nextOpSeqID));  // 本次下一站ID更新
			 	pstmt.setFloat(4,Float.parseFloat(queueQty)+Float.parseFloat(scrapQty));     // 本次處理數量更新
             	pstmt.setString(5,resEmployee);  //異動日期更新
             	pstmt.setString(6,resourceQty);  //人工工時,add by Peggy 20120313
             	pstmt.setString(7,resourceQty_machine);  //機器工時,add by Peggy 20120313
             	pstmt.setString(8,wkClass);  //班別,add by Peggy 20120313
				pstmt.setInt(9,Integer.parseInt(userMfgUserID));     //add by peggy 20120315  
		     	pstmt.executeUpdate(); 
             	pstmt.close();
		  	} 
			else if (jobType.equals("2")) // 若為非標準型工單(重工工單),則不更新 Sequence ID
		    {
				String sql = " update APPS.YEW_RUNCARD_ALL set QTY_IN_TOMOVE=? ,RES_EMPLOYEE_OP=?,RES_WKHOUR_OP=?,RES_MACHINE_WKHOUR_OP=? ,RES_WKCLASS_OP =?,LAST_UPDATED_BY = ?, LAST_UPDATE_DATE=to_char(SYSDATE,'yyyymmddhh24miss')"+
		                         " where WO_NO='"+woNo+"' and RUNCAD_ID='"+runCardID+"' ";
	            PreparedStatement pstmt=con.prepareStatement(sql);  
                pstmt.setString(1,queueQty);        // 本次移站數量更新	
                pstmt.setString(2,resEmployee);     // 異動日期更新         
             	pstmt.setString(3,resourceQty);  //人工工時,add by Peggy 20120313
             	pstmt.setString(4,resourceQty_machine);  //機器工時,add by Peggy 20120313
             	pstmt.setString(5,wkClass);  //班別,add by Peggy 20120313
				pstmt.setInt(6,Integer.parseInt(userMfgUserID));     //add by peggy 20120315  
		        pstmt.executeUpdate(); 
                pstmt.close();
			} 
		   // %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _起
		    for (int rr=0;rr<r.length;rr++)
			{
				if (runCardID==r[rr][12] || runCardID.equals(r[rr][12]) )
			  	{ 
					String sqlResRowID =" select a.ROWID, b.ORGANIZATION_CODE "+
				                       " from WIP_OPERATION_RESOURCES a, MTL_PARAMETERS b "+
				                       " where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.WIP_ENTITY_ID="+entityId+" "+
									   "   and a.OPERATION_SEQ_NUM='"+r[rr][13]+"' and (a.RESOURCE_SEQ_NUM='"+r[rr][0]+"' or  a.RESOURCE_SEQ_NUM='"+r[rr][18]+"')"; //modify by Peggy 20120313
	               	Statement stateResRowID=con.createStatement();
                   	ResultSet rsResRowID=stateResRowID.executeQuery(sqlResRowID);
				   	if (rsResRowID.next())
				   	{
				    	String groupId = "0",respID = "0"; 
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
						 
						if (intResExist || rCardResExt || resResExist) 
						{  
						} // 若該流程卡(r[rr][17])已經回報過工時資源檔,則不再寫一次 } //20090424 update transacion_date不抓 sysdate
						else 
						{
							String resTxnSql=" insert into APPS.YEW_RUNCARD_RESTXNS(WO_NO, RUNCARD_NO, QTY_IN_INPUT, CREATED_BY, LAST_UPDATED_BY, "+
						                     " OPERATION_SEQ_NUM, AUTOCHARGE_TYPE, WKCLASS_CODE, WKCLASS_NAME, WORK_EMPLOYEE, WORK_EMPID, WORK_MACHINE, WORK_MACHNO, WIP_ENTITY_ID, QTY_AC_SCRAP , TRANSACTION_DATE ";
							if (work_person) resTxnSql += ", RESOURCE_SEQ_NUM, RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM";
							if (work_machine) resTxnSql += ",MACHINE_RESOURCE_SEQ_NUM,MACHINE_RESOURCE_ID,MACHINE_TRANSACTION_QUANTITY,MACHINE_TRANSACTION_UOM ";//add by Peggy 20120313
							resTxnSql +=     " )"+
							                 " values ( '"+woNo+"', '"+r[rr][17]+"', "+inputQty+", '"+userMfgUserID+"', '"+userMfgUserID+"', "+															              
							                 " '"+Integer.parseInt(r[rr][13])+"', 2 , '"+wkClass+"', 'N/A', '"+resEmployee+"', '0','"+resMachine+"','N/A', '"+entityId+"', '"+scrapQty+"','"+resEmployee+"'||'"+sTime+"' ";	                              
							if (work_person)  resTxnSql += ", "+(r[rr][0].equals("")?null:r[rr][0])+", "+(r[rr][1].equals("")?0:Integer.parseInt(r[rr][1]))+", "+resourceQty+", '"+r[rr][10]+"'";  //add by Peggy 20120313
							if (work_machine) resTxnSql += ", "+(r[rr][18].equals("")?null:r[rr][18])+", "+(r[rr][19].equals("")?0:Integer.parseInt(r[rr][19]))+", "+resourceQty_machine+", '"+r[rr][20]  +"'"; //add by Peggy 20120313
							resTxnSql += ")";
							//out.println("resTxnSql="+resTxnSql);
						    PreparedStatement pstmtResTxn=con.prepareStatement(resTxnSql);                        
		                    pstmtResTxn.executeUpdate(); 
                            pstmtResTxn.close(); 
						   
							if (!resourceQty.equals("") && Float.parseFloat(resourceQty)>0) // if (回報工時>0才寫Interface ) 2007/02/12
							{
					       		String resSql=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME, "+
						                      " PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, ORGANIZATION_ID, ORGANIZATION_CODE, WIP_ENTITY_ID, ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM, "+
								              " RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, WIP_ENTITY_NAME,  PRIMARY_ITEM_ID, ATTRIBUTE2 ) "+
									          " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
									          "         1, 1, 1, '"+organizationId+"', '"+rsResRowID.getString("ORGANIZATION_CODE")+"', '"+entityId+"', "+
											  "         1, to_date('"+resEmployee+"'||'"+sTime+"','yyyymmddhh24miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][0])+", "+
											  "         "+Integer.parseInt(r[rr][1])+", "+resourceQty+", '"+r[rr][10]+"', 2 , "+
										      "         '"+woNo+"',"+r[rr][16]+", '"+r[rr][17]+"' ) ";		                              
								//out.println("resSql="+resSql);
						        PreparedStatement pstmtRes=con.prepareStatement(resSql);                        
		                        pstmtRes.executeUpdate(); 
                                pstmtRes.close();
							}
							if (!resourceQty_machine.equals("") && Float.parseFloat(resourceQty_machine)>0) //add by Peggy 20120313
							{
					       		String resSqla=" insert into WIP_COST_TXN_INTERFACE(LAST_UPDATE_DATE, LAST_UPDATED_BY, CREATION_DATE, CREATED_BY, CREATED_BY_NAME, LAST_UPDATED_BY_NAME,PROCESS_PHASE, PROCESS_STATUS, TRANSACTION_TYPE, "+
						                      " ORGANIZATION_ID, ORGANIZATION_CODE, WIP_ENTITY_ID, ENTITY_TYPE, TRANSACTION_DATE, OPERATION_SEQ_NUM, RESOURCE_SEQ_NUM,RESOURCE_ID, TRANSACTION_QUANTITY, TRANSACTION_UOM, AUTOCHARGE_TYPE, WIP_ENTITY_NAME,  PRIMARY_ITEM_ID, ATTRIBUTE2 ) "+
									          " values( SYSDATE, "+Integer.parseInt(userMfgUserID)+", SYSDATE, "+Integer.parseInt(userMfgUserID)+", UPPER('"+userMfgUserName+"'), UPPER('"+userMfgUserName+"'), "+
								              "         1, 1, 1, '"+organizationId+"', '"+rsResRowID.getString("ORGANIZATION_CODE")+"', '"+entityId+"', 1, to_date('"+resEmployee+"'||'"+sTime+"','yyyymmddhh24miss'), "+Integer.parseInt(r[rr][13])+", "+Integer.parseInt(r[rr][18])+", "+
											  "         "+Integer.parseInt(r[rr][19])+", "+resourceQty_machine+", '"+r[rr][20]+"', 2 , '"+woNo+"',"+r[rr][16]+", '"+r[rr][17]+"' ) ";		                              
								//out.println("resSqla="+resSqla);
						        PreparedStatement pstmtResa=con.prepareStatement(resSqla);                        
		                        pstmtResa.executeUpdate(); 
                                pstmtResa.close();
							}
						} 
				 	}
					rsResRowID.close();
					stateResRowID.close();	  
			  	}
			}		  
		  	// %%%%%%%%%%%%%%%%%%%%%%% 工時回報 WIP Operation Resource API %%%%%%%%%%%%%%%%%%%% _迄
        }
    }	 //end of try
    catch (Exception e)
    {
    	out.println("Exception 工時回報:"+e.getMessage());
    }
    String a[][]=arrMFGRCExpTransBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
    if (a!=null) 
	{		  
		for (int k=0;k<a.length;k++)
		{  
			if (a[0][2] !=null && !a[0][2].equals(""))
			{
				chkMoveQtyFlag = "Y";   
			} 
			else 
			{
			}
		} 
	}	
	else 
	{
		chkMoveQtyFlag="N"; //未給定任何數值
	}	
    %> 
 </font>      
  </tr>       
</table>
 
<% 
try
{
} //end of try
catch (Exception e)
{
	out.println("Exception Runcard:"+e.getMessage());
}	   
 
%>
<!--=============以下區段為取得判斷檢驗類型決定檢驗明細==========-->
<!--%@ include file="/jsp/include/TSIQCInspectLotBasicInfoPage.jsp"%-->
<!--=================================-->
<%
// if (woType.equals("3")) // 若是後段工令,則顯示date code 可修改
if (woType.equals("3") || woType.equals("5")) // 若是後段工令,則顯示date code 可修改 , 20140206加樣品
{   
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="97%" align="center" bordercolorlight="#FFFFFF"  border="0">
    <tr bgcolor="#CCCC99"> 
    <td colspan="8" width="8%"><font color="#000066"> Date Code:</font></td><td colspan="3"><font color="#000066"><input type="text" name="DATECODE" value="<%=dateCodeSet%>" size=8 ></font></td>
	</tr>
</table>
<%
}
%>
<BR>
<table align="left"><tr><td colspan="3">
 <strong><font color="#FF0000">執行動作-&gt;</font></strong> 
 <a name='#ACTION'>
 <%
try
{
	String sqlAction = "select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='999' " ;
	if (wipRelease && poReceiptOSP) //工令已Release且如有外包站確實設定為 PO Receipt的 OSP Chargr Type
	{  
		sqlAction = "select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' ";
	    if (!singLastOp) //  不為最後一站,則可執行Transfer
	    { 
	    	if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		   	{
		    	sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('023','021') order by x1.ACTIONID desc "; 	
		   	}
		   	else 
			{ //不為最後一站,則可執行Transfer
	        	sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('006','021') "; 	   
		    }
	    }
	    else 
		{  //  本站為最後一站且為委外加工站,則執行OSPProcess
	    	if (ospCheckFlag)  //下一站委外加工站,則選擇動作為OSPROCESS
		    { 
		    	sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('024','021') order by x1.ACTIONID desc "; 	
		    }
		    else 
			{ //為最後一站,則可執行Complete或Cancel(因為第一站即為最後一站)
				if (dirOspFlag) // 投產即為委外加工站
				{
					sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('024','021') order by 1 desc "; 
				} 
				else 
				{					   
	            	sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' and x2.ACTIONID in ('012','021') "; 	   
				}
		    }	           
	    }
	} 
	else  // End of else (wipRelease) //工令已Release
	{ // 給一個不會出現Result 的 SQL如下,避免Error
		sqlAction = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='ET' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"' "; 
%>
		<script language="javascript">
			alert("             您尚未釋出此工令!!!\n請先至Oracle設定工令狀態為Released\n             方能執行動作!");
		</script>		  
<%
	}	
    Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlAction);
   	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSCMfgRunCardTransfer.jsp?WO_NO="+woNo+"&RUNCARD_NO="+runCardNo+"&EXPAND="+expand+'"'+")'>");			  				  
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
	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='WO' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	rs.next();
	if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	{
    	if (!ospCheckFlag && !dirOspFlag) // 若本站及下一站皆不為委外加工站,則呼叫正常移站處理頁面_起
		{ 
%>
			<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setSubmit("../jsp/TSCMfgRCTransferMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>","確認流程卡投產移站?","<%=chkMoveQtyFlag%>",this.form.CHKBELOT.value,"<%=woType%>","<%=backEndIssFlag%>")'>
<%
		} 
		else 
		{
	    	if (dirOspFlag) // 投產即為委外加工站
			{ 
%>
				<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("../jsp/TSCMfgWoExpandMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>","確認執行移至委外加工站?","<%=chkMoveQtyFlag%>",this.form.CHKBELOT.value,"<%=woType%>")'>				 
<% 
			} 
			else if (ospCheckFlag) // 下一站為委外加工站
			{ 
%>
				<INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setOSPSubmit("../jsp/TSCMfgWoOSPMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>","確認執行移至委外加工站?","<%=chkMoveQtyFlag%>",this.form.CHKBELOT.value,"<%=woType%>")'> 
<%
			} 
			else
			{	
%>		  
		        <INPUT TYPE='button' NAME='submit2' value='Submit' onClick='setSubmit("../jsp/TSCMfgRCTransferMProcess.jsp?WO_NO=<%=woNo%>&RUNCARD_NO=<%=runCardNo%>","確認流程卡投產移站?","<%=chkMoveQtyFlag%>",this.form.CHKBELOT.value,"<%=woType%>","<%=backEndIssFlag%>")'>
<%
			}  
		} // 若下一站不為委外加工站,則呼叫正常移站處理頁面_迄
		out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>郵件通知<%
		 
		if (UserRoles.indexOf("admin")>=0) // 若是管理員模式,可設定手動給定報廢數量
	    { 
			out.println("<INPUT TYPE='checkBox' NAME='ADMINMODEOPTION' VALUE='YES'>");%>管理員模式<%
		} 
	} 
    rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	out.println("Exception Action:"+e.getMessage());
}
   %></a>
     </td>
    </tr>
  </table>
<!-- 表單參數 --> 
<INPUT type="hidden" SIZE=5 name="RUNCARD_NO" value="<%=runCardNo%>" readonly>
<INPUT type="hidden" SIZE=5 name="RUNCARDID" value="<%=runCardID%>" readonly>
<INPUT type="hidden" SIZE=5 name="OP_SEQ" value="<%=operSeqNum%>" readonly>
<INPUT type="hidden" SIZE=5 name="WOTYPE" value="<%=woType%>" readonly>
<INPUT type="hidden" SIZE=5 name="ALTERNATEROUTING" value="<%=alternateRouting%>" readonly>
<INPUT type="hidden" SIZE=5 name="CHKBELOT" value="<%=chkBELot%>" readonly>
<INPUT type="hidden" SIZE=5 name="ACCLOTQTY" value="<%=accLotQty%>" readonly>
<INPUT type="hidden" SIZE=5 name="DIRECTOSP" value="<%=directOSP%>" readonly>
<INPUT type="hidden" SIZE=5 name="SYSTEMDATE" value="<%=systemDate%>" readonly>
</FORM>
<script language="JavaScript" type="text/javascript" src="../JSP-bk/wz_tooltip.js" ></script>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
