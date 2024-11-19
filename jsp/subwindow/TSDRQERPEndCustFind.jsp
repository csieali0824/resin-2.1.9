<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String CUSTNUMBER = request.getParameter("CUSTNUMBER");
if (CUSTNUMBER==null) CUSTNUMBER="";
String SALESAREA = request.getParameter("SALESAREA");
if (SALESAREA==null) SALESAREA="";
String ENDCUST=request.getParameter("ENDCUST");
if (ENDCUST==null) ENDCUST="";
String SEARCHSTR= request.getParameter("CUSTOMER");
if (SEARCHSTR==null )
{
	if (!ENDCUST.equals(""))
	{
		SEARCHSTR=ENDCUST;
	}
	else
	{
		SEARCHSTR="";
	}
}
	
if (SEARCHSTR.equals("")) SEARCHSTR="%";
String CUSTOMERNO="",CUSTOMERNAME="",CUSTOMERSHORTNAME="",SUPPLIER_FLAG="";
int vline=0;
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(vID,vName,SupplierFlag)
{
	window.opener.document.MYFORM.LNREMARK.value = '';
	window.opener.document.MYFORM.ENDCUSTOMER.value = '';
	if(['32652','32653','32654','32655'].includes(vID)) { // 判斷 Customer No 為比亞迪時，附註欄加上"single label"字樣
		window.opener.document.MYFORM.LNREMARK.value = 'single label';
	}
	window.opener.document.MYFORM.ENDCUSTOMERID.value = vID;
	window.opener.document.MYFORM.ENDCUSTOMER.value = vName;
	window.opener.document.MYFORM.SUPPLIER_FLAG.value=SupplierFlag;  //add by Peggy 20220428
	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQERPEndCustFind.jsp" NAME="SUBFORM">
<input type="hidden" name="CUSTNUMBER" value="<%=CUSTNUMBER%>">
<input type="hidden" name="SALESAREA" value="<%=SALESAREA%>">
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
					/*sql = "	SELECT distinct c.customer_id,c.customer_number,c.customer_name customer_name,c.CUSTOMER_NAME_PHONETIC"+
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SALESAREA+"') d"+
				          " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					      " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
					      //" and a.ORG_ID =d.PAR_ORG_ID"+
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and (c.CUSTOMER_NUMBER ='"+SEARCHSTR+"' or UPPER(c.CUSTOMER_NAME) like '"+SEARCHSTR.toUpperCase()+"%') "+
						  " and c.STATUS=?"+
						  " and c.customer_number <>'"+CUSTNUMBER+"'"+
						  " order by  '('||c.customer_number||')'||c.customer_name";*/
					sql = " SELECT distinct c.customer_id,c.ACCOUNT_NUMBER customer_number,c.customer_name customer_name,c.CUSTOMER_SNAME CUSTOMER_NAME_PHONETIC"+
						  ",TSC_LABEL_PKG.SUPPLIER_NUMBER_REQUIREMENT(c.customer_id) SUPPLIER_FLAG"+//add by Peggy 20220428
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, tsc_customer_all_v c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SALESAREA+"') d"+
				          " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					      " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
					      //" and a.ORG_ID =d.PAR_ORG_ID"+
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and (c.ACCOUNT_NUMBER ='"+SEARCHSTR+"' or UPPER(c.CUSTOMER_NAME) like '"+SEARCHSTR.toUpperCase()+"%') "+
						  " and c.ACCOUNT_STATUS=?"+
						  " and c.ACCOUNT_NUMBER <>'"+CUSTNUMBER+"'"+
						  " order by  '('||c.ACCOUNT_NUMBER||')'||c.customer_name";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					//statement.setString(1,"41");
					statement.setString(1,"A");
					ResultSet rs=statement.executeQuery();
					out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
					out.println("<TR bgcolor='#cccccc'><TH style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
					//out.println("<TH style='font-size:12px;font-family:arial'>Customer ID</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>Customer Number</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>Customer Name</TH>");
					out.println("<TH style='font-size:12px;font-family:arial'>Customer Short Name</TH>");
					out.println("</TR>");
					vline=0;
					while (rs.next())
					{
						vline++;
						CUSTOMERNO=rs.getString(2);
						CUSTOMERNAME=rs.getString(3);
						CUSTOMERSHORTNAME=rs.getString(4);  //add by Peggy 20211108
						SUPPLIER_FLAG=rs.getString(5);   //add by Peggy 20220503
						out.println("<TR id='tr_"+vline+"'>");
						out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick='setSubmit("+'"'+rs.getString(2)+'"'+","+'"'+rs.getString(4)+'"'+","+'"'+rs.getString(5)+'"'+")'></TD>");
						//out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(1)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(2)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(3)+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString(4)+"</TD>");
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
<INPUT TYPE="hidden" NAME="CUSTOMERNO" value="<%=CUSTOMERNO%>" >
<INPUT TYPE="hidden" NAME="CUSTOMERNAME"  value="<%=CUSTOMERNAME%>" >
<INPUT TYPE="hidden" NAME="CUSTOMERSHORTNAME"  value="<%=CUSTOMERSHORTNAME%>" >
<INPUT TYPE="hidden" NAME="SUPPLIER_FLAG"  value="<%=SUPPLIER_FLAG%>" >
<%	   
if (vline==1) //若取到的查詢數 == 1
{
%>
<script LANGUAGE="JavaScript">   
	setSubmit("<%=CUSTOMERNO%>","<%=CUSTOMERSHORTNAME%>","<%=SUPPLIER_FLAG%>");		                   
</script>
<%		
}  // End of if (queryCount==1)
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
