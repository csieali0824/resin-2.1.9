<html>
<head>
<title>TSCA Order Import </title>

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
<!--%@ page errorPage="ExceptionHandler.jsp" %-->

<!--===========Change the directory location below ======================-->
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCABuffer/" />
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

<%  out.println("Trace 1");

      if (MultipartFormDataRequest.isMultipartFormData(request))  {
        // Rename the file name with the following rule.
	SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd_HHmmss");
        fileMover.setNewfilename("TSCABuffer_"+sdf.format(new java.util.Date())+".xls");
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
out.println("Trace 2");
         // Change the directory location below
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCABuffer/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         Cell   cellorderno   = sheet.getCell(0,1);
         String BufferOrderNo = cellorderno.getContents();
         String BufferCurrency = "USD";
         
         Cell cellpartdesc1 = null;
         Cell cellpartdesc2 = null;
         Cell cellqty = null;
         Cell cellreqdate = null;
         Cell cellunitprice = null;

         // Set first array for TSSalesDRQCreateImport.jsp

         String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
         // Set TSCA Order Default Value
   
         session.setAttribute("SPQCHECKED","N");
         session.setAttribute("CUSTOMERID","1019");
         session.setAttribute("CUSTOMERNO","1008");
         session.setAttribute("CUSTOMERNAME","TSC America, Inc.");
         session.setAttribute("CUSTOMERPO", BufferOrderNo);
         session.setAttribute("CURR", BufferCurrency);
         session.setAttribute("CUSTACTIVE","A");
         session.setAttribute("SALESAREANO","008");
         session.setAttribute("REMARK","Order Import from file");
         session.setAttribute("PREORDERTYPE","1020");
         session.setAttribute("ISMODELSELECTED","Y");
         session.setAttribute("PROCESSAREA","008(¢Db?EAe¡LA¡P~3!-?u¢Xe¢XI)");
         session.setAttribute("CUSTOMERIDTMP","1019");
         session.setAttribute("INSERT","Y");
out.println("Trace 3");
         int rows    = sheet.getRows()-1; 
         int columns = sheet.getColumns()-1; 
		 
		 //int rows    = sheet.getRows(); 
         //int columns = sheet.getColumns(); 
		 
		 out.println("rows="+rows);
		 out.println("columns="+columns);

         String iNo=null;
         String b[][]                 = new String[rows][columns];
         String BufferPartDesc[][]    = new String[columns][rows];
         String BufferQuantity[][]    = new String[columns][rows];
         int    BufferQuantityNew[][] = new int[columns][rows];
         String BufferRequestDate[][] = new String[columns][rows];
         double BufferUnitPrice[][]   = new double[columns][rows];
         String BufferUOM[][]         = new String[columns][rows];
         String BufferPartNumber[][]  = new String[columns][rows];
         String BufferPartDescNew[][] = new String[columns][rows];

         int j = 0;  
          
         for( int i=0 ; i< rows ; i++ )
         {
  
            //attention: The first parameter is column,the second parameter is row.  

             cellpartdesc1 = sheet.getCell(1,i+1);
             cellpartdesc2 = sheet.getCell(3,i+1);
             cellqty =  sheet.getCell(9,i+1);
             cellreqdate = sheet.getCell(2,i+1);
             cellunitprice = sheet.getCell(7,i+1);          

             String QtyCheck =  cellqty.getContents();
             String strdate   =  cellreqdate.getContents();

             String year    = strdate.substring(7,9);
             String monthMMM   = strdate.substring(3,6);         
             String day     = strdate.substring(0,2);
             String monthmm = null;
               
             if (monthMMM.equals("Jan"))
             {monthmm="01";}
             else if (monthMMM.equals("Feb"))
             {monthmm="02";}
             else if (monthMMM.equals("Mar"))
             {monthmm="03";}
             else if (monthMMM.equals("Apr"))
             {monthmm="04";}
             else if (monthMMM.equals("May"))
             {monthmm="05";}
             else if (monthMMM.equals("Jun"))
             {monthmm="06";}
             else if (monthMMM.equals("Jul"))
             {monthmm="07";}
             else if (monthMMM.equals("Aug"))
             {monthmm="08";}
             else if (monthMMM.equals("Sep"))
             {monthmm="09";}
             else if (monthMMM.equals("Oct"))
             {monthmm="10";}
             else if (monthMMM.equals("Nov"))
             {monthmm="11";}
             else if (monthMMM.equals("Dec"))
             {monthmm="12";}
             else
             {monthmm="";}       
			      
             String ReqDate = null;
             if (year != null && monthmm != null && day !=null && year != "" && monthmm !="" && day !="")
             { ReqDate = "20"+year+monthmm+day;}
             else { ReqDate="NO DEFINED";}
             out.println("ReqDate="+ReqDate);
             if(QtyCheck.trim() != "" && ReqDate.trim() != "")
             {
             
             String partdesc1   = replace(cellpartdesc1.getContents()," T/R","");
             String partdesctmp = cellpartdesc2.getContents();
             String partdesc2   = partdesctmp.substring(0,2);
             
             BufferPartDesc[1][i] = partdesc1+" "+partdesc2;
             BufferRequestDate[2][i] = ReqDate;
             BufferQuantity[3][i] = QtyCheck;
             BufferUnitPrice[7][i] = Double.parseDouble(cellunitprice.getContents());
             BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);
out.println("Trace 4");
             // Get TSC Part Number

             try
              {
                String sqlUOM = "";
                sqlUOM = "select INVENTORY_ITEM_ID,SEGMENT1,DESCRIPTION,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+BufferPartDesc[1][i]+"' ";
                Statement stateUOM=con.createStatement();
                ResultSet rsUOM=stateUOM.executeQuery(sqlUOM);
	            out.println("Trace 4.1");
                while (rsUOM.next ())
                 {	   out.println("Trace 4.2");
                   BufferUOM[1][i]         = rsUOM.getString("PRIMARY_UOM_CODE");   
                   BufferPartNumber[1][i]  = rsUOM.getString("SEGMENT1"); 
	           BufferPartDescNew[1][i] = rsUOM.getString("DESCRIPTION");
                 }
                rsUOM.close();
                stateUOM.close(); 

                // Set into ArrayBean for TSSalesDRQCreateImport.jsp page
                if (BufferPartNumber[1][i].trim() !=null && BufferPartNumber[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null && BufferPartDescNew[1][i].trim() !=null)
                { out.println("Trace 4.3");
				  out.println("BufferPartNumber[1][i]="+BufferPartNumber[1][i]);
				   out.println("BufferPartDescNew[1][i]="+BufferPartDescNew[1][i]);
                  iNo = Integer.toString(j+1);  
                  b[j][0]=iNo;
                  b[j][1]=BufferPartNumber[1][i];
                  b[j][2]=BufferPartDescNew[1][i];

                  // Convert into KPC
                  b[j][3]=Double.toString(BufferQuantityNew[3][i]/1000.);
                  out.println("BufferQuantityNew[3][i]="+BufferQuantityNew[3][i]);
				  out.println("BufferUOM[1][i]="+BufferUOM[1][i]);
				  out.println("BufferRequestDate[2][i]="+BufferRequestDate[2][i]);
                  b[j][4]=BufferUOM[1][i];
				  out.println("Trace 4.4");
				  out.println("j="+j+"<BR>");
                  b[j][5]=BufferRequestDate[2][i];
				
				  out.println("Trace 4.5");
                  b[j][6]="TSCA Order Import";        

        	    if (b[j][1]!=null && b[j][1].trim()!="" )
		        {		out.println("Trace 4.6");
                     arrayRFQDocumentInputBean.setArray2DString(b);
                     arrayRFQDocumentInputBean.setArray2DCheck(b);
                     //out.println(arrayRFQDocumentInputBean.getArray2DCheck());
					 out.println("Trace 4.7");
		        } 	
		    j++;

                 } // end of if

               } // end of try
               catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                }
         
             session.setAttribute("MAXLINENO",iNo);
            out.println("Trace 4.6"); 
            //out.println(i+"--"+QtyCheck+"--"+ReqDate+"--"+partdesc1+" "+partdesc2+"--"+Double.parseDouble(cellunitprice.getContents())+"--");

             }  // end of (QtyCheck.trim() != "" && ReqDate.trim() != "")

       } // end of for loop
out.println("Trace 5");              
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
<form method="post" action="TSCABufferImportTwo.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

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

  String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//¡Lu¡Óo¢DO?e¢X}|C?oRe

  if (q!=null) 
  {out.println("<BR>");		  
				    //out.println(q[0][0]+ " " +q[0][1]+" " +q[0][2]+" " +q[0][3]+" " +q[0][4]+" " +q[0][5]+" " +q[0][6]+"<BR>");	
				    //out.println(q[1][0]+ " " +q[1][1]+" " +q[1][2]+" " +q[1][3]+" " +q[1][4]+" " +q[1][5]+" " +q[1][6]+"<BR>");
				   // out.println(q[2][0]+ " " +q[2][1]+" " +q[2][2]+" " +q[2][3]+" " +q[2][4]+" " +q[2][5]+" " +q[2][6]+"<BR>");	
					//out.println(q[3][0]+ " " +q[3][1]+" " +q[3][2]+" " +q[3][3]+" " +q[3][4]+" " +q[3][5]+" " +q[3][6]+"<BR>");				   
					//out.println(arrayRFQDocumentInputBean.getArray2DDocumentString());
  } 		
                       		    		  	   		   
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
        TSCA  Order in Excel format to upload :</b></font></td>
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
