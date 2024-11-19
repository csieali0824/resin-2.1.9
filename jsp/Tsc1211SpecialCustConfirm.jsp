<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC Order Detail Confirm</title>
<script language="JavaScript" type="text/JavaScript">
function subWindowProductFind(primaryFlag,ID,line_no,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscProductFind.jsp?PRIMARYFLAG="+
	primaryFlag+"&ID="+ID+"&line_no="+line_no+"&CUSTOMERNUMBER="+customerNumber+"&sourcepg=D1010","subwin");  
} 
function setCreate(URL)
{  
    document.MYFORM.complete.disabled=true;
	flag=confirm("您確定要轉入ERP產生訂單嗎?");
	if (flag==false)
	{  
		document.MYFORM.complete.disabled=false;
		return(false);
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function subWindowPriceListFind(ID,Currency_code)
{    
	subWin=window.open("../jsp/subwindow/TscPriceListFind.jsp?ID="+ID+"&Currency_code="+Currency_code+"&sourcepg=D1010","subwin");  
} 
function subWindowBillToFind(ID,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscUseInfoFind.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&ADDRESSID="+"BILL_TO"+"&u_Update_Field="+"BILLTOID&sourcepg=D1010","subwin");  
}
function subWindowLineTypeFind(ID,line_no,status)
{    
	subWin=window.open("../jsp/subwindow/TscLineTypeFind.jsp?ID="+ID+"&line_no="+line_no+"&status="+status,"subwin");  
}
</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:Arial; font-size:12px; color: #000000; text-align:left}
 .style3   {font-family:Arial; font-size:12px; color: #000000; text-align:right}
 .style4   {font-family:Arial; font-size:12px; color: #000000; text-align:center}
 .style2   {font-family:Arial; font-size:12px; background-color:#BBD3E1; width:150;}
 .style5   {font-family:Arial; font-size:12px; background-color:#FF99CC; font-weight:bold;}
 .style13  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:left;}
 .style14  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:center;}
 .style15  {font-family:標楷體; font-size:16px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 .style16  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 </STYLE>
</head>
<body>
<%
String keyID =request.getParameter("KeyID");
//從TscPriceListFind.jsp回傳的參數值
String p_ID = request.getParameter("ID");
if (keyID == null && p_ID != null)
{
	keyID = p_ID;
}
String p_List_Header_ID = request.getParameter("p_List_Header_ID");
String p_Currency_Code = request.getParameter("p_Currency_Code");
String sql ="";
if (p_List_Header_ID != null)
{
	try
	{
		sql = " update  TSC_OE_AUTO_HEADERS "+
		             " set PRICE_LIST=?"+
					 " where ID='"+p_ID +"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);   
		pstmt.setString(1,p_List_Header_ID);
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("Update header Exception:"+e.toString());
	}
}
String FOB = request.getParameter("FOB");
if (FOB != null)
{
	try
	{
		sql = " update  TSC_OE_AUTO_HEADERS "+
		             " set SHIPMENTTERMS=?"+
					 " where ID='"+keyID +"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);   
		pstmt.setString(1,FOB);
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("Update header FOB Exception:"+e.toString());
	}	
}
//從TscUseInfoFind.jsp回傳的參數值
String u_Site_Use_ID = request.getParameter("u_Site_Use_ID");
if (u_Site_Use_ID != null)
{
try
	{
		sql = " update  TSC_OE_AUTO_HEADERS "+
		             " set BILLTOID=?"+
					 " where ID='"+p_ID +"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);   
		pstmt.setString(1,u_Site_Use_ID);
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("Update header Exception:"+e.toString());
	}
}
//從TscProductFind.jsp回傳的參數值
String p_line_no =request.getParameter("p_line_no");
String p_inventory_Item =request.getParameter("inventory_Item");
String p_item =request.getParameter("Item");
String p_Item_Description =request.getParameter("p_Item_Description");
String p_Item_Identifier = request.getParameter("p_Item_Identifier");
String p_Item_ID = request.getParameter("p_Item_ID");
String p_inventory_Item_ID = request.getParameter("inventory_Item_ID");
if (p_line_no != null && p_inventory_Item_ID !=null  && p_line_no!=null && p_inventory_Item!=null  && p_Item_Identifier!=null)
{ 
	try
	{
		sql = " update  TSC_OE_AUTO_LINES "+
		             " set INVENTORY_ITEM_ID=?"+
					 ",INVENTORY_ITEM=? "+
					 ",CUSTOMERPRODUCTNUMBER=?"+
					 ",ITEM_DESCRIPTION=?"+
					 ",ITEM_IDENTIFIER_TYPE =?"+
					 ",CUSTOMERPRODUCT_ID=? "+
					 " where ID='"+p_ID +"' "+
					 " and LINE_NO='"+p_line_no+"' ";																		
		PreparedStatement pstmt=con.prepareStatement(sql);   
		pstmt.setInt(1,Integer.parseInt(p_inventory_Item_ID));  
		pstmt.setString(2,p_inventory_Item);
		pstmt.setString(3,p_item);
		pstmt.setString(4,p_Item_Description);
		pstmt.setString(5,p_Item_Identifier);
		pstmt.setInt(6,Integer.parseInt(p_Item_ID));
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("Update lines Exception1:"+e.toString());
	}
} 
//從TscLineTypeFind.jsp回傳的參數值
String v_line_no =request.getParameter("v_line_no");
String p_line_type =request.getParameter("p_Line_Type");
if (v_line_no != null && p_line_type != null)
{
	try
	{
		sql = " update  TSC_OE_AUTO_LINES "+
		             " set LINE_TYPE=?"+
					 " where ID='"+p_ID +"' "+
					 " and LINE_NO='"+v_line_no+"' ";																		
		PreparedStatement pstmt=con.prepareStatement(sql);   
		pstmt.setString(1,p_line_type);
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("Update lines Exception2:"+e.toString());
	}
}

CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();

String Order_Type_Id = "";
String Payment_Terms = "";
String Payment_Terms_Name = "";
String Plant_Code = "";
String Customer_Number = "";
String Customer_Name = "";
String ShipToLocation = "";
String BillToLocation = "";
String ShipToLocationID = "";
String BillToLocationID = "";
String Subinventory_Code = "50";
String Locator_Name = "";
//String FOB = "";
String Currency_Code = "";
String Price_List_Id = "";
String Price_List_Code = "";
String SalesPerson = "";
String Creation_Date = "";
String Created_By = "";
String ERP_Order_Number = "";
String odr_status = "";
String customerID = "";
int errCnt =0;
try
{
	sql="select "+
	        " CUSTOMERID,"+
            " CUSTOMERPO,"+
			" CUSTOMERNAME,"+
			" SHIPMENTTERMS,"+
			" PACKINGLISTNUMBER,"+
			" ORDER_NUMBER,"+
			" PRICE_LIST,"+
			" PAYTERM_ID,"+
		    " C_DATE,"+
			" SALESPERSON,"+
			" CREATED_BY,"+
			" CREATION_DATE , "+
			" SHIPTOID ,"+
			" BILLTOID,"+
			" CURRENCY ,"+
			" CUSTOMERNUMBER, "+
			" ORDER_TYPE_ID,"+
			" STATUS,"+
			" PLANT_CODE "+
		    " from TSC_OE_AUTO_HEADERS"+
			" WHERE ID = '"+keyID+"'" +
			" and SALES_REGION='DELTA'";
	Statement statement=con.createStatement();
	ResultSet rs = statement.executeQuery(sql);
	if (rs.next())
	{
		customerID = rs.getString("CUSTOMERID");
		Order_Type_Id = rs.getString("ORDER_TYPE_ID");
		Payment_Terms = rs.getString("PAYTERM_ID");
		Plant_Code = rs.getString("PLANT_CODE");
		Customer_Number = rs.getString("CUSTOMERNUMBER") ;
		Customer_Name = rs.getString("CUSTOMERNAME") ;
		SalesPerson = rs.getString("SALESPERSON");
		Creation_Date = rs.getString("CREATION_DATE");
		Created_By = rs.getString("CREATED_BY");
	    ShipToLocationID = rs.getString("SHIPTOID");
        BillToLocationID = rs.getString("BILLTOID");	
		FOB = rs.getString("SHIPMENTTERMS");
		Currency_Code = rs.getString("CURRENCY"); 
		Price_List_Id = rs.getString("PRICE_LIST");
		if (Price_List_Id == null) Price_List_Id="&nbsp;";
		ERP_Order_Number = rs.getString("ORDER_NUMBER");
		Locator_Name = rs.getString("PLANT_CODE");
		odr_status = rs.getString("STATUS");
	} 
	rs.close();
	statement.close();		
}
catch(SQLException e)
{
	out.println(e.toString());
}
%>
<form name="MYFORM"  METHOD="post" action="../jsp/Tsc1211SpecialCustConfirm.jsp?KeyID=<%=keyID%>">
<p>
  <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</p>
  <TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong>DELTA 1211 Order Detail Confirm(<font color="#0000FF"><%=keyID%></fond><input type="hidden" name="KeyID" value="<%=keyID%>">)</strong></font></TD>
  <br>
  <p>
<table width="90%"  cellspacing="0" cellpadding="0" bordercolordark="#990000">
 	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#000000" cellpadding="1" width="100%" height="15" align="left">
				<TR>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="回首頁!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#FFFFFF">
									<STRONG>回首頁</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>
					<TD width="15%" class="style15">
						<STRONG>生成訂單確認</STRONG>
					</TD>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入資料上傳功能!">
									<A HREF="Tsc1211SpecialCustUpload.jsp" style="text-decoration:none;color:#FFFFFF">
									<STRONG>資料上傳</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</td>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入資料查詢功能!">
									<A HREF="Tsc1211SpecialCustQuery.jsp" style="text-decoration:none;color:#FFFFFF">
									<STRONG>資料查詢</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</td>
					<TD width="65%" class="style16"><a href="samplefiles/D4-010_User_Guide.doc">Download User Guide</a>&nbsp;</TD>
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
	<tr>
		<td>
			<table cellspacing="0"   cellpadding="0" width="100%" align="left" border="0">
				<TR>
					<TD>
						<table cellspacing="0"  bordercolordark="#ffffff" cellpadding="1" width="100%" align="left" bordercolorlight="#0099FF" border="1">
							<tr>
								<td bgcolor="#BBD3E1" colspan="6"><FONT color="#000000" size="2">訂單資訊：</FONT>
								</td>
							</tr>
							<tr>
								<td class="style2">Customer Name:</td>
								<td class="style1" colspan="5">
								<input type="text" class="Style1"  size="5" name="CustomerNumber" value="<%=Customer_Number%>" readonly>
								<%=Customer_Name%>
								</td>
							</tr>
							<%
							 try
							 {  
								//sql = " select a.STATUS,a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1"+ 
								//			 " from AR_SITE_USES_V a,"+
								//			 " AR_ADDRESSES_V b "+
								//			 " where a.ADDRESS_ID = b.ADDRESS_ID "+
								//			 " and a.STATUS=b.STATUS "+
								//			 " and a.STATUS='A' "+
								//			 " and b.ORG_ID = '41' "+
								//			 " and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID "+
								//			 " from HZ_CUST_ACCT_SITES_ALL  WHERE CUST_ACCOUNT_ID='"+Customer_Number+"') "+
								//			 " and (a.SITE_USE_ID = '"+ShipToLocationID+"' or  a.SITE_USE_ID = '"+BillToLocationID+"' )"; 
								//modify by Peggy 20140123
								sql = " select a.STATUS,a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID,loc.COUNTRY, loc.ADDRESS1"+
								      " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
									  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
								      " AND b.party_site_id = party_site.party_site_id"+
								      " AND loc.location_id = party_site.location_id "+
								      " and a.STATUS='A' "+
								      " and b.CUST_ACCOUNT_ID ='"+Customer_Number+"'"+	
									  " and (a.SITE_USE_ID = '"+ShipToLocationID+"' or  a.SITE_USE_ID = '"+BillToLocationID+"' )"; 							
								//out.println(sql);
								Statement statement=con.createStatement();
								ResultSet rs=statement.executeQuery(sql);	  			  				     
								while (rs.next())
								{            		             
									if (rs.getString("SITE_USE_CODE")=="SHIP_TO" || rs.getString("SITE_USE_CODE").equals("SHIP_TO"))
									{ 
										ShipToLocation  = rs.getString("ADDRESS1"); 
									}
									if (rs.getString("SITE_USE_CODE")=="BILL_TO" || rs.getString("SITE_USE_CODE").equals("BILL_TO"))
									{  
										BillToLocation=rs.getString("ADDRESS1"); 
									}
								} 	
								rs.close();   
								statement.close();  
							 }
							 catch (Exception e) 
							 { 
								out.println("Exception:"+e.getMessage()); 
							 }    
							%>	      		   
							<tr>
								<td class="style2">Ship To Location:</td>
								<td class="style1" colspan="5">
								<INPUT TYPE="text" class="Style1" size="5" name="ShipTo" value="<%=ShipToLocationID%>" readonly>
								<%=ShipToLocation%>
								</td> 	
							</tr>
							<tr>
								<td class="style2">Bill To Location:</td>
								<td class="style1" colspan="5">
								<input type="text" class="Style1" size="5" name="BillTo" value="<%=BillToLocationID%>" readonly>
								<%
								if (odr_status.equals("OPEN"))
								{
									out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowBillToFind("+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(Customer_Number)+'"'+")' title='請按我!'>");
								}
								%>
								<%=BillToLocation%>
								</td> 
							</tr>
							<tr>
								<td class="style2">Order Type:</td>
								<td width="250"><input type="hidden" name="TRANSACTION_TYPE_CODE"   value='<%=Order_Type_Id%>' size="6" readonly>
									<font size="2" face="Arial" color="blue">TSC _S_Consignment Order</font>
								</td>
								<td class="style2">Currency:</td>
								<td width="300"><font size="2" face="Arial" color="blue"><%=Currency_Code%></font></td>
								<td class="style2">FOB:</td>
								<td class="style1" width="150"><input type="text" name="FOB" style="font-family:arial;border-color:#ffffff;font-size:12px" value="<%=FOB%>" size="15" onkeydown="return (event.keyCode==13);"><IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' 
								onClick='window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?FUNC=D4010","subwin")' title='請按我!'></td>
							</tr>
							<tr>
								<td class="style2">Payment Terms:</td>
								<% 
								try
								{
									sql = "select NAME from RA_TERMS_VL  where term_id='"+Payment_Terms+"'";
									Statement statement=con.createStatement();
									ResultSet rs = statement.executeQuery(sql);
									if(rs.next())
									{
										Payment_Terms_Name = rs.getString("name");
									}   
									rs.close();
									statement.close();		
								}
								catch(Exception e) 
								{
									errCnt ++;
									Payment_Terms_Name="Payment Terms Exception:"+e.getMessage(); 
								}    
								%>
								<td class="style1" width="250"><%=Payment_Terms_Name%></td>
								<td class="style2">Price List:</td>
								<%
								try
								{
									sql = "select NAME as LIST_CODE "+
											" from qp_list_headers_v "+
											" where ACTIVE_FLAG = 'Y'"+
											" and TO_CHAR(LIST_HEADER_ID) > '0'"+
											" and LIST_HEADER_ID='"+Price_List_Id+"'"; 
									Statement statement=con.createStatement();
									ResultSet rs = null;
									try
									{   
										rs = statement.executeQuery(sql);
										if(rs.next())
										{
											Price_List_Code = rs.getString("LIST_CODE");
										}
										else
										{
											errCnt ++;
											Price_List_Code = "<font color='red'> Price List Code Not Found</font>";
										}
									}
									catch (Exception e) 
									{ 
										errCnt ++;
										Price_List_Code = " <font color='red'> Error:"+e.getMessage()+"</font>";
									}  
									finally
									{
										rs.close();
										statement.close();
									}
								}catch(Exception e){}
								//out.println("<td class='style1' width='300'>");
								//out.println("<INPUT TYPE='text' class='Style1' size='5' name='pricelistid' value='"+Price_List_Id+"' readonly>");
								%>
								<td class="style1" width="300">
								<INPUT TYPE="text" class="Style1" size="5" name="pricelistid" value=<%=Price_List_Id%> readonly>
								<%
								if (odr_status.equals("OPEN"))
								{
									out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowPriceListFind("+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(Currency_Code)+'"'+")' title='請按我!'>");
								}
								out.println(Price_List_Code);
								%>
								</td>
								<td class="style2">Order Status:</td>
								<%
								if (odr_status.equals("CLOSED"))
								{
									out.println("<td class='style1' width='150'><font color='red'>"+odr_status+"</font></td>");
								}
								else
								{
									out.println("<td class='style1' width='150'><font color='blue'>"+odr_status+"</font></td>");
								}
								%>
							</tr>
							<tr>
								<td class="style2">I6-Subinventory:</td>
								<td class="style1">
								<input type="text" class="Style1" size="5" name="subinventory" value="<%=Subinventory_Code%>" readonly>
								</td> 
								<td class="style2">I6-Locator:</td>
								<td class="style1">
								<% 
								if (Locator_Name==null)
								{
								%>
								<input type="text" class="Style5" size="5" name="locator" value="&nbsp;" readonly>
								<%
								errCnt++;
								}else{
								%>
								<input type="text" class="Style1" size="5" name="locator" value="<%=Locator_Name%>" readonly>
								<%
								}
								%>
								<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' 
								onClick='window.open("../jsp/subwindow/TscPlantCodeInfo.jsp?plant=<%=Locator_Name%>","subwin")' title='請按我!'>
								</td> 
								<%
								if (ERP_Order_Number != null)
								{
									out.println("<td class='style2'>ERP Order Number:</td>");
									out.println("<td class='style1'><font color='blue' size='4'><b>"+ERP_Order_Number+"</b></font></td>");
								}else{
									out.println("<td class='style1' colspan='2'>&nbsp;</td>");
								}
								%>
							</tr>
						</table>
					</td>
				</tR>
				<TR>
					<TD>
						<table  width="100%" border="1" align="left"  cellpadding="1" cellspacing="0" bordercolorlight="#0099FF" bordercolordark="#FFFFFF">
							<tr>
								<td colspan="10"  bgcolor="#D8E6E7" ><font size="2">處理內容明細 :</font></td>
							</tr>
							<tr>
								<td width="1%"  bgcolor="#A9E1E7"><div align="left"><font face="Arial" size="2">Line</font></div></td>
								<td width="18%" bgcolor="#A9E1E7"><div align="left"><font face="Arial" size="2">Customer Po Line Number</font></div></td>
								<td width="15%" bgcolor="#A9E1E7"><div align="left"><font face="Arial" size="2">Ordered Item</font></div></td>
								<td width="15%" bgcolor="#A9E1E7"><div align="left"><font face="Arial" size="2">Item Description</font></div></td>
								<td width="8%"  bgcolor="#A9E1E7"><div align="left"><font face="Arial" size="2">Internal Item</font></div></td>
								<td width="10%" bgcolor="#A9E1E7"><div align="center"><font face="Arial" size="2">Unit Price</font></div></td>
								<td width="4%"  bgcolor="#A9E1E7"><div align="center"><font face="Arial" size="2">Qty</font></div></td>
								<td width="4%"  bgcolor="#A9E1E7"><div align="center"><font face="Arial" size="2">UOM</font></div></td>
								<td width="12%" bgcolor="#A9E1E7"><div align="center"><font face="Arial" size="2">Amount</font></div></td>
								<td width="11%" bgcolor="#A9E1E7"><div align="center"><font face="Arial" size="2">Line Type</font></div></td>
							</tr>
							<%
							try
							{
								int i= 1;
								String line_no ="";
								String cust_po_line_number = "";
								String customerProductNumber= "";
								String item_Description = "";
								String inventory_Item= "";
								float selling_Price =0;
								int quantity =0;
								int totQty =0;
								String uom = "";
								String line_type = "";
								float amount = 0;
								float totAmount = 0;
								sql =" select LINE_NO,SHIPPING_INSTRUCTIONS,"+
								"CUSTOMERPRODUCTNUMBER,ITEM_DESCRIPTION,INVENTORY_ITEM"+
								",SELLING_PRICE,QUANTITY,UOM,AMOUNT,LINE_TYPE"+
								" from TSC_OE_AUTO_LINES  "+
								" where id = '"+keyID+"'" +
								" order by LINE_NO" ; 
								Statement statement=con.createStatement();
								ResultSet rs = statement.executeQuery(sql);
								while(rs.next())
								{
									line_no =rs.getString("LINE_NO");
									cust_po_line_number = rs.getString("SHIPPING_INSTRUCTIONS");
									customerProductNumber= rs.getString("CUSTOMERPRODUCTNUMBER");
									item_Description =rs.getString("ITEM_DESCRIPTION");
									inventory_Item= rs.getString("INVENTORY_ITEM");
									selling_Price =rs.getFloat("SELLING_PRICE");
									quantity =rs.getInt("QUANTITY");
									totQty += quantity;
									uom = rs.getString("UOM");
									line_type = rs.getString("LINE_TYPE");
									amount = (float)Math.round(quantity * selling_Price * 100)/100 ;
									totAmount += amount;
									out.println("<tr>");
									out.println("<td >");
									out.println("<input class='style1' type='text' name='LINE_NO'  size='1'  value='"+line_no+"' readonly>");
									out.println("</td>");
									out.println("<td class='style1'>");
									out.println("<input class='style1' type='text' name='custpolinenumber"+i+"' size='20' value='"+cust_po_line_number+"' readonly>");
									out.println("</td>");
									if(customerProductNumber!=null &&  inventory_Item!=null && item_Description!=null )
									{
									out.println("<td>");
									out.println("<input class='style1' type='text' name='cust_num"+i+"'  size='15' value='"+customerProductNumber+"' readonly>");
									out.println("</td>");
									out.println("<td>");
									out.println("<input class='style1' type='text' name='item_desc"+i+"'  size='15'  value='"+item_Description+"' readonly>");
									out.println("</td>");
									out.println("<td>");
									out.println("<input class='style1' type='text' name='inv_item"+i+"'  size='27' value='"+inventory_Item+"' readonly>");
									out.println("</td>");
									}
									else if(customerProductNumber!=null &&  inventory_Item==null && item_Description!=null  )
									{
									errCnt ++;
									out.println("<td>");
									out.println("<input class='style5' type='text' name='cust_num"+i+"'  size='15'  value='"+customerProductNumber+"' readonly>");                       out.println("</td>");
									out.println("<td>");
									out.println("<input class='style5' type='text' name='item_desc"+i+"'  size='15' value='"+item_Description+"' readonly>");
									out.println("</td>");
									out.println("<td>");
									out.println("<INPUT TYPE='button'  value='...' onClick='subWindowProductFind("+
									'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+
									","+'"'+java.net.URLEncoder.encode(keyID)+'"'+
									","+'"'+java.net.URLEncoder.encode(line_no)+'"'+
									","+'"'+java.net.URLEncoder.encode(Customer_Number)+'"'+")' title='請按我!'>"+
									"<input class='style5' type='text' name='inv_item"+i+"'  size='27'  value='&nbsp;' readonly>");
									out.println("</td>");
									}
									else
									{
									errCnt ++;
									out.println("<td>");
									if (customerProductNumber == null)
									{
										out.println("<input class='style5'type='text' name='cust_num"+i+"'  size='15' value='&nbsp;' readonly>	");
									}else{
										out.println("<input class='style5'type='text' name='cust_num"+i+"'  size='15' value='"+customerProductNumber+"' readonly>");
									}
									out.println("</td>");
									out.println("<td>");
									if (item_Description == null)
									{
										out.println("<input class='style5' type='text' name='item_desc"+i+"'  size='15' value='&nbsp;' readonly>");
									}else{
										out.println("<input class='style5' type='text' name='item_desc"+i+"'  size='15' value='"+item_Description+"' readonly>");
									}
									out.println("</td>");
									out.println("<td>");
									out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowProductFind("+
									'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+
									","+'"'+java.net.URLEncoder.encode(keyID)+'"'+
									","+'"'+java.net.URLEncoder.encode(line_no)+'"'+
									","+'"'+java.net.URLEncoder.encode(Customer_Number)+'"'+")' title='請按我!'>"+
									"<input class='style5' type='text' name='inv_item"+i+"'  size='27' value='&nbsp;' readonly>");
									out.println("</td>");
									}
									out.println("<td class='style3'>");
									out.println("<input class='style3' type='text' name='unitprice"+i+"'  size='10'  value='"+selling_Price+"' readonly>");
									out.println("</td>");
									out.println("<td class='style3'>");
									String str_qty  = (new DecimalFormat("##,###,###")).format(quantity);
									out.println("<input class='style3' type='text' name='qty"+i+"'  size='12' value='"+str_qty+"' readonly>");
									out.println("</td>");
									out.println("<td>");
									out.println("<input class='style4' type='text' name='UOM"+i+"'  size='5'  value='"+uom+"' readonly>");
									out.println("</td>");
									out.println("<td class='style3'>");
									String str_amount = (new DecimalFormat("##,###,##0.00")).format(amount);
									out.println("<input class='style3' type='text' name='amt"+i+"' size='16' value='"+ str_amount+"' readonly>");
									out.println("</td>");
									out.println("<td width='20%'>");
									out.println("<input class='style4' type='text' name='linetype"+i+"'  size='3'  value='"+line_type+"' readonly>");
									out.println("<IMG name='ppp' src='images/search.gif' width='15' height='15' border=0 alt='' onClick='subWindowLineTypeFind("+
									'"'+java.net.URLEncoder.encode(keyID)+'"'+
									","+'"'+java.net.URLEncoder.encode(line_no)+'"'+
									","+'"'+java.net.URLEncoder.encode(odr_status)+'"'+")' title='請按我!'>");
									out.println("</td>");
									out.println("</tr>"); 
									i++;
								}
								out.println("<tr>");
								out.println("<td colspan='6' bgcolor='#A9E1E7' align='right'><font face='Arial' size='2'>Total:</font></div></td>");
								out.println("<td bgcolor='#A9E1E7'>");
								String str_totQty = (new DecimalFormat("##,###,###")).format(totQty);
								out.println("<input class='style3' type='text' name='totQty' size='12' value='"+ str_totQty+"' readonly>");
								out.println("</td>");
								out.println("<td bgcolor='#A9E1E7'>&nbsp;</td>");
								out.println("<td bgcolor='#A9E1E7'>");
								String str_totAmount = (new DecimalFormat("##,###,###,###.00")).format(totAmount);
								out.println("<input class='style3' type='text' name='totAmount' size='16' value='"+ str_totAmount+"' readonly>");
								out.println("</td>");
								out.println("<td bgcolor='#A9E1E7'>&nbsp;</td>");
								out.println("</tr>");
								rs.close();   
								statement.close(); 
							}
							catch (Exception e) 
							{
								out.println("Exception:"+e.getMessage()); 
							} 
							%>
							<tr>
								<td colspan="13"  bgcolor="#A9E1E7" >&nbsp;</td>
							</tr>
					  </table>
					</TD>
				</TR>
				<TR>
					<TD>
						<table cellspacing="0" bordercolordark="#FFFFFF"  cellpadding="1" width="100%" align="left" bordercolorlight="#0099FF" border="1">
							<tr>
								<td width="23%"  bgcolor="#AEF199"><div align="center"><font face="Arial" size="2">業務姓名</font></div></td>
								<td width="29%"  bgcolor="#AEF199"><div align="center"><font face="Arial" size="2">Created_Date</font></div></td>
								<td width="26%"  bgcolor="#AEF199"><div align="center"><font face="Arial" size="2">Created_By</font></div></td>
								<td width="22%"  bgcolor="#AEF199"><div align="center"><font face="Arial" size="2">&nbsp;</font></div></td>
							</tr>
							<tr>
								<td class="style1"><div align="center"><font size="2"><%=SalesPerson%></font></div></td>
								<td class="style1"><div align="center"><font size="2"><%=Creation_Date%></font></div></td>
								<td class="style1"><div align="center"><font size="2"><%=Created_By%></font></div></td>
								<td align="center">
								<%
								if (errCnt ==0 && odr_status.equals("OPEN"))
								{
									out.println("<input type='button' class='style4' name='complete' value='Complete' "+
									" onClick='setCreate("+'"'+"../jsp/Tsc1211CallAPI.jsp?ID="+keyID+
									"&status=process&sourcepg=D1010&customerID="+customerID+'"'+")' title='請按我，才能生成訂單!'>");
								}
								else
								{
									out.println("&nbsp");
								}
								%>
								</td>													 
							</tr>
							<tr>
								<td width="23%"  bgcolor="#AEF199">&nbsp;</td>
								<td width="29%"  bgcolor="#AEF199">&nbsp;</td>
								<td width="26%"  bgcolor="#AEF199">&nbsp;</td>
								<td width="22%"  bgcolor="#AEF199">&nbsp;</td>
							</tr>
						</table>
					</TD>
				</TR>
			</TABLE>
		</td>
	</tr>
</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

</form>
</body>
</html>
