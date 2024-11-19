<!-- modify by Peggy 20140811,新增ORADDMAN.TSDELIVERY_NOTICE_DETAIL.END_CUSTOMER_ID欄位,來源為oraddman.tsce_end_customer_list.ERP_CUSTOMER_ID_1-->
<!-- 20161005 Peggy,轉RFQ再檢查狀態是否可轉,避免同時有一個以上USER在處理同張PO造成PO重下-->
<!-- 20181206 Peggy,slow moving check-->
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
	document.TSCEPOFORM.action=URL;
	document.TSCEPOFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSCE1214MProcess.jsp" METHOD="post" NAME="TSCEPOFORM">
<%
String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
String CUSTPO = request.getParameter("CUSTPO");
String VERSIONID = request.getParameter("VERSIONID");
String PROGRAMNAME = request.getParameter("PROGRAMNAME");
if (PROGRAMNAME == null) PROGRAMNAME ="";
String CUSTOMER_NAME= request.getParameter("CUSTOMER_NAME");
if (CUSTOMER_NAME==null) CUSTOMER_NAME="";
String ENDCUSTID= request.getParameter("ENDCUSTID");
if (ENDCUSTID==null) ENDCUSTID="";
String CURRENCY= request.getParameter("CURRENCY");
if (CURRENCY==null) CURRENCY="";
String NOCHANGE=request.getParameter("NOCHANGE");  //add by Peggy 20211130
if (NOCHANGE==null) NOCHANGE="N";
boolean slowmoving_flag = false; //add by Peggy 20141007
String sql ="",v_conti_msg="";

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
		String SALESID = request.getParameter("SALESID");
		String SALES = request.getParameter("SALES");		
		String LSTATUSID ="003",LSTATUS="ESTIMATING";
		String CUSTMARKETGROUP = request.getParameter("CUSTMARKETGROUP");
		if (CUSTMARKETGROUP==null) CUSTMARKETGROUP="";
		String END_CUST_NAME = request.getParameter("ENDCUSTNAME");
		if (END_CUST_NAME==null) END_CUST_NAME="";		
		String ERP_END_CUSTOMER_ID ="",ERP_END_CUSTOMER_NAME=""; //add by Peggy 20140811
		
		//add by Peggy 20140811
		Statement state1=con.createStatement();
		ResultSet rs1=state1.executeQuery("SELECT NVL(A.ERP_CUSTOMER_ID_1,0),B.CUSTOMER_NAME_PHONETIC  FROM  ORADDMAN.TSCE_END_CUSTOMER_LIST A,AR_CUSTOMERS B WHERE A.CUSTOMER_ID = SUBSTR('"+CUSTPO+"' ,0, INSTR('"+CUSTPO+"','-')-1) AND A.ERP_CUSTOMER_ID_1 = B.CUSTOMER_ID(+)");  
		if (rs1.next())
		{
			ERP_END_CUSTOMER_ID=rs1.getString(1);
			ERP_END_CUSTOMER_NAME =rs1.getString(2);
		}
		else
		{
			ERP_END_CUSTOMER_ID="0";
			ERP_END_CUSTOMER_NAME="";
		}
		rs1.close();
		state1.close();		

		CallableStatement cs1 = con.prepareCall("{call TSC_EDI_PKG.GET_RFQ_NO(?,?)}");
		cs1.setString(1, SALESAREANO);    
		cs1.registerOutParameter(2, Types.VARCHAR);   
		cs1.execute();
		DNDOCNO = cs1.getString(2);                    
		cs1.close();
		out.println("<input type='hidden' name='DNDOCNO' value='"+DNDOCNO+"'>");
		
		String autoCreate_Flag="";
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
		
		String chk[]= request.getParameterValues("CHKBOX");	
		int line_no =0;
		String v_line ="",PLANT_CODE="",TSC_PACKAGE="",CATEGORY_ITEM="",ORDER_TYPE_ID="",SHIPPING_METHOD="",ORDER_TYPE="";
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
				
				//chcek 狀態是否可以轉單,add by Pegy 20161005
				sql = "SELECT count(1) FROM oraddman.tsce_purchase_order_lines a  WHERE CUSTOMER_PO=? AND VERSION_ID=? AND PO_LINE_NO=?  AND DATA_FLAG IN (?)";
				PreparedStatement stateaa = con.prepareStatement(sql);
				stateaa.setString(1,CUSTPO); 
				stateaa.setString(2,VERSIONID); 
				stateaa.setString(3,request.getParameter("CUST_PO_LINE_NO_"+v_line));
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
				PLANT_CODE =request.getParameter("PLANTCODE_"+v_line);
				TSC_PACKAGE = request.getParameter("TSC_ITEM_PACKAGE_"+v_line);
				CATEGORY_ITEM = request.getParameter("CATEGORY_ITEM_"+v_line);
				SHIPPING_METHOD = request.getParameter("SHIPPINGMETHOD_"+v_line);
				//ORDER_TYPE = request.getParameter("ORDER_TYPE_"+v_line);
				ORDER_TYPE ="1214";//固定為1214訂單
				
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
				
				//add by Peggy 20221003
				sql = "SELECT TSC_CHECK_CONTI_ITEM(?,?,?) FROM DUAL";	
				PreparedStatement statementxx = con.prepareStatement(sql);
				statementxx.setString(1,(ERP_END_CUSTOMER_ID.equals("0")?null:ERP_END_CUSTOMER_ID));
				statementxx.setString(2,request.getParameter("CUST_ITEM_"+v_line));
				statementxx.setString(3,request.getParameter("TSC_ITEM_"+v_line));
				ResultSet rsxx=statementxx.executeQuery();
				if (rsxx.next())
				{	
					v_conti_msg=rsxx.getString(1);
				}
				rsxx.close();
				statementxx.close();
				if (!v_conti_msg.equals("OK") && !v_conti_msg.startsWith("Notice:"))
				{
					throw new Exception("訂單項次:"+request.getParameter("CUST_PO_LINE_NO_"+v_line)+"  "+ v_conti_msg);
				}
				
				//check slow moving stock,add by Peggy 20181206
				slowmoving_flag =false;
				if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
				while (rsh.next())
				{
					if (rsh.getString("item_desc").equals(request.getParameter("TSC_ITEM_DESC_"+v_line)))
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
					 ",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER,END_CUSTOMER_ID,PC_LEADTIME,SUPPLIER_NUMBER)"+  //add PC_LEADTIME by Peggy 20150707 //add supplier id by Peggy 20220427
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
				pstmtDtl.setString(28,"D11-001I"); // PROGRAM_NAME
				pstmtDtl.setString(29,request.getParameter("CRD_"+v_line)); 
				pstmtDtl.setString(30,SHIPPING_METHOD); 
				pstmtDtl.setString(31,ORDER_TYPE_ID); 
				pstmtDtl.setString(32,autoCreate_Flag);
				pstmtDtl.setString(33,request.getParameter("SELLINGPRICE_"+v_line));
				pstmtDtl.setString(34,request.getParameter("CUST_ITEM_"+v_line)); 
				pstmtDtl.setString(35,request.getParameter("CUST_ITEM_ID_"+v_line)); 
				pstmtDtl.setString(36,request.getParameter("ITEM_ID_TYPE_"+v_line)); 
				pstmtDtl.setString(37,request.getParameter("LINE_FOB_"+v_line)); 
				pstmtDtl.setString(38,request.getParameter("CUST_PO_LINE_NO_"+v_line));
				pstmtDtl.setString(39,""); 
				pstmtDtl.setString(40,(ERP_END_CUSTOMER_ID.equals("0")?null:ERP_END_CUSTOMER_NAME)); 
				pstmtDtl.setString(41,(ERP_END_CUSTOMER_ID.equals("0")?null:ERP_END_CUSTOMER_ID)); 
				pstmtDtl.setString(42,PLANT_CODE);                                     //modify by Peggy 20150707
				pstmtDtl.setString(43,request.getParameter("TSC_ITEM_ID_"+v_line));    //modify by Peggy 20150707
				pstmtDtl.setString(44,request.getParameter("SUPPLIER_ID_"+v_line));    //modify by Peggy 20220427
				pstmtDtl.executeQuery();
				pstmtDtl.close();
				
				sql = " UPDATE oraddman.tsce_purchase_order_lines a"+
                      " SET RFQ = ?"+
                      ",RFQ_LINE_NO =?"+
                      ",DATA_FLAG =?"+
					  ",RFQ_QTY=?*1000"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",CRD=?"+
                      " WHERE CUSTOMER_PO=?"+
					  " AND VERSION_ID=?"+
                      " AND PO_LINE_NO = ?";
				PreparedStatement pstmtDt5=con.prepareStatement(sql);  
				pstmtDt5.setString(1,DNDOCNO); 
				pstmtDt5.setString(2,""+line_no);
				pstmtDt5.setString(3,"Y");
				pstmtDt5.setString(4,request.getParameter("QUANTITY_"+v_line));
				pstmtDt5.setString(5,UserName);
				pstmtDt5.setString(6,request.getParameter("CRD_"+v_line));  //ADD BY PEGGY 20210312
				pstmtDt5.setString(7,CUSTPO); 
				pstmtDt5.setString(8,VERSIONID); 
				pstmtDt5.setString(9,request.getParameter("CUST_PO_LINE_NO_"+v_line));
				pstmtDt5.executeQuery();
				pstmtDt5.close();
					  
			}
			sql= " insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,CURR,"+
				 " AMOUNT,REQUIRE_DATE,PCCFIRM_DATE,FCTPOMS_DATE,PROD_FACTORY,REMARK,STATUSID,STATUS,CREATION_DATE,CREATED_BY,"+
				 " LAST_UPDATE_DATE,LAST_UPDATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,SALESPERSON,"+
				 " BILL_TO_ORG,PAYTERM_ID,SHIPMETHOD,FOB_POINT,AR_OVERDUE,SOURCE_CODE,SAMPLE_ORDER,SAMPLE_CHARGE,AUTOCREATE_FLAG,RFQ_TYPE"+  
				 ",SHIP_TO_CONTACT_ID,DELIVERY_TO_ORG)"+
				 " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
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
			pstmt.setString(36,"4"); //RFQ_TYPE=4(TSCE Hub PO)
			pstmt.setString(37,SHIPTOCONTACTID); 
			pstmt.setString(38,DELIVERYTOID);  
			pstmt.executeQuery();	
			pstmt.close();
			
			sql = " UPDATE oraddman.tsce_purchase_order_headers a"+
				  " SET LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  ",customer_name=?"+
				  " WHERE CUSTOMER_PO=?"+
				  " AND VERSION_ID=?";
			PreparedStatement pstmtDt6=con.prepareStatement(sql);  
			pstmtDt6.setString(1,UserName);
			pstmtDt6.setString(2,END_CUST_NAME); 
			pstmtDt6.setString(3,CUSTPO); 
			pstmtDt6.setString(4,VERSIONID); 
			pstmtDt6.executeQuery();
			pstmtDt6.close(); 
			
			sql = " select distinct 1 from APPS.TSC_CUST_PO_HEADER A "+
			      " WHERE CUST_PO_NUM = ? "+
			      " and a.CUST_NO=(select customer_number from ar_customers ac where ac.customer_id=?)";  //Party_Number 改用Customer_number寫入 modify by Peggy 20210916
			      //" AND exists (select 1  FROM hz_cust_accounts cust, hz_parties party "+
				  //" WHERE cust.party_id = party.party_id  and cust.status='A'  "+
				  //" and cust.CUST_ACCOUNT_ID=?"+
				  //" and party.party_number=a.CUST_NO)";
			PreparedStatement statex = con.prepareStatement(sql);
			statex.setString(1,CUSTPO);
			statex.setString(2,ERPCUSTOMERID);
			ResultSet rsx=statex.executeQuery();
			if (!rsx.next()) 
			{ 	
				String DOC_ID="";
				Statement stateid=con.createStatement();
				ResultSet rsid=stateid.executeQuery("SELECT MAX(DOC_ID)+1 FROM TSC_CUST_PO_HEADER"); 
				if (rsid.next())
				{
					DOC_ID = rsid.getString(1);  
				}
				rsid.close();
				stateid.close(); 				
				
				sql = " INSERT INTO APPS.TSC_CUST_PO_HEADER(DOC_ID,CUST_PO_NUM,CUST_NAME,CUST_NO,CREATED_BY,CREATED_DATE,REGION1)"+
                      //" values(?,?,(SELECT CUSTOMER_NAME FROM AR_CUSTOMERS X WHERE CUSTOMER_ID =?)"+
                      //",(select party_number  FROM hz_cust_accounts cust, hz_parties party WHERE cust.party_id = party.party_id  and cust.status='A' and cust.CUST_ACCOUNT_ID=?),?,SYSDATE,'TSCE')";
					  " select ?,?,customer_name,customer_number,?,sysdate,'TSCE' from AR_CUSTOMERS  WHERE CUSTOMER_ID =?";  //Party_Number 改用Customer_number寫入 modify by Peggy 20210916
				PreparedStatement pstmtDt7=con.prepareStatement(sql);  
				pstmtDt7.setString(1,DOC_ID); 
				pstmtDt7.setString(2,CUSTPO); 
				pstmtDt7.setString(3,UserName); 
				pstmtDt7.setString(4,ERPCUSTOMERID); 
				pstmtDt7.executeQuery();
				pstmtDt7.close();
				
				sql = " INSERT INTO APPS.TSC_CUST_PO_UPLOAD(DOC_ID,VERSION,IS_NEWEST,REMARKS,UPDATED_BY,UPDATED_TIME,STATUS,REGION1)"+
                      " values(? ,'0','Y','none',?,sysdate,'Y','TSCE' )";
				PreparedStatement pstmtDt8=con.prepareStatement(sql);  
				pstmtDt8.setString(1,DOC_ID); 
				pstmtDt8.setString(2,UserName); 
				pstmtDt8.executeQuery();
				pstmtDt8.close();
				
			}
			rsx.close();
			statex.close(); 
				  
			con.commit();
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("動作成功!!RFQ號碼:"+document.TSCEPOFORM.DNDOCNO.value);
				setSubmit("../jsp/TSCE1214ExceptionQuery.jsp");
			</script>
		<%		
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
		String TO_RFQ_SSD="",TO_RFQ_SHIPMETHOD="",TO_RFQ_ORDER_TYPE="",LINE_REMARKS="",PDNFLAG="",ERPMOSELLINGPRICE="",ERPORIGMOSELLINGPRICE="",CUST_DESC="",ITEM_NAME="";
		int CUST_PO_LINE_NO_CNT=0,CUST_PO_LINE_MO_CNT=0,TO_RFQ_CNT=0,ERR_CNT=0;
		int GROUP_ID=0;
		boolean exception_flag=false;
		//add by Peggy 20221003
		CallableStatement cs11 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
		cs11.execute();
		cs11.close();
				
		for(int i=0; i< chk.length ;i++)
		{
			CUST_PO_LINE_NO = chk[i]; 
			CUST_PO_LINE_NO_CNT = Integer.parseInt(request.getParameter("ROW_CNT_"+CUST_PO_LINE_NO));
			CUST_DESC = request.getParameter("CUST_DESC_"+CUST_PO_LINE_NO); //add by Peggy 20221003
			ITEM_DESC = request.getParameter("ITEM_DESC_"+CUST_PO_LINE_NO);
			CUST_PO_LINE_MO_CNT = Integer.parseInt(request.getParameter("MO_ROW_CNT_"+CUST_PO_LINE_NO));
			
			//CHECK DATA是否已處理
			sql = " SELECT 1 FROM oraddman.tsce_purchase_order_lines a"+
		          " WHERE a.customer_po=?"+
				  " AND a.VERSION_ID=?"+
				  " and a.PO_LINE_NO=?"+
				  " AND a.DATA_FLAG=?";
			PreparedStatement statex = con.prepareStatement(sql);
			//out.println(CUSTPO);
			//out.println(VERSIONID);
			//out.println(CUST_PO_LINE_NO);
			statex.setString(1,CUSTPO);
			statex.setString(2,VERSIONID);
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
				//add by Peggy 20221003
				sql = " SELECT INVENTORY_ITEM FROM OE_ITEMS_V A"+ 
                      " WHERE ITEM_STATUS=?"+
                      " AND CROSS_REF_STATUS=?"+
                      " AND SOLD_TO_ORG_ID=?"+
                      " AND ITEM=?"+
                      " AND ITEM_DESCRIPTION=?";
				PreparedStatement statementxx = con.prepareStatement(sql);
				statementxx.setString(1,"ACTIVE");
				statementxx.setString(2,"ACTIVE");
				statementxx.setString(3,ERPCUSTOMERID);
				statementxx.setString(4,CUST_DESC);
				statementxx.setString(5,ITEM_DESC);
				ResultSet rsxx=statementxx.executeQuery();
				if (rsxx.next())
				{	
					ITEM_NAME=rsxx.getString(1);
				}
				rsxx.close();
				statementxx.close();
				
				if (!ITEM_NAME.equals(""))
				{
					//add by Peggy 20221003
					sql = " SELECT TSC_CHECK_CONTI_ITEM(A.ERP_CUSTOMER_ID_1,?,?)"+
					      " FROM ORADDMAN.TSCE_END_CUSTOMER_LIST A"+
                          " WHERE A.ACTIVE_FLAG =?"+
                          " AND A.CURRENCY_CODE=?"+
                          " AND CUSTOMER_ID =SUBSTR(?,0,INSTR(?,'-')-1)";
					statementxx = con.prepareStatement(sql);
					statementxx.setString(1,CUST_DESC);
					statementxx.setString(2,ITEM_NAME);
					statementxx.setString(3,"A");
					statementxx.setString(4,CURRENCY);
					statementxx.setString(5,CUSTPO);
					statementxx.setString(6,CUSTPO);
					rsxx=statementxx.executeQuery();
					if (rsxx.next())
					{	
						v_conti_msg=rsxx.getString(1);
					}
					rsxx.close();
					statementxx.close();
					if (!v_conti_msg.equals("OK"))
					{
						out.println("訂單項次:"+CUST_PO_LINE_NO+"  "+ v_conti_msg);
						ERR_CNT++;
					}				
				}
			
				if (CHOOSE_LINE_LIST.length()>0) CHOOSE_LINE_LIST+=",";
				CHOOSE_LINE_LIST += "'"+CUST_PO_LINE_NO+"'";
			
				if (!NOCHANGE.equals("Y"))  //add by Peggy 20211130
				{
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
						if (PDNFLAG==null) PDNFLAG="";
						if (TO_RFQ_QTY==null || TO_RFQ_QTY.equals("")) TO_RFQ_QTY="0";
						if (Long.parseLong(TO_RFQ_QTY) >0)
						{
							try
							{
								/*sql = " update ORADDMAN.TSCE_PURCHASE_ORDER_LINES a "+
									  " set RFQ_QTY="+TO_RFQ_QTY+""+           
									  " ,REMARKS='"+LINE_REMARKS+"'"+
									  " ,PDN_FLAG='"+PDNFLAG+"'"+
									  " ,RFQ_SSD=TO_DATE('"+TO_RFQ_SSD+"','yyyymmdd')"+
									  " ,RFQ_SHIPPING_METHOD='"+TO_RFQ_SHIPMETHOD+"'"+
									  " ,CRD='"+ CRD+"'"+  //add by Peggy 20210312
									  " where CUSTOMER_PO='"+CUSTPO+"'"+
									  " AND VERSION_ID='"+VERSIONID+"'"+
									  " AND PO_LINE_NO ='"+CUST_PO_LINE_NO+"'"+
									  " AND DATA_FLAG='E'"+
									  " AND RFQ IS NULL"+
									  " AND RFQ_LINE_NO IS NULL"; */
								sql = " update ORADDMAN.TSCE_PURCHASE_ORDER_LINES a "+
									  " set RFQ_QTY=?"+           
									  " ,REMARKS=?"+
									  " ,PDN_FLAG=?"+
									  " ,RFQ_SSD=TO_DATE(?,'yyyymmdd')"+
									  " ,RFQ_SHIPPING_METHOD=?"+
									  " ,CRD=?"+  //add by Peggy 20210312
									  " where CUSTOMER_PO=?"+
									  " AND VERSION_ID=?"+
									  " AND PO_LINE_NO =?"+
									  " AND DATA_FLAG=?"+
									  " AND RFQ IS NULL"+
									  " AND RFQ_LINE_NO IS NULL"; 
								//out.println(sql);      
								PreparedStatement pstmt=con.prepareStatement(sql);
								pstmt.setString(1,TO_RFQ_QTY);
								pstmt.setString(2,LINE_REMARKS);
								pstmt.setString(3,PDNFLAG);
								pstmt.setString(4,TO_RFQ_SSD);
								pstmt.setString(5,TO_RFQ_SHIPMETHOD);
								pstmt.setString(6,CRD);
								pstmt.setString(7,CUSTPO);
								pstmt.setString(8,VERSIONID);
								pstmt.setString(9,CUST_PO_LINE_NO);
								pstmt.setString(10,"E");
								pstmt.executeQuery();	
								TO_RFQ_CNT ++;	
							}
							catch(Exception e)
							{
								out.println(e.getMessage());
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
						//if (!NOTYPE.equals("RFQ") && (!ERPMOQTY.equals(ERPORIGMOQTY) || !ERPMOCRD.equals(ERPORIGMOCRD) || !SHIPPINGMETHOD.equals(ORIGSHIPPINGMETHOD) || !ERPMOSSD.equals(ERPORIGMOSSD) || !ERPMOSELLINGPRICE.equals(ERPORIGMOSELLINGPRICE)))
						//modify by Peggy 20140219
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
							if (!ERPMOQTY.equals(ERPORIGMOQTY))
							{
								if (REMARKS.length()>0) REMARKS+=",";
								REMARKS += "QTY:"+ ERPORIGMOQTY+"=>"+ERPMOQTY;
							}
							if (!ERPMOCRD.equals(ERPORIGMOCRD))
							{
								if (REMARKS.length()>0) REMARKS+=",";
								REMARKS += "CRD:"+ ERPORIGMOCRD+"=>"+ERPMOCRD;
							}
							if (!SHIPPINGMETHOD.equals(ORIGSHIPPINGMETHOD))
							{
								if (REMARKS.length()>0) REMARKS+=",";
								REMARKS += "SHIPPING METHOD:"+ ORIGSHIPPINGMETHOD+"=>"+SHIPPINGMETHOD;
							}
							if (!ERPMOSSD.equals(ERPORIGMOSSD))
							{
								if (REMARKS.length()>0) REMARKS+=",";
								REMARKS += "SSD:"+ ERPORIGMOSSD+"=>"+ERPMOSSD;
							}
							if (!ERPMOSELLINGPRICE.equals(ERPORIGMOSELLINGPRICE))
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
								
								//add by Peggy 20141029
								/*sql = " update ORADDMAN.TSCE_PURCHASE_ORDER_LINES a "+
									  " SET LAST_UPDATED_BY='"+UserName+"'"+
									  " where CUSTOMER_PO='"+CUSTPO+"'"+
									  " AND VERSION_ID='"+CUSTPO+"'"+
									  " AND PO_LINE_NO ='"+CUSTPO+"'"+
									  " AND DATA_FLAG='E'"; */
								sql = " update ORADDMAN.TSCE_PURCHASE_ORDER_LINES a "+
									  " SET LAST_UPDATED_BY=?"+
									  " where CUSTOMER_PO=?"+
									  " AND VERSION_ID=?"+
									  " AND PO_LINE_NO =?"+
									  " AND DATA_FLAG=?"; 
								//out.println(sql);      
								pstmt3=con.prepareStatement(sql);
								pstmt3.setString(1,UserName);
								pstmt3.setString(2,CUSTPO);   
								pstmt3.setString(3,VERSIONID);   
								pstmt3.setString(4,CUST_PO_LINE_NO);   
								pstmt3.setString(5,"E");							
								pstmt3.executeQuery();	
								pstmt3.close();						
							}
							catch(Exception e)
							{	
								out.println(e.getMessage());
								ERR_CNT++;
							}
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
				out.println(Errbuf);
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
				out.println(Errbuf);
				ERR_CNT++;
				throw new Exception(Errbuf);
			}
		}
			
		if (TO_RFQ_CNT >0)
		{
			if (ERR_CNT==0)
			{
				CallableStatement cs3 = con.prepareCall("{call tsce_buffernet_po_pkg.CREATE_RFQ(?,?,?,?,?)}");
				cs3.setString(1,CUSTPO);      
				cs3.setString(2,VERSIONID);                   
				cs3.setString(3,CURRENCY);                   
				cs3.setString(4,ENDCUSTID);                   
				cs3.setString(5,"E");                   
				cs3.execute();
				cs3.close();
			}
			else
			{
				throw new Exception("create rfq fail!!");
			}
		}
	
	    sql = " SELECT 1 as seq,'訂單異動' type, b.SOLD_TO_ORG_ID ERP_CUSTOMER_ID, b.customer_line_number customer_po, b.customer_shipment_number CUST_PO_LINE_NO, to_char(b.order_number) order_number, "+
              " b.line_number||'.'||b.shipment_number line_no, b.item_description, b.ORDERED_QUANTITY,  to_char(b.REQUEST_DATE,'yyyymmdd') cust_request_date , TO_CHAR(b.schedule_ship_date,'yyyymmdd') schedule_ship_date ,"+
              " b.SHIPPING_METHOD_CODE shipping_method, decode(a.process_status,null,'無異動',a.remarks) remarks, case when nvl(a.REVISE_STATUS,'Success')='Success' and nvl(a.process_status,4) ='4' then 'Success' else 'Fail' end as process_status, case when nvl(a.REVISE_STATUS,'')='Success' and nvl(a.process_status,4) ='4' then '' else a.error_explanation end as error_explanation,"+
              " b.ORDER_QUANTITY_UOM UOM, b.status,b.UNIT_SELLING_PRICE SELLING_PRICE  FROM (select order_number, line_number,process_status,REVISE_STATUS,error_explanation,remarks from oraddman.tsc_om_salesorderrevise  where GROUP_ID= ?) a,"+
              " (SELECT d.description item_description,c.ORDERED_QUANTITY,c.REQUEST_DATE,c.SCHEDULE_SHIP_DATE,c.SHIPPING_METHOD_CODE, c.SHIP_FROM_ORG_ID,c.FLOW_STATUS_CODE status,c.ORDER_QUANTITY_UOM,b.order_number,c.header_id, c.line_id,b.SOLD_TO_ORG_ID, c.customer_line_number,c.customer_shipment_number,c.line_number,c.shipment_number,c.UNIT_SELLING_PRICE FROM ont.oe_order_headers_all b, ont.oe_order_lines_all c,inv.mtl_system_items_b d where b.header_id = c.header_id"+
              " AND  b.SOLD_TO_ORG_ID=?"+
              " and c.customer_line_number=?"+
              " and c.customer_shipment_number in ("+CHOOSE_LINE_LIST+")"+
              " and c.SHIP_FROM_ORG_ID=d.organization_id"+
              " and c.inventory_item_id=d.inventory_item_id"+
			  " and c.FLOW_STATUS_CODE <>'CANCELLED'"+  //add by Peggy 20130925
              ") b"+
              " where b.order_number=a.order_number(+)"+
              " and b.line_number||'.'||b.shipment_number=a.line_number(+)"+
              " union all"+
              " SELECT 2 as seq,'詢RFQ' type,"+ERPCUSTOMERID+" as ERP_CUSTOMER_ID,b.cust_po_number cust_po,a.PO_LINE_NO AS CUST_PO_LINE_NO,a.RFQ order_number, to_char(a.RFQ_line_no) line_no,b.item_description,decode(b.uom,'KPC',b.quantity*1000,b.quantity) ordered_quantity,b.cust_request_date,substr(b.request_date,1,8) schedule_ship_date,b.shipping_method"+
			  ",'' REMARKS,case when '"+NOCHANGE+"'='Y' then 'Success' else NVL2(a.rfq,'Success','Fail') end process_status"+
			  ", case when '"+NOCHANGE+"'='Y' then '' else NVL2(a.rfq,'',a.EXCEPTION_DESC) end error_explanation,'PCE' UOM,b.LSTATUS  status,b.selling_price"+
              " FROM oraddman.tsce_purchase_order_lines a,oraddman.tsdelivery_notice_detail b"+
              " where a.CUSTOMER_PO=?"+
			  " and a.VERSION_ID=?"+
              " and a.PO_LINE_NO in  ("+CHOOSE_LINE_LIST+")"+
              " and nvl(RFQ_QTY,0) >0 "+
			  //" AND a.rfq is not null "+ //modify by Peggy 20200814
              " and a.RFQ = b.dndocno(+)"+
              " and a.RFQ_LINE_NO=b.line_no(+)"+
			  " order by 5,1";
		//out.println(sql);
		PreparedStatement statey = con.prepareStatement(sql);
		statey.setString(1,""+GROUP_ID);
		statey.setString(2,ERPCUSTOMERID);
		statey.setString(3,CUSTPO);
		statey.setString(4,CUSTPO);
		statey.setString(5,VERSIONID);
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
				out.println("<table width='100%' border='1' bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>");
				out.println("<tr>");
				out.println("<td width='20%' bgcolor='#64B077'><font color='white'>客戶</font></td>");
				out.println("<td width='40%'>"+CUSTOMER_NAME+"</td>");
				out.println("<td width='20%' bgcolor='#64B077'><font color='white'>客戶訂單</font></td>");
				out.println("<td width='20%'>"+CUSTPO+"</td>");
				out.println("</tr>");
				out.println("<tr>");
				out.println("<td colspan='4'>");
				out.println("<table width='100%' border='1'  bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1'  cellspacing='0'>");
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
			out.println("<td>"+(rsy.getString("order_number")==null?"&nbsp;":rsy.getString("order_number"))+"</td>");
			out.println("<td>"+(rsy.getString("line_no")==null?"&nbsp;":rsy.getString("line_no"))+"</td>");
			out.println("<td>"+(rsy.getString("ordered_quantity")==null?"&nbsp;":rsy.getString("ordered_quantity"))+"</td>");
			out.println("<td>"+(rsy.getString("uom")==null?"&nbsp;":rsy.getString("uom"))+"</td>");
			out.println("<td>"+(rsy.getString("SELLING_PRICE")==null?"&nbsp;":(new DecimalFormat("####0.#####")).format(Float.parseFloat(rsy.getString("SELLING_PRICE"))))+"</td>");
			out.println("<td>"+(rsy.getString("cust_request_date")==null?"&nbsp;":rsy.getString("cust_request_date"))+"</td>");
			out.println("<td>"+(rsy.getString("schedule_ship_date")==null?"&nbsp;":rsy.getString("schedule_ship_date"))+"</td>");
			out.println("<td>"+(rsy.getString("shipping_method")==null?"&nbsp;":rsy.getString("shipping_method"))+"</td>");
			out.println("<td>"+(rsy.getString("status")==null?"&nbsp;":rsy.getString("status"))+"</td>");
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
		out.println("</td><td width='5%'>&nbsp;</td></tr><tr height='30%'><td>&nbsp;</td><td><div align='center'><a href='TSCE1214ExceptionQuery.jsp'>回查詢畫面</a></div></td><td>&nbsp;</td></tr>");
		out.println("</table>");
		rsy.close();
		statey.close();
		
		if (OK_LINE_LIST.length()>0)
		{
			sql = " update oraddman.tsce_purchase_order_lines a"+
				  " set a.DATA_FLAG=?"+
				  ",LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  ",NO_CHANGE_FLAG=decode(?,'Y','Y','')"+
				  " where CUSTOMER_PO=?"+
				  " AND VERSION_ID=?"+
				  " and a.PO_LINE_NO in ("+OK_LINE_LIST+")";
			PreparedStatement pstmt3=con.prepareStatement(sql);
			pstmt3.setString(1,"Y");
			pstmt3.setString(2,UserName);
			pstmt3.setString(3,NOCHANGE);
			pstmt3.setString(4,CUSTPO);
			pstmt3.setString(5,VERSIONID);
			pstmt3.executeQuery();		
			pstmt3.close();	
						
			sql = " update oraddman.tsce_purchase_order_headers a"+
				  " set LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=sysdate"+
				  " where CUSTOMER_PO=?"+
				  " AND VERSION_ID=?";
			PreparedStatement pstmt6=con.prepareStatement(sql);
			pstmt6.setString(1,UserName);
			pstmt6.setString(2,CUSTPO);
			pstmt6.setString(3,VERSIONID);
			pstmt6.executeQuery();		
			pstmt6.close();							
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
	out.println("<font color='red'>交易失敗,請速洽系統管理人員,謝謝!!<br>"+e.getMessage()+"<br><br><a href='TSCE1214ExceptionQuery.jsp'>回查詢畫面</a></font>");
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

