<%@ page language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{    
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="",radflag="",i_res="",rcv_trx_id="";
	if (document.MYFORM.chk.length != undefined)
	{
		chk_len = document.MYFORM.chk.length;
	}
	else
	{
		chk_len = 1;
	}

	for (var i =0 ; i < chk_len ;i++)
	{
		if (chk_len==1)
		{
			chkflag = document.MYFORM.chk.checked; 
			id = document.MYFORM.chk.value;		
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
			id = document.MYFORM.chk[i].value;		
		}
		if (chkflag==true)
		{
			chkcnt ++;
		}
	}
	if (chkcnt ==0)
	{
		alert("Please choose a item!");
		return false;
	}
	document.MYFORM.submiterp.disabled=true;
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
}
function setSubmit2(URL)
{    
	subWin=window.open("../jsp/TSCSGItemSafetyStockUpload.jsp","subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit3(jobid)
{   
	document.MYFORM.action="../jsp/TSCSGItemSafetyStockReqNotice.jsp?JOB_ID="+jobid;
 	document.MYFORM.submit(); 
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setChkboxPress(i+1,document.MYFORM.chk[i].value);
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setChkboxPress(i+1,document.MYFORM.chk[i].value);
		}
	}
}
function setChkboxPress(Lineno,id)
{
	var checkvalue=false;
	if (document.MYFORM.chk.length != undefined)
	{
		checkvalue =document.MYFORM.chk[Lineno-1].checked;
	}
	else
	{
		checkvalue =document.MYFORM.chk.checked;
	}
	if (!checkvalue)
	{
		document.getElementById("td_"+id).style.backgroundColor ="#FFFFFF";
	}
	else
	{
		document.getElementById("td_"+id).style.backgroundColor ="#C4F8A5";
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>SG Safety Stock Request</title>
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
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String C_MONTH = request.getParameter("C_MONTH");
if (C_MONTH==null || C_MONTH.equals("--")) C_MONTH="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGItemSafetyStockRequest.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Safety Stock Request </font></strong>
<BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 400px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">The data processing,please wait while.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="7%"><font color="#666600" >Org Code:</font></td>   
		<td width="7%"><select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="SG1" <%if (ORGCODE.equals("SG1")) out.println("selected");%>>SG-D</OPTION>
		<OPTION VALUE="SG2" <%if (ORGCODE.equals("SG2")) out.println("selected");%>>SG-E</OPTION>
		</select>
		</td>	
		<td width="15%"><font color="#666600">Item Name/Description:</font></td>
		<td width="15%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family:Arial;font-size:12px" size="25"></td>
		<td width="15%"><font color="#666600">Calculate  Month:</font></td>
		<td width="15%">		
		<%
	      PreparedStatement statement1 = con.prepareStatement("SELECT C_MONTH,C_MONTH FROM (SELECT C_MONTH FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK_REQUEST a GROUP BY C_MONTH ORDER BY C_MONTH desc) WHERE ROWNUM<=5");
		  ResultSet rs1=statement1.executeQuery();			
		  comboBoxBean.setRs(rs1);
	      comboBoxBean.setSelection(C_MONTH);
	      comboBoxBean.setFieldName("C_MONTH");	   
          out.println(comboBoxBean.getRsString());		
		  rs1.close();
		  statement1.close();	
		%>
		</td>
		<td>
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGItemSafetyStockRequest.jsp")' > 
		<%
			if (UserRoles.equals("admin") || UserName.startsWith("CYTSOU") || UserName.startsWith("JUDY_") || UserName.startsWith("PERRY.JUAN")) //ADD JUDY BY PEGGY 20211007
			{
		%>
			&nbsp;
			<INPUT TYPE="button" align="middle"  value='Upload Safety Stock' onClick='setSubmit2("../jsp/TSCSGItemSafetyStockUpload.jsp")'  style="font-family: Tahoma,Georgia" > 
		<%
			}
			
		%>		
			&nbsp;
			<INPUT TYPE="button" align="middle"  value='Excel' onClick='setSubmit("../jsp/TSCSGItemSafetyStockReqExcel.jsp")'  style="font-family: Tahoma,Georgia" > 
		</td>
	</tr>
</table> 
<HR>
<%
try
{
	sql = " SELECT  a.organization_code,a.c_month"+
          " ,(SELECT count(distinct job_id)+1 FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK_REQUEST x WHERE x.c_month=a.c_month and x.job_id<a.job_id ) req_times"+
          " ,a.item_desc,a.safety_seq_id,a.inventory_item_id, a.item_name,"+
          " a.suggest_safety_stock, a.safety_job_id, a.approve_item_id,"+
          " a.approve_item_name, a.approve_item_desc, a.approve_qty,"+
          " a.vendor_id, a.vendor_site_id, a.pr_no, a.po_no, a.status,"+
          " a.error_msg, to_char(a.creation_date,'yyyy-mm-dd') creation_date, a.created_by, to_char(a.approved_date,'yyyy-mm-dd') approved_date,"+
          " a.approved_by, to_char(a.last_update_date,'yyyy-mm-dd') last_update_date , a.last_updated_by,B.VENDOR_SITE_CODE "+
		  " FROM ORADDMAN.TSSG_ITEM_SAFETY_STOCK_REQUEST A,AP.AP_SUPPLIER_SITES_ALL B"+
		  " WHERE A.VENDOR_SITE_ID=B.VENDOR_SITE_ID(+)";
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " AND A.ORGANIZATION_CODE='"+ORGCODE+"'";
	}
	if (!ITEM.equals(""))
	{
		sql += " AND (A.ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%' OR A.APPROVE_ITEM_NAME LIKE '"+ ITEM.toUpperCase()+"%' OR A.APPROVE_ITEM_DESC LIKE '"+ITEM.toUpperCase()+"%')";
	}
	if (!C_MONTH.equals(""))
	{
		sql += " AND a.C_MONTH='"+C_MONTH +"'";
	}
	sql += " order by 1,2 desc,3 desc,4";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	ResultSet rs=statement.executeQuery();
	int icnt =0;
	while (rs.next())
	{
		if (icnt ==0)
		{
%>
		<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
			<tr bgcolor="#C8E3E8" style="font-family: Tahoma,Georgia;font-size:11px" align="center">
				<td width="2%">&nbsp;</td>
				<td width="2%" align="center"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
				<td width="3%">Org Code</td>
				<td width="4%">Month</td>
				<td width="4%">Req Times</td>
				<td width="11%">Item Name</td>
				<td width="8%">Item Desc</td>
				<td width="6%">Suggest Safety Stock(PCS)</td>
				<td width="8%">Approve Item Desc</td>
				<td width="6%">Approve Qty</td>
				<td width="7%">Vendor Site Code</td>
				<td width="6%">PR</td>
				<td width="6%">PO</td>
				<td width="5%">Creation Date</td>
				<td width="7%">Created By</td>
				<td width="5%">Approve Date</td>
				<td width="7%">Approved By</td>
			</tr>
			
<%		
		}
		icnt++;
%>
			<tr id="td_<%=rs.getString("safety_seq_id")%>">
				<td><%=icnt%></td>
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("safety_seq_id")%>" onClick="setChkboxPress('<%=icnt%>','<%=rs.getString("safety_seq_id")%>')" <%=(rs.getString("PO_NO")!=null?"disabled":"")%>></td>
				<td align="center"><%=rs.getString("ORGANIZATION_code")%></td>
				<td align="center"><%=rs.getString("C_MONTH")%></td>
				<td align="left"><%=rs.getString("REQ_TIMES")%></td>
				<td align="left"><%=rs.getString("ITEM_NAME")%></td>
				<td align="left"><%=rs.getString("ITEM_DESC")%></td>
				<td align="right"><%=rs.getString("SUGGEST_SAFETY_STOCK")%></td>
				<td align="right"><%=(rs.getString("APPROVE_ITEM_DESC")==null?"&nbsp;":rs.getString("APPROVE_ITEM_DESC"))%></td>
				<td align="right"><%=(rs.getString("APPROVE_QTY")==null?"&nbsp;":rs.getString("APPROVE_QTY"))%></td>
				<td align="center"><%=(rs.getString("VENDOR_SITE_CODE")==null?"&nbsp;":rs.getString("VENDOR_SITE_CODE"))%></td>
				<td align="center"><%=(rs.getString("PR_NO")==null?"&nbsp;":rs.getString("PR_NO"))%></td>
				<td align="center"><%=(rs.getString("PO_NO")==null?"&nbsp;":rs.getString("PO_NO"))%></td>
				<td align="center"><%=rs.getString("CREATION_DATE")%></td>
				<td align="center"><%=rs.getString("CREATED_BY")%></td>
				<td align="center"><%=(rs.getString("APPROVED_DATE")==null?"&nbsp;":rs.getString("APPROVED_DATE"))%></td>
				<td align="center"><%=(rs.getString("APPROVED_BY")==null?"&nbsp;":rs.getString("APPROVED_BY"))%></td>
			</tr>
<%
	}
	rs.close();
	statement.close();
	if (icnt >0)
	{
	%>
		</table>
		<table>
			<tr>
				<td><!--<input type="button" name="submiterp" value="Submit To ERP" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit1("../jsp/TSCSGItemSafetyStockDetail.jsp")'>--></td>
			</tr>
		</table>
	<%
	
	}
	else
	{
		out.println("<div align='center'><font color='red' size='2' face='Tahoma,Georgia'><strong>No data found!</strong></font></div>");
	}
	
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

