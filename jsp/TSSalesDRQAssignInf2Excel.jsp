<!-- 20160127 Peggy,增加開單人員-->
<!-- 20160805 Peggy,開放樣品rfq給他區查詢-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*,java.util.Base64" %>
<%@ page import="DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Upload File and Insert into Database</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<FORM ACTION="../jsp/TSSalesDRQAssignInf2Excel.jsp" METHOD="post" name="MYFORM">
<%
Base64.Decoder decoder = Base64.getDecoder();
String sqlGlobal = request.getParameter("SQLGLOBAL");
if (sqlGlobal!=null) sqlGlobal = sqlGlobal;
sqlGlobal=new String(decoder.decode(sqlGlobal), "UTF-8");
String RepCenterNo=request.getParameter("REPCENTERNO");   // 改抓Session內的登入資料
String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");  
String dnDocNo=request.getParameter("DNDOCNO");
String SWHERE=request.getParameter("SWHERECOND");
if (SWHERE!=null) SWHERE =SWHERE;
SWHERE=new String(decoder.decode(SWHERE), "UTF-8");
if (dnDocNo==null) dnDocNo = "";
if (dateStringBegin==null){dateStringBegin=dateBean.getYearMonthDay();}
if (dateStringEnd==null){dateStringEnd=dateBean.getYearMonthDay();}

String ymdCurr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();
String hmsCurr = dateBean.getHourMinuteSecond();
String ShipType=request.getParameter("SHIPTYPE");
String ShipName=request.getParameter("SHIPNAME");
String strHMSec = request.getParameter("HOURTIME");

String customerId=request.getParameter("CUSTOMERID");
String customerNo=request.getParameter("CUSTOMERNO");
String customerName=request.getParameter("CUSTOMERNAME");
if (customerId==null || customerId.equals("")) customerId="";
if (customerNo==null || customerNo.equals("")) customerNo="";
if (customerName==null || customerName.equals("")) customerName="";
  
