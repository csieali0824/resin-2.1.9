<html>
<head>
<title>TSCR FairChild Order Import </title>

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
<jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCRFairChild/" />
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
		fileMover.setNewfilename("TSCRFairChild_"+sdf.format(new java.util.Date())+".xls");
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
				out.println("<li>Form field : uploadfile"+"<BR> Uploaded file : " +
									  fileMover.getFileName() + " (" + file.getFileSize() +
									  " bytes)" + "<BR> Content Type : " + file.getContentType());
	
				// Change the directory location below
				Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCRFairChild/"+fileMover.getFileName()));
				Sheet sheet = rw.getSheet(0);
				Cell   cellorderno   = sheet.getCell(5,2);
				String BufferOrderNo = cellorderno.getContents();
				out.println(BufferOrderNo);
				String BufferCurrency = "USD";
				Cell cellpartdesc = null;
				Cell cellqty = null;
				Cell cellreqdate = sheet.getCell(5,1);
				DateCell datec11 = (DateCell)cellreqdate;
				java.util.Date ReqDate  =  datec11.getDate();
				SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
				String calstrdate=sy1.format(ReqDate);
				java.util.Date dt = sy1.parse(calstrdate);
				Calendar rightNow = Calendar.getInstance();
				rightNow.setTime(dt);
				rightNow.add(Calendar.MONTH,1);
				java.util.Date dt1=rightNow.getTime();
				String strdate=sy1.format(dt1); 
				Cell cellunitprice = null;
	
				// Set first array for TSSalesDRQCreateImport.jsp
				// 20110309 Marvie Update : Add Field  SPQ MOQ
				//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
				//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","End-Customer PO","Remark"};
				//String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark"};
			    String oneDArray[] = {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust PO Line","Quote#"};
				arrayRFQDocumentInputBean.setArrayString(oneDArray);
		
				// Set TSCR Order Default Value
				session.setAttribute("SPQCHECKED","N");
				session.setAttribute("CUSTOMERID","1220");
				session.setAttribute("CUSTOMERNO","1107");
				session.setAttribute("CUSTOMERNAME","FAIRCHILD SEMICONDUCTOR HONG KONG (HOLDINGS) LTD.");
				session.setAttribute("CUSTOMERPO", BufferOrderNo);
				session.setAttribute("CURR", BufferCurrency);
				session.setAttribute("CUSTACTIVE","A");
				session.setAttribute("SALESAREANO","002");
				session.setAttribute("REMARK","Order Import from file");
				//session.setAttribute("PREORDERTYPE","1020"); //mark by Peggy 20120303
				session.setAttribute("ISMODELSELECTED","Y");
				session.setAttribute("PROCESSAREA","002(半導體業務部-香港、澳門及大陸地區)");
				session.setAttribute("CUSTOMERIDTMP","1220");
				session.setAttribute("INSERT","Y");
				session.setAttribute("PROGRAMNAME","D4-005");
				String custID = (String)session.getAttribute("CUSTOMERID");
				int rows    = sheet.getRows(); 
				int columns = sheet.getColumns();
	
				String iNo=null;
				String partdescCNT=null;
				int itemCNTsub[]             = new int[rows];
				String BufferPartDesc[][]    = new String[columns][rows];
				String BufferQuantity[][]    = new String[columns][rows];
				int    BufferQuantityNew[][] = new int[columns][rows];
				String BufferRequestDate[][] = new String[columns][rows];
				double BufferUnitPrice[][]   = new double[columns][rows];
				String BufferUOM[][]         = new String[columns][rows];
				String BufferPartNumber[][]  = new String[columns][rows];
				String BufferPartDescNew[][] = new String[columns][rows];
				String itemFactory =""; //add by Peggy 20120303
				String orderType = "";  //add by Peggy 20120303
				String lineType ="";    //add by Peggy 20120303
				String ship_via="";     //add by Peggy 20120309
				String lineFob = "";    //add by Peggy 20120329
				String fobPoint="";     //add by Peggy 20120329
	
				try
				{
					//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
					CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
					cs1.setString(1,"41");
					cs1.execute();
					cs1.close();
				}
				catch (Exception e)
				{
					out.println("Exception:"+e.getMessage());
				}
	
				//add by Peggy 20120309
				Statement statementa=con.createStatement();
				ResultSet rsa=null;		
				String sqla = " select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
							 " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION"+ 
							 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
							 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
							 " AND b.party_site_id = party_site.party_site_id"+
							 " AND loc.location_id = party_site.location_id "+
							 " and a.STATUS='A' "+
							 " and a.PRIMARY_FLAG='Y'"+
							 " and b.CUST_ACCOUNT_ID ='"+custID+"'"+
							 " and a.PAYMENT_TERM_ID = c.TERM_ID(+)";
				rsa=statementa.executeQuery(sqla);
				while (rsa.next())
				{
					if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
					{
						if ((ship_via.equals("") || ship_via==null) && rsa.getString("ship_via") != null)
						{
							ship_via = rsa.getString("ship_via");
						}
						if ((fobPoint.equals("") || fobPoint == null) && rsa.getString("FOB_POINT")!=null)
						{
							fobPoint = rsa.getString("FOB_POINT");
						}
					}
					else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
					{
						if ((ship_via.equals("") || ship_via==null) && rsa.getString("ship_via") != null)
						{
							ship_via = rsa.getString("ship_via");
						}	
						if ((fobPoint.equals("") || fobPoint == null) && rsa.getString("FOB_POINT")!=null)
						{
							fobPoint = rsa.getString("FOB_POINT");
						}																		
					}
				}
				rsa.close();
				statementa.close();
	
				int itemCNTtotal = 0;
				for ( int itemno=5 ; itemno < rows-1 ; itemno++)
				{
					cellpartdesc = sheet.getCell(0,itemno);
					String partdesc   = cellpartdesc.getContents();
					if(partdesc.startsWith("TOTAL")) continue; //add by Peggy 20120303
					partdescCNT = cellpartdesc.getContents();
					try
					{
						// To Check the ITEM result records
						// 20100117 Marvie Update : fix Remark display incorrect
						//String sqlCNTitem = "select count(*) from APPS.OE_ITEMS_V where ITEM = '"+partdescCNT+"' AND ITEM_DESCRIPTION NOT LIKE '%Disable%' ";
						String sqlCNTitem = "select COUNT(*) from APPS.OE_ITEMS_V"+
									   " where ITEM = '"+partdescCNT+"'"+
										 " and SOLD_TO_ORG_ID = "+custID+
										 " and ITEM_DESCRIPTION not like '%Disable%'"+
										 " and ITEM_DESCRIPTION not like '%disable%'"+
										 " and (ITEM_DESCRIPTION like '%Fairchild%' or ITEM_DESCRIPTION like '%FAIRCHILD%')"+
										 " and CROSS_REF_STATUS = 'ACTIVE'";
						Statement stateCNTitem=con.createStatement();
						ResultSet rsCNTitem=stateCNTitem.executeQuery(sqlCNTitem);
						rsCNTitem.next();
						itemCNTsub[itemno] = rsCNTitem.getInt(1);
	
						if(rsCNTitem.getInt(1) == 0) 
						{
							itemCNTsub[itemno]=1;
						}
						itemCNTtotal += itemCNTsub[itemno];      
					}
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
				} // End for itemno
	
				// modify by peggy 20110729
				columns = 21;
				String b[][] = new String[itemCNTtotal+1][columns];
				int j = 0;
				for( int i=5 ; i< rows-1 ; i++ )
				{
					String CheckNext = "N";
					cellpartdesc = sheet.getCell(0,i);	//--Part--
					if (cellpartdesc.getContents().startsWith("TOTAL")) continue; //add by Peggy 20120303
					cellqty =  sheet.getCell(3,i);		//--Firm Order--
					cellunitprice = sheet.getCell(2,i);	//--Price--
					Cell cellreqdate2 = sheet.getCell(9,i);	//--Request Date--
					datec11 = (DateCell)cellreqdate2;
					java.util.Date ReqDate2  =  datec11.getDate();
					String calstrdate2=sy1.format(ReqDate2);
					String QtyCheck =  replace(cellqty.getContents(),",","");  
					Cell cellCustPOLine = sheet.getCell(10,i); //cust po line number,add by Peggy 20120716
					String CustPOLineNo = cellCustPOLine.getContents();
	
					if(QtyCheck.trim() != "" && strdate.trim() != "") 
					{
						BufferPartDesc[1][i] = cellpartdesc.getContents();		//--Part--
						BufferQuantity[3][i] = QtyCheck;				//--Firm Order--             
						BufferRequestDate[4][i] = calstrdate2;			//--Request Date--
						BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);		//--Firm Order--
						BufferUnitPrice[6][i] = Double.parseDouble(cellunitprice.getContents());	//--Price--
	
						try 
						{
							String sqlUOM = "select distinct b.INVENTORY_ITEM_ID INVENTORY_ITEM_ID, b.SEGMENT1 SEGMENT1,"+
											" b.DESCRIPTION DESCRIPTION, b.PRIMARY_UOM_CODE PRIMARY_UOM_CODE"+
									        " ,NVL(b.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
								            " ,TSC_RFQ_CREATE_ERP_ODR_PKG.tsc_get_order_type(b.ATTRIBUTE3) as ORDER_TYPE"+
											" from APPS.OE_ITEMS_V a, APPS.MTL_SYSTEM_ITEMS b"+
								            " ,APPS.MTL_ITEM_CATEGORIES_V c "+
											" where a.item= '"+BufferPartDesc[1][i]+"'"+
											" and a.SOLD_TO_ORG_ID = "+custID+
											" and a.item_description not like '%Disable%'"+
											" and a.ITEM_DESCRIPTION not like '%disable%'"+
											" and a.INVENTORY_ITEM=b.SEGMENT1"+
											" and b.ORGANIZATION_ID = 49"+
											" and (a.item_description like '%Fairchild%' or a.item_description like '%FAIRCHILD%')"+
											" and CROSS_REF_STATUS = 'ACTIVE'"+
              					            " and b.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
								            " and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
								            " and c.CATEGORY_SET_ID = 6";	
							Statement stateUOM=con.createStatement();
							ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
							while (rsUOM.next()) 
							{	   
								CheckNext = "Y";
								BufferUOM[1][i]         = rsUOM.getString("PRIMARY_UOM_CODE");   
								BufferPartNumber[1][i]  = rsUOM.getString("SEGMENT1");
								BufferPartDescNew[1][i] = rsUOM.getString("DESCRIPTION");
								itemFactory = rsUOM.getString("ATTRIBUTE3");	
								orderType = rsUOM.getString("ORDER_TYPE");								
					   
								//add by Peggy 20120303
		   			            Statement stateLType=con.createStatement();
   					            String sqlOrgInf = " select a.DEFAULT_ORDER_LINE_TYPE,a.OTYPE_ID "+
		              					           " from ORADDMAN.TSAREA_ORDERCLS a, APPS.OE_TRANSACTION_TYPES_V b "+
			          					           " where a.DEFAULT_ORDER_LINE_TYPE=b.TRANSACTION_TYPE_ID and to_char(a.ORDER_NUM) = '"+orderType+"' "+
					  					           " and a.SAREA_NO = '"+(String)session.getAttribute("SALESAREANO")+"' and a.ACTIVE ='Y' ";
   					            ResultSet rsLType=stateLType.executeQuery(sqlOrgInf);
   					            if (rsLType.next())
   					            {
     					        	lineType = rsLType.getString("DEFAULT_ORDER_LINE_TYPE");
									if ((String)session.getAttribute("PREORDERTYPE")==null)	session.setAttribute("PREORDERTYPE",rsLType.getString("OTYPE_ID")); //mark by Peggy 20120303
   								} 
   								else 
								{ 
									lineType ="0"; 
								} 
   								rsLType.close();
   								stateLType.close();						   

								if (orderType.equals("1141"))
								{
									lineFob = "FOB TAIWAN";
								}
								else if (orderType.equals("1142") || orderType.equals("1156"))
								{
									lineFob = "FOB TIANJIN";
								}
								else
								{
									lineFob =fobPoint;
								}								
								
								// Set into ArrayBean for TSSalesDRQCreateImport.jsp page
								if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
								{
									iNo = Integer.toString(j+1);
									b[j][0]=iNo;
									b[j][1]=BufferPartNumber[1][i];	//--Inventory Item--
									b[j][2]=BufferPartDescNew[1][i];	//--Item Description--
									//b[j][3]=Double.toString(BufferQuantityNew[3][i]/1000);	//--Order Qty--
									b[j][3]=Double.toString((double)(BufferQuantityNew[3][i])/(double)(1000));	//modif by Peggy 20111019
									b[j][4]=BufferUOM[1][i];			//--UOM--
									b[j][5]="&nbsp;"; 
									b[j][6]=ship_via; 
									b[j][7]=BufferRequestDate[4][i];		//--Request Date--
									b[j][8]=BufferOrderNo;
									if (itemCNTsub[i]==1) b[j][9]="&nbsp;";
									else b[j][9]="** DUPLICATED"+i+" **";
									b[j][10]="N";
									b[j][11]="0";
									b[j][12]="0";
									b[j][13]=itemFactory;   //生產廠別 add by Peggy 20120303
									b[j][14]=""+BufferPartDesc[1][i];    //客戶料號 add by Peggy 20120303
									b[j][15]=""+BufferUnitPrice[6][i];  //單價 add by Peggy 20120303
									b[j][16]=orderType;      //訂單類型 add by Peggy 20120303
									b[j][17]=lineType;       //LineType add by Peggy 20120303
									b[j][18]=lineFob;        //FOB,add by Peggy 20120329
									b[j][19]=CustPOLineNo;   //CUST PO LINE NO,add by Peggy 20120716
									b[j][20]="&nbsp;";       //QUOTE NUMBER,add by Peggy 20120917
									j++;
								} // End of if ()
							} // while next end
							rsUOM.close();
	
							if(!CheckNext.equals("Y"))
							{
								iNo = Integer.toString(j+1);  
								b[j][0]=iNo;
								b[j][1]="XXXXXXXXXX";
								b[j][2]=BufferPartDesc[1][i];
								//b[j][3]=Double.toString(BufferQuantityNew[3][i]/1000);
								b[j][3]= Double.toString((double)(BufferQuantityNew[3][i])/(double)(1000)); //modif by Peggy 20111019
								b[j][4]="KPC";
				   				b[j][5]="&nbsp;"; 
				   				b[j][6]=ship_via; 
								b[j][7]=BufferRequestDate[4][i];                   
								b[j][8]=BufferOrderNo;
								b[j][9]="*WRONG*";
								b[j][10]="N";
								b[j][11]="0";
								b[j][12]="0";
								b[j][13]="&nbsp;";      //生產廠別 add by Peggy 20120303
								b[j][14]=""+BufferPartDesc[1][i];     //客戶料號 add by Peggy 20120303
								b[j][15]=""+BufferUnitPrice[6][i];  //單價 add by Peggy 20120303
								b[j][16]="&nbsp;";      //訂單類型 add by Peggy 20120303
								b[j][17]="&nbsp;";       //LineType add by Peggy 20120303	
								b[j][18]="&nbsp;";       //FOB, add by Peggy 20120329	
								b[j][19]=CustPOLineNo;   //CUST PO LINE NO,add by Peggy 20120716	
								b[j][20]="&nbsp;";       //QUOTE NUMBER,add by Peggy 20120917					
								j++;
							} // end if(CheckNext.equals("Y"))
							stateUOM.close();
						}
						catch (Exception e)
						{
							out.println("Exception:"+e.getMessage());
						}
						session.setAttribute("MAXLINENO",iNo);
					} // End of if (BufferPartDesc[1][j] != "" && BufferQuantity[3][j] != "")
				}  // End of for ()
	
				// 20110309 Marvie Add : Add Field  SPQ MOQ
				int iRow = Integer.parseInt(iNo);
				String bb[][] = new String[iRow][columns];
				String cc[][] = new String[iRow][columns];
				for (int i=0;i<bb.length;i++) 
				{
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
					cc[i][19]="D";  //add by Peggy 20120531
					cc[i][20]="D";  //add by Peggy 20120917
				}
				arrayRFQDocumentInputBean.setArray2DString(bb);
				arrayRFQDocumentInputBean.setArray2DCheck(cc);
	
				// Get the SalesPerson and SalesPersonID SQL
				try
				{
					Statement statement=con.createStatement();
					String sSql = "select b.PRIMARY_SALESREP_ID, c.RESOURCE_NAME from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b,JTF_RS_DEFRESOURCES_VL c "+
						  "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and to_char(a.CUST_ACCOUNT_ID) ='"+custID+"' "+
						  "and a.STATUS = 'A' and a.ORG_ID = b.ORG_ID and a.SHIP_TO_FLAG='P' "+
						  "and c.RESOURCE_ID = b.PRIMARY_SALESREP_ID";
					ResultSet rsSalsPs=statement.executeQuery(sSql);	 
					if (rsSalsPs.next()==true)
					{  
						String salesPerson = rsSalsPs.getString("RESOURCE_NAME");
						String toPersonID  = rsSalsPs.getString("PRIMARY_SALESREP_ID");
						session.setAttribute("SALESPERSONID",toPersonID);
						session.setAttribute("SALESPERSON",salesPerson);	
					}
		
					rsSalsPs.close();		
					statement.close();	
				}
				catch (Exception e)
				{
					out.println("Exception:"+e.getMessage());
				}
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
<form method="post" action="TSCRFairChildImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

<% //TSCRFairChildImport.jsp?UPLOADFLAG=Y
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
	String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 		
                       		    		  	   		   
  	if (uploadFlag == null) 
  	{  
	}
  	else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  	{ 
   		// 20110217 Marvie Update : Add field  PROGRAM_NAME
   		//String urlDir = "TSSalesDRQCreateImport.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+
		//modify by Peggy 20120303 URL changed
		String urlDir = "TSSalesDRQ_Create.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+
                   "&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+
				   "&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+
				   "&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+ProcessArea+
				   "&CUSTOMERIDTMP="+CustomerIdTmp+"&INSERT="+Insert+"&RFQTYPE=NORMAL&PROGRAMNAME=D4-005";
   		response.sendRedirect(urlDir);
  	}		
}
catch(Exception e)
{
	out.println("Exception:"+e.getMessage());
}				
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSCR FairChild Order in Excel format to upload :</b></font></td>
    </tr>
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">
        <input type="file" name="uploadfile" size="80">
        <A HREF="../jsp/samplefiles/D4-005_SampleFile.xls">Download Sample File</A>	</font></td>
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
