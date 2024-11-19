<!-- modify by Peggy 20151118,新增內外銷調撥選項-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
		lineid = document.MYFORM.chk[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
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
		alert("請先勾選資料!");
		return false;
	}
	if (document.MYFORM.ACTIONCODE.value =="--" || document.MYFORM.ACTIONCODE.value=="")
	{
		alert("請選擇執行動作!");
		return false;
	}
	else if (document.MYFORM.ACTIONCODE.value =="R" && document.MYFORM.RESULT_MSG.value =="")
	{
		alert("請輸入退件原因!");
		return false;
	}
	document.MYFORM.Submit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function subAction(obj_value)
{
	if (obj_value=="R")
	{
		document.MYFORM.RESULT_MSG.value ="";
		document.MYFORM.reason.style.visibility="visible";
		document.MYFORM.RESULT_MSG.style.visibility="visible";
	}
	else
	{
		document.MYFORM.RESULT_MSG.value ="";
		document.MYFORM.reason.style.visibility="hidden";
		document.MYFORM.RESULT_MSG.style.visibility="hidden";
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
</STYLE>
<title>TEW PO Revise Confirm</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<%
String sql = "";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="N";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String RESULT_MSG = request.getParameter("RESULT_MSG");
if (RESULT_MSG ==null) RESULT_MSG="";
POReceivingBean.setArray2DString(null); 
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWPOReviseConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">Confirm to Revise Data</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%"><font color="#666600">供應商:</font></td>
		<td width="13%"><input type="text" name="SUPPLIER" value="<%=SUPPLIER%>" style="font-family:Arial;font-size:12px" size="25"></td>
		<td width="7%"><font color="#666600">採購單號:</font></td>
		<td width="13%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family:Arial;font-size:12px" size="15"></td>
		<td width="12%"><font color="#666600">料號或型號:</font></td>
		<td width="14%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family:Arial;font-size:12px" size="20"></td>
		<td width="7%"><font color="#666600">申請日期:</font></td>
		<td width="13%">
<%
		String CurrYear = null;	 
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2014+1];
			for (int i = 2014; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
		</td>
		<td width="7%"><font color="#666600">狀態:</font></td>
		<td width="7%"><select NAME="STATUS" style="font-family: Tahoma,Georgia; font-size: 12px ">
		<OPTION VALUE=-- <%if (STATUS.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>><jsp:getProperty name="rPH" property="pgNonProcess"/></OPTION>
		<OPTION VALUE="Y" <%if (STATUS.equals("Y")) out.println("selected");%>><jsp:getProperty name="rPH" property="pgApproval"/></OPTION>
		<OPTION VALUE="R" <%if (STATUS.equals("R")) out.println("selected");%>><jsp:getProperty name="rPH" property="pgReject"/></OPTION>
		</select>		
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWPOReviseConfirm.jsp")' > 
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	sql = " SELECT a.vendor_name"+
	      ",a.po_no"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",b.po_line_location_id"+
		  ",to_char(b.old_received_date,'yyyy-mm-dd') old_received_date"+
		  ",b.old_lot_number"+
		  ",b.old_date_code"+
		  ",b.old_received_quantity"+
		  ",to_char(b.new_received_date,'yyyy-mm-dd') new_received_date"+
		  ",b.new_lot_number"+
		  ",b.new_date_code"+
		  ",b.new_received_quantity"+
		  ",b.remark"+
		  ",b.created_by"+
		  ",to_char(b.creation_date,'yyyy-mm-dd') creation_date"+
		  ",a.po_header_id"+
		  ",b.request_id"+
		  ",b.seq_id"+
		  ",nvl(b.APPROVE_FLAG,'N') APPROVE_FLAG"+
          " FROM oraddman.tewpo_receive_header a,oraddman.tewpo_receive_revise b"+
          " where a.po_line_location_id = b.po_line_location_id ";
	if (!PONO.equals(""))
	{
		sql += " AND a.PO_NO LIKE '"+ PONO+"%'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (a.ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR a.ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!SUPPLIER.equals(""))
	{
		sql += " AND a.vendor_name LIKE '"+SUPPLIER+"%'";
	}
	if (!STATUS.equals("") && !STATUS.equals("--"))
	{
		sql += " AND b.APPROVE_FLAG ='" + STATUS+"'";
	}
	if (!YearFr.equals("--") && !YearFr.equals("")) 
	{
		sql += " AND to_char(b.creation_date,'yyyy') = '" + YearFr+"'";
	}	
	if (!MonthFr.equals("--") && !MonthFr.equals(""))
	{
		sql += " AND to_char(b.creation_date,'mm') = '" + MonthFr+"'";
	}
	if (!DayFr.equals("--") && !DayFr.equals(""))
	{
		sql += " AND to_char(b.creation_date,'dd') = '" + DayFr+"'";
	}
	sql += " order by b.creation_date,b.PO_LINE_LOCATION_ID";
	//out.println(sql);
	Statement statement = con.createStatement();
	ResultSet rs=statement.executeQuery(sql);
	int icnt =0;
	while (rs.next())
	{
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
			<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:12px" align="center">
				<td width="3%">
<%
				if (STATUS.equals("--") || STATUS.equals("N") || STATUS.equals(""))
				{
%>
					<input type="checkbox" name="chkall"  onClick="checkall()">
<%
				}
				else
				{
					out.println("&nbsp;");
				}
%>
				</td>
				<td width="13%">供應商</td>
				<td width="7%">採購單號</td>
				<td width="13%">料號</td>
				<td width="3%">&nbsp;</td>
				<td width="7%">收料日期</td>
				<td width="10%">LOT</td>
				<td width="8%">D/C</td>
				<td width="7%">收料數量</td>
				<td width="10%">修改原因</td>
				<td width="7%">申請人</td>
				<td width="7%">申請日期</td>
			</tr>
		
<%		
		}
%>
			<tr style="font-size:12px" id="tr_<%=rs.getString("request_id")%>">
				<td rowspan="2" align="center">
<%
				if (rs.getString("APPROVE_FLAG").equals("N"))
				{
%>
				<input type="checkbox" name="chk" value="<%=rs.getString("request_id")%>" onClick="setCheck(<%=(icnt+1)%>)">
<%
				}
				else
				{
					out.println(icnt+1);
				}
%>				
				</td>
				<td rowspan="2" align="left"><%=rs.getString("vendor_name")%><input type="hidden" name="PO_LINE_LOCATION_ID_<%=rs.getString("request_id")%>" value="<%=rs.getString("PO_LINE_LOCATION_ID")%>"><input type="hidden" name="SEQ_ID_<%=rs.getString("request_id")%>" value="<%=rs.getString("SEQ_ID")%>"></td>
				<td rowspan="2" align="center"><%=rs.getString("PO_NO")%><input type="hidden" name="PO_NO_<%=rs.getString("request_id")%>" value="<%=rs.getString("PO_NO")%>"></td>
				<td rowspan="2" align="left"><a href='javaScript:popMenuMsg("<%=rs.getString("ITEM_DESC")%>")' onmouseover='this.T_WIDTH=80;return escape("<%=rs.getString("ITEM_DESC")%>")'><%=rs.getString("ITEM_name")%></a><input type="hidden" name="ITEM_NAME_<%=rs.getString("request_id")%>" value="<%=rs.getString("ITEM_NAME")%>"></td>
				<td align="center" style="color:#0000FF;background-color:#C1E1D1">異動前</td>
				<td align="center" style="background-color:#C1E1D1"><% if (!rs.getString("NEW_RECEIVED_DATE").equals(rs.getString("OLD_RECEIVED_DATE"))){ out.println("<font color='blue'>");}else{out.println("<font color='black'>");}%><%=rs.getString("OLD_RECEIVED_DATE")%></FONT><input type="hidden" name="OLD_RDATE_<%=rs.getString("request_id")%>" value="<%=rs.getString("OLD_RECEIVED_DATE")%>"></td>
				<td align="left" style="background-color:#C1E1D1"><% if (!rs.getString("NEW_LOT_NUMBER").equals(rs.getString("OLD_LOT_NUMBER"))){ out.println("<font color='blue'>");}else{out.println("<font color='black'>");}%><%=rs.getString("OLD_LOT_NUMBER")%></font><input type="hidden" name="OLD_LOT_<%=rs.getString("request_id")%>" value="<%=rs.getString("OLD_LOT_NUMBER")%>"></td>
				<td align="left" style="background-color:#C1E1D1"><% if (!rs.getString("NEW_DATE_CODE").equals(rs.getString("OLD_DATE_CODE"))){ out.println("<font color='blue'>");}else{out.println("<font color='black'>");}%><%=rs.getString("OLD_DATE_CODE")%></font><input type="hidden" name="OLD_DC_<%=rs.getString("request_id")%>" value="<%=rs.getString("OLD_DATE_CODE")%>"></td>
				<td align="right" style="background-color:#C1E1D1"><% if (!rs.getString("NEW_RECEIVED_QUANTITY").equals(rs.getString("OLD_RECEIVED_QUANTITY"))){ out.println("<font color='blue'>");}else{out.println("<font color='black'>");}%><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("OLD_RECEIVED_QUANTITY")))%></font></td>
				<td rowspan="2" align="left"><%=rs.getString("remark")%></td>
				<td rowspan="2" align="center"><%=rs.getString("created_by")%></td>
				<td rowspan="2" align="center"><%=rs.getString("creation_date")%></td>
			</tr>
			<tr style="font-size:12px" id="tr_<%=rs.getString("request_id")%>">
				<td align="center" style="color:#FF0000;background-color:#E7D8E9">異動後</td>
				<td align="center" style="background-color:#E7D8E9"><% if (!rs.getString("NEW_RECEIVED_DATE").equals(rs.getString("OLD_RECEIVED_DATE"))){ out.println("<font color='red'>");}else{out.println("<font color='black'>");}%><%=rs.getString("NEW_RECEIVED_DATE")%></font></td><input type="hidden" name="NEW_RDATE_<%=rs.getString("request_id")%>" value="<%=rs.getString("NEW_RECEIVED_DATE")%>"></td>
				<td align="left" style="background-color:#E7D8E9"><% if (!rs.getString("NEW_LOT_NUMBER").equals(rs.getString("OLD_LOT_NUMBER"))){ out.println("<font color='red'>");}else{out.println("<font color='black'>");}%><%=rs.getString("NEW_LOT_NUMBER")%></font><input type="hidden" name="NEW_LOT_<%=rs.getString("request_id")%>" value="<%=rs.getString("NEW_LOT_NUMBER")%>"></td>
				<td align="left" style="background-color:#E7D8E9"><% if (!rs.getString("NEW_DATE_CODE").equals(rs.getString("OLD_DATE_CODE"))){ out.println("<font color='red'>");}else{out.println("<font color='black'>");}%><%=rs.getString("NEW_DATE_CODE")%></font><input type="hidden" name="NEW_DC_<%=rs.getString("request_id")%>" value="<%=rs.getString("NEW_DATE_CODE")%>"></td>
				<td align="right" style="background-color:#E7D8E9"><% if (!rs.getString("NEW_RECEIVED_QUANTITY").equals(rs.getString("OLD_RECEIVED_QUANTITY"))){ out.println("<font color='red'>");}else{out.println("<font color='black'>");}%><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("NEW_RECEIVED_QUANTITY")))%></font></td>
			</tr>
