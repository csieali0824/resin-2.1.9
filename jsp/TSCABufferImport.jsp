<!-- 20140813 by Peggy,新增shiping method & ERP END CUSTOMER ID欄位-->
<!-- 20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!-- 20160313 by Peggy,add sample order direct ship to cust flag-->
<!-- 20160706 by Peggy,自動判斷運輸方式-->
<!-- 20160907 by Peggy,CRD格式改為MM/DD/YY 文字格式-->
<!-- 20160913 by Peggy,客戶品號不存在直接報錯,不往下進行-->
<!-- 20161019 by Peggy,停用function:TSC_RFQ_GET_TSCA_SSD,改用TSCA_GET_ORDER_SSD-->
<!-- 20170216 by Peggy,add sales region for bi-->
<!-- 20170504 by Peggy,Check CRD>=SYSDATE-30-->
<!-- 20170512 by Peggy,add end cust ship to id-->
<!-- 20180103 by Peggy,add new column =>Ref. Sales Order No -->
<!-- 20190225 by Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*,java.util.*,jxl.*,java.lang.Math.*,java.text.*,java.io.*"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean,WorkingDateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Excel Upload To Create a TSCA New RFQ Order</title>
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
String CustomerName = "TSC America, Inc.";
String CustomerNo = "1008";
String CustomerID = "1019";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE == null) ACTIONCODE = "";
String SalesAreaNo = "008";
String SalesAreaName = "半導體事業部-美國區";
String SalesArea = "("+SalesAreaNo+")"+SalesAreaName;
String SAMPLEFILE = request.getParameter("SAMPLEFILE");
if (SAMPLEFILE ==null) SAMPLEFILE="";
int icnt=0,ErrCnt=0,sRow=3,rec_cnt=0;
String strLineRemark="",FOBList="",ShippingMethodList="",urlDir ="",sql = "",strOtypeID ="",strUOM="",strFactory="",strItemID="",strLineType="",strItemName ="",strOrderType="",strCustName="",strCustPO="",strRFQType="",strItemDesc="",strQty="",strCustItem="",strSellingPrice="",strCRD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strEndCustID="",strErr="",strRefSO="",strCustPoLineNo="",strLineCustPoNo="",strOrigSoLineID="";
String strERPEndCustomerID="";         //add by Peggy 20140813
String shippingMethodName="";          //add by Peggy 20140819
String tsc_package = "",tsc_family=""; //add by Peggy 20160706
String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust Po Line No","Quote#","End Customer ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust Partno"};//add by Peggy 20170222
String aa [][] = new String[1][1];
StringBuffer sb = new StringBuffer();
int months_num = 0;                    //add by Peggy 20170504

//String strYear="",strMon="",strDay=""; 
%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">

