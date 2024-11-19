<%@ page contentType="text/html; charset=utf-8" language="java" import="java.io.*,oracle.sql.*,oracle.jdbc.driver.*,java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
	if (document.MYFORM.LABEL_GROUP_CODE.value=="" || document.MYFORM.LABEL_GROUP_NAME.value=="")
	{
		alert("請輸入標籤群組名稱!!");
		document.MYFORM.LABEL_GROUP_NAME.focus();
		return false;
	}
	if (document.MYFORM.LABEL_TYPE_CODE.value=="" || document.MYFORM.LABEL_TYPE_NAME.value=="")
	{
		alert("請輸入標籤種類!");
		document.MYFORM.LABEL_TYPE_NAME.focus();
		return false;
	}	
	if (document.MYFORM.STATUS.value !='UPD')
	{
		if 	(document.MYFORM.LABEL_FILE.value == "")
		{
			alert("請選擇上傳檔案!");
			document.MYFORM.LABEL_FILE.focus();
			return false;		
		}
		var filename = document.MYFORM.LABEL_FILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".LBL")
		{
			alert('上傳檔案必須為標籤檔!');
			document.MYFORM.LABEL_FILE.focus();
			return false;	
		}
	}	
	if (document.MYFORM.EFFECTIVE_FROM.value !="" &&  document.MYFORM.EFFECTIVE_TO.value!="" && eval(document.MYFORM.EFFECTIVE_TO.value)<eval(document.MYFORM.EFFECTIVE_FROM.value))
	{
		alert("啟用迄日必須大於等於啟用起日!!");
		document.MYFORM.EFFECTIVE_TO.focus();
		return false;
	}	
	var LABEL_CODE = document.MYFORM.LABEL_CODE.value;
	var LABEL_GROUP_CODE = document.MYFORM.LABEL_GROUP_CODE.value;
	var LABEL_NAME = document.MYFORM.LABEL_NAME.value;
	var LABEL_TYPE_CODE = document.MYFORM.LABEL_TYPE_CODE.value;
	var EFFECTIVE_FROM = document.MYFORM.EFFECTIVE_FROM.value;
	var EFFECTIVE_TO = document.MYFORM.EFFECTIVE_TO.value;
	var REMARKS = document.MYFORM.REMARKS.value;
	document.MYFORM.btnSubmit.disabled =true;
	document.MYFORM.btnCancel.disabled =true;
	document.MYFORM.action=URL+"&LABEL_CODE="+LABEL_CODE+"&LABEL_GROUP_CODE="+LABEL_GROUP_CODE+"&LABEL_NAME="+LABEL_NAME+"&LABEL_TYPE_CODE="+LABEL_TYPE_CODE+"&EFFECTIVE_FROM="+EFFECTIVE_FROM+"&EFFECTIVE_TO="+EFFECTIVE_TO+"&REMARKS="+REMARKS;
 	document.MYFORM.submit();
}

function setCancel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setClear()
{
	document.MYFORM.LABEL_GROUP_NAME.value="";
	document.MYFORM.LABEL_GROUP_CODE.value="";
	document.MYFORM.LABEL_NAME.value="";
	document.MYFORM.LABEL_TYPE_CODE.value="";
	document.MYFORM.LABEL_TYPE_NAME.value="";
	//document.MYFORM.LABEL_FILE.value="":
	document.MYFORM.EFFECTIVE_FROM.value="";
	document.MYFORM.EFFECTIVE_TO.value="";
}

