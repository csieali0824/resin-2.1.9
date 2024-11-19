<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String SEARCHSTR = request.getParameter("SEARCHSTR");
if (SEARCHSTR==null) SEARCHSTR="";
String ID  =request.getParameter("ID");
if (ID==null) ID="";
String ITEMID = request.getParameter("ITEMID");
if (ITEMID==null || ITEMID.equals("--")) ITEMID="0";
%>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEW PO List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(VENDOR,VENDOR_SITE_ID,LINE_LOCATION_ID,PONO,PRICE,LINEID)
{
	window.opener.document.getElementById("VENDOR_"+LINEID).innerHTML = VENDOR;
	window.opener.document.MYFORM.elements["VENDOR_SITE_ID_"+LINEID].value = VENDOR_SITE_ID;
	window.opener.document.MYFORM.elements["LINE_LOCATION_ID_"+LINEID].value = LINE_LOCATION_ID;
	window.opener.document.MYFORM.elements["PONO_"+LINEID].value = PONO;
	window.opener.document.getElementById("PO_PRICE_"+LINEID).innerHTML = PRICE;
	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TEWPOListFind.jsp" NAME="SUBFORM">
<table>
	<tr>
		<td>
			<table>
				<tr>
					<td style="font-family:arial;font-size:12px">PO NO:</td>
					<td><input type="text" name="SEARCHSTR" style="font-family:arial" value="<%=SEARCHSTR%>"></td>
					<td><input type="submit" name="submit" value="Query" style="font-family:arial"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<%     
				try
				{ 
					sql = " SELECT c.vendor_site_code,"+
                          " a.segment1 pono,"+
                          " b.line_location_id,"+
                          " b.price_override,"+
                          " a.vendor_site_id,"+
                          " d.line_num,"+
						  " d.item_description,"+
                          " (f.onhand*1000) QUANTITY,"+
						  //" e.buyer,"+
						  " g.order_number,"+
						  " g.line_number||'.'||g.shipment_number line_no,"+
						  " g.CUSTOMER_NAME_PHONETIC customer_name,"+
						  " DECODE(g.ITEM_IDENTIFIER_TYPE,'CUST',g.ORDERED_ITEM,'') CUST_ITEM,"+
						  " to_char(b.need_by_date,'yyyy-mm-dd') need_by_date"+
                          " FROM po.po_headers_all a,"+
                          " po.po_line_locations_all b,"+
                          " ap.ap_supplier_sites_all c ,"+
                          " po.po_lines_all d,"+
						  //" (select e.* from (select e.PERSON_ID,e.last_name || e.first_name buyer,EFFECTIVE_START_DATE,row_number() over (partition by e.PERSON_ID order by EFFECTIVE_START_DATE desc) row_num from per_all_people_f e) e where row_num=1) e,"+						  
						  " (select y.PO_LINE_LOCATION_ID,sum(nvl(RECEIVED_QUANTITY,0)-nvl(SHIPPED_QUANTITY,0)) onhand from oraddman.tewpo_receive_detail x,oraddman.tewpo_receive_header y where x.po_line_location_id=y.po_line_location_id and y.inventory_item_id=? group by y.PO_LINE_LOCATION_ID) >0) f,"+
		 				  " (SELECT ooha.SOLD_TO_ORG_ID CUSTOMER_ID,ooha.ORDER_NUMBER , RA.CUSTOMER_NAME_PHONETIC ,ooha.ORDER_NUMBER ||'.'|| oolla.LINE_NUMBER order_line,oolla.* from ONT.OE_ORDER_HEADERS_ALL ooha,"+
                          " ONT.OE_ORDER_LINES_ALL oolla,AR_CUSTOMERS ra"+
                          " where ooha.HEADER_ID = oolla.HEADER_ID"+
						  " and ooha.SOLD_TO_ORG_ID = ra.CUSTOMER_ID"+
					      " AND oolla.PACKING_INSTRUCTIONS=?"+
						  " and oolla.INVENTORY_ITEM_ID=?) g"+
                          " where  a.po_header_id =d.po_header_id "+
                          " and d.po_header_id = b.po_header_id"+
                          " and d.po_line_id = b.po_line_id "+
                          " and a.vendor_site_id = c.vendor_site_id"+
						  //" and a.agent_id = e.person_id"+
						  " and b.line_location_id = f.po_line_location_id"+ 
						  " AND b.note_to_receiver = g.order_line(+)"+
						  " and a.segment1 like ?"+
						  " order by a.segment1 desc";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,ITEMID);
					statement.setString(2,"E");
					statement.setString(3,ITEMID);
					statement.setString(4,SEARCHSTR+"%");
					ResultSet rs=statement.executeQuery();
					int vline=0;
					while (rs.next())
					{
						vline++;
						if (vline==1)
						{
							out.println("<div id='div1' style='font-size:12px'>品    名："+rs.getString("item_description")+"</div>");
							out.println("<div id='div2' style='font-size:12px'>數量單位：PCE</div>");
							out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#ffffff'>");      
							out.println("<TR bgcolor='#cccccc'>");
							out.println("<Td>&nbsp;</Td>");        
							out.println("<Td>供應商</Td>");
							out.println("<Td>採購單號</Td>");
							out.println("<Td>採購單項次</Td>");
							out.println("<Td>需求日期</Td>");
							//out.println("<Td>品名</Td>");
							out.println("<Td>收貨數量<br>(PCE)</Td>");
							out.println("<Td>出貨數量<br>(PCE)</Td>");
							out.println("<Td>已分配未出量<br>(PCE)</Td>");
							out.println("<Td>可用庫存量<br>(PCE)</Td>");
							out.println("<Td>單價</Td>");
							out.println("<Td>客戶名稱</Td>");
							out.println("<Td>客戶品號</Td>");
							out.println("<Td>訂單號碼</Td>");
							out.println("<Td>訂單項次</Td>");
							//out.println("<Td>採購人員</Td>");
							out.println("</TR>");
						}
						out.println("<TR id='tr_"+vline+"'>");
						out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick=setSubmit('"+rs.getString("vendor_site_code")+"','"+ rs.getString("vendor_site_id")+"','"+ rs.getString("line_location_id")+"','"+ rs.getString("pono")+"','"+ rs.getString("price_override")+"','"+ID+"');></TD>");
						out.println("<TD>"+ rs.getString("vendor_site_code")+"</TD>");
						out.println("<TD>"+ rs.getString("pono")+"</TD>");
						out.println("<TD>"+ rs.getString("line_num")+"</TD>");
						out.println("<TD>"+ rs.getString("need_by_date")+"</TD>");
						//out.println("<TD>"+ rs.getString("item_description")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("RECEIVED_QUANTITY")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("SHIPPED_QUANTITY")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("ALLOT_QTY")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("USEFUL_QTY")+"</TD>");
						out.println("<TD align='right'>"+ rs.getString("price_override")+"</TD>");
						out.println("<TD>"+ (rs.getString("customer_name")==null?"&nbsp;":rs.getString("customer_name"))+"</TD>");
						out.println("<TD>"+ (rs.getString("CUST_ITEM")==null?"&nbsp;":rs.getString("CUST_ITEM"))+"</TD>");
						out.println("<TD>"+ (rs.getString("order_number")==null?"&nbsp;":rs.getString("order_number"))+"</TD>");
						out.println("<TD>"+ (rs.getString("line_no")==null?"&nbsp;":rs.getString("line_no"))+"</TD>");
						//out.println("<TD>"+ rs.getString("buyer")+"</TD>");
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();  
					statement.close();     
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
<INPUT TYPE="hidden" name="ITEMID" value="<%=ITEMID%>">
<INPUT TYPE="hidden" name="ID" value="<%=ID%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
