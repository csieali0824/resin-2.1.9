<!-- 20141014 modify by Peggy,讀取bill to對應currency,若與buffernet currency不同,須擋住不能轉mo-->
<!-- 20150601 modify by Peggy,hip to contact有多筆時,不帶預設值-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*"%>
<%@ page import="java.text.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
 
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
 <!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
 
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
cs1.execute();
cs1.close();
 
String line_Type =request.getParameter("line_Type");
String customerPO=request.getParameter("customerPO");
String lineType = request.getParameter("LINE_TYPE"); 
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
String c_tax_code=request.getParameter("c_tax_code");
String c_ShipToID = request.getParameter("c_ShipToID");  //20110323 add by Peggychen
String u_Site_Use_ID = request.getParameter("u_Site_Use_ID");
String u_Use_Code = request.getParameter("u_Use_Code");
String u_payment_id = request.getParameter("u_payment_id");   //add by Peggy 20130412
String u_pricelist = request.getParameter("u_pricelist");     //add by Peggy 20130412
String u_fob = request.getParameter("u_fob");                 //add by Peggy 20130412
String u_currency = request.getParameter("u_currency");       //add by Peggy 20130516
String u_tax_code = request.getParameter("u_tax_code");       //add by Peggy 20131118
String orig_customerPO = ""; //add by Peggy 20120918
String q_status = request.getParameter("STATUS"); //add by Peggy 20120927
if (q_status == null) q_status ="OPEN";
String keyID=request.getParameter("ID");
String keyCode = request.getParameter("keyCode");
String ORDERNUM =request.getParameter("ORDERNUM");  //add by Peggy 20130416
int   quantity =0; 
float selling_Price =0;
float amount = 0,totamount = 0;
String ship_to_contact ="";
String ship_to_contact_id ="";
String p_ship_to_contact_id = request.getParameter("p_ship_to_contact_id");
if (p_ship_to_contact_id != null)
{
	ship_to_contact_id = p_ship_to_contact_id;
}
else
{
	ship_to_contact_id = request.getParameter("ship_to_contact_id");
}
if (ship_to_contact_id==null) ship_to_contact_id="";
String TAXCODE = request.getParameter("TAXCODE");
if (TAXCODE==null) TAXCODE="";
String bill_curr ="";  //add by Peggy 20141014
String taxcode_err=""; //add by Peggy 20190412
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
	var gg=document.MYFORM.line_Type.value;
 	alert("document.MYFORM."+CC+".value =="+ gg);
	document.MYFORM.elements[CC].value == "222";
} 

function subWindowProductFind(primaryFlag,ID,keyCode,line_no,customerNumber,itemdescription,cartonnum,invoiceno)
{    
	subWin=window.open("../jsp/subwindow/TscProductFind.jsp?PRIMARYFLAG="+primaryFlag+"&ID="+ID+"&KEYCODE="+keyCode+"&line_no="+line_no+"&CUSTOMERNUMBER="+customerNumber+"&ITEMDESC="+itemdescription+"&CARTON="+cartonnum+"&INVOICE="+invoiceno,"subwin","width=800,height=200,scrollbars=yes,menubar=no");
} 

function subWindowPriceListFind(ID,Currency_code)
{    
	subWin=window.open("../jsp/subwindow/TscPriceListFind.jsp?ID="+ID+"&Currency_code="+Currency_code,"subwin","scrollbars=yes,menubar=no");
} 

