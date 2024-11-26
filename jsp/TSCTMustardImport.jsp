<!--add by Peggy 20140826,新增ERP END CUSTOMER ID欄位-->
<!--add by Peggy 20150326,修正上傳客戶類別-->
<!--add by Peggy 20150519,add column "tsch orderl line id" for tsch case-->
<!--add by Peggy 20160408,add sample order direct ship to cust flag-->
<!--20170216 by Peggy,add sales region for bi-->
<!--20170512 by Peggy,add end cust ship to id-->
<!--20191128 Peggy,TSCT-DA與TSCT-Disty合併成TSCT,RFQ業務區移除006,統一在005-->
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<html>
<head>
<title>TSCT Mustard Order Import </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page language="java" import="javazoom.upload.*,java.sql.*,java.util.*,java.text.*" %>
<%@ page language="java" import="java.io.*,java.io.File,jxl.*" %>
<%@ page language="java" import="jxl.write.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>

<!--===========Change the directory location below ======================-->
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
<jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCTMustard/" />
<jsp:setProperty name="upBean" property="overwrite" value="true" />
<% upBean.addUploadListener(fileMover); %>
</jsp:useBean>

<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>

<!--  File Mover Bean is instantiated before the uploadBean to that it can be used as a
      listener for the upload Bean.
      NOTE:  FolderStore Property of the uploadBean is used by the filemover as the location
      to save the file.  Don't forget to modify this property to reflect a valid
      directory on your server.
-->
<%!
String replace(String s, String one, String another) 
{
	// In a string replace one substring with another
  	if (s.equals("")) return "";
	String res = "";
  	int i = s.indexOf(one,0);
  	int lastpos = 0;
  	while (i != -1) 
	{
    	res += s.substring(lastpos,i) + another;
    	lastpos = i + one.length();
    	i = s.indexOf(one,lastpos);
  	}
  	res += s.substring(lastpos);  // the rest
  	return res;  
}
%>
<% 
 String uploadFlag=request.getParameter("UPLOADFLAG");
