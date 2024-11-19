<html>
<head>

<title>TSCT MUSTARD(CHINESE) Order Import </title>

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
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCTCHTMustard/" />
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
String replace(String s, String one, String another) {
// In a string replace one substring with another
  if (s.equals("")) return "";
  String res = "";
  int i = s.indexOf(one,0);
  int lastpos = 0;
  while (i != -1) {
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
      if (MultipartFormDataRequest.isMultipartFormData(request))  {
        // Rename the file name with the following rule.
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        fileMover.setNewfilename("TSCTCHTMustard_"+sdf.format(new java.util.Date())+".xls");
        // Uses MultipartFormDataRequest to parse the HTTP request.
        MultipartFormDataRequest mrequest = new MultipartFormDataRequest(request);
        String todo = mrequest.getParameter("todo");
        if ( (todo != null) && (todo.equalsIgnoreCase("upload")) )  {
          Hashtable files = mrequest.getFiles();
          if ( (files != null) || (!files.isEmpty()) )  {
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
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCTCHTMustard/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         Cell   cellorderno   = sheet.getCell(0,5);
         Cell   cellcurrency = sheet.getCell(5,9);

          // For Chinese Language Problem

          String temp_ppono          = "採購單號:";
          byte[] temp_tpono          = temp_ppono.getBytes("ISO8859-1");
          String PONo                = new String(temp_tpono);
          
          String temp_punitp         = "單  價(";
          byte[] temp_tunitp         = temp_punitp.getBytes("ISO8859-1");
          String UnitP                = new String(temp_tunitp);

         String BufferOrderNo = replace(cellorderno.getContents(),PONo,"");        
         String BufferCurrency = replace(replace(replace(cellcurrency.getContents(),UnitP,""),")","")," ","");
         
         Cell cellpartdesc1 = null;
         //Cell cellpartdesc2 = null;
         Cell cellqty = null;
         Cell cellreqdate = null;
         Cell cellunitprice = null;
         Cell cellremark = null;

         // Set first array for TSSalesDRQCreateImport.jsp

         String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
         // Set TSCA Order Default Value
   
         session.setAttribute("SPQCHECKED","N");
         session.setAttribute("CUSTOMERID","4824");
         session.setAttribute("CUSTOMERNO","2462");
         session.setAttribute("CUSTOMERNAME","茂荃股份有限公司");
         session.setAttribute("CUSTOMERPO", BufferOrderNo);
         session.setAttribute("CURR", BufferCurrency);
         session.setAttribute("CUSTACTIVE","A");
         session.setAttribute("SALESAREANO","005");
         session.setAttribute("REMARK","Order Import from file");
         session.setAttribute("PREORDERTYPE","1020");
         session.setAttribute("ISMODELSELECTED","Y");
         session.setAttribute("PROCESSAREA","005(半導體業務部-台灣區(DA)");
         session.setAttribute("CUSTOMERIDTMP","4824");
         session.setAttribute("INSERT","Y");

         int rows    = sheet.getRows(); 
         int columns = sheet.getColumns(); 

         out.println(rows);
         out.println(columns);

         String iNo=null;
         int itemCNTsub[]             = new int[rows];
         //String b[][]                 = new String[rows][columns];
         String BufferPartDesc[][]    = new String[columns][rows];
         String BufferQuantity[][]    = new String[columns][rows];
         int    BufferQuantityNew[][] = new int[columns][rows];
         String BufferRequestDate[][] = new String[columns][rows];
         double BufferUnitPrice[][]   = new double[columns][rows];
         String BufferUOM[][]         = new String[columns][rows];
         String BufferPartNumber[][]  = new String[columns][rows];
         String BufferPartDescNew[][] = new String[columns][rows];
         String strdate="";

// Process to determine the total item records

          int itemCNTtotal = 0;

          for ( int itemno=0 ; itemno < rows-11 ; itemno++)
          {
             cellpartdesc1      = sheet.getCell(1,itemno+10);
             String partdesc1   = replace(replace(cellpartdesc1.getContents()," ",""),"-"," ");
             String partdescCNT = partdesc1;

           //String partdescCNT = cellpartdesc.getContents();
             
           // Get TSC Part Number

           try
            {

            // To Check the ITEM result records

               String sqlCNTitem = "";
               sqlCNTitem = "select count(*) from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+partdescCNT+"' ";
               Statement stateCNTitem=con.createStatement();
               ResultSet rsCNTitem=stateCNTitem.executeQuery(sqlCNTitem);
               rsCNTitem.next();
               itemCNTsub[itemno] = rsCNTitem.getInt(1);
            
               itemCNTtotal = itemCNTtotal + itemCNTsub[itemno];      

               out.println("<BR>"+"ITEMNO"+itemno+"--ITEMDESC "+partdescCNT+"--SUB "+itemCNTsub[itemno]+"--ITEMTOTAL "+itemCNTtotal + "<BR>");                 

            }
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }
          }

// End ITEM Count

         String b[][] = new String[itemCNTtotal+1][columns];

         int j = 0;  
          
         for( int i=0 ; i< rows-11 ; i++ )
         {
  
            //attention: The first parameter is column,the second parameter is row.  

             // Check flag for WRONG ITEM NUMBER

             String CheckNext = "N";

             cellpartdesc1 = sheet.getCell(1,i+10);
             cellqty =  sheet.getCell(3,i+10);
             cellreqdate = sheet.getCell(2,i+10);
             cellunitprice = sheet.getCell(5,i+10); 
             //cellremark = sheet.getCell(7,i+6);

             //String RemarkDesc = cellremark.getContents();      
             //String QtyCheck =  replace(cellqty.getContents(),",","");
             //String QtyCheck = "1000";
             out.println(cellqty.getType());
             //out.println(QtyCheck);

             String QtyCheck = "";

             if(cellqty.getType() == CellType.NUMBER)
             {

             double strc10 = 0.00;
             NumberCell numc10 = (NumberCell)cellqty;
             strc10 = numc10.getValue();
             int strc11 = (int)strc10;
 
             QtyCheck = Integer.toString(strc11);
             out.println(QtyCheck);
             } 
              
             if (cellreqdate.getType() == CellType.DATE)
             {
             DateCell datec11 = (DateCell)cellreqdate;
             java.util.Date ReqDate  =  datec11.getDate();

             SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
             strdate=sy1.format(ReqDate); 
             }
           
           
             if(QtyCheck.trim() != "" && strdate.trim() != "")
             {
             
             String partdesc1   = replace(replace(cellpartdesc1.getContents()," ",""),"-"," ");
             
             BufferPartDesc[1][i] = partdesc1;

             out.println(BufferPartDesc[1][i]);

             BufferRequestDate[2][i] = strdate;
             BufferQuantity[3][i] = QtyCheck;
             out.println(BufferQuantity[3][i]);
             //BufferQuantity[3][i] ="1000";
             BufferUnitPrice[7][i] = Double.parseDouble(cellunitprice.getContents());
             BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);
             //BufferQuantityNew[3][i] = 1000;

             // Get TSC Part Number

             try
              {
                String sqlUOM = "";
                sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+BufferPartDesc[1][i]+"' ";
                Statement stateUOM=con.createStatement();
                ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
	
                while (rsUOM.next ())
                 {	
                   CheckNext = "Y";   
                   BufferUOM[1][i]         = rsUOM.getString("PRIMARY_UOM_CODE");   
                   BufferPartNumber[1][i]  = rsUOM.getString("SEGMENT1"); 
	           BufferPartDescNew[1][i] = rsUOM.getString("DESCRIPTION");

                  //}
               // rsUOM.close();
                //stateUOM.close(); 

                // Set into ArrayBean for TSSalesDRQCreateImport.jsp page
                if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
                {
                  iNo = Integer.toString(j+1);  
                  b[j][0]=iNo;
                  b[j][1]=BufferPartNumber[1][i];
                  b[j][2]=BufferPartDescNew[1][i];

                  // Convert into KPC
                  b[j][3]=Double.toString(BufferQuantityNew[3][i]/1000.);

                  b[j][4]=BufferUOM[1][i];
                  b[j][5]=BufferRequestDate[2][i];
                    
                  if( itemCNTsub[i]==1 )
                  {
                  b[j][6]="MUSTARD Order Import";
                  }
                  else 
                  {
                   b[j][6]="*DUPLICATED*"+i;
                  }
       

        	    if (b[j][1]!=null && b[j][1].trim()!="" )
		    {		
                     arrayRFQDocumentInputBean.setArray2DString(b);
                     arrayRFQDocumentInputBean.setArray2DCheck(b);		
		    } 	
		    j++;

                 } // end of if
                 
                }
                rsUOM.close();

               // Set the WRONG ITEM DESCRIPTION VALUE

                if(CheckNext.equals("Y"))
                {}
                else
                {
                  iNo = Integer.toString(j+1);  
                  b[j][0]=iNo;

                  b[j][1]="XXXXXXXXXX";
                  b[j][2]=BufferPartDesc[1][i];

                  // Convert into KPC
                  b[j][3]=Double.toString(BufferQuantityNew[3][i]);

                  b[j][4]="KPC";
                  b[j][5]=BufferRequestDate[2][i];                   
                  b[j][6]="*WRONG*";
     

        	    if (b[j][1]!=null && b[j][1].trim()!="" )
		    {		
                     arrayRFQDocumentInputBean.setArray2DString(b);
                     arrayRFQDocumentInputBean.setArray2DCheck(b);		
		    } 	
		    j++;
                } // end if(CheckNext.equals("Y"))

                stateUOM.close(); 
               
               } // end of try
               catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                }
         
             session.setAttribute("MAXLINENO",iNo);
             
            //out.println(i+"--"+QtyCheck+"--"+ReqDate+"--"+partdesc+"--"+price+"--");

             }  // end of (QtyCheck.trim() != "" && ReqDate.trim() != "")

       } // end of for loop
              
  // Get the SalesPerson and SalesPersonID SQL

       try
       {

        String custID = (String)session.getAttribute("CUSTOMERID");
        
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

            // Set TSCE Order Default Value

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
          
      // Close Excel file  
      rw.close();

     }
     else  {
            out.println("<li>No uploaded files");
           }
     }
     else out.println("<BR> todo="+todo);
     }
         
%>
</font></ul>
<form method="post" action="TSCTCHTMustardImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

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
  {  }
  else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  { 
   String urlDir = "TSSalesDRQCreateImport.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+"&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+"&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+"&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+ProcessArea+"&CUSTOMERIDTMP="+CustomerIdTmp+"&INSERT="+Insert;
   response.sendRedirect(urlDir);
  }		
			
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSCT MUSTARD(CHINESE) Order in Excel format to upload :</b></font></td>
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
