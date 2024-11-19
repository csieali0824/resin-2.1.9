<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20160219 by Peggy,END_CUSTOMER_SHIP_TO_ORG_ID-->
<!--20160309 by Peggy,for sample order add direct_ship_to_cust column-->
<!--20190225 Peggy,add End customer part name-->
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
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%-->
<script language="JavaScript" type="text/JavaScript">
function reProcessFormConfirm(ms1,URL,dnDOCNo,lineNo,assignFact,ordtypeid,linetypeid)
{
	var orginalPage="?DNDOCNO="+dnDOCNo+"&LINE_NO="+lineNo+"&ASSIGN_MANUFACT="+assignFact+"&ORDER_TYPE_ID="+ordtypeid+"&LINE_TYPE="+linetypeid;
    flag=confirm(ms1);      
    if (flag==false) return(false);
	else
    { 
		document.MPROCESSFORM.action=URL+orginalPage;
        document.MPROCESSFORM.submit();
	} 
}

function alertItemExistsMsg(msItemExists)
{
	alert(msItemExists);
}
</script>
<html>
<head>
<title>Sales Delivery Request M Data Process</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--FOR MATERIAL USAGE-->

<jsp:useBean id="array2DGenerateSOrderBean" scope="session" class="Array2DimensionInputBean"/> <!--FOR 業務生成銷售訂單確認-->
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/> <!-- FOR 業務生成銷售訂單確認(其他資訊Notify to Contact) -->
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/> <!-- FOR 業務生成銷售訂單確認(其他資訊Deliver to Contact) -->
<jsp:useBean id="sendMailBean" scope="page" class="SendMailBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSSalesDRQApndMProcess.jsp" METHOD="post" NAME="MPROCESSFORM">
<%
String serverHostName=request.getServerName();
String mailHost=application.getInitParameter("MAIL_HOST"); //由Server的web.xml中取出mail server的host name
String previousPageAddress=request.getParameter("PREVIOUSPAGEADDRESS");
String dnDocNo=request.getParameter("DNDOCNO");
String formID=request.getParameter("FORMID");
String typeNo=request.getParameter("TYPENO");
String isTransmitted=request.getParameter("ISTRANSMITTED");//取得前一頁處理之維修案件是否已後送之FLAG
String fromStatusID=request.getParameter("FROMSTATUSID");
String actionID=request.getParameter("ACTIONID");
String remark=request.getParameter("REMARK");

// 2005/12/03 取session 的Bean 的選取的生管指派指對應代碼 // By Kerwin
String aSalesOrderGenerateCode[][]=array2DGenerateSOrderBean.getArray2DContent();//取得業務訂單生成陣列內容
String aSalesOrderNotifyInfo[]=array2DMOContactInfoBean.getArrayContent(); // 取MO單生成User設定的NotifyTOContact資訊 陣列內容
String aSalesOrderDeliverInfo[]=array2DMODeliverInfoBean.getArrayContent(); // 取MO單生成User設定的DeliverTOContact資訊 陣列內容
// 2004/07/08 取session 的Bean 的選取的維修方式對應代碼 // By Kerwin
String changeProdPersonID=request.getParameter("CHANGEREPPERSONID");
String changeProdPersonMail="";
String sendMailOption=request.getParameter("SENDMAILOPTION");//是否要SEND MAIL
String newDRQOption=request.getParameter("NEWDRQOPTION");//是否要以原單據內容產生新的交期詢問單
String oriStatus=null;
String actionName=null;
String dateString="";
String seqkey="";
String seqno="";
String firmOrderType=request.getParameter("FIRMORDERTYPE");
String firmSoldToOrg=request.getParameter("FIRMSOLDTOORG");
String firmPriceList=request.getParameter("FIRMPRICELIST");
String ShipToOrg=request.getParameter("SHIPTOORG");
String billTo = request.getParameter("BILLTO"); 
String payTermID=request.getParameter("PAYTERMID");
String fobPoint=request.getParameter("FOBPOINT");
String shipMethod=request.getParameter("SHIPMETHOD");
String orgOrder=request.getParameter("ORGORDER");
String orgHeaderID = "";
int lineNo = 1;  // 取得先前MO的LineNo
String line_No=request.getParameter("LINE_NO");
String custPO=request.getParameter("CUST_PO");
String curr=request.getParameter("CURR");
String prCurr=request.getParameter("PRCURR");
String [] choice=request.getParameterValues("CHKFLAG");

