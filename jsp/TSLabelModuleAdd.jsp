<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
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
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		if (document.MYFORMD.STATUS.value=="NEW")
		{
			window.opener.MYFORM.submit();
		}
		else
		{	
			window.opener.document.getElementById("alpha").style.width="0";
			window.opener.document.getElementById("alpha").style.height="0";
		}
		window.close();				
    }  
} 
function setCancel()
{
	if (document.MYFORMD.STATUS.value=="NEW")
	{
		window.opener.MYFORM.submit();
	}
	else
	{
		window.opener.document.getElementById("alpha").style.width="0";
		window.opener.document.getElementById("alpha").style.height="0";
	}
	self.close();
}
function setSubmit(URL)
{ 
	if (document.MYFORMD.MODULE_CODE.value=="")
	{
		alert("請輸入業務模組代碼!!");
		document.MYFORMD.MODULE_CODE.focus();
		return false;
	}
	if (document.MYFORMD.MODULE_NAME.value=="")
	{
		alert("請選擇業務模組名稱!!");
		document.MYFORMD.MODULE_NAME.focus();
		return false;
	}	
	if (document.MYFORMD.EFFECTIVE_FROM.value !="" &&  document.MYFORMD.EFFECTIVE_TO.value!="" && eval(document.MYFORMD.EFFECTIVE_TO.value)<eval(document.MYFORMD.EFFECTIVE_FROM.value))
	{
		alert("啟用迄日必須大於等於啟用起日!!");
		document.MYFORMD.EFFECTIVE_TO.focus();
		return false;
	}			
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
}
function setClear()
{
	document.MYFORMD.MODULE_CODE.value="";
	document.MYFORMD.MODULE_NAME.value="";
	document.MYFORMD.EFFECTIVE_FROM.value="";
	document.MYFORMD.EFFECTIVE_TO.value="";
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
<title>TS Label Module Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSLabelModuleAdd.jsp" METHOD="POST"> 
<%
String MODULE_CODE = request.getParameter("MODULE_CODE");
if (MODULE_CODE==null) MODULE_CODE="";
String MODULE_NAME = request.getParameter("MODULE_NAME");
if (MODULE_NAME==null) MODULE_NAME="";
String EFFECTIVE_FROM = request.getParameter("EFFECTIVE_FROM");
if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
String EFFECTIVE_TO = request.getParameter("EFFECTIVE_TO");
if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{  
	if (STATUS.equals("UPD"))
	{
		if (ACODE.equals(""))
		{
			sql = " select a.module_code, a.module_name,"+
                  " to_char(a.effective_from_date,'yyyymmdd') effective_from_date, to_char(a.effective_to_date,'yyyymmdd') effective_to_date"+
                  " from oraddman.ts_label_modules a "+
                  " where a.module_code=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,MODULE_CODE);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				MODULE_NAME=rs.getString("module_name");
				EFFECTIVE_FROM=rs.getString("EFFECTIVE_FROM_DATE");
				if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
				EFFECTIVE_TO=rs.getString("EFFECTIVE_TO_DATE");
				if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("查無資料,請重新確認,謝謝!");
					setCancel();
				</script>
			<%				
			}
			rs.close();
			statement.close();
		}
	}

%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<table align="center" width="80%">
	<tr>
		<td align="center">
			<strong><font style="font-family:細明體;font-size:20px;color:#006666">業務模組</font><font style="font-size:20px;color:#006666">維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">業務模組代碼</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="MODULE_CODE" value="<%=MODULE_CODE%>" size="20" style="font-family: Tahoma,Georgia;" <%=(STATUS.equals("UPD")?"readonly":"")%>></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">業務模組名稱</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="MODULE_NAME" value="<%=MODULE_NAME%>" size="30" style="font-family: Tahoma,Georgia;"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">啟用起日</span>：</td>
					<td nowrap><input type="text" name="EFFECTIVE_FROM" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_FROM%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.EFFECTIVE_FROM);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">啟用迄日</span>：</td>
					<td nowrap><input type="text" name="EFFECTIVE_TO" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_TO%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.EFFECTIVE_TO);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A></tr>	
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
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSLabelModuleAdd.jsp?STATUS=<%=STATUS%>&ACODE=SAVE")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick='setCancel()' value="關閉視窗" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		try
		{
			if (STATUS.equals("UPD"))
			{
				sql= " update oraddman.ts_label_modules  "+
				     " set MODULE_NAME=?"+
					 ",EFFECTIVE_FROM_DATE=TO_DATE(?,'yyyymmdd')"+
					 ",EFFECTIVE_TO_DATE=TO_DATE(?,'yyyymmdd')"+
					 ",LAST_UPDATED_BY=?"+
					 ",LAST_UPDATE_DATE=sysdate"+
					 " where MODULE_CODE = ?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,MODULE_NAME);
				st1.setString(2,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
				st1.setString(3,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
				st1.setString(4,UserName);
				st1.setString(5,MODULE_CODE);
				st1.executeUpdate();
				st1.close();
			%>
				<script language = "JavaScript">
					alert('修改成功!');
					window.opener.MYFORM.submit();
					setCancel();
				</script>
			<%				
			}
			else
			{
				sql = " select 1 from oraddman.ts_label_modules a "+
						  " where a.MODULE_CODE=?";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,MODULE_CODE);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{	
					throw new Exception("業務模組已存在,不可重覆!");
				}
				else
				{		
					sql = " insert into oraddman.ts_label_modules"+
						  " (module_code"+
						  ", module_name"+
                          ",effective_from_date"+
						  ",effective_to_date"+
						  ",creation_date"+
                          ",created_by"+
						  ",last_update_date"+
						  ",last_updated_by)"+
						  " values ("+
						  " ?"+
						  ",?"+
						  ",to_date(?,'yyyymmdd')"+
						  ",to_date(?,'yyyymmdd')"+
						  ",sysdate"+
						  ",?"+
						  ",sysdate"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,MODULE_CODE);	
					st1.setString(2,MODULE_NAME);
					st1.setString(3,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
					st1.setString(4,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
					st1.setString(5,UserName); 
					st1.setString(6,UserName); 
					st1.executeUpdate();
					st1.close();
					
					out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
			%>
					<script language="javascript">
						setClear();
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
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>Exception1:"+e.getMessage()+"</DIV>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
