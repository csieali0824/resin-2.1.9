<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*"%>
<%@ page import="java.text.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
 
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
 
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%

   
   //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
   CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
   //cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
   cs1.execute();
   //out.println("Procedure : Execute Success !!! ");
   cs1.close();
 
//String lineTypeSet=request.getParameter("lineTypeSet");
String line_Type =request.getParameter("line_Type");
String customerPO=request.getParameter("customerPO");
String keyID=request.getParameter("ID");
//String line_Type1=request.getParameter("line_Type1");
String lineType = request.getParameter("LINE_TYPE"); 

//out.println(customerPO);
String sSql = request.getParameter("sSql");
String customerID =  request.getParameter("customerID");
String transaction_Type_ID = request.getParameter("transaction_Type_ID");
String customer_Name =request.getParameter("customer_Name");
String order_Type_ID = request.getParameter("order_Type_ID");
String ts_customer_Name =request.getParameter("ts_customer_Name");
String customer_PO = request.getParameter("customer_PO");
String c_Date = request.getParameter("c_Date");
String payterm_ID =request.getParameter("payterm_ID");
String packing_List_Number =request.getParameter("packing_List_Number");
String shipment_Term =request.getParameter("shipment_Term");
String created_By = request.getParameter("created_By");
String creation_Date =request.getParameter("creation_Date");
String salesPerson=request.getParameter("salesPerson");
String customerName=request.getParameter("customerName");
String customerNumber=request.getParameter("customerNumber");
String cartonNumber =request.getParameter("cartonNumber");
String awb		    =request.getParameter("awb");
String invoiceNumber= request.getParameter("invoiceNumber");
String currency= request.getParameter("currency");
String orderNo ="";

String shipToID =request.getParameter("shipToID");
String billToID =request.getParameter("billToID");
String partyID = request.getParameter("PARTYID"); 
String price_List_id=request.getParameter("price_List_id");

String shipTo_Departmaent=request.getParameter("shipTo_Departmaent");
String shipTo_Street=request.getParameter("shipTo_Street");
String shipTo_City=request.getParameter("shipTo_City");
String shipTo_County=request.getParameter("shipTo_County");
String shipTo_ZIP=request.getParameter("shipTo_ZIP");
String shipTo_Country=request.getParameter("shipTo_Country");

String billTo_Departmaent=request.getParameter("billTo_Departmaent");
String billTo_Street=request.getParameter("billTo_Street");
String billTo_City=request.getParameter("billTo_City");
String billTo_County=request.getParameter("billTo_County");
String billTo_ZIP=request.getParameter("billTo_ZIP");
String billTo_Country=request.getParameter("billTo_Country");

//String LINENO =request.getParameter("LINENO");
String line_no =request.getParameter("line_no");
String p_line_no =request.getParameter("p_line_no");
String p_inventory_Item =request.getParameter("inventory_Item");
String p_item =request.getParameter("Item");
String p_Item_Description =request.getParameter("p_Item_Description");
String p_Item_Identifier = request.getParameter("p_Item_Identifier");
String p_Item_ID = request.getParameter("p_Item_ID");
String p_Currency_Code = request.getParameter("p_Currency_Code");

String item_Description ="";
String customerProductNumber  = "";
String inventory_Item =request.getParameter("inventory_Item");
String p_inventory_Item_ID = request.getParameter("inventory_Item_ID");
String p_List_Header_ID = request.getParameter("p_List_Header_ID");

String c_Cust_Account_ID = request.getParameter("c_Cust_Account_ID");
String c_Customer_Number = request.getParameter("c_Customer_Number");
String c_Customer_Name = request.getParameter("c_Customer_Name");
String c_Party_Number = request.getParameter("c_Party_Number");
String c_Payterm_ID = request.getParameter("c_Payterm_ID");
String c_BillToID = request.getParameter("c_BillToID");
String u_Update_Field= request.getParameter("u_Update_Field");
String c_Currency_Code=request.getParameter("c_Currency_Code");
String c_Price_List_ID= request.getParameter("c_Price_List_ID");

