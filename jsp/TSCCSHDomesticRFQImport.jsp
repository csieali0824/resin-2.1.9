<!-- 20160313 by Peggy,add sample order direct ship to cust flag-->
<!-- 20161124 by Peggy,抓relationship customer-->
<!-- 20170216 by Peggy,add sales region for bi-->
<!-- 20170511 by Peggy,add  ship_to_id column for end customer -->
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
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 13px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 13px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 13px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 13px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
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
	var chkflag = false;
	var RFQ_TYPE = "";
	var radioLength = document.form1.rfqtype.length;
	if(radioLength == undefined) 
	{
		return;
	}
	for(var i = 0; i < radioLength; i++) 
	{
		if ( document.form1.rfqtype[i].checked)
		{
			RFQ_TYPE = document.form1.rfqtype[i].value;
			chkflag=true;
			break;
		}
	}
	if (chkflag == false)
	{
		alert("請選擇RFQ類型!");
		return false;		
	}	
    document.form1.submit1.disabled=true;
	document.form1.action=URL+"&RFQ_TYPE="+RFQ_TYPE;
	document.form1.submit(); 
}
</script>
</head>
<body>
<%
String CustomerNo = "7883";
String CustomerID = "14980";
String CustomerName ="上海瀚科國際貿易有限公司";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE == null) ACTIONCODE = "";
String SalesAreaNo = "012";
String rfqTypeName1= "NORMAL";
String rfqTypeName2= "FORECAST";
String OrderType="4131";
String OrderTypeName=request.getParameter("OrderTypeName");
if (OrderTypeName==null) OrderTypeName="";
String SalesAreaName = request.getParameter("SalesAreaName");
if (SalesAreaName==null) SalesAreaName="";
String SAMPLEFILE = request.getParameter("SAMPLEFILE");
if (SAMPLEFILE ==null) SAMPLEFILE="";
String RFQ_TYPE = request.getParameter("RFQ_TYPE");
String rfqTypeNormal = "";
String rfqTypeForecast = "";
dateBean.setAdjDate(6);
String chkDate=dateBean.getYearMonthDay();
dateBean.setAdjDate(-6);
String SalesOrgId="";
int icnt=0,ErrCnt=0,sRow=1,rec_cnt=0;
String strLineRemark="",urlDir ="",sql = "",strOtypeID ="",strUOM="",strFactory="",strItemID="",strLineType="",strItemName ="",strCustName="",strCustPO="",strItemDesc="",strQty="",strCustItem="",strSellingPrice="",strCRD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strEndCustID="",strErr="",strShipTo="",end_cust_ship_to_id="";
String strERPEndCustomerID="",strBIRegion="",BIRegionList=""; //add by Peggy 20140813
String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust Po Line No","Quote#","End Customer ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End cust Ship to","End Cust PartNo"};//add by Peggy 20160313
String aa [][] = new String[1][1];
try
{
	sql = "select '('||SALES_AREA_NO||')'||SALES_AREA_NAME from oraddman.tssales_area a where SALES_AREA_NO =?";
	if (UserRoles!="admin" && !UserRoles.equals("admin")) 
	{ 	 
		sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=a.SALES_AREA_NO)";
	}
	PreparedStatement statex = con.prepareStatement(sql);
	statex.setString(1,SalesAreaNo);
	ResultSet rsx=statex.executeQuery();
	if (!rsx.next()) 
	{ 	
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("您沒有此業務區權限,無法使用此功能,謝謝!");
			location.href="../ORAddsMainMenu.jsp";
			//closeWindow();
		</script>
		<%	
	}
	rsx.close();
	statex.close();
}
catch(Exception e)
{
	out.println(e.getMessage());
}
try
{
	if (SalesAreaName.equals(""))
	{
		sql = "select SALES_AREA_NAME ,PAR_ORG_ID from oraddman.tssales_area a  where SALES_AREA_NO=?";
		PreparedStatement statet=con.prepareStatement(sql);
		statet.setString(1,SalesAreaNo);
		ResultSet rs=statet.executeQuery();
		if (rs.next())
		{
			SalesAreaName=rs.getString(1);
			SalesOrgId=rs.getString(2);
		}
		rs.close();
		statet.close();
	}
	
	//if (CustomerName.equals(""))
	//{
	//	sql = "select customer_name from ar_customers a  where customer_id=?";
	//	PreparedStatement statet=con.prepareStatement(sql);
	//	statet.setString(1,CustomerID);
	//	ResultSet rs=statet.executeQuery();
	//	if (rs.next())
	//	{
	//		CustomerName=rs.getString(1);
	//	}
	//	rs.close();
	//	statet.close();
	//}
	
	if (OrderTypeName.equals(""))
	{
		sql = "select OTYPE_NAME from oraddman.tsarea_ordercls a  where SAREA_NO=? and ORDER_NUM=? ";
		PreparedStatement statet=con.prepareStatement(sql);
		statet.setString(1,SalesAreaNo);
		statet.setString(2,OrderType);
		ResultSet rs=statet.executeQuery();
		if (rs.next())
		{
			OrderTypeName=rs.getString(1);
		}
		rs.close();
		statet.close();
		
		Statement state1=con.createStatement();
		sql = " select wf.LINE_TYPE_ID,ORDER_TYPE_ID from APPS.OE_WORKFLOW_ASSIGNMENTS wf, APPS.OE_TRANSACTION_TYPES_TL vl"+ 
			  " where wf.LINE_TYPE_ID = vl.TRANSACTION_TYPE_ID and wf.LINE_TYPE_ID is not null "+
			  " and vl.language = 'US' and exists (select 1 from ORADDMAN.TSAREA_ORDERCLS c  where c.OTYPE_ID= wf.ORDER_TYPE_ID"+
			  " and c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+OrderType+"')"+
			  " and END_DATE_ACTIVE is NULL and vl.name like 'Y_S%Finished Goods_Affiliated'";
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
	}
}
catch(Exception e)
{	
	out.println("<font color='red'>exception:"+e.getMessage()+"</font>");
}
%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">

