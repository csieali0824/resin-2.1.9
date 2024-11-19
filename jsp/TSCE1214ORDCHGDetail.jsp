<!--20140724 Peggy,客戶品號或台半品號與ERP訂單不同時,若有改單,須顯示訊息提示user -->
<!--20150721 Peggy,shipping method&sqp&moq改以call tsc_edi_pkg.get_shipping_method&tsc_edi_pkg.GET_SPQ_MOQ取得-->
<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20160513 Peggy,for TSC_EDI_PKG.GET_SHIPPING_METHOD新增customer_id而修改-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>Order Change Confirm</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8;font-size:11px;}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size:11px;}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:11px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;font-size:11px;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia;font-size:11px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
}

function subWindowCRD(polineno,seqno)
{    
	if (event.keyCode == 13)
	{
		var mo_crd = document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].value;
		if (mo_crd.length!= 8)
		{
			alert("訂單項次"+polineno+":CRD日期有誤,請重新確認!!");
			document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].focus();
			return false;
		}	
		else
		{
			var year = mo_crd.substring(0,4);
			var mon = mo_crd.substring(4,6);
			var dd = mo_crd.substring(6,8);
			if (year.substring(0,1) != 2)
			{
				alert("訂單項次"+polineno+":CRD年份有誤,請重新確認!!");
				document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].focus();
				return false;
			}
			else if (mon <1 || mon>12)
			{
				alert("訂單項次"+polineno+":CRD月份有誤,請重新確認!!");
				document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].focus();
				return false;
			}
			else if (dd <1 || dd>31)
			{
				alert("訂單項次"+polineno+":CRD日期有誤,請重新確認!!");
				document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].focus();
				return false;
			}
			else 
			{
				if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
				|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
				|| (isLeapYear(year) && mon == 2 && dd>29)
				|| (!isLeapYear(year) && mon == 2 && dd>28))
				{
					alert("訂單項次"+polineno+":CRD有誤,請重新確認!!");
					document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].focus();
					return false;
				}
			}
		}
		subWindowSSDFind(polineno,seqno);
	}
	else if (event.keyCode >= 48 && event.keyCode <=57)
	{
		return false;
	}
}

function subWindowSSDFind(polineno,seqno)
{    
	var region = document.MYFORM.SALESAREANO.value;
	var crdate = document.MYFORM.elements["MOCRD_"+polineno+"_"+seqno].value;
	var odrtype = document.MYFORM.elements["MO_"+polineno+"_"+seqno].value;
	var plant = document.MYFORM.elements["PLANT_"+polineno].value;
	var shippingMethod = document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+seqno].value;
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var fob = document.MYFORM.elements["FOB_"+polineno+"_"+seqno].value;  //add by Peggy 20210207
	var deliver_to_id = document.MYFORM.DELIVER_TO_ID.value;
	if (odrtype==null || odrtype=="")
	{
		alert("請先選擇訂單資料");
		return false;
	}
	odrtype = odrtype.substr(0,4);

	//subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D11001&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&fob="+fob.replace("&","\"")+"&deliverid="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function subWindowSSDFind1(polineno,seqno)
{  	
	var region = document.MYFORM.SALESAREANO.value;
	var crdate = document.MYFORM.elements["CRD_"+polineno+"_"+seqno].value;
	var plant = document.MYFORM.elements["PLANT_"+polineno].value;
	var odrtype = document.MYFORM.elements["ORDERTYPE_"+polineno].value;
	var shippingMethod = document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+seqno].value;
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var fob = document.MYFORM.elements["FOB_"+polineno+"_"+seqno].value;  //add by Peggy 20210207
	var deliver_to_id = document.MYFORM.DELIVER_TO_ID.value;
	//subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D110021&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&fob="+fob.replace("&","\"")+"&deliverid="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function setSubmit(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();	
}

