<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>Sales Delivery Request M Data Process</title>
<%@ page import="DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<TABLE><TR><TD><A HREF="Tsc1211ConfirmList.jsp"><font size="2">回上一頁</font></A></TD></TR></TABLE>
<%

String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);
//String HourFr=dateBean.getHourMinuteSecond().substring(0,2);
//String MinuteFr=dateBean.getHourMinuteSecond().substring(2,4);
//String SecondFr=dateBean.getHourMinuteSecond().substring(4,6);
//out.println("AA="+HourFr+"hour"+MinuteFr+"MinuteFr"+SecondFr+"SecondFr"+"<br>");
//java.util.Date datetime = new java.util.Date();

//SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd");
//SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy/MM/dd HH:mm:ss");
//String RevisedTime = (String) formatter.format( datetime );         //2003/01/01
//String RevisedTimes = (String) formatter1.format( datetime );         //2003/01/01
//DateFormat  datetime2 = DateFormat.getDateInstance(DateFormat.LONG, Locale.TAIWAN);
//out.println("datetime2="+datetime2+"<br>");
//out.println("datetime="+datetime+"<br>");
//out.println("RevisedTimes="+RevisedTimes+"<br>");
   
   
 String processStatus = "";
 int headerID = 0;   // 把第二次的更新 Header ID 取到
 
 String orderNo = "";
 String errorMessageHeader = "";
//java.sql.Date datetime2 = (java.sql.Date)datetime;
//out.println("datetime2="+datetime2+"<br>");
   java.sql.Date orderedDate 	= new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
   java.sql.Date shipdate 		= new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
   java.sql.Date requestdate 	= new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
   java.sql.Date pricedate 		= new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
   java.sql.Date promisedate 	= new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date
   //out.println(promisedate);
	String customerPO=request.getParameter("customerPO");
	String status =request.getParameter("status");
	String customerID =request.getParameter("customerID");
		
	CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	cs1.execute();
	cs1.close();
									//  1.Org ID 	"41"
	String oraUserID="3077";  		//  2.User ID 	
	String respID="50124";   		//  3.使用的Responsibility ID --> TSC_OM_Semi_SU	
	String customerNumber="";
	String firmOrderType="";  		//  4.Order Type ID 	
	String firmSoldToOrg="";   		//  5.SoldToOrg = 客戶代號	
	String firmPriceList="";    	//  6.PriceList 	
	String ShipToOrg="";   			//  7.Ship To Org 
	//String orderedDate="";    	//  8.Ordered Date 
	String billTo="";    			//  9.Bill To Org(Invoice To Org)  
	String payTermID="";    		//  10.Payment Term ID  
	String shipMethod="";    		//  11.Shipping Method Code 	
	String fobPoint="";    			//  12.FOB Point Code  
	String custPO="";    			//  13.Customer PO  
									//	14 
	String InventoryItemID=""; 		//  15.InventoryItemID 	
	String InventoryItem=""; 		//  16.Inventory Item  	
	String orderQty="";    			//  17.Ordered Quantity
	String lineType=""; 	    	//  18.Line Type 	
	//String shipdate="";   		//  19.Schedule Shup Date 	
	//String requestdate="";   		//  20.Request Date 	
	//String pricedate="";   		//  21.Pricing Date 	
	//String promisedate="";   		//  22.Promise Date 
	String sourceTypeCode="";   	//  23.Source Type Code  		
	String unitSellingPrice="";  	//  24.Unit Selling Price 	
	String shippingInstructions=""; //  25.Shipping Instructions發票號  
	String packInstructions="";   	//  26.Packing Instructions生管判定產地  
	String oPcAcpDate="";   		//  27.Attributes8 生管交期排定日  
	//String unitSellingPrice="";   //  28.Unit Selling Price Per Q'ty 
	String primaryUOM="";   		//  29.更改的訂購單位
	
	String line_No=""; 
	String customerProductNumber ="";
	String customerProduct_ID ="";
	String i_Item_Identifier_Type="";
 
   
