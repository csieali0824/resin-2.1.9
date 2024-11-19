<!--add by Peggy 20140826,新增ERP END CUSTOMER ID欄位-->
<!--20150616 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!--20160113 by Peggy,客戶名稱為空時 read ar_customers-->
<!--20170216 by Peggy,add sales region for bi-->
<!--20170512 by Peggy,add end cust ship to id-->
<%@ page language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal")	gfPop.fHideCal();
}

// 限制使用者直接按 F5 重新整理,導致 arrayBean 取值異常的問題
//function document.onkeydown() 
//{ 
	//if (event.keyCode==116) 
    //{ 
    //	event.keyCode = 0; 
        //event.cancelBubble = true; 
     //   return false; 
    //}
//}
//

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

function submitCheck(field)
{  
	// 確認送出前先提示使用者是否存為草稿     
   	if (document.MYFORM.ACTIONID.value=="002")  //表示為確認送出產生訂單動作
   	{ 
    	flag=confirm(ms1);      
    	if (flag==false) return(false);
		else
        {   // 若確認送出再檢查
			return (true);
		}

 		 //檢查是否選取的資料有填入相對應的DATA
  		if (field.length==null)
 	 	{
     		if (field.checked==true)
	 		{
	    		if (document.MYFORM.elements["DUEDATE-"+field.value].value=="" || document.MYFORM.elements["DUEDATE-"+field.value].value==null || document.MYFORM.elements["QTY-"+field.value].value=="" || document.MYFORM.elements["QTY-"+field.value].value==null)
				{ 
			  		alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  		return(false);
				}  
			
				txt1=document.MYFORM.elements["QTY-"+field.value].value;	
				txt2=document.MYFORM.elements["DUEDATE-"+field.value].value;	
				for (j=0;j<txt1.length;j++)      
				{ 
			   		c=txt1.charAt(j);
					if ("0123456789.".indexOf(c,0)<0) 
			   		{
				 		alert("The data that you inputed should be numerical!!");    
				 		return(false);
					}
				}	
			
				for (j=0;j<txt2.length;j++)      
				{ 
			   		c=txt2.charAt(j);
					if ("0123456789.".indexOf(c,0)<0) 
			   		{
				 		alert("The data that you inputed should be numerical!!");    
				 		return(false);
					}
				}	
	 		}
  		} 
		else 
		{
	  		for (i = 0; i < field.length; i++)  
	  		{	   
				if (field[i].checked == true)
				{	   		  			
					if (document.MYFORM.elements["DUEDATE-"+field[i].value].value=="" || document.MYFORM.elements["DUEDATE-"+field[i].value].value==null || document.MYFORM.elements["QTY-"+field[i].value].value=="" || document.MYFORM.elements["QTY-"+field[i].value].value==null)
					{ 
			  			alert("Before you submit, please do not let the data that you choosed be Null !!");   
			  			return(false);
					}  
			
					txt1=document.MYFORM.elements["QTY-"+field[i].value].value;	
					txt2=document.MYFORM.elements["DUEDATE-"+field[i].value].value;	
					for (j=0;j<txt1.length;j++)      
					{ 
			   			c=txt1.charAt(j);
						if ("0123456789.".indexOf(c,0)<0) 
			   			{
				 			alert("The data that you inputed should be numerical!!");    
				 			return(false);
						}
					}	
			
					for (j=0;j<txt2.length;j++)      
					{ 
			   			c=txt2.charAt(j);
						if ("0123456789.".indexOf(c,0)<0) 
			   			{
				 			alert("The data that you inputed should be numerical!!");    
				 			return(false);
						}
					}							
				} //end of if =>if (field[i].checked == true)
	  		} //END OF 檢查是否選取的資料有填入相對應的DATA
  		}	//end of if=>field.length==null  

  		var pass = "NO"; 
  		if (field.length==null)
  		{
     		if (field.checked==true) pass="YES";
  		} 
		else 
		{
	  		for (i = 0; i < field.length; i++) 
	  		{    
				if (field[i].checked == true)
				{
		  			pass="YES";
		  			break;
				}
	  		}
  		}
  
  		if (pass == "NO")
 	 	{
    		alert("You can not submit while you are not choosing any one!!");
    		return false;
  		}
  
 	 }  // End of if 最外層 if (document.MYFORM.ACTIONID.value=="002")
  	document.MYFORM.submit();   
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

function setSPQCheck(xORDERQTY,xSPQP)
{
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
}

function setSubmit(URL)
{
	warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value,document.MYFORM.SPQP.value,document.MYFORM.CUSTOMERID.value,document.MYFORM.CUSTACTIVE.value);   
	for (i=0;i<7;i++)
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
	   		if (warray[i]=="" || warray[i]==null)
	   		{   
        		alert("Please Input Request Date!!");   
	    		document.MYFORM.REQUESTDATE.focus();  
	    		return(false);	    
	   		} 
     	} // End of else if (warray[i]=="")
	 	else if (i==5)
     	{	
	   		if (warray[i]=="" || warray[i]==null)
	   		{ 	     
            	alert("Please Choose Customer Name!!");   
	          	document.MYFORM.CUSTOMERNAME.focus();  
	          	return(false);			  
	   		}	     
     	} // End of else if (warray[i]=="")  
	 	else if (i==6)
	 	{    //alert(warray[6]);
	    	if (warray[6]!="A") 
		  	{ 
		   		alert("                              Warning !!\n The Customer what you choose should be set ACTIVE in Oracle.");  
		  	}
	 	}
	} //end of for  null check
   
   	if (warray[4]!=null) // 若系統取得該次料項最小包裝量,則計算是否輸入訂購數量為最小包裝量之倍數
   	{
    	if (warray[4]==0) //若系統取得0, 表示尚未設定該料號最小包裝量, 不得詢問
	  	{
	       //alert("The Item SPQP not be defaule, Please contact with Item Administroatr!!"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
           //document.MYFORM.ITEMDESC.focus();  
	       //return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
      	} 
		else
	  	{
        	base=warray[4];
         	n=warray[2]/base;
	     	if ((""+n).indexOf(".")>-1) 
	     	{ 
	       		alert("The Order Q'ty which you input not acceptence by SPQP rule !!!\n                          SPQP= "+base+" KPC"); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
           		document.MYFORM.ORDERQTY.focus();  
	       		return(false); // 若要卡住輸入最小包裝量限制,則 Enable此javascript
	     	}
	  	} // end if
	  //else alert("n is integer");
   	}
   // 檢查Order Qty 欄位是否為數值  
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
   
  // 檢查日期是否符合日期格式 
   	var datetime;
   	var year,month,day;
   	var gone,gtwo;
   	if(warray[3]!="")
   	{
    	datetime=warray[3];
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
     //   if((gone=="-")&&(gtwo=="-"))
	 //	{
	 //alert(day);
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
    // }else // End of if((gone=="-")&&(gtwo=="-"))
    //    {
    //      alert("??入日期!格式?(yyyy-mm-dd) \n例(2001-01-01)");
    //      checktext.focus();
    //      return false;
    //    }
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
		else
		{ // End Else of if(datetime.length==10)
        	alert("Please Input Date Type as(yyyymmdd) \n For example:(20010101)!!");
          	document.MYFORM.REQUESTDATE.focus();
          	return(false);
        }
  	}
	else
	{ // End of if(Trim(checktext.value)!="")
         //return true;
    }
    
	var myDate = document.MYFORM.maxDate.value;
	if (document.MYFORM.REQUESTDATE.value <= myDate && document.MYFORM.REQUESTDATE.value!= "")
	{
		alert("The Request Date must greater than leadtime "+myDate);
		document.MYFORM.REQUESTDATE.focus();
		return (false);
	}

	if (document.MYFORM.showCRD.value =="Y")
	{
		if (document.MYFORM.CRD.value==null || document.MYFORM.CRD.value =="" || document.MYFORM.CRD.value.length != 8)
		{
			alert("please input a value on CRD field!");
			document.MYFORM.CRD.focus();
			return (false);
		}
		
		if (document.MYFORM.SHIPPINGMETHOD.value == null || document.MYFORM.SHIPPINGMETHOD.value =="")
		{
			alert("please input a value on shippingmethod field!");
			document.MYFORM.SHIPPINGMETHOD.focus();
			return (false);
		}
	}
	
  // 檢查日期是否符合日期格式
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}


