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
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		setCloseWindow();
    }  
}  

function setUpload(URL)
{
	if (document.SUBFORM.UPLOADFILE.value ==null || document.SUBFORM.UPLOADFILE.value=="")
	{
		alert("Please choose upload file!");
		return false;
	}
	else
	{
		var filename = document.SUBFORM.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('upload excel file must be 2003 format!');
			document.SUBFORM.UPLOADFILE.focus();
			return false;	
		}
	}
	document.SUBFORM.upload.disabled=true;
	document.SUBFORM.winclose.disabled=true;	
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}
function setCloseWindow()
{
	setClose();
	window.opener.document.MYFORM.submit();
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
function setSubmit3(jobid)
{   
	document.SUBFORM.action="../jsp/TSCSGItemSafetyStockReqNotice.jsp?JOB_ID="+jobid;
 	document.SUBFORM.submit(); 
}
</script>
<title>Excel Upload</title>
</head>
<%
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",job_id="";
int sheetRows=0,sheetCols=9,i=0,j=0,irow=0;
String strarray[]=new String [sheetCols];
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<!--<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Sales Group</TD>
		<TD>&nbsp;<strong></strong></TD>
	</TR>-->
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Download Sample File </TD>
		<TD><A HREF="../jsp/samplefiles/H11-003_SampleFile.xls" style="font-family:Tahoma,Georgia;font-size:12px">Download Sample File</A></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCSGItemSafetyStockUpload.jsp?ACTION=UPLOAD")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
try
{
	if (ACTION.equals("UPLOAD"))
	{
		mySmartUpload.initialize(pageContext); 
		mySmartUpload.upload();
		com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
		String uploadFile_name=upload_file.getFileName();

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\H11-003("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		//out.println("sheetRows="+sheetRows);
								
		for (i = 1 ; i <=sheetRows; i++) 
		{
			for (j = 0 ; j < sheetCols ; j++)
			{
				jxl.Cell strCell= sht.getCell(j, i);
				vStr = (strCell.getContents()).trim();
				strarray[j]=vStr;
			}
			
			if (i==1)
			{
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery("select apps.SG_SAFETY_JOB_ID_S.nextval from dual");
				if (!rs.next())
				{
					throw new Exception("ID not Found!!");
				}
				else
				{
					job_id = rs.getString(1);
				}
				rs.close();
				statement.close();				
			}
			
			sql = " insert into oraddman.TSSG_ITEM_SAFETY_STOCK_REQUEST "+
			      "(JOB_ID"+
				  ",SAFETY_SEQ_ID"+
				  ",ORGANIZATION_CODE"+
				  ",C_MONTH"+
				  ",INVENTORY_ITEM_ID"+
				  ",ITEM_NAME"+
				  ",ITEM_DESC"+
				  ",SUGGEST_SAFETY_STOCK"+
				  ",CREATION_DATE"+
				  ",CREATED_BY"+
				  ",LAST_UPDATE_DATE"+
				  ",LAST_UPDATED_BY"+
				  ")"+
				  " values"+
				  " ("+
				  " ?"+
				  ",SG_SAFETY_SEQ_ID_S.nextval"+
				  ",?"+
				  ",?"+
				  ",(select inventory_item_id from inv.mtl_system_items_b where segment1=? and organization_id=43)"+
				  ",?"+
				  ",?"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  ",sysdate"+
				  ",?"+
				  " )";
			//out.println(sql);
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,job_id);
			pstmtDt.setString(2,strarray[0]);
			pstmtDt.setString(3,strarray[1]);
			pstmtDt.setString(4,strarray[4]);
			pstmtDt.setString(5,strarray[4]);
			pstmtDt.setString(6,strarray[5]);
			pstmtDt.setString(7,strarray[8]);
			pstmtDt.setString(8,UserName);
			pstmtDt.setString(9,UserName);
			pstmtDt.executeQuery();
			pstmtDt.close();				  
		}

		//add by Peggy 20201230
		sql = " insert into oraddman.tssg_forecast_item_temp "+
		      " SELECT ?,?,ITEM_NAME,CREATED_BY,CREATION_DATE,?"+
			  " FROM oraddman.tssg_item_safety_stock_request a"+
			  " WHERE JOB_ID=?"+
			  " AND NOT EXISTS (SELECT 1 FROM oraddman.tssg_forecast_item_temp b WHERE b.ITEM_NAME =a.ITEM_NAME)";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setInt(1,908);
		pstmtDt.setString(2,"SG2");
		pstmtDt.setString(3,"Forecast PO");
		pstmtDt.setString(4,job_id);
		pstmtDt.executeQuery();
		pstmtDt.close();	
			
		//add by Peggy 20201230
		sql = " insert into oraddman.tssg_forecast_item_history"+
			  " SELECT a.organization_id, a.organization_code, a.item_name,"+
			  " a.created_by, a.creation_date, a.created_by,a.creation_date"+
			  " FROM oraddman.tssg_forecast_item_temp a"+
			  " where not exists (select 1 from oraddman.tssg_forecast_item_history x"+
			  "               where x.organization_id=a.organization_id"+
			  "                and x.item_name=a.item_name)";
		pstmtDt=con.prepareStatement(sql);  
		pstmtDt.executeQuery();
		pstmtDt.close();
		
		CallableStatement cs1 = con.prepareCall("{call tssg_inv_pkg.item_update_job(?)}");
		cs1.setString(1,UserName); 	
		cs1.execute();
		cs1.close();			
		con.commit();
		
		wb.close();
		
		out.println("<script language='JavaScript' type='text/JavaScript'>");
		out.println("setSubmit3("+job_id+");");
		out.println("window.opener.document.MYFORM.submit();");
		out.println("setClose();");
		out.println("</script>");
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Upload Fail!!Cause..<br>Record#"+i+":"+e.getMessage()+"</div>");
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