%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<ul><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
<%
try
{
	if (MultipartFormDataRequest.isMultipartFormData(request))  
	{
        // Rename the file name with the following rule.
		SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        fileMover.setNewfilename("TSCTMustard_"+sdf.format(new java.util.Date())+".xls");
        // Uses MultipartFormDataRequest to parse the HTTP request.
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        String todo = mrequest.getParameter("todo");
        if ( (todo != null) && (todo.equalsIgnoreCase("upload")) )  
		{
        	Hashtable files = mrequest.getFiles();
          	if ( (files != null) || (!files.isEmpty()) )  
			{
            	UploadFile file = (UploadFile) files.get("uploadfile");

            	// The store method must be invoked to trigger the fileMover
            	// Object's fileUploaded() callback function.  This is the function
            	// That actually writes the file to disk.
            	upBean.store(mrequest, "uploadfile");

            	// Modified this slightly to retrieve the filename from the fileMover object.
            	// The same could be done for the file size.

           	 	//out.println("<li>Form field : uploadfile"+"<BR> Uploaded file : " +
                //                  fileMover.getFileName() + " (" + file.getFileSize() +
                //                  " bytes)" + "<BR> Content Type : " + file.getContentType());

         		// Change the directory location below
         		Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCTMustard/"+fileMover.getFileName()));
         		Sheet sheet = rw.getSheet(0);
         		Cell   cellorderno   = sheet.getCell(1,1);
         		String BufferOrderNo = cellorderno.getContents();
         		Cell   cellcurrency = sheet.getCell(1,4);
         		String BufferCurrency = cellcurrency.getContents();
         
         		Cell cellpartdesc1 = null;
         		Cell cellqty = null;
         		Cell cellreqdate = null;
         		Cell cellunitprice = null;
         		Cell cellremark = null;
        	 	Cell cellcompinfo = null;
         		cellcompinfo = sheet.getCell(1,0);
				Cell cellEndCustID = null;   //add by Peggy 20140826
				Cell cellSalesRemark = null; //add by Peggy 20150707
				Cell cellCustPart = null; //add by Peggy 20210811
          		// For Chinese Language Problem

         		String temp_p          = cellcompinfo.getContents();;
         		byte[] temp_t          = temp_p.getBytes("ISO8859-1");
         		String CompInfo        = new String(temp_t);
				String strEndCust="",strERPEndCustomerID=""; //add by Peggy 20140826
				String strRemark="",CustPart="";  //add by Peggy 20150707

         		// Set first array for TSSalesDRQCreateImport.jsp
        		// 20110309 Marvie Update : Add Field  SPQ MOQ
         		//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
         		//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","End-Customer PO","Remark"};
		 		//modify by Peggy 2011079
         		String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","BI Region"};
         		arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
         		// Set TSCT Order Default Value
         		if (CompInfo.toUpperCase().startsWith("MUSTARD"))
         		{
         			session.setAttribute("SPQCHECKED","N");
         			session.setAttribute("CUSTOMERID","4985");
         			session.setAttribute("CUSTOMERNO","2514");
         			session.setAttribute("CUSTOMERNAME","MUSTARD SEED CORP.");
         			session.setAttribute("CUSTOMERPO", BufferOrderNo);
         			session.setAttribute("CURR", BufferCurrency);
         			session.setAttribute("CUSTACTIVE","A");
         			session.setAttribute("REMARK","Order Import from file");
         			session.setAttribute("PREORDERTYPE","1175");
         			session.setAttribute("ISMODELSELECTED","Y");
         			session.setAttribute("CUSTOMERIDTMP","4985");
         			session.setAttribute("INSERT","Y");
					//if (Integer.parseInt(dateBean.getYearMonthDay())>=20200101)
					//{
					//	session.setAttribute("SALESAREANO","005");
					//	session.setAttribute("PROCESSAREA","005(半導體業務部-台灣區)");
					//}
					//else
					//{
						session.setAttribute("SALESAREANO","006");
						session.setAttribute("PROCESSAREA","006(半導體業務部-台灣區(Disty))");
					//}
         		}
         		else
         		{
         			session.setAttribute("SPQCHECKED","N");
         			session.setAttribute("CUSTOMERID","4824");
         			session.setAttribute("CUSTOMERNO","2462");
         			session.setAttribute("CUSTOMERNAME","茂荃股份有限公司");
         			session.setAttribute("CUSTOMERPO", BufferOrderNo);
         			session.setAttribute("CURR", BufferCurrency);
         			session.setAttribute("CUSTACTIVE","A");
         			session.setAttribute("REMARK","Order Import from file");
         			session.setAttribute("PREORDERTYPE","1021");
         			session.setAttribute("ISMODELSELECTED","Y");
         			session.setAttribute("CUSTOMERIDTMP","4824");
        		 	session.setAttribute("INSERT","Y");
					//if (Integer.parseInt(dateBean.getYearMonthDay())>=20200101)
					//{
					//	session.setAttribute("SALESAREANO","005");
					//	session.setAttribute("PROCESSAREA","005(半導體業務部-台灣區");
					//}
					//else
					//{
						session.setAttribute("SALESAREANO","006");
						session.setAttribute("PROCESSAREA","006(半導體業務部-台灣區(Disty))");
					//}
         		}
         
         		int rows    = sheet.getRows(); 
         		int columns = sheet.getColumns(); 

         		//out.println(rows);
         		//out.println(columns);

         		String iNo=null;
         		int itemCNTsub[]             = new int[rows];
         		//String b[][]                 = new String[rows][columns];
         		String BufferPartDesc[][]    = new String[columns][rows];
         		String BufferQuantity[][]    = new String[columns][rows];
         		double BufferQuantityNew[][] = new double[columns][rows];
         		String BufferRequestDate[][] = new String[columns][rows];
         		double BufferUnitPrice[][]   = new double[columns][rows];
         		String BufferUOM[][]         = new String[columns][rows];
         		String BufferPartNumber[][]  = new String[columns][rows];
         		String BufferPartDescNew[][] = new String[columns][rows];
         		String strdate="";
         		String UnitPriceOK = "";
				String itemFactory =""; //add by Peggy 20120316
				String ship_via = "";   //add by Peggy 20120321
				String lineFob = "";    //add by Peggy 20120329

				CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S','41')}");
				cs1.execute();
				cs1.close();
		
				String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
				PreparedStatement pstmt1=con.prepareStatement(sql1);
				pstmt1.executeUpdate(); 
				pstmt1.close();	
				
				//add by Peggy 20120309
				Statement statementa=con.createStatement();
				String sqla = " select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
							 " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION"+ 
							 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
							 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
							 " AND b.party_site_id = party_site.party_site_id"+
							 " AND loc.location_id = party_site.location_id "+
							 " and a.STATUS='A' "+
							 " and a.PRIMARY_FLAG='Y'"+
							 " and b.CUST_ACCOUNT_ID ='"+ (String)session.getAttribute("CUSTOMERID")+"'"+
							 " and a.PAYMENT_TERM_ID = c.TERM_ID(+)";
				ResultSet rsa=statementa.executeQuery(sqla);
				while (rsa.next())
				{
					if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
					{
						if (ship_via==null || ship_via.equals(""))
						{
							ship_via = rsa.getString("ship_via");
						}
						if (lineFob==null || lineFob.equals(""))
						{
							lineFob = rsa.getString("FOB_POINT");
						}						
					}
					else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
					{
						if (ship_via==null || ship_via.equals(""))
						{
							ship_via = rsa.getString("ship_via");
						}	
						if (lineFob==null || lineFob.equals(""))
						{
							lineFob = rsa.getString("FOB_POINT");
						}																		
					}
				}
				rsa.close();
				statementa.close();
				
				//add by Peggy 20140826
				String sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
							  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
							  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+session.getAttribute("SALESAREANO")+"') d"+
							  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
							  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
							  " and a.STATUS = b.STATUS "+
							  " and a.ORG_ID = b.ORG_ID "+										
							  " and a.ORG_ID = d.PAR_ORG_ID"+
							  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
							  " and c.STATUS='A'"+
							  " order by c.customer_id";
				Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rss = statements.executeQuery(sql);	
								
				// Process to determine the total item records
          		int itemCNTtotal = 0;

          		for ( int itemno=0 ; itemno < rows-7 ; itemno++)
          		{
             		cellpartdesc1 = sheet.getCell(2,itemno+6);
             		String partdesc1   = cellpartdesc1.getContents();
             		String partdescCNT = partdesc1;
           			try
            		{
               			String sqlCNTitem = "";
               			sqlCNTitem = " select count(*) from APPS.MTL_SYSTEM_ITEMS a"+
						             " where ORGANIZATION_ID = '49' "+
									 " and DESCRIPTION = '"+partdescCNT+"' "+
						             " AND INVENTORY_ITEM_STATUS_CODE<>'Inactive'"+ //add by Peggy 20110729
									 " AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y' "+
									 " AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y' "+ //add by Peggy 20180504
									 " AND (length(a.SEGMENT1)=22 or (length(a.SEGMENT1)=30 and a.SEGMENT1 LIKE '%F00'))"+  //add by Peggy 20230118
									 " AND tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230118
               			Statement stateCNTitem=con.createStatement();
               			ResultSet rsCNTitem=stateCNTitem.executeQuery(sqlCNTitem);
               			rsCNTitem.next();
               			itemCNTsub[itemno] = rsCNTitem.getInt(1);
               			if(rsCNTitem.getInt(1) == 0) 
               			{
                 			itemCNTsub[itemno]=1;
               			}
               			itemCNTtotal = itemCNTtotal + itemCNTsub[itemno];      

               			//out.println("<BR>"+"ITEMNO"+itemno+"--ITEMDESC "+partdescCNT+"--SUB "+itemCNTsub[itemno]+"--ITEMTOTAL "+itemCNTtotal + "<BR>");                 
            		}
            		catch (Exception e)
            		{
             			out.println("Exception:"+e.getMessage());
            		}
          		}


         		// 20110729 Peggy set columns = 13
         		columns = 30;
         		String b[][] = new String[itemCNTtotal+1][columns];
         		int j = 0;  
         		for( int i=0 ; i< rows-7 ; i++ )
         		{
             		String CheckNext = "N";

             		cellCustPart = sheet.getCell(1,i+6);  //add by Peggy 20210811
					CustPart=cellCustPart.getContents().trim(); //add by Peggy 20210811
					if (CustPart==null) CustPart="";
             		cellpartdesc1 = sheet.getCell(2,i+6);
             		cellqty =  sheet.getCell(3,i+6);
             		cellreqdate = sheet.getCell(6,i+6);
             		cellunitprice = sheet.getCell(4,i+6); 
             		cellremark = sheet.getCell(7,i+6);
					cellEndCustID = sheet.getCell(8,i+6); //add by Peggy 20140826
					cellSalesRemark = sheet.getCell(9,i+6); //add by Peggy 20150707
					strRemark = (cellSalesRemark.getContents()).trim();
					strERPEndCustomerID=(cellEndCustID.getContents()).trim();
					if (strERPEndCustomerID==null) strERPEndCustomerID="";
					
					//End Customer ID
					strEndCust ="";
					if (!strERPEndCustomerID.equals(""))
					{
						if (strERPEndCustomerID.equals(session.getAttribute("CUSTOMERNO")))
						{
							out.println("<font color='red'>End Customer ID:"+strERPEndCustomerID+" is not the same!</font>");
							uploadFlag =null;
						}
						else
						{
							if (rss.isBeforeFirst() ==false) rss.beforeFirst();
							while (rss.next())
							{
								if (rss.getString("customer_number").equals(strERPEndCustomerID))
								{
									strEndCust = rss.getString("CUSTOMER_NAME_PHONETIC");
									break;
								}
							}
							if (strEndCust.equals(""))
							{
								out.println("<font color='red'>End Customer ID:"+strERPEndCustomerID+" NOT Found!</font>");
								uploadFlag =null;
							}	
						}				
					}											

					//檢查客戶品號
					if (CustPart!= null && !CustPart.equals(""))
					{						  
						sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID"+
							  " from oe_items_v a"+
							  " ,inv.mtl_system_items_b msi "+
							  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
							  " where a.SOLD_TO_ORG_ID = '"+(String)session.getAttribute("CUSTOMERID")+"' "+
							  " and a.organization_id = msi.organization_id"+
							  " and a.inventory_item_id = msi.inventory_item_id"+
							  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
							  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
							  " and msi.ORGANIZATION_ID = '49'"+
							  " and c.CATEGORY_SET_ID = 6"+
							  " and a.CROSS_REF_STATUS='ACTIVE'"+
						      " and msi.inventory_item_status_code <> 'Inactive'"+
                              " and a.ITEM = '"+CustPart+"'"+
							 " AND (length(msi.SEGMENT1)=22 or (length(msi.SEGMENT1)=30 and msi.SEGMENT1 LIKE '%F00'))"+  //add by Peggy 20230118
							  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230118							  
						//out.println("**"+sql);
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						if (!rs.next())
						{
							out.println("<font color='red'>Not found cust PN:"+CustPart+" in ERP<br></font>");
							uploadFlag =null;
						}
						rs.close();
						statement.close();
					}
					
             		String RemarkDesc = cellremark.getContents();         
             		String QtyCheck =  cellqty.getContents();

             		//out.println("PRICETYPE"+cellunitprice.getType());

             		if(cellunitprice.getType() == CellType.NUMBER)
             		{
              			//UnitPriceOK = cellunitprice.getContents();
						//modify by Peggy 20140826
						UnitPriceOK = (new DecimalFormat("######.#####")).format(Float.parseFloat(""+((NumberCell) cellunitprice).getValue()));						
             		}
             		else
             		{
              			UnitPriceOK = "0";
             		}
					
             		if (cellreqdate.getType() == CellType.DATE)
             		{
             			DateCell datec11 = (DateCell)cellreqdate;
             			java.util.Date ReqDate  =  datec11.getDate();

             			SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
             			strdate=sy1.format(ReqDate); 
             		}	
					else
					{
						strdate="";
					}
					//out.println("QtyCheck="+QtyCheck);
					//out.println("strdate="+strdate);
             		if(QtyCheck.trim() != "" && strdate.trim() != "")
             		{
             
             			String partdesc1   = cellpartdesc1.getContents();
             			BufferPartDesc[1][i] = partdesc1;
             			BufferRequestDate[2][i] = strdate;
             			BufferQuantity[3][i] = QtyCheck;
            		 	BufferUnitPrice[7][i] = Double.parseDouble(UnitPriceOK);
             			BufferQuantityNew[3][i] = Double.parseDouble(BufferQuantity[3][i]);

             			//out.println("<BR>"+BufferPartDesc[1][i]);

             			try
              			{
                			String sqlUOM = "";
							String order_type = "";
                			sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE ,NVL(ATTRIBUTE3,'N/A') ATTRIBUTE3"+
							 ", tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (a.inventory_item_id) as order_type\n"+
							 " from APPS.MTL_SYSTEM_ITEMS a"+
							 " where ORGANIZATION_ID = '49'"+
							 " AND DESCRIPTION = '"+BufferPartDesc[1][i]+"' "+
							 " AND INVENTORY_ITEM_STATUS_CODE<>'Inactive'"+ //add by Peggy 20110729
							 " AND NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+
							 " AND NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y' "+ //add by Peggy 20180504
							 " and (length(a.SEGMENT1)=22 or (length(a.SEGMENT1)=30 and a.SEGMENT1 LIKE '%F00'))"+  //add by Peggy 20230118
							 " AND tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230118							 
							//out.println(sqlUOM);
                			Statement stateUOM=con.createStatement();
                			ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
	
                			while (rsUOM.next ())
                 			{
                   				CheckNext = "Y";	   
                   				BufferUOM[1][i]         = rsUOM.getString("PRIMARY_UOM_CODE");   
                   				BufferPartNumber[1][i]  = rsUOM.getString("SEGMENT1"); 
	           					BufferPartDescNew[1][i] = rsUOM.getString("DESCRIPTION");
								itemFactory = rsUOM.getString("ATTRIBUTE3");
								order_type = rsUOM.getString("ORDER_TYPE");

                				// Set into ArrayBean for TSSalesDRQCreateImport.jsp page
                				if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
                				{
                  					iNo = Integer.toString(j+1);  
                  					b[j][0]=iNo;
                  					b[j][1]=BufferPartNumber[1][i];
                  					b[j][2]=BufferPartDescNew[1][i];
                  					// Convert into KPC
                 	 				b[j][3]=Double.toString(BufferQuantityNew[3][i]);
                  					b[j][4]=BufferUOM[1][i];
									b[j][5]=""; //add by Peggy 20110729
									b[j][6]=ship_via; //add by Peggy 20110729
                  					b[j][7]=BufferRequestDate[2][i];
				  					b[j][8]=(BufferOrderNo.equals("")?"":BufferOrderNo)+"("+RemarkDesc+")";   //add by Peggy 20180719,加括號for Kristin issue  //add by Peggy 加customer po在line 20210127
                  					if (itemCNTsub[i]==1) b[j][9]=strRemark;  //add by Peggy 20150707
                  					else b[j][9]="*DUPLICATED*("+RemarkDesc+")";
				  					b[j][10]="N";
                  					b[j][11]="0";
				  					b[j][12]="0";
									b[j][13]=itemFactory;   //生產廠別 add by Peggy 20120316
									b[j][14]=CustPart;    //客戶料號 add by Peggy 20210811
									b[j][15]=""+BufferUnitPrice[7][i];  ///加入EXCEL檔的單價,modify by Peggy 20140626
									b[j][16]=order_type;      //訂單類型 add by Peggy 20120316
									b[j][17]="";       //LineType add by Peggy 20120316
									b[j][18]="";      //FOB add by Peggy 20120329
									b[j][19]="";      //CUST PO LINE NO,add by Peggy 20120601
									b[j][20]="";      //QUOTE NUMBER,add by Peggy 20120917
									b[j][21]=strERPEndCustomerID;     //END CUSTOMER ID,add by Peggy 20140826
									b[j][22]="";      //SHIPPING MARKS,add by Peggy 20130305
									b[j][23]="";      //REMAKRS,add by Peggy 20130305
									b[j][24]=strEndCust;    //END CUSTOMER,add by Peggy 20140826
									b[j][25]="";            //source line id,add by Peggy 20150616
									b[j][26]="";            //sample order direct ship,add by Peggy 20160408
									b[j][27]="";            //bi region,add by Peggy 20170222
									b[j][28]="";            //END CUSTOMER SHIP TO ID,add by Peggy 20170512
									b[j][29]="";            //END CUSTOMER PARTNO,add by Peggy 20190313
		          					j++;
                 				} // end of if
                			}
                			rsUOM.close();
                			// Set the WRONG ITEM DESCRIPTION VALUE

                			if(CheckNext.equals("Y"))
                			{
							}
                			else
                			{
                  				iNo = Integer.toString(j+1);  
                  				b[j][0]=iNo;
                  				b[j][1]="XXXXXXXXXX";
                  				b[j][2]=BufferPartDesc[1][i];
                  				// Convert into KPC
                  				b[j][3]=Double.toString(BufferQuantityNew[3][i]);
                  				b[j][4]="KPC";
				   				b[j][5]=""; 
				   				b[j][6]=""; 
                 	 			b[j][7]=BufferRequestDate[2][i];                   
				  				b[j][8]=RemarkDesc;
                  				b[j][9]="*WRONG*("+RemarkDesc+")";
				  				b[j][10]="N";
                  				b[j][11]="0";
				  				b[j][12]="0";
								b[j][13]="";      //生產廠別 add by Peggy 20120303
								b[j][14]="";      //客戶料號 add by Peggy 20120303
								b[j][15]="";      //單價 add by Peggy 20120303
								b[j][16]="";      //訂單類型 add by Peggy 20120303
								b[j][17]="";      //LineType add by Peggy 20120303								
								b[j][18]="";      //FOB add by Peggy 201203029							
     							b[j][19]="";      //CUST PO LINE NO,add by Peggy 20120601
     							b[j][20]="";      //QUOTE NUMBER,add by Peggy 20120917
								b[j][21]="";      //END CUSTOMER ID,add by Peggy 20121107
     							b[j][22]="";      //SHIPPING MARKS,add by Peggy 20130305
								b[j][23]="";      //REMARKS,add by Peggy 20130305
								b[j][24]="";      //END CUSTOMER,add by Peggy 20140826
								b[j][25]="";       //source line id,add by Peggy 20150616
								b[j][26]="";       //sample order direct ship,add by Peggy 20160408
								b[j][27]="";       //bi region,add by Peggy 20170222
								b[j][28]="";       //END CUSTOMER SHIP TO ID,add by Peggy 20170512
								b[j][29]="";       //END CUSTOMER PARTNO,add by Peggy 20190313
		          				j++;
                			} // end if(CheckNext.equals("Y"))
                			stateUOM.close(); 
               			} // end of try
              	 		catch (Exception e)
                		{
                  			out.println("Exception1:"+e.getMessage());
                		}
         
             			session.setAttribute("MAXLINENO",iNo);
             		}  // end of (QtyCheck.trim() != "" && ReqDate.trim() != "")
       			} // end of for loop
				
				// 20110309 Marvie Add : Add Field  SPQ MOQ
				//out.println("iNo="+iNo);
				int iRow = Integer.parseInt(iNo) + 1;
        		String bb[][] = new String[iRow][columns];
        		String cc[][] = new String[iRow][columns];
				for (int i=0;i<bb.length;i++) 
				{
					//out.println("xx"+b[i]);
		  			bb[i] = b[i];
		  			cc[i][0]=b[i][0];
		  			cc[i][1]="D";
		  			cc[i][2]="D";
		  			cc[i][3]="U";
		  			cc[i][4]="U";
		  			cc[i][5]="D";
		  			cc[i][6]="D";
		  			cc[i][7]="U";
		  			cc[i][8]="U";
		  			cc[i][9]="U";
		  			cc[i][10]="P";
		  			cc[i][11]="P";
		  			cc[i][12]="P";
					cc[i][13]="D";
					cc[i][14]="D";
					cc[i][15]="D";
					cc[i][16]="D";
					cc[i][17]="D";
					cc[i][18]="D";
					cc[i][19]="D";
					cc[i][20]="D";
					cc[i][21]="D";
					cc[i][22]="D";
					cc[i][23]="D";
					cc[i][24]="D";  //add by Peggy 20140826
					cc[i][25]="D";  //add by Peggy 20150616
					cc[i][26]="D";  //add by Peggy 20160408
					cc[i][27]="D";  //add by Peggy 20170222
					cc[i][28]="D";  //add by Peggy 20170512
					cc[i][29]="D";  //add by Peggy 20190313
				}
        		arrayRFQDocumentInputBean.setArray2DString(bb);
        		arrayRFQDocumentInputBean.setArray2DCheck(cc);
				
				rss.close();
				statements.close();
				
       			// Get the SalesPerson and SalesPersonID SQL
       			try
       			{
					String custID = (String)session.getAttribute("CUSTOMERID");
					Statement statement=con.createStatement();
        			//String sSql = "select b.PRIMARY_SALESREP_ID, c.RESOURCE_NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,JTF_RS_DEFRESOURCES_VL c "+
		            //  "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and to_char(a.CUST_ACCOUNT_ID) ='"+custID+"' "+
					//  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID and a.SHIP_TO_FLAG='P' "+
					//  "and c.RESOURCE_ID = b.PRIMARY_SALESREP_ID";
					//modify by Peggy 20230421
					String sSql = " select distinct b.PRIMARY_SALESREP_ID, c.LOV_MEANING NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,tsc_crm_lov_v c "+
                                  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
                                  " and a.CUST_ACCOUNT_ID ="+custID+""+
                                  " and a.STATUS = 'A'"+
                                  " and a.ORG_ID = b.ORG_ID"+ 
                                  " and a.ORG_ID =41"+
                                  " and a.SHIP_TO_FLAG='P' "+
                                  " and c.LOV_CODE = to_char(b.PRIMARY_SALESREP_ID)"+ 
                                  " and b.STATUS = 'A'";
        			ResultSet rsSalsPs=statement.executeQuery(sSql);	 
          			if (rsSalsPs.next()==true)
          			{  
	    				//String salesPerson = rsSalsPs.getString("RESOURCE_NAME");
						String salesPerson = rsSalsPs.getString("NAME");
	    				String toPersonID  = rsSalsPs.getString("PRIMARY_SALESREP_ID");

            			// Set TSCE Order Default Value
            			session.setAttribute("SALESPERSONID",toPersonID);
            			session.setAttribute("SALESPERSON",salesPerson);	
          			}
        			rsSalsPs.close();		
					statement.close();	
      			}
      			catch (Exception e)
      			{
       				out.println("Exception2:"+e.getMessage());
      			}
     	 		// Close Excel file  
      			rw.close();
     		}
     		else  
			{
            	out.println("<li>No uploaded files");
           	}
     	}
     	else out.println("<BR> todo="+todo);
    }
         
%>
</font></ul>
<form method="post" action="TSCTMustardImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

<% //TSCEBufferImport.jsp?UPLOADFLAG=Y

	String SPQChecked      = (String)session.getAttribute("SPQCHECKED");
	String CustomerId      = (String)session.getAttribute("CUSTOMERID");
	String CustomerNo      = (String)session.getAttribute("CUSTOMERNO");
	String CustomerName    = (String)session.getAttribute("CUSTOMERNAME");
	String CustomerPo      = (String)session.getAttribute("CUSTOMERPO");
	String Curr            = (String)session.getAttribute("CURR");
	String CustActive      = (String)session.getAttribute("CUSTACTIVE");
	String SalesAreaNo     = (String)session.getAttribute("SALESAREANO");
	String SalesPersonId   = (String)session.getAttribute("SALESPERSONID");
	String SalesPerson     = (String)session.getAttribute("SALESPERSON");
	String Remark          = (String)session.getAttribute("REMARK");
	String PreOrderType    = (String)session.getAttribute("PREORDERTYPE");
	String IsModelSelected = (String)session.getAttribute("ISMODELSELECTED");
	String ProcessArea     = (String)session.getAttribute("PROCESSAREA");
	String CustomerIdTmp   = (String)session.getAttribute("CUSTOMERIDTMP");
	String Insert          = (String)session.getAttribute("INSERT");
	//String fromPage        = (String)session.getAttribute("FROMPAGE");
  	String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 		
        
  	if (uploadFlag == null) 
  	{  
	}
  	else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  	{
   		// 20110217 Marvie Update : Add field  PROGRAM_NAME
   		//String urlDir = "TSSalesDRQCreateImport.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+"&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+"&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+"&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+ProcessArea+"&CUSTOMERIDTMP="+CustomerIdTmp+"&INSERT="+Insert;
   		String urlDir = "TSSalesDRQCreateImport.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+
                   "&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+
				   "&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+
				   "&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+java.net.URLEncoder.encode(ProcessArea)+
				   "&CUSTOMERIDTMP="+CustomerIdTmp+"&INSERT="+Insert+"&PROGRAMNAME=D4-008";
   		response.sendRedirect(urlDir);
  	}		
}
catch(Exception e)
{
	out.println("Exception3:"+e.getMessage());
}				
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSCT Mustard Order in Excel format to upload :</b></font></td>
    </tr>
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
        <input type="file" name="uploadfile" size="50">
        </font></td>
    </tr>
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
	<input type="hidden" name="todo" value="upload">
	
        <input type="submit" name="Submit" value="Upload">
        <input type="reset" name="Reset" value="Cancel">
        </font></td>
    </tr>
  </table>
</form>

<!--=============Release Database Connection==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