function setClose(URL)
{
	if (confirm("您確定要不存檔離開嗎?"))
	{
		location.href=URL;
	}
}
function checkall()
{
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.CHKBOX.length ;i++)
		{
			document.MYFORM.CHKBOX[i].checked= document.MYFORM.chkall.checked;
			setCheck(document.MYFORM.CHKBOX[i].value,(i+1));
		}
	}
	else
	{
		document.MYFORM.CHKBOX.checked = document.MYFORM.chkall.checked;
		setCheck(document.MYFORM.CHKBOX.value,1);
	}
}
function setCheck(polineno,irow)
{
	var chkflag ="";
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		chkflag = document.MYFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.MYFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.MYFORM.elements["MOQ_"+polineno].style.backgroundColor ="#E4F3ED";
		document.getElementById("tr_"+polineno).style.backgroundColor ="#E4F3ED";
		document.MYFORM.elements["CRD_"+polineno+"_1"].disabled = false;
		document.MYFORM.elements["CRD_"+polineno+"_1"].style.backgroundColor ="#E4F3ED";			
		document.MYFORM.elements["RFQ_"+polineno+"_1"].style.backgroundColor ="#E4F3ED";
		document.MYFORM.elements["RFQ_"+polineno+"_1"].disabled = false;
		document.MYFORM.elements["REMARK_"+polineno+"_1"].style.backgroundColor ="#E4F3ED";
		document.MYFORM.elements["REMARK_"+polineno+"_1"].disabled=false;
		document.MYFORM.elements["RFQSM_"+polineno+"_1"].disabled=false;
		document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_1"].style.backgroundColor ="#E4F3ED";
		document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_1"].disabled = false;
		document.MYFORM.elements["RFQ_SSD_"+polineno+"_1"].style.backgroundColor ="#E4F3ED";
		document.MYFORM.elements["RFQ_SSD_"+polineno+"_1"].disabled = false;
		for (var j=1; j <= document.MYFORM.elements["MO_ROW_CNT_"+polineno].value ;j++)
		{
			document.MYFORM.elements["MO_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["MOLINE_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["MOQTY_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["MOCRD_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["SSD_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["STATUS_"+polineno+"_"+j].style.backgroundColor ="#E4F3ED";
			if (document.MYFORM.elements["NO_TYPE_"+polineno+"_"+j].value=="MO")
			{
				document.MYFORM.elements["MOQTY_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["MOQTY_"+polineno+"_"+j].value = document.MYFORM.elements["MOQTY_"+polineno+"_"+j].value.replace(/\,/g,"");
				document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["MOCRD_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["SM_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["SSD_"+polineno+"_"+j].disabled=false;
				try
				{
					document.MYFORM.elements["crd_popcal_"+polineno+"_"+j].width=20;
					document.MYFORM.elements["ssd_popcal_"+polineno+"_"+j].width=20;
				}catch(e){}
			}
		}
	}
	else
	{
		document.MYFORM.elements["MOQ_"+polineno].style.backgroundColor ="#ffffff";
		document.getElementById("tr_"+polineno).style.backgroundColor ="#ffffff";
		document.MYFORM.elements["CRD_"+polineno+"_1"].style.backgroundColor ="#ffffff";
		document.MYFORM.elements["CRD_"+polineno+"_1"].disabled = true;			
		document.MYFORM.elements["RFQ_"+polineno+"_1"].style.backgroundColor ="#ffffff";
		document.MYFORM.elements["RFQ_"+polineno+"_1"].value="";
		document.MYFORM.elements["RFQ_"+polineno+"_1"].disabled = true;
		document.MYFORM.elements["REMARK_"+polineno+"_1"].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["REMARK_"+polineno+"_1"].value="";
		document.MYFORM.elements["REMARK_"+polineno+"_1"].disabled = true;
		document.MYFORM.elements["RFQSM_"+polineno+"_1"].disabled = true;
		document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_1"].style.backgroundColor ="#ffffff";
		document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_1"].disabled = true;
		document.MYFORM.elements["RFQ_SSD_"+polineno+"_1"].style.backgroundColor ="#ffffff";
		document.MYFORM.elements["RFQ_SSD_"+polineno+"_1"].disabled = true;
		for (var j=1; j <= document.MYFORM.elements["MO_ROW_CNT_"+polineno].value ;j++)
		{
			document.MYFORM.elements["MO_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["MOLINE_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["MOQTY_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["MOQTY_"+polineno+"_"+j].value=document.MYFORM.elements["ORIGMOQTY_"+polineno+"_"+j].value;
			document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].value=document.MYFORM.elements["ORIGMOSELLINGPRICE_"+polineno+"_"+j].value;
			document.MYFORM.elements["MOCRD_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["MOCRD_"+polineno+"_"+j].value=document.MYFORM.elements["ORIGMOCRD_"+polineno+"_"+j].value;
			document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].value=document.MYFORM.elements["ORIGSHIPPINGMETHOD_"+polineno+"_"+j].value;
			document.MYFORM.elements["SSD_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["SSD_"+polineno+"_"+j].value=document.MYFORM.elements["ORIGSSD_"+polineno+"_"+j].value;
			document.MYFORM.elements["STATUS_"+polineno+"_"+j].style.backgroundColor ="#ffffff";
			if (document.MYFORM.elements["NO_TYPE_"+polineno+"_"+j].value=="MO")
			{
				document.MYFORM.elements["MOQTY_"+polineno+"_"+j].disabled=true;
				document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].disabled=true;
				document.MYFORM.elements["MOCRD_"+polineno+"_"+j].disabled = true;
				document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].disabled=true;
				document.MYFORM.elements["SM_"+polineno+"_"+j].disabled=true;
				document.MYFORM.elements["SSD_"+polineno+"_"+j].disabled=true;
				try
				{
					document.MYFORM.elements["crd_popcal_"+polineno+"_"+j].width=0;
					document.MYFORM.elements["ssd_popcal_"+polineno+"_"+j].width=0;
				}catch(e){}
			}			
		}
		
	}
}
function setSubmit1()
{    
	var chkcnt=0,change_crd=0,change_qty=0,rfq_qty=0,tot_qty=0,changcnt=0,SPQ=0,MOQ=0;
	var custpolineno="",chkvalue=false;;
	var mostatus="";
	var cust_partno="";
	var tsc_partno="";
	var chklen=0;
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		chklen=document.MYFORM.CHKBOX.length;
	}
	else
	{
		chklen=1;
	}
	for (i = 0; i < chklen; i++) 
	{
		if (chklen==1)
		{
			chkvalue = document.MYFORM.CHKBOX.checked;
			custpolineno =document.MYFORM.CHKBOX.value; 
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i].checked;
			custpolineno =document.MYFORM.CHKBOX[i].value; 
		}	

		if (chkvalue)
		{
			SPQ = parseFloat(document.MYFORM.elements["SPQ_"+custpolineno].value);
			MOQ = parseFloat(document.MYFORM.elements["MOQ_"+custpolineno].value);
			SELLINGPRICE = document.MYFORM.elements["SELLINGPRICE_"+custpolineno].value;
			cust_partno = document.MYFORM.elements["CUST_DESC_"+custpolineno].value; //add by Peggy 20140724
			tsc_partno = document.MYFORM.elements["ITEM_DESC_"+custpolineno].value;   //add by Peggy 20140724
			for (var j =1 ; j <= parseFloat(document.MYFORM.elements["ROW_CNT_"+custpolineno].value) ; j++)
			{
				tot_qty=0;changcnt=0;
				mostatus="";
				//add by Peggy 20140304
				try
				{
					mostatus=document.MYFORM.elements["STATUS_"+custpolineno+"_"+j].value;
				}
				catch(e)
				{
					mostatus="";
				}
									
			//if (mostatus!="CLOSED")
			//{
				if ((SPQ ==null || SPQ==0) && (MOQ==null || MOQ==0))
				{
					alert("訂單項次"+custpolineno+":此料號尚未設定SPQ及MOQ,請洽系統管理人員處理!!");
					return false;
				} 					
								
				change_crd=document.MYFORM.elements["CRD_"+custpolineno+"_"+j].value;
				change_qty=parseFloat(document.MYFORM.elements["QTY_"+custpolineno+"_"+j].value.replace(/\,/g,""));
				rfq_qty=document.MYFORM.elements["RFQ_"+custpolineno+"_"+j].value.replace(/\,/g,"");
				if (rfq_qty==null||rfq_qty=="") rfq_qty=0;
				tot_qty+=rfq_qty;	
				if (rfq_qty >0)
				{
					//add by Peggy 20210311
					if (eval(document.MYFORM.elements["CRD_"+custpolineno+"_"+j].value) < eval(document.MYFORM.SYSTEMDATE.value))
					{
						alert("訂單項次"+custpolineno+":CRD必須大於等於今天!!");
						document.MYFORM.elements["CRD_"+custpolineno+"_"+j].focus();
						return false;								
					}	
									
					if  (rfq_qty < MOQ)
					{
						alert("RFQ數量("+rfq_qty+")必須大於等於MOQ:"+MOQ+"!!");
						document.MYFORM.elements["RFQ_"+custpolineno+"_"+j].focus();
						return false;
					}
					else if ((rfq_qty%SPQ) != 0)
					{
						alert("RFQ數量必為SPQ:"+SPQ+"的倍數!!");
						document.MYFORM.elements["RFQ_"+custpolineno+"_"+j].focus();
						return false;
					}
					
					var rfq_ssd = document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].value;
					if (rfq_ssd.length!= 8)
					{
						alert("訂單項次"+custpolineno+":SSD日期有誤,請重新確認!!");
						document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].focus();
						return false;
					}	
					else
					{
						var year = rfq_ssd.substring(0,4);
						var mon = rfq_ssd.substring(4,6);
						var dd = rfq_ssd.substring(6,8);
						if (year.substring(0,1) != 2)
						{
							alert("訂單項次"+custpolineno+":SSD年份有誤,請重新確認!!");
							document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].focus();
							return false;
						}
						else if (mon <1 || mon>12)
						{
							alert("訂單項次"+custpolineno+":SSD月份有誤,請重新確認!!");
							document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].focus();
							return false;
						}
						else if (dd <1 || dd>31)
						{
							alert("訂單項次"+custpolineno+":SSD日期有誤,請重新確認!!");
							document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].focus();
							return false;
						}
						else 
						{
							if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
							|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
							|| (isLeapYear(year) && mon == 2 && dd>29)
							|| (!isLeapYear(year) && mon == 2 && dd>28))
							{
								alert("訂單項次"+custpolineno+":SSD有誤,請重新確認!!");
								document.MYFORM.elements["RFQ_SSD_"+custpolineno+"_"+j].focus();
								return false;
							}
						}
					}
				}
						
				if (mostatus!="CLOSED")
				{							
					for (var k =1 ; k <= parseFloat(document.MYFORM.elements["MO_ROW_CNT_"+custpolineno].value) ; k++)
					{
						var mo_qty = parseFloat(document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].value.replace(/\,/g,""));
						var orig_mo_qty = parseFloat(document.MYFORM.elements["ORIGMOQTY_"+custpolineno+"_"+k].value.replace(/\,/g,""));
						var mo_sellingprice = parseFloat(document.MYFORM.elements["MOSELLINGPRICE_"+custpolineno+"_"+k].value.replace(/\,/g,""));
						var orig_mo_sellingprice = parseFloat(document.MYFORM.elements["ORIGMOSELLINGPRICE_"+custpolineno+"_"+k].value.replace(/\,/g,""));
						var mo_crd = document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].value;
						var mo_cust_partno = document.MYFORM.elements["MO_CUST_PARTNO_"+custpolineno+"_"+k].value; //add by Peggy 20140724
						var mo_tsc_partno = document.MYFORM.elements["MO_TSC_PARTNO_"+custpolineno+"_"+k].value;   //add by Peggy 20140724
						if (mo_crd.length!= 8)
						{
							alert("訂單項次"+custpolineno+":CRD日期有誤,請重新確認!!");
							document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].focus();
							return false;
						}	
						else
						{
							var year = mo_crd.substring(0,4);
							var mon = mo_crd.substring(4,6);
							var dd = mo_crd.substring(6,8);
							if (year.substring(0,1) != 2)
							{
								alert("訂單項次"+custpolineno+":CRD年份有誤,請重新確認!!");
								document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else if (mon <1 || mon>12)
							{
								alert("訂單項次"+custpolineno+":CRD月份有誤,請重新確認!!");
								document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else if (dd <1 || dd>31)
							{
								alert("訂單項次"+custpolineno+":CRD日期有誤,請重新確認!!");
								document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else 
							{
								if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
								|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
								|| (isLeapYear(year) && mon == 2 && dd>29)
								|| (!isLeapYear(year) && mon == 2 && dd>28))
								{
									alert("訂單項次"+custpolineno+":CRD有誤,請重新確認!!");
									document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].focus();
									return false;
								}
							}
						}
						var mo_ssd = document.MYFORM.elements["SSD_"+custpolineno+"_"+k].value;
						if (mo_ssd.length!= 8)
						{
							alert("訂單項次"+custpolineno+":SSD日期有誤,請重新確認!!");
							document.MYFORM.elements["SSD_"+custpolineno+"_"+k].focus();
							return false;
						}	
						else
						{
							var year = mo_ssd.substring(0,4);
							var mon = mo_ssd.substring(4,6);
							var dd = mo_ssd.substring(6,8);
							if (year.substring(0,1) != 2)
							{
								alert("訂單項次"+custpolineno+":SSD年份有誤,請重新確認!!");
								document.MYFORM.elements["SSD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else if (mon <1 || mon>12)
							{
								alert("訂單項次"+custpolineno+":SSD月份有誤,請重新確認!!");
								document.MYFORM.elements["SSD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else if (dd <1 || dd>31)
							{
								alert("訂單項次"+custpolineno+":SSD日期有誤,請重新確認!!");
								document.MYFORM.elements["SSD_"+custpolineno+"_"+k].focus();
								return false;
							}
							else 
							{
								if (((mon == 4 || mon == 6 || mon == 9 || mon == 11) && dd >30) 
								|| ((mon == 1 || mon == 3 || mon == 5 || mon == 7 || mon == 8 || mon == 10 || mon == 12) && dd >31)
								|| (isLeapYear(year) && mon == 2 && dd>29)
								|| (!isLeapYear(year) && mon == 2 && dd>28))
								{
									alert("訂單項次"+custpolineno+":SSD有誤,請重新確認!!");
									document.MYFORM.elements["SSD_"+custpolineno+"_"+k].focus();
									return false;
								}
							}
						}
						
						if (change_crd==mo_crd)
						{
							tot_qty += parseFloat(document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].value.replace(/\,/g,""));
							if (mo_crd != document.MYFORM.elements["ORIGMOCRD_"+custpolineno+"_"+k].value || document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].value != document.MYFORM.elements["ORIGMOQTY_"+custpolineno+"_"+k].value)
							{
								changcnt++;
								
							}
						}
						
						//訂單數量異動
						if (orig_mo_qty != mo_qty)
						{
							if (mo_qty ==null||mo_qty=="") mo_qty=0;
							if (mo_qty >0)
							{
								if  (mo_qty < MOQ)
								{
									alert("訂單數量必須大於等於MOQ:"+MOQ+"!!");
									document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].focus();
									return false;
								}
								else if ((mo_qty%SPQ) != 0)
								{
									alert("訂單數量必為SPQ:"+SPQ+"的倍數!!");
									document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].focus();
									return false;
								}
							}
						}
						//單價異動
						if (SELLINGPRICE != mo_sellingprice && mo_sellingprice != orig_mo_sellingprice)
						{
							alert("Selling Price不正確!!");
							document.MYFORM.elements["MOSELLINGPRICE_"+custpolineno+"_"+k].focus();
							return false;
						}
						//檢查客戶品號,add by Peggy 20140724
						if (cust_partno!=mo_cust_partno)
						{
							alert("MO的客戶品號:"+mo_cust_partno+"與此次Order Change客戶品號:"+cust_partno+"不符,無法改單!");
							return false;
						}
						//檢查台半品號,add by Peggy 20140724
						if (tsc_partno!=mo_tsc_partno)
						{
							alert("MO的台半品號:"+mo_tsc_partno+"與此次Order Change台半品號:"+tsc_partno+"不符,無法改單!");
							return false;
						}
					}
				}
				if (change_qty!=tot_qty && changcnt>0 && tot_qty < mo_qty )
				{
					alert("訂單項次"+custpolineno+":數量有誤,請重新確認!!");
					return false;
				}
			}
			chkcnt++;
		}
	}
	if(chkcnt ==0)
	{
		alert("請先勾選處理項目!!");
		return false;
	}
	else if (document.MYFORM.CHKBOX.checked == false)
	{
		alert("請先勾選處理項目!!");
		return false;
	}
	if (confirm("您確定要送出申請嗎?"))
	{
		document.MYFORM.save.disabled=true;
		document.MYFORM.exit.disabled=true;
		document.MYFORM.closed.disabled=true;
		document.MYFORM.action="../jsp/TSCE1214MProcess.jsp";
		document.MYFORM.submit();
	}
}

