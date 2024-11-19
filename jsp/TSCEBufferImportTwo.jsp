<html>
<head>
<title>TSCE BufferNet Consignment Order (1213) Import </title>

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
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCEBuffer/" />
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

<% 
 String uploadFlag=request.getParameter("UPLOADFLAG");
%>
</head>
<body bgcolor="#FFFFFF" text="#000000">
<ul><font size="-1" face="Verdana, Arial, Helvetica, sans-serif">

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
      if (MultipartFormDataRequest.isMultipartFormData(request))  {
        // Rename the file name with the following rule.
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        fileMover.setNewfilename("TSCEBuffer_"+sdf.format(new java.util.Date())+".xls");
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
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCEBuffer/"+fileMover.getFileName()));

         WritableWorkbook wwb = Workbook.createWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCEBuffer/TEMP_"+fileMover.getFileName()),rw);
         wwb.write();
      
         Sheet sheet = wwb.getSheet(1);

         Cell BufferDate = sheet.getCell(8,9);
         Cell BufferOrderNo = sheet.getCell(2,20);
         Cell BufferCurrency = sheet.getCell(9,23);

         Cell cellpartdesc = null;
         Cell cellqty = null;
         Cell cellreqdate = null;
         Cell cellunitprice = null;

          // Set first array for TSSalesDRQCreateImport.jsp

          String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
     	  arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
          // Set TSCE Order Default Value
   
          session.setAttribute("SPQCHECKED","N");
          session.setAttribute("CUSTOMERID","1411");
          session.setAttribute("CUSTOMERNO","1202");
          session.setAttribute("CUSTOMERNAME","TAIWAN SEMICONDUCTOR EUROPE GMBH");
          session.setAttribute("CUSTOMERPO", BufferOrderNo.getContents());
          session.setAttribute("CURR", BufferCurrency.getContents());
          session.setAttribute("CUSTACTIVE","A");
          session.setAttribute("SALESAREANO","001");
          session.setAttribute("REMARK","BufferNet Consignment Order");
          session.setAttribute("PREORDERTYPE","1114");
          session.setAttribute("ISMODELSELECTED","Y");
          session.setAttribute("PROCESSAREA","001(半導體業務部-歐洲區)");
          session.setAttribute("CUSTOMERIDTMP","1411");
          session.setAttribute("INSERT","Y");
          session.setAttribute("FROMPAGE","TSCEBufferImport.jsp");
          //String fromPage=request.getParameter("FROMPAGE");

         // Loop To read the Cells value
                            
          int rows    = sheet.getRows();
          int columns = sheet.getColumns();
		                     
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
          
// Process to determine the total item records

          int itemCNTtotal = 0;

          for ( int itemno=0 ; itemno < rows ; itemno++)
          {
           cellpartdesc = sheet.getCell(1,itemno+26);
           String partdescCNT = cellpartdesc.getContents();
             
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

               //out.println("<BR>"+"ITEMNO"+itemno+"--ITEMDESC "+partdescCNT+"--SUB "+itemCNTsub[itemno]+"--ITEMTOTAL "+itemCNTtotal + "<BR>");                 

            }
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }
          }

