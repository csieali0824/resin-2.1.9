<!-- 20150209 Peggy,微鑫3292,北新科3867,昇陽國際2012三家以片計價-->
<!-- 20150317 Peggy,北新科3867只做測試-->
<!-- 20150506 Peggy,remark增加5. Wafer lot : -->
<!-- 20150317 Peggy,3864薩摩亞商捷敏科有限公司台灣分公司改以kpcs計價-->
<!-- 20150608 Peggy,秀武電子3967以片計價-->
<!-- 20150608 Peggy,華泰電子3915以片計價-->
<!-- 20150616 Peggy,薩摩亞商捷敏3864以片計價-->
<!-- 20150702 Peggy,捷敏3979以片計價-->
<!-- 20150812 Peggy,捷敏3979量產以K計價-->
<!-- 20160914 Peggy,新增bill_sequence_id-->
<!-- 20161104 Peggy,新增prd 外包-->
<!-- 20170817 Peggy,預計完工日移至表頭,取消line request date,新增暫不發料選項-->
<!-- 20171012 Peggy,新增RD3工程入庫交易-->
<!-- 20171027 Peggy,新增RD5工程入庫交易-->
<!-- 20180124 Peggy,晶片發往封裝廠寄存,D/C輸入HOLD表工單未下線數-->
<!-- 20180724 Peggy,新增晶片片號FOR 4056天水華天-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="WIPShipBean" scope="session" class="Array2DimensionInputBean"/>
<title>PMD委外加工單-新增</title>
<script language="JavaScript" type="text/JavaScript">
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

	document.MYFORM.action=URL;
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
				document.MYFORM.elements["DC_YYWW"+i].value = document.MYFORM.elements["DC_YYWW"+(i+1)].value;
				//document.MYFORM.elements["RequestSD"+i].value = document.MYFORM.elements["RequestSD"+(i+1)].value;
				document.MYFORM.elements["UseDateCode"+i].value = document.MYFORM.elements["UseDateCode"+(i+1)].value;
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
				document.MYFORM.elements["DC_YYWW"+i].value = "";
				//document.MYFORM.elements["RequestSD"+i].value = "";
				document.MYFORM.elements["UseDateCode"+i].value ="";
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
	var wiptype = document.MYFORM.WIPTYPE.value;
	if (wiptype !="03" && wiptype !="05")  //重工
	{
		//PRD排除在同型號D/C不重複之限制外,add by Peggy 20170609
		if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")<0)
		{
			var useDateCode = document.MYFORM.elements["UseDateCode"+chooseLine].value;
			var DateCode = document.MYFORM.elements["DateCode"+chooseLine].value.toUpperCase();;
			var strlen = useDateCode.split(";");
			for (var i = 0 ; i< strlen.length ; i++)
			{
				//if (DateCode != null && DateCode != "" && strlen[i] == DateCode)
				if (DateCode != null && DateCode != "" && DateCode != "HOLD" && DateCode != "NA" && DateCode != "N/A" && strlen[i] == DateCode)
				{
					alert("DateCode:"+DateCode+"已使用過,請重新輸入!!");
					document.MYFORM.elements["DateCode"+chooseLine].value="";
					document.MYFORM.elements["DateCode"+chooseLine].focus();
					return false;
				}
			}
		}
		if (document.MYFORM.elements["DateCode"+chooseLine].value!="" && document.MYFORM.elements["DateCode"+chooseLine].value!="HOLD" && document.MYFORM.elements["DateCode"+chooseLine].value!="NA")
		{
			subWin=window.open("../jsp/subwindow/TSCPMDDateCodeInfoFind.jsp?ITEMNAME="+document.MYFORM.elements["ITEMNAME"].value+"&DC="+document.MYFORM.elements["DateCode"+chooseLine].value+"&LNO="+chooseLine,"subwin","width=100,height=100,scrollbars=yes,menubar=no,location=no");
		}
		else
		{
			document.MYFORM.elements["DC_YYWW"+chooseLine].value="";
		}
		
	}
	return true;
}

