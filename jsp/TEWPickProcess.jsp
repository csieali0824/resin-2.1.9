<!-- modify by Peggy 20160614,回T訂單改由天津出貨驗收,1131,1141入I1 15倉,1121入I20 40倉然後轉回I1 15倉-->
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
<title>TEW Pick Process</title>
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
<FORM ACTION="TEWPickProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();	

if (TRANSTYPE.equals("ALLOT"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無處理交易!!");
		}
		String ADVISE_NO = request.getParameter("ADVISENO");
		if (ADVISE_NO==null)
		{
			throw new Exception("無Advise No!!");
		}
		
		for(int i=0; i< chk.length ;i++)
		{
			//檢查資料是否已存在
			sql = "select 1 from oraddman.tew_lot_allot_detail a where TEW_ADVISE_NO=? and advise_line_id=? and CARTON_NUM=? and po_line_location_id=? and lot_number=? and seq_id=?";
			//out.println(sql);
			//out.println(ADVISE_NO);
			//out.println(request.getParameter("ADVISE_LINE_ID_"+chk[i]));
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,ADVISE_NO);
			statement1.setString(2,request.getParameter("ADVISE_LINE_ID_"+chk[i]));
			statement1.setString(3,request.getParameter("CARTON_NUM_"+chk[i])); 
			statement1.setString(4,request.getParameter("PO_LINE_LOCATION_ID_"+chk[i])); 
			statement1.setString(5,request.getParameter("LOT_"+chk[i])); 
			statement1.setString(6,request.getParameter("SEQ_ID_"+chk[i])); 
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				throw new Exception("配貨資料已存在,不可重覆作業!!");
			}
			rs1.close();
			statement1.close();	
				
			sql = " insert into oraddman.tew_lot_allot_detail"+
				 	  "(advise_line_id"+         //1
					  ",carton_num"+             //2
					  ",po_line_location_id"+    //3
					  ",lot_number"+             //4
					  ",allot_qty"+              //5 
					  ",tew_advise_no"+          //6 
					  ",advise_header_id"+       //7
					  ",creation_date"+          //8
					  ",created_by"+             //9
					  ",last_update_date"+       //10
					  ",last_updated_by"+        //11
					  ",confirm_flag"+           //12
					  ",PO_HEADER_ID"+           //13
					  ",SEQ_ID)"+                //14
				      " values"+
				      "(?"+                      //1
				      ",?"+                      //2
				      ",?"+                      //3
				      ",?"+                      //4
				      ",?"+                      //5
				      ",?"+                      //6
				      ",?"+                      //7
				      ",sysdate"+                //8
				      ",?"+                      //9
				      ",sysdate"+                //10
				      ",?"+                      //11
				      ",?"+                      //12
				      ",?"+                      //13
					  ",?)";                     //14
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("ADVISE_LINE_ID_"+chk[i]));
			pstmtDt.setString(2,request.getParameter("CARTON_NUM_"+chk[i])); 
			pstmtDt.setString(3,request.getParameter("PO_LINE_LOCATION_ID_"+chk[i]));
			pstmtDt.setString(4,request.getParameter("LOT_"+chk[i]));
			//pstmtDt.setString(5,""+(Float.parseFloat(request.getParameter("LOT_QTY_"+chk[i]))*1000)); 
			pstmtDt.setString(5,request.getParameter("LOT_QTY_"+chk[i])); 
			pstmtDt.setString(6,ADVISE_NO);
			pstmtDt.setString(7,request.getParameter("ADVISE_HEADER_ID_"+chk[i])); 
			pstmtDt.setString(8,UserName);
			pstmtDt.setString(9,UserName);
			pstmtDt.setString(10,"N");
			pstmtDt.setString(11,request.getParameter("PO_HEADER_ID_"+chk[i]));
			pstmtDt.setString(12,request.getParameter("SEQ_ID_"+chk[i]));
			pstmtDt.executeQuery();
			pstmtDt.close();
		}	
		con.commit();
		
		out.println("<table width='80%' align='center'>");
		out.println("<tr><td align='center' colspan='2'><div align='cneter' style='font-weight:bold;color:#0000ff;font-size:16px'>配貨動作成功!!</DIV></td></tr>");
		out.println("<tr><td align='center' colspan='2'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
		%>
		<jsp:getProperty name="rPH" property="pgHOME"/>
		<%
		out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		out.println("<a href='TEWPickAllot.jsp'>回批號分配確認功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TEWPickConfirmExcel.jsp?ADVISENO="+ADVISE_NO+'"'+">下載出貨批號明細表</a></td></tr>");
		out.println("</table>");		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TEWPickAllot.jsp'>回批號分配確認功能</a></font>");
	}
}
else if (TRANSTYPE.equals("PICKCONFIRM"))
{
	String ADVISENO = request.getParameter("ADVISENO");
	if (ADVISENO==null) ADVISENO="";
	String ERPUSERID = request.getParameter("ERPUSERID");
	String SUBINVENTORY = request.getParameter("SUBINVENTORY");
	if (SUBINVENTORY==null) SUBINVENTORY="";
	
	try
	{
		//檢查資料是否已存在
		sql = "select 1 from oraddman.tew_lot_allot_detail a where TEW_ADVISE_NO=? AND confirm_flag=?";
		PreparedStatement statement1 = con.prepareStatement(sql);
		statement1.setString(1,ADVISENO);
		statement1.setString(2,"N");
		ResultSet rs1=statement1.executeQuery();
		if (!rs1.next())
		{
			throw new Exception("撿貨資料已確認,不可重覆作業!!");
		}
		rs1.close();
		statement1.close();
		
		//檢查撿貨與PC排定出貨量是否相等	
 		sql = " SELECT case when ship_qty <> pick_qty then 1 else 0 end "+
              " from (select sum(ship_qty) ship_qty"+
              " ,sum((select sum(qty) from tsc.tsc_pick_confirm_lines b where b.advise_header_id = a.advise_header_id and b.advise_line_id = a.advise_line_id))"+
              " +sum((select sum(allot_qty) from oraddman.tew_lot_allot_detail c where c.advise_header_id = a.advise_header_id and c.advise_line_id = a.advise_line_id and c.confirm_flag<>'Y')) pick_qty "+
              " FROM tsc.tsc_shipping_advise_lines a,tsc_shipping_advise_headers b"+
              " where a.advise_header_id = b.advise_header_id and a.TEW_ADVISE_NO=?)";			
		statement1 = con.prepareStatement(sql);
		statement1.setString(1,ADVISENO);
		rs1=statement1.executeQuery();
		if (rs1.next())
		{
			if (rs1.getInt(1)>0)
			{
				throw new Exception("撿貨數量與出貨通知單數量不相等,請重新確認!!");
			}
		}	
		rs1.close();
		statement1.close();
			
		//檢查庫存			  
		sql = " SELECT a.po_line_location_id, a.lot_number, "+
              " (a.received_quantity -a.shipped_quantity)*1000-allot_qty onhand"+
              " FROM oraddman.tewpo_receive_detail a,(select po_line_location_id,lot_number,seq_id,sum(allot_qty) allot_qty from oraddman.tew_lot_allot_detail b where b.tew_advise_no=? group by po_line_location_id,lot_number,seq_id) b"+
              " where a.po_line_location_id = b.po_line_location_id"+
              " and a.lot_number=b.lot_number"+
			  " and a.seq_id=b.seq_id"+
              " and (a.received_quantity -a.shipped_quantity)*1000-allot_qty<0";
		statement1 = con.prepareStatement(sql);
		statement1.setString(1,ADVISENO);
		rs1=statement1.executeQuery();
		if (rs1.next())
		{
			throw new Exception("LOT:"+rs1.getString("lot_number")+" 庫存不足!!");
		}
		rs1.close();
		statement1.close();
			
		//檢查LOT是否PENDING在修改待核淮的LIST中,add by Peggy 20141204
		sql = " select distinct LOT_NUMBER from oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_revise b"+ 
              " where a.TEW_ADVISE_NO=? and a.po_line_location_id = b.po_line_location_id "+
              " and a.seq_id = b.seq_id and NVL(b.approve_flag,'N')='N'";
		  
		statement1 = con.prepareStatement(sql);
		statement1.setString(1,ADVISENO);
		rs1=statement1.executeQuery();
		String err_msg ="";
		while (rs1.next())
		{
			err_msg +=(!err_msg.equals("")?"<br>":"")+"LOT:"+rs1.getString(1)+" 申請修改等待主管核淮中";
		}
		rs1.close();
		statement1.close();
		if (!err_msg.equals(""))
		{
			throw new Exception(err_msg);
		}
		  
		PreparedStatement pstmtDt=con.prepareStatement("update oraddman.tew_lot_allot_detail set confirm_flag=? where TEW_ADVISE_NO=?");  
		pstmtDt.setString(1,"W");
		pstmtDt.setString(2,ADVISENO);
		pstmtDt.executeQuery();
		pstmtDt.close();
			
		sql = " insert into tsc.tsc_pick_confirm_headers"+
		      "(advise_header_id"+
			  ",advise_no"+
			  ",pick_status"+
			  ",oqc_status"+
			  ",LAST_UPDATE_DATE"+
			  ",LAST_UPDATED_BY"+
			  ",CREATION_DATE"+
			  ",CREATED_BY)"+
			  " select x.advise_header_id"+
			  ",x.advise_no"+
			  ",'Y'"+
			  ",'Y'"+
			  ",sysdate"+
			  ",?"+
			  ",sysdate"+
			  ",? "+
			  " from tsc.tsc_shipping_advise_headers x "+
			  " where exists (select 1 from tsc.tsc_shipping_advise_lines y where x.advise_header_id = y.advise_header_id and y.tew_advise_no=?)";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,ERPUSERID);
		pstmtDt.setString(2,ERPUSERID);
		pstmtDt.setString(3,ADVISENO);
		pstmtDt.executeQuery();
		pstmtDt.close();
				
		sql = " insert into tsc.tsc_pick_confirm_lines"+
		      " (advise_header_id"+
			  ", advise_line_id"+
			  ", oqc_status"+
			  ", carton_no"+
			  ", carton_qty"+
			  ", so_no"+
			  ", so_header_id"+
			  ", so_line_id"+
			  ", organization_id"+
			  ", inventory_item_id"+
			  ", item_no"+
			  ", lot"+
			  ", subinventory"+
			  ", qty"+
			  ", date_code"+
			  ", manufacture_date"+
			  ", effective_date"+
			  ", last_update_date"+
			  ", last_updated_by"+
			  ", creation_date"+
			  ", created_by"+
              ", product_group"+
			  ", onhand_org_id"+
			  ", PO_LINE_LOCATION_ID"+ 
			  ", TEW_ADVISE_NO)"+ 
			  " select b.advise_header_id"+
			  ",b.advise_line_id"+
			  ",'C'"+
			  ",a.carton_num"+
			  ",'1'"+
			  ",b.so_no"+
			  ",b.so_header_id"+
			  ",b.so_line_id"+
			  ",b.organization_id"+
			  ",b.inventory_item_id"+
			  ",b.item_no"+
			  ",a.lot_number"+
			  ",case when nvl(e.to_tw,'N')='Y' and substr(b.SO_NO,1,4) in ('1121') then '40' when nvl(e.to_tw,'N')='Y' and substr(b.SO_NO,1,4) not in ('1121') then '15' else '14' end "+ //add by Peggy 21060614
			  ",a.allot_qty"+
			  ",c.date_code"+
			  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(c.date_code,b.item_no)) where D_TYPE=?) MANUFACTURE_DATE"+
              ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(c.date_code,b.item_no)) where D_TYPE=?) EFFECTIVE_DATE"+
			  ",sysdate"+
			  ",?"+
			  ",sysdate"+
			  ",?"+
			  ",b.PRODUCT_GROUP"+
			  ",d.ORGANIZATION_ID"+
			  ",a.PO_LINE_LOCATION_ID"+
			  ",?"+
              " from oraddman.tew_lot_allot_detail a,tsc.tsc_shipping_advise_lines b,oraddman.tewpo_receive_detail c,oraddman.TEWPO_RECEIVE_HEADER d,tsc.tsc_shipping_advise_headers e"+ //add by Peggy 20160614
              " where b.tew_advise_no=?"+
              " and a.advise_line_id = b.advise_line_id"+
			  " and a.tew_advise_no = b.tew_advise_no"+
              " and a.po_line_location_id = c.po_line_location_id"+
			  " and c.po_line_location_id = d.po_line_location_id"+
              " and a.lot_number=c.lot_number"+
			  " and a.seq_id = c.seq_id"+
			  " and b.advise_header_id=e.advise_header_id"+ //add by Peggy 20160614 
			  " and nvl(a.ALLOT_QTY,0) >0"+
			  " order by a.carton_num";
		pstmtDt=con.prepareStatement(sql);  
		//pstmtDt.setString(1,SUBINVENTORY);
		pstmtDt.setString(1,"MAKE");
		pstmtDt.setString(2,"VALID");
		pstmtDt.setString(3,ERPUSERID);
		pstmtDt.setString(4,ERPUSERID);
		pstmtDt.setString(5,ADVISENO);
		pstmtDt.setString(6,ADVISENO);
		pstmtDt.executeQuery();
		pstmtDt.close();
		    
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("確認成功!!");
			setSubmit("../jsp/TEWPickConfirm.jsp");
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TEWPickConfirm.jsp'>回倉庫撿貨確認功能</a></font>");
	}	
}
else if (TRANSTYPE.equals("SHIPCANCEL"))
{
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無處理交易!!");
		}
		for(int i=0; i< chk.length ;i++)
		{	
			PreparedStatement pstmtDt=con.prepareStatement("delete oraddman.tew_lot_allot_detail where TEW_ADVISE_NO=?");  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_line_id=a.advise_line_id)");  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();			

			pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_headers a where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_header_id=a.advise_header_id)");  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("出貨取消成功!!");
			setSubmit("../jsp/TEWShipConfirm.jsp");
		</script>
	<%		
		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TEWShipConfirm.jsp'>回倉庫出貨確認功能</a></font>");
	}
}
else if (TRANSTYPE.equals("SHIPCONFIRM"))
{
	String ERPUSERID = request.getParameter("ERPUSERID");
	int err_cnt =0;
	//String GROUPID = "";
	try
	{
		String chk[]= request.getParameterValues("chk");	
		if (chk.length <=0)
		{
			throw new Exception("無處理交易!!");
		}
	
		for(int i=0; i< chk.length ;i++)
		{
			try
			{
				//檢查已收未出數量是否滿足此次出貨
				sql = " select count(1)  from (SELECT a.po_line_location_id,a.lot,sum(qty) pick_qty"+
					  " FROM  tsc.tsc_pick_confirm_lines a"+
					  " where a.tew_advise_no=?"+
					  " GROUP BY a.po_line_location_id,a.lot) a,(select po_line_location_id,lot_number,(sum(RECEIVED_QUANTITY)-nvl(sum(SHIPPED_QUANTITY),0))*1000 UNRECEIVE_QTY FROM oraddman.tewpo_receive_detail GROUP BY po_line_location_id,lot_number having sum(RECEIVED_QUANTITY)-nvl(sum(SHIPPED_QUANTITY),0) >0 order by 2) c"+
					  " where a.po_line_location_id = c.po_line_location_id(+)"+
					  " and a.lot=c.lot_number(+)"+
					  " and c.unreceive_qty- pick_qty <0";
				//out.println(sql);
				PreparedStatement statement1 = con.prepareStatement(sql);
				statement1.setString(1,chk[i]);
				ResultSet rs1=statement1.executeQuery();
				if (rs1.next())
				{
					if (rs1.getInt(1) >0)
					{
						throw new Exception("庫存不足!!");
					}
				}
				rs1.close();
				statement1.close();	
				
				//檢查出貨明細與shipping advise是否一致
				sql = " select x.inventory_item_id,sum(x.ship_qty) ship_qty,sum(x.pick_qty) pick_qty "+
                      " from (select b.inventory_item_id,sum(b.ship_qty) ship_qty,0 pick_qty"+
                      " from tsc.tsc_shipping_advise_headers a,tsc.tsc_shipping_advise_lines b"+
                      " where b.tew_advise_no=? "+
                      " and a.advise_header_id=b.advise_header_id"+
                      " group by b.inventory_item_id"+
                      " union all"+
                      " select b.inventory_item_id,0 ship_qty ,sum(b.qty) pick_qty"+
                      " from tsc.tsc_pick_confirm_headers a,tsc.tsc_pick_confirm_lines b"+
                      " where b.tew_advise_no=?"+
					  " AND a.advise_header_id = b.advise_header_id"+
                      " group by b.inventory_item_id) x "+
                      " group by x.inventory_item_id"+
                      " having sum(x.ship_qty) -sum(x.pick_qty) <>0";
				statement1 = con.prepareStatement(sql);
				statement1.setString(1,chk[i]);
				statement1.setString(2,chk[i]);
				rs1=statement1.executeQuery();
				if (rs1.next())
				{
					throw new Exception("出貨明細(數量)與PC排定出貨明細不一致!!");
				}
				rs1.close();
				statement1.close();					
						
				//檢查LOT是否PENDING在修改待核淮的LIST中,add by Peggy 20141204
				sql = " select distinct LOT_NUMBER from oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_revise b"+ 
					  " where a.TEW_ADVISE_NO=? and a.po_line_location_id = b.po_line_location_id "+
					  " and a.seq_id = b.seq_id and NVL(b.approve_flag,'N')='N'";
				  
				statement1 = con.prepareStatement(sql);
				statement1.setString(1,chk[i]);
				rs1=statement1.executeQuery();
				String err_msg ="";
				while (rs1.next())
				{
					err_msg +=(!err_msg.equals("")?"<br>":"")+"LOT:"+rs1.getString(1)+" 申請修改等待主管核淮中";
				}
				rs1.close();
				statement1.close();
				if (!err_msg.equals(""))
				{
					throw new Exception(err_msg);
				}
								
				sql = " UPDATE tsc.tsc_pick_confirm_headers a"+
					  " SET PICK_CONFIRM_DATE=TO_DATE(?,'yyyymmdd')"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",LAST_UPDATED_BY=?"+
					  ",RCV_STATUS=?"+
					  " where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.advise_header_id = a.advise_header_id and b.tew_advise_no=?)";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,request.getParameter("TEXT_"+chk[i]));
				pstmtDt.setString(2,ERPUSERID);
				pstmtDt.setString(3,"N");
				pstmtDt.setString(4,chk[i]);
				pstmtDt.executeUpdate();
				pstmtDt.close();	
			
				sql = " UPDATE tsc.tsc_pick_confirm_lines a"+
					  " set LAST_UPDATE_DATE=sysdate"+
					  ",LAST_UPDATED_BY=?"+
					  " where tew_advise_no=?";
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,ERPUSERID);
				pstmtDt.setString(2,chk[i]);
				pstmtDt.executeUpdate();
				pstmtDt.close();	
			
				CallableStatement cs1 = con.prepareCall("{call tew_rcv_pkg.SUBMIT_REQ(?)}");
				cs1.setString(1,chk[i]); 	
				cs1.execute();
				cs1.close();
			}
			catch(Exception e)
			{	
				err_cnt++;
				sql = " UPDATE tsc.tsc_pick_confirm_headers a"+
					  " SET PICK_CONFIRM_DATE=null"+
				      " where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.advise_header_id = a.advise_header_id and b.tew_advise_no=?)";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.executeUpdate();
				pstmtDt.close();				
				out.println("<font color='red'> Advise No:"+chk[i]+" 出貨交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TEWShipConfirm.jsp'>回倉庫出貨確認功能</a></font>");
			}	
		}
		if (err_cnt ==0)
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("出貨確認成功!!");
				setSubmit("../jsp/TEWShipConfirm.jsp");
			</script>
		<%	
		}	
	}
	catch(Exception e)
	{	
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TEWShipConfirm.jsp'>回倉庫出貨確認功能</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

