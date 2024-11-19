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
<%@ page errorPage="ExceptionHandler.jsp" %>

<!--===========Change the directory location below ======================-->
<jsp:useBean id="fileMover" scope="page" class="uploadutilities.FileMover" />
<jsp:useBean id="upBean" scope="page" class="javazoom.upload.UploadBean" >
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCTTantron/" />
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
        fileMover.setNewfilename("TSCTTantron_"+sdf.format(new java.util.Date())+".xls");
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
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCTTantron/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         Cell   cellorderno   = sheet.getCell(1,1);
         String BufferOrderNo = cellorderno.getContents();
         out.println(BufferOrderNo);

         Cell   cellcurrency = sheet.getCell(1,4);
         String BufferCurrency = cellcurrency.getContents();
         
         Cell cellpartdesc = null;
         Cell cellqty = null;
         Cell cellreqdate = null;
         Cell cellunitprice = null;

         // Set first array for TSSalesDRQCreateImport.jsp

         String oneDArray[]= {"","No.","Inventory Item","Item Description","Order Qty","UOM","Request Date","Remark"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	
         // Set TSCA Order Default Value
   
         session.setAttribute("SPQCHECKED","N");
         session.setAttribute("CUSTOMERID","1019");
         session.setAttribute("CUSTOMERNO","1107");
         session.setAttribute("CUSTOMERNAME","FAIRCHILD SEMICONDUCTOR HONG KONG (HOLDINGS) LTD.");
         session.setAttribute("CUSTOMERPO", BufferOrderNo);
         session.setAttribute("CURR", BufferCurrency);
         session.setAttribute("CUSTACTIVE","A");
         session.setAttribute("SALESAREANO","008");
         session.setAttribute("REMARK","Order Import from file");
         session.setAttribute("PREORDERTYPE","1020");
         session.setAttribute("ISMODELSELECTED","Y");
         session.setAttribute("PROCESSAREA","009(半導體事業部-R.O.W.)");
         session.setAttribute("CUSTOMERIDTMP","1019");
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


// Process to determine the total item records

          int itemCNTtotal = 0;

          for ( int itemno=0 ; itemno < rows-7 ; itemno++)
          {
             cellpartdesc = sheet.getCell(2,itemno+6);
             //String partdesc   = cellpartdesc.getContents();
             //String partdescCNT = partdesc;

             String partdescCNT = cellpartdesc.getContents();
             
           // Get TSC Part Number

          if (partdescCNT.trim() !="")
          {
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
           } //end if (partdescCNT.trim() !="")
          }

 // End ITEM Count

         String b[][] = new String[itemCNTtotal+1][columns];

         int j = 0;  
          
         for( int i=0 ; i< rows-7 ; i++ )
         {
  
            //attention: The first parameter is column,the second parameter is row.  

             cellpartdesc = sheet.getCell(2,i+6);
             cellqty =  sheet.getCell(3,i+6);
             cellreqdate = sheet.getCell(6,i+6);
             String strdate="";
             //String strtype = cellreqdate.getType();
             out.println("TYPE"+cellreqdate.getType());

             //DateCell datec11 = (DateCell)cellreqdate;
             //java.util.Date ReqDate  =  datec11.getDate();
             //out.println(ReqDate);
             //SimpleDateFormat sy1=new SimpleDateFormat("M/d/yyyy");
             //String strdatenew=sy1.format(strdate);

             //if (!cellreqdate.getType().equals("Empty"))
             //{/
             //String format = "d/M/yyyy";
             //SimpleDateFormat sdfnew = new SimpleDateFormat(format);
             //sdfnew.parse(strdate);
             //}

             cellunitprice = sheet.getCell(4,i+6);          

             String QtyCheck =  cellqty.getContents();
             out.println(QtyCheck);

             if (cellreqdate.getType() == CellType.DATE)
             {

             DateCell datec11 = (DateCell)cellreqdate;
             java.util.Date ReqDate  =  datec11.getDate();
             out.println(ReqDate);
             SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
             strdate=sy1.format(ReqDate);
             //strdate="20060101";
             out.println(strdate);
             }
            
             //out.println(strdate);

             //String strdate = cellreqdate.getContents();          
             //String year    = strdate.substring(5,9);
             //String month   = strdate.substring(3,5);
             //String day     = strdate.substring(0,2);
             //BufferRequestDate[4][i] = "20"+year+month+day;           
             //String ReqDate = year+monthmm+day;
             
             if(QtyCheck.trim() != "" && strdate.trim() != "")
            {
             
             String partdesc   = cellpartdesc.getContents();
             out.println(partdesc+"<BR>");
             //String partdesctmp = cellpartdesc2.getContents();
             //String partdesc2   = partdesctmp.substring(0,2);
             
             BufferPartDesc[1][i] = partdesc;
             //BufferRequestDate[2][i] = year+month+day;
             BufferQuantity[3][i] = QtyCheck;
             BufferUnitPrice[7][i] = Double.parseDouble(cellunitprice.getContents());
             BufferQuantityNew[3][i] = Integer.parseInt(BufferQuantity[3][i]);

             // Get TSC Part Number

         
             session.setAttribute("MAXLINENO",iNo);
             
            out.println(i+"--"+QtyCheck+"--"+strdate+"--"+partdesc+"--"+BufferUnitPrice[7][i]+"--"+BufferQuantityNew[3][i]);

            }  // end of (QtyCheck.trim() != "" && ReqDate.trim() != "")

       } // end of for loop


  // Get the SalesPerson and SalesPersonID SQL


          
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
<form method="post" action="TSCTTantronImportTwo.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

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
   //response.sendRedirect(urlDir);
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
