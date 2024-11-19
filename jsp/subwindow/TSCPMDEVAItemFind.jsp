<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=================================-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String sql = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<script language="JavaScript" type="text/JavaScript">
function chkall()
{
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.SUBFORM.CHKBOX.length ;i++)
		{
			document.SUBFORM.CHKBOX[i].checked= document.SUBFORM.CHKBOXALL.checked;
			setCheck((i+1));
		}
	}
	else
	{
		document.SUBFORM.CHKBOX.checked = document.SUBFORM.CHKBOXALL.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkflag = document.SUBFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.SUBFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor = document.SUBFORM.STRBGCOLOR.value;
		document.SUBFORM.elements["text_"+irow].style.backgroundColor = document.SUBFORM.STRBGCOLOR.value;
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		document.SUBFORM.elements["text_"+irow].style.backgroundColor="#FFFFFF";
	}
}

function sendToMainWindow()
{
	var chkleng =0;
	var chked = false;
	var strchkvlaue = "";
	var iseq=0;
	var choosevalue = "Hi-Rel test item";
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
			iseq ++;
			if (choosevalue.length >0) choosevalue +="\n";
			choosevalue += (iseq+". "+document.SUBFORM.elements["text_"+(i+1)].value);
		}
	}
	//alert(choosevalue);
	window.opener.document.MYFORM.REMARKS.value = window.opener.document.MYFORM.REMARKS.value+choosevalue;
	this.window.close();
}
</script>
<title>Page for choose Condition List</title>
</head>
<body >  
<FORM NAME="SUBFORM" METHOD="post" ACTION="TSCPMDEVAItemFind.jsp">
<%  
	Statement statement=con.createStatement();
	String trBgColor="#D9D540";
	try
    { 
		sql = " select TYPE_NAME \"Hi-Rel test item\" from oraddman.tspmd_data_type_tbl a where a.STATUS_FLAG='A' and a.data_type = decode(substr('"+ITEMDESC+"',1,3),'TSM','MOS','IC')";
		ResultSet rs=statement.executeQuery(sql);
		ResultSetMetaData md=rs.getMetaData();
		int colCount=md.getColumnCount();
		String colLabel[]=new String[colCount+1]; 
		out.println("<table align='align'>");
		out.println("<tr>");
		out.println("<td>");  
		out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
		out.println("<TR><TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'><input type='checkbox' name='CHKBOXALL' onClick='chkall();'></TH>");        
		for (int i=1;i<=colCount;i++) 
		{
			colLabel[i]=md.getColumnLabel(i);
			out.println("<TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'>"+colLabel[i].trim()+"</TH>");
		} 
		out.println("</TR>");
		String strListValue = "",strchk="",strbgColor="";
		int vline=0;
		while (rs.next())
		{
			strbgColor = "#FFFFFF"; 
			strchk = "";
			vline++;
			out.println("<TR id='tr_"+vline+"' BGCOLOR='"+strbgColor+"'>");
			out.println("<TD><input type='checkbox' name='CHKBOX' value='"+vline+"' "+strchk+"  onclick=setCheck('"+vline+"');></TD>");
			for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
			{
				strListValue=rs.getString(i).trim();
				out.println("<TD style='font-size:12px;font-family:arial'><input type='text' name='text_"+vline+"' value='"+strListValue+"' style='border-left:none;border-right:none;border-top:none;border-bottom:none;font-family:arial' readonly size='60' onKeyDown='return (event.keyCode!=8);'></TD>");
			} 
			out.println("</TR>");	
		}
		out.println("</TABLE>");	
		out.println("</td>");  
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td align='center'><input type='button' name='btn1' value='Confirm' onclick='sendToMainWindow()' style='font-size:12px;font-family:arial'></td>");
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
<input type="hidden" name="STRBGCOLOR" value="<%=trBgColor%>">
<input type="hidden" name="ITEMDESC" value="<%=ITEMDESC%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
