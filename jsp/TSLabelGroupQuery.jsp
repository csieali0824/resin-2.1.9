<!--20171024 Peggy,新增remarks欄位-->
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
	var w_height=850;
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
	var w_height=850;
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
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 11px}
</STYLE>
<title>TS Label Group Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String LABEL_GROUP = request.getParameter("LABEL_GROUP");
if (LABEL_GROUP==null) LABEL_GROUP="";
String LABEL_GROUP_CODE = request.getParameter("LABEL_GROUP_CODE");
if (LABEL_GROUP_CODE==null) LABEL_GROUP_CODE="";
String MODULE_CODE = request.getParameter("MODULE_CODE");
if (MODULE_CODE==null) MODULE_CODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String sql ="",sql1="";
int area_cnt =0;

sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSLabelGroupQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤群組查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;">群組代碼/名稱:</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="LABEL_GROUP" VALUE="<%=LABEL_GROUP%>" 	 style="font-family: Tahoma,Georgia;"></td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">業務模組:</td>   
		<td width="15%">
		<%
		try
		{
			sql = " select distinct b.module_code,b.module_name from oraddman.ts_label_group_assignments a,oraddman.ts_label_modules b "+
                  " where a.module_code=b.module_code and NVL(a.isactive_flag,'N') ='Y' order by b.module_code";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(MODULE_CODE);
			comboBoxBean.setFieldName("MODULE_CODE");	
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
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666">啟/停用:</td>   
		<td width="15%">
		<select NAME="STATUS" style="font-family:Tahoma,Georgia; font-size: 12px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>			
		</td>
		<td width="31%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSLabelGroupQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSLabelGroupAdd.jsp?STATUS=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSLabelGroupExcel.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select a.label_group_code,a.label_group_name, a.label_group_desc,a.remarks, "+
          " to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date, to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, a.last_updated_by "+
		  ",a.label_form_code||'-'|| a.label_form_version label_form"; //add by Peggy 20210122
	sql1 = " SELECT a.module_code FROM oraddman.ts_label_modules a "+
		  " where trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date)) "+
		  " order by a.module_code";
	Statement statement1=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
	ResultSet rs1=statement1.executeQuery(sql1);
	while (rs1.next())
	{
		sql += ",(select nvl(isactive_flag,'N') from oraddman.ts_label_group_assignments x where x.label_group_code=a.label_group_code and NVL(x.isactive_flag,'N') ='Y' and x.module_code='"+rs1.getString("module_code")+"' ) AS "+rs1.getString("module_code")+"";
		area_cnt++;
	}

    sql += " from oraddman.ts_label_groups a"+
		  " where 1=1";
	if (! LABEL_GROUP.equals("") && ! LABEL_GROUP.equals("--"))
	{
	 	sql += " and (upper(a.label_group_code)='"+ LABEL_GROUP.toUpperCase()+"' or upper(a.label_group_name) like '"+ LABEL_GROUP.toUpperCase()+"%')";
	}
	if (!MODULE_CODE.equals("") && !MODULE_CODE.equals("--"))
	{
		sql += " and exists (select 1 from oraddman.ts_label_group_assignments b where b.module_code = '" + MODULE_CODE +"' and b.label_group_code=a.label_group_code and NVL(b.isactive_flag,'N')='Y')";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	sql += " order by length(a.label_form_code),a.label_form_code,a.label_group_code,a.label_group_name";
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
				<td width="3%" rowspan="2">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" rowspan="2" style="font-size:12px;color:#006666" align="center">序號</td> 
				<td width="7%" rowspan="2" style="font-size:12px;color:#006666" align="center">文件編號</td>
				<td width="5%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組代碼</td>
				<td width="16%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組名稱</td>
				<td width="16%" rowspan="2" style="font-size:12px;color:#006666" align="center">群組說明</td>
				<td width="10%" rowspan="2" style="font-size:12px;color:#006666" align="center">備註</td>
				<td width="15%" colspan="5" style="font-size:12px;color:#006666" align="center" valign="middle">業務模組</td>
				<td width="6%" rowspan="2" style="font-size:12px;color:#006666" align="center">啟用起日</td>            
				<td width="6%" rowspan="2" style="font-size:12px;color:#006666" align="center">啟用迄日</td>            
				<td width="6%" rowspan="2" style="font-size:12px;color:#006666" align="center">最後異動日</td>            
				<td width="7%" rowspan="2" style="font-size:12px;color:#006666" align="center">最後異動者</td>            
			</tr>
			<tr bgcolor="#D3E6F3"> 
		<%
			if (rs1.isBeforeFirst() ==false) rs1.beforeFirst();
			while (rs1.next())
			{
		%>
				<td style="font-size:12px;color:#006666" align="center"><%=rs1.getString("module_code")%></td>
		<%
			}
			rs1.close();   
			statement1.close();		
		%>
				
			</tr>
		<% 
		}
    	%>
			<tr id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setUpdate('../jsp/TSLabelGroupAdd.jsp?STATUS=UPD&LABEL_GROUP_CODE=<%=rs.getString("label_group_code")%>')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("label_form")%></td>
			<td align="center"><%=rs.getString("label_group_code")%></td>
			<td><%=rs.getString("label_group_name")%></td>
			<td><%=rs.getString("label_group_desc")%></td>
			<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
			<% 
			for (int i = 1 ; i <=area_cnt ; i++)
			{
			%>
				<td align="center"><%=(rs.getString(10+(i-1))==null?"&nbsp;":rs.getString(10+(i-1)))%></td>
			<%
			}
			%>
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

