<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAdd(URL)
{    
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);	
}

function setUpdate(URL)
{
	var w_width=600;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);
}
function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
.style2 {	font-size: 12px;
	color: #006666;
}
</STYLE>
<title>TS YEW Label Type Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String LABEL_TYPE_CODE = request.getParameter("LABEL_TYPE_CODE");
if (LABEL_TYPE_CODE==null) LABEL_TYPE_CODE="";
String LABEL_TYPE_NAME = request.getParameter("LABEL_TYPE_NAME");
if (LABEL_TYPE_NAME==null) LABEL_TYPE_NAME="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSYewLabelTypeQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤種類查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">標籤代碼:</td>   
		<td width="15%">
		<%
		try
		{
			sql = " select LABEL_TYPE_CODE,LABEL_TYPE_CODE  from oraddman.ts_label_types a order by  a.LABEL_TYPE_CODE";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(LABEL_TYPE_CODE);
			comboBoxBean.setFieldName("LABEL_TYPE_CODE");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>		
		</td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">標籤名稱:</td>   
		<td width="15%">
		<INPUT TYPE="TEXT" NAME="LABEL_TYPE_NAME" VALUE="<%=LABEL_TYPE_NAME%>" 	 style="font-family: Tahoma,Georgia;">
		</td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">啟/停用:</td>   
		<td width="15%">
		<select NAME="STATUS" style="font-family:Tahoma,Georgia; font-size: 12px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>			
		</td>
		<td width="31%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSYewLabelTypeQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSYewLabelTypeAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSYewLabelTypeExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.LABEL_TYPE_CODE,a.LABEL_TYPE_NAME,a.description,to_char(a.LAST_UPDATE_DATE,'yyyy-mm-dd') LAST_UPDATE_DATE,a.LAST_UPDATED_BY,to_char(a.EFFECTIVE_FROM_DATE,'yyyy-mm-dd') EFFECTIVE_FROM_DATE,to_char(a.EFFECTIVE_TO_DATE,'yyyy-mm-dd') EFFECTIVE_TO_DATE,a.PRINT_NUM,a.label_size,a.label_type"+
          " FROM oraddman.tsyew_label_types a  "+
		  " where 1=1";
          //" where b.PARENT_LABEL_TYPE_CODE <>'000' ";
	if (!LABEL_TYPE_CODE.equals("") && !LABEL_TYPE_CODE.equals("--"))
	{
	 	sql += " and a.LABEL_TYPE_CODE='"+ LABEL_TYPE_CODE+"' ";
	}
	if (!LABEL_TYPE_NAME.equals(""))
	{
		//sql += " and a.LABEL_TYPE_NAME like '%" + LABEL_TYPE_NAME +"%'";
		sql += " and UPPER(a.LABEL_TYPE_NAME) like '%" + LABEL_TYPE_NAME.toUpperCase() +"%'";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	sql += " order by decode(a.label_type,'REEL',1,'BOX',2,'CARTON',3,4),a.label_size,a.LABEL_TYPE_NAME,a.LABEL_TYPE_CODE";
	//sql += " start with b.parent_LABEL_TYPE_CODE='000'"+
    //      " CONNECT by nocycle prior b.LABEL_TYPE_CODE = b.PARENT_LABEL_TYPE_CODE ";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
		%>
		<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
			<tr bgcolor="#D3E6F3"> 
				<td width="3%" height="22">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="5%" style="font-size:12px;color:#006666" align="center">標籤代碼</td>
				<td width="8%" style="font-size:12px;color:#006666" align="center">標籤名稱</td>
				<td width="10%" style="font-size:12px;color:#006666" align="center">標籤說明</td>
				<td width="8%" style="font-size:12px;color:#006666" align="center">標籤尺寸(<span class="style2">mm</span>)</td>
				<td width="8%" style="font-size:12px;color:#006666" align="center">材積種類</td>
				<td width="5%" style="font-size:12px;color:#006666" align="center">列印張數</td>
				<td width="9%" style="font-size:12px;color:#006666" align="center">啟用起日</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">啟用迄日</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="9%" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
			</tr>
		<% 
		}
    	%>
			<tr  id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSYewLabelTypeAdd.jsp?STATUS=UPD&LABEL_TYPE_CODE=<%=rs.getString("LABEL_TYPE_CODE")%>')"></td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("LABEL_TYPE_CODE")%></td>
			<td><%=rs.getString("LABEL_TYPE_name")%></td>
			<td><%=(rs.getString("DESCRIPTION")==null?"&nbsp;":rs.getString("DESCRIPTION"))%></td>
			<td><%=(rs.getString("LABEL_SIZE")==null?"&nbsp;":rs.getString("LABEL_SIZE"))%></td>
			<td><%=(rs.getString("LABEL_TYPE")==null?"&nbsp;":rs.getString("LABEL_TYPE"))%></td>
			<td align="center"><%=(rs.getString("PRINT_NUM")==null?"&nbsp;":rs.getString("PRINT_NUM"))%></td>
			<td align="center"><%=(rs.getString("effective_from_date")==null?"&nbsp;":rs.getString("effective_from_date"))%></td>
			<td align="center"><%=(rs.getString("effective_to_date")==null?"&nbsp;":rs.getString("effective_to_date"))%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center"><%=rs.getString("last_updated_by")%></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	else
	{
%>
	</table>
<%
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

