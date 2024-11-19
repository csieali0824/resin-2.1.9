<!--20150625 Peggy,qp_secu_list_headers_v change to qp_list_headers_v -->
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
<title>TSCE RFQ Confirm</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#D1EAF1}
  .style2   {font-family:Tahoma,Georgia;border:none}
  .style3   {font-family:Tahoma,Georgia;color:#0000CC;font-size:14px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function chkall()
{
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.CHKBOX.length ;i++)
		{
			document.MYFORM.CHKBOX[i].checked= document.MYFORM.CHKBOXALL.checked;
		}
	}
	else
	{
		document.MYFORM.CHKBOX.checked = document.MYFORM.CHKBOXALL.checked;
	}
}
function subWindowPayTermFind(primaryFlag)
{	    
	subWin=window.open("../jsp/subwindow/TSDRQPaymentTermFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D11001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function subWindowFOBPointFind(lineNo,primaryFlag,fieldType)
{    
	subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&FUNC=D11001&FTYPE="+fieldType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function subWindowShipToContactFind()
{    
	var CUSTOMERID=document.MYFORM.ERPCUSTOMERID.value;
	var customerName=document.MYFORM.CUSTOMER_NAME.value;
	var SHIPTOCONTACT=document.MYFORM.SHIPTOCONTACTID.value;
	subWin=window.open("../jsp/subwindow/TscShipToContact.jsp?PROGRAMID=D11001&CUSTOMERNUMBER="+CUSTOMERID+"&CUSTOMERNAME="+customerName+"&SHIPTOCONTACT="+SHIPTOCONTACT,"subwin","top=200,left=400,width=550,height=300,scrollbars=yes,menubar=no"); 
}	
//function subWindowTaxCodeFind()
//{	    
//	subWin=window.open("../jsp/subwindow/TSDRQTaxCodeFind.jsp","subwin","width=500,height=480,scrollbars=yes,menubar=no");  
//} 
function subWindowShipToFind(siteUseCode,customerID,shipToOrg,salesAreaNo)
{   
	if (salesAreaNo == null || salesAreaNo =="")
	{
		alert("請先選擇業務區域!!");
		return false;
	}

	if (customerID == null || customerID =="")
	{
		alert("請先選擇客戶!!");
		return false;
	}
		
	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo+"&FUNC=D11001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function subWindowCustItemFind(LINENO,CUSTOMERID,TSCITEMDESC,CUSTITEMDESC)
{
	if (CUSTOMERID == null || CUSTOMERID =="")
	{
		alert("客戶不可空白!");
		return false;
	}
	if ((TSCITEMDESC == null || TSCITEMDESC == "") && (CUSTITEMDESC == null || CUSTITEMDESC == ""))
	{
		alert("台半料號或客戶品號不可空白!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSDRQCustomerItemFind.jsp?PROGID=D11001&LINENO="+LINENO+"&INVDESC="+TSCITEMDESC+"&CUSTOMERID="+CUSTOMERID+"&CUSTITEM="+CUSTITEMDESC,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function subWindowItemFind(LineNO,invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,orderType,marketGroup,CRD,customerID,deliverid)
{  
	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?LINENO="+LineNO+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D11001&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&MARKETGROUP="+marketGroup+"&CRD="+CRD+"&CUSTOMERID="+customerID+"&deliverid="+deliverid,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function subWindowSSDFind(lineNo,sKind,plant,lineFob,custid)
{    
	var itemdesc = document.MYFORM.elements["TSC_ITEM_DESC_"+lineNo].value;
	var crdate = document.MYFORM.elements["CRD_"+lineNo].value;
	var odrtype = document.MYFORM.elements["ORDER_TYPE_"+lineNo].value; 
	var region = document.MYFORM.SALESAREANO.value;
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var shippingMethod = document.MYFORM.elements["SHIPPINGMETHOD_"+lineNo].value;
	var SSDate = document.MYFORM.elements["SSD_"+lineNo].value;
	var deliver_to_id=document.MYFORM.DELIVERYTOID.value;
	if (sKind == "1")
	{
		shippingMethod = "";
		if (itemdesc =="" || itemdesc == null)
		{
			alert("Please input the item !!! ");
			document.MYFORM.elements["TSC_ITEM_DESC_"+lineNo].focus();
			return false;
		}
	
		if (odrtype == "--" || odrtype == ""  || odrtype == null)
		{
			alert("Please choice the Order Type !!! ");
			document.MYFORM.elements["ORDER_TYPE_"+lineNo].focus();
			return false;
		}
	
		if (crdate=="" || crdate==null)
		{
			alert("Please input a value on CRD field !!! ");
			document.MYFORM.elements["CRD_"+lineNo].focus();
			return false;
		}
		if (crdate.length!= 8)
		{
			alert("The format of CRD field must be yyyymmdd !!! ");
			document.MYFORM.elements["CRD_"+lineNo].focus();
			return false;
		}	
		else
		{
			var year = crdate.substring(0,4);
			var mon = crdate.substring(4,6);
			var dd = crdate.substring(6,8);
			if (year.substring(0,1) != 2)
			{
				alert("The year is invalid on CRD field!!! ");
				document.MYFORM.elements["CRD_"+lineNo].focus();
				return false;
			}
			else if (mon <1 || mon>12)
			{
				alert("The month is invalid on CRD field!!! ");
				document.MYFORM.elements["CRD_"+lineNo].focus();
				return false;
			}
			else if (dd <1 || dd>31)
			{
				alert("The date is invalid on CRD field!!! ");
				document.MYFORM.elements["CRD_"+lineNo].focus();
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
					document.MYFORM.elements["CRD_"+lineNo].focus();
					return false;
				}
			}
		}
		if (plant=="" || plant==null)
		{
			alert("請選擇生產廠區!!");
			document.MYFORM.elements["PLANTCODE_"+lineNo].focus();
			return false;
		}
		if (lineFob=="" || lineFob==null)
		{
			alert("請選擇INCOTERM!!");
			document.MYFORM.elements["LINE_FOB_"+lineNo].focus();
			return false;
		}		
		subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D11001&LINENO="+lineNo+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&fob="+lineFob.replace("&","\"")+"&deliverid="+deliver_to_id+"&custid="+custid,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
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
function subWindowOrderTypeFind(lineNo,primaryFlag,salesAreaNo,plantCode)
{	
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
	subWin=window.open("../jsp/subwindow/TSDRQOrderTypeFind.jsp?PROGID=D11001&LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&MANUFACTORY="+plantCode,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function subWindowLineTypeFind(lineNo,primaryFlag,salesAreaNo,orderType)
{	    
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
	subWin=window.open("../jsp/subwindow/TSDRQLineTypeFind.jsp?PROGID=D11001&LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&orderType="+orderType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 
function subWindowPlantFind(lineNo,primaryFlag)
{
	subWin=window.open("../jsp/subwindow/TSDRQPlantCodeFind.jsp?LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}

function setSubmit(URL)
{
    if (document.MYFORM.SALESAREANO.value==null || document.MYFORM.SALESAREANO.value=="")
	{
		alert("業務區域不可空白!!");
		return false;
	}
    if (document.MYFORM.CUSTPO.value==null || document.MYFORM.CUSTPO.value=="")
	{
		alert("客戶訂單號碼不可空白!!");
		return false;
	}
    if (document.MYFORM.ERPCUSTOMERID.value==null || document.MYFORM.ERPCUSTOMERID.value=="")
	{
		alert("客戶不可空白!!");
		return false;
	}
    if (document.MYFORM.CURRENCY.value==null || document.MYFORM.CURRENCY.value=="")
	{
		alert("幣別不可空白!!");
		return false;
	}
    if (document.MYFORM.PAYTERMID.value==null || document.MYFORM.PAYTERMID.value=="")
	{
		alert("付款條件不可空白!!");
		return false;
	}
    if (document.MYFORM.SHIPTOID.value==null || document.MYFORM.SHIPTOID.value=="")
	{
		alert("出貨地不可空白!!");
		return false;
	}
    if (document.MYFORM.FOB.value==null || document.MYFORM.FOB.value=="")
	{
		alert("FOB不可空白!!");
		return false;
	}
    //if (document.MYFORM.TAXCODE.value==null || document.MYFORM.TAXCODE.value=="")
	//{
	//	alert("Tax Code不可空白!!");
	//	return false;
	//}
    if (document.MYFORM.BILLTOID.value==null || document.MYFORM.BILLTOID.value=="")
	{
		alert("發票地不可空白!!");
		return false;
	}
    if (document.MYFORM.SHIPTOCONTACTID.value==null || document.MYFORM.SHIPTOCONTACTID.value=="")
	{
		alert("ship to contact不可空白!!");
		return false;
	}
    if (document.MYFORM.DELIVERYTOID.value==null || document.MYFORM.DELIVERYTOID.value=="")
	{
		alert("交貨地不可空白!!");
		return false;
	}
	if (document.MYFORM.PRICELIST.value==null || document.MYFORM.PRICELIST.value=="")
	{
		alert("價格表不可空白!!");
		return false;
	}
	var iLen = document.MYFORM.MAXLINE.value;
	var LineNo = "";
	var chkvalue = false;
	var chkcnt =0;
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		iLen = document.MYFORM.CHKBOX.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.CHKBOX.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i-1].checked 
		}
		if (chkvalue==true)
		{
			chkcnt ++;
			LineNo = document.MYFORM.elements["LINE_NO_"+i].value;
			if (document.MYFORM.elements["CUST_PO_LINE_NO_"+i].value==null || document.MYFORM.elements["CUST_PO_LINE_NO_"+i].value=="")
			{
				alert("行號"+LineNo+":客戶訂單項次不可空白!!");
				document.MYFORM.elements["CUST_PO_LINE_NO_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["CUST_ITEM_ID_"+i].value==null || document.MYFORM.elements["CUST_ITEM_ID_"+i].value=="")
			{
				alert("行號"+LineNo+":客戶品號不可空白!!");
				document.MYFORM.elements["CUST_ITEM_ID_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["TSC_ITEM_ID_"+i].value==null || document.MYFORM.elements["TSC_ITEM_ID_"+i].value=="")
			{
				alert("行號"+LineNo+":台半料號不可空白!!");
				document.MYFORM.elements["TSC_ITEM_ID_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["QUANTITY_"+i].value==null || document.MYFORM.elements["QUANTITY_"+i].value=="")
			{
				alert("行號"+LineNo+":數量不可空白!!");
				document.MYFORM.elements["QUANTITY_"+i].focus();
				return false;
			}
			else if (parseFloat(document.MYFORM.elements["QUANTITY_"+i].value)<=0)
			{
				alert("行號"+LineNo+":數量必須大於零!!");
				document.MYFORM.elements["QUANTITY_"+i].focus();
				return false;
			}
			else
			{
				var SPQ = document.MYFORM.elements["SPQ_"+i].value;
				var MOQ = document.MYFORM.elements["MOQ_"+i].value;
				if ((SPQ ==null || SPQ==0) && (MOQ==null || MOQ==0))
				{
					alert("此料號尚未設定SPQ及MOQ,請洽系統管理人員處理!!");
					document.MYFORM.elements["QUANTITY_"+i].focus();  
					return false;
				} 
				else
				{
					var SPQ_PCS = SPQ * 1000;
					var MOQ_PCS = MOQ * 1000;
					var QTY_PCS = document.MYFORM.elements["QUANTITY_"+i].value * 1000;
					if (QTY_PCS < MOQ_PCS)
					{
						alert("訂單量必須大於等於MOQ:"+MOQ+"!!");
						return false;
					}
					else if ( (QTY_PCS%SPQ_PCS) != 0)
					{
						alert("訂單量必為SPQ:"+SPQ+"的倍數!!");
						return false;
					}
				}
			}
			//add by Peggy 20130910
			if (document.MYFORM.elements["UOM_"+i].value==null || document.MYFORM.elements["UOM_"+i].value=="")
			{
				alert("行號"+LineNo+":UOM不可空白!!");
				return false;
			}
			if (document.MYFORM.elements["CRD_"+i].value==null || document.MYFORM.elements["CRD_"+i].value=="")
			{
				alert("行號"+LineNo+":CRD不可空白!!");
				document.MYFORM.elements["CRD_"+i].focus();
				return false;
			}
			else if (eval(document.MYFORM.elements["CRD_"+i].value)<eval(document.MYFORM.SYSTEMDATE.value))  //add by Peggy 20210311
			{
				alert("行號"+LineNo+":CRD必須大於等於今天!!");
				document.MYFORM.elements["CRD_"+i].focus();
				return false;				
							
			}
			if (document.MYFORM.elements["SHIPPINGMETHOD_"+i].value==null || document.MYFORM.elements["SHIPPINGMETHOD_"+i].value=="")
			{
				alert("行號"+LineNo+":出貨方式不可空白!!");
				document.MYFORM.elements["SHIPPINGMETHOD_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["SSD_"+i].value==null || document.MYFORM.elements["SSD_"+i].value=="")
			{
				alert("行號"+LineNo+":SSD不可空白!!");
				document.MYFORM.elements["SSD_"+i].focus();
				return false;
			}
			else if ((document.MYFORM.elements["SSD_"+i].value).length !=8)
			{
				alert("行號"+LineNo+":SSD日期格式有誤!!");
				document.MYFORM.elements["SSD_"+i].focus();
				return false;
			}
			else if (document.MYFORM.elements["SSD_"+i].value <= document.MYFORM.SYSTEMDATE.value)
			{
				alert("行號"+LineNo+":SSD必須大於等於系統日("+document.MYFORM.SYSTEMDATE.value+")!!");
				document.MYFORM.elements["SSD_"+i].focus();
				return false;
			}
	
			if (document.MYFORM.elements["PLANTCODE_"+i].value==null || document.MYFORM.elements["PLANTCODE_"+i].value=="")
			{
				alert("行號"+LineNo+":生產廠區不可空白!!");
				document.MYFORM.elements["PLANTCODE_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["ORDER_TYPE_"+i].value==null || document.MYFORM.elements["ORDER_TYPE_"+i].value=="")
			{
				alert("行號"+LineNo+":訂單類型不可空白!!");
				document.MYFORM.elements["ORDER_TYPE_"+i].focus();
				return false;
			}
			if (document.MYFORM.elements["LINE_TYPE_"+i].value==null || document.MYFORM.elements["LINE_TYPE_"+i].value=="")
			{
				alert("行號"+LineNo+":Line Type不可空白!!");
				document.MYFORM.elements["LINE_TYPE_"+i].focus();
				return false;
			}
			if (document.MYFORM.CUSTMARKETGROUP.value =="AU" && document.MYFORM.SALESAREANO.value=="001" && document.MYFORM.elements["TSC_ITEM_PACKAGE_"+i].value=="SMA" && document.MYFORM.elements["YEWFLAG_"+i].value=="1")
			{
				alert("行號"+LineNo+":此SMA產品目前只能詢YEW!!");
				document.MYFORM.elements["PLANTCODE_"+i].focus();
				return false;
			}
			//add by Peggy 20140526
			if (document.MYFORM.elements["LINE_FOB_"+i].value==null ||document.MYFORM.elements["LINE_FOB_"+i].value=="")
			{
				alert("行號"+LineNo+":FOB 不可空白!!");
				document.MYFORM.elements["LINE_FOB_"+i].focus();
				return false;
			}
			else
			{
				//if ((document.MYFORM.elements["PLANTCODE_"+i].value=="002" || document.MYFORM.elements["PLANTCODE_"+i].value=="008") && document.MYFORM.elements["LINE_FOB_"+i].value !="CIF MUNICH")
				if ((document.MYFORM.elements["PLANTCODE_"+i].value=="002" || document.MYFORM.elements["PLANTCODE_"+i].value=="008") && document.MYFORM.elements["LINE_FOB_"+i].value !="EX WORKS")  //20220105起改為EX WORKS FROM EMILY
				{
					alert("行號"+LineNo+":FOB必須為 EX WORKS");
					document.MYFORM.elements["LINE_FOB_"+i].focus();
					return false;
				}
				//else if ((document.MYFORM.elements["PLANTCODE_"+i].value=="011" || document.MYFORM.elements["PLANTCODE_"+i].value=="006" || document.MYFORM.elements["PLANTCODE_"+i].value=="010") && document.MYFORM.elements["LINE_FOB_"+i].value !="EX WORKS")
				else if ((document.MYFORM.elements["PLANTCODE_"+i].value=="011" || document.MYFORM.elements["PLANTCODE_"+i].value=="006" || document.MYFORM.elements["PLANTCODE_"+i].value=="010") && document.MYFORM.elements["LINE_FOB_"+i].value !="C&I MUNICH")
				{
					//alert("行號"+LineNo+":FOB必須為 C&I MUNICH");
					//alert("行號"+LineNo+":FOB必須為 EX WORKS");  //add by Peggy 20220526
					alert("行號"+LineNo+":FOB必須為 C&I MUNICH");  //add by Peggy 20221201
					document.MYFORM.elements["LINE_FOB_"+i].focus();
					return false;
				}
				else if (document.MYFORM.elements["PLANTCODE_"+i].value=="005")
				{
					//if (document.MYFORM.elements["PACKING_INSTRUCTIONS_"+i].value=="I"  && document.MYFORM.elements["LINE_FOB_"+i].value !="EX WORKS")
					if (document.MYFORM.elements["PACKING_INSTRUCTIONS_"+i].value=="I"  && document.MYFORM.elements["LINE_FOB_"+i].value !="C&I MUNICH")
					{
						//alert("行號"+LineNo+":FOB必須為 C&I MUNICH");
						//alert("行號"+LineNo+":FOB必須為 EX WORKS"); //add by Peggy 20220526
						alert("行號"+LineNo+":FOB必須為 C&I MUNICH"); //add by Peggy 20221201
						document.MYFORM.elements["LINE_FOB_"+i].focus();
						return false;					
					}
					//else if (document.MYFORM.elements["PACKING_INSTRUCTIONS_"+i].value=="T"  && document.MYFORM.elements["LINE_FOB_"+i].value !="CIF MUNICH")
					else if (document.MYFORM.elements["PACKING_INSTRUCTIONS_"+i].value=="T"  && document.MYFORM.elements["LINE_FOB_"+i].value !="EX WORKS") //20220105起改為EX WORKS FROM EMILY
					{
						alert("行號"+LineNo+":FOB必須為 EX WORKS");
						document.MYFORM.elements["LINE_FOB_"+i].focus();
						return false;					
					}					
				}
			}
		}
	}
	if (chkcnt ==0)
	{
		alert("請先勾選處理項目!!");
		return false;
	}
	//檢查客戶是否只能matrix
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.CHKBOX.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i-1].checked 
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["MATRIX_ITEM_FLAG_"+i].value=="Y" && document.MYFORM.elements["TSC_ITEM_PACKAGE_"+i].value.toUpperCase().indexOf("MATRIX")<0)
			{
				if (confirm("行號"+LineNo+":客戶限制下Matrix料號,你確定要改下Non Matrix嗎?")==false)
				{
					return false;
				}
			}
		}
	}
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
function setCRD(objLine)
{
	if (document.MYFORM.elements["CRD_"+objLine].value==null || document.MYFORM.elements["CRD_"+objLine].value!=document.MYFORM.elements["ORIG_CRD_"+objLine].value)
	{
		document.MYFORM.elements["SSD_"+objLine].value="";
	}
}
</script>
<%
	String SALESAREANO= request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="001";
	String SALESAREA= request.getParameter("SALESAREA");
	if (SALESAREA==null) SALESAREA="";
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String VERSIONID = request.getParameter("VERSIONID");
	if (VERSIONID==null) VERSIONID="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	//String TAXCODE = request.getParameter("TAXCODE");
	//if (TAXCODE==null) TAXCODE="";
	String CUSTNAME= request.getParameter("CUSTNAME");
	if (CUSTNAME==null) CUSTNAME="";
	String CUSTOMER_NAME = request.getParameter("CUSTOMER_NAME");
	if (CUSTOMER_NAME==null) CUSTOMER_NAME="";
	String SALES = request.getParameter("SALES");
	if (SALES==null) SALES="";
	String SALESID = request.getParameter("SALESID");
	if (SALESID==null) SALESID="";
	String PAYTERMID = request.getParameter("PAYTERMID");
	if (PAYTERMID==null) PAYTERMID="";
	String PAYMENTTERM = request.getParameter("PAYMENTTERM");
	if (PAYMENTTERM==null) PAYMENTTERM="";
	String SHIPTOID = request.getParameter("SHIPTOID");
	if (SHIPTOID==null) SHIPTOID="";
	String SHIPTO = request.getParameter("SHIPTO");
	if (SHIPTO==null) SHIPTO="";
	String FOB = request.getParameter("FOB");
	if (FOB==null) FOB="";
	String SHIPTOCONTACTID = request.getParameter("SHIPTOCONTACTID");
	if (SHIPTOCONTACTID==null) SHIPTOCONTACTID="";
	String SHIPTOCONTACT = request.getParameter("SHIPTOCONTACT");
	if (SHIPTOCONTACT==null) SHIPTOCONTACT="";
	String BILLTOID=request.getParameter("BILLTOID");
	if (BILLTOID==null) BILLTOID="";
	String BILLTO=request.getParameter("BILLTO");
	if (BILLTO==null) BILLTO="";
	//String RFQTYPE = request.getParameter("RFQTYPE");
	//if (RFQTYPE==null) RFQTYPE="";
	String PRICELIST = request.getParameter("PRICELIST");
	if (PRICELIST==null) PRICELIST="";
	String DELIVERYTOID = request.getParameter("DELIVERYTOID");
	if (DELIVERYTOID==null) DELIVERYTOID="";
	String DELIVERYTO = request.getParameter("DELIVERYTO");
	if (DELIVERYTO==null) DELIVERYTO="";
	String REMARK = request.getParameter("REMARK");
	if (REMARK==null) REMARK="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID ==null) ERPCUSTOMERID="";
	String CUSTMARKETGROUP=request.getParameter("CUSTMARKETGROUP");
	if (CUSTMARKETGROUP ==null) CUSTMARKETGROUP = ""; 
	String END_CUST_NAME = request.getParameter("ENDCUSTNAME");
	if (END_CUST_NAME==null) END_CUST_NAME="";
	String SYSTEMDATE = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(7);
    String maxDate = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(-7);
	String sql = "",CREATED_BY="",PO_CUSTOMER_NAME="",PACKING_INSTRUCTIONS="";
	String REMAKRS=""; //add by Peggy 20181205
	int iMaxLine = 0;
	try
	{
		iMaxLine = Integer.parseInt(request.getParameter("MAXLINE"));
	}
	catch(Exception e)
	{
		iMaxLine = 0;
	}
	
	
	boolean bNotFound = false;
	
	try
	{
			
		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		cs1.setString(1,"41"); 
		cs1.execute();
		cs1.close();		

		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();
			
		sql = " select nvl(b.CURRENCY_CODE,'') currency_code, (select '('||c.sales_area_no||')'||c.sales_area_name from oraddman.tssales_area c where c.sales_area_no='"+SALESAREANO+"') as SALESAREA"+
		      ",'('||d.customer_number||')'||d.customer_name as CUSTNAME,d.ATTRIBUTE2 market_group,d.customer_name,a.erp_customer_id"+
			  ",b.customer_id end_customer_id"+
			  ",b.customer_name end_customer_name"+
			  ",a.CUSTOMER_NAME po_customer_name"+ //add by Peggy 20180201
			  ",(select currency_code from oraddman.tsce_purchase_order_lines x where x.customer_po=a.customer_po and x.version_id=a.version_id and rownum=1) line_curr"+
              " from ORADDMAN.TSCE_PURCHASE_ORDER_HEADERS a"+
			  ",(SELECT * FROM oraddman.TSCE_END_CUSTOMER_LIST where active_flag=?) b"+
			  ",ar_customers d "+
              " where A.customer_po=?"+
			  " and a.version_id=?"+
              " AND substr(a.customer_po,0,instr(a.customer_po,'-')-1)=b.customer_id(+)"+
			  " AND a.erp_customer_id = d.customer_id"+
			  " and exists (select 1 from oraddman.tsce_purchase_order_lines x where x.data_flag='E' and x.version_id=0 and x.customer_po=a.customer_po)";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"A");
		statement.setString(2,CUSTPO);
		statement.setString(3,VERSIONID);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			if (rs.getString("currency_code") == null || rs.getString("currency_code").equals(""))
			{
				CURRENCY ="";
			}
			else
			{
				CURRENCY = rs.getString("line_curr");
			}
			SALESAREA = rs.getString("SALESAREA");
			CREATED_BY = UserName;
			CUSTMARKETGROUP =rs.getString("MARKET_GROUP");
			CUSTOMER_NAME = rs.getString("customer_name");
			CUSTNAME = rs.getString("CUSTNAME");
			ERPCUSTOMERID = rs.getString("ERP_CUSTOMER_ID");
			END_CUST_NAME = rs.getString("end_customer_name");
			PO_CUSTOMER_NAME =rs.getString("po_customer_name");  //add by Peggy 20180201

  			Statement statement1=con.createStatement();
       		sql = "select b.PRIMARY_SALESREP_ID, c.NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,jtf_rs_salesreps c "+
		              "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and a.CUST_ACCOUNT_ID ='"+ERPCUSTOMERID+"' "+
					  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID "+
					  "and exists (select 1 from oraddman.tssales_area x where x.par_org_id = a.org_id and x.sales_area_no='"+SALESAREANO+"') and a.SHIP_TO_FLAG='P' "+ 
					  "and c.SALESREP_ID  = b.PRIMARY_SALESREP_ID";
        	ResultSet rsSalsPs=statement1.executeQuery(sql);	 
	    	if (rsSalsPs.next()==true)
			{  
				if (!SALESAREANO.equals("020") && !SALESAREANO.equals("021") &&  !SALESAREANO.equals("022"))
				{
					SALES = rsSalsPs.getString("NAME");
					SALESID = rsSalsPs.getString("PRIMARY_SALESREP_ID");		
				}
			} 
			else 
			{
				SALESID=userSalesResID; // 找不到客戶負責的業務人員,則以業務地區主要負責業務員
			}
			rsSalsPs.close();	
			statement1.close();
				
			Statement statementy=con.createStatement();
			sql = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
					  " from ar_contacts_v con,hz_cust_site_uses su "+
					  " where  con.customer_id ='"+ERPCUSTOMERID+"'"+
					  " and con.status='A'"+
					  " AND con.address_id=su.cust_acct_site_id"+
					  " AND su.site_use_code='SHIP_TO'"+
					  " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+ERPCUSTOMERID+"',1,2)";		
			ResultSet rsy=statementy.executeQuery(sql);	  			  				     
			if (rsy.next())
			{
				SHIPTOCONTACT = rsy.getString("contact_name");
				SHIPTOCONTACTID= rsy.getString("contact_id");			
			}
			rsy.close();
			statementy.close();

			sql =" select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
				 " a.PAYMENT_TERM_ID, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID"+ 
				 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
				 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
				 " AND b.party_site_id = party_site.party_site_id"+
				 " AND loc.location_id = party_site.location_id "+
				 " and a.STATUS='A' "+
				 " AND a.PRIMARY_FLAG='Y'"+
				 " and b.CUST_ACCOUNT_ID =?";
			PreparedStatement statementa = con.prepareStatement(sql);
			statementa.setString(1,ERPCUSTOMERID);
			ResultSet rsa=statementa.executeQuery();
			while (rsa.next())
			{
				if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
				{
					SHIPTOID = rsa.getString("SITE_USE_ID");
					SHIPTO = "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
				else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
				{
					BILLTOID = rsa.getString("SITE_USE_ID");
					BILLTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
					PAYTERMID = rsa.getString("PAYMENT_TERM_ID");
					FOB = rsa.getString("FOB_POINT");
					if (CURRENCY.equals("USD"))
					{
						PRICELIST = "6038";
					}
					else if (CURRENCY.equals("EUR"))
					{
						PRICELIST = "7331";
					}
					else
					{
						PRICELIST = "";
					}
					
					sql = " select a.NAME  from RA_TERMS_VL a where a.IN_USE ='Y' AND a.TERM_ID='"+PAYTERMID+"'";
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery(sql);	  			  				     
					if (rs1.next())
					{
						PAYMENTTERM  = rs1.getString("NAME");
					}
					else
					{
						PAYMENTTERM = "";
					}
					rs1.close();
					state1.close();
					
				}
				else if (rsa.getString("SITE_USE_CODE").equals("DELIVER_TO"))
				{
					DELIVERYTOID = rsa.getString("SITE_USE_ID");
					DELIVERYTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
			}
			rsa.close();
			statementa.close();
			
			//跟上面sql合併,modify by Peggy 20190319
			/*
			sql = " select b.SITE_USE_CODE, b.site_use_id,b.PAYMENT_TERM_ID,b.FOB_POINT, b.PRICE_LIST_ID,b.tax_code"+
			      " from hz_cust_acct_sites_all a,hz_cust_site_uses_all b"+
                  " where a.cust_account_id=?"+
                  " and a.cust_acct_site_id=b.cust_acct_site_id"+
                  " and b.status='A'"+
                  " and b.SITE_USE_ID IN ("+BILLTOID+","+DELIVERYTOID+")";
			PreparedStatement statementb = con.prepareStatement(sql);
			statementb.setString(1,ERPCUSTOMERID);
			ResultSet rsb=statementb.executeQuery();
			while (rsb.next())
			{
				if (rsb.getString("SITE_USE_CODE").equals("BILL_TO"))
				{
					//TAXCODE = rsb.getString("TAX_CODE");
					//if (TAXCODE ==null) TAXCODE ="";
					PAYTERMID = rsb.getString("PAYMENT_TERM_ID");
					FOB = rsb.getString("FOB_POINT");
					BILLTOID = rsb.getString("site_use_id");
					if (CURRENCY.equals("USD"))
					{
						PRICELIST = "6038";
					}
					else if (CURRENCY.equals("EUR"))
					{
						PRICELIST = "7331";
					}
					else
					{
						PRICELIST = "";
					}
					
					sql = " select a.NAME  from RA_TERMS_VL a where a.IN_USE ='Y' AND a.TERM_ID='"+PAYTERMID+"'";
					Statement state1=con.createStatement();
					ResultSet rs1=state1.executeQuery(sql);	  			  				     
					if (rs1.next())
					{
						PAYMENTTERM  = rs1.getString("NAME");
					}
					else
					{
						PAYMENTTERM = "";
					}
					rs1.close();
					state1.close();
				}
				else if (rsb.getString("SITE_USE_CODE").equals("DELIVER_TO"))
				{
					DELIVERYTOID = rsb.getString("site_use_id");
				}
			}
			rsb.close();
			statementb.close();  
				*/
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
		out.println("<font color='red'>exception:"+e.getMessage()+"</font>");
		//bNotFound = true;
	}	
	
	if (bNotFound)
	{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!客戶PO狀態可能不符合條件,請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCE1214ORDERSDetail.jsp" METHOD="post" NAME="MYFORM">
<BR>
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">TSCE New PO</font>
			<font style="font-size:20px;color:#000000;font-family:細明體"><strong>資料異常確認</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><a href="TSCE1214ExceptionQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0">
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesArea"/></td>
					<td><input type="text" name="SALESAREA" value="<%=SALESAREA%>" size="40" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SALESAREANO" value="<%=SALESAREANO%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="VERSIONID" value="<%=VERSIONID%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCurr"/></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesMan"/></td>
					<td><input type="text" name="SALES" value="<%=SALES%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SALESID" value="<%=SALESID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustomerName"/></td>
					<td colspan="3"><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>"  size="60" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"><input type="hidden" name="CUSTOMER_NAME" value="<%=CUSTOMER_NAME%>"><input type="hidden" name="ENDCUSTNAME" value="<%=END_CUST_NAME%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td><input type="button" name="btnfob" value=".." onClick="subWindowFOBPointFind('',this.form.FOB.value,'HEADER')"><input type="text" name="FOB" value="<%=FOB%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (FOB==null||FOB==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgPaymentTerm"/></td>
					<td><input type="button" name="btnpay" value=".." onClick="subWindowPayTermFind(this.form.PAYTERMID.value)"><input type="text" name="PAYMENTTERM" value="<%=PAYMENTTERM%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (PAYMENTTERM==null||PAYMENTTERM==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="hidden" name="PAYTERMID" value="<%=PAYTERMID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></td>
					<td colspan="3"><input type="button" name="btnshipto" value=".." onClick="subWindowShipToFind('SHIP_TO',this.form.ERPCUSTOMERID.value,this.form.SHIPTOID.value,this.form.SALESAREANO.value)"><input type="text" name="SHIPTO" value="<%=SHIPTO%>"  size="70" class="style4"><input type="hidden" name="SHIPTOID" value="<%=SHIPTOID%>"></td>
					<td class="style1">Ship To Contact</td>
					<td colspan="3"><input type="button" name="btntcontact" value=".." onClick="subWindowShipToContactFind()"><input type="text" name="SHIPTOCONTACT" value="<%=SHIPTOCONTACT%>" class="style4" size="50" onKeyDown="return (event.keyCode!=8);" <%if (SHIPTOCONTACT==null||SHIPTOCONTACT==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="hidden" name="SHIPTOCONTACTID" value="<%=SHIPTOCONTACTID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgBillTo"/></td>
					<td colspan="3"><input type="button" name="btntbillto" value=".." onClick="subWindowShipToFind('BILL_TO',this.form.ERPCUSTOMERID.value,this.form.BILLTOID.value,this.form.SALESAREANO.value)"><input type="text" name="BILLTO" value="<%=BILLTO%>" size="70" class="style4"><input type="hidden" name="BILLTOID" value="<%=BILLTOID%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgPriceList"/></td>
					<td colspan="3">
					<%
					try
					{   
						Statement statementx=con.createStatement();
						sql = " select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
					      	//" from qp_secu_list_headers_v "+
					          " from qp_list_headers_v "+ //因價格表改為 User 權限 , 取消所有 OU 權限,故改用qp_list_headers_v by Peggy 20150625
							  " where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' "+
							  "  AND (ORIG_ORG_ID =41 or ORIG_ORG_ID IS NULL ) "; 
						ResultSet rsx=statementx.executeQuery(sql);
						out.println("<select NAME='PRICELIST' tabindex='16' class='style5'" + ((PRICELIST==null||PRICELIST=="")?"style='background-color:#FFFF66'":"style='background-color:#FFFFFF'>"));
						out.println("<OPTION VALUE=-->--");     
						while (rsx.next())
						{            
							String s1=(String)rsx.getString(1); 
							String s2=(String)rsx.getString(2); 
							String s3=(String)rsx.getString(3);
							if (s1==PRICELIST || s1.equals(PRICELIST)) 
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
							} 
							else 
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}        
						} 
						out.println("</select>"); 
						statementx.close();		  		  
						rsx.close();        	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception3:"+e.getMessage()); 
					} 		
					%>
					</td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgDeliverTo"/></td>
					<td colspan="3"><input type="button" name="btntdeliverto" value=".." onClick="subWindowShipToFind('DELIVER_TO',this.form.ERPCUSTOMERID.value,this.form.DELIVERYTOID.value,this.form.SALESAREANO.value)"><input type="text" name="DELIVERYTO" value="<%=DELIVERYTO%>" size="70" class="style4"><input type="hidden" name="DELIVERYTOID" value="<%=DELIVERYTOID%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td colspan="3"><input type="text" name="REMARK" value="<%=REMARK%>" size="80" class="style4"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0">
				<tr>
					<td colspan="17" class="style1"><jsp:getProperty name="rPH" property="pgDetail"/></td>
				</tr>
				<tr>
					<td width="2%" class="style1"><input type="checkbox" name="CHKBOXALL" value="" onClick="chkall();"></td>
					<td width="2%" class="style1">Line No</td>
					<td width="2%" class="style1"><jsp:getProperty name="rPH" property="pgCustPOLineNo"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgCustItemNo"/></td>
					<td width="12%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgItemDesc"/></td>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgQty"/>/<jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000"><jsp:getProperty name="rPH" property="pgKPC"/></font></td>
					<td width="4%" class="style1">Selling Price</td>
					<td width="5%" class="style1">CRD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgShippingMethod"/></td>
					<td width="5%" class="style1">SSD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgProdFactory"/></td>
					<td width="4%" class="style1"><jsp:getProperty name="rPH" property="pgFirmOrderType"/></td>
					<td width="5%" class="style1">Line Type</td>
					<td width="7%" class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td width="4%" class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td width="4%" class="style1">Supplier ID</td>
					
				</tr>
				<%
				try
				{
					sql = " select rownum SEQ_NO,PO_LINE_NO CUST_PO_LINE_NO,CUST_PART_NO CUST_ITEM_NAME,TSC_PART_NO TSC_ITEM_NAME, QUANTITY,UOM,UNIT_PRICE ,CRD CUST_REQUEST_DATE "+
				          ",TSCE_BUFFERNET_PO_PKG.MATRIX_ITEM_CHECK('"+PO_CUSTOMER_NAME+"',TSC_PART_NO) MATRIX_ITEM_FLAG,ORIG_CRD ORIG_CUST_REQUEST_DATE"+
						  ",a.supplier_number"+ //add by Peggy 20220623
						  ",a.exception_desc"+
					      " from oraddman.tsce_purchase_order_lines a"+
                          " where CUSTOMER_PO=?"+
                          " and DATA_FLAG=?"+
                          " and RFQ is null"+
                          " and RFQ_LINE_NO is null"+
						  " ORDER BY TO_NUMBER(po_line_no)";
					//out.println(sql);
					PreparedStatement statementb = con.prepareStatement(sql);
					statementb.setString(1,CUSTPO);
					statementb.setString(2,"E");
					ResultSet rsb=statementb.executeQuery();
					iMaxLine =0;
					boolean exp_flag=false;
					float qty =0,moq =0,spq=0;
					String SEQ_NO ="",CUST_PO_LINE_NO ="",ORDER_ITEM="",TSC_ITEM_DESC="",QUANTITY="",ORDER_UOM="",SELLING_PRICE="",CRD="",ORIG_CRD="";
					String ORDER_ITEM_ID="",INVENTORY_ITEM_ID="",TSC_ITEM_NAME="",UOM="",ASSIGN_MANUFACT="",ORDER_TYPE="1214",PACKAGE_CODE="",FAMILY_CODE="",TSC_PROD_GROUP="",CATEGORY_ITEM="",ITEM_ID_TYPE="";
					String MOQ="",SPQ="",SHIPPING_METHOD="",SSD="",ORDER_TYPE_ID="",LINE_TYPE="",YEW_FLAG="",MATRIX_ITEM_FLAG="",SUPPLIER_NUMBER="",EXP_MSG="";
					int item_cnt =0;
					while(rsb.next())
					{
						iMaxLine ++;
						SEQ_NO = rsb.getString("SEQ_NO");
						CUST_PO_LINE_NO = rsb.getString("CUST_PO_LINE_NO");
						ORDER_ITEM = rsb.getString("CUST_ITEM_NAME");
						TSC_ITEM_DESC = rsb.getString("TSC_ITEM_NAME");
						QUANTITY = (rsb.getString("UOM").equals("PCE")?""+(Float.parseFloat(rsb.getString("QUANTITY"))/1000):rsb.getString("QUANTITY")); //modify by Peggy 20130910
						ORDER_UOM = rsb.getString("UOM");
						SELLING_PRICE = rsb.getString("UNIT_PRICE");
						CRD = rsb.getString("CUST_REQUEST_DATE");
						ORIG_CRD = rsb.getString("ORIG_CUST_REQUEST_DATE"); //add by Peggy 20210311
						MATRIX_ITEM_FLAG = rsb.getString("MATRIX_ITEM_FLAG"); //add by Peggy 20180201
						item_cnt=0;
						ORDER_ITEM_ID="";INVENTORY_ITEM_ID="";TSC_ITEM_NAME="";UOM="";ASSIGN_MANUFACT="";PACKAGE_CODE="";FAMILY_CODE="";TSC_PROD_GROUP="";CATEGORY_ITEM="";ITEM_ID_TYPE="";REMAKRS="";
						SPQ = "0";MOQ ="0";
						SUPPLIER_NUMBER=rsb.getString("SUPPLIER_NUMBER");  //add by Peggy 20220623
						if (CUSTPO.equals("99-181203-01-EH")) REMAKRS="ON-SEMI INVENTORY from A01";
						EXP_MSG = rsb.getString("exception_desc");   //add by Peggy 20221003 
						if (EXP_MSG==null) EXP_MSG="";
						
						sql = " SELECT  DISTINCT a.item_id"+
						      ",a.INVENTORY_ITEM_ID"+
							  ",a.INVENTORY_ITEM"+
							  ",msi.PRIMARY_UOM_CODE"+
                              ",NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
							  //",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
							  ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) AS ORDER_TYPE"+  //add by Peggy 20191122
                              ",NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
                              ",NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
                              //" CASE WHEN NVL(msi.attribute3, 'N/A')='008' THEN 'Rect-Subcon' WHEN NVL(msi.attribute3, 'N/A')='002' THEN 'Rect' ELSE NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP,"+
							  ",CASE WHEN NVL(msi.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE  NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
                              ",a.item_identifier_type"+
							  ",c.SEGMENT1"+
							  ",msi.creation_date"+ //20130820 add by Peggy
							  ",count(1)  over (order by a.ITEM_ID) rec_cnt"+ //add by Peggy 20150113
							  ",(SELECT COUNT(1) FROM INV.MTL_SYSTEM_ITEMS_B MSIB WHERE MSIB.INVENTORY_ITEM_ID=MSI.INVENTORY_ITEM_ID AND MSIB.ORGANIZATION_ID=327) YEW_FLAG "+ //ADD BY PEGGY 20170512
							  ",TSC_ORDER_WAREHOUSE_VALUE(msi.inventory_item_id,?,?,?) packing_instructions"+ //ADD BY PEGGY 20211118
                              " from oe_items_v a"+
							  " ,inv.mtl_system_items_b msi"+
							  " ,APPS.MTL_ITEM_CATEGORIES_V c"+
							  " ,oraddman.tsprod_manufactory d"+ //20151209
                              " where a.SOLD_TO_ORG_ID = ?"+
                              " and a.organization_id = msi.organization_id"+
                              " and a.inventory_item_id = msi.inventory_item_id"+
                              " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID"+
                              " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID"+
                              " and msi.ORGANIZATION_ID = '49'"+
							  " and msi.attribute3=d.MANUFACTORY_NO(+)"+
                              " and c.CATEGORY_SET_ID = 6"+
                              " and a.CROSS_REF_STATUS='ACTIVE'"+
                              " and msi.inventory_item_status_code <> 'Inactive'"+
							  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"+ //add by Peggy 20230215
                              " and a.item = ?"+
                              " and case when ?='' OR ? IS NULL then 'XXX' ELSE a.item_description END = case when ?='' or ? IS NULL then 'XXX' ELSE ? END"+
							  " order by msi.creation_date DESC"; //20130820 add by Peggy,當客戶品名+台半品名對應一個以上台半料號時,以最近create的料號為優先
						//out.println(sql);
						PreparedStatement statementc = con.prepareStatement(sql);
						statementc.setString(1,"1142");
						statementc.setString(2,"PACKINGINSTRUCTIONS");
						statementc.setString(3,ERPCUSTOMERID);
						statementc.setString(4,ERPCUSTOMERID);
						statementc.setString(5,ORDER_ITEM );
						statementc.setString(6,TSC_ITEM_DESC);
						statementc.setString(7,TSC_ITEM_DESC);
						statementc.setString(8,TSC_ITEM_DESC);
						statementc.setString(9,TSC_ITEM_DESC);
						statementc.setString(10,TSC_ITEM_DESC);
						ResultSet rsc=statementc.executeQuery();
						while(rsc.next())
						{
							if (rsc.getInt("rec_cnt") >1) break;
							item_cnt++;
							if (item_cnt ==1)
							{
								ORDER_ITEM_ID=rsc.getString("item_id");
								INVENTORY_ITEM_ID=rsc.getString("INVENTORY_ITEM_ID");
								TSC_ITEM_NAME=rsc.getString("INVENTORY_ITEM");
								UOM=rsc.getString("PRIMARY_UOM_CODE");
								ASSIGN_MANUFACT=rsc.getString("ATTRIBUTE3");
								PACKAGE_CODE=rsc.getString("TSC_PACKAGE");
								FAMILY_CODE=rsc.getString("TSC_FAMILY");
								TSC_PROD_GROUP=rsc.getString("TSC_PROD_GROUP");
								CATEGORY_ITEM=rsc.getString("SEGMENT1");
								ITEM_ID_TYPE=rsc.getString("item_identifier_type");
								YEW_FLAG=rsc.getString("YEW_FLAG"); //add by Peggy 20160512
								PACKING_INSTRUCTIONS=rsc.getString("packing_instructions"); //add by Peggy 20211118
								
								if (ASSIGN_MANUFACT.equals("002") || ASSIGN_MANUFACT.equals("008"))
								{
									//FOB = "CIF MUNICH";
									FOB = "EX WORKS";  //20220105起改為EX WORKS FROM EMILY
								}
								else if (ASSIGN_MANUFACT.equals("005"))  //add by Peggy 20211118
								{
									 if (PACKING_INSTRUCTIONS.equals("I"))
									 {
									 	//FOB = "C&I MUNICH";
										//FOB = "EX WORKS";  //20220526起改為EX WORKS FROM EMILY
										FOB = "C&I MUNICH";  //20221201起改為C&I MUNICH FROM EMILY
									 }
									 else
									 {
									 	//FOB = "CIF MUNICH";
										FOB = "EX WORKS";  //20220105起改為EX WORKS FROM EMILY
									 }
								}
								else
								{
									//FOB = "C&I MUNICH";
									//FOB = "EX WORKS";  //20220526起改為EX WORKS FROM EMILY
									FOB = "C&I MUNICH";  //20221201起改為C&I MUNICH FROM EMILY
								}
							}
						
							//modify by Peggy 20150721
							//CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?)}");
							CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}"); //add by Peggy 20160513
							csf.setString(1,SALESAREANO);
							csf.setString(2,PACKAGE_CODE);      
							csf.setString(3,FAMILY_CODE);                   
							csf.setString(4,TSC_ITEM_DESC);    
							csf.setString(5,CRD);   
							csf.registerOutParameter(6, Types.VARCHAR);  
							csf.setString(7,ORDER_TYPE);   
							csf.setString(8,ASSIGN_MANUFACT);   
							csf.setString(9,ERPCUSTOMERID);    //add by Peggy 20160513
							csf.setString(10,FOB);             //add by Peggy 20190319
							csf.setString(11,DELIVERYTOID);              //add by Peggy 20190319
							csf.execute();
							SHIPPING_METHOD = csf.getString(6);                
							csf.close();							
						
							//modify by Peggy 20150721
							CallableStatement csx = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?)}");
							csx.setString(1,INVENTORY_ITEM_ID);
							csx.setString(2,ASSIGN_MANUFACT);      
							csx.registerOutParameter(3, Types.VARCHAR);  
							csx.registerOutParameter(4, Types.VARCHAR);  
							csx.execute();
							SPQ = ""+(csx.getFloat(3)/1000);                
							MOQ = ""+(csx.getFloat(4)/1000); 
							csx.close();
														
							Statement state3=con.createStatement();     
							//ResultSet rs3=state3.executeQuery("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+SHIPPING_METHOD+"','"+ASSIGN_MANUFACT+"') from dual");
							ResultSet rs3=state3.executeQuery("SELECT tsce_buffernet_po_pkg.GET_PO_SSD('"+CRD+"','"+SHIPPING_METHOD+"','"+ASSIGN_MANUFACT+"',sysdate,'"+ERPCUSTOMERID+"','"+FOB+"','"+DELIVERYTOID+"') from dual");  //新增sysdate參數,modify by Peggy 20170523
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
						}
						rsc.close();
						statementc.close();
							  
						sql = " SELECT DISTINCT  a.OTYPE_ID,a.DEFAULT_ORDER_LINE_TYPE"+
							  " FROM ORADDMAN.TSAREA_ORDERCLS  A"+
							  " WHERE A.ACTIVE =?"+
							  " AND A.ORDER_NUM =?"+
							  " and a.SAREA_NO= ?";
						PreparedStatement statementd = con.prepareStatement(sql);
						statementd.setString(1,"Y");
						statementd.setString(2,ORDER_TYPE);
						statementd.setString(3,SALESAREANO);
						ResultSet rsd=statementd.executeQuery();
						if(rsd.next())
						{
							ORDER_TYPE_ID = rsd.getString("OTYPE_ID");
							LINE_TYPE = rsd.getString("DEFAULT_ORDER_LINE_TYPE"); 
						}
						else
						{
							ORDER_TYPE_ID="";LINE_TYPE="";
						}
						rsd.close();
						statementd.close();

						
						if (SPQ.equals("0") || MOQ.equals("0") || ((Float.parseFloat(QUANTITY)*1000)%(Float.parseFloat(SPQ)*1000)) !=0 || Float.parseFloat(QUANTITY)<Float.parseFloat(MOQ))
						{
							exp_flag=true;
						}
						else
						{
							exp_flag=false;
						}
				%>
					<tr>
						<td><input type="checkbox" name="CHKBOX" value="<%=iMaxLine%>"><input type="hidden" name="SEQ_NO_<%=iMaxLine%>" value="<%=SEQ_NO%>"></td>
						<td><input type="text" name="LINE_NO_<%=iMaxLine%>" value="<%=iMaxLine%>"  size="2" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CUST_PO_LINE_NO_<%=iMaxLine%>" value="<%=CUST_PO_LINE_NO%>" size="4" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CUST_ITEM_<%=iMaxLine%>" value="<%=ORDER_ITEM%>" size="10" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (ORDER_ITEM ==null||ORDER_ITEM.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btncustitem_<%=iMaxLine%>" value=".." onClick="subWindowCustItemFind('<%=iMaxLine%>',this.form.ERPCUSTOMERID.value,this.form.TSC_ITEM_DESC_<%=iMaxLine%>.value,this.form.CUST_ITEM_<%=iMaxLine%>.value)"><input type="hidden" name="CUST_ITEM_ID_<%=iMaxLine%>" value="<%=ORDER_ITEM_ID%>"><input type="hidden" name="ITEM_ID_TYPE_<%=iMaxLine%>" value="<%=ITEM_ID_TYPE%>"><input type="hidden" name="CATEGORY_ITEM_<%=iMaxLine%>" value="<%=CATEGORY_ITEM%>">
						<%=(EXP_MSG.equals("")?"":"<font color='red'>"+EXP_MSG+"</font>")%></td>
						<td><input type="text" name="TSC_ITEM_<%=iMaxLine%>" value="<%=TSC_ITEM_NAME%>" size="23" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (TSC_ITEM_NAME==null||TSC_ITEM_NAME.equals("")||item_cnt >1){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnitem_<%=iMaxLine%>" value=".." onClick="subWindowItemFind('<%=iMaxLine%>',this.form.TSC_ITEM_<%=iMaxLine%>.value,this.form.TSC_ITEM_DESC_<%=iMaxLine%>.value,'N',this.form.ERPCUSTOMERID.value,this.form.SALESAREANO.value,this.form.ORDER_TYPE_<%=iMaxLine%>.value,this.form.CUSTMARKETGROUP.value,this.form.CRD_<%=iMaxLine%>.value,this.form.ERPCUSTOMERID.value,this.form.DELIVERYTOID.value)"><input type="hidden" name="TSC_ITEM_ID_<%=iMaxLine%>" value="<%=INVENTORY_ITEM_ID%>"><input type="hidden" name="TSC_ITEM_PACKAGE_<%=iMaxLine%>" value="<%=PACKAGE_CODE%>"><input type="hidden" name="TSC_PROD_GROUP_<%=iMaxLine%>" value="<%=TSC_PROD_GROUP%>">
						    <input type="hidden" name="MATRIX_ITEM_FLAG_<%=iMaxLine%>" value="<%=MATRIX_ITEM_FLAG%>"><input type="hidden" NAME="YEWFLAG_<%=iMaxLine%>" value="<%=YEW_FLAG%>"></td>
						<td><input type="text" name="TSC_ITEM_DESC_<%=iMaxLine%>" value="<%=TSC_ITEM_DESC%>"  size="18" class="style4"><input type="hidden" name="UOM_<%=iMaxLine%>" value="<%=UOM%>"></td>
						<td><input type="text" name="QUANTITY_<%=iMaxLine%>" value="<%=(new DecimalFormat("####0.#####")).format(Float.parseFloat(QUANTITY))%>" size="3" class="style4" <%if (exp_flag){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> >
						<font color='#FF0000' face = 'Arial'><strong>MOQ:<input type="text" name="MOQ_<%=iMaxLine%>" size="2" align="right" style="border:0;color:#FF0000; text-decoration: underline ;font:'Comic Sans MS'; font-style:italic;"  value="<%=MOQ%>" readonly>K</strong></font><input type="hidden" name="SPQ_<%=iMaxLine%>" value="<%=SPQ%>"></td>
						<td><input type="text" name="SELLINGPRICE_<%=iMaxLine%>" value="<%=(new DecimalFormat("####0.#####")).format(Float.parseFloat(SELLING_PRICE))%>" size="4" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
						<td><input type="text" name="CRD_<%=iMaxLine%>" value="<%=CRD%>" size="6" class="style4" onBlur="setCRD(<%=iMaxLine%>)" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" <%if (Long.parseLong(CRD)<Long.parseLong(SYSTEMDATE)){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> ><input type="hidden" name="ORIG_CRD_<%=iMaxLine%>" value="<%=ORIG_CRD%>"></td>
						<td><input type="text" name="SHIPPINGMETHOD_<%=iMaxLine%>" value="<%=SHIPPING_METHOD%>" size="6" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (SHIPPING_METHOD==null||SHIPPING_METHOD.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnshippingmethod" value=".." onClick="subWindowSSDFind('<%=iMaxLine%>',1,this.form.PLANTCODE_<%=iMaxLine%>.value,this.form.LINE_FOB_<%=iMaxLine%>.value,<%=ERPCUSTOMERID%>)"></td>
						<td><input type="text" name="SSD_<%=iMaxLine%>" value="<%=SSD%>" size="7" class="style4" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" <%if (SSD==null||SSD.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SSD_<%=iMaxLine%>);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
						<td><input type="text" name="PLANTCODE_<%=iMaxLine%>" value="<%=ASSIGN_MANUFACT%>" class="style4" size="2" onKeyDown="return (event.keyCode!=8);" <%if (ASSIGN_MANUFACT==null||ASSIGN_MANUFACT.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnplat" value=".." onClick="subWindowPlantFind('<%=iMaxLine%>',this.form.PLANTCODE_<%=iMaxLine%>.value)"><input type="hidden" name="PACKING_INSTRUCTIONS_<%=iMaxLine%>" value="<%=PACKING_INSTRUCTIONS%>"></td>
						<td><input type="text" name="ORDER_TYPE_<%=iMaxLine%>" value="<%=ORDER_TYPE%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" <%if (ORDER_TYPE==null||ORDER_TYPE.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly></td>
						<td><input type="text" name="LINE_TYPE_<%=iMaxLine%>" value="<%=LINE_TYPE%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" <%if (LINE_TYPE==null||LINE_TYPE.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnlinetype" value=".." onClick="subWindowLineTypeFind('<%=iMaxLine%>',this.form.LINE_TYPE_<%=iMaxLine%>.value,this.form.SALESAREANO.value,this.form.ORDER_TYPE_<%=iMaxLine%>.value)"></td>
						<td><input type="text" name="LINE_FOB_<%=iMaxLine%>" value="<%=FOB%>"  class="style4" size="6" onKeyDown="return (event.keyCode!=8);" <%if (FOB==null||FOB.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnlinefob" value=".." onClick="subWindowFOBPointFind('<%=iMaxLine%>',this.form.LINE_FOB_<%=iMaxLine%>.value,'LINE')"></td>
						<td><input type="text" name="REMARK_<%=iMaxLine%>" value="<%=REMAKRS%>" size="8" class="style4"></td>
						<td><input type="text" name="SUPPLIER_ID_<%=iMaxLine%>" value="<%=SUPPLIER_NUMBER%>" size="6" class="style4" readonly></td>
					</tr>
				<%
					}
					rsb.close();
					statementb.close();
				}
				catch(Exception e)
				{
					out.println("Exception4:"+e.getMessage());
				}

				%>
			</table>
		</td>
	</tr>
	<tr><td><HR></td></tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0">
				<tr>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgProcessUser"/></td>
					<td width="20%"><font color='#000099' face="Arial"><%=userID+"("+UserName+")"%></font> </td>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgProcessDate"/></td>
					<td width="20%"><font color="#000099" face="Arial"><%=dateBean.getYearMonthDay()%></font></td> 
 					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgAction"/></td>
					<td width="20%" align="center"><INPUT TYPE="button" tabindex='41' value='<jsp:getProperty name="rPH" property="pgSave"/>' onClick='setSubmit("../jsp/TSCE1214MProcess.jsp")' >&nbsp;&nbsp;<INPUT TYPE="button" value='<jsp:getProperty name="rPH" property="pgRFQAborted"/>' onClick='setClose("../jsp/TSCE1214ExceptionQuery.jsp")' ></td>
				</tr>
			</table>
		<td>
	</tr>
</table>
<input type="hidden" name="MAXLINE" value="<%=iMaxLine%>">
<input type="hidden" name="SYSTEMDATE" value="<%=SYSTEMDATE%>">
<input name="CUSTMARKETGROUP" type="hidden" value="<%=CUSTMARKETGROUP%>">
<input name="PROGRAMNAME" type="hidden" value="RFQCONFIRM">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
