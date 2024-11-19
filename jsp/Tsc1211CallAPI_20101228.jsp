<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%> 
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>Sales Delivery Request M Data Process</title>
<%@ page import="DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">

</head>
<body>
<TABLE><TR><TD><A HREF="Tsc1211ConfirmList.jsp"><font size="2">回上一頁</font></A></TD></TR></TABLE>

<%
 String  user_ID 	  = "";
 
	try{
	String sql="";
/*  20101123 liling update 避免跨區的帳號都要來這裡再寫一段else
	   user_ID 	  =  (String)session.getAttribute("USERNAME");
	   if(user_ID =="CLOVER_TSCA" || user_ID.equals("CLOVER_TSCA")){
			 sql = " select USER_NAME , USER_ID from FND_USER  where  USER_NAME = 'CLOVER' ";
	   }else{
			  sql = " select USER_NAME , USER_ID from FND_USER  where  USER_NAME = upper('"+(String)session.getAttribute("USERNAME")+"')";
	   }
	*/	
		sql = " SELECT distinct ERP_USER_ID USER_ID FROM ORADDMAN.WSUSER WHERE USERNAME =  upper('"+(String)session.getAttribute("USERNAME")+"')";
		//out.println(sql);
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(sql);
		 while(rs.next()){
		 	user_ID = rs.getString("USER_ID") ;
			//out.println("USER_ID="+user_ID);
		 }
		rs.close();   
		st.close(); 
	}catch(SQLException e){out.println(e.toString());}
 
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
	String keyID = request.getParameter("ID");
	out.println("keyID="+keyID);
	String customerNumberPre = request.getParameter("CUSTOMER_NUMBER");//
		
	CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	cs1.execute();
	cs1.close();
									//  1.Org ID 	"41"
	String oraUserID="3077";  		//  2.User ID 	
	String respID="50124";   		//  3.使用的Responsibility ID --> TSC_OM_Semi_SU	
	//String customerNumber="";
	//String firmOrderType="";  		//  4.Order Type ID 	
	//String firmSoldToOrg="";   		//  5.SoldToOrg = 客戶代號	
	//String firmPriceList="";    	//  6.PriceList 	
	//String ShipToOrg="";   			//  7.Ship To Org 
	// String orderedDate="";    	//  8.Ordered Date 
	//String billTo="";    			//  9.Bill To Org(Invoice To Org)  
	//String payTermID="";    		//  10.Payment Term ID  
	//String shipMethod="";    		//  11.Shipping Method Code 	
	//String fobPoint="";    			//  12.FOB Point Code  
	//String custPO="";    			//  13.Customer PO  
									//	14 
	//String InventoryItemID=""; 		//  15.InventoryItemID 	
	//String InventoryItem=""; 		//  16.Inventory Item  	
	//String orderQty="";    			//  17.Ordered Quantity
	//String lineType=""; 	    	//  18.Line Type 	
	//String shipdate="";   		//  19.Schedule Shup Date 	
	//String requestdate="";   		//  20.Request Date 	
	//String pricedate="";   		//  21.Pricing Date 	
	//String promisedate="";   		//  22.Promise Date 
	String sourceTypeCode="";   	//  23.Source Type Code  		
	//String unitSellingPrice="";  	//  24.Unit Selling Price 	
	//String shippingInstructions=""; //  25.Shipping Instructions發票號  
	//String packInstructions="";   	//  26.Packing Instructions生管判定產地  
	//String oPcAcpDate="";   		//  27.Attributes8 生管交期排定日  
	//String unitSellingPrice="";   //  28.Unit Selling Price Per Q'ty 
	//String primaryUOM="";   		//  29.更改的訂購單位
	
	//String line_No=""; 
	//String customerProductNumber ="";
	//String customerProduct_ID ="";
	//String i_Item_Identifier_Type="";
	//String packing_List_Number="";
      
 
   
