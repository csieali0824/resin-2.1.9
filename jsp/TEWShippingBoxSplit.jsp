<!--20151204 by Peggy,TSC_PROD_ROUP更名,Rect=>PRD,SSP=>SSD-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.lang.Math"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TEW Pick Confirm Detail</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.MYFORM.delete1.disabled= false;
		window.opener.document.MYFORM.exit1.disabled= false;
		window.opener.document.MYFORM.submit();
		window.close();	
    }  
} 
function setAddLine(URL)
{
	var TXTLINE = document.MYFORMD.TXTLINE.value;
	if (TXTLINE == "" || TXTLINE == null || TXTLINE == "null")
	{
		alert("請輸入欲新增行數!");
		document.MYFORMD.TXTLINE.focus();
		return false;
	}	
	else
	{
		var regex = /^-?\d+$/;
		if (TXTLINE.match(regex)==null) 
		{ 
    		alert("數量必須是整數數值型態!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;
		} 
		else if (parseInt(TXTLINE)<1 || parseInt(TXTLINE)>10)
		{
    		alert("行數新增範圍1~10!"); 
			document.MYFORMD.TXTLINE.focus();
			return false;		
		}
	}
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}
function setDelete(objLine)
{
	if (confirm("您確定要刪除Line No:"+objLine+"的資料嗎?"))
	{
		var SNO = document.MYFORMD.elements["S_CARTON_"+objLine].value;
		var ENO = document.MYFORMD.elements["E_CARTON_"+objLine].value;
		document.MYFORMD.action="../jsp/TEWShippingBoxSplit.jsp?ACODE=DELETELINE&DEL_SNO="+SNO+"&DEL_ENO="+ENO+"&DEL_LOT="+LOT;
		document.MYFORMD.submit();	
	}
	else
	{
		return false;
	}
}
function setSubmit(URL)
{
	var ID = document.MYFORMD.ID.value;
	var totqty = "";
	var sno_cnt =0;
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		if ((document.MYFORMD.elements["S_CARTON_"+i].value!=null && document.MYFORMD.elements["S_CARTON_"+i].value) !="" || (document.MYFORMD.elements["E_CARTON_"+i].value !=null && document.MYFORMD.elements["E_CARTON_"+i].value !="") || (document.MYFORMD.elements["BOX_QTY_"+i].value !=null && document.MYFORMD.elements["BOX_QTY_"+i].value !=""))
		{
			if (document.MYFORMD.elements["S_CARTON_"+i].value =="")
			{
				alert("請輸入起始箱號!!");
				document.MYFORMD.elements["S_CARTON_"+i].focus();
				return false;
			}
			else if (document.MYFORMD.elements["E_CARTON_"+i].value =="")
			{
				alert("請輸入結束箱號!!");
				document.MYFORMD.elements["E_CARTON_"+i].focus();
				return false;
			}
			else if (eval(document.MYFORMD.elements["S_CARTON_"+i].value) > eval(document.MYFORMD.elements["E_CARTON_"+i].value))
			{
				alert("箱號錯誤!!");
				document.MYFORMD.elements["E_CARTON_"+i].focus();
				return false;
			}
			else if (isNaN(document.MYFORMD.elements["BOX_QTY_"+i].value))
			{
				document.MYFORMD.elements["BOX_QTY_"+i].focus();
				alert("請輸入數字型態!!");
				return false;
			}
			else if (eval(document.MYFORMD.elements["BOX_QTY_"+i].value) > (eval(document.MYFORMD.elements["E_CARTON_"+i].value)-eval(document.MYFORMD.elements["S_CARTON_"+i].value)+1) *  eval(document.MYFORMD.CARTON_PER_QTY.value))
			{
				alert("數量錯誤!");
				document.MYFORMD.elements["BOX_QTY_"+i].value="";
				document.MYFORMD.elements["BOX_QTY_"+i].focus();
				return false;
			} 
			else if (document.MYFORMD.elements["E_CARTON_"+i].value!=document.MYFORMD.elements["S_CARTON_"+i].value && eval(document.MYFORMD.elements["BOX_QTY_"+i].value) !=(eval(document.MYFORMD.elements["E_CARTON_"+i].value)-eval(document.MYFORMD.elements["S_CARTON_"+i].value)+1) *  eval(document.MYFORMD.CARTON_PER_QTY.value))
			{
				alert("數量錯誤!");
				document.MYFORMD.elements["BOX_QTY_"+objseq].value="";
				document.MYFORMD.elements["BOX_QTY_"+objseq].focus();
			}
			for (var j =i+1 ; j <= document.MYFORMD.LINECNT.value ; j++)
			{
				if ((document.MYFORMD.elements["S_CARTON_"+j].value != null && document.MYFORMD.elements["S_CARTON_"+j].value !="") || (document.MYFORMD.elements["E_CARTON_"+j].value!=null && document.MYFORMD.elements["E_CARTON_"+j].value !="") || (document.MYFORMD.elements["BOX_QTY_"+j].value!=null && document.MYFORMD.elements["BOX_QTY_"+j].value !=""))
				{			
					if (eval(document.MYFORMD.elements["S_CARTON_"+i].value) >= eval(document.MYFORMD.elements["S_CARTON_"+j].value) && eval(document.MYFORMD.elements["S_CARTON_"+i].value) <= eval(document.MYFORMD.elements["E_CARTON_"+j].value))
					{
						alert("箱號重複!!");
						document.MYFORMD.elements["S_CARTON_"+i].focus();
						return false;
					}
					else if (eval(document.MYFORMD.elements["E_CARTON_"+i].value) >= eval(document.MYFORMD.elements["S_CARTON_"+j].value) && eval(document.MYFORMD.elements["E_CARTON_"+i].value) <= eval(document.MYFORMD.elements["E_CARTON_"+j].value))
					{
						alert("箱號重複!!");
						document.MYFORMD.elements["E_CARTON_"+i].focus();
						return false;
					}
				}		
			}
			if (document.MYFORMD.elements["S_CARTON_"+i].value == document.MYFORMD.SCNO.value)
			{
				sno_cnt ++;
			}
		}
	}
	if (sno_cnt ==0)
	{
		alert("起始箱號必須有一筆從"+document.MYFORMD.SCNO.value+"箱開始編起!!");
		return false;
	}
	else if (sno_cnt >1)
	{
		alert("起始箱號只能有一筆從"+document.MYFORMD.SCNO.value+"箱開始編起!!");
		return false;
	}
	if (eval(document.MYFORMD.TOTQTY.value) != eval(document.MYFORMD.TOTSHIPQTY.value))
	{
		alert("合計數量("+document.MYFORMD.TOTQTY.value+")必須等於總出貨數量("+document.MYFORMD.TOTSHIPQTY.value+")!");
		return false;
	}	
	document.MYFORMD.save1.disabled= true;
	document.MYFORMD.cancel1.disabled=true;
	document.MYFORMD.action=URL;
	document.MYFORMD.submit();
}

