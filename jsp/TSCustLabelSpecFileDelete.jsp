<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>TSC Customer Label Delete Page</title>
</head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<%
     String customerId=request.getParameter("CUSTOMERID"); 
     String custNo=request.getParameter("CUST_NO");
     String customerName=request.getParameter("CUSTOMERNAME");
	 String stationNo=request.getParameter("STATNO");
     String typeID=request.getParameter("TYPE_ID");
	 String tscFamily=request.getParameter("ITEMCATE");
	 String organizationID=request.getParameter("MARKETTYPE");     
%>
<body>
<%
     String sqlB="delete from ORADDMAN.TSCUST_LABEL_BLOBS where CUST_NO='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' ";		              
     PreparedStatement pstmtB=con.prepareStatement(sqlB);
	 pstmtB.executeUpdate(); 
     pstmtB.close();
	 
	 String sql="delete from ORADDMAN.TSCUST_LABEL_SPECS where CUST_NUMBER='"+custNo+"' and STATNO='"+stationNo+"' and TYPE_ID='"+typeID+"' and ORGANIZATION_ID='"+organizationID+"' and TSC_PACKAGE = '"+tscFamily+"' ";		              
     PreparedStatement pstmt=con.prepareStatement(sql);
	 pstmt.executeUpdate(); 
     pstmt.close();

     out.println("Delete Customer Label Success !!!");

%>
<table width="40%" border="1" cellpadding="0" cellspacing="0" >
  <tr>
    <td ><font size="2">客戶特殊規格標籤管理</font></td>      
  </tr>
  <tr>   
    <td>
<%
  try  
  { out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "E9"; 	
	String sqlE3 = "SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ";
	//out.println("sqlE3="+sqlE3);
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sqlE3);    	
    while(rs.next())
    {
	    //out.println("FSEQ="+rs.getString("FSEQ"));
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
	out.println("</table>");  
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  
   
%>   
  </td>     
 </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