String u_Site_Use_ID = request.getParameter("u_Site_Use_ID");
String u_Use_Code = request.getParameter("u_Use_Code");
 

int   quantity =0;
float selling_Price =0;
float amount = 0;
%>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC Confirm  List Detail</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<style type="text/css">
<!--
.style2 {color: #FFFFFF}
-->
</style>
<script language="JavaScript" type="text/JavaScript">
function setLineType(CC)
{    
	var gg=document.form1.line_Type.value;
 	alert("document.form1."+CC+".value =="+ gg);
	document.form1.elements[CC].value == "222";
} 
 

function subWindowProductFind(primaryFlag,ID,line_no,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscProductFind.jsp?PRIMARYFLAG="+primaryFlag+"&ID="+ID+"&line_no="+line_no+"&CUSTOMERNUMBER="+customerNumber,"subwin");  
} 

function subWindowPriceListFind(ID,Currency_code)
{    
	subWin=window.open("../jsp/subwindow/TscPriceListFind.jsp?ID="+ID+"&Currency_code="+Currency_code,"subwin");  
} 

function subWindowShipToFind(ID,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscUseInfoFind.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&ADDRESSID="+"SHIP_TO"+"&u_Update_Field="+"SHIPTOID","subwin");  
}
function subWindowBillToFind(ID,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscUseInfoFind.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&ADDRESSID="+"BILL_TO"+"&u_Update_Field="+"BILLTOID","subwin");  
}

function subWindowCustomerFind(ID)
{    
	subWin=window.open("../jsp/subwindow/TscCustomerFind.jsp?ID="+ID,"subwin");  
}
function setSubmit2(URL,LINE)
{  


	var linkURL = "#"+LINE;
	document.form1.action=URL+"&line_no="+LINE+linkURL;
	document.form1.submit(); 
	
}

function setCreate(URL)
{  
	document.form1.action=URL;
	document.form1.submit(); 
}


</script>
<%

String status = "next";
String	q_status = "";


if(u_Site_Use_ID!=null && u_Use_Code!=null){ 
	try{
		String sql = "update  TSC_OE_AUTO_HEADERS  set  "+u_Update_Field+"=?    where ID='"+keyID+"' ";
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(u_Site_Use_ID));        
		pstmt.executeUpdate(); 
		pstmt.close();
		response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(SQLException e){out.println(e.toString());}

}  



 
if (c_Cust_Account_ID!=null   &&  c_Customer_Name!=null  && c_Party_Number!=null && c_Payterm_ID!=null && c_BillToID!=null ){ 
	try{
		//out.println("c_Customer_Name="+c_Customer_Name);
		String sql = "update  TSC_OE_AUTO_HEADERS  set CUSTOMERNAME=?, CUSTOMERID=? , CUSTOMERNUMBER=? , BILLTOID = ? ,PAYTERM_ID=? ,CURRENCY=? , PRICE_LIST=? where ID='"+keyID+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,c_Customer_Name.replaceAll("FUCK","&"));   
		pstmt.setInt(2,Integer.parseInt(c_Party_Number));   
		pstmt.setInt(3,Integer.parseInt(c_Cust_Account_ID));
		pstmt.setInt(4,Integer.parseInt(c_BillToID));   
		pstmt.setInt(5,Integer.parseInt(c_Payterm_ID));     
		pstmt.setString(6,c_Currency_Code);  
		pstmt.setString(7,c_Price_List_ID);  
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(SQLException e){out.println(e.toString());}	
	try{
		String sql = "update  TSC_OE_AUTO_LINES  set ITEM_DESCRIPTION=?, INVENTORY_ITEM_ID=? ,INVENTORY_ITEM=? , ITEM_IDENTIFIER_TYPE = ? ,CUSTOMERPRODUCT_ID=?  where ID='"+keyID+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,"");   
		pstmt.setString(2,"");   
		pstmt.setString(3,"");
		pstmt.setString(4,"");   
		pstmt.setInt(5,0);      
		pstmt.executeUpdate(); 
		pstmt.close();
		response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(SQLException e){out.println(e.toString());}
}  

if (line_no!=null  && !lineType.equals("--")){ 
	try{
		String sql = "update  TSC_OE_AUTO_LINES  set LINE_TYPE=? where ID='"+keyID+"' and LINE_NO='"+line_no+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(lineType));   
		pstmt.executeUpdate(); 
		pstmt.close();
		response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(SQLException e){out.println(e.toString());}
}  
if (p_inventory_Item_ID!=null  && p_line_no!=null && p_inventory_Item!=null  && p_Item_Identifier!=null){ 
	try{
		String sql = "update  TSC_OE_AUTO_LINES  set INVENTORY_ITEM_ID=?, INVENTORY_ITEM=? , CUSTOMERPRODUCTNUMBER=? , ITEM_DESCRIPTION=? , ITEM_IDENTIFIER_TYPE =?  ,CUSTOMERPRODUCT_ID=? where ID='"+keyID+"' and LINE_NO='"+p_line_no+"' ";																		
		PreparedStatement pstmt=con.prepareStatement(sql);   
 		//out.println(p_Item_ID);
		pstmt.setInt(1,Integer.parseInt(p_inventory_Item_ID));  // Line Type
		pstmt.setString(2,p_inventory_Item);
		pstmt.setString(3,p_item);
		pstmt.setString(4,p_Item_Description);
		pstmt.setString(5,p_Item_Identifier);
		pstmt.setInt(6,Integer.parseInt(p_Item_ID));
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(Exception e){out.println("Exception:hj"+e.toString());}
	//}catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
} 
if (p_List_Header_ID!=null && p_Currency_Code!=null ){ 
	try{
		String sql = "update  TSC_OE_AUTO_Headers  set PRICE_LIST=? ,CURRENCY=?  where ID='"+keyID+"'";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(p_List_Header_ID));  // Line Type
		pstmt.setString(2,p_Currency_Code);
		pstmt.executeUpdate(); 
		pstmt.close();
		response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+keyID);
	}catch(SQLException e){out.println(e.toString());}
} 
%>

