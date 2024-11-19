<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Insert UploadFile into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<A HREF='../WinsMainMenu.jsp'>HOME</A><BR>  
<table border="1">


<%
try {
	mySmartUpload.initialize(pageContext); 
	mySmartUpload.upload();
	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
	upload_file.saveAs("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 
	String uploadFile_name=upload_file.getFileName();
	String uploadFilePath="c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName();
	InputStream is = new FileInputStream("c://clientupload/"+request.getRemoteAddr()+"-"+upload_file.getFileName()); 			
	jxl.Workbook wb = Workbook.getWorkbook(is);                
	jxl.Sheet sht = wb.getSheet(0);
	int rowCount = sht.getRows();  // 筆數 
	//out.println("rowCount="+rowCount);

	int x = 2;		
	while (x<10) {         
		
		jxl.Cell wcMODEL = sht.getCell(x, 2);    //ws.getWritableCell(int column, int row);  // 讀model1                                
		String sMODEL = wcMODEL.getContents(); 
		//out.println("<BR>"+x+sMODEL);             
%>
<tr><td>MODEL</td><td colspan=2><%=sMODEL%></td></tr>
<tr><td>DAY</td><td>DATE</td><td>QTY</td></tr>

<%		
		
		int y = 5;			
		
		while (y<rowCount) {         
			jxl.Cell wcDAY = sht.getCell(0, y);    //ws.getWritableCell(int column, int row);  // 讀DAY                                
			String sDAY = wcDAY.getContents();
			//out.println("<BR>"+y+sDAY);           
			
			jxl.Cell wcDATE = sht.getCell(1, y);    //ws.getWritableCell(int column, int row);  // 讀日期        
			String sDATE = wcDATE.getContents();    
			String dt = "";
			//out.println(sDATE);
			int nIdx = sDATE.indexOf("/");
			if ( sDATE!=null && !sDATE.equals("") && nIdx>0) {
			String sYEAR=  sDATE.substring(6); 
			String sMonth= sDATE.substring(3,5); 
			String sDay=  sDATE.substring(0,2); 
			sDATE=sYEAR+"/"+sMonth+"/"+sDay;
			dt=sYEAR+sMonth+sDay;
			}
			else { sDATE = ""; }
			//out.println(sDATE);
		
			jxl.Cell wcQTY = sht.getCell(x, y);    //ws.getWritableCell(int column, int row);  // 讀2052C                                
			String sQTY = wcQTY.getContents(); 
			if (sQTY==null || sQTY.equals("")) { sQTY = "0"; }
			//out.println(sQTY); 
			
			
			if (sMODEL!=null && sQTY!=null && sDAY!=null && sDATE!=null
			 && !sMODEL.equals("") && !sQTY.equals("") && !sDAY.equals("") && !sDATE.equals("")) {
				 if (sDAY.equals("SUN") || sDAY.equals("MON") || sDAY.equals("TUE") || sDAY.equals("WED") || sDAY.equals("THU") || sDAY.equals("FRI") || sDAY.equals("SAT") ) {

%>
<tr>
<tr><td><%=sDAY%></td><td><%=sDATE%></td><td><%=sQTY%></td></tr>
</tr>
<%	
		
					Statement st = dmcon.createStatement();
					ResultSet rs = st.executeQuery("SELECT * FROM MPS WHERE MODEL='"+sMODEL+"' AND M_DATE='"+sDATE+"' ");
					if (rs.next()) {
						PreparedStatement stdel = dmcon.prepareStatement("delete from  MPS WHERE MODEL='"+sMODEL+"' AND M_DATE='"+sDATE+"' "); 
						stdel.executeUpdate();           
						stdel.close();				
					} // end if
					rs.close();
					st.close();
					
					String sSql =  "insert into MPS(MODEL,QTY,M_DAY, M_DATE,FILE_NAME,mdate) "+
							 "values(?,?,?,?,?,?)";   			            
					
					
					PreparedStatement stmt=dmcon.prepareStatement(sSql);    				
					stmt.setString(1,sMODEL);
					stmt.setString(2,sQTY); 
					stmt.setString(3,sDAY);
					stmt.setString(4,sDATE); 
					stmt.setString(5,"");
					stmt.setString(6,dt);            
					stmt.executeUpdate();
					stmt.close(); 
					
					
				} // end if sDay
				
			} // end if null
			
			y++;  
		}   // End of While j
				
			  
		x++;  
	}   // End of While i
		
		
	wb.close(); 
                           
} // end try
catch (Exception e) {  e.printStackTrace();  out.println(e.getMessage());  }
  

%>

</table>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
