<!--modify by Peggy 20140829,added to modify FOB,PAYMENT TERM,SHIP TO CONTACT-->
<!--modify by Peggy 20150127,update tsc_edi_orders_his_d.LAST_UPDATED_BY & LAST_UPDATE_DATE column value -->
<!--modify by Peggy 20150618,add two columns "Hold Shipment" & "Remove Hold"-->
<!--modify by Peggy 20150904,移除line no的單引號-->
<!--modify by Peggy 20160606,add tsch order revise-->
<!--modify by Peggy 20180314,The initial SSD write to database-->
<!--modify by Peggy 20181214,add a field of cust_po_line_number to modify-->
<!--20181222 Peggy,新增original customer part no-->
<!--20200130 Peggy,新增overdue new ssd column for TSCE,Quote Number & End Customer for TSCR-->
<!--20200430 sharlin,add Delivery_Instruction for YEW-DropShip-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*,java.text.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Sales Order Revise Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<script language="JavaScript" type="text/JavaScript">

function setDataReset(URL)
{  
   alert("資料清空!!!");
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

function setDataRevise(URL)
{
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

</script>
<body>
<A HREF="../jsp/TSCSalesOrderReviseUpload.jsp">上一頁</A>
<FORM NAME="MYFORM" onsubmit='return submitCheck("是","否")' ACTION="../jsp/TSCSalesOrderReviseInsert.jsp" METHOD="post">
  <strong><font color="#004080" size="4" face="Arial">Sales Order Revise Process</font></strong> 
<%


int loginUserId=0,dataCount=0,cntError=0,cntRevise=0;

String updateFlag = request.getParameter("UPDATEFLAG");       //判斷是否按了更新資料庫BUTTON
String dataError = request.getParameter("DATAERROR");        // 判斷資料是否有誤 Y / N
String pType = request.getParameter("PTYPE");   //  1: insert table ORADDMAN.TSC_OM_SALESORDERREVISE ,2:REVISE 3:CANCEL
String groupId =request.getParameter("GROUP_ID"); 

if (updateFlag==null || updateFlag.equals("")) updateFlag="N";
if (dataError==null || dataError.equals("")) dataError="N";   //預設資料無誤
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);
String dateString="";
String errorFlag="N",colorStr="";
boolean chkvaild=false;  //add by Peggy 20140901
String dItem_Desc ="", dCustomer ="",dCustomer_PO_No="",dQty ="",sPrice="",sSchedule_Ship_Date ="",sOriginalSSD="",dShipping_Method="",dRemarks="",dChange_Reason="",dChange_Comments="",CRD="",FOB = "",Payment_Term = "",Payment_Term_ID = "",Ship_To_Contact_ID=null;
String Hold_Shipment="",Hold_Reason="",overdue_new_ssd="",quote_number="",end_cust="",end_cust_id="",end_cust_name=""; //add by Peggy 20150618
String cust_po_line_no="",backtotw_remarks="",backtotw="",Hold_SSD="";   //add by Peggy 20181214
String delivery_instruction="";   //20200430 sharlin add
Hashtable hashtb = new Hashtable();
String strErr="";

String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
pstmtNLS.executeUpdate(); 
pstmtNLS.close();
String colName[] = {"Qty","Price","SSD","CRD","Shipping Method","FOB Term","Payment Term","Hold Shipment","Hold Reason","Overdue SSD","Delivery instruction","TOTW Ship Method","TOTW Ship Remarks","Hold SSD","Quote#","End Cust"};
int i_cnt=0;

if ( pType == "1" || pType.equals("1") )    // Insert temp table , check , display
{
	mySmartUpload.initialize(pageContext); 
   	mySmartUpload.upload();

   	dateString=dateBean.getYearMonthDay();
   	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
   	upload_file.saveAs("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 


   	String uploadFile_name=upload_file.getFileName();
   	String uploadFilePath="d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName();

   	try 
	{
    	String sqlid = " SELECT TSCC_OM_STATUS_S.NEXTVAL GROUP_ID, erp_user_id FROM ORADDMAN.WSUSER"+
 					 "  WHERE UPPER(USERNAME) = trim(upper('"+UserName+"')) " ;
	  	Statement stateid=con.createStatement();
      	ResultSet rsid=stateid.executeQuery(sqlid);
	  	if (rsid.next()) 
		{ 	
        	groupId=rsid.getString("GROUP_ID");    // group_id use TSCC_OM_STATUS_S.nextval
         	loginUserId=rsid.getInt("ERP_USER_ID");
      	}
	  	rsid.close();
      	stateid.close(); 
   	}
   	catch (Exception e) 
	{
		out.println("Exception get group_id:"+e.getMessage());
	  	errorFlag="Y";
   	} 

   	if (errorFlag=="N") 
	{
    	String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
      	String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
      	InputStream is = new FileInputStream("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 			
			
      	jxl.Workbook wb = Workbook.getWorkbook(is);  
      	jxl.Sheet sht = wb.getSheet(0);

      	String sheetName = sht.getName();    //抓SHEETNAME
    
        int columnCount = sht.getColumns();    // 20120720 Marvie Add : Qty descrete

      	int rowCount = sht.getRows();  // 取此次筆數
      	dataCount = 0;

      	int i = 1; //EXCEL 表由第2列開始讀入			
		
		//add by Peggy 20140901
		String sql = " select a.FOB_CODE, a.FOB from OE_FOBS_ACTIVE_V a";
		Statement statefob=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rsfob = statefob.executeQuery(sql);		
		
		//add by Peggy 20140901
		sql = " select a.TERM_ID, a.NAME, a.DESCRIPTION from RA_TERMS_VL a where sysdate between a.start_date_active and NVL(a.end_date_active,sysdate)";
		Statement statepayment=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rspayment = statepayment.executeQuery(sql);	
				
      	try 
		{
        	while (i<rowCount) 
			{  
            	jxl.Cell wcDOrder_No = sht.getCell(2, i);            // Order
            	String dOrder_No = wcDOrder_No.getContents();
   
            	jxl.Cell wcDLine_No = sht.getCell(3, i);             // Line
            	String dLine_No = wcDLine_No.getContents();
				dLine_No = dLine_No.replace("'","");   //去掉單引號,某些報表會在line no加單引號,以文字呈現,user複製時要人工移除,很麻煩,add by Peggy 20150908

				if (dOrder_No!="" && dLine_No!="") 
				{
					//檢查訂單+項次是否重複,add by Peggy 20210812
					if ((String)hashtb.get(dOrder_No+"/"+dLine_No)!=null)
					{
						strErr =strErr+(!strErr.equals("")?"<br>":"")+"MO:"+dOrder_No+"   項次:"+dLine_No+" 重複";
					}
					else
					{
						hashtb.put(dOrder_No+"/"+dLine_No,"V");		 

						jxl.Cell wcDItem_Desc = sht.getCell(4, i);           // Item Desc
						dItem_Desc = wcDItem_Desc.getContents();
	
						jxl.Cell wcDCustomer = sht.getCell(5, i);            // Customer
						dCustomer = wcDCustomer.getContents();
	
						jxl.Cell wcDCustomer_PO_No = sht.getCell(6, i);      // Customer PO No                      
						dCustomer_PO_No = wcDCustomer_PO_No.getContents();
						// 20110107 Marvie Add : whitespace omit
						dCustomer_PO_No = dCustomer_PO_No.trim();
						dCustomer_PO_No = dCustomer_PO_No.replace("'","");   //去除單引號,add by Peggy 20210505
	
						jxl.Cell wcDQty = sht.getCell(7, i);                 // Qty
						dQty = wcDQty.getContents();
						dQty = dQty.trim();  //trim space,add by Peggy 20140425
						
						jxl.Cell wcDPrice = sht.getCell(8, i);               // Price
						sPrice = wcDPrice.getContents();
						double dPrice = 0.0d;
						if (wcDPrice.getType() == CellType.NUMBER) 
						{
							NumberCell nc = (NumberCell) wcDPrice;
							dPrice = nc.getValue();
						} 
						else sPrice = "";
	
						//add by Peggy 20180314
						jxl.Cell wcDOriginalSSD = sht.getCell(9, i);  //initial SSD
						sOriginalSSD= wcDOriginalSSD.getContents();
						java.util.Date dOriginalSSD = new java.util.Date(2000,1,1);
						if (wcDOriginalSSD.getType() == CellType.DATE)
						{
							DateCell dc = (DateCell) wcDOriginalSSD;
							dOriginalSSD = dc.getDate();
						} 
						else sOriginalSSD = "";
											
						jxl.Cell wcDSchedule_Ship_Date = sht.getCell(10, i);  // Schedule Ship Date
						sSchedule_Ship_Date = wcDSchedule_Ship_Date.getContents();
						java.util.Date dSchedule_Ship_Date = new java.util.Date(2000,1,1);
						if (sSchedule_Ship_Date!=null && !sSchedule_Ship_Date.trim().equals(""))
						{
							if (wcDSchedule_Ship_Date.getType() == CellType.DATE)
							{
								DateCell dc = (DateCell) wcDSchedule_Ship_Date;
								dSchedule_Ship_Date = dc.getDate();
							} 
							else
							{
								//sSchedule_Ship_Date = "";
								throw new Exception("Row#"+i+":The new schedule date("+sSchedule_Ship_Date+") format error!!");
							}
						}
	
						jxl.Cell wcDShipping_Method = sht.getCell(11, i);     // Shipping Method
						dShipping_Method = wcDShipping_Method.getContents();              
						// 20110107 Marvie Add : whitespace omit
						dShipping_Method = dShipping_Method.trim();
	
						jxl.Cell wcDRemarks = sht.getCell(12, i);             // Remarks
						dRemarks = wcDRemarks.getContents();              
	
						// 20120720 Marvie Add : Qty descrete
						dChange_Reason = "";
						if (columnCount > 14) {
						  jxl.Cell wcDChange_Reason = sht.getCell(14, i);     // Change Reason
						  dChange_Reason = wcDChange_Reason.getContents();
						}
						//add by Peggy 20131009
						dChange_Comments="";
						if (columnCount > 15) 
						{
							jxl.Cell wcDChange_Comments = sht.getCell(15, i);     // Change Comments
							dChange_Comments = wcDChange_Comments.getContents();
						}
						
						//add by Peggy 20130108
						CRD = "";
						java.util.Date dCRD = new java.util.Date(2000,1,1);
						if ( columnCount > 16)
						{
							jxl.Cell wcDCRD = sht.getCell(16, i);     // CRD
							CRD = wcDCRD.getContents();
							if (wcDCRD.getType() == CellType.DATE)
							{
								DateCell dc = (DateCell) wcDCRD;
								dCRD= dc.getDate();
							} 
							else
							{
								CRD ="";
							}
						}
						
						//add by Peggy 20140829
						FOB = "";
						if ( columnCount > 17)
						{
							jxl.Cell wcDFOB = sht.getCell(17, i);     //FOB
							FOB = wcDFOB.getContents();
							//out.println("FOB="+FOB);
							if (FOB==null || FOB.equals(""))
							{
								FOB="";
							}
							else
							{
								chkvaild =false;
								if (rsfob.isBeforeFirst() ==false) rsfob.beforeFirst();
								while (rsfob.next())
								{
									if (rsfob.getString("FOB_CODE").equals(FOB))
									{
										chkvaild=true;
										break;
									}
								}
								if (!chkvaild) throw new Exception("FOB:"+FOB +" Not Found!!");
							}
						}
						
						//add by Peggy 20140829
						Payment_Term = "";Payment_Term_ID="";
						if ( columnCount > 18)
						{
							jxl.Cell wcDPayment_Term = sht.getCell(18, i); //Payment_Term
							Payment_Term = wcDPayment_Term.getContents();
							//out.println("Payment_Term="+Payment_Term);
							if (Payment_Term==null || Payment_Term.equals(""))
							{
								 Payment_Term="";
							}
							else
							{
								chkvaild =false;
								if (rspayment.isBeforeFirst() ==false) rspayment.beforeFirst();
								while (rspayment.next())
								{
									if (rspayment.getString("NAME").equals(Payment_Term))
									{
										Payment_Term_ID = rspayment.getString("TERM_ID");
										chkvaild=true;
										break;
									}
								}
								if (!chkvaild) throw new Exception("Payment Term:"+Payment_Term +" Not Found!!");
							}						
						}						
							
						//add by Peggy 20140829
						Ship_To_Contact_ID = null;
						if ( columnCount > 19)
						{
							jxl.Cell wcDShipToContactID = sht.getCell(19, i); //ship to contact id
							Ship_To_Contact_ID = wcDShipToContactID.getContents();
							if (Ship_To_Contact_ID==null)
							{
								 Ship_To_Contact_ID="";
							}
						}	
						
						//add by Peggy 20150618
						Hold_Shipment=null;
						Hold_Reason=null;
						java.util.Date dHold_Ship_Date=null;
						if (columnCount > 20)
						{
							jxl.Cell wcHold_Shipment = sht.getCell(20, i); //Hold_Shipment
							Hold_Shipment= wcHold_Shipment.getContents();
							if (Hold_Shipment==null)
							{
								 Hold_Shipment="";
							}
							jxl.Cell wcHold_Reason = sht.getCell(21, i); //Hold_Reason
							Hold_Reason= wcHold_Reason.getContents();
							if (Hold_Reason==null)
							{
								 Hold_Reason="";
							}	
							
							jxl.Cell wcHold_SSD = sht.getCell(22, i); //Hold new ssd
							Hold_SSD= wcHold_SSD.getContents();
  						    dHold_Ship_Date = new java.util.Date(2000,1,1);
							if (wcHold_SSD.getType() == CellType.DATE)
							{
								DateCell dc = (DateCell) wcHold_SSD;
								dHold_Ship_Date = dc.getDate();
							}
							else Hold_SSD="";
						}
						
						//add by Peggy 20181214
						cust_po_line_no="";
						if (columnCount > 23)
						{
							jxl.Cell wcCustPOLineNo = sht.getCell(23, i); //cust po line no
							cust_po_line_no= wcCustPOLineNo.getContents();
							if (cust_po_line_no==null) cust_po_line_no="";
						}					
								
						//add by Peggy 20200130
						overdue_new_ssd="";
						java.util.Date dOverdueSSD = new java.util.Date(2000,1,1);
						if (columnCount > 24)
						{
							jxl.Cell wcOverdueNewSSD = sht.getCell(24, i); //overdue_new_ssd
							overdue_new_ssd= wcOverdueNewSSD.getContents();
							overdue_new_ssd=overdue_new_ssd.trim();
							if (wcOverdueNewSSD.getType() == CellType.DATE)
							{
								DateCell dc = (DateCell) wcOverdueNewSSD;
								dOverdueSSD= dc.getDate();
							} 
							else if (overdue_new_ssd.length() >0) //add by Peggy 20210726
							{
								throw new Exception("Overdue/Early Warning SSD("+overdue_new_ssd+") format error!!");
							}
							else
							{
								overdue_new_ssd ="";
							}						
						}
						
						//add by Peggy 20200130
						quote_number="";
						if (columnCount > 25)
						{
							jxl.Cell wcQuoteNumber = sht.getCell(25, i); //quote_number
							quote_number= wcQuoteNumber.getContents();
							if (quote_number==null) quote_number="";
						}	
	
						//add by Peggy 20200130
						end_cust="";end_cust_id="";end_cust_name="";
						if (columnCount > 26)
						{
							jxl.Cell wcEndCustomer = sht.getCell(26, i); //end customer
							end_cust = wcEndCustomer.getContents();
							if (end_cust==null)
							{
								end_cust="";
							}
							if (!end_cust.equals(""))
							{
								try
								{
									sql = " SELECT CUSTOMER_ID ,customer_name"+
										  " FROM AR_CUSTOMERS AC"+
										  " WHERE CUSTOMER_NUMBER=?"+
										  " AND EXISTS (SELECT 1 FROM HZ_CUST_ACCT_SITES_ALL hcas"+
										  "             ,HZ_CUST_SITE_USES_ALL hcsu"+
										  ",TSC_OM_GROUP tog"+
										  " WHERE hcas.STATUS='A'"+
										  " AND hcsu.STATUS='A'"+
										  " AND hcas.CUST_ACCT_SITE_ID=hcsu.CUST_ACCT_SITE_ID"+
										  " AND hcas.ORG_ID=hcsu.ORG_ID"+
										  " AND TO_NUMBER(hcsu.ATTRIBUTE1) = TOG.GROUP_ID"+
										  " AND tog.ORG_ID = hcsu.ORG_ID"+
										  //" AND tog.GROUP_NAME=TSC_INTERCOMPANY_PKG.GET_SALES_GROUP(NVL((SELECT HEADER_ID FROM ONT.OE_ORDER_HEADERS_ALL X WHERE X.ORDER_NUMBER=?),0))"+
										  " AND tog.GROUP_NAME=TSC_OM_Get_Sales_Group(NVL((SELECT HEADER_ID FROM ONT.OE_ORDER_HEADERS_ALL X WHERE X.ORDER_NUMBER=?),0))"+
										  " AND hcas.CUST_ACCOUNT_ID=AC.CUSTOMER_ID)";
									PreparedStatement statement1 = con.prepareStatement(sql);
									statement1.setString(1,end_cust);
									statement1.setString(2,dOrder_No);
									ResultSet rs1=statement1.executeQuery();
									if (rs1.next())
									{	
										end_cust_id=rs1.getString(1);
										end_cust_name=rs1.getString(2);
									}
									else
									{
										end_cust_name=end_cust;
									}								
									rs1.close();
									statement1.close();																	
								}
								catch(Exception e)
								{
									end_cust_name=end_cust;
								}
							}
						}										
	
					  //20200430 sharlin add
						delivery_instruction="";
						if (columnCount > 27)
						{
							jxl.Cell wcDelivyerInstruction = sht.getCell(27, i); //DelivyerInstruction
							delivery_instruction= wcDelivyerInstruction.getContents();
							if (delivery_instruction==null) delivery_instruction="";
							//out.println("delivery_instruction="+delivery_instruction);
						}	
						
						//add Back T SO-shipping method by Peggy 
						backtotw="";
						if (columnCount > 28)
						{
							jxl.Cell wcbacktotw = sht.getCell(28, i); 
							backtotw= wcbacktotw.getContents();
							if (backtotw==null) backtotw="";					
						}
						
						//add Back T SO-shipping remarks method by Peggy 
						backtotw_remarks="";
						if (columnCount > 29)
						{
							jxl.Cell wcbacktotwRemarks = sht.getCell(29, i); 
							backtotw_remarks= wcbacktotwRemarks.getContents();
							if (backtotw_remarks==null) backtotw_remarks="";					
						}					
														
																					
						// 20120720 Marvie Update : Qty descrete , add field change_reason
						String sqlTC = "insert into ORADDMAN.TSC_OM_SALESORDERREVISE(group_id, order_number, line_number, item_description,"+
									 " customer_name, customer_po_number, ordered_quantity, unit_selling_price, schedule_ship_date,"+
									 " shipping_method_name, remarks, creation_date, created_by, process_status, change_reason,change_comments,CUST_REQUEST_DATE"+
									 ",FOB_POINT,PAYMENT_TERM_NAME,PAYMENT_TERM_ID,SHIP_TO_CONTACT_ID"+ //add by Peggy 20140829
									 ",HOLD_SHIPMENT,HOLD_REASON"+  //add by Peggy 20150618
									 ",ORIGINAL_SSD"+ //add by Peggy 20180314
									 ",CUST_PO_LINE_NO"+  //add by Peggy 20181214
									 ",OVERDUE_NEW_SSD,QUOTE_NUMBER,END_CUSTOMER_ID,END_CUSTOMER_NAME"+ //add by Peggy 20200130
									 ",DELIVERY_INSTRUCTION"+ //20200430 sharlin add
									 ",CREATED_BY_NAME,TOTW_SHIPPING_METHOD,TOTW_SHIPPING_REMARKS,HOLD_NEW_SSD)"+ //add by Peggy 20210809
									 " values("+groupId+","+dOrder_No+",'"+dLine_No+"', ?,"+
									 " ?, ?, ?, ?, ?,"+
									 " ?, ?, sysdate, "+loginUserId+", 1, ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,to_char(?,'yyyy/mm/dd')) ";								
						//out.println(sqlTC);
						PreparedStatement seqstmt=con.prepareStatement(sqlTC);
						seqstmt.setString(1,dItem_Desc);
						seqstmt.setString(2,dCustomer);
						seqstmt.setString(3,dCustomer_PO_No);
						//if (dQty==null || dQty=="") seqstmt.setNull(4,java.sql.Types.FLOAT);
						if (dQty==null || dQty.equals("")) seqstmt.setNull(4,java.sql.Types.FLOAT); //modify by Peggy 20140425
						else seqstmt.setFloat(4,Float.parseFloat(dQty));
						//if (sPrice==null || sPrice=="") seqstmt.setNull(5,java.sql.Types.FLOAT);
						if (sPrice==null || sPrice.equals("")) seqstmt.setNull(5,java.sql.Types.FLOAT); //modify by Peggy 20140425
						else seqstmt.setFloat(5,(float)dPrice);
						if (sSchedule_Ship_Date==null || sSchedule_Ship_Date.trim().equals(""))
						{
							seqstmt.setNull(6,java.sql.Types.DATE);
						}
						else 
						{
							java.sql.Date sqlDate = new java.sql.Date(dSchedule_Ship_Date.getTime());
							seqstmt.setDate(6,sqlDate);
						}
						seqstmt.setString(7,dShipping_Method);
						seqstmt.setString(8,dRemarks);
						seqstmt.setString(9,dChange_Reason);     // 20120720 Marvie Add : Qty descrete , add field change_reason
						seqstmt.setString(10,dChange_Comments);  // 20121009 Peggy Add : add field change_comments
						if (CRD==null || CRD.equals(""))  //addd by Peggy 20140108
						{
							seqstmt.setNull(11,java.sql.Types.DATE);
						}
						else 
						{
							java.sql.Date sqlDate = new java.sql.Date(dCRD.getTime());
							seqstmt.setDate(11,sqlDate);
						}					
						seqstmt.setString(12,FOB);                 // FOB, 20140829 add by Peggy
						seqstmt.setString(13,Payment_Term);        // Payment_Term, 20140829 add by Peggy
						seqstmt.setString(14,Payment_Term_ID);     // Payment_Term_ID, 20140829 add by Peggy
						seqstmt.setString(15,Ship_To_Contact_ID);  // Ship_To_Contact_ID, 20140829 add by Peggy
						seqstmt.setString(16,Hold_Shipment);       // Hold_Shipment, 20150618 add by Peggy
						seqstmt.setString(17,Hold_Reason);         // Hold_Reason, 20150618 add by Peggy
						if (sOriginalSSD==null || sOriginalSSD=="")  //add by Peggy 20180314
						{
							seqstmt.setNull(18,java.sql.Types.DATE);
						}
						else 
						{
							java.sql.Date sqlDate = new java.sql.Date(dOriginalSSD.getTime());
							seqstmt.setDate(18,sqlDate);
						}	
						seqstmt.setString(19,cust_po_line_no);         // cust_po_line_no, 20181214 by Peggy	
						if (overdue_new_ssd==null || overdue_new_ssd.equals(""))  //addd by Peggy 20200130
						{
							seqstmt.setNull(20,java.sql.Types.DATE);
						}
						else 
						{
							java.sql.Date sqlDate = new java.sql.Date(dOverdueSSD.getTime());
							seqstmt.setDate(20,sqlDate);
						}								
						seqstmt.setString(21,quote_number);            // quote_number by Peggy 20200130			
						seqstmt.setString(22,end_cust_id);             // end cust id by Peggy 20200130		
						seqstmt.setString(23,end_cust_name);           // end cust number by Peggy 20200130
						seqstmt.setString(24,delivery_instruction);       //Delivery Instruction       20200430 sharlin	
						seqstmt.setString(25,UserName);                //User Name by Peggy 20210809
						seqstmt.setString(26,backtotw);                //Back T SO-shipping method by Peggy 20210812
						seqstmt.setString(27,backtotw_remarks);        //Back T SO-shipping method Remarks by Peggy 20210812
						if (Hold_SSD==null || Hold_SSD=="") //Hold_SSD by Peggy 20211104
						{
							seqstmt.setNull(28,java.sql.Types.DATE);
						}
						else 
						{
							java.sql.Date holdDate = new java.sql.Date(dHold_Ship_Date.getTime());
							seqstmt.setDate(28,holdDate);
						}						
						//seqstmt.executeUpdate();
						seqstmt.executeQuery();
						dataCount++;
					}
				}
				i++;
		 	}

			if (i>0 && strErr.equals(""))
			{
				con.commit(); //add by Peggy 20140829
			} 
			else
			{
				throw new Exception(strErr);
			}
	  	} 
	  	catch (Exception e) 
		{
			con.rollback(); //add by Peggy 20140829
			out.println("<P><font color='red'>Exception insert fail...<br>"+e.getMessage()+"</font>");
	     	errorFlag="Y";
	  	}
   		wb.close(); 
   	}  

   	// Valid order
   	if (errorFlag=="N") 
   	{
    	try  
		{
        	String Errbuf="",Retcode="";

		 	CallableStatement cs4 = con.prepareCall("{call TSC_OM_SO_REVISE_PKG.valid_order(?,?,?,1,?,?)}");
		 	cs4.registerOutParameter(1, Types.VARCHAR);    // return Errbuf
		 	cs4.registerOutParameter(2, Types.VARCHAR);    // return Retcode
		 	cs4.setInt(3, Integer.parseInt(groupId));      // group_id
		 	cs4.setInt(4, loginUserId);                    // user_id
		 	cs4.registerOutParameter(5, Types.INTEGER);    // return Count_Error
		 	cs4.execute();
		 	Errbuf = cs4.getString(1);                     // return Errbuf
		 	Retcode = cs4.getString(2);                    // return Retcode
		 	cntError = cs4.getInt(5);                      // return Count_Error
		 	cs4.close();
			
         	if (Errbuf!=null) 
			{
		    	out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Valid order fail </FONT></TD><TD colspan=3>"+Errbuf+"("+Retcode+")"+"</TD></TR>");	
	        	errorFlag="Y";
         	}
	  	}
	  	catch (Exception e) 
		{
			out.println("Exception valid:"+e.getMessage());
	     	errorFlag="Y";
	  	}
   	} 

   	// Display error data
   	if (errorFlag=="N") 
	{
    	try 
		{
%>
		<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="95%" align="center" bordercolorlight="#ffffff" border="1">
<%
        	if (cntError>0) 
			{
%>
            	<tr><td colspan="12"><div align="center"><font color="#CC3300" face="Arial" size="2">Error data can not revise</font></div></td></tr>
  			    <tr bgcolor="#CCCC99"> 
			    <td width="9%" height="20" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Order</font></div></td>
  		        <td width="2%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Line</font></div></td>  
  		        <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Item Desc</font></div></td>  
  		        <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Customer</font></div></td>         
			    <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">PO No</font></div></td>
   			    <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Qty</font></div></td>
   			    <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Price</font></div></td>
			    <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Schedule<br>Ship Date</font></div></td>
			    <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Shipping<br>Method</font></div></td>			 
			    <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">CRD</font></div></td>			 
			    <td width="15%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Remarks</font></div></td>			 
			    <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Error Explanation</font></div></td>			 
                </tr>
<%
            	String sItemDesc="",sCustomer="",sPO_No="",sQty="",sScheduleShipDate="",sShippingMethod="",sRemarks="",sCRD="";

            	String sqlI= "SELECT order_number, line_number, item_description, customer_name, customer_po_number,"+
		                       " ordered_quantity, unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
						       " shipping_method_name, remarks, error_explanation"+
							   ",to_char(CUST_REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE"+ //add by Peggy 20140109
				          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE "+
   				         " WHERE group_id = "+groupId+
    				     "   AND process_status = 2 "+
						 " union all"+  //add by Peggy 20160606,add by tsch order error message
						 " SELECT A.SO_NO order_number, A.LINE_NO line_number,A.SOURCE_ITEM_DESC item_description,B.ACCOUNT_NAME customer_name, A.SOURCE_CUSTOMER_PO customer_po_number,"+
                         " A.SO_QTY ordered_quantity, NULL unit_selling_price,to_char(A.schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
                         " a.SHIPPING_METHOD shipping_method_name, NULL remarks, ERROR_MESSAGE error_explanation,"+
                         " to_char(REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE"+
                         " FROM oraddman.tsc_om_salesorderrevise_temp  A,HZ_CUST_ACCOUNTS B"+
                         " WHERE GROUP_ID_REF = "+groupId+
                         " and ERROR_MESSAGE is not null"+
                         " AND A.source_customer_id=B.CUST_ACCOUNT_ID";
	        	Statement stateI=con.createStatement();
            	ResultSet rsI=stateI.executeQuery(sqlI);
	        	while (rsI.next()) 
				{
			  		sItemDesc = rsI.getString("ITEM_DESCRIPTION");
			  		sCustomer = rsI.getString("CUSTOMER_NAME");
			  		sPO_No = rsI.getString("CUSTOMER_PO_NUMBER");
			  		sQty = rsI.getString("ORDERED_QUANTITY");
			  		sPrice = rsI.getString("UNIT_SELLING_PRICE");
			  		sScheduleShipDate = rsI.getString("SCHEDULE_SHIP_DATE");
			  		sShippingMethod = rsI.getString("SHIPPING_METHOD_NAME");
			  		sRemarks = rsI.getString("REMARKS");
					sCRD = rsI.getString("CUST_REQUEST_DATE"); //add by Peggy 20140109
			  		if (sItemDesc==null) sItemDesc = "&nbsp";
			  		if (sCustomer==null) sCustomer = "&nbsp";
			  		if (sPO_No==null) sPO_No = "&nbsp";
			  		if (sQty==null) sQty = "&nbsp";
			  		if (sPrice==null) sPrice = "&nbsp";
			  		if (sScheduleShipDate==null) sScheduleShipDate = "&nbsp";
			  		if (sShippingMethod==null) sShippingMethod = "&nbsp";
			  		if (sRemarks==null) sRemarks = "&nbsp";
					if (sCRD==null) sCRD ="&nbsp;"; //add by Peggy 20140109
%>
                <tr bgcolor="#FFFF99"> 
                <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("ORDER_NUMBER")%></font></div></td>
	 		    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("LINE_NUMBER")%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sItemDesc%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sCustomer%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sPO_No%></font></div></td>  
			    <td ><div align="right"><font color="#006666" face="Arial" size="2"><%=sQty%>&nbsp;</font></div></td>
			    <td ><div align="right"><font color="#006666" face="Arial" size="2"><%=sPrice%>&nbsp;</font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sScheduleShipDate%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sShippingMethod%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sCRD%></font></div></td>
			    <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sRemarks%></font></div></td>
			    <td ><div align="center"><font color="#CC3300" face="Arial" size="2"><%=rsI.getString("ERROR_EXPLANATION")%></font></div></td>
                </tr>
<%
		    	}  //end while
	        	rsI.close();
	        	stateI.close();
         	} 
%>            
            <tr><td colspan="12"><font color='#006666' face='Arial' size='3'>Data Count : <%=dataCount%> , Error Count : <%=cntError%> </font></td></tr> 
            </table>
<%            
	  	} 
	  	catch (Exception e) 
		{
			out.println("Exception display error data:"+e.getMessage());
	  	} 
   	}  

   	if (errorFlag=="N") 
	{
    	try 
		{     
        	String sOrder="",sLine="",sItemDesc="",sCustomer="",sPO_No="",sQty="",sScheduleShipDate="",sShippingMethod="",sRemarks="",sCRD="";
         	String sPO_No_RF, sQty_RF, sPrice_RF, sScheduleShipDate_RF, sShippingMethod_RF,sCRD_RF;
		 	String fcolor1, fcolor2, fcolor3, fcolor4, fcolor5,fcolor6, b1b, b1e, b2b, b2e, b3b, b3e, b4b, b4e, b5b, b5e,b6b,b6e;
		 	// 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
		 	String sQty_NC, sQty_Check;
		 	int k=1;

         	cntRevise=0;
	%>
	<table width="100%" border="0">
		<tr>
			<td>
	<%			
         	//String sqlP = "SELECT order_number, line_number, item_description, customer_name, customer_po_number,"+
		    //              " ordered_quantity, unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
			//			  " shipping_method_name, remarks, customer_po_number_rf, ordered_quantity_rf, unit_selling_price_rf,"+
			//			  " schedule_ship_date_rf, shipping_method_name_rf,"+
			//		      // 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
			//			  " ordered_quantity_nc"+
			//			  ",to_char(CUST_REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE"+ //add by Peggy 20140109
			//			  ",CUST_REQUEST_DATE_RF"+ //add by Peggy 20140109
			//	          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE "+
   			//	          " WHERE group_id = "+groupId+
    		//		      "   AND process_status = 3 "+
			//			  " UNION ALL"+  //add by Peggy 20160606,add by tsch order error message
			//			  " SELECT a.SO_NO order_number, a.LINE_NO line_number,  A.SOURCE_ITEM_DESC  item_description, B.ACCOUNT_NAME customer_name, "+
            //             " A.SOURCE_CUSTOMER_PO customer_po_number, A.SO_QTY ordered_quantity,  null unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
            //              " a.SHIPPING_METHOD shipping_method_name, null remarks, 'N' customer_po_number_rf, 'Y' ordered_quantity_rf,'N' unit_selling_price_rf,"+
            //              " 'Y' schedule_ship_date_rf, 'N' shipping_method_name_rf, NULL ordered_quantity_nc, to_char(REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE,'N' CUST_REQUEST_DATE_RF"+
            //             " FROM oraddman.tsc_om_salesorderrevise_temp a,HZ_CUST_ACCOUNTS B"+
            //              " WHERE GROUP_ID_REF ="+groupId+
            //              " and ERROR_MESSAGE is null"+
            //              " AND A.source_customer_id=B.CUST_ACCOUNT_ID";
			String sqlinf=" SELECT ORDER_NUMBER"+   //1
			              ",LINE_NUMBER"+           //2
						  ",ITEM_DESCRIPTION"+      //3
						  ",CUSTOMER_NAME"+         //4
						  ",CUSTOMER_PO_NUMBER "+   //5
                          ",ORDERED_QUANTITY"+      //6
                          ",UNIT_SELLING_PRICE"+    //7
                          ",to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date"+    //8
                          ",to_char(CUST_REQUEST_DATE,'YYYY/MM/DD') CUST_REQUEST_DATE"+     //9
                          ",SHIPPING_METHOD_NAME"+  //10
                          ",FOB_POINT"+             //11
                          ",PAYMENT_TERM_NAME"+     //12
                          ",HOLD_SHIPMENT"+         //13
                          ",HOLD_REASON"+           //14
                          ",to_char(OVERDUE_NEW_SSD,'YYYY/MM/DD') OVERDUE_NEW_SSD"+       //15
                          ",DELIVERY_INSTRUCTION"+  //16
                          ",TOTW_SHIPPING_METHOD"+  //17
                          ",TOTW_SHIPPING_REMARKS"+ //18
                          ",HOLD_NEW_SSD"+          //19
                          ",QUOTE_NUMBER"+          //20
                          ",END_CUSTOMER_NAME"+     //21
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND ORDERED_QUANTITY IS NOT NULL) QTY_CNT"+         //22
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND UNIT_SELLING_PRICE IS NOT NULL) PRICE_CNT"+     //23
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND SCHEDULE_SHIP_DATE IS NOT NULL) SSD_CNT"+       //24
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND CUST_REQUEST_DATE IS NOT NULL) CRD_CNT"+        //25
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND SHIPPING_METHOD_NAME IS NOT NULL) SHIP_METHOD_CNT"+  //26
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND FOB_POINT IS NOT NULL) FOB_CNT"+     //27
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND PAYMENT_TERM_NAME IS NOT NULL) PAYMENT_CNT"+    //28
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_SHIPMENT IS NOT NULL) HOLD_S_CNT"+         //29
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_REASON IS NOT NULL) HOLD_R_CNT"+           //30
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND OVERDUE_NEW_SSD IS NOT NULL) OVER_SSD_CNT"+     //31
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND DELIVERY_INSTRUCTION IS NOT NULL) DELIVERY_CNT"+   //32
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND TOTW_SHIPPING_METHOD IS NOT NULL) TOTW_SHIP_CNT"+  //33
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND TOTW_SHIPPING_REMARKS IS NOT NULL) TOTW_SHIP_R_CNT"+  //34
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_NEW_SSD IS NOT NULL) HOLD_SSD_CNT"+           //35
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND QUOTE_NUMBER IS NOT NULL) QUOTE_CNT"+            //37
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND END_CUSTOMER_NAME IS NOT NULL) END_CUST_CNT"+      //36
                          ",REMARKS"+
                          ",ERROR_EXPLANATION"+
						  ",REVISE_STATUS"+
                          ",ROW_NUMBER() OVER (ORDER BY ORDER_NUMBER ,LINE_NUMBER) ROW_SEQ"+
                          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE A"+
                          " WHERE group_id = ?"+
                          " AND process_status = ? "+
                          " ORDER BY ORDER_NUMBER ,LINE_NUMBER";
			PreparedStatement statement = con.prepareStatement(sqlinf);
			statement.setString(1,groupId);
			statement.setInt(2,3);
			statement.setString(3,groupId);
			statement.setInt(4,3);
			statement.setString(5,groupId);
			statement.setInt(6,3);
			statement.setString(7,groupId);
			statement.setInt(8,3);
			statement.setString(9,groupId);
			statement.setInt(10,3);
			statement.setString(11,groupId);
			statement.setInt(12,3);
			statement.setString(13,groupId);
			statement.setInt(14,3);
			statement.setString(15,groupId);
			statement.setInt(16,3);
			statement.setString(17,groupId);
			statement.setInt(18,3);
			statement.setString(19,groupId);
			statement.setInt(20,3);
			statement.setString(21,groupId);
			statement.setInt(22,3);
			statement.setString(23,groupId);
			statement.setInt(24,3);
			statement.setString(25,groupId);
			statement.setInt(26,3);
			statement.setString(27,groupId);
			statement.setInt(28,3);
			statement.setString(29,groupId);
			statement.setInt(30,3);
			statement.setString(31,groupId);
			statement.setInt(32,3);
			statement.setString(33,groupId);
			statement.setInt(34,3);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{	
				if (rs.getInt("ROW_SEQ")==1)
				{
				%>
				<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="left" bordercolorlight="#200025" border="1">
				<tr bgcolor="#CCCC66"> 
				 <td width="8%" height="20" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Order</div></td>
				 <td width="3%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Line</div></td>  
				 <td width="11%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Item Desc</div></td>  
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Customer</div></td>          
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">PO No</div></td>
				 <%
					for (int x =22 ; x<=37; x++)
				 	{
						if (rs.getInt(x)>0)
					 	{
					 %>
						 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=colName[x-22]%></div></td>
					 <%
					 	}
					}
				 %>
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Remarks</div></td>
				</tr>
				
				<%
				}
	        	if ((rs.getInt("ROW_SEQ") % 2) == 0) 
				{
	           		colorStr = "#D8E6E7";
				} 
				else 
				{
	           		colorStr = "#BBD3E1";
				}				
				%>	
				<tr bgcolor="<%=colorStr%>">
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=rs.getString("ORDER_NUMBER")%></div></td>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=rs.getString("LINE_NUMBER")%></div></td>  
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("ITEM_DESCRIPTION")==null?"&nbsp;":rs.getString("ITEM_DESCRIPTION"))%></div></td>  
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("CUSTOMER_NAME")==null?"&nbsp;":rs.getString("CUSTOMER_NAME"))%></div></td>          
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("CUSTOMER_PO_NUMBER")==null?"&nbsp;":rs.getString("CUSTOMER_PO_NUMBER"))%></div></td>
				 <%
					for (int x =22 ; x<=37; x++)
				 	{
						if (rs.getInt(x)>0)
					 	{
					 %>
						 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString(x-16)==null?"&nbsp;":rs.getString(x-16))%></div></td>
					 <%
					 	}
					}
				 %>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("REMARKS")==null?"&nbsp;":rs.getString("REMARKS"))%></div></td>
				</tr>
		<%		
				cntRevise++;			  
			}
			rs.close();
			statement.close();
	%>
			</table>
			</td>
		</tr>
	<%
			
         	String sqlP = " SELECT a.SO_NO order_number, a.LINE_NO line_number,  A.SOURCE_ITEM_DESC  item_description, B.ACCOUNT_NAME customer_name, "+
                          " A.SOURCE_CUSTOMER_PO customer_po_number, A.SO_QTY ordered_quantity,  null unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
                          " a.SHIPPING_METHOD shipping_method_name, null remarks, 'N' customer_po_number_rf, 'Y' ordered_quantity_rf,'N' unit_selling_price_rf,"+
                          " 'Y' schedule_ship_date_rf, 'N' shipping_method_name_rf, NULL ordered_quantity_nc, to_char(REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE,'N' CUST_REQUEST_DATE_RF"+
                          " FROM oraddman.tsc_om_salesorderrevise_temp a,HZ_CUST_ACCOUNTS B"+
                          " WHERE GROUP_ID_REF ="+groupId+
                          " and ERROR_MESSAGE is null"+
                          " AND A.source_customer_id=B.CUST_ACCOUNT_ID";
			//out.println(sqlP);
	     	Statement stateSh=con.createStatement();
         	ResultSet rsSh=stateSh.executeQuery(sqlP);
	     	while (rsSh.next()) 
			{
				if (i_cnt==0)
				{
%>
<hr>
<tr>
	<td>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  			  <tr bgcolor="#BBD3E1"  height="20"> 
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Order</font></div></td> 
  		       <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Line</font></div></td>           
 		       <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Item Desc</font></div></td> 
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Customer</font></div></td>
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">PO No</font></div></td>
			   <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Qty</font></div></td>
			   <td width="2%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">C</font></div></td>
			   <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Price</font></div></td>
			   <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Schedule<br>Ship Date</font></div></td>
			   <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Shipping<br>Method</font></div></td>
			   <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">CRD</font></div></td>
			   <td width="15%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Remarks</font></div></td>
              </tr>
<%
				}
            	sOrder=rsSh.getString("ORDER_NUMBER");
            	sLine=rsSh.getString("LINE_NUMBER");
            	sItemDesc=rsSh.getString("ITEM_DESCRIPTION");
            	sCustomer=rsSh.getString("CUSTOMER_NAME");
            	sPO_No=rsSh.getString("CUSTOMER_PO_NUMBER");
            	sQty=rsSh.getString("ORDERED_QUANTITY");
            	sPrice=rsSh.getString("UNIT_SELLING_PRICE");
            	sScheduleShipDate=rsSh.getString("SCHEDULE_SHIP_DATE");
            	sShippingMethod=rsSh.getString("SHIPPING_METHOD_NAME");
            	sRemarks=rsSh.getString("REMARKS");
            	sPO_No_RF=rsSh.getString("CUSTOMER_PO_NUMBER_RF");
            	sQty_RF=rsSh.getString("ORDERED_QUANTITY_RF");
            	sPrice_RF=rsSh.getString("UNIT_SELLING_PRICE_RF");
            	sScheduleShipDate_RF=rsSh.getString("SCHEDULE_SHIP_DATE_RF");
            	sShippingMethod_RF=rsSh.getString("SHIPPING_METHOD_NAME_RF");
		    	// 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
				sQty_NC=rsSh.getString("ORDERED_QUANTITY_NC");
				sCRD = rsSh.getString("CUST_REQUEST_DATE"); //add by Peggy 20140109
				sCRD_RF = rsSh.getString("CUST_REQUEST_DATE_RF"); //add by Peggy 20140109

				if (sItemDesc==null) sItemDesc = "&nbsp";
				if (sCustomer==null) sCustomer = "&nbsp";
				if (sPO_No==null) sPO_No = "&nbsp";
				if (sQty==null) sQty = "&nbsp";
				if (sPrice==null) sPrice = "&nbsp";
				if (sScheduleShipDate==null) sScheduleShipDate = "&nbsp";
				if (sShippingMethod==null) sShippingMethod = "&nbsp";
				if (sRemarks==null) sRemarks = "&nbsp";
				if (sCRD==null) sCRD ="&nbsp;"; //add by Peggy 20140109
		    	// 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
				sQty_Check = "&nbsp";

	        	if ((k % 2) == 0) 
				{
	           		colorStr = "#D8E6E7";
				} 
				else 
				{
	           		colorStr = "#BBD3E1";
				}
	        	if (sPO_No_RF == "Y" || sPO_No_RF.equals("Y")) 
				{
	          		fcolor1 = "#000000";
			  		b1b = "<b>";
			  		b1e = "</b>";
				} 
				else 
				{
	          		fcolor1 = "#006666";
			  		b1b = "";
			  		b1e = "";
				}
		   
		   		// 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
	        	if (sQty_NC != null && (sQty_NC == "Y" || sQty_NC.equals("Y"))) 
				{
	          		fcolor2 = "#FF0000";
			  		b2b = "<b>";
			  		b2e = "</b>";
			  		sQty_Check = "<INPUT TYPE=checkbox NAME=CH VALUE='"+sOrder+"|"+sLine+"'>";
	        	} 
				else if (sQty_RF == "Y" || sQty_RF.equals("Y")) 
				{
	          		fcolor2 = "#000000";
			  		b2b = "<b>";
			  		b2e = "</b>";
				} 
				else 
				{
	          		fcolor2 = "#006666";
			  		b2b = "";
			  		b2e = "";
				}
	        	if (sPrice_RF == "Y" || sPrice_RF.equals("Y")) 
				{
	          		fcolor3 = "#000000";
			  		b3b = "<b>";
			  		b3e = "</b>";
				} 
				else 
				{
	          		fcolor3 = "#006666";
			  		b3b = "";
			  		b3e = "";
				}
	        	if (sScheduleShipDate_RF == "Y" || sScheduleShipDate_RF.equals("Y")) 
				{
	          		fcolor4 = "#000000";
			  		b4b = "<b>";
			  		b4e = "</b>";
				} 
				else 
				{
	          		fcolor4 = "#006666";
			  		b4b = "";
			  		b4e = "";
				}
	        	if (sShippingMethod_RF == "Y" || sShippingMethod_RF.equals("Y")) 
				{
	          		fcolor5 = "#000000";
			  		b5b = "<b>";
			  		b5e = "</b>";
				} 
				else 
				{
	          		fcolor5 = "#006666";
			  		b5b = "";
			  		b5e = "";
				}

	        	if (sCRD_RF == "Y" || sCRD_RF.equals("Y")) 
				{
	          		fcolor6 = "#000000";
			  		b6b = "<b>";
			  		b6e = "</b>";
				} 
				else 
				{
	          		fcolor6 = "#006666";
			  		b6b = "";
			  		b6e = "";
				}
%>
              <tr bgcolor="<%=colorStr%>" height="20"> 
               <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sOrder%></font></div></td>
	 		   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sLine%></font></div></td>
			   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sItemDesc%></font></div></td>
			   <td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sCustomer%></font></div></td>
			   <td ><div align="center"><font color="<%=fcolor1%>" face="Arial" size="2"><%=b1b%><%=sPO_No%><%=b1e%></font></div></td>
			   <td ><div align="right"><font color="<%=fcolor2%>" face="Arial" size="2"><%=b2b%><%=sQty%>&nbsp;<%=b2e%></font></div></td>
               <td ><div align="center"></div><%=sQty_Check%></td>
			   <td ><div align="right"><font color="<%=fcolor3%>" face="Arial" size="2"><%=b3b%><%=sPrice%>&nbsp;<%=b3e%></font></div></td>
			   <td ><div align="center"><font color="<%=fcolor4%>" face="Arial" size="2"><%=b4b%><%=sScheduleShipDate%><%=b4e%></font></div></td>
			   <td ><div align="center"><font color="<%=fcolor5%>" face="Arial" size="2"><%=b5b%><%=sShippingMethod%><%=b5e%></font></div></td>
			   <td ><div align="center"><font color="<%=fcolor6%>" face="Arial" size="2"><%=b6b%><%=sCRD%><%=b6e%></font></div></td>
			   <td ><div align="left"><font color="#006666" face="Arial" size="2"><%=sRemarks%></font></div></td>
              </tr>
<%
            	k++; //項次使用
				cntRevise++;
				i_cnt++;
         	} //END while(rsSh.next())
	     	rsSh.close();
    	 	stateSh.close();
      	} // end of try
	  	catch (Exception e) 
		{
			out.println("Exception display:"+e.getMessage());		  
	     	errorFlag="Y";
	  	}
		if (i_cnt>0)
		{
		%>
			</table></td></tr>
		<%
		}
