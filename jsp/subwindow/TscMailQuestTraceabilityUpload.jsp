<%@ page contentType="text/html; charset=UTF-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
		window.close();				
    }  
}  

function setUpload(URL)
{
	if ( (document.SITEFORM.UPLOADFILE1.value ==null || document.SITEFORM.UPLOADFILE1.value=="") &&
	     (document.SITEFORM.UPLOADFILE2.value ==null || document.SITEFORM.UPLOADFILE2.value=="") &&
	     (document.SITEFORM.UPLOADFILE3.value ==null || document.SITEFORM.UPLOADFILE3.value=="") &&
	     (document.SITEFORM.UPLOADFILE4.value ==null || document.SITEFORM.UPLOADFILE4.value=="") &&
		 (document.SITEFORM.UPLOADFILE5.value ==null || document.SITEFORM.UPLOADFILE5.value==""))
	{
		alert("Please choose upload file!");
		return false;
	}
	document.SITEFORM.upload.disabled=true;
	document.SITEFORM.winclose.disabled=true;	
	document.SITEFORM.action=URL;
	document.SITEFORM.submit();	
}
function setClose()
{
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
	String str_floder = "CustomerQuestion_Attache";
%>
<body >  
<FORM METHOD="post" NAME="SITEFORM"  ENCTYPE="multipart/form-data">
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'arial';font-size:12px">&nbsp;Attachement1&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE1" size="60" style="font-family:arial"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'arial';font-size:12px">&nbsp;Attachement2&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE2" size="60" style="font-family:arial"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'arial';font-size:12px">&nbsp;Attachement3&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE3" size="60" style="font-family:arial"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'arial';font-size:12px">&nbsp;Attachement4&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE4" size="60"style="font-family:arial"></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'arial';font-size:12px">&nbsp;Attachement5&nbsp;</font></TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE5" size="60" style="font-family:arial"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload" onClick='setUpload("../subwindow/TscMailQuestTraceabilityUpload.jsp?ACTION=UPLOAD&FILEID=<%=FILEID%>")' style="font-family:arial">
		&nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close" onClick='setClose();' style="font-family:arial">
		</TD>
	</TR>
</TABLE>
<BR>
<%
	if (ACTION.equals("UPLOAD"))
	{
		try
		{
			java.io.File file = new java.io.File(application.getRealPath("/jsp/"+str_floder+"/"+FILEID));
			if(!file.exists())
			{
				file.mkdirs(); 
			}
			out.println("<input type='hidden' name='FILEID' value='"+FILEID+"'>");
			
			mySmartUpload.initialize(pageContext); 
			mySmartUpload.setMaxFileSize(10 *1024*1024);
			mySmartUpload.upload();
 			for (int i=0;i < mySmartUpload.getFiles().getCount(); i++)
			{
				com.jspsmart.upload.File upload_file = mySmartUpload.getFiles().getFile(i);
				String uploadFile_name=upload_file.getFileName();
				uploadFile_name = uploadFile_name.toLowerCase().replace(".eml",".mht");
				if (!uploadFile_name.equals(""))
				{
					upload_file.saveAs("/jsp/"+str_floder+"/"+FILEID+"/"+uploadFile_name);
				}
			}
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.form1.submit();
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
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
