<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,CodeUtil,WriteLogToFileBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!--%@ include file="/jsp/include/ConnBPCSDisttstPoolPage.jsp"%-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Oracle AddsOn System Order Import Create Test Page</title>
</head>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>   
<% 
     String dnDocNo=request.getParameter("DNDOCNO");
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
%>
<A HREF="../jsp/TSRFQRegenerateDocumentSetActive.jsp?DNDOCNO=<%=dnDocNo%>">回銷售企劃人員核准訂單生成頁面</A><BR>

  <%
     //out.println(sqlGlobal);
  //<A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
  //<A HREF="../jsp/TSRFQRegenerateDocumentSetActive.jsp"> <jsp:getProperty name="rPH" property="pgSalesPlanner"/><jsp:getProperty name="rPH" property="pgSalesPlanner"/><jsp:getProperty name="rPH" property="pgApproval"/><jsp:getProperty name="rPH" property="pgOrdCreate"/></A>
  try
  { 
         
     int batchCnt = 0; 
     int recordCnt = 0;
  
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
 		     recordCnt++; // 計算更新筆數		                
	 
		  //if (rs.getString("ACTIVE")=="Y" || rs.getString("ACTIVE").equals("Y"))
		  //{
		      String sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set SDRQ_EXCEED=?,LSTATUSID='009',LSTATUS='GENERATING' "+
	                     " where DNDOCNO='"+choice[k].substring(0,17)+"' and LINE_NO='"+choice[k].substring(17,choice[k].length())+"' ";     
              PreparedStatement pstmt=con.prepareStatement(sql);
              pstmt.setString(1,"N");                    
              pstmt.executeUpdate(); 
              pstmt.close();  
			  
			//  out.println("sql1="+sql);
		  //} 
		  /*else {
		  
		          String sql="update ORADDMAN.TSAREA_ORDERCLS set ACTIVE=? "+
	              "where SAREA_NO='"+choice[k].substring(0,3)+"' and ORDER_NUM = '"+rs.getString("ORDER_NUM")+"' ";     
                  PreparedStatement pstmt=con.prepareStatement(sql);
                  pstmt.setString(1,"Y");                    
                  pstmt.executeUpdate(); 
                  pstmt.close();  
		           // out.println("sql2="+sql);
		         }		     
				   */

////20090702
		 // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      float processWorkTime = 0;
		      String preWorkTime = "0"; 			 
		      Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' (工廠批退交期安排中送出前一狀態為ESTIMATING(003))
              ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choice[k].substring(0,17)+"' and TO_CHAR(LINE_NO)='"+choice[k].substring(17,choice[k].length())+"' and ORISTATUSID ='004' ");
	          if (rsHProcWT.next())
		      {
			     preWorkTime = rsHProcWT.getString(1);
			  }
			  rsHProcWT.close();
			  stateHProcWT.close();
           //若取到前一個狀態時間,則以目前時間減去前
		    if (preWorkTime!="0")
		    {
			    String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
				//out.println("sqlWT="+sqlWT);
		        Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            if (rsWTime.next())
		        {
			     processWorkTime = rsWTime.getFloat(1);
			    }
			    rsWTime.close();
			    stateWTime.close();
			}

          // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_迄

	  
		      //Step5. 任一Action,寫入交期詢問明細歷程檔	         	 
              //out.println("先取該項次目前資料筆數"); 	 
	          int deliveryCount = 0;
	          Statement stateDeliveryCNT=con.createStatement();
              //  out.print("deliveryCount="+select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choice[k].substring(0,17)+"' and TO_CHAR(LINE_NO)='"+choice[k].substring(17,choice[k].length())); 
              ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choice[k].substring(0,17)+"' and TO_CHAR(LINE_NO)='"+choice[k].substring(17,choice[k].length())+"' ");
	          if (rsDeliveryCNT.next())
	          {
	            deliveryCount = rsDeliveryCNT.getInt(1);

	          }
	          rsDeliveryCNT.close();
	          stateDeliveryCNT.close();
	
	          String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,CDATETIME,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?) ";
	          PreparedStatement historystmt=con.prepareStatement(historySql);   
              historystmt.setString(1,choice[k].substring(0,17)); 
              historystmt.setString(2,"008"); 
              historystmt.setString(3,"CONFIRMED"); //寫入status名稱
              historystmt.setString(4,"011"); 
              historystmt.setString(5,"APPLY"); 
              historystmt.setString(6,userID); 
              historystmt.setString(7,dateBean.getYearMonthDay()); 
              historystmt.setString(8,dateBean.getHourMinuteSecond());
            //  historystmt.setString(9,prodCodeGet); //寫入工廠編號
              historystmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
            //  historystmt.setString(11,remark);
              historystmt.setInt(10,deliveryCount);
		      historystmt.setInt(11,Integer.parseInt(choice[k].substring(17,choice[k].length()))); // 寫入處理Line_No
		      historystmt.setFloat(12,processWorkTime);		
			//  historystmt.setString(15,aFactoryArrangedCode[i][6]);
		      historystmt.executeUpdate();   
              historystmt.close(); 
	         //Step5. 寫入交期詢問明細歷程檔
             //===ENF OF 寫入action history

///20090702

		 out.println("RFQ Number= "+choice[k].substring(0,17)+" Line "+choice[k].substring(17,choice[k].length())+" unLock success");
		 out.println("<BR>");
	   } // End of if
	  } // End of for (k)  
	 }  // End of While
     statement.close();
	 rs.close();
    out.println("<BR>"); 
	out.println("Unlock Success record count ="+recordCnt);
		 
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