<%
		icnt++;
	}
	if (icnt >0)
	{
%>
		</table>
<%
		if (STATUS.equals("--") || STATUS.equals("N") || STATUS.equals(""))
		{
%>			
			<P>
			<table width="100%" cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#DCE6E7">
				<tr>
					<TD><font color="#666600"><strong><jsp:getProperty name="rPH" property="pgAction"/>=></strong></font>				
						<select NAME="ACTIONCODE" style="font-family: Tahoma,Georgia; font-size: 12px" onChange="subAction(this.value);">
						<OPTION VALUE=-->--</OPTION>
						<OPTION VALUE="Y"><jsp:getProperty name="rPH" property="pgApproval"/></OPTION>
						<OPTION VALUE="R"><jsp:getProperty name="rPH" property="pgReject"/></OPTION>
						</select>
						<INPUT TYPE="button" tabindex='41' value='Submit' name="Submit1" onClick='setSubmit1("../jsp/TEWPOReceiveProcess.jsp");' style="font-family: Tahoma,Georgia; font-size: 12px"></font>
						<INPUT TYPE="text"  name="reason"  value="退件原因說明:"  size="12" style="border-left:none;border-top:none;border-bottom:none;border-right:none;visibility:hidden;font-family: Tahoma,Georgia; font-size: 12px;color:#FF0000">
						<INPUT TYPE="text"  name="RESULT_MSG"  value="<%=RESULT_MSG%>" SIZE="40" style="visibility:hidden;font-family: Tahoma,Georgia; font-size: 12px">
					</td>
				</tr>
			</table>
			<hr>
<%
		}
	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<input type="hidden" name="TRANSTYPE" value="UPDATE">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

