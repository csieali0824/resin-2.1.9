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
upload_file.saveAs("c://temp/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
String uploadFile_name=upload_file.getFileName();
String uploadFilePath="c://temp/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
//out.println("Step2");

   /*
            try
	         {  
			    //define connection 
				String url="jdbc:oracle:thin:@10.0.1.7:1522:dev";
			    Connection dmcon=DriverManager.getConnection(url,"oraddman","oraddman");   
				Statement statement=dmcon.createStatement();
				//Statement statement=con.createStatement();
			    String sSql="select FILENAME "+" "+
		                           "from ittest_excel"; 
		        String sWhere="where  FILENAME='"+uploadFile_name+"'"; 
		        
	            sSql=sSql+sWhere; 
	            //out.println(sSql);      					 
	            ResultSet rs=statement.executeQuery(sSql);
		        if(rs.next())
			    {
				String sqld="delete from  ittest_excel where  FILENAME='"+uploadFile_name+"'";   
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
*/				

             String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
             String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
			 

      
            /*  For Excel View  */         
            // 取得上傳Excel報表
	        InputStream is = new FileInputStream("c://temp/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 			
			
            jxl.Workbook wb = Workbook.getWorkbook(is);                
            //jxl.Sheet sht = wb.getSheet(0);
			
			jxl.Sheet sht = wb.getSheet("info");      
            int rowCount = sht.getRows();  // 取此次筆數 
            //out.println("rowCount="+rowCount);
			 jxl.Cell wcName = sht.getCell(0,0);    //ws.getWritableCell(int column, int row);  // 讀name                              
             String name = wcName.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+name+"</font></td>");
			  jxl.Cell wcNo = sht.getCell(1, 0);    //ws.getWritableCell(int column, int row);  // 讀階段                                
             String no = wcNo.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+no+"</font></td>");
			  jxl.Cell wcCDate = sht.getCell(2, 0);    //ws.getWritableCell(int column, int row);  // 讀產出日期                               
             String cDate = wcCDate.getContents(); 
			   out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+cDate+"</font></td>");
			  jxl.Cell wcCBy = sht.getCell(3, 0);    //ws.getWritableCell(int column, int row);  // 讀RF                                
             String createBy = wcCBy.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+createBy+"</font></td>");
			  jxl.Cell wcUpDate = sht.getCell(4,0);    //ws.getWritableCell(int column, int row);  // 讀數量                         
             String upDate = wcUpDate.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+upDate+"</font></td>");
			  jxl.Cell wcUpBy = sht.getCell(5, 0);    //ws.getWritableCell(int column, int row);  // 讀ADTB                                
             String upBy = wcUpBy.getContents();              
             out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+upBy+"</font></td>");
			

            /*out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>ITEM</font></td><td><font size='2' color='#FFFFFF'>Name1</font></td><td><font size='2' color='#FFFFFF'>STATUS</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>DESC</font></td><td><font size='2' color='#FFFFFF'>REMARK</font></td></tr>");     */
            
       

		    int i = 1;			
            
			try {
            while (i<rowCount)  
            {         
              jxl.Cell wcDName = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀ITEM                                
              String dName = wcDName.getContents();           
             if (dName==null || dName.equals(""))  dName ="N/A";  //如果是空值, 則設定同上一筆
		     //else {PreITEM = dName;}
			 out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dName+"</font></td>");
			 
			  jxl.Cell wcDNo = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀NAME1                                
              String dNo = wcDNo.getContents();              
			  if (dNo==null || dNo.equals("")) {dNo ="000";}  //如果是空值, 則設定同上一筆		    
			 out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dNo+"</font></td>");
			 
			   jxl.Cell wcDCDate = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀NAME2                                
              String dCDate = wcDCDate.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dCDate+"</font></td>");
			  
			   jxl.Cell wcDCby = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀NAME3                                
              String dCBy = wcDCby.getContents();              
               out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dCBy+"</font></td>");
			  //Name1=Name1+"-"+Name2+"-"+Name3; 			
			  
			  jxl.Cell wcDUpDate = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀STATUS                                
              String dUpDate = wcDUpDate.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dUpDate+"</font></td>");
			  
			  jxl.Cell wcDUpBy = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀DESC                            
              String dUpBy = wcDUpBy.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+dUpBy+"</font></td>");
			  
			 

				String sqlTC =  "insert into ORADDMAN.ittest_excel(MC_USERID,MC_EMPID,CREATION_DATE,CREATED_BY,LAST_UPDATE_DATE,LAST_UPDATED_BY) "+
                                        "values(?,?,?,?,?,?)";   			            
                 PreparedStatement seqstmt=con.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
				 seqstmt.setString(1,dName); // out.println("Step1.1");
                 seqstmt.setString(2,dNo);// out.println("Step1.2"); 
				 seqstmt.setString(3,dCDate); //out.println("Step1.4");
				 seqstmt.setString(4,dCBy); //out.println("Step1.5");
				 seqstmt.setString(5,dUpDate); 
				 seqstmt.setString(6,dUpBy);				    
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
