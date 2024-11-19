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
<title>SG Shipping Box Confirm Process</title>
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
<FORM ACTION="TSCSGShippingBoxConfirmProcess.jsp" METHOD="post" NAME="SUBFORM">
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
String PACK1= request.getParameter("PACK_1");
if (PACK1==null) PACK1="";
String PACK2= request.getParameter("PACK_2");
if (PACK2==null) PACK2="";
int iCnt=0;
String strErr="",v_rpt_name="",v_rpt_name1="";

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

		//檢查是否有批號分配記錄,add by Peggy 20200506
		sql =  " select b.so_no,b.so_line_number,b.item_desc,a.carton_no  from tsc.tsc_pick_confirm_lines a, tsc.tsc_shipping_advise_lines b"+
			   " where a.advise_line_id=b.advise_line_id"+
			   " and b.advise_line_id in (";
		for(int i=0; i< chk.length ;i++)
		{
			sql +=chk[i];
			if (i!=(chk.length-1)) sql +=",";
		}		
		sql += ")";
		
		Statement statement66=con.createStatement();
		ResultSet rs66=statement66.executeQuery(sql);
		while (rs66.next())
		{
			strErr += " MO#"+rs66.getString("so_no")+"  Line#"+rs66.getString("so_line_number") +"  Item#"+rs66.getString("item_desc") +" 第"+rs66.getString("carton_no")+" 箱已批號分配,不可刪除<br>";
		}
		rs66.close();
		statement66.close();
		if (!strErr.equals(""))
		{	
			throw new Exception(strErr);
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
				PreparedStatement pstmtDt=con.prepareStatement("update tsc.tsc_shipping_advise_pc_sg a set ADVISE_NO=NULL,ORIG_ADVISE_NO=NULL,SEQ_NO=NULL  where a.PC_ADVISE_ID=?");  
				pstmtDt.setString(1,request.getParameter("PC_ADVISE_ID_"+chk[i]));
				pstmtDt.executeQuery();
				pstmtDt.close();	
			}			
		}	
		con.commit();	
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("資料已刪除!!");
			setSubmit("../jsp/TSCSGShippingBoxHistoryQuery.jsp");
		</script>
	<%					
	}
	else if (TYPE.equals("REVISE"))
	{
		String chk[]= request.getParameterValues("chk2");
		String strpack="";	
		if (chk.length <=0)
		{
			throw new Exception("無編箱交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{
			PreparedStatement pstmtDt=con.prepareStatement("update TSC_SHIPPING_ADVISE_LINES a set CARTON_NUM_FR=?,CARTON_NUM_TO=?,CUBIC_METER=?,GROSS_WEIGHT=?,NET_WEIGHT=?,CUBE=?,last_update_date=sysdate, last_updated_by=? where a.advise_line_id=?");  
			pstmtDt.setString(1,request.getParameter("SNO_"+chk[i]));
			pstmtDt.setString(2,request.getParameter("ENO_"+chk[i]));
			pstmtDt.setString(3,(request.getParameter("CBM_"+chk[i])==null?"0":request.getParameter("CBM_"+chk[i])));
			pstmtDt.setString(4,(request.getParameter("GW_"+chk[i])==null?"0":request.getParameter("GW_"+chk[i])));
			pstmtDt.setString(5,(request.getParameter("NW_"+chk[i])==null?"0":request.getParameter("NW_"+chk[i])));
			strpack=request.getParameter("rdo_"+chk[i]);
			if (strpack.equals("0"))
			{
				pstmtDt.setString(6,(request.getParameter("CUBE_"+chk[i])==null?"0":request.getParameter("CUBE_"+chk[i])));
			}
			else if (strpack.equals("1"))
			{
				pstmtDt.setString(6,PACK1);
			}
			else if (strpack.equals("2"))
			{
				pstmtDt.setString(6,PACK2);
			}
			else
			{
				pstmtDt.setString(6,"");
			}
			pstmtDt.setString(7,ERPUSERID); //add by Peggy 20201211
			pstmtDt.setString(8,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();	
		}	
		
		//防呆檢查,add by Peggy 20200506
		sql = " select x.* from (select a.SO_NO,a.so_line_number,a.ITEM_DESC,a.SHIP_QTY/1000 ship_qty,nvl((select sum(TOTAL_QTY) from  tsc.tsc_shipping_advise_lines b where b.tew_advise_no=a.advise_no and b.pc_advise_id=a.pc_advise_id),0)/1000 advise_qty"+
			  " from tsc.tsc_shipping_advise_pc_sg a"+
			  " where a.advise_no='"+ADVISE_NO+"') x"+
			  " where x.SHIP_QTY<>x.advise_qty ";
		Statement statement66=con.createStatement();
		ResultSet rs66=statement66.executeQuery(sql);
		while (rs66.next())
		{
			strErr += " MO#"+rs66.getString("so_no")+"  Line#"+rs66.getString("so_line_number") +"  Item#"+rs66.getString("item_desc") +" 編箱數量:"+rs66.getString("advise_qty")+"K 不等於PC排定出貨量:"+rs66.getString("ship_qty")+"K<br>";
		}
		rs66.close();
		statement66.close();						  
		if (!strErr.equals(""))
		{	
			throw new Exception(strErr);
		}	
		
		//防呆檢查,不同嘜頭不可合併同箱,add by Peggy 20220329
		sql = " SELECT CARTON_NUM_FR,CARTON_NUM_TO,COUNT(DISTINCT SHIPPING_REMARK) "+
		      " FROM tsc.tsc_shipping_advise_lines a"+
              " WHERE TEW_ADVISE_NO='"+ADVISE_NO+"'"+
              " GROUP BY CARTON_NUM_FR,CARTON_NUM_TO"+
              " HAVING COUNT(DISTINCT SHIPPING_REMARK)>1";
		statement66=con.createStatement();
		rs66=statement66.executeQuery(sql);
		while (rs66.next())
		{
			strErr += " Carton#"+rs66.getString("CARTON_NUM_FR")+" 不同嘜頭不可合箱<br>";
		}
		rs66.close();
		statement66.close();	
							  
		if (!strErr.equals(""))
		{	
			throw new Exception(strErr);
		}				  
  
		//防呆檢查,SIEMENS.SANMINA BULGARIA不同po不可合併同一箱,add by Peggy 20220329
   		sql = " SELECT TEW_ADVISE_NO,SHIPPING_REMARK,CARTON_NUM_FR,CARTON_NUM_TO,COUNT(DISTINCT PO_NO) FROM tsc.tsc_shipping_advise_lines a"+
              " WHERE TEW_ADVISE_NO='"+ADVISE_NO+"'"+
			  " AND (INSTR(UPPER(SHIPPING_REMARK),'SIEMENS')>0 OR UPPER(SHIPPING_REMARK) LIKE '%SANMINA%BULGARIA%' OR UPPER(SHIPPING_REMARK) LIKE '%ARCELIK%' OR UPPER(SHIPPING_REMARK) LIKE '%ROBERT%BOSCH%')"+
              " GROUP BY TEW_ADVISE_NO,SHIPPING_REMARK,CARTON_NUM_FR,CARTON_NUM_TO"+
              " HAVING COUNT(DISTINCT PO_NO)>1";
		statement66=con.createStatement();
		rs66=statement66.executeQuery(sql);
		while (rs66.next())
		{
			strErr += " Carton#"+rs66.getString("CARTON_NUM_FR")+" 客戶:"+rs66.getString("SHIPPING_REMARK")+" 不同PO不可合箱<br>";
		}
		rs66.close();
		statement66.close();	
							  
		if (!strErr.equals(""))
		{	
			throw new Exception(strErr);
		}  
  		
		//add by Peggy 20210914	
		CallableStatement cs3 = con.prepareCall("{call apps.TSSG_SHIP_PKG.SG_ADVISE_WEIGHT_CHECK(?)}");
		cs3.setString(1,ADVISE_NO); 
		cs3.execute();
		cs3.close();

		con.commit();	
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("箱號修改完成!!");
			setSubmit("../jsp/TSCSGShippingBoxHistoryQuery.jsp");
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
		
		sql = " select ADVISE_HEADER_ID from tsc.TSC_SHIPPING_ADVISE_HEADERS a where advise_no='"+ADVISE_NO+"'";
		Statement statement6=con.createStatement();
		ResultSet rs6=statement6.executeQuery(sql);
		if (!rs6.next())
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
				  " SELECT ?,ADVISE_NO, 'Y','0','' invoice_no, a.customer_id, a.shipping_method, a.shipping_from,"+
				  "       a.fob_code, a.payment_term_id, a.payment_term, a.ship_to_org_id, a.ship_to, a.invoice_to_org_id, a.invoice_to,"+
				  "       a.deliver_to_org_id, a.deliver_to, a.tax_code,a.ship_to_contact_id, a.currency_code, a.CUST_PO_NUMBER po_no,"+
				  "       a.shipping_remark,?, file_id, 'N',sysdate LAST_UPDATE_DATE,? LAST_UPDATED_BY,sysdate CREATION_DATE,? CREATED_BY,'' LAST_UPDATE_LOGIN, a.to_tw"+
				  " FROM tsc.tsc_shipping_advise_pc_sg a "+
				  " WHERE ADVISE_NO=? and rownum=1";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ADVISE_HEADER_ID);
			pstmtDt.setString(2,request.getParameter("BOX_CODE_"+chk[0]));
			pstmtDt.setString(3,ERPUSERID);
			pstmtDt.setString(4,ERPUSERID);
			pstmtDt.setString(5,ADVISE_NO);
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
		else
		{
			ADVISE_HEADER_ID =rs6.getString(1);
		}	
		rs6.close();
		statement6.close();
			
		for(int i=0; i< chk.length ;i++)
		{
			iCnt ++;
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
				  ",org_id"+
				  ",post_code"+
				  ",cubic_meter"+
				  ") "+
				  " SELECT ?,?, a.so_header_id,"+
				  " a.so_line_id, a.so_no, a.so_line_number, a.delivery_detail_id,a.organization_id, a.inventory_item_id, a.item_no, a.item_desc,"+
				  " a.product_group, a.so_qty, ?, a.onhand_qty,a.pc_confirm_qty, a.unship_confirm_qty, a.uom,"+
				  " a.schedule_ship_date, a.pc_schedule_ship_date, ? net_weight, ? gross_weight,? cube, a.pc_remark, a.packing_instructions,"+
				  " a.shipping_remark, a.region_code, a.CUST_PO_NUMBER po_no,"+
				  " ? carton_num_fr,? carton_num_to, 'LINE' type, ? carton_qty, ? carton_per_qty,? total_qty,"+
				  " a.tsc_package, a.tsc_family, a.pc_advise_id, null parent_advise_line_id, a.file_id, a.packing_code,"+
				  " sysdate last_update_date,? last_updated_by, sysdate creation_date,? created_by, null last_update_login, null attribute1, null attribute2,a.vendor_site_id,?,org_id,?,?"+
				  " FROM tsc.tsc_shipping_advise_pc_sg a   WHERE PC_ADVISE_ID =?";
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
			pstmtDt.setString(15,request.getParameter("BOX_CODE_"+chk[i]));
			pstmtDt.setString(16,request.getParameter("CBM_"+chk[i]));
			pstmtDt.setString(17,request.getParameter("PC_ADVISE_ID_"+chk[i]));
			pstmtDt.executeQuery();
			pstmtDt.close();	
			
			sql = " SELECT b.CHK_RPT_NAME,b.CHK_PAPER_RPT_NAME"+
                  " FROM tsc.tsc_shipping_advise_pc_sg b"+
				  " where b.advise_no=?"+
                  " and b.pc_advise_id<>?"+
                  " AND EXISTS(SELECT A.ADVISE_NO,a.shipping_remark,a.inventory_item_id,a.item_no,a.item_desc,tsc_get_item_desc_nopacking(a.organization_id,a.inventory_item_id) partno,a.customer_id "+
                  "            FROM tsc.tsc_shipping_advise_pc_sg  a"+
                  "            where a.pc_advise_id=?"+
                  "            and a.INVENTORY_ITEM_ID=b.INVENTORY_ITEM_ID"+
                  "            and a.SHIPPING_REMARK=b.SHIPPING_REMARK"+
                  "            and a.CUSTOMER_ID=b.CUSTOMER_ID)	";
			PreparedStatement statementk = con.prepareStatement(sql);
			statementk.setString(1,ADVISE_NO);
			statementk.setString(2,request.getParameter("PC_ADVISE_ID_"+chk[i]));
			statementk.setString(3,request.getParameter("PC_ADVISE_ID_"+chk[i]));
			ResultSet rsk=statementk.executeQuery();
			if (rsk.next())			  
			{	
				v_rpt_name = rsk.getString("CHK_RPT_NAME");
				v_rpt_name1 = rsk.getString("CHK_PAPER_RPT_NAME");	
			}
			else
			{
				v_rpt_name ="";v_rpt_name1 ="";
			}
			rsk.close();	
			statementk.close();
			

			sql = " update tsc.tsc_shipping_advise_pc_sg a"+
				  " set advise_no =(select distinct tew_advise_no from tsc.tsc_shipping_advise_lines b where b.pc_advise_id = ?)"+
				  ",CHK_RPT_NAME=nvl(?,CHK_RPT_NAME)"+
				  ",CHK_PAPER_RPT_NAME=nvl(?,CHK_PAPER_RPT_NAME)"+
				  ",post_fix_code=?"+
				  " where  PC_ADVISE_ID =?";
			//out.println(request.getParameter("PC_ADVISE_ID_"+chk[i]));
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("PC_ADVISE_ID_"+chk[i]));
			pstmtDt.setString(2,v_rpt_name); //add by Peggy 20210422
			pstmtDt.setString(3,v_rpt_name1); //add by Peggy 20210422
			pstmtDt.setString(4,request.getParameter("BOX_CODE_"+chk[i])); //add by Peggy 20200608
			pstmtDt.setString(5,request.getParameter("PC_ADVISE_ID_"+chk[i]));
			pstmtDt.executeQuery();
			pstmtDt.close();			
		}
			
		//防呆檢查,add by Peggy 20200506
		sql = " select x.* from (select a.SO_NO,a.so_line_number,a.ITEM_DESC,a.SHIP_QTY/1000 ship_qty,nvl((select sum(TOTAL_QTY) from  tsc.tsc_shipping_advise_lines b where b.tew_advise_no=a.advise_no and b.pc_advise_id=a.pc_advise_id),0)/1000 advise_qty"+
			  " from tsc.tsc_shipping_advise_pc_sg a"+
			  " where a.advise_no='"+ADVISE_NO+"') x"+
			  " where x.SHIP_QTY<>x.advise_qty ";
		Statement statement66=con.createStatement();
		ResultSet rs66=statement66.executeQuery(sql);
		while (rs66.next())
		{
			strErr += " MO#"+rs66.getString("so_no")+"  Line#"+rs66.getString("so_line_number") +"  Item#"+rs66.getString("item_desc") +" 編箱數量:"+rs66.getString("advise_qty")+"K 不等於PC排定出貨量:"+rs66.getString("ship_qty")+"K<br>";
		}
		rs66.close();
		statement66.close();						  
		if (!strErr.equals(""))
		{	
			throw new Exception(strErr);
		}			

		if (iCnt ==0)
		{
			throw new Exception("無編箱交易!!");
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			//if (confirm("確認成功!!若要產出Packing文件,請按確定鍵,否則按下取消鍵,回到出貨編箱確認功能!!"))
			//{
			//	window.open("http://ap1.ts.com.tw/tsc_vendor_invoice/tsc_dn_combine.asp");
			//	setSubmit("../jsp/TSCSGShippingBoxConfirmQuery.jsp");
			//}
			//else
			//{
				alert("Success!!");
				setSubmit("../jsp/TSCSGShippingBoxConfirmQuery.jsp");
			//}		
		</script>
	<%		
	}
}
catch(Exception e)
{	
	con.rollback();
	if (TYPE.equals("DELETE") || TYPE.equals("REVISE"))
	{
		out.println("<font color='red'>動作失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGShippingBoxHistoryQuery.jsp'>回出貨編箱查詢功能</a></font>");
	}
	else
	{	
		out.println("<font color='red'>動作失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGShippingBoxConfirmQuery.jsp'>回出貨編箱確認功能</a></font>");
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

