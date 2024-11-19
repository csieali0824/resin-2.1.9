<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="MiscellaneousBean,java.text.DecimalFormat"%>
<!--%@ include file="/jsp/include/ConnTest2PoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function sendWindowOpen(pp)
{    
 //subWin=window.open("TscOtherInvoiceCreatePreview.jsp?INVOICENO="+pp);  
 document.MYFORM.action=pp;  
 document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Concurrent SQL Detail Page</title>
</head>

<body>
<A HREF="../jsp/OraSysConcurrentSQLQuery.jsp">回上一頁</A> 
<FORM ACTION="../jsp/OraSysConcurrentSQLQuery.jsp" METHOD="post" NAME="MYFORM">
<%
     
	            String sessionID=request.getParameter("SID");
	 
	
	 
		 
                String sSQLText = ""; 
		        Statement stateSQL=con.createStatement();
                ResultSet rsSQL=stateSQL.executeQuery("select PIECE, SQL_TEXT from v$SESSION a, v$SQLTEXT b where a.sql_address = b.address and a.SID = '"+sessionID+"' order by PIECE ");
                while (rsSQL.next())
				{
				  sSQLText = sSQLText + " "+ rsSQL.getString("SQL_TEXT");
				} 
				rsSQL.close();
				stateSQL.close();
				//out.println(sSQLText);

	 
	
	
	
  
	 
// Step7. 資料產生完成,可選擇直接重新轉向至列印頁面

  //  response.sendRedirect("http://intranet.ts.com.tw/joetest/other/otherindex2.asp?invoice_no="+invoiceNo); 
	 
%>

<table>
  <tr bgcolor="#339999">
     <td colspan="2" valign="middle">
	     <div align="center"><font color="#FFFF00"><strong>SQL Text</strong></font>
      <textarea name="SHIPMARK" cols="80" rows="20" ><%=sSQLText%></textarea></div>	
	 </td>
  </tr>
</table>
<% //-- 表單參數 %>
</FORM>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnTest2Page.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
