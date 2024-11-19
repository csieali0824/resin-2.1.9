<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String customerNo=request.getParameter("CustomerNo");
String orgID=request.getParameter("ORGID");
if (orgID==null || orgID.equals("")) orgID = "41"; // 若沒給或沒取到,則預設是半導體業務部
%>
<html>
<head>
<title>Page for choose Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(URL)
{
	window.opener.document.form1.action=URL
	window.opener.document.form1.submit(); 
  	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TscExcelUploadCustInfo.jsp" NAME=CUSTFORM>
<BR>
<%     
int QryCnt = 0;
String sql = "";
String buttonContent=null;
String trBgColor = "";
String SalesArea ="",CustomerNumber="",CustomerName="",Status="",SalesAreaNo="",CustomerID="",PAR_ORG_ID="",Sample_File="";
Statement statement=con.createStatement();
try
{ 
	sql = " SELECT DISTINCT '('|| e.sales_area_no||')'||e.SALES_AREA_NAME as saleAreaName,c.customer_number,"+
          "      REPLACE (c.customer_name, '\''', ' ') AS customer_name,"+
          "      c.status,e.sales_area_no,"+
		  "      a.cust_account_id customerNo,"+
		  "      e.PAR_ORG_ID,d.SAMPLE_FILE"+
          " FROM apps.hz_cust_acct_sites_all a,"+
          "     ar.hz_cust_site_uses_all b,"+
          //"      apps.ra_customers c,"+
		  "     ar_customers c,"+
          "     oraddman.tsc_cust_upload_tbl d,"+
          "     oraddman.tssales_area e"+
          " WHERE a.cust_acct_site_id = b.cust_acct_site_id"+
          " AND ',' || e.GROUP_ID || ',' LIKE '%,' || b.attribute1 || ',%'"+
          " AND a.status = b.status"+
          " AND a.org_id = b.org_id"+
          //" AND a.org_id ="+orgID+
          " AND a.cust_account_id = c.customer_id"+
          " AND c.customer_number = d.customer_no"+
		  " AND d.sales_area_no = e.sales_area_no"+ //add by Peggy 20120525
		  " and e.group_id is not null";
	if (!UserRoles.equals("admin"))  // 設定管理員可看得到所有客戶
	{
    	sql +=" AND EXISTS (SELECT 1  FROM oraddman.tsrecperson x  WHERE x.username = '"+UserName+"'"+
              " AND x.tssaleareano = e.sales_area_no)";
	}
    sql += " ORDER BY e.sales_area_no,c.customer_number ";
	ResultSet rs=statement.executeQuery(sql);
	//out.println("sql="+sql);
	while (rs.next())
	{	
		if (QryCnt==0)
		{
			out.println("<TABLE>");      
			out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>SalesAres</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>CustomerNo</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>CustomerName</TH>");
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>Status</TH>");
			out.println("</TR>");
		}
		SalesArea=rs.getString("saleAreaName");
		CustomerNumber=rs.getString("customer_number");
		CustomerName=rs.getString("CUSTOMER_NAME");
		Status=rs.getString("STATUS");
		SalesAreaNo=rs.getString("sales_area_no");  
		CustomerID=rs.getString("customerNo");
		PAR_ORG_ID=rs.getString("PAR_ORG_ID");
		Sample_File=rs.getString("SAMPLE_FILE");
		if (customerNo.equals(CustomerNumber))				 	 
		{ 
			trBgColor = "FFCC66"; 
		}
		else 
		{ 
			trBgColor = "E3E3CF"; 
		}
		//buttonContent="this.value=sendToMainWindow("+'"'+CustomerID+'"'+","+'"'+CustomerNumber+'"'+","+'"'+CustomerName+'"'+","+'"'+SalesAreaNo+'"'+","+'"'+SalesArea+'"'+","+'"'+PAR_ORG_ID+'"'+")";		
		buttonContent="this.value=sendToMainWindow("+'"'+"../jsp/TSCExcelUploadToImport.jsp?CUSTOMERNAME="+java.net.URLEncoder.encode(CustomerName)+"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNumber)+"&CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+"&SalesArea="+java.net.URLEncoder.encode(SalesArea)+"&SalesAreaNo="+java.net.URLEncoder.encode(SalesAreaNo)+"&PAR_ORG_ID="+java.net.URLEncoder.encode(PAR_ORG_ID)+"&SAMPLEFILE="+java.net.URLEncoder.encode(Sample_File)+'"'+")";
		out.println("<TR BGCOLOR='"+trBgColor+"'>");
		out.println("<TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%out.println("' onClick='"+buttonContent+"'></TD>");		
		out.println("<TD><FONT SIZE=2>"+SalesArea+"</TD>");
		out.println("<TD><FONT SIZE=2>"+CustomerNumber+"</TD>");
		out.println("<TD><FONT SIZE=2>"+CustomerName+"</TD>");
		out.println("<TD><FONT SIZE=2>"+Status+"</TD>");
		out.println("</TR>");
		QryCnt++;
	}
	if (QryCnt >0)
	{
		out.println("</TABLE>");
	}						
	else
	{
		out.println("<font color='red'>No Data found!</font>");
	} 
	rs.close(); 
}
catch(Exception e)
{
	out.println("Exception"+e.getMessage());
}
finally
{
	statement.close();
}
session.removeAttribute("EXL"); 	
if (QryCnt ==1)
{
	out.println("<script type=\"text/javascript\">sendToMainWindow("+'"'+"../jsp/TSCExcelUploadToImport.jsp?CUSTOMERNAME="+java.net.URLEncoder.encode(CustomerName)+"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNumber)+"&CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+"&SalesArea="+java.net.URLEncoder.encode(SalesArea)+"&SalesAreaNo="+java.net.URLEncoder.encode(SalesAreaNo)+"&PAR_ORG_ID="+java.net.URLEncoder.encode(PAR_ORG_ID)+"&SAMPLEFILE="+java.net.URLEncoder.encode(Sample_File)+'"'+")</script>"); 
}	
%>
<BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
