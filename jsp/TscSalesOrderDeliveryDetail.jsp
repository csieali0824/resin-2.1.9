<!--20160718 Peggy,排除TSCH ORDER-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,jxl.*,jxl.write.*,jxl.format.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>

<html>
<head>
<title>Order Detail Information</title>
</head>
<body>
<FORM ACTION="../jsp/TscSalesOrderDeliveryDetail.jsp" METHOD="post" NAME="MYFORM">
<div align="right"><a href="JavaScript:self.close()">Closed Windows</A></div>
<% 
String SYM=request.getParameter("SYM");
if (SYM == null) SYM = "";
String EYM=request.getParameter("EYM");
if (EYM == null) EYM = "";
String ITEM =request.getParameter("ITEM");
if (ITEM == null) ITEM = "";
String CUST=request.getParameter("CUST");
if (CUST == null) CUST = "";
String KIND=request.getParameter("KIND");
if (KIND == null) KIND = "";
String ENDCUST = request.getParameter("ENDCUST");
if (ENDCUST==null || ENDCUST.toLowerCase().equals("null")) ENDCUST = "";
float tt_unship_qty = 0;
float tt_shipped_qty = 0;
int rowcnt =0;
if (SYM.equals("") || EYM.equals(""))
{
%>
	<script language="JavaScript">
	alert('Date value is invalid!');
	return;
	</script>	
<%
}

if (ITEM.equals(""))
{
%>
	<script language="JavaScript">
	alert('Item value is invalid!');
	return;
	</script>
<%
}

if (CUST.equals(""))
{
%>
	<script language="JavaScript">
	alert('Customer value is invalid!');
	return;
	</script>
<%
}

if (KIND.equals(""))
{
%>
	<script language="JavaScript">
	alert('KIND value is invalid!');
	return;
	</script>
<%
}

