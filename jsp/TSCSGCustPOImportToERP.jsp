<%@ page contentType="text/html; charset=utf-8" language="java" %>
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
<title>SG Order Import</title>
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
    document.form1.submit1.disabled=true;
	document.getElementById("alpha").style.width="100"+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';	
	document.form1.action=URL;
	document.form1.submit(); 
}
function setchk(svalue)
{
	var ckLength = document.form1.checkbox1.length;
	for(var i = 0; i <= ckLength; i++) 
	{
		if ( document.form1.checkbox1[i].value!=svalue)
		{
			document.form1.checkbox1[i].checked = false;
		}
	}
}
function focuscolor(objid)
{
	var color2 = document.form1.HIGHLIGHTOLOR.value;
	color2=color2.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color2;
	document.getElementById("tdo"+objid).style.backgroundColor =color2;
	document.getElementById("tdc"+objid).style.backgroundColor =color2;
	for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
	{
		document.getElementsByName("tdb"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdg"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdh"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdi"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdj"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdk"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdl"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdm"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdn"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdr"+objid)[i].style.backgroundColor =color2;
	}
}
function unfocuscolor(objid)
{
	var color1 = document.form1.ROWCOLOR.value;
	color1=color1.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color1;
	document.getElementById("tdo"+objid).style.backgroundColor =color1;
	document.getElementById("tdc"+objid).style.backgroundColor =color1;
	for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
	{
		document.getElementsByName("tdb"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdg"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdh"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdi"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdj"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdk"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdl"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdm"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdn"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdr"+objid)[i].style.backgroundColor =color1;
	}
}
function delData(URL)
{ 
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.form1.action=URL+"&ACTIONCODE=DETAIL";		
		document.form1.submit();
	}
}
function toRFQ(URL)
{ 
	document.form1.action=URL;		
	document.form1.submit();
}
function setSearch(URL)
{  
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline; font-size: 12px  }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
</head>
<body>
<%
String sType = request.getParameter("STYPE");
if (sType==null) sType="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE == null) ACTIONCODE = "";
String SalesAreaNo = "002";
String SalesArea = "";
String SAMPLEFILE = request.getParameter("SAMPLEFILE");
if (SAMPLEFILE ==null) SAMPLEFILE="";
String MTYPE= request.getParameter("MTYPE");
if (MTYPE ==null) MTYPE="";	
String CustomerID=request.getParameter("CUSTOMERID");
String CustomerNo=request.getParameter("CUSTOMERNO");
String CustomerName=request.getParameter("CUSTOMERNAME");
String CustomerPO=request.getParameter("CUSTOMERPO");
String strRemark="Order Import from file";
String DelFlag=request.getParameter("DELFLAG");
if (DelFlag==null) DelFlag="";
String InsertFlag=request.getParameter("INSERTFLAG");
if (InsertFlag==null) InsertFlag="";
String CUSTNAME = request.getParameter("CUSTNAME");
if (CUSTNAME == null) CUSTNAME="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO="";
String UPLOADBY = request.getParameter("UPLOADBY");
if (UPLOADBY == null) UPLOADBY="";
String SHIPTO = request.getParameter("SHIPTO");
if (SHIPTO == null) SHIPTO="";
String rfqTypeName1= "NORMAL";
String rfqTypeName2= "FORECAST";
String ODRTYPE=request.getParameter("ODRTYPE");
String RFQ_TYPE = request.getParameter("RFQ_TYPE");
String TEMP_ID = request.getParameter("TEMP_ID");
if (TEMP_ID==null) TEMP_ID="";
String rfqTypeNormal = "";
String rfqTypeForecast = "";
int icnt=0,ErrCnt=0,sRow=1,rec_cnt=0,insert_cnt=0,col_cnt=37,rfq_col_cnt=30,v_org_id=0,v_Year=0,v_Month=0,v_Days=0;
String seqno="",seqkey="",strURL="",strTempId="",PREORDERTYPE="";
String salesPerson="",toPersonID="";
String IDTYPE = "CUSTID",POTYPE="CUSTPO",strCurr="";
String strCustNo="",strCustID="",strLineCustPO="",strLineCustPOLineNo="",strLineRemark="",FOBList="",ShippingMethodList="",urlDir ="",OrderTypeList="";
String sql = "",strOtypeID ="",strUOM="KPC",strFactory="",strHeaderOrderType="",strItemID="",strBIRegion="";
String strLineType="",strItemName ="",strOrderType="",strOrderTypeID="",strCustName="",strCustPO="",strRFQType="",strItemDesc="",strPaymentTerm="",strTax="",strPriceList="",strBillTo="";
String strQty="",strCustItem="",strSellingPrice="",strCRD="",strSSD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strErr="",strShipTo="";
String rowColor="#ffffff",highlightColor="#EEDDCC";
String bkcolor="#C6D1E6";
String strEndCustID ="",strEndCustID1 ="",BIRegionList=""; 
String shipToContact="",shipToContactid="",group_id="";
String oneDArray[] = new String [col_cnt];
String aa [][] = new String[1][1];
String bb [][] = new String[1][1];
String strK3OrderNo="",strK3OrderLineNo="",strUom="",strK3CustCode="",strSampleOrder="",strK3AddrCode="",strEndCust1="",strEndCustShipTo="";
SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
%>

<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%" align="center" border="0">
	<tr>
		<td width="20%">&nbsp;</td>
		<td width="60%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
				<tr>
					<td height="50" align="center"><font style="color:#003399;font-weight:bold;font-family:Tahoma,Georgia;font-size:20px">SG PO轉ERP訂單</font></td>
				</tr>
				<tr>
					<TD align="right" width="100%" title="回首頁!">
						<A HREF="../ORAddsMainMenu.jsp" style="font-size:13px;font-family:標楷體;text-decoration:none;color:#0000FF">
						<STRONG>回首頁</STRONG>
						</A>
					</TD>
				</tr>
				<tr>
					<td colspan="2">
						<table  bordercolordark="#000033" cellspacing="0"  cellpadding="0" width="100%" align="left" bordercolorlight="ffffff" border="1">
			  				<tr>
								<td align="right">Upload File：</td>
								<td width="85%" ><INPUT TYPE="FILE" style="font-family:Tahoma,Georgia;font-size:13px" NAME="UPLOADFILE" size="90"></td>
			  				</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2" title="請按我，謝謝!" align="center">
						<input type="button" style="font-size:13px;font-family: Tahoma,Georgia;" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCSGCustPOImportToERP.jsp?ACTIONCODE=UPLOAD')">
					</td>
				</tr>
				
			</table>
		</td>
		<td width="20%">&nbsp;</td>
	</tr>
</table>
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
			
if (ACTIONCODE.equals("UPLOAD"))
{
	try
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		String strDate=dateBean.getYearMonthDay();
		String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond(); 
		dateBean.setAdjDate(7);
		String strCHKDate = dateBean.getYearMonthDay();
		dateBean.setAdjDate(-7);
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
			cs1.setString(1,"325");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
		
			sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO in ('012','022')) d"+
						  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
						  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
						  " and a.ORG_ID = d.PAR_ORG_ID"+
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and c.STATUS='A'"+
						  " order by c.customer_id";
			Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rsi = statements.executeQuery(sql);
				
			cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();
		
			sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
						  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						  " ,(select * from oraddman.tssales_area where SALES_AREA_NO in ('002')) d"+
						  " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
						  " and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						  " and a.STATUS = b.STATUS "+
						  " and a.ORG_ID = b.ORG_ID "+										
						  " and a.ORG_ID = d.PAR_ORG_ID"+
						  " and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
						  " and c.STATUS='A'"+
						  " order by c.customer_id";
			Statement statemento=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rso = statemento.executeQuery(sql);
								
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
			
			//BI REGION
			sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
        	rst=statet.executeQuery(sql);
			while (rst.next())
			{
				BIRegionList += (rst.getString("A_VALUE")+";");
			}
					
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4020_"+strDateTime+"-"+uploadFile_name;
			upload_file.saveAs(uploadFilePath); 
			java.util.Date datetime = new java.util.Date();
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String CreationDate = (String) formatter.format( datetime );
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
	
			arrayRFQDocumentInputBean.setArrayString(oneDArray);
			aa = new String[sht.getRows()-sRow][oneDArray.length];
			//out.println("aa="+aa.length);
			
			//line detail
			for (int i = sRow; i < sht.getRows(); i++) 
			{	
				strCustNo="";strEndCust ="";strEndCustID ="";	
				
				//K3單據號碼
				jxl.Cell cellCol1 = sht.getCell(1,i);
				strK3OrderNo = cellCol1.getContents().trim();
				if (strK3OrderNo==null || strK3OrderNo.equals("")) continue;
	
				//K3單據行號
				jxl.Cell cellCol2 = sht.getCell(2, i);          
				strK3OrderLineNo = (cellCol2.getContents()).trim();
							
				//客戶PO
				jxl.Cell cellCol3 = sht.getCell(3,i);
				strLineCustPO = cellCol3.getContents();
	
				//台半料號
				jxl.Cell cellCol4 = sht.getCell(4, i);          
				strItemName = (cellCol4.getContents()).trim();
	
				//台半品名
				jxl.Cell cellCol5 = sht.getCell(5, i);          
				strItemDesc = (cellCol5.getContents());
				if (strItemDesc == null) strItemDesc= "";
	
				//客戶品號
				jxl.Cell cellCol6 = sht.getCell(6, i);          
				strCustItem = (cellCol6.getContents());
				if (strCustItem == null) strCustItem= "";
				strCustItem=strCustItem.replace(" ","&nbsp;");
				
				//CRD
				jxl.Cell cellColCRD = sht.getCell(7, i);  
				if (cellColCRD.getType() == CellType.DATE) 
				{
					strCRD =sy1.format(((DateCell)cellColCRD).getDate());
				}
				else
				{
					strCRD= (cellColCRD.getContents()).trim();
				}
				if (strCRD != null) strCRD=strCRD.replace("-","/");		
				String  arrayDate[]=strCRD.split("/");
								
				//SSD
				jxl.Cell cellCol7 = sht.getCell(8, i);  
				if (cellCol7.getType() == CellType.DATE) 
				{
					strSSD =sy1.format(((DateCell)cellCol7).getDate());
				}
				else
				{
					strSSD= (cellCol7.getContents()).trim();
				}
				if (strSSD != null & !strSSD.equals(""))
				{
					strSSD=strSSD.replace("-","/");		
				}
				else
				{
					strSSD=strCRD;  
				}				
				String  arrayDate1[]=strSSD.split("/");	
				
				//數量 
				jxl.Cell cellCol8 = sht.getCell(9, i);  
				if (cellCol8.getType() == CellType.NUMBER) 
				{
					strQty = ""+((NumberCell) cellCol8).getValue();
				} 
				else strQty = (cellCol8.getContents()).trim();
				if (strQty == null) strQty="0";
				
				//單位
				jxl.Cell cellCol9 = sht.getCell(10, i);  
				strUom = (cellCol9.getContents()).trim();
				if (strUom == null) strUom= "";
			
				//單價 
				jxl.Cell cellCol10 = sht.getCell(11, i);  
				if (cellCol10.getType() == CellType.NUMBER) 
				{
					strSellingPrice = ""+((NumberCell) cellCol10).getValue();
				} 
				else strSellingPrice = (cellCol10.getContents()).trim();
				if (strSellingPrice == null) strSellingPrice="0";		
			
				//K3客戶代碼
				jxl.Cell cellCol11 = sht.getCell(13, i);  
				strK3CustCode = (cellCol11.getContents()).trim();
				if (strK3CustCode == null) strK3CustCode= "";
				
				//樣品
				jxl.Cell cellCol12 = sht.getCell(17, i);  
				strSampleOrder = (cellCol12.getContents()).trim();
				if (strSampleOrder == null) strSampleOrder= "";			
				strSampleOrder=strSampleOrder.toUpperCase();
						
				//K3優先送貨地址代碼		
				jxl.Cell cellCol13 = sht.getCell(20, i);          
				strK3AddrCode = (cellCol13.getContents()).trim();
				if (strK3AddrCode==null) strK3AddrCode="";
			
				//bi region
				jxl.Cell cellCol14= sht.getCell(23, i);          
				strBIRegion = (cellCol14.getContents()).trim();
							
				strErr ="";strCustID="";strCustName="";strItemID="";rec_cnt=0;strFactory="";strOrderType="";strOrderTypeID="";strEndCust1="";strEndCustShipTo="";//初始化
				strPaymentTerm="";strTax="";strPriceList="";strBillTo="";
				
				if (strK3OrderNo.equals(""))
				{
					strErr += "K3單據編號不可空白<br>";
				}
				
				if (strK3OrderLineNo.equals(""))
				{
					strErr += "K3單據編號項次不可空白<br>";
				}
				
				//檢查K3單據編號是否有待處理資料
				if (strK3OrderNo != null && !strK3OrderNo.equals("") && strK3OrderLineNo !=null && !strK3OrderLineNo.equals(""))
				{
					Statement statementa=con.createStatement();
					ResultSet rsa=statementa.executeQuery("select 1 from oraddman.TSSG_OPEN_ORDERS_IMPORT where K3_ORDER_NO = '"+strK3OrderNo+"'  and K3_ORDER_LINE ='"+strK3OrderLineNo+"' AND ERP_ORDER_NO IS NOT NULL");
					if(rsa.next())
					{
						strErr += "K3單據編號:"+strK3OrderNo+"  K3單據編號項次:"+strK3OrderLineNo+"已存在,不可重複上傳!<br>";
					}
					rsa.close();
					statementa.close(); 
				}	
							
				if ((strItemName != null && !strItemName.equals("")) || (strItemDesc!=null && !strItemDesc.equals("")))
				{
					sql = " SELECT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (case when msi.description in ('SFAF1608G C0','SFAF808G C0') then '002' else msi.attribute3 end, 'N/A') attribute3,"+
						  " case when msi.attribute3='002' or msi.description in ('SFAF1608G C0','SFAF808G C0') then case '"+strSampleOrder +"' when 'Y' then '4121' else '4131' end "+
						  " when msi.attribute3 in ('005','008') then '8131'"+ 
						  " else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) end  AS order_type"+
						  ", count(1) over (partition by msi.description) row_cnt"+
						  " FROM  inv.mtl_system_items_b msi"+
						  " WHERE msi.organization_id=49"+
						  " AND msi.inventory_item_status_code <> 'Inactive'"+
						  " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+         
						  " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'";	
					if (strItemDesc != null && !strItemDesc.equals(""))
					{
						sql +=  " AND msi.description =  '"+strItemDesc+"'";
					}
					if (strItemName != null && !strItemName.equals(""))
					{
						sql += " and msi.segment1 = '"+strItemName+"'";
					}
					Statement statement=con.createStatement();
					ResultSet rs = statement.executeQuery(sql);
					if(rs.next())
					{
						if (rs.getInt("row_cnt")>1)
						{
							strErr +="品名對應兩筆以上的料號,請指定料號<br>";
							strItemID ="";
							
						}
						else
						{
							strItemName = rs.getString("segment1");
							strItemID = rs.getString("INVENTORY_ITEM_ID");	
							strItemDesc = rs.getString("description");
							strFactory = rs.getString("ATTRIBUTE3");
							strOrderType = rs.getString("ORDER_TYPE");
							if (strOrderType.substring(0,1).equals("4"))
							{
								strCustNo="7883";  //上海瀚科國際貿易有限公司
								if (strOrderType.equals("4121"))
								{
									SalesAreaNo="022";
								}
								else
								{
									SalesAreaNo="012";
								}
								v_org_id=325;
							}
							else if (strOrderType.substring(0,1).equals("1")) 
							{
								strCustNo="8103";  //SHANGHAI GREAT TECHNOLOGY TRADING CO.LTD.
								SalesAreaNo="002";
								v_org_id=41;
							}
							else if (strOrderType.substring(0,1).equals("8"))  
							{
								SalesAreaNo="023";
								v_org_id=886;
							}
							else
							{
								strErr +="未經定義的訂單類型<br>";
							}
						}
					}
					else
					{
						strErr +="ERP未定義台半料號:"+strItemName+"<br>";
					}
					rs.close();
					statement.close();
					
					if (!strItemID.equals(""))
					{
						cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,""+v_org_id);  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();	
										
									
						//檢查優先送貨地址
						strEndCustID1="";
						if (!strK3AddrCode.equals(""))
						{
							sql = " SELECT erp_ship_to_location_id,ERP_CUSTOMER_ID  FROM oraddman.tscc_k3_addr_link_erp a"+
								  " WHERE  a.addr_code='"+strK3AddrCode+"'";
							//out.println(sql);
							statement=con.createStatement();
							rs = statement.executeQuery(sql);
							if(!rs.next())
							{
								strErr +="未定義K3送貨地址與ERP地址link<br>";
								strEndCustShipTo="";strEndCustID1="";		  
							}
							else
							{
								strEndCustShipTo = rs.getString("erp_ship_to_location_id");
								strEndCustID1 = rs.getString("ERP_CUSTOMER_ID");
							}
						}
					
						//檢查K3客戶代碼
						if (!strK3CustCode.equals(""))
						{
							sql = " SELECT b.customer_name,b.customer_number "+
								  " FROM oraddman.tscc_k3_cust_link_erp a,ar_customers b"+
								  " WHERE a.active_flag='A'"+
								  " and a.cust_code='"+strK3CustCode+"'"+
								  " and a.erp_cust_number=b.customer_number";
							if (!strOrderType.substring(0,1).equals("1") && !strOrderType.substring(0,1).equals("8") && !strEndCustID1.equals(""))
							{
								sql += " and b.customer_id="+strEndCustID1+"";
							}
							sql += " order by decode(a.erp_cust_number,'20971',1,2)";
							//out.println(sql);
							statement=con.createStatement();
							rs = statement.executeQuery(sql);
							if(!rs.next())
							{
								strErr +="未定義K3客戶與ERP客戶link<br>";
								strEndCust ="";strEndCustID ="";		  
							}
							else
							{
								if (!strOrderType.substring(0,1).equals("8")) 
								{
									strEndCust = rs.getString("customer_name");
									strEndCustID = rs.getString("customer_number");
								}
								else
								{
									strCustNo=rs.getString("customer_number");
									strEndCust="";strEndCustID="";
								}
							}
							rs.close();
							statement.close();
						}
						else
						{
							strErr +="客戶代碼不可空白<br>";	
						}
										
						strShippingMethod="";strFOB="";strShipTo="";
						Statement statementa=con.createStatement();
						ResultSet rsa=statementa.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS where status = 'A' and CUSTOMER_NUMBER ='"+strCustNo+"'");
						if(rsa.next())
						{
							strCustID = rsa.getString("CUSTOMER_ID"); 
							strCustName=rsa.getString("CUSTOMER_NAME"); 
	
										
							sql = " select 1 as segno,"+ 
								  " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
								  " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE,"+ 
								  " a.tax_code" + 
								  " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
								  " ,SO_PRICE_LISTS d"+
								  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
								  " AND b.party_site_id = party_site.party_site_id"+
								  " AND loc.location_id = party_site.location_id "+
								  " and a.STATUS='A' "+
								  " and a.site_use_code in ('SHIP_TO','BILL_TO')"+
								  " and b.CUST_ACCOUNT_ID ='"+strCustID+"'"+
							      " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
								  " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
								  " order by decode(a.PRIMARY_FLAG,'Y',1,2), a.SITE_USE_ID";				
							//out.println(sql);							  
							Statement statementb=con.createStatement();
							ResultSet rsb=statementb.executeQuery(sql);
							while (rsb.next())
							{
								if (rsb.getString("SITE_USE_CODE").equals("SHIP_TO"))
								{
									if (strShipTo==null || strShipTo.equals(""))
									{
										strShipTo=rsb.getString("SITE_USE_ID");
									}
									if ((strShippingMethod ==null || strShippingMethod.equals("")) && rsb.getString("ship_via") != null)
									{
										strShippingMethod = rsb.getString("ship_via");
									}
									if ((strFOB==null || strFOB.equals("")) && rsb.getString("FOB_POINT")!= null)
									{	
										strFOB  = rsb.getString("FOB_POINT");
									}
									if (strPriceList.equals(""))
									{
										strPriceList = rsb.getString("PRICE_LIST_ID");
									}
									if (strTax.equals(""))
									{
										strTax=rsb.getString("tax_code");
									}
									if (strPaymentTerm.equals(""))
									{
										strPaymentTerm=rsb.getString("PAYMENT_TERM_ID");
									}
								}
								else if (rsb.getString("SITE_USE_CODE").equals("BILL_TO")) 
								{
									if (strBillTo==null || strBillTo.equals(""))
									{
										strBillTo=rsb.getString("SITE_USE_ID");
									}								
								}
							}
							rsb.close();
							statementb.close();
						}
						else
						{
							strErr += "客戶資訊未定義在ERP<br>";
						}
						rsa.close();
						statementa.close(); 
					
						cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
						cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
						cs1.execute();
						cs1.close();
										
						if (strCustItem != null && !strCustItem.equals(""))
						{						  
							sql = " select  a.item"+
								  " from oe_items_v a,inv.mtl_system_items_b msi "+
								  " where a.SOLD_TO_ORG_ID = '"+strCustID+"' "+
								  " and a.organization_id = msi.organization_id"+
								  " and a.inventory_item_id = msi.inventory_item_id"+
								  " and msi.ORGANIZATION_ID = '49'"+
								  " and a.CROSS_REF_STATUS='ACTIVE'"+
								  " and msi.inventory_item_status_code <> 'Inactive'"+
								  " and a.ITEM = '"+strCustItem.replace("&nbsp;"," ")+"'";
							if (strItemDesc != null && !strItemDesc.equals(""))
							{
								sql += " and a.ITEM_DESCRIPTION = '"+strItemDesc+"'";
							}
							if (strItemName != null && !strItemName.equals(""))
							{
								sql += " and a.INVENTORY_ITEM = '"+strItemName+"'";
							}
							//out.println(sql);
							statement=con.createStatement();
							rs = statement.executeQuery(sql);
							if (!rs.next())
							{
								strErr +="ERP未定義客戶品號:"+strCustItem+"<br>";
							}
							rs.close();
							statement.close();
						}
						
						//customer po
						if (strLineCustPO==null || strLineCustPO.equals(""))
						{
							strErr += "Customer PO不可空白<br>";
						}
						else if (strLineCustPO.indexOf("(")>0)
						{
							if (!strOrderType.substring(0,1).equals("1"))
							{
								strEndCust1 = strLineCustPO.substring(strLineCustPO.indexOf("(")+1,strLineCustPO.lastIndexOf(")"));
								strLineCustPO = strLineCustPO.substring(0,strLineCustPO.indexOf("("));	
							}
							else
							{
								strEndCust1 ="";
							}
						}
					
						//檢查訂單類型是否正確
						Statement stateodrtype=con.createStatement();
						sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
									" where b.order_num=a.order_num and a.order_num='"+strOrderType+"'"+
									" and a.SAREA_NO ='"+SalesAreaNo+"' and a.active='Y'"+
									" and b.MANUFACTORY_NO='"+strFactory+"' and b.ACTIVE='Y'";
						//out.println(sql);
						ResultSet rsodrtype=stateodrtype.executeQuery(sql);  
						if (!rsodrtype.next())
						{
							strErr += "訂單類型錯誤<br>";
						}
						else
						{
							strOrderTypeID=rsodrtype.getString(1);
						}
						rsodrtype.close();
						stateodrtype.close();
			
								
						//出貨方式
						if (strShippingMethod == null || strShippingMethod.equals(""))
						{
						//	strShippingMethod = "&nbsp;";
						//	strErr +="出貨方式不可空白<br>";
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
							//strFOB = "&nbsp;";
							//strErr += "FOB不可空白<br>";
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
			
						//END CUSTOMER
						strEndCust="";strEndCustID1="";
						if (!strEndCustID.equals(""))
						{
							//end customer id不可與customer id相同
							if (strEndCustID.equals(strCustNo))
							{
								if (strOrderType.equals("4121"))
								{
									strEndCustID="";
								}
								else
								{
									strErr += "End Customer ID不可與Customer ID相同<br>";
								}
							}
							else
							{
								if (strOrderType.substring(0,1).equals("4"))
								{
									if (rsi.isBeforeFirst() ==false) rsi.beforeFirst();
									while (rsi.next())
									{
										if (rsi.getString("customer_number").equals(strEndCustID))
										{
											strEndCust = rsi.getString("CUSTOMER_NAME_PHONETIC");
											strEndCustID1 =""+rsi.getInt("customer_id");
											break;
										}
									}
								}
								else
								{
									if (rso.isBeforeFirst() ==false) rso.beforeFirst();
									while (rso.next())
									{
										if (rso.getString("customer_number").equals(strEndCustID))
										{
											strEndCust = rso.getString("CUSTOMER_NAME_PHONETIC");
											strEndCustID1 =""+rso.getInt("customer_id");
											break;
										}
									}						
								}
								
								if (strEndCust.equals(""))
								{
									sql =" SELECT  c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC  "+
										 " FROM ar_customers a,ar.hz_cust_acct_relate_all b,ar_customers c"+
										 " where a.customer_id=b.RELATED_CUST_ACCOUNT_ID"+
										 " and b.STATUS ='A'"+
										 " and a.customer_number="+strCustNo+""+
										 " and b.cust_account_id=c.customer_id"+
										 " and c.customer_number="+strEndCustID+"";
									Statement statementy=con.createStatement();
									ResultSet rsy=statementy.executeQuery(sql);
									if (rsy.next())
									{
										strEndCust = rsy.getString("CUSTOMER_NAME_PHONETIC");
										strEndCustID1 =""+rsy.getInt("customer_id");							
									}
									rsy.close();
									statementy.close();							
									if (strEndCust.equals("")) strErr += "End Customer ID不存在ERP<br>";
								}
							}
						}
					}
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
						double qtynum = Double.parseDouble(strQty.replace(",",""));
						if ( qtynum <= 0)
						{
							strErr += "數量必須大於零<br>";
						}
						else
						{
							if (strUom.equals("PCS")) qtynum=qtynum/1000;
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
					if (!strSampleOrder.equals("Y"))
					{
						strSellingPrice = "&nbsp;";
						strErr +="Selling Price不可空白<br>";
					}
				}
				else
				{
					try
					{
						double pricenum = Double.parseDouble(strSellingPrice.replace(",",""));
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
				
				//交貨日期	
				if (arrayDate1.length !=3)
				{
					strErr +="SSD:"+strSSD+"格式錯誤<br>";
				}
				else
				{
					v_Year = Integer.parseInt(arrayDate1[0]);
					v_Month =Integer.parseInt(arrayDate1[1]);
					v_Days =Integer.parseInt(arrayDate1[2]);
					if ((""+v_Year).length() !=4)
					{
						strErr +="SSD:"+strSSD+"格式錯誤<br>";
					}
					else if (v_Month <1 && v_Month>12)
					{
						strErr +="SSD:"+strSSD+"格式錯誤<br>";
					}
					else if	(v_Days <1  || v_Days >31)
					{
						strErr +="SSD:"+strSSD+"格式錯誤<br>";
					}	
					strSSD = v_Year+("0"+v_Month).substring(("0"+v_Month).length()-2)+("0"+v_Days).substring(("0"+v_Days).length()-2);
				}	
				
				if (strSSD == null || strSSD.equals(""))
				{
					strSSD = "&nbsp;";
					strErr +="SSD不可空白<br>";
				}
				else if (Long.parseLong(strSSD) <= Long.parseLong(strCHKDate))
				{
					strErr +="SSD:"+strSSD+"必須大於"+strCHKDate+"<br>";
				}
				
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
				
				Statement state1=con.createStatement();
				sql = " select DEFAULT_ORDER_LINE_TYPE LINE_TYPE_ID from ORADDMAN.TSAREA_ORDERCLS c  where c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+strOrderType+"'";
				ResultSet rs1=state1.executeQuery(sql);
				if (rs1.next())
				{
					strLineType = rs1.getString("LINE_TYPE_ID");
				} 
				else 
				{ 
					strLineType ="0"; 
					strErr +="Line Type代碼不可空白<br>";	
				} 
				rs1.close();
				state1.close();
								
				if (strErr.length() > 0)
				{
					if (ErrCnt ==0)
					{
	%>
						<table cellspacing="0" bordercolordark="#ffffff" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
							<tr bgcolor="#96AEBC" style="color:#ffffff;font-size:10px;">
								<td width='4%'>Customer No</td>
								<td width='7%'>Customer Name</td>
								<td width='4%'>Ship To ORG ID</td>
								<td width='3%'>RFQ Type</td>
								<td width='3%'>Order Type</td>
								<td width='7%'>Customer PO</td>
								<td width='7%'>TSC P/N</td>
								<td width='7%'>Customer P/N</td>
								<td width='5%'>Qty(KPCS)</td>
								<td width='5%'>Selling<br>Price</td>
								<td width='4%'>SSD</td>
								<td width='5%'>Shipping Method</td>
								<td width='5%'>FOB</td>
								<td width='3%'>End Cust#</td>
								<td width='6%'>End Customer</td>
								<td width='5%'>Remarks</td>
								<td width='7%'>Error<br>Message</td>
							</tr>
	<%
					}
	%>
					<tr bgcolor="#CCFFAC" style="color:#000000;font-size:11px;">
						<td><%=strCustNo%></td>
						<td><%=strCustName%></td>
						<td><%=strShipTo%></td>
						<td><%=strRFQType%></td>
						<td><%=strOrderType%></td>
						<td><%=strLineCustPO%></td>
						<td><%=strItemDesc%></td>
						<td><%=strCustItem%></td>
						<td><%=strQty%></td>
						<td><%=strSellingPrice%></td>
						<td><%=strRequestDate%></td>
						<td><%=strShippingMethod%></td>
						<td><%=strFOB%></td>
						<td><%=strLineRemark%></td>
						<td><%=(strEndCustID==null ||strEndCustID.equals("")?"&nbsp;":strEndCustID)%></td>
						<td><%=(strEndCust==null || strEndCust.equals("")?"&nbsp;":strEndCust)%></td>
						<td style="color:#FF0000"><%=strErr%></td>
					</tr>
	<%					
					strErr="";
					ErrCnt ++;
				}
				
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select apps.tsc_order_revise_group_id_s.nextval from dual");
				if (!rs.next())
				{
					throw new Exception("GROUP ID not Found!!");
				}
				else
				{
					group_id = rs.getString(1);
				}
				rs.close();
				statement.close();					
				
				aa[icnt][0]=strCustNo;
				aa[icnt][1]=strCustName;
				aa[icnt][2]=RFQ_TYPE;
				aa[icnt][3]=strCustPO;
				aa[icnt][4]=strItemDesc;
				aa[icnt][5]=strItemName;
				aa[icnt][6]=strCustItem.replace("&nbsp;"," "); 
				aa[icnt][7]=strFactory;
				aa[icnt][8]=strUOM;
				aa[icnt][9]=strQty;
				aa[icnt][10]=strSellingPrice; 
				aa[icnt][11]=strSSD;
				aa[icnt][12]=strSSD;
				aa[icnt][13]=strShippingMethod ;
				aa[icnt][14]=(strFOB.startsWith("FOB") && strOrderTypeID.equals("1022")?"FOB TAIWAN":strFOB);   
				aa[icnt][15]=strLineRemark.replace("&nbsp;","");
				aa[icnt][16]=strOrderTypeID;
				aa[icnt][17]=strLineType;
				aa[icnt][18]=strItemID;
				aa[icnt][19]=strCustID;
				aa[icnt][20]=strLineCustPO;
				aa[icnt][21]=strEndCustID1;
				aa[icnt][22]=(strEndCust1.equals("")?strEndCust:strEndCust1);				
				aa[icnt][23]=strShipTo;				
				aa[icnt][24]=strTempId;	
				aa[icnt][25]=strBIRegion; 
				aa[icnt][26]=strK3AddrCode;		
				aa[icnt][27]=strK3OrderNo; 	
				aa[icnt][28]=strK3OrderLineNo; 	
				aa[icnt][29]=SalesAreaNo;
				aa[icnt][30]=strEndCustShipTo;
				aa[icnt][31]=strK3CustCode;
				aa[icnt][32]=strPriceList;
				aa[icnt][33]=strTax;
				aa[icnt][34]=strPaymentTerm;
				aa[icnt][35]=strBillTo;
				aa[icnt][36]=""+v_org_id;
				icnt++;
			}
			wb.close();
			rsi.close();
			rso.close();
			statements.close();
				
			if (icnt ==0)
			{ 
				throw new Exception("上傳內容錯誤!");
			}
		}
	
		if (ErrCnt >0)
		{
	%>
		</table>
	<%				
			out.println("<table width='90%' align='center'><tr><td align='center'><font style='color:#ff0000;font-family:標楷體;font-size:16px'>上傳動作失敗，請洽系統管理員，謝謝!</font></td></tr></table>");		
		}
		else
		{
			for (int i =0 ; i < aa.length ; i++)
			{
				//if (aa[i][0] == null || aa[i][0].equals("")) continue;
				sql=" insert into oraddman.tssg_open_orders_import"+
				    " ("+
					  " import_group_id"+    //0
					  ",import_id"+          //1
					  ",k3_order_no"+        //2
					  ",k3_order_line"+      //3
					  ",customer_po"+        //4
					  ",inventory_item_id"+  //5
					  ",item_name"+          //6
					  ",item_desc"+          //7
                      ",cust_partno"+        //8
					  ",crd"+                //9
					  ",ssd"+                //10
					  ",qty"+                //11
					  ",uom"+                //12
					  ",k3_customer_no"+     //13
					  ",k3_address_code"+    //14
					  ",bi_region"+          //15
					  ",erp_customer_id"+    //16
					  ",shipping_method"+    //17
					  ",fob"+                //18
					  ",tax_code"+           //19
					  ",payment_term_id"+    //20
					  ",price_list_id"+      //21
					  ",ship_to_org_id"+     //22
					  ",invoice_to_org_id"+  //23
					  ",upload_date"+        //24
					  ",unit_selling_price"+ //25
					  ",upload_by"+          //26
					  ",line_type_id"+       //27      
					  ",order_type_id"+      //28
					  ",erp_customer_no"+    //29  
					  ",org_id"+             //30   
					  ")"+
					  " values("+
					  "?,"+                           //0
					  "SG_IMPORT_MO_ID_S.NEXTVAL,"+   //1
					  "?,"+                           //2
					  "?,"+                           //3
					  "?,"+                           //4
					  "?,"+                           //5
					  "?,"+                           //6
					  "?,"+                           //7
					  "?,"+                           //8
					  "to_date(?,'yyyymmdd'),"+       //9
					  "to_date(?,'yyyymmdd'),"+       //10
					  "?,"+                           //11
					  "?,"+                           //12
					  "?,"+                           //13
					  "?,"+                           //14
					  "?,"+                           //15
					  "(select customer_id from ar_customers where customer_number=?),"+                           //16
					  "?,"+                           //17
					  "?,"+                           //18
					  "?,"+                           //19
					  "?,"+                           //20
					  "?,"+                           //21
					  "?,"+                           //22
					  "?,"+                           //23
					  "sysdate,"+                     //24
					  "?,"+                           //25
					  "?,"+                           //26
					  "?,"+                           //27
					  "?,"+                           //28
					  "?,"+                           //29
					  "?)";                           //30
				PreparedStatement pstmt=con.prepareStatement(sql); 
				pstmt.setString(1,group_id);             //group_id
				pstmt.setString(2,aa[i][27]);            //K3 Order No
				pstmt.setString(3,aa[i][28]);            //k3 Order Line No
				pstmt.setString(4,aa[i][20]);             //customer_po
				pstmt.setString(5,aa[i][18]);            //inventory_item_id
				pstmt.setString(6,aa[i][5]);             //item_name
				pstmt.setString(7,aa[i][4]);             //item_desc
				pstmt.setString(8,(aa[i][6].equals("&nbsp;")?"":aa[i][6]));             //cust_item_name
				pstmt.setString(9,aa[i][11]);            //crd
				pstmt.setString(10,aa[i][12]);           //request_date
				pstmt.setString(11,aa[i][9]);            //qty
				pstmt.setString(12,aa[i][8]);            //uom
				pstmt.setString(13,aa[i][31]);            //k3 customer
				pstmt.setString(14,aa[i][26]);           //K3 Addr Code
				pstmt.setString(15,aa[i][25]);           //BI REGION
				pstmt.setString(16,aa[i][0]);           //ERP CUSTOMER ID
				pstmt.setString(17,aa[i][13]);           //shipping_method
				pstmt.setString(18,aa[i][14]);           //fob
				pstmt.setString(19,aa[i][33]);           //tax
				pstmt.setString(20,aa[i][34]);           //payment_term
				pstmt.setString(21,aa[i][32]);           //price_list
				pstmt.setString(22,aa[i][23]);           //SHIP TO
				pstmt.setString(23,"");                  //INVOICE TO
				pstmt.setString(24,aa[i][10]);           //selling_price
				pstmt.setString(25,"SUNNY_LU");             //upload_by
				pstmt.setString(26,aa[i][17]);           //line_type
				pstmt.setString(27,aa[i][16]);           //order_type
				pstmt.setString(28,aa[i][0]);            //ERP CUSTOMER NO
				pstmt.setString(29,aa[i][36]);            //org_id
				pstmt.executeQuery();
				pstmt.close();
				insert_cnt++;
			}
			con.commit();
		}
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("error1:"+e.getMessage());
	}
}
%>

<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<input name="ROWCOLOR" type="HIDDEN" value="<%=rowColor%>">	
<input name="HIGHLIGHTOLOR" type="HIDDEN" value="<%=highlightColor%>">	
</form>
</body>
</html>
