<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>

<html>
<head>
<title>Order Detail Information</title>
</head>
<body>
<FORM ACTION="../jsp/TSCPMDQuotationHistory.jsp" METHOD="post" NAME="MYFORM">
<% 
String ITEMID=request.getParameter("ITEMID");
if (ITEMID== null) ITEMID = "";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME== null) ITEMNAME = "";
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC== null) ITEMDESC = "";
String PROGRAMNAME = request.getParameter("PROGRAMNAME");
if (PROGRAMNAME==null) PROGRAMNAME="";
String VENDOR =request.getParameter("VENDOR");
if (VENDOR ==null) VENDOR="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO == null) REQUESTNO="";
String QTY = request.getParameter("QTY");
if (QTY == null) QTY="";
String STARTQTY = request.getParameter("STARTQTY");
if (STARTQTY == null) STARTQTY="";
String ENDQTY = request.getParameter("ENDQTY");
if (ENDQTY == null) ENDQTY="";
String VENDORSITEID =request.getParameter("VENDORSITEID");
if (VENDORSITEID ==null) VENDORSITEID="";
String V_REQUESTNO="";
int rowcnt=0,reqcnt=0;
String fontstyle = "";
String bgcolor = "";
boolean choose = false;
if (ITEMID.equals(""))
{
%>
	<script language="JavaScript">
	alert('Please choose the item!');
	this.window.close();
	</script>	
<%
}
try
{   
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	
	out.println("<table width='100%'>");
	out.println("<tr><td width='100%' colspan='2'><font face='Book Antiqua'>Item Name：</font><font style='font-family:Book Antiqua;text-decoration:underlineface'>"+ITEMNAME+"</font></td></tr>");
	out.println("<tr><td width='50%'><font face='Book Antiqua'>Description：</font><font style='font-family:Book Antiqua;text-decoration:underlineface'>"+ITEMDESC+"</font></td>");
	out.println("<td width='50%'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font style='text-align:right'><a href='JavaScript:self.close()'>關閉視窗</A></font></td></tr>");
	out.println("</table>");

	String sql = " select b.inventory_item_name,b.item_description,to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
	             " a.request_no,a.vendor_name,b.unit_price,b.start_date||'~'||b.end_date avail_date,b.request_reason,"+
				 " a.created_by_name,to_char(a.approve_date,'yyyy-mm-dd hh24:mi') approve_date,a.approved_by_name,a.status,"+
				 " nvl(b.start_qty,0) start_qty,nvl(b.end_qty,0) end_qty,a.currency_code,b.uom,"+
				 " nvl((select count(1) from oraddman.tspmd_quotation_lines_all c where c.request_no= a.request_no  and c.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID";
	if (!STARTQTY.equals("") && !ENDQTY.equals(""))
	{
		sql += " and ("+ STARTQTY+ " between c.start_qty and c.end_qty  or  "+ENDQTY + " between c.start_qty and c.end_qty)";
	}
	else if (!STARTQTY.equals(""))
	{
		sql += " and "+ STARTQTY+ " between c.start_qty and c.end_qty";
	}
	else if (!ENDQTY.equals(""))
	{	
		sql += " and "+ENDQTY + " between c.start_qty and c.end_qty ";
	}
	sql +=" ),0) totcnt from oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
                 " where a.request_no=b.request_no"+
                 " and b.inventory_item_id="+ITEMID+""+
				 " and a.status not in ('Cancelled','Reject')";
	if (PROGRAMNAME.equals("F1-001")) sql += " and a.vendor_code='"+VENDOR+"' and a.vendor_site_id ='"+VENDORSITEID+"'";
	if (!REQUESTNO.equals("")) sql += " and a.request_no <>'"+REQUESTNO+"'";
	//if (!STARTQTY.equals("")) sql += " and b.start_qty >='"+STARTQTY+"'";
	//if (!ENDQTY.equals("")) sql += " and b.end_qty <= '" + ENDQTY+"'";
	//if (!STARTQTY.equals("")) sql += " and "+ STARTQTY+ " between b.start_qty and b.end_qty ";
	//if (!ENDQTY.equals("")) sql += " and "+ENDQTY + " between b.start_qty and b.end_qty ";
	if (!STARTQTY.equals("") && !ENDQTY.equals(""))
	{
		sql += " and ("+ STARTQTY+ " between b.start_qty and b.end_qty or  "+ENDQTY + " between b.start_qty and b.end_qty)";
	}
	else if (!STARTQTY.equals(""))
	{
		sql += " and "+ STARTQTY+ " between b.start_qty and b.end_qty";
	}
	else if (!ENDQTY.equals(""))
	{	
		sql += " and "+ENDQTY + "  between b.start_qty and b.end_qty ";
	}	
	sql += " order by a.request_no desc,b.start_qty";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);	
	while (rs.next())
   	{ 
		if (rowcnt ==0)
		{
			out.println("<font face='Book Antiqua'><table cellspacing='0' bordercolordark='#6699CC' cellpadding='1' width='100%' align='center' bordercolorlight='#ffffff' border='1'>");
			out.println("<TR BGCOLOR='#000088'>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>供應商</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>申請單號</FONT></td>");
			out.println("<td NOWRAP width='15%'><FONT SIZE=2 COLOR='#EEEEEE'>數量起訖區間</FONT></td>");
			out.println("<td NOWRAP width='4%'><FONT SIZE=2 COLOR='#EEEEEE'>單位</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>單價</FONT></td>");
			out.println("<td NOWRAP width='10%' align='center'><FONT SIZE=2 COLOR='#EEEEEE'>幣別</FONT></td>");
			//out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>有效起訖日</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>異動原因</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>申請日期</FONT></td>");
			out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>申請人</FONT></td>");
			out.println("<td NOWRAP width='10%' align='center'><FONT SIZE=2 COLOR='#EEEEEE'>申請狀態</FONT></td>");
			//out.println("<td NOWRAP width='10%'><FONT SIZE=2 COLOR='#EEEEEE'>核淮人</FONT></td>");
			out.println("</TR>");
		}
		if (!V_REQUESTNO.equals(rs.getString("request_no")))
		{
			if (PROGRAMNAME.equals("F1-001") && reqcnt >=5) break;
			out.println("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
			out.println("<TD NOWRAP rowspan='"+rs.getString("totcnt")+"'><FONT SIZE=2>"+rs.getString("vendor_name")+"</FONT></TD>");
			out.println("<TD NOWRAP rowspan='"+rs.getString("totcnt")+"'><FONT SIZE=2>"+rs.getString("request_no")+"</FONT></TD>");
			V_REQUESTNO=rs.getString("request_no");
			reqcnt++;
		}
		fontstyle = "<FONT SIZE=2 color='#000000'>"+(new DecimalFormat("#,##0.####")).format(rs.getFloat("UNIT_PRICE"))+"</FONT>";
		bgcolor = "";
		if (!QTY.equals("") && !choose)
		{
			if (rs.getString("status").equals("Approved") && Float.parseFloat(QTY) > rs.getFloat("start_qty") && Float.parseFloat(QTY) <= rs.getFloat("end_qty"))
			{
				fontstyle = "<strong><FONT SIZE=3 color='#0000FF'>"+(new DecimalFormat("#,##0.####")).format(rs.getFloat("UNIT_PRICE"))+"</FONT></strong>";
				bgcolor = "bgcolor='#9A798E'";
				choose =true;
			}
		}
	   	out.println("<TD NOWRAP><div align='right'><FONT SIZE=2>"+(new DecimalFormat("#,##0.####")).format(rs.getFloat("start_qty"))+" ~ " + (new DecimalFormat("#,##0.####")).format(rs.getFloat("end_qty"))+"</FONT></div></TD>");
	   	out.println("<TD NOWRAP align='center'><FONT SIZE=2>"+rs.getString("uom")+"</FONT></TD>");
	   	out.println("<TD NOWRAP "+bgcolor+"><div align='right'>"+fontstyle+"</div></TD>");
	   	//out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("avail_date")+"</FONT></TD>");
	   	out.println("<TD NOWRAP align='center'><FONT SIZE=2>"+rs.getString("currency_code")+"</FONT></TD>");
	   	out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("request_reason")+"</FONT></TD>");
	   	out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("creation_date")+"</FONT></TD>");
	   	out.println("<TD NOWRAP><FONT SIZE=2>"+rs.getString("created_by_name")+"</FONT></TD>");
		out.println("<TD NOWRAP align='center'><FONT SIZE=2>"+rs.getString("status")+"</FONT></TD>");
	   	//out.println("<TD NOWRAP><FONT SIZE=2>"+(rs.getString("approve_date")==null?"&nbsp;":rs.getString("approve_date"))+"</FONT></TD>");
	   	//out.println("<TD NOWRAP><FONT SIZE=2>"+(rs.getString("approved_by_name")==null?"&nbsp;":rs.getString("approved_by_name"))+"</FONT></TD>");
    	out.println("</TR>");
		rowcnt ++;
	}
	if (rowcnt==0)
	{
		out.println("<font color='red'>查無該料號歷史單價!!</font>");
	}
	else
	{
		out.println("</TABLE></font>");
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

