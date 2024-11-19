<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(URL)
{    
	var chkcnt=0;
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (i = 0; i < document.MYFORM.CHKBOX.length; i++) 
		{
			if (document.MYFORM.CHKBOX[i].checked ==true)
			{
				if (document.getElementById("date"+(i+1)).value ==null || document.getElementById("date"+(i+1)).value=="")
				{
					alert("領料日期必須輸入!!");
					document.getElementById("date"+(i+1)).focus();
					return false;
				}
				else if (document.getElementById("date"+(i+1)).value.length !=8)
				{
					alert("領料日期格式錯誤(正確格式:YYYYMMDD)!!");
					document.getElementById("date"+(i+1)).focus();
					return false;
				}
				else if (parseFloat(document.getElementById("date"+(i+1)).value) > parseFloat(document.MYFORM.nowtime.value))
				{
					alert("領料日期不可為未來日期!!");
					return false;
				}
				else
				{
					if (parseFloat(document.getElementById("date"+(i+1)).value.substring(0,8)) < parseFloat(document.getElementById("RELEASEDDATE"+(i+1)).value.substring(0,8)))
					{
						alert("領料日期不可小於工單Release日期("+document.getElementById("RELEASEDDATE"+(i+1)).value.substring(0,8)+")!!");
						return false;
					}
					else if (parseFloat(document.getElementById("date"+(i+1)).value.substring(0,8)) < parseFloat(document.getElementById("ORIGINVDATE"+(i+1)).value.substring(0,8)))
					{
						alert("領料日期不可小於上一次領料日期("+document.getElementById("ORIGINVDATE"+(i+1)).value.substring(0,8)+")!!");
						return false;
					}
				}
				chkcnt++;
			}
		}
		if(chkcnt ==0)
		{
			alert("請先勾選工單號!!");
			return false;
		}
	}
	else if (document.MYFORM.CHKBOX.checked == false)
	{
		alert("請先勾選工單號!!");
		return false;
	}
	if (confirm("您確定要進行工單領料作業??"))
	{
		document.MYFORM.submit1.disabled=true;
		document.getElementById("alpha").style.width="100"+"%";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.MYFORM.action="../jsp/TSCPMDOEMProcess.jsp?PROGRAMNAME=F1-004";
		document.MYFORM.submit();
	}
}

function checkall()
{
	var chkflag = document.MYFORM.CHKALL.checked;
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (i = 0; i < document.MYFORM.CHKBOX.length; i++) 
		{
			if (document.MYFORM.CHKBOX[i].disabled != true)
			{
				document.MYFORM.CHKBOX[i].checked = chkflag;
				if (chkflag == true)
				{
					document.getElementById("dv"+(i+1)).style.color ="#00f";
					document.getElementById("dv"+(i+1)).style.fontSize ="14px";
					document.getElementById("dv"+(i+1)).style.fontWeight="bold";
					document.getElementById("date"+(i+1)).value = document.MYFORM.nowtime.value;
				}
				else
				{
					document.getElementById("dv"+(i+1)).style.color ="#000";
					document.getElementById("dv"+(i+1)).style.fontSize ="12px";
					document.getElementById("dv"+(i+1)).style.fontWeight="normal";
					document.getElementById("date"+(i+1)).value="";
				}
			}
		}
	}
	else if (document.MYFORM.CHKBOX.disabled != true)
	{
		document.MYFORM.CHKBOX.checked = chkflag;
		if (chkflag == true)
		{
			document.getElementById("dv1").style.color ="#00f";
			document.getElementById("dv1").style.fontSize ="14px";
			document.getElementById("dv1").style.fontWeight="bold";
			document.getElementById("date1").value = document.MYFORM.nowtime.value;
		}
		else
		{
			document.getElementById("dv1").style.color ="#000";
			document.getElementById("dv1").style.fontSize ="12px";
			document.getElementById("dv1").style.fontWeight="normal";
			document.getElementById("date1").value="";
		}
		
	}
}

