<%@ page language="java" import="java.sql.*"%>
<%@ page import="java.text.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String WIP_TYPE=request.getParameter("WIP_TYPE");
if (WIP_TYPE == null) WIP_TYPE = "";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(i_row)
{ 
	window.opener.document.MYFORM.VENDOR.value=document.SITEFORM.elements["VENDOR_"+i_row].value;
	window.opener.document.MYFORM.VENDOR_NAME.value=document.SITEFORM.elements["VENDORNAME_"+i_row].value;
  	window.opener.document.MYFORM.VENDOR_ID.value=document.SITEFORM.elements["VENDORID_"+i_row].value;
  	window.opener.document.MYFORM.VENDOR_CODE.value=document.SITEFORM.elements["VENDORCODE_"+i_row].value;
	window.opener.document.MYFORM.VENDOR_SITE_ID.value=document.SITEFORM.elements["VENDORSITEID_"+i_row].value;
	window.opener.document.MYFORM.VENDOR_CONTACT.value=document.SITEFORM.elements["VENDORCONTACT_"+i_row].value;
	window.opener.document.MYFORM.CURR_CODE.value=document.SITEFORM.elements["CURRENCYCODE_"+i_row].value;
	window.opener.document.MYFORM.CURR1.value=document.SITEFORM.elements["CURRENCYCODE_"+i_row].value;
	window.opener.document.MYFORM.ITEMID.value="";
	window.opener.document.MYFORM.ITEMNAME.value="";
	window.opener.document.MYFORM.ITEMDESC.value="";
	window.opener.document.MYFORM.PACKAGE.value="";
	window.opener.document.MYFORM.DIEID.value="";
	window.opener.document.MYFORM.DIENAME.value="";
	window.opener.document.MYFORM.DIEDESC.value="";
	window.opener.document.MYFORM.DIEQTY.value="";
	window.opener.document.MYFORM.VENDORITEMNAME.value="";
	window.opener.document.MYFORM.NEWITEMNAME.value="";
	window.opener.document.MYFORM.NEWITEMID.value="";
	window.opener.document.MYFORM.NEWITEMDESC.value="";
	window.opener.document.MYFORM.BILLSEQID.value="";
	window.opener.document.MYFORM.QTY.value="";
	window.opener.document.MYFORM.UNITPRICE.value="";
	window.opener.document.MYFORM.PACKING.value="";
	window.opener.document.MYFORM.PACKAGESPEC.value="";
	window.opener.document.MYFORM.TESTSPEC.value="";	
  	this.window.close();
}
</script>
<title>Page for choose Supplier List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSA01OEMSupplierInfo.jsp" NAME="SITEFORM">
<BR>
<%  
	try
    { 
		String sql = " SELECT DISTINCT b.VENDOR_SITE_CODE VENDOR_SITE"+
                     ",'('||a.SEGMENT1||')'||a.VENDOR_NAME VENDOR"+
					 //",replace(replace(c.VENDOR_CONTACT,'''r',''),'''','') VENDOR_CONTACT"+
					 ",(SELECT  PERSON.person_last_name||PERSON.person_first_name "+
                     " FROM hz_parties PERSON"+
					 " ,hz_parties PTY_REL"+
					 " ,ap_supplier_contacts APSC "+
                     " WHERE APSC.per_party_id = PERSON.party_id"+
                     " AND APSC.rel_party_id = PTY_REL.party_id"+
                     " AND APSC.org_party_site_id=b.party_site_id) VENDOR_CONTACT"+ 
                     ",NVL(b.PAYMENT_CURRENCY_CODE,b.INVOICE_CURRENCY_CODE) CURRENCY_CODE"+
                     ",b.VENDOR_SITE_ID "+
                     ",a.VENDOR_ID"+
					 ",a.SEGMENT1"+
					 ",a.VENDOR_NAME"+
                     " FROM AP.ap_suppliers a "+
                     ",AP.ap_supplier_sites_all b"+
                     ",(select VENDOR_SITE_ID,vendor_contact from (SELECT VENDOR_SITE_ID,LAST_NAME|| FIRST_NAME vendor_contact, row_number() over (partition by VENDOR_SITE_ID order by LAST_UPDATE_DATE desc) rownumber FROM AP.ap_supplier_contacts) where rownumber=1) c "+
                     ",(SELECT a.data_seq FROM oraddman.tsa01_oem_data_type a where data_type=? and data_code=? and status_flag=?) d"+
                     " where a.vendor_id= b.vendor_id "+
                     " and b.vendor_site_id= c.vendor_site_id(+) "+
                     " and A.ENABLED_FLAG=? "+
                     " and (b.INACTIVE_DATE IS NULL or trunc(b.INACTIVE_DATE)>trunc(sysdate)) "+
                     " and b.PURCHASING_SITE_FLAG=?"+
                     " and a.vendor_id=d.data_seq";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"WIP_TYPE");
		statement.setString(2,WIP_TYPE);
		statement.setString(3,"A");
		statement.setString(4,"Y");
		statement.setString(5,"Y");
		ResultSet rs=statement.executeQuery();
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE bordercolor='#CCCCCC'>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount-3;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		int queryCount=0;
		String buttonContent=null;
		while (rs.next())
		{
			queryCount++;	
			buttonContent="this.value=sendToMainWindow("+queryCount+")";							
			//out.println(buttonContent);
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount-3;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT>");
				if (i==2)
				{
					out.println("<input type='hidden' name='VENDOR_"+queryCount+"' value='"+rs.getString(2)+"'>");
					out.println("<input type='hidden' name='VENDORNAME_"+queryCount+"' value='"+rs.getString(8)+"'>");
				}
				else if (i==3)
				{
					out.println("<input type='hidden' name='VENDORCONTACT_"+queryCount+"' value='"+(rs.getString(3)==null?"":rs.getString(3))+"'>");
				}
				else if (i==4)
				{
					out.println("<input type='hidden' name='CURRENCYCODE_"+queryCount+"' value='"+rs.getString(4)+"'>");
					out.println("<input type='hidden' name='VENDORSITEID_"+queryCount+"' value='"+rs.getString(5)+"'>"); 
					out.println("<input type='hidden' name='VENDORID_"+queryCount+"' value='"+rs.getString(6)+"'>"); 
					out.println("<input type='hidden' name='VENDORCODE_"+queryCount+"' value='"+rs.getString(7)+"'>"); 
				}
				out.println("</TD>");
			} 
			out.println("</TR>");
		} 
		out.println("</TABLE>");						
		rs.close();  
		statement.close();

	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     %>
		    <script LANGUAGE="JavaScript">	
				sendToMainWindow(1);	
            </script>
		 <%
	    }
		
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>
 <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
