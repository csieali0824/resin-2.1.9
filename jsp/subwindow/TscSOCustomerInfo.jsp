<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%
String customerNo=request.getParameter("CUSTOMERNO");
String name=request.getParameter("NAME");
String SAREANO=request.getParameter("SAREANO");
String orgID="";
String searchString = "";
String salesChGroupID = "";
String sql = "";
if (customerNo != null && !customerNo.equals(""))
{
	searchString += customerNo;
}else if (name != null && !name.equals(""))
{	
	searchString +=name;
}
Statement statement=con.createStatement();
ResultSet rs=statement.executeQuery("select PAR_ORG_ID,GROUP_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO='"+SAREANO+"'");  
if (rs.next())
{
	orgID=rs.getString("PAR_ORG_ID");
	salesChGroupID = rs.getString("GROUP_ID");
}
rs.close();

//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
cs1.setString(1,orgID);
cs1.execute();
cs1.close();
%>
<html>
<head>
<title>Page for choose Customer Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(custID,custNo,custName)
{   
  window.opener.document.MYFORM.CUSTOMERID.value=custID; 
  window.opener.document.MYFORM.CUSTOMERNO.value=custNo;
  window.opener.document.MYFORM.CUSTOMERNAME.value=custName;  
  this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSCustomerInfoFind.jsp" NAME='CUSTFORM'>
<font size="-1">客戶編號或客戶名稱: 
<input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
</font> 
<INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  -----客戶資訊--------------------------------------------     
<BR>
<%  
int queryCount = 0;
try
{ 
	if (UserRoles.equals("admin"))  // 設定管理員可看得到所有客戶
	{
		sql = " select CUSTOMER_ID, CUSTOMER_NUMBER, REPLACE(CUSTOMER_NAME,'\''',' ') as CUSTOMER_NAME,"+
			  " STATUS from APPS.AR_CUSTOMERS "+
			  " where  (CUSTOMER_NUMBER ='"+searchString+"' or "+ " CUSTOMER_NUMBER like '"+searchString+"%' or CUSTOMER_NAME like '"+searchString+"%')"+
			  " order by CUSTOMER_ID "; 

	}
	else if (userSalesGroupID!=null && !userSalesGroupID.equals(""))
	{				    			 
		sql = "select DISTINCT a.CUST_ACCOUNT_ID, c.CUSTOMER_NUMBER,"+
			  " REPLACE(c.CUSTOMER_NAME,'\''',' ') as CUSTOMER_NAME, "+
			  " c.STATUS"+
			  "  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+		
			  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
			  "  and b.attribute1 in ("+salesChGroupID+") "+
			  "  and a.STATUS = b.STATUS and a.ORG_ID = b.ORG_ID "+										
			  "  and a.ORG_ID ="+orgID+" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
			  "  and (CUSTOMER_NUMBER ='"+searchString+"' or c.CUSTOMER_NUMBER like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString+"%') "+
			  " order by CUST_ACCOUNT_ID ";    
	}
	if (sql.length() >0)
	{
		rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
		for (int i=2;i<=colCount;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
		}
		out.println("</TR>");
		String customerID=null,custNo=null,custName=null,custStatus=null;
		String buttonContent=null;
		String trBgColor = "";
		while (rs.next())
		{		
			customerID=rs.getString(1);
			custNo=rs.getString("CUSTOMER_NUMBER");
			custName=rs.getString("CUSTOMER_NAME");	
			custStatus=rs.getString("STATUS");
			out.println("<input type='hidden' name='CUSTID' value='"+customerID+"' >");
			out.println("<input type='hidden' name='CUSTNO' value='"+custNo+"' >");
			out.println("<input type='hidden' name='CUSTNAME' value='"+custName+"' >");
			out.println("<input type='hidden' name='STATUS' value='"+custStatus+"' >");
			if (customerNo==null) 
			{ 
				trBgColor = "E3E3CF"; 
			}
			else if (customerNo==rs.getString("CUSTOMER_NUMBER") || customerNo.equals(rs.getString("CUSTOMER_NUMBER")))				 	 
			{ 
				trBgColor = "FFCC66"; 
			}
			else 
			{ 
				trBgColor = "E3E3CF"; 
			}
			out.println("<TR BGCOLOR='"+trBgColor+"'>");
			out.println("<TD>");
	 %>
			<INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=customerID%>","<%=custNo%>","<%=custName%>")'> 
	 <% 
			out.print("</TD>");		
			out.println("<TD><FONT SIZE=2>"+customerID+"</TD>");
			out.println("<TD><FONT SIZE=2>"+custNo+"</TD>");
			out.println("<TD><FONT SIZE=2>"+custName+"</TD>");
			out.println("<TD><FONT SIZE=2>"+custStatus+"</TD>");
			out.println("</TR>");	
			queryCount++;
		} 
		out.println("</TABLE>");						
		rs.close(); 
		statement.close();
		if (queryCount==1) //若取到的查詢數 == 1
		{
		 %>
			<script LANGUAGE="JavaScript">		
				//window.opener.document.location.reload();			    	   
				window.opener.document.MYFORM.CUSTOMERID.value = document.CUSTFORM.CUSTID.value;
				window.opener.document.MYFORM.CUSTOMERNO.value = document.CUSTFORM.CUSTNO.value; 
				window.opener.document.MYFORM.CUSTOMERNAME.value = document.CUSTFORM.CUSTNAME.value;   
				
				this.window.close(); 
			</script>
		 <%
		}
	}   
	else
	{
		out.println("<font color='red'>No Data found!</font>");
	} 		
} 
catch (Exception e)
{
	out.println("Exception:"+sql+e.getMessage());
}
%>
<BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="orgID" SIZE=30 value="<%=orgID%>" >
<INPUT TYPE="hidden" NAME="CUSTOMERNO" SIZE=10 value="<%=customerNo%>" >
<INPUT TYPE="hidden" NAME="NAME" SIZE=30 value="<%=name%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
