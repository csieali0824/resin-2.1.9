<!-- 20160919 Peggy,新增bill_sequence_id-->
<!-- 20161107 Peggy,新增PRD外包-->
<!-- 20170817 Peggy,預計完工日移至表頭,取消line request date,新增暫不發料選項,及補發料功能-->
<!-- 20171012 Peggy,新增RD3工程入庫交易-->
<!-- 20171027 Peggy,新增RD5工程入庫交易-->
<!-- 20180124 Peggy,HOLD晶片轉工單生產-->
<!-- 20180528 Peggy,茂矽分批發料issue-->
<!-- 20180724 Peggy,新增晶片片號欄位for4056天水華天集團-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<title>委外加工單-修改</title>
<script language="JavaScript" type="text/JavaScript">
function setCopyLine(URL)
{
	document.MYFORM.txtLine.value="1";
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setAddLine(URL)
{
	var TXTLINE = document.MYFORM.txtLine.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入行數!");
		document.MYFORM.txtLine.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORM.txtLine.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>10)
		{
    		alert("行數新增範圍1~10!"); 
			document.MYFORM.txtLine.focus();
			return false;		
		}
	}
	
	if ( document.MYFORM.COPY_LINE.checked)
	{
		if (document.MYFORM.COPY_NUM.value=="")
		{
			alert("請輸入copy項次!");
			document.MYFORM.COPY_NUM.focus();
			return false;		
		}
		else
		{
			var regex = /^-?\d+$/;
			if ((document.MYFORM.COPY_NUM.value).match(regex)==null) 
			{ 
				alert("數量必須是整數數值型態!"); 
				document.MYFORM.COPY_NUM.focus();
				return false;
			} 
			else if (parseInt(document.MYFORM.COPY_NUM.value)>parseInt(document.MYFORM.LINENUM.value))
			{
				alert("項次最多只到"+document.MYFORM.LINENUM.value+",請認真輸入,謝謝!"); 
				document.MYFORM.COPY_NUM.focus();
				return false;		
			}	
		}	
	}

	document.MYFORM.action=URL+"&COPY_NUM="+document.MYFORM.COPY_NUM.value;
	document.MYFORM.submit();
}

function setDelete(objLine)
{
	if (confirm("您確定要刪除行號"+objLine+"所有資料嗎?"))
	{
		for (var i = objLine ; i <= document.MYFORM.LINENUM.value ; i++)
		{
			if ( i < document.MYFORM.LINENUM.value)
			{
				document.MYFORM.elements["Stock"+i].value = document.MYFORM.elements["Stock"+(i+1)].value;
				document.MYFORM.elements["INVITEM"+i].value = document.MYFORM.elements["INVITEM"+(i+1)].value;
				document.MYFORM.elements["INVITEMID"+i].value = document.MYFORM.elements["INVITEMID"+(i+1)].value;
				document.MYFORM.elements["LotOnhand"+i].value = document.MYFORM.elements["LotOnhand"+(i+1)].value;
				document.MYFORM.elements["WaferLot"+i].value = document.MYFORM.elements["WaferLot"+(i+1)].value;
				document.MYFORM.elements["WaferNumber"+i].value = document.MYFORM.elements["WaferNumber"+(i+1)].value;
				document.MYFORM.elements["ChipQty"+i].value = document.MYFORM.elements["ChipQty"+(i+1)].value;
				document.MYFORM.elements["WaferQty"+i].value = document.MYFORM.elements["WaferQty"+(i+1)].value;
				document.MYFORM.elements["DateCode"+i].value = document.MYFORM.elements["DateCode"+(i+1)].value;
				//document.MYFORM.elements["RequestSD"+i].value = document.MYFORM.elements["RequestSD"+(i+1)].value;
				document.MYFORM.elements["UseDateCode"+i].value = document.MYFORM.elements["UseDateCode"+(i+1)].value;
				document.MYFORM.elements["DC_YYWW"+i].value = document.MYFORM.elements["DC_YYWW"+(i+1)].value;
			}
			else
			{
				document.MYFORM.elements["Stock"+i].value = "";
				document.MYFORM.elements["INVITEM"+i].value = "";
				document.MYFORM.elements["INVITEMID"+i].value = "";
				document.MYFORM.elements["LotOnhand"+i].value = "";
				document.MYFORM.elements["WaferLot"+i].value = "";
				document.MYFORM.elements["WaferNumber"+i].value = "";
				document.MYFORM.elements["ChipQty"+i].value = "";
				document.MYFORM.elements["WaferQty"+i].value = "";
				document.MYFORM.elements["DateCode"+i].value = "";
				//document.MYFORM.elements["RequestSD"+i].value = "";
				document.MYFORM.elements["UseDateCode"+i].value ="";
				document.MYFORM.elements["DC_YYWW"+i].value = "";
			}
		}
		computeTotal("WaferQty");
		computeTotal("ChipQty");
	}
	else
	{
		return false;
	}
}
function CheckDataCode(chooseLine)
{
	//PRD排除在同型號D/C不重複之限制外,add by Peggy 20170609
	if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")<0)
	{
		var useDateCode = document.MYFORM.elements["UseDateCode"+chooseLine].value;
		var DateCode = document.MYFORM.elements["DateCode"+chooseLine].value.toUpperCase();
		var strlen = useDateCode.split(";");
		for (var i = 0 ; i< strlen.length ; i++)
		{
			//if (DateCode != null && DateCode != "" && strlen[i] == DateCode)
			if (DateCode != null && DateCode != "" && DateCode.toUpperCase() != "HOLD" && DateCode != "NA" && DateCode != "N/A" && strlen[i] == DateCode)
			{
				alert("DateCode:"+DateCode+"已使用過,請重新輸入!!");
				document.MYFORM.elements["DateCode"+chooseLine].value="";
				document.MYFORM.elements["DateCode"+chooseLine].focus();
				return false;
			}
		}
	}
	if (document.MYFORM.elements["DateCode"+chooseLine].value !="" && document.MYFORM.elements["DateCode"+chooseLine].value.toUpperCase() != "HOLD" && document.MYFORM.elements["DateCode"+chooseLine].value.toUpperCase() != "NA" && document.MYFORM.elements["DateCode"+chooseLine].value.toUpperCase() != "N/A")
	{
		subWin=window.open("../jsp/subwindow/TSCPMDDateCodeInfoFind.jsp?ITEMNAME="+document.MYFORM.elements["ITEMNAME"].value + "&PROD_GROUP="+document.MYFORM.elements["PROD_GROUP"].value + "&DC="+document.MYFORM.elements["DateCode"+chooseLine].value+"&LNO="+chooseLine,"subwin","width=100,height=100,scrollbars=yes,menubar=no,location=no");
	}
	else
	{
		document.MYFORM.elements["DC_YYWW"+chooseLine].value="";
	}	
}

