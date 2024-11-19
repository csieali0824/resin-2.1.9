
<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
 
<%
String searchString=request.getParameter("SEARCHSTRING");
String keyID=request.getParameter("ID");
String customerNumber=request.getParameter("CUSTOMERNUMBER");
String addressID =request.getParameter("ADDRESSID");
String u_Update_Field= request.getParameter("u_Update_Field");
String sourcePage=request.getParameter("sourcepg");
if (sourcePage == null) sourcePage = "";
String url_page = "";
if (sourcePage.equals("D1010"))
{
	url_page  = "../jsp/Tsc1211SpecialCustConfirm.jsp";
}
else 
{
	url_page = "../jsp/Tsc1211ConfirmDetailList.jsp";
}  
String u_Primary_Flag =""; 
String u_Site_Use_ID ="";
String u_Country ="";
String u_Address1 ="";
String u_Address2 ="";
String u_Use_Code="";
String u_payment_id="",u_pricelist="",u_fob =""; //add by Peggy 20130412
String u_currency="";     //add by Peggy 20130516
String u_TaxCode="";      //add by Peggy 20131118
String u_site_number="";  //add by Peggy 20150910
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();
%>
<html>
<head>
<title> </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	window.opener.document.MYFORM.action=URL;
 	window.opener.document.MYFORM.submit(); 
 	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1"  >
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"><strong> Customer <%=addressID%> Address Select :</strong></font>
<br>
<%  
Statement statement=con.createStatement();
out.println("<table width='630' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
out.println("<tr bgcolor='#EEEEEE'>");
out.println("<td width='10'><font size='2'>&nbsp;</font></td>");
out.println("<td width='30'><font size='2'>FLAG</font></td>");
out.println("<td width='30'><font size='2'>SITE_ID</font></td>");
out.println("<td width='50'><font size='2'>COUNTRY</font></td>");
out.println("<td width='510'><font size='2'>ADDRESS1</font></td>");
out.println("</tr>");
try
{ 
	String sql = " select a.STATUS, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1,b.ADDRESS2,b.ADDRESS3,b.ADDRESS4  "+ 
			     ",a.payment_term_id,a.fob_point, a.price_list_id,nvl(c.CURRENCY_CODE,'') CURRENCY_CODE"+ //add CURRENCY_CODE by Peggy 20130516
				 ",b.site_number"+//add by Peggy 20150910
			     " from AR_SITE_USES_V a,AR_ADDRESSES_V b,SO_PRICE_LISTS c"+ //add SO_PRICE_LISTS by Peggy 20130516
			     " where a.ADDRESS_ID = b.ADDRESS_ID "+
			     " and a.STATUS=b.STATUS and a.STATUS='A'"+
			     " and b.ORG_ID = '41' "+
                 " and a.PRICE_LIST_ID = c.PRICE_LIST_ID(+)"+ //add by Peggy 20130516
			     " and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL  WHERE CUST_ACCOUNT_ID='"+customerNumber+"') "+
			     " and a.SITE_USE_CODE = '"+addressID+"' "; 
	//out.println(sql);
	ResultSet rs=statement.executeQuery(sql);	
	if(rs!=null)
	{
		while(rs.next())
		{
			u_Primary_Flag = rs.getString("PRIMARY_FLAG");
			u_Site_Use_ID = rs.getString("SITE_USE_ID");
			u_Country = rs.getString("COUNTRY");
			u_Address1 = rs.getString("ADDRESS1");
			u_Address2 = rs.getString("ADDRESS2");
			u_payment_id= rs.getString("payment_term_id");  //add by Peggy 20130412
			u_pricelist= rs.getString("price_list_id");     //add by Peggy 20130412 
			u_fob = rs.getString("fob_point");              //add by Peggy 20130412
			u_currency = rs.getString("CURRENCY_CODE");     //add by Peggy 20130516
			u_TaxCode = "";  
			u_site_number=rs.getString("site_number");     //add by Peggy 20150910
			//add by Peggy 20131118
			if (addressID.equals("SHIP_TO"))
			{
				//sql = " select a.TAX_CODE"+ 
			    // " from AR_SITE_USES_V a,AR_ADDRESSES_V b"+
			    // " where a.ADDRESS_ID = b.ADDRESS_ID "+
			    // " and a.STATUS=b.STATUS and a.STATUS='A'"+
			    //" and b.ORG_ID = '41' "+
			    // " and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL  WHERE CUST_ACCOUNT_ID='"+customerNumber+"') "+
			    // " and a.SITE_USE_CODE = 'DELIVER_TO'"+
				// " and b.ADDRESS1 ='"+ 	u_Address1+"'";
				sql =" SELECT su.TAX_CODE"+
                     " FROM  hz_cust_site_uses_all SU ,AR_ADDRESSES_V AD,AR_CUSTOMERS AC "+
                     " WHERE  su.cust_acct_site_id  = AD.ADDRESS_ID "+
                     " AND AD.CUSTOMER_ID=AC.CUSTOMER_ID "+
                     " AND AC.CUSTOMER_ID ='"+customerNumber+"'"+
                     " AND SU.SITE_USE_CODE='DELIVER_TO'"+
                     " AND AD.SITE_NUMBER='"+u_site_number+"'";
				Statement statement1=con.createStatement();
				ResultSet rs1=statement1.executeQuery(sql);	
				if(rs1.next())
				{
					u_TaxCode=rs1.getString("TAX_CODE");
				}
				rs1.close();
				statement1.close();
			}
			out.println("<tr bgcolor='#E6FFE6'>");                       
			out.println("<td><input type='button' value='Set' onClick='setSubmit("+'"'+url_page+"?ID="+keyID+"&u_Site_Use_ID="+u_Site_Use_ID+"&u_Use_Code="+addressID+"&u_Update_Field="+u_Update_Field+"&u_payment_id="+u_payment_id+"&u_pricelist="+u_pricelist+"&u_fob="+u_fob+"&u_currency="+u_currency+"&u_tax_code="+u_TaxCode+'"'+")' ></td>");
			out.println("<td><div align='right'><font size='2'>"+u_Primary_Flag+"</font></div></td>");
			out.println("<td><div align='right'><font size='2'>"+u_Site_Use_ID+"</font></div></td>");
			out.println("<td><div align='left'><font size='2'>"+u_Country+"</font></div></td>");
			out.println("<td><div align='left'><font size='2'>"+u_Address1+"</font></div></td>");
			out.println("</tr>");
		}
	}
	else
	{
			out.println("<tr bgcolor='#E6FFE6'>");
			out.println("<td colspan='5'><div align='center'><font size='2'>No Data !!</font></div></td>");
			out.println("</tr>");
	}
}
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
out.println("</table>");
%>
<br> 
</p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
