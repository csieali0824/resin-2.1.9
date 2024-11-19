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
<title>Object Schema Detail Page</title>
</head>

<body>
<A HREF="../jsp/OraSysObjQuery.jsp">回上一頁</A> 
<FORM ACTION="../jsp/OraSysObjQuery.jsp" METHOD="post" NAME="MYFORM">
<%
     
	            String object=request.getParameter("OBJECT"); 
	
	 
		 
                String sSQLText = ""; 
		        Statement stateSQL=con.createStatement();
                ResultSet rsSQL=stateSQL.executeQuery("select LINE, TEXT from USER_SOURCE b where name = '"+object+"' order by LINE ");
                while (rsSQL.next())
				{
				  sSQLText = sSQLText + " "+ rsSQL.getString("TEXT");
				} 
				rsSQL.close();
				stateSQL.close();
				//out.println(sSQLText);

	 
	
	
	
  
	 
// Step7. 資料產生完成,可選擇直接重新轉向至列印頁面

  //  response.sendRedirect("http://intranet.ts.com.tw/joetest/other/otherindex2.asp?invoice_no="+invoiceNo); 
	 
%>

<table>
  <tr bgcolor="#339999" height="100%">
     <td colspan="1">
	     <div align="left"><font color="#FFFF00"><strong>Object Schema</strong></font>
	       <textarea name="SHIPMARK" cols="120" rows="30" ><%=sSQLText%></textarea>
</div>	
	 </td>
  </tr>
</table>
</FORM>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnTest2Page.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>