function subWindowShipToFind(ID,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscUseInfoFind.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&ADDRESSID=SHIP_TO&u_Update_Field=SHIPTOID","subwin","scrollbars=yes,menubar=no");
}
function subWindowBillToFind(ID,customerNumber)
{    
	subWin=window.open("../jsp/subwindow/TscUseInfoFind.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&ADDRESSID=BILL_TO&u_Update_Field=BILLTOID","subwin","scrollbars=yes,menubar=no");  
}
function subWindowCustomerFind(ID)
{    
	subWin=window.open("../jsp/subwindow/TscCustomerFind.jsp?ID="+ID,"subwin","scrollbars=yes,menubar=no"); 
}
function setSubmit2(URL,LINE,SEQNO)
{  
	var lineType = document.getElementById("LineType"+SEQNO).value;
	var linkURL = "#"+LINE;
	document.MYFORM.action=URL+"&LINE_TYPE="+lineType+"&line_no="+LINE+linkURL;
	document.MYFORM.submit(); 
}
function setCreate(URL)
{  
	//add by Peggy 20120830
	if (document.MYFORM.PAYTERMID.value == null || document.MYFORM.PAYTERMID.value=="null" || document.MYFORM.PAYTERMID.value=="")
	{
		alert("請先選擇付款條件!!");
		return false;
	}
	if (document.MYFORM.PRICELISTID.value == null || document.MYFORM.PRICELISTID.value =="null" || document.MYFORM.PRICELISTID.value =="")
	{
		alert("價目表不可空白!!");
		return false;
	}
	//add by Peggy 20120925
	if (document.MYFORM.shipment_Term.value == null || document.MYFORM.shipment_Term.value=="null" || document.MYFORM.shipment_Term.value=="")
	{
		alert("出貨方式不可空白!!");
		return false;
	}
	//add by Peggy 20120925
	if (document.MYFORM.currency.value == null || document.MYFORM.currency.value=="null" || document.MYFORM.currency.value=="")
	{
		alert("幣別不可空白!!");
		return false;
	}
	//add by Peggy 20131118
	if (document.MYFORM.TAXCODE.value == null || document.MYFORM.TAXCODE.value=="null" || document.MYFORM.TAXCODE.value=="")
	{
		alert("稅別不可空白!!");
		return false;
	}
	//add by Peggy 20120925
	if (document.MYFORM.SHIPTOORG.value == null || document.MYFORM.SHIPTOORG.value=="null" || document.MYFORM.SHIPTOORG.value=="")
	{
		alert("出貨地址不可空白!!");
		return false;
	}
	//add by Peggy 20120925
	if (document.MYFORM.BILLTO.value == null || document.MYFORM.BILLTO.value=="null" || document.MYFORM.BILLTO.value=="")
	{
		alert("發票地址不可空白!!");
		return false;
	}
	//add by Peggy 20121204
	if (document.MYFORM.ship_to_contact_id.value == null || document.MYFORM.ship_to_contact_id.value=="null" || document.MYFORM.ship_to_contact_id.value=="")
	{
		alert("Ship To Contact不可空白!!");
		return false;
	}	
	for (var i = 1 ; i <= document.getElementsByName("no").length ; i++)
	{
		if (document.MYFORM.elements("LineType"+i).value =="--" || document.MYFORM.elements("LineType"+i).value ==null)
		{
			document.MYFORM.elements("LineType"+i).style.backgroundColor="#FF87A9";
			alert("Line"+i+":Line Type不可空白!!");
			return false;
		}
		if (document.MYFORM.elements("INVENTORY_ITEM_ID"+i).value =="null" || document.MYFORM.elements("INVENTORY_ITEM_ID"+i).value=="" || document.MYFORM.elements("INVENTORY_ITEM_ID"+i).value ==null)
		{
			document.MYFORM.elements("INVENTORY_ITEM"+i).style.backgroundColor="#FF87A9";
			alert("Line"+i+":台半料號不可空白!!");
			return false;
		}
	}
    document.MYFORM.complete.disabled=true;
	//add by Peggy 20120621
	document.getElementById("alpha").style.width="100%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';	
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function subWindowShipToContactFind(ID,customerNumber,customerName)
{    
	subWin=window.open("../jsp/subwindow/TscShipToContact.jsp?ID="+ID+"&CUSTOMERNUMBER="+customerNumber+"&CUSTOMERNAME="+customerName,"subwin","width=450,height=200,scrollbars=yes,menubar=no"); 
}
function subWindowTaxCodeFind()
{	    
	subWin=window.open("../jsp/subwindow/TSDRQTaxCodeFind.jsp","subwin","width=500,height=480,scrollbars=yes,menubar=no");  
} 

</script>
<%
String status = "next";
int i= 0;

if(u_Site_Use_ID!=null && u_Use_Code!=null)
{ 
	try
	{
//		String sql = "update  TSC_OE_AUTO_HEADERS  set "+u_Update_Field+"=?,ship_to_contact_id=?,PAYTERM_ID=NVL(?,PAYTERM_ID),PRICE_LIST=nvl(?,PRICE_LIST),currency=decode('"+u_Use_Code+"','BILL_TO',nvl(?,currency),currency) where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		String sql = "update  TSC_OE_AUTO_HEADERS  set "+u_Update_Field+"=?,PAYTERM_ID=NVL(?,PAYTERM_ID),PRICE_LIST=nvl(?,PRICE_LIST),currency=decode('"+u_Use_Code+"','BILL_TO',nvl(?,currency),currency),tax_code=decode('"+u_Use_Code+"','SHIP_TO',nvl(?,NVL(tax_code,'')),tax_code) where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(u_Site_Use_ID));        
		//pstmt.setString(2,""); //20121205 add by Peggy
		pstmt.setString(2,u_payment_id);   //20130412 add by Peggy 
		pstmt.setString(3,(u_pricelist==null || u_pricelist.equals("null")?"":u_pricelist));  //20130412 add by Peggy 
		pstmt.setString(4,(u_currency==null || u_currency.equals("null")?"":u_currency));     //20130516 add by Peggy 
		pstmt.setString(5,(u_tax_code==null || u_tax_code.equals("null")?"":u_tax_code));     //20131118 add by Peggy 
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID));
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error1:"+e.toString()+"</font>");
	}
} 
 
if (c_Cust_Account_ID!=null   &&  c_Customer_Name!=null  && c_Party_Number!=null && c_Payterm_ID!=null && c_BillToID!=null)
{ 
	try
	{
		//out.println("c_Customer_Name="+c_Customer_Name);
		String sql = "update  TSC_OE_AUTO_HEADERS  set CUSTOMERNAME=?, CUSTOMERID=? , CUSTOMERNUMBER=? , BILLTOID = ? ,PAYTERM_ID=? ,CURRENCY=? , PRICE_LIST=? ,SHIPTOID=? ,TAX_CODE=? where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,c_Customer_Name.replaceAll("FUCK","&"));   
		pstmt.setInt(2,Integer.parseInt(c_Party_Number));   
		pstmt.setInt(3,Integer.parseInt(c_Cust_Account_ID));
		pstmt.setInt(4,Integer.parseInt(c_BillToID));   
		pstmt.setInt(5,Integer.parseInt(c_Payterm_ID));     
		pstmt.setString(6,c_Currency_Code);  
		pstmt.setString(7,c_Price_List_ID);  
		pstmt.setString(8,c_ShipToID); //20110323 add by Peggychen
		//pstmt.setString(9,""); //20121204 add by Peggy
		pstmt.setString(9,c_tax_code); //20131118 add by Peggychen
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error2:"+e.toString()+"</font>");
	}	
	
	try
	{
		String sql = " UPDATE tsc_oe_auto_lines a "+
			  " SET ( inventory_item_id, inventory_item,item_identifier_type,CUSTOMERPRODUCT_ID) ="+
			  " (select  inventory_item_id, inventory_item,item_identifier_type,ITEM_ID "+
			  " from (SELECT item,item_description, inventory_item_id, inventory_item,"+
			  " item_identifier_type, item_id, row_number() over (partition by item order by rank) as row_num"+
			  " FROM oe_items_v b "+
			  " WHERE b.sold_to_org_id = '" + c_Cust_Account_ID+"'"+
			  " and CROSS_REF_STATUS <>'INACTIVE' and ITEM_STATUS <>'INACTIVE'  ORDER BY RANK) b"+
			  " where  b.item =  a.customerproductnumber"+
			  " and nvl2(a.orig_item_description,b.item_description,1) = nvl(a.orig_item_description,1)"+
			  " ) WHERE  exists (select 1 from tsc_oe_auto_headers x where x.packinglistnumber = '"+keyID+"' and x.status='"+q_status+"' and x.packinglistnumber=a.packinglistnumber and x.customerpo=a.customerpo)"+
			  " and nvl(a.inventory_item_id,0) <> nvl(a.CUSTOMERPRODUCT_ID,0)";
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID));
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error3:"+e.toString()+"</font>");
	}
}  
if (line_no!=null && lineType !=null && !lineType.equals("--"))
{ 
	try
	{
		String sql = "update  TSC_OE_AUTO_LINES  set LINE_TYPE=? where ID='"+keyCode+"' and LINE_NO='"+line_no+"' ";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(lineType));   
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID));
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error4:"+e.toString()+"</font>");
	}
}
  