function subWindowSupplierFind(supplierNo,supplierName,itemID,supplierSite)
{    
	subWin=window.open("../jsp/subwindow/TSCPMDSupplierInfoFind.jsp?SUPPLIERNO="+supplierNo+"&SUPPLIERNAME="+supplierName+"&ITEMID="+itemID+"&QTY="+Qty+"&SUPPLIERSITE="+supplierSite,"subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}	

function subWindowSubinventoryFind()
{    
	subWin=window.open("../jsp/subwindow/TSCPMDSubinventoryFind.jsp?","subwin","width=540,height=480,scrollbars=yes,menubar=no,location=no");
}	

function subWindowItemFind(itemName,itemDesc,Vendor,Qty,supplierSite)
{
	var wiptype =document.MYFORM.WIPTYPE.value;  //add by Peggy 20191021
	var REQUESTNO = document.MYFORM.REQUESTNO.value;
	subWin=window.open("../jsp/subwindow/TSCPMDItemInfoFind.jsp?ITEMNAME="+itemName+"&ITEMDESC="+itemDesc+"&VENDOR="+Vendor+"&QTY="+Qty+"&SUPPLIERSITE="+supplierSite+"&WIPTYPE="+wiptype+"&REQUESTNO="+REQUESTNO,"subwin","width=740,height=480,scrollbars=yes,menubar=no,location=no");
}

function subWindowInvItemFind(chooseLine)
{
	var itemName = document.MYFORM.elements["INVITEM"+chooseLine].value;
	var wiptype =document.MYFORM.WIPTYPE.value;  //add by Peggy 20120831
	subWin=window.open("../jsp/subwindow/TSCPMDItemInfoFind.jsp?ITEMNAME="+itemName+"&LINENO="+chooseLine+"&WIPTYPE="+wiptype,"subwin","width=740,height=480,scrollbars=yes,menubar=no,location=no");
}
function setValue(wipType)
{
	var LINENUM = document.MYFORM.LINENUM.value;
	var status ="",status1 =null;
	document.MYFORM.UNITPRICE.value = "";
	var curr = document.MYFORM.CURRENCYCODE.value;
	var price_uom = "";
	if (wipType =="03" || wipType =="05") //重工
	{
		status ="visible";
		status1 = false;
		document.MYFORM.UNITPRICE.readOnly = false;
		if (curr != null && curr != "") price_uom ="k";
	}
	else
	{
		status ="hidden";
		status1 = true;
		if (wipType =="01") //量產,add by Peggy 20120704
		{
			document.MYFORM.UNITPRICE.readOnly = true;
			price_uom = document.MYFORM.PRICE_SOURCE_UOM.value;  //modify by Peggy 20130522
			//price_uom = document.MYFORM.PRICE_UOM.value;
		}
		else  //工程
		{
			document.MYFORM.UNITPRICE.readOnly = false;
			if (curr != null && curr != "")
			{
				price_uom ="k";
			}
			else
			{
				price_uom="";
			}
		}
	}	
	if (curr != null && curr != "")
	{
		document.getElementById("td1").innerHTML=curr+"/"+price_uom;
	}
	else
	{
		document.getElementById("td1").innerHTML="";
	}
	document.MYFORM.PRICE_UOM.value = price_uom;

	for (var i = 1 ; i <= LINENUM ; i ++)
	{	
		if (document.MYFORM.elements["INVITEM"+i].readOnly!=status1)
		{
			document.MYFORM.elements["Stock"+i].value="";
			document.MYFORM.elements["INVITEM"+i].value="";
			document.MYFORM.elements["INVITEMID"+i].value="";
			document.MYFORM.elements["LotOnhand"+i].value = "";
			document.MYFORM.elements["WaferLot"+i].value="";
			document.MYFORM.elements["WaferNumber"+i].value="";
			document.MYFORM.elements["ChipQty"+i].value="";
			document.MYFORM.elements["UseDateCode"+i].value = "";
			document.MYFORM.elements["INVITEM"+i].readOnly=status1;
		}
		document.MYFORM.elements["btnInvItem"+i].style.visibility=status;
	}
}
function subWindowItemLotFind(chooseLine)
{
	var REQUESTNO = document.MYFORM.REQUESTNO.value;
	var VERSIONID = document.MYFORM.VERSIONID.value;
	var wiptype = document.MYFORM.WIPTYPE.value;
	if (wiptype == null || wiptype =="--")
	{
		alert("請先選擇工單類型!!");
		document.MYFORM.WIPTYPE.focus();
		return false;
	}
	var GoodsItemID = "";
	var itemID = "";
	if (wiptype =="03" || wiptype =="05") //重工
	{
		itemID =document.MYFORM.elements["INVITEMID"+chooseLine].value;
	}
	else
	{
		itemID = document.MYFORM.DIEID.value;
		GoodsItemID = document.MYFORM.ITEMID.value;
	}
	
	if (itemID ==null || itemID =="")
	{
		alert("請先輸入料號後,再選擇Lot!!");
		if (wiptype =="03"  || wiptype =="05")
		{
			document.MYFORM.elements["INVITEM"+chooseLine].focus();
		}
		else
		{
			document.MYFORM.ITEMNAME.focus();
		}
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSCPMDItemLotInfoFind.jsp?REQUESETNO="+REQUESTNO+"&VERSIONID="+VERSIONID+"&LINENO="+chooseLine+"&ITEMID="+itemID+"&GOODS="+GoodsItemID+"&TSC_PROD_GROUP="+document.MYFORM.PROD_GROUP.value+"&ONHAND_TYPE="+document.MYFORM.elements["trans_source_id_"+chooseLine].value+"&WAFERLOT="+document.MYFORM.elements["WaferLot"+chooseLine].value+"&WAFERQTY="+document.MYFORM.elements["ChipQty"+chooseLine].value,"subwin","width=750,height=500,scrollbars=yes,menubar=no,location=no");
}

function selectCheckBox(chkBox)
{
	if (!chkBox.checked)
	{
		document.MYFORM.OTHERS.value="";
	}
}

function setCurrType(curr)
{
	var wipType = document.MYFORM.WIPTYPE.value;
	var price_uom = "";
	if (wipType != "01")  //add by Peggy 20130522
	{
		if (curr==="USD" || wipType ==="03" || wipType ==="02") //modify by Peggy 20120705
		{
			price_uom = "k";
		}
		else
		{
			price_uom = "ea";
		}
	}
	else
	{
		price_uom = document.MYFORM.PRICE_SOURCE_UOM.value;
	}
	document.getElementById("td1").innerHTML=curr+"/"+price_uom;
	document.MYFORM.PRICE_UOM.value = price_uom;
}

function setSubmit()
{
	computeTotal("WaferQty");
	computeTotal("ChipQty");

	var REQUESTNO = document.MYFORM.REQUESTNO.value;
	var VERSIONID = document.MYFORM.VERSIONID.value;
	var ACTIONID = document.MYFORM.ACTIONID.value;
	if (ACTIONID == "--" || ACTIONID == null || ACTIONID == "" || ACTIONID=="null")
	{
		alert("請選擇執行動作!");
		document.MYFORM.ACTIONID.focus();
		return false;
	}
	//alert("ACTIONID="+ACTIONID);
	//alert("STATUSTYPE="+STATUSTYPE);
	var STATUSTYPE = document.MYFORM.STATUSTYPE.value;
	if (STATUSTYPE !="3" && ACTIONID =="002")
	{
		alert("工單狀態已為Completed，不允許修改!");
		return false;
	}
	
	var WIPTYPE = document.MYFORM.WIPTYPE.value;
	if (WIPTYPE == "--" || WIPTYPE == null || WIPTYPE =="" || WIPTYPE == "null")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIPTYPE.focus();
		return false;
	}
	else if (WIPTYPE=="03" || WIPTYPE=="05") //add by Peggy 20150416
	{
		document.MYFORM.DIEQTY.value ="1";
	}
	
	var ISSUEDATE = document.MYFORM.ISSUEDATE.value;
	if (ISSUEDATE =="" || ISSUEDATE == null || ISSUEDATE == "null")
	{
		alert("請輸入ISSUE DATE!");
		document.MYFORM.ISSUEDATE.focus();
		return false;
	}
	var COMPLETEDATE = document.MYFORM.COMPLETEDATE.value;
	if (COMPLETEDATE <= ISSUEDATE)
	{
		alert("預計完成日("+COMPLETEDATE+")必須大於ISSUE DATE("+ISSUEDATE+")!"); 
		document.MYFORM.COMPLETEDATE.focus();
		return false;
	}	
	
	var SUPPLIERNO = document.MYFORM.SUPPLIERNO.value;
	if (SUPPLIERNO =="" || SUPPLIERNO == null || SUPPLIERNO =="null")
	{
		alert("請輸入供應商代碼!");
		document.MYFORM.SUPPLIERNO.focus();
		return false;	
	}
	
	var SUPPLIERNAME = document.MYFORM.SUPPLIERNAME.value;
	if (SUPPLIERNAME =="" || SUPPLIERNAME == null || SUPPLIERNAME =="null")
	{
		alert("請輸入供應商名稱!");
		document.MYFORM.SUPPLIERNAME.focus();
		return false;	
	}	
	
	var VENDOR_SITE_ID = document.MYFORM.VENDOR_SITE_ID.value;
	if (VENDOR_SITE_ID =="" || VENDOR_SITE_ID == null || VENDOR_SITE_ID =="null")
	{
		alert("供應商Site不可空白!");
		document.MYFORM.SUPPLIERNAME.focus();
		return false;	
	}
		
	var SUPPLIERCONTACT = document.MYFORM.SUPPLIERCONTACT.value;
	if (SUPPLIERCONTACT == "" || SUPPLIERCONTACT == null || SUPPLIERCONTACT == "null")
	{
		alert("請輸入供應商之聯絡人!");
		document.MYFORM.SUPPLIERCONTACT.focus();
		return false;		
	}

	var CURRENCYCODE = document.MYFORM.CURRENCYCODE.value;
	if (CURRENCYCODE == "" || CURRENCYCODE == null || CURRENCYCODE == "null" || CURRENCYCODE == "&nbsp;")
	{
		alert("幣別不可空白!");
		document.MYFORM.CURRENCYCODE.focus();
		return false;		
	}

	if (document.MYFORM.SUBINVENTORY.value == null || document.MYFORM.SUBINVENTORY.value == "" || document.MYFORM.SUBINVENTORY.value == "null")
	{
		alert("請指定入庫倉!");
		document.MYFORM.SUBINVENTORY.focus();
		return false;		
	}	
	
	var CHKASSEMBLY = document.MYFORM.CHKASSEMBLY.checked;
	var CHKTESTING = document.MYFORM.CHKTESTING.checked;
	var CHKTAPING = document.MYFORM.CHKTAPING.checked;
	var CHKLAPPING = document.MYFORM.CHKLAPPING.checked;
	var CHKOTHERS = document.MYFORM.CHKOTHERS.checked;
	var OTHERS = document.MYFORM.OTHERS.value;
	if (CHKASSEMBLY == false && CHKTESTING == false && CHKTAPING ==false && CHKLAPPING ==false && CHKOTHERS ==false)
	{
		alert("測試項目請至少勾選一項!");
		return false;
	}
	if (CHKOTHERS==true && (OTHERS == "" || OTHERS == null || OTHERS == "null"))
	{
		alert("當勾選[其他]時，請填寫其他說明!");
		document.MYFORM.OTHERS.focus();
		return false;
	}
	
	var ITEMID = document.MYFORM.ITEMID.value;
	var ITEMNAME = document.MYFORM.ITEMNAME.value;
	if (ITEMNAME == "" || ITEMNAME == null || ITEMNAME == "null")
	{
		alert("請輸入料號!");
		document.MYFORM.ITEMNAME.focus();
		return false;
	}
	
	var ITEMDESC = document.MYFORM.ITEMDESC.value;
	if (ITEMDESC == "" || ITEMDESC == null || ITEMDESC == "null")
	{
		alert("請輸入品名!");
		document.MYFORM.ITEMDESC.focus();
		return false;
	}	
	
	//var PACKAGE = document.MYFORM.PACKAGE.value;
	//if (PACKAGE == "" || PACKAGE == null || PACKAGE == "null")
	//{
	//	alert("請輸入封裝型式!");
	//	document.MYFORM.PACKAGE.focus();
	//	return false;
	//}
	
	var DIEID = document.MYFORM.DIEID.value;
	var DIE = DIEID.split(",");
	var DIENAME = document.MYFORM.DIENAME.value;
	if (DIENAME == "" || DIENAME == null || DIENAME == "null")
	{
		alert("請輸入芯片名稱!");
		document.MYFORM.DIENAME.focus();
		return false;
	}	
	
	var QTY = document.MYFORM.QTY.value;
	if (QTY == "" || QTY == null || QTY == "null")
	{
		alert("請輸入數量!");
		document.MYFORM.QTY.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+\.?\d*?$/;
		if (QTY.match(regex)==null) 
		{ 
    		alert("數量必須是數值型態!"); 
			document.MYFORM.QTY.focus();
			return false;
		} 
	}
	//add by Peggy 20120514
	if (ACTIONID !="005")
	{
		if (document.MYFORM.ACTIONTYPE.value=="CHANGE" || VERSIONID !="0")
		{
			var totChipQty = document.MYFORM.totChipQty.value;
			var openQty = document.MYFORM.OPENQTY.value;
			var origQty = document.MYFORM.ORIGQTY.value;
			var num1 = ((origQty*1000)-(totChipQty*1000))/1000;
			//alert("openQty="+openQty + "  origQty="+origQty+ "  num1="+num1);
			//if (num1 >  openQty && openQty >0 )
			//{
			//	alert("工單總數量("+totChipQty+")不可超過ERP工單OPEN數量("+openQty+")!");
			//	return false;
			//}
			//var totChipQty = document.MYFORM.totChipQty.value;
			//var origTotChipQty = document.MYFORM.ORIGTOTCHIPQTY.value;
			//if ((((parseFloat(totChipQty)*1000)-(parseFloat(origTotChipQty)*1000))/1000) !=0)
			//{
			//	alert("發料總數量("+totChipQty+")必須與原單發料數量("+origTotChipQty+")一致!");
			//	return false;
			//}
		}
		var PRICEUOM = document.MYFORM.PRICE_UOM.value;
		if (PRICEUOM == "" || PRICEUOM == null || PRICEUOM =="null")
		{
			alert("單價單位不可空白!");
			document.MYFORM.PRICE_UOM.focus();
			return false;	
		}
			
		var UNITPRICE = document.MYFORM.UNITPRICE.value;
		if (UNITPRICE == "" || UNITPRICE == null || UNITPRICE == "null")
		{
			alert("請輸入單價!");
			document.MYFORM.UNITPRICE.focus();
			return false;
		}	
		else
		{
			var regex = /^-?\d+\.?\d*?$/;
			if (UNITPRICE.match(regex)==null) 
			{ 
				alert("單價必須是數值型態!"); 
				document.MYFORM.UNITPRICE.focus();
				return false;
			} 
		}
				
		var PACKING = document.MYFORM.PACKING.value;
		if (ITEMNAME.length >=22 && (PACKING == "--" || PACKING == "" || PACKING == null || PACKING == "null"))
		{
			alert("請輸入包裝!");
			document.MYFORM.PACKING.focus();
			return false;
		}	
		
		var PACKAGESPEC = document.MYFORM.PACKAGESPEC.value;
		if (PACKAGESPEC == "" || PACKAGESPEC == null || PACKAGESPEC == "null")
		{
			alert("請輸入封裝規格!");
			document.MYFORM.PACKAGESPEC.focus();
			return false;
		}	
		
		var TESTSPEC = document.MYFORM.TESTSPEC.value;
		if (TESTSPEC == "" || TESTSPEC == null || TESTSPEC == "null")
		{
			alert("請輸入測試規格!");
			document.MYFORM.TESTSPEC.focus();
			return false;
		}	
		var REMARKS	 = document.MYFORM.REMARKS.value;
		if (REMARKS == "" || REMARKS == null || REMARKS == "null")
		{
			alert("請輸入備註資訊!");
			document.MYFORM.REMARKS.focus();
			return false;
		}	
		
		var MARKING = document.MYFORM.MARKING.value;
		if (MARKING == "" || MARKING == null || MARKING == "null")
		{
			alert("請輸入MARKING!");
			document.MYFORM.MARKING.focus();
			return false;
		}	
		
		//add by Peggy 20240529
		if (document.MYFORM.CHANGE_REASON.value=="" || document.MYFORM.CHANGE_REASON.value==null || document.MYFORM.CHANGE_REASON.value=="null")
		{
			alert("請輸入變更原因說明!");
			document.CHANGE_REASON.focus();
			return false;		
		}
		
		var LINENUM = document.MYFORM.LINENUM.value;
		var rec_cnt =0;
		var num1=0, num11=0,num2=0,num21=0;
		for (var i = 1 ; i <= LINENUM ; i ++)
		{
			var Stock = document.MYFORM.elements["Stock"+i].value;
			var invitem = document.MYFORM.elements["INVITEM"+i].value;
			var invitemid = document.MYFORM.elements["INVITEMID"+i].value;
			var WaferLot = document.MYFORM.elements["WaferLot"+i].value;
			var WaferNumber = document.MYFORM.elements["WaferNumber"+i].value;
			var WaferQty = document.MYFORM.elements["WaferQty"+i].value;
			var ChipQty = document.MYFORM.elements["ChipQty"+i].value;
			var DateCode = document.MYFORM.elements["DateCode"+i].value;
			DateCode = DateCode.replace("_",""); //add by Peggy 20221212
			var DC_YYWW = document.MYFORM.elements["DC_YYWW"+i].value; //add by Peggy 20221205
			//var RequestSD = document.MYFORM.elements["RequestSD"+i].value;
			var LotOnhand = document.MYFORM.elements["LotOnhand"+i].value;
			var WIP_ISSUE_FLAG = document.MYFORM.elements["WIP_ISSUE_FLAG_"+i].value;  //add by Peggy 20180529
			if ((WaferLot != null && WaferLot != "") || ( WIPTYPE !="03" && WIPTYPE !="05" && invitem !=null && invitem != "" && invitemid !=null && invitemid != "" && WaferQty != null && WaferQty != "" && DateCode!=null && DateCode !="" && ChipQty != null && ChipQty != "") || ( (WIPTYPE =="03" || WIPTYPE =="05") && invitem !=null && invitem != "" &&  invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != "" && DateCode!=null && DateCode !="" ) || (invitem !=null && invitem != "" &&  invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != ""))
			{
				//20210514 by Peggy,for申請單:R210514001 issue,與nono確認後不檢查
				/*for (var j = i ; j <= LINENUM ; j++)
				{
					if (WaferLot != "" && WaferLot!=null)
					{
						//if (WIPTYPE !="03" && WaferLot == document.MYFORM.elements["WaferLot"+j].value && DateCode != document.MYFORM.elements["DateCode"+j].value)
						//{
						//	alert("Wafer Lot:"+WaferLot+" 不允許有兩個以上的DataCode!"); 
						//	document.MYFORM.elements["WaferLot"+j].focus();
						//	return false;
						//}
						//else if (WIPTYPE !="03" && i != j && WaferLot == document.MYFORM.elements["WaferLot"+j].value && DateCode == document.MYFORM.elements["DateCode"+j].value)
						if (WIPTYPE !="03" && i != j && WaferLot == document.MYFORM.elements["WaferLot"+j].value && (DateCode.toUpperCase()!="HOLD" && DateCode == document.MYFORM.elements["DateCode"+j].value))
						{
							alert("Wafer Lot:"+WaferLot+" + Date Code:"+ DateCode + "不可重複!"); 
							document.MYFORM.elements["WaferLot"+j].focus();
							return false;
						}
					}
				}
				*/
				if (WIP_ISSUE_FLAG=="Y" &&  WaferLot !=null && WaferLot !="" &&  WaferLot !="&nbsp;" && (Stock ==null || Stock ==""))
				{
					alert("請選擇發料倉!"); 
					document.MYFORM.elements["WaferLot"+i].focus();
					return false;
				}
				if (WIPTYPE !="03" && WIPTYPE !="05" && DIEID != invitemid)
				{
					var okcnt=0;
					for ( k = 0 ; k < DIE.length ; k++)
					{
						if (DIE[k] == invitemid)
						{
							okcnt =1;
							break;
						}
					}
					if (okcnt ==0)
					{
						alert("發料項目不正確!"); 
						document.MYFORM.elements["INVITEM"+i].focus();
						return false;
					}
				}
				var regex = /^-?\d+\.?\d*?$/;
				if (WIPTYPE !="03" && WIPTYPE !="05" && WaferQty.match(regex)==null) 
				{ 
					alert("Wafer Qty必須是數值型態!"); 
					document.MYFORM.elements["WaferQty"+i].focus();
					return false;
				} 
				if (ChipQty.match(regex)==null) 
				{ 
					alert("Chip Qty必須是數值型態!"); 
					document.MYFORM.elements["ChipQty"+i].focus();
					return false;
				}
				else if (ChipQty ==0)
				{
					alert("Chip Qty必須大於0!"); 
					document.MYFORM.elements["ChipQty"+i].focus();
					return false;
				}
				//if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (parseFloat(ChipQty) > parseFloat(LotOnhand)))
				//{ 
				//	alert("Chip Qty不可大於目前庫存量("+LotOnhand+")!"); 
				//	document.MYFORM.elements["ChipQty"+i].focus();
				//	return false;
				//}
				if (document.MYFORM.SUPPLIERNO.value =="4056" && (WaferNumber==null||WaferNumber==""))  //add by Peggy 20180724
				{
					alert("此供應商必須指定Wafer片號!"); 
					document.MYFORM.elements["WaferNumber"+i].focus();
					return false;			
				}				
				//if (WIPTYPE !="03" && (DateCode==null || DateCode=="")) 
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (DateCode==null || DateCode=="")) 
				{ 
					alert("Date Code不可空白!"); 
					document.MYFORM.elements["DateCode"+i].focus();
					return false;
				} 			
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && DateCode!="HOLD" && DateCode!="NA" && DateCode!="N/A" && (DC_YYWW==null || DC_YYWW=="")) 
				{ 
					alert("DC_YYWW不可空白!"); 
					document.MYFORM.elements["DC_YYWW"+i].focus();
					return false;
				} 			
				//if (RequestSD <= ISSUEDATE)
				//{
				//	alert("Requeset S/D("+RequestSD+")必須大於ISSUE DATE("+ISSUEDATE+")!"); 
				//	document.MYFORM.elements["RequestSD"+i].focus();
				//	return false;
				//}
				rec_cnt ++;
			}
		}
		if (rec_cnt ==0)
		{
			alert("請輸入工單發料資訊!");
			document.MYFORM.elements["WaferLot1"].focus;
			return false;
		}
		var totChipQty = document.MYFORM.totChipQty.value;
		var totWaferQty = document.MYFORM.totWaferQty.value;
		var DIEQTY = document.MYFORM.DIEQTY.value;
		if (DIEQTY ==null) DIEQTY ="1";
		totChipQty = Math.round(parseFloat(totChipQty)/parseFloat(DIEQTY)*10000)/10000;
		//var maxQty = (((QTY *1.1) * 10000)/10000);
		if ( document.MYFORM.PRICE_UOM.value !="片" && totChipQty != QTY)
		{
			alert("發料數量("+totChipQty+")不等於開工數量("+QTY+")");
			document.MYFORM.QTY.focus;
			return false;
		}
		else if (document.MYFORM.PRICE_UOM.value =="片" && totWaferQty != QTY)
		{
			alert("片數("+totWaferQty+")不等於開工片數("+QTY+")");
			document.MYFORM.QTY.focus;
			return false;
		}
		
		for (var i = 1 ; i <= LINENUM ; i ++)
		{	
			if (WIPTYPE =="03" || WIPTYPE =="05")
			{
				document.MYFORM.elements["btnInvItem"+i].disabled=true;
			}
			document.MYFORM.elements["btnLot"+i].disabled=true;
		}
	}
	var actiontype=document.MYFORM.ACTIONTYPE.value;
	document.MYFORM.btnSupplier.disabled=true;	
	document.MYFORM.btnStock.disabled=true;
	document.MYFORM.btnItem.disabled=true;	
	document.MYFORM.btnDesc.disabled=true;	
	document.MYFORM.Submit1.disabled=true;	
	document.MYFORM.addline.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	//document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?REQUESTNO="+REQUESTNO+"&VERSIONID="+VERSIONID+"&PROGRAMNAME="+actiontype;
	if (REQUESTNO.indexOf("-")<0)
	{
		document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?REQUESTNO="+REQUESTNO+"&VERSIONID="+VERSIONID+"&PROGRAMNAME="+actiontype;
	}
	else
	{
		document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?REQUESTNO="+REQUESTNO.substring(0,REQUESTNO.indexOf("-"))+"&VERSIONID="+VERSIONID+"&PROGRAMNAME="+actiontype;
	}
	document.MYFORM.submit();
}
function checkonhand(ChipQty,LotOnhand)
{
	ChipQty=ChipQty.replace(",","");
	LotOnhand=LotOnhand.replace(",","");
	var num1=0, num11=0,num2=0,num21=0;
	if (ChipQty.indexOf(".") < 0)
	{
		num1 = ChipQty;
		num11 = 0;
	}
	else
	{
		num1 = ChipQty.substring(0, ChipQty.indexOf("."));
		num11 = ChipQty.substring(ChipQty.indexOf(".") + 1);
	}
	if (LotOnhand.indexOf(".") < 0)
	{
		num2 = LotOnhand;
		num21 = 0;
	}
	else
	{
		num2 = LotOnhand.substring(0, LotOnhand.indexOf("."));
		num21 = LotOnhand.substring(LotOnhand.indexOf(".") + 1);
	}
	if ((num1 > num2))
	{ 
		return false;
	}
	else if ((num1 == num2 && num11 > num21))
	{
		return false;
	}
	else
	{
		return true;
	}
}
function computeTotal(objName)
{
	var LINENUM = document.MYFORM.LINENUM.value;
	var totQty =0,Qty=0;
	var num1, num2, m, c;

	for (var i = 1 ; i <= LINENUM ; i ++)
	{
		Qty = document.MYFORM.elements[objName+i].value;
    	try 
		{ 
			num1 = Qty.toString().split(".")[1].length 
		} 
		catch (e) { num1 = 0 }
        try 
		{
			num2 = totQty.toString().split(".")[1].length 
		} catch (e) { num2 = 0 }
        c = Math.abs(num1 - num2);
        m = Math.pow(10, Math.max(num1, num2))
        if (c > 0) 
		{
            var cm = Math.pow(10, c);
            if (num1 > num2) 
			{
                Qty = Number(Qty.toString().replace(".", ""));
                totQty = Number(totQty.toString().replace(".", "")) * cm;
            }
            else 
			{
                Qty = Number(Qty.toString().replace(".", "")) * cm;
                totQty = Number(totQty.toString().replace(".", ""));
            }
        }
        else 
		{
            Qty = Number(Qty.toString().replace(".", ""));
            totQty = Number(totQty.toString().replace(".", ""));
        }
        totQty = (Qty + totQty) / m;
	}
	document.MYFORM.elements["tot"+objName].value = totQty;
	if (objName =="ChipQty")
	{
		if (document.MYFORM.PRICE_UOM.value !="片")
		{	
			//add by Peggy 20121009
			var DIEQTY = document.MYFORM.DIEQTY.value;
			if (DIEQTY ==null) DIEQTY ="1";
			totQty = Math.round(parseFloat(totQty)/parseFloat(DIEQTY)*10000)/10000;
			document.MYFORM.QTY.value = totQty;
		}
		if (document.MYFORM.WIPTYPE.value=="01") getUnitPrice();
	}
	else
	{
		if (document.MYFORM.PRICE_UOM.value =="片")
		{	
			document.MYFORM.QTY.value = totQty;
			if (document.MYFORM.WIPTYPE.value=="01")  getUnitPrice();
		}
	}
}

