<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
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
		document.MYFORM.elements["TEXT_"+lineid].disabled = false;
		document.MYFORM.elements["TEXT_"+lineid].value=document.MYFORM.SDATE.value;
		document.MYFORM.elements["IMG_"+lineid].style.width="20px";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["TEXT_"+lineid].disabled = true;
		document.MYFORM.elements["TEXT_"+lineid].value="";
		document.MYFORM.elements["IMG_"+lineid].style.width="0px";
	}
}
function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.TRANSTYPE.value =="" || document.MYFORM.TRANSTYPE.value =="--")
	{
		alert("請選擇執行動作!!");
		return false;
	}
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
			if (document.MYFORM.TRANSTYPE.value != "SHIPCANCEL")
			{
				if (document.MYFORM.elements["TEXT_"+lineid].value==null || document.MYFORM.elements["TEXT_"+lineid].value=="")
				{
					alert("Advise NO:"+lineid+" 交易日期不可空白!!!");
					return false;			
				}
				else if (parseFloat(document.MYFORM.elements["TEXT_"+lineid].value) > parseFloat(document.MYFORM.SDATE.value))
				{
					alert("Advise NO:"+lineid+" 交易日期不可大於今天!!!");
					return false;			
				}
				else
				{
					var isExit = false;
					for (var j = 0; j < document.MYFORM.ACCPERIOD.options.length; j++) 
					{
						if (document.MYFORM.ACCPERIOD.options[j].value ==document.MYFORM.elements["TEXT_"+lineid].value.substring(0,6))
						{
							isExit = true;
							break;
						}
					}	
					if (!isExit)
					{
						alert("Advise NO:"+lineid+" 交易日期錯誤(該月份未開帳)!!");
						return false;
					}			
				}
				if (document.MYFORM.elements["INVOICE_"+lineid].value==null || document.MYFORM.elements["INVOICE_"+lineid].value=="null" || document.MYFORM.elements["INVOICE_"+lineid].value=="")
				{
					alert("Advise NO:"+lineid+" 無供應商發票號碼!!!");
					return false;
				}
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	if (document.MYFORM.TRANSTYPE.value =="SHIPCANCEL")
	{
		if (confirm("您確定要取消出貨資料嗎?")==false) return false;
	}	
	document.MYFORM.save.disabled=true;
	document.MYFORM.btnqry.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
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
<title>TEW 出貨確認</title>
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
<%
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null || ADVISENO.equals("--")) ADVISENO="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String sql = "";
String ERPUSERID="";
PreparedStatement statement8 = con.prepareStatement(" select user_id from fnd_user a where user_name=UPPER(?)");
statement8.setString(1,UserName);
ResultSet rs8=statement8.executeQuery();
if (rs8.next())
{
	ERPUSERID = rs8.getString(1);
}
else
{
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("您沒有ERP帳號權限,請先向資訊單位申請,謝謝!");
		location.href="/oradds/ORADDSMainMenu.jsp";
	</script>
<%
}
rs8.close();
statement8.close();

