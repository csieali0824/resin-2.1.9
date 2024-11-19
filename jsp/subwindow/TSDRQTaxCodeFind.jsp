<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title> </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(taxCode)
{  
	window.opener.document.MYFORM.TAXCODE.value=taxCode;
 	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1"  >
<br>
<%  
Statement statement=con.createStatement();
String strTaxCode="",strTaxName="";
int rowcnt=0;
try
{ 
	String sql = " select tcc.tax_classification_code, NVL (rvl.tax_rate_name, lkp.lookup_code) tax_classification_name"+
                 " from zx_id_tcc_mapping_all tcc,zx_rates_vl rvl, "+
                 " (select lookup_code,  enabled_flag, start_date_active, end_date_active,"+
                 " lookup_type, leaf_node  from fnd_lookup_values lkp  where   lkp.view_application_id = 0"+
                 " AND security_group_id = 0  AND LANGUAGE ='US'  AND lookup_type = 'ZX_OUTPUT_CLASSIFICATIONS') lkp"+
                 " where tcc.org_id=41     and (tcc.tax_class='OUTPUT' or tcc.tax_class IS NULL)"+
                 " and tcc.tax_classification_code = lkp.lookup_code(+)"+
                 " AND tcc.tax_rate_code_id = rvl.tax_rate_id(+)"+
				 " AND tcc.ACTIVE_FLAG='Y'"+ //add by Peggy 20200724
                 " and NVL (tcc.effective_to,TO_DATE ('31/12/4712', 'DD/MM/YYYY')) - sysdate > 0"+
				 " order by tcc.tax_classification_code desc";
	ResultSet rs=statement.executeQuery(sql);	
	while(rs.next())
	{
		strTaxCode = rs.getString("tax_classification_code");
		strTaxName = rs.getString("tax_classification_name");
			
		if (rowcnt==0)
		{
			out.println("<table width='450' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
			out.println("<tr bgcolor='#EEEEEE'><td>&nbsp;</td>");
			out.println("<td align='center' style='font-family:arial;font-size:12px'>TAX Classification Code</td>");
			out.println("<td align='center' style='font-family:arial;font-size:12px'>TAX Classification Name</td>");
	
		}				
		out.println("<tr bgcolor='#E6FFE6'>");
		out.println("<td><input type='button' value='Set'  onClick='setSubmit("+'"'+strTaxCode+'"'+")' ></td>");
		out.println("<td><div align='left'><font size='2'>"+strTaxCode+"</font></div></td>");
		out.println("<td><div align='left'><font size='2'>"+strTaxName+"</font></div></td>");
		out.println("</tr>");
		rowcnt ++;
	}
	rs.close();
	if (rowcnt >0)
	{
		out.println("</table>");
	}
	else
	{
		out.println("<font color='red'>No Data Found!!</font>");
	}
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
statement.close();  
if (rowcnt==1)
{
%>
	<script LANGUAGE="JavaScript"> 
	setSubmit("<%=strTaxCode%>");
	</script> 	
<%
}    
%>
<BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