function subWindowHistory()
{
	var VENDOR = document.MYFORM.SUPPLIERNO.value;
	if (VENDOR =="" || VENDOR == null || VENDOR =="null")
	{
		alert("請輸入供應商代碼!");
		document.MYFORM.SUPPLIERNO.focus();
		return false;	
	}

	var	ITEMID = document.MYFORM.ITEMID.value;
	if (ITEMID == null || ITEMID == "")
	{
		alert("請先輸入料號");
		document.MYFORM.ITEMID.focus();
		return false;
	}
	var	ITEMNAME = document.MYFORM.ITEMNAME.value;
	var	ITEMDESC = document.MYFORM.ITEMDESC.value;
	var VENDORSITEID = document.MYFORM.VENDOR_SITE_ID.value;
	var QTY = document.MYFORM.QTY.value;
	subWin=window.open("../jsp/TSCPMDQuotationHistory.jsp?ITEMID="+ITEMID+"&ITEMNAME="+ITEMNAME+"&ITEMDESC="+ITEMDESC+"&VENDOR="+VENDOR+"&QTY="+QTY+"&VENDORSITEID="+VENDORSITEID+"&PROGRAMNAME=F1-001","subwin","width=850,height=480,scrollbars=yes,menubar=no,location=no");
}

function getUnitPrice()
{
	var Qty = document.MYFORM.QTY.value;
	var price = document.MYFORM.UNITPRICE.value;
	for (var i = 0; i < document.MYFORM.UNITPRICELIST.options.length; i++) 
	{
		var rangeqty = document.MYFORM.UNITPRICELIST.options[i].text;
		if (parseFloat(Qty) <= parseFloat(rangeqty))
		{
			price = document.MYFORM.UNITPRICELIST.options[i].value;	
			break;
		}
	}	
	document.MYFORM.UNITPRICE.value = price;
}
function chkObj()
{
	//if (!document.MYFORM.WIP_ISSUE_FLAG.checked)
	//{
	//	document.getElementById("span1").style.backgroundColor ="#FFFFFF";	
	//}
	//else
	//{
		document.getElementById("span1").style.backgroundColor ="#FFFF33";	
		for (var i =1 ; i <= document.MYFORM.LINENUM.value ; i++)
		{
			document.MYFORM.elements["Stock"+i].value = "";
			document.MYFORM.elements["INVITEM"+i].value = "";
			document.MYFORM.elements["INVITEMID"+i].value = "";
			document.MYFORM.elements["LotOnhand"+i].value = "";
			document.MYFORM.elements["WaferLot"+i].value = "";
			document.MYFORM.elements["WaferNumber"+i].value = "";
			document.MYFORM.elements["ChipQty"+i].value = "";
			document.MYFORM.elements["WaferQty"+i].value = "";
			document.MYFORM.elements["DateCode"+i].value = "";
			//document.MYFORM.elements["RequestSD"+i].value = "";
			document.MYFORM.elements["UseDateCode"+i].value ="";
			document.MYFORM.elements["DC_YYWW"+i].value = "";
		}	
		if (document.MYFORM.ITEMID.value!="")
		{
			document.MYFORM.submit();
		}
	//}
}
function setUnit()
{
	if ((document.MYFORM.WIPTYPE.value=="02" || document.MYFORM.WIPTYPE.value=="03" || document.MYFORM.WIPTYPE.value=="05"))  //工程,重工允許手動調整單價單位,modify by Peggy 20170823
	{
		if ((document.MYFORM.CURRENCYCODE.value==="USD" || document.MYFORM.WIPTYPE.value==="02") && document.MYFORM.PRICE_UOM.value.toUpperCase()==="K")
		{
			document.MYFORM.PRICE_UOM.value="片";
			document.getElementById("td2").innerHTML="Q'ty("+document.MYFORM.PRICE_UOM.value+")";
			document.MYFORM.QTY.value=document.MYFORM.totWaferQty.value;
		}
		else if (document.MYFORM.CURRENCYCODE.value=="TWD" && document.MYFORM.PRICE_UOM.value.toUpperCase()=="EA")
		{
			document.MYFORM.PRICE_UOM.value="片";
			document.getElementById("td2").innerHTML="Q'ty("+document.MYFORM.PRICE_UOM.value+")";
			document.MYFORM.QTY.value=document.MYFORM.totWaferQty.value;
		}
		else
		{
			if (document.MYFORM.CURRENCYCODE.value==="USD" || document.MYFORM.WIPTYPE.value==="02")
			{
				document.MYFORM.PRICE_UOM.value="k";
				document.getElementById("td2").innerHTML="Q'ty(KPC)";
			}
			else if (document.MYFORM.CURRENCYCODE.value=="TWD")
			{
				document.MYFORM.PRICE_UOM.value="ea";
				document.getElementById("td2").innerHTML="Q'ty(KPC)";
			}
			document.MYFORM.QTY.value=document.MYFORM.totChipQty.value;
		}
		document.MYFORM.PRICE_SOURCE_UOM.value=document.MYFORM.PRICE_UOM.value;
		document.getElementById("td1").innerHTML=document.MYFORM.CURRENCYCODE.value+"/"+document.MYFORM.PRICE_UOM.value;
	}	
}
function chkObjX()
{	
	if (!document.MYFORM.COPY_LINE.checked)
	{
		document.MYFORM.COPY_NUM.value="";
		document.MYFORM.COPY_NUM.disabled=true;
	}
	else
	{
		document.MYFORM.COPY_NUM.value="";
		document.MYFORM.COPY_NUM.disabled=false;
	}
}
</script>
<STYLE TYPE='text/css'> 
 .style3   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:center}
 .style4   {font-family:細明體;	font-size:12px;	background-color:#CCCCFF; text-align:center;color: #000000;}
 .style1   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:left}
 .style2   {font-family:細明體;	font-size:12px;	background-color:#CCCCFF; text-align:left;	color: #000000;}
 .style5   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:right}
 .style6   {font-family:細明體;	font-size:12px;	background-color:#CCCCFF; text-align:right; color: #000000;}
 .style7 {	font-family:細明體;
	font-size:12px;
	background-color:#D8DEA9;
	text-align:left;
color=#EE6633D;
	color: #660000;
}
</STYLE>
</head>
<body>
<%
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE ="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String ORIGVERSIONID = request.getParameter("ORIGVERSIONID");
if (ORIGVERSIONID==null) ORIGVERSIONID="";
String VERSIONID = request.getParameter("VERSIONID");
if (VERSIONID==null) VERSIONID="";
String ACTIONTYPE= request.getParameter("ACTIONTYPE");
if (ACTIONTYPE==null) ACTIONTYPE="";
String FuncName = "";
if (ACTIONTYPE.equals("CHANGE")) FuncName ="變更";
if (ACTIONTYPE.equals("MODIFY")) FuncName ="修改";
if (ACTIONTYPE.equals("WIPISSUE")) FuncName ="發料";
String WIPTYPE = request.getParameter("WIPTYPE");
if (WIPTYPE ==null) WIPTYPE ="";
String ISSUEDATE = request.getParameter("ISSUEDATE");
if (ISSUEDATE ==null) ISSUEDATE="";
String CREATOR = request.getParameter("CREATOR");
if (CREATOR == null) CREATOR="";
String CREATEDATE= request.getParameter("CREATEDATE");
if (CREATEDATE == null) CREATEDATE="";
String CREATORID = request.getParameter("CREATORID");
if (CREATORID==null) CREATORID="";
String SUPPLIERNO = request.getParameter("SUPPLIERNO");
if (SUPPLIERNO==null) SUPPLIERNO="";
String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
if (SUPPLIERNAME==null) SUPPLIERNAME="";
String SUPPLIERCONTACT = request.getParameter("SUPPLIERCONTACT");
if (SUPPLIERCONTACT==null) SUPPLIERCONTACT="";
String CHKASSEMBLY = request.getParameter("CHKASSEMBLY");
if (CHKASSEMBLY != null && CHKASSEMBLY.equals("Y")) CHKASSEMBLY="checked"; else CHKASSEMBLY="";
String CHKTESTING = request.getParameter("CHKTESTING");
if (CHKTESTING != null && CHKTESTING.equals("Y")) CHKTESTING="checked"; else CHKTESTING="";
String CHKTAPING = request.getParameter("CHKTAPING");
if (CHKTAPING != null && CHKTAPING.equals("Y")) CHKTAPING="checked"; else CHKTAPING="";
String CHKLAPPING = request.getParameter("CHKLAPPING");
if (CHKLAPPING != null && CHKLAPPING.equals("Y")) CHKLAPPING="checked"; else CHKLAPPING="";
String FSM = request.getParameter("FSM");
if (FSM != null && FSM.equals("Y")) FSM="checked"; else FSM="";
String RINGCUT = request.getParameter("RINGCUT");
if (RINGCUT != null && RINGCUT.equals("Y")) RINGCUT="checked"; else RINGCUT="";
String CHKOTHERS = request.getParameter("CHKOTHERS");
if (CHKOTHERS != null && CHKOTHERS.equals("Y")) CHKOTHERS="checked"; else CHKOTHERS="";
String OTHERS = request.getParameter("OTHERS");
if (OTHERS==null) OTHERS="";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID==null) ITEMID="";
String ITEMNAME = request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String ITEMDESC = request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String PACKAGE = request.getParameter("PACKAGE");
if (PACKAGE==null) PACKAGE = "";
String DIENAME = request.getParameter("DIENAME");
if (DIENAME==null) DIENAME="";
String DIEID = request.getParameter("DIEID");
if (DIEID==null) DIEID="";
String DIE_QTY = request.getParameter("DIEQTY");  //add by Peggy 20121011
if (DIE_QTY ==null) DIE_QTY ="1";
String QTY = request.getParameter("QTY");
if (QTY==null) QTY="";
String UNITPRICE = request.getParameter("UNITPRICE");
if (UNITPRICE==null || UNITPRICE.equals("")) UNITPRICE="";
String PACKING = request.getParameter("PACKING");
if (PACKING ==null) PACKING="";
String PACKAGESPEC = request.getParameter("PACKAGESPEC");
if (PACKAGESPEC==null) PACKAGESPEC="";
String TESTSPEC = request.getParameter("TESTSPEC");
if (TESTSPEC==null) TESTSPEC="";
String CURRENCYCODE = request.getParameter("CURRENCYCODE");
if (CURRENCYCODE==null) CURRENCYCODE="";
String REMARKS=request.getParameter("REMARKS");
if (REMARKS==null) REMARKS="";
String MARKING= request.getParameter("MARKING");
if (MARKING ==null) MARKING="";
String CHANGE_REASON=request.getParameter("CHANGE_REASON"); //add by Peggy 20240529
if (CHANGE_REASON==null) CHANGE_REASON="";
String LINENUM=request.getParameter("LINENUM");
if (LINENUM == null || LINENUM.equals("")) LINENUM ="0"; //預設0行
String ADDLINE=request.getParameter("txtLine");
if (ADDLINE == null || ADDLINE.equals("")) ADDLINE = "0";
if (!ACTIONCODE.equals("AddLine")) ADDLINE="0";
LINENUM = ""+(Integer.parseInt(ADDLINE)+Integer.parseInt(LINENUM));
String totWaferQty=request.getParameter("totWaferQty");
if (totWaferQty==null) totWaferQty="";
String totChipQty=request.getParameter("totChipQty");
if (totChipQty==null) totChipQty="";
String SUBINVENTORY = request.getParameter("SUBINVENTORY");
if (SUBINVENTORY ==null) SUBINVENTORY="";
String WIPNO = request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String PRNO=request.getParameter("PRNO");
if (PRNO==null) PRNO="";
String PONO=request.getParameter("PONO");
if (PONO==null) PONO="";
String WIPID= request.getParameter("WIPID");
if (WIPID ==null) WIPID="";
String ORIGTOTCHIPQTY=request.getParameter("ORIGTOTCHIPQTY");
if (ORIGTOTCHIPQTY==null) ORIGTOTCHIPQTY="0";
String ORIGQTY=request.getParameter("ORIGQTY");
if (ORIGQTY==null) ORIGQTY="0";
String OPENQTY=request.getParameter("OPENQTY");
if (OPENQTY==null) OPENQTY="0";
String STATUSTYPE= request.getParameter("STATUSTYPE");
if (STATUSTYPE==null) STATUSTYPE="";
String PRICEUOM = request.getParameter("PRICE_UOM");
if (PRICEUOM == null) PRICEUOM="";  //add by Peggy 20120705
String PRICESOURCEUOM = request.getParameter("PRICE_SOURCE_UOM");
if (PRICESOURCEUOM == null) PRICESOURCEUOM="";  //add by Peggy 20130522
String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
String WaferLot="",ChipQty="",WaferQty="",DateCode="",RequestSD="",LotOnhand="",Stock="",INVITEMID="",INVITEM="",UseDateCode="",trans_source_id="",WIP_ISSUE_FLAG="",WaferNumber="",DC_YYWW="",DIE_MODE="";
String WIPMODIFY="MODIFY",WIPCHANGE="CHANGE",WIPISSUE="WIPISSUE";
String DIEITEM = request.getParameter("DIEITEM");
if (DIEITEM==null) DIEITEM="";  //add by Peggy 20130916
String AVL = request.getParameter("AVL");  //add by Peggy 20130916
if (AVL==null) AVL="";
String BILLSEQID = request.getParameter("BILLSEQID");
String PROD_GROUP=request.getParameter("PROD_GROUP");
if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161106
String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID=""; //add by Peggy 20161106
String COMPLETEDATE= request.getParameter("COMPLETEDATE");
if (COMPLETEDATE==null) COMPLETEDATE="";  //add by Peggy 20170817
//String WIP_ISSUE_FLAG=request.getParameter("WIP_ISSUE_FLAG");
//if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG=""; //add by Peggy 20170817
String WIP_MTL_STATUS="";
String CPLINE = request.getParameter("CPLINE");
if (CPLINE==null) CPLINE="";  //add by Peggy 20180124
String COPY_LINE= request.getParameter("COPY_LINE");
if (COPY_LINE==null) COPY_LINE="N";
String COPY_NUM = request.getParameter("COPY_NUM");
if (COPY_NUM==null) COPY_NUM="";
String ST_UNITPRICE=request.getParameter("ST_UNITPRICE"); //add by Peggy 20210608
if (ST_UNITPRICE==null) ST_UNITPRICE="";
String V_LINENO="";
String sql="";
	
