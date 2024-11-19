<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,CodeUtil,WriteLogToFileBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--%@ include file="/jsp/include/ConnBPCSDisttstPoolPage.jsp"%-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle AddsOn System Order Import Create Test Page</title>
</head>
<body>
<A HREF="/Oradds/ORAddsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/TestOrderImportCreate.jsp"> 新增訂單測試 </A><BR>
<% 
    
	 
	 String orderType=request.getParameter("ORDERTYPE");
	 String soldToOrg=request.getParameter("SOLDTOORG");
	 String priceList=request.getParameter("PRICELIST");
	 String invItem=request.getParameter("INVITEM");
	 String orderQty=request.getParameter("ORDERQTY");
	 String lineType=request.getParameter("LINETYPE");	 
	
	 String organizationId = request.getParameter("ORGPARID"); // 41 = Semiconductor ,  42 = Printer
	
	 //String userName = userID;
	 //userID = userID.toUpperCase(); // 將系統取得之 User Name 轉為大寫
	 
	 String userName = "OF000886";	// 因系統每日自動啟動,故使用者設定為 KERWIN	 
	 String userID = "3077";  // 因系統每日自動啟動,故使用者設定為 KERWIN
	 String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
	 
	 String sqlGlobal="";
     String sWhere=""; 
	 String sOrder="";
     //out.println(sqlGlobal);

	            
%>
<%
  try
  { 
			     //	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
				 CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_CREATE_SP(?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
	             cs3.setString(1,organizationId);  /*  Org ID */	
				 cs3.setString(2,userID);  /* User ID */	
				 cs3.setString(3,respID);  /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
				 cs3.setInt(4,Integer.parseInt(orderType));  /*  Order Type ID */	
				 cs3.setInt(5,Integer.parseInt(soldToOrg));  /*  SoldToOrg */	
				 cs3.setInt(6,Integer.parseInt(priceList));  /*  PriceList */	
				 cs3.setInt(7,Integer.parseInt(invItem));  /*  InventoryItemID */	
				 cs3.setInt(8,Integer.parseInt(orderQty));  /*  Ordered Quantity */	
				 cs3.setInt(9,Integer.parseInt(lineType));  /*  Ordered Quantity */	
	             cs3.registerOutParameter(10, Types.VARCHAR); /*  訂單處理訊息 */	
				 cs3.registerOutParameter(11, Types.INTEGER); /*  訂單HEADER ID */	
				 //cs3.registerOutParameter(12, Types.DOUBLE); /*  訂單號碼 */	
				 cs3.registerOutParameter(12, Types.VARCHAR); /*  訂單號碼 */	
				 cs3.registerOutParameter(13, Types.VARCHAR); /*  未成功錯誤訊息 */
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
				 String processStatus = cs3.getString(10);
	             int headerID = cs3.getInt(11);
				 //double orderNo = cs3.getDouble(12);
				 String orderNo = cs3.getString(12);
				 String errorMessage = cs3.getString(13);
                 cs3.close();
	 
	             //out.println("Request ID="+requestID);	
				 
				 if (errorMessage==null) { errorMessage = ""; }
					  
					                    
					  
					  //out.println("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                      //"</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  //writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                     // "</font></TD><TD><font color='#CC3366'><strong>"+requestID+"</strong></font></TD>"+"<TD>"+rsGetItem.getString("ORGANIZATION_ID")+"</TD>"+"<TD>"+inventoryItemId+"("+rsGetItem.getString("SEGMENT1")+")"+"</TD>"+"<TD>"+rsGetItem.getString("CATEGORY_ID")+"</TD>"+"<TD>"+categoryId+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
					  out.println("<table>");
					  out.println("<TR bgcolor='#FFFFCC'><TD colspan=2><font color='#000099'>Process Status</FONT></TD><TD colspan=2>"+processStatus+"</TD></TR>");
					  out.println("<TR><TD><font color='#000099'>Header ID</FONT></TD><TD><font color='#000099'>"+headerID+"</FONT></TD><TD><font color='#000099'>Order No</FONT></TD><TD><font color='#000099'>"+orderNo+"</FONT></TD></TR>");
					  out.println("<TR bgcolor='#FFFFCC'><TD colspan=2><font color='#000099'>Error Message</FONT></TD><TD colspan=2>"+errorMessage+"</TD></TR>");
					  out.println("</table>");
			

  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  }
   
  // 設定存檔路徑並存檔
  //writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/TSCInvCategoryFix"+dateBean.getYearMonthDay()+".html");
  //writeLogToFileBean.StrSaveToFile();
  

%>

</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
