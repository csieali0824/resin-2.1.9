<!--20140815 Peggy,修改業務預設值-->
<!--20170503 Peggy,使用invoice+carton number+partno至packing抓22D-->
<!--20171117 Peggy,歐洲系統bug,將QUANTITY=0也丟進來,故增加QUANTITY>0判斷條件-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,"%>
<%@ page import="org.w3c.dom.*" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
String UserName=(String)session.getAttribute("USERNAME"); 
String checkbox[]= request.getParameterValues("checkbox");
%>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
</head>
<body>
<FORM NAME="MYFORM">
<%
boolean bProd = false,isError = false;
String getURL = request.getRequestURL().toString();
String packingNumber = "",customerPO ="",Customer_ID="",Customer_Name="",Party_ID="",Party_Number="",Orig_System_Reference="";
String erp_customerID="",erp_shipToID="",erp_billToID="",payterm_ID="",price_List_id="",currency_code="",shipmentTerms="";
String sourceCustID = "",sourceBillToID = "",sourceShipToID = "",currency ="";  
String customerProductNumber="",productName="",invoiceNumber="",cartonNumber="",awb="",price="",quantity="",i_inventory_item_id="";
String i_inventory_item="",i_Item_Description="",i_item="",i_Item_Identifier_Type ="",modelName="",erp_customer_number="";
int i_item_ID=0,i_item_cnt=0;
java.util.Date datetime = new java.util.Date();
SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd");
String RevisedTime = (String) formatter.format( datetime );      

