<%@ page contentType="text/html;charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Slow Moving Stock Upload</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setCreate(URL)
{  
	if (document.form1.UPLOADFILE.value=='')
	{
		alert("請指定上傳檔案!!");
		return false;
	}
	var filename = document.form1.UPLOADFILE.value;
	filename = filename.substr(filename.length-4);
	if (filename.toUpperCase() != ".XLS")
	{
		alert('upload excel file must be 2003 format!');
		document.form1.UPLOADFILE.focus();
		return false;	
	}	
    document.form1.submit1.disabled=true;
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:Tahoma,Georgia; font-size:13px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:Tahoma,Georgia; font-size:13px; background-color:#D8E6E7; color:#000000; text-align:left;}
 .style3   {font-family:Tahoma,Georgia; font-size:13px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Tahoma,Georgia; font-size:11px; color: #000000; text-align:center}
 .style7   {font-family:Tahoma,Georgia; font-size:11px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style9   {font-family:Tahoma,Georgia; font-size:11px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style13  {font-family:Tahoma,Georgia; font-size:13px; background-color:#AAAAAA; color:#000000; text-align:left;}
 .style14  {font-family:Tahoma,Georgia; font-size:13px; background-color:#CAE1DC; color:#000000; text-align:center;}
 .style15  {font-family:Tahoma,Georgia; font-size:15px; background-color:#99CC99; color:#000000; text-align:center;}
 .style16  {font-family:Tahoma,Georgia; font-size:11px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style17  {font-family:Tahoma,Georgia; font-size:13px; background-color:#FFFFFF; color:#000000; text-align:LEFT;}
 td {word-break:break-all}
</STYLE>
</head>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<body>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
<p>
<font  style="font-weight:bold;font-family:'Tahoma,Georgia';color:#003399;font-size:24px" >TSC 海外庫存明細上傳</font>
<br>
</p>
<%
String TransType = request.getParameter("TransType");
if (TransType == null) TransType="0";
boolean isException = false;
String pgmName = "D8002_";
int keepVersionNum = 10;
String versionID="",sql ="",SalesArea = "",Item_ID = "",Item_Name = "",Item_Desc = "", IdleQty = "", Date_Code= "",Sales = "",Customer="",Remark="",LotNumber="";
String ErrorMsg = "",ErrData = "";
int SuccCnt = 0;
%>
<table width="75%" bgcolor="#D8E6E7" cellspacing="0" cellpadding="0" bordercolordark="#990000">
 	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#000000" cellpadding="1" width="100%" height="15" align="left">
				<TR>
					<td width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
    							<TD width="10%"  height="70%" class="style13" title="回首頁!">
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#000000">
									<STRONG>回首頁</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>
					<TD width="10%" class="style15">
						<STRONG>資料上傳</STRONG>
					</TD>
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入庫存查詢功能!">
									<A HREF="TSCWorldWideOnhandQuery.jsp" style="text-decoration:none;color:#000000">
									<STRONG>庫存查詢</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>					
					<TD width="10%" bgcolor="#FFFFFF">
						<table>
							<tr>
								<TD width="10%" class="style14" title="請按我進入上傳歷程查詢功能!">
									<A HREF="TSCWorldWideOnhandHistory.jsp" style="text-decoration:none;color:#000000">
									<STRONG>上傳歷程</STRONG>
									</A>
								</TD>
							</tr>
						</table>
					</TD>					
					<!--<TD width="65%" class="style16"><a href="samplefiles/D8-001_User_Guide.doc">Download User Guide</a>&nbsp;</TD>-->
					<TD width="65%" class="style16">&nbsp;</TD>
  				</TR>
			</TABLE>
		</td>
	</tr>
	<tr>
		<td class="style15" height="10"></td>
	</tr>	
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#998811"  cellpadding="1" width="100%" align="left" bordercolorlight="#ffffff" border="1">
			  <tr style="font-family:Tahoma,Georgia;font-size:12px;background-color:#C7DEC8">
				<td colspan="2">請指定上傳檔案：</FONT></td>
			  </tr>
			  <tr>
				<td width="10%" bgcolor="#AAFFAA" class="style17">Upload File：</font></td>
				<td width="90%" class="style17"><INPUT TYPE="FILE" NAME="UPLOADFILE" size="80">
				  <span class="style3">
				  <input type="button" class="style4" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCWorldWideOnhandUpload.jsp?TransType=1')">
				  </span><A HREF="../jsp/samplefiles/D8-001_SampleFile.xls">Download Sample File</A></td>
			  </tr>
			</table>
		</td>
	</tr>
</table>
<%
if (TransType.equals("1"))
{
	try
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();
		if (uploadFile_name == null || uploadFile_name.equals("") )
		{
			out.println("<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的office 2003 excel檔，謝謝!')</script>");
		}
		else
		{
			String CreationDate = (String) (new SimpleDateFormat ("yyyyMMddHHmmss")).format( new java.util.Date());
			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+pgmName+CreationDate +".xls";
			upload_file.saveAs(uploadFilePath); 
			
			//將目前版本改為失效 
			sql = " update oraddman.TSC_WWS_STOCK_HEADER set VERSION_FLAG='I'";
			//out.println(sql);
			PreparedStatement seqstmt=con.prepareStatement(sql);
			seqstmt.executeQuery();
			seqstmt.close();
			
			Statement st = con.createStatement();
			ResultSet rs=st.executeQuery("select nvl(max(VERSION_ID),0)+1 from oraddman.TSC_WWS_STOCK_HEADER ");
			if (rs.next()) 
			{
				versionID = rs.getString(1); 
			}
			else
			{	
				versionID = "1";
			}
			rs.close();
			st.close();
			
			//寫入新版本,狀態為更新中			 
			sql = " insert into oraddman.TSC_WWS_STOCK_HEADER"+
				  " values( ?,'T',?,sysdate,? )";
			seqstmt=con.prepareStatement(sql);
			seqstmt.setString(1,versionID);
			seqstmt.setString(2,UserName);
			seqstmt.setString(3,pgmName+CreationDate +".xls");
			seqstmt.executeQuery();
			seqstmt.close();

			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);

			if (sht.getRows() ==0)
			{
				throw new Exception("上傳失敗!!資料內容不可為空，請確認清楚後再重新上傳，謝謝~~");
			}
			else
			{
				//detail
				for (int i = 3; i <sht.getRows(); i++) 
				{
					//out.println(""+i);
					//業務區域
					jxl.Cell wcSalesArea = sht.getCell(0, i);          
					SalesArea= (wcSalesArea.getContents()).trim();
					if (SalesArea == null) SalesArea = "";

					////ITEM Name
					//jxl.Cell wcItem_Name = sht.getCell(1, i);          
					//Item_Name = (wcItem_Name.getContents()).trim();
					//if (Item_Name  == null) Item_Name = "";
	
					//ITEM Desc
					jxl.Cell wcItem_Desc = sht.getCell(1, i);          
					Item_Desc = (wcItem_Desc.getContents()).trim();
					if (Item_Desc  == null) Item_Desc = "";

					//Slow Moving Qty
					jxl.Cell wcIdleQty = sht.getCell(2, i);  
					IdleQty = (wcIdleQty.getContents()).trim().replace(",","");
					if (IdleQty == null) IdleQty = "0";
					
					//Date Code
					jxl.Cell wcDateCode = sht.getCell(3, i);          
					Date_Code= (wcDateCode.getContents()).trim();
					if (Date_Code  == null) Date_Code = "";	
					Date_Code = Date_Code.replace("'","");

					//Customer
					jxl.Cell wcCustomer = sht.getCell(4, i);          
					Customer = (wcCustomer.getContents()).trim();
					if (Customer  == null) Customer = "";

					//lot number
					jxl.Cell wcLot = sht.getCell(5, i);          
					LotNumber = (wcLot.getContents()).trim();
					if (LotNumber == null) LotNumber = "";
					LotNumber = LotNumber.replace("'","");
					
					//SALES
					jxl.Cell wcSales = sht.getCell(6, i);          
					Sales = (wcSales.getContents()).trim();
					if (Sales  == null) Sales = "";
						
					//Remark
					jxl.Cell wcRemark = sht.getCell(7, i);          
					Remark = (wcRemark.getContents()).trim();
					if (Remark  == null) Remark = "";
												
					//檢查ITEM是否存在
					if (Item_Desc == null || Item_Desc.equals(""))
					{
						ErrorMsg += "TSC Item Desc不可空白<br>";
					}
					else
					{
						Statement st1 = con.createStatement();
						ResultSet rs1=st1.executeQuery("SELECT inventory_item_id,segment1,description from inv.mtl_system_items_b a where organization_id=43 and description='"+Item_Desc+"'");
						if (rs1.next()) 
						{
							Item_ID = rs1.getString("inventory_item_id");
							Item_Name = rs1.getString("segment1"); 
						}
						else
						{	
							Item_ID = "";Item_Name = "";
							ErrorMsg += Item_Desc+"不存在<br>";
						}
						rs1.close();
						st1.close();
					}
					
					//檢查數量格式是否正確
					try
					{
						float qtynum = Float.parseFloat(IdleQty.replace(",",""));
						if ( qtynum <= 0)
						{
							ErrorMsg +="Slow Moving Qty必須大於零<br>";
						}
					}
					catch(Exception e)
					{
						ErrorMsg += "數量格式錯誤<br>";
					}
					
					if (ErrorMsg.length()>0)
					{
						ErrData += "<tr style='font-size:11px;font-family:Tahoma,Georgia'><td>"+i+"</td>";
						ErrData += "<td>"+SalesArea+"</td>";
					    ErrData += "<td>"+Item_Name+"</td>";
						ErrData += "<td>"+Item_Desc+"</td>";
						ErrData += "<td>"+IdleQty+"</td>";
						ErrData += "<td>"+Date_Code+"</td>";
						ErrData += "<td>"+LotNumber+"</td>";
						ErrData += "<td>"+Sales+"</td>";
						ErrData += "<td>"+(Customer.equals("")?"&nbsp;":Customer)+"</td>";
						ErrData += "<td>"+(Remark.equals("")?"&nbsp;":Remark)+"</td>";
						ErrData += "<td style='color:#ff0000'>"+ErrorMsg+"</td></tr>";
						ErrorMsg = "";
					}
					else
					{
						//寫入新版本detail	 
						sql = "insert into oraddman.TSC_WWS_STOCK_DETAIL"+
						   " (VERSION_ID,AREA,INVENTORY_ITEM_ID,ITEM_NAME,ITEM_DESC,DATE_CODE,QTY,SALES,CUSTOMER,REMARKS,SEQ_NO,LOT_NUMBER)"+ 
						   " values(?,?,?,?,?,?,?,?,?,?,?,?)";
						seqstmt=con.prepareStatement(sql);
						seqstmt.setString(1,versionID);
						seqstmt.setString(2,SalesArea);
						seqstmt.setString(3,Item_ID);
						seqstmt.setString(4,Item_Name);
						seqstmt.setString(5,Item_Desc); 
						seqstmt.setString(6,Date_Code); 
						seqstmt.setString(7,IdleQty); 
						seqstmt.setString(8,Sales);  
						seqstmt.setString(9,Customer); 
						seqstmt.setString(10,Remark);  
						//seqstmt.setString(11,Item_Desc);  
						//seqstmt.setString(12,Item_Desc);  
						//seqstmt.setString(13,Item_Desc);  
						//seqstmt.setString(14,Item_Desc);  
						//seqstmt.setString(15,Item_Desc);  
						//seqstmt.setString(16,Item_ID);  
						seqstmt.setString(11,""+(Integer.parseInt(versionID+"0000")+(SuccCnt+1)));  
						seqstmt.setString(12,LotNumber);  
						seqstmt.executeQuery();	
						seqstmt.close();
						SuccCnt ++;
					}
				}
			}

			sql = " update oraddman.TSC_WWS_STOCK_HEADER set version_flag='A' where  version_id ='" + versionID+ "' and version_flag ='T'";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeQuery();
			seqstmt.close();
			
			if (ErrData.length() ==0)
			{
				if (SuccCnt != (sht.getRows()-3))
				{
					throw new Exception("上傳失敗!!成功筆數與資料筆數不符，請洽系統維護人員，謝謝~~");
				}
				else
				{
					con.commit();
				}
			}
			else
			{
				throw new Exception("上傳失敗!!資料錯誤，請修正後再重新上傳，謝謝~~");
			}
			
			//oraddman.TSC_IDLE_STOCK_HEADER只保留前十次交易
			sql = " delete from oraddman.TSC_WWS_STOCK_HEADER b"+
                         " where not exists (select 1 from (SELECT version_id,row_number() over (order by version_id desc) as rownumber"+
                         " FROM oraddman.TSC_WWS_STOCK_HEADER ) a"+
                         " where rownumber <="+keepVersionNum+" and b.version_id = a.version_id)";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeUpdate();
			seqstmt.close();
			
			//oraddman.TSC_IDLE_STOCK_DETAIL只保留前十次交易明細
			sql = " delete from oraddman.TSC_WWS_STOCK_DETAIL b"+
			      " where not exists (select 1 from oraddman.TSC_WWS_STOCK_HEADER a where a.version_id = b.version_id)";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeUpdate();
			seqstmt.close();
		}
		
		out.println("<font color='blue' face='Tahoma,Georgia'>上傳成功!!總筆數：</font><font face='Arial' color='blue'>"+SuccCnt +"  </font>");
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font face='Tahoma,Georgia' color='red'><strong>"+e.getMessage()+"</strong></font>");
		if (ErrData.length() >0)
		{
			out.println("<table cellspacing='0' cellpadding='0' bordercolordark='#99AACC' border='1'>");
			out.println("<tr style='font-size:11px;font-family:Tahoma,Georgia;background-color:#A816A7'>");
			out.println("<td>Seq No</td>");
			out.println("<td>業務區域/td>");
			out.println("<td>台半22碼料號</td>");
			out.println("<td>台半品名</font></td>");
			out.println("<td>數量</td>");
			out.println("<td>Date Code</td>");
			out.println("<td>Lot Number</td>");
			out.println("<td>Sales</td>");
			out.println("<td>Customer</td>");
			out.println("<td>Remark</td>");
			out.println("<td>Error Message</td>");
			out.println("<tr>");
		 	out.println(ErrData);
		    out.println("</table>");
		}
	}
}
%>

<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</html>
