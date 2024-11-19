<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setQuery()
{ 
	if (event.keyCode==13)
	{
		if (document.MYFORM.ORGCODE.value==null || document.MYFORM.ORGCODE.value =="" || document.MYFORM.ORGCODE.value =="--")
		{
			alert("Please choose a ORG code!");
			document.MYFORM.ORGCODE.focus();
			return false;
		}
		if (document.MYFORM.INVOICE_NO.value==null || document.MYFORM.INVOICE_NO.value =="")
		{
			alert("Please enter a invoice number!");
			document.MYFORM.INVOICE_NO.focus();
			return false;
		}
		document.MYFORM.submit();
	}
}
function setExit(URL)
{
	if (confirm("Are you sure to exit?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();	
	}
}
function setSubmit(URL)
{ 
	var chk_cnt =0;
	if (document.MYFORM.ORGCODE.value==null || document.MYFORM.ORGCODE.value =="" || document.MYFORM.ORGCODE.value =="--")
	{
		alert("Please choose a ORG code!");
		document.MYFORM.ORGCODE.focus();
		return false;
	}	
	if (document.MYFORM.INVOICE_NO.value==null || document.MYFORM.INVOICE_NO.value =="")
	{
		alert("Please enter a invoice number!");
		document.MYFORM.INVOICE_NO.focus();
		return false;
	}
	if (document.MYFORM.RECEIVE_DATE.value==null || document.MYFORM.RECEIVE_DATE.value =="")
	{
		alert("Please enter a Acceptance date!");
		document.MYFORM.RECEIVE_DATE.focus();
		return false;
	}	
	else if (eval(document.MYFORM.RECEIVE_DATE.value)> eval(document.MYFORM.SYSDATE.value))
	{
		alert("Acceptance date cannot be a future date!");
		document.MYFORM.RECEIVE_DATE.focus();
		return false;
	}
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].checked)
			{
				if ((document.MYFORM.elements["INVOICE_"+document.MYFORM.chk[i].value].value).substring(1,10)!=document.MYFORM.INVOICE_NO.value.substring(1,10))
				{
					alert("invoice number is not vaild!");
					return false;
				}
				if (document.MYFORM.elements["LOT_"+document.MYFORM.chk[i].value].value==null || document.MYFORM.elements["LOT_"+document.MYFORM.chk[i].value].value=="")
				{
					alert("lot number can not empty!");
					document.MYFORM.elements["LOT_"+document.MYFORM.chk[i].value].focus();
					return false;
				}
				if (document.MYFORM.elements["DC_"+document.MYFORM.chk[i].value].value==null || document.MYFORM.elements["DC_"+document.MYFORM.chk[i].value].value=="")
				{
					alert("date code can not empty!");
					document.MYFORM.elements["DC_"+document.MYFORM.chk[i].value].focus();
					return false;
				}
				chk_cnt ++;
			}
		}
	}
	else
	{
		chk_cnt ++;
		if ((document.MYFORM.elements["INVOICE_"+document.MYFORM.chk.value].value).substring(1,10)!=document.MYFORM.INVOICE_NO.value.substring(1,10))
		{
			alert("invoice number is not vaild!!");
			return false;
		}
	}
		
	if (chk_cnt ==0)
	{	
		alert("No data found!");
		return false;
	}
	document.MYFORM.btnSave.disabled =true;
	document.MYFORM.btnCancel.disabled =true;
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function onCheck(v_id)
{
	if (document.MYFORM.chk[v_id-1].checked)
	{
		document.MYFORM.chk[v_id-1].checked=false;
		document.getElementById(v_id).style.backgroundColor ="#FFFFFF";
	}
	else
	{
		document.MYFORM.chk[v_id-1].checked=true;
		document.getElementById(v_id).style.backgroundColor ="#CCFF66";
	}
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
  .style1  {font-family:Tahoma,Georgia;font-size:12px; color:#000000;vertical-align:middle}  
  .style2  {font-family:Tahoma,Georgia;font-size:12px; color:#000000;text-align:right;vertical-align:middle}  
</STYLE>
<title>SG ToTW Purchase</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSCSGTOTWPOReceive.jsp" METHOD="POST"> 
<%
String INVOICE_NO = request.getParameter("INVOICE_NO");
if (INVOICE_NO==null) INVOICE_NO="";
String RECEIVE_DATE = request.getParameter("RECEIVE_DATE");
if (RECEIVE_DATE==null) RECEIVE_DATE=dateBean.getYearMonthDay();
String ORGCODE= request.getParameter("ORGCODE");  
if (ORGCODE==null)
{
	if (UserRoles.equals("admin") || (!UserName.toUpperCase().equals("JENNY_LIAO") && !UserName.toUpperCase().equals("JUDY_CHO") && !UserName.toUpperCase().equals("REBECCA_YEH"))) 
	{
		ORGCODE="49";
	}
	else if (UserRoles.equals("admin") || UserName.toUpperCase().equals("JENNY_LIAO") || UserName.toUpperCase().equals("JUDY_CHO") || UserName.toUpperCase().equals("REBECCA_YEH")) 
	{ 
		ORGCODE="566";
	}
}
String sql ="",stock_name="",tot_qty="";
int icnt=0,no_price_cnt=0;

try
{
%>
<table cellSpacing="0" cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border="0">
	<tr>
		<td align="center" bgcolor="#D3E6F3";><strong><font style="font-size:20px;color:#006666">Purchase Order Acceptance</font></strong></td>
	</tr>
	<td style="border-color:#D3E6F3;background-color:#D3E6F3;border-top-width:0">&nbsp;</td></TR>
	<tr>
		<td>
			<table border="1" cellpadding="1" cellspacing="1" borderColorLight="#D3E6F3"  bordercolordark="#D3E6F3" width="100%">
				<tr style="background-color:#D3E6F3;border-top-width:0">
					<td width="8%" class="style1">Org Code:</td>   
					<td width="7%"><select NAME="ORGCODE" class="style1">
					<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
					<%
					if (UserRoles.equals("admin") || (!UserName.toUpperCase().equals("JENNY_LIAO") && !UserName.toUpperCase().equals("JUDY_CHO") && !UserName.toUpperCase().equals("REBECCA_YEH"))) 
					{ 
					%>
					<OPTION VALUE="49" <%if (ORGCODE.equals("49")) out.println("selected");%>>I1</OPTION>
					<%
					}
					if (UserRoles.equals("admin") || UserName.toUpperCase().equals("JENNY_LIAO") || UserName.toUpperCase().equals("JUDY_CHO") || UserName.toUpperCase().equals("REBECCA_YEH")) 
					{ 
					%>
					<OPTION VALUE="566" <%if (ORGCODE.equals("566")) out.println("selected");%>>I20</OPTION>
					<%
					}
					%>
					</select>				
					<td width="10%"  class="style1">Invoice No：</td>
				  <td width="35%">
			        <input type="text" name="INVOICE_NO" value="<%=INVOICE_NO%>" class="style1" size="20" onKeyPress="setQuery()">
				   (Please click Enter button when enter invoice no after)</td>
					<td width="10%"  class="style1">Receive Date：</td>
				    <td width="10%"><input type="text" name="RECEIVE_DATE" value="<%=RECEIVE_DATE%>" class="style1" size="8"><A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.RECEIVE_DATE);return false;"><img src="../image/calbtn.gif" name="IMG1" border="0" style="vertical-align:middle"></A></td>
					<td width="35%" align="right"><A href="TSCSGTOTWPOReceiveQuery.jsp"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgFunction"/></A></td>
				</tr>
			</table>
		</td>
	</tr>
	<%
	
	if (!INVOICE_NO.equals(""))
	{			
		sql = " select x.* "+
		      " from ("+
			  "      select tsil.invoice_no invoice_no"+
			  "      ,a.tew_advise_no"+
			  "      ,a.advise_header_id"+
			  "      ,a.advise_line_id"+
			  "      ,a.carton_no"+
			  "      ,a.so_no"+
			  "      ,d.so_line_number"+
			  "      ,a.so_header_id"+
			  "      ,a.so_line_id"+
			  "      ,a.inventory_item_id"+
			  "      ,a.item_no"+
			  "      ,d.item_desc"+
			  "      ,a.lot"+
			  "      ,a.receipt_num"+
			  "      ,i.organization_id"+
			  "      ,i.organization_code"+
			  "      ,a.date_code"+
			  "      ,a.qty qty"+
			  "      ,d.product_group"+
			  "      ,nvl(tsil.unit_selling_price,0)/1000 unit_price"+
			  "      ,tsc_inv_category(d.inventory_item_id,43,1100000003) tsc_prod_group"+
			  "      ,nvl(ar.customer_name_phonetic,ar.customer_name) customer_name"+
			  "      ,sum(a.qty) over (partition by  c.delivery_name) tot_qty"+
			  "      ,a.dc_yyww"+ //add by Peggy 20220726
			  "      from tsc.tsc_pick_confirm_lines a "+
			  "      ,tsc.tsc_shipping_advise_headers b"+
			  "      ,tsc.tsc_advise_dn_line_int c"+
 			  "      ,tsc.tsc_shipping_advise_lines d"+
 			  "      ,tsc.tsc_pick_confirm_headers h"+
			  "      ,mtl_parameters i"+
			  "      ,tsc_sg_invoice_lines tsil"+
			  "      ,(select order_number,header_id,sold_to_org_id from ont.oe_order_headers_all where org_id=41) orh"+
			  "      ,ar_customers ar"+
			  "      ,tsc.tsc_advise_dn_header_int k"+
			  "      where nvl(b.to_tw,'N')=? "+
			  "      and b.shipping_from LIKE ?||'%'"+
			  //"      and c.delivery_name LIKE ?||'%'"+
			  "      and tsil.invoice_no=?"+ //modify by Peggy 20200617
			  "      and substr(a.so_no,1,4) in (case when ?=566 then '1121' else '1131' end ,case when ?=566 then '1121' else '1141' end,case when ?=566 then '1121' else '1214' end)"+  
			  "      and a.advise_line_id = c.advise_line_id"+
			  "      and a.advise_line_id=d.advise_line_id"+
			  "      and a.advise_header_id=b.advise_header_id"+
			  "      and a.advise_header_id=h.advise_header_id"+
			  "      and i.organization_id=case substr(a.so_no,1,4) when '1121' then  566 else 49 end"+ 
			  "      and a.so_line_id=tsil.order_line_id(+)"+
			  "      and d.so_no=orh.order_number"+
			  "      and orh.sold_to_org_id=ar.customer_id"+
			  "      and c.advise_header_id=k.advise_header_id"+
              "      and c.interface_header_id=k.interface_header_id"+
              "      and c.batch_id=k.batch_id"+
              "      and k.status='S'"+
			  //"      group by c.invoice_no,a.tew_advise_no,a.advise_header_id, a.advise_line_id, a.carton_no,"+
			  //"      a.so_no, d.so_line_number,a.so_header_id, a.so_line_id,"+
			  //"      a.inventory_item_id, a.item_no,d.item_desc, a.lot,"+
			  //"      a.date_code,a.organization_id,i.organization_code"+
			  "      ) x"+
			  " where not exists (select 1 from oraddman.tssg_po_receive_tw k where k.INVOICE_NO=x.invoice_no AND k.organization_id=x.organization_id)"+
			  " order by to_number(x.carton_no),x.so_no,x.so_line_id,x.lot";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"Y");
		statement.setString(2,"SG");
		statement.setString(3,INVOICE_NO);
		statement.setString(4,ORGCODE);
		statement.setString(5,ORGCODE);
		statement.setString(6,ORGCODE);
		ResultSet rs=statement.executeQuery();
		while (rs.next())
		{	
			if (icnt==0)
			{
				tot_qty=rs.getString("tot_qty");
			%>
		<tr>
			<td>
				<table width="100%" border="1" cellpadding="1" cellspacing="1" borderColorLight="#DAD6D9"  bordercolordark="#DAD6D9" >
					<tr bgcolor="#CCCCCC">	
						<td>Invoice No </td>
						<td>Carton No</td>
						<td>客戶</td>
						<td>MO#</td>
						<td>MO Line#</td>
						<td>Item Name</td>
						<td>Item Desc</td>
						<td>Lot</td>
						<td>Date Code</td>
						<td>DC YYWW</td>
						<td>Qty(PCS)</td>
						<td align="center">ORG</td>
						<td align="center">Subinventory</td>
						<td>TSC Prod Group</td>
					</tr>
			<%
			}
			if (rs.getString("organization_id").equals("566"))
			{
				stock_name="40";
			}
			else
			{
				if (rs.getString("product_group").equals("SSD"))
				{
					stock_name="11";
				}
				else
				{
					stock_name="13";
				}
			}
			icnt++;
			out.println("<tr>");
			out.println("<td>"+rs.getString("INVOICE_NO")+"</td>");
			out.println("<td>"+rs.getString("CARTON_NO")+"<input type='checkbox'  name='chk' value='"+icnt+"' style='visibility:hidden' checked><input type='hidden' name='ADVISE_LINE_ID_"+icnt+"' value='"+rs.getString("advise_line_id")+"'><input type='hidden' name='INVOICE_"+icnt+"' value='"+rs.getString("invoice_no")+"'><input type='hidden' name='CARTON_"+icnt+"' value='"+rs.getString("CARTON_NO")+"'></td>");
			out.println("<td>"+rs.getString("CUSTOMER_NAME")+"</td>");
			out.println("<td>"+rs.getString("SO_NO")+"</td>");
			out.println("<td>"+rs.getString("SO_LINE_NUMBER")+"</td>");
			out.println("<td>"+rs.getString("ITEM_NO")+"</td>");
			out.println("<td>"+rs.getString("ITEM_DESC")+"</td>");
 			out.println("<td><INPUT TYPE='text' name='LOT_"+icnt+"' value='"+rs.getString("LOT")+"' size='18' class='style1'><INPUT TYPE='hidden' name='SG_LOT_"+icnt+"' value='"+rs.getString("LOT")+"' size='13' class='style1'></td>");
			out.println("<td><INPUT TYPE='text' name='DC_"+icnt+"' value='"+(rs.getString("DATE_CODE")==null?"":rs.getString("DATE_CODE"))+"' size='10' class='style1'><INPUT TYPE='hidden' name='SG_DC_"+icnt+"' value='"+rs.getString("DATE_CODE")+"' size='10' class='style1'></td>");
			out.println("<td><INPUT TYPE='text' name='DC_YYWW_"+icnt+"' value='"+(rs.getString("DC_YYWW")==null?"":rs.getString("DC_YYWW"))+"' size='10' class='style1'><INPUT TYPE='hidden' name='SG_DC_YYWW_"+icnt+"' value='"+rs.getString("DC_YYWW")+"' size='10' class='style1'></td>");
			out.println("<td align='right'>"+rs.getString("QTY")+"<input type='hidden' name='QTY_"+icnt+"' value='"+rs.getString("QTY")+"'><input type='hidden' name='SG_QTY_"+icnt+"' value='"+rs.getString("QTY")+"'></td>");
			out.println("<td>"+rs.getString("organization_code")+"</td>");  
			out.println("<td align='center'><INPUT TYPE='text' name='STOCK_"+icnt+"' value='"+stock_name+"' size='7'  class='style1'></td>");
			out.println("<td>"+rs.getString("tsc_prod_group")+"</td>");  
			out.println("</tr>");
			if (rs.getString("unit_price").equals("0")) no_price_cnt++;
			icnt++;
		}
				 
		if (icnt>0)
		{
		%>
					<tr>
						<td colspan="10" align="right" style="border-right-style:none">合計:</td>
						<td align="right" style="border-left-style:none;border-right-style:none"><%=tot_qty%></td>
						<td colspan="3" style="border-left-style:none;">&nbsp;</td>						
					</tr>
				</table>
			</td>	
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center"><input type="button" name="btnSave" value="Acceptance Confirm" style="font-family:Tahoma,Georgia" onClick="setSubmit('../jsp/TSCSGTOTWPOReceiveProcess.jsp')" <%=(no_price_cnt>0?"disabled":"")%>>
			&nbsp;&nbsp;<input type="button" name="btnCancel" value="Cancel" style="font-family:Tahoma,Georgia" onClick="setExit('../jsp/TSCSGTOTWPOReceiveQuery.jsp')"></td>
		</tr>
		<%
			if (no_price_cnt>0)
			{
			%>
		<tr>
			<td rowspan="2" align="center" style="color:#ff0000">Not Found Invoice Data!</td>
		</tr>
			<%
			}
		}
		else
		{
		%>
		<tr>
			<td style="color:#ff0000" align="center">No Data Found!!</td>
		</tr>
		<%
		}
		rs.close();
		statement.close();	
	}
}
catch(Exception e)
{
	out.println("exception:"+e.getMessage());
}
	%>
</table>
<input type="hidden" name="SYSDATE" VALUE="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
