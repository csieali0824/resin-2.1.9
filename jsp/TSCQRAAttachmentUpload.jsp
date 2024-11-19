<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="com.jspsmart.upload.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
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
	if ( (document.SITEFORM.UPLOADFILE1.value ==null || document.SITEFORM.UPLOADFILE1.value==""))
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE1.value!="" &&  (document.SITEFORM.UPLOADFILE1.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件必須為PDF檔案格式!");
		return false;
	}
	document.SITEFORM.upload.disabled=true;
	document.SITEFORM.winclose.disabled=true;	
	document.SITEFORM.action=URL;
	document.SITEFORM.submit();	
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
	String FILEID = request.getParameter("FILEID");
	if (FILEID ==null) FILEID="";
	String ACTION = request.getParameter("ACTION");
	if (ACTION ==null) ACTION="";
%>
<body >  
<FORM METHOD="post" NAME="SITEFORM"  ENCTYPE="multipart/form-data">
<HR>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#C2DEE0"><font style="font-family:Tahoma;font-size:12px">QPCN/QPDN Number:</font></TD>
		<TD><font style="font-family:Tahoma;font-size:12px">&nbsp;<%=FILEID%></font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#C2DEE0"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE1" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../jsp/TSCQRAAttachmentUpload.jsp?ACTION=UPLOAD&FILEID=<%=FILEID%>")'>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="關閉視窗" onClick='setClose();'>
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			if (FILEID.equals("")) throw new Exception("查無FILEID!!");
			out.println("<input type='hidden' name='FILEID' value='"+FILEID+"'>");
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.setMaxFileSize(10 *1024*1024);
			mySmartUpload.upload();
			com.jspsmart.upload.File upload_file = mySmartUpload.getFiles().getFile(0);
			upload_file.saveAs("/jsp/QRA_Attache/"+FILEID+".pdf");
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.MYFORM.action="TSCQRAProductChangeSummary.jsp";
				window.opener.MYFORM.submit();
				window.close();				
			</script>
	<%	
		}			
		catch(Exception e)
		{
			out.println("<font color='red' size='+1'>Exception:"+e.getMessage()+"</font>");
		}
			
	}
%>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
