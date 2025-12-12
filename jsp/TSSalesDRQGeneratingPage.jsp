<!-- 20160219 Peggy,顯示上海內銷012 end customer-->
<!-- 20160222 Peggy,yew回T訂單1141,1131,1121檢查ITEM是否ASSIGN Y2-->
<!-- 20170216 Peggy,add sales region for bi-->
<!-- 20171221 Peggy,TSCH-HK RFQ region code from 002 change to 018-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat,java.text.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Generating Sales Order</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DGenerateSOrderBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
	if (checkflag == "false") 
	{
		//modify by Peggy 20120712
		if (field.length == undefined)
		{
			if (field.style.visibility != "hidden")
			{
				field.checked = true;
				setchk(0);
			}
		}
		else
		{
			for (i = 0; i < field.length; i++) 
			{
				if (field[i].style.visibility != "hidden")
				{
					field[i].checked = true;
					setchk(i);
				}
			}
		}
		checkflag = "true";
 		return "Cancel Selected"; 
	}
 	else 
	{
		//modify by Peggy 20120712
		if (field.length == undefined)
		{
			if (field.style.visibility != 'hidden')
			{		
				field.checked = false;
			}
		}
		else
		{
			for (i = 0; i < field.length; i++) 
			{
				if (field[i].style.visibility != 'hidden')
				{			
					field[i].checked = false; 
				}
			}
		}
 		checkflag = "false";
 		return "Select All"; 
	}
}

document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal")	gfPop.fHideCal();	
}

function submitCheck(ms1,ms2,ms3,ms4,ms5,ms6,ms7,ms8,ms9,ms10,ms11)
{  
	// 先卡住未選任何動作按下Submit ...
	if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null) // 表示無選擇任何動作點擊 Submit鈕
   	{  
		alert(ms2);   
     	return(false);	  	
   	} 
	else if (document.DISPLAYREPAIR.ACTIONID.value!="012")  //表示動作清單不為COMPLETE,可能是自行輸入LINE_ID,因此需卡住
	{ //先卡住未選任何動作按下Submit ...
    	alert("Error !!!\n Don't try key-in invalid line No in this page...");   
        return(false);
    }   
   //     
   	if (document.DISPLAYREPAIR.ACTIONID.value=="012")  //表示為確認送出產生訂單動作
   	{ 
    	flag=confirm(ms1);      
    	if (flag==false)
		{
			return(false);
		}
		else
        {   // 若確認送出再檢查
        	if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null) // 表示無選擇任何動作點擊 Submit鈕
          	{ 
           		alert(ms2);   
           		return(false);
          	} 
          	if (document.DISPLAYREPAIR.FIRMORDERTYPE.value=="--" || document.DISPLAYREPAIR.FIRMORDERTYPE.value==null) // 未選擇訂單類型
          	{ 
           		alert(ms3);   
           		return(false);
          	} 
          	if (document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="--" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value==null) // 未選擇客戶
          	{ 
           		alert(ms4);   
           		return(false);
          	}
          	if (document.DISPLAYREPAIR.FIRMPRICELIST.value=="--" || document.DISPLAYREPAIR.FIRMPRICELIST.value==null) // 未選擇價格表
          	{ 
           		alert(ms5);   
           		return(false);
          	} 
          	if (document.DISPLAYREPAIR.SHIPTOORG.value=="" || document.DISPLAYREPAIR.SHIPTOORG.value==null) // 未選擇出貨地
          	{ 
           		alert(ms6);   
           		return(false);
          	}
          	if (document.DISPLAYREPAIR.BILLTO.value=="" || document.DISPLAYREPAIR.BILLTO.value==null) // 未選擇立帳地
          	{ 
           		alert(ms7);   
           		return(false);
          	} 
          	if (document.DISPLAYREPAIR.PAYTERMID.value=="" || document.DISPLAYREPAIR.PAYTERMID.value==null) // 未選擇付款條件
          	{ 
           		alert(ms8);   
           		return(false);
          	}
          	if (document.DISPLAYREPAIR.FOBPOINT.value=="" || document.DISPLAYREPAIR.FOBPOINT.value==null) // 未選擇FOB
          	{ 
           		alert(ms9);   
           		return(false);
          	}
          	if (document.DISPLAYREPAIR.SHIPMETHOD.value=="" || document.DISPLAYREPAIR.SHIPMETHOD.value==null) // 未選擇出貨方式
          	{ 
           		alert(ms10);   
           		return(false);
          	}  
		  	// 若未選擇任一Line 作動作,則警告
          	var chkFlag="FALSE";
			for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
			{
				if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
				{
					chkFlag="TURE";
				} 
			}  // End of for	 
			//if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
			//modify by Peggy 20120301
			if (chkFlag=="FALSE" && (document.DISPLAYREPAIR.CHKFLAG.length!=null || document.DISPLAYREPAIR.CHKFLAG.length == undefined))
			{
				alert(ms11);   
				return(false);
			}
        }  // End of else		
    } //End of if     
 	return(true);  
}

function submitCheckProcess(URL,ms1,ms2,ms3,ms4,ms5,ms6,ms7,ms8,ms9,ms10,ms11,ms12)
{
	//add by Peggy 20120113 check linetype是否正確
	if (document.DISPLAYREPAIR.ACTIONID.value!="013")
	{
		var num =1;
		var chkcnt=0;  //add by Peggy 20130701
		var custpo=""; //add by Peggy 20130628
		var end_customer_ship_to=""; //add by Peggy 20160219
		var bi_region="";  //add by Peggy 20170220
		var slow_moving_cnt=0;  //add by Peggy 20190401
		if (document.DISPLAYREPAIR.CHKFLAG.length != undefined)
		{
			num=document.DISPLAYREPAIR.CHKFLAG.length;
		}
		for (var i=0;i<num;i++)
		{  
			var chkvalue=false;
			if (num!=1)
			{	
				chkvalue=document.DISPLAYREPAIR.CHKFLAG[i].checked;
			}
			else
			{
				chkvalue=document.DISPLAYREPAIR.CHKFLAG.checked;
			}
			if (chkvalue==true)
			{
				chkcnt ++;
				var isExit = false;
				var slinetype = document.DISPLAYREPAIR.elements["SLINETYPE"+i].value;
				if (document.DISPLAYREPAIR.elements["REASON_CODE"+i].value=="08")  //add by Peggy 20190401
				{
					slow_moving_cnt++;
				}
				if (slinetype !="--")
				{
					for (var j = 0; j < document.DISPLAYREPAIR.LINE_TYPE.options.length; j++) 
					{	
						if (document.DISPLAYREPAIR.LINE_TYPE.options[j].value == slinetype)
						{
							isExit = true;
							break;
						}
					}	
				}
				if (!isExit)
				{
					alert("LINE TYPE:"+slinetype+" is not available!!"); 
					document.DISPLAYREPAIR.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
					document.DISPLAYREPAIR.elements["SLINETYPE"+i].focus();
					return(false);
				}
				var TSAREANO = document.DISPLAYREPAIR.TSAREANO.value;
				var sellingPrice = document.getElementById("sellingprice"+i).innerHTML;
				var regex = /^-?\d+\.?\d*?$/;
				if (sellingPrice.match(regex)==null) 
				{ 
					alert("Line:"+(i+1)+" 單價必須是數值型態!"); 
					return false;
				}
				if (TSAREANO=="002" &&  (sellingPrice==""||sellingPrice==null||sellingPrice=="0"||sellingPrice=="0.0"))
				{
					alert("Line:"+(i+1)+" 單價必須輸入!"); 
					return false;
				}  
				//add by Peggy 20120712
				var editcode = document.DISPLAYREPAIR.elements["EDITCODE"+i].value;
				if (editcode =="R") //退件
				{
					alert("Line:"+ (i+1) +" 被工廠退件,不允許生成MO!!!");
					return false;
				}
				if (document.DISPLAYREPAIR.elements["REASON_CODE"+i].value!="08" && document.DISPLAYREPAIR.elements["PCN_FLAG"+i].value=="Y") //add by Peggy 20230208
				{
					alert("Line:"+ (i+1) +" PCN/PDN/ID料號,不允許生成MO!!!");
					return false;				
				}
				//add by peggy 20130628
				custpo = document.getElementById("CUSTPO_"+i).innerHTML;
				//if ((document.DISPLAYREPAIR.CREATEDBY.value=="TSCCSZ020" || document.DISPLAYREPAIR.SALESAREANO.value=="004") && num != 1) //add saleareas=004 by Peggy 20140116
				if ((document.DISPLAYREPAIR.SALESAREANO.value=="018"|| document.DISPLAYREPAIR.SALESAREANO.value=="004") && num != 1) //modify by Peggy 20171221
				{
					for (var j = i+1 ; j < num ; j++)
					{
						if (document.DISPLAYREPAIR.CHKFLAG[j].checked && custpo != document.getElementById("CUSTPO_"+j).innerHTML)
						{
							alert("Line:"+ (j+1) +" 客戶訂購單號不同,不可生成同張MO!");
							return false;
						}
					}
				}
				//add by peggy 20160219
				end_customer_ship_to=document.DISPLAYREPAIR.elements["END_CUST_SHIP_TO_"+i].value;
				if (document.DISPLAYREPAIR.SALESAREANO.value=="012" && num != 1) 
				{
					for (var j = i+1 ; j < num ; j++)
					{
						if (document.DISPLAYREPAIR.CHKFLAG[j].checked)
						{
							if ( end_customer_ship_to != document.DISPLAYREPAIR.elements["END_CUST_SHIP_TO_"+j].value)
							{
								alert("Line:"+ (j+1) +" End Customer Ship to不同,不可生成同張MO!");
								return false;
							}
						}
					}
				}
				
				//add by peggy 20170220
				if (document.DISPLAYREPAIR.value == "14980" || document.DISPLAYREPAIR.value=="15540")
				{
					bi_region=document.DISPLAYREPAIR.elements["BI_REGION_"+i].value;
					for (var j = i+1 ; j < num ; j++)
					{
						if (document.DISPLAYREPAIR.CHKFLAG[j].checked)
						{
							if ( bi_region != document.DISPLAYREPAIR.elements["BI_REGION_"+j].value)
							{
								alert("Line:"+ (j+1) +" BI Region不同,不可生成同張MO!");
								return false;
							}
						}
					}
				}				
				//add by peggy 20160222
				if (document.DISPLAYREPAIR.elements["UNASSIGNORG"+i].value!="")
				{
					alert("Line:"+ (i+1) +" Item未assign到"+document.DISPLAYREPAIR.elements["UNASSIGNORG"+i].value+"!");
					return false;
				}				
			}
		}
		if (chkcnt==0)
		{
			alert("請勾選項次!");
			return false;		
		}


		//add by Peggy 20160219
		//alert(end_customer_ship_to +"  "+document.DISPLAYREPAIR.SHIPTOORG.value);
		if (document.DISPLAYREPAIR.SALESAREANO.value=="012" && document.DISPLAYREPAIR.SHIPTOORG.value != end_customer_ship_to && end_customer_ship_to != null && end_customer_ship_to!="")
		{
			alert("出貨地址與End Customer Ship to不符,請重新確認!");
			return false;
		}
		//add by Peggy 20130701
		if (chkcnt >1 && (document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="2016" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="7911" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="18615"  || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="47272"  || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="79272" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="1238" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="4377"  || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="537292" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="6293"))
		{
			alert("此客戶規定一個ITEM生成一筆MO!");
			return false;
		}
		//add by Peggy 20190401
		//if ((document.DISPLAYREPAIR.FIRMORDERTYPE.value=="1175" || document.DISPLAYREPAIR.FIRMORDERTYPE.value=="1322") && slow_moving_cnt>0)
		//{
		//	alert("消化庫存的訂單不可下1156或1142訂單!");
		//	return false;		
		//}
		if (document.DISPLAYREPAIR.FIRMORDERTYPE.value == "1763" && document.DISPLAYREPAIR.SALES_GROUP_ID.value !="509")  //add by Peggy 20210528
		{
			alert("This customer is not allowed to book 1132 order type!!");
			document.DISPLAYREPAIR.FIRMORDERTYPE.focus();
			return false;			 
		}
		else if (document.DISPLAYREPAIR.FIRMORDERTYPE.value != "1763" && document.DISPLAYREPAIR.SALES_GROUP_ID.value =="509")  //add by Peggy 20210528
		{
			alert("This customer must book 1132 order type!!");
			document.DISPLAYREPAIR.FIRMORDERTYPE.focus();
			return false;		 
		}
		if (document.DISPLAYREPAIR.SALESAREANO.value=="008" && document.DISPLAYREPAIR.FIRMPRICELIST.value!="3410499")
		{
			alert("The price list error!!");
			document.DISPLAYREPAIR.FIRMPRICELIST.focus();
			return false;		
		}
	}
     
	if (document.DISPLAYREPAIR.ACTIONID.value=="--" || document.DISPLAYREPAIR.ACTIONID.value==null) // 表示無選擇任何動作點擊 Submit鈕
   	{  
		alert(ms2);   
     	return(false);	  	
   	} 	
	else
    {
		if (document.DISPLAYREPAIR.ACTIONID.value=="012" || document.DISPLAYREPAIR.ACTIONID.value=="030" || document.DISPLAYREPAIR.ACTIONID.value=="013")  
        {  //表示為確認送出產生訂單動作(012) 或確認合併已存在MO單(030)
        	flag=confirm(ms1);      
            if (flag==false) return(false);
	        else
            {  
				if (document.DISPLAYREPAIR.FIRMORDERTYPE.value=="--" || document.DISPLAYREPAIR.FIRMORDERTYPE.value==null || document.DISPLAYREPAIR.FIRMORDERTYPE.value=="null") // 未選擇訂單類型
                { 
                	alert(ms3);   
                    return(false);
                } 
				if (document.DISPLAYREPAIR.FIRMSOLDTOORG.value=="--" || document.DISPLAYREPAIR.FIRMSOLDTOORG.value==null) // 未選擇客戶
                { 
                	alert(ms4);   
                    return(false);
                }
  
                if (document.DISPLAYREPAIR.FIRMPRICELIST.value=="--" || document.DISPLAYREPAIR.FIRMPRICELIST.value==null) // 未選擇價格表
                { 
                	alert(ms5);   
                    return(false);
                } 
  
                if (document.DISPLAYREPAIR.SHIPTOORG.value=="" || document.DISPLAYREPAIR.SHIPTOORG.value==null || document.DISPLAYREPAIR.SHIPTOORG.value=="null") // 未選擇出貨地
                { 
                	alert(ms6);   
                    return(false);
                }
  
                if (document.DISPLAYREPAIR.BILLTO.value=="" || document.DISPLAYREPAIR.BILLTO.value==null || document.DISPLAYREPAIR.BILLTO.value=="null") // 未選擇立帳地
                { 
                	alert(ms7);   
                    return(false);
                } 
  
                if (document.DISPLAYREPAIR.PAYTERMID.value=="" || document.DISPLAYREPAIR.PAYTERMID.value==null || document.DISPLAYREPAIR.PAYTERMID.value=="null") // 未選擇付款條件
                { 
                	alert(ms8);   
                    return(false);
                }
  
                if (document.DISPLAYREPAIR.FOBPOINT.value=="" || document.DISPLAYREPAIR.FOBPOINT.value==null || document.DISPLAYREPAIR.FOBPOINT.value=="null") // 未選擇FOB
                { 
                	alert(ms9);   
                    return(false);
                }
      
                if (document.DISPLAYREPAIR.SHIPMETHOD.value=="" || document.DISPLAYREPAIR.SHIPMETHOD.value==null || document.DISPLAYREPAIR.SHIPMETHOD.value=="null") // 未選擇出貨方式
                { 
                	alert(ms10);   
                    return(false);
                }  
				// 若未選擇任一Line 作動作,則警告
				var chkFlag="FALSE";
				for (i=0;i<document.DISPLAYREPAIR.CHKFLAG.length;i++)
				{
					if (document.DISPLAYREPAIR.CHKFLAG[i].checked==true)
					{
						chkFlag="TURE";
					} 
				}  // End of for	 
				//if (chkFlag=="FALSE" && document.DISPLAYREPAIR.CHKFLAG.length!=null)
				//modify by Peggy 20120301
				if (chkFlag=="FALSE" && (document.DISPLAYREPAIR.CHKFLAG.length!=null || document.DISPLAYREPAIR.CHKFLAG.length != undefined))
				{
					alert(ms12);   
					return(false);
				}
						
				if (document.DISPLAYREPAIR.ACTIONID.value=="030") // 如為 APPEND 合併訂單
				{	 
					if (document.DISPLAYREPAIR.ORGORDER.value==null || document.DISPLAYREPAIR.ORGORDER.value=="") // 未選擇合併的MO單號
                    { 
                    	alert(ms11);
						document.DISPLAYREPAIR.ORGORDER.focus();   
                        return(false);
                    } 
				}	 // End of if					
		    }  // End of Else if (flag==false)
		} // if (document.DISPLAYREPAIR.ACTIONID.value=="012")	
	   	document.DISPLAYREPAIR.submit2.disabled = true;  
	   	document.DISPLAYREPAIR.action=URL;
	   	document.DISPLAYREPAIR.submit();    
	}  
}

