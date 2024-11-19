<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="jxl.*" %> 
<%@ page import="java.sql.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.File.*"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<!--=============以下區段為安全認證機制==========-->
 
<%
 //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
 cs1.execute();
 cs1.close();
  
  //String userActCenterNo =null;
  String dateString=null;
  String docNo=request.getParameter("DOCNO"); 
  String targetYear=""; 
  String targetMonth=""; 
  String seqno=null;
  String seqkey=null;
  String customerId=request.getParameter("CUSTOMERID"); 
  //String customerNo=request.getParameter("CUSTOMERNO");
  //String customerName=request.getParameter("CUSTOMERNAME");
  String salesAreaNo=request.getParameter("SALESAREANO"); 
  out.println("salesAreaNo="+salesAreaNo);
  String salesPersonID=request.getParameter("SALESPERSONID"); 
  out.println("salesPersonID="+salesPersonID);
  //String customerPO=request.getParameter("CUSTOMERPO"); 
  String receptDate=request.getParameter("RECEPTDATE");
  out.println("receptDate="+receptDate);
  String curr=request.getParameter("CURR"); 
  String remark=request.getParameter("REMARK"); 
  String requireReason=request.getParameter("REQUIREREASON");
  String preOrderType=request.getParameter("PREORDERTYPE");
  String isModelSelected=request.getParameter("ISMODELSELECTED");  
  String processArea=request.getParameter("PROCESSAREA");
  String salesPerson=request.getParameter("SALESPERSON"); 
  String toPersonID=request.getParameter("TOPERSONID"); 
  String customerIdTmp=request.getParameter("CUSTOMERIDTMP");
  String insertPage=request.getParameter("INSERT"); 
  String preSeqNo=request.getParameter("PREDNDOCNO");
  String repeatInput=request.getParameter("REPEATINPUT");

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


%>

<html>
<head>
<title>EXL Parser Test Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">


</head>
<body>

<FORM  action="TscJapanExlPaserGetArr.jsp" name="form1" method="post" enctype="multipart/form-data">

