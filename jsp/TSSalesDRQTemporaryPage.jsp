<!-- 20150416 Peggy,java script function:subWindowOrderTypeFind加customerid參數-->
<!-- 20150417 Peggy,line qty修改檢查spq及moq,CRD,REQUEST DATE檢查日期格式-->
<!-- 20150507 Peggy,Sample Order只須檢查SPQ-->
<!-- 20150519 Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20150908 Peggy,sample區yew交期只要大於系統日即可-->
<!-- 20151008 Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!-- 20151026 Peggy,get_ssd  arrow ssd+運輸天數>=crd -->
<!-- 20160219 Peggy,上海內銷012 end customer設為必填-->
<!-- 20160308 Peggy,for sample order add direct_ship_to_cust column-->
<!-- 20160318 Peggy,客戶單價有定義時,自動帶入-->
<!-- 20161228 Peggy,ITEM STATUS=NRND FOR SAMPLE ALERT-->
<!-- 20170216 Peggy,add sales region for bi-->
<!-- 20170425 Peggy,market group=AU & product package=SMA,當型號有assign到YEW,必須判002,否則依預設工廠別顯示(與CELINE討論)-->
<!-- 20170511 Peggy,add end cust ship to id-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<!-- 20180518 Peggy,TSCC內銷012,022,外銷002客戶8103 RFQ必須輸入END CUSTOMER-->
<!-- 20190225 Peggy,add End customer part name-->
<%@ page language="java" import="java.sql.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Assign</title>
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
.gogo{
    border:0;
	color:#FF0000;
	background-color:#99CCFF;font-family: Tahoma,Georgia; font-size: 12px
}
  .style1 { font-family: Tahoma,Georgia; font-size: 12px }	
  .style2 { font-family: Tahoma,Georgia; font-size: 11px }
  .style2 { font-family: Tahoma,Georgia; font-size: 10px }	  
</STYLE>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="rfqArray2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeanss" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal")  gfPop.fHideCal();
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

document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") gfPop.fHideCal();
}

function submitCheck(URL,ms1,ms2,ms3,ms4)
{     
	if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  	{ 
   		flag=confirm(ms1);      
   		if (flag==false)  return(false);
  	} 
	//add by Peggy 20120112 check 廠別是否正確
	if (document.MYFORM.ACTIONID.value != "013")
	{
		var num =1;
		var autocreateflag = document.MYFORM.AUTOCREATE_FLAG.value;
		var crd="",request_date="",year="",mon ="",dd = "";
		if (document.MYFORM.ADDITEMS.length!= undefined)
		{
			num=document.MYFORM.ADDITEMS.length;
		}
		var myDate = document.MYFORM.maxDate.value;
		var myDate1 = document.MYFORM.maxDate1.value;
		for (var i=0;i<num;i++)
		{   
			//add by Peggy 20150417,check qty是否為spq倍數
			if ((Math.round((eval(document.MYFORM.elements["MONTH"+i+"-3"].value)*1000)) % Math.round((eval(document.MYFORM.elements["MONTH"+i+"-11"].value)*1000)))>0)
			{
				alert("The order qty must be a multiple of the SPQ:"+document.MYFORM.elements["MONTH"+i+"-11"].value+"k");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-3"].focus();
				return (false);
			}
			//add by Peggy 20150507,SAMPLE不用檢查MOQ
			if (document.MYFORM.SAMPLEORDER.value =="N" && Math.round((eval(document.MYFORM.elements["MONTH"+i+"-3"].value)*1000)) < Math.round((eval(document.MYFORM.elements["MONTH"+i+"-12"].value)*1000)))
			{
				alert("The order qty must be greater than MOQ:"+document.MYFORM.elements["MONTH"+i+"-12"].value+"k");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-3"].focus();
				return (false);
			}			
			
			//add by Peggy 20150417 check crd format
			crd =document.MYFORM.elements["MONTH"+i+"-5"].value;
			crd = crd.replace(/\u00A0/g, "");
			if (crd.length!=0 && crd.length!=8)
			{
				alert(" CRD date format error,must be yyyymmdd!");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-5"].focus();
				return  false;
			}
			else if (crd.length ==8)
			{
				year = crd.substring(0,4);
				mon = crd.substring(4,6);
				dd = crd.substring(6,8);	
				if (year.substring(0,2) != 20)
				{
					alert("The year is invalid on CRD field!!! ");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-5"].focus();
					return false;
				}
				else if (mon <1 || mon>12)
				{
					alert("The month is invalid on CRD field!!! ");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-5"].focus();
					return false;
				}
				else 
				{
					if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
					|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
					|| (isLeapYear(year) && mon == 2 && dd>29)
					|| (!isLeapYear(year) && mon == 2 && dd>28))
					{
						alert("The date is invalid on CRD field!!! ");
						document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
						document.MYFORM.elements["MONTH"+i+"-5"].focus();
						return false;
					}
				}
				//add by Peggy 20210308
				if (eval(crd) < eval(document.MYFORM.SYSDATE.value))
				{
					alert("CRD must be greater than or equals the today!");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-5"].focus();
					return false;					
				}				
			}			
			
			//add by Peggy 20150417 check request date format
			request_date=document.MYFORM.elements["MONTH"+i+"-7"].value;
			if (request_date.length!=8)
			{
				alert(" Request date format error,must be yyyymmdd!");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-7"].focus();
				return  false;
			}
			else
			{
				year = request_date.substring(0,4);
				mon = request_date.substring(4,6);
				dd = request_date.substring(6,8);	
				if (year.substring(0,2) != 20)
				{
					alert("The year is invalid on Request Date! ");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-7"].focus();
					return false;
				}
				else if (mon <1 || mon>12)
				{
					alert("The month is invalid on Request Date! ");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-7"].focus();
					return false;
				}
				else 
				{
					if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
					|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
					|| (isLeapYear(year) && mon == 2 && dd>29)
					|| (!isLeapYear(year) && mon == 2 && dd>28))
					{
						alert("The date is invalid on Request Date! ");
						document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
						document.MYFORM.elements["MONTH"+i+"-7"].focus();
						return false;
					}
				}				
			}			
			
			var plant =document.MYFORM.elements["MONTH"+i+"-10"].value;
			if (plant =="002" && document.MYFORM.SALESAREANO.value=="020")
			{
				if (document.MYFORM.elements["MONTH"+i+"-7"].value <= myDate1 && document.MYFORM.elements["MONTH"+i+"-7"].value != "")
				{
					alert("The Request Date must be greater than leadtime "+myDate1);
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-7"].focus();
					return (false);
				}
			}
			else
			{
				if (document.MYFORM.elements["MONTH"+i+"-7"].value <= myDate && document.MYFORM.elements["MONTH"+i+"-7"].value != "")
				{
					alert("The Request Date must be greater than leadtime "+myDate);
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-7"].focus();
					return (false);
				}
			}		
			var isExit = false;
			for (var j = 0; j < document.MYFORM.PLANTLIST.options.length; j++) 
			{	
				if (document.MYFORM.PLANTLIST.options[j].value == plant)
				{
					isExit = true;
					break;
				}
			}	
			if (!isExit)
			{
				alert("PLANT CODE:"+plant+" is not available!!"); 
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-10"].focus();
				return(false);
			}
			
			//add by Peggy 20120323
			var isAvailable = false;
			var ordertype =document.MYFORM.elements["MONTH"+i+"-15"].value;
			if (autocreateflag=="Y" || (ordertype != "N/A" && ordertype != "" && ordertype != null))
			{
				for (var k = 0; k < document.MYFORM.ORDERLIST.options.length; k++) 
				{	
					if (document.MYFORM.ORDERLIST.options[k].value == (plant+"-"+ordertype))
					{
						isAvailable = true;
						break;
					}
					//alert(document.MYFORM.ORDERLIST.options[k].value + "***"+(plant+"-"+ordertype));
				}	
				if (!isAvailable)
				{
					alert("Error!! The manufactory:"+plant+" does not use this order Type Code:"+ordertype+"!!"); 
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-15"].focus();
					return(false);
				}
				//add by Peggy 20120427
				if (ordertype != "1131" && (document.MYFORM.CURR.value =="TWD" || document.MYFORM.CURR.value =="NTD"))
				{
					alert("Line"+(i+1)+":The Order Type is not available!");
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-15"].focus();
					return (false);						
				}
			}
			if (ordertype=="1132" && document.MYFORM.SALES_GROUP_ID.value!="509")
			{
				alert("Line"+(i+1)+":This customer is not allowed to book 1132 order type!!");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-15"].focus();
				return (false);					
			}
			if (ordertype!="1132" && document.MYFORM.SALES_GROUP_ID.value=="509")
			{
				alert("Line"+(i+1)+":This customer must book 1132 order type!!");
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-15"].focus();
				return (false);					
			}			
			
			var isAvailable = false;
			var linetype =document.MYFORM.elements["MONTH"+i+"-16"].value;
			if (autocreateflag=="Y" || (ordertype != "N/A" && ordertype != "" && ordertype != null && linetype != "N/A" && linetype != "" && linetype != null))
			{
				for (var k = 0; k < document.MYFORM.LINETYPELIST.options.length; k++) 
				{	
					if (document.MYFORM.LINETYPELIST.options[k].value == (ordertype+"-"+linetype))
					{
						isAvailable = true;
						break;
					}
				}	
				if (!isAvailable)
				{
					alert("Error!! The order type:"+ordertype+" does not use this line type:"+linetype+"!!"); 
					document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.MYFORM.elements["MONTH"+i+"-16"].focus();
					return(false);
				}	
			}
			var lineFob =document.MYFORM.elements["MONTH"+i+"-17"].value;
			if (autocreateflag=="Y" && (lineFob == "N/A" || lineFob == "" ||lineFob == null))
			{
				alert("Please input the FOB value!!"); 
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.elements["MONTH"+i+"-17"].focus();
				return(false);
			}
			//add by Peggy 20140424
			if (document.MYFORM.ACTIONID.value=="002" && document.MYFORM.SALESAREANO.value=="001")
			{
				if (document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase().indexOf("FOB")>=0 || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="EX WORKS" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="EX-WORK" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="FCA TAIWAN"  || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="FCA TIANJIN" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="FCA YANGXIN XIAN"  || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="FCA I-LAN" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="C&F H.K." || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="EXW I-LAN" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()=="CIF H.K." )
				{
					if (document.MYFORM.elements["MONTH"+i+"-6"].value.toUpperCase()=="AIR(C)" || document.MYFORM.elements["MONTH"+i+"-6"].value.toUpperCase()=="SEA(C)")
					{
						if (document.MYFORM.elements["MONTH"+i+"-15"].value.toUpperCase()!="1214" || document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()!="EX WORKS")  //1214 EX WORKS排外 ADD BY PEGGY 20220105
						{
							alert("Line"+(i+1)+":Shipping Method("+document.MYFORM.elements["MONTH"+i+"-6"].value.toUpperCase()+") not match FOB Term("+document.MYFORM.elements["MONTH"+i+"-17"].value.toUpperCase()+")("+document.MYFORM.elements["MONTH"+i+"-15"].value.toUpperCase()+")!");   
							document.MYFORM.elements["MONTH"+i+"-6"].focus();
							return(false);
						}
					}
				}
			}
			//add by Peggy 20170220
			if (document.MYFORM.TSCUSTOMERID.value=="14980" || document.MYFORM.TSCUSTOMERID.value=="15540")
			{
				if (document.MYFORM.elements["MONTH"+i+"-26"].value==""||document.MYFORM.elements["MONTH"+i+"-26"].value===null|| document.MYFORM.elements["MONTH"+i+"-26"].value==="--")
				{
					alert("Line"+(i+1)+":BI Region can not be empty!");
					return false;
				}
			}			
		}
	}
	
	if (document.MYFORM.ACTIONID.value=="--" || document.MYFORM.ACTIONID.value==null)
  	{ 
   		alert(ms2);   
   		return(false);
  	} 
	//modify by Peggy 20111103 add 013 item
	else if (document.MYFORM.ACTIONID.value!="002" && document.MYFORM.ACTIONID.value!="001"  && document.MYFORM.ACTIONID.value!="021" && document.MYFORM.ACTIONID.value!="013")  //表示動作清單不為CREATE,可能是自行輸入LINE_ID,因此需卡住網頁動作
    { 
       	alert("Error Action Process!!!\n Don't try key-in invalid line No in this page...");   
        return(false);
    }
	//modify by Peggy 20111103
	else if (document.MYFORM.ACTIONID.value == "013" && (document.MYFORM.CancelReason.value == "" || document.MYFORM.CancelReason.value == null))
	{
		alert("please input a reason for this cancel action!");
		document.MYFORM.CancelReason.focus();
		return false;
	}
	
  	document.MYFORM.action=URL;
  	document.MYFORM.submit();
}

function setSubmit1(URL)
{ 
	var linkURL = "#ACTION";
  	document.MYFORM.action=URL+linkURL;
  	document.MYFORM.submit();    
}