</head>



<body>
<form name="form1"  METHOD="post" >
<%
	try{
	 sSql="select  CUSTOMERID,CUSTOMERPO,CUSTOMERNAME, SHIPMENTTERMS,PACKINGLISTNUMBER, order_number , PRICE_LIST,PAYTERM_ID, "+
		  " C_DATE,SALESPERSON,CREATED_BY,CREATION_DATE , SHIPTOID ,BILLTOID,CURRENCY ,CUSTOMERNUMBER, ORDER_TYPE_ID,STATUS, ID " + 
		  " from   TSC_OE_AUTO_HEADERS   WHERE "+
		  " ID = '"+keyID+"'" ;
 
		 Statement st = con.createStatement();
		 ResultSet rs = st.executeQuery(sSql);
			while(rs.next()){
				customerID = rs.getString("CUSTOMERID");
				customerPO = rs.getString("CUSTOMERPO");
				customerName = rs.getString("CUSTOMERNAME") ;
				customerNumber = rs.getString("CUSTOMERNUMBER") ;
				packing_List_Number = rs.getString("PACKINGLISTNUMBER");
				order_Type_ID = rs.getString("ORDER_TYPE_ID");
				c_Date = 	rs.getString("C_DATE");
				salesPerson = 	rs.getString("SALESPERSON");
				created_By = 	rs.getString("CREATED_BY");
				creation_Date = 	rs.getString("CREATION_DATE");
				shipToID = 	rs.getString("SHIPTOID");
				billToID = 	rs.getString("BILLTOID");
				shipment_Term =rs.getString("SHIPMENTTERMS");
				currency =rs.getString("currency"); 
				payterm_ID = rs.getString("PAYTERM_ID");
				price_List_id = rs.getString("PRICE_LIST");
				q_status=rs.getString("STATUS");
				keyID = rs.getString("ID");
				orderNo = rs.getString("ORDER_NUMBER");
			} 
	}catch(SQLException e){out.println(e.toString());}

 
	try{
		sSql="select l.CUSTOMERPO CUSTOMERPO,h.ORDER_TYPE_ID ,h.PAYTERM_ID , h.PACKINGLISTNUMBER  ,h.ID  from TSC_OE_AUTO_LINES l , TSC_OE_AUTO_HEADERS h  WHERE "+
			 "l.ID = h.ID and h.ID = '"+keyID+"'" ;
  
		Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(sSql);
					
		while(rs.next()){
			keyID = rs.getString("ID");
		} 
	}catch(SQLException e){out.println(e.toString());}
 
