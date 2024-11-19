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
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCTNiec/" />
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
        fileMover.setNewfilename("TSCRFairChild_"+sdf.format(new java.util.Date())+".xls");
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
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCTNiec/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         Cell   cellorderno   = sheet.getCell(7,1);
         String BufferOrderNo = cellorderno.getContents();

         out.println(BufferOrderNo);

         String BufferCurrency = "USD";
         
         Cell cellpartdesc = null;
         //Cell cellpartdesc2 = null;
         Cell cellqty = null;

         //Cell cellreqdate = sheet.getCell(5,1);

         //DateCell datec11 = (DateCell)cellreqdate;
         //java.util.Date ReqDate  =  datec11.getDate();

         //SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
         //String calstrdate=sy1.format(ReqDate);
         
         //java.util.Date dt = sy1.parse(calstrdate);
         //Calendar rightNow = Calendar.getInstance();
         //rightNow.setTime(dt);
         //rightNow.add(Calendar.MONTH,1);
         //java.util.Date dt1=rightNow.getTime();

         //String strdate=sy1.format(dt1); 

         //out.println("DATE"+strdate);
         //out.println("DATE1"+ReqDate);

         

         Cell cellunitprice = null;

         // Set first array for TSSalesDRQCreateImport.jsp

         String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
         // Set TSCR Order Default Value
   
         session.setAttribute("SPQCHECKED","N");
         session.setAttribute("CUSTOMERID","1220");
         session.setAttribute("CUSTOMERNO","1107");
         session.setAttribute("CUSTOMERNAME","FAIRCHILD SEMICONDUCTOR HONG KONG (HOLDINGS) LTD.");
         session.setAttribute("CUSTOMERPO", BufferOrderNo);
         session.setAttribute("CURR", BufferCurrency);
         session.setAttribute("CUSTACTIVE","A");
         session.setAttribute("SALESAREANO","009");
         session.setAttribute("REMARK","Order Import from file");
         session.setAttribute("PREORDERTYPE","1020");
         session.setAttribute("ISMODELSELECTED","Y");
         session.setAttribute("PROCESSAREA","009(半導體事業部-R.O.W.)");
         session.setAttribute("CUSTOMERIDTMP","1220");
         session.setAttribute("INSERT","Y");

         int rows    = sheet.getRows(); 
         int columns = sheet.getColumns();

         //out.println(rows);
         //out.println(columns);

         String iNo=null;
         String partdescCNT=null;
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
         // MUST Call Below before query view
         
         try
            {

	      CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	      cs1.setString(1,"41");
	      cs1.execute();
              //out.println("Procedure : Execute Success !!! ");
              cs1.close();
            }
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }


          int itemCNTtotal = 0;

          for ( int itemno=0 ; itemno < rows-10 ; itemno++)
          {
             cellpartdesc = sheet.getCell(0,itemno+10);
             String partdesctmp   = cellpartdesc.getContents();
             String[] partdesctmp2 = partdesctmp.split(" ",-1);
             String partdesc = partdesctmp2[2];
           
             if(!partdesc.equals("TOTAL"))
             {
             partdescCNT = cellpartdesc.getContents();
             }
            
           // Get TSC Part Number

           try
            {
           
           // To Check the ITEM result records

               String sqlCNTitem = "";
               sqlCNTitem = "select count(*) from APPS.OE_ITEMS_V where ITEM = '"+partdescCNT+"' AND ITEM_DESCRIPTION NOT LIKE '%Disable%' ";
               Statement stateCNTitem=con.createStatement();
               ResultSet rsCNTitem=stateCNTitem.executeQuery(sqlCNTitem);
               rsCNTitem.next();
               itemCNTsub[itemno] = rsCNTitem.getInt(1);

               if(rsCNTitem.getInt(1) == 0) 
               {
                 itemCNTsub[itemno]=1;
               }
            
               itemCNTtotal = itemCNTtotal + itemCNTsub[itemno];      

               //out.println("<BR>"+"ITEMNO"+itemno+"--ITEM "+partdescCNT+"--SUB "+itemCNTsub[itemno]+"--ITEMTOTAL "+itemCNTtotal + "<BR>");                 

            }
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }
         } // End for itemno