%>
           <tr><td>
<%
      	if ((errorFlag=="N" || errorFlag.equals("N")) && cntRevise>0) 
		{ 
%>   
         <input type='button' name='IMPORT' size='20' value='    REVISE   ' onClick='setDataRevise("../jsp/TSCSalesOrderReviseInsert.jsp?PTYPE=2&GROUP_ID=<%=groupId%>")'> 
<%    
		}
%>
      <input type='button' name='ABORT' size='20' value='   CANCEL   ' onClick='setDataReset("../jsp/TSCSalesOrderReviseInsert.jsp?PTYPE=3&GROUP_ID=<%=groupId%>")'>
               </td>
           </tr>
  </table>
<%

   	}  // end if (errorFlag=="N")
} //  end if (pType=1) 

if (pType == "2" || pType.equals("2")) 
{  // REVISE
	try 
	{
    	String sqlid = " SELECT erp_user_id FROM ORADDMAN.WSUSER"+
 					 "  WHERE UPPER(USERNAME) = trim(upper('"+UserName+"')) " ;
	  	Statement stateid=con.createStatement();
      	ResultSet rsid=stateid.executeQuery(sqlid);
	  	if (rsid.next())
		{ 	
        	loginUserId=rsid.getInt("ERP_USER_ID");
      	}
	  	rsid.close();
      	stateid.close(); 
   	}
   	catch (Exception e) 
	{
		out.println("Exception get erp_user_id:"+e.getMessage());
	  	errorFlag="Y";
   	} 

   	// Revise order
   	if (errorFlag=="N") 
	{
    	try  
		{
			// 20110524 Marvie Add : Qty is more than 5 multiple , need confrim
		 	String sqlQtyCF, sOrder, sLine;
         	String [] choice=request.getParameterValues("CH");
         	if (choice != null) 
			{
           		for (int k=0;k<choice.length;k++) 
				{
		     		sOrder = choice[k].substring(0,choice[k].indexOf("|"));
		     		sLine = choice[k].substring(choice[k].indexOf("|")+1);
		     		sqlQtyCF = "UPDATE ORADDMAN.TSC_OM_SALESORDERREVISE"+
						  " SET ordered_quantity_cf = 'Y'"+
					    " WHERE group_id = "+groupId+
					      " AND order_number = "+sOrder+
						  " AND line_number = '"+sLine+"' ";
             		PreparedStatement psQtyCF=con.prepareStatement(sqlQtyCF);
             		psQtyCF.executeUpdate();
		   		}  // end for
		 	}  // end if (choice != null)

         	String Errbuf="",Retcode="";
		 	CallableStatement cs4 = con.prepareCall("{call TSC_OM_SO_REVISE_PKG.revise_order(?,?,?,3,?)}");
		 	cs4.registerOutParameter(1, Types.VARCHAR);    // return Errbuf
		 	cs4.registerOutParameter(2, Types.VARCHAR);    // return Retcode
		 	cs4.setInt(3,Integer.parseInt(groupId));       // group_id
		 	cs4.setInt(4, loginUserId);                    // user_id
		 	cs4.execute();
		 	Errbuf = cs4.getString(1);                     // return Errbuf
		 	Retcode = cs4.getString(2);                    // return Retcode
		 	cs4.close();

			//add by Peggy 20140108
			String sql = " SELECT a.sold_to_org_id,a.order_number,b.cust_po_number,b.customer_shipment_number "+
                         " FROM ONT.OE_ORDER_HEADERS_ALL a,ONT.OE_ORDER_LINES_ALL b,ORADDMAN.TSC_OM_SALESORDERREVISE c "+
                         " WHERE c.GROUP_ID=?"+
                         " AND c.PROCESS_STATUS=?"+
                         " AND a.HEADER_ID = b.HEADER_ID "+
                         " AND b.HEADER_ID = c.HEADER_ID "+
                         " AND b.LINE_ID = c.LINE_ID";
			PreparedStatement state1 = con.prepareStatement(sql);
			state1.setString(1,groupId);
			state1.setString(2,"4");
			ResultSet rs1=state1.executeQuery();
			while (rs1.next())
			{
				if (rs1.getString("order_number").substring(0,4).equals("1214"))
				{
					sql = " select distinct a.version_id from oraddman.tsce_purchase_order_headers a,oraddman.tsce_purchase_order_lines b"+
					      " where a.erp_customer_id =?"+
						  " and a.customer_po=?"+
						  " and a.customer_po = b.customer_po"+
						  " and a.version_id = b.version_id"+
						  " and b.po_line_no = ?"+
						  " and b.data_flag=?";
					PreparedStatement state2 = con.prepareStatement(sql);
					state2.setString(1,rs1.getString("sold_to_org_id"));
					state2.setString(2,rs1.getString("cust_po_number"));
					state2.setString(3,rs1.getString("customer_shipment_number"));
					state2.setString(4,"E");
					ResultSet rs2=state2.executeQuery();
					while (rs2.next())
					{
						sql = " update oraddman.tsce_purchase_order_lines a"+
							  " set a.DATA_FLAG=?"+
							  " where CUSTOMER_PO=?"+
							  " AND VERSION_ID=?"+
							  " and a.PO_LINE_NO=?";
						PreparedStatement pstmt3=con.prepareStatement(sql);
						pstmt3.setString(1,"Y");
						pstmt3.setString(2,rs1.getString("cust_po_number"));
						pstmt3.setString(3,rs2.getString("version_id"));
						pstmt3.setString(4,rs1.getString("customer_shipment_number"));
						pstmt3.executeUpdate();		
						pstmt3.close();	
					}
					rs2.close();
	   				state2.close();
				}
				else
				{
					sql = " select distinct a.REQUEST_NO  from  tsc_edi_orders_his_h a,tsc_edi_orders_his_d b"+
					      " where a.ERP_CUSTOMER_ID =?"+
                          " and a.customer_po =?"+
						  " and a.request_no = b.request_no"+
						  " and a.erp_customer_id = b.erp_customer_id"+
						  " and b.CUST_PO_LINE_NO=?"+
						  " and b.data_flag=?";
					PreparedStatement state2 = con.prepareStatement(sql);
					state2.setString(1,rs1.getString("sold_to_org_id"));
					state2.setString(2,rs1.getString("cust_po_number"));
					state2.setString(3,rs1.getString("customer_shipment_number"));
					state2.setString(4,"N");
					ResultSet rs2=state2.executeQuery();
					while (rs2.next())
					{
						sql = " delete tsc_edi_orders_detail a"+
							  " where a.erp_customer_id=?"+
							  " and a.customer_po=?"+
							  " and a.version_id=?"+
							  " and a.cust_po_line_no =?";
						//out.println(sql);
						PreparedStatement pstmt1=con.prepareStatement(sql);
						pstmt1.setString(1,rs1.getString("sold_to_org_id"));
						pstmt1.setString(2,rs1.getString("cust_po_number"));
						pstmt1.setString(3,"0");
						pstmt1.setString(4,rs1.getString("customer_shipment_number"));
						pstmt1.executeUpdate();		
						pstmt1.close();		
							  
						sql = " insert into tsc_edi_orders_detail (erp_customer_id, customer_po, version_id,"+
							  " cust_po_line_no, seq_no, cust_item_name, tsc_item_name,"+
							  " quantity, uom, unit_price, cust_request_date,creation_date,orig_cust_item_name,orig_tsc_item_name)"+  //add orig_cust_item_name  by Peggy 20181222
							  " SELECT a.erp_customer_id, b.customer_po,?,a.cust_po_line_no,a.cust_po_line_no||'.'||row_number() over (partition by a.cust_po_line_no order by a.seq_no) seq_no,"+
							  " a.cust_item_name, a.tsc_item_name, a.quantity, a.uom,"+
							  " a.unit_price, a.cust_request_date, sysdate,a.orig_cust_item_name,a.orig_tsc_item_name"+  //add orig_cust_item_name by Peggy 20181222
							  " FROM tsc_edi_orders_his_d a,tsc_edi_orders_his_h b"+
							  " where a.request_no=b.request_no"+
							  " and a.erp_customer_id=b.erp_customer_id"+
							  " and a.request_no=?"+
							  " and a.erp_customer_id=?"+
							  " and b.customer_po=?"+
							  " and a.cust_po_line_no =?"+
							  " and a.ACTION_CODE<>'2'";
						//out.println(sql);
						PreparedStatement pstmt2=con.prepareStatement(sql);
						pstmt2.setString(1,"0");
						pstmt2.setString(2,rs2.getString("request_no"));
						pstmt2.setString(3,rs1.getString("sold_to_org_id"));
						pstmt2.setString(4,rs1.getString("cust_po_number"));
						pstmt2.setString(5,rs1.getString("customer_shipment_number"));
						pstmt2.executeUpdate();		
						pstmt2.close();		
						
						sql = " update tsc_edi_orders_his_d a"+
							  " set a.DATA_FLAG=?"+
							  ",LAST_UPDATED_BY=?"+        //add by Peggy 20150127
							  ",LAST_UPDATE_DATE=sysdate"+ //add by Peggy 20150127
							  " where a.REQUEST_NO=?"+
							  " and a.ERP_CUSTOMER_ID=?"+
							  " and a.CUST_PO_LINE_NO=?";
						PreparedStatement pstmt3=con.prepareStatement(sql);
						pstmt3.setString(1,"Y");
						pstmt3.setString(2,UserName);  //add by Peggy 20150127
						pstmt3.setString(3,rs2.getString("request_no"));
						pstmt3.setString(4,rs1.getString("sold_to_org_id"));
						pstmt3.setString(5,rs1.getString("customer_shipment_number"));
						pstmt3.executeUpdate();		
						pstmt3.close();	
					}												 
					rs2.close();
	   				state2.close();					
				}
			}
			rs1.close();
			state1.close();
			
         	if (Errbuf!=null) 
			{
		    	out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Revise order fail </FONT></TD><TD colspan=3>"+Errbuf+"("+Retcode+")"+"</TD></TR>");	
	        	errorFlag="Y";
         	}
	  	} // end of try
	  	catch (Exception e) 
		{
			out.println("Exception revise:"+e.getMessage());
	     	errorFlag="Y";
	  	}
   	}  // end if (errorFlag=="N")

   	if (errorFlag=="N") 
	{
	%>
	<table width="100%" border="0">
		<tr>
			<td>
	<%
    	try 
		{
			//String sqlinf=" SELECT order_number, line_number, item_description, customer_name, customer_po_number,"+
		    //              " ordered_quantity, unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
			//			  " shipping_method_name, remarks, revise_status, error_explanation"+
			//			  ",to_char(CUST_REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE"+ //add by Peggy 20140109
			//	          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE "+
   			//	          " WHERE group_id = "+groupId+
    		//		      " AND process_status = 4 ";
			String sqlinf=" SELECT ORDER_NUMBER"+   //1
			              ",LINE_NUMBER"+           //2
						  ",ITEM_DESCRIPTION"+      //3
						  ",CUSTOMER_NAME"+         //4
						  ",CUSTOMER_PO_NUMBER "+   //5
                          ",ORDERED_QUANTITY"+      //6
                          ",UNIT_SELLING_PRICE"+    //7
                          ",to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date"+    //8
                          ",to_char(CUST_REQUEST_DATE,'YYYY/MM/DD') CUST_REQUEST_DATE"+     //9
                          ",SHIPPING_METHOD_NAME"+  //10
                          ",FOB_POINT"+             //11
                          ",PAYMENT_TERM_NAME"+     //12
                          ",HOLD_SHIPMENT"+         //13
                          ",HOLD_REASON"+           //14
                          ",to_char(OVERDUE_NEW_SSD,'YYYY/MM/DD') OVERDUE_NEW_SSD"+       //15
                          ",DELIVERY_INSTRUCTION"+  //16
                          ",TOTW_SHIPPING_METHOD"+  //17
                          ",TOTW_SHIPPING_REMARKS"+ //18
                          ",HOLD_NEW_SSD"+          //19
                          ",QUOTE_NUMBER"+          //20
                          ",END_CUSTOMER_NAME"+     //21
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND ORDERED_QUANTITY IS NOT NULL) QTY_CNT"+         //22
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND UNIT_SELLING_PRICE IS NOT NULL) PRICE_CNT"+     //23
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND SCHEDULE_SHIP_DATE IS NOT NULL) SSD_CNT"+       //24
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND CUST_REQUEST_DATE IS NOT NULL) CRD_CNT"+        //25
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND SHIPPING_METHOD_NAME IS NOT NULL) SHIP_METHOD_CNT"+  //26
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND FOB_POINT IS NOT NULL) FOB_CNT"+     //27
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND PAYMENT_TERM_NAME IS NOT NULL) PAYMENT_CNT"+    //28
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_SHIPMENT IS NOT NULL) HOLD_S_CNT"+         //29
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_REASON IS NOT NULL) HOLD_R_CNT"+           //30
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND OVERDUE_NEW_SSD IS NOT NULL) OVER_SSD_CNT"+     //31
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND DELIVERY_INSTRUCTION IS NOT NULL) DELIVERY_CNT"+   //32
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND TOTW_SHIPPING_METHOD IS NOT NULL) TOTW_SHIP_CNT"+  //33
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND TOTW_SHIPPING_REMARKS IS NOT NULL) TOTW_SHIP_R_CNT"+  //34
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND HOLD_NEW_SSD IS NOT NULL) HOLD_SSD_CNT"+           //35
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND QUOTE_NUMBER IS NOT NULL) QUOTE_CNT"+            //37
						  ",(SELECT COUNT(1) FROM ORADDMAN.TSC_OM_SALESORDERREVISE WHERE group_id = ? AND process_status = ? AND END_CUSTOMER_NAME IS NOT NULL) END_CUST_CNT"+      //36
                          ",REMARKS"+
                          ",ERROR_EXPLANATION"+
						  ",REVISE_STATUS"+
                          ",ROW_NUMBER() OVER (ORDER BY ORDER_NUMBER ,LINE_NUMBER) ROW_SEQ"+
                          " FROM ORADDMAN.TSC_OM_SALESORDERREVISE A"+
                          " WHERE group_id = ?"+
                          " AND process_status = ? "+
                          " ORDER BY ORDER_NUMBER ,LINE_NUMBER";
			PreparedStatement statement = con.prepareStatement(sqlinf);
			statement.setString(1,groupId);
			statement.setInt(2,4);
			statement.setString(3,groupId);
			statement.setInt(4,4);
			statement.setString(5,groupId);
			statement.setInt(6,4);
			statement.setString(7,groupId);
			statement.setInt(8,4);
			statement.setString(9,groupId);
			statement.setInt(10,4);
			statement.setString(11,groupId);
			statement.setInt(12,4);
			statement.setString(13,groupId);
			statement.setInt(14,4);
			statement.setString(15,groupId);
			statement.setInt(16,4);
			statement.setString(17,groupId);
			statement.setInt(18,4);
			statement.setString(19,groupId);
			statement.setInt(20,4);
			statement.setString(21,groupId);
			statement.setInt(22,4);
			statement.setString(23,groupId);
			statement.setInt(24,4);
			statement.setString(25,groupId);
			statement.setInt(26,4);
			statement.setString(27,groupId);
			statement.setInt(28,4);
			statement.setString(29,groupId);
			statement.setInt(30,4);
			statement.setString(31,groupId);
			statement.setInt(32,4);
			statement.setString(33,groupId);
			statement.setInt(34,4);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{	
				if (rs.getInt("ROW_SEQ")==1)
				{
				%>
				<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="left" bordercolorlight="#200025" border="1">
				<tr bgcolor="#CCCC66"> 
				 <td width="8%" height="20" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Order</div></td>
				 <td width="3%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Line</div></td>  
				 <td width="11%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Item Desc</div></td>  
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">Customer</div></td>          
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;text-align:center">PO No</div></td>
				 <%
					for (int x =22 ; x<=37; x++)
				 	{
						if (rs.getInt(x)>0)
					 	{
					 %>
						 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=colName[x-22]%></div></td>
					 <%
					 	}
					}
				 %>
				 <td width="8%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;">Remarks</div></td>
				 <td width="5%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;">Revise<br>Status</div></td>	
				 <td width="10%" nowrap><div style="font-size:12px;font-family:arial;color:#000066;">Error Explanation</div></td>	
				</tr>
				
				<%
				}
				%>	
				<tr>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=rs.getString("ORDER_NUMBER")%></div></td>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=rs.getString("LINE_NUMBER")%></div></td>  
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("ITEM_DESCRIPTION")==null?"&nbsp;":rs.getString("ITEM_DESCRIPTION"))%></div></td>  
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("CUSTOMER_NAME")==null?"&nbsp;":rs.getString("CUSTOMER_NAME"))%></div></td>          
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("CUSTOMER_PO_NUMBER")==null?"&nbsp;":rs.getString("CUSTOMER_PO_NUMBER"))%></div></td>
				 <%
					for (int x =22 ; x<=37; x++)
				 	{
						if (rs.getInt(x)>0)
					 	{
					 %>
						 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString(x-16)==null?"&nbsp;":rs.getString(x-16))%></div></td>
					 <%
					 	}
					}
				 %>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("REMARKS")==null?"&nbsp;":rs.getString("REMARKS"))%></div></td>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=rs.getString("REVISE_STATUS")%></div></td>
				 <td nowrap><div style="font-size:12px;font-family:arial;color:#000066;"><%=(rs.getString("ERROR_EXPLANATION")==null?"&nbsp;":rs.getString("ERROR_EXPLANATION"))%></div></td>
				</tr>
		<%					  
			}
			rs.close();
			statement.close();
	%>
			</table>
		</td>
	</tr>