%>

<p>
  <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</p>
  <TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Order Temp Confirm Interface</strong></font></TD><br>
<A HREF="Tsc1211ConfirmList.jsp"><font size="2">回上一頁</font></A>
<table cellspacing="0" bordercolordark="#FFCC99"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
    <td colspan="2" bgcolor="#FFFFFF"><FONT color="#FF0000" size="2">訂單轉入資訊:</FONT></td>
    </tr>
  <tr>
    <td width="79" bgcolor="#FFCC99"><font size="2" color="#FF0000">客戶名稱:</font></td>
    <td width="675" align="left">
	<%
		if(q_status=="CLOSED" || q_status.equals("CLOSED")){
			
		}else{
			out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowCustomerFind("+'"'+java.net.URLEncoder.encode(keyID)+'"'+")'>");
		}
		
		try{
	  		Statement statement=con.createStatement();
        	ResultSet rs=null;	
			String custname_sql = "select party_name,party_number,party_id from  hz_parties where party_number ='"+customerID+"'";
			 
			rs=statement.executeQuery(custname_sql);	  			  				     
				while (rs.next()){
					ts_customer_Name = rs.getString("PARTY_NAME");
					partyID = rs.getString("party_id");
					out.println("<input align='left' type='text' name='customer_Name' size='80' maxlength='15' value='"+ts_customer_Name+"' readonly>");
					 
				}         
	 	 }catch(Exception e) { out.println("Exception:b"+e.getMessage()); }    

 		%>
        </td>
  </tr>
