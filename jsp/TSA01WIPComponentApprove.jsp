<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="",so_line_id="";
	if (document.MYFORM.STATUS.value=="" || document.MYFORM.STATUS.value=="--")
	{
		alert("請選擇執行動作!");
		return false;		
	}
	if (document.MYFORM.STATUS.value=="REJECT")
	{
		if (document.MYFORM.REJ_REASON.value=="")
		{
			alert("請輸入退件原因!");
			document.MYFORM.REJ_REASON.focus();
			return false;		
		}		
	}
	chkcnt=0;	
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true)
		{
			chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請勾選工單!");
		return false;
	}
	
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit1(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck((i+1));
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("reqno_"+irow).style.fontWeight="bold";
		document.getElementById("chk_"+irow).style.backgroundColor ="#99CC99";
	}
	else
	{
		document.getElementById("reqno_"+irow).style.fontWeight ="normal";
		document.getElementById("chk_"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setOPTValue()
{
	if (document.MYFORM.STATUS.value=="REJECT")
	{
		document.getElementById("span1").style.visibility ="visible";
		document.MYFORM.REJ_REASON.value="";
	}
	else
	{
		document.getElementById("span1").style.visibility ="hidden";
		document.MYFORM.REJ_REASON.value="";
	}
}
</script>
<html>
<head>
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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>TSA01 WIP Component Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
String colorStr = "";
String sql="";
String REQUEST_NO = request.getParameter("REQUEST_NO");
if (REQUEST_NO==null) REQUEST_NO="";
String WIP_NO = request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
int iCnt=0;
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPComponentApprove.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">A01領退料主管審核</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#E4F0F1">
	<tr>
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">領料單號:</font></td>
		<td width="15%"><input type="text" name="REQUEST_NO"  style="font-family: Tahoma,Georgia;" value="<%=REQUEST_NO%>">
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">工單號碼:</font></td>
		<td width="65%"><input type="text" name="WIP_NO"  style="font-family: Tahoma,Georgia;" value="<%=WIP_NO%>">
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" name="btnqry" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit1("../jsp/TSA01WIPComponentApprove.jsp")' ></td>
	</tr>
</table>   
<hr>
<%
try
{       	 

	sql = " SELECT a.request_no, a.request_type, a.organization_id,"+
                 " a.wip_entity_name, a.wip_entity_id, a.inventory_item_id,"+
                 " a.item_name, a.tsc_package, a.created_by, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date,"+
                 " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date, nvl(d.TYPE_VALUE ,a.status) status, a.version_id"+
				 ",c.TYPE_NAME"+
				 ",b.description item_desc"+
				 ",count(1) over (partition by a.organization_id) tot_cnt"+
                 " FROM oraddman.tsa01_request_headers_all a"+
				 ",inv.mtl_system_items_b b"+
				 ",(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
				 ",(select TYPE_NAME,TYPE_VALUE  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
				 " where a.organization_id=b.organization_id "+
				 " and a.inventory_item_id=b.inventory_item_id "+
				 " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
				 " and a.status=d.TYPE_NAME(+)"+
				 " and exists (select 1  from oraddman.tsa01_base_setup x where x.TYPE_CODE='REQ_STATUS' and x.TYPE_GROUP='K2-001' and x.TYPE_NAME=a.STATUS)";
	if (!REQUEST_NO.equals(""))
	{
		sql += " and a.request_no='"+ REQUEST_NO+"'";
	}
	if (!WIP_NO.equals(""))
	{
		sql += " and upper(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	}					 
	sql += " order by a.wip_entity_name,a.request_no ";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
			out.println("<div><font face='細明體' color='#CC0066' size='2'>共"+ rs.getString("tot_cnt") +"筆資料待簽核</font></div>");
%> 
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF"> 
	<tr bgcolor="#C5C6AE" style="color:#006666">
		<td width="2%" height="30" align="center"><input type="checkbox" name="chkall" value="Y"  onClick="checkall()"></td> 
		<td width="2%" align="center">項次</td> 
	  	<td width="4%" align="center">領料單號</td>
	  	<td width="4%" align="center">交易類型</td>
      	<td width="6%" align="center">工單號碼</td> 
      	<td width="10%"align="center">料號</td> 
      	<td width="12%"align="center">品名</td> 
      	<td width="38%" align="center">申請<jsp:getProperty name="rPH" property="pgDetail"/></td>            
	  	<td width="5%" align="center">申請人</td>                    
	  	<td width="7%" align="center">申請日期</td>                    
    </tr>
    <% 
		}
		
    %>
		<tr bgcolor="<%=colorStr%>"> 
			<td align="center" id="chk_<%=iCnt%>"><input type="checkbox" name="chk" value="<%=rs.getString("REQUEST_NO")%>" onClick="setCheck('<%=iCnt%>')"></td>
			<td align="center"><%=iCnt%></td>
			<td align="center" id="reqno_<%=iCnt%>"><%=rs.getString("REQUEST_NO")%></td>
			<td align="center" <%=(rs.getString("request_type").equals("RETURN")?"style='background-color:#F9C6DB'":"")%>><%=rs.getString("TYPE_NAME")%></td>
			<td align="center"><%=rs.getString("wip_entity_name")%></td>
			<td><%=rs.getString("ITEM_NAME")%></td>
			<td><%=rs.getString("ITEM_DESC")%></td>
			<td>
	<% 
			int iRow = 0; 	
			String sqld = " SELECT a.request_no, a.line_no, a.comp_type_no,b.comp_type_name, a.organization_id,"+
                          " a.component_item_id, a.component_name, a.uom, a.required_qty,"+
                          " a.request_qty,  a.spq, a.moq, a.change_rate,"+
                          " a.remarks,(select listagg(k.LOT ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'<br>') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k"+
						  " where  a.request_no=k.request_no"+
                          " and a.line_no=k.line_no) lot_list"+						  
                          " FROM oraddman.tsa01_request_lines_all a,oraddman.tsa01_component_type b"+
						  " where a.COMP_TYPE_NO=b.COMP_TYPE_NO "+
						  " and a.request_no='"+ rs.getString("REQUEST_NO")+"' order by a.line_no";				   
			Statement stated=con.createStatement();
			ResultSet rsd=stated.executeQuery(sqld); 							  
			while (rsd.next())
			{ 
				if (iRow==0 )
				{ 
					out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");			 
					out.println("<tr align='center' bgcolor='#99CC99'>");
					out.println("<td width='10%'>類別</td>");
					out.println("<td width='10%'>料號</td>");
					out.println("<td width='8%'>單位</td>");
					out.println("<td width='8%'>工單用量</td>");
					out.println("<td width='8%'>最小包裝量</td>");
					out.println("<td width='8%'>領用數量</td>");
					out.println("<td width='15%'>指定批號</td>");
					out.println("</tr>");
				}	
				out.println("<tr bgcolor="+colorStr+">");
				out.println("<td nowrap>"+rsd.getString("comp_type_name")+"</td>");
				out.println("<td nowrap>"+rsd.getString("COMPONENT_NAME")+"</td>");
				out.println("<td align='center'>"+rsd.getString("uom")+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("required_qty")).doubleValue()+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("spq")).doubleValue()+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("request_qty")).doubleValue()+"</td>");
				out.println("<td>"+(rsd.getString("lot_list")==null?"&nbsp;":rsd.getString("lot_list"))+"</td>");
				out.println("</tr>");			
				iRow++;
			} 
			rsd.close();
			stated.close();
			if (iRow >0) out.println("</table>");   
