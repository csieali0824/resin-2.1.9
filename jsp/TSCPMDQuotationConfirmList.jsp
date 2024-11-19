<!-- 20161104 Peggy,新增prd 外包-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ArrayComboBoxBean,DateBean,QueryAllRepairBean"%>
<html>
<head>
<title>Query unApprove Request Order List</title>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=============以下區段為等待畫面==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============以上區段為等待畫面==========-->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="queryAllRepairBean" scope="application" class="QueryAllRepairBean"/>
<style type="text/css">
 .style1   {
	font-family:Arial;
	font-size:12px;
	background-color:#D7F4E6;
	text-align:left;
}
</style>
<script language="JavaScript" type="text/JavaScript">
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
</script>
<%   
String pageURL=request.getParameter("PAGEURL");
String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
String queryDateFrom="",queryDateTo=""; 
String fromYear=request.getParameter("FROMYEAR");  
if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
String fromMonth=request.getParameter("FROMMONTH"); 
if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
String fromDay=request.getParameter("FROMDAY");
if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
queryDateFrom=fromYearString+fromMonthString+fromDayString;
String toYear=request.getParameter("TOYEAR");
if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
String toMonth=request.getParameter("TOMONTH");
if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
String toDay=request.getParameter("TODAY");
if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 20;
%>
<body>
<FORM NAME="MYFORM" METHOD="POST"> 
<font color="#000000" size="4" face="標楷體"><strong>外包PO單價待核淮明細(狀態:Submit)</strong></FONT>
<br>
<font color="#000000" size="2" face="細明體"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></font>
<br>
<table width="100%">
	<tr>
		<td>
			<table TABLE cellSpacing='0' bordercolordark='#99CC99' cellPadding='0' width='80%' align='left' borderColorLight='#FFFFFF' border='1'>
				<tr>
					<td height="38" class="style1">&nbsp;&nbsp;