%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TEWShipConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 出貨確認</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="10%"><font style="color:#666600;font-family: Tahoma,Georgia">Advist No:</font></td>
		<td width="90%">		<%
		try
		{   
			Statement st2=con.createStatement();
			sql =" select distinct b.tew_advise_no,b.tew_advise_no advise_no1 "+
	  		     " from tsc.tsc_shipping_advise_headers a,tsc.tsc_shipping_advise_lines b"+
		         " where a.SHIPPING_FROM='TEW' "+
				 " and a.advise_header_id = b.advise_header_id"+
		         " and b.VENDOR_SITE_ID is not null"+
		         " and exists (select 1 from tsc.TSC_PICK_CONFIRM_HEADERS y where y.advise_header_id = a.advise_header_id and  y.PICK_CONFIRM_DATE is null)"+
				 " order by b.tew_advise_no";
			//out.println(sql);    	 
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(ADVISENO);
			comboBoxBean.setFieldName("ADVISENO");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close(); 
		} //end of try		 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>	
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" name="btnqry" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TEWShipConfirm.jsp")' >
		<%
		Statement stateX=con.createStatement();
		String sqlX = " SELECT SUBSTR(TO_CHAR(PERIOD_START_DATE,'yyyymmdd'),1,6)  FROM INV.ORG_ACCT_PERIODS A where ORGANIZATION_ID='49' and OPEN_FLAG='Y'"; 
		ResultSet rsX=stateX.executeQuery(sqlX);
		out.println("<select NAME='ACCPERIOD' style='visibility: hidden;'>");				  			  
		out.println("<OPTION VALUE=-->--");     
		while (rsX.next())
		{  
			String s1=(String)rsX.getString(1); 
			String s2=(String)rsX.getString(1); 
			out.println("<OPTION VALUE='"+s1+"'>"+s2);
		}
		out.println("</select>");
		stateX.close();		  		  
		rsX.close();	
		%>	
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	sql = "  select a.* from (select  distinct a.tew_advise_no advise_no"+
		  ",CASE WHEN b.to_tw='Y' THEN 'TSCT' ELSE a.region_code END region_code"+
		  ",b.SHIPPING_METHOD"+
		  ",a.vendor_site_id"+
		  ",c.vendor_site_code"+
		  ",b.to_tw,TO_CHAR(A.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD"+
		  ",e.INVOICE_NO"+
		  ",row_number() over (partition by a.tew_advise_no order by a.region_code) row_cnt"+
		  " from tsc.tsc_shipping_advise_lines a"+
		  ",tsc.tsc_shipping_advise_headers b"+
		  ",ap.ap_supplier_sites_all c"+
		  ",apps.TSC_VENDOR_INVOICE_LINES e"+
		  " where  b.SHIPPING_FROM=? "+
		  " and b.advise_header_id = a.advise_header_id "+
		  " and a.vendor_site_id = c.vendor_site_id(+)"+
		  " and a.tew_advise_no = e.tew_advise_no(+)"+
		  " and a.VENDOR_SITE_ID is not null"+
		  " and exists (select 1 from tsc.TSC_PICK_CONFIRM_HEADERS y where y.advise_header_id = b.advise_header_id and  y.PICK_CONFIRM_DATE is null)"+
	      " and a.tew_advise_no like ?) a where  row_cnt=1 "+
		  " order by a.advise_no ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"TEW");
	statement.setString(2,(ADVISENO.equals("")?"%":ADVISENO));
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	String po_remarks =""; //add by Peggy 20140729
	while (rs.next())
	{		
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
			<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
				<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
				<td width="3%">序號</td>
				<td width="8%">交易日</td>
				<td width="8%" align="center">Advise No</td>
				<!--<td width="24%" align="center">客戶</td>-->
				<td width="10%" align="center">供應商</td>
				<td width="10%" align="center">業務區</td>
				<td width="10%" align="center">出貨方式</td>
				<td width="8%" align="center">排定出貨日</td>
				<!--<td width="5%" align="center">幣別</td>-->
				<td width="5%" align="center">回T</td>
				<td width="10%" align="center">供應商發票號碼</td>
				<td width="26%" align="center">備註</td>
			</tr>
		
<%
		}
		po_remarks="";
		sql = " SELECT distinct  y.segment1 po_no,NVL (y.approved_flag, 'N') approved_flag, NVL (y.cancel_flag, 'N') cancel_flag,NVL (y.closed_code, 'OPEN') closed_code,y.AUTHORIZATION_STATUS"+
		      ",z.name,g.LAST_NAME1||g.FIRST_NAME1 buyer"+
              " FROM oraddman.tew_lot_allot_detail x, po_headers_all y"+
			  ",(select object_id, name from (select a.object_id ,b.LAST_NAME1||b.FIRST_NAME1 name,row_number() over (partition by a.object_id order by a.SEQUENCE_NUM) seq "+
              " from po_action_history a,ahr.ahr_employees_all b WHERE a.OBJECT_TYPE_CODE='PO' and a.employee_id = b.PERSON_ID and a.ACTION_CODE is null) x where seq=1) z"+
			  ",ahr.ahr_employees_all g"+
              " WHERE x.po_header_id = y.po_header_id"+
			  " and y.TYPE_LOOKUP_CODE='STANDARD'"+
			  " and y.po_header_id = z.object_id(+)"+
			  " and y.AGENT_ID = g.PERSON_ID(+)"+
              " and x.tew_advise_no=?";
		PreparedStatement statement9 = con.prepareStatement(sql);
		statement9.setString(1,rs.getString("advise_no"));
		ResultSet rs9=statement9.executeQuery();
		while (rs9.next())
		{
			if (!rs9.getString("approved_flag").equals("Y"))
			{
				if (rs9.getString("AUTHORIZATION_STATUS").equals("REJECTED"))
				{
					po_remarks +=(!po_remarks.equals("")?"<br>":"")+"<font color='red'>採購單號:"+rs9.getString("po_no") + " 被退件,尚未重新送審</font>";
				}
				else
				{
					po_remarks +=(!po_remarks.equals("")?"<br>":"")+"<font color='red'>採購單號:"+rs9.getString("po_no") + " 尚未核淮</font>";
					if (!rs9.getString("AUTHORIZATION_STATUS").equals("IN PROCESS") || rs9.getString("approved_flag").equals("R"))
					{
						po_remarks +="<font color='#000000'>(採購人員:"+rs9.getString("buyer")+" 尚未送簽)</font>";
					}
					else
					{
						po_remarks +="<font color='#000000'>(主管:"+rs9.getString("name")+" 尚未簽核)<font>";
					}
				}
			}
			if (!rs9.getString("cancel_flag").equals("N"))
			{
				po_remarks +=(!po_remarks.equals("")?"<br>":"")+"採購單號:"+rs9.getString("po_no") + " 已Cancelled";
			}
			if (rs9.getString("closed_code").indexOf("CLOSED") >=0)
			{
				po_remarks +=(!po_remarks.equals("")?"<br>":"")+"採購單號:"+rs9.getString("po_no") + " 已結案";
			}
		}
		rs9.close();
		statement9.close();	
		
		//檢查LOT是否PENDING在修改待核淮的LIST中,add by Peggy 20141204
		sql = " select distinct LOT_NUMBER from oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_revise b"+ 
			  " where a.TEW_ADVISE_NO=? and a.po_line_location_id = b.po_line_location_id "+
			  " and a.seq_id = b.seq_id and NVL(b.approve_flag,'N')='N'";
		//out.println(sql);
		statement9 = con.prepareStatement(sql);
		statement9.setString(1,rs.getString("advise_no"));
		rs9=statement9.executeQuery();
		while (rs9.next())
		{	
			po_remarks +=(!po_remarks.equals("")?"<br>":"")+"<font color='red'>LOT號:"+rs9.getString(1) + " 申請修改等待核淮中</font>";
		}
		rs9.close();
		statement9.close();	
		