String sampleOrder=request.getParameter("SAMPLEORDER");
if (custPO==null) { custPO=""; }
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);;
java.sql.Date orderedDate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Ordered Date
java.sql.Date pricedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Pricing Date
java.sql.Date promisedate = new java.sql.Date(Integer.parseInt(YearFr)-1900,Integer.parseInt(MonthFr)-1,Integer.parseInt(DayFr));  // 給Promise Date     
String sourceTypeCode = "INTERNAL"; 
int lineType = 0;  
String respID = "50124"; // 預設值為 TSC_OM_Semi_SU, 判斷若為 Printer Org 則設定為 TSC_OM_Printer_SU = 50125
String assignLNo = "";
String prodDesc = null;
String prodCodeGet = "";
int prodCodeGetLength = 0;   
String dateCurrent = dateBean.getYearMonthDay();	
try
{ 
	// 先取得下一狀態及狀態描述並作流程狀態更新   
	dateString=dateBean.getYearMonthDay();
  	String sqlStat = "";
  	String whereStat = "";
	//out.println("FORMID="+formID);
  	sqlStat = "select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 ";
  	whereStat ="WHERE FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
     // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
	if (UserRoles.equals("admin")) whereStat = whereStat+"";  //若是管理員,則任何動作不受限制
	else 
	{
		if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereStat = whereStat+"and FORMID='SH' "; // 若是上海內銷辦事處
		else whereStat = whereStat+"and FORMID='TS' "; // 否則一律皆為外銷流程
	}
	 // 2006/04/13加入特殊內銷流程,針對上海內銷_迄		
  	sqlStat = sqlStat+whereStat;
  	//"select TOSTATUSID,STATUSNAME from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFSTATUS x2 WHERE FORMID='"+formID+"' AND FROMSTATUSID='"+fromStatusID+"' AND ACTIONID='"+actionID+"' AND x1.TOSTATUSID=x2.STATUSID and  x1.LOCALE='"+locale+"'";
  	Statement getStatusStat=con.createStatement();  
  	ResultSet getStatusRs=getStatusStat.executeQuery(sqlStat);  
  	getStatusRs.next();
  
  	String sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=? where DNDOCNO='"+dnDocNo+"'";
  	PreparedStatement pstmt=con.prepareStatement(sql);  
 
  	pstmt.setString(1,getStatusRs.getString("TOSTATUSID")); //寫入STATUSID
  	pstmt.setString(2,getStatusRs.getString("STATUSNAME")); //寫入STATUS  
  	pstmt.executeUpdate();
  	pstmt.close();  
  
  	//若有指派人員則找出其e-Mail
  	if (changeProdPersonID!=null)
  	{
    	Statement mailStat=con.createStatement();  
    	ResultSet mailRs=mailStat.executeQuery("select USERMAIL from ORADDMAN.WSUSER where WEBID='"+changeProdPersonID+"'");  
    	if (mailRs.next()) changeProdPersonMail=mailRs.getString("USERMAIL");
		mailRs.close();
		mailStat.close();	
  	}	
  
   	//@@@@@@@@@@取得該使用者隸屬之業務中心資料@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	Statement userSalesStat=con.createStatement();
    ResultSet userSalesRs=userSalesStat.executeQuery("SELECT SALES_AREA_NO,SALES_AREA_NAME,TEL,MOBILE,ZIP,ADDRESS FROM ORADDMAN.TSSALES_AREA WHERE trim(SALES_AREA_NO)='"+userActCenterNo+"'");
    String userSalesAreaName="",userTel="",userCell="",userAddr="",userZIP="";//Zip是電話分機代碼
	if (userSalesRs.next() )
	{
		userSalesAreaName=userSalesRs.getString("SALES_AREA_NAME");	  
	  	userTel=userSalesRs.getString("TEL");
	  	userCell=userSalesRs.getString("MOBILE");
	  	userAddr=userSalesRs.getString("ADDRESS");
	  	userZIP=userSalesRs.getString("ZIP");	  
	}	 	  
	userSalesRs.close();
	userSalesStat.close();
	//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  
	 
	// 	先設定Client Info_起 
  	CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
  	cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
  	cs1.execute();
  	cs1.close();	 
  
  	//若為交期詢問銷售訂單生成附加於舊MO單(APPEND)_起 (ACTION=030)
  	if (actionID.equals("030"))  
  	{
    	//Step1. 先取先前已生成MO單的HEADER_ID_起
		Statement stateORGMO=con.createStatement();
        ResultSet rsORGMO=stateORGMO.executeQuery("select a.HEADER_ID, max(b.LINE_NUMBER) from OE_ORDER_HEADERS_ALL a, OE_ORDER_LINES_ALL b where ORDER_NUMBER='"+orgOrder+"' and a.HEADER_ID = b.HEADER_ID group by a.HEADER_ID ");  
       	if (rsORGMO.next())
        {   
			orgHeaderID = rsORGMO.getString("HEADER_ID");
			lineNo = rsORGMO.getInt(2); // 依批次選擇的舊MO單取得最大的Line Number
      	}
		rsORGMO.close();
		stateORGMO.close();
		 // 先取先前已生成MO單的HEADER_ID_迄
		 
        //  取批次訂單生成批號_起( MG00X200XXXXXXXXX-XXX )	    
        try
        {             
        	dateString=dateBean.getYearMonthDay();     
            if (dnDocNo==null || dnDocNo.equals("--")) seqkey="MG"+userActCenterNo+dateString; //但仍以預設為使用者地區
            else seqkey="MG"+dnDocNo.substring(2,5)+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號   
            //====先取得流水號=====  
            Statement statement=con.createStatement();
            ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");  
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
                String sqlLstNo = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
                ResultSet rs2=statement.executeQuery(sqlLstNo); 
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
	 
	                    String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
                        PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                        seqstmt.setInt(1,lastno_r);   
                        seqstmt.executeUpdate();   
                        seqstmt.close();  
	            	} 
				} 
			} 
      	} 
      	catch (Exception e)
      	{
        	out.println("Exception:"+e.getMessage());
      	}
	  
       	String oraUserID = "";
	   	Statement stateUser=con.createStatement();
        ResultSet rsUser=stateUser.executeQuery("select a.USER_ID from APPS.FND_USER a, APPS.AHR_EMPLOYEES_ALL b where a.EMAIL_ADDRESS = b.EMAIL_ADDRESS(+) and (b.EMPLOYEE_NO = '"+userID+"' or a.USER_NAME = '"+userID+"' or a.USER_NAME = '"+UserName+"' )");
       	if (rsUser.next())
       	{ 
	    	oraUserID = rsUser.getString("USER_ID");
	   	} 
		else 
		{
	    %>
		<script language="javascript">
			alert("No User Authorise in Oracle System");
		</script>
		<%
	    }
	   	rsUser.close();	  	   
	   	stateUser.close(); 
	   
	   	// 為存入日期格式為US考量,將語系先設為美國
	   	sql="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
       	pstmt=con.prepareStatement(sql);
		pstmt.executeUpdate(); 
        pstmt.close();
	   
		int choiceLen = choice.length; // 若有選任一Line作Check才執行下列動作
		if (choiceLen>0)
		{  
	   		if (aSalesOrderGenerateCode!=null)
	   		{     	   
				// 開始針對 Array 內容產生訂單到 Oracle 透過API
			 	String errorMessage = "";
				String errorMessageHeader = "";
			 	String noTPriceMsg = "";
			 	String processStatus="";
			 	String processMsg = "";
			 	int headerID = 0;  // 第一次取得的 Header ID
		 		String orderNo = "";
		 		String notifyContact = null;
		 		String notifyLocation = null;
		 		String shipContact = null;
		 		String deliverOrgID = null;
		 		String deliverContactID = null; 
		 
		    	String warehouseID = "0";
		      	Statement stateWareID=con.createStatement();
			  	ResultSet rsWareID=stateWareID.executeQuery("select ORGANIZATION_ID from ORADDMAN.TSAREA_ORDERCLS where OTYPE_ID = '"+firmOrderType+"' and SAREA_NO = substr('"+dnDocNo+"',3,3) ");
              	if (rsWareID.next())
              	{ 
	           		warehouseID = rsWareID.getString(1);//out.println("warehouseID="+warehouseID);
	          	} 
	          	rsWareID.close();	
   	          	stateWareID.close(); 
		 
		        String orgID = "41";  // 預設的 ORG_ID (2006/12/27)
				Statement stateOrg=con.createStatement();			  
                ResultSet rsOrg=stateOrg.executeQuery("select PAR_ORG_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = substr('"+dnDocNo+"',3,3) ");
				if (rsOrg.next()) orgID = rsOrg.getString("PAR_ORG_ID");
				rsOrg.close();
				stateOrg.close();
		 
		 		// 判斷各訂單類型給定的line Type及 Source Type Code(Oracle Transaction Table --> 
		 		if (firmOrderType=="1132" || firmOrderType.equals("1132")) // Drop Ship
		 		{ 
					sourceTypeCode = "EXTERNAL";
		   			lineType = 1133;
		 		} 
				else if (firmOrderType=="1015" || firmOrderType.equals("1015")) // 1121Order
		        { 
					lineType = 1013; /* S_R_Ship Only */ 
				}
				else if (firmOrderType=="1021" || firmOrderType.equals("1021")) // 1131Order
				{ 
					lineType = 1007; /* S_R_Finished Goods */ 
				}
				else if (firmOrderType=="1091" || firmOrderType.equals("1091")) // 1211Order
				{  
					lineType = 1007; /* S_R_Finished Goods */ 
				}
				else if (firmOrderType=="1022" || firmOrderType.equals("1022")) // 1141Order
				{  
					//lineType = 1007; /* S_R_Finished Goods */
				}
				else if (firmOrderType=="1020" || firmOrderType.equals("1020")) // 1151Order
				{  
					lineType = 1007; /* S_R_Finished Goods */ 
					sourceTypeCode = "EXTERNAL";
				}
				else if (firmOrderType=="1054" || firmOrderType.equals("1054")) // 1161Order
				{ 
					lineType = 1051; /* S_R_Internal Deal */ 
				}
				else if (firmOrderType=="1114" || firmOrderType.equals("1114"))  // 1213Order
				{ 
					lineType = 1113; /* S_R_Forecast_Line */ 
				}
				else if (firmOrderType=="1056" || firmOrderType.equals("1056"))  // 1112Order (半導體交期詢問單)
				{ 
					lineType = 1010; /* S_R_Quotation STD */ 
				}
				else if (firmOrderType=="1161" || firmOrderType.equals("1161"))
				{ 
					lineType = 1158; /* TSC_S_DropShip Standard Order */ 
					sourceTypeCode = "EXTERNAL";
				}
				else if (firmOrderType=="1154" || firmOrderType.equals("1154"))
				{
					sourceTypeCode = "EXTERNAL";
				}
				else 
				{  
					lineType = 1007; /* S_R_Finished Goods */
				} 
													   
		 		if (aSalesOrderGenerateCode!=null)
		 		{ 
					out.println("<BR>");
				%> 
				<jsp:getProperty name="rPH" property="pgSalesOrder"/><jsp:getProperty name="rPH" property="pgGenerateInf"/>		 
				<% 
					out.println("<BR>"); 
				} 
		 
		 		out.println("<table cellSpacing='0' bordercolordark='#66CC99'  cellPadding='1' width='60%' borderColorLight='#ffffff' border='1'>"); 
	   			for (int i=0;i<aSalesOrderGenerateCode.length-1;i++)
       			{
		  			for (int k=0;k<=choice.length-1;k++)    
          			{
		    			// 判斷被Check 的Line 才執行產生訂單作業
		    			if (choice[k]==aSalesOrderGenerateCode[i][0] || choice[k].equals(aSalesOrderGenerateCode[i][0]))
						{
			  				// 若當時料號不存在,則產生訂單此時再取料號Inventory_Item_ID,並更新_起			
			  				if (aSalesOrderGenerateCode[i][7]=="0" || aSalesOrderGenerateCode[i][7].equals("0"))
			  				{       
			       				Statement statGetItemID=con.createStatement();
                   				ResultSet rsGetItemID=null;	
	               				String sqlGetItemID = "select INVENTORY_ITEM_ID,PRIMARY_UOM_CODE from APPS.MTL_SYSTEM_ITEMS where ORGANIZATION_ID = '49' and DESCRIPTION = '"+aSalesOrderGenerateCode[i][1]+"' ";						  								 			  
                   				rsGetItemID=statGetItemID.executeQuery(sqlGetItemID);
	               				if (rsGetItemID.next())
	               				{		             					 
					 				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set INVENTORY_ITEM_ID=?,UOM=?"+			                   
	                     				"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";     
                     				pstmt=con.prepareStatement(sql);
                     				pstmt.setInt(1,Integer.parseInt(rsGetItemID.getString("INVENTORY_ITEM_ID"))); // 更新的Inventory_item_id
					 				pstmt.setString(2,rsGetItemID.getString("PRIMARY_UOM_CODE")); // 更新的Primary_UOM 
					 				pstmt.executeUpdate(); 
                     				pstmt.close(); 		
	               				}	
								else 
								{
				                %>							     
                                	<script language="javascript">
								  		alertItemExistsMsg("<jsp:getProperty name='rPH' property='pgAlertItemExistsMsg'/>");
                                 	</script>							   
                                <%	
							 	}		
	              				rsGetItemID.close();   
	              				statGetItemID.close(); 
			  				} 			  
			
		      				// 取出生管判定產地代碼_起
		      				String packInstructions = "";
			  				String oRequestDate = "";
			  				String oCRequestDate = "";
			  				String oSchShipDate = "";
			  				String oPcAcpDate = "";
			  				String primaryUOM = "KPC"; // 預設的
			  				String orgUOM = "KPC";
			  				float orderQty = Float.parseFloat(aSalesOrderGenerateCode[i][2]); // 預設的訂購數量
			  				String calPriceFlag = "N";
			  
		      				Statement stateMFC=con.createStatement();			  
              				ResultSet rsMFC=stateMFC.executeQuery("select RESP_ID, ALNAME,REQUEST_DATE,PROMISE_DATE,SHIP_DATE,to_char(to_date(PCACPDATE,'YYYYMMDDHH24MISS'),'DD-MON-YYYY') as PCACP_DATE, "+
			                                         "PRIMARY_UOM "+
			                                         "from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,ORADDMAN.TSPROD_MANUFACTORY b "+
													 "where a.DNDOCNO='"+dnDocNo+"' and TO_CHAR(a.LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' "+
													   "and a.ASSIGN_MANUFACT = b.MANUFACTORY_NO and a.PCACPDATE != 'N/A' ");													 
              				if (rsMFC.next())
			  				{ 
			    				packInstructions = rsMFC.getString("ALNAME"); 
								oRequestDate = rsMFC.getString("REQUEST_DATE").substring(0,8);  
								oCRequestDate = rsMFC.getString("PROMISE_DATE").substring(0,8); 
								if (oCRequestDate!=oRequestDate) { oRequestDate = oCRequestDate; }  
				
								oSchShipDate = rsMFC.getString("SHIP_DATE"); 
								if (oSchShipDate.equals("N/A")) { oSchShipDate =oRequestDate; } 
								else { oSchShipDate = oSchShipDate.substring(0,8); }
				
								oPcAcpDate = rsMFC.getString("PCACP_DATE");  // 生管交期排定日
								primaryUOM = rsMFC.getString("PRIMARY_UOM");  // 原單位若為KPC,則改為PCE並乘上1000
								orgUOM = primaryUOM;
								if (primaryUOM==null || primaryUOM.equals(""))
								{  
								}
								else if (primaryUOM.equals("KPC")) 
								{
				  					primaryUOM = "PCE";
				  					orderQty = orderQty *1000; // 若單位若為KPC,則將改為PCE並乘上1000
								} //否則不變原單位及數量		
				
								// 若單據為大陸內銷(業務區012,013)且產地為山東廠,則 Responsibility 取YEW_OM_SEMI_SU
								if (packInstructions.equals("Y") && orgID.equals("325")) 
								{ 
									respID = rsMFC.getString("RESP_ID");  
								}// RESPONSIBILITY_ID ( 50124=TSC_OM_SEMI_SU ; 50795=YEW_OM_SEMI_SU )		
			  				} 
							else 
							{ 
								oSchShipDate = aSalesOrderGenerateCode[i][11].substring(0,8); oRequestDate = aSalesOrderGenerateCode[i][10].substring(0,8); 
							}
			  				rsMFC.close();
			  				stateMFC.close();
			 
			  				// 若使用者有設定客戶料號,則以客戶料號置入 ORDERED_ITEM欄位_起
			  				if (aSalesOrderGenerateCode[i][12]!=null && !aSalesOrderGenerateCode[i][12].equals("N/A") && !aSalesOrderGenerateCode[i][7].equals("0")) // 若客戶料號有給且台半料號ID不為0
			  				{  
								aSalesOrderGenerateCode[i][1] = aSalesOrderGenerateCode[i][12]; 
							}
			  				else  // 否則,把台半料號當成ORDERED_ITEM
			     			{
				   				aSalesOrderGenerateCode[i][1] = aSalesOrderGenerateCode[i][15];
				 			} 
			  
			  				if (aSalesOrderGenerateCode[i][13]==null || aSalesOrderGenerateCode[i][13].equals("") || aSalesOrderGenerateCode[i][13].equals("null") || aSalesOrderGenerateCode[i][13].equals("N/A") ) 
							{ 
								aSalesOrderGenerateCode[i][13]="0"; 
							}			  
			  
			  				if (aSalesOrderGenerateCode[i][14]==null || aSalesOrderGenerateCode[i][14].equals("")) 
							{ 
								aSalesOrderGenerateCode[i][14]="INT"; 
							}
			  				else if (aSalesOrderGenerateCode[i][14].equals("CUSTOMER")) 
							{ 
								aSalesOrderGenerateCode[i][14]="CUST"; 
							}
			  				else if (aSalesOrderGenerateCode[i][14].equals("Customer")) 
							{ 
								aSalesOrderGenerateCode[i][14]="Customer"; 
							}
              				java.sql.Date shipdate = new java.sql.Date(Integer.parseInt(oSchShipDate.substring(0,4))-1900,Integer.parseInt(oSchShipDate.substring(4,6))-1,Integer.parseInt(oSchShipDate.substring(6,8)));  // 給Schedule Ship Date
              				java.sql.Date requestdate = new java.sql.Date(Integer.parseInt(oRequestDate.substring(0,4))-1900,Integer.parseInt(oRequestDate.substring(4,6))-1,Integer.parseInt(oRequestDate.substring(6,8)));  // 給Request Date
			  
			  				if (Float.parseFloat(aSalesOrderGenerateCode[i][8])>0)  //若使用者設定售價,則以售價傳入
              				{
			    				calPriceFlag = "N";
			  				}		
			 
		     				// 取出生管判定產地代碼_迄			 
			 				if (shipMethod==null || shipMethod.equals(""))
			 				{ 
								shipMethod = "N/A"; 
							}   // 2006/01/22  修改若未給出貨方式取預設值			 								
		      	                 							  
							if (aSalesOrderNotifyInfo!=null)
			                {
			                	if (aSalesOrderNotifyInfo[0]!=null && !aSalesOrderNotifyInfo[0].equals("")) notifyContact = aSalesOrderNotifyInfo[0];
				                else notifyContact = "N/A";
				                if (aSalesOrderNotifyInfo[1]!=null && !aSalesOrderNotifyInfo[1].equals("")) notifyLocation = aSalesOrderNotifyInfo[1];
				                else notifyLocation = "N/A";
				                if (aSalesOrderNotifyInfo[2]!=null && !aSalesOrderNotifyInfo[2].equals("")) shipContact = aSalesOrderNotifyInfo[2];
				                else shipContact = "N/A";						      
			                } 
							else 
							{
				            	notifyContact = "N/A";
						        notifyLocation = "N/A";
						        shipContact = "N/A";
				            }
			 
			                if (aSalesOrderDeliverInfo!=null)
			                {
			                	if (aSalesOrderDeliverInfo[1]!=null && !aSalesOrderDeliverInfo[1].equals("")) deliverOrgID = aSalesOrderDeliverInfo[1];
				                else deliverOrgID = "0";
				                if (aSalesOrderDeliverInfo[8]!=null && !aSalesOrderDeliverInfo[8].equals("")) deliverContactID = aSalesOrderDeliverInfo[8];
				                else deliverContactID = "0";
			                } 
							else 
							{
				            	deliverOrgID = "0";
						        deliverContactID = "0";
				            }
				            CallableStatement cs3 = con.prepareCall("{call TSC_OE_ORDER_UPDATE_JSP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 				 
	                        cs3.setString(1,orgID);  /*  Org ID */	
				            cs3.setInt(2,Integer.parseInt(oraUserID)); //out.println("oraUserID="+oraUserID);	  /* User ID */	
				            cs3.setInt(3,Integer.parseInt(respID));  //out.println("respID="+respID); /*  使用的Responsibility ID --> TSC_OM_Semi_SU*/	
				            cs3.setInt(4,Integer.parseInt(firmOrderType));  //out.println("firmOrderType="+firmOrderType); /*  Order Type ID */	
				            cs3.setInt(5,Integer.parseInt(firmSoldToOrg));  //out.println("firmSoldToOrg="+firmSoldToOrg); /*  SoldToOrg */	
				            cs3.setInt(6,Integer.parseInt(firmPriceList));  //out.println("firmPriceList="+firmPriceList); /*  PriceList */	
					        cs3.setInt(7,Integer.parseInt(ShipToOrg));  //out.println("ShipToOrg="+ShipToOrg); /*  Ship To Org */				
					        cs3.setDate(8,orderedDate);  //out.println("orderedDate="+orderedDate); /*  Ordered Date */	
					        cs3.setInt(9,Integer.parseInt(orgHeaderID)); //out.println("orgHeaderID="+orgHeaderID);  /*  更新的  Header Id */
						    cs3.setInt(10,lineNo+1);  //out.println("lineNo="+lineNo+1); /*  增加的  LineNo */
						    cs3.setInt(11,Integer.parseInt(billTo));  //out.println("billTo="+billTo); /*  Bill To Org(Invoice To Org) */ 
				            cs3.setInt(12,Integer.parseInt(payTermID)); //out.println("billTo="+billTo); /*  Payment Term ID */ 
				            cs3.setString(13,shipMethod);  //out.println("shipMethod="+shipMethod);  /*  Shipping Method Code */	
				            cs3.setString(14,fobPoint);   //out.println("fobPoint="+fobPoint); /*  FOB Point Code  */
						    cs3.setString(15,custPO);     //out.println("custPO="+custPO); /*  Customer PO  */
				            cs3.setString(16,"N/A");      /*  Currency Code  */ // 不傳入Currency Code,由Price List自己帶入							  					     
				            cs3.setInt(17,Integer.parseInt(aSalesOrderGenerateCode[i][7]));  //out.println("InventoryItemID="+aSalesOrderGenerateCode[i][7]); /*  InventoryItemID */				
					        cs3.setString(18,aSalesOrderGenerateCode[i][1]);  //out.println("Ordered Item="+aSalesOrderGenerateCode[i][1]);                /*  Ordered Item  可能是客戶料號 */							             
						    cs3.setFloat(19,orderQty);  //out.println("orderQty="+orderQty);   /*  Order Quantity */			
				            cs3.setInt(20,Integer.parseInt(aSalesOrderGenerateCode[i][9]));  //out.println("Line Type="+aSalesOrderGenerateCode[i][9]);  /*  Line Type */				
					        cs3.setDate(21,shipdate);  //out.println("shipdate="+shipdate); /*  Schedule Shup Date */	
					        cs3.setDate(22,requestdate);  //out.println("requestdate="+requestdate); /*  Request Date */	
					        cs3.setDate(23,pricedate);  //out.println("pricedate="+pricedate); /*  Pricing Date */
					        cs3.setDate(24,promisedate);  //out.println("promisedate="+promisedate); /*  Promise Date */					
					        cs3.setString(25,sourceTypeCode); //out.println("sourceTypeCode="+sourceTypeCode);  /*  Source Type Code  */				
				            cs3.setFloat(26,Float.parseFloat(aSalesOrderGenerateCode[i][8])); //out.println("Unit Selling Price="+aSalesOrderGenerateCode[i][8]); /*  Unit Selling Price */	
						    cs3.setString(27,"");  /*  Shipping Instructions發票號  */
				            cs3.setString(28,packInstructions); //out.println("packInstructions="+packInstructions);  /*  Packing Instructions生管判定產地  */	
						    cs3.setString(29,oPcAcpDate);  //out.println("oPcAcpDate="+oPcAcpDate); /*  Attributes8 生管交期排定日  */	
						    cs3.setFloat(30,Float.parseFloat(aSalesOrderGenerateCode[i][8])); //out.println("Unit Selling Price Per Q'ty="+aSalesOrderGenerateCode[i][8]);  /*  Unit Selling Price Per Q'ty */
						    cs3.setString(31,primaryUOM);  //out.println("primaryUOM="+primaryUOM); /*  更改的訂購單位  */			
						    cs3.setInt(32,Integer.parseInt(aSalesOrderGenerateCode[i][13]));  //out.println("客戶料件ID="+aSalesOrderGenerateCode[i][13]); /*  客戶料件ID  */
				            cs3.setString(33,aSalesOrderGenerateCode[i][14]);  //out.println("Item ID Type="+aSalesOrderGenerateCode[i][14]); /*  Item ID Type  */
						    cs3.setString(34,calPriceFlag);  //out.println("calPriceFlag="+calPriceFlag); /*  Calculate Price Flag  */						  
						    cs3.setString(35,"N/A");  /*   Line Attribute1 --> 1211MO單之 Packing List No  */
						    cs3.setString(36,dnDocNo); //out.println("dnDocNo="+dnDocNo);  /*  Header Attribute10 --> 置入交期詢問單號  */
							cs3.setInt(37,Integer.parseInt(warehouseID));  //out.println("warehouseID="+warehouseID); /* line 的 Warehouse ID-->Ship From ID  */
							cs3.setString(38,"N/A");  /*  Header Attribute6 --> 置入I6 subinventory(10)  */
							cs3.setString(39,"N/A");  /*  Line Context --> 置入1211MO 之 Line Context  */
							cs3.setString(40,"N/A");  /*  Attribute4 --> 置入MO 之 Notify To Contact notifyContact */
				            cs3.setString(41,"N/A");  /*  Attribute5 --> 置入MO 之 Notify To Location  notifyLocation */
				            cs3.setString(42,"N/A");  /*  Attribute11 --> 置入MO 之 Ship to Contact shipContact  */
				            cs3.setInt(43,0);  /*  Deliver to Org ID --> 置入MO 之 Deliver To Org ID Integer.parseInt(deliverOrgID) */
				            cs3.setInt(44,0);  /*  Deliver to Contact ID --> 置入MO 之  Deliver To Contact ID  Integer.parseInt(deliverContactID) */
							cs3.setString(45,aSalesOrderGenerateCode[i][16]); //out.println("Line Cust PO Number="+aSalesOrderGenerateCode[i][16]);  /*  Line Cust PO Number  2006/06/06 */
							cs3.setString(46,sampleOrder);  //out.println("sampleOrder="+sampleOrder); /*  Sample OrderFlag  2006/06/12 */
	                        cs3.registerOutParameter(47, Types.VARCHAR); /*  訂單處理訊息 */	
				            cs3.registerOutParameter(48, Types.INTEGER); /*  訂單HEADER ID */					              
				            cs3.registerOutParameter(49, Types.VARCHAR); /*  訂單號碼 */	
				            cs3.registerOutParameter(50, Types.VARCHAR); /*  未成功錯誤訊息 */
	                        cs3.execute();
                            //  out.println("aSalesOrderGenerateCode[i][16]="+aSalesOrderGenerateCode[i][16]);
				            String processStatusLine = cs3.getString(47);
	                        headerID = cs3.getInt(48);				              
				            orderNo = cs3.getString(49);
				            String errorMessageLine = cs3.getString(50);
                            cs3.close();
	     
	                		if (errorMessage==null) { errorMessage = ""; }   
							if (errorMessageLine==null && (processStatusLine=="S" || processStatusLine.equals("S"))) 
							{ 
					     		errorMessageLine = "&nbsp;";
					     		// 依成功內容作資料明細檔之更新(第一筆之後)
				         		sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set OR_LINENO=?, "+
			                        "SASCODATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,ORDERNO=?,SOURCE_TYPE=? "+
	                         		"where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";     
                         		pstmt=con.prepareStatement(sql);
                         		pstmt.setString(1,Integer.toString(lineNo+1)); // 更新的第i筆Oracle OrderLineNo 			             
                         		pstmt.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 設定的業務生成訂單日期 + 時間     
		                 		pstmt.setString(3,userID); // 最後更新人員 
		                 		pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間
		                 		pstmt.setString(5,getStatusRs.getString("TOSTATUSID")); // 本次更新狀態ID 
		                 		pstmt.setString(6,getStatusRs.getString("STATUSNAME")); // 本次更新狀態  
			             		pstmt.setString(7,orderNo); // 寫回產生訂單號
						 		pstmt.setString(8,sourceTypeCode); // sourceType = 'INTERNAL' or 'EXTERNAL'
                         		pstmt.executeUpdate(); 
                         		pstmt.close();	
						 
						 		try
						 		{
						  			CallableStatement cs4 = con.prepareCall("{call TSC_OE_ORDER_SPRICE_UPDATE(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");			 
					      			cs4.setString(1,orgID);                                         //  Org ID 	
					      			cs4.setInt(2,Integer.parseInt(oraUserID)); //out.println("oraUserID="+oraUserID);  // User ID 					 
					      			cs4.setInt(3,Integer.parseInt(respID));  //out.println("respID="+respID);          //  使用的Responsibility ID --> TSC_OM_Semi_SU									 
					      			cs4.setString(4,firmPriceList);  //out.println("firmPriceList="+firmPriceList);    //  Customer Price List						 
					      			cs4.setInt(5,headerID);   //out.println("headerID="+headerID);    //  Order Header ID 	
					      			cs4.setInt(6,lineNo+1);     //out.println("lineNo="+lineNo);                                          //   Order line No 						 
					      			cs4.setInt(7,Integer.parseInt(aSalesOrderGenerateCode[i][7]));  //  Inventory Item ID	
					      			cs4.setDouble(8,Double.parseDouble(aSalesOrderGenerateCode[i][8]));  //  User Selling Price 
						  			cs4.setString(9,dnDocNo);                                            //  RFQ NO 					
						  			cs4.setInt(10,Integer.parseInt(aSalesOrderGenerateCode[i][0])); 	       // RFQ Line No
						  			cs4.setString(11,seqno);  //out.println("seqno="+seqno);                   //  BATCH MO GENERATE NO
						  			cs4.setString(12,processStatus); 	//out.println("processStatus="+processStatus);    // MO 生成時Process Status 為 "S" 的項次
						  			cs4.setString(13,orderNo);        //out.println("orderNo="+orderNo);  // Orginal Order No		
						  			cs4.setString(14,prCurr); 	    //out.println("prCurr="+prCurr);    // 傳入正確幣別		 						 					  		
					      			cs4.registerOutParameter(15, Types.VARCHAR); //  訂單處理訊息 
					      			cs4.registerOutParameter(16, Types.INTEGER); //  訂單HEADER ID 
					      			cs4.registerOutParameter(17, Types.VARCHAR); //  訂單號碼 
					      			cs4.registerOutParameter(18, Types.VARCHAR); //  未成功錯誤訊息 
						  			cs4.registerOutParameter(19, Types.VARCHAR); //  未成功錯誤訊息 
					      			cs4.execute();
					      			processStatus = cs4.getString(15);					
					      			headerID = cs4.getInt(16);   // 把第二次的更新 Header ID 取到<br>					 
					      			orderNo = cs4.getString(17);					 
					      			errorMessageHeader = cs4.getString(18);
						  			noTPriceMsg = cs4.getString(19);
					      			cs4.close();								 
						 			// 成功MO Header寫入,依MO單號改第 k 個Line的單價(Selling Price)_止	
						  			if (noTPriceMsg==null) noTPriceMsg = ""; 			
					   			}	  
				       			catch (Exception e) 
								{
									out.println("Exception:"+e.getMessage()); 
								} 
					 
	   							// 取歷程檔內前一個狀態至目前的時間差,做為本次歷程的工時_起
		      					float processWorkTime = 0;
		      					String preWorkTime = "0"; 			 
		      					Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '008' (客戶確認交期中送出前一狀態為confirmed(008))
              					ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' and ORISTATUSID ='008' ");
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
		        					Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                					ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            					if (rsWTime.next())
		        					{
			    				 		processWorkTime = rsWTime.getFloat(1);
			    					}
			    					rsWTime.close();
			    					stateWTime.close();
			  					}
						 
	                     		int deliveryCount = 0;
	                     		Statement stateDeliveryCNT=con.createStatement(); 
                         		ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ");
	                     		if (rsDeliveryCNT.next())
	                     		{
	                      			deliveryCount = rsDeliveryCNT.getInt(1);
	                     		}
	                     		rsDeliveryCNT.close();
	                     		stateDeliveryCNT.close();

                         		Statement statement=con.createStatement();
                         		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
                         		rs.next();
                         		actionName=rs.getString("ACTIONNAME");
   
                         		rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
                         		rs.next();
                         		oriStatus=rs.getString("STATUSNAME");   
                         		statement.close();
                         		rs.close();	
	
	                     		String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                                          "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	                     		PreparedStatement historystmt=con.prepareStatement(historySql);   
                         		historystmt.setString(1,dnDocNo); 
                         		historystmt.setString(2,fromStatusID); 
                         		historystmt.setString(3,oriStatus); //寫入status名稱
                         		historystmt.setString(4,actionID); 
                         		historystmt.setString(5,actionName); 
                         		historystmt.setString(6,userID); 
                         		historystmt.setString(7,dateBean.getYearMonthDay()); 
                         		historystmt.setString(8,dateBean.getHourMinuteSecond());
                         		historystmt.setString(9,prodCodeGet); //寫入工廠編號
                         		historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
                         		historystmt.setString(11,remark);
                         		historystmt.setInt(12,deliveryCount);
		                 		historystmt.setInt(13,Integer.parseInt(aSalesOrderGenerateCode[i][0])); // 寫入處理Line_No
		                 		historystmt.setFloat(14,processWorkTime);
		
		                 		historystmt.executeUpdate();   
                         		historystmt.close(); 
								
								if (aSalesOrderNotifyInfo!=null && aSalesOrderDeliverInfo!=null && notifyContact!="N/A")
			            		{
						     		String sqlUMO="update APPS.OE_ORDER_HEADERS_ALL set ATTRIBUTE4=? ";
							 		if (notifyLocation!="N/A") sqlUMO = sqlUMO+ ",ATTRIBUTE5=?,TP_ATTRIBUTE5=? ";
							 		if (shipContact!="N/A") sqlUMO = sqlUMO+ ",ATTRIBUTE11=?,TP_ATTRIBUTE11=? ";
		                     		sqlUMO=sqlUMO+"where to_char(ORDER_NUMBER) = '"+orderNo+"' ";
	                         		PreparedStatement stmtUMP=con.prepareStatement(sqlUMO); 
								 	stmtUMP.setString(1,notifyContact);
								 	if (notifyLocation!="N/A")
								 	{
								  		stmtUMP.setString(2,notifyLocation);
								  		stmtUMP.setString(3,notifyLocation);
								 	} 
								 	if (shipContact!="N/A")
								 	{
								  		stmtUMP.setString(4,shipContact); // 寫入處理Line_No
								  		stmtUMP.setString(5,shipContact);		
								 	} 
								 	stmtUMP.executeUpdate();   
								 	stmtUMP.close();  
								}  
				      		}
					  		if (k==0)
					  		{
					    		if (processStatus.equals("S")) processMsg = "MO Append Success!!!"; 
								else 
								{    
									processMsg = "MO Append Fail!!!";  
								}
					    		out.println("<TR bgcolor='#FFFFCC'><TD colspan=2><font color='#000099'>Process Status</FONT></TD><TD colspan=4>"+processStatus+"<font color='#000099'>("+processMsg+")</font></TD></TR>");
					    		out.println("<TR><TD><font color='#000099'>Header ID</FONT></TD><TD><font color='#000099'>"+headerID+"</FONT></TD><TD><font color='#000099'>Order No</FONT></TD><TD colspan=3><font color='#000099'>"+orderNo+"</FONT></TD></TR>");
					  		}
					  		out.println("<TR bgcolor='#CCFFCC'><TD><font color='#000099'>Line No.</FONT></TD><TD><font color='#000099'>Inventory Item ID</FONT></TD><TD><font color='#000099'>Inventory Item</FONT></TD><TD><font color='#000099'>Order Q'ty</FONT></TD><TD><font color='#000099'>Line Status</FONT></TD><TD><font color='#000099'>Error Message</FONT></TD></TR>");					 
					  		out.println("<TR><TD><font color='#000099'>"+lineNo+"</FONT></TD><TD><font color='#000099'>"+aSalesOrderGenerateCode[i][7]+"</FONT></TD><TD><font color='#000099'>"+aSalesOrderGenerateCode[i][1]+"</FONT></TD><TD><font color='#000099'>"+aSalesOrderGenerateCode[i][2]+"</FONT></TD><TD><font color='#000099'>"+processStatusLine+"</FONT></TD><TD><font color='#FF3300'>"+errorMessageLine+noTPriceMsg+"</FONT></TD></TR>");				 
		     				lineNo++; 		
		   				} 
		  			} 
	    		}
	  			out.println("</table>");
	  			out.println("<BR>");	 
	  
       			if((errorMessageHeader==null || errorMessageHeader.equals("") || errorMessageHeader.equals("&nbsp;")) && (processStatus=="S" || processStatus.equals("S")))     // 訂單第一筆細項產生沒有ErrorMessage ,才執行  
	   			{
		   			Statement statement=con.createStatement();
           			ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
           			rs.next();
           			actionName=rs.getString("ACTIONNAME");
   
           			rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
           			rs.next();
           			oriStatus=rs.getString("STATUSNAME");   
           			statement.close();
           			rs.close();	   
	   
	       			String thisStatusID = "N/A";
	       			String thisStatus = "N/A";
	       			Statement stateLStatus=con.createStatement(); 
           			ResultSet rsLStatus=stateLStatus.executeQuery("select LSTATUSID from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID='N/A' ");
           			if (rsLStatus.next()) 
	       			{
	         			thisStatusID = fromStatusID; // 如果詢問單明細還存在部份狀態為 "N/A" 的未生成訂單,則詢問單主檔狀態便不更新為 "COMPLETE"
		     			thisStatus = oriStatus;      // 回朔至前一狀態
	       			} 
					else 
					{
	                	thisStatusID =getStatusRs.getString("TOSTATUSID");
				    	thisStatus =getStatusRs.getString("STATUSNAME"); 	            
	              	}    
	       
	       			// 詢問單主檔更新	  
	       			sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=?,ORDER_TYPE_ID=?,SOLD_TO_ORG=?,PRICE_LIST=?,SHIP_TO_ORG=?,"+
		       			"BILL_TO_ORG=?,PAYTERM_ID=?,SHIPMETHOD=?,FOB_POINT=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	           			"where DNDOCNO='"+dnDocNo+"' ";     
           			pstmt=con.prepareStatement(sql);
	       			pstmt.setString(1,thisStatusID);  // 原狀態ID      
           			pstmt.setString(2,thisStatus); // 原狀態
	       			pstmt.setInt(3,Integer.parseInt(firmOrderType)); // Order Type ID
           			pstmt.setInt(4,Integer.parseInt(firmSoldToOrg)); // Sold To Org       
           			pstmt.setInt(5,Integer.parseInt(firmPriceList)); // Price List
	       			pstmt.setInt(6,Integer.parseInt(ShipToOrg)); // Ship To Org
		  			pstmt.setInt(7,Integer.parseInt(billTo)); //  BILL TO ID
		   			pstmt.setString(8,payTermID); // Payment Term ID 
		   			pstmt.setString(9,fobPoint);  // FOB Point Code
		   			pstmt.setString(10,shipMethod); // Shipping Method		   
	       			pstmt.setString(11,userID); // 最後更新人員
	       			pstmt.setString(12,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間    
           			pstmt.executeUpdate(); 
           			pstmt.close(); 	
	  			} 
	  			else 
				{
	          		out.println("<BR>");
			  		out.println("Sales Order create fail , No action happened in this case ! ");  			   
	      	 	}	  
			}  
			else
			{ 
				Statement statement=con.createStatement();
           		ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
           		rs.next();
           		actionName=rs.getString("ACTIONNAME");
   
           		rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
           		rs.next();
           		oriStatus=rs.getString("STATUSNAME");   
           		statement.close();
           		rs.close();	   
	   
	       		String oldStatusID = "N/A";
	       		String oldStatus = "N/A";
	       		Statement stateLStatus=con.createStatement(); 
           		ResultSet rsLStatus=stateLStatus.executeQuery("select LSTATUSID from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and ORDERNO='N/A' ");
           		if (rsLStatus.next()) 
	       		{
	         		oldStatusID = fromStatusID; // 如果詢問單明細還存在部份狀態為 "N/A" 的未生成訂單,則詢問單主檔狀態便不更新為 "COMPLETE"
		     		oldStatus = oriStatus;      // 回朔至前一狀態
	       		} 
				else 
				{
	            	oldStatusID =getStatusRs.getString("TOSTATUSID");
				    oldStatus =getStatusRs.getString("STATUSNAME"); 	            
	            } 
		  		// 沒有任何訂單被產生,故詢問單主檔狀態RollBack至前一個狀態	  
	       		sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	           		"where DNDOCNO='"+dnDocNo+"' ";     
           		pstmt=con.prepareStatement(sql);
	       		pstmt.setString(1,oldStatusID);  // 原狀態ID      
           		pstmt.setString(2,oldStatus); // 原狀態	      
	       		pstmt.setString(3,userID); // 最後更新人員
	       		pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間    
           		pstmt.executeUpdate(); 
           		pstmt.close(); 
			} 
	 		out.println("<BR>");   
		}
		else 
		{
	    	Statement statement=con.createStatement();
           	ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
           	rs.next();
           	actionName=rs.getString("ACTIONNAME");
   
           	rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
           	rs.next();
           	oriStatus=rs.getString("STATUSNAME");   
           	statement.close();
           	rs.close();	   
	   
	       	String oldStatusID = "N/A";
	       	String oldStatus = "N/A";
	       	Statement stateLStatus=con.createStatement(); 
           	ResultSet rsLStatus=stateLStatus.executeQuery("select LSTATUSID from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and ORDERNO='N/A' ");
           	if (rsLStatus.next()) 
	       	{
	        	oldStatusID = fromStatusID; // 如果詢問單明細還存在部份狀態為 "N/A" 的未生成訂單,則詢問單主檔狀態便不更新為 "COMPLETE"
		     	oldStatus = oriStatus;      // 回朔至前一狀態
	       	} 
			else 
			{
	        	oldStatusID =getStatusRs.getString("TOSTATUSID");
				oldStatus =getStatusRs.getString("STATUSNAME"); 	            
	        } 
		  	// 沒有任何訂單被產生,故詢問單主檔狀態RollBack至前一個狀態	  
	       	sql="update ORADDMAN.TSDELIVERY_NOTICE set STATUSID=?,STATUS=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=? "+
	           "where DNDOCNO='"+dnDocNo+"' ";     
           	pstmt=con.prepareStatement(sql);
	       	pstmt.setString(1,oldStatusID);  // 原狀態ID      
           	pstmt.setString(2,oldStatus); // 原狀態	      
	       	pstmt.setString(3,userID); // 最後更新人員
	       	pstmt.setString(4,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間    
           	pstmt.executeUpdate(); 
           	pstmt.close();       
		}
	 
	 	//完成處理後即將session取到的Bean 的內容值清空(避免二次傳送) 
	 	if (aSalesOrderGenerateCode!=null)
	 	{ 
			array2DGenerateSOrderBean.setArray2DString(null); 
		}	 
	 
	 	Statement stateReProcess=con.createStatement(); 
     	ResultSet rsReProcess=stateReProcess.executeQuery("select LINE_NO,ASSIGN_MANUFACT from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO='"+dnDocNo+"' and LSTATUSID='009' ");  // 取任一筆未處理RFQ單據做訂單生成的Line_No及分派產地
	 	if (rsReProcess.next())
	 	{
	  		String reLineNo = rsReProcess.getString("LINE_NO");
	  		String reAssignManufact = rsReProcess.getString("ASSIGN_MANUFACT");
	 
	 		%>
	   		<script LANGUAGE="JavaScript">
	       		reProcessFormConfirm("<jsp:getProperty name='rPH' property='pgAlertReProcessMsg'/>","../jsp/TSSalesDRQGeneratingPage.jsp","<%=dnDocNo%>","<%=reLineNo%>","<%=reAssignManufact%>","<%=firmOrderType%>","<%=lineType%>");
	   		</script>
	 		<%
	 	}
	 	rsReProcess.close();
	 	stateReProcess.close();	 
	 
	  	// 為存入日期格式為US考量,將語系先設為美國
	    sql="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
        pstmt=con.prepareStatement(sql);
		pstmt.executeUpdate(); 
        pstmt.close();
	} 
  
  	if (actionID.equals("013")) 
  	{
    	if (aSalesOrderGenerateCode!=null) // 判斷該次處理細項才更新明細檔
	 	{
	    	dateString=dateBean.getYearMonthDay();
          	//seqkey="TS"+userActCenterNo+dateString;
		  	//抓原單據前五碼(因為一個帳號會有一個以上site)modify by Peggy 20120910
		  	seqkey=dnDocNo.substring(0,5)+dateString;
          	//====先取得流水號=====  
          	Statement statement=con.createStatement();
          	ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");  
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
      
            	sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
            	ResultSet rs2=statement.executeQuery(sql); 
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
	 
	             		String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";   
                 		PreparedStatement seqstmt=con.prepareStatement(seqSql);        
                 		seqstmt.setInt(1,lastno_r);   
	
                 		seqstmt.executeUpdate();   
                 		seqstmt.close();  
	          		}
            	} 
		 
				int newLine =1; 		
	    		for (int i=0;i<aSalesOrderGenerateCode.length-1;i++)
	    		{  
		  			for (int k=0;k<=choice.length-1;k++)    
          			{
	        			if (choice[k]==aSalesOrderGenerateCode[i][0] || choice[k].equals(aSalesOrderGenerateCode[i][0]))
	        			{ 
	           				sql="update ORADDMAN.TSDELIVERY_NOTICE_DETAIL set REREQUEST_DATE=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=?,LSTATUSID=?,LSTATUS=?,EDIT_CODE=? "+
	                            "where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";     
               				pstmt=con.prepareStatement(sql);
		      				if (aSalesOrderGenerateCode[i][6].equals("N/A")) aSalesOrderGenerateCode[i][6] = aSalesOrderGenerateCode[i][4]; // 若業務未重新給定新的交期需求日,則以原需求日作為新交期需求日
               				pstmt.setString(1,aSalesOrderGenerateCode[i][6]); // 設定的客戶新交期需求日期    
		       				pstmt.setString(2,userID); // 最後更新人員 
		       				pstmt.setString(3,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); // 最後更新時間 
		       				pstmt.setString(4,getStatusRs.getString("TOSTATUSID")); // Line 的狀態ID
		       				pstmt.setString(5,getStatusRs.getString("STATUSNAME")); // Line 的狀態
			   				pstmt.setString(6,"N/A"); // 回覆EDIT_CODE的原狀態  
               				pstmt.executeUpdate(); 
               				pstmt.close();    
		   

		      				float processWorkTime = 0;
		      				String preWorkTime = "0"; 			 
		      				Statement stateHProcWT=con.createStatement();  // ORISTATUSID = '003' (客戶放棄交期詢單送出前一狀態為RESPONDING(007))
              				ResultSet rsHProcWT=stateHProcWT.executeQuery("select CDATETIME from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' and ORISTATUSID ='007' ");
	          				if (rsHProcWT.next())
		      				{
			     				preWorkTime = rsHProcWT.getString(1);
			  				}
			  				rsHProcWT.close();
			 				stateHProcWT.close();
		    
							if (preWorkTime!="0")
		    				{
			    				String sqlWT = "select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+preWorkTime+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ";
		        				Statement stateWTime=con.createStatement();  // ORISTATUSID = '001' (草稿文件前一狀態仍為草稿文件)
                				ResultSet rsWTime=stateWTime.executeQuery(sqlWT);
	            				if (rsWTime.next())
		        				{
			     					processWorkTime = rsWTime.getFloat(1);
			   	 				}
			    				rsWTime.close();
			   	 				stateWTime.close();
							}
	                     
						 	int deliveryCount = 0;
	                     	Statement stateDeliveryCNT=con.createStatement(); 
                         	ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where DNDOCNO='"+dnDocNo+"' and TO_CHAR(LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ");
	                     	if (rsDeliveryCNT.next())
	                     	{
	                      		deliveryCount = rsDeliveryCNT.getInt(1);
	                     	}
	                     	rsDeliveryCNT.close();
	                     	stateDeliveryCNT.close();

                         	Statement state013=con.createStatement();
                         	ResultSet rs013=state013.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
                         	rs013.next();
                         	actionName=rs013.getString("ACTIONNAME");
   
                         	rs013=state013.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
                         	rs013.next();
                         	oriStatus=rs013.getString("STATUSNAME");
   
                         	state013.close();
                         	rs013.close();	
	
	                     	String historySql="insert into ORADDMAN.TSDELIVERY_DETAIL_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW,LINE_NO,PROCESS_WORKTIME) "+
		                                      "values(?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
	                     	PreparedStatement historystmt=con.prepareStatement(historySql);   
                         	historystmt.setString(1,dnDocNo); 
                         	historystmt.setString(2,fromStatusID); 
                         	historystmt.setString(3,oriStatus); //寫入status名稱
                         	historystmt.setString(4,actionID); 
                         	historystmt.setString(5,actionName); 
                         	historystmt.setString(6,userID); 
                         	historystmt.setString(7,dateBean.getYearMonthDay()); 
                         	historystmt.setString(8,dateBean.getHourMinuteSecond());
                         	historystmt.setString(9,prodCodeGet); //寫入工廠編號
                         	historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
                         	historystmt.setString(11,remark);
                         	historystmt.setInt(12,deliveryCount);
		                 	historystmt.setInt(13,Integer.parseInt(aSalesOrderGenerateCode[i][0])); // 寫入處理Line_No
		                 	historystmt.setFloat(14,processWorkTime);		
		                 	historystmt.executeUpdate();   
                         	historystmt.close(); 
		
		 					if (newDRQOption!=null && newDRQOption.equals("YES")) // 若使用者選擇要以原單據內容產生新的交期詢問單
         					{ 		   
		   						if (k==0)
		   						{
				 					sql="insert into ORADDMAN.TSDELIVERY_NOTICE(DNDOCNO,TSAREANO,REQPERSONID,REQREASON,TSCUSTOMERID,CUSTOMER,CUST_PO,"+
					 				"CURR,REQUIRE_DATE,REMARK,STATUSID,STATUS,CREATED_BY,TOPERSONID,ORDER_TYPE_ID,SOLD_TO_ORG,PRICE_LIST,SHIP_TO_ORG,"+
					 				"SALESPERSON,BILL_TO_ORG,LAST_UPDATE_DATE,LAST_UPDATED_BY,ORIDOCNO "+
					 				",AUTOCREATE_FLAG,PAYTERM_ID,FOB_POINT,RFQ_TYPE,SAMPLE_ORDER,SAMPLE_CHARGE,TAX_CODE "+ //add TAX_CODE by Peggy 20130411
									",SHIP_TO_CONTACT_ID)"+ //add by Peggy 20190104 
					 				" select '"+seqno+"',a.TSAREANO,a.REQPERSONID,a.REQREASON,a.TSCUSTOMERID,a.CUSTOMER,"+
					 				"(select CUST_PO_NUMBER from ORADDMAN.TSDELIVERY_NOTICE_DETAIL b where b.DNDOCNO=a.DNDOCNO and TO_CHAR(b.LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"'),"+
					 				"CURR,'"+aSalesOrderGenerateCode[i][6]+"','"+ remark+"','001','CREATING','"+userID+"',a.TOPERSONID,a.ORDER_TYPE_ID,"+
					 				"a.SOLD_TO_ORG,a.PRICE_LIST,a.SHIP_TO_ORG,a.SALESPERSON,a.BILL_TO_ORG,'"+
					 				dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','"+userID+"',a.DNDOCNO,a.AUTOCREATE_FLAG,a.PAYTERM_ID,a.FOB_POINT,a.RFQ_TYPE,a.SAMPLE_ORDER,a.SAMPLE_CHARGE,a.TAX_CODE,a.SHIP_TO_CONTACT_ID "+
					 				" from ORADDMAN.TSDELIVERY_NOTICE a "+
					 				" where a.DNDOCNO='"+dnDocNo+"' "; 											
				 					pstmt=con.prepareStatement(sql);          
				 					pstmt.executeUpdate();   
				 					pstmt.close();	
		   						}
			
								// 再產生新的單據細項
								sql="insert into ORADDMAN.TSDELIVERY_NOTICE_DETAIL(DNDOCNO,LINE_NO,INVENTORY_ITEM_ID,ITEM_SEGMENT1,QUANTITY,UOM,"+
									"LIST_PRICE,REQUEST_DATE,LINE_TYPE,PRIMARY_UOM,REMARK,CREATED_BY,LSTATUSID,LSTATUS,ITEM_DESCRIPTION,LAST_UPDATE_DATE,"+
									"LAST_UPDATED_BY,CUST_REQUEST_DATE,SHIPPING_METHOD "+ //CUST_REQUEST_DATE,SHIPPING_METHOD add by Peggy 20120117
									",AUTOCREATE_FLAG,ORDERED_ITEM,ORDERED_ITEM_ID,ITEM_ID_TYPE,CUST_PO_NUMBER,SELLING_PRICE,PROGRAM_NAME,TSC_PROD_GROUP "+//add by Peggy 20120328
									",CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER"+ //add by Peggy 20121107
									",END_CUSTOMER_ID "+ //add by Peggy 20140813
									",ORIG_SO_LINE_ID"+ //add by Peggy 20150519
									",DIRECT_SHIP_TO_CUST"+ //add by Peggy 20160309
									",BI_REGION"+           //add by Peggy 20170927
									",END_CUSTOMER_PARTNO"+  //add by Peggy 20190225
									",SUPPLIER_NUMBER)"+  //add SUPPLIER_NUMBER by Peggy 20220428
									" select '"+seqno+"','"+newLine+"',a.INVENTORY_ITEM_ID,a.ITEM_SEGMENT1,a.QUANTITY,a.UOM,a.LIST_PRICE,'"+aSalesOrderGenerateCode[i][6]+"',a.LINE_TYPE,"+
									" a.PRIMARY_UOM,a.REMARK,'"+userID+"','001','CREATING',a.ITEM_DESCRIPTION,'"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()
									+"','"+userID+"',a.CUST_REQUEST_DATE,a.SHIPPING_METHOD "+
									",b.AUTOCREATE_FLAG,a.ORDERED_ITEM,a.ORDERED_ITEM_ID, a.ITEM_ID_TYPE,a.CUST_PO_NUMBER,a.SELLING_PRICE,'D1-007I',a.TSC_PROD_GROUP "+ //add by Peggy 20120307
									",a.CUST_PO_LINE_NO,QUOTE_NUMBER,END_CUSTOMER"+ //add by Peggy 20121107
									",a.END_CUSTOMER_ID"+ //add by Peggy 20140813
									",a.orig_so_line_id"+ //add by Peggy 20150519
									",a.DIRECT_SHIP_TO_CUST"+ //add by Peggy 20160309
									",a.BI_REGION"+            //add by Peggy 20170927
									",a.END_CUSTOMER_PARTNO"+  //add by Peggy 20190225
									",a.SUPPLIER_NUMBER"+  //add SUPPLIER_NUMBER by Peggy 20220428
									" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a,ORADDMAN.TSDELIVERY_NOTICE b where a.DNDOCNO = b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"' and TO_CHAR(a.LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";
								//out.println(sql);
								pstmt=con.prepareStatement(sql);          
								pstmt.executeUpdate();   
								pstmt.close();

								//add by Peggy 20130815
								sql = " insert into oraddman.tsdelivery_notice_remarks"+
									  "(dndocno,"+
									  " line_no,"+
									  " customer,"+
									  " shipping_marks,"+
									  " remarks,"+
									  " creation_date,"+
									  " created_by,"+
									  " last_update_date,"+
									  " last_updated_by)"+
									  " SELECT '"+seqno+"','"+newLine+"', a.customer, a.shipping_marks, a.remarks, sysdate,'"+UserName+"', sysdate,'"+UserName+"' "+
									  " FROM oraddman.tsdelivery_notice_remarks a where a.DNDOCNO='"+dnDocNo+"' "+
									  " and TO_CHAR(a.LINE_NO)='"+aSalesOrderGenerateCode[i][0]+"' ";
								pstmt=con.prepareStatement(sql);          
								pstmt.executeUpdate();   
								pstmt.close();
		  					}
		   
		   					newLine++; 
		 				} 
					}
	  			}
	 		}
	
	 		if (aSalesOrderGenerateCode!=null)  
     		{ 
				array2DGenerateSOrderBean.setArray2DString(null);  
			}
  		} 
   
   		//執行sendMail動作
   		if (sendMailOption!=null && sendMailOption.equals("YES"))
   		{
     		sendMailBean.setMailHost(mailHost);
     		sendMailBean.setReception(changeProdPersonMail);
     		sendMailBean.setFrom(UserName);
     		sendMailBean.setSubject(CodeUtil.unicodeToBig5("Assignment from the Sales Delivery Request System"));	 
     		sendMailBean.setBody(CodeUtil.unicodeToBig5("Case No.:")+dnDocNo);	
	 		if (typeNo.equals("001")) //區別一般維修及DOA/DAP件
	 		{
       			sendMailBean.setUrlAddr(serverHostName+"/oradds/jsp/TSSalesEstimatingPage.jsp?DNDOCNO="+dnDocNo);
	 		}    
     		sendMailBean.sendMail();
   		}
  	} 
   	
	int deliveryCount = 0;
	Statement stateDeliveryCNT=con.createStatement(); 
    ResultSet rsDeliveryCNT=stateDeliveryCNT.executeQuery("select count(*)+1 from ORADDMAN.TSDELIVERY_HISTORY where DNDOCNO='"+dnDocNo+"' ");
	if (rsDeliveryCNT.next())
	{
		deliveryCount = rsDeliveryCNT.getInt(1);
	}
	rsDeliveryCNT.close();
	stateDeliveryCNT.close();

    Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSWFACTION where ACTIONID='"+actionID+"'");
    rs.next();
    actionName=rs.getString("ACTIONNAME");
   
    rs=statement.executeQuery("select * from ORADDMAN.TSWFStatus where STATUSID='"+fromStatusID+"'");
    rs.next();
    oriStatus=rs.getString("STATUSNAME");
   
    statement.close();
    rs.close();	
	
	String historySql="insert into ORADDMAN.TSDELIVERY_HISTORY(DNDOCNO,ORISTATUSID,ORISTATUS,ACTIONID,ACTIONNAME,UPDATEUSERID,UPDATEDATE,UPDATETIME,ASSIGN_FACTORY,CDATETIME,REMARK,SERIALROW) "+
		                  "values(?,?,?,?,?,?,?,?,?,?,?,?) ";
	PreparedStatement historystmt=con.prepareStatement(historySql);   
    historystmt.setString(1,dnDocNo); 
    historystmt.setString(2,fromStatusID); 
    historystmt.setString(3,oriStatus); //寫入status名稱
    historystmt.setString(4,actionID); 
    historystmt.setString(5,actionName); 
    historystmt.setString(6,userID); 
    historystmt.setString(7,dateBean.getYearMonthDay()); 
    historystmt.setString(8,dateBean.getHourMinuteSecond());
    historystmt.setString(9,prodCodeGet); //寫入工廠編號
    historystmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
    historystmt.setString(11,remark); // 本次處理說明欄位
    historystmt.setInt(12,deliveryCount);		
	historystmt.executeUpdate();   
    historystmt.close(); 

  	out.println("<BR>Processing Sales Delivery Request value(RFQ NO.:<A HREF='TSSalesDRQDisplayPage.jsp?DNDOCNO="+dnDocNo+"'><font color=#FF0000>"+dnDocNo+"</font></A>) OK!");
  
  	if (actionID.equals("013")) //若為客戶放棄交期詢問單(ABORT)則再執行以下動作
  	{
    	if (newDRQOption!=null && newDRQOption.equals("YES")) // 若使用者選擇要以原單據內容產生新的交期詢問單
     	{ 	
       		out.println("<BR>&nbsp;<A HREF='TSSalesDRQTemporaryPage.jsp?DNDOCNO="+seqno+"&LSTATUSID=001'>");%><<jsp:getProperty name="rPH" property="pgRefresh"/>><jsp:getProperty name="rPH" property="pgSalesDRQ"/><%out.println("("+seqno+")</A><BR>"); 
	 	}
 	}
  	out.println("<BR>");
  	out.println("<A HREF='../OraddsMainMenu.jsp'>");%><font size="2"><jsp:getProperty name="rPH" property="pgHOME"/></font><%out.println("</A>");
   
  	getStatusStat.close();
  	getStatusRs.close();  
  	pstmt.close();       
} //end of try
catch (Exception e)
{
	e.printStackTrace();
   	out.println(e.getMessage());
}//end of catch
%>