if (p_inventory_Item_ID!=null  && p_line_no!=null && p_inventory_Item!=null  && p_Item_Identifier!=null)
{ 
	try
	{
		String sql = "update  TSC_OE_AUTO_LINES  set INVENTORY_ITEM_ID=?, INVENTORY_ITEM=? , ITEM_IDENTIFIER_TYPE =?,CUSTOMERPRODUCT_ID=?  where ID='"+keyCode+"' and LINE_NO='"+p_line_no+"' ";																		
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);   
 		//out.println(p_Item_ID);
		pstmt.setInt(1,Integer.parseInt(p_inventory_Item_ID));  // Line Type
		pstmt.setString(2,p_inventory_Item);
		pstmt.setString(3,p_Item_Identifier);
		pstmt.setString(4,p_Item_ID); //add by Peggy 20121120
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(Exception e)
	{
		out.println("<font color='red'>Error5:"+e.toString()+"</font>");
	}
} 

if (p_List_Header_ID!=null && p_Currency_Code!=null )
{ 
	try
	{
		String sql = "update  TSC_OE_AUTO_Headers  set PRICE_LIST=? ,CURRENCY=?  where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(p_List_Header_ID));  // Line Type
		pstmt.setString(2,p_Currency_Code);
		pstmt.executeUpdate(); 
		pstmt.close();
		//response.sendRedirect("Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID));
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error6:"+e.toString()+"</font>");
	}
} 
if (p_ship_to_contact_id != null)
{
	try
	{
		String sql = "update  TSC_OE_AUTO_Headers  set ship_to_contact_id=?  where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		//out.println(sql);
		//out.println(p_ship_to_contact_id);
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setInt(1,Integer.parseInt(p_ship_to_contact_id));  // p_ship_to_contact_id
		pstmt.executeUpdate(); 
		pstmt.close();
	}
	catch(SQLException e)
	{
		out.println("<font color='red'>Error7:"+e.toString()+"</font>");
	}
}
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" action="../jsp/Tsc1211ConfirmDetailList.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">訂單生成中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<%
try
{
	sSql="select CUSTOMERID,CUSTOMERPO,CUSTOMERNAME, SHIPMENTTERMS,PACKINGLISTNUMBER, order_number , PRICE_LIST,PAYTERM_ID, "+
		  " C_DATE,SALESPERSON,CREATED_BY,CREATION_DATE , SHIPTOID ,BILLTOID,CURRENCY ,CUSTOMERNUMBER, ORDER_TYPE_ID,STATUS, ID,ship_to_contact_id " + 
		  ",(select DISTINCT tsce_packinglist_pkg.CHANGE_TO_ERP_TAX(TAX_CODE) from tsc_packinglist_data x where x.CUSTOMERPO||x.PACKINGLISTNUMBER=a.id) erp_tax_code"+ //add by Peggy 20200702
		  " from   TSC_OE_AUTO_HEADERS a  WHERE PACKINGLISTNUMBER = '"+keyID+"' AND STATUS='"+q_status+"'";//modify by Peggy 20120927
	//out.println(sSql);
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sSql);
	while(rs.next())
	{
		customerID = rs.getString("CUSTOMERID");
		customerPO = rs.getString("CUSTOMERPO");
		customerName = rs.getString("CUSTOMERNAME") ;
		customerNumber = rs.getString("CUSTOMERNUMBER") ;
		packing_List_Number = rs.getString("PACKINGLISTNUMBER");
		if (packing_List_Number==null) packing_List_Number="";
		order_Type_ID = rs.getString("ORDER_TYPE_ID");
		c_Date = rs.getString("C_DATE");
		salesPerson = rs.getString("SALESPERSON");
		created_By = rs.getString("CREATED_BY");
		creation_Date = rs.getString("CREATION_DATE");
		shipToID = rs.getString("SHIPTOID");
		if (shipToID==null) shipToID ="";  //add by Peggy 20130516
		billToID = rs.getString("BILLTOID");
		if (billToID==null) billToID ="";
		shipment_Term =rs.getString("SHIPMENTTERMS");
		currency =rs.getString("currency"); 
		if (currency==null) currency="";
		payterm_ID = rs.getString("PAYTERM_ID");
		price_List_id = rs.getString("PRICE_LIST");
		if (price_List_id==null) price_List_id ="";
		q_status=rs.getString("STATUS");
		orderNo = rs.getString("ORDER_NUMBER");
		ship_to_contact_id = rs.getString("ship_to_contact_id");
		if (ship_to_contact_id==null) ship_to_contact_id="";
		bill_curr="";
		TAXCODE = rs.getString("ERP_TAX_CODE"); //add by Peggy 20200702
		if (TAXCODE==null) TAXCODE="";
		
		//add by Peggy 20121204
		Statement statementx=con.createStatement();
		String sqlx = " select distinct rownum,su.site_use_id, LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
                      //" from ar_contacts_v con,hz_cust_site_uses su,HZ_CUST_SITE_USES_ALL hcsu "+
					  " from ar_contacts_v con,hz_cust_site_uses_all su "+
                      " where  con.customer_id ='"+customerNumber+"'"+
                      " and con.status='A'"+
			          " AND con.address_id=su.cust_acct_site_id"+
				      " AND su.site_use_code='SHIP_TO'"+
					  " AND su.site_use_id = '"+shipToID+"'"; //modify by Peggy 20131118,依ship to 地址的ship to contact顯示,未設定者,顯示空白
					  //" AND hcsu.CUST_ACCT_SITE_ID =con.address_id(+)"+
                      //" AND hcsu.SITE_USE_ID='"+shipToID+"'";
		if (ship_to_contact_id  != null && !ship_to_contact_id.equals(""))
		{
			sqlx += " and con.contact_id ='" +ship_to_contact_id +"'";
		}
		sqlx += " order by 1 desc"; //add by Peggy 20150601
		//sqlx +=	 " order by decode(su.site_use_id,"+shipToID+",1,2),LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE)";
		//sqlx += " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+customerName+"',1,2)";
		//out.println(sqlx);
		ResultSet rsx=statementx.executeQuery(sqlx);	  			  				     
		if (rsx.next())
		{
			if (rsx.getString("ROWNUM").equals("1") || (ship_to_contact_id  != null && !ship_to_contact_id.equals("")))  //ship to contact有多筆時,不帶預設值,add by Peggy 20150601
			{
				ship_to_contact = rsx.getString("contact_name");
				ship_to_contact_id = rsx.getString("contact_id");
			}
			else
			{
				ship_to_contact = "";
				ship_to_contact_id = "";
			}
		} 
		else
		{
			ship_to_contact = "";
			ship_to_contact_id = "";
		}		 
		rsx.close();
		statementx.close();       

		//add by Peggy 20131118
		//依歐洲的稅別為主,user可手動改,add by Peggy 20200702
		/*String sql = " select a.TAX_CODE"+ 
		 " from AR_SITE_USES_V a,AR_ADDRESSES_V b"+
		 " where a.ADDRESS_ID = b.ADDRESS_ID "+
		 " and a.STATUS=b.STATUS and a.STATUS='A'"+
		 " and b.ORG_ID = '41' "+
		 " and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL  WHERE CUST_ACCOUNT_ID='"+customerNumber+"') "+
		 " and a.SITE_USE_CODE = 'DELIVER_TO'"+
		 " and b.ADDRESS1 = (SELECT y.ADDRESS1 from AR_SITE_USES_V x,AR_ADDRESSES_V y where x.ADDRESS_ID = y.ADDRESS_ID "+
		 " and x.STATUS=y.STATUS and x.STATUS='A'"+
		 " and y.ORG_ID = '41' and x.SITE_USE_ID ='"+shipToID +"')";
		//out.println(sql);
		Statement statement1=con.createStatement();
		ResultSet rs1=statement1.executeQuery(sql);	
		if(rs1.next())
		{
			TAXCODE=rs1.getString("TAX_CODE");
			if (TAXCODE==null) TAXCODE="";
		}
		else
		{
			TAXCODE="";
		}
		rs1.close();
		statement1.close();*/
		
		//sql = "update  TSC_OE_AUTO_HEADERS  set SHIP_TO_CONTACT_ID=?,tax_code=? where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		////out.println(sql);
		//PreparedStatement pstmt=con.prepareStatement(sql);            
		//pstmt.setString(1,ship_to_contact_id);   
		//pstmt.setString(2,TAXCODE);   //add by Peggy 20131118
		//pstmt.executeUpdate(); 
		//pstmt.close();
		
		/*sql = "update  TSC_OE_AUTO_HEADERS  set tax_code=? where packinglistnumber='"+keyID+"' and status='"+q_status+"'";
		//out.println(sql);
		PreparedStatement pstmt=con.prepareStatement(sql);            
		pstmt.setString(1,TAXCODE);   //add by Peggy 20131118
		pstmt.executeUpdate(); 
		pstmt.close();
		*/
	} 
}
catch(SQLException e)
{
	out.println(e.toString());
}

