<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.stream.Stream" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
					"    -- 第一部分：QUOTE 資料來源\n" +
					"    SELECT\n" +
					"        a.quoteid,\n" +
					"        a.partnumber,\n" +
					"        a.currency,\n" +
					"LISTAGG(TO_CHAR(a.pricek / 1000, 'FM99990.0999999'), ',') \n" +
					"            WITHIN GROUP (ORDER BY a.pricek DESC) AS pricek,\n" +
					"        '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
					"        CASE\n" +
					"            WHEN (\n" +
					"                CASE\n" +
					"                    WHEN a.region IN ('TSCR', 'TSCI') THEN TRUNC(a.fromdate)\n" +
					"                    ELSE TRUNC(SYSDATE)\n" +
					"                END\n" +
					"            ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
					"            THEN '1'\n" +
					"            ELSE '0'\n" +
					"        END AS pass_flag,\n" +
					"        TO_CHAR(a.todate,'yyyy-mm-dd') todate\n" +
					"    FROM tsc_om_ref_quotenet a\n" +
					"    WHERE a.quoteid='" +QNO + "' \n"+
					"      AND a.partnumber='" + PNO + "' \n"+
					"	 GROUP BY\n" +
					"	         a.quoteid,\n" +
					"	         a.partnumber,\n" +
					"	         a.currency,\n" +
					"	         a.datecreated,\n" +
					"	         a.region,\n" +
					"	         a.endcustomer,\n" +
					"	         a.fromdate,\n" +
					"	         a.todate\n" +
					"    UNION ALL\n" +
					"    -- 第二部分：MODELN 資料來源（只取最新報價）\n" +
					"    SELECT\n" +
					"        quoteid,\n" +
					"        partnumber,\n" +
					"        currency,\n" +
					"        pricek,\n" +
					"        end_customer,\n" +
					"        pass_flag,\n" +
					"        todate\n" +
					"    FROM (\n" +
					"        SELECT\n" +
					"            a.quoteid,\n" +
					"            a.partnumber,\n" +
					"            a.currency,\n" +
					"            TO_CHAR(a.pricek / 1000, 'FM99990.0999999') AS pricek,\n" +
					"            '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
					"            CASE\n" +
					"                WHEN (\n" +
					"                    CASE\n" +
					"                        WHEN a.region IN ('TSCR') THEN TRUNC(a.fromdate)\n" +
					"                        ELSE TRUNC(SYSDATE)\n" +
					"                    END\n" +
					"                ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
					"                THEN '1'\n" +
					"                ELSE '0'\n" +
					"            END AS pass_flag,\n" +
					"            TO_CHAR(a.todate,'yyyy-mm-dd') todate,\n" +
					"            ROW_NUMBER() OVER (\n" +
					"                PARTITION BY a.quoteid, a.partnumber, a.currency\n" +
					"                ORDER BY a.datechanged DESC\n" +
					"            ) AS rn\n" +
					"        FROM tsc_om_ref_modeln a\n" +
					"        WHERE a.quoteid='" + QNO + "' \n"+
					"          AND a.partnumber='" + PNO + "' \n"+
					"    )\n" +
					"    WHERE rn = 1\n" +
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
							return ;
						} else {
							uprice = sellingPrice;
						}
					} else if (!StringUtils.isNullOrEmpty(sellingPrice) && !sellingPrice.equals(uprice)) {
						out.println("Selling Price not match quote price(" + uprice + "))!");
						return ;
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
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
