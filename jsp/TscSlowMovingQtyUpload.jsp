<%@ page contentType="text/html; charset=utf-8" language="java" %>
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
    document.form1.submit1.disabled=true;
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
<STYLE TYPE='text/css'> 
 .style1   {font-family:標楷體; font-size:14px; background-color:#A9E1E7; color:#000000; text-align:left;}
 .style2   {font-family:標楷體; font-size:14px; background-color:#D8E6E7; color:#000000; text-align:left;}
 .style3   {font-family:標楷體; font-size:14px; background-color:#FFFFFF; color:#000000; text-align:left;}
 .style4   {font-family:Arial; font-size:12px; color: #000000; text-align:center}
 .style7   {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#CC0000; text-align:right;}
 .style9   {font-family:Arial; font-size:12px; background-color:#CCFFFF; color:#000000; text-align:left;}
 .style13  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:left;}
 .style14  {font-family:標楷體; font-size:14px; background-color:#AAAAAA; color:#FFFFFF; text-align:center;}
 .style15  {font-family:標楷體; font-size:16px; background-color:#6699CC; color:#FFFFFF; text-align:center;}
 .style16  {font-family:Arial; font-size:12px; background-color:#FFFFFF; color:#000000; text-align:right;}
 .style17  {font-family:Arial; font-size:14px; background-color:#FFFFFF; color:#000000; text-align:LEFT;}
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
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Slow Moving Stock Upload</strong></font>
<br>
</p>
<%
String TransType = request.getParameter("TransType");
if (TransType == null) TransType="0";
boolean isException = false;
String pgmName = "D8001_";
int keepVersionNum = 10;
String versionID="",sql ="",SalesArea = "",Item_ID = "",Item_Name = "",Item_Desc = "", IdleQty = "", Date_Code= "",Sales = "",Customer="",Remark="",Region="";
String ErrorMsg = "",ErrData = "",DC_REMARKS="";
int SuccCnt = 0;
int rec_cnt=0;
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
									<A HREF="../ORAddsMainMenu.jsp" style="text-decoration:none;color:#FFFFFF">
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
									<A HREF="TscSlowMovingQueryAll.jsp" style="text-decoration:none;color:#FFFFFF">
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
									<A HREF="TscSlowMovingQueryHistory.jsp" style="text-decoration:none;color:#FFFFFF">
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
			  <tr>
				<td colspan="2" bgcolor="#D8E6E7F" class="style1">請指定上傳檔案：</FONT></td>
			  </tr>
			  <tr>
				<td width="10%" bgcolor="#AAFFAA" class="style17">Upload File：</font></td>
				<td width="90%" class="style17"><INPUT TYPE="FILE" NAME="UPLOADFILE" size="80">
				  <span class="style3">
				  <input type="button" class="style4" name="submit1" value='Upload' onClick="setCreate('../jsp/TscSlowMovingQtyUpload.jsp?TransType=1')">
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
			sql = " update oraddman.TSC_IDLE_STOCK_HEADER set VERSION_FLAG='I'";
			//out.println(sql);
			PreparedStatement seqstmt=con.prepareStatement(sql);
			seqstmt.executeQuery();
			seqstmt.close();
			
			Statement st = con.createStatement();
			ResultSet rs=st.executeQuery("select nvl(max(VERSION_ID),0)+1 from oraddman.TSC_IDLE_STOCK_HEADER ");
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
			sql = " insert into oraddman.TSC_IDLE_STOCK_HEADER"+
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
				for (int i = 1; i <sht.getRows(); i++) 
				{
					rec_cnt = i;
					//out.println(""+i);
					//業務區域,add by Peggy 20220303
					jxl.Cell wcRegion = sht.getCell(0, i);          
					Region= (wcRegion.getContents()).trim();
					if (Region == null) Region = "";
										
					//area
					jxl.Cell wcSalesArea = sht.getCell(1, i);          
					SalesArea= (wcSalesArea.getContents()).trim();
					if (SalesArea == null) SalesArea = "";
	
					//ITEM Name
					jxl.Cell wcItem_Name = sht.getCell(2, i);          
					Item_Name = (wcItem_Name.getContents()).trim();
					if (Item_Name  == null) Item_Name = "";
	
					//out.println(Item_Name);
					
					//ITEM Desc
					jxl.Cell wcItem_Desc = sht.getCell(3, i);          
					Item_Desc = (wcItem_Desc.getContents()).trim();
					if (Item_Desc  == null) Item_Desc = "";

					//Slow Moving Qty
					jxl.Cell wcIdleQty = sht.getCell(4, i);  
					IdleQty = (wcIdleQty.getContents()).trim().replace(",","");
					if (IdleQty == null) IdleQty = "0";
					
					//Date Code
					jxl.Cell wcDateCode = sht.getCell(5, i);          
					Date_Code= (wcDateCode.getContents()).trim();
					if (Date_Code  == null) Date_Code = "";	
					
					//SALES
					jxl.Cell wcSales = sht.getCell(6, i);          
					Sales = (wcSales.getContents()).trim();
					if (Sales  == null) Sales = "";
						
					//Customer
					jxl.Cell wcCustomer = sht.getCell(7, i);          
					Customer = (wcCustomer.getContents()).trim();
					if (Customer  == null) Customer = "";

					//out.println(Customer);
					//out.println("xxx");
					
					//Remark
					jxl.Cell wcRemark = sht.getCell(10, i);          
					Remark = (wcRemark.getContents()).trim();
					if (Remark  == null) Remark = "";
												
					//out.println("xxx1");
					//檢查ITEM是否存在
					if (Item_Name == null || Item_Name.equals(""))
					{
						ErrorMsg += "TSC Item Name不可空白<br>";
					}
					else
					{
						//rs=st.executeQuery("SELECT inventory_item_id from inv.mtl_system_items_b a where organization_id=43 and segment1='"+Item_Name+"'");
						st = con.createStatement();
						rs=st.executeQuery("SELECT inventory_item_id,description from inv.mtl_system_items_b a where organization_id=43 and segment1='"+Item_Name+"'");
						if (rs.next()) 
						{
							Item_ID = rs.getString("inventory_item_id"); 
							//add by Peggy 20130628
							if (!Item_Desc.equals(rs.getString("description")))
							{
								Item_ID = "";
								ErrorMsg += "品名不正確<br>";
							}
						}
						else
						{	
							Item_ID = "";
							ErrorMsg += Item_Name+"不存在<br>";
						}
						rs.close();
						st.close();
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
					
					//add by Peggy 20221227
					if (!Date_Code.equals("") && !Item_ID.equals(""))
					{
						sql = "select to_char(D_DATE,'yyyymmdd') D_DATE,CASE WHEN D_DATE IS NOT NULL AND D_DATE >TRUNC(SYSDATE) THEN 1 ELSE 0 END AS EXPIRATION_FLAG  from table(TSC_GET_ITEM_DATE_INFO(?,?)) where D_TYPE=?";
						PreparedStatement statement9 = con.prepareStatement(sql);
						statement9.setString(1,Date_Code);
						statement9.setString(2,Item_Name);
						statement9.setString(3,"VALID");
						ResultSet rs9=statement9.executeQuery();
						if (rs9.next())
						{
							if (rs9.getInt(2)==0)
							{
								DC_REMARKS += "<tr><td><font face='Arial' size='2'>"+i+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+Region+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+SalesArea+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+Item_Name+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+Item_Desc+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+IdleQty+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+Date_Code+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+Sales+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+(Customer.equals("")?"&nbsp;":Customer)+"</font></td>";
								DC_REMARKS += "<td><font face='Arial' size='2'>"+(Remark.equals("")?"&nbsp;":Remark)+"</font></td>";
								DC_REMARKS += "<td><font face='arial' color='blue' size='2'>"+Date_Code+"(Expiration Date:"+rs9.getString(1)+"過期)</font></td></tr>";
							}
						}
						rs9.close();
						statement9.close();						
					}
					
					if (ErrorMsg.length()>0)
					{
						ErrData += "<tr><td><font face='Arial' size='2'>"+i+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+Region+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+SalesArea+"</font></td>";
					    ErrData += "<td><font face='Arial' size='2'>"+Item_Name+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+Item_Desc+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+IdleQty+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+Date_Code+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+Sales+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+(Customer.equals("")?"&nbsp;":Customer)+"</font></td>";
						ErrData += "<td><font face='Arial' size='2'>"+(Remark.equals("")?"&nbsp;":Remark)+"</font></td>";
						ErrData += "<td><font face='標楷體' color='red' size='2'>"+ErrorMsg+"</font></td></tr>";
						ErrorMsg = "";
					}
					else
					{
						//寫入新版本detail	 
						sql = "insert into oraddman.TSC_IDLE_STOCK_DETAIL"+
						   " (VERSION_ID,AREA,INVENTORY_ITEM_ID,ITEM_NAME,ITEM_DESC,DATE_CODE,IDLE_QTY,SALES,CUSTOMER,REMARKS,ITEM_DESC1"+  //add by Peggy 20140124
						   ",SEQ_NO,REGION)"+ //add by Peggy 20140530
						   //" values(?,?,?,?,?,?,?,?,?,?,CASE WHEN INSTR (?, '-') > 0 THEN SUBSTR (?,0,INSTR (?, '-') - 1) ELSE SUBSTR (?,0, LENGTH (?)- LENGTH (apps.tsc_get_item_packing_code (49,?)) - 1) END ,?,?)";
						   " values(?,?,?,?,?,?,?,?,?,?,CASE WHEN INSTR (?, '-') > 0 THEN SUBSTR (?,0,INSTR (?, '-') - 1) ELSE case when substr(?,9,2)='QQ' THEN ? ELSE SUBSTR (?,0, LENGTH (?)- LENGTH (apps.tsc_get_item_packing_code (49,?)) - 1) END END ,?,?)";
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
						seqstmt.setString(11,Item_Desc);  
						seqstmt.setString(12,Item_Desc);  
						seqstmt.setString(13,Item_Desc); 
						seqstmt.setString(14,Item_Name);						
						seqstmt.setString(15,Item_Desc);						 
						seqstmt.setString(16,Item_Desc);  
						seqstmt.setString(17,Item_Desc);  
						seqstmt.setString(18,Item_ID);  
						seqstmt.setString(19,""+(Integer.parseInt(versionID+"0000")+(SuccCnt+1)));  
						seqstmt.setString(20,Region);  
						seqstmt.executeQuery();	
						SuccCnt ++;
					}
				}
			}

			sql = " update oraddman.TSC_IDLE_STOCK_HEADER set version_flag='A' where  version_id ='" + versionID+ "' and version_flag ='T'";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeQuery();
			seqstmt.close();
			
			if (ErrData.length() ==0)
			{
				if (SuccCnt != (sht.getRows()-1))
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
			sql = " delete from oraddman.TSC_IDLE_STOCK_HEADER b"+
                         " where not exists (select 1 from (SELECT version_id,row_number() over (order by version_id desc) as rownumber"+
                         " FROM oraddman.TSC_IDLE_STOCK_HEADER ) a"+
                         " where rownumber <="+keepVersionNum+" and b.version_id = a.version_id)";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeUpdate();
			seqstmt.close();
			
			//oraddman.TSC_IDLE_STOCK_DETAIL只保留前十次交易明細
			sql = " delete from oraddman.TSC_IDLE_STOCK_DETAIL b"+
			      " where not exists (select 1 from oraddman.TSC_IDLE_STOCK_HEADER a where a.version_id = b.version_id)";
			seqstmt=con.prepareStatement(sql);
			seqstmt.executeUpdate();
			seqstmt.close();
			//seqstmt.close();
		}
		
		if (DC_REMARKS.length() >0)
		{
			out.println("<table cellspacing='0' cellpadding='0' bordercolordark='#99AACC' border='1'>");
			out.println("<tr bgcolor='#Aa16A7'>");
			out.println("<td><font face='Arial' color='white' size='2'>Seq No</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>業務區域</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Area</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半22碼料號</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半品名</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>數量</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Date Code</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Sales</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Customer</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Remark</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>有效期提醒</font></td>");
			out.println("<tr>");
		 	out.println(DC_REMARKS);
		    out.println("</table>");		
		}
		out.println("<font color='blue' face='標楷體'>上傳成功!!總筆數：</font><font face='Arial' color='blue'>"+SuccCnt +"  </font>");
	}
	catch(Exception e)
	{
		con.rollback();
		out.println("<font face='標楷體' color='red'><strong>"+e.getMessage()+"cnt:"+rec_cnt+"</strong></font>");
		if (ErrData.length() >0)
		{
			out.println("<table cellspacing='0' cellpadding='0' bordercolordark='#99AACC' border='1'>");
			out.println("<tr bgcolor='#A816A7'>");
			out.println("<td><font face='Arial' color='white' size='2'>Seq No</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>業務區域</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Area</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半22碼料號</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半品名</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>數量</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Date Code</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Sales</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Customer</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Remark</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Error Message</font></td>");
			out.println("<tr>");
		 	out.println(ErrData);
		    out.println("</table>");
		}
		
		if (DC_REMARKS.length() >0)
		{
			out.println("<table cellspacing='0' cellpadding='0' bordercolordark='#99AACC' border='1'>");
			out.println("<tr bgcolor='#Aa16A7'>");
			out.println("<td><font face='Arial' color='white' size='2'>Seq No</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>業務區域</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Area</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半22碼料號</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>台半品名</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>數量</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Date Code</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Sales</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Customer</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>Remark</font></td>");
			out.println("<td><font face='Arial' color='white' size='2'>有效期提醒</font></td>");
			out.println("<tr>");
		 	out.println(DC_REMARKS);
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