String sql2="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt2=con.prepareStatement(sql2);
pstmt2.executeUpdate(); 
pstmt2.close();
%>
<p>
  <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</p>
<font size="+3" color="#66CC33" face="Arial Black">TSC</font><font color="#000000" size="+2" face="Times New Roman"> <strong> Order Temp Confirm Interface</strong></font><br>
<A HREF="Tsc1211ConfirmList.jsp"><font size="2">回上一頁</font></A>
<table cellspacing="0" bordercolordark="#92D08A" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
	<tr>
    	<td colspan="4" bgcolor="#92D08A"><font style='font-size:12px;font-family:arial'>訂單轉入資訊:</FONT></td>
   	</tr>
  	<tr>
    	<td bgcolor="#CCFFCC" width="15%"><font style='font-size:12px;font-family:arial'>Customer Name:</font></td>
    	<td align="left" width="45%">
<%
	if(!q_status.equals("CLOSED"))
	{
		out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowCustomerFind("+'"'+java.net.URLEncoder.encode(packing_List_Number)+'"'+")'>");
	}
		
	try
	{
		Statement statement=con.createStatement();
		String custname_sql = "select party_name,party_number,party_id from  hz_parties where party_number ='"+customerID+"'";
		ResultSet rs=statement.executeQuery(custname_sql);	  			  				     
		while (rs.next())
		{
			ts_customer_Name = rs.getString("PARTY_NAME");
			partyID = rs.getString("party_id");
			out.println("<input align='left' type='text' name='customer_Name' size='70' maxlength='15' style='border:none;font-size:14px;font-family:arial' value='"+ts_customer_Name+"' readonly>");
		}         
	}
	catch(Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	}    