function setSubmit1(URL)
{ //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
   //chkFlag="TURE";   
	var linkURL = "#ACTION";
  	//document.DISPLAYREPAIR.submit2.disabled = false;
  	document.DISPLAYREPAIR.action=URL+linkURL;
  	document.DISPLAYREPAIR.submit();    
}

function setSubmit2(URL,LINKREF,xMINIPRICE,xALNAME,itemStatus,xDiffFactroyMsg)
{ 
	if (itemStatus=="Inactive")
	{
		alert("The internal Item had been setting with 'Inactive' property\n     Please contact System Administrator!!!"); 
		return false;
	}
	
  // 檢查 Mini Price 
	var nMINIPRICE = xMINIPRICE;
  	var nUPRICE = document.DISPLAYREPAIR.UPRICE.value;
  	if (nUPRICE != 0)
  	{
     	if (nUPRICE < nMINIPRICE) 	 
	 	{
	    	alert("Line "+LINKREF+", Selling Price "+nUPRICE+" < Mini Price "+nMINIPRICE+" !!");
         	document.DISPLAYREPAIR.UPRICE.focus();
      	}
  	}	 
  	//alert(document.DISPLAYREPAIR.MFGFACTORY.value);
  	if (document.DISPLAYREPAIR.MFGFACTORY.value!=null && document.DISPLAYREPAIR.MFGFACTORY.value!="")
  	{  // 若使用者選了先前的已生成MO,判斷該次Set的生產地是否相同於原MO生產地
    	if (xALNAME!=document.DISPLAYREPAIR.MFGFACTORY.value)
	   	{
	    	alert(xDiffFactroyMsg);
		 	return false;
	   	}
  	}

  	warray=new Array(document.DISPLAYREPAIR.SSHIPDATE.value,document.DISPLAYREPAIR.LINE_TYPE.value,document.DISPLAYREPAIR.PROMISEDATE.value); 
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
         		document.DISPLAYREPAIR.SSHIPDATE.focus();
         		return(false);
        	}
        	gone=datetime.substring(4,5);
        	month=datetime.substring(4,6);
        	if(isNaN(month)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.SSHIPDATE.focus();
          		return(false);
        	}
        	gtwo=datetime.substring(7,8);
        	day=datetime.substring(6,8);
       	 	if(isNaN(day)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.SSHIPDATE.focus();
          		return(false);
        	}
          	if(month<1||month>12) 
		  	{ 
            	alert("Month must between 01 and 12 !!"); 
            	document.DISPLAYREPAIR.SSHIPDATE.focus();   
            	return(false); 
          	} 
          	if(day<1||day>31)
		  	{ 
            	alert("Day must between 01 and 31!!");
            	document.DISPLAYREPAIR.SSHIPDATE.focus(); 
           	 	return(false); 
          	}
			else
			{
            	if(month==2)
				{  
                	if(isLeapYear(year)&&day>29)
					{ 
                    	alert("February between 01 and 29 !!"); 
                      	document.DISPLAYREPAIR.SSHIPDATE.focus();
                      	return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                    	alert("February between 01 and 29 !!");
                     	document.DISPLAYREPAIR.SSHIPDATE.focus(); 
                     	return(false); 
                    } 
                } // End of if(month==2)
                if((month==4||month==6||month==9||month==11)&&(day>30))
				{ 
                	alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   	document.DISPLAYREPAIR.SSHIPDATE.focus(); 
                   	return(false); 
                } 
           	} // End of else 
    	}
		else
		{
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.DISPLAYREPAIR.SSHIPDATE.focus();
          	return(false);
        }
  	}
	else
	{ 
		// 不卡日期未輸入,由訂單產生前若未設定 Schedule Shippment Date則預設與Customer Request Date相同
        //alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
        //document.DISPLAYREPAIR.SSHIPDATE.focus();
        //return(false);
    }
	// 判斷 CR Date 是否合法   
   	if(warray[2]!="")
   	{
    	datetime=warray[2];
     	if(datetime.length==8)
     	{
        	year=datetime.substring(0,4);
        	if(isNaN(year)==true)
			{
         		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
         		document.DISPLAYREPAIR.PROMISEDATE.focus();
         		return(false);
        	}
        	gone=datetime.substring(4,5);
        	month=datetime.substring(4,6);
        	if(isNaN(month)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.PROMISEDATE.focus();
          		return(false);
        	}
        	gtwo=datetime.substring(7,8);
        	day=datetime.substring(6,8);
        	if(isNaN(day)==true)
			{
          		alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          		document.DISPLAYREPAIR.PROMISEDATE.focus();
          		return(false);
        	}
          	if(month<1||month>12) 
		  	{ 
            	alert("Month must between 01 and 12 !!"); 
            	document.DISPLAYREPAIR.PROMISEDATE.focus();   
            	return(false); 
          	} 
          	if(day<1||day>31)
		  	{ 
            	alert("Day must between 01 and 31!!");
            	document.DISPLAYREPAIR.PROMISEDATE.focus(); 
            	return(false); 
          	}
			else
			{
            	if(month==2)
				{  
                	if(isLeapYear(year)&&day>29)
					{ 
                    	alert("February between 01 and 29 !!"); 
                      	document.DISPLAYREPAIR.PROMISEDATE.focus();
                      	return(false); 
                    }       
                    if(!isLeapYear(year)&&day>28)
					{ 
                    	alert("February between 01 and 29 !!");
                     	document.DISPLAYREPAIR.PROMISEDATE.focus(); 
                     	return(false); 
                    } 
                } // End of if(month==2)
                if((month==4||month==6||month==9||month==11)&&(day>30))
				{ 
                	alert("Apr., Jun., Sep. and Oct. \n Must between 01 and 30 !!");
                   	document.DISPLAYREPAIR.PROMISEDATE.focus(); 
                   	return(false); 
                } 
           	} // End of else 
    	}
		else
		{ // End Else of if(datetime.length==10)
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.DISPLAYREPAIR.PROMISEDATE.focus();
          	return(false);
        }
  	}
	else
	{ 
		// 不卡日期未輸入,由訂單產生前若未設定 Schedule Shippment Date則預設與Customer Request Date相同
        //alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
        //document.DISPLAYREPAIR.SSHIPDATE.focus();
        //return(false);
    }	   
    
  	// 檢查日期是否符合日期格式_止
  	// 檢查Line Type是否未選擇
  	if(warray[1]==null ||warray[1]=="" || warray[1]=="--")
  	{
    	alert("Please Choose Order Line Type !!!");
        document.DISPLAYREPAIR.LINE_TYPE.focus();
        return(false);
  	}
  
  	//add by Peggy 20120206
	var sRun = "Y";
	var sshipDate = document.DISPLAYREPAIR.SSHIPDATE.value;
	if (sshipDate.length>=8) sshipDate = sshipDate.substring(0,8);
	var origShipDate = document.getElementsByName("ORIGSHIPDATE"+LINKREF)[0].value;
	if (origShipDate.length>=8)  origShipDate = origShipDate.substring(0,8);
	if  (sshipDate.length >0 && sshipDate !="" && (sshipDate != origShipDate))
	{
		var FTACPDATE = document.getElementsByName("FTACPDATE"+LINKREF)[0].value.substring(0,8);
		if (FTACPDATE > sshipDate)
		{
			if (confirm("Schedule Ship Date("+sshipDate+") < Factory Confirm Date("+FTACPDATE+")\n                          Are you sure to update?")==false)
			{
				sRun = "N";
			}
		}
	}
	if (sRun == "Y")
	{
		document.DISPLAYREPAIR.ACTIONID.value="--"; // 避免使用者先選動作再設定各項目
  
  		var uPrice="&UPRICE="+document.DISPLAYREPAIR.UPRICE.value+"&LINE_TYPE="+document.DISPLAYREPAIR.LINE_TYPE.value+"&CUSTITEMNO="+document.DISPLAYREPAIR.elements["CITEMDESC"+LINKREF].value+"&CUSTITEMID="+document.DISPLAYREPAIR.elements["CITEMID"+LINKREF].value+"&CUSTITEMTYPE="+document.DISPLAYREPAIR.elements["CITEMTYPE"+LINKREF].value; 
  		var linkURL = "#"+LINKREF;
  		document.DISPLAYREPAIR.action=URL+uPrice+linkURL;
  		document.DISPLAYREPAIR.submit();   
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

function subWindowCustItemFind(customerID,invItemID,cItemDesc,dnDocNo,lineNo,itemStatus,stockEnable,transEnable)
{    
	if (itemStatus=="Inactive") 
   	{ 
    	alert("The internal Item had been setting with 'Inactive' property\n     Please contact System Administrator!!!"); 
   	}
   	if (stockEnable=="N" || transEnable=="N")
   	{
    	alert("The internal Item had been setting with 'non-Stockable' property\n     Please contact System Administrator!!!");
   	}

  	subWin=window.open("../jsp/subwindow/TSDRQCustItemInfoFind.jsp?INVITEMID="+invItemID+"&CUSTOMERID="+customerID+"&INVITEMDESC="+cItemDesc+"&DNDOCNO="+dnDocNo+"&LINENO="+lineNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function subWindowShipToFind(siteUseCode,customerID,shipToOrg,salesAreaNo)
{    
	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

// 用自行輸入找SHIP TO
function setShipToFind(siteUseCode,customerID,shipToOrg,salesAreaNo)
{  
	if (event.keyCode==13)
   	{    
    	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
   	}
}

// 點 ... 找 BILL TO
function subWindowBillToFind(siteUseCode,customerID,billTo,salesAreaNo)
{    
	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&BILLTO="+billTo+"&SALESAREANO="+salesAreaNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

//用自行輸入找BILL TO
function setBillToFind(siteUseCode,customerID,billTo,salesAreaNo)
{    
	if (event.keyCode==13)
  	{  
    	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&BILLTO="+billTo+"&SALESAREANO="+salesAreaNo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
  	}
}

function subWindowPayTermFind(primaryFlag)
{    
	subWin=window.open("../jsp/subwindow/TSDRQPaymentTermFind.jsp?PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 

function subWindowFOBPointFind(primaryFlag)
{    
	subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 

function subWindowShipMethodFind(primaryFlag)
{    
	subWin=window.open("../jsp/subwindow/TSDRQShippingMethodFind.jsp?PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 

function subMOrderOtherInforSet(pageChoice,customerID,ntfContact,ntfLocation,shpContact,dlvCustomer,dlvLocation,dlvTo,dlvAddress)
{    
	subWin=window.open("../jsp/subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH="+pageChoice+"&CUSTOMERID="+customerID+"&DELIVERTO="+dlvTo,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function setOrgOrderFind(custID, custPO, orderTypeID, priceListID, rfqNo, orgMO)
{
	if (event.keyCode==13)
  	{  
    	if (document.DISPLAYREPAIR.FIRMPRICELIST.value==null || document.DISPLAYREPAIR.FIRMPRICELIST.value=="--")
		{ 
	  		alert("Please Choose Price List first!!!");
	  		document.DISPLAYREPAIR.FIRMPRICELIST.focus(); 
		}
		else if (document.DISPLAYREPAIR.FIRMORDERTYPE.value==null || document.DISPLAYREPAIR.FIRMORDERTYPE.value=="--")
		{
	   		alert("Please Choose Price List first!!!");
	   		document.DISPLAYREPAIR.FIRMORDERTYPE.focus(); 
		}
		else 
		{
        	subWin=window.open("../jsp/subwindow/TSDRQOrgMOInfoFind.jsp?CUSTID="+custID+"&CUSTPO="+custPO+"&ORDERTYPEID="+orderTypeID+"&PRICELISTID="+priceListID+"&RDQNO="+rfqNo+"&ORGMO="+orgMO,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes");  
		} 
  	}
}

function subWindowOrgOrderFind(custID, custPO, orderTypeID, priceListID, rfqNo, orgMO)
{
	if (document.DISPLAYREPAIR.FIRMPRICELIST.value==null || document.DISPLAYREPAIR.FIRMPRICELIST.value=="--")
	{ 
		alert("Please Choose Price List first!!!");
	  	document.DISPLAYREPAIR.FIRMPRICELIST.focus(); 
	}
	else if (document.DISPLAYREPAIR.FIRMORDERTYPE.value==null || document.DISPLAYREPAIR.FIRMORDERTYPE.value=="--")
	{
		alert("Please Choose Price List first!!!");
	   	document.DISPLAYREPAIR.FIRMORDERTYPE.focus(); 
	}
	else 
	{
    	subWin=window.open("../jsp/subwindow/TSDRQOrgMOInfoFind.jsp?CUSTID="+custID+"&CUSTPO="+custPO+"&ORDERTYPEID="+orderTypeID+"&PRICELISTID="+priceListID+"&RFQNO="+rfqNo+"&ORGMO="+orgMO,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes");  
	} 
}

function alertShipBillMsg(msShipBill)
{
	alert(msShipBill);
}

function alertItemORGAssignMsg(msItemOrgAssign)
{
	alert(msItemOrgAssign);
}
setflag = false;

function pullDownMenu()
{
	if (setflag) pdMENU.style.visibility = "hidden";
 	else      pdMENU.style.visibility = "visible";
 	setflag = !setflag;
}

function popMenuMsg(listPrice)
{
	alert("Target Price="+listPrice);
}

function setchk(objline)
{
	//add by Peggy 20170803,TSCT-Disty  元超(全漢)必須單獨生成訂單,因為嘜頭有規定
	var chk_flag =false;
	var chk_row = 0;
	if (document.DISPLAYREPAIR.SALESAREANO.value=="006" && document.DISPLAYREPAIR.CUSTOMERNO.value=="1010")
	{
		if (document.DISPLAYREPAIR.CHKFLAG.length != undefined)
		{
			chk_flag = document.DISPLAYREPAIR.CHKFLAG[objline].checked;
			chk_row = document.DISPLAYREPAIR.CHKFLAG.length;
		}
		else
		{
			chk_flag = document.DISPLAYREPAIR.CHKFLAG.checked;
			chk_row = 1;
		}
		
		if (chk_flag && chk_row>1)
		{
			for (var i =0 ; i < document.DISPLAYREPAIR.CHKFLAG.length ;i++)
			{
				if (document.DISPLAYREPAIR.CHKFLAG[i].checked)
				{
					if ((document.getElementById("CUSTPO_"+objline).innerHTML.indexOf("全漢")>0 && document.getElementById("CUSTPO_"+i).innerHTML.indexOf("全漢")<=0)
						  || (document.getElementById("CUSTPO_"+objline).innerHTML.indexOf("全漢")<=0 && document.getElementById("CUSTPO_"+i).innerHTML.indexOf("全漢")>0)) 
					{
						alert("元超(全漢)必須單獨轉訂單,不可與其他End customer併單!");
						document.DISPLAYREPAIR.CHKFLAG[objline].checked = false;
						return false;
					}
				}
			}
		}		
	}
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<% 
	String dnDocNo=request.getParameter("DNDOCNO");
   	String assignManufact=request.getParameter("ASSIGN_MANUFACT");
   	String prodManufactory=request.getParameter("PRODMANUFACTORY");   
   	String lineNo=request.getParameter("LINENO");
   	String factoryDate=request.getParameter("FACTORYDATE"); 
   	String uPrice=request.getParameter("UPRICE"); 
   	String actionID = request.getParameter("ACTIONID");     //out.println("actionID="+actionID);
   	String remark = request.getParameter("REMARK");   
   	//response.sendRedirect("../jsp/TSSalesDRQAssigningPage.jsp?DNDOCNO="+dnDocNo); ASSIGN_MANUFACT PRICELIST
   	String preOrderType = request.getParameter("ORDER_TYPE_ID");
   	String firmOrderType = request.getParameter("FIRMORDERTYPE");
   	String lineType = request.getParameter("LINE_TYPE");   
   	String partyID = request.getParameter("PARTYID"); 
   	String firmSoldToOrg = request.getParameter("FIRMSOLDTOORG");
   	String firmPriceList = request.getParameter("FIRMPRICELIST");
   	String ShipToOrg = request.getParameter("SHIPTOORG"); 
	//out.println("ShipToOrg="+ShipToOrg);
   	String shipAddress = request.getParameter("SHIPADDRESS");
   	String billAddress = request.getParameter("BILLADDRESS");
   	String shipCountry = request.getParameter("SHIPCOUNTRY"); 
   	String billCountry = request.getParameter("BILLCOUNTRY"); 
   	String line_No=request.getParameter("LINE_NO");
   	String shipTo = request.getParameter("SHIPTO"); 
   	String billTo = request.getParameter("BILLTO"); 
	//out.println("SHIPTO="+shipTo + " BILLTO ="+billTo);
   	String deliverTo = request.getParameter("DELIVERTO");
   	String shipMethod = request.getParameter("SHIPMETHOD");
   	String fobPoint = request.getParameter("FOBPOINT");
   	String paymentTerm = request.getParameter("PAYTERM");
   	String pTermDesc = "";
   	String payTerm = request.getParameter("PAYTERM");
   	String payTermID = request.getParameter("PAYTERMID");
   	String sShipDate = request.getParameter("SSHIPDATE");
   	String promiseDate = request.getParameter("PROMISEDATE");
   	String custItemNo = request.getParameter("CUSTITEMNO");
   	String custItemID = request.getParameter("CUSTITEMID");
   	String custItemType = request.getParameter("CUSTITEMTYPE");
   	String masterGroupID = request.getParameter("MASTERGROUPID");    
   	String miniPrice = request.getParameter("MINIPRICE");
   	String orgOrder = request.getParameter("ORGORDER");
   	String mfgFactory = request.getParameter("MFGFACTORY");
   	String notifyContact = request.getParameter("NCONTACT");
   	String notifyLocation = request.getParameter("NLOCATION");
   	String shipContact = request.getParameter("SCONTACT");
   	String deliverCustomer = request.getParameter("DCUSTOMER");
   	String deliverLocation = request.getParameter("DLOCATION");
   	String deliverAddress = request.getParameter("DADDRESS");
   	String notifySet = request.getParameter("NOTIFYSET");
   	String deliverSet = request.getParameter("DELIVERSET");
   	String [] check=request.getParameterValues("CHKFLAG");
   	String addressInfo = request.getParameter("ADDRESSINFO");
   	String custItemDesc = request.getParameter("CITEMDESC");
   	String alertMsg = request.getParameter("ALERTMSG");
   	String alertItemAssignMsg = request.getParameter("ALERTITEMASSIGNMSG");
   	String setEnter  = "N";
   	String computeSSD ="N"; //add by Peggychen 20110621   
   	String setOrderTypeOrg = userOrgID; // 預設為使用者的Org 
	if (dnDocNo.substring(2,5).equals("023"))setOrderTypeOrg="907";//add by Peggy 20200107
	String tw_vendor_flag=request.getParameter("TW_VENDOR_FLAG"); //add by Peggy 20200224
	if (tw_vendor_flag==null) tw_vendor_flag="N";
	String REASON_CODE=request.getParameter("REASON_CODE");  //add by Peggy 20210817
	if (REASON_CODE==null) REASON_CODE="";
   
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt1=con.prepareStatement(sql1);
	pstmt1.executeUpdate(); 
	pstmt1.close();   
	/*if (preOrderType !=null && firmOrderType==null)
   	{
    	// 更正以下的固定取setOrderTypeOeg寫法_起
       	Statement stateSetOrg = con.createStatement();
       	String orgSql=" SELECT B.ORG_ID ORGANIZATION_ID,case when d.TSCUSTOMERID=14880 and d.TSAREANO='005' and A.ORDER_NUM='1131' then '1008' else   a.DEFAULT_ORDER_LINE_TYPE end as DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS A,"+
	                 " oraddman.TSPROD_ORDERTYPE B ,"+
					 " oraddman.TSDELIVERY_NOTICE_DETAIL c, "+
					 " oraddman.TSDELIVERY_NOTICE d"+
					 " WHERE A.OTYPE_ID = '"+preOrderType+"' "+
					 " AND A.SAREA_NO = d.TSAREANO "+
					 " AND A.ORDER_NUM = B.ORDER_NUM "+ 
					 " AND B.MANUFACTORY_NO = c.ASSIGN_MANUFACT "+
					 " AND c.dndocno = d.dndocno"+
					 " AND c.DNDOCNO='"+dnDocNo+"' "+
					 " AND c.LINE_NO = "+line_No+" ";
		ResultSet rsSetOrg=stateSetOrg.executeQuery(orgSql);
	   	if (rsSetOrg.next())
	   	{
	    	setOrderTypeOrg = rsSetOrg.getString("ORGANIZATION_ID");	
			
			//add by Peggy 20141017
			String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LINE_TYPE=? where DNDOCNO='"+dnDocNo+"' and LSTATUSID='009' AND AUTOCREATE_FLAG <>'Y' AND ASSIGN_MANUFACT= '"+assignManufact+"'";
			PreparedStatement pstmt=con.prepareStatement(sql);            
			pstmt.setString(1,rsSetOrg.getString("DEFAULT_ORDER_LINE_TYPE"));  // Line Type
			pstmt.executeUpdate(); 
			pstmt.close();				
				
	   	} 
		else 
		{
	    	if (preOrderType.equals("1021") || preOrderType.equals("1022")) 
			{ 
				setOrderTypeOrg = "49"; 
			} // 1131及1141設為49(I1)
	        else if (preOrderType.equals("1020")) 
			{ 
				setOrderTypeOrg = "44"; 
			} // 1151設為44(I8)
            else if (preOrderType.equals("1015")) 
			{ 
				setOrderTypeOrg = "566"; 
			} // 1121設為566(I20)
            else if (preOrderType.equals("1322")) 
			{ 
				//setOrderTypeOrg = "327"; 
				setOrderTypeOrg = "49";   //modify by Peggy 20111109
			} // 1122設為327(Y2)
	        else if (preOrderType.equals("1114")) 
			{ 
				setOrderTypeOrg = "163"; 
			} // 1213設為163(I6)
		    else if (preOrderType.equals("1165")) 
			{ 
				setOrderTypeOrg = "326"; 
			} // 4131 YEW Y1(內銷倉) // 2006/12/28	
            else if (preOrderType.equals("1302")) 
			{ 
				setOrderTypeOrg = "326"; 
			} // 4121 YEW Y1(內銷倉) // 2009/03/23  
	    }
	    rsSetOrg.close();
	    stateSetOrg.close();   
       	// 更正以下的固定取setOrderTypeOeg寫法_迄	 
   	} 
	else*/ if ( firmOrderType!=null && !firmOrderType.equals("") )
    {
		// 更正以下的固定取setOrderTypeOeg寫法_起
    	Statement stateSetOrg = con.createStatement();
        //String orgSql=" SELECT B.ORG_ID ORGANIZATION_ID,a.DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS A,"+
		//              " oraddman.TSPROD_ORDERTYPE B ,"+
		//			  " oraddman.TSDELIVERY_NOTICE_DETAIL c "+
	  	//		  	  //" WHERE A.OTYPE_ID = '"+preOrderType+"' "+
		//			  " WHERE A.OTYPE_ID = '"+firmOrderType+"'"+  //modify by Peggy 20111109
		//			  " AND A.SAREA_NO = SUBSTR(c.DNDOCNO,3,3) "+
		//			  " AND A.ORDER_NUM = B.ORDER_NUM "+ 
		//			  " AND B.MANUFACTORY_NO = c.ASSIGN_MANUFACT"+
		//			  " AND c.DNDOCNO='"+dnDocNo+"' AND c.LINE_NO = "+line_No+" ";
       	String orgSql=" SELECT B.ORG_ID ORGANIZATION_ID,case when d.TSCUSTOMERID=14880 and d.TSAREANO='005' and A.ORDER_NUM='1131' then '1008' else   a.DEFAULT_ORDER_LINE_TYPE end as DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS A,"+
	                 " oraddman.TSPROD_ORDERTYPE B ,"+
					 " oraddman.TSDELIVERY_NOTICE_DETAIL c, "+
					 " oraddman.TSDELIVERY_NOTICE d"+
					 " WHERE A.OTYPE_ID = '"+firmOrderType+"' "+
					 " AND A.SAREA_NO = d.TSAREANO "+
					 " AND A.ORDER_NUM = B.ORDER_NUM "+ 
					 " AND B.MANUFACTORY_NO = c.ASSIGN_MANUFACT "+
					 " AND c.dndocno = d.dndocno"+
					 " AND c.DNDOCNO='"+dnDocNo+"' "+
					 " AND c.LINE_NO = "+line_No+" ";
		//out.println(orgSql);
        ResultSet rsSetOrg=stateSetOrg.executeQuery(orgSql);
	    if (rsSetOrg.next())
	    {
	    	setOrderTypeOrg = rsSetOrg.getString("ORGANIZATION_ID");	
			
			//add by Peggy 20141017
			String sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LINE_TYPE=? where DNDOCNO='"+dnDocNo+"' and LSTATUSID='009' AND AUTOCREATE_FLAG <>'Y' AND ASSIGN_MANUFACT= '"+assignManufact+"'";
			PreparedStatement pstmt=con.prepareStatement(sql);            
			pstmt.setString(1,rsSetOrg.getString("DEFAULT_ORDER_LINE_TYPE"));  
			pstmt.executeUpdate(); 
			pstmt.close();				
	    } 
		else 
		{
			if (firmOrderType.equals("1021") || firmOrderType.equals("1022")) 
			{ 
				setOrderTypeOrg = "49"; 
			} // 1131及1141設為49(I1)
	        else if (firmOrderType.equals("1020")) 
			{ 
				setOrderTypeOrg = "44"; 
			} // 1151設為44(I8)
            else if (firmOrderType.equals("1015")) 
			{ 
				setOrderTypeOrg = "566"; 
			} // 1121設為566(I20)
            else if (firmOrderType.equals("1322")) 
			{ 
				//setOrderTypeOrg = "327"; 
				setOrderTypeOrg = "49";   //modify by Peggy 20111109
			} // 1122設為327(Y2)
	        else if (firmOrderType.equals("1114")) 
			{ 
				setOrderTypeOrg = "163"; 
			} // 1213設為163(I6)
			else if (firmOrderType.equals("1165")) 
			{ 
				setOrderTypeOrg = "326"; 
			} // 4131 YEW Y1(內銷倉) // 2006/12/28
            else if (firmOrderType.equals("1302")) 
			{ 
				setOrderTypeOrg = "326"; 
			} // 4121 YEW Y1(內銷倉) // 2009/03/23
		}
		rsSetOrg.close();
	    stateSetOrg.close();   
        // 更正以下的固定取setOrderTypeOeg寫法_迄	
		
	} // End of else if ()
   
   	if (promiseDate==null) promiseDate="";
   	if (sShipDate==null) sShipDate="";
   	if (lineNo==null) lineNo=""; 
   	if (uPrice==null) uPrice="0";
   	if (remark==null) remark=""; 
   	if (ShipToOrg==null) ShipToOrg=""; 
   	if (shipAddress==null) shipAddress="";
   	if (billAddress==null) billAddress="";
   	if (billTo==null) billTo="";
   	if (addressInfo==null) addressInfo="";
   	if (shipMethod==null) shipMethod="";
   	if (fobPoint==null) fobPoint="";
   	if (payTermID==null) payTermID="";
   	if (paymentTerm==null || paymentTerm.equals("")) paymentTerm="";
   	if (payTerm==null) payTerm=""; 
   	if (firmOrderType==null || firmOrderType.equals("--")) firmOrderType=preOrderType;
   	if (custItemDesc==null) custItemDesc="";
   	if (custItemNo==null) custItemNo=""; 
   	if (custItemID==null) custItemID="";
   	if (custItemType==null) custItemType="INT";
   	if (alertMsg==null) alertMsg = "N";
   	if (alertItemAssignMsg==null) alertItemAssignMsg = "N";
   	if (setEnter==null) setEnter = "N";
   	if (notifyContact==null) notifyContact= "";
   	if (notifyLocation==null) notifyLocation= "";
   	if (shipContact==null) shipContact= "";
   	if (deliverCustomer==null) deliverCustomer = "";
   	if (deliverTo==null) deliverTo = "";
   	if (deliverLocation==null) deliverLocation = "";
   	if (deliverAddress==null) deliverAddress = "";
   	if (orgOrder==null) orgOrder = "";
   	if (mfgFactory==null) mfgFactory = "";
 	if (notifySet==null || notifySet.equals("N")) 
   	{ 
    	array2DMOContactInfoBean.setArrayString(null);
	 	array2DMODeliverInfoBean.setArrayString(null); 
   	}
   	if (deliverSet==null || deliverSet.equals("N"))
   	{
    	array2DMOContactInfoBean.setArrayString(null); 
    	array2DMODeliverInfoBean.setArrayString(null); 
   	}
   	String assignMFGAlName = "",assignMFGAlNameDetail="";   
   	if (assignManufact!=null)
   	{
		Statement state = con.createStatement();
       	ResultSet rs=state.executeQuery("select ALNAME,ALSHT_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO = '"+assignManufact+"' ");
	   	if (rs.next())
	   	{
	    	assignMFGAlName = rs.getString("ALNAME");	
         	assignMFGAlNameDetail = rs.getString("ALSHT_NAME");	
	   	}
	   	rs.close();
	   	state.close();
   	} 
   	String salesAreaNo = "";
   	String parOrgID = "41";
   	if (dnDocNo!=null)
   	{
    	salesAreaNo = dnDocNo.substring(2,5);
	   	Statement state = con.createStatement();
       	ResultSet rs=state.executeQuery("select ORGANIZATION_ID, PAR_ORG_ID,SSD_FLAG "+
	   	"from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = '"+salesAreaNo+"' ");
	   	if (rs.next())
	   	{	     
			parOrgID = rs.getString("PAR_ORG_ID");		 
		 	computeSSD=rs.getString("SSD_FLAG");  //add by Peggychen 20110621
	   	}
	   	rs.close();
	   	state.close();   
   	}
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" onsubmit='return submitCheck("<jsp:getProperty name="rPH" property="pgAlertMOGenSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertSubmit"/>","<jsp:getProperty name="rPH" property="pgAlertSvrType"/>","<jsp:getProperty name="rPH" property="pgAlertCustomer"/>","<jsp:getProperty name="rPH" property="pgAlertPriceList"/>","<jsp:getProperty name="rPH" property="pgAlertShipAddress"/>","<jsp:getProperty name="rPH" property="pgAlertBillAddress"/>","<jsp:getProperty name="rPH" property="pgAlertPayTerm"/>","<jsp:getProperty name="rPH" property="pgAlertFOB"/>","<jsp:getProperty name="rPH" property="pgAlertShipMethod"/>","<jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/>")' ACTION="../jsp/TSSalesDRQMProcess.jsp?DNDOCNO=<%=dnDocNo%>" METHOD="post">
  <!--=============以下區段為取得維修基本資料==========-->
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<!--=================================-->
<%
//add by Peggy 20150520
if (ShipToOrg == null || ShipToOrg.equals("")) ShipToOrg = shipToOrg;
if (billTo == null || billTo.equals("")) billTo = billtoorg;
if (fobPoint ==null || fobPoint.equals("")) fobPoint = FOB_POINT;
if (firmPriceList==null || firmPriceList.equals("")) firmPriceList = priceList;
if (paymentTerm==null || paymentTerm.equals("")) paymentTerm=paymentterm;

if (lineNo !=null && !lineNo.equals("") && uPrice!=null && !uPrice.equals("") && Double.valueOf(uPrice).doubleValue() >0)  //modify by Peggy 20150520,price >0 才update
{
	try
	{
		//add by Peggy 20120130
		String sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'SELLING_PRICE'"+
					 " ,SELLING_PRICE"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"' "+
					 " and LINE_NO='"+lineNo+"' "+
					 " and SELLING_PRICE <>"+uPrice;
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,uPrice);
		pstmt.setString(2,UserName);	 
		pstmt.executeQuery(); 
		pstmt.close();	 
		
		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set SELLING_PRICE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
		pstmt=con.prepareStatement(sql);  
		pstmt.setFloat(1,Float.parseFloat(uPrice));  // 單價		 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();

		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("selling price update fail!");
	}
}  

if (lineNo !=null && !lineNo.equals("") && lineType!=null && lineType!="--" && !lineType.equals("--"))
{ 
	try
	{
		//add by Peggy 20120130
		String sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'LINE_TYPE'"+
					 " ,LINE_TYPE"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"' "+
					 " and LINE_NO='"+lineNo+"' "+
					 " and LINE_TYPE <>"+lineType;
		PreparedStatement pstmt=con.prepareStatement(sql);	
		pstmt.setInt(1,Integer.parseInt(lineType));  // Line Type
		pstmt.setString(2,UserName);	 
		pstmt.executeQuery(); 
		pstmt.close();	 
	
		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LINE_TYPE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
		pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(lineType));  // Line Type
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();
		
		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("LINE_TYPE update fail!");
	}
} 

if (lineNo !=null && !lineNo.equals("") && promiseDate!="" && !promiseDate.equals(""))
{	 
	try
	{
		//add by Peggy 20120130
		String sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'PROMISE_DATE'"+
					 " ,PROMISE_DATE"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"'"+
					 " and LINE_NO='"+lineNo+"' "+
					 " and PROMISE_DATE <>'"+promiseDate +"'";
		PreparedStatement pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,promiseDate);  // PROMISE_DATE
		pstmt.setString(2,UserName);	 
		pstmt.executeUpdate(); 
		pstmt.close();	 
	
		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PROMISE_DATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
		pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,promiseDate);  // Line Type
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();
		
		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("PROMISE_DATE update fail!");
	}
}

if (lineNo !=null && !lineNo.equals("") && sShipDate!="" && !sShipDate.equals(""))
{ 
	try
	{
		//add by Peggy 20120130
		String sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'SHIP_DATE'"+
					 " ,SHIP_DATE"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"'"+
					 " and LINE_NO='"+lineNo+"' "+
					 " and SHIP_DATE <>'"+sShipDate+"'";
		PreparedStatement pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,sShipDate);  //SHIP_DATE
		pstmt.setString(2,UserName);	 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();	 
	
		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set SHIP_DATE=? where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
		pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,sShipDate);  // Line Type
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();
		
		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("SHIP_DATE update fail!");
	}
}
 
if (lineNo !=null && !lineNo.equals("") && custItemNo!="" && !custItemNo.equals(""))
{ 
	try
	{
		//add by Peggy 20120130
		String sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'ORDERED_ITEM'"+
					 " ,ORDERED_ITEM"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"'"+
					 " and LINE_NO='"+lineNo+"' "+
					 " and ORDERED_ITEM <>'"+custItemNo+"'";
		PreparedStatement pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,custItemNo);  // custItemNo
		pstmt.setString(2,UserName);	 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();	 

		//add by Peggy 20120130
		sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'ORDERED_ITEM_ID'"+
					 " ,ORDERED_ITEM_ID"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"'"+
					 " and LINE_NO='"+lineNo+"' "+
					 " and ORDERED_ITEM_ID <>'"+custItemID+"'";
		pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,custItemID);  // custItemID
		pstmt.setString(2,UserName);	 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();	 
	
		//add by Peggy 20120130
		sql = " insert into ORADDMAN.TSDELIVERY_DETAIL_LOG"+
					 " ("+
					 " dndocno"+
					 " ,line_no "+
					 " ,column_name"+
					 " ,old_value"+
					 " ,new_value"+
					 " ,last_update_date"+
					 " ,last_updated_by"+
					 " ,program_name"+
					 ")"+
					 " select "+
					 "  DNDOCNO"+
					 " ,LINE_NO"+
					 " ,'ITEM_ID_TYPE'"+
					 " ,ITEM_ID_TYPE"+
					 " ,?"+
					 " ,sysdate"+
					 " ,?"+
					 " ,'D1-007'"+
					 " FROM ORADDMAN.TSDELIVERY_NOTICE_DETAIL"+
					 " WHERE DNDOCNO='"+dnDocNo+"'"+
					 " and LINE_NO='"+lineNo+"' "+
					 " and ITEM_ID_TYPE <>'"+custItemType+"'";
		pstmt=con.prepareStatement(sql);	
		pstmt.setString(1,custItemType);  // custItemType
		pstmt.setString(2,UserName);	 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();	 
	
		sql = "update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set ORDERED_ITEM=?,ORDERED_ITEM_ID=?,ITEM_ID_TYPE=? "+
					" where DNDOCNO='"+dnDocNo+"' and LINE_NO='"+lineNo+"' ";
		pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,custItemNo);  
		pstmt.setString(2,custItemID); 
		pstmt.setString(3,custItemType); 
		//pstmt.executeUpdate(); 
		pstmt.executeQuery(); 
		pstmt.close();
		
		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("CUSTOMER_ITEM update fail!");
	}
}

	//CallableStatement cs2 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
 	CallableStatement cs2 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
    cs2.setString(1,parOrgID);  // 取業務員隸屬ParOrgID
    cs2.execute();
    cs2.close(); 

int iCount = 0;
if (firmSoldToOrg==null) firmSoldToOrg = tsCustomerID;
// 取由選擇客戶帶出的Price List相關資訊為預設PriceList選項
if (tsCustomerID!=null) // 2006/01/18 一律取ShipTo BillTo
{
	String acctSiteAddressID = "";
	boolean prlistGet = false;
	String sqlPr = "select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,  "+		
				   " a.PAYMENT_TERM_ID, c.NAME as PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, "+
			       " a.PRICE_LIST_ID, c.DESCRIPTION, a.ATTRIBUTE1, d.CURRENCY_CODE, f.MASTER_GROUP_ID "+  
				   //" from RA_SITE_USES_ALL a,RA_ADDRESSES_ALL b, RA_TERMS c, "+ 
				   //20110826 modify by Peggy for R12 upgrade
				   " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS c, "+ //modify by Peggy 20111227
				   //" from hz_cust_site_uses a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS c, "+
				   " SO_PRICE_LISTS d,TSC_OM_GROUP e, TSC_OM_GROUP_MASTER f "+ 
				   " where  a.ADDRESS_ID = b.cust_acct_site_id"+
				   //" where  a.cust_acct_site_id = b.cust_acct_site_id"+ //modify by Peggy 20111227
                   " AND b.party_site_id = party_site.party_site_id"+
                   " AND loc.location_id = party_site.location_id "+
				   " and a.STATUS='A' "+
				   " and b.CUST_ACCOUNT_ID ='"+tsCustomerID+"'"+
				   //" and a.PRIMARY_FLAG = 'Y' "+
				   " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+) "+
				   " and a.PAYMENT_TERM_ID = c.TERM_ID(+) "+	
				   " and a.ATTRIBUTE1 = e.GROUP_ID(+) "+	
				   " and e.MASTER_GROUP_ID = f.MASTER_GROUP_ID(+)"+
				   " order by  a.SITE_USE_CODE,decode(a.PRIMARY_FLAG,'Y',1,2)";
				   //" and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+		
				   //" where CUST_ACCOUNT_ID ='"+tsCustomerID+"') "+
				   //" and a.ORG_ID = '"+parOrgID+"' ";  // 半導體事業部
	Statement stateCust=con.createStatement();	  
	ResultSet rsPr=stateCust.executeQuery(sqlPr);
	//out.println("sqlPr="+sqlPr);
	while (rsPr.next())
	{
		if (rsPr.getString("SITE_USE_CODE")=="SHIP_TO" || rsPr.getString("SITE_USE_CODE").equals("SHIP_TO"))
		{ 
			if (firmPriceList==null || firmPriceList.equals("") || firmPriceList.equals("0")) firmPriceList=rsPr.getString("PRICE_LIST_ID");
		  	if (ShipToOrg==null || ShipToOrg.equals("") || ShipToOrg.equals("0")) ShipToOrg=rsPr.getString("SITE_USE_ID");		
		  	if (shipMethod==null || shipMethod.equals("")) shipMethod=rsPr.getString("SHIP_VIA");
		  	if (fobPoint==null || fobPoint.equals("")) fobPoint=rsPr.getString("FOB_POINT");	
		  	if (paymentTerm==null || paymentTerm.equals("")) paymentTerm=rsPr.getString("PAYMENT_TERM_NAME");
		  	if (payTermID==null || payTermID.equals("") || payTermID.equals("0")) payTermID=rsPr.getString("PAYMENT_TERM_ID");
		  	if (pTermDesc==null || pTermDesc.equals("")) pTermDesc = rsPr.getString("DESCRIPTION");
		  	if (shipAddress==null || shipAddress.equals("") || ShipToOrg.equals(rsPr.getString("SITE_USE_ID"))) shipAddress=rsPr.getString("ADDRESS1"); 
		  	if (shipCountry==null || shipCountry.equals("") || ShipToOrg.equals(rsPr.getString("SITE_USE_ID"))) shipCountry=rsPr.getString("COUNTRY");
		  	if (curr==null || curr.equals("")) curr=rsPr.getString("CURRENCY_CODE");
		  	if (masterGroupID==null || masterGroupID.equals("")) masterGroupID=rsPr.getString("MASTER_GROUP_ID");
		  	prlistGet = true;  
		}
		if (rsPr.getString("SITE_USE_CODE")=="BILL_TO" || rsPr.getString("SITE_USE_CODE").equals("BILL_TO"))
		{ 
			if (billTo==null || billTo.equals("") || billTo.equals("0")) billTo=rsPr.getString("SITE_USE_ID");
			if (firmPriceList==null || firmPriceList.equals("") || firmPriceList.equals("0")) firmPriceList=rsPr.getString("PRICE_LIST_ID");
			if (shipMethod==null || shipMethod.equals("")) shipMethod=rsPr.getString("SHIP_VIA");
			if (fobPoint==null || fobPoint.equals("")) fobPoint=rsPr.getString("FOB_POINT");
			if (paymentTerm==null || paymentTerm.equals("")) paymentTerm=rsPr.getString("PAYMENT_TERM_NAME");   
			if (payTermID==null || payTermID.equals("") || payTermID.equals("0")) payTermID=rsPr.getString("PAYMENT_TERM_ID"); 
			if (pTermDesc==null || pTermDesc.equals("")) pTermDesc = rsPr.getString("DESCRIPTION");
			if (billAddress==null || billAddress.equals("") || billTo.equals(rsPr.getString("SITE_USE_ID"))) billAddress=rsPr.getString("ADDRESS1"); 
		    if (billCountry==null || billCountry.equals("") || billTo.equals(rsPr.getString("SITE_USE_ID"))) billCountry=rsPr.getString("COUNTRY");
		    if (curr==null || curr.equals("")) curr=rsPr.getString("CURRENCY_CODE");
		    if (masterGroupID==null || masterGroupID.equals("")) masterGroupID=rsPr.getString("MASTER_GROUP_ID");
			prlistGet = true; 
		}
		if (rsPr.getString("SITE_USE_CODE")=="DELIVER_TO" || rsPr.getString("SITE_USE_CODE").equals("DELIVER_TO"))
		{  
			deliverTo=rsPr.getString("SITE_USE_ID"); 
		}
		iCount++;
	} // Enf of While
	rsPr.close();	
	stateCust.close(); 

	if ((iCount==0 || iCount<=1) && alertMsg.equals("N")) // 若不存在SHIP_TO & BILL TO 或 缺其中之一未設為 PRIMARY, 則找任一組置入
	{  		  
		//alertMsg = "Y";
	} // End of if ()	
		
	// 若找不到,則找系統標準的VIEW(AR_SITE_USES_V)
	if (firmPriceList==null || firmPriceList.equals(""))
	{	
		Statement statePRLIST=con.createStatement();
		ResultSet rsPRLIST=null;				  
		rsPRLIST=statePRLIST.executeQuery("select a.PRICE_LIST_ID "+ 
		//20110826 modify by Peggy for R12 upgrade 
		//" from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c "+  
		" from AR_SITE_USES_V a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c "+  
		" where  a.ADDRESS_ID = b.cust_acct_site_id"+
		" AND b.party_site_id = party_site.party_site_id"+
		" AND loc.location_id = party_site.location_id "+
		" and a.STATUS='A' "+
		" and a.PAYMENT_TERM_ID = c.TERM_ID(+) "+	
		" and a.PRIMARY_FLAG = 'Y' "+
		" and b.CUST_ACCOUNT_ID ='"+tsCustomerID+"'");
		if (rsPRLIST.next())
		{
			firmPriceList=rsPRLIST.getString("PRICE_LIST_ID"); 
		}
		rsPRLIST.close();
		statePRLIST.close();
	}
} // End of if tsCustomerID!=null
%>
<hr>
<%
//  若狀態是 009訂單生成中,才顯示明細供使用者設定相關參數,否則,使用者無法作任何Submit...(防止User自行於網址列輸入LineNO) 	
if (frStatID.equals("009"))
{
	String m[]=array2DMOContactInfoBean.getArrayContent(); // 取一維陣列內容
    if (m!=null)
    {
    }
	String n[]=array2DMODeliverInfoBean.getArrayContent(); // 取一維陣列內容
    if (n!=null)
    {
    }
  
%>
<TABLE cellSpacing="1" cellPadding="5" width="100%" align="center" border="0">
<TBODY>
	<TR>	
		<TD bgColor=#ffffff>
		<table border="1" cellpadding="0" cellspacing="1" align="center" width="100%" bordercolor="#999966"  bordercolorlight="#999999" bordercolordark="#CCCC99" bgcolor="#CCCC99">
    		<tr bgcolor='#D5D8A7'>
	    		<td height="22" colspan="2">
		 <font  color="#000066"><jsp:getProperty name="rPH" property="pgSalesOrder"/><jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/>:</font>
		  <font  color="#666666"><jsp:getProperty name="rPH" property="pgQDocNo"/>:</font><font  color="#006699"><%=dnDocNo%></font>
		  <BR>
		  <font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgFirmOrderType"/></font>	
	<%
	try
    {   
    	//判斷若為訂單不收費,只能生成1121的訂單_start
        String sampleOrderCode="";
        String sampleChargeCode="";
        String sampleSql="";
	   	Statement statesamp = con.createStatement();
       	ResultSet rsSamp=statesamp.executeQuery("select TSAREANO,SAMPLE_ORDER,DECODE(SAMPLE_CHARGE,'','N','N','N','Y') SAMPLE_CHARGE "+
		                                        " from oraddman.TSDELIVERY_NOTICE where DNDOCNO= '"+dnDocNo+"' ");
	   	if (rsSamp.next())
	  	{	     
			sampleOrderCode = rsSamp.getString("SAMPLE_ORDER");
            sampleChargeCode = rsSamp.getString("SAMPLE_CHARGE");		 
		}
	   	rsSamp.close();
	    statesamp.close();

        if ( (sampleOrderCode.equals("Y") && sampleChargeCode.equals("Y")) || sampleOrderCode.equals("N"))   //樣品訂單要收費,為一般訂單
        { 
        	sampleSql = " and A.ORDER_NUM NOT IN ('1121','1122','4121','8121')  ";  //add 8121 by Peggy 20201111
        }
		else if ( sampleOrderCode.equals("Y") && sampleChargeCode.equals("N"))
        { 
			sampleSql = "  and A.ORDER_NUM IN ('1121','1122','4121','8121') ";   //add 8121 by Peggy 20201111
		}
        else
        {  
			sampleSql="  ";
        }
       	//判斷若為訂單不收費,只能生成1121的訂單_ end
		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sqlOrgInf = " SELECT DISTINCT A.OTYPE_ID, A.ORDER_NUM||'('||A.DESCRIPTION||')' AS TRANSACTION_TYPE_CODE "+
		                   "   FROM ORADDMAN.TSAREA_ORDERCLS  A ,ORADDMAN.TSPROD_ORDERTYPE B  ";
		String whereOrgInf = " WHERE A.ACTIVE ='Y'  AND A.ORDER_NUM = B.ORDER_NUM  AND B.ALSHT_NAME = '"+assignMFGAlNameDetail+"'  ";
		if (!REASON_CODE.equals("08") && !salesAreaNo.equals("006")  && !salesAreaNo.equals("005") && !firmOrderType.equals("1663")) whereOrgInf+=" and A.OTYPE_ID='"+ preOrderType+"'"; //add by Peggy 20210817
		String orderOrgInf = "order by 2 ";  
		if (UserRoles.indexOf("admin")>=0) 
		{  
			whereOrgInf = whereOrgInf +"and A.SAREA_NO = '"+salesAreaNo+"' "; 					 
		}// 管理員可選任一型態
		else
		{
			//whereOrgInf = whereOrgInf +"and A.SAREA_NO = '"+userActCenterNo+"' ";
			whereOrgInf = whereOrgInf +"and A.SAREA_NO = '"+salesAreaNo+"' and exists (select 1 FROM oraddman.tsrecperson x where x.TSSALEAREANO=A.SAREA_NO and x.USERNAME='"+UserName+"')"; //modif by Peggy 20120516
		}
		sqlOrgInf = sqlOrgInf + whereOrgInf + sampleSql + orderOrgInf ;
      	rs=statement.executeQuery(sqlOrgInf);
		//out.println("sqlOrgInf="+sqlOrgInf);
		out.println("<select NAME='FIRMORDERTYPE' tabindex='1' class='style1' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+"&ASSIGN_MANUFACT="+assignManufact+'"'+")'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
		    String s2=(String)rs.getString(2); 
 	        if (s1.equals(firmOrderType)) 
  	        {
            	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 
            } 
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }  
		} //end of while
		out.println("</select>"); 
        rs.close();   
		statement.close();     	 
    } //end of try		 
    catch (Exception e)
	{ 
		out.println("Exception1:"+e.getMessage()); 
	} 
	%>
				</font>			 
				</td>
				<td valign="bottom"><div align="left">
	 			<font face="Arial" color="#996600"><span class="style1">&nbsp;</span><a href='javaScript:subMOrderOtherInforSet("NOTIFY","<%=tsCustomerID%>","<%=notifyContact%>","<%=notifyLocation%>","<%=shipContact%>","<%=deliverCustomer%>","<%=deliverLocation%>","<%=deliverTo%>","<%=deliverAddress%>")'><jsp:getProperty name="rPH" property="pgOthers"/></a></font>
		  		</div>
		 		</td>
			</tr>
			<tr bgcolor='#D5D8A7'>		   
      			<td colspan="2"><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSoldToOrg"/></font>
	<%
	try
    {   
		Statement statement=con.createStatement();
        ResultSet rs=null;				      									  
		//String sqlSold = "select CUSTOMER_ID, CUSTOMER_NUMBER||'('||CUSTOMER_NAME||')' as TRANSACTION_TYPE_CODE, "+
		//                " CUSTOMER_NUMBER||'('||CUSTOMER_NAME||')', PARTY_ID "+
		//	             " from RA_CUSTOMERS "+
		//	             " where status = 'A' "+
		//				 " and CUSTOMER_ID = '"+tsCustomerID+"' "+								  
		//                " order by CUSTOMER_ID "; 
		//20110826 modify by Peggy for R12 upgrade	
		String sqlSold = " SELECT cust.cust_account_id customer_id,cust.account_number || '(' || SUBSTRB (party.party_name, 1, 50) || ')'"+
                         " AS transaction_type_code,cust.account_number || '(' || SUBSTRB (party.party_name, 1, 50) || ')',"+
                         " party.party_number "+
                         " FROM hz_cust_accounts cust, hz_parties party"+
						 " where cust.party_id = party.party_id"+
						 " AND cust.status ='A'"+
						 " AND cust.cust_account_id = '"+tsCustomerID+"' "+	
						 " order by CUST.cust_account_id "; 
		rs=statement.executeQuery(sqlSold);		
        out.println("<select NAME='FIRMSOLDTOORG' tabindex='2' class='style1' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+firmOrderType+'"'+")'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
		    String s2=(String)rs.getString(2); 
		    if (s1.equals(firmSoldToOrg)) 
  		    {
            	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
				firmSoldToOrg = s2; 					  
				customer = rs.getString(3);   
				partyID = rs.getString(4);                               
            }
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
		} //end of while
		out.println("</select>"); 
	    statement.close();		  		  
	    rs.close();        	 
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception2:"+e.getMessage()); 
	}       
	%><BR></font>
				</td>
           		<td width="39%"><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPriceList"/></font>
	<%	
	String orgID = "41";  // 預設的 ORG_ID (2006/12/27)
	// ## 依此單據開單業務區取得其 OrgID_起				   
	Statement stateOrg=con.createStatement();			  
    ResultSet rsOrg=stateOrg.executeQuery("select PAR_ORG_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = substr('"+dnDocNo+"',3,3) ");
	if (rsOrg.next()) orgID = rsOrg.getString("PAR_ORG_ID");
	rsOrg.close();
	stateOrg.close();
	// ## 依廠區找此單據開單業務區取得其 OrgID_迄	 
	try
    {   
		Statement statement=con.createStatement();
        ResultSet rs=null;		      
		String sql = " select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
					 " from qp_list_headers_v "+
			         " where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' "+
					 "  AND (ORIG_ORG_ID ="+orgID+" or ORIG_ORG_ID IS NULL ) "; 
	    rs=statement.executeQuery(sql);
		out.println("<select NAME='FIRMPRICELIST' tabindex='3' class='style1' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+firmOrderType+'"'+")'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
		    String s2=(String)rs.getString(2); 
            String s3=(String)rs.getString(3);
		    if (s1==firmPriceList || s1.equals(firmPriceList)) 
  		    {
            	out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
				curr = s3; 					                                 
            } 
			else 
			{
            	out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
		} //end of while
		out.println("</select>"); 
		statement.close();		  		  
		rs.close();        	 
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception3:"+e.getMessage()); 
	}  
	%>		  
		   		</font>
	  			</td>		    
			</tr>	
			<tr bgcolor='#D5D8A7'>
	  			<td colspan="3"><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></font>
	<%			     
	try
    {  
		// 取預設選擇客戶的Ship To Address 及 Bill To Address 
		if (ShipToOrg==null || ShipToOrg=="" || billTo==null || billTo=="")
		{
			Statement statement=con.createStatement();
            ResultSet rs=null;					  
			String sql = " select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,  "+		
				         " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION "+  
					     //" from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c "+  
						 //20110826 modify by Peggy for R12 upgrade	
						 //" from AR_SITE_USES_V a,AR_ADDRESSES_V b, RA_TERMS_VL c "+  
						 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
					     " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                         " AND b.party_site_id = party_site.party_site_id"+
                         " AND loc.location_id = party_site.location_id "+
						 " and a.STATUS='A' "+
						 " and a.PRIMARY_FLAG='Y'"+
						 " and b.CUST_ACCOUNT_ID ='"+tsCustomerID+"'"+
						 " and a.PAYMENT_TERM_ID = c.TERM_ID(+) ";	
					     //" AND a.PRIMARY_FLAG = 'Y' and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+		
			             //" where CUST_ACCOUNT_ID ='"+tsCustomerID+"') ";							 					  
            rs=statement.executeQuery(sql);
			//out.println("sql="	+sql);  			  				     
		    while (rs.next())
		    {
		    	if (rs.getString("SITE_USE_CODE")=="SHIP_TO" || rs.getString("SITE_USE_CODE").equals("SHIP_TO"))
		        { 
					if (ShipToOrg==null || ShipToOrg=="") ShipToOrg=rs.getString("SITE_USE_ID");
					if (shipAddress==null || shipAddress=="")shipAddress=rs.getString("ADDRESS1"); 
					if (shipCountry==null || shipCountry=="") shipCountry=rs.getString("COUNTRY"); 
					if (fobPoint==null || fobPoint=="") fobPoint=rs.getString("FOB_POINT");
					if (rs.getString("SHIP_VIA")!=null) shipMethod =rs.getString("SHIP_VIA");
					if (paymentTerm==null || paymentTerm=="") paymentTerm=rs.getString("PAYMENT_TERM_NAME");  
					if (pTermDesc==null || pTermDesc=="") pTermDesc=rs.getString("DESCRIPTION");
					if (payTermID==null || payTermID=="") payTermID=rs.getString("PAYMENT_TERM_ID");					   
				}
		        if (rs.getString("SITE_USE_CODE")=="BILL_TO" || rs.getString("SITE_USE_CODE").equals("BILL_TO"))
		        {  
					if (billTo==null || billTo=="")billTo=rs.getString("SITE_USE_ID");
					if (billAddress==null || billAddress=="") billAddress=rs.getString("ADDRESS1"); 
					if (billCountry==null || billCountry=="") billCountry=rs.getString("COUNTRY");
					if (payTermID==null) payTermID=rs.getString("PAYMENT_TERM_ID");
					if (paymentTerm==null) paymentTerm=rs.getString("PAYMENT_TERM_NAME");
				}
				if (rs.getString("SITE_USE_CODE")=="DELIVER_TO" || rs.getString("SITE_USE_CODE").equals("DELIVER_TO"))
		        {  
					deliverTo=rs.getString("SITE_USE_ID"); 
				}
				iCount++;
		    } //end of while		          			   
		    rs.close();  
			if ((iCount==0 || iCount<2) && alertMsg.equals("N")) // 若不存在SHIP_TO & BILL TO 或 缺其中之一未設為 PRIMARY, 則找任一組置入
	        {  
	%>
	        	<script language="javascript">			   
			    	alertShipBillMsg("<jsp:getProperty name='rPH' property='pgAlertShipBillMsg'/>");			
			    </script>
	<%
              	alertMsg = "Y";
		    } // End of if ()	 
					 
			// 若沒直接取到ShipToAddress,則找下列SQL   
			if (shipAddress==null || shipAddress.equals(""))
			{					 
				sql = " select DISTINCT a.SITE_USE_ID,a.SITE_USE_CODE,a.PAYMENT_TERM_ID,"+
			 	      "  a.WAREHOUSE_ID, loc.ADDRESS1, loc.COUNTRY, a.SHIP_VIA, a.FOB_POINT, c.NAME, c.DESCRIPTION "+
					  //" from RA_SITE_USES_ALL a, RA_ADDRESSES_ALL b, RA_TERMS_VL c "+
					  //20110826 modify by Peggy for R12 upgrade	
					  " from RA_SITE_USES_ALL a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c "+
				      " where a.ADDRESS_ID = b.cust_acct_site_id"+
                         " AND b.party_site_id = party_site.party_site_id"+
                         " AND loc.location_id = party_site.location_id "+
						 " and TO_CHAR(a.SITE_USE_ID) = '"+ShipToOrg+"' "+
					     " and a.STATUS='A' and a.PRIMARY_FLAG = 'Y' "+
					     " and c.IN_USE ='Y'";
                //out.println("sql="+sql);						 
				ResultSet rsSP = statement.executeQuery(sql);
				if (rsSP.next())
				{
					shipAddress=rsSP.getString("ADDRESS1"); 
					shipCountry=rsSP.getString("COUNTRY"); 
					fobPoint=rsSP.getString("FOB_POINT");
					if (rsSP.getString("SHIP_VIA")!=null) 
					{
						shipMethod =rsSP.getString("SHIP_VIA");
					} 
					else 
					{
						Statement stateSP2=con.createStatement();
	                    String sqlSP2 = "select a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1, loc.ADDRESS2, loc.ADDRESS3, loc.ADDRESS4, "+
			                            "  a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME,a.SHIP_VIA,a.FOB_POINT,a.PRICE_LIST_ID "+
		                                //" from AR_SITE_USES_V a,RA_ADDRESSES_ALL b "+
					  					//20110826 modify by Peggy for R12 upgrade	
		                                " from AR_SITE_USES_V a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
		                                " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                                        " AND b.party_site_id = party_site.party_site_id"+
                                        " AND loc.location_id = party_site.location_id "+
										" and a.STATUS='A' "+	
										" and b.CUST_ACCOUNT_ID ='"+tsCustomerID+"'"+				
						                //" and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL"+
										//" where CUST_ACCOUNT_ID ='"+tsCustomerID+"') "+
					                    " and a.SITE_USE_CODE = 'SHIP_TO' "+ // 取 SHIP_TO
									    " and to_char(a.SITE_USE_ID) = '"+billTo+"' "; // 2007/09/14 modify
						//out.println("sqlSP2="+sqlSP2);
			            ResultSet rsSP2 = stateSP2.executeQuery(sqlSP2);		
			            if (rsSP2.next())	
			            {
                    		if (firmPriceList==null)firmPriceList=rsSP2.getString("PRICE_LIST_ID");   
			                if (ShipToOrg==null) ShipToOrg=rsSP2.getString("SITE_USE_ID");
							shipAddress=rsSP2.getString("ADDRESS1"); shipCountry=rsSP2.getString("COUNTRY"); 
			                shipMethod=rsSP2.getString("SHIP_VIA");
			                fobPoint=rsSP2.getString("FOB_POINT");
			                if (paymentTerm==null) paymentTerm=rsSP2.getString("PAYMENT_TERM_NAME");
			                if (payTermID==null) payTermID=rsSP2.getString("PAYMENT_TERM_ID");
			            }
			        	rsSP2.close();
			            stateSP2.close();            
					} // End of else					         
					rsSP.close();
				}								 
			}		// End of if (shipAddress==null || shipAddress.equals(""))			
			// 若沒直接取到BillToAddress,則找下列SQL  
			if (billAddress==null || billAddress.equals(""))	
			{
				sql = " select a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1, loc.ADDRESS2, loc.ADDRESS3, loc.ADDRESS4 "+
					  //"from AR_SITE_USES_V a,RA_ADDRESSES_ALL b "+
					  //20110826 modify by Peggy for R12 upgrade	
					  " from AR_SITE_USES_V a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
					  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                         " AND b.party_site_id = party_site.party_site_id"+
                         " AND loc.location_id = party_site.location_id "+
						 " and a.STATUS='A' "+	
						 " and b.CUST_ACCOUNT_ID ='"+tsCustomerID+"'"+				
					     //"and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL where CUST_ACCOUNT_ID ='"+tsCustomerID+"') "+
					     " and a.SITE_USE_CODE = 'BILL_TO' "+ // 取 BILL_TO
					     " and a.SITE_USE_ID = '"+billTo+"' ";
				//out.println("sql="+sql);
				ResultSet rsBA = statement.executeQuery(sql);
				if (rsBA.next())
				{
					billAddress = rsBA.getString("ADDRESS1"); 
					billCountry = rsBA.getString("COUNTRY"); 
				}
				rsBA.close();
			}  // End of if ()
			statement.close();  
		}  // End of if (ShipToOrg==null || ShipToOrg=="" || billTo==null || billTo=="")  
	} //end of try		 
    catch (Exception e)
	{ 
		out.println("Exception4:"+e.getMessage()); 
	}  
	//add by Peggy 20111227  
	if ((computeSSD.equals("Y") || computeSSD.equals("S") || computeSSD.equals("X")) && (shipMethod==null || shipMethod=="")) //modify by Peggy 20120522
	{
		String sql = " SELECT nvl(a.shipping_method,b.shipmethod) shipping_method"+
              " FROM oraddman.tsdelivery_notice_detail a,oraddman.tsdelivery_notice b"+
              " WHERE   a.dndocno = b.dndocno"+
              " and   a.dndocno = '"+dnDocNo+"'"+
              " AND a.lstatusid = '"+frStatID+"'"+
              " AND a.sdrq_exceed = 'N' "+
			  " AND nvl(a.shipping_method,b.shipmethod) is not null"+
              " order by a.LINE_NO";
	    //out.println("sql="+sql);
		Statement state1=con.createStatement();		
		ResultSet rs1 = state1.executeQuery(sql);		
		if (rs1.next())
		{
			if (!rs1.getString("shipping_method").equals("&nbsp;")) shipMethod=rs1.getString("shipping_method");
		}
		rs1.close();
		state1.close();
	}
	%>	      		  
		   			<input type="text" size="10" name="SHIPTOORG" tabindex='4' onKeyDown='setShipToFind("SHIP_TO","<%=tsCustomerID%>",this.form.SHIPTOORG.value,"<%=dnDocNo.substring(2,5)%>")' value="<%=ShipToOrg%>" style="background:#FFFF99">		
		   			<INPUT TYPE="button" tabindex='5'  value="..." onClick='subWindowShipToFind("SHIP_TO","<%=tsCustomerID%>",this.form.SHIPTOORG.value,"<%=dnDocNo.substring(2,5)%>")'>
		   			<INPUT TYPE="text" NAME="SHIPADDRESS" tabindex='6' SIZE=80 value="<%=shipAddress%>" readonly style="border:1 solid:#996600"> 
		   			<INPUT TYPE="text" NAME="SHIPCOUNTRY" tabindex='7' SIZE=3 value="<%=shipCountry%>" readonly style="border:1 solid:#996600"> 
		   			</font>		   
	  			</td> 	  
			</tr>
			<tr bgcolor='#D5D8A7'>
	 	 		<td colspan="3"><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgBillTo"/></font>
	       			<input type="text" size="10" name="BILLTO" tabindex='8' onKeyDown='setBillToFind("BILL_TO","<%=tsCustomerID%>",this.form.BILLTO.value,"<%=dnDocNo.substring(2,5)%>")' value="<%=billTo%>" style="background:#FFFF99">		
		   			<INPUT TYPE="button" tabindex='9'  value="..." onClick='subWindowBillToFind("BILL_TO","<%=tsCustomerID%>",this.form.BILLTO.value,"<%=dnDocNo.substring(2,5)%>")'>
		   			<INPUT TYPE="text" NAME="BILLADDRESS" tabindex='10' SIZE=80 value="<%=billAddress%>" readonly style="border:1 solid:#996600"> 
		   			<INPUT TYPE="text" NAME="BILLCOUNTRY" tabindex='11' SIZE=3 value="<%=billCountry%>" readonly style="border:1 solid:#996600"> 
		   			</font>		   
	  			</td> 	  
			</tr> 	 
			<tr bgcolor='#D5D8A7'> 
	  			<td width="20%" colspan="1" nowrap>
	  				<font face="Arial" color="#996600">
      				<span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPaymentTerm"/>
      				</font>
	  				<font color="#996600">
					<input type="text" size="30" name="PAYTERM" tabindex='12' value="<%=paymentTerm%>" readonly>
	                <input type="hidden" size="10" name="PAYTERMID" tabindex='13' value="<%=payTermID%>">
					<INPUT TYPE="button" tabindex='14' value="..." onClick='subWindowPayTermFind(this.form.PAYTERMID.value)'>
	  				</font>
	  			</td>
	  			<td width="15%" colspan="1">
	  				<font face="Arial" color="#996600">
      				<span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgFOB"/></font>
	  				<font color="#996600">
					<input type="text" size="10" name="FOBPOINT" tabindex='15' value="<%=fobPoint%>">
	                <INPUT TYPE="button" tabindex='16' value="..." onClick='subWindowFOBPointFind(this.form.FOBPOINT.value)'>
	  				</font>
	  			</td>
	  			<td width="15%" colspan="1">
	  				<font face="Arial" color="#996600">
      				<span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgShippingMethod"/></font>
	  				<font color="#996600">
					<input type="text" size="10" name="SHIPMETHOD" tabindex='17' value="<%if (shipMethod==null || shipMethod.equals("null") || shipMethod=="") out.println(""); else out.println(shipMethod);%>" style="border:1 solid:#996600">
	                <INPUT TYPE="button" tabindex='18' value="..." onClick='subWindowShipMethodFind(this.form.SHIPMETHOD.value)'></font>
	  			</td>
			</tr>  
			<tr bgcolor='#D5D8A7'>
	  			<td colspan="3">
	  				<font face="Arial" color="#996600">
	  				<span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgOrgOrder"/>&nbsp;</font>
	   				<input type="text" tabindex='19' name="ORGORDER" value="<%=orgOrder%>" size="15" onKeyDown='setOrgOrderFind("<%=tsCustomerID%>",this.form.CUST_PO.value, "<%=firmOrderType%>", "<%=firmPriceList%>", "<%=dnDocNo%>", this.form.ORGORDER.value)' onMouseOver='this.T_ABOVE=false;this.T_WIDTH=215;this.T_OPACITY=80;return escape("<jsp:getProperty name="rPH" property="pgOrgOrderDesc"/>")'>
	   				<INPUT TYPE="button" tabindex='20' name="CHORGORDER" value="..." onClick='subWindowOrgOrderFind("<%=tsCustomerID%>",this.form.CUST_PO.value, "<%=firmOrderType%>", "<%=firmPriceList%>", "<%=dnDocNo%>", this.form.ORGORDER.value)' onMouseOver='this.T_ABOVE=false;this.T_WIDTH=215;this.T_OPACITY=80;return escape("<jsp:getProperty name="rPH" property="pgOrderChMsg"/>")'>
	   				<input type="hidden" name="MFGFACTORY" value="<%=mfgFactory%>" size="3">
	  			</td>
			</tr>
    		<tr bgcolor='#D5D8A7'> 
    			<td colspan="3">
      				<jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/>
      :&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font>
	  			<BR>
		<%
	    // 依訂單來源決定是否需找內銷匯率給定Selling Price_起
		String poCurr = "";
		double convRate = 1;
		if (orgID.equals("325"))
		{
			Statement stateCN=con.createStatement();
            ResultSet rsCN=stateCN.executeQuery(" select b.TO_CURRENCY_CODE, b.FIXED_VALUE "+
			                                    " from qp_currency_lists_vl a, qp_currency_details b "+		                                      
											    " where a.CURRENCY_HEADER_ID = b.CURRENCY_HEADER_ID  and a.BASE_CURRENCY_CODE = 'USD' "+
												" and b.TO_CURRENCY_CODE = 'CNY' and b.END_DATE_ACTIVE is null ");	
			if (rsCN.next()) 
			{ 
				poCurr = rsCN.getString(1);
				convRate = rsCN.getDouble(2);				 
			}
	    	rsCN.close();
	        stateCN.close();
		}		
		// 依訂單來源決定是否需找內銷匯率給定Selling Price_迄 
	  
	  	try
      	{   
			// 先將內容明細的標頭,給一維陣列
	    	String oneDArray[]= {"Line no.","Inventory Item","Quantity","UOM", "Request Date","Remark","Product Manufactory"};      			  
    		array2DGenerateSOrderBean.setArrayString(oneDArray);
			// 先取 該詢問單筆數
	     	int rowLength = 0;
	     	Statement stateCNT=con.createStatement();
         	ResultSet rsCNT=stateCNT.executeQuery("select count(LINE_NO) from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' "+
											   "and LSTATUSID = '"+frStatID+"' and SDRQ_EXCEED='N' ");	
	     	if (rsCNT.next()) rowLength = rsCNT.getInt(1);
	     	rsCNT.close();
	     	stateCNT.close();
	   		if (rowLength<1)
	   		{
	  	%>
		  	<font color="#003399">< <jsp:getProperty name="rPH" property="pgExceedValidDate"/>,<jsp:getProperty name="rPH" property="pgInvalidDoc"/> ></font>
		<%
	   		}	 
	  
	   		String b[][]=new String[rowLength+1][19]; // 宣告一二維陣列,分別是(未分配產地=列)X(資料欄數+1= 行)
	   		out.println("<TABLE border='1' cellpadding='1' cellspacing='0' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
	   		out.println("<tr bgcolor='#D5D8A7'>");	
	   		out.println("<td nowrap><font color='#FFFFFF'></font>");
	   	%>
	   		<input type="button" name="button1" onClick="this.value=check(this.form.CHKFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	   	<%
	   		out.println("</td>"); 	
	   		out.println("<td nowrap><font  color='#FFFFFF'>&nbsp;</font></td>");   	    
	   		out.println("<td width='1%' nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgAnItem"/>
	   	<%
	   		out.println("</td><td nowrap><div align=center>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/><jsp:getProperty name="rPH" property="pgDesc"/><BR>
	   	<%    
	    	out.println("</div></td><td nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgQty"/>
	   	<%
	   		out.println("</td><td nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgUOM"/>
	   	<% 
			if (computeSSD.equals("Y") || computeSSD.equals("X"))  //add by Peggychen 20120511
	   		{
	   			out.println("</td><td nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgCRDate"/>
	   	<% 
			}
			
			if (computeSSD.equals("Y") || computeSSD.equals("S") || computeSSD.equals("X"))  //add by Peggychen 20120511
			{
	   			out.println("</td><td nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgShippingMethod"/>
	   	<%
	   		}
	   		out.println("</td><td nowrap>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgRequestDate"/>
	   	<%	  
	   		out.println("</td>");	 
	   		out.println("<td width='1%' nowrap><font color='#996633'><div align=center>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgDesc"/><BR>
	   	<% 
	   		out.println("</div></font></td>");  
	   		out.println("<td nowrap><font  color='#996633'>");
	   		try
       		{ 
		  		out.println("<font color='#996633'><div align='center'>Selling Price</font><BR><input name='UPRICE' type='text' size='5' ");
		  		if (lineNo!=null) out.println("value="+uPrice); else out.println("value="+uPrice); 
		  		out.println("></div>");	   
	   		} //end of try		 
       		catch (Exception e) 
			{ 
				out.println("Exception5:"+e.getMessage()); 
			} 
	   		out.println("</font></td>");	   	
  	   		out.println("<td nowrap width='3%'><font color='#996633'><div align='center'>Mini Price</div>");
	   		out.println("</font></td>");	  
	   		out.println("<td nowrap width='5%'><font color='#996633'><div align='center'>");
	   	%>
	   	<jsp:getProperty name="rPH" property="pgSRDate"/>
	   	<%	  
	   		out.println("</div>");	    	
	   		try
        	{ 
		  		out.println("<input name='PROMISEDATE' type='text' size='6' ");
		  		if (lineNo!=null) out.println("value="+promiseDate); else out.println("value="+promiseDate); 
		  		out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.PROMISEDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	   		} //end of try		 
       		catch (Exception e) 
			{ 
				out.println("Exception6:"+e.getMessage()); 
			} 
	   		out.println("</font></td>");  
  	   		out.println("<td nowrap width='5%'><font color='#996633'><div align='center'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgSSD"/>
	   	<%	  
	   		out.println("</div>");		   
	   		try
        	{ 
		  		out.println("<input name='SSHIPDATE' type='text' size='6' ");
		  		if (lineNo!=null) out.println("value="+sShipDate); else out.println("value="+sShipDate); 
		  		out.println("><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.DISPLAYREPAIR.SSHIPDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");	   
	   		} //end of try		 
       		catch (Exception e) 
			{ 
				out.println("Exception7:"+e.getMessage()); 
			} 
	   		out.println("</font></td>");
	   		out.println("<td nowrap>");
	   		try
       		{ 
		  		out.println("<font color='#996633'><div align='center'><img src='../image/point.gif'>Line Type</div></font>");
		  		out.println("<div align='center'>");
		  		Statement statement=con.createStatement();
          		ResultSet rs=null;	
		  		String sqlOrgInf = " select wf.LINE_TYPE_ID, vl.name as LINE_TYPE "+
			                       " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl ";
		  		String sqlOrgWhere = " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
                                     "  and vl.language = 'US' "+
                                     "  and to_char(ORDER_TYPE_ID) = '"+firmOrderType+"' and END_DATE_ACTIVE is NULL ";		  	   
		  		if (sampleOrder.equals("Y") && !firmOrderType.equals("1114")) // 若是樣品訂單,再判斷是否要收費
		  		{	
		    		if (sampleCharge==null || sampleCharge.equals("")	|| sampleCharge.equals("N")) 
		    		{
			   			sqlOrgWhere = sqlOrgWhere + "and TO_CHAR(LINE_TYPE_ID) in ('1013','1161','1163','1703') ";  // 只出貨不立帳
					}                 
		    		else if (sampleCharge.equals("Y")) 
		    		{
		       			sqlOrgWhere = sqlOrgWhere + "and TO_CHAR(LINE_TYPE_ID) not in ('1013','1161','1703') ";  
		    		}			
		 		}			
		 		sqlOrgInf = sqlOrgInf + sqlOrgWhere;   
         		rs=statement.executeQuery(sqlOrgInf);
		 		comboBoxBean.setRs(rs);
		 		comboBoxBean.setSelection(lineType);
	     		comboBoxBean.setFieldName("LINE_TYPE");	   
         		out.println(comboBoxBean.getRsString());
				   	  		  
		 		rs.close();   
		 		statement.close(); 
		 		out.println("</div>");	   
			} //end of try		 
       		catch (Exception e) 
			{ 
				out.println("Exception8:"+e.getMessage()); 
			} 
	   		out.println("</font></td>");
			//add by Peggy 20130430
			out.println("<td><font color='#000000'><div align='center'>");
			%>
			<jsp:getProperty name="rPH" property="pgRemark"/>
			<%
			out.println("</div></font></td>");
			//add by Peggy 20130628
			out.println("<td align='center' width='8%'><font color='#000000'>");
			%>
			<jsp:getProperty name="rPH" property="pgCustPONo"/>
			<%
			out.println("</font></td>");
			out.println("<td align='center' width='8%'>End Customer</td>"); //add by Peggy 20160219
			
			if (tsCustomerID.equals("14980") || tsCustomerID.equals("15540"))  //add by Peggy 20170220
			{
				out.println("<td align='center' width='8%'>BI Region</td>"); //add by Peggy 20160219	
			}
	   		out.println("</tr>"); 
			
	   
	   		String itemExistAlert = "FALSE";
	   		int k=0;
			String unAssignORG=""; //add by Peggy 20160219
	   		String buttonContent=null;
       		Statement statement=con.createStatement();
       		String lineSql = " select a.LINE_NO, a.ITEM_DESCRIPTION, a.QUANTITY, a.UOM, a.REQUEST_DATE, a.REMARK,"+
	                         " a.ASSIGN_MANUFACT, a.FTACPDATE, a.INVENTORY_ITEM_ID, a.SELLING_PRICE, a.LINE_TYPE,"+
						     " a.SHIP_DATE,PROMISE_DATE, a.ORDERED_ITEM, a.ORDERED_ITEM_ID, a.ITEM_ID_TYPE, "+
						     " a.ITEM_SEGMENT1, b.MINI_PRICE, a.LIST_PRICE, a.CUST_PO_NUMBER, "+
						     " c.ALNAME, "+ // 2006/12/24 依各分派產地識別是否可Append 舊單
							 " a.CUST_REQUEST_DATE,a.SHIPPING_METHOD"+  //add by Peggychen 20110621
							 ",a.FTACPDATE,a.PC_COMMENT"+ //add by Peggy 20130430
							 ",nvl(a.AUTOCREATE_FLAG,'N') AUTOCREATE_FLAG"+ //add by Peggy 20120301
							 ",nvl(EDIT_CODE,'N/A') EDIT_CODE "+ //add by Peggy 20120712
							 ",a.END_CUSTOMER"+
							 ",a.END_CUSTOMER_SHIP_TO_ORG_ID"+ //add by Peggy 20160219
							 ",a.ASSIGN_MANUFACT "+  //add by Peggy 20160219
							 ",a.BI_REGION"+  //add by Peggy 20170220
							 ",a.REASON_CODE"+  //add by Peggy 20190401
							 ",tsc_item_pcn_flag(43,a.inventory_item_id,to_date(substr(a.creation_date,1,8),'yyyymmdd')) pcn_flag"+  //add by Peggy 20230204
							 ",nvl((select 'Y' from oe_items_v x where x.item=a.ORDERED_ITEM and x.inventory_item_id=a.inventory_item_id and x.sold_to_org_id=d.tscustomerid),'N') as custitem_flag"+  //add by Peggy 20230204
							 " from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
							 ",ORADDMAN.TSPROD_MANUFACTORY c"+ 
                             ",(select b.INVENTORY_ITEM_ID, ROUND((b.MINI_PRICE / 1000),6) MINI_PRICE from ORADDMAN.TSITEM_MINIPRICE_HEADERS a ,ORADDMAN.TSITEM_MINIPRICE_LINES b "+
                             " where to_char(a.MASTER_GROUP_ID) = '"+masterGroupID +"' "+
                             " and a.CURRENCY = '"+curr+"' "+
                             " and a.PRICE_HEADER_ID = b.PRICE_HEADER_ID ) b"+
							 ",ORADDMAN.TSDELIVERY_NOTICE d"+ //add by Peggy 20210817
						     " where a.DNDOCNO='"+dnDocNo+"' and a.ASSIGN_MANUFACT = c.MANUFACTORY_NO "+
							 //" and c.ALNAME = '"+assignMFGAlName+"' "+ 
							 " and c.MANUFACTORY_NO='"+assignManufact+"'"+
							 " and a.LSTATUSID = '"+frStatID+"' "+
							 " and a.SDRQ_EXCEED='N' "+
                             " and a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID(+) "+
							 " and a.dndocno=d.dndocno"+ //add by Peggy 20210817
							 " and NVL((select 'Y' from oraddman.tssg_vendor_tw y where nvl(y.active_flag,'I')='A' and y.plant_code=a.assign_manufact and y.vendor_site_id=a.vendor_site_id),'N')='"+tw_vendor_flag+"'"; //add by Peggy 20200224
			if (REASON_CODE.equals("08"))  //add by Peggy 20210817
			{
				lineSql += " and a.REASON_CODE='"+REASON_CODE+"'";
			}
			else if (!salesAreaNo.equals("006") && !salesAreaNo.equals("005") && !firmOrderType.equals("1663"))
			{
				lineSql += " and nvl(a.ORDER_TYPE_ID,d.order_type_id)='"+firmOrderType+"'";
			}						
			lineSql += " order by a.LINE_NO ";
			//out.println(lineSql);
       		ResultSet rs=statement.executeQuery(lineSql);
	   		while (rs.next())
	   		{	     
	        	String itemStatusCode="Active";
			 	String stockEnable="Y";
			 	String transactionEnable="Y";
	         	String trBGColor = "#FFFFFF";
				unAssignORG="";
	         	Statement stateChkItem=con.createStatement();
             	ResultSet rsChkItem=stateChkItem.executeQuery(" select INVENTORY_ITEM_ID, INVENTORY_ITEM_STATUS_CODE, "+
			                                                  " STOCK_ENABLED_FLAG, MTL_TRANSACTIONS_ENABLED_FLAG "+
			                                                  " from MTL_SYSTEM_ITEMS "+
		                                                      " where SEGMENT1='"+rs.getString("ITEM_SEGMENT1")+"' "+	
                                                              " and ORGANIZATION_ID = '"+setOrderTypeOrg+"' ");	
			 	if (rsChkItem.next()) 	
			 	{ 
					//add by Peggy 20160222
					if (rs.getString("ASSIGN_MANUFACT").equals("002"))
					{
						 if (firmOrderType.equals("1015") || firmOrderType.equals("1021") || firmOrderType.equals("1022"))
						 {
							Statement stateChkItem1=con.createStatement();
							ResultSet rsChkItem1=stateChkItem1.executeQuery(" select INVENTORY_ITEM_ID, INVENTORY_ITEM_STATUS_CODE, "+
																		  " STOCK_ENABLED_FLAG, MTL_TRANSACTIONS_ENABLED_FLAG "+
																		  " from MTL_SYSTEM_ITEMS "+
																		  " where SEGMENT1='"+rs.getString("ITEM_SEGMENT1")+"' "+	
																		  " and ORGANIZATION_ID =327 ");	
							if (!rsChkItem1.next()) 	
							{	
								trBGColor = "#FFFF00";
								itemExistAlert = "TRUE"; 
								unAssignORG="Y2";												 
							}
							else
							{
								trBGColor = "#FFFFFF";		
								itemStatusCode=rsChkItem.getString("INVENTORY_ITEM_STATUS_CODE");
								stockEnable=rsChkItem.getString("STOCK_ENABLED_FLAG");
								transactionEnable=rsChkItem.getString("MTL_TRANSACTIONS_ENABLED_FLAG");						
							}
							rsChkItem1.close();
							stateChkItem1.close();							
						 }
					}
					else
					{
						trBGColor = "#FFFFFF";		
						itemStatusCode=rsChkItem.getString("INVENTORY_ITEM_STATUS_CODE");
						stockEnable=rsChkItem.getString("STOCK_ENABLED_FLAG");
						transactionEnable=rsChkItem.getString("MTL_TRANSACTIONS_ENABLED_FLAG");
					}	   
			 	}	
			 	else 
			 	{ 
			 		trBGColor = "#FFFF00";
			    	itemExistAlert = "TRUE"; 
					//out.println("setOrderTypeOrg="+setOrderTypeOrg);
					Statement state1=con.createStatement();
             		ResultSet rs1=state1.executeQuery(" select organization_code from mtl_parameters a where organization_id="+setOrderTypeOrg+"");
			 		if (rs1.next()) 	
			 		{
						unAssignORG=rs1.getString(1); 					
					}
					rs1.close();
					state1.close();
			 	} // 檢查Org的Item,不存在用黃底標示			
			 	rsChkItem.close();
			 	stateChkItem.close();
				String yellowMsg = "Yellow means no Item Exists on Org. with respect to Order Type";
		
				// 2007/03/27 把取得的Target Price 取至小數4位_起
		   		java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.0000"); // 取小數後四位 
	       		java.math.BigDecimal bd = null;
		   		java.math.BigDecimal strTargetPrice = null;
		   		try
		   		{
					bd = new java.math.BigDecimal(rs.getDouble("LIST_PRICE")*convRate/1000);
				   	strTargetPrice = bd.setScale(4, java.math.BigDecimal.ROUND_HALF_UP);
				   
		   		} //end of try
           		catch (NumberFormatException e)
           		{
                	System.out.println("Exception9: Target Price"+e.getMessage());
           		}
		   
				// 2007/03/27 把取得的Target Price 取至小數4位_迄
	    		out.println("<TR bgcolor='"+trBGColor+"'>");
				out.println("<TD width='2%'><div align='center'>");
				//if (((actionID ==null || !actionID.equals("013")) && itemStatusCode.equals("Inactive")) || rs.getString("AUTOCREATE_FLAG").equals("Y"))  //add by Peggy 20120511加入退件判斷
				//{
				//	out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' style='visibility: hidden;'>");
				//}
				//else
				//{
					out.println("<input type='checkbox' name='CHKFLAG' value='"+rs.getString("LINE_NO")+"' onclick='setchk("+k+")' "+((((actionID ==null || !actionID.equals("013")) && itemStatusCode.equals("Inactive")) || rs.getString("AUTOCREATE_FLAG").equals("Y"))?"style='visibility: hidden;'":""));
					if (((actionID ==null || !actionID.equals("013")) && itemStatusCode.equals("Inactive")) || rs.getString("AUTOCREATE_FLAG").equals("Y")) //add by Peggy 20230204
					{
						out.println(" >");
					}
					else
					{
						if (check !=null) // 若先前以設定為選取,則Check Box 顯示 checked
						{
							for (int j=0;j<check.length;j++) 
							{ 
								if (check[j]==rs.getString("LINE_NO") || check[j].equals(rs.getString("LINE_NO")) ) out.println("checked");  
							}
							// 給定單價即設定欲結轉
							if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) out.println("checked"); 
						} 
						else if (lineNo==rs.getString("LINE_NO") || lineNo.equals(rs.getString("LINE_NO"))) //第一筆給定單價即設定欲結轉
						{
							out.println("checked"); 
						}
			 
						if (rowLength==1) out.println("checked >"); else out.println(" >");
					}
				//}
				out.println("</div>");
				out.println("<input type='hidden' name='EDITCODE"+k+"' value="+'"'+rs.getString("EDIT_CODE")+'"'+">"); //add by Peggy 20120712
				out.println("<input type='hidden' name='UNASSIGNORG"+k+"' value='"+unAssignORG+"'>");  //add by Peggy 20160222
				out.println("<input type='hidden' name='PCN_FLAG"+k+"' value='"+rs.getString("pcn_flag")+"'>"); //add by Peggy 20230208
				out.println("</TD>");
				// Set 按鈕_起
				out.println("<TD width='2%'><div align='center'>");
				if (trBGColor=="#FFFF00" || trBGColor.equals("#FFFF00"))
				{ 
					// 若 無料號原訂單類型所屬的 Org 則顯示 Tool Tip 說明
		  			out.print("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?LINENO="+rs.getString("LINE_NO")+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+firmOrderType+"&DNDOCNO="+dnDocNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+rs.getFloat("MINI_PRICE")+'"'+","+'"'+rs.getString("ALNAME")+'"'+","+'"'+itemStatusCode+'"'+","+'"'+"");
		  %><jsp:getProperty name="rPH" property="pgFactDiffMsg"/><%out.print(""+'"'+")' ");      
		  //out.print("onMouseOver='this.T_ABOVE=false;this.T_WIDTH=300;this.T_OPACITY=80;return escape("+'"'+yellowMsg+'"'+")'>");
		  			out.print("onMouseOver='this.T_ABOVE=false;this.T_WIDTH=300;this.T_OPACITY=80;return escape("+'"'+"");
		  %><jsp:getProperty name="rPH" property="pgYellowItem"/><jsp:getProperty name="rPH" property="pgDenote"/><jsp:getProperty name="rPH" property="pgItemExistsMsg"/><%out.print(""+'"'+")'>"); 				
				}
				else 
				{
					out.print("<INPUT TYPE='button' value='Set' onClick='setSubmit2("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?LINENO="+rs.getString("LINE_NO")+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+firmOrderType+"&DNDOCNO="+dnDocNo+"&EXPAND="+expand+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+rs.getFloat("MINI_PRICE")+'"'+","+'"'+rs.getString("ALNAME")+'"'+","+'"'+itemStatusCode+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgFactDiffMsg"/><%out.print(""+'"'+")'>");       
				}
				out.println("</div></TD>");		
				// Set 按鈕_迄
				out.println("<TD><font size='2'><a name="+rs.getString("LINE_NO")+">"+rs.getString("LINE_NO")+"</a></font></TD>");
				// 台半料號說明_起
				out.println("<TD width='2%' nowrap><font size='2'>");
				out.println("<a href=javaScript:popMenuMsg('"+strTargetPrice+"') onmouseover='this.T_WIDTH=80;return escape("+strTargetPrice+")'>");
				out.print(rs.getString("ITEM_DESCRIPTION"));
				out.println("</a>");
				if (itemStatusCode.equals("Inactive") || rs.getString("pcn_flag").equals("Y")) //add by Peggy 20230204
				{
					out.println("<font color='red'>("+(itemStatusCode.equals("Inactive")?itemStatusCode:"")+(rs.getString("pcn_flag").equals("Y")?(itemStatusCode.equals("Inactive")?"&":"")+"PCN/PDN":"")+")</font>");
				}
				out.println("</font></TD>"); 
				out.println("<TD width='2%' nowrap><font size='2'>"+rs.getString("QUANTITY")+"</font></TD>");
				out.println("<TD width='1%' nowrap><font size='2'>"+rs.getString("UOM")+"</font></TD>");
				if (computeSSD.equals("Y") || computeSSD.equals("X"))  //modify by Peggy 20120511
				{
					out.println("<TD width='3%' nowrap><font size='2'>"+((rs.getString("CUST_REQUEST_DATE")==null)?"&nbsp;":rs.getString("CUST_REQUEST_DATE"))+"</font></TD>");  
				}
				if (computeSSD.equals("Y") || computeSSD.equals("S") || computeSSD.equals("X")) //modify by Peggy 20120511
				{
					out.println("<TD width='3%' nowrap><font size='2'>"+((rs.getString("SHIPPING_METHOD")==null)?"&nbsp;":rs.getString("SHIPPING_METHOD"))+"</font></TD>");
				}				
				out.println("<TD width='3%' nowrap><font size='2'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</font></TD>");
				out.print("<TD width='3%' nowrap><font size='2'>");
				out.print("<INPUT TYPE='TEXT' NAME='CITEMDESC"+rs.getString("LINE_NO")+"' value='");
				if (rs.getString("ORDERED_ITEM")=="N/A" || rs.getString("ORDERED_ITEM").equals("N/A"))
				{ 	
					out.println("");			
				}
				else
				{
					out.println(rs.getString("ORDERED_ITEM")); 
				}
				out.println("' size=10 readonly>");   // rsChkItem
				buttonContent="subWindowCustItemFind("+'"'+tsCustomerID+'"'+","+'"'+rs.getString("INVENTORY_ITEM_ID")+'"'+","+'"'+rs.getString("ITEM_DESCRIPTION")+'"'+","+'"'+dnDocNo+'"'+","+'"'+rs.getString("LINE_NO")+'"'+","+'"'+itemStatusCode+'"'+","+'"'+stockEnable+'"'+","+'"'+transactionEnable+'"'+")";		
       	 		out.println("<INPUT TYPE=button NAME='button' VALUE='...' onClick='"+buttonContent+"'>");
				out.println("<INPUT TYPE='hidden' NAME='CITEMID"+rs.getString("LINE_NO")+"' value='"+rs.getString("ORDERED_ITEM_ID")+"'>");
				out.println("<INPUT TYPE='hidden' NAME='CITEMTYPE"+rs.getString("LINE_NO")+"' value='"+rs.getString("ITEM_ID_TYPE")+"'>");
				out.println("</font>"+(!rs.getString("ORDERED_ITEM").equals("N/A") && rs.getString("custitem_flag").equals("N")?"<font color='red'>cust item issue</font>":"")+"</TD>");		
				out.println("<TD width='3%' nowrap>");	
				out.println("<font  color='#0000ff' size='2'><div id='sellingprice"+k+"'>"+rs.getFloat("SELLING_PRICE")+"</div></font>");  
				out.println("</TD>");		
        		// 取Item Mini Price
				out.println("<TD width='3%' nowrap>");
        		out.print("<font size='2'>"+rs.getFloat("MINI_PRICE")+"</font>");
	    		out.print("<INPUT TYPE='hidden' NAME='MINIPRICE' SIZE=10 value='"+rs.getFloat("MINI_PRICE")+"' > ");
				out.println("</TD>");
				out.println("<TD width='5%' nowrap>");
				if (rs.getString("PROMISE_DATE")!=null && !rs.getString("PROMISE_DATE").equals("") && !rs.getString("PROMISE_DATE").equals("N/A"))
				{ 
		   			out.println("<font color='#0000ff'>"); 
					out.println(rs.getString("PROMISE_DATE").substring(0,8)+"</font>");	
				}	
				out.println("</TD>");
				out.println("<TD width='5%' nowrap>");
	    		if (rs.getString("SHIP_DATE")!=null && !rs.getString("SHIP_DATE").equals("") && !rs.getString("SHIP_DATE").equals("N/A"))
				{ 
					SimpleDateFormat dateFormat = new SimpleDateFormat ("yyyyMMdd");
					java.util.Date timeDate = dateFormat.parse(rs.getString("REQUEST_DATE").substring(0,8));
					java.util.Calendar cal=java.util.Calendar.getInstance(); 
					cal.setTime(timeDate); 
					cal.add(java.util.Calendar.DATE,-7);
					timeDate =cal.getTime();
					if (computeSSD.equals("Y") && timeDate.compareTo(dateFormat.parse(rs.getString("SHIP_DATE").substring(0,8)))>=0)
					{
						out.println("<font  color='#0000FF'><strong>"+rs.getString("SHIP_DATE").substring(0,8)+"</strong></font>");	
					}
					else
					{
						out.println("<font  color='#FF0000'>"+rs.getString("SHIP_DATE").substring(0,8)+"</font>");
					}
				}	
				
				out.println("<input type='hidden' name='FTACPDATE"+rs.getString("LINE_NO")+"' value='"+rs.getString("FTACPDATE")+"'>");
				out.println("<input type='hidden' name='ORIGSHIPDATE"+rs.getString("LINE_NO")+"' value='"+rs.getString("SHIP_DATE")+"'>");
				out.println("</TD>");
				out.println("<TD width='5%' nowrap>");
	    		if (rs.getString("LINE_TYPE")==null || rs.getString("LINE_TYPE").equals("") || rs.getString("LINE_TYPE")=="0" || rs.getString("LINE_TYPE").equals("0"))
				{ 
					out.println("<font size='2'><input type='text' name ='SLINETYPE"+k+ "' value='"); 
					out.println("' readonly></font>"); 				
				}
				else  
				{ 
					out.println("<font  color='#FF0000'><input type='text' name ='SLINETYPE"+k+ "' value='"); 
					out.println(rs.getString("LINE_TYPE"));	
					out.println("' readonly></font>"); 				
				}	
				out.println("</TD>");
				out.println("<td align='left' style='color:#0000ff'>"+(rs.getString("PC_COMMENT")==null?"&nbsp;":rs.getString("PC_COMMENT"))+"</td>");
				out.println("<td align='left'><div id='CUSTPO_"+k+"'>"+(rs.getString("CUST_PO_NUMBER")==null?"&nbsp;":rs.getString("CUST_PO_NUMBER"))+"</div></td>"); //add by Peggy 20130628
				out.println("<td align='left'><div id='END_CUST_"+k+"'>"+(rs.getString("END_CUSTOMER")==null?"&nbsp;":rs.getString("END_CUSTOMER"))+"</div>");
				out.println("<INPUT TYPE='hidden' NAME='END_CUST_SHIP_TO_"+k+"' value='"+(rs.getString("END_CUSTOMER_SHIP_TO_ORG_ID")==null?"":rs.getString("END_CUSTOMER_SHIP_TO_ORG_ID"))+"'>");
				out.println("<input type='hidden' name='REASON_CODE"+k+"' value='"+rs.getString("REASON_CODE")+"'>");  //add by Peggy 20190401
				out.println("</td>"); //add by Peggy 20160219
				if (tsCustomerID.equals("14980") || tsCustomerID.equals("15540"))  //add by Peggy 20170220
				{
					out.println("<td align='center'>"+(rs.getString("BI_REGION")==null?"&nbsp;":rs.getString("BI_REGION"))+"<input type='hidden' name='BI_REGION_"+k+" value='"+(rs.getString("BI_REGION")==null?"":rs.getString("BI_REGION"))+"'></td>"); //add by Peggy 20160219	
				}				
				out.println("</TR>");
				b[k][0]=rs.getString("LINE_NO");		
				b[k][1]=rs.getString("ITEM_DESCRIPTION");			
				b[k][2]=rs.getString("QUANTITY");
				b[k][3]=rs.getString("UOM");
				b[k][4]=rs.getString("CUST_REQUEST_DATE");
				b[k][5]=rs.getString("SHIPPING_METHOD");
				b[k][6]=rs.getString("REQUEST_DATE");
				b[k][7]=rs.getString("REMARK");
				b[k][8]=rs.getString("FTACPDATE");
				b[k][9]=rs.getString("INVENTORY_ITEM_ID");
				b[k][10]=Float.toString(rs.getFloat("SELLING_PRICE"));
				b[k][11]=Integer.toString(rs.getInt("LINE_TYPE"));
				b[k][12]=rs.getString("PROMISE_DATE");
				b[k][13]=rs.getString("SHIP_DATE");	
				b[k][14]=rs.getString("ORDERED_ITEM"); // 若設定ORDERED_ITEM,則以台半料號為Ordered Item 給 API
				b[k][15]=rs.getString("ORDERED_ITEM_ID");
				b[k][16]=rs.getString("ITEM_ID_TYPE");	
				b[k][17]=rs.getString("ITEM_SEGMENT1"); // 把台半料號取出來,若使用者未給客戶料號,則ORDERED_ITEM亦給台半料號
				if (rs.getString("CUST_PO_NUMBER")==null || rs.getString("CUST_PO_NUMBER").equals("null")) b[k][18]= "N/A";
				else b[k][18]=rs.getString("CUST_PO_NUMBER");  // 2006/06/06 取上載Line PO Number
				array2DGenerateSOrderBean.setArray2DString(b);
				k++;
			}  // End of while (rs.next())  	   	   	 
			out.println("</TABLE>");
			statement.close();
    		rs.close();  	
	   
			if (itemExistAlert.equals("TRUE") && alertItemAssignMsg.equals("N"))
			{
				alertItemAssignMsg = "Y";
	    	%>
		    <script language="javascript">
				alertItemORGAssignMsg("<jsp:getProperty name='rPH' property='pgAlertItemOrgAssignMsg'/>");	
			</script>
	    	<%
			}
	   
		} //end of try
		catch (Exception e)
		{
			out.println("Exception10:"+e.getMessage());
		}

		String a[][]=array2DGenerateSOrderBean.getArray2DContent();//取得目前陣列內容 
		if (a!=null) 	
		{		  	
		}	//enf of a!=null if		
	%> 
			</font>      
			</tr>    
			<tr bgcolor="#D5D8A7"> 
				<td colspan="3" width='100%'><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgProcessMark"/>: 
        			<INPUT TYPE="TEXT" NAME="REMARK" SIZE=60 maxlength="60" value="<%=remark%>">
					<INPUT type="hidden" name="WORKTIME" value="0">
        			<INPUT TYPE="hidden" NAME="SOFTWAREVER" SIZE=60 ></font>           
    			</td>
			</tr>
			<tr bgcolor="#D5D8A7">
    			<td><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgProcessUser"/>:</font><font face="Arial" color="#996600"><%=userID+"("+UserName+")"%></font>
				</td>
    			<td><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgProcessDate"/>:<%=dateBean.getYearMonthDay()%>
    			</font>
				</td>
    			<td><font face="Arial" color="#996600"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgProcessTime"/>:<%=dateBean.getHourMinuteSecond()%></font>
    			</td>
			</tr>       
		</table>
		</TD>
	</TR>
</TBODY>
</TABLE>
<%
}  // End of if (frStatID.equals("009"))
%>
<table align="left">
	<tr>	
		<td colspan="3">
		<strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
   		<a name='#ACTION'>
<%
try
{  
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("select x1.ACTIONID, x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
	                                    " WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID "+
										" and  x1.LOCALE='"+locale+"' order by x2.ACTIONNAME desc ");
	out.println("<select NAME='ACTIONID' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQGeneratingPage.jsp?DNDOCNO="+dnDocNo+"&LINE_NO="+line_No+"&ASSIGN_MANUFACT="+assignManufact+"&ORDER_TYPE_ID="+firmOrderType+'"'+")'>");				  				  
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
	   
	rs=statement.executeQuery("select COUNT (*) from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
	" WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	rs.next();
	if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	{
		if (actionID==null || actionID.equals("012"))
		{  // 若是單純新增產生 MO 單,則呼叫原MProcess
			out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='submitCheckProcess("+'"'+"../jsp/TSSalesDRQMProcess.jsp?DNDOCNO="+dnDocNo+'"'+","+'"'+"");
		            %><jsp:getProperty name="rPH" property="pgAlertMOGenSubmit"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertSubmit"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertSvrType"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertCustomer"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertPriceList"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertShipAddress"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertBillAddress"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertPayTerm"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertFOB"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertShipMethod"/><%out.print(""+'"'+","+'"'+"");		
					%><jsp:getProperty name="rPH" property="pgAppendMOMsg"/><%out.print(""+'"'+","+'"'+"");			  
				    %><jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/><%out.print(""+'"'+")'>");
		}
		else if (actionID.equals("030")) 
		{   // 若是 030(APPEND) 則呼叫另一個MPROCESS程式
			out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='submitCheckProcess("+'"'+"../jsp/TSSalesDRQApndMProcess.jsp?DNDOCNO="+dnDocNo+'"'+","+'"'+"");
		            %><jsp:getProperty name="rPH" property="pgAlertMOCmbSubmit"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertSubmit"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertSvrType"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertCustomer"/><%out.print(""+'"'+","+'"'+""); 
				    %><jsp:getProperty name="rPH" property="pgAlertPriceList"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertShipAddress"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertBillAddress"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertPayTerm"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertFOB"/><%out.print(""+'"'+","+'"'+"");
				    %><jsp:getProperty name="rPH" property="pgAlertShipMethod"/><%out.print(""+'"'+","+'"'+"");	
					%><jsp:getProperty name="rPH" property="pgAppendMOMsg"/><%out.print(""+'"'+","+'"'+"");				  
				    %><jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/><%out.print(""+'"'+")'>");
		} 
		else if (actionID.equals("013"))
		{  //若是 013(ABORT) 則呼叫另一個MPROCESS程式
			out.print("<INPUT TYPE='button' NAME='submit2' tabindex='30' value='Submit' onClick='submitCheckProcess("+'"'+"../jsp/TSSalesDRQApndMProcess.jsp?DNDOCNO="+dnDocNo+'"'+","+'"'+"");
		                  %><jsp:getProperty name="rPH" property="pgAlterGenAbort"/><%out.print(""+'"'+","+'"'+""); 
				          %><jsp:getProperty name="rPH" property="pgAlertSubmit"/><%out.print(""+'"'+","+'"'+""); 
				          %><jsp:getProperty name="rPH" property="pgAlertSvrType"/><%out.print(""+'"'+","+'"'+""); 
				          %><jsp:getProperty name="rPH" property="pgAlertCustomer"/><%out.print(""+'"'+","+'"'+""); 
				          %><jsp:getProperty name="rPH" property="pgAlertPriceList"/><%out.print(""+'"'+","+'"'+"");
				          %><jsp:getProperty name="rPH" property="pgAlertShipAddress"/><%out.print(""+'"'+","+'"'+"");
				          %><jsp:getProperty name="rPH" property="pgAlertBillAddress"/><%out.print(""+'"'+","+'"'+"");
				          %><jsp:getProperty name="rPH" property="pgAlertPayTerm"/><%out.print(""+'"'+","+'"'+"");
				          %><jsp:getProperty name="rPH" property="pgAlertFOB"/><%out.print(""+'"'+","+'"'+"");
				          %><jsp:getProperty name="rPH" property="pgAlertShipMethod"/><%out.print(""+'"'+","+'"'+"");	
					      %><jsp:getProperty name="rPH" property="pgAppendMOMsg"/><%out.print(""+'"'+","+'"'+"");				  
				          %><jsp:getProperty name="rPH" property="pgAlertCheckLineFlag"/><%out.print(""+'"'+")'>");
		}				 	 
		out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES'>");%><jsp:getProperty name="rPH" property="pgMailNotice"/><%
		if (actionID==null) 
		{ 
		}
		else if (actionID.equals("013"))
		{
			out.println("&nbsp;<INPUT TYPE='checkBox' NAME='NEWDRQOPTION' VALUE='YES'>");
		  %><font color="#FF0000"><strong><jsp:getProperty name="rPH" property="pgAbortToTempDRQ"/></strong></font><%
		} 
	} 
    rs.close();       
	statement.close();
} //end of try
catch (Exception e)
{
	out.println("Exception11:"+e.getMessage());
}
%>
</a>
		</td>
	</tr>
</table>
<!-- 表單參數 --> 
<INPUT TYPE="hidden" NAME="SASCODATE" SIZE=14 value="<%=dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()%>" >
<INPUT TYPE="hidden" NAME="PARTYID" SIZE=5 value="<%=partyID%>" >
<INPUT TYPE="hidden" NAME="CURR" SIZE=5 value="<%=curr%>" >
<INPUT TYPE="hidden" NAME="PRCURR" SIZE=5 value="<%=curr%>" >
<INPUT TYPE="hidden" NAME="MASTERGROUPID" SIZE=5 value="<%=masterGroupID%>" >
<INPUT TYPE="hidden" NAME="CUST_PO" SIZE=5 value="<%=custPO%>" >
<INPUT TYPE="hidden" NAME="LINENO" SIZE=5 value="<%=lineNo%>" >
<INPUT TYPE="hidden" NAME="LINE_NO" SIZE=5 value="<%=line_No%>" >
<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >
<input name="ALERTMSG" type="HIDDEN" value="<%=alertMsg%>" >
<input name="ALERTITEMASSIGNMSG" type="hidden" value="<%=alertItemAssignMsg%>" >
<input name="SETENTER" type="HIDDEN" value="<%=setEnter%>" >
<input name="NCONTACT" type="HIDDEN" value="<%=notifyContact%>" >
<input name="NLOCATION" type="HIDDEN" value="<%=notifyLocation%>" >
<input name="SCONTACT" type="HIDDEN" value="<%=shipContact%>" >
<input name="DCUSTOMER" type="HIDDEN" value="<%=deliverCustomer%>" >
<input name="DLOCATION" type="HIDDEN" value="<%=deliverLocation%>" >
<input name="DELIVERTO" type="hidden" value="<%=deliverTo%>" >
<input name="DADDRESS" type="HIDDEN" value="<%=deliverAddress%>" >
<input name="NOTIFYSET" type="HIDDEN" value="<%=notifySet%>" >
<input name="DELIVERSET" type="HIDDEN" value="<%=deliverSet%>" >
<input name="SAMPLEORDER" type="HIDDEN" value="<%=sampleOrder%>" >
<input name="computeSSD" type="HIDDEN" value="<%=computeSSD%>">
<input name="CREATEDBY" type="hidden" value="<%=createdBy%>">
<input name="SALESAREANO" type="hidden" value="<%=salesAreaNo%>"> 
<input name="TW_VENDOR_FLAG" type="hidden" value="<%=tw_vendor_flag%>">
<input name="REASON_CODE" type="hidden" value="<%=REASON_CODE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
