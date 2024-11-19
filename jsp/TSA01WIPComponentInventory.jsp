<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.*"%>
<%@ page import="java.text.*,java.text.DecimalFormat"%>
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
<jsp:useBean id="WIPMISCBean" scope="session" class="Array2DimensionInputBean"/>
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
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String ITEM_NAME="",LOT="",WIPNO="",SubItem="";
double MES_QTY=0,STOCK_QTY=0,MISC_QTY=0;
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int start_row=1,i_code=0;


%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Upload File&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Sample File&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/K2-001_SampleFile.xls"><font face="Tahoma,Georgia" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../jsp/TSA01WIPComponentInventory.jsp?ACTION=UPLOAD")' style="font-family:Tahoma,Georgia">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" onClick='setClose();' style="font-family:Tahoma,Georgia">
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		WIPMISCBean.setArray2DString(null);
		StringBuilder sb = new StringBuilder();
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\K2-001("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			Hashtable hashtb = new Hashtable();
			Hashtable hashtb1 = new Hashtable();
			
			for (int i = start_row ; i <sht.getRows(); i++) 
			{
				//工單
				jxl.Cell wcWIPNO = sht.getCell(0, i);          
				WIPNO = (wcWIPNO.getContents()).trim();
				if (WIPNO  == null) WIPNO = "";
				if (WIPNO.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:工單號不可空白!!");
				}
				
				//半成品
				jxl.Cell wcSubItem = sht.getCell(3, i);  
				SubItem = (wcSubItem.getContents()).trim();
				if (SubItem== null) SubItem = "";
				if (SubItem.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:半成品料號不可空白!!");
				}	
				else
				{
					sql = " select 1 from inv.mtl_system_items_b a where a.organization_id=? and a.inventory_item_status_code<>? and a.segment1=?";
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setInt(1,606);
					statement.setString(2,"Inactive");
					statement.setString(3,SubItem);
					ResultSet rs=statement.executeQuery();
					if (!rs.next())
					{
						throw new Exception("第"+(i+1)+"列:半成品料號不存在(可能停用或未assign I13)!!");
					}
					rs.close();
					statement.close();				
				}
				
				//批號
				jxl.Cell wcLOT = sht.getCell(4, i);  		   
				LOT = (wcLOT.getContents()).trim();
				if (LOT== null) LOT = "";
				if (LOT.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:批號不可空白!!");
				}
				
				//MES數量
				jxl.Cell wcMES_QTY = sht.getCell(5, i);  		   
				if (wcMES_QTY.getType() == CellType.NUMBER) 
				{
					MES_QTY = Double.parseDouble(""+((NumberCell) wcMES_QTY).getValue());
				}
				else
				{
					throw new Exception("第"+(i+1)+"列:MES餘量欄位型態必須是數值!!");
				}
				if (MES_QTY<0)
				{
					throw new Exception("第"+(i+1)+"列:MES餘量必須大於等於0!!");
				}				
				
				//盤點餘料
				jxl.Cell wcSTOCK_QTY = sht.getCell(6, i);  		   
				if (wcSTOCK_QTY.getType() == CellType.NUMBER) 
				{
					STOCK_QTY = Double.parseDouble(""+((NumberCell) wcSTOCK_QTY).getValue());
				}
				else
				{
					throw new Exception("第"+(i+1)+"列:盤點餘料欄位型態必須是數值!!");
				}
				if (STOCK_QTY<0)
				{
					throw new Exception("第"+(i+1)+"列:盤點餘料必須大於等於0!!");
				}
				//MISC_QTY = ((STOCK_QTY*1000000)-(MES_QTY*1000000))/1000000;				
				MISC_QTY = (Math.round((STOCK_QTY*1000000)-(MES_QTY*1000000)));		
				MISC_QTY = MISC_QTY /1000000;		
				String LotA[][]=WIPMISCBean.getArray2DContent();
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
					LotB[LotA.length][0] = WIPNO;
					LotB[LotA.length][1] = SubItem;
					LotB[LotA.length][2] = LOT;
					LotB[LotA.length][3] = ""+MES_QTY;
					LotB[LotA.length][4] = ""+STOCK_QTY;		
					LotB[LotA.length][5] = ""+MISC_QTY;		
					LotB[LotA.length][6] = "N";		
					WIPMISCBean.setArray2DString(LotB);					
				}
				else
				{
					String LotB[][]={{WIPNO,SubItem,""+LOT,""+MES_QTY,""+STOCK_QTY, ""+MISC_QTY,"N"}};
					WIPMISCBean.setArray2DString(LotB); 
				}	
			}
			wb.close();
			session.setAttribute("K2001",hashtb);
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.action="../jsp/TSA01WIPComponentRequest.jsp?ACODE=UPLOAD";
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
