<!-- modify by Peggy 20140902,客戶=CHANNEL WELL, 箱碼固定為D,且放置在箱數前面,例D1,D2..-->
<!-- modify by Peggy 20150203,同箱同型號同DATE CODE,不可超過兩個LOT-->
<!-- modify by Peggy 20160614,回T訂單改由天津出貨驗收,1131,1141入I1 15倉,1121入I20 40倉然後轉回I1 15倉-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	if (document.MYFORM.ADVISENO.value =="" || document.MYFORM.ADVISENO.value =="--")
	{
		alert("請選擇Advise No!!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	//if (document.MYFORM.SUBINVENTORY.value=="")
	//{
	//	alert("請輸入倉庫代碼");
	//	return false;
	//}
	//else
	//{
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
				 if (document.getElementById("div_"+lineid).innerHTML==null || document.getElementById("div_"+lineid).innerHTML=="" || parseFloat(document.getElementById("div_"+lineid).innerHTML) != parseFloat(document.MYFORM.elements["TOT_QTY_"+lineid].value))
				 {
					document.getElementById("div_"+lineid).style.Color = "#ff0000";
					alert("資料異常!!請檢查撿貨量是否等於出貨量,謝謝!!");
					return false;
				 }
			}
		}
	//}
	document.MYFORM.save1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function  setSubmit2(so_line_id)
{
	if (confirm("您確定要刪除此筆訂單資料?"))
	{
		document.MYFORM.action="../jsp/TEWPickConfirm.jsp?ATYPE=DEL&ADVISENO="+document.MYFORM.ADVISENO1.value+"&ID="+so_line_id;
		document.MYFORM.submit();
	}
}
function setSubmit3(URL)
{
	document.MYFORM.save1.disabled= true;
	subWin=window.open(URL,"subwin","left=200,width=800,height=600,scrollbars=yes,menubar=no");
}

</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline; font-size: 11px  }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>TEW Pick Confirm</title>
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
String sql = "";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
//String SUBINVENTORY = request.getParameter("SUBINVENTORY");
//if (SUBINVENTORY==null) SUBINVENTORY="14";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String ERPUSERID="";
String strdetail="";
double tot_allot=0;
String carton_lot_cnt ="";  //add by Peggy 20150203
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

