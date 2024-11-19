<!-- modify by Peggy 20160614,�^T�q���ѤѬz�X�f�禬,1131,1141�JI1 15��,1121�JI20 40�ܵM����^I1 15��-->
<%@ page contentType="text/html; charset=utf-8" pageEncoding="big5" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TEW TO TW PO RECEIVE Process</title>
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
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<FORM ACTION="TEWTOTWPOReceiveProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="",INVOICE_NO="",trx_no="";

try
{
	String chk[]= request.getParameterValues("chk");	
	if (chk.length <=0)
	{
		throw new Exception("�L���f���!!");
	}
	
	Statement statement1=con.createStatement();
	ResultSet rs1=statement1.executeQuery(" SELECT APPS.TEWPO_RECEIVE_TW_S.nextval from dual");
	if (rs1.next())
	{
		trx_no = rs1.getString(1);
	}
	else
	{
		throw new Exception("trx no���o����!!");
	}
	rs1.close();
	statement1.close();	
		
	for(int i=0; i< chk.length ;i++)
	{
		sql = " INSERT INTO  oraddman.tewpo_receive_tw("+
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
			  ",po_no"+
			  ",po_header_id"+
			  ",po_line_location_id"+
			  ",creation_date"+
			  ",created_by"+
			  ",last_update_date"+
			  ",last_updated_by"+
			  ",receive_date"+
			  ",RECEIPT_NUM"+     //add by Peggy 20160614
			  ",TEW_LOT"+         //add by Peggy 20160614
			  ",TEW_DATE_CODE"+   //add by Peggy 20160614
			  ",TEW_QTY"+         //add by Peggy 20160614  
			  ",TRX_NO"+          //add by Peggy 20160614 
			  ")"+
			  " SELECT ?"+  //invoice no
			  ",a.tew_advise_no"+
			  ",b.advise_no"+
			  ",a.advise_header_id"+
			  ",a.advise_line_id"+
			  ",?"+  //carton
			  ",a.so_no"+
			  ",a.so_line_number"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",a.organization_id"+
			  ",?"+  //subinventory
			  ",a.inventory_item_id"+
			  ",a.item_no"+
			  ",?"+  //lot
			  ",?"+  //datecode
			  ",?"+  //qty
			  ",?"+  //po_no
			  ",?"+  //po_header_id
			  ",?"+  //po_line_location_id
			  ",sysdate"+
			  ",?"+  //created_by
			  ",sysdate"+
			  ",?"+
			  ",to_date(?,'yyyymmdd')"+
			  ",case when c.RECEIPT_NUM='�^T�q��' then null else c.RECEIPT_NUM end "+ //add by Peggy 20160614
			  ",?"+                      //TEW_LOT,add by Peggy 20160614
			  ",?"+                      //TEW_DATE_CODE,add by Peggy 20160614
			  ",?"+                      //TEW_QTY,add by Peggy 20160614
			  ",'TW#'||?||'-'||(SELECT COUNT(1)+1 FROM oraddman.tewpo_receive_tw y where TRX_NO like 'TW#"+trx_no+"-%') "+  //TRX_NO,add by Peggy 20160614
              " FROM tsc.tsc_shipping_advise_lines a"+
			  ",tsc.tsc_shipping_advise_headers b"+
			  ",(select advise_header_id,advise_line_id, RECEIPT_NUM from tsc.tsc_pick_confirm_lines group by advise_header_id,advise_line_id, RECEIPT_NUM)  c"+ //add by Peggy 20160614
              " where a.advise_header_id=b.advise_header_id"+
			  " and a.advise_header_id=c.advise_header_id"+  //add by Peggy 20160614
			  " and a.advise_line_id=c.advise_line_id"+  //add by Peggy 20160614
			  " and a.advise_line_id=?";
		//out.println(request.getParameter("ADVISE_LINE_ID_"+chk[i]));
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,request.getParameter("INVOICE_"+chk[i]));
		pstmtDt.setString(2,request.getParameter("CARTON_"+chk[i]));
		pstmtDt.setString(3,request.getParameter("STOCK_"+chk[i]));
		pstmtDt.setString(4,request.getParameter("LOT_"+chk[i]));
		pstmtDt.setString(5,request.getParameter("DC_"+chk[i]));
		pstmtDt.setString(6,request.getParameter("QTY_"+chk[i]));
		pstmtDt.setString(7,request.getParameter("PO_"+chk[i]));
		pstmtDt.setString(8,request.getParameter("PO_HEADER_ID_"+chk[i]));
		pstmtDt.setString(9,request.getParameter("PO_LINE_LOCATION_ID_"+chk[i]));
		pstmtDt.setString(10,UserName);
		pstmtDt.setString(11,UserName);
		pstmtDt.setString(12,request.getParameter("RECEIVE_DATE"));
		pstmtDt.setString(13,request.getParameter("TEW_LOT_"+chk[i]));
		pstmtDt.setString(14,request.getParameter("TEW_DC_"+chk[i]));
		pstmtDt.setString(15,request.getParameter("TEW_QTY_"+chk[i]));
		pstmtDt.setString(16,trx_no);  
		pstmtDt.setString(17,request.getParameter("ADVISE_LINE_ID_"+chk[i]));
		pstmtDt.executeQuery();
		pstmtDt.close();
		if (i==0) INVOICE_NO =request.getParameter("INVOICE_"+chk[i]); 
	}	
	con.commit();
	
	CallableStatement cs1 = con.prepareCall("{call tew_rcv_pkg.SUBMIT_REQ(?)}");
	cs1.setString(1,INVOICE_NO+"(TW#"+trx_no+")"); 	
	cs1.execute();
	cs1.close();
		
	out.println("<table width='80%' align='center'>");
	out.println("<tr><td align='center' colspan='2'><div align='cneter' style='font-weight:bold;color:#0000ff;font-size:16px'>��Ƽg�J���\!!</DIV></td></tr>");
	out.println("<tr><td align='center' colspan='2'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
	%>
	<jsp:getProperty name="rPH" property="pgHOME"/>
	<%
	out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
	out.println("<a href='TEWTOTWPOReceiveQuery.jsp'>�^T�禬��Ƭd�ߥ\��</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href='TEWTOTWPOReceive.jsp'>�~���禬�U�@��</a></td></tr>");
	out.println("</table>");		
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>�������,�гt���t�κ޲z�H��,����!!<br>"+e.getMessage()+"<br><br><a href='TEWTOTWPOReceive.jsp'>�^T�q���禬�@�~</a></font>");
}

%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