function setClose()
{
	window.opener.document.MYFORM.submit();
	this.window.close();
}

function setChange()
{
	document.MYFORMD.submit();
}

function setCNOChange(objseq)
{
	if (document.MYFORMD.elements["S_CARTON_"+objseq].value==null || document.MYFORMD.elements["S_CARTON_"+objseq].value=="" || document.MYFORMD.elements["E_CARTON_"+objseq].value==null ||  document.MYFORMD.elements["E_CARTON_"+objseq].value=="")
	{
		return;
	}
	else if (eval(document.MYFORMD.elements["S_CARTON_"+objseq].value) > eval(document.MYFORMD.elements["E_CARTON_"+objseq].value))
	{
		document.MYFORMD.elements["E_CARTON_"+objseq].value="";
		document.MYFORMD.elements["E_CARTON_"+objseq].focus();
		return;
	}
	else if (document.MYFORMD.elements["E_CARTON_"+objseq].value==document.MYFORMD.elements["S_CARTON_"+objseq].value)
	{
		document.MYFORMD.elements["BOX_QTY_"+objseq].value ="";
		return;
	}
	document.MYFORMD.elements["BOX_QTY_"+objseq].value = (eval(document.MYFORMD.elements["E_CARTON_"+objseq].value)-eval(document.MYFORMD.elements["S_CARTON_"+objseq].value)+1) *  eval(document.MYFORMD.CARTON_PER_QTY.value);
	countqty();
}
function setQTYChange(objseq)
{
	if (document.MYFORMD.elements["S_CARTON_"+objseq].value==null || document.MYFORMD.elements["S_CARTON_"+objseq].value=="")
	{
		alert("請先輸入起始箱數!");
		document.MYFORMD.elements["BOX_QTY_"+objseq].value="";
		document.MYFORMD.elements["S_CARTON_"+objseq].focus();
	}
	else if (document.MYFORMD.elements["E_CARTON_"+objseq].value==null || document.MYFORMD.elements["E_CARTON_"+objseq].value=="")
	{	
		alert("請先輸入結束箱數!");
		document.MYFORMD.elements["BOX_QTY_"+objseq].value="";
		document.MYFORMD.elements["E_CARTON_"+objseq].focus();
	}
	else if (eval(document.MYFORMD.elements["BOX_QTY_"+objseq].value) > (eval(document.MYFORMD.elements["E_CARTON_"+objseq].value)-eval(document.MYFORMD.elements["S_CARTON_"+objseq].value)+1) *  eval(document.MYFORMD.CARTON_PER_QTY.value))
	{
		alert("數量錯誤!");
		document.MYFORMD.elements["BOX_QTY_"+objseq].value="";
		document.MYFORMD.elements["BOX_QTY_"+objseq].focus();
	} 
	else if (document.MYFORMD.elements["E_CARTON_"+objseq].value!=document.MYFORMD.elements["S_CARTON_"+objseq].value && eval(document.MYFORMD.elements["BOX_QTY_"+objseq].value) !=(eval(document.MYFORMD.elements["E_CARTON_"+objseq].value)-eval(document.MYFORMD.elements["S_CARTON_"+objseq].value)+1) *  eval(document.MYFORMD.CARTON_PER_QTY.value))
	{
		alert("數量錯誤!");
		document.MYFORMD.elements["BOX_QTY_"+objseq].value="";
		document.MYFORMD.elements["BOX_QTY_"+objseq].focus();
	}
	countqty();
}

