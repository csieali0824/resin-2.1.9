<%@ page language="java" import="java.sql.*"%>
<!--=============�H�U�Ϭq�����o�s����==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Stream" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String QNO=request.getParameter("QNO");
if (QNO==null) QNO="";
String PNO=request.getParameter("PNO");
if (PNO==null) PNO="";
String PITEM=request.getParameter("PITEM");
if (PITEM==null) PITEM="";
String  sellingPrice = StringUtils.isNullOrEmpty(request.getParameter("UPRICE")) ? "" : request.getParameter("UPRICE");
%>
<html>
<head>
<title>Quote info</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(price,end_cust)
{
	window.opener.document.MYFORM.UPRICE.value=price; 
	if (window.opener.document.MYFORM.SALESAREANO.value!="003")
	{
		window.opener.document.MYFORM.ENDCUSTOMER.value=end_cust;
	}
 	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQQuoteInfoFind.jsp" NAME="SITEFORM">
<%  
	String uprice="",end_cust="";
	try
	{
		if (!StringUtils.isNullOrEmpty(QNO) && !StringUtils.isNullOrEmpty(PNO)) {
			String sql = "SELECT * FROM (\n" +
					"    -- �Ĥ@�����GQUQTE ��ƨӷ�\n" +
					"     SELECT \n" +
					"         quoteid,\n" +
					"         partnumber,\n" +
					"         currency,   \n" +
					"         LISTAGG(pricek, ',') WITHIN GROUP (ORDER BY pricek DESC) AS pricek,\n" +
					"         LISTAGG(end_customer||'_'||pricek, ',') WITHIN GROUP (ORDER BY end_customer DESC) AS end_customer,\n" +
					"         pass_flag,\n" +
					"         todate\n" +
					"     FROM (    \n" +
					"         SELECT DISTINCT\n" +
					"             a.quoteid,\n" +
					"             a.partnumber,\n" +
					"             a.currency,\n" +
					"             TO_CHAR(a.pricek / 1000, 'FM99990.0999999') AS pricek,           \n" +
					"             '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
					"             CASE\n" +
					"                 WHEN (\n" +
					"                     CASE\n" +
					"                         WHEN a.region IN ('TSCR', 'TSCI') THEN TRUNC(a.fromdate)\n" +
					"                         ELSE TRUNC(SYSDATE)\n" +
					"                     END\n" +
					"                 ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
					"                 THEN '1'\n" +
					"                 ELSE '0'\n" +
					"             END AS pass_flag,\n" +
					"             TO_CHAR(a.todate,'yyyy-mm-dd') todate\n" +
					"         FROM tsc_om_ref_quotenet a\n" +
					"    WHERE a.quoteid='" + QNO + "' \n"+
					"      AND a.partnumber='" + PNO + "' \n"+
					"      AND EXISTS (\n" +
					"                     SELECT 1 \n" +
					"                     FROM tsc_om_ref_quotenet b\n" +
					"                     WHERE b.quoteid = a.quoteid\n" +
					"                       AND b.partnumber = a.partnumber\n" +
					"                 )\n" +
					"     )\n" +
					"     GROUP BY\n" +
					"        quoteid,\n" +
					"        partnumber,\n" +
					"        currency,\n" +
					"        pass_flag,\n" +
					"        todate\n" +
					"    UNION ALL\n" +
					"     -- �ĤG�����GMODELN ��ƨӷ�(�u���̷s����)\n" +
					"    SELECT\n" +
					"         quoteid,\n" +
					"         partnumber,\n" +
					"         currency,   \n" +
					"         LISTAGG(pricek, ',') WITHIN GROUP (ORDER BY pricek DESC) AS pricek,\n" +
					"         LISTAGG(end_customer||'_'||pricek, ',') WITHIN GROUP (ORDER BY end_customer DESC) AS end_customer,\n" +
					"         pass_flag,\n" +
					"         todate\n" +
					"    FROM (\n" +
					"       SELECT DISTINCT\n" +
					"             a.quoteid,\n" +
					"             a.partnumber,\n" +
					"             a.currency,\n" +
					"             TO_CHAR(a.pricek / 1000, 'FM99990.0999999') AS pricek,           \n" +
					"             '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
					"             CASE\n" +
					"                 WHEN (\n" +
					"                     CASE\n" +
					"                         WHEN a.region IN ('TSCR', 'TSCI') THEN TRUNC(a.fromdate)\n" +
					"                         ELSE TRUNC(SYSDATE)\n" +
					"                     END\n" +
					"                 ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
					"                 THEN '1'\n" +
					"                 ELSE '0'\n" +
					"             END AS pass_flag,\n" +
					"             TO_CHAR(a.todate,'yyyy-mm-dd') todate\n" +
					"        FROM tsc_om_ref_modeln a\n" +
					"        WHERE a.quoteid='" + QNO + "' \n"+
					"          AND a.partnumber='" + PNO + "' \n"+
					"          AND EXISTS (\n" +
					"               SELECT 1 \n" +
					"               FROM tsc_om_ref_modeln b\n" +
					"               WHERE b.quoteid = a.quoteid\n" +
					"                 AND b.partnumber = a.partnumber\n" +
					"           ) \n" +
					"    )\n" +
					"     GROUP BY\n" +
					"        quoteid,\n" +
					"        partnumber,\n" +
					"        currency,\n" +
					"        pass_flag,\n" +
					"        todate\n" +
					")";

			Statement statement = con.createStatement();
			ResultSet rs = statement.executeQuery(sql);
			if (rs.next())
			{
				if (rs.getString("pass_flag").equals("1"))
				{
					uprice=rs.getString("pricek");
					end_cust=rs.getString("end_customer");
					if (uprice.split(",").length > 1) {
						if (!Arrays.asList(uprice.split(",")).contains(sellingPrice)) {
							out.println("Multiple prices exist for the same part number (" + uprice.replace(",", " / ") + ")!");
							return;
						} else {
							uprice = sellingPrice;
						}
					} else if (!StringUtils.isNullOrEmpty(sellingPrice) && !sellingPrice.equals(uprice)) {
						out.println("Selling Price not match quote price(" + uprice + "))!");
						return;
					}
				}
				else
				{
					out.println("Quote:"+QNO+" + Part:"+PNO+" has expired("+rs.getString("todate")+")!");
				}
			}
			else
			{
				out.println("Quote#"+QNO+" + Part#"+PNO+"  not found!");
			}
			rs.close();
			statement.close();
		}
		if (StringUtils.isNullOrEmpty(PNO)) {
			out.println("Please enter the TSC P/N.");
		}

		if (!uprice.equals(""))
		{
		%>
		<script LANGUAGE="JavaScript">
			sendToMainWindow("<%=uprice%>","<%=end_cust%>");
		</script>
		<%	
		}
    } 
    catch (Exception e)
    {
		%>
		<script LANGUAGE="JavaScript">   
			sendToMainWindow("","");		                   
		</script> 
		<%	    
	}
	%>
<!--%���Ѽ�%-->
</FORM>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
