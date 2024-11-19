<!-- 20150409 Peggy,check Arrow End customer item-->
<!-- 20161005 Peggy,轉RFQ再檢查狀態是否可轉,避免同時有一個以上USER在處理同張PO造成PO重下-->
<!-- 20180717 Peggy,tsc_edi_orders_detail & tsc_edi_orders_his_d add new column tsc_item_no-->
<!-- 20181206 Peggy,slow moving check-->
<!--20181222 by Peggy,新增original customer part no-->
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
<title>TSC EDI Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.EDIFORM.action=URL;
	document.EDIFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCEDIMProcess.jsp" METHOD="post" NAME="EDIFORM">
<%
String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
String CUSTPO = request.getParameter("CUSTPO");
String REQUESTNO = request.getParameter("REQUESTNO");
String PROGRAMNAME = request.getParameter("PROGRAMNAME");
if (PROGRAMNAME == null) PROGRAMNAME ="";
//out.println(PROGRAMNAME);
String CUSTOMER_NAME= request.getParameter("CUSTOMER_NAME");
if (CUSTOMER_NAME==null) CUSTOMER_NAME="";
boolean slowmoving_flag = false; //add by Peggy 20141007
String sql ="",onhand_hub_order="1215",onhand_hq_order="1151",v_seq="",v_erp_order_num="";

