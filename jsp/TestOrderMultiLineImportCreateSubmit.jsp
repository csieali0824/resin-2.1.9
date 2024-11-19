<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Oracle AddsOn System Order Multip-Line Import Create Test Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
   
   String requestDate=request.getParameter("REQUESTDATE");
   

   String organizationId =request.getParameter("ORGPARID");
   String orderType=request.getParameter("ORDERTYPE");
   String soldToOrg=request.getParameter("SOLDTOORG");
   String priceList=request.getParameter("PRICELIST");
   String shipToOrg=request.getParameter("SHIPTOORG");
   String invItem=request.getParameter("INVITEM");
   String orderQty=request.getParameter("ORDERQTY");
   String lineType=request.getParameter("LINETYPE");	
   
   String userName = "OF000886";	// 因系統每日自動啟動,故使用者設定為 KERWIN	 
   userID = "3077";  // 因系統每日自動啟動,故使用者設定為 KERWIN
   String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125

   String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容
   
   if (priceList==null) { priceList = "6038"; }
   if (shipToOrg==null) { shipToOrg = "6004"; }
   
   String YearFr=requestDate.substring(0,4);
   String MonthFr=requestDate.substring(4,6);
   String DayFr=requestDate.substring(6,8);;
   
   java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
   java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Schedule Ship Date
   java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Request Date
   java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
   java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date
   
   
   

