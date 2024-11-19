<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String keyID=request.getParameter("ID");
String customerNumber=request.getParameter("CUSTOMERNUMBER");
String customerName=request.getParameter("CUSTOMERNAME");
String p_ship_to_contact="",p_ship_to_contact_id="";
String PROGRAMID=request.getParameter("PROGRAMID");
if (PROGRAMID==null) PROGRAMID="";
String searchStr = request.getParameter("SHIPTOCONTACT");
String SHIPTOCONTACTID="",SHIPTOCONTACT="";
if (searchStr ==null) searchStr="";
if (!searchStr.equals(""))
{
	try
	{
		long sid = Long.parseLong(searchStr);
		SHIPTOCONTACTID = searchStr;
	}
	catch(Exception e)
	{
		SHIPTOCONTACT = searchStr;
	}
}
int rowcnt =0;
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

function setSubmit1(SHIPTOCONTACT,SHIPTOCONTACTID)
{  
	window.opener.document.MYFORM.SHIPTOCONTACTID.value=SHIPTOCONTACTID;
  	window.opener.document.MYFORM.SHIPTOCONTACT.value=SHIPTOCONTACT; 
 	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1"  >
<br>
<%  
Statement statement=con.createStatement();
try
{ 
	String sql = " select distinct con.contact_id,LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name"+
                 //" from ar_contacts_v con,hz_cust_site_uses su "+
				 " from ar_contacts_v con "+
                 " where  con.customer_id ='"+customerNumber+"'"+
                 " and con.status='A'";
			     //" and con.address_id=su.cust_acct_site_id";
				// " AND su.site_use_code='SHIP_TO'";
	if (!SHIPTOCONTACTID.equals("")) sql += " AND con.contact_id ='"+SHIPTOCONTACTID+"'";
	if (!SHIPTOCONTACT.equals("")) sql +=" AND LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) like '"+SHIPTOCONTACT+"%'";
	sql += " ORDER BY LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE)";
	ResultSet rs=statement.executeQuery(sql);	
	//out.println(sql);
	while(rs.next())
	{
		p_ship_to_contact = rs.getString("contact_name");
		p_ship_to_contact_id = rs.getString("contact_id");
			
		if (rowcnt==0)
		{
			out.println("<table width='450' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'><tr bgcolor='#EEEEEE'><td>&nbsp;</td><td align='center' style='font-family:arial;font-size:12px'>ID</td><td align='center' style='font-family:arial;font-size:12px'>Name</td>");
	
		}				
		out.println("<tr bgcolor='#E6FFE6'>");
		if (PROGRAMID.equals("D1001") || PROGRAMID.equals("D9002") || PROGRAMID.equals("D11001"))  //add by Peggy 20140103
		{
			out.println("<td><input type='button' value='Set'  onClick='setSubmit1("+'"'+p_ship_to_contact+'"'+","+'"'+p_ship_to_contact_id+'"'+")' ></td>");
		}
		else
		{                   
			out.println("<td><input type='button' value='Set'  onClick='setSubmit("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+keyID+"&p_ship_to_contact_id="+p_ship_to_contact_id+'"'+")' ></td>");
		}
		out.println("<td><div align='left'><font size='2'>"+p_ship_to_contact_id+"</font></div></td>");
		out.println("<td><div align='left'><font size='2'>"+p_ship_to_contact+"</font></div></td>");
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
out.println("<input type='hidden' name='PROGRAMID' value='"+PROGRAMID+"'>");
if (rowcnt==1)
{
%>
	<script LANGUAGE="JavaScript"> 
		if (document.form1.PROGRAMID.value=="D1001" || document.form1.PROGRAMID.value=="D9002" || document.form1.PROGRAMID.value=="D11001")
		{
			setSubmit1("<%=p_ship_to_contact%>","<%=p_ship_to_contact_id%>");
		}
		else
		{
			setSubmit("../jsp/Tsc1211ConfirmDetailList.jsp?ID=<%=keyID%>&p_ship_to_contact_id=<%=p_ship_to_contact_id%>");
		}
	</script> 	
<%
}    
%>
<BR>
</p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
