<!-- 20161007 Peggy,新增英文版加工單-->
<!-- 20161107 Peggy,新增prd 外包-->
<!-- 20170817 Peggy,新增工單補發料功能-->
<!-- 20171016 Peggy,新增RD3工程入庫交易顯示-->
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
function changeURL(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function changeEvent()
{
	var docNo = document.MYFORM.REQUESTNO.value;
	if (docNo.length >=3)
	{
		var year = docNo.substring(1,3);
		var year = "20"+year;
		try
		{
			document.MYFORM.YEARFR.value = year;
			document.MYFORM.YEARTO.value = "--";
		}
		catch(err)
		{
			document.MYFORM.YEARFR.value = "--";
			document.MYFORM.YEARTO.value = "--";
		}
	}
	if (docNo.length >=5)
	{
		var months = docNo.substring(3,5);
		try
		{
			document.MYFORM.MONTHFR.value = months;
			document.MYFORM.MONTHTO.value = "--";
		}
		catch(err)
		{
			document.MYFORM.MONTHFR.value = "--";
			document.MYFORM.MONTHTO.value = "--";
		}
	}
	if (docNo.length >=7)
	{
		var day = docNo.substring(5,7);
		try
		{
			document.MYFORM.DAYFR.value = day;
			document.MYFORM.DAYTO.value = "--";
		}
		catch(err)
		{
			document.MYFORM.DAYFR.value = "--";
			document.MYFORM.DAYTO.value = "--";
		}
	}	
	return;
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
<title>Oracle Add On System Information Query</title>
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

String dateStartType="";
String dateEndType="";
String YearFr=request.getParameter("YEARFR");
dateBean.setAdjDate(-7);
if (YearFr ==null) YearFr = dateBean.getYearString();
if (YearFr.equals("--")){YearFr ="";}else{dateStartType +="yyyy";}
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr ==null) MonthFr = dateBean.getMonthString();
if (MonthFr.equals("--")){MonthFr ="";}else{	dateStartType +="mm";}
String DayFr=request.getParameter("DAYFR");
if (DayFr == null) DayFr = dateBean.getDayString();
if (DayFr.equals("--")){DayFr ="";}else{dateStartType +="dd";}
String dateSetBegin=YearFr+MonthFr+DayFr;  
dateSetBegin.replace("--","");
dateBean.setAdjDate(7);
String YearTo=request.getParameter("YEARTO");
if (YearTo == null) YearTo = dateBean.getYearString();
if (YearTo.equals("--")){YearTo ="";}else{dateEndType +="yyyy";}
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo ==null) MonthTo = dateBean.getMonthString();
if (MonthTo.equals("--") ){MonthTo ="";}else{dateEndType +="mm";}
String DayTo=request.getParameter("DAYTO");
if (DayTo == null) DayTo = dateBean.getDayString();
if (DayTo.equals("--")){DayTo ="";}else{ dateEndType +="dd";}
String dateSetEnd = YearTo+MonthTo+DayTo; 
dateSetEnd.replace("--","");
String VENDOR=request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String WIPTYPE=request.getParameter("WIPTYPE");
if (WIPTYPE==null) WIPTYPE="";
String WIPNO=request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String REQUESTNO=request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String PRNO=request.getParameter("PRNO");
if (PRNO==null) PRNO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50;
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCPMDOEMInformationQuery.jsp" METHOD="post" NAME="MYFORM">
<font color="#006666" size="+2" face="Times New Roman"> 
<strong>委外加工單<jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td width="10%" colspan="1" nowrap><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgVendor"/></strong></font></td> 
		<td width="20%"><input type="text" name="VENDOR" value="<%=VENDOR%>" size="30" style="font-family:Tahoma,Georgia;"></td>
		<td width="10%"><font color="#006666" ><strong>工單類型</strong></font></td>   
		<td width="10%" colspan="1" nowrap><div align="left">   
