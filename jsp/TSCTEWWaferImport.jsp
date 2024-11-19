<html>
<head>
<title>TSC TEW Wafer Testing Data Import </title>

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
  <jsp:setProperty name="upBean" property="folderstore" value="D:/resin-2.1.9/webapps/oradds/jsp/TSCWaferImport/" />
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
        fileMover.setNewfilename("TSCTEWWaferImport_"+sdf.format(new java.util.Date())+".xls");
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
         Workbook rw = Workbook.getWorkbook(new File("D:/resin-2.1.9/webapps/oradds/jsp/TSCWaferImport/"+fileMover.getFileName()));
   
         Sheet sheet = rw.getSheet(0);
 
         // 取得 Wafer 批號

         Cell   cellwaferlotno   = sheet.getCell(6,6);
         String WaferLotNo       = cellwaferlotno.getContents();

         // 取得測試條件

         Cell cellifa           = sheet.getCell(1,9);
         Cell cellvrv           = sheet.getCell(2,9);
         Cell celliz1           = sheet.getCell(3,9);
         Cell cellvf1l          = sheet.getCell(1,11);
         Cell cellvf1h          = sheet.getCell(1,12);
         Cell cellir1l          = sheet.getCell(2,11);
         Cell cellir1h          = sheet.getCell(2,12);
         Cell cellvz1l          = sheet.getCell(3,11);
         Cell cellvz1h          = sheet.getCell(3,12);
         Cell celltrr1l         = sheet.getCell(4,11);
         Cell celltrr1h         = sheet.getCell(4,12);

         String IFA             = replace(cellifa.getContents(),"@","");
         String VRV             = replace(cellvrv.getContents(),"@","");
         String IZ1             = replace(celliz1.getContents(),"@","");
         String VF1L            = cellvf1l.getContents();
         String VF1H            = cellvf1h.getContents();
         String IR1L            = cellir1l.getContents();
         String IR1H            = cellir1h.getContents();
         String VZ1L            = cellvz1l.getContents();
         String VZ1H            = cellvz1h.getContents();
         String TRR1L           = celltrr1l.getContents();
         String TRR1H           = celltrr1h.getContents();


         // out.println(IFA+"-"+VRV+"-"+IZ1+"-"+VF1L+"-"+VF1H+"-"+IR1L+"-"+IR1H+"-"+VZ1L+"-"+VZ1H+"-"+TRR1L+"-"+TRR1H);

         // 載入資料庫 ORADDMAN.TSCIQC_LOTDRAWING_HEADER


        String sql="insert into ORADDMAN.TSCIQC_LOTDRAWING_HEADER("+
                   "VND_LOT_NUM,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,VF1L,VF1H,IR1L,IR1H,VZ1L,VZ1H,TRR1L,TRR1H)"+
                   " values(?,?,?,?,?,?,?,?,?,?,?,?)";  
               PreparedStatement pstmt=con.prepareStatement(sql);
                                 pstmt.setString(1,WaferLotNo);
                                 pstmt.setString(2,IFA);  
                                 pstmt.setString(3,VRV);
                                 pstmt.setString(4,IZ1);  
                                 pstmt.setString(5,VF1L);
                                 pstmt.setString(6,VF1H);
                                 pstmt.setString(7,IR1L);             
                                 pstmt.setString(8,IR1H);
                                 pstmt.setString(9,VZ1L);   
                                 pstmt.setString(10,VZ1H); 
      	                         pstmt.setString(11,TRR1L);
                                 pstmt.setString(12,TRR1H);  
                                 pstmt.executeUpdate();
                                 pstmt.close();

         // out.println("PASS SQL");
         // rw.close();

         // 讀取第二頁之 worksheet

         Sheet sheetdata = rw.getSheet(1);

         // 取得測試數據
        
         Cell cellrecordno   = null;
         Cell cellbinno      = null;
         Cell cellconta      = null;
         Cell cellcontc      = null;
         Cell cellpolar      = null;
         Cell cellvf         = null;
         Cell cellirt        = null;
         Cell cellvrt        = null;
         Cell celldirt       = null;
         Cell cellvz1        = null;
         Cell celldvz1       = null;
         Cell celldvz2       = null;
         Cell celltrr        = null;

         String    RecordNo  = null;
         String    BinNo     = null;
         String    Conta     = null;
         String    Contc     = null;
         String    Polar     = null;
         String    VF        = null;
         String    IRT       = null;
         String    VRT       = null;
         String    VZ1       = null;
         String    TRR       = null;

         // Set first array

         String oneDArray[]= {"","Wafer Lot No.","RecordNo","BinNo","CONTA","CONTC","POLAR","VF","IRT","VRT","VZ1","TRR"}; 		 	     			  
         arrayRFQDocumentInputBean.setArrayString(oneDArray);
	         
         int rows    = sheetdata.getRows(); 
         int columns = sheetdata.getColumns(); 

         out.println(rows);
         out.println(columns);

         String iNo=null;
         int itemCNTsub[]             = new int[rows];
         String b[][]                 = new String[rows][columns+1];
         
         for( int i=0 ; i< rows-1 ; i++ )
         {
  
            //attention: The first parameter is column,the second parameter is row.  



             cellrecordno   = sheetdata.getCell(0,i+1);
             cellbinno      = sheetdata.getCell(1,i+1);
             cellconta      = sheetdata.getCell(2,i+1);
             cellcontc      = sheetdata.getCell(3,i+1);
             cellpolar      = sheetdata.getCell(4,i+1);
             cellvf         = sheetdata.getCell(5,i+1);
             cellirt        = sheetdata.getCell(6,i+1);
             cellvrt        = sheetdata.getCell(7,i+1);
             cellvz1        = sheetdata.getCell(9,i+1);
             celltrr        = sheetdata.getCell(12,i+1);

             // Set CLASS_ID as contant

             String ClassID    = "01";
             String SourceCode = "TEW";
             RecordNo     = cellrecordno.getContents();
             BinNo        = cellbinno.getContents();
             Conta        = cellconta.getContents();
             Contc        = cellcontc.getContents();
             Polar        = cellpolar.getContents();
             VF           = cellvf.getContents();
             IRT          = cellirt.getContents();
             VRT          = cellvrt.getContents();
             VZ1          = cellvz1.getContents();
             TRR          = celltrr.getContents();
            
             b[i][0]=WaferLotNo;
             b[i][1]=RecordNo;
             b[i][2]=BinNo;
             b[i][3]=Conta;
             b[i][4]=Contc;
             b[i][5]=Polar;
             b[i][6]=VF;
             b[i][7]=IRT;  
             b[i][8]=VRT;
             b[i][9]=VZ1;
             b[i][10]=TRR;

        try
        {

       String sqll="insert into ORADDMAN.TSCIQC_LOTDRAWING_DETAIL("+
                   "VND_LOT_NUM,CLASS_ID,SOURCE_CODE,SEQ_NO,BIN_NO,CONTA,CONTC,POLAR,VF,IRT,VRT,VZ1,TRR)"+
                   " values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
              PreparedStatement pstmtl=con.prepareStatement(sqll);
                                pstmtl.setString(1,WaferLotNo);
                                pstmtl.setString(2,ClassID);
                                pstmtl.setString(3,SourceCode);
                                pstmtl.setString(4,RecordNo);
                                pstmtl.setString(5,BinNo);  
                                pstmtl.setString(6,Conta);
                                pstmtl.setString(7,Contc);  
                                pstmtl.setString(8,Polar);
                                pstmtl.setString(9,VF);  
                                pstmtl.setString(10,IRT);
                                pstmtl.setString(11,VRT);  
                                pstmtl.setString(12,VZ1);
                                pstmtl.setString(13,TRR);
                                pstmtl.executeUpdate();
                                pstmtl.close();    
        }
        catch (Exception e)
        {
         out.println("Exception:"+e.getMessage());
        }
					
             arrayRFQDocumentInputBean.setArray2DString(b);
             arrayRFQDocumentInputBean.setArray2DCheck(b);	

	 // 取得載入的行數

         session.setAttribute("IMPORTRECORD",RecordNo);
	     	
       } // end of for loop
      
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
<form method="post" action="TSCTEWWaferImport.jsp?UPLOADFLAG=Y" name="upform" enctype="multipart/form-data">

<% //TSCEBufferImport.jsp?UPLOADFLAG=Y

  String ImportRecord = (String)session.getAttribute("IMPORTRECORD");

  //String q[][]=arrayRFQDocumentInputBean.getArray2DContent();//取得目前陣列內容 		
 
  //if (q!=null) 
  //{//out.println("<BR>");		  
  //  out.println(arrayRFQDocumentInputBean.getArray2DBufferString());
  // }		
                       		    		  	   		   
  if (uploadFlag == null) 
  {  }
  else if (uploadFlag == "Y" || uploadFlag.equals("Y"))
  { 
   String urlDir = "TSCWaferImportStatus.jsp?"+"IMPORTRECORD="+ImportRecord;
   response.sendRedirect(urlDir);
  }		
			
				   
%>
  <table width="60%" border="0" cellspacing="1" cellpadding="1" align="center">
    <tr>
      <td align="left"><font size="-1" face="Verdana, Arial, Helvetica, sans-serif"><b>Select
        TSC TEW Wafer Test Excel Report to upload :</b></font></td>
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
