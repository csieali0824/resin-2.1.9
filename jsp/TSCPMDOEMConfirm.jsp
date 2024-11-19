<!-- 20161110 Peggy,新增PRD外包-->
<!-- 20170817 Peggy,預計完工日移至表頭,取消line request date,新增暫不發料選項-->
<!-- 20171012 Peggy,新增RD3工程入庫交易-->
<!-- 20180724 Peggy,新增晶片片號FOR 4056天水華天-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
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
<title>委外加工單-核淮</title>
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
			if (document.MYFORM.LINENUM.value==1 || document.MYFORM.LINENUM.value==i)
			{
				document.MYFORM.elements["Stock"+i].value = "";
				document.MYFORM.elements["INVITEM"+i].value = "";
				document.MYFORM.elements["INVITEMID"+i].value = "";
				document.MYFORM.elements["WaferLot"+i].value = "";
				document.MYFORM.elements["WaferNumber"+i].value = "";
				document.MYFORM.elements["ChipQty"+i].value = "";
				document.MYFORM.elements["WaferQty"+i].value = "";
				document.MYFORM.elements["DateCode"+i].value = "";
				//document.MYFORM.elements["RequestSD"+i].value = "";
				document.MYFORM.elements["LotOnhand"+i].value = "";
			}
			else
			{
				document.MYFORM.elements["Stock"+i].value = document.MYFORM.elements["Stock"+(i+1)].value;
				document.MYFORM.elements["INVITEM"+i].value = document.MYFORM.elements["INVITEM"+(i+1)].value;
				document.MYFORM.elements["INVITEMID"+i].value = document.MYFORM.elements["INVITEMID"+(i+1)].value;
				document.MYFORM.elements["WaferLot"+i].value = document.MYFORM.elements["WaferLot"+(i+1)].value;
				document.MYFORM.elements["WaferNumber"+i].value = document.MYFORM.elements["WaferNumber"+(i+1)].value;
				document.MYFORM.elements["ChipQty"+i].value = document.MYFORM.elements["ChipQty"+(i+1)].value;
				document.MYFORM.elements["WaferQty"+i].value = document.MYFORM.elements["WaferQty"+(i+1)].value;
				document.MYFORM.elements["DateCode"+i].value = document.MYFORM.elements["DateCode"+(i+1)].value;
				//document.MYFORM.elements["RequestSD"+i].value = document.MYFORM.elements["RequestSD"+(i+1)].value;
				document.MYFORM.elements["LotOnhand"+i].value = document.MYFORM.elements["LotOnhand"+(i+1)].value;
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
function setSubmit()
{
	var ACTIONID = document.MYFORM.ACTIONID.value;
	if (ACTIONID == "--" || ACTIONID == null || ACTIONID == "" || ACTIONID=="null")
	{
		alert("請選擇執行動作!");
		document.MYFORM.ACTIONID.focus();
		return false;
	}
	
	if (ACTIONID =="004" && (document.MYFORM.approvemark.value==null || document.MYFORM.approvemark.value =="" || document.MYFORM.approvemark.value=="null"))
	{
		alert("請輸入退件原因!");
		document.MYFORM.approvemark.focus();
		return false;
	}
	
	if (ACTIONID =="003")
	{	
		var WIPNO = document.MYFORM.WIPNO.value;
		var STATUSTYPE = document.MYFORM.STATUSTYPE.value;
		var WIPENTITYID = document.MYFORM.WIPENTITYID.value;
		if (ACTIONID !="004" && WIPENTITYID!="0" && STATUSTYPE!="3")
		{
			alert("工單號:"+WIPNO+"狀態為Completed，不允許修改!");
			return false;
		}
		var ITEMID = document.MYFORM.ITEMID.value;
		var DIEID = document.MYFORM.DIEID.value;
		var DIE = DIEID.split(",");
		var WIPTYPE = document.MYFORM.WIPTYPE.value;
		var LINENUM = document.MYFORM.LINENUM.value;
		var ISSUEDATE = document.MYFORM.ISSUEDATE.value;
		var rec_cnt =0;
		var num1=0, num11=0,num2=0,num21=0;
		for (var i = 1 ; i <= LINENUM ; i ++)
		{
			var invitem = document.MYFORM.elements["INVITEM"+i].value;
			var invitemid = document.MYFORM.elements["INVITEMID"+i].value;
			var Stock = document.MYFORM.elements["Stock"+i].value;
			var WaferLot = document.MYFORM.elements["WaferLot"+i].value;
			var WaferNumber = document.MYFORM.elements["WaferNumber"+i].value;
			var WaferQty = document.MYFORM.elements["WaferQty"+i].value;
			var ChipQty = document.MYFORM.elements["ChipQty"+i].value;
			var DateCode = document.MYFORM.elements["DateCode"+i].value;
			//var RequestSD = document.MYFORM.elements["RequestSD"+i].value;
			var LotOnhand = document.MYFORM.elements["LotOnhand"+i].value;
			if ((WaferLot != null && WaferLot != "") || ( WIPTYPE !="03" && WIPTYPE !="05" && invitem !=null && invitem != "" && invitemid !=null && invitemid != "" && WaferQty != null && WaferQty != "" && DateCode!=null && DateCode !="" && ChipQty != null && ChipQty != "") || ((WIPTYPE =="03" || WIPTYPE =="05")  && invitem !=null && invitem != "" && invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != "")  || ( document.MYFORM.WIP_ISSUE_FLAG.checked && invitem !=null && invitem != "" &&  invitemid !=null && invitemid != "" && ChipQty != null && ChipQty != ""))
			{
				for (var j = i ; j <= LINENUM ; j++)
				{
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
				}
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && (Stock ==null || Stock ==""))
				{
					alert("請選擇發料倉!"); 
					document.MYFORM.elements["WaferLot"+i].focus();
					return false;
				}
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && WIPTYPE !="03" && WIPTYPE !="05")
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
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && WIPTYPE !="03" && WIPTYPE !="05" && ("0"+WaferQty).match(regex)==null) 
				{ 
					alert("Wafer Qty必須是數值型態!"); 
					document.MYFORM.elements["WaferQty"+i].focus();
					return false;
				} 
				if (("0"+ChipQty).match(regex)==null) 
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
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && document.MYFORM.elements["misc_flag"+i].value !="Y" && parseFloat(ChipQty) > parseFloat(LotOnhand))
				{ 
					alert("Chip Qty("+ChipQty+")不可大於目前庫存量("+LotOnhand+")!"); 
					document.MYFORM.elements["ChipQty"+i].focus();
					return false;
				}
				if (!document.MYFORM.WIP_ISSUE_FLAG.checked && WIPTYPE !="03" && WIPTYPE !="05" && (DateCode==null || DateCode=="")) 
				{ 
					alert("Date Code不可空白!"); 
					document.MYFORM.elements["DateCode"+i].focus();
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
		}
		for (var i = 1 ; i <= LINENUM ; i ++)
		{	
			if (WIPTYPE =="03" || WIPTYPE =="05")
			{
				document.MYFORM.elements["btnInvItem"+i].disabled=true;
			}
			document.MYFORM.elements["btnLot"+i].disabled=true;
		}

		//if (confirm("您確定要核淮此申請單嗎?"))
		//{
			document.MYFORM.Submit1.disabled=true;	
			document.getElementById("alpha").style.width="100"+"%";
			document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
			document.getElementById("showimage").style.visibility = '';
			document.getElementById("blockDiv").style.display = '';
			document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?PROGRAMNAME=F1-002&REQUESTNO="+document.MYFORM.REQUESTNO.value+"";
			document.MYFORM.submit();
		//}
	}
	else
	{
		document.MYFORM.Submit1.disabled=true;	
		document.getElementById("alpha").style.width="100"+"%";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?PROGRAMNAME=F1-002&REQUESTNO="+document.MYFORM.REQUESTNO.value+"";
		document.MYFORM.submit();
	}
}
function subWindowInvItemFind(chooseLine)
{
	var itemName = document.MYFORM.elements["INVITEM"+chooseLine].value;
	subWin=window.open("../jsp/subwindow/TSCPMDItemInfoFind.jsp?ITEMNAME="+itemName+"&LINENO="+chooseLine,"subwin","width=740,height=480,scrollbars=yes,menubar=no");
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
	var itemID = "";
	if (wiptype =="03" || wiptype =="05") //重工
	{
		itemID =document.MYFORM.elements["INVITEMID"+chooseLine].value;
	}
	else
	{
		itemID = document.MYFORM.DIEID.value;
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
	subWin=window.open("../jsp/subwindow/TSCPMDItemLotInfoFind.jsp?LINENO="+chooseLine+"&ITEMID="+itemID,"subwin","width=500,height=500,scrollbars=yes,menubar=no");
}

function subAction()
{
	if (document.MYFORM.ACTIONID.value=="004")
	{
		document.MYFORM.approvemark.value="";
		document.MYFORM.reason.style.visibility="visible";
		document.MYFORM.approvemark.style.visibility="visible";
	}
	else
	{
		document.MYFORM.approvemark.value="";
		document.MYFORM.reason.style.visibility="hidden";
		document.MYFORM.approvemark.style.visibility="hidden";
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
			num1 = Qty.toString().split(".")[1].length;
		} 
		catch (e) { num1 = 0;}
        try 
		{
			num2 = totQty.toString().split(".")[1].length ;
		} catch (e) { num2 = 0; }
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

</script>
<STYLE TYPE='text/css'> 
 .style3   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:center}
 .style4   {
	font-family:細明體;
	font-size:12px;
	background-color:#D8DEA9;
	text-align:center;
color=#EE6633;
color: #663300;
}
 .style1   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:left}
 .style2   {
	font-family:細明體;
	font-size:12px;
	background-color:#D8DEA9;
	text-align:left;
color=#EE6633D;
	color: #660000;
}
 .style5   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:right}
  .style6   {
	font-family:細明體;
	font-size:12px;
	background-color:#D8DEA9;
	text-align:right;
color=#EE6633;
color: #663300;
}
 </STYLE>