// End ITEM Count

          String b[][] = new String[itemCNTtotal+1][columns];

          int j = 0;

          for( int i=0 ; i< rows ; i++ )
          {
  
            //attention: The first parameter is column,the second parameter is row.  
             cellpartdesc = sheet.getCell(1,i+26);
             cellqty =  sheet.getCell(3,i+26);
             cellreqdate = sheet.getCell(4,i+26);
             cellunitprice = sheet.getCell(6,i+26);
             
             String QtyCheck =  cellqty.getContents();
             String ReqDate  =  cellreqdate.getContents();
             
             if(QtyCheck.trim() != "" && ReqDate.trim() != "")
             {
             
             BufferPartDesc[1][i] = cellpartdesc.getContents();
             BufferQuantity[3][i] = replace(replace(cellqty.getContents(),".0",""),",","");
             
             String strdate = cellreqdate.getContents();          
             String year    = strdate.substring(6,8);
             String month   = strdate.substring(3,5);
             String day     = strdate.substring(0,2);
             BufferRequestDate[4][i] = "20"+year+month+day;

             // Convert Unit Price in EA (Default TSCE price is 100EA/price)

             BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);
             BufferUnitPrice[6][i] = Double.parseDouble(cellunitprice.getContents())/100;

             // Get TSC Part Number

             try
             {

             // To Check the ITEM result records
                  
              //out.println("SUB LOOP "+itemCNTsub[i]);

                    String sqlUOM = "";
                    sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+BufferPartDesc[1][i]+"' ";
                    Statement stateUOM=con.createStatement();
                    ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);

                    while (rsUOM.next ())
                    {	   
                       BufferUOM[1][i]         = rsUOM.getString("PRIMARY_UOM_CODE");   
	               BufferPartNumber[1][i]  = rsUOM.getString("SEGMENT1");
	               BufferPartDescNew[1][i] = rsUOM.getString("DESCRIPTION");

                       //out.println("PART DESC"+BufferPartDescNew[1][i]+" PART NUMBER"+ BufferPartNumber[1][i] +"<BR>");

                    //}
                    //rsUOM.close();
                    //stateUOM.close(); 
           
                     // Set into ArrayBean for TSSalesDRQCreateImport.jsp page
                    if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
                    {
                    iNo = Integer.toString(j+1);
                    //out.println("iNo"+iNo);  
                    //out.println("PART DESC "+BufferPartDescNew[1][i]+" PART NUMBER"+ BufferPartNumber[1][i] +"<BR>");

                    b[j][0]=iNo;
                    b[j][1]=BufferPartNumber[1][i];
                    b[j][2]=BufferPartDescNew[1][i];
                   
                    // Convert into KPC
                    b[j][3]=Double.toString(BufferQuantityNew[3][i]/1000.);

                    b[j][4]=BufferUOM[1][i];
                    b[j][5]=BufferRequestDate[4][i];

                    if( itemCNTsub[i]==1 )
                    {
                    b[j][6]="BufferStock"; 
                    }
                    else 
                    {
                    b[j][6]="** DUPLICATED **";
                    }
      
		    if (b[j][1]!=null && b[j][1].trim()!="" )
		    {		
                     arrayRFQDocumentInputBean.setArray2DString(b);
                     arrayRFQDocumentInputBean.setArray2DCheck(b);		
		    } 	
		    j++;

 
                 } // End of if ()

               } // while next end
               rsUOM.close();
               stateUOM.close();

               }
               catch (Exception e)
               {
                 out.println("Exception:"+e.getMessage());
               }

	   // j++;
            session.setAttribute("MAXLINENO",iNo);
           } // End of if (BufferPartDesc[1][j] != "" && BufferQuantity[3][j] != "")

       }  // End of for ()

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
      wwb.close();
         
     //Delete Temp Files, change location

     File tmpfile = new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCEBuffer/TEMP_"+fileMover.getFileName());
     boolean deleted= tmpfile.delete();

     }
     else  {
            out.println("<li>No uploaded files");
           }
     }
     else out.println("<BR> todo="+todo);
     }
         
%>
</font></ul>
<form method="post" action="TSCEBufferImportTwo.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

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
  
  //if (q!=null) 
  //{//out.println("<BR>");		  
				    //out.println(q[0][0]+ " " +q[0][1]+" " +q[0][2]+" " +q[0][3]+" " +q[0][4]+" " +q[0][5]+" " +q[0][6]+"<BR>");	
				    //out.println(q[1][0]+ " " +q[1][1]+" " +q[1][2]+" " +q[1][3]+" " +q[1][4]+" " +q[1][5]+" " +q[1][6]+"<BR>");
				    //out.println(q[2][0]+ " " +q[2][1]+" " +q[2][2]+" " +q[2][3]+" " +q[2][4]+" " +q[2][5]+" " +q[2][6]+"<BR>");	
					//out.println(q[3][0]+ " " +q[3][1]+" " +q[3][2]+" " +q[3][3]+" " +q[3][4]+" " +q[3][5]+" " +q[3][6]+"<BR>");				   
					//out.println(arrayRFQDocumentInputBean.getArray2DString());
  //}

  //out.println(q.length);
 
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
        TSCE 1213 Order in Excel format to upload :</b></font></td>
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