<table width="100%" align="center" border="0">
	<tr>
		<td width="20%">&nbsp;</td>
		<td width="60%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
				<tr>
					<td height="50" align="center"><font style="color:#003399;font-weight:bold;font-family:Tahoma,Georgia;font-size:20px">TSCC-SH 內銷</font><font style="font-weight:bold;font-family:Tahoma,Georgia;font-size:20px"> Upload To Create a New RFQ Order</font></td>
				</tr>
			</table>
		</td>
		<td width="20%">&nbsp;</td>
	</tr>
	<tr>
		<td width="20%">&nbsp;</td>
		<td width="60%">
			<table align="center" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
				<tr>
					<TD width="90%">&nbsp;
					</TD>
					<TD>
						<A HREF="../ORAddsMainMenu.jsp" style="font-size:13px;font-family:Tahoma,Georgia;text-decoration:none;color:#0000FF">
						<STRONG>回首頁</STRONG>
						</A>					
					</TD>
				</tr>
				<tr>
					<td colspan="2">
						<table  bordercolordark="#CCCCCC" cellspacing="0"  cellpadding="0" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">Sales Region：</td>
								<td ><%="("+SalesAreaNo+")"+ SalesAreaName%></td>
			  				</tr>
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">Customer Name：</td>
								<td ><%="("+CustomerNo+")"+ CustomerName%></td>
		  					</tr>
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">Order Type：</td>
								<td ><%="("+OrderType+")"+OrderTypeName%></td>
		  					</tr>
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">RFQ Type：</td>
								<td ><input type="radio" name="rfqtype" value="<%=rfqTypeName1%>" <%=rfqTypeNormal%> style="border:none;font-family:Tahoma,Georgia;font-size:13px"><%=rfqTypeName1%>
									&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="rfqtype" value="<%=rfqTypeName2%>" <%=rfqTypeForecast%> style="border:none;font-family:Tahoma,Georgia;font-size:13px"><%=rfqTypeName2%>
								</td>
		  					</tr>
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">Upload File：</td>
								<td width="85%" ><INPUT TYPE="FILE" style="font-family:Tahoma,Georgia;font-size:13px" NAME="UPLOADFILE" size="80"></td>
			  				</tr>
			  				<tr>
								<td style="background-color:#C9D5EF" align="right">Sample File：</td>
								<td width="85%" ><A HREF="../jsp/samplefiles/D4-016_SampleFile.xls" style="font-family:Tahoma,Georgia;font-size:13px">Download Sample File</font></A></td>
			  				</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2" title="按下此鍵,匯入資料!" align="center">
					<input type="button" style="font-size:13px;font-family:Tahoma,Georgia" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCCSHDomesticRFQImport.jsp?ACTIONCODE=INSERT')">
					</td>
				</tr>
			</table>
		</td>
		<td width="20%">&nbsp;</td>
	</tr>
