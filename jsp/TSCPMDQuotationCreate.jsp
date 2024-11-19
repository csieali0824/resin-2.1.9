<!--20131209,起訖數量不限制(原限制為500的倍數),前次單價user自行輸入-->
<!--20161106,新增PRD外包-->
<%@ page contentType="text/html; charset=utf-8" language="java"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="Array2DimensionInputBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<head>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<title>外包PO單價簽核</title>
</head>
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
				document.MYFORM.elements["ITEMID"+i].value = document.MYFORM.elements["ITEMID"+(i+1)].value;
				document.MYFORM.elements["ITEMNAME"+i].value = document.MYFORM.elements["ITEMNAME"+(i+1)].value;
				document.MYFORM.elements["ITEMDESC"+i].value = document.MYFORM.elements["ITEMDESC"+(i+1)].value;
				document.MYFORM.elements["PRICE"+i].value = document.MYFORM.elements["PRICE"+(i+1)].value;
				document.MYFORM.elements["PREPRICE"+i].value = document.MYFORM.elements["PREPRICE"+(i+1)].value;
				document.MYFORM.elements["PERCENTAGE"+i].value = document.MYFORM.elements["PERCENTAGE"+(i+1)].value;
				document.MYFORM.elements["STARTQTY"+i].value = document.MYFORM.elements["STARTQTY"+(i+1)].value;
				document.MYFORM.elements["ENDQTY"+i].value = document.MYFORM.elements["ENDQTY"+(i+1)].value;
				document.MYFORM.elements["REASON"+i].value = document.MYFORM.elements["REASON"+(i+1)].value;
				document.MYFORM.elements["UOM"+i].value = document.MYFORM.elements["UOM"+(i+1)].value;
				document.MYFORM.elements["PRICELIST"+i].value = document.MYFORM.elements["PRICELIST"+(i+1)].value;
				document.MYFORM.elements["QTY_UNIT"+i].value = document.MYFORM.elements["QTY_UNIT"+(i+1)].value;  //add by Peggy 20121105
				document.MYFORM.elements["ORGANIZATION_ID"+i].value = document.MYFORM.elements["ORGANIZATION_ID"+(i+1)].value;  //add by Peggy 20161110
				document.MYFORM.elements["PROD_GROUP"+i].value = document.MYFORM.elements["PROD_GROUP"+(i+1)].value;   //add by Peggy 20161110
				compute(i);
			}
			else
			{
				document.MYFORM.elements["ITEMID"+i].value = "";
				document.MYFORM.elements["ITEMNAME"+i].value = "";
				document.MYFORM.elements["ITEMDESC"+i].value = "";
				document.MYFORM.elements["PRICE"+i].value = "";
				document.MYFORM.elements["PREPRICE"+i].value = "";
				document.MYFORM.elements["PERCENTAGE"+i].value ="";
				document.MYFORM.elements["STARTQTY"+i].value = "";
				document.MYFORM.elements["ENDQTY"+i].value = "";
				document.MYFORM.elements["REASON"+i].value ="";
				document.MYFORM.elements["UOM"+i].value ="";
				document.MYFORM.elements["PRICELIST"+i].value ="";
				document.MYFORM.elements["QTY_UNIT"+i].value =""; //add by Peggy 20121105
				document.MYFORM.elements["ORGANIZATION_ID"+i].value =""; //add by Peggy 20161110
				document.MYFORM.elements["PROD_GROUP"+i].value =""; //add by Peggy 20161110
			}
		}
	}
	else
	{
		return false;
	}
}

function compute(chooseLine)
{
	var newPrice = document.MYFORM.elements["PRICE"+chooseLine].value;
	var prePrice = document.MYFORM.elements["PREPRICE"+chooseLine].value;
	prePrice = prePrice.replace(",","");
	var regex = /^-?\d+\.?\d*?$/;
	if (newPrice != null && newPrice != "" && newPrice.match(regex)==null) 
	{ 
		alert("單價必須是數值型態!"); 
		document.MYFORM.elements["PRICE"+chooseLine].focus();
		return false;
	} 
	var numpercent = 0;
	if (newPrice == null || newPrice == "" || prePrice==null || prePrice=="" || parseFloat(prePrice) ==0)
	{
		document.MYFORM.elements["PERCENTAGE"+chooseLine].value = "0";
		document.MYFORM.elements["PERCENTAGE"+chooseLine].style.color="#000000";
	}
	else
	{
		numpercent = parseFloat(newPrice) - parseFloat(prePrice);
		numpercent = Math.round(parseFloat(numpercent) / parseFloat(prePrice) * 10000)/100;	
		document.MYFORM.elements["PERCENTAGE"+chooseLine].value = numpercent;
		if (numpercent <0)
		{
			document.MYFORM.elements["PERCENTAGE"+chooseLine].style.color="#0000FF";
		}
		else
		{
			document.MYFORM.elements["PERCENTAGE"+chooseLine].style.color="#FF0000";
		}
	}
}

function setVendor(objType)
{
	if (objType == "1")
	{
		document.MYFORM.SUPPLIERNAME.value="";
	}
	else
	{
		document.MYFORM.SUPPLIERNO.value="";
	}
}

