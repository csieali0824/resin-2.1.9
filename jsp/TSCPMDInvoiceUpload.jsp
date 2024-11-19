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
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<html>
<head>
<title>PMD Invoice Detail Upload</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
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
String strWIPNO="",strPONO="",strVendor="",strInvoice="",strRate="",strInvoiceAmt="",strPO="",strPartNumber="",strOtherCharge="",strQty="",strUnitPrice="",strAmount="";
String strAmt="",strErr="",strItemID="",strItemName="",strVendorSite="",strVendorCode="",strCurr="",strTax="0.05",strCurrency="";
int err_cnt=0,icnt=0;
String aa [][] = new String[1][1];
float totAmount = 0;
String strDateTime="";

try
{
%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<table cellSpacing='0' bordercolordark="#CCCCCC"  cellPadding='0' width='60%' align='center'>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td height="40" align="center"  valign="bottom"><DIV style="font-weight:bold;color:#4A2231;font-family:標楷體;font-size:28px">PMD發票明細上傳</DIV></td>
		<td width="12%" valign="bottom"><A href="../jsp/TSCPMDInvoiceSummaryReport.jsp" style="font-family:標楷體;font-size:16px;background-color:#E4E4E4">發票查詢</A></td>
		<td width="8%" valign="bottom"><A href="/oradds/ORADDSMainMenu.jsp" style="font-family:標楷體;font-size:16px;background-color:#E4E4E4"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr><td height="5" colspan="3" bgcolor="#73C4B4">&nbsp;</td>
	</tr>
</table>
<table cellSpacing='0' bordercolordark="#CCCCCC"  cellPadding='0' width='60%' align='center' borderColorLight='#ffffff' border='1'>
    <tr>
		<td style="color:#353535;font-size:14px;font-family:Verdana;background-color:#73C4B4">Upload File：</td>
		<td width="85%" ><INPUT TYPE="FILE" style="font-family:ARIAL;font-size:14px" NAME="UPLOADFILE" size="90"></td>
	</tr>
	<tr>
		<td style="color:#353535;font-size:14px;font-family:Verdana;background-color:#73C4B4">Sample File：</td>
		<td width="85%" ><A HREF="../jsp/samplefiles/F1-005_SampleFile.xls"><font style="font-size:14px;font-family:arial">Download Sample File</font></A></td>
	</tr>
	<tr>
		<td colspan="2" title="請按我，謝謝!">
		<input type="button" style="font-size:14px;font-family:arial" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCPMDInvoiceUpload.jsp?ACTIONCODE=INSERT')">
		</td>
	</tr>
</table>
<%
	if (ACTIONCODE.equals("INSERT"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		String strDate=dateBean.getYearMonthDay();
		strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond(); 
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
		
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\F1005_"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			java.util.Date datetime = new java.util.Date();
			SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
			String CreationDate = (String) formatter.format( datetime );
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);

			//VENDOR
			jxl.Cell cellVendor = sht.getCell(0,1); 
			strVendor = cellVendor.getContents();
				
			//INVOICE
			jxl.Cell cellInvoice = sht.getCell(1,1); 
			strInvoice = cellInvoice.getContents();
			
			//CURRENCY
			jxl.Cell cellCurrency = sht.getCell(2,1); 
			strCurrency = cellCurrency.getContents().trim();
			
			//RATE
			jxl.Cell cellRate = sht.getCell(3,1); 
			strRate = cellRate.getContents();
			if (strRate==null || strRate.equals("")) strRate ="1";
			
			//INVOICEAMT 
			jxl.Cell cellInvoiceAmt = sht.getCell(4,1); 
			strInvoiceAmt = cellInvoiceAmt.getContents();
			strInvoiceAmt = ""+(Math.round(Float.parseFloat(strInvoiceAmt))*100/100);
			
			if (strVendor==null || strVendor.equals(""))
			{
				throw new Exception("供應商名稱不可空白!!!");
			}
			
			if (strInvoice== null || strInvoice.equals(""))
			{
				throw new Exception("發票號碼不可空白!!!");
			}
			
			//檢查發票號
			String sql = " SELECT  1 FROM oraddman.tspmd_invoice_headers_all a"+
				 " where a.invoice_no ='" + strInvoice + "'";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			if (rs.next())
			{
				throw new Exception("發票號碼已存在,不可重複匯入!!!");
			}

			aa = new String[sht.getRows()-3][16];
			//line detail
			for (int i = 3; i < sht.getRows(); i++) 
			{
				boolean poExist = false,partsExist=false,priceOK=false,qtyOK=false,rateOK=false;
				strErr ="";strItemID="";strItemName="";strVendorSite="";strVendorCode="";strCurr="";strPONO="";strWIPNO="";strItemID="";strItemName="";
				
				//PO
				jxl.Cell cellPO = sht.getCell(0,i);
				strPO = cellPO.getContents();
				
				//Part Number
				jxl.Cell cellPartNumber = sht.getCell(1,i);
				strPartNumber = (cellPartNumber.getContents()).trim();
				if (strPartNumber==null) strPartNumber ="";
				
				//Other Charge
				jxl.Cell cellOtherCharge = sht.getCell(2, i);          
				strOtherCharge = cellOtherCharge.getContents();
				if (strOtherCharge==null) strOtherCharge="";

				//QTY
				jxl.Cell cellQty = sht.getCell(3, i);  
				if (cellQty.getType() == CellType.NUMBER) 
				{
					strQty = ""+((NumberCell) cellQty).getValue();
				} 
				else strQty = (cellQty.getContents()).trim();
				if (strQty == null) strQty="0";
				strQty = strQty.replace(",","");
				
				//單價
				jxl.Cell cellUnitPrice = sht.getCell(4, i);  
				if (cellUnitPrice.getType() == CellType.NUMBER) 
				{
					strUnitPrice = ""+((NumberCell) cellUnitPrice).getValue();
				} 
				else strUnitPrice = (cellUnitPrice.getContents()).trim();
				if (strUnitPrice == null) strUnitPrice="0";
				strUnitPrice = strUnitPrice.replace(",","");
			
				//AMOUNT
				jxl.Cell cellAmount = sht.getCell(5, i);   
				if (cellAmount.getType() == CellType.NUMBER) 
				{
					strAmount = ""+((NumberCell) cellAmount).getValue();
				} 
				else strAmount = (cellAmount.getContents()).trim();
				if (strAmount == null || strAmount.equals("")) strAmount="0";
				strAmount = strAmount.replace(",","");

				strAmount = ""+(Math.round(10000*Float.parseFloat(strAmount)/100));
				strAmount = ""+(Float.parseFloat(strAmount)/100);

				if (strPO==null || strPO.equals(""))
				{
					if (strUnitPrice.toUpperCase().equals("TOTAL"))
					{
						totAmount = Float.parseFloat(strAmount);  //金額合計
					}
					continue;
				}
				strAmt = "" + (Math.round(10000* (Float.parseFloat(strUnitPrice) * Float.parseFloat(strQty))/100));
				strAmt = "" + (Float.parseFloat(strAmt)/100);
				
				//數量	
				if (strQty == null || strQty.equals(""))
				{
					strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 數量不可空白<br>";
					strQty ="0";
				}
				else
				{
					try
					{
						float qtynum = Float.parseFloat(strQty.replace(",",""));
						if ( qtynum <= 0)
						{
							strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 數量必須大於零<br>";
						}
					}
					catch (Exception e)
					{
						strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 數量格式錯誤<br>";
						strQty ="0";
					}
				}
				
				//單價
				if (strUnitPrice== null || strUnitPrice.equals(""))
				{
					strErr +="採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 單價不可空白<br>";
					strUnitPrice ="0";
				}
				else
				{
					try
					{
						float pricenum = Float.parseFloat(strUnitPrice.replace(",",""));
						if ( pricenum <= 0)
						{
							strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 單價必須大於零<br>";
						}
					}
					catch (Exception e)
					{
						strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 單價格式錯誤<br>";
						strUnitPrice ="0";
					}
				}
				
				//金額
				if (strAmount== null || strAmount.equals(""))
				{
					strErr +="採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 金額不可空白<br>";
					strAmount ="0";
				}
				else
				{
					try
					{
						float pricenum = Float.parseFloat(strAmount.replace(",",""));
						if ( pricenum <= 0)
						{
							strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 金額必須大於零<br>";
						}
						if (Float.parseFloat(strAmt) != Float.parseFloat(strAmount))
						{
							strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 金額("+strAmount+")單價*數量("+strAmt+")<br>";
						}
					}
					catch (Exception e)
					{
						strErr += "採購單號(或工單號碼):"+strPO+ " 品名:"+strPartNumber+" 金額格式錯誤<br>";
						strAmount ="0";
					}
				}
				
				//檢查PO及ITEM是否存在ERP
				sql = " SELECT distinct a.vendor_site_id,a.segment1 po_no,NVL(m.wip_entity_name,'') WIP_ENTITY_NAME,"+
				      " g.segment1 vendor_code, g.vendor_name,"+
					  " NVL(e.segment1,k.segment1) segment1,"+
					  " NVL(e.inventory_item_id,k.inventory_item_id) inventory_item_id,"+
					  " NVL(e.description,k.description) description, a.currency_code, f.unit_price,"+
					  " f.quantity, NVL ((SELECT SUM (qty) FROM oraddman.tspmd_invoice_lines_all h WHERE h.po_no = a.segment1 AND h.item_description = e.description),0)+"+strQty+" REQ_QTY"+
					  " FROM po.po_headers_all a,po.po_line_locations_all b,"+
					  " po.po_requisition_lines_all c, wip.wip_discrete_jobs d,"+
					  " inv.mtl_system_items_b e, po.po_lines_all f, ap.ap_suppliers g,"+
					  " inv.mtl_system_items_b k,wip.wip_entities m"+
					  " WHERE (a.segment1 ='"+strPO+"' or m.WIP_ENTITY_NAME='"+strPO+"')"+
					  " AND f.po_line_id = b.po_line_id"+
					  " AND f.item_id = k.inventory_item_id"+
					  " AND b.SHIP_TO_ORGANIZATION_ID = k.organization_id"+
					  " AND b.line_location_id = c.line_location_id(+)"+
					  " AND c.wip_entity_id = d.wip_entity_id(+)"+
					  " AND d.primary_item_id = e.inventory_item_id(+)"+
					  " AND d.organization_id = e.organization_id(+)"+
					  " AND d.wip_entity_id = m.wip_entity_id(+)"+
					  " AND d.organization_id = m.organization_id(+)"+
					  " AND a.po_header_id = f.po_header_id"+
					  " AND a.vendor_id = g.vendor_id"+
					  " AND g.vendor_name = '"+ strVendor+"'";
				//out.println(sql);
				rs=statement.executeQuery(sql);
				while (rs.next())
				{
					strPONO = rs.getString("PO_NO");
					strWIPNO = rs.getString("WIP_ENTITY_NAME");
					poExist = true;
					if (strPartNumber.equals(""))
					{
						partsExist=true;priceOK=true;qtyOK=true;rateOK=true;
					}
					else if (rs.getString("description").equals(strPartNumber))
					{
						partsExist=true;
						strItemID = rs.getString("INVENTORY_ITEM_ID");
						strItemName = rs.getString("SEGMENT1");
						if (Float.parseFloat(rs.getString("unit_price")) == Float.parseFloat(strUnitPrice)) priceOK=true;
						if (Float.parseFloat(rs.getString("QUANTITY")) >= Float.parseFloat(rs.getString("REQ_QTY"))) qtyOK=true;
					}
					strCurr = rs.getString("CURRENCY_CODE");
					strVendorSite= rs.getString("vendor_site_id");
					strVendorCode= rs.getString("vendor_code");
					if ((strCurr.equals(strCurrency) && strRate.equals("1")) || (!strCurr.equals(strCurrency) && Float.parseFloat(strRate)>0)) rateOK=true;
				}
				if (!poExist) strErr += "供應商:"+strVendor+" 查無採購單號:"+strPONO+"<br>";
				if (!partsExist) strErr += "採購單號:"+strPONO+ " 查無品名:"+strPartNumber+"<br>";
				if (!priceOK) strErr += "採購單號:"+strPONO+ " 品名:"+strPartNumber+" 單價不正確<br>";
				if (!qtyOK) strErr += "採購單號:"+strPONO+ " 品名:"+strPartNumber+" 發票總數量已超過原始採購量<br>";
				if (!rateOK) strErr += "採購單號:"+strPONO+ " 品名:"+strPartNumber+" 匯率錯誤<br>";
				
				if (strErr.length()>0)
				{
					if (err_cnt ==0)
					{
						out.println("<table cellSpacing='0' bordercolordark='#CCCCCC'  cellPadding='0' width='60%' align='center' borderColorLight='#ffffff'>");
    					out.println("<tr><td style='font-family:細明體;font-size:14px;color:#ff0000'><br>");
					}
					out.println(strErr);
					err_cnt ++;
				}
				else
				{
					aa[icnt][0]=strInvoice;
					aa[icnt][1]=strVendorCode;
					aa[icnt][2]=strVendorSite;
					aa[icnt][3]=strVendor;
					aa[icnt][4]=strCurrency;
					aa[icnt][5]=strRate;
					aa[icnt][6]=strInvoiceAmt; 
					aa[icnt][7]=strPONO;
					aa[icnt][8]=strItemID;
					aa[icnt][9]=strItemName;
					aa[icnt][10]=strPartNumber;
					aa[icnt][11]=strOtherCharge;
					aa[icnt][12]=strQty; 
					aa[icnt][13]=strUnitPrice;
					aa[icnt][14]=strAmount;
					aa[icnt][15]=strWIPNO;
					icnt++;
				}
			}
			rs.close();
			statement.close();

			float totAmt = Math.round(totAmount * Float.parseFloat(strRate) * (1+ Float.parseFloat(strTax)));
			if (totAmt != Float.parseFloat(strInvoiceAmt))
			{
				throw new Exception("發票金額有誤("+totAmt+"<>"+ Float.parseFloat(strInvoiceAmt)+"),請確認清楚後再上傳!!!");
			}
			
			if (err_cnt >0)
			{
				throw new Exception("資料有誤,請確認清楚後再上傳!!!");
			}
			else
			{
				for (int i =0 ; i < aa.length ; i++)
				{
					if (aa[i][0] == null || aa[i][0].equals("")) continue;
					if (i ==0)
					{
						sql = "insert into oraddman.tspmd_invoice_headers_all("+
							  " invoice_no"+
							  ",vendor_code"+
							  ",vendor_site_id"+
							  ",vendor_name"+
							  ",currency_code"+
							  ",tot_amount"+
							  ",rate"+
							  ",tax"+
							  ",invoice_amount"+
							  ",created_by"+
							  ",creation_date)"+
							  " values("+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",sysdate)";
						PreparedStatement pstmt=con.prepareStatement(sql); 
						pstmt.setString(1,aa[i][0]);           //INVOICENO
						pstmt.setString(2,aa[i][1]);           //vendor_code
						pstmt.setString(3,aa[i][2]);           //vendor_site_id
						pstmt.setString(4,aa[i][3]);           //vendor_name
						pstmt.setString(5,aa[i][4]);           //currency_code
						pstmt.setString(6,""+totAmount);          //tot_amount
						pstmt.setString(7,aa[i][5]);           //rate
						pstmt.setString(8,strTax);             //tax
						pstmt.setString(9,aa[i][6]);           //invoice_amount
						pstmt.setString(10,UserName);          //created_by
						pstmt.executeQuery();
						pstmt.close();
					}
					
					sql = " insert into oraddman.tspmd_invoice_lines_all("+
						   " invoice_no"+
						   ",line_no"+
						   ",po_no"+
						   ",other_charge"+
						   ",inventory_item_id"+
						   ",item_name"+
						   ",item_description"+
						   ",qty"+
						   ",unit_price"+
						   ",amount"+
						   ",WIP_NO)"+
						   " values("+
						   " ?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?"+
						   ",?)";
					PreparedStatement pstmt1=con.prepareStatement(sql); 
					pstmt1.setString(1,aa[i][0]);          //invoice_no
					pstmt1.setInt(2,(i+1));             //line_no
					pstmt1.setString(3,aa[i][7]);          //po_no
					pstmt1.setString(4,aa[i][11]);         //other_charge
					pstmt1.setString(5,aa[i][8]);          //inventory_item_id
					pstmt1.setString(6,aa[i][9]);          //item_name
					pstmt1.setString(7,aa[i][10]);         //item_description
					pstmt1.setString(8,aa[i][12]);         //qty
					pstmt1.setString(9,aa[i][13]);         //unit_price
					pstmt1.setString(10,aa[i][14]);        //amount
					pstmt1.setString(11,aa[i][15]);        //wip_no
					pstmt1.executeQuery();
					pstmt1.close();
				}
				
				con.commit();
				
				response.sendRedirect("TSCPMDInvoiceDetail.jsp?INVOICENO="+strInvoice+"&TRANSTYPE=UPLOAD&FILENAME="+strDateTime);
			}
		}
	}
}
catch(Exception e)
{
	con.rollback();
	if (err_cnt ==0)
	{
		out.println("<table cellSpacing='0' bordercolordark='#CCCCCC'  cellPadding='0' width='60%' align='center' borderColorLight='#ffffff'>");
		out.println("<tr><td style='font-family:細明體;font-size:14px;color:#ff0000'><br>");
	}
	out.println("Exception:"+e.getMessage());
	out.println("</td></tr></table>");
}
%>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
</body>
</html>