%>
		</td>
    	<td bgcolor="#CCFFCC" width="15%"><font style='font-size:12px;font-family:arial'>Ship To Contact:</font></td>
    	<td width="25%"><input type="button" name="btn1" value="..." onClick='subWindowShipToContactFind("<%=packing_List_Number%>","<%=customerNumber%>","<%=ts_customer_Name%>")'><input type="text" name="ship_to_contact"  size="35" style="color:#FF0066;font-stretch:extra-expanded;font-family:arial;border:none;font-size:14px" <% if(ship_to_contact.equals("")) out.println("style='background-color:#FFFF66'");%> value="<%=ship_to_contact%>" readonly><input type="hidden" name="ship_to_contact_id" value="<%=ship_to_contact_id%>"></td>
  	</tr>
  	<tr>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Order Type:</font></td>
    	<td><input type="hidden" name="TRANSACTION_TYPE_CODE"   value='<%=order_Type_ID%>' size="6" readonly="">
        <font style='font-size:14px;font-family:arial'><%out.println("1211(TSC Consignment Order)");%></font></td>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Packing List#:</font></td>
    	<td><input align='left' type='text' name='packing_List_Number' size='15'  style="color:#0033FF;font-stretch:extra-expanded;border:none;font-family:arial;font-size:14px"  maxlength="15" value="<%=packing_List_Number%>" readonly></td>
  	</tr>
  	<tr>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Payment Term:</font></td>
    	<td><input type="hidden" name="PAYTERMID" value="<%=payterm_ID%>">
<% 
	try
	{
		if ( payterm_ID != null && !payterm_ID.equals(""))
		{
			Statement statement=con.createStatement();
			ResultSet rs=null;	
			String pay_sql = "select NAME from RA_TERMS_VL  where term_id='"+payterm_ID+"'";
			rs=statement.executeQuery(pay_sql);	  			  				     
			while (rs.next())
			{
				out.println("<input align='left' type='text' name='payterm' size='30' maxlength='15' style='border:none;font-size:14px;font-family:arial' value='"+rs.getString("name")+"' readonly>"); 
			}         
		}
	}
	catch(Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	}    
%>
    </font> 
		</td>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Price List</font></td>
       	<td><font style='font-size:14px;font-family:arial'><input type="hidden" name="PRICELISTID"  value="<%=price_List_id%>">
<%		
	if(q_status!="CLOSED" && !q_status.equals("CLOSED"))
	{
	  	out.println("<INPUT TYPE='button'  value='...'  onClick='subWindowPriceListFind("+'"'+java.net.URLEncoder.encode(packing_List_Number)+'"'+","+'"'+java.net.URLEncoder.encode(currency)+'"'+")'>");
	} 
	
	try
	{   
		Statement statement=con.createStatement();
        ResultSet rs=null;		      
		String sql = "select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
			         "from qp_list_headers_v "+
			         "where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' and LIST_HEADER_ID='"+price_List_id+"'"; 					   
        rs=statement.executeQuery(sql);
       	while (rs.next())
		{ 
			out.println(rs.getString("LIST_CODE"));           
		} //end of while
	}
	catch (Exception e) 
	{ 
		out.println("Exception:m"+e.getMessage()); 
	}  
%>		  
		   </font>
		</td>
	</tr>