if (ATYPE.equals("DEL"))
{
	try
	{
		if (ID.equals("-999"))
		{
			PreparedStatement pstmtDt=con.prepareStatement("delete oraddman.tew_lot_allot_detail a where exists (select 1 from tsc.tsc_shipping_advise_lines b where b.TEW_ADVISE_NO=? and b.advise_line_id = a.advise_line_id and b.tew_advise_no = a.tew_advise_no)");  
			pstmtDt.setString(1,ADVISENO);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
		else
		{
			PreparedStatement pstmtDt=con.prepareStatement("delete oraddman.tew_lot_allot_detail a where exists (select 1 from tsc.tsc_shipping_advise_lines b where b.TEW_ADVISE_NO=? and b.SO_LINE_ID =? and b.advise_line_id = a.advise_line_id and b.tew_advise_no = a.tew_advise_no)");  
			pstmtDt.setString(1,ADVISENO);
			pstmtDt.setString(2,ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
%>
	<script language="JavaScript" type="text/JavaScript">
		alert("資料刪除成功!");
	</script>
<%		
	}
	catch(Exception e)
	{
		out.println("<font color='red'>Exception2:"+e.getMessage()+"</font>");
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TEWPickConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">TEW 撿貨確認</font></strong>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="10%"><font color="#666600">Advise No:</font></td>
		<td width="90%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("select tew_advise_no advise_no,tew_advise_no advise_no1 from oraddman.tew_lot_allot_detail a where confirm_flag='N' group by tew_advise_no order by tew_advise_no ");
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(ADVISENO);
			comboBoxBean.setFieldName("ADVISENO");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} //end of try		 
		catch (Exception e) 
		{ 
			//out.println("Exception:"+e.getMessage()); 
		} 
		%>		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TEWPickConfirm.jsp")' > 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='出貨批號明細表' onClick='setSubmit("../jsp/TEWPickConfirmExcel.jsp")' > 
		</td>
	</tr>
</table> 
<hr>
<%
try
{
	if (ADVISENO.equals("--") || ADVISENO.equals(""))
	{
		out.println("<div align='center'><font color='blue' size='2' face='新細明體'><strong>請選擇Advise No!</strong></font></div>");
	}
	else
	{
		/*sql = " select c.VENDOR_SITE_CODE"+
		      ",a.vendor_site_id"+
			  ",b.shipping_method"+
			  ",a.SHIPPING_REMARK"+
			  ",a.tew_advise_no advise_no"+
			  ",b.advise_header_id"+
			  ",a.advise_line_id"+
			  ",a.so_no"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",a.so_line_number"+
			  ",a.item_no"+
			  ",a.item_desc"+
			  ",a.inventory_item_id"+
			  ",to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
			  ",(a.ship_qty/1000) SHIP_QTY"+
			  ",a.carton_num_fr"+
			  ",a.carton_num_to"+
			  ",(a.CARTON_PER_QTY/1000) CARTON_PER_QTY"+
			  ",(a.TOTAL_QTY/1000) TOTAL_QTY"+
			  ",b.POST_FIX_CODE"+
			  ",nvl((SELECT SUM(ALLOT_QTY)/1000 ALLOT_QTY FROM oraddman.tew_lot_allot_detail X WHERE x.ADVISE_LINE_ID=a.advise_line_id AND x.CONFIRM_FLAG='N'),0) ALLOT_QTY"+
			  " FROM tsc.tsc_shipping_advise_lines a"+
			  ",tsc.tsc_shipping_advise_headers b"+
			  ",ap.ap_supplier_sites_all c"+
			  " where  a.tew_advise_no=? "+
			  " and b.SHIPPING_FROM=? "+
			  " and b.advise_header_id = a.advise_header_id "+
			  " and a.vendor_site_id = c.vendor_site_id(+)"+
			  " and exists (select 1 from oraddman.tew_lot_allot_detail x where x.advise_header_id = b.advise_header_id and x.CONFIRM_FLAG=?)"+
			  " order by a.carton_num_fr,a.carton_num_to,a.advise_line_id ";*/
		sql = " SELECT x.to_tw,x.VENDOR_SITE_CODE,x.vendor_site_id,x.shipping_method,x.SHIPPING_REMARK,x.advise_no,x.advise_header_id,x.so_no,x.so_header_id"+
              ",x.so_line_id,x.so_line_number,x.item_no,x.item_desc,x.inventory_item_id,x.pc_schedule_ship_date,x.POST_FIX_CODE,sum(x.SHIP_QTY) SHIP_QTY"+
              ",min(x.carton_num_fr) carton_num_fr,max(x.carton_num_to) carton_num_to,sum(x.TOTAL_QTY) TOTAL_QTY,sum(x.ALLOT_QTY) ALLOT_QTY "+            
			  ",TEW_RCV_PKG.GET_ORDER_CARTON_LIST('ORDER_LINE',x.tew_advise_no,x.so_line_id,'0','0') carton_list"+
			  " FROM (select a.tew_advise_no,c.VENDOR_SITE_CODE ,a.vendor_site_id ,b.shipping_method ,a.SHIPPING_REMARK ,a.tew_advise_no advise_no,b.advise_header_id"+
              "       ,a.advise_line_id,a.so_no,a.so_header_id,a.so_line_id,a.so_line_number,a.item_no,a.item_desc,a.inventory_item_id,to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
              "       ,b.POST_FIX_CODE,(a.ship_qty/1000) SHIP_QTY,a.carton_num_fr,a.carton_num_to,(a.CARTON_PER_QTY/1000) CARTON_PER_QTY,(a.TOTAL_QTY/1000) TOTAL_QTY"+
              "       ,nvl((SELECT SUM(ALLOT_QTY)/1000 ALLOT_QTY FROM oraddman.tew_lot_allot_detail X WHERE x.ADVISE_LINE_ID=a.advise_line_id AND x.CONFIRM_FLAG='N'),0) ALLOT_QTY"+
			  "       ,nvl(b.TO_TW,'N') TO_TW"+  //add by Peggy 20160614
              "       FROM tsc.tsc_shipping_advise_lines a"+
              "       ,tsc.tsc_shipping_advise_headers b"+
              "       ,ap.ap_supplier_sites_all c"+
              "       where  a.tew_advise_no=? "+
              "       and b.SHIPPING_FROM=?"+
              "       and b.advise_header_id = a.advise_header_id "+
              "       and a.vendor_site_id = c.vendor_site_id(+)"+
              "       and exists (select 1 from oraddman.tew_lot_allot_detail x where x.advise_header_id = b.advise_header_id and x.CONFIRM_FLAG=?)"+
              "       order by a.carton_num_fr,a.carton_num_to,a.advise_line_id ) x "+
              " group by x.to_tw,x.VENDOR_SITE_CODE,x.vendor_site_id,x.shipping_method,x.SHIPPING_REMARK,x.advise_no,x.advise_header_id,x.so_no,x.so_header_id"+
              " ,x.so_line_id,x.so_line_number,x.item_no,x.item_desc,x.inventory_item_id,x.pc_schedule_ship_date,x.POST_FIX_CODE"+
			  " ORDER BY CARTON_NUM_FR";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISENO);
		statement.setString(2,"TEW");
		statement.setString(3,"N");
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		float ALLOT_QTY=0;
		String strColor=""; 
		while (rs.next())
		{		
			if (icnt ==0)
			{
	%>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#DCE6E7">
				<tr>
					<td width="15%"><font style="font-weight:bold;font-size:11px">供應商:</font><%=rs.getString("VENDOR_SITE_CODE")%></td>
				</tr>		<tr>
					<td width="15%"><font style="font-weight:bold;font-size:11px">Advise No:</font><%=rs.getString("advise_no")%><input type="hidden" name="ADVISENO1" VALUE="<%=rs.getString("advise_no")%>"></td>
				</tr>
				<tr>
					<td width="15%"><font style="font-weight:bold;font-size:11px">出貨日期:</font><%=rs.getString("pc_schedule_ship_date")%></td>
				</tr>
				<tr>
					<td width="15%"><font style="font-weight:bold;font-size:11px">回T:</font><%=(rs.getString("TO_TW").equals("Y")?"是":"否")%><input type="hidden" name="TOTW" VALUE="<%=rs.getString("TO_TW")%>"></td>
				</tr>
				</table>
				<HR>
				<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
					<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
						<!--<td width="8%">Advise No</td>-->
						<!--<td width="8%">供應商</td>-->
						<!--<td width="6%">出貨日期</td>-->
						<td width="10%">&nbsp;</td>
						<td width="8%">MO#</td>
						<td width="4%">訂單項次</td>
						<td width="14%">料號</td>
						<td width="12%">型號</td>
						<td width="14%">嘜頭</td>
						<td width="8%">出貨方式</td>
						<td width="10%">C/NO</td>
						<td width="6%">出貨量(K)</td>
						<td width="6%">撿貨量(K)</td>
						<td width="6%"><input type="button" name="delAll" value="全部刪除" style="font-family:arial;font-size:11px" onClick="setSubmit2(-999)"></td>
					</tr>
	<%		
				sql = " select distinct carton_num from (select A.ADVISE_LINE_ID,A.CARTON_NUM,B.DATE_CODE,count(distinct a.lot_number) carton_lot_cnt from oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_detail b "+
				  	  " where a.seq_id = b.seq_id "+
                      " and TEW_ADVISE_NO=?"+
                      " group by  A.ADVISE_LINE_ID,A.CARTON_NUM,B.DATE_CODE "+
                      " having count(distinct a.lot_number)>2) x"+
                      " order by x.carton_num";
				PreparedStatement statement1 = con.prepareStatement(sql);
				statement1.setString(1,ADVISENO);
				ResultSet rs1=statement1.executeQuery();
				while (rs1.next())
				{
					carton_lot_cnt += rs1.getString("carton_num")+",";
				}	
				rs1.close();
				statement1.close();
			}
						
			if (rs.getFloat("ALLOT_QTY") != rs.getFloat("TOTAL_QTY"))
			{
				strColor ="#ff0000";
			}
			else
			{
				strColor ="#0000ff";
			}
			//sql = " SELECT a.advise_line_id,a.lot_number,c.DATE_CODE,min(a.carton_num) sno,max(a.carton_num) eno ,sum(a.allot_qty)/1000 allot_qty FROM oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_detail c "+
            //      " where a.SEQ_ID=c.SEQ_ID and exists (select 1 from TSC_SHIPPING_ADVISE_LINES b where b.advise_line_id=a.advise_line_id and b.advise_header_id=a.advise_header_id "+
            //      " and b.so_line_id=? and b.tew_advise_no=?) "+
            //      " group by a.advise_line_id,a.lot_number,c.DATE_CODE"+
            //      " order by min(a.carton_num)";
			sql = " SELECT a.advise_line_id,a.lot_number,c.DATE_CODE,a.carton_num ,sum(a.allot_qty)/1000 allot_qty "+
                  " FROM oraddman.tew_lot_allot_detail a,oraddman.tewpo_receive_detail c "+
                  " where a.SEQ_ID=c.SEQ_ID "+
                  " and exists (select 1 from TSC_SHIPPING_ADVISE_LINES b"+
                  "             where b.advise_line_id=a.advise_line_id "+
                  "             and b.advise_header_id=a.advise_header_id "+
                  "             and b.so_line_id=?"+
				  "             and b.tew_advise_no=?) "+
                  " group by a.advise_line_id,a.lot_number,c.DATE_CODE,a.carton_num"+
                  " order by min(a.carton_num),a.lot_number";
			PreparedStatement statement1 = con.prepareStatement(sql);
			statement1.setString(1,rs.getString("so_line_id"));
			statement1.setString(2,ADVISENO);
			ResultSet rs1=statement1.executeQuery();
			strdetail="";tot_allot=0;
			String lotNumber="",sCartonNum="",eCartonNum="",dateCode="";
			float allotQty=0;
			int rowcnt=0;			
			while (rs1.next())
			{	
				if (rowcnt==0)
				{
					lotNumber=rs1.getString("LOT_NUMBER");
					allotQty=rs1.getFloat("ALLOT_QTY");
					sCartonNum=rs1.getString("CARTON_NUM");
					eCartonNum=rs1.getString("CARTON_NUM");
					dateCode=rs1.getString("DATE_CODE");
				}	
				if (!lotNumber.equals(rs1.getString("LOT_NUMBER")) || !dateCode.equals(rs1.getString("DATE_CODE")) || (!sCartonNum.equals(eCartonNum) && !eCartonNum.equals(""+(rs1.getInt("CARTON_NUM")-1))))
				{						
					if (strdetail.equals(""))
					{
						strdetail ="<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
					}	
					strdetail += "<tr><td>"+sCartonNum+(eCartonNum.equals(sCartonNum)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":" - "+ eCartonNum)+"</td><td>"+lotNumber+"</td><td>"+dateCode+"</td><td align=right>"+allotQty+"</td></tr>";
					lotNumber=rs1.getString("LOT_NUMBER");
					allotQty=rs1.getFloat("ALLOT_QTY");
					sCartonNum=rs1.getString("CARTON_NUM");
					eCartonNum=rs1.getString("CARTON_NUM");
					dateCode=rs1.getString("DATE_CODE");	
				}
				else if (rowcnt!=0)
				{
					allotQty+=rs1.getFloat("ALLOT_QTY");
					eCartonNum=rs1.getString("CARTON_NUM");
				}
				tot_allot +=rs1.getDouble("allot_qty");
				rowcnt++;					
			}	
			if (rowcnt>0)
			{
				if (strdetail.equals(""))
				{
					strdetail ="<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
				}	
				strdetail += "<tr><td>"+sCartonNum+(eCartonNum.equals(sCartonNum)?"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":" - "+ eCartonNum)+"</td><td>"+lotNumber+"</td><td>"+dateCode+"</td><td align=right>"+allotQty+"</td></tr>";
			}			
			if (strdetail.length() >0) strdetail += "<tr><td colspan=4>-------------------------------------------------------------------</td></tr><tr><td colspan=4 align=right>Total:&nbsp;&nbsp;&nbsp;&nbsp;"+tot_allot+"</td></table>";
			rs1.close();
			statement1.close();
			
	%>
				<tr id="tr_<%=rs.getString("so_line_id")%>" onMouseOver="this.style.backgroundColor='#D8EBEB'" onMouseOut="style.backgroundColor='#ffffff'">
					<td align="center"><input type="button" name="btn_<%=rs.getString("so_line_id")%>" value="LOT明細" style="font-family:arial;font-size:11px" onClick="setSubmit3('../jsp/TEWPickConfirmDetail.jsp?ID=<%=rs.getString("so_line_id")%>&ADVISENO=<%=rs.getString("advise_no")%>')"><input type="checkbox" name="chk" value="<%=rs.getString("so_line_id")%>" style="visibility:hidden" checked></td>
					<td align="center"><a onMouseOver="this.T_STICKY=true;this.T_WIDTH=280;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_TITLE='C/NO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LOT NUMBER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Code&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;QTY';this.T_OFFSETY=-100;return escape('<%=strdetail%>')"><%=rs.getString("so_no")%></a></td>
					<td align="left"><%=rs.getString("so_line_number")%></td>
					<td align="left"><%=rs.getString("item_no")%></td>
					<td align="left"><%=rs.getString("item_desc")%></td>
					<td align="left"><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
					<td align="left"><%=rs.getString("SHIPPING_METHOD")%></td>
					<td align="center" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><%=rs.getString("carton_list")%></td>
					<td align="right" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><%=(new DecimalFormat("#####.###")).format(rs.getFloat("TOTAL_QTY"))%><input type="hidden" name="TOT_QTY_<%=rs.getString("so_line_id")%>" value="<%=rs.getFloat("TOTAL_QTY")%>"></td>
					<td align="right" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><div id="div_<%=rs.getString("so_line_id")%>"><%=(new DecimalFormat("#####.###")).format(rs.getFloat("ALLOT_QTY"))%></div></td>
					<td align="center"><input type="button" name="DEL_<%=rs.getString("so_line_id")%>" value="刪除" style="font-family:arial;font-size:11px" onClick="setSubmit2(<%=rs.getString("so_line_id")%>)"></td>
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
				<tr><td><input type="hidden" name="TRANSTYPE" value="PICKCONFIRM">
				<!--倉庫代碼：<input type="text" name="SUBINVENTORY" value="" style="font-family: Tahoma,Georgia;" size="5" readonly>-->
	<%
			if (carton_lot_cnt.equals(""))
			{
	%>
				<input type='button' name='save1' value='撿貨確認' style='font-family:arial' onClick='setSubmit1("../jsp/TEWPickProcess.jsp")'>
	<%
			}
			else
			{
				out.println("<font style='color=#ff0000;size:13px;font-weight:bold'>撿貨確認無法進行,錯誤原因：第"+carton_lot_cnt.substring(0,carton_lot_cnt.length()-1)+"箱不符出貨作業規範(同一D/C最多2個Lot)</font>");
			}
	%>
					</td>
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
}
catch(Exception e)
{
	out.println("Exception1:"+e.getMessage());
}
%>
<input type="hidden" name="ERPUSERID" value="<%=ERPUSERID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