<%		
        	sqlinf= " SELECT A.SO_NO order_number,A.LINE_NO line_number,A.SOURCE_ITEM_DESC item_description,B.ACCOUNT_NAME customer_name, A.SOURCE_CUSTOMER_PO customer_po_number,"+
                    " A.SO_QTY ordered_quantity, null unit_selling_price, to_char(schedule_ship_date,'YYYY/MM/DD') schedule_ship_date,"+
                    " null shipping_method_name,null remarks, case when ERROR_MESSAGE is null then 'Success' else 'fail' end revise_status, ERROR_MESSAGE error_explanation"+
                    ",to_char(a.REQUEST_DATE,'yyyy/mm/dd') CUST_REQUEST_DATE"+
                    " FROM oraddman.tsc_om_salesorderrevise_tsch  A,HZ_CUST_ACCOUNTS B"+
                    " WHERE GROUP_ID_REF = "+groupId+
                    " AND A.source_customer_id=B.CUST_ACCOUNT_ID"+
					" order by A.SO_NO,A.LINE_NO";
			//out.println(sqlinf);
	     	Statement stateinf=con.createStatement();
         	ResultSet rsinf=stateinf.executeQuery(sqlinf);

         	String sItemDesc="",sCustomer="",sPO_No="",sQty="",sScheduleShipDate="",sShippingMethod="",sRemarks="",errorExplanation="",sCRD="";
			i_cnt=0;
	     	while (rsinf.next()) 
			{
				if (i_cnt==0)
				{
%>
	<tr>
		<td>
	    <table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="left" bordercolorlight="#200025" border="1">
  	    <tr bgcolor="#CCCC66"> 
	     <td width="9%" height="20" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Order</font></div></td>
  	     <td width="4%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Line</font></div></td>  
  	     <td width="11%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Item Desc</font></div></td>  
  	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Customer</font></div></td>          
	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">PO No</font></div></td>
   	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Qty</font></div></td>
   	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Price</font></div></td>
   	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Schedule<br>Ship Date</font></div></td>
	     <td width="5%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Shipping<br>Method</font></div></td>	
   	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">CRD</font></div></td>
	     <td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Remarks</font></div></td>
	     <td width="5%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Revise<br>Status</font></div></td>	
	     <td width="10%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">Error Explanation</font></div></td>	
        </tr>
<%	
				}
						
				sItemDesc = rsinf.getString("ITEM_DESCRIPTION");
				sCustomer = rsinf.getString("CUSTOMER_NAME");
				sPO_No = rsinf.getString("CUSTOMER_PO_NUMBER");
				sQty = rsinf.getString("ORDERED_QUANTITY");
				sPrice = rsinf.getString("UNIT_SELLING_PRICE");
				sScheduleShipDate = rsinf.getString("SCHEDULE_SHIP_DATE");
				sShippingMethod = rsinf.getString("SHIPPING_METHOD_NAME");
				sRemarks = rsinf.getString("REMARKS");
		    	errorExplanation = rsinf.getString("ERROR_EXPLANATION");
				sCRD = rsinf.getString("CUST_REQUEST_DATE");
				if (sItemDesc==null) sItemDesc = "&nbsp";
				if (sCustomer==null) sCustomer = "&nbsp";
				if (sPO_No==null) sPO_No = "&nbsp";
				if (sQty==null) sQty = "&nbsp";
				if (sPrice==null) sPrice = "&nbsp";
				if (sScheduleShipDate==null) sScheduleShipDate = "&nbsp";
				if (sShippingMethod==null) sShippingMethod = "&nbsp";
				if (sRemarks==null) sRemarks = "&nbsp";
            	if (errorExplanation==null || errorExplanation.equals("null")) errorExplanation="&nbsp";
				if (sCRD==null) sCRD="&nbsp;";
				i_cnt++;
%>
          <tr bgColor='#FFFFFF' > 
           <td ><div align="center"><font color="" face="Arial" size="2"><%=rsinf.getString("ORDER_NUMBER")%></font></div></td>
	       <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("LINE_NUMBER")%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sItemDesc%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sCustomer%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sPO_No%></font></div></td>  
		   <td ><div align="right"><font color="#000066" face="Arial" size="2"><%=sQty%>&nbsp;</font></div></td>
		   <td ><div align="right"><font color="#000066" face="Arial" size="2"><%=sPrice%>&nbsp;</font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sScheduleShipDate%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sShippingMethod%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sCRD%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=sRemarks%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("REVISE_STATUS")%></font></div></td>
		   <td ><div align="center"><font color="#000066" face="Arial" size="2"><%=errorExplanation%></font></div></td>
          </tr>
<%       	
		} //end while rsinf.next()
		
		if(i_cnt>0)
		{
%>
</table></td></tr>
		<%
		}
		%>
		</table>
		<%
         	rsinf.close();
	     	stateinf.close();
	  	}	// End of try
	  	catch (Exception e) 
		{
	    	out.println("Exception display:"+e.getMessage());
	     	errorFlag="Y";
	  	}	
   	}  // end if (errorFlag=="N")
 
}  // end if pType=='2' 

if (pType == "3" || pType.equals("3")) 
{   // CANCEL
	String sqld = "delete from ORADDMAN.TSC_OM_SALESORDERREVISE where group_id = "+groupId+"  ";
  	PreparedStatement seqstmtd=con.prepareStatement(sqld);
  	seqstmtd.executeUpdate();
   	seqstmtd.close(); 	
   	response.sendRedirect("../jsp/TSCSalesOrderReviseUpload.jsp");
}  // end if pType=='3'

%>

</FORM>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