<%
	try
	{   
		Statement statement=con.createStatement();
		String sql = " select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
					 " where DATA_TYPE='WIP' AND NVL(STATUS_FLAG,'I') = 'A' "; 
		ResultSet rs=statement.executeQuery(sql);
		out.println("<select NAME='WIPTYPE'  style='font-family:Tahoma,Georgia;'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
			if (s1==WIPTYPE || s1.equals(WIPTYPE)) 
			{
				out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
			} 
			else 
			{
				out.println("<OPTION VALUE='"+s1+"'>"+s2);
			}        
		} 
		out.println("</select>"); 
		statement.close();		  		  
		rs.close();        	 
	} 
	catch (Exception e) 
	{ 
		out.println("Exception1:"+e.getMessage()); 
	} 		
%>
		</div></td>    
		<td width="10%"><font color="#006666" ><strong>工單號碼</strong></font></td>
	    <td width="10%"><input type="text" name="WIPNO" value="<%=WIPNO%>"  style="font-family:Tahoma,Georgia;"></td>
	</tr>
	<TR>
	    <td><div align="left"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgPart"/>或<jsp:getProperty name="rPH" property="pgItemDesc"/></strong></font></div></td>
	    <td><input type="text" name="ITEMNAME" size="30" value="<%=ITEMNAME%>"  style="font-family:Tahoma,Georgia;"></td> 
	    <td nowrap colspan="1"><font color="#006666" ><strong>申請單號</strong></font></td> 
		<td><div align="left"><font color="#006666" ><strong> </strong></font><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>"  style="font-family:Tahoma,Georgia;" onKeyUp="changeEvent()"></div></td> 
	    <td nowrap colspan="1"><font color="#006666" ><strong>請購單號</strong></font></td> 
		<td><div align="left"><font color="#006666" ><strong> </strong></font><input type="text" name="PRNO" value="<%=PRNO%>"  style="font-family:Tahoma,Georgia;"></div></td> 
	</tr>
	<tr>
		<td nowrap><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font></td>
		<td nowrap><font color="#006666" >
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
		if (YearFr==null)
		{
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(YearFr);
		}
		arrayComboBoxBean.setFieldName("YEARFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
		  
	String CurrMonth = null;	     		 
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
	  	if (MonthFr==null)
	  	{
			CurrMonth=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonth);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthFr);
	  	}
		arrayComboBoxBean.setFieldName("MONTHFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception2:"+e.getMessage());
    }

	String CurrDay = null;	     		 
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
		if (DayFr==null)
		{
			CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(DayFr);
		}
		arrayComboBoxBean.setFieldName("DAYFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}	
%>
		~</strong></font>
<%
	String CurrYearTo = null;	     		 
	try
    {  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
	  	if (YearTo==null)
	  	{
			CurrYearTo=dateBean.getYearString();
			arrayComboBoxBean.setSelection(CurrYearTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(YearTo);
	  	}
		arrayComboBoxBean.setFieldName("YEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
	}
    catch (Exception e)
    {
    	out.println("Exception4:"+e.getMessage());
    }
	
	String CurrMonthTo = null;	     		 
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
	  	if (MonthTo==null)
	  	{
			CurrMonthTo=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonthTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthTo);
	  	}
		arrayComboBoxBean.setFieldName("MONTHTO");	   
		out.println(arrayComboBoxBean.getArrayString());		    
	}
	catch (Exception e)
	{
		out.println("Exception5:"+e.getMessage());
	}
	
	String CurrDayTo = null;	     		 
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
		if (DayTo==null)
		{
			CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(DayTo);
		}
		arrayComboBoxBean.setFieldName("DAYTO");	   
    	out.println(arrayComboBoxBean.getArrayString());	
	}
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
%>    
		</td>  
		<td width="10%"><font color="#006666" ><strong>申請狀態</strong></font></td>   
		<td width="10%" colspan="1" nowrap><div align="left">   
