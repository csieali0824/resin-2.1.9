<!--20161117 by Peggy,工廠PC confirm前再檢查一次rfq狀態是否合法,避免系統異常,造成重複confirm,重複轉單-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.lang.Object.*,java.text.Format.*" %>
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
<title>Sales Delivery Request M Data Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--FOR MATERIAL USAGE-->
<jsp:useBean id="array2DAssignFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 企劃分派產地-->
<jsp:useBean id="array2DEstimateFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠安排交期確認中-->
<jsp:useBean id="array2DArrangedFactoryBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 工廠回覆交期確認-->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String pageURL=request.getParameter("PAGEURL");//承接前一頁所傳來之參數
String [] choice=request.getParameterValues("CH");
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String dnDocNo=request.getParameter("DNDOCNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String tsRpCenterNo=request.getParameter("TSRPCENTERNO");
String repPersonID=request.getParameter("REPPERSONID");
String oriIMEI=request.getParameter("IMEI");
String modelNo=request.getParameter("MODELNO");
String itemNo=request.getParameter("ITEMNO");
String cmrName=request.getParameter("CMRNAME");
String remark=request.getParameter("REMARK");
String line_No=request.getParameter("LINE_NO");

String actRepMethod=null;
// 2005/12/03 取session 的Bean 的選取的生管指派指對應代碼 // By Kerwin
String aFactoryCode[][]=array2DAssignFactoryBean.getArray2DContent();//取得assignFactoryCode目前陣列內容 
String aFactoryEstimatingCode[][]=array2DEstimateFactoryBean.getArray2DContent();//取得工廠交期安排確認目前陣列內容
// 2004/07/08 取session 的Bean 的選取的維修方式對應代碼 // By Kerwin

String changeProdCenterNo=request.getParameter("CHANGEREPCENTERNO");
String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
//String worktime=request.getParameter("WORKTIME");  
//String changeTypeNo=request.getParameter("CHANGETYPENO");

String RepCenterLOC=(String)session.getAttribute("BLLOC");
String [] recItemNo2=request.getParameterValues("RECITEMNO2"); //後送維修收件項目
String recItemString="";
String[] situationConfirm=request.getParameterValues("SITUATIONCONFIRM"); //報價時之機況確認

//String repairingCost=request.getParameter("REPAIRINGCOST"); 
String itemCost=request.getParameter("ITEMCOST");  
String transCost=request.getParameter("TRANSCOST"); 
String otherCost=request.getParameter("OTHERCOST"); 

String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String newDRQOption=request.getParameter("NEWDRQOPTION");//是否要以原單據內容產生新的交期詢問單
String [] standardOfDOAP=request.getParameterValues("STANDARDOFDOAP");//取得DOA/DAP判定標準

String oriStatus=null;
String actionName=null;

String dateString="";
String seqkey="";
String seqno="";
String lotno=null;
String lotkey=null;
String receiptkey=null;
String receiptNo=null;
String rpTxComNo="";//領料單單號
String rpTxComNoIssue="";//倉管發料領料單單號

//2004-10-05 ADD BEGIN
String recitemNo=request.getParameter("RECITEMNO");
String itemno2="";
String qty=request.getParameter("QTY");
String recType=request.getParameter("RECTYPE");
String svrType=request.getParameter("TYPENO");
//String rCenter=recCenterNo;
//if (rCenter!=null) rCenter=rCenter.substring(0,3);
String fwhs=""; // from whs
String floct=""; // from location
String ftype=""; // to transaction type
String fres=""; // to reason
String twhs=""; // to   whs
String tloct=""; // to location
String ttype=""; // to transaction type
String tres=""; // to reason
String pcbitemNo=request.getParameter("PCBITEMNO");
//2004-11-10  begin
String pcb2=request.getParameter("PCB2");
if (pcbitemNo == null || pcbitemNo.equals("--") || pcbitemNo.equals(""))
{
	if (pcb2 != null && !pcb2.equals(""))
	{ 
		pcbitemNo = pcb2.toUpperCase() ;
	}
}
	
// 2004-11-10 end
String fitemNo=""; // 
String titemNo=""; // 
String pcb="";
String pcbSelected="N";
//2004-10-05 ADD END
//2005/05/10 Add By Kerwin
String shipType=request.getParameter("SHIPCODE");
// 2005/05/10 Add By Kerwin

String assignLNo = "";
String arrangDate ="";
boolean is_exist = false; //add by Peggy 20161117
String strstatusId="",strstatusName="",stractionname="",sql=""; //add by Peggy 20161117

// 若使用者未於批次作業點選任一Check Box	  
if (choice==null || choice[0].equals(null))    // 2004/11/25 for fileter user don't choosen any item to process // 2004/11/25
{ 
	out.println("<font color='#FF0000' face='ARIAL BLACK' size='3'> Warning !!!</font>,<font color='#000099' face='ARIAL'><strong>Nothing gonna to Process,Please choice Case .</strong></font>"); 
} 
else 
{
	// formID = 基本資料頁傳來固定常數='TS'
  	// fromStatusID = 基本資料頁傳來Hidden 參數
  	// actionID = 前頁取得動作 ID( Assign = 003 )
 	try
 	{ // 先取得下一狀態及狀態描述並作流程狀態更新   
  		dateString=dateBean.getYearMonthDay();
  		//若有指派人員則找出其e-Mail
  		if (changeProdPersonID!=null)
  		{
    		Statement mailStat=con.createStatement();  
    		ResultSet mailRs=mailStat.executeQuery("select USERMAIL from ORADDMAN.WSUSER where WEBID='"+changeProdPersonID+"'");  
    		if (mailRs.next()) changeProdPersonMail=mailRs.getString("USERMAIL");
			mailRs.close();
			mailStat.close();	
  		}	
		String sqlStat = "";
		String whereStat = "";
		//out.println("FORMID="+formID);
		sqlStat = "select x1.TOSTATUSID,x2.STATUSNAME ,x3.actionname from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2,ORADDMAN.TSWFACTION x3 ";
		whereStat ="WHERE x1.FROMSTATUSID='"+fromStatusID+"' AND x1.ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'"+
		           " and x1.actionid =x3.actionid ";
		// 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		if (!UserRoles.equals("admin"))
		{
			if (userActCenterNo.equals("010") || userActCenterNo.equals("011"))
			{ 
				whereStat += " and x1.FORMID='SH' "; // 若是上海內銷辦事處
			}
			else
			{ 
				whereStat += " and x1.FORMID='TS' "; // 否則一律皆為外銷流程
			}
		}
		
		// 2006/04/13加入特殊內銷流程,針對上海內銷_迄		
		sqlStat = sqlStat+whereStat;
		//out.println(sqlStat);
		Statement getStatusStat=con.createStatement();  
		ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
		if (getStatusRs.next())
		{
			strstatusId=getStatusRs.getString("TOSTATUSID");
			strstatusName=getStatusRs.getString("STATUSNAME");
			stractionname=getStatusRs.getString("actionname");
		}
		getStatusRs.close();
		getStatusStat.close();

		//String prodDesc = null;
		//String prodCodeGet = "";
		//int prodCodeGetLength = 0;  
		// 處理工時宣告
		float processWorkTime = 0;
		String choiceDocNo ="",choiceLine="";
		// 處理工時宣告
      
  		for (int k=0;k<choice.length ;k++)    
  		{    
			choiceDocNo = choice[k].substring(0,17);
			choiceLine = choice[k].substring(18,choice[k].indexOf("|",18));  // 找第一個 | 之後的 | 
			//java.text.DateFormat dateFormat = new java.text.SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
			//java.util.Date date = new java.util.Date();
			//out.println(dateFormat.format(date));
			
			//out.println(choiceDocNo + choiceLine);
			
 			/*
     		String sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=? where DNDOCNO='"+choiceDocNo+"'";
     		PreparedStatement pstmt=con.prepareStatement(sql);  
 
     		//pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
     		//pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
     		pstmt.setString(1,strstatusId); //寫入STATUSID
     		pstmt.setString(2,strstatusName); //寫入STATUS  
     		pstmt.executeUpdate();
     		pstmt.close();   
  			*/
  
		   	//若為工廠交期已確定(ARRANGED_004),則執行以下動作_起
    		//將交期詢問單屬於不同的產地之明細分別給定分批序號(呼叫給號程序段
	     	if (actionID.equals("009") || actionID.equals("010") || actionID.equals("011") || actionID.equals("015")) 
     		{
				if (actionID.equals("009")) // 工廠交期確立,回覆予企劃生管人員(STATUS = (004)ARRANGED)
	  			{
					//add by Peggy  20161021,update前檢查rfq狀態是否合法
					Statement stater=con.createStatement();
					sql = " select 1 from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
						  " where DNDOCNO='"+choiceDocNo+"' "+
						  " and TO_CHAR(LINE_NO) = '"+choiceLine+"'"+
						  " and a.LSTATUSID='"+fromStatusID+"'";
					ResultSet rsr=stater.executeQuery(sql);
					if (rsr.next())
					{
						is_exist=true;
					}
					else
					{
						is_exist=false;
					}
					rsr.close();
					stater.close();
					
					if (!is_exist)
					{
						throw new Exception("查無RFQ:"+choiceDocNo +" Line:"+choiceLine+" 資料,請重新確認!");
					}	

			       	sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	    		       "where DNDOCNO='"+choiceDocNo+"' and to_char(LINE_NO)='"+choiceLine+"' ";     
		           	PreparedStatement pstmt=con.prepareStatement(sql);
				   	pstmt.setString(1,userID); // 最後更新人員 
				   	pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		   			//pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		   			//pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態  
		   			pstmt.setString(3,strstatusId); // Line 的狀態ID
		   			pstmt.setString(4,strstatusName); // Line 的狀態  
           			pstmt.executeUpdate(); 
           			pstmt.close(); 
		
		   			// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		      		String preWorkTime = "0"; 			 
		      		Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '002' (工廠安排交期中送出前一狀態為ASSIGNING(002))
              		ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME,ARRANGED_DATE from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choiceDocNo+"' and TO_CHAR(LINE_NO)='"+choiceLine+"' and ORISTATUSID ='003' ");
	          		if (rsHProcWT.next())
		      		{
			     		preWorkTime = rsHProcWT.getString(1);
			     		arrangDate = rsHProcWT.getString(2);  //20101105 liling
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
			  	} 
				else if (actionID.equals("010") ) // 企劃生管作RESPONDING (STATUS=(007)予業務)
	      		{		
				    
					sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
	            		"where DNDOCNO='"+choiceDocNo+"' and to_char(LINE_NO)='"+choiceLine+"' ";   
			  
		            PreparedStatement pstmt=con.prepareStatement(sql);
            		// pstmt.setString(1,aFactoryCode[i][6]);                
		    		pstmt.setString(1,userID); // 最後更新人員 
		    		pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		    		//pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		    		//pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態  
		    		pstmt.setString(3,strstatusId); // Line 的狀態ID
		    		pstmt.setString(4,strstatusName); // Line 的狀態  
            		pstmt.executeUpdate(); 
            		pstmt.close(); 						
		  		}
				else if (actionID.equals("011")) ////業務取得客戶確認交期, For 管理員,可依單據作更新
		        { 
									 	
					sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
						"where DNDOCNO='"+choiceDocNo+"' and LINE_NO = '"+choiceLine+"' ";   
					if (!UserRoles.equals("admin")) 
					{
						if (UserRegionSet==null || UserRegionSet.equals(""))
			            { 
							sql += " and substr(DNDOCNO,3,3)='"+userActCenterNo+"' ";
						}
						else 
						{
							sql += " and substr(DNDOCNO,3,3) in ("+UserRegionSet+") ";
						}
			        }	
						   
				    // 2006/12/27_因應 YEW ERP上線_判斷大陸內銷單(012,013區)如給天津廠生產地(T)的項次,直接結案_起
					String prodFactory = "";
					Statement stateMFGArea=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                    ResultSet rsMFGArea=stateMFGArea.executeQuery("select ALNAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO = (select ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"' and LINE_NO = "+choiceLine+" ) ");
	                if (rsMFGArea.next())
		            {
			       		prodFactory = rsMFGArea.getString(1);
			       	}
			        rsMFGArea.close();
			        stateMFGArea.close();
						   
					//String statusID=getStatusRs.getString("TOSTATUSID"); 
					//String status=getStatusRs.getString("STATUSNAME");
					String statusID=strstatusId; 
					String status=strstatusName;
					String salesAreaNo = choiceDocNo.substring(2,5);
					if ( (salesAreaNo.equals("012") || salesAreaNo.equals("013")) && prodFactory.equals("T") ) // 天津直接結案
					{
						statusID = "010"; // 產地是天津RFQ項次直接結案
						status = "CLOSED";// 產地是天津RFQ項次直接結案
					}
					// 2006/12/27_因應 YEW ERP上線_判斷大陸內銷單(012,013區)如給天津廠生產地(T)的項次,直接結案_迄						   
						   
                    PreparedStatement pstmt=con.prepareStatement(sql);
                    // pstmt.setString(1,aFactoryCode[i][6]);                
		            pstmt.setString(1,userID); // 最後更新人員 
		            pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		            pstmt.setString(3,statusID); // Line 的狀態ID
		            pstmt.setString(4,status);   // Line 的狀態  
                    pstmt.executeUpdate(); 
                    pstmt.close(); 		
						
					// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		            String preWorkTime = "0"; 			 
		            Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '002' (工廠安排交期中送出前一狀態為ASSIGNING(002))
                    ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choiceDocNo+"' and TO_CHAR(LINE_NO)='"+choiceLine+"' and ORISTATUSID ='007' ");
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
				} // End of actionID.equals("011")
				else if (actionID.equals("015")) ////業務取得客戶確認交期(但為內銷流程,確認後直接Close), For 管理員,可依單據作更新
		        {  	
					sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
						"where DNDOCNO='"+choiceDocNo+"' and LINE_NO = '"+choiceLine+"' ";   
					if (!UserRoles.equals("admin")) 
					{
						if (UserRegionSet==null || UserRegionSet.equals(""))
			            { 
							sql += " and substr(DNDOCNO,3,3)='"+userActCenterNo+"' ";
						}
						else 
						{
							sql +=  " and substr(DNDOCNO,3,3) in ("+UserRegionSet+") ";
						}
			       	}	

                    PreparedStatement pstmt=con.prepareStatement(sql);
		            pstmt.setString(1,userID); // 最後更新人員 
		            pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		            //pstmt.setString(3,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		            //pstmt.setString(4,getStatusRs.getString("STATUSNAME")); // Line 的狀態  
		            pstmt.setString(3,strstatusId); // Line 的狀態ID
		            pstmt.setString(4,strstatusName); // Line 的狀態  
                    pstmt.executeUpdate(); 
                    pstmt.close(); 		
						
					// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起		      
		            String preWorkTime = "0"; 			 
		            Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '002' (工廠安排交期中送出前一狀態為ASSIGNING(002))
                    ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choiceDocNo+"' and TO_CHAR(LINE_NO)='"+choiceLine+"' and ORISTATUSID ='007' ");
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
				}
	            
             	//Statement stateProdDesc=con.createStatement();    
             	//ResultSet rsProdDesc=stateProdDesc.executeQuery("select DISTINCT ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"'  and LINE_NO = '"+choiceLine+"' ");  //20101105 liling
             	//while (rsProdDesc.next()) 
             	//{ 
              	//	prodDesc = rsProdDesc.getString(1);
	          	//	prodCodeGet = prodCodeGet + prodDesc+","; 
             	//}
             	//rsProdDesc.close();
             	//stateProdDesc.close(); 	
			 
				//if (prodCodeGet.length()>0)
            	//{        
             	//	prodCodeGetLength = prodCodeGet.length()-1;  // 把最後的','去掉          
             	//	prodCodeGet = prodCodeGet.substring(0,prodCodeGetLength);
            	//}  
			
	 			if (actionID.equals("009")) // 若是工廠交期確立,回覆予企劃生管人員(STATUS = (004)ARRANGED)
				{ 
       				sql=" update ORADDMAN.TSDELIVERY_NOTICE set FCTPOMS_DATE=?,PROD_FACTORY=(select ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"'  and LINE_NO = '"+choiceLine+"'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	       				" where DNDOCNO='"+choiceDocNo+"' ";     
					PreparedStatement pstmt=con.prepareStatement(sql);
				    pstmt.setString(1,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
			        //pstmt.setString(2,prodCodeGet);        
				    pstmt.setString(2,userID); // 最後更新人員
				    pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
                    pstmt.executeUpdate(); 
       				pstmt.close();      
				 } 
				 else 
				 {
	           		sql=" update ORADDMAN.TSDELIVERY_NOTICE set PROD_FACTORY=(select ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"'  and LINE_NO = '"+choiceLine+"'),LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	                    " where DNDOCNO='"+choiceDocNo+"' ";     
		         	PreparedStatement pstmt=con.prepareStatement(sql);	          
               		//pstmt.setString(1,prodCodeGet);        
               		pstmt.setString(1,userID); // 最後更新人員
	           		pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間     
               		pstmt.executeUpdate(); 
               		pstmt.close();      
	         	}  // End of if ()
  			} 
  
  			// 業務詢問客戶取消原交期,並給定新的交期需求(ABORT)_起 (ACTION=013)
		  	if (actionID.equals("013")) 
  			{	   
		   		dateBean.setAdjDate(7); // 將日期調整7天;預定為新交期
		   		String dateNewRequest = dateBean.getYearMonthDay();
		   		dateBean.setAdjDate(-7); // 調整回今天日期
		   
	       		sql=" update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set PROMISE_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=? "+
   	                " where DNDOCNO='"+choiceDocNo+"' and TO_CHAR(LINE_NO)='"+choiceLine+"' ";     
           		PreparedStatement pstmt=con.prepareStatement(sql);
           		pstmt.setString(1,dateNewRequest); // 設定的客戶新交期需求日期    
			   	pstmt.setString(2,userID); // 最後更新人員 
		   		pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		   		//pstmt.setString(4,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		   		//pstmt.setString(5,getStatusRs.getString("STATUSNAME")); // Line 的狀態  
		   		pstmt.setString(4,strstatusId); // Line 的狀態ID
		   		pstmt.setString(5,strstatusName); // Line 的狀態  
           		pstmt.executeUpdate(); 
           		pstmt.close();    
  			} 
  
       		//out.println("先取目前明細資料筆數"); 	 
	   		int deliveryCount = 0;
	   		Statement stateDeliveryCNT=con.createStatement(); 
       		ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choiceDocNo+"' and TO_CHAR(LINE_NO)='"+choiceLine+"' ");
	   		if (rsDeliveryCNT.next())
	   		{
	     		deliveryCount = rsDeliveryCNT.getInt(1);
	   		}
	   		rsDeliveryCNT.close();
	   		stateDeliveryCNT.close();
	 
     		//Statement statement=con.createStatement();
     		//ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
		    //rs.next();
     		//actionName=rs.getString("ACTIONNAME");
   
     		//rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
     		//rs.next();
     		//oriStatus=rs.getString("STATUSNAME");
   
     		//rs.close();
     		//statement.close();
	
	    	String historySql=" insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME,ARRANGED_DATE) "+
		                      " values(?,?,?,?,?,?,?,?,(select ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"'  and LINE_NO = '"+choiceLine+"'),?,?,?,?,?,?) ";
		    PreparedStatement historystmt=con.prepareStatement(historySql);   
    	    historystmt.setString(1,choiceDocNo); 
        	historystmt.setString(2,fromStatusID); 
        	historystmt.setString(3,strstatusName); //寫入status名稱
        	historystmt.setString(4,actionID); 
        	historystmt.setString(5,stractionname); 
        	historystmt.setString(6,userID); 
        	historystmt.setString(7,dateBean.getYearMonthDay()); 
        	historystmt.setString(8,dateBean.getHourMinuteSecond());
        	//historystmt.setString(9,prodCodeGet); //寫入產地點編號
        	historystmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
        	historystmt.setString(10,remark);
        	historystmt.setInt(11,deliveryCount);
			historystmt.setInt(12,Integer.parseInt(choiceLine));
			historystmt.setFloat(13,processWorkTime);
			historystmt.setString(14,arrangDate);  //20101105 liling
			historystmt.executeUpdate();   
        	historystmt.close(); 
   
   			if (actionID.equals("021")) //若為批量後送(ROUTE)則再執行以下動作
   			{
				out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='RPTransListPage.jsp?LOTNO="+lotno+"'>");%><jsp:getProperty name="rPH" property="pgTransList"/><%out.println("(<font color=RED>");%><jsp:getProperty name="rPH" property="pgLotNo"/><%out.println(":"+lotno+"</font>)</A>"); 
    			out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='RPTransmitLotListPage.jsp?LOTNO="+lotno+"'>");%><jsp:getProperty name="rPH" property="pgPrintShippedConfirm"/><%out.println("</A><BR>"); 
			}
   			if (actionID.equals("013")) //若為倉管發料確認(ISSUE)則再執行以下動作
   			{
     			out.println("&nbsp;&nbsp;&nbsp;&nbsp;<A HREF='RPIssueAppReportPrint.jsp?RPTXCOM="+rpTxComNoIssue+"'>");%><jsp:getProperty name="rPH" property="pgMaterialRequest"/><%out.println("("+rpTxComNoIssue+")</A><BR>"); 
   			}
   
   
   			if (k==0) // 若是第一筆,則寫入歷程頭檔
   			{
	 
        		//out.println("先取目前資料筆數"); 	 
	    		int deliveryCountHD = 0;
	    		Statement stateDeliveryCNTHD=con.createStatement(); 
        		ResultSet rsDeliveryCNTHD=stateDeliveryCNTHD.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+choiceDocNo+"' ");
	    		if (rsDeliveryCNTHD.next())
	    		{
	     			deliveryCountHD = rsDeliveryCNTHD.getInt(1);
	    		}
	    		rsDeliveryCNTHD.close();
	    		stateDeliveryCNTHD.close();

       			//statement=con.createStatement();
       			//rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
       			//rs.next();
       			//actionName=rs.getString("ACTIONNAME");
   
       			//rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
       			//rs.next();
       			//oriStatus=rs.getString("STATUSNAME");
   
		       	//rs.close();	
       			//statement.close();
	
	    		historySql=" insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		                   " values(?,?,?,?,?,?,?,?,(select ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+choiceDocNo+"'  and LINE_NO = '"+choiceLine+"'),?,?,?) ";
	    		historystmt=con.prepareStatement(historySql);   
        		historystmt.setString(1,choiceDocNo); 
        		historystmt.setString(2,fromStatusID); 
        		historystmt.setString(3,oriStatus); //寫入status名稱
        		historystmt.setString(4,actionID); 
        		historystmt.setString(5,actionName); 
        		historystmt.setString(6,userID); 
        		historystmt.setString(7,dateBean.getYearMonthDay()); 
        		historystmt.setString(8,dateBean.getHourMinuteSecond());
		        //historystmt.setString(9,prodCodeGet); //寫入產地點編號
        		historystmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
		        historystmt.setString(10,remark);
        		historystmt.setInt(11,deliveryCount);
		
				historystmt.executeUpdate();   
        		historystmt.close(); 
			}   // End of if (k==0)
   
   			//getStatusStat.close();
		   	//getStatusRs.close();  
   			//pstmt.close();  
   
			// 在 For 迴圈內
   			if (actionID.equals("009")) // 若為工廠安排交期確認,若check E-Mail,則取該單據內各被原指派人作為回覆Mail依據清單,
   			{ 
    			if (sendMailOption!=null && sendMailOption.equals("YES"))
    			{  
      				if (k==0) // 若是第一筆,則送E-Mail找歷程清單
      				{	 
         				//String [] mailList = new String[mfgCount+1];  // 宣告大小為指派產地之陣列
	     				String sqlAddList = "select DISTINCT UPDATEUSERID,substr(ARRANGED_DATE,0,8) from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+choiceDocNo+"' and ORISTATUSID='003' ";
	     				//out.println("sqlAddList =:"+sqlAddList);
	     				Statement stateAddList=con.createStatement();
         				ResultSet rsAddList=stateAddList.executeQuery(sqlAddList);
         				while (rsAddList.next())
	     				{		  
	     
	      					Statement stateList=con.createStatement();
	      					String sqlList = "select a.USERMAIL, a.USERNAME from ORADDMAN.WSUSER a,ORADDMAN.TSSPLANER_PERSON b where a.USERNAME = b.USERID and b.USERNAME = '"+rsAddList.getString(1)+"' ";
	      					//out.println("sqlList =:"+sqlList);	
          					ResultSet rsList=stateList.executeQuery(sqlList);
	      					if (rsList.next())
	      					{   //out.println("USERMAIL="+rsList.getString("USERMAIL"));	      
           						sendMailBean.setMailHost(mailHost);
           						sendMailBean.setReception(rsList.getString("USERMAIL"));
		   						//sendMailBean.setReception("kerwin@mail.ts.com.tw");
           						sendMailBean.setFrom(UserName);   	 	 
           						sendMailBean.setSubject(CodeUtil.unicodeToBig5("RFQ System Document Approvement Notification:工廠生管交期安排確認-交貨日期("+rsAddList.getString(2)+")"));	 
           						//sendMailBean.setBody(CodeUtil.unicodeToBig5("Case No.:")+dnDocNo);	
		   						sendMailBean.setUrlName("Dear "+rsList.getString("USERNAME")+",\n"+CodeUtil.unicodeToBig5("   請點擊來自交期詢問系統的郵件:工廠生管交期安排確認-("+choiceDocNo+")-交貨日期("+rsAddList.getString(2)+")"));   	 
           						sendMailBean.setUrlAddr(serverHostName+":8080/oradds/jsp/TSSalesDRQAcceptingPage.jsp?DNDOCNO="+choiceDocNo+"&LINE_NO="+choiceLine);//
           						sendMailBean.sendMail();
	      					}
	      					rsList.close();
	      					stateList.close();
	     				}
	     				rsAddList.close();
	     				stateAddList.close();
	   				}  // End of if (k==0) 		 
	 			} // End of if (sendMailOption!=null && sendMailOption.equals("YES"))
   			} // End of if (actionID=="008") // 工廠安排交期確認
	  	} //end of for (int i=0;i<choice.length;i++)
  
  		// 依次顯示處理完成訊息
  		for (int g=0;g<choice.length;g++)    
  		{ 
     		choiceDocNo = choice[g].substring(0,17);
	 		choiceLine = choice[g].substring(18,choice[g].indexOf("|",18));  // 找第一個 | 之後的 | 
     		out.println("Processing Sales Delivery Request Case (RFQ NO.:<A HREF='TSSalesDRQDisplayPage.jsp?DNDOCNO="+choiceDocNo+"'><font color='#FF0000'>"+choiceDocNo+"</font>&nbsp;Line No.:<FONT COLOR='#000099'>"+choiceLine+"</FONT></A>) OK!<BR>");
  		} 
  		out.println("<BR>");
  		out.println("<A HREF='../OraddsMainMenu.jsp'>");%><jsp:getProperty name="rPH" property="pgHOME"/><%out.println("</A>");   
 	} //end of try
 	catch (Exception e)
 	{
		e.printStackTrace();
   		out.println(e.getMessage());
 	}//end of catch
}  // End of if (choice==null || choice[0].equals(null)) for fileter user don't choosen any item to process // 2004/11/25
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0" >
  <tr>
    <td width="278" nowrap><jsp:getProperty name="rPH" property="pgDRQDocProcess"/></td>
    <td width="297" nowrap><jsp:getProperty name="rPH" property="pgDRQInquiryReport"/></td>   
  </tr>
  <tr>
    <td>
<%
  try  
  {
    out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "D1";    
	Statement statement=con.createStatement();
//    ResultSet rs=statement.executeQuery("select distinct ADDRESS,PROGRAMMERNAME,lineno from RPPROGRAMMER WHERE ROLENAME IN (select ROLENAME from RPGROUPUSERROLE WHERE GROUPUSERID='"+userID+"') AND  MODEL='"+MODEL+"'  order by lineno");    
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
	//out.println("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");
    while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		//out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
		out.println("<tr><td align='center' nowrap><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
      rs.close(); 
	  statement.close();
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch 
  out.println("</table>");     
%>   </td>
    <td><%
  try  
  {
    out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "D2";    
	Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    
    while(rs.next())
    {
      	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		//out.println("<font size=-1><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a><br>");
		out.println("<tr><td align='center' nowrap><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
      rs.close(); 
	  statement.close();
  } //end of try
  catch (Exception e)
  {
	  e.printStackTrace();
      out.println(e.getMessage());
  }//end of catch  
  out.println("</table>");    
%></td>
    
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
