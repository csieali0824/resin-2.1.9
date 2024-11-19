<!--modify by Peggy 20160824,lot第一碼必須為英文字-->
<!--modify by Peggy 20170920,新增remarks欄位-->
<!--modify by Peggy 20171205,檢查供應商來貨D/C是否符FIFO,不符者需填入原因-->
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
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
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
	if (document.SUBFORM.RECEIVE_DATE.value==null || document.SUBFORM.RECEIVE_DATE.value=="")
	{
		alert("請先指定收貨日期!");
		return false;	
	}
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
	document.SUBFORM.action=URL+"&RECEIVE_DATE="+document.SUBFORM.RECEIVE_DATE.value;;
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
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String VENDORID = request.getParameter("VENDORID");
if (VENDORID == null) VENDORID="";
String RECEIVE_DATE = request.getParameter("RECEIVE_DATE");
if (RECEIVE_DATE==null) RECEIVE_DATE=dateBean.getYearMonthDay();
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String VENDOR_NAME = "",CURRENCY_CODE="",ITEMDESC="",LOT="",RECEIVE_QTY="",DATE_CODE="",PO_NO="",CURR="",PRE_DATE_CODE="",CUST_PARTNO="",VENDOR_SITE_CODE="",remarks="",no_fifo_reason="",ITEMNAME="",no_fifo_flag="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int colCnt = 12,start_row=5,i_code=0;
long QTY=0,ALLOT_QTY=0,REC_QTY=0,UN_REC_QTY=0;

