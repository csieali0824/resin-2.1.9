<!-- 20180207 Peggy,供應商=蘇固且訂單類型=1142,訂單類型自動轉換為1141, FOB設定為FOB TAIWAN-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.text.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%
String sql = "";
String ITEMID= request.getParameter("ITEMID");
if (ITEMID==null ) ITEMID="";
String LINENO = request.getParameter("LINENO");
if (LINENO==null) LINENO="";
String rfqno = request.getParameter("rfqno"); //add by Peggy 20180207
if (rfqno==null) rfqno="";
String PG = request.getParameter("PG"); //add by Peggy 20180207
if (PG==null) PG="";
String ORGCODE = request.getParameter("ORG");
if (ORGCODE==null) ORGCODE="";
String VENDOR_SITE_CODE="",VENDOR_SITE_ID="";
%>
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(VendorSiteCode,VendorSiteId)
{ 
	window.opener.document.DISPLAYREPAIR.elements["VENDOR_CODE_"+document.SITEFORM.LINENO.value].value=VendorSiteCode;
	window.opener.document.DISPLAYREPAIR.elements["VENDOR_SITE_ID_"+document.SITEFORM.LINENO.value].value=VendorSiteId;
	window.opener.document.DISPLAYREPAIR.ACTIONID.value=""; //add by Peggy 20180206
	//if (window.opener.document.DISPLAYREPAIR.salesarea.value=="001" && VendorSiteId=="220965" && window.opener.document.DISPLAYREPAIR.elements["order_type_id_"+document.SITEFORM.LINENO.value].value !=1022)
	if (VendorSiteId=="220965" && window.opener.document.DISPLAYREPAIR.elements["order_type_id_"+document.SITEFORM.LINENO.value].value !=1022)
	{
		if (document.SITEFORM.PG.value=="D1003")
		{
  			window.opener.document.DISPLAYREPAIR.action="../jsp/TSSalesDRQEstimatingPage.jsp?LINENO="+document.SITEFORM.LINENO.value+"&DNDOCNO="+document.SITEFORM.rfqno.value+"&TEWTOTW=Y";
		}
		else if (document.SITEFORM.PG.value=="D1004")
		{
  			window.opener.document.DISPLAYREPAIR.action="../jsp/TSSalesDRQArrangedPage.jsp?LINENO="+document.SITEFORM.LINENO.value+"&DNDOCNO="+document.SITEFORM.rfqno.value+"&TEWTOTW=Y";
		}
  		window.opener.document.DISPLAYREPAIR.submit();	
	}
  	this.window.close();
}
</script>
<title>Approval Supplier List</title>
</head>
<body >  
<FORM METHOD="post" ACTION="TSCApprovalSupplierFind.jsp" NAME="SITEFORM">
<input type="hidden" name="ITEMID" value="<%=ITEMID%>">
<input type="hidden" name="LINENO" value="<%=LINENO%>">
<input type="hidden" name="rfqno"  value="<%=rfqno%>">
<input type="hidden" name="ORG"  value="<%=ORGCODE%>">
<input type="hidden" name="PG"  value="<%=PG%>">
<BR>
<%  
	try
    { 
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();		
	
		//sql = " select c.VENDOR_NAME,a.VENDOR_SITE_ID, b.vendor_site_code "+
		//      " from PO_APPROVED_SUPPLIER_LIST a ,ap.ap_supplier_sites_all b,ap.ap_suppliers c "+
        //      " where a.ASL_STATUS_ID ='2' "+
		//  	  " and nvl(a.DISABLE_FLAG,'N') ='N'"+
		// 	  " and a.OWNING_ORGANIZATION_ID=49"+
		// 	  " and a.ITEM_ID='"+ITEMID+"'"+
		//	  " and a.vendor_id=c.vendor_id"+
		// 	  " and a.vendor_site_id = b.vendor_site_id";
		//modify by Peggy 20140806,SSP產生顯示單價,單價由小到大排序
		/*sql = " select c.VENDOR_NAME,a.VENDOR_SITE_ID, b.vendor_site_code ,d.CURRENCY_CODE,nvl(d.unit_price,0) unit_price ,tsc_om_category(a.item_id,a.OWNING_ORGANIZATION_ID,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
              " from PO_APPROVED_SUPPLIER_LIST a ,ap.ap_supplier_sites_all b,ap.ap_suppliers c,"+
              " (select x.vendor_site_id,x.CURRENCY_CODE,y.item_id,y.unit_price from po_headers_all x,po_lines_all y"+
              " where x.TYPE_LOOKUP_CODE='BLANKET'"+
              " and x.ORG_ID=41"+
              " and NVL(x.approved_flag, 'N') in ('Y') "+
              " and NVL(x.cancel_flag,'N') = 'N'"+
              " and NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
              " and NVL(y.cancel_flag,'N') = 'N'"+
              " and NVL(y.closed_code,'OPEN') <> 'CLOSED'"+
              " and NVL(y.closed_flag,'N') <> 'Y'"+               
              " and x.po_header_id=y.po_header_id) d"+
              " where a.ASL_STATUS_ID ='2' "+
              " and nvl(a.DISABLE_FLAG,'N') ='N'"+
              " and a.OWNING_ORGANIZATION_ID=49"+
              " and a.ITEM_ID='"+ITEMID+"'"+
              " and a.vendor_id=c.vendor_id"+
              " and a.vendor_site_id = b.vendor_site_id"+
              " and a.vendor_site_id=d.vendor_site_id(+)"+
              " and a.item_id=d.item_id(+)"+
			  " and (b.inactive_date is null or b.INACTIVE_DATE > trunc(sysdate))"+ //add by Peggy 20150202
              " order by d.unit_price,b.VENDOR_SITE_CODE";*/
		sql = " select distinct c.VENDOR_NAME,b.VENDOR_SITE_ID, ood.organization_id,ood.organization_code,b.vendor_site_code ,d.CURRENCY_CODE,nvl(d.unit_price,0) unit_price ,tsc_om_category(d.item_id,43,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
              " from ap.ap_supplier_sites_all b"+
			  ",ap.ap_suppliers c"+
			  ",hr_locations_v hl"+
			  ",org_organization_definitions ood"+
              ",(select x.ship_to_location_id, x.vendor_site_id,x.CURRENCY_CODE,y.item_id,y.unit_price from po_headers_all x,po_lines_all y"+
              "  where x.TYPE_LOOKUP_CODE='BLANKET'"+
              "  and x.ORG_ID in (?)"+
              //"  and NVL(x.approved_flag, 'N') in ('Y') "+
              "  and NVL(x.cancel_flag,'N') = 'N'"+
              "  and NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
              "  and NVL(y.cancel_flag,'N') = 'N'"+
              "  and NVL(y.closed_code,'OPEN') <> 'CLOSED'"+
              "  and NVL(y.closed_flag,'N') <> 'Y'"+      
              "  and y.item_id =? "+     
              "  and x.po_header_id=y.po_header_id) d"+
              "  where b.vendor_id=c.vendor_id "+
              //"  and b.ship_to_location_id=d.ship_to_location_id"+
              "  and b.vendor_site_id=d.vendor_site_id"+
              "  and b.ship_to_location_id = hl.location_id"+
              "  AND ood.organization_id = hl.inventory_organization_id"+
              "  AND b.org_id  IN (?)"+
              "  and (b.inactive_date is null or b.INACTIVE_DATE > trunc(sysdate))"+
			  "  and ood.organization_code in (?)"+
              "  union all"+
              " select distinct c.VENDOR_NAME,b.VENDOR_SITE_ID, ood.organization_id,ood.organization_code,b.vendor_site_code ,d.CURRENCY_CODE,nvl(d.unit_price,0) unit_price ,tsc_om_category(d.item_id, 43,'TSC_PROD_GROUP') TSC_PROD_GROUP"+
              "  from ap.ap_supplier_sites_all b"+
			  ",ap.ap_suppliers c"+
			  ",hr_locations_all hl"+
			  ",org_organization_definitions ood"+
              ",(select x.ship_to_location_id, x.vendor_site_id,x.CURRENCY_CODE,y.item_id,y.unit_price from po_headers_all x,po_lines_all y"+
              "  where x.TYPE_LOOKUP_CODE='BLANKET'"+
              "  and x.ORG_ID in (?)"+
              //"  and NVL(x.approved_flag, 'N') in ('Y') "+
              "  and NVL(x.cancel_flag,'N') = 'N'"+
              "  and NVL(x.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
              "  and NVL(y.cancel_flag,'N') = 'N'"+
              "  and NVL(y.closed_code,'OPEN') <> 'CLOSED'"+
              "  and NVL(y.closed_flag,'N') <> 'Y'      "+
              "  and y.item_id =?"+  
              "  and x.po_header_id=y.po_header_id) d"+
              "  where b.vendor_id=c.vendor_id "+
              //"  and b.ship_to_location_id=d.ship_to_location_id"+
              "  and b.vendor_site_id=d.vendor_site_id"+
              "  and b.ship_to_location_id = hl.location_id"+
              "  AND ood.organization_id = hl.inventory_organization_id"+
              "  AND b.org_id  IN (?)"+
			  "  and ood.organization_code in (?)"+
              //"  and exists (select 1 from oraddman.tssg_vendor_tw x where x.vendor_site_id=b.VENDOR_SITE_ID and nvl(x.active_flag,'N')='A')"+
              "  and (exists (select 1 from oraddman.tssg_vendor_tw x where x.vendor_site_id=b.VENDOR_SITE_ID and nvl(x.active_flag,'N')='A')"+
              "  or exists (select 1 from inv.mtl_system_items_b x where x.organization_id=49 and x.attribute3='011' and x.inventory_item_id=d.item_id))"+  //add by Peggy 20200406
              "  and (b.inactive_date is null or b.INACTIVE_DATE > trunc(sysdate)) "+                             
              "  order by 7,2";	  
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"906");
		statement.setString(2,ITEMID);
		statement.setString(3,"906");
		statement.setString(4,ORGCODE);
		statement.setString(5,"41");
		statement.setString(6,ITEMID);
		statement.setString(7,"41");
		statement.setString(8,"I1");
		ResultSet rs = statement.executeQuery();	
		//Statement statement=con.createStatement();
		//ResultSet rs=statement.executeQuery(sql);
		int rec_cnt=0;
		while (rs.next())
		{
			if (rec_cnt==0)
			{
%>			
				<TABLE width="80%" border="1" bordercolor="#0099CC" style="font-family:ARIAL;font-size:12px">
					<TR bgcolor="#CCCCCC">
						<TD>&nbsp;</TD>        
						<TD>供應商</TD>        
						<TD>供應商Site</TD>   
				<%
					if (rs.getString("tsc_prod_group").toUpperCase().equals("SSD"))
					{
						out.println("<td>單價</td>");
						out.println("<td>幣別</td>");
					}
				%>     
					</TR>
<%
			}
			VENDOR_SITE_CODE= rs.getString("VENDOR_site_code");
			VENDOR_SITE_ID= rs.getString("VENDOR_site_ID");
%>
			<tr>
				<td><INPUT TYPE="button" NAME="btn<%=rec_cnt+1%>" VALUE='<jsp:getProperty name="rPH" property="pgFetch"/>' onClick="sendToMainWindow('<%=VENDOR_SITE_CODE%>','<%=VENDOR_SITE_ID%>')"></TD>
				<td><%=rs.getString("VENDOR_NAME")%></td>
				<td><%=rs.getString("VENDOR_site_code")%></td>
				<%
					if (rs.getString("tsc_prod_group").toUpperCase().equals("SSD"))
					{
						out.println("<td align='right'>"+(new DecimalFormat("######.###")).format(rs.getFloat("unit_price"))+"</td>");
						out.println("<td align='center'>"+rs.getString("CURRENCY_CODE")+"</td>");
					}
				%>  				
			</tr>
<%
			rec_cnt++;	
		}
		rs.close();   
		statement.close();
		if (rec_cnt>0)
		{
%>		
			</TABLE>
<%
			if (rec_cnt==1)
			{
%>
				<script type="text/javascript">sendToMainWindow('<%=VENDOR_SITE_CODE%>','<%=VENDOR_SITE_ID%>')</script>
<%
			}
		}
		else
		{
			out.println("<font color='red'>查無資料!!!</font>");
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
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
