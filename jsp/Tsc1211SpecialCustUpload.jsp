<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page errorPage="ExceptionHandler.jsp"%>

<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>DELTA 1211 Order Import</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />

<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setCreate(URL)
{  
    document.form1.submit1.disabled=true;
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:Arial; font-size:12px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:left;}
 .style3   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Arial; font-size:12px; color: #000000; text-align:center}
 .style5   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style6   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:center;}
 .style7   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style8   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:center;}
 .style9   {font-family:Arial; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style10  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#0000FF; text-align:center;}
 .style11  {font-family:Arial; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:center;}
 .style12  {font-family:Arial; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:right;}
 .style13  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:left;}
 .style14  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:center;}
 .style15  {font-family:標楷體; font-size:16px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 .style16  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style17  {font-family:標楷體; font-size:16px; background-color:#FFFFFF; color:#FF0000; text-align:LEFT;}
 td {word-break:break-all}
</STYLE>
</head>
<body>
<!--<form name="form1"  ACTION="../jsp/Tsc1211SpecialCustUpload.jsp?PTYPE=1" METHOD="post" ENCTYPE="multipart/form-data">-->
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<p>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> DELTA 1211 Order Import
</strong></font>
<br>
</p>
<%
String PTYPE = request.getParameter("PTYPE");
if (PTYPE == null) PTYPE="0";
StringBuffer sbf_s = new StringBuffer();
StringBuffer sbf_d = new StringBuffer();
StringBuffer allStrErr = new StringBuffer();
boolean isException = false;
String pgmName = "D4010_"; //add by Peggy 20110629

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

if (PTYPE.equals("1"))
{
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	String strDate=dateBean.getYearMonthDay();
	String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	String uploadFile_name=upload_file.getFileName();
	if (uploadFile_name == null || uploadFile_name.equals("") )
	{
		out.println("<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的txt檔或office 2003 excel檔，謝謝!')</script>");
	}
	else if (!(uploadFile_name.toLowerCase()).endsWith("xls") && !(uploadFile_name.toLowerCase()).endsWith("txt"))
	{
		out.println("<script language=javascript>alert('上傳檔案必須為txt檔或office 2003 excel檔!')</script>");
	}
	else
	{
		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+pgmName+strDateTime+"-"+uploadFile_name;
		upload_file.saveAs(uploadFilePath); 
		int Org_ID = 163;
		String Subinventory_Code = "50";
		String Customer_PO = "DELTA";
		String ERP_CUST_NUMBER = "";
		String Customer_ID = "";
		String Customer_Number = "";
		String ShipToID = "";
		String BillToID = "";
		String sql = "";
		StringBuffer strErr = new StringBuffer();
		String ITEM_IDENTIFIER_TYPE = "";
		String ORDER_ITEM_ID = "";
		String ITEM_NAME = "";
		String INV_ITEM_ID = "";
		String Price_List_ID = "";
		String CUSTOMER_NAME = "";
		String Payment_Term_ID = "";
		String KEYNO = "";
		String KEYID = "";
		String SHIPMENTTERMS = "";
		String actionCode = "";
		String Cust_Po_line_Number = "";
		String Unit_Price = "";
		String UOM = "";
		String IssueQty = "";
		String Order_Item = "";
		String Amount = "";
		String Item_Desc = "";
		String Plant_Code = "";
		String Currency = "";
		String stepName = ""; //add by Peggy 20110526
		int ErrorCnt = 0;
		int icnt = 0;   //add by Peggy 20111202
		java.util.Date datetime = new java.util.Date();
		SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
		String CreationDate = (String) formatter.format( datetime );
		StringBuilder sb = new StringBuilder();

		try
		{
			if (uploadFile_name.endsWith("txt"))
			{
				BufferedReader br = new BufferedReader(new FileReader(uploadFilePath));
				boolean b_line= false;
				String str = "";
				while((str = br.readLine()) != null)
				{
					if (str.contains("PLANT CODE.") && (stepName.equals("") || stepName.equals("03")))
					{
						try
						{
							Plant_Code = (str.substring(str.indexOf(":")+1,str.indexOf("REFERENCE"))).trim();
						}
						catch(Exception e){}
						b_line= false;
						stepName  = "01";
					}
					if (str.contains("INVOICE"))
					{
						try
						{
							Cust_Po_line_Number = (str.substring(str.indexOf(":")+1,str.indexOf("MATERIAL"))).trim();
							Order_Item = (str.substring(str.indexOf(":",str.indexOf("MATERIAL"))+1,str.indexOf("-",str.indexOf("MATERIAL")))).trim();
							Item_Desc = (str.substring(str.indexOf("-",str.indexOf("MATERIAL"))+1)).trim();
						}
						catch(Exception e){}				
						b_line= false;
						stepName  = "02";
					}
					if (str.contains("GOODS ISSUE"))
					{
						b_line= true;
						continue;
					}
					if (b_line)
					{
						try
						{
							UOM = (str.substring(str.indexOf("-")+1,str.indexOf("-")+5)).trim();
							Unit_Price = (str.substring(str.indexOf(UOM)+UOM.length(),str.indexOf("-",str.indexOf(UOM)))).trim();
							int iLeng = str.indexOf("-",str.indexOf(Unit_Price)+Unit_Price.length()+1);
							Currency = (str.substring(iLeng+1,iLeng+4)).trim();
							b_line= false;
						}catch(Exception e){}
						
					}
					if (str.contains("TOTAL GI"))
					{
						try
						{
							IssueQty = (str.substring(str.indexOf(":")+1,str.indexOf("-"))).trim();
							Amount = (str.substring(str.indexOf("-")+1,str.indexOf("-",str.indexOf("-")+1))).trim();
						}catch(Exception e){}
						
						//負數數量不做上傳
						if (!IssueQty.startsWith("-"))
						{
							sb.append(Plant_Code+";"+Cust_Po_line_Number+";"+Order_Item+";"+
							Item_Desc+";"+UOM+";"+Unit_Price+";"+Currency+";"+IssueQty+";"+Amount+"<br>");
						}
						b_line= false;
						stepName  = "03";
					}
					
				}
			}
			else
			{
				InputStream is = new FileInputStream(uploadFilePath); 			
				jxl.Workbook wb = Workbook.getWorkbook(is);  
				jxl.Sheet sht = wb.getSheet(0);
				for (int i = 1; i <sht.getRows(); i++) 
				{
					//PLANT CODE
					jxl.Cell wcPlant_Code = sht.getCell(0, i);            
					Plant_Code = (wcPlant_Code.getContents()).trim();
					if (Plant_Code == null) Plant_Code= "";
				
					//ORDER ITEM
					jxl.Cell wcOrder_Item = sht.getCell(1, i);          
					Order_Item = (wcOrder_Item.getContents()).trim();
					if (Order_Item == null) Order_Item= "";
				
					//ITEM DESC
					jxl.Cell wcItem_Desc = sht.getCell(2, i);          
					Item_Desc = (wcItem_Desc.getContents()).trim();
					if (Item_Desc  == null) Item_Desc = "";
				
					// qty
					jxl.Cell wcIssueQty = sht.getCell(3, i);  
					IssueQty = (wcIssueQty.getContents()).trim();
					if (IssueQty == null) IssueQty="0";
				
					// Amount 
					jxl.Cell wcAmount = sht.getCell(5, i);           
					Amount = (wcAmount.getContents()).trim();
					if (Amount == null) Amount = "";
									
					//// UOM
					//jxl.Cell wcUOM = sht.getCell(4, i);           
					//UOM = (wcUOM.getContents()).trim();
					//if (UOM == null) UOM="";
				
					// CURRENCY
					jxl.Cell wcCurrency = sht.getCell(6, i);           
					Currency = (wcCurrency.getContents()).trim();
					if (Currency == null) Currency="";
									
					// UNIT PRICE
					jxl.Cell wcUnit_Price = sht.getCell(7, i);  
					jxl.NumberCell uPrice = (jxl.NumberCell)wcUnit_Price;
					Unit_Price = Double.toString(uPrice.getValue());
					if (Unit_Price == null) Unit_Price="";

					UOM="PCE"; //DELTA固定PCE BY PEGGY 20240603
					
					//負數數量不做上傳
					if (!IssueQty.startsWith("-"))
					{
						sb.append(Plant_Code+";"+Cust_Po_line_Number+";"+Order_Item+";"+
						Item_Desc+";"+UOM+";"+Unit_Price+";"+Currency+";"+IssueQty+";"+Amount+"<br>");
					}
				}
				wb.close();
			}
		}catch(Exception e){out.println("exception:"+e.getMessage());sb.setLength(0);}
		
		if (sb != null && sb.length() >0) 
		{
			java.util.Hashtable hashtb = new Hashtable();
			sbf_s.append("<table cellspacing='0' bordercolordark='#998811' cellpadding='1' width='100%' align='left'"+
						 " bordercolorlight='#ffffff' border='1'>"+
						 "<tr class='style9' >"+
				         "<td colspan='13'>上傳結果：</td>"+
			 			 "</tr>"+
						 "<tr>"+
						 "<td class='style9'>Seq No</td>"+
						 "<td class='style9'>PLANT</td>"+
				         "<td class='style9'>Cust PO Line Numbers</td>"+
			             "<td class='style9'>P/N</td>"+
						 "<td class='style9'>Vendor P/N</td>"+
						 "<td class='style11'>Issue Qty</td>"+
						 "<td class='style11'>Issue Unit</td>"+
						 "<td class='style11'>Consign Price</td>"+
						 "<td class='style11'>Currency</td>"+
						 "<td class='style11'>Amount</td>"+
						 "<td class='style11'>ID No</td>"+
						 "<td class='style11'>Status</td>"+
						 "<td class='style9'>Error Message</td>"+
						 "</tr>"+
						 "?????" +
						 "</table>");
					
			try 
			{
				//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
				//20110824 for ERP R12 Upgrade to modify 
 				CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
				cs1.execute();
				cs1.close();	
				ERP_CUST_NUMBER = "";
				Customer_ID = "";
				Customer_Number = "";
				ShipToID = "";
				BillToID = "";
				ITEM_IDENTIFIER_TYPE = "";
				ORDER_ITEM_ID = "";
				ITEM_NAME = "";
				INV_ITEM_ID = "";	
				Price_List_ID = "";
				Payment_Term_ID = "";
				CUSTOMER_NAME = "";
				actionCode ="";
				SHIPMENTTERMS = "";
				KEYID = "";
				KEYNO = "";
				Cust_Po_line_Number = "";
					 
				String [] strArray  = (sb.toString()).split("<br>");
				for (int i = 0 ; i < strArray.length ; i ++)
				{		
					strErr.setLength(0);
					strErr.append("");
					allStrErr.setLength(0);
					allStrErr.append("");
					sbf_d.append("<tr>");
					sbf_d.append("<td class='style3'>"+(i+1)+"</td>");
					String [] strDetail = strArray[i].split(";");
					
					//PLANT CODE
					Plant_Code = strDetail[0].trim();
					if (Plant_Code == null)
					{
						Plant_Code="&nbsp;";
						strErr.append("Plant Code不可空白<br>");
						ErrorCnt ++;
					}
					else
					{
						KEYNO = (String)hashtb.get(Plant_Code);
						if (KEYNO != null) 
						{
							actionCode = "UPDATE";
							KEYID = Customer_PO+KEYNO;
						}
						else
						{
							actionCode = "NEW";
						}
				
						//sql = "SELECT a.attribute1, a.attribute2, b.customer_id, b.party_number,"+
						//  " c.address_id, d.site_use_id, d.site_use_code, d.fob_point,b.PRICE_LIST_ID,b.CUSTOMER_NAME"+
						//  " ,d.PAYMENT_TERM_ID"+
						//  " FROM inv.mtl_item_locations a,"+
						//  " ar_customers_v b,"+ 
						//  " ar_addresses_v c,"+
						//  " hz_site_uses_v d"+
						//  " WHERE a.organization_id = "+Org_ID+""+
						//  " AND a.subinventory_code = '"+Subinventory_Code+"'"+
						//  " AND a.segment1 = '"+Plant_Code+"'"+
						//  " AND a.attribute1 = b.customer_number(+)"+
						//  " AND b.status = 'A'"+
						//  " AND b.customer_id = c.customer_id(+)"+
						//  " AND c.address_id = d.address_id(+)"+
						//  " AND d.status = 'A'"+
						//  " and d.site_use_code='BILL_TO'";
						//20110825 modify by peggychen for R12 upgrade--change ar_customers_v to ar_customers
						sql = "SELECT a.attribute1, a.attribute2, b.customer_id, b.party_number,"+
						  " c.cust_acct_site_id address_id, d.site_use_id, d.site_use_code, d.fob_point,b.PRICE_LIST_ID,b.CUSTOMER_NAME"+
						  " ,d.PAYMENT_TERM_ID"+
						  " FROM inv.mtl_item_locations a,"+
						  " (SELECT cust.CUST_ACCOUNT_ID customer_id, substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
                          " cust.ACCOUNT_NUMBER customer_number,party.party_id, party.party_number,"+
                          " cust.orig_system_reference,cust.price_list_id ,cust.status FROM  hz_cust_accounts cust, hz_parties party"+
                          " WHERE cust.party_id = party.party_id) b,"+ 
						  " hz_cust_acct_sites c,"+
                          " hz_cust_site_uses d"+
						  " WHERE a.organization_id = "+Org_ID+""+
						  " AND a.subinventory_code = '"+Subinventory_Code+"'"+
						  " AND a.segment1 = '"+Plant_Code+"'"+
						  " AND a.attribute1 = b.customer_number(+)"+
						  " AND b.status = 'A'"+
						  " AND b.customer_id = c.cust_account_id(+)"+
						  " AND c.cust_acct_site_id = d.cust_acct_site_id(+)"+
						  " AND d.status = 'A'"+
						  " and d.site_use_code='BILL_TO'";
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						if(rs.next())
						{
							ERP_CUST_NUMBER = rs.getString("attribute1");
							if (ERP_CUST_NUMBER==null)
							{
								strErr.append("Plant Code未設定對應ERP客戶<br>");
								ErrorCnt ++;
							}
							if (ShipToID == null)
							{
								strErr.append("Plant Code未設定對應ShipToID<br>");
								ErrorCnt ++;
							}
							Customer_Number = rs.getString("customer_id");
							Customer_ID = rs.getString("party_number");
							ShipToID = rs.getString("attribute2");
							BillToID = rs.getString("site_use_id");
							Price_List_ID = rs.getString("PRICE_LIST_ID");
							//SHIPMENTTERMS = rs.getString("fob_point");
							SHIPMENTTERMS = "DDU E-HUB OPERATION"; //add by Peggy 20140123
							CUSTOMER_NAME = rs.getString("CUSTOMER_NAME");
							Payment_Term_ID = rs.getString("payment_term_id");
							if (SHIPMENTTERMS == null)
							{
								strErr.append("Customer："+ERP_CUST_NUMBER+"的FOB未設定<br>");
								ErrorCnt ++;
								//SHIPMENTTERMS = "FOB TIANJIN"; //--For 測試用
							}
						}
						else
						{
							strErr.append("Plant Code未設定對應ERP客戶<br>");
							ErrorCnt ++;
						}   
						rs.close();
						statement.close();		
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style2'>"+Plant_Code+"</td>");
					}
					else
					{
						sbf_d.append("<td class='style3'>"+Plant_Code+"</td>");
					}
		   
		   			// CUSTOMER PO LINE NUMBER
					Cust_Po_line_Number = strDetail[1].trim();
					if (Cust_Po_line_Number == null || Cust_Po_line_Number.equals(""))
					{
						Cust_Po_line_Number = Customer_PO;
						sbf_d.append("<td class='style3'>&nbsp;</td>");
					}else{
						sbf_d.append("<td class='style3'>"+Cust_Po_line_Number +"</td>");
					}
					
					//ORDER ITEM
					Order_Item = strDetail[2].trim();
		
					// Item Desc
					Item_Desc = strDetail[3].trim();
					if (Order_Item  == null && Item_Desc == null)
					{
						Order_Item = "&nbsp;";
						Item_Desc = "&nbsp;";
						strErr.append("P/N不可空白<br>Vendor P/N不可空白<BR>");
						ErrorCnt ++;
					}
					else if (Order_Item  == null && Item_Desc != null)
					{ 
						sql = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,"+
							  " INVENTORY_ITEM, ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID"+
							  " from oe_items_v "+
							  " where SOLD_TO_ORG_ID = '"+Customer_Number+"' "+
							  " and ITEM_DESCRIPTION = '"+Item_Desc+"'"+
							  " and ITEM_STATUS='ACTIVE'"+       //add by Peggy 20231121
							  " and CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20231121 
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						if(rs.next())
						{
							ITEM_IDENTIFIER_TYPE = rs.getString("ITEM_IDENTIFIER_TYPE");
							ORDER_ITEM_ID = rs.getString("ITEM_ID");
							ITEM_NAME = rs.getString("INVENTORY_ITEM");
							INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
							Order_Item = rs.getString("ITEM");
						}
						else
						{
							strErr.append(Item_Desc+"查無對應的ERP料號<br>");
							ErrorCnt ++;
						}   
						rs.close();
						statement.close();		
					}
					else if (Order_Item  != null && Item_Desc == null)
					{
						sql = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,"+
							  " INVENTORY_ITEM, ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID"+
							  " from oe_items_v "+
							  " where SOLD_TO_ORG_ID = '"+Customer_Number+"' "+
							  " and ITEM = '"+Order_Item+"'"+
							  " and ITEM_STATUS='ACTIVE'"+       //add by Peggy 20231121
							  " and CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20231121 
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						if(rs.next())
						{
							ITEM_IDENTIFIER_TYPE = rs.getString("ITEM_IDENTIFIER_TYPE");
							ORDER_ITEM_ID = rs.getString("ITEM_ID");
							ITEM_NAME = rs.getString("INVENTORY_ITEM");
							INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
							Item_Desc = rs.getString("ITEM_DESCRIPTION");
						}
						else
						{
							strErr.append(Order_Item+"查無對應的ERP料號<br>");
							ErrorCnt ++;
						}
						rs.close();
						statement.close();			
					}
					else
					{
						sql = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,"+
							  " INVENTORY_ITEM, ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID"+
							  " from oe_items_v "+
							  " where SOLD_TO_ORG_ID = '"+Customer_Number +"' "+
							  " and ITEM = '"+Order_Item+"'"+
							  " and ITEM_DESCRIPTION = '"+Item_Desc+"'"+
							  " and ITEM_STATUS='ACTIVE'"+       //add by Peggy 20231121
							  " and CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20231121 							  
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						if(rs.next())
						{
							ITEM_IDENTIFIER_TYPE = rs.getString("ITEM_IDENTIFIER_TYPE");
							ORDER_ITEM_ID = rs.getString("ITEM_ID");
							ITEM_NAME = rs.getString("INVENTORY_ITEM");
							INV_ITEM_ID = rs.getString("INVENTORY_ITEM_ID");	
						}
						else
						{
							sql = " select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,"+
								  " INVENTORY_ITEM, ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID"+
								  " from oe_items_v "+
								  " where SOLD_TO_ORG_ID = '"+Customer_Number+"' "+
								  " and ITEM = '"+Order_Item+"'"+
							  	  " and ITEM_STATUS='ACTIVE'"+       //add by Peggy 20231121
							      " and CROSS_REF_STATUS='ACTIVE'";  //add by Peggy 20231121 								  
							Statement statement1=con.createStatement();
							ResultSet rs1 = statement1.executeQuery(sql);
							if(rs1.next())
							{
								ITEM_IDENTIFIER_TYPE = rs1.getString("ITEM_IDENTIFIER_TYPE");
								ORDER_ITEM_ID = rs1.getString("ITEM_ID");
								ITEM_NAME = rs1.getString("INVENTORY_ITEM");
								INV_ITEM_ID = rs1.getString("INVENTORY_ITEM_ID");
								Item_Desc = rs1.getString("ITEM_DESCRIPTION");
							}
							else
							{
								strErr.append("查無對應的ERP料號<BR>");
								ErrorCnt ++;
							}
							rs1.close();
							statement1.close();							
						}
						rs.close();
						statement.close();	
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style2'>"+Order_Item+"</td>");
						sbf_d.append("<td class='style2'>"+Item_Desc+"</td>");
						
					}else{
						sbf_d.append("<td class='style3'>"+Order_Item+"</td>");
						sbf_d.append("<td class='style3'>"+Item_Desc+"</td>");
					}
		
					// qty
					try
					{
						IssueQty = strDetail[7].trim();
						if (IssueQty == null)
						{
							IssueQty = "&nbsp;";
							strErr.append("Issue Qty不可空白<br>");
							ErrorCnt ++;
						}
						else
						{
							float qtynum = Float.parseFloat(IssueQty.replace(",",""));
							if (qtynum != (float) Math.floor(qtynum))
							{	
								strErr.append("Issue Qty必須為正整數<br>");
								ErrorCnt ++;
							}
							else if ( qtynum <= 0)
							{
								strErr.append("Issue Qty必須大於零<br>");
								ErrorCnt ++;
							}
							else
							{
								IssueQty =(new DecimalFormat("##,###,##0")).format(qtynum);
							}
						}
					}
					catch(Exception e)
					{
						strErr.append("Issue Qty必須為數字<br>");
						ErrorCnt ++;
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style7'>"+IssueQty+"</td>");
						
					}else{
						sbf_d.append("<td class='style5'>"+IssueQty+"</td>");
					}
					
					// UOM
					UOM = strDetail[4].trim();
					if (UOM == null)
					{
						UOM = "&nbsp;";
						strErr.append("Issue Unit不可空白<br>");
						ErrorCnt ++;
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style8'>"+UOM+"</td>");
						
					}else{
						sbf_d.append("<td class='style6'>"+UOM+"</td>");
					}
								
					// Unit Price
					try
					{
						Unit_Price = strDetail[5].trim();
						if (Unit_Price == null)
						{
							Unit_Price = "&nbsp;";
							strErr.append("Consign Price不可空白<br>");
							ErrorCnt ++;
						}
						else
						{
							float pricenum = Float.parseFloat(Unit_Price.replace(",",""));
							if ( pricenum <= 0)
							{
								strErr.append("Consign Price必須大於零<br>");
								ErrorCnt ++;
							}
							else
							{
								Unit_Price =(new DecimalFormat("###,##0.000##")).format(pricenum);
							}
						}
					}
					catch(Exception e)
					{
						strErr.append("Consign Price必須為數字<br>");
						ErrorCnt ++;
					}			
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style7'>"+Unit_Price+"</td>");
					}else{
						sbf_d.append("<td class='style5'>"+Unit_Price+"</td>");
					}
					
					// CURRENCY
					Currency =strDetail[6].trim();
					if (Currency == null)
					{
						Currency = "&nbsp;";
						strErr.append("Currency不可空白<br>");
						ErrorCnt ++;
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style8'>"+Currency+"</td>");
						
					}else{
						sbf_d.append("<td class='style6'>"+Currency+"</td>");
					}
								  
					// Amount 
					try
					{
						Amount = strDetail[8].trim();
						if (Amount == null)
						{
							Amount = "&nbsp;";
							strErr.append("Amount不可空白<br>");
							ErrorCnt ++;
						}
						else
						{
							float amt_num = Float.parseFloat(Amount.replace(",",""));
							if ( amt_num <= 0)
							{
								strErr.append("Amount必須大於零<br>");
								ErrorCnt ++;
							}
							else
							{
								Amount =(new DecimalFormat("##,###,##0.00")).format(amt_num);
							}
						}
					}
					catch(Exception e)
					{
						strErr.append("Amount必須為數字<br>");
						ErrorCnt ++;
					}
					if (strErr.length() >0)
					{
						allStrErr.append(strErr);
						strErr.setLength(0);
						sbf_d.append("<td class='style7'>"+Amount+"</td>");
						
					}else{
						sbf_d.append("<td class='style5'>"+Amount+"</td>");
					}	
						
					if (Price_List_ID == null || Payment_Term_ID == null)
					{
						sql = " SELECT payment_term_id, price_list_id"+
						  " FROM (SELECT   '1' AS sno, hcsua.payment_term_id, hcsua.price_list_id"+
						  " FROM hz_cust_site_uses_all hcsua,"+
						  " hz_cust_acct_sites_all hcasa,"+
						  " hz_party_sites hps,"+
						  " hz_locations hl"+
						  " WHERE hcsua.LOCATION = '"+BillToID+"'"+
						  " AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id"+
						  " AND hcasa.party_site_id = hps.party_site_id"+
						  " AND hps.location_id = hl.location_id"+
						  " UNION ALL"+
						  " SELECT   '2' AS sno, hcsua.payment_term_id, hcsua.price_list_id"+
						  " FROM hz_cust_site_uses_all hcsua,"+
						  " hz_cust_acct_sites_all hcasa,"+
						  " hz_party_sites hps,"+
						  " hz_locations hl"+
						  " WHERE hcsua.LOCATION = '"+ShipToID+"'"+
						  " AND hcsua.cust_acct_site_id = hcasa.cust_acct_site_id"+
						  " AND hcasa.party_site_id = hps.party_site_id"+
						  " AND hps.location_id = hl.location_id"+
						  " ORDER BY 1)";
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);				  
						while(rs.next())
						{
							if (Price_List_ID == "" || Price_List_ID == null)
							{
								Price_List_ID = rs.getString("price_list_id");
							}
						
							if (Payment_Term_ID == "" || Payment_Term_ID == null)
							{
								Payment_Term_ID = rs.getString("payment_term_id");
							}
						}
						rs.close();
						statement.close();
					}
						
					
					if (allStrErr.length()==0)
					{
						if (actionCode == "NEW")
						{
							icnt ++;
							sql = " select lpad(DELTA_KEY_S.nextval ,7,'0') KEYNO from dual";
							Statement statement=con.createStatement();
							ResultSet rs = statement.executeQuery(sql);
							if(rs.next())
							{
								KEYNO = rs.getString("KEYNO");
								hashtb.put(Plant_Code,KEYNO);
							}
							KEYID = Customer_PO+KEYNO;							
							rs.close();
							statement.close();
						
							sql = "insert into apps.TSC_OE_AUTO_HEADERS("+
								   "C_DATE,CUSTOMERNAME,ORDER_TYPE_ID,PAYTERM_ID,SHIPMENTTERMS,"+
								   "PRICE_LIST,SHIPTOID,BILLTOID,SALESPERSON,STATUS,"+
								   "FLAG,PACKINGLISTNUMBER,CREATED_BY,CREATION_DATE,CURRENCY,"+
								   "CUSTOMERID,CUSTOMERNUMBER,ID,SALES_REGION,PLANT_CODE,"+
								   "CUSTOMERPO"+
								   ")"+
								   " values("+
								   "?,?,?,?,?,"+
								   "?,?,?,?,?,"+
								   "?,?,?,?,?,"+
								   "?,?,?,?,?,"+
								   "? "+
								   ") ";
							PreparedStatement seqstmt=con.prepareStatement(sql);
							seqstmt.setString(1,CreationDate);
							seqstmt.setString(2,CUSTOMER_NAME);
							seqstmt.setString(3,"1091");
							seqstmt.setString(4,Payment_Term_ID);
							seqstmt.setString(5,SHIPMENTTERMS);
							seqstmt.setString(6,Price_List_ID);
							seqstmt.setString(7,ShipToID);
							seqstmt.setString(8,BillToID);
							seqstmt.setString(9,"DorisLee");
							seqstmt.setString(10,"OPEN");
							seqstmt.setString(11,"N");
							seqstmt.setString(12,KEYNO);
							seqstmt.setString(13,UserName);
							seqstmt.setString(14,CreationDate);
							seqstmt.setString(15,Currency);
							seqstmt.setString(16,Customer_ID);
							seqstmt.setString(17,Customer_Number);
							seqstmt.setString(18,KEYID);
							seqstmt.setString(19,Customer_PO);
							seqstmt.setString(20,Plant_Code);
							seqstmt.setString(21,KEYID);
							//seqstmt.executeUpdate();
							seqstmt.executeQuery();
						}
						
						sql = "insert into apps.TSC_OE_AUTO_LINES("+
							   "LINE_NO,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,CUSTOMERPRODUCTNUMBER,LINE_TYPE,"+
							   "SHIP_DATE,LIST_PRICE,SELLING_PRICE,UOM,QUANTITY,"+
							   "CURRENCY,AMOUNT,PACKINGLISTNUMBER,CARTONNUMBER,AWB,SHIPPING_INSTRUCTIONS,"+
							   "CREATED_BY,CREATION_DATE,LAST_UPDATE_DATE,LAST_UPDATED_BY,INVENTORY_ITEM,"+
							   "ITEM_IDENTIFIER_TYPE,CUSTOMERPRODUCT_ID,ID,CUSTOMERPO,OR_LINENO"+
							   ")"+
							   " select NVL(MAX(LINE_NO),0)+1,"+
							   "?,?,?,?,?,"+
							   "?,?,?,?,?,"+
							   "?,?,?,?,?,"+
							   "?,?,?,?,?,"+
							   "?,?,?,?,NVL(MAX(LINE_NO),0)+1"+
							   " from  apps.TSC_OE_AUTO_LINES"+
							   " where ID = '" + KEYID + "'";
						PreparedStatement seqstmt=con.prepareStatement(sql);
						seqstmt.setString(1,Item_Desc);
						seqstmt.setString(2,INV_ITEM_ID);
						seqstmt.setString(3,Order_Item);
						seqstmt.setString(4,"1007");
						seqstmt.setString(5,CreationDate);
						seqstmt.setString(6,Unit_Price);
						seqstmt.setString(7,Unit_Price);
						seqstmt.setString(8,UOM);
						seqstmt.setString(9,IssueQty.replace(",",""));
						seqstmt.setString(10,Currency);
						seqstmt.setString(11,Amount.replace(",",""));
						seqstmt.setString(12,KEYNO);
						seqstmt.setString(13,"0");
						seqstmt.setString(14,"");
						seqstmt.setString(15,Cust_Po_line_Number);
						seqstmt.setString(16,UserName);
						seqstmt.setString(17,CreationDate);
						seqstmt.setString(18,UserName);
						seqstmt.setString(19,CreationDate);
						seqstmt.setString(20,ITEM_NAME);
						seqstmt.setString(21,ITEM_IDENTIFIER_TYPE);
						seqstmt.setString(22,ORDER_ITEM_ID);
						seqstmt.setString(23,KEYID);
						seqstmt.setString(24,Customer_PO);
						//seqstmt.executeUpdate();
						seqstmt.executeQuery();
						sbf_d.append("<td class='style3'><A HREF='../jsp/Tsc1211SpecialCustConfirm.jsp?KeyID="+KEYID+"'>"+KEYID+"</a></td>");
						sbf_d.append("<td class='style10'>OK</td>");
						sbf_d.append("<td class='style3'>&nbsp;</td>");
					}else{
						sbf_d.append("<td class='style3'>&nbsp;</td>");
						sbf_d.append("<td class='style8'>Error</td>");
						sbf_d.append("<td class='style2'>"+allStrErr+"</td>");
					}
					sbf_d.append("</tr>");
				}
				if (ErrorCnt==0)
				{
					con.commit();
					if (icnt ==1)
					{	
						out.println("icnt="+icnt);
						response.sendRedirect("Tsc1211SpecialCustConfirm.jsp?KeyID="+KEYID);
					}
					
				}
				else
				{
					con.rollback();
					String v_str = sbf_d.toString();
					Enumeration enkey  = hashtb.keys(); 
        			while (enkey.hasMoreElements())   
					{ 
        				Object  aa  =  enkey.nextElement(); 
						v_str = v_str.replace("<A HREF='../jsp/Tsc1211SpecialCustConfirm.jsp?KeyID="+Customer_PO+hashtb.get(aa)+"'>"+Customer_PO+hashtb.get(aa)+"</a>","&nbsp;");
            		} 
					sbf_d.delete(0,sbf_d.length());
					sbf_d.append(v_str);
				}
			}
			catch (Exception e) 
			{
				con.rollback();
				isException = true;
				allStrErr.setLength(0);
				allStrErr.append("上傳動作失敗，請洽系統管理員，謝謝！<br>Exception insert:"+e.getMessage()+"<br>"+sql);
			}
		}
		else
		{
			isException=true;
			allStrErr.setLength(0);
			allStrErr.append("動作失敗，上傳檔案格式錯誤，請重新確認後再上傳，謝謝！");
		}
	}
}
%>
<table width="75%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
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
					<TD width="10%" class="style15">
						<STRONG>資料上傳</STRONG>
					</TD>
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
					<TD width="70%" class="style16"><a href="samplefiles/D4-010_User_Guide.doc">Download User Guide</a>&nbsp;</TD>
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  <tr>
				<td colspan="2" bgcolor="#D8E6E7F" class="style1">請指定上傳檔案：</FONT></td>
			  </tr>
			  <tr>
				<td width="10%" bgcolor="#AAFFAA" class="style3">Upload File：</font></td>
				<td width="90%" class="style3"><INPUT TYPE="FILE" NAME="UPLOADFILE" size="90" class="style3">
				<A HREF="../jsp/samplefiles/D4-010_SampleFile.xls">Download Sample File</A>				
				</td>
			  </tr>
			  <tr>
				<td class="style3" colspan=2 title="請按我，謝謝!">
				<input type="button" class="style4" name="submit1" value='Upload' onClick="setCreate('../jsp/Tsc1211SpecialCustUpload.jsp?PTYPE=1')">
				</td>
			  </tr>
			</table>
		</td>
	</tr>
	<TR><TD>&nbsp;</td></tr>
	<% 
	if (PTYPE.equals("1") && isException==false)
	{
		out.println("<tr><td width='100%'>"+sbf_s.toString().replace("?????",sbf_d.toString())+"</td></tr>");
	}
	else
	{
		out.println("<tr><td width='100%' class='style17'><strong>"+allStrErr+"</strong></td></tr>");
	}
	%>
</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