function countqty()
{
	var totqty=0;
	for (var i =1 ; i <= document.MYFORMD.LINECNT.value ; i++)
	{
		if (document.MYFORMD.elements["BOX_QTY_"+i].value==null || document.MYFORMD.elements["BOX_QTY_"+i].value=="") continue;
		totqty = totqty + eval(document.MYFORMD.elements["BOX_QTY_"+i].value);
	}	
	document.MYFORMD.TOTQTY.value = ""+totqty;
}
</script>
<%
String sql = "",DateCodeList="";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String TXTLINE = request.getParameter("TXTLINE");
if (TXTLINE==null) TXTLINE="0";
String LINECNT = request.getParameter("LINECNT");
if (LINECNT==null) LINECNT ="3";
String SO_NO="",SCNO="",ECNO="",SHIPQTY="",ITEM_DESC="",CARTON_PER_QTY="";
double TOTQTY=0;
boolean Line_Exist = false;
String ACODE = request.getParameter("ACODE");
if (ACODE ==null) ACODE="1";
if (ACODE.equals("ADDLINE"))
{
	LINECNT = ""+(Integer.parseInt(LINECNT)+Integer.parseInt(TXTLINE));
}
if (LINECNT.equals("0")) LINECNT="3";
int icnt=0,errcnt=0;	

try
{
	sql = " select a.tew_advise_no,a.pc_advise_id,a.so_no,a.so_header_id, a.so_line_id,a.inventory_item_id,a.ITEM_DESC,a.shipping_remark,a.CARTON_NUM_FR,a.CARTON_NUM_TO,a.CARTON_PER_QTY,a.TOTAL_QTY "+
		  " from tsc.tsc_shipping_advise_lines a where a.tew_advise_no =? and a.advise_line_id=?";
	//out.println(sql);
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,ADVISENO);
	statement1.setString(2,ID);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{
		Line_Exist=true;
		SCNO=rs1.getString("CARTON_NUM_FR");
		ECNO=rs1.getString("CARTON_NUM_TO");
		SHIPQTY=""+(rs1.getFloat("TOTAL_QTY")/1000);
		SO_NO = rs1.getString("SO_NO");
		ITEM_DESC = rs1.getString("ITEM_DESC");
		CARTON_PER_QTY=""+(rs1.getFloat("CARTON_PER_QTY")/1000);
	}
	else
	{
		Line_Exist=false;
	}
	rs1.close();
	statement1.close();	
}
catch(Exception e)
{
	Line_Exist=false;
}