<%
//get a new document builder
 
  
//load exl
Workbook workbook = Workbook.getWorkbook(new File("C:\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\japan.xls")); 
Sheet sheet = workbook.getSheet(0); 
int  number =  sheet.getRows();
//int  gogofighting =  numdber.getRow() ;
//out.println("number="+number+"<br>");
 
	 // 若單號未取得,則呼叫取號程序
	 try
	 { 
	  if (docNo==null || docNo.equals(""))
	  {  
	   dateString=dateBean.getYearMonthDay();   
	   //seqkey="TS"+userActCenterNo+dateString;  //salesAreaNo
	   if (salesAreaNo==null || salesAreaNo.equals("--")) seqkey="TS"+userActCenterNo+dateString; //但仍以預設為使用者地區
	   else seqkey="TS"+salesAreaNo+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號   
	   //====先取得流水號=====  
	   Statement statement=con.createStatement();
	   ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
	  out.println("seqkey="+seqkey);
	   if (rs.next()==false)
	   {   
		String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";   
		PreparedStatement seqstmt=con.prepareStatement(seqSql);     
		seqstmt.setString(1,seqkey);
		seqstmt.setInt(2,1);   
		
		seqstmt.executeUpdate();
		seqno=seqkey+"-001";
		seqstmt.close();   
	   } 
	   else 
	   {
		int lastno=rs.getInt("LASTNO");
		  
		String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
		ResultSet rs2=statement.executeQuery(sql); 
		//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
		if (rs2.next())
		{         
		  lastno++;
		  String numberString = Integer.toString(lastno);
		  String lastSeqNumber="000"+numberString;
		  lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
		  seqno=seqkey+"-"+lastSeqNumber;     
	   
		  String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
		  PreparedStatement seqstmt=con.prepareStatement(seqSql);        
		  seqstmt.setInt(1,lastno);   
		
		  seqstmt.executeUpdate();   
		  seqstmt.close(); 
		} 
		else
		{
		  //===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
		  String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
		  ResultSet rs3=statement.executeQuery(sSql);
		 
		  if (rs3.next()==true)
		  {
		   int lastno_r=rs3.getInt("LASTNO");
		  
		   lastno_r++;
		  
		   String numberString_r = Integer.toString(lastno_r);
		   String lastSeqNumber_r="000"+numberString_r;
		   lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
		   seqno=seqkey+"-"+lastSeqNumber_r;  
		 
		   String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
		   PreparedStatement seqstmt=con.prepareStatement(seqSql);        
		   seqstmt.setInt(1,lastno_r);   
		   //out.pringln("lastno_r="+lastno_r);
		   seqstmt.executeUpdate();   
		   seqstmt.close();  
		  }  // End of if (rs3.next()==true)
	   
		 } // End of Else  //===========(處理跳號問題)
		} // End of Else    
		docNo = seqno; // 把取到的號碼給本次輸入
	  } // End of if (docNo==null || docNo.equals(""))	
	  else {
	  
		   }	 
	 } //end of try
	 catch (Exception e)
	 {
	  out.println("Exception:"+e.getMessage());
	 }
	
	
	try{
		out.println("<table width='80%' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
			out.println("<tr>"); 
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >LineNumber</font></div></td>"); 
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >FOB</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >CustomerPO</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >PartNumber</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >PackageMethod</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >Quantity</font></div></td>");
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >UnitPrice</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >Inventory_item_id</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >inventory_item</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >Item_Description</font></div></td>");
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >Item_Identifier_Type</font></div></td>");
			out.println("</tr>"); 
		arr = new String[10][number];

		for(int i=1;i<number;i++){
			int  c_lineNumber = i;
			
			Cell c_Fob_Point = sheet.getCell(12,i);
			Cell c_customerPO = sheet.getCell(15,i); 
			Cell c_partNumber = sheet.getCell(16,i);    
			Cell c_packageMethod = sheet.getCell(17,i); 
			Cell c_quantity = sheet.getCell(18,i);    //  1代表row  2 代表column
			Cell c_unitPrice = sheet.getCell(19,i);
			String customerPO = c_customerPO.getContents(); 
			String partNumber = c_partNumber.getContents(); 
			String packageMethod = c_packageMethod.getContents(); 
			String quantity =  c_quantity.getContents(); 
			String unitPrice = c_unitPrice.getContents();
			String fobpoint = c_Fob_Point.getContents();
			String item =  partNumber+" "+packageMethod;
			//out.println("item="+item);
			try{
				String sql_item =	" select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+  
 									" ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v where  "+
  									" ITEM_IDENTIFIER_TYPE = 'INT' and  ITEM_DESCRIPTION = '"+item+"'" ;
 				//out.println(sql_item);
				Statement st = con.createStatement();
				ResultSet rs =  null;
				rs=st.executeQuery(sql_item);
				//i_item	= customerProductNumber;
				while(rs.next()){
					String i_inventory_item_id = rs.getString("INVENTORY_ITEM_ID"); 
					String i_inventory_item	= rs.getString("INVENTORY_ITEM"); 
					//i_item	= customerProductNumber;
					//i_item_ID = rs.getInt("ITEM_ID");
					String i_Item_Description  = rs.getString("ITEM_DESCRIPTION"); 
					String i_Item_Identifier_Type = rs.getString("ITEM_IDENTIFIER_TYPE"); 
					arr[0][i]  =  customerPO; 
					arr[1][i]  =  partNumber; 
					arr[2][i]  =  packageMethod; 
					arr[3][i]  =  quantity; 
					arr[4][i]  =  unitPrice; 
					arr[5][i]  =  fobpoint; 
					arr[6][i]  =  i_inventory_item_id; 
					arr[7][i]  =  i_inventory_item; 
					arr[8][i]  =  i_Item_Description; 
					arr[9][i]  =  i_Item_Identifier_Type; 
					out.println("<tr>"); 
					out.println("<td><font  face='Arial' size= '2' >"+c_lineNumber+"</font></td>"); 
					out.println("<td><font  face='Arial' size= '2' >"+fobpoint+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+customerPO+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+docNo+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+""+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+Float.parseFloat(quantity)/1000+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+unitPrice+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_inventory_item_id+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_inventory_item+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_Item_Description+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_Item_Identifier_Type+"</font></td>");
					out.println("</tr>"); 
					array2DimensionInputBean.setArray2DString(arr);
 
				}
				rs.close();   
				st.close(); 
			}catch (Exception e) { out.println("Exception3:"+e.getMessage()); }


			//arr[6][i]  =  c_lineNumber; 
			 
			 

			//array2DimensionInputBean.setArray2DString(arr);
		}
		 
		out.println("</table>"); 
		
		//out.println("XXX="+arr[0][9]); 
		//out.println("YYY="+arr[6][9]);
	}catch (Exception e) { out.println("Exception1:"+e.getMessage()); } 
	//out.println("<td><font  face='Arial' size= '2' >"+unitPrice+"</font></td>");
	
	
	 

// String  arrgogo[][]=session.setAttribute(arrgogo ,arr);
 
%>
<input type="submit" name="Submit">
</FORM>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
 