function subWindowFind(itemid)
{
	if (itemid=="1")
	{
		subWin=window.open("../jsp/subwindow/TSYewLabelGroupInfo.jsp","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	}
	else if (itemid=="2")
	{
		subWin=window.open("../jsp/subwindow/TSYewLabelTypeInfo.jsp","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
	}
}

</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TS YEW Label Maintain</title>
</head>
<body>
<FORM NAME="MYFORM" METHOD="POST" ACTION="TSYewLabelFilesAdd.jsp" ENCTYPE="multipart/form-data" > 
<%
String LABEL_CODE = request.getParameter("LABEL_CODE");
if (LABEL_CODE==null) LABEL_CODE="";
String LABEL_GROUP_CODE = request.getParameter("LABEL_GROUP_CODE");
if (LABEL_GROUP_CODE==null) LABEL_GROUP_CODE="";
String LABEL_GROUP_NAME = request.getParameter("LABEL_GROUP_NAME");
if (LABEL_GROUP_NAME==null) LABEL_GROUP_NAME="";
String LABEL_NAME = request.getParameter("LABEL_NAME");
if (LABEL_NAME==null) LABEL_NAME="";
String LABEL_TYPE_CODE = request.getParameter("LABEL_TYPE_CODE");
if (LABEL_TYPE_CODE==null) LABEL_TYPE_CODE="";
String LABEL_TYPE_NAME = request.getParameter("LABEL_TYPE_NAME");
if (LABEL_TYPE_NAME==null) LABEL_TYPE_NAME="";
String EFFECTIVE_FROM = request.getParameter("EFFECTIVE_FROM");
if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
String EFFECTIVE_TO =request.getParameter("EFFECTIVE_TO");
if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String SHIPPING_MARK= request.getParameter("SHIPPING_MARK"); 
if (SHIPPING_MARK==null) SHIPPING_MARK="";
String REMARKS= request.getParameter("REMARKS");  
if (REMARKS==null) REMARKS="";
String sql ="",strExist="",strNoFound="", uploadFilePath="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{  
	if (STATUS.equals("UPD"))
	{
		sql = " select a.label_code, a.label_name, a.label_file, a.label_group_code,a.label_type_code,"+
			  " b.label_group_name,b.label_group_desc,c.label_type_name,"+
			  " to_char(a.effective_from_date,'yyyymmdd') effective_from_date, to_char(a.effective_to_date,'yyyymmdd') effective_to_date"+
			  ",a.SHIPPING_MARK,a.remarks"+ 
			  " from oraddman.tsyew_label_all a,oraddman.tsyew_label_groups b,oraddman.tsyew_label_types c "+
			  " where a.label_group_code=b.label_group_code"+
			  " and a.label_type_code=c.label_type_code"+
			  " AND a.label_code=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,LABEL_CODE);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			LABEL_GROUP_CODE =rs.getString("LABEL_GROUP_CODE");
			LABEL_GROUP_NAME =rs.getString("LABEL_GROUP_NAME");
			LABEL_TYPE_CODE = rs.getString("LABEL_TYPE_CODE");
			LABEL_TYPE_NAME = rs.getString("LABEL_TYPE_NAME");
			EFFECTIVE_FROM=rs.getString("EFFECTIVE_FROM_DATE");
			if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
			EFFECTIVE_TO=rs.getString("EFFECTIVE_TO_DATE");
			if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
			LABEL_NAME = rs.getString("LABEL_NAME");
			SHIPPING_MARK=rs.getString("SHIPPING_MARK");
			if (SHIPPING_MARK==null) SHIPPING_MARK="";
			REMARKS=rs.getString("REMARKS");
			if (REMARKS==null) REMARKS="";
		}
		else
		{
		%>
			<script language="JavaScript" type="text/JavaScript">
				alert("查無資料,請重新確認,謝謝!");
			</script>
		<%				
		}
		rs.close();
		statement.close();
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
}
%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<table width="100%">
	<tr>
	<td width="20%"></td>
	<td width="60%">
	
<table align="center" width="100%">
	<tr>
		<td align="center">
			<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤檔設定</font><font style="font-size:20px;color:#006666"></font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">群組名稱</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_GROUP_NAME" value="<%=LABEL_GROUP_NAME%>" size="50" style="font-family: Tahoma,Georgia;" onKeyPress="return (event.keyCode==8 || event.keyCode ==127)"><INPUT TYPE="button" name="btn1" value=".." style="font-family:Tahoma,Georgia" onClick="subWindowFind('1')"><INPUT TYPE="hidden" name="LABEL_GROUP_CODE" value="<%=LABEL_GROUP_CODE%>"></td>
				</tr>
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤種類</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_TYPE_NAME" value="<%=LABEL_TYPE_NAME%>" size="30" style="font-family: Tahoma,Georgia;" onKeyPress="return (event.keyCode==8 || event.keyCode ==127)"><INPUT TYPE="button" name="btn2" value=".." style="font-family:Tahoma,Georgia" onClick="subWindowFind('2')"><INPUT TYPE="hidden" name="LABEL_TYPE_CODE" value="<%=LABEL_TYPE_CODE%>"></td>
				</tr>
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤代碼</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" NAME="LABEL_CODE" value="<%=LABEL_CODE%>" size="20" style="font-family:Tahoma,Georgia;font-size:12px" readonly></td>
				</tr>							
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤檔</span>：</td>
					<td nowrap><INPUT TYPE="FILE" NAME="LABEL_FILE" size="100" style="font-family:Tahoma,Georgia;font-size:12px"></td>
				</tr>							
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤說明</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_NAME" value="<%=LABEL_NAME%>" size="60" style="font-family: Tahoma,Georgia;"></td>
				</tr>	
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">備註</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="REMARKS" value="<%=REMARKS%>" size="60" style="font-family: Tahoma,Georgia;"></td>
				</tr>	
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">啟用起日</span>：</td>
					<td nowrap><input type="text" name="EFFECTIVE_FROM" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_FROM%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EFFECTIVE_FROM);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					</td>
				</tr>	
				<tr>
					<td width="20%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">啟用迄日</span>：</td>
					<td nowrap><input type="text" name="EFFECTIVE_TO" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_TO%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.EFFECTIVE_TO);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSYewLabelFilesProcess.jsp?STATUS=<%=STATUS%>")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick='setCancel("../jsp/TSYewLabelFilesQuery.jsp")' value="回上頁" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
	</td>
	<td width="20%"></td>
	</tr>
</table>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