try
{
	sql = " select a.VENDOR_NAME, b.INVOICE_CURRENCY_CODE CURRENCY_CODE,b.vendor_site_code from  AP.ap_suppliers a,ap.ap_supplier_sites_all b where b.vendor_site_id ="+VENDORID+" and b.vendor_id = a.vendor_id";
	Statement statement=con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	if(rs.next())
	{
		VENDOR_NAME = rs.getString("VENDOR_NAME");
		CURRENCY_CODE = rs.getString("CURRENCY_CODE");
		VENDOR_SITE_CODE = rs.getString("VENDOR_SITE_CODE");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("查詢供應商資料時發生異常,請洽系統管理人員,謝謝!");
		setClose();
		this.window.close();
	</script>
<%
}
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<input type="hidden" name="ORGCODE" value="<%=ORGCODE%>">
<input type="hidden" name="VENDORID" value="<%=VENDORID%>">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;供應商&nbsp;</font></TD>
		<TD><font style="color:#000099;font-family:Arial;font-size:12px">&nbsp;<strong><%=VENDOR_NAME%></strong></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;收貨日期&nbsp;</font></TD>
		<TD><input type="TEXT" name="RECEIVE_DATE" value="<%=RECEIVE_DATE%>"  style="font-family: Tahoma,Georgia;" size="10" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"readonly ><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.SUBFORM.RECEIVE_DATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></TD>
	</TR>	
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="../samplefiles/H1-001_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TEWPOReceiveUploadImport.jsp?ACTION=UPLOAD&ORGCODE=<%=ORGCODE%>&VENDORID=<%=VENDORID%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		POReceivingBean.setArray2DString(null);
		StringBuilder sb = new StringBuilder();
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H1-001("+VENDORID+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			Hashtable hashtb = new Hashtable();
			Hashtable hashtb1 = new Hashtable();
			
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				//品名
				jxl.Cell wcItemDesc = sht.getCell(0, i);          
				ITEMDESC = (wcItemDesc.getContents()).trim();
				if (ITEMDESC  == null) ITEMDESC = "";
				if (ITEMDESC.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:型號不可空白!!");
				}
				
				//LOT
				jxl.Cell wcLOT = sht.getCell(1, i);  
				LOT = (wcLOT.getContents()).trim();
				if (LOT == null) LOT = "";
				if (LOT.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:LOT不可空白!!");
				}	
				else 
				{
					i_code=(int)(LOT.charAt(0));
					if (i_code <65 || i_code > 90)
					{
						throw new Exception("第"+(i+1)+"列:LOT:"+LOT+" 第一碼必須是大寫英字!!");
					}
				}
				
				//收貨數量
				jxl.Cell wcQTY = sht.getCell(2, i);  		   
				if (wcQTY.getType() == CellType.NUMBER) 
				{
					RECEIVE_QTY = (new DecimalFormat("#####.###")).format(Float.parseFloat(""+((NumberCell) wcQTY).getValue()));
				}
				else RECEIVE_QTY = (wcQTY.getContents()).trim();
				if (RECEIVE_QTY == null || RECEIVE_QTY.equals(""))
				{
					throw new Exception("第"+i+"列:數量不可空白!!");
				}
				else  if (Float.parseFloat(RECEIVE_QTY)<=0)
				{
					throw new Exception("第"+(i+1)+"列:數量必須大於0!!");
				}
				
				//DATE CODE
				jxl.Cell wcDC = sht.getCell(3, i);  
				DATE_CODE = (wcDC.getContents()).trim();
				if (DATE_CODE== null) DATE_CODE = "";
				if (DATE_CODE.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:DATE_CODE不可空白!!");
				}	
				else if (!DATE_CODE.equals(PRE_DATE_CODE))
				{
					sql = " select 1 from tsc.tsc_date_code where DATE_CODE=?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,DATE_CODE);
					ResultSet rs=statement.executeQuery();
					if (rs.next())					 
					{
						PRE_DATE_CODE=DATE_CODE;
					}	
					rs.close();	
					statement.close();
					
					if (!DATE_CODE.equals(PRE_DATE_CODE))
					{
						throw new Exception("第"+(i+1)+"列:查無DATE_CODE!!");
					}	
				}
				
				//CUST PART NO
				jxl.Cell wcCUSTPARTNO = sht.getCell(6, i);  
				CUST_PARTNO = (wcCUSTPARTNO.getContents()).trim();
				if (CUST_PARTNO== null || CUST_PARTNO.equals("")) CUST_PARTNO = "N/A";
								
				//PO
				jxl.Cell wcPO = sht.getCell(7, i);  
				PO_NO = (wcPO.getContents()).trim();
				if (PO_NO== null) PO_NO = "";
				if (PO_NO.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:採購單號不可空白!!");
				}	
				else
				{
					if ((String)hashtb1.get(PO_NO)==null)
					{
						hashtb1.put(PO_NO,"V");
						sql = " SELECT vendor_site_id, NVL(A.approved_flag, 'N') approved_flag, NVL(A.cancel_flag,'N') cancel_flag, NVL(A.closed_code,'OPEN') closed_code"+
							  " FROM PO.PO_HEADERS_ALL A WHERE A.SEGMENT1 =? AND  A.TYPE_LOOKUP_CODE='STANDARD'";
						PreparedStatement statement9 = con.prepareStatement(sql);
						statement9.setString(1,PO_NO);
						ResultSet rs9=statement9.executeQuery();
						while (rs9.next())
						{
							if (!rs9.getString("approved_flag").equals("Y"))
							{
								throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + " 尚未核淮，請與採購人員確認");
							}
							if (!rs9.getString("cancel_flag").equals("N"))
							{
								throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + " 已Cancelled，請與採購人員確認");
							}
							if (rs9.getString("closed_code").indexOf("CLOSED") >=0)
							{
								throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + " 已結案，請與採購人員確認");
							}
							if (!rs9.getString("vendor_site_id").equals(VENDORID))
							{
								throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + " 不是"+VENDOR_SITE_CODE +"的採購單");
							}
						}
						rs9.close();
						statement9.close();
					}
				}
				
				//CURR
				jxl.Cell wcCURR = sht.getCell(8, i);  
				CURR = (wcCURR.getContents()).trim();
				if (CURR== null) CURR = "";
				if (CURR.equals(""))
				{
					throw new Exception("第"+i+"列:幣別不可空白!!");
				}	
				else if (!CURR.equals(CURRENCY_CODE))
				{
					throw new Exception("第"+(i+1)+"列:"+CURR+"與供應商幣別"+CURRENCY_CODE+"不符!!");
				}	
				
				//remarks
				try
				{
					jxl.Cell wcREMARKS = sht.getCell(13, i);  
					remarks = (wcREMARKS.getContents()).trim();
					if (remarks== null) remarks = "";
				}
				catch(Exception e)
				{
					remarks = "";
				}
				
				//no fifo reason,add by Peggy 20171205
				try
				{
					jxl.Cell wcNOFIFOREASON = sht.getCell(14, i);  
					no_fifo_reason = (wcNOFIFOREASON.getContents()).trim();
					if (no_fifo_reason== null) no_fifo_reason = "";
				}
				catch(Exception e)
				{
					no_fifo_reason = "";
				}				
				
				
				sql = " SELECT a.PO_HEADER_ID,"+
					  " b.PO_LINE_ID,"+
					  " a.SEGMENT1 PO_NO,"+
					  " C.LINE_LOCATION_ID,"+
					  " to_char(c.need_by_date,'yyyy-mm-dd') need_by_date,"+
					  " E.SEGMENT1 ITEM_NAME,"+
					  " E.DESCRIPTION ITEM_DESC,"+
					  " A.CURRENCY_CODE,"+
					  " C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0) QUANTITY,"+
					  " C.UNIT_MEAS_LOOKUP_CODE UOM,"+
					  " C.QUANTITY_RECEIVED,"+
					  " C.QUANTITY_CANCELLED,"+
					  //" C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)-NVL(F.RECEIVED_QUANTITY,0) UNRECEIVE_QTY,"+
					  " C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)-NVL(F.RECEIVED_QUANTITY,0) -(NVL(F.SHIPPED_QUANTITY,0) - NVL(C.QUANTITY_RECEIVED,0)) UNRECEIVE_QTY,"+
					  " NVL(F.RECEIVED_QUANTITY,0) RECEIVED_QUANTITY,"+
					  " C.SHIP_TO_ORGANIZATION_ID,"+
					  " E.INVENTORY_ITEM_ID ITEM_ID"+
					  " FROM PO.PO_HEADERS_ALL A,"+
					  " PO.PO_LINES_ALL B,"+
					  " PO.PO_LINE_LOCATIONS_ALL C,"+
					  " INV.MTL_SYSTEM_ITEMS_B E,"+
					  "(SELECT x.PO_LINE_LOCATION_ID,SUM(x.RECEIVED_QUANTITY-NVL(x.SHIPPED_QUANTITY,0)) RECEIVED_QUANTITY,SUM(NVL(x.SHIPPED_QUANTITY,0)) SHIPPED_QUANTITY "+
					  " FROM ORADDMAN.TEWPO_RECEIVE_DETAIL x,ORADDMAN.TEWPO_RECEIVE_HEADER y WHERE x.PO_LINE_LOCATION_ID=y.PO_LINE_LOCATION_ID";
				if (!ORGCODE.equals(""))
				{
					sql += "  AND y.ORGANIZATION_ID="+ORGCODE+"";
				}
				else 
				{
					sql += "  AND y.ORGANIZATION_ID in (49,566)";
				}
				sql +=" AND y.PO_NO ='"+PO_NO+"'"+
					  " AND upper(y.ITEM_DESC) ='"+ITEMDESC.toUpperCase()+"'"+
					  " AND EXISTS (SELECT 1 from  PO.PO_HEADERS_ALL z where VENDOR_SITE_ID = '"+VENDORID+"' and z.po_header_id = y.po_header_id)"+
					  " GROUP BY x.PO_LINE_LOCATION_ID) F"+
                      " ,(SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
                      "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
                      "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr"+
					  " WHERE A.ORG_ID =?"+
					  " AND A.TYPE_LOOKUP_CODE='STANDARD'"+
					  " AND A.ORG_ID=B.ORG_ID"+
					  " AND B.ORG_ID=C.ORG_ID"+
					  " AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
					  " AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
					  " AND B.PO_LINE_ID = C.PO_LINE_ID"+
					  " AND NVL(A.approved_flag, 'N') = 'Y' "+
					  " AND NVL(A.cancel_flag,'N') = 'N'"+
					  " AND NVL(A.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
					  " AND NVL(B.cancel_flag,'N') = 'N'"+
					  " AND NVL(B.closed_code,'OPEN') <> 'CLOSED'"+
					  " AND NVL(B.closed_flag,'N') <> 'Y'"+
					  " AND NVL(C.cancel_flag,'N') <> 'Y' "+
					  " AND NVL(C.CLOSED_CODE,'OPEN') NOT LIKE  '%CLOSED%'"+
					  " AND C.quantity - NVL (C.quantity_received, 0) > 0";
				if (!ORGCODE.equals(""))
				{
					sql += "  AND C.ship_to_organization_id="+ORGCODE+"";
				}
				else 
				{
					sql += "  AND C.ship_to_organization_id in (49,566)";
				}						  
				sql +=" AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
					  " AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID"+
					  " AND C.LINE_LOCATION_ID = F.PO_LINE_LOCATION_ID(+)"+
					  " AND length(E.SEGMENT1)>=?"+
					  //" AND C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)-NVL(F.RECEIVED_QUANTITY,0)>0"+
					  " AND C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)-NVL(F.RECEIVED_QUANTITY,0) - (NVL(F.SHIPPED_QUANTITY,0) - NVL(C.QUANTITY_RECEIVED,0))>0"+
					  " AND A.SEGMENT1 ='"+PO_NO+"'"+
					  " AND UPPER(E.DESCRIPTION) ='"+ITEMDESC.toUpperCase()+"'"+
					  " AND a.VENDOR_SITE_ID = '"+VENDORID+"'"+
                      " AND SUBSTR (c.note_to_receiver,1, INSTR (c.note_to_receiver, '.') - 1) = odr.order_number(+)"+
                      " AND SUBSTR (c.note_to_receiver,INSTR (c.note_to_receiver, '.') + 1,LENGTH (c.note_to_receiver)) = odr.line_number(+)"+
					  " AND nvl(odr.cust_partno,nvl(B.note_to_vendor,'N/A'))='"+CUST_PARTNO+"'"+//modify by Peggy 20140717
					  " ORDER BY c.need_by_date,b.LINE_NUM"; //加po line add by Peggy 20150727
					 // " order by decode(nvl(odr.cust_partno,''),'"+CUST_PARTNO+"',1,2),decode(nvl(B.note_to_vendor,''),'"+CUST_PARTNO+"',1,2),c.need_by_date, case when C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)-NVL(F.RECEIVED_QUANTITY,0)-"+RECEIVE_QTY+" =0 then 1 else 2 end";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				//statement.setString(1,ORGCODE);
				statement.setString(1,"41");
				//statement.setString(3,ORGCODE);
				statement.setString(2,"22");
				ResultSet rs=statement.executeQuery();
				QTY = (long)(Float.parseFloat(RECEIVE_QTY)*1000); ALLOT_QTY=0;REC_QTY=0;UN_REC_QTY=0;no_fifo_flag="";
				while (rs.next())
				{
					ITEMNAME = rs.getString("ITEM_NAME");
					if (QTY<=0) break;
					if ((String)hashtb.get(rs.getString("LINE_LOCATION_ID"))==null)
					{
						ALLOT_QTY=0;
					}
					else
					{
						ALLOT_QTY = Long.parseLong((String)hashtb.get(rs.getString("LINE_LOCATION_ID")));
					}
					UN_REC_QTY = (long)(Float.parseFloat(rs.getString("UNRECEIVE_QTY"))*1000)-ALLOT_QTY;
					if (UN_REC_QTY >0)
					{
						if (QTY>=UN_REC_QTY)
						{
							REC_QTY=UN_REC_QTY;	
						}
						else
						{
							REC_QTY=QTY;
						}
						QTY =QTY - REC_QTY;
						hashtb.put(rs.getString("LINE_LOCATION_ID"),""+(ALLOT_QTY+REC_QTY));
						String LotA[][]=POReceivingBean.getArray2DContent();
						if (LotA!=null)
						{
							String LotB[][]=new String[LotA.length+1][LotA[0].length];
							for (int k=0 ; k < LotA.length ; k++)
							{
								for (int m=0 ; m < LotA[k].length; m++)
								{ 
									LotB[k][m]=LotA[k][m];				    
								} 
							}
							LotB[LotA.length][0] = rs.getString("LINE_LOCATION_ID");
							LotB[LotA.length][1] = RECEIVE_DATE;
							LotB[LotA.length][2] = LOT;
							LotB[LotA.length][3] = DATE_CODE;
							LotB[LotA.length][4] = ""+(new DecimalFormat("######.###")).format((float)REC_QTY/1000);		
							LotB[LotA.length][5] = remarks;  //add by Peggy 20170920
							LotB[LotA.length][6] = no_fifo_reason;  //add by Peggy 20171205
							POReceivingBean.setArray2DString(LotB);					
						}
						else
						{
							String LotB[][]={{rs.getString("LINE_LOCATION_ID"),RECEIVE_DATE,LOT,DATE_CODE,""+(new DecimalFormat("######.###")).format((float)REC_QTY/1000),remarks,no_fifo_reason}};
							POReceivingBean.setArray2DString(LotB); 
						}	
					}	
				}
				rs.close();
				statement.close();
				if (QTY>0)
				{
					//out.println(sql);
					//out.println(QTY);
					throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + "  型號:"+ITEMDESC + "  超收"+((float)(QTY/1000))+"K");
				}
				
				//檢查當天收貨D/C是否有符FIFO,若無,需填入原因
				//sql = " select case when date_code >? then '1' else '0' end as no_fifo_flag"+
				sql = " select case when date_code >? AND substr(date_code,1,1)<>'9' and substr(?,1,1)<>'0'  AND substr(date_code,2,1)<>'9' and substr(?,2,1)<>'0' then '1' else '0' end as no_fifo_flag"+ //modify by Peggy 20200108
			          " from (select a.vendor_site_id,a.item_name,b.date_code,b.creation_date,row_number() over(partition by a.vendor_site_id,a.item_name order by b.creation_date desc) receive_rank"+
			          " from oraddman.tewpo_receive_header a"+
				      " ,oraddman.tewpo_receive_detail b "+
              	      " where a.po_line_location_id=b.po_line_location_id "+
			          " and a.vendor_site_id=?"+
			          " and a.item_name=?"+
  		              " and trunc(b.creation_date) <trunc(sysdate)) x where receive_rank=1";
				PreparedStatement statement1 = con.prepareStatement(sql);
				statement1.setString(1,DATE_CODE);
				statement1.setString(2,DATE_CODE);
				statement1.setString(3,DATE_CODE);
				statement1.setString(4,VENDORID);
				statement1.setString(5,ITEMNAME);
				ResultSet rs1=statement1.executeQuery();
				if (rs1.next())
				{
					no_fifo_flag = rs1.getString(1);
				}
				rs1.close();	
				statement1.close();	
				
				if (no_fifo_flag.equals("1") && no_fifo_reason.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:採購單號:"+PO_NO + "  型號:"+ITEMDESC + "  Date Code="+DATE_CODE+" 廠商來貨不符先進先出原則,請填入原因!");
				}
				
			}
			wb.close();
			session.setAttribute("H1001",hashtb);
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.action="../jsp/TEWPOReceive.jsp?ORGCODE="+document.SUBFORM.ORGCODE.value+"&SUPPLIERSITEID="+document.SUBFORM.VENDORID.value+"&PONO=&ITEM=&ACTIONCODE=UPLOAD";
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
<!--%表單參數%-->
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
