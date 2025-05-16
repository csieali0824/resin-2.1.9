<!--20140801 Peggy,jabil order amount < USD200,須提示使用者-->
<!--20150417 Peggy,客戶品號不可異動-->
<!--20150625 Peggy,qp_secu_list_headers_v change to qp_list_headers_v -->
<!--20150721 Peggy,shipping method&sqp&moq改以call tsc_edi_pkg.get_shipping_method&tsc_edi_pkg.GET_SPQ_MOQ取得-->
<!--20151209 Peggy,TSC_PROD_GROUP Issue-->
<!--20160127 Peggy,arrow end customer delphi cust part no-->
<!--20160513 Peggy,for TSC_EDI_PKG.GET_SHIPPING_METHOD新增customer_id而修改-->
<!--20170425 Peggy,market group=AU & product package=SMA,當型號有assign到YEW,必須判002,否則依預設工廠別顯示(與CELINE討論)-->
<!--20171220 Peggy,Schukat EDI/ RFQ 限制下SMA SMB  Matrix-->
<!--20181207 Peggy,-ON型號檢查-->
<!--20190225 Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.lang.*,java.text.*,java.io.*,java.util.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>RFQ Confirm</title>
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
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 11px ;table-layout:fixed; word-break :break-all}
  A         { text-decoration: underline ; font-size: 11px}
  A:link    { color: #003399; text-decoration: underline; font-size: 11px }
  A:visited { color: #990066; text-decoration: underline; font-size: 11px }
  .style1   {background-color:#D1EAF1;font-size: 11px}
  .style2   {font-family:Tahoma,Georgia;border:none;font-size: 11px}
  .style3   {font-family:Tahoma,Georgia;color:#0000CC;font-size:13px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC;font-size: 11px}
  .style5   {font-family:Tahoma,Georgia;font-size: 11px}
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
	subWin=window.open("../jsp/subwindow/TSDRQPaymentTermFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D9002","subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
function subWindowFOBPointFind(lineNo,primaryFlag,fieldType)
{
	subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&FUNC=D9002&FTYPE="+fieldType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
function subWindowShipToContactFind()
{
	var CUSTOMERID=document.MYFORM.ERPCUSTOMERID.value;
	var customerName=document.MYFORM.CUSTOMER_NAME.value;
	var SHIPTOCONTACT=document.MYFORM.SHIPTOCONTACTID.value;
	subWin=window.open("../jsp/subwindow/TscShipToContact.jsp?PROGRAMID=D9002&CUSTOMERNUMBER="+CUSTOMERID+"&CUSTOMERNAME="+customerName+"&SHIPTOCONTACT="+SHIPTOCONTACT,"subwin","top=200,left=400,width=550,height=300,scrollbars=yes,menubar=no");
}
function subWindowTaxCodeFind()
{
	subWin=window.open("../jsp/subwindow/TSDRQTaxCodeFind.jsp","subwin","width=500,height=480,scrollbars=yes,menubar=no");
}
function subWindowShipToFind(EDICODE,siteUseCode,customerID,shipToOrg,salesAreaNo)
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

	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?EDICODE="+EDICODE+"&SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo+"&FUNC=D9002","subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
function subWindowCustItemFind(LINENO,CUSTOMERID,TSCITEMDESC,CUSTITEMDESC,salesAreaNo,orderType,marketGroup,CRD,customerID,FOB)
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
	if (CUSTOMERID==7147 && TSCITEMDESC==CUSTITEMDESC)
	{
		subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?LINENO="+LINENO+"&ITEMDESC="+TSCITEMDESC+"&SAMPLEORDCH=N&CUSTOMERID="+CUSTOMERID+"&sType=D9002&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&MARKETGROUP="+marketGroup+"&CRD="+CRD+"&CUSTOMERID="+customerID+"&FOB="+FOB+"&deliverid="+document.MYFORM.DELIVERYTOID.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}
	else
	{
		subWin=window.open("../jsp/subwindow/TSDRQCustomerItemFind.jsp?PROGID=D9002&LINENO="+LINENO+"&INVDESC="+TSCITEMDESC+"&CUSTOMERID="+CUSTOMERID+"&CUSTITEM="+CUSTITEMDESC,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}
}
function subWindowItemFind(LineNO,invItem,itemDesc,sampleOrdCh,sCustomerId,salesAreaNo,orderType,marketGroup,CRD,customerID,FOB)
{
	subWin=window.open("../jsp/subwindow/TSInvItemPackageFind.jsp?LINENO="+LineNO+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh+"&CUSTOMERID="+sCustomerId+"&sType=D9002&SALESAREA="+salesAreaNo+"&ORDERTYPE="+orderType+"&MARKETGROUP="+marketGroup+"&CRD="+CRD+"&CUSTOMERID="+customerID+"&FOB="+FOB+"&deliverid="+document.MYFORM.DELIVERYTOID.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
function subWindowSSDFind(lineNo,sKind,plant)
{
	var itemdesc = document.MYFORM.elements["TSC_ITEM_DESC_"+lineNo].value;
	var crdate = document.MYFORM.elements["CRD_"+lineNo].value;
	var odrtype = document.MYFORM.elements["ORDER_TYPE_"+lineNo].value;
	var region = document.MYFORM.SALESAREANO.value;
	var createdt = document.MYFORM.SYSTEMDATE.value;
	var shippingMethod = document.MYFORM.elements["SHIPPINGMETHOD_"+lineNo].value;
	var SSDate = document.MYFORM.elements["SSD_"+lineNo].value;
	var custid = document.MYFORM.ERPCUSTOMERID.value;
	var fob = document.MYFORM.elements["LINE_FOB_"+lineNo].value; //add by Peggy 20210207
	var deliver_to_id = document.MYFORM.DELIVERYTOID.value; //add by Peggy 20210208
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
		subWin=window.open("../jsp/subwindow/TSDRQSSDFind.jsp?PROGID=D9002&LINENO="+lineNo+"&CRD="+crdate+"&plant="+plant+"&odrtype="+odrtype+"&region="+region+"&createdt="+createdt+"&shippingMethod="+shippingMethod+"&itemname="+itemdesc+"&custid="+custid+"&fob="+fob.replace("&","\"")+"&deliver_id="+deliver_to_id,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
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
	subWin=window.open("../jsp/subwindow/TSDRQOrderTypeFind.jsp?PROGID=D9002&LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&MANUFACTORY="+plantCode,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
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
	subWin=window.open("../jsp/subwindow/TSDRQLineTypeFind.jsp?PROGID=D9002&LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag+"&SalesAreaNo="+salesAreaNo+"&orderType="+orderType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}
function subWindowPlantFind(lineNo,primaryFlag)
{
	subWin=window.open("../jsp/subwindow/TSDRQPlantCodeFind.jsp?LINENO="+lineNo+"&PRIMARYFLAG="+primaryFlag,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
}

function setSubmit(URL,URL1)
{
	//add by Peggy 20140604
	if (document.MYFORM.ACTION_TYPE.value==null || document.MYFORM.ACTION_TYPE.value=="")
	{
		alert("請選擇執行動作!!");
		return false;
	}
	//add by Peggy 20140604
	if (document.MYFORM.ACTION_TYPE.value=="CANCELLED"  || document.MYFORM.ACTION_TYPE.value=="PASS")
	{
		if (document.MYFORM.cancel_remark.value==null || document.MYFORM.cancel_remark.value=="")
		{
			if (document.MYFORM.ACTION_TYPE.value=="CANCELLED")
			{
				alert("請輸入取消原因!");
			}
			else
			{
				alert("請輸入Pass原因!");
			}
			document.MYFORM.cancel_remark.focus();
			return false;
		}
	}
	else if (document.MYFORM.ACTION_TYPE.value=="RFQ")
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
		if (document.MYFORM.TAXCODE.value==null || document.MYFORM.TAXCODE.value=="")
		{
			alert("Tax Code不可空白!!");
			return false;
		}
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
			//add by Peggy 20140604
			if (document.MYFORM.ACTION_TYPE.value=="RFQ")
			{
				if (document.MYFORM.elements["CUST_PO_LINE_NO_"+i].value==null || document.MYFORM.elements["CUST_PO_LINE_NO_"+i].value=="")
				{
					alert("行號"+LineNo+":客戶訂單項次不可空白!!");
					document.MYFORM.elements["CUST_PO_LINE_NO_"+i].focus();
					return false;
				}
				if (document.MYFORM.elements["CUST_ITEM_ID_"+i].value==null || document.MYFORM.elements["CUST_ITEM_ID_"+i].value=="")
				{
					if (document.MYFORM.ERPCUSTOMERID.value !=7147 || document.MYFORM.elements["CUST_ITEM_"+i].value != document.MYFORM.elements["TSC_ITEM_DESC_"+i].value) //add by Peggy 20210825
					{
						alert("行號"+LineNo+":查無客戶品號!!");
						document.MYFORM.elements["CUST_ITEM_"+i].focus();
						return false;
					}
				}
				//if ((document.MYFORM.ERPCUSTOMERID.value !=690290 && document.MYFORM.ERPCUSTOMERID.value !=702294) && document.MYFORM.elements["CUST_ITEM_"+i].value != document.MYFORM.elements["ORIG_CUST_ITEM_"+i].value)  //檢查客戶品號是否被改掉,add by Peggy 20150417
				if (document.MYFORM.elements["CUST_ITEM_"+i].value != document.MYFORM.elements["ORIG_CUST_ITEM_"+i].value && document.MYFORM.elements["ORIG_CUST_ITEM_"+i].value == document.MYFORM.elements["END_CUST_ITEM_"+i].value && document.MYFORM.elements["END_CUST_ITEM_"+i].value!="")  //檢查客戶品號是否被改掉,add by Peggy 20150417
				{
					alert("行號"+LineNo+":客戶品號不可異動!!");
					document.MYFORM.elements["CUST_ITEM_"+i].focus();
					return false;
				}
				//add by Peggy 20190306
				//if ((document.MYFORM.ERPCUSTOMERID.value ==690290 || document.MYFORM.ERPCUSTOMERID.value ==702294) && document.MYFORM.elements["END_CUST_ITEM_"+i].value=="")
				if (document.MYFORM.ERPCUSTOMERID.value !=7147)
				{
					if (document.MYFORM.elements["TSC_ITEM_DESC_"+i].value.indexOf("-ON")>=0 &&  document.MYFORM.elements["END_CUST_ITEM_"+i].value=="" && document.MYFORM.elements["ORIG_CUST_ITEM_"+i].value != document.MYFORM.elements["END_CUST_ITEM_"+i].value)
					{
						alert("行號"+LineNo+":請輸入終端客戶品號不可空白!!");
						return false;
					}
				}
				if (document.MYFORM.elements["TSC_ITEM_ID_"+i].value==null || document.MYFORM.elements["TSC_ITEM_ID_"+i].value=="")
				{
					alert("行號"+LineNo+":台半料號不可空白!!");
					document.MYFORM.elements["TSC_ITEM_ID_"+i].focus();
					return false;
				}
				else
				{
					try //add  by Peggy 20140430
					{
						if (document.MYFORM.elements["TSC_ITEM_ID_"+i].value=="undefined" || parseFloat(document.MYFORM.elements["TSC_ITEM_ID_"+i].value)<=0)
						{
							alert("行號"+LineNo+":台半料號錯誤!!");
							document.MYFORM.elements["TSC_ITEM_"+i].focus();
							return false;
						}
					}
					catch(e)
					{
						alert("行號"+LineNo+":台半料號異常!!");
						document.MYFORM.elements["TSC_ITEM_"+i].focus();
						return false;
					}
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
						var SPQ_PCS = eval(SPQ) * 1000;
						var MOQ_PCS = eval(MOQ) * 1000;
						//var QTY_PCS = eval(document.MYFORM.elements["QUANTITY_"+i].value) * 1000;
						var QTY_PCS1 = eval(document.MYFORM.elements["QUANTITY_"+i].value);
						var QTY_PCS = Math.round(QTY_PCS1 * 1000);
						if (QTY_PCS < MOQ_PCS && document.MYFORM.elements["ORDER_TYPE_"+i].value != document.MYFORM.ONHAND_ORDER_TYPE.value && document.MYFORM.elements["ORDER_TYPE_"+i].value != document.MYFORM.ONHAND_ORDER_TYPE_HQ.value)
						{
							alert("訂單量必須大於等於MOQ:"+MOQ+"!!");
							return false;
						}
						else if ( (QTY_PCS%SPQ_PCS) != 0 && document.MYFORM.elements["ORDER_TYPE_"+i].value != document.MYFORM.ONHAND_ORDER_TYPE_HQ.value)
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
				//if ((document.MYFORM.CUSTMARKETGROUP.value =="AU" || document.MYFORM.SALESAREANO.value=="001") && document.MYFORM.elements["TSC_ITEM_PACKAGE_"+i].value=="SMA" && document.MYFORM.elements["PLANTCODE_"+i].value=="008")
				if ((document.MYFORM.CUSTMARKETGROUP.value =="AU" || document.MYFORM.SALESAREANO.value=="001") && document.MYFORM.elements["TSC_ITEM_PACKAGE_"+i].value=="SMA" && document.MYFORM.elements["PLANTCODE_"+i].value=="008" && document.MYFORM.elements["YEW_FLAG_"+i].value=="1")
				{
					alert("行號"+LineNo+":SMA產品不允許外購,請重新選擇生產廠別!!");
					document.MYFORM.elements["PLANTCODE_"+i].focus();
					return false;
				}
			}
		}
	}
	if (chkcnt ==0)
	{
		alert("請先勾選處理項目!!");
		return false;
	}
	if (document.MYFORM.ACTION_TYPE.value!="MAIL_TO_CUST")
	{
		document.MYFORM.btn1.disabled=true;
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	else
	{
		document.MYFORM.btn1.disabled=true;
		document.MYFORM.action=URL1;
		document.MYFORM.submit();
	}
}
//function setClose(URL)
//{
//	if (confirm("您確定要不存檔離開嗎?"))
//	{
//		location.href=URL;
//	}
//}
function subAction()
{
	if (document.MYFORM.ACTION_TYPE.value=="CANCELLED" || document.MYFORM.ACTION_TYPE.value=="PASS")
	{
		document.MYFORM.cancel_remark.value="";
		if (document.MYFORM.ACTION_TYPE.value=="CANCELLED")
		{
			document.MYFORM.reason.value="取消原因";
		}
		else
		{
			document.MYFORM.reason.value="Pass原因";
		}
		document.MYFORM.reason.style.visibility="visible";
		document.MYFORM.cancel_remark.style.visibility="visible";

	}
	else
	{
		document.MYFORM.cancel_remark.value="";
		document.MYFORM.reason.style.visibility="hidden";
		document.MYFORM.cancel_remark.style.visibility="hidden";
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
	String REQUESTNO = request.getParameter("REQUESTNO");
	if (REQUESTNO==null) REQUESTNO ="";
	String SALESAREANO= request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String SALESAREA= request.getParameter("SALESAREA");
	if (SALESAREA==null) SALESAREA="";
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String CURRENCY = request.getParameter("CURRENCY");
	if (CURRENCY==null) CURRENCY="";
	String TAXCODE = request.getParameter("TAXCODE");
	if (TAXCODE==null) TAXCODE="";
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
	String RFQTYPE = request.getParameter("RFQTYPE");
	if (RFQTYPE==null) RFQTYPE="";
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
	String BY_CODE=request.getParameter("BY_CODE");
	if (BY_CODE==null) BY_CODE="";
	String DP_CODE=request.getParameter("DP_CODE");
	if (DP_CODE==null) DP_CODE="";
	String MAIL_TO_CUST_FLAG=request.getParameter("MAIL_TO_CUST_FLAG");
	if (MAIL_TO_CUST_FLAG==null) MAIL_TO_CUST_FLAG="";
	String MIN_ORDER_FLAG="",MIN_ORDER_AMT="",MIN_ORDER_CURR="";
	float TOT_ORDER_AMT=0;
	String SYSTEMDATE = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(7);
    String maxDate = dateBeans.getYearMonthDay();
	dateBeans.setAdjDate(-7);
	String sql = "",CREATED_BY="",parOrgID="";
	int iMaxLine = 0,v_loop_cnt=0,v_order_loop=0;  //add v_loop_cnt by Peggy 20181207
	String v_onhand="0",V_ERP_ORDER_TYPE="",ONHAND_ORDER_TYPE="1215",ONHAND_ORDER_TYPE_HQ="1151";
	Hashtable hashtb = new Hashtable();
	float v_used_qty =0;

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

		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate();
		pstmt1.close();

		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		cs1.setString(1,"41");
		cs1.execute();
		cs1.close();

		sql = " select a.by_code,a.dp_code,a.currency_code,b.sales_area_no,CASE WHEN a.currency_code='USD' AND a.erp_customer_id=7147 THEN b.SHIP_TO_SITE_ID1 ELSE  b.SHIP_TO_SITE_ID END as SHIP_TO_SITE_ID,'('||c.sales_area_no||')'||c.sales_area_name as SALESAREA,"+
              "'('||d.customer_number||')'||d.customer_name as CUSTNAME,d.ATTRIBUTE2 market_group,d.customer_name,c.PAR_ORG_ID"+
			  ",nvl(b.MAIL_TO_CUST_FLAG,'N') MAIL_TO_CUST_FLAG"+ //add by Peggy 20140721
			  ",nvl(b.MIN_ORDER_FLAG,'N') MIN_ORDER_FLAG,nvl(b.MIN_ORDER_AMT,0) MIN_ORDER_AMT,nvl(b.MIN_ORDER_CURR,'') MIN_ORDER_CURR"+ //add by Peggy 20140801
              " from TSC_EDI_ORDERS_HIS_H a,TSC_EDI_CUSTOMER b,oraddman.tssales_area c,ar_customers d"+
              " where a.request_no=?"+
              " AND A.erp_customer_id=?"+
              " AND A.customer_po=?"+
              " AND A.erp_customer_id=b.customer_id"+
              " AND b.sales_area_no=c.sales_area_no"+
              " AND b.customer_id=d.customer_id";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,REQUESTNO);
		statement.setString(2,ERPCUSTOMERID);
		statement.setString(3,CUSTPO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			SALESAREANO = rs.getString("sales_area_no");
			CURRENCY = rs.getString("currency_code");
			RFQTYPE = "EDI";
			BY_CODE=rs.getString("BY_CODE");
			DP_CODE=rs.getString("DP_CODE");
			SHIPTOID = rs.getString("ship_to_site_id");
			SALESAREA = rs.getString("SALESAREA");
			CUSTNAME = rs.getString("CUSTNAME");
			CREATED_BY = UserName;
			CUSTMARKETGROUP =rs.getString("MARKET_GROUP");
			CUSTOMER_NAME = rs.getString("customer_name");
			parOrgID=rs.getString("PAR_ORG_ID");
			MAIL_TO_CUST_FLAG = rs.getString("MAIL_TO_CUST_FLAG"); //add by Peggy 20140721
			MIN_ORDER_FLAG=rs.getString("MIN_ORDER_FLAG");         //add by Peggy 20140801
			MIN_ORDER_AMT =rs.getString("MIN_ORDER_AMT");          //add by Peggy 20140801
			MIN_ORDER_CURR = rs.getString("MIN_ORDER_CURR");       //add by Peggy 20140801

  			Statement statement1=con.createStatement();
       		sql = "select b.PRIMARY_SALESREP_ID, c.NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,jtf_rs_salesreps c "+
		              "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and a.CUST_ACCOUNT_ID ='"+ERPCUSTOMERID+"' "+
					  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID "+
					  "and a.ORG_ID ='"+parOrgID+"' and a.SHIP_TO_FLAG='P' "+
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
					  " AND su.SITE_USE_ID ='"+ SHIPTOID+"'";  //modify by Peggy 20140718
					  //" ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+ERPCUSTOMERID+"',1,2)";
			ResultSet rsy=statementy.executeQuery(sql);
			if (rsy.next())
			{
				SHIPTOCONTACT = rsy.getString("contact_name");
				SHIPTOCONTACTID= rsy.getString("contact_id");
			}
			rsy.close();
			statementy.close();

			sql = " select b.SITE_USE_CODE, b.site_use_id,b.PAYMENT_TERM_ID,b.FOB_POINT, b.PRICE_LIST_ID,b.tax_code"+
			      " from hz_cust_acct_sites_all a,hz_cust_site_uses_all b,so_price_lists c"+
                  " where a.cust_account_id=?"+
                  " and a.cust_acct_site_id=b.cust_acct_site_id"+
                  " and b.status='A'"+
                  " and ((b.SITE_USE_CODE ='BILL_TO' AND b.attribute2=?)"+
				  " OR (b.SITE_USE_CODE='DELIVER_TO' AND b.attribute2=?))"+
                  " and b.PRICE_LIST_ID = c.PRICE_LIST_ID(+)"+
                  " and c.currency_code=?";
			PreparedStatement statementb = con.prepareStatement(sql);
			statementb.setString(1,ERPCUSTOMERID);
			statementb.setString(2,BY_CODE);
			statementb.setString(3,DP_CODE);
			statementb.setString(4,CURRENCY);
			ResultSet rsb=statementb.executeQuery();
			while (rsb.next())
			{
				if (rsb.getString("SITE_USE_CODE").equals("BILL_TO"))
				{
					PAYTERMID = rsb.getString("PAYMENT_TERM_ID");
					FOB = rsb.getString("FOB_POINT");
					BILLTOID = rsb.getString("site_use_id");
					PRICELIST = rsb.getString("PRICE_LIST_ID");

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
					TAXCODE = rsb.getString("TAX_CODE"); //抓DELIVER_TO的TAX CODE,add by Peggy 20140414
				}
			}
			rsb.close();
			statementb.close();

			sql =" select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
				 " a.PAYMENT_TERM_ID, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID"+
				 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
				 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
				 " AND b.party_site_id = party_site.party_site_id"+
				 " AND loc.location_id = party_site.location_id "+
				 " and a.STATUS='A' "+
				 " and b.CUST_ACCOUNT_ID =?";
			PreparedStatement statementa = con.prepareStatement(sql);
			statementa.setString(1,ERPCUSTOMERID);
			ResultSet rsa=statementa.executeQuery();
			while (rsa.next())
			{
				if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO") && rsa.getString("SITE_USE_ID").equals(SHIPTOID))
				{
					SHIPTO = "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
				else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO") && rsa.getString("SITE_USE_ID").equals(BILLTOID))
				{
					BILLTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
				else if (rsa.getString("SITE_USE_CODE").equals("DELIVER_TO") && rsa.getString("SITE_USE_ID").equals(DELIVERYTOID))
				{
					DELIVERYTO =  "(" + rsa.getString("SITE_USE_ID")+")"+rsa.getString("ADDRESS1");
				}
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
		out.println(e.getMessage()+sql);
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
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCEDIORDERSDetail.jsp" METHOD="post" NAME="MYFORM">
<BR>
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">RFQ</font>
			<font style="font-size:20px;color:#000000;font-family:細明體"><strong>資料異常確認</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><a href="TSCEDIExceptionQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesArea"/></td>
					<td><input type="text" name="SALESAREA" value="<%=SALESAREA%>" size="40" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SALESAREANO" value="<%=SALESAREANO%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgRFQType"/></td>
					<td><input type="text" name="RFQTYPE" value="<%=RFQTYPE%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgSalesMan"/></td>
					<td><input type="text" name="SALES" value="<%=SALES%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SALESID" value="<%=SALESID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCustomerName"/></td>
					<td colspan="3"><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>"  size="40" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"><input type="hidden" name="CUSTOMER_NAME" value="<%=CUSTOMER_NAME%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgCurr"/></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgPaymentTerm"/></td>
					<td><input type="button" name="btnpay" value=".." onClick="subWindowPayTermFind(this.form.PAYTERMID.value)"><input type="text" name="PAYMENTTERM" value="<%=PAYMENTTERM%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (PAYMENTTERM==null||PAYMENTTERM==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="hidden" name="PAYTERMID" value="<%=PAYTERMID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></td>
					<td colspan="3"><input type="button" name="btnshipto" value=".." onClick="subWindowShipToFind('','SHIP_TO',this.form.ERPCUSTOMERID.value,this.form.SHIPTOID.value,this.form.SALESAREANO.value)"><input type="text" name="SHIPTO" value="<%=SHIPTO%>"  size="80" class="style4" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="SHIPTOID" value="<%=SHIPTOID%>"></td>
					<td class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td><input type="button" name="btnfob" value=".." onClick="subWindowFOBPointFind('',this.form.FOB.value,'HEADER')"><input type="text" name="FOB" value="<%=FOB%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (FOB==null||FOB==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly></td>
					<td class="style1">Tax Code</td>
					<td><input type="button" name="btntax" value=".." onClick="subWindowTaxCodeFind()"><input type="text" name="TAXCODE" value="<%=TAXCODE%>" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (TAXCODE==null||TAXCODE==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgBillTo"/></td>
					<td colspan="3"><input type="button" name="btntbillto" value=".." onClick="subWindowShipToFind('<%=BY_CODE%>','BILL_TO',this.form.ERPCUSTOMERID.value,this.form.BILLTOID.value,this.form.SALESAREANO.value)"><input type="text" name="BILLTO" value="<%=BILLTO%>" size="80" class="style4" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="BILLTOID" value="<%=BILLTOID%>"></td>
					<td class="style1">Ship To Contact</td>
					<td colspan="3"><input type="button" name="btntcontact" value=".." onClick="subWindowShipToContactFind()"><input type="text" name="SHIPTOCONTACT" value="<%=SHIPTOCONTACT%>" class="style4" size="50" onKeyDown="return (event.keyCode!=8);" <%if (SHIPTOCONTACT==null||SHIPTOCONTACT==""){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="hidden" name="SHIPTOCONTACTID" value="<%=SHIPTOCONTACTID%>"></td>
				</tr>
				<tr>
					<td class="style1"><jsp:getProperty name="rPH" property="pgDeliverTo"/></td>
					<td colspan="3"><input type="button" name="btntdeliverto" value=".." onClick="subWindowShipToFind('<%=DP_CODE%>','DELIVER_TO',this.form.ERPCUSTOMERID.value,this.form.DELIVERYTOID.value,this.form.SALESAREANO.value)"><input type="text" name="DELIVERYTO" value="<%=DELIVERYTO%>" size="80" class="style4" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="DELIVERYTOID" value="<%=DELIVERYTOID%>"></td>
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
					<td class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td colspan="7"><input type="text" name="REMARK" value="<%=REMARK%>" size="80" class="style4"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr>
					<td colspan="19" class="style1"><jsp:getProperty name="rPH" property="pgDetail"/></td>
				</tr>
				<tr>
					<td width="2%" class="style1"><input type="checkbox" name="CHKBOXALL" value="" onClick="chkall();"></td>
					<td width="2%" class="style1">Line No</td>
					<td width="2%" class="style1"><jsp:getProperty name="rPH" property="pgCustPOLineNo"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgCustItemNo"/></td>
					<td width="12%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/></td>
					<td width="8%" class="style1"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgItemDesc"/></td>
					<td width="8%" class="style1">End Cust PartNo</td>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgQty"/>/<jsp:getProperty name="rPH" property="pgUOM"/>:</font><font color="#FF0000"><jsp:getProperty name="rPH" property="pgKPC"/></font></td>
					<td width="5%" class="style1">Selling Price</td>
					<td width="5%" class="style1">CRD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgShippingMethod"/></td>
					<td width="6%" class="style1">SSD</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgProdFactory"/></td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgFirmOrderType"/></td>
					<td width="5%" class="style1">Line Type</td>
					<td width="6%" class="style1"><jsp:getProperty name="rPH" property="pgFOB"/></td>
					<td width="6%" class="style1">Quote#</td>
					<td width="5%" class="style1"><jsp:getProperty name="rPH" property="pgRemark"/></td>
					<td width="3%" class="style1">Mailed</td>
				</tr>
				<%
				try
				{
					sql = " select SEQ_NO,CUST_PO_LINE_NO"+
					      //",nvl(END_CUSTOMER_ITEM,CUST_ITEM_NAME) CUST_ITEM_NAME"+ //add by Peggy 20160127
					      ",CUST_ITEM_NAME"+ //add by Peggy 20160127
					      ",TSC_ITEM_NAME, QUANTITY,UOM,UNIT_PRICE ,CUST_REQUEST_DATE "+
					      ",QUOTE_NUMBER"+ //add by Peggy 20140430
						  ",QUANTITY*UNIT_PRICE ORDER_AMT"+ //add by Peggy 20140801
						  ",to_char(MAILED_DATE,'yyyy-mm-dd hh24:mi') MAILED_DATE"+  //add by Peggy 20140721
						  //",CASE WHEN ORIG_CUST_ITEM_NAME <> CUST_ITEM_NAME AND ORIG_CUST_ITEM_NAME IS NOT NULL  THEN ORIG_CUST_ITEM_NAME ELSE NULL END END_CUSTOMER_ITEM"+
						  ",ORIG_CUST_ITEM_NAME END_CUSTOMER_ITEM"+
						  ",ORIG_CUST_REQUEST_DATE"+ //add by Peggy 20210311
					      " from tsc_edi_orders_his_d a"+
                          " where REQUEST_NO =?"+
                          " and ERP_CUSTOMER_ID=?"+
                          " and DATA_FLAG=?"+
                          " and DNDOCNO is null"+
                          " and LINE_NO is null"+
						  " ORDER BY TO_NUMBER(cust_po_line_no)";
					//out.println(sql);
					PreparedStatement statementb = con.prepareStatement(sql);
					statementb.setString(1,REQUESTNO);
					statementb.setString(2,ERPCUSTOMERID);
					statementb.setString(3,"N");
					ResultSet rsb=statementb.executeQuery();
					iMaxLine =0;
					boolean exp_flag=false;
					float qty =0,moq =0,spq=0;
					String SEQ_NO ="",CUST_PO_LINE_NO ="",ORDER_ITEM="",TSC_ITEM_DESC="",QUANTITY="",ORDER_UOM="",SELLING_PRICE="",CRD="",ORIG_CRD="";
					String ORDER_ITEM_ID="",INVENTORY_ITEM_ID="",TSC_ITEM_NAME="",UOM="",ASSIGN_MANUFACT="",ORDER_TYPE="",PACKAGE_CODE="",FAMILY_CODE="",TSC_PROD_GROUP="",CATEGORY_ITEM="",ITEM_ID_TYPE="",YEW_FLAG="";
					String QUOTE_NUMBER="";//add by Peggy 20140430
					String MOQ="",SPQ="",SHIPPING_METHOD="",SSD="",ORDER_TYPE_ID="",LINE_TYPE="",END_CUSTOMER_ITEM="";
					int item_cnt =0;
					while(rsb.next())
					{
						iMaxLine ++;
						SEQ_NO = rsb.getString("SEQ_NO");
						CUST_PO_LINE_NO = rsb.getString("CUST_PO_LINE_NO");
						ORDER_ITEM = rsb.getString("CUST_ITEM_NAME");
						TSC_ITEM_DESC = rsb.getString("TSC_ITEM_NAME");
						//QUANTITY = rsb.getString("QUANTITY");
						QUANTITY = (rsb.getString("UOM").equals("PCE")?""+(Float.parseFloat(rsb.getString("QUANTITY"))/1000):rsb.getString("QUANTITY")); //modify by Peggy 20130910
						ORDER_UOM = rsb.getString("UOM");
						SELLING_PRICE = rsb.getString("UNIT_PRICE");
						CRD = rsb.getString("CUST_REQUEST_DATE");
						QUOTE_NUMBER = rsb.getString("QUOTE_NUMBER"); //add by Peggy 20140430
						TOT_ORDER_AMT += rsb.getFloat("ORDER_AMT");    //add by Peggy 20140801
						END_CUSTOMER_ITEM = rsb.getString("END_CUSTOMER_ITEM"); //add by Peggy 20190225
						ORIG_CRD = rsb.getString("ORIG_CUST_REQUEST_DATE"); //add by Peggy 20210311
						item_cnt=0;
						ORDER_ITEM_ID="";INVENTORY_ITEM_ID="";TSC_ITEM_NAME="";UOM="";ASSIGN_MANUFACT="";ORDER_TYPE="";PACKAGE_CODE="";FAMILY_CODE="";TSC_PROD_GROUP="";CATEGORY_ITEM="";ITEM_ID_TYPE="";YEW_FLAG="";
						v_loop_cnt =0;  //add by Peggy 20181207

						//-ON型號CHECK,add by Peggy 20181207
						while(v_loop_cnt <4)
						{
							if (v_loop_cnt!=0)
							{
								// TSCE客戶不要自動帶出 ON SEMI PN from Emily Issue,Add by JB 20250505
								sql = " select * from tsc_edi_orders_his_d a, APPS.TSC_EDI_CUSTOMER e"+
										" where a.ERP_CUSTOMER_ID = e.CUSTOMER_ID"+
										" and a.REQUEST_NO =?"+
										" and a.ERP_CUSTOMER_ID =?"+
										" and a.DATA_FLAG=?"+
										" and REGION1 <> ?";
								PreparedStatement statementxx = con.prepareStatement(sql);
								statementxx.setString(1,REQUESTNO);
								statementxx.setString(2,ERPCUSTOMERID);
								statementxx.setString(3,"N");
								statementxx.setString(4,"TSCE");
								ResultSet rsxx=statementxx.executeQuery();
								if (rsxx.next())
								{
									//檢查客戶品號是否為-ON型號
									sql = " SELECT DISTINCT msi.DESCRIPTION,a.cust_partno "+
											" FROM INV.MTL_SYSTEM_ITEMS_B msi"+
											",oraddman.ts_label_onsemi_item A"+
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
									statementc.setString(1,(v_loop_cnt==1?ORDER_ITEM:TSC_ITEM_DESC));
									ResultSet rsc=statementc.executeQuery();
									if (rsc.next())
									{
										ORDER_ITEM=rsc.getString("cust_partno");
										TSC_ITEM_DESC=rsc.getString("description");

										sql = " update tsc_edi_orders_his_d a"+
												" set TSC_ITEM_NAME =?"+
												" ,CUST_ITEM_NAME=?"+
												" where a.erp_customer_id=?"+
												" and a.REQUEST_NO=?"+
												" and a.SEQ_NO=?";
										PreparedStatement pstmtDt2=con.prepareStatement(sql);
										pstmtDt2.setString(1,TSC_ITEM_DESC);
										pstmtDt2.setString(2,ORDER_ITEM);
										pstmtDt2.setString(3,ERPCUSTOMERID);
										pstmtDt2.setString(4,REQUESTNO);
										pstmtDt2.setString(5,rsb.getString("SEQ_NO"));
										pstmtDt2.executeUpdate();
										pstmtDt2.close();
									}
									rsc.close();
									statementc.close();
								}
								rsxx.close();
								statementxx.close();


							}
							v_loop_cnt++;

							PreparedStatement statementc =null;
							if (ORDER_ITEM.equals(TSC_ITEM_DESC) && ERPCUSTOMERID.equals("7147"))
							{
								sql = " SELECT msi.INVENTORY_ITEM_ID item_id"+
									  " ,msi.INVENTORY_ITEM_ID"+
									  " ,msi.segment1 INVENTORY_ITEM"+
									  " ,msi.PRIMARY_UOM_CODE"+
									  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									  ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) AS ORDER_TYPE"+  //modify by Peggy 20191122
									  " ,NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
									  " ,NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
									  " ,CASE WHEN NVL(msi.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
									  " ,'INT' item_identifier_type"+
									  " ,c.SEGMENT1"+
									  " ,msi.creation_date"+ //20130820 add by Peggy
									  " ,(SELECT COUNT(1) FROM INV.MTL_SYSTEM_ITEMS_B MSIB WHERE MSIB.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID AND MSIB.ORGANIZATION_ID=327) YEW_FLAG "+ //ADD BY PEGGY 20170425
									  " ,count(1) over (partition by 1) ROW_CNT"+  //add by Peggy 20210911
									  " from inv.mtl_system_items_b msi"+
									  " ,APPS.MTL_ITEM_CATEGORIES_V c"+
									  " ,oraddman.tsprod_manufactory d"+ //by Peggy 20151209
									  " where msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID"+
									  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID"+
									  " and msi.ORGANIZATION_ID = '49'"+
									  " and msi.attribute3=d.MANUFACTORY_NO(+)"+
									  " and c.CATEGORY_SET_ID = 6"+
									  " and msi.inventory_item_status_code <> 'Inactive'"+
									  " and msi.description = ?"+
									  " and msi.segment1 not like '%FA2'"+ //排除conti料號,add by Peggy 20210911
									  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"+ //add by Peggy 20230215
									  " and tsc_get_item_coo(msi.inventory_item_id) =(\n" + //add by Mars 20250108
									  "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
									  "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+ //add by Mars 20250108
									  " order by msi.creation_date desc";
						 			statementc = con.prepareStatement(sql);
									statementc.setString(1,TSC_ITEM_DESC);
							}
							else
							{
								sql = " SELECT x.* FROM (SELECT a.item_id"+
									  " ,a.INVENTORY_ITEM_ID"+
									  " ,a.INVENTORY_ITEM"+
									  " ,msi.PRIMARY_UOM_CODE"+
									  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
									  //",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
									  ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) AS ORDER_TYPE"+  //modify by Peggy 20191122
									  " ,NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
									  " ,NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_Family')) as TSC_FAMILY"+
									  " ,CASE WHEN NVL(msi.attribute3, 'N/A') in ('008','002') THEN d.TSC_PROD_GROUP ELSE NVL(TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_PROD_GROUP'),TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,43,'TSC_PROD_GROUP')) END as TSC_PROD_GROUP"+
									  " ,a.item_identifier_type"+
									  " ,c.SEGMENT1"+
									  " ,msi.creation_date"+ //20130820 add by Peggy
									  //", a.RANK"+
									  " ,(SELECT COUNT(1) FROM INV.MTL_SYSTEM_ITEMS_B MSIB WHERE MSIB.INVENTORY_ITEM_ID=msi.INVENTORY_ITEM_ID AND MSIB.ORGANIZATION_ID=327) YEW_FLAG "+ //ADD BY PEGGY 20170425
									  " ,rank() over (partition by a.item_id order by a.RANK) row_rank"+
									  " ,count(1) over (partition by 1) ROW_CNT"+  //add by Peggy 20210911
									  " from oe_items_v a"+
									  " ,inv.mtl_system_items_b msi"+
									  " ,APPS.MTL_ITEM_CATEGORIES_V c"+
									  " ,oraddman.tsprod_manufactory d"+ //by Peggy 20151209
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
									  " and a.item = ?"+
									  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"+ //add by Peggy 20230215
									  " and tsc_get_item_coo(msi.inventory_item_id) =(\n" + //add by Mars 20250108
									  "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
									  "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+ //add by Mars 20250108
									  " and case when ?='' OR ? IS NULL then 'XXX' ELSE a.item_description END = case when ?='' or ? IS NULL then 'XXX' ELSE ? END) x where row_rank=1";
									  //" order by msi.creation_date DESC"; //20130820 add by Peggy,當客戶品名+台半品名對應一個以上台半料號時,以最近create的料號為優先
						 			statementc = con.prepareStatement(sql);
									statementc.setString(1,ERPCUSTOMERID);
									statementc.setString(2,ORDER_ITEM );
									statementc.setString(3,TSC_ITEM_DESC);
									statementc.setString(4,TSC_ITEM_DESC);
									statementc.setString(5,TSC_ITEM_DESC);
									statementc.setString(6,TSC_ITEM_DESC);
									statementc.setString(7,TSC_ITEM_DESC);
							}
							//out.println(sql);
							//PreparedStatement statementc = con.prepareStatement(sql);
							//statementc.setString(1,ERPCUSTOMERID);
							//statementc.setString(2,ORDER_ITEM );
							//statementc.setString(3,TSC_ITEM_DESC);
							//statementc.setString(4,TSC_ITEM_DESC);
							//statementc.setString(5,TSC_ITEM_DESC);
							//statementc.setString(6,TSC_ITEM_DESC);
							//statementc.setString(7,TSC_ITEM_DESC);
							ResultSet rsc=statementc.executeQuery();
							while(rsc.next())
							{
								//拿掉from emily by Peggy 20220425
								//add by Peggy 20171220
								//if (ERPCUSTOMERID.equals("1889"))
								//{
								//	if (rsc.getString("TSC_PACKAGE").equals("SMA") || rsc.getString("TSC_PACKAGE").equals("SMB"))
								//	{
								//		continue;
								//	}
								//}
								item_cnt++;
								//if (item_cnt ==1)
								if (item_cnt ==1 && rsc.getInt("ROW_CNT")==1) //加ROW_CNT=1 by Peggy 20210911
								{
									ORDER_ITEM_ID=rsc.getString("item_id");
									INVENTORY_ITEM_ID=rsc.getString("INVENTORY_ITEM_ID");
									TSC_ITEM_NAME=rsc.getString("INVENTORY_ITEM");
									UOM=rsc.getString("PRIMARY_UOM_CODE");
									ASSIGN_MANUFACT=rsc.getString("ATTRIBUTE3");
									ORDER_TYPE=rsc.getString("ORDER_TYPE");
									V_ERP_ORDER_TYPE=rsc.getString("ORDER_TYPE");
									PACKAGE_CODE=rsc.getString("TSC_PACKAGE");
									FAMILY_CODE=rsc.getString("TSC_FAMILY");
									TSC_PROD_GROUP=rsc.getString("TSC_PROD_GROUP");
									CATEGORY_ITEM=rsc.getString("SEGMENT1");
									ITEM_ID_TYPE=rsc.getString("item_identifier_type");
									YEW_FLAG=rsc.getString("YEW_FLAG"); //add by Peggy 20170425
								}
								v_loop_cnt=4; //add by Peggy 20181207
							}
							rsc.close();
							statementc.close();
						}

						//add by Peggy 20190307,end cust partno=cust partno時,end cust partno顯示空白
						if (END_CUSTOMER_ITEM.equals(ORDER_ITEM))
						{
							END_CUSTOMER_ITEM="";
						}

						//modify by Peggy 20150721
						CallableStatement cse = con.prepareCall("{call tsc_edi_pkg.GET_SPQ_MOQ(?,?,?,?)}");
						cse.setString(1,INVENTORY_ITEM_ID);
						cse.setString(2,ASSIGN_MANUFACT);
						cse.registerOutParameter(3, Types.VARCHAR);
						cse.registerOutParameter(4, Types.VARCHAR);
						cse.execute();
						SPQ = ""+(cse.getFloat(3)/1000);
						MOQ = ""+(cse.getFloat(4)/1000);
						cse.close();

						v_order_loop=1;
						while(v_order_loop <=2)  //check I6 14倉onhand,add by Peggy 20190520
						{
							if (v_order_loop ==1)
							{
								//add by Peggy 20190520,check onhand
								sql = " SELECT TSC_EDI_PKG.GET_ONSEMI_ONHAND(?,?) from dual";
								PreparedStatement statementd = con.prepareStatement(sql);
								statementd.setString(1,INVENTORY_ITEM_ID);
								statementd.setString(2,"KPC");
								ResultSet rsd=statementd.executeQuery();
								if(rsd.next())
								{
									v_onhand = rsd.getString(1);
								}
								rsd.close();
								statementd.close();

								//檢查已被book的庫存 start
								if ((String)hashtb.get(INVENTORY_ITEM_ID)==null)
								{
									v_used_qty =0;
								}
								else
								{
									v_used_qty = Float.parseFloat((String)hashtb.get(INVENTORY_ITEM_ID));
								}
								v_onhand = ""+((Float.parseFloat(v_onhand)*1000)-v_used_qty);
								v_onhand = ""+(Float.parseFloat(v_onhand)/1000);
								//檢查已被book的庫存 end

								if (Float.parseFloat(v_onhand)>0)
								{
									ORDER_TYPE = ONHAND_ORDER_TYPE;
									if (Float.parseFloat(QUANTITY) > Float.parseFloat(v_onhand))
									{
										QUANTITY = v_onhand;
									}
									hashtb.put(INVENTORY_ITEM_ID,""+(v_used_qty+(Float.parseFloat(QUANTITY)*1000)));
								}
								else
								{
									v_order_loop=2;
								}
							}
							else
							{
								iMaxLine++;
								ORDER_TYPE = V_ERP_ORDER_TYPE;
								QUANTITY =(rsb.getString("UOM").equals("PCE")?""+((rsb.getFloat("QUANTITY")-(Float.parseFloat(v_onhand)*1000))/1000):""+(rsb.getFloat("QUANTITY")-(Float.parseFloat(v_onhand)*1000)));
								if (Float.parseFloat(QUANTITY)<0) QUANTITY="0"; //add by Peggy 20190618
							}

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

							CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}");  //modify by Peggy 20160513
							csf.setString(1,SALESAREANO);
							csf.setString(2,PACKAGE_CODE);
							csf.setString(3,FAMILY_CODE);
							csf.setString(4,TSC_ITEM_DESC);
							csf.setString(5,CRD);
							csf.registerOutParameter(6, Types.VARCHAR);
							csf.setString(7,ORDER_TYPE);
							csf.setString(8,ASSIGN_MANUFACT);
							csf.setString(9,ERPCUSTOMERID);     //add by Peggy 20160513
							csf.setString(10,FOB);       //add by Peggy 20190319
							csf.setString(11,DELIVERYTOID);        //add by Peggy 20190319

							csf.execute();
							SHIPPING_METHOD = csf.getString(6);
							csf.close();

							CallableStatement csg = con.prepareCall("{call tsc_edi_pkg.GET_SSD(?,?,?,?,?,?,?,sysdate,?,?)}");
							csg.setString(1,SALESAREANO);
							csg.setString(2,ASSIGN_MANUFACT);
							csg.setString(3,CRD);
							csg.setString(4,SHIPPING_METHOD);
							csg.setString(5,ORDER_TYPE);
							csg.registerOutParameter(6, Types.VARCHAR);
							csg.setString(7,ERPCUSTOMERID);
							csg.setString(8,FOB);   //add by Peggy 20210207
							csg.setString(9,DELIVERYTOID);   //add by Peggy 20210217
							csg.execute();
							SSD = csg.getString(6);
							csg.close();

							if (v_order_loop==2)
							{
								if (SPQ.equals("0") || MOQ.equals("0") || ((Float.parseFloat(QUANTITY)*1000)%(Float.parseFloat(SPQ)*1000)) !=0 || Float.parseFloat(QUANTITY)<Float.parseFloat(MOQ))
								{
									exp_flag=true;
								}
								else
								{
									exp_flag=false;
								}
							}
							v_order_loop ++;
					%>
						<tr>
							<td><input type="checkbox" name="CHKBOX" value="<%=iMaxLine%>"><input type="hidden" name="SEQ_NO_<%=iMaxLine%>" value="<%=SEQ_NO%>"></td>
							<td><input type="text" name="LINE_NO_<%=iMaxLine%>" value="<%=iMaxLine%>"  size="2" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
							<td><input type="text" name="CUST_PO_LINE_NO_<%=iMaxLine%>" value="<%=CUST_PO_LINE_NO%>" size="4" class="style2" onKeyDown="return (event.keyCode!=8);" readonly></td>
							<td><input type="text" name="CUST_ITEM_<%=iMaxLine%>" value="<%=ORDER_ITEM%>" size="10" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (ORDER_ITEM ==null||ORDER_ITEM.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btncustitem_<%=iMaxLine%>" value=".." onClick="subWindowCustItemFind('<%=iMaxLine%>',this.form.ERPCUSTOMERID.value,this.form.TSC_ITEM_DESC_<%=iMaxLine%>.value,this.form.CUST_ITEM_<%=iMaxLine%>.value,this.form.SALESAREANO.value,this.form.ORDER_TYPE_<%=iMaxLine%>.value,this.form.CUSTMARKETGROUP.value,this.form.CRD_<%=iMaxLine%>.value,this.form.ERPCUSTOMERID.value,this.form.LINE_FOB_<%=iMaxLine%>.value)">
							<input type="hidden" name="CUST_ITEM_ID_<%=iMaxLine%>" value="<%=ORDER_ITEM_ID%>">
							<input type="hidden" name="ITEM_ID_TYPE_<%=iMaxLine%>" value="<%=ITEM_ID_TYPE%>">
							<input type="hidden" name="CATEGORY_ITEM_<%=iMaxLine%>" value="<%=CATEGORY_ITEM%>">
							<input type="hidden" name="ORIG_CUST_ITEM_<%=iMaxLine%>" value="<%=ORDER_ITEM%>"></td>
							<td><input type="text" name="TSC_ITEM_<%=iMaxLine%>" value="<%=TSC_ITEM_NAME%>" size="23" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (TSC_ITEM_NAME==null||TSC_ITEM_NAME.equals("")||item_cnt >1){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" id="btnitem_<%=iMaxLine%>" name="btnitem_<%=iMaxLine%>" value=".." onClick="subWindowItemFind('<%=iMaxLine%>',this.form.TSC_ITEM_<%=iMaxLine%>.value,this.form.TSC_ITEM_DESC_<%=iMaxLine%>.value,'N',this.form.ERPCUSTOMERID.value,this.form.SALESAREANO.value,this.form.ORDER_TYPE_<%=iMaxLine%>.value,this.form.CUSTMARKETGROUP.value,this.form.CRD_<%=iMaxLine%>.value,this.form.ERPCUSTOMERID.value,this.form.LINE_FOB_<%=iMaxLine%>.value)">
							<input type="hidden" name="TSC_ITEM_ID_<%=iMaxLine%>" value="<%=INVENTORY_ITEM_ID%>">
							<input type="hidden" name="TSC_ITEM_PACKAGE_<%=iMaxLine%>" value="<%=PACKAGE_CODE%>">
							<input type="hidden" name="TSC_PROD_GROUP_<%=iMaxLine%>" value="<%=TSC_PROD_GROUP%>"></td>
							<td><input type="text" name="TSC_ITEM_DESC_<%=iMaxLine%>" value="<%=TSC_ITEM_DESC%>"  size="18" class="style4">
							<input type="hidden" name="UOM_<%=iMaxLine%>" value="<%=UOM%>"><input type="hidden" name="YEW_FLAG_<%=iMaxLine%>" value="<%=YEW_FLAG%>"></td>
							<td><input type="text" name="END_CUST_ITEM_<%=iMaxLine%>" value="<%=(END_CUSTOMER_ITEM==null?"":END_CUSTOMER_ITEM)%>"  size="14" class="style4" onKeypress="return event.keyCode=-1"></td>
							<td><input type="text" name="QUANTITY_<%=iMaxLine%>" value="<%=QUANTITY%>" size="3" class="style4"  <%if (exp_flag){out.println("style='background-color:#FFFF66'");}else{if(ORDER_TYPE.equals(ONHAND_ORDER_TYPE)){out.println("style='color:#0000ff;font-weight:bold;background-color:#FFCCCC'");}else{out.println("style='background-color:#FFFFFF'");}}%> >
							<%
							if (ORDER_TYPE.equals(ONHAND_ORDER_TYPE))
							{
							%>
								<font color='#0000FF' face = 'Arial'><strong>Stock:<input type="text" name="Stock_<%=iMaxLine%>" size="2" align="right" style="border:0;color:#0000FF; text-decoration: underline ;font:'Comic Sans MS'; font-style:italic;"  value="<%=v_onhand%>" readonly>K</strong></font>
								<input type="hidden" name="MOQ_<%=iMaxLine%>" value="<%=MOQ%>">
							<%
							}
							else
							{
							%>
								<font color='#FF0000' face = 'Arial'><strong>MOQ:<input type="text" name="MOQ_<%=iMaxLine%>" size="2" align="right" style="border:0;color:#FF0000; text-decoration: underline ;font:'Comic Sans MS'; font-style:italic;"  value="<%=MOQ%>" readonly>K</strong></font>
							<%
							}
							%>
							<input type="hidden" name="SPQ_<%=iMaxLine%>" value="<%=SPQ%>"></td>
							<td><input type="text" name="SELLINGPRICE_<%=iMaxLine%>" value="<%=SELLING_PRICE%>" size="4" class="style4" onKeyDown="return (event.keyCode!=8);" readonly></td>
							<td><input type="text" name="CRD_<%=iMaxLine%>" value="<%=CRD%>" size="6" class="style4" onBlur="setCRD(<%=iMaxLine%>)" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" <%if (Long.parseLong(CRD)<Long.parseLong(SYSTEMDATE)){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> ><input type="hidden" name="ORIG_CRD_<%=iMaxLine%>" value="<%=ORIG_CRD%>"></td>
							<td><input type="text" name="SHIPPINGMETHOD_<%=iMaxLine%>" value="<%=(SHIPPING_METHOD==null?"":SHIPPING_METHOD)%>" size="6" class="style4" onKeyDown="return (event.keyCode!=8);" <%if (SHIPPING_METHOD==null||SHIPPING_METHOD.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnshippingmethod" value=".." onClick="subWindowSSDFind('<%=iMaxLine%>',1,this.form.PLANTCODE_<%=iMaxLine%>.value)"></td>
							<td><input type="text" name="SSD_<%=iMaxLine%>" value="<%=(SSD==null?"":SSD)%>" size="7" class="style4" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" <%if (SSD==null||SSD.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%>><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SSD_<%=iMaxLine%>);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
							<td><input type="text" name="PLANTCODE_<%=iMaxLine%>" value="<%=ASSIGN_MANUFACT%>" class="style4" size="2" onKeyDown="return (event.keyCode!=8);" <%if (ASSIGN_MANUFACT==null||ASSIGN_MANUFACT.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnplat" value=".." onClick="subWindowPlantFind('<%=iMaxLine%>',this.form.PLANTCODE_<%=iMaxLine%>.value)" <%=(ORDER_TYPE.equals(ONHAND_ORDER_TYPE)?" disabled":"")%>></td>
							<td><input type="text" name="ORDER_TYPE_<%=iMaxLine%>" value="<%=ORDER_TYPE%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" <%if (ORDER_TYPE==null||ORDER_TYPE.equals("")){out.println("style='background-color:#FFFF66'");}else{if(ORDER_TYPE.equals(ONHAND_ORDER_TYPE)){out.println("style='color:#0000ff;font-weight:bold;background-color:#FFCCCC'");}else{out.println("style='background-color:#FFFFFF'");}}%> readonly><input type="button" name="btnordertype" value=".." onClick="subWindowOrderTypeFind('<%=iMaxLine%>',this.form.ORDER_TYPE_<%=iMaxLine%>.value,this.form.SALESAREANO.value,this.form.PLANTCODE_<%=iMaxLine%>.value)" <%=(ORDER_TYPE.equals(ONHAND_ORDER_TYPE)?" disabled":"")%>></td>
							<td><input type="text" name="LINE_TYPE_<%=iMaxLine%>" value="<%=LINE_TYPE%>" class="style4" size="3" onKeyDown="return (event.keyCode!=8);" <%if (LINE_TYPE==null||LINE_TYPE.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnlinetype" value=".." onClick="subWindowLineTypeFind('<%=iMaxLine%>',this.form.LINE_TYPE_<%=iMaxLine%>.value,this.form.SALESAREANO.value,this.form.ORDER_TYPE_<%=iMaxLine%>.value)" <%=(ORDER_TYPE.equals(ONHAND_ORDER_TYPE)?" disabled":"")%>></td>
							<td><input type="text" name="LINE_FOB_<%=iMaxLine%>" value="<%=FOB%>"  class="style4" size="6" onKeyDown="return (event.keyCode!=8);" <%if (FOB==null||FOB.equals("")){out.println("style='background-color:#FFFF66'");}else{out.println("style='background-color:#FFFFFF'");}%> readonly><input type="button" name="btnlinefob" value=".." onClick="subWindowFOBPointFind('<%=iMaxLine%>',this.form.LINE_FOB_<%=iMaxLine%>.value,'LINE')"></td>
							<td><input type="text" name="QUOTE_NUMBER_<%=iMaxLine%>" value="<%=(QUOTE_NUMBER==null?"":QUOTE_NUMBER)%>"  class="style4" size="10" readonly>
							<td><input type="text" name="REMARK_<%=iMaxLine%>" value="" size="8" class="style4"></td>
							<td align="center"><%=((rsb.getString("MAILED_DATE")==null || rsb.getString("MAILED_DATE").equals(""))?"&nbsp;":"<font color='#0000ff'>Y</font>")%></td>
						</tr>
					<%
						}
					}
					rsb.close();
					statementb.close();
				}
				catch(Exception e)
				{
					out.println("Exception4:"+e.getMessage()+sql);
				}

				%>
			</table>
		</td>
	</tr>
	<tr><td><HR></td></tr>
	<%
	if (MIN_ORDER_FLAG.equals("Y") && (TOT_ORDER_AMT < Float.parseFloat(MIN_ORDER_AMT) || !CURRENCY.equals(MIN_ORDER_CURR)))
	{
		String str_notice ="";
		out.println("<tr><td align='center'><font style='font-size:12px;color:#ff0000;font-weight:bold'>注意:");
		if (TOT_ORDER_AMT < Float.parseFloat(MIN_ORDER_AMT))
		{
			str_notice +=" 訂單總金額:"+TOT_ORDER_AMT+" < "+MIN_ORDER_AMT +" "+MIN_ORDER_CURR;
		}
		if (!CURRENCY.equals(MIN_ORDER_CURR))
		{
			str_notice +=" 幣別不符("+CURRENCY+" <> "+ MIN_ORDER_CURR+")";
		}
		out.println(str_notice+"</font></td></tr>");
	}
	%>
	<tr>
		<td>
			<table width="100%" border="1" bordercolordark="#ABC2AF" bordercolorlight="#FFFFFF" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgProcessUser"/></td>
					<td width="15%"><font color='#000099' face="Arial"><%=userID+"("+UserName+")"%></font> </td>
					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgProcessDate"/></td>
					<td width="15%"><font color="#000099" face="Arial"><%=dateBean.getYearMonthDay()%></font></td>
 					<td width="10%" class="style1"><jsp:getProperty name="rPH" property="pgAction"/></td>
					<td width="40%">
					<select name="ACTION_TYPE" style="font-family:Tahoma" onChange="subAction()">
					<option value=''>--</option>
					<option value='RFQ'>RFQ/ERP Order</option>
					<option value='CANCELLED'>Cancelled</option>
					<option value='PASS'>Pass</option>
					<%
					if (MAIL_TO_CUST_FLAG.equals("Y"))
					{
					%>
					<option value='MAIL_TO_CUST'>MAIL TO CUST</option>
					<%
					}
					%>
					</select>
					<INPUT TYPE="button" tabindex="41" value="Submit" name="btn1" onClick='setSubmit("../jsp/TSCEDIMProcess.jsp","../jsp/TSCEDIORDERSMail.jsp")' style="font-family:Tahoma,Georgia" >
					<INPUT TYPE="text" name="reason"  value="取消原因:"  size="8" style="border-left:none;border-top:none;border-bottom:none;border-right:none;visibility:hidden;font-family:Tahoma,Georgia;color:#FF0000;font-size:11px;" readonly>
					<input typ="text" name="cancel_remark" value="" size="30" style="visibility:hidden;font-family:Tahoma,Georgia;font-size:11px;">
					</td>
				</tr>
			</table>
		<td>
	</tr>
</table>
<input type="hidden" name="MAXLINE" value="<%=iMaxLine%>">
<input type="hidden" name="SYSTEMDATE" value="<%=SYSTEMDATE%>">
<input name="CUSTMARKETGROUP" type="hidden" value="<%=CUSTMARKETGROUP%>">
<input name="BY_CODE" type="hidden" value="<%=BY_CODE%>">
<input name="DP_CODE" type="hidden" value="<%=DP_CODE%>">
<input name="REQUESTNO" type="hidden" value="<%=REQUESTNO%>">
<input name="PROGRAMNAME" type="hidden" value="RFQCONFIRM">
<input name="ONHAND_ORDER_TYPE" type="hidden" value="<%=ONHAND_ORDER_TYPE%>">
<input name="ONHAND_ORDER_TYPE_HQ" type="hidden" value="<%=ONHAND_ORDER_TYPE_HQ%>">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
