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
<title>SG Distribtuion Process</title>
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
<FORM ACTION="TSCSGLotDistributionProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql ="",strErr="",v_pick_flag="N";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String DISTRIBUTION_ID = request.getParameter("DISTRIBUTION_ID");
if (DISTRIBUTION_ID==null) DISTRIBUTION_ID="";

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
		String ADVISENO = request.getParameter("ADVISENO");
		if (ADVISENO==null)
		{
			throw new Exception("無Advise No!!");
		}
		
		//檢查庫存			  
		/*sql =" SELECT A.SG_STOCK_ID"+
		     ",A.ITEM_DESC"+
             ",A.LOT_NUMBER"+
             ",A.DATE_CODE"+
             ",(NVL(A.RECEIVED_QTY,0)+NVL(A.ALLOCATE_IN_QTY,0)-NVL(A.RETURN_QTY,0)-NVL(A.ALLOCATE_OUT_QTY,0)-NVL(A.SHIPPED_QTY,0))/1000 ONHAND "+
             ",SUM(QTY)/1000 PICK_QTY"+
             ",(NVL(A.RECEIVED_QTY,0)+NVL(A.ALLOCATE_IN_QTY,0)-NVL(A.RETURN_QTY,0)-NVL(A.ALLOCATE_OUT_QTY,0)-NVL(A.SHIPPED_QTY,0))/1000-(SUM(QTY)/1000) QTY "+
             " FROM ORADDMAN.TSSG_STOCK_OVERVIEW A,ORADDMAN.TSSG_LOT_DISTRIBUTION_TEMP B"+
             " WHERE A.SG_STOCK_ID=B.SG_STOCK_ID"+
             " AND B.SG_DISTRIBUTION_ID=?"+
             " GROUP BY  A.SG_STOCK_ID,A.ITEM_DESC,A.LOT_NUMBER,A.DATE_CODE,NVL(A.RECEIVED_QTY,0),NVL(A.ALLOCATE_IN_QTY,0),NVL(A.RETURN_QTY,0),NVL(A.ALLOCATE_OUT_QTY,0),NVL(A.SHIPPED_QTY,0)";*/
		sql = " SELECT X.SG_STOCK_ID,X.LOT_NUMBER,(nvl((NVL(Y.RECEIVED_QTY,0)+ NVL(Y.allocate_in_qty,0)-NVL(y.allocate_out_qty,0)-nvl( y.return_qty,0)-nvl(y.shipped_qty,0)"+
		      "-nvl((select sum(qty) from tsc.tsc_pick_confirm_lines a,tsc.tsc_pick_confirm_headers b "+
              " where a.organization_id in (?,?) and a.sg_stock_id=x.sg_stock_id"+
              " and a.advise_header_id=b.advise_header_id"+
              " and b.PICK_CONFIRM_DATE is  null),0)),0)/1000)-X.QTY ONHAND"+
              " FROM (SELECT NVL(A.SG_STOCK_ID,0) SG_STOCK_ID,A.LOT_NUMBER,SUM(QTY)/1000 QTY FROM  ORADDMAN.TSSG_LOT_DISTRIBUTION_TEMP A"+
              " WHERE A.SG_DISTRIBUTION_ID=?"+
              " AND A.LOT_NUMBER<>'庫存不足'"+
              " GROUP BY NVL(A.SG_STOCK_ID,0),A.LOT_NUMBER) X,ORADDMAN.TSSG_STOCK_OVERVIEW Y"+
              " WHERE X.SG_STOCK_ID=Y.SG_STOCK_ID(+)";
		//out.println(sql);	
		//out.println(DISTRIBUTION_ID);
		PreparedStatement statementx = con.prepareStatement(sql);
		statementx.setString(1,"907");
		statementx.setString(2,"908");
		statementx.setString(3,DISTRIBUTION_ID);
		ResultSet rsx=statementx.executeQuery();
		while (rsx.next())
		{
			if (rsx.getInt("ONHAND")<0)
			{
				strErr += "LOT:"+rsx.getString("LOT_NUMBER")+" 庫存不足,超出"+(rsx.getInt("ONHAND")*-1)+"K !!<br>";
			}
		}
		rsx.close();
		statementx.close();
		
		if (!strErr.equals(""))
		{
			throw new Exception(strErr);
		}
		
		//for(int i=0; i< chk.length ;i++)
		//{	
		//	if (i==0)
		//	{	
				v_pick_flag="N";
				sql = " select pick_status from tsc.tsc_pick_confirm_headers a where a.advise_no=?";
				PreparedStatement statement1 = con.prepareStatement(sql);
				statement1.setString(1,ADVISENO);
				ResultSet rs1=statement1.executeQuery();
				if (!rs1.next())
				{
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
						  ",'N'"+
						  ",'Y'"+
						  ",sysdate"+
						  ",(select erp_user_id from oraddman.wsuser where username=?)"+
						  ",sysdate"+
						  ",(select erp_user_id from oraddman.wsuser where username=?)"+
						  " from tsc.tsc_shipping_advise_headers x "+
						  " where exists (select 1 from tsc.tsc_shipping_advise_lines y where x.advise_header_id = y.advise_header_id and y.tew_advise_no=?)";
					//out.println(sql);
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,UserName);
					pstmtDt.setString(2,UserName);
					pstmtDt.setString(3,ADVISENO);
					pstmtDt.executeQuery();
					pstmtDt.close();
				}
				else
				{
					v_pick_flag=rs1.getString("pick_status");
					if (v_pick_flag==null) v_pick_flag="N";
				}
				rs1.close();
				statement1.close();	
				
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
					  ", TEW_ADVISE_NO"+
					  ", PO_CUST_PARTNO"+ 
					  ", sg_stock_id"+
					  ", PICK_QTY"+
					  ", DC_YYWW"+ //add by Peggy 20220721
					  ")"+  //add by Peggy 20210601
					  " select x.ADVISE_HEADER_ID "+
					  " ,x.ADVISE_LINE_ID"+
					  " ,x.CARTON_CODE"+
					  " ,x.CARTON_NUM"+
					  " ,x.CARTON_QTY"+
					  " ,x.SO_NO"+
					  " ,x.SO_HEADER_ID"+
					  " ,x.SO_LINE_ID"+
					  " ,x.ORGANIZATION_ID"+
					  " ,x.ITEM_ID"+
					  " ,x.ITEM_NAME"+
					  " ,x.LOT_NUMBER"+
					  " ,x.SUBINVENTORY_CODE"+
					  " ,x.QTY"+
					  " ,x.DATE_CODE"+
					  " ,x.MANUFACTURE_DATE"+
					  " ,x.EFFECTIVE_DATE"+
					  " ,x.CREATION_DATE"+
					  " ,x.CREATED_BY"+
					  " ,x.LAST_UPDATE_DATE"+
					  " ,x.LAST_UPDATED_BY"+
					  " ,x.PRODUCT_GROUP"+
					  " ,x.ON_HAND_ORG_ID"+
					  " ,x.PO_LINE_LOCATION_ID"+
					  " ,x.ADVISE_NO"+
					  " ,x.PO_CUST_PARTNO"+
					  " ,x.SG_STOCK_ID"+
					  ", x.PICK_QTY"+
					  ", x.dc_yyww"+
					  " from (select b.advise_header_id"+
                      "       ,b.advise_line_id"+
                      "       ,'C' carton_code"+
                      "       ,b.carton_num"+
                      "       ,'1' carton_qty"+
                      "       ,b.so_no"+
                      "       ,a.so_header_id"+
                      "       ,a.so_line_id"+
                      "       ,a.organization_id"+
                      "       ,b.item_id"+
                      "       ,b.item_name"+
                      "       ,b.lot_number"+
                      "       ,b.subinventory_code "+
                      "       ,b.qty"+
                      "       ,b.date_code"+
                      "       ,(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(b.date_code,b.item_name)) where D_TYPE='MAKE') MANUFACTURE_DATE"+
                      "       ,(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(b.date_code,b.item_name)) where D_TYPE='VALID') EFFECTIVE_DATE"+
                      "       ,sysdate creation_date"+
                      "       ,(select erp_user_id from oraddman.wsuser where username=b.created_by) created_by"+
                      "       ,sysdate last_update_date"+
                      "       ,(select erp_user_id from oraddman.wsuser where username=b.created_by) last_updated_by"+
                      "       ,a.PRODUCT_GROUP"+
                      "       ,a.ORGANIZATION_ID on_hand_org_id"+
                      "       ,null po_line_location_id"+
                      "       ,b.advise_no"+
                      "       ,replace(b.PO_CUST_PARTNO,'N/A','') PO_CUST_PARTNO"+
					  "       ,b.sg_stock_id"+
					  "       ,a.carton_per_qty"+
                      "       ,sum(b.qty) over (partition by b.advise_line_id,b.carton_num) allot_qty"+
					  "       ,case when ?=? then b.qty else 0 end as PICK_QTY"+ //add by Peggy 20210601
					  "       ,b.dc_yyww"+ //add by Peggy 20220721
                      "       from oraddman.TSSG_LOT_DISTRIBUTION_TEMP b,tsc.tsc_shipping_advise_lines a"+
                      "       where b.SG_DISTRIBUTION_ID=?"+
                      "       and b.advise_line_id=a.advise_line_id"+
                      "       and b.lot_number <>'庫存不足') x"+
					  " where x.carton_per_qty=x.allot_qty"+
                      " order by x.carton_num";
				//out.println(sql);
				//out.println(request.getParameter("DATECODE_"+chk[i]));
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,v_pick_flag);
				pstmtDt.setString(2,"Y");
				pstmtDt.setString(3,DISTRIBUTION_ID);
				pstmtDt.executeQuery();
				pstmtDt.close();							
				
			/*}	
			if (!request.getParameter("QTY_"+chk[i]).equals("0"))
			{			
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
					  ", TEW_ADVISE_NO"+
					  ", PO_CUST_PARTNO)"+ 
					  " select b.advise_header_id"+
					  ",b.advise_line_id"+
					  ",'C'"+
					  ",replace(SUBSTR(?,INSTR(?,'|')+1,LENGTH(?)-INSTR(?,'*')),'*','') carton_num"+
					  ",'1'"+
					  ",b.so_no"+
					  ",b.so_header_id"+
					  ",b.so_line_id"+
					  ",b.organization_id"+
					  ",b.inventory_item_id"+
					  ",b.item_no"+
					  ",?"+
					  ",'01' "+
					  ",?*1000"+
					  ",?"+
					  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(?,b.item_no)) where D_TYPE=?) MANUFACTURE_DATE"+
					  ",(select D_DATE from table(TSC_GET_ITEM_DATE_INFO(?,b.item_no)) where D_TYPE=?) EFFECTIVE_DATE"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=?)"+
					  ",sysdate"+
					  ",(select erp_user_id from oraddman.wsuser where username=?)"+
					  ",b.PRODUCT_GROUP"+
					  ",b.ORGANIZATION_ID"+
					  ",null"+
					  ",?"+
					  ",replace(?,'N/A','')"+
					  " from tsc.tsc_shipping_advise_lines b,tsc.tsc_shipping_advise_headers a"+
					  //",inv.mtl_lot_numbers c"+ 
					  " where b.tew_advise_no=?"+
					  " and b.advise_header_id=a.advise_header_id"+ 
					  //" and b.inventory_item_id=c.inventory_item_id"+
					  //" and b.organization_id=c.organization_id"+
					  //" and c.lot_number=?"+
					  " and b.advise_line_id=SUBSTR(?,1,INSTR(?,'|')-1)";
				//out.println(sql);
				//out.println(request.getParameter("DATECODE_"+chk[i]));
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,chk[i]);
				pstmtDt.setString(2,chk[i]);
				pstmtDt.setString(3,chk[i]);
				pstmtDt.setString(4,chk[i]);
				pstmtDt.setString(5,request.getParameter("LOT_"+chk[i]));
				pstmtDt.setString(6,request.getParameter("QTY_"+chk[i]));
				pstmtDt.setString(7,request.getParameter("DATECODE_"+chk[i]));
				pstmtDt.setString(8,request.getParameter("DATECODE_"+chk[i]));
				pstmtDt.setString(9,"MAKE");
				pstmtDt.setString(10,request.getParameter("DATECODE_"+chk[i]));
				pstmtDt.setString(11,"VALID");
				pstmtDt.setString(12,UserName);
				pstmtDt.setString(13,UserName);
				pstmtDt.setString(14,ADVISENO);
				pstmtDt.setString(15,(request.getParameter("PO_CUST_PARTNO_"+chk[i]).equals(",")?"":request.getParameter("PO_CUST_PARTNO_"+chk[i])));
				pstmtDt.setString(16,ADVISENO);
				//pstmtDt.setString(16,request.getParameter("LOT_"+chk[i]));
				pstmtDt.setString(17,chk[i]);
				pstmtDt.setString(18,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			*/   
		//}	
		con.commit();
		
		out.println("<table width='80%' align='center'>");
		out.println("<tr><td align='center' colspan='2'><div align='cneter' style='font-weight:bold;color:#0000ff;font-size:16px'>配貨動作成功!!</DIV></td></tr>");
		out.println("<tr><td align='center' colspan='2'><A href="+'"'+"/oradds/ORADDSMainMenu.jsp"+'"'+">");
		%>
		<jsp:getProperty name="rPH" property="pgHOME"/>
		<%
		out.println("</A>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
		out.println("<a href='TSCSGLotDistribution.jsp'>回批號分配功能</font></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="+'"'+"../jsp/TSCSGLotDistributionExcel.jsp?ADVISENO="+ADVISENO+'"'+">下載出貨批號明細表</a></td></tr>");
		out.println("</table>");		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGLotDistributionConfirm.jsp'>回批號分配確認功能</a></font>");
	}
}
else if (TRANSTYPE.equals("PICKCONFIRM"))
{
	String ADVISENO = request.getParameter("ADVISENO");
	if (ADVISENO==null) ADVISENO="";
	try
	{
		PreparedStatement pstmtDt=con.prepareStatement("update tsc.tsc_pick_confirm_headers a set pick_status=? where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.TEW_ADVISE_NO=? and b.advise_header_id=a.advise_header_id)");  
		pstmtDt.setString(1,"Y");
		pstmtDt.setString(2,ADVISENO);
		pstmtDt.executeQuery();
		pstmtDt.close();

		pstmtDt=con.prepareStatement("update tsc.tsc_pick_confirm_lines a set pick_qty=qty where a.TEW_ADVISE_NO=?");  
		pstmtDt.setString(1,ADVISENO);
		pstmtDt.executeQuery();
		pstmtDt.close();
			
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("確認成功!!");
			setSubmit("../jsp/TSCSGLotDistributionConfirm.jsp");
		</script>
	<%			
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGLotDistributionConfirm.jsp'>回倉庫撿貨確認功能</a></font>");
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
			//PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_line_id=a.advise_line_id)");  
			//pstmtDt.setString(1,chk[i]);
			//pstmtDt.executeQuery();
			//pstmtDt.close();			

			//pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_headers a where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_header_id=a.advise_header_id)");  
			//pstmtDt.setString(1,chk[i]);
			//pstmtDt.executeQuery();
			//pstmtDt.close();

			//modify by Peggy 20210806
			PreparedStatement pstmtDt=con.prepareStatement("update tsc.tsc_pick_confirm_lines a set pick_qty=null where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_line_id=a.advise_line_id)");  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();			

			//modify by Peggy 20210806
			pstmtDt=con.prepareStatement("update tsc.tsc_pick_confirm_headers a set pick_status=? where exists (select 1 from tsc.tsc_shipping_advise_lines b where  b.TEW_ADVISE_NO=? and b.advise_header_id=a.advise_header_id)");  
			pstmtDt.setString(1,"N");
			pstmtDt.setString(2,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
		}
		con.commit();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("出貨取消成功!!");
			setSubmit("../jsp/TSCSGLotShipConfirm.jsp");
		</script>
	<%		
		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGLotShipConfirm.jsp'>回倉庫出貨確認功能</a></font>");
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
			//檢查出貨明細與shipping advise是否一致
			sql = " select x.inventory_item_id,sum(x.ship_qty) ship_qty,sum(x.pick_qty) pick_qty "+
				  " from (select b.inventory_item_id,sum(b.ship_qty) ship_qty,0 pick_qty"+
				  " from tsc.tsc_shipping_advise_headers a,tsc.tsc_shipping_advise_lines b"+
				  " where b.tew_advise_no=? "+
				  " and a.advise_header_id=b.advise_header_id"+
				  " group by b.inventory_item_id"+
				  " union all"+
				  " select b.inventory_item_id,0 ship_qty ,sum(b.pick_qty) pick_qty"+
				  " from tsc.tsc_pick_confirm_headers a,tsc.tsc_pick_confirm_lines b"+
				  " where b.tew_advise_no=?"+
				  " AND a.advise_header_id = b.advise_header_id"+
				  " group by b.inventory_item_id) x "+
				  " group by x.inventory_item_id"+
				  " having sum(x.ship_qty) -sum(x.pick_qty) <>0";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,chk[i]);
			statement1.setString(2,chk[i]);
			ResultSet rs1=statement1.executeQuery();
			if (rs1.next())
			{
				throw new Exception("出貨明細(數量)與PC排定出貨明細不一致!!");
			}
			rs1.close();
			statement1.close();					
			
			//add by Peggy 20200609		
			sql = " select 1 from tsc.tsc_pick_confirm_headers a where a.advise_no=? and a.PICK_CONFIRM_DATE is not null";
			statement1 = con.prepareStatement(sql);
			statement1.setString(1,chk[i]);
			rs1=statement1.executeQuery();
			if (rs1.next())
			{	
				throw new Exception("Advise:"+chk[i]+"已做出貨確認,不可重複作業!!");			
			}		
			rs1.close();
			statement1.close();	
								
			// UPDATE TSC_SHIPPING_ADVISE_HEADERS.STATUS=4
			sql = " UPDATE TSC.TSC_SHIPPING_ADVISE_HEADERS a"+
				  " SET STATUS=?"+
				  " WHERE EXISTS (SELECT 1 FROM TSC.TSC_SHIPPING_ADVISE_LINES b WHERE b.ADVISE_HEADER_ID = a.ADVISE_HEADER_ID AND b.TEW_ADVISE_NO = ?)";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"4");
			pstmtDt.setString(2,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();	
					
			sql = " UPDATE tsc.tsc_pick_confirm_headers a"+
				  " SET PICK_CONFIRM_DATE=TO_DATE(?,'yyyymmdd')"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  ",LAST_UPDATED_BY=?"+
				  ",RCV_STATUS=?"+
				  ",PICK_CONFIRM_BY=?"+
				  " where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.advise_header_id = a.advise_header_id and b.tew_advise_no=?)";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,request.getParameter("TEXT_"+chk[i]));
			pstmtDt.setString(2,ERPUSERID);
			pstmtDt.setString(3,"N");
			pstmtDt.setString(4,ERPUSERID);
			pstmtDt.setString(5,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();	
		
			sql = " UPDATE tsc.tsc_pick_confirm_lines a"+
				  " set LAST_UPDATE_DATE=sysdate"+
				  ",LAST_UPDATED_BY=?"+
				  " where tew_advise_no=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,ERPUSERID);
			pstmtDt.setString(2,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();	
			
			sql = " UPDATE oraddman.tssg_stock_overview A"+
				  " SET SHIPPED_QTY=nvl(SHIPPED_QTY,0)+nvl((SELECT SUM(QTY) FROM tsc.tsc_pick_confirm_headers X,tsc.tsc_pick_confirm_lines Y"+
				  " WHERE X.PICK_CONFIRM_DATE IS NOT NULL "+
				  " AND X.ADVISE_HEADER_ID=Y.ADVISE_HEADER_ID"+
				  " AND X.ADVISE_NO=?"+
				  " AND Y.SG_STOCK_ID=A.SG_STOCK_ID),0)"+
				  " WHERE EXISTS (SELECT 1 FROM tsc.tsc_pick_confirm_lines b WHERE tew_advise_no=? and b.sg_stock_id is not null and b.sg_stock_id=a.sg_stock_id)";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,chk[i]);
			pstmtDt.setString(2,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
			
			//出貨數量是否正確檢查,ADD BY PEGGY 20200526
			sql =" SELECT X.LOT_NUMBER,X.DATE_CODE FROM (select A.*,(SELECT SUM(QTY) FROM tsc.tsc_pick_confirm_headers X,tsc.tsc_pick_confirm_lines Y"+
				 " WHERE X.PICK_CONFIRM_DATE IS NOT NULL "+
				 " AND X.ADVISE_HEADER_ID=Y.ADVISE_HEADER_ID"+
				 " AND y.organization_id in (?,?)"+
				 " AND Y.SG_STOCK_ID=A.SG_STOCK_ID) ACT_SHIP_QTY from oraddman.tssg_stock_overview A"+
				 " WHERE EXISTS (SELECT 1 FROM tsc.tsc_pick_confirm_lines b WHERE tew_advise_no=? and b.sg_stock_id is not null and b.sg_stock_id=a.sg_stock_id)) X"+
				 " WHERE NVL(X.SHIPPED_QTY,0)<>NVL(X.ACT_SHIP_QTY,0)";
			//out.println(sql);
			statement1 = con.prepareStatement(sql);
			statement1.setString(1,"907");
			statement1.setString(2,"908");
			statement1.setString(3,chk[i]);
			rs1=statement1.executeQuery();
			if (rs1.next())
			{
				throw new Exception("Advise:"+chk[i]+"出貨數量更新異常,請洽系統管理員!!");
			}
			rs1.close();
			statement1.close();
		}								
		con.commit();
			
		if (err_cnt ==0)
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("出貨確認成功!!");
				setSubmit("../jsp/TSCSGLotShipConfirm.jsp");
			</script>
		<%	
		}	
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCSGLotShipConfirm.jsp'>回倉庫出貨確認功能</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

