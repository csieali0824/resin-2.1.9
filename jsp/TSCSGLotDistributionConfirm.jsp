<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	//if (document.MYFORM.ADVISENO.value =="" || document.MYFORM.ADVISENO.value =="--")
	//{
	//	alert("請選擇Advise No!!");
	//	return false;
	//}
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
function  setSubmit2(so_line_id,carton_list,vendor_site_id)
{
	if (confirm("您確定要刪除所有第"+carton_list+"箱訂單資料?"))
	{
		document.MYFORM.action="../jsp/TSCSGLotDistributionConfirm.jsp?ATYPE=DEL&ADVISENO="+document.MYFORM.ADVISENO1.value+"&ID="+so_line_id+"&VID="+vendor_site_id;
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
<title>SG Distribution LOT Confirm</title>
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
if (ADVISENO==null || ADVISENO.equals("--")) ADVISENO="";
String TRANSTYPE = request.getParameter("TRANSTYPE");
if (TRANSTYPE==null) TRANSTYPE="";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String ID = request.getParameter("ID");
if (ID==null) ID="";
String VID = request.getParameter("VID");
if (VID==null) VID="";
String PC_SSD=request.getParameter("PC_SSD");
if (PC_SSD==null || PC_SSD.equals("--")) PC_SSD="";
String ERPUSERID="";
String strdetail="";
double tot_allot=0;
int i_err=0;
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
			PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_headers a where exists (select 1 from tsc.tsc_pick_confirm_lines b where  b.TEW_ADVISE_NO=? and b.advise_header_id=a.advise_header_id)");  
			pstmtDt.setString(1,ADVISENO);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		
			pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where  a.TEW_ADVISE_NO=? ");  
			pstmtDt.setString(1,ADVISENO);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		}
		else
		{
			sql = " SELECT  count(1) from tsc.tsc_pick_confirm_lines a where a.so_line_id<>"+ID+" and exists (select 1 from tsc.tsc_pick_confirm_lines b where b.TEW_ADVISE_NO='"+ADVISENO+"' and b.so_line_id="+ID+" and b.advise_header_id=a.advise_header_id)";
			Statement statement1=con.createStatement();
			ResultSet rs1=statement1.executeQuery(sql);
			if (rs1.next())
			{
				if (rs1.getInt(1)==0)
				{
		
					PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_headers a where exists (select 1 from tsc.tsc_pick_confirm_lines b where b.TEW_ADVISE_NO=? and b.so_line_id=? and b.advise_header_id=a.advise_header_id)");  
					pstmtDt.setString(1,ADVISENO);
					pstmtDt.setString(2,ID);
					pstmtDt.executeUpdate();
					pstmtDt.close();
				}
			}
			rs1.close();
			statement1.close();

			//刪除同箱不同訂單資料,add by Peggy 20200504
			PreparedStatement pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where  a.TEW_ADVISE_NO=? and a.so_line_id<>? and exists (select 1 from tsc.tsc_pick_confirm_lines b where  b.TEW_ADVISE_NO=? and b.so_line_id=? and b.carton_no=a.carton_no) ");  
			pstmtDt.setString(1,ADVISENO);
			pstmtDt.setString(2,ID);
			pstmtDt.setString(3,ADVISENO);
			pstmtDt.setString(4,ID);
			pstmtDt.executeUpdate();
			pstmtDt.close();
		
			pstmtDt=con.prepareStatement("delete tsc.tsc_pick_confirm_lines a where  a.TEW_ADVISE_NO=? and a.so_line_id=?");  
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
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGLotDistributionConfirm.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Distribution Lot Confirm</font></strong>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="10%"><font color="#666600">Advise No:</font></td>
		<td width="10%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("select tew_advise_no advise_no,tew_advise_no advise_no1 from  tsc.tsc_pick_confirm_lines a,tsc.tsc_pick_confirm_headers b where a.advise_header_id=b.advise_header_id and b.PICK_STATUS='N' and a.ORGANIZATION_ID IN (907,908) group by tew_advise_no order by tew_advise_no ");
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
		</td>
		<td width="10%"><font color="#666600">PC Confirm出貨日:</font></td>		
		<td width="70%">
		<%
		try
		{   
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery("select to_char(c.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') pc_ssd,to_char(c.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') pc_ssd1 from  tsc.tsc_pick_confirm_lines a,tsc.tsc_pick_confirm_headers b,tsc.tsc_shipping_advise_lines c where a.advise_header_id=b.advise_header_id and b.PICK_STATUS='N' and a.ORGANIZATION_ID IN (907,908) and a.advise_line_id=c.advise_line_id group by to_char(c.PC_SCHEDULE_SHIP_DATE,'yyyymmdd') order by 1 ");
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(PC_SSD);
			comboBoxBean.setFieldName("PC_SSD");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} //end of try		 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>		
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGLotDistributionConfirm.jsp")' > 
		&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<INPUT TYPE="button" align="middle"  value='出貨批號明細表' onClick='setSubmit("../jsp/TSCSGLotDistributionExcel.jsp")' > 
		</td>
	</tr>
</table> 
<hr>
<%
try
{
	//if (ADVISENO.equals("--") || ADVISENO.equals(""))
	//{
	//	out.println("<div align='center'><font color='blue' size='2' face='新細明體'><strong>請選擇Advise No!</strong></font></div>");
	//}
	//else
	//{
		sql = " SELECT x.to_tw,x.VENDOR_SITE_CODE,x.vendor_site_id,x.shipping_method,x.SHIPPING_REMARK,x.advise_no,x.advise_header_id,x.so_no,x.so_header_id"+
              ",x.so_line_id,x.so_line_number,x.item_no,x.item_desc,x.inventory_item_id,x.pc_schedule_ship_date,x.POST_FIX_CODE,sum(x.SHIP_QTY) SHIP_QTY"+
              ",min(x.carton_num_fr) carton_num_fr,max(x.carton_num_to) carton_num_to,sum(x.TOTAL_QTY) TOTAL_QTY,sum(x.ALLOT_QTY) ALLOT_QTY "+            
			  //",tssg_ship_pkg.GET_ORDER_CARTON_LIST('ORDER_LINE',x.tew_advise_no,x.so_line_id,'0','0') carton_list"+
			  ",tssg_ship_pkg.GET_ORDER_CARTON_LIST('ORDER_LINE',x.tew_advise_no,x.so_line_id,'0','0',x.vendor_site_id) carton_list"+  //add vendor_site_id by Peggy 20210826
			  ",x.exp_msg"+
			  " FROM (select a.tew_advise_no,c.VENDOR_SITE_CODE ,a.vendor_site_id ,b.shipping_method ,a.SHIPPING_REMARK ,a.tew_advise_no advise_no,b.advise_header_id"+
              "       ,a.advise_line_id,a.so_no,a.so_header_id,a.so_line_id,a.so_line_number,a.item_no,a.item_desc,a.inventory_item_id,to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
              "       ,nvl(a.post_code,b.POST_FIX_CODE) POST_FIX_CODE,(a.ship_qty/1000) SHIP_QTY,a.carton_num_fr,a.carton_num_to,(a.CARTON_PER_QTY/1000) CARTON_PER_QTY,(a.TOTAL_QTY/1000) TOTAL_QTY"+
              "       ,(sum(x.qty)/1000) ALLOT_QTY"+
			  "       ,nvl(b.TO_TW,'N') TO_TW"+  
              "       ,(select sum(nvl(NET_WEIGHT,0)) from tsc.tsc_shipping_advise_lines tsal where tsal.advise_header_id=a.advise_header_id and tsal.carton_num_fr=a.carton_num_fr and tsal.carton_num_to=a.carton_num_to) tot_nw"+
              "       ,(select sum(nvl(GROSS_WEIGHT,0)) from tsc.tsc_shipping_advise_lines tsal where tsal.advise_header_id=a.advise_header_id and tsal.carton_num_fr=a.carton_num_fr and tsal.carton_num_to=a.carton_num_to) tot_gw"+
		      "       ,case when (select sum(nvl(NET_WEIGHT,0)) from tsc.tsc_shipping_advise_lines tsal where tsal.advise_header_id=a.advise_header_id and tsal.carton_num_fr=a.carton_num_fr and tsal.carton_num_to=a.carton_num_to) >= (select sum(nvl(GROSS_WEIGHT,0)) from tsc.tsc_shipping_advise_lines tsal where tsal.advise_header_id=a.advise_header_id and tsal.carton_num_fr=a.carton_num_fr and tsal.carton_num_to=a.carton_num_to) then 'Carton:'||A.CARTON_NUM_FR|| CASE WHEN A.CARTON_NUM_TO<>A.CARTON_NUM_FR THEN '-'||A.CARTON_NUM_TO else '' end||' 淨重大於或等於毛重' else '' end as exp_msg"+ //add by Peggy 20210513
              "       FROM tsc.tsc_shipping_advise_lines a"+
              "       ,tsc.tsc_shipping_advise_headers b"+
              "       ,ap.ap_supplier_sites_all c"+
			  "       ,tsc.tsc_pick_confirm_lines x"+
			  "       ,tsc.tsc_pick_confirm_headers y "+
              "       where  a.tew_advise_no=nvl(?,a.tew_advise_no) "+
              "       and b.SHIPPING_FROM like ?||'%'"+
              "       and b.advise_header_id = a.advise_header_id "+
              "       and a.vendor_site_id = c.vendor_site_id(+)"+
			  "       and x.advise_header_id=y.advise_header_id"+
			  "       and x.advise_header_id = b.advise_header_id "+
			  "       and x.advise_line_id = a.advise_line_id"+
			  "       and y.PICK_STATUS=?"+
			  "       and to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyymmdd')=nvl(?,to_char(a.PC_SCHEDULE_SHIP_DATE,'yyyymmdd'))"+
			  "       group by a.advise_header_id,a.tew_advise_no,c.VENDOR_SITE_CODE ,a.vendor_site_id ,b.shipping_method ,a.SHIPPING_REMARK ,a.tew_advise_no ,b.advise_header_id"+
              "      ,a.advise_line_id,a.so_no,a.so_header_id,a.so_line_id,a.so_line_number,a.item_no,a.item_desc,a.inventory_item_id,to_char(a.pc_schedule_ship_date,'yyyy-mm-dd')"+
              "      ,nvl(a.post_code,b.POST_FIX_CODE),(a.ship_qty/1000),a.carton_num_fr,a.carton_num_to,(a.CARTON_PER_QTY/1000),(a.TOTAL_QTY/1000),nvl(b.TO_TW,'N')"+
			  "       ) x"+
              " group by x.to_tw,x.VENDOR_SITE_CODE,x.vendor_site_id,x.shipping_method,x.SHIPPING_REMARK,x.advise_no,x.advise_header_id,x.so_no,x.so_header_id"+
              " ,x.so_line_id,x.so_line_number,x.item_no,x.item_desc,x.inventory_item_id,x.pc_schedule_ship_date,x.POST_FIX_CODE,x.exp_msg"+
			  " ORDER BY CARTON_NUM_FR";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISENO);
		statement.setString(2,"SG");
		statement.setString(3,"N");
		statement.setString(4,PC_SSD);
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
						<td width="5%">&nbsp;</td>
						<td width="8%">MO#</td>
						<td width="4%">訂單項次</td>
						<td width="14%">料號</td>
						<td width="12%">型號</td>
						<td width="12%">嘜頭</td>
						<td width="8%">出貨方式</td>
						<td width="8%">C/NO</td>
						<td width="4%">出貨量(K)</td>
						<td width="4%">撿貨量(K)</td>
						<td width="7%">供應商</td>
						<td width="8%">重量備註</td>
						<td width="6%"><input type="button" name="delAll" value="全部刪除" style="font-family:arial;font-size:11px" onClick="setSubmit2(-999)"></td>
					</tr>
	<%		
			}
						
			if (rs.getFloat("ALLOT_QTY") != rs.getFloat("TOTAL_QTY"))
			{
				strColor ="#ff0000";
			}
			else
			{
				strColor ="#0000ff";
			}
			sql = " select a.advise_line_id,a.lot lot_number,a.date_code,a.carton_no carton_num ,sum(a.qty)/1000 allot_qty "+
                  " from tsc.tsc_pick_confirm_lines a"+
                  " where a.so_line_id=?"+
                  " and a.tew_advise_no=?"+
                  " group by a.advise_line_id,a.lot,a.date_code,a.carton_no"+
                  " order by min(a.carton_no),a.lot";
			//out.println(sql);
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
					if (dateCode==null) dateCode="";
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
					if (dateCode==null) dateCode="";
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
				<tr id="tr_<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>" onMouseOver="this.style.backgroundColor='#D8EBEB'" onMouseOut="style.backgroundColor='#ffffff'">
					<td align="center"><input type="button" name="btn_<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>" value="LOT明細" style="font-family:arial;font-size:11px" onClick="setSubmit3('../jsp/TSCSGLotDistributionConfirmDetail.jsp?ID=<%=rs.getString("so_line_id")%>&ADVISENO=<%=rs.getString("advise_no")%>&VID=<%=rs.getString("vendor_site_id")%>')"><input type="checkbox" name="chk" value="<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>" style="visibility:hidden" checked></td>
					<td align="center"><a onMouseOver="this.T_STICKY=true;this.T_WIDTH=280;this.T_CLICKCLOSE=false;this.T_BGCOLOR='#D8EBEB';this.T_SHADOWCOLOR='#FFFF99';this.T_TITLE='C/NO&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;LOT NUMBER&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Date Code&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;QTY';this.T_OFFSETY=-100;return escape('<%=strdetail%>')"><%=rs.getString("so_no")%></a></td>
					<td align="left"><%=rs.getString("so_line_number")%></td>
					<td align="left"><%=rs.getString("item_no")%></td>
					<td align="left"><%=rs.getString("item_desc")%></td>
					<td align="left"><%=(rs.getString("SHIPPING_REMARK")==null?"&nbsp;":rs.getString("SHIPPING_REMARK"))%></td>
					<td align="left"><%=rs.getString("SHIPPING_METHOD")%></td>
					<td align="center" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><%=rs.getString("carton_list")%></td>
					<td align="right" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><%=(new DecimalFormat("#####.###")).format(rs.getFloat("TOTAL_QTY"))%><input type="hidden" name="TOT_QTY_<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>" value="<%=rs.getFloat("TOTAL_QTY")%>"></td>
					<td align="right" style="color:<%=strColor%>;font-weight:bold;font-size:12px"><div id="div_<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>"><%=(new DecimalFormat("#####.###")).format(rs.getFloat("ALLOT_QTY"))%></div></td>
					<td align="center"><%=rs.getString("vendor_site_code")%></td>
					<td align="center" style="color:#FF0000"><%=(rs.getString("exp_msg")==null?"&nbsp;":rs.getString("exp_msg"))%></td>
					<td align="center"><input type="button" name="DEL_<%=rs.getString("so_line_id")+"."+rs.getString("vendor_site_id")%>" value="刪除" style="font-family:arial;font-size:11px" onClick="setSubmit2(<%=rs.getString("so_line_id")%>,'<%=rs.getString("carton_list")%>','<%=rs.getString("vendor_site_id")%>')"></td>
				</tr>
	<%				
	
			if (rs.getString("exp_msg")!=null) i_err++;
			icnt++;
		}
		if (icnt >0)
		{
	%>
			</table>
			<hr>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border="0" bgcolor="#DCE6E7">
				<tr><td><input type="hidden" name="TRANSTYPE" value="PICKCONFIRM">
					<input type='button' name='save1' value='撿貨確認' style='font-family:arial' onClick='setSubmit1("../jsp/TSCSGLotDistributionProcess.jsp")' <%=i_err>0?"disabled":""%>>
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
	//}
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