function setCheck(irow)
{
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		var chkflag = document.MYFORM.CHKBOX[(irow-1)].checked; 
		if (chkflag == true)
		{
			document.getElementById("dv"+irow).style.color ="#00f";
			document.getElementById("dv"+irow).style.fontSize ="14px";
			document.getElementById("dv"+irow).style.fontWeight="bold";
			document.getElementById("date"+irow).value = document.MYFORM.nowtime.value;
		}
		else
		{
			document.getElementById("dv"+irow).style.color ="#000";
			document.getElementById("dv"+irow).style.fontSize ="12px";
			document.getElementById("dv"+irow).style.fontWeight="normal";
			document.getElementById("date"+irow).value ="";
		}
	}
	else
	{
		var chkflag = document.MYFORM.CHKBOX.checked; 
		if (chkflag == true)
		{
			document.getElementById("dv1").style.color ="#00f";
			document.getElementById("dv1").style.fontSize ="14px";
			document.getElementById("dv1").style.fontWeight="bold";
			document.getElementById("date1").value = document.MYFORM.nowtime.value;
		}
		else
		{
			document.getElementById("dv1").style.color ="#000";
			document.getElementById("dv1").style.fontSize ="12px";
			document.getElementById("dv1").style.fontWeight="normal";
			document.getElementById("date1").value ="";
		}
	
	}
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
<title>PMD Work in Process</title>
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
dateBean.setAdjDate(-3);
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
dateBean.setAdjDate(3);
String nowtime = dateBean.getYearMonthDay();
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
String WIPNO=request.getParameter("WIPNO");
if (WIPNO==null) WIPNO="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="N";
String REQUESTNO=request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String VERSIONID=request.getParameter("VERSIONID");
if (VERSIONID==null) VERSIONID="";
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCPMDOEMInventoryTransaction.jsp" METHOD="post" NAME="MYFORM">
<font color="#006666" size="+2" face="Times New Roman"> 
<strong>PMD工單領(退)料確認<jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
  <input type="hidden" name="nowtime" value="<%=nowtime%>">
<table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
		<td width="8%"><font color="#006666" ><strong>工單號碼</strong></font></td>
	    <td width="8%"><input type="text" name="WIPNO" value="<%=WIPNO%>"   size="10" style="font-family:Tahoma,Georgia;"></td>
		<td width="8%"><font color="#006666" ><strong>廠商名稱</strong></font></td>
	    <td width="15%"><input type="text" name="VENDOR" value="<%=VENDOR%>"  size="30" style="font-family:Tahoma,Georgia;"></td>
		<td width="8%"><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font></td>
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
    	out.println("Exception:"+e.getMessage());
    }
%>    
		</font></td>  
		<td width="8%"><font color="#006666" ><strong>領(退)料狀態</strong></font></td>
		<td width="8%">
		<select NAME='STATUS' style='font-family:ARIAL'>
		<OPTION VALUE=--  <%if (STATUS.equals("--")) out.println("SELECTED");%>>
		<OPTION VALUE='N' <%if (STATUS.equals("N")) out.println("SELECTED");%>>未領(退)料					   
		<OPTION VALUE='Y' <%if (STATUS.equals("Y")) out.println("SELECTED");%>>已領(退)料
		</select>
		</td>
	</tr>
	<tr>
		<td colspan="8" align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCPMDOEMInventoryTransaction.jsp")' > 
		</td>
   </tr>
