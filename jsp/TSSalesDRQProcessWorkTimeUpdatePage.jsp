<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="DateBean" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>更新工時(交期詢單處理工時)</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>
<body>
<%

  try  
  { // 所有處理工時為零的作更新
    int countUpdateRow = 1;
    String sql = "select * from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where PROCESS_WORKTIME = 0 ";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sql);    
    while(rs.next())
    {
       String oriStatusID = rs.getString("ORISTATUSID");	// 判斷取得的原狀態
	   String dnDocNo = rs.getString("DNDOCNO");
	   String lineNo = rs.getString("LINE_NO");
	   
	   float processWorkTime = 0;
	   
	   if (oriStatusID.equals("001")) // 草稿文件 --> 草稿文件
	   { 
	         // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		      String preWorkTime = "0"; 
			  //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		      Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
              ResultSet rsHProcWT=stateHProcWT.executeQuery("select CREATION_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' ");
	          if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		      {
			     preWorkTime = rsHProcWT.getString(1);
			  }
			  rsHProcWT.close();
			  stateHProcWT.close();
             //若取到前一個狀態時間,則以目前時間減去前
		     if (preWorkTime!="0")
		     {
			    String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
			 
			  
			  
	   } //
	   else if (oriStatusID.equals("002"))
	        {
			    // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		        String preWorkTime = "0"; 
			    //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		        Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='001' ");
	            if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		        {
			      preWorkTime = rsHProcWT.getString(1);
			    } else {
				          Statement stateCProcWT=con.createStatement();  // 若不存在草稿文件,則找單據開立日為
                          ResultSet rsCProcWT=stateCProcWT.executeQuery("select CREATION_DATE from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' ");   
						  if (rsCProcWT.next())
						  {
						   preWorkTime = rsCProcWT.getString(1);
						  }
						  rsCProcWT.close();
						  stateCProcWT.close();
				       }
			    rsHProcWT.close();
			    stateHProcWT.close();
                //若取到前一個狀態時間,則以目前時間減去前
		        if (preWorkTime!="0")
		        {
			      String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
			} else if (oriStatusID.equals("003"))
			       {
				     // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		             String preWorkTime = "0"; 
			         //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		             Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '002' 
                     ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='002' ");
	                 if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		             {
			           preWorkTime = rsHProcWT.getString(1);
			         }
			         rsHProcWT.close();
			         stateHProcWT.close();
                     //若取到前一個狀態時間,則以目前時間減去前
		             if (preWorkTime!="0")
		             {
			            String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
				          
				    } else if (oriStatusID.equals("004"))
					       {
						       // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                       String preWorkTime = "0"; 
			                   //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                       Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' 
                               ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='003' ");
	                           if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                       {
			                    preWorkTime = rsHProcWT.getString(1);
			                   }
			                   rsHProcWT.close();
			                   stateHProcWT.close();
                               //若取到前一個狀態時間,則以目前時間減去前
		                      if (preWorkTime!="0")
		                      {
			                    String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
						   } else if (oriStatusID.equals("007"))
						          {  // 有可能是來自於 REJECT(003) 或 CONFIRMED(004)
								    // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                            String preWorkTime = "0"; 
			                        //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                            Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' 
                                    ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID in ('004','003') order by CDATETIME ASC ");
	                                if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                            {
			                         preWorkTime = rsHProcWT.getString(1);
			                        }
			                        rsHProcWT.close();
			                        stateHProcWT.close();
                                    //若取到前一個狀態時間,則以目前時間減去前
		                            if (preWorkTime!="0")
		                            {
			                          String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
								     
								  } else if (oriStatusID.equals("008"))
								         {
										      // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                                      String preWorkTime = "0"; 
			                                  //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                                      Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' 
                                              ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='007' ");
	                                          if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                                      {
			                                    preWorkTime = rsHProcWT.getString(1);
			                                  }
			                                  rsHProcWT.close();
			                                  stateHProcWT.close();
                                              //若取到前一個狀態時間,則以目前時間減去前
		                                      if (preWorkTime!="0")
		                                      {
			                                     String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
										 } else if (oriStatusID.equals("009"))
										        {
												    // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                                            String preWorkTime = "0"; 
			                                         //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                                            Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' 
                                                    ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='008' ");
	                                                if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                                            {
			                                          preWorkTime = rsHProcWT.getString(1);
			                                        }
			                                        rsHProcWT.close();
			                                        stateHProcWT.close();
                                                    //若取到前一個狀態時間,則以目前時間減去前
		                                            if (preWorkTime!="0")
		                                            {
			                                          String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
												     
												} else if (oriStatusID.equals("010"))
												       {
													       // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                                                   String preWorkTime = "0"; 
			                                               //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                                                   Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' 
                                                           ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='009' ");
	                                                       if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                                                   {
			                                                preWorkTime = rsHProcWT.getString(1);
			                                               }
			                                               rsHProcWT.close();
			                                               stateHProcWT.close();
                                                           //若取到前一個狀態時間,則以目前時間減去前
		                                                   if (preWorkTime!="0")
		                                                   {
			                                                 String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
													   } else if (oriStatusID.equals("012"))
													          {
															     // 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		                                                         String preWorkTime = "0"; 
			                                                     //out.println("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesTemporaryCode[i][0]+"' and ORISTATUSID ='001' ");
		                                                         Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '004' 
                                                                 ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='008' ");
	                                                             if (rsHProcWT.next())  // 草稿文件第一筆資料為文件起始,故取明細檔
		                                                         {
			                                                       preWorkTime = rsHProcWT.getString(1);
			                                                     }
			                                                     rsHProcWT.close();
			                                                     stateHProcWT.close();
                                                                 //若取到前一個狀態時間,則以目前時間減去前
		                                                         if (preWorkTime!="0")
		                                                         {
			                                                       String sqlWT = "select ROUND((to_date(CDATETIME,'YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
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
															     
															  
															  }
			
     // 更新工時_起
		String historySql="update ORADDMAN.TSDELIVERY_DETAIL_HISTORY set PROCESS_WORKTIME=? "+
		                        "where DNDOCNO = '"+dnDocNo+"' and to_char(LINE_NO) = '"+lineNo+"' and ORISTATUSID ='"+oriStatusID+"' ";
	    PreparedStatement historystmt=con.prepareStatement(historySql);  
	    historystmt.setFloat(1,processWorkTime);		
		historystmt.executeUpdate();   
        historystmt.close(); 	
     // 更新工時_迄
	 
	  countUpdateRow++;
	  out.println("RFQ NO :"+dnDocNo+ "- LineNo:("+lineNo+")"+" Update Success !!!"+"<BR>");
	  
	}
    rs.close(); 
	statement.close();
    out.println("共更新:"+countUpdateRow+" 筆記錄");   
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
