<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}            
.style2 {
	color: #FFFFFF;
	font-weight: bold;
}
</STYLE>
<title>PMD Invoice List Upload and Query</title>
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
<%
String colorStr = "";

String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String WIPNO=request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String INVOICENO=request.getParameter("INVOICENO");
if (INVOICENO==null) INVOICENO="";
String PONO=request.getParameter("PONO");
if (PONO==null) PONO="";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50;
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCPMDInvoiceSummaryReport.jsp" METHOD="post" NAME="MYFORM">
<table cellSpacing='0' bordercolordark="#CCCCCC"  cellPadding='0' width='80%' align='center'>
	<tr><td colspan="3">&nbsp;</td></tr>
	<tr>
		<td height="40" align="center"  valign="bottom"><DIV style="font-weight:bold;color:#4A2231;font-family:標楷體;font-size:28px">PMD發票明細<jsp:getProperty name="rPH" property="pgQuery"/></DIV></td>
		<td width="12%" valign="bottom"><A href="../jsp/TSCPMDInvoiceUpload.jsp" style="font-family:標楷體;font-size:16px;background-color:#E4E4E4">發票明細匯入</A></td>
		<td width="6%" valign="bottom"><A href="/oradds/ORADDSMainMenu.jsp" style="font-family:標楷體;font-size:16px;background-color:#E4E4E4"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr><td height="5" colspan="3" bgcolor="#A7D1B8">&nbsp;</td>
	</tr>
</table>
<table cellSpacing='0' bordercolordark="#CCCCCC"  cellPadding='0' width='80%' align='center' borderColorLight='#ffffff' border='1'>
    <tr>
	    <td width="10%" nowrap style="background-color:#A7D1B8;font-size:12px;font-weight:bold;color:#333333"><jsp:getProperty name="rPH" property="pgVendor"/></td> 
		<td width="30%"><input type="text" name="VENDOR" value="<%=VENDOR%>" size="40" style="font-family:Tahoma,Georgia;"></td>
		<td width="10%" style="background-color:#A7D1B8;font-size:12px;font-weight:bold;color:#333333">工單號碼</td>
	    <td width="20%"><input type="text" name="WIPNO" value="<%=WIPNO%>"  style="font-family:Tahoma,Georgia;"></td>
	    <td width="10%" style="background-color:#A7D1B8;font-size:12px;font-weight:bold;color:#333333">採購單號</td> 
		<td width="20%"><div align="left"><font color="#006666" ><strong> </strong></font><input type="text" name="PONO" value="<%=PONO%>"  style="font-family:Tahoma,Georgia;"></div></td> 
	</tr>
	<tr>
	    <td style="background-color:#A7D1B8;font-size:12px;font-weight:bold;color:#333333"><div align="left"><jsp:getProperty name="rPH" property="pgPart"/>或<jsp:getProperty name="rPH" property="pgItemDesc"/></div></td>
	    <td><input type="text" name="ITEMNAME" size="40" value="<%=ITEMNAME%>"  style="font-family:Tahoma,Georgia;"></td> 
	    <td style="background-color:#A7D1B8;font-size:12px;font-weight:bold;color:#333333">發票號碼</td> 
		<td><div align="left"><font color="#006666" ><strong> </strong></font><input type="text" name="INVOICENO" value="<%=INVOICENO%>"  style="font-family:Tahoma,Georgia;"></div></td> 
		<td colspan="2" align="center"><INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCPMDInvoiceSummaryReport.jsp")' ></td>
   </tr>