<table width="100%" align="center" border="0">
	<tr>
		<td width="15%">&nbsp;</td>
		<td width="70%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
				<tr>
					<td height="50" align="center">
						<font color="#003399" size="+2" face="Arial Black">TSCA </font>
						<font color="#000000" size="+2" face="Times New Roman"> <strong>  Excel Upload To Create a New RFQ Order</strong></font>
					</td>
				</tr>
			</table>
		</td>
		<td width="10%">&nbsp;</td>
	</tr>
	<tr>
		<td width="10%">&nbsp;</td>
		<td width="80%">
			<table align="center" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
				<tr>
					<TD width="90%">&nbsp;
					</TD>
					<TD align="right" width="15%" title="回首頁!">
						<A HREF="../ORAddsMainMenu.jsp" style="font-size:14px;font-family:標楷體;text-decoration:none;color:#0000FF">
						<STRONG>回首頁</STRONG>
						</A>
					</TD>
				</tr>
				<tr>
					<td colspan="2">
						<table  bordercolordark="#BEDCE4" cellspacing="0"  cellpadding="0" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  				<tr>
								<td style="color:#000033;font-size:14px;font-family:標楷體;background-color:#BEDCE4">業務區域：</td>
								<td ><input type="text" style="border:none;font-family:ARIAL;font-size:14px" size="80" name="SalesArea" value="<%=SalesArea%>" oonkeydown="return (event.keyCode!=8);" readonly>
			  				</tr>
			  				<tr>
								<td style="color:#000033;font-size:14px;font-family:標楷體;background-color:#BEDCE4">客戶名稱：</td>
								<td ><input type="text" style="border:none;font-family:ARIAL;font-size:14px" size="80" name="Customer" value="<%=CustomerName%>" oonkeydown="return (event.keyCode!=8);" readonly>
		  					</tr>
			  				<tr>
								<td style="color:#000033;font-size:14px;font-family:Verdana;background-color:#BEDCE4">Upload File：</td>
								<td width="85%" ><INPUT TYPE="FILE" style="font-family:ARIAL;font-size:14px" NAME="UPLOADFILE" size="90"></td>
			  				</tr>
			  				<tr>
								<td style="color:#000033;font-size:14px;font-family:Verdana;background-color:#BEDCE4">Sample File：</td>
								<td width="85%" ><A HREF="../jsp/samplefiles/D4-004_SampleFile.xls"><font style="font-size:14px;font-family:arial">Download Sample File</font></A></td>
			  				</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" title="請按我，謝謝!">
					<input type="button" style="font-size:14px;font-family:arial" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCABufferImport.jsp?ACTIONCODE=INSERT')">
					</td>
				</tr>
			</table>
		</td>
		<td width="15%">&nbsp;</td>
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
			
			//add by Peggy 20140819
			sql = " SELECT lookup_code,meaning FROM fnd_lookup_values lv"+
                  " WHERE language = 'US'"+
                  " AND view_application_id = 3"+
                  " AND lookup_type = 'SHIP_METHOD'"+
                  " AND security_group_id = 0"+
                  " AND ENABLED_FLAG='Y'"+
                  " AND (end_date_active IS NULL OR end_date_active > SYSDATE)";
			Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rsh = statementh.executeQuery(sql);
		
			//add by Peggy 20140820
			sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SalesAreaNo+"') d"+
				          " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					      " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
					      " and (a.ORG_ID = d.PAR_ORG_ID"+
						  " OR a.ORG_ID=1046)"+ //add by Peggy 20240103
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and c.STATUS='A'"+
						  " and c.customer_number <>'"+CustomerNo+"'"+
						  " order by c.customer_id";
			Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rss = statements.executeQuery(sql);
						  		
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\TSCABuffer\\"+strDateTime+"-"+uploadFile_name;
			upload_file.saveAs(uploadFilePath); 
			java.util.Date datetime = new java.util.Date();
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String CreationDate = (String) formatter.format( datetime );
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);

			//客戶訂單號碼
			jxl.Cell cellCustPO  = sht.getCell(1,0); 
			strCustPO = cellCustPO.getContents();
			
			//RFQ類型
			jxl.Cell cellRFQType = sht.getCell(1,1); 
			strRFQType = cellRFQType.getContents();
				
			arrayRFQDocumentInputBean.setArrayString(oneDArray);
			aa = new String[sht.getRows()-sRow][oneDArray.length];
			
			//line detail
			//out.println("sht.getRows()="+sht.getRows());
			for (int i = sRow; i <sht.getRows(); i++) 
			{
				//台半品名
				jxl.Cell cellItemDesc = sht.getCell(0, i);          
				strItemDesc = (cellItemDesc.getContents()).trim();
				if (strItemDesc == null) strItemDesc= "";

				//台半料號
				jxl.Cell cellItemName = sht.getCell(1, i);          
				strItemName = (cellItemName.getContents()).trim();
				if (strItemName == null) strItemName= "";
			
				//客戶品號
				jxl.Cell cellCustItem = sht.getCell(2, i);          
				strCustItem = (cellCustItem.getContents()).trim();
				if (strCustItem == null) strCustItem= "";
				
				if (strItemDesc.equals("") && strCustItem.equals("")) continue;

				//數量
				jxl.Cell cellQty = sht.getCell(3, i);  
				if (cellQty.getType() == CellType.NUMBER) 
				{
					strQty = ""+((NumberCell) cellQty).getValue();
				} 
				else strQty = (cellQty.getContents()).trim();
				if (strQty == null) strQty="0";
			
				
				//單價
				jxl.Cell cellSellingPrice = sht.getCell(4, i);  
				if (cellSellingPrice.getType() == CellType.NUMBER) 
				{
					strSellingPrice = ""+((NumberCell) cellSellingPrice).getValue();
				} 
				else strSellingPrice = (cellSellingPrice.getContents()).trim();
				if (strSellingPrice == null) strSellingPrice="0";
			
				// CRD
				jxl.Cell cellCRD = sht.getCell(5, i);
				//SimpleDateFormat sy1=new SimpleDateFormat("MM/dd/yy");
				//strCRD =sy1.format(((DateCell)cellCRD).getDate());
				strCRD = (cellCRD.getContents()).trim();
				strCRD = strCRD.replace("：",":").replace("CRD:","").trim();

				//END CUSTOMER
				jxl.Cell cellEndCust = sht.getCell(6, i);          
				strEndCust = (cellEndCust.getContents()).trim();
					
				//REMARK
				jxl.Cell cellRemark = sht.getCell(7, i);          
				strLineRemark = (cellRemark.getContents()).trim();
				
				//Shipping Method,add by Peggy 20140813
				jxl.Cell cellShippingMethod = sht.getCell(8, i);          
				shippingMethodName=(cellShippingMethod.getContents()).trim();
				if (shippingMethodName==null) shippingMethodName="";


				//ERP END CUSTOMER ID,add by Peggy 20140813
				jxl.Cell cellERPEndCustomerID = sht.getCell(9, i);          
				strERPEndCustomerID=(cellERPEndCustomerID.getContents()).trim();
				if (strERPEndCustomerID==null) strERPEndCustomerID="";

				//Ref. Sales Order No,add by Peggy 20180103
				jxl.Cell cellRefSO = sht.getCell(10, i);          
				strRefSO=(cellRefSO.getContents()).trim();
				if (strRefSO==null) strRefSO="";
				
				//cust po line number,add by Peggy 20200430
				jxl.Cell cellCustPoLineNo = sht.getCell(11, i);          
				strCustPoLineNo=(cellCustPoLineNo.getContents()).trim();
				if (strCustPoLineNo==null) strCustPoLineNo="";
				
				//cust po number,add by Peggy 20210223
				jxl.Cell cellLineCustPoNo = sht.getCell(12, i);          
				strLineCustPoNo=(cellLineCustPoNo.getContents()).trim();
				if (strLineCustPoNo==null) strLineCustPoNo=strCustPO;
				if (strCustPO==null|| strCustPO.equals("")) strCustPO=strLineCustPoNo;
												
				strErr ="";strItemID="";rec_cnt=0;strUOM="";strFactory="";strOrderType="";//初始化
					
				if (icnt ==0)
				{
					sb.append("<table cellspacing='1' bordercolordark='#CC9966' cellpadding='1' width='100%' align='center' bordercolorlight='#ffffff' border='1'>"+
							  "<tr>"+
							  "<td width='2%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>No.</td>"+
					          "<td width='10%' bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>TSC Item Name</td>"+
							  "<td width='9%' bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>TSC Item Desc</td>"+
							  "<td width='9%' bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Customer Item</td>"+
							  "<td width='4%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Qty(K)</td>"+
							  "<td width='4%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Unit Price</td>"+
							  "<td width='5%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>CRD</td>"+
							  "<td width='5%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Request<br>Date</td>"+
							  "<td width='6%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Shipping<br>Method</td>"+
							  "<td width='6%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>FOB</td>"+
							  "<td width='6%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Cust PO NO</td>"+
							  "<td width='7%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>End Customer</td>"+
							  "<td width='4%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>End Customer ID</td>"+
							  "<td width='8%'  bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Remark</td>"+
							  "<td width='7%' bgcolor='#EA7500' style='color:#ffffff;font-size:11px;font-family:ARIAL'>Error Message</td>"+
							  "</tr>");
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
					//if ((strCustItem != null && !strCustItem.equals("")) || (strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals("")))
					if (strCustItem != null && !strCustItem.equals(""))
					{						  
						sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
							  " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
							  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
							  //" ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
							  //" ,case when msi.attribute3='005' then '1141' else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) end AS ORDER_TYPE"+ //TSCA SSD產品都須回T by cindy issue,20191003
							  " ,case when msi.attribute3 in ('005','011') or " +
							  " ('" + SalesAreaNo + "' in ('008') AND  msi.attribute3 in ('002') and TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') in ('SMA', 'SMB','SMC','SOD-123W','SOD-128')) then '1141' "+
						      " else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) end AS ORDER_TYPE"+ // by Mars 20241106
						      //" ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) AS order_type"+ //20200115 by Peggy TSCA也可以接受小訊號由大陸直接出貨不回台
							  " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE "+
						      " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY "+
							  " from oe_items_v a,inv.mtl_system_items_b msi "+
							  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
							  " where a.SOLD_TO_ORG_ID = '"+CustomerID+"' "+
							  " and a.organization_id = msi.organization_id"+
							  " and a.inventory_item_id = msi.inventory_item_id"+
							  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
							  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
							  " and msi.ORGANIZATION_ID = '49'"+
							  " and c.CATEGORY_SET_ID = 6"+
							  " and a.CROSS_REF_STATUS='ACTIVE'"+
						      " and msi.inventory_item_status_code <> 'Inactive'"+//add by Peggy 20130221
							  " and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230202
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
						//out.println("**"+sql);
						Statement statement=con.createStatement();
						ResultSet rs = statement.executeQuery(sql);
						while(rs.next())
						{
							strItemName = rs.getString("INVENTORY_ITEM");
							strItemID = rs.getString("INVENTORY_ITEM_ID");	
							strItemDesc = rs.getString("ITEM_DESCRIPTION");
							//strCustItem = rs.getString("item");
							strUOM = rs.getString("PRIMARY_UOM_CODE");
							strFactory = rs.getString("ATTRIBUTE3");
							strOrderType = rs.getString("ORDER_TYPE");
							tsc_package = rs.getString("TSC_PACKAGE");  //add by Peggy 20160706
							tsc_family = rs.getString("TSC_FAMILY");    //add by Peggy 20160706
							rec_cnt++;
							
						}
						rs.close();
						statement.close();
						if (rec_cnt==0)
						{
							strErr += "ERP無此客戶品號<br>";
						}
					}
					//if (rec_cnt==0)
					else
					{
						if ((strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals("")))
						{
							sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3"+
  								  //" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3)  AS order_type"+
								  //" case when msi.attribute3='005' then '1141' else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) end AS order_type"+ //TSCA SSD產品都須回T by cindy issue,20191003
//								  " case when msi.attribute3 in ('005','011') then '1141' else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) end AS order_type"+ //TSCA SSD產品都須回T by cindy issue,20191122
									" ,case when msi.attribute3 in ('005','011') or " +
									" ('" + SalesAreaNo + "' in ('008') AND  msi.attribute3 in ('002') and TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') in ('SMA', 'SMB','SMC','SOD-123W','SOD-128')) then '1141' "+
									" else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) end AS ORDER_TYPE"+ // by Mars 20241106
								  //" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.INVENTORY_ITEM_ID) AS order_type"+ //20200115 by Peggy TSCA也可以接受小訊號由大陸直接出貨不回台
	   						      " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Package') as TSC_PACKAGE "+
						          " ,TSC_OM_CATEGORY(msi.INVENTORY_ITEM_ID,msi.ORGANIZATION_ID,'TSC_Family') as TSC_FAMILY "+
								  " FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c"+
								  " WHERE msi.inventory_item_id = c.inventory_item_id"+
								  " AND msi.organization_id = c.organization_id"+
								  " AND msi.organization_id = '49'"+
								  " AND c.category_set_id = 6"+
								  " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+   //add by Peggy 20151008
								  " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+ //add by Peggy 20151008
								  " AND msi.inventory_item_status_code <> 'Inactive'"+//add by Peggy 20130221
								  " AND tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"; //add by Peggy 20230202
							if (strItemDesc != null && !strItemDesc.equals("")) sql += " AND msi.description =  '"+strItemDesc+"'";	
							if (strItemName != null && !strItemName.equals("")) sql += " AND msi.segment1 =  '"+strItemName+"'";
							Statement statement=con.createStatement();
							ResultSet rs = statement.executeQuery(sql);
							while(rs.next())
							{
								//out.println("***"+sql);
								strItemName = rs.getString("segment1");
								strItemID = rs.getString("INVENTORY_ITEM_ID");	
								strItemDesc = rs.getString("description");
								strCustItem = "";
								strUOM = rs.getString("PRIMARY_UOM_CODE");
								strFactory = rs.getString("ATTRIBUTE3");
								strOrderType = rs.getString("ORDER_TYPE");
								tsc_package = rs.getString("TSC_PACKAGE");  //add by Peggy 20160706
								tsc_family = rs.getString("TSC_FAMILY");    //add by Peggy 20160706
								rec_cnt++;
							}
							rs.close();
							statement.close();
						}			
						if (rec_cnt==0)
						{
							strErr += "查無對應的ERP料號<br>";
						}
						else if (rec_cnt >1)
						{
							strErr += "對應的台半料號超過一個以上,請選擇正確台半料號<br>";
						}	
					}
				}
				sb.append ("<tr><td style='font-size:11px;font-family:arial'>"+(icnt+1)+"</td>"+
				           "<td><input type='text' name='itemname"+(icnt+1)+"' value='"+strItemName+"' size=22 style='font-size:11px;font-family:arial' readonly></td>"+
						   "<td><input type='text' name='itemdesc"+(icnt+1)+"' value='"+strItemDesc+"' size=15 style='font-size:11px;font-family:arial' readonly></td>"+
						   "<td><input type='text' name='custitem"+(icnt+1)+"' value='"+strCustItem+"' size=15 style='font-size:11px;font-family:arial' readonly></td>");
					
				//add by Peggy 20180726
				if (strERPEndCustomerID.equals("25091") || strERPEndCustomerID.equals("32712") || strERPEndCustomerID.equals("32713"))
				{
					sql = " select a.SITE_USE_CODE, a.SITE_USE_ID,a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID,a.tax_code"+
						  " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b "+
						  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
						  " and a.STATUS='A' "+
						  " and b.CUST_ACCOUNT_ID ="+CustomerID+""+
						  " and a.SITE_USE_ID=55839";
					Statement statement3=con.createStatement();
					ResultSet rs3 = statement3.executeQuery(sql);
					if (rs3.next())
					{
						if (!strOrderType.equals("1141"))
						{
							shippingMethodName=rs3.getString("SHIP_VIA");
						}
						else
						{
							//shippingMethodName="FEDEX ECONOMY";
							shippingMethodName="UPS EXPEDITED";  //20200408因疫情Fedex停止經濟型(Economy)服務,只提供優先型(Priority)服務,今天客人指示要將所有Digikey的出貨方式改為UPS Expedited

						}
						strFOB =rs3.getString("FOB_POINT");
						if (strFOB.equals("")) strFOB ="FCA";
					}
					rs3.close();
					statement3.close();						  
				}
				else
				{
					strFOB ="DAP";
				}	
				
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
							/*//add by Peggy 20200514,qty必須是moq的倍數
							sql = "SELECT SPQ/1000 SPQ,MOQ/1000 MOQ,mod("+qtynum+", moq/1000 ) com_qty FROM TABLE(TSC_GET_ITEM_SPQ_MOQ('"+strItemID+"','TS','"+strFactory +"'))";
							Statement statement3=con.createStatement();
							ResultSet rs3 = statement3.executeQuery(sql);
							if (rs3.next())
							{	
								if (!rs3.getString(3).equals("0")) strErr += "數量必須是moq("+rs3.getString(2)+"K)的倍數<br>";	
							}
							rs3.close();
							statement3.close();	
							*/
								
							//add by Peggy 20211111,qty必須是SPQ的倍數
							sql = "SELECT SPQ/1000 SPQ,MOQ/1000 MOQ,mod("+qtynum+", spq/1000 ) com_qty,(MOQ/1000)-"+qtynum+" as chkqty FROM TABLE(TSC_GET_ITEM_SPQ_MOQ('"+strItemID+"','TS','"+strFactory +"'))";
							Statement statement3=con.createStatement();
							ResultSet rs3 = statement3.executeQuery(sql);
							if (rs3.next())
							{	
								if (!rs3.getString(3).equals("0")) strErr += "數量必須是SPQ("+rs3.getString(1)+"K)的倍數<br>";	
								if (rs3.getInt(4)>0)  strErr += "數量必須大於或等於MOQ("+rs3.getString(2)+"K)的倍數<br>";
							}
							rs3.close();
							statement3.close();																		

							strQty=(new DecimalFormat("#######0.0#")).format(qtynum);
						}
					}
					catch (Exception e)
					{
						strErr += "SPQ/MOQ資訊未建立,請通知PC同仁建立<br>";
					}
				}
				sb.append("<td style='font-size:11px;font-family:arial'>"+strQty+"</td>");

				//單價
				if (strSellingPrice == null || strSellingPrice.equals(""))
				{
					strSellingPrice = "";
					strErr +="Selling Price不可空白<br>";
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
				sb.append("<td style='font-size:11px;font-family:arial'>"+strSellingPrice+"</td>");
				
				
				//CRD	
				if (strCRD == null || strCRD.equals(""))
				{
					strCRD = "";
					strRequestDate = "";
					strErr +="CRD不可空白<br>";
				}
				else if (strCRD.length() !=8)
				{
					strCRD = "";
					strRequestDate = "";
					strErr +="CRD日期格式錯誤(正確格式=MM/DD/YY)<br>";
				}
				else
				{
					Statement statement=con.createStatement();
					//ResultSet rs = statement.executeQuery("select to_char(to_date('"+strCRD+"','mm/dd/yy'),'yyyymmdd'),floor(months_between(to_date('"+strCRD+"','mm/dd/yy'),trunc(sysdate))) from dual");
					ResultSet rs = statement.executeQuery("select to_char(to_date('"+strCRD+"','mm/dd/yy'),'yyyymmdd'),to_date('"+strCRD+"','mm/dd/yy')-trunc(sysdate) from dual");  //modif by Peggy 20210309
					if (rs.next())
					{
						strCRD = rs.getString(1);
						months_num = rs.getInt(2); //add by Peggy 20170504
					}
					rs.close();
					statement.close();		
					
					if (months_num <-1)  //add by Peggy 20170504
					{
						//strErr +="CRD日期必須在系統日-30日以上<br>";
						strErr +="CRD日期必須大於或等於系統日<br>";  //add by Peggy 20210309
					}			
				}
				
				//add by Peggy 20140819
				if (shippingMethodName==null || shippingMethodName.equals(""))
				{
					//add by Peggy 20160706
					CallableStatement csf = con.prepareCall("{call tsc_edi_pkg.GET_SHIPPING_METHOD(?,?,?,?,?,?,?,sysdate,?,?,?,?)}"); 
					csf.setString(1,SalesAreaNo);
					csf.setString(2,tsc_package);      
					csf.setString(3,tsc_family);                   
					csf.setString(4,strItemDesc);    
					csf.setString(5,strCRD);   
					csf.registerOutParameter(6, Types.VARCHAR);  
					csf.setString(7,strOrderType);   
					csf.setString(8,strFactory);   
					csf.setString(9,CustomerID);   
					csf.setString(10,strFOB);     //add by Peggy 20190319
					csf.setString(11,"");         //add by Peggy 20190319					
					csf.execute();
					shippingMethodName = csf.getString(6);                
					csf.close();					
				}
				strShippingMethod="";
				if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
				while (rsh.next())
				{
					if (rsh.getString("MEANING").equals(shippingMethodName))
					{
						strShippingMethod = rsh.getString("LOOKUP_CODE");
						break;
					}
				}
				
				if (strShippingMethod.equals(""))
				{
					strErr +=("運輸方式未定義("+(shippingMethodName==null?"":shippingMethodName)+")<br>");
				}				
				else
				{
					//strYear = strCRD.substring(6,8);
					//strMon = strCRD.substring(3,5);
					//strDay = strCRD.substring(0,2);
					//out.println(strYear+"  "+strMon+"  "+strDay);
					if (!strFactory.equals(""))
					{
						//交貨日期	
						//sql = "SELECT TSC_RFQ_GET_TSCA_SSD("+strOrderType+",'"+(strFactory.equals("002") || strFactory.equals("008") ?"SEA(UC)":"AIR(UC)")+"','"+strCRD+"') FROM DUAL";
						//sql = "SELECT TSC_RFQ_GET_TSCA_SSD("+strOrderType+",'"+shippingMethodName+"','"+strCRD+"') FROM DUAL"; //modify by Peggy 20140819
						sql = "SELECT TSCA_GET_ORDER_SSD("+strOrderType+",'"+shippingMethodName+"','"+strCRD+"','CRD',trunc(sysdate),null) FROM DUAL"; //modify by Peggy 20161019
						Statement statement2=con.createStatement();
						ResultSet rs2 = statement2.executeQuery(sql);
						if (rs2.next())
						{
							strRequestDate	= rs2.getString(1);			 
						}
						else
						{
							strRequestDate = "";
						}
						rs2.close();
						statement2.close();
					}
				}

				sb.append("<td style='font-size:11px;font-family:arial'>"+strCRD+"</td>");
				sb.append("<td style='font-size:11px;font-family:arial'>"+strRequestDate+"</td>");				
				sb.append("<td style='font-size:11px;font-family:arial'>"+shippingMethodName+"</td>");		
				
				//FOB
				sb.append("<td style='font-size:11px;font-family:arial'>"+strFOB+"</td>");

				//CUSTOMER PO
				sb.append("<td style='font-size:11px;font-family:arial'>"+strCustPO+"</td>");
				
				
				//END CUSTOMER
				if (strEndCust == null || strEndCust.equals(""))
				{
					strEndCust = "";
				}
				else if (strERPEndCustomerID !=null && !strERPEndCustomerID.equals(""))
				{
					strErr +="End Customer與End Customer ID請擇一輸入<br>";
				}
				sb.append("<td style='font-size:11px;font-family:arial'>?01</td>");
				
				//REMARK
				if (strLineRemark == null || strLineRemark.equals(""))
				{
					strLineRemark = "";
				}
				if (strErr.length() >0) ErrCnt ++;
				sb.append("<td style='font-size:11px;font-family:arial'>"+strLineRemark +"</td>");
				
				//End Customer ID
				if (strERPEndCustomerID == null || strERPEndCustomerID.equals(""))
				{
					strERPEndCustomerID = "";
				}
				else
				{
					strEndCust ="";strEndCustID="";
					//end customer id不可與customer id相同
					if (strERPEndCustomerID.equals(CustomerNo))
					{
						strEndCust = "";
						strErr += "End Customer ID不可與Customer ID相同<br>";
					}
					else
					{
						if (rss.isBeforeFirst() ==false) rss.beforeFirst();
						while (rss.next())
						{
							if (rss.getString("customer_number").equals(strERPEndCustomerID))
							{
								strEndCust = rss.getString("CUSTOMER_NAME_PHONETIC");
								strEndCustID=""+rss.getLong("customer_id");
								break;
							}
						}
						if (strEndCust.equals(""))
						{
							strEndCust = "";
							strErr +=("查無ERP Customer ID:"+strERPEndCustomerID+"<br>");
						}
					}					
				}
				
				//cust po line#必填,add by Peggy 20200430
				if (strCustPoLineNo==null || strCustPoLineNo.equals("") || strCustPoLineNo.equals("'"))
				{
					strErr +=("請輸入customer po line number<br>");
				}
				
							
				//cust po#必填,add by Peggy 20210223
				if (strLineCustPoNo==null || strLineCustPoNo.equals("") || strLineCustPoNo.equals("'"))
				{
					strErr +=("請輸入customer po number<br>");
				}
				else
				{
					//TSCA訂單Link ADD BY Peggy 20240105
					strOrigSoLineID="";
					if (strLineCustPoNo.startsWith("SB"))
					{
						sql =" select a.line_id "+
							 " from ont.oe_order_lines_all a"+
							 ",ont.oe_order_headers_all b"+
							 " where a.header_id=b.header_id"+
							 " and b.org_id=1046"+
							 " and a.attribute1='"+strLineCustPoNo+"'"+
							 " and a.attribute11='"+strCustPoLineNo.replace("'","")+"'"+
							 " and ORDERED_QUANTITY-nvl(CANCELLED_QUANTITY,0)-nvl(a.SHIPPING_QUANTITY,0)>0";
						Statement state1=con.createStatement();
						ResultSet rs1=state1.executeQuery(sql);
						if (rs1.next())
						{
							strOrigSoLineID = rs1.getString("line_id");
						} 
						rs1.close();
						state1.close();		
	
					}
					else if (strLineCustPoNo.startsWith("9"))
					{
						sql = " select line_id "+
							  " from ont.oe_order_lines_all a"+
							  ",ont.oe_order_headers_all b"+
							  " where a.header_id=b.header_id"+
							  " and b.order_number='"+strLineCustPoNo+"'"+
							  " and a.line_number||'.'||a.shipment_number='"+strCustPoLineNo.replace("'","")+"'";
						//out.println(sql);
						Statement state1=con.createStatement();
						ResultSet rs1=state1.executeQuery(sql);
						if (rs1.next())
						{
							strOrigSoLineID = rs1.getString("line_id");
						} 
						rs1.close();
						state1.close();				
					}
					if (strOrigSoLineID.equals(""))
					{
						strErr +=("查無對應TSCA銷售訂單,請確認CUST PO是否正確?<br>");
					}
				}			
													
				if (sb.indexOf("?01") >=0) sb.replace(sb.indexOf("?01"),sb.indexOf("?01")+3,strEndCust);
				sb.append("<td style='font-size:11px;font-family:arial'>"+strERPEndCustomerID +"</td>");
				
				sb.append("<td style='color:#ff0000;font-size:11px;font-family:arial'>"+(strErr.equals("")?"":strErr)+"</td></tr>");
				strErr ="";
				Statement state1=con.createStatement();
				sql = " select wf.LINE_TYPE_ID,ORDER_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
					  " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
		  			  " and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
	  				  " and c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+strOrderType+"')"+
					  " and END_DATE_ACTIVE is NULL and vl.name like 'S%Finished Goods_Affiliated'";
				//out.println(sql);
				ResultSet rs1=state1.executeQuery(sql);
				if (rs1.next())
				{
					strLineType = rs1.getString("LINE_TYPE_ID");
					if (strOtypeID.equals("")) strOtypeID = rs1.getString("ORDER_TYPE_ID");
				} 
				else 
				{ 
					strLineType ="0"; 
				} 
				rs1.close();
				state1.close();
				
				aa[icnt][0]=""+(icnt+1);
				aa[icnt][1]=strItemName;
				aa[icnt][2]=strItemDesc;
				aa[icnt][3]=strQty;
				aa[icnt][4]=strUOM;
				aa[icnt][5]=strCRD; 
				aa[icnt][6]=strShippingMethod ;
				aa[icnt][7]=strRequestDate;
				//aa[icnt][8]=strCustPO;
				//aa[icnt][8]=strCustPO+(strRefSO==null||strRefSO.equals("")?"":"("+strRefSO+")"); //modif by Peggy 20180103,ref sales order跟cust po合併在一起
				aa[icnt][8]=strLineCustPoNo+(strRefSO==null||strRefSO.equals("")?"":"("+strRefSO+")"); //modif by Peggy 20180103,ref sales order跟cust po合併在一起
				aa[icnt][9]=strLineRemark.replace("&nbsp;","");
				aa[icnt][10]="N";
				aa[icnt][11]="0";
				aa[icnt][12]="0";
				aa[icnt][13]=strFactory;
				aa[icnt][14]=strCustItem; 
				aa[icnt][15]=strSellingPrice; 
				aa[icnt][16]=strOrderType;
				aa[icnt][17]=strLineType;
				aa[icnt][18]=strFOB;   
				aa[icnt][19]=strCustPoLineNo.replace("'","");     //cust po line#,add by Peggy 20200430
				aa[icnt][20]=""; 
				aa[icnt][21]=strERPEndCustomerID; //erp customer id,add by Peggy 20140819
				aa[icnt][22]="";            //shipping marks,add by Peggy 20130305
				aa[icnt][23]="";            //shipping marks,add by Peggy 20130305
				aa[icnt][24]=strEndCust;          //END customer,add by Peggy 20140819
				aa[icnt][25]=strOrigSoLineID;      //orig so line id,add by Peggy 20150519
				aa[icnt][26]="";            //direct ship to cust,add by Peggy 20160313
				aa[icnt][27]="";            //bi region,add by Peggy 20170222
				aa[icnt][28]="";            //END CUSTOMER SHIP TO ID,add by Peggy 20170512
				aa[icnt][29]="";            //END CUSTOMER PARTNO,add by Peggy 20190225
			
				icnt++;
			}
			wb.close();
			if (icnt ==0)
			{ 
				throw new Exception("上傳內容錯誤!");
			}
			else
			{
				if (sb.length() >0) sb.append("</table>");
			}
			String sql2="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
			PreparedStatement pstmt2=con.prepareStatement(sql2);
			pstmt2.executeUpdate(); 
			pstmt2.close();			 
		}
	}
	catch(Exception e)
	{
		ErrCnt ++;
		if (sb.length() >0) sb.append("</table>");
		strErr=e.getMessage();
	}
	if (ErrCnt >0)
	{
		out.println("<tr><td colspan='3' align='center'><font style='color:#ff0000;font-family:標楷體;font-size:16px'>上傳動作失敗，請洽系統管理員，謝謝!"+(strErr.length()>0?"<br>("+strErr+")":"")+"</font></td></tr>");		
		out.println("<tr><td colspan='3' align='center'>"+sb.toString()+"</td></tr>");
	}
	else
	{
		String bb [][] = new String[icnt+1][oneDArray.length];
		for ( int k = 0 ; k < icnt ; k++)
		{
			for (int g =0 ; g < oneDArray.length ; g++)
			{
				bb[k][g]= aa[k][g];
			}
		}
		String strRemark = "Order Import from file";
		String strCurr = "USD";
		arrayRFQDocumentInputBean.setArray2DString(bb);
		session.setAttribute("SPQCHECKED","N");
		session.setAttribute("CUSTOMERID",CustomerID);
		session.setAttribute("CUSTOMERNO",CustomerNo);
		session.setAttribute("CUSTOMERNAME",CustomerName);
		session.setAttribute("CUSTOMERPO", strCustPO);
		session.setAttribute("CUSTACTIVE","Y");
		session.setAttribute("SALESAREANO",SalesAreaNo);
		session.setAttribute("REMARK",strRemark);
		session.setAttribute("PREORDERTYPE",strOtypeID);
		session.setAttribute("ISMODELSELECTED","Y");
		session.setAttribute("CUSTOMERIDTMP",CustomerID);
		session.setAttribute("INSERT","Y");	
		session.setAttribute("RFQ_TYPE",strRFQType);	
		session.setAttribute("MAXLINENO",""+bb.length);
        session.setAttribute("CURR", strCurr);
		session.setAttribute("PROGRAMNAME","D4-004");
		urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
				 "&SPQCHECKED=N"+
				 "&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
				 "&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName)+
				 "&CUSTACTIVE=A"+
				 "&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
				 //"&SALESPERSON="+java.net.URLEncoder.encode(SalesPerson)+
				 //"&SALESPERSONID="+java.net.URLEncoder.encode(toPersonID)+
				 "&CUSTOMERPO="+java.net.URLEncoder.encode(strCustPO)+
				 "&CURR="+java.net.URLEncoder.encode(strCurr)+
				 "&REMARK="+java.net.URLEncoder.encode(strRemark)+
				 "&PREORDERTYPE="+java.net.URLEncoder.encode(strOtypeID)+
				 "&ISMODELSELECTED=Y"+
				 "&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
				 //"&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerID)+
				 "&INSERT=Y"+
				 "&RFQTYPE="+java.net.URLEncoder.encode(strRFQType)+
				 "&PROGRAMNAME=D4-004";
		try
		{
			response.sendRedirect(urlDir);
		}
		catch(Exception e) 
		{
			out.println("Error:"+e.getMessage());
		}
	}
}
%>
</table>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
</body>
</html>