%>
			<tr style="font-family:airl;font-size:11px" id="tr_<%=rs.getString("ADVISE_NO")%>">
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("ADVISE_NO")%>" onClick="setCheck(<%=icnt%>)" <%=(po_remarks.equals("")?"":"disabled")%>></td>
				<td align="center"><%=(icnt+1)%></td>
				<td><input type="text" name="TEXT_<%=rs.getString("ADVISE_NO")%>" SIZE="8" style="font-family: Tahoma,Georgia;" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" disabled readonly>&nbsp;<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.TEXT_<%=rs.getString("ADVISE_NO")%>);return false;"><img name="IMG_<%=rs.getString("ADVISE_NO")%>" border="0" src="../image/calbtn.gif" width="0"></A></td>
				<td align="center"><%=rs.getString("ADVISE_NO")%></td>
				<td><%=rs.getString("VENDOR_SITE_CODE")%></td>
				<td><%=rs.getString("REGION_CODE")%></td>
				<td><%=rs.getString("SHIPPING_METHOD")%></td>
				<td align="center"><%=rs.getString("SSD")%></td>
				<td align="center"><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%></td>
				<td align="center"><%=(rs.getString("INVOICE_NO")==null?"&nbsp;":rs.getString("INVOICE_NO"))%><input type="hidden" name="INVOICE_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("INVOICE_NO")%>"></td>
				<td><%=(po_remarks.equals("")?"&nbsp;":po_remarks)%></td>
			</tr>
<%
		icnt++;
	}
	if (icnt >0)
	{
%>
		</table>
		<hr>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#DCE6E7">
			<tr>
				<tr><td>執行動作：<select NAME="TRANSTYPE" style="font-family:ARIAL;" onChange="changobj()">
				<OPTION VALUE=-- <%if (TRANSTYPE.equals("")) out.println("selected");%>>--</OPTION>
				<OPTION VALUE="SHIPCONFIRM" <%if (TRANSTYPE.equals("SHIPCONFIRM")) out.println("selected");%>>出貨確認</OPTION>
		        <OPTION VALUE="SHIPCANCEL" <%if (TRANSTYPE.equals("SHIPCANCEL")) out.println("selected");%>>出貨取消</OPTION>
				</select>
				<input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TEWPickProcess.jsp')"></td></tr>
			</tr>
		</table>		
<%
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
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
<input type="hidden" name="SDATE" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