// End ITEM Count

          String b[][] = new String[itemCNTtotal+1][columns];

          int j = 0;

          for( int i=0 ; i< rows-10 ; i++ )
          {
  
             // Check flag for WRONG ITEM NUMBER

             String CheckNext = "N";

            //attention: The first parameter is column,the second parameter is row.  

             cellpartdesc = sheet.getCell(0,i+5);
             cellqty =  sheet.getCell(3,i+5);
             //cellreqdate = sheet.getCell(4,i+5);
             
             cellunitprice = sheet.getCell(2,i+5);
             
             String QtyCheck =  replace(cellqty.getContents(),",","");
             //String ReqDate  =  cellreqdate.getContents();
             
             if(QtyCheck.trim() != "" && strdate.trim() != "")
             {
             
             BufferPartDesc[1][i] = cellpartdesc.getContents();
             BufferQuantity[3][i] = QtyCheck;
             
             //String strdate = cellreqdate.getContents();          
             BufferRequestDate[4][i] = strdate;


             BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);
             BufferUnitPrice[6][i] = Double.parseDouble(cellunitprice.getContents());

             // Get TSC Part Number

             try
             {

             // To Check the ITEM result records
                  
              //out.println("SUB LOOP "+itemCNTsub[i]);
              //out.println(BufferPartDesc[1][i]);

                    String sqlUOM = "";
                    //String sql1 = "";
                    //String sql2 = "";
                    //String sql3 = "";

                    sqlUOM = "select b.INVENTORY_ITEM_ID INVENTORY_ITEM_ID, b.SEGMENT1 SEGMENT1, b.DESCRIPTION DESCRIPTION, b.PRIMARY_UOM_CODE PRIMARY_UOM_CODE from APPS.OE_ITEMS_V a, APPS.MTL_SYSTEM_ITEMS b where a.item= '"+BufferPartDesc[1][i]+"' and a.item_description not like '%Disable%' and a.INVENTORY_ITEM=b.SEGMENT1 and b.ORGANIZATION_ID = '49'";
 
                    Statement stateUOM=con.createStatement();
                    ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);

                    while (rsUOM.next ())
                    {	   
                       CheckNext = "Y";
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
                    b[j][6]="FairChild Import"; 
                    }
                    else 
                    {
                    b[j][6]="** DUPLICATED"+i+" **";
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
                  b[j][5]=BufferRequestDate[4][i];                   
                  b[j][6]="*WRONG*";
     

        	    if (b[j][1]!=null && b[j][1].trim()!="" )
		    {		
                     arrayRFQDocumentInputBean.setArray2DString(b);
                     arrayRFQDocumentInputBean.setArray2DCheck(b);		
		    } 	
		    j++;
                } // end if(CheckNext.equals("Y"))

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
<form method="post" action="TSCTNiecImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

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
          //String fromPage        = (String)session.getAttribute("FROMPAGE");

  String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 		
                       		    		  	   		   
  if (uploadFlag == null) 
  {  }
  else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  { 
   String urlDir = "TSSalesDRQCreateImport.jsp?"+"CUSTOMERID="+CustomerId+"&SPQCHECKED="+SPQChecked+"&CUSTOMERNO="+CustomerNo+"&CUSTOMERNAME="+CustomerName+"&CUSTACTIVE="+CustActive+"&SALESAREANO="+SalesAreaNo+"&SALESPERSON="+SalesPerson+"&SALESPERSONID="+SalesPersonId+"&CUSTOMERPO="+CustomerPo+"&CURR="+Curr+"&REMARK="+Remark+"&PREORDERTYPE="+PreOrderType+"&ISMODELSELECTED="+IsModelSelected+"&PROCESSAREA="+ProcessArea+"&CUSTOMERIDTMP="+CustomerIdTmp+"&INSERT="+Insert;
   //response.sendRedirect(urlDir);
  }		
			
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSCR FairChild Order in Excel format to upload :</b></font></td>
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