<table width="60%" border="1" cellpadding="0" cellspacing="0">
  <tr>
    <td width="278"><font size="2"><jsp:getProperty name="rPH" property="pgDRQDocProcess"/></font></td>
    <td width="297"><font size="2"><jsp:getProperty name="rPH" property="pgDRQInquiryReport"/></font></td>    
  </tr>
  <tr>   
    <td>
<%
try  
{ 
	out.println("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
    String MODEL = "D1";    
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("SELECT DISTINCT FDESC,FSEQ,FADDRESS FROM ORADDMAN.MENUFUNCTION,ORADDMAN.WSPROGRAMMER WHERE FMODULE='"+MODEL+"' AND FLAN=(SELECT LOCALE_SHT_NAME FROM ORADDMAN.WSLOCALE WHERE LOCALE='"+locale+"') AND FSHOW=1 AND FFUNCTION=ADDRESSDESC AND ROLENAME IN (select ROLENAME from ORADDMAN.WSGROUPUSERROLE WHERE GROUPUSERNAME='"+UserName+"') ORDER BY FSEQ ");    	
    while(rs.next())
    {
    	String ADDRESS = rs.getString("FADDRESS");
		String PROGRAMMERNAME= rs.getString("FDESC");
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td>");
	}
    rs.close(); 
	statement.close();
} 
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}
out.println("</table>");   
%>   
 </td> 
 <td>
 <%
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
		out.println("<tr><td align='center'><img name='FOLDER' src='../image/RFQJSP_folder.gif' border='0'></td><td align='left'><font size=2><a href="+ ADDRESS +">"+PROGRAMMERNAME+"</a></font></td><td>");
	}
    rs.close(); 
	statement.close();
} //end of try
catch (Exception e)
{
	e.printStackTrace();
    out.println(e.getMessage());
}
out.println("</table>");  
%></td>    
  </tr>
</table>
</FORM>
</body>
<!--%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