</table>  
<%
try
{       	 

	int iCnt = 0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	String sqlw="";
	String sql = " SELECT distinct a.invoice_no, a.vendor_code, a.vendor_site_id, a.vendor_name,"+
                 " a.currency_code, a.tot_amount, a.rate, a.tax, a.invoice_amount,"+
                 " a.created_by, a.creation_date"+
                 " FROM oraddman.tspmd_invoice_headers_all a,oraddman.tspmd_invoice_lines_all b"+
				 " where a.invoice_no = b.invoice_no";
	if (VENDOR!=null && !VENDOR.equals("")) sqlw += " and a.vendor_name like '"+VENDOR+"%'";
	if (WIPNO!=null && !WIPNO.equals("")) sqlw += " and exists (select 1 from oraddman.TSPMD_OEM_HEADERS_ALL c where c.WIP_NO ='"+ WIPNO+"' and c.po_no=b.po_no)";
	if (PONO!=null && !PONO.equals("")) sqlw += " and b.PO_NO ='"+ PONO+"'";
	if (ITEMNAME!=null && !ITEMNAME.equals("")) sqlw += " and (b.item_description like '"+ ITEMNAME +"%' or  b.item_name like '"+ITEMNAME +"%')";
	if (sqlw.length() <=0) sqlw += " and a.creation_date between trunc(sysdate-3) and trunc(sysdate)+0.99999";
	sqlw += " order by a.invoice_no ";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql+sqlw);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
			String sqlt = " select count(1) rowcnt from ("+sql+") ss";
			Statement statement1=con.createStatement(); 
			ResultSet rs1 =statement1.executeQuery(sqlt);
			while (rs1.next())
			{
				//總筆數
				dataCnt = Long.parseLong(rs1.getString("rowcnt"));
				//最後頁數
				LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
			}
			rs1.close();
			statement1.close();
				
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='80%' align='center' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#CC0066' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			if (LastPage==1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}
			else if (NowPage == 1)
			{
				FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
			}
			else if (NowPage == LastPage)
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
			}				
			else
			{
				FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
			}
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDInvoiceSummaryReport.jspjsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDInvoiceSummaryReport.jsp.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDInvoiceSummaryReport.jsp.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDInvoiceSummaryReport.jsp.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");		
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
%> 
 <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
	<tr bgcolor="#9ECBBD"> 
		<td width="4%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;&nbsp;</font></div></td> 
	  	<td width="10%" nowrap><div align="center"><font color="#273D33">發票號碼</font></div></td>
	  	<td width="15%" nowrap><div align="center"><font color="#273D33">供應商</font></div></td>
      	<td width="5%" nowrap><div align="center"><font color="#273D33">幣別</font></div></td>
      	<td width="5%" nowrap><div align="center"><font color="#273D33">匯率</font></div></td> 
	  	<td width="5%" nowrap><div align="center"><font color="#273D33">稅率</font></div></td>                    
	  	<td width="10%" nowrap><div align="center"><font color="#273D33">發票含稅金額</font></div></td>                    
	  	<td width="15%" nowrap><div align="center"><font color="#273D33">原始文件</font></div></td>                    
    </tr>
    <% 
		}
		
		if ((iCnt) > sCnt && (iCnt) <= eCnt)
		{
			if ((showCnt % 2) == 0)
			{
				colorStr = "CCFFCC";
			}
			else
			{
				colorStr = "CCFFFF"; 
			}
    %>
		<tr bgcolor="#E9FEF7"> 
			<td bgcolor="#9ECBBD" align="center" width="4%"><%out.println(iCnt);%></td>
			<td width="9%" align="center" nowrap><A href='../jsp/TSCPMDInvoiceDetail.jsp?INVOICENO=<%=rs.getString("INVOICE_NO")%>' title="點我,可進入明細畫面!"><%=rs.getString("INVOICE_NO")%></A></td>
			<td width="9%" nowrap><%=rs.getString("VENDOR_NAME")%></font></div></td>
			<td width="10%" align="center" nowrap><%=rs.getString("CURRENCY_CODE")%></font></div></td>
			<td width="10%" align="center" nowrap><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("RATE")))%></font></div></td>
			<td width="5%" align="center" nowrap><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("TAX")))%></div></td>
			<td width="10%" align="center" nowrap><%=rs.getString("INVOICE_AMOUNT")%></font></div></td>
			<td>
			<%
				String rootName = "/jsp/PMD_Invoice";
				String rootPath = application.getRealPath(rootName);
				boolean bexist = false;
				File fp = new File(rootPath);
				if (fp.exists()) 
				{  
					String[] list = fp.list();
					for(int j=0; j<list.length;j++)
					{
						File inFp = new File(rootPath + fp.separator + list[j]);
						if (inFp.getName().startsWith(rs.getString("INVOICE_NO")))
						{
							out.println("<div align='center'><img src='images/xls.gif'><font style='font-family:arial;font-size:12px'><a href='.."+rootName+"/"+ list[j]+"' target='_blank'>"+list[j]+"</a></font></div><br>");
							bexist = true;
							break;
						}
					}
					if (list.length==0 || !bexist) out.println("&nbsp;<br>&nbsp;");
				}
				else
				{
					out.println("&nbsp;<br>&nbsp;");
				}
			%>
			</td>
		</tr>
<%
			showCnt++;
		}
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<table width='80%'><tr><td align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></td></tr></table>");
	}
	else
	{
		out.println("</table>");
		out.println("</td>");		
		out.println("</tr>");	
		out.println("</table>");	
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

