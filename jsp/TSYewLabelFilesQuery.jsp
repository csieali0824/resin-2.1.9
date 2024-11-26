<%@ page contentType="text/html;charset=utf-8"  language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>TS YEW Label Query</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAdd(URL)
{    
	document.MYFORM.action=URL;
	document.MYFORM.submit();	
}

function setUpdate(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();	
}

function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setDelete(URL)
{
	if (confirm("Are you sure to delete label?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();	
	}
}
</script>
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
<%
String LABEL = request.getParameter("LABEL");
if (LABEL==null) LABEL="";
String LABEL_GROUP = request.getParameter("LABEL_GROUP");
if (LABEL_GROUP==null) LABEL_GROUP="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String LABEL_CODE = request.getParameter("LABEL_CODE");
if (LABEL_CODE==null) LABEL_CODE="";
String sql ="",FileName=""; 
int area_cnt=0,bufsize=0,fileLength=0; 

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

if (STATUS.equals("DELETE"))
{
	sql= " delete oraddman.tsyew_label_all  "+
		 " where LABEL_CODE = ?";
	//out.println(sql);
	PreparedStatement st1 = con.prepareStatement(sql);
	st1.setString(1,LABEL_CODE);
	st1.executeUpdate();
	st1.close();
%>	
		<script language="javascript">
			alert("Data deleted!!");
		</script>		
<%
}
%>
</head>
<body>
<form name="MYFORM"  METHOD="post" ACTION="../jsp/TSYewLabelFilesQuery.jsp">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤檔查詢</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
 		<td width="10%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666;">標籤代碼/名稱:</td>   
		<td width="15%"><input type="text" name="LABEL" value="" style="font-family:Tahoma,Georgia; font-size: 11px"></td>
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666;">群組代碼/名稱:</td>   
		<td width="12%"><input type="text" name="LABEL_GROUP" value="" style="font-family:Tahoma,Georgia; font-size: 11px"></td> 
		<td width="8%" bgcolor="#D3E6F3"  style="font-size:11px;font-weight:bold;color:#006666">啟/停用:</td>   
		<td width="10%">
		<select NAME="STATUS" style="font-family:Tahoma,Georgia; font-size: 11px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>			
		</td>
	   <td width="17%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSYewLabelFilesQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSYewLabelFilesAdd.jsp?STATUS=NEW")' > 
	    &nbsp;&nbsp;&nbsp;</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " select  b.label_group_code"+
	      ",b.label_group_name"+
		  ",a.label_code"+
		  ",a.label_name"+
		  ",a.label_file"+
          ",a.label_type_code"+
		  ",to_char(a.effective_from_date,'yyyy-mm-dd') effective_from_date"+
		  ",to_char(a.effective_to_date,'yyyy-mm-dd') effective_to_date"+
          ",to_char(a.creation_date,'yyyy-mm-dd') creation_date"+
		  ",a.created_by"+
		  ",to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date"+
          ",a.last_updated_by"+
		  ",d.LABEL_TYPE_NAME "+
		  ",a.SHIPPING_MARK"+
		  ",a.remarks"+
	      " from oraddman.tsyew_label_all a,oraddman.tsyew_label_groups b,oraddman.tsyew_label_types d"+
          " where a.label_group_code=b.label_group_code(+) "+
		  " and a.label_type_code=d.label_type_code(+)";
	if (! LABEL.equals("") && ! LABEL.equals("--"))
	{
	 	sql += " and (upper(a.label_code)  like '"+ LABEL.toUpperCase()+"%' or upper(a.label_name)  like '"+ LABEL.toUpperCase()+"%')";
	}		  
	if (! LABEL_GROUP.equals("") && ! LABEL_GROUP.equals("--"))
	{
	 	sql += " and (upper(b.label_group_code) ='"+ LABEL_GROUP.toUpperCase() +"' or upper(b.label_group_name) like '"+LABEL_GROUP.toUpperCase()+"%')";
	}
	if (STATUS.equals("Y"))
	{
		sql += " and trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	else if (STATUS.equals("N"))
	{
		sql += " and trunc(sysdate) not between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date))";
	}
	sql += " order by b.LABEL_GROUP_CODE,decode(d.LABEL_TYPE,'REEL',1,'BOX',2,'CARTON',3,4),a.label_type_code,a.label_code";
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
				<td width="3%" rowspan="2" align="center">編輯</td> 
				<td width="4%" rowspan="2" style="font-size:11px;color:#006666" align="center">序號</td> 
				<td width="6%" rowspan="2" style="font-size:11px;color:#006666" align="center">群組代碼</td>
				<td width="12%" rowspan="2" style="font-size:11px;color:#006666" align="center">群組名稱</td>
				<td width="6%" rowspan="2" style="font-size:11px;color:#006666" align="center">標籤代碼</td>
				<td width="8%" rowspan="2" style="font-size:11px;color:#006666" align="center">標籤種類</td>
				<td width="13%" rowspan="2" style="font-size:11px;color:#006666" align="center">標籤名稱</td>
				<td width="6%" rowspan="2" style="font-size:11px;color:#006666" align="center">標籤檔</td>
				<td width="8%" rowspan="2" style="font-size:11px;color:#006666" align="center">備註</td>
				<td width="6%" rowspan="2" style="font-size:11px;color:#006666" align="center">啟用起日</td>            
				<td width="6%" rowspan="2" style="font-size:11px;color:#006666" align="center">啟用迄日</td>            
				<td width="9%" rowspan="2" style="font-size:11px;color:#006666" align="center">最後異動日</td>            
				<td width="8%" rowspan="2" style="font-size:11px;color:#006666" align="center">最後異動者</td>            
			</tr>
			<tr bgcolor="#D3E6F3"> 
			</tr>
		<% 
		}
		FileName=rs.getString("label_code")+".lbl";
		
    	%>
			<tr  id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="20" title="修改資料" onClick="setUpdate('../jsp/TSYewLabelFilesAdd.jsp?STATUS=UPD&LABEL_CODE=<%=rs.getString("label_code")%>')">&nbsp;&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="刪除資料" onClick="setDelete('../jsp/TSYewLabelFilesQuery.jsp?LABEL_CODE=<%=rs.getString("label_code")%>&STATUS=DELETE')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td><%=rs.getString("label_group_code")%></td>
			<td><%=rs.getString("label_group_name")%></td>
			<td><%=rs.getString("label_code")%></td>
			<td><%=rs.getString("label_type_name")%></td>
			<td><%=rs.getString("label_name")%></td>
			<td align="center"><a href="../jsp/download_label/<%=FileName%>" title="請按滑鼠右鍵,下載標籤檔"><%=FileName%></a></td>
			<td><%=(rs.getString("remARKs")==null?"&nbsp;":rs.getString("reMARKs"))%></td>
			<% 
			for (int i = 1 ; i <=area_cnt ; i++)
			{
			%>
				<td align="center"><%=(rs.getString(15+(i-1))==null?"&nbsp;":rs.getString(15+(i-1)))%></td>
			<%
			}
			%>
			<td align="center"><%=(rs.getString("effective_from_date")==null?"&nbsp;":rs.getString("effective_from_date"))%></td>
			<td align="center"><%=(rs.getString("effective_to_date")==null?"&nbsp;":rs.getString("effective_to_date"))%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center"><%=rs.getString("last_updated_by")%></td>
		</tr>
<%
		/*
		BLOB myblob=((OracleResultSet)rs).getBLOB("label_file");
		InputStream is = myblob.getBinaryStream();
		
		FileOutputStream fos = new FileOutputStream("\\resin-2.1.9\\webapps\\oradds\\jsp\\download_label\\"+FileName);
		bufsize=myblob.getBufferSize();
		byte[] buffer = new byte[bufsize];   
		while ((fileLength=is.read(buffer))!=-1)   
			fos.write(buffer,0,fileLength);
	   	fos.flush();
	   	fos.close();
	   	is.close();
		*/
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
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</form>
</body>
</html>