<jsp:getProperty name="rPH" property="pgCreateFormDate"/>
:FROM
<%
try
{	   
	int  j =0; 
	String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
	for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
	{
		a[j++] = ""+i; 
	}
    arrayComboBoxBean.setArrayString(a);
	if (fromYear!=null)
	{
		arrayComboBoxBean.setSelection(fromYearString);
	}
	arrayComboBoxBean.setFieldName("FROMYEAR");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
} //end of try
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
/
<%
try
{       
	int  j =0; 
	String b[]= new String[12];
	for (int i =1;i <= 12;i++)
	{
		if (i <10)	b[j++] = "0"+i;
		else b[j++] = ""+i;		
	}
    arrayComboBoxBean.setArrayString(b);
	if (fromMonth!=null)
	{
		arrayComboBoxBean.setSelection(fromMonth);
	}
	arrayComboBoxBean.setFieldName("FROMMONTH");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
}
catch (Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
/
<%
try
{       
	int  j =0; 
	String c[]= new String[31];
	for (int i =1;i <= 31;i++)
	{
		if (i <10)	c[j++] = "0"+i;
		else c[j++] = ""+i;		
	}	
    arrayComboBoxBean.setArrayString(c);
	if (fromDay!=null)
	{
    	arrayComboBoxBean.setSelection(fromDay);
	}
	arrayComboBoxBean.setFieldName("FROMDAY");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
} 
catch (Exception e)
{
	out.println("Exception3:"+e.getMessage());
}
%>
~
TO
<%
try
{	   
	int  j =0; 
	String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
	for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
	{
		a[j++] = ""+i; 
	}
    arrayComboBoxBean.setArrayString(a);
	if (toYear!=null)
	{
		arrayComboBoxBean.setSelection(toYear);
	}
	arrayComboBoxBean.setFieldName("TOYEAR");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
} //end of try
catch (Exception e)
{
	out.println("Exception4:"+e.getMessage());
}
%>
/
<%
try
{       
	int  j =0; 
	String b[]= new String[12];
	for (int i =1;i <= 12;i++)
	{
		if (i <10)	b[j++] = "0"+i;
		else b[j++] = ""+i;		
	}
    arrayComboBoxBean.setArrayString(b);
	if (toMonth!=null)
	{
		arrayComboBoxBean.setSelection(toMonth);
	}
	arrayComboBoxBean.setFieldName("TOMONTH");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
}
catch (Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
/
<%
try
{       
	int  j =0; 
	String c[]= new String[31];
	for (int i =1;i <= 31;i++)
	{
		if (i <10)	c[j++] = "0"+i;
		else c[j++] = ""+i;		
	}	
    arrayComboBoxBean.setArrayString(c);
	if (toDay!=null)
	{
    	arrayComboBoxBean.setSelection(toDay);
	}
	arrayComboBoxBean.setFieldName("TODAY");	   
    out.println(arrayComboBoxBean.getArrayString());		      		 
} 
catch (Exception e)
{
	out.println("Exception3:"+e.getMessage());
}
%>
&nbsp;&nbsp;&nbsp;<input type="button" name="Search" value="Search" onClick="sendSubmit('../jsp/TSCPMDQuotationConfirmList.jsp')">
				  </td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%
try
{
	int iCnt = 0,pagewidth=0,LastPage =0;
	String sql = "",sqlt = "";
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
   	Statement statement=con.createStatement(); 
	sql =  " SELECT distinct a.request_no \"申請單號\",'('|| a.vendor_code||') ' || a.vendor_name \"廠商名稱\", a.currency_code \"幣別\","+
	       " to_char(a.creation_date,'yyyy-mm-dd hh24:mi') \"申請日期\", a.created_by_name \"申請人\", "+
           " a.status \"申請狀態\" ,a.NEXT_WKFLOW FROM oraddman.tspmd_quotation_headers_all a,oraddman.tspmd_quotation_lines_all b"+
		   " where a.request_no = b.request_no and a.status not in ('Cancelled','Reject','Closed','Approved') ";
	if (!UserRoles.startsWith("admin"))
	{
		sql += "and exists (SELECT 1  FROM oraddman.wsgroupuserrole x, oraddman.tspmd_data_type_tbl y"+
           " where x.GROUPUSERNAME='"+UserName+"' and y.data_type='F2_ROLE'  AND x.rolename = y.TYPE_NAME  and y.TYPE_NO=a.NEXT_WKFLOW)";
	}
	if (!queryDateFrom.equals("")) sql += " and to_char(a.creation_date,'yyyymmdd') >='"+ queryDateFrom+"'";
	if (!queryDateTo.equals("")) sql += " and to_char(a.creation_date,'yyyymmdd') <='"+ queryDateTo+"'";
	sql +=  " order by  a.request_no";
	//out.println(sql);
	ResultSet rs=statement.executeQuery(sql);
	int colCount=0,showCnt=0;
	String backgroundcolor = "";
	while (rs.next()) 
	{ 	
		if (iCnt == 0)
		{	
			sqlt = " select count(1) rowcnt from ("+sql+") ss";
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
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='80%' align='left' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#993366' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
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
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationConfirmList.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationConfirmList.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#993366' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationConfirmList.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDQuotationConfirmList.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
			ResultSetMetaData md=rs.getMetaData();
			colCount=md.getColumnCount();
			String colLabel[]=new String[colCount+1]; 
			out.println("<TABLE cellSpacing='0' bordercolordark='#99CC99' cellPadding='0' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");      
			out.println("<TR bgcolor='#CAF4F7'>");  
			for (int i=1;i<=colCount-1;i++) 
			{
				colLabel[i]=md.getColumnLabel(i);
				out.println("<TD style='font-family:arial;font-size:12px;color=#000000'><div align='center'>"+colLabel[i]+"</div></TD>");
			} 
			out.println("</TR>");
		}

		if ((iCnt+1) > sCnt && (iCnt+1) <= eCnt)
		{
			if ((showCnt%2) ==1)
			{
				backgroundcolor="#FFFFFF";
			}
			else
			{
				backgroundcolor="#FFFFFF";
			}
			for (int i=1;i<=colCount-1;i++) 
			{
				if (i ==1)
				{
					out.println("<TR onmouseover=bgColor='#FFCCFF' onmouseout=bgColor='#FFFFFF' title='按下滑鼠左鍵,進入核淮畫面!' onclick=javascript:location.href='../jsp/TSCPMDQuotationConfirm.jsp?REQUESTNO="+rs.getString(i)+"&THISWKFLOW="+rs.getString("NEXT_WKFLOW")+"' >");    
				}
				out.println("<TD style='font-family:arial;font-size:12px'><div align='center'>"+rs.getString(i)+"</div></TD>");
			} 
			out.println("</TR>");
			showCnt++;
		}
		iCnt ++;
	}
	if (iCnt >0)
	{
		out.println("</table>");
		out.println("</td>");
		out.println("</tr>");		
		out.println("</table>");
	}
	else
	{
		out.println("<font face='細明體' size='2' color='red'>查無相關資料,請重新輸入日期條件,謝謝!</font>");
	}
}
catch(Exception e)
{	
	out.println("Exception8:"+e.getMessage());
}	
%>
</FORM>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
