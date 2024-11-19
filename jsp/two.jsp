<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<%

String packingnumber = request.getParameter("packingnumber"); 
out.println("aa="+packingnumber);
String customerName = ""; 

%>

<html>
<body>
<%
 Connection conn=null;
	try{
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://gray:1433;DatabaseName=bufferstock;User=sa;Password=gt2000");
  
			String sql = "select a.packinglistnumber ,a.packinglistdate ,a.shiptoaddressid , "+
						 " a.billtoaddressid ,b.cartonnumber , b.awb , b.invoicenumber , "+
						 " b.productid , b.customerpo ,b.customerproductnumber , b.quantity , "+
						 " b.price , c.name , c.currency , d.description "+
						 " FROM   PackingList a ,PackingListDetails b , customer c , product d   "+
						 " where a.PackingListID = b.PackingListID "+
						 " and c.id = a.customerid "+
						 " and a.packinglistnumber ='T-050720H' " +
						 " and b.ProductId = d.ID ";
						 
			out.println("aa="+sql);
			Statement st = null;
			ResultSet rs = null;
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			//if(conn == null ){
			// 	out.println(sql);
			//}else{
			//	out.println("sql");
			//}
				int k = 0;
				writeLogToFileBean.setTextString("<?xml version='1.0'  encoding='UTF-8'?>");
				writeLogToFileBean.setTextString("<PurchaseOrderList>");
				while(rs.next()){
			if(k==0){

				writeLogToFileBean.setTextString("<CustomerPO name='"+rs.getString("customerpo")+"'>");
	  			writeLogToFileBean.setTextString("<PackingListNumber>"+rs.getString("PackingListNumber")+"</PackingListNumber>");
	  			writeLogToFileBean.setTextString("<Date>"+rs.getString("customerpo")+"</Date>");
	  			writeLogToFileBean.setTextString("<CustomerName>"+rs.getString("name")+"</CustomerName>");
	  			writeLogToFileBean.setTextString("<CustomerID>"+rs.getString("customerpo")+"</CustomerID>");
	  			writeLogToFileBean.setTextString("<ShipmentTerms>"+rs.getString("customerpo")+"</ShipmentTerms>");
				writeLogToFileBean.setTextString("<Currency>"+rs.getString("currency")+"</Currency>");
				writeLogToFileBean.setTextString("<Comments>"+rs.getString("customerpo")+"</Comments>");
				//if(customerName=="Philips Lighting")
				writeLogToFileBean.setTextString("<ShipToAddress>");
					writeLogToFileBean.setTextString("<ShipToID>6094</ShipToID>");
					writeLogToFileBean.setTextString("<Department></Department>");
					writeLogToFileBean.setTextString("<Street> </Street>");
					writeLogToFileBean.setTextString("<City> </City>");
					writeLogToFileBean.setTextString("<County> </County>");
					writeLogToFileBean.setTextString("<Zip> </Zip>");
					writeLogToFileBean.setTextString("<Country> </Country>");
				writeLogToFileBean.setTextString("</ShipToAddress>");
				writeLogToFileBean.setTextString(" <BillToAddress>");
					writeLogToFileBean.setTextString("<BillToID>3740</BillToID>");
					writeLogToFileBean.setTextString("<Department> </Department>");
					writeLogToFileBean.setTextString("<Street> </Street>");
					writeLogToFileBean.setTextString("<City> </City>");
					writeLogToFileBean.setTextString("<County> </County>");
					writeLogToFileBean.setTextString("<Zip> </Zip>");
					writeLogToFileBean.setTextString("<Country> </Country>");
				writeLogToFileBean.setTextString("</BillToAddress>");
				
				
				
				
					writeLogToFileBean.setTextString("<Items>");
					writeLogToFileBean.setTextString("<Item>");
					  writeLogToFileBean.setTextString("<TSCItemNo></TSCItemNo>");   
					  writeLogToFileBean.setTextString("<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>");
					  writeLogToFileBean.setTextString("<Awb>"+rs.getString("Awb")+"</Awb>");
					  writeLogToFileBean.setTextString("<SerialNumber></SerialNumber>");
					  writeLogToFileBean.setTextString("<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>");
					  writeLogToFileBean.setTextString("<ProductName>"+rs.getString("description")+"</ProductName>");
					  writeLogToFileBean.setTextString("<CustomerProductNumber>"+rs.getString("customerproductnumber")+"</CustomerProductNumber>");
					  writeLogToFileBean.setTextString("<Quantity>"+rs.getString("Quantity")+"</Quantity>");
					  writeLogToFileBean.setTextString("<Price>"+rs.getString("Price")+"</Price>");
					writeLogToFileBean.setTextString("</Item>");
			   	
			}else  if(k>0){
	  			 
					writeLogToFileBean.setTextString("<Item>");
					  writeLogToFileBean.setTextString("<TSCItemNo></TSCItemNo>");   
					  writeLogToFileBean.setTextString("<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>");
					  writeLogToFileBean.setTextString("<Awb>"+rs.getString("Awb")+"</Awb>");
					  writeLogToFileBean.setTextString("<SerialNumber></SerialNumber>");
					  writeLogToFileBean.setTextString("<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>");
					  writeLogToFileBean.setTextString("<ProductName>"+rs.getString("description")+"</ProductName>");
					  writeLogToFileBean.setTextString("<CustomerProductNumber>"+rs.getString("customerproductnumber")+"</CustomerProductNumber>");
					  writeLogToFileBean.setTextString("<Quantity>"+rs.getString("Quantity")+"</Quantity>");
					  writeLogToFileBean.setTextString("<Price>"+rs.getString("Price")+"</Price>");
					writeLogToFileBean.setTextString("</Item>");
			  
			}k++;
				}
			writeLogToFileBean.setTextString("</Items>");
			writeLogToFileBean.setTextString("</CustomerPO>");
			writeLogToFileBean.setTextString("</PurchaseOrderList>");
			writeLogToFileBean.setFileName("c:/resin-2.1.9/webapps/oradds/xml_file/TSCXml"+dateBean.getYearMonthDay()+"_"+packingnumber+".xml");
  			writeLogToFileBean.StrSaveToFile();
 

	}catch(SQLException e){
		out.println(e.toString());
	}finally{
	  // if(conn!=null){
	 	   conn.close();
	 	   conn=null;
     //  }
	 }
   

%>
</body>
</html>