<%
	try
	{   
		Statement statement=con.createStatement();
		String sql = " select TYPE_NO, TYPE_NAME  from ORADDMAN.TSPMD_DATA_TYPE_TBL "+
					 " where DATA_TYPE='STATUS' AND NVL(STATUS_FLAG,'I') = 'A' "; 
		ResultSet rs=statement.executeQuery(sql);
		out.println("<select NAME='STATUS' style='font-family:ARIAL'>");
		out.println("<OPTION VALUE=-->--");     
		while (rs.next())
		{            
			String s1=(String)rs.getString(1); 
			String s2=(String)rs.getString(2); 
			if (s1==STATUS || s1.equals(STATUS)) 
			{
				out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);					   
			} 
			else 
			{
				out.println("<OPTION VALUE='"+s1+"'>"+s2);
			}        
		} 
		out.println("</select>"); 
		statement.close();		  		  
		rs.close();        	 
	} 
	catch (Exception e) 
	{ 
		out.println("Exception1:"+e.getMessage()); 
	} 		
%>
		</div></td>    
		<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCPMDOEMInformationQuery.jsp")' > 
		</td>
   </tr>
</table>  
<%
try
{       	 

	int iCnt = 0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	String sql = " SELECT a.request_no||'-'||a.version_id request_no, b.type_name wip_name, a.vendor_name,"+
             " a.request_date, a.inventory_item_name, a.item_description, "+
             " a.die_name, a.quantity, a.unit_price,a.wip_no, a.pr_no, "+
			 " a.status, to_char(a.creation_date,'yyyymmdd') creation_date,"+
             " a.created_by_name, to_char(a.approve_date,'yyyymmdd') approve_date, a.approved_by_name,"+
             " (select count(1) from oraddman.tspmd_oem_lines_all c where c.request_no=a.request_no) total_cnt"+
			 //",(SELECT p.segment1  FROM  po.po_requisition_headers_all m, po.po_requisition_lines_all n,po.po_line_locations_all o, po.po_headers_all p"+
             //" where m.segment1 = a.pr_no and m.requisition_header_id=n.requisition_header_id(+) and n.line_location_id=o.line_location_id(+) and o.po_header_id=p.po_header_id(+)) PO_NO "+
			 " ,a.po_no"+
			 " ,NVL(c.status_type,'3') status_type ,NVL(a.LOCK_FLAG,'N') LOCK_FLAG,a.CURRENCY_CODE,nvl(WIP_MTL_STATUS,'') WIP_MTL_STATUS "+
			 " ,a.tsc_prod_group"+
	    	 //" ,nvl(a.WIP_ISSUE_PENDING_FLAG,'N') WIP_ISSUE_PENDING_FLAG"+  //add by Peggy 20170822
			 ",NVL((SELECT distinct 'Y' from oraddman.tspmd_oem_lines_all x where x.request_no=a.request_no and x.version_id=a.version_id and NVL(x.WIP_ISSUE_PENDING_FLAG,'Y')='Y'),'N')  WIP_ISSUE_PENDING_FLAG"+ //add by Peggy 20180529
			 ",a.VENDOR_CODE"+ //add by Peggy 20221026
			 ",a.subinventory_code"+ //add by Peggy 20230718
             " FROM oraddman.tspmd_oem_headers_all a,oraddman.tspmd_data_type_tbl b,wip.wip_discrete_jobs c"+
             " where a.wip_type_no=b.type_no"+
			 " and a.wip_entity_id = c.wip_entity_id(+)"+
             " and b.data_type='WIP' ";
	if (VENDOR!=null && !VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR+"%'";
	if (WIPTYPE!=null && !WIPTYPE.equals("") && !WIPTYPE.equals("--")) sql += " and a.WIP_TYPE_NO ='"+WIPTYPE+"'";
	if (WIPNO!=null && !WIPNO.equals("")) sql += " and a.WIP_NO ='"+ WIPNO+"'";
	if (REQUESTNO!=null && !REQUESTNO.equals("")) sql += " and a.REQUEST_NO LIKE '"+REQUESTNO+"%'";
	if (PRNO!=null && !PRNO.equals("")) sql += " and a.PR_NO ='"+ PRNO+"'";
	if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) sql += " and a.STATUS='"+ STATUS+"'";
	if (ITEMNAME!=null && !ITEMNAME.equals("")) sql += " and (a.item_description like '"+ ITEMNAME +"%' or  a.inventory_item_name like '"+ITEMNAME +"%')";
	if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and to_char(a.creation_date,'"+dateStartType+"') >='"+dateSetBegin+"'";
	if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and to_char(a.creation_date,'"+dateEndType+"') <='"+dateSetEnd+"'";
	sql += " order by a.request_no,a.version_id ";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
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
				
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#CC0066' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
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
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMInformationQuery.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMInformationQuery.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMInformationQuery.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSCPMDOEMInformationQuery.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");		
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
%> 
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF"> 
	<tr bgcolor="#99CCFF"> 
		<td width="4%" height="22" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;&nbsp;</font></div></td> 
		<td width="4%" nowrap><div align="center"><font color="#000000" >&nbsp;&nbsp;&nbsp;&nbsp;</font></div></td> 
	  	<td width="9%" nowrap><div align="center"><font color="#006666">申請單號</font></div></td>
	  	<td width="9%" nowrap><div align="center"><font color="#006666">工單類型</font></div></td>
      	<td width="28%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>            
      	<td width="8%" nowrap><div align="center"><font color="#006666">狀態</font></div></td>
      	<!--<td width="10%" nowrap><div align="center"><font color="#006666">開單者</font></div></td> -->
      	<!--<td width="10%" nowrap><div align="center"><font color="#006666">核淮日</font></div></td> -->
      	<!--<td width="10%" nowrap><div align="center"><font color="#006666">核淮者</font></div></td> -->
      	<td width="8%" nowrap><div align="center"><font color="#006666">工單號碼</font></div></td> 
      	<td width="5%" nowrap><div align="center"><font color="#006666">領(退)料狀態</font></div></td> 
	  	<td width="8%" nowrap><div align="center"><font color="#006666">請購單號</font></div></td>                    
	  	<td width="8%" nowrap><div align="center"><font color="#006666">採購單號</font></div></td>                    
	  	<td width="8%" nowrap><div align="center"><font color="#006666">下載(中/英文)</font></div></td>                    
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
		<tr bgcolor="<%=colorStr%>"> 
			<td bgcolor="#99CCFF" width="4%"><div align="center"><font  color="#006666"><%out.println(iCnt);%></font></div></td>
			<td width="5%" nowrap>
			<%
				
				if (rs.getString("STATUS").equals("Reject") && rs.getString("LOCK_FLAG").equals("N")) //Released
				{
					btnCnt ++;
				%>
					<div align="center" title="點我,可進入修改功能!"><A href='../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE=MODIFY&REQUESTNO=<%=rs.getString("REQUEST_NO")%>'>退件<BR>處理</A></div>
				<%
				}
				else if (rs.getString("WIP_MTL_STATUS") != null && rs.getString("WIP_MTL_STATUS").equals("S") && rs.getString("STATUS").equals("Approved") && rs.getString("LOCK_FLAG").equals("N") && (rs.getString("status_type").equals("3") || rs.getString("status_type").equals("4"))) //Released
				{
					btnCnt ++;
				%>
					<div align="center" title="點我,可進入工單變更功能!"><A href='../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE=CHANGE&REQUESTNO=<%=rs.getString("REQUEST_NO")%>'>工單<BR>變更</A></div>
				<%
				}
				else if (rs.getString("WIP_MTL_STATUS") == null && rs.getString("WIP_ISSUE_PENDING_FLAG").equals("Y") && rs.getString("STATUS").equals("Approved") && rs.getString("LOCK_FLAG").equals("N") && (rs.getString("status_type").equals("3") || rs.getString("status_type").equals("4"))) //Released
				{
					btnCnt ++;
				%>
					<div align="center" title="點我,可進入工單變更功能!"><A href='../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE=CHANGE&REQUESTNO=<%=rs.getString("REQUEST_NO")%>'>工單<BR>變更</A></div><br>
					<div align="center" title="點我,可進入工單發料功能!"><A href='../jsp/TSCPMDOEMModify.jsp?ACTIONTYPE=WIPISSUE&REQUESTNO=<%=rs.getString("REQUEST_NO")%>'>工單<BR>發料</A></div>
				<%
				}
				else
				{
				%>
				&nbsp;&nbsp;
				<%
				}
			%>
			</td>
			<td width="9%" nowrap><div align="center" title="點我,可進入申請明細畫面!"><font  color="#006666"><A href='../jsp/TSCPMDOEMInformationDetail.jsp?REQUESTNO=<%=rs.getString("REQUEST_NO")%>'><%=rs.getString("REQUEST_NO")%></A></font></div></td>
			<td width="9%" nowrap><div align="center"><font  color="#006666"><%=rs.getString("WIP_NAME")%></font></div></td>
			<td width="40%" nowrap><font  color="#006666">
	<% 
			out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");			 
			out.println("<tr><td colspan=10><font color='#CC0066'>"); 							   
	%><jsp:getProperty name="rPH" property="pgVendor"/><%
			out.println(" : "+rs.getString("VENDOR_NAME")+"&nbsp;&nbsp;&nbsp;幣別");
			out.println(" : "+rs.getString("CURRENCY_CODE")+"&nbsp;&nbsp;&nbsp;Issue Date");
			out.println(" : "+rs.getString("request_date")+"&nbsp;&nbsp;&nbsp;開單人");				           
			out.println(" : "+rs.getString("created_by_name")+"&nbsp;&nbsp;&nbsp;核淮人");				           
			out.println(" : "+(rs.getString("approved_by_name")==null?"N/A":rs.getString("approved_by_name"))+"&nbsp;&nbsp;&nbsp;倉別");	
			out.println(" : "+(rs.getString("subinventory_code")==null?"":rs.getString("subinventory_code")));							           
			out.println("</font></td></tr>");
			int iRow = 0; 	
								   
			//String sqld = " SELECT a.request_no, a.version_id,a.line_no, a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, a.completion_date,a.inventory_item_name issue_item "+
			//              " FROM oraddman.tspmd_oem_lines_all a"+
			//              " where a.request_no||'-'||a.version_id='"+ rs.getString("REQUEST_NO")+"' order by a.line_no";	
			//modify by Peggy 20171016,show "研發領退料(RD3)"		
			String sqld = " SELECT a.request_no, a.version_id,a.line_no, a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, a.completion_date,a.inventory_item_name issue_item  ,a.transactions_type_id,b.type_name transactions_type_name,a.dc_yyww"+
			              " FROM oraddman.tspmd_oem_lines_all a,(SELECT type_no, type_name FROM oraddman.tspmd_data_type_tbl WHERE data_type='SOURCE_ID') b"+
						  " where a.request_no||'-'||a.version_id='"+ rs.getString("REQUEST_NO")+"' and a.transaction_source_id=b.type_no(+) order by a.line_no";				   
			Statement stated=con.createStatement();
			ResultSet rsd=stated.executeQuery(sqld); 							  
			while (rsd.next())
			{ 
				if (iRow==0 )
				{ 
					out.println("<tr align='center' bgcolor='#990099'>");
					out.println("<td width='15%' nowrap><font color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgPart"/><%								
					out.println("</font></td><td width='10%' nowrap><font color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgItemDesc"/><%								
					out.println("</font></td><td width='3%' nowrap><font color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgAnItem"/><%
					out.println("</font></td><td width='15%' nowrap><font color='#FFFFFF'>發料項目");
					out.println("</font></td><td width='12%' nowrap><font color='#FFFFFF'>Wafer Lot#");
					out.println("</font></td><td width='8%' nowrap><font color='#FFFFFF'>Wafer Qty");
					out.println("</font></td><td width='8%' nowrap><font color='#FFFFFF'>Chip Qty");
					out.println("</font></td><td width='8%' nowrap><font color='#FFFFFF'>Date Code");								
					out.println("</font></td><td width='8%' nowrap><font color='#FFFFFF'>DC YYWW");								
					out.println("</font></td><td width='8%' nowrap><font color='#FFFFFF'>Request S/D");
					out.println("</font></td><td width='7%' nowrap><font color='#FFFFFF'>雜收交易");
					out.println("</font></td></tr>");
					
					out.println("<tr bgcolor="+colorStr+">");
					out.println("<td nowrap rowspan="+rs.getString("total_cnt")+"><font color='#006666'>"+rs.getString("INVENTORY_ITEM_NAME")+"</font></td>");								
					out.println("<td nowrap rowspan="+rs.getString("total_cnt")+"><font color='#006666'>"+rs.getString("ITEM_DESCRIPTION")+"</font></td>");
					out.println("<td nowrap><font color='#006666'>"+rsd.getString("line_no")+"</font></td>");
					out.println("<td nowrap><font color='#006666'>"+rsd.getString("ISSUE_ITEM")+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+((rsd.getString("lot_number")==null || rsd.getString("lot_number").equals("null"))?"&nbsp;":rsd.getString("lot_number"))+"</font></td>");
					//out.println("<td nowrap align='right'><font color='#006666'>"+(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rsd.getString("wafer_qty")))+"</font></td>");
					//out.println("<td nowrap align='right'><font color='#006666'>"+(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rsd.getString("chip_qty")))+"</font></td>");
					out.println("<td nowrap align='right'><font color='#006666'>"+Double.valueOf(rsd.getString("wafer_qty")).doubleValue()+"</font></td>");
					out.println("<td nowrap align='right'><font color='#006666'>"+Double.valueOf(rsd.getString("chip_qty")).doubleValue()+"</font></td>");
					out.println("<td nowrap align='center'>"+((rsd.getString("date_code")==null || rsd.getString("date_code").equals("null"))?"&nbsp;": (rsd.getString("date_code").toUpperCase().equals("HOLD")?"<font color='#ff0000'>":"<font color='#006666'>")+rsd.getString("date_code"))+"</font></td>");
					out.println("<td nowrap align='center'>"+((rsd.getString("dc_yyww")==null || rsd.getString("dc_yyww").equals("null"))?"&nbsp;": (rsd.getString("dc_yyww").toUpperCase().equals("HOLD")?"<font color='#ff0000'>":"<font color='#006666'>")+rsd.getString("dc_yyww"))+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+rsd.getString("completion_date")+"</font></td>");
					out.println("<td nowrap align='center'>"+(rsd.getString("transactions_type_name")==null?"&nbsp;":"<font color='#ff0000'>"+rsd.getString("transactions_type_name")+"</font>")+"</td>");
					out.println("</tr>");
				}
				else
				{
					out.println("<tr bgcolor="+colorStr+">");
					out.println("<td nowrap><font color='#006666'>"+rsd.getString("line_no")+"</font></td>");
					out.println("<td nowrap><font color='#006666'>"+rsd.getString("ISSUE_ITEM")+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+((rsd.getString("lot_number")==null || rsd.getString("lot_number").equals("null"))?"&nbsp;":rsd.getString("lot_number"))+"</font></td>");
					//out.println("<td nowrap align='right'><font color='#006666'>"+(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rsd.getString("wafer_qty")))+"</font></td>");
					//out.println("<td nowrap align='right'><font color='#006666'>"+(new DecimalFormat("##,##0.####")).format(Float.parseFloat(rsd.getString("chip_qty")))+"</font></td>");
					out.println("<td nowrap align='right'><font color='#006666'>"+Double.valueOf(rsd.getString("wafer_qty")).doubleValue()+"</font></td>");
					out.println("<td nowrap align='right'><font color='#006666'>"+Double.valueOf(rsd.getString("chip_qty")).doubleValue()+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+((rsd.getString("date_code")==null || rsd.getString("date_code").equals("null"))?"&nbsp;":rsd.getString("date_code"))+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+((rsd.getString("dc_yyww")==null || rsd.getString("dc_yyww").equals("null"))?"&nbsp;":rsd.getString("dc_yyww"))+"</font></td>");
					out.println("<td nowrap align='center'><font color='#006666'>"+rsd.getString("completion_date")+"</font></td>");
					out.println("<td nowrap align='center'>"+(rsd.getString("transactions_type_name")==null?"&nbsp;":"<font color='#ff0000'>"+rsd.getString("transactions_type_name")+"</font>")+"</td>");
					out.println("</tr>");			
				}
				iRow++;
			} 
			rsd.close();
			stated.close();
			out.println("</table>");   
%>			

			</font></td> 
			<!--<td width="10%" nowrap><div align="center"><font color="#006666"><%=rs.getString("CREATION_DATE")%></font></div></td>-->
			<!--<td width="10%" nowrap><div align="center"><font color="#006666"><%=rs.getString("CREATED_BY_NAME")%></font></div></td>-->
			<td width="10%" nowrap><div align="center"><font color="#006666"><% if (rs.getString("STATUS")!=null) out.println(rs.getString("STATUS")); else out.println("&nbsp;");%></font></div></td>
			<!--<td width="10%" nowrap><div align="center"><font color="#006666"><% if (rs.getString("APPROVE_DATE")!=null) out.println(rs.getString("APPROVE_DATE")); else out.println("&nbsp;");%></font></div></td>-->
			<!--<td width="10%" nowrap><div align="center"><font color="#006666"><% if (rs.getString("approved_by_name")!=null) out.println(rs.getString("approved_by_name")); else out.println("&nbsp;");%></font></div></td>-->
			<td width="10%" nowrap><div align="center"><font color="#DD0066"><% if (rs.getString("WIP_NO")!=null) out.println(rs.getString("WIP_NO")); else out.println("&nbsp;");%></font></div></td>
			<td width="5%" nowrap><div align="center"><font color="#DD0066"><% if (rs.getString("WIP_MTL_STATUS")!=null) out.println("已領(退)料"); else out.println("未領(退)料");%></font></div></td>
			<td width="10%" nowrap><div align="center"><font color="#CC5511"><% if (rs.getString("PR_NO")!=null)  out.println(rs.getString("PR_NO")); else out.println("&nbsp;");%></font></div></td>
			<td width="10%" nowrap><div align="center"><font color="#CC5511"><% if (rs.getString("PO_NO")!=null)  out.println(rs.getString("PO_NO")); else out.println("&nbsp;");%></font></div></td>
			<td align="center">
			<%
				if (rs.getString("WIP_NO")!=null &&rs.getString("STATUS").equals("Approved"))
				{
					if (rs.getString("VENDOR_CODE").equals("4682"))
					{
						out.println("<a href='../jsp/TSCPMDOEMMSECExcel.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");
					}
					else if (rs.getString("VENDOR_CODE").equals("4986"))
					{
						out.println("<a href='../jsp/TSCPMDOEMPPTExcel.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");
					}
					else
					{
						out.println("中文<a href='../jsp/TSCPMDOEMInformationExcel.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a><br>英文<a href='../jsp/TSCPMDOEMInformationExcelEng.jsp?REQUESTNO="+rs.getString("REQUEST_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");  
					}
				}
				else out.println("&nbsp;&nbsp;");
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
		out.println("<font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font>");
	}
	else
	{
%>
</table>
</td>
</tr>
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

