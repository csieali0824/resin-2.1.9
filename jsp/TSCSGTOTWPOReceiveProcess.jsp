<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>SG TOTW Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCSGTOTWPOReceiveProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="",INVOICE_NO="",trx_no="";

try
{
	String chk[]= request.getParameterValues("chk");	
	if (chk.length <=0)
	{
		throw new Exception("No data found!!");
	}
	
	Statement statement1=con.createStatement();
	ResultSet rs1=statement1.executeQuery(" SELECT APPS.SG_TOTW_PO_RECEIVE_S.nextval from dual");
	if (rs1.next())
	{
		trx_no = rs1.getString(1);
	}
	else
	{
		throw new Exception("trx no get value fail!!");
	}
	rs1.close();
	statement1.close();	
		
	for(int i=0; i< chk.length ;i++)
	{
		sql = " INSERT INTO  oraddman.tssg_po_receive_tw"+
		      "("+
		      " invoice_no"+
		      ",tew_advise_no"+
			  ",advise_no"+
			  ",advise_header_id"+
			  ",advise_line_id"+
			  ",carton_no"+
			  ",so_no"+
			  ",so_line_number"+
			  ",so_header_id"+
			  ",so_line_id"+
			  ",organization_id"+
			  ",subinventory"+
			  ",inventory_item_id"+
			  ",item_no"+
			  ",lot"+
			  ",date_code"+
			  ",qty"+
			  ",creation_date"+
			  ",created_by"+
			  ",last_update_date"+
			  ",last_updated_by"+
			  ",receive_date"+
			  ",sg_lot"+         
			  ",sg_date_code"+   
			  ",sg_qty"+        
			  ",trx_no"+  
			  ",selling_price"+
			  ",vendor_site_id"+
			  ",vendor_id"+
			  ",currency_code"+
			  ",process_flag"+
			  ",lot_expiration_date"+
			  ",dc_yyww"+ //add by Peggy 20220726
			  ")"+
			  " SELECT ?"+  
			  ",a.tew_advise_no"+
			  ",b.advise_no"+
			  ",a.advise_header_id"+
			  ",a.advise_line_id"+
			  ",?"+  
			  ",a.so_no"+
			  ",a.so_line_number"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",?"+
			  ",?"+  
			  ",a.inventory_item_id"+
			  ",a.item_no"+
			  ",?"+  
			  ",?"+  //datecode
			  ",?"+  //qty
			  ",sysdate"+
			  ",?"+  //created_by
			  ",sysdate"+
			  ",?"+
			  ",to_date(?,'yyyymmdd')"+
			  ",?"+                      //SG_LOT
			  ",?"+                      //SG_DATE_CODE
			  ",?"+                      //SG_QTY
			  ",'SGTW#'||?||'-'||(SELECT COUNT(1)+1 FROM oraddman.tssg_po_receive_tw y where TRX_NO like 'SGTW#"+trx_no+"-%') "+  //TRX_NO
			  ",c.unit_selling_price/1000 unit_selling_price"+
			  ",d.vendor_site_id"+
			  ",d.vendor_id"+
			  ",e.currency_code transactional_curr_code"+
			  ",?"+
			  ",(SELECT D_DATE FROM TABLE(tsc_get_item_date_info(?,a.item_no)) WHERE D_TYPE='VALID')"+
			  ",?"+ //add by Peggy 20220726
              " FROM tsc.tsc_shipping_advise_lines a"+
			  ",tsc.tsc_shipping_advise_headers b"+
			  //",ont.oe_order_lines_all c"+
			  ",tsc_sg_invoice_lines c"+
			  ",ap.ap_supplier_sites_all d"+
			  //",ont.oe_order_headers_all e"+
			  ",tsc_sg_invoice_headers e"+
              " where a.advise_header_id=b.advise_header_id"+
			  //" and a.so_line_id=c.line_id"+
			  " and a.so_line_id=c.order_line_id"+
			  " and d.vendor_site_id=?"+
			  " and c.invoice_no=e.invoice_no"+
			  " and a.advise_line_id=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,request.getParameter("INVOICE_"+chk[i]));
		pstmtDt.setString(2,request.getParameter("CARTON_"+chk[i]));
		pstmtDt.setString(3,request.getParameter("ORGCODE"));
		pstmtDt.setString(4,request.getParameter("STOCK_"+chk[i]));
		pstmtDt.setString(5,request.getParameter("LOT_"+chk[i]));
		pstmtDt.setString(6,(request.getParameter("DC_"+chk[i])==null?"":request.getParameter("DC_"+chk[i])));
		pstmtDt.setString(7,request.getParameter("QTY_"+chk[i]));
		pstmtDt.setString(8,UserName);
		pstmtDt.setString(9,UserName);
		pstmtDt.setString(10,request.getParameter("RECEIVE_DATE"));
		pstmtDt.setString(11,request.getParameter("SG_LOT_"+chk[i]));
		pstmtDt.setString(12,(request.getParameter("SG_DC_"+chk[i])==null?"":request.getParameter("SG_DC_"+chk[i])));
		pstmtDt.setString(13,request.getParameter("SG_QTY_"+chk[i]));
		pstmtDt.setString(14,trx_no);  
		pstmtDt.setString(15,"W");  
		pstmtDt.setString(16,(request.getParameter("DC_"+chk[i])==null?"":request.getParameter("DC_"+chk[i])));
		pstmtDt.setString(17,(request.getParameter("DC_YYWW_"+chk[i])==null?"":request.getParameter("DC_YYWW_"+chk[i]))); //add by
		pstmtDt.setString(18,"280966");  
		pstmtDt.setString(19,request.getParameter("ADVISE_LINE_ID_"+chk[i]));
		pstmtDt.executeQuery();
		pstmtDt.close();
		if (i==0) INVOICE_NO =request.getParameter("INVOICE_"+chk[i]); 
	}	
	
	CallableStatement cs1 = con.prepareCall("{call tssg_rcv_pkg.tsc_rcv_job(?,?)}");
	cs1.setString(1,INVOICE_NO); 	
	cs1.setString(2,UserName);
	cs1.execute();
	cs1.close();
	con.commit();
	
	out.println("<table width='80%' align='center'>");
	out.println("<tr><td align='center' colspan='2'><div align='cneter' style='font-weight:bold;color:#0000ff;font-size:16px'>Success!!</DIV></td></tr>");
	out.println("<tr><td align='center' colspan='2'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
	%>
	<jsp:getProperty name="rPH" property="pgHOME"/>
	<%
	out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	out.println("<a href='TSCSGTOTWPOReceiveQuery.jsp'>SG ToTW Query</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TSCSGTOTWPOReceive.jsp'>Continue to next</a></td></tr>");
	out.println("</table>");		
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>Fail!Please contact the sysdate administrator!!<br>"+e.getMessage()+"<br><br><a href='TSCSGTOTWPOReceive.jsp'>SG ToTW Acceptance</a></font>");
}

%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