function subWindowSupplierFind(supplierNo,supplierName)
{    
	subWin=window.open("../jsp/subwindow/TSCPMDSupplierInfoFind.jsp?SUPPLIERNO="+supplierNo+"&SUPPLIERNAME="+supplierName+"&FUNCNAME=F2001","subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}	

function subWindowHistory(chooseLine)
{
	var	ITEMID = document.MYFORM.elements["ITEMID"+chooseLine].value;
	if (ITEMID == null || ITEMID == "")
	{
		alert("請先輸入料號");
		document.MYFORM.elements["ITEMNAME"+chooseLine].focus();
		return false;
	}
	var	STARTQTY = document.MYFORM.elements["STARTQTY"+chooseLine].value;
	var	ENDQTY = document.MYFORM.elements["ENDQTY"+chooseLine].value;
	if (STARTQTY == null || STARTQTY == "" || ENDQTY == null || ENDQTY == "")
	{
		alert("請先輸入數量區間");
		if (STARTQTY == null || STARTQTY == "")
		{
			document.MYFORM.elements["STARTQTY"+chooseLine].focus();
		}
		else
		{
			document.MYFORM.elements["ENDQTY"+chooseLine].focus();
		}
		return false;
	}
	var REQUESTNO = document.MYFORM.REQUESTNO.value;
	var	ITEMNAME = document.MYFORM.elements["ITEMNAME"+chooseLine].value;
	var	ITEMDESC = document.MYFORM.elements["ITEMDESC"+chooseLine].value;
	subWin=window.open("../jsp/TSCPMDQuotationHistory.jsp?ITEMID="+ITEMID+"&ITEMNAME="+ITEMNAME+"&ITEMDESC="+ITEMDESC+"&REQUESTNO="+REQUESTNO+"&STARTQTY="+STARTQTY+"&ENDQTY="+ENDQTY,"subwin","width=850,height=480,scrollbars=yes,menubar=no,location=no");
}

function subWindowItemFind(chooseType,chooseLine)
{
	var itemName ="";
	var itemDesc ="";
	if (chooseType=="1")
	{
		itemName = document.MYFORM.elements["ITEMNAME"+chooseLine].value;
	}
	else
	{
		itemDesc = document.MYFORM.elements["ITEMDESC"+chooseLine].value;
	}
	var Vendor = document.MYFORM.SUPPLIERNO.value;
	var VENDORSITEID = document.MYFORM.VENDOR_SITE_ID.value;
	var PROD_GROUP = document.MYFORM.PROD_GROUP.value;
	subWin=window.open("../jsp/subwindow/TSCPMDItemInfoFind.jsp?ITEMNAME="+itemName+"&ITEMDESC="+itemDesc+"&LINENO="+chooseLine+"&VENDOR="+Vendor+"&SUPPLIERSITE="+VENDORSITEID+"&FUNCNAME=F2-001&PROD_GROUP="+PROD_GROUP,"subwin","width=740,height=480,scrollbars=yes,menubar=no,location=no");
}

function setSubmit()
{
	var ACTIONID = document.MYFORM.ACTIONID.value;
	if (ACTIONID == "--" || ACTIONID == null || ACTIONID == "" || ACTIONID=="null")
	{
		alert("請選擇執行動作!");
		document.MYFORM.ACTIONID.focus();
		return false;
	}
	
	if (ACTIONID =="002")
	{
		var SUPPLIERNO = document.MYFORM.SUPPLIERNO.value;
		if (SUPPLIERNO =="" || SUPPLIERNO == null || SUPPLIERNO =="null")
		{
			alert("請輸入廠商代碼!");
			document.MYFORM.SUPPLIERNO.focus();
			return false;	
		}
		
		var SUPPLIERNAME = document.MYFORM.SUPPLIERNAME.value;
		if (SUPPLIERNAME =="" || SUPPLIERNAME == null || SUPPLIERNAME =="null")
		{
			alert("請輸入廠商名稱!");
			document.MYFORM.SUPPLIERNAME.focus();
			return false;	
		}	
		
		var SUPPLIERSITE = document.MYFORM.SUPPLIERSITE.value;
		if (SUPPLIERSITE == "" || SUPPLIERSITE == null || SUPPLIERSITE == "null")
		{
			alert("請輸入廠商SITE!");
			document.MYFORM.SUPPLIERSITE.focus();
			return false;		
		}
	
		var CURRENCYCODE = document.MYFORM.CURRENCYCODE.value;
		if (CURRENCYCODE == "" || CURRENCYCODE == null || CURRENCYCODE == "null")
		{
			alert("幣別不可空白!");
			document.MYFORM.CURRENCYCODE.focus();
			return false;		
		}
	
		var LINENUM = document.MYFORM.LINENUM.value;
		var rec_cnt =0;
		var num1=0, num11=0,num2=0,num21=0;
		for (var i = 1 ; i <= LINENUM ; i ++)
		{
			var ITEMID = document.MYFORM.elements["ITEMID"+i].value;
			var ITEMNAME = document.MYFORM.elements["ITEMNAME"+i].value;
			var ITEMDESC = document.MYFORM.elements["ITEMDESC"+i].value;
			var PRICE = document.MYFORM.elements["PRICE"+i].value;
			var STARTQTY= document.MYFORM.elements["STARTQTY"+i].value;
			var ENDQTY= document.MYFORM.elements["ENDQTY"+i].value;
			var REASON = document.MYFORM.elements["REASON"+i].value;
			var UOM = document.MYFORM.elements["UOM"+i].value;
			var QTYUNIT =document.MYFORM.elements["QTY_UNIT"+i].value;  //add by Peggy 20121105
			if ((ITEMID != null && ITEMID != "") || (ITEMNAME != null && ITEMNAME != "") || (ITEMDESC !=null && ITEMDESC != "") || (PRICE !=null && PRICE != "") || (STARTQTY != null && STARTQTY != "") || (ENDQTY != null && ENDQTY != "") || (REASON !=null && REASON !="") || (UOM !=null && UOM !="" && UOM !="--"))
			{
				//alert("ITEMID="+ITEMID+ "   ITEMNAME="+ITEMNAME +" ITEMDESC="+ITEMDESC +"  PRICE="+PRICE +" STARTQTY="+STARTQTY +" ENDQTY="+ENDQTY+"  REASON="+REASON); 
				if (ITEMNAME ==null || ITEMNAME =="" || ITEMID ==null || ITEMID =="")
				{
					alert("項次"+i+ ":請輸入料號!"); 
					document.MYFORM.elements["ITEMNAME"+i].focus();
					return false;
				}
				if (ITEMDESC ==null || ITEMDESC =="")
				{
					alert("項次"+i+ ":請輸入品名!"); 
					document.MYFORM.elements["ITEMDESC"+i].focus();
					return false;
				}
				var regex = /^-?\d+\.?\d*?$/;
				if (PRICE.match(regex)==null) 
				{ 
					alert("項次"+i+ ":單價必須是數值型態!"); 
					document.MYFORM.elements["PRICE"+i].focus();
					return false;
				}
				else if (PRICE ==0)
				{
					alert("項次"+i+ ":單價必須大於0!"); 
					document.MYFORM.elements["PRICE"+i].focus();
					return false;
				}
				if (STARTQTY==null ||STARTQTY=="") 
				{ 
					alert("項次"+i+ ":起始訂單量不可空白!"); 
					document.MYFORM.elements["STARTQTY"+i].focus();
					return false;
				} 			
				else if (STARTQTY.match(regex)==null)
				{
					alert("項次"+i+ ":起始訂單量必須是數值型態!"); 
					document.MYFORM.elements["STARTQTY"+i].focus();
					return false;
				}
				//else if (parseFloat(STARTQTY) !=0 && (parseFloat(STARTQTY) % 500) != 0)
				else if (parseFloat(STARTQTY) !=0 && (parseFloat(STARTQTY) % parseFloat(QTYUNIT)) != 0)
				{
					alert("項次"+i+ ":起始訂單量必須等於0或為"+QTYUNIT+"倍數!"); 
					document.MYFORM.elements["STARTQTY"+i].focus();
					return false;
				}
				else if (parseFloat(STARTQTY)<0)	
				{
					alert("項次"+i+ ":起始訂單量必須大於等於零!"); 
					document.MYFORM.elements["STARTQTY"+i].focus();
					return false;
				}	
				else if (checkQty(i,"STARTQTY") == false)
				{
					return false;
				}
				//檢查料號是否有重覆
				for (var j=i+1 ; j <= LINENUM ; j++)
				{
					if ( ITEMID ==  document.MYFORM.elements["ITEMID"+j].value)
					{
						if (STARTQTY ==  document.MYFORM.elements["STARTQTY"+j].value)
						{
							alert("項次"+i+"與項次"+j+"資料重覆!"); 
							document.MYFORM.elements["ITEMNAME"+i].focus();
							return false;
						}
						//檢查相同料號其數量單位是否皆相同
						if (UOM != document.MYFORM.elements["UOM"+j].value)
						{
							alert("項次"+i+"與項次"+j+"的數量單位必須相同!"); 
							document.MYFORM.elements["UOM"+i].focus();
							return false;
						}
					}
				}
				if (ENDQTY==null || ENDQTY=="") 
				{ 
					alert("項次"+i+ ":結束訂單量不可空白!"); 
					document.MYFORM.elements["ENDQTY"+i].focus();
					return false;
				} 
				else if (ENDQTY.match(regex)==null)
				{
					alert("項次"+i+ ":結束訂單量必須是數值型態!"); 
					document.MYFORM.elements["ENDQTY"+i].focus();
					return false;
				}	
				else if (parseFloat(ENDQTY)<0)	
				{
					alert("項次"+i+ ":結束訂單量必須大於等於零!"); 
					document.MYFORM.elements["ENDQTY"+i].focus();
					return false;
				}
				else if (parseFloat(QTYUNIT) >0 && (parseFloat(ENDQTY) % parseFloat(QTYUNIT)) != 0)
				{
					alert("項次"+i+ ":"+QTYUNIT+"倍數!"); 
					document.MYFORM.elements["ENDQTY"+i].focus();
					return false;
				}
				//else if (checkQty(i,"ENDQTY") == false)
				//{
				//	return false;
				//}	
				if (UOM ==null || UOM=="" || UOM=="--")
				{
					alert("項次"+i+ ":請輸入數量單位!"); 
					document.MYFORM.elements["UOM"+i].focus();
					return false;
				}
						
				if (REASON ==null || REASON=="")
				{
					alert("項次"+i+ ":請輸入異動原因!"); 
					document.MYFORM.elements["REASON"+i].focus();
					return false;
				}
				rec_cnt ++;
			}
		}
		if (rec_cnt ==0)
		{
			alert("請輸入報價資訊!");
			document.MYFORM.elements["ITEMNAME1"].focus;
			return false;
		}
	}
	document.MYFORM.btnSubmit.disabled=true;	
	document.MYFORM.addline.disabled=true;
	document.MYFORM.upload.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action="../jsp/TSCPMDQuotationProcess.jsp";
	document.MYFORM.submit();
}

function setUpload(URL)
{
	var SUPPLIERNO = document.MYFORM.SUPPLIERNO.value;
	var SUPPLIERNAME = document.MYFORM.SUPPLIERNAME.value;
	var SUPPLIERSITE = document.MYFORM.VENDOR_SITE_ID.value;
	if (SUPPLIERNO==null || SUPPLIERNO =="" || SUPPLIERNAME==null || SUPPLIERNAME =="" || SUPPLIERSITE==null || SUPPLIERSITE =="")
	{
		alert("請先選擇廠商!");
		document.MYFORM.SUPPLIERNAME.focus();
		return false;
	}
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?SUPPLIERNO="+SUPPLIERNO+"&SUPPLIERNAME="+SUPPLIERNAME+"&SUPPLIERSITE="+SUPPLIERSITE,"subwin","width=740,height=200,scrollbars=yes,menubar=no,location=no");
}

function checkQty(chooseLine,fieldname)
{
	var LINENUM = document.MYFORM.LINENUM.value;
	var STARTQTY= document.MYFORM.elements["STARTQTY"+chooseLine].value;
	var ENDQTY= document.MYFORM.elements["ENDQTY"+chooseLine].value;
	var ITEMID = document.MYFORM.elements["ITEMID"+chooseLine].value;
	var QTYUNIT =document.MYFORM.elements["QTY_UNIT"+chooseLine].value;
	var chkqty = 0,rowcnt=0;
	var check1 = "N",check2 = "N";
	//if (fieldname=="ENDQTY" && (parseFloat(ENDQTY) % 500) !=0)
	if (parseFloat(QTYUNIT)>0)
	{
		if (fieldname=="ENDQTY" && (parseFloat(ENDQTY) % parseFloat(QTYUNIT)) !=0)
		{
			alert("數量必須為"+QTYUNIT+"或"+QTYUNIT+"的倍數!!!");
			document.MYFORM.elements[fieldname+chooseLine].value="";
			document.MYFORM.elements[fieldname+chooseLine].focus();
			return false;
		}
	}
	if (STARTQTY !=null && STARTQTY !="" && ENDQTY != null && ENDQTY != "")
	{
		if (parseFloat(ENDQTY) <= parseFloat(STARTQTY))
		{
			alert("Line:"+chooseLine + "的起始訂單量必須小於結束訂單量!!!");
			document.MYFORM.elements[fieldname+chooseLine].focus();
			return false;
		}
	}
	if (STARTQTY !=null && STARTQTY !="" && parseFloat(STARTQTY)==0) check1="Y";	
	for (var i = 1 ; i <= LINENUM ; i ++)
	{
		if (i != chooseLine && ITEMID == document.MYFORM.elements["ITEMID"+i].value && STARTQTY!=null && STARTQTY !="")
		{
			var C_STARTQTY = document.MYFORM.elements["STARTQTY"+i].value;
			var C_ENDQTY = document.MYFORM.elements["ENDQTY"+i].value;
			if (parseFloat(STARTQTY) > parseFloat(C_ENDQTY) && parseFloat(C_ENDQTY) > parseFloat(chkqty)) chkqty=C_ENDQTY;
			if (check1 =="N" && parseFloat(C_STARTQTY) ==0) check1="Y";
			if (check2 =="N" && ((C_ENDQTY != null && C_ENDQTY != "" && parseFloat(STARTQTY) == parseFloat(C_ENDQTY)) || parseFloat(STARTQTY) ==0))  check2="Y"; //檢查起始量合法性
			if (STARTQTY == C_STARTQTY)
			{
				alert("Line:"+chooseLine + "與Line:"+i+"的起始訂單量不可相同!!!");
				document.MYFORM.elements[fieldname+chooseLine].focus();
				return false;
			}
			rowcnt ++;
		}
	}
	if (parseFloat(rowcnt)==0) check2="Y";
	if (check1=="N")
	{
		alert("Line:"+chooseLine + " 起始訂單量請從0開始設起!!!");
		document.MYFORM.elements[fieldname+chooseLine].focus();
		return false;
	}
	if (check2=="N")
	{
		alert("Line:"+chooseLine + " 起始訂單量須為"+chkqty+"!!!");
		document.MYFORM.elements[fieldname+chooseLine].focus();
		return false;
	}
	if (STARTQTY !=null && STARTQTY !="" && ENDQTY != null && ENDQTY != "")
	{
		var PRICELIST= document.MYFORM.elements["PRICELIST"+chooseLine].value;
		//alert(PRICELIST);
		var array=PRICELIST.split(",");
		var PREPRICE = "";
		var price1 = "0";
		for (var i =0 ; i < array.length ; i++)
		{
			var val= array[i].split("=");
			//alert(val.length);
			//alert(parseFloat(ENDQTY));
			//alert(parseFloat(val[0]));
			//alert(parseFloat(price1));
			if (parseFloat(ENDQTY) <= parseFloat(val[0]) && (parseFloat(price1)==0 || parseFloat(val[0]) <= parseFloat(price1)))
			{
				PREPRICE = val[1];
				price1 = val[0];
			}
		}
		//document.MYFORM.elements["PREPRICE"+chooseLine].value = PREPRICE;
		compute(chooseLine);
	}
	return true;
}
function setAttache(URL)
{
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL,"subwin","width=740,height=250,scrollbars=yes,menubar=no,location=no");
}
function delAttache(URL)
{
	if (confirm("您確定要刪除檔案嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
	return false;
}
</script>
<STYLE TYPE='text/css'> 
 .style4   {font-family:細明體; font-size:12px; background-color:#D5F3FD; color:#000000;text-align:center}
 .style1   {font-family:細明體; font-size:12px; background-color:#FFFFFF; color:#000000;text-align:left}
 .style2   {font-family:細明體; font-size:12px; background-color:#D5F3FD; color:#000000;text-align:left}
 .style6   {font-family:細明體; font-size:12px; background-color:#D5F3FD; color:#000000;text-align:right}
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style5   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:center;}
</STYLE>
<body>
<%
try
{
	String REQUESTNO = request.getParameter("REQUESTNO");
	if (REQUESTNO ==null) REQUESTNO ="";
	String ACTIONCODE= request.getParameter("ACTIONCODE");
	if (ACTIONCODE==null) ACTIONCODE="Submit";
	String CREATEDATE = request.getParameter("CREATEDATE");
	//if (CREATEDATE==null) CREATEDATE=dateBean.getYearMonthDay();
	if (CREATEDATE==null) CREATEDATE=dateBean.getYear() +"-"+dateBean.getMonth()+"-"+dateBean.getDay();
	String CREATOR = request.getParameter("CREATOR");
	if (CREATOR==null) CREATOR=UserName;
	String CREATORID = request.getParameter("CREATORID");
	if (CREATORID==null) CREATORID=userID;
	String SUPPLIERNO = request.getParameter("SUPPLIERNO");
	if (SUPPLIERNO==null) SUPPLIERNO="";
	String SUPPLIERSITE = request.getParameter("SUPPLIERSITE");
	if (SUPPLIERSITE==null) SUPPLIERSITE="";
	String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
	if (SUPPLIERNAME==null) SUPPLIERNAME="";
	String CURRENCYCODE = request.getParameter("CURRENCYCODE");
	if (CURRENCYCODE==null) CURRENCYCODE="";
	String REMARKS = request.getParameter("REMARKS");
	if (REMARKS == null) REMARKS="";
	String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
	if (VENDOR_SITE_ID ==null) VENDOR_SITE_ID="";  //add by Peggy 20120705
	String LINENUM=request.getParameter("LINENUM");
	if (LINENUM == null || LINENUM.equals("")) LINENUM ="10"; //預設10行
	String ADDLINE=request.getParameter("txtLine");
	if (ADDLINE == null || ADDLINE.equals("")) ADDLINE = "0";
	if (ACTIONCODE.equals("DELATTACHE")) ADDLINE ="0";
	LINENUM = ""+(Integer.parseInt(ADDLINE)+Integer.parseInt(LINENUM));
	String FILESNUM=request.getParameter("FILESNUM");
	if (FILESNUM == null || FILESNUM.equals("")) FILESNUM ="0"; //預設1行
	String ITEMID="",ITEMNAME="",ITEMDESC="",PRICE="",REASON="", PREPRICE ="", PERCENTAGE ="",sql="",STARTQTY="", ENDQTY= "",UOM="",PRICELIST="",QTY_UNIT="",PROD_GROUP="",ORGANIZATION_ID="";
	String FILEID = request.getParameter("FILEID");
	if (FILEID == null) FILEID ="";
	String FILENAME = request.getParameter("FILENAME");
	if (FILENAME==null) FILENAME ="";
	String STATUS = request.getParameter("STATUS");
	if (STATUS==null) STATUS="";
	String NEXTWKFLOW = request.getParameter("NEXTWKFLOW");
	if (NEXTWKFLOW==null) NEXTWKFLOW="";
	String THISWKFLOW = request.getParameter("THISWKFLOW");
	if (THISWKFLOW==null) THISWKFLOW="WKFW0";
	String b[][]=new String[1][1];
	int colCnt =14;
	
	if (ACTIONCODE.equals("Reject") && !REQUESTNO.equals(""))
	{
		sql = " SELECT  a.vendor_code, a.vendor_name, a.vendor_site, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd') creation_date , a.created_by, a.created_by_name,a.vendor_site_id,"+
			  " a.status,NEXT_WKFLOW,count(1) rowcnt"+
			  " FROM oraddman.tspmd_quotation_headers_all a ,oraddman.tspmd_quotation_lines_all b "+
			  " where a.request_no='"+ REQUESTNO+"' "+
			  " and a.status='"+ACTIONCODE+"'"+
			  " and a.request_no = b.request_no"+
			  " group by a.vendor_code, a.vendor_name, a.vendor_site, a.currency_code, to_char(a.creation_date,'yyyy-mm-dd') , a.created_by, a.created_by_name,a.vendor_site_id,a.status,NEXT_WKFLOW";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if (rs.next())
		{
			SUPPLIERNO = rs.getString("vendor_code");
			SUPPLIERNAME = rs.getString("vendor_name");
			SUPPLIERSITE = rs.getString("vendor_site");
			CURRENCYCODE = rs.getString("currency_code");
			VENDOR_SITE_ID = rs.getString("vendor_site_id");
			STATUS = rs.getString("STATUS");
			NEXTWKFLOW =rs.getString("NEXT_WKFLOW");
			FILEID=REQUESTNO; 
			
			b =new String[rs.getInt("rowcnt")][colCnt];
			int i=0;
			sql = " SELECT a.INVENTORY_ITEM_ID,a.inventory_item_name, a.item_description, a.unit_price,a.previous_price, a.start_date, a.end_date,"+
				  " a.request_reason,decode(previous_price,0,0,round((unit_price-previous_price)/previous_price*100,2)) percentage,"+
				  " a.start_qty,a.end_qty,a.uom"+
				  ",a.organization_id,tsc_prod_group"+ //add by Peggy 20161110
				  " FROM oraddman.tspmd_quotation_lines_all a"+
				  " WHERE  a.request_no='"+ REQUESTNO+"' ORDER BY a.inventory_item_name,a.start_qty";
			Statement statementx=con.createStatement();
			ResultSet rsx=statementx.executeQuery(sql);
			while (rsx.next())
			{
				b[i][0]= rsx.getString("INVENTORY_ITEM_ID");
				b[i][1]= rsx.getString("inventory_item_name");
				b[i][2]= rsx.getString("item_description");
				b[i][3]= rsx.getString("unit_price");
				b[i][4]= rsx.getString("previous_price");
				b[i][5]= rsx.getString("percentage");
				b[i][6]= rsx.getString("start_QTY");
				b[i][7]= rsx.getString("end_QTY");
				b[i][8]= rsx.getString("request_reason");
				b[i][9]= rsx.getString("uom");
				String PriceList="";
				sql = " SELECT a.end_qty, a.unit_price"+
					  " FROM oraddman.tspmd_item_quotation a  "+
					  " where a.inventory_item_id='"+rsx.getString("INVENTORY_ITEM_ID")+"' and exists (select 1 from ( select x.vendor_code,x.vendor_site_id,x.inventory_item_id,row_number() over (PARTITION by x.vendor_code,x.vendor_site_id,x.inventory_item_id order by x.creation_date desc) as rowcnt"+
                      " from oraddman.tspmd_item_quotation x where x.inventory_item_id='"+rsx.getString("INVENTORY_ITEM_ID")+"') y where rowcnt =1 and y.VENDOR_SITE_ID=a.VENDOR_SITE_ID and y.vendor_code=a.vendor_code and a.vendor_site_id='"+VENDOR_SITE_ID+"')";
					  //" where a.vendor_code ='"+SUPPLIERNO+"' and a.inventory_item_id='"+rsx.getString("INVENTORY_ITEM_ID")+"' and a.VENDOR_SITE_ID='"+ VENDOR_SITE_ID+"'";
				//out.println(sql);
				Statement statement2=con.createStatement();
				ResultSet rs2=statement2.executeQuery(sql);
				while (rs2.next())
				{
					PriceList += (rs2.getString("end_qty")+"="+ (new DecimalFormat("####0.###")).format(Float.parseFloat(rs2.getString("unit_price")))+",");
				}
				rs2.close();
				statement2.close();
				b[i][10]= PriceList;
				
				/*
				sql = " select 1 SEQNO,QTY_UNIT FROM oraddman.TSPMD_QUOTATION_UNIT_SETUP where DATA_TYPE='ITEM' AND DATA_NAME ='"+rsx.getString("inventory_item_name")+"'"+
				      " UNION ALL"+
					  " select 2 SEQNO,QTY_UNIT FROM oraddman.TSPMD_QUOTATION_UNIT_SETUP where DATA_TYPE='PACKAGE' AND DATA_NAME = TSC_OM_CATEGORY('"+rsx.getString("INVENTORY_ITEM_ID")+"',49,'TSC_Package')"+
				      " UNION ALL"+
					  " select 3 SEQNO,QTY_UNIT FROM oraddman.TSPMD_QUOTATION_UNIT_SETUP where DATA_TYPE='PACKAGE' AND DATA_NAME = 'OTHER'"+
					  " order by 1";
				//out.println(sql);
				Statement statement3=con.createStatement();
				ResultSet rs3=statement3.executeQuery(sql);
				if (rs3.next())
				{
					QTY_UNIT = rs3.getString("QTY_UNIT");
				}
				rs3.close();
				statement3.close();
				b[i][11]= QTY_UNIT;
				*/
				b[i][11]=""+( Long.parseLong(rsx.getString("start_QTY"))-Long.parseLong(rsx.getString("end_QTY"))); //modify by Peggy 20131213
				b[i][12]= rsx.getString("organization_id"); //add by Peggy 20161110
				b[i][13]= rsx.getString("tsc_prod_group");  //add by Peggy 20161110
				
				
				i++;
			}
			LINENUM=""+i;
			rsx.close();
			statementx.close();
		}
		else
		{
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("此申請單非退件狀態，請重新確認，謝謝!");
				document.location.href="../jsp/TSCPMDQuotationQuery.jsp";
			</script>
	<%
		}
		rs.close();
		statement.close();
	}
	else if (ACTIONCODE.equals("EXLUPD"))
	{
		sql = " select a.VENDOR_NAME from  AP.ap_suppliers a where a.SEGMENT1='"+SUPPLIERNO+"'";
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);
		if(rs.next())
		{
			SUPPLIERNAME = rs.getString("VENDOR_NAME");
		}
		rs.close();
		statement.close();
	
		b=arrayRFQDocumentInputBean.getArray2DContent();//上傳內容
		LINENUM = ""+b.length;
	}
%>
<form name="MYFORM"  METHOD="post" ACTION="TSCPMDQuotationCreate.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font color="#000000" size="+2" face="標楷體"> <strong><%=PROD_GROUP%>外包PO單價申請作業<%if (REQUESTNO.equals("")) out.println(""); else out.println("<font style='color:#0000FF;font-family:ARIAL'>(申請單號:"+REQUESTNO+")</font>");%></strong></font><br>
<A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A>&nbsp;&nbsp;&nbsp;<br>
<table width="100%">
	<tr>
		<td>
			<table cellspacing="0"  bordercolor="#FFFFFF" bordercolorlight="#FFFFFF"  bordercolordark='#79C6EE' cellpadding="1" width="100%" align="left" border="1">
				<tr>
					<td class="style2" colspan="6" height="20">廠商資訊：</td>
				</tr>
				<tr>
					<td width="10%" class="style2">廠商名稱:</td>
					<td width="40%" class="style1">
					<INPUT TYPE="text" SIZE="5" name="SUPPLIERNO" value="<%=SUPPLIERNO%>" style="font-family:ARIAL" onChange="setVendor(1);">
					<INPUT TYPE="button" name="btnSupplier" value=".." style="font-family:ARIAL" onClick='subWindowSupplierFind(this.form.SUPPLIERNO.value,this.form.SUPPLIERNAME.value)' tabindex="4">
					<INPUT TYPE="text" SIZE="40" name="SUPPLIERNAME" value="<%=SUPPLIERNAME%>" style="font-family:ARIAL" onChange="setVendor(2);">
					<INPUT TYPE="hidden" NAME="VENDOR_SITE_ID" value="<%=VENDOR_SITE_ID%>">
					</td> 	
					<td width="10%" class="style2"><font class="style2" style="font-family:ARIAL">Site:</font></td>
					<td width="15%" class="style1"><INPUT TYPE="text" size="30" name="SUPPLIERSITE" value="<%=SUPPLIERSITE%>" style="border:#FFFFFF;font-family:ARIAL" onKeyDown="return (event.keyCode!=8);" readonly>
				  <td width="10%" class="style2">幣別:</td>
				  <td width="15%" class="style1"><INPUT TYPE="text" size="15" name="CURRENCYCODE" value="<%=CURRENCYCODE%>" style="border:#FFFFFF;font-family:ARIAL" onKeyDown="return (event.keyCode!=8);" readonly></td> 
				</tr>
				<tr>
					<td class="style2" colspan="6" height="20">申請明細：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
						<table width="100%"  bordercolor="#FFFFFF" bordercolorlight="#FFFFFF" bordercolordark='#79C6EE' cellspacing="0" border="1">
							<tr>
								<td class="style4" width="2%"><input type="button" name="upload"  size="20" value="資料匯入" onClick='setUpload("../jsp/subwindow/TSCPMDExcelUpload.jsp")'></td>
								<td class="style4" width="2%">項次</td>
								<td class="style4" width="20%">料號</td>
								<td class="style4" width="17%">品名</td>
								<td class="style4" width="8%">起始訂單量(>)</td>
								<td class="style4" width="8%">結束訂單量(<=)</td>
								<td class="style4" width="4%">數量單位</td>
								<td class="style4" width="6%">單價</td>
								<td class="style4" width="6%">前次單價</td>
								<td class="style4" width="6%">差異比(%)</td>
								<td class="style4" width="16%">異動原因</td>
								<td class="style4" width="3%">歷程</td>
							</tr>
							<%
							String str_color="";
							Statement statexx=con.createStatement();
							ResultSet rsxx=statexx.executeQuery("select a.type_no, a.type_name from oraddman.tspmd_data_type_tbl a where a.data_type='F2_UOM' and a.STATUS_FLAG='A'");
							java.util.Hashtable hashtb = new Hashtable();
							while (rsxx.next())
							{
								hashtb.put(rsxx.getString(1),rsxx.getString(2));
							}
							rsxx.close();       
							statexx.close();
							
							for (int i = 1; i <=Integer.parseInt(LINENUM); i++)
							{ 
								if ((ACTIONCODE.equals("Reject") && !REQUESTNO.equals("")) || ACTIONCODE.equals("EXLUPD"))
								{
									ITEMID=b[i-1][0];
									ITEMNAME=b[i-1][1];
									ITEMDESC=b[i-1][2];
									PRICE=b[i-1][3];
									PREPRICE = b[i-1][4];
									PERCENTAGE =b[i-1][5];
									STARTQTY=b[i-1][6];
									ENDQTY=b[i-1][7];
									REASON=b[i-1][8];
									UOM=b[i-1][9];
									PRICELIST=b[i-1][10];
									QTY_UNIT=b[i-1][11]; //add by Peggy 20121105
									ORGANIZATION_ID=b[i-1][12];  //add by Peggy 20161110
								    PROD_GROUP=b[i-1][13];  //add by Peggy 20161110	
									
									if (PRICE!=null && !PRICE.equals("")) PRICE= (new DecimalFormat("####0.##")).format(Float.parseFloat(PRICE));
								}
								else
								{
									ITEMID=request.getParameter("ITEMID"+i);
									if (ITEMID ==null) ITEMID="";
									ITEMNAME=request.getParameter("ITEMNAME"+i);
									ITEMDESC=request.getParameter("ITEMDESC"+i);
									PRICE=request.getParameter("PRICE"+i);
									PREPRICE = request.getParameter("PREPRICE"+i);
									PERCENTAGE = request.getParameter("PERCENTAGE"+i);
									STARTQTY=request.getParameter("STARTQTY"+i);
									ENDQTY=request.getParameter("ENDQTY"+i);
									REASON=request.getParameter("REASON"+i);
									UOM=request.getParameter("UOM"+i);
									QTY_UNIT=request.getParameter("QTY_UNIT"+i); //add by Peggy 20121105
									ORGANIZATION_ID=request.getParameter("ORGANIZATION_ID"+i);  //add by Peggy 20161110
								    PROD_GROUP=request.getParameter("PROD_GROUP"+i);  //add by Peggy 20161110								
									//PRICELIST=request.getParameter("PRICELIST"+i);
									sql = " SELECT a.start_qty,a.end_qty, a.unit_price"+
										  " FROM oraddman.tspmd_item_quotation a  "+
					                      //" where a.inventory_item_id='"+ITEMID+"' and exists (select 1 from ( select x.vendor_code,x.vendor_site_id,x.inventory_item_id,row_number() over (PARTITION by x.vendor_code,x.vendor_site_id,x.inventory_item_id order by x.creation_date desc) as rowcnt"+
										  " where a.inventory_item_id='"+ITEMID+"' and exists (select 1 from ( select x.vendor_code,x.vendor_site_id,x.inventory_item_id,row_number() over (PARTITION by x.inventory_item_id order by x.creation_date desc) as rowcnt"+
                                          //" from oraddman.tspmd_item_quotation x where x.inventory_item_id='"+ITEMID+"') y where rowcnt =1 and y.VENDOR_SITE_ID=a.VENDOR_SITE_ID and y.vendor_code=a.vendor_code and a.vendor_site_id='"+VENDOR_SITE_ID+"')";
										  " from oraddman.tspmd_item_quotation x where x.inventory_item_id='"+ITEMID+"') y where rowcnt =1 and y.VENDOR_SITE_ID=a.VENDOR_SITE_ID and y.vendor_code=a.vendor_code)";										  
										  //" where a.vendor_code ='"+SUPPLIERNO+"' and a.inventory_item_id='"+ITEMID+"' and a.VENDOR_SITE_ID='"+ VENDOR_SITE_ID+"'";
									//out.println(sql);
									Statement statement2=con.createStatement();
									ResultSet rs2=statement2.executeQuery(sql);
									//PREPRICE="";PERCENTAGE="";
									PRICELIST  ="";
									while (rs2.next())
									{
										//if (Float.parseFloat(STARTQTY) >= Float.parseFloat(rs2.getString("start_qty")) &&  Float.parseFloat(ENDQTY) <= Float.parseFloat(rs2.getString("end_qty")))
										//if (Float.parseFloat(ENDQTY) > Float.parseFloat(rs2.getString("start_qty")) && Float.parseFloat(ENDQTY) <= Float.parseFloat(rs2.getString("end_qty")))
										//{
										//	PREPRICE = rs2.getString("unit_price");
										//	PERCENTAGE =""+(((Float.parseFloat(PRICE) -  Float.parseFloat(rs2.getString("unit_price"))) / Float.parseFloat(rs2.getString("unit_price"))) * 10000 /100);
										//} 
										PRICELIST += (rs2.getString("end_qty")+"="+  (new DecimalFormat("####0.###")).format(Float.parseFloat(rs2.getString("unit_price")))+",");
									}
									rs2.close();
									statement2.close();
								}					
								if (ITEMID==null) ITEMID="";
								if (ITEMNAME==null) ITEMNAME="";
								if (ITEMDESC==null) ITEMDESC="";
								if (PRICE ==null) PRICE="";
								if (PREPRICE==null || PREPRICE.equals("")) PREPRICE ="0";
								if (PERCENTAGE==null || PERCENTAGE.equals("")) PERCENTAGE ="0";
								if (STARTQTY==null) STARTQTY="";
								if (ENDQTY==null) ENDQTY= "";
								if (REASON==null) REASON="";
								if (UOM==null) UOM="";
								if (PRICELIST==null) PRICELIST="";
								//if (QTY_UNIT==null) QTY_UNIT="500";  //add by Peggy 20121105
								if (QTY_UNIT==null) QTY_UNIT="0";  //add by Peggy 20131209
								if (ORGANIZATION_ID==null) ORGANIZATION_ID="";  //add by Peggy 20161110
								if (PROD_GROUP==null) PROD_GROUP="";//add by Peggy 20161110
							%>
							<tr>
								<td class="style1"><input type="button" size="5" name="<%="DEL"+i%>" style="font-family:Arial" value="刪除" onClick="setDelete(<%=i%>)"></td>
								<td class="style1"><input type="text" size="3" name="<%="SEQ"+i%>" style="border:#FFFFFF;font-family:Arial" value="<%=i%>" onKeyDown="return (event.keyCode!=8);" readonly></td>
								<td class="style1"><input type="hidden" name="<%="ITEMID"+i%>" style="font-family:Arial" value="<%=ITEMID%>" ><input type="hidden" name="<%="ORGANIZATION_ID"+i%>" style="font-family:Arial" value="<%=ORGANIZATION_ID%>"><input type="hidden" name="<%="PROD_GROUP"+i%>" style="font-family:Arial" value="<%=PROD_GROUP%>">
								<input type="text" name="<%="ITEMNAME"+i%>" size="28" style="font-family:Arial" value="<%=ITEMNAME%>">
								<input type="button" name="<%="btnItem"+i%>" value=".." style="font-family:Arial" onClick="subWindowItemFind(1,<%=i%>)">								</td>
								<td class="style1"><input type="text" name="<%="ITEMDESC"+i%>" size="22" style="font-family:Arial" value="<%=ITEMDESC%>">
								<input type="button" name="<%="btnDesc"+i%>" value=".." style="font-family:Arial" onClick="subWindowItemFind(2,<%=i%>)">								</td>
								<td class="style5"><input type="hidden" name="<%="QTY_UNIT"+i%>" value="<%=QTY_UNIT%>"><input type="text" name="<%="STARTQTY"+i%>" size="8" style="font-family:Arial;text-align=right" value="<%=STARTQTY%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" onChange="checkQty(<%=i%>,<%="'"+"STARTQTY"+"'"%>)"></td>
								<td class="style5"><input type="text" name="<%="ENDQTY"+i%>" size="8" style="font-family:Arial;text-align=right" value="<%=ENDQTY%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" onChange="checkQty(<%=i%>,<%="'"+"ENDQTY"+"'"%>)"></td>
								<td class="style5">
								<%
									out.println("<select NAME='"+"UOM"+i+"' style='font-size:12px'>");
									out.println("<OPTION VALUE=-->--");
			 						Enumeration e = hashtb.keys();
         							while(e.hasMoreElements())
             						{ 
             							String key = (String)(e.nextElement());
             							String value = (String)hashtb.get(key);

        								if (value.equals(UOM))
        								{
          									out.println("<OPTION VALUE='"+key+"' SELECTED>"+value);
        								} 
										else 
										{
          									out.println("<OPTION VALUE='"+key+"'>"+value);
        								}
									}
									out.println("</select>");
								%>								</td>
								<td class="style5"><input type="text" name="<%="PRICE"+i%>" size="7" style="font-family:Arial;text-align=right"  value="<%=PRICE%>" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)" onChange="compute(<%=i%>)"></td>
								<td class="style1"><input type="text" name="<%="PREPRICE"+i%>" size="7" style="font-family:Arial;text-align=right" value="<%=(new DecimalFormat("####0.###")).format(Float.parseFloat(PREPRICE))%>" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)" onChange="compute(<%=i%>)"><INPUT TYPE="hidden" NAME="<%="PRICELIST"+i%>" value="<%=PRICELIST%>"></td>
							<%
								if (Float.parseFloat(PERCENTAGE) <0)
								{
									str_color = "#0000FF";
								}
								else if (Float.parseFloat(PERCENTAGE) >0)
								{
									str_color = "#FF0000";
								}
								else
								{
									str_color = "#000000";
								}
							%>
								<td class="style1"><input type="text" name="<%="PERCENTAGE"+i%>" size="5" style="font-weight:bold;color:<%=str_color%>;border:#FFFFFF;font-family:Arial;text-align=right" value="<%=(new DecimalFormat("####0.###")).format(Float.parseFloat(PERCENTAGE))%>"  onkeydown="return (event.keyCode!=8);" readonly></td>
								<td class="style1"><input type="text" name="<%="REASON"+i%>" size="25" style="font-family:Arial" value="<%=REASON%>"></td>
								<td class="style5"><IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick="subWindowHistory(<%=i%>)"></td>
							</tr>
							<%
							}
							%>
							<TR>
								<TD class="style6" colspan="12">
								  <input type="text" name="txtLine"  size="5" value="<%=ADDLINE%>" style="font-family:arial;text-align:right">
								  <input type="button" name="addline"  size="20" value="AddLine" style="font-family:arial" onClick='setAddLine("../jsp/TSCPMDQuotationCreate.jsp")'>							  </td>
							</TR>
					  </table>
					</td>
				</tr>
				<TR>
					<td width="10%" class="style2"><input type="hidden" name="FILEID" value="<%=FILEID%>"><input type="button" name="upload"  size="20" value="上傳附件" onClick='setAttache("../jsp/subwindow/TSCPMDAttachmentUpload.jsp?FILEID=<%=FILEID%>")'></td>
					<td colspan="5">
					<%
					//取得附件
					if (!FILEID.equals(""))
					{
						String rootName = "/jsp/PMD_Attache/"+FILEID;
						if (ACTIONCODE.equals("DELATTACHE") && !FILENAME.equals(""))
						{
							String delPath = application.getRealPath(rootName+"/"+FILENAME);
							File file = new File(delPath);   
							if (file.exists()) 
							{  
								boolean deleted = file.delete();  
							}
						}
						
						String rootPath = application.getRealPath(rootName);
						File fp = new File(rootPath);
						if (fp.exists()) 
						{
							String[] list = fp.list();
							if (list.length > 0)
							{
								for(int i=0; i<list.length;i++)
								{
									File inFp = new File(rootPath + File.separator + list[i]);
									out.println("&nbsp;<img src='images/pdf.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+list[i]+"' target='_blank'>"+list[i]+"</a> ("+new Long(inFp.length()) +" bytes) "+new Timestamp(new Long(inFp.lastModified()).longValue())+"</font>&nbsp;&nbsp;&nbsp;<img style='vertical-align:text-bottom' src='images/deleteicon_disabled.gif' border='0' onClick='delAttache("+'"'+"../jsp/TSCPMDQuotationCreate.jsp?ACTIONCODE=DELATTACHE&FILENAME="+ list[i]+'"'+")'><br>");
								}
							}
							else
							{
								out.println("&nbsp;<br>&nbsp;");
							}
						}
					}
					else
					{
						out.println("&nbsp;<br>&nbsp;");
					}
					%>
					</td>
				</TR>
				<tr>
					<td width="10%" class="style2">備註說明:</td>
					<td colspan="5"><textarea cols="190" rows="4"  name="REMARKS" style="font-family:ARIAL"><%=REMARKS%></textarea></td>
				</tr>
				<TR>
					<td class="style2"><strong><jsp:getProperty name="rPH" property="pgAction"/></strong></td>
					<td class="style1">
					<%
					try
					{    
						sql = "SELECT a.type_no, a.type_name  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE='F2-001'  AND a.status_flag='A'";
						if (REQUESTNO.equals("")) sql += " and TYPE_NO <>'001'";
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
					<input type="button" name="btnSubmit" style="font-family:arial" value="Submit" onClick="setSubmit();"></td>
					<td class="style2">申請日期:</td>
					<TD class="style1"><input type="text" name="CREATEDATE" value="<%=CREATEDATE%>" style="border:#FFFFFF;font-family:ARIAL" onKeyDown="return (event.keyCode!=8);" readonly></TD>
					<td class="style2">申請人:</td>
					<TD class="style1"><input type="hidden" name="CREATORID" value="<%=CREATORID%>" style="font-family:ARIAL"><input type="text" name="CREATOR" value="<%=CREATOR%>" style="border:#FFFFFF;font-family:ARIAL" onKeyDown="return (event.keyCode!=8);" readonly></TD>
				</TR>
			</table>
		</td>
	</tr>
	<%
		sql = " SELECT  a.action_name,c.type_name action_desc, to_char(a.action_date,'yyyy-mm-dd hh24:mi:ss')  action_date,a.actor, a.remark "+
		      " FROM oraddman.tspmd_action_history a"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE ='F2_ACTION') b"+
		      " ,(select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL  where DATA_TYPE like 'F2-%') c"+
		      " where a.request_no ='" + REQUESTNO+"' and a.ACTION_NAME = b.type_name and b.type_no = c.type_no order by a.action_date";
		Statement statementa=con.createStatement();
		ResultSet rsa=statementa.executeQuery(sql);
		int cnt =0;
		while (rsa.next())
		{
			if (cnt ==0)
			{
				out.println("<tr><td>&nbsp;</td></tr>");
				out.println("<tr><td>");
				out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0'  bordercolorlight='#FFFFFF'  bordercolordark='#79C6EE'>");
				out.println("<tr>");
				out.println("<td height='20' colspan='8' class='style2'>申請歷程：</td>");
				out.println("</tr>");
				out.println("<tr height='20'>");
				out.println("<td class='style4' width='5%'>序號</td>");
				out.println("<td class='style4' width='20%'>交易名稱</td>");
				out.println("<td class='style4' width='20%'>交易日期</td>");
				out.println("<td class='style4' width='20%'>交易人員</td>");
				out.println("<td class='style4' width='35%'>備註說明</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td class='style5'>"+(cnt+1)+"</td>");
			out.println("<td class='style5'>"+rsa.getString("action_desc")+"</td>");
			out.println("<td class='style5'>"+rsa.getString("action_date")+"</td>");
			out.println("<td class='style5'>"+rsa.getString("actor")+"</td>");
			out.println("<td class='style3'>"+((rsa.getString("remark")==null || rsa.getString("remark").equals(""))?"&nbsp;":rsa.getString("remark"))+"</td>");
			out.println("</tr>");
			cnt ++;
		}
		if (cnt >0)
		{
			out.println("</table></td></tr>");
		}
		rsa.close();
		statementa.close();

	%>
</table>
<input type="hidden" name="LINENUM" value="<%=LINENUM%>">
<input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>">
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<input type="hidden" name="NEXTWKFLOW" value="<%=NEXTWKFLOW%>">
<input type="hidden" name="THISWKFLOW" value="<%=THISWKFLOW%>">
<input type="hidden" name="PROD_GROUP" value="<%=PROD_GROUP%>">
<input type="hidden" name="ORGANIZATION_ID" value="<%=ORGANIZATION_ID%>">
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
<%
}
catch(Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>
