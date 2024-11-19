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
<A HREF="/Oradds/ORAddsMainMenu.jsp">回首頁</A>&nbsp;&nbsp;<A HREF="../jsp/TSSalesAreaMapOrderTypeSetActive.jsp"> 設定銷售地區對應訂單類型頁面 </A><BR>
<% 
    
	 String [] choice=request.getParameterValues("CHKFLAG");
	// String orderType=request.getParameter("ORDERTYPE");
	// String soldToOrg=request.getParameter("SOLDTOORG");
	// String priceList=request.getParameter("PRICELIST");
	// String invItem=request.getParameter("INVITEM");
	// String orderQty=request.getParameter("ORDERQTY");
	// String lineType=request.getParameter("LINETYPE");	 
	
	// String organizationId = request.getParameter("ORGPARID"); // 41 = Semiconductor ,  42 = Printer
	
	 //String userName = userID;
	 //userID = userID.toUpperCase(); // 將系統取得之 User Name 轉為大寫
	 
		 
	 String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取文件新增日期時間 //
	 
	 String sqlGlobal=request.getParameter("SQLGLOBAL");;
     String salesArea=null; 
	 
     //out.println(sqlGlobal);

	            
%>
<%
  try
  { 
         
     int batchCnt = 0; 
     int recordCnt = 1;
  
     //out.println("sqlGlobal ="+sqlGlobal);   
	  
     Statement statement=con.createStatement();
     //out.println("sqlGlobal="+sqlGlobal);
     ResultSet rs=statement.executeQuery(sqlGlobal);
     while (rs.next())
     { 
  
       for (int j=0;j<choice.length ;j++)    
       { 
         salesArea = choice[j]; 
		 //out.println("choice[j]="+choice[j]+"<BR>");    
       }
	   //out.println("choice.length="+choice.length);
	   //out.println("orderNumber="+orderNumber);
	   
	         if (batchCnt==0) // 取成功入帳BPCS 批號,當第一筆成功寫入出現時
             { 
               //out.println("<tr bgcolor='#FFFFCC'><td colspan='9' bgcolor='#000099'><font color='#FFFFFF'>成功項次清單</font></td></tr><tr bgcolor='#FFFFCC'><td>&nbsp;</td><td><font color='#CC3366'><strong>Oracle Request ID</strong></font></td><td>Org.ID</td><td>Item.ID</td><td>Error CategoryID</td><td>Correct CategoryID</td><td>UserID</td><td>UserName</td><td>LastUpdateTime</td></tr>");   
			   
               // 取成功帳入 BPCS 時所需的 流水號
               batchCnt++;   // 取成功入帳BPCS 批號,當第一筆成功寫入出現時 
             } // end of if (batchCnt =0 ) 取成功入帳BPCS 批號,當第一筆成功寫入出現時	
	 
	  for (int k=0;k<choice.length ;k++)    
      { 	   
	    //out.println("choice[k]="+choice[k]);
	   
        if (choice[k].trim()==rs.getString("OKEY").trim() || choice[k].equals(rs.getString("OKEY")) ) 
        { 
		 //out.println("orderNumberk= "+k+" -- "+choice[k]);
		 
		  if (rs.getString("ACTIVE")=="Y" || rs.getString("ACTIVE").equals("Y"))
		  {
		      String sql="update ORADDMAN.TSAREA_ORDERCLS set ACTIVE=? "+
	              "where SAREA_NO='"+choice[k].substring(0,3)+"' and ORDER_NUM = '"+rs.getString("ORDER_NUM")+"' ";     
              PreparedStatement pstmt=con.prepareStatement(sql);
              pstmt.setString(1,"N");                    
              pstmt.executeUpdate(); 
              pstmt.close();  
			  
			  //out.println("sql1="+sql);
		  } else {
		  
		          String sql="update ORADDMAN.TSAREA_ORDERCLS set ACTIVE=? "+
	              "where SAREA_NO='"+choice[k].substring(0,3)+"' and ORDER_NUM = '"+rs.getString("ORDER_NUM")+"' ";     
                  PreparedStatement pstmt=con.prepareStatement(sql);
                  pstmt.setString(1,"Y");                    
                  pstmt.executeUpdate(); 
                  pstmt.close();  
		           // out.println("sql2="+sql);
		         }		     
				   
				 
		 recordCnt++; // 計算更新筆數		                
					  
	   } // End of if
	  } // End of for (k)  
	 }  // End of While
     statement.close();
	 rs.close();
	 
		 
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());		  
  }
   
  // 設定存檔路徑並存檔
%>

</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSDisttstPage.jsp"%-->
<!--%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<% //response.sendRedirect("/oradds/jsp/TSSalesAreaMapOrderTypeSetActive.jsp"); %>
</html>
