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
		window.opener.document.getElementById("alpha").style.width="0px";
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
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();				
}
</script>
<title>Excel Upload</title>
</head>
<%
String QSEQNO = request.getParameter("QSEQNO");
if (QSEQNO==null) QSEQNO="";
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
int start_row=1;
boolean run_job = false;
						
sql = " SELECT 1 FROM user_scheduler_jobs WHERE JOB_NAME = 'PCN JOB:"+QSEQNO+"'";
Statement statement=con.createStatement();
ResultSet rs=statement.executeQuery(sql);
if (rs.next()) 
{	
	run_job =true;	
}
rs.close();
statement.close();

%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;請選擇上檔傳案&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上傳範本&nbsp;</font></TD>
		<TD><A HREF="samplefiles/G1-001_SampleFile.xls"><font face="ARIAL" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<%=(run_job==true?"":"<INPUT TYPE='button' NAME='upload' value='檔案上傳' onClick='setUpload("+'"'+"../jsp/TSCQRAProductChangeUpload.jsp?ACTION=UPLOAD"+'"'+")'>")%>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<div id="div1" align="center" style="color:#ff0000;font-size:11px"><%=(run_job==true?"此PCN目前在進行歷史訂單資料讀取作業，無法上傳，請稍候再作業，謝謝!":"")%></div>
<%
	if (ACTION.equals("UPLOAD"))
	{
		POReceivingBean.setArray2DString(null);
		try
		{
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
			String uploadFile_name=upload_file.getFileName();

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\G1-001("+QSEQNO+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			String ITEMDESC="",PRODGROUP="",TSC_Family="",TSC_Package="",Packing_Code="",TSC_Amp="";
			String arraylist [][] = new String[sht.getRows()-start_row][6];
			
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
				
				//Prod Group
				jxl.Cell wcProdGroup = sht.getCell(1, i);  
				PRODGROUP = (wcProdGroup.getContents()).trim();
				if (PRODGROUP == null) PRODGROUP = "";
				if (PRODGROUP.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Prod Group不可空白!!");
				}	

				//Family
				jxl.Cell wcFamily = sht.getCell(2, i);  
				TSC_Family = (wcFamily.getContents()).trim();
				if (TSC_Family== null) TSC_Family = "";
				//if (TSC_Family.equals(""))
				//{
				//	throw new Exception("第"+(i+1)+"列:Family不可空白!!");
				//}	
				
				//Package
				jxl.Cell wcPackage = sht.getCell(3, i);  
				TSC_Package = (wcPackage.getContents()).trim();
				if (TSC_Package== null) TSC_Package="";
				if (TSC_Package.equals(""))
				{
					throw new Exception("第"+(i+1)+"列:Package不可空白!!");
				}
				
				//Packing Code
				jxl.Cell wcPackingCode = sht.getCell(4, i);  
				Packing_Code = (wcPackingCode.getContents()).trim();
				if (Packing_Code== null) Packing_Code = "";
				//if (Packing_Code.equals(""))
				//{
				//	throw new Exception("第"+(i+1)+"列:Packing Code不可空白!!");
				//}	
				
				//Io(Amp)
				jxl.Cell wcAmp = sht.getCell(5, i);  
				TSC_Amp = (wcAmp.getContents()).trim();
				if (TSC_Amp== null) TSC_Amp = "";
				
				arraylist[i-start_row][0]=ITEMDESC;
				arraylist[i-start_row][1]=PRODGROUP;
				arraylist[i-start_row][2]=TSC_Family;
				arraylist[i-start_row][3]=TSC_Package;
				arraylist[i-start_row][4]=Packing_Code;
				arraylist[i-start_row][5]=TSC_Amp;
				
			}
			wb.close();
			session.setAttribute("G1001TB",arraylist);
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.action="../jsp/TSCQRAProductChangeModify.jsp?QTRANS=U";
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