try
{  
  String sql="";  
  String errorMessage = "";
   if (a!=null) 
   {  
     out.println("<table>");  
     int headerID = 0;  // 第一次取得的 Header ID
	 int lineNo = 1;  // 累加的 LineNo 	
	 
     String ym[]=array2DimensionInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	  
		   int invItemID = 0;	
		   	   
		             Statement statement=con.createStatement();
                     ResultSet rs=null;	
			                sql = "select INVENTORY_ITEM_ID "+
			                      "from MTL_SYSTEM_ITEMS "+
			                      "where ORGANIZATION_ID = '49' and SEGMENT1 = '"+a[ac][0]+"' ";						  								 			  
                     rs=statement.executeQuery(sql);
		             if	(rs.next())
					 {
					   invItemID = rs.getInt("INVENTORY_ITEM_ID"); 
					 }			    
		             rs.close();   
					 statement.close();  
					 
		  	//out.println("orderType="+orderType);	
			//out.println("soldToOrg="+soldToOrg);	
			//out.println("priceList="+priceList);
			//out.println("shipToOrg="+shipToOrg); 
           
		   if (ac==0) // 第一筆,呼叫新增的 API Procedure 
		   {     //	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
				 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_CREATE_SP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	             cs3.setString(1,organizationId);  /*  Org ID */	
				 cs3.setString(2,userID);  /* User ID */	
				 cs3.setString(3,respID);  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
				 cs3.setInt(4,Integer.parseInt(orderType));  /*  Order Type ID */	
				 cs3.setInt(5,Integer.parseInt(soldToOrg));  /*  SoldToOrg = 客戶代號*/	
				 //cs3.setInt(5,4124);  /*  SoldToOrg for test */	
				 cs3.setInt(6,Integer.parseInt(priceList));  /*  PriceList */	
				 cs3.setInt(7,Integer.parseInt(shipToOrg));  /*  Ship To Org */
				 cs3.setDate(8,orderedDate);  /*  Ordered Date */	
				 cs3.setInt(9,invItemID);  /*  InventoryItemID */	
				 cs3.setString(10,a[ac][0]);  /*  Inventory Item  */	
				 cs3.setInt(11,Integer.parseInt(a[ac][1]));  /*  InvItem ID */	
				 cs3.setInt(12,Integer.parseInt(a[ac][2]));  /*  Ordered Quantity */	
				 cs3.setDate(13,shipdate);  /*  Schedule Shup Date */	
				 cs3.setDate(14,requestdate);  /*  Request Date */	
				 cs3.setDate(15,pricedate);  /*  Pricing Date */	
				 cs3.setDate(16,promisedate);  /*  Promise Date */	
	             cs3.registerOutParameter(17, Types.VARCHAR); /*  訂單處理訊息 */	
				 cs3.registerOutParameter(18, Types.INTEGER); /*  訂單HEADER ID */	
				 //cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
				 cs3.registerOutParameter(19, Types.VARCHAR); /*  訂單號碼 */	
				 cs3.registerOutParameter(20, Types.VARCHAR); /*  未成功錯誤訊息 */
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
				 String processStatus = cs3.getString(17);
	             headerID = cs3.getInt(18);   // 把第二次的更新 Header ID 取到
				 //double orderNo = cs3.getDouble(12);
				 String orderNo = cs3.getString(19);
				        errorMessage = cs3.getString(20);
                 cs3.close();
				 
	             if (errorMessage==null) { errorMessage = ""; }
	             //out.println("Request ID="+requestID);	
					  
					  out.println("<TR bgcolor='#FFFFCC'><TD colspan=2><font color='#000099'>Process Status</FONT></TD><TD colspan=2>"+processStatus+"</TD></TR>");
					  out.println("<TR><TD><font color='#000099'>Header ID</FONT></TD><TD><font color='#000099'>"+headerID+"</FONT></TD><TD><font color='#000099'>Order No</FONT></TD><TD><font color='#000099'>"+orderNo+"</FONT></TD></TR>");
					  out.println("<TR bgcolor='#CCFFCC'><TD><font color='#000099'>Line No.</FONT></TD><TD><font color='#000099'>Inventory Item ID</FONT></TD><TD><font color='#000099'>Inventory Item</FONT></TD><TD><font color='#000099'>Order Q'ty</FONT></TD><TD><font color='#000099'>Line Status</FONT></TD><TD><font color='#000099'>Error Message</FONT></TD></TR>");
					  out.println("<TR><TD><font color='#000099'>"+lineNo+"</FONT></TD><TD><font color='#000099'>"+invItemID+"</FONT></TD><TD><font color='#000099'>"+a[ac][0]+"</FONT></TD><TD><font color='#000099'>"+a[ac][1]+"</FONT></TD><TD><font color='#000099'>"+processStatus+"</FONT></TD><TD><font color='#FF3300'>"+errorMessage+"</FONT></TD></TR>");
					  if (errorMessage==null || errorMessage=="" ) { }
					  else { 
					        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessage+"</TD></TR>");
					       }					  
					  
			}  // End of if (ac=0)
			else if (ac>0) {
			        //	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
				    CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_UPDATE_SP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	                cs3.setString(1,organizationId);  /*  Org ID */	
				    cs3.setString(2,userID);  /* User ID */	
				    cs3.setString(3,respID);  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
				    cs3.setInt(4,Integer.parseInt(orderType));  /*  Order Type ID */	
				    cs3.setInt(5,Integer.parseInt(soldToOrg));  /*  SoldToOrg */	
				    cs3.setInt(6,Integer.parseInt(priceList));  /*  PriceList */	
					cs3.setInt(7,Integer.parseInt(shipToOrg));  /*  Ship To Org */
					cs3.setDate(8,orderedDate);  /*  Ordered Date */	
					cs3.setInt(9,headerID);  /*  更新的  Header Id */
					cs3.setInt(10,lineNo);  /*  增加的  LineNo */
				    cs3.setInt(11,invItemID);  /*  InventoryItemID */	
					cs3.setString(12,a[ac][0]);  /*  Inventory Item  */
				    cs3.setInt(13,Integer.parseInt(a[ac][1]));  /*  InvItem ID */	
				    cs3.setInt(14,Integer.parseInt(a[ac][2]));  /*  Ordered Quantity */
					cs3.setDate(15,shipdate);  /*  Schedule Shup Date */	
					cs3.setDate(16,requestdate);  /*  Request Date */	
					cs3.setDate(17,pricedate);  /*  Pricing Date */
					cs3.setDate(18,promisedate);  /*  Promise Date */	
	                cs3.registerOutParameter(19, Types.VARCHAR); /*  訂單處理訊息 */	
				    cs3.registerOutParameter(20, Types.INTEGER); /*  訂單HEADER ID */	
				    //cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
				    cs3.registerOutParameter(21, Types.VARCHAR); /*  訂單號碼 */	
				    cs3.registerOutParameter(22, Types.VARCHAR); /*  未成功錯誤訊息 */
	                cs3.execute();
                    // out.println("Procedure : Execute Success !!! ");
				    String processStatus = cs3.getString(19);
	                headerID = cs3.getInt(20);
				    //double orderNo = cs3.getDouble(12);
				    String orderNo = cs3.getString(21);
				           errorMessage = cs3.getString(22);
                    cs3.close();
	 
	                if (errorMessage==null) { errorMessage = ""; }   
	                //out.println("Request ID="+requestID);	
					out.println("<TR><TD><font color='#000099'>"+lineNo+"</FONT></TD><TD><font color='#000099'>"+invItemID+"</FONT></TD><TD><font color='#000099'>"+a[ac][0]+"</FONT></TD><TD><font color='#000099'>"+a[ac][1]+"</FONT></TD><TD><font color='#000099'>"+processStatus+"</FONT></TD><TD><font color='#FF3300'>"+errorMessage+"</FONT></TD></TR>");
				 
				    
			     }  // End of Else 
		lineNo++; 		
	} //enf of for	
	out.println("</table>");
  } //end of array if null
  out.println("<BR>");
  
  if (errorMessage==null || errorMessage.equals(""))
  {  out.println("Oracle Order Import Success !!!<BR>"); } 
  
  out.println("<A HREF=/oradds/ORADDSMainMenu.jsp>首頁</A>&nbsp;&nbsp;<A HREF='../jsp/TestOrderMultiLineImportCreate.jsp'> 新增訂單測試 </A> ");
  
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(array2DimensionInputBean.getResultString());		
     array2DimensionInputBean.setArray2DString(null);       		   	 
   }	//enf of a!=null if         
 
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