function setSubmit2(SPQChk,URL,dim1,dim2,ms1)
{
 // Jingker 2006/03/04 Add here for Importing Check
 	var i_year = "",i_month= "",i_day ="";
	var chkflag = false;
	var RFQ_TYPE = "";
	if (SPQChk == 'Y')
 	{
		var radioLength = document.MYFORM.rfqtype.length;
		if(radioLength == undefined) 
		{
			return;
		}
		for(var i = 0; i < radioLength; i++) 
		{
			if ( document.MYFORM.rfqtype[i].checked)
			{
				RFQ_TYPE = document.MYFORM.rfqtype[i].value;
				chkflag=true;
				break;
			}
		}
		if (chkflag == false)
		{
			alert("Please choose the RFQ type!");
			return false;		
		}
			
		if  (document.MYFORM.ACTIONID.value =="--")
		{
			alert("Please choose the action type!!");
			document.MYFORM.ACTIONID.focus();   
			return(false);
		}
		
  		//20100824 檢查是否輸訂單類型_起
  		if (document.MYFORM.PREORDERTYPE.value=="--" || document.MYFORM.PREORDERTYPE.value=="" || document.MYFORM.PREORDERTYPE.value==null)
  		{
			alert("Please Select Order Type !!! ");
			document.MYFORM.PREORDERTYPE.focus();
			return (false);
  		}	
  		//20100824 檢查是否輸訂單類型_

   		// 確認送出前先提示使用者是否存為草稿     
 		if (document.MYFORM.ACTIONID.value=="002")  //表示為確認送出產生訂單動作
 		{ 
    		flag=confirm(ms1);      
    		if (flag==false) return(false);
			else
        	{ 	//alert("CCC");  // 若確認送出再檢查
		  		//return (true); 
		  		//alert("QQQ");
			}

   			if (dim1<1)  //若沒有任何資料則不能存檔
   			{
       			alert("No Need to Save because there is no any data being Added!!");   
       			return(false);
   			}
 		}  // 最外層 End of if (document.MYFORM.ACTIONID.value=="002")
		//alert("URL="+URL);
		
		//add by Peggy 20120403
		var num =1;
		var myDate = document.MYFORM.maxDate.value;
		if (document.MYFORM.ADDITEMS.length!= undefined)
		{
			num=document.MYFORM.ADDITEMS.length;
		}
		for (var i=0;i<num;i++)
		{	
			if (document.MYFORM.elements["MONTH"+i+"-7"].value <= myDate && document.MYFORM.elements["MONTH"+i+"-7"].value != "")
			{
				alert("The Request Date must greater than leadtime "+myDate);
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.btn1.disabled=true;
				document.MYFORM.elements["MONTH"+i+"-7"].focus();
				return (false);
			}
			else if (document.MYFORM.elements["MONTH"+i+"-7"].value.length!=8)
			{
				alert("Line"+(i+1)+":Date format error(invalid format:YYYYMMDD)!!");
				document.MYFORM.elements["MONTH"+i+"-7"].style.backgroundColor="#FFCCCC";  
				return false;		
			}			
			else 
			{
				i_year = document.MYFORM.elements["MONTH"+i+"-7"].value.substr(0,4);
				i_month= document.MYFORM.elements["MONTH"+i+"-7"].value.substr(4,2);
				i_day  = document.MYFORM.elements["MONTH"+i+"-7"].value.substr(6,2);	
				if (i_month <1 || i_month >12)
				{
					alert("Line"+(i+1)+":Month format error(invalid format:YYYYMMDD)!!");
					document.MYFORM.elements["MONTH"+i+"-7"].style.backgroundColor="#FFCCCC";  
					return false;			
				}	
				else if ((i_month ==1 || i_month==3 || i_month == 5 || i_month ==7 || i_month==8 || i_month==10 || i_month ==12) && i_day > 31)
				{
					alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
					document.MYFORM.elements["MONTH"+i+"-7"].style.backgroundColor="#FFCCCC";  
					return false;			
				} 
				else if ((i_month == 4 || i_month==6 || i_month == 9 || i_month ==11)	 && i_day > 30)
				{
					alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
					document.MYFORM.elements["MONTH"+i+"-7"].style.backgroundColor="#FFCCCC";  
					return false;			
				} 
				else if (i_month == 2)
				{
					if ((isLeapYear(i_year) && i_day > 29) || (!isLeapYear(i_year) && i_day > 28))
					{
						alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
						document.MYFORM.elements["MONTH"+i+"-7"].style.backgroundColor="#FFCCCC";  
						return false;	
					}		
				}
			}
		}		
		
 		document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE;
 		document.MYFORM.submit();
 	}
  	else 
 	{
		alert("MOQ Not Checked !");   
    	return(false);
 	} // End of if (SPQChk=="Y")
}

function setSubmit1(URL)
{ //alert(); 
  //alert(document.MYFORM.CHKFLAG.length);  
	document.MYFORM.action=URL;
  	document.MYFORM.submit();    
}

function setSubmit3(SPQChk,URL)
{
	var RFQ_TYPE = "";
	if (SPQChk == 'Y')
 	{
		//add by Peggy 20120403
		var num =1;
		var myDate = document.MYFORM.maxDate.value;
		if (document.MYFORM.ADDITEMS.length!= undefined)
		{
			num=document.MYFORM.ADDITEMS.length;
		}
		var radioLength = document.MYFORM.rfqtype.length;
		for(var i = 0; i < radioLength; i++) 
		{
			if ( document.MYFORM.rfqtype[i].checked)
			{
				RFQ_TYPE = document.MYFORM.rfqtype[i].value;
			}
		}		
		for (var i=0;i<num;i++)
		{	
			if (document.MYFORM.elements["MONTH"+i+"-7"].value <= myDate && document.MYFORM.elements["MONTH"+i+"-7"].value != "")
			{
				alert("The Request Date must greater than leadtime "+myDate);
				document.MYFORM.ACTIONID.value = "--"; //為了確保submit前,array物件上的值都有被get到,必須強逼重選ACTION
				document.MYFORM.btn1.disabled=true;
				document.MYFORM.elements["MONTH"+i+"-7"].focus();
				return (false);
			}
		}		
	}
	document.MYFORM.action=URL+"&RFQTYPE="+RFQ_TYPE;	
 	document.MYFORM.submit();
}