try
{
	//RFQ CONFIRM
	if (PROGRAMNAME.equals("RFQCONFIRM"))
	{
		String DNDOCNO = "";
		String SALESAREANO = request.getParameter("SALESAREANO");
		String PAYTERMID = request.getParameter("PAYTERMID");
		String SHIPTOID = request.getParameter("SHIPTOID");
		String FOB = request.getParameter("FOB");
		String TAXCODE = request.getParameter("TAXCODE");
		String BILLTOID = request.getParameter("BILLTOID");
		String SHIPTOCONTACTID = request.getParameter("SHIPTOCONTACTID");
		String DELIVERYTOID = request.getParameter("DELIVERYTOID");
		String PRICELIST = request.getParameter("PRICELIST");
		String REMARK = request.getParameter("REMARK");
		String MAXLINE = request.getParameter("MAXLINE");
		String CURRENCY = request.getParameter("CURRENCY");
		String SALESID = request.getParameter("SALESID");
		String SALES = request.getParameter("SALES");		
		String LSTATUSID ="003",LSTATUS="ESTIMATING";
		String CUSTMARKETGROUP = request.getParameter("CUSTMARKETGROUP");
		if (CUSTMARKETGROUP==null) CUSTMARKETGROUP="";
		String ACTION_TYPE = request.getParameter("ACTION_TYPE");  //add by Peggy 20140604
		if (ACTION_TYPE==null) ACTION_TYPE="";
		String cancel_remark = request.getParameter("cancel_remark"); //add by Peggy 20140604
		if (cancel_remark==null) cancel_remark="";
		String autoCreate_Flag="",END_CUSTOMER_ID="",END_CUSTOMER=""; //add by Peggy 20150409

		String chk[]= request.getParameterValues("CHKBOX");	
		int line_no =0;
		String v_line ="",PLANT_CODE="",TSC_PACKAGE="",CATEGORY_ITEM="",ORDER_TYPE_ID="",SHIPPING_METHOD="",ORDER_TYPE="",QUOTE_NUMBER=""; //add QUOTE_NUMBER 
		double listPrice = 0;
		int to_rfq =0;  //add by Peggy 20161005
		
		//add by Peggy 20181206
		String sqlh = " SELECT  a.area"+
					  ",a.inventory_item_id"+
					  ",a.item_name"+
					  ",a.item_desc"+
					  ",a.date_code"+
					  ",(a.idle_qty/1000) idle_qty"+
					  ",a.sales"+
					  ",a.customer"+
					  ",a.remarks"+
					  ",a.item_desc1"+
					  ",a.seq_no"+
					  ",tsc_om_category(a.inventory_item_id,49,'TSC_PROD_GROUP') tsc_prod_group"+
					  " FROM oraddman.tsc_idle_stock_detail a"+
					  " where exists (select 1 from (select VERSION_ID from oraddman.tsc_idle_stock_header  where VERSION_FLAG='A' order by UPDATE_DATE desc) b where rownum=1 and b.version_id=a.version_id)";
		Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rsh = statementh.executeQuery(sqlh);	
				
		if (chk.length >0)
		{
			for(int i=0; i< chk.length ;i++)
			{
				v_line = chk[i];to_rfq =0;
				if (request.getParameter("ORDER_TYPE_"+v_line).equals(onhand_hub_order) || request.getParameter("ORDER_TYPE_"+v_line).equals(onhand_hq_order)|| request.getParameter("QUANTITY_"+v_line) ==null || request.getParameter("QUANTITY_"+v_line).equals("") || Float.parseFloat(request.getParameter("QUANTITY_"+v_line))<=0) continue; //add by Peggy 20190520
				
				//chcek 狀態是否可以轉單,add by Pegy 20161005
				sql = "SELECT count(1) FROM tsc_edi_orders_his_d a  WHERE ERP_CUSTOMER_ID=? AND REQUEST_NO=? AND SEQ_NO = ? AND DATA_FLAG IN (?)";
				PreparedStatement stateaa = con.prepareStatement(sql);
				stateaa.setString(1,ERPCUSTOMERID);
				stateaa.setString(2,REQUESTNO);
				stateaa.setString(3,request.getParameter("SEQ_NO_"+v_line));
				stateaa.setString(4,"Y");
				ResultSet rsaa=stateaa.executeQuery();
				if (rsaa.next())
				{
					to_rfq =rsaa.getInt(1);
				}
				rsaa.close();
				stateaa.close();		
				
				if (to_rfq>0)
				{	
					throw new Exception("客戶訂單項次:"+request.getParameter("CUST_PO_LINE_NO_"+v_line)+" 已轉RFQ,不可重複轉單");
				}
				line_no ++;
				if (ACTION_TYPE.equals("RFQ")) //add by Peggy 20140604
				{
					if (line_no==1)
					{
						CallableStatement cs1 = con.prepareCall("{call TSC_EDI_PKG.GET_RFQ_NO(?,?)}");
						cs1.setString(1, SALESAREANO);    
						cs1.registerOutParameter(2, Types.VARCHAR);   
						cs1.execute();
						DNDOCNO = cs1.getString(2);                    
						cs1.close();
						out.println("<input type='hidden' name='DNDOCNO' value='"+DNDOCNO+"'>");
						
						Statement stateflag=con.createStatement();
						String sqlflag = "select a.autocreate_flag "+
									  " from oraddman.tssales_area a "+
									  " where a.sales_area_no= '"+SALESAREANO+"' ";
						ResultSet rsflag=stateflag.executeQuery(sqlflag);
						if (rsflag.next())
						{
							autoCreate_Flag = rsflag.getString("autocreate_flag");
						} 
						else 
						{ 
							autoCreate_Flag ="N"; 
						}
						rsflag.close();
						stateflag.close(); 
					}	
				
					PLANT_CODE =request.getParameter("PLANTCODE_"+v_line);
					TSC_PACKAGE = request.getParameter("TSC_ITEM_PACKAGE_"+v_line);
					CATEGORY_ITEM = request.getParameter("CATEGORY_ITEM_"+v_line);
					SHIPPING_METHOD = request.getParameter("SHIPPINGMETHOD_"+v_line);
					ORDER_TYPE = request.getParameter("ORDER_TYPE_"+v_line);
					QUOTE_NUMBER=request.getParameter("QUOTE_NUMBER_"+v_line); //add by Peggy 20140430
					if (QUOTE_NUMBER==null) QUOTE_NUMBER="";
					
					Statement stateListPrice=con.createStatement();
					String sqlLPrice = "select OPERAND from ORADDMAN.TSITEM_LIST_PRICE "+
					" where LIST_HEADER_ID =  '"+PRICELIST+"' and PRODUCT_ATTR_VAL_DISP = '"+CATEGORY_ITEM+"' ";
					//out.println(sqlLPrice);
					ResultSet rsLPrice=stateListPrice.executeQuery(sqlLPrice); 
					if (rsLPrice.next())
					{
						listPrice = rsLPrice.getDouble("OPERAND");  
					}
					else
					{
						listPrice=0;
					}
					rsLPrice.close();
					stateListPrice.close(); 
					
					if ( TSC_PACKAGE.equals("SMA") &&  CUSTMARKETGROUP.equals("AU"))
					{
						PLANT_CODE ="002";
						ORDER_TYPE ="1156";
					}
					
					Statement stateodrtype=con.createStatement();
					ResultSet rsodrtype=stateodrtype.executeQuery("SELECT  a.otype_id  "+
					" FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
					" where b.order_num=a.order_num"+
					" and a.order_num='"+ORDER_TYPE+"' and a.SAREA_NO ='"+SALESAREANO+"' and a.active='Y'"+
					" and b.MANUFACTORY_NO='"+PLANT_CODE+"' and b.ACTIVE='Y'");  
					if (rsodrtype.next())
					{
						ORDER_TYPE_ID=rsodrtype.getString("otype_id");  
					}
					else
					{
						sql ="";
						throw new Exception("訂單項次:"+ request.getParameter("CUST_PO_LINE_NO_"+v_line)+" Order Type is not exists!!");
					}
					rsodrtype.close();
					stateodrtype.close();
					
					//check arrow end customer item,add by Peggy 20150409
					if (ERPCUSTOMERID.equals("7147"))
					{
						END_CUSTOMER_ID=null;END_CUSTOMER=null;
						sql = " SELECT a.end_customer_id,nvl(b.customer_name_phonetic, b.customer_name) customer_name"+
							  " FROM oraddman.tsce_arrow_end_customer a,ar_customers b"+
							  "  where NVL(a.ACTIVE_FLAG,'I') =? "+
							  " AND a.end_customer_id=b.customer_id "+
							  " and trim(a.item_desc)=trim(?)";
						PreparedStatement state88 = con.prepareStatement(sql);
						state88.setString(1,"A");
						state88.setString(2,request.getParameter("TSC_ITEM_DESC_"+v_line));
						ResultSet rs88=state88.executeQuery();
						if (rs88.next())
						{
							END_CUSTOMER_ID=rs88.getString(1);
							END_CUSTOMER=rs88.getString(2);
						}	
						rs88.close();
						state88.close();
					}		
					
					//check slow moving stock,add by Peggy 20181206
					slowmoving_flag =false;
					if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
					while (rsh.next())
					{
						if (rsh.getString("ITEM_DESC").equals(request.getParameter("TSC_ITEM_DESC_"+v_line)))
						{
							slowmoving_flag=true;
							break;
						}
					}									  
						  
									
					sql =" insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,LINE_NO,INVENTORY_ITEM_ID,"+
						 " ITEM_SEGMENT1,QUANTITY,UOM,LIST_PRICE,REQUEST_DATE,SHIP_DATE,"+
						 " PROMISE_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY,LSTATUSID,LSTATUS,"+
						 " ITEM_DESCRIPTION,MOQP,ASSIGN_MANUFACT,CUST_PO_NUMBER,NSPQ_CHECK, TSC_PROD_GROUP, SPQ, MOQ, PROGRAM_NAME, "+
						 " CUST_REQUEST_DATE,SHIPPING_METHOD,ORDER_TYPE_ID,AUTOCREATE_FLAG,SELLING_PRICE,ORDERED_ITEM,ORDERED_ITEM_ID,ITEM_ID_TYPE,FOB"+  //add by Peggychen 20110621
						 ",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER,END_CUSTOMER_ID,PC_LEADTIME,END_CUSTOMER_PARTNO)"+  //add PC_LEADTIME by Peggy 20150707 //add END_CUSTOMER_PARTNO by Peggy 20190327
						 " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,tsc_get_pc_lead_time(?,trunc(sysdate),?),?)";
					PreparedStatement pstmtDtl=con.prepareStatement(sql);  
					pstmtDtl.setString(1,DNDOCNO); 
					pstmtDtl.setInt(2,line_no);
					pstmtDtl.setString(3,request.getParameter("TSC_ITEM_ID_"+v_line));
					pstmtDtl.setString(4,request.getParameter("TSC_ITEM_"+v_line)); 
					pstmtDtl.setFloat(5,Float.parseFloat(request.getParameter("QUANTITY_"+v_line)));
					pstmtDtl.setString(6,request.getParameter("UOM_"+v_line)); 
					pstmtDtl.setDouble(7,listPrice); 
					pstmtDtl.setString(8,request.getParameter("SSD_"+v_line)+dateBean.getHourMinuteSecond());
					pstmtDtl.setString(9,request.getParameter("SSD_"+v_line)+dateBean.getHourMinuteSecond()); 
					pstmtDtl.setString(10,request.getParameter("SSD_"+v_line)+dateBean.getHourMinuteSecond());
					pstmtDtl.setInt(11,Integer.parseInt(request.getParameter("LINE_TYPE_"+v_line)));
					pstmtDtl.setString(12,request.getParameter("UOM_"+v_line)); 
					pstmtDtl.setString(13,(request.getParameter("REMARK_"+v_line)==null?"":request.getParameter("REMARK_"+v_line)));
					pstmtDtl.setString(14,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
					pstmtDtl.setString(15,userID); 
					pstmtDtl.setString(16,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
					pstmtDtl.setString(17,userID); 
					//add by Peggy 20181206
					if (slowmoving_flag)
					{
						pstmtDtl.setString(18,"014"); 
						pstmtDtl.setString(19,"PENDING"); 
					}
					else
					{
						pstmtDtl.setString(18,"003"); 
						pstmtDtl.setString(19,"ESTIMATING"); 
					}
					pstmtDtl.setString(20,request.getParameter("TSC_ITEM_DESC_"+v_line));
					pstmtDtl.setString(21,"0"); 
					pstmtDtl.setString(22,PLANT_CODE);
					pstmtDtl.setString(23,CUSTPO); 
					pstmtDtl.setString(24,"N"); 
					pstmtDtl.setString(25,request.getParameter("TSC_PROD_GROUP_"+v_line).toUpperCase());  
					pstmtDtl.setFloat(26,Float.parseFloat(request.getParameter("SPQ_"+v_line))); 
					pstmtDtl.setFloat(27,Float.parseFloat(request.getParameter("MOQ_"+v_line))); 
					pstmtDtl.setString(28,"D9-002I"); // PROGRAM_NAME
					pstmtDtl.setString(29,request.getParameter("CRD_"+v_line)); 
					pstmtDtl.setString(30,SHIPPING_METHOD); 
					pstmtDtl.setString(31,ORDER_TYPE_ID); 
					pstmtDtl.setString(32,autoCreate_Flag);
					pstmtDtl.setString(33,request.getParameter("SELLINGPRICE_"+v_line));
					//pstmtDtl.setString(34,request.getParameter("CUST_ITEM_"+v_line)); 
					//pstmtDtl.setString(35,request.getParameter("CUST_ITEM_ID_"+v_line)); 
					pstmtDtl.setString(34,(request.getParameter("CUST_ITEM_ID_"+v_line)==null||request.getParameter("CUST_ITEM_ID_"+v_line).equals("")?"N/A":request.getParameter("CUST_ITEM_"+v_line)));  //for Arrow issue by Peggy 20210825
					pstmtDtl.setString(35,(request.getParameter("CUST_ITEM_ID_"+v_line)==null||request.getParameter("CUST_ITEM_ID_"+v_line).equals("")?"0":request.getParameter("CUST_ITEM_ID_"+v_line))); //for Arrow issue by Peggy 20210825
					pstmtDtl.setString(36,request.getParameter("ITEM_ID_TYPE_"+v_line)); 
					pstmtDtl.setString(37,request.getParameter("LINE_FOB_"+v_line)); 
					pstmtDtl.setString(38,request.getParameter("CUST_PO_LINE_NO_"+v_line));
					pstmtDtl.setString(39,QUOTE_NUMBER);     //add by Peggy 20140430
					pstmtDtl.setString(40,END_CUSTOMER);     //modify by Peggy 20150409
					pstmtDtl.setString(41,END_CUSTOMER_ID);  //modify by Peggy 20150409
					pstmtDtl.setString(42,PLANT_CODE);                                     //modify by Peggy 20150707
					pstmtDtl.setString(43,request.getParameter("TSC_ITEM_ID_"+v_line));    //modify by Peggy 20150707
					pstmtDtl.setString(44,(request.getParameter("END_CUST_ITEM_"+v_line)==null?"":request.getParameter("END_CUST_ITEM_"+v_line)));  //modify by Peggy 20190327
					pstmtDtl.executeQuery();
					pstmtDtl.close();
				}
				
				sql = " UPDATE tsc_edi_orders_his_d a"+
                      " SET DNDOCNO = ?"+
                      ",LINE_NO =?"+
                      ",DATA_FLAG =?"+
					  ",RFQ_QTY =?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",TSC_ITEM_NO=?"+ //add by Peggy 20180717
					  ",PASS_REASON=?"+  //add by Peggy 20190319
					  ",CUST_REQUEST_DATE=?"+ //add by Peggy 20210311
                      " WHERE ERP_CUSTOMER_ID=?"+
                      " AND REQUEST_NO=?"+
                      " AND SEQ_NO = ?";
				PreparedStatement pstmtDt5=con.prepareStatement(sql);  
				pstmtDt5.setString(1,DNDOCNO); 
				pstmtDt5.setString(2,""+line_no);
				pstmtDt5.setString(3,"Y");
				pstmtDt5.setFloat(4,Float.parseFloat(request.getParameter("QUANTITY_"+v_line))*1000);
				pstmtDt5.setString(5,UserName);
				pstmtDt5.setString(6,request.getParameter("TSC_ITEM_"+v_line));
				pstmtDt5.setString(7,(ACTION_TYPE.equals("PASS")?cancel_remark:""));
				pstmtDt5.setString(8,request.getParameter("CRD_"+v_line)); //add by Peggy 20210311
				pstmtDt5.setString(9,ERPCUSTOMERID); 
				pstmtDt5.setString(10,REQUESTNO); 
				pstmtDt5.setString(11,request.getParameter("SEQ_NO_"+v_line));
				pstmtDt5.executeQuery();
				pstmtDt5.close();
					  
				
				//modify by Peggy 20140815
				sql = " select 1 from TSC_EDI_ORDERS_DETAIL a "+
				      " where a.erp_customer_id='"+ERPCUSTOMERID+"'"+
					  " and a.cust_po_line_no='"+request.getParameter("CUST_PO_LINE_NO_"+v_line)+"'"+
					  " and a.customer_po='"+CUSTPO+"'"+
					  " and a.DATA_FLAG='P'"+
					  " and a.MAILED_DATE is not null";
				Statement statement8=con.createStatement();
				ResultSet rs8=statement8.executeQuery(sql);
				if (rs8.next())
				{
					sql = " update TSC_EDI_ORDERS_DETAIL a"+
					      " set DATA_FLAG =null"+
						  " where a.erp_customer_id=?"+
						  " and a.cust_po_line_no=?"+
						  " and a.customer_po=?"+
						  " and a.DATA_FLAG=?"+
						  " and a.MAILED_DATE is not null";
					PreparedStatement pstmtDt2=con.prepareStatement(sql);  
					pstmtDt2.setString(1,ERPCUSTOMERID); 
					pstmtDt2.setString(2,request.getParameter("CUST_PO_LINE_NO_"+v_line));
					pstmtDt2.setString(3,CUSTPO); 
					pstmtDt2.setString(4,"P");
					pstmtDt2.executeQuery();
					pstmtDt2.close();
						  
				}
				else
				{
					sql = " insert into tsc_edi_orders_detail(erp_customer_id, customer_po, version_id, cust_po_line_no, seq_no, cust_item_name, tsc_item_name,quantity, uom, unit_price, cust_request_date,creation_date,DATA_FLAG,REMARKS,tsc_item_no,orig_cust_item_name,orig_tsc_item_name,orig_cust_request_date)"+ //add by Peggy 20180717 new column tsc_item_no,add orig_cust_item_name by Peggy 20181222
						  " select a.erp_customer_id,c.customer_po,0,a.cust_po_line_no,a.cust_po_line_no||'.'||to_char(nvl((select count(1) from tsc_edi_orders_detail b where b.customer_po=c.customer_po and b.erp_customer_id=a.erp_customer_id and b.cust_po_line_no=a.cust_po_line_no),1)+1) ,a.cust_item_name,a.tsc_item_name,a.quantity,a.uom,a.unit_price,a.cust_request_date,sysdate,?,?,a.tsc_item_no,a.orig_cust_item_name,a.orig_tsc_item_name,a.orig_cust_request_date"+
						  " from tsc_edi_orders_his_d a,tsc_edi_orders_his_h c"+
						  " where a.request_no=?"+
						  " and a.erp_customer_id=?"+
						  " and a.cust_po_line_no=?"+
						  " and c.customer_po=?"+
						  " and a.seq_no=?"+
						  " and a.request_no=c.request_no"+
						  " and a.erp_customer_id=c.erp_customer_id";
					PreparedStatement pstmtDt2=con.prepareStatement(sql);  
					pstmtDt2.setString(1,(ACTION_TYPE.equals("RFQ")?"":(ACTION_TYPE.equals("PASS")?"":"C"))); 
					pstmtDt2.setString(2,(ACTION_TYPE.equals("RFQ")?"":(ACTION_TYPE.equals("PASS")?"":cancel_remark)));
					pstmtDt2.setString(3,REQUESTNO); 
					pstmtDt2.setString(4,ERPCUSTOMERID);
					pstmtDt2.setString(5,request.getParameter("CUST_PO_LINE_NO_"+v_line));
					pstmtDt2.setString(6,CUSTPO); 
					pstmtDt2.setString(7,request.getParameter("SEQ_NO_"+v_line));
					pstmtDt2.executeQuery();
					pstmtDt2.close();
					
					//add by Peggy 20150224
					if (ACTION_TYPE.equals("CANCELLED"))
					{
						sql = "SELECT count(1) FROM apps.tsc_edi_orders_his_d a where ERP_CUSTOMER_ID=? and REQUEST_NO=?";
						PreparedStatement state1 = con.prepareStatement(sql);
						state1.setString(1,ERPCUSTOMERID);
						state1.setString(2,CUSTPO);
						ResultSet rs1=state1.executeQuery();
						if (rs1.next())
						{					
							sql = "SELECT 1 FROM daphne_proforma_temp a where CUST_PO_NUMBER=? and exists (select 1 from ar_customers b where customer_id =? and customer_number=CUSTOMER_NO)";
							PreparedStatement state2 = con.prepareStatement(sql);
							state2.setString(1,CUSTPO);
							state2.setString(2,ERPCUSTOMERID);
							ResultSet rs2=state2.executeQuery();
							if (!rs2.next())
							{
								sql=" insert into daphne_proforma_temp (ORDER_NUMBER, CUST_PO_NUMBER,CUSTOMER_NAME, FLAG, CUSTOMER_NO ,CREATION_DATE,REGION1)"+
									" select ?,?,b.customer_name,?,b.customer_number,to_char(sysdate,'yyyymmddhh24miss'),a.region1 from apps.tsc_edi_customer a,ar_customers b"+
									" where a.CUSTOMER_ID=b.CUSTOMER_ID"+
									" and a.customer_id=?";
								PreparedStatement pstmtDt3=con.prepareStatement(sql);  
								pstmtDt3.setString(1,"1141"+(CUSTPO.length()>=5?CUSTPO.substring(CUSTPO.length()-5):CUSTPO)); 
								pstmtDt3.setString(2,CUSTPO);
								pstmtDt3.setString(3,"Y"); 
								pstmtDt3.setString(4,ERPCUSTOMERID); 
								pstmtDt3.executeQuery();
								pstmtDt3.close();		
							}
							rs2.close();
							state2.close();		
						}
						rs1.close();
						state1.close();									
					}
					
				}
				rs8.close();
				statement8.close();
				
			}

			if (ACTION_TYPE.equals("RFQ") && line_no>0) //add by Peggy 20140604
			{
				sql= " insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,"+
					 " AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,REMARK,STATUSID,STATUS,CREATION_DATE,CREATED_BY,"+
					 " LAST_UPDATE_DATE,LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,"+
					 " BILL_TO_ORG,PAYTERM_ID,SHIPMETHOD,FOB_POINT,AR_OVERDUE,SOURCE_CODE,SAMPLE_ORDER,SAMPLE_CHARGE,AUTOCREATE_FLAG,RFQ_TYPE"+  
					 ",SHIP_TO_CONTACT_ID,DELIVERY_TO_ORG,TAX_CODE)"+
					 " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement pstmt=con.prepareStatement(sql);  
				pstmt.setString(1,DNDOCNO); 
				pstmt.setString(2,SALESAREANO);
				pstmt.setString(3,userID);  
				pstmt.setString(4,"");
				pstmt.setString(5,ERPCUSTOMERID);
				pstmt.setString(6,CUSTOMER_NAME);
				pstmt.setString(7,CUSTPO);
				pstmt.setString(8,CURRENCY);
				pstmt.setInt(9,0);
				pstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
				pstmt.setString(11,""); 
				pstmt.setString(12,"");
				pstmt.setString(13,"");
				pstmt.setString(14,REMARK);
				pstmt.setString(15,LSTATUSID);
				pstmt.setString(16,LSTATUS);
				pstmt.setString(17,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
				pstmt.setString(18,userID);
				pstmt.setString(19,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
				pstmt.setString(20,userID);
				pstmt.setString(21,SALESID); 
				pstmt.setString(22,ORDER_TYPE_ID); 
				pstmt.setString(23,ERPCUSTOMERID); 
				pstmt.setString(24,PRICELIST);
				pstmt.setString(25,SHIPTOID); 
				pstmt.setString(26,SALES);
				pstmt.setString(27,BILLTOID);
				pstmt.setString(28,PAYTERMID); 
				pstmt.setString(29,SHIPPING_METHOD); 
				pstmt.setString(30,FOB);
				pstmt.setString(31,"N");
				pstmt.setString(32,"01"); 
				pstmt.setString(33,"N"); 
				pstmt.setString(34,""); 
				pstmt.setString(35,autoCreate_Flag);
				pstmt.setString(36,"3"); //RFQ_TYPE=3(EDI)
				pstmt.setString(37,SHIPTOCONTACTID); 
				pstmt.setString(38,DELIVERYTOID);  
				pstmt.setString(39,TAXCODE); 
				pstmt.executeQuery();	
				pstmt.close();
			}
			
			sql = "SELECT 1  FROM tsc_edi_orders_header a  where ERP_CUSTOMER_ID=?  and CUSTOMER_PO=?";
			PreparedStatement state1 = con.prepareStatement(sql);
			state1.setString(1,ERPCUSTOMERID);
			state1.setString(2,CUSTPO);
			ResultSet rs1=state1.executeQuery();
			if (!rs1.next())
			{
				sql=" insert into tsc_edi_orders_header(erp_customer_id, customer_po, version_id, request_date, by_code, dp_code, se_code, currency_code,creation_date, data_flag)"+
					" select a.erp_customer_id,a.customer_po,0,a.request_date,a.by_code,a.dp_code,a.se_code,a.currency_code,sysdate,'Y' from tsc_edi_orders_his_h a  "+     
					" where a.request_no=?"+
					" and a.erp_customer_id=?"+
					" and a.customer_po=?";
				PreparedStatement pstmtDt3=con.prepareStatement(sql);  
				pstmtDt3.setString(1,REQUESTNO); 
				pstmtDt3.setString(2,ERPCUSTOMERID);
				pstmtDt3.setString(3,CUSTPO); 
				pstmtDt3.executeQuery();
				pstmtDt3.close();
			}
			rs1.close();
			state1.close(); 
			
			//產生ERP訂單
			for(int t=0; t< chk.length ;t++)
			{
				v_line = chk[t];
				if (!request.getParameter("ORDER_TYPE_"+v_line).equals(onhand_hub_order) && !request.getParameter("ORDER_TYPE_"+v_line).equals(onhand_hq_order) ) continue; //add by Peggy 20190520 //1151 by Peggy 20220825
				sql = " UPDATE tsc_edi_orders_his_d a"+
                      " SET ERP_ORDER_QTY = ?"+
                      ",ERP_SHIPPING_METHOD_CODE =?"+
                      ",ERP_SCHEDULE_SHIP_DATE =to_date(?,'yyyymmdd')"+
					  ",CRD=?"+  //add by Peggy 20210311
					  ",ERP_ORDER_TYPE=?"+ //add by Peggy 20220825
					  ",ERP_FOB=?"+ //add by Peggy 20220829
                      " WHERE ERP_CUSTOMER_ID=?"+
                      " AND REQUEST_NO=?"+
                      " AND SEQ_NO = ?";
				PreparedStatement pstmtDt5=con.prepareStatement(sql);  
				pstmtDt5.setString(1,""+(Float.parseFloat(request.getParameter("QUANTITY_"+v_line))*1000));
				pstmtDt5.setString(2,request.getParameter("SHIPPINGMETHOD_"+v_line));
				pstmtDt5.setString(3,request.getParameter("SSD_"+v_line));
				pstmtDt5.setString(4,request.getParameter("CRD_"+v_line));  //add by Peggy 20210311
				pstmtDt5.setString(5,request.getParameter("ORDER_TYPE_"+v_line));  //add by Peggy 20220825
				pstmtDt5.setString(6,request.getParameter("LINE_FOB_"+v_line));  //add by Peggy 20220829
				pstmtDt5.setString(7,ERPCUSTOMERID); 
				pstmtDt5.setString(8,REQUESTNO); 
				pstmtDt5.setString(9,request.getParameter("SEQ_NO_"+v_line));
				pstmtDt5.executeQuery();
				pstmtDt5.close();	
				if (!v_seq.equals("")) v_seq+=",";
				v_seq += request.getParameter("SEQ_NO_"+v_line);		
			}
			con.commit();
			
			if (!v_seq.equals(""))
			{
				CallableStatement cs3 = con.prepareCall("{call tsc_edi_pkg.EDI_ORDERS_TRANSFER_TO_ERP(?,?,?)}");
				cs3.setString(1,REQUESTNO);      
				cs3.setString(2,ERPCUSTOMERID);                   
				cs3.setString(3,onhand_hub_order);                   
				cs3.execute();
				cs3.close();	
				
				sql = "select listagg(erp_order_no,',') within group (order by erp_order_no) from (select distinct erp_order_no from tsc_edi_orders_his_d where ERP_CUSTOMER_ID=? AND REQUEST_NO=? AND ','||?||',' like '%,'||SEQ_NO||',%') x";
				PreparedStatement state11 = con.prepareStatement(sql);
				state11.setString(1,ERPCUSTOMERID);
				state11.setString(2,REQUESTNO); 
				state11.setString(3,v_seq);
				ResultSet rs11=state11.executeQuery();
				if (rs11.next())
				{
					v_erp_order_num = rs11.getString(1);
				}
				out.println("<input type='hidden' name='ERP_ODR_NUM' value='"+v_erp_order_num+"'>");
				rs11.close();
				state11.close();
			}
			
			if (ACTION_TYPE.equals("RFQ")) //add by Peggy 20140604
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					var msg="";
					if (document.EDIFORM.ERP_ODR_NUM!=undefined)
					{
						msg=msg+"ERP訂單號:"+document.EDIFORM.ERP_ODR_NUM.value +"  ";
					}
					if (document.EDIFORM.DNDOCNO != undefined)
					{
						msg=msg+"RFQ號碼:"+document.EDIFORM.DNDOCNO.value;
					}
					alert("動作成功!!"+msg);
					setSubmit("../jsp/TSCEDIExceptionQuery.jsp");
				</script>
			<%	
			}
			else if (ACTION_TYPE.equals("PASS"))
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("訂單PASS成功!!");
					setSubmit("../jsp/TSCEDIExceptionQuery.jsp");
				</script>
			<%	
			}
			else 
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("訂單取消成功!!");
					setSubmit("../jsp/TSCEDIExceptionQuery.jsp");
				</script>
			<%	
			}
		}
		else
		{
			throw new Exception("無Insert資料!!");
		}
	}
	else if (PROGRAMNAME.equals("ORDCHGCONFIRM")) //ORDER CHANGE CONFIRM
	{
		String chk[]= request.getParameterValues("CHKBOX");		
		String ITEM_DESC ="",CUST_PO_LINE_NO ="",SEQ_NO="",VERSION_ID="0",REMARKS="",LOGIN_USER_ID="",TO_RFQ_QTY="",CHOOSE_LINE_LIST="",OK_LINE_LIST="",CRD="";
		String NOTYPE="",ERPMO="",ERPMOLINE="",	ERPMOQTY="",ERPORIGMOQTY="",ERPMOCRD="",ERPORIGMOCRD="",SHIPPINGMETHOD="",ORIGSHIPPINGMETHOD="",ERPMOSSD="",ERPORIGMOSSD="";
		String TO_RFQ_SSD="",TO_RFQ_SHIPMETHOD="",TO_RFQ_ORDER_TYPE="",LINE_REMARKS="",PDNFLAG="",ERPMOSELLINGPRICE="",ERPORIGMOSELLINGPRICE="",ORDCHG_WARNNING="",ORDER_REMARKS="",CANCEL_FLAG="";
		String TO_ERP_QTY="",TO_ERP_SSD="",TO_ERP_SHIPMETHOD="";   //add by Peggy 20190521
		int CUST_PO_LINE_NO_CNT=0,CUST_PO_LINE_MO_CNT=0,TO_RFQ_CNT=0,ERR_CNT=0,TO_MO_CNT=0;
		int GROUP_ID=0;
		boolean exception_flag=false;
		for(int i=0; i< chk.length ;i++)
		{
			CUST_PO_LINE_NO = chk[i]; 
			CUST_PO_LINE_NO_CNT = Integer.parseInt(request.getParameter("ROW_CNT_"+CUST_PO_LINE_NO));
			ITEM_DESC = request.getParameter("ITEM_DESC_"+CUST_PO_LINE_NO);
			CUST_PO_LINE_MO_CNT = Integer.parseInt(request.getParameter("MO_ROW_CNT_"+CUST_PO_LINE_NO));
			ORDCHG_WARNNING = request.getParameter("ORDCHG_WARNNING_"+CUST_PO_LINE_NO);  //add by Peggy 20190408
			ORDER_REMARKS = request.getParameter("ORDER_REMARKS_"+CUST_PO_LINE_NO);      //add by Peggy 20190408
			CANCEL_FLAG = request.getParameter("CANCEL_FLAG_"+CUST_PO_LINE_NO);      //add by Peggy 20190408
			if (CANCEL_FLAG==null || !CANCEL_FLAG.equals("C")) CANCEL_FLAG="";
			
			//CHECK DATA是否已處理
			sql = " SELECT 1 FROM tsc_edi_orders_his_d a"+
		          " WHERE a.REQUEST_NO=?"+
			      " and a.ERP_CUSTOMER_ID=?"+
				  " and a.CUST_PO_LINE_NO=?"+
				  " AND a.DATA_FLAG=?";
			PreparedStatement statex = con.prepareStatement(sql);
			statex.setString(1,REQUESTNO);
			statex.setString(2,ERPCUSTOMERID);
			statex.setString(3,CUST_PO_LINE_NO);
			statex.setString(4,"Y");
			ResultSet rsx=statex.executeQuery();
			if (rsx.next()) 
			{ 	
				exception_flag = true;
			}
			else
			{
				exception_flag = false;
			}
			rsx.close();
			statex.close(); 
			
			if (!exception_flag)
			{
				if (CHOOSE_LINE_LIST.length()>0) CHOOSE_LINE_LIST+=",";
				CHOOSE_LINE_LIST += "'"+CUST_PO_LINE_NO+"'";
			
				//TRANS TO RFQ
				for	(int k =1; k <= CUST_PO_LINE_NO_CNT ; k++)
				{
					SEQ_NO = request.getParameter("SEQ_"+CUST_PO_LINE_NO+"_"+k);
					CRD = request.getParameter("CRD_"+CUST_PO_LINE_NO+"_"+k);
					TO_RFQ_QTY = request.getParameter("RFQ_"+CUST_PO_LINE_NO+"_"+k);
					TO_RFQ_SSD = request.getParameter("RFQ_SSD_"+CUST_PO_LINE_NO+"_"+k);
					TO_RFQ_SHIPMETHOD = request.getParameter("RFQ_SHIPMETHOD_"+CUST_PO_LINE_NO+"_"+k);
					TO_RFQ_ORDER_TYPE = request.getParameter("ORDERTYPE_"+CUST_PO_LINE_NO);
					LINE_REMARKS=request.getParameter("REMARK_"+CUST_PO_LINE_NO+"_"+k);
					PDNFLAG=request.getParameter("PDNFLAG_"+CUST_PO_LINE_NO+"_"+k);
					TO_ERP_QTY = request.getParameter("ERPODR_"+CUST_PO_LINE_NO+"_"+k);
					TO_ERP_SSD = request.getParameter("ERPODR_SSD_"+CUST_PO_LINE_NO+"_"+k);
					TO_ERP_SHIPMETHOD = request.getParameter("ERPODR_SHIPMETHOD_"+CUST_PO_LINE_NO+"_"+k);
					if (PDNFLAG==null) PDNFLAG="";
					if (TO_RFQ_QTY==null || TO_RFQ_QTY.equals("")) TO_RFQ_QTY="0";
					if (TO_ERP_QTY==null || TO_ERP_QTY.equals("")) TO_ERP_QTY="0";
					if (Integer.parseInt(TO_RFQ_QTY) >0 || Integer.parseInt(TO_ERP_QTY) >0)
					{
						try
						{
							sql = " update tsc_edi_orders_his_d a "+
								  " set RFQ_QTY=?"+           
								  " ,SHIPPING_METHOD=?"+
								  " ,SCHEDULE_SHIP_DATE=?"+
								  " ,ORDER_TYPE=?"+
								  " ,REMARK=?"+
								  " ,PDN_FLAG=?"+
								  " ,ERP_ORDER_QTY =?"+
                                  " ,ERP_SHIPPING_METHOD_CODE =?"+
                                  " ,ERP_SCHEDULE_SHIP_DATE =to_date(?,'yyyymmdd')"+
								  " ,CUST_REQUEST_DATE=?"+
								  " where REQUEST_NO=?"+
								  " AND ERP_CUSTOMER_ID=?"+
								  " AND SEQ_NO =?"+
								  " AND DATA_FLAG=?"+
								  " AND DNDOCNO IS NULL"+
								  " AND LINE_NO IS NULL";       
							PreparedStatement pstmt=con.prepareStatement(sql);
							pstmt.setInt(1,Integer.parseInt(TO_RFQ_QTY));
							pstmt.setString(2,TO_RFQ_SHIPMETHOD);
							pstmt.setString(3,TO_RFQ_SSD);
							pstmt.setString(4,TO_RFQ_ORDER_TYPE);
							pstmt.setString(5,LINE_REMARKS);
							pstmt.setString(6,PDNFLAG);
							pstmt.setInt(7,Integer.parseInt(TO_ERP_QTY));
							pstmt.setString(8,TO_ERP_SHIPMETHOD);
							pstmt.setString(9,TO_ERP_SSD);
							pstmt.setString(10,CRD);  //add by Peggy 20210311
							pstmt.setString(11,REQUESTNO);
							pstmt.setString(12,ERPCUSTOMERID);
							pstmt.setString(13,SEQ_NO);
							pstmt.setString(14,"N");
							pstmt.executeQuery();	
							if (Integer.parseInt(TO_RFQ_QTY) >0) TO_RFQ_CNT ++;	 //modif by Peggy 20190521
							if (Integer.parseInt(TO_ERP_QTY) >0) TO_MO_CNT ++;  //modif by Peggy 20190521
						}
						catch(Exception e)
						{
							ERR_CNT++;
						}		
					}
				}
				//MO LIST
				for (int j =1 ; j <= CUST_PO_LINE_MO_CNT ; j++)
				{
					NOTYPE=request.getParameter("NO_TYPE_"+CUST_PO_LINE_NO+"_"+j);
					if (NOTYPE==null) NOTYPE="";
					ERPMO=request.getParameter("MO_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMO==null) ERPMO="";
					ERPMOLINE=request.getParameter("MOLINE_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMOLINE==null) ERPMOLINE="";
					ERPMOQTY=request.getParameter("MOQTY_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMOQTY==null) ERPMOQTY="";
					ERPORIGMOQTY=request.getParameter("ORIGMOQTY_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPORIGMOQTY==null) ERPORIGMOQTY="";
					ERPMOSELLINGPRICE=request.getParameter("MOSELLINGPRICE_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMOSELLINGPRICE==null) ERPMOSELLINGPRICE="";
					ERPORIGMOSELLINGPRICE=request.getParameter("ORIGMOSELLINGPRICE_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPORIGMOSELLINGPRICE==null) ERPORIGMOSELLINGPRICE="";
					ERPMOCRD=request.getParameter("MOCRD_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMOCRD==null) ERPMOCRD="";
					ERPORIGMOCRD=request.getParameter("ORIGMOCRD_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPORIGMOCRD==null) ERPORIGMOCRD="";
					SHIPPINGMETHOD=request.getParameter("SHIPPINGMETHOD_"+CUST_PO_LINE_NO+"_"+j);
					if (SHIPPINGMETHOD==null) SHIPPINGMETHOD="";
					ORIGSHIPPINGMETHOD=request.getParameter("ORIGSHIPPINGMETHOD_"+CUST_PO_LINE_NO+"_"+j);
					if (ORIGSHIPPINGMETHOD==null) ORIGSHIPPINGMETHOD="";
					ERPMOSSD=request.getParameter("SSD_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPMOSSD==null) ERPMOSSD="";
					ERPORIGMOSSD=request.getParameter("ORIGSSD_"+CUST_PO_LINE_NO+"_"+j);
					if (ERPORIGMOSSD==null) ERPORIGMOSSD="";
					REMARKS="";
					if (!NOTYPE.equals("RFQ") && ( (!ERPMOQTY.equals(ERPORIGMOQTY) && !ERPMOQTY.equals("")) || (!ERPMOCRD.equals(ERPORIGMOCRD) && !ERPMOCRD.equals("")) || (!SHIPPINGMETHOD.equals(ORIGSHIPPINGMETHOD) && !SHIPPINGMETHOD.equals("")) || (!ERPMOSSD.equals(ERPORIGMOSSD) && !ERPMOSSD.equals("")) || (!ERPMOSELLINGPRICE.equals(ERPORIGMOSELLINGPRICE) && !ERPMOSELLINGPRICE.equals("")) ))
					{
						//get GROUP_ID
						if (GROUP_ID==0)
						{
							sql = " SELECT TSCC_OM_STATUS_S.NEXTVAL GROUP_ID , erp_user_id FROM ORADDMAN.WSUSER"+
								  " WHERE UPPER(USERNAME) = trim(upper('"+UserName+"')) " ;
							Statement stateid=con.createStatement();
							ResultSet rsid=stateid.executeQuery(sql);
							if (rsid.next()) 
							{ 	
								GROUP_ID=Integer.parseInt(rsid.getString("GROUP_ID")); 
								LOGIN_USER_ID=rsid.getString("ERP_USER_ID");
							}
							rsid.close();
							stateid.close(); 
						}
						if (!ERPMOQTY.equals(ERPORIGMOQTY) && !ERPMOQTY.equals("")) //modify by Peggy 20140116
						{
							if (REMARKS.length()>0) REMARKS+=",";
							REMARKS += "QTY:"+ ERPORIGMOQTY+"=>"+ERPMOQTY;
						}
						if (!ERPMOCRD.equals(ERPORIGMOCRD) && !ERPMOCRD.equals("")) //modify by Peggy 20140116
						{
							if (REMARKS.length()>0) REMARKS+=",";
							REMARKS += "CRD:"+ ERPORIGMOCRD+"=>"+ERPMOCRD;
						}
						if (!SHIPPINGMETHOD.equals(ORIGSHIPPINGMETHOD) && !SHIPPINGMETHOD.equals("")) //modify by Peggy 20140116
						{
							if (REMARKS.length()>0) REMARKS+=",";
							REMARKS += "SHIPPING METHOD:"+ ORIGSHIPPINGMETHOD+"=>"+SHIPPINGMETHOD;
						}
						if (!ERPMOSSD.equals(ERPORIGMOSSD) && !ERPMOSSD.equals(""))  //modify by Peggy 20140116
						{
							if (REMARKS.length()>0) REMARKS+=",";
							REMARKS += "SSD:"+ ERPORIGMOSSD+"=>"+ERPMOSSD;
						}
						if (!ERPMOSELLINGPRICE.equals(ERPORIGMOSELLINGPRICE) && !ERPMOSELLINGPRICE.equals("")) //modify by Peggy 20140116
						{
							if (REMARKS.length()>0) REMARKS+=",";
							REMARKS += "SELLING PRICE:"+ ERPORIGMOSELLINGPRICE+"=>"+ERPMOSELLINGPRICE;
						}						
						
						try
						{
							sql = " insert into ORADDMAN.TSC_OM_SALESORDERREVISE(group_id, order_number, line_number, item_description,"+
								  " customer_name, customer_po_number, ordered_quantity, unit_selling_price, schedule_ship_date,"+
								  " shipping_method_name, remarks, creation_date, created_by, process_status, change_reason,CUST_REQUEST_DATE)"+
								  " values(?,?,?,?,?,?,?,?,to_date(?,'yyyy-mm-dd'),?,?,sysdate,?,?,?,to_date(?,'yyyy-mm-dd')) ";
							PreparedStatement pstmt3=con.prepareStatement(sql);
							pstmt3.setString(1,""+GROUP_ID);
							pstmt3.setString(2,ERPMO);
							pstmt3.setString(3,ERPMOLINE);
							pstmt3.setString(4,ITEM_DESC);
							pstmt3.setString(5,CUSTOMER_NAME);
							pstmt3.setString(6,CUSTPO);
							pstmt3.setFloat(7,Float.parseFloat(ERPMOQTY));
							pstmt3.setFloat(8,Float.parseFloat(ERPMOSELLINGPRICE));
							pstmt3.setString(9,ERPMOSSD);
							pstmt3.setString(10,SHIPPINGMETHOD);
							pstmt3.setString(11,REMARKS);
							pstmt3.setString(12,LOGIN_USER_ID);   
							pstmt3.setString(13,"1");   
							pstmt3.setString(14,"Customer Require");   
							pstmt3.setString(15,ERPMOCRD);
							pstmt3.executeQuery();				
							pstmt3.close();
						}
						catch(Exception e)
						{	
							ERR_CNT++;
						}
					}
				}
			}
		}
		if (CHOOSE_LINE_LIST.length()==0)
		{
			throw new Exception("查無符合條件的資料,請重新確認!!");
		}
	
		if (GROUP_ID >0)
		{
			String Errbuf="",Retcode="";
			int cntError =0;
			CallableStatement cs1 = con.prepareCall("{call TSC_OM_SO_REVISE_PKG.valid_order(?,?,?,1,?,?)}");
			cs1.registerOutParameter(1, Types.VARCHAR);   
			cs1.registerOutParameter(2, Types.VARCHAR);   
			cs1.setInt(3, GROUP_ID);    
			cs1.setInt(4, Integer.parseInt(LOGIN_USER_ID));                    
			cs1.registerOutParameter(5, Types.INTEGER);    
			cs1.execute();
			Errbuf = cs1.getString(1);                    
			Retcode = cs1.getString(2);                  
			cntError = cs1.getInt(5);                     
			cs1.close();
			if (Errbuf!=null)
			{
				ERR_CNT++;
				throw new Exception(Errbuf);
			}	
			CallableStatement cs2 = con.prepareCall("{call TSC_OM_SO_REVISE_PKG.revise_order(?,?,?,3,?)}");
			cs2.registerOutParameter(1, Types.VARCHAR);    
			cs2.registerOutParameter(2, Types.VARCHAR);  
			cs2.setInt(3,GROUP_ID);      
			cs2.setInt(4, Integer.parseInt(LOGIN_USER_ID));                   
			cs2.execute();
			Errbuf = cs2.getString(1);                     
			Retcode = cs2.getString(2);                
			cs2.close();
			if (Errbuf!=null)
			{
				ERR_CNT++;
				throw new Exception(Errbuf);
			}
			
			CallableStatement cs3 = con.prepareCall("{call tsc_edi_pkg.MODIFY_MO_REMARKS_INFO(?)}");
			cs3.setInt(1,GROUP_ID);      
			cs3.execute();
			cs3.close();
			
		}
						
		if (ERR_CNT==0)
		{
			if (TO_RFQ_CNT >0)
			{
				CallableStatement cs3 = con.prepareCall("{call tsc_edi_pkg.EDI_ORDERS_TRANSFER_TO_RFQ(?,?,?,?)}");
				cs3.setString(1,REQUESTNO);      
				cs3.setString(2,ERPCUSTOMERID);                   
				cs3.setString(3,CUSTPO);                   
				cs3.setString(4,"ORDCHG");                   
				cs3.execute();
				cs3.close();
			}
			if (TO_MO_CNT >0) //add by Peggy 20190521
			{
				CallableStatement cs3 = con.prepareCall("{call tsc_edi_pkg.EDI_ORDERS_TRANSFER_TO_ERP(?,?,?)}");
				cs3.setString(1,REQUESTNO);      
				cs3.setString(2,ERPCUSTOMERID);                   
				cs3.setString(3,onhand_hub_order);                   
				cs3.execute();
				cs3.close();
				//out.println("call tsc_edi_pkg.EDI_ORDERS_TRANSFER_TO_ERP('"+REQUESTNO+"','"+ERPCUSTOMERID+"','"+onhand_hub_order+"')");						
			}
		}
	
	    sql = " SELECT 1 as seq,'訂單異動' type, b.SOLD_TO_ORG_ID ERP_CUSTOMER_ID, b.customer_line_number customer_po, nvl(b.customer_shipment_number,decode( b.SOLD_TO_ORG_ID ,7147,'1','')) CUST_PO_LINE_NO, to_char(b.order_number) order_number, "+
              " b.line_number||'.'||b.shipment_number line_no, b.item_description, b.ORDERED_QUANTITY,  to_char(b.REQUEST_DATE,'yyyymmdd') cust_request_date , TO_CHAR(b.schedule_ship_date,'yyyymmdd') schedule_ship_date ,"+
              " b.SHIPPING_METHOD_CODE shipping_method,case when a.process_status is null then case when b.status ='ENTERED' then '' else '無異動' end else a.remarks end remarks, case when nvl(a.REVISE_STATUS,'Success')='Success' and nvl(a.process_status,4) ='4' then 'Success' else 'Fail' end as process_status, case when nvl(a.REVISE_STATUS,'')='Success' and nvl(a.process_status,4) ='4' then '' else a.error_explanation end as error_explanation,"+
              " b.ORDER_QUANTITY_UOM UOM, b.status,b.UNIT_SELLING_PRICE SELLING_PRICE  "+
			  ",b.SHIPPING_METHOD_NAME"+//add by Peggy 20200807
			  " FROM (select order_number, line_number,process_status,REVISE_STATUS,error_explanation,remarks from oraddman.tsc_om_salesorderrevise  where GROUP_ID= ?) a,"+
              "     (SELECT d.description item_description,c.ORDERED_QUANTITY,c.REQUEST_DATE,c.SCHEDULE_SHIP_DATE,c.SHIPPING_METHOD_CODE, c.SHIP_FROM_ORG_ID,c.FLOW_STATUS_CODE status,c.ORDER_QUANTITY_UOM,b.order_number,c.header_id, c.line_id,b.SOLD_TO_ORG_ID, c.customer_line_number,c.customer_shipment_number,c.line_number,c.shipment_number,c.UNIT_SELLING_PRICE "+
			  "     ,lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806
			  "     FROM ont.oe_order_headers_all b"+
			  "     ,ont.oe_order_lines_all c"+
			  "     ,inv.mtl_system_items_b d"+
			  "     ,(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+ //add by Peggy 20200806
			  "     where b.header_id = c.header_id"+
              "     AND  b.SOLD_TO_ORG_ID=?"+
              "     and c.customer_line_number=?"+
              "     and nvl(c.customer_shipment_number,decode(b.SOLD_TO_ORG_ID,7147,'1',c.customer_shipment_number)) in ("+CHOOSE_LINE_LIST+")"+
              "     and c.SHIP_FROM_ORG_ID=d.organization_id"+
              "     and c.inventory_item_id=d.inventory_item_id"+
			  "     and c.FLOW_STATUS_CODE <>'CANCELLED'"+  //add by Peggy 20130925
    		  "     and b.shipping_method_code = lc.lookup_code (+)"+ //add by Peggy 20200806
              "     ) b"+
              " where b.order_number=a.order_number(+)"+
              " and b.line_number||'.'||b.shipment_number=a.line_number(+)"+
              " union all"+
              " SELECT 2 as seq,'詢RFQ' type,a.ERP_CUSTOMER_ID,b.cust_po_number cust_po,a.CUST_PO_LINE_NO,a.dndocno order_number, to_char(a.line_no) line_no,b.item_description item_description,decode(b.uom,'KPC',b.quantity*1000,b.quantity) ordered_quantity,b.cust_request_date,substr(b.request_date,1,8) schedule_ship_date,b.shipping_method,'' REMARKS,NVL2(a.dndocno,'Success','Fail') process_status, '' error_explanation,'PCE' UOM,b.LSTATUS  status,b.selling_price"+
			  ",lc.meaning SHIPPING_METHOD_NAME"+ //add by Peggy 20200806
              " FROM tsc_edi_orders_his_d a"+
			  ",oraddman.tsdelivery_notice_detail b"+
			  ",(SELECT lookup_code,meaning  FROM fnd_lookup_values  WHERE  language='US' AND LOOKUP_TYPE='SHIP_METHOD') lc"+ //add by Peggy 20200806
              " where REQUEST_NO=?"+
              " and a.ERP_CUSTOMER_ID=?"+
              " and a.CUST_PO_LINE_NO in  ("+CHOOSE_LINE_LIST+")"+
              " and nvl(RFQ_QTY,0) >0 "+
              " and a.dndocno = b.dndocno(+)"+
              " and a.line_no=b.line_no(+)"+
			  "	and b.shipping_method = lc.lookup_code (+)"+ //add by Peggy 20200806
			  " order by 5,1";
		//out.println(sql);
		PreparedStatement statey = con.prepareStatement(sql);
		statey.setString(1,""+GROUP_ID);
		statey.setString(2,ERPCUSTOMERID);
		statey.setString(3,CUSTPO);
		statey.setString(4,REQUESTNO);
		statey.setString(5,ERPCUSTOMERID);
		ResultSet rsy=statey.executeQuery();
		int rowcnt=0,errcnt=0;
		String cust_line_number="";
		out.println("<table width='100%'>");
		out.println("<tr>");
		out.println("<td width='5%'>&nbsp;</td>");
		out.println("<td width='90%'>");
		while (rsy.next())
		{
			if (rowcnt==0)
			{
				out.println("<table width='100%' border='1' bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0' bordercolor='#cccccc'>");
				out.println("<tr>");
				out.println("<td width='20%' bgcolor='#64B077'><font color='white'>客戶</font></td>");
				out.println("<td width='40%'>"+CUSTOMER_NAME+"</td>");
				out.println("<td width='20%' bgcolor='#64B077'><font color='white'>客戶訂單</font></td>");
				out.println("<td width='20%'>"+CUSTPO+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td colspan='4'>");
				out.println("<table width='100%' border='1'  bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0' bordercolor='#cccccc'>");
				out.println("<tr>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>訂單項次</font></td>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>交易型態</font></td>");
				out.println("<td width='10%' bgcolor='#64B077'><font color='white'>訂單/RFQ</font></td>");
				out.println("<td width='3%' bgcolor='#64B077'><font color='white'>行號</font></td>");
				out.println("<td width='4%' bgcolor='#64B077'><font color='white'>數量</font></td>");
				out.println("<td width='3%' bgcolor='#64B077'><font color='white'>單位</font></td>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>Selling Price</font></td>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>CRD</font></td>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>SSD</font></td>");
				out.println("<td width='5%' bgcolor='#64B077'><font color='white'>出貨方式</font></td>");
				out.println("<td width='8%' bgcolor='#64B077'><font color='white'>狀態</font></td>");
				out.println("<td width='8%' bgcolor='#64B077'><font color='white'>備註</font></td>");
				out.println("<td width='4%' bgcolor='#64B077'><font color='white'>處理結果</font></td>");
				out.println("<td width='10%' bgcolor='#64B077'><font color='white'>錯誤原因</font></td>");
				out.println("</tr>");				
			}
			if (cust_line_number.equals("")) cust_line_number=rsy.getString("CUST_PO_LINE_NO");
			if (!cust_line_number.equals(rsy.getString("CUST_PO_LINE_NO")))
			{
				if (errcnt ==0)
				{
					if (OK_LINE_LIST.length()>0) OK_LINE_LIST+=",";
					OK_LINE_LIST += "'"+cust_line_number+"'";
				}
				errcnt=0;
				cust_line_number=rsy.getString("CUST_PO_LINE_NO");
			}
			if (!rsy.getString("process_status").toUpperCase().equals("SUCCESS"))
			{
				errcnt ++;
			}
			out.println("<tr>");
			out.println("<td>"+rsy.getString("CUST_PO_LINE_NO")+"</td>");
			out.println("<td>"+rsy.getString("type")+"</td>");
			out.println("<td>"+rsy.getString("order_number")+"</td>");
			out.println("<td>"+rsy.getString("line_no")+"</td>");
			out.println("<td>"+rsy.getString("ordered_quantity")+"</td>");
			out.println("<td>"+rsy.getString("uom")+"</td>");
			out.println("<td>"+(new DecimalFormat("####0.#####")).format(Float.parseFloat(rsy.getString("SELLING_PRICE")))+"</td>");
			out.println("<td>"+rsy.getString("cust_request_date")+"</td>");
			out.println("<td>"+rsy.getString("schedule_ship_date")+"</td>");
			out.println("<td>"+rsy.getString("SHIPPING_METHOD_NAME")+"</td>");
			out.println("<td>"+rsy.getString("status")+"</td>");
			out.println("<td>"+(rsy.getString("remarks")==null?"&nbsp;":rsy.getString("remarks"))+"</td>");
			out.println("<td>"+(rsy.getString("process_status").toUpperCase().equals("SUCCESS")?"<font color='blue'><strong>":"<font color='red'><strong>")+rsy.getString("process_status")+"</strong></font></td>");
			out.println("<td><font color='red'>"+(rsy.getString("error_explanation")==null?"&nbsp;":rsy.getString("error_explanation"))+"</font></td>");
			out.println("</tr>");
			
			rowcnt++;
		}
		if (errcnt ==0)
		{
			if (OK_LINE_LIST.length()>0) OK_LINE_LIST+=",";
			OK_LINE_LIST += "'"+cust_line_number+"'";
			if (OK_LINE_LIST.equals("''")) OK_LINE_LIST = CHOOSE_LINE_LIST;
		}
		
		if (rowcnt >0)
		{
			out.println("</table>");
			out.println("</td>");
			out.println("</tr>");
			out.println("</table>");
		}
		else
		{
			out.println("<div align='center'><font color='blue'>確認成功!!</font></div>");
		}
		out.println("</td><td width='5%'>&nbsp;</td></tr><tr height='30%'><td>&nbsp;</td><td><div align='center'><a href='TSCEDIExceptionQuery.jsp'>回查詢畫面</a></div></td><td>&nbsp;</td></tr>");
		out.println("</table>");
		rsy.close();
		statey.close();
		
		if (OK_LINE_LIST.length()>0)
		{
			sql = " delete tsc_edi_orders_detail a"+
				  " where a.erp_customer_id=?"+
				  " and a.customer_po=?"+
				  " and a.version_id=?"+
				  " and a.cust_po_line_no in ("+OK_LINE_LIST+")";
			//out.println(sql);
			PreparedStatement pstmt1=con.prepareStatement(sql);
			pstmt1.setString(1,ERPCUSTOMERID);
			pstmt1.setString(2,CUSTPO);
			pstmt1.setString(3,VERSION_ID);
			pstmt1.executeQuery();		
			pstmt1.close();		
				  
			sql = " insert into tsc_edi_orders_detail (erp_customer_id, customer_po, version_id,"+
				  " cust_po_line_no, seq_no, cust_item_name, tsc_item_name,"+
				  " quantity, uom, unit_price, cust_request_date,creation_date,tsc_item_no,orig_cust_item_name,orig_tsc_item_name,remarks,order_change_notice_flag,data_flag,orig_cust_request_date)"+  //add orig_cust_item_name by Peggy 20181222
				  " SELECT x.erp_customer_id, x.customer_po,?,x.cust_po_line_no,x.seq_no,"+
				  " x.cust_item_name, x.tsc_item_name, x.quantity, x.uom,"+
				  " x.unit_price, x.cust_request_date, sysdate,x.tsc_item_no,x.orig_cust_item_name,x.orig_tsc_item_name"+  //add orig_cust_item_name by Peggy 20181222
				  " ,?,?,?,x.orig_cust_request_date"+ //add by Peggy 20190408
				  " from (SELECT a.erp_customer_id, b.customer_po,a.cust_po_line_no,a.cust_po_line_no||'.'||row_number() over (partition by a.cust_po_line_no order by a.seq_no) seq_no,"+
				  " a.cust_item_name, a.tsc_item_name, a.quantity, a.uom,"+
				  " a.unit_price, a.cust_request_date,a.tsc_item_no,a.orig_cust_item_name,a.orig_tsc_item_name,a.orig_cust_request_date"+
				  " ,rank() over (partition by a.erp_customer_id, b.customer_po order by decode(a.ACTION_CODE,2,2,1)) rank_seq"+
				  " FROM tsc_edi_orders_his_d a,tsc_edi_orders_his_h b"+
				  " where a.request_no=b.request_no"+
				  " and a.erp_customer_id=b.erp_customer_id"+
				  " and a.request_no=?"+
				  " and a.erp_customer_id=?"+
				  " and b.customer_po=?"+
				  " and a.cust_po_line_no in ("+OK_LINE_LIST+")) x"+
				  " where rank_seq=1";
				  //" and a.ACTION_CODE<>'2'";
			//out.println(sql);
			PreparedStatement pstmt2=con.prepareStatement(sql);
			pstmt2.setString(1,VERSION_ID);
			pstmt2.setString(2,ORDER_REMARKS);   //add by Peggy 20190408
			pstmt2.setString(3,ORDCHG_WARNNING); //add by Peggy 20190408
			pstmt2.setString(4,CANCEL_FLAG); //add by Peggy 20190408
			pstmt2.setString(5,REQUESTNO);
			pstmt2.setString(6,ERPCUSTOMERID);
			pstmt2.setString(7,CUSTPO);
			pstmt2.executeQuery();		
			pstmt2.close();		
			
			sql = " update tsc_edi_orders_his_d a"+
				  " set a.DATA_FLAG=?"+
				  " where a.REQUEST_NO=?"+
				  " and a.ERP_CUSTOMER_ID=?"+
				  " and a.CUST_PO_LINE_NO in ("+OK_LINE_LIST+")";
			PreparedStatement pstmt3=con.prepareStatement(sql);
			pstmt3.setString(1,"Y");
			pstmt3.setString(2,REQUESTNO);
			pstmt3.setString(3,ERPCUSTOMERID);
			pstmt3.executeQuery();		
			pstmt3.close();	
				
			//add by Peggy 20160510 start		
			sql = "SELECT * FROM tsc_edi_orders_header a  where ERP_CUSTOMER_ID=?  and CUSTOMER_PO=?";
			PreparedStatement state1 = con.prepareStatement(sql);
			state1.setString(1,ERPCUSTOMERID);
			state1.setString(2,CUSTPO);
			ResultSet rs1=state1.executeQuery();
			if (!rs1.next())
			{
				sql=" insert into tsc_edi_orders_header(erp_customer_id, customer_po, version_id, request_date, by_code, dp_code, se_code, currency_code,creation_date, data_flag)"+
					" select a.erp_customer_id,a.customer_po,0,a.request_date,a.by_code,a.dp_code,a.se_code,a.currency_code,sysdate,'Y' from tsc_edi_orders_his_h a  "+     
					" where a.request_no=?"+
					" and a.erp_customer_id=?"+
					" and a.customer_po=?";
				PreparedStatement pstmtDt3=con.prepareStatement(sql);  
				pstmtDt3.setString(1,REQUESTNO); 
				pstmtDt3.setString(2,ERPCUSTOMERID);
				pstmtDt3.setString(3,CUSTPO); 
				pstmtDt3.executeQuery();
				pstmtDt3.close();
			}
			rs1.close();
			state1.close(); 
					
			sql = "SELECT count(1) FROM tsc_edi_orders_detail  a  where ERP_CUSTOMER_ID=?  and CUSTOMER_PO=? and QUANTITY >0";
			state1 = con.prepareStatement(sql);
			state1.setString(1,ERPCUSTOMERID);
			state1.setString(2,CUSTPO);
			rs1=state1.executeQuery();
			if (rs1.next())
			{		
				if (rs1.getInt(1)==0)
				{
					sql = "SELECT 1 FROM daphne_proforma_temp a where CUST_PO_NUMBER=? and exists (select 1 from ar_customers b where customer_id =? and customer_number=CUSTOMER_NO)";
					PreparedStatement state2 = con.prepareStatement(sql);
					state2.setString(1,CUSTPO);
					state2.setString(2,ERPCUSTOMERID);
					ResultSet rs2=state2.executeQuery();
					if (!rs2.next())
					{
						sql=" insert into daphne_proforma_temp (ORDER_NUMBER, CUST_PO_NUMBER,CUSTOMER_NAME, FLAG, CUSTOMER_NO ,CREATION_DATE,REGION1)"+
							" select ?,?,b.customer_name,?,b.customer_number,to_char(sysdate,'yyyymmddhh24miss'),a.region1 from apps.tsc_edi_customer a,ar_customers b"+
							" where a.CUSTOMER_ID=b.CUSTOMER_ID"+
							" and a.customer_id=?";
						PreparedStatement pstmtDt3=con.prepareStatement(sql);  
						pstmtDt3.setString(1,"1141"+(CUSTPO.length()>=5?CUSTPO.substring(CUSTPO.length()-5):CUSTPO)); 
						pstmtDt3.setString(2,CUSTPO);
						pstmtDt3.setString(3,"Y"); 
						pstmtDt3.setString(4,ERPCUSTOMERID); 
						pstmtDt3.executeQuery();
						pstmtDt3.close();		
					}
					rs2.close();
					state2.close();		
				}
			}
			rs1.close();
			state1.close();		
			//add by Peggy 20160510 end 
											
			con.commit();
		}
	}
	else
	{
		throw new Exception("交易來源不明!!");
	}
}
catch(Exception e)
{	
	con.rollback();
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCEDIExceptionQuery.jsp'>回查詢畫面</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

