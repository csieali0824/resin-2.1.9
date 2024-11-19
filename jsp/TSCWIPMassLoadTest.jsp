<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<%@ page import="DateBean,CodeUtil"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Test Submit Request WIP Mass Load</title>
</head>

<body>

<%
     String groupID=request.getParameter("GROUPID");
     String respID = ""; // TSC_WIP_SEMI_SU  --> 台半 WIP Super User 預設
	 String startDate="20060928";
	 String interfaceId="";
%>
<%
     String groupId       = "0";
	 String entityId      = "0";
	 java.sql.Date startdate = null;
	 startdate = new java.sql.Date(Integer.parseInt(startDate.substring(0,4))-1900,Integer.parseInt(startDate.substring(4,6))-1,Integer.parseInt(startDate.substring(6,8)));  // 給startDate
	 
     String sqlf = "select WIP_INTERFACE_S.NEXTVAL, WIP_JOB_SCHEDULE_INTERFACE_S.NEXTVAL INTERFACE_ID,WIP_JOB_SCHEDULE_INTERFACE_S.CURRVAL GROUP_ID, "+
	 				"       WIP_ENTITIES_S.NEXTVAL ENTITY_ID from dual " ;
	 //out.print("sqlf="+sqlf);
	 Statement statef=con.createStatement();
     ResultSet rsf=statef.executeQuery(sqlf);
	 if (rsf.next())
		 {
		  	interfaceId   = rsf.getString(1); 
		 	groupId       = rsf.getString(2); 
			entityId      = rsf.getString(3);
		  }
	 rsf.close();
     statef.close(); 	
	 

 
  try
  {
      //out.print("step01");
      String inSql="insert into WIP_JOB_SCHEDULE_INTERFACE (  "+
					"       FIRST_UNIT_START_DATE, GROUP_ID, "+					
					"       BOM_REFERENCE_ID, COMPLETION_SUBINVENTORY,  "+
					"		CREATED_BY,CREATION_DATE,JOB_NAME,LAST_UPDATE_DATE,LAST_UPDATED_BY,WIP_ENTITY_ID,HEADER_ID, "+
					"		LOAD_TYPE,NET_QUANTITY,ORGANIZATION_ID,PRIMARY_ITEM_ID,  "+
					"		PROCESS_PHASE,PROCESS_STATUS,START_QUANTITY,STATUS_TYPE,ALLOW_EXPLOSION, INTERFACE_ID) "+
					"values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "; 
	  //out.print("inSql="+inSql);				
      PreparedStatement instmt=con.prepareStatement(inSql);     
      
	  //    out.print("interfaceId="+interfaceId+"<br>");	
	  instmt.setDate(1,startdate);    //FIRST_UNIT_START_DATE 預計投入日	  
      instmt.setInt(2,Integer.parseInt(groupId)); 
	  out.print("groupId="+groupId+"<br>");	    
	  //instmt.setString(3,"Y"); 								 //ALLOW_EXPLOSION
      instmt.setInt(3,57458);      
	  instmt.setString(4,"");   							//completion sub  
	  instmt.setInt(5,3077);     //create by
	  instmt.setDate(6,startdate);    		 //create date
	  instmt.setString(7,"Test010");   							 //job name
	  instmt.setDate(8,startdate);         //lastupdate date
	  instmt.setInt(9,3077);    //lastupdate by
	  instmt.setInt(10,Integer.parseInt(entityId));         //wip_entity_id
	  instmt.setInt(11,Integer.parseInt(entityId));         //heaer_id
	  instmt.setInt(12,1);    								//load_type   1=create   3=update
	  instmt.setInt(13,10);   			 //net_qty
	  instmt.setInt(14,49);    //organization_id
	  instmt.setInt(15,57458);    //primary item id
	  instmt.setInt(16,2);    //process_phase    2 PROCESS_PHASE = 2 (Validation)
	  instmt.setInt(17,1);    //process_status   1 =Pending  3=error
	  instmt.setInt(18,10);    //start qty
	  instmt.setInt(19,3);    //status_type      1=unlease 3=release 
	  instmt.setString(20,"Y");    //status_type      1=unlease 3=release
	  instmt.setInt(21,Integer.parseInt(interfaceId));	  
      instmt.executeUpdate();
      instmt.close();  
	  	
	  con.commit(); // 確認執行choice[k] 的 Processor;
		
      
	  
  	    String sqlf1 = " select INTERFACE_ID from WIP_JOB_SCHEDULE_INTERFACE where group_id= "+groupId ;
		out.print("sqlf1="+sqlf1);
	    Statement statef1=con.createStatement();
 	    ResultSet rsf1=statef1.executeQuery(sqlf1);
		 if (rsf1.next())
		   { out.print("stepaa");
		 	interfaceId   = rsf1.getString("INTERFACE_ID"); 
			out.print("<br>"+"interfaceId="+interfaceId);
	  	   }
		rsf1.close();
     	statef1.close();

  }// end of try	  		  
  catch (Exception e)
  {
     out.println("Exception interface:"+e.getMessage());
   }	


%>

<%
    
	 
	  Statement stateResp=con.createStatement();
	  String sqlResp = "select DISTINCT RESPONSIBILITY_ID from FND_RESPONSIBILITY_TL where APPLICATION_ID = '706' and RESPONSIBILITY_NAME like '%WIP_SEMI_SU' "; 
	  ResultSet rsResp=stateResp.executeQuery(sqlResp); 
	  if (rsResp.next())
	  {
	     respID = rsResp.getString("RESPONSIBILITY_ID");
	  } else {
	           respID = "50146"; // 找不到則預設 --> 台半 WIP Super User 預設
	         }
			 rsResp.close();
			 stateResp.close();
	 
	 
	 
	 if (groupID==null || groupID.equals(""))
	 { 
	   if (groupId==null)
	   {
	    %>
		<script language="javascript">		
		  alert("請輸入GroupID !!!\n xxx.jsp?GROUPID=xxx");
		</script>
		<%		
	    }
		else groupID=groupId;
	 } else {

                // 先取 Btach Job 執行人員 ID, 否則設為 Kerwin = 3077
	 
	                  Statement stateUser=con.createStatement();
		              String sqlUser = "select USER_ID from FND_USER where USER_NAME = '"+userID+"' "; 
					  ResultSet rsUser=stateUser.executeQuery(sqlUser); 
					  if (rsUser.next()) 
					  { userID = rsUser.getString("USER_ID"); }
					  else { userID = "3077"; }
					  rsUser.close();
					  stateUser.close(); 
	            // 先取 Btach Job 執行人員 ID

                //	Step1. 寫入 Schedult Discrete Job API submit request 的Procedure 並取回 Oracle Request ID	
				 CallableStatement cs3 = con.prepareCall("{call TSC_WIP_MASSLOAD_REQUEST(?,?,?,?)}");			 
	             cs3.setString(1,groupID);  /*  Group ID */	
				 cs3.setString(2,userID);  /*  user_id 修改人ID */	
				 cs3.setString(3,respID);  /*  使用的Responsibility ID --> TSC_INV_Semi_SU */					 
	             cs3.registerOutParameter(4, Types.INTEGER); 
	             cs3.execute();
                 // out.println("Procedure : Execute Success !!! ");
	             int requestID = cs3.getInt(4);
                 cs3.close();
				 
				 if (requestID==0) out.println("Error process Request...");
				 else {
				          out.println("Success Submit !!! RequestID = "+requestID);
					  }
             }
%>
</body>
</html>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