if (getURL.indexOf("tsrfq.ts.com.tw") > 0 || getURL.indexOf("yewintra.ts.com.tw") > 0  || getURL.indexOf("10.0.1.134") > 0 || getURL.indexOf("10.0.1.135") > 0) 
{
	bProd = true;
}
try
{
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	cs1.execute();
	cs1.close();

	for(int i=0; checkbox != null && i<checkbox.length ;i++)
	{
		packingNumber = checkbox[i]; 
		//String sql = " SELECT distinct a.packinglistnumber, a.packinglistdate, a.shiptoaddressid, "+ 
		// 	         " a.billtoaddressid, trim(a.customerpo) customerpo, REPLACE(h.CUSTOMER_NAME,'\''',' ') name,"+
		//			 " a.shipmentterm shipmentterm2, "+
		//			 " h.CUSTOMER_NUMBER customernumber, "+
		//			 " a.customerid source_customerid, " + 
		//			 " (select customerproductnumber from tsc_packinglist_data b where b.packinglistnumber = a.packinglistnumber and trim(b.customerpo) = trim(a.customerpo) and rownum=1) as modelname,"+
        //            " cust.CUST_ACCOUNT_ID customer_id,"+
        //             " substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
        //             " cust.ACCOUNT_NUMBER customer_number,"+
        //             " party.party_id,"+
        //             " party.party_number,"+
        //             " cust.orig_system_reference,"+
        //             " cust.price_list_id"+                      
		//			 " FROM tsc_packinglist_data a, APPS.AR_CUSTOMERS h ,hz_cust_accounts cust, hz_parties party"+
		//			 " where a.BILLTOADDRESSID=h.CUSTOMER_NUMBER"+
		//			 " and a.packinglistnumber = '"+packingNumber+"'" +
		//			 " and a.customerpo is not null and a.customerpo <>'null'"+
		//			 " and cust.party_id = party.party_id"+
        //            " and a.billtoaddressid=cust.ACCOUNT_NUMBER"+
        //             " and cust.status = 'A'"+
		//			 " ORDER BY a.packinglistdate DESC,trim(a.customerpo)";	
		String sql = " select packinglistnumber, packinglistdate, shiptoaddressid,billtoaddressid,customerpo,shipmentterm2,source_customerid,CUSTOMER_NAME,CUSTOMER_ID,modelname,customer_number,party_id,party_number,orig_system_reference,price_list_id,currency,salesName"+
		             ", new_shipmentterm"+
					 " FROM (SELECT distinct a.packinglistnumber, a.packinglistdate, a.shiptoaddressid, "+ 
		 	         " a.billtoaddressid, trim(a.customerpo) customerpo, "+
					 " a.shipmentterm shipmentterm2, "+
					 " a.customerid source_customerid, " + 
					 " (select customerproductnumber from tsc_packinglist_data b where b.packinglistnumber = a.packinglistnumber and trim(b.customerpo) = trim(a.customerpo) and rownum=1) as modelname,"+
                     " cust.CUST_ACCOUNT_ID customer_id,"+
                     " substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
                     " cust.ACCOUNT_NUMBER customer_number,"+
                     " party.party_id,"+
                     " party.party_number,"+
                     " cust.orig_system_reference,"+
                     " cust.price_list_id,"+  
					 " a.currency"+//add by Peggy 20140225 
					 ",'CHRIS_LIN' salesName"+ //add by Peggy 20140815  
					 ",tsce_packinglist_pkg.GET_SHIPMENT_TERM(a.shipmentterm) new_shipmentterm"+ //add by Peggy 20220621                 
					 " FROM tsc_packinglist_data a,hz_cust_accounts cust, hz_parties party"+
					 " WHERE a.packinglistnumber = '"+packingNumber+"'" +
                     " and a.billtoaddressid=cust.ACCOUNT_NUMBER"+
			   	     " and cust.party_id = party.party_id"+
					 " and a.customerpo is not null "+
                     " and a.customerpo <>'null'"+
                     " and cust.status = 'A'"+
					 " and trunc(a.CREATION_DATE) < to_date('2013-06-04','yyyy-mm-dd')"+
					 " union all"+
					 " SELECT distinct a.packinglistnumber, a.packinglistdate, a.shiptoaddressid, "+ 
		 	         " a.billtoaddressid, trim(a.customerpo) customerpo,"+
					 " a.shipmentterm shipmentterm2, "+
					 " a.customerid source_customerid, " + 
					 " (select customerproductnumber from tsc_packinglist_data b where b.packinglistnumber = a.packinglistnumber and trim(b.customerpo) = trim(a.customerpo) and rownum=1) as modelname,"+
                     " cust.CUST_ACCOUNT_ID customer_id,"+
                     " substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
                     " cust.ACCOUNT_NUMBER customer_number,"+
                     " party.party_id,"+
                     " party.party_number,"+
                     " cust.orig_system_reference,"+
                     " cust.price_list_id,"+     
					 " a.currency"+  //add by Peggy 20140225     
					 ",jss.NAME salesName"+ //add by Peggy 20140815            
					 //" FROM tsc_packinglist_data a, hz_cust_site_uses_all b,HZ_CUST_ACCT_SITES_all c,hz_cust_accounts cust, hz_parties party"+
					 ",tsce_packinglist_pkg.GET_SHIPMENT_TERM(a.shipmentterm) new_shipmentterm"+ //add by Peggy 20220621                 
					 " FROM tsc_packinglist_data a, hz_cust_site_uses_all b,HZ_CUST_ACCT_SITES_all c,hz_cust_accounts cust, hz_parties party,jtf_rs_salesreps jss"+
                     " where a.BILLTOADDRESSID=b.site_use_id(+)"+
                     " and b.cust_acct_site_id=c.cust_acct_site_id(+)"+
                     " and c.cust_account_id=cust.cust_account_id(+) "+					 
					 " and cust.party_id = party.party_id(+)"+
					 " and a.packinglistnumber = '"+packingNumber+"'" +
					 " and a.customerpo is not null and a.customerpo <>'null'"+
					 " and a.QUANTITY>0"+ //add by Peggy 20171117
                     " and cust.status = 'A'"+
					 " and b.PRIMARY_SALESREP_ID = jss.SALESREP_ID(+)"+ //add by Peggy 20140815
					 " and trunc(a.CREATION_DATE) >= to_date('2013-06-04','yyyy-mm-dd'))"+
					 " ORDER BY packinglistdate DESC,trim(customerpo)";	
		//out.println(sql);	
		Statement st = con.createStatement();
		ResultSet rs =  st.executeQuery(sql);	
		while (rs.next()) 
		{
			customerPO = rs.getString("customerpo");
			sourceCustID = rs.getString("source_customerid");
			sourceShipToID = rs.getString("shiptoaddressid");
			sourceBillToID = rs.getString("billtoaddressid");
			modelName = rs.getString("modelname");
			erp_customer_number = rs.getString("customer_number"); 
			Customer_ID = rs.getString("CUSTOMER_ID");
			Customer_Name =  rs.getString("CUSTOMER_NAME");
			Party_ID =  rs.getString("PARTY_ID");
			Party_Number =   rs.getString("PARTY_NUMBER");
			Orig_System_Reference =  rs.getString("ORIG_SYSTEM_REFERENCE");
			price_List_id = rs.getString("PRICE_LIST_ID"); 
			if (price_List_id==null) price_List_id="";
			erp_customerID = rs.getString("PARTY_NUMBER");
			currency_code = rs.getString("CURRENCY"); //add by Peggy 20140225
			//out.println("currency_code="+currency_code);
			if (currency_code ==null) currency_code="";
			if (currency_code.equals("USD")) price_List_id="6038";
			if (currency_code.equals("EUR")) price_List_id="7331";
			//out.println("price_List_id="+price_List_id);
			
			
			String sql_item5 = "select ID from tsc_oe_auto_headers where ID='"+customerPO+packingNumber+"'";
			Statement st5 = con.createStatement();
			ResultSet rs5 =  st5.executeQuery(sql_item5);
 			if (!rs5.next())
			{

				sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+
				      " case when a.SITE_USE_ID=c.SHIPTOID then 1 when a.PRIMARY_FLAG='Y' then 2 else 3 end as secno,"+
                      " a.SITE_USE_CODE, a.SITE_USE_ID, a.PAYMENT_TERM_ID, a.PRICE_LIST_ID,  nvl(d.CURRENCY_CODE,'') CURRENCY_CODE "+
					  ",a.fob_point"+ //add by Peggy 20231206
                      " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b,SO_PRICE_LISTS d"+
					  ",(SELECT CUSTOMERNUMBER,SHIPTOID,BILLTOID FROM (SELECT CUSTOMERNUMBER,SHIPTOID,BILLTOID,row_number() over (partition by CUSTOMERNUMBER order by CREATION_DATE desc) AS ROWCNT FROM tsc_oe_auto_headers a "+
					  " where  customernumber='"+Customer_ID+"' ) g where ROWCNT=1) c "+
                      " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                      " and a.STATUS='A' "+
                      //" and a.PRIMARY_FLAG='Y'"+
                      " and b.CUST_ACCOUNT_ID ='"+Customer_ID+"'"+
                      " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
					  " and b.CUST_ACCOUNT_ID = c.CUSTOMERNUMBER(+)"+
                      " and a.SITE_USE_CODE in ('SHIP_TO','BILL_TO')"+
                      " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end"+
					  ",case when a.SITE_USE_ID=c.SHIPTOID then 1 when a.PRIMARY_FLAG='Y' then 2 else 3 end ";
				//out.println(sql);
				Statement st1 = con.createStatement();
				ResultSet rs1=st1.executeQuery(sql);
				erp_shipToID="";erp_billToID="";payterm_ID="";
				while(rs1.next())
				{
			    	//if (rs1.getString("SITE_USE_CODE").equals("SHIP_TO") && erp_shipToID.equals(""))
					//if (rs1.getString("SITE_USE_CODE").equals("SHIP_TO") && (erp_shipToID.equals("") || rs1.getString("SITE_USE_ID").equals(sourceShipToID)))
					if (rs1.getString("SITE_USE_CODE").equals("SHIP_TO") && (erp_shipToID.equals("") && rs1.getString("SITE_USE_ID").equals(sourceShipToID)))
					{
						erp_shipToID = rs1.getString("SITE_USE_ID");
						if (payterm_ID != null && payterm_ID.equals(""))
						{
							payterm_ID = rs1.getString("PAYMENT_TERM_ID");
						}
						if (price_List_id != null && price_List_id.equals(""))
						{
							price_List_id = rs1.getString("PRICE_LIST_ID");
						}
						if (currency_code != null && currency_code.equals(""))
						{
							currency_code = rs1.getString("CURRENCY_CODE");
						}
						shipmentTerms =rs1.getString("fob_point");  //add by Peggy 20231206 
					}
					//else if (rs1.getString("SITE_USE_CODE").equals("BILL_TO") && erp_billToID.equals(""))
					//else if (rs1.getString("SITE_USE_CODE").equals("BILL_TO") && (erp_billToID.equals("") || rs1.getString("SITE_USE_ID").equals(sourceBillToID)))
					else if (rs1.getString("SITE_USE_CODE").equals("BILL_TO") && (erp_billToID.equals("") && rs1.getString("SITE_USE_ID").equals(sourceBillToID)))
					{
						erp_billToID = rs1.getString("SITE_USE_ID");
						if (payterm_ID != null && payterm_ID.equals(""))
						{
							payterm_ID = rs1.getString("PAYMENT_TERM_ID");
						}
						if (price_List_id != null && price_List_id.equals(""))
						{
							price_List_id = rs1.getString("PRICE_LIST_ID");
						}
						if (currency_code != null && currency_code.equals(""))
						{
							currency_code = rs1.getString("CURRENCY_CODE");
						}
					}
				}
				rs1.close();
				st1.close();
				//shipmentTerms =rs.getString("new_shipmentterm"); //modify by Peggy 20220621	   
				/*if (rs.getString("shipmentterm2").trim().startsWith("DAP"))
				{
					shipmentTerms ="DAP";
				}
				else if (rs.getString("shipmentterm2").trim().startsWith("DDP"))
				{
					shipmentTerms ="DDP";
				}
				else if (rs.getString("shipmentterm2").trim().startsWith("DDU"))
				{
					shipmentTerms ="DDU";
				}
				else if (rs.getString("shipmentterm2").trim().startsWith("FCA"))
				{
					shipmentTerms =  "FCA MUNICH";
				}
				else
				{
					shipmentTerms ="DAP";
				}*/	
				
				sql = "Insert into TSC_OE_AUTO_HEADERS " + 
				"(CUSTOMERPO,"+
				"C_DATE,"+
				"CUSTOMERNAME,"+
				"SHIPMENTTERMS,"+
				"SHIPTOID,"+    
				"BILLTOID,"+
				"COMMENTS,"+
				"SALESPERSON,"+
				"STATUS,"+
				"PACKINGLISTNUMBER,"+
				"CREATED_BY,"+
				"CREATION_DATE,"+
				"CURRENCY,"+
				"CUSTOMERID,"+
				"ORDER_TYPE_ID,"+
				"PAYTERM_ID,"+
				"PRICE_LIST,"+
				"CUSTOMERNUMBER,"+
				"ID,"+
				"SALES_REGION," +
				"ORIG_CUSTOMER_ID,"+
				"ORIG_SHIPTOID,"+
				"ORIG_BILLTOID"+
				")"+ 
				" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				PreparedStatement st11 = con.prepareStatement(sql);
				st11.setString(1,customerPO.trim());
				st11.setString(2,RevisedTime );
				st11.setString(3,Customer_Name);
				st11.setString(4,shipmentTerms);
				st11.setString(5,erp_shipToID);
				st11.setString(6,erp_billToID);
				st11.setString(7,"");
				//st11.setString(8,"LCHEN");
				st11.setString(8,rs.getString("salesName")); //modify by Peggy 20140815
				st11.setString(9,"OPEN");
				st11.setString(10,packingNumber.trim());
				st11.setString(11,UserName);
				st11.setString(12,RevisedTime);
				st11.setString(13,currency_code);
				st11.setString(14,erp_customerID);
				st11.setString(15,"1091");
				st11.setString(16,payterm_ID);
				st11.setString(17,price_List_id);
				st11.setString(18,Customer_ID);
				st11.setString(19,customerPO.trim()+packingNumber.trim()); 
				st11.setString(20,"TSCE");
				st11.setString(21,sourceCustID);
				st11.setString(22,sourceShipToID);
				st11.setString(23,sourceBillToID);
				st11.executeUpdate();
				
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt1=con.prepareStatement(sql1);
				pstmt1.executeUpdate(); 
				pstmt1.close();	
								
				String sql2 = " SELECT a.cartonnumber, a.awb, a.invoicenumber, "+
				  	          " trim(a.customerpo) customerpo, trim(a.customerproductnumber) customerproductnumber, a.quantity, "+ 
					          " a.price,trim(a.tsc_prod_description) description "+
					          " FROM tsc_packinglist_data a "+
					          " where a.packinglistnumber = '"+packingNumber+"'" +
							  " and trim(a.customerpo) = '" + customerPO+"'"+
							  " and a.QUANTITY>0"+ //add by Peggy 20171117
					          " ORDER BY a.invoicenumber";
		        Statement st2 = con.createStatement();
		        ResultSet rs2 =  st2.executeQuery(sql2);	
				int j =0;
				while (rs2.next()) 
				{
					j++;
					customerProductNumber = rs2.getString("customerproductnumber");
					productName =  rs2.getString("description");
					invoiceNumber = rs2.getString("invoicenumber");
                    cartonNumber = rs2.getString("cartonnumber");
                    awb = rs2.getString("awb");
                    price = rs2.getString("price");
					quantity = rs2.getString("quantity");
					i_item_cnt =0;
					
					//add by Peggy 20170503,check packing 22D
					sql = " SELECT  DISTINCT INVENTORY_ITEM_ID"+
                          " FROM (select packing_no,ITEM_DESCRIPTION, INVENTORY_ITEM_ID,TSC_INV_Category(INVENTORY_ITEM_ID, 43, '23') TSC_Package,rc_datecode datecode,CARTON_NO,SHIP_TRANSACTION_NAME dn_name from tsc_packing_lines"+
                          "      WHERE packing_no='"+invoiceNumber.replace("_","")+"'"+
                          "       AND ITEM_DESCRIPTION='"+productName+"'"+
                          "       AND CARTON_NO='"+cartonNumber+"'"+
                          "       UNION ALL"+
                          "       SELECT packing_no,ITEM_DESCRIPTION, INVENTORY_ITEM_ID,TSC_INV_Category(INVENTORY_ITEM_ID, 43, '23') TSC_Package,rc_datecode datecode,CARTON_NO,SHIP_TRANSACTION_NAME dn_name from tsc_t_packing_l_fairchild"+
                          "       WHERE packing_no='"+invoiceNumber.replace("_","")+"'"+
                          "       AND ITEM_DESCRIPTION='"+productName+"'"+
                          "       AND CARTON_NO='"+cartonNumber+"'"+
                          "       ) pkg";
					//out.println(sql);
					Statement stt = con.createStatement();
					ResultSet rst =stt.executeQuery(sql);
					while (rst.next()) 
					{
						i_item_cnt ++;
					 	i_inventory_item_id= rst.getString(1);
					}
					rst.close();
					stt.close();
					
					if (i_item_cnt!=1)
					{
						i_inventory_item_id ="0";
					}

					if ( customerProductNumber != null && productName != null)
					{
						boolean bItemExists = false;
						String sql_item = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
										  " ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where "+
										  " SOLD_TO_ORG_ID = '"+Customer_ID+"' and  ITEM = '"+customerProductNumber+"'"+
										  " and ITEM_DESCRIPTION = '"+productName+"'"+
										  " and CROSS_REF_STATUS <>'INACTIVE' "+
										  " and ITEM_STATUS <>'INACTIVE'";
						if (!i_inventory_item_id.equals("0"))
						{
							sql_item+=" and inventory_item_id="+i_inventory_item_id+"";  //add by Peggy 20170503
						}
						Statement stx = con.createStatement();
						ResultSet rsx =stx.executeQuery(sql_item);
						while (rsx.next()) 
						{
							//out.println(sql_item);
							i_inventory_item_id = rsx.getString("INVENTORY_ITEM_ID"); 
							i_inventory_item	= rsx.getString("INVENTORY_ITEM"); 
							i_item_ID = rsx.getInt("ITEM_ID");
							i_Item_Description  = rsx.getString("ITEM_DESCRIPTION"); 
							i_Item_Identifier_Type = rsx.getString("ITEM_IDENTIFIER_TYPE"); 
							i_item = rsx.getString("ITEM");
							bItemExists = true;
						}
						rsx.close();   
						stx.close(); 
						
						if (bItemExists == false) 
						{
							i_item = customerProductNumber; 
							i_Item_Description = productName;
							i_item_ID = 0;
						//	i_inventory_item_id =0;  //20130415 liling modify for convert error.
							i_inventory_item_id ="0";
							i_inventory_item = "";
							i_Item_Identifier_Type = ""; 
						}
					}
					else
					{
						if ( productName != null)
						{
							boolean bItemExists = false;
							String sql_item = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
											  " ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v  "+
											  " whereITEM_IDENTIFIER_TYPE = 'INT' "+
											  " and ITEM_DESCRIPTION = '"+productName+"'"+
											  " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'"; 
							if (!i_inventory_item_id.equals("0"))
							{
								sql_item+=" and inventory_item_id="+i_inventory_item_id+"";  //add by Peggy 20170503
							}											  
							Statement stx = con.createStatement();
							ResultSet rsx = stx.executeQuery(sql_item);
							 
							while(rsx.next())
							{
								i_inventory_item_id = rsx.getString("INVENTORY_ITEM_ID"); 
								i_inventory_item	= rsx.getString("INVENTORY_ITEM");
								i_Item_Description  = rsx.getString("ITEM_DESCRIPTION");
								i_item	= rsx.getString("INVENTORY_ITEM"); 
								i_item_ID = 0;
								i_Item_Identifier_Type = rsx.getString("ITEM_IDENTIFIER_TYPE"); 
								bItemExists = true;
							}
							rsx.close();   
							stx.close(); 
							
							if (bItemExists == false) 
							{
								sql_item = " select a.inventory_item_id,a.segment1,a.description from inv.mtl_system_items_b a"+
												   " where a.description ='"+productName+"'"+
												   " and ORGANIZATION_ID=43"+
												   " AND  A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive'"+
												   " AND A.DESCRIPTION not like '%Disable%'";
								if (!i_inventory_item_id.equals("0"))
								{
									sql_item+=" and a.inventory_item_id="+i_inventory_item_id+"";  //add by Peggy 20170503
								}													   
								Statement stxx = con.createStatement();
								ResultSet rsxx = stxx.executeQuery(sql_item);
								 
								while(rsxx.next())
								{
									i_inventory_item_id = rsxx.getString("inventory_item_id"); 
									i_inventory_item	= rsxx.getString("segment1");
									i_Item_Description  = rsxx.getString("description");
									i_item	= rsxx.getString("segment1"); 
									i_item_ID = 0;
									i_Item_Identifier_Type = ""; 
									bItemExists = true;
								}
								rsxx.close();   
								stxx.close(); 
							}
						}
					}
					
					String sql22 = "Insert into TSC_OE_AUTO_LINES " + 
						   "(CUSTOMERPO"+
						   ",LINE_NO"+
						   ",ITEM_DESCRIPTION"+
						   ",INVENTORY_ITEM_ID"+
						   ",CUSTOMERPRODUCTNUMBER"+
						   ",LINE_TYPE"+
						   ",SHIP_DATE"+
						   ",LIST_PRICE"+
						   ",SELLING_PRICE"+
						   ",UOM"+
						   ",QUANTITY"+
						   ",CURRENCY"+
						   ",AMOUNT"+
						   ",PACKINGLISTNUMBER"+
						   ",CARTONNUMBER"+
						   ",AWB"+
						   ",SHIPPING_INSTRUCTIONS"+
						   ",OR_LINENO"+
						   ",CREATED_BY"+
						   ",CREATION_DATE"+
						   ",LAST_UPDATE_DATE"+
						   ",LAST_UPDATED_BY"+
						   ",INVENTORY_ITEM"+
						   ",ITEM_IDENTIFIER_TYPE"+
						   ",CUSTOMERPRODUCT_ID"+
						   ",ID"+
						   ",ORIG_ITEM_DESCRIPTION"+
						   ")"+ 
						   " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
					PreparedStatement st22 = con.prepareStatement(sql22);
				    st22.setString(1,customerPO.trim());
				    st22.setInt(2,j);
				    st22.setString(3,i_Item_Description);
				    st22.setString(4,i_inventory_item_id);
				    st22.setString(5,i_item);
				    st22.setInt(6,1007);
				    st22.setString(7,RevisedTime);
				    st22.setFloat(8,Float.parseFloat(price));
			     	st22.setFloat(9,Float.parseFloat(price));
				    st22.setString(10,"PCE" );
				    st22.setInt(11,Integer.parseInt(quantity));
				    st22.setString(12,currency_code);
				    st22.setInt(13,0);
				    st22.setString(14,packingNumber.trim()); 
				    st22.setString(15,cartonNumber);
				    st22.setString(16,awb);
				    st22.setString(17,invoiceNumber);
				    st22.setInt(18,j);
				    st22.setString(19,UserName);
				    st22.setString(20,RevisedTime);
				    st22.setString(21,RevisedTime);
				    st22.setString(22,UserName);
				    st22.setString(23,i_inventory_item);
				    st22.setString(24,i_Item_Identifier_Type);
				    st22.setInt(25,i_item_ID);
				    st22.setString(26,customerPO.trim()+packingNumber.trim()); 
				    st22.setString(27,productName);
				    st22.executeUpdate();
				}
				rs2.close();
				st2.close();
				
				if (j==0)
				{
					throw new Exception("資料異常!!");
				}
			}
			
			rs5.close();
			st5.close();
		}
		rs.close();
		st.close();
	}
	response.sendRedirect("Tsc1211ConfirmList.jsp");
}
catch(SQLException e)
{
	out.println("資料匯入發生異常!請洽系統管理人員處理,謝謝!!~("+e.toString()+")");
}
catch(Exception e)
{
	out.println("資料匯入發生異常!請洽系統管理人員處理,謝謝!!~("+e.toString()+")");
}
finally
{
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</FORM>
</body>
</html>