//cs3.registerOutParameter(30, Types.VARCHAR); //  訂單處理訊息 
//cs3.registerOutParameter(31, Types.INTEGER); //  訂單HEADER ID 
//cs3.registerOutParameter(32, Types.VARCHAR); //  訂單號碼 
//cs3.registerOutParameter(33, Types.VARCHAR); //  未成功錯誤訊息 
//out.println("customerPO="+customerPO);
//out.println("status="+status);
	try{   
		Statement st_break=con.createStatement();
		ResultSet rs_break=null;
		String	sql_break = "select ORDER_NUMBER , status from tsc_oe_auto_headers where  ID='"+keyID+"' and " +
					  " status = '"+"CLOSED"+"' and  customerID ='"+customerID +"'";
		//out.println("<br>sql_break"+sql_break);
		rs_break=st_break.executeQuery(sql_break);
		if (rs_break.next()==true){
		//此地if的內容為如果 在tsc_oe_auto_headers 內有此 ID的資料那就顯示其訂單資訊, 否則執行ELSE
		//的內容產生資料
			out.println("<table width='400' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>這筆資料已經生成訂單了</font></div></td></tr>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>單號為"+rs_break.getString("ORDER_NUMBER")+"</font></div></td></tr>");
			out.println("<tr><td><div><font  face='Arial' size= '2' color='#red'><hr></font></div></td></tr>");
			out.println("</table><br>");

		}else{
			try{   
		//這個try是用來跑Call API產生訂單資訊的資料
				out.println("<table width='400' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
				Statement st1=con.createStatement();
				ResultSet rs1=null;
				String	sql = "select a.*,b.*,UPPER(TSC_OM_CATEGORY(b.INVENTORY_ITEM_ID,49,'TSC_PROD_GROUP')) DEMAND_CLASS from tsc_oe_auto_headers a , tsc_oe_auto_lines b  where  a.ID= b.ID and a.ID='"+keyID+"' order by OR_LINENO asc  ";
				//out.println(sql);
				rs1=st1.executeQuery(sql);
				//out.println(sql);
				int k =0;
				//out.println(sql);
					while (rs1.next()){
    

					
						if(k==0){
							String firmOrderType=rs1.getString("ORDER_TYPE_ID");	
							String firmSoldToOrg=rs1.getString("CUSTOMERNUMBER");
							String firmPriceList=rs1.getString("PRICE_LIST");
							String ShipToOrg=rs1.getString("SHIPTOID");	 
							String billTo=rs1.getString("BILLTOID");
							String payTermID=rs1.getString("PAYTERM_ID");
							String line_No=rs1.getString("OR_LINENO");
							String fobPoint=rs1.getString("SHIPMENTTERMS");
							//out.println(firmOrderType+","+firmSoldToOrg+","+firmPriceList+","+ShipToOrg+","+billTo+","+payTermID+","+line_No+","+fobPoint+"<br>");
							 keyID=rs1.getString("ID");
							String custPO=customerPO;
							String customerNumber=rs1.getString("CUSTOMERNUMBER");
							String InventoryItemID=rs1.getString("INVENTORY_ITEM_ID");
							String InventoryItem=rs1.getString("INVENTORY_ITEM");
							String orderQty=rs1.getString("QUANTITY");
							String lineType=rs1.getString("LINE_TYPE");
							String unitSellingPrice=rs1.getString("SELLING_PRICE");  	 
							String shippingInstructions=rs1.getString("SHIPPING_INSTRUCTIONS");  	 
							String packInstructions="Y";
							String customerProductNumber=rs1.getString("CUSTOMERPRODUCTNUMBER");	
							String i_Item_Identifier_Type=rs1.getString("ITEM_IDENTIFIER_TYPE");	
							String customerProduct_ID=rs1.getString("CUSTOMERPRODUCT_ID");	
							String packing_List_Number=rs1.getString("PACKINGLISTNUMBER");
							String demandClass=rs1.getString("DEMAND_CLASS");
							//out.println("Step1="+packing_List_Number);
							
							String oPcAcpDate="";   		 
							//unitSellingPrice=rs2.getString("SELLING_PRICE");  
							String primaryUOM="PCE"; 
							//Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
							 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_CREATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
							 System.out.println("===1211 Header Begin===");
							 System.out.println("==="+keyID+"===");
							 System.out.println("--------------------------");
							 System.out.println("write="+packing_List_Number);
							 System.out.println("write="+custPO);
							 System.out.println("orderedDate="+orderedDate);
							 System.out.println("--------------------------");
							 cs3.setString(1,"41");  //  Org ID 	
							 cs3.setInt(2,Integer.parseInt(user_ID)); // User ID 2743	 2116
							 cs3.setInt(3,Integer.parseInt(respID));  //  使用的Responsibility ID --> TSC_OM_Semi_SU	
							 cs3.setInt(4,Integer.parseInt(firmOrderType));  //  Order Type ID 	
							 cs3.setInt(5,Integer.parseInt(firmSoldToOrg));  //  SoldToOrg = 客戶代號	
							 cs3.setInt(6,Integer.parseInt(firmPriceList));  //  PriceList 	
							 cs3.setInt(7,Integer.parseInt(ShipToOrg));  //  Ship To Org 
							 cs3.setDate(8,orderedDate);  //  Ordered Date 
							 cs3.setInt(9,Integer.parseInt(billTo));  //  Bill To Org(Invoice To Org)  
							 cs3.setInt(10,Integer.parseInt(payTermID));  //  Payment Term ID  
							 //out.println("billTo="+billTo+"ShipToOrg="+ShipToOrg+"payTermID="+payTermID+"<br>") ;
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
							 //out.println("custPO="+custPO+"InventoryItemID="+InventoryItemID+"customerProductNumber="+customerProductNumber+"<br>");
							 cs3.setDate(21,pricedate);  //  Pricing Date 	
							 cs3.setDate(22,promisedate);  //  Promise Date 
							 cs3.setString(23,"INTERNAL");  //  Source Type Code  	
							 cs3.setFloat(24,Float.parseFloat(unitSellingPrice));  //  Unit Selling Price 
				 
							 cs3.setString(25,shippingInstructions);  //  Shipping Instructions發票號  
							 //out.println("shippingInstructions="+shippingInstructions);
							 cs3.setString(26,packInstructions);  //  Packing Instructions生管判定產地 
							 cs3.setString(27,"");  //  Attributes8 生管交期排定日  
							 cs3.setFloat(28,Float.parseFloat(unitSellingPrice));  // 
							 //out.println("Float.parseFloat(unitSellingPrice)="+Float.parseFloat(unitSellingPrice));
							 cs3.setString(29,"PCE");  //  更改的訂購單位
							 /*new*/
							 cs3.setInt(30,Integer.parseInt(customerProduct_ID));  // 客戶品號id 
							 cs3.setString(31,i_Item_Identifier_Type);  //   
							 //out.println("shippingInstructions="+shippingInstructions+"customerProduct_ID="+customerProduct_ID+"i_Item_Identifier_Type="+i_Item_Identifier_Type+"<br>"); 
							 /*new*/
							 cs3.setString(32,"N");  //  line_calculate_price_flag
							 cs3.setString(33,packing_List_Number);  //   
							 cs3.setString(34,"");  //    1j4 
							 cs3.setInt(35,163);  //  line_ship_from_org_id
							 cs3.setString(36,"10");  //    1j4 
							 cs3.setString(37,"Packing List Info");  //  packing文字
							 //out.println("packing_List_Number="+packing_List_Number);
							 cs3.setString(38,null);
							 cs3.setString(39,null);
							 cs3.setString(40,null);
							 cs3.setInt(41,0);
							 cs3.setInt(42,0);
							 cs3.setString(43,"N/A");
							 cs3.setString(44,"N/A");
                             cs3.setString(45,demandClass);
							 /*new*/
							 cs3.registerOutParameter(46, Types.VARCHAR); //  訂單處理訊息 
							 cs3.registerOutParameter(47, Types.INTEGER); //  訂單HEADER ID 
							 cs3.registerOutParameter(48, Types.VARCHAR); //  訂單號碼 
							 cs3.registerOutParameter(49, Types.VARCHAR); //  未成功錯誤訊息 
							 cs3.execute();
							 // out.println("Procedure : Execute Success !!! ");
							 processStatus = cs3.getString(46);
							 //out.println("processStatus ="+processStatus+"<br>");
							 headerID = cs3.getInt(47);   // 把第二次的更新 Header ID 取到<br>
							 //out.println("headerID ="+headerID+"<br>");
							 //double orderNo = cs3.getDouble(12);
							 orderNo = cs3.getString(48);
							 //out.println("orderNo ="+orderNo+"<br>");
							 errorMessageHeader = cs3.getString(49);
							  out.println("errorMessageHeader ="+errorMessageHeader+"<br>");
							 System.out.println("===1211 Header END===");
							// System.out.println("==="+keyID+"===");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>第"+(k+1)+"筆資料,訂單名稱="+orderNo+"</font></div></td></tr>");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>客戶Item資料="+customerProductNumber+"</font></div></td></tr>");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>客戶Number="+customerNumberPre+"</font></div></td></tr>");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>errorMessageHeader="+errorMessageHeader+"</font></div></td></tr>");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>processStatus="+processStatus+"</font></div></td></tr>");
							 out.println("<tr><td><div><font  face='Arial' size= '2' color='#red'><hr></font></div></td></tr>");
							 
							 
							 //out.println("k1="+k);				
							 cs3.close();
							 //out.println("k="+k);				
							  
						}else{    
							String firmOrderType=rs1.getString("ORDER_TYPE_ID");	
							String firmSoldToOrg=rs1.getString("CUSTOMERNUMBER");
							String firmPriceList=rs1.getString("PRICE_LIST");
							String ShipToOrg=rs1.getString("SHIPTOID");	 
							String billTo=rs1.getString("BILLTOID");
							String payTermID=rs1.getString("PAYTERM_ID");
							String line_No=rs1.getString("OR_LINENO");
							String fobPoint=rs1.getString("SHIPMENTTERMS");
							//out.println(firmOrderType+","+firmSoldToOrg+","+firmPriceList+","+ShipToOrg+","+billTo+","+payTermID+","+line_No+","+fobPoint+"<br>");
							  keyID=rs1.getString("ID");
							String custPO=customerPO;
							String customerNumber=rs1.getString("CUSTOMERNUMBER");
							String InventoryItemID=rs1.getString("INVENTORY_ITEM_ID");
							String InventoryItem=rs1.getString("INVENTORY_ITEM");
							String orderQty=rs1.getString("QUANTITY");
							String lineType=rs1.getString("LINE_TYPE");
							String unitSellingPrice=rs1.getString("SELLING_PRICE");  	 
							String shippingInstructions=rs1.getString("SHIPPING_INSTRUCTIONS");  	 
							String packInstructions="Y";
							String customerProductNumber=rs1.getString("CUSTOMERPRODUCTNUMBER");	
							String i_Item_Identifier_Type=rs1.getString("ITEM_IDENTIFIER_TYPE");	
							String customerProduct_ID=rs1.getString("CUSTOMERPRODUCT_ID");	
							String packing_List_Number=rs1.getString("PACKINGLISTNUMBER");
							String demandClass=rs1.getString("DEMAND_CLASS");
							//out.println(packing_List_Number);
							
							String oPcAcpDate="";   		 
							//unitSellingPrice=rs2.getString("SELLING_PRICE");  
							String primaryUOM="PCE"; 
								//	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No				  
								CallableStatement cs4 = con.prepareCall("{call TSC_OE_ORDER_UPDATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 				 
								System.out.println("===1211 Line Begin===");
								System.out.println("==="+line_No+"===");
								System.out.println("==="+keyID+"===");
								cs4.setString(1,"41");  /*  Org ID */	
								cs4.setInt(2,Integer.parseInt(user_ID));  /* User ID */	
								cs4.setInt(3,Integer.parseInt(respID));  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
								cs4.setInt(4,Integer.parseInt(firmOrderType));  /*  Order Type ID */	
								cs4.setInt(5,Integer.parseInt(firmSoldToOrg));  /*  SoldToOrg */	
								cs4.setInt(6,Integer.parseInt(firmPriceList));  /*  PriceList */	
								cs4.setInt(7,Integer.parseInt(ShipToOrg));  /*  Ship To Org */				
								cs4.setDate(8,orderedDate);  /*  Ordered Date */	
								cs4.setInt(9,headerID);  /*  更新的  Header Id */
								out.println("headerID123="+headerID);
								cs4.setInt(10,Integer.parseInt(line_No));  /*  增加的  LineNo */
								//out.println("line_No="+line_No);
								cs4.setInt(11,Integer.parseInt(billTo));  /*  Bill To Org(Invoice To Org) */ 
								cs4.setInt(12,Integer.parseInt(payTermID));  /*  Payment Term ID */ 
								cs4.setString(13,"N/A");  /*  Shipping Method Code */	
								cs4.setString(14,fobPoint);  /*  FOB Point Code  */
								cs4.setString(15,custPO);  /*  Customer PO  */
								cs4.setString(16,"N/A");  /*  Currency Code  */ // 不傳入Currency Code,由Price List自己帶入							  					     
								cs4.setInt(17,Integer.parseInt(InventoryItemID));  /*  InventoryItemID */				
								cs4.setString(18,customerProductNumber);  /*  Ordered Item  可能是客戶料號 */				
								//cs3.setFloat(19,Float.parseFloat(aSalesOrderGenerateCode[i][2]));  /*  Order Quantity */	
								cs4.setFloat(19,Float.parseFloat(orderQty));  /*  Order Quantity */			
								cs4.setInt(20,Integer.parseInt(lineType));  /*  Line Type */				
								cs4.setDate(21,shipdate);  /*  Schedule Shup Date */	
								cs4.setDate(22,requestdate);  /*  Request Date */	
								cs4.setDate(23,pricedate);  /*  Pricing Date */
								cs4.setDate(24,promisedate);  /*  Promise Date */					
								cs4.setString(25,"INTERNAL");  /*  Source Type Code  */				
								//out.println("asdf");
								cs4.setFloat(26,Float.parseFloat(unitSellingPrice));  /*  Unit Selling Price */	
								//out.println("Float.parseFloat(unitSellingPrice)="+Float.parseFloat(unitSellingPrice));
								cs4.setString(27,shippingInstructions);  /*  Shipping Instructions發票號  */
								cs4.setString(28,packInstructions);  /*  Packing Instructions生管判定產地  */	
								cs4.setString(29,oPcAcpDate);  /*  Attributes8 生管交期排定日  */	
								cs4.setFloat(30,Float.parseFloat(orderQty));  /*  Unit Selling Price Per Q'ty */
								cs4.setString(31,primaryUOM);  /*  更改的訂購單位  */			
								/*new*/
								cs4.setInt(32,Integer.parseInt(customerProduct_ID));  /*  line_ordered_item_id 要確認一下  ??很奇怪  這不知要塞甚麼 有數字ㄟ */			
								cs4.setString(33,i_Item_Identifier_Type);  /*  line_item_identifier_type 要改 CUST Customer INT */			
								/*new*/
								cs4.setString(34,"N");  /*  line_calculate_price_flag 要問"Y" OR "N" 影響 */
								cs4.setString(35,packing_List_Number);  /*  attribute1  要嘛就董事長 or slavo or sbrina */
								//out.println("i_Item_Identifier_Type="+i_Item_Identifier_Type);
								cs4.setString(36,"");  /*  我看1211 的單子好像這欄位都是空值 attribute10 */
								cs4.setInt(37,163);  /*  line_ship_from_org_id  44 可能是帶代表I8倉  */
								cs4.setString(38,"10");  /*  line_ship_from_org_id  44 可能是帶代表I8倉  */
								cs4.setString(39,"Packing List Info");  /*  line_ship_from_org_id  44 可能是帶代表I8倉  */
								//new 4/19
								cs4.setString(40,null);
								cs4.setString(41,null);
								cs4.setString(42,null);
								cs4.setInt(43,0);
								cs4.setInt(44,0);
								cs4.setString(45,"N/A");
								cs4.setString(46,"N/A");
                                cs4.setString(47,demandClass);
								cs4.registerOutParameter(48, Types.VARCHAR); /*  訂單處理訊息 */	
								cs4.registerOutParameter(49, Types.INTEGER); /*  訂單HEADER ID */	
								//cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
								cs4.registerOutParameter(50, Types.VARCHAR); /*  訂單號碼 */	
								cs4.registerOutParameter(51, Types.VARCHAR); /*  未成功錯誤訊息 */
								//out.println("<br>begin<br>");
								cs4.execute();
								//out.println("<br>end<br>");
								// out.println("Procedure : Execute Success !!! ");
								String processStatusLine = cs4.getString(48);
								headerID = cs4.getInt(49);
								//out.println("headerID="+headerID);
								//double orderNo = cs3.getDouble(12);
								orderNo = cs4.getString(50);
								//out.println("orderNo="+orderNo);
								String errorMessageLine = cs4.getString(51);
								System.out.println("===1211 Line END===");
								out.println("errorMessageHeader22 ="+errorMessageHeader+"<br>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>第"+(k+1)+"筆資料,訂單名稱="+orderNo+"</font></div></td></tr>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>客戶Item資料="+customerProductNumber+"</font></div></td></tr>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>客戶Number="+customerNumberPre+"</font></div></td></tr>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>errorMessageHeader="+errorMessageHeader+"</font></div></td></tr>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#000000'>processStatus="+processStatus+"</font></div></td></tr>");
								out.println("<tr><td><div><font  face='Arial' size= '2' color='#red'><hr></font></div></td></tr>");
								
								cs4.close();
						}k++;
								out.println("</table><br>");
								out.println("<p>&nbsp;</p>");

					}
					rs1.close();   
				 	st1.close(); 
						if(orderNo == null){
								
						}else{
							try{
								String sql1 = "update  TSC_OE_AUTO_HEADERS  set ORDER_NUMBER=? ,STATUS=?  where ID='"+keyID+"'";
								PreparedStatement pstmt=con.prepareStatement(sql1);            
								pstmt.setString(1,orderNo);  // Line Type
								pstmt.setString(2,"CLOSED");  // Line Type
								pstmt.executeUpdate(); 
								pstmt.close();
								//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?customerPO="+customerPO);
								//response.sendRedirect("Tsc1211ConfirmList.jsp");
							}catch(SQLException e){out.println(e.toString());}
						} 

				 //out.println("k="+k);
			}catch (Exception e) { out.println("Exception34:"+e.getMessage()); } 
			


								
		}

		//out.println("gogogoqw");
		//while(rs1.next()){
	 	//}
		 rs_break.close();   
		 st_break.close(); 
	}catch (Exception e) { out.println("Exception1:"+e.getMessage()); } 

	
	
 
 
	  customerPO=null;
	  status =null;
      customerID =null;
	  keyID = null;
	  customerNumberPre =null;//
				   

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>

<!--=================================-->
</html>
