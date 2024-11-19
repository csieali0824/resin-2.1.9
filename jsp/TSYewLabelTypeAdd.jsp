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
	//if (document.MYFORMD.LABEL_TYPE_CODE.value=="")
	//{
	//	alert("請輸入標籤種類代碼!!");
	//	document.MYFORMD.LABEL_TYPE_CODE.focus();
	//	return false;
	//}
	if (document.MYFORMD.LABEL_TYPE_NAME.value=="")
	{
		alert("請選擇標籤種類名稱!!");
		document.MYFORMD.LABEL_TYPE_NAME.focus();
		return false;
	}
	if (document.MYFORMD.PRINT_NUM.value=="")
	{
		alert("請輸入預設列印張數!!");
		document.MYFORMD.PRINT_NUM.focus();
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
	document.MYFORMD.LABEL_TYPE_CODE.value="";
	document.MYFORMD.LABEL_TYPE_NAME.value="";
	document.MYFORMD.LABEL_TYPE_DESC.value="";
	document.MYFORMD.LABEL_SIZE.value="";
	document.MYFORMD.PARENT_LABEL_TYPE_CODE.value="";
	document.MYFORMD.PRINT_NUM="";
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
.style2 {
	font-size: 12px;
	color: #006666;
}
</STYLE>
<title>TS Label Type Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSYewLabelTypeAdd.jsp" METHOD="POST"> 
<%
String LABEL_TYPE_CODE = request.getParameter("LABEL_TYPE_CODE");
if (LABEL_TYPE_CODE==null) LABEL_TYPE_CODE="";
String LABEL_TYPE_NAME = request.getParameter("LABEL_TYPE_NAME");
if (LABEL_TYPE_NAME==null) LABEL_TYPE_NAME="";
String LABEL_TYPE_DESC = request.getParameter("LABEL_TYPE_DESC");
if (LABEL_TYPE_DESC==null) LABEL_TYPE_DESC="";
String LABEL_SIZE = request.getParameter("LABEL_SIZE");
if (LABEL_SIZE==null) LABEL_SIZE="";
String LABEL_TYPE = request.getParameter("LABEL_TYPE");
if (LABEL_TYPE==null || LABEL_TYPE.equals("--")) LABEL_TYPE="";
String PRINT_NUM = request.getParameter("PRINT_NUM");
if (PRINT_NUM==null) PRINT_NUM="";
String EFFECTIVE_FROM = request.getParameter("EFFECTIVE_FROM");
if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
String EFFECTIVE_TO = request.getParameter("EFFECTIVE_TO");
if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="",s_res = "",v_reel="REEL",v_box="BOX",v_carton="CARTON";

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
			sql = " select a.LABEL_TYPE_NAME, a.DESCRIPTION,a.PRINT_NUM,a.LABEL_TYPE,a.LABEL_SIZE,"+
                  " to_char(a.effective_from_date,'yyyymmdd') effective_from_date, to_char(a.effective_to_date,'yyyymmdd') effective_to_date"+
                  " from oraddman.tsyew_label_types a "+
                  " where a.LABEL_TYPE_CODE=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,LABEL_TYPE_CODE);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				LABEL_TYPE_NAME=rs.getString("LABEL_TYPE_NAME");
				LABEL_TYPE_DESC=rs.getString("DESCRIPTION");
				LABEL_SIZE=rs.getString("LABEL_SIZE");
				if (LABEL_SIZE==null) LABEL_SIZE="";
				LABEL_TYPE=rs.getString("LABEL_TYPE");
				if (LABEL_TYPE==null) LABEL_TYPE="";
				PRINT_NUM=rs.getString("PRINT_NUM");
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
	
	if (ACODE.equals("SAVE"))
	{
		try
		{
			if (STATUS.equals("UPD"))
			{
				sql= " update oraddman.tsyew_label_types "+
				     " set LABEL_TYPE_NAME=?"+
					 ",DESCRIPTION=?"+
					 ",PRINT_NUM=?"+
					 ",LABEL_SIZE=?"+
					 ",LABEL_TYPE=?"+
					 ",EFFECTIVE_FROM_DATE=TO_DATE(?,'yyyymmdd')"+
					 ",EFFECTIVE_TO_DATE=TO_DATE(?,'yyyymmdd')"+
					 ",LAST_UPDATED_BY=?"+
					 ",LAST_UPDATE_DATE=sysdate"+
					 " where LABEL_TYPE_CODE = ?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,LABEL_TYPE_NAME);
				st1.setString(2,LABEL_TYPE_DESC);
				st1.setString(3,PRINT_NUM);
				st1.setString(4,LABEL_SIZE);
				st1.setString(5,LABEL_TYPE);
				st1.setString(6,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
				st1.setString(7,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
				st1.setString(8,UserName);
				st1.setString(9,LABEL_TYPE_CODE);
				st1.executeUpdate();
				st1.close();
				s_res ="1";
			
			}
			else
			{
				sql = " select lpad(nvl(max(SUBSTR(LABEL_TYPE_CODE,-3)),0)+1,3,'0') from oraddman.tsyew_label_types a ";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					LABEL_TYPE_CODE = "Y"+rs.getString(1);
				}
				rs.close();
				statement.close();
				
				sql = " insert into oraddman.tsyew_label_types"+
					  " (LABEL_TYPE_CODE"+
					  ",LABEL_TYPE_NAME"+
					  ",DESCRIPTION"+
					  ",PRINT_NUM"+
					  ",LABEL_SIZE"+
					  ",LABEL_TYPE"+
					  ",effective_from_date"+
					  ",effective_to_date"+
					  ",creation_date"+
					  ",created_by"+
					  ",last_update_date"+
					  ",last_updated_by)"+
					  " values ("+
					  " ?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",to_date(?,'yyyymmdd')"+
					  ",to_date(?,'yyyymmdd')"+
					  ",sysdate"+
					  ",?"+
					  ",sysdate"+
					  ",?)";
				//out.println(sql);
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,LABEL_TYPE_CODE);	
				st1.setString(2,LABEL_TYPE_NAME);
				st1.setString(3,LABEL_TYPE_NAME);
				st1.setString(4,PRINT_NUM);
				st1.setString(5,LABEL_SIZE);
				st1.setString(6,LABEL_TYPE);
				st1.setString(7,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
				st1.setString(8,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
				st1.setString(9,UserName); 
				st1.setString(10,UserName); 
				st1.executeUpdate();
				st1.close();
				s_res ="2";
			}
		}
		catch(Exception e)
		{
			out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
		}
	}

%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<table align="center" width="80%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">標籤種類維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤種類名稱</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_TYPE_NAME" value="<%=LABEL_TYPE_NAME%>" size="30" style="font-family: Tahoma,Georgia;"><INPUT TYPE="hidden" name="LABEL_TYPE_CODE" value="<%=LABEL_TYPE_CODE%>"></td>
				</tr>
				<tr>
					<td width="35%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤種類說明</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_TYPE_DESC" value="<%=LABEL_TYPE_DESC%>" size="30" style="font-family: Tahoma,Georgia;"></td>
				</tr>	
				<tr>
					<td width="35%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤尺寸(<span class="style2">mm</span>)</span>：</td>
				  <td nowrap><INPUT TYPE="TEXT" name="LABEL_SIZE" value="<%=LABEL_SIZE%>" size="30" style="font-family: Tahoma,Georgia;"></td>
				</tr>	
				<tr>
					<td width="35%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">材積種類：</span></td>
					<td nowrap><select NAME="LABEL_TYPE" style="font-family:Tahoma,Georgia; font-size: 12px ">
					<OPTION VALUE=-- <%if (LABEL_TYPE.equals("")) out.println("selected");%>>--</OPTION>
					<OPTION VALUE="<%=v_reel%>" <%if (LABEL_TYPE.equals(v_reel)) out.println("selected");%>><%=v_reel%></OPTION>
					<OPTION VALUE="<%=v_box%>" <%if (LABEL_TYPE.equals(v_box)) out.println("selected");%>><%=v_box%></OPTION>
					<OPTION VALUE="<%=v_carton%>" <%if (LABEL_TYPE.equals(v_carton)) out.println("selected");%>><%=v_carton%></OPTION>
					</select></td>					
				<tr>
					<td width="35%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">列印張數預設值</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="PRINT_NUM" value="<%=PRINT_NUM%>" size="30" style="font-family: Tahoma,Georgia;" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" ></td>
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
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSYewLabelTypeAdd.jsp?STATUS=<%=STATUS%>&ACODE=SAVE")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick='setCancel()' value="關閉視窗" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (s_res.equals("1"))
	{
	%>
		<script language = "JavaScript">
			alert('修改成功!');
			window.opener.MYFORM.submit();
			setCancel();
		</script>
	<%				
	}
	else if (s_res.equals("2"))
	{
		out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
	
	%>
		<script language="javascript">
			setClear();
		</script>
	<%
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