function setSubmit2(URL,LINKREF)
{ 
   	warray=new Array(document.MYFORM.REQUESTDATE.value); 
   	// 檢查日期是否符合日期格式 
   	var datetime;
   	var year,month,day;
	var gone,gtwo;
   	if(warray[0]!="")
   	{
    	datetime=warray[0];
     	if(datetime.length==8)
     	{
        	year=datetime.substring(0,4);
        	if(isNaN(year)==true)
			{
         		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
         		document.MYFORM.REQUESTDATE.focus();
         		return(false);
        	}
        	gone=datetime.substring(4,5);
        	month=datetime.substring(4,6);
        	if(isNaN(month)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.MYFORM.REQUESTDATE.focus();
          		return(false);
        	}
        	gtwo=datetime.substring(7,8);
        	day=datetime.substring(6,8);
        	if(isNaN(day)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.MYFORM.REQUESTDATE.focus();
          		return(false);
        	}
          	if(month<1||month>12) 
		  	{ 
            	alert("Month must between 01 and 12 !!"); 
            	document.MYFORM.REQUESTDATE.focus();   
            	return(false); 
          	} 
          	if(day<1||day>31)
		  	{ 
            	alert("Day must between 01 and 31!!");
            	document.MYFORM.REQUESTDATE.focus(); 
            	return(false); 
          	}
			else
			{
            	if(month==2)
				{  
                	if(isLeapYear(year)&&day>29)
					{ 
                    	alert("February between 01 and 29 !!"); 
                      	document.MYFORM.REQUESTDATE.focus();
                      	return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                    	alert("February between 01 and 29 !!");
                     	document.MYFORM.REQUESTDATE.focus(); 
                     	return(false); 
                    } 
                } // End of if(month==2)
                if((month==4||month==6||month==9||month==11)&&(day>30))
				{ 
                	alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   	document.MYFORM.REQUESTDATE.focus(); 
                   	return(false); 
                } 
           	} // End of else 
    	}
		else
		{ // End Else of if(datetime.length==10)
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.MYFORM.REQUESTDATE.focus();
          	return(false);
        }
  	}
	else
	{  
	}
	   
  	document.MYFORM.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目	   	   

  	var requestDate="&REQUESTDATE="+document.MYFORM.REQUESTDATE.value; 
  	var linkURL = "#"+LINKREF;
  	document.MYFORM.action=URL+requestDate+linkURL;
  	document.MYFORM.submit();    
}

function setSubmit3(URL,LINKREF)
{ 
	var markDelete="&MARKDELETE="+document.MYFORM.MARKDELETE.value; 
  	var linkURL = "#"+LINKREF;
  	document.MYFORM.action=URL+markDelete+linkURL;
  	document.MYFORM.submit();    
}

function setSubmit4(URL,dnDocNo,xsampleOrder)
{  
	var InsertPage="?DNDOCNO="+dnDocNo+"&LSTATUSID=001&INSERT=Y";
   	//warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value);
	warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value,document.MYFORM.SPQP.value,document.MYFORM.MOQP.value); //modify by Peggy 20120521
	for (i=0;i<6;i++)
   	{  
    	if (i<=1)  
     	{
	   		if ((warray[0]=="" || warray[0]==null || warray[0]=="--") && (warray[1]=="" || warray[1]==null || warray[1]=="--"))
	   		{ 
	    		alert("TSC Item or Item Description must input,please do not let them's data be Null !!");
				document.MYFORM.ITEMDESC.focus();
	    		return(false); 
	   		}
	 	}	 
	 	else if (i==2)
     	{	 
	   		if (warray[i]=="" || warray[i]==null)
	   		{  
        		alert("Please Input Order Quantity!!");   
	    		document.MYFORM.ORDERQTY.focus();  
	    		return(false);	 
	   		}	    
     	} // End of else if (warray[i]=="")
	 	else if (i==3)
     	{	
	   		if (warray[i]=="" || warray[i]==null || warray[i].length != 8)
	   		{   
        		alert("Please Input Request Date!!");   
	    		document.MYFORM.REQUESTDATE.focus();  
	    		return(false);	    
	   		} 
			else
			{
				// 檢查日期是否符合日期格式 
				var datetime;
				var year,month,day;
				var gone,gtwo;

     			datetime=warray[3];
				year=datetime.substring(0,4);
				if(isNaN(year)==true)
				{
					alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
					document.MYFORM.REQUESTDATE.focus();
					return(false);
				}
				gone=datetime.substring(4,5);
				month=datetime.substring(4,6);
				if(isNaN(month)==true)
				{
					alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
					document.MYFORM.REQUESTDATE.focus();
					return(false);
				}
				gtwo=datetime.substring(7,8);
				day=datetime.substring(6,8);
				if(isNaN(day)==true)
				{
					alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
					document.MYFORM.REQUESTDATE.focus();
					return(false);
				}
				if(month<1||month>12) 
				{ 
					alert("Month must between 01 and 12 !!"); 
					document.MYFORM.REQUESTDATE.focus();   
					return(false); 
				} 
				if(day<1||day>31)
				{ 
					alert("Day must between 01 and 31!!");
					document.MYFORM.REQUESTDATE.focus(); 
					return(false); 
				}
				else
				{
					if(month==2)
					{  
						if(isLeapYear(year)&&day>29)
						{ 
							alert("February between 01 and 29 !!"); 
							document.MYFORM.REQUESTDATE.focus();
							return(false); 
						}       
						if(!isLeapYear(year)&&day>28)
						{ 
							alert("February between 01 and 29 !!");
							document.MYFORM.REQUESTDATE.focus(); 
							return(false); 
						} 
					} // End of if(month==2)
					if((month==4||month==6||month==9||month==11)&&(day>30))
					{ 
						alert("Apr., Jun., Sep. and Nov. \n Must between 01 and 30 !!");
						document.MYFORM.REQUESTDATE.focus(); 
						return(false); 
					} 
				} // End of else 
				today = new Date();
				xday = new Date(year,month,day);
				dayMS = 24*60*60*1000;
				n = Math.floor((xday.getTime()-today.getTime())/dayMS)+1;
				if (n < 0)
				{
					alert("<jsp:getProperty name='rPH' property='pgRFQRequestDateMsg'/>");	
					document.MYFORM.REQUESTDATE.focus();
					return(false);
				}
			}
     	} // End of else if (warray[i]=="")
   	} //end of for  null check
     
   	for (i=2;i<3;i++)
   	{     
    	txt=warray[i];
	 	for (j=0;j<txt.length;j++)      
     	{ 
	  		c=txt.charAt(j);	   
     	} 
	  	if ("0123456789.".indexOf(c,0)<0) 
	 	{
	  		alert("The Quantity data that you inputed should be numerical!!");    
	  		return(false);
	 	}
   	} //end of for  null check

	//check sqp add by Peggy 20120521
	if (warray[4]!=null) 
	{
		if (warray[4]!=0)
		{
			var sourcespq=warray[4]; // SPQ
			var base=warray[5] * 1000; // MOQ
			var oQTY=warray[2] * 1000; // OrderQty
			oQTY = oQTY.toFixed(4); 
			var spqQty=sourcespq * 1000; // SPQ
			if (base==0 && spqQty==0) 
			{	
			//
			} 
			else
			{ 
				if (base >0 && spqQty>0) // 若兩者皆大於零
				{ 
					var baseSPQ=spqQty;
					var baseMOQ=base;
	  				
					if (oQTY<baseMOQ) // 若輸入數量小於 MOQ 則警告
					{ 
						if (xsampleOrder == "N")
						{ 
							alert("The Order Q'ty which you input less than MOQ setting !!!\n    MOQP= "+warray[5]+" KPC"); 
							document.MYFORM.ORDERQTY.focus(); 
							return(false); 
						}
						else 
						{ 
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptable by Sample Order Q'ty rule !!!\n      SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false);
							} 
						}
					}
					else 
					{ 
						if (xsampleOrder == "N") 
						{
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptable by MOQ / Plus SPQP rule !!!\n     SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false); 
							} 
						} 
						else 
						{  
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptable by SPQP rule !!!\n   SPQP= "+sourcespq+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false); 
							} 
						}      
					} 
				} // enf of if 
			} // end else
		} // end if
	}

	var myDate = document.MYFORM.maxDate.value;
	var myDate1 = document.MYFORM.maxDate1.value;
	if (document.MYFORM.PLANTCODE.value =="002" && document.MYFORM.SALESAREANO.value=="020")
	{
		if (document.MYFORM.REQUESTDATE.value <= myDate1 && document.MYFORM.REQUESTDATE.value!= "")
		{
			alert("The Request Date must greater than leadtime "+myDate1);
			document.MYFORM.REQUESTDATE.focus();
			return (false);
		}
	}
	else
	{
		if (document.MYFORM.REQUESTDATE.value <= myDate && document.MYFORM.REQUESTDATE.value!= "")
		{
			alert("The Request Date must greater than leadtime "+myDate);
			document.MYFORM.REQUESTDATE.focus();
			return (false);
		}
	}
	
	if (document.MYFORM.showCRD.value =="Y" || document.MYFORM.showCRD.value =="X")
	{
		if (document.MYFORM.CRD.value==null || document.MYFORM.CRD.value =="" || document.MYFORM.CRD.value.length != 8)
		{
			alert("please input a value on CRD field!");
			document.MYFORM.CRD.focus();
			return (false);
		}
		else if (eval(document.MYFORM.CRD.value)<eval(document.MYFORM.SYSDATE.value)) //add by Peggy 20210308
		{
			alert("CRD must be greater than or equals the today!");
			document.MYFORM.CRD.focus();
			return (false);				
		}		
	}
	
	//modify by Peggy 20120209
	if (document.MYFORM.showCRD.value =="Y" || document.MYFORM.showCRD.value =="S" || document.MYFORM.showCRD.value =="X")
	{
		if (document.MYFORM.SHIPPINGMETHOD.value == null || document.MYFORM.SHIPPINGMETHOD.value =="")
		{
			alert("please input a value on shippingmethod field!");
			document.MYFORM.SHIPPINGMETHOD.focus();
			return (false);
		}
	}
		
	//add by Peggy 20111011,歐洲區+SMA ITEM或AU類別客戶皆不接受外購品
	if (document.MYFORM.PLANTCODE.value=="008")
	{
		//if ( document.MYFORM.CUSTMARKETGROUP.value=="AU")
		//{
		//	alert("The AU market group customer does not accept a outsource goods!");
		//	return false;
		//}
		if ( document.MYFORM.SALESAREANO.value=="001" &&  document.MYFORM.CUSTMARKETGROUP.value=="AU" && document.MYFORM.TSCPACKAGE.value=="SMA" && document.MYFORM.YEWFLAG.value=="1")
		{
			alert("The SMA item does not accept a outsource goods!");
			return false;
		}
	}

	//add by Peggy 20120305
	if (document.MYFORM.LINEODRTYPE.value==null || document.MYFORM.LINEODRTYPE.value=="" || document.MYFORM.LINEODRTYPE.value=="null")
	{
		alert("The ORDER TYPE is not empty!");
		document.MYFORM.LINEODRTYPE.focus();
		return (false);
	}
	//add by Peggy 20120427	
	else if (( document.MYFORM.CURR.value =="NTD" || document.MYFORM.CURR.value =="TWD") && document.MYFORM.LINEODRTYPE.value != "1131")
	{
		alert("The Order Type is not available!");
		document.MYFORM.LINEODRTYPE.focus();
		return (false);
	}			
	else if (document.MYFORM.LINEODRTYPE.value == "1132" && document.MYFORM.SALES_GROUP_ID.value !="509")  //add by Peggy 20210528
	{
		alert("This customer is not allowed to book 1132 order type!!");
		document.MYFORM.LINEODRTYPE.focus();
		return (false);			 
	}
	else if (document.MYFORM.LINEODRTYPE.value != "1132" && document.MYFORM.SALES_GROUP_ID.value =="509")  //add by Peggy 20210528
	{
		alert("This customer must book 1132 order type!!");
		document.MYFORM.LINEODRTYPE.focus();
		return (false);			 
	}		
	
	//add by Peggy 20120305
	if (document.MYFORM.LINETYPE.value==null || document.MYFORM.LINETYPE.value=="" || document.MYFORM.LINETYPE.value=="null")
	{
		alert("The LINE TYPE is not empty!");
		document.MYFORM.LINETYPE.focus();
		return (false);
	}	

	//add by Peggy 20120522
	if (document.MYFORM.showCRD.value =="X" || document.MYFORM.showCRD.value=="S")
	{
		var isExit = false;
		var SHIPPINGMETHOD =document.MYFORM.SHIPPINGMETHOD.value;
		for (var j = 0; j < document.MYFORM.SHIPMETHODLIST.options.length; j++) 
		{	
			if (document.MYFORM.SHIPMETHODLIST.options[j].value == SHIPPINGMETHOD)
			{
				isExit = true;
				break;
			}
		}	
		if (!isExit)
		{
			alert("Shipping Method:"+SHIPPINGMETHOD+" is not available!!"); 
			document.MYFORM.SHIPPINGMETHOD.focus();
			return(false);
		}
	}
	
	//add by Peggy 20120601
	if (document.MYFORM.CUSTPOLINENO!=undefined)
	{
		if (document.MYFORM.CUSTPOLINENO.value=="" ||document.MYFORM.CUSTPOLINENO.value=="null" || document.MYFORM.CUSTPOLINENO.value==null)
		{
			alert("Please input the cust po line no value!!"); 
			document.MYFORM.CUSTPOLINENO.focus();  
			return(false);
		} 
	}	
	
	//add by Peggy 20140424
	if ( document.MYFORM.SALESAREANO.value=="001")
	{
		if (document.MYFORM.LINEFOB.value.toUpperCase().indexOf("FOB") >=0 || document.MYFORM.LINEFOB.value.toUpperCase()=="EX WORKS" || document.MYFORM.LINEFOB.value.toUpperCase()=="EX-WORK" || document.MYFORM.LINEFOB.value.toUpperCase()=="FCA TAIWAN" || document.MYFORM.LINEFOB.value.toUpperCase()=="FCA TIANJIN" || document.MYFORM.LINEFOB.value.toUpperCase()=="FCA I-LAN" || document.MYFORM.LINEFOB.value.toUpperCase()=="FCA YANGXIN XIAN" || document.MYFORM.LINEFOB.value.toUpperCase()=="C&F H.K." || document.MYFORM.LINEFOB.value.toUpperCase()=="EXW I-LAN" || document.MYFORM.LINEFOB.value.toUpperCase()=="CIF H.K." )
		{
			if (document.MYFORM.SHIPPINGMETHOD.value.toUpperCase()=="AIR(C)" || document.MYFORM.SHIPPINGMETHOD.value.toUpperCase()=="SEA(C)")
			{
				if (document.MYFORM.LINEODRTYPE.value!="1214" || document.MYFORM.LINEFOB.value.toUpperCase()!="EX WORKS")  //1214 EX WORKS排外 ADD BY PEGGY 20220105
				{
					alert("Shipping Method not match FOB Term!");
					document.MYFORM.SHIPPINGMETHOD.focus();
					return false;
				}
			}
		}
	}
		
	//add by Peggy 20160219,012業務區內銷訂單 end customer必填
	//if ( document.MYFORM.SALESAREANO.value=="012")
	if (document.MYFORM.SALESAREANO.value=="012" || document.MYFORM.SALESAREANO.value=="022" || (document.MYFORM.SALESAREANO.value=="002" && document.MYFORM.TSCUSTOMERID.value=="15540")) //modify by Peggy 20180518
	{
		if (document.MYFORM.ENDCUSTOMER.value == null || document.MYFORM.ENDCUSTOMER.value =="" || document.MYFORM.ENDCUSTOMERID.value ==null || document.MYFORM.ENDCUSTOMERID.value=="")
		{	
			alert("Please input a end customer!!");
			document.MYFORM.ENDCUSTOMER.focus();
			return false;			
		}	
	}		
	
	//add by Peggy 20140812
	if (document.MYFORM.ENDCUSTOMER.value != null && document.MYFORM.ENDCUSTOMER.value !="")
	{
		if (document.MYFORM.ENDCUSTOMERID.value ==null || document.MYFORM.ENDCUSTOMERID.value=="")
		{
			alert("Please choose erp end customer!!");
			document.MYFORM.ENDCUSTOMER.focus();
			return false;
		}
		if (document.MYFORM.ENDCUSTOMERID.value==document.MYFORM.TSCUSTOMERID.value)
		{
			alert("End customer can not be the same with rfq customer!!");
			document.MYFORM.ENDCUSTOMER.focus();
			return false;
		}
	}

	if (document.MYFORM.LINEODRTYPE.value=="1121" || document.MYFORM.LINEODRTYPE.value=="4121") //add by Peggy 20161228
	{
		if (document.MYFORM.ITEMSTATUS.value=="NRND")
		{
			if (confirm("Are you sure to order this item(status="+document.MYFORM.ITEMSTATUS.value+")")==false)
			{
				return false;
			}
		}
	}	
	
	//add by Peggy 20170220
	if (document.MYFORM.TSCUSTOMERID.value=="14980" || document.MYFORM.TSCUSTOMERID.value=="15540")
	{
		if (document.MYFORM.BI_REGION.value==""||document.MYFORM.BI_REGION.value==null|| document.MYFORM.BI_REGION.value=="--")
		{
			alert("Please choose a BI Region!");
			document.MYFORM.BI_REGION.focus();
			return false;
		}
	}
				
 	document.MYFORM.action=URL+InsertPage;
 	document.MYFORM.submit();
}