//cs3.registerOutParameter(30, Types.VARCHAR); //  訂單處理訊息 
//cs3.registerOutParameter(31, Types.INTEGER); //  訂單HEADER ID 
//cs3.registerOutParameter(32, Types.VARCHAR); //  訂單號碼 
//cs3.registerOutParameter(33, Types.VARCHAR); //  未成功錯誤訊息 
//out.println("customerPO="+customerPO);
//out.println("status="+status);
	try{   
		Statement st1=con.createStatement();
		ResultSet rs1=null;
		String	sql = "select * from tsc_oe_auto_headers where  customerPo='"+customerPO+"' and " +
					  " status = '"+"CLOSED"+"' and  customerID ='"+customerID +"'";
		//out.println(sql);
		rs1=st1.executeQuery(sql);
			if (rs1.next()==false){
		
			}
		//out.println("gogogoqw");
		//while(rs1.next()){
	 	//}
		 rs1.close();   
		 st1.close(); 
	}catch (Exception e) { out.println("Exception1:"+e.getMessage()); } 



	try{   
		Statement st1=con.createStatement();
		ResultSet rs1=null;
		String	sql = "select a.*,b.* from tsc_oe_auto_headers a , tsc_oe_auto_lines b  where  a.customerPo= b.customerPo and a.customerPo='"+customerPO+"' order by OR_LINENO asc  ";
		//out.println(sql);
		rs1=st1.executeQuery(sql);
		int k =0;
			while (rs1.next()){
					//oraUserID="2743";
					//respID=rs1.getString(); 
  					firmOrderType=rs1.getString("ORDER_TYPE_ID");	
					firmSoldToOrg=rs1.getString("CUSTOMERNUMBER");
					firmPriceList=rs1.getString("PRICE_LIST");
					ShipToOrg=rs1.getString("SHIPTOID");	 
					billTo=rs1.getString("BILLTOID");
					payTermID=rs1.getString("PAYTERM_ID");
					line_No=rs1.getString("OR_LINENO");
					fobPoint=rs1.getString("SHIPMENTTERMS");
					custPO=customerPO;
					customerNumber=rs1.getString("CUSTOMERNUMBER");
					InventoryItemID=rs1.getString("INVENTORY_ITEM_ID");
					InventoryItem=rs1.getString("INVENTORY_ITEM");
					orderQty=rs1.getString("QUANTITY");
					lineType=rs1.getString("LINE_TYPE");
					unitSellingPrice=rs1.getString("SELLING_PRICE");  	 
					shippingInstructions=rs1.getString("SHIPPING_INSTRUCTIONS");  	 
					packInstructions="Y";
					customerProductNumber=rs1.getString("CUSTOMERPRODUCTNUMBER");	
					i_Item_Identifier_Type=rs1.getString("ITEM_IDENTIFIER_TYPE");	
					customerProduct_ID=rs1.getString("CUSTOMERPRODUCT_ID");	
					
					oPcAcpDate="";   		 
					//unitSellingPrice=rs2.getString("SELLING_PRICE");  
					primaryUOM="PCE"; 
			
				if(k==0){
					//Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
					 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_CREATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
					 cs3.setString(1,"41");  //  Org ID 	
					 cs3.setInt(2,Integer.parseInt("2820")); // User ID 	
					 cs3.setInt(3,Integer.parseInt(respID));  //  使用的Responsibility ID --> TSC_OM_Semi_SU	
					 cs3.setInt(4,Integer.parseInt(firmOrderType));  //  Order Type ID 	
					 cs3.setInt(5,Integer.parseInt(firmSoldToOrg));  //  SoldToOrg = 客戶代號	
					 cs3.setInt(6,Integer.parseInt(firmPriceList));  //  PriceList 	
					 cs3.setInt(7,Integer.parseInt(ShipToOrg));  //  Ship To Org 
					 cs3.setDate(8,orderedDate);  //  Ordered Date 
					 cs3.setInt(9,Integer.parseInt(billTo));  //  Bill To Org(Invoice To Org)  
					 cs3.setInt(10,Integer.parseInt(payTermID));  //  Payment Term ID  
					 cs3.setString(11,"N/A");  //  Shipping Method Code
					 cs3.setString(12,fobPoint);  //  FOB Point Code  
					 cs3.setString(13,custPO);  //  Customer PO  
					 cs3.setString(14,"N/A");  //  Currency Code  	 // 不傳入Currency Code,由Price List自己帶入			 	 
					 cs3.setInt(15,Integer.parseInt(InventoryItemID));  //  InventoryItemID 	
					 cs3.setString(16,customerProductNumber);  //  Inventory Item  	
					 cs3.setFloat(17,Float.parseFloat(orderQty));  //  Ordered Quantity
					 cs3.setInt(18,Integer.parseInt(lineType));  //  Line Type 	
					 cs3.setDate(19,shipdate);  //  Schedule Shup Date 	
					 cs3.setDate(20,requestdate);  //  Request Date
					 cs3.setDate(21,pricedate);  //  Pricing Date 	
					 cs3.setDate(22,promisedate);  //  Promise Date 
					 cs3.setString(23,"INTERNAL");  //  Source Type Code  	
					 cs3.setFloat(24,Float.parseFloat(unitSellingPrice));  //  Unit Selling Price 
		 
					 cs3.setString(25,shippingInstructions);  //  Shipping Instructions發票號  
					 //out.println("shippingInstructions="+shippingInstructions);
					 cs3.setString(26,"");  //  Packing Instructions生管判定產地 
					 cs3.setString(27,"");  //  Attributes8 生管交期排定日  
					 cs3.setFloat(28,Float.parseFloat(unitSellingPrice));  // 
					 //out.println("Float.parseFloat(unitSellingPrice)="+Float.parseFloat(unitSellingPrice));
					 cs3.setString(29,"PCE");  //  更改的訂購單位
					 /*new*/
					 cs3.setInt(30,Integer.parseInt(customerProduct_ID));  //  
					 cs3.setString(31,i_Item_Identifier_Type);  //   
					 /*new*/
					 cs3.setInt(32,0);  //  
					 cs3.setInt(33,0);  //   
					 cs3.setString(34,"");  //     
					 /*new*/
					 cs3.registerOutParameter(35, Types.VARCHAR); //  訂單處理訊息 
					 cs3.registerOutParameter(36, Types.INTEGER); //  訂單HEADER ID 
					 cs3.registerOutParameter(37, Types.VARCHAR); //  訂單號碼 
					 cs3.registerOutParameter(38, Types.VARCHAR); //  未成功錯誤訊息 
					 cs3.execute();
					 // out.println("Procedure : Execute Success !!! ");
					 processStatus = cs3.getString(35);
					 //out.println("processStatus ="+processStatus+"<br>");
					 headerID = cs3.getInt(36);   // 把第二次的更新 Header ID 取到<br>
					 //out.println("headerID ="+headerID+"<br>");
					 //double orderNo = cs3.getDouble(12);
					 orderNo = cs3.getString(37);
					 //out.println("orderNo ="+orderNo+"<br>");
					 errorMessageHeader = cs3.getString(38);
					 //out.println("errorMessageHeader ="+errorMessageHeader+"<br>");
					 out.println("<table border='1' cellpadding='1' cellspacing='1' width='100%'>");
					 out.println("<tr><td><div>第"+(k+1)+"筆資料,訂單名稱="+orderNo+"<br></div></td></tr>");
					 out.println("<tr><td><div>客戶Item資料="+customerProductNumber+"</div></td></tr>");
					 out.println("</table><br>");
					 
					 
					 //out.println("k1="+k);				
					 cs3.close();
					 //out.println("k="+k);				
					 
				}else if (k>0) {    
						//	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No				  
						CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_UPDATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 				 
						cs3.setString(1,"41");  /*  Org ID */	
 						cs3.setInt(2,Integer.parseInt("2820"));  /* User ID */	
						cs3.setInt(3,Integer.parseInt(respID));  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
						cs3.setInt(4,Integer.parseInt(firmOrderType));  /*  Order Type ID */	
						cs3.setInt(5,Integer.parseInt(firmSoldToOrg));  /*  SoldToOrg */	
						cs3.setInt(6,Integer.parseInt(firmPriceList));  /*  PriceList */	
						cs3.setInt(7,Integer.parseInt(ShipToOrg));  /*  Ship To Org */				
						cs3.setDate(8,orderedDate);  /*  Ordered Date */	
						cs3.setInt(9,headerID);  /*  更新的  Header Id */
						//out.println("headerID123="+headerID);
						cs3.setInt(10,Integer.parseInt(line_No));  /*  增加的  LineNo */
						//out.println("line_No="+line_No);
						cs3.setInt(11,Integer.parseInt(billTo));  /*  Bill To Org(Invoice To Org) */ 
						cs3.setInt(12,Integer.parseInt(payTermID));  /*  Payment Term ID */ 
						cs3.setString(13,"N/A");  /*  Shipping Method Code */	
						cs3.setString(14,fobPoint);  /*  FOB Point Code  */
						cs3.setString(15,custPO);  /*  Customer PO  */
						cs3.setString(16,"N/A");  /*  Currency Code  */ // 不傳入Currency Code,由Price List自己帶入							  					     
						cs3.setInt(17,Integer.parseInt(InventoryItemID));  /*  InventoryItemID */				
						cs3.setString(18,customerProductNumber);  /*  Ordered Item  可能是客戶料號 */				
						//cs3.setFloat(19,Float.parseFloat(aSalesOrderGenerateCode[i][2]));  /*  Order Quantity */	
						cs3.setFloat(19,Float.parseFloat(orderQty));  /*  Order Quantity */			
						cs3.setInt(20,Integer.parseInt(lineType));  /*  Line Type */				
						cs3.setDate(21,shipdate);  /*  Schedule Shup Date */	
						cs3.setDate(22,requestdate);  /*  Request Date */	
						cs3.setDate(23,pricedate);  /*  Pricing Date */
						cs3.setDate(24,promisedate);  /*  Promise Date */					
						cs3.setString(25,"INTERNAL");  /*  Source Type Code  */				
						//out.println("asdf");
						cs3.setFloat(26,Float.parseFloat(unitSellingPrice));  /*  Unit Selling Price */	
						out.println("Float.parseFloat(unitSellingPrice)="+Float.parseFloat(unitSellingPrice));
						cs3.setString(27,shippingInstructions);  /*  Shipping Instructions發票號  */
						cs3.setString(28,packInstructions);  /*  Packing Instructions生管判定產地  */	
						cs3.setString(29,oPcAcpDate);  /*  Attributes8 生管交期排定日  */	
						cs3.setFloat(30,Float.parseFloat(orderQty));  /*  Unit Selling Price Per Q'ty */
						cs3.setString(31,primaryUOM);  /*  更改的訂購單位  */			
						/*new*/
						cs3.setInt(32,);  /*  更改的訂購單位  */			
						cs3.setString(33,"");  /*  更改的訂購單位  */			
						/*new*/
						cs3.setInt(34,Integer.parseInt(customerProduct_ID));  /*  客戶料件ID  */
						cs3.setString(35,i_Item_Identifier_Type);  /*  v_line_item_identifier_type */
						//out.println("i_Item_Identifier_Type="+i_Item_Identifier_Type);
						cs3.setString(36,"N");  /*  Item ID Type  */
						cs3.registerOutParameter(37, Types.VARCHAR); /*  訂單處理訊息 */	
						cs3.registerOutParameter(38, Types.INTEGER); /*  訂單HEADER ID */	
						//cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
						cs3.registerOutParameter(39, Types.VARCHAR); /*  訂單號碼 */	
						cs3.registerOutParameter(40, Types.VARCHAR); /*  未成功錯誤訊息 */
						//out.println("<br>begin<br>");
						cs3.execute();
						//out.println("<br>end<br>");
						// out.println("Procedure : Execute Success !!! ");
						String processStatusLine = cs3.getString(37);
						headerID = cs3.getInt(38);
						//out.println("headerID="+headerID);
						//double orderNo = cs3.getDouble(12);
						orderNo = cs3.getString(39);
						//out.println("orderNo="+orderNo);
						String errorMessageLine = cs3.getString(40);
						
					    out.println("<table border='1' cellpadding='1' cellspacing='1' width='100%'>");
					    out.println("<tr><td><div>第"+(k+1)+"筆資料,訂單名稱="+orderNo+"<br></div></td></tr>");
					    out.println("<tr><td><div>客戶Item資料="+customerProductNumber+"</div></td></tr>");
					    out.println("</table><br>");
						cs3.close();
	   			}k++;
				
				if(orderNo == null){
						
				}else{
					try{
						String sql1 = "update  TSC_OE_AUTO_HEADERS  set ORDER_NUMBER=? ,STATUS=?  where CustomerPO='"+customerPO+"'";
						PreparedStatement pstmt=con.prepareStatement(sql1);            
						pstmt.setString(1,orderNo);  // Line Type
						pstmt.setString(2,"CLOSED");  // Line Type
						pstmt.executeUpdate(); 
						pstmt.close();
						//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?customerPO="+customerPO);
						//response.sendRedirect("Tsc1211ConfirmList.jsp");
					}catch(SQLException e){out.println(e.toString());}
				} 
			}
		 rs1.close();   
		 st1.close(); 
		 //out.println("k="+k);
	}catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
	
	

	
	
 
 
  //	
				   

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
