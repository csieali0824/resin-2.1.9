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
	//var w_width=600;
	//var w_height=300;
    //var x=(screen.width-w_width)/2;
    //var y=(screen.height-w_height-200)/2;
    //var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x;
	//document.getElementById("alpha").style.width=document.body.clientWidth;
	//document.getElementById("alpha").style.height=document.body.clientHeight;
	//subWin=window.open(URL,"subwin",ww);
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
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
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
<title>A01 WIP  Component Detail Query</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String COMP_TYPE_NAME = request.getParameter("COMP_TYPE_NAME");
if (COMP_TYPE_NAME==null) COMP_TYPE_NAME="";
String ITEM_NAME = request.getParameter("ITEM_NAME");
if (ITEM_NAME==null) ITEM_NAME="";
String COMP_TYPE_NO = request.getParameter("COMP_TYPE_NO");
if (COMP_TYPE_NO==null) COMP_TYPE_NO="";
String ORGANIZATION_ID = request.getParameter("ORGANIZATION_ID");
if (ORGANIZATION_ID==null) ORGANIZATION_ID="";
String ITEM_ID = request.getParameter("ITEM_ID");
if (ITEM_ID==null) ITEM_ID="";
String ATYPE =request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String sql ="";

if (ATYPE.equals("DELETE"))
{
	try
	{
		sql = " delete oraddman.TSA01_COMPONENT_DETAIL where COMP_TYPE_NO=? and ORGANIZATION_ID=? and INVENTORY_ITEM_ID=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,COMP_TYPE_NO); 
		pstmtDt.setString(2,ORGANIZATION_ID); 
		pstmtDt.setString(3,ITEM_ID); 
		pstmtDt.executeQuery();
		pstmtDt.close();

		con.commit();
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("刪除動作失敗!!(錯誤原因:"+e.getMessage()+")");
	}	
}
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPComponentDetailQuery.jsp" METHOD="post" NAME="MYFORM">
<br>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<strong><font style="font-family:細明體;font-size:20px;color:#006666;">A01原物料明細設定</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div><br>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td width="10%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;"><span style="font-size:12px;color:#006666">原物料類別名稱</span> :</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="COMP_TYPE_NAME" VALUE="<%=COMP_TYPE_NAME%>" style="font-family: Tahoma,Georgia;"></td> 
		<td width="10%" bgcolor="#D3E6F3"  style="font-size:12px;font-weight:bold;color:#006666;"><span style="font-size:12px;color:#006666">料號/品名</span> :</td>   
		<td width="15%"><INPUT TYPE="TEXT" NAME="ITEM_NAME" VALUE="<%=ITEM_NAME%>" style="font-family: Tahoma,Georgia;"></td> 
		<td width="50%" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPComponentDetailQuery.jsp")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='新增'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSA01WIPComponentDetailModify.jsp?ACODE=NEW&ORGANIZATION_ID=606&TRANS_TYPE=NEW")' > 
			&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value='匯出Excel'  style="font-family:ARIAL" onClick='setExportXLS("../jsp/TSA01WIPComponentDetailExcel.jsp")' > 
			
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	sql = " SELECT a.comp_type_no"+
	      ", b.comp_type_name"+
	      ", a.organization_id"+
		  ", a.inventory_item_id"+
		  ", a.item_name"+
		  ", c.description"+
		  ", a.uom"+
		  ", a.spq"+
		  ", a.moq"+
		  ", a.created_by"+
          ", a.level1_packing_name"+
		  ", a.level1_packing_value"+
          ", a.level2_packing_name"+
		  ", a.level2_packing_value"+
		  ", a.level3_packing_name"+
		  ", a.level3_packing_value"+
		  ", a.level4_packing_name"+
		  ", a.level4_packing_value"+
		  ", a.moq_level"+
		  ", to_char(a.creation_date,'yyyy/mm/dd') creation_date"+
		  ", a.last_updated_by"+
		  ", to_char(a.last_update_date,'yyyy/mm/dd') last_update_date"+
		  ", nvl(a.inactive_flag,'') inactive_flag"+
          " FROM oraddman.tsa01_component_detail a,oraddman.tsa01_component_type b,inv.mtl_system_items_b c"+
		  " where a.comp_type_no=b.comp_type_no"+
		  " and a.inventory_item_id=c.inventory_item_id"+
		  " and a.organization_id=c.organization_id";
	if (!COMP_TYPE_NAME.equals(""))
	{
	 	sql += " and b.comp_type_name like '"+ COMP_TYPE_NAME.toUpperCase()+"%'";
	}
	if (!ITEM_NAME.equals(""))
	{
		sql += " and (a.item_name like '"+ITEM_NAME+"%' or c.description like '%"+ITEM_NAME+"%')";
	}
	sql += " order by a.comp_type_no,a.item_name";
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
				<td width="5%" rowspan="2">&nbsp;&nbsp;&nbsp;</td> 
				<td width="3%" style="color:#006666" align="center" rowspan="2">序號</td> 
				<td width="8%" style="color:#006666" align="center" rowspan="2">原物料類別代碼</td>
				<td width="8%" style="color:#006666" align="center" rowspan="2">原物料類別名稱</td>
				<td width="10%" style="color:#006666" align="center" rowspan="2">料號</td>
				<td width="20%" style="color:#006666" align="center" rowspan="2">品名</td>
				<td width="20%" align="center" colspan="4">小--->大</td>
				<td width="3%" style="color:#006666" align="center" rowspan="2">單位</td>
				<td width="5%" style="color:#006666" align="center" rowspan="2">發料包裝層</td>
				<td width="7%" style="color:#006666" align="center" rowspan="2">最後異動日</td>            
				<td width="7%" style="color:#006666" align="center" rowspan="2">最後異動者</td>            
				<td width="4%" style="color:#006666" align="center" rowspan="2">是否停用</td>            
			</tr>
			<tr bgcolor="#D3E6F3">
				<td width="5%" align="center">第一層包裝</td>
				<td width="5%" align="center">第二層包裝</td>
				<td width="5%" align="center">第三層包裝</td>
				<td width="5%" align="center">第四層包裝</td>
			</tr>			
			<tr bgcolor="#D3E6F3"> 
			</tr>
		<% 
		}
    	%>
			<tr id="tr_<%=iCnt%>" bgcolor="#E7F3FE" onMouseOver="this.style.Color='#006666';this.style.backgroundColor='#CAEDAF';this.style.fontWeight='bold'" onMouseOut="style.backgroundColor='#E7F3FE';style.color='#000000';this.style.fontWeight='normal'">
			<td align="center">
			<img border="0" src="images/updateicon_enabled.gif" height="18" title="修改資料" onClick="setAdd('../jsp/TSA01WIPComponentDetailModify.jsp?ACODE=UPDATE&COMP_TYPE_NO=<%=rs.getString("comp_type_no")%>&ORGANIZATION_ID=606&TRANS_TYPE=UPDATE&ITEM_ID=<%=rs.getString("inventory_item_id")%>')">
			&nbsp;&nbsp;&nbsp;<img border="0" src="images/deletion.gif" height="14" title="Delete Record" onClick="setDelete('../jsp/TSA01WIPComponentDetailQuery.jsp?COMP_TYPE_NO=<%=rs.getString("comp_type_no")%>&ORGANIZATION_ID=606&ITEM_ID=<%=rs.getString("inventory_item_id")%>&ATYPE=DELETE')">
			</td>
			<td align="center"><%=iCnt%></td>
			<td align="center"><%=rs.getString("comp_type_no")%></td>
			<td><%=rs.getString("comp_type_name")%></td>
			<td><%=rs.getString("item_name")%></td>
			<td><%=rs.getString("description")%></td>
			<td align="center"><%=(rs.getString("level1_packing_value")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("level1_packing_value")))+(rs.getString("level1_packing_name")==null?"":"/"+rs.getString("level1_packing_name")))%></td>
			<td align="center"><%=(rs.getString("level2_packing_value")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("level2_packing_value")))+(rs.getString("level2_packing_name")==null?"":"/"+rs.getString("level2_packing_name")))%></td>
			<td align="center"><%=(rs.getString("level3_packing_value")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("level3_packing_value")))+(rs.getString("level3_packing_name")==null?"":"/"+rs.getString("level3_packing_name")))%></td>
			<td align="center"><%=(rs.getString("level4_packing_value")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("level4_packing_value")))+(rs.getString("level4_packing_name")==null?"":"/"+rs.getString("level4_packing_name")))%></td>
			<td align="center"><%=(rs.getString("UOM")==null?"&nbsp;":rs.getString("UOM"))%></td>
			<td align="center"><%=(rs.getString("moq_level")==null?"&nbsp;":rs.getString("moq_level"))%></td>
			<td align="center"><%=rs.getString("last_update_date")%></td>
			<td align="center"><%=rs.getString("last_updated_by")%></td>
			<td align="center"><%=(rs.getString("inactive_flag") != null && rs.getString("inactive_flag").equals("Y")?"停用":"&nbsp;")%></td>
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

