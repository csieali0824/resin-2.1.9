<%@ page import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		window.opener.document.getElementById("alpha").style.width="0%";
		window.opener.document.getElementById("alpha").style.height="0px";
		window.close();				
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("Please choose a source file!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('excel must be a .xls file !');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0%";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String K3CreationDate="",K3OrderNo="",K3OrderLineNo="",CustPO="",ItemDesc="",CustItemDesc="",CRD="",SSD="",QTY="",UOM="",UnitPrice="",K3Cust="";
String K3Supplier="",K3Address="",BIREGION="",TEWPO="",K3PO="",K3PODATE="",INTEW="",ItemID="",ItemName="",strErr="";
String Comment="",K3AddressName="",K3ShipTo="",Sales="",Amount="",K3CustName="",Remarks="",SamplerOrder="",Shipmethod="",TEWPOPRICE="",TEWPOSSD="";

int rec_cnt=0;
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td width="20%">&nbsp;</td>
		<td>
			<table width="100%" border="1" cellspacing="0" cellpadding="0">
				<tr>
					<TD height="29" width="25%" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Please choose source file&nbsp;</font></TD>
					<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
				</TR>
				<TR>
					<TD colspan="2" align="center">
					<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../jsp/TSCSGDomesticOpenOrderUpload.jsp?ACTION=UPLOAD")' style="font-family:Tahoma,Georgia">
					&nbsp;&nbsp;&nbsp;&nbsp;
					<INPUT TYPE="button" NAME="winclose" value="Close Window" onClick='setClose();' style="font-family:Tahoma,Georgia">
					</TD>
				</TR>
			</table>
		</td>
		<td width="20%" style="vertical-align:bottom"><A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></A></td>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H18-001("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			String arrylist [][] = new String[sht.getRows()-1][31];
			
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"906");  // 取業務員隸屬ParOrgID
			cs1.execute();
			cs1.close();	
									
			for (int i = 1 ; i <sht.getRows(); i++) 
			{
				K3CreationDate="";K3OrderNo="";K3OrderLineNo="";CustPO="";ItemDesc="";CustItemDesc="";
				CRD="";SSD="";QTY="";UOM="";UnitPrice="";K3Cust="";K3Supplier="";K3Address="";
				BIREGION="";TEWPO="";K3PO="";K3PODATE="";INTEW="";Comment="";K3AddressName="";K3ShipTo="";Sales="";
				Amount="";K3CustName="";Remarks="";SamplerOrder="";Shipmethod="";ItemName="";ItemID="";
				rec_cnt=0;
				
				//k3建立日期
				jxl.Cell wcK3CreationDate = sht.getCell(0, i);          
				K3CreationDate = (wcK3CreationDate.getContents()).trim();
							
				//k3單據編號
				jxl.Cell wcK3OrderNo = sht.getCell(1, i);          
				K3OrderNo = (wcK3OrderNo.getContents()).trim();
				
				//k3行號
				jxl.Cell wcK3OrderLineNo = sht.getCell(2, i);          
				K3OrderLineNo = (wcK3OrderLineNo.getContents()).trim();
				
				//CUST PO
				jxl.Cell wcCustPO = sht.getCell(3, i);          
				CustPO = (wcCustPO.getContents()).trim();

				//TSC Item desc
				jxl.Cell wcItemDesc = sht.getCell(5, i);          
				ItemDesc = (wcItemDesc.getContents()).trim();

				//Cust Item desc
				jxl.Cell wcCustItemDesc = sht.getCell(6, i);          
				CustItemDesc = (wcCustItemDesc.getContents()).trim();

				//CRD
				jxl.Cell wcCRD = sht.getCell(7, i);          
				CRD = (wcCRD.getContents()).trim();

				//SSD
				jxl.Cell wcSSD = sht.getCell(8, i);          
				SSD = (wcSSD.getContents()).trim();

				//QTY
				jxl.Cell wcQTY = sht.getCell(9, i);          
				QTY = (wcQTY.getContents()).trim();

				//UOM
				jxl.Cell wcUOM = sht.getCell(10, i);          
				UOM = (wcUOM.getContents()).trim();
				
				//UNIT PRICE
				jxl.Cell wcUnitPrice = sht.getCell(11, i);          
				UnitPrice = (wcUnitPrice.getContents()).trim();

				//AMOUNT
				jxl.Cell wcAmout = sht.getCell(12, i);          
				Amount = (wcAmout.getContents()).trim();
				
				//K3客戶代碼
				jxl.Cell wcK3Cust = sht.getCell(13, i);          
				K3Cust = (wcK3Cust.getContents()).trim();

				//K3客戶名稱
				jxl.Cell wcK3CustName = sht.getCell(14, i);          
				K3CustName = (wcK3CustName.getContents()).trim();

				//備註
				jxl.Cell wcRemarks = sht.getCell(15, i);          
				Remarks = (wcRemarks.getContents()).trim();

				//K3供應商代碼
				jxl.Cell wcK3Supplier = sht.getCell(16, i);          
				K3Supplier = (wcK3Supplier.getContents()).trim();

				//樣品單
				jxl.Cell wcSampleOrder = sht.getCell(17, i);          
				SamplerOrder = (wcSampleOrder.getContents()).trim();

				//出貨方式
				jxl.Cell wcShipmethod = sht.getCell(18, i);          
				Shipmethod = (wcShipmethod.getContents()).trim();

				//摘要
				jxl.Cell wcComment = sht.getCell(19, i);          
				Comment = (wcComment.getContents()).trim();

				//K3送貨地址代碼
				jxl.Cell wcK3Address = sht.getCell(20, i);          
				K3Address = (wcK3Address.getContents()).trim();

				//K3送貨地址
				jxl.Cell wcK3AddressName = sht.getCell(21, i);          
				K3AddressName = (wcK3AddressName.getContents()).trim();

				//K3送貨地址ship to
				jxl.Cell wcK3ShipTo = sht.getCell(22, i);          
				K3ShipTo = (wcK3ShipTo.getContents()).trim();

				//BI REGION
				jxl.Cell wcBIREGION = sht.getCell(23, i);          
				BIREGION = (wcBIREGION.getContents()).trim();

				//Sales
				jxl.Cell wcSales = sht.getCell(24, i);          
				Sales = (wcSales.getContents()).trim();

				//TEWPO
				jxl.Cell wcTEWPO = sht.getCell(25, i);          
				TEWPO = (wcTEWPO.getContents()).trim();

				//K3PO
				jxl.Cell wcK3PO = sht.getCell(26, i);          
				K3PO = (wcK3PO.getContents()).trim();

				//K3PODATE
				jxl.Cell wcK3PODATE = sht.getCell(27, i);          
				K3PODATE = (wcK3PODATE.getContents()).trim();

				////INTEW
				//jxl.Cell wcINTEW = sht.getCell(28, i);          
				//INTEW = (wcINTEW.getContents()).trim();
				
				//TEW PO PRICE
				jxl.Cell wcTEWPOPRICE = sht.getCell(28, i);          
				TEWPOPRICE = (wcTEWPOPRICE.getContents()).trim();
				
				//TEW PO SSD
				jxl.Cell wcTEWPOSSD = sht.getCell(29, i);          
				TEWPOSSD = (wcTEWPOSSD.getContents()).trim();
				
				
				if (CustItemDesc != null && !CustItemDesc.equals(""))
				{						  
					sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
						  " a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
						  " ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
						  " from oe_items_v a,inv.mtl_system_items_b msi "+
						  " ,APPS.MTL_ITEM_CATEGORIES_V c "+
						  " where exists (select 1  FROM oraddman.tscc_k3_cust_link_erp x,ar_customers y"+
						  " where x.active_flag='A'"+
						  " and x.cust_code='"+K3Cust+"'"+
						  " and x.erp_cust_number=y.customer_number"+
						  " and y.customer_id=a.sold_to_org_id)"+
						  " and a.organization_id = msi.organization_id"+
						  " and a.inventory_item_id = msi.inventory_item_id"+
						  " and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
						  " and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
  					      " and msi.ORGANIZATION_ID = 907"+
						  " and c.CATEGORY_SET_ID = 6"+
						  " and a.CROSS_REF_STATUS='ACTIVE'"+
						  " and msi.inventory_item_status_code <> 'Inactive'"+
						  " and a.ITEM = '"+CustItemDesc+"'";
					if (ItemDesc!= null && !ItemDesc.equals(""))
					{
						sql += " and a.ITEM_DESCRIPTION = '"+ItemDesc+"'";
					}
					//out.println(sql);
					Statement statement=con.createStatement();
					ResultSet rs = statement.executeQuery(sql);
					while(rs.next())
					{
						ItemName = rs.getString("INVENTORY_ITEM");
						ItemID = rs.getString("INVENTORY_ITEM_ID");	
						rec_cnt++;
					}
					rs.close();
					statement.close();
					if (rec_cnt==0)
					{
						strErr +="Cust Part No:"+ CustItemDesc+" not found in ERP<br>";
					}						
				}
				else
				{
					sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3"+
						  " FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c"+
						  " WHERE msi.inventory_item_id = c.inventory_item_id"+
						  " AND msi.organization_id = c.organization_id"+
						  " AND msi.organization_id = 43"+
						  " AND c.category_set_id = 6"+
						  " AND msi.inventory_item_status_code <> 'Inactive'"+
						  " AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+           
						  " AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+	 						  
						  " AND msi.description =  '"+ItemDesc+"'";	
					Statement statement=con.createStatement();
					//out.println(sql);
					ResultSet rs = statement.executeQuery(sql);
					while(rs.next())
					{
						ItemName = rs.getString("segment1");
						ItemID = rs.getString("INVENTORY_ITEM_ID");	
						rec_cnt++;
					}
					rs.close();
					statement.close();
					if (rec_cnt==0)
					{
						strErr +="TSC Part No:"+ItemDesc+" not found in ERP<br>";
					}
				}
				
				arrylist[i-1][0]=K3CreationDate;
				arrylist[i-1][1]=K3OrderNo;
				arrylist[i-1][2]=K3OrderLineNo;
				arrylist[i-1][3]=CustPO;
				arrylist[i-1][4]=ItemID;
				arrylist[i-1][5]=ItemName;
				arrylist[i-1][6]=ItemDesc;
				arrylist[i-1][7]=CustItemDesc;
				arrylist[i-1][8]=CRD;
				arrylist[i-1][9]=SSD;
				arrylist[i-1][10]=QTY;
				arrylist[i-1][11]=UOM;
				arrylist[i-1][12]=UnitPrice;
				arrylist[i-1][13]=Amount;
				arrylist[i-1][14]=K3Cust;
				arrylist[i-1][15]=K3CustName;
				arrylist[i-1][16]=Remarks;
				arrylist[i-1][17]=K3Supplier;
				arrylist[i-1][18]=SamplerOrder;
				arrylist[i-1][19]=Shipmethod;
				arrylist[i-1][20]=Comment;
				arrylist[i-1][21]=K3Address;
				arrylist[i-1][22]=K3AddressName;
				arrylist[i-1][23]=K3ShipTo;
				arrylist[i-1][24]=BIREGION;
				arrylist[i-1][25]=Sales;
				arrylist[i-1][26]=TEWPO;
				arrylist[i-1][27]=K3PO;
				arrylist[i-1][28]=K3PODATE;
				//arrylist[i-1][29]=INTEW.replace("是","Y");
				arrylist[i-1][29]=TEWPOPRICE;
				arrylist[i-1][30]=TEWPOSSD;
			}
			wb.close();
			
			//truncate table TSSG_DOMESTIC_OPEN_ORDER
			sql = " truncate table oraddman.TSSG_DOMESTIC_OPEN_ORDER";
			PreparedStatement pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.executeUpdate();
			pstmtDt1.close();	
			
			for (int j =0 ; j < arrylist.length ; j++)
			{
				sql = " insert into oraddman.TSSG_DOMESTIC_OPEN_ORDER"+
					   " values(?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",null"+
					   ",null"+
					   ",null"+
					   ",null"+
					   ",null"+
					   ",sysdate"+
					   ",null"+
					   ",?"+
					   ",?)";
				pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,arrylist[j][0]);
				pstmtDt1.setString(2,arrylist[j][1]);
				pstmtDt1.setString(3,arrylist[j][2]);
				pstmtDt1.setString(4,arrylist[j][3]);
				pstmtDt1.setString(5,arrylist[j][4]);
				pstmtDt1.setString(6,arrylist[j][5]);
				pstmtDt1.setString(7,arrylist[j][6]);
				pstmtDt1.setString(8,arrylist[j][7]);
				pstmtDt1.setString(9,arrylist[j][8]);
				pstmtDt1.setString(10,arrylist[j][9]);
				pstmtDt1.setString(11,arrylist[j][10]);
				pstmtDt1.setString(12,arrylist[j][11]);
				pstmtDt1.setString(13,arrylist[j][12]);
				pstmtDt1.setString(14,arrylist[j][13]);
				pstmtDt1.setString(15,arrylist[j][14]);
				pstmtDt1.setString(16,arrylist[j][15]);
				pstmtDt1.setString(17,arrylist[j][16]);
				pstmtDt1.setString(18,arrylist[j][17]);
				pstmtDt1.setString(19,arrylist[j][18]);
				pstmtDt1.setString(20,arrylist[j][19]);
				pstmtDt1.setString(21,arrylist[j][20]);
				pstmtDt1.setString(22,arrylist[j][21]);
				pstmtDt1.setString(23,arrylist[j][22]);
				pstmtDt1.setString(24,arrylist[j][23]);
				pstmtDt1.setString(25,arrylist[j][24]);
				pstmtDt1.setString(26,arrylist[j][25]);
				pstmtDt1.setString(27,arrylist[j][26]);
				pstmtDt1.setString(28,arrylist[j][27]);
				pstmtDt1.setString(29,arrylist[j][28]);
				pstmtDt1.setString(30,arrylist[j][30]);
				pstmtDt1.setString(31,arrylist[j][29]);
				pstmtDt1.executeQuery();
				pstmtDt1.close();	
			}
			con.commit();
				
			if (!strErr.equals(""))
			{
				out.println(strErr);
			}	
			else
			{
				//CallableStatement cs2 = con.prepareCall("{call TSSG_ORDER_PKG.DOMESTIC_IMPORT_JOB(?)}");
				//cs2.setString(1,UserName); 	
				//cs2.execute();
				//cs2.close();			
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>The action fail,error cause is..<br>"+e.getMessage()+"</div>");
		}
	}
%>
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
