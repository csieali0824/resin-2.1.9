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
String SONO="",SalesGroup="",LineNo="",ItemDesc="",strErr="";
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
					<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../jsp/TSCSGAbroadOpenOrderUpload.jsp?ACTION=UPLOAD")' style="font-family:Tahoma,Georgia">
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

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H18-002("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			String arrylist [][] = new String[sht.getRows()-1][4];

									
			for (int i = 1 ; i <sht.getRows(); i++) 
			{
				SONO="";SalesGroup="";LineNo="";ItemDesc="";strErr="";
				rec_cnt=0;
				
				//SO_NO
				jxl.Cell wcSONO = sht.getCell(0, i);          
				SONO = (wcSONO.getContents()).trim();
				//out.println("SONO="+SONO);
							
				//SALES_GROUP
				jxl.Cell wcSalesGroup = sht.getCell(1, i);          
				SalesGroup = (wcSalesGroup.getContents()).trim();
				
				//LINE_NO
				jxl.Cell wcLineNO = sht.getCell(2, i);          
				LineNo = (wcLineNO.getContents()).trim();
				
				//ITEM_DESC
				jxl.Cell wcItemDesc = sht.getCell(3, i);          
				ItemDesc = (wcItemDesc.getContents()).trim();

				arrylist[i-1][0]=SONO;
				arrylist[i-1][1]=SalesGroup;
				arrylist[i-1][2]=LineNo;
				arrylist[i-1][3]=ItemDesc;
				
				//out.println(SONO);
			}
			wb.close();
			
			//truncate table TSSG_ABROAD_OPEN_ORDER
			sql = " truncate table oraddman.TSSG_ABROAD_OPEN_ORDER";
			PreparedStatement pstmtDt1=con.prepareStatement(sql);  
			pstmtDt1.executeUpdate();
			pstmtDt1.close();	
			
			for (int j =0 ; j < arrylist.length ; j++)
			{
				sql = " insert into oraddman.TSSG_ABROAD_OPEN_ORDER(SO_NO,SALES_GROUP,LINE_NO,ITEM_DESC,ERP_MO_HEADER_ID,ERP_MO_LINE_ID,CREATION_DATE,ERR_MSG,UPDATED_FLAG)"+
					   " values(?"+
					   ",?"+
					   ",?"+
					   ",?"+
					   ",null"+
					   ",null"+
					   ",sysdate"+
					   ",null"+
					   ",null)";
				//out.println(sql);
				pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,arrylist[j][0]);
				pstmtDt1.setString(2,arrylist[j][1]);
				pstmtDt1.setString(3,arrylist[j][2]);
				pstmtDt1.setString(4,arrylist[j][3]);
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
				//CallableStatement cs2 = con.prepareCall("{call TSSG_ORDER_PKG.ABROAD_IMPORT_JOB}");
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
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
