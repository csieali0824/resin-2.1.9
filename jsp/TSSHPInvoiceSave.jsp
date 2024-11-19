<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->
<script language="JavaScript" type="text/JavaScript">

</script>
<html>
<head>
<title>Invoice Save Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="shpArray2DTemporaryBean" scope="session" class="Array2DimensionInputBean"/> <!---->
<jsp:useBean id="shpArray2DPageBean" scope="page" class="Array2DimensionInputBean"/> <!---->
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<style type="text/css">
<!--
.style2 {font-family: Arial, Helvetica, sans-serif}
.style7 {color: #3333FF}
-->
</style>
</head>
<body>
<FORM ACTION="TSSHPInvoiceSave.jsp" METHOD="post" NAME="MYFORM">
<%

  String customerId=request.getParameter("CUSTOMERID");
  String customerNo=request.getParameter("CUSTOMERNO");
  String customerName=request.getParameter("CUSTOMERNAME");
  String salesAreaNo=request.getParameter("SALESAREANO");
  String salesOrderNo=request.getParameter("SALESORDERNO");
  String shipFromOrgId=request.getParameter("SHIP_FROM_ORG_ID");
  String status=request.getParameter("STATUS");
   String ShipToOrg = request.getParameter("SHIPTOORG"); 
   String shipAddress = request.getParameter("SHIPADDRESS");
   String shipCountry = request.getParameter("SHIPCOUNTRY"); 
   String line_No=request.getParameter("LINE_NO");
   String shipTo = request.getParameter("SHIPTO");
   String billTo = request.getParameter("BILLTO");     
   String shipMethod = request.getParameter("SHIPMETHOD");
   String fobPoint = request.getParameter("FOBPOINT");
   String paymentTerm = request.getParameter("PAYTERM");
   String payTermID = request.getParameter("PAYTERMID");
   String custItemNo = request.getParameter("ORDERED_ITEM");
   String [] check=request.getParameterValues("CHKFLAG");
   String rcv_Qty = request.getParameter("RCV_QTY");
   String tsInvoiceNo = request.getParameter("TSINVOICENO"); 
   String shipDate = request.getParameter("SHIPDATE");
   String headerId = request.getParameter("HEADER_ID");   
   String lineId = request.getParameter("LINE_ID");  
   String inventoryItemId = request.getParameter("INVENTORY_ITEM_ID"); 
   String invItem=request.getParameter("INV_ITEM");   
   String itemDesc = request.getParameter("ITEM_DESC");    
   String poNum = request.getParameter("PO_NUM");   
   String poHeaderId = request.getParameter("PO_HEADER_ID");     
   String lineLocationId = request.getParameter("LINE_LOCATION_ID");     
   String poLineId = request.getParameter("PO_LINE_ID");         
   String poUom = request.getParameter("PO_UOM");
   
   
   String errorMessageHeader ="";
   String processStatus="";
   
   String ashpTemporaryCode[][]=shpArray2DTemporaryBean.getArray2DContent();//取得shpArray2DTemporaryBean目前陣列內容
   String packInsue=request.getParameter("PACKINSUE");
   String taxCode=request.getParameter("TAXCODE");
   String unitPrice=request.getParameter("UNITPRICE");
   String taxRate=request.getParameter("TAXRATE");
   String ccCode=request.getParameter("CCCODE");    
   String currCode=request.getParameter("CURR_CODE");  
   String itemCount=request.getParameter("ITEMCOUNT");   
   String countInv = request.getParameter("COUNTINV"); 
   String tempInvoice = "0"; 
   int createById=0;  // userid 
   int dsHeaderId=0;
   int dsLineId=0;
   int employeeId=0;
        
		
   String YearFr=dateBean.getYearMonthDay().substring(0,4);
   String MonthFr=dateBean.getYearMonthDay().substring(4,6);
   String DayFr=dateBean.getYearMonthDay().substring(6,8);

   if (itemCount==null) itemCount = "0";
   if (shipMethod==null ) shipMethod="";
  
java.sql.Date shippingDate = null;

	    		                       		    		  	   


 java.sql.Date createDate = new java.sql.Date(Integer.parseInt(dateBean.getYearString())-1900,Integer.parseInt(dateBean.getMonthString())-1,Integer.parseInt(dateBean.getDayString()));  // 給creation Date
 if (shipDate!=null && shipDate.length()>=8)
 {
   shippingDate = new java.sql.Date(Integer.parseInt(shipDate.substring(0,4))-1900,Integer.parseInt(shipDate.substring(4,6))-1,Integer.parseInt(shipDate.substring(6,8)));  // 給Shipping Date
 }
 
 
      CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	  cs1.setString(1,"41");
	  cs1.execute();
      //out.println("Procedure : Execute Success !!! ");
      cs1.close();
	  
String a[][]=shpArray2DTemporaryBean.getArray2DContent();//取得前頁陣列內容 
int k=0;
     String oneDArray[]= {"","Sales Order No.","Line No.","Ship Q'ty","Customer ID","Customer No.","Customer Name.","Ship To Org.","Ship To Addr.","Shipping Method","FOB","Payment Term","Header ID","Line ID","Line No.","Inventory Item ID","Inventory Item","Item Description","PO Header ID","PO No.","PO Line ID","Line Location ID","UOM","Ordered Item","Bill To","Organization_id","CUST_PO_NUMBER"};
     shpArray2DPageBean.setArrayString(oneDArray);	
	// String r[][]=new String[Integer.parseInt(itemCount)+1][25];
	 String r[][]=new String[a.length][26];
	 
	 //out.println("a.length="+a.length);
	 //out.println(a[0][0]+" "+a[0][1]+" "+ a[0][2]);
	 //out.println(a[1][0]+" "+a[1][1]+" "+ a[1][2]);

//for (int i=0;i<a.length-1;i++) // 將陣列內容取出
for (int i=0;i<a.length;i++) // 將陣列內容取出
{  //out.println("Step:RESPONDING_1="+aFactoryArrangedCode[i][6]); 
 try
 {

//out.print("tsInvoiceNo="+tsInvoiceNo);

 String     sSql = " select A.ORDER_NUM, A.HEADER_ID,A.LINE_NUM,A.LINE_ID,A.ORDERED_ITEM, C.SEGMENT1 as INV_ITEM,C.INVENTORY_ITEM_ID, "+
 	    " 	     C.DESCRIPTION as ITEM_DESC,B.UOM,A.UNSHIP_QTY,  B.UNDELIVERY_QTY, "+
		" 	     A.CONVERSION_TYPE_CODE,  A.SHIPTOORG,a.CUSTOMERNAME,A.SHIPTOADDR, "+
		"        A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM,A.CUSTOMERID,A.CUSTOMERNO,A.SELECTFLAG,A.BILLTO,A.SHIP_FROM_ORG_ID,A.CUST_PO_NUMBER, " +
		"        B.PO_HEADER_ID,B.PO_NUM,B.PO_LINE_ID,b.line_location_id, B.UNDELIVERY_QTY-NVL(D.RCVQTY,0) as ALLOWQTY	   ";
		
 String sFrom1 = "from   "+
 "                 (select OOH.ORDER_NUMBER as ORDER_NUM,OOH.HEADER_ID,OOH.SHIP_FROM_ORG_ID,OOL.LINE_NUMBER as LINE_NUM, "+   
 "                         OOL.ORDERED_ITEM,OOL.INVENTORY_ITEM_ID,OOL.ORDER_QUANTITY_UOM as UOM,   "+
 "  	                    sum(OOL.ORDERED_QUANTITY) as ORDER_QTY,nvl(sum(OOL.SHIPPED_QUANTITY),0) as SHIP_QTY,  "+  
 "  	                    sum(OOL.ORDERED_QUANTITY)-nvl(sum(OOL.SHIPPED_QUANTITY),0) UNSHIP_QTY,   "+
 "                         ODS.PO_HEADER_ID ,ODS.LINE_LOCATION_ID,OOH.CUSTOMER_NUMBER as CUSTOMERNO,    "+
 "  		                OOH.CONVERSION_TYPE_CODE, OOH.SOLD_TO_ORG_ID as CUSTOMERID,OOH.SOLD_TO as CUSTOMERNAME, OOH.ORDER_NUMBER||'-'|| OOL.LINE_NUMBER as SELECTFLAG,  "+
 "  	                    OOL.LINE_ID,OOH.SHIP_TO_ORG_ID as SHIPTOORG,OOH.SHIPPING_METHOD_CODE as SHIPMETHOD,OOH.FOB_POINT_CODE as FOBPOINT,OOH.TERMS as PAYTERM,   "+
 " 						OOH.SHIP_TO_ADDRESS1 as SHIPTOADDR,OOH.INVOICE_TO_LOCATION as BILLTO,OOL.CUST_PO_NUMBER "+
 "                  from OE_ORDER_HEADERS_V OOH,OE_ORDER_LINES_ALL OOL,OE_DROP_SHIP_SOURCES ODS "+
 "                  where  OOH.HEADER_ID=OOL.HEADER_ID   "+
 "                         and ODS.LINE_ID=OOL.LINE_ID   "+
 "  	                    and OOL.CANCELLED_FLAG !='Y'   "+
 "  		                and OOL.FLOW_STATUS_CODE != 'CLOSED'    "+
 "							and to_char(OOH.ORDER_NUMBER)='"+a[i][1]+"' and to_char(OOL.LINE_ID) = '"+a[i][2]+"' "+   //Liling  2007/11/20 為解決存檔慢的問題
 "  		        group by OOH.ORDER_NUMBER ,OOH.HEADER_ID,OOH.SHIP_FROM_ORG_ID,OOL.LINE_NUMBER,OOL.ORDERED_ITEM, "+
 " 	                     OOL.INVENTORY_ITEM_ID,OOL.ORDER_QUANTITY_UOM,ODS.PO_HEADER_ID ,ODS.LINE_LOCATION_ID,OOH.CUSTOMER_NUMBER, "+
 "  	                     OOH.CONVERSION_TYPE_CODE, OOH.SOLD_TO_ORG_ID,OOH.SOLD_TO, "+
 " 	                     OOH.ORDER_NUMBER||'-'|| OOL.LINE_NUMBER ,OOL.LINE_ID,OOH.SHIP_TO_ORG_ID ,OOH.SHIPPING_METHOD_CODE , "+
 " 	                     OOH.FOB_POINT_CODE ,OOH.TERMS ,OOH.SHIP_TO_ADDRESS1,OOH.INVOICE_TO_LOCATION,OOL.CUST_PO_NUMBER  ) A,    ";
 String sFrom2 = "                  (select distinct poh.segment1 PO_NUM,poh.po_header_id,pll.line_location_id,ODS.LINE_ID,ODS.PO_LINE_ID,POL.UNIT_MEAS_LOOKUP_CODE UOM,  "+
 " 				                  sum(pll.quantity),sum(pll.quantity_received),(sum(pll.quantity)-nvl(sum(pll.quantity_received),0)) undelivery_qty   "+
 "                   from oe_drop_ship_sources ods,po_headers_all poh,po_line_locations_all pll,po_lines_all pol    "+
 "                   where ods.PO_HEADER_ID=poh.PO_HEADER_ID    "+
 "                       and ods.LINE_LOCATION_ID=pll.line_location_id     "+
 "  		              and poh.po_header_id=pll.po_header_id    "+
 "  		              and pll.closed_code !='CLOSED'   "+
 " 					  and poh.AUTHORIZATION_STATUS='APPROVED' "+
 "                    and poh.po_header_id = pol.po_header_id "+
 "					  and pll.po_line_id = pol.po_line_id "+
 "      			  and ods.PO_LINE_ID = pol.PO_LINE_ID AND  ods.line_id = '"+a[i][2]+"' "+
 " 					  group by poh.segment1,poh.po_header_id,pll.line_location_id,ODS.LINE_ID,ODS.PO_LINE_ID,POL.UNIT_MEAS_LOOKUP_CODE  ) B, MTL_SYSTEM_ITEMS  C ,TSC_DROPSHIP_SHIP_LINE D   ";


 String   sWhere = "   where A.PO_HEADER_ID=B.PO_HEADER_ID(+)   "+
	   		 "         and A.LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)   "+
			 "   	   and B.LINE_ID(+)=A.LINE_ID   "+
			 "  	   and C.INVENTORY_ITEM_ID=A.INVENTORY_ITEM_ID   "+
			 "  	   and C.ORGANIZATION_ID = A.SHIP_FROM_ORG_ID   "+
             "         and a.line_location_id IS NOT NULL "+   // 2008/01/18 LILINE ADD 解決oe_drop_ship_sources重覆問題
    		 "         and a.selectflag =  d.salesorderno(+) || '-' || d.line_no(+)  " +	
             "         and to_char(a.order_num)='"+a[i][1]+"' and to_char(a.LINE_ID) = '"+a[i][2]+"'  " ;
			
		
  sSql = sSql + sFrom1 + sFrom2 + sWhere ;
  Statement statementTC=con.createStatement();
  ResultSet rsTC=statementTC.executeQuery(sSql);
 // out.print("<BR>sql="+sSql); 
  
  
  //計算陣列筆數
  Statement statementTC1=con.createStatement();
  ResultSet rsTC1=statementTC1.executeQuery("select count(A.ORDER_NUM) as ITEMCOUNT "+sFrom1 + sFrom2 + sWhere);
  if (rsTC1.next())
  { itemCount=rsTC1.getString("ITEMCOUNT"); }
  rsTC1.close();
  statementTC1.close();
  
  //out.println("itemCount.length()="+itemCount.length());

//out.println("QQQ 1");
	 
     if (rsTC.next())
     {  
	  //out.println("AA="+rsTC.getString("ORDER_NUM"));
	  //String r[][]=new String[30][12]; 
	  String iNo = Integer.toString(k+1);  // 把料項序號給第一個位置
	  //r[k][0]= iNo;
	  r[k][0]=rsTC.getString("ORDER_NUM");
	  r[k][1]=rsTC.getString("LINE_NUM");
  	  r[k][2]=a[i][3];
	  r[k][3]=rsTC.getString("CUSTOMERID");
	  r[k][4]=rsTC.getString("CUSTOMERNO");
	  r[k][5]=rsTC.getString("CUSTOMERNAME");
	  r[k][6]=rsTC.getString("SHIPTOORG");		  
	  r[k][7]=rsTC.getString("SHIPTOADDR");		  
	  r[k][8]=rsTC.getString("SHIPMETHOD");	 
	  r[k][9]=rsTC.getString("FOBPOINT");	  
	  r[k][10]=rsTC.getString("PAYTERM");		 
	  r[k][11]=rsTC.getString("HEADER_ID");	
	  r[k][12]=rsTC.getString("LINE_ID");	
	  r[k][13]=rsTC.getString("LINE_NUM");	
	  r[k][14]=rsTC.getString("INVENTORY_ITEM_ID");	
	  r[k][15]=rsTC.getString("INV_ITEM");	
	  r[k][16]=rsTC.getString("ITEM_DESC");	
	  r[k][17]=rsTC.getString("PO_HEADER_ID");		
	  r[k][18]=rsTC.getString("PO_NUM");		
	  r[k][19]=rsTC.getString("PO_LINE_ID");		 
	  r[k][20]=rsTC.getString("LINE_LOCATION_ID");		  
	  r[k][21]=rsTC.getString("UOM");		 //記得最後要改為抓PO_UOM
	  r[k][22]=rsTC.getString("ORDERED_ITEM");		
	  r[k][23]=rsTC.getString("BILLTO");		
	  r[k][24]=rsTC.getString("SHIP_FROM_ORG_ID");	
	  r[k][25]=rsTC.getString("CUST_PO_NUMBER");	
  
 
      shpArray2DPageBean.setArray2DString(r); 
	  shpArray2DPageBean.setArray2DCheck(r);
	  
	 } // End of if (rsTc.next())

	rsTC.close();
	statementTC.close();
	} //end of try
    catch (Exception e)
    {
          out.println("Exception SQL:"+e.getMessage());
    } 
 k++;   //累加陣列內容
} // End of for ()

     String q[][]=shpArray2DPageBean.getArray2DContent();//取得目前陣列內容		
     //印出陣列內容
	 if (q!=null) 
	 {			   
      //out.println(shpArray2DPageBean.getArray2DTempString());
	  out.println(shpArray2DPageBean.getArray2DShipString());
     }
     // 之前沒出過的發票方可作新增
		   String sqlc = " select COUNT(TDSH.TSINVOICENO) as COUNTINV from APPS.TSC_DROPSHIP_SHIP_HEADER TDSH  where TDSH.TSINVOICENO= upper('"+tsInvoiceNo+"')";
           //out.println("<BR>sqlc="+sqlc);
           Statement statect=con.createStatement();
           ResultSet rsct=statect.executeQuery(sqlc);
		   if (rsct.next())
		   {  countInv   = rsct.getString("COUNTINV");	}
		   if (countInv =="0" || countInv.equals("0")) {}
		   else { tempInvoice  = tsInvoiceNo; }
		   rsct.close();
           statect.close();		   



/*********************************************************************/
 
    String p[][]=shpArray2DPageBean.getArray2DContent();//取得目前陣列內容 		
    if (p!=null)
	{




	  String sqlh=" insert into tsc_dropship_ship_header(TSINVOICENO,SHIPDATE,CUSTOMERID,CUSTOMERNO,CUSTOMERNAME, "+
                  " SHIPTOORG,SHIPADDRESS,SHIPMETHOD,FOBPOINT,PAYTERM,CREATE_BY,STATUS,TAX_CODE,CURRENCY_CODE,BILLTO,DS_HEADER_ID,EMPLOYEE_ID ) "+
                  " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				  
//out.println("QQQ 1");				  
	  String sqll=" insert into TSC_DROPSHIP_SHIP_LINE( TSINVOICENO,ORDER_HEADER_ID,SALESORDERNO,ORDER_LINE_ID,LINE_NO, "+
                  " INVENTORY_ITEM_ID,INV_ITEM,ITEM_DESC,CUSTITEMNO,PO_UOM,RCVQTY,PO_HEADER_ID,PO_NUM, "+
                  " PO_LINE_ID,PO_LOCATION_LINE_ID,UNIT_SELLING_PRICE,CCCODE,PACKING_INSTRUCTIONS,DS_HEADER_ID,DS_LINE_ID,ORGANIZATION_ID,CUSTOMER_PN) "+
                  " values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
				  
      String sqls=" select DS_HEADER_ID from APPS.TSC_DROPSHIP_HEADER where TSINVOICENO=upper('"+tsInvoiceNo+"')";				  
//out.println("QQQ 2");				  
  
	  //for (int t=0;t<p.length-1;t++) // 2006/04/10 解決一筆Line問題
	  for (int t=0;t<p.length;t++)
	  {
          //取陣列內容不足的欄位	PACKING_INSTRUCTIONS,TAXCODE,UNITPRICE,CCCODE
	  	  Statement stateLT=con.createStatement();
		  String sql1=" select A.PACKING_INSTRUCTIONS as PACKINSUE ,A.TAX_POINT_CODE as TAXCODE,A.TRANSACTIONAL_CURR_CODE as CURR_CODE, "+
		              "        B.UNIT_SELLING_PRICE as UNITPRICE ,B.TAX_RATE "+
                      " from OE_ORDER_HEADERS_V A,OE_ORDER_LINES_V B "+
                      " where a.HEADER_ID=b.HEADER_ID and to_char(b.LINE_ID)= '"+p[t][12]+"' " ; 
                     // " where a.HEADER_ID=b.HEADER_ID and b.LINE_ID= '267264' " ; 					  
          ResultSet rsLT=stateLT.executeQuery(sql1);  
          if (rsLT.next()) 
		  {  
              currCode=rsLT.getString("CURR_CODE");	  		  	  
			  packInsue=rsLT.getString("PACKINSUE");
		      taxCode=rsLT.getString("TAXCODE");
              unitPrice=rsLT.getString("UNITPRICE");
              taxRate=rsLT.getString("TAX_RATE");
		  } // end of if (rsLT.next()) 
		 // out.print("sql1"+sql1);
		  rsLT.close();
		  stateLT.close();

		  
		 
		  //取cccode
		  Statement stateLT2=con.createStatement();
		  ResultSet rsLT2=stateLT2.executeQuery("select CCCODE from TSC_CCCODE where DESCRIPTION='"+p[t][16]+"' ");  
          if (rsLT2.next()) 
		  { ccCode=rsLT2.getString("CCCODE");  }
		  rsLT2.close();
		  stateLT2.close();	
		  
		  //取user login id
		 String sqlfnd = " select USER_ID  from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 					     " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
		 Statement stateFndId=con.createStatement();
         ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
         //out.println("sqlfnd="+sqlfnd);
		 if (rsFndId.next())
		 { createById=rsFndId.getInt("USER_ID"); }
		 rsFndId.close();
		 stateFndId.close();
	
		  //取employee_id
		 String sqlFndeId = " select PERSON_ID as EMPLOYEE_ID from APPS.AHR_EMPLOYEES_ALL where EMPLOYEE_NO= '"+userID+"'";
		 Statement stateFndeId=con.createStatement();
         ResultSet rsFndeId=stateFndeId.executeQuery(sqlFndeId);
         //out.println("sqlfnd="+sqlfnd);
		 if (rsFndeId.next())
		 { employeeId=rsFndeId.getInt("EMPLOYEE_ID"); }
		 rsFndeId.close();
		 stateFndeId.close();	

		 // out.println("shippingDate="+shippingDate); 
		 // out.println("CreateDate="+createDate); 
		if (tempInvoice!=tsInvoiceNo || !tempInvoice.equals(tsInvoiceNo))   //判斷若invoice一樣,則header只寫一次
		{ 
		  
		  //取DS_HEADER_ID 
		 Statement statehId=con.createStatement();
         ResultSet rshId=statehId.executeQuery("select TSC_DROPSHIP_HEADER_S.NEXTVAL from dual");
         //out.println("sqlfnd="+sqlfnd);
		 if (rshId.next())
		 { dsHeaderId=rshId.getInt("NEXTVAL"); }
		 rshId.close();
		 statehId.close();			  	 		 
        //insert into tsc_dropship_ship_header		
	    if (p[t][0]!=null && !p[t][0].equals(""))	  
		{   		
		  PreparedStatement pstmt=con.prepareStatement(sqlh);
		  pstmt.setString(1,tsInvoiceNo.toUpperCase()); //  TSINVOICENO 		  
      	 // pstmt.setDate(2,shippingDate);     // SHIPDATE  
      	  pstmt.setString(2,shipDate);     // SHIPDATE  		  
 	      pstmt.setInt(3,Integer.parseInt(p[t][3])); // CUSTOMERID	  
  	      pstmt.setString(4,p[t][4].trim()); // CUSTOMERNO	  
  	      pstmt.setString(5,p[t][5].trim()); // CUSTOMERNAME	 
	      pstmt.setString(6,p[t][6].trim()); // SHIPTOORG	  
  	      pstmt.setString(7,p[t][7].trim()); // SHIPADDRESS
	      pstmt.setString(8,p[t][8].trim()); // SHIPMETHOD
	      pstmt.setString(9,p[t][9].trim()); // FOBPOINT
	      pstmt.setString(10,p[t][10].trim()); // PAYMENTTERM		    
          //pstmt.setDate(11,createDate);  //CREATE_DATE  
	      pstmt.setInt(11,createById); //CREATE_BY  user login id
	      pstmt.setString(12,"OPEN"); //STATUS
	      pstmt.setString(13,taxCode);  //TAX_CODE		
	      pstmt.setString(14,currCode);  //CURRENCY_CODE  	
	      pstmt.setString(15,p[t][23].trim());  //BILLTO 
	      pstmt.setInt(16,dsHeaderId);  //DS_HEADER_ID	
	      pstmt.setInt(17,employeeId);  //EMPLOYEE_ID 	 	  	    
	      pstmt.executeUpdate(); 
          pstmt.close(); 	
		 } // end of if (p[r][0]!=null && !p[r][0].equals("")) // 若內容有取到才新增頭檔
	  } //end if (tempInvoice!=tsInvoiceNo || !tempInvoice.equals(tsInvoiceNo))

//out.println("QQQ 3");
	    //取DS_HEADER_ID 
		 Statement statehIda=con.createStatement();
         ResultSet rshIda=statehIda.executeQuery(" select DS_HEADER_ID from APPS.TSC_DROPSHIP_SHIP_HEADER where TSINVOICENO=upper('"+tsInvoiceNo+"')");
         //out.println("sqlfnd="+sqlfnd);
		 if (rshIda.next())
		  { dsHeaderId=rshIda.getInt("DS_HEADER_ID"); }
		 rshIda.close();
		 statehIda.close();		
		 
	   if (p[t][0]!=null && !p[t][0].equals(""))	  
  	   {    
	   	//取DS_LINE_ID 
		 Statement stateLId=con.createStatement();
         ResultSet rsLId=stateLId.executeQuery("select TSC_DROPSHIP_LINE_S.NEXTVAL from dual");
         //out.println("sqlfnd="+sqlfnd);
		 if (rsLId.next())
		 { dsLineId=rsLId.getInt("NEXTVAL"); }
		 rsLId.close();
		 stateLId.close();
	   
        //insert to tsc_dropship_ship_line		
          PreparedStatement pstmtl=con.prepareStatement(sqll);
		  pstmtl.setString(1,tsInvoiceNo.toUpperCase());    //  TSINVOICENO 
      	  pstmtl.setInt(2,Integer.parseInt(p[t][11]));     // ORDER_HEADER_ID  
 	      pstmtl.setString(3,p[t][0]);                  // SALESORDERNO	  
  	      pstmtl.setInt(4,Integer.parseInt(p[t][12]));  // ORDER_LINE_ID	  
  	      pstmtl.setInt(5,Integer.parseInt(p[t][13]));  // LINE_NO  
	      pstmtl.setInt(6,Integer.parseInt(p[t][14]));  // INVENTORY_ITEM_ID	  
  	      pstmtl.setString(7,p[t][15]); 				// INV_ITEM 
	      pstmtl.setString(8,p[t][16]); 				// ITEM_DESC
	      pstmtl.setString(9,p[t][22]); 				// CUSTITEMNO
          pstmtl.setString(10,p[t][21]); 				 //PO_UOM
         // pstmtl.setString(10,"KPC"); 				    //PO_UOM		  
	      pstmtl.setFloat(11,Float.parseFloat(p[t][2]));  //RCVQTY
	      pstmtl.setInt(12,Integer.parseInt(p[t][17])); //PO_HEADER_ID
	      pstmtl.setInt(13,Integer.parseInt(p[t][18]));  //PO_NUM
  	      pstmtl.setInt(14,Integer.parseInt(p[t][19])); // PO_LINE_ID
  	      pstmtl.setInt(15,Integer.parseInt(p[t][20])); // PO_LOCATION_LINE_ID
  	      pstmtl.setString(16,unitPrice);               // UNIT_SELLING_PRICE 
  	      pstmtl.setString(17,ccCode);                  // CCCODE  
  	      pstmtl.setString(18,packInsue);               // PACKING_INSTRUCTIONS	 
  	      pstmtl.setInt(19,dsHeaderId);                 // DS_HEADER_ID	
		  pstmtl.setInt(20,dsLineId);		    		// DS_LINE_ID 
		  pstmtl.setInt(21,Integer.parseInt(p[t][24]));		// ORGANIZATION_ID 		  
		  pstmtl.setString(22,p[t][25]); ;		// CUSTOMER_PN 				  		  		  
	      pstmtl.executeUpdate(); 
          pstmtl.close(); 	 
		} // End of if (p[r][0]!=null && !p[r][0].equals(""))	 
		  		  
	 tempInvoice=tsInvoiceNo; //判斷invoiceno是否為同一個,做為header寫入的依據
  
     } //end of for
 
%>						 
			<TABLE align="center" bordercolor="#FFFFFF">
    		 <TR  bgcolor="#FFFF99">
    		  <TD><A href="/oradds/ORADDSMainMenu.jsp"> <jsp:getProperty name="rPH" property="pgHOME"/></A></TD>&nbsp;&nbsp;
    		  <TD><A href="/oradds/jsp/TSSHPInvoiceQuery.jsp"> <jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgQuery"/></A></TD>
              <TD><A href="/oradds/jsp/TSSHPInvoiceAdd.jsp?TSINVOICENO=<%=tsInvoiceNo%>"><jsp:getProperty name="rPH" property="pgContiune"/><jsp:getProperty name="rPH" property="pgAdd"/><jsp:getProperty name="rPH" property="pgDetail"/></A></TD>			  
   		     </TR>
             <TR  bgcolor="#CCCCFF"><TD colspan=3 bgcolor="#FFFF99" ><span class="style2"><font size="+2"><%=tsInvoiceNo.toUpperCase()%>&nbsp;&nbsp;<span class="style2">Invoice Save Success!!</span></font></span></TD>
             </TR>
            </TABLE>		
<%  
		 } //end if (p!=null)
		 else { 
				out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Error Message</FONT></TD><TD colspan=3>"+errorMessageHeader+"</TD></TR>");
			  }					  
 		   
%>



</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

