<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*" %>
<jsp:useBean id="myUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="jxl.*" %> 
<%@ page import="java.lang.*" %>
<%@ page import="java.io.File.*"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%

	String fileName = request.getParameter("fileName"); 
	
	String errorMessage = null;
	if(fileName==null ){
		myUpload.initialize(pageContext);
		myUpload.upload();
	
		if(myUpload.getFiles().getCount()>0){
			com.jspsmart.upload.File myFile = myUpload.getFiles().getFile(0);
			if (!myFile.isMissing()){
				fileName = myFile.getFileName();
				myFile.saveAs("/jsp/TSCT-Disty2/"+fileName);
				session.setAttribute("pic",fileName);
			}
		}
	}
		//response.sendRedirect("TscJapanExlRfqUpload.jsp");
%>
<!--=============以下區段為安全認證機制==========-->
<%

 //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
 cs1.execute();
 cs1.close();
  
 
 

/* XML 抓取 JSP 程式 編號  TU-001 */

java.util.Date datetime = new java.util.Date();
SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd");
SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy/MM/dd HH:mm:ss");
String RevisedTime = (String) formatter.format( datetime );         //2003/01/01
String RevisedTimes = (String) formatter1.format( datetime );         //2003/01/01

//String arr[6][i];
//String a[][]=array2DimensionInputBean.getArray2DContent();
  
String  arr[][];
//String userActCenterNo = "aaa";
//out.println("kk="+dateBean.getYearMonthDay());

%>

<html>
<head>
<title> </title>
<STRI>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>

<FORM  action="" method="post"   name="form1"  >
 

<%

//get a new document builder
 
  
//load exl
		Workbook workbook = Workbook.getWorkbook(new File("\\resin-2.1.9\\webapps\\oradds\\jsp\\TSCT-Disty2\\"+fileName)); 
		Sheet sheet = workbook.getSheet(0); 
		int  number =  sheet.getRows();
		Cell cellcustomername = null;
		Cell cellcustomerpo = null;
		Cell cellineNumber = null;
		Cell cellitem = null;
		Cell cellquantity = null;
		Cell cellprice = null;
		Cell cellendcustomer = null;
		Cell cellcurrency = null;
		
          int itemCNTtotal = 0;
		  int itemCNTsub[] = new int[number];

		cellcustomername = sheet.getCell(1,0);  
		String customername = cellcustomername.getContents();
		out.println("customername="+customername+"<br>");
		customername=customername.substring(0,6); 
		//out.println("customername1="+customername+"<br>");
		
		
		if(customername=="BRIGHT" || customername.equals("BRIGHT")){
			//out.println("BRIGHT");
			String shipToID = "10010";
			String billToID = "1181";
			String customerNumber ="1038";
			String CustomerID = "1081";
 

		}else if(customername=="GLOBAL" || customername.equals("GLOBAL")){
			//out.println("GLOBAL");
			//out.println("BRIGHT");
			String shipToID = "10012";
			String billToID = "1564";
			String customerNumber ="1117";
			String CustomerID = "1242";
			
		}else{
			out.println("FUCKING WRONG CUSTOMER");
		}
		
		
		

		cellcustomerpo = sheet.getCell(1,1);  
		String customerpo = cellcustomerpo.getContents();
		out.println("customerpo="+customerpo+"<br>");
		
		cellcurrency = sheet.getCell(1,4);  
		String currency = cellcurrency.getContents();
		out.println("currency="+currency+"<br>");
		
		
		
		
		
		
		


          for ( int itemno=6 ; itemno < number ; itemno++)
          {
		  	
		  
		  	cellineNumber   = sheet.getCell(0,itemno);  
			String lineNumber =   cellineNumber.getContents();
			if(lineNumber==null || lineNumber.equals("")){
			}else{
				out.println("lineNumber="+lineNumber);
				cellitem = sheet.getCell(2,itemno); 
				String item =   cellitem.getContents();
				try{
					 Statement st2=con.createStatement();
                     ResultSet rs2=null;
			         String sql2 = "select DISTINCT created_By , created_By from TSC_OE_AUTO_HEADERS ";   //要傳兩個變數
                     rs2=st2.executeQuery(sql2);
 
				
				}catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
				 
				 
				 
				 
				 
				 
				 
				 
				cellquantity = sheet.getCell(3,itemno); 
				String quantity =   cellquantity.getContents();
				out.println("quantity="+quantity);
				cellprice = sheet.getCell(4,itemno); 
				String price =   cellprice.getContents();
				out.println("price="+price );
				cellendcustomer = sheet.getCell(7,itemno); 
				String endcustomer =   cellendcustomer.getContents();
				out.println("endcustomer="+endcustomer+"<br>");
 			}
           }
%>
 
			
</FORM>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
 
