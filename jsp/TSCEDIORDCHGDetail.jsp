<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20160127 Peggy,arrow end customer delphi cust part no-->
<!--20160513 Peggy,for TSC_EDI_PKG.GET_SHIPPING_METHOD新增customer_id而修改-->
<!--20190225 Peggy,add End customer part name-->
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
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 10px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 10px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 10px }
  TD        { font-family: Tahoma,Georgia; font-size: 10px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8;font-size:10px;}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size:10px;}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:10px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;font-size:10px;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia;font-size:10px;}
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
	var fob = document.MYFORM.elements["FOB_"+polineno+"_"+seqno].value; //add by Peggy 20210208
	var deliver_to_id = document.MYFORM.elements["DELIVER_TO_ID_"+polineno+"_"+seqno].value; //add by Peggy 20210208
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var custid = document.MYFORM.ERPCUSTOMERID.value;
	if (odrtype==null || odrtype=="")
	{
		alert("請先選擇訂單資料");
		return false;
	}
	odrtype = odrtype.substr(0,4);

	//subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&custid="+custid+"&fob="+fob.replace("&","\"")+"&deliver_id="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function subWindowSSDFind1(polineno,seqno,objtype)
{    
	var region = document.MYFORM.SALESAREANO.value;
	var crdate = document.MYFORM.elements["CRD_"+polineno+"_"+seqno].value;
	var plant = document.MYFORM.elements["PLANT_"+polineno].value;
	var odrtype = document.MYFORM.elements["ORDERTYPE_"+polineno].value;
	var shippingMethod = document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+seqno].value;
	var fob = document.MYFORM.elements["RFQ_FOB_"+polineno+"_"+seqno].value; //add by Peggy 20210208
	var deliver_to_id = document.MYFORM.elements["RFQ_DELIVER_TO_ID_"+polineno+"_"+seqno].value; //add by Peggy 20210208
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var custid = document.MYFORM.ERPCUSTOMERID.value;
	//subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D90021&LINENO="+polineno+"_"+seqno+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&custid="+custid+"&objtype="+objtype+"&fob="+fob.replace("&","\"")+"&deliver_id="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
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
		document.MYFORM.elements["SPQ_"+polineno].style.backgroundColor ="#E4F3ED";
		document.getElementById("tr_"+polineno).style.backgroundColor ="#E4F3ED";
		//for (var i =0; i <document.getElementsByName("tr_"+polineno).length;i++)
		//{		
		for (var i =0; i <1;i++) 
		{
			document.MYFORM.elements["CRD_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["CRD_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["RFQ_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["RFQ_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["REMARK_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["REMARK_"+polineno+"_"+(i+1)].disabled=false;
			document.MYFORM.elements["RFQSM_"+polineno+"_"+(i+1)].disabled=false;
			document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["RFQ_SSD_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["RFQ_SSD_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["ERPODRSM_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["ERPODR_SHIPMETHOD_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["ERPODR_SHIPMETHOD_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["ERPODR_SSD_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["ERPODR_SSD_"+polineno+"_"+(i+1)].disabled = false;
			document.MYFORM.elements["ERPODR_"+polineno+"_"+(i+1)].style.backgroundColor ="#E4F3ED";
			document.MYFORM.elements["ERPODR_"+polineno+"_"+(i+1)].disabled = false;
		}
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
				document.MYFORM.elements["MOSELLINGPRICE_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["MOCRD_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["SHIPPINGMETHOD_"+polineno+"_"+j].disabled=false;
				document.MYFORM.elements["SSD_"+polineno+"_"+j].disabled=false;
				try
				{
					document.MYFORM.elements["SM_"+polineno+"_"+j].disabled=false;
					document.MYFORM.elements["crd_popcal_"+polineno+"_"+j].width=20;
					document.MYFORM.elements["ssd_popcal_"+polineno+"_"+j].width=20;
				}catch(e){}
			}
		}
	}
	else
	{
		document.MYFORM.elements["MOQ_"+polineno].style.backgroundColor ="#ffffff";
		document.MYFORM.elements["SPQ_"+polineno].style.backgroundColor ="#ffffff";
		document.getElementById("tr_"+polineno).style.backgroundColor ="#ffffff";
		//for (var i =0; i <document.getElementsByName("tr_"+polineno).length;i++)
		for (var i =0; i <1;i++) 
		{
			document.MYFORM.elements["CRD_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["CRD_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["RFQ_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["RFQ_"+polineno+"_"+(i+1)].value="";
			document.MYFORM.elements["RFQ_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["REMARK_"+polineno+"_"+(i+1)].style.backgroundColor ="#FFFFFF";
			document.MYFORM.elements["REMARK_"+polineno+"_"+(i+1)].value="";
			document.MYFORM.elements["REMARK_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["RFQSM_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["RFQ_SHIPMETHOD_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["RFQ_SSD_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["RFQ_SSD_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["ERPODRSM_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["ERPODR_SHIPMETHOD_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["ERPODR_SHIPMETHOD_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["ERPODR_SSD_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["ERPODR_SSD_"+polineno+"_"+(i+1)].disabled = true;
			document.MYFORM.elements["ERPODR_"+polineno+"_"+(i+1)].style.backgroundColor ="#ffffff";
			document.MYFORM.elements["ERPODR_"+polineno+"_"+(i+1)].value="";
		}
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
	var custpolineno="",chkvalue=false;
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
			SELLINGPRICE = document.MYFORM.elements["SELLINGPRICE_"+custpolineno].value
			for (var j =1 ; j <= parseFloat(document.MYFORM.elements["ROW_CNT_"+custpolineno].value) ; j++)
			{
				tot_qty=0;changcnt=0;
				change_crd=document.MYFORM.elements["CRD_"+custpolineno+"_"+j].value;
				change_qty=parseFloat(document.MYFORM.elements["QTY_"+custpolineno+"_"+j].value);
				rfq_qty=document.MYFORM.elements["RFQ_"+custpolineno+"_"+j].value;
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
					
					//add by Peggy 20141128
					if (document.MYFORM.elements["TSCITEM_"+custpolineno].value==null || document.MYFORM.elements["TSCITEM_"+custpolineno].value=="")
					{
						alert("訂單項次"+custpolineno+":此料號尚未建立客戶品號與台半品號關係!!");
						return false;
					}
					
					if ((SPQ ==null || SPQ==0) && (MOQ==null || MOQ==0))
					{
						alert("訂單項次"+custpolineno+":此料號尚未設定SPQ及MOQ,請洽系統管理人員處理!!");
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
					
				for (var k =1 ; k <= parseFloat(document.MYFORM.elements["MO_ROW_CNT_"+custpolineno].value) ; k++)
				{
					var mo_qty = parseFloat(document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].value);
					var orig_mo_qty = parseFloat(document.MYFORM.elements["ORIGMOQTY_"+custpolineno+"_"+k].value);
					var mo_sellingprice = parseFloat(document.MYFORM.elements["MOSELLINGPRICE_"+custpolineno+"_"+k].value);
					var orig_mo_sellingprice = parseFloat(document.MYFORM.elements["ORIGMOSELLINGPRICE_"+custpolineno+"_"+k].value);
					var mo_crd = document.MYFORM.elements["MOCRD_"+custpolineno+"_"+k].value;
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
						tot_qty += parseFloat(document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].value);
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
								alert("項次"+k+":訂單數量必須大於等於MOQ:"+MOQ+"!!");
								document.MYFORM.elements["MOQTY_"+custpolineno+"_"+k].focus();
								return false;
							}
							else if ((mo_qty%SPQ) != 0)
							{
								alert("項次"+k+":訂單數量必為SPQ:"+SPQ+"的倍數!!");
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
	if (confirm("您確定要送出申請嗎?"))
	{
		document.MYFORM.save.disabled=true;
		document.MYFORM.exit.disabled=true;
		document.MYFORM.action="../jsp/TSCEDIMProcess.jsp";
		document.MYFORM.submit();
	}
}
function setCRD(objName)
{
	if (document.MYFORM.elements[objName].value==null || document.MYFORM.elements[objName].value!=document.MYFORM.elements[objName.replace("CRD","ORIG_CRD")].value)
	{
		document.MYFORM.elements[objName.replace("CRD","RFQ_SSD")].value="";
		document.MYFORM.elements[objName.replace("CRD","ERPODR_SSD")].value="";
	}
}

</script>
<%
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID==null) ERPCUSTOMERID="";
	String REQUESTNO = request.getParameter("REQUESTNO");
	if (REQUESTNO==null) REQUESTNO="";
	String VERSIONID = request.getParameter("VERSIONID");
	if (VERSIONID==null) VERSIONID="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	String SALESAREANO = request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String SYSTEMDATE = dateBeans.getYearMonthDay();
	String sql = "",CREATION_DATE="",CREATED_BY="",CUSTNAME="",VERSION_ID="",CUSTOMER_NAME="",MARKET_GROUP="",FOB_POINT="",strNotice="",ERPCUSTOMERID1="",DELIVER_TO_ID="",v_warning="";
	int v_loop_cnt=0;  //add v_loop_cnt by Peggy 20181210
	
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
	
	boolean bNotFound = false;
	
	try
	{
		sql = " select a.*,'('||c.customer_number||')'||c.CUSTOMER_NAME as CUSTNAME,d.SALES_AREA_NO,c.CUSTOMER_NAME,c.ATTRIBUTE2 market_group "+
		      ",e.currency_code currency_code1"+
			  ",'('||f.customer_number||')'||f.CUSTOMER_NAME as CUSTNAME1"+
			  ",e.erp_customer_id erp_customer_id1"+
		      " from tsc_edi_orders_header a"+
			  ",ar_customers c"+
			  ",tsc_edi_customer d "+
			  ",tsc_edi_orders_his_h e"+ //add by Peggy 20201029
			  ",ar_customers f"+
			  " where a.ERP_CUSTOMER_ID= c.customer_id "+
			  " and a.DATA_FLAG=?"+
			  " and e.ERP_CUSTOMER_ID=?"+
			  " and a.CUSTOMER_PO=?"+
			  " and a.ERP_CUSTOMER_ID=d.CUSTOMER_ID"+
			  " and e.request_no=?"+
			  " and a.customer_po=e.customer_po"+
			  " and e.erp_customer_id=f.customer_id"+
			  " and CASE WHEN e.erp_customer_id IN (690290,702294,1071293,1071295) THEN 1 ELSE e.erp_customer_id END=CASE WHEN a.erp_customer_id IN (690290,702294,1071293,1071295) THEN 1 ELSE a.erp_customer_id END";
			  //" and exists (select 1 from tsc_edi_orders_his_d b where b.DATA_FLAG ='N' and b.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID"+
			  //" and b.REQUEST_NO='"+REQUESTNO+"')";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"Y");
		statement.setString(2,ERPCUSTOMERID);
		statement.setString(3,CUSTPO);
		statement.setString(4,REQUESTNO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUSTNAME = rs.getString("CUSTNAME");
			VERSIONID = rs.getString("VERSION_ID");
			CURRENCY = rs.getString("CURRENCY_CODE");
			VERSION_ID = rs.getString("VERSION_ID");
			SALESAREANO = rs.getString("SALES_AREA_NO");
			CUSTOMER_NAME = rs.getString("CUSTOMER_NAME");
			MARKET_GROUP = rs.getString("MARKET_GROUP");
			ERPCUSTOMERID1 = rs.getString("erp_customer_id"); 
			
			if (!rs.getString("currency_code1").equals(rs.getString("currency_code")) || !rs.getString("erp_customer_id1").equals(rs.getString("erp_customer_id")))
			{
				strNotice ="注意:<br>";
				strNotice=strNotice+(!rs.getString("currency_code1").equals(rs.getString("currency_code"))?"幣別變更:"+rs.getString("currency_code")+"=>"+rs.getString("currency_code1"):"")+"<br>";
				strNotice=strNotice+(!rs.getString("erp_customer_id1").equals(rs.getString("erp_customer_id"))?"客戶變更:"+rs.getString("CUSTNAME")+"=>"+rs.getString("CUSTNAME1"):"");
			}
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
			alert("查無資料!!申請單狀態可能不符合條件,請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
	
	try
	{
		//add by Peggy 20190319
		sql = " select b.FOB_POINT"+
              " from hz_cust_acct_sites_all a,hz_cust_site_uses_all b,so_price_lists c"+
              " where a.cust_acct_site_id=b.cust_acct_site_id"+
              " and b.status='A'"+
              " and b.SITE_USE_CODE ='BILL_TO' "+
              " and b.PRICE_LIST_ID = c.PRICE_LIST_ID(+)"+
              " and exists (select 1 from tsc_edi_orders_his_h  teoh"+
              " where teoh.request_no=?"+
              " and teoh.erp_customer_id=?"+
              " and teoh.erp_customer_id=a.cust_account_id"+
              " and teoh.by_code=b.attribute2"+
              " and teoh.currency_code=c.currency_code)";
		PreparedStatement statementb = con.prepareStatement(sql);
		statementb.setString(1,REQUESTNO);
		statementb.setString(2,ERPCUSTOMERID);
		ResultSet rsb=statementb.executeQuery();
		if (rsb.next())
		{	
			FOB_POINT = rsb.getString("FOB_POINT");
		}
		rsb.close();
		statementb.close();				  
	}
	catch(Exception e)
	{
		FOB_POINT="";
	}
	
	try
	{
		//add by Peggy 20210208
		sql = " select b.SITE_USE_ID"+
              " from hz_cust_acct_sites_all a,hz_cust_site_uses_all b,so_price_lists c"+
              " where a.cust_acct_site_id=b.cust_acct_site_id"+
              " and b.status='A'"+
              " and b.SITE_USE_CODE ='DELIVER_TO' "+
              " and b.PRICE_LIST_ID = c.PRICE_LIST_ID(+)"+
              " and exists (select 1 from tsc_edi_orders_his_h  teoh"+
              " where teoh.request_no=?"+
              " and teoh.erp_customer_id=?"+
              " and teoh.erp_customer_id=a.cust_account_id"+
              " and teoh.dp_code=b.attribute2"+
              " and teoh.currency_code=c.currency_code)";
		PreparedStatement statementb = con.prepareStatement(sql);
		statementb.setString(1,REQUESTNO);
		statementb.setString(2,ERPCUSTOMERID);
		ResultSet rsb=statementb.executeQuery();
		if (rsb.next())
		{	
			DELIVER_TO_ID = rsb.getString("SITE_USE_ID");
		}
		rsb.close();
		statementb.close();				  
	}
	catch(Exception e)
	{
		DELIVER_TO_ID="";
	}	
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="TSCEDIORDCHGDetail.jsp" METHOD="post" NAME="MYFORM">
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">TSC</font>
			<font style="font-size:20px;color:#000000;font-family:細明體"><strong>客戶訂單變更確認</strong></font>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="1">
				<tr>
					<td><font style="color:#64B077">客戶訂單明細:</font></td>
					<td align="right"><a href="TSCEDIExceptionQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td bgcolor='#64B077'><font style="color:#ffffff"><jsp:getProperty name="rPH" property="pgCustomerName"/></font></td>
					<td><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" size="40" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"><input type="hidden" name="SALESAREANO" value="<%=SALESAREANO%>"><input type="hidden" name="CUSTOMER_NAME" value="<%=CUSTOMER_NAME%>"></td>
					<td bgcolor='#64B077'><font style="color:#ffffff"><jsp:getProperty name="rPH" property="pgCustPONo"/></font></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff"><jsp:getProperty name="rPH" property="pgCurr"/></font></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
				<%
				if (!strNotice.equals(""))
				{
				%>
				<tr>
					<td colspan="6" style="color:#FF0000"><%=strNotice%></td>
				</tr>
				<%
				}
				%>
			<%
			try
			{
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt1=con.prepareStatement(sql1);
				pstmt1.executeUpdate(); 
				pstmt1.close();
						
				sql = " select a.* ,nvl((select inventory_item from oe_items_v b where b.SOLD_TO_ORG_ID=a.ERP_CUSTOMER_ID "+
				      " and b.item=a.CUST_ITEM_NAME and b.ITEM_DESCRIPTION=a.TSC_ITEM_NAME and b.inventory_item=nvl(a.tsc_item_no,b.inventory_item) and b.CROSS_REF_STATUS='ACTIVE'),(select segment1 from inv.mtl_system_items_b c "+
					  " where c.ORGANIZATION_ID = '49' and c.inventory_item_status_code <> 'Inactive' and c.description =a.TSC_ITEM_NAME and rownum=1)) item_name "+
					  " from tsc_edi_orders_detail a "+
				      " where a.ERP_CUSTOMER_ID= ?"+
					  " and a.CUSTOMER_PO=? "+
					  " and VERSION_ID=? "+
					  " and exists (select 1 from tsc_edi_orders_his_d x"+
					  " where x.DATA_FLAG =? and x.ERP_CUSTOMER_ID=?"+
			          " and x.REQUEST_NO=? and x.cust_po_line_no = a.cust_po_line_no)"+
					  " order by to_number(a.CUST_PO_LINE_NO)";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,ERPCUSTOMERID1);
				statement.setString(2,CUSTPO);
				statement.setString(3,VERSION_ID);
				statement.setString(4,"N");
				statement.setString(5,ERPCUSTOMERID);
				statement.setString(6,REQUESTNO);
				ResultSet rs=statement.executeQuery();
				int i =0;
				while (rs.next())
				{
					if (i==0)
					{
				%>
				<tr>
					<td colspan="6">
						<table align="center" width='100%' border='1' bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bordercolor="#64B077">
							<tr style="color:#64B077">
								<td colspan="9">前次申請明細如下:</td>
							</tr>
							<tr bgcolor='#64B077' style="color:#FFFFFF">
								<td align="center" width="8%"><jsp:getProperty name='rPH' property='pgCustPOLineNo'/></td>
								<td align="center" width="5%">序號</td>
								<td align="center" width="12%"><jsp:getProperty name='rPH' property='pgCustItemNo'/></td>
								<td align="center" width="15%"><jsp:getProperty name="rPH" property='pgTSCAlias'/><jsp:getProperty name='rPH' property='pgPart'/></td>
								<td align="center" width="10%"><jsp:getProperty name='rPH' property='pgTSCAlias'/><jsp:getProperty name='rPH' property='pgItemDesc'/></td>
								<td align="center" width="7%"><jsp:getProperty name='rPH' property='pgQty'/></td>
								<td align="center" width="5%"><jsp:getProperty name='rPH' property='pgUOM'/></td>
								<td align="center" width="7%">Selling Price</td>
								<td align="center" width="8%">CRD</td>
								<td align="center" width="15%">Order Warnning</td>
							</tr>
				<%
					}
					out.println("<tr "+(rs.getString("order_change_notice_flag")!=null && rs.getString("order_change_notice_flag").equals("Y")?" bgcolor='#FFFF66'":"")+">");
					out.println("<td>"+rs.getString("CUST_PO_LINE_NO")+"</td>");
					out.println("<td>"+rs.getString("SEQ_NO")+"</td>");
					out.println("<td>"+(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))+"</td>");
					out.println("<td>"+rs.getString("ITEM_NAME")+"</td>");
					out.println("<td>"+rs.getString("TSC_ITEM_NAME")+"</td>");
					out.println("<td align='right'>"+rs.getString("QUANTITY")+"</td>");
					out.println("<td align='center'>"+rs.getString("UOM")+"</td>");
					out.println("<td align='right'>"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"</td>");
					out.println("<td align='center'>"+rs.getString("CUST_REQUEST_DATE")+"</td>");
					out.println("<td align='center' "+(rs.getString("order_change_notice_flag")!=null&& rs.getString("order_change_notice_flag").equals("Y")?" style='color:#FF0000;font-weight:bold'":"")+">"+(rs.getString("order_change_notice_flag")!=null && rs.getString("order_change_notice_flag").equals("Y")?(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks")):"&nbsp;")+"</td>");
					out.println("</tr>");
					
					i++;
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
<HR>
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td><font style="color:#8F996C">變更申請單號:</font><font style="font-family:Tahoma,Georgia;color:#3333CC"><strong><%=REQUESTNO%></strong></font><input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>"></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#60895F" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr bgcolor="#8F996C" style="color:#FFFFFF">
					<td colspan="10" align="center">訂單變更明細</td>
					<td colspan="7" align="center" bgcolor="#CC6633">處理結果</td>
				</tr>
				<tr bgcolor="#8F996C" style="color:#FFFFFF">
					<td align="center" width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td align="center" width="4%"><jsp:getProperty name='rPH' property='pgCustPOLineNo'/></td>
					<td align="center" width="8%"><jsp:getProperty name='rPH' property='pgCustItemNo'/></td>
					<td align="center" width="8%"><jsp:getProperty name='rPH' property='pgTSCAlias'/><jsp:getProperty name='rPH' property='pgItemDesc'/></td>
					<td align="center" width="6%">TSC Package</td>
					<td align="center" width="6%">End Cust PartNo</td>
					<td align="center" width="4%"><jsp:getProperty name='rPH' property='pgQty'/></td>
					<td align="center" width="3%"><jsp:getProperty name='rPH' property='pgUOM'/></td>
					<td align="center" width="4%">Selling<br>Price</td>
					<td align="center" width="6%">CRD</td>
					<td align="center" width="18%" bgcolor="#CC6633">新訂單/RFQ</td>
					<td align="center" width="34%" bgcolor="#F1D1BE" style="color:#000000">修改訂單/RFQ明細</td>
					<td align="center" width="2%" bgcolor="#CC6633">工程變更註記</td>
					<td align="center" width="5%" bgcolor="#CC6633">備註</td>
				</tr>
			<%
			try
			{
				//add by Peggy 20181210
				sql = " select * from tsc_edi_orders_his_d a"+
				      " where a.REQUEST_NO =?"+
					  " and a.ERP_CUSTOMER_ID =?"+
					  " and a.DATA_FLAG=?"+
					  " and a.ERP_CUSTOMER_ID <>?";
				PreparedStatement statementx = con.prepareStatement(sql);
				statementx.setString(1,REQUESTNO);
				statementx.setString(2,ERPCUSTOMERID);
				statementx.setString(3,"N");
				statementx.setString(4,"1889");  //Schukat非 ON SEMI的客戶, 訂單請不要綁定-ON ,add by Peggy 20210323
				ResultSet rsx=statementx.executeQuery();
				while (rsx.next())
				{	
					v_loop_cnt =1;  
					
					//-ON型號CHECK,add by Peggy 20181210
					while(v_loop_cnt <4)
					{
						//檢查客戶品號是否為-ON型號
						sql = " SELECT DISTINCT msi.DESCRIPTION,a.cust_partno "+
						      " FROM INV.MTL_SYSTEM_ITEMS_B msi,oraddman.ts_label_onsemi_item a"+
							  " WHERE msi.ORGANIZATION_ID=49"+
							  " AND msi.INVENTORY_ITEM_STATUS_CODE<>'Inactive'"+
							  " AND msi.CUSTOMER_ORDER_ENABLED_FLAG='Y'"+
							  " AND msi.INTERNAL_ORDER_ENABLED_FLAG='Y'"+
							  " AND msi.DESCRIPTION LIKE '%-ON %'"+
							  " AND a.TSC_PARTNO LIKE '%-ON'";
						if (v_loop_cnt==1 || v_loop_cnt==2)
						{
							sql += " AND a.CUST_PARTNO=?";
						}
						else if (v_loop_cnt==3)
						{
							sql += " AND a.TSC_PARTNO=?||'-ON'";
						}
						sql += " AND MSI.DESCRIPTION LIKE TSC_PARTNO||'%'";
						PreparedStatement statementc = con.prepareStatement(sql);
						statementc.setString(1,(v_loop_cnt==1?rsx.getString("CUST_ITEM_NAME"):rsx.getString("TSC_ITEM_NAME")));
						ResultSet rsc=statementc.executeQuery();
						if (rsc.next())
						{
							sql = " update tsc_edi_orders_his_d a"+
								  " set TSC_ITEM_NAME =?"+
								  " ,CUST_ITEM_NAME=?"+
								  " where a.erp_customer_id=?"+
								  " and a.REQUEST_NO=?"+
								  " and a.SEQ_NO=?";
							PreparedStatement pstmtDt2=con.prepareStatement(sql);  
							pstmtDt2.setString(1,rsc.getString("description")); 
							pstmtDt2.setString(2,rsc.getString("cust_partno")); 
							pstmtDt2.setString(3,ERPCUSTOMERID); 
							pstmtDt2.setString(4,REQUESTNO);
							pstmtDt2.setString(5,rsx.getString("SEQ_NO")); 
							pstmtDt2.executeUpdate();
							pstmtDt2.close();							
							v_loop_cnt=4;  
						}	  
						rsc.close();
						statementc.close();								
						v_loop_cnt++;	
					}
				}
				rsx.close();
				statementx.close();
							
				sql = " select distinct (select count(1) from tsc_edi_orders_his_d b where b.REQUEST_NO=a.REQUEST_NO and b.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID and b.DATA_FLAG=a.DATA_FLAG and b.CUST_PO_LINE_NO=a.CUST_PO_LINE_NO) rowcnt"+
					  ",a.SEQ_NO"+
					  ",a.CUST_PO_LINE_NO"+
					  //",nvl(a.END_CUSTOMER_ITEM,a.CUST_ITEM_NAME) CUST_ITEM_NAME"+  //add by Peggy 20160127
					  ",a.CUST_ITEM_NAME"+  //add by Peggy 20160127
					  ",a.TSC_ITEM_NAME"+
					  ",decode(a.action_code,'2',0,a.QUANTITY)  QUANTITY"+
					  ",a.UOM"+
					  ",a.UNIT_PRICE"+
					  ",a.CUST_REQUEST_DATE"+
					  ",a.RFQ_QTY"+
					  ",a.dndocno"+
					  ",a.line_no "+
					  ",NVL(b.ATTRIBUTE3,(select attribute3 from inv.mtl_system_items_b c where c.ORGANIZATION_ID = '49' and c.inventory_item_status_code <> 'Inactive' and c.description =a.TSC_ITEM_NAME and rownum=1)) plantcode "+
					  ",TSC_PACKAGE"+
					  ",TSC_FAMILY"+
					  ",TSC_PROD_GROUP"+
					  ",b.segment1"+
					  ",b.ORDER_TYPE"+
					  ",c.quantity orig_qty"+
					  //",(select unit_price  from tsc_edi_orders_detail g where a.customer_po=g.customer_po AND a.erp_customer_id=g.erp_customer_id AND a.cust_po_line_no=g.cust_po_line_no group by unit_price) orig_unit_price"+
					  ",a.unit_price  orig_unit_price"+
					  ",c.cust_request_date orig_crd"+
					  ",a.action_code"+
					  //",d.INVENTORY_ITEM"+    //add by Peggy 20141128
					  ",nvl(d.INVENTORY_ITEM,b.segment1)  INVENTORY_ITEM "+  //modify by Peggy 20180814
					  ",b.inventory_item_id"+ //add by Peggy 20150804
					  ",NVL(a.END_CUSTOMER_ITEM,case when a.ORIG_CUST_ITEM_NAME<>a.CUST_ITEM_NAME then a.ORIG_CUST_ITEM_NAME else null end) as END_CUSTOMER_ITEM  "+  //add by Peggy 20190225
					  ",a.order_change_notice_flag ordchg_warnning"+ //add by Peggy 20190408
					  ",a.order_remarks"+            //add by Peggy 20190408
					  ",a.cancel_flag"+              //add by Peggy 20190408
					  ",TSC_EDI_PKG.GET_ONSEMI_ONHAND(b.inventory_item_id,null) onhand_qty"+ //add by Peggy 20190520
					  ",case when a.action_code='1' then case when TSC_EDI_PKG.GET_ONSEMI_ONHAND(b.inventory_item_id,null) >= decode(a.action_code,'2',0,a.QUANTITY) then decode(a.action_code,'2',0,a.QUANTITY) else TSC_EDI_PKG.GET_ONSEMI_ONHAND(b.inventory_item_id,null) end else 0 end as mo_qty"+ 
					  ",case when a.action_code='1' then case when TSC_EDI_PKG.GET_ONSEMI_ONHAND(b.inventory_item_id,null) >= decode(a.action_code,'2',0,a.QUANTITY) then 0 else decode(a.action_code,'2',0,a.QUANTITY)- TSC_EDI_PKG.GET_ONSEMI_ONHAND(b.inventory_item_id,null) end else 0 end as rfq_qty"+ 
					  " from (select  ROW_NUMBER () over (partition by x.REQUEST_NO,x.erp_customer_id,x.CUST_PO_LINE_NO order by x.CUST_REQUEST_DATE ) seq_no1,x.*,"+ //modify by Peggy20140618
					  "                nvl(z.inventory_item_id,case when x.TSC_ITEM_NAME<>nvl(x.END_CUSTOMER_ITEM,x.CUST_ITEM_NAME) then (SELECT INVENTORY_ITEM_ID FROM oe_items_v a where a.ITEM_DESCRIPTION=x.TSC_ITEM_NAME and a.ITEM = nvl(x.END_CUSTOMER_ITEM,x.CUST_ITEM_NAME) AND a.SOLD_TO_ORG_ID =x.ERP_CUSTOMER_ID AND a.INVENTORY_ITEM=NVL( x.TSC_ITEM_NO,a.INVENTORY_ITEM) and rownum=1) else (select inventory_item_id from mtl_system_items_b a where a.organization_id=49 and a.description =x.TSC_ITEM_NAME and a.INVENTORY_ITEM_STATUS_CODE <>'Inactive' and rownum=1) end) as inventory_item_id"+ //modify by Peggy 20140702
			          "               ,nvl(teod.order_change_notice_flag,'N') order_change_notice_flag, teod.remarks order_remarks,teod.data_flag cancel_flag "+
		 			  "               from (select y.customer_po,x.* from tsc_edi_orders_his_d x, tsc_edi_orders_his_h y where x.erp_customer_id=y.erp_customer_id AND x.request_no=y.request_no) x,oraddman.tsdelivery_notice_detail z,tsc_edi_orders_detail teod where x.dndocno=z.dndocno(+) and x.line_no=z.line_no(+) and teod.erp_customer_id(+)=x.erp_customer_id and teod.customer_po(+) =x.customer_po and teod.cust_po_line_no(+)=x.cust_po_line_no and teod.seq_no(+)=x.seq_no) a"+
					  ",(select  c.inventory_item_id, c.ATTRIBUTE3,c.segment1,c.description item_description"+
					  "          ,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
					  "          ,NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
					  "          ,CASE WHEN NVL(c.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,c.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(c.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
					  //"          ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (c.attribute3) AS ORDER_TYPE"+
					  "          ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (c.INVENTORY_ITEM_ID) AS ORDER_TYPE"+   //modify by Peggy 20191122
					  " from inv.mtl_system_items_b c "+
					  " ,oraddman.tsprod_manufactory d"+ //by Peggy 20151209
					  " where c.ORGANIZATION_ID = '49'"+
					  " and c.attribute3=d.MANUFACTORY_NO(+)) b"+
					  ",(select k.*,substr(seq_no,instr(seq_no,'.')+1,length(seq_no)-instr(seq_no,'.')+1) seq_no1 from tsc_edi_orders_detail k) c"+
					  ",(SELECT * FROM oe_items_v WHERE  ITEM_STATUS='ACTIVE' AND CROSS_REF_STATUS='ACTIVE') d"+ //add by Peggy 20141128
					  " where a.REQUEST_NO =?"+
					  " and a.ERP_CUSTOMER_ID =?"+
					  " and a.DATA_FLAG=?"+
					  " and b.inventory_item_id(+)=a.inventory_item_id"+
					  " AND a.customer_po=c.customer_po(+)"+
					  " AND a.erp_customer_id=c.erp_customer_id(+)"+
					  " AND a.cust_po_line_no=c.cust_po_line_no(+)"+
					  " AND a.seq_no1 =  c.seq_no1(+)"+//add by Peggy 20140618
					  " AND nvl(a.END_CUSTOMER_ITEM,a.cust_item_name)= d.item(+)"+
					  " AND a.tsc_item_name = d.item_description(+)"+
					  " AND a.TSC_ITEM_NO=d.inventory_item(+)"+ //add by Peggy 20180717
					  " AND a.erp_customer_id =d.sold_to_org_id(+)"+
					  //" AND a.cust_request_date=c.cust_request_date(+)"+
					  " order by a.CUST_PO_LINE_NO,a.SEQ_NO";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,REQUESTNO);
				statement.setString(2,ERPCUSTOMERID);
				statement.setString(3,"N");
				ResultSet rs=statement.executeQuery();
				int polineno=0,i =0,rowcnt=0,po_line_cnt=0;
				String cust_po_line_number="",SPQ="",MOQ="",SHIPPING_METHOD="",PLANT_CODE="",ORDER_TYPE="",SSD="";
				while (rs.next())
				{
					PLANT_CODE = rs.getString("plantcode");
					ORDER_TYPE = rs.getString("ORDER_TYPE");
					if ((SALESAREANO.equals("001") && rs.getString("TSC_PACKAGE") != null && rs.getString("TSC_PACKAGE").equals("SMA")) || MARKET_GROUP.equals("AU"))
					{
						PLANT_CODE ="002";
						ORDER_TYPE ="1156";
					}
					
					//modify by Peggy 20150721
					CallableStatement cse = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?)}");
					cse.setString(1,rs.getString("INVENTORY_ITEM_ID"));
					cse.setString(2,PLANT_CODE);      
					cse.registerOutParameter(3, Types.VARCHAR);  
					cse.registerOutParameter(4, Types.VARCHAR);  
					cse.execute();
					SPQ = cse.getString(3);                     
					MOQ = cse.getString(4); 
					cse.close();

					i++;
					out.println("<tr id='tr_"+rs.getString("CUST_PO_LINE_NO")+"'>");
					if (!cust_po_line_number.equals(rs.getString("CUST_PO_LINE_NO")))
					{
						po_line_cnt=0;
						polineno ++;
						cust_po_line_number =rs.getString("CUST_PO_LINE_NO");
						rowcnt = Integer.parseInt(rs.getString("rowcnt"));
						out.println("<td rowspan="+rowcnt+"><input type='checkbox' name='CHKBOX' value='"+rs.getString("CUST_PO_LINE_NO")+"' onclick=setCheck('"+rs.getString("CUST_PO_LINE_NO")+"','"+polineno+"');><input type='hidden' name='ROW_CNT_"+cust_po_line_number+"' value='"+rowcnt+"'></td>");
						out.println("<td rowspan="+rowcnt+" align='center'>"+rs.getString("CUST_PO_LINE_NO")+"</td>");
						out.println("<td rowspan="+rowcnt+">"+(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))+"<input type='hidden' name='PLANT_"+cust_po_line_number+"' value='"+PLANT_CODE+"'><input type='hidden' name='ORDERTYPE_"+cust_po_line_number+"' value='"+ORDER_TYPE+"'><input type='hidden' name='TSCITEM_"+cust_po_line_number+"' value='"+(rs.getString("INVENTORY_ITEM")==null?"":rs.getString("INVENTORY_ITEM"))+"'><input type='hidden' name='ORDCHG_WARNNING_"+cust_po_line_number+"' value='"+rs.getString("ordchg_warnning")+"'><input type='hidden' name='ORDER_REMARKS_"+cust_po_line_number+"' value='"+rs.getString("order_remarks")+"'><input type='hidden' name='CANCEL_FLAG_"+cust_po_line_number+"' value='"+rs.getString("cancel_flag")+"'></td>");
						out.println("<td rowspan="+rowcnt+">"+rs.getString("TSC_ITEM_NAME")+"<input type='hidden' name='ITEM_DESC_"+cust_po_line_number+"' value='"+rs.getString("TSC_ITEM_NAME")+"'><br><font class='style2'><font color='blue'><strong>MOQ:</strong></font><input type='text' class='style4' style='text-align:right;' name='MOQ_"+cust_po_line_number+"' value='"+MOQ+"' size='4' onKeyDown='return (event.keyCode!=8);' readonly ><br><font class='style2'><font color='blue'><strong>SPQ:</strong></font><input type='text' name='SPQ_"+cust_po_line_number+"' value='"+SPQ+"' class='style4' style='text-align:right;' size='4' readonly><input type='hidden' name='SELLINGPRICE_"+cust_po_line_number+"' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"'></td>");
						if (rs.getString("TSC_PACKAGE")!=null && (rs.getString("TSC_PACKAGE").equals("Matrix SMB") || rs.getString("TSC_PACKAGE").equals("Matrix SMC") || rs.getString("TSC_PACKAGE").equals("SOD-123W") || rs.getString("TSC_PACKAGE").equals("Micro SMA")))
						{
							v_warning=" style='background-color:#FF99CC'";
						}
						else
						{
							v_warning="";
						}
						out.println("<td rowspan="+rowcnt+" align='center'"+ v_warning+">"+rs.getString("TSC_PACKAGE")+"</td>"); //add by Peggy 20210317
						out.println("<td rowspan="+rowcnt+">"+(rs.getString("END_CUSTOMER_ITEM")==null?"&nbsp;":rs.getString("END_CUSTOMER_ITEM"))+"</td>");
						po_line_cnt++;
					}
					else
					{
						rowcnt=0;
						po_line_cnt++;
					}
					out.println("<td align='center'>"+(!rs.getString("QUANTITY").equals(rs.getString("ORIG_QTY"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("QUANTITY")))+"</FONT>");
					out.println("<input type='hidden' name='QTY_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+rs.getString("QUANTITY")+"'><input type='hidden' name='SEQ_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+rs.getString("SEQ_NO")+"'></td>");
					out.println("<td align='center'>"+rs.getString("UOM")+"</td>");
					out.println("<td align='center'>"+(!rs.getString("UNIT_PRICE").equals(rs.getString("ORIG_UNIT_PRICE"))?"<font style='font-weight:bold;color:ff0000'>":"<font style='color:000000'>")+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"</FONT></td>");
					out.println("<td align='center'><input type='text' class='style2' name='CRD_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+rs.getString("CUST_REQUEST_DATE")+"' size='8' onKeypress='return event.keyCode >= 48 && event.keyCode <=57' "+(!rs.getString("CUST_REQUEST_DATE").equals(rs.getString("ORIG_CRD"))?" style='font-weight:bold;color:ff0000'":"style='color:000000'")+"  onBlur='setCRD("+'"'+"CRD_"+cust_po_line_number+"_"+po_line_cnt+'"'+")' disabled><br><input type='hidden' name='ORIG_CRD_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+rs.getString("CUST_REQUEST_DATE")+"'></td>");
					v_loop_cnt=0;
					while (v_loop_cnt <2)
					{
						v_loop_cnt++;
						//modify by Peggy 20150721
						//CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?)}");
						CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}"); //modify by Peggy 20160513
						csf.setString(1,SALESAREANO);
						csf.setString(2,rs.getString("TSC_PACKAGE"));      
						csf.setString(3,rs.getString("TSC_FAMILY"));                   
						csf.setString(4,rs.getString("TSC_ITEM_NAME"));    
						csf.setString(5,rs.getString("CUST_REQUEST_DATE"));   
						csf.registerOutParameter(6, Types.VARCHAR);  
						csf.setString(7,(v_loop_cnt==1?ORDER_TYPE:"1215"));   
						csf.setString(8,PLANT_CODE);   
						csf.setString(9,ERPCUSTOMERID);  //add by Peggy 20160513   
						csf.setString(10,FOB_POINT);     //add by Peggy 20190319
						csf.setString(11,DELIVER_TO_ID);            //add by Peggy 20190319
						csf.execute();
						SHIPPING_METHOD = csf.getString(6);                
						csf.close();						
	
						CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
						csg.setString(1,SALESAREANO);
						csg.setString(2,PLANT_CODE);      
						csg.setString(3,rs.getString("CUST_REQUEST_DATE"));                   
						csg.setString(4,SHIPPING_METHOD);    
						csg.setString(5,(v_loop_cnt==1?ORDER_TYPE:"1215"));   
						csg.registerOutParameter(6, Types.VARCHAR);  
						csg.setString(7,ERPCUSTOMERID);  //add by Peggy 20210207  
						csg.setString(8,FOB_POINT);  //add by Peggy 20210208 
						csg.setString(9,DELIVER_TO_ID);  //add by Peggy 20210208 
						csg.execute();
						SSD = (csg.getString(6)==null?"":csg.getString(6));                
						csg.close();
				
						
						if (v_loop_cnt ==1)
						{
							out.println("<td><table width='100%' border='1' bordercolorlight='#60895F' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0' bordercolor='#CCcccc'>");
							out.println("<tr style='color:#FFFFFF' bgcolor='#CC6633'><td>類型</td><td>出貨方式</td><td>SSD</td><td>數量</td></tr>");
							out.println("<tr><td>RFQ</td>");
							out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='RFQ_SHIPMETHOD_"+cust_po_line_number+"_"+po_line_cnt+"' size='3' value='"+SHIPPING_METHOD+"' "+((rs.getString("DNDOCNO")!=null && rs.getString("DNDOCNO")!="")?" onKeyDown='return (event.keyCode!=8);' readonly":" readonly ")+"><input type='button' name='RFQSM_"+cust_po_line_number+"_"+po_line_cnt+"' value='..' style='font-size:10px' onClick='subWindowSSDFind1("+'"'+cust_po_line_number+'"'+","+'"'+po_line_cnt+'"'+","+'"'+"RFQ"+'"'+")' disabled><input type='hidden' name='RFQ_FOB_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+FOB_POINT+"'><input type='hidden' name='RFQ_DELIVER_TO_ID_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+DELIVER_TO_ID+"'></td>");
							out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='RFQ_SSD_"+cust_po_line_number+"_"+po_line_cnt+"' size='5' value='"+SSD+"' "+((rs.getString("DNDOCNO")!=null && rs.getString("DNDOCNO")!="")?" onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled></td>");
							out.println("<td align='left'><input type='text' class='style4' style='text-align:right;' name='RFQ_"+cust_po_line_number+"_"+po_line_cnt+"' size='3'" +((rs.getString("ACTION_CODE").equals("1") && (rs.getString("DNDOCNO")==null || rs.getString("DNDOCNO").equals("")))?" value='"+ (new DecimalFormat("####0.#####")).format(rs.getFloat("rfq_qty"))+"'":" value=''") +((rs.getString("DNDOCNO")!=null && rs.getString("DNDOCNO")!="")?" onKeyDown='return (event.keyCode!=8);' readonly ":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled></td></tr>");
						}
						else 
						{			
							out.println("<tr><td>1215</td>");
							out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='ERPODR_SHIPMETHOD_"+cust_po_line_number+"_"+po_line_cnt+"' size='3' value='"+SHIPPING_METHOD+"'><input type='button' name='ERPODRSM_"+cust_po_line_number+"_"+po_line_cnt+"' value='..' style='font-size:10px' onClick='subWindowSSDFind1("+'"'+cust_po_line_number+'"'+","+'"'+po_line_cnt+'"'+","+'"'+"ERPODR"+'"'+")' disabled><input type='hidden' name='ERPODR_FOB_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+FOB_POINT+"'><input type='hidden' name='ERPODR_DELIVER_TO_ID_"+cust_po_line_number+"_"+po_line_cnt+"' value='"+DELIVER_TO_ID+"'></td>");
							out.println("<td align='center'><input type='text' class='style2' style='text-align:left;' name='ERPODR_SSD_"+cust_po_line_number+"_"+po_line_cnt+"' size='5' value='"+SSD+"' onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled></td>");
							out.println("<td align='left'><input type='text' class='style4' style='text-align:right;' name='ERPODR_"+cust_po_line_number+"_"+po_line_cnt+"' size='3'" +(rs.getString("ACTION_CODE").equals("1")?" value='"+ (new DecimalFormat("####0.#####")).format(rs.getFloat("mo_qty"))+"'":" value=''") +" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled><br><font class='style2'><font color='blue'><strong>Stock:"+rs.getString("onhand_qty")+"</strong></font></td></tr></table></td>");
						}
					}
						
					if (rowcnt>0)
					{
						out.println("<td rowspan="+rowcnt+" align='center' valign='top'>");
						sql = " select '1','MO' TYPE,to_char(b.order_number) requestno,line_number||'.'||a.shipment_number line_no,a.ordered_quantity,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyymmdd') REQUEST_DATE,to_char( a.SCHEDULE_SHIP_DATE,'yyyymmdd')  SCHEDULE_SHIP_DATE,a.line_number,a.shipment_number,a.FLOW_STATUS_CODE status,a.UNIT_SELLING_PRICE SELLING_PRICE "+
					          ",lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806		
							  ",a.fob_point_code fob_point"+ //add by Peggy 20210207	
							  ",a.deliver_to_org_id"+        //add by Peggy 20210208				  
							  " from ont.oe_order_lines_all a"+
							  ",ont.oe_order_headers_all b "+
							  ",(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+
							  " where b.SOLD_TO_ORG_ID=?"+
							  " and a.customer_line_number=?"+
							  " and nvl(a.customer_shipment_number,decode(b.SOLD_TO_ORG_ID,'7147','1',''))=?"+
							  " and a.header_id=b.header_id"+
							  " and a.ordered_quantity>0"+
							  " and a.FLOW_STATUS_CODE <>'CANCELLED'"+
					          " and a.shipping_method_code = lc.lookup_code (+)"+ //add by Peggy 20200806
							  " union all"+
							  " select '2','RFQ' TYPE,a.dndocno requestno,to_char(a.line_no) line_no,a.quantity*1000 ordered_quantity,a.shipping_method,a.CUST_REQUEST_DATE REQUEST_DATE,substr(a.REQUEST_DATE,1,8) SCHEDULE_SHIP_DATE,line_no line_number,0 shipment_number ,a.LSTATUS  status,a.SELLING_PRICE"+
					          ",lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806	
							  ",nvl(a.fob,b.fob_point) fob_point"+	 //add by Peggy 20210207	
							  ",b.DELIVERY_TO_ORG deliver_to_org_id"+ //add by Peggy 20210208					  
							  " from oraddman.tsdelivery_notice_detail a"+
							  ",oraddman.tsdelivery_notice b"+
							  ",(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+
							  " where a.dndocno = b.dndocno"+
							  " and b.TSCUSTOMERID=?"+
							  " and a.CUST_PO_NUMBER =?"+
							  " and a.CUST_PO_LINE_NO=?"+
							  " and (ORDERNO is null or ORDERNO ='N/A')"+
							  " and a.LSTATUSID not in ('001','010','012')"+
							  "	and a.shipping_method = lc.lookup_code (+)"+ //add by Peggy 20200806
							  " order by 1,7,3,4 ";
						//out.println(sql);
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,ERPCUSTOMERID1);
						statement1.setString(2,CUSTPO);
						statement1.setString(3,rs.getString("CUST_PO_LINE_NO"));
						statement1.setString(4,ERPCUSTOMERID1);
						statement1.setString(5,CUSTPO);
						statement1.setString(6,rs.getString("CUST_PO_LINE_NO"));
						ResultSet rs1=statement1.executeQuery();
						int j=0;
						boolean b_show = true;
						while (rs1.next())
						{
							j++;
							if (j==1)
							{
								out.println("<table width='70%' border='1' bordercolorlight='#60895F' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0' bordercolor='#cccccc'>");
								out.println("<tr bgcolor='#F1D1BE' style='color:#000000'>");
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
							out.println("<td align='center'><input type='text' style='text-align:left' class='style2' name='MO_"+cust_po_line_number+"_"+j+"' size='10' value='"+rs1.getString("requestno")+"' onKeyDown='return (event.keyCode!=8);' readonly><input type='hidden' name='NO_TYPE_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("TYPE")+"'></td>");
							out.println("<td align='center'><input type='text' style='text-align:center' class='style2' name='MOLINE_"+cust_po_line_number+"_"+j+"' size='3' value='"+rs1.getString("line_no")+"' onKeyDown='return (event.keyCode!=8);' readonly></td>");
							out.println("<td align='center'><input type='text' style='text-align:right'  class='style4' name='MOQTY_"+cust_po_line_number+"_"+j+"' size='5' value='"+rs1.getString("ordered_quantity")+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled><input type='hidden' name='ORIGMOQTY_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("ordered_quantity")+"'></td>");
							out.println("<td align='center'><input type='text' style='text-align:right'  class='style4' name='MOSELLINGPRICE_"+cust_po_line_number+"_"+j+"' size='6' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)' disabled><input type='hidden' name='ORIGMOSELLINGPRICE_"+cust_po_line_number+"_"+j+"' value='"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs1.getString("SELLING_PRICE")))+"'><input type='hidden' name='FOB_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("FOB_POINT")+"'><input type='hidden' name='DELIVER_TO_ID_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("DELIVER_TO_ORG_ID")+"'></td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='MOCRD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("REQUEST_DATE")+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='subWindowCRD("+cust_po_line_number+","+j+")' disabled><input type='hidden' name='ORIGMOCRD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("REQUEST_DATE")+"'>"+(!b_show?"":"<A id='crd_link_"+cust_po_line_number+"_"+j+"' href='javascript:void(0)'  style='font-size:10px' onclick='gfPop.fPopCalendar(document.MYFORM.MOCRD_"+cust_po_line_number+"_"+j+");return false;'><img name='crd_popcal_"+cust_po_line_number+"_"+j+"' border='0' src='../image/calbtn.gif' width='0'></A>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='SHIPPINGMETHOD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("shipping_method_name")+"' onKeyDown='return (event.keyCode!=8);' readonly><input type='hidden' name='ORIGSHIPPINGMETHOD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("shipping_method_name")+"'>"+ (!b_show?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":"<input type='button' name='SM_"+cust_po_line_number+"_"+j+"' value='..' style='font-size:10px' onClick='subWindowSSDFind("+'"'+cust_po_line_number+'"'+","+'"'+j+'"'+")' disabled>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='SSD_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("SCHEDULE_SHIP_DATE")+"'"+ (!b_show?"onKeyDown='return (event.keyCode!=8);' readonly":"")+" onKeypress='return event.keyCode >= 48 && event.keyCode <=57' disabled><input type='hidden' name='ORIGSSD_"+cust_po_line_number+"_"+j+"' value='"+rs1.getString("SCHEDULE_SHIP_DATE")+"'>"+(!b_show?"":"<A id='ssd_link_"+cust_po_line_number+"_"+j+"' href='javascript:void(0)' style='font-size:10px' onclick='gfPop.fPopCalendar(document.MYFORM.SSD_"+cust_po_line_number+"_"+j+");return false;'><img name='ssd_popcal_"+cust_po_line_number+"_"+j+"' border='0' src='../image/calbtn.gif' width='0'></A>")+"</td>");
							out.println("<td align='left'><input type='text' style='text-align:center' class='style2' name='STATUS_"+cust_po_line_number+"_"+j+"' size='6' value='"+rs1.getString("STATUS")+"' onKeyDown='return (event.keyCode!=8);' readonly></A></td>");
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
				out.println("Exception3:"+e.getMessage());
			}	
			%>
			</table>
		</td>
	</tr>
</table>
<P>
<div align="right"><font style="color:#8F996C">本次處理人員:</font><font style="font-family:Tahoma,Georgia;color:#999933"><%=UserName%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font style="color:#8F996C">處理日期:</font><%=dateBean.getYearMonthDay()%></div>
<HR>
<div align="center">
<%
//if (strNotice.equals(""))
//{
%>
<INPUT TYPE="button" name="save" tabindex='41' value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit1()' >
<%
//}
%>
&nbsp;&nbsp;<INPUT TYPE="button" name="exit" value='離開' onClick='setClose("../jsp/TSCEDIExceptionQuery.jsp")' ></div>
<input type="hidden" name="SYSTEMDATE" value="<%=dateBeans.getYearMonthDay()%>">
<input type="hidden" name="CUSTMARKETGROUP" value="<%=MARKET_GROUP%>">
<input type="hidden" name="PROGRAMNAME" value="ORDCHGCONFIRM">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
