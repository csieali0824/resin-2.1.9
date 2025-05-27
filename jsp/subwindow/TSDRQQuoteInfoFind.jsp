<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="com.mysql.jdbc.StringUtils" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String QNO=request.getParameter("QNO");
if (QNO==null) QNO="";
String PNO=request.getParameter("PNO");
if (PNO==null) PNO="";
String PITEM=request.getParameter("PITEM");
if (PITEM==null) PITEM="";
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
	String uprine="",end_cust="";
	try
	{
		if (!StringUtils.isNullOrEmpty(QNO) && !StringUtils.isNullOrEmpty(PNO)) {
			String sql = "SELECT * FROM (\n" +
					"    -- 第一部分：QUOTE 資料來源\n" +
					"    SELECT\n" +
					"        a.quoteid,\n" +
					"        a.partnumber,\n" +
					"        a.currency,\n" +
					"        TO_CHAR(a.pricekusd / 1000, 'FM99990.0999999') AS price_usd,\n" +
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
					"    UNION ALL\n" +
					"    -- 第二部分：MODELN 資料來源（只取最新報價）\n" +
					"    SELECT\n" +
					"        quoteid,\n" +
					"        partnumber,\n" +
					"        currency,\n" +
					"        price_usd,\n" +
					"        end_customer,\n" +
					"        pass_flag,\n" +
					"        todate\n" +
					"    FROM (\n" +
					"        SELECT\n" +
					"            a.quoteid,\n" +
					"            a.partnumber,\n" +
					"            a.currency,\n" +
					"            TO_CHAR(a.pricekusd / 1000, 'FM99990.0999999') AS price_usd,\n" +
					"            '(' || a.region || ')' || a.endcustomer AS end_customer,\n" +
					"            CASE\n" +
					"                WHEN (\n" +
					"                    CASE\n" +
					"                        WHEN a.region IN ('TSCR', 'TSCI') THEN TRUNC(a.fromdate)\n" +
					"                        ELSE TRUNC(SYSDATE)\n" +
					"                    END\n" +
					"                ) BETWEEN TRUNC(a.fromdate) AND TRUNC(a.todate)\n" +
					"                THEN '1'\n" +
					"                ELSE '0'\n" +
					"            END AS pass_flag,\n" +
					"            TO_CHAR(a.todate,'yyyy-mm-dd') todate,\n" +
					"            ROW_NUMBER() OVER (\n" +
					"                PARTITION BY a.quoteid, a.partnumber, a.currency\n" +
					"                ORDER BY a.pricekusd DESC\n" +
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
					uprine=rs.getString("price_usd");
					end_cust=rs.getString("end_customer");
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

		if (!uprine.equals(""))
		{
		%>
		<script LANGUAGE="JavaScript">   
			sendToMainWindow("<%=uprine%>","<%=end_cust%>");		                   
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
