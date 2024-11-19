<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String CNAME = request.getParameter("CNAME");
if (CNAME==null) CNAME="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String SEARCHSTR= request.getParameter("CUSTOMER");
if (SEARCHSTR==null ) SEARCHSTR="";
if (SEARCHSTR.equals("")) SEARCHSTR=CNAME;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(vID,vName)
{
	window.opener.document.MYFORM.elements["ERPCUSTOMER"+document.SUBFORM.ID.value].value = vName;
	window.opener.document.MYFORM.elements["ERPCUSTID"+document.SUBFORM.ID.value].value = vID;
	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSCE1214CustInfoFind.jsp" NAME="SUBFORM">
<input type="hidden" name="CNAME" value="<%=CNAME%>">
<input type="hidden" name="ID" value="<%=ID%>">
<table>
	<tr>
		<td>
			<table>
				<tr>
					<td style="font-family:arial;font-size:12px">Customer Name:</td>
					<td><input type="text" name="CUSTOMER" style="font-family:arial" value="<%=SEARCHSTR%>"></td>
					<td><input type="submit" name="submit" value="Query" style="font-family:arial"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<%     
				try
				{ 
					sql = "	SELECT distinct c.customer_id,c.customer_number,c.customer_name customer_name"+
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='001') d"+
				          " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					      " and ','||d.GROUP_ID||',' like ','||b.attribute1||','"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
					      " and a.ORG_ID =?"+
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and (c.CUSTOMER_NUMBER ='"+SEARCHSTR+"' or UPPER(c.CUSTOMER_NAME) like '"+SEARCHSTR.toUpperCase()+"%') "+
						  " and c.STATUS=?"+
						  " order by  '('||c.customer_number||')'||c.customer_name";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"41");
					statement.setString(2,"A");
					ResultSet rs=statement.executeQuery();
					out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
					out.println("<TR bgcolor='#cccccc'><TH style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
					out.println("<TH style='font-size:12px;font-family:arial'>Customer ID</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>Customer Number</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>Customer Name</TH>");
					out.println("</TR>");
					int vline=0;
					while (rs.next())
					{
						vline++;
						out.println("<TR id='tr_"+vline+"'>");
						out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick='setSubmit("+'"'+rs.getString(1)+'"'+","+'"'+"("+rs.getString(2)+")"+rs.getString(3)+'"'+")'></TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(1)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(2)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(3)+"</TD>");
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();  
					statement.close();  
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
</table>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