try
{
	if (!REQUESTNO.equals("") && WIPTYPE.equals("") && (ACTIONTYPE.equals(WIPMODIFY) || ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)))
	{
		sql = " SELECT a.request_no, a.version_id,a.wip_type_no,b.TYPE_NAME wip_type_name, a.vendor_code, a.vendor_name,"+
					 " a.vendor_contact, a.request_date, a.inventory_item_id,"+
					 " a.inventory_item_name, a.item_description, a.item_package,"+
					 " a.die_item_id || decode(a.die_item_id1,null,'',','||a.die_item_id1) die_item_id, a.die_name|| decode(a.die_name1,null,'',','||a.die_name1) die_name, a.quantity, a.unit_price, a.packing,"+
					 " a.package_spec, a.test_spec, a.assembly, a.testing,"+
					 " a.taping_reel, a.lapping, a.others, a.remarks, a.marking,a.currency_code,a.CREATED_BY,a.unit_price_uom,a.VENDOR_SITE_ID,"+
					 " a.created_by_name,to_char(a.CREATION_DATE,'yyyy-mm-dd') CREATION_DATE ,a.SUBINVENTORY_CODE,a.currency_code,a.wip_no,a.pr_no,a.po_no,a.wip_entity_ID,a.orig_version_id,"+
					 //" nvl((select x.TOT_CHIP_QTY from oraddman.tspmd_oem_headers_all x where x.request_no = a.request_no and x.version_id = a.orig_version_id),0)  orig_qty"+
					 " decode('"+ACTIONTYPE+"','"+WIPMODIFY+"',nvl((select x.TOT_CHIP_QTY from oraddman.tspmd_oem_headers_all x where x.request_no = a.request_no and x.version_id = a.orig_version_id),0),'"+WIPCHANGE+"',a.tot_chip_qty,'"+WIPISSUE+"',a.tot_chip_qty) orig_qty"+						  
					 ",nvl((select max(version_id) from oraddman.tspmd_oem_headers_all y where y.request_no= a.request_no),0)+1 max_versionid,a.die_qty"+
					 ",a.BILL_SEQUENCE_ID"+ //20160919 add by Peggy 
					 ",a.tsc_prod_group,a.organization_id"+ //add by Peggy 20161108
				     ",to_char(a.completion_date,'yyyymmdd') completion_date,a.WIP_MTL_STATUS"+ //add by Peggy 20170817
				     ",a.front_side_metal fsm, a.ring_cut ringcut"+ //add by Peggy 20230426					 
					 " FROM oraddman.tspmd_oem_headers_all a,oraddman.TSPMD_DATA_TYPE_TBL b"+
					 " WHERE request_no||'-'||version_id='"+REQUESTNO+"' "+
					 //" AND a.created_by_name ='"+UserName+"' "+
					 " AND a.status = decode('"+ACTIONTYPE+"','"+WIPMODIFY+"','Reject','"+WIPCHANGE+"','Approved','"+WIPISSUE+"','Approved','') and a.wip_type_no=b.TYPE_NO and b.DATA_TYPE='WIP'"+
					 " AND NVL(a.LOCK_FLAG,'N')='N'";
		if (ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE))
		{
			sql += " and exists (select 1 from wip.wip_discrete_jobs c where c.wip_entity_id=a.wip_entity_id and c.status_type='3')";
		}
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if (rs.next())
		{
			REQUESTNO=rs.getString("request_no");
			WIPTYPE=rs.getString("wip_type_no");
			if (ACTIONTYPE.equals(WIPMODIFY))
			{
				//VERSIONID=rs.getString("version_id");
				VERSIONID=rs.getString("max_versionid");  //退件修改,版次+1,add by Peggy 20150904
				CREATEDATE=rs.getString("CREATION_DATE");
				ORIGVERSIONID = rs.getString("version_id");
				//ORIGVERSIONID = rs.getString("orig_version_id");
				ORIGQTY = rs.getString("orig_qty");
			}
			else if (ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE))
			{
				if (ACTIONTYPE.equals(WIPISSUE))
				{
					VERSIONID=rs.getString("version_id");
				}
				else
				{
					VERSIONID=rs.getString("max_versionid");
				}
				CREATEDATE=dateBean.getYear() +"-"+dateBean.getMonth()+"-"+dateBean.getDay();
				ORIGVERSIONID = rs.getString("version_id");
				ORIGQTY = rs.getString("orig_qty");
			}
			CREATORID=rs.getString("CREATED_BY");
			ISSUEDATE=rs.getString("request_date");
			CREATOR=rs.getString("created_by_name");
			SUPPLIERNO = rs.getString("vendor_code");
			SUPPLIERNAME = rs.getString("vendor_name");
			SUPPLIERCONTACT = rs.getString("vendor_contact");
			CURRENCYCODE = rs.getString("currency_code");
			SUBINVENTORY = rs.getString("SUBINVENTORY_CODE");
			if (SUBINVENTORY==null) SUBINVENTORY="";
			//modify by Peggy 20200825
			/*if (rs.getString("TSC_PROD_GROUP").equals("PMD"))
			{
				//add by Peggy 20130711
				if (WIPTYPE.equals("01"))
				{
					SUBINVENTORY ="63";
				}
				else if (WIPTYPE.equals("02"))
				{
					SUBINVENTORY ="66";
				}
			}
			else
			{
				SUBINVENTORY ="03";
			}*/
	
			CHKASSEMBLY = rs.getString("assembly");
			if (CHKASSEMBLY != null && CHKASSEMBLY.equals("Y")) CHKASSEMBLY="checked"; else CHKASSEMBLY="";
			CHKTESTING = rs.getString("testing");
			if (CHKTESTING != null && CHKTESTING.equals("Y")) CHKTESTING="checked"; else CHKTESTING="";
			CHKTAPING = rs.getString("taping_reel");
			if (CHKTAPING != null && CHKTAPING.equals("Y")) CHKTAPING="checked"; else CHKTAPING="";
			CHKLAPPING = rs.getString("lapping");
			if (CHKLAPPING != null && CHKLAPPING.equals("Y")) CHKLAPPING="checked"; else CHKLAPPING="";
			CHKOTHERS = rs.getString("others");
			if (CHKOTHERS != null && CHKOTHERS.length()>0) CHKOTHERS="checked"; else CHKOTHERS="";
			OTHERS = rs.getString("others");
			if (OTHERS==null) OTHERS="";
			ITEMID = rs.getString("inventory_item_id");
			if (ITEMID==null) ITEMID="";
			ITEMNAME = rs.getString("inventory_item_name");
			if (ITEMNAME==null) ITEMNAME="";
			ITEMDESC = rs.getString("item_description");
			if (ITEMDESC==null) ITEMDESC="";
			PACKAGE = rs.getString("item_package");
			if (PACKAGE==null) PACKAGE = "";
			DIENAME = rs.getString("die_name");
			if (DIENAME==null) DIENAME="";
			DIEID = rs.getString("die_item_id");
			if (DIEID==null) DIEID="";
			QTY = rs.getString("quantity");
			if (QTY==null) QTY="";
			UNITPRICE = rs.getString("unit_price");
			if (UNITPRICE==null) UNITPRICE="";
			PACKING = rs.getString("PACKING");
			if (PACKING ==null) PACKING="";
			PACKAGESPEC = rs.getString("package_spec");
			if (PACKAGESPEC==null) PACKAGESPEC="";
			TESTSPEC = rs.getString("test_spec");
			if (TESTSPEC==null) TESTSPEC="";
			REMARKS = rs.getString("remarks");
			if (REMARKS==null) REMARKS="";
			MARKING= rs.getString("MARKING");
			if (MARKING ==null) MARKING="";
			WIPNO = rs.getString("WIP_NO");
			if (WIPNO==null) WIPNO="";
			PRNO=rs.getString("PR_NO");
			if (PRNO==null) PRNO="";
			PONO=rs.getString("PO_NO");
			if (PONO==null) PONO="";
			WIPID= rs.getString("wip_entity_id");
			if (WIPID ==null) WIPID="";	
			PRICEUOM =rs.getString("unit_price_uom");
			if (PRICEUOM == null) PRICEUOM=""; //add by Peggy 20120705
			VENDOR_SITE_ID = rs.getString("VENDOR_SITE_ID");
			if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
			STATUSTYPE ="3";
			DIE_QTY = rs.getString("DIE_QTY"); //add by Peggy 20121011
			if (DIE_QTY ==null) DIE_QTY="1";
			BILLSEQID = rs.getString("BILL_SEQUENCE_ID");  //add by Peggy 20160919
			if (BILLSEQID==null) BILLSEQID="";
			PROD_GROUP = rs.getString("TSC_PROD_GROUP");
			if (PROD_GROUP==null) PROD_GROUP="";    //add by Peggy 20161108
			ORGANIZATION_ID = rs.getString("ORGANIZATION_ID");
			if (ORGANIZATION_ID==null) ORGANIZATION_ID=""; //add by Peggy 20161108
			COMPLETEDATE=rs.getString("COMPLETION_DATE");  //add by Peggy 20170817
			if (COMPLETEDATE==null) COMPLETEDATE="";
			FSM=rs.getString("FSM");
			if (FSM != null && FSM.equals("Y")) FSM="checked"; else FSM="";			
			RINGCUT=rs.getString("RINGCUT");			
			if (RINGCUT != null && RINGCUT.equals("Y")) RINGCUT="checked"; else RINGCUT="";			
			//WIP_ISSUE_FLAG=rs.getString("WIP_ISSUE_PENDING_FLAG"); //add by Peggy 20170817
			//if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG="";
			//WIP_MTL_STATUS =rs.getString("WIP_MTL_STATUS");
			WIP_MTL_STATUS="Y";//add by Peggy 20201007
			if (WIP_MTL_STATUS==null) WIP_MTL_STATUS="N"; //add by Peggy 20170817
			
			if (!WIPID.equals(""))
			{
				sql = " SELECT nvl(sum(a.QUANTITY_IN_QUEUE),0) OPEN_QTY,b.status_type  FROM wip.wip_operations a,wip.wip_discrete_jobs b where a.wip_entity_id = b.wip_entity_id and a.wip_entity_id="+WIPID+" group by b.status_type ";
				
				Statement statementx=con.createStatement();
				ResultSet rsx=statementx.executeQuery(sql);
				if (rsx.next())
				{			
					OPENQTY = rsx.getString("OPEN_QTY");
					STATUSTYPE = rsx.getString("status_type");
				}
				rsx.close();
				statementx.close();
			}
		}
		rs.close();
		statement.close();
		if (WIPTYPE.equals(""))
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!申請單狀態可能不符合異動條件,請重新確認,謝謝!");
			document.location.href="../jsp/TSCPMDOEMInformationQuery.jsp";
		</script>
		<%
		}
	}
}
catch(Exception e)
{
	out.println("Exception2:"+e.getMessage());	
}
%>
<form name="MYFORM"  METHOD="post" action="TSCPMDOEMModify.jsp" >
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
 <font color="#000000" size="+2" face="標楷體"> <strong><%=PROD_GROUP%>委外加工單-<%=FuncName%></strong></font>
