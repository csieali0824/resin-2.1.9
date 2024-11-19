<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String LOTNO = request.getParameter("LOTNO");
if (LOTNO==null) LOTNO="";
String ActionCode = request.getParameter("ActionCode");
if (ActionCode==null) ActionCode="";
String LABEL = request.getParameter("LABEL");
if (LABEL==null) LABEL="";
String SYS_NAME = request.getParameter("SYS_NAME");
if (SYS_NAME==null) SYS_NAME="";
String sql = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<script language="JavaScript" type="text/JavaScript">
function setCheck(irow)
{
	var chkflag ="";
	var chkleng =0;
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkflag = document.SUBFORM.CHKBOX[(irow-1)].checked; 
		chkleng = document.SUBFORM.CHKBOX.length;
	}
	else
	{
		chkflag = document.SUBFORM.CHKBOX.checked; 
		chkleng = 1;
	}
	for (var i = 0 ; i < chkleng ; i++)
	{
		if (chkflag == true)
		{
			if ((i+1)==irow)
			{
				document.getElementById("tr_"+irow).style.backgroundColor = document.SUBFORM.STRBGCOLOR.value;
				document.SUBFORM.elements["txt_remarks_"+(i+1)].value="";
				document.SUBFORM.elements["txt_remarks_"+(i+1)].disabled=false;

			}
			else
			{
				document.SUBFORM.CHKBOX[i].checked = false;
				document.getElementById("tr_"+(i+1)).style.backgroundColor ="#FFFFFF";
				document.SUBFORM.elements["txt_remarks_"+(i+1)].value="";
				document.SUBFORM.elements["txt_remarks_"+(i+1)].disabled=true;
			}
		}
		else
		{
			if ((i+1)==irow)
			{		
				document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
				document.SUBFORM.elements["txt_remarks_"+(i+1)].value="";
				document.SUBFORM.elements["txt_remarks_"+(i+1)].disabled=true;
			}
		}
	}
}

function sendToMainWindow()
{
	var chkleng =0;
	var chked = false;
	var chkcnt =0;
	var unlock_code ="";
	var unlock_name ="";
	var URL="";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkleng = document.SUBFORM.CHKBOX.length;
	}
	else
	{
		chkleng = 1;
	}
	for (var i = 0 ; i < chkleng ; i++)
	{
		if ( chkleng == 1)
		{
			chked = document.SUBFORM.CHKBOX.checked;
			strchkvlaue = document.SUBFORM.CHKBOX.value;
		}
		else
		{
			chked = document.SUBFORM.CHKBOX[i].checked; 
			strchkvlaue = document.SUBFORM.CHKBOX[i].value;
		}
		if (chked)
		{
			if (document.SUBFORM.elements["txt_"+(i+1)].value=="其他" &&  document.SUBFORM.elements["txt_remarks_"+(i+1)].value=="")
			{
				alert("解鎖原因選擇其他時,必須輸入原因說明");
				document.SUBFORM.elements["txt_remarks_"+(i+1)].focus();
			}
			unlock_code=document.SUBFORM.elements["txt_"+(i+1)].value;
			unlock_name=document.SUBFORM.elements["txt_remarks_"+(i+1)].value;
			chkcnt++;
		}
	}
	if (chkcnt ==0)
	{
		alert("請選擇解鎖原因!");
		return false;
	}
	else if (chkcnt > 1)
	{
		alert("解鎖原因只能單選不能複選,請重新確認!");
		return false;
	}
	URL = "../jsp/TSCMfgLabelPrintedQuery.jsp?ActionCode="+document.SUBFORM.ActionCode.value+"&SYS_NAME="+document.SUBFORM.SYS_NAME.value+"&LOTNO="+document.SUBFORM.LOTNO.value+"&LABEL="+document.SUBFORM.LABEL.value+"&UNLOCK_REASON="+unlock_code+"&UNLOCK_REASON_REMARKS="+unlock_name;
	this.window.close();	
	window.opener.document.MYFORM.action=URL;
	window.opener.document.MYFORM.submit();
	this.window.close();
}
</script>
<title>Page for choose Condition List</title>
</head>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSCMfgLabelUnlockReasonList.jsp">
<%  
	Statement statement=con.createStatement();
	String trBgColor="#D9D540";
	try
    { 
		sql = " SELECT a.a_value 解鎖原因,'' 說明"+
              " FROM oraddman.tsc_rfq_setup a"+
              " WHERE a.a_code ='YEW_LABEL_UNLOCK_REASON' "+
              " ORDER BY TO_NUMBER(A_SEQ)";
		//out.println(sql);
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1]; 
		out.println("<table align='align'>");
		out.println("<tr>");
		out.println("<td>");  
		out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
		out.println("<TR><TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'></TH>");        
		for (int i=1;i<=colCount;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'>"+colLabel[i].trim()+"</TH>");
		} 
		out.println("</TR>");
		int vline=0;
		//String [] chooseList  = VALUE.split(";");
		while (rs.next())
		{
			vline++;
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='checkbox' name='CHKBOX' value='"+vline+"' onclick='setCheck("+vline+")'></TD>");
			out.println("<TD style='font-size:12px;font-family: Tahoma,Georgia;'>"+ rs.getString(1).trim()+"<input type='hidden' name='txt_"+vline+"' value='"+rs.getString(1).trim()+"'></TD>");
			out.println("<TD style='font-size:12px;font-family: Tahoma,Georgia;'><input type='text' name='txt_remarks_"+vline+"' value='' size='20' style='font-size:12px;font-family: Tahoma,Georgia;' disabled></TD>");
			out.println("</TR>");	
		}
		out.println("</TABLE>");	
		out.println("</td>");  
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td align='center'><input type='button' name='btn1' value='Confirm' style='font-size:12px;font-family:arial' onclick='sendToMainWindow()'></td>");
		out.println("</tr>");
		out.println("</table>");
		rs.close();       
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
%>
 <BR>
<!--%表單參數%-->
<input type="hidden" name="LOTNO" value="<%=LOTNO%>">
<input type="hidden" name="LABEL" value="<%=LABEL%>">
<input type="hidden" name="SYS_NAME" value="<%=SYS_NAME%>">
<input type="hidden" name="ActionCode" value="<%=ActionCode%>">
<input type="hidden" name="STRBGCOLOR" value="#C9E7DD">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