if (!Line_Exist)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查無訂單資料,請重新確認,謝謝!");
		//window.opener.document.MYFORM.delete1.disabled= false;
		//window.opener.document.MYFORM.exit1.disabled= false;
		this.window.close();	
	</script>
<%
} 
%>
<body>  
<FORM ACTION="../jsp/TEWShippingBoxSplit.jsp" METHOD="post" NAME="MYFORMD">
<TABLE border="0" width="100%">
	<tr>
		<td width="10%" style="font-size:12px" align="right"><input type="text" name="txt1" value="Advise No：" style="text-align:right;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td width="20%" colspan="3"><input type="text" name="ADVISENO" value="<%=ADVISENO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly><input type="hidden" name="ID" value="<%=ID%>"><input type="hidden" name="SCNO" value="<%=SCNO%>"><input type="hidden" name="ECNO" value="<%=ECNO%>"></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right"><input type="text" name="txt2" value="MO#：" style="text-align:right;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td width="20%" colspan="3"><input type="text" name="SO_NO" value="<%=SO_NO%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right"><input type="text" name="txt3" value="型號：" style="text-align:right;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td width="20%" colspan="3"><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="30" readonly></td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td width="10%" style="font-size:12px" align="right"><input type="text" name="txt4" value="總出貨量：" style="text-align:right;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td width="20%"><input type="text" name="TOTSHIPQTY" value="<%=(new DecimalFormat("#####.###")).format(Float.parseFloat(SHIPQTY))%>" style="text-align:left;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="4" readonly>K</td>
		<td width="10%" style="font-size:12px" align="right"><input type="text" name="txt5" value="單箱數量：" style="text-align:right;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="10" readonly></td>
		<td width="20%"><input type="TEXT" name="CARTON_PER_QTY" value="<%=(new DecimalFormat("#####.###")).format(Float.parseFloat(CARTON_PER_QTY))%>" style="text-align:left;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;;border-right-width:0;" size="2" readonly>K</td>
	</tr>
</TABLE>
<hr>
<div style="color:#0000FF">(請注意!! 不滿箱請獨立一列，不可與滿箱寫在同列)</div>
<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="12%" align="center">起始箱號</td>
		<td width="12%" align="center">結束箱號</td>
		<td width="12%" align="center">出貨量(K)</td>
	</tr>
