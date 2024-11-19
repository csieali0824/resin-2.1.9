<!-- 20161219 liling 增加organization id=606 直接入庫的部份 -->
<!-- 20170515 liling 修改organization id=606 直接入庫改分階段入庫 -->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,jxl.*,jxl.write.*,jxl.format.*,WorkingDateBean,java.lang.Math.*" %>
<%@ page import="java.io.*,DateBean" %>
<%@ page import="com.jspsmart.upload.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->

<html>
<head>
<title>Insert UploadFile into Database</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />

<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>

<script language="JavaScript" type="text/JavaScript">
function subWinRcvLotInfo(iRcvId,ilocationId)
{ 
	//subWin=window.open("../jsp/subwindow/TSCSubInventoryFind.jsp?ORGANIZATIONID="+organizationID+"&SUBINVENTORY="+subInv+"&SUBINVDESC="+subInvDesc,"subwin","width=640,height=480,status=yes,locatin=yes,toolbar=yes,directories=yes,menubar=yes,scrollbar=yes,resizable=yes");  
  	subWin=window.open("../jsp/TSCPoReceiptInsert.jsp?PTYPE=5&RCV_ID="+iRcvId+"&LOCATIONID="+ilocationId,"subwin","top=0,left=300,width=640,height=480,status=yes,scrollbars=yes,menubar=no");  
}

function setDataReset(URL)
{  
	alert("資料清空!!!");
   	document.MYFORM.action=URL;
   	document.MYFORM.submit();
}

function setDataUpload(URL)
{ //alert();
	document.MYFORM.action=URL;
   	document.MYFORM.submit();
}

</script>
<body>
<A HREF="../jsp/TSCPoReceiptUpload.jsp?RCV_ID=">上一頁</A>
<FORM NAME="MYFORM" onsubmit='return submitCheck("是","否")' ACTION="../jsp/TSCPoReceiptInsert.jsp" METHOD="post">
<%


int iRcvId=0,loginUserId=0,errCount=0;

String updateFlag = request.getParameter("UPDATEFLAG");       //判斷是否按了更新資料庫BUTTON
String dataError = request.getParameter("DATAERROR");        // 判斷資料是否有誤 Y / N
String pType = request.getParameter("PTYPE");   //1:傳入TEMP TABLW ,2:處理顯示 3:轉入ERP 4:放棄上傳ERP
String rcvId =request.getParameter("RCV_ID"); 
String locationId=request.getParameter("LOCATIONID"); 
String poNo="",itemId="",sheeName="",sheetNo="",colorStr = "",poStatus="",receiptNo="",status="";

if (updateFlag==null || updateFlag.equals("")) updateFlag="N";
if (dataError==null || dataError.equals("")) dataError="N";   //預設資料無誤
//out.println("updateFlag="+updateFlag);
String YearFr=dateBean.getYearMonthDay().substring(0,4);
String MonthFr=dateBean.getYearMonthDay().substring(4,6);
String DayFr=dateBean.getYearMonthDay().substring(6,8);
String dateString="",empId="";
float rcvQtyf=0,rcvQty=0;
Hashtable hashtb = new Hashtable();

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

