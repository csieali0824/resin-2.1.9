<!--20140825 by Peggy,新增ERP END CUSTOMER ID欄位-->
<!--20141226 by Peggy,修正line type寫法-->
<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!--20190221 by Peggy,新增end customer name欄位-->
<!--20190227 by Peggy,新增quote number欄位-->
<%@ page contentType="text/html; charset=big5" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Excel Upload To Create a TSCR New RFQ Order</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setCreate(URL)
{  
	if (document.form1.UPLOADFILE.value == "")
	{
		alert("請選擇上傳檔案!");
		document.form1.UPLOADFILE.focus();
		return false;		
	}
	var filename = document.form1.UPLOADFILE.value;
	filename = filename.substr(filename.length-4);
	if (filename.toUpperCase() != ".XLS")
	{
		alert('上傳檔案必須為office 2003 excel檔!');
		document.form1.UPLOADFILE.focus();
		return false;	
	}
    document.form1.submit1.disabled=true;
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
<STYLE TYPE='text/css'> 
 td {word-break:break-all}
</STYLE>
</head>
<body>
<%
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE == null) ACTIONCODE = "";
String SalesAreaNo = "009";
String SalesAreaName = "半導體事業部-R.O.W.";
String SalesArea = "("+SalesAreaNo+")"+SalesAreaName;
String SAMPLEFILE = request.getParameter("SAMPLEFILE");
if (SAMPLEFILE ==null) SAMPLEFILE="";
int icnt=0,ErrCnt=0,sRow=2,rec_cnt=0,insert_cnt=0;
String seqno="",seqkey="";
String salesPerson="",toPersonID="";
String strCustNo="",strCustID="",strLineCustPO="",strLineCustPOLineNo="",strLineRemark="",FOBList="",ShippingMethodList="",urlDir ="",OrderTypeList="";
String sql = "",strOtypeID ="",strUOM="",strFactory="",strHeaderOrderType="",strLineOrderType="",strLineOrderTypeID="",strItemID="";
String strLineType="",strItemName ="",strOrderType="",strCustName="",strCustPO="",strRFQType="",strItemDesc="";
String strQty="",strCustItem="",strSellingPrice="",strSellingPrice_Q="",strCRD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strErr="",strHearCustPO="";
String strEndCustID ="",strEndCustID1=""; //add by Peggy 20140825
String strEndCustName="",strQuoteNumber="",strItemNoPacking="",strCustPOLineNo_flag=""; //add by Peggy 20190221
String oneDArray[] = new String [27];
String aa [][] = new String[1][1];

%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<table width="100%" align="center" border="0">
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
				<tr>
					<td height="50" align="center">
						<font color="#003399" size="+2" face="Arial Black">TSCR </font>
						<font color="#000000" size="+2" face="Times New Roman"> <strong>  Excel Upload To Create a New RFQ Order</strong></font>
					</td>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
			<table align="center" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
				<tr>
					<TD width="85%">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td bgcolor="#3E9C30" width="15%" height="20" align="center" style="border-color:#3E9C30;border:insert;color:#ffffff;font-family:Arial;font-size:14px">Excel匯入</td>
								<td bgcolor="#CECECE" width="15%" align="center"><a href="../jsp/TSCROWImportHistory.jsp" style="color:000000;font-family:Arial;font-size:14px;text-decoration:none;">待處理明細</a></td>
								<td width="70%" style="border-color:ffffff;">&nbsp;</td>
							</tr>
						</table>
					</TD>
					<TD align="right" width="15%" title="回首頁!">
						<A HREF="../ORAddsMainMenu.jsp" style="font-size:14px;font-family:標楷體;text-decoration:none;color:#0000FF">
						<STRONG>回首頁</STRONG>
						</A>
					</TD>
				</tr>
				<tr><td height="10" colspan="2" bgcolor="#3E9C30"></td></tr>
				<tr>
					<td colspan="2">
						<table  bordercolordark="#508040" cellspacing="0"  cellpadding="0" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  				<tr>
								<td style="color:#ffffff;font-size:14px;font-family:標楷體;background-color:#3E9C30">業務區域：</td>
								<td ><input type="text" style="border:none;font-family:ARIAL;font-size:14px" size="80" name="SalesArea" value="<%=SalesArea%>" oonkeydown="return (event.keyCode!=8);" readonly>
			  				</tr>
			  				<tr>
								<td style="color:#ffffff;font-size:14px;font-family:Verdana;background-color:#3E9C30">Upload File：</td>
								<td width="85%" ><INPUT TYPE="FILE" style="font-family:ARIAL;font-size:14px" NAME="UPLOADFILE" size="90"></td>
			  				</tr>
			  				<tr>
								<td style="color:#ffffff;font-size:14px;font-family:Verdana;background-color:#3E9C30">Sample File：</td>
								<td width="85%" ><A HREF="../jsp/samplefiles/D4-012_SampleFile.xls"><font style="font-size:14px;font-family:arial">Download Sample File</font></A></td>
			  				</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" title="請按我，謝謝!">
					<input type="button" style="font-size:14px;font-family:arial" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCROWExcelImport.jsp?ACTIONCODE=INSERT')">
					</td>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
