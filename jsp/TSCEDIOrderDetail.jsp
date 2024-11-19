<!--20150817 by Peggy,改為欄位名稱改為英文-->
<!--20181222 by Peggy,新增original customer part no-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>Order Change Confirm</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8}
  .style2   {font-family:Tahoma,Georgia;border:none}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:12px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
</script>
<%
	String REQUESTNO = request.getParameter("REQUESTNO");
	if (REQUESTNO==null) REQUESTNO="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID==null) ERPCUSTOMERID="";
	String sql = "";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCEDIDetailQuery.jsp" METHOD="post" NAME="MYFORM">
<HR>
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr>
					<td><font style="color:#8F996C">Request No:<%=REQUESTNO%></font></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bordercolor="#336699">
				<tr bgcolor='#336699' style="color:#ffffff">
					<td align="center" width="7%">PO Line</td>
					<td align="center" width="9%">Cus P/N</td>
					<td align="center" width="9%">Orig Cus P/N</td>
					<td align="center" width="11%">TSC PN</td>
					<td align="center" width="11%">Orig TSC PN</td>
					<td align="center" width="6%">QTY</td>
					<td align="center" width="5%">UOM</td>
					<td align="center" width="7%">Selling Price</td>
					<td align="center" width="6%">CRD</td>
					<td align="center" width="6%">Order type</td>
					<td align="center" width="12%">RFQ No</td>
					<td align="center" width="5%">RFQ Line</td>
					<td align="center" width="6%">RFQ Qty</td>
					<td align="center" width="8%">Remark</td>
					<td align="center" width="8%">Quote Number</td>
				</tr>
			<%
				sql = " SELECT a.request_no, a.erp_customer_id,  a.cust_po_line_no,"+
                      " a.cust_item_name, a.tsc_item_name, a.quantity, a.uom,"+
                      " a.unit_price, a.cust_request_date, a.creation_date,"+
                      " a.ACTION_CODE, a.rfq_qty, a.dndocno, a.line_no, a.remark "+
					  ",(select count(1) from tsc_edi_orders_his_d b where b.REQUEST_NO=a.REQUEST_NO and b.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID and b.cust_po_line_no=a.cust_po_line_no) row_cnt"+
					  ",a.quote_number,a.orig_cust_item_name,a.orig_tsc_item_name"+//add by Peggy 20140423,add by Peggy 20181222
                      " FROM tsc_edi_orders_his_d a"+
                      " WHERE REQUEST_NO=?"+
                      " AND ERP_CUSTOMER_ID=?"+
                      " order by to_number(CUST_PO_LINE_NO)";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,REQUESTNO);
				statement.setString(2,ERPCUSTOMERID);
				ResultSet rs=statement.executeQuery();
				String cust_po_line_no ="";
				while (rs.next())
				{
					out.println("<tr>");
					if (!cust_po_line_no.equals(rs.getString("cust_po_line_no")))
					{
						out.println("<td align='left' rowspan='"+rs.getString("row_cnt")+"'>"+rs.getString("cust_po_line_no")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("row_cnt")+"'>"+rs.getString("cust_item_name")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("row_cnt")+"'>"+rs.getString("orig_cust_item_name")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("row_cnt")+"'>"+rs.getString("tsc_item_name")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("row_cnt")+"'>"+rs.getString("orig_tsc_item_name")+"</td>");
						cust_po_line_no=rs.getString("cust_po_line_no");
					}
					out.println("<td align='right'>"+rs.getString("quantity")+"</td>");
					out.println("<td align='center'>"+rs.getString("uom")+"</td>");
					out.println("<td align='right'>"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("unit_price")))+"</td>");
					out.println("<td align='center'>"+rs.getString("cust_request_date")+"</td>");
					if (rs.getString("ACTION_CODE").equals("1"))
					{
						out.println("<td align='center'><font color='blue'>Add</font></td>");
					}
					else if (rs.getString("ACTION_CODE").equals("2"))
					{
						out.println("<td align='center'><font color='red'>Cancel</font></td>");
					}
					else if (rs.getString("ACTION_CODE").equals("3"))
					{
						out.println("<td align='center'><font color='orange'>Change</font></td>");
					}
					out.println("<td align='center'>"+(rs.getString("dndocno")==null?"&nbsp;":rs.getString("dndocno"))+"</td>");
					out.println("<td align='center'>"+(rs.getString("line_no")==null?"&nbsp;":rs.getString("line_no"))+"</td>");
					out.println("<td align='right'>"+(rs.getString("rfq_qty")==null || rs.getString("rfq_qty").equals("0")?"&nbsp;":rs.getString("rfq_qty"))+"</td>");
					out.println("<td align='left'>"+(rs.getString("remark")==null?"&nbsp;":rs.getString("remark"))+"</td>");
					out.println("<td align='left'>"+(rs.getString("quote_number")==null?"&nbsp;":rs.getString("quote_number"))+"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();	  
					  
			%>
			</table>
		</td>
	</tr>
</table>
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