function subWindowSupplierFind(supplierNo,supplierName,itemID,Qty,supplierSite)
{   
	//add by Peggy 20130719
	if (document.MYFORM.WIPTYPE.value=="--" || document.MYFORM.WIPTYPE.value==null || document.MYFORM.WIPTYPE.value=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIPTYPE.focus();
		return false;
	}
	//add by Peggy 20130719
	if ((document.MYFORM.WIPTYPE.value=="01" || document.MYFORM.WIPTYPE.value=="04") && document.MYFORM.ITEMID.value=="")
	{
		alert("請先輸入料號!");
		document.MYFORM.ITEMNAME.focus();
		return false;
	}
	var WIPTYPE=document.MYFORM.WIPTYPE.value;
	subWin=window.open("../jsp/subwindow/TSCPMDSupplierInfoFind.jsp?SUPPLIERNO="+supplierNo+"&SUPPLIERNAME="+supplierName+"&ITEMID="+itemID+"&QTY="+Qty+"&SUPPLIERSITE="+supplierSite+"&WIPTYPE="+WIPTYPE,"subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}	

function subWindowSubinventoryFind()
{    
	subWin=window.open("../jsp/subwindow/TSCPMDSubinventoryFind.jsp?","subwin","width=540,height=480,scrollbars=yes,menubar=no,location=no");
}	

function subWindowItemFind(itemName,itemDesc,Vendor,Qty,supplierSite)
{
	var WIPTYPE=document.MYFORM.WIPTYPE.value;
	if (WIPTYPE=="--" || WIPTYPE==null || WIPTYPE=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIPTYPE.focus();
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSCPMDItemInfoFind.jsp?ITEMNAME="+itemName+"&ITEMDESC="+itemDesc+"&VENDOR="+Vendor+"&QTY="+Qty+"&SUPPLIERSITE="+supplierSite+"&WIPTYPE="+WIPTYPE,"subwin","width=840,height=480,scrollbars=yes,menubar=no,location=no");
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
	document.MYFORM.CHKASSEMBLY.checked=false;
	document.MYFORM.CHKTESTING.checked=false;
	document.MYFORM.CHKTAPING.checked=false;
	document.MYFORM.CHKLAPPING.checked=false;
	document.MYFORM.CHKOTHERS.checked=false;
	document.MYFORM.OTHERS.value="";
	document.MYFORM.WIP_ISSUE_FLAG.checked = false;
	if (wipType =="03" || wipType =="05") //重工
	{
		status ="visible";
		status1 = false;
		document.MYFORM.UNITPRICE.readOnly = false;
		if (curr != null && curr != "") price_uom ="k";
		document.MYFORM.btnStock.disabled = false;
		
		//add by Peggy 20200422
		if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")>=0)
		{
			if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
			{
				document.MYFORM.SUBINVENTORY.value ="71";  
			}
			else
			{
				document.MYFORM.SUBINVENTORY.value ="73";  
			}
		}
		else if (document.MYFORM.PROD_GROUP.value=="PMD")
		{
			if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
			{
				document.MYFORM.SUBINVENTORY.value ="61";  
			}
			else
			{
				document.MYFORM.SUBINVENTORY.value ="63"; 
			}
		}	
		else if (document.MYFORM.PROD_GROUP.value=="SSD")  //add by Peggy 20240304
		{
			if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
			{
				document.MYFORM.SUBINVENTORY.value ="81";  
			}
			else
			{
				document.MYFORM.SUBINVENTORY.value ="83"; 
			}
		}				
	}
	else
	{
		status ="hidden";
		status1 = true;
		//document.MYFORM.btnStock.disabled = true;
		document.MYFORM.btnStock.disabled = false;  //modify by Peggy 20230714
		
		if (wipType =="01" ) //量產,add by Peggy 20120704,工程也同量產for nono issue
		{
			document.MYFORM.UNITPRICE.readOnly = true;
			price_uom = document.MYFORM.PRICE_SOURCE_UOM.value;  //modify by Peggy 20130522
			//price_uom = document.MYFORM.PRICE_UOM.value;
			if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")>=0)
			{
				if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
				{
					document.MYFORM.SUBINVENTORY.value ="71";  
				}
				else
				{
					document.MYFORM.SUBINVENTORY.value ="73";  
				}
			}
			else if (document.MYFORM.PROD_GROUP.value=="PMD")
			{
				if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
				{
					document.MYFORM.SUBINVENTORY.value ="61";  //add by Peggy 20130709
				}
				else
				{
					document.MYFORM.SUBINVENTORY.value ="63";  //add by Peggy 20130709
				}
			}
			else if (document.MYFORM.PROD_GROUP.value=="SSD")  //add by Peggy 20240304
			{
				if (document.MYFORM.PACKAGE.value.toUpperCase() =="WAFER")
				{
					document.MYFORM.SUBINVENTORY.value ="81";  
				}
				else
				{
					document.MYFORM.SUBINVENTORY.value ="83";  
				}
			}			
			if (document.MYFORM.SUPPLIERNO.value =="3867")  //北新科只有測試,add by Peggy 20150317
			{
				document.MYFORM.CHKTESTING.checked = true;
			}
			else
			{			
				//if (document.MYFORM.SUPPLIERNO.value !="2012")  //昇陽科無封裝,add by Peggy 20141110
				if (document.MYFORM.SUPPLIERNO.value !="2012" && document.MYFORM.PACKAGE.value.toUpperCase() !="WAFER")  //封裝形式=WAFER不勾封裝 For Nono issue,add by Peggy 20180126
				{
					document.MYFORM.CHKASSEMBLY.checked =true; //add by Peggy 20130725
				}
				document.MYFORM.CHKTESTING.checked =true;  //add by Peggy 20130725
				//add by Peggy 20130726
				//if (document.MYFORM.PACKING.value =="AMMO" || document.MYFORM.PACKING.value=="TAPE & REEL")
				if ((document.MYFORM.PACKING.value =="AMMO" || document.MYFORM.PACKING.value=="TAPE & REEL") && document.MYFORM.PACKAGE.value.toUpperCase() !="WAFER")  //封裝形式=WAFER不勾編帶 For Nono issue,add by Peggy 20180126 
				{
					document.MYFORM.CHKTAPING.checked = true;
				}
				var lapping_flag=document.MYFORM.DIEITEM.value.substr(document.MYFORM.DIEITEM.value.length-3,1);
				if (lapping_flag=="A" || lapping_flag=="B")
				{
					document.MYFORM.CHKLAPPING.checked=true;
				}
			}
		} 
		else if (wipType =="04") //WAFER,add by Peggy 20170825
		{
			document.MYFORM.WIP_ISSUE_FLAG.checked = true;
			document.MYFORM.CHKOTHERS.checked = true;
			document.MYFORM.OTHERS.value = "晶圓製程生產";
			document.MYFORM.REMARKS.value ="";
			document.MYFORM.PACKAGESPEC.value="N/A";
			document.MYFORM.TESTSPEC.value="N/A";
			document.MYFORM.MARKING.value="N/A";
			document.MYFORM.SUBINVENTORY.value ="61"; 
			document.MYFORM.PRICE_UOM.value="片";
			document.getElementById("td2").innerHTML="Q'ty("+document.MYFORM.PRICE_UOM.value+")";
			document.MYFORM.QTY.value=document.MYFORM.totWaferQty.value;
		}
		else  //工程
		{
			document.MYFORM.UNITPRICE.readOnly = false;
			if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")>=0)
			{
				document.MYFORM.SUBINVENTORY.value ="74";  
			}
			else if (document.MYFORM.PROD_GROUP.value=="PMD")
			{
				document.MYFORM.SUBINVENTORY.value ="64";  //add by Peggy 20130709
			}
			else if (document.MYFORM.PROD_GROUP.value=="SSD")  //add by Peggy 20240304
			{
				document.MYFORM.SUBINVENTORY.value ="84";  
			}						
			if (document.MYFORM.SUPPLIERNO.value =="3867")  //北新科只有測試,add by Peggy 20150317
			{
				document.MYFORM.CHKTESTING.checked = true;
			}			
			if (curr != null && curr != "")
			{
				if (curr=="TWD")
				{
					price_uom ="ea";
				}
				else
				{
					price_uom ="k";
				}
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
			document.MYFORM.elements["INVITEM"+i].value="";
			document.MYFORM.elements["INVITEMID"+i].value="";
			document.MYFORM.elements["WaferLot"+i].value="";
			document.MYFORM.elements["WaferNumber"+i].value="";
			document.MYFORM.elements["Stock"+i].value="";
			document.MYFORM.elements["ChipQty"+i].value="";
			document.MYFORM.elements["LotOnhand"+i].value = "";
			document.MYFORM.elements["UseDateCode"+i].value = "";
			document.MYFORM.elements["INVITEM"+i].readOnly=status1;
		}
		document.MYFORM.elements["btnInvItem"+i].style.visibility=status;
	}
}
function subWindowItemLotFind(chooseLine)
{
	var wiptype = document.MYFORM.WIPTYPE.value;
	if (wiptype == null || wiptype =="--")
	{
		alert("請先選擇工單類型!!");
		document.MYFORM.WIPTYPE.focus();
		return false;
	}
	var GoodsItemID = "";
	var itemID = "";
	//if (wiptype =="03") //重工
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
		if (wiptype =="03" || wiptype =="05")
		{
			document.MYFORM.elements["INVITEM"+chooseLine].focus();
		}
		else
		{
			document.MYFORM.ITEMNAME.focus();
		}
		return false;
	}
	//subWin=window.open("../jsp/subwindow/TSCPMDItemLotInfoFind.jsp?LINENO="+chooseLine+"&ITEMID="+itemID+"&GOODS="+GoodsItemID,"subwin","width=750,height=500,scrollbars=yes,menubar=no,location=no");
	subWin=window.open("../jsp/subwindow/TSCPMDItemLotInfoFind.jsp?LINENO="+chooseLine+"&ITEMID="+itemID+"&GOODS="+GoodsItemID+"&TSC_PROD_GROUP="+document.MYFORM.PROD_GROUP.value+"&ONHAND_TYPE="+document.MYFORM.elements["trans_source_id_"+chooseLine].value+"&WAFERLOT="+document.MYFORM.elements["WaferLot"+chooseLine].value+"&WAFERQTY="+document.MYFORM.elements["ChipQty"+chooseLine].value,"subwin","width=750,height=500,scrollbars=yes,menubar=no,location=no");
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
	if (wipType != "01" && wipType != "04")  //add by Peggy 20130522
	{
		if (curr=="USD" || wipType =="03") //modify by Peggy 20120705
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

	var ACTIONID = document.MYFORM.ACTIONID.value;
	if (ACTIONID == "--" || ACTIONID == null || ACTIONID == "" || ACTIONID=="null")
	{
		alert("請選擇執行動作!");
		document.MYFORM.ACTIONID.focus();
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
	if (CURRENCYCODE == "" || CURRENCYCODE == null || CURRENCYCODE == "null")
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
	if (SUPPLIERNO=="4056")
	{
		if (CHKOTHERS==false)
		{
			alert("供應商=4056天水華天必須指定其他!");
			return false;		
		}
		else if (OTHERS == "" || OTHERS == null || OTHERS == "null")
		{
			alert("供應商=4056天水華天必須填寫其他說明!");
			document.MYFORM.OTHERS.focus();
			return false;		
		}
	}
	if (SUPPLIERNO=="4746")
	{
		if (CHKOTHERS==false)
		{
			alert("供應商=4746華羿微必須指定其他!");
			return false;		
		}
		else if (OTHERS == "" || OTHERS == null || OTHERS == "null")
		{
			alert("供應商=4746華羿微必須填寫其他說明!");
			document.MYFORM.OTHERS.focus();
			return false;		
		}
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
	
	if (WIPTYPE=="01") //量產
	{
		var AVL = document.MYFORM.AVL.value;
		var AVLARY = AVL.split(",");
		var avail_flag="N";
		for (var x =0; x < AVLARY.length ; x++)
		{
			if (SUPPLIERNO==AVLARY[x])
			{
				avail_flag="Y";
				break;
			}
		}
		if (avail_flag=="N")
		{
			alert("此供應商不是合法供應商!!");
			return false;
		}
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
	if (QTY == "" || QTY == null || QTY == "null" || eval(QTY)<=0)
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
	var PRICEUOM = document.MYFORM.PRICE_UOM.value;
	if (PRICEUOM == "" || PRICEUOM == null || PRICEUOM =="null")
	{
		alert("單價單位不可空白!");
		document.MYFORM.PRICE_UOM.focus();
		return false;	
	}
	
	var UNITPRICE = document.MYFORM.UNITPRICE.value;
	var ST_UNITPRICE = document.MYFORM.ST_UNITPRICE.value;  //add by Peggy 20210608
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
		if (WIPTYPE=="01") //量產工單開放調降價格(下單量達標),限制標準價*0.97內,add by Peggy 20210608
		{		
			if (eval(UNITPRICE)>eval(ST_UNITPRICE))
			{
				alert("單價不可超過標準價("+UNITPRICE+")!"); 
				document.MYFORM.UNITPRICE.focus();
				return false;
			}
			else if ((1-(Math.round(eval(UNITPRICE)/eval(ST_UNITPRICE)*1000)/1000))>0.030)
			{
				alert("調降比率必須在標準價3%內!"); 
				document.MYFORM.UNITPRICE.focus();
				return false;
			}
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
	
	var LINENUM = document.MYFORM.LINENUM.value;
	var rec_cnt =0;
	var num1=0, num11=0,num2=0,num21=0;
	var v_dc="";
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
		DateCode = DateCode.replaceAll("_",""); //add by Peggy 20221212
		var DC_YYWW = document.MYFORM.elements["DC_YYWW"+i].value;
		//var RequestSD = document.MYFORM.elements["RequestSD"+i].value;
		var LotOnhand = document.MYFORM.elements["LotOnhand"+i].value;
		if ((WaferLot != null && WaferLot != "") || ( WIPTYPE !="03" && invitem !=null && invitem != "" && invitemid !=null && invitemid != "" && WaferQty != null && WaferQty != "" && DateCode!=null && DateCode !="" && DC_YYWW!=null && DC_YYWW !="" && ChipQty != null && ChipQty != "") || (WIPTYPE =="03" && invitem !=null && invitem != "" &&  invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != "" && DateCode!=null && DateCode !="") || ( document.MYFORM.WIP_ISSUE_FLAG.checked && invitem !=null && invitem != "" &&  invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != ""))
		{
			//for (var j = i ; j <= LINENUM ; j++)
			//{
				//不卡了,add by Peggy 20120606
				/*
				if (WaferLot != "" && WaferLot!=null)
				{
					if (WIPTYPE !="03" && WaferLot == document.MYFORM.elements["WaferLot"+j].value && DateCode != document.MYFORM.elements["DateCode"+j].value)
					{
						alert("Wafer Lot:"+WaferLot+" 不允許有兩個以上的DataCode!"); 
						document.MYFORM.elements["WaferLot"+j].focus();
						return false;
					}
					else if (WIPTYPE !="03" && i != j && WaferLot == document.MYFORM.elements["WaferLot"+j].value && DateCode == document.MYFORM.elements["DateCode"+j].value)
					{
						alert("Wafer Lot:"+WaferLot+" + Date Code:"+ DateCode + "不可重複!"); 
						document.MYFORM.elements["WaferLot"+j].focus();
						return false;
					}
				}
				*/
			//}
			if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (Stock ==null || Stock ==""))
			{
				alert("請選擇倉!"); 
				document.MYFORM.elements["WaferLot"+i].focus();
				return false;
			}
			if (WIPTYPE !="03" && WIPTYPE !="05")
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
			else
			{
				//add by Peggy 20210810
				if (invitemid!=ITEMID)
				{
					alert("發料項目不正確!"); 
					document.MYFORM.elements["INVITEM"+i].focus();
					return false;
				}
			}
			if (SUPPLIERNO=="4056" && (WaferNumber==null || WaferNumber==""))
			{	
				alert("供應商=4056天水華天必須指定Wafer片號!"); 
				document.MYFORM.elements["WaferNumber"+i].focus();
				return false;			
			}
			if (SUPPLIERNO=="4746" && (WaferNumber==null || WaferNumber==""))
			{	
				alert("供應商=4746華羿微必須指定Wafer片號!"); 
				document.MYFORM.elements["WaferNumber"+i].focus();
				return false;			
			}			
					
			var regex = /^-?\d+\.?\d*?$/;
			if (!document.MYFORM.WIP_ISSUE_FLAG.checked && WIPTYPE !="03" && WIPTYPE !="05" && WaferQty.match(regex)==null) 
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
			if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (parseFloat(ChipQty) > parseFloat(LotOnhand)))
			{ 
				alert("Chip Qty不可大於目前庫存量("+LotOnhand+")!"); 
				document.MYFORM.elements["ChipQty"+i].focus();
				return false;
			}
			//if (WIPTYPE !="03" && (DateCode==null || DateCode=="")) 
			if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (DateCode==null || DateCode=="")) 
			{ 
				alert("Date Code不可空白!"); 
				document.MYFORM.elements["DateCode"+i].focus();
				return false;
			}
			else
			{
				if (CheckDataCode(i)==false)
				{
					return false;
				}
				if (WIPTYPE !="03" && WIPTYPE !="04" && WIPTYPE !="05")
				{
					if (DateCode.toUpperCase()!="HOLD" && DateCode.toUpperCase()!="N/A" && DateCode.toUpperCase()!="NA") //HOLD表寄放封裝廠的晶片數量,N/A,NA表WAFER生產不用D/C,add by Peggy 20180124
					{
						if (document.MYFORM.PROD_GROUP.value=="PMD")
						{
							//add by Peggy 20140324,check date rule是否正確
							if (ITEMNAME.substr(3,1)=="G" && (ITEMDESC!="TS19705CX6 RFG" && ITEMDESC !="TS19720CX6 RFG"))
							{
								if (DateCode.length ==3 && (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 79 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 90))
								{
									alert("Date Code第二碼不符規定!");
									return false;
								}
							}
							//add by Peggy 20191009,check datecode
							if (DateCode.length >5)
							{
								alert("Date Code長度不符規定!");
								return false;
							}
							else if (DateCode.length ==5)
							{
								if (DateCode.substr(0,1)=="G" && ((DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(2,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(2,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(3,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(3,1).toUpperCase().charCodeAt(0) > 57)))
								{
									alert("Date Code不符規定(G)!");
									return false;
								}
								else if (DateCode.substr(0,1)!="G" && ((DateCode.substr(0,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(0,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(2,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(2,1).toUpperCase().charCodeAt(0) > 57)))
								{
									alert("Date Code不符規定(Non G)!");
									return false;									
								}
							}
							else if (DateCode.length ==4)
							{
								if ((DateCode.substr(0,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(0,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 57)
								|| (DateCode.substr(2,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(2,1).toUpperCase().charCodeAt(0) > 57)) 
								{
									alert("Date Code不符規定!");
									return false;									
								}								
							}
							else if (DateCode.length ==3)
							{
								if (ITEMDESC=="TS19705CX6 RFG" || ITEMDESC=="TS19720CX6 RFG")
								{
									if ((DateCode.substr(0,1).toUpperCase().charCodeAt(0) < 65 || DateCode.substr(0,1).toUpperCase().charCodeAt(0) > 90)
									|| (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 65 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 90)
									|| (DateCode.substr(2,1).toUpperCase().charCodeAt(0) < 65 || DateCode.substr(2,1).toUpperCase().charCodeAt(0) > 90)) 
									{
										alert("Date Code不符規定!");
										return false;									
									}	
								
								}
								else
								{
									if ((DateCode.substr(0,1).toUpperCase().charCodeAt(0) < 48 || DateCode.substr(0,1).toUpperCase().charCodeAt(0) > 57)
									|| (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 65 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 90)) 
									{
										alert("Date Code不符規定!");
										return false;									
									}	
								}							
							}
						}
						else
						{
							if (document.MYFORM.PACKAGE.value.indexOf("SMPC")>=0)
							{
								if (isNaN(DateCode.substr(0,1)) || DateCode.substr(1,1).charCodeAt(0)<65 || DateCode.substr(1,1).charCodeAt(0)>90 || DateCode.length !=3)  //SPMC DATECODE RULE,add by Peggy 20170831
								{
									alert("Date Code不符規定(正確格式=YWF)!!");
									return false;
								}
							}
							//else
							//{
							//	if (isNaN(DateCode) || DateCode.length !=3)  //PRD外購 Datecode check,add by Peggy 20161201
							//	{
							//		alert("Date Code不符規定(正確格式=YWW)!!");
							//		return false;
							//	}
							//}
						}
						
						//檢查廠商代碼是否正確,add by Peggy 20190910			
						if (DateCode.substr(0,1)=="G")
						{
							v_dc=DateCode.substr(1,DateCode.length-1);
						}
						else
						{
							v_dc=DateCode;
						}
						if (v_dc.substr(1,1).charCodeAt(0)>=48 && v_dc.substr(1,1).charCodeAt(0)<=53)  //周datecode
						{
							if (v_dc.substr(v_dc.length-1,1).toUpperCase()=="N")
							{	
								if (document.MYFORM.PROD_GROUP.value.indexOf("PRD")<0)
								{
									alert("Date Code廠商碼錯誤!!");
									return false;
								}
							}
							else if (v_dc.substr(v_dc.length-1,1).toUpperCase()=="E")
							{
								if (document.MYFORM.PROD_GROUP.value.indexOf("PMD")<0)
								{
									alert("Date Code廠商碼錯誤!!");
									return false;
								}
							}
						}
					}
				}
				
				//非green的產品,製程可能走green,故出產的產品雖品名不是green,但實際卻是green,所以datecode不檢查,modify by Peggy 20140924
				//else
				//{
				//	if (DateCode.substr(1,1).toUpperCase().charCodeAt(0) < 65 || DateCode.substr(1,1).toUpperCase().charCodeAt(0) > 76)
				//	{
				//		alert("Date Code第二碼不符規定!");
				//		return false;
				//	}				
				//}
			} 	
			if (!document.MYFORM.WIP_ISSUE_FLAG.checked && DateCode!="HOLD" && DateCode!="NA" && DateCode!="N/A" && (DC_YYWW==null || DC_YYWW=="")) 
			{ 
				alert("DC YYWW不可空白!"); 
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
		if (rec_cnt ==0)
		{
			alert("請輸入工單發料資訊!");
			document.MYFORM.elements["WaferLot1"].focus;
			return false;
		}
		var totChipQty = document.MYFORM.totChipQty.value;
		var totWaferQty = document.MYFORM.totWaferQty.value;
		var DIEQTY = document.MYFORM.DIEQTY.value;
		if (DIEQTY ==null || DIEQTY =="") DIEQTY ="1";
		totChipQty = Math.round(parseFloat(totChipQty)/parseFloat(DIEQTY)*10000)/10000;
		//var maxQty = (((QTY *1.1) * 10000)/10000);
		//if ( totChipQty > maxQty)
		//{
		//	if (confirm("發料數量("+totChipQty+")超過開工數量("+QTY+")的10%，您確定嗎?")==false)
		//	{
		//		return false;
		//	}
		//}
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
	}
	
	for (var i = 1 ; i <= LINENUM ; i ++)
	{	
		if (WIPTYPE =="03" || WIPTYPE =="05")
		{
			document.MYFORM.elements["btnInvItem"+i].disabled=true;
		}
		document.MYFORM.elements["btnLot"+i].disabled=true;
	}
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
	document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?PROGRAMNAME=F1-001";
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
	//alert(num1);
	//alert(num11);
	//alert(num2);
	//alert(num21);
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
			if (DIEQTY ==null || DIEQTY=="") DIEQTY ="1";
			totQty = Math.round(parseFloat(totQty)/parseFloat(DIEQTY)*10000)/10000;
			document.MYFORM.QTY.value = totQty;
		}
		getUnitPrice();
	}
	else
	{
		if (document.MYFORM.PRICE_UOM.value =="片")
		{
			document.MYFORM.QTY.value = totQty;
			getUnitPrice();
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
	var wiptype = document.MYFORM.WIPTYPE.value;
	if (wiptype == "01")
	{
		var Qty = document.MYFORM.QTY.value;
		var price = "";
		for (var i = 0; i < document.MYFORM.UNITPRICELIST.options.length; i++) 
		{
			var rangeqty = document.MYFORM.UNITPRICELIST.options[i].text;
			if (parseFloat(Qty) <= parseFloat(rangeqty))
			{
				price = document.MYFORM.UNITPRICELIST.options[i].value;	
				break;
			}
		}	
		if (document.MYFORM.UNITPRICE.value==null || document.MYFORM.UNITPRICE.value=="") //20210608開放user手動降調單價
		{
			document.MYFORM.UNITPRICE.value = price;
		}
		document.MYFORM.ST_UNITPRICE.value = price; //add by Peggy 20210608
	} 
}
//add by Peggy 20140401
function subWindowEVAList()
{   
	if (document.MYFORM.WIPTYPE.value!="02")
	{
		alert("工程工單才能點選此功能!");
		return false;
	}
	if (document.MYFORM.ITEMDESC.value=="")
	{
		alert("請先輸入料號!");
		return false;
	}
	var	ITEMDESC = document.MYFORM.ITEMDESC.value;
	subWin=window.open("../jsp/subwindow/TSCPMDEVAItemFind.jsp?ITEMDESC="+ITEMDESC,"subwin","width=440,height=580,scrollbars=yes,menubar=no");
}
//add by Peggy 20150814
function setUnit()
{
	//if ((document.MYFORM.WIPTYPE.value=="02" || document.MYFORM.WIPTYPE.value=="03") && document.MYFORM.CURRENCYCODE.value=="USD")  //工程,重工USD允許手動調整單價單位
	if ((document.MYFORM.WIPTYPE.value=="02" || document.MYFORM.WIPTYPE.value=="03" || document.MYFORM.WIPTYPE.value=="05"))  //工程,重工允許手動調整單價單位,modify by Peggy 20170823
	{
		if (document.MYFORM.CURRENCYCODE.value=="USD" && document.MYFORM.PRICE_UOM.value.toUpperCase()=="K")
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
			if (document.MYFORM.CURRENCYCODE.value=="USD")
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
function chkObj()
{	
	if (!document.MYFORM.WIP_ISSUE_FLAG.checked)
	{
		document.getElementById("span1").style.backgroundColor ="#FFFFFF";	
	}
	else
	{
		document.getElementById("span1").style.backgroundColor ="#FFFF33";	
		for (var i = 1 ; i <= document.MYFORM.LINENUM.value ; i++)
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
			document.MYFORM.elements["DC_YYWW"+i].value = "";
			document.MYFORM.elements["UseDateCode"+i].value ="";
		}		
		if (document.MYFORM.ITEMID.value!="")
		{
			document.MYFORM.submit();
		}
	}
}

</script>
<STYLE TYPE='text/css'> 
 .style3   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:center}
 .style4   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:center}
 .style1   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:left}
 .style2   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:left}
 .style5   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:right}
 .style6   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:right}
 </STYLE>
</head>
<body>
<%
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE ="";
String VERSIONID = request.getParameter("VERSIONID");
if (VERSIONID==null) VERSIONID="0";
String WIPTYPE = request.getParameter("WIPTYPE");
if (WIPTYPE ==null) WIPTYPE ="";
String ISSUEDATE = request.getParameter("ISSUEDATE");
if (ISSUEDATE ==null) ISSUEDATE=dateBean.getYearMonthDay();
String CREATEDATE = request.getParameter("CREATEDATE");
//if (CREATEDATE==null) CREATEDATE=dateBean.getYearMonthDay();
if (CREATEDATE==null) CREATEDATE=dateBean.getYear() +"-"+dateBean.getMonth()+"-"+dateBean.getDay();
String CREATOR = request.getParameter("CREATOR");
if (CREATOR==null) CREATOR=UserName;
String CREATORID = request.getParameter("CREATORID");
if (CREATORID==null) CREATORID=userID;
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
String DIEITEM = request.getParameter("DIEITEM");
if (DIEITEM==null) DIEITEM="";  //add by Peggy 20130726
String DIEQTY = request.getParameter("DIEQTY"); //add by Peggy 20121009
if (DIEQTY==null) DIEQTY="1";
String QTY = request.getParameter("QTY");
if (QTY==null) QTY="";
String UNITPRICE = request.getParameter("UNITPRICE");
if (UNITPRICE==null) UNITPRICE="";
String PACKING = request.getParameter("PACKING");
if (PACKING ==null) PACKING="";
String PACKAGESPEC = request.getParameter("PACKAGESPEC");
if (PACKAGESPEC==null) PACKAGESPEC="";
String TESTSPEC = request.getParameter("TESTSPEC");
if (TESTSPEC==null) TESTSPEC="";
String CURRENCYCODE = request.getParameter("CURRENCYCODE");
if (CURRENCYCODE==null) CURRENCYCODE="";
String PRICEUOM = request.getParameter("PRICE_UOM");
if (PRICEUOM == null) PRICEUOM="";  //add by Peggy 20120705
String PRICESOURCEUOM = request.getParameter("PRICE_SOURCE_UOM");
if (PRICESOURCEUOM == null) PRICESOURCEUOM="";  //add by Peggy 20130522
String BILLSEQID = request.getParameter("BILLSEQID");
if (BILLSEQID==null) BILLSEQID=""; //add by Peggy 20160914
String ITEM_TYPE=request.getParameter("ITEM_TYPE");
if (ITEM_TYPE==null) ITEM_TYPE=""; //add by Peggy 20220817
String REMARKS_LIST = "1. Wafer will be delivered "+"on "+ISSUEDATE+"\n"
            + "2. Each date code has to be provided a yield report."+"\n"
            + "3. Each date code has to be provided 100 pcs EQC Data Log."+"\n"
			//+ "4. Testing yield has been required to equal or larger than 97% ; as low yield appears please highlight to TSC immediately."+"\n"
			+ "4. Testing yield has been required to as test SPEC.; as low yield appears please highlight to TSC immediately."+"\n"
			+ "5. Wafer lot : ";
			
String strRemarks="Marking 後三碼LYW 請按訂單D/C執行";
String strRemarks1="D/C 加註底線時，標籤底線請執行於末碼XXX_";
String strRemarks2="D/C欄位三碼皆有底線時，標籤D/C欄位不需加註底線"; //add by Peggy 20210527
String REMARKS=request.getParameter("REMARKS");
if (REMARKS==null && !WIPTYPE.equals("04"))
{
	REMARKS =REMARKS_LIST;
}
//add by Peggy 20200114 for NONO=>Marking 後三碼LYW 請按訂單D/C執行
if (WIPTYPE.equals("01") && (ITEMDESC.equals("TS19705CX6 RFG") || ITEMDESC.equals("TS19720CX6 RFG")))
{
	if (REMARKS.indexOf(strRemarks)<0)
	{
		REMARKS +="\n"+strRemarks;
	}
	//add by Peggy 20201005
	if (ITEMDESC.equals("TS19705CX6 RFG"))
	{
		if (REMARKS.indexOf(strRemarks1)<0)
		{
			REMARKS +="\n"+strRemarks1;
		}	
	}
	if (REMARKS.indexOf(strRemarks2)>=0)
	{
		REMARKS =REMARKS.replace("\n"+strRemarks2,"");
	}	
}
else
{
	if (REMARKS.indexOf(strRemarks)>=0)
	{
		REMARKS =REMARKS.replace("\n"+strRemarks,"");
	}
	//add by Peggy 20201005
	if (REMARKS.indexOf(strRemarks1)>=0)
	{
		REMARKS =REMARKS.replace("\n"+strRemarks1,"");
	}	
	//add by Peggy 20210527
	if (ITEMDESC.equals("TS19503CB10H RBG"))
	{	
		if (REMARKS.indexOf(strRemarks2)<0)
		{
			REMARKS +="\n"+strRemarks2;
		}	
	}
	else
	{
		if (REMARKS.indexOf(strRemarks2)>=0)
		{
			REMARKS =REMARKS.replace("\n"+strRemarks2,"");
		}		
	}
}

/*
//nono說拿掉,add by Peggy 20191015
String packingruleno ="包裝規範編號  BAT32DFN006RL000X03";
if (ITEMDESC.indexOf("TSM500P02DCQ")>=0|| ITEMDESC.indexOf("TSM250N02DCQ")>=0)  //add by Peggy 20160627
{
	if (REMARKS.indexOf(packingruleno)<0)
	{	
		REMARKS += "\n"+packingruleno;
	}
}
else
{
	if (REMARKS.indexOf(packingruleno)>=0)
	{
		REMARKS = REMARKS.replace("\n"+packingruleno,"");
	}
}*/
String MARKING= request.getParameter("MARKING");
if (MARKING ==null) MARKING="";
String LINENUM=request.getParameter("LINENUM");
if (LINENUM == null || LINENUM.equals("")) LINENUM ="10"; //預設10行
String ADDLINE=request.getParameter("txtLine");
if (ADDLINE == null || ADDLINE.equals("")) ADDLINE = "2";
if (!ACTIONCODE.equals("AddLine")) ADDLINE="0";
LINENUM = ""+(Integer.parseInt(ADDLINE)+Integer.parseInt(LINENUM));
String totWaferQty=request.getParameter("totWaferQty");
if (totWaferQty==null) totWaferQty="";
String totChipQty=request.getParameter("totChipQty");
if (totChipQty==null) totChipQty="";
String PROD_GROUP=request.getParameter("PROD_GROUP");
if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161106
String ORGANIZATION_ID= request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID=""; //add by Peggy 20161106
String COMPLETEDATE= request.getParameter("COMPLETEDATE");
if (COMPLETEDATE==null) COMPLETEDATE="";  //add by Peggy 20170817
String WIP_ISSUE_FLAG=request.getParameter("WIP_ISSUE_FLAG");
if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG=""; //add by Peggy 20170817
String SUBINVENTORY = request.getParameter("SUBINVENTORY");
if (SUBINVENTORY ==null || SUBINVENTORY.equals(""))
{
	if (PROD_GROUP.indexOf("PRD")>=0)
	{
		if (PACKAGE!=null && PACKAGE.equals("WAFER"))
		{
			SUBINVENTORY="71"; //預設71倉
		}
		else if (WIPTYPE=="01")  //工程
		{
			SUBINVENTORY="74"; //預設74倉
		}
		else
		{
			SUBINVENTORY="73"; //預設73倉
		}
	}
	else if (PROD_GROUP.equals("PMD"))
	{	
		if (PACKAGE!=null && PACKAGE.equals("WAFER"))
		{	
			SUBINVENTORY="61"; //預設61倉	
		}
		else if (WIPTYPE=="01")  //工程
		{
			SUBINVENTORY="64"; //預設64倉
		}		
		else
		{
			SUBINVENTORY="63"; //預設63倉
		}
	}
	else if (PROD_GROUP.equals("SDD"))
	{	
		if (PACKAGE!=null && PACKAGE.equals("WAFER"))
		{	
			SUBINVENTORY="81"; 
		}
		else if (WIPTYPE=="01")  //工程
		{
			SUBINVENTORY="84"; 
		}		
		else
		{
			SUBINVENTORY="83"; 
		}
	}	
	else
	{
		SUBINVENTORY=""; 
	}
}
String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
String AVL = request.getParameter("AVL");  //add by Peggy 20130719
if (AVL==null) AVL="";
String WaferLot="",ChipQty="",WaferQty="",DateCode="",RequestSD="",LotOnhand="",Stock="",INVITEMID="",INVITEM="",UseDateCode="",trans_source_id="",WaferNumber="",DC_YYWW="",DIE_MODE="";
//if (SUPPLIERNO.equals("3864"))
//if (SUPPLIERNO.equals("3864") || SUPPLIERNO.equals("3292") || SUPPLIERNO.equals("3867") || SUPPLIERNO.equals("2012"))
//if (SUPPLIERNO.equals("3292") || SUPPLIERNO.equals("3867") || SUPPLIERNO.equals("2012")) //modify by Peggy 20150507,3864薩摩亞商捷敏科有限公司台灣分公司改kpcs計價
//if (SUPPLIERNO.equals("3292") || SUPPLIERNO.equals("3867") || SUPPLIERNO.equals("2012") || SUPPLIERNO.equals("3967")) 
if (SUPPLIERNO.equals("3292") || SUPPLIERNO.equals("3867") || SUPPLIERNO.equals("2012") || SUPPLIERNO.equals("3967") || SUPPLIERNO.equals("4009") || SUPPLIERNO.equals("4682") || PACKAGE.equals("WAFER")||ITEM_TYPE.equals("WAFER"))  //逸昌以片計價,add by Peggy 20160727 //微矽 for 工單類型=CP BY PEGGY 20210730
{
	PRICEUOM ="片";PRICESOURCEUOM="片";
}
String ST_UNITPRICE=request.getParameter("ST_UNITPRICE"); //add by Peggy 20210608
if (ST_UNITPRICE==null) ST_UNITPRICE="";
String sql="";
%>
<form name="MYFORM"  METHOD="post" ACTION="TSCPMDOEMCreate.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料新增中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
 <font color="#000000" size="+2" face="標楷體"> <strong>委外加工單-新增</strong></font>
<br>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A>&nbsp;&nbsp;&nbsp;
<%
try
{   
	Statement statement=con.createStatement();
	sql = " SELECT decode(lower(a.uom),'ea',a.end_qty/1000,a.end_qty) end_qty, a.unit_price  FROM oraddman.tspmd_item_quotation a  "+
				 " where vendor_code ='"+SUPPLIERNO+"'  and inventory_item_id='"+ITEMID+"'"+
				 " and vendor_site_id ='"+VENDOR_SITE_ID+"' order by a.end_qty";
	//out.println(sql);
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
<table cellspacing="0"  bordercolordark="#9999CC" cellpadding="1" width="100%" align="left" bordercolorlight="#FFFFFF" border="1">
	<tr>
		<td  width="100%" bgcolor="#BBDDEE" colspan="10"><FONT color="#000000" size="2" class="style4">訂單資訊：</FONT></td>
	</tr>
	<tr>
		<td class="style2" width="8%">工單類型:</td>
		<td class="style1" width="24%">
		<%
		try
		{   
			Statement statement=con.createStatement();
			ResultSet rs=null;		      
			sql = " select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
						 " where DATA_TYPE='WIP' AND NVL(STATUS_FLAG,'I') = 'A' "; 
			rs=statement.executeQuery(sql);
			out.println("<select NAME='WIPTYPE' tabindex='1' class='style1' style='font-family:ARIAL' onchange='setValue(this.form.WIPTYPE.value)'>");
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
		&nbsp;&nbsp;
		<input type="checkbox" name="WIP_ISSUE_FLAG" value="Y" <%=WIP_ISSUE_FLAG.equals("Y")?"checked":""%> onClick="chkObj()"><span id="span1" style="background-color:<%=WIP_ISSUE_FLAG.equals("Y")?"#FFFF33":"#FFFFFF"%>">預開工單及採購單,暫不發料</span>
		</td>
		<td class="style2" width="6%"><font style="font-family:ARIAL">Issue Date:</font></td>
		<td class="style1" width="12%"><input type="text" size="10" name="ISSUEDATE" style="font-family:Arial;text-align:center" value="<%=ISSUEDATE%>" tabindex="2" readonly><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.ISSUEDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
		<td class="style2" width="6%" style="font-family:Arial">預計完工日:</td>
		<td class="style1" width="12%"><input type="text" size="8" name="COMPLETEDATE" style="font-family:Arial;text-align:LEFT" value="<%=COMPLETEDATE%>" readonly><A href="javascript:void(0)" onclick="gfPop.fPopCalendar(document.MYFORM.COMPLETEDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A><input type="hidden"name="CREATEDATE" style="font-family:Arial;text-align:LEFT" value="<%=CREATEDATE%>" readonly></td>
		<td class="style2" width="6%" style="font-family:Arial">開單人:</td>
		<td class="style1" width="12%"><input type="hidden" name="CREATORID" value="<%=CREATORID%>"><input type="text" size="12" name="CREATOR" style="font-family:Arial;text-align:LEFT" value="<%=CREATOR%>" readonly></td>
		<td class="style2" width="6%" style="font-family:Arial">版次:</td>
		<td class="style1" width="10%"><input type="text" size="3" name="VERSIONID" style="font-family:Arial;text-align:LEFT" value="<%=VERSIONID%>" readonly></td>
	</tr>    		   
	<tr>
		<td class="style2">廠商名稱:</td>
		<td class="style1" colspan="3">
		<INPUT TYPE="text" SIZE="5" name="SUPPLIERNO" value="<%=SUPPLIERNO%>" style="font-family:ARIAL">
		<INPUT TYPE="button" name="btnSupplier" value=".." style="font-family:ARIAL" onClick='subWindowSupplierFind(this.form.SUPPLIERNO.value,this.form.SUPPLIERNAME.value,this.form.ITEMID.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="4">
		<INPUT TYPE="text" SIZE="40" name="SUPPLIERNAME" value="<%=SUPPLIERNAME%>" style="font-family:ARIAL">
		<INPUT TYPE="hidden" NAME="VENDOR_SITE_ID" value="<%=VENDOR_SITE_ID%>">
		</td> 	
		<td class="style2">聯絡人:</td>
		<td class="style1"><INPUT TYPE="text" size="12" name="SUPPLIERCONTACT" value="<%=SUPPLIERCONTACT%>" style="font-family:ARIAL" tabindex="5"></td> 
		<td class="style2">幣別:</td>
		<td class="style1"><INPUT TYPE="text" size="8" name="CURRENCYCODE" value="<%=CURRENCYCODE%>" style="font-family:ARIAL" onchange="setCurrType(this.form.CURRENCYCODE.value)" readonly></td> 
		<td class="style2" style="font-family:Arial">完工入庫倉:</td>
		<td class="style1"><input type="text" size="3" name="SUBINVENTORY" style="font-family:Arial;text-align:LEFT" value="<%=SUBINVENTORY%>"  onkeydown="return (event.keyCode!=8);" readonly><INPUT TYPE="button" name="btnStock" value=".." style="font-family:ARIAL" onClick="subWindowSubinventoryFind();"></td>
	</tr>
	<TR>
		<td colspan="10">
			<table width="100%">
				<tr>			
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKASSEMBLY" value="Y" <%=CHKASSEMBLY%> tabindex="6">封裝 <font style="font-family:Arial">Assembly</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKTESTING" value="Y" <%=CHKTESTING%> tabindex="7">測試 <font style="font-family:Arial">Testing</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKTAPING" value="Y" <%=CHKTAPING%> tabindex="8">編帶 <font style="font-family:Arial">T＆R</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKLAPPING" value="Y" <%=CHKLAPPING%> tabindex="9">減薄 <font style="font-family:Arial">Lapping</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="FSM" value="Y" <%=FSM%> tabindex="9">正面金屬濺鍍沈積 <font style="font-family:Arial">FSM</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="RINGCUT" value="Y" <%=RINGCUT%> tabindex="9">環切 <font style="font-family:Arial">Ring Cut</font></TD>
					<TD class="style1" width="20%" style="border-style:double;border-color:#CCCCCC"><input type="checkbox" name="CHKOTHERS" value="Y" onClick="selectCheckBox(this);" <%=CHKOTHERS%> tabindex="10">其他&nbsp;&nbsp;<input type="text" name="OTHERS" size="37" style="border-bottom-style:double;border-left:none;border-right:none;border-top:none;font-family:Arial" value=<%=OTHERS%>></td>
				</tr>
			</table>
		</td>
	</TR>
	<tr>
		<td colspan="10">
			<table>
				<tr>
					<td class="style4" style="font-family:Arial">Prod Group</td>
					<td class="style4">料號<br><font style="font-family:Arial">Item No</font></td>
					<td class="style4">品名<br><font style="font-family:Arial">Device Name</font></td>
					<td class="style4">封裝型式<br><font style="font-family:Arial">Package</font></td>
					<td class="style4">芯片名稱<br><font style="font-family:Arial">Die Name</font></td>
					<td class="style4">數量<br><font style="font-family:Arial"><div id="td2"><%if (!PRICEUOM.equals("片")) out.println("Q'ty(KPC)"); else out.println("Q'ty("+PRICEUOM+")");%></div></font></td>
					<td class="style4">單價<font style="font-family:Arial">U/P</font><br><font style="font-family:Arial"><div id="td1" onClick="setUnit();"><%if (!CURRENCYCODE.equals("") && !PRICEUOM.equals("")) out.println(CURRENCYCODE+"/"+PRICEUOM); else out.println("");%></div></font></td>
					<td class="style4">包裝<br><font style="font-family:Arial">Packing</font></td>
					<td class="style4">封裝規格<br><font style="font-family:Arial">D/B No.</font></td>
					<td class="style4">測試規格<br><font style="font-family:Arial">Test Spec</font></td>
				</tr>
				<tr>
					<td class="style1"><input type="text" name="PROD_GROUP" style="font-size:11px;font-family:Arial" value="<%=PROD_GROUP%>" size="7" readonly></td>
					<td class="style1"><input type="hidden" name="ITEMID" style="font-family:Arial" value="<%=ITEMID%>" ><input type="text" name="ITEMNAME" size="25" style="font-size:11px;font-family:Arial" value="<%=ITEMNAME%>" tabindex="11"><input type='button' name='btnItem' value='..' style="font-family:Arial" onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="12"></td>
					<td class="style1"><input type="text" name="ITEMDESC" size="20" style="font-size:11px;font-family:Arial" value="<%=ITEMDESC%>" tabindex="13"><input type='button' name='btnDesc' value='..' style="font-family:Arial" onClick='subWindowItemFind(this.form.ITEMNAME.value,this.form.ITEMDESC.value,this.form.SUPPLIERNO.value,this.form.QTY.value,this.form.VENDOR_SITE_ID.value)' tabindex="14"></td>
					<td class="style1"><input type="text" name="PACKAGE" size="8" style="font-size:11px;font-family:Arial"  value="<%=PACKAGE%>" readonly>
					<input type="hidden" name="ITEM_TYPE" value="<%=ITEM_TYPE%>">
					</td>
					<td class="style1"><input type="text" name="DIENAME" size="12" style="font-size:11px;font-family:Arial" value='<%=DIENAME%>' readonly><input type="hidden" name="DIEID" style="font-family:Arial" value="<%=DIEID%>"><input type="hidden" name="DIEITEM" style="font-family:Arial" value="<%=DIEITEM%>"><input type="hidden" name="DIEQTY" style="font-family:Arial" value="<%=DIEQTY%>"><input type="hidden" name="BILLSEQID" style="font-family:Arial" value="<%=BILLSEQID%>"></td>
					<td class="style1"><input type="text" name="QTY" size="5" style="font-family:Arial;text-align=right" value="<%=QTY%>"  onChange="getUnitPrice()" tabindex="15"></td>
					<td class="style1"><input type="text" name="UNITPRICE" size="4" style="font-family:Arial;text-align=right" value="<%=UNITPRICE%>" <%if (WIPTYPE.equals("01")) out.println(""); else out.println("");%> tabindex="16">
					<input type="hidden" name="ST_UNITPRICE" value="<%=ST_UNITPRICE%>">
					<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick="subWindowHistory()"></td>
					<td class="style1">
					<%
					try
					{   
						Statement statement=con.createStatement();
						ResultSet rs=null;		      
						sql = " select TYPE_NAME, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
									 " where DATA_TYPE='PACKING' AND NVL(STATUS_FLAG,'I') = 'A' order by TYPE_NO"; 
						rs=statement.executeQuery(sql);
						out.println("<select NAME='PACKING' class='style1' tabindex='17' style='font-family:Arial'>");
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
					<td class="style1"><textarea cols="18" rows="2" name="PACKAGESPEC" style="font-size:11px;font-family:ARIAL" tabindex="18"><%=PACKAGESPEC%></textarea></td>
					<td class="style1"><textarea cols="18" rows="2" name="TESTSPEC" style="font-size:11px;font-family:ARIAL" tabindex="19"><%=TESTSPEC%></textarea></td>
				</tr>
			</table>
		</td>
	</tr>
	<TR>
		<TD class="style4">備註<A href="javascript:void(0)" title="按下滑鼠左鍵，開啟EVA項目選單" onClick="subWindowEVAList()"><img src="images/search.gif" border="0"></A></TD>
		<TD class="style1" colspan="9">
		<textarea cols="170" rows="6" name="REMARKS" style="text-align:left;font-family:Arial" tabindex="20"><%=REMARKS%></textarea></TD>
	</TR>
	<tr>
		<TD class="style4" style="font-family:Arial">Marking</TD>
		<TD class="style1" colspan="9"><textarea cols="170" rows="2" name="MARKING" style="font-family:ARIAL" tabindex="21"><%=MARKING%></textarea></TD>
	</TR>
	<TR>
		<TD colspan="10" width="100%" >
			<table width="100%" bordercolorlight="#FFFFFF" border="1" cellspacing="0"  bordercolordark="#9999CC" cellpadding="1">
				<tr>
					<td width="100%" bgcolor="#BBDDEE" colspan="13"><FONT color="#000000" size="2" face="Arial">Producton Control：</FONT></td>
				</tr>	
				<TR>
					<TD width="3%" class="style4" rowspan="<%=Integer.parseInt(LINENUM)+1%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<TD width="2%" class="style4">&nbsp;&nbsp;&nbsp;</TD>
					<TD width="3%" class="style4"><font style="font-family:細明體">行號</font></td>
					<TD width="23%" class="style4"><font style="font-family:Arial">Item Name</font></td>
					<TD width="6%" class="style4"><font style="font-family:Arial">Wafer Subinventory</font></td>
					<TD width="23%" class="style4"><font style="font-family:Arial">Wafer Lot#</font></td>
					<TD width="10%" class="style4"><font style="font-family:Arial">Wafer片號</font></td>
					<TD width="5%" class="style4"><font style="font-family:Arial">Wafer Qty</font></TD>
					<TD width="5%" class="style4"><font style="font-family:Arial">Chip Qty</font></td>
					<TD width="5%" class="style4"><font style="font-family:Arial">Date Code</font></td>
					<TD width="5%" class="style4"><font style="font-family:Arial">DC YYWW</font></td>
					<TD width="7%" class="style4"><font style="font-family:Arial">Die Mode</font></td>
					<!--<TD class="style4"><font style="font-family:Arial">Request S/D</font></td>-->
					<TD width="3%" class="style4" rowspan="<%=Integer.parseInt(LINENUM)+1%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</TR>
				<% 
				int idx_num=22;
				for (int i = 1; i <=Integer.parseInt(LINENUM); i++)
				{ 
					Stock=request.getParameter("Stock"+i);
					if (Stock==null) Stock="";
					INVITEM=request.getParameter("INVITEM"+i);
					if (INVITEM==null) INVITEM="";
					INVITEMID=request.getParameter("INVITEMID"+i);
					if (INVITEMID==null) INVITEMID="";
					if (INVITEMID.equals("") && WIP_ISSUE_FLAG.equals("Y") && !WIPTYPE.equals("03") && !WIPTYPE.equals("05"))
					{
						if (DIEID != null && !DIEID.equals(""))
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
					}
					WaferLot=request.getParameter("WaferLot"+i);
					if (WaferLot==null) WaferLot="";
					ChipQty=request.getParameter("ChipQty"+i);
					if (ChipQty ==null) ChipQty="";
					WaferQty=request.getParameter("WaferQty"+i);
					if (WaferQty==null) WaferQty="";
					DateCode=request.getParameter("DateCode"+i);
					if (DateCode==null) DateCode="";
					//RequestSD=request.getParameter("RequestSD"+i);
					//if (RequestSD==null) RequestSD= "";
					LotOnhand = request.getParameter("LotOnhand"+i);
					if (LotOnhand==null) LotOnhand ="0";
					UseDateCode = request.getParameter("UseDateCode"+i);
					if (UseDateCode==null) UseDateCode ="";
					trans_source_id=request.getParameter("trans_source_id_"+i);  //add by Peggy 20171013
					if (trans_source_id==null) trans_source_id="";
					WaferNumber=request.getParameter("WaferNumber"+i);
					if (WaferNumber==null) WaferNumber="";
					DC_YYWW=request.getParameter("DC_YYWW"+i);  //add by Peggy 20221205
					if (DC_YYWW==null) DC_YYWW="";		
					DIE_MODE=request.getParameter("DIE_MODE"+i);  //add by Peggy 20221208
					if (DIE_MODE==null) DIE_MODE="";									
					
					
				%>
					<TR>
						<TD class="style3"><input type="button" name="<%="BtnDel"+i%>"   size="5" value="刪除" onClick='setDelete(<%=i%>)'></td>
						<TD class="style3"><input type="text" name="<%="LineNo"+i%>"     size="2"  value="<%=i%>" style="font-family:Arial" readonly></td>
						<TD class="style3"><input type="hidden" name ="<%="INVITEMID"+i%>" value="<%=INVITEMID%>"><input type="text" name="<%="INVITEM"+i%>" size="24" tabindex="<%=(idx_num++)%>" value="<%=INVITEM%>" style="font-family:Arial;text-align:center" <%if (WIPTYPE.equals("03") || WIPTYPE.equals("05")) out.println(""); else out.println(" readonly");%>><input type="button" name="<%="btnInvItem"+i%>"  value="..." title="請按我!" onClick="subWindowInvItemFind(<%=i%>)" <%if (WIPTYPE.equals("03") || WIPTYPE.equals("05")) out.println("style='visibility:visible;font-family:arial'"); else out.println("style='visibility:hidden;font-family:arial'");%> tabindex="<%=(idx_num++)%>"></td>
						<TD class="style3"><input type="text" name ="<%="Stock"+i%>" value="<%=Stock%>" size="4" style="font-family:Arial;text-align:center" readonly></TD>
						<TD class="style3"><input type="text" name="<%="WaferLot"+i%>"  size="14" tabindex="<%=(idx_num++)%>" value="<%=WaferLot%>" style="font-size:11px;font-family:Arial;text-align:center" readonly><input type="button" name="<%="btnLot"+i%>" style="font-family:arial" value="..." title="請按我!" onClick="subWindowItemLotFind(<%=i%>)" tabindex="<%=(idx_num++)%>"><input type="hidden" name="<%="trans_source_id_"+i%>" value="<%=trans_source_id%>"></td>
						<TD class="style3"><input type="text" name="<%="WaferNumber"+i%>"  size="8" tabindex="<%=(idx_num++)%>" value="<%=WaferNumber%>" style="font-family:Arial;text-align:center"></td>
						<TD class="style3"><input type="text" name="<%="WaferQty"+i%>"   size="5" tabindex="<%=(idx_num++)%>" value="<%=WaferQty%>" style="font-family:Arial;text-align:right" onchange="computeTotal('WaferQty')"></TD>
						<TD class="style3"><input type="hidden" name="<%="LotOnhand"+i%>" value="<%=LotOnhand%>"><input type="text" name="<%="ChipQty"+i%>"  size="5" tabindex="<%=(idx_num++)%>" value="<%=ChipQty%>" style="font-family:Arial;text-align:right"  onFocus="getUnitPrice()" onchange="computeTotal('ChipQty')"></td>
						<TD class="style3"><input type="hidden" name="<%="UseDateCode"+i%>" value="<%=UseDateCode%>"><input type="text" name="<%="DateCode"+i%>" size="5" tabindex="<%=(idx_num++)%>" value="<%=DateCode%>" style="font-family:Arial;text-align:center"  onBlur="CheckDataCode(<%=i%>)"></td>
						<TD class="style3"><input type="text" name="<%="DC_YYWW"+i%>" size="4" tabindex="<%=(idx_num++)%>" value="<%=DC_YYWW%>" style="font-family:Arial;text-align:center" maxlength="4" onkeydown="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
						<TD class="style3">
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
						%>	
						<!--<TD class="style1"><input type="text" name="<%="RequestSD"+i%>"  size="9" tabindex="<%=(idx_num++)%>" value="<%=RequestSD%>" style="font-family:Arial;text-align:center" readonly>-->
				<%
						//out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM."+"RequestSD"+i+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");					
				%>
						<!--</td>-->
					</TR>
				<%
				}
				%>
					<tr>
						<TD class="style6" colspan="7"><font style="font-family:arial;text-align:Right">Total：</font></td>
						<TD class="style4" style="border-left-color:#BBDDEE"><input type="text" name="totWaferQty" value="<%=totWaferQty%>" size="15" style="font-family:arial; text-align:right; background-color:#BBDDEE; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></TD>
						<TD class="style4" style="border-left-color:#BBDDEE"><input type="text" name="totChipQty" value="<%=totChipQty%>" size="15" style="font-family:arial; text-align:right; background-color:#BBDDEE; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></td>
						<TD class="style4"colspan="4" style="border-left-color:#BBDDEE">&nbsp;&nbsp;&nbsp;</td>
					</tr>
					<tr>
						<TD colspan="9"><font style="font-size:12px;font-family:標楷體;color:#0011FF"><strong><jsp:getProperty name="rPH" property="pgAction"/>=></strong></font>						
						<%
						try
						{       
							Statement statement=con.createStatement();
							ResultSet rs=statement.executeQuery("SELECT a.type_no, a.type_name  FROM oraddman.tspmd_data_type_tbl a  WHERE a.DATA_TYPE='F1-001'  AND a.status_flag='A' and a.TYPE_NO not in ('005','006','007')");
							comboBoxBean.setRs(rs);
							comboBoxBean.setFieldName("ACTIONID");	   
							out.println(comboBoxBean.getRsString());
							rs.close();       
							statement.close();
						} //end of try
						catch (Exception e)
						{
							out.println("Exception1:"+e.getMessage());
						}
						%>
							<INPUT TYPE="button"  NAME="Submit1" value='Submit' onClick='setSubmit();' style="font-family:arial" tabindex="<%=(idx_num++)%>"></font></td>
					
						<TD colspan="3" style="border-left-style: none" align="right"><input type="text" name="txtLine"  size="5" value="<%=ADDLINE%>" style="font-family:arial;text-align:right"><input type="button" name="addline"  size="20" value="AddLine" style="font-family:arial" onClick='setAddLine("../jsp/TSCPMDOEMCreate.jsp?ACTIONCODE=AddLine")'></td>
					</tr>
			</table>
		</TD>
	</TR>
</table>
<input type="hidden" name="LINENUM" value="<%=LINENUM%>">
<input type="hidden" name="REMARKS_LIST" value="<%=REMARKS_LIST%>">
<input type="hidden" name="PRICE_UOM" value="<%=PRICEUOM%>">
<input type="hidden" name="PRICE_SOURCE_UOM" value="<%=PRICESOURCEUOM%>">
<input type="hidden" name="AVL" value="<%=AVL%>">
<input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<input type="hidden" name="ACTIONTYPE" value="NEW">
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