<%
if (ACODE.equals("1") || ACODE.equals("SAVE") || ACODE.equals("ADDLINE"))
{
	try
	{
		if (ACODE.equals("ADDLINE"))
		{	
			for (int i =0 ; i <Integer.parseInt(LINECNT) ; i++)
			{
		%>
				<tr>
					<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(i+1)%>" value="<%=(request.getParameter("S_CARTON_"+(i+1))==null?"":request.getParameter("S_CARTON_"+(i+1)))%>" style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
					<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(i+1)%>" value="<%=(request.getParameter("E_CARTON_"+(i+1))==null?"":request.getParameter("E_CARTON_"+(i+1)))%>" style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
					<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="TEXT" NAME="BOX_QTY_<%=(i+1)%>" value="<%=(request.getParameter("BOX_QTY_"+(i+1))==null?"":request.getParameter("BOX_QTY_"+(i+1)))%>" style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setQTYChange("<%=(i+1)%>")' onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode ==46 )"><input type="checkbox" name="chk1" value="<%=(i+1)%>" style="visibility:hidden" checked></td>
				</tr>	
		<%	
				TOTQTY += Double.valueOf((request.getParameter("BOX_QTY_"+(i+1))==null||request.getParameter("BOX_QTY_"+(i+1)).equals("")?"0":request.getParameter("BOX_QTY_"+(i+1)))).doubleValue();

			}		
		}
		else
		{
			if (ACODE.equals("SAVE"))
			{
				try
				{
					double NW=0,GW=0,CARTON_QTY=0;
					int MAX_CNO=0;
					for (int i =1; i <= Integer.parseInt(LINECNT) ; i++)
					{
						if (request.getParameter("S_CARTON_"+i) == null || request.getParameter("S_CARTON_"+i).equals("") || request.getParameter("E_CARTON_"+i) == null || request.getParameter("E_CARTON_"+i).equals("") ) continue;
						if (Integer.parseInt(request.getParameter("E_CARTON_"+i)) > Integer.parseInt(request.getParameter("ECNO")))
						{
							sql = " select 1 from tsc.tsc_shipping_advise_lines a where a.tew_advise_no =? and "+request.getParameter("E_CARTON_"+i)+" between CARTON_NUM_FR and CARTON_NUM_TO";
							PreparedStatement statement2 = con.prepareStatement(sql);
							statement2.setString(1,ADVISENO);
							ResultSet rs2=statement2.executeQuery();
							if (rs2.next())
							{
								if (Integer.parseInt(request.getParameter("E_CARTON_"+i))>	MAX_CNO) MAX_CNO=Integer.parseInt(request.getParameter("E_CARTON_"+i));	
							}
							rs2.close();
							statement2.close();		
						}
					}
					/*
					if (MAX_CNO>0)
					{
						sql = " select ADVISE_LINE_ID,CARTON_QTY from tsc.tsc_shipping_advise_lines a"+
							  " WHERE tew_advise_no = ?"+
                              " AND exists (select 1 FROM tsc.tsc_shipping_advise_lines b"+
                              " where b.tew_advise_no =a.tew_advise_no "+
                              " and b.ADVISE_LINE_ID =?"+
                              " and b.CARTON_NUM_TO <a.CARTON_NUM_FR) "+
                              " ORDER BY CARTON_NUM_FR,CARTON_NUM_TO";
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,ADVISENO);
						statement1.setString(2,ID);
						ResultSet rs1=statement1.executeQuery();
						while (rs1.next())
						{	
							sql = " update tsc.tsc_shipping_advise_lines"+
							      " set CARTON_NUM_FR=?"+
								  ",CARTON_NUM_TO=?"+
								  " where advise_line_id=?";
							PreparedStatement pstmtDt1=con.prepareStatement(sql);  
							pstmtDt1.setString(1,""+(MAX_CNO+1));
							pstmtDt1.setString(2,""+(MAX_CNO+rs1.getInt("CARTON_QTY"))); 
							pstmtDt1.setString(3,rs1.getString("ADVISE_LINE_ID"));
							pstmtDt1.executeQuery();
							pstmtDt1.close();
							MAX_CNO +=rs1.getInt("CARTON_QTY");
						}
						rs1.close();
						statement1.close();						  
					}
					*/
					
					sql = " select c.* from tsc.tsc_shipping_advise_lines a,ap.ap_supplier_sites_all b,tsc_item_packing_master c "+
                          " where c.INT_TYPE=?"+
						  " and NVL(c.STATUS,'N')=?"+
                          " and  a.ADVISE_LINE_ID =?"+
                          " and a.vendor_site_id=b.vendor_site_id"+
                          " and  decode(a.product_group,'Rect','Rect-Subcon','PRD','PRD-Subcon',a.product_group)=c.TSC_PROD_GROUP"+
                          " and a.TSC_PACKAGE=c.TSC_PACKAGE"+
                          " and a.PACKING_CODE=c.PACKING_CODE"+
                          " and b.vendor_id=c.VENDOR_ID"+
                          " order by decode(a.item_desc,c.attribute1,1,2)";
					PreparedStatement statement1 = con.prepareStatement(sql);
					statement1.setString(1,"TEW");
					statement1.setString(2,"Y");
					statement1.setString(3,ID);
					ResultSet rs1=statement1.executeQuery();
					if (rs1.next())
					{	
						NW=rs1.getDouble("NW");
						GW=rs1.getDouble("GW");
						CARTON_QTY = rs1.getDouble("CARTON_QTY");
					}
					rs1.close();
					statement1.close();
										  
					for (int i =1; i <= Integer.parseInt(LINECNT) ; i++)
					{
						if (request.getParameter("S_CARTON_"+i) == null || request.getParameter("S_CARTON_"+i).equals("") || request.getParameter("E_CARTON_"+i) == null || request.getParameter("E_CARTON_"+i).equals("") ) continue;
					
						//檢查同筆訂單是否已存在該箱號
						sql = " select advise_line_id from tsc.tsc_shipping_advise_lines a "+
						      " where ? between CARTON_NUM_FR and CARTON_NUM_TO"+
							  " and exists (select 1 from tsc.tsc_shipping_advise_lines x "+
							  " where x.tew_advise_no =?"+
							  " and x.ADVISE_LINE_ID =?"+
							  " and x.advise_header_id=a.advise_header_id "+
							  " and x.so_line_id=a.so_line_id)"+
							  " and a.advise_line_id <>?";
						PreparedStatement statement5 = con.prepareStatement(sql);
						statement5.setString(1,request.getParameter("S_CARTON_"+i));
						statement5.setString(2,ADVISENO);
						statement5.setString(3,ID);
						statement5.setString(4,ID);
						ResultSet rs5=statement5.executeQuery();
						if (rs5.next())
						{
							sql = " update tsc.tsc_shipping_advise_lines"+
							      " set SHIP_QTY=SHIP_QTY+(?)"+
								  ",CARTON_PER_QTY=CARTON_PER_QTY+(?)"+
								  ",TOTAL_QTY=CARTON_QTY*(CARTON_PER_QTY+(?))"+
								  ",NET_WEIGHT=round(((CARTON_PER_QTY+(?))/?)*?,1)"+
								  ",GROSS_WEIGHT=round(((CARTON_PER_QTY+(?))/?)*?,1)"+
								  " where advise_line_id=?";
							//out.println(sql);
							PreparedStatement pstmtDt1=con.prepareStatement(sql);  
							pstmtDt1.setString(1,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(2,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(3,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(4,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(5,""+CARTON_QTY); 
							pstmtDt1.setString(6,""+NW); 
							pstmtDt1.setString(7,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(8,""+CARTON_QTY); 
							pstmtDt1.setString(9,""+GW); 
							pstmtDt1.setString(10,rs5.getString(1));
							pstmtDt1.executeQuery();
							pstmtDt1.close();
								  
						}
						else
						{							  
							sql = " insert into tsc.tsc_shipping_advise_lines (advise_line_id"+               //0
								  "             ,advise_header_id"+             //1
								  "             ,so_header_id"+                 //2
								  "             ,so_line_id"+                   //3
								  "             ,so_no"+                        //4
								  "             ,so_line_number"+               //5
								  "             ,delivery_detail_id"+           //6
								  "             ,organization_id"+              //7
								  "             ,inventory_item_id"+            //8
								  "             ,item_no"+                      //9
								  "             ,item_desc"+                    //10
								  "             ,product_group"+                //11
								  "             ,so_qty"+                       //12
								  "             ,ship_qty"+                     //13
								  "             ,onhand_qty"+                   //14
								  "             ,pc_confirm_qty"+               //15
								  "             ,unship_confirm_qty"+           //16
								  "             ,uom"+                          //17
								  "             ,schedule_ship_date"+           //18
								  "             ,pc_schedule_ship_date"+        //19
								  "             ,net_weight"+                   //20
								  "             ,gross_weight"+                 //21
								  "             ,cube"+                         //22
								  "             ,pc_remark"+                    //23
								  "             ,packing_instructions"+         //24
								  "             ,shipping_remark"+              //25
								  "             ,region_code"+                  //26
								  "             ,po_no"+                        //27
								  "             ,carton_num_fr"+                //28
								  "             ,carton_num_to"+                //29
								  "             ,type"+                         //30
								  "             ,carton_qty"+                   //31
								  "             ,carton_per_qty"+               //32
								  "             ,total_qty"+                    //33
								  "             ,tsc_package"+                  //34
								  "             ,tsc_family"+                   //35
								  "             ,pc_advise_id"+                 //36
								  "             ,parent_advise_line_id"+        //37
								  "             ,file_id"+                      //38
								  "             ,packing_code"+                 //39
								  "             ,last_update_date"+             //40
								  "             ,last_updated_by"+              //41
								  "             ,creation_date"+                //42
								  "             ,created_by"+                   //43
								  "             ,last_update_login"+            //44
								  "             ,attribute1"+                   //45
								  "             ,attribute2"+                   //46
								  "             ,vendor_site_id"+               //47
								  "             ,tew_advise_no) "+              //48
								  " select tsc_shipping_advise_lines_s.nextval"+   //0
								  "        , advise_header_id"+                    //1
								  "        , so_header_id"+                        //2
								  "        , so_line_id"+                          //3
								  "        , so_no"+                               //4
								  "        , so_line_number"+                      //5
								  "        , delivery_detail_id"+                  //6
								  "        , organization_id"+                     //7
								  "        , inventory_item_id"+                   //8
								  "        , item_no"+                             //9
								  "        , item_desc"+                           //10
								  "        , product_group"+                       //11
								  "        , so_qty"+                              //12
								  "        , ?"+                                   //13
								  "        , onhand_qty"+                          //14
								  "        , pc_confirm_qty"+                      //15
								  "        , unship_confirm_qty"+                  //16
								  "        , uom"+                                 //17
								  "        , schedule_ship_date"+                  //18
								  "        , pc_schedule_ship_date"+               //19
								  "        , round(?,1)"+                          //20
								  "        , round(?,1)"+                          //21
								  "        , cube"+                                //22
								  "        , pc_remark"+                           //23
								  "        , packing_instructions"+                //24
								  "        , shipping_remark"+                     //25
								  "        , region_code"+                         //26
								  "        , po_no"+                               //27
								  "        , ?"+                                   //28
								  "        , ?"+                                   //29
								  "        , type"+                                //30
								  "        , ?"+                                   //31
								  "        , ?"+                                   //32
								  "        , ?"+                                   //33
								  "        , tsc_package"+                         //34
								  "        , tsc_family"+                          //35
								  "        , pc_advise_id"+                        //36
								  "        , parent_advise_line_id"+               //37
								  "        , file_id"+                             //38
								  "        , packing_code"+                        //39
								  "        , sysdate"+                             //40
								  "        , (select erp_user_id from oraddman.wsuser where USERNAME ='"+UserName+"' and rownum=1)"+  //41
								  "        , sysdate"+                             //42
								  "        , (select erp_user_id from oraddman.wsuser where USERNAME ='"+UserName+"' and rownum=1)"+  //43
								  "        , null"+                                //44
								  "        , attribute1"+                          //45
								  "        , attribute2"+                          //46
								  "        , vendor_site_id"+                      //47
								  "        , tew_advise_no "+                      //48
								  " FROM tsc.tsc_shipping_advise_lines "+
								  " where tew_advise_no =?"+
								  " and ADVISE_LINE_ID =?";
							//out.println(sql);
							PreparedStatement pstmtDt1=con.prepareStatement(sql);  
							pstmtDt1.setString(1,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(2,""+(((Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000)/(Integer.parseInt(request.getParameter("E_CARTON_"+i))-Integer.parseInt(request.getParameter("S_CARTON_"+i))+1)/CARTON_QTY)*NW)); 
							pstmtDt1.setString(3,""+(((Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000)/(Integer.parseInt(request.getParameter("E_CARTON_"+i))-Integer.parseInt(request.getParameter("S_CARTON_"+i))+1)/CARTON_QTY)*GW)); 
							pstmtDt1.setString(4,request.getParameter("S_CARTON_"+i)); 
							pstmtDt1.setString(5,request.getParameter("E_CARTON_"+i));
							pstmtDt1.setString(6,""+(Integer.parseInt(request.getParameter("E_CARTON_"+i))-Integer.parseInt(request.getParameter("S_CARTON_"+i))+1));
							pstmtDt1.setString(7,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000)/(Integer.parseInt(request.getParameter("E_CARTON_"+i))-Integer.parseInt(request.getParameter("S_CARTON_"+i))+1)); 
							pstmtDt1.setString(8,""+(Double.valueOf(request.getParameter("BOX_QTY_"+i)).doubleValue()*1000));
							pstmtDt1.setString(9,ADVISENO);
							pstmtDt1.setString(10,ID);
							pstmtDt1.executeQuery();
							pstmtDt1.close();
						}
						rs5.close();
						statement5.close();
					}

					PreparedStatement pstmtDt1=con.prepareStatement("delete tsc.tsc_shipping_advise_lines a  where tew_advise_no =? and ADVISE_LINE_ID =? ");  
					pstmtDt1.setString(1,ADVISENO);
					pstmtDt1.setString(2,ID);
					pstmtDt1.executeQuery();
					pstmtDt1.close();
					
					//add by Peggy 20160909	
					pstmtDt1=con.prepareStatement("update oraddman.TEW_LOT_RESERVATION_DETAIL a set STATUS='I' where ADVISE_LINE_ID =? ");  
					pstmtDt1.setString(1,ID);
					pstmtDt1.executeQuery();
					pstmtDt1.close();
															
					con.commit();
				
					//con.rollback();
					%>
						<script language="JavaScript" type="text/JavaScript">
							alert("修改成功!");
							setClose();
						</script>			
					<%				
				}
				catch(Exception e)
				{
					con.rollback();
					out.println("<font color='red'>更新失敗!!"+e.getMessage()+"</font>");
				}
			}
			sql = " SELECT CARTON_NUM_FR,CARTON_NUM_TO,TOTAL_QTY/1000 TOTAL_QTY"+
				  " FROM tsc.tsc_shipping_advise_lines a"+
				  " WHERE  a.advise_line_id=? "+
				  " AND a.TEW_ADVISE_NO=? ";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,ID);
			statement.setString(2,ADVISENO);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
		%>
			<tr>
				<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(icnt+1)%>" value="<%=rs.getString("CARTON_NUM_FR")%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(icnt+1)%>" value="<%=rs.getString("CARTON_NUM_TO")%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(icnt+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="TEXT" NAME="BOX_QTY_<%=(icnt+1)%>" value="<%=rs.getString("TOTAL_QTY")%>"  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setQTYChange("<%=(icnt+1)%>")' onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode ==46 )"><input type="checkbox" name="chk1" value="<%=(icnt+1)%>" style="visibility:hidden" checked></td>
			</tr>	
		<%
				TOTQTY +=Double.valueOf(rs.getString("TOTAL_QTY")).doubleValue();
				icnt++;
			}
			rs.close();
			statement.close();
		
			if (icnt==0 || icnt <Integer.parseInt(LINECNT))
			{
				for (int i =icnt ; i < Integer.parseInt(LINECNT) ; i++)
				{
			%>
					<tr>
						<td align="center"><input type="TEXT" NAME="S_CARTON_<%=(i+1)%>" value=""  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
						<td align="center"><input type="TEXT" NAME="E_CARTON_<%=(i+1)%>" value=""  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setCNOChange("<%=(i+1)%>")' onKeypress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
						<td align="center">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="TEXT" NAME="BOX_QTY_<%=(i+1)%>" value=""  style="text-align:center;font-family: Tahoma,Georgia;" size="5" onChange='setQTYChange("<%=(i+1)%>")'onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode ==46 )"><input type="checkbox" name="chk1" value="<%=(i+1)%>" style="visibility:hidden" checked></td>
					</tr>	
			<%		
					icnt++;
				}
			}		
			
			LINECNT = ""+icnt;
		}
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
}
%>	
	<tr>
		<td  colspan="2" style="border-left-style:none;border-right-style:none;"><input type="button" name="Addline" value="Add Line" style="font-family: Tahoma,Georgia;" onClick="setAddLine('../jsp/TEWShippingBoxSplit.jsp?ACODE=ADDLINE')"><input type="text" NAME="TXTLINE" value="1" style="font-family: Tahoma,Georgia;text-align:RIGHT" size="5"></td>
		<td  align="center"  style="border-left-style:none;">合計：<input type="text" name="TOTQTY" VALUE="<%=(new DecimalFormat("######0.###")).format(TOTQTY)%>" style="text-align:left;font-family: Tahoma,Georgia;border-bottom-width:0;border-top-width:0;border-left-width:0;border-right-width:0;" size="5" readonly></td>
	</tr>
</table>
<table width="100%">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="SAVE" onClick='setSubmit("../jsp/TEWShippingBoxSplit.jsp?ACODE=SAVE")' style="font-family: Tahoma,Georgia;">
			&nbsp;&nbsp;&nbsp;<input type="button" name="cancel1" value="CANCEL" onClick='setClose()' style="font-family: Tahoma,Georgia;">
		</td>
	</tr>
</table>
<input type="hidden" name="LINECNT" value="<%=LINECNT%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

