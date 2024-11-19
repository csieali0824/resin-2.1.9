<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,javax.xml.parsers.*"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%

String packingnumber = request.getParameter("packingnumber"); 
String customerpo = request.getParameter("customerpo"); 
//out.println("aa="+packingnumber);
if(packingnumber==null || customerpo==null){
	response.sendRedirect("Tsc1211GenerateXml.jsp");
}else{



String customerName = ""; 
String customerID = ""; 
String shipToID = ""; 
String billToID = ""; 

%>

<html>
<body>
<%
 Connection conn=null;
	try{
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://210.62.146.199:1433;DatabaseName=BufferNetSQL;User=web;Password=6227");
  
			String sql = "select a.packinglistnumber ,a.packinglistdate ,a.shiptoaddressid , "+
						 " a.billtoaddressid ,b.cartonnumber , b.awb , b.invoicenumber , "+
						 " b.productid , b.customerpo ,b.customerproductnumber , b.quantity , "+
						 " b.price , c.name , c.currency, d.description "+
						 "  ,e.department shipdepartment, e.street shipstreet, e.city shipcity, e.county shipcounty, e.zip shipzip, e.country shipcountry "+
						 "  ,f.department billdepartment, f.street billstreet, f.city billcity, f.county billcounty, f.zip billzip, e.country billcountry "+
						 "  ,g.description shipmentterm  , h.shiptoid shiptoid ,h.billtoid billtoid ,h.customernumber customernumber "+
						 " FROM   PackingList a ,PackingListDetails b , customer c , product d ,address e ,address f , shipmentterms g ,"+
						 " customerdata h  "+
						 " where a.PackingListID = b.PackingListID "+
						 " and c.id = a.customerid "+
						 " and a.packinglistnumber ='"+packingnumber+"'" +
						 " and b.customerpo ='"+customerpo+"'" +
						 " and b.ProductId = d.ID " +
						 " and a.shiptoaddressid = e.id " +
						 " and a.billtoaddressid = f.id " +
						 " and g.shipmenttermsid = a.shipmenttermsid " +
						 " and h.id = a.customerid ";
						 
						 
			System.out.println("aa="+sql);
			Statement st = null;
			ResultSet rs = null;
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			//out.println("rs="+rs);
			if(rs==null){
				response.sendRedirect("Tsc1211GenerateXml.jsp");			
			}else{

				int k = 0;
				writeLogToFileBean.setTextString("<?xml version='1.0'  encoding='UTF-8'?>\n");
				System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString("<PurchaseOrderList>\n");
				System.out.println(writeLogToFileBean.getTextString());
				while(rs.next()){
			if(k==0){
				//customerName = rs.getString("name");
				//if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}else if(customerName == "Flextronics"){
				//}
				//customerID = 
 				//shipToID = ""; 
 				//billToID = ""; 
				//char a = (char)rs.getString("shipdepartment") ;
			    //char b = (char)rs.getString("billdepartment") ;
				 //String shipdepartment = rs.getString("shipdepartment");
				 //String billdepartment = rs.getString("billdepartment");
				
				 //out.println("shipdepartment="+a);
				 //out.println("billdepartment="+b);

				writeLogToFileBean.setTextString("<CustomerPO name='"+rs.getString("customerpo")+"'>\n");
				System.out.println(writeLogToFileBean.getTextString());
	  			writeLogToFileBean.setTextString("<PackingListNumber>"+rs.getString("PackingListNumber")+"</PackingListNumber>\n");
				System.out.println(writeLogToFileBean.getTextString());
	  			writeLogToFileBean.setTextString("<Date>"+rs.getString("customerpo")+"</Date>\n");
				System.out.println(writeLogToFileBean.getTextString());
	  			writeLogToFileBean.setTextString("<CustomerName>"+rs.getString("name")+"</CustomerName>\n");
				System.out.println(writeLogToFileBean.getTextString());
	  			writeLogToFileBean.setTextString("<CustomerID>"+rs.getString("customernumber")+"</CustomerID>\n");
				System.out.println(writeLogToFileBean.getTextString());
	  			writeLogToFileBean.setTextString("<ShipmentTerms>"+rs.getString("shipmentterm")+"</ShipmentTerms>\n");
				System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString("<Currency>"+rs.getString("currency")+"</Currency>\n");
				System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString("<Comments></Comments>\n");
				System.out.println(writeLogToFileBean.getTextString());
				//if(customerName=="Philips Lighting")
				writeLogToFileBean.setTextString("<ShipToAddress>\n");
				System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<ShipToID>"+rs.getString("shiptoid")+"</ShipToID>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Department>"+rs.getString("shipdepartment").replaceAll("&","&amp;")+"</Department>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Street>"+rs.getString("shipstreet")+"</Street>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<City>"+rs.getString("shipcity")+"</City>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<County>"+rs.getString("shipcounty")+"</County>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Zip>"+rs.getString("shipzip")+"</Zip>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Country>"+rs.getString("shipcountry")+"</Country>\n");
					System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString("</ShipToAddress>\n");
				System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString(" <BillToAddress>\n");
				System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<BillToID>"+rs.getString("billtoid")+"</BillToID>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Department>"+rs.getString("billdepartment").replaceAll("&","&amp;")+"</Department>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Street>"+rs.getString("billStreet")+"</Street>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<City>"+rs.getString("billCity")+"</City>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<County>"+rs.getString("billCounty")+"</County>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Zip>"+rs.getString("billZip")+"</Zip>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Country>"+rs.getString("billCountry")+"</Country>\n");
					System.out.println(writeLogToFileBean.getTextString());
				writeLogToFileBean.setTextString("</BillToAddress>\n");
				System.out.println(writeLogToFileBean.getTextString());
				
				
				
				
					writeLogToFileBean.setTextString("<Items>\n");
					System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("<Item>\n");
					System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<TSCItemNo></TSCItemNo>\n"); 
					  System.out.println(writeLogToFileBean.getTextString());  
					  writeLogToFileBean.setTextString("<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Awb>"+rs.getString("Awb")+"</Awb>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<SerialNumber></SerialNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<ProductName>"+rs.getString("description")+"</ProductName>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<CustomerProductNumber>"+rs.getString("customerproductnumber")+"</CustomerProductNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Quantity>"+rs.getString("Quantity")+"</Quantity>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Price>"+rs.getString("Price")+"</Price>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("</Item>\n");
					System.out.println(writeLogToFileBean.getTextString());
			   	
			}else  if(k>0){
	  			 
					writeLogToFileBean.setTextString("<Item>\n");
					System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<TSCItemNo></TSCItemNo>\n");   
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Awb>"+rs.getString("Awb")+"</Awb>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<SerialNumber></SerialNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<ProductName>"+rs.getString("description")+"</ProductName>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<CustomerProductNumber>"+rs.getString("customerproductnumber")+"</CustomerProductNumber>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Quantity>"+rs.getString("Quantity")+"</Quantity>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					  writeLogToFileBean.setTextString("<Price>"+rs.getString("Price")+"</Price>\n");
					  System.out.println(writeLogToFileBean.getTextString());
					writeLogToFileBean.setTextString("</Item>\n");
					System.out.println(writeLogToFileBean.getTextString());
			  
			}k++;
				}
			writeLogToFileBean.setTextString("</Items>\n");
			System.out.println(writeLogToFileBean.getTextString());
			writeLogToFileBean.setTextString("</CustomerPO>\n");
			System.out.println(writeLogToFileBean.getTextString());
			writeLogToFileBean.setTextString("</PurchaseOrderList>");
			//System.out.println(writeLogToFileBean.getTextString());
			writeLogToFileBean.setFileName("\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_xml\\"+dateBean.getYearMonthDay()+"_"+packingnumber.replaceAll("/","_")+"_"+customerpo.replaceAll("/","_")+".xml");
  			writeLogToFileBean.StrSaveToFile();
			
			
 
		}//IF
		
	}catch(SQLException e){
		System.out.println(e.toString());
	}finally{
	   if(conn!=null){
	 	   conn.close();
	 	   conn=null;
		     response.sendRedirect("Tsc1211XmlUpload.jsp");
       }
	 }
   
}
%>
</body>
</html>
 