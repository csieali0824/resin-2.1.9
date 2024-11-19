<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,java.lang.Math.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="java.io.*,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>

<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>  
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
		                           "from qcissuelist  "; 
		        String sWhere="where  FILENAME='"+uploadFile_name+"'"; 
		        
	            sSql=sSql+sWhere; 
	            //out.println(sSql);      					 
	            ResultSet rs=statement.executeQuery(sSql);
		        if(rs.next())
			    {
				String sqld="delete from  qcissuelist where  FILENAME='"+uploadFile_name+"'";   
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
			jxl.Sheet sht = wb.getSheet("追蹤 List");      
            int rowCount = sht.getRows();  // 取此次筆數 
            //out.println("rowCount="+rowCount);
            out.println("<table width='100%' border='0' cellspacing='1' cellpadding='1'><tr bgcolor='#000099'><td><font size='2' color='#FFFFFF'>序號</font></td><td><font size='2' color='#FFFFFF'>日期</font></td><td><font size='2' color='#FFFFFF'>地區</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>MODEL</font></td><td><font size='2' color='#FFFFFF'>問題敘述</font></td><td><font size='2' color='#FFFFFF'>手機S/W</font></td><td><font size='2' color='#FFFFFF'>系統</font></td><td><font size='2' color='#FFFFFF'>不良原因分析</font></td><td><font size='2' color='#FFFFFF'>PIC</font></td>"+
                         "<td><font size='2' color='#FFFFFF'>改善對策</font></td><td><font size='2' color='#FFFFFF'>DUE DATE</font></td><td><font size='2' color='#FFFFFF'>STATU</font></td></tr>");     
            int i = 1;			
            int lastBase = 0;   
			
            while (i<rowCount)  
            {         
              jxl.Cell wcSEQNO = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀序號                                
              String SEQNO = wcSEQNO.getContents();              
              out.print("<tr bgcolor='#FFFFCC'><td><font size='2'>"+SEQNO+"</font></td>");
        
              jxl.Cell wcGDATE = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀日期        
			  String GDATE = wcGDATE.getContents();              
              out.print("<td><font size='2'>"+GDATE+"</font></td>");                       
              
              jxl.Cell wcAREA = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀地區                                
              String AREA = wcAREA.getContents();  
              //out.println("RECDATE="+RECDATE+" "); 
              out.print("<td><font size='2'>"+AREA+"</font></td>");    
			  
    		  jxl.Cell wcMODELNO = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀MODEL                             
              String MODELNO = wcMODELNO.getContents();  
              //out.println("FINDATE="+FINDATE+" ");
              out.print("<td><font size='2'>"+MODELNO+"</font></td>");   			  
			
			  
			   jxl.Cell wcPROBDESC = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀問題陳述                          
              String PROBDESC = wcPROBDESC.getContents();  
              //out.println("BRAND="+BRAND+" ");
              out.print("<td><font size='2'>"+PROBDESC+"</font></td>");
   
              jxl.Cell wcCELLSOFT = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀PIC                                
              String CELLSOFT = wcCELLSOFT.getContents();  
              //out.println("MODEL="+MODEL+" "); 
              out.print("<td><font size='2'>"+CELLSOFT+"</font></td>");
			  
			  jxl.Cell wcSYSTEM = sht.getCell(6, i);    //ws.getWritableCell(int column, int row);  // 讀系統                             
              String SYSTEM = wcSYSTEM.getContents();  
              //out.println("FINDATE="+FINDATE+" ");
              out.print("<td><font size='2'>"+SYSTEM+"</font></td>");   

              jxl.Cell wcDEFECTANALY = sht.getCell(7, i);    //ws.getWritableCell(int column, int row);  // 讀不良原因分析                                
              String DEFECTANALY = wcDEFECTANALY.getContents();  
              //out.println("BRAND="+BRAND+" ");
              out.print("<td><font size='2'>"+DEFECTANALY+"</font></td>");
   
              jxl.Cell wcPIC = sht.getCell(8, i);    //ws.getWritableCell(int column, int row);  // 讀PIC                                
              String PIC = wcPIC.getContents();  
              //out.println("MODEL="+MODEL+" "); 
              out.print("<td><font size='2'>"+PIC+"</font></td>");

              jxl.Cell wcIMPPLAN = sht.getCell(9, i);    //ws.getWritableCell(int column, int row);  // 讀改良對策                               
              String IMPPLAN = wcIMPPLAN.getContents();  
              //out.println("IMEI="+IMEI+" ");
              out.print("<td><font size='2'>"+IMPPLAN+"</font></td>");      
  
              jxl.Cell wcDUEDATE = sht.getCell(10, i);    //ws.getWritableCell(int column, int row);  // 讀DUE DATE                                
              String DUEDATE = wcDUEDATE.getContents();  
              //out.println("WARRTYPE="+WARRTYPE+" ");
              out.print("<td><font size='2'>"+DUEDATE+"</font></td>"); 
    
              jxl.Cell wcSTATUS = sht.getCell(11, i);    //ws.getWritableCell(int column, int row);  // 讀STATUS                                
              String STATUS = wcSTATUS.getContents();  
              //out.println("RTNFLAG="+RTNFLAG+" "); 
              out.print("<td><font size='2'>"+STATUS+"</font></td>");   
			 
		     //out.println(SEQNO); 
             if(SEQNO!="" && SEQNO!=null && !SEQNO.equals("")) 
				 {String sqlTC =  "insert into DMADMIN.QCIssueList(SEQNO,GDATE,AREA,MODELNO,PROBDESC,CELLSOFT,SYSTEM,DEFECTANALY,PIC,IMPPLAN,DUEDATE,STATUS,FILENAME,CREATEUSER) "+
                                 "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";   			            
                 PreparedStatement seqstmt=dmcon.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
				 seqstmt.setString(1,SEQNO); //out.println("Step1.2");
                 seqstmt.setString(2,GDATE);  // out.println("Step1.3");             
                 seqstmt.setString(3,AREA);
				 seqstmt.setString(4,MODELNO); // out.println("Step1.4");
                 seqstmt.setString(5,PROBDESC); // out.println("Step1.4");
                 seqstmt.setString(6,CELLSOFT);// out.println("Step1.5");
                 seqstmt.setString(7,SYSTEM); //out.println("Step1.6");
                 seqstmt.setString(8,DEFECTANALY);  // out.println("Step1.7");
                 seqstmt.setString(9,PIC);
                 seqstmt.setString(10,IMPPLAN); // out.println("Step1.8"); 
                 seqstmt.setString(11,DUEDATE); //out.println("Step1.6");
                 seqstmt.setString(12,STATUS);  // out.println("Step1.7");
                 seqstmt.setString(13,uploadFile_name);                
				 seqstmt.setString(14,userID); // out.println("Step1.8");       
            
                     
                 seqstmt.executeUpdate();
                 //seqno=seqkey+"-001";
                 seqstmt.close(); 
				 
		     }//end of if(serial!="")
			  
           i++;  
		}   // End of While (i<rowCount)
		
		
        out.println("</table>"); 
        wb.close(); 
                           
   

%>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