</table>
<%
try
{       	 
	String sql = " SELECT  a.request_no,a.version_id,a.wip_no, a.vendor_name,a.inventory_item_name, a.item_description,case when length(a.inv_date) >8 then substr(a.inv_date,0,8) else a.inv_date end as inv_date"+
                 ",to_char(a.creation_date,'yyyymmdd') creation_date,a.created_by_name, NVL(b.status_type,'') status_type ,decode(NVL(a.wip_mtl_status,'N'),'S','Y','N') status,decode(NVL(a.wip_mtl_status,'N'),'S','已領(退)料','未領(退)料') statusname,to_char(b.DATE_RELEASED,'yyyymmddhh24miss') DATE_RELEASED"+
				 ",case when a.version_id >0 then (select INV_DATE from oraddman.tspmd_oem_headers_all c where c.request_no = a.request_no and c.version_id = a.orig_version_id) else '' end  ORIG_INV_DATE,a.DIE_NAME"+                 
				 " FROM oraddman.tspmd_oem_headers_all a,wip.wip_discrete_jobs b"+
                 " where a.wip_entity_id = b.wip_entity_id and a.STATUS='Approved'";
	if (VENDOR!=null && !VENDOR.equals("")) sql += " and a.vendor_name like '"+VENDOR+"%'";
	if (WIPNO!=null && !WIPNO.equals("")) sql += " and a.WIP_NO ='"+ WIPNO+"'";
	if (STATUS!=null && !STATUS.equals("") && !STATUS.equals("--")) sql += " and decode(NVL(a.wip_mtl_status,'N'),'S','Y','N')='"+ STATUS+"' ";
	if (dateSetBegin!=null && !dateSetBegin.equals("")) sql += " and to_char(a.creation_date,'"+dateStartType+"') >='"+dateSetBegin+"'";
	if (dateSetEnd!=null && !dateSetEnd.equals("")) sql += " and to_char(a.creation_date,'"+dateEndType+"') <='"+dateSetEnd+"'";
	sql += " order by a.creation_date,wip_no ";
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	//out.println(sql);
	int iCnt =0;
	while (rs.next()) 
	{ 	
		iCnt ++;
		if (iCnt ==1)
		{
%>
	<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
		<tr bgcolor="#86B6D9"> 
			<td width="2%"><div align="center"><font color="#000000" >&nbsp;&nbsp;</font></div></td> 
			<td width="2%"><div align="center"><font color="#000000" ><input type="checkbox" name="CHKALL" onClick="checkall();" value="Y"></font></div></td> 
	  		<td width="7%"><div align="center"><font color="#000000">領料日期</font></div></td>
	  		<td width="7%"><div align="center"><font color="#000000">工單號碼</font></div></td>
	  		<td width="13%"><div align="center"><font color="#000000">供應商</font></div></td>
	  		<td width="13%"><div align="center"><font color="#000000">台半料號/品名</font></div></td>
	  		<td width="8%"><div align="center"><font color="#000000">芯片名稱</font></div></td>
      		<td width="44%"><div align="center"><font color="#000000"><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>            
      		<td width="4%"><div align="center"><font color="#000000">狀態</font></div></td>
    	</tr>

<%
		}	
%>
		<tr  bgcolor="#E9F3EC"> 
			<td bgcolor="#86B6D9"><div align="center"><font  color="#006666"><%out.println(iCnt);%></font></div></td>
			<td align="center"><input type="checkbox" name="CHKBOX" value="<%=iCnt%>"  <%if (rs.getString("status").equals("Y")) out.println("disabled='disabled'");%> onClick="setCheck(<%=iCnt%>);"></td>
			<td align="center"><input type="text" name="date<%=iCnt%>" size="7" <% if (rs.getString("status").equals("Y")) out.println("value='"+rs.getString("inv_date")+"' onkeydown='return (event.keyCode!=8);' readonly");%>>
<%
			if (!rs.getString("status").equals("Y")) out.println("<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM."+"date"+iCnt+");return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>");					

%>
			</td>
			<td><div id="dv<%=iCnt%>"><%=rs.getString("WIP_NO")+(!rs.getString("VERSION_ID").equals("0")?"<br>(變更)":"")%></div>
			<input type="hidden" name="WIPNO<%=iCnt%>" value="<%=rs.getString("WIP_NO")%>">
			<input type="hidden" name="REQUESTNO<%=iCnt%>" value="<%=rs.getString("REQUEST_NO")%>">
			<input type="hidden" name="VERSIONID<%=iCnt%>" value="<%=rs.getString("VERSION_ID")%>">
			<input type="hidden" name="RELEASEDDATE<%=iCnt%>" value="<%=rs.getString("DATE_RELEASED")%>">
			<input type="hidden" name="ORIGINVDATE<%=iCnt%>" value="<%=rs.getString("ORIG_INV_DATE")%>">
			</td>
			<td><%=rs.getString("vendor_name")%></td>
			<td><%=rs.getString("INVENTORY_ITEM_NAME")%><br><%=rs.getString("ITEM_DESCRIPTION")%></td>
			<td><%=rs.getString("DIE_NAME")%></td>
			<td><font  color="#006666">
<% 
			int iRow = 0; 	
			float totWaferQty =0;
			float totChipQty=0;
			String sqld = " SELECT a.request_no, a.version_id,a.line_no, a.lot_number, a.wafer_qty, a.chip_qty,a.date_code, a.completion_date,a.inventory_item_name issue_item,b.description "+
			              " FROM oraddman.tspmd_oem_lines_all a,inv.mtl_system_items_b b"+
						  " where a.request_no ='"+ rs.getString("REQUEST_NO")+"' and a.version_id='"+ rs.getString("VERSION_ID")+"' and b.organization_id=49 and a.inventory_item_id = b.inventory_item_id order by a.line_no";				   
			Statement stated=con.createStatement();
			ResultSet rsd=stated.executeQuery(sqld); 							  
			while (rsd.next())
			{ 
				if (iRow==0 )
				{ 
					out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");			 
					out.println("<tr align='center' bgcolor='#990099'>");
					out.println("<td width='3%' nowrap><font color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgAnItem"/><%
					out.println("</font></td><td width='20%' nowrap><font color='#FFFFFF'>發料項目");
					out.println("</font></td><td width='15%' nowrap><font color='#FFFFFF'>Wafer Lot#");
					out.println("</font></td><td width='10%' nowrap><font color='#FFFFFF'>Wafer Qty");
					out.println("</font></td><td width='10%' nowrap><font color='#FFFFFF'>Chip Qty");
					out.println("</font></td><td width='10%' nowrap><font color='#FFFFFF'>Date Code");								
					out.println("</font></td></tr>");
				}
				%>
				<!--<tr bgcolor="#2FAE72">-->
				<%
				out.println("<tr bgcolor='#E9F3EC'>");
				out.println("<td nowrap><font color='#000000'>"+rsd.getString("line_no")+"</font></td>");
				out.println("<td nowrap><font color='#000000'>"+rsd.getString("ISSUE_ITEM")+"</font></td>");
				out.println("<td nowrap align='center'><font color='#000000'>"+((rsd.getString("lot_number")==null || rsd.getString("lot_number").equals("null"))?"&nbsp;":rsd.getString("lot_number"))+"</font></td>");
				out.println("<td nowrap align='right'><font color='#000000'>"+(new DecimalFormat("##,##0.#####")).format(Float.parseFloat(rsd.getString("wafer_qty")))+"</font></td>");
				out.println("<td nowrap align='right'><font color='#000000'>"+(new DecimalFormat("##,##0.#####")).format(Float.parseFloat(rsd.getString("chip_qty")))+"</font></td>");
				out.println("<td nowrap align='center'><font color='#000000'>"+((rsd.getString("date_code")==null || rsd.getString("date_code").equals("null"))?"&nbsp;":rsd.getString("date_code"))+"</font></td>");
				out.println("</tr>");	
				
				totWaferQty+=Float.parseFloat(rsd.getString("wafer_qty"));	
				totChipQty+=Float.parseFloat(rsd.getString("chip_qty"));	
				iRow++;
			} 
			rsd.close();
			stated.close();
			if (iRow >0)
			{
				out.println("<tr bgcolor='#2FAE72'>");
				out.println("<td colspan='3' align='center'><font color='#FFFFFF'>合計:</font></td>");
				out.println("<td nowrap align='right'><font color='#FFFFFF'>"+(new DecimalFormat("##,##0.#####")).format(totWaferQty)+"</font></td>");
				out.println("<td nowrap align='right'><font color='#FFFFFF'>"+(new DecimalFormat("##,##0.#####")).format(totChipQty)+"</font></td>");
				out.println("<td>&nbsp;</td>");
				out.println("</tr>");	
				out.println("</table>");   
			}
%>
			</font></td> 
			<td width="10%" nowrap><div align="center"><font color="#000000"><% if (rs.getString("STATUSNAME")!=null) out.println(rs.getString("STATUSNAME")); else out.println("&nbsp;");%></font></div></td>
		</tr>
<%
	}
	rs.close();
	statement.close();
	
	if (iCnt==0)
	{
		out.println("<font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font>");
	}
	else
	{
		out.println("<tr bgcolor='#86B6D9' height='25'><td colspan='9'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='button' name='submit1' value='領(退)料確認' onClick='setSubmit1();'></td></tr>");
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
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>

