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
<jsp:useBean id="WIPMISCBean" scope="session" class="Array2DimensionInputBean"/>
<title>A01委外加工單-新增</title>
<script language="JavaScript" type="text/JavaScript">
function setWIPType(wip_type)
{
	subWindowSupplierFind(wip_type);
	if (wip_type=="BGBM")
	{
		document.MYFORM.CHKASSEMBLY.checked=false;
		document.MYFORM.CHKTESTING.checked=false;
        document.MYFORM.CHKTAPING.checked=false;
        document.MYFORM.CHKLAPPING.checked=true;
        document.MYFORM.CHKOTHERS.checked=false;
		document.MYFORM.OTHERS.value="";
		document.MYFORM.MARKING.value="N/A";
		document.MYFORM.REMARKS.value=document.MYFORM.BGBM_REMARKS.value;
		if (document.MYFORM.ITEMNAME.value=="MQ-W050NB0608DVN")
		{
			document.MYFORM.REMARKS.value=document.MYFORM.REMARKS.value.replace("007N4_AUSL.02","002N6_AUSL.02");
		}
		document.getElementById("DIV_CHKASSEMBLY").style.Color ="#000000";	
		document.getElementById("DIV_CHKASSEMBLY").style.fontWeight ="normal";
		document.getElementById("DIV_CHKTESTING").style.Color ="#000000";	
		document.getElementById("DIV_CHKTESTING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKTAPING").style.Color ="#000000";	
		document.getElementById("DIV_CHKTAPING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKLAPPING").style.Color ="#0033CC";	
		document.getElementById("DIV_CHKLAPPING").style.fontWeight ="bold";
		document.getElementById("DIV_CHKOTHERS").style.Color ="#000000";	
		document.getElementById("DIV_CHKOTHERS").style.fontWeight ="normal";
		document.MYFORM.VENDORITEMNAME.value="";
		document.MYFORM.NEWITEMID.value="";
		document.MYFORM.NEWITEMNAME.value="";
		document.MYFORM.NEWITEMDESC.value="";
		//document.getElementById("cp1").style.visibility="hidden";
		//document.getElementById("cp11").style.visibility="hidden";
	}
	else if (wip_type=="CP")
	{
		document.MYFORM.CHKASSEMBLY.checked=false;
		document.MYFORM.CHKTESTING.checked=true;
        document.MYFORM.CHKTAPING.checked=false;
        document.MYFORM.CHKLAPPING.checked=false;
        document.MYFORM.CHKOTHERS.checked=false;
		document.MYFORM.OTHERS.value="";
		document.MYFORM.MARKING.value="N/A";
		document.MYFORM.REMARKS.value=document.MYFORM.CP_REMARKS.value;
		document.getElementById("DIV_CHKASSEMBLY").style.Color ="#000000";	
		document.getElementById("DIV_CHKASSEMBLY").style.fontWeight ="normal";
		document.getElementById("DIV_CHKTESTING").style.Color ="#0033CC";	
		document.getElementById("DIV_CHKTESTING").style.fontWeight ="bold";
		document.getElementById("DIV_CHKTAPING").style.Color ="#000000";	
		document.getElementById("DIV_CHKTAPING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKLAPPING").style.Color ="#000000";	
		document.getElementById("DIV_CHKLAPPING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKOTHERS").style.Color ="#000000";	
		document.getElementById("DIV_CHKOTHERS").style.fontWeight ="normal";
		document.MYFORM.VENDORITEMNAME.value="";
		document.MYFORM.NEWITEMID.value="";
		document.MYFORM.NEWITEMNAME.value="";
		document.MYFORM.NEWITEMDESC.value="";		
		//document.getElementById("cp1").style.visibility="visible";
		//document.getElementById("cp11").style.visibility="visible";
	}
	else
	{
		document.MYFORM.CHKASSEMBLY.checked=false;
		document.MYFORM.CHKTESTING.checked=false;
        document.MYFORM.CHKTAPING.checked=false;
        document.MYFORM.CHKLAPPING.checked=false;
        document.MYFORM.CHKOTHERS.checked=false;
		document.MYFORM.OTHERS.value="";
		document.MYFORM.MARKING.value="";
		document.MYFORM.REMARKS.value="";
		document.getElementById("DIV_CHKASSEMBLY").style.Color ="#000000";	
		document.getElementById("DIV_CHKASSEMBLY").style.fontWeight ="normal";
		document.getElementById("DIV_CHKTESTING").style.Color ="#000000";	
		document.getElementById("DIV_CHKTESTING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKTAPING").style.Color ="#000000";	
		document.getElementById("DIV_CHKTAPING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKLAPPING").style.Color ="#000000";	
		document.getElementById("DIV_CHKLAPPING").style.fontWeight ="normal";
		document.getElementById("DIV_CHKOTHERS").style.Color ="#000000";			
		document.getElementById("DIV_CHKOTHERS").style.fontWeight ="normal";
	}
}
function subWindowSupplierFind(wip_type)
{
	if (document.MYFORM.WIP_TYPE.value=="--" || document.MYFORM.WIP_TYPE.value==null || document.MYFORM.WIP_TYPE.value=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIP_TYPE.focus();
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSA01OEMSupplierInfo.jsp?WIP_TYPE="+document.MYFORM.WIP_TYPE.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}
function subWindowItemFind(itemname,itemdesc,itype)
{
	if (document.MYFORM.WIP_TYPE.value=="--" || document.MYFORM.WIP_TYPE.value==null || document.MYFORM.WIP_TYPE.value=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIP_TYPE.focus();
		return false;
	}
	if (itype=="OLD")
	{
		if (document.MYFORM.VENDOR_SITE_ID.value==null || document.MYFORM.VENDOR_SITE_ID.value=="")
		{
			alert("請選擇供應商!");
			document.MYFORM.VENDOR_NAME.focus();
			return false;
		}
	}
	subWin=window.open("../jsp/subwindow/TSA01OEMItemInfo.jsp?WIP_TYPE="+document.MYFORM.WIP_TYPE.value+"&VSID="+document.MYFORM.VENDOR_SITE_ID.value+"&ITEMNAME="+itemname+"&ITEMDESC="+itemdesc+"&ITYPE="+itype,"subwin","width=840,height=480,scrollbars=yes,menubar=no,location=no");
}
function subWindowItemMiscFind(irow)
{
	if (document.MYFORM.WIP_TYPE.value=="--" || document.MYFORM.WIP_TYPE.value==null || document.MYFORM.WIP_TYPE.value=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIP_TYPE.focus();
		return false;
	}
	if (document.MYFORM.DIEID.value==null || document.MYFORM.DIEID.value=="")
	{
		alert("請選擇料號!");
		document.MYFORM.ITEMNAME.focus();
		return false;
	}	
	subWin=window.open("../jsp/subwindow/TSA01OEMMISCItemInfo.jsp?WIP_TYPE="+document.MYFORM.WIP_TYPE.value+"&DIEID="+document.MYFORM.DIEID.value+"&IROW="+irow+"&ITEMN="+document.MYFORM.ITEMNAME.value,"subwin","width=640,height=480,scrollbars=yes,menubar=no,location=no");
}
function chkHold(objname)
{
	if (document.getElementById(objname).checked)
	{
		document.getElementById("div_"+objname).style.Color ="#0033CC";	
		document.getElementById("div_"+objname).style.fontWeight ="bold";
	}
	else
	{
		document.getElementById("div_"+objname).style.Color ="#000000";	
		document.getElementById("div_"+objname).style.fontWeight ="normal";
	}
}
function setDelete(URL)
{
	if (confirm("Are you sure to delete this line?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();		
	}
}
function setExit()
{
	if (confirm("Are you sure to exit this function?"))
	{
		location.href="/oradds/ORADDSMainMenu.jsp";
	}
}
function setSubmit(URL)
{
	var iLen=0,iCnt=0;
	if (document.MYFORM.WIP_TYPE.value=="--" || document.MYFORM.WIP_TYPE.value==null || document.MYFORM.WIP_TYPE.value=="")
	{
		alert("請選擇工單類型!");
		document.MYFORM.WIP_TYPE.focus();
		return false;
	}
	if (document.MYFORM.VENDOR_SITE_ID.value==null || document.MYFORM.VENDOR_SITE_ID.value=="")
	{
		alert("請選擇供應商!");
		document.MYFORM.VENDOR_NAME.focus();
		return false;
	}	
	if (document.MYFORM.DIEID.value==null || document.MYFORM.DIEID.value=="")
	{
		alert("請選擇料號!");
		document.MYFORM.ITEMNAME.focus();
		return false;
	}	
	if (document.MYFORM.COMPLETION_DATE.value=="")
	{
		alert("請輸入預計完工日!");
		document.MYFORM.COMPLETION_DATE.focus();
		return false;	
	}
	if (document.MYFORM.SUBINVENTORY_CODE.value=="")
	{
		alert("請輸入完工入庫倉!");
		document.MYFORM.SUBINVENTORY_CODE.focus();
		return false;
	}
	if (document.MYFORM.WIP_NO.value=="")
	{
		alert("請輸入工單號碼!");
		document.MYFORM.WIP_NO.focus();
		return false;
	}
	else if (document.MYFORM.WIP_TYPE.value=="CP" && document.MYFORM.WIP_NO.value.indexOf("PA-")<0)
	{
		alert("工單號碼須為PA-開頭!");
		document.MYFORM.WIP_NO.focus();
		return false;
	}
	else if (document.MYFORM.WIP_TYPE.value=="BGBM" && document.MYFORM.WIP_NO.value.indexOf("SA-")<0)
	{
		alert("工單號碼須為SA-開頭!");
		document.MYFORM.WIP_NO.focus();
		return false;
	}
		
	if (document.MYFORM.chk == undefined)
	{
		iLen = 0;
	}
	else if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else 
	{
		iLen = 1;
	}
	
	computeTotal();
	for (var i=1; i<= iLen ; i++)
	{	
		if (document.MYFORM.elements["LOT_D_"+(i)].value=="") continue;
		if (document.MYFORM.elements["WAFERNO_D_"+(i)].value==null || document.MYFORM.elements["WAFERNO_D_"+(i)].value=="")
		{
			alert("請輸入片號!");
			document.MYFORM.elements["WAFERNO_D_"+(i)].focus();
			return false;
		}
		for (var j=i+1; j<= iLen ; j++)
		{
			if (document.MYFORM.elements["LOT_D_"+(j)].value!="" && document.MYFORM.elements["LOT_D_"+(i)].value==document.MYFORM.elements["LOT_D_"+(j)].value)
			{
				alert("批號重複,請確認!");
				document.MYFORM.elements["LOT_D_"+(j)].focus();
				return false;
			}
		}	
		iCnt++;
	}
	
	if (iCnt==0)
	{
		alert("請輸入工單發料明細!");
		return false;
	}

	if (document.MYFORM.Submit1 != undefined)
	{
		document.MYFORM.Submit1.disabled=true;
	}
	if (document.MYFORM.exit1 != undefined)
	{	
		document.MYFORM.exit1.disabled=true;
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function computeTotal()
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var tot_qty =0;
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue)
		{
			if (document.MYFORM.elements["WAFERQTY_D_"+(i)].value!="")
			{
				tot_qty = tot_qty + eval(document.MYFORM.elements["WAFERQTY_D_"+(i)].value);
			}
		}
	}
	document.MYFORM.QTY.value=""+tot_qty;
}

</script>
<STYLE TYPE='text/css'> 
 .style4   {font-family:細明體; font-size:11px; background-color:#BBDDEE; text-align:center}
 .style2   {font-family:Tahoma,Georgia; font-size:11px; background-color:#BBDDEE; text-align:center}
 .style1   {font-family:細明體; font-size:11px; background-color:#FFFFFF; text-align:center}
   BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
 </STYLE>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSA01OEMCreate.jsp">
<%
try
{
	String WIP_TYPE =request.getParameter("WIP_TYPE");
	if (WIP_TYPE==null) WIP_TYPE="";
	String WIP_CODE=request.getParameter("WIP_CODE");
	if (WIP_CODE==null) WIP_CODE="";
	String REQUEST_NO=request.getParameter("REQUEST_NO");
	if (REQUEST_NO==null) REQUEST_NO="";
	String VERSION_NO=request.getParameter("VERSION_NO");
	if (VERSION_NO==null) VERSION_NO="0";
	String REQUEST_NAME=request.getParameter("REQUEST_NAME");
	if (REQUEST_NAME==null) REQUEST_NAME=UserName;
	String ISSUE_DATE=request.getParameter("ISSUE_DATE");
	if (ISSUE_DATE==null) ISSUE_DATE=dateBean.getYearMonthDay();
	String VENDOR_ID = request.getParameter("VENDOR_ID");
	if (VENDOR_ID==null) VENDOR_ID="";
	String VENDOR_CODE = request.getParameter("VENDOR_CODE");
	if (VENDOR_CODE==null) VENDOR_CODE="";
	String VENDOR_SITE_ID = request.getParameter("VENDOR_SITE_ID");
	if (VENDOR_SITE_ID==null) VENDOR_SITE_ID="";	
	String VENDOR = request.getParameter("VENDOR");
	if (VENDOR==null) VENDOR="";
	String VENDOR_NAME = request.getParameter("VENDOR_NAME");
	if (VENDOR_NAME==null) VENDOR_NAME="";
	String VENDOR_CONTACT = request.getParameter("VENDOR_CONTACT");
	if (VENDOR_CONTACT==null) VENDOR_CONTACT="";
	String CURR_CODE = request.getParameter("CURR_CODE");
	if (CURR_CODE==null) CURR_CODE="";
	String COMPLETION_DATE = request.getParameter("COMPLETION_DATE");
	if (COMPLETION_DATE==null) COMPLETION_DATE="";
	String HOLD_FLAG=request.getParameter("HOLD_FLAG");
	if (HOLD_FLAG==null) HOLD_FLAG="";
	String CHKASSEMBLY = request.getParameter("CHKASSEMBLY");
	if (CHKASSEMBLY != null && CHKASSEMBLY.equals("Y")) CHKASSEMBLY="checked"; else CHKASSEMBLY="";
	String CHKTESTING = request.getParameter("CHKTESTING");
	if (CHKTESTING != null && CHKTESTING.equals("Y")) CHKTESTING="checked"; else CHKTESTING="";
	String CHKTAPING = request.getParameter("CHKTAPING");
	if (CHKTAPING != null && CHKTAPING.equals("Y")) CHKTAPING="checked"; else CHKTAPING="";
	String CHKLAPPING = request.getParameter("CHKLAPPING");
	if (CHKLAPPING != null && CHKLAPPING.equals("Y")) CHKLAPPING="checked"; else CHKLAPPING="";
	String CHKOTHERS = request.getParameter("CHKOTHERS");
	if (CHKOTHERS != null && CHKOTHERS.equals("Y")) CHKOTHERS="checked"; else CHKOTHERS="";
	String OTHERS = request.getParameter("OTHERS");
	if (OTHERS==null) OTHERS="";
	String PACKAGESPEC = request.getParameter("PACKAGESPEC");
	if (PACKAGESPEC==null) PACKAGESPEC="";
	String TESTSPEC = request.getParameter("TESTSPEC");
	if (TESTSPEC==null) TESTSPEC="";
	String MARKING= request.getParameter("MARKING");
	if (MARKING ==null) MARKING="";
	String REMARKS= request.getParameter("REMARKS");
	if (REMARKS ==null) REMARKS="";
	String ITEMID=request.getParameter("ITEMID");
	if (ITEMID==null) ITEMID="";
	String ITEMNAME=request.getParameter("ITEMNAME");
	if (ITEMNAME==null) ITEMNAME="";
	String ITEMDESC=request.getParameter("ITEMDESC");
	if (ITEMDESC==null) ITEMDESC="";
	String PACKAGE=request.getParameter("PACKAGE");
	if (PACKAGE==null) PACKAGE="";
	String DIENAME=request.getParameter("DIENAME");
	if (DIENAME==null) DIENAME="";
	String DIEID=request.getParameter("DIEID");
	if (DIEID==null) DIEID="";
	String DIEDESC=request.getParameter("DIEDESC");
	if (DIEDESC==null) DIEDESC="";
	String DIEQTY=request.getParameter("DIEQTY");
	if (DIEQTY==null) DIEQTY="";
	String BILLSEQID=request.getParameter("BILLSEQID");
	if (BILLSEQID==null) BILLSEQID="";
	String QTY=request.getParameter("QTY");
	if (QTY==null) QTY="";
	String UNITPRICE=request.getParameter("UNITPRICE");
	if (UNITPRICE==null) UNITPRICE="";
	String PACKING=request.getParameter("PACKING");
	if (PACKING==null) PACKING="";
	String PRICEUOM="",CURRENCYCODE="";
	String LINE_CNT=request.getParameter("LINE_CNT");
	if (LINE_CNT==null) LINE_CNT="10";
	String DELLINE=request.getParameter("DELLINE");
	if (DELLINE==null) DELLINE="";
	String SUBINVENTORY_CODE=request.getParameter("SUBINVENTORY_CODE");
	if (SUBINVENTORY_CODE==null) SUBINVENTORY_CODE="01";
	String NEWITEMID=request.getParameter("NEWITEMID");
	if (NEWITEMID==null) NEWITEMID="";
	String NEWITEMNAME=request.getParameter("NEWITEMNAME");
	if (NEWITEMNAME==null) NEWITEMNAME="";
	String NEWITEMDESC=request.getParameter("NEWITEMDESC");
	if (NEWITEMDESC==null) NEWITEMDESC="";
	String VENDORITEMNAME=request.getParameter("VENDORITEMNAME");
	if (VENDORITEMNAME==null) VENDORITEMNAME="";
	String WIP_NO=request.getParameter("WIP_NO");
	if (WIP_NO==null) WIP_NO="";
	
	String BGBM_REMARKS="1. 芯片已在貴司\n"+
	                    "2. LOT:\n"+
						"3. BG:減至150um\n"+
						"   BM:Ti/NiV/Ag:1K/2K/6K\n"+
						"4. 出貨地點:微矽電子股份有限公司\n"+
						"5. 對應型號007N4_AUSL.02";
	String CP_REMARKS="1. 待宜錦出貨\n"+
	                  "2. LOT:\n"+
					  "3. CP Report and MAP\n"+
					  "4. OQC Report\n"+
					  "5. 完成後請寄回台灣半導體";
	int irow=0;
	
	if (REQUEST_NO.equals(""))
	{
		WIPMISCBean.setArray2DString(null); 	
		CallableStatement cs1 = con.prepareCall("{call TSA01_OEM_PKG.GET_REQUEST_NO(?)}");
		cs1.registerOutParameter(1, Types.VARCHAR);   
		cs1.execute();
		REQUEST_NO = cs1.getString(1);                    
		cs1.close();
		if (REQUEST_NO==null)
		{
			throw new Exception("申請單號取值功能異常,請洽系統管理人員!");
		}
	}

%>
<input type="hidden" name="BGBM_REMARKS" value="<%=BGBM_REMARKS%>">
<input type="hidden" name="CP_REMARKS" value="<%=CP_REMARKS%>">
<table width="100%">
	<tr>	
		<td width="5%">&nbsp;</td>
		<td width="90%" align="center" style="font-weight:bold;font-size:22px;font-family:'細明體'">台灣半導體股份有限公司</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%">
				<tr>
					<td width="95%" align="center" style="font-weight:bold;font-size:20px;font-family:'細明體'">&nbsp;&nbsp;&nbsp;&nbsp;宜蘭封裝廠 委外託工單</td>
					<td><A HREF="/oradds/ORADDSMainMenu.jsp">回首頁</A></td>
				</tr>
			</table>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td width="8%" class="style4">工單類型<img src="images/lang.gif"></td>
					<td width="22%"><div id="DIV_HOLD_FLAG">
					<%
					try
					{   
						Statement statement=con.createStatement();
						ResultSet rs=null;		      
						String sql = " select distinct DATA_CODE, DATA_CODE  from ORADDMAN.TSA01_OEM_DATA_TYPE "+
									 " where DATA_TYPE='WIP_TYPE' AND NVL(STATUS_FLAG,'I') = 'A' AND DATA_CODE=NVL('"+WIP_CODE+"',DATA_CODE)"; 
						rs=statement.executeQuery(sql);
						out.println("<select NAME='WIP_TYPE' style='font-size:11px;font-family:Tahoma,Georgia' onchange='setWIPType(this.form.WIP_TYPE.value)'>");
						out.println("<OPTION VALUE=-->--");     
						while (rs.next())
						{            
							String s1=(String)rs.getString(1); 
							String s2=(String)rs.getString(2); 
							if (s1==WIP_TYPE || s1.equals(WIP_TYPE)) 
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
					<input type="checkbox" id="HOLD_FLAG" name="HOLD_FLAG" value="Y" onClick="chkHold('hold_flag')">預開工單暫不發料</div>
					</td>
					<td width="6%" class="style4">申請單號</td>
					<td width="10%" style="font-weight:bold;font-size:14px;color:#0033CC"><%=REQUEST_NO%><input type="hidden" name="REQUEST_NO" value="<%=REQUEST_NO%>"></td>
					<td width="6%" class="style4">版次</td>
					<td width="6%"><%=VERSION_NO%><input type="hidden" name="VERSION_NO" value="<%=VERSION_NO%>"></td>
					<td width="8%" class="style4">工單號碼</td>
					<td width="12%" ><input type="text" name="WIP_NO" value="<%=WIP_NO%>" size="12" style="font-family:Tahoma,Georgia;font-size:11px" ><input type="hidden" name="REQUEST_NAME" value="<%=REQUEST_NAME%>"></td>
					<td width="8%" class="style2">Issue Date</td>
					<td width="12%"><%=ISSUE_DATE%><input type="hidden" name="ISSUE_DATE" value="<%=ISSUE_DATE%>"></td>
				</tr>
				<tr>
					<td class="style4">供應商<img src="images/lang.gif"></td>
					<td><input type="text" name="VENDOR" value="<%=VENDOR%>" size="30" style="font-family:Tahoma,Georgia;font-size:11px" readonly>
					<input type="button" name="btn1" value=".." style="font-size:9px;font-family:Tahoma,Georgia" onClick="subWindowSupplierFind(this.form.WIP_TYPE.value)">
					<input type="hidden" name="VENDOR_ID" value="<%=VENDOR_ID%>">
					<input type="hidden" name="VENDOR_NAME" value="<%=VENDOR_NAME%>">
					<input type="hidden" name="VENDOR_CODE" value="<%=VENDOR_CODE%>">
					<input type="hidden" name="VENDOR_SITE_ID" value="<%=VENDOR_SITE_ID%>">
					</td>
					<td class="style4">聯絡人</td>
					<td><input type="text" name="VENDOR_CONTACT" value="<%=VENDOR_CONTACT%>" size="15" style="font-family:Tahoma,Georgia;font-size:11px" ></td>
					<td class="style4">幣別</td>
					<td><input type="text" name="CURR_CODE" value="<%=CURR_CODE%>" size="8" style="font-family:Tahoma,Georgia;font-size:11px" readonly></td>
					<td class="style4">預計完工日<img src="images/lang.gif"></td>
					<td><input type="text" name="COMPLETION_DATE" value="<%=COMPLETION_DATE%>" size="12" style="font-family:Tahoma,Georgia;font-size:11px" readonly><A href="javascript:void(0)" onclick="gfPop.fPopCalendar(document.MYFORM.COMPLETION_DATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A></td>
					<td class="style4">完工入庫倉<img src="images/lang.gif"></td>
					<td><input type="text" name="SUBINVENTORY_CODE" value="<%=SUBINVENTORY_CODE%>" size="8" style="font-family:Tahoma,Georgia;font-size:11px"></td>
				</tr>				
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td width="15%"><div id="DIV_CHKASSEMBLY"><input type="checkbox" name="CHKASSEMBLY" value="Y" <%=CHKASSEMBLY%> onClick="chkHold('CHKASSEMBLY')">封裝 <font style="font-family:Tahoma,Georgia">Assembly</font></div></td>
					<td width="15%"><div id="DIV_CHKTESTING"><input type="checkbox" name="CHKTESTING" value="Y" <%=CHKTESTING%> onClick="chkHold('CHKTESTING')">測試 <font style="font-family:Tahoma,Georgia">Testing</font></div></td>
					<td width="15%"><div id="DIV_CHKTAPING"><input type="checkbox" name="CHKTAPING" value="Y" <%=CHKTAPING%> onClick="chkHold('CHKTAPING')">編帶 <font style="font-family:Tahoma,Georgia">T＆R</font></div></td>
					<td width="15%"><div id="DIV_CHKLAPPING"><input type="checkbox" name="CHKLAPPING" value="Y" <%=CHKLAPPING%> onClick="chkHold('CHKLAPPING')">減薄 <font style="font-family:Tahoma,Georgia">Lapping</font></div></td>
					<td width="40%"><div id="DIV_CHKOTHERS"><input type="checkbox" name="CHKOTHERS" value="Y" <%=CHKOTHERS%> onClick="chkHold('CHKOTHERS')">其他&nbsp;&nbsp;<input type="text" name="OTHERS" size="50" style="border-bottom-style:double;border-left:none;border-right:none;border-top:none;font-size:11px;font-family:Tahoma,Georgia" value=<%=OTHERS%>></div></td>
				</tr>
			</table>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td class="style4">料號<img src="images/lang.gif"><br><font style="font-family:Tahoma,Georgia">Item No</font></td>
					<td class="style4">品名<img src="images/lang.gif"><br><font style="font-family:Tahoma,Georgia">Device Name</font></td>
					<td class="style4">封裝型式<br><font style="font-family:Tahoma,Georgia">Package</font></td>
					<td class="style4">芯片名稱<br><font style="font-family:Tahoma,Georgia">Die Name</font></td>
					<td class="style4">數量<img src="images/lang.gif"><br><input type="text" name="UOM1" value="Q'ty" style="text-align:right;border:thin;background-color:#BBDDEE;font-size:11px;font-family:Tahoma,Georgia" size="2">/<input type="text" name="UOM2" value="片" style="border:thin;background-color:#BBDDEE;font-size:11px;font-family:Tahoma,Georgia" size="2"></td>
					<td class="style4">單價<font style="font-family:Tahoma,Georgia">U/P</font><br><input type="text" name="CURR1" value="" style="text-align:right;border:thin;background-color:#BBDDEE;font-size:11px;font-family:Tahoma,Georgia" size="2">/<input type="text" name="UOM3" value="片" style="border:thin;background-color:#BBDDEE;font-size:11px;font-family:Tahoma,Georgia" size="2"></td>
					<td class="style4">包裝<br><font style="font-family:Tahoma,Georgia">Packing</font></td>
					<td class="style4">封裝規格<img src="images/lang.gif"><br><font style="font-family:Tahoma,Georgia">D/B No.</font></td>
					<td class="style4">測試規格<img src="images/lang.gif"><br><font style="font-family:Tahoma,Georgia">Test Spec</font></td>
				</tr>
				<tr>
					<td class="style1"><input type="hidden" name="ITEMID" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=ITEMID%>" >
					<input type="text" name="ITEMNAME" size="20" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=ITEMNAME%>" onKeyPress='subWindowItemFind(this.form.ITEMNAME.value,"","OLD")'>
					<input type='button' name='btnItem' value='..' style="font-family:Tahoma,Georgia" onClick='subWindowItemFind(this.form.ITEMNAME.value,"","OLD")'></td>
					<td class="style1"><input type="text" name="ITEMDESC" size="20" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=ITEMDESC%>" onKeyPress='subWindowItemFind("",this.form.ITEMDESC.value)'>
					<input type='button' name='btnDesc' value='..' style="font-family:Tahoma,Georgia" onClick='subWindowItemFind("",this.form.ITEMDESC.value,"OLD")'></td>
					<td class="style1"><input type="text" name="PACKAGE" size="8" style="font-size:11px;font-family:Tahoma,Georgia"  value="<%=PACKAGE%>" readonly></td>
					<td class="style1"><input type="text" name="DIEDESC" size="20" style="font-size:11px;font-family:Tahoma,Georgia" value='<%=DIEDESC%>' readonly>
					<input type="hidden" name="DIEID" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=DIEID%>">
					<input type="hidden" name="DIENAME" style="font-family:Tahoma,Georgia" value="<%=DIENAME%>">
					<input type="hidden" name="DIEQTY" style="font-family:Tahoma,Georgia" value="<%=DIEQTY%>">
					<input type="hidden" name="BILLSEQID" style="font-family:Tahoma,Georgia" value="<%=BILLSEQID%>"></td>
					<td class="style1"><input type="text" name="QTY" size="7" style="font-size:11px;font-family:Tahoma,Georgia;text-align=right" value="<%=QTY%>" readonly></td>
					<td class="style1"><input type="text" name="UNITPRICE" size="4" style="font-size:11px;font-family:Tahoma,Georgia;text-align=right" value="<%=UNITPRICE%>" readonly></td>
					<td class="style1"><input type="text" name="PACKING" size="12" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=PACKING%>"></td>
					<td class="style1"><textarea cols="21" rows="2" name="PACKAGESPEC" style="font-size:11px;font-family:Tahoma,Georgia"><%=PACKAGESPEC%></textarea></td>
					<td class="style1"><textarea cols="21" rows="2" name="TESTSPEC" style="font-size:11px;font-family:Tahoma,Georgia"><%=TESTSPEC%></textarea></td>
				</tr>
				<tr id="cp1" style="visibility:hidden">
					<td colspan="2" class="style4">台半片轉K料號<img src="images/lang.gif"></td>
					<td colspan="2" class="style4">台半片轉K品名<img src="images/lang.gif"></td>
					<td rowspan="2" colspan="5">&nbsp;</td>
				</tr>
				<tr id="cp11" style="height:0;visibility:hidden">
					<td colspan="2" class="style1"><input type="hidden" name="NEWITEMID" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=NEWITEMID%>" >
					<input type="hidden" name="VENDORITEMNAME" size="14" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=VENDORITEMNAME%>">
					<input type="text" name="NEWITEMNAME" size="20" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=NEWITEMNAME%>">
					<input type='button' name='btnItem1' value='..' style="font-family:Tahoma,Georgia" onClick='subWindowItemFind(this.form.NEWITEMNAME.value,"","NEW")'></td>
					<td colspan="2" class="style1"><input type="text" name="NEWITEMDESC" size="20" style="font-size:11px;font-family:Tahoma,Georgia" value="<%=NEWITEMDESC%>">
					<input type='button' name='btnDesc1' value='..' style="font-family:Tahoma,Georgia" onClick='subWindowItemFind("",this.form.NEWITEMDESC.value,"NEW")'></td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<td width="8%" class="style2">Marking<img src="images/lang.gif"></td>
					<td width="18%"><textarea cols="30" rows="5" name="MARKING" style="font-size:11px;text-align:left;font-family:Tahoma,Georgia" ><%=MARKING%></textarea></td>
					<td width="8%" class="style4">備註<img src="images/lang.gif"></td>
					<td width="66%"><textarea cols="110" rows="5" name="REMARKS" style="font-size:11px;text-align:left;font-family:Tahoma,Georgia" ><%=REMARKS%></textarea></td>
				</tr>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#CCCCCC">
				<tr>
					<TD width="4%" class="style2">Line#</td>
					<TD width="18%" class="style2">Item No</td>
					<TD width="15%" class="style2">Item Name</td>
					<TD width="10%" class="style2">Wafer Subinventory</td>
					<TD width="18%" class="style2">Wafer Lot#</td>
					<TD width="15%" class="style2">Wafer片號</td>
					<TD width="10%" class="style2">Wafer Qty</TD>
					<TD width="10%" class="style2">Date Code</td>
				</tr>
				<%
				irow=0;
				for (int i =1 ; i <= Integer.parseInt(LINE_CNT) ; i++)
				{
					if (DELLINE.equals(""+i)) continue;
					irow++;
				%>
				<tr>
					<td align="center"><%=irow%><input type="checkbox" name="chk" value="<%=irow%>" style="visibility:hidden" <%=(request.getParameter("ITEMNAME_D_"+i)==null||request.getParameter("ITEMNAME_D_"+i).equals("")?"":"checked")%>></td>
					<td align="center"><input type="text" name="ITEMNAME_D_<%=irow%>" value="<%=(request.getParameter("ITEMNAME_D_"+i)==null?"":request.getParameter("ITEMNAME_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="30" readonly><input type="hidden" name="ITEMID_D_<%=irow%>" value="<%=(request.getParameter("ITEMID_D_"+i)==null?"":request.getParameter("ITEMID_D_"+i))%>"></td>
					<td align="center"><input type="text" name="ITEMDESC_D_<%=irow%>" value="<%=(request.getParameter("ITEMDESC_D_"+i)==null?"":request.getParameter("ITEMDESC_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="25" readonly></td>
					<td align="center"><input type="text" name="SUBINV_D_<%=irow%>" value="<%=(request.getParameter("SUBINV_D_"+i)==null?"":request.getParameter("SUBINV_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="10" readonly></td>
					<td align="center"><input type="text" name="LOT_D_<%=irow%>" value="<%=(request.getParameter("LOT_D_"+i)==null?"":request.getParameter("LOT_D_"+i))%>" style="font-family:Tahoma,Georgia" size="12" readonly>
					<input type="button" name="lin_btn<%=irow%>" value=".." onClick="subWindowItemMiscFind(<%=irow%>)"> 
					<img border="0" src="images/delete.png" height="14" title="delete data" onClick="setDelete('../jsp/TSA01OEMCreate.jsp?DELLINE=<%=irow%>')"></td>
					<td align="center"><input type="text" name="WAFERNO_D_<%=irow%>" value="<%=(request.getParameter("WAFERNO_D_"+i)==null?"":request.getParameter("WAFERNO_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="25"></td>
					<td align="center"><input type="text" name="WAFERQTY_D_<%=irow%>" value="<%=(request.getParameter("WAFERQTY_D_"+i)==null?"":request.getParameter("WAFERQTY_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="10" onchange="computeTotal()"></td>
					<td align="center"><input type="text" name="DATECODE_D_<%=irow%>" value="<%=(request.getParameter("DATECODE_D_"+i)==null?"":request.getParameter("DATECODE_D_"+i))%>" style="font-size:11px;font-family:Tahoma,Georgia" size="10" readonly></td>
				</tr>
				<%
				}
				for (int i = irow+1; i<= Integer.parseInt(LINE_CNT) ; i++)
				{
					irow++;
				%>
				<tr>
					<td align="center"><%=irow%><input type="checkbox" name="chk" value="<%=irow%>" style="visibility:hidden"></td>
					<td align="center"><input type="text" name="ITEMNAME_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="30" readonly><input type="hidden" name="ITEMID_D_<%=irow%>" value=""></td>
					<td align="center"><input type="text" name="ITEMDESC_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="25" readonly></td>
					<td align="center"><input type="text" name="SUBINV_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="10" readonly></td>
					<td align="center"><input type="text" name="LOT_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="12" eadonly>
					<input type="button" name="lin_btn<%=irow%>" value=".." onClick="subWindowItemMiscFind(<%=irow%>)"> 
					<img border="0" src="images/delete.png" height="14" title="delete data" onClick="setDelete('../jsp/TSA01OEMCreate.jsp?DELLINE=<%=irow%>')"></td>
					<td align="center"><input type="text" name="WAFERNO_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="25"></td>
					<td align="center"><input type="text" name="WAFERQTY_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="10" onchange="computeTotal('WAFERQTY_D')"></td>
					<td align="center"><input type="text" name="DATECODE_D_<%=irow%>" value="" style="font-size:11px;font-family:Tahoma,Georgia" size="10" readonly></td>
				</tr>
				<%				
				}
				//LINE_CNT=""+irow;
				%>
			</table>
		</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align="center">
			<INPUT TYPE="button"  NAME="Submit1" value="送出申請" onClick='setSubmit("../jsp/TSA01OEMProcess.jsp")' style="font-size:11px;font-family:Tahoma,Georgia">
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			&nbsp;&nbsp;
			<INPUT TYPE="button"  NAME="exit1" value="離開不儲存" onClick="setExit()" style="font-size:11px;font-family:Tahoma,Georgia">
		</td>
		<td>&nbsp;</td>
	</tr>
</table>
<input type="hidden" name="LINE_CNT" value="<%=LINE_CNT%>">	
<input type="hidden" name="TRANSCODE" value="Submit">	
<%
	if (!DELLINE.equals(""))
	{
	%>
	<script language="JavaScript" type="text/JavaScript">
	computeTotal();
	</script>
	<%
	}
}
catch(Exception e)
{
	out.println("<font color='red'>"+e.getMessage()+"</font>");
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>