</table>
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
			cs1.setString(1,SalesOrgId);  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
		
			String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
			PreparedStatement pstmt1=con.prepareStatement(sql1);
			pstmt1.executeUpdate(); 
			pstmt1.close();
			
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
						  " and c.customer_number <>'"+CustomerNo+"'"+
						  " order by c.customer_id";
			Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rss = statements.executeQuery(sql);						  
				
 		
			sql =  " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ 
					 " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
					 " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,d.CURRENCY_CODE"+ 
					 ",a.tax_code" + 
					 " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c,SO_PRICE_LISTS d"+
					 " where  a.ADDRESS_ID = b.cust_acct_site_id"+
					 " AND b.party_site_id = party_site.party_site_id"+
					 " AND loc.location_id = party_site.location_id "+
					 " and a.STATUS='A' "+
					 " and a.PRIMARY_FLAG='Y'"+
					 " and b.CUST_ACCOUNT_ID ='"+CustomerID+"'"+
					 " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
					 " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
					 " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end";   
			//out.println(sql);
			Statement statementx=con.createStatement();
			ResultSet rsx=statementx.executeQuery(sql);
			while (rsx.next())
			{
				if (strShippingMethod.equals("")) strShippingMethod=rsx.getString("ship_via");
				if (strFOB.equals("")) strFOB=rsx.getString("fob_point");
			}
			rsx.close();
			statementx.close();	
				
			//BI REGION
			Statement statet=con.createStatement();
			sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
        	ResultSet rst=statet.executeQuery(sql);
			while (rst.next())
			{
				BIRegionList += (rst.getString("A_VALUE")+";");
			}	
			rst.close();
			statet.close();
												  		
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4016_"+strDateTime+"-"+uploadFile_name;
			upload_file.saveAs(uploadFilePath); 
			java.util.Date datetime = new java.util.Date();
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String CreationDate = (String) formatter.format( datetime );
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
				
			arrayRFQDocumentInputBean.setArrayString(oneDArray);
			aa = new String[sht.getRows()-sRow][oneDArray.length];
			
			//line detail
			for (int i = sRow; i <sht.getRows(); i++) 
			{
				//CUSTOMER PO#
				jxl.Cell cellCustPO  = sht.getCell(0,i); 
				strCustPO = cellCustPO.getContents();		

				//台半料號
				jxl.Cell cellItemName = sht.getCell(1,i);          
				strItemName = (cellItemName.getContents()).trim();
				if (strItemName == null) strItemName= "";
					
				//台半品名
				jxl.Cell cellItemDesc = sht.getCell(2,i);          
				strItemDesc = (cellItemDesc.getContents()).trim();
				if (strItemDesc == null) strItemDesc= "";

				//客戶品號
				jxl.Cell cellCustItem = sht.getCell(3,i);          
				strCustItem = (cellCustItem.getContents()).trim();
				if (strCustItem == null) strCustItem= "";
				
				// REQUEST DATE
				jxl.Cell cellRDATE = sht.getCell(4,i);
				SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");
				strRequestDate =sy1.format(((DateCell)cellRDATE).getDate());
				
				//數量
				jxl.Cell cellQty = sht.getCell(5,i);  
				if (cellQty.getType() == CellType.NUMBER) 
				{
					strQty = ""+((NumberCell) cellQty).getValue();
				} 
				else strQty = (cellQty.getContents()).trim();
				if (strQty == null) strQty="0";
				
				//單價
				jxl.Cell cellSellingPrice = sht.getCell(6,i);  
				if (cellSellingPrice.getType() == CellType.NUMBER) 
				{
					strSellingPrice = ""+((NumberCell) cellSellingPrice).getValue();
				} 
				else strSellingPrice = (cellSellingPrice.getContents()).trim();
				if (strSellingPrice == null) strSellingPrice="0";

				//END CUSTOMER#
				jxl.Cell cellERPEndCustomerID = sht.getCell(7,i);          
				strERPEndCustomerID=(cellERPEndCustomerID.getContents()).trim();
				if (strERPEndCustomerID==null) strERPEndCustomerID="";
			
				//END CUSTOMER
				jxl.Cell cellEndCust = sht.getCell(8,i);          
				strEndCust = (cellEndCust.getContents()).trim();
					
				//REMARK
				jxl.Cell cellRemark = sht.getCell(9,i);          
				strLineRemark = (cellRemark.getContents()).trim();

				//bi region,add by Peggy 20170218
				jxl.Cell cellBIRegion = sht.getCell(10, i);          
				strBIRegion = (cellBIRegion.getContents()).trim();
				
				//SHIP TO ORG ID,add by Peggy 20170511
				jxl.Cell cellShipTo = sht.getCell(11,i);
				strShipTo = cellShipTo.getContents();
				
				strErr ="";strItemID="";rec_cnt=0;strUOM="";strFactory="";//初始化
	 
	 			if (strCustPO==null || strCustPO.equals(""))
				{
					strErr += "Customer PO#不可空白";
				}
				
				//品名	
				if ((strItemName  == null || strItemName.equals("")) && (strItemDesc  == null || strItemDesc.equals("")) && (strCustItem == null && strCustItem.equals("")))
				{
					strErr += "台半品名,料號及客戶品名不可同時空白<br>";
				}
				else
				{
					CallableStatement cs2 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
					cs2.setString(1,"41");  // 取業務員隸屬ParOrgID
					cs2.execute();
					cs2.close();
									 
					//if ((strCustItem != null && !strCustItem.equals("")) || (strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals("")))
					if (strCustItem != null && !strCustItem.equals(""))
					{						  
						sql = " select  DISTINCT a.item"+
						      ",a.ITEM_DESCRIPTION"+
							  ",a.INVENTORY_ITEM_ID"+
							  ",a.INVENTORY_ITEM"+
							  ",a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
							  ",NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
							  //",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
							  ",tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE"+  //modify by Peggy 20191122
							  ",TSC_OM_CATEGORY(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP') as TSC_PROD_GROUP"+
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
						      " and msi.inventory_item_status_code <> 'Inactive'";//add by Peggy 20130221
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
							if (rs.getString("TSC_PROD_GROUP").startsWith("PRD"))
							{
								strItemName = rs.getString("INVENTORY_ITEM");
								strItemID = rs.getString("INVENTORY_ITEM_ID");	
								strItemDesc = rs.getString("ITEM_DESCRIPTION");
								//strCustItem = rs.getString("item");
								strUOM = rs.getString("PRIMARY_UOM_CODE");
								strFactory = "002"; //固定YEW
							}
							rec_cnt++;
						}
						rs.close();
						statement.close();
					}
					if (rec_cnt==0)
					{
						if (((strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals(""))) && (strCustItem == null || strCustItem.equals("")))
						{
							sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3,"+
								  //" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3)  AS order_type"+
								  " tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type"+  //modify by Peggy 20191122
							      ",TSC_OM_CATEGORY(msi.inventory_item_id,msi.organization_id,'TSC_PROD_GROUP') as TSC_PROD_GROUP"+
								  " FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c"+
								  " WHERE msi.inventory_item_id = c.inventory_item_id"+
								  " AND msi.organization_id = c.organization_id"+
								  " AND msi.organization_id = '49'"+
								  " AND c.category_set_id = 6"+
								  " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+   //add by Peggy 20151008
								  " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+ //add by Peggy 20151008
								  " AND msi.inventory_item_status_code <> 'Inactive'";//add by Peggy 20130221
							if (strItemDesc != null && !strItemDesc.equals("")) sql += " AND msi.description =  '"+strItemDesc+"'";	
							if (strItemName != null && !strItemName.equals("")) sql += " AND msi.segment1 =  '"+strItemName+"'";	
							//out.println(sql);
							Statement statement=con.createStatement();
							ResultSet rs = statement.executeQuery(sql); 
							while(rs.next())
							{
								//out.println("***"+sql);
								if (rs.getString("TSC_PROD_GROUP").startsWith("PRD"))
								{								
									strItemName = rs.getString("segment1");
									strItemID = rs.getString("INVENTORY_ITEM_ID");	
									strItemDesc = rs.getString("description");
									strCustItem = "&nbsp;";
									strUOM = rs.getString("PRIMARY_UOM_CODE");
									strFactory ="002";
								}
								rec_cnt++;
							}
							rs.close();
							statement.close();
						}			
					}
					if (rec_cnt==0)
					{
						strErr += "查無對應的ERP料號<br>";
					}
					else if (rec_cnt >=1)
					{
						if (strItemID.equals(""))
						{
							strErr += "此型號產品別不是PRD<br>";
						}
						else if (rec_cnt >1)
						{
							strErr += "對應的台半料號超過一個以上,請選擇正確台半料號<br>";
						}
					}	
				}

				//REQUEST DATE
				if (strRequestDate == null || strRequestDate.equals(""))
				{
					strErr +="Request Date不可空白<br>";
				}
				else if (strRequestDate.length()!=8)
				{
					strErr +="Request Date錯誤<br>";
				}
				else if (Long.parseLong(chkDate)>Long.parseLong(strRequestDate))
				{
					strErr +="Request Date必須大於"+chkDate+"<br>";
				}
				
				//數量	
				if (strQty == null || strQty.equals(""))
				{
					strQty = "&nbsp;";
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
							strQty=(new DecimalFormat("#######0.##")).format(qtynum);
						}
					}
					catch (Exception e)
					{
						strErr += "數量格式錯誤<br>";
					}
				}

				//單價
				if (strSellingPrice != null && !strSellingPrice.equals(""))
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

				//End Customer No
				if (strERPEndCustomerID == null || strERPEndCustomerID.equals(""))
				{
					strErr += "End Customer#必須輸入<br>";
				}
				else
				{
					strEndCust ="";strEndCustID="";
					//end customer id不可與customer id相同
					if (strERPEndCustomerID.equals(CustomerNo))
					{
						strEndCust = "&nbsp;";
						strErr += "End Customer#不可與Customer相同<br>";
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
						if (strEndCust ==null || strEndCust.equals(""))
						{
							//add by Peggy 20161124,抓relationship customer
							sql =" SELECT  c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC  "+
							     " FROM ar_customers a,ar.hz_cust_acct_relate_all b,ar_customers c"+
                                 " where a.customer_id=b.RELATED_CUST_ACCOUNT_ID"+
                                 " and b.STATUS ='A'"+
                                 " and a.customer_id="+CustomerID+""+
                                 " and b.cust_account_id=c.customer_id"+
                                 " and c.customer_number="+strERPEndCustomerID+"";
							Statement statementy=con.createStatement();
							ResultSet rsy=statementy.executeQuery(sql);
							if (rsy.next())
							{
								strEndCust = rsy.getString("CUSTOMER_NAME_PHONETIC");
								strEndCustID =""+rsy.getInt("customer_id");							
							}
							rsy.close();
							statementy.close();	
														
							if (strEndCust ==null || strEndCust.equals(""))
							{
								strEndCust = "&nbsp;";
								strErr +=("查無ERP Customer ID:"+strERPEndCustomerID+"<br>");
							}
						}
					}					
				}

				//END CUSTOMER
				if (strEndCust == null || strEndCust.equals(""))
				{
					strEndCust = "&nbsp;";
				}
				
				//REMARK
				if (strLineRemark == null || strLineRemark.equals(""))
				{
					strLineRemark = "&nbsp;";
				}
				
				//BI Region,add by Peggy 20170218	
				if (strBIRegion ==null || strBIRegion.equals(""))
				{
					strErr += "BI Region不可空白<br>";				
				}
				else
				{
					boolean bolExist = false;
					String [] strarray= BIRegionList.split(";");
					for (int x = 0 ; x < strarray.length ; x++)
					{
						if (strBIRegion.equals(strarray[x]))
						{
							bolExist = true;
						}
					}
					if (!bolExist) strErr +=  "BI Region必須為"+BIRegionList.replace(";","或")+"<br>";				
				}
				
				//end customer ship to location id,add by Peggy 20170511
				end_cust_ship_to_id="";
				if (strShipTo!=null && !strShipTo.equals(""))
				{
					sql = " SELECT SITE_USE_ID FROM HZ_CUST_SITE_USES_ALL a,HZ_CUST_ACCT_SITES_ALL b"+
                          " WHERE  a.SITE_USE_CODE='SHIP_TO'"+
                          " AND a.CUST_ACCT_SITE_ID=b.CUST_ACCT_SITE_ID"+
						  " AND b.CUST_ACCOUNT_ID='"+strEndCustID+"'"+
                          " AND a.LOCATION='"+strShipTo+"'"+
                          " AND NVL(a.STATUS,'I')='A'";
					Statement statementb=con.createStatement();
					ResultSet rsb=statementb.executeQuery(sql);
					if (!rsb.next())
					{	
						strErr +=  "End customer ship to id not found<br>";
					}	
					else 
					{
						end_cust_ship_to_id = strShipTo;
					}
					rsb.close();	
					statementb.close();			  
				}
				
				if (strErr.length() >0)
				{
					ErrCnt ++;
					if (ErrCnt==1)
					{
						%>	
						<table cellspacing="1" bordercolordark="#CC9966" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
							<tr style="background-color:#FF9966;font-size:11px">
								<td width="2%">Line#</td>
							  	<td width="10%">Customer PO#</td>
					          	<td width="12%">TSC Item Name</td>
							  	<td width="10%">TSC Item Desc</td>
							  	<td width="10%">Customer Item</td>
							  	<td width="6%">Request Date	</td>
							  	<td width="6%">Qty(K)</td>
							  	<td width="6%">Unit Price</td>
							  	<td width="6%">End Customer Num</td>
							  	<td width="10%">End Customer</td>
							  	<td width="10%">Remark</td>
							  	<td width="16%">Error Message</td>
							</tr>
						<%
					}
					%>
					<tr style="font-size:11px">
						<td><%=ErrCnt%></td>
						<td><%=strCustPO%></td>
						<td><%=((strItemName==null || strItemName.equals(""))?"&nbsp;":strItemName)%></td>
						<td><%=((strItemDesc==null || strItemDesc.equals(""))?"&nbsp;":strItemDesc)%></td>
						<td><%=((strCustItem==null || strCustItem.equals(""))?"&nbsp;":strCustItem)%></td>
						<td><%=strRequestDate%></td>
						<td><%=strQty%></td>
						<td><%=(strSellingPrice==null?"&nbsp;":strSellingPrice)%></td>
						<td><%=strERPEndCustomerID%></td>
						<td><%=strEndCust%></td>
						<td><%=strLineRemark%></td>
						<td style="color:#ff0000"><%=strErr%></td>
					</tr>
					
					<%
				}
				
				aa[icnt][0]=""+(icnt+1);
				aa[icnt][1]=strItemName;
				aa[icnt][2]=strItemDesc;
				aa[icnt][3]=strQty;
				aa[icnt][4]=strUOM;
				aa[icnt][5]="&nbsp;"; 
				aa[icnt][6]=strShippingMethod ;
				aa[icnt][7]=strRequestDate;
				aa[icnt][8]=strCustPO;
				aa[icnt][9]=strLineRemark.replace("&nbsp;","");
				aa[icnt][10]="N";
				aa[icnt][11]="0";
				aa[icnt][12]="0";
				aa[icnt][13]=strFactory;
				aa[icnt][14]=strCustItem; 
				aa[icnt][15]=strSellingPrice; 
				aa[icnt][16]=OrderType;
				aa[icnt][17]=strLineType;
				aa[icnt][18]=strFOB;   
				aa[icnt][19]="&nbsp;"; 
				aa[icnt][20]="&nbsp;"; 
				aa[icnt][21]=strERPEndCustomerID; 
				aa[icnt][22]="&nbsp;";           
				aa[icnt][23]="&nbsp;";          
				aa[icnt][24]=strEndCust;     
				aa[icnt][25]="&nbsp;";           
				aa[icnt][26]="&nbsp;";     
				aa[icnt][27]=strBIRegion; //add by Peggy 20170218			
				aa[icnt][28]=end_cust_ship_to_id; //add by Peggy 20170511		
				aa[icnt][29]="&nbsp;"; //add by Peggy 20190312
			
				icnt++;
			}
			wb.close();
			if (icnt ==0)
			{ 
				throw new Exception("上傳內容錯誤!");
			}
			else
			{
				if (ErrCnt>0)
				{
				%>
					</table>
				<%
				}
			}
		}
	}
	catch(Exception e)
	{
		ErrCnt ++;
		strErr=e.getMessage();
	}
	if (ErrCnt >0)
	{
		out.println("<div style='color:#ff0000;font-family:ahoma,Georgia;font-size:13px' align='center'>上傳動作失敗，請洽系統管理員，謝謝!</div>");		
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
		session.setAttribute("RFQ_TYPE",RFQ_TYPE);	
		session.setAttribute("MAXLINENO",""+bb.length);
        session.setAttribute("CURR", strCurr);
		session.setAttribute("PROGRAMNAME","D4-016");
		urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
				 "&SPQCHECKED=N"+
				 "&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
				 "&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName)+
				 "&CUSTACTIVE=A"+
				 "&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
				 "&CUSTOMERPO="+java.net.URLEncoder.encode(strCustPO)+
				 "&CURR="+java.net.URLEncoder.encode(strCurr)+
				 "&REMARK="+java.net.URLEncoder.encode(strRemark)+
				 "&PREORDERTYPE="+java.net.URLEncoder.encode(strOtypeID)+
				 "&ISMODELSELECTED=Y"+
				 "&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
				 "&INSERT=Y"+
				 "&RFQTYPE="+java.net.URLEncoder.encode(RFQ_TYPE)+
				 "&PROGRAMNAME=D4-016";
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
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
</body>
</html>
