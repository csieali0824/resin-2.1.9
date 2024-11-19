<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="javax.xml.parsers.*" %>  
<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
/* XML 抓取 JSP 程式 編號  TU-001 */
java.util.Date datetime = new java.util.Date();
System.out.println("datetime="+datetime);
SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd");
System.out.println("formatter="+formatter);
SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy/MM/dd HH:mm:ss");
System.out.println("formatter1="+formatter1);
String RevisedTime = (String) formatter.format( datetime );         //2003/01/01
System.out.println("RevisedTime="+RevisedTime);
String RevisedTimes = (String) formatter1.format( datetime );         //2003/01/01
System.out.println("RevisedTimes="+RevisedTimes);
String xmlname = request.getParameter("xmlname");
System.out.println();
%>
<html>
<head>
<title>XML Parser Test Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM NAME="MYFORM">
<%
//get a new document builder
DocumentBuilderFactory factory=DocumentBuilderFactory.newInstance();
DocumentBuilder builder=factory.newDocumentBuilder();
StringBuffer requestURL=HttpUtils.getRequestURL(request);
URL jspURL=new URL(requestURL.toString());
URL url=new URL(jspURL,"upload_xml/"+xmlname);
InputSource is=new InputSource(url.openStream());
String purchaseOrderList ="";
String customerPO ="";
String packingListNumber ="";
String date ="";
String customerName ="";
String customerID ="";
String shipmentTerms ="";
String currency ="";
String comments ="";
String shipToID ="";
String billToID ="";
String department ="";
String street ="";
String city ="";
String county ="";
String zip ="";
String country ="";
String b_department ="";
String b_street ="";
String b_city ="";
String b_county ="";
String b_zip ="";
String b_country ="";
String name="name";
String ID="ID";
String payterm_ID="";
String price_List_id="";
String r_Customer_ID ="";
String r_Customer_Name =""; 
String r_Party_ID ="";
String r_Party_Number ="";
String r_Orig_System_Reference ="";
String r_Price_List_ID="";
String item="";
String tscItemNo ="";
String cartonNumber ="";
String awb ="";
String serialNumber ="";
String invoiceNumber ="";
String productName ="";
String customerProductNumber ="";
String quantity=""; 
String price=""; 
String erp_customerID = "";    //20110323 add by Peggychen
String erp_shipToID = "";      //20110323 add by Peggychen
String erp_billToID = "";      //20110323 add by Peggychen
String modelName = "";         //20110323 add by Peggychen
String ErrorMsg = "";          //20110323 add by Peggychen
int ErrCnt = 0;                //20110325 add by Peggychen
String sourceCustID = "";      //20110325 add by Peggychen
String sourceBillToID = "";    //20110325 add by Peggychen
String sourceShipToID = "";    //20110325 add by Peggychen
String i_inventory_item = "";
String i_inventory_item_id ="";
String i_item ="";
int i_item_ID =0;
String i_Item_Description = "";  
String i_Item_Identifier_Type="";
boolean errFlag = false;
String currency_code = "";
 
//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
//20110824 for ERP R12 Upgrade to modify 
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();

