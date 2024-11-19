<!--20150904 Peggy,顯示單據申請歷程-->
<!--20161107 Peggy,新增prd 外包-->
<!--20170817 Peggy,預計完工日移至表頭,取消line request date,新增暫不發料選項-->
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
<title>委外加工單內容</title>
<STYLE TYPE='text/css'> 
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; text-align:center;color: #000000;}
 .style4   {
	font-family:Arial;
	font-size:12px;
	background-color:#CCFFCC;
	text-align:center;
color=#EE6633;
color: #000000;
}
 .style1   {
	font-family:Arial;
	font-size:12px;
	background-color:#FFFFFF;
	text-align:left;
	color: #000000;
}
 .style2   {
	font-family:Arial;
	font-size:12px;
	background-color:#CCFFCC;
	text-align:left;
color=#EE6633D;
	color: #000000;
}
 .style6  {
	font-family:Arial;
	font-size:12px;
	background-color:#CCFFCC;
	text-align:right;
color=#EE6633;
color: #000000;
}
.style7 {font-family: Arial; font-size: 12px; background-color: #CCFFCC; text-align: left; color: #000000; }
</STYLE>
</head>
<body>
<%
String REQUESTNO = request.getParameter("REQUESTNO");
String PROGRAMNAME = request.getParameter("PROGRAMNAME");
if (PROGRAMNAME==null) PROGRAMNAME="";
String WaferLot="",DateCode="",RequestSD="",Remarks="",status="",wordcolor="",ITEMNAME="",Stock="",WaferNumber="",DC_YYWW="",DIE_MODE="";
double totWaferQty=0,totChipQty=0;
double ChipQty=0,WaferQty=0;
String strHyperLink = "",strHyperLinkVal="";
if (PROGRAMNAME.equals("F1-001") || PROGRAMNAME.equals("F1-002"))
{
	strHyperLink = "回首頁";
	strHyperLinkVal = "/oradds/ORADDSMainMenu.jsp";
}
else
{
	strHyperLink = "回查詢畫面";
	strHyperLinkVal = "../jsp/TSCPMDOEMInformationQuery.jsp";
}

try
{
	String sql = " SELECT a.request_no, a.version_id,a.wip_type_no,b.TYPE_NAME wip_type_name, a.vendor_code, a.vendor_name,"+
				 " a.vendor_contact, a.request_date, a.inventory_item_id,"+
				 " a.inventory_item_name, a.item_description, a.item_package,"+
				 " a.die_item_id || decode(a.die_item_id1,null,'','<br>'||a.die_item_id1) die_item_id, a.die_name || decode(a.die_name1,null,'','<br>'||a.die_name1) die_name, a.quantity, a.unit_price, a.packing,"+
				 " a.package_spec, a.test_spec, a.assembly, a.testing,a.SUBINVENTORY_CODE,"+
				 " a.taping_reel, a.lapping, a.others, a.remarks, a.marking,a.wip_no,a.PR_NO,a.status,a.CREATED_BY_NAME,"+
				 " to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE , a.CURRENCY_CODE,"+
				 " to_char(a.APPROVE_DATE,'yyyy-mm-dd hh24:mi') APPROVE_DATE , a.APPROVED_BY_NAME,a.APPROVE_REMARK,decode(a.WIP_MTL_STATUS,'S','已領料',case when a.WIP_ISSUE_PENDING_FLAG='R' THEN '領料交易進行中' ELSE '尚未領料' END) WIP_MTL_STATUS,a.unit_price_uom"+
				 " ,a.po_no,nvl(a.die_item_id1,'') die_item_id1 ,nvl(a.die_name1,'') die_name1"+ //add by Peggy 20121009
				 " ,a.tsc_prod_group"+ //add by Peggy 20161110
				 " ,nvl(a.WIP_ISSUE_PENDING_FLAG,'N') WIP_ISSUE_PENDING_FLAG"+  //add by Peggy 20170822
				 ",a.front_side_metal fsm, a.ring_cut ringcut"+ //add by Peggy 20230426						 
				 //",(SELECT p.segment1  FROM  po.po_requisition_headers_all m, po.po_requisition_lines_all n,po.po_line_locations_all o, po.po_headers_all p"+
             	 //" where m.segment1 = a.pr_no and m.requisition_header_id=n.requisition_header_id(+) and n.line_location_id=o.line_location_id(+) and o.po_header_id=p.po_header_id(+)) PO_NO "+
				 " FROM oraddman.tspmd_oem_headers_all a,oraddman.TSPMD_DATA_TYPE_TBL b"+
				 " WHERE request_no||'-'||version_id='"+REQUESTNO+"' AND a.wip_type_no=b.TYPE_NO and b.DATA_TYPE='WIP'";
	//out.println(sql);
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if (rs.next())
	{
		status = rs.getString("STATUS");
		if (status.equals("Reject"))
		{
			wordcolor = "#990000";
		}
		else
		{
			wordcolor = "#000099";
		}
%>
<form name="MYFORM"  METHOD="post" >
 <DIV><font color="#000000" size="+2" face="標楷體"> <strong>委外加工單(申請單號:<font style="font-family:arial;color='<%=wordcolor%>';"><%=REQUESTNO%></font>)</strong><input type="hidden" name="REQUESTNO" value="<%=REQUESTNO%>"></font>
<br>
<A HREF="<%=strHyperLinkVal%>"><%=strHyperLink%></A>&nbsp;&nbsp;&nbsp;</DIV>
<table width="90%" border="1" align="left" cellpadding="1" cellspacing="0"  bordercolorlight="#FFFFFF"  bordercolordark="#999999">
	<tr>
		<td height="21" colspan="12" class="style7">訂單資訊：</td>
	</tr>
	<tr>
		<td width="7%" height="25" class="style2"><font style="font-family:arial; color: #000000;">工單類型:</font></td>
		<td class="style1" width="10%"><font style="font-family:arial;font-size:12px;"><%=rs.getString("wip_type_name")%></font></td>
		<td class="style2" width="7%"><font class="style2" style="font-family:ARIAL; color: #000000;">Issue Date:</font></td>
		<td class="style1" width="10%"><font style="font-family:arial;font-size:12px;"><%=rs.getString("request_date")%><input type="hidden" name="ISSUEDATE" value="<%=rs.getString("request_date")%>"></font></td>
		<td class="style2" width="7%" style="font-family:Arial; color: #000000;">工單號碼:</td>
	  	<td class="style1" Width="10%" ><font style="color:#DD0066;font-family:arial;font-size:12px;"><% if (rs.getString("wip_no")==null) out.println("&nbsp;"); else out.println(rs.getString("wip_no")); %><input type="hidden" name="WIPNO" value="<%=rs.getString("wip_no")%>"></font></td>
		<td class="style2" width="7%" style="font-family:Arial; color: #000000;">領料狀態:</td>
	    <td class="style1" width="7%" ><font style="color:#DD0066;font-family:arial;font-size:12px;"><% if (rs.getString("WIP_MTL_STATUS")==null) out.println("&nbsp;"); else out.println(rs.getString("WIP_MTL_STATUS"));%></font></td>
		<td class="style2" width="7%" style="font-family:Arial; color: #000000;">請購單號:</td>
	    <td class="style1" width="10%" ><font style="color:#CC5511;font-family:arial;font-size:12px;"><% if (rs.getString("pr_no")==null) out.println("&nbsp;"); else out.println(rs.getString("pr_no"));%><input type="hidden" name="PRNO" value="<%=rs.getString("pr_no")%>"></font></td>
		<td class="style2" width="7%" style="font-family:Arial; color: #000000;">採購單號:</td>
	    <td class="style1" width="10%" ><font style="color:#CC5511;font-family:arial;font-size:12px;"><% if (rs.getString("po_no")==null) out.println("&nbsp;"); else out.println(rs.getString("po_no"));%><input type="hidden" name="PONO" value="<%=rs.getString("po_no")%>"></font></td>
	</tr>    		   
	<tr>
		<td height="25" class="style2">廠商名稱:</td>
		<td class="style1" colspan="3"><font style="font-family:arial;font-size:12px;"><%="("+rs.getString("vendor_code")+")"+rs.getString("vendor_name")%></font></td> 	
		<td class="style2">聯絡人:</td>
		<td class="style1"><font style="font-family:arial;font-size:12px;"><%=rs.getString("vendor_contact")%></font></td> 
		<td class="style2" style="font-family:Arial; color: #000000;">幣別:</td>
	    <td class="style1" ><font style="color:#CC5511;font-family:arial;font-size:12px;"><% if (rs.getString("CURRENCY_CODE")==null) out.println("&nbsp;"); else out.println(rs.getString("CURRENCY_CODE"));%></font></td>
		<td class="style2" style="font-family:Arial; color: #000000;">完工入庫倉:</td>
	    <td class="style1" ><font style="color:#CC5511;font-family:arial;font-size:12px;"><% if (rs.getString("SUBINVENTORY_CODE")==null) out.println("&nbsp;"); else out.println(rs.getString("SUBINVENTORY_CODE"));%></font></td>
		<td class="style2">狀態:</td>
		<td class="style1"><font style="font-family:arial; font-size:12px; color: #000000;"><%=rs.getString("status")%></font></td> 
	</tr>
	<TR>
		<td colspan="12">
			<table width="100%">
				<tr>			
		    	 	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKASSEMBLY" <% if (rs.getString("assembly").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:Arial;font-size:12px">封裝 Assembly</font></TD>
			  	  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKTESTING" <% if (rs.getString("testing").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font class="style1" style="font-family:Arial;font-size:12px">測試 Testing</font></TD>
				  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKTAPING"  <% if (rs.getString("taping_reel").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:Arial;font-size:12px">編帶 T＆R</font></TD>
				  	<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKLAPPING" <% if (rs.getString("lapping").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font class="style1" style="font-family:Arial;font-size:12px">減薄 Lapping</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="FSM" <% if (rs.getString("FSM").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font class="style1" style="font-family:Arial; font-size:12px;">正面金屬濺鍍沈積 FSM</font></TD>
					<TD class="style1" width="10%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="RINGCUT" <% if (rs.getString("RINGCUT").equals("Y")) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font class="style1" style="font-family:Arial; font-size:12px;">環切 Ring Cut</font></TD>
					<TD class="style1" width="30%" style="border-style:double;border-color:#FFFFFF"><input type="checkbox" name="CHKOTHERS"  <% if (rs.getString("others")!=null) out.println("style='background-color:#CC0000' checked"); else out.println("");%> onclick="return false" onkeydown="return false" ><font style="font-family:Arial;font-size:12px">其他&nbsp;&nbsp;</font><input type="text" name="OTHERS" size="35" style="border-bottom-style:double;border-left:none;border-right:none;border-top:none;font-family:Arial" <%if (rs.getString("others")==null) out.println("value=''"); else out.println("value='"+rs.getString("others")+"'");%> readonly></td>
				</tr>
		  </table>	  </td>
	</TR>
	<tr>
		<td colspan="12">
			<table width="100%" bordercolorlight="#FFFFFF" border="1" cellpadding="1" cellspacing="0" bordercolordark="#999999">
				<tr>
				  	<td class="style4" width="8%">TSC Prod Group</td>
				  	<td class="style4" width="17%">料號<br><font class="style6" style="font-family:Arial">Item No</font></td>
					<td class="style4" width="13%">品名<br><font style="font-family:Arial">Device Name</font></td>
					<td class="style4" width="8%">封裝型式<br><font style="font-family:Arial">Package</font></td>
					<td class="style4" width="9%">芯片名稱<br><font style="font-family:Arial">Die Name</font></td>
					<td class="style4" width="7%">數量<br><font style="font-family:Arial">Q'ty(<%if (rs.getString("unit_price_uom").equals("片")) out.println(rs.getString("unit_price_uom")); else out.println("KPC");%>)</font></td>
					<td class="style4" width="7%">單價<font face="ARIAL">U/P</font><br><font style="font-family:Arial"><%=rs.getString("currency_code")+"/"+rs.getString("unit_price_uom")%></font></td>
					<td class="style4" width="9%">包裝<br><font style="font-family:Arial">Packing</font></td>
					<td class="style4" width="13%">封裝規格<br><font style="font-family:Arial">D/B No.</font></td>
					<td class="style4" width="13%">測試規格<br><font style="font-family:Arial">Test Spec</font></td>
				</tr>
				<tr>
					<td height="25" class="style3"><font style="font-family:arial"><%=rs.getString("tsc_prod_group")%></font></td>
					<td height="25" class="style3"><font style="font-family:arial"><%=rs.getString("inventory_item_name")%></font></td>
					<td class="style3"><font style="font-family:arial"><%=rs.getString("item_description")%></font></td>
					<td class="style3"><font style="font-family:arial"><%if (rs.getString("item_package")==null) out.println("&nbsp;"); else out.println(rs.getString("item_package"));%></font></td>
					<td class="style3"><font style="font-family:arial"><%=rs.getString("die_name")%><input type="hidden" name="DIEID" value="<%=rs.getString("die_item_id")%>"></font></td>
					<td class="style3"><font style="font-family:arial"><%=(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rs.getString("quantity")))%></font></td>
					<td class="style3"><font style="font-family:arial"><%=(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rs.getString("unit_price")))%></font></td>
					<td class="style3"><font style="font-family:arial"><%if (rs.getString("packing")==null) out.println("&nbsp;"); else out.println(rs.getString("packing"));%></font></td>
					<td class="style3"><font style="font-family:arial"><%=rs.getString("package_spec").replace("\n","<br>")%></font></td>
					<td class="style3"><font style="font-family:arial"><%=rs.getString("test_spec").replace("\n","<br>")%></font></td>
				</tr>
			</table>	  </td>
	</tr>
	<TR>
		<TD height="70" class="style4">備註</TD>
		<TD colspan="11" class="style1" style="vertical-align:top"><font style="font-family:arial;font-size:12px"><%=rs.getString("remarks").replace("\n","<br>")%></font></TD>
	</TR>
	<tr>
		<TD height="57" class="style4" style="font-family:Arial">Marking</TD>
		<TD colspan="11" class="style1" ><font style="font-family:arial;font-size:12px"><%=rs.getString("marking").replace("\n","<br>")%></font></TD>
	</TR>
	<TR>
		<TD colspan="12">
			<table border="1" cellpadding="1" cellspacing="0" bordercolorlight="#CCFFCC"  bordercolordark="#999999">
				<tr>
					<td height="29" colspan="13" class="style2" style="font-family:Arial">Producton Control：</td>
				</tr>	
				<% 
				sql = " SELECT a.lot_number, a.wafer_qty, a.chip_qty,a.date_code,a.SUBINVENTORY_CODE, a.completion_date,a.inventory_item_name,(select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no = a.request_no  and c.version_id = a.version_id) rec_cnt,wafer_number,dc_yyww,die_mode"+
  				      " FROM oraddman.tspmd_oem_lines_all a"+
					  " WHERE request_no||'-'||version_id='"+REQUESTNO+"' order by a.line_no";
				Statement statementd=con.createStatement();
				ResultSet rsd=statementd.executeQuery(sql);
				int i =0;
				double totWQty =0,totCQty=0;
				while (rsd.next())				
				{
					ITEMNAME=rsd.getString("inventory_item_name");
					Stock=rsd.getString("SUBINVENTORY_CODE");
					WaferLot=rsd.getString("lot_number");
					ChipQty=rsd.getDouble("chip_qty");
					WaferQty=rsd.getDouble("wafer_qty");
					WaferNumber=rsd.getString("wafer_number");
					DateCode=rsd.getString("date_code");
					RequestSD=rsd.getString("completion_date");
					totWQty += rsd.getDouble("wafer_qty");
					totCQty +=rsd.getDouble("chip_qty");
					//totWaferQty =""+(float)Math.round(totWQty*100000)/100000;
					//totChipQty =""+ (float)Math.round(totCQty*100000)/100000;	
					DC_YYWW=rsd.getString("DC_YYWW");  //add by Peggy 20220905
					if (DC_YYWW==null) DC_YYWW="";
					DIE_MODE=rsd.getString("DIE_MODE");  //add by Peggy 20221208
					if (DIE_MODE==null) DIE_MODE="";					
					totWaferQty=totWQty;
					totChipQty=totCQty;
					
					i++;
					if (i==1)
					{
						out.println("<tr>");
						out.println("<TD class='style4' rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+1)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
						out.println("<TD class='style4' width='5%'><font style='font-family:細明體'>行號</font></td>");
						out.println("<TD class='style4' width='25%'>Item Name</td>");
						out.println("<TD class='style4' width='13%'>Wafer Subinventory</td>");
						out.println("<TD class='style4' width='13%'>Wafer Lot#</td>");
						out.println("<TD class='style4' width='13%'>Wafer片號</td>");
						out.println("<TD class='style4' width='10%'>Wafer Qty</TD>");
						out.println("<TD class='style4' width='10%'>Chip Qty</td>");
						out.println("<TD class='style4' width='6%'>Date Code</td>");
						out.println("<TD class='style4' width='6%'>DC YYWW</td>");
						out.println("<TD class='style4' width='6%'>DIE MODE</td>");
						out.println("<TD class='style4' width='6%'>Request S/D</td>");
						out.println("<TD class='style4' rowspan='"+(Integer.parseInt(rsd.getString("rec_cnt"))+1)+"'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>");
						out.println("</TR>");
					}					
					out.println("<tr>");
					out.println("<TD class='style3'>"+i+"</td>");
					out.println("<TD class='style3'>"+ITEMNAME+"</td>");
					out.println("<TD class='style3'>"+(Stock==null?"&nbsp;":Stock)+"</td>");
					out.println("<TD class='style3'>"+((WaferLot==null || WaferLot.equals("null"))?"&nbsp;":WaferLot)+"</td>");
					out.println("<TD class='style3'>"+((WaferNumber==null || WaferNumber.equals("null"))?"&nbsp;":WaferNumber)+"</td>");
					out.println("<TD class='style3'>"+(new DecimalFormat("##,##0.####")).format(WaferQty)+"</TD>");
					out.println("<TD class='style3'>"+(new DecimalFormat("##,##0.####")).format(ChipQty)+"</td>");
					out.println("<TD class='style3'>"+((DateCode==null)?"&nbsp;":(DateCode.toUpperCase().equals("HOLD")?"<font color='#ff0000'>":"<font color='#000000'>")+DateCode+"</font>")+"</td>");
					out.println("<TD class='style3'>"+((DC_YYWW==null)?"&nbsp;":DC_YYWW)+"</td>");
					out.println("<TD class='style3'>"+((DIE_MODE==null)?"&nbsp;":DIE_MODE)+"</td>");
					out.println("<TD class='style3'>"+RequestSD+"</TD>");
					out.println("</tr>");
				}
				rsd.close();
				statementd.close();
				%>
				<tr>
					<TD class="style6" colspan="6"><font style="font-family:arial;text-align:Right">Total：</font></td>
					<TD style="border-left-style: none;font-family:Arial;font-size:12px;background-color:#CCFFCC;text-align:center;"><%=(new DecimalFormat("##,##0.####")).format(totWaferQty)%></TD>
					<TD style="border-left-style: none;font-family:Arial;font-size:12px;background-color:#CCFFCC;text-align:center;"><%=(new DecimalFormat("##,##0.####")).format(totChipQty)%></td>
					<TD colspan="5" style="border-left-style: none;font-family:Arial;font-size:12px;background-color:#CCFFCC;text-align:center;">&nbsp;&nbsp;&nbsp;</td>
				</tr>
		  	</table>	  
	  </TD>
	</TR>
	<%
		sql = " SELECT  a.action_name, a.VERSION_ID,to_char(a.action_date,'yyyy-mm-dd hh24:mi:ss')  action_date,a.actor, a.remark "+
		      " FROM oraddman.tspmd_action_history a"+
		      " where a.request_no ='" + REQUESTNO.substring(0,REQUESTNO.indexOf("-"))+"' order by a.action_date";
		//out.println(sql);
		Statement statementa=con.createStatement();
		ResultSet rsa=statementa.executeQuery(sql);
		int cnt =0;
		while (rsa.next())
		{
			if (cnt ==0)
			{
				out.println("<tr><td colspan='12'>");
				out.println("<table width='100%' border='1' align='left' cellpadding='1' cellspacing='0'  bordercolorlight='#FFFFFF'  bordercolordark='#336600'>");
				out.println("<tr>");
				out.println("<td height='20' colspan='8' class='style7'>申請歷程：</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td class='style4' width='5%'>序號</td>");
				out.println("<td class='style4' width='15%'>申請版本</td>");
				out.println("<td class='style4' width='15%'>交易名稱</td>");
				out.println("<td class='style4' width='15%'>交易日期</td>");
				out.println("<td class='style4' width='15%'>交易人員</td>");
				out.println("<td class='style4' width='35%'>備註說明</td>");
				out.println("</tr>");
			}
			out.println("<tr>");
			out.println("<td class='style3'>"+(cnt+1)+"</td>");
			out.println("<td class='style3'>"+rsa.getString("version_id")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_name")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("action_date")+"</td>");
			out.println("<td class='style3'>"+rsa.getString("actor")+"</td>");
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
<%
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());	
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%
if (PROGRAMNAME.equals("F1-001"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單新增成功!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續新增下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMCreate.jsp";
	}		
	</script>
<%
}
else if (PROGRAMNAME.equals("MODIFY") && !status.toUpperCase().equals("CANCELLED"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單修改成功!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續修改下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMInformationQuery.jsp?STATUS=Reject";
	}		
	</script>
<%
}
else if (PROGRAMNAME.equals("MODIFY") && status.toUpperCase().equals("CANCELLED"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單已取消!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續異動下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMInformationQuery.jsp?STATUS=Reject";
	}		
	</script>
<%
}
else if (PROGRAMNAME.equals("CHANGE"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單變更完成!!(申請單號:"+ document.MYFORM.REQUESTNO.value+")\n\n若要繼續異動下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMInformationQuery.jsp?STATUS=Approved";
	}		
	</script>
<%
}
else if (PROGRAMNAME.equals("F1-002") && !status.toUpperCase().equals("REJECT"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單核淮成功!!(工單號碼:"+ document.MYFORM.WIPNO.value+"，請購單號:"+document.MYFORM.PRNO.value+"，採購單號:"+document.MYFORM.PONO.value+")\n\n若要繼續核淮下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMConfirmQuery.jsp";
	}	
	</script>
<%
}
else if (PROGRAMNAME.equals("F1-002") && status.toUpperCase().equals("REJECT"))
{
%>
	<script language="JavaScript" type="text/JavaScript">
	if (confirm("委外加工單已退件!!\n\n若要繼續核淮下一筆，請按確定鍵，謝謝!"))
	{
		document.location.href="../jsp/TSCPMDOEMConfirmQuery.jsp";
	}	
	</script>
<%
}

%>
</html>
