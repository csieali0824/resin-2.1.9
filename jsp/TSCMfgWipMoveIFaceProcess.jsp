<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Wip Move Transaction Processing</title>
</head>
<body>

<%  
        String toIntStepType=request.getParameter("TOINTSTEPTYPE");

        String sql = "select GROUP_ID from WIP_MOVE_TXN_INTERFACE where PROCESS_PHASE=1 and PROCESS_STATUS=2 and length(WIP_ENTITY_NAME)=10 and TO_INTRAOPERATION_STEP_TYPE = "+toIntStepType+" ";
	    //out.println("sql =:"+sql);
	    Statement statement=con.createStatement();
        ResultSet rs=statement.executeQuery(sql);
		while (rs.next())
		{
		     int grpId = 0;
		     String sqlSeq = "select WIP_TRANSACTIONS_S.NEXTVAL from dual ";
	         //out.println("sqlAddList =:"+sqlAddList);
	         Statement stateSeq=con.createStatement();
			 ResultSet rsSeq=stateSeq.executeQuery(sqlSeq);
			 if (rsSeq.next()) grpId = rsSeq.getInt(1);
			 rsSeq.close();
			 stateSeq.close();	
			 
			out.println("grpId ="+grpId+"<BR>");
		   
		    PreparedStatement stmt=con.prepareStatement("update WIP_MOVE_TXN_INTERFACE set TRANSACTION_ID="+grpId+", GROUP_ID = "+grpId+" "+
			                                           "  where PROCESS_PHASE=1 and PROCESS_STATUS=2 and length(WIP_ENTITY_NAME)=10 and GROUP_ID ="+rs.getString("GROUP_ID")+" and TO_INTRAOPERATION_STEP_TYPE = "+toIntStepType+" "); 
            stmt.executeUpdate();
            stmt.close();		

           // 即時呼叫 WIP_MOVE PROCESS WORKER		  
		   int procPhase = 1;
		   int timeOut = 10;
		   try
		   {	        
		                  int getRetScrapCode = 0;
						  String getErrScrapBuffer ="";						  
		             
					      CallableStatement cs5 = con.prepareCall("{call WIP_MOVPROC_PUB.processInterface(?,?,?,?,?)}");			 			   
			              cs5.setInt(1,grpId);   // 針對Group Id Process                                      //  Org ID 	
			              cs5.setString(2,null);   // BackFlush Setup    
			              cs5.setString(3,"T");	   // FND_API.G_TRUE = "T", FND_API.G_FALSE = "F"
			              cs5.registerOutParameter(4, Types.VARCHAR); //  傳回值     STATUS
			              cs5.registerOutParameter(5, Types.VARCHAR); //  傳回值		ERROR MESSAGE					 					      						   	 					     
			              cs5.execute();					      
			              String getMoveStatus = cs5.getString(4);		
			              String getMoveErrorMsg = cs5.getString(5);								      				    
			              cs5.close();	
						  
						  if (getMoveStatus.equals("U") && getMoveErrorMsg!=null && !getMoveErrorMsg.equals(""))
						  {
						     getRetScrapCode = 77;   // Error Number  
							 getErrScrapBuffer = getMoveErrorMsg; // 把錯誤訊息給原來判斷的Buffer
							 out.println("getRetScrapCode="+getRetScrapCode+"&nbsp;"+"Move Transaction錯誤原因="+getErrScrapBuffer+"<BR>");
						  }	else {
						           out.println("Move Status="+getMoveStatus+"<BR>Move Message="+getMoveErrorMsg+"<BR>");						  
						         }  	  
					 
			}	  
			catch (Exception e) { out.println("Exception Move Transaction Error:"+e.getMessage()); }  
		  		 
		 // *****%%%%%%%%%%%%%% 移站報廢數量數量  %%%%%%%%%%%%**********  迄
	}  // End of while
	rs.next();
	statement.close(); 

%>
</body>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