</table>
<table cellspacing="0" bordercolordark="#FFCC99"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
    <td width="78" bgcolor="#FFCC99"><font   size= "2" color="#FF0000">訂單類型</font></td>
    <td width="272"><input type="hidden" name="TRANSACTION_TYPE_CODE"   value='<%=order_Type_ID%>' size="6" readonly="">
    <font size="2" color="#FF0000"><%out.println("1211(TSC Consignment Order)");%></font></td>
    <td width="102" bgcolor="#FFCC99"><font  size="2" color="#FF0000" >客戶訂單號碼</font></td>
    <td width="294"><font size="2"><input value="<%=customerPO%>" name = "customerPO" size="10" readonly=""></font></td>
  </tr>
  <tr>
    <td bgcolor="#FFCC99"><font  size= "2" color="#FF0000">付款條件 : </font></td>
    <td><font size="2">
	<% 
 
	  try{
	  	Statement statement=con.createStatement();
        ResultSet rs=null;	
	  	String pay_sql = "select NAME from RA_TERMS_VL  where term_id='"+payterm_ID+"'";
		rs=statement.executeQuery(pay_sql);	  			  				     
			while (rs.next()){
				out.println("<input align='left' type='text' name='payterm' size='30' maxlength='15' value='"+rs.getString("name")+"' readonly>"); 
			}         
	  }catch(Exception e) { out.println("Exceptiono:"+e.getMessage()); }    

	
	
	%>
    </font> </td>
    <td bgcolor="#FFCC99"><font size="2" color="#FF0000">包裝號碼 : </font></td>
    <td><font size="2"> 
		<input align='left' type='text' name='packing_List_Number' size='10' maxlength='15' value='<%=packing_List_Number%>' readonly>
	</font></td>
  </tr>
  <tr>
    <td bgcolor="#FFCC99"><font  size= "2" color="#FF0000">出貨方式 :</font></td>
    <td><font  size= "2">
		<input align='left' type='text' name='shipment_Term' size='15' maxlength='15' value='<%=shipment_Term%>' readonly>
    </font></td>
    <td bgcolor="#FFCC99"><font  size= "2" color="#FF0000">幣別 : </font></td>
    <td><font  size= "2"> 
	<input align='left' type='text' name='currency' size='10' maxlength='15' value='<%=currency%>' readonly>
	</font></td>
  </tr>
  <tr>
    <td bgcolor="#FFCC99"><font  size= "2" color="#FF0000">價目表</font></td>
       <td width="39%" ><font face="Arial" size="2" color="#FF0033"><%=price_List_id%></font><font face="Arial" size="2" color="#FF0033">
	   
		      <%		
			  if(q_status=="CLOSED" || q_status.equals("CLOSED")){
			  	out.println(" &nbsp;");
			  }else{
			  	out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowPriceListFind("+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(currency)+'"'+")'>");     			 
			  } 
				 try{   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;		      
									  
				   String sql = "select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
			                    "from qp_list_headers_v "+
			                    "where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' and LIST_HEADER_ID='"+price_List_id+"'"; 					   
			  	   //out.println(sql);
                   rs=statement.executeQuery(sql);

		          	while (rs.next()){ 
				   		out.println(rs.getString("LIST_CODE"));           
		            } //end of while
    	 
                 }catch (Exception e) { out.println("Exception:m"+e.getMessage()); }  
				 
			  %>		  
		   </font>
	   </td>
       <td bgcolor="#FFCC99">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr bgcolor="#FFCC99">
	  <td bgColor="#FFCC99" colspan="4"><font face="Arial" size="2" color="#FF0033"></font>

		   </font>		   
	  </td> 	  
	</tr> 
</table>
<table cellspacing="0" bordercolordark="#FFCC99"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
 	  <td bgColor="#FFCC99" colspan="3"><font face="Arial" size="2" color="#FF0033"> 出貨地址 :</font>
		    <%			     
			   
				 try{  // 取預設選擇客戶的Ship To Address 及 Bill To Address 
				 	Statement statement=con.createStatement();
                 	ResultSet rs=null;	
 				 	String sql = " select a.STATUS,a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1,b.ADDRESS2,b.ADDRESS3,b.ADDRESS4  "+ 
		 					  	 " from AR_SITE_USES_V a,RA_ADDRESSES_ALL b where a.ADDRESS_ID = b.ADDRESS_ID "+
							  	 " and a.STATUS=b.STATUS and a.STATUS='A'  and b.ORG_ID = '41' "+
					 		  	 " and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL  WHERE CUST_ACCOUNT_ID='"+customerNumber+"') "+
				 			  	 " and (a.SITE_USE_ID = '"+shipToID+"' or  a.SITE_USE_ID = '"+billToID+"' )"; 

                   	rs=statement.executeQuery(sql);	  			  				     
		           	while (rs.next()){            		             
		            	if (rs.getString("SITE_USE_CODE")=="SHIP_TO" || rs.getString("SITE_USE_CODE").equals("SHIP_TO")){ 
					   		shipTo_Street  = rs.getString("ADDRESS1"); 
					   		shipTo_Country = rs.getString("COUNTRY"); 
					 	}

		             	if (rs.getString("SITE_USE_CODE")=="BILL_TO" || rs.getString("SITE_USE_CODE").equals("BILL_TO")){  
							//billTo=rs.getString("SITE_USE_ID");
							billTo_Street=rs.getString("ADDRESS1"); 
							billTo_County=rs.getString("COUNTRY"); 
					 	}
		           	} //end of while		
				             			   
		           rs.close();   
				   statement.close();  
				 }catch (Exception e) { out.println("Exception:"+e.getMessage()); }    
			  %>	      		   
 
		   <input type="text" size="10" name="SHIPTOORG" value="<%=shipToID%>" readonly>		
		   	<%
			if(q_status=="CLOSED" || q_status.equals("CLOSED")){
			
			}else{
			%>
		   		<INPUT TYPE="button"  value="..." onClick='subWindowShipToFind("<%=keyID%>","<%=customerNumber%>")'>
		   <%}%>
		   
		   <INPUT TYPE="text" NAME="SHIPADDRESS" SIZE=80 value="<%=shipTo_Street%>" readonly> 
		   <INPUT TYPE="text" NAME="SHIPCOUNTRY" SIZE=3 value="<%=shipTo_Country%>" readonly> 
		   </font>		   
	  </td> 	</tr>
</table>
<table cellspacing="0" bordercolordark="#FFCC99"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
	  <td bgColor="#FFCC99" colspan="3"><font face="Arial" size="2" color="#FF0033"> 發票地址 :</font>		         		  
		   <input type="text" size="10" name="BILLTO" value="<%=billToID%>" readonly>
		    <%
			if(q_status=="CLOSED" || q_status.equals("CLOSED")){
			
			}else{
			%>
		   		<INPUT TYPE="button"  value="..." onClick='subWindowBillToFind("<%=keyID%>","<%=customerNumber%>")'>	
		   	<%}%>	
		   <INPUT TYPE="text" NAME="BILLADDRESS" SIZE=80 value="<%=billTo_Street%>" readonly border="0"> 
		   <INPUT TYPE="text" NAME="BILLCOUNTRY" SIZE=3 value="<%=billTo_County%>" readonly border="0">   
		   </font>		   
	  </td> </tr>
</table>
 <table cellspacing="0" bordercolordark="#FFffff"  cellpadding="1" width="1300" align="center" bordercolorlight="#FFCC99" border="1">
  <tr>
    <td colspan="8"  bgcolor="#FFAA99" ><span class="style2"><font size="2">處理內容明細 :</font></span></td>
	<td colspan="5"  bgcolor="#FFAA99" ><span class="style2"> <font size="2">Line Type Select :</font></span>
	  <%
		if(q_status=="CLOSED" || q_status.equals("CLOSED")){
			out.println("&nbsp");
		}else{
			try{ 
				Statement statement=con.createStatement();
			  	ResultSet rs=null;	
			  	String sqlOrgInf = "select DISTINCT LINE_TYPE_ID, LINE_TYPE_ID||'('||LINE_TYPE||')' "+
								   "from APPS.OE_WF_LINE_ASSIGN_V ";
			  	rs=statement.executeQuery(sqlOrgInf);
			  	comboBoxBean.setRs(rs);
			  	comboBoxBean.setSelection(lineType);
			  	comboBoxBean.setFieldName("LINE_TYPE");	   
			  	out.println(comboBoxBean.getRsString());
				rs.close();   
			  	statement.close();   
			}catch (Exception e) { out.println("Exception:a"+e.getMessage()); } 
		}
	%>	 </td>
    </tr>
  <tr>
    <td width="2%"  bgcolor="#FFAA99" ><font size="2">Line</font></td>
	<td width="15%"  bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">台半料號說明</font></div></td>
	<td width="15%"  bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">客戶料號說明</font></div></td>
	<td width="15%"  bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">Internal Item</font></div></td>
    <td width="8%" colspan="1" bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">數量</font></div></td>
	<td width="4%" colspan="1" bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">UOM</font></div></td>
    <td width="12%" bgcolor="#FFAA99"><div align="center"><font size="2">單價</font></div></td>
    <td width="8%" colspan="1" bgcolor="#FFAA99"><div align="center"><font face="Arial" size="2">加總</font></div></td>
    <td width="6%" bgcolor="#FFAA99"><font size="2">Carton Number</font></td>
    <td width="6%" bgcolor="#FFAA99"><font size="2">Awb</font></td>
    <td width="10%" bgcolor="#FFAA99"><font size="2">Invoice Number</font></td>
	<td width="2%"  bgcolor="#FFAA99" ><font size="2"> </font></td>
    <td width="14%" bgcolor="#FFAA99"><p><font size="2">Line Type</font></td>
  </tr>
<%
	try{
		int i= 1;
			Statement st1=con.createStatement();
			ResultSet rs1=null;
			String	sql = "select * "+
						  "from	TSC_OE_AUTO_LINES  "+
						  "where id = '"+keyID+"'" +
						  " order by LINE_NO ASC" ; 
			rs1=st1.executeQuery(sql);

		while(rs1.next()){
			 line_no =rs1.getString("LINE_NO");
			 item_Description =rs1.getString("ITEM_DESCRIPTION");
			 quantity =rs1.getInt("QUANTITY");
			 selling_Price =rs1.getFloat("SELLING_PRICE");
			 amount = quantity * selling_Price ;
			 line_Type=rs1.getString("LINE_TYPE");
 			 cartonNumber =rs1.getString("CARTONNUMBER"); 
			 awb  =rs1.getString("AWB"); 
			 invoiceNumber= rs1.getString("SHIPPING_INSTRUCTIONS"); 
			 customerProductNumber= rs1.getString("CUSTOMERPRODUCTNUMBER");
			 inventory_Item= rs1.getString("INVENTORY_ITEM");
				int kk =i;
				out.println("<tr>");
				out.println("<td><input align='center' type='text' name='LINE_NO'   size='3' maxlength='2' value='"+line_no+"' readonly></td>");
				
			
			if(customerProductNumber!=null &&  inventory_Item!=null && item_Description!=null ){
				out.println("<td><div align='right'><input align='right' type='text' name='ITEM_DESCRIPTION"+i+"'  size='15' maxlength='30' value='"+item_Description+"' readonly></div></td>");
				out.println("<td><div align='right'><input align='right' type='text' name='CUSTOMER_NUMBER"+i+"'  size='15' maxlength='30' value='"+customerProductNumber+"' readonly></div></td>");
				out.println("<td><div align='right'><input align='right' type='text' name='INVENTORY_ITEM"+i+"'  size='20' maxlength='30' value='"+inventory_Item+"' readonly></div></td>");
			}else if(customerProductNumber!=null &&  inventory_Item==null && item_Description!=null  ){
				   status = "stop";
				out.println("<td bgcolor='#AA0000'><div align='right'><input align='right' type='text' name='ITEM_DESCRIPTION"+i+"'  size='15' maxlength='30' value='"+item_Description+"' readonly></div></td>");
				out.println("<td bgcolor='#AA0000'><div align='right'><input align='right' type='text' name='CUSTOMER_NUMBER"+i+"'  size='15' maxlength='30' value='"+customerProductNumber+"' readonly></div></td>");
				out.println("<td bgcolor='#AA0000'><div align='right'><INPUT TYPE='button'  value='...' onClick='subWindowProductFind("+'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+","+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(line_no)+'"'+","+'"'+java.net.URLEncoder.encode(customerNumber)+'"'+")'><input align='right' type='text' name='INVENTORY_ITEM"+i+"'  size='20' maxlength='30' value='"+inventory_Item+"' readonly></div></td>");
			}else{
				 status = "stop";
				out.println("<td bgcolor='#AA0000'><div align='right'><input align='right' type='text' name='ITEM_DESCRIPTION"+i+"'  size='15' maxlength='30' value='"+item_Description+"' readonly></div></td>");
				out.println("<td bgcolor='#AA0000'><div align='right'><input align='right' type='text' name='CUSTOMER_NUMBER"+i+"'  size='15' maxlength='30' value='"+customerProductNumber+"' readonly></div></td>");
				out.println("<td bgcolor='#AA0000'><div align='right'><INPUT TYPE='button'  value='...'  onClick='subWindowProductFind("+'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+","+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(line_no)+'"'+","+'"'+java.net.URLEncoder.encode(customerNumber)+'"'+")'><input align='right' type='text' name='INVENTORY_ITEM"+i+"'  size='20' maxlength='30' value='"+inventory_Item+"' readonly></div></td>");
			}
				out.println("<td><div align='right'><input align='right' type='text' name='QUANTITY"+i+"'  size='10' maxlength='15' value='"+quantity+"' readonly></div></td>");
				out.println("<td><div align='right'><input align='right' type='text' name='UOM"+i+"'  size='5' maxlength='5' value='PCE' readonly></div></td>");
				out.println("<td><div align='right'><input align='right' type='text' name='SELLINGPRICE"+i+"'  size='10' maxlength='15' value='"+selling_Price+"' readonly></div></td>");
				out.println("<td><div align='right'><font size='2'>"+amount+"</font></div></td>");
				out.println("<td><font size='2'>"+cartonNumber+"</font></td>");
				out.println("<td><font size='2'>"+awb+"</font></td>");
				out.println("<td><font size='2'>"+invoiceNumber+"</font></td>");
				
				if(q_status=="CLOSED" || q_status.equals("CLOSED")){
					out.println("<td>&nbsp;</td>");
				}else{
					out.println("<td><input type='button'  value='set' onClick='setSubmit2("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+keyID+"&lineType="+lineType+'"'+","+'"'+rs1.getString("LINE_NO")+'"'+")'></td>");
				}
 
				out.println("<td><div align='right'><input align='right' type='text' name='LineType"+i+"'  size='10' maxlength='15' value='"+line_Type+"' readonly></div></td>");
				out.println("</tr>"); 
				 //out.println(i);
				i++;
			
		}
		  	rs1.close();   
		  	st1.close(); 
	}catch (Exception e) { out.println("Exception:9"+e.getMessage()); } 
%>
   <tr>
    <td colspan="13"  bgcolor="#FFAA99" >&nbsp;</td>
  </tr>
</table>
<table cellspacing="0" bordercolordark="#FFCC99"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
    <td width="21%"  bgcolor="#FFCC99"> <div align="center"><font face="Arial" size="2">業務姓名</font></div></td>
    <td width="26%" colspan="1" bgcolor="#FFCC99"><div align="center"><font face="Arial" size="2">Created_Date</font></div></td>
    <td width="24%" bgcolor="#FFCC99"><div align="center"><font face="Arial" size="2">Created_By</font></div></td>
    <td width="29%" colspan="1" bgcolor="#FFCC99"><div align="center"><font size="2" face="Arial"></font></div></td>
  </tr>
  <tr>
    <td><div align="right"><font size="2"><%=salesPerson%></font></div></td>
    <td><div align="right"><font size="2"><%=creation_Date%></font></div></td>
    <td><div align="right"><font size="2"><%=created_By%></font></div></td>
    <td>
      <div align="center">
	  
      <%   
	  	//小S 在 2/24 提出要在CALL API 完成後帶出 CUSTOMER NUMBER 
	  		try{ 
				Statement statement=con.createStatement();
			  	ResultSet rs=null;	
			  	String sql_cust = "select CUSTOMER_NUMBER  from   AR_CUSTOMERS_V  where PARTY_NUMBER='"+customerID+"'";
			  	rs=statement.executeQuery(sql_cust);
   				while(rs.next()){
			  		out.println("<input type='HIDDEN' name='CUSTOMER_NUMBER' size='15' maxlength='15' value='"+rs.getString("CUSTOMER_NUMBER")+"' readonly> ");
				}
				rs.close();   
			  	statement.close();   
			}catch (Exception e) { out.println("Exception:a"+e.getMessage()); } 
		
	  
	  
 
	  	if((status == "next" || status.equals("next")) && (q_status=="OPEN" || q_status.equals("OPEN"))){
	  %>
	  <%
			out.println("<input type='submit' name='Submit' value='complete' onClick='setCreate("+'"'+"../jsp/Tsc1211CallAPI.jsp?ID="+keyID+"&status="+"process"+"&customerID="+customerID+'"'+")'>");
      	
		}else{
			out.println("&nbsp");
		}
	  %>
	  </div></td>													 
  </tr>
  <tr>
    <td colspan="4"><div align="center"><em> </em></div></td>
  </tr>
  <tr>
    <td colspan="4"  bgcolor="#FFCC99" >&nbsp;</td>
  </tr>
</table>

<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

</form>
</body>
</html>
