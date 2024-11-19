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
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
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
	if ( (document.SITEFORM.UPLOADFILE1.value ==null || document.SITEFORM.UPLOADFILE1.value=="") &&
	     (document.SITEFORM.UPLOADFILE2.value ==null || document.SITEFORM.UPLOADFILE2.value=="") &&
	     (document.SITEFORM.UPLOADFILE3.value ==null || document.SITEFORM.UPLOADFILE3.value=="") &&
	     (document.SITEFORM.UPLOADFILE4.value ==null || document.SITEFORM.UPLOADFILE4.value=="") &&
		 (document.SITEFORM.UPLOADFILE5.value ==null || document.SITEFORM.UPLOADFILE5.value==""))
	{
		alert("請先按瀏覽鍵選擇上傳的檔案!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE1.value!="" &&  (document.SITEFORM.UPLOADFILE1.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件1必須為PDF檔案格式!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE2.value!="" &&  (document.SITEFORM.UPLOADFILE2.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件2必須為PDF檔案格式!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE3.value!="" &&  (document.SITEFORM.UPLOADFILE3.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件3必須為PDF檔案格式!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE4.value!="" &&  (document.SITEFORM.UPLOADFILE4.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件4必須為PDF檔案格式!");
		return false;
	}
	else if (document.SITEFORM.UPLOADFILE5.value!="" &&  (document.SITEFORM.UPLOADFILE5.value).toLowerCase().indexOf(".pdf") ==-1)
	{
		alert("附件5必須為PDF檔案格式!");
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
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件1&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE1" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件2&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE2" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件3&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE3" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件4&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE4" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC"><font style="font-family:'細明體';font-size:12px">&nbsp;上檔附件5&nbsp;</font></TD>
		<TD><font style="font-family:Arial">&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE5" size="60" class="style3"><font size="-1" color='red' face="Arial, Helvetica, sans-serif">(*.pdf)</font></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="檔案上傳" onClick='setUpload("../subwindow/TSCPMDAttachmentUpload.jsp?ACTION=UPLOAD&FILEID=<%=FILEID%>")'>
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
			if (FILEID.equals(""))
			{
				String sql = " select tsc_pmd_quotation_fileid_s.nextval from dual";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				if (rs.next())
				{
					FILEID = rs.getString(1);
				}
				rs.close();
				statement.close();
			}
			if (FILEID.equals("")) throw new Exception("查無FILEID!!");
			//java.io.File file = new java.io.File("D:/resin-2.1.9/webapps/oradds/jsp/PMD_Attache/"+FILEID); 
			java.io.File file = new java.io.File(application.getRealPath("/jsp/PMD_Attache/"+FILEID));
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
				if (!uploadFile_name.equals(""))
				{
					upload_file.saveAs("/jsp/PMD_Attache/"+FILEID+"/"+uploadFile_name);
				}
			}
	%>
			<script language="JavaScript" type="text/JavaScript">
				window.opener.document.MYFORM.FILEID.value=document.SITEFORM.FILEID.value;
				window.opener.document.MYFORM.txtLine.value="0";
				window.opener.document.MYFORM.submit();
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
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
