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
String sql ="",ItemName="",OrgName="",OrgID="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="25%" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Please choose source file&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:ARIAL;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="25" align="center" bgcolor="#FFFFCC"><font style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;Download Sample File&nbsp;</font></TD>
		<TD><A HREF="../jsp/samplefiles/H14-003_SampleFile.xls"><font face="Tahoma,Georgia" size="-1">Download Sample File</font></A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../jsp/TSCSGShippingWaybillNumber.jsp?ACTION=UPLOAD")' style="font-family:Tahoma,Georgia">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" onClick='setClose();' style="font-family:Tahoma,Georgia">
		</TD>
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

			String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H14-003("+UserName+")"+strDateTime+".xls";
			upload_file.saveAs(uploadFilePath); 
			InputStream is = new FileInputStream(uploadFilePath); 			
			jxl.Workbook wb = Workbook.getWorkbook(is);  
			jxl.Sheet sht = wb.getSheet(0);
			PreparedStatement statement9 =null;
			ResultSet rs9=null;
			String arrylist [][] = new String[sht.getRows()-1][2];
			String strInvoice="",strWaybill="";
			
			for (int i = 1 ; i <sht.getRows(); i++) 
			{
				//invoice number
				jxl.Cell wcInvoice = sht.getCell(0, i);          
				strInvoice = (wcInvoice.getContents()).trim();
				if (strInvoice  == null) strInvoice= "";
				if (strInvoice.equals(""))
				{
					throw new Exception("Row#"+(i+1)+":Invoice Number must be input!!");
				}
				else
				{
					sql = " select 1 from tsc.tsc_advise_dn_line_int a"+
					      " where delivery_name=?"+
					      " and exists (select 1 from tsc.tsc_advise_dn_header_int b"+
					      "             where b.status='S'"+
					      "             and b.advise_header_id=a.advise_header_id"+
					      "             and b.batch_id=a.batch_id) ";
					statement9 = con.prepareStatement(sql);
					statement9.setString(1,strInvoice);
					rs9=statement9.executeQuery();
					if (!rs9.next())
					{
						throw new Exception("Row#"+(i+1)+":"+strInvoice+" not found");
					}
					rs9.close();
					statement9.close();
				
				}
											
				//運單號碼
				jxl.Cell wcWaybill = sht.getCell(1, i);          
				strWaybill = (wcWaybill.getContents()).trim();
				if (strWaybill  == null) strWaybill = "";
				if (strWaybill.equals(""))
				{
					throw new Exception("Row#"+(i+1)+":Waybill Number must be input!!");
				}

				arrylist[i-1][0]=strInvoice;
				arrylist[i-1][1]=strWaybill;
			}
			wb.close();
			
			for (int j =0 ; j < arrylist.length ; j++)
			{
				sql = " update tsc.tsc_advise_dn_line_int a"+
				      " set sg_delivery_no=?"+
					  ",sg_updated_by=?"+
					  ",sg_update_date=sysdate"+
					  " where delivery_name=?"+
					  " and exists (select 1 from tsc.tsc_advise_dn_header_int b"+
					  "             where b.status='S'"+
					  "             and b.advise_header_id=a.advise_header_id"+
					  "             and b.batch_id=a.batch_id)";
				PreparedStatement pstmtDt1=con.prepareStatement(sql);  
				pstmtDt1.setString(1,arrylist[j][1]);
				pstmtDt1.setString(2,UserName);
				pstmtDt1.setString(3,arrylist[j][0]);
				pstmtDt1.executeQuery();
				pstmtDt1.close();	
			}
			con.commit();
			
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.submit();
				setClose();		
			</script>
	<%				
			
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