function setSubmit5(URL,invitem)
{ 
	var markDelete="&MARKDELETE="+document.MYFORM.MARKDELETE.value; 
  	var linkURL = "#"+LINKREF;
  	document.MYFORM.action=URL+markDelete+linkURL;
  	document.MYFORM.submit();    
}

function setSubmit6(URL,dnDocNo,delFlag)
{  
	var InsertPage="?DNDOCNO="+dnDocNo+"&INSERT=Y"+"&DELMODE="+delFlag;   
	document.MYFORM.action=URL+InsertPage;
 	document.MYFORM.submit();
}

function subWindowItemFind(invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,priceList)
{    
	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D1009&SALESAREA="+salesAreaNo+"&PRICELIST="+priceList+"&deliverid="+document.MYFORM.DELIVERTOOD.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no");  
} 

function setItemFindCheck(invItem,itemDesc,salesAreaNo,priceList)
{
	if (event.keyCode==13 || document.MYFORM.INVFLAG.value =="1")
   	{ 
    	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&sType=D1009&SALESAREA="+salesAreaNo+"&PRICELIST="+priceList+"&deliverid="+document.MYFORM.DELIVERTOOD.value,"subwin","width=800,height=480,scrollbars=yes,menubar=no"); 
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

function setSPQCheck(xORDERQTY,xSPQP,xMOQP,xsampleOrder)
{
	/*
	if (event.keyCode==13 || event.keyCode==9 )
   	{ 
    	if (xSPQP!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
      	{
        	if (xSPQP==0) //若系統取得0, 表示尚未設定該料號最小包裝量, 不得詢問
	     	{
	        	alert("The Item SPQP not be defaule, Please contact with Item Administroatr!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
            	document.MYFORM.REQUESTDATE.focus();  
	        	//return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
         	} 
			else
	     	{
            	base=xSPQP;
            	n=xORDERQTY/base;
	        	if ((""+n).indexOf(".")>-1) 
	        	{ 
	           		alert("The Order Q'ty which you input not acceptence by SPQP rule !!!\n                          SPQP= "+base+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
               		document.MYFORM.ORDERQTY.focus();  
	           		return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
	         	}
	      	} // end if
	      	document.MYFORM.REQUESTDATE.focus();  
      	} //end null if
   	} //end keydown if	
	*/
	//modif by Peggy copy D1-001的檢查到D1-009 20120516
	if (event.keyCode==13 || event.keyCode==9 ) // event.keycode = 9 --> Tab 鍵
	{ 
		if (xSPQP!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
		{
			if (xSPQP==0 && xMOQP==0) //若系統取得0, 表示尚未設定該料號最小包裝量(MOQ及SPQ), 不得詢問
			{
				alert("The Item SPQP not be default, Please contact with Item Administrator!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
				document.MYFORM.REQUESTDATE.focus();  
				return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
			} 
			else
			{ // 開始判斷取 MOQ /SPQ 規則2006/06/05_起
				if (xMOQP >0 && xSPQP>0) // 若兩者皆大於零
				{ 
					var baseSPQ= xSPQP * 1000;
					var baseMOQ=xMOQP * 1000;
					var oQTY=xORDERQTY * 1000;
					if (oQTY<baseMOQ) // 若輸入數量小於 MOQ 則警告
					{ 
						if (xsampleOrder == "N")
						{ 
							alert("The Order Q'ty which you input less than MOQ setting !!!\n  MOQP= "+xMOQP+" KPC"); 
							document.MYFORM.ORDERQTY.focus(); 
							return(false);
						}
						else 
						{ //若是選擇樣品訂單,則直接以SPQ計算
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptence by Sample Order Q'ty rule !!!\n  SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false); 
							} 
						} 
					}
					else 
					{ 
						if (xsampleOrder == "N")
						{
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptence by MOQ/SPQP rule !!!\n   SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false);
							} 
						} 
						else 
						{
							var n = oQTY % baseSPQ;
							if (n != 0)
							{
								alert("The Order Q'ty which you input not acceptence by SPQP rule !!!\n   SPQP= "+xSPQP+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
								document.MYFORM.ORDERQTY.focus();  
								return(false); 
							} 
						}      
					} 
				} 
			} 
			document.MYFORM.REQUESTDATE.focus();  
		} 
	} 
}
// Add by Peggychen 20110622
function subWindowSSDFind(sKind,plant)
{    
	var itemdesc = document.MYFORM.INVITEM.value;
	var crdate = document.MYFORM.CRD.value;
	var plant = document.MYFORM.PLANTCODE.value;
	var odrtype = document.MYFORM.LINEODRTYPE.value;
	var region = document.MYFORM.SALESAREANO.value;
	var createdt = document.MYFORM.SYSDATE.value;
	var lineFOB = document.MYFORM.LINEFOB.value; //add by Peggy 20140424
	var shippingMethod = document.MYFORM.SHIPPINGMETHOD.value;
	var custid = document.MYFORM.TSCUSTOMERID.value; //add by Peggy 20151026
	var deliver_to_id=document.MYFORM.DELIVERTOOD.value;  //add by Peggy 20210208
	if (lineFOB==null||lineFOB=="")
	{
		lineFOB = document.MYFORM.FOBPOINT.value;//add by Peggy 20150826
		document.MYFORM.LINEFOB.value =lineFOB; //add by Peggy 20210217
	} 

	if (sKind == "1" || sKind == "3")
	{
		//if (sKind == "3" && shippingMethod != "") return; //add by Peggy 20130122
		//modify by Peggy 20140424
		if (sKind == "3" && (shippingMethod != "" || (region=="001" && (lineFOB.toUpperCase().indexOf("FOB")>=0 || (odrtype!="1214" && lineFOB.toUpperCase()=="EX WORKS") || lineFOB.toUpperCase()=="EX-WORK" || lineFOB.toUpperCase()=="FCA TAIWAN" || lineFOB.toUpperCase()=="FCA TIANJIN" || lineFOB.toUpperCase()=="FCA I-LAN"  || lineFOB.toUpperCase()=="FCA YANGXIN XIAN"  || lineFOB.toUpperCase()=="C&F H.K."  || lineFOB.toUpperCase()=="EXW I-LAN" || lineFOB.toUpperCase()=="CIF H.K."))) ) return; //modify by Peggy 20140424,1214 EX WORKS 排除 by Peggy 20220413
		
		if (sKind == "1") 
		{
			shippingMethod = "";
		}
		else if (sKind == "3")
		{
			shippingMethod = "*";
		}
	
		if (itemdesc =="" || itemdesc == null)
		{
			alert("Please input the item !!! ");
			document.MYFORM.INVITEM.focus();
			return (false);
		}
		
		if (odrtype == "--" || odrtype == ""  || odrtype == null)
		{
			alert("Please choice the Order Type !!! ");
			document.MYFORM.PREORDERTYPE.focus();
			return (false);
		}
	
		if (crdate=="" || crdate==null)
		{
			alert("Please input a value on CRD field !!! ");
			document.MYFORM.CRD.focus();
			return (false);
		}
		
		if (crdate.length!= 8)
		{
			alert("The format of CRD field must be yyyymmdd !!! ");
			document.MYFORM.CRD.focus();
			return (false);
		}	
		else
		{
			var year = crdate.substring(0,4);
			var mon = crdate.substring(4,6);
			var dd = crdate.substring(6,8);
			if (year.substring(0,1) != 2)
			{
				alert("The year is invalid on CRD field!!! ");
				document.MYFORM.CRD.focus();
				return (false);
			}
			else if (mon <1 || mon>12)
			{
				alert("The month is invalid on CRD field!!! ");
				document.MYFORM.CRD.focus();
				return (false);
			}
			else if (dd <1 || dd>31)
			{
				alert("The date is invalid on CRD field!!! ");
				document.MYFORM.CRD.focus();
				return (false);
			}
			else 
			{
				if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
				|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
				|| (isLeapYear(year) && mon == 2 && dd>29)
				|| (!isLeapYear(year) && mon == 2 && dd>28))
				{
					alert("The date is invalid on CRD field!!! ");
					document.MYFORM.CRD.focus();
					return (false);
				}
			}
		}
		if (plant=="" || plant==null)
		{
			alert("Please choise the item !!!");
			document.MYFORM.INVITEM.focus();
			return (false);
		}
		subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&custid="+custid+"&fob="+lineFOB.replace("&","\"")+"&deliverid="+deliver_to_id ,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); //add by Peggy 20210207
	}
	else
	{	
		if (shippingMethod != "" && shippingMethod != null && crdate != "" && crdate != null && (SSDate == "" || SSDate == null))
		{
			subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&custid="+custid+"&fob="+lineFOB.replace("&","\"")+"&deliverid="+deliver_to_id ,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); //add by Peggy 20210207
		}
	}
	
	//if (plant=="" || plant==null)
	//{
	//	alert("Please choise the item !!!");
	//	document.MYFORM.INVITEM.focus();
	//	return (false);
	//}
    //
	//subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