<%			     
	try
	{  // 取預設選擇客戶的Ship To Address 及 Bill To Address 
		Statement statement=con.createStatement();
        ResultSet rs=null;	
	 	String sql = " select a.STATUS,a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,loc.ADDRESS2,loc.ADDRESS3,loc.ADDRESS4  "+ 
		             ",d.CURRENCY_CODE"+ //add by Peggy 20141014
					 " from AR_SITE_USES_V a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc"+
					 ",SO_PRICE_LISTS d"+ //add by Peggy 20141014
					 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
                     " AND b.party_site_id = party_site.party_site_id"+
                     " AND loc.location_id = party_site.location_id "+
					 " and a.STATUS='A' "+
					 " and b.CUST_ACCOUNT_ID='"+customerNumber+"'"+
					 " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+ //add by Peggy 20141014
				 	 " and (a.SITE_USE_ID = '"+shipToID+"' or  a.SITE_USE_ID = '"+billToID+"' )"+
					 " order by decode(a.SITE_USE_CODE ,'BILL_TO',1,2)";
		//out.println(sql);
      	rs=statement.executeQuery(sql);	  			  				     
       	while (rs.next())
		{            		             
			if (rs.getString("SITE_USE_CODE")=="SHIP_TO" || rs.getString("SITE_USE_CODE").equals("SHIP_TO"))
			{ 
				shipTo_Street  = rs.getString("ADDRESS1"); 
				shipTo_Country = rs.getString("COUNTRY"); 
				if (bill_curr.equals("")) bill_curr=rs.getString("CURRENCY_CODE");   //add by Peggy 20141014
			}
			else if (rs.getString("SITE_USE_CODE")=="BILL_TO" || rs.getString("SITE_USE_CODE").equals("BILL_TO"))
			{  
				//billTo=rs.getString("SITE_USE_ID");
				billTo_Street=rs.getString("ADDRESS1"); 
				billTo_County=rs.getString("COUNTRY"); 
				if (bill_curr.equals("")) bill_curr=rs.getString("CURRENCY_CODE");   //add by Peggy 20141014 
			}
		} 
        rs.close();   
	    statement.close();  
		
		//1211六月發票要維持VAT 19% from emily 20200629
		//依歐洲的稅別為主,user可手動改,add by Peggy 20200702
		/*if (Long.parseLong(dateBean.getYearMonthDay())>=20200701)
		{
			if (shipTo_Street.toUpperCase().indexOf("GERMANY")>0 && !TAXCODE.equals("Vat 16%(For EU denote)") && (!shipment_Term.substring(1,2).equals("EX") && !shipment_Term.substring(1,3).equals("FOB")))
			{
				taxcode_err="Warnning:TAX must be Vat 19%(For EU denote)";
			}
			else
			{
				taxcode_err="";
			}
		}
		else
		{
			if (shipTo_Street.toUpperCase().indexOf("GERMANY")>0 && !TAXCODE.equals("Vat 19%(For EU denote)") && (!shipment_Term.substring(1,2).equals("EX") && !shipment_Term.substring(1,3).equals("FOB")))
			{
				TAXCODE="Vat 19%(For EU denote)";
				taxcode_err="";
			}
			else
			{
				taxcode_err="";
			}
		}*/
	}
	catch (Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	}    
	%>	      		   
  	<tr>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Shipping Term:</font></td>
    	<td><input align='left' type='text' name='shipment_Term' size='15' maxlength='15' style="border:none;font-family:arial;font-size:14px" value='<%=shipment_Term%>' readonly>
    	</font></td>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Currency:</font></td>
    	<td><font style='font-size:12px;font-family:arial'><input align='left' type='text' name='currency' size='10' maxlength='15'  style="border:none;font-family:arial;font-size:14px" value='<%=currency%>' readonly>
		</font></td>
  	</tr>
  	<tr>
    	<td bgcolor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Tax Code:</font></td>
    	<td><input align='left' type='text' name='TAXCODE' size='20' maxlength='30' style="border:none;font-family:arial;font-size:14px" <% if(TAXCODE.equals("")) out.println("style='background-color:#FFFF66'");%> value='<%=TAXCODE%>' readonly>
		<%
		//if (!taxcode_err.equals(""))
		//{
		%>
			<INPUT TYPE='button'  value='...' onClick='subWindowTaxCodeFind()'>
		<%
		//}
		%>
		<div style="color:#ff0000;font-size:12px;font-family:arial"><%=taxcode_err%></div></td>
		<td colspan="2">&nbsp;
    	</td>
  	</tr>
  	<tr>
 		<td bgColor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Ship-To Address:</font></td>
		<td colspan="3">
		<input type="text" size="10" style="font-family:ARIAL;font-size:14px" name="SHIPTOORG" value="<%=shipToID%>" readonly>		
		<%
		if(!q_status.equals("CLOSED"))
		{
		%>
		<INPUT TYPE="button"  value="..." onClick='subWindowShipToFind("<%=packing_List_Number%>","<%=customerNumber%>")'>
		<%
		}
		%>
   		<INPUT TYPE="text" NAME="SHIPADDRESS" SIZE=135  style="font-family:ARIAL;font-size:14px" value="<%=shipTo_Street%>" readonly> 
		<INPUT TYPE="text" NAME="SHIPCOUNTRY" SIZE=5  style="font-family:ARIAL;font-size:14px" value="<%=shipTo_Country%>" readonly> 
		   </font>		   
		</td> 	
	</tr>
	<tr>
		<td bgColor="#CCFFCC"><font style='font-size:12px;font-family:arial'>Bill-To Address:</font></td>
		<td colspan="3">		         		  
	<input type="text" size="10" name="BILLTO" style="font-family:ARIAL;font-size:14px" value="<%=billToID%>" readonly>
	<%
	if(!q_status.equals("CLOSED"))
	{
	%>
	<INPUT TYPE="button"  value="..." onClick='subWindowBillToFind("<%=packing_List_Number%>","<%=customerNumber%>")'>	
	<%
	}
	%>	
	<INPUT TYPE="text" NAME="BILLADDRESS" SIZE=135 style="font-family:ARIAL;font-size:14px" value="<%=billTo_Street%>" readonly border="0"> 
	<INPUT TYPE="text" NAME="BILLCOUNTRY" SIZE=5 style="font-family:ARIAL;font-size:14px" value="<%=billTo_County%>" readonly border="0">   
		   </font>		   
		</td>
	</tr>
	<tr>
		<td colspan="4">
			<table cellspacing="0" bordercolordark="#FFffff"  cellpadding="1" width="100%" align="center" bordercolorlight="#92D08A" border="1">
  				<tr>
    				<td colspan="14"  bgcolor="#92D08A" ><font style="font-size:12px;font-family:arial">處理內容明細 :</font></span></td>
    			</tr>
  				<tr>
					<td width="3%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">LineNo</font></td>
					<td width="10%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Customer PO#</font></td>
					<td width="12%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">TSC P/N</font></td>
					<td width="10%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Customer P/N</font></td>
					<td width="16%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">TSC Item</font></td>
					<td width="6%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Q'ty</font></td>
					<td width="4%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">UOM</font></td>
					<td width="6%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Selling Price</font></td>
					<td width="6%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Amount</font></td>
					<td width="6%"  bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Carton Number</font></td>
					<td width="10%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Awb</font></td>
					<td width="10%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Invoice#</font></td>
					<td width="10%" bgcolor="#66CC99" align="center"><font style="font-size:12px;font-family:arial">Line Type</font></td>
			  	</tr>