%>			

			</td> 
			<td align="center"><%=(rs.getString("CREATED_BY")==null?"&nbsp;":rs.getString("CREATED_BY"))%></td>
			<td align="center"><%=(rs.getString("CREATION_DATE")==null?"&nbsp;":rs.getString("CREATION_DATE"))%></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<font color='red' size='2' face='新細明體'><strong>目前無待簽核資料!</strong></font>");
	}
	else
	{
%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#E4F0F1">
	<tr>
		<td>
		  <p><font style="font-family:Tahoma,Georgia;font-size:12px">
	      <jsp:getProperty name="rPH" property="pgAction"/>
	      =></font>
		 <%
		try
		{   
			sql = "select distinct a.type_name,a.type_value from oraddman.tsa01_base_setup a where a.type_code='REQ_STATUS' AND TYPE_GROUP='K2-002'";
			statement=con.createStatement();
			rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(STATUS);
			comboBoxBean.setOnChangeJS("setOPTValue()");
			comboBoxBean.setFieldName("STATUS");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();      	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>	
	        <input type="button" name="submit1" value="Submit" style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSA01WIPComponentProcess.jsp?PROGRAM=K2-002")'>
		        <span id="span1" style="visibility:hidden;font-size:12px">
			退件原因：</font>
  <input type="text"  name="REJ_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia;font-size:12px">
            </span> </td>
	</tr>
</table>
<hr>

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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