//load the document
Document doc=builder.parse(is);
Element root=doc.getDocumentElement();
NodeList customerPOList = root.getElementsByTagName("CustomerPO");
int customerPONum =customerPOList.getLength();
//out.println("customerPONum="+customerPONum);
//out.println("customerPONum = "+customerPONum); 
//計算 cuctomerPO 的數量
for(int i=0;i<customerPONum;i++)
{
	currency_code=""; //add by Peggy 20120816
	//Element PurchaseOrderListElt = (Element)doc.getElementsByTagName("PurchaseOrderList").item(0);
	Element custPoElt = (Element)doc.getElementsByTagName("CustomerPO").item(i);
	if ( custPoElt != null && custPoElt.getAttribute(name) != null)
	{
		customerPO = custPoElt.getAttribute(name);}
		//out.println("customerPO="+customerPO);
		Element PackingPoElt = (Element)custPoElt.getElementsByTagName("PackingListNumber").item(0);
		if ( PackingPoElt != null && PackingPoElt.getFirstChild() != null)
		{
			packingListNumber = PackingPoElt.getFirstChild().getNodeValue(); 
		}
		//out.println("packingListNumber="+packingListNumber);
		try
		{
			boolean bFind = false;
			String sql_item5 = "select ID from tsc_oe_auto_headers where ID='"+customerPO+packingListNumber+"'";
			Statement st5 = con.createStatement();
			ResultSet rs5 =  null;
			rs5=st5.executeQuery(sql_item5);
 			if (rs5.next()) bFind = true;
			rs5.close();
			st5.close(); 

			if (!bFind) 
			{
				Element dateElt = (Element)custPoElt.getElementsByTagName("Date").item(0);
				if ( dateElt != null && dateElt.getFirstChild() != null)
				{
					date = dateElt.getFirstChild().getNodeValue(); 
				}
					
				Element customerNameElt = (Element)custPoElt.getElementsByTagName("CustomerName").item(0);
				if ( customerNameElt != null && customerNameElt.getFirstChild() != null)
				{
					customerName = customerNameElt.getFirstChild().getNodeValue(); 
				}
					
				Element customerIDElt = (Element)custPoElt.getElementsByTagName("CustomerID").item(0);
				if ( customerIDElt != null && customerIDElt.getFirstChild() != null)
				{
					customerID = customerIDElt.getFirstChild().getNodeValue();
						
					//20110323 add by Peggychen
					try
					{
						Element modelNameElt = (Element)custPoElt.getElementsByTagName("modelName").item(0);
						if ( modelNameElt != null && modelNameElt.getFirstChild() != null)
						{
							modelName = modelNameElt.getFirstChild().getNodeValue();
						}
						else
						{
							modelName = "";
						}
					}
					catch(Exception e) 
					{
						modelName=""; 
					}
					
					//20110325 add by Peggychen
					try
					{
						Element sourceCustIDElt = (Element)custPoElt.getElementsByTagName("sourceCustID").item(0);
						if ( sourceCustIDElt != null && sourceCustIDElt.getFirstChild() != null)
						{
							sourceCustID = sourceCustIDElt.getFirstChild().getNodeValue();
						}
						else
						{
							sourceCustID = "";
						}
					}
					catch(Exception e) 
					{
						sourceCustID=""; 
					}					
						
					//20110325 add by Peggychen
					try
					{
						Element sourceShipToIDElt = (Element)custPoElt.getElementsByTagName("sourceShipToID").item(0);
						if ( sourceShipToIDElt != null && sourceShipToIDElt.getFirstChild() != null)
						{
							sourceShipToID = sourceShipToIDElt.getFirstChild().getNodeValue();
						}
						else
						{
							sourceShipToID = "";
						}
					}
					catch(Exception e) 
					{
						sourceShipToID=""; 
					}	
						
					//20110325 add by Peggychen
					try
					{
						Element sourceBillToIDElt = (Element)custPoElt.getElementsByTagName("sourceBillToID").item(0);
						if ( sourceBillToIDElt != null && sourceBillToIDElt.getFirstChild() != null)
						{
							sourceBillToID = sourceBillToIDElt.getFirstChild().getNodeValue();
						}
						else
						{
							sourceBillToID = "";
						}
					}
					catch(Exception e) 
					{
						sourceBillToID=""; 
					}	
												
					//erp客戶ID
					String sql_cust = "select tsc_buffernet_comparison_erp.get_erp_customer_id('"+sourceCustID +"','"+customerID+"','"+sourceShipToID+"','"+modelName+"') as erp_cust_id from  dual";
					Statement st_cust = con.createStatement();
					ResultSet rs_cust =  null;
					rs_cust=st_cust.executeQuery(sql_cust);
					if (rs_cust.next())
					{
						erp_customerID = rs_cust.getString("erp_cust_id");
					}
					else
					{
						erp_customerID = customerID;
					}
					rs_cust.close();
					st_cust.close(); 							
							
					try
					{
						//String sql_item = " select CUSTOMER_ID,CUSTOMER_NAME, " +
						//				  " CUSTOMER_NUMBER,PARTY_ID,PARTY_NUMBER,ORIG_SYSTEM_REFERENCE,PRICE_LIST_ID  "+
						//				  //" from   AR_CUSTOMERS_V  where PARTY_NUMBER = '"+customerID+"'" ;
						//				  " from   AR_CUSTOMERS_V  where PARTY_NUMBER = '"+erp_customerID+"'" ; //20110323 modify by Peggychen
						//20110824 for ERP R12 Upgrade to modify 
						String sql_item = " SELECT cust.CUST_ACCOUNT_ID customer_id, substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
						                    " cust.ACCOUNT_NUMBER customer_number,party.party_id, party.party_number,"+
											" cust.orig_system_reference,cust.price_list_id "+
                                            " FROM hz_cust_accounts cust, hz_parties party"+
  											" WHERE cust.party_id = party.party_id"+
											" AND party.PARTY_NUMBER = '"+erp_customerID+"'"+
											" AND cust.status = 'A'"; //add by Peggy 20120305
						Statement st = con.createStatement();
						ResultSet rs =  null;
						rs=st.executeQuery(sql_item);
						while(rs.next())
						{
							r_Customer_ID = rs.getString("CUSTOMER_ID");
							r_Customer_Name =  rs.getString("CUSTOMER_NAME");
							r_Party_ID =  rs.getString("PARTY_ID");
							r_Party_Number =   rs.getString("PARTY_NUMBER");
							r_Orig_System_Reference =  rs.getString("ORIG_SYSTEM_REFERENCE");
							r_Price_List_ID = rs.getString("PRICE_LIST_ID"); 
						}
						rs.close();   
						st.close(); 
					}
					catch (Exception e) 
					{ 
						out.println("Exception:7"+e.getMessage()); 
					}
				}
				
				Element shipmentTermsElt = (Element)custPoElt.getElementsByTagName("ShipmentTerms").item(0);
				if ( shipmentTermsElt != null && shipmentTermsElt.getFirstChild() != null)
				{
					shipmentTerms = shipmentTermsElt.getFirstChild().getNodeValue(); 
				}
					
				Element currencyElt = (Element)custPoElt.getElementsByTagName("Currency").item(0);
				if ( currencyElt != null && currencyElt.getFirstChild() != null)
				{
					currency = currencyElt.getFirstChild().getNodeValue(); 
				}
					
				Element commentsElt = (Element)doc.getElementsByTagName("Comments").item(0);
				if ( commentsElt != null && commentsElt.getFirstChild() != null)
				{
					comments = commentsElt.getFirstChild().getNodeValue(); 
				}
				
				Element shipElt = (Element)custPoElt.getElementsByTagName("ShipToAddress").item(0);
				Element shipidElt =  (Element)shipElt.getElementsByTagName("ShipToID").item(0);
				//Element departmentElt =  (Element)shipElt.getElementsByTagName("Department").item(0);
				//Element streetElt =  (Element)shipElt.getElementsByTagName("Street").item(0);
				//Element cityElt =  (Element)shipElt.getElementsByTagName("City").item(0);
				//Element countyElt =  (Element)shipElt.getElementsByTagName("County").item(0);
				//Element zipElt =  (Element)shipElt.getElementsByTagName("Zip").item(0);
				//Element countryElt =  (Element)shipElt.getElementsByTagName("Country").item(0);
					
				if ( shipidElt != null && shipidElt.getFirstChild() != null) 
				{
					shipToID = shipidElt.getFirstChild().getNodeValue();
					Statement st_cust = con.createStatement();
					ResultSet rs_cust =  null;
					//String sql_cust = "select tsc_buffernet_comparison_erp.get_erp_shiptoid('"+sourceCustID+"','"+erp_customerID +"','"+shipToID+"') as erp_shiptoid from  dual";
					//modify by Peggy 20120823
					String sql_cust = "select tsc_buffernet_comparison_erp.get_erp_shiptoid('"+sourceCustID+"','"+erp_customerID +"','"+sourceShipToID+"') as erp_shiptoid from  dual";
					rs_cust=st_cust.executeQuery(sql_cust);
					if (rs_cust.next())
					{
						if (rs_cust.getString("erp_shiptoid").equals(sourceShipToID))
						{
							erp_shipToID = shipToID;
						}
						else
						{
							erp_shipToID = rs_cust.getString("erp_shiptoid");
						}
					}
					else
					{
						erp_shipToID = shipToID;
					}
					rs_cust.close();
					st_cust.close(); 
				}
				
				//if ( departmentElt != null && departmentElt.getFirstChild() != null)
				//{
				//	department 	= departmentElt.getFirstChild().getNodeValue(); 
				//}
						
				//if ( streetElt != null && streetElt.getFirstChild() != null)
				//{
				//	street = streetElt.getFirstChild().getNodeValue(); 
				//}
					
				//if ( cityElt != null && cityElt.getFirstChild() != null)
				//{
				//	city = cityElt.getFirstChild().getNodeValue(); 
				//}
					
				//if ( zipElt != null && zipElt.getFirstChild() != null)
				//{
				//	zip = zipElt.getFirstChild().getNodeValue();
				//}
					
				//if ( countryElt != null && countryElt.getFirstChild() != null)
				//{
				//	country = countryElt.getFirstChild().getNodeValue();
			    //}
				 
				Element billElt 	= (Element)custPoElt.getElementsByTagName("BillToAddress").item(0);
				Element billidElt =  (Element)billElt.getElementsByTagName("BillToID").item(0);
				//Element b_departmentElt =  (Element)billElt.getElementsByTagName("Department").item(0);
				//Element b_streetElt =  (Element)billElt.getElementsByTagName("Street").item(0);
				//Element b_cityElt =  (Element)billElt.getElementsByTagName("City").item(0);
				//Element b_countyElt =  (Element)billElt.getElementsByTagName("County").item(0);
				//Element b_zipElt =  (Element)billElt.getElementsByTagName("Zip").item(0);
				//Element b_countryElt =  (Element)billElt.getElementsByTagName("Country").item(0);
						
				if ( billidElt != null && billidElt.getFirstChild() != null)
				{
					billToID 	= billidElt.getFirstChild().getNodeValue(); 
					Statement st_cust = con.createStatement();
					ResultSet rs_cust =  null;
					//String sql_cust = "select tsc_buffernet_comparison_erp.get_erp_billtoid('"+sourceCustID+"','"+erp_customerID +"','"+billToID+"') as erp_billtoid from  dual";
					//modify by Peggy 20120823
					String sql_cust = "select tsc_buffernet_comparison_erp.get_erp_billtoid('"+sourceCustID+"','"+erp_customerID +"','"+sourceBillToID+"') as erp_billtoid from  dual";					
					rs_cust=st_cust.executeQuery(sql_cust);
					if (rs_cust.next())
					{
						if (rs_cust.getString("erp_billtoid").equals(sourceBillToID))
						{
							erp_billToID = billToID;
						}
						else
						{
							erp_billToID = rs_cust.getString("erp_billtoid");
						}
					}
					else
					{
						erp_billToID = billToID;
					}
					rs_cust.close();
					st_cust.close(); 
							
					try
					{   
						Statement st1=con.createStatement();
						ResultSet rs1=null;
						//String	sql = " SELECT  payment_term_id, price_list_id"+
						//		      " from (select  '1' AS sno,hcsua.payment_term_id"+
						//			  // 20100514 Marvie Add : Get price list from bill_to
						//			   ", hcsua.price_list_id "+
						//			   " from	HZ_CUST_SITE_USES_ALL hcsua, HZ_CUST_ACCT_SITES_ALL	 hcasa, "+
						//			   " HZ_PARTY_SITES hps, HZ_LOCATIONS hl  "+
						//			   //" where  hcsua.location='"+billToID+"'" +
						//			   " where hcsua.location ='" + erp_billToID + "'"+
						//			   " and hcsua.cust_acct_site_id =  hcasa.cust_acct_site_id "+
						//			   " and hcasa.party_site_id = hps.party_site_id "+
						//			   " and hps.location_id = hl.location_id " +
						//			   " UNION ALL "+  //20110325 add by Peggychen,先以billtoid抓,抓不到再以shiptoid抓
                        //               " SELECT   '2' AS sno, hcsua.payment_term_id, "+
						//			   "  hcsua.price_list_id "+
                        //              "  FROM hz_cust_site_uses_all hcsua,"+
                        //               "  hz_cust_acct_sites_all hcasa,"+
                        //               "  hz_party_sites hps,"+
                        //               "  hz_locations hl"+
                        //               " WHERE hcsua.LOCATION = '" + erp_shipToID + "'"+
                        //               " AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id"+
                        //               " AND hcasa.party_site_id = hps.party_site_id"+
                        //               " AND hps.location_id = hl.location_id"+
                        //               " ORDER BY 1)"+
						//			   " WHERE ROWNUM = 1	";								  
						//SQL錯誤,modify by Peggy 20120816
						String sql = " SELECT  payment_term_id, price_list_id,CURRENCY_CODE"+
                                     " from (select  '1',a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME,  a.FOB_POINT, a.PRICE_LIST_ID,d.CURRENCY_CODE"+
                                     " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d"+
                                     " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                                     " AND b.party_site_id = party_site.party_site_id"+
                                     " AND loc.location_id = party_site.location_id"+
                                     " and a.STATUS='A' "+
                                     " and a.PRIMARY_FLAG='Y'"+
                                     " and a.SITE_USE_ID='"+ erp_billToID +"'" +
                                     " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
                                     " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
                                     " UNION ALL "+   
                                     " select  '2',a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME,  a.FOB_POINT, a.PRICE_LIST_ID,d.CURRENCY_CODE"+
                                     " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d"+
                                     " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                                     " AND b.party_site_id = party_site.party_site_id"+
                                     " AND loc.location_id = party_site.location_id "+
                                     " and a.STATUS='A' "+
                                     " and a.PRIMARY_FLAG='Y'"+
                                     " and a.SITE_USE_ID='" + erp_shipToID + "'"+
                                     " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
                                     " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+))"+
                                     " WHERE ROWNUM = 1";
						//out.println(sql);
						rs1=st1.executeQuery(sql);
						while(rs1.next())
						{
							//shipTo_Departmaent= rs1.getString("PAYTERM_ID");
							payterm_ID = rs1.getString("payment_term_id");
							// 20100514 Marvie Add : Get price list from bill_to
							price_List_id = rs1.getString("PRICE_LIST_ID");
							//add by Peggy 20120816
							currency_code = rs1.getString("CURRENCY_CODE");
						}
						//20110413 add by Peggy
						if (price_List_id == "" || price_List_id == null || price_List_id.equals("")) 
						{
							sql= "select tsc_buffernet_comparison_erp.get_erp_pricelistid('"+sourceCustID+"','"+sourceShipToID+"') as erp_pricelistid from  dual";
							rs1=st1.executeQuery(sql);
							if (rs1.next())
							{
								price_List_id= rs1.getString("erp_pricelistid");
							}
						}
						if (currency_code ==null || currency_code.equals(""))
						{
							currency_code = currency;
						}
   						rs1.close();
						st1.close();
					}
					catch (Exception e) 
					{ 
						out.println("Exception:5"+e.getMessage()); 
					} 
				}
				
				//if ( b_departmentElt != null && b_departmentElt.getFirstChild() != null)
				//{
				//	b_department = b_departmentElt.getFirstChild().getNodeValue(); 
				//}
				
				//if ( b_streetElt != null && b_streetElt.getFirstChild() != null)
				//{
				//	b_street = b_streetElt.getFirstChild().getNodeValue(); 
				//}
				
				//if ( b_cityElt != null && b_cityElt.getFirstChild() != null)
				//{
				//	b_city = b_cityElt.getFirstChild().getNodeValue(); 
				//}
				 
				//if ( countyElt != null && countyElt.getFirstChild() != null)
				//{
				//	b_county =countyElt.getFirstChild().getNodeValue(); 
				//}
				 
				//if ( b_zipElt != null && b_zipElt.getFirstChild() != null)
				//{
				//	b_zip = b_zipElt.getFirstChild().getNodeValue(); 
				//}
				
				//if ( b_countryElt != null && b_countryElt.getFirstChild() != null)
				//{
				//	b_country = b_countryElt.getFirstChild().getNodeValue(); 
				//}
				
				// 20100517 Marvie Add : check currency
				errFlag = false;
				//if (price_List_id != null && !price_List_id.equals("") && !price_List_id.equals("null")) 
				//{
				//	currency_code = "";
				//    Statement stQP1=con.createStatement();
				//	ResultSet rsQP1=null;
				//	// use view QP_LIST_HEADERS , sometime cannot get value.
				//    String sqlQP1 = "select CURRENCY_CODE from QP_LIST_HEADERS_B  where LIST_HEADER_ID = "+price_List_id+" ";
                //    rsQP1=stQP1.executeQuery(sqlQP1);
				//    if (rsQP1.next()) 
				//	{
				//   	currency_code = rsQP1.getString("CURRENCY_CODE");
				//	}
				//    rsQP1.close();
				//    stQP1.close();
					// if (currency_code == null || currency_code.equals("") || currency_code.equals("null") || !currency_code.equals(currency)) {
				if (currency_code == null || currency_code.equals("") || currency_code.equals("null")) 
				{
					out.println("<BR>XML document customer PO:"+customerPO+"   currency error (<font color='BLUE'>"+currency_code+"</font>) Please check price list in customer master<BR>");
					errFlag = true;
					ErrCnt +=1; //20110325 add by Peggychen
				}
				//}
				//else
				//{
				//	currency_code = currency;
				//}
				if (!errFlag) 
				{
					try
					{
						//String search_sql= " select * from "
						String sql = "Insert into TSC_OE_AUTO_HEADERS " + 
						" (CUSTOMERPO,C_DATE,CUSTOMERNAME,SHIPMENTTERMS , SHIPTOID, "+    
						"  BILLTOID,COMMENTS,SALESPERSON,STATUS,PACKINGLISTNUMBER , "+
						" CREATED_BY,CREATION_DATE,CURRENCY ,CUSTOMERID,ORDER_TYPE_ID,PAYTERM_ID,PRICE_LIST,CUSTOMERNUMBER,ID ,SALES_REGION," +
						" ORIG_CUSTOMER_ID,ORIG_SHIPTOID,ORIG_BILLTOID)"+  //20110323 add by Peggychen
						" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,customerPO.trim());	  //CUSTOMERPO
						st1.setString(2,RevisedTime );
						st1.setString(3,r_Customer_Name);  //20110323 modify by Peggychen
						st1.setString(4,shipmentTerms);
						st1.setString(5,erp_shipToID);  //20110323 modify by peggychen
						st1.setString(6,erp_billToID);  //20110323 modify by peggychen
						st1.setString(7,"");
						st1.setString(8,"LCHEN");
						st1.setString(9,"OPEN");
						st1.setString(10,packingListNumber.trim()); //add trim() by Peggy 20121106
						st1.setString(11,UserName);
						st1.setString(12,RevisedTime);
						st1.setString(13,currency_code);
						st1.setString(14,erp_customerID);  //20110323 modify by peggychen
						st1.setString(15,"1091");
						st1.setString(16,payterm_ID);
						st1.setString(17,price_List_id);
						st1.setString(18,r_Customer_ID);
						st1.setString(19,customerPO.trim()+packingListNumber.trim());  //add trim() by Peggy 20121106
						st1.setString(20,"TSCE");
						st1.setString(21,sourceCustID);       //20110323 add by Peggychen
						st1.setString(22,sourceShipToID);     //20110323 add by Peggychen
						st1.setString(23,sourceBillToID);     //20110323 add by Peggychen
						System.out.println("XML--------------------------BEGIN");
						System.out.println("XML="+packingListNumber);
						System.out.println("XML="+customerPO);
						System.out.println("RevisedTime="+RevisedTime);
						System.out.println("XML--------------------------END");
						st1.executeUpdate();
					}
					catch (Exception e) 
					{ 
						out.println("Exception:4"+e.getMessage()); 
					} 
					
				  	/********************************************
				  	*   以下為計算一個customerPO裡面的Item數量  *
				  	********************************************/
				  	Element itemsElt = (Element)custPoElt.getElementsByTagName("Items").item(0);
				  	NodeList itemList= itemsElt.getElementsByTagName("Item");
				  	int itemNum =itemList.getLength();
				  	/********************************************
				  	*   計算Item數量結束                        *
				  	********************************************/
					
					for(int j=0;j<itemNum;j++)
					{
						Element itemElt =  (Element)itemsElt.getElementsByTagName("Item").item(j);
						item = itemElt.getAttribute(ID);
						Element tscItemNoElt =  (Element)itemElt.getElementsByTagName("TSCItemNo").item(0);
						Element cartonNumberElt =  (Element)itemElt.getElementsByTagName("CartonNumber").item(0);
						Element awbElt =  (Element)itemElt.getElementsByTagName("Awb").item(0);
						Element serialNumberElt =  (Element)itemElt.getElementsByTagName("SerialNumber").item(0);
						Element invoiceNumberElt =  (Element)itemElt.getElementsByTagName("InvoiceNumber").item(0);
						Element productNameElt =  (Element)itemElt.getElementsByTagName("ProductName").item(0);
						Element customerProductNumberElt =  (Element)itemElt.getElementsByTagName("CustomerProductNumber").item(0);
						Element quantityElt =  (Element)itemElt.getElementsByTagName("Quantity").item(0);
						Element priceElt =  (Element)itemElt.getElementsByTagName("Price").item(0);
						
						if ( tscItemNoElt != null && tscItemNoElt.getFirstChild() != null)
						{
							tscItemNo = tscItemNoElt.getFirstChild().getNodeValue(); 
						}
							
						if ( cartonNumberElt != null && cartonNumberElt.getFirstChild() != null)
						{
							cartonNumber 	= cartonNumberElt.getFirstChild().getNodeValue(); 
						}
							
						if ( awbElt != null && awbElt.getFirstChild() != null)
						{
							awb = awbElt.getFirstChild().getNodeValue(); 
						}
						
						if ( serialNumberElt != null && serialNumberElt.getFirstChild() != null)
						{
							serialNumber = serialNumberElt.getFirstChild().getNodeValue(); 
						}
						 
						if ( invoiceNumberElt != null && invoiceNumberElt.getFirstChild() != null)
						{
							invoiceNumber = invoiceNumberElt.getFirstChild().getNodeValue(); 
						}
						 
						 
						if ( customerProductNumberElt != null && customerProductNumberElt.getFirstChild() != null)
						{
							customerProductNumber = customerProductNumberElt.getFirstChild().getNodeValue(); 
							customerProductNumber = customerProductNumber.trim();
							
							if (productNameElt != null && productNameElt.getFirstChild() != null) 
							{
								productName = productNameElt.getFirstChild().getNodeValue();
							}
							
							try 
							{
								// 20110214 Marvie Add : one customer item mutiple TSC item
                            	boolean bItemExists = false;
								String sql_item = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
												  " ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where "+
												  " SOLD_TO_ORG_ID = '"+r_Customer_ID+"' and  ITEM = '"+customerProductNumber+"'"+
												  // 20110214 Marvie Add : one customer item mutiple TSC item
												  " and ITEM_DESCRIPTION = '"+productName+"'"+
												  " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'"; //add by Peggy 20120719
								i_item	= customerProductNumber; 	
								i_Item_Description = productName; //add by Peggy 20120924
								Statement st = con.createStatement();
								ResultSet rs =  null;
								rs=st.executeQuery(sql_item);
								while (rs.next()) 
								{
									i_inventory_item_id = rs.getString("INVENTORY_ITEM_ID"); 
									i_inventory_item	= rs.getString("INVENTORY_ITEM"); 
									i_item_ID = rs.getInt("ITEM_ID");
									i_Item_Description  = rs.getString("ITEM_DESCRIPTION"); 
									i_Item_Identifier_Type = rs.getString("ITEM_IDENTIFIER_TYPE"); 
									// 20110214 Marvie Add : one customer item mutiple TSC item
									bItemExists = true;
								}
								rs.close();   
								st.close(); 
								//客戶料號+台半品名在customer item找不到時直接留空白,add by Peggy 20120924
								/*
								// 20110214 Marvie Add : one customer item mutiple TSC item
								if (bItemExists == false) 
								{
									String sql_item1 = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
													   " ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where "+
													   " SOLD_TO_ORG_ID = '"+r_Customer_ID+"' and  ITEM = '"+customerProductNumber+"'"+
												       " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'"; //add by Peggy 20120719
													   
									Statement st1 = con.createStatement();
									ResultSet rs1 = st1.executeQuery(sql_item1);
									while (rs1.next()) 
									{
										i_inventory_item_id = rs1.getString("INVENTORY_ITEM_ID"); 
										i_inventory_item	= rs1.getString("INVENTORY_ITEM"); 
										i_item_ID = rs1.getInt("ITEM_ID");
										i_Item_Description  = rs1.getString("ITEM_DESCRIPTION"); 
										i_Item_Identifier_Type = rs1.getString("ITEM_IDENTIFIER_TYPE"); 
										bItemExists = true;
									}
									rs1.close();
									st1.close();
								}
								*/
							} 
							catch (Exception e) 
							{ 
								out.println("Exception3:"+e.getMessage()); 
							}
						}
						else
						{
							if (productNameElt != null && productNameElt.getFirstChild() != null)
							{
								productName = productNameElt.getFirstChild().getNodeValue(); 
								try
								{
									boolean bItemExists = false;
									String sql_item2 = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
													  "ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where "+
													  " ITEM_IDENTIFIER_TYPE = 'INT' and  ITEM_DESCRIPTION = '"+productName+"'"+
													  " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'"; //add by Peggy 20120719
									//out.println("xxxx="+sql_item2);
									Statement st2 = con.createStatement();
									ResultSet rs2 =  null;
									rs2=st2.executeQuery(sql_item2);
									 
									while(rs2.next())
									{
										i_inventory_item_id = rs2.getString("INVENTORY_ITEM_ID"); 
										i_inventory_item	= rs2.getString("INVENTORY_ITEM");
										i_Item_Description  = rs2.getString("ITEM_DESCRIPTION");
										i_item	= rs2.getString("INVENTORY_ITEM"); 
										i_item_ID = 0;
										i_Item_Identifier_Type = rs2.getString("ITEM_IDENTIFIER_TYPE"); 
										bItemExists = true;
									}
									rs2.close();   
									st2.close(); 
									
									//add by Peggy 20120828
									if (bItemExists == false) 
									{
										String sql_item3 = " select a.inventory_item_id,a.segment1,a.description from inv.mtl_system_items_b a"+
                                                           " where a.description ='"+productName+"'"+
                                                           " and ORGANIZATION_ID=43"+
                                                           " AND  A.INVENTORY_ITEM_STATUS_CODE <> 'Inactive'"+
                                                           " AND A.DESCRIPTION not like '%Disable%'";
										Statement st3 = con.createStatement();
										ResultSet rs3 = st3.executeQuery(sql_item3);
										 
										while(rs3.next())
										{
											i_inventory_item_id = rs3.getString("inventory_item_id"); 
											i_inventory_item	= rs3.getString("segment1");
											i_Item_Description  = rs3.getString("description");
											i_item	= rs3.getString("segment1"); 
											i_item_ID = 0;
											i_Item_Identifier_Type = ""; 
											bItemExists = true;
										}
										rs3.close();   
										st3.close(); 
									}
								}
								catch (Exception e) 
								{ 
									out.println("Exception2:"+e.getMessage()); 
								} 
								
							}
							else
							{
								out.println("白痴歐!沒資料還敢傳過來");
							}
						}
				 
						if ( quantityElt != null && quantityElt.getFirstChild() != null)
						{
							quantity = quantityElt.getFirstChild().getNodeValue(); 
						}
							
						if ( priceElt != null && priceElt.getFirstChild() != null)
						{
							price = priceElt.getFirstChild().getNodeValue(); 
						}
						
						try
						{
							String sql1 = "Insert into TSC_OE_AUTO_LINES " + 
									      " (  CUSTOMERPO ,  LINE_NO ,  ITEM_DESCRIPTION ,  INVENTORY_ITEM_ID ,  CUSTOMERPRODUCTNUMBER ,"+
								          "LINE_TYPE ,  SHIP_DATE ,  LIST_PRICE ,  SELLING_PRICE ,  UOM ,"+
								          "QUANTITY ,  CURRENCY ,  AMOUNT ,  PACKINGLISTNUMBER ,  CARTONNUMBER ,"+
								          "AWB ,  SHIPPING_INSTRUCTIONS ,  OR_LINENO ,  CREATED_BY ,  CREATION_DATE ,"+
								          "LAST_UPDATE_DATE ,  LAST_UPDATED_BY , INVENTORY_ITEM ,ITEM_IDENTIFIER_TYPE,CUSTOMERPRODUCT_ID,ID,ORIG_ITEM_DESCRIPTION)"+  //add ORIG_ITEM_DESCRIPTION by Peggy 20120727
								          " VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
							PreparedStatement st2 = con.prepareStatement(sql1);
							st2.setString(1,customerPO.trim());
							st2.setInt(2,j+1);
							st2.setString(3,i_Item_Description);
						    st2.setString(4,i_inventory_item_id);//
						    st2.setString(5,i_item);
						    st2.setInt(6,1007);//
						    st2.setString(7,RevisedTime);
						    st2.setFloat(8,Float.parseFloat(price));
						    st2.setFloat(9,Float.parseFloat(price));
						    st2.setString(10,"PCE" );
						    st2.setInt(11,Integer.parseInt(quantity));
						    st2.setString(12,currency);
						    st2.setInt(13,0);
						    st2.setString(14,packingListNumber.trim()); //add trim() by Peggy 20121106
						    st2.setString(15,cartonNumber);
						    st2.setString(16,awb);
						    st2.setString(17,invoiceNumber);
						    st2.setInt(18,j+1);
						    st2.setString(19,UserName);
						    st2.setString(20,RevisedTime);
						    st2.setString(21,RevisedTime);
						    st2.setString(22,UserName);
						    st2.setString(23,i_inventory_item);
						    st2.setString(24,i_Item_Identifier_Type);
						    st2.setInt(25,i_item_ID);
						    st2.setString(26,customerPO.trim()+packingListNumber.trim()); //add trim() by Peggy 20121106
							st2.setString(27, productName);//add by Peggy 20120727
						    st2.executeUpdate();
						    i_inventory_item_id = ""; 
							i_inventory_item	= ""; 
							i_item	= ""; 
							i_item_ID = 0;
							i_Item_Description  = ""; 
							i_Item_Identifier_Type = ""; 
						} 
						catch (Exception e) 
						{ 
							out.println("Exception1:"+e.getMessage()); 
						}
					}
				} 
				else
				{
					out.println("<script language='JavaScript' type='text/JavaScript'>");
					out.println("alert('"+"第"+i+"份訂單,單號="+customerPO+"沒上傳成功<BR>')");
					out.println("</script>");
				} 
				//這是多餘的,add by Peggy 20120904
				//else 
				//{
				//	out.println("alert('"+"Xml文件中第"+i+"份訂單,單號="+customerPO+"上傳成功<BR>')");
				//}
			}
			else 
			{
				out.println("<script language='JavaScript' type='text/JavaScript'>");
				out.println("alert('"+"Xml文件中第"+i+"份訂單,單號="+customerPO+"重複所以沒有上傳成功<BR>')");	
				out.println("</script>");
			}
		} 
		catch (Exception e)
		{ 
        	ErrCnt +=1; //20110325 add by Peggychen
			ErrorMsg = "<font color='red'>XML檔寫入資料庫發生異常,請洽系統管理員,謝謝!<br>"+ e.toString()+"";
			out.println(""+ErrorMsg); 
		}  // 最早的try
}//FOR
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<% 
	if (ErrCnt ==0)	response.sendRedirect("Tsc1211ConfirmList.jsp");
%>
</FORM>
</body>
</html>

