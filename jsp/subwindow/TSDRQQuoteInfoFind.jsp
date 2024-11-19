<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
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
	String uprine="",end_cust="",chk_flag="";
	try
	{
		//String sql = " SELECT a.quote_id, a.tsc_partno,a.currency_code, TO_CHAR(a.price_k_usd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(CREATED_BY),'LISA')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.end_customer end_customer"+
		//			 " FROM oraddman.tsc_quote_data a"+
		//			 " where a.quote_id=?"+
		//			 " and a.tsc_partno=?";
		//			 //" and trunc(sysdate) between to_date(a.from_date,'yyyy/mm/dd') and to_date(a.to_date,'yyyy/mm/dd')";
		//String sql = " SELECT 1 iseq,a.quote_id, a.tsc_partno,a.currency_code, TO_CHAR(a.price_k_usd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(CREATED_BY),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(CREATED_BY),'JUNE')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.end_customer end_customer,'Y' as chkflag"+
        //             " FROM oraddman.tsc_quote_data a"+
        //             " where a.quote_id=?"+
        //             " and a.tsc_partno=?"+
        //	         " union all"+
        //             " SELECT 2 iseq,a.quote_id, a.tsc_partno,a.currency_code, TO_CHAR(a.price_k_usd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(CREATED_BY),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(CREATED_BY),'JUNE')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.end_customer end_customer,'N' as chkflag"+
        //             " FROM oraddman.tsc_quote_data a"+
        //             " where a.quote_id=?"+
        //             " and a.tsc_partno like (select tsc_get_item_desc_nopacking(msi.organization_id ,msi.inventory_item_id) from inv.mtl_system_items_b msi where msi.segment1=? and msi.organization_id=?)||'_%'"+
	    //             " order by 1";
		//String sql = " SELECT 1 iseq,a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, case when a.region in ('TSCR','TSCI') then case when INSTR(UPPER(a.createdby),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JUNE')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JWANG')>0 THEN '(TSCR)' ELSE '(TSCI)' END else '' end || a.endcustomer end_customer,'Y' as chkflag"+
		String sql = " SELECT 1 iseq,a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd"+
                     ",to_char(a.fromdate,'yyyy-mm-dd') fromdate"+
                     ",to_char(a.todate,'yyyy-mm-dd') todate"+				 	
		             ",case when a.region in ('TSCR','TSCI') then '('|| a.region ||')' else '' end || a.endcustomer end_customer"+
					 ",'Y' as chkflag"+	
                     ",case when case when a.region in ('TSCR','TSCI') then trunc(a.fromdate) else trunc(sysdate) end between trunc(a.fromdate) and trunc(a.todate) then '1' else '0' end pass_flag"+     
                     " FROM tsc_om_ref_quotenet a"+
                     " where a.quoteid=?"+
                     " and a.partnumber=?"+
					 //" and case when a.region in ('TSCR','TSCI') then trunc(a.fromdate) else trunc(sysdate) end between trunc(a.fromdate) and trunc(a.todate)"+ //add by Peggy 20231002
                     " union all"+
                     //" SELECT 2 iseq,a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, case when a.region in ('TSCR','TSCI') then case when INSTR(UPPER(a.createdby),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JUNE')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JWANG')>0 THEN '(TSCR)' ELSE '(TSCI)' END else '' end || a.endcustomer end_customer,'N' as chkflag"+
                     " SELECT 2 iseq,a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd"+
                     ",to_char(a.fromdate,'yyyy-mm-dd') fromdate"+
                     ",to_char(a.todate,'yyyy-mm-dd') todate"+						 
					 ",case when a.region in ('TSCR','TSCI') then '('|| a.region ||')' else '' end || a.endcustomer end_customer"+
					 ",'N' as chkflag"+
                     ",case when case when a.region in ('TSCR','TSCI') then trunc(a.fromdate) else trunc(sysdate) end between trunc(a.fromdate) and trunc(a.todate) then '1' else '0' end pass_flag"+     
                     " FROM tsc_om_ref_quotenet a"+
                     " where a.quoteid=?"+
                     " and a.partnumber like (select tsc_get_item_desc_nopacking(msi.organization_id ,msi.inventory_item_id) from inv.mtl_system_items_b msi where msi.segment1=? and msi.organization_id=?)||'_%'"+
					 " and length(?)>0"+ //add by Peggy 20240529 
					 //" and case when a.region in ('TSCR','TSCI') then trunc(a.fromdate) else trunc(sysdate) end between trunc(a.fromdate) and trunc(a.todate)"+  //add by Peggy 20231002
                     " order by 1";
		//out.println(sql);
		//out.println(PNO);
		//out.println(PITEM);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,QNO);
		statement.setString(2,PNO);
		statement.setString(3,QNO);
		statement.setString(4,PITEM);
		statement.setInt(5,43);
		statement.setString(6,PITEM);		
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{	
			if (rs.getString("pass_flag").equals("1"))
			{
				uprine=rs.getString("price_usd");
				end_cust=rs.getString("end_customer");
				chk_flag=rs.getString("chkflag");
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