try 
{ 	
	String sql = "";
	String sWhere = "";
 	String orderBy = "";
	String customer="";
	String tscItemDesc = "";
	String requestDate = "";
	String prodFactoryName="";
    String assignUserName="";
	String prodUserName="";
	String uom = "";
	String qty="";
	String schShipDate="";
	String remark="";
	String custPO = "";
    String statusCode="";
	String prodFName="";
	 
	if (sqlGlobal==null || sqlGlobal=="")
	{ 		
		sql =  " select c.curr,c.customer,d.*,e.MANUFACTORY_NAME ,f.username "+
		       ",f.username"+  //add by Peggy 20160128
			   ",case when nvl(d.EDIT_CODE,'')='R' then 'Y' else '' END reject_flag"+
		       " ,y.a_value rfq_type_name"+ //add by Peggy 202111119
	           " from ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
			   ",(SELECT USERNAME ,WEBID FROM (SELECT USERNAME,WEBID,ROW_NUMBER() OVER(PARTITION BY WEBID ORDER BY USERNAME) USER_SEQ FROM ORADDMAN.WSUSER) WHERE USER_SEQ =1) f "+ //add by Peggy 20160128
		       ",(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
		sWhere = " where c.DNDOCNO = d.DNDOCNO "+
	             " and d.assign_manufact = e.manufactory_no(+) "+
				 " and d.created_by=f.webid(+)"+  //add by Peggy 20160128
   			     " and c.rfq_type=y.a_seq(+) ";	
		   
	   	orderBy =  " ";	  
	 
	   	if (UserRoles=="admin" || UserRoles.equals("admin")) 
		{ 
		}  // 若為管理員,可看任一產地詢問單
	   	else
	   	{
			if (!UserName.equals("CCYANG") && !UserName.equals("RITA_ZHOU"))
			{
				//主要先判斷是屬於被指派產地人員方可檢視
				if (userProdCenterNo!=null && !userProdCenterNo.equals("--")) 
				{ 
					//add by Peggy 20140320
					if (UserRegionSet.equals(""))
					{
						sWhere=sWhere+" and d.ASSIGN_MANUFACT = '"+userProdCenterNo+"' ";
					}
					else
					{
						sWhere += " and (d.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or b.SALES_AREA_NO in ("+UserRegionSet+"))";
					}
				}
				else
				{
					if (customerNo.equals("10877") && !customerId.equals("") &&  !customerName.equals(""))  //add by Peggy 20160805
					{
						sWhere += " and b.SALES_AREA_NO ='020'"; 
					}
					else
					{
						//add by Peggy 20140305
						sWhere += " and b.SALES_AREA_NO in ("+UserRegionSet+",'020')";
					}
				} 
			}
	   	}       

	   	if (dnDocNo==null || dnDocNo.equals("")) 
	   	{
			//
		}
       	else 
	   	{
			sWhere=sWhere+" and d.DNDOCNO ='"+dnDocNo.trim()+"' "; 
		}	   
	   
	} 
	else
   	{
		sql = " select c.curr,c.customer,d.*,e.MANUFACTORY_NAME ,f.username"+
			  ",case when nvl(d.EDIT_CODE,'')='R' then 'Y' else '' END reject_flag"+
		      " ,y.a_value rfq_type_name"+ //add by Peggy 202111119
		      " from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
			  ",(SELECT USERNAME ,WEBID FROM (SELECT USERNAME,WEBID,ROW_NUMBER() OVER(PARTITION BY WEBID ORDER BY USERNAME) USER_SEQ FROM ORADDMAN.WSUSER) WHERE USER_SEQ =1) f "+ //add by Peggy 20160128
  	          ",(SELECT a_seq,a_value  FROM oraddman.tsc_rfq_setup  WHERE A_CODE='RFQ_TYPE') y";
		SWHERE += " and d.created_by=f.webid(+)";
		if (UserRoles=="admin" || UserRoles.equals("admin")) 
		{ 
		}  // 若為管理員,可看任一產地詢問單
	    else
		{
			// 優先判斷若人員屬於企劃人員,則不限定,(即所有廠區皆可檢視),否則只能看各別廠區的單子
			Statement statePlanner=con.createStatement();
            String sqlPlanner = "select USERNAME from ORADDMAN.TSSPLANER_PERSON where (USERID= '"+UserName+"' or UPPER(USERID)='"+UserName+"') ";
			ResultSet rsPlanner=statePlanner.executeQuery(sqlPlanner);
			if (!rsPlanner.next())
			{ 
				if (!UserName.equals("CCYANG") && !UserName.equals("RITA_ZHOU"))
				{
					//主要先判斷是屬於被指派產地人員方可檢視
					if (userProdCenterNo!=null && !userProdCenterNo.equals("--")) 
					{ 
						//add by Peggy 20140320
						if (UserRegionSet.equals(""))
						{
							SWHERE += " and d.ASSIGN_MANUFACT = '"+userProdCenterNo+"' ";
						}
						else
						{
							SWHERE += " and (d.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or b.SALES_AREA_NO in ("+UserRegionSet+"))";
						}
					}
					else
					{
						if (customerNo.equals("10877") && !customerId.equals("") &&  !customerName.equals(""))  //add by Peggy 20160805
						{
							SWHERE += " and b.SALES_AREA_NO ='020'"; 
						}
						else
						{
							SWHERE +=  " and b.SALES_AREA_NO in ("+UserRegionSet+",'020')";
						}
					}
				}
			}
			rsPlanner.close();
			statePlanner.close();	
	   	}       
	}
	
    Statement stateProd=con.createStatement();
    String sqlProd = "select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO= '"+userProdCenterNo+"' ";
    ResultSet rsProd=stateProd.executeQuery(sqlProd);
	if (rsProd.next())
	{
		prodFactoryName = rsProd.getString(1);
	}
	rsProd.close();
	stateProd.close();
	 
    Statement stateAssign=con.createStatement();
    String sqlAssign = "select b.USERID from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a,ORADDMAN.TSSPLANER_PERSON b where a.UPDATEUSERID = b.USERNAME and DNDOCNO= '"+dnDocNo+"' and ORISTATUSID='002' ";
    ResultSet rsAssign=stateAssign.executeQuery(sqlAssign);
	if (rsAssign.next())
	{
		assignUserName = rsAssign.getString(1);
	}
	rsAssign.close();
	stateAssign.close();
	 
	if (SWHERE==null || SWHERE=="" || SWHERE.equals("")) // 若為傳入條件式,則為單據
    {     
		sql = sql + sWhere + orderBy;
	}
    else // 否則則是查詢頁
    {      
    	sql = sql + SWHERE + orderBy;  // 測試傳表單參數 // 
	}
	
	//out.println(sql);
	
	// 產生報表
	OutputStream os = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\report\\"+userID+"_"+ymdCurr+hmsCurr+"_Query.xls"); 	
    jxl.write.WritableWorkbook wwb = Workbook.createWorkbook(os); 
    jxl.write.WritableSheet ws = wwb.createSheet("Sales Delivery Request", 0); //-- TEST
	jxl.SheetSettings sst = ws.getSettings(); 
	
    // 抬頭列字型15
	jxl.write.WritableFont wf2Title = new jxl.write.WritableFont(WritableFont.TIMES, 15,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Title = new jxl.write.WritableCellFormat(wf2Title); 
	wcf2Title.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    // 條件列字型12
    jxl.write.WritableFont wf2Cond = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcf2Cond = new jxl.write.WritableCellFormat(wf2Cond); 
	wcf2Cond.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    // Header 列背景灰色
    jxl.write.WritableFont wf2Header = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Header = new jxl.write.WritableCellFormat(wf2Header); 
	wcf2Header.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    wcf2Header.setBackground(jxl.format.Colour.GRAY_25); // 設定背景顏色
    // 內容 列 定義
    jxl.write.WritableFont wf2Content = new jxl.write.WritableFont(WritableFont.TIMES, 10,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.BLACK);
    jxl.write.WritableCellFormat wcf2Content = new jxl.write.WritableCellFormat(wf2Content); 
	wcf2Content.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    //wcf2Content.setBackground(jxl.format.Colour.GRAY_25); // 	  
	
	jxl.write.WritableFont wfT = new jxl.write.WritableFont(WritableFont.TIMES, 10, WritableFont.BOLD, false, UnderlineStyle.SINGLE); 
    jxl.write.WritableCellFormat wcfT = new jxl.write.WritableCellFormat(wfT); 
	wcfT.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN); 
    wcfT.setAlignment(jxl.format.Alignment.LEFT);
	
	sst.setSelected();
	sst.setVerticalFreeze(7);
	sst.setFitToPages(true);	
	sst.setFitWidth(1);  // 設定一頁寬
			
	//file://抬頭:(第0列第1行)
    jxl.write.WritableFont wf1 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF1 = new jxl.write.WritableCellFormat(wf1); 
	//wcfF1.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
	wcfF1.setAlignment(jxl.format.Alignment.CENTRE);
    jxl.write.Label labelCF1 = new jxl.write.Label(0, 0, "TAIWAN  SEMICONDUCTOR  CO.,  LTD.", wcfF1);  // (行,列)
    ws.addCell(labelCF1);
	ws.mergeCells(0, 0, 6, 0);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 6);
	
	//file://抬頭:(第1列第1行)
	jxl.write.WritableFont wf2 = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false,UnderlineStyle.NO_UNDERLINE); 
    jxl.write.WritableCellFormat wcfF2 = new jxl.write.WritableCellFormat(wf2); 
	wcfF2.setAlignment(jxl.format.Alignment.CENTRE);
	//wcfF2.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
    jxl.write.Label labelCF2 = new jxl.write.Label(0, 1, "交  期  詢  問  回  覆  單", wcfF2);  // (行,列)
    ws.addCell(labelCF2);
	ws.mergeCells(0, 1, 6, 1);  //ws.mergeCells(int col1, int row1, int col2, int row2) // 合併儲存格
	ws.setColumnView(0, 15);
                                     
    //2005.5.26 Gray end
    //抬頭:(第0列第2行)
    jxl.write.WritableFont wfc = new jxl.write.WritableFont(WritableFont.ARIAL,12,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,jxl.format.Colour.RED); 
    jxl.write.WritableCellFormat wcfFC = new jxl.write.WritableCellFormat(wfc); 
    jxl.write.Label labelCFC1 = new jxl.write.Label(0, 3, prodFactoryName, wcfFC);  // 取工廠產地名稱 // (行,列)
    ws.addCell(labelCFC1);
	ws.setColumnView(0, 10);

	jxl.write.Label labelCFC2 = new jxl.write.Label(4, 3, "NO: "+dnDocNo, wcfFC); // 指派人員(行,列)
    ws.addCell(labelCFC2);
	ws.setColumnView(1, 10);
	
	jxl.write.Label labelCFC20 = new jxl.write.Label(5, 3, assignUserName, wcfFC); // 指派人員(行,列)
    ws.addCell(labelCFC20);
	ws.setColumnView(1, 10);
	
	jxl.write.Label labelCFC30 = new jxl.write.Label(0, 4, "ATTE:", wcfFC); // 指派人員(行,列)
    ws.addCell(labelCFC30);
	ws.setColumnView(0, 10);
	
	//抬頭:(第0列第3行) 
    jxl.write.Label labelCF3 = new jxl.write.Label(1, 4, prodUserName, wcfFC); // 工廠人員名稱(行,列)
    ws.addCell(labelCF3);
	ws.setColumnView(0, 10);	
	
	//抬頭:(第5行第4行)
	jxl.write.Label labelCF4 = new jxl.write.Label(5, 4, "Date", wcfF1); // 單據日期抬頭(行,列)
    ws.addCell(labelCF4);
	ws.setColumnView(4, 10);
	//抬頭:(第0列第5行)
	if (dnDocNo!=null && dnDocNo.length()>=8) 
	{
		jxl.write.Label labelCF5 = new jxl.write.Label(6, 4, dnDocNo.substring(5,13), wcfF1); // 單據日期(行,列)
	 	ws.addCell(labelCF5);
	 	ws.setColumnView(6, 15);
	}
	else
	{
		jxl.write.Label labelCF5 = new jxl.write.Label(6, 4, dateBean.getYearMonthDay(), wcfF1); // 單據日期(行,列)
	 	ws.addCell(labelCF5);
	 	ws.setColumnView(6, 15);
	} 
	
	//抬頭:(第6列第0行)		// 明細抬頭說明
	jxl.write.Label labelCF13 = new jxl.write.Label(0, 6, "交期詢問單號", wcfT); // (行,列)
    ws.addCell(labelCF13);
	ws.setColumnView(0, 20);
	
	jxl.write.Label labelCFC6 = new jxl.write.Label(1, 6, "客戶名稱", wcfT); // (行,列)
    ws.addCell(labelCFC6);
	ws.setColumnView(1, 20);
	
	//抬頭:(第6列第1行)
	jxl.write.Label labelCF7 = new jxl.write.Label(2, 6, "台半品名", wcfT); // (行,列)
    ws.addCell(labelCF7);
	ws.setColumnView(2, 20);
	//抬頭:(第6列第2行)
	jxl.write.Label labelCF8 = new jxl.write.Label(3, 6, "單位", wcfT); // (行,列)
    ws.addCell(labelCF8);
	ws.setColumnView(3, 5);
	//抬頭:(第6列第3行)
	jxl.write.Label labelCF9 = new jxl.write.Label(4, 6, "數量", wcfT); // (行,列)
    ws.addCell(labelCF9);
	ws.setColumnView(4, 8);
	//抬頭:(第6列第4行)
	jxl.write.Label labelCFC10 = new jxl.write.Label(5, 6, "需求日期", wcfT); // (行,列)
    ws.addCell(labelCFC10);
	ws.setColumnView(5, 10);
	//抬頭:(第6列第5行)
	jxl.write.Label labelCFC11 = new jxl.write.Label(6, 6, "預交日期", wcfT); // (行,列)
    ws.addCell(labelCFC11);
	ws.setColumnView(6, 10);
	//抬頭:(第6列第6行)
	jxl.write.Label labelCF12 = new jxl.write.Label(7, 6, "備註說明", wcfT); // (行,列)
    ws.addCell(labelCF12);
	ws.setColumnView(7, 25);
	
	jxl.write.Label labelCPO = new jxl.write.Label(8, 6, "客戶訂購單號 ", wcfT); // (行,列)
    ws.addCell(labelCPO);
	ws.setColumnView(8, 20);

	jxl.write.Label labelCFM = new jxl.write.Label(9, 6, "生產廠別", wcfT); // (行,列)
    ws.addCell(labelCFM);
	ws.setColumnView(9, 40);
	
	jxl.write.Label labelUserName = new jxl.write.Label(10, 6, "開單人員", wcfT); // (行,列)
    ws.addCell(labelUserName);
	ws.setColumnView(10, 20);

	jxl.write.Label labelcurr = new jxl.write.Label(11, 6, "幣別", wcfT); //add by Peggy 20181203
    ws.addCell(labelcurr);
	ws.setColumnView(11, 12);

	jxl.write.Label labelstatus = new jxl.write.Label(12, 6, "狀態", wcfT); //add by Peggy 20190912
    ws.addCell(labelstatus);
	ws.setColumnView(12, 12);

	jxl.write.Label labelreject = new jxl.write.Label(13, 6, "是否Reject", wcfT); //add by Peggy 20190912
    ws.addCell(labelreject);
	ws.setColumnView(13, 12);

	jxl.write.Label labelpcremarks = new jxl.write.Label(14, 6, "PC Remarks", wcfT); //add by Peggy 20190912
    ws.addCell(labelpcremarks);
	ws.setColumnView(14, 12);
		
	int noSeq = 0;
	String noSeqStr = "";
	int colNo = 1;
	int rowNo = 7;
		
    //out.println(sql+"<BR>"); 
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery(sql); 		
	while (rs.next())
	{	
		noSeq = noSeq + 1;
		noSeqStr = Integer.toString(noSeq);
		  
		jxl.write.WritableFont wfL = new jxl.write.WritableFont(WritableFont.TIMES, 12,WritableFont.BOLD, false, UnderlineStyle.NO_UNDERLINE); 
        jxl.write.WritableCellFormat wcfFL = new jxl.write.WritableCellFormat(wfL);
		wcfFL.setBackground(jxl.format.Colour.ICE_BLUE); // 設定背景顏色	 
		wcfFL.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);  
		   
		dnDocNo = rs.getString("DNDOCNO");
		jxl.write.Label lable10 = new jxl.write.Label(0, rowNo, dnDocNo , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(lable10);
		  
		customer=rs.getString("CUSTOMER");
		if ((customer == null ||  customer.equals("")))
		{
			customer ="";
		}	 
	    jxl.write.Label lable11 = new jxl.write.Label(1, rowNo, customer , wcfFL); // (行,列);由第七列開始顯示動態資料
        ws.addCell(lable11);
		  
		tscItemDesc=rs.getString("ITEM_DESCRIPTION");
		if ((tscItemDesc == null ||  tscItemDesc.equals("")))
		{
			tscItemDesc ="";
		}		 		       
	    jxl.write.Label lable21 = new jxl.write.Label(2, rowNo, tscItemDesc , wcfFL); // (行,列); 台半料號
        ws.addCell(lable21);
		 
		uom=rs.getString("PRIMARY_UOM");
		if ((uom == null ||  uom.equals("")))
		{
			uom ="";
		}
		jxl.write.Label lable31 = new jxl.write.Label(3, rowNo, uom , wcfFL); // (行,列); 單位
        ws.addCell(lable31);
		  
		qty=rs.getString("QUANTITY");					  
		jxl.write.Label lable41 = new jxl.write.Label(4, rowNo, qty , wcfFL); 
        ws.addCell(lable41);		
          
		if (rs.getString("REQUEST_DATE").length() >8)
		{  
			requestDate=rs.getString("REQUEST_DATE").substring(0,8);
		}
		else
		{
			requestDate=rs.getString("REQUEST_DATE");
		}
		
		if ((requestDate == null ||  requestDate.equals("")))
		{
			requestDate ="";
		}
		jxl.write.Label lable51 = new jxl.write.Label(5, rowNo, requestDate , wcfFL); 
        ws.addCell(lable51);		  
		 
		statusCode=rs.getString("LSTATUSID");
		schShipDate=rs.getString("SHIP_DATE");
		if ((schShipDate == null ||  schShipDate.equals("N/A")))
		{ 
			schShipDate =""; 
		}
		else 
		{ 
			if (schShipDate.length()>=8) schShipDate = schShipDate.substring(0,8);
	   	}
         
		//20100106 工廠未回覆前,不允許顯示預交日 liling for YEW ISSUE
        if( statusCode=="003" || statusCode=="004" || statusCode.equals("003") || statusCode.equals("004") )
        { 
			schShipDate ="N/A"; 
		}
		jxl.write.Label lable61 = new jxl.write.Label(6, rowNo, schShipDate , wcfFL); 
        ws.addCell(lable61);
		  
		remark=rs.getString("REMARK");  //顯示Line remarks,modify by Peggy 20180918		  			  
		jxl.write.Label lable71 = new jxl.write.Label(7, rowNo, remark , wcfFL); 
        ws.addCell(lable71);	
		
		custPO=rs.getString("CUST_PO_NUMBER"); //add by Peggy 20121119
		if (custPO ==null || custPO.equals(""))
		{  
			custPO=rs.getString("CUST_PO");		  			  
		}
		jxl.write.Label lable81 = new jxl.write.Label(8, rowNo, custPO , wcfFL); 
        ws.addCell(lable81);	

  		//modify by Peggychen 20110726 
		prodFName = rs.getString("MANUFACTORY_NAME");
		jxl.write.Label lable91 = new jxl.write.Label(9, rowNo, prodFName , wcfFL); 
        ws.addCell(lable91);
		  
  		//add by Peggy 20160128
		jxl.write.Label lable101 = new jxl.write.Label(10, rowNo, rs.getString("UserName") , wcfFL); 
        ws.addCell(lable101);	

		//add by Peggy 20181203
		jxl.write.Label lable111 = new jxl.write.Label(11, rowNo, rs.getString("CURR") , wcfFL); 
        ws.addCell(lable111);	

		//add by Peggy 20190912
		jxl.write.Label lable112 = new jxl.write.Label(12, rowNo, rs.getString("LSTATUS") , wcfFL); 
        ws.addCell(lable112);	

		//add by Peggy 20190912
		jxl.write.Label lable113 = new jxl.write.Label(13, rowNo, rs.getString("reject_flag") , wcfFL); 
        ws.addCell(lable113);	

		//add by Peggy 20190912
		jxl.write.Label lable114 = new jxl.write.Label(14, rowNo,((rs.getString("REASONDESC")==null||rs.getString("REASONDESC").equals("N/A"))?"":rs.getString("REASONDESC")) , wcfFL); 
        ws.addCell(lable114);	
				  
		rowNo = rowNo + 1;
	} 
	rs.close();
	statement.close();

	//寫入Excel 
	wwb.write(); 
   	wwb.close();
   	os.close();
   	out.close(); 
} 
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 	
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%
   response.reset();
   response.setContentType("application/vnd.ms-excel");					
   response.sendRedirect("/oradds/report/"+userID+"_"+ymdCurr+hmsCurr+"_Query.xls");  

%>

</html>
