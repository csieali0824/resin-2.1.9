<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAddNew(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setModify(URL)
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
</script>
<html>
<head>
<title>特規料號資料查詢</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">    
<FORM  METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
	String ITEM = request.getParameter("ITEM");
	if (ITEM==null) ITEM="";
	String ITEMID = request.getParameter("ITEMID");
	if (ITEMID==null) ITEMID="";
	String ACTIONCODE = request.getParameter("ACTIONCODE");
	if (ACTIONCODE==null) ACTIONCODE = "";
	
	if (ACTIONCODE.equals("DELETE"))
	{
		String sql = " delete oraddman.tsc_special_item_data"+
			  " where INVENTORY_ITEM_ID ='"+ITEMID+"'";
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.executeUpdate();
		st1.close();
		out.println("<script language = 'JavaScript'>");
		out.println("alert('資料刪除完成!')");
		out.println("</script>");
	}
%>
<table cellspacing="0" cellpadding="1" width="90%" align="center">	
	<tr>
		<td><font color="#003366" size="+3" face="Arial Black"><em>TSC</em></font>
			<font style="font-size:28px;color:#000000;font-family:'標楷體'"><strong>特規料號資料查詢維護</strong></font>
		</td>
	</tr>
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"  style="font-size:16px;font-family:標楷體;text-decoration:none;color:#0000FF">回首頁</A></td>
	</tr>
	<tr>
		<td>
			<table cellspacing="0" bordercolordark="#999966" cellpadding="0" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
				<tr BGCOLOR='#999966'>
					<td width="20%" nowrap style="font-size:12px;color:#FFFFFF;font-family:arial"><strong>料號/品名</strong></td> 
					<td width="60%"><INPUT TYPE="textbox" NAME="ITEM" value="<%=ITEM%>" style="font-size:12px;color:#333333;font-family:arial"></td>
					<td width="20%"><INPUT TYPE="button" id='Query' value='查詢' onClick='setSubmit("../jsp/TSCMfgSpecificationItemQuery.jsp")'>&nbsp;&nbsp;&nbsp;
					<INPUT TYPE='button' id='AddNew' value='資料新增' onClick='setAddNew("../jsp/TSCMfgSpecificationItemUpdate.jsp")'>
					</td> 			
				</tr>
			</table>
		</td>
   	</tr>
   	<tr>
   		<td>&nbsp;</td>
	</tr>
<%
			int i =0;
			try
			{
				String sourceLot = "";
				String sql = " SELECT a.inventory_item_id, a.inventory_item_name, a.item_description,"+
                             " a.carton_item_desc, a.box_item_desc, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date ,"+
                             " a.last_updated_by, to_char(a.previous_update_date,'yyyy-mm-dd hh24:mi') previous_update_date, a.previous_updated_by"+
							 ",(select count(1) from  oraddman.tsc_special_item_data b";
				if (!ITEM.equals("")) sql += " where (b.inventory_item_name like '"+ ITEM +"%' or b.item_description like '"+ ITEM +"%')";
                sql += " ) rowcnt FROM oraddman.tsc_special_item_data a";
				if (!ITEM.equals("")) sql += " where (inventory_item_name like '"+ ITEM +"%' or item_description like '"+ ITEM +"%')";
   				Statement statement=con.createStatement();
			    ResultSet rs=statement.executeQuery(sql);  
				//out.println(sql);
			    while (rs.next())
				{
					i++;
					if (i==1)
					{
						out.println("<tr><td style='font-family:細明體;font-size:14px'>查詢筆數共:"+rs.getString("rowcnt")+"筆資料</td></tr>");
						out.println("<tr>");
						out.println("<td>");
						out.println("<table cellspacing='0' bordercolordark='#FFFFFF' cellpadding='1' width='100%' align='center' bordercolorlight='#CCCC99' border='1'>");	
						out.println("<tr bgcolor='#CCCC99' style='font-size:12px;font-family:arial;color:#000000'>");
						out.println("<td width='4%' align='center'>&nbsp;</td>");
						out.println("<td width='8%' align='center'>&nbsp;</td>");
						out.println("<td width='13%' valign='middle'>料號</td>");
						out.println("<td width='13%'>品名</td>");
						out.println("<td width='15%'>外箱品名</td>");
						out.println("<td width='15%'>內盒品名</td>");
						out.println("<td width='8%' align='center'>最後更新日</td>");
						out.println("<td width='8%' align='center'>最後更新人員</td>");
						out.println("<td width='8%' align='center'>上次更新日</td>");
						out.println("<td width='8%' align='center'>上次更新人員</td>");
						out.println("</tr>");
					}
					out.println("<tr>");
					out.println("<td align='center' style='font-size:12px;font-family:arial;'>"+i+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;'>");
					out.println("<input type='button' id='UPD"+i+"' value='修改' onclick='setModify("+'"'+"../jsp/TSCMfgSpecificationItemUpdate.jsp?ACTIONMODE=MODIFY&ITEMID="+rs.getString("inventory_item_id")+'"'+")'>");
					out.println("<input type='button' id='DEL"+i+"' value='刪除' onclick='setDelete("+'"'+"../jsp/TSCMfgSpecificationItemQuery.jsp?ACTIONCODE=DELETE&ITEMID="+rs.getString("inventory_item_id")+'"'+")'>");
					out.println("</td>");
					out.println("<td style='font-size:11px;font-family:arial;'>"+rs.getString("inventory_item_name")+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;'>"+rs.getString("item_description")+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;'>"+rs.getString("carton_item_desc")+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;'>"+rs.getString("box_item_desc")+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+(rs.getString("last_update_date")==null?"&nbsp;":rs.getString("last_update_date"))+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+rs.getString("last_updated_by")+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+(rs.getString("previous_update_date")==null?"&nbsp;":rs.getString("previous_update_date"))+"</td>");
					out.println("<td style='font-size:11px;font-family:arial;' align='center'>"+(rs.getString("previous_updated_by")==null?"&nbsp;":rs.getString("previous_updated_by"))+"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();
			}
			catch (Exception e)
			{
				out.println(e.getMessage());
			}
			if (i>0)
			{
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
			}
			else
			{
				out.println("<tr><td>查無資料!!</td></tr>");
			}
%>				
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