<br>
<A HREF="../jsp/TSCPMDOEMInformationQuery.jsp"><font style="font-size:14px;font-family:'細明體'">回查詢畫面</font></A>&nbsp;&nbsp;&nbsp;
<%
try
{   
	Statement statement=con.createStatement();
	sql = " SELECT a.end_qty, a.unit_price  FROM oraddman.tspmd_item_quotation a  "+
				 " where vendor_code ='"+SUPPLIERNO+"'  and inventory_item_id='"+ITEMID+"'"+
				 " and vendor_site_id ='"+VENDOR_SITE_ID+"' order by a.end_qty";
	ResultSet rs=statement.executeQuery(sql);
	out.println("<select NAME='UNITPRICELIST' style='visibility:hidden'>");
	while (rs.next())
	{            
		out.println("<OPTION VALUE='"+(new DecimalFormat("####0.####")).format(Float.parseFloat(rs.getString(2)))+"'>"+rs.getString(1));
	} 
	out.println("</select>"); 
	statement.close();		  		  
	rs.close();        	 
} 
catch (Exception e) 
{ 
	out.println("Exception2:"+e.getMessage()); 
} 	
%>
<table width="100%" border="1" align="left" cellpadding="1" cellspacing="0"  bordercolorlight="#FFFFFF"  bordercolordark="#9999CC">
	<tr>
		<td width="100%" height="21" colspan="12" class="style2">訂單資訊：</td>
	</tr>
	<tr>
		<td class="style2" width="10%" height="30" ><font class="style2" style="font-family:'細明體'; color: #000000;">申請單號:</font></td>
		<td class="style1" width="30%"><input type="text" name="REQUESTNO" style="font-size:14px;font-family:Arial;text-align:LEFT;color:#0000CC" value="<%=REQUESTNO%>" size="12" onkeydown="return (event.keyCode!=8);" readonly>		&nbsp;&nbsp;
		<input type="hidden" name="ACTIONTYPE" value="<%=ACTIONTYPE%>"><input type='hidden' name="STATUSTYPE" value="<%=STATUSTYPE%>"></td>
		<td class="style2" width="10%" ><font class="style4" style="font-family:'細明體'; color: #000000;">版次:</font></td>
		<td class="style1" width="10%"><input type="text" name="VERSIONID" style="font-size:14px;font-family:Arial;text-align:left;color:#0000CC" value="<%=VERSIONID%>" size="3" onkeydown="return (event.keyCode!=8);" readonly><input type="hidden" name="ORIGVERSIONID" value="<%=ORIGVERSIONID%>"></td>
		<td class="style2" width="10%" style="font-family:'細明體'; color: #000000;">開單人:</td>
	    <td class="style1" width="10%" ><input type="hidden" name="CREATORID" value="<%=CREATORID%>"><input type="text" name="CREATOR" style="font-family:Arial;text-align:left" value="<%=UserName%>" size="15" onkeydown="return (event.keyCode!=8);" readonly></td>
		<td class="style2" width="10%" style="font-family:'細明體'; color: #000000;">幣別:</td>
	    <td class="style1" width="10%" ><INPUT TYPE="text" size="8" name="CURRENCYCODE" value="<%if (CURRENCYCODE==null) out.println(""); else out.println(CURRENCYCODE);%>" style="font-family:ARIAL" onchange="setCurrType(this.form.CURRENCYCODE.value)" onkeydown="return (event.keyCode!=8);" readonly></td>
	</tr>
	<TR>		
		<td class="style2"><font style="font-family:'細明體'; color: #000000;">工單類型:</font></td>
		<td class="style1">
		<%
		try
		{   
			Statement statement=con.createStatement();
			ResultSet rs=null;		      
			sql = " select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
						 " where DATA_TYPE='WIP' AND NVL(STATUS_FLAG,'I') = 'A'";
			if (ACTIONTYPE.equals(WIPCHANGE)) sql+=" AND TYPE_NO='"+WIPTYPE+"'"; 
			rs=statement.executeQuery(sql);
			out.println("<select NAME='WIPTYPE' tabindex='1' class='style1' style='font-family:ARIAL' onchange='setValue(this.form.WIPTYPE.value)'"+ ((ACTIONTYPE.equals(WIPISSUE))?" disabled":"")+">");
			out.println("<OPTION VALUE=-->--");     
			while (rs.next())
			{            
				String s1=(String)rs.getString(1); 
				String s2=(String)rs.getString(2); 
				if (s1==WIPTYPE || s1.equals(WIPTYPE)) 
				{
					out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
				} 
				else 
				{
					out.println("<OPTION VALUE='"+s1+"'>"+s2);
				}        
			} 
			out.println("</select>"); 
			statement.close();		  		  
			rs.close();        	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception1:"+e.getMessage()); 
		} 		
		%>
		</td>
		<td class="style2"><font style="font-family:ARIAL; color: #000000;">Issue Date:</font></td>
		<td class="style1"><input type="text" name="ISSUEDATE" style="font-family:Arial;text-align:left" value="<%=ISSUEDATE%>" size="10" <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
		<%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println(""); else out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.ISSUEDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>"); %>
		</td>
		<td class="style2" width="8%" style="font-family:'細明體'; color: #000000;">預計完工日:</td>
	    <td class="style1" width="10%" ><input type="text" name="COMPLETEDATE" style="font-family:Arial;text-align:left" value="<%=COMPLETEDATE%>" size="10" onkeydown="return (event.keyCode!=8);" readonly><A href="javascript:void(0)" onclick="gfPop.fPopCalendar(document.MYFORM.COMPLETEDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A><input type="hidden"name="CREATEDATE" style="font-family:Arial;text-align:LEFT" value="<%=CREATEDATE%>" readonly></td>
		<td class="style2" style="font-family:'細明體'; color: #000000;">完工入庫倉:</td>
	    <td class="style1"><input type="text" size="3" name="SUBINVENTORY" style="font-family:Arial;text-align:LEFT" value="<%if (SUBINVENTORY==null) out.println(""); else out.println(SUBINVENTORY);%>" <%if (!WIPTYPE.equals("02") && !WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println(" onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
		<INPUT TYPE="button" name="btnStock" value=".." <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("style='font-family:ARIAL'"); else out.println("style='font-family:ARIAL'");%> onClick="subWindowSubinventoryFind();" <%if (!WIPTYPE.equals("02") && !WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println("disabled"); else out.println("");%>></td>
	</tr>    		   
	<tr>
		<td class="style2" height="30" >廠商名稱:</td>
		<td class="style1" colspan="3">
		<INPUT TYPE="text" SIZE="5" name="SUPPLIERNO" value="<%=SUPPLIERNO%>" style="font-family:ARIAL" <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
		<INPUT TYPE="button" name="btnSupplier" value=".." <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("style='visibility:hidden;font-family:ARIAL'"); else out.println("style='font-family:ARIAL'");%> onClick='subWindowSupplierFind(this.form.SUPPLIERNO.value,this.form.SUPPLIERNAME.value,this.form.ITEMID.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="4">
		<INPUT TYPE="text" SIZE="40" name="SUPPLIERNAME" value="<%=SUPPLIERNAME%>" style="font-family:ARIAL" <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
		<INPUT TYPE="hidden" NAME="VENDOR_SITE_ID" value="<%=VENDOR_SITE_ID%>">
		</td> 	
		<td class="style2">聯絡人:</td>
		<td class="style1"><INPUT TYPE="text" size="15" name="SUPPLIERCONTACT" value="<%=SUPPLIERCONTACT%>" style="font-family:ARIAL" tabindex="5" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" readonly"); else out.println("");%>></td> 
		<td class="style2">工單號碼:</td>
		<td class="style1"><font style="font-size:14px;font-family:Arial;text-align:LEFT;color:#0000CC"><%=(WIPNO.equals("")?"&nbsp;":WIPNO)%></font><input type="hidden" name="WIPNO" value="<%=WIPNO%>"><input type="hidden" name="PRNO" value="<%=PRNO%>"><input type="hidden" name="PONO" value="<%=PONO%>"><input type="hidden" name="WIPID" value="<%=WIPID%>"></td> 
	</tr>
	<TR>
		<td colspan="8">
			<table width="100%">
				<tr>			
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKASSEMBLY" value="Y" <%=CHKASSEMBLY%> tabindex="6" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled "); else out.println("");%>>封裝 <font style="font-family:Arial">Assembly</font></TD>
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKTESTING" value="Y" <%=CHKTESTING%> tabindex="7" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled"); else out.println("");%>>測試 <font style="font-family:Arial">Testing</font></TD>
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKTAPING" value="Y" <%=CHKTAPING%> tabindex="8" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled"); else out.println("");%>>編帶 <font style="font-family:Arial">T＆R</font></TD>
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKLAPPING" value="Y" <%=CHKLAPPING%> tabindex="9" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled"); else out.println("");%>>減薄 <font style="font-family:Arial">Lapping</font></TD>
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="FSM" value="Y" <%=FSM%> tabindex="9" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled"); else out.println("");%>>正面金屬濺鍍沈積 <font style="font-family:Arial">FSM</font></TD>
					<TD class="style1" width="8%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="RINGCUT" value="Y" <%=RINGCUT%> tabindex="9" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" disabled"); else out.println("");%>>環切 <font style="font-family:Arial">Ring Cut</font></TD>
					<TD class="style1" width="20%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKOTHERS" value="Y" <%=CHKOTHERS%> tabindex="10" 
					<%
						if(ACTIONTYPE.equals(WIPCHANGE))
						{
							out.println("onClick='selectCheckBox(this);'"); 
						}
						else if (ACTIONTYPE.equals(WIPISSUE))
						{
							out.println(" disabled");
						}
						else 
						{
							out.println("onClick='selectCheckBox(this);'");
						}
					%>
						>其他&nbsp;&nbsp;<input type="text" name="OTHERS" size="37" style="border-bottom-style:double;border-left:none;border-right:none;border-top:none;font-family:Arial" value="<%=OTHERS%>" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" readonly"); else out.println("");%>></td>
				</tr>
		  </table>
	  </td>
	</TR>
	<tr>
		<td colspan="8">
			<table width="100%" bordercolorlight="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolordark="#9999CC">
				<tr>
				  	<td width="8%" height="42" class="style4"><font style="font-family:Arial">TSC Prod Group</font></td>
					<td class="style4" height="42">料號<br><font style="font-family:Arial">Item No</font></td>
					<td class="style4">品名<br><font style="font-family:Arial">Device Name</font></td>
					<td class="style4">封裝型式<br><font style="font-family:Arial">Package</font></td>
					<td class="style4">芯片名稱<br><font style="font-family:Arial">Die Name</font></td>
					<td class="style4">數量<br><font style="font-family:Arial"><div id="td2"><%if (!PRICEUOM.equals("片")) out.println("Q'ty(KPC)"); else out.println("Q'ty("+PRICEUOM+")");%></div></font></td>
					<td class="style4">單價<font style="font-family:Arial">U/P</font><br><font style="font-family:Arial"><div id="td1" onClick="setUnit();"><%=CURRENCYCODE+"/"+PRICEUOM%></div></font></td>
					<td class="style4">包裝<br><font style="font-family:Arial">Packing</font></td>
					<td class="style4">封裝規格<br><font style="font-family:Arial">D/B No.</font></td>
					<td class="style4">測試規格<br><font style="font-family:Arial">Test Spec</font></td>
				</tr>
				<tr>
					<td class="style1"><input type="text" name="PROD_GROUP" style="font-size:11px;font-family:Arial" value="<%=PROD_GROUP%>" size="8" readonly><input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>"></td>
					<td class="style1"><input type="hidden" name="ITEMID" style="font-family:Arial" value="<%=ITEMID%>" ><input type="text" name="ITEMNAME" size="25" style="font-size:11px;font-family:Arial" value="<%=ITEMNAME%>" tabindex="11" <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
					<!--<input type='button' name='btnItem' value='..' <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("style='visibility:hidden;font-family:ARIAL'"); else out.println("style='font-family:ARIAL'");%> onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="12">-->
					<input type='button' name='btnItem' value='..' style='font-family:ARIAL' onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' <%=(ACTIONTYPE.equals(WIPISSUE)?" disabled":"")%> tabindex="12">					
					</td>
					<td class="style1"><input type="text" name="ITEMDESC" size="15" style="font-size:11px;font-family:Arial" value="<%=ITEMDESC%>" tabindex="13" <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%>>
					<!--<input type='button' name='btnDesc' value='..' <%if(ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) out.println("style='visibility:hidden;font-family:ARIAL'"); else out.println("style='font-family:ARIAL'");%> onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="14">-->
					<input type='button' name='btnDesc' value='..' style='font-family:ARIAL' onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' <%=(ACTIONTYPE.equals(WIPISSUE)?" disabled":"")%> tabindex="14">					
					</td>
					<td class="style1"><input type="text" name="PACKAGE" size="8" style="font-family:Arial"  value="<%=PACKAGE%>" onkeydown='return (event.keyCode!=8);' readonly></td>
					<td class="style1"><input type="text" name="DIENAME" size="12" style="font-family:Arial" value='<%=DIENAME%>' onkeydown='return (event.keyCode!=8);' readonly><input type="hidden" name="DIEID" style="font-family:Arial" value="<%=DIEID%>"><input type="hidden" name="DIEQTY" value="<%=DIE_QTY%>"><input type="hidden" name="DIEITEM" style="font-family:Arial" value="<%=DIEITEM%>"><input type="hidden" name="BILLSEQID" style="font-family:Arial" value="<%=BILLSEQID%>"></td>
					<td class="style1"><input type="text" name="QTY" size="5" style="font-family:Arial;text-align=right" value="<%=QTY%>"  onChange="getUnitPrice()" <%=(ACTIONTYPE.equals(WIPISSUE)?" readonly":"")%> tabindex="15"><input type="hidden" name="ORIGQTY" value="<%=ORIGQTY%>"><input type="hidden" name="OPENQTY" value="<%=OPENQTY%>"></td>
					<td class="style1"><input type="text" name="UNITPRICE" size="4" style="font-family:Arial;text-align=right" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat((UNITPRICE.equals("")?"0":UNITPRICE)))%>" tabindex="16" <%if (WIPTYPE.equals("01") || ACTIONTYPE.equals(WIPISSUE)) out.println("onkeydown='return (event.keyCode!=8);' readonly"); else out.println("");%> >
					<input type="hidden" name="ST_UNITPRICE" value="<%=ST_UNITPRICE%>">
					<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick="subWindowHistory()"></td>
					<td class="style1">
					<%
					try
					{   
						Statement statement=con.createStatement();
						ResultSet rs=null;		      
						sql = " select TYPE_NAME, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
									 " where DATA_TYPE='PACKING' AND NVL(STATUS_FLAG,'I') = 'A' ";
						if (ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE)) sql+=" AND TYPE_NAME='"+PACKING+"'"; 
						sql +="	 order by TYPE_NO"; 
						rs=statement.executeQuery(sql);
						out.println("<select NAME='PACKING' class='style1' tabindex='17' style='font-family:Arial' "+(ACTIONTYPE.equals(WIPISSUE)?" disabled":"")+">");
						out.println("<OPTION VALUE=-->--");     
						while (rs.next())
						{            
							String s1=(String)rs.getString(1); 
							String s2=(String)rs.getString(2); 
							if (s1==PACKING || s1.equals(PACKING)) 
							{
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
							} 
							else 
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}        
						} 
						out.println("</select>"); 
						statement.close();		  		  
						rs.close();        	 
					} 
					catch (Exception e) 
					{ 
						out.println("Exception1:"+e.getMessage()); 
					} 	
					%>
					</td>
					<td class="style1"><textarea cols="20" rows="2" name="PACKAGESPEC" style="font-size:11px;font-family:ARIAL" tabindex="18" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" readonly"); else out.println("");%>><%=PACKAGESPEC%></textarea></td>
					<td class="style1"><textarea cols="20" rows="2" name="TESTSPEC" style="font-size:11px;font-family:ARIAL" tabindex="19" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" readonly"); else out.println("");%>><%=TESTSPEC%></textarea></td>
				</tr>
			</table>
	  </td>
	</tr>
	<TR>
		<TD height="110" class="style4">備註</TD>
		<TD colspan="7" class="style1"><textarea cols="170" rows="6" name="REMARKS" style="text-align:left;font-family:Arial" tabindex="20" ><%=REMARKS%></textarea></TD>
	</TR>
	<tr>
		<TD height="40" class="style4" style="font-family:Arial">Marking</TD>
		<TD colspan="7" class="style1" ><textarea cols="170" rows="2" name="MARKING" style="font-family:ARIAL" tabindex="21" <%if(ACTIONTYPE.equals(WIPISSUE)) out.println(" readonly"); else out.println("");%>><%=MARKING%></textarea></TD>
	</TR>
	<tr>
		<TD height="40" class="style4" style="font-family:Arial">變更原因說明</TD>
		<TD colspan="7" class="style1" ><textarea cols="170" rows="2" name="CHANGE_REASON" style="font-family:ARIAL" tabindex="21"><%=CHANGE_REASON%></textarea></TD>
	</TR>	
	<TR>
		<TD colspan="8">
			<table  width="100%" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#FFFFFF"  bordercolordark="#9999CC">
				<tr>
					<td height="29" colspan="12" class="style2" style="font-family:Arial">Producton Control：</td>
				</tr>	
				<% 
				try
				{
					int idx_num=50;
					float totWQty =0,totCQty=0;
					//out.println("LINENUM="+LINENUM);
					if (LINENUM.equals("0"))
					{
						sql = " SELECT a.lot_number"+
							  ", a.wafer_qty"+
							  ", a.chip_qty"+
							  ", a.date_code"+
							  ", a.completion_date"+
							  ", a.SUBINVENTORY_CODE"+
							  ", a.inventory_item_id"+
							  ", a.inventory_item_name"+
							  ",nvl((select sum(TRANSACTION_QUANTITY) from MTL_ONHAND_QUANTITIES_DETAIL x where x.organization_id=b.organization_id and nvl(x.lot_number,'XXXX')=NVL(a.lot_number,'XXXX') and x.SUBINVENTORY_CODE=a.SUBINVENTORY_CODE and x.inventory_item_id=a.inventory_item_id ),0) lotonhand"+ 
							  ",decode('"+ACTIONTYPE+"','"+WIPMODIFY+"',nvl((select sum(x.chip_qty) orig_qty from oraddman.tspmd_oem_lines_all x WHERE x.request_no = b.request_no and x.version_id = b.orig_version_id  and x.subinventory_code=a.subinventory_code and x.inventory_item_id=a.inventory_item_id),0),'"+WIPCHANGE+"',chip_qty,'"+WIPISSUE+"',chip_qty) orig_qty"+						  
							  ",nvl((select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no = a.request_no and c.version_id=a.version_id),0) rec_cnt "+
							  //",a.transaction_source_id"+ //add by Peggy 20171013
							  ",a.WIP_ISSUE_PENDING_FLAG"+ //add by Peggy 20180529
							  ",a.wafer_number"+   //add by Peggy 20180724
							  ",a.LINE_NO"+ //add by Peggy 20210820
							  ",a.DC_YYWW"+ //add by Peggy 20221205
							  ",a.DIE_MODE"+ //add by Peggy 20221209
							  " FROM oraddman.tspmd_oem_lines_all a,oraddman.tspmd_oem_headers_all b"+
							  " WHERE a.request_no='"+REQUESTNO+"' ";
						if (ACTIONTYPE.equals(WIPCHANGE) || ACTIONTYPE.equals(WIPISSUE))
						{
							sql+=" and a.version_id =" + ORIGVERSIONID+"";
						}
						else if (ACTIONTYPE.equals(WIPMODIFY))
						{
							//sql+=" and a.version_id =" + VERSIONID+"";
							sql+=" and a.version_id =" + ORIGVERSIONID+"";
						}
						sql += " and a.request_no = b.request_no and a.version_id = b.version_id"+
							  " order by a.line_no ";
						//out.println(sql);
						Statement statementd=con.createStatement();
						ResultSet rsd=statementd.executeQuery(sql);
						int i =0;
						while (rsd.next())				
						{
							INVITEM=rsd.getString("inventory_item_name");
							INVITEMID=rsd.getString("inventory_item_id");
							if (INVITEMID.equals(""))
							{
								String [] DIE_ID = DIEID.split(",");
								if ( i<=DIE_ID.length)
								{
									sql = "select segment1 from inv.mtl_system_items_b a where organization_id="+ORGANIZATION_ID+" and inventory_item_id="+DIE_ID[i-1]+"";
									Statement statementa=con.createStatement();
									ResultSet rsa=statementa.executeQuery(sql);
									if (rsa.next())
									{
										INVITEMID = DIE_ID[i-1];
										INVITEM =rsa.getString(1);
									}
									rsa.close();
									statementa.close();
								}
							}
							Stock=rsd.getString("SUBINVENTORY_CODE");
							if (Stock==null) Stock="";
							WaferLot=rsd.getString("lot_number");
							ChipQty=rsd.getString("chip_qty");
							WaferQty=rsd.getString("wafer_qty");
							DateCode=rsd.getString("date_code");
							RequestSD=rsd.getString("completion_date");
							LotOnhand="" + (Float.parseFloat(rsd.getString("LotOnhand")) + Float.parseFloat(rsd.getString("orig_qty")));
							totWQty += Float.parseFloat(WaferQty);
							totCQty += Float.parseFloat(ChipQty);
							WaferNumber=rsd.getString("Wafer_Number");  //add by Peggy 20180724
							totWaferQty =""+(float)Math.round(totWQty*100000)/100000;
							totChipQty =""+ (float)Math.round(totCQty*100000)/100000;	
							//trans_source_id=rsd.getString("transaction_source_id");  //add by Peggy 20171013
							//if (trans_source_id==null) trans_source_id=""; 	
							WIP_ISSUE_FLAG=rsd.getString("WIP_ISSUE_PENDING_FLAG"); //add by Peggy 20180529
							WIP_MTL_STATUS="Y";//add by Peggy 20201007
							if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG="Y";
							WaferNumber=rsd.getString("wafer_number");  //add by Peggy 20180724
							DC_YYWW=rsd.getString("DC_YYWW");  //add by Peggy 20221205
							if (DC_YYWW==null) DC_YYWW="";
							DIE_MODE=rsd.getString("DIE_MODE");  //add by Peggy 20221208
							if (DIE_MODE==null) DIE_MODE="";
							i++;
							
							sql = " select distinct b.date_code from oraddman.tspmd_oem_headers_all a,oraddman.tspmd_oem_lines_all b"+
								  " where a.request_no=b.request_no and a.version_id=b.version_id and a.inventory_item_id='"+ITEMID+"'"+
								  //" and b.lot_number='"+WaferLot+"' and b.date_code is not null AND a.request_no||'-'||a.version_id <>'"+REQUESTNO+"-"+VERSIONID+"'";
								  " and b.lot_number='"+WaferLot+"' and b.date_code is not null AND a.request_no <>'"+REQUESTNO+"'"+ //add by Peggy 20131122
								  " and a.status in ('Approved','Submit')"; //add by Peggy 20230105
							//out.print(sql);
							Statement statementx=con.createStatement();
							ResultSet rsx=statementx.executeQuery(sql);
							while (rsx.next())
							{
								UseDateCode += (rsx.getString("date_code")+";");
							}	
							rsx.close();
							statementx.close();				  
							//out.println("UseDateCode="+UseDateCode);
							if (i==1)
							{
								out.println("<tr>");
								out.println("<TD width='3%' class='style4' rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+1)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp</td>");
								out.println("<TD width='4%' class='style4'>&nbsp;&nbsp;</td>");
								out.println("<TD width='4%' class='style4'><font style='font-family:細明體'>行號</font></td>");
								out.println("<TD width='24%' class='style4'><font style='font-family:Arial'>Item Name</font></td>");
								out.println("<TD width='5%' class='style4'><font style='font-family:Arial'>Wafer Subinventory</font></td>");
								out.println("<TD width='15%' class='style4'><font style='font-family:Arial'>Wafer Lot#</font></td>");
								out.println("<TD width='15%' class='style4'><font style='font-family:Arial'>Wafer片號</font></td>");
								out.println("<TD width='6%' class='style4'><font style='font-family:Arial'>Wafer Qty</font></TD>");
								out.println("<TD width='6%' class='style4'><font style='font-family:Arial'>Chip Qty</font></td>");
								out.println("<TD width='6%' class='style4'><font style='font-family:Arial'>Date Code</font></td>");
								out.println("<TD width='6%' class='style4'><font style='font-family:Arial'>DC YYWW</font></td>");
								out.println("<TD width='6%' class='style4'><font style='font-family:Arial'>DIE MODE</font></td>");
								out.println("<TD width='3%' class='style4'rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+1)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
								out.println("</TR>");
							}
							out.println("<tr>");
							out.println("<TD class='style1'><input type='button' name='BtnDel"+i+"'  size='20' value='刪除' onClick='setDelete("+i+")'"+(ACTIONTYPE.equals(WIPISSUE) && (i==1 || !WIP_ISSUE_FLAG.equals("Y"))?"disabled":"")+"></td>");
							out.println("<TD class='style1'><input type='text' name='LineNo"+i+"'    size='3'  value='"+rsd.getString("LINE_NO")+"' style='font-family:Arial' readonly></td>");
							out.println("<TD class='style1'><input type='hidden' name='INVITEMID"+i+"' value='"+INVITEMID+"'><input type='text' name='INVITEM"+i+"'  size='25' tabindex='"+(idx_num++)+"' value='"+INVITEM+"'  style='font-family:Arial;text-align:center;' "+(!WIPTYPE.equals("03")&& !WIPTYPE.equals("05")?"readonly":"")+"><input type='button' name='btnInvItem"+i+"' style='font-family:arial;"+(!WIPTYPE.equals("03") && !WIPTYPE.equals("05")?"visibility:hidden;":"")+"' value='...' title='請按我!' onClick='subWindowInvItemFind("+i+")'></td>");
							out.println("<TD class='style1'><input type='text' name='Stock"+i+"' value='"+Stock+"' size='4' style='font-family:Arial;text-align:center;' readonly></td>");
							out.println("<TD class='style1'><input type='text' name='WaferLot"+i+"'  size='14' tabindex='"+(idx_num++)+"' value='"+(WaferLot==null?"":WaferLot)+"'  style='font-family:Arial;text-align:center' readonly><input type='button' name='btnLot"+i+"' style='font-family:arial' value='...' title='請按我!' onClick='subWindowItemLotFind("+i+")'"+(ACTIONTYPE.equals(WIPISSUE) && !WIP_ISSUE_FLAG.equals("Y")?"disabled":"")+" ><input type='hidden' name='trans_source_id_"+i+"' value='"+trans_source_id+"'><input type='hidden' name='WIP_ISSUE_FLAG_"+i+"' value='"+WIP_ISSUE_FLAG+"'></td>");
							out.println("<TD class='style1'><input type='text' name='WaferNumber"+i+"'  size='14' tabindex='"+(idx_num++)+"' value='"+(WaferNumber==null?"":WaferNumber)+"'  style='font-family:Arial;text-align:center'></td>");
							out.println("<TD class='style5'><input type='text' name='WaferQty"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+(new DecimalFormat("##0.####")).format(Float.parseFloat(WaferQty))+"'  style='font-family:Arial;text-align:right' onChange='computeTotal("+'"'+"WaferQty"+'"'+")'"+(ACTIONTYPE.equals(WIPISSUE) && !WIP_ISSUE_FLAG.equals("Y")?" readonly ":"")+"></TD>");
							out.println("<TD class='style5'><input type='hidden' name='LotOnhand"+i+"' value='"+LotOnhand+"'><input type='text' name='ChipQty"+i+"'   size='12' tabindex='"+(idx_num++)+"' value='"+(new DecimalFormat("##0.####")).format(Float.parseFloat(ChipQty))+"'   style='font-family:Arial;text-align:right' onChange='computeTotal("+'"'+"ChipQty"+'"'+")'"+(ACTIONTYPE.equals(WIPISSUE) && !WIP_ISSUE_FLAG.equals("Y")?" readonly ":"")+"></TD>");
							out.println("<TD class='style1'><input type='hidden' name='UseDateCode"+i+"' value='"+UseDateCode+"'><input type='text' name='DateCode"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+(DateCode==null?"&nbsp;":DateCode)+"' style='font-family:Arial;text-align:center'  onChange='CheckDataCode("+i+")' "+(ACTIONTYPE.equals(WIPISSUE) && !WIP_ISSUE_FLAG.equals("Y")?" readonly ":"")+">");
							out.println("<TD class='style1'><input type='text' name='DC_YYWW"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+(DC_YYWW==null?"&nbsp;":DC_YYWW)+"' maxlength='4' style='font-family:Arial;text-align:center'"+(ACTIONTYPE.equals(WIPISSUE) && !WIP_ISSUE_FLAG.equals("Y")?" readonly ":"")+" onkeydown='return (event.keyCode >= 48 && event.keyCode <=57)'>");
							out.println("<TD class='style1'>");
							try
							{   
								sql = " SELECT a.a_value, a.a_value  FROM oraddman.tsc_rfq_setup a where a_code='PMD_DIE_MODE' order by a.a_seq ";
								Statement st2=con.createStatement();
								ResultSet rs2=st2.executeQuery(sql);
								comboBoxBean.setRs(rs2);
								comboBoxBean.setSelection(DIE_MODE);
								comboBoxBean.setFontSize(11);
								comboBoxBean.setFontName("Tahoma,Georgia");
								comboBoxBean.setFieldName("DIE_MODE"+i);	   
								out.println(comboBoxBean.getRsString());				   
								rs2.close();   
								st2.close();     	 
							} 
							catch (Exception e) 
							{ 
								out.println("Exception:"+e.getMessage()); 
							} 							
							if (DateCode!=null && DateCode.toUpperCase().equals("HOLD"))
							{
							%>
							<input type="button" name="cpline"  size="20" value="Copy Line" style="font-family:arial" onClick='setCopyLine("../jsp/TSCPMDOEMModify.jsp?CPLINE=<%=i%>&ACTIONCODE=AddLine&ACTIONTYPE=<%=ACTIONTYPE%>&REQUESTNO=<%=REQUESTNO+"-"+VERSIONID%>")'>
							<%
							}
							out.println("</td>");
							//out.println("<TD class='style1'><input type='text' name='RequestSD"+i+"' size='10' tabindex='"+(idx_num++)+"' value='"+RequestSD+"' style='font-family:Arial;text-align:center' readonly>");
							//out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.RequestSD"+i+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");
							//out.println("</td>");					
							out.println("</tr>");
						}
						rsd.close();
						statementd.close();
						LINENUM = ""+ i;
						ORIGTOTCHIPQTY=totChipQty;
					}
					else
					{
					%>
						<TR>
							<TD class="style4" rowspan="<%=Integer.parseInt(LINENUM)+1%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
							<TD class="style4">&nbsp;&nbsp;</td>
							<TD class="style4"><font style="font-family:細明體">行號</font></td>
							<TD class="style4"><font style="font-family:Arial">Item Name</font></td>
							<TD class="style4"><font style="font-family:Arial">Wafer Subinventory</font></td>
							<TD class="style4"><font style="font-family:Arial">Wafer Lot#</font></td>
							<TD class="style4"><font style="font-family:Arial">Wafer片號</font></td>
							<TD class="style4"><font style="font-family:Arial">Wafer Qty</font></TD>
							<TD class="style4"><font style="font-family:Arial">Chip Qty</font></td>
							<TD class="style4"><font style="font-family:Arial">Date Code</font></td>
							<TD class="style4"><font style="font-family:Arial">DC YYWW</font></td>
							<TD class="style4"><font style="font-family:Arial">DIE MODE</font></td>
							<!--<TD class="style4"><font style="font-family:Arial">Request S/D</font></td>-->
							<TD class="style4" rowspan="<%=Integer.parseInt(LINENUM)+1%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</TR>
					<%
						int linenum = 0;
						for (int i = 1; i <=Integer.parseInt(LINENUM) ; i++)
						{ 
							if (i ==Integer.parseInt(LINENUM) && !CPLINE.equals(""))
							{
								linenum = Integer.parseInt(CPLINE);
							}
							else if (i >(Integer.parseInt(LINENUM)-Integer.parseInt(ADDLINE)) && (!COPY_NUM.equals("") && COPY_LINE.equals("Y")))
							{
								linenum = Integer.parseInt(COPY_NUM);
							}
							else 
							{
								linenum = i;
							}
							
							Stock=request.getParameter("Stock"+linenum);
							if (Stock==null) Stock="";
							INVITEM=request.getParameter("INVITEM"+linenum);
							if (INVITEM==null) INVITEM="";
							INVITEMID=request.getParameter("INVITEMID"+linenum);
							if (INVITEMID==null) INVITEMID="";
							if (INVITEMID.equals("") && WIP_ISSUE_FLAG.equals("Y"))
							{
								String [] DIE_ID = DIEID.split(",");
								if ( i<=DIE_ID.length)
								{
									sql = "select segment1 from inv.mtl_system_items_b a where organization_id="+ORGANIZATION_ID+" and inventory_item_id="+DIE_ID[i-1]+"";
									Statement statementa=con.createStatement();
									ResultSet rsa=statementa.executeQuery(sql);
									if (rsa.next())
									{
										INVITEMID = DIE_ID[i-1];
										INVITEM =rsa.getString(1);
									}
									rsa.close();
									statementa.close();
								}
							}						
							WaferLot=request.getParameter("WaferLot"+linenum);
							if (WaferLot==null) WaferLot="";
							ChipQty=request.getParameter("ChipQty"+i);
							if (ChipQty ==null) ChipQty="";
							WaferQty=request.getParameter("WaferQty"+i);
							if (WaferQty==null) WaferQty="";
							WaferNumber=request.getParameter("WaferNumber"+i);
							if (WaferNumber==null) WaferNumber="";
							DateCode=request.getParameter("DateCode"+i);
							if (DateCode==null) DateCode="";
							LotOnhand = request.getParameter("LotOnhand"+linenum);
							if (LotOnhand==null) LotOnhand ="0";					
							UseDateCode = request.getParameter("UseDateCode"+i);
							if (UseDateCode==null) UseDateCode ="";
							trans_source_id = request.getParameter("trans_source_id_"+linenum);  //add by Peggy 20171013
							if (trans_source_id==null) trans_source_id=""; 
							WIP_ISSUE_FLAG=request.getParameter("WIP_ISSUE_PENDING_FLAG_"+linenum); //add by Peggy 20180529
							if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG="Y";	
							V_LINENO = request.getParameter("LineNo"+linenum); //add by Peggy 20210820
							if (!DateCode.trim().toUpperCase().equals("HOLD") || V_LINENO==null) 
							{
								V_LINENO=""+i;
							}				
							DC_YYWW=request.getParameter("DC_YYWW"+i);
							if (DC_YYWW==null) DC_YYWW="";
							DIE_MODE=request.getParameter("DIE_MODE"+i);
							if (DIE_MODE==null) DIE_MODE="";
					%>
						<TR>
							<TD class="style1"><input type="button" name="<%="BtnDel"+i%>"  size="20" value="刪除" onClick='setDelete(<%=i%>)' <%=(ACTIONTYPE.equals(WIPISSUE)&&(i==1 || !WIP_ISSUE_FLAG.equals("Y"))?"disabled":"")%>></td>
							<TD class="style1"><input type="text" name="<%="LineNo"+i%>"     size="2"  value="<%=V_LINENO%>" style="font-family:Arial" readonly></td>
							<TD class="style1"><input type="hidden" name ="<%="INVITEMID"+i%>" value="<%=INVITEMID%>"><input type="text" name="<%="INVITEM"+i%>" size="27" tabindex="<%=(idx_num++)%>" value="<%=INVITEM%>" style="font-family:Arial;text-align:center" <%if(!WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println("readonly"); else out.println("");%>><input type="button" name="<%="btnInvItem"+i%>" <%if(!WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println("style='font-family:arial;visibility:hidden;'"); else out.println("style='font-family:arial;'");%> value="..." title="請按我!" onClick="subWindowInvItemFind(<%=i%>)" tabindex="<%=(idx_num++)%>"></td>
							<TD class="style1"><input type="text" name ="<%="Stock"+i%>" value="<%=(Stock==null?"":Stock)%>"  size="13" style="font-family:Arial;text-align:center;" readonly></td>
							<TD class="style1"><input type="text" name="<%="WaferLot"+i%>"  size="15" tabindex="<%=(idx_num++)%>" value="<%=WaferLot%>" style="font-family:Arial;text-align:center" readonly><input type="button" name="<%="btnLot"+i%>" style="font-family:arial" value="..." title="請按我!" onClick="subWindowItemLotFind(<%=i%>)" tabindex="<%=(idx_num++)%>"  <%=(ACTIONTYPE.equals(WIPISSUE)&&!WIP_ISSUE_FLAG.equals("Y")?"disabled":"")%>><input type="hidden" name="<%="trans_source_id_"+i%>" value="<%=trans_source_id%>"><input type="hidden" name="<%="WIP_ISSUE_FLAG_"+i%>" value="<%=WIP_ISSUE_FLAG%>"></td>
							<TD class="style1"><input type="text" name="<%="WaferNumber"+i%>"  size="15" tabindex="<%=(idx_num++)%>" value="<%=WaferNumber%>" style="font-family:Arial;text-align:center"></td>
							<TD class="style5"><input type="text" name="<%="WaferQty"+i%>"   size="14" tabindex="<%=(idx_num++)%>" value="<%=WaferQty%>" style="font-family:Arial;text-align:right" onchange="computeTotal('WaferQty')" <%=(ACTIONTYPE.equals(WIPISSUE)&&!WIP_ISSUE_FLAG.equals("Y")?" readonly":"")%>></TD>
							<TD class="style5"><input type="hidden" name="<%="LotOnhand"+i%>" value="<%=LotOnhand%>"><input type="text" name="<%="ChipQty"+i%>"  size="14" tabindex="<%=(idx_num++)%>" value="<%=ChipQty%>" style="font-family:Arial;text-align:right" onchange="computeTotal('ChipQty')" <%=(ACTIONTYPE.equals(WIPISSUE)&&!WIP_ISSUE_FLAG.equals("Y")?" readonly":"")%>></td>
							<TD class="style1"><input type="hidden" name="<%="UseDateCode"+i%>" value="<%=UseDateCode%>"><input type="text" name="<%="DateCode"+i%>" size="12" tabindex="<%=(idx_num++)%>" value="<%=DateCode%>" style="font-family:Arial;text-align:center"  onChange="CheckDataCode(<%=i%>)" <%=(ACTIONTYPE.equals(WIPISSUE)&&!WIP_ISSUE_FLAG.equals("Y")?" readonly":"")%>>
							<TD class="style1"><input type="text" name="<%="DC_YYWW"+i%>" size="12" tabindex="<%=(idx_num++)%>" value="<%=DC_YYWW%>" style="font-family:Arial;text-align:center" <%=(ACTIONTYPE.equals(WIPISSUE)&&!WIP_ISSUE_FLAG.equals("Y")?" readonly":"")%>>
							<TD class="style1">
							<%
							try
							{   
								sql = " SELECT a.a_value, a.a_value  FROM oraddman.tsc_rfq_setup a where a_code='PMD_DIE_MODE' order by a.a_seq ";
								Statement st2=con.createStatement();
								ResultSet rs2=st2.executeQuery(sql);
								comboBoxBean.setRs(rs2);
								comboBoxBean.setSelection(DIE_MODE);
								comboBoxBean.setFontSize(11);
								comboBoxBean.setFontName("Tahoma,Georgia");
								comboBoxBean.setFieldName("DIE_MODE"+i);	   
								out.println(comboBoxBean.getRsString());				   
								rs2.close();   
								st2.close();     	 
							} 
							catch (Exception e) 
							{ 
								out.println("Exception:"+e.getMessage()); 
							} 
							if (DateCode!=null && DateCode.toUpperCase().equals("HOLD"))
							{
							%>
							<input type="button" name="cpline"  size="20" value="Copy Line" style="font-family:arial" onClick='setCopyLine("../jsp/TSCPMDOEMModify.jsp?CPLINE=<%=i%>&ACTIONCODE=AddLine&ACTIONTYPE=<%=ACTIONTYPE%>&REQUESTNO=<%=REQUESTNO+"-"+VERSIONID%>")'>
							<%
							}
							%>
							</td>
							<!--<TD class="style1"><input type="text" name="<%="RequestSD"+i%>"  size="10" tabindex="<%=(idx_num++)%>" value="<%=RequestSD%>" style="font-family:Arial;text-align:center" readonly>-->
					<%
							//out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM."+"RequestSD"+i+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");					
					%>
							<!--</td>-->
						</TR>
					<%
						}
					}
				}
				catch(Exception e)
				{
					out.println("Exception11:"+e.getMessage());
				}
				%>
				<tr>
						<TD class="style6" colspan="7"><font style="font-family:arial;text-align:Right">Total：</font></td>
						<TD class="style4" style="border-left-color:#CCCCFF"><input type="text" name="totWaferQty" value="<%=totWaferQty%>" size="15" style="font-family:arial; text-align:right; background-color:#CCCCFF; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></TD>
						<TD class="style4" style="border-left-color:#CCCCFF"><input type="text" name="totChipQty" value="<%=totChipQty%>" size="15" style="font-family:arial; text-align:right; background-color:#CCCCFF; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"><input type="hidden" name="ORIGTOTCHIPQTY" value="<%=ORIGTOTCHIPQTY%>"></td>
						<TD class="style4"colspan="3" style="border-left-color:#BBDDEE">&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<TD colspan="7"><font style="font-size:12px;font-family:標楷體;color:#000000"><strong>
					  <jsp:getProperty name="rPH" property="pgAction"/>
					  =></strong></font>						
					<%
					try
					{    
						sql = "SELECT a.type_no, a.type_name  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE='F1-001' and a.status_flag='A'";
						if (ACTIONTYPE.equals(WIPISSUE))
						{
							sql += " and a.TYPE_NO in ('006','007')";
						}
						else
						{
							sql += " and a.TYPE_NO not in ('006','007')";
							if (ACTIONTYPE.equals(WIPCHANGE))
							{
								sql += " and a.TYPE_NO not in ('005')";
							}
						}
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery(sql);
						comboBoxBean.setRs(rs1);
						comboBoxBean.setFieldName("ACTIONID");	   
						comboBoxBean.setOnChangeJS("subAction()");	   
						out.println(comboBoxBean.getRsString());
						rs1.close();       
						statement1.close();
					} //end of try
					catch (Exception e)
					{
						out.println("Exception1:"+e.getMessage());
					}
					%>
						<INPUT TYPE="button" tabindex='41' value='Submit' name="Submit1" onClick='setSubmit();' style="font-family:arial"></font>
				  </td>
					<TD colspan="4" align="right" style="border-left-style: none;"><input type="text" name="txtLine"  size="5" value="" style="font-family:arial;text-align:right"><input type="button" name="addline"  size="20" value="AddLine" style="font-family:arial" onClick='setAddLine("../jsp/TSCPMDOEMModify.jsp?ACTIONCODE=AddLine&ACTIONTYPE=<%=ACTIONTYPE%>&REQUESTNO=<%=REQUESTNO+"-"+VERSIONID%>")'>
					<input type="checkbox" name="COPY_LINE" value="Y" onClick="chkObjX()"><font style="font-size:11px;font-family:arial">COPY LINE</font><input type="text" name="COPY_NUM" valule="" size="2" style="font-family:arial;" disabled>
					</TD>
				</tr>
		  	</table>
	  </TD>
	</TR>
</table>
<input type="hidden" name="LINENUM" value="<%=LINENUM%>">
<input type="hidden" name="PRICE_UOM" value="<%=PRICEUOM%>">
<input type="hidden" name="PRICE_SOURCE_UOM" value="<%=PRICESOURCEUOM%>">
<input type="hidden" name="AVL" value="<%=AVL%>">
<input type="checkbox" name="WIP_ISSUE_FLAG" value="Y" <%=WIP_ISSUE_FLAG.equals("Y")?"checked":""%> style="visibility:hidden">
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
</html>