</head>
<body>
<%
String REQUESTNO = request.getParameter("REQUESTNO");
String LINENUM = request.getParameter("LINENUM");
if (LINENUM==null) LINENUM="0";
String AddLine = request.getParameter("txtLine");
if (AddLine==null) AddLine="0";
LINENUM = "" + (Integer.parseInt(LINENUM)+Integer.parseInt(AddLine));
String APPROVEMARK = request.getParameter("approvemark");
if ( APPROVEMARK ==null)  APPROVEMARK="";
String totWaferQty=request.getParameter("totWaferQty");
if (totWaferQty==null) totWaferQty="";
String totChipQty=request.getParameter("totChipQty");
if (totChipQty==null) totChipQty="";
String PROD_GROUP=request.getParameter("PROD_GROUP");
if (PROD_GROUP==null) PROD_GROUP=""; //add by Peggy 20161107
String WIP_ISSUE_FLAG=request.getParameter("WIP_ISSUE_FLAG");
if (WIP_ISSUE_FLAG==null) WIP_ISSUE_FLAG=""; //add by Peggy 20170817
String REQLIST=request.getParameter("REQLIST");
if (REQLIST==null) REQLIST=""; //add by Peggy 20220809
String WIPTYPE="",WaferLot="",ChipQty="",WaferQty="",DateCode="",RequestSD="",Remarks="",LotOnhand="",Stock="",INVITEMID="",INVITEM="",misc_flag="",WaferNumber="";
String ORIG_REQUESTNO="",ORIG_VERSIONID="",ORIG_QTY="",ORIG_UNITPRICE="",ORIG_PACKAGE_SPEC="",ORIG_TEST_SPEC="",ORIG_ASSEMBLY="",ORIG_TESTING="",ORIG_TAPING_REEL="",ORIG_LAPPING="",ORIG_OTHERS="",ORIG_REMARKS="",ORIG_MARKING="",DC_YYWW="",ORIG_DC_YYWW="",DIE_MODE="",ORIG_DIE_MODE="";
String ORIG_ITEM_NAME = "",	ORIG_STOCK="",ORIG_WAFER_LOT="",  ORIG_CHIP_QTY="",	ORIG_WAFER_QTY="",ORIG_DATE_CODE="",ORIG_REQ_DATE="",ORIG_WAFER_NUMBER="",ORIG_FSM="",ORIG_RINGCUT="",ORIG_SUBINVENTORY="";
try
{

	String sql = " SELECT A.* FROM (SELECT a.request_no, a.version_id,a.wip_type_no,b.TYPE_NAME wip_type_name, a.vendor_code, a.vendor_name,a.vendor_site_id,"+
				 " a.vendor_contact, a.request_date, a.inventory_item_id,"+
				 " a.inventory_item_name, a.item_description, a.item_package,"+
				 " a.die_item_id || decode(a.die_item_id1,null,'',','||a.die_item_id1) die_item_id, a.die_name || decode(a.die_name1,null,'','<br>'||a.die_name1) die_name, a.quantity, a.unit_price, a.packing,"+
				 " a.package_spec, a.test_spec, a.assembly, a.testing,"+
				 " a.taping_reel, a.lapping, a.others, a.remarks, a.marking,"+
				 " a.created_by_name,to_char(a.CREATION_DATE,'yyyy-mm-dd') CREATION_DATE ,a.SUBINVENTORY_CODE,a.currency_code,a.orig_version_id"+
				 " ,nvl(c.status_type,0) status_type,NVL(a.wip_entity_id,0) wip_entity_id,a.wip_no,a.unit_price_uom,a.die_qty"+
				 ",a.request_no ||'-'||a.orig_version_id orig_requestno"+
				 ",a.tsc_prod_group"+ //add by Peggy 20161110
				 ",to_char(a.completion_date,'yyyymmdd') completion_date,a.wip_issue_pending_flag"+ //add by Peggy 20170817
				 ",row_number() over (order by a.request_no||'-'||a.version_id) seq_no"+ //add by Peggy 20230214
				 ",a.front_side_metal fsm, a.ring_cut ringcut"+ //add by Peggy 20230426
				 ",(SELECT x.remark  FROM oraddman.tspmd_action_history x  where x.request_no||'-'||x.version_id=a.request_no||'-'||a.version_id and action_name='Submit') change_reason"+ //add by Peggy 20240529 
				 " FROM oraddman.tspmd_oem_headers_all a,oraddman.TSPMD_DATA_TYPE_TBL b,wip.wip_discrete_jobs c "+
				 " WHERE a.status='Submit' "+
				 " and a.wip_type_no=b.TYPE_NO "+
				 " and b.DATA_TYPE='WIP'"+
				 " and a.wip_entity_id =c.wip_entity_id(+)";
	if (!REQLIST.equals(""))
	{
		sql += " and ',"+REQLIST+",' like '%,'||a.request_no||'-'||a.version_id||',%') A"+
		        " WHERE SEQ_NO=1";
	}
	else
	{
		sql += " and a.request_no||'-'||a.version_id='"+REQUESTNO+"') A ";
	}
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		REQUESTNO=rs.getString("request_no")+"-"+rs.getString("version_id");
		WIPTYPE=rs.getString("wip_type_no");
		ORIG_VERSIONID=rs.getString("orig_version_id");
		ORIG_REQUESTNO=rs.getString("orig_requestno");
		
		if (rs.getString("version_id").equals("0"))
		{
				ORIG_QTY=rs.getString("quantity");
				ORIG_UNITPRICE=rs.getString("unit_price");
				ORIG_PACKAGE_SPEC=rs.getString("package_spec");
				ORIG_TEST_SPEC=rs.getString("test_spec");
				ORIG_ASSEMBLY=rs.getString("assembly");
				ORIG_TESTING=rs.getString("testing");
				ORIG_TAPING_REEL=rs.getString("taping_reel");
				ORIG_LAPPING=rs.getString("lapping");
				ORIG_OTHERS=rs.getString("others");
				if (ORIG_OTHERS==null) ORIG_OTHERS="";
				ORIG_REMARKS=rs.getString("remarks");
				if (ORIG_REMARKS==null) ORIG_REMARKS="";
				ORIG_MARKING=rs.getString("marking");
				if (ORIG_MARKING==null) ORIG_MARKING="";
				ORIG_FSM=rs.getString("FSM");
				ORIG_RINGCUT=rs.getString("RINGCUT");
				ORIG_SUBINVENTORY=rs.getString("SUBINVENTORY_CODE"); //add by Peggy 20240530
				
		}
		else
		{
			sql =" SELECT quantity, unit_price, package_spec, test_spec, assembly, testing,taping_reel, lapping, others, remarks, marking,front_side_metal fsm, ring_cut ringcut,SUBINVENTORY_CODE"+
				 " FROM oraddman.tspmd_oem_headers_all a  WHERE request_no||'-'||version_id='"+ORIG_REQUESTNO+"'";
			Statement statement2=con.createStatement();
			ResultSet rs2=statement2.executeQuery(sql);
			if (rs2.next())
			{
				ORIG_QTY=rs2.getString("quantity");
				ORIG_UNITPRICE=rs2.getString("unit_price");
				ORIG_PACKAGE_SPEC=rs2.getString("package_spec");
				ORIG_TEST_SPEC=rs2.getString("test_spec");
				ORIG_ASSEMBLY=rs2.getString("assembly");
				ORIG_TESTING=rs2.getString("testing");
				ORIG_TAPING_REEL=rs2.getString("taping_reel");
				ORIG_LAPPING=rs2.getString("lapping");
				ORIG_OTHERS=rs2.getString("others");
				if (ORIG_OTHERS==null) ORIG_OTHERS="";
				ORIG_REMARKS=rs2.getString("remarks");
				if (ORIG_REMARKS==null) ORIG_REMARKS="";
				ORIG_MARKING=rs2.getString("marking");
				if (ORIG_MARKING==null) ORIG_MARKING="";
				ORIG_FSM=rs2.getString("FSM");
				ORIG_RINGCUT=rs2.getString("RINGCUT");
				ORIG_SUBINVENTORY=rs2.getString("SUBINVENTORY_CODE"); //add by Peggy 20240530				
			}
			rs2.close();
			statement2.close();
		}
%>
<form name="MYFORM"  METHOD="post" >
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
 <font color="#000000" size="+2" face="標楷體"> <strong><%=PROD_GROUP%>委外加工單<%if(ORIG_VERSIONID!=null) out.println("(變更)-核淮"); else out.println("-核淮");%></strong></font>
<br>
<A HREF="../jsp/TSCPMDOEMConfirmQuery.jsp"><font style="font-size:14px;font-family:'細明體'">回待核淮查詢畫面</font></A>&nbsp;&nbsp;&nbsp;
<table width="100%" border="1" align="left" cellpadding="1" cellspacing="0"  bordercolorlight="#FFFFFF"  bordercolordark="#336666" bordercolor="#CCCCCC">
	<tr>
		<td width="100%" height="21" colspan="12" class="style2">訂單資訊：</td>
	</tr>
	<tr>
		<td class="style2" width="7%" height="30" ><font class="style2" style="font-family:'細明體'; color: #663300;">申請單號:</font></td>
		<td class="style1" width="25%"><font style="font-size:16px;color:#0000FF;font-family:arial"><%=rs.getString("request_no")%></font><input type="hidden" name="REQUESTNO" value="<%=rs.getString("request_no")%>"><input type="checkbox" name="WIP_ISSUE_FLAG" value="Y"  <%=rs.getString("wip_issue_pending_flag").equals("Y")?" checked ":" style='visibility:hidden'"%> disabled><span id='span1' style='background-color:#FFFF33'><%=rs.getString("wip_issue_pending_flag").equals("Y")?"預開工單及採購單,暫不發料":""%></span><input type="hidden" name="WIPENTITYID" value="<%=rs.getString("wip_entity_id")%>"><input type="hidden" name="STATUSTYPE" value="<%=rs.getString("status_type")%>"><input type="hidden" name="WIPNO" value="<%=rs.getString("WIP_NO")%>"></td>
		<td class="style2" width="5%" ><font class="style2" style="font-family:'細明體'; color: #663300;">版次:</font></td>
		<td class="style1" width="5%"><font style="font-size:16px;color:#0000FF;font-family:arial"><%=rs.getString("version_id")%></font><input type="hidden" name="VERSIONID" value="<%=rs.getString("version_id")%>"></td>
		<td class="style2" width="7%"><font style="font-family:'細明體'; color: #663300;">工單類型:</font></td>
		<td class="style1" width="7%"><font style="font-family:arial;font-size:12px;"><%=rs.getString("wip_type_name")%><input type="hidden" name="WIPTYPE" value="<%=WIPTYPE%>"></font></td>
		<td class="style2" width="7%"><font style="font-family:ARIAL; color: #663300;">Issue Date:</font></td>
		<td class="style1" width="8%"><font style="font-family:arial;font-size:12px;"><%=rs.getString("request_date")%><input type="hidden" name="ISSUEDATE" value="<%=rs.getString("request_date")%>"></font></td>
		<td class="style2" width="7%" style="font-family:'細明體'; color: #663300;">開單人:</td>
	    <td class="style1" width="8%" ><font style="font-family:arial;font-size:12px;"><%=rs.getString("created_by_name")%></font></td>
		<td class="style2" width="7%" style="font-family:'細明體'; color: #663300;">預計完工日:</td>
	    <td class="style1" width="7%" ><font style="font-family:arial;font-size:12px;"><%=rs.getString("COMPLETION_DATE")%></font></td>
	</tr>
	<tr>
		<td class="style2" height="30" >廠商名稱:</td>
		<td class="style1" colspan="5"><font style="font-family:arial;font-size:12px;"><%="("+rs.getString("vendor_code")+")"+rs.getString("vendor_name")%></font><INPUT TYPE="hidden" name="SUPPLIERNO" value="<%=rs.getString("vendor_code")%>"><INPUT TYPE="hidden" name="VENDOR_SITE_ID" value="<%=rs.getString("vendor_site_id")%>"></td> 	
		<td class="style2">聯絡人:</td>
		<td class="style1"><font style="font-family:arial;font-size:12px;"><%=rs.getString("vendor_contact")%></font></td> 
		<td class="style2" style="font-family:'細明體'; color: #663300;">幣別:</td>
	    <td class="style1"><font style="font-family:arial;font-size:12px;"><%if (rs.getString("CURRENCY_CODE")==null) out.println("&nbsp;"); else out.println(rs.getString("CURRENCY_CODE"));%></font></td>
		<td class="style2" style="font-family:'細明體'; color: #663300;">完工入庫倉:</td>
	    <td class="style1"><font style="font-family:arial;font-size:12px;<% if (!rs.getString("SUBINVENTORY_CODE").equals(ORIG_SUBINVENTORY)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><% if (rs.getString("SUBINVENTORY_CODE")==null) out.println("&nbsp;"); else out.println(rs.getString("SUBINVENTORY_CODE"));%></font></td>
	</tr>
	<TR>
		<td colspan="12">
			<table width="100%">
				<tr>			
		    	  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKASSEMBLY" <% if (rs.getString("assembly").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px; <%if (!rs.getString("assembly").equals(ORIG_ASSEMBLY)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">封裝 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("assembly").equals(ORIG_ASSEMBLY)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">Assembly</font></TD>
			  	  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKTESTING" <% if (rs.getString("testing").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px; <%if (!rs.getString("testing").equals(ORIG_TESTING)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">測試 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("testing").equals(ORIG_TESTING)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">Testing</font></TD>
				  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKTAPING"  <% if (rs.getString("taping_reel").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family細明體; font-size:12px;<%if (!rs.getString("taping_reel").equals(ORIG_TAPING_REEL)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">編帶 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("taping_reel").equals(ORIG_TAPING_REEL)) out.println("color:#ff0000;"); else out.println("color: #00000;");%>">T＆R</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKLAPPING" <% if (rs.getString("lapping").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px;<%if (!rs.getString("lapping").equals(ORIG_LAPPING)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">減薄 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("lapping").equals(ORIG_LAPPING)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">Lapping</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="FSM" <% if (rs.getString("FSM").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px;<%if (!rs.getString("FSM").equals(ORIG_FSM)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">正面金屬濺鍍沈積 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("FSM").equals(ORIG_FSM)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">FSM</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="RINGCUT" <% if (rs.getString("RINGCUT").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px;<%if (!rs.getString("RINGCUT").equals(ORIG_RINGCUT)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">環切 </font><font style="font-family:Arial; font-size:12px; <%if (!rs.getString("RINGCUT").equals(ORIG_RINGCUT)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">Ring Cut</font></TD>
					<TD class="style1" width="30%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKOTHERS"  <% if (rs.getString("others")!=null) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:細明體; font-size:12px; <%if (rs.getString("others")!=null && !rs.getString("others").equals(ORIG_OTHERS)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>">其他&nbsp;&nbsp;</font>
					  <input type="text" name="OTHERS" size="45" style="border-bottom-style:double;border-left:none;border-right:none;border-top:none;font-family:Arial;<%if (rs.getString("others")!=null && !rs.getString("others").equals(ORIG_OTHERS)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>" <%if (rs.getString("others")==null) out.println("value=''"); else out.println("value='"+rs.getString("others")+"'");%> readonly></td>
				</tr>
		  </table>
	  </td>
	</TR>
	<tr>
		<td colspan="12">
			<table width="100%" bordercolorlight="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolordark="#336666" bordercolor="#cccccc">
				<tr>
				  	<td width="8%" height="42" class="style4"><font style="font-family:Arial">TSC Prod Group</font></td>
				  	<td width="17%" height="42" class="style4">料號<br>
				  <font style="font-family:Arial">Item No</font></td>
					<td class="style4" width="13%">品名<br><font style="font-family:Arial">Device Name</font></td>
					<td class="style4" width="8%">封裝型式<br><font style="font-family:Arial">Package</font></td>
					<td class="style4" width="9%">芯片名稱<br><font style="font-family:Arial">Die Name</font></td>
					<td class="style4" width="7%">數量<br><font style="font-family:Arial"><%if (!rs.getString("unit_price_uom").equals("片")) out.println("Q'ty(KPC)"); else out.println("Q'ty("+rs.getString("unit_price_uom")+")");%></font></td>
					<td class="style4" width="7%">單價<font face="ARIAL">U/P</font><br><font style="font-family:Arial"><%=rs.getString("currency_code")+"/"+rs.getString("unit_price_uom")%></font></td>
					<td class="style4" width="9%">包裝<br><font style="font-family:Arial">Packing</font></td>
					<td class="style4" width="13%">封裝規格<br><font style="font-family:Arial">D/B No.</font></td>
					<td class="style4" width="13%">測試規格<br><font style="font-family:Arial">Test Spec</font></td>
				</tr>
				<tr>
					<td height="46" class="style3"><font style="font-family:arial"><%=rs.getString("tsc_prod_group")%></font></td>
					<td height="46" class="style3"><font style="font-family:arial"><input type="hidden" name="ITEMID" style="font-family:Arial" value="<%=rs.getString("inventory_item_id")%>"><input type="hidden" name="ITEMNAME" value="<%=rs.getString("inventory_item_name")%>"><%=rs.getString("inventory_item_name")%></font></td>
					<td class="style3"><font style="font-family:arial"><input type="hidden" name="ITEMDESC" value="<%=rs.getString("item_description")%>"><%=rs.getString("item_description")%></font></td>
					<td class="style3"><font style="font-family:arial"><% if (rs.getString("item_package")==null) out.println("&nbsp;"); else out.println(rs.getString("item_package"));%></font></td>
					<td class="style3"><font style="font-family:arial"><%=rs.getString("die_name")%><input type="hidden" name="DIEID" value="<%=rs.getString("die_item_id")%>"><input type="hidden" name="DIEQTY" value="<%=rs.getString("die_qty")%>"></font></td>
					<td class="style3"><font style="font-family:arial;<% if (!rs.getString("quantity").equals(ORIG_QTY)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><%=(new DecimalFormat("####0.####")).format((float)Math.round(Float.parseFloat(rs.getString("quantity"))*1000)/1000)%><input type="hidden" name="QTY" value="<%=rs.getString("quantity")%>"></font></td>
					<td class="style3"><font style="font-family:arial;<% if (!rs.getString("unit_price").equals(ORIG_UNITPRICE)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><span style="vertical-align:middle"><%=(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rs.getString("unit_price")))%>&nbsp;&nbsp;</span><IMG name='ppp' src='images/search.gif' width='20' height='15' border=0 alt='' onClick="subWindowHistory()"></font></td>
					<td class="style3"><font style="font-family:arial"><% if (rs.getString("packing")==null) out.println("&nbsp;"); else out.println(rs.getString("packing"));%></font></td>
					<td class="style3"><font style="font-family:arial;<% if (!rs.getString("package_spec").equals(ORIG_PACKAGE_SPEC)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><%=rs.getString("package_spec").replace("\n","<br>")%></font></td>
					<td class="style3"><font style="font-family:arial;<% if (!rs.getString("test_spec").equals(ORIG_TEST_SPEC)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><%=rs.getString("test_spec").replace("\n","<br>")%></font></td>
				</tr>
			</table>
	  </td>
	</tr>
	<TR>
		<TD height="121" class="style4">備註</TD>
		<TD colspan="11" class="style1" style="vertical-align:top"><font style="font-family:arial;font-size:12px;<% if (!rs.getString("remarks").equals(ORIG_REMARKS)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><%=rs.getString("remarks").replace("\n","<br>")%></font></TD>
	</TR>
	<tr>
		<TD height="57" class="style4" style="font-family:Arial">Marking</TD>
		<TD colspan="11" class="style1" ><font style="font-family:arial;font-size:12px;<% if (!rs.getString("marking").equals(ORIG_MARKING)) out.println("color:#ff0000;"); else out.println("color: #000000;");%>"><%=rs.getString("marking").replace("\n","<br>")%></font></TD>
	</TR>
	<tr>
		<TD height="40" class="style4" style="font-family:Arial">變更原因說明</TD>
		<TD colspan="11" class="style1" ><font style="font-family:arial;font-size:12px;color: #000000;"><%=rs.getString("change_reason")%></font></TD>
	</TR>		
	<TR>
		<TD colspan="12">
			<table  width="100%" border="1" cellpadding="1" cellspacing="0" bordercolorlight="#D8DEA9"  bordercolordark="#336666" bordercolor="#cccccc">
				<tr>
					<td height="29" colspan="12" class="style2" style="font-family:Arial">Producton Control：</td>
				</tr>	
				<% 
				int idx_num=50;
				//float totWQty =0,totCQty=0;
				if (LINENUM.equals("0"))
				{
					sql = " SELECT x.*"+
                          ",(ORIG_QTY+LOTONHAND) ONHAND"+
						  ",SUM(x.wafer_qty) over(order by x.line_no) tot_wafer_qty"+
						  ",SUM(x.chip_qty) over(order by x.line_no) tot_chip_qty"+
                          " FROM (SELECT a.line_no,a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, a.completion_date,a.SUBINVENTORY_CODE,a.inventory_item_id,a.inventory_item_name"+
						  ",nvl((select sum(TRANSACTION_QUANTITY) from MTL_ONHAND_QUANTITIES_DETAIL c where c.organization_id=49 and NVL(c.lot_number,'XXXX')=NVL(a.lot_number,'XXXX') and c.SUBINVENTORY_CODE=a.SUBINVENTORY_CODE and c.inventory_item_id=a.inventory_item_id ),0) lotonhand "+
						  //" - nvl((select sum(CHIP_QTY) from oraddman.tspmd_oem_headers_all m,oraddman.tspmd_oem_lines_all n where m.request_no = n.request_no AND m.WIP_MTL_STATUS IS NULL AND m.STATUS='Approved' AND n.inventory_item_id=a.inventory_item_id AND n.LOT_NUMBER=a.LOT_NUMBER and (n.request_no <> a.request_no or n.version_id <> a.version_id)),0) lotonhand"+  //onhand須扣除尚未領料的工單數量,modify by Peggy 20130223
						  //" - nvl((select sum(CHIP_QTY) from oraddman.tspmd_oem_headers_all m,oraddman.tspmd_oem_lines_all n where m.request_no = n.request_no AND m.WIP_MTL_STATUS IS NULL AND m.STATUS='Approved' AND n.inventory_item_id=a.inventory_item_id AND n.LOT_NUMBER=a.LOT_NUMBER and (n.request_no <> a.request_no or n.version_id <> a.version_id)),0) + DECODE(NVL(wip_mtl_status,'N'),'S', a.chip_qty,0) lotonhand"+  //modify by Peggy 20140925,加回已發料的庫存,mark by Peggy 20210303
						  ",nvl((select sum(x.chip_qty) orig_qty from oraddman.tspmd_oem_lines_all x WHERE x.request_no = b.request_no and x.version_id = b.orig_version_id  and x.subinventory_code=a.subinventory_code and x.inventory_item_id=a.inventory_item_id),0) orig_qty"+						  
					      ",nvl((select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no = a.request_no and c.version_id=a.version_id),0) rec_cnt  "+
						  ",a.miscellaneous_erp_flag"+ //add by Peggy 20171013
						  ",a.wafer_number"+ //add by Peggy 20180730
						  ",a.DC_YYWW"+  //add by Peggy 20221205
						  ",a.DIE_MODE"+  //add by Peggy 20221208
						  " FROM oraddman.tspmd_oem_lines_all a,oraddman.tspmd_oem_headers_all b"+
						  " WHERE a.request_no||'-'||a.version_id='"+REQUESTNO+"' "+
						  " and a.request_no = b.request_no and a.version_id = b.version_id) x"+
 						  " order by x.line_no ";
					//out.println(sql);
					Statement statementd=con.createStatement();
					ResultSet rsd=statementd.executeQuery(sql);
					int i =0;
					while (rsd.next())				
					{
						if (rs.getString("version_id").equals("0"))
						{
							ORIG_ITEM_NAME = rsd.getString("inventory_item_name");
							ORIG_STOCK=rsd.getString("SUBINVENTORY_CODE");
							ORIG_WAFER_LOT=rsd.getString("lot_number");
							ORIG_CHIP_QTY=rsd.getString("chip_qty");
							ORIG_WAFER_QTY=rsd.getString("wafer_qty");
							ORIG_DATE_CODE=rsd.getString("date_code");
							ORIG_REQ_DATE=rsd.getString("completion_date");
							ORIG_WAFER_NUMBER=rsd.getString("wafer_number");
							ORIG_DC_YYWW=rsd.getString("DC_YYWW"); //add by Peggy 20221205
							ORIG_DIE_MODE=rsd.getString("DIE_MODE"); //add by Peggy 20221208
						}
						else
						{
							sql = " select inventory_item_name,SUBINVENTORY_CODE,lot_number,chip_qty,wafer_qty,date_code,completion_date ,wafer_number,DC_YYWW,die_mode"+
								  " from  oraddman.tspmd_oem_lines_all a where a.request_no||'-'||a.version_id ='"+ ORIG_REQUESTNO+"' and line_no='"+ rsd.getString("line_no")+"'";
							Statement statementf=con.createStatement();
							ResultSet rsf=statementf.executeQuery(sql);
							if (rsf.next())				
							{
								ORIG_ITEM_NAME = rsf.getString("inventory_item_name");
								ORIG_STOCK=rsf.getString("SUBINVENTORY_CODE");
								ORIG_WAFER_LOT=rsf.getString("lot_number");
								ORIG_CHIP_QTY=rsf.getString("chip_qty");
								ORIG_WAFER_QTY=rsf.getString("wafer_qty");
								ORIG_DATE_CODE=rsf.getString("date_code");
								ORIG_REQ_DATE=rsf.getString("completion_date");
								ORIG_WAFER_NUMBER=rsd.getString("wafer_number");
								ORIG_DC_YYWW=rsd.getString("DC_YYWW"); //add by Peggy 20221205
								ORIG_DIE_MODE=rsd.getString("DIE_MODE"); //add by Peggy 20221208
								
							}
							else
							{
								ORIG_ITEM_NAME = "";ORIG_STOCK="";ORIG_WAFER_LOT="";ORIG_CHIP_QTY="0";ORIG_WAFER_QTY="0";ORIG_DATE_CODE="";ORIG_REQ_DATE="";ORIG_WAFER_NUMBER="";ORIG_DC_YYWW="";ORIG_DIE_MODE="";
							}
							rsf.close();
							statementf.close();
						}
						
						INVITEM=rsd.getString("inventory_item_name");
						INVITEMID=rsd.getString("inventory_item_id");
						Stock=rsd.getString("SUBINVENTORY_CODE");
						if (Stock==null) Stock="";
						WaferLot=rsd.getString("lot_number");
						WaferNumber=rsd.getString("Wafer_Number");
						//ChipQty=rsd.getString("chip_qty");
						//ChipQty=""+ (float)Math.round(Float.parseFloat(rsd.getString("chip_qty"))*10000)/10000; //modify by Peggy 20140106
						ChipQty=rsd.getString("chip_qty");
						//WaferQty=rsd.getString("wafer_qty");
						//WaferQty=""+(float)Math.round(Float.parseFloat(rsd.getString("wafer_qty"))*10000)/10000; //modify by Peggy 20140106
						WaferQty=rsd.getString("wafer_qty");
						DateCode=rsd.getString("date_code");
						if (DateCode==null) DateCode="";
						RequestSD=rsd.getString("completion_date");
						//LotOnhand="" + (float)Math.round((Float.parseFloat(rsd.getString("LotOnhand")) + Float.parseFloat(rsd.getString("orig_qty")))*100000)/100000;
						//LotOnhand="" + (float)Math.round((Float.parseFloat(rsd.getString("LotOnhand")) + Float.parseFloat(rsd.getString("orig_qty")))*100000)/100000;
						LotOnhand = rsd.getString("ONHAND");
						//totWQty += Float.parseFloat(WaferQty);
						//totCQty += Float.parseFloat(ChipQty);
						//totWaferQty =""+(float)Math.round(totWQty*10000)/10000;
						//totChipQty =""+ (float)Math.round(totCQty*10000)/10000;	
						totWaferQty=rsd.getString("tot_wafer_qty");
						totChipQty=rsd.getString("tot_chip_qty");
						misc_flag=rsd.getString("miscellaneous_erp_flag"); //add by Peggy 20171013
						if (misc_flag==null) misc_flag="N";
						DC_YYWW=rsd.getString("DC_YYWW");  //add by Peggy 20221205
						if (DC_YYWW==null) DC_YYWW="";
						DIE_MODE=rsd.getString("DIE_MODE");  //add by Peggy 20221208
						if (DIE_MODE==null) DIE_MODE="";
											
						i++;
						if (i==1)
						{
							out.println("<tr>");
							out.println("<TD class='style4' width='5%' rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+2)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
							//out.println("<TD class='style4'>&nbsp;&nbsp;</td>");
							out.println("<TD class='style4' width='10%'><font style='font-family:細明體'>行號</font></td>");
							out.println("<TD class='style4' width='17%'><font style='font-family:Arial'>Item Name</font></td>");
							out.println("<TD class='style4' width='7%'><font style='font-family:Arial'>Wafer Subinventory</font></td>");
							out.println("<TD class='style4' width='15%'><font style='font-family:Arial'>Wafer Lot#</font></td>");
							out.println("<TD class='style4' width='11%'><font style='font-family:Arial'>Wafer片號</font></td>");
							out.println("<TD class='style4' width='5%'><font style='font-family:Arial'>Wafer Qty</font></TD>");
							out.println("<TD class='style4' width='5%'><font style='font-family:Arial'>Chip Qty</font></td>");
							out.println("<TD class='style4' width='5%'><font style='font-family:Arial'>Date Code</font></td>");
							out.println("<TD class='style4' width='5%'><font style='font-family:Arial'>DC YYWW</font></td>");
							out.println("<TD class='style4' width='5%'><font style='font-family:Arial'>DIE MODE</font></td>");
							//out.println("<TD class='style4' width='10%'><font style='font-family:Arial'>Request S/D</font></td>");
							out.println("<TD class='style4' width='5%'rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+2)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
							out.println("</TR>");
						}
						out.println("<tr>");
						//out.println("<TD class='style1'><input type='button' name='BtnDel"+i+"'  size='20' value='刪除' onClick='setDelete("+i+")'></td>");
						out.println("<TD class='style1'><input type='text' name='LineNo"+i+"'    size='3'  value='"+i+"' style='font-family:Arial' readonly></td>");
						out.println("<TD class='style1'><input type='hidden' name='INVITEMID"+i+"' value='"+INVITEMID+"'><input type='text' name='INVITEM"+i+"'  size='22' tabindex='"+(idx_num++)+"' value='"+INVITEM+"'  style='font-family:Arial;text-align:center;"+(!INVITEM.equals(ORIG_ITEM_NAME)?"color:#ff0000;":"color:#000000;")+"' "+(!WIPTYPE.equals("03") && !WIPTYPE.equals("05")?"readonly":"readonly")+"><input type='button' name='btnInvItem"+i+"' style='font-family:arial;"+(!WIPTYPE.equals("03") && !WIPTYPE.equals("05")?"visibility:hidden;":"visibility:hidden;")+"' value='...' title='請按我!' onClick='subWindowInvItemFind("+i+")'></td>");
						out.println("<TD class='style1'><input type='text' name='Stock"+i+"' value='"+(Stock==null?"":Stock)+"' style='font-family:Arial;text-align:center;"+(!Stock.equals(ORIG_STOCK)?"color:#ff0000;":"color:#000000;")+"' size='6' readonly></td>");
						out.println("<TD class='style1'><input type='hidden' name='LotOnhand"+i+"' value='"+LotOnhand+"'><input type='text' name='WaferLot"+i+"'  size='14' tabindex='"+(idx_num++)+"' value='"+(WaferLot==null?"&nbsp;":WaferLot)+"'  style='font-family:Arial;text-align:center;"+((WaferLot!=null && !WaferLot.equals(ORIG_WAFER_LOT))?"color:#ff0000;":"color:#000000;")+"' readonly><input type='button' name='btnLot"+i+"' style='width:0;visibility:hidden;font-family:arial' value='...' title='請按我!' onClick='subWindowItemLotFind("+i+")'></td>");
						out.println("<TD class='style1'><input type='text' name='WaferNumber"+i+"'  size='12' tabindex='"+(idx_num++)+"' value='"+(WaferNumber==null?"&nbsp;":WaferNumber)+"'  style='font-family:Arial;text-align:center;"+((WaferNumber!=null && !WaferNumber.equals(ORIG_WAFER_NUMBER))?"color:#ff0000;":"color:#000000;")+"' readonly></td>");
						out.println("<TD class='style1'><input type='text' name='WaferQty"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+WaferQty+"'  style='font-family:Arial;text-align:center;"+(Float.parseFloat(WaferQty)!=Float.parseFloat(ORIG_WAFER_QTY)?"color:#ff0000;":"color:#000000;")+"' onChange='computeTotal("+'"'+"WaferQty"+'"'+")' readonly></TD>");
						out.println("<TD class='style1'><input type='text' name='ChipQty"+i+"'   size='5' tabindex='"+(idx_num++)+"' value='"+ChipQty+"'   style='font-family:Arial;text-align:center;"+(!ChipQty.equals(ORIG_CHIP_QTY)?"color:#ff0000;":"color:#000000;")+"' onChange='computeTotal("+'"'+"ChipQty"+'"'+")' readonly></TD>");
						out.println("<TD class='style1'><input type='text' name='DateCode"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+(DateCode==null?"&nbsp;":DateCode)+"'  style='font-family:Arial;text-align:center;"+(!DateCode.equals(ORIG_DATE_CODE)?"color:#ff0000;":"color:#000000;")+"' readonly><input type='hidden' name='misc_flag"+i+"' value='"+misc_flag+"'></td>");
						out.println("<TD class='style1'><input type='text' name='DC_YYWW"+i+"'  size='5' tabindex='"+(idx_num++)+"' value='"+(DC_YYWW==null?"&nbsp;":DC_YYWW)+"'  style='font-family:Arial;text-align:center;"+(!DC_YYWW.equals(ORIG_DC_YYWW)?"color:#ff0000;":"color:#000000;")+"' readonly></td>");
						out.println("<TD class='style1'><input type='text' name='DIE_MODE"+i+"'  size='6' tabindex='"+(idx_num++)+"' value='"+(DIE_MODE==null?"&nbsp;":DIE_MODE)+"'  style='font-family:Arial;text-align:center;"+(!DIE_MODE.equals(ORIG_DIE_MODE)?"color:#ff0000;":"color:#000000;")+"' readonly></td>");
						//out.println("<TD class='style1'><input type='text' name='RequestSD"+i+"' size='10' tabindex='"+(idx_num++)+"' value='"+RequestSD+"' style='font-family:Arial;text-align:center;"+(!RequestSD.equals(ORIG_REQ_DATE)?"color:#ff0000;":"color:#000000;")+"' readonly>");
						//out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM."+"RequestSD"+i+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif' style='visibility:hidden;'></A>");
						out.println("</td>");					
						out.println("</tr>");
					}
					rsd.close();
					statementd.close();
					LINENUM = ""+ i;
				}
				else
				{
				%>
					<TR>
						<TD class="style4" rowspan="<%=Integer.parseInt(LINENUM)+2%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<!--<TD class="style4">&nbsp;&nbsp;</td>!-->
						<TD class="style4"><font style="font-family:細明體">行號</font></td>
						<TD class="style4"><font style="font-family:Arial">Item Name</font></td>
						<TD class="style4"><font style="font-family:Arial">Wafer Subinventory</font></td>
						<TD class="style4"><font style="font-family:Arial">Wafer Lot#</font></td>
						<TD class="style4"><font style="font-family:Arial">Wafer片號</font></td>
						<TD class="style4"><font style="font-family:Arial">Wafer Qty</font></TD>
						<TD class="style4"><font style="font-family:Arial">Chip Qty</font></td>
						<TD class="style4"><font style="font-family:Arial">Date Code</font></td>
						<TD class="style4"><font style="font-family:Arial">DC YYWW</font></td>
						<TD class="style4"><font style="font-family:Arial">Die Mode</font></td>
						<!--<TD class="style4"><font style="font-family:Arial">Request S/D</font></td>-->
						<TD class="style4" rowspan="<%=Integer.parseInt(LINENUM)+2%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					</TR>
				<%
					for (int i = 1; i <=Integer.parseInt(LINENUM) ; i++)
					{ 
						Stock=request.getParameter("Stock"+i);
						if (Stock==null) Stock="";
						INVITEM=request.getParameter("INVITEM"+i);
						if (INVITEM==null) INVITEM="";
						INVITEMID=request.getParameter("INVITEMID"+i);
						if (INVITEMID==null) INVITEMID="";
						WaferLot=request.getParameter("WaferLot"+i);
						if (WaferLot==null) WaferLot="";
						WaferNumber=request.getParameter("WaferNumber"+i);
						if (WaferNumber==null) WaferNumber="";						
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
						misc_flag = request.getParameter("misc_flag"+i);  //add by Peggy 20171013
						if (misc_flag==null) misc_flag ="N";											
						DC_YYWW=request.getParameter("DC_YYWW"+i); //add by Peggy 20221205
						if (DC_YYWW==null) DC_YYWW="";
						DIE_MODE=request.getParameter("DIE_MODE"+i);  //add by Peggy 20221208
						if (DIE_MODE==null) DIE_MODE="";									
						
				%>
					<TR>
						<!--<TD class="style1"><input type="button" name=<%="BtnDel"+i%>   size="20" value="刪除" onClick='setDelete(<%=i%>)'></td>-->
						<TD class="style1"><input type="text" name=<%="LineNo"+i%>     size="3"  value="<%=i%>" style="font-family:Arial" readonly></td>
						<TD class="style1"><input type="hidden" name ="<%="INVITEMID"+i%>" value="<%=INVITEMID%>"><input type="text" name=<%="INVITEM"+i%>   size="25" tabindex="<%=(idx_num++)%>" value="<%=INVITEM%>" style="font-family:Arial;text-align:center" <%if (!WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println("readonly"); else out.println("readonly");%>><input type="button" name="<%="btnInvItem"+i%>" style="font-family:arial" value="..." title="請按我!" onClick="subWindowInvItemFind(<%=i%>)" <%if (!WIPTYPE.equals("03") && !WIPTYPE.equals("05")) out.println("style='visibility:hidden;'"); else out.println("style='visibility:hidden;'");%>></td>
						<TD class="style1"><input type="text" name ="<%="Stock"+i%>" value="<%=Stock%>" style="font-family:Arial;text-align:center" size="5" readonly></td>
						<TD class="style1"><input type="hidden" name="<%="LotOnhand"+i%>" value="<%=LotOnhand%>"><input type="text" name=<%="WaferLot"+i%>   size="16" tabindex="<%=(idx_num++)%>" value="<%=(WaferLot==null?"&nbsp;":WaferLot)%>" style="font-family:Arial;text-align:center" readonly><input type="button" name="<%="btnLot"+i%>" style="visibility:hidden;font-family:arial" value="..." title="請按我!" onClick="subWindowItemLotFind(<%=i%>)"></td>
						<TD class="style1"><input type="hidden" name="<%="WaferNumber"+i%>" value="<%=WaferNumber%>"><input type="text" name=<%="WaferNumber"+i%>   size="12" tabindex="<%=(idx_num++)%>" value="<%=(WaferNumber==null?"&nbsp;":WaferNumber)%>" style="font-family:Arial;text-align:center" readonly></td>
						<TD class="style1"><input type="text" name=<%="WaferQty"+i%>   size="6" tabindex="<%=(idx_num++)%>" value="<%=WaferQty%>" style="font-family:Arial;text-align:center" onChange="computeTotal('WaferQty')" readonly></TD>
						<TD class="style1"><input type="text" name=<%="ChipQty"+i%>    size="6" tabindex="<%=(idx_num++)%>" value="<%=ChipQty%>" style="font-family:Arial;text-align:center" onChange="computeTotal('ChipQty')" readonly></td>
						<TD class="style1"><input type="text" name=<%="DateCode"+i%>   size="7" tabindex="<%=(idx_num++)%>" value="<%=DateCode%>" style="font-family:Arial;text-align:center" readonly><input type="hidden" name="<%="misc_flag"+i%>" value="<%=misc_flag%>"></td>
						<TD class="style1"><input type="text" name=<%="DC_YYWW"+i%>   size="7" tabindex="<%=(idx_num++)%>" value="<%=DC_YYWW%>" style="font-family:Arial;text-align:center" readonly></td>
						<TD class="style1"><input type="text" name=<%="DIE_MODE"+i%>   size="7" tabindex="<%=(idx_num++)%>" value="<%=DIE_MODE%>" style="font-family:Arial;text-align:center" readonly></td>
						<!--<TD class="style1"><input type="text" name=<%="RequestSD"+i%>  size="10" tabindex="<%=(idx_num++)%>" value="<%=RequestSD%>" style="font-family:Arial;text-align:center" readonly></td>-->
					</TR>
				<%
					}
				}
				%>
				<tr>
					<TD class="style6" colspan="5"><font class="style6" style="font-family:arial;text-align:Right">Total：</font></td>
					<TD class="style4" style="border-left-style:none"><input type="text" name="totWaferQty" value="<%=totWaferQty%>" size="15" style="font-family:arial; text-align:right; background-color:#D8DEA9; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></TD>
					<TD class="style4" style="border-left-style:none"><input type="text" name="totChipQty" value="<%=totChipQty%>" size="15" style="font-family:arial; text-align:right; background-color:#D8DEA9; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></td>
					<TD class="style4"colspan="5" style="border-left-style:none">&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
					<TD colspan="12"><font style="font-size:12px;font-family:標楷體;color:#663300"><strong><jsp:getProperty name="rPH" property="pgAction"/>=></strong></font>						
					<%
					try
					{    
						Statement statement1=con.createStatement();
						ResultSet rs1=statement1.executeQuery("SELECT a.type_no, a.type_name  FROM oraddman.tspmd_data_type_tbl a  WHERE DATA_TYPE='F1-002'  AND a.status_flag='A'");
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
						<INPUT TYPE="text"  name="reason"  value="退件原因說明:"  size="10" style="border-left:none;border-top:none;border-bottom:none;border-right:none;visibility:hidden;font-family:arial;color:#FF0000">
						<INPUT TYPE="text"  name="approvemark"  value="<%=APPROVEMARK%>" SIZE="40" style="visibility:hidden;font-family:arial">
					</td>
					<!--<TD align="right" style="border-left-style: none;"><input type="text" name="txtLine"  size="5" value="1" style="font-family:arial;text-align:right"><input type="button" name="addline"  size="20" value="AddLine" style="font-family:arial" onClick='setAddLine("../jsp/TSCPMDOEMConfirm.jsp")'></td>
					<TD align="right" style="border-left-style: none;">&nbsp;&nbsp;&nbsp;</TD>-->
				</tr>
		  	</table>
	  </TD>
	</TR>
</table>
<%
	}
}
catch(Exception e)
{
	out.println("Exception2:"+e.getMessage());	
}
%>
<input type="hidden" name="LINENUM" value="<%=LINENUM%>">
<input type="hidden" name="REQLIST" value="<%=REQLIST%>">
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
</html>
