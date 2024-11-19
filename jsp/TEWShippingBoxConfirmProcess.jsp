<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>TEW Shipping Box Confirm Process</title>
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
<FORM ACTION="TEWShippingBoxConfirmProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String ADVISE_NO = request.getParameter("ADVISE_NO");
if (ADVISE_NO==null) ADVISE_NO="";
String ADVISE_NO_LIST=request.getParameter("ADVISE_NO_LIST");
if (ADVISE_NO_LIST==null) ADVISE_NO_LIST="";
String ERPUSERID = request.getParameter("ERPUSERID");
String ADVISE_HEADER_ID ="",TSC_ADVISE_NO = "";
String TYPE=request.getParameter("TYPE");
if (TYPE==null) TYPE="";
int iCnt=0;

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{
	if (TYPE.equals("DELETE"))
	{
		String chk[]= request.getParameterValues("chk1");	
		if (chk.length <=0)
		{
			throw new Exception("無編箱交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{
			sql = " SELECT  count(1) from tsc.tsc_shipping_advise_lines a where exists (select 1 from TSC_SHIPPING_ADVISE_LINES b where b.advise_line_id="+chk[i]+" and b.advise_header_id=a.advise_header_id)";
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(sql);
			if (rs1.next())
			{
				if (rs1.getInt(1)==1)
				{
					PreparedStatement pstmtDt=con.prepareStatement("delete TSC_SHIPPING_ADVISE_HEADERS a where exists (select 1 from TSC_SHIPPING_ADVISE_LINES b where b.advise_header_id = a.advise_header_id and b.advise_line_id=?)");  
					pstmtDt.setString(1,chk[i]);
					pstmtDt.executeQuery();
					pstmtDt.close();
				}
				PreparedStatement pstmtDt=con.prepareStatement("delete TSC_SHIPPING_ADVISE_LINES a where a.advise_line_id=?");  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
			}
			rs1.close();
			statement1.close();	
		
			if (Float.parseFloat(request.getParameter("CARTON_QTY_"+chk[i])) >0)  //add by Peggy 20160608
			{
				PreparedStatement pstmtDt=con.prepareStatement("update tsc.tsc_shipping_advise_pc_tew a set ADVISE_NO=NULL,ORIG_ADVISE_NO=NULL,SEQ_NO=NULL  where a.PC_ADVISE_ID=?");  
				pstmtDt.setString(1,request.getParameter("PC_ADVISE_ID_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();	
			}			
		}	
		con.commit();	
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料已刪除!!");
			setSubmit("../jsp/TEWShippingBoxHistoryQuery.jsp");
		</script>
	<%					
	}
	else
	{
		if (ADVISE_NO_LIST.equals(""))
		{
			throw new Exception("無編箱資料!!");
		}
		String chk[]= request.getParameterValues("chk1");	
		if (chk.length <=0)
		{
			throw new Exception("無編箱交易!!");
		}
		
		sql = " select pc_advise_id,tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id) GROUP_BY FROM tsc.tsc_shipping_advise_pc_tew  WHERE ORIG_ADVISE_NO in ("+ADVISE_NO_LIST+") order by GROUP_BY";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		//statement.setString(1,ADVISE_NO_LIST);
		ResultSet rs=statement.executeQuery();
		String str_group="";
		while (rs.next())
		{
			iCnt ++;
			if (!rs.getString("GROUP_BY").equals(str_group))
			{
				str_group = rs.getString("GROUP_BY");
				
				sql = " select advise_header_id from (select ADVISE_HEADER_ID,pc_advise_id FROM tsc.tsc_shipping_advise_LINES  WHERE TEW_ADVISE_NO =?) a"+
                      " where tew_rcv_pkg.GET_ADVISE_GROUP_VALUE(pc_advise_id)=?";
				PreparedStatement statement6 = con.prepareStatement(sql);
				statement6.setString(1,ADVISE_NO);
				statement6.setString(2,str_group);
				ResultSet rs6=statement6.executeQuery();
				if (rs6.next())
				{
					ADVISE_HEADER_ID = rs6.getString(1);
				}
				else
				{
					sql = " SELECT tsc_shipping_advise_headers_s.nextval from dual";
					Statement statement1=con.createStatement();
					ResultSet rs1=statement1.executeQuery(sql);
					if (rs1.next())
					{
						ADVISE_HEADER_ID = rs1.getString(1);
					}
					rs1.close();
					statement1.close();	
				
					sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
					Statement statement7=con.createStatement();
					ResultSet rs7=statement7.executeQuery(sql);
					if (rs7.next())
					{
						TSC_ADVISE_NO = rs7.getString(1);
					}
					else
					{
						sql = " insert into tsc.tsc_shipping_advise_no(shipping_date, seq_no) values (trunc(sysdate),1)";
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						pstmtDt.executeUpdate();
						pstmtDt.close();	
						
						sql = " select to_char(trunc(sysdate),'yyyymmdd') || lpad(seq_no,3,0) from tsc_shipping_advise_no where shipping_date = trunc(sysdate)";
						statement1=con.createStatement();
						rs1=statement1.executeQuery(sql);
						if (rs1.next())
						{
							TSC_ADVISE_NO = rs1.getString(1);
						}	
						rs1.close();
						statement1.close();	
					}
					rs7.close();
					statement7.close();
					
					if (!TSC_ADVISE_NO.equals(""))
					{
						sql = " update tsc.tsc_shipping_advise_no set seq_no = seq_no +1 where shipping_date = trunc(sysdate)";
						PreparedStatement pstmtDt=con.prepareStatement(sql);  
						pstmtDt.executeUpdate();
						pstmtDt.close();				
					}
					else
					{
						throw new Exception("Advise No產生失敗!!");
					}
					
					sql = " insert into tsc.tsc_shipping_advise_headers"+
						  "(advise_header_id"+
						  ",advise_no"+
						  ",comfirm_flag"+
						  ",status"+
						  ",invoice_no"+
						  ",customer_id"+
						  ",shipping_method"+
						  ",shipping_from"+
						  ",fob_code"+
						  ",payment_term_id"+
						  ",payment_term"+
						  ",ship_to_org_id"+
						  ",ship_to"+
						  ",invoice_to_org_id"+
						  ",invoice_to"+
						  ",deliver_to_org_id"+
						  ",deliver_to"+
						  ",tax_code"+
						  ",ship_to_contact_id"+
						  ",currency_code"+
						  ",po_no"+
						  ",shipping_remark"+
						  ",post_fix_code"+
						  ",file_id"+
						  ",dn_flag"+
						  ",last_update_date"+
						  ",last_updated_by"+
						  ",creation_date"+
						  ",created_by"+
						  ",last_update_login"+
						  ",to_tw)"+
						  " SELECT ?,?, 'Y','0','' invoice_no, a.customer_id, a.shipping_method, a.shipping_from,"+
						  "       a.fob_code, a.payment_term_id, a.payment_term, a.ship_to_org_id, a.ship_to, a.invoice_to_org_id, a.invoice_to,"+
						  "       a.deliver_to_org_id, a.deliver_to, a.tax_code,a.ship_to_contact_id, a.currency_code, a.CUST_PO_NUMBER po_no,"+
						  "       a.shipping_remark, a.post_fix_code, file_id, 'N',sysdate LAST_UPDATE_DATE,? LAST_UPDATED_BY,sysdate CREATION_DATE,? CREATED_BY,'' LAST_UPDATE_LOGIN, a.to_tw"+
						  " FROM tsc.tsc_shipping_advise_pc_tew a "+
						  " WHERE pc_advise_id=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,ADVISE_HEADER_ID);
					pstmtDt.setString(2,TSC_ADVISE_NO);
					pstmtDt.setString(3,ERPUSERID);
					pstmtDt.setString(4,ERPUSERID);
					pstmtDt.setString(5,rs.getString("pc_advise_id"));
					pstmtDt.executeQuery();
					pstmtDt.close();
				}
				rs6.close();
				statement6.close();
			}
			
			for(int i=0; i< chk.length ;i++)
			{
				if (request.getParameter("PC_ADVISE_ID_"+chk[i]).equals(rs.getString("pc_advise_id")))
				{
					sql = " INSERT INTO tsc.tsc_shipping_advise_lines "+
						  "(advise_line_id"+
						  ",advise_header_id"+
						  ",so_header_id"+
						  ",so_line_id"+
						  ",so_no"+
						  ",so_line_number"+
						  ",delivery_detail_id"+
						  ",organization_id"+
						  ",inventory_item_id"+
						  ",item_no"+
						  ",item_desc"+
						  ",product_group"+
						  ",so_qty"+
						  ",ship_qty"+
						  ",onhand_qty"+
						  ",pc_confirm_qty"+
						  ",unship_confirm_qty"+
						  ",uom"+
						  ",schedule_ship_date"+
						  ",pc_schedule_ship_date"+
						  ",net_weight"+
						  ",gross_weight"+
						  ",cube"+
						  ",pc_remark"+
						  ",packing_instructions"+
						  ",shipping_remark"+
						  ",region_code"+
						  ",po_no"+
						  ",carton_num_fr"+
						  ",carton_num_to"+
						  ",type"+
						  ",carton_qty"+
						  ",carton_per_qty"+
						  ",total_qty"+
						  ",tsc_package"+
						  ",tsc_family"+
						  ",pc_advise_id"+
						  ",parent_advise_line_id"+
						  ",file_id"+
						  ",packing_code"+
						  ",last_update_date"+
						  ",last_updated_by"+
						  ",creation_date"+
						  ",created_by"+
						  ",last_update_login"+
						  ",attribute1"+
						  ",attribute2"+
						  ",vendor_site_id"+
						  ",tew_advise_no"+
						  ") "+
						  " SELECT ?,?, a.so_header_id,"+
						  " a.so_line_id, a.so_no, a.so_line_number, a.delivery_detail_id,a.organization_id, a.inventory_item_id, a.item_no, a.item_desc,"+
						  " a.product_group, a.so_qty, ?, a.onhand_qty,a.pc_confirm_qty, a.unship_confirm_qty, a.uom,"+
						  " a.schedule_ship_date, a.pc_schedule_ship_date, ? net_weight, ? gross_weight,? cube, a.pc_remark, a.packing_instructions,"+
						  " a.shipping_remark, a.region_code, a.CUST_PO_NUMBER po_no,"+
						  " ? carton_num_fr,? carton_num_to, 'LINE' type, ? carton_qty, ? carton_per_qty,? total_qty,"+
						  " a.tsc_package, a.tsc_family, a.pc_advise_id, null parent_advise_line_id, a.file_id, a.packing_code,"+
						  " sysdate last_update_date,? last_updated_by, sysdate creation_date,? created_by, null last_update_login, null attribute1, null attribute2,a.vendor_site_id,?"+
						  " FROM tsc.tsc_shipping_advise_pc_tew a   WHERE PC_ADVISE_ID =?";
					//out.println(chk[i]);
					//out.println(ADVISE_HEADER_ID);
					//out.println(ADVISE_NO);
					//out.println(request.getParameter("PC_ADVISE_ID_"+chk[i]));
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,chk[i]);
					pstmtDt.setString(2,ADVISE_HEADER_ID);
					pstmtDt.setString(3,request.getParameter("SHIP_QTY_"+chk[i]));
					pstmtDt.setString(4,request.getParameter("NW_"+chk[i]));;
					pstmtDt.setString(5,request.getParameter("GW_"+chk[i]));
					pstmtDt.setString(6,request.getParameter("CUBE_"+chk[i]));
					pstmtDt.setString(7,request.getParameter("SNO_"+chk[i]));;
					pstmtDt.setString(8,request.getParameter("ENO_"+chk[i]));;
					pstmtDt.setString(9,request.getParameter("TOT_CARTON_NUM_"+chk[i]));
					pstmtDt.setString(10,request.getParameter("CARTON_QTY_"+chk[i]));
					pstmtDt.setString(11,""+ (Long.parseLong(request.getParameter("TOT_CARTON_NUM_"+chk[i]))*Long.parseLong(request.getParameter("CARTON_QTY_"+chk[i]))));
					pstmtDt.setString(12,ERPUSERID);
					pstmtDt.setString(13,ERPUSERID);
					pstmtDt.setString(14,ADVISE_NO);
					pstmtDt.setString(15,request.getParameter("PC_ADVISE_ID_"+chk[i]));
					pstmtDt.executeQuery();
					pstmtDt.close();	
					
					sql = " update tsc.tsc_shipping_advise_pc_tew a"+
						  " set advise_no =(select distinct tew_advise_no from tsc.tsc_shipping_advise_lines b where b.pc_advise_id = ?)"+
						  " where  PC_ADVISE_ID =?";
					//out.println(request.getParameter("PC_ADVISE_ID_"+chk[i]));
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,request.getParameter("PC_ADVISE_ID_"+chk[i]));
					pstmtDt.setString(2,request.getParameter("PC_ADVISE_ID_"+chk[i]));
					pstmtDt.executeQuery();
					pstmtDt.close();	
				}
			}
		}
		rs.close();
		statement.close();			  

		if (iCnt ==0)
		{
			throw new Exception("無編箱交易!!");
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			if (confirm("確認成功!!若要產出Packing文件,請按確定鍵,否則按下取消鍵,回到出貨編箱確認功能!!"))
			{
				window.open("http://ap1.ts.com.tw/tsc_vendor_invoice/tsc_dn_combine.asp");
				setSubmit("../jsp/TEWShippingBoxConfirmQuery.jsp");
			}
			else
			{
				setSubmit("../jsp/TEWShippingBoxConfirmQuery.jsp");
			}		
		</script>
	<%		
	}
}
catch(Exception e)
{	
	con.rollback();
	if (TYPE.equals("DELETE"))
	{
		out.println("<font color='red'>動作失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TEWShippingBoxHistoryQuery.jsp'>回出貨編箱查詢功能</a></font>");
	}
	else
	{	
		out.println("<font color='red'>動作失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"("+sql+")<br><br><a href='TEWShippingBoxConfirmQuery.jsp'>回出貨編箱確認功能</a></font>");
	}
}
String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
PreparedStatement pstmt2=con.prepareStatement(sql2);
pstmt2.executeUpdate(); 
pstmt2.close();		
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

