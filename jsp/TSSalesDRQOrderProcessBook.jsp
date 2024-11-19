<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,CodeUtil,WriteLogToFileBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
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
<title>Sales Delivery Request Order Book Page</title>
</head>
<body>
<A HREF="/Oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><BR>
<% 
    
	 String [] choice=request.getParameterValues("CHKFLAG");
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
	 String oraUserID = "";
	 //userID = "3077";  // 因系統每日自動啟動,故使用者設定為 KERWIN
	 String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
	 
	 String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
	 
	 String sqlGlobal=request.getParameter("SQLGLOBAL");;
     String orderNumber=null; 
	 
	 // 先抓訂單產生人員
	 //Statement stateUser=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     //ResultSet rsUser=stateUser.executeQuery("select a.USER_ID from APPS.FND_USE");
	 
     //out.println(sqlGlobal);
	 // 故前提是 (1). 定義在本系統認證檔內(WSUSER) (2). 定義在 Oracle系統內主要使用者檔(FND_USER) (3). 定義在AHR人事主檔內(AHR_EMPLOYEES_ALL) ,且(2).Email_address = (3).Email_address
	 Statement stateUser=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     ResultSet rsUser=stateUser.executeQuery("select a.USER_ID from APPS.FND_USER a, APPS.AHR_EMPLOYEES_ALL b where a.EMAIL_ADDRESS = b.EMAIL_ADDRESS and b.EMPLOYEE_NO = '"+userID+"' ");
     if (rsUser.next())
     { 
	   oraUserID = rsUser.getString("USER_ID");
	 }
	 rsUser.close();
	 stateUser.close();
	 

	            
%>
<%
  try
  { 
         
     int batchCnt = 0; 
     int recordCnt = 1;
  
     //out.println("sqlGlobal ="+sqlGlobal);   
	 writeLogToFileBean.setTextString("<table border='1'>");
	 out.println(writeLogToFileBean.getTextString());  
  
     Statement statement=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     ResultSet rs=statement.executeQuery(sqlGlobal);
     while (rs.next())
     { 
  
       for (int j=0;j<choice.length ;j++)    
       { 
         orderNumber = choice[j]; 
		 //out.println("choice[j]="+choice[j]+"<BR>");    
       }
	   //out.println("choice.length="+choice.length);
	   //out.println("orderNumber="+orderNumber);
	   
	         if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
			   writeLogToFileBean.setTextString("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>("+dateBean.getYearMonthDay()+")成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Order Header ID</strong></font></td><td>Order Number</td><td>Customer Number</td><td>Ship To ID</td><td>Bill To ID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");
			   out.println(writeLogToFileBean.getTextString());
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
	 
	  for (int k=0;k<choice.length ;k++)    
      { 	   
	    //out.println("orderNumber="+orderNumber);
	   
        if (choice[k]==rs.getString("ORDER_NUMBER") || choice[k].equals(rs.getString("ORDER_NUMBER")) ) 
        { 
		 //out.println("orderNumberk="+k+" -- "+choice[k]);
		   
			     //	Step1. 步驟1. 呼叫 Order Import submit request 的Procedure 並取回 Oracle Header ID及Order No	
				 CallableStatement cs3 = con.prepareCall("{call TSC_ORDER_PROCESS_BOOK_SP(?,?,?,?,?,?)}");			 
	             cs3.setString(1,"41");  //*  Org ID 	
				 cs3.setString(2,oraUserID);  //* User ID 	
				 cs3.setString(3,respID);  //*  使用的Responsibility ID --> TSC_OM_Semi_SU	
				 cs3.setString(4,choice[k]);  //*  Order No 				 
	             cs3.registerOutParameter(5, Types.VARCHAR); ///*  訂單處理訊息 	
				 cs3.registerOutParameter(6, Types.INTEGER); ///*  訂單HEADER ID 	
				 //cs3.registerOutParameter(12, Types.DOUBLE);// /*  訂單號碼 				
	                 cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
				 String ErrorMessage = cs3.getString(5);
	             int returnStatus = cs3.getInt(6);
				 //double orderNo = cs3.getDouble(12);				 
                  cs3.close();
	   
	             //out.println("Request ID="+requestID);				 
				 
				 out.println("ErrorMessage="+ErrorMessage);  
				 out.println("returnStatus="+returnStatus); 				 
		      
				 writeLogToFileBean.setTextString("<TR bgcolor='#FFFFCC'><TD><font color='#000099'>"+recordCnt+
                                                  "</font></TD><TD><font color='#CC3366'><strong>"+rs.getString("HEADER_ID")+"</strong></font></TD>"+"<TD>"+choice[k]+"</TD>"+"<TD>"+rs.getString("CUSTOMER")+"</TD>"+"<TD>"+rs.getString("SHIP_TO_ORG_ID")+"</TD>"+"<TD>"+rs.getString("INVOICE_TO_ORG_ID")+"</TD>"+"<TD>"+userID+"</TD>"+"<TD>"+userName+"</TD>"+"<TD>"+strDateTime+"</TD></TR>");
				 out.println(writeLogToFileBean.getTextString());    
				 
		 recordCnt++; // 計算更新筆數		                
					  
	   } // End of if
	  } // End of for (k)  
	 }  // End of While
     statement.close();
	 rs.close();
	 
	 writeLogToFileBean.setTextString("</table>");
	 out.println(writeLogToFileBean.getTextString());
	 
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  }
   
  // 設定存檔路徑並存檔
  writeLogToFileBean.setFileName("D:/resin-2.1.9/webapps/oradds/LogFile/OM/OrderProcessBook"+dateBean.getYearMonthDay()+".html");
  writeLogToFileBean.StrSaveToFile();
  

%>

</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