<%
if (ACTIONCODE.equals("INSERT"))
{
	try
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		String strDate=dateBean.getYearMonthDay();
		String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond(); 
		//dateBean.setAdjDate(7);
		dateBean.setAdjDate(6);  //7天統一包含當天
		String strCHKDate = dateBean.getYearMonthDay();
		//dateBean.setAdjDate(-7);
		dateBean.setAdjDate(-6); //7天統一包含當天
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();
		if (uploadFile_name == null || uploadFile_name.equals("") )
		{
			out.println("<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的office 2003 excel檔，謝謝!')</script>");
		}
		else if (!(uploadFile_name.toLowerCase()).endsWith("xls"))
		{
			out.println("<script language=javascript>alert('上傳檔案必須為office 2003 excel檔!')</script>");
		}
		else
		{
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
		
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
					
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4012_"+strDateTime+"-"+uploadFile_name;
			upload_file.saveAs(uploadFilePath); 
			java.util.Date datetime = new java.util.Date();
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String CreationDate = (String) formatter.format( datetime );
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);

			//出貨方式list
			Statement statet=con.createStatement();
			sql = "select a.SHIPPING_METHOD_CODE ,a.SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a ";
        	ResultSet rst=statet.executeQuery(sql);
			while (rst.next())
			{
				ShippingMethodList += (rst.getString("SHIPPING_METHOD")+"@"+rst.getString("SHIPPING_METHOD_CODE")+";");
			}

			//FOB list
			sql = "select distinct a.FOB_CODE from OE_FOBS_ACTIVE_V a ";
        	rst=statet.executeQuery(sql);
			while (rst.next())
			{
				FOBList += (rst.getString("FOB_CODE")+";");
			}
			
			//ORDER TYPE list
			sql = " select DISTINCT ORDER_NUM,OTYPE_ID from ORADDMAN.TSAREA_ORDERCLS  where  ACTIVE ='Y' and SAREA_NO='"+SalesAreaNo+"'";
			rst = statet.executeQuery(sql);
			while (rst.next())
			{
				OrderTypeList += (rst.getString("ORDER_NUM")+"@"+rst.getString("OTYPE_ID")+";");
			}
			rst.close();
			statet.close();
			
			//add by Peggy 20140820
			sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
				  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
				  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SalesAreaNo+"') d"+
				  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
				  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
				  " and a.STATUS = b.STATUS "+
				  " and a.ORG_ID = b.ORG_ID "+										
				  " and a.ORG_ID = d.PAR_ORG_ID"+
				  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
				  " and c.STATUS='A'"+
				  " order by c.customer_id";
			Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rss = statements.executeQuery(sql);	
			
			////add by Peggy 20220606
			//sql = "	SELECT a.quote_id, a.tsc_partno,a.currency_code, TO_CHAR(a.price_k_usd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(CREATED_BY),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(CREATED_BY),'JUNE')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.end_customer end_customer"+
            //      " FROM oraddman.tsc_quote_data a order by a.quote_id, a.tsc_partno";
			//	  //" where trunc(sysdate) between to_date(a.from_date,'yyyy/mm/dd') and to_date(a.to_date,'yyyy/mm/dd')";
			//Statement statementn=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			//ResultSet rsn = statementn.executeQuery(sql);					
			
			//RFQ類型
			jxl.Cell cellRFQType = sht.getCell(1,0); 
			strRFQType = cellRFQType.getContents();
				
			arrayRFQDocumentInputBean.setArrayString(oneDArray);
			aa = new String[sht.getRows()-sRow][oneDArray.length];
			//out.println("aa="+aa.length);
			
			//line detail
			for (int i = sRow; i < sht.getRows(); i++) 
			{
				//客戶ID
				jxl.Cell cellCustNo = sht.getCell(0,i);
				strCustNo = cellCustNo.getContents();
				
				//訂單類型
				jxl.Cell cellOdrType = sht.getCell(1,i);
				strLineOrderType = cellOdrType.getContents();
				if (strLineOrderType==null) strLineOrderType ="";
				
				//CUSTOMER PO
				jxl.Cell cellLineCustPO = sht.getCell(2, i);          
				strLineCustPO = (cellLineCustPO.getContents()).trim();

				//CUSTOMER PO LINE NUMBER
				jxl.Cell cellLineCustPOLineNo = sht.getCell(3, i);  
				strLineCustPOLineNo = (cellLineCustPOLineNo.getContents()).trim();
				//if (strLineCustPOLineNo == null || strLineCustPOLineNo.equals("")) strLineCustPOLineNo = strLineCustPO;
				if (strLineCustPOLineNo == null || strLineCustPOLineNo.equals("")) strLineCustPOLineNo =""; //add by Peggy 20221221
				
				//台半品名
				jxl.Cell cellItemDesc = sht.getCell(4, i);          
				strItemDesc = (cellItemDesc.getContents()).trim();
				if (strItemDesc == null) strItemDesc= "";

				//台半料號
				jxl.Cell cellItemName = sht.getCell(5, i);          
				strItemName = (cellItemName.getContents()).trim();
				if (strItemName == null) strItemName= "";

				//客戶品號
				jxl.Cell cellCustItem = sht.getCell(6, i);          
				strCustItem = (cellCustItem.getContents()).trim();
				if (strCustItem == null) strCustItem= "";

				if (strItemDesc.equals("") && strItemName.equals("") && strCustItem.equals("")) continue;
				
				//數量
				jxl.Cell cellQty = sht.getCell(7, i);  
				if (cellQty.getType() == CellType.NUMBER) 
				{
					strQty = ""+((NumberCell) cellQty).getValue();
				} 
				else strQty = (cellQty.getContents()).trim();
				if (strQty == null) strQty="0";
				
				//單價
				jxl.Cell cellSellingPrice = sht.getCell(8, i);  
				if (cellSellingPrice.getType() == CellType.NUMBER) 
				{
					strSellingPrice = ""+((NumberCell) cellSellingPrice).getValue();
				} 
				else strSellingPrice = (cellSellingPrice.getContents()).trim();
				if (strSellingPrice == null) strSellingPrice="0";
			
				SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
				// CRD
				try
				{
					jxl.Cell cellCRD = sht.getCell(9, i);           
					strCRD =sy1.format(((DateCell)cellCRD).getDate());
				}
				catch(Exception e)
				{
					strCRD ="";
				}
				
				//交貨日期
				try
				{
					jxl.Cell cellRequestDate = sht.getCell(10, i);           
					strRequestDate =sy1.format(((DateCell)cellRequestDate).getDate());
				}
				catch(Exception e)
				{
					strRequestDate ="";
				}
				
				//出貨方式
				jxl.Cell cellShippingMethod = sht.getCell(11, i);          
				strShippingMethod = (cellShippingMethod.getContents()).trim();
									
				//FOB
				jxl.Cell cellFOB = sht.getCell(12, i);          
				strFOB = (cellFOB.getContents()).trim();
					
				//REMARK
				jxl.Cell cellRemark = sht.getCell(13, i);          
				strLineRemark = (cellRemark.getContents()).trim();
				
				//END CUSTOMER ID,add by Peggy 20140825
				jxl.Cell cellEndCustID = sht.getCell(14, i);          
				strEndCustID = (cellEndCustID.getContents()).trim();
				if (strEndCustID==null) strEndCustID="";				
				
				//END CUSTOMER NAME,add by Peggy 20190221
				jxl.Cell cellEndCustName = sht.getCell(15, i);          
				strEndCustName = (cellEndCustName.getContents()).trim();
				if (strEndCustName==null) strEndCustName="";

				//Quote Number,add by Peggy 20190227
				jxl.Cell cellQuoteNumber = sht.getCell(16, i);          
				strQuoteNumber = (cellQuoteNumber.getContents()).trim();
				if (strQuoteNumber==null) strQuoteNumber="";
								
				strErr ="";strCustID="";strCustName="";strItemID="";rec_cnt=0;strUOM="";strFactory="";strOrderType="";strLineOrderTypeID="";strItemNoPacking="";strCustPOLineNo_flag="";//初始化
				
				//客戶代號
				if (strCustNo == null || strCustNo.equals(""))
				{
					strErr += "客戶代號不可空白<br>";
				}
				else
				{
					Statement statementa=con.createStatement();
					ResultSet rsa=statementa.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME,NVL((SELECT 'Y' FROM ORADDMAN.tscust_special_setup c WHERE sales_area_no ='009' AND c.customer_id=a.customer_id and active_flag='A') ,'N') custPOLineNo_flag"+
                                                          " from ar_CUSTOMERS a where status = 'A'  and CUSTOMER_NUMBER ='"+strCustNo+"'");
					if(rsa.next())
					{
						strCustID = rsa.getString("CUSTOMER_ID"); 
						strCustName=rsa.getString("CUSTOMER_NAME");
						strCustPOLineNo_flag =rsa.getString("custPOLineNo_flag"); //add by Peggy 20221230
					}
					else
					{
						strErr += "ERP查無客戶資訊<br>";
						
					}
					rsa.close();
					statementa.close(); 
				}
				//customer po
				if (strLineCustPO==null || strLineCustPO.equals(""))
				{
					strErr += "Customer PO不可空白<br>";
				}
				
				//檢查客戶+customer po是否有待處理資料
				if (strCustNo != null && !strCustNo.equals("") && strLineCustPO !=null && !strLineCustPO.equals(""))
				{
					Statement statementa=con.createStatement();
					ResultSet rsa=statementa.executeQuery("select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where SALESAREANO = '009'  and CUSTOMER_NO ='"+strCustNo+"' AND CUSTOMER_PO='"+ strLineCustPO+"' AND CREATE_FLAG='N'");
					if(rsa.next())
					{
						strErr += "請先解決待處理資料後再上傳<br>";
					}
					rsa.close();
					statementa.close(); 
				}
				
				//品名	
				if ((strItemName  == null || strItemName.equals("")) && (strItemDesc  == null || strItemDesc.equals("")) && (strCustItem == null && strCustItem.equals("")))
				{
					strItemName = "";
					strItemDesc = "";
					strCustItem = "";
					strErr += "台半品名,料號及客戶品名不可同時空白<br>";
				}
				else
				{ 
					if (strCustItem != null && !strCustItem.equals(""))
					{						  
						sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
							  " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
							  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
							  //" ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
							  " ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE"+  //modify by Peggy 20191122
							  " ,tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking"+ //add by Peggy 20220715
							  " from oe_items_v a"+
							  " ,inv.mtl_system_items_b msi "+
							  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
							  " where a.SOLD_TO_ORG_ID = '"+strCustID+"' "+
							  " and a.organization_id = msi.organization_id"+
							  " and a.inventory_item_id = msi.inventory_item_id"+
							  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
							  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
							  " and msi.ORGANIZATION_ID = '49'"+
							  " and c.CATEGORY_SET_ID = 6"+
							  " and a.CROSS_REF_STATUS='ACTIVE'"+
						      " and msi.inventory_item_status_code <> 'Inactive'"+//add by Peggy 20130221
						      " and tsc_get_item_coo(msi.inventory_item_id) =(\n" + //add by Mars 20250108
							  "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
							  "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+ //add by Mars 20250108
							  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230202
						if (strCustItem != null && !strCustItem.equals(""))
						{						  
							sql += " and a.ITEM = '"+strCustItem+"'";
						}
						if (strItemDesc != null && !strItemDesc.equals(""))
						{
							sql += " and a.ITEM_DESCRIPTION = '"+strItemDesc+"'";
						}
						if (strItemName != null && !strItemName.equals(""))
						{
							sql += " and a.INVENTORY_ITEM = '"+strItemName+"'";
						}
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						while(rs.next())
						{
							strItemName = rs.getString("INVENTORY_ITEM");
							strItemID = rs.getString("INVENTORY_ITEM_ID");	
							strItemDesc = rs.getString("ITEM_DESCRIPTION");
							strUOM = rs.getString("PRIMARY_UOM_CODE");
							strFactory = rs.getString("ATTRIBUTE3");
							strOrderType = rs.getString("ORDER_TYPE");
							if (strLineOrderType == null || strLineOrderType.equals("")) strLineOrderType=strOrderType;
							strItemNoPacking=rs.getString("itemnopacking"); //add by Peggy 20220715
							rec_cnt++;
						}
						rs.close();
						statement.close();
					}
					if (rec_cnt==0)
					{
						if (strCustItem != null && !strCustItem.equals(""))
						{
							strErr += "未建立客戶品名與台半品名關連<br>";						
						}
						else
						{
							if ((strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals("")))
							{
								sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3,"+
									  //" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3)  AS order_type"+
									  " tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type"+  //modify by Peggy 20191122
									  " ,tsc_get_item_desc_nopacking(msi.organization_id,msi.inventory_item_id) itemnopacking"+ //add by Peggy 20220715
									  " FROM  inv.mtl_system_items_b msi"+
									  ",apps.mtl_item_categories_v c"+
									  " WHERE msi.inventory_item_id = c.inventory_item_id"+
									  " AND msi.organization_id = c.organization_id"+
									  " AND msi.organization_id = '49'"+
									  " AND c.category_set_id = 6"+
									  " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+         //add by Peggy 20151008
									  " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+ //add by Peggy 20151008
									  " AND msi.inventory_item_status_code <> 'Inactive'"+//add by Peggy 20130221
									  " and tsc_get_item_coo(msi.inventory_item_id) =(\n" + //add by Mars 20250108
									  "     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
									  "     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+ //add by Mars 20250108
									  " AND tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230202
								if (strItemDesc != null && !strItemDesc.equals("")) sql += " AND msi.description =  '"+strItemDesc+"'";	
								if (strItemName != null && !strItemName.equals("")) sql += " AND msi.segment1 =  '"+strItemName+"'";	
								Statement statement=con.createStatement();
								//out.println(sql);
								ResultSet rs = statement.executeQuery(sql);
								while(rs.next())
								{
									strItemName = rs.getString("segment1");
									strItemID = rs.getString("INVENTORY_ITEM_ID");	
									strItemDesc = rs.getString("description");
									strCustItem = "";
									strUOM = rs.getString("PRIMARY_UOM_CODE");
									strFactory = rs.getString("ATTRIBUTE3");
									strOrderType = rs.getString("ORDER_TYPE");
									if (strLineOrderType == null || strLineOrderType.equals("")) strLineOrderType=strOrderType;
									strItemNoPacking=rs.getString("itemnopacking"); //add by Peggy 20220715
									rec_cnt++;
								}
								rs.close();
								statement.close();
							}	
							if (rec_cnt==0)
							{
								strErr += "查無對應的ERP料號<br>";
							}
						}		
					}
					if (rec_cnt >1)
					{
						strErr += "對應的台半料號超過一個以上,請選擇正確台半料號<br>";
					}	
					else
					{
						if (!strQuoteNumber.equals("") && !strItemDesc.equals(""))
						{
							strSellingPrice_Q="";strEndCustName="";
							Statement state1=con.createStatement();
							//sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(a.createdby),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JUNE')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JWANG')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.endcustomer end_customer"+
							sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, '('|| a.region ||')'|| a.endcustomer end_customer"+	 //add by Peggy 20240217						
                                  " FROM tsc_om_ref_quotenet a "+
								  " where a.quoteid='"+strQuoteNumber+"'"+
								  " and a.partnumber='"+strItemDesc+"'"+
								  " order by a.quoteid, a.partnumber";
							//out.println(sql);
							ResultSet rs1=state1.executeQuery(sql);  
							if (rs1.next())
							{
								strSellingPrice_Q = rs1.getString("PRICE_USD");
								strEndCustName = rs1.getString("END_CUSTOMER");
							}
							rs1.close();
							state1.close();	
							if (strSellingPrice_Q.equals(""))  
							{								
								state1=con.createStatement();
								//sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(a.createdby),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JUNE')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JWANG')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.endcustomer end_customer"+
								sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, '('|| a.region ||')'|| a.endcustomer end_customer"+	 //add by Peggy 20240217							
                                  	  " FROM tsc_om_ref_quotenet a "+
									  " where a.quoteid='"+strQuoteNumber+"'"+
								      " and a.partnumber like '"+strItemNoPacking+"%'"+
								      " order by a.quoteid, a.partnumber";
								//out.println(sql);
								rs1=state1.executeQuery(sql);  
								if (rs1.next())
								{
									strSellingPrice_Q = rs1.getString("PRICE_USD");
									strEndCustName = rs1.getString("END_CUSTOMER");
								}
								rs1.close();
								state1.close();								
							}				
							//add by Peggy 20220606
							/*if (rsn.isBeforeFirst() ==false) rsn.beforeFirst();
							while (rsn.next())
							{
								if (rsn.getString("QUOTE_ID").equals(strQuoteNumber) && rsn.getString("TSC_PARTNO").equals(strItemDesc))
								{
									strSellingPrice = rsn.getString("PRICE_USD");
									strEndCustName = rsn.getString("END_CUSTOMER");
									break;
								}
							}
							if (strSellingPrice.equals(""))  //add by Peggy 20220715
							{
								if (rsn.isBeforeFirst() ==false) rsn.beforeFirst();
								while (rsn.next())
								{
									if (rsn.getString("QUOTE_ID").equals(strQuoteNumber) && rsn.getString("TSC_PARTNO").startsWith(strItemNoPacking))
									{
										strSellingPrice = rsn.getString("PRICE_USD");
										strEndCustName = rsn.getString("END_CUSTOMER");
										break;
									}
								}							
							}
							*/
						}
					}
				}
					
				//訂單類型
				if (strLineOrderType == null || strLineOrderType.equals(""))
				{
					strLineOrderType = "";
					strErr +="訂單類型不可空白<br>";
				}
				else
				{
					boolean bolExist = false;
					String [] strarray= OrderTypeList.split(";");
					for (int x = 0 ; x < strarray.length ; x++)
					{
						String [] strd = strarray[x].split("@");
						if (strLineOrderType.equals(strd[0]))
						{
							bolExist = true;
							strLineOrderTypeID =strd[1];
						}
					}
					if (!bolExist) strErr +="訂單類型不存在<br>";
				}
				
				//檢查訂單類型是否正確
				Statement stateodrtype=con.createStatement();
				sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
							" where b.order_num=a.order_num and a.order_num='"+strLineOrderType+"' and a.SAREA_NO ='"+SalesAreaNo+"' and a.active='Y'"+
							" and b.MANUFACTORY_NO='"+strFactory+"' and b.ACTIVE='Y'";
				//out.println(sql);
				ResultSet rsodrtype=stateodrtype.executeQuery(sql);  
				if (!rsodrtype.next())
				{
					strErr += "訂單類型錯誤<br>";
				}
				rsodrtype.close();
				stateodrtype.close();

				//數量	
				if (strQty == null || strQty.equals(""))
				{
					strQty = "";
					strErr += "數量不可空白<br>";
				}
				else
				{
					try
					{
						float qtynum = Float.parseFloat(strQty.replace(",",""));
						if ( qtynum <= 0)
						{
							strErr += "數量必須大於零<br>";
						}
						else
						{
							strQty=(new DecimalFormat("#######0.0#")).format(qtynum);
						}
					}
					catch (Exception e)
					{
						strErr += "數量格式錯誤<br>";
					}
				}

				//單價
				if (strSellingPrice == null || strSellingPrice.equals(""))
				{
					if (strSellingPrice_Q == null || strSellingPrice_Q.equals(""))
					{
						strSellingPrice = "";
						strErr +="Selling Price不可空白<br>";
					}
					else
					{
						strSellingPrice=strSellingPrice_Q;
					}
				}
				else
				{
					try
					{
						float pricenum = Float.parseFloat(strSellingPrice.replace(",",""));
						if ( pricenum <= 0)
						{
							strErr += "Selling Price必須大於零<br>";
						}
						else if (!strSellingPrice.equals(strSellingPrice_Q)) //add by Peggy 20231229
						{
							strErr += "Selling Price not match quote price("+strSellingPrice_Q+")<br>";
						}
						else
						{
							strSellingPrice =(new DecimalFormat("###,##0.000##")).format(pricenum);
						}
					}
					catch (Exception e)
					{
						strErr += "單價格式錯誤<br>";
					}
				}
				
				//CRD	
				if (strCRD == null || strCRD.equals(""))
				{
					strCRD = "";
					strErr +="CRD不可空白<br>";
				}
				else if (Long.parseLong(strCRD) <= Long.parseLong(strCHKDate))
				{
					strErr +="CRD必須大於"+strCHKDate+"<br>";
				}
				
				//交貨日期	
				if (strRequestDate == null || strRequestDate.equals(""))
				{
					strRequestDate = "";
					strErr +="Request Date不可空白<br>";
				}
				else if (Long.parseLong(strRequestDate) <= Long.parseLong(strCHKDate))
				{
					strErr +="Request Date必須大於"+strCHKDate+"<br>";
				}
						
				//出貨方式
				if (strShippingMethod == null || strShippingMethod.equals(""))
				{
					strShippingMethod = "";
					strErr +="出貨方式不可空白<br>";
				}
				else
				{
					boolean bolExist = false;
					String [] strarray= ShippingMethodList.split(";");
					for (int x = 0 ; x < strarray.length ; x++)
					{
						String [] strd = strarray[x].split("@");
						if (strShippingMethod.equals(strd[0]) || strShippingMethod.equals(strd[1]))
						{
							bolExist = true;
							strShippingMethod = strd[1];
						}
					}
					if (!bolExist) strErr +="出貨方式不存在<br>";
				}
				
				//FOB
				if (strFOB == null || strFOB.equals(""))
				{
					strFOB = "";
					strErr += "FOB不可空白<br>";
				}
				else
				{
					boolean bolExist = false;
					String [] strarray= FOBList.split(";");
					for (int x = 0 ; x < strarray.length ; x++)
					{
						if (strFOB.equals(strarray[x]))
						{
							bolExist = true;
						}
					}
					if (!bolExist) strErr += "FOB不存在<br>";
				}

				//CUSTOMER PO
				if (strLineCustPO == null || strLineCustPO.equals(""))
				{
					strLineCustPO = strCustPO;
				}
				
				//REMARK
				if (strLineRemark == null || strLineRemark.equals(""))
				{
					strLineRemark = "";
				}
				
				//END CUSTOMER
				strEndCust="";strEndCustID1 ="";
				if (!strEndCustID.equals(""))
				{
					//end customer id不可與customer id相同
					if (strEndCustID.equals(strCustNo))
					{
						 strErr += "End Customer ID不可與Customer ID相同<br>";
					}
					else
					{
						if (rss.isBeforeFirst() ==false) rss.beforeFirst();
						while (rss.next())
						{
							if (rss.getString("customer_number").equals(strEndCustID))
							{
								strEndCust = rss.getString("CUSTOMER_NAME_PHONETIC");
								strEndCustID1 =""+rss.getInt("customer_id");
								break;
							}
						}
						if (strEndCust.equals("")) strErr += "End Customer ID不存在ERP<br>";
					}
				}	
				else if (!strEndCustName.equals("")) //add by Peggy 20190221
				{
					strEndCust=strEndCustName;
				}
				
				if (strErr.length() > 0)
				{
					if (ErrCnt ==0)
					{
%>
					<tr>
						<td colspan="3">
							<table cellspacing='0' bordercolordark="#ffffff" cellpadding='1' width='100%' align='center' bordercolorlight='#ffffff' border='1'>
								<tr bgcolor="#6633CC" style="color:#ffffff;font-size:10px;font-family:ARIAL">
									<td width='4%'>Customer No</td>
									<td width='8%'>Customer Name</td>
									<td width='3%'>RFQ Type</td>
									<td width='8%'>Customer PO</td>
									<td width='4%'>Order Type</td>
									<td width='7%'>TSC P/N</td>
									<td width='9%'>TSC internal P/N</td>
									<td width='7%'>Customer P/N</td>
									<td width='4%'>Qty(KPCS)</td>
									<td width='4%'>Selling<br>Price</td>
									<td width='4%'>CRD</td>
									<td width='4%'>SSD</td>
									<td width='5%'>Shipping<br>Method</td>
									<td width='5%'>FOB Type</td>
									<td width='4%'>End Cust ID</td>
									<td width='6%'>End Customer</td>
									<td width='6%'>Remarks</td>
									<td width='8%'>Error<br>Message</td>
								</tr>
<%
					}
%>
								<tr bgcolor="#CCFFAC" style="color:#000000;font-size:10px;font-family:ARIAL">
									<td><%=strCustNo%></td>
									<td><%=strCustName%></td>
									<td><%=strRFQType%></td>
									<td><%=strLineCustPO%></td>
									<td><%=strLineOrderType%></td>
									<td><%=strItemDesc%></td>
									<td><%=strItemName%></td>
									<td><%=strCustItem%></td>
									<td><%=strQty%></td>
									<td><%=strSellingPrice%></td>
									<td><%=strCRD%></td>
									<td><%=strRequestDate%></td>
									<td><%=strShippingMethod%></td>
									<td><%=strFOB%></td>
									<td><%=strEndCustID%></td>
									<td><%=strEndCust%></td>
									<td><%=strLineRemark%></td>
									<td style="color:#FF0000"><%=strErr%></td>
								</tr>
<%					
					strErr="";
					ErrCnt ++;
				}
				Statement state1=con.createStatement();
				//sql = " select wf.LINE_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
				//	  " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
		  		//	  " and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
	  			//	  " and c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+strLineOrderType+"')"+
				//	  " and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
				sql = " SELECT DISTINCT a.ORDER_NUM, a.DEFAULT_ORDER_LINE_TYPE FROM ORADDMAN.TSAREA_ORDERCLS  A "+
                      " WHERE A.ACTIVE ='Y' and A.SAREA_NO = '"+SalesAreaNo+"' and a.ORDER_NUM='"+strLineOrderType+"'";
				ResultSet rs1=state1.executeQuery(sql);
				if (rs1.next())
				{
					strLineType = rs1.getString("DEFAULT_ORDER_LINE_TYPE");
				} 
				else 
				{ 
					strLineType ="0"; 
				} 
				rs1.close();
				state1.close();
				
				aa[icnt][0]=strCustNo;
				aa[icnt][1]=strCustName;
				aa[icnt][2]=strRFQType;
				aa[icnt][3]=strLineCustPO;
				aa[icnt][4]=strItemDesc;
				aa[icnt][5]=strItemName;
				aa[icnt][6]=strCustItem; 
				aa[icnt][7]=strFactory;
				aa[icnt][8]=strUOM;
				aa[icnt][9]=strQty;
				aa[icnt][10]=strSellingPrice; 
				aa[icnt][11]=strCRD; 
				aa[icnt][12]=strRequestDate;
				aa[icnt][13]=strShippingMethod ;
				aa[icnt][14]=strFOB;   
				aa[icnt][15]=strLineRemark.replace("&nbsp;","");
				aa[icnt][16]=strLineOrderTypeID;
				aa[icnt][17]=strLineType;
				aa[icnt][18]=strItemID;
				aa[icnt][19]=strCustID;
				aa[icnt][20]=strLineCustPOLineNo;
				aa[icnt][21]="";   //shipping marks,add by Peggy 20130305
				aa[icnt][22]="";   //remarks,add by Peggy 20130305
				aa[icnt][23]=strEndCustID1;   //end customer id,add by Peggy 20140825
				aa[icnt][24]=strEndCust;     //end customer,add by Peggy 20140825
				aa[icnt][25]=strQuoteNumber; //Quote Number,add by Peggy 20190227
				aa[icnt][26]="";      //ORIG SO LINE ID,add by Peggy 20150519
				icnt++;
			}
			wb.close();
			if (icnt ==0)
			{ 
				throw new Exception("上傳內容錯誤!");
			}
			rss.close();
			statements.close();
			//rsn.close(); 
			//statementn.close();
		}
		
		if (ErrCnt >0)
		{
			out.println("</table></td></tr>");
			out.println("<tr><td colspan='3' align='center'><font style='color:#ff0000;font-family:標楷體;font-size:16px'>上傳動作失敗，請洽系統管理員，謝謝!</font></td></tr>");		
		}
		else
		{
			for (int i =0 ; i < aa.length ; i++)
			{
				if (aa[i][0] == null || aa[i][0].equals("")) continue;
				sql=" insert into oraddman.tsc_rfq_upload_temp("+
					  "salesareano,"+        //0
					  "upload_date,"+        //1
					  "upload_by,"+          //2
       				  "customer_no,"+        //3
					  "customer_name,"+      //4
					  "rfq_type,"+           //5
					  "customer_po,"+        //6
					  "inventory_item_id,"+  //7
					  "cust_item_name,"+     //8
					  "qty,"+                //9
					  "selling_price,"+      //10 
					  "crd,"+                //11
					  "request_date,"+       //12
					  "shipping_method,"+    //13
					  "fob,"+                //14
					  "remarks,"+            //15
                      "order_type,"+         //16
					  "line_type,"+          //17
					  "create_flag,"+        //18
					  "CUSTOMER_ID,"+        //19
					  "FACTORY,"+            //20
					  "customer_po_line_number,"+ //21
					  "line_no,"+            //22
					  "END_CUSTOMER_ID,"+    //23
					  "END_CUSTOMER,"+       //24
					  "QUOTE_NUMBER,"+       //25
					  "PO_LINE_NO)"+         //26
					  " values("+
					  "?,"+                  //0
					  "SYSDATE,"+            //1
					  "?,"+                  //2
					  "?,"+                  //3
					  "?,"+                  //4
					  "?,"+                  //5
					  "?,"+                  //6
					  "?,"+                  //7
					  "?,"+                  //8
					  "?,"+                  //9
					  "?,"+                  //10
					  "?,"+                  //11
					  "?,"+                  //12
					  "?,"+                  //13
					  "?,"+                  //14
					  "?,"+                  //15
					  "?,"+                  //16
					  "?,"+                  //17
					  "?,"+                  //18
					  "?,"+                  //19
					  "?,"+                  //20
					  "?,"+                  //21
					  "?,"+                  //22
					  "?,"+                  //23
					  "?,"+                  //24
					  "?,"+                  //25
					  "?)";                  //26
				PreparedStatement pstmt=con.prepareStatement(sql); 
				pstmt.setString(1,SalesAreaNo);          //salesareano
				pstmt.setString(2,UserName);             //upload_by
				pstmt.setString(3,aa[i][0]);             //customer_no
				pstmt.setString(4,aa[i][1]);             //customer_name
				pstmt.setString(5,aa[i][2].toUpperCase());    //rfq_type
				//pstmt.setString(6,aa[i][3]);             //customer_po
				if (strCustPOLineNo_flag.equals("Y"))
				{
					pstmt.setString(6,aa[0][3]);             //customer_po,第一筆po當header by Peggy 20221221
				}
				else
				{
					pstmt.setString(6,aa[i][3]);
				}
				pstmt.setString(7,aa[i][18]);            //inventory_item_id
				pstmt.setString(8,(aa[i][6].equals("&nbsp;")?"":aa[i][6]));             //cust_item_name
				pstmt.setString(9,aa[i][9]);             //qty
				pstmt.setString(10,aa[i][10]);           //selling_price
				pstmt.setString(11,aa[i][11]);           //crd
				pstmt.setString(12,aa[i][12]);           //request_date
				pstmt.setString(13,aa[i][13]);           //shipping_method
				pstmt.setString(14,aa[i][14]);           //fob
				pstmt.setString(15,aa[i][15]);           //remarks
				pstmt.setString(16,aa[i][16]);           //order_type
				pstmt.setString(17,aa[i][17]);           //line_type
				pstmt.setString(18,"N");                 //create_flag
				pstmt.setString(19,aa[i][19]);           //customer_id
				pstmt.setString(20,aa[i][7]);            //factory
				//pstmt.setString(21,aa[i][20]);           //customer po line number
				pstmt.setString(21,aa[i][3]);             //customer po line number,modify by Peggy 20221221
				pstmt.setInt(22,(insert_cnt+1));         //line_no
				pstmt.setString(23,aa[i][23]);            //end customer id,add by Peggy 20140825
				pstmt.setString(24,aa[i][24]);            //end customer,add by Peggy 20190221
				pstmt.setString(25,aa[i][25]);            //quote number,add by Peggy 20190227
				pstmt.setString(26,aa[i][20]);            //po line no,add by Peggy 20221221
				pstmt.executeQuery();
				pstmt.close();
				insert_cnt++;
			}
			con.commit();
		}
		if (insert_cnt >0) 
		{
			response.sendRedirect("TSCROWImportHistory.jsp");
			//out.println("<tr><td colspan='3' align='center'><font style='color:#0000FF;font-family:標楷體;font-size:16px'>資料上傳成功!!共上傳"+insert_cnt+"筆資料..</font></td></tr>");		
		}		
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("error1:"+e.getMessage());
	}
}
%>
</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
</body>
</html>
