<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
  	String vPlant=request.getParameter("plant");
	if (vPlant == null) vPlant = "";
%>
<html>
<head>
<title>Plant Code Mapping Customer Information</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body >  
<FORM METHOD="post" name ="form1">
<TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong>Plant Code Mapping Customer Information:</strong></font>
</TD>
<br>
<br>
<%  
    out.println("<table width='85%' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
	out.println("<tr bgcolor='#EEEEEE'>");
	out.println("<td width='10%'><font size='2'>Plant Code</font></td>");
	out.println("<td width='45%'><font size='2'>Customer Name</font></td>");
	out.println("<td width='45%'><font size='2'>Ship To Location</font></td>");
    out.println("</tr>");
	try
	{ 
		//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	 	 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
 		cs1.execute();
 		cs1.close();
			
 		String sql = " SELECT a.segment1, '('||a.attribute1 || ')' || b.customer_name customer_name,"+
                      " '('||a.attribute2 || ')' || c.address1 address"+
                      " FROM inv.mtl_item_locations a,"+
                      " ar_customers b,"+
                      " ar_addresses_v c,"+
                      " hz_site_uses_v d"+
                      " WHERE a.organization_id = 163"+
                      " AND a.subinventory_code = '50'"+
                      " AND a.attribute1 = b.customer_number(+)"+
                      " AND b.status = 'A'"+
                      " AND b.customer_id = c.customer_id(+)"+
                      " AND c.address_id = d.address_id(+)"+
                      " AND d.status = 'A'"+
                      " AND a.attribute2 = d.site_use_id";
		Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql);
		while(rs.next())
		{
			if (rs.getString("segment1").equals(vPlant))
			{
				out.println("<tr bgcolor='#FFFF00'>");
			}
			else
			{
				out.println("<tr bgcolor='#E6FFE6'>");
			}
			out.println("<td><div align='left'><font size='2'>"+rs.getString("segment1")+"</font></div></td>");
			out.println("<td><div align='left'><font size='2'>"+rs.getString("customer_name")+"</font></div></td>");
			out.println("<td><div align='left'><font size='2'>"+rs.getString("address")+"</font></div></td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
	}
	catch (Exception e)
	{
		out.println("Exception:"+e.getMessage());
	}
 	out.println("</table>");
    %>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
 </body>
</html>
