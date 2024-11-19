<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
  
<%
mySmartUpload.initialize(pageContext); 
mySmartUpload.upload();
//out.println("Step1");
com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
//out.println("Step2");
        try
	         {     
				Statement statement=dmcon.createStatement();
			    String sSql="select FILENAME "+" "+
		                           "from MDCKLIST  "; 
		        String sWhere="where  FILENAME='"+uploadFile_name+"'"; 
		        
	            sSql=sSql+sWhere; 
	            //out.println(sSql);      					 
	            ResultSet rs=statement.executeQuery(sSql);
		        if(rs.next())
			    {
				String sqld="delete from  MDCKLIST where  FILENAME='"+uploadFile_name+"'";   
                PreparedStatement dstmt=dmcon.prepareStatement(sqld);      
                dstmt.executeUpdate();           
                dstmt.close();
				}
				 statement.close();
	             rs.close();
				}//end of try
		       catch (Exception e)
             {
               e.printStackTrace();
               out.println(e.getMessage());
              }//end of catch
				

             String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
             String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
			 

      
            /*  For Excel View  */         
            // 取得上傳Excel報表
	        InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 			
			
            jxl.Workbook wb = Workbook.getWorkbook(is);                
            //jxl.Sheet sht = wb.getSheet(0);
			
			jxl.Sheet sht = wb.getSheet("C4-EP1");      
            int rowCount = sht.getRows();  // 取此次筆數 
            //out.println("rowCount="+rowCount);
			 jxl.Cell wcMODEL = sht.getCell(1, 0);    //ws.getWritableCell(int column, int row);  // 讀model                               
             String MODEL = wcMODEL.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+MODEL+"</font></td>");
			  jxl.Cell wcPHASE = sht.getCell(1, 1);    //ws.getWritableCell(int column, int row);  // 讀階段                                
             String PHASE = wcPHASE.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+PHASE+"</font></td>");
			  jxl.Cell wcGDATE = sht.getCell(1, 2);    //ws.getWritableCell(int column, int row);  // 讀產出日期                               
             String GDATE = wcGDATE.getContents();                         
			  
			  //String sYEAR=  GDATE.substring(6)     ; 
			  //String sMonth= GDATE.substring(3,5)     ; 
			  //String sDay=  GDATE.substring(0,2)     ; 
			  //GDATE=sYEAR+"/"+sMonth+"/"+sDay; 
			   out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+GDATE+"</font></td>");
			 
			  jxl.Cell wcRFTB = sht.getCell(1, 3);    //ws.getWritableCell(int column, int row);  // 讀RF                                
             String RFTB = wcRFTB.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+RFTB+"</font></td>");
			  jxl.Cell wcQTY = sht.getCell(4, 2);    //ws.getWritableCell(int column, int row);  // 讀數量                         
             String QTY = wcQTY.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+QTY+"</font></td>");
			  jxl.Cell wcADTB = sht.getCell(4, 3);    //ws.getWritableCell(int column, int row);  // 讀ADTB                                
             String ADTB = wcADTB.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+ADTB+"</font></td>");
			  jxl.Cell wcHW = sht.getCell(6, 2);    //ws.getWritableCell(int column, int row);  // 讀HW                                
             String HW = wcHW.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+HW+"</font></td>");
			  jxl.Cell wcBATB = sht.getCell(6, 3);    //ws.getWritableCell(int column, int row);  // 讀BATB                                
             String BATB = wcBATB.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+BATB+"</font></td>");
			 jxl.Cell wcSW = sht.getCell(8, 2);    //ws.getWritableCell(int column, int row);  // 讀SW                                
             String SW = wcSW.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+SW+"</font></td>");
			  jxl.Cell wcHousing = sht.getCell(8, 3);    //ws.getWritableCell(int column, int row);  // 讀Housing                                
             String Housing = wcHousing.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Housing+"</font></td>");

            /*out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>ITEM</font></td><td><font size='2' color='#FFFFFF'>Name1</font></td><td><font size='2' color='#FFFFFF'>STATUS</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>DESC</font></td><td><font size='2' color='#FFFFFF'>REMARK</font></td></tr>");     */
            
           String PreITEM=""; 
		   String PreName1=""; 

		    int i = 5;			
            
			try {
            while (i<rowCount)  
            {         
              jxl.Cell wcITEM = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀ITEM                                
              String ITEM = wcITEM.getContents();           
             if (ITEM==null || ITEM.equals("")) {ITEM = PreITEM;}  //如果是空值, 則設定同上一筆
		     else {PreITEM = ITEM;}
			 out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+ITEM+"</font></td>");
			  jxl.Cell wcName1 = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀NAME1                                
              String Name1 = wcName1.getContents();              
			  if (Name1==null || Name1.equals("")) {Name1 = PreName1;}  //如果是空值, 則設定同上一筆
		     else {PreName1 = Name1;}
			 out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Name1+"</font></td>");
			   jxl.Cell wcName2 = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀NAME2                                
              String Name2 = wcName2.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Name2+"</font></td>");
			   jxl.Cell wcName3 = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀NAME3                                
              String Name3 = wcName3.getContents();              
               out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+Name3+"</font></td>");
			  //Name1=Name1+"-"+Name2+"-"+Name3; 
			
			  
			  jxl.Cell wcSTATUS = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀STATUS                                
              String STATUS = wcSTATUS.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+STATUS+"</font></td>");
			  
			  jxl.Cell wcDESC = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀DESC                            
              String DESC = wcDESC.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+DESC+"</font></td>");
			  
			  jxl.Cell wcREMARK = sht.getCell(7, i);    //ws.getWritableCell(int column, int row);  // 讀Remark                                
              String REMARK = wcREMARK.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+REMARK+"</font></td>");

				String sqlTC =  "insert into MDCKLIST(ITEM,MODELNO,PHASE,GDATE,QTY,CKHW,CKSW,CKRF,AUDIO,BATTERY,HOUSING,CKNAME1,CKNAME2,CKNAME3,STATUS,CKDESC,CKREMARK,FILENAME,FILECDATE) "+
                                        "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";   			            
                 PreparedStatement seqstmt=dmcon.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
				 seqstmt.setString(1,ITEM); // out.println("Step1.1");
                 seqstmt.setString(2,MODEL);// out.println("Step1.2"); 
				 seqstmt.setString(3,PHASE); //out.println("Step1.4");
				 seqstmt.setString(4,GDATE); //out.println("Step1.5");
				 seqstmt.setString(5,QTY); 
				 seqstmt.setString(6,HW);
				 seqstmt.setString(7,SW); 
				 seqstmt.setString(8,RFTB); 
				 seqstmt.setString(9,ADTB); 
				 seqstmt.setString(10,BATB); 
				 seqstmt.setString(11,Housing); 
				 seqstmt.setString(12,Name1); 
				 seqstmt.setString(13,Name2); 
				 seqstmt.setString(14,Name3); 
				 seqstmt.setString(15,STATUS); 							 
				 seqstmt.setString(16,DESC); 
				 seqstmt.setString(17,REMARK); 
                 seqstmt.setString(18,uploadFile_name);  
				 seqstmt.setString(19,strDateTime);      
                 seqstmt.executeUpdate();
                 seqstmt.close(); 		
		
				 
			  
            i++;  
		  }   // End of While (i<rowCount)
		} // end of try
			catch (Exception e)
			{
				 out.println("Exception:"+e.getMessage());		  
			} 
		
        out.println("</table>"); 
        wb.close(); 
                           
   

%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
