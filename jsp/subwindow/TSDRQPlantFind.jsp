<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String sourcePlant=request.getParameter("PLANTCODE");
if (sourcePlant == null) sourcePlant = "";
String salesAreaCode=request.getParameter("SALESAREANO");
String invItem=request.getParameter("INVITEM");
String custName=request.getParameter("CUSTNAME");
String CRD=request.getParameter("CRD");
if (CRD==null) CRD="";
String SHIPPINGMETHOD=request.getParameter("SHIPPINGMETHOD");
if (SHIPPINGMETHOD==null) SHIPPINGMETHOD="";
String MARKETGROUP=request.getParameter("MARKETGP");
if (MARKETGROUP==null) MARKETGROUP="";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(PLANTCODE,ORIGPLANT)
{ 
  window.opener.document.MYFORM.PLANTCODE.value=PLANTCODE;
  if (window.opener.document.MYFORM.showCRD.value=="Y" && PLANTCODE != ORIGPLANT)
  {
  	window.opener.document.MYFORM.REQUESTDATE.value="";
	window.opener.document.MYFORM.LINEODRTYPE.value="";    //add by Peggy 20120305  
	window.opener.document.MYFORM.LINETYPE.value="";       //add by Peggy 20120305
  	//window.opener.document.MYFORM.PLANTCODE.focus();//要觸發plantcode onblur事件,故做兩次focus
	window.opener.document.MYFORM.ORDERQTY.focus();
  }
  else
  {
  	window.opener.document.MYFORM.ORDERQTY.focus();
  }
  this.window.close();
}
</script>
<title>Page for choose Plant Code List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSDRQPlantFind.jsp">
<BR>
<%  
	Statement statement=con.createStatement();
	try
    { 
		String sql = " SELECT distinct y.manufactory_no AS \"PLANT CODE\", y.manufactory_name NAME"+
                     " FROM (SELECT a.plant_list plantcode FROM oraddman.tscust_outsource_setup a"+
                     " WHERE sales_region = '001' AND outsource_flag = 'N'"+
                     " AND UPPER ('"+custName+"') LIKE a.cust_group || '%'"+
                     " AND package_group = tsc_om_category ((SELECT inventory_item_id FROM inv.mtl_system_items_b"+
                     " WHERE organization_id = 49 AND segment1 = '"+invItem+"' and rownum=1),49,'TSC_Package')"+
                     " UNION ALL"+
                     " SELECT msi.attribute3 plantcode FROM inv.mtl_system_items_b msi"+
                     " WHERE msi.organization_id = 49 AND msi.segment1 = '"+invItem+"'"+
					 " UNION ALL"+
                     " SELECT a.plant_list plantcode"+
                     " FROM oraddman.tscust_outsource_setup a"+
                     " WHERE sales_region = 'ALL'"+
                     " AND outsource_flag = 'N'"+
                     " AND  a.cust_group = '"+ MARKETGROUP+ "') x,oraddman.tsprod_manufactory y"+
                     " WHERE x.plantcode= y.manufactory_no";
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1];        
		out.println("<TABLE>");      
		out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;</TH>");        
		for (int i=1;i<=colCount;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>"+colLabel[i]+"</TH>");
		} //end of for 
		out.println("</TR>");
		String PLANT=null;
		String buttonContent=null;
		while (rs.next())
		{
			PLANT=rs.getString("PLANT CODE");
			buttonContent="this.value=sendToMainWindow("+'"'+PLANT+'"'+','+'"'+sourcePlant+'"'+")";		
			out.println("<TR BGCOLOR='E3E3CF'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
			out.println("' onClick='"+buttonContent+"'></TD>");		
			for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				String s=(String)rs.getString(i);
				out.println("<TD align='left'><FONT SIZE=2  color='black'>"+((s==null)?"&nbsp;":s)+"</FONT></TD>");
			} //end of for
			out.println("</TR>");	
		} //end of while
		out.println("</TABLE>");						
	
		rs.close();       
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
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