//add by Peggy 20120209
function subWindowShipMethodFind(primaryFlag)
{	    
	subWin=window.open("../jsp/subwindow/TSDRQShippingMethodFind.jsp?PRIMARYFLAG="+primaryFlag+"&SEARCHSTRING="+primaryFlag+"&sType=D1009","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

//add by Peggy 20120306
function subWindowCustItemFind()
{
	var CUSTOMERID = document.MYFORM.TSCUSTOMERID.value;
	var INVITEM = document.MYFORM.INVITEM.value;
	var CITEMDESC = document.MYFORM.CITEMDESC.value;  //add by Peggy 20130412
	if (CUSTOMERID == null || CUSTOMERID =="")
	{
		alert("please choose the customer!");
		return false;
	}
	if ((INVITEM == null || INVITEM == "") && (CITEMDESC == null || CITEMDESC == ""))
	{
		alert("please choose the tsc item or customer item name!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSDRQCustomerItemFind.jsp?INVITEM="+INVITEM+"&CUSTOMERID="+CUSTOMERID+"&CUSTITEM="+CITEMDESC,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

//add by Peggy 20120303
function subWindowOrderTypeFind(primaryFlag,plantCode,objLine)
{	
	var salesAreaNo = document.MYFORM.SALESAREANO.value;
	if (salesAreaNo == null || salesAreaNo =="")
	{
		alert("please choose the sales area!");
		return false;
	}

	if (plantCode == null || plantCode =="")
	{
		alert("please choose the manufacture factory!");
		return false;
	}	    
	subWin=window.open("../jsp/subwindow/TSDRQOrderTypeFind.jsp?PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&MANUFACTORY="+plantCode+"&ArrayLine="+objLine+"&CUSTOMERID="+document.MYFORM.TSCUSTOMERID.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 	

//add by Peggy 20120303
function subWindowLineTypeFind(primaryFlag,orderType,objLine)
{	    
	var salesAreaNo = document.MYFORM.SALESAREANO.value;
	if (salesAreaNo == null || salesAreaNo =="")
	{
		alert("please choose the sales area!");
		return false;
	}

	if (orderType == null || orderType =="")
	{
		alert("please choose the order type!");
		return false;
	}	
	subWin=window.open("../jsp/subwindow/TSDRQLineTypeFind.jsp?PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&orderType="+orderType+"&ArrayLine="+objLine,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 	

//add by Peggy 20120306
function subWindowPlantFind(primaryFlag)
{
	subWin=window.open("../jsp/subwindow/TSDRQPlantCodeFind.jsp?PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function subWindowLineClickEvent(objLine,objColumn)
{
	if (objColumn == 15) //order type
	{
		var linePlant = document.MYFORM.elements["MONTH"+objLine+"-10"].value;
		if (linePlant !="N/A" && linePlant != null && linePlant != "")
		{
			subWindowOrderTypeFind("",linePlant,objLine);
		}
		else
		{
			alert("Please choose the plant value!!"); 
			document.MYFORM.elements["MONTH"+objLine+"-10"].focus();
			return false;
		}
	}
	else if (objColumn == 16) //line type
	{
		var lineOrderType = document.MYFORM.elements["MONTH"+objLine+"-15"].value;
		if (lineOrderType !="N/A" && lineOrderType != null && lineOrderType != "")
		{
			subWindowLineTypeFind("",lineOrderType,objLine);
		}
		else
		{
			alert("Please choose the order type value!!"); 
			document.MYFORM.elements["MONTH"+objLine+"-15"].focus();
			return false;
		}
	}
	else if (objColumn == 17) //fob
	{
		subWindowFOBPointFind("",objLine);
	}
}
//add by Peggy 20120329
function subWindowFOBPointFind(primaryFlag,fieldType)
{    
	subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D1009&FTYPE="+fieldType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
//add by Peggy 20140811
function subWindowEndCustFind(custnumber,salesarea)
{
	if (custnumber==null || custnumber=="")
	{
		alert("Please choose ERP customer!");
		document.MYFORM.CUSTOMERNO.focus();
		return false;
	}
	if (salesarea==null || salesarea=="")
	{
		alert("Please choose sales area!");
		//document.MYFORM.SALESAREANO.focus();
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSDRQERPEndCustFind.jsp?CUSTNUMBER="+custnumber+"&SALESAREA="+salesarea+"","subwin","width=600,height=480,scrollbars=yes,menubar=no");  
}
//add by Peggy 20140813
function custChange()
{
	document.MYFORM.ENDCUSTOMERID.value="";
}	
function setsubmitChg()
{
	if (document.MYFORM.ACTIONID.value !="--")
	{
		document.MYFORM.ACTIONID.value="--";
	}
}
function setPOObject(salesarea,customerpo)
{
	if (salesarea=="020")
	{
		if (customerpo.toUpperCase().indexOf("(K)",0)>=0 || customerpo.toUpperCase().indexOf("KOREA",0)>=0)
		{
			document.MYFORM.DIRECT_SHIP_TO_CUST.value="1";
		}
		else
		{
			document.MYFORM.DIRECT_SHIP_TO_CUST.value="";
		}
	}
}
function setPrice(salesarea,quotenum,tscpartno,tscitem)
{
	if ((salesarea=="009" || salesarea=="006" || salesarea=="003") && event.keyCode==13)   //tscj add by Peggy 20240528
	{
		subWin=window.open("../jsp/subwindow/TSDRQQuoteInfoFind.jsp?QNO="+quotenum+"&PNO="+tscpartno+"&PITEM="+tscitem,"subwin","width=10,height=10,scrollbars=yes,menubar=no");  
	}	
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<%
	String dnDocNo=request.getParameter("DNDOCNO");
   	String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   	String lineNo=request.getParameter("LINENO");
   	String pcAcceptDate=request.getParameter("PCACPDATE"); 
   	String actionID = request.getParameter("ACTIONID");   
   	String remark = request.getParameter("REMARK");   
   	String line_No=request.getParameter("LINE_NO");
   	String quantity=request.getParameter("QUANTITY");
   	String setRequestDate = request.getParameter("SETREQUESTDATE");
   	String markDelete = request.getParameter("MARKDELETE");
   	String [] check=request.getParameterValues("CHKFLAG");
   	String isModelSelected=request.getParameter("ISMODELSELECTED");  
   	String insertPage=request.getParameter("INSERT"); 
   	int commitmentMonth=0;
   	rfqArray2DTemporaryBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
   	String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料 
   	String [] addItems=request.getParameterValues("ADDITEMS");
   	String delMode = request.getParameter("DELMODE");
   	String custINo=request.getParameter("CUSTINO");
	String iNo=request.getParameter("INO");
	String invItem=request.getParameter("INVITEM");
	String itemDescription=request.getParameter("ITEMDESC");
	String orderQty=request.getParameter("ORDERQTY");
	String uom=request.getParameter("UOM");
	String requestDate=request.getParameter("REQUESTDATE");
	String lnRemark=request.getParameter("LNREMARK");
	String sPQP=request.getParameter("SPQRULE"); //modify by Peggy 20120516
	String custPONo=request.getParameter("CUSTPONO");
	String custPOLineNo=request.getParameter("CUSTPOLINENO"); //add by Peggy 20120531
	if (custPOLineNo == null) custPOLineNo = "";
	String custrequestDate=request.getParameter("CRD"),shippingMethod=request.getParameter("SHIPPINGMETHOD");  //add by Peggychen 20110614
	if (custrequestDate == null) custrequestDate = "";
	if (shippingMethod == null) shippingMethod = "";
	//String [] allMonth={iNo,invItem,itemDescription,orderQty,uom,requestDate,lnRemark,custPONo};
	//add two parameters by Peggy 20110622
	String [] allMonth={iNo,invItem,itemDescription,orderQty,uom,custrequestDate,shippingMethod,requestDate,lnRemark,custPONo};	
   	String entry=request.getParameter("ENTRY");
   	if (entry==null || entry.equals("") )  {  }
   	else { rfqArray2DTemporaryBean.setArray2DString(null); } 
	String v_conti_msg=""; //add by Peggy 202209	
   
   	if (custINo==null || custINo.equals("")) custINo = "1";
   	if (iNo==null || iNo.equals("")) iNo = "1"; 
   
   	if (lineNo==null) { lineNo="";}
   	//if (pcAcceptDate==null) { pcAcceptDate="";}
   	if (remark==null) { remark=""; }
   	if (requestDate==null) { requestDate="";}   
   	if (quantity==null) { quantity="0";}
   	if (markDelete==null) {markDelete = "N";}
   	if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
   
   	if (delMode==null) delMode="N";
  	if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
  	{    
		rfqArray2DTemporaryBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  	}

  	String spqp=request.getParameter("SPQP");
  	String moqp=request.getParameter("MOQP");
  	String plantCode=request.getParameter("PLANTCODE"); //2009/03/02 liling add default item attribute3 plantcode
  	String plantDesc="";
	String TSCPACKAGE=request.getParameter("TSCPACKAGE"); //add by Peggy 20111004
	if (TSCPACKAGE==null) TSCPACKAGE = "";  //add by Peggy 20111004	
	String CancelReason=request.getParameter("CancelReason");  //add by Peggy 20111103
	if (CancelReason==null) CancelReason="";
	String custItem=request.getParameter("CITEMDESC");       //add by Peggy 20120222
	String sellingprice=request.getParameter("UPRICE");      //add by Peggy 20120222
	String ordertype=request.getParameter("LINEODRTYPE");    //add by Peggy 20120222
	String linetype=request.getParameter("LINETYPE");        //add by Peggy 20120222
	String lineFob=request.getParameter("LINEFOB");          //add by Peggy 20120329
	String QUOTENUMBER=request.getParameter("QUOTENUMBER");  //add by Peggy 20120917
	if (QUOTENUMBER == null) QUOTENUMBER = "";
	String ENDCUSTOMER=request.getParameter("ENDCUSTOMER");  //add by Peggy 20121107
	if (ENDCUSTOMER == null) ENDCUSTOMER = "";
	String ENDCUSTOMERID = request.getParameter("ENDCUSTOMERID");  //add by Peggy 20140813
	if (ENDCUSTOMERID ==null) ENDCUSTOMERID = "";                  //add by Peggy 20140813	
	String direct_ship_to_cust=request.getParameter("DIRECT_SHIP_TO_CUST");  //add by Peggy 20160308
	if (direct_ship_to_cust==null||direct_ship_to_cust.equals("--")) direct_ship_to_cust="";	
	String BI_REGION=request.getParameter("BI_REGION");  //add by Peggy 20170218
	if (BI_REGION==null||BI_REGION.equals("--")) BI_REGION="";	
	String end_cust_ship_to_id = request.getParameter("end_cust_ship_to_id");  //add by Peggy 20170512
	if (end_cust_ship_to_id==null) end_cust_ship_to_id="";	
	if (lineFob==null) lineFob="";	
	String shipping_Marks="",remarks="",tsc_prod_group="",greenFlag="";    //add by Peggy 20130305
	String sProgramName=request.getParameter("PROGRAMNAME");   //add by Peggy 20170920
	if (sProgramName==null || sProgramName.equals("")) sProgramName="D1-009";
	String endCustPartNo=request.getParameter("EndCustPartNo"); //add by Peggy 20190225
	if (endCustPartNo==null) endCustPartNo="";		
	String preOrderType=request.getParameter("PREORDERTYPE");
	String sql="";	
	
	try 
 	{   
   		String at[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容     
  		//*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內
   		if (at!=null) 
  	 	{
      		for (int ac=0;ac<at.length;ac++)
	  		{    	        
          		for (int subac=1;subac<at[ac].length;subac++)
	      		{   
		      		at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位
		   		}  //end for array second layer count
	  		} //end for array first layer count
   	 		rfqArray2DTemporaryBean.setArray2DString(at);  //reset Array
   		}   //end if of array !=null
   		//********************************************************************
   
  		if (addItems!=null && delMode.equals("Y")) //若有選取且為刪除鍵則表示要刪除
  		{ 
  
    		String a[][]=rfqArray2DTemporaryBean.getArray2DContent();//重新取得陣列內容
			if (a==null)
			{ 
	  			if (addItems.length>0)
	  			{   //需判斷 addItems的內容,作為刪除的依據 (addItems即是 line_no)		     
		   			for (int x=0;x<addItems.length;x++)
		   			{ 
		     			String sqlDelTemp="delete from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+
						" where DNDOCNO='"+dnDocNo+"' and to_char(LINE_NO) = '"+addItems[x]+"' ";		                                 
	         			PreparedStatement stmtDelTemp=con.prepareStatement(sqlDelTemp);
			 			stmtDelTemp.executeUpdate();   
             			stmtDelTemp.close();
		   			}
		   			if (a==null)	
		   			{
		      			out.println("a object Array is NULL !!!");
		   			}
	  			}  // End of if (addItems) 
			}       
    		else if (a!=null && addItems.length>0)      
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
							for (int gg=0;gg<a[m].length;gg++)
							{                          // 目前共9個{ iNo,invItem,itemDescription,orderQty,uom,custrequestDate,shippingMethod,requestDate,lnRemark }      
								if (gg==0)
								{
									t[cc][gg]= Integer.toString(cc+1); // 把第一行的值重算
								}
								else 
								{
									t[cc][gg]=a[m][gg];         
								}
							} // End of for
							cc++;			     
						}   //end of if a.inArray.equals("N")	
					}   // End of for  
					rfqArray2DTemporaryBean.setArray2DString(t);	  
				} 
				else 
				{ 	
				}  
			}//end of if ( a!=null && addItems.length>0)
  		} 
  	} //end of try
  	catch (Exception e)
  	{
   		out.println("Exception1:"+e.getMessage());
  	}  
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertCancel"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertAssign"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
<em><font color="#993366" size="+2"><strong><<jsp:getProperty name="rPH" property="pgTempDRQDoc"/>></strong></font></em>
<BR>
<!--=============以下區段為取得交期單據基本資料==========-->  
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<%
if (insertPage!=null && insertPage.equals("Y") && tsAreaNo.equals("001"))
{
	if (preOrderType.equals("1342")) //1214
	{
		sql = "SELECT TSC_CHECK_CONTI_ITEM((SELECT CUSTOMER_ID FROM AR_CUSTOMERS WHERE CUSTOMER_NUMBER=?),?,?) FROM DUAL";	
	}
	else
	{
		sql = "SELECT TSC_CHECK_CONTI_ITEM(?,?,?) FROM DUAL";	
	}
	PreparedStatement statement = con.prepareStatement(sql);
	if (preOrderType.equals("1342")) //1214
	{
		statement.setString(1,ENDCUSTOMERID);
	}
	else
	{
		statement.setString(1,tsCustomerID);
	}	
	statement.setString(2,custItem);
	statement.setString(3,invItem);
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{	
		v_conti_msg=rs.getString(1);
	}
	rs.close();
	statement.close();
	
	if (!v_conti_msg.equals("OK"))
	{
		%>
		<SCRIPT>
			alert("<%=v_conti_msg%>");
		</script>
		<%
	}
}

String POLINEFLAG=request.getParameter("POLINEFLAG"); //add by Peggy 20120531
if (POLINEFLAG==null) POLINEFLAG=custPOLineNo_flag;
String LIMITDAYS=request.getParameter("LIMITDAYS");
String LIMITDAYS1="6";
if (LIMITDAYS == null)	
{
	LIMITDAYS ="6";
}
else if (LIMITDAYS.equals("0"))
{
	LIMITDAYS ="-1";
}
if ((tsAreaNo==null && userActCenterNo.equals("020")) || tsAreaNo.equals("020"))  //add by Peggy 20150908,sample區交期只要大於系統日即可
{
	LIMITDAYS1 ="0";
}
dateBeans.setAdjDate(Integer.parseInt(LIMITDAYS));
String maxDate = dateBeans.getYearMonthDay();
dateBeanss.setAdjDate(Integer.parseInt(LIMITDAYS1));
String maxDate1 = dateBeanss.getYearMonthDay();
%>
<HR>
<table cellSpacing="1" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" bordercolor="#66CC99" border="1">
	<tr bgcolor="#99CCFF">      
    	<td width="18%"><div align="center"><font face="Arial" size="2" color="#3366FF">
      		<jsp:getProperty name="rPH" property="pgOrderedItem"/></font><img src="../image/point.gif"><font face="Arial" size="2" color="#3366FF">
      		<jsp:getProperty name="rPH" property="pgTSCAlias"/>      
      		</font></div>
		</td>
	  	<td width="18%"><div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
			</font><img src="../image/point.gif"></div>
		</td>
	  	<td width="8%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgQty"/><img src="../image/point.gif">
			<jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000" size="2">
			<jsp:getProperty name="rPH" property="pgKPC"/></font></div>
		</td> 
		<!-- add by Peggy 20120222-->
		<td>
		<div align="center">
		<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgCustItemNo"/>
		<jsp:getProperty name="rPH" property="pgDesc"/></font>
		</div>	
		</td>
		<!-- add by Peggy 20120222-->
	  	<td width="3%">
		<div align="left">
		<font face="Arial" color="#3366FF">Selling<br>Price</font></div>	
		</td> 			
		<%
		if (showSSD.equals("Y") || showSSD.equals("X")) //顯示CRD
		{
		%>
			<td width="9%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgCRDate"/><BR>(CRD)
			</font></div>
			</td>	
		<%
		}
		//modify by Peggy 20120209
		if (showSSD.equals("Y") || showSSD.equals("S") || showSSD.equals("X")) //顯示SHIPPINGMETHOD
		{
		%>
			<td width="9%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgShippingMethod"/>
			</font><img src="../image/point.gif"></div>
			</td>				   
		<%
		}
		%>
      	<td width="5%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgDeliveryDate"/>
			</font><img src="../image/point.gif"></div>
		</td>
		<!--add by Peggy 20120222-->
		<td>
		<div align="center">
		<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgFirmOrderType"/>
		</font><img src="../image/point.gif"></div>			
		</td> 	
		<!--add by Peggy 20120222-->
		<td>
		<div align="center">
		<font face="Arial" color="#3366FF">Line<BR>Type
		</font><img src="../image/point.gif"></div>			
		</td> 	
		<!--add by Peggy 20120329-->
		<td>
		<div align="center">
		<font face="Arial" color="#3366FF"><jsp:getProperty name="rPH" property="pgFOB"/>	   
		</font></div>			
		</td> 					
	  	<td width="6%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgRemark"/></font></div>
	  	</td> 
	  	<td width="6%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgCustPONo"/></font></div>
		</td>
		<%
		if(tsAreaNo.equals("001") || tsAreaNo.equals("009") || tsAreaNo.equals("006"))  //add by Peggy 20120904
		{
		%>
	  	<td  nowrap>
		<div align="center">
		<font face="Arial" color="#3366FF">Quote#</font><img src="../image/point.gif"></div>		
		</td> 	
		<%
		}
		if (POLINEFLAG.equals("Y"))
		{
		%> 	  	  
	  	<td width="6%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgCustPOLineNo"/></font></div>
		</td>	
		<%
		}
		//if(tsAreaNo.equals("008"))  //add by Peggy 20121107
		//{
		%>
	  	<td  nowrap>
		<div align="center">
		<font face="Arial" color="#3366FF">End Customer</font></div>		
		</td> 	
		<%
		//}
		%> 	  	  
      	<td><font face="Arial" size="2" color="#3366FF">PlantCode</font>
<%
/*
      try
        { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select MANUFACTORY_NO as PRODMANUFACTORY, MANUFACTORY_NO||'  '||MANUFACTORY_NAME  "+
			                        "from ORADDMAN.TSPROD_MANUFACTORY "+
			                        "where MANUFACTORY_NO > 0 "+																  
								     "order by MANUFACTORY_NO "; 
                   //out.print(sqlGetP);		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxBean.setRs(rsGetP);
		           comboBoxBean.setSelection(prodManufactory);
	               comboBoxBean.setFieldName("PLANTCODE");					     
                   out.println(comboBoxBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	   } //end of try		 
       catch (Exception e) { out.println("Exception2:"+e.getMessage()); 
	   }
*/
%>    
		</td> 
		<%
		if(tsAreaNo.equals("020"))  //add by Peggy 20160308
		{
		%>	
			<td width="7%"><font face="Arial" color="#3366FF">Delivery Remarks</font></td>
		<%
		}
		%>	
		<%
		if(tsCustomerID.equals("14980") || tsCustomerID.equals("15540"))  //add by Peggy 20170220
		{
		%>	
			<td width="7%"><font face="Arial" color="#3366FF">BI Region</font></td>
		<%
		}
		if (tsAreaNo.equals("012"))  //add by Peggy 20170512
		{
		%>
			<td width="7%"><font face="Arial" color="#3366FF">End Cust Ship To ID</font></td>	
		<%
		}			
		%>				  	  
	  	<td width="2%" rowspan="2"><div align="center">
		<INPUT TYPE="button" tabindex="24"  value="Add" onClick='setSubmit4("../jsp/TSSalesDRQTemporaryPage.jsp","<%=dnDocNo%>","<%=sampleOrder%>")'></div>
		</td>	 
    </tr>	
  	<tr bgcolor="#99CCFF">
    	<td>    
    		<input type="text" name="INVITEM" tabindex="1"  size="19" class="style2" onFocus='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,"<%=tsAreaNo%>")' onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,"<%=tsAreaNo%>","<%=priceList%>")' maxlength="30" <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%>>
			<INPUT TYPE="button" tabindex="2" value="."  class="style3" onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,"<%=sampleOrder%>","<%=tsCustomerID%>","<%=tsAreaNo%>","<%=priceList%>")'>   
			<input type="hidden" NAME="INVFLAG" value="">
			<input type="hidden" NAME="ITEMSTATUS" value="">
			<input type="hidden" NAME="YEWFLAG" value="">
		</td>
		<td>    
			<input name="INO" type="hidden" size="2" <%if (iNo==null) out.println("value=1"); else out.println("value="+iNo);%>> 
    		<input type="text" name="ITEMDESC" tabindex="3" size="14"  class="style2" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,"<%=tsAreaNo%>","<%=priceList%>")' maxlength="60" <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%>>
			<INPUT TYPE="button" tabindex="4" value="."  class="style3" onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value,"<%=sampleOrder%>","<%=tsCustomerID%>","<%=tsAreaNo%>","<%=priceList%>")'>
			
		</td>
    	<td nowrap><div align="center">	
			<input type="text" name="ORDERQTY" tabindex="5" size="4"  class="style2" onKeyDown='setSPQCheck(this.form.ORDERQTY.value,this.form.SPQP.value,this.form.MOQP.value,"<%=sampleOrder%>")' maxlength="60"  <%if (allMonth[3]!=null) out.println("value="); else out.println("value=");%> >
	 <%
	    out.println("<font color='#FF0000' size='2'>");
	    out.println("MOQ: ");
		%>
      		<input type="text" name="SPQRULE" tabindex="6" size="3" align="right" readonly class="gogo" <%if (sPQP!=null) out.println("value="); else out.println("value=");%>>      
      <%
	    out.println(" K");
	    out.println("</font>");
	  %>
		</div>    
		</td>
		<!-- ADD BY PEGGY 20120222-->
		<td width="5%" nowrap>
			<INPUT TYPE="text" NAME="CITEMDESC" tabindex="7" value='' size="10"  class="style2"  >
       	 	<INPUT TYPE="button"  NAME='button'  tabindex="8" VALUE='.'  class="style3" onClick='subWindowCustItemFind()'><p>
			<INPUT TYPE="text" NAME="EndCustPartNo" style="border:none;color:#0000ff;font-family:Tahoma,Georgia;font-size:9px"></td>
		</td>		
		<!--add by Peggy 20120222-->	
		<td width="3%" nowrap>
		 	<input name='UPRICE' type='text' size='5' tabindex="10" class="style2" >	
		</td>		
		<% 
		if (showSSD.equals("Y") || showSSD.equals("X")) //顯示CRD
		{
		%>
		<td width="5%" nowrap>
       		<input name="CRD" tabindex="10" type="text" size="7"  class="style2" maxlength="8" <%if (allMonth[5]!=null) out.println("value="); else out.println("value=");%>>	   
      		<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.CRD);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> 
		</td>
		<%
		}
		if (showSSD.equals("Y")) //SHIPPINGMETHOD
		{
		%>
		<td width="5%" nowrap>    
    		<input type="text" name="SHIPPINGMETHOD" tabindex="11" size="7"  class="style2" maxlength="20" onFocus="subWindowSSDFind(3,this.form.PLANTCODE.value)" <%if (allMonth[6]!=null) out.println("value="); else out.println("value=");%>>
			<INPUT TYPE="button" tabindex="12"  value="."  class="style3" onClick="subWindowSSDFind(1,this.form.PLANTCODE.value)">
    	</td>		
		<%
		}
		else if (showSSD.equals("S") || showSSD.equals("X")) //顯示SHIPPINGMETHOD,modify by Peggy 20120209
		{
		%>
		<td width="5%" nowrap>    
    		<input type="text" name="SHIPPINGMETHOD" tabindex="11" size="7" maxlength="20"  class="style2" onChange="subWindowShipMethodFind(this.form.SHIPPINGMETHOD.value)" <%if (allMonth[6]!=null) out.println("value="); else out.println("value=");%>>
			<INPUT TYPE="button" tabindex="12"  value="."  class="style3" onClick='subWindowShipMethodFind(this.form.SHIPPINGMETHOD.value)'>
    	</td>			
		<%
			//add by Peggy 20120522
			Statement stateX=con.createStatement();
			String sqlX = "select a.SHIPPING_METHOD_CODE,SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a"; 
			ResultSet rsX=stateX.executeQuery(sqlX);
			out.println("<select NAME='SHIPMETHODLIST'  style='visibility: hidden;'>");				  			  
			out.println("<OPTION VALUE=-->--");     
			while (rsX.next())
			{            
				String s1=(String)rsX.getString(1); 
				String s2=(String)rsX.getString(2); 
				out.println("<OPTION VALUE='"+s1+"'>"+s2);
			}
			out.println("</select>"); 
			stateX.close();		  		  
			rsX.close();	
		}	
		%>
		<td width="5%">
			<input name="TSCPACKAGE" type="hidden" value=<%=TSCPACKAGE%>>
			<input name="LIMITDAYS" type="hidden" size="2" value=<%=LIMITDAYS%>>  
	   		<input name="UOM" tabindex="8" type="hidden" size="8" <%if (allMonth[4]!=null) out.println("value="); else out.println("value=");%>>
	   		<input name="REQUESTDATE" tabindex="13" type="text" size="7"  class="style2" maxlength="8" <%if (showSSD.equals("Y")) out.println("onfocus='subWindowSSDFind(2,this.form.PLANTCODE.value)'");%> <%if (allMonth[7]!=null) out.println("value="); else out.println("value=");%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>    
		</td>
		<!--ADD BY PEGGY 2012022-->
	    <td nowrap>
		<div align="center">
	    	<input type="text" name="LINEODRTYPE" tabindex="14" size="3" maxlength="5"  class="style2" >
            <INPUT TYPE="button" tabindex='15' value="."  class="style3" onClick='subWindowOrderTypeFind(this.form.LINEODRTYPE.value,this.form.PLANTCODE.value,null)'>
		</div>    	
		</td>
		<!--ADD BY PEGGY 2012022-->
		<td nowrap>
		<div align="center">
	    	<input type="text" name="LINETYPE" tabindex="16" size="3" maxlength="5"  class="style2" >
            <INPUT TYPE="button" tabindex='17' value="."  class="style3" onClick="subWindowLineTypeFind(this.form.LINETYPE.value,this.form.LINEODRTYPE.value,null)">
		</div>    	
		</td> 	
		<td nowrap>
		<div align="center">
	    	<input type="text" name="LINEFOB" size="5" maxlength="5"  class="style2"  readonly>
            <INPUT TYPE="button" tabindex='18' value="."  class="style3" onClick='subWindowFOBPointFind(this.form.LINEFOB.value,"LINE")'>
		</div>    	
		</td>					
		<td><div align="center">
	     	<input type="text" name="LNREMARK" tabindex="19"  size="7" maxlength="60"  class="style2" <%if (allMonth[8]!=null) out.println("value=''"); else out.println("value=''");%>>			 	 
		 </div>    
		</td>   
		<td><div align="center">
	    	<input type="text" name="CUSTPONO" tabindex="20"  size="7" maxlength="60"  class="style2" <%if (allMonth[9]!=null) out.println("value=''"); else out.println("value=''");%> onBlur="setPOObject(this.form.SALESAREANO.value,this.form.CUSTPONO.value)">			 	 
		 </div>    
		</td> 
		<%
		if(tsAreaNo.equals("001") || tsAreaNo.equals("009") || tsAreaNo.equals("006"))
		{
		%>
		<td nowrap>
		<div align="center">
	    	<input type="text" name="QUOTENUMBER" tabindex="21" size="8" maxlength="9"  value="<%=QUOTENUMBER%>" class="style2" onKeyPress="setPrice(this.form.SALESAREANO.value,this.form.QUOTENUMBER.value,this.form.ITEMDESC.value,this.form.INVITEM.value)" >
		</div>    	
		</td>   
		<%
		}
		if (POLINEFLAG.equals("Y"))
		{
		%> 	 		
		<td><div align="left">
	    	<input type="text" name="CUSTPOLINENO" tabindex="22"  size="5" maxlength="60"  class="style2" >			 	 
		 </div>    
		</td>
		<%
		}
		//if(tsAreaNo.equals("008"))
		//{
		%>
		<td nowrap>
		<div align="center">
	    	<input type="text" name="ENDCUSTOMER" tabindex="21" size="13" maxlength="50"  value=""  class="style2" onChange="custChange()">
	    	<input type="hidden" name="ENDCUSTOMERID" class="style3"  value="">
            <INPUT TYPE="button" value="."  class="style2" onClick='subWindowEndCustFind(this.form.CUSTOMERNO.value,this.form.SALESAREANO.value)'>
		</div>    	
		</td>   
		<%
		//}
		%> 
		<td><div align="center">
	    	<input type="text" name="PLANTCODE" tabindex="23"  size="2" maxlength="3" readonly  class="style2">			 	 
			<INPUT TYPE="button" id="btn1" name="btplant" tabindex="24"  value="."  class="style3" onClick='subWindowPlantFind(this.form.PLANTCODE.value)'>
		 </div>    
		</td> 
		<%
		if(tsAreaNo.equals("020"))  //add by Peggy 20160308
		{
		%>	
		<td nowrap>
		<%
			try
			{   
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt=con.prepareStatement(sql1);
				pstmt.executeUpdate(); 
				pstmt.close();	
						
				sql = " SELECT flv.lookup_code,flv.meaning"+
                             " FROM fnd_lookup_values flv"+
                             " WHERE flv.LOOKUP_TYPE = 'TSC_OM_DELIVERY_INS' "+
							 " AND flv.language ='US'";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				comboBoxBean.setRs(rs);
				//comboBoxBean.setSelection(direct_ship_to_cust);
				comboBoxBean.setFieldName("DIRECT_SHIP_TO_CUST");	
				comboBoxBean.setFontName("Tahoma,Georgia"); 
				comboBoxBean.setFontSize(10); 
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
		<%
		}
		%>			   
		
		<%
		if(tsCustomerID.equals("14980") || tsCustomerID.equals("15540"))  //add by Peggy 20170220
		{
		%>	
		<td nowrap>
		<%
			try
			{   
				sql = " SELECT A_VALUE,A_VALUE"+
                             " FROM oraddman.tsc_rfq_setup a"+
                             " WHERE A_CODE = 'BI_REGION' "+
							 " order by A_SEQ";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				comboBoxBean.setRs(rs);
				//comboBoxBean.setSelection(direct_ship_to_cust);
				comboBoxBean.setFieldName("BI_REGION");	
				comboBoxBean.setFontName("Tahoma,Georgia"); 
				comboBoxBean.setFontSize(10); 
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
		<%
		}
		if (tsAreaNo.equals("012"))  //add by Peggy 20170512
		{
		%>	
		<td nowrap>
			<input type="text" name="end_cust_ship_to_id" tabindex="23"  size="2" maxlength="5" class="style2">			
		</td> 
		<%		
		}
		%>			   
    </tr>
	<tr>
		<td colspan="12"><div align="center"><strong>
      	<%
		try
       	{
			if (v_conti_msg.equals("") || v_conti_msg.equals("OK") ||v_conti_msg.startsWith("Notice:")) //add by Peggy 20220921
			{		
				//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","Remark","Customer PO No.","Plant","SPQ","MOQ"};
				String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","Remark","Customer PO No.","Plant","SPQ","MOQ","Customer Item","Selling Price","Order<br>Type","Line<br>Type","FOB","Cust Po Line","Quote#","EndCustID","Shipping Marks","Remarks","EndCustomer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust PartNo"}; //modify by Peggy 20150519
				rfqArray2DTemporaryBean.setArrayString(oneDArray);
				String a[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容  	   			    
				int i=0,j=0,k=0;
				String dupFLAG="FALSE";
				if (( (invItem!=null && !invItem.equals("")) || (itemDescription!=null && !itemDescription.equals("")) ) && orderQty!=null && !orderQty.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
				{  //out.println("step1"); 
					String sqlUOM = ""; 
					if (invItem!=null && !invItem.equals("")) // 若輸入料號,抓說明及單位
					{ 
						sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE ,TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP "+ //20130319 add by Peggy TSC_PROD_GROUP
								 " ,TSC_ITEM_GREEN_CHECK(ORGANIZATION_ID,INVENTORY_ITEM_ID)  GREEN_FLAG"+
								 " from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and SEGMENT1 = '"+invItem+"' "+
								 " AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+   //add by Peggy 20151008
								 " AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"; //add by Peggy 20151008						      
					}       
					else 
					{ // 否則若輸入料號說明,抓料號及單位
						sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE  ,TSC_OM_CATEGORY(INVENTORY_ITEM_ID,ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP "+ //20130319 add by Peggy TSC_PROD_GROUP
								 " ,TSC_ITEM_GREEN_CHECK(ORGANIZATION_ID,INVENTORY_ITEM_ID)  GREEN_FLAG"+
								 " from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+itemDescription+"' "+
								 " AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+   //add by Peggy 20151008
								 " AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"; //add by Peggy 20151008						      
					} 					
					// 依使用者輸入的料號ID取其單位
					Statement stateUOM=con.createStatement();			  
					ResultSet rsUOM=stateUOM.executeQuery(sqlUOM); 
					if (rsUOM.next())
					{
						uom =  rsUOM.getString("PRIMARY_UOM_CODE");   
						invItem = rsUOM.getString("SEGMENT1"); 
						itemDescription = rsUOM.getString("DESCRIPTION"); 
						tsc_prod_group = rsUOM.getString("TSC_PROD_GROUP");  //add by Peggy 20130319
						greenFlag = rsUOM.getString("GREEN_FLAG"); //add by Peggy 20150519								
					} 
					else 
					{ 
			%>
						   <script LANGUAGE="JavaScript">                        
						   subWindowItemFind("<%=invItem%>","<%=itemDescription%>","<%=sampleOrder%>","<%=tsCustomerID%>","<%=tsAreaNo%>","<%=priceList%>");                   
						   </script> 
			<%
						 // 若找不到,則呼叫料號尋找視窗,並將料號及料號說明給沒填入的欄位
						if (itemDescription==null || itemDescription.equals("")) itemDescription = invItem;
						else if (invItem==null || invItem.equals("")) invItem = itemDescription;
						uom = "KPC";
						tsc_prod_group =""; //add by Peggy 20130319
					}
					rsUOM.close();
					stateUOM.close();
					
					//add by Peggy 20130305
					Statement statea=con.createStatement();
					String sqla = " SELECT 1,substr(replace(replace('"+custPONo+"','（','('),'）',')'),instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPONo+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
						   " FROM oraddman.tsc_om_remarks_setup a "+
						   " where TSAREANO='"+tsAreaNo+"'"+
						   //" AND USER_NAME ='"+UserName+"'"+
						   " AND substr(replace(replace('"+custPONo+"','（','('),'）',')'),instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPONo+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1)) LIKE '%' || customer||'%'"+
						   " AND ORDER_TYPE ='"+ordertype+"'"+
						   " UNION ALL"+
						   " SELECT 2,substr(replace(replace('"+custPONo+"','（','('),'）',')'),instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+custPONo+"','（','('),'）',')'),')')-(instr(replace(replace('"+custPONo+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
						   " FROM oraddman.tsc_om_remarks_setup a "+
						   " where TSAREANO='"+tsAreaNo+"'"+
						   //" AND USER_NAME ='"+UserName+"'"+
						   " AND customer='ALL'"+
						   " AND ORDER_TYPE ='"+ordertype+"'"+					   
						   " ORDER BY 1";
					//out.println(sqla);
					ResultSet rsa=statea.executeQuery(sqla);
					if (rsa.next())
					{
						shipping_Marks= rsa.getString("shipping_marks");
						shipping_Marks = shipping_Marks.replace("?01",(rsa.getString("customer")==null?custPONo:rsa.getString("customer")));
						remarks = rsa.getString("remarks");
						remarks = remarks.replace("?02",(greenFlag.equals("Y")?"green compound":""));  //modify by Peggy 20150519
						//if (invItem.substring(10,11).equals("1"))
						//if (invItem.substring(10,11).equals("1") || (tsc_prod_group.equals("PMD") && invItem.substring(3,4).equals("G"))) //PMD料號22碼中第四碼為G表GREEN COMPOUND,add by Peggy 20130319
						//{ 
						//	remarks = remarks.replace("?02","green compound"); 
						//}
						//else
						//{
						//	remarks = remarks.replace("?02",""); 
						//}
					} 
					else 
					{ 
						shipping_Marks=""; 
						remarks ="";
					} 
					rsa.close();
					statea.close();
					
					// 依使用者輸入的料號ID取其單位 			    
					if (a!=null) 
					{ 
						String b[][]=new String[a.length+1][a[i].length];		    			 
						for (i=0;i<a.length;i++)
						{
							for (j=0;j<a[i].length;j++)
							{ 
								b[i][j]=a[i][j];
							} // End of for (j=0)
							k++;
						}// End of for (i=0) 
				  
						iNo = Integer.toString(k);  // 把料項序號給第一個位置
				 
						b[k-1][0]=iNo;
						b[k-1][1]=invItem;
						b[k-1][2]=itemDescription;
						b[k-1][3]=orderQty;
						b[k-1][4]=uom;
						b[k-1][5]=(custrequestDate=="")?"":custrequestDate; //add by Peggychen 20110622
						b[k-1][6]=(shippingMethod=="")?"":shippingMethod; //add by Peggychen 20110622
						b[k-1][7]=requestDate;
						b[k-1][8]=lnRemark;
						if (custPONo==null || custPONo.equals(""))
						{
							custPONo=custPO;
							if(tsAreaNo.equals("020") && (custPONo.toUpperCase().indexOf("(K)")>=0 || custPONo.toUpperCase().indexOf("KOREA")>=0))
							{
								direct_ship_to_cust="1";
							}
						}
						b[k-1][9]=custPONo;
						b[k-1][10]=plantCode;
						// 20110310 Marvie Add : Add Field  SPQ MOQ
						b[k-1][11]=spqp; // SPQ
						b[k-1][12]=moqp; // MOQ
						b[k-1][13]=custItem;     //add by Peggy 20120222
						b[k-1][14]=(sellingprice==null || sellingprice.equals("null"))?"":sellingprice; //add by Peggy 20120222
						b[k-1][15]=ordertype;    //add by Peggy 20120222
						b[k-1][16]=linetype;     //add by Peggy 20120222
						b[k-1][17]=(lineFob==null||lineFob.equals(""))?FOB_POINT:lineFob;      //add by Peggy 20120329
						b[k-1][18]=custPOLineNo;  //add by Peggy 20120531
						b[k-1][19]=QUOTENUMBER;   //add by Peggy 20120905
						//b[k-1][20]=ENDCUSTOMER;   //add by Peggy 20121107
						b[k-1][20]=ENDCUSTOMERID;   //modify by Peggy 20140813
						b[k-1][21]=shipping_Marks; //add by Peggy 20130305
						b[k-1][22]=remarks;        //add by Peggy 20130305
						b[k-1][23]=ENDCUSTOMER;    //modify by Peggy 20140813
						b[k-1][24]="";       //add by Peggy 20150519
						b[k-1][25]=direct_ship_to_cust; //add by Peggy 20160308
						b[k-1][26]=BI_REGION;           //add by Peggy 20170218
						b[k-1][27]=end_cust_ship_to_id; //add by Peggy 20170512
						b[k-1][28]=endCustPartNo;       //add by Peggy 20190225
						rfqArray2DTemporaryBean.setArray2DString(b);
					} 
					else 
					{	
						//String c[][]={{iNo,invItem,itemDescription,orderQty,uom,custrequestDate,shippingMethod,requestDate,lnRemark,custPONo,plantCode,moqp,spqp}};
						//String c[][]={{iNo,invItem,itemDescription,orderQty,uom,custrequestDate,shippingMethod,requestDate,lnRemark,custPONo,plantCode,spqp,moqp,custItem,sellingprice,ordertype,linetype,(lineFob==null||lineFob.equals(""))?FOB_POINT:lineFob}}; //modify by Peggy 20120222
						String c[][]={{iNo,invItem,itemDescription,orderQty,uom,custrequestDate,shippingMethod,requestDate,lnRemark,custPONo,plantCode,spqp,moqp,custItem,sellingprice,ordertype,linetype,(lineFob==null||lineFob.equals(""))?FOB_POINT:lineFob,custPOLineNo,QUOTENUMBER,ENDCUSTOMER,"","","","",direct_ship_to_cust,end_cust_ship_to_id,endCustPartNo}}; //modify by Peggy 20150519
						rfqArray2DTemporaryBean.setArray2DString(c);
					}                   	                       		        		  
				} 
				else 
				{ //out.println("step6:未輸入欄位內容作 Add ,表示點擊刪除鍵");
					if (a!=null) 
					{ 
						//add by Peggy 20140331
						//if (UserName.equals("COCO"))
						if (tsAreaNo.equals("018")) //modify by Peggy 20171221
						{
							for (int g=0 ; g < a.length ; g++)
							{
								if (a[g][15]!=null && !a[g][15].equals(""))
								{
									Statement statea=con.createStatement();
									String sqla = " SELECT 1,substr(replace(replace('"+a[g][9]+"','（','('),'）',')'),instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),')')-(instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
												  " FROM oraddman.tsc_om_remarks_setup a "+
												  " where TSAREANO='"+tsAreaNo+"'"+
												  //" AND USER_NAME ='"+UserName+"'"+
												  " AND substr(replace(replace('"+a[g][9]+"','（','('),'）',')'),instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),')')-(instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1)) LIKE '%' || customer||'%'"+
												  " AND ORDER_TYPE ='"+a[g][15]+"'"+
												  " UNION ALL"+
												  " SELECT 2,substr(replace(replace('"+a[g][9]+"','（','('),'）',')'),instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1,instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),')')-(instr(replace(replace('"+a[g][9]+"','（','('),'）',')'),'(')+1)) customer,a.shipping_marks, a.remarks"+
												  " FROM oraddman.tsc_om_remarks_setup a "+
												  " where TSAREANO='"+tsAreaNo+"'"+
												  //" AND USER_NAME ='"+UserName+"'"+
												  " AND customer='ALL'"+
												  " AND ORDER_TYPE ='"+a[g][15]+"'"+					   
												  " ORDER BY 1";
									//out.println(sqla);
									ResultSet rsa=statea.executeQuery(sqla);
									if (rsa.next())
									{
										shipping_Marks= rsa.getString("shipping_marks");
										shipping_Marks = shipping_Marks.replace("?01",(rsa.getString("customer")==null?a[g][9]:rsa.getString("customer")));
										remarks = rsa.getString("remarks");
										remarks = remarks.replace("?02",(greenFlag.equals("Y")?"green compound":""));  //modify by Peggy 20150519
										//if (a[g][1].substring(10,11).equals("1") ||  a[g][1].substring(3,4).equals("G")) //PMD料號22碼中第四碼為G表GREEN COMPOUND,add by Peggy 20130319
										//{ 
										//	remarks = remarks.replace("?02","green compound"); 
										//}
										//else
										//{
										//	remarks = remarks.replace("?02",""); 
										//}
									} 
									else 
									{ 
										shipping_Marks=""; 
										remarks ="";
									} 
									rsa.close();
									statea.close();	
									a[g][21]=shipping_Marks;
									a[g][22]=remarks;					
								}
							}
						}
						rfqArray2DTemporaryBean.setArray2DString(a);     			       	                
					} 
				}
		 	}
			
		 	custINo = Integer.toString(Integer.parseInt(custINo) + 1);
		 	if (custINo==iNo)
		 	{		 
		 	} 
			else 
			{
		    	custINo = iNo;
		    }
		 	//###################針對目前陣列內容進行檢查機制#############################		  
		  	String T2[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
		  	if  (T2!=null) 
		  	{  		   
		    	//-------------------------取得轉存用陣列-------------------- 		    
	        	String temp[][]=new String[T2.length][T2[0].length];		    
			 	for (int ti=0;ti<T2.length;ti++) 
				{
			    	for (int tj=0;tj<T2[ti].length;tj++) 
					{
				  		if (tj==0)
						{
							temp[ti][tj]=T2[ti][tj];
						}
				  		else if (tj==1 || tj==2)
						{
							temp[ti][tj]="D";
						}
				  		else if (tj>=3 && tj<=14)
						{
							//if ((showSSD.equals("Y") && (tj ==5 || tj==6)) || (tj!=5 && tj!=6)) //顯示CRD,SHIPPINGMETHOD
							if (((showSSD.equals("Y") || showSSD.equals("X")) && (tj ==5 || tj==6)) || (showSSD.equals("S") && tj==6) || (tj!=4 && tj!=5 && tj!=6 && tj!=11 && tj!=12 && tj!=13)) //modify by Peggy 20120209
							{					
								temp[ti][tj]="U";
							}
							else
							{
								temp[ti][tj]="D";
							}						
						}
						else if (tj==15 || tj==16 || tj==17) //ORDER TYPE,LINE TYPE,FOB add by Peggy 20120328
						{
							temp[ti][tj]="B";
						}
						else if (tj==18)
						{
							if	(POLINEFLAG.equals("Y"))
							{
								temp[ti][tj]="U";
							}
							else
							{
								temp[ti][tj]="D";
							}
						}
						else if (tj==19)
						{
							if (tsAreaNo.equals("001"))
							{
								temp[ti][tj]="U";
							}
							else
							{
								temp[ti][tj]="D";
							}
						}
						else if (tj==20)   //add by Peggy 20121107
						{
							if (tsAreaNo.equals("008"))
							{
								temp[ti][tj]="U";
							}
							else
							{
								temp[ti][tj]="D";
							}
						}
						//else if ((tj==21 || tj ==22) && UserName.equals("COCO"))
						else if ((tj==21 || tj ==22) && tsAreaNo.equals("018"))  //modify by Peggy 20171221
						{
							temp[ti][tj]="U";
						}
				  		else 
						{
							temp[ti][tj]="P";
						}
					}
		      	}		
		    //--------------------------------------------------------------------
		     	rfqArray2DTemporaryBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
		  	} 
			else 
			{    		      		     
		    	rfqArray2DTemporaryBean.setArray2DCheck(null);
		  	}	 //end if of T2!=null	   
		 	//##############################################################	    	 
       	} //end of try
       	catch (Exception e)
       	{
        	out.println("Exception3:"+e.getMessage());
       	}
	 	%></strong></div>	 
	 	</td> 
	</tr>
</table> 
<table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">	
	<tr bgcolor="#99CCFF">
  		<td>
     		<input name="button" tabindex='25' type=button onClick="this.value=check(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
     <font color="#336699" size="2">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
	 <%
			//隱藏下拉選單,submit前用來檢查資料是否正確
			//生產廠別
		   	Statement stateGetP=con.createStatement();
		   	ResultSet rsGetP=null;				      									  
		   	String sqlGetP = "select MANUFACTORY_NO as PRODMANUFACTORY, MANUFACTORY_NO||'  '||MANUFACTORY_NAME  "+
							"from ORADDMAN.TSPROD_MANUFACTORY "+
							"where MANUFACTORY_NO > 0 "+																  
							 "order by MANUFACTORY_NO "; 
            rsGetP=stateGetP.executeQuery(sqlGetP);
			out.println("<select NAME='PLANTLIST'  style='visibility: hidden;>");				  			  
	        out.println("<OPTION VALUE=-->--");     
	        while (rsGetP.next())
	        {            
		    	String s1=(String)rsGetP.getString(1); 
		        String s2=(String)rsGetP.getString(2); 
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
	        }
	        out.println("</select>"); 
			stateGetP.close();		  		  
			rsGetP.close();
			//訂單類型
			Statement stateGetA=con.createStatement();
		   	String sqlGetA = " SELECT DISTINCT B.MANUFACTORY_NO ||'-'||A.ORDER_NUM ,A.ORDER_NUM FROM ORADDMAN.TSAREA_ORDERCLS  A ,ORADDMAN.TSPROD_ORDERTYPE B "+
                             " WHERE A.ACTIVE ='Y'  AND A.ORDER_NUM = B.ORDER_NUM  and A.SAREA_NO = '"+tsAreaNo+"' order by 2  "; 
			//out.println("sqlGetA="+sqlGetA);
            ResultSet rsGetA=stateGetA.executeQuery(sqlGetA);
			out.println("<select NAME='ORDERLIST'  style='visibility: hidden;'>");				  			  
	        out.println("<OPTION VALUE=-->--");     
	        while (rsGetA.next())
	        {            
		    	String s1=(String)rsGetA.getString(1); 
		        String s2=(String)rsGetA.getString(2); 
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
	        }
	        out.println("</select>"); 
			stateGetA.close();		  		  
			rsGetA.close();		
			//LINETYPE
			Statement stateGetB=con.createStatement();
		   	String sqlGetB = " select c.ORDER_NUM ||'-'|| wf.LINE_TYPE_ID, vl.name as LINE_TYPE"+
                             " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl ,ORADDMAN.TSAREA_ORDERCLS c"+
                             " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
                             " and vl.language = 'US' "+
                             " and c.OTYPE_ID= wf.ORDER_TYPE_ID"+
                             " and c.SAREA_NO = '"+tsAreaNo+"' "+
                             " and c.ACTIVE ='Y' "+
                             " and END_DATE_ACTIVE is NULL "+
                      		"  ORDER BY 1	 "; 
            ResultSet rsGetB=stateGetB.executeQuery(sqlGetB);
			out.println("<select NAME='LINETYPELIST'  style='visibility: hidden;>");				  			  
	        out.println("<OPTION VALUE=-->--");     
	        while (rsGetB.next())
	        {            
		    	String s1=(String)rsGetB.getString(1); 
		        String s2=(String)rsGetB.getString(2); 
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
	        }
	        out.println("</select>"); 
			stateGetB.close();		  		  
			rsGetB.close();		
	 %>
  		</td>
	</tr>
	<tr bgcolor="#99CCFF">
  		<td> 
  <font size="2" color="#000066"><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></font>
      : <font size="2" color="#666666"><jsp:getProperty name="rPH" property="pgQDocNo"/>:</font><font size="2" color="#006699"><%=dnDocNo%></font> 
	  <BR> 
  		<% 
		int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
	  	try
      	{	
	    	String a[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容 
         	if (a!=null) 
		 	{	
		    	div1=a.length;
				div2=a[0].length;				
	        	rfqArray2DTemporaryBean.setFieldName("ADDITEMS");	
				rfqArray2DTemporaryBean.setClickEvent("subWindowLineClickEvent");		
				rfqArray2DTemporaryBean.setEventName(" onChange=setsubmitChg();");	 //add by Peggy 20150908
				out.println(rfqArray2DTemporaryBean.getArray2DTempString());  // 用Item 及Item Description 作為Key 的Method				
				isModelSelected = "Y";	// 若Model 明細內有任一筆資料,則為 "Y" 		
				
		 	}	//enf of a!=null if		
		 	else if (a==null)    // 2006/02/20 判斷若陣列內為空值,則取於資料庫內的 Temporary內容置入鎮列
		    {
				rfqArray2DTemporaryBean.setFieldName("ADDITEMS");
				rfqArray2DTemporaryBean.setClickEvent("subWindowLineClickEvent");
				rfqArray2DTemporaryBean.setEventName(" onChange=setsubmitChg();");	 //add by Peggy 20150908
			    int k=0;
				//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","CRDate","Shipping<br>Method","Request Date","Remark","Customer PO No.","Plant","SPQ","MOQ"};
				String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","CRDate","Shipping<br>Method","Request Date","Remark","Customer PO No.","Plant","SPQ","MOQ","Customer Item","Selling Price","Order<br>Type","Line<br>Type","FOB","Cust PO Line","Quote#","EndCustID","Shipping Marks","Remarks","EndCustomer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust PartNo"}; //modify by Peggy 20150519
    	        rfqArray2DTemporaryBean.setArrayString(oneDArray);				  
	            // 先取 該詢問單筆數
	            int rowLength = 0;
	            Statement stateCNT=con.createStatement();
                ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL "+ 
				 " where DNDOCNO='"+dnDocNo+"' and LSTATUSID = '"+frStatID+"' ");	
	            if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	            rsCNT.close();
	            stateCNT.close();
	        
				String r[][]=new String[rowLength+1][29];
	            String sqlEst = "select a.LINE_NO, a.ITEM_SEGMENT1,a.ITEM_DESCRIPTION, a.QUANTITY, a.UOM, a.REQUEST_DATE, a.REMARK,"+
				                " a.ASSIGN_MANUFACT, a.FTACPDATE, a.PCACPDATE, a.EDIT_CODE, a.CUST_PO_NUMBER, a.ASSIGN_MANUFACT,"+
							    " a.SPQ, a.MOQ,a.CUST_REQUEST_DATE,a.SHIPPING_METHOD"+
								" ,decode(a.ORDERED_ITEM_ID,a.INVENTORY_ITEM_ID,'N/A',a.ORDERED_ITEM) ORDERED_ITEM"+ //add by Peggy 20220223
								" ,nvl((select b.order_num from oraddman.tsarea_ordercls b where b.sarea_no ='"+tsAreaNo+"' and  TO_CHAR(a.order_type_id) = b.OTYPE_ID),'N/A') ORDER_TYPE"+
								" ,a.SELLING_PRICE,a.LINE_TYPE,nvl(a.FOB,b.FOB_POINT) FOB" + //add by Peggy 20120222
								" ,nvl(a.CUST_PO_LINE_NO,'') CUST_PO_LINE_NO"+//add by Peggy 20120531
								", nvl(a.quote_number,'') QUOTE_NUMBER"+      //add by Peggy 20120917
								", nvl(a.end_customer,'') END_CUSTOMER"+      //add by Peggy 20121107
								", nvl(c.SHIPPING_MARKS,'') SHIPPING_MARKS"+  //add by Peggy 20130305
								", nvl(c.REMARKS,'') REMARKS"+                //add by Peggy 20130305
								", d.customer_number end_customer_id"+        //add by Peggy 20140813
								", a.orig_so_line_id"+                        //add by Peggy 20150519
								", a.direct_ship_to_cust"+                    //add by Peggy 20160316
								", a.bi_region"+                              //add by Peggy 20170218
								", nvl((select location from AR.HZ_CUST_SITE_USES_ALL hcsu where hcsu.SITE_USE_ID=a.END_CUSTOMER_SHIP_TO_ORG_ID),'') end_cust_ship_id"+ //add by Peggy 20170512
								", a.end_customer_partno"+                    //add by Peggy 20190225
								" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,ORADDMAN.TSDELIVERY_NOTICE b,oraddman.tsdelivery_notice_remarks c"+
								",ar_customers d"+
								" where a.DNDOCNO='"+dnDocNo+"' "+
								" and a.LSTATUSID = '"+frStatID+"'"+
								" and a.DNDOCNO=b.DNDOCNO"+
								" and a.DNDOCNO=c.DNDOCNO(+)"+
								" and a.LINE_NO=c.LINE_NO(+)"+
								" and a.end_customer_id=d.customer_id(+)"+
								" order by a.LINE_NO"; 
                Statement statement=con.createStatement();
                ResultSet rs=statement.executeQuery(sqlEst);
	            while (rs.next())
	            {			       
					iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
                    lnRemark=rs.getString("REMARK");
                    custPONo=rs.getString("CUST_PO_NUMBER");
					custPOLineNo=rs.getString("CUST_PO_LINE_NO");  //add by Peggy 20120531
                    plantCode=rs.getString("ASSIGN_MANUFACT");
                    if (lnRemark==null || lnRemark.equals("null")) lnRemark="";
					if (custPONo==null || custPONo.equals("null")) custPONo="";
					if (plantCode==null || plantCode.equals("null")) plantCode="";
					if (custPOLineNo==null || custPOLineNo.equals("null")) custPOLineNo="";

			        r[k][0]=rs.getString("LINE_NO");
			        r[k][1]=rs.getString("ITEM_SEGMENT1");
					r[k][2]=rs.getString("ITEM_DESCRIPTION");
					//r[k][3]=Float.toString(rs.getFloat("QUANTITY"));
					r[k][3]=rs.getString("QUANTITY");  //modify by Peggy 20200714
					r[k][4]=rs.getString("UOM");
			  		r[k][5]=(rs.getString("CUST_REQUEST_DATE")==null?"":rs.getString("CUST_REQUEST_DATE")); //add by Peggychen 20110622
			  		r[k][6]=(rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD"));     //add by Peggychen 20110622
					if (rs.getString("REQUEST_DATE") == null || rs.getString("REQUEST_DATE").length()<8)
					{
						r[k][7]=rs.getString("REQUEST_DATE");
					}
					else
					{
						r[k][7]=rs.getString("REQUEST_DATE").substring(0,8);
					}
					r[k][8]=lnRemark;
					r[k][9]=(custPONo.equals("") || custPONo ==null)?custPO:custPONo;
					r[k][10]=plantCode;
   			        r[k][11]=rs.getString("SPQ");
					r[k][12]=rs.getString("MOQ");
					r[k][13]=rs.getString("ORDERED_ITEM");
					r[k][14]=(rs.getString("SELLING_PRICE")==null || rs.getString("SELLING_PRICE").equals("null"))?"":rs.getString("SELLING_PRICE");
					r[k][15]=(rs.getString("ORDER_TYPE")==null?"N/A":rs.getString("ORDER_TYPE"));
					r[k][16]=rs.getString("LINE_TYPE");
					r[k][17]=(rs.getString("FOB")==null || rs.getString("FOB").equals("null")?"":rs.getString("FOB"));
					r[k][18]=custPOLineNo; //add by Peggy 20120531
					r[k][19]=(rs.getString("QUOTE_NUMBER")==null || rs.getString("QUOTE_NUMBER").equals("null"))?"":rs.getString("QUOTE_NUMBER");               //add by Peggy 20120905
					r[k][20]=(rs.getString("END_CUSTOMER_ID")==null || rs.getString("END_CUSTOMER_ID").equals("null"))?"":rs.getString("END_CUSTOMER_ID");      //add by Peggy 20140813
					r[k][21]=(rs.getString("SHIPPING_MARKS")==null || rs.getString("SHIPPING_MARKS").equals("null"))?"":rs.getString("SHIPPING_MARKS");         //add by Peggy 20130305
					r[k][22]=(rs.getString("REMARKS")==null || rs.getString("REMARKS").equals("null"))?"":rs.getString("REMARKS");                              //add by Peggy 20120305
					r[k][23]=(rs.getString("END_CUSTOMER")==null || rs.getString("END_CUSTOMER").equals("null"))?"":rs.getString("END_CUSTOMER");      //add by Peggy 20140813
					r[k][24]=(rs.getString("orig_so_line_id")==null?"":rs.getString("orig_so_line_id"));  //orig so line id,add by Peggy 20150519					
					r[k][25]=(rs.getString("direct_ship_to_cust")==null?"":rs.getString("direct_ship_to_cust"));  //direct_ship_to_cust,add by Peggy 20160308
					r[k][26]=(rs.getString("bi_region")==null?"":rs.getString("bi_region"));  //bi_region,add by Peggy 20170218
					r[k][27]=(rs.getString("end_cust_ship_id")==null?"":rs.getString("end_cust_ship_id"));  //bi_region,add by Peggy 20170512
					r[k][28]=(rs.getString("end_customer_partno")==null?"":rs.getString("end_customer_partno"));  //end_customer_partno,add by Peggy 20190225
					k++;
				}
				rs.close();
				statement.close();
				   
			    rfqArray2DTemporaryBean.setArray2DString(r);
  			    String q[][]=rfqArray2DTemporaryBean.getArray2DContent();//取得目前陣列內容 	
                if (q!=null) 
		        {
					String cct[][] = new String[q.length][q[0].length];
			        for (int ti=0;ti<q.length;ti++) 
					{
			        	for (int tj=0;tj<q[ti].length;tj++) 
						{
				        	if (tj==0)
							{
								cct[ti][tj]=q[ti][tj];
							}
				        	else if (tj==1 || tj==2) 
							{
								cct[ti][tj]="D";
							}
				        	else if (tj>=3 && tj<=14)
							{
								//if ((showSSD.equals("Y") && (tj ==5 || tj==6)) || (tj!=5 && tj!=6)) //顯示CRD,SHIPPINGMETHOD
								if (((showSSD.equals("Y") || showSSD.equals("X")) && (tj ==5 || tj==6)) || (showSSD.equals("S") && tj==6) || (tj!=4 && tj!=5 && tj!=6 && tj!=11 && tj!=12 && tj!=13)) //modify by Peggy 20120209
								{					
									cct[ti][tj]="U";
								}
								else
								{
									cct[ti][tj]="D";
								}
							}
							else if (tj==15 || tj==16 || tj==17) //ORDER TYPE,LINE TYPE,FOB add by Peggy 20120328
							{
								cct[ti][tj]="B";
							}
							else if (tj==18)  //add by Peggy 20120531
							{
								if	(POLINEFLAG.equals("Y"))
								{
									cct[ti][tj]="U";
								}
								else
								{
									cct[ti][tj]="D";
								}
							}
							else if (tj==19)
							{
								if (tsAreaNo.equals("001"))
								{
									cct[ti][tj]="U";
								}
								else
								{
									cct[ti][tj]="D";
								}
							}
							else if (tj==20)  //add by Peggy 20121107
							{
								if (tsAreaNo.equals("008"))
								{
									cct[ti][tj]="U";
								}
								else
								{
									cct[ti][tj]="D";
								}
							}
							//else if ((tj==21 || tj ==22) && UserName.equals("COCO"))
							else if ((tj==21 || tj ==22) && tsAreaNo.equals("018"))  //modify by Peggy 20171221
							{
								cct[ti][tj]="T";
							}
				        	else
							{
								cct[ti][tj]="P";
							}
				      	}
		        	}
					rfqArray2DTemporaryBean.setArray2DCheck(cct);
					out.println(rfqArray2DTemporaryBean.getArray2DTempString());
				}
			} // end of if (a==null)
       } //end of try
       catch (Exception e)
       {
       		out.println("Exception4:"+e.getMessage());
       }
       %>
      	</td>
    </tr>
	<tr bgcolor="#99CCFF">
		<td>
			<INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmit6("../jsp/TSSalesDRQTemporaryPage.jsp","<%=dnDocNo%>","<%="Y"%>")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
          	<% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699' size='2'>-----CLICK checkbox and choice to delete---------------------------------------------------------------------------------------------------"); 
		  	%>
		</td>
	</tr>
 </table>
<HR>

<table align="left">
	<tr>	
		<td colspan="3">
			<strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
			<a name='#ACTION'>
			<%
			try
			{  
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME "+
					   " from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
					   " WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
				out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQTemporaryPage.jsp"+
				"?LSTATUSID=001&INSERT=Y&DNDOCNO="+dnDocNo+'"'+")'>");				  				  
				out.println("<OPTION VALUE=-->--");     
				while (rs.next())
				{    
					if ( !rs.getString(1).equals("021") || (rs.getString(1).equals("021") && UserRoles.equals("admin")))
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
				} //end of while
				out.println("</select>"); 
				rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
				" WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
				rs.next();
				if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
				{
					out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='submitCheck("+'"'+"../jsp/TSSalesDRQMProcess.jsp?DNDOCNO="+dnDocNo+"&PROGRAMNAME="+sProgramName+'"'+","+'"'+"");
						  %><jsp:getProperty name="rPH" property="pgAlertCancel"/><%out.print(""+'"'+","+'"'+"");
						  %><jsp:getProperty name="rPH" property="pgAlertSubmit"/><%out.print(""+'"'+","+'"'+"");
						  %><jsp:getProperty name="rPH" property="pgAlertAssign"/><%out.print(""+'"'+","+'"'+"");				  
						  %><jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/><%out.print(""+'"'+")'>");
				 
					out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
				} 
				rs.close();       
				statement.close();
			} //end of try
			catch (Exception e)
			{
				out.println("Exception5:"+e.getMessage());
			}
			%>
			</a>
		</td>
	</tr>
	<% 
	//add by Peggy 20111103,當執行動作為abort,須填入cancel單原因
	if (actionID != null && actionID.equals("013"))
	{
	%>
	<tr>
		<td>
		<font color='#0000ff'><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
		<input type="text" name="CancelReason" size="60" maxlength="60" value="<%=CancelReason%>"></font>
		</td>
	</tr>
	<%
	}
	%>
</table>
<!-- 表單參數 --> 
<input type="hidden" size="10" name="MOQP" <%if (moqp!=null) out.println("value="); else out.println("value=");%>>
<input type="hidden" size="10" name="SPQP" <%if (spqp!=null) out.println("value="); else out.println("value=");%>><!--add by Peggy 20120516-->
<input name="LSTATUSID" type="hidden" value="<%=frStatID%>" >
<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
<input type="hidden" size="10" name="SORDERCHECK" value="<%=%>">	
<input type="hidden" size="10" name="SAMPLEORDER" value="<%=sampleOrder%>">
<input type="hidden" size="10" name="CUSTOMERID" value="<%=customerNo%>">
<input type="hidden" size="10" name="SALESAREANO" value="<%=tsAreaNo%>">
<input type="hidden" size="10" name="showCRD" value="<%=showSSD%>">
<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
<input name="maxDate" type="hidden" value="<%=maxDate%>">
<input name="maxDate1" type="hidden" value="<%=maxDate1%>">
<input type="hidden" name="CUSTMARKETGROUP" value="<%=CUSTMARKETGROUP%>">
<input type="hidden" name="POLINEFLAG" value="<%=POLINEFLAG%>">
<input type="hidden" name="TSCUSTOMERID" value="<%=tsCustomerID%>">
<input type="hidden" name="FOBPOINT" value="<%=FOB_POINT%>">
<input type="hidden" name="DELIVERTOOD" value="<%=deliveryToOrg%>">
<input type="hidden" name="PROGRAMNAME" value="<%=sProgramName%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