// pType=1 上傳至暫存TABLE______起
if( pType == "1" || pType.equals("1"))
{
	mySmartUpload.initialize(pageContext); 
   	mySmartUpload.upload();
	dateString=dateBean.getYearMonthDay();
   	com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
   	upload_file.saveAs("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 


	String uploadFile_name=upload_file.getFileName();
   	String uploadFilePath="d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName();

	try
	{
		String sqlid = " SELECT TSCC_OM_STATUS_S.NEXTVAL RCV_ID,USER_ID, EMPLOYEE_ID FROM APPS.FND_USER A, ORADDMAN.WSUSER B  "+
 		  		       "  WHERE A.USER_NAME = UPPER(B.USERNAME)  AND  UPPER(B.USERNAME) =  trim(upper('"+UserName+"')) " ;
	    // out.print("sqli="+sqli);
		Statement stateid=con.createStatement();
     	ResultSet rsid=stateid.executeQuery(sqlid);
	 	if (rsid.next())
		{ 	
        	rcvId=rsid.getString("RCV_ID");         // 此次匯入的GROUP id ,用TSCC_OM_STATUS_S.nextval沒有特別意思,隨便抓的
            iRcvId=rsid.getInt("RCV_ID");
            loginUserId=rsid.getInt("USER_ID");
		}
      	rsid.close();
    	stateid.close(); 
	}
	catch (Exception e)
	{
		out.println("Exception delete:"+e.getMessage());		  
	} 

	String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   // 取結轉日期時間 //
    String strDate = dateBean.getYearMonthDay();   // 取結轉日期時間 //
    InputStream is = new FileInputStream("d://resin-2.1.9/webapps/oradds/jsp/upload_exl/"+dateString+"-"+upload_file.getFileName()); 			
			
    jxl.Workbook wb = Workbook.getWorkbook(is);  
	jxl.Sheet sht = wb.getSheet(0);

	String sheetName = sht.getName();    //抓SHEETNAME
    
    int rowCount = sht.getRows();  // 取此次筆數 
 	int dataCount = (rowCount-1);
	int i = 1; //EXCEL 表由第2列開始讀入			
         
	try 
	{
    	while (i<rowCount)  
        {  
			jxl.Cell wcDS_No = sht.getCell(0, i);    //ws.getWritableCell(int column, int row);  // 讀項次                        
            String dS_No = wcDS_No.getContents();           
  
            jxl.Cell wcDPo_No = sht.getCell(1, i);    //ws.getWritableCell(int column, int row);  // 讀PO_NO                        
            String dPo_No = wcDPo_No.getContents();           
			 
			jxl.Cell wcDItem_No = sht.getCell(2, i);    //ws.getWritableCell(int column, int row);  // 讀item no                               
            String dItem_No = wcDItem_No.getContents();              

			jxl.Cell wcDLot_No = sht.getCell(3, i);    //ws.getWritableCell(int column, int row);  // 讀Supplier Lot_No                          
            String dLot_No = wcDLot_No.getContents();       
			dLot_No = dLot_No.trim();//去空白,add by Peggy 20190813       
			 
			jxl.Cell wcDRcv_Qty = sht.getCell(4, i);    //ws.getWritableCell(int column, int row);  // 讀RCV_QTY                            
            String dRcv_Qty = wcDRcv_Qty.getContents();              
			  
			if ((UserRoles.indexOf("A01_Warehouse")>=0) ||(UserRoles.indexOf("admin")>=0) ) // 若A01才需要上傳有效期欄位  20161219
           	{ 
				jxl.Cell wcDExp_Date = sht.getCell(5, i);    //ws.getWritableCell(int column, int row);  // 讀EXPIRATION_DATE    20161219                      
                String dExp_Date = wcDExp_Date.getContents();   			 
			    if (dExp_Date==null || dExp_Date.equals("") || dExp_Date.equals("null")) {dExp_Date ="29991231";}  //如果是空值	          

				String sqlTC =  " insert into APPS.YEW_PO_RCV_L(RCV_ID,SHEET_NAME,SHEET_NO,PO_NO,ITEM_NO,VENDOR_LOT_NUM,RCV_QTY,CREATED_BY,EXP_DATE,STATUS,ITEM_ID) "+
                                " values(?,?,?,?,?,?,?,?,?,'OPEN',(select msi.INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS msi where msi.ORGANIZATION_ID=43 and msi.segment1=?)) ";   
				PreparedStatement seqstmt=con.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
				seqstmt.setInt(1,iRcvId);  //out.println("Step1.1");  //TSCC_OM_STATUS_S 是隨便抓一個seqno 的,沒特別意思
				seqstmt.setString(2,sheetName); //out.println("AAA"); 
				seqstmt.setString(3,dS_No); // excel上的項次
				seqstmt.setString(4,dPo_No); //out.println("dPo_No="+dPo_No);
				seqstmt.setString(5,dItem_No); //out.println("dItem_No="+dItem_No);
				seqstmt.setString(6,dLot_No);  //out.println("dLot_No="+dLot_No);
				seqstmt.setFloat(7,Float.parseFloat(dRcv_Qty));   //out.println("dRcv_Qty="+Float.parseFloat(dRcv_Qty));
				seqstmt.setInt(8,loginUserId); //out.println("loginUserId<br>");
				seqstmt.setString(9,dExp_Date); //out.println("dExp_Date<br>");	//20161219								 	 
				seqstmt.setString(10,dItem_No); //add by Peggy 20170927						 	 
				seqstmt.executeUpdate();
			}
			else   //其餘依原本欄位
			{
				String sqlTC =  " insert into APPS.YEW_PO_RCV_L(RCV_ID,SHEET_NAME,SHEET_NO,PO_NO,ITEM_NO,VENDOR_LOT_NUM,RCV_QTY,CREATED_BY,STATUS,ITEM_ID) "+
                                " values(?,?,?,?,?,?,?,?,'OPEN',(select msi.INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS msi where msi.ORGANIZATION_ID=43 and msi.segment1=?)) ";   
                PreparedStatement seqstmt=con.prepareStatement(sqlTC); //out.println("Step1.1.2");    				
			    seqstmt.setInt(1,iRcvId);  //out.println("Step1.1");  //TSCC_OM_STATUS_S 是隨便抓一個seqno 的,沒特別意思
                seqstmt.setString(2,sheetName); //out.println("AAA"); 
                seqstmt.setString(3,dS_No); // excel上的項次
				seqstmt.setString(4,dPo_No); //out.println("dPo_No="+dPo_No);
				seqstmt.setString(5,dItem_No); //out.println("dItem_No="+dItem_No);
				seqstmt.setString(6,dLot_No);  //out.println("dLot_No="+dLot_No);
				seqstmt.setFloat(7,Float.parseFloat(dRcv_Qty));   //out.println("dRcv_Qty="+Float.parseFloat(dRcv_Qty));
				seqstmt.setInt(8,loginUserId); //out.println("loginUserId<br>");			 
				seqstmt.setString(9,dItem_No);  //add by Peggy 20170927		
                seqstmt.executeUpdate();				  
			}
            i++;  
		} 
		
		//modify by Peggy 20170927,移到上面的sql裡
		//String sqlUC = " update APPS.YEW_PO_RCV_L "+
 		//			   " set ITEM_ID = (select MSI.INVENTORY_ITEM_ID from MTL_SYSTEM_ITEMS MSI "+
  	 	//		       " where MSI.ORGANIZATION_ID=43 and trim(ITEM_NO) = MSI.SEGMENT1)  ";
		//PreparedStatement seqstmta=con.prepareStatement(sqlUC); //out.println("Step1.1.2");    				
        //seqstmta.executeUpdate();
        //seqstmta.close(); 	
	} 
	catch (Exception e)
	{
		out.println("Exception insert:"+e.getMessage());		  
	} 
    wb.close(); 

   	try
   	{
    	String sqlall = " select PO_NO,ITEM_ID,RCV_ID,SHEET_NO,RCV_QTY from APPS.YEW_PO_RCV_L WHERE  RCV_ID="+rcvId+" order by to_number(SHEET_NO) " ;
	  	Statement stateA=con.createStatement();
       	ResultSet rsA=stateA.executeQuery(sqlall);
	   	while (rsA.next())
		{ 	
        	poNo=rsA.getString("PO_NO");
          	itemId=rsA.getString("ITEM_ID");
          	rcvId = rsA.getString("RCV_ID");
	      	sheetNo = rsA.getString("SHEET_NO");
          	rcvQty = rsA.getFloat("RCV_QTY");
          	rcvQtyf = rsA.getFloat("RCV_QTY");

            String sqlPc = " SELECT count(*) FROM PO_LINES_ALL PL ,PO_LINE_LOCATIONS_ALL PLL ,PO_HEADERS_ALL PH,YEW_PO_RCV_L YRL ";

            String sqlP =  " SELECT YRL.RCV_ID,YRL.SHEET_NAME,PH.SEGMENT1,PL.LINE_NUM,PH.PO_HEADER_ID, PLL.APPROVED_FLAG PO_STATUS, "+
                           "       (pll.quantity - pll.quantity_received) LINE_QTY , "+
		 	               "		   PL.PO_LINE_ID,PLL.LINE_LOCATION_ID,PL.ITEM_ID,YRL.ITEM_NO,PL.UNIT_MEAS_LOOKUP_CODE, "+
		 			       "		   PLL.SHIP_TO_LOCATION_ID,PH.VENDOR_ID,PH.VENDOR_SITE_ID,PLL.SHIP_TO_ORGANIZATION_ID, "+
						   "		   YRL.RCV_QTY,YRL.VENDOR_LOT_NUM,YRL.CREATED_BY,YRL.IMPORT_DATE "+
						   "     FROM PO_LINES_ALL PL ,PO_LINE_LOCATIONS_ALL PLL ,PO_HEADERS_ALL PH,YEW_PO_RCV_L YRL ";

   			String sqlPw = "  WHERE PH.SEGMENT1 = YRL.PO_NO  AND PL.ITEM_ID=YRL.ITEM_ID "+
    				       "  AND PL.PO_LINE_ID = PLL.PO_LINE_ID AND PH.PO_HEADER_ID=PL.PO_HEADER_ID "+
						   "  AND NVL(PL.CLOSED_CODE,'OPEN')='OPEN' AND NVL(PL.CANCEL_FLAG,'N') ='N' "+ //20180705 liling add
						   "  AND NVL(PLL.CLOSED_CODE,'OPEN')='OPEN' AND NVL(PLL.CANCEL_FLAG,'N') ='N' "+ //20200921 Marvie Add : fix error
                           "  AND YRL.RCV_ID = '"+rcvId+"' AND YRL.SHEET_NO ='"+sheetNo+"' AND (pll.quantity - pll.quantity_received)>0 ";

            String sOrderBy= " order by PLL.NEED_BY_DATE ";

           	int iCount=0; 
           	sqlPc=sqlPc+sqlPw;  //先判斷是否同張po,item有多交期...
           	//out.print("sqlPc="+sqlPc+"<br>");
	       	Statement statePc=con.createStatement();
           	ResultSet rsPc=statePc.executeQuery(sqlPc);
	       	if (rsPc.next())
		   	{  
				iCount=rsPc.getInt(1);  //out.print("<br>iCount="+iCount);
           	}//end if count
	       	rsPc.close();
    	   	statePc.close(); 
         	
			try
          	{
            	if (iCount==0)  //找不到po
            	{
              		PreparedStatement pstmte=con.prepareStatement("update APPS.YEW_PO_RCV_L set STATUS='ERROR',STATUS_DESC='PO not found' where RCV_ID = '"+rcvId+"' AND SHEET_NO ='"+sheetNo+"' AND  LINE_LOCATION_ID IS NULL ");  
              		pstmte.executeUpdate(); 
              		pstmte.close();   
             	}

            	if (iCount==1)  //該po內只有一個交期
             	{
              		sqlP = sqlP+sqlPw;
              		//out.print("<br>1.sqlP="+sqlP);
	          		Statement statePca=con.createStatement();
              		ResultSet rsPca=statePca.executeQuery(sqlP);
	          		while (rsPca.next())
              		{  //依據 sqlP 所得出的line location id 更新
		        		String  sqlPo=" update APPS.YEW_PO_RCV_L set LINE_NUM=?,PO_HEADER_ID=?,PO_LINE_ID=?,LINE_LOCATION_ID=?,UOM=?,SHIP_TO_LOCATION_ID=?, "+
					                  " VENDOR_ID=?,VENDOR_SITE_ID=?,TO_ORGANIZATION_ID=?,PO_STATUS=? "+
	                                  " where RCV_ID = '"+rcvId+"' AND SHEET_NO ='"+sheetNo+"'  ";  
                 		PreparedStatement pstmt=con.prepareStatement(sqlPo);  
			     		pstmt.setInt(1,rsPca.getInt("LINE_NUM"));  
	   		     		pstmt.setInt(2,rsPca.getInt("PO_HEADER_ID"));  
		         		pstmt.setInt(3,rsPca.getInt("PO_LINE_ID"));  
			     		pstmt.setInt(4,rsPca.getInt("LINE_LOCATION_ID")); 
		         		pstmt.setString(5,rsPca.getString("UNIT_MEAS_LOOKUP_CODE")); 
		         		pstmt.setInt(6,rsPca.getInt("SHIP_TO_LOCATION_ID")); 
		         		pstmt.setInt(7,rsPca.getInt("VENDOR_ID")); 
		         		pstmt.setInt(8,rsPca.getInt("VENDOR_SITE_ID")); 
		         		pstmt.setInt(9,rsPca.getInt("SHIP_TO_ORGANIZATION_ID"));
		         		pstmt.setString(10,rsPca.getString("PO_STATUS"));  
                 		pstmt.executeUpdate(); 
                 		pstmt.close();   
              		}//end of while
	         		rsPca.close();
    	     		statePca.close();             
				}
           		else  // po有同item 多交期
           		{ 
             		int lineNum=0,headerId=0,lineId=0,locationIdi=0;
             		float lineQtyf=0,sumRcvQtyf=0;

             		sqlP = sqlP+sqlPw+sOrderBy;
             		//out.print("<br>2.sqlP="+sqlP);
	         		Statement statePcb=con.createStatement();
             		ResultSet rsPcb=statePcb.executeQuery(sqlP);
	         		while (rsPcb.next())
             		{  
              			try
              			{   
               				lineNum = rsPcb.getInt("LINE_NUM"); 
               				locationIdi = rsPcb.getInt("LINE_LOCATION_ID");
               				lineQtyf = rsPcb.getFloat("LINE_QTY");

               				//計算 rcv table 裡已有location id的總數
                			String Sqls="select SUM(RCV_QTY) from yew_po_rcv_l where status='OPEN' AND rcv_id="+rcvId+" AND LINE_LOCATION_ID='"+locationIdi+"' ";
	            			Statement stateS=con.createStatement();
                			ResultSet rsS=stateS.executeQuery(Sqls);
	            			if (rsS.next())
                			{  
                  				sumRcvQtyf = rsS.getFloat(1); 
                 			}
	             			rsS.close();
    	         			stateS.close();

                 			if ( (lineQtyf-sumRcvQtyf) >= rcvQtyf )  //總PO數-已有註明數 > 此次要收的 ,把目前的LOCATION ID 填入
                  			{ 
		           				String  sqlPo=" update APPS.YEW_PO_RCV_L set LINE_NUM=?,PO_HEADER_ID=?,PO_LINE_ID=?,LINE_LOCATION_ID=?,UOM=?,SHIP_TO_LOCATION_ID=?, "+
				  	                          " VENDOR_ID=?,VENDOR_SITE_ID=?,TO_ORGANIZATION_ID=?,PO_STATUS=?,STATUS='OPEN',STATUS_DESC=''  "+
	                                          " where RCV_ID = '"+rcvId+"' AND SHEET_NO ='"+sheetNo+"'  AND  LINE_LOCATION_ID IS NULL ";  
                    			PreparedStatement pstmtf=con.prepareStatement(sqlPo);  
			        			pstmtf.setInt(1,rsPcb.getInt("LINE_NUM"));  
	   		        			pstmtf.setInt(2,rsPcb.getInt("PO_HEADER_ID"));  
		            			pstmtf.setInt(3,rsPcb.getInt("PO_LINE_ID"));  
			       				// pstmtf.setInt(4,rsPcb.getInt("LINE_LOCATION_ID")); 
			        			pstmtf.setInt(4,locationIdi); 
		            			pstmtf.setString(5,rsPcb.getString("UNIT_MEAS_LOOKUP_CODE")); 
		            			pstmtf.setInt(6,rsPcb.getInt("SHIP_TO_LOCATION_ID")); 
		            			pstmtf.setInt(7,rsPcb.getInt("VENDOR_ID")); 
		            			pstmtf.setInt(8,rsPcb.getInt("VENDOR_SITE_ID")); 
		            			pstmtf.setInt(9,rsPcb.getInt("SHIP_TO_ORGANIZATION_ID"));
		            			pstmtf.setString(10,rsPcb.getString("PO_STATUS"));  
                    			pstmtf.executeUpdate(); 
                    			pstmtf.close();   
                    			//out.print("update locd id="+locationIdi);
                   			} 
							else
                     		{ 
								float avaQtyf=0;
                       			//out.print("<BR>aaaa sheetNo="+sheetNo+"   locationIdi="+locationIdi+"  avaQtyf:"+avaQtyf+"  rcvQtyf="+rcvQtyf );
		               			String  sqlPo=" update APPS.YEW_PO_RCV_L set STATUS='ERROR', STATUS_DESC='Qty Over' where RCV_ID = '"+rcvId+"' AND SHEET_NO ='"+sheetNo+"' AND  LINE_LOCATION_ID IS NULL ";  
                       			PreparedStatement pstmte=con.prepareStatement(sqlPo);  
                       			pstmte.executeUpdate(); 
                       			pstmte.close();   
                      		}
                 		}
		        		catch (Exception e)
		        		{ 
							out.println("Exception ccc:"+e.getMessage());	
						} 
              		} //end while
	        		rsPcb.close();
    	    		statePcb.close(); 
            	} //end if iCount<=1
          	}
		  	catch (Exception e)
		  	{ 
				out.println("Exception muti:"+e.getMessage());	
			} 
        } //end of while 
	    rsA.close();
    	stateA.close(); 
        
        pType = "2" ; //可上傳資料至ERP  
        
		try
		{
        	//檢查有無料號key錯的____起
            String sqlIC= "  SELECT COUNT(*) FROM YEW_PO_RCV_L WHERE (ITEM_ID IS NULL or PO_STATUS='N' OR STATUS !='OPEN') AND RCV_ID ='"+rcvId+"' ";
	        Statement stateIC=con.createStatement();
			ResultSet rsIC=stateIC.executeQuery(sqlIC);
	        if (rsIC.next())
	        {  
            	errCount=rsIC.getInt(1);
                if(rsIC.getInt(1)>0)
                {
%>
					<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="80%" align="center" bordercolorlight="#ffffff" border="1">
                    	<tr>
							<td colspan="8"><div align="center"><font color="#CC3300" face="Arial" size="2">異常資料無法轉入</font></div></td>
						</tr>
  			        	<tr bgcolor="#CCCC99"> 
			         		<td width="3%" height="20" nowrap><div align="center"><font color="#006666" face="Arial" size="2">識別</font></div></td>
  		             		<td width="2%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">項次</font></div></td>  
  		             		<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">PO NO</font></div></td>  
  		             		<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">核准狀態</font></div></td>         
			         		<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">料號</font></div></td>
   			         		<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">接收數</font></div></td>
			         		<td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">批號</font></div></td>
			         		<td width="12%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">說明</font></div></td>			 
                   		</tr>
<%
                    //異常資料狀態改變
                    //無 ITEM ID的
                    //out.print(" <BR>sqlUsc="+sqlUsc);
                    PreparedStatement pstmtD=con.prepareStatement(" update APPS.YEW_PO_RCV_L set STATUS='ERROR' ,STATUS_DESC='ITEM ERROR'  where RCV_ID = '"+rcvId+"' and ITEM_ID IS NULL ");  
                    pstmtD.executeUpdate(); 
                    pstmtD.close();   

		            String  sqlUsP=" update APPS.YEW_PO_RCV_L set STATUS_DESC='PO Approved Error' "+
                                       "  where RCV_ID = '"+rcvId+"' and PO_STATUS='N'  ";
                    //out.print(" <BR>sqlUsc="+sqlUsc);
                    PreparedStatement pstmtP=con.prepareStatement(sqlUsP);  
                    pstmtP.executeUpdate(); 
                    pstmtP.close();   
					//異常資料狀態改變

                    String sqlI= "  SELECT SHEET_NO,PO_NO,ITEM_NO,RCV_QTY,VENDOR_LOT_NUM,PO_STATUS,STATUS_DESC FROM YEW_PO_RCV_L  "+
			   		  	         "  WHERE (ITEM_ID IS NULL or PO_STATUS='N' OR STATUS !='OPEN' ) AND RCV_ID ='"+rcvId+"' ";
                    //out.print("sqlI="+sqlI);
	                Statement stateI=con.createStatement();
                    ResultSet rsI=stateI.executeQuery(sqlI);
	                while (rsI.next())
	             	{
                    	poStatus=rsI.getString("PO_STATUS");
                    	if (poStatus==null || poStatus=="" || poStatus.equals("") || poStatus.equals("null")) poStatus="&nbsp;";
%>
                      	<tr bgcolor="#FFFF99"> 
                        	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rcvId%></font></div></td>
	 		            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("SHEET_NO")%></font></div></td>
			            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("PO_NO")%></font></div></td>
			            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=poStatus%></font></div></td>
			            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("ITEM_NO")%>&nbsp;</font></div></td>  
			            	<td ><div align="right"><font color="#006666" face="Arial" size="2"><%=rsI.getString("RCV_QTY")%>&nbsp;</font></div></td>
			            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsI.getString("VENDOR_LOT_NUM")%></font></div></td>
			            	<td ><div align="center"><font color="#CC3300" face="Arial" size="2"><%=rsI.getString("STATUS_DESC")%></font></div></td>
                     	</tr>
<%
                    	//異常資料狀態改變
		            	String  sqlUsD=" update APPS.YEW_PO_RCV_L set STATUS='ERROR' "+
                                       " where RCV_ID = '"+rcvId+"' and STATUS='OPEN' AND SHEET_NO= '"+rsI.getString("SHEET_NO")+"'  ";
                    	//out.print(" <BR>sqlUsc="+sqlUsc);
                    	PreparedStatement pstmtDa=con.prepareStatement(sqlUsD);  
                    	pstmtDa.executeUpdate(); 
                    	pstmtDa.close();   
					}  //end while
	               	rsI.close();
	               	stateI.close();
                } //end  if(rsIC.getInt(1)>0)
			} // end if
	        rsIC.close();
	        stateIC.close();
%>            
						<tr>
							<td colspan="8"><font color='#006666' face='Arial' size='3'>上傳資料數 計<%=dataCount%> 筆,異常數 計 <%=errCount%> 筆 </font></td>
						</tr> 
             		</table>
<%            //檢查有無料號key錯的____迄
		}
		catch (Exception e)
		{ 
			out.println("Exception bbb:"+e.getMessage());	
		} 
	} // end of try
	catch (Exception e)
	{
		out.println("Exception updatedb:"+e.getMessage());		  
	} 
} //  end if (pType=1) 
// pType=1 上傳至暫存TABLE______迄

// pType=='2' 檢核上傳資料及找出PO相關資訊____起
if ( pType=="2" || pType.equals("2"))
{
	try
   	{     
    	String sRcvId="",sSheetNo="",sPoNo="",sLineNo="",sItemNo="",sItemId="",sUom="",sAllowQty="",sPoQty="",sOrg="",fcolor="";
        float allowQtyf=0;
        int k=1;
        String sqlP =  " SELECT distinct YRL.RCV_ID,PH.SEGMENT1 PO_NO,PL.LINE_NUM,PH.PO_HEADER_ID,  "+
		 			   "  PL.PO_LINE_ID,PLL.LINE_LOCATION_ID,PL.ITEM_ID,YRL.ITEM_NO,PL.UNIT_MEAS_LOOKUP_CODE UOM,  "+
                       "  DECODE(YRL.TO_ORGANIZATION_ID,326,'Y1',327,'Y2','606','I13',YRL.TO_ORGANIZATION_ID) ORG_CODE , "+
		 			   "  PLL.QUANTITY PO_QTY, nvl(PLL.QUANTITY_RECEIVED,0) RCVD_QTY, (PLL.QUANTITY-PLL.QUANTITY_RECEIVED) ALLOW_QTY   "+
					   "  FROM PO_LINES_ALL PL ,PO_LINE_LOCATIONS_ALL PLL ,PO_HEADERS_ALL PH,YEW_PO_RCV_L YRL "+
   					   "  WHERE PH.SEGMENT1 = YRL.PO_NO  AND PL.ITEM_ID=YRL.ITEM_ID "+
    				   "  AND PL.PO_LINE_ID = PLL.PO_LINE_ID AND PH.PO_HEADER_ID=PL.PO_HEADER_ID  "+
                       "  AND PLL.APPROVED_FLAG='Y' AND YRL.RCV_ID = '"+rcvId+"' AND  YRL.STATUS='OPEN' "+
					   "  AND NVL(PL.CLOSED_CODE,'OPEN')='OPEN' AND NVL(PL.CANCEL_FLAG,'N') ='N' "+ //20180705 liling add
					   "  AND NVL(PLL.CLOSED_CODE,'OPEN')='OPEN' AND NVL(PLL.CANCEL_FLAG,'N') ='N' "+ //20200921 Marvie Add : fix error
                       "  AND  (PLL.QUANTITY-PLL.QUANTITY_RECEIVED) >0  ";
		// out.print("<br>sqlP="+sqlP);
	    Statement stateSh=con.createStatement();
        ResultSet rsSh=stateSh.executeQuery(sqlP);
%>
	<hr>
		<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  			<tr bgcolor="#BBD3E1"  height="20"> 
				<td width="3%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">識別</font></div></td> 
  		       	<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">PO NO</font></div></td>           
 		       	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Line</font></div></td> 
			   	<td width="15%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">料號</font></div></td>
			   	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">單位</font></div></td>
			   	<td width="5%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">ORG</font></div></td>
			   	<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">採購數量</font></div></td>
			   	<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">已接收量</font></div></td>
			   	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">可收數量</font></div></td>
   			   	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">上傳數量</font></div></td>
			   	<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">Detail</font></div></td>	 
            </tr>
<%
		while (rsSh.next())
		{  
        	sRcvId=rsSh.getString("RCV_ID");
            // sSheetNo=rsSh.getString("SHEET_NO");
			sPoNo=rsSh.getString("PO_NO");
            sLineNo=rsSh.getString("LINE_NUM");
            sItemNo=rsSh.getString("ITEM_NO");
            sItemId=rsSh.getString("ITEM_ID");
            locationId=rsSh.getString("LINE_LOCATION_ID");
            sUom=rsSh.getString("UOM");
            sOrg=rsSh.getString("ORG_CODE");
            sPoQty=rsSh.getString("PO_QTY");
            sAllowQty=rsSh.getString("ALLOW_QTY");
            allowQtyf=rsSh.getFloat("ALLOW_QTY");
 
            String sqlRqty= "  SELECT SUM(rcv_qty) RCV_QTY FROM YEW_PO_RCV_L WHERE LINE_LOCATION_ID='"+locationId+"' AND RCV_ID='"+rcvId+"' AND STATUS='OPEN'  AND PO_STATUS='Y' ";
            //out.print("sqlRqty"+sqlRqty);
	        Statement stateRqty=con.createStatement();
            ResultSet rsRqty=stateRqty.executeQuery(sqlRqty);
	        if (rsRqty.next())
	        {
            	rcvQtyf = rsRqty.getFloat("RCV_QTY");
			}
	        rsRqty.close();
	        stateRqty.close();

	        if ((k % 2) == 0)
			{
	        	colorStr = "#D8E6E7"; 
			}
	        else
			{
	        	colorStr = "#BBD3E1"; 
			}
            
			if ( rcvQtyf > allowQtyf ) 
            {  
            	colorStr = "#FFFF66" ;
                dataError = "Y";    //資料有異常不允許轉入
			}
	       
		    if (sOrg == "Y1" || sOrg.equals("Y1"))
			{
	        	fcolor = "#006666"; 
			}
	        else
			{
	        	fcolor = "#0000CC"; 
			}
%>
			<tr bgcolor="<%=colorStr%>" height="20"> 
            	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sRcvId%></font></div></td>
	 		   	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sPoNo%></font></div></td>
			   	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sLineNo%></font></div></td>
			  	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sItemNo%></font></div></td>
			   	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=sUom%></font></div></td>
			   	<td ><div align="center"><font color="<%=fcolor%>" face="Arial" size="2"><%=sOrg%></font></div></td>
			   	<td ><div align="right"><font color="#006666" face="Arial" size="2"><%=sPoQty%>&nbsp;</font></div></td>
			   	<td ><div align="right"><font color="#006666" face="Arial" size="2"><%=rsSh.getString("RCVD_QTY")%></font></div></td>
			   	<td ><div align="right"><strong><font color="#000099" face="Arial" size="2"><%=sAllowQty%>&nbsp;</font></strong></div></td>
			   	<td ><div align="right"><strong><font color="#000099" face="Arial" size="2"><%=rcvQtyf%>&nbsp;</font></strong></div></td>  
			   	<td ><div align="center"><font color="#006666" face="Arial" size="-1">
                <input type='button' name='LOTINFO' size="-1" value='LotNo' onClick='subWinRcvLotInfo("<%=sRcvId%>","<%=locationId%>")'> 
                </font></div></td>
			</tr>
<%
            k++; //項次使用
		} //END while(rsSh.next())
	    rsSh.close();
    	stateSh.close(); 
	} // end of try
	catch (Exception e)
	{
		out.println("Exception updatedb:"+e.getMessage());		  
	} 
%>
           <tr><td colspan="11">
<%
//檢核是否有二個 TO_ORGANIZATION ID
//20100421 liling add
	try
   	{
    	int toOrgCount=0;

        String sqlToOrg= " SELECT COUNT (DISTINCT TO_ORGANIZATION_ID) ORGCOUNT FROM YEW_PO_RCV_L WHERE RCV_ID='"+rcvId+"' AND STATUS='OPEN'  AND PO_STATUS='Y' ";
        //out.print("sqlToOrg="+sqlToOrg);
	    Statement stateToOrg=con.createStatement();
        ResultSet rsToOrg=stateToOrg.executeQuery(sqlToOrg);
	    if (rsToOrg.next())
		{
        	toOrgCount = rsToOrg.getInt("ORGCOUNT");
		}
	    rsToOrg.close();
	    stateToOrg.close();

        if ( toOrgCount > 1 ) 
		{
		%>
			<script language="javascript">
				alert("請注意此批有內外銷合併,不允許上傳");
			</script> 
		<% 
        	dataError = "Y";    //資料有異常不允許轉入
        } 
	} // end of try
	catch (Exception e)
	{
		out.println("Exception org check:"+e.getMessage());		  
	}      

 	if (dataError=="N" || dataError.equals("N"))    //數量無誤才能轉入
   	{ 
	%>   
    	<input type='button' name='IMPORT' size='20' value='    轉入ERP   ' onClick='setDataUpload("../jsp/TSCPoReceiptInsert.jsp?PTYPE=3&RCV_ID=<%=rcvId%>")'> 
	<%
	}
	%>
    	<input type='button' name='ABORT' size='20' value='   放棄上傳   ' onClick='setDataReset("../jsp/TSCPoReceiptInsert.jsp?PTYPE=4&RCV_ID=<%=rcvId%>")'>
				</td>
			</tr>
		</table>
<%
} //end if (PTYPE=2) 
// pType=='2' 檢核上傳資料及找出PO相關資訊___迄

// pType=='3' 轉入ERP做Receipt ______起
if (pType == "3" || pType.equals("3"))
{
	int rcvHeaderId=0,rtvId=0,groupId=0,ilineNum=0,ipoHeaderId=0,ipoLineId=0,ilocationId=0,iitemId=0,ishipToId=0;
    int ivendorId=0,ivendorSite=0,iorganizationId=0,j=1;
    float ircvQty=0;
    String ipoNo="",iuom="",ilotNo="",iexpDate="",interface_group_id="";

    //interface 所需id
	try
    {
    	String sqlGpid = " select RCV_HEADERS_INTERFACE_S.NEXTVAL RH_ID , RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RT_ID,RCV_INTERFACE_GROUPS_S.NEXTVAL GROUPID FROM dual " ;
       	//out.print("sqlGpid="+sqlGpid);
	   	Statement stateGpid=con.createStatement();
       	ResultSet rsGpid=stateGpid.executeQuery(sqlGpid);
	   	if (rsGpid.next())
       	{
        	rcvHeaderId=rsGpid.getInt("RH_ID");         // 此次匯入的GROUP id ,用TSCC_OM_STATUS_S.nextval沒有特別意思,隨便抓的
         	groupId=rsGpid.getInt("GROUPID");
         	rtvId=rsGpid.getInt("RT_ID");
        }
	    rsGpid.close();
        stateGpid.close(); 
       	out.print("<BR>rcvHeaderId="+rcvHeaderId+" rtvId="+rtvId );

       	//20100518 liling add employee id
       	String sqleid = " SELECT USER_ID, EMPLOYEE_ID FROM APPS.FND_USER A, ORADDMAN.WSUSER B  "+
 	    			    "  WHERE A.USER_NAME = UPPER(B.USERNAME)  AND  UPPER(B.USERNAME) =  trim(upper('"+UserName+"')) " ;
        //out.print("sqleid="+sqleid);
	    Statement stateeid=con.createStatement();
        ResultSet rseid=stateeid.executeQuery(sqleid);
	    if (rseid.next())
	    { 	
        	empId=rseid.getString("EMPLOYEE_ID");        
        }
        //end of while
	    rseid.close();
    	stateeid.close(); 
        //out.print("<br>loginUserId="+loginUserId);		 
	}
	catch (Exception e)
	{
		out.println("Exception empid:"+e.getMessage());		  
	} 

    try
    {  
		Statement stated=con.createStatement();
		ResultSet rsd=stated.executeQuery(" SELECT RCV_INTERFACE_GROUPS_S.NEXTVAL from dual");
		if (rsd.next())
		{ 	
			interface_group_id = rsd.getString(1);      
		}
		rsd.close();
		stated.close();	
		
		//String sqlpid =	" select PO_NO,LINE_NUM,PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID,ITEM_ID,UOM,SHIP_TO_LOCATION_ID, "+
       	//   				"        VENDOR_ID,VENDOR_SITE_ID,TO_ORGANIZATION_ID,RCV_QTY,UOM,VENDOR_LOT_NUM,CREATED_BY,EXP_DATE,SHEET_NO   "+
		//    			"   from YEW_PO_RCV_L WHERE STATUS='OPEN' AND LINE_LOCATION_ID IS NOT NULL AND PO_STATUS='Y' AND RCV_ID='"+rcvId+"'  "; 
		//modify by Peggy 20170928,調整A01暫收SQL,同一PO項次合併數量寫入INTERFACE
		String sqlpid = " select DISTINCT PO_NO,LINE_NUM,PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID,ITEM_ID,UOM,SHIP_TO_LOCATION_ID, "+
                        " VENDOR_ID,VENDOR_SITE_ID,TO_ORGANIZATION_ID,SUM(RCV_QTY) OVER (PARTITION BY PO_NO,LINE_NUM,PO_HEADER_ID,PO_LINE_ID,LINE_LOCATION_ID,ITEM_ID,UOM,SHIP_TO_LOCATION_ID,"+
                        " VENDOR_ID,VENDOR_SITE_ID,TO_ORGANIZATION_ID,UOM,CASE WHEN TO_ORGANIZATION_ID=606 THEN NULL ELSE VENDOR_LOT_NUM END,CREATED_BY,"+
                        " CASE WHEN TO_ORGANIZATION_ID=606 THEN NULL ELSE SHEET_NO END) AS RCV_QTY,"+
                        " CASE WHEN TO_ORGANIZATION_ID=606 THEN NULL ELSE VENDOR_LOT_NUM END  VENDOR_LOT_NUM,"+
                        " CREATED_BY,'' EXP_DATE,"+
                        " CASE WHEN TO_ORGANIZATION_ID=606 THEN TO_CHAR(LINE_LOCATION_ID) ELSE SHEET_NO END SHEET_NO"+
                        " from YEW_PO_RCV_L "+
						" WHERE STATUS='OPEN' AND LINE_LOCATION_ID IS NOT NULL AND PO_STATUS='Y' AND RCV_ID='"+rcvId+"'"; 
	    //out.print("sqlpid="+sqlpid);
    	Statement statePid=con.createStatement();
        ResultSet rsPid=statePid.executeQuery(sqlpid);
	    while (rsPid.next())
		{ 
        	ipoNo=rsPid.getString("PO_NO"); 
            ilineNum=rsPid.getInt("LINE_NUM");
            ipoHeaderId=rsPid.getInt("PO_HEADER_ID");
            ipoLineId=rsPid.getInt("PO_LINE_ID");
            ilocationId=rsPid.getInt("LINE_LOCATION_ID");
            iitemId=rsPid.getInt("ITEM_ID");
            ishipToId=rsPid.getInt("SHIP_TO_LOCATION_ID");
            ivendorId=rsPid.getInt("VENDOR_ID");
            ivendorSite=rsPid.getInt("VENDOR_SITE_ID");
            iorganizationId=rsPid.getInt("TO_ORGANIZATION_ID");
            ircvQty=rsPid.getFloat("RCV_QTY");
            iuom=rsPid.getString("UOM"); 
            ilotNo=rsPid.getString("VENDOR_LOT_NUM");
			if (ilotNo==null) ilotNo=""; //add by Peggy 20170928 
            loginUserId=rsPid.getInt("CREATED_BY");
			iexpDate=rsPid.getString("EXP_DATE"); 
			sheetNo=rsPid.getString("SHEET_NO");

			try 
			{
				//寫入 RCV_HEADERS_INTERFACE__起
              	if(j==1)  //j=1 第一筆資料
               	{   
               		String rcvRsql= " INSERT INTO RCV_HEADERS_INTERFACE "+
  					  			    " (HEADER_INTERFACE_ID, GROUP_ID, PROCESSING_STATUS_CODE, RECEIPT_SOURCE_CODE, TRANSACTION_TYPE, "+
    							    " LAST_UPDATE_DATE, LAST_UPDATED_BY, VENDOR_ID, EXPECTED_RECEIPT_DATE, VALIDATION_FLAG,EMPLOYEE_ID) "+
                                    " values(?,?,?,?,?,sysdate,?,?,sysdate,?,?) ";
  				  	PreparedStatement pstmtI=con.prepareStatement(rcvRsql);  
  				  	pstmtI.setInt(1,rcvHeaderId);  // INTERFACE_TRANSACTION_ID
					//pstmtI.setInt(2,loginUserId);  // GROUP_ID  固定丟USER的 USER_ID識別
					pstmtI.setString(2,interface_group_id);  //modify by Peggy 20170929
				  	pstmtI.setString(3,"PENDING");  // PROCESSING_STATUS_CODE
                  	pstmtI.setString(4,"VENDOR");  //  RECEIPT_SOURCE_CODE
				  	pstmtI.setString(5,"NEW");  // TRANSACTION_TYPE
					pstmtI.setInt(6,loginUserId);  // LAST_UPDATED_BY
				  	pstmtI.setInt(7,ivendorId);  // VENDOR_ID
				  	pstmtI.setString(8,"Y");  //VALIDATION_FLAG
				  	pstmtI.setString(9,empId);  // EMPLOYEE_ID
  				  	pstmtI.executeUpdate(); 
 				  	pstmtI.close();
                	//   out.println("<br>!!!RCV_HEADERS_INTERFACE!!!!");
                }//end  if(j=1)
           	    //寫入 RCV_HEADERS_INTERFACE__迄  

             	//寫入 RCV_TRANSACTIONS_INTERFACE___起  
				String rcvRsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE "+
                                "    (INTERFACE_TRANSACTION_ID,HEADER_INTERFACE_ID, GROUP_ID,LAST_UPDATE_DATE,CREATION_DATE,TRANSACTION_DATE, "+
   								"     LAST_UPDATED_BY,CREATED_BY,TRANSACTION_TYPE,PROCESSING_STATUS_CODE,PROCESSING_MODE_CODE,TRANSACTION_STATUS_CODE, "+
							    "     RECEIPT_SOURCE_CODE,SOURCE_DOCUMENT_CODE,DESTINATION_TYPE_CODE,VALIDATION_FLAG, "+
                                "     DOCUMENT_NUM,DOCUMENT_LINE_NUM, PO_LINE_ID,PO_LINE_LOCATION_ID, ITEM_ID, QUANTITY, "+
	                            "     UNIT_OF_MEASURE, SHIP_TO_LOCATION_ID,VENDOR_ID,VENDOR_SITE_ID,TO_ORGANIZATION_ID, "+
								"     UOM_CODE,VENDOR_LOT_NUM,ATTRIBUTE6 ,EMPLOYEE_ID ) "+
                                " values(RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL,?,?,sysdate,sysdate,sysdate,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
  				PreparedStatement pstmtR=con.prepareStatement(rcvRsql);  
  				pstmtR.setInt(1,rcvHeaderId);  // INTERFACE_TRANSACTION_ID
                //pstmtR.setInt(2,loginUserId);  // GROUP_ID  固定丟USER的 USER_ID識別
				pstmtR.setString(2,interface_group_id);  //modify by Peggy 20170929
                pstmtR.setInt(3,loginUserId);  // LAST_UPDATED_BY
                pstmtR.setInt(4,loginUserId);  // CREATED_BY
				pstmtR.setString(5,"RECEIVE");  // TRANSACTION_TYPE
                pstmtR.setString(6,"PENDING");   // PROCESSING_STATUS_CODE
				pstmtR.setString(7,"BATCH");     // PROCESSING_MODE_CODE
			    pstmtR.setString(8,"PENDING");   // TRANSACTION_STATUS_CODE
				pstmtR.setString(9,"VENDOR");  // RECEIPT_SOURCE_CODE
				pstmtR.setString(10,"PO");  //SOURCE_DOCUMENT_CODE
				pstmtR.setString(11,"RECEIVING");  //DESTINATION_TYPE_CODE
				pstmtR.setString(12,"Y");  //VALIDATION_FLAG
				pstmtR.setString(13,ipoNo);  //DOCUMENT_NUM po_no
				pstmtR.setInt(14,ilineNum);  //DOCUMENT_LINE_NUM
				pstmtR.setInt(15,ipoLineId);  //PO_LINE_ID
				pstmtR.setInt(16,ilocationId);  //PO_LINE_LOCATION_ID
				pstmtR.setInt(17,iitemId);  //ITEM_ID
				pstmtR.setFloat(18,ircvQty);  //QUANTITY
				pstmtR.setString(19,iuom);  //UNIT_OF_MEASURE
				pstmtR.setInt(20,ishipToId);  //SHIP_TO_LOCATION_ID
				pstmtR.setInt(21,ivendorId);  //VENDOR_ID
				pstmtR.setInt(22,ivendorSite);  //VENDOR_SITE_ID
				pstmtR.setInt(23,iorganizationId);  //TO_ORGANIZATION_ID
				pstmtR.setString(24,iuom);  //UOM_CODE
				pstmtR.setString(25,ilotNo);  //VENDOR_LOT_NUM
				pstmtR.setString(26,rcvId+sheetNo);  //ATTRIBUTE6
				pstmtR.setString(27,empId);  //EMPLOYEE_ID
  				pstmtR.executeUpdate(); 
 				pstmtR.close();
				//寫入 RCV_TRANSACTIONS_INTERFACE___迄 
                // out.println("<br>end  RCV_TRANSACTIONS_INTERFACE!!!!");
				j++ ;  //判斷是否第一筆,要寫入RCV_HEADERS_INTERFACE   
			}	// End of try
	        catch (Exception e) 
	        { 
				out.println("Exception YEW:"+e.getMessage()); 
			}			    
		} // end while
	    rsPid.close();
        statePid.close(); 
        // out.print("****RCV_TRANSACTIONS_INTERFACE sucess!!");
	}	// End of try
	catch (Exception e) 
	{ 
		out.println("Exception interface:"+e.getMessage()); 
	}	

	try 
    {
    	int requestID=0,i_loop_cnt=0;
        String devStatus="",devMessage="";
        String successInfo="",Errbuf="",Retcode="";
		String shipmentHeaderId="",sql="",po_distributions_id="",interface_trx_id ="";
		double rcv_qty =0,use_qty=0,deliver_qty=0; //add by Peggy 20170928

		CallableStatement cs4 = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
		//cs4.setString(1,Integer.toString(loginUserId));			                        // 此次的 RCV Processor Group ID
		cs4.setString(1,interface_group_id);	//modif by Peggy 20170929
		//out.print("Groupid:"+Integer.toString(loginUserId));
		cs4.setInt(2,loginUserId);                   //USER REQUEST 
		//cs4.setInt(3,50801);                      //RESPONSIBILITY ID 
		cs4.setInt(3,(iorganizationId==606?50264:50801));
		cs4.registerOutParameter(4, Types.INTEGER);                  //回傳 REQUEST_ID
		cs4.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
		cs4.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE			
		cs4.execute();
        requestID = cs4.getInt(4);   //  回傳 REQUEST_ID
		devStatus = cs4.getString(5);   //  回傳 REQUEST 執行狀況
		devMessage = cs4.getString(6);   //  回傳 REQUEST 執行狀況訊息
		cs4.close();		
		out.print("<br>Receipt requestID:"+requestID);
		out.print("devStatus:"+devStatus);
		out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099' size='+1'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
		//out.println("sqlfnd="+sqlfnd);	
		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
		out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	

        //抓成功與否
        String sqlrcvErr = " select PROCESSING_STATUS_CODE from RCV_HEADERS_INTERFACE where HEADER_INTERFACE_ID= '"+rcvHeaderId+"'" ;
		//out.println("<br>sqlrcvErr="+sqlrcvErr);
	    Statement stateRcvErr=con.createStatement();
        ResultSet rsRcvErr=stateRcvErr.executeQuery(sqlrcvErr);
	    if (rsRcvErr.next())
		{
			successInfo=rsRcvErr.getString(1);         // 此次匯入的GROUP id ,用TSCC_OM_STATUS_S.nextval沒有特別意思,隨便抓的
        }
	    rsRcvErr.close();
        stateRcvErr.close(); 
		
		if ( successInfo=="SUCCESS" || successInfo.equals("SUCCESS"))  //成功的話回傳驗收單號及更新table
        {
            String sqlrcvNo = " SELECT RSH.RECEIPT_NUM,RSH.SHIPMENT_HEADER_ID FROM RCV_HEADERS_INTERFACE RHI,RCV_SHIPMENT_HEADERS RSH "+
		  				      "  WHERE RHI.RECEIPT_HEADER_ID=RSH.SHIPMENT_HEADER_ID AND RHI.PROCESSING_STATUS_CODE='SUCCESS' "+
 						      "    AND RHI.HEADER_INTERFACE_ID = '"+rcvHeaderId+"'" ;
            //out.print("sqlrcvNo="+sqlrcvNo);
	        Statement stateRcvNo=con.createStatement();
            ResultSet rsRcvNo=stateRcvNo.executeQuery(sqlrcvNo);
	        if (rsRcvNo.next())
            {
            	receiptNo=rsRcvNo.getString("RECEIPT_NUM");         // 
				shipmentHeaderId=rsRcvNo.getString("SHIPMENT_HEADER_ID");   //20170515
			}
	        rsRcvNo.close();
            stateRcvNo.close(); 

            out.print("<br><font color='#000099' face='Arial' SIZE='+1'>驗收單號:"+receiptNo+"</FONT>");
                 
			//更新temp table 狀態
		    String  sqlUs=" update APPS.YEW_PO_RCV_L  "+
				          " set STATUS='SUCCESS',HEADER_INTERFACE_ID='"+rcvHeaderId+"', RECEIPT_NO='"+receiptNo+"',SHIPMENT_HEADER_ID='"+shipmentHeaderId+"' "+
                          " where RCV_ID = '"+rcvId+"' AND STATUS='OPEN' AND LINE_LOCATION_ID IS NOT NULL AND PO_STATUS='Y'  ";
            // out.print("sqlUs="+sqlUs);
            PreparedStatement pstmtb=con.prepareStatement(sqlUs);  
            pstmtb.executeUpdate(); 
            pstmtb.close();   

		    String  sqlUa=" update YEW_PO_RCV_L a  "+
						  " set (SHIPMENT_LINE_ID,PARENT_TRANSACTION_ID)=(select SHIPMENT_LINE_ID,PARENT_TRANSACTION_ID  from RCV_TRANSACTIONS b  "+
                          " where a.SHIPMENT_HEADER_ID = b.SHIPMENT_HEADER_ID and b.attribute6=a.rcv_id||decode(a.TO_ORGANIZATION_ID,606,a.LINE_LOCATION_ID,a.sheet_no) and TRANSACTION_TYPE='RECEIVE' ) "+//modify by Peggy 20170928
                          //" PARENT_TRANSACTION_ID=(select TRANSACTION_ID  from RCV_TRANSACTIONS b  "+
                          //" where a.SHIPMENT_HEADER_ID = b.SHIPMENT_HEADER_ID and b.attribute6=a.rcv_id||a.sheet_no and TRANSACTION_TYPE='RECEIVE' )    "+  
                          " where SHIPMENT_HEADER_ID = '"+shipmentHeaderId+"' ";  
			PreparedStatement pstmtba=con.prepareStatement(sqlUa);  
            pstmtba.executeUpdate(); 
            pstmtba.close();   				 
				 
            //更新temp table 狀態
			//20170515 I13 接著做檢驗及入庫_起
            if (iorganizationId == 606)  //20170515				
            {   
				int a01Userid = 10900;  //宜蘭廠固定QC-DUNCAN_CHIANG 
				int a01Empid = 11806;   //宜蘭廠固定QC-DUNCAN_CHIANG 
	           	
				try   //start Accept
				{
					Statement stated=con.createStatement();
					ResultSet rsd=stated.executeQuery(" SELECT RCV_INTERFACE_GROUPS_S.NEXTVAL from dual");
					if (rsd.next())
					{ 	
						interface_group_id = rsd.getString(1);      
					}
					rsd.close();
					stated.close(); 	
									
                	String sqlRacc =" SELECT RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL RTID,RT.TRANSACTION_ID PARN_ID,RT.PO_LINE_ID,YPR.ITEM_ID,RT.QUANTITY, RT.UOM_CODE,RT.VENDOR_LOT_NUM,RT.ATTRIBUTE6,  "+
                                    " RT.UNIT_OF_MEASURE,RT.PO_HEADER_ID,RT.PO_LINE_LOCATION_ID,RT.ORGANIZATION_ID,RT.LOCATION_ID,RT.SHIPMENT_HEADER_ID,RT.SHIPMENT_LINE_ID  "+
                                    //" FROM YEW_PO_RCV_L YPR , RCV_TRANSACTIONS RT "+
									" FROM (SELECT DISTINCT SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ITEM_ID FROM YEW_PO_RCV_L WHERE SHIPMENT_HEADER_ID ='"+shipmentHeaderId+"') YPR "+ //modify by Peggy 20170928
									",RCV_TRANSACTIONS RT "+
									" WHERE YPR.SHIPMENT_HEADER_ID= RT.SHIPMENT_HEADER_ID "+
                                    " AND RT.DESTINATION_TYPE_CODE='RECEIVING' "+
									" AND  YPR.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID ";
									//" AND YPR.SHIPMENT_HEADER_ID ='"+shipmentHeaderId+"' "; 
					Statement stateRacc=con.createStatement();
					ResultSet rsRacc=stateRacc.executeQuery(sqlRacc);
	                while (rsRacc.next())
	                { 
						//寫入interface 
                   		String rcvAsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
    									"      LAST_UPDATED_BY, CREATED_BY, EMPLOYEE_ID, "+
    									"     TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
    									"     PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
    									"     TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
										"     SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
    									"     RECEIPT_SOURCE_CODE) "+
                        				" values(?,?,?,?,?,?,?,sysdate,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?) ";
  						PreparedStatement pstmtIa=con.prepareStatement(rcvAsql);  
  						pstmtIa.setInt(1,rsRacc.getInt("RTID"));  // INTERFACE_TRANSACTION_ID   				        
                    	//pstmtIa.setInt(2,a01Userid);  // GROUP_ID  固定丟USER的 USER_ID識別
						pstmtIa.setString(2,interface_group_id);  //modify by Peggy 20170929
						pstmtIa.setInt(3,rsRacc.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
                    	pstmtIa.setInt(4,a01Userid);  //  LAST_UPDATED_BY
				    	pstmtIa.setInt(5,a01Userid);  // CREATED_BY
						pstmtIa.setInt(6,a01Empid);  // EMPLOYEE_ID  ,宜蘭廠固定QC-DUNCAN_CHIANG
						pstmtIa.setString(7,"ACCEPT");  // TRANSACTION_TYPE
					//	pstmtIa.setDate(8,receivingDate);  // TRANSACTION_DATE
						pstmtIa.setString(8,"PENDING");  // PROCESSING_STATUS_CODE
						pstmtIa.setString(9,"BATCH");  // PROCESSING_MODE_CODE
						pstmtIa.setString(10,"PENDING");  // TRANSACTION_STATUS_CODE
						pstmtIa.setInt(11,rsRacc.getInt("PO_LINE_ID"));  // PO_LINE_ID
						pstmtIa.setInt(12,rsRacc.getInt("ITEM_ID"));  // ITEM_ID
						pstmtIa.setFloat(13,rsRacc.getFloat("QUANTITY"));  // QUANTITY
						pstmtIa.setString(14,rsRacc.getString("UNIT_OF_MEASURE"));  // UNIT_OF_MEASURE
						pstmtIa.setInt(15,rsRacc.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
						pstmtIa.setInt(16,rsRacc.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
						pstmtIa.setInt(17,rsRacc.getInt("ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
						pstmtIa.setString(18,"Y");  // VALIDATION_FLAG
						pstmtIa.setString(19,"RECEIVING");  // DESTINATION_TYPE_CODE
						pstmtIa.setInt(20,rsRacc.getInt("LOCATION_ID"));  // SHIP_TO_LOCATION_ID
						//pstmtI.setString(21,rsRacc.getString("UOM_CODE"));  // UOM_CODE
						pstmtIa.setString(21,rsRacc.getString("UOM_CODE"));  //改抓PO的UOM,modify by Peggy 20111230
						pstmtIa.setInt(22,rsRacc.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
						pstmtIa.setInt(23,rsRacc.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
						pstmtIa.setString(24,rsRacc.getString("ATTRIBUTE6"));  // ATTRIBUTE6
						pstmtIa.setString(25,rsRacc.getString("VENDOR_LOT_NUM"));  // VENDOR_LOT_NUM
                    	pstmtIa.setString(26,"VENDOR");   // RECEIPT_SOURCE_CODE
						pstmtIa.executeUpdate(); 
 						pstmtIa.close();
                    } // end while
	                rsRacc.close();
                    stateRacc.close(); 

		        	CallableStatement cs4a = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
			        //cs4a.setInt(1,a01Userid);			                        // 此次的 RCV Processor Group ID
					cs4a.setString(1,interface_group_id);	          //add by Peggy 20170929
					cs4a.setInt(2,loginUserId);                   //USER REQUEST 
         			cs4a.setInt(3,(iorganizationId==606?50264:50801));            //RESPONSIBILITY ID 
				    cs4a.registerOutParameter(4, Types.INTEGER);                  //回傳 REQUEST_ID
				    cs4a.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
			        cs4a.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE			
				    cs4a.execute();
               	    requestID = cs4a.getInt(4);   //  回傳 REQUEST_ID
				    devStatus = cs4a.getString(5);   //  回傳 REQUEST 執行狀況
				    devMessage = cs4a.getString(6);   //  回傳 REQUEST 執行狀況訊息
				    cs4a.close();		
				    out.print("<br>ACCEPT requestID:"+requestID);
				    out.print("devStatus:"+devStatus);
				    out.print("devMessage:"+devMessage);								
			    
					out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099' size='+1'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
				    out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
				    out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	

                    //抓成功與否
                    sqlrcvErr = " select  ERROR_MESSAGE from PO_INTERFACE_ERRORS   where ERROR_MESSAGE is not null and REQUEST_ID= '"+requestID+"'" ;
	                Statement stateRcvErra=con.createStatement();
                    ResultSet rsRcvErra=stateRcvErra.executeQuery(sqlrcvErr);
	                if (rsRcvErra.next())
                    {
                    	successInfo=rsRcvErra.getString(1);         // 此次匯入的GROUP id ,用TSCC_OM_STATUS_S.nextval沒有特別意思,隨便抓的
                    }
	                rsRcvErra.close();
                    stateRcvErra.close(); 					
					
					if ( successInfo==null || successInfo.equals("null") || successInfo.equals("SUCCESS"))  //成功的話回傳驗收單號及更新table
                    {
						out.println("<br>Delivery success!");
					} 
					else 
					{  
						out.println("Error Message:"+successInfo); 
					}
		       	}	// End of try
	            catch (Exception e) 
	            { 
					out.println("Exception acc request:"+e.getMessage()); 
				}	//acc 結束
					
 				//************************ delivery  ********************************************
				if ( successInfo==null || successInfo.equals("null") || successInfo.equals("SUCCESS"))  //成功的話才繼續執行入庫
                {				 
	           		try   //start Delivery
		            {
						Statement stated=con.createStatement();
						ResultSet rsd=stated.executeQuery(" SELECT RCV_INTERFACE_GROUPS_S.NEXTVAL from dual");
						if (rsd.next())
						{ 	
							interface_group_id = rsd.getString(1);      
						}
						rsd.close();
						stated.close(); 						
						
						String sqlRdel = " SELECT RT.TRANSACTION_ID PARN_ID"+
										 ",RT.PO_LINE_ID"+
										 ",YPR.ITEM_ID"+
										 //",RT.QUANTITY"+
										 ",YPR.RCV_QTY  QUANTITY"+ //modify by Peggy 20170928
										 ",RT.UOM_CODE"+
										 //",RT.VENDOR_LOT_NUM"+
										 ",YPR.VENDOR_LOT_NUM"+  //modify by Peggy 20170928
										 ",RT.ATTRIBUTE6"+
										 ",RT.UNIT_OF_MEASURE"+
										 ",RT.PO_HEADER_ID"+
										 ",RT.PO_LINE_LOCATION_ID"+
										 ",RT.ORGANIZATION_ID"+
										 ",RT.LOCATION_ID"+
										 ",RT.SHIPMENT_HEADER_ID"+
										 ",RT.SHIPMENT_LINE_ID"+
										 ",YPR.EXP_DATE  "+
                                         " FROM YEW_PO_RCV_L YPR "+
										 ",RCV_TRANSACTIONS RT "+
										 " WHERE YPR.SHIPMENT_HEADER_ID= RT.SHIPMENT_HEADER_ID "+
                                         " AND RT.TRANSACTION_TYPE='ACCEPT'"+
										 " AND YPR.SHIPMENT_LINE_ID= RT.SHIPMENT_LINE_ID"+
										 " AND YPR.SHIPMENT_HEADER_ID ='"+shipmentHeaderId+"' ";
	                    //out.print("sqlRacc="+sqlRacc);
 				   		Statement stateRDel=con.createStatement();
 				       	ResultSet rsRdel=stateRDel.executeQuery(sqlRdel);
	                   	while (rsRdel.next())
	                   	{ 
							//寫入interface 
							iexpDate=rsRdel.getString("EXP_DATE"); 
							rcv_qty =rsRdel.getDouble("QUANTITY")*(rsRdel.getString("UOM_CODE").equals("KPC")?1000:1); //add by Peggy 20170928
							i_loop_cnt =0;
							
							while (rcv_qty >0)
							{
								i_loop_cnt ++;
								if (i_loop_cnt>10) throw new Exception("loop cnt > 10");
								
								sql = " SELECT PO_DISTRIBUTION_ID,(NVL(A.QUANTITY_ORDERED,0)-NVL(A.QUANTITY_CANCELLED,0)-NVL(A.QUANTITY_DELIVERED,0)) * CASE WHEN B.UNIT_MEAS_LOOKUP_CODE='KPC' THEN 1000 ELSE 1 END AS OPEN_QTY"+
                                      " FROM PO_DISTRIBUTIONS_ALL A ,PO_LINE_LOCATIONS_ALL B"+
                                      " WHERE A.LINE_LOCATION_ID=B.LINE_LOCATION_ID"+
                                      " AND A.LINE_LOCATION_ID="+rsRdel.getString("PO_LINE_LOCATION_ID")+""+
                                      " AND NVL(A.QUANTITY_ORDERED,0)-NVL(A.QUANTITY_CANCELLED,0)-NVL(A.QUANTITY_DELIVERED,0) >0"+
                                      " ORDER BY A.DISTRIBUTION_NUM";
								Statement state1=con.createStatement();
								ResultSet rs1=state1.executeQuery(sql);
								while (rs1.next())
								{ 		
									po_distributions_id=rs1.getString("PO_DISTRIBUTION_ID");
									if (hashtb.get(po_distributions_id)==null)
									{
										if (rs1.getDouble("OPEN_QTY")>rcv_qty)
										{
											deliver_qty = rcv_qty;
											rcv_qty-=deliver_qty;
										}
										else
										{
											deliver_qty = rs1.getDouble("OPEN_QTY");
											rcv_qty-=deliver_qty;
										}
										hashtb.put(po_distributions_id,""+deliver_qty);
									}
									else
									{
										use_qty = Double.parseDouble((String)hashtb.get(po_distributions_id));
										//out.println(use_qty);
										if (rs1.getDouble("OPEN_QTY")-use_qty <=0) continue;
										if (rs1.getDouble("OPEN_QTY")-use_qty>rcv_qty)
										{
											deliver_qty =rcv_qty;
											rcv_qty-=deliver_qty;
										}
										else
										{
											deliver_qty =rs1.getDouble("OPEN_QTY")-use_qty;
											rcv_qty-=deliver_qty;
										}
										hashtb.put(po_distributions_id,""+(use_qty+deliver_qty));					
										
									}
									break;
								}
								rs1.close();
								state1.close();
								
								if (deliver_qty >0)
								{
									stated=con.createStatement();
									rsd=stated.executeQuery(" SELECT RCV_TRANSACTIONS_INTERFACE_S.NEXTVAL from dual");
									if (rsd.next())
									{ 	
										interface_trx_id=rsd.getString(1);  
									}
									rsd.close();
									stated.close(); 								

									String rcvDsql= " INSERT INTO RCV_TRANSACTIONS_INTERFACE (INTERFACE_TRANSACTION_ID,GROUP_ID,PARENT_TRANSACTION_ID, "+
													" LAST_UPDATED_BY, CREATED_BY,  "+
													" TRANSACTION_TYPE, TRANSACTION_DATE, PROCESSING_STATUS_CODE, PROCESSING_MODE_CODE, TRANSACTION_STATUS_CODE,  "+
													" PO_LINE_ID, ITEM_ID, QUANTITY, UNIT_OF_MEASURE,PO_HEADER_ID,PO_LINE_LOCATION_ID, "+ 
													" TO_ORGANIZATION_ID, VALIDATION_FLAG,DESTINATION_TYPE_CODE, "+
													" SHIP_TO_LOCATION_ID, UOM_CODE,SHIPMENT_HEADER_ID,SHIPMENT_LINE_ID,ATTRIBUTE6,VENDOR_LOT_NUM,LAST_UPDATE_DATE,CREATION_DATE, "+ 
													" RECEIPT_SOURCE_CODE,PO_DISTRIBUTION_ID) "+  
													" values(?,?,?,?,?,?,sysdate,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,sysdate,sysdate,?,?) ";
									PreparedStatement pstmtId=con.prepareStatement(rcvDsql);  
									//pstmtId.setInt(1,rsRdel.getInt("RTID"));  // INTERFACE_TRANSACTION_ID
									pstmtId.setString(1,interface_trx_id);  // INTERFACE_TRANSACTION_ID
									//pstmtId.setInt(2,loginUserId);  // GROUP_ID  固定丟USER的 USER_ID識別
									pstmtId.setString(2,interface_group_id);  //modif by Peggy 20170928
									pstmtId.setInt(3,rsRdel.getInt("PARN_ID"));  // PARENT_TRANSACTION_ID
									pstmtId.setInt(4,loginUserId);  //  LAST_UPDATED_BY
									pstmtId.setInt(5,loginUserId);  // CREATED_BY
									pstmtId.setString(6,"DELIVER");  // TRANSACTION_TYPE
									pstmtId.setString(7,"PENDING");  // PROCESSING_STATUS_CODE
									pstmtId.setString(8,"BATCH");  // PROCESSING_MODE_CODE
									pstmtId.setString(9,"PENDING");  // TRANSACTION_STATUS_CODE
									pstmtId.setInt(10,rsRdel.getInt("PO_LINE_ID"));  // PO_LINE_ID
									pstmtId.setInt(11,rsRdel.getInt("ITEM_ID"));  // ITEM_ID
									//pstmtId.setFloat(12,rsRdel.getFloat("QUANTITY"));  // QUANTITY
									pstmtId.setString(12,""+(deliver_qty/(rsRdel.getString("UNIT_OF_MEASURE").equals("KPC")?1000:1)));  // QUANTITY
									pstmtId.setString(13,rsRdel.getString("UNIT_OF_MEASURE"));  // UNIT_OF_MEASURE
									pstmtId.setInt(14,rsRdel.getInt("PO_HEADER_ID"));  // PO_HEADER_ID
									pstmtId.setInt(15,rsRdel.getInt("PO_LINE_LOCATION_ID"));  // PO_LINE_LOCATION_ID
									pstmtId.setInt(16,rsRdel.getInt("ORGANIZATION_ID"));  // TO_ORGANIZATION_ID
									pstmtId.setString(17,"Y");  // VALIDATION_FLAG
									pstmtId.setString(18,"INVENTORY");  // DESTINATION_TYPE_CODE
									pstmtId.setInt(19,rsRdel.getInt("LOCATION_ID"));  // SHIP_TO_LOCATION_ID
									pstmtId.setString(20,rsRdel.getString("UOM_CODE"));  //改抓PO的UOM,modify by Peggy 20111230
									pstmtId.setInt(21,rsRdel.getInt("SHIPMENT_HEADER_ID"));  // SHIPMENT_HEADER_ID
									pstmtId.setInt(22,rsRdel.getInt("SHIPMENT_LINE_ID"));  // SHIPMENT_LINE_ID
									pstmtId.setString(23,rsRdel.getString("ATTRIBUTE6"));  // ATTRIBUTE6
									pstmtId.setString(24,rsRdel.getString("VENDOR_LOT_NUM"));  // VENDOR_LOT_NUM
									pstmtId.setString(25,"VENDOR");   // RECEIPT_SOURCE_CODE
									pstmtId.setString(26,po_distributions_id);   // PO_DISTRIBUTIONS_ID
									pstmtId.executeUpdate(); 
									pstmtId.close();  						
							 
									// 入庫的部份需要多執行LOT INSERT____起
									String delRsqlb = " INSERT INTO MTL_TRANSACTION_LOTS_INTERFACE "+
													  " ( TRANSACTION_INTERFACE_ID, SOURCE_CODE,PROCESS_FLAG,CREATION_DATE, LAST_UPDATE_DATE,PRODUCT_CODE,PRODUCT_TRANSACTION_ID,  "+
													  " SOURCE_LINE_ID, LOT_NUMBER, TRANSACTION_QUANTITY,"+
													  " CREATED_BY,LAST_UPDATED_BY,LOT_EXPIRATION_DATE ) "+
													  " VALUES "+                                
													  " ( ?,'E1-011',1,SYSDATE,SYSDATE,'RCV',?,?,?,?,?,?,to_date("+iexpDate+",'yyyy/mm/dd')) ";									 								 									  
									PreparedStatement pstmtDb=con.prepareStatement(delRsqlb); 
									//pstmtDb.setInt(1,rsRdel.getInt("RTID"));   //TRANSACTION_INTERFACE_ID 
									//pstmtDb.setInt(2,rsRdel.getInt("RTID"));	//PRODUCT_TRANSACTION_ID					
									pstmtDb.setString(1,interface_trx_id);   //TRANSACTION_INTERFACE_ID 
									pstmtDb.setString(2,interface_trx_id);	//PRODUCT_TRANSACTION_ID					
									pstmtDb.setString(3,rsRdel.getString("SHIPMENT_LINE_ID"));  // SOURCE_LINE_ID				   
									pstmtDb.setString(4,rsRdel.getString("VENDOR_LOT_NUM"));  // LOT_NUMBER
									//pstmtDb.setFloat(5,rsRdel.getFloat("QUANTITY"));  // TRANSACTION_QUANTITY						
									pstmtDb.setString(5,""+(deliver_qty/(rsRdel.getString("UNIT_OF_MEASURE").equals("KPC")?1000:1)));  // TRANSACTION_QUANTITY						
									pstmtDb.setInt(6,loginUserId);  // CREATED_BY
									pstmtDb.setInt(7,loginUserId);  // LAST_UPDATED_BY
									pstmtDb.executeUpdate(); 
									pstmtDb.close();
								}
							}
	
                        } // end while
	                  	rsRdel.close();
                      	stateRDel.close(); 

		           		CallableStatement cs4d = con.prepareCall("{call TSC_IQC_RVCTP_REQUEST(?,?,?,?,?,?)}");
			         	//cs4d.setString(1,Integer.toString(loginUserId));			                        // 此次的 RCV Processor Group ID
						cs4d.setString(1,interface_group_id);        // add by Peggy 20170929
		         	    cs4d.setInt(2,loginUserId);                   //USER REQUEST 
         				cs4d.setInt(3,(iorganizationId==606?50264:50801));            //RESPONSIBILITY ID 
				        cs4d.registerOutParameter(4, Types.INTEGER);                  //回傳 REQUEST_ID
				        cs4d.registerOutParameter(5, Types.VARCHAR);                  //回傳 DEV_STATUS
			            cs4d.registerOutParameter(6, Types.VARCHAR);                  //回傳 DEV_MASSAGE			
				        cs4d.execute();
               	        requestID = cs4d.getInt(4);   //  回傳 REQUEST_ID
				        devStatus = cs4d.getString(5);   //  回傳 REQUEST 執行狀況
				        devMessage = cs4d.getString(6);   //  回傳 REQUEST 執行狀況訊息
				        cs4d.close();		
				        out.print("<br>Delivery requestID:"+requestID);
				        out.print("   devStatus:"+devStatus);
				        out.print("   devMessage:"+devMessage);								
			    
				        out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099' size='+1'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");							  
				        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>RCV Transaction Processor Success!! </FONT></TD><TD colspan=3>"+"</TD></TR>");
				        out.println("<TR bgcolor='#FFFFCC'><TD colspan=3><font color='#000099'>Processor Request Message </FONT></TD><TD colspan=3>"+devStatus+"("+devMessage+")"+"</TD></TR>");	

                        //抓成功與否
                        sqlrcvErr = " select  ERROR_MESSAGE from PO_INTERFACE_ERRORS   where ERROR_MESSAGE is not null and REQUEST_ID= '"+requestID+"'" ;
						Statement stateRcvErrd=con.createStatement();
                        ResultSet rsRcvErrd=stateRcvErrd.executeQuery(sqlrcvErr);
	                    if (rsRcvErrd.next())
                        {
                        	successInfo=rsRcvErrd.getString(1);         // 此次匯入的GROUP id ,用TSCC_OM_STATUS_S.nextval沒有特別意思,隨便抓的
                        }
	                    rsRcvErrd.close();
                        stateRcvErrd.close(); 					
					
					    if ( successInfo==null || successInfo.equals("null") || successInfo.equals("SUCCESS"))  //成功的話回傳驗收單號及更新table
                        {
							out.println("<br>Delivery success!");
					    } 
						else 
						{  
							out.println("<font color='#FF0000'>Error Message:"+successInfo+"</font>"); 
						}
					}	// End of try
	               	catch (Exception e) 
	                { 
						out.println("Exception delivery request:"+e.getMessage()); 
					}	//delivery 結束
				} //end 入庫的if				 
	        }  //end if 606  //2017I13 接著做檢驗及入庫_迄	
		} 
		else  //successInfo!="SUCCESS"   暫收失敗
		{  
        	String sqlrcvE = "  SELECT COLUMN_NAME||' / '||ERROR_MESSAGE FROM PO_INTERFACE_ERRORS WHERE INTERFACE_HEADER_ID = '"+rcvHeaderId+"'" ;
			//out.print("sqlrcvNo="+sqlrcvNo);
	        Statement stateRcvE=con.createStatement();
            ResultSet rsRcvE=stateRcvE.executeQuery(sqlrcvE);
	        if (rsRcvE.next())
            {
            	out.print("<BR><font color='#FF0000' SIZE='+2'>"+rsRcvE.getString(1)+"</FONT>");       
            }
	        rsRcvE.close();
            stateRcvE.close(); 

            out.print("<BR><font color='#FF0000' SIZE='+2'>轉入ERP失敗!!!</FONT>");

		    String  sqlUsc=" update APPS.YEW_PO_RCV_L set STATUS='FAILED',HEADER_INTERFACE_ID='"+rcvHeaderId+"' "+
                           "  where RCV_ID = '"+rcvId+"' and STATUS='OPEN' AND LINE_LOCATION_ID IS NOT NULL AND PO_STATUS='Y'  ";
			//out.print(" <BR>sqlUsc="+sqlUsc);
            PreparedStatement pstmtc=con.prepareStatement(sqlUsc);  
            pstmtc.executeUpdate(); 
            pstmtc.close();   
		}// end if successInfo 
	}	// End of try
	catch (Exception e) 
	{ 
		out.println("Exception call request:"+e.getMessage()); 
	}	
	   
    //顯示最後資訊______起
    try
    {
		String sqlinf= " SELECT SHEET_NO,PO_NO,LINE_NUM,ITEM_NO,RCV_QTY,UOM,VENDOR_LOT_NUM,PO_STATUS,STATUS,RECEIPT_NO,STATUS_DESC "+
 					   "  FROM YEW_PO_RCV_L WHERE RCV_ID='"+rcvId+"' ORDER BY TO_NUMBER(SHEET_NO) ";
		//out.print("<br>sqlLqty="+sqlLqty);
	    Statement stateinf=con.createStatement();
        ResultSet rsinf=stateinf.executeQuery(sqlinf);
%>
		<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="90%" align="left" bordercolorlight="#200025" border="1">
  	    	<tr bgcolor="#CCCC66"> 
	     		<td width="3%" height="20" nowrap><div align="center"><font color="#000066" face="Arial" size="2">識別</font></div></td>
  	     		<td width="2%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">項次</font></div></td>  
  	     		<td width="8%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">PO NO</font></div></td>  
  	     		<td width="2%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">PO LINE</font></div></td>          
	     		<td width="10%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">料號</font></div></td>
   	     		<td width="5%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">接收數</font></div></td>
   	     		<td width="3%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">單位</font></div></td>
	     		<td width="10%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">批號</font></div></td>	
	     		<td width="3%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">PO核准</font></div></td>
	     		<td width="9%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">驗收單號</font></div></td>	
	     		<td width="5%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">上傳狀態</font></div></td>	
	     		<td width="10%" nowrap><div align="center"><font color="#000066" face="Arial" size="2">錯誤說明</font></div></td>	
        	</tr>
<%
		while (rsinf.next())
	    {
        	String lineNo="",itemNo="",uom="",statusDesc="";

          	colorStr="#FFFFFF";
		  	//sheetNo=rsinf.getString("SHEET_NO"); 
		  	//poNo=rsinf.getString("PO_NO");
		  	lineNo=rsinf.getString("LINE_NUM");
		  	itemNo=rsinf.getString("ITEM_NO");
		  	rcvQtyf=rsinf.getFloat("RCV_QTY");
		  	uom=rsinf.getString("UOM");
		  	poStatus=rsinf.getString("PO_STATUS");
          	status=rsinf.getString("STATUS");
          	statusDesc=rsinf.getString("STATUS_DESC");
		  	receiptNo=rsinf.getString("RECEIPT_NO");
           	if (lineNo==null || lineNo.equals("null")) lineNo="&nbsp";
           	if (uom==null || uom.equals("null")) uom="&nbsp";
           	if (poStatus==null || poStatus.equals("null")) poStatus="&nbsp";
           	if (statusDesc==null || statusDesc.equals("null")) statusDesc="&nbsp";
           	if (receiptNo==null || receiptNo.equals("null")) 
            { 
				receiptNo="&nbsp"; 
              	colorStr="#FFFF99"; 
			}
%>
			<tr bgColor='<%=colorStr%>' > 
           		<td ><div align="center"><font color="" face="Arial" size="2"><%=rcvId%></font></div></td>
	       		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("SHEET_NO")%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("PO_NO")%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=lineNo%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("ITEM_NO")%></font></div></td>  
		   		<td ><div align="right"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("RCV_QTY")%>&nbsp;</font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=uom%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("VENDOR_LOT_NUM")%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=poStatus%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=receiptNo%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=rsinf.getString("STATUS")%></font></div></td>
		   		<td ><div align="center"><font color="#000066" face="Arial" size="2"><%=statusDesc%></font></div></td>
          	</tr>
<% 
		} //end while rsi
%>
		</table>
<%
        rsinf.close();
	    stateinf.close();
	}	// End of try
	catch (Exception e) 
	{ 
		out.println("Exception s:"+e.getMessage()); 
	}	
}  //end if pType=='3' 

if (pType == "4" || pType.equals("4"))
{
	String sqld =  " delete APPS.YEW_PO_RCV_L where RCV_ID ='"+rcvId+"'  ";
    //out.print("<br>sqlUC="+sqld);   			            
    PreparedStatement seqstmtd=con.prepareStatement(sqld); //out.println("Step1.1.2");    				
    seqstmtd.executeUpdate();
    seqstmtd.close(); 	

    response.sendRedirect("../jsp/TSCPoReceiptUpload.jsp");
}  //end if pType=='4' 


// pType=='5' 顯示轉入LOT NO 資訊_______起
if (pType == "5" || pType.equals("5"))
{
	float rcvQtySum = 0;
    String sqlLqty= " SELECT SHEET_NO,PO_NO,ITEM_NO,RCV_QTY,VENDOR_LOT_NUM FROM YEW_PO_RCV_L WHERE LINE_LOCATION_ID='"+locationId+"' AND RCV_ID='"+rcvId+"' ";
    //out.print("<br>sqlLqty="+sqlLqty);
	Statement stateLqty=con.createStatement();
    ResultSet rsLqty=stateLqty.executeQuery(sqlLqty);
%>
	<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
  		<tr bgcolor="#999966"> 
	   		<td width="3%" height="20" nowrap><div align="center"><font color="#006666" face="Arial" size="2">識別</font></div></td>
  	   		<td width="2%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">項次</font></div></td>  
  	   		<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">PO NO</font></div></td>           
	   		<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">料號</font></div></td>
   	   		<td width="9%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">接收數</font></div></td>
	   		<td width="10%" nowrap><div align="center"><font color="#006666" face="Arial" size="2">批號</font></div></td>	 
      	</tr>
<%
	while (rsLqty.next())
	{
    	rcvQtySum = rcvQtySum + rsLqty.getFloat("RCV_QTY");
%>
       	<tr bgColor='#FFFF99' onmouseover=bgColor='#FFCC33' onmouseout=bgColor='#FFFF99'> 
        	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rcvId%></font></div></td>
	    	<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsLqty.getString("SHEET_NO")%></font></div></td>
			<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsLqty.getString("PO_NO")%></font></div></td>
			<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsLqty.getString("ITEM_NO")%>&nbsp;</font></div></td>  
			<td ><div align="right"><font color="#006666" face="Arial" size="2"><%=rsLqty.getString("RCV_QTY")%>&nbsp;</font></div></td>
			<td ><div align="center"><font color="#006666" face="Arial" size="2"><%=rsLqty.getString("VENDOR_LOT_NUM")%></font></div></td>
       	</tr>
<%
	}
    rsLqty.close();
	stateLqty.close();
%>
   		<tr>
     		<td colspan="5"><div align="right"><font color="#006666" face="Arial" size="2" ><%=rcvQtySum%>&nbsp;</font></div></td>
     		<td>&nbsp;</td>
    	</tr>
	</table>
<% 
}  //end if pType=='4' 

%>

</FORM>
</body>
</html>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
