<!--20171106 Peggy,po改至line-->
<!--20180202 Peggy,訂單1141出貨方式為DHL from Chris-->
<!--20180706 Peggy,on semi houseno變成-ON-->
<!--20180706 Peggy,on semi houseno變成-E-->
<!--20180202 Peggy,訂單1141出貨方式為UPS EXPRESS from Ava-->
<html>
<head>
<title>TSCC ON Semi Order Import </title>

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
<jsp:setProperty name="upBean" property="folderstore" value="d:/resin-2.1.9/webapps/oradds/jsp/ON Semi/" />
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
		fileMover.setNewfilename("TSCCONSemi_"+sdf.format(new java.util.Date())+".xls");
		// Uses MultipartFormDataRequest to parse the HTTP request.
		MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
		String todo = mrequest.getParameter("todo");
		if ( (todo != null) && (todo.equalsIgnoreCase("upload")) )  
		{
			Hashtable files = mrequest.getFiles();
			if ( (files != null) || (!files.isEmpty()) )  
			{
				UploadFile file = (UploadFile) files.get("uploadfile");
	
				upBean.store(mrequest, "uploadfile");
	
				out.println("<li>Form field : uploadfile"+"<BR> Uploaded file : " +
									  fileMover.getFileName() + " (" + file.getFileSize() +
									  " bytes)" + "<BR> Content Type : " + file.getContentType());
	
				// Change the directory location below
				Workbook rw = Workbook.getWorkbook(new File("d:/resin-2.1.9/webapps/oradds/jsp/ON Semi/"+fileMover.getFileName()));
				Sheet sheet = rw.getSheet(0);
				//Cell   cellorderno   = sheet.getCell(3,2);  //改抓line,modify by Peggy 20171106
				Cell cellorderno = null;
				//String BufferOrderNo = cellorderno.getContents();
				String BufferOrderNo = "";
				//out.println(BufferOrderNo);
				String BufferCurrency = "USD";
				Cell cellpartdesc = null;
				Cell cellqty = null;
				//Cell cellreqdate = sheet.getCell(3,1);
				Cell cellreqdate = sheet.getCell(4,1); //line add po column,modify by Peggy 20171106
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
	
			    String oneDArray[] = {"","No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust PO Line","Quote#","End Customer ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region"};//add by Peggy 20170222
				arrayRFQDocumentInputBean.setArrayString(oneDArray);
		
				// Set TSCR Order Default Value
				session.setAttribute("SPQCHECKED","N");
				session.setAttribute("CUSTOMERID","601290");
				session.setAttribute("CUSTOMERNO","25071");
				session.setAttribute("CUSTOMERNAME","On Semiconductor");
				session.setAttribute("CUSTOMERPO", BufferOrderNo);
				session.setAttribute("CURR", BufferCurrency);
				session.setAttribute("CUSTACTIVE","A");
				session.setAttribute("SALESAREANO","002");
				session.setAttribute("REMARK","Order Import from file");
				session.setAttribute("ISMODELSELECTED","Y");
				session.setAttribute("PROCESSAREA","002(半導體業務部-香港、澳門及大陸地區)");
				session.setAttribute("CUSTOMERIDTMP","601290");
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
				String itemFactory ="";
				String orderType = "";  
				String lineType ="";    
				String ship_via="";    
				String lineFob = "";   
				String fobPoint="";  
				String shipping_method=""; //add by Peggy 20180202
	
				try
				{
					CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
					cs1.setString(1,"41");
					cs1.execute();
					cs1.close();
				}
				catch (Exception e)
				{
					out.println("Exception:"+e.getMessage());
				}
	
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
							  " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
							  " order by decode(a.SITE_USE_CODE,'SHIP_TO',1,2)"; 
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
					//if(partdesc.startsWith("TOTAL")) continue; //add by Peggy 20120303
					if (partdesc==null || partdesc.equals("") || partdesc.startsWith("TOTAL")) continue; 
					partdescCNT = cellpartdesc.getContents();
					try
					{
						String sqlCNTitem = "select COUNT(*) from APPS.OE_ITEMS_V a"+
									   " where ITEM = '"+partdescCNT+"'"+
										 " and SOLD_TO_ORG_ID = "+custID+
										 " and ITEM_DESCRIPTION not like '%Disable%'"+
										 " and ITEM_DESCRIPTION not like '%disable%'"+
										 " and (UPPER(ITEM_DESCRIPTION) like '%ON SEMI%' or UPPER(ITEM_DESCRIPTION) like '%ON SEMI%' or UPPER(ITEM_DESCRIPTION) like '%-ON %' or UPPER(ITEM_DESCRIPTION) like '%-E%')"+
										 " and CROSS_REF_STATUS = 'ACTIVE'"+
										 " and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230204
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
						out.println("Exception1:"+e.getMessage());
					}
				}
	
				columns = 30;
				String b[][] = new String[itemCNTtotal+1][columns];
				int j = 0;
				for( int i=5 ; i< rows-1 ; i++ )
				{
					String CheckNext = "N";
					cellpartdesc = sheet.getCell(0,i);	
					if (cellpartdesc.getContents()==null || cellpartdesc.getContents().equals("") || cellpartdesc.getContents().startsWith("TOTAL")) continue; 
					cellorderno   = sheet.getCell(1,i); //add by Peggy 20171106
					BufferOrderNo = cellorderno.getContents();
					if (i==5)
					{
						session.setAttribute("CUSTOMERPO", BufferOrderNo);
					}
					//cellqty =  sheet.getCell(3,i);		
					cellqty =  sheet.getCell(4,i); //modify by Peggy 20171106
					//cellunitprice = sheet.getCell(2,i);
					cellunitprice = sheet.getCell(3,i);  //modify by Peggy 20171106
					//Cell cellreqdate2 = sheet.getCell(6,i);	
					Cell cellreqdate2 = sheet.getCell(7,i);	 //modify by Peggy 20171106
					datec11 = (DateCell)cellreqdate2;
					java.util.Date ReqDate2  =  datec11.getDate();
					String calstrdate2=sy1.format(ReqDate2);
					String QtyCheck =  replace(cellqty.getContents(),",","");  
					//Cell cellCustPOLine = sheet.getCell(7,i); 
					Cell cellCustPOLine = sheet.getCell(8,i);  //modify by Peggy 20171106
					String CustPOLineNo = cellCustPOLine.getContents();
	
					if(QtyCheck.trim() != "" && strdate.trim() != "") 
					{
						BufferPartDesc[1][i] = cellpartdesc.getContents();	
						BufferQuantity[3][i] = QtyCheck;				    
						BufferRequestDate[4][i] = calstrdate2;			
						BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);		
						BufferUnitPrice[6][i] = Double.parseDouble(cellunitprice.getContents());	
	
						try 
						{
							String sqlUOM = "select distinct b.INVENTORY_ITEM_ID INVENTORY_ITEM_ID, b.SEGMENT1 SEGMENT1,"+
											" b.DESCRIPTION DESCRIPTION, b.PRIMARY_UOM_CODE PRIMARY_UOM_CODE"+
									        " ,NVL(b.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
								            //" ,TSC_RFQ_CREATE_ERP_ODR_PKG.tsc_get_order_type(b.ATTRIBUTE3) as ORDER_TYPE"+
											" ,TSC_RFQ_CREATE_ERP_ODR_PKG.tsc_get_order_type(b.inventory_item_id) as ORDER_TYPE"+  //modify by Peggy 20191122
											" from APPS.OE_ITEMS_V a, APPS.MTL_SYSTEM_ITEMS b"+
								            " ,APPS.MTL_ITEM_CATEGORIES_V c "+
											" where a.item= '"+BufferPartDesc[1][i]+"'"+
											" and a.SOLD_TO_ORG_ID = "+custID+
											" and a.item_description not like '%Disable%'"+
											" and a.ITEM_DESCRIPTION not like '%disable%'"+
											" and a.INVENTORY_ITEM=b.SEGMENT1"+
											" and b.ORGANIZATION_ID = 49"+
											" and (upper(a.item_description) like '%ON SEMI%' or upper(a.item_description) like '%ON SEMI%' or upper(a.item_description) like '%-ON %' or upper(a.item_description) like '%-E%')"+
											" and CROSS_REF_STATUS = 'ACTIVE'"+
              					            " and b.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
								            " and b.ORGANIZATION_ID = c.ORGANIZATION_ID "+
								            " and c.CATEGORY_SET_ID = 6"+
											" and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230204	
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
								lineFob =fobPoint;
								//add by Peggy 20180202
								if (orderType.equals("1141"))
								{
									shipping_method="UPS EXPRESS";
								}
								else
								{
									shipping_method=ship_via;
								}
								
								if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
								{
									iNo = Integer.toString(j+1);
									b[j][0]=iNo;
									b[j][1]=BufferPartNumber[1][i];	
									b[j][2]=BufferPartDescNew[1][i];	
									b[j][3]=Double.toString((double)(BufferQuantityNew[3][i])/(double)(1000));
									b[j][4]=BufferUOM[1][i];		
									b[j][5]=""; 
									//b[j][6]=ship_via; 
									b[j][6]=shipping_method;  //add by Peggy 20180202
									b[j][7]=BufferRequestDate[4][i];	
									b[j][8]=BufferOrderNo;
									if (itemCNTsub[i]==1) b[j][9]="";
									else b[j][9]="** DUPLICATED"+i+" **";
									b[j][10]="N";
									b[j][11]="0";
									b[j][12]="0";
									b[j][13]=itemFactory;  
									b[j][14]=""+BufferPartDesc[1][i];  
									b[j][15]=""+BufferUnitPrice[6][i]; 
									b[j][16]=orderType;     
									b[j][17]=lineType;   
									b[j][18]=lineFob;     
									b[j][19]=CustPOLineNo;  
									b[j][20]="";       
									b[j][21]="";   
									b[j][22]="";  
									b[j][23]="";   
									b[j][24]="";   
									b[j][25]="";    
									b[j][26]=""; 
									b[j][27]="";   
									b[j][28]="";   
									b[j][29]="";   
									j++;
								} 
							} 
							rsUOM.close();
	
							if(!CheckNext.equals("Y"))
							{
								iNo = Integer.toString(j+1);  
								b[j][0]=iNo;
								b[j][1]="XXXXXXXXXX";
								b[j][2]=BufferPartDesc[1][i];
								b[j][3]= Double.toString((double)(BufferQuantityNew[3][i])/(double)(1000)); 
								b[j][4]="KPC";
				   				b[j][5]=""; 
				   				//b[j][6]=ship_via; 
								b[j][6]=shipping_method;  //add by Peggy 20180202
								b[j][7]=BufferRequestDate[4][i];                   
								b[j][8]=BufferOrderNo;
								b[j][9]="*WRONG*";
								b[j][10]="N";
								b[j][11]="0";
								b[j][12]="0";
								b[j][13]="";    
								b[j][14]=""+BufferPartDesc[1][i];    
								b[j][15]=""+BufferUnitPrice[6][i]; 
								b[j][16]="";    
								b[j][17]="";   
								b[j][18]="";    
								b[j][19]=CustPOLineNo;  
								b[j][20]="";     
								b[j][21]="";   		
								b[j][22]="";  
								b[j][23]="";     
								b[j][24]="";      
								b[j][25]="";     
								b[j][26]="";     
								b[j][27]="";     
								b[j][28]="";     
								b[j][29]="";     
								j++;
							} // end if(CheckNext.equals("Y"))
							stateUOM.close();
						}
						catch (Exception e)
						{
							out.println("Exception2:"+e.getMessage());
						}
						session.setAttribute("MAXLINENO",iNo);
					}
				}  
	
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
					cc[i][19]="D";  
					cc[i][20]="D"; 
					cc[i][21]="D"; 
					cc[i][22]="D"; 
					cc[i][23]="D"; 
					cc[i][24]="D"; 
					cc[i][25]="D"; 
					cc[i][26]="D";
					cc[i][27]="D"; 
					cc[i][28]="D";
					cc[i][29]="D";
				}
				arrayRFQDocumentInputBean.setArray2DString(bb);
				arrayRFQDocumentInputBean.setArray2DCheck(cc);
	
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
					out.println("Exception4:"+e.getMessage());
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
<form method="post" action="TSCONSemiImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

<% 
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
		String urlDir = "TSSalesDRQ_Create.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+
                   "&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+
				   "&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+
				   "&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+ProcessArea+
				   "&INSERT="+Insert+"&RFQTYPE=NORMAL&PROGRAMNAME=D4-005";
   		response.sendRedirect(urlDir);
  	}		
}
catch(Exception e)
{
	out.println("Exception5:"+e.getMessage());
}				
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSC ON Semi Order in Excel format to upload :</b></font></td>
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
