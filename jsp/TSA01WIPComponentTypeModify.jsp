<!--20180613 Pegg,新增庫存移轉邊線倉flag-->
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
function setSubmit(URL)
{ 
	if (document.MYFORMD.comp_type_name.value=="")
	{
		alert("請輸入原物料類別名稱!!");
		document.MYFORMD.comp_type_name.focus();
		return false;
	}
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
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
function setClear()
{
	document.MYFORMD.comp_type_name.value="";
	document.MYFORMD.comp_type_name.focus();
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
<title>A01 WIP COMPONENT Type Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSA01WIPComponentTypeModify.jsp" METHOD="POST"> 
<%
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String comp_type_name= request.getParameter("comp_type_name");
if (comp_type_name==null) comp_type_name="";
String comp_type_no = request.getParameter("comp_type_no");
if (comp_type_no==null) comp_type_no="";
String ACTIVE_FLAG = request.getParameter("ACTIVE_FLAG");
if (ACTIVE_FLAG==null) ACTIVE_FLAG="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String WIP_SUBINV_FLAG= request.getParameter("WIP_SUBINV_FLAG");  //add by Peggy 20180613
if (WIP_SUBINV_FLAG==null) WIP_SUBINV_FLAG="N";
String sql ="";
int chk_row=8,row=0;
String v_no="";

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
			sql = "select * from oraddman.tsa01_component_type a "+
                  " where a.comp_type_no =?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,comp_type_no);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				comp_type_name=rs.getString("comp_type_name");
				WIP_SUBINV_FLAG=rs.getString("WIP_SUBINV_FLAG");
				if (WIP_SUBINV_FLAG==null) WIP_SUBINV_FLAG="N";
				ACTIVE_FLAG = rs.getString("ACTIVE_FLAG");
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
				sql= " update oraddman.tsa01_component_type"+
				     " set LAST_UPDATED_BY=?"+
					 " ,LAST_UPDATE_DATE=sysdate"+
					 " ,COMP_TYPE_NAME=?"+
					 " ,ACTIVE_FLAG=?"+
					 " ,WIP_SUBINV_FLAG=?"+
				     " where comp_type_no= ?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,UserName);
				st1.setString(2,comp_type_name);
				st1.setString(3,ACTIVE_FLAG);
				st1.setString(4,WIP_SUBINV_FLAG);
				st1.setString(5,comp_type_no);
				st1.executeQuery();
				st1.close();
			}
			else
			{
			
				sql = " select lpad(nvl(max(substr(comp_type_no,-3)),0)+1,3,'0') from oraddman.tsa01_component_type a ";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{
					v_no= "C"+rs.getString(1);
				}
				rs.close();
				statement.close();
				
				sql = " insert into oraddman.tsa01_component_type"+
					  "(comp_type_no"+
					  ",comp_type_name"+
					  ",created_by"+
					  ",creation_date"+
					  ",last_updated_by"+
					  ",last_update_date"+
					  ",active_flag"+
					  ",WIP_SUBINV_FLAG"+
					  ")"+
					  " values"+
					  " ("+
					  " ?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",sysdate"+
					  ",?"+
					  ",?"+
					  ")";
				//out.println(sql);
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,v_no);	
				st1.setString(2,comp_type_name);
				st1.setString(3,UserName); 
				st1.setString(4,UserName); 
				st1.setString(5,ACTIVE_FLAG); 
				st1.setString(6,WIP_SUBINV_FLAG);
				st1.executeQuery();
				st1.close();
			}
			con.commit();
		}
		catch(Exception e)
		{
			con.rollback();
			ACODE="";
			out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
		}
	}

%>
<INPUT TYPE="hidden" name="STATUS" value="<%=STATUS%>">
<table align="center" width="100%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">A01</font><font style="font-family:細明體;font-size:20px;color:#006666;">原物料</font><font style="font-size:20px;color:#006666">類別維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="10%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">原物料類別名稱</span></td>
					<td nowrap><INPUT TYPE="TEXT" name="comp_type_name" value="<%=comp_type_name%>" size="30" style="font-family: Tahoma,Georgia;"><INPUT TYPE="hidden" name="comp_type_no" value="<%=comp_type_no%>"></td>
				</tr>
				<tr>
					<td width="10%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">發料至線邊倉</span></td>
					<td nowrap>
					<input type="radio" name="WIP_SUBINV_FLAG" value="Y" style="font-family:'Times New Roman';font-size:12px" <%if (WIP_SUBINV_FLAG.equals("Y")){out.println("checked");}%>><font style="font-size:12px">是</font>
					<input type="radio" name="WIP_SUBINV_FLAG" value="N" style="font-family:'Times New Roman';font-size:12px" <%if (WIP_SUBINV_FLAG.equals("N")){out.println("checked");}%>><font style="font-size:12px">否</font>					
					</td>
				</tr>
				<tr>
					<td width="10%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">狀態</span></td>
					<td nowrap>
					<input type="radio" name="ACTIVE_FLAG" value="Y" style="font-family:'Times New Roman';font-size:12px" <%if (STATUS.equals("NEW") || ACTIVE_FLAG.equals("Y")){out.println("checked");}%>><font style="font-size:12px">啟用</font>
					<input type="radio" name="ACTIVE_FLAG" value="N" style="font-family:'Times New Roman';font-size:12px" <%if (ACTIVE_FLAG.equals("N")){out.println("checked");}%>><font style="font-size:12px">停用</font>					
					</td>
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
    				<td width="16%"> 
									<input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSA01WIPComponentTypeModify.jsp?STATUS=<%=STATUS%>&ACODE=SAVE")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
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
		if (STATUS.equals("UPD"))
		{
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
			out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
	%>
		<script language="javascript">
			setClear();
		</script>
	<%
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
