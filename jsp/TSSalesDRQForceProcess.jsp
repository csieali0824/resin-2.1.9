<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="DateBean,ArrayCheckBoxBean,ArrayCheckBox2DBean,Array2DimensionInputBean,SendMailBean,CodeUtil" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>無標題文件</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>
<FORM ACTION="TSSalesDRQForceProcess.jsp" METHOD="post" NAME="FORCEPROCESSFORM">
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%> 
<%
  String dnDocNo=request.getParameter("DNDOCNO");
  String fromStatusID=request.getParameter("FROMSTATUSID");
  String recUserID=request.getParameter("RECUSERID");
  String statusID=request.getParameter("STATUSID");
  //out.println("dnDocNo="+dnDocNo);
  try 
  { 
    //out.println("statusID="+statusID);
	//out.println("recUserID="+recUserID);
    if (statusID!=null && !statusID.equals("--"))
	{  //out.println("statusID="+statusID);
	    Statement statement=con.createStatement(); 
	    ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+statusID+"'");
        rs.next();
        String tarStatus=rs.getString("STATUSNAME");   
        statement.close();
        rs.close();	
	   //out.println("UPDATE Header="+tarStatus);
	  
	   //Step1. 先改Header 狀態
	          String sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,STATUSID=?,STATUS=? "+
	                     "where DNDOCNO='"+dnDocNo+"'  ";     
              PreparedStatement pstmt=con.prepareStatement(sql);	
	          pstmt.setString(1,userID); 
              pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
              pstmt.setString(3,statusID);
              pstmt.setString(4,tarStatus); //         
		      pstmt.executeUpdate(); 
              pstmt.close();
	 // Step2. 取Header目前資料筆數  
			  //out.println("先取目前資料筆數"); 	 
	          int deliveryCount_H = 0;
	          Statement stateDeliveryCNT_H=con.createStatement(); 
              ResultSet rsDeliveryCNT_H=stateDeliveryCNT_H.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+dnDocNo+"' ");
	          if (rsDeliveryCNT_H.next())
	          {
	           deliveryCount_H = rsDeliveryCNT_H.getInt(1);
	          }
	          rsDeliveryCNT_H.close();
	          stateDeliveryCNT_H.close();
		//out.println("Insert Header History");
	 //out.println("Step3:寫Header 歷程檔"); 
			  String historySql_H="insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		                          "values(?,?,?,?,?,?,?,?,?,?,?,?) ";
	          PreparedStatement historystmt_H=con.prepareStatement(historySql_H);   
              historystmt_H.setString(1,dnDocNo); 
              historystmt_H.setString(2,fromStatusID); 
              historystmt_H.setString(3,tarStatus); //寫入status名稱
              historystmt_H.setString(4,"999"); 
              historystmt_H.setString(5,"FORCE"); 
              historystmt_H.setString(6,userID); 
              historystmt_H.setString(7,dateBean.getYearMonthDay()); 
              historystmt_H.setString(8,dateBean.getHourMinuteSecond());
              historystmt_H.setString(9,""); //寫入工廠編號
              historystmt_H.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              historystmt_H.setString(11,"ADMIN FORCE UPDATE DOCUMENT STATUS"); // 本次處理說明欄位
              historystmt_H.setInt(12,deliveryCount_H);		
		      historystmt_H.executeUpdate();   
              historystmt_H.close();   
			  
	 // Step4. 取Detail目前資料明細   
              Statement stateDRQ=con.createStatement(); 
              ResultSet rsDRQ=stateDRQ.executeQuery("select * from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' order by LINE_NO ");
	          while (rsDRQ.next())
	          {  //out.println("Update Detail");
			    //Step5. 更新明細內容
	              String sqlDtl="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	                            "where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+rsDRQ.getString("LINE_NO")+"' ";     
                  PreparedStatement pstmtDetail=con.prepareStatement(sqlDtl);	
				  pstmtDetail.setString(1,userID); 
                  pstmtDetail.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
                  pstmtDetail.setString(3,statusID);
                  pstmtDetail.setString(4,tarStatus); //         
		          pstmtDetail.executeUpdate(); 
				  pstmtDetail.close();
				  
			   //Step6. 取Detail目前資料筆數 
				   int deliveryCount = 0;
	               Statement stateDeliveryCNT=con.createStatement(); 
                   ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+rsDRQ.getString("LINE_NO")+"' ");
	               if (rsDeliveryCNT.next())
	               {
	                deliveryCount = rsDeliveryCNT.getInt(1);
	               }
	               rsDeliveryCNT.close();
	               stateDeliveryCNT.close();
			   //Step7:寫Detail 歷程檔");  
			   //out.println("Insert Detail History");
				  String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	              PreparedStatement historystmt=con.prepareStatement(historySql);   
                  historystmt.setString(1,dnDocNo); 
                  historystmt.setString(2,fromStatusID); 
                  historystmt.setString(3,tarStatus); //寫入status名稱
                  historystmt.setString(4,"999"); 
                  historystmt.setString(5,"FORCE"); 
                  historystmt.setString(6,userID); 
                  historystmt.setString(7,dateBean.getYearMonthDay()); 
                  historystmt.setString(8,dateBean.getHourMinuteSecond());
                  historystmt.setString(9,""); //寫入工廠編號
                  historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
                  historystmt.setString(11,"ADMIN FORCE UPDATE DOCUMENT STATUS"); //REMARK
                  historystmt.setInt(12,deliveryCount);
		          historystmt.setInt(13,Integer.parseInt(rsDRQ.getString("LINE_NO"))); // 寫入處理Line_No
		          historystmt.setFloat(14,0);		
		          historystmt.executeUpdate();   
                  historystmt.close(); 
				  
	          }
	          rsDRQ.close();
	          stateDRQ.close();
			  
			  
	} // End of if (statusID!=null)		
	
	if (recUserID!=null && !recUserID.equals("--"))  
	{ 
	    Statement statement=con.createStatement(); 
	    ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
        rs.next();
        String tarStatus=rs.getString("STATUSNAME");   
        statement.close();
        rs.close();	
	  
	   //Step1. 先改Header開單人員 狀態
	          String sql="update ORADDMAN.TSDELIVERY_NOTICE set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,STATUSID=?,STATUS=?,CREATED_BY=? "+
	                     "where DNDOCNO='"+dnDocNo+"'  ";     
              PreparedStatement pstmt=con.prepareStatement(sql);	
	          pstmt.setString(1,userID); 
              pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
              pstmt.setString(3,fromStatusID);
              pstmt.setString(4,tarStatus); // 
			  pstmt.setString(5,recUserID); //         
		      pstmt.executeUpdate(); 
              pstmt.close();
	   // Step2. 取Header目前資料筆數  
			  //out.println("先取目前資料筆數"); 	 
	          int deliveryCount_H = 0;
	          Statement stateDeliveryCNT_H=con.createStatement(); 
              ResultSet rsDeliveryCNT_H=stateDeliveryCNT_H.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+dnDocNo+"' ");
	          if (rsDeliveryCNT_H.next())
	          {
	           deliveryCount_H = rsDeliveryCNT_H.getInt(1);
	          }
	          rsDeliveryCNT_H.close();
	          stateDeliveryCNT_H.close();
			  
	 //out.println("Step3:寫Header 歷程檔"); 
			  String historySql_H="insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?) ";
	          PreparedStatement historystmt_H=con.prepareStatement(historySql_H);   
              historystmt_H.setString(1,dnDocNo); 
              historystmt_H.setString(2,fromStatusID); 
              historystmt_H.setString(3,tarStatus); //寫入status名稱
              historystmt_H.setString(4,"999"); 
              historystmt_H.setString(5,"FORCE"); 
              historystmt_H.setString(6,userID); 
              historystmt_H.setString(7,dateBean.getYearMonthDay()); 
              historystmt_H.setString(8,dateBean.getHourMinuteSecond());
              historystmt_H.setString(9,""); //寫入工廠編號
              historystmt_H.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
              historystmt_H.setString(11,"ADMIN FORCE UPDATE CREATE USER"); // 本次處理說明欄位
              historystmt_H.setInt(12,deliveryCount_H);		
		      historystmt_H.executeUpdate();   
              historystmt_H.close();   
			  
	 // Step4. 取Detail目前資料明細   
              Statement stateDRQ=con.createStatement(); 
              ResultSet rsDRQ=stateDRQ.executeQuery("select * from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' order by LINE_NO ");
	          while (rsDRQ.next())
	          {
			    //Step5. 更新明細內容
	              String sqlDtl="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,CREATED_BY=? "+
	                         "where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+rsDRQ.getString("LINE_NO")+"' ";     
                  PreparedStatement pstmtDetail=con.prepareStatement(sqlDtl);	
				  pstmtDetail.setString(1,userID); 
                  pstmtDetail.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
                  pstmtDetail.setString(3,fromStatusID);
                  pstmtDetail.setString(4,tarStatus); //
				  pstmtDetail.setString(5,recUserID); //         
		          pstmtDetail.executeUpdate(); 
				  pstmtDetail.close();
				  
			   //Step6. 取Detail目前資料筆數 
				   int deliveryCount = 0;
	               Statement stateDeliveryCNT=con.createStatement(); 
                   ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+rsDRQ.getString("LINE_NO")+"' ");
	               if (rsDeliveryCNT.next())
	               {
	                deliveryCount = rsDeliveryCNT.getInt(1);
	               }
	               rsDeliveryCNT.close();
	               stateDeliveryCNT.close();
			   //Step7:寫Detail 歷程檔");  
				  String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                        "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	              PreparedStatement historystmt=con.prepareStatement(historySql);   
                  historystmt.setString(1,dnDocNo); 
                  historystmt.setString(2,fromStatusID); 
                  historystmt.setString(3,tarStatus); //寫入status名稱
                  historystmt.setString(4,"999"); 
                  historystmt.setString(5,"FORCE"); 
                  historystmt.setString(6,userID); 
                  historystmt.setString(7,dateBean.getYearMonthDay()); 
                  historystmt.setString(8,dateBean.getHourMinuteSecond());
                  historystmt.setString(9,""); //寫入工廠編號
                  historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
                  historystmt.setString(11,"ADMIN FORCE UPDATE CREATE USER"); //REMARK
                  historystmt.setInt(12,deliveryCount);
		          historystmt.setInt(13,Integer.parseInt(rsDRQ.getString("LINE_NO"))); // 寫入處理Line_No
		          historystmt.setFloat(14,0);		
		          historystmt.executeUpdate();   
                  historystmt.close(); 
				  
	          }
	          rsDRQ.close();
	          stateDRQ.close(); 
	} // End of if (recUserID!=null)	
			
			
	out.println("<BR>Processing Sales Delivery Request value(DNDOCNO:<A HREF='TSSalesDRQDisplayPage.jsp?DNDOCNO="+dnDocNo+"'><font color=#FF0000>"+dnDocNo+"</font></A>) OK!");		  
			  
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  

%>
</body>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