try
{   
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	

	String sql = " SELECT '(' || d.account_number || ')' || e.party_name customer_name,a.order_number, c.segment1 item_name, c.description item_desc,"+
                 " nvl(to_char(nvl(b.schedule_ship_date,''),'yyyy-mm-dd'),'') schedule_ship_date, "+
				 " nvl(to_char(nvl(b.actual_shipment_date,''),'yyyy-mm-dd'),'') actual_shipment_date,"+
				 " CASE b.order_quantity_uom WHEN 'PCE' THEN 'KPC' ELSE b.order_quantity_uom END AS item_uom,"+
                 " CASE b.order_quantity_uom WHEN 'PCE' THEN NVL (b.ordered_quantity, 0) / 1000 ELSE NVL (b.ordered_quantity, 0)  END AS ordered_quantity,"+
                 " CASE b.order_quantity_uom WHEN 'PCE' THEN NVL (b.shipped_quantity, 0) / 1000 ELSE NVL (b.shipped_quantity, 0)  END AS shipped_quantity"+
                 " FROM ont.oe_order_headers_all a,ont.oe_order_lines_all b,inv.mtl_system_items_b c,hz_cust_accounts d,hz_parties e"+
                 " WHERE a.header_id = b.header_id AND b.inventory_item_id = c.inventory_item_id AND b.ship_from_org_id = c.organization_id"+
                 " AND a.sold_to_org_id = d.cust_account_id AND d.party_id = e.party_id "+
		  		 //" AND TO_CHAR (NVL (b.actual_shipment_date, b.schedule_ship_date), 'yyyy-mm') BETWEEN '"+SYM+"' AND '"+ EYM +"'"+
		         " AND nvl(b.actual_shipment_date,b.schedule_ship_date) between to_date('"+ SYM +"','yyyy-mm') and add_months(to_date('"+ EYM +"','yyyy-mm'),1)-1+0.99999"+
                 " AND (b.schedule_ship_date IS NOT NULL OR b.actual_shipment_date IS NOT NULL)"+
				 " AND a.org_id in (41,325)"+ //add by Peggy 20160718
                 " AND d.account_number = "+ CUST+""+
                 " AND c.segment1 = '"+ ITEM +"'";
	if (!ENDCUST.equals("")) sql += " AND exists (select 1 from  fnd_attached_docs_form_vl fadfv where fadfv.function_name = 'OEXOEORD'"+
                                   " AND fadfv.category_description = 'SHIPPING MARKS' AND fadfv.user_entity_name = 'OM Order Header'"+
				                   " AND fadfv.pk1_value= A.HEADER_ID AND fadfv.document_description ='"+ENDCUST+"')";
	if (KIND.equals("0")) sql += " AND b.actual_shipment_date IS NULL";
	if (KIND.equals("1")) sql += " AND b.actual_shipment_date IS NOT NULL";
	sql += " order by nvl(b.actual_shipment_date,b.schedule_ship_date)";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);	
	while (rs.next())
   	{ 
		if (rowcnt ==0)
		{
			out.println("<font face='Book Antiqua'>Customer Name："+rs.getString("customer_name")+"</font><br>");
			out.println("<font face='Book Antiqua'>Item Name："+rs.getString("item_name")+"</font><br>");
			out.println("<font face='Book Antiqua'>Item Description："+rs.getString("item_desc")+"</font><br>");
			out.println("<font face='Book Antiqua'>UOM："+rs.getString("item_uom")+"</font><br>");
			out.println("<font face='Book Antiqua'>Date Period："+ SYM + " ~ " + EYM+"</font><br>");
			out.println("<font face='Book Antiqua'>End Customer："+ ENDCUST+"</font><br>");
			out.println("<font face='Book Antiqua'>");
			out.println("<table cellspacing='0' bordercolordark='#6699CC' cellpadding='1' width='100%' align='center' bordercolorlight='#ffffff' border='1'>");
			out.println("<TR BGCOLOR='#000088'>");
			out.println("<td NOWRAP width='10%'><FONT  COLOR='#EEEEEE'>Order Number</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT  COLOR='#EEEEEE'>Schedule Ship Date</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT  COLOR='#EEEEEE'>Actual Shipment Date</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT  COLOR='#EEEEEE'>Ordered Qty</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT  COLOR='#EEEEEE'>Shipped Qty</FONT></td>");
			out.println("</TR>");
		}
		out.println("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
	   	out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("order_number")+"</FONT></TD>");
	   	out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("schedule_ship_date")+"</FONT></TD>");
		if (rs.getString("actual_shipment_date")==null)
		{
	   		out.println("<TD NOWRAP><FONT SIZE=2>&nbsp;</FONT></TD>");
		}
		else
		{
	   		out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("actual_shipment_date")+"</FONT></TD>");
		}
	   	out.println("<TD NOWRAP><div align='right'><FONT SIZE=2>"+(new DecimalFormat("#,##0.###")).format(rs.getFloat("ordered_quantity"))+"</FONT></div></TD>");
	   	out.println("<TD NOWRAP><div align='right'><FONT SIZE=2>"+(new DecimalFormat("#,##0.###")).format(rs.getFloat("shipped_quantity"))+"</FONT></div></TD>");
    	out.println("</TR>");
		tt_unship_qty += rs.getFloat("ordered_quantity");
		tt_shipped_qty += rs.getFloat("shipped_quantity");
		rowcnt ++;
	}
	if (rowcnt >0)
	{
		out.println("<TR>");
		out.println("<TD colspan=3>Total:</TD>");
		out.println("<TD NOWRAP><div align='right'><FONT SIZE=2>"+(new DecimalFormat("#,##0.###")).format(tt_unship_qty)+"</FONT></div></TD>");
		out.println("<TD NOWRAP><div align='right'><FONT SIZE=2>"+(new DecimalFormat("#,##0.###")).format(tt_shipped_qty)+"</FONT></div></TD>");
		out.println("</TR>");
		out.println("</TABLE>");
		out.println("</font>");
	}
	else
	{
		out.println("<font color='red'>No Data Found!!</font>");
	}
	rs.close();   
   	statement.close();

	sql1="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
	pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
} 
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>

</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

