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
				myFile.saveAs("/jsp/upload_exl/"+fileName);
				session.setAttribute("pic",fileName);
			}
		}
	}
		//response.sendRedirect("TscJapanExlRfqUpload.jsp");
%>
<!--=============以下區段為安全認證機制==========-->
<%

 CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
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
  //out.println("userActCenterNo="+userActCenterNo+"<br>");

  String customerPO_Easy ="";
  
  //String customerNo=request.getParameter("CUSTOMERNO");
  //String customerName=request.getParameter("CUSTOMERNAME");
  String salesAreaNo="003"; 
  
  String salesPersonID=request.getParameter("SALESPERSONID"); 
  //out.println("salesPersonID="+salesPersonID);
  //String customerPO=request.getParameter("CUSTOMERPO"); 
  String receptDate=request.getParameter("RECEPTDATE");
  //out.println("receptDate="+receptDate);
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
  
  String itemFactory = "";
  String uom =  "";
  String priceCategory  ="";
 

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
<title>EXL Parser Test Page</title>
<STRI>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>

<FORM  action="TscJapanExlPaserGetArr.jsp" method="post"   name="form1"  >
 <%@ include file="TscJapanHead.jsp"%>
<input name="Submit" type="submit"   value="產生詢問單" >

<%

//get a new document builder
 
  
//load exl
Workbook workbook = Workbook.getWorkbook(new File("\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+fileName)); 
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
	   //out.println("seqkey="+seqkey);
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
		   out.println("<tr><tr>");
		   out.println("<TD>詢問單號="+seqno+"</TD><BR>");
		   out.println("<TD>台半工號="+userID+"</TD><BR>");
  		   out.println("<TD>業務區碼="+salesAreaNo+"</TD><BR>");
		   out.println("</tr></tr><br>");
		   
		   
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
		out.println("<table width='90%' border='0'><tr><table width='100%' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
			out.println("<tr>"); 
			out.println("<td width='3'><div align='center'><font  face='Arial' size= '2' >項次</font></div></td>"); 
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >F.O.B</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >CustomerPO</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >數量</font></div></td>");
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >價格</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >型號ID</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >型號內碼</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >型號</font></div></td>");
			out.println("<td width='200'><div align='center'><font  face='Arial' size= '2' >LINE說明</font></div></td>");
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >客戶</font></div></td>");
			
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >生產工廠</font></div></td>");
			out.println("<td width='20'><div align='center'><font  face='Arial' size= '2' >最小單位</font></div></td>");
		 
			out.println("<td width='10'><div align='center'><font  face='Arial' size= '2' >名目價格</font></div></td>");
			out.println("</tr>"); 
			out.println("1");
		arr = new String[15][number];
			out.println("1");
			Cell c_customerPO_Easy = sheet.getCell(15,1); 
			out.println("1");
			String  p_customerPO_Easy = c_customerPO_Easy.getContents(); 
			
			int a_begin =  p_customerPO_Easy.indexOf("/");
			out.println("1");
			int b_end =  p_customerPO_Easy.length(); 
			out.println("2");
			customerPO_Easy = p_customerPO_Easy.substring(0,a_begin);   		// 表示字串中","之前的字串也就是 CUSTOMER PO
			out.println("customerPO_Easy="+customerPO_Easy);
			//String word = customerPO.substring(a_begin+1,b_end);	
			//out.println("customerPO_Easy="+customerPO_Easy);
			out.println("1");

		for(int i=1;i<number;i++){
			int  c_lineNumber = i;
			Cell c_OrderFrom = sheet.getCell(8,i);
			Cell c_Fob_Point = sheet.getCell(12,i);
			Cell c_customerPO = sheet.getCell(15,i); 
			Cell c_partNumber = sheet.getCell(16,i);    
			Cell c_packageMethod = sheet.getCell(17,i); 
			Cell c_quantity = sheet.getCell(18,i);    //  1代表row  2 代表column
			Cell c_unitPrice = sheet.getCell(19,i);
			Cell c_EndCustomer = sheet.getCell(25,i);
			Cell c_RequestDate = sheet.getCell(21,i);
			String orderFrom = c_OrderFrom.getContents();
			out.println("1");
			String customerPO = c_customerPO.getContents(); 
			out.println("1");
			String partNumber = c_partNumber.getContents(); 
			out.println("1");
			String packageMethod = c_packageMethod.getContents();
			out.println("1"); 
			String quantity =  c_quantity.getContents(); 
			out.println("1");
			String unitPrice = c_unitPrice.getContents();
			out.println("1");
			String fobpoint = c_Fob_Point.getContents();
			String endCustomer = c_EndCustomer.getContents();
			String requestDate = c_RequestDate.getContents();
			String yyyymmdd = (requestDate.replaceAll("/","")).substring(4,8)+(requestDate.replaceAll("/","")).substring(2,4)+(requestDate.replaceAll("/","")).substring(0,2);
			
			//out.println(customerPO.);
			if(endCustomer=="NA" || endCustomer.equals("NA")){
				endCustomer="";
			}
			String item =  partNumber+" "+packageMethod;
			String po_Header = customerPO+"("+orderFrom+")/"+endCustomer;
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
					
					
				 
					Statement st2=con.createStatement();
					ResultSet rs_item=null;	
					String sql_item2 = "select a.INVENTORY_ITEM_ID, a.PRIMARY_UOM_CODE, NVL(a.ATTRIBUTE3,'N/A') ATTRIBUTE3, b.SEGMENT1  "+
									  "from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b "+
									  "where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
									  "and a.ORGANIZATION_ID = '49' and b.CATEGORY_SET_ID = 6 and a.SEGMENT1 = '"+i_inventory_item+"' ";						  								 			  
					rs_item =st2.executeQuery(sql_item2);
					if (rs_item.next()){
						itemFactory = rs_item.getString("ATTRIBUTE3");
						uom =  rs_item.getString("PRIMARY_UOM_CODE");
						priceCategory = rs_item.getString("SEGMENT1");		
					 }	else { itemFactory="N/A"; uom="N/A"; priceCategory = ""; }		
					  //out.println(sql);    
					  rs_item.close();   
					  st2.close(); 	
					  
					  String listPrice = "";
					  Statement stateListPrice=con.createStatement();
					  String sqlLPrice = "select OPERAND from ORADDMAN.TSITEM_LIST_PRICE where LIST_HEADER_ID =  '6038' and PRODUCT_ATTR_VAL_DISP = '"+priceCategory+"' ";
					  ResultSet rsLPrice=stateListPrice.executeQuery(sqlLPrice); 
					  if (rsLPrice.next())
					  {
						 listPrice = rsLPrice.getString("OPERAND");  
					  }
					  rsLPrice.close();
					  stateListPrice.close(); 

					arr[0][i]  =  customerPO; 
					//arr[1][i]  =  partNumber; 
					//arr[2][i]  =  packageMethod; 
					arr[1][i]  =  quantity; 
					arr[2][i]  =  unitPrice; 
					arr[3][i]  =  fobpoint; 
					arr[4][i]  =  i_inventory_item_id; 
					arr[5][i]  =  i_inventory_item; 
					arr[6][i]  =  i_Item_Description; 
					arr[7][i]  =  i_Item_Identifier_Type; 
					arr[8][i]  =  orderFrom; 
					arr[9][i]  =  endCustomer;
					arr[10][i] =  yyyymmdd;
					
					arr[11][i] = itemFactory;
					arr[12][i] = uom;
					arr[13][i] = priceCategory;
					arr[14][i] = listPrice;
			 
					
					
					
					out.println("<tr>"); 
					out.println("<td><font  face='Arial' size= '2' >"+c_lineNumber+"</font></td>"); 
					out.println("<td><font  face='Arial' size= '2' >"+fobpoint+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+customerPO+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+Float.parseFloat(quantity)/1000+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+unitPrice+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_inventory_item_id+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_inventory_item+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+i_Item_Description+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+po_Header+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+endCustomer+"</font></td>");
					
					out.println("<td><font  face='Arial' size= '2' >"+itemFactory+"</font></td>");
					out.println("<td><font  face='Arial' size= '2' >"+uom+"</font></td>");
					 
					out.println("<td><font  face='Arial' size= '2' >"+listPrice+"</font></td>");
					out.println("</tr>"); 
					array2DimensionInputBean.setArray2DString(arr);
				}
				rs.close();   
				st.close(); 
			}catch (Exception e) { out.println("Exception3:"+e.getMessage()); }
			//arr[6][i]  =  c_lineNumber; 
			//array2DimensionInputBean.setArray2DString(arr);
		}
		 
		out.println("</table></tr></table>"); 
		
		//out.println("XXX="+arr[0][9]); 
		//out.println("YYY="+arr[6][9]);
	}catch (Exception e) { out.println("Exception1:"+e.getMessage()); } 
	//out.println("<td><font  face='Arial' size= '2' >"+unitPrice+"</font></td>");
	
	
	 

// String  arrgogo[][]=session.setAttribute(arrgogo ,arr);

%>
<input type="hidden" name="seqno" value="<%=seqno%>">
<input type="hidden" name="customerPO_Easy" value="<%=customerPO_Easy%>">
<BR>
<BR>

</FORM>
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
 