<%
	try
	{
		Statement st1=con.createStatement();
		ResultSet rs1=null;
		String strCustPO="",txtColor="";
		//String	sql = " select * from TSC_OE_AUTO_LINES  where id = '"+keyID+"' order by LINE_NO ASC" ; 
		String sql = " select (select count(1) from TSC_OE_AUTO_LINES d where d.id = a.id) rowcnt,a.* ,(a.QUANTITY* a.SELLING_PRICE) totamount from TSC_OE_AUTO_LINES a where exists (select 1 from TSC_OE_AUTO_HEADERS b "+
                     " WHERE EXISTS (SELECT 1 FROM TSC_OE_AUTO_HEADERS c  where c.packinglistnumber = '"+keyID+"' and c.packinglistnumber=b.packinglistnumber and c.customerpo=b.customerpo";
		if (ORDERNUM != null && !ORDERNUM.equals("")  && !ORDERNUM.equals("null")) sql += " and c.ORDER_NUMBER ='" + ORDERNUM+"'";
        sql += ") AND b.ID=a.ID  and b.status='"+q_status+"') order by a.customerpo,a.SHIPPING_INSTRUCTIONS,a.CARTONNUMBER";
		//out.println(sql);
		rs1=st1.executeQuery(sql);
		while(rs1.next())
		{
			i++;
			customerPO =rs1.getString("CUSTOMERPO");
			line_no =rs1.getString("LINE_NO");
			item_Description =rs1.getString("ITEM_DESCRIPTION");
			quantity =rs1.getInt("QUANTITY");
			selling_Price =rs1.getFloat("SELLING_PRICE");
			amount = rs1.getFloat("totamount") ;
			totamount += amount;
			line_Type=rs1.getString("LINE_TYPE");
 			cartonNumber =rs1.getString("CARTONNUMBER"); 
			awb  =rs1.getString("AWB"); 
			invoiceNumber= rs1.getString("SHIPPING_INSTRUCTIONS"); 
			customerProductNumber= rs1.getString("CUSTOMERPRODUCTNUMBER");
			inventory_Item= rs1.getString("INVENTORY_ITEM");
			keyCode=rs1.getString("ID"); //add by Peggy 20120927
			out.println("<tr>");
			out.println("<td><div id='no' align='center'><font style='font-size:12px;font-family:arial'>"+i+"</div></font>");
			out.println("<input type='hidden' name='ID"+i+"' value='"+keyCode+"'>");
			out.println("<input type='hidden' name='LINENO"+i+"' value='"+line_no+"'>");
			out.println("</td>");
			if (!strCustPO.equals(customerPO))
			{
				out.println("<td rowspan='"+rs1.getString("rowcnt")+"'><font style='font-size:12px;font-family:arial'>"+customerPO+"</font></td>");
				strCustPO=customerPO;
			}
			out.println("<td><div id='ITEM_DESCRIPTION"+i+"' align='left'><font style='font-size:12px;font-family:arial'>"+item_Description+"</font></div></td>");
			out.println("<td><div id='CUSTOMER_NUMBER"+i+"' align='left'><font style='font-size:12px;font-family:arial'>"+customerProductNumber+"</font></div></td>");
			out.println("<td>");
			if (inventory_Item ==null) txtColor="background-color:#FF87A9"; else  txtColor="";
			out.println("<input type='text' name='INVENTORY_ITEM"+i+"' value='"+(inventory_Item==null?"&nbsp;":inventory_Item)+"' style='border:none;font-size:12px;font-family:arial;"+txtColor+"' size='26' readonly>");
			if (inventory_Item==null || inventory_Item.equals(""))
			{
				//out.println("<INPUT TYPE='button'  name='btn"+i+"' style='border:groove;background-color:#ffdd11;height:20;width:20' value='..' onClick='subWindowProductFind("+'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+","+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(keyCode)+'"'+","+'"'+java.net.URLEncoder.encode(line_no)+'"'+","+'"'+java.net.URLEncoder.encode(customerNumber)+'"'+","+'"'+java.net.URLEncoder.encode(item_Description)+'"'+")'>");
				out.println("<INPUT TYPE='button'  name='btn"+i+"' style='border:groove;background-color:#ffdd11;height:20;width:20' value='..' onClick='subWindowProductFind("+'"'+java.net.URLEncoder.encode(customerProductNumber)+'"'+","+'"'+java.net.URLEncoder.encode(keyID)+'"'+","+'"'+java.net.URLEncoder.encode(keyCode)+'"'+","+'"'+java.net.URLEncoder.encode(line_no)+'"'+","+'"'+java.net.URLEncoder.encode(customerNumber)+'"'+","+'"'+java.net.URLEncoder.encode(item_Description)+'"'+","+'"'+java.net.URLEncoder.encode(cartonNumber)+'"'+","+'"'+java.net.URLEncoder.encode(invoiceNumber)+'"'+")'>");
			}
			out.println("<input type='hidden' name='INVENTORY_ITEM_ID"+i+"' value='"+rs1.getString("INVENTORY_ITEM_ID")+"'></td>");
			out.println("<td><div id='QUANTITY"+i+"' align='right'><font style='font-size:12px;font-family:arial'>"+quantity+"&nbsp;</font></div></td>");
			out.println("<td><div id='UOM"+i+"' align='center'><font style='font-size:12px;font-family:arial'>PCE</font></div></td>");
			out.println("<td><div id='SELLINGPRICE"+i+"' align='right'><font style='font-size:12px;font-family:arial'>"+selling_Price+"&nbsp;</font></div></td>");
			out.println("<td><div align='right'><font style='font-size:12px;font-family:arial'>"+amount+"&nbsp;</font></div></td>");
			out.println("<td><div align='left'><font style='font-size:12px;font-family:arial'>"+cartonNumber+"&nbsp;</font></div></td>");
			out.println("<td><div align='left'><font style='font-size:12px;font-family:arial'>"+awb+"</font></div></td>");
			out.println("<td><div align='center'><font style='font-size:12px;font-family:arial'>"+invoiceNumber+"</font></div></td>");
			out.println("<td><font style='font-size:12px;font-family:arial'>");
			try
			{ 
				Statement statement1=con.createStatement();
				String sql1 = " select wf.LINE_TYPE_ID, wf.LINE_TYPE_ID ||'(' || vl.name ||')' as LINE_TYPE"+
                              " from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl "+
                              " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
                              " and vl.language = 'US'  and to_char(ORDER_TYPE_ID) = '1091' and END_DATE_ACTIVE is NULL ";
				ResultSet rs2=statement1.executeQuery(sql1);
				comboBoxBean.setRs(rs2);
				comboBoxBean.setSelection(line_Type);
				comboBoxBean.setFieldName("LineType"+i);
				comboBoxBean.setFontName("Arial");	   
				comboBoxBean.setOnChangeJS("setSubmit2("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+keyID+"&keyCode="+keyCode+'"'+","+'"'+line_no+'"'+","+'"'+ i +'"'+")");
				out.println(comboBoxBean.getRsString());
				rs2.close();   
				statement1.close();   
			}
			catch (Exception e) 
			{ 
				out.println("Exception:a"+e.getMessage()); 
			} 
			out.println("</font></td></tr>"); 
		}
		rs1.close();   
		st1.close(); 
	}
	catch (Exception e) 
	{ 
		out.println("Exception:9"+e.getMessage()); 
	} 
