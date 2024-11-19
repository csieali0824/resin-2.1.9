<!--20180917 Peggy,新增"製造/研發/品管領退料"申請交易-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	if (document.MYFORM.WIP_NO.value =="" &&  document.MYFORM.REQUESTNO.value=="" && document.MYFORM.PICKNO.value ==""  && document.MYFORM.ITEMNAME.value =="" && 
   	   (document.MYFORM.YEARFR.value=="--" || document.MYFORM.MONTHFR.value=="--" || document.MYFORM.YEARTO.value=="--" || document.MYFORM.MONTHTO.value=="--"))
	{
		alert("查詢條件必須擇一輸入!");
		return false;
	}	
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}
function setExportXLS(URL)
{    
	if (document.MYFORM.WIP_NO.value =="" &&  document.MYFORM.REQUESTNO.value=="" && document.MYFORM.PICKNO.value ==""  && document.MYFORM.ITEMNAME.value =="" && 
   	   (document.MYFORM.YEARFR.value=="--" || document.MYFORM.MONTHFR.value=="--" || document.MYFORM.YEARTO.value=="--" || document.MYFORM.MONTHTO.value=="--"))
	{
		alert("查詢條件必須擇一輸入!");
		return false;
	}	
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setChange(objvalue)
{
	if (objvalue.length>0)
	{
		document.MYFORM.YEARFR.value="--";
		document.MYFORM.MONTHFR.value="--";
		document.MYFORM.DAYFR.value="--";
		document.MYFORM.YEARTO.value="--";
		document.MYFORM.MONTHTO.value="--";
		document.MYFORM.DAYTO.value="--";
	}
}
</script>
<html>
<head>
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

String dateStartType="";
String dateEndType="";
String YearFr=request.getParameter("YEARFR");
//dateBean.setAdjDate(-1);
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
//dateBean.setAdjDate(1);
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
String TRANS_TYPE=request.getParameter("TRANS_TYPE");
if (TRANS_TYPE==null) TRANS_TYPE="";
String WIP_NO=request.getParameter("WIP_NO");
if (WIP_NO==null) WIP_NO="";
String ITEM_NAME=request.getParameter("ITEMNAME");
if (ITEM_NAME==null) ITEM_NAME="";
String REQUEST_NO=request.getParameter("REQUESTNO");
if (REQUEST_NO==null) REQUEST_NO="";
String PICK_NO=request.getParameter("PICKNO");
if (PICK_NO==null) PICK_NO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50;
String sql="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSA01WIPRequestHistory.jsp" METHOD="post" NAME="MYFORM">
<font color="#006666" size="+2" face="Times New Roman"> 
<strong>A01工單原物料申請明細查詢</strong></font>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
		<td width="10%"><font color="#006666" ><strong>交易類型</strong></font></td>   
		<td width="15%">
		<%
		try
		{   
			sql = "select a.type_value,a.type_name from oraddman.tsa01_base_setup a where a.type_code='REQ_TYPE'";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(TRANS_TYPE);
			comboBoxBean.setFieldName("TRANS_TYPE");	
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
		</td>    
		<td width="10%"><font color="#006666" ><strong>工單號碼</strong></font></td>
	    <td width="15%"><input type="text" name="WIP_NO" value="<%=WIP_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange(this.value)"></td>
	    <td width="10%"><font color="#006666" ><strong>領料單號</strong></font></td> 
		<td width="15%"><input type="text" name="REQUESTNO" value="<%=REQUEST_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange(this.value)"></td> 
	    <td width="10%"><font color="#006666" ><strong>撿貨單號</strong></font></td> 
		<td width="15%"><input type="text" name="PICKNO" value="<%=PICK_NO%>"  style="font-family:Tahoma,Georgia;" onChange="setChange(this.value)"></td> 
	</tr>
	<TR>
	    <td><div align="left"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgPart"/>或<jsp:getProperty name="rPH" property="pgItemDesc"/></strong></font></div></td>
	    <td><input type="text" name="ITEMNAME" size="30" value="<%=ITEM_NAME%>"  style="font-family:Tahoma,Georgia;"></td> 
		<td><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font></td>
		<td colspan="3">
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
		<td width="10%">
<%
	try
	{   
		Statement statement=con.createStatement();
		sql = " select distinct TYPE_NAME,TYPE_DESC  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS'";
		ResultSet rs=statement.executeQuery(sql);
		out.println("<select NAME='STATUS' style='font-family:Tahoma,Georgia'>");
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
		</td>  
	</tr>
	<tr>  
		<td colspan="8" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSA01WIPRequestHistory.jsp")' > 
			&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    <INPUT TYPE="button" align="middle"  value="下載領(退)料申請單" onClick='setExportXLS("../jsp/TSA01WIPRequestExcel.jsp")' > 
		</td>
   </tr>
</table>  
<HR>

<%
try
{       	 

	int iCnt = 0,pagewidth=0,LastPage =0,showCnt=0,btnCnt =0;
	long dataCnt =0;
	long sCnt = (NowPage-1) * PageSize;
	long eCnt = NowPage * PageSize;
	sql = " SELECT a.request_no, a.request_type, a.organization_id,"+
                 " a.wip_entity_name, a.wip_entity_id, a.inventory_item_id,"+
                 " a.item_name, a.tsc_package, a.created_by, to_char(a.creation_date,'yyyy-mm-dd') creation_date,"+
                 " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date,a.status, nvl(d.TYPE_DESC ,a.status) status_name, a.version_id"+
				 ",c.TYPE_NAME"+
				 ",count(request_no) over (partition by a.organization_id order by a.organization_id) tot_cnt"+
                 " FROM oraddman.tsa01_request_headers_all a"+
				 ",inv.mtl_system_items_b b"+
				 ",(select * from oraddman.tsa01_base_setup where TYPE_CODE='REQ_TYPE') c "+
				 ",(select TYPE_NAME,TYPE_DESC  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') d"+
				 " where a.organization_id=b.organization_id "+
				 " and a.inventory_item_id=b.inventory_item_id "+
				 " and a.REQUEST_TYPE=c.TYPE_VALUE(+)"+
				 " and a.status=d.TYPE_NAME(+)";
	if (TRANS_TYPE!=null && !TRANS_TYPE.equals("--") && !TRANS_TYPE.equals("")) sql += " and a.request_type='"+TRANS_TYPE+"'";
	if (WIP_NO!=null && !WIP_NO.equals("")) sql += " and UPPER(a.wip_entity_name) like '"+ WIP_NO.toUpperCase()+"%'";
	if (REQUEST_NO!=null && !REQUEST_NO.equals("")) sql += " and a.REQUEST_NO LIKE '"+REQUEST_NO+"%'";
	if (PICK_NO!=null && !PICK_NO.equals("")) sql += " and exists (select 1 from oraddman.TSA01_request_lines_all x where x.PICK_NO like '"+ PICK_NO+"%' and x.request_no=a.request_no)";
	if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) sql += " and  exists (select 1 from oraddman.tsa01_request_lines_all b where b.STATUS='"+ STATUS+"' and b.request_no=a.request_no)";
	if (ITEM_NAME!=null && !ITEM_NAME.equals("")) sql += " and (b.description like '%"+ ITEM_NAME +"%' or  a.item_name like '"+ITEM_NAME +"%')";
	if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and a.creation_date >=to_DATE('"+dateSetBegin+"','"+dateStartType+"')";
	if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and a.creation_date <=to_DATE('"+dateSetEnd+"','"+dateEndType+"')+0.99999";
	sql += " order by a.wip_entity_name,a.request_no ";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		iCnt++;
		if (iCnt ==1)
		{
			//總筆數
			dataCnt = Long.parseLong(rs.getString("tot_cnt"));
			//最後頁數
			LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
				
			out.println("<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>");
			out.println("<tr>");
			out.println("<td>");
			out.println("<font face='細明體' color='#CC0066' size='2'>查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁</font>");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			out.println("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
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
			out.println("<input type=button name='FPage' id='FPage' value='<<' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPRequestHistory.jsp?QPage=1"+'"'+")' "+ FirBtnStatus+" title='First Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='PPage' id='PPage' value='<' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPRequestHistory.jsp?QPage="+(NowPage-1)+'"'+")' "+ PreBtnStatus+" title='Previous Page'>");
			out.println("&nbsp;&nbsp;<font face='細明體' color='#CC0066' size='2'>"+"第"+NowPage+"頁</font>&nbsp;&nbsp;");
			out.println("<input type=button name='NPage' id='NPage' value='>' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPRequestHistory.jsp?QPage="+(NowPage+1)+'"'+")' "+ NxtBtnStatus+" title='Next Page'>");
			out.println("&nbsp;");
			out.println("<input type=button name='LPage' id='LPage' value='>>' onClick='sendSubmit("+'"'+"../jsp/TSA01WIPRequestHistory.jsp?QPage="+LastPage+'"'+")' "+ LstBtnStatus + " title='Last Page'>");
			out.println("</td>");		
			out.println("</tr>");
			out.println("<tr>");
			out.println("<td>");
%> 
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF"> 
	<tr bgcolor="#C5C6AE" style="color:#006666">
		<td width="3%" height="30" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;</td> 
	  	<td width="6%" align="center">領料單號</td>
	  	<td width="4%" align="center">交易類型</td>
      	<td width="8%" align="center">工單號碼</td> 
      	<td width="12%"align="center">品名</td> 
      	<td width="67%" align="center"><jsp:getProperty name="rPH" property="pgDetail"/></td>            
	  	<!--<td width="5%" align="center">領料單下載</td>-->
    </tr>
    <% 
		}
		
		if ((iCnt) > sCnt && (iCnt) <= eCnt)
		{
			if ((showCnt % 2) == 0)
			{
				colorStr = "E3F0DF";
			}
			else
			{
				//colorStr = "B4E0C8"; 
				colorStr = "E3F0DF"; 
			}
    %>
		<tr bgcolor="<%=colorStr%>"> 
			<td align="center"><%=iCnt%></td>
			<td><div align="center" title="點我,可進入明細畫面!"><font  color="#006666"><A href='../jsp/TSA01WIPComponentRequest.jsp?REQUEST_NO=<%=rs.getString("REQUEST_NO")%>&ACODE=VIEW&STATUS=<%=rs.getString("status")%>'><%=rs.getString("REQUEST_NO")%></A></font></div></td>
			<td align="center"><%=rs.getString("TYPE_NAME")%></td>
			<td align="center"><%=rs.getString("wip_entity_name")%></td>
			<td><%=rs.getString("ITEM_NAME")%></td>
			<td>
	<% 
			int iRow = 0; 	
			String sqld = " SELECT a.request_no, a.line_no, a.comp_type_no,b.comp_type_name, a.organization_id,"+
                          " a.component_item_id, a.component_name, a.uom, a.required_qty,"+
                          " a.request_qty, a.spq, a.moq, a.change_rate,"+
                          " a.remarks,a.pick_no, nvl(c.TYPE_DESC ,a.status) status_name"+
                 		  ",(select listagg(k.LOT ||'  ' ||K.LOT_QTY||K.UOM ||CASE WHEN NVL(k.MISCELLANEOUS_FLAG,'N')='Y' and d.request_type NOT IN ('MISC','RDMISC','QCMISC') THEN '(工程批)' ELSE '' END ||CASE WHEN k.REMARKS IS NULL THEN '' ELSE '('||k.REMARKS||')' END ,'<br>') within group (order by k.lot) from oraddman.TSA01_REQUEST_WAFER_LOT_ALL k "+
                		  " where a.request_no=k.request_no"+
                		  " and a.line_no=k.line_no) lot_list"+	
						  ",nvl(a.issue_qty,0) issue_qty"+		
						  ",a.status"+			  
                          " FROM oraddman.tsa01_request_lines_all a"+
						  ",oraddman.tsa01_component_type b"+
			           	  ",(select TYPE_NAME,TYPE_DESC  from oraddman.tsa01_base_setup where TYPE_CODE='REQ_STATUS') c"+
						  ",oraddman.tsa01_request_headers_all d"+
						  " where a.COMP_TYPE_NO=b.COMP_TYPE_NO "+
						  " and a.status=c.TYPE_NAME"+
						  " and a.request_no=d.request_no"+
						  " and a.request_no='"+ rs.getString("REQUEST_NO")+"'";
			if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) sqld += " and  a.STATUS='"+ STATUS+"'";
			sqld += " order by a.line_no";				   
			Statement stated=con.createStatement();
			ResultSet rsd=stated.executeQuery(sqld); 							  
			while (rsd.next())
			{ 
				if (iRow==0 )
				{ 
					out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");			 
					out.println("<tr align='center' style='color:#ffffff' bgcolor='#B4AB72'>");
					out.println("<td width='10%'>類別</td>");
					out.println("<td width='13%'>料號</td>");
					out.println("<td width='6%'>單位</td>");
					out.println("<td width='7%'>工單用量</td>");
					out.println("<td width='7%'>最小包裝量</td>");
					out.println("<td width='7%'>領用數量</td>");
					out.println("<td width='7%'>撿貨數量</td>");
					out.println("<td width='17%'>指定批號</td>");
					out.println("<td width='11%'>狀態</td>");
					out.println("<td width='8%'>撿貨單號</td>");
					out.println("</tr>");
				}	
				out.println("<tr bgcolor="+colorStr+">");
				out.println("<td align='center'>"+rsd.getString("comp_type_name")+"</td>");
				out.println("<td>"+rsd.getString("COMPONENT_NAME")+"</td>");
				out.println("<td align='center'>"+rsd.getString("uom")+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("required_qty")).doubleValue()+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("spq")).doubleValue()+"</td>");
				out.println("<td align='right'>"+Double.valueOf(rsd.getString("request_qty")).doubleValue()+"</td>");
				out.println("<td align='right'"+ ((rs.getString("status").equals("CONFIRMED") || rs.getString("status").equals("PICKED") || rs.getString("status").equals("CLOSED")) && Double.valueOf(rsd.getString("issue_qty")).doubleValue()!=Double.valueOf(rsd.getString("request_qty")).doubleValue()?" style='color:#ff0000;font-weight:bold'":"")+">"+Double.valueOf(rsd.getString("issue_qty")).doubleValue()+"</td>");
				out.println("<td style='font-size:11px'>"+(rsd.getString("lot_list")==null?"&nbsp;":rsd.getString("lot_list"))+"</td>");
				out.println("<td align='center'>"+rsd.getString("status_name")+"</td>");
				out.println("<td align='center'>"+(rsd.getString("pick_no")==null?"&nbsp;":(rsd.getString("pick_no")==null?"&nbsp;":"<a href="+'"'+"../jsp/TSA01WIPWareHousePickExcel.jsp?PICK_NO="+rsd.getString("pick_no")+'"'+">"+rsd.getString("pick_no")+"</a>"))+"</td>");
				out.println("</tr>");			
				iRow++;
			} 
			rsd.close();
			stated.close();
			if (iRow >0) out.println("</table>");   
%>			

			</td> 
			<!--<td align="center"><%if (!rs.getString("STATUS").toUpperCase().equals("REJECT") && !rs.getString("STATUS").toUpperCase().equals("DISAGREE")) out.println("<a href='../jsp/TSA01WIPRequestExcel.jsp?REQUEST_NO="+rs.getString("REQUEST_NO")+"'><img name='popcal' border='0' src='../image/excel_16.gif'></a>");  else out.println("&nbsp;&nbsp;");%></td>-->
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