function setSubmit2()
{    
	var chkcnt=0,chklen=0;
	var chkvalue="";
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		chklen=document.MYFORM.CHKBOX.length;
	}
	else
	{
		chklen=1;
	}
	for (i = 0; i < chklen; i++) 
	{
		if (chklen==1)
		{
			chkvalue = document.MYFORM.CHKBOX.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i].checked;
		}	
		if (chkvalue) chkcnt++;
	}
	if(chkcnt ==0)
	{
		alert("請先勾選處理項目!!");
		return false;
	}
	if (confirm("您確定要送出申請嗎?"))
	{
		document.MYFORM.save.disabled=true;
		document.MYFORM.exit.disabled=true;
		document.MYFORM.closed.disabled=true;
		document.MYFORM.action="../jsp/TSCE1214MProcess.jsp?NOCHANGE=Y";
		document.MYFORM.submit();
	}
}

function setCRD(objName)
{
	if (document.MYFORM.elements[objName].value==null || document.MYFORM.elements[objName].value!=document.MYFORM.elements[objName.replace("CRD","ORIG_CRD")].value)
	{
		document.MYFORM.elements[objName.replace("CRD","RFQ_SSD")].value="";
	}
}

</script>
<%
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID==null) ERPCUSTOMERID="";
	String VERSIONID = request.getParameter("VERSIONID");
	if (VERSIONID==null) VERSIONID="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	String SALESAREANO = request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String SYSTEMDATE = dateBeans.getYearMonthDay();
	String sql = "",CREATION_DATE="",CREATED_BY="",CUSTNAME="",VERSION_ID="",CUSTOMER_NAME="",MARKET_GROUP="",PARENT_VERSIONID="",ENDCUSTNAME="",ENDCUSTID="",FOB_POINT="",DELIVER_TO_ID="",v_warning="";
	
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
	
	boolean bNotFound = false;
	
	try
	{
		sql = " select a.*,d.CURRENCY_CODE,'('||c.customer_number||')'||c.CUSTOMER_NAME as CUSTNAME,'001' AS SALES_AREA_NO,c.CUSTOMER_NAME,c.ATTRIBUTE2 market_group,d.customer_name,d.customer_id "+
		      " from oraddman.tsce_purchase_order_headers a,ar_customers c,oraddman.tsce_end_customer_list d "+
			  " where substr(a.customer_po,0,instr(a.customer_po,'-')-1) = d.customer_id"+
			  " and a.erp_customer_id = c.customer_id"+
			  " and exists (select 1 from oraddman.tsce_purchase_order_lines b where b.DATA_FLAG =? and b.customer_po = a.customer_po "+
			  " and b.version_id = a.version_id and b.customer_po =? and b.version_id=?)";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"E");
		statement.setString(2,CUSTPO);
		statement.setString(3,VERSIONID);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUSTNAME = rs.getString("CUSTNAME");
			CURRENCY = rs.getString("CURRENCY_CODE");
			VERSION_ID = rs.getString("VERSION_ID");
			SALESAREANO = rs.getString("SALES_AREA_NO");
			CUSTOMER_NAME = rs.getString("CUSTOMER_NAME");
			MARKET_GROUP = rs.getString("MARKET_GROUP");
			PARENT_VERSIONID = rs.getString("PARENT_VERSION_ID");
			ENDCUSTNAME =rs.getString("CUSTOMER_NAME");
			ENDCUSTID=rs.getString("customer_id");
			ERPCUSTOMERID = rs.getString("ERP_CUSTOMER_ID");
			
			//add by Peggy 20190319
			sql =" select a.FOB_POINT"+ 
				 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b"+
				 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
				 " and a.STATUS=? "+
				 " AND a.PRIMARY_FLAG=?"+
				 " AND a.SITE_USE_CODE=?"+
				 " and b.CUST_ACCOUNT_ID =?";
			PreparedStatement statementa = con.prepareStatement(sql);
			statementa.setString(1,"A");
			statementa.setString(2,"Y");
			statementa.setString(3,"BILL_TO");
			statementa.setString(4,ERPCUSTOMERID);
			ResultSet rsa=statementa.executeQuery();
			if (rsa.next())
			{	
				FOB_POINT = rsa.getString("FOB_POINT");
			}
			rsa.close();		
			statementa.close();
			
			//add by Peggy 20210208
			sql =" select a.site_use_id"+ 
				 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b"+
				 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
				 " and a.STATUS=? "+
				 " AND a.PRIMARY_FLAG=?"+
				 " AND a.SITE_USE_CODE=?"+
				 " and b.CUST_ACCOUNT_ID =?";
			statementa = con.prepareStatement(sql);
			statementa.setString(1,"A");
			statementa.setString(2,"Y");
			statementa.setString(3,"DELIVER_TO");
			statementa.setString(4,ERPCUSTOMERID);
			rsa=statementa.executeQuery();
			if (rsa.next())
			{	
				DELIVER_TO_ID = rsa.getString("SITE_USE_ID");
			}
			rsa.close();		
			statementa.close();
		}
		else
		{
			bNotFound = true;
		}
		rs.close();
		statement.close();	
	
	}
	catch(Exception e)
	{
		out.println("Exception1:"+e.getMessage());
		//bNotFound = true;
	}	
	
	if (bNotFound)
	{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!PO狀態可能不符合條件,請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCE1214ORDCHGDetail.jsp" METHOD="post" NAME="MYFORM">
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">TSCE PO</font>
			<font style="font-size:20px;color:#000000;font-family:細明體"><strong>變更確認</strong></font>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#990066" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td>PO明細:</td>
					<td align="right"><a href="TSCE1214ExceptionQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#999999" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td bgcolor="#CBE2E4"><jsp:getProperty name="rPH" property="pgCustomerName"/></td>
					<td><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" size="60" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"><input type="hidden" name="SALESAREANO" value="<%=SALESAREANO%>"><input type="hidden" name="CUSTOMER_NAME" value="<%=CUSTOMER_NAME%>"></td>
					<td bgcolor="#CBE2E4"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="VERSIONID" value="<%=VERSIONID%>"></td>
					<td bgcolor="#CBE2E4">End Customer Name</td>
					<td><input type="text" name="ENDCUSTNAME" value="<%=ENDCUSTNAME%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ENDCUSTID" value="<%=ENDCUSTID%>"></td>
					<td bgcolor="#CBE2E4"><jsp:getProperty name="rPH" property="pgCurr"/></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<HR>
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#60895F" bordercolordark="#ffffff" cellPadding="0"  cellspacing="0">
				<tr bgcolor="#CBE2E4">
					<td colspan="9" align="center">PO變更明細</td>
					<td colspan="6" align="center" bgcolor="#FFCC00">處理結果</td>
				</tr>
				<tr bgcolor="#CBE2E4">
					<td rowspan="2" align="center" width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td rowspan="2" align="center" width="3%"><jsp:getProperty name='rPH' property='pgCustPOLineNo'/></td>
					<td rowspan="2" align="center" width="7%"><jsp:getProperty name='rPH' property='pgCustItemNo'/></td>
					<td rowspan="2" align="center" width="8%"><jsp:getProperty name='rPH' property='pgTSCAlias'/><jsp:getProperty name='rPH' property='pgItemDesc'/><BR>TSC Package</td>
					<td rowspan="2" align="center" width="6%">Supplier ID</td>
					<td rowspan="2" align="center" width="5%"><jsp:getProperty name='rPH' property='pgQty'/></td>
					<td rowspan="2" align="center" width="4%"><jsp:getProperty name='rPH' property='pgUOM'/></td>
					<td rowspan="2" align="center" width="4%">Selling<br>Price</td>
					<td rowspan="2" align="center" width="5%">CRD</td>
					<td colspan="3" align="center" width="15%" bgcolor="#FFCC00">詢RFQ</td>
					<td rowspan="2" align="center" width="34%" bgcolor="#F1D1BE">修改訂單/RFQ明細</td>
					<td rowspan="2" align="center" width="2%" bgcolor="#FFCC00">工程變更註記</td>
					<td rowspan="2" align="center" width="5%" bgcolor="#FFCC00">備註</td>
				</tr>
				<tr bgcolor="#F8F3D1">
					<td colspan="1" align="center" width="5%" bgcolor="#FFCC00">出貨方式</td>
					<td colspan="1" align="center" width="5%" bgcolor="#FFCC00">SSD</td>
					<td colspan="1" align="center" width="5%" bgcolor="#FFCC00">RFQ數量<br>(PCE)</td>
				</tr>
			<%
			try
			{
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt1=con.prepareStatement(sql1);
				pstmt1.executeUpdate(); 
				pstmt1.close();		
					
				sql = " select (select count(1) from oraddman.tsce_purchase_order_lines b where b.DATA_FLAG='E' and b.CUSTOMER_PO = a.CUSTOMER_PO and b.PO_LINE_NO=a.PO_LINE_NO) rowcnt"+
				      ",ROWNUM AS SEQ_NO"+
					  ",a.PO_LINE_NO"+
					  ",a.CUST_PART_NO"+
					  ",a.TSC_PART_NO"+
					  ",a.QUANTITY"+
					  ",a.UOM"+
					  ",a.UNIT_PRICE"+
					  ",a.CRD CUST_REQUEST_DATE"+
					  ",a.RFQ "+
					  ",a.RFQ_LINE_NO line_no "+
					  ",NVL(b.ATTRIBUTE3"+
					  ",(select attribute3 from inv.mtl_system_items_b c where c.ORGANIZATION_ID = '49' and c.inventory_item_status_code <> 'Inactive' and c.description =a.TSC_PART_NO and rownum=1)) plantcode "+
					  ",b.TSC_PACKAGE"+
					  ",b.TSC_FAMILY"+
					  ",b.TSC_PROD_GROUP"+
					  ",b.segment1"+
					  ",c.quantity orig_qty"+
					  ",(select unit_price  from oraddman.tsce_purchase_order_lines g where a.customer_po=g.customer_po AND g.version_id ='"+PARENT_VERSIONID+"' and a.po_line_no=g.po_line_no) orig_unit_price"+
					  ",c.CRD orig_crd"+
					  ",c.cust_part_no orig_cust_part_no"+  //add by Peggy 20140724
                      ",c.tsc_part_no orig_tsc_part_no"+ //add by Peggy 20140724
					  ",b.inventory_item_id"+            //add by Peggy 20150721
					  ",b.inactive_flag"+  //add by Peggy 20200814
					  ",a.supplier_number"+  //add by Peggy 20220427
				      " from (select x.* ,(select inventory_item_id from (select k.tscustomerid,p.cust_po_number,p.cust_po_line_no,p.inventory_item_id ,row_number() over (partition by k.tscustomerid,p.cust_po_number,p.cust_po_line_no ORDER by p.dndocno desc) rec_cnt from oraddman.tsdelivery_notice k,oraddman.tsdelivery_notice_detail p where k.dndocno=p.dndocno) where tscustomerid ='"+ERPCUSTOMERID+"' and cust_po_number=y.customer_po and cust_po_line_no=x.PO_LINE_NO and rec_cnt =1) inventory_item_id from oraddman.tsce_purchase_order_lines x, oraddman.tsce_purchase_order_headers y where  x.customer_po=y.customer_po and x.version_id = y.version_id and x.customer_po ='"+CUSTPO+"' and x.version_id ='"+VERSIONID+"' and x.data_flag='E') a"+
					  //",(select  b.inventory_item_id, c.ATTRIBUTE3,c.segment1,b.SOLD_TO_ORG_ID,b.item,b.item_description,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY,CASE WHEN NVL(c.attribute3, 'N/A')='008' THEN 'Rect-Subcon' WHEN NVL(c.attribute3, 'N/A')='002' THEN 'Rect' ELSE NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP from oe_items_v b,inv.mtl_system_items_b c where c.ORGANIZATION_ID = '49' and b.inventory_item_id=c.inventory_item_id and b.sold_to_org_id ="+ERPCUSTOMERID+") b"+
					  //" ,(select * from (select  b.inventory_item_id, c.ATTRIBUTE3,c.segment1,b.SOLD_TO_ORG_ID,b.item,b.item_description,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY,CASE WHEN NVL(c.attribute3, 'N/A')='008' THEN 'Rect-Subcon' WHEN NVL(c.attribute3, 'N/A')='002' THEN 'Rect' ELSE NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP ,row_number() over (partition by b.sold_to_org_id, b.item,b.item_description order by case when c.attribute3 ='002' then 1 else 2 end ) rec_rank from oe_items_v b,inv.mtl_system_items_b c where c.ORGANIZATION_ID = '49' and b.inventory_item_id=c.inventory_item_id and b.sold_to_org_id ="+ERPCUSTOMERID+")  where REC_RANK=1) b"+
					  //" ,(select * from (select  b.inventory_item_id, c.ATTRIBUTE3,c.segment1,b.SOLD_TO_ORG_ID,b.item,b.item_description,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
					  //"                 ,CASE WHEN NVL(c.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP "+
					  " ,(select * from (select  b.inventory_item_id, c.ATTRIBUTE3,c.segment1,b.SOLD_TO_ORG_ID,b.item,b.item_description,NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,23),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,23)) as TSC_PACKAGE,NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,21),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,21)) as TSC_FAMILY"+
					  "                 ,CASE WHEN NVL(c.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,1100000003),TSC_INV_CATEGORY(c.INVENTORY_ITEM_ID,43,1100000007)) END as TSC_PROD_GROUP "+
					  "                 ,row_number() over (partition by b.sold_to_org_id, b.item,b.item_description order by case when c.attribute3 ='002' then 1 else 2 end ) rec_rank "+
					  "                 ,NVL(e.ATTRIBUTE2,'N') inactive_flag"+ //add by Peggy 20200814
					  "                 from oe_items_v b"+
					  "                 ,inv.mtl_system_items_b c"+
					  "                 ,oraddman.tsprod_manufactory d"+  //add by Peggy 20151209
					  "                 ,MTL_CUSTOMER_ITEM_XREFS e"+ //add by Peggy 20200814
					  "                 where c.ORGANIZATION_ID = '49' "+
					  "                 and b.inventory_item_id=c.inventory_item_id"+
 				      "                 and c.attribute3=d.MANUFACTORY_NO(+)"+
                      "                 and b.ITEM_ID=e.CUSTOMER_ITEM_ID"+ //add by Peggy 20200814
                      "                 and b.INVENTORY_ITEM_ID=e.INVENTORY_ITEM_ID"+ //add by Peggy 20200814
					  "                 and b.sold_to_org_id ="+ERPCUSTOMERID+")"+
					  "   where REC_RANK=1) b"+
					  " ,(select * from oraddman.tsce_purchase_order_lines where customer_po ='"+CUSTPO+"' and version_id ='"+PARENT_VERSIONID+"') c"+
					  " where b.item(+)=a.CUST_PART_NO "+
					  " and b.ITEM_DESCRIPTION(+) = a.tsc_part_no"+
       				  " AND a.customer_po=c.customer_po(+)"+
                      " AND a.po_line_no=c.po_line_no(+)"+
					  " order by a.PO_LINE_NO";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				ResultSet rs=statement.executeQuery();
				int polineno=0,i =0,rowcnt=0,po_line_cnt=0;
				String cust_po_line_number="",SPQ="",MOQ="",SHIPPING_METHOD="",PLANT_CODE="",ORDER_TYPE="1214",SSD="",CRD="";
				while (rs.next())
				{
					CRD = rs.getString("CUST_REQUEST_DATE");
					PLANT_CODE = rs.getString("plantcode");
					if ((SALESAREANO.equals("001") && rs.getString("TSC_PACKAGE") != null && rs.getString("TSC_PACKAGE").equals("SMA")) || MARKET_GROUP.equals("AU"))
					{
						PLANT_CODE ="002";
					}
						
					//modify by Peggy 20150721
					//CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?)}");
					CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}");
					csf.setString(1,SALESAREANO);
					csf.setString(2,(rs.getString("TSC_PACKAGE")==null?"":rs.getString("TSC_PACKAGE")));      
					csf.setString(3,(rs.getString("TSC_FAMILY")==null?"":rs.getString("TSC_FAMILY")));                   
					csf.setString(4,rs.getString("TSC_PART_NO"));    
					csf.setString(5,CRD);   
					csf.registerOutParameter(6, Types.VARCHAR);  
					csf.setString(7,ORDER_TYPE);   
					csf.setString(8,PLANT_CODE);   
					csf.setString(9,ERPCUSTOMERID);    //add by Peggy 20160513
					csf.setString(10,FOB_POINT);       //add by Peggy 20190319
					csf.setString(11,DELIVER_TO_ID);   //add by Peggy 20190319
					csf.execute();
					SHIPPING_METHOD = csf.getString(6);                
					csf.close();					
					
					Statement state3=con.createStatement();     
					//ResultSet rs3=state3.executeQuery("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+SHIPPING_METHOD+"','"+PLANT_CODE+"') from dual");
					ResultSet rs3=state3.executeQuery("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+SHIPPING_METHOD+"','"+PLANT_CODE+"',sysdate,"+ERPCUSTOMERID+",'"+FOB_POINT+"','"+DELIVER_TO_ID+"') from dual");  //新增sysdate參數,modify by Peggy 20150723
					//out.println("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+SHIPPING_METHOD+"','"+PLANT_CODE+"',sysdate,"+ERPCUSTOMERID+",'"+FOB_POINT+"','"+DELIVER_TO_ID+"') from dual");
					if (rs3.next())	
					{ 
						SSD =rs3.getString(1);	
					}
					else
					{
						SSD ="";
					}
					rs3.close();
					state3.close();	
						
					//modify by Peggy 20150721
					CallableStatement csx = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?)}");
					csx.setString(1,rs.getString("inventory_item_id"));
					csx.setString(2,PLANT_CODE);      
					csx.registerOutParameter(3, Types.VARCHAR);  
					csx.registerOutParameter(4, Types.VARCHAR);  
					csx.execute();
					SPQ = csx.getString(3);  
					if (SPQ==null) SPQ="";              
					MOQ = csx.getString(4);                
					if (MOQ==null) MOQ="";
					csx.close();					
			
					i++;
					out.println("<tr id='tr_"+rs.getString("PO_LINE_NO")+"'>");
					if (!cust_po_line_number.equals(rs.getString("PO_LINE_NO")))
					{
						po_line_cnt=0;
						polineno ++;
						cust_po_line_number =rs.getString("PO_LINE_NO");
						rowcnt = Integer.parseInt(rs.getString("rowcnt"));
						out.println("<td rowspan="+rowcnt+"><input type='checkbox' name='CHKBOX' value='"+rs.getString("PO_LINE_NO")+"' onclick=setCheck('"+rs.getString("PO_LINE_NO")+"','"+polineno+"');><input type='hidden' name='ROW_CNT_"+cust_po_line_number+"' value='"+rowcnt+"'></td>");
						out.println("<td rowspan="+rowcnt+" align='center'>"+rs.getString("PO_LINE_NO")+"</td>");
						out.println("<td rowspan="+rowcnt+">"+(!rs.getString("CUST_PART_NO").equals(rs.getString("orig_cust_part_no"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+rs.getString("CUST_PART_NO")+"</font>"+(rs.getString("inactive_flag")!=null && rs.getString("inactive_flag").equals("Y")?"<br><font style='font-weight:bold;color:ff0000'>(Inactive)</font>":"")+"<input type='hidden' name='CUST_DESC_"+cust_po_line_number+"' value='"+rs.getString("CUST_PART_NO")+"'><input type='hidden' name='PLANT_"+cust_po_line_number+"' value='"+PLANT_CODE+"'><input type='hidden' name='ORDERTYPE_"+cust_po_line_number+"' value='"+ORDER_TYPE+"'></td>");
						out.println("<td rowspan="+rowcnt+">"+(!rs.getString("TSC_PART_NO").equals(rs.getString("orig_tsc_part_no"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+rs.getString("TSC_PART_NO")+"</font><input type='hidden' name='ITEM_DESC_"+cust_po_line_number+"' value='"+rs.getString("TSC_PART_NO")+"'><br><font class='style2'><font color='blue'><strong>MOQ:</strong></font><input type='text' class='style4' style='text-align:right;' name='MOQ_"+cust_po_line_number+"' value='"+MOQ+"' size='4' onKeyDown='return (event.keyCode!=8);' readonly ><input type='hidden' name='SPQ_"+cust_po_line_number+"' value='"+SPQ+"'><input type='hidden' name='SELLINGPRICE_"+cust_po_line_number+"' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"'>");
						if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("Matrix SMB") || rs.getString("TSC_PACKAGE").equals("Matrix SMC") || rs.getString("TSC_PACKAGE").equals("SOD-123W") || rs.getString("TSC_PACKAGE").equals("Micro SMA")))
						{
							v_warning=" style='background-color:#FF99CC'";
						}
						else
						{
							v_warning="";
						}						
						out.println("<div "+ v_warning+">"+rs.getString("TSC_PACKAGE")+"</div>");  //ADD BY PEGGY 20210317
						po_line_cnt++;
					}
					else
					{
						rowcnt=0;
						po_line_cnt++;
					}
					out.println("</td>");
					out.println("<td align='center'>"+rs.getString("supplier_number")+"<input type='hidden' name='SUPPLIER_ID_"+cust_po_line_number+"' value='"+rs.getString("supplier_number")+"'></td>"); //add by Peggy 20220427
					out.println("<td align='right'>"+(!rs.getString("QUANTITY").equals(rs.getString("ORIG_QTY"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs.getString("QUANTITY")))+"</FONT>");
					out.println("<input type='hidden' name='QTY_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs.getString("QUANTITY")))+"'><input type='hidden' name='SEQ_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+rs.getString("SEQ_NO")+"'></td>");
					out.println("<td align='center'>"+rs.getString("UOM")+"</td>");
					out.println("<td align='right'>"+(!rs.getString("UNIT_PRICE").equals(rs.getString("ORIG_UNIT_PRICE"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"</FONT></td>");
					//out.println("<td align='center'>"+(!CRD.equals(rs.getString("ORIG_CRD"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+CRD+"</FONT><input type='hidden' name='CRD_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+CRD+"'></td>");
					out.println("<td align='center'><input type='text' class='style2' name='CRD_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+CRD+"' size='8' onKeypress='return event.keyCode >= 48 && event.keyCode <=57' "+(!CRD.equals(rs.getString("ORIG_CRD"))?" style='font-weight:bold;color:ff0000'":"style='color:000000'")+"  onBlur='setCRD("+'"'+"CRD_"+cust_po_line_number+"_"+po_line_cnt+'"'+")' disabled><br><input type='hidden' name='ORIG_CRD_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+CRD+"'></td>");
					out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='RFQ_SHIPMETHOD_"+cust_po_line_number+"_"+po_line_cnt+"' size='4' value='"+SHIPPING_METHOD+"' "+((rs.getString("RFQ")!=null && rs.getString("RFQ")!="")?" onKeyDown='return (event.keyCode!=8);' readonly":" readonly ")+"><input type='button' name='RFQSM_"+cust_po_line_number+"_"+po_line_cnt+"' value='..' style='font-size:11px' onClick='subWindowSSDFind1("+cust_po_line_number+","+po_line_cnt+")' disabled></td>");
					out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='RFQ_SSD_"+cust_po_line_number+"_"+po_line_cnt+"' size='6' value='"+SSD+"' "+((rs.getString("RFQ")!=null && rs.getString("RFQ")!="")?" onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled></td>");
					out.println("<td align='center'><input type='text' class='style4' style='text-align:right;' name='RFQ_"+cust_po_line_number+"_"+po_line_cnt+"' size='4' value='' "+((rs.getString("RFQ")!=null && rs.getString("RFQ")!="")?" onKeyDown='return (event.keyCode!=8);' readonly ":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled></td>");
					if (rowcnt>0)
					{
						out.println("<td rowspan="+rowcnt+" align='center' valign='top'>");
						//modify by Peggy 20140724,add 客戶品號及台半品號欄位
						//sql = " select '1','MO' TYPE,to_char(b.order_number) requestno,line_number||'.'||a.shipment_number line_no,a.ordered_quantity,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyymmdd') REQUEST_DATE,to_char( a.SCHEDULE_SHIP_DATE,'yyyymmdd')  SCHEDULE_SHIP_DATE,a.line_number,a.shipment_number,a.FLOW_STATUS_CODE status,a.UNIT_SELLING_PRICE SELLING_PRICE "+
						sql = " select '1','MO' TYPE,to_char(b.order_number) requestno,line_number||'.'||a.shipment_number line_no,a.ordered_quantity,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyymmdd') REQUEST_DATE,to_char( a.SCHEDULE_SHIP_DATE,'yyyymmdd')  SCHEDULE_SHIP_DATE,a.line_number,a.shipment_number,a.FLOW_STATUS_CODE status,a.UNIT_SELLING_PRICE SELLING_PRICE ,a.ordered_item,c.description"+
						      ",a.fob_point_code fob_point"+ //add by Peggy 20210207
						      " from ont.oe_order_lines_all a"+
							  ",ont.oe_order_headers_all b"+
							  ",inv.mtl_system_items_b c "+
                              " where b.SOLD_TO_ORG_ID=?"+
							  " and a.customer_line_number=?"+
							  " and a.customer_shipment_number=?"+
							  " and a.header_id=b.header_id"+
							  " and a.ordered_quantity>0"+
							  " and a.FLOW_STATUS_CODE <>'CANCELLED'"+
                              " and a.inventory_item_id =c.inventory_item_id"+
                              " and a.ship_from_org_id=c.organization_id"+
							  " union all"+
							  //" select '2','RFQ' TYPE,a.dndocno requestno,to_char(a.line_no) line_no,a.quantity*1000 ordered_quantity,a.shipping_method,a.CUST_REQUEST_DATE REQUEST_DATE,substr(a.REQUEST_DATE,1,8) SCHEDULE_SHIP_DATE,line_no line_number,0 shipment_number ,a.LSTATUS  status,a.SELLING_PRICE"+
							  " select '2','RFQ' TYPE,a.dndocno requestno,to_char(a.line_no) line_no,a.quantity*1000 ordered_quantity,a.shipping_method,a.CUST_REQUEST_DATE REQUEST_DATE,substr(a.REQUEST_DATE,1,8) SCHEDULE_SHIP_DATE,line_no line_number,0 shipment_number ,a.LSTATUS  status,a.SELLING_PRICE,a.ordered_item,a.item_description description"+							  
							  ",nvl(a.fob,b.fob_point) fob_point"+ //add by Peggy 20210207
							  " from oraddman.tsdelivery_notice_detail a"+
							  ",oraddman.tsdelivery_notice b"+
							  " where a.dndocno = b.dndocno"+
							  " and b.TSCUSTOMERID=?"+
							  " and a.CUST_PO_NUMBER =?"+
							  " and a.CUST_PO_LINE_NO=?"+
							  " AND (ORDERNO is null or ORDERNO ='N/A')"+
                              " and a.LSTATUSID not in ('001','010','012')"+
							  " order by 1,3,4 ";
						//out.println(sql);
						//out.println(""+ERPCUSTOMERID);
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,ERPCUSTOMERID);
						statement1.setString(2,CUSTPO);
						statement1.setString(3,rs.getString("PO_LINE_NO"));
						statement1.setString(4,ERPCUSTOMERID);
						statement1.setString(5,CUSTPO);
						statement1.setString(6,rs.getString("PO_LINE_NO"));
						ResultSet rs1=statement1.executeQuery();
						int j=0;
						boolean b_show = true;
						while (rs1.next())
						{
							j++;
							if (j==1)
							{
								out.println("<table width='70%' border='1' bordercolorlight='#60895F' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>");
								out.println("<tr bgcolor='#F1D1BE' style='color:#000000;font-size:11px'>");
								out.println("<td align='center' width='15%'>訂單/RFQ</td>");
								out.println("<td align='center' width='5%'>行號</td>");
								out.println("<td align='center' width='10%'>訂單量(PCE)</td>");
								out.println("<td align='center' width='10%'>Selling Price</td>");
								out.println("<td align='center' width='10%'>CRD</td>");
								out.println("<td align='center' width='10%'>出貨方式</td>");
								out.println("<td align='center' width='10%'>SSD</td>");
								out.println("<td align='center' width='10%'>狀態</td>");
								out.println("</tr>");
							
							}
							if (rs1.getString("TYPE").equals("RFQ")||rs1.getString("STATUS").equals("SHIPPED")||rs1.getString("STATUS").equals("CLOSED"))
							{
								b_show = false;
							}
							else
							{
								b_show = true;
							}
							out.println("<tr>");
							out.println("<td align='center'><input type='text' style='text-align:left' class='style2' name='MO_"+cust_po_line_number+"_"+j+"' size='10' value='"+rs1.getString("requestno")+"' onKeyDown='return (event.keyCode!=8);' readonly><input type='hidden' name='NO_TYPE_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("TYPE")+"'><input type='hidden' name='MO_CUST_PARTNO_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("ORDERED_ITEM")+"'><input type='hidden' name='MO_TSC_PARTNO_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("DESCRIPTION")+"'><input type='hidden' name='FOB_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("FOB_POINT")+"'></td>");
							out.println("<td align='center'><input type='text' style='text-align:center' class='style2' name='MOLINE_"+cust_po_line_number+"_"+j+"' size='3' value='"+rs1.getString("line_no")+"' onKeyDown='return (event.keyCode!=8);' readonly></td>");
							out.println("<td align='center'><input type='text' style='text-align:right'  class='style4' name='MOQTY_"+cust_po_line_number+"_"+j+"' size='5' value='"+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs1.getString("ordered_quantity")))+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled><input type='hidden' name='ORIGMOQTY_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("ordered_quantity")+"'></td>");
							out.println("<td align='center'><input type='text' style='text-align:right'  class='style4' name='MOSELLINGPRICE_"+cust_po_line_number+"_"+j+"' size='6' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)' disabled><input type='hidden' name='ORIGMOSELLINGPRICE_"+cust_po_line_number+"_"+j+"' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))+"'></td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='MOCRD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("REQUEST_DATE")+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='subWindowCRD("+cust_po_line_number+","+j+")' disabled><input type='hidden' name='ORIGMOCRD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("REQUEST_DATE")+"'>"+(!b_show?"":"<A id='crd_link_"+cust_po_line_number+"_"+j+"' href='javascript:void(0)'  style='font-size:11px' onclick='gfPop.fPopCalendar(document.MYFORM.MOCRD_"+cust_po_line_number+"_"+j+");return false;'><img name='crd_popcal_"+cust_po_line_number+"_"+j+"' border='0' src='../image/calbtn.gif' width='0'></A>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='SHIPPINGMETHOD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("shipping_method_code")+"' onKeyDown='return (event.keyCode!=8);' readonly><input type='hidden' name='ORIGSHIPPINGMETHOD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("shipping_method_code")+"'>"+ (!b_show?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":"<input type='button' name='SM_"+cust_po_line_number+"_"+j+"' value='..' style='font-size:11px' onClick='subWindowSSDFind("+cust_po_line_number+","+j+")' disabled>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='SSD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("SCHEDULE_SHIP_DATE")+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled><input type='hidden' name='ORIGSSD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("SCHEDULE_SHIP_DATE")+"'>"+(!b_show?"":"<A id='ssd_link_"+cust_po_line_number+"_"+j+"' href='javascript:void(0)' style='font-size:11px' onclick='gfPop.fPopCalendar(document.MYFORM.SSD_"+cust_po_line_number+"_"+j+");return false;'><img name='ssd_popcal_"+cust_po_line_number+"_"+j+"' border='0' src='../image/calbtn.gif' width='0'></A>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='STATUS_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("STATUS")+"' onKeyDown='return (event.keyCode==1);'></A></td>");
							out.println("</tr>");
						}
						rs1.close();
						statement1.close();
						
						if (j>0)
						{
							out.println("</table>");
						}
						out.println("<input type='hidden' name='MO_ROW_CNT_"+cust_po_line_number+"' value='"+j+"'>");
						out.println("</td>");
					%>
					<%
					}
					out.println("<td align='center'><input type='checkbox' class='style5' name='PDNFLAG_"+cust_po_line_number+"_"+po_line_cnt+"' value='Y'></td>");
					out.println("<td align='center'><input type='text' class='style5' name='REMARK_"+cust_po_line_number+"_"+po_line_cnt+"' size='5' value=''></td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();
				
				if (i>0)
				{
					out.println("</table></td></tr>");
				}	
			
			}
			catch(Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}	
			%>
			</table>
		</td>
	</tr>
</table>
<P>
<div align="right"><font style="color:#8F996C">本次處理人員:</font><font style="font-family:Tahoma,Georgia;color:#999933"><%=UserName%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style="color:#8F996C">處理日期:</font><%=dateBean.getYearMonthDay()%></div>
<HR>
<div align="center"><INPUT TYPE="button" name="save" tabindex='41' value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit1()' >
&nbsp;&nbsp;
<INPUT TYPE="button" name="exit" value='離開' onClick='setClose("../jsp/TSCE1214ExceptionQuery.jsp")' >
&nbsp;&nbsp;
<INPUT TYPE="button" name="closed" value='不變更,結案' onClick='setSubmit2()' ></div>
<input type="hidden" name="SYSTEMDATE" value="<%=dateBeans.getYearMonthDay()%>">
<input type="hidden" name="CUSTMARKETGROUP" value="<%=MARKET_GROUP%>">
<input type="hidden" name="PROGRAMNAME" value="ORDCHGCONFIRM">
<input type="hidden" name="DELIVER_TO_ID" value="<%=DELIVER_TO_ID%>">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
