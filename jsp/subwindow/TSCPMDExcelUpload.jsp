<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
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
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
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
	if (document.SITEFORM.UPLOADFILE.value ==null || document.SITEFORM.UPLOADFILE.value=="")
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else
	{
		var filename = document.SITEFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.SITEFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SITEFORM.upload.disabled=true;
	document.SITEFORM.winclose.disabled=true;	
	document.SITEFORM.action=URL;
	document.SITEFORM.submit();	
}
function setClose()
{
	//var SUPPLIERNO = window.opener.document.MYFORM.SUPPLIERNO.value;
	//var SUPPLIERNAME = window.opener.document.MYFORM.SUPPLIERNAME.value;
	//var SUPPLIERSITE = window.opener.document.MYFORM.SUPPLIERSITE.value;
	//var CURRENCYCODE = window.opener.document.MYFORM.CURRENCYCODE.value;
	//var REQUESTNO = window.opener.document.MYFORM.REQUESTNO.value;
	window.opener.document.getElementById("alpha").style.width="0%";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<title>Excel Upload</title>
</head>
<%
	String SUPPLIERNO = request.getParameter("SUPPLIERNO");
	if (SUPPLIERNO == null) SUPPLIERNO="";
	String SUPPLIERNAME = request.getParameter("SUPPLIERNAME");
	if (SUPPLIERNAME == null) SUPPLIERNAME="";
	String SUPPLIERSITE = request.getParameter("SUPPLIERSITE");
	if (SUPPLIERSITE ==null) SUPPLIERSITE =""; //add by Peggy 20130204
	String ACTION = request.getParameter("ACTION");
	if (ACTION ==null) ACTION="";
	int colCnt = 14;
	String LINENUM="",ITEMID="",ITEMNAME="",ITEMDESC="",PRICE="",REASON="",STARTQTY="", ENDQTY= "", PREPRICE ="", PERCENTAGE ="",sql="",UOM="",PRICELIST="",QTY_UNIT="",ORG_ID="",TSC_PROD_GROUP="",ORIG_VENDOR="";

	sql = " select a.VENDOR_NAME from  AP.ap_suppliers a where a.SEGMENT1='"+SUPPLIERNO+"'";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if(rs.next())
	{
		SUPPLIERNAME = rs.getString("VENDOR_NAME");
	}
	rs.close();
	statement.close();
%>
<body >  
<FORM METHOD="post" NAME="SITEFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;廠商名稱&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong><%=SUPPLIERNAME%></strong></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;</font><INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" class="style3"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../samplefiles/F2-001_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../subwindow/TSCPMDExcelUpload.jsp?ACTION=UPLOAD&SUPPLIERNO=<%=SUPPLIERNO%>&SUPPLIERNAME=<%=SUPPLIERNAME%>&SUPPLIERSITE=<%=SUPPLIERSITE%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		StringBuilder sb = new StringBuilder();
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			String strDate=dateBean.getYearMonthDay();
			String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\F2-001("+SUPPLIERNO+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			
			//廠商名稱
			jxl.Cell wcVendor= sht.getCell(1, 0);          
			String Vendor= (wcVendor.getContents()).trim();
			if (Vendor  == null || Vendor.length() ==0) Vendor = "";

			if (!Vendor.equals(SUPPLIERNAME))
			{
				throw new Exception("檔案裡的廠商與實際申請的廠商不符,請重新確認,謝謝!!");
			}
			for (int i = 2; i <sht.getRows(); i++) 
			{
				//料號
				jxl.Cell wcItemName = sht.getCell(0, i);          
				ITEMNAME = (wcItemName.getContents()).trim();
				if (ITEMNAME  == null || ITEMNAME.length() ==0) ITEMNAME  = "";
				
				//品名
				jxl.Cell wcItemDesc = sht.getCell(1, i);          
				ITEMDESC = (wcItemDesc.getContents()).trim();
				if (ITEMDESC  == null) ITEMDESC = "";
				if (ITEMNAME.equals("") && ITEMDESC.equals(""))
				{
					throw new Exception("料號或品名必須擇一輸入,不可同時空白,謝謝!!");
				}
				
				//起始訂單量
				jxl.Cell wcSQTY = sht.getCell(2, i);     
				if (wcSQTY.getType() == CellType.NUMBER) 
				{
					STARTQTY = (new DecimalFormat("###0")).format(Float.parseFloat(""+((NumberCell) wcSQTY).getValue()));
				}
				else STARTQTY = (wcSQTY.getContents()).trim();
				if (STARTQTY == null || STARTQTY.equals(""))
				{
					throw new Exception("起始訂單量不可空白,謝謝!!");
				}
				//結束訂單量
				jxl.Cell wcEQTY = sht.getCell(3, i);   
				if (wcEQTY.getType() == CellType.NUMBER) 
				{
					ENDQTY = (new DecimalFormat("###0")).format(Float.parseFloat(""+((NumberCell) wcEQTY).getValue()));
				}
				else ENDQTY = (wcEQTY.getContents()).trim();
				if (ENDQTY == null || ENDQTY.equals(""))
				{
					throw new Exception("結束訂單量不可空白,謝謝!!");
				}
				//單位
				jxl.Cell wcUOM = sht.getCell(4, i);  
				UOM = (wcUOM.getContents()).trim().toUpperCase();

				//單價
				jxl.Cell wcUnitPrice = sht.getCell(5, i);  
				if (wcUnitPrice.getType() == CellType.NUMBER) 
				{
					PRICE = ""+((NumberCell) wcUnitPrice).getValue();
				} 
				else PRICE = (wcUnitPrice.getContents()).trim();
				if (PRICE == null) PRICE="0";


				//original supplier code,add by Peggy 20191220
				jxl.Cell wcOrigVendor = sht.getCell(7, i);          
				ORIG_VENDOR = (wcOrigVendor.getContents()).trim();
				if (ORIG_VENDOR == null || ORIG_VENDOR.length() ==0) ORIG_VENDOR = "&nbsp;";
				
				if (!ITEMNAME.equals("") || !ITEMDESC.equals(""))
				{
					sql = " select a.segment1,a.description,a.inventory_item_id,nvl(b.unit_price,0) unit_price,"+
						  " decode(nvl(b.unit_price,0),0,0,round(("+PRICE+"-b.unit_price)/b.unit_price*100,2)) percentage"+
						  ",a.organization_id,TSC_INV_Category(a.inventory_item_id, a.organization_id, 1100000003) tsc_prod_group"+
						  " from inv.mtl_system_items_b a,"+
						  " (select inventory_item_id, unit_price from (select inventory_item_id, unit_price,row_number() over (partition by inventory_item_id order by creation_date desc) row_num "+
						  " from oraddman.TSPMD_ITEM_QUOTATION where 1=1";
					if (ORIG_VENDOR.equals("&nbsp;"))
					{
						sql +=" and (VENDOR_CODE='"+ SUPPLIERNO+"' or decode(VENDOR_CODE,3517,2876,VENDOR_CODE)='"+SUPPLIERNO+"') "+
						  " and  VENDOR_SITE_ID ='"+SUPPLIERSITE+"' " ;
					}
					else
					{
						sql +=" and VENDOR_CODE='"+ ORIG_VENDOR+"'";
					}
					sql += "  and ((start_qty >="+ STARTQTY+" and  end_qty <="+ ENDQTY +") or ("+STARTQTY+" >= start_qty and "+ENDQTY+" <=end_qty))) b  where row_num=1) b"+
						  " where a.organization_id=49 and a.inventory_item_id  = b.inventory_item_id(+) ";
					if (!ITEMNAME.equals("")) sql += " and a.segment1='"+ ITEMNAME +"'";
					if (!ITEMDESC.equals("")) sql += " and a.description = '" + ITEMDESC + "'";
					Statement statementx=con.createStatement();
					//if (ITEMDESC.equals("TSC5302DCH C5G")) out.println(sql);
					//out.println(sql);
					ResultSet rsx=statementx.executeQuery(sql);
					if(rsx.next())
					{
						ITEMID = rsx.getString("inventory_item_id");
						ITEMNAME = rsx.getString("segment1");
						ITEMDESC = rsx.getString("description");
						PREPRICE = rsx.getString("unit_price");
						PERCENTAGE = rsx.getString("percentage");
						PRICELIST =""; //add by Peggy 20121026
						ORG_ID=rsx.getString("organization_id");        //add by Peggy 20190315
						TSC_PROD_GROUP=rsx.getString("tsc_prod_group"); //add by Peggy 20190315
						
						sql = " SELECT a.end_qty, a.unit_price"+
							  " FROM oraddman.tspmd_item_quotation a  "+
							  " where a.vendor_code ='"+SUPPLIERNO+"'"+
							  " and a.VENDOR_SITE_ID ='"+SUPPLIERSITE+"'"+
							  " and exists (select 1 from inv.mtl_system_items_b b where b.organization_id=49";
						if (!ITEMNAME.equals("")) sql += " and b.segment1 ='"+ ITEMNAME +"'";
						if (!ITEMDESC.equals("")) sql += " and b.description = '" + ITEMDESC + "'";
						sql += " and b.inventory_item_id = a.inventory_item_id)";
						//out.println(sql);
						Statement statement2=con.createStatement();
						ResultSet rs2=statement2.executeQuery(sql);
						while (rs2.next())
						{
							PRICELIST += (rs2.getString("end_qty")+"="+ (new DecimalFormat("####0.###")).format(Float.parseFloat(rs2.getString("unit_price")))+",");
						}
						rs2.close();
						statement2.close();
						
						//add by Peggy 20121105
						/*
						sql = " select DECODE(x.DATA_TYPE,'ITEM',1,DECODE(x.DATA_NAME,'OTHER',3,2)) SEQNO, QTY_UNIT from oraddman.TSPMD_QUOTATION_UNIT_SETUP x where (x.DATA_TYPE='ITEM' AND x.DATA_NAME='"+ITEMNAME+"') or (x.DATA_TYPE='PACKAGE' AND x.DATA_NAME IN ( TSC_OM_CATEGORY('"+ITEMID+"',49,'TSC_Package'),'OTHER')) order by 1";
						Statement statement3=con.createStatement();
						ResultSet rs3=statement3.executeQuery(sql);
						if (rs3.next())
						{
							QTY_UNIT = rs3.getString("QTY_UNIT");
						}
						//out.println(PriceList);
						rs3.close();
						statement3.close();
						*/
						QTY_UNIT = ""+(Long.parseLong(ENDQTY) - Long.parseLong(STARTQTY));  //modify by Peggy 20131212
					}
					else
					{
						ITEMID="";
						PREPRICE = "0";
						PERCENTAGE = "0";
						PRICELIST ="";
						//QTY_UNIT ="500";
						QTY_UNIT ="0";  //modify by Peggy 20131212
						ORG_ID="";
						TSC_PROD_GROUP="";
					}
					rsx.close();
					statementx.close();
				}
				else
				{
					ITEMID="";
					PREPRICE = "0";
					PERCENTAGE = "0";
					PRICELIST ="";
					//QTY_UNIT ="500";
					QTY_UNIT ="0"; //modify by Peggy 20131212
					ORG_ID="";
					TSC_PROD_GROUP="";
				}
				//REASON
				jxl.Cell wcReason = sht.getCell(6, i);          
				REASON = (wcReason.getContents()).trim();
				if (REASON == null || REASON.length() ==0) REASON = "&nbsp;";

					
				//負數數量不做上傳
				if (!ITEMID.equals("") || !ITEMNAME.equals("") || !ITEMDESC.equals(""))
				{
					sb.append(ITEMID+";"+ITEMNAME+";"+ITEMDESC+";"+PRICE+";"+PREPRICE+";"+PERCENTAGE+";"+STARTQTY+";"+ENDQTY+";"+REASON+";"+UOM+";"+PRICELIST+";"+QTY_UNIT+";"+ORG_ID+";"+TSC_PROD_GROUP+"<br>");			
					//if (ITEMDESC.equals("TSC5302DCH C5G")) out.println(ITEMID+";"+ITEMNAME+";"+ITEMDESC+";"+PRICE+";"+PREPRICE+";"+PERCENTAGE+";"+STARTQTY+";"+ENDQTY+";"+REASON);
				}
				else if (!ITEMNAME.equals("") || !ITEMDESC.equals(""))
				{
					out.println("<script language=javascript>alert('Line:"+i+"的料號不正確!')</script>");
				}
			}
			wb.close();
		}
		catch(Exception e)
		{
			out.println("<font color='red' size='+1'>Exception:"+e.getMessage()+"</font>");
		}
		finally
		{
			if (!sb.toString().equals(""))
			{
				try
				{
					String [] strArray  = (sb.toString().replace("&nbsp;","")).split("<br>");
					if (strArray.length > 0)
					{
						if (strArray.length <10)
							LINENUM ="10";
						else
							LINENUM = ""+ strArray.length;
						String b[][] =new String[Integer.parseInt(LINENUM)][colCnt];
						for (int m = 0 ; m < strArray.length ; m ++)
						{
							String [] strDetail = strArray[m].split(";");
							for (int n =0 ; n < strDetail.length ; n++)
							{
								b[m][n]= strDetail[n].trim();
							}
						}
						arrayRFQDocumentInputBean.setArray2DString(null); 
						arrayRFQDocumentInputBean.setArray2DString(b);
		%>
					<script language="JavaScript" type="text/JavaScript">
						var SUPPLIERNO = window.opener.document.MYFORM.SUPPLIERNO.value;
						var SUPPLIERNAME = window.opener.document.MYFORM.SUPPLIERNAME.value;
						var SUPPLIERSITE = window.opener.document.MYFORM.SUPPLIERSITE.value;
						var CURRENCYCODE = window.opener.document.MYFORM.CURRENCYCODE.value;
						var REQUESTNO = window.opener.document.MYFORM.REQUESTNO.value;
						var REMARKS = window.opener.document.MYFORM.REMARKS.value;
						var LINENUM = window.opener.document.MYFORM.LINENUM.value;
						var FILEID = window.opener.document.MYFORM.FILEID.value;
						var VENDOR_SITE_ID = window.opener.document.MYFORM.VENDOR_SITE_ID.value;
						var rec_cnt =0;
						var actiontype = "N";
						for (var i = 1 ; i <= LINENUM ; i ++)
						{
							var ITEMID = window.opener.document.MYFORM.elements["ITEMID"+i].value;
							var ITEMNAME = window.opener.document.MYFORM.elements["ITEMNAME"+i].value;
							var ITEMDESC = window.opener.document.MYFORM.elements["ITEMDESC"+i].value;
							var PRICE = window.opener.document.MYFORM.elements["PRICE"+i].value;
							var STARTQTY = window.opener.document.MYFORM.elements["STARTQTY"+i].value;
							var ENDQTY = window.opener.document.MYFORM.elements["ENDQTY"+i].value;
							var REASON = window.opener.document.MYFORM.elements["REASON"+i].value;
							var UOM = window.opener.document.MYFORM.elements["UOM"+i].value;
							if ((ITEMID != null && ITEMID != "") && (ITEMNAME != null && ITEMNAME != "") && (ITEMDESC !=null && ITEMDESC != "") && (PRICE !=null && PRICE != "") && (UOM !=null && UOM != "" && UOM != "--"))
							{
								rec_cnt ++;
							}
						}
						if (rec_cnt>0)
						{
							if (confirm("系統檢查到申請畫面上有"+rec_cnt+"筆資料，上傳動作將會取代這些資料，您確定要上傳嗎?"))
							{
								actiontype="Y";
							}
						}
						else
						{
							actiontype="Y";
						}
						if (actiontype=="Y")
						{
							window.opener.location.href="../TSCPMDQuotationCreate.jsp?ACTIONCODE=EXLUPD&SUPPLIERNO="+SUPPLIERNO+"&SUPPLIERNAME="+SUPPLIERNAME+"&SUPPLIERSITE="+SUPPLIERSITE+"&CURRENCYCODE="+CURRENCYCODE+"&REQUESTNO="+REQUESTNO+"&FILEID="+FILEID+"&VENDOR_SITE_ID="+VENDOR_SITE_ID+"&REMARKS="+REMARKS;
							window.close();				
						}	
					</script>
		<%				
					}
				}
				catch(Exception e)
				{
					out.println("<font color='#ff0000'>Error="+e.getMessage()+"</font>");
				}
			}
		}
	}
%>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