function subWindowItemFind(invItem,itemDesc)
{    
	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

// Jingker Add for Importing Check, 2006/03/04

function setSPQImportCheck()
{
    SQPWindow=window.open("../jsp/subwindow/TSCRFQImportSPQCheck.jsp","spqwin","width=740,height=480,scrollbars=yes,menubar=no"); 
}

function subWindowCustInfoFind(custNo,custName,salesArea)
{ 
   	if (event.keyCode==13)
   	{    
   		subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName+"&SAREANO="+salesArea,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
   	}	
}

function setCustInfoFind(custID,custName,salesArea)
{      
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERID="+custID+"&NAME="+custName+"&SAREANO="+salesArea,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function setSubmit4(URL,insertPage)
{  
	var InsertPage="?INSERT="+document.MYFORM.INSERT.value; 
   	warray=new Array(document.MYFORM.INVITEM.value,document.MYFORM.ITEMDESC.value,document.MYFORM.ORDERQTY.value,document.MYFORM.REQUESTDATE.value);   
   	for (i=0;i<4;i++)
   	{  
    	if (i<=1)  
     	{
	   		if ((warray[0]=="" || warray[0]==null || warray[0]=="--") && (warray[1]=="" || warray[1]==null || warray[1]=="--"))
	   		{ 
	    		alert("TSC Item or Item Description must input,please do not let them's data be Null !!");
	    		return(false); 
	   		}
	 	}	 
	 	else if (warray[i]=="" || warray[i]==null || warray[i]=="--" )
     	{	   
       		alert("Before you want to add , please do not let the any fields of  data be Null !!");     
	   		return(false);	     
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

 	document.MYFORM.action=URL+InsertPage;
 	document.MYFORM.submit();
}
//Enter Keycode = 13, Tab Keycode = 9
function setItemFindCheck(invItem,itemDesc)
{
	if (event.keyCode==13)
   	{ 
    	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 
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
function subWindowSSDFind()
{    
	var itemdesc = document.MYFORM.INVITEM.value;
	var crdate = document.MYFORM.CRD.value;
	var plant = "002";
	var odrtype = document.MYFORM.PREORDERTYPE.value;
	var region = document.MYFORM.SALESAREANO.value;
	var createdt = document.MYFORM.SYSDATE.value;

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
			|| (isLeapYear(year) && mon == 2 && day>29)
			|| (!isLeapYear(year) && mon == 2 && day>28))
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

	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function subWindowSSDFind()
{    
	var itemdesc = document.MYFORM.INVITEM.value;
	var crdate = document.MYFORM.CRD.value;
	var plant = "002";
	var odrtype = document.MYFORM.PREORDERTYPE.value;
	var region = document.MYFORM.SALESAREANO.value;
	var createdt = document.MYFORM.SYSDATE.value;

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
			|| (isLeapYear(year) && mon == 2 && day>29)
			|| (!isLeapYear(year) && mon == 2 && day>28))
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

	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
//add by Peggy 20120312
function subWindowShipMethodFind(primaryFlag)
{	    
	subWin=window.open("../jsp/subwindow/TSDRQShippingMethodFind.jsp?PRIMARYFLAG="+primaryFlag+"&sType=D1001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function setsubmitChg()
{
	if (document.MYFORM.ACTIONID.value !="--")
	{
		document.MYFORM.ACTIONID.value="--";
	}
}
</script>

<% 
String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 	
if (q!=null) 
{
}
// 20110217 Marvie Add : Add field  PROGRAM_NAME
String sProgramName=request.getParameter("PROGRAMNAME");
if (sProgramName==null || sProgramName.equals("")) sProgramName="";
session.setAttribute("PROGRAMNAME",sProgramName);

String docNo=request.getParameter("DOCNO"); 
String targetYear=""; 
String targetMonth=""; 
 
// Add by Jingker 2006/03/04, For Import Checking
String SPQChecked=request.getParameter("SPQCHECKED");
  
String customerId=request.getParameter("CUSTOMERID"); 
String customerNo=request.getParameter("CUSTOMERNO");
String customerName=request.getParameter("CUSTOMERNAME");
String custActive=request.getParameter("CUSTACTIVE");
String salesAreaNo=request.getParameter("SALESAREANO"); 
String salesPersonID=request.getParameter("SALESPERSONID"); 
String customerPO=request.getParameter("CUSTOMERPO"); 
String receptDate=request.getParameter("RECEPTDATE");
String curr=request.getParameter("CURR"); 
String remark=request.getParameter("REMARK"); 
String requireReason=request.getParameter("REQUIREREASON");
String preOrderType=request.getParameter("PREORDERTYPE");
String isModelSelected=request.getParameter("ISMODELSELECTED");  
String processArea=request.getParameter("PROCESSAREA");
String salesPerson=request.getParameter("SALESPERSON"); 
String toPersonID=request.getParameter("TOPERSONID"); 
String customerIdTmp=request.getParameter("CUSTOMERIDTMP");
String insertPage=request.getParameter("INSERT"); 
String preSeqNo=request.getParameter("PREDNDOCNO");
String repeatInput=request.getParameter("REPEATINPUT");
String custAROverdue=request.getParameter("CUSTOMERAROVERDUE");
//String fromPage = (String)session.getAttribute("FROMPAGE");
String actionID = request.getParameter("ACTIONID");
//String custINo=request.getParameter("CUSTINO"); // 客戶項次編號
  
int commitmentMonth=0;
arrayRFQDocumentInputBean.setCommitmentMonth(commitmentMonth);//設定承諾月數
String bringLast=request.getParameter("BRINGLAST"); //bringLast是用來識別是否帶出上一次輸入之最新版本資料
String comp=request.getParameter("COMP");
String [] addItems=request.getParameterValues("ADDITEMS");
String iNo=request.getParameter("INO"),invItem=request.getParameter("INVITEM"),itemDesc=request.getParameter("ITEMDESC"),orderQty=request.getParameter("ORDERQTY"),uom=request.getParameter("UOM"),requestDate=request.getParameter("REQUESTDATE"),lnRemark=request.getParameter("LNREMARK"),sPQP=request.getParameter("SPQP");
// 20110308 Marvie Add : line customer po
String endCustPO=request.getParameter("ENDCUSTPO");
String custrequestDate=request.getParameter("CRD"),shippingMethod=request.getParameter("SHIPPINGMETHOD");  //add by Peggychen 20110614
if (custrequestDate == null) custrequestDate = "";
if (shippingMethod == null) shippingMethod = "";
//String [] allMonth={iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark};
String [] allMonth={iNo,invItem,itemDesc,orderQty,uom, custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark};
String spqp=request.getParameter("SPQP");
String moqp=request.getParameter("MOQP");
String computeSSD="N";  
String LIMITDAYS=request.getParameter("LIMITDAYS");
if (LIMITDAYS == null)	
{
	LIMITDAYS ="6";
}else if (LIMITDAYS.equals("0"))
{
	LIMITDAYS ="-1";
}
dateBeans.setAdjDate(Integer.parseInt(LIMITDAYS));
String maxDate = dateBeans.getYearMonthDay();	

//if (custINo==null || custINo.equals("")) custINo = "1";
if (iNo==null || iNo.equals("")) iNo = "1"; 
if (receptDate==null || receptDate.equals("")) receptDate=dateBean.getYearMonthDay();
if (curr==null || curr.equals("")) curr="";
if (remark==null || remark.equals("")) remark="";
if (requireReason==null || requireReason.equals("")) requireReason="";
if (customerPO==null || customerPO.equals("")) customerPO="";
if (isModelSelected==null || isModelSelected.equals("")) isModelSelected="N"; // 預設未輸入任一筆明細
if (salesPerson==null || salesPerson.equals("")) salesPerson="";
if (customerId==null || customerId.equals("")) customerId="";
if (customerNo==null || customerNo.equals("")) customerNo="";
if (customerName==null || customerName.equals("")) customerName="";
if (custActive==null || custActive.equals("")) custActive="";
if (custAROverdue==null || custAROverdue.equals("")) custAROverdue="N";
// Add by Jingker 2006/03/04, For Import Checking
if (SPQChecked ==null || SPQChecked.equals("")) SPQChecked="N";
String rfqType = request.getParameter("RFQTYPE");    //add by Peggy 20120303
if (rfqType==null)
{ 
	rfqType="";
}
String rfqTypeNormal = "";
String rfqTypeForecast = "";
if (rfqType.equals("NORMAL"))
{ 
	rfqTypeNormal="checked";
}
else if (rfqType.equals("FORECAST"))
{
	rfqTypeForecast="checked";
}
String seqno=null;
String seqkey=null;
String dateString=null;
  
if (insertPage==null) // 若輸入模式離開此頁面,則BeanArray內容清空
{     
	arrayRFQDocumentInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
}
  
if (salesAreaNo ==null) //add by Peggychen 20110728
{  
	salesAreaNo =userActCenterNo;
} 
if (salesAreaNo !=null) //add by Peggychen 20110728
{  
	// 否則,以選擇的業務地區找其Parent Organization作為 ORG_ID_起
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery("select SSD_FLAG from ORADDMAN.TSSALES_AREA where SALES_AREA_NO='"+salesAreaNo+"'");  
	if (rs.next())
	{
		computeSSD=rs.getString("SSD_FLAG");  
	}
	rs.close();
	statement.close();
}

//add by Peggy 20160113
if (customerName.equals(""))
{
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery("select customer_name from ar_customers where customer_Id='"+customerId+"'");  
	if (rs.next())
	{
		customerName=rs.getString("customer_name");  
	}
	rs.close();
	statement.close();
}

try 
{   
 
	String at[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容     
  	//*************依Detail資料user可能再修改內容,故必須將其內容重寫入陣列內  
   	if (at!=null) 
   	{      
    	for (int ac=0;ac<at.length;ac++)
	  	{      
        	for (int subac=1;subac<at[ac].length;subac++)
	      	{
				if (request.getParameter("MONTH"+ac+"-"+subac)!=null && request.getParameter("MONTH"+ac+"-"+subac).trim()!="")
		      	{
			   		at[ac][subac]=request.getParameter("MONTH"+ac+"-"+subac); //取上一頁之輸入欄位		
			  	} 	
		   	}  //end for array second layer count
	  	} //end for array first layer count
   	 	arrayRFQDocumentInputBean.setArray2DString(at);  //reset Array
   	}   //end if of array !=null
   //********************************************************************
 
  	if (addItems!=null) //若有選取則表示要刪除
  	{ 
    	String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//重新取得陣列內容  
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
							// 20110307 Marvie Update : fix bug
							for (int gg=0;gg<a[m].length;gg++)
							{                          // 目前共7個{ iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark }      
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
						} // End of if (a[m][1]!=null && a[m][1].trim() != "") // 除去那些Excel cell為null的_迄 		     
					}  
				} //end of if a.length		
				arrayRFQDocumentInputBean.setArray2DString(t);	  
			} 
			else 
			{ 	
				if (a.length==addItems.length)
				{  
					arrayRFQDocumentInputBean.setArray2DString(null); //若陣列內容不為空,且陣列的Entity=addItems.length,則將陣列內容清空 
				} // End of if (a.length==addItems.length)
			}  
		}//end of if a!=null
	} //end of if (addsItem!=null)
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}   
  
// 若單號未取得,則呼叫取號程序
try
{ 
	if (docNo==null || docNo.equals(""))
  	{  
   		dateString=dateBean.getYearMonthDay();   
   
   		if (salesAreaNo==null || salesAreaNo.equals("--")) seqkey="TS"+userActCenterNo+dateString; //但仍以預設為使用者地區
   		else seqkey="TS"+salesAreaNo+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號   
   		//====先取得流水號=====  
   		Statement statement=con.createStatement();
   		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
  	 	if (rs.next()==false)
   		{   
    		String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";   
    		PreparedStatement seqstmt=con.prepareStatement(seqSql);     
    		seqstmt.setString(1,seqkey);
    		seqstmt.setInt(2,1);   
	
    		seqstmt.executeUpdate();
    		seqno=seqkey+"-001";
    		seqstmt.close();   
   		} 
   		else 
   		{
    		int lastno=rs.getInt("LASTNO");
      
    		String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
			Statement statement2=con.createStatement();
    		ResultSet rs2=statement2.executeQuery(sql); 
    		//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
    		if (rs2.next())
    		{         
      			lastno++;
     	 		String numberString = Integer.toString(lastno);
      			String lastSeqNumber="000"+numberString;
      			lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
      			seqno=seqkey+"-"+lastSeqNumber;     
   
      			String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
      			PreparedStatement seqstmt=con.prepareStatement(seqSql);        
      			seqstmt.setInt(1,lastno);   
	
      			seqstmt.executeUpdate();   
      			seqstmt.close(); 
    		} 
    		else
    		{
      			//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
      			String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
				Statement statement3=con.createStatement();
      			ResultSet rs3=statement3.executeQuery(sSql);
	 
	  			if (rs3.next()==true)
	  			{
       				int lastno_r=rs3.getInt("LASTNO");
	   				lastno_r++;
	  
	   				String numberString_r = Integer.toString(lastno_r);
       				String lastSeqNumber_r="000"+numberString_r;
       				lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
       				seqno=seqkey+"-"+lastSeqNumber_r;  
	 
	   				String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
       				PreparedStatement seqstmt=con.prepareStatement(seqSql);        
       				seqstmt.setInt(1,lastno_r);   
	
       				seqstmt.executeUpdate();   
       				seqstmt.close();  
	  			}  // End of if (rs3.next()==true)
				rs3.close();
				statement3.close();
     		} // End of Else  //===========(處理跳號問題)
			rs2.close();
			statement2.close();
    	} // End of Else    
		rs.close();
		statement.close();
		docNo = seqno; // 把取到的號碼給本次輸入
  	} // End of if (docNo==null || docNo.equals(""))	
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
// 取客戶ID對應的業務員
try
{
	if (customerId !=null && customerId !=customerIdTmp)// 若輸入過程變更客戶,則找新的負責的業務員資料及客戶對應的預設幣別
	{
		// 先由客戶ID取客戶的Site Use ID 
	    Statement statement=con.createStatement();
        //String sSql = "select b.PRIMARY_SALESREP_ID, c.RESOURCE_NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,JTF_RS_DEFRESOURCES_VL c "+
		//              "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and to_char(a.CUST_ACCOUNT_ID) ='"+customerId+"' "+
		//			  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID and a.SHIP_TO_FLAG='P' "+
		//			  "and c.RESOURCE_ID = b.PRIMARY_SALESREP_ID";
		String sSql = " select distinct b.PRIMARY_SALESREP_ID, c.LOV_MEANING RESOURCE_NAME "+
               		  " from APPS.HZ_CUST_ACCT_SITES_ALL a"+
					  ",AR.HZ_CUST_SITE_USES_ALL b"+
					  ",tsc_crm_lov_v c "+
					  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					  " and a.CUST_ACCOUNT_ID ="+customerId+""+
					  " and a.STATUS = 'A'"+
					  " and a.ORG_ID = b.ORG_ID"+ 
					  " and a.ORG_ID =41"+
					  " and a.SHIP_TO_FLAG='P' "+
					  " and c.LOV_CODE = to_char(b.PRIMARY_SALESREP_ID)"+ 
					  " and b.STATUS = 'A'";		
        ResultSet rsSalsPs=statement.executeQuery(sSql);	 
	    if (rsSalsPs.next()==true)
		{  
			salesPerson = rsSalsPs.getString("RESOURCE_NAME");
		 	toPersonID = rsSalsPs.getString("PRIMARY_SALESREP_ID");	
		}
		rsSalsPs.close();		
		
		//
		customerIdTmp = customerId;  // 把這次的客戶代號記入客戶代號暫存變數,作為下次判斷是否重取業務員之用
		
		// 取此客戶對應的 預設Profile Amount內的幣別檔
		sSql = "select CURRENCY_CODE from AR_CUSTOMER_PROFILE_AMOUNTS where to_char(customer_ID) ='"+customerId+"' ";
		ResultSet rsSCurr=statement.executeQuery(sSql);	
		if (rsSCurr.next())
		{
			if (curr==null || curr.equals(""))
		  	{ 
		   		curr=rsSCurr.getString("CURRENCY_CODE");
		  	}
		}
		rsSCurr.close();
		statement.close();
	} // End of if
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>

<html>
<head>
<title>Sales Delivery Request Questionnaire Input Form</title>
<Style type="text/css">
.gogo{
    border:0;
	color:#FF0000;
}
</Style>
</head>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>   
<FORM ACTION="TSSalesDRQCreateImport.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font  color="#000099" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/></strong></font>
&nbsp;&nbsp;&nbsp;<img src="../image/point.gif"><font color="#FF6600" size="2"><jsp:getProperty name="rPH" property="pgNoBlankMsg"/></font>
<%
if (preSeqNo==null || preSeqNo.equals(""))
{
}
else if (preSeqNo !=null && !preSeqNo.equals(""))	
{ 
		  %>  <font color="#330099"  size="2"><a href="TSSalesDRQDisplayPage.jsp?DNDOCNO=<%=preSeqNo%>" id="myLINK"><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgQDocNo"/></a></font><%out.println(":<font color='#FF0000' size='2'><strong>"+preSeqNo+"</strong></font>"); %>
  <% 			   
}
  %>
  <input type="hidden" size="1" name="CUSTOMERAROVERDUE" style="border:0 solid #CC0066" value=<%=custAROverdue%>>&nbsp;&nbsp;&nbsp;
  <font color="#FF0000" size="2"><input type="text" size="30" name="AROVERDUEDESC" class="gogo" readonly></font>
<%		
if (custAROverdue=="Y" || custAROverdue.equals("Y") ) 
{ 
	out.println("&nbsp;&nbsp;&nbsp;<font color='#FF0000' size='2'>");
    out.println("Customer AR Overdue 90 days !!");
    out.println("</font>");
} 		 
else 
{ 
	out.println(" "); 
}
%>
<table cellSpacing="0" bordercolordark="#66CC99"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
    <tr bgcolor="#CCFFCC">      
      <td width="19%"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><strong><jsp:getProperty name="rPH" property="pgQDocNo"/></strong></font><font face="Arial" size="2" color="#003366"><span class="style1">&nbsp;</span><strong><%=docNo%></strong></font></td>      	 
	</tr>
 </table>
 <table cellSpacing="0" bordercolordark="#66CC99" cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1"> 
    <tr bgcolor="#CCFFCC">
	  <td width="15%" ><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSalesArea"/></font><img src="../image/point.gif"></td> 
      <td width="21%"> 
<%		 
try
{   
	Statement statement=con.createStatement();
    ResultSet rs=null;	
	String sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA ";
	String sWhere = "where SALES_AREA_NO > 0 ";
	if (UserRoles=="admin" || UserRoles.equals("admin")) 
	{ 
	}  // 若為管理員,可開立任何一區詢問單
	else 
	{  
		//sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' ";
		if (UserRegionSet==null || UserRegionSet.equals(""))
		{
			sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' "; // 若是空的地區集,則以主要的業務區
		} 
		else 
		{
			sWhere = sWhere + "and SALES_AREA_NO in ("+UserRegionSet+") ";
		}
		
	}  // 否則,就只能開立所屬區域單
	sql = sql + sWhere;
	//out.println(sql);
    rs=statement.executeQuery(sql);	

	out.println("<select NAME='SALESAREANO' tabindex='1' onChange='setSubmit1("+'"'+"../jsp/TSSalesDRQCreateImport.jsp?INSERT=Y&SPQCHECKED=Y"+'"'+")'>");				  				  
    out.println("<OPTION VALUE=-->--");                              
	while (rs.next())
	{            
		String s1=(String)rs.getString(1); 
		String s2=(String)rs.getString(2); 
        if (s1.equals(salesAreaNo)) 
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
	out.println("Exception:"+e.getMessage());
}		   
%>
	 </td>
	 <td width="16%"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCreateFormDate"/></font></td>		   
		   <td width="18%" bgColor="#ffffff">
		       <input name="RECEPTDATE" tabindex="2" type="text" size="8" value="<%=receptDate%>" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RECEPTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> 
		   </td>  
	 <td width="14%"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCreateFormUser"/></font></td>
	 <td width="16%" bgColor="#ffffff">
      <font size="2"><%out.println(userID+"("+UserName+")"); salesPersonID = userID; %></font>
	 </td>
    </tr>	
	<tr bgcolor="#CCFFCC">
	    <td width="15%" height="22"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgPreOrderType"/></font></td>
           <td width="21%" bgColor="#ffffff"><font face="Arial">
<%
try
{   
	Statement statement=con.createStatement();
    ResultSet rs=null;	
	String sqlOrgInf = "select DISTINCT OTYPE_ID, ORDER_NUM||'('||DESCRIPTION||')' as TRANSACTION_TYPE_CODE "+
	                   "from ORADDMAN.TSAREA_ORDERCLS ";
	String whereOType = "where  ACTIVE ='Y'  ";								  
								      
	if (UserRoles=="admin" || UserRoles.equals("admin")) 
	{ 
	}  // 若為管理員,可開立任何一訂單類型詢問單
	else 
	{  
		if (UserRegionSet==null || UserRegionSet.equals(""))
		{  // 未取到業務地區集,則以主要的業務區
			whereOType = whereOType + "and SAREA_NO = '"+userActCenterNo+"' and PAR_ORG_ID = '"+userParOrgID+"' order by 2 ";
		} 
		else 
		{
		    whereOType = whereOType + "and SAREA_NO in ("+UserRegionSet+") and PAR_ORG_ID = '"+userParOrgID+"' order by 2 ";
		} 
		
	}  // 否則,就只能開立所屬區域單
	//UserParOrgID
	sqlOrgInf = sqlOrgInf + whereOType;
    rs=statement.executeQuery(sqlOrgInf);
	comboBoxBean.setRs(rs);
	comboBoxBean.setSelection(preOrderType);
	comboBoxBean.setFieldName("PREORDERTYPE");	   
    out.println(comboBoxBean.getRsString());
				   	  		  
	rs.close();   
	statement.close();     	 
} //end of try		 
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
%>
			 </font>
		 </td>
		 <td width="16%"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustPONo"/></font></td> 
		 <td colspan="1"><input size="20" name="CUSTOMERPO" tabindex='4' value="<%=customerPO%>"></td> 
		 <td width="14%"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCurr"/></font></td> 
		 <td colspan="1"><input size="20" name="CURR" tabindex='5' value="<%=curr%>"></td> 
	</tr>   
	<tr bgcolor="#CCFFCC">
	   <td width="15%" height="22"><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgCustomerName"/></font><img src="../image/point.gif"></td>
       <td bgColor="#ffffff" colspan="3"><font face="Arial">		       
              <input type="text" size="10" name="CUSTOMERNO" tabindex='6' onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.SALESAREANO.value)' value="<%=customerNo%>">	        
              <input name="button3" type="button" tabindex='7' onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.SALESAREANO.value)' value="...">		
        <input type="text" size="50" name="CUSTOMERNAME" tabindex='8' onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.SALESAREANO.value)' value="<%=customerName%>"> </font></td>
	 <td nowrap><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgSalesMan"/></font></td>
	 <td width="16%" bgColor="#ffffff"><font size="2"><%if (salesPerson=="") out.println("&nbsp;"); else out.println(salesPerson); %></font></td>
    </tr>	
	 <tr bgcolor="#CCFFCC">
	   <td nowrap><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRequireReason"/></font>
	   </td>
	   <td bgColor="#ffffff"><font face="Arial"><input name="REQUIREREASON" tabindex='9' type="text" size="40" value="<%=requireReason%>" maxlength="60"></font></td>
		<td><font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRFQType"/></font>
		</td>
		<td><font face="Arial" size="2" color="#3366FF">
		   <input type="radio" name="rfqtype" value="NORMAL" <%=rfqTypeNormal%>>NORMAL
		   &nbsp;&nbsp;&nbsp;&nbsp;
		   <input type="radio" name="rfqtype" value="FORECAST" <%=rfqTypeForecast%>>FORECAST</font>
	   	</td>	   	   
	   <td>
           <font face="Arial" size="2" color="#3366FF"><span class="style1">&nbsp;</span><jsp:getProperty name="rPH" property="pgRemark"/></font>
		 </td>
		 <TD>
	       <input name="REMARK" tabindex='10' type="text" size="25" value="<%=remark%>" maxlength="80">	
	   </td>	   	   
	 </tr> 
 </table>
 <table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
  <tr bgcolor="#CCFFCC">  
      <!--td width="3%"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td-->   
      <td width="20%"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></font><img src="../image/point.gif"></div></td>
	  <td width="20%"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/></font><img src="../image/point.gif"></div></td>
	  <td width="16%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgQty"/><img src="../image/point.gif"><jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000" size="2"><jsp:getProperty name="rPH" property="pgKPC"/></font></div></td> 
		<%
		if (computeSSD.equals("Y")) //顯示CRD,SHIPPINGMETHOD
		{
		%>
			<td width="10%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgCRDate"/>
			</font></div>
			</td>	
		<%
		}
		if (computeSSD.equals("Y") || computeSSD.equals("S"))
		{
		%>
			<td width="10%" colspan="1">
			<div align="center"><font face="Arial" size="2" color="#3366FF">
			<jsp:getProperty name="rPH" property="pgShippingMethod"/>
			</font></div>
			</td>				   
		<%
		}
		%>		
	  
      <td width="10%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgDeliveryDate"/></font><img src="../image/point.gif"></div></td>
	  <td width="16%" colspan="1" nowrap><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgEndCustPO"/></font><img src="../image/point.gif"></div></td> 	 	  	  
	  <td width="15%" colspan="1"><div align="center"><font face="Arial" size="2" color="#3366FF"><jsp:getProperty name="rPH" property="pgRemark"/></font></div></td> 	 	  	  
      <!--%<td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button"  value="Add" onClick='setSubmit("../jsp/TSSalesDRQCreateImport.jsp")'></div></td> %-->
	  <td width="4%" rowspan="2"><div align="center"><INPUT TYPE="button" tabindex="18" value='<jsp:getProperty name="rPH" property="pgAdd"/>' onClick='setSubmit("../jsp/TSSalesDRQCreateImport.jsp?INSERT=Y")'></div></td>
    </tr>
  <tr>
    <td width="20%" nowrap> <div align="center"> 
	<input name="INO" type="hidden" size="2" <%if (iNo==null) out.println("value=1"); else out.println("value="+iNo);%>>  
    <input type="text" name="INVITEM" tabindex="11" size="27" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' maxlength="30" <%if (allMonth[1]!=null) out.println("value="); else out.println("value=");%>>	
    <INPUT TYPE="button" tabindex="12" value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'>   
	</div></td>
	<td width="20%" nowrap>    
    <input type="text" name="ITEMDESC" tabindex="13" size="25" onKeyDown='setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value)' maxlength="60" <%if (allMonth[2]!=null) out.println("value="); else out.println("value=");%>>
	<INPUT TYPE="button" tabindex="14"  value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'>
    </td>
    <td width="16%"><div align="center">
      <input type="text" name="ORDERQTY" tabindex="15" size="10" onKeyDown='setSPQCheck(this.form.ORDERQTY.value,this.form.SPQP.value)' maxlength="60"  <%if (allMonth[3]!=null) out.println("value="); else out.println("value=");%> >
      <%
	    out.println("<font color='#FF0000' size='2'>");
	    out.println("MOQ: ");
		%>
      <input type="text" name="SPQP" size="3" align="right"  class="gogo" readonly <%if (sPQP!=null) out.println("value="); else out.println("value=");%>>      
      <%
	    out.println(" K");
	    out.println("</font>");
		%>
    </div></td>	
		<% 
		if (computeSSD.equals("Y")) //顯示CRD,SHIPPINGMETHOD
		{
		%>
		<td width="10%" bgColor="#ffffff" nowrap>
       		<input name="CRD" tabindex="16" type="text" size="8" maxlength="8" onKeyPress="if(window.event.keyCode<48 || window.event.keyCode>57) window.event.keyCode = 0;" <%if (allMonth[5]!=null) out.println("value="); else out.println("value=");%>>	   
      		<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.CRD);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> 
		</td>
		<td width="10%" nowrap>    
    		<input type="text" name="SHIPPINGMETHOD" tabindex="13" size="15" maxlength="20" <%if (allMonth[6]!=null) out.println("value="); else out.println("value=");%>>
			<INPUT TYPE="button" tabindex="14"  value="..." onClick='subWindowSSDFind()'>
    	</td>		
		<%
		}
		else if (computeSSD.equals("S")) //顯SHIPPINGMETHOD,modify by Peggy 20120209
		{
		%>
		<td width="10%" nowrap>    
    		<input type="text" name="SHIPPINGMETHOD" tabindex="13" size="10" maxlength="20"  <%if (allMonth[6]!=null) out.println("value="); else out.println("value=");%>>
            <INPUT TYPE="button" tabindex='18' value="..." onClick='subWindowShipMethodFind(this.form.SHIPPINGMETHOD.value)'>
		</td>
		<%
		}
		%>
	<td width="10%" bgColor="#ffffff">
	   <input name="UOM" type="hidden" size="8" <%if (allMonth[4]!=null) out.println("value="); else out.println("value=");%>>
       <input name="REQUESTDATE" tabindex="16" type="text" size="8" <%if (allMonth[7]!=null) out.println("value="); else out.println("value=");%>>	   
       <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.REQUESTDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A> </td>
	<td nowrap><div align="center">
	     <input type="text" name="ENDCUSTPO" tabindex="17" size="20" maxlength="60"   <%if (allMonth[8]!=null) out.println("value="); else out.println("value=");%>>
		 </div>
    </td>    
	<td nowrap><div align="center">
	     <input type="text" name="LNREMARK" tabindex="18" size="20" maxlength="60"   <%if (allMonth[9]!=null) out.println("value="); else out.println("value=");%>>
		 </div>
    </td>
    </tr>
  <tr bgcolor="#CCFFCC">
    <td colspan="9"><div align="center"><strong>
<%
try
{
	// 20110222 Marvie Update : Add Field  SPQ MOQ
    //String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
    //String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","End-Customer PO","Remark"};
	String oneDArray[] ={"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust PO Line","Quote#","End Cust ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to"}; //add by Peggy 20160401
    arrayRFQDocumentInputBean.setArrayString(oneDArray);
	String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 \
	//out.println("a.length="+a.length);	    
	int i=0,j=0,k=0;
    String dupFLAG="FALSE";
	if (( (invItem!=null && !invItem.equals("")) || (itemDesc!=null && !itemDesc.equals("")) ) && orderQty!=null && !orderQty.equals("") && bringLast==null) //bringLast是用來識別是否帶出上一次輸入之最新版本資料
	{  //out.println("step1"); 
		String sqlUOM = ""; 
		if (invItem!=null && !invItem.equals("")) // 若輸入料號,抓說明及單位
		{ 
			sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and SEGMENT1 = '"+invItem+"'  AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y' AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y' AND inventory_item_status_code<>'Inactive'";  
		}       
		else 
		{ // 否則若輸入料號說明,抓料號及單位
			sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+itemDesc+"' AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y' AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y' AND inventory_item_status_code<>'Inactive' ";     
		} 					
		// 依使用者輸入的料號ID取其單位
		Statement stateUOM=con.createStatement();			  
        ResultSet rsUOM=stateUOM.executeQuery(sqlUOM); 
        //===(
        if (rsUOM.next())
        {
			uom =  rsUOM.getString("PRIMARY_UOM_CODE");   
			invItem = rsUOM.getString("SEGMENT1"); 
			itemDesc = rsUOM.getString("DESCRIPTION"); 
		} 
		else 
		{ 
%>
			<script LANGUAGE="JavaScript">                        
				subWindowItemFind("<%=invItem%>","<%=itemDesc%>");                        
            </script> 
<%
		 	// 若找不到,則呼叫料號尋找視窗,並將料號及料號說明給沒填入的欄位
			if (itemDesc==null || itemDesc.equals("")) itemDesc = invItem;
			else if (invItem==null || invItem.equals("")) invItem = itemDesc;
			uom = "KPC";
		}
		rsUOM.close();
		stateUOM.close();
		     // 依使用者輸入的料號ID取其單位 			    
		if (a!=null) 
		{ 
			String b[][]=new String[a.length+1][a[i].length];	
			for (i=0;i<a.length;i++)			   
			{ 
				if (a[i][1]!=null && a[i][1].trim()!="")	// 除去那些為null的 Excel表cell    			 
				{
					for (j=0;j<a[i].length;j++)
					{
						b[i][j]=a[i][j];				    
					} 
					k++;			
				}    
			}
			iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
			//out.println(iNo);
			b[k][0]=iNo;
			b[k][1]=invItem;
			b[k][2]=itemDesc;
			b[k][3]=orderQty;
			b[k][4]=uom;
			b[k][5]=(custrequestDate=="")?"":custrequestDate; //add by Peggychen 20110622
			b[k][6]=(shippingMethod=="")?"":shippingMethod; //add by Peggychen 20110622
			b[k][7]=requestDate;
			b[k][8]=endCustPO;
			b[k][9]=lnRemark;
			b[k][10]="N";
			b[k][11]=spqp;   // SPQ
			b[k][12]=moqp;   // MOQ
			b[k][13]="";
			b[k][14]="";     //客戶料號 add by Peggy 20120301
			b[k][15]="";     //單價 add by Peggy 20120301
			b[k][16]=null;   //訂單類型 add by Peggy 20120301
			b[k][17]=null;   //line type add by peggy 20120301
			b[k][18]=null;   //add by Peggy 20120330
			b[k][19]=null;   //add by Peggy 20120601
			b[k][20]=null;   //add by Peggy 20120917
			b[k][21]=null;   //add by Peggy 20121107
			b[k][22]=null;   //add by Peggy 20130305
			b[k][23]=null;   //add by Peggy 20130305
			b[k][24]=null;   //add by Peggy 20140825
			b[k][25]=null;   //add by Peggy 20150616
			b[k][26]=null;   //add by Peggy 20160401
			b[k][27]=null;   //add by Peggy 20170222
			b[k][28]=null;   //add by Peggy 20170512
			arrayRFQDocumentInputBean.setArray2DString(b);
		} 
		else 
		{	//out.println("step5: 若為第一筆資料,則填入抬頭");	            
			//String c[][]={{iNo,invItem,itemDesc,orderQty,uom,requestDate,endCustPO,lnRemark,"N",moqp,spqp}};
			String c[][]={{iNo,invItem,itemDesc,orderQty,uom,custrequestDate,shippingMethod,requestDate,endCustPO,lnRemark,"N",spqp,moqp,"","","","","","","","","","","","","",""}};
			arrayRFQDocumentInputBean.setArray2DString(c);
		} // End of else                  	                       		        		  
	} 
	else 
	{ 
		if (a!=null) 
		{ 
			arrayRFQDocumentInputBean.setArray2DString(a);     			       	                
		} 
	}

	 //###################針對目前陣列內容進行檢查機制#############################		  
	 // 20110303 Marvie Delelte
	 String T2[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容做為暫存用;	  			  	
	 //String tp[]=arrayRFQDocumentInputBean.getArrayContent();
	 if (T2!=null) 
	 {  		   
	 	//-------------------------取得轉存用陣列-------------------- 
	    String temp[][]=new String[T2.length][T2[0].length];		    
		for (int ti=0;ti<T2.length;ti++)
		{
			for (int tj=0;tj<T2[ti].length;tj++) 
			{		
				//out.println("T2["+ti+"]["+tj+"]="+T2[ti][tj]);		 
				if (tj==0)
				{
					temp[ti][tj]=T2[ti][tj];
				}
				else if (tj==1 || tj==2 || (tj>=10 && tj<=24)) 
				{
					temp[ti][tj] = "D";
				}
				else if (tj>=3 && tj<=9)
				{
					if ((computeSSD.equals("Y") && (tj ==5 || tj==6)) || (computeSSD.equals("S") && tj==6) || (tj!=4 && tj!=5 && tj!=6)) 
					{					
						temp[ti][tj]="U";
					}
					else
					{
						temp[ti][tj]="D";
					}
				}
				else
				{
					temp[ti][tj] = "P";
				}
			}
		}
	    arrayRFQDocumentInputBean.setArray2DCheck(temp);  //置入檢查陣列以為控制之用			   
	} 
	else 
	{    		      		     
		arrayRFQDocumentInputBean.setArray2DCheck(null);
	}	//end if of T2!=null	   
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
try
{
	String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容  	   			    		                       		    
	float total=0;
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());		  
}
%>
</strong></div>
	</td>        
    </tr>
  </table>
  <HR>
  <table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
<tr bgcolor="#CCFFCC">
  <td>
     <input name="button" tabindex='19' type=button onClick="this.value=check(this.form.ADDITEMS)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
     <font color="#336699" size="2">-----DETAIL you choosed to be saved----------------------------------------------------------------------------------------------------</font>
  </td>
</tr>
<tr bgcolor="#CCFFCC">
  <td>  
<% 
int div1=0,div2=0;      //做為運算共有多少個row和column輸入欄位的變數
try
{	
	String a[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 		    		                       		    		  	   
    if (a!=null) 
	{		
		div1=a.length;
		div2=a[0].length;
		//out.println("div2="+div2);
	    arrayRFQDocumentInputBean.setFieldName("ADDITEMS");			
		arrayRFQDocumentInputBean.setEventName(" onChange=setsubmitChg();");
		out.println(arrayRFQDocumentInputBean.getArray2DTempString()); //onChange要用這個,add by Peggy 20150908
		//out.println(arrayRFQDocumentInputBean.getArray2DBufferString());  // 用Item 及Item Description 作為Key 的Method
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
	    <td>
		  <INPUT name="button2" tabindex='20' TYPE="button" onClick='setSubmit3("<%=SPQChecked%>","../jsp/TSSalesDRQCreateImport.jsp?INSERT=Y")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' >
          <% 
		    if (isModelSelected =="Y" || isModelSelected.equals("Y")) out.println("<font color='#336699' size='2'>-----");
		  %>
		  <jsp:getProperty name="rPH" property="pgLCheckDelete"/>--------------------------------------------
</td>
	  </tr>
 </table>
<HR>
<table cellSpacing="0" bordercolordark="#66CC99"cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border="1">
<tr bgcolor="#CCFFCC">
 <td>
  <strong><font color="#3366FF" face="Arial" size="2" ><jsp:getProperty name="rPH" property="pgProcessUser"/></font></strong> 
 </td>
 <td width="18%" bgcolor="#FFFFFF"> 
    <font color='#000099' face="Arial" size="2" ><strong><%=userID+"("+UserName+")"%></strong></font>	 
 </td>
 <td width="16%" bgcolor="#CCFFCC">
  <strong><font color="#3366FF" face="Arial" size="2" ><jsp:getProperty name="rPH" property="pgProcessDate"/></font></strong> 
 </td>
 <td width="15%" bgcolor="#FFFFFF"> 
   <font color="#000099" face="Arial" size="2" ><strong><%=dateBean.getYearMonthDay()%></strong></font>	 
 </td> 
 <td width="16%" bgcolor="#CCFFCC">
  <strong><font color="#3366FF" face="Arial" size="2" ><jsp:getProperty name="rPH" property="pgProcessTime"/></font></strong> 
 </td>
 <td width="19%" bgcolor="#FFFFFF"> 
    <font color='#000099' face="Arial" size="2" ><strong><%=dateBean.getHourMinuteSecond()%></strong></font>	 
 </td>  
</tr>
<tr>
 <td width="16%" bgcolor="#CCFFCC">
  <strong><font color="#3366FF" face="Arial" size="2"><jsp:getProperty name="rPH" property="pgAction"/></font></strong> 
 </td>
 <td colspan="1"> 
<%
if (SPQChecked.equals("Y"))
{
	try
    {       
    	Statement statement=con.createStatement();
       	ResultSet rs=statement.executeQuery("select x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 WHERE FORMID='TS'AND TYPENO='001' AND FROMSTATUSID='001' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'");
	   	out.println("<select NAME='ACTIONID' onChange='setSubmit3("+'"'+SPQChecked+'"'+","+'"'+"../	jsp/TSSalesDRQCreateImport.jsp?INSERT=Y&SPQCHECKED=Y&PREORDERTYPE="+preOrderType+'"'+")'>");					  				  
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
       	rs.close();       
	   	statement.close();
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
} 
else
{
	out.println("<INPUT TYPE='button' value='MOQ Check' onClick='setSPQImportCheck();'>");
}
    
       %>
	   &nbsp;&nbsp;&nbsp;&nbsp;
   </td>   
   <td bgcolor="#CCFFCC">
     <strong><font color="#3366FF" face="Arial" size="2"><jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgDeptArea"/></font></strong> 
   </td>
   <td width="15%" bgcolor="#FFFFFF" colspan="3"> 
    <font color='#000099' face="Arial" size="2"><strong>
<%
try
{   
	if (processArea==null || processArea.equals(""))
	{
		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA WHERE SALES_AREA_NO='"+userActCenterNo+"' ";				   
        rs=statement.executeQuery(sql);		           
		if (rs.next())   
        { 
			processArea=rs.getString(2);
			out.println(processArea);
		}
		rs.close();   
		statement.close(); 
	}
	else 
	{	
		out.println(processArea);   
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}	
%>
</strong></font>	 
   </td>
 </tr>
</table>
<script LANGUAGE="JavaScript"> 
</script> 
<BR>

<!-- Jingker 2006/03/04 Change Here, Add SPQChecked flag on setSubmit2 below-->

<INPUT TYPE="button" tabindex='25' name="btn1" value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit2("<%=SPQChecked%>","../jsp/TSSalesDRQ_MInsert.jsp?REPEATINPUT=N&PROGRAMNAME=<%=sProgramName%>P",<%=div1%>,<%=div2%>,"<jsp:getProperty name="rPH" property="pgAlertCreateDRQ"/>")' <%=((actionID== null || actionID.equals("") || actionID.equals("--"))?" disabled":"")%> >
&nbsp;<font color="#CC0066" size="2"><strong><input name="REPEATINPUT" type="checkbox" <% if (repeatInput==null || repeatInput.equals("")) { out.println("checked");  } else if (repeatInput=="on" || repeatInput.equals("on")){ out.println("checked"); } else {} %>><jsp:getProperty name="rPH" property="pgRepeatRepInput"/></strong></font>

<!-- 表單參數 -->  
    <input name="FORMID" type="HIDDEN" value="TS">	
    <input name="FROMSTATUSID" type="HIDDEN" value="001">
	<input name="ISMODELSELECTED" type="HIDDEN" value="<%=isModelSelected%>" size=2>  <!--做為判斷是否已選取新增機型明細-->
	<input name="FROMPAGE" type="HIDDEN" value="TSSalesDRQ_Create.jsp">  	
	<input name="SALESPERSONID" type="HIDDEN" value="<%=salesPersonID%>">
	<input name="PROCESSAREA" type="HIDDEN" value="<%=processArea%>">
	<input name="SALESPERSON" type="HIDDEN" value="<%=salesPerson%>">
	<input name="TOPERSONID" type="HIDDEN" value="<%=toPersonID%>">
	<input name="CUSTOMERIDTMP" type="HIDDEN" value="<%=customerIdTmp%>">
	<input name="INSERT" type="HIDDEN" value="<%=insertPage%>">
	<input type="hidden" size="10" name="CUSTOMERID" value="<%=customerId%>">
	<input type="hidden" size="10" name="CUSTACTIVE" value="<%=custActive%>">	
	<input type="hidden" size="10" name="SOURCEINPUT" value="02">
	<input name="PROGRAMNAME" type="HIDDEN" value="<%=sProgramName%>">
	<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">	
	<input name="maxDate" type="hidden" value="<%=maxDate%>">
	<input type="hidden" size="10" name="showCRD" value="<%=computeSSD%>">	
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