%>
				<tr>
    				<td colspan="9" align="right" bgcolor="#ffffff" style="border-right-color:#FFFFFF;font-size:12px;font-family:arial">Total:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=totamount%>&nbsp;</td>
    				<td colspan="5" align="left"  bgcolor="#ffffff" style="font-size:12px;font-family:arial">&nbsp;</td>
				</tr>
				<tr>
    				<td colspan="14"  bgcolor="#92D08A" >&nbsp;</td>
  </tr>
</table>
</td>
</tr>
</table>
<table cellspacing="0" bordercolordark="#92D08A"  cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  <tr>
    <td width="21%" bgcolor="#CCFFCC"><div align="center"><font style="font-size:12px;font-family:arial">Sales Name</font></div></td>
    <td width="26%" bgcolor="#CCFFCC"><div align="center"><font style="font-size:12px;font-family:arial">Created_Date</font></div></td>
    <td width="24%" bgcolor="#CCFFCC"><div align="center"><font style="font-size:12px;font-family:arial">Created_By</font></div></td>
    <td width="29%" bgcolor="#CCFFCC"><div align="center"><font style="font-size:12px;font-family:arial">
	<%
	if((status == "next" || status.equals("next")) && (q_status=="OPEN" || q_status.equals("OPEN")))
	{
		out.println("&nbsp;");
	}
	else
	{
		out.println("ERP訂單號碼");
	}
	%>
	</font></div></td>
  </tr>
  <tr>
    <td><div align="center"><font style="font-size:12px;font-family:arial"><%=salesPerson%></font></div></td>
    <td><div align="center"><font style="font-size:12px;font-family:arial"><%=creation_Date%></font></div></td>
    <td><div align="center"><font style="font-size:12px;font-family:arial"><%=created_By%></font></div></td>
    <td>
      <div align="center">
	  
<%   
  	//小S 在 2/24 提出要在CALL API 完成後帶出 CUSTOMER NUMBER 
	try
	{ 
		Statement statement=con.createStatement();
		ResultSet rs=null;	
		String sql_cust = " SELECT cust.ACCOUNT_NUMBER customer_number "+
                          " FROM hz_cust_accounts cust, hz_parties party"+
  		   			      " WHERE cust.party_id = party.party_id"+
						  " AND party.PARTY_NUMBER = '"+customerID+"'"+
						  " AND CUST.STATUS='A'"; //add by Peggy 20160725
		rs=statement.executeQuery(sql_cust);
   		while(rs.next())
		{
			out.println("<input type='HIDDEN' name='CUSTOMER_NUMBER' size='15' maxlength='15' value='"+rs.getString("CUSTOMER_NUMBER")+"' readonly> ");
		}
		rs.close();   
		statement.close();   
	}
	catch (Exception e) 
	{ 
		out.println("Exception:a"+e.getMessage()); 
	} 

	if (!currency.equals(bill_curr)) //add by Peggy 20141014
	{
		out.println("<font style='font-family:arial;color:#FF0000;font-size:14px;font-weight:bold;'>幣別不符,請重新確認,謝謝!</font>");
	}
  	else if((status == "next" || status.equals("next")) && (q_status=="OPEN" || q_status.equals("OPEN")))
	{
		out.println("<input type='button' name='complete' style='font-family:arial;font-size:12px' value='Complete' onClick='setCreate("+'"'+"../jsp/Tsc1211CallAPI.jsp?ID="+java.net.URLEncoder.encode(keyID)+"&status="+"process"+"&customerID="+customerID+'"'+")'>");
	}
	else
	{
		out.println("<font style='font-family:arial;color:#0000FF;font-size:16px;font-weight:bold;'>"+orderNo+"</font>");
	}
%>
	  </div></td>													 
  </tr>
  <tr>
    <td colspan="4"  bgcolor="#CCFFCC" >&nbsp;</td>
  </tr>
</table>
<input type="hidden" name="maxLine" value="<%=i%>">
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
