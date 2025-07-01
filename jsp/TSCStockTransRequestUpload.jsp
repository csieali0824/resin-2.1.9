<%@ page contentType="text/html; charset=big5" import="java.sql.*"%>
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
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="StockBean" scope="session" class="Array2DimensionInputBean"/>
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
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
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
<title>Excel Upload</title>
</head>
<%
String rdoitem=request.getParameter("rdoitem");
if (rdoitem==null) rdoitem="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE ==null) ACTIONCODE="";
String sql ="",rdoitemdesc="";
String strProdGroup="",strItemName="",strItemDesc="",strLot="",strDateCode="",strOrigOrg="",strOrigSubinv="",strKey="";
String strNewOrg="",strNewSubinv="",strQty="",strUom="",strReason="",strUnitPrice="",strAmt="",strNewItemName="",strNewItemDesc="",strNewLot="",strNewDateCode="",strNewQty="",strNewUom="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int colCnt = 0,start_row=1;
Hashtable hashtb = new Hashtable();
boolean ifound=false;
double iUseQty=0,ionhand=0,iQty=0,iStrQty=0,iiStrQty=0;

sql = " select a.trans_desc from oraddman.tsc_stock_trans_type a"+
      " where a.trans_name=?";
PreparedStatement statement = con.prepareStatement(sql);
statement.setString(1,rdoitem);
ResultSet rs=statement.executeQuery();	
if (rs.next())
{
	rdoitemdesc=rs.getString("trans_desc");
}
rs.close();
statement.close();

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">申請項目&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong><%=rdoitemdesc%></strong></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD>
		<% 
		if (rdoitem.equals("SUBTRANS"))
		{
		%>
		<A HREF="../jsp/samplefiles/StockSubinvTransSampleFile.xls">
		<%
		}
		else if (rdoitem.equals("MISC"))
		{
		%>
		<A HREF="../jsp/samplefiles/StockMiscTransSampleFile.xls">
		<%
		}
		%>
		<font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSCStockTransRequestUpload.jsp?ACTIONCODE=UPLOAD&rdoitem=<%=rdoitem%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTIONCODE.equals("UPLOAD"))
	{
		StockBean.setArray2DString(null);
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+"Stock"+rdoitem+strDateTime+"("+UserName+").xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			//Hashtable hashtb = new Hashtable();
			//Hashtable hashtb1 = new Hashtable();
			
			sql = " SELECT distinct b.organization_code,a.secondary_inventory_name "+
			      " FROM inv.mtl_secondary_inventories a"+
				  " ,inv.mtl_parameters b"+
				  " ,oraddman.tsc_stock_trans_subinv c"+
				  " ,oraddman.tsc_stock_trans_type d"+
			      " WHERE a.organization_id=b.organization_id"+
				  //" and b.organization_code in ('I1','I20','I13','I91')"+
				  " and b.organization_code =c.organization_code"+
				  " and c.trans_type=d.trans_type"+
				  " and nvl(c.active_flag,'N')='A'"+
				  " and d.trans_name='"+rdoitem+"'"+
				  " and nvl(a.disable_date,to_date('20990101','yyyymmdd'))>trunc(sysdate)";
			Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			ResultSet rsh = statementh.executeQuery(sql);
						
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				//轉倉通知單
				if (rdoitem.equals("SUBTRANS"))
				{
					//產品別
					jxl.Cell wcItem = sht.getCell(0, i);          
					strProdGroup = (wcItem.getContents()).trim();
					if (strProdGroup  == null) strProdGroup = "";

					//料號
					wcItem = sht.getCell(1, i);          
					strItemName = (wcItem.getContents()).trim();
					if (strItemName  == null) strItemName = "";
					
					//品名
					wcItem = sht.getCell(2, i);          
					strItemDesc = (wcItem.getContents()).trim();
					if (strItemDesc  == null) strItemDesc = "";		
					//if (strItemDesc.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:品名不可空白!!");
					//}	
					if (strItemName.equals("") && strItemDesc.equals(""))
					{
						throw new Exception("第"+(i)+"筆:料號或品名請擇一輸入!!");
					}						
						
					//lot
					wcItem = sht.getCell(3, i);          
					strLot = (wcItem.getContents()).trim();
					if (strLot  == null) strLot = "";		
					if (strLot.equals(""))
					{
						throw new Exception("第"+(i)+"筆:Lot不可空白!!");
					}								

					//d/c
					wcItem = sht.getCell(4, i);          
					strDateCode = (wcItem.getContents()).trim();
					if (strDateCode  == null) strDateCode = "";		
					//if (strDateCode.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:Date Code不可空白!!");
					//}	
	
					//移出org
					wcItem = sht.getCell(5, i);          
					strOrigOrg = (wcItem.getContents()).trim();
					if (strOrigOrg  == null) strOrigOrg = "";
					if (strOrigOrg.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移出Org不可空白!!");
					}	
					else if (!strOrigOrg.equals("I1") && !strOrigOrg.equals("I20") && !strOrigOrg.equals("I91") && !strOrigOrg.equals("I13"))
					{
						throw new Exception("第"+(i)+"筆:移出Org:"+strOrigOrg+"錯誤(目前只開放I1,I20,I13,I91)!!");
					}					
					
					//移出倉別 
					wcItem = sht.getCell(6, i);          
					strOrigSubinv = (wcItem.getContents()).trim();
					if (strOrigSubinv  == null) strOrigSubinv = "";
					if (strOrigSubinv.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移出倉別不可空白!!");
					}	
					else
					{
						ifound=false;
						if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
						while (rsh.next())
						{
							if (rsh.getString("organization_code").equals(strOrigOrg) && rsh.getString("secondary_inventory_name").equals(strOrigSubinv))
							{
								ifound=true;
								break;
							}
						}
						if (ifound==false)
						{
							throw new Exception("第"+(i)+"筆:移出倉別不存在!!");
						}
					}
					
					//移入org
					wcItem = sht.getCell(7, i);          
					strNewOrg = (wcItem.getContents()).trim();
					if (strNewOrg  == null) strNewOrg = "";
					if (strNewOrg.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移入Org不可空白!!");
					}
					else if (!strNewOrg.equals("I1") && !strNewOrg.equals("I20") && !strNewOrg.equals("I91") && !strNewOrg.equals("I13"))
					{
						throw new Exception("第"+(i)+"筆:移入Org"+strNewOrg+"錯誤(目前只開放I1,I20,I13,I91)!!");
					}
					
					//移入倉別 
					wcItem = sht.getCell(8, i);          
					strNewSubinv = (wcItem.getContents()).trim();
					if (strNewSubinv  == null) strNewSubinv = "";
					if (strNewSubinv.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移入倉別不可空白!!");
					}	
					else if (strNewOrg.equals(strOrigOrg) && strNewSubinv.equals(strOrigSubinv))
					{
						throw new Exception("第"+(i)+"筆:移入ORG與倉別不可與轉出Org和倉別相同!!");
					}				
					else
					{
						ifound=false;
						if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
						while (rsh.next())
						{
							if (rsh.getString("organization_code").equals(strNewOrg) && rsh.getString("secondary_inventory_name").equals(strNewSubinv))
							{
								ifound=true;
								break;
							}
						}
						if (ifound==false)
						{
							throw new Exception("第"+(i)+"筆:移入倉別不存在!!");
						}
					}
											
					//數量
					wcItem = sht.getCell(9, i);          
					strQty = (wcItem.getContents()).trim();
					if (strQty == null) strQty = "";
					if (strQty.equals(""))
					{
						throw new Exception("第"+(i)+"筆:數量不可空白!!");
					}

					//單位
					wcItem = sht.getCell(10, i);          
					strUom = (wcItem.getContents()).trim();
					if (strUom   == null) strUom  = "";
					//if (strUom .equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:單位不可空白!!");
					//}
					//else if (!strUom.equals("KPC") && !strUom.equals("PCE"))
					//{
					//	throw new Exception("第"+(i+1)+"列:單位值錯誤(應為KPC或PCE)!!");
					//}					
					
					//移出原因
					wcItem = sht.getCell(11, i);          
					strReason = (wcItem.getContents()).trim();
					if (strReason  == null) strReason = "";
					if (strReason.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移轉原因不可空白!!");
					}
					
					//單價
					wcItem = sht.getCell(12, i); 
					if (wcItem .getType() == CellType.NUMBER) 
					{
						strUnitPrice = (new DecimalFormat("#####.###")).format(Double.parseDouble(""+((NumberCell) wcItem).getValue()));
					}
					else strUnitPrice = (wcItem.getContents()).trim();	
					if (strUnitPrice == null || strUnitPrice.equals(""))
					{
						throw new Exception("第"+(i)+"筆:單價不可空白!!");
					}
					//金額
					wcItem = sht.getCell(13, i); 
					if (wcItem .getType() == CellType.NUMBER) 
					{
						strAmt = (new DecimalFormat("#####.##")).format(Double.parseDouble(""+((NumberCell) wcItem).getValue()));
					}
					else strAmt = (wcItem.getContents()).trim();	
					if (strAmt == null || strAmt.equals(""))
					{
						throw new Exception("第"+(i)+"筆:單價不可空白!!");
					}
				}
				//料號移轉(重分轉入)通知單
				else if (rdoitem.equals("MISC"))
				{
					//產品別
					jxl.Cell wcItem = sht.getCell(0, i);          
					strProdGroup = (wcItem.getContents()).trim();
					if (strProdGroup  == null) strProdGroup = "";

					//料號
					wcItem = sht.getCell(1, i);          
					strItemName = (wcItem.getContents()).trim();
					if (strItemName  == null) strItemName = "";
					
					//品名
					wcItem = sht.getCell(2, i);          
					strItemDesc = (wcItem.getContents()).trim();
					if (strItemDesc  == null) strItemDesc = "";		
					//if (strItemDesc.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:品名不可空白!!");
					//}	
					if (strItemName.equals("") && strItemDesc.equals(""))
					{
						throw new Exception("第"+(i)+"筆:料號或品名請擇一輸入!!");
					}						
											
					//lot
					wcItem = sht.getCell(3, i);          
					strLot = (wcItem.getContents()).trim();
					if (strLot  == null) strLot = "";		
					if (strLot.equals(""))
					{
						throw new Exception("第"+(i)+"筆:Lot不可空白!!");
					}								

					//d/c
					wcItem = sht.getCell(4, i);          
					strDateCode = (wcItem.getContents()).trim();
					if (strDateCode  == null) strDateCode = "";		
					//if (strDateCode.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:Date Code不可空白!!");
					//}	
	
					//數量
					wcItem = sht.getCell(5, i);          
					strQty = (wcItem.getContents()).trim();
					if (strQty == null) strQty = "";
					if (strQty.equals(""))
					{
						throw new Exception("第"+(i)+"筆:數量不可空白!!");
					}

					//單位
					wcItem = sht.getCell(6, i);          
					strUom = (wcItem.getContents()).trim();
					if (strUom   == null) strUom  = "";

					//移出org
					wcItem = sht.getCell(7, i);          
					strOrigOrg = (wcItem.getContents()).trim();
					if (strOrigOrg  == null) strOrigOrg = "";
					if (strOrigOrg.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移出Org不可空白!!");
					}	
					else if (!strOrigOrg.equals("I1") && !strOrigOrg.equals("I20") && !strOrigOrg.equals("I91") && !strOrigOrg.equals("I13"))
					{
						throw new Exception("第"+(i)+"筆:移出org錯誤(目前只開放I1,I20,I13,I91)!!");
					}					
					
					//移出倉別 
					wcItem = sht.getCell(8, i);          
					strOrigSubinv = (wcItem.getContents()).trim();
					if (strOrigSubinv  == null) strOrigSubinv = "";
					if (strOrigSubinv.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移出倉別不可空白!!");
					}	
					else
					{
						ifound=false;
						if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
						while (rsh.next())
						{
							if (rsh.getString("organization_code").equals(strOrigOrg) && rsh.getString("secondary_inventory_name").equals(strOrigSubinv))
							{
								ifound=true;
								break;
							}
						}
						if (ifound==false)
						{
							throw new Exception("第"+(i)+"筆:移出倉別不存在!!");
						}
					}
										
					//輸入料號
					wcItem = sht.getCell(9, i);          
					strNewItemName = (wcItem.getContents()).trim();
					if (strNewItemName  == null) strNewItemName = "";
					//if (strNewItemName.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:轉入料號不可空白!!");
					//}	
					
					//轉入品名
					wcItem = sht.getCell(10, i);          
					strNewItemDesc= (wcItem.getContents()).trim();
					if (strNewItemDesc  == null) strNewItemDesc = "";
					//if (strNewItemDesc.equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:轉入品名不可空白!!");
					//}	
					if (strNewItemName.equals("") && strNewItemDesc.equals(""))
					{
						throw new Exception("第"+(i)+"筆:轉出料號或轉出品名請擇一輸入!!");
					}					
					else if (strNewItemDesc.equals(strItemDesc) && 	(strItemName.equals("") || strNewItemName.equals("")))
					{
						throw new Exception("第"+(i)+"筆:轉出入品名相同時,轉出入料號不可空白!!");
					}
						
					//轉入lot
					wcItem = sht.getCell(11, i);          
					strNewLot = (wcItem.getContents()).trim();
					if (strNewLot  == null) strNewLot = "";		
					if (strNewLot.equals(""))
					{
						throw new Exception("第"+(i)+"筆:轉入Lot不可空白!!");
					}								

					//轉入d/c
					wcItem = sht.getCell(12, i);          
					strNewDateCode = (wcItem.getContents()).trim();
					if (strNewDateCode  == null) strNewDateCode = "";		
											
					//輸入數量
					wcItem = sht.getCell(13, i);          
					strNewQty = (wcItem.getContents()).trim();
					if (strNewQty == null) strNewQty = "";
					if (strNewQty.equals(""))
					{
						throw new Exception("第"+(i)+"筆:轉入數量不可空白!!");
					}

					//輸入單位
					wcItem = sht.getCell(14, i);          
					strNewUom = (wcItem.getContents()).trim();
					if (strNewUom   == null) strNewUom  = "";
					//if (strUom .equals(""))
					//{
					//	throw new Exception("第"+(i+1)+"列:單位不可空白!!");
					//}
					//else if (!strUom.equals("KPC") && !strUom.equals("PCE"))
					//{
					//	throw new Exception("第"+(i+1)+"列:單位值錯誤(應為KPC或PCE)!!");
					//}					
					
					//移出原因
					wcItem = sht.getCell(15, i);          
					strReason = (wcItem.getContents()).trim();
					if (strReason  == null) strReason = "";
					if (strReason.equals(""))
					{
						throw new Exception("第"+(i)+"筆:移轉原因不可空白!!");
					}
					
				}
				
				//檢查料號
				sql = " select a.segment1,a.description,a.inventory_item_status_code,tsc_inv_category(a.inventory_item_id,a.organization_id,1100000003) tsc_prod_group,a.item_type,a.PRIMARY_UNIT_OF_MEASURE uom"+
                      " from inv.mtl_system_items_b a,inv.mtl_parameters b"+
                      " where a.organization_id=b.organization_id"+
                      " and a.segment1=nvl(?,a.segment1)"+
                      " and a.description=nvl(?,a.description)"+
                      " and b.organization_code=?";
				statement = con.prepareStatement(sql);
				statement.setString(1,strItemName);
				if (!strItemName.equals("") && strItemName.length()<22)
				{
					statement.setString(2,null);
				}
				else
				{
					statement.setString(2,strItemDesc);
				}
				statement.setString(3,strOrigOrg);
				rs=statement.executeQuery();
				if (rs.next())
				{
					if (rs.getString("inventory_item_status_code").equals("Inactive"))
					{
						throw new Exception("第"+(i)+"列:料號"+rs.getString("segment1")+"已停用!!");
					}
					if (rs.getString("item_type").equals("FG"))
					{
						strProdGroup=rs.getString("tsc_prod_group");
					}
					else if (rs.getString("item_type").equals("SA"))
					{
						strProdGroup="半成品";
					}
					else
					{
						strProdGroup="原物料";
					}
					strItemName=rs.getString("segment1");
					strItemDesc=rs.getString("description");
					strUom=rs.getString("uom");					
				}
				else
				{
					out.println("xxx");
					throw new Exception("第"+(i)+"列:查無料號"+rs.getString("segment1")+"!!");
				}
				rs.close();
				statement.close();
				
				strKey=strItemName+","+strOrigOrg+","+strOrigSubinv+","+strLot;
				
				//檢查庫存
				sql = " select nvl(sum(TRANSACTION_QUANTITY* case when TRANSACTION_UOM_CODE='KPC' THEN 1000 ELSE 1 END ),0) onhand"+
                      " from (select b.organization_code,a.* from inv.mtl_onhand_quantities_detail a,inv.mtl_parameters b where a.organization_id=b.organization_id) a,inv.mtl_system_items_b c,oraddman.tsc_stock_trans_subinv d,oraddman.tsc_stock_trans_type e"+
                      " where a.organization_code=?"+
                      " and a.organization_id=c.organization_id"+
                      " and a.inventory_item_id=c.inventory_item_id"+
                      " and c.segment1=?"+
                      " and a.subinventory_code=?"+
                      " and a.lot_number=?"+
                      " and a.organization_code=d.organization_code(+)"+
                      " and a.subinventory_code=d.subinventory_code(+)"+
                      " and d.trans_type=e.trans_type"+
                      " and e.trans_name=?";			  
				//out.println(sql);
				statement = con.prepareStatement(sql);
				statement.setString(1,strOrigOrg);
				statement.setString(2,strItemName);
				statement.setString(3,strOrigSubinv);
				statement.setString(4,strLot);
				statement.setString(5,rdoitem);
				rs=statement.executeQuery();
				if (rs.next())
				{	
					ionhand = Double.parseDouble(rs.getString("onhand"));
				}
				else
				{
					ionhand=0;
				}
				rs.close();
				statement.close();
					
				if ((String)hashtb.get(strKey)==null)
				{
					iUseQty=0;
				}
				else
				{
					iUseQty = Double.parseDouble((String)hashtb.get(strKey));
				}
				iQty =ionhand-iUseQty;
				iStrQty = Double.parseDouble(strQty);
				iiStrQty = Math.round(iStrQty*(strUom.equals("KPC")?1000:1));
				iQty =iQty-iiStrQty ;		
				if (iQty<0)
				{
					throw new Exception("第"+(i)+"列:料號:"+strItemName+"    LOT:"+strLot+" 庫存不足("+iQty+"  "+ionhand+"  "+iUseQty+"  "+iStrQty+"  "+iiStrQty+")!!");
				}
				
				iUseQty+= (Double.parseDouble(strQty)*(strUom.equals("KPC")?1000:1));
				hashtb.put(strKey,""+iUseQty);
				
				//檢查倉別
				sql = " SELECT 1  FROM oraddman.tsc_stock_trans_subinv a,oraddman.tsc_stock_trans_type b"+
                      " WHERE nvl(a.active_flag,'N') =?"+
                      " AND a.organization_code=?"+
                      " AND a.subinventory_code=?"+
					  " AND a.trans_type=b.trans_type"+
					  " AND b.trans_name=?";
				statement = con.prepareStatement(sql);
				statement.setString(1,"A");
				statement.setString(2,strOrigOrg);
				statement.setString(3,strOrigSubinv);
				statement.setString(4,rdoitem);
				rs=statement.executeQuery();
				if (!rs.next())
				{	
					throw new Exception("第"+(i)+"列:移出ORG:"+strOrigOrg+"    移出倉別:"+strOrigSubinv+" 不在可執行交易名單中!!");
				}
				rs.close();	
				statement.close();				  
					 
				if (rdoitem.equals("SUBTRANS"))
				{					  
					//檢查倉別
					sql = " SELECT 1  FROM oraddman.tsc_stock_trans_subinv a,oraddman.tsc_stock_trans_type b"+
						  " WHERE nvl(a.active_flag,'N') =?"+
						  " AND a.organization_code=?"+
						  " AND a.subinventory_code=?"+
						  " AND a.trans_type=b.trans_type"+
						  " AND b.trans_name=?";
					statement = con.prepareStatement(sql);
					statement.setString(1,"A");
					statement.setString(2,strNewOrg);
					statement.setString(3,strNewSubinv);
					statement.setString(4,rdoitem);
					rs=statement.executeQuery();
					if (!rs.next())
					{	
						throw new Exception("第"+(i)+"列:移出ORG:"+strNewOrg+"    移出倉別:"+strNewSubinv+" 不在可執行交易名單中!!");
					}
					rs.close();	
					statement.close();	
				}
				else if (rdoitem.equals("MISC"))
				{
					sql = " select a.segment1,a.description,a.inventory_item_status_code,tsc_inv_category(a.inventory_item_id,a.organization_id,1100000003) tsc_prod_group,a.PRIMARY_UNIT_OF_MEASURE uom"+
						  " from inv.mtl_system_items_b a,inv.mtl_parameters b"+
						  " where a.organization_id=b.organization_id"+
						  " and a.segment1=nvl(?,a.segment1)"+
						  " and a.description=nvl(?,a.description)"+
						  " and b.organization_code=?";
					//out.println(sql);
					statement = con.prepareStatement(sql);
					statement.setString(1,strNewItemName);
					statement.setString(2,strNewItemDesc);
					statement.setString(3,strOrigOrg);
					rs=statement.executeQuery();
					if (rs.next())
					{
						if (rs.getString("inventory_item_status_code").equals("Inactive"))
						{
							throw new Exception("第"+(i)+"列:轉入料號"+rs.getString("segment1")+"已停用!!");
						}
						strNewItemName=rs.getString("segment1");
						strNewItemDesc=rs.getString("description");
					}
					else
					{
						throw new Exception("第"+(i)+"列:轉入料號"+rs.getString("segment1")+"不存在ERP!!");
					}
					rs.close();
					statement.close();				
				}
				
				String StockA[][]=StockBean.getArray2DContent();
				if (StockA!=null)
				{
					String StockB[][]=new String[StockA.length+1][StockA[0].length];
					for (int k=0 ; k < StockA.length ; k++)
					{
						for (int m=0 ; m < StockA[k].length; m++)
						{ 
							StockB[k][m]=StockA[k][m];				    
						} 
					}
					StockB[StockA.length][0] = strProdGroup;
					StockB[StockA.length][1] = strItemName;
					StockB[StockA.length][2] = strItemDesc;
					StockB[StockA.length][3] = strLot;
					StockB[StockA.length][4] = strDateCode;		
					StockB[StockA.length][5] = strOrigOrg; 
					StockB[StockA.length][6] = strOrigSubinv; 
					StockB[StockA.length][7] = strNewItemName; 
					StockB[StockA.length][8] = strNewItemDesc; 
					StockB[StockA.length][9] = strNewOrg; 
					StockB[StockA.length][10] = strNewSubinv; 
					StockB[StockA.length][11] = strQty; 
					StockB[StockA.length][12] = strUom; 
					StockB[StockA.length][13] = strReason; 
					StockB[StockA.length][14] = strUnitPrice;
					StockB[StockA.length][15] = strAmt; 
					StockB[StockA.length][16] = strNewLot; 
					StockB[StockA.length][17] = strNewDateCode; 
					StockB[StockA.length][18] = strNewQty; 
					StockB[StockA.length][19] = strNewUom; 					
					StockBean.setArray2DString(StockB);					
				}
				else
				{
					String StockB[][]={{strProdGroup,strItemName,strItemDesc,strLot,strDateCode,strOrigOrg,strOrigSubinv,strNewItemName,strNewItemDesc,strNewOrg,strNewSubinv,strQty,strUom,strReason,strUnitPrice,strAmt,strNewLot,strNewDateCode,strNewQty,strNewUom}};
					StockBean.setArray2DString(StockB); 
				}	
			}
			
			wb.close();
			rsh.close();
			statementh.close();		
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.action="../jsp/TSCStockTransRequest.jsp?rdoitem=<%=rdoitem%>&ACTIONCODE=UPLOAD";
				window.opener.document.MYFORM.submit();
				setClose();		
			</script>
	<%		
		}
		catch(Exception e)
		{
			out.println("<div style='color:#ff0000;font-family:arial;font-size:12px'>上傳失敗!!錯誤原因如下說明..<br>"+e.getMessage()+"</div>");
		}
	}
%>
<input type="hidden" name="rdoitem" value="<%=rdoitem%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
