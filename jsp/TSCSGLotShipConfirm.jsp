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
		document.getElementById("IMG_"+lineid).style.width="20px";
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["TEXT_"+lineid].disabled = true;
		document.MYFORM.elements["TEXT_"+lineid].value="";
		document.getElementById("IMG_"+lineid).style.width="0px";
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
				//alert(document.MYFORM.elements[""+lineid+"_issue"].value);
				if (document.MYFORM.elements["ship_"+lineid].value=="Y")
				{
					alert("Advise NO:"+lineid+" 出貨日不在本月者不允許出貨確認 !!!");
					return false;			
				}
				if (document.MYFORM.elements["gw_flag_"+lineid].value=="Y")
				{
					alert("Advise NO:"+lineid+" 毛重異常,不允許出貨確認 !!!");
					return false;			
				}
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
					if ( document.MYFORM.elements["SHIP_FROM_"+lineid].value =="SG1")
					{
						for (var j = 0; j < document.MYFORM.ACCPERIODSG1.options.length; j++) 
						{
							if (document.MYFORM.ACCPERIODSG1.options[j].value ==document.MYFORM.elements["TEXT_"+lineid].value.substring(0,6))
							{
								isExit = true;
								break;
							}
						}
					}
					else
					{
						for (var j = 0; j < document.MYFORM.ACCPERIODSG2.options.length; j++) 
						{
							if (document.MYFORM.ACCPERIODSG2.options[j].value ==document.MYFORM.elements["TEXT_"+lineid].value.substring(0,6))
							{
								isExit = true;
								break;
							}
						}
					}	
					if (!isExit)
					{
						alert("Advise NO:"+lineid+" 交易日期錯誤(該月份未開帳)!!");
						return false;
					}			
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
<title>SG Ship Confirm</title>
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
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGLotShipConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Ship Confirm</font></strong>
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
		         " where a.SHIPPING_FROM LIKE 'SG%' "+
				 " and a.advise_header_id = b.advise_header_id"+
		         " and b.VENDOR_SITE_ID is not null"+
		         " and exists (select 1 from tsc.TSC_PICK_CONFIRM_HEADERS y where y.advise_header_id = a.advise_header_id and y.pick_status='Y' and y.PICK_CONFIRM_DATE is null)"+
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
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" name="btnqry" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>'  style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCSGLotShipConfirm.jsp")' >
		<%
		Statement stateX=con.createStatement();
		String sqlX = " SELECT SUBSTR(TO_CHAR(PERIOD_START_DATE,'yyyymmdd'),1,6)  FROM INV.ORG_ACCT_PERIODS A,INV.MTL_PARAMETERS B where A.ORGANIZATION_ID=B.ORGANIZATION_ID AND b.ORGANIZATION_CODE='SG1' and OPEN_FLAG='Y'"; 
		ResultSet rsX=stateX.executeQuery(sqlX);
		out.println("<select NAME='ACCPERIODSG1' style='visibility: hidden;'>");				  			  
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
		
		stateX=con.createStatement();
		sqlX = " SELECT SUBSTR(TO_CHAR(PERIOD_START_DATE,'yyyymmdd'),1,6)  FROM INV.ORG_ACCT_PERIODS A,INV.MTL_PARAMETERS B where A.ORGANIZATION_ID=B.ORGANIZATION_ID AND b.ORGANIZATION_CODE='SG2' and OPEN_FLAG='Y'"; 
		rsX=stateX.executeQuery(sqlX);
		out.println("<select NAME='ACCPERIODSG2' style='visibility: hidden;'>");				  			  
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
	sql = "  select a.* ,b.carton_gw_issue from (select  distinct a.tew_advise_no advise_no"+
		  ",CASE WHEN b.to_tw='Y' THEN 'TSCT' ELSE a.region_code END region_code"+
		  ",b.shipping_method"+
		  ",a.vendor_site_id"+
		  ",c.vendor_site_code"+
		  ",b.to_tw,TO_CHAR(A.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') SSD"+
		  ",b.SHIPPING_FROM"+
		  ",case b.SHIPPING_FROM when 'SG1' then '內銷' when 'SG2' then '外銷' else b.SHIPPING_FROM end SHIPPING_FROM_NAME"+ 
		  //",e.INVOICE_NO"+
		  ",row_number() over (partition by a.tew_advise_no order by a.region_code) row_cnt"+
		  " from tsc.tsc_shipping_advise_lines a"+
		  ",tsc.tsc_shipping_advise_headers b"+
		  ",ap.ap_supplier_sites_all c"+
		  " where  b.shipping_from like ?||'%' "+
		  " and b.advise_header_id = a.advise_header_id "+
		  " and a.vendor_site_id = c.vendor_site_id(+)"+
		  " and a.VENDOR_SITE_ID is not null"+
		  " and exists (select 1 from tsc.TSC_PICK_CONFIRM_HEADERS y where y.advise_header_id = b.advise_header_id and y.pick_status=? and y.PICK_CONFIRM_DATE is null)"+
	      " and a.tew_advise_no like ?) a"+
		  ",(SELECT tew_advise_no,listagg('第'||carton_num_fr||'箱毛重不可為空<br>') within group(order by carton_num_fr) carton_gw_issue "+
          " from (SELECT a.tew_advise_no,a.carton_num_fr,a.gross_weight"+
          " ,row_number() over (partition by a.tew_advise_no,CARTON_NUM_FR order by nvl(GROSS_WEIGHT,0) desc) row_seq"+
          " FROM tsc.tsc_shipping_advise_lines a"+
          " where tew_advise_no like ?"+
          " order by TEW_ADVISE_NO,CARTON_NUM_FR) x where x.ROW_SEQ=1 and nvl(x.GROSS_WEIGHT,0)<=0  group by tew_advise_no) b "+
		  " where a.row_cnt=1"+
		  " and a.advise_no=b.tew_advise_no(+)"+
		  " order by a.advise_no ";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,"SG");
	statement.setString(2,"Y");
	statement.setString(3,(ADVISENO.equals("")?"%":ADVISENO));
	statement.setString(4,(ADVISENO.equals("")?"%":ADVISENO));
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	String po_remarks =""; 
	while (rs.next())
	{		
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="1">
			<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
				<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
				<td width="3%">序號</td>
				<td width="12%">交易日</td>
				<td width="6%" align="center">內外銷</td>
				<td width="8%" align="center">Advise No</td>
				<!--<td width="24%" align="center">客戶</td>-->
				<!--<td width="10%" align="center">供應商</td>-->
				<td width="10%" align="center">業務區</td>
				<td width="10%" align="center">出貨方式</td>
				<td width="8%" align="center">排定出貨日</td>
				<!--<td width="5%" align="center">幣別</td>-->
				<td width="5%" align="center">回T</td>
				<!--<td width="10%" align="center">供應商發票號碼</td>-->
				<td width="18%" align="center">毛重檢查</td>
				<td width="18%" align="center">備註</td>
			</tr>
		
<%
		}
		
