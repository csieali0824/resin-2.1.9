<!--20170704 Peggy,新增reel_qty欄位-->
<!--20180511 Peggy,新增供應商欄位-->
<!--20180620 Peggy,add TSC_PARTNO欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAddNew(URL)
{  
	subWin=window.open(URL,"subwin","width=740,height=480,scrollbars=yes,menubar=no");   
}

function setModify(URL)
{
	subWin=window.open(URL,"subwin","width=740,height=480,scrollbars=yes,menubar=no");   
}
function setInactive(URL,STATUS)
{
	var str ="停用";
	if (STATUS=="Y") str ="啟用";
	if (confirm("您確定要將資料狀態改為"+str+"?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}

</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  INPUT     { font-family: Tahoma,Georgia; font-size: 11px }
</STYLE>
<title>宜蘭Hub倉產品材積維護</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCIlanShippingBoxQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:18px;color:#000099">宜蘭Hub倉產品材積維護</font></strong>
<BR>
<%
String TSC_PROD_GROUP = request.getParameter("TSC_PROD_GROUP");
if (TSC_PROD_GROUP==null) TSC_PROD_GROUP="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String PACKING_CODE = request.getParameter("PACKING_CODE");
if (PACKING_CODE==null) PACKING_CODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String CARTON_SIZE= request.getParameter("CARTON_SIZE");
if (CARTON_SIZE==null) CARTON_SIZE="";
String INT_TYPE = request.getParameter("INT_TYPE");
if (INT_TYPE==null) INT_TYPE="";
String Q_TSC_PROD_GROUP = request.getParameter("Q_TSC_PROD_GROUP");
if (Q_TSC_PROD_GROUP==null) Q_TSC_PROD_GROUP="";
String Q_TSC_PACKAGE = request.getParameter("Q_TSC_PACKAGE");
if (Q_TSC_PACKAGE==null) Q_TSC_PACKAGE="";
String Q_PACKING_CODE = request.getParameter("Q_PACKING_CODE");
if (Q_PACKING_CODE==null) Q_PACKING_CODE="";
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE==null) ACTIONCODE="Q";
String STATUS1 = request.getParameter("STATUS1");
if (STATUS1==null) STATUS1="";
String ID=request.getParameter("ID");
if (ID==null) ID="";
String sql = "";


if (ACTIONCODE.equals("CANCEL"))
{
	sql = " update apps.tsc_item_packing_master a"+
				 " set STATUS=?"+
				 ",LAST_UPDATED_BY=?"+
				 ",LAST_UPDATE_DATE=sysdate"+
				 " where ROWID=?";
	PreparedStatement pstmtDt=con.prepareStatement(sql);  
	pstmtDt.setString(1,STATUS);
	pstmtDt.setString(2,UserName);
	pstmtDt.setString(3,ID);
	pstmtDt.executeQuery();
	pstmtDt.close();
	out.println("<script language = 'JavaScript'>");
	out.println("alert('更新完成!')");
	out.println("</script>");
	ACTIONCODE="Q";
}
%>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
	<tr>
		<td width="10%" style="background-color:#D3E6F3;color:#006666">TSC Prod Group:</td>
		<td width="15%">
		<%
	      PreparedStatement statement1 = con.prepareStatement("SELECT a.TSC_PROD_GROUP,TSC_PROD_GROUP TSC_PROD_GROUP1 FROM tsc_item_packing_master a where a.int_type=?  group by TSC_PROD_GROUP order by TSC_PROD_GROUP");
		  statement1.setString(1,"TSC");
		  ResultSet rs1=statement1.executeQuery();		
		  comboBoxBean.setRs(rs1);
	      comboBoxBean.setSelection(Q_TSC_PROD_GROUP);
	      comboBoxBean.setFieldName("Q_TSC_PROD_GROUP");	   
          out.println(comboBoxBean.getRsString());	
		  rs1.close();
		  statement1.close();	
		%>
		</td>
		<td width="7%" style="background-color:#D3E6F3;color:#006666">TSC Package</td>
		<td width="10%">
		<%
	      statement1 = con.prepareStatement("SELECT TSC_PACKAGE,TSC_PACKAGE TSC_PACKAGE1 FROM tsc_item_packing_master a where a.int_type=? group by TSC_PACKAGE order by TSC_PACKAGE");
		  statement1.setString(1,"TSC");
		  rs1=statement1.executeQuery();		
		  comboBoxBean.setRs(rs1);
	      comboBoxBean.setSelection(Q_TSC_PACKAGE);
	      comboBoxBean.setFieldName("Q_TSC_PACKAGE");	   
          out.println(comboBoxBean.getRsString());		
		  rs1.close();
		  statement1.close();	
		%>
		</td>		
		<td width="7%" style="background-color:#D3E6F3;color:#006666">Packing Code</td>
		<td width="10%"><input type="text" name="Q_PACKING_CODE" value="<%=Q_PACKING_CODE%>" style="font-family: Tahoma,Georgia; font-size: 11px"></td>
		<td width="7%" style="background-color:#D3E6F3;color:#006666">狀態</td>
		<td width="10%">
		<select NAME="STATUS1" style="Tahoma,Georgia; font-size: 11px ">
		<OPTION VALUE=-- <%if (STATUS1.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="Y" <%if (STATUS1.equals("Y")) out.println("selected");%>>啟用</OPTION>
		<OPTION VALUE="N" <%if (STATUS1.equals("N")) out.println("selected");%>>停用</OPTION>
		</select>
		</td>
		<td width="22%">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCIlanShippingBoxQuery.jsp?ACTIONCODE=Q")' >
			&nbsp;&nbsp;&nbsp;
			<INPUT TYPE='button' id='AddNew' value='新增' onClick='setAddNew("../jsp/TSCIlanShippingBoxSetup.jsp")'>
		</td>  
	</tr>
</table> 
<%
if (ACTIONCODE.equals("Q"))
{
	try
	{
		sql = " select a.rowid,a.tsc_prod_group, a.tsc_package, a.packing_code, a.def_flag,"+
              " a.inner_qty, a.carton_qty, a.carton_size, a.carton_no, a.gw,"+
              " a.nw, a.creation_date, a.creation_by, a.attribute1, a.attribute2,"+
              " a.attribute3, a.int_type, a.status,"+
              " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date,a.reel_qty"+
			  ",a.vendor_id,b.segment1 vendor_code,b.vendor_name ,a.TSC_PARTNO"+ //add by Peggy 20180511
			  "  from tsc_item_packing_master a,ap_suppliers b"+
			  " Where a.INT_TYPE='TSC'"+
			  " and a.vendor_id=b.vendor_id(+)";
		if (!Q_TSC_PROD_GROUP.equals("") && !Q_TSC_PROD_GROUP.equals("--"))
		{
			sql += " and a.TSC_PROD_GROUP='"+ Q_TSC_PROD_GROUP+"'";
		}
		if (!Q_TSC_PACKAGE.equals("") && !Q_TSC_PACKAGE.equals("--"))
		{
			sql += " and a.TSC_PACKAGE='"+ Q_TSC_PACKAGE+"'";
		}	
		if (!Q_PACKING_CODE.equals(""))
		{
			sql += " and a.PACKING_CODE LIKE '"+ Q_PACKING_CODE+"%'";
		}
		if (!STATUS1.equals("") && !STATUS1.equals("--"))
		{
			sql += " and a.STATUS='"+ STATUS1+"'";
		}	
		sql += " order by a.tsc_prod_group, a.tsc_package,SUBSTR(a.packing_code,1,2),INNER_QTY,CARTON_QTY, length(a.packing_code)";
		//out.println(sql);
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery(sql);  
		int i=0;
		while (rs.next())
		{
			i++;
			if (i==1)
			{
%>
				<hr>
				<div align="left" style="color:#0000FF">數量單位:PCS</div>
				<table cellspacing="0" bordercolordark="#FFFFFF" cellpadding="1" width="100%" align="center" bordercolorlight="#CCCC99" border="1">
					<tr bgcolor="#C8E3E8">
						<td align="center" width="7%">&nbsp;</td>
						<td align="center" width="3%">項次</td>
						<td align="center" width="5%">TSC Prod Group</td>
						<td align="center" width="7%">TSC Package</td>
						<td align="center" width="4%">Packing Code</td>
						<td align="center" width="5%">Reel Qty</td>
						<td align="center" width="5%">Inner Qty</td>
						<td align="center" width="5%">Carton Qty</td>
						<td align="center" width="6%">Carton Size</td>
						<td align="center" width="4%">Net Weight</td>
						<td align="center" width="4%">Gross Weight</td>
						<td align="center" width="9%">供應商</td>
						<td align="center" width="9%">品名</td>
						<td align="center" width="9%">備註</td>
						<td align="center" width="4%">狀態</td>
						<td align="center" width="6%">最近異動者</td>
						<td align="center" width="8%">最近異動日</td>
					</tr>
<%
			}
			out.println("<tr>");
			out.println("<td align='center'>");
			out.println("<input type='button' id='UPD"+i+"' value='修改' onclick='setModify("+'"'+"../jsp/TSCIlanShippingBoxSetup.jsp?ACTIONMODE=MODIFY&ID="+java.net.URLEncoder.encode(rs.getString("ROWID"))+'"'+")'>");
			out.println("<input type='button' id='CANCEL"+i+"' value='"+(rs.getString("STATUS").equals("Y")?"停用":"啟用")+"' onclick='setInactive("+'"'+"../jsp/TSCIlanShippingBoxQuery.jsp?ACTIONCODE=CANCEL&ID="+java.net.URLEncoder.encode(rs.getString("ROWID"))+"&STATUS="+(rs.getString("STATUS").equals("Y")?"N":"Y")+ '"'+","+'"'+(rs.getString("STATUS").equals("Y")?"N":"Y")+'"'+")'>");
			out.println("</td>");
			out.println("<td>"+i+"</td>");
			out.println("<td>"+rs.getString("TSC_PROD_GROUP")+"</td>");
			out.println("<td>"+rs.getString("TSC_PACKAGE")+"</td>");
			out.println("<td>"+rs.getString("PACKING_CODE")+"</td>");
			out.println("<td align='right'>"+(rs.getString("REEL_QTY")==null?"&nbsp;":rs.getString("REEL_QTY"))+"</td>");
			out.println("<td align='right'>"+(rs.getString("INNER_QTY")==null?"&nbsp;":rs.getString("INNER_QTY"))+"</td>");
			out.println("<td align='right'>"+rs.getString("CARTON_QTY")+"</td>");
			out.println("<td>"+(rs.getString("CARTON_SIZE")==null?"&nbsp;":rs.getString("CARTON_SIZE"))+"</td>");
			out.println("<td align='right'>"+(rs.getString("NW")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("NW"))))+"</td>");
			out.println("<td align='right'>"+(rs.getString("GW")==null?"&nbsp;":(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("GW"))))+"</td>");
			out.println("<td>"+(rs.getString("vendor_code")==null?"&nbsp;":rs.getString("vendor_code")+" "+rs.getString("vendor_name"))+"</td>");
			out.println("<td>"+(rs.getString("TSC_PARTNO")==null?"&nbsp;":rs.getString("TSC_PARTNO"))+"</td>");
			out.println("<td>"+(rs.getString("ATTRIBUTE1")==null?"&nbsp;":rs.getString("ATTRIBUTE1"))+"</td>");
			out.println("<td align='center'>"+(rs.getString("STATUS").equals("Y")?"<font color='blue'>啟用</font>":"<font color='red'>停用</font>")+"</td>");
			out.println("<td align='center'>"+(rs.getString("last_updated_by")==null?"&nbsp;":rs.getString("last_updated_by"))+"</td>");
			out.println("<td align='center'>"+(rs.getString("last_update_date")==null?"&nbsp;":rs.getString("last_update_date"))+"</td>");
			out.println("</tr>");
		}
		rs.close();
		statement.close();
		if (i>0)
		{
		%>
					</table>
		<%
		}
		else
		{
			out.println("<div align='center' style='color:#ff0000'>查無資料!!</div>");
		}
	}
	catch (Exception e)
	{
		out.println(e.getMessage());
	}
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

