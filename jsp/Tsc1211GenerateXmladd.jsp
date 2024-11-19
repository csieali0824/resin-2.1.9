<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,javax.xml.parsers.*,CodeUtil"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="codeUtil" scope="page" class="CodeUtil"/>
<%
String UserName=(String)session.getAttribute("USERNAME"); 
String checkbox[]= request.getParameterValues("checkbox");
String packingNumber = "",customerPO = "",xml ="",fob ="";
%>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
</head>
<body>
<%
Connection conn=null;
boolean bProd = false,isError = false;
String strMark = "";
String getURL = request.getRequestURL().toString();
if (getURL.indexOf("tsrfq.ts.com.tw") > 0 || getURL.indexOf("yewintra.ts.com.tw") > 0 || getURL.indexOf("10.0.1.134") > 0 || getURL.indexOf("10.0.1.135") > 0) 
{
	bProd = true;
}
try
{
	Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
	conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.18:1433;DatabaseName=BufferNetSQL;User=web;Password=6227");
	xml ="<?xml version='1.0'  encoding='UTF-8'?>\n"+"<PurchaseOrderList>\n";
	for(int i=0; checkbox != null && i<checkbox.length ;i++)
	{
		//int a =  checkbox[i].indexOf(",");
		//int b =  checkbox[i].length(); 
		//customerPO = checkbox[i].substring(0,a);   		// 表示字串中","之前的字串也就是 CUSTOMER PO
		//packingNumber = checkbox[i].substring(a+1,b);	// 表示字串中","之後的字串也就是 PACKING NUMBER
		packingNumber = checkbox[i]; //add by Peggy 20120927,用packinglistnumber
		customerPO ="";
		/*
		String sql = " SELECT a.packinglistnumber, a.packinglistdate, a.shiptoaddressid, "+ 
		 	         " a.billtoaddressid, b.cartonnumber, b.awb, b.invoicenumber, "+
					 " b.productid, ltrim(rtrim(b.customerpo)) customerpo, b.customerproductnumber, b.quantity, "+   //add trim() by Peggy 20121106
					 " b.price, h.name, h.currency, d.description, "+
					 " g.id, g.DESCRIPTION shipmentterm2, h.shiptoid shiptoid, h.billtoid billtoid, "+
					 " h.customernumber customernumber "+
					 ",a.customerid source_customerid " + //20110325 add by Peggychen
					 " FROM PackingList a, PackingListDetails b, Customers c, products d, "+
					 " shipmentterms g ,customerdata h "+
					 " where a.CustomerID = c.ID "+
					 " and a.ID = b.packinglistid "+
					 " and b.productid = d.id "+
					 " and h.id = c.id "+
					 " and a.shipmenttermsid = g.id "+ 
					 " and a.packinglistnumber = '"+packingNumber+"'" +
					 //" and b.customerpo = '"+customerPO+"'" +
					 " ORDER BY a.ID DESC,b.customerpo";
		*/
		//因應New BufferNet上線,來源table跟著異動,modify by Peggy 20130327
		String sql = " SELECT a.packinglistnumber, a.packinglistdate, a.shiptoaddressid, "+ 
		 	         " a.billtoaddressid, a.cartonnumber, a.awb, a.invoicenumber, "+
					 " ltrim(rtrim(a.customerpo)) customerpo, a.customerproductnumber, a.quantity, "+ 
					 " a.price, h.name, h.currency, a.tsc_prod_description description, "+
					 " a.shipmentterm shipmentterm2, h.shiptoid shiptoid, h.billtoid billtoid, "+
					 " h.customernumber customernumber "+
					 ",a.customerid source_customerid " + //20110325 add by Peggychen
					 " FROM PackingListdata a, customerdata h "+
					 " where h.id = a.customerid "+
					 " and a.packinglistnumber = '"+packingNumber+"'" +
					 //" and b.customerpo = '"+customerPO+"'" +
					 " ORDER BY a.packinglistdate DESC,a.customerpo";
					 
		Statement st = null;
		ResultSet rs = null;
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		if (rs==null)
		{
			conn.close();
			conn=null;
			response.sendRedirect("Tsc1211GenerateXml.jsp");			
		}
		else
		{
			int k = 0;
			while (rs.next()) 
			{
				if (bProd) 
				{
					String sqlP = "insert into PackingListProcessed(packinglistnumber, customerpo, username)"+
								  " values('"+packingNumber+"','"+rs.getString("customerpo")+"','"+UserName+"') ";
					PreparedStatement pstmt=conn.prepareStatement(sqlP);
					pstmt.executeUpdate();
					pstmt.close();
				}
			
				//New BufferNet上線,歐洲無法再提供所有資料表資料,這幾個欄位在後面動作都用不到,在未來無法提供資料前提下,
				//一旦READ不到資料,會導致匯出XML動作失敗,所以MARK掉,modify by Peggy 20130327
				/*
				String sqlShip = " SELECT a.department, a.street, a.city, a.county, a.zip, c.countryname"+
				   			     " FROM address a, country c "+
								 " WHERE a.countryid = c.id "+
								 " AND a.id = "+rs.getString("shiptoaddressid"); 
		        Statement stateShip=conn.createStatement();
                ResultSet rsShip=stateShip.executeQuery(sqlShip);
	            rsShip.next();

				String sqlBill = " SELECT a.department, a.street, a.city, a.county, a.zip, c.countryname"+
				  			     " FROM address a, country c "+
							     " WHERE a.countryid = c.id "+
								 " AND a.id = "+rs.getString("billtoaddressid");
                Statement stateBill=conn.createStatement();
                ResultSet rsBill=stateBill.executeQuery(sqlBill);
	            rsBill.next();
				*/
				
				//add by Peggy 20120927
				if (!customerPO.equals(rs.getString("customerpo")))
				{	
					if (!customerPO.equals("")) xml += "</Items>\n</CustomerPO>\n";
					customerPO = rs.getString("customerpo");
					k=0;
				}
				
				if (k==0) 
				{	
					//因New BufferNet上線,此判斷code已不適用,modify by Peggy 20130328		
					//if(rs.getString("id")=="3"||rs.getString("id").equals("3"))
					//{
					//	fob =  "FCA MUNICH";
					//}
					//else
					//{
					//  fob =  rs.getString("shipmentterm2");
					//}
					if (rs.getString("shipmentterm2").trim().startsWith("DAP"))
					{
						fob ="DAP";
					}
					else if (rs.getString("shipmentterm2").trim().startsWith("DDP"))
					{
						fob ="DDP";
					}
					else if (rs.getString("shipmentterm2").trim().startsWith("DDU"))
					{
						fob ="DDU";
					}
					else if (rs.getString("shipmentterm2").trim().startsWith("FCA"))
					{
						fob =  "FCA MUNICH";
					}
					else
					{
						fob ="DAP";
					}	
					
					xml +="<CustomerPO name='"+rs.getString("customerpo")+"'>\n" +
						  "<PackingListNumber>"+rs.getString("PackingListNumber")+"</PackingListNumber>\n" +
						  "<Date>"+"0"+"</Date>\n"+
						  "<CustomerName>"+rs.getString("name").replaceAll("&","&amp;")+"</CustomerName>\n"+
						  "<CustomerID>"+rs.getString("customernumber")+"</CustomerID>\n"+
						  "<ShipmentTerms>"+fob+"</ShipmentTerms>\n"+
						  "<Currency>"+rs.getString("currency")+"</Currency>\n"+
						  "<Comments></Comments>\n";
					xml+="<modelName>"+rs.getString("customerproductnumber").trim()+"</modelName>\n";
					xml+="<sourceCustID>"+rs.getString("source_customerid").trim()+"</sourceCustID>\n";
					xml+="<sourceShipToID>"+rs.getString("shiptoaddressid").trim()+"</sourceShipToID>\n";
					xml+="<sourceBillToID>"+rs.getString("billtoaddressid").trim()+"</sourceBillToID>\n";
					strMark = "shiptoaddressid="+rs.getString("shiptoaddressid"); //20110315 add by Peggychen
					xml+="<ShipToAddress>\n"+
						 "<ShipToID>"+rs.getString("shiptoid")+"</ShipToID>\n"+
						 //"<Department>"+codeUtil.convertFullorHalf(rsShip.getString("department").replaceAll("&","&amp;"),0)+"</Department>\n"+
						 //"<Street>"+codeUtil.convertFullorHalf(rsShip.getString("street"),0)+"</Street>\n"+
						 //"<City>"+codeUtil.convertFullorHalf(rsShip.getString("city"),0)+"</City>\n"+
						 //"<County>"+codeUtil.convertFullorHalf(rsShip.getString("county"),0)+"</County>\n"+
						 //"<Zip>"+codeUtil.convertFullorHalf(rsShip.getString("zip"),0)+"</Zip>\n"+
						 //"<Country>"+codeUtil.convertFullorHalf(rsShip.getString("countryname"),0)+"</Country>\n"+
						 "</ShipToAddress>\n";
					strMark = "billtoaddressid="+rs.getString("billtoaddressid");  //20110315 add by Peggychen
					xml+="<BillToAddress>\n"+
					     "<BillToID>"+rs.getString("billtoid")+"</BillToID>\n"+
						 //"<Department>"+codeUtil.convertFullorHalf(rsBill.getString("department").replaceAll("&","&amp;"),0)+"</Department>\n"+
						 //"<Street>"+codeUtil.convertFullorHalf(rsBill.getString("street"),0)+"</Street>\n"+ 
						 //"<City>"+codeUtil.convertFullorHalf(rsBill.getString("city"),0)+"</City>\n"+
						 //"<County>"+codeUtil.convertFullorHalf(rsBill.getString("county"),0)+"</County>\n"+
						 //"<Zip>"+codeUtil.convertFullorHalf(rsBill.getString("zip"),0)+"</Zip>\n"+
						 //"<Country>"+codeUtil.convertFullorHalf(rsBill.getString("countryname"),0)+"</Country>\n"+
						 "</BillToAddress>\n";
					xml+="<Items>\n"+
					 	 "<Item>\n"+
						 "<TSCItemNo></TSCItemNo>\n"+
						 "<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>\n"+
						 "<Awb>"+rs.getString("Awb")+"</Awb>\n"+
						 "<SerialNumber></SerialNumber>\n"+
						 "<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>\n"+
						 "<ProductName>"+rs.getString("description")+"</ProductName>\n"+
						 "<CustomerProductNumber>"+rs.getString("customerproductnumber").trim()+"</CustomerProductNumber>\n"+
						 "<Quantity>"+rs.getString("Quantity")+"</Quantity>\n"+
						 "<Price>"+rs.getString("Price")+"</Price>\n"+
						"</Item>\n";
				}
				else if(k>0)
				{
					xml += "<Item>\n"+
						   "<TSCItemNo></TSCItemNo>\n"+   
						   "<CartonNumber>"+rs.getString("cartonnumber")+"</CartonNumber>\n"+
						   "<Awb>"+rs.getString("Awb")+"</Awb>\n"+
						   "<SerialNumber></SerialNumber>\n"+
			   			   "<InvoiceNumber>"+rs.getString("InvoiceNumber")+"</InvoiceNumber>\n"+
						   "<ProductName>"+rs.getString("description")+"</ProductName>\n"+
						   "<CustomerProductNumber>"+rs.getString("customerproductnumber").trim()+"</CustomerProductNumber>\n"+
						   "<Quantity>"+rs.getString("Quantity")+"</Quantity>\n"+
						   "<Price>"+rs.getString("Price")+"</Price>\n"+
						   "</Item>\n";
				}
				k++;
               	//rsBill.close();
				//stateBill.close();
	            //rsShip.close();
				//stateShip.close();
			}	
			xml += "</Items>\n"+
			   "</CustomerPO>\n";
		}
	} 
	xml += "</PurchaseOrderList>";
	writeLogToFileBean.setTextString(xml);
	writeLogToFileBean.setFileName("\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_xml\\"+dateBean.getYearMonthDay()+".xml");
	writeLogToFileBean.StrSaveToFile();
}
catch(SQLException e)
{
	isError=true;
	out.println("<font color='red'>資料轉XML發生異常,請洽系統管理員,謝謝!("+strMark+")<br>"+ e.toString()+"");
}
finally
{
	if(conn!=null)
	{
		conn.close();
		conn=null;
		if (!isError)
		{
			response.sendRedirect("XMLParserToOracle2.jsp?xmlname="+dateBean.getYearMonthDay()+".xml"); //20110309 add by Peggychen
		}
	}
}
%>
</body>
</html>