%>
			<tr style="font-family:airl;font-size:11px" id="tr_<%=rs.getString("ADVISE_NO")%>">
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("ADVISE_NO")%>" onClick="setCheck(<%=icnt%>)"></td>
				<td align="center"><%=(icnt+1)%></td>
				<td align="center"><input type="text" name="TEXT_<%=rs.getString("ADVISE_NO")%>" SIZE="8" style="font-family: Tahoma,Georgia;" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" disabled readonly>&nbsp;<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.TEXT_<%=rs.getString("ADVISE_NO")%>);return false;"><img id="IMG_<%=rs.getString("ADVISE_NO")%>" name="IMG_<%=rs.getString("ADVISE_NO")%>" border="0" src="../image/calbtn.gif" width="0"></A></td>
				<td align="center"><%=rs.getString("SHIPPING_FROM_NAME")%><input type="hidden" name="SHIP_FROM_<%=rs.getString("ADVISE_NO")%>" value="<%=rs.getString("SHIPPING_FROM")%>"></td>
				<td align="center"><%=rs.getString("ADVISE_NO")%></td>
				<td><%=rs.getString("REGION_CODE")%></td>
				<td><%=rs.getString("SHIPPING_METHOD")%></td>
				<td align="center"><%=rs.getString("SSD")%><input type="hidden" name="ship_<%=rs.getString("ADVISE_NO")%>" value="<%=(Integer.parseInt(rs.getString("SSD").substring(0,6))>Integer.parseInt(dateBean.getYearMonthDay().substring(0,6))?"Y":"N")%>"><input type="hidden" name="gw_flag_<%=rs.getString("ADVISE_NO")%>" value="<%=(rs.getString("carton_gw_issue")==null?"N":"Y")%>"></td>
				<td align="center"><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%></td>
				<td style="color:#ff0000"><%=(rs.getString("carton_gw_issue")==null?"&nbsp;":rs.getString("carton_gw_issue"))%></td>
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
				<input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGLotDistributionProcess.jsp')"></td></tr>
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

