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
</script>
<title>Excel Upload</title>
</head>
<%
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String ACTION = request.getParameter("ACTION");
if (ACTION==null) ACTION="";
String sql ="";
String strDate=dateBean.getYearMonthDay();
String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();   
String vStr="",temp_id="",v_no="",v_partno="",sid="",skey="";
int sheetRows=0,i=0,j=0,irow=0,error=0;
Hashtable hashtb = new Hashtable();
%>
<body >  
<FORM METHOD="post" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<div>Notice:upload excel file must be 2003 format!!</div>
<TABLE width="100%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD height="29" width="20%" align="center" bgcolor="#FFFFCC">Upload File </TD>
		<TD>&nbsp;<INPUT TYPE="FILE" NAME="UPLOADFILE" size="60" style="font-family:Tahoma,Georgia;font-size:12px"></TD>
	</TR>
	<TR>
		<TD colspan="2" align="center">
		<INPUT TYPE="button" NAME="upload" value="Upload File"  style="font-family:Tahoma,Georgia" onClick='setUpload("../jsp/TSCQRAPartNoListUpload.jsp?ACTION=UPLOAD&QNO=<%=QNO%>")'>
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

		String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\G1-003("+UserName+")"+strDateTime+".xls";
		upload_file.saveAs(uploadFilePath); 
		InputStream is = new FileInputStream(uploadFilePath); 			
		jxl.Workbook wb = Workbook.getWorkbook(is);  
		jxl.Sheet sht = wb.getSheet(0);
		sheetRows=sht.getRows()-1;
		boolean isExist=false;
		
		jxl.Cell strNo = sht.getCell(0,4);
		v_no = (strNo.getContents()).trim();
		if (v_no.indexOf("_")>=0)
		{
			v_no = v_no.substring(0,v_no.indexOf("_"));
		}
		if (!QNO.equals(v_no))
		{
			throw new Exception("上傳檔案裡的PCN/PDN號碼("+v_no+")與指定號碼("+QNO+")不符!!");
		}
		jxl.Cell strCell=null,strPartCell=null;
		sql = " SELECT a.seqid, a.tsc_part_no  FROM oraddman.tsqra_pcn_item_detail a"+
			  " where PCN_NUMBER='"+QNO+"'"+
			  " AND SOURCE_TYPE='2'";
		Statement statement=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
		ResultSet rs = statement.executeQuery(sql);		
								
		for (i = 6 ; i <=sheetRows; i++) 
		{
			if ((((sht.getCell(1, i)).getContents()).trim()).startsWith("***")||(((sht.getCell(1, i)).getContents()).trim()).equals(""))
			{
				continue;
			}
			strPartCell= sht.getCell(2,i);
			v_partno = (strPartCell.getContents()).trim();
			strCell= sht.getCell(3,i);
			vStr = (strCell.getContents()).trim();
			isExist=false;
			
			if (rs.isBeforeFirst() ==false) rs.beforeFirst();
			while (rs.next())
			{
				if (rs.getString("tsc_part_no").equals(v_partno))
				{
					sid=rs.getString("seqid");
					isExist=true;
					break;
				}
			}
				
			if (!isExist)
			{				
				if (error==0)
				{
					out.println("<div style='color:#FF0000;font-size:12px'>The following items can not be found in "+QNO+"</div><br>");
					out.println("<div style='color:#FF0000;font-size:12px'>===============================================</div><br>");
				}
				out.println("<font style='color:#ff0000'>"+v_partno+"</font><br>");
				error++;
			}
			else
			{
				hashtb.put(sid,vStr);
			}
		}
		rs.close();
		statement.close();
		wb.close();
		
		if (error ==0)
		{
			Enumeration enkey  = hashtb.keys(); 
			while (enkey.hasMoreElements())   
			{
				skey=""+(enkey.nextElement());
				sql = " update oraddman.tsqra_pcn_item_detail"+
					   " set REPLACE_PART_NO=?"+
					   " ,REPLACE_PART_NO_UPLOAD_BY=?"+
					   " ,REPLACE_PART_NO_UPLOAD_DATE=sysdate"+
					   " where PCN_NUMBER=?"+
					   " and SEQID=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,""+(hashtb.get(skey)));
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,QNO);
				pstmtDt.setString(4,skey);
				pstmtDt.executeQuery();
				pstmtDt.close();			
			}
			
			//add by Peggy 20181025,cust p/n list也要update
			sql = " UPDATE oraddman.tsqra_pcn_item_detail y"+
                  " SET ( REPLACE_PART_NO,REPLACE_PART_NO_UPLOAD_BY,REPLACE_PART_NO_UPLOAD_DATE) = (SELECT distinct x.REPLACE_PART_NO,x.REPLACE_PART_NO_UPLOAD_BY,x.REPLACE_PART_NO_UPLOAD_DATE FROM oraddman.tsqra_pcn_item_detail x"+
                  " WHERE x.PCN_NUMBER=y.PCN_NUMBER "+
				  " AND x.TSC_PART_NO=y.TSC_PART_NO "+
				  " AND x.REPLACE_PART_NO IS NOT NULL"+
                  " AND x.SOURCE_TYPE=?)"+
                  " WHERE y.PCN_NUMBER=?"+
                  " AND y.SOURCE_TYPE=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"2");
			pstmtDt.setString(2,QNO);
			pstmtDt.setString(3,"1");
			pstmtDt.executeQuery();
			pstmtDt.close();				  

			con.commit();

			out.println("<script language='JavaScript' type='text/JavaScript'>");
			out.println("window.opener.document.MYFORM.action="+'"'+"../jsp/TSCQRAPartNoListQuery.jsp?QNO="+QNO+"&QUERYTYPE=2"+'"'+";");
			out.println("window.opener.document.MYFORM.submit();");
			out.println("setClose();");
			out.println("</script>");
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div>Error!!"+e.getMessage()+"</div>");
}
%>
<!--%表單參數%-->
<input type="hidden" name="QNO" value="<%=QNO%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
