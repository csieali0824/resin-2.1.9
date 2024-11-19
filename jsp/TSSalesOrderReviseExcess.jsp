<!-- 20240226 Marvie : Excess Status-->
<%@ page contentType="text/html; charset=utf-8" import="java.sql.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
 .style3   {font-family:細明體; font-size:12px; background-color:#FFFFFF; text-align:center}
 .style4   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:center}
 .style6   {font-family:細明體; font-size:12px; background-color:#BBDDEE; text-align:right}
</STYLE>
<script language="JavaScript" type="text/JavaScript">

function setSave(URL)
{
	document.SUBFORM.save.disabled=true;	
	document.SUBFORM.winclose.disabled=true;
	document.SUBFORM.ACTION.value = "SAVE";
	//document.SUBFORM.action='../jsp/TSSalesOrderReviseExcessP.jsp';
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();	
}

function setUpdate(line_no)
{
	document.SUBFORM.elements["chk"+line_no].checked = true;
}

function computeTotal(objName, line_no)
{
	if (line_no>0) {
		setUpdate(line_no);
	}
	
	var LINENUM = document.SUBFORM.LINENUM.value;
	var totQty =0,Qty=0;
	var num1, num2, m, c;
	for (var i = 1 ; i <= LINENUM ; i ++)
	{
		Qty = document.SUBFORM.elements[objName+i].value;
    	try 
		{ 
			num1 = Qty.toString().split(".")[1].length 
		} 
		catch (e) { num1 = 0 }
        try 
		{
			num2 = totQty.toString().split(".")[1].length 
		} catch (e) { num2 = 0 }
        c = Math.abs(num1 - num2);
        m = Math.pow(10, Math.max(num1, num2))
        if (c > 0) 
		{
            var cm = Math.pow(10, c);
            if (num1 > num2) 
			{
                Qty = Number(Qty.toString().replace(".", ""));
                totQty = Number(totQty.toString().replace(".", "")) * cm;
            }
            else 
			{
                Qty = Number(Qty.toString().replace(".", "")) * cm;
                totQty = Number(totQty.toString().replace(".", ""));
            }
        }
        else 
		{
            Qty = Number(Qty.toString().replace(".", ""));
            totQty = Number(totQty.toString().replace(".", ""));
        }
        totQty = (Qty + totQty) / m;
	}
	document.SUBFORM.elements["tot"+objName].value = totQty;

	if (totQty > (document.SUBFORM.ORIG_QTY.value - document.SUBFORM.SO_QTY.value))	 {
		document.SUBFORM.save.disabled=true;
		alert("Total Quantity is greater than (Original Qty-CFM Qty).");
	} else {
		document.SUBFORM.save.disabled=false;
	}
}

function setCloseWindow()
{
	setClose();
	//window.opener.document.MYFORM.submit();
}
function setClose()
{
	window.opener.document.getElementById("alpha").style.width="0px";
	window.opener.document.getElementById("alpha").style.height="0px";
	window.close();	
}
</script>
<title>Excess Status</title>
</head>
<%
String id = request.getParameter("ID");
String orig_qty = request.getParameter("ORIG_QTY");
String so_qty = request.getParameter("SO_QTY");
String ssd = request.getParameter("SSD");
String temp_id = id.substring(0, id.indexOf("."));
String seq_id = id.substring(id.indexOf(".")+1);
String totQuantity="";
String sql="";
String LINENUM = request.getParameter("LINENUM");
if (LINENUM ==null) LINENUM="10";
int i=0;
String ACTION = request.getParameter("ACTION");
if (ACTION ==null) ACTION="";
String ExcessType, Quantity, DateCode, ExcessID, UpdateFlag;
%>
<body onload="computeTotal('Quantity', 0)">
<FORM METHOD="get" NAME="SUBFORM"  ENCTYPE="multipart/form-data">
<!--<input type="hidden" name="SGROUP" value="">-->
<%
try
{
	// 為存入日期格式為US考量,將語系先設為美國
	String sqlNLS="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmtNLS=con.prepareStatement(sqlNLS);
	pstmtNLS.executeUpdate();
	pstmtNLS.close();

	if (ACTION.equals("SAVE"))
	{
		int insertCnt=0, updateCnt=0, deleteCnt=0;
		for (i = 1 ; i <= Integer.parseInt(LINENUM) ;i++) {
			UpdateFlag=request.getParameter("chk"+i);
			if (UpdateFlag==null) UpdateFlag="";
			ExcessID=request.getParameter("ExcessID"+i);
			if (ExcessID==null) ExcessID="";
			ExcessType=request.getParameter("Type"+i);
			if (ExcessType==null || ExcessType.equals("--")) ExcessType="";
			Quantity=request.getParameter("Quantity"+i);
			if (Quantity==null) Quantity="";
			DateCode=request.getParameter("DateCode"+i);
			if (DateCode==null) DateCode="";

			//out.println("<div style='font-family:Tahoma,Georgia;font-size:12px'>i="+i+" ExcessType="+ExcessType+
			//            " Quantity="+Quantity+" DateCode="+DateCode+"</div>");

			if (!UpdateFlag.equals("") && ExcessID.equals("") && !ExcessType.equals("") && !Quantity.equals("")) {
				sql="insert into oraddman.tsc_om_so_revise_excess(excess_id, temp_id, seq_id, line_no, excess_type_code, quantity, date_code"+
				           ", last_update_date, last_updated_by_name, creation_date, created_by_name)"+
				     " values(tsc_om_so_revise_excess_s.nextval, ?, ?, ?, ?, ?, ?"+
					       ", sysdate, ?, sysdate, ?)";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setInt(1,Integer.parseInt(temp_id));
				pstmt.setInt(2,Integer.parseInt(seq_id));
				pstmt.setInt(3,i);
				pstmt.setString(4,ExcessType);
				pstmt.setFloat(5,Float.parseFloat((Quantity.equals("")?"0":Quantity)));
				pstmt.setString(6,DateCode);
				pstmt.setString(7,UserName);
				pstmt.setString(8,UserName);
				pstmt.executeQuery();
		
				insertCnt ++;
			}
			else if (!UpdateFlag.equals("") && !ExcessID.equals("") && !ExcessType.equals("") && !Quantity.equals("")) {
				sql="update oraddman.tsc_om_so_revise_excess"+
				      " set excess_type_code = ?"+
					     ", quantity = ?"+
						 ", date_code = ?"+
				         ", last_update_date = sysdate"+
						 ", last_updated_by_name = ?"+
				    " where excess_id = ?";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,ExcessType);
				pstmt.setFloat(2,Float.parseFloat((Quantity.equals("")?"0":Quantity)));
				pstmt.setString(3,DateCode);
				pstmt.setString(4,UserName);
				pstmt.setInt(5,Integer.parseInt(ExcessID));
				pstmt.executeQuery();
		
				updateCnt ++;
			}
			else if (!UpdateFlag.equals("") && !ExcessID.equals("") && ExcessType.equals("") && Quantity.equals("")) {
				sql="delete from oraddman.tsc_om_so_revise_excess"+
				    " where excess_id = ?";
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setInt(1,Integer.parseInt(ExcessID));
				pstmt.executeQuery();
		
				deleteCnt ++;
			}
		}
		if (insertCnt>0 || updateCnt>0 || deleteCnt>0) {
		    con.commit();
			out.println("<div style='font-family:Tahoma,Georgia;font-size:12px'>Insert "+insertCnt+" Record(s).<BR>"+
			            "Update "+updateCnt+" Record(s).<BR>Delete "+deleteCnt+" Record(s).<BR></div>");
		}
	}
}
catch(Exception e)
{
	con.rollback();
	out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>Save Fail!!Cause..<br>Line No:"+i+
	            " Data Error"+e.getMessage()+"</div>");
}
%>
<!--<div>id=<%=id%> temp_id=<%=temp_id%> seq_id=<%=seq_id%> orig_qty=<%=orig_qty%> so_qty=<%=so_qty%> ssd=<%=ssd%> UserName=<%=UserName%></div>-->
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#51874E;color:#FFFFFF;">
		<td rowspan="2" width="70" align="center">Request No</td>
		<td rowspan="2" width="50" align="center">Plant Code </td>
		<td colspan="8" width="600" align="center">Order Original Detail </td>
		<td width="200" style="background-color:#66CCCC;color:#000000" colspan="4" align="center">Factory Confirm Detail </td>
	</tr>
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="60" style="background-color:#51874E;color:#FFFFFF;" align="center">Sales Area </td>
		<td width="80" style="background-color:#51874E;color:#FFFFFF;" align="center">Customer</td>
		<td width="80" style="background-color:#51874E;color:#FFFFFF;" align="center">MO#</td>
		<td width="30" style="background-color:#51874E;color:#FFFFFF;" align="center">Line#</td>	
		<td width="150" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Item Desc </td>	
		<td width="90" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Package </td>	
		<td width="50" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Qty </td>	
		<td width="60" style="background-color:#51874E;color:#FFFFFF;" align="center">Original SSD </td>	
		<td width="60" align="center" style="background-color:#66CCCC;color:#000000">Factory CFM Qty</td>
		<td width="60" align="center" style="background-color:#66CCCC;color:#000000">Factory CFM SSD </td>
	</tr>
<%
try
{
	sql = " select a.temp_id"+
	      ",a.seq_id"+
		  ",a.sales_group"+
		  ",a.so_no"+
		  ",nvl(a.line_no,'') line_no"+
		  ",a.so_header_id"+
		  ",a.so_line_id"+
		  ",nvl(a.order_type,'') order_type "+
		  ",a.customer_number"+
		  ",a.customer_name"+
		  ",a.ship_to_org_id"+
		  ",a.ship_to"+
		  ",a.inventory_item_id"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",a.cust_item_id"+
		  ",a.cust_item_name"+
		  ",a.customer_po"+
		  ",a.shipping_method"+
		  ",NVL(a.so_qty,a.SOURCE_SO_QTY) so_qty"+
		  ",to_char(a.request_date,'yyyymmdd') request_date "+
		  ",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
		  ",a.packing_instructions"+
		  ",a.plant_code"+
		  ",a.change_reason"+
		  ",a.change_comments"+
		  ",a.created_by"+
		  ",a.creation_date"+
		  ",(SELECT ALENGNAME FROM oraddman.tsprod_manufactory b WHERE a.plant_code =b.manufactory_no) ALENGNAME "+ 
		  ",a.REQUEST_NO"+
		  ",a.remarks"+
		  ",a.SOURCE_SO_QTY orig_so_qty"+
          ",(select f.description  from inv.mtl_system_items_b f where  a.SOURCE_ITEM_ID=f.inventory_item_id  and a.SOURCE_SHIP_FROM_ORG_ID=f.organization_id) orig_item_desc"+
		  ",to_char(CASE WHEN a.packing_instructions IN ('Y','T') AND (SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') OR (SUBSTR(a.so_no,1,4) IN ('1214') and nvl(a.TO_TW_DAYS,0)<>0)) THEN TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD')"+ // delta 1214 totw
		  "  ELSE a.source_ssd-nvl(a.TO_TW_DAYS,0) END ,'yyyymmdd') AS  orig_schedule_ship_date"+ //回T依工廠SSD為準
		  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+ 
		  " else (SELECT nvl(e.CUSTOMER_SNAME,e.customer_name) from tsc_customer_all_v e where a.SOURCE_CUSTOMER_ID=e.customer_id) ||case when a.source_customer_id=14980 then (select  nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') from hz_cust_accounts end_cust where d.end_customer_id = end_cust.cust_account_id) else '' end end as orig_customer"+
		  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
          ",sum(case when a.so_qty is null then 0 else 1 end ) over (partition by a.plant_code) so_qty_cnt"+
          ",sum(case when a.schedule_ship_date is null then 0 else 1 end ) over (partition by a.plant_code) schedule_ship_date_cnt"+  
          ",sum(case when a.order_type is null then 0 else 1 end ) over (partition by a.plant_code) order_type_cnt"+
          ",sum(case when a.customer_number is null then 0 else 1 end ) over (partition by a.plant_code) customer_number_cnt"+
          ",sum(case when a.ship_to_org_id is null then 0 else 1 end ) over (partition by a.plant_code) ship_to_org_id_cnt"+
          ",sum(case when a.item_name is null then 0 else 1 end ) over (partition by a.plant_code) item_name_cnt"+
          ",sum(case when a.cust_item_id is null then 0 else 1 end ) over (partition by a.plant_code) cust_item_id_cnt"+
          ",sum(case when a.customer_po is null then 0 else 1 end ) over (partition by a.plant_code) customer_po_cnt"+
          ",sum(case when a.shipping_method is null then 0 else 1 end ) over (partition by a.plant_code) shipping_method_cnt"+
          ",case when sum(case when a.so_qty is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.schedule_ship_date is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.order_type is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.customer_number is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.ship_to_org_id is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.item_name is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.cust_item_id is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.customer_po is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.shipping_method is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end as show_column_cnt"+
		  ",tsc_inv_category(d.inventory_item_id,43,23) tsc_package"+
          ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id) - a.source_so_qty  change_qty"+
          ",to_number(to_char(a.source_ssd,'yyyymmdd'))-to_number(to_char(case when a.schedule_ship_date is null then a.source_ssd else case when nvl(a.TO_TW_DAYS,0)<>0 then a.SCHEDULE_SHIP_DATE_TW else a.schedule_ship_date end end,'yyyymmdd')) change_ssd"+
          ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id)  change_new_qty"+
		  ",nvl(a.TO_TW_DAYS,0) TO_TW_DAYS"+
		  ",a.TSC_PROD_GROUP"+
          ",case when send_from_temp_id is null or a.plant_code='002' then 0 else (row_number() over(partition by send_from_temp_id,send_from_seq_id order by temp_id)) +"+
          " (select count(1) from oraddman.tsc_om_salesorderrevise_req_bk x where x.send_from_temp_id=a.send_from_temp_id and x.send_from_seq_id=a.send_from_seq_id) end resend_times"+
		  ",case when a.send_from_temp_id is null or a.plant_code='002' then null else (select listagg(to_char(x.creation_date,'yyyymmdd'),'/') within group (order by x.creation_date desc ) dd from tsc_om_salesorderrevise_req_v x where x.temp_id<a.temp_id and a.send_from_temp_id ||'-'||a.send_from_seq_id in (x.send_from_temp_id ||'-'||x.send_from_seq_id,x.temp_id ||'-'||x.seq_id) ) end as send_date"+
		  ",case when a.send_from_temp_id is null or a.plant_code='002' then null else (select listagg(x.pc_remarks,'/') within group (order by x.creation_date desc ) dd from tsc_om_salesorderrevise_req_v x where x.temp_id<a.temp_id and x.pc_confirmed_result='R' AND a.send_from_temp_id ||'-'||a.send_from_seq_id in (x.send_from_temp_id ||'-'||x.send_from_seq_id,x.temp_id ||'-'||x.seq_id) ) end rej_reason"+ 
		  ",to_char(a.source_request_date,'yyyymmdd') source_crd "+
		  ",supplier_number"+ 
		  ",a.cancel_move_flag"+
		  ",a.status"+
		  " from oraddman.tsc_om_salesorderrevise_req a"+
		  ",ont.oe_order_lines_all d"+		
		  " where a.so_header_id=d.header_id"+
		  " and a.so_line_id=d.line_id"+
		  " and a.temp_id="+temp_id+
		  " and a.seq_id="+seq_id+	  
	      " order by a.SALES_GROUP,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
//out.println("<div>"+sql+"</div>");
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
  %>
	<tr style="font-size:10px">
		<td align="center"><%=rs.getString("request_no")%></td>
		<td align="center"><%=rs.getString("ALENGNAME")%></td>
		<td align="center"><%=rs.getString("sales_group")%></td>
		<td align="left"><%=rs.getString("orig_customer")%></td>
		<td align="center"><%=rs.getString("so_no")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
		<td><%=rs.getString("line_no")%></td>
		<td onMouseOver='this.T_ABOVE=false;this.T_WIDTH=100;this.T_OPACITY=80;return escape("<%=rs.getString("created_by")%>")'><%=rs.getString("orig_item_desc")%></td>
		<td><%=rs.getString("tsc_package")%></td>
		<td align="center"><%=rs.getString("orig_so_qty")%></td>
		<td align="center"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%></td>
		<td align="center"><%=so_qty%></td>
		<td align="center"><%=ssd%></td>
	</tr>
  <%
	}
	rs.close();
	statement.close();
}
catch(Exception e)
{
	out.println("<div align='center' style='font-size:12px;color:#ff0000'>Exception:"+e.getMessage()+"</div>");
}
%>
</table>
<BR>
			<table width="50%" bordercolorlight="#FFFFFF" border="1" cellspacing="0"  bordercolordark="#9999CC" cellpadding="1">
				<tr>
					<td width="100%" bgcolor="#BBDDEE" colspan="13"><FONT color="#000000" size="2" face="Arial">Excess Status：</FONT></td>
				</tr>	
				<TR>
					<TD width="10%" class="style4"><font style="font-family:Arial">Update</font></td>
					<TD width="10%" class="style4"><font style="font-family:Arial">Line No</font></td>
					<TD width="20%" class="style4"><font style="font-family:Arial">*Type</font></td>
					<TD width="10%" class="style4"><font style="font-family:Arial">*Quantity</font></td>
					<TD width="10%" class="style4"><font style="font-family:Arial">Date Code</font></td>
				</TR>
				<%
			try {
				String max_line_no="";
				String sql1 = "select max(line_no) line_no from oraddman.tsc_om_so_revise_excess"+
				      " where temp_id = "+temp_id+" and seq_id = "+seq_id;
				//out.println(sql1);
				Statement st1=con.createStatement();
				ResultSet rs1=st1.executeQuery(sql1);
				if (rs1.next())	{
					max_line_no = rs1.getString("line_no");
				}
				rs1.close();
				st1.close();
				if (max_line_no==null) {
					max_line_no="0";
				}
				if (Integer.parseInt(max_line_no)>Integer.parseInt(LINENUM)) LINENUM = max_line_no;
				//out.println("LINENUM="+LINENUM);

				sql1 = "select line_no, excess_type_code, quantity, date_code, excess_id from oraddman.tsc_om_so_revise_excess"+
				      " where temp_id = "+temp_id+" and seq_id = "+seq_id+
					  " order by 1";
				st1=con.createStatement();
				rs1=st1.executeQuery(sql1);
				boolean bFind = rs1.next();
				int iLineNo = -1;
				if (bFind) iLineNo = rs1.getInt(1);

				for (i = 1; i <=Integer.parseInt(LINENUM); i++) {
					Quantity = "";
					DateCode = "";
					ExcessID = "";
					if (bFind && iLineNo==i) {
						Quantity = rs1.getString("quantity");
						DateCode = rs1.getString("date_code");
						if (DateCode==null) DateCode="";
						ExcessID = rs1.getString("excess_id");
					}
				%>
					<TR>
						<TD class="style3"><input type="checkbox" name="chk<%=i%>" value="<%=i%>"></TD>
						<TD class="style3"><%=i%><input type="hidden" name="ExcessID<%=i%>" value="<%=ExcessID%>"></TD>
						<TD class="style3">
						<%
						try
						{   
							String sql2 = "SELECT lookup_code, meaning FROM fnd_lookup_values_vl"+
							      " where lookup_type = 'TSC_EXCESS_TYPE' order by lookup_code";
							Statement st2=con.createStatement();
							ResultSet rs2=st2.executeQuery(sql2);
							comboBoxBean.setRs(rs2);
							if (bFind && iLineNo==i) comboBoxBean.setSelection(rs1.getString("excess_type_code"));
							comboBoxBean.setFontSize(11);
							comboBoxBean.setFontName("Tahoma,Georgia");
							comboBoxBean.setFieldName("Type"+i);	   
							out.println(comboBoxBean.getRsString());				   
							rs2.close();
							st2.close();     	 
						} 
						catch (Exception e) 
						{ 
							out.println("Exception:"+e.getMessage()); 
						}
						%></TD>
						<TD class="style3"><input type="text" name="<%="Quantity"+i%>" size="5" value="<%=Quantity%>" style="font-family:Arial;text-align:right" onChange="computeTotal('Quantity',<%=i%>)"></TD>
						<TD class="style3"><input type="text" name="<%="DateCode"+i%>" size="5" value="<%=DateCode%>" style="font-family:Arial" onChange="setUpdate(<%=i%>)"></TD>
					</TR>
				<%
					if (bFind && iLineNo==i) {
						bFind = rs1.next();
						iLineNo = -1;
						if (bFind) iLineNo = rs1.getInt(1);
					}
				}
				rs1.close();
				st1.close();
			}
			catch(Exception e) {
				out.println("<div style='color:#ff0000;font-family:Tahoma,Georgia;font-size:12px'>"+e.getMessage()+"</div>");
			}
				%>
					<tr>
						<TD class="style6" colspan="3"><font style="font-family:arial;text-align:Right">Total：</font></td>
						<TD class="style4" style="border-left-color:#BBDDEE"><input type="text" name="totQuantity" value="<%=totQuantity%>" size="15" style="font-family:arial; text-align:right; background-color:#BBDDEE; border-bottom-style: none; border-left-style: none; border-right-style: none; border-top-style: none;"></TD>
						<TD class="style4"colspan="1" style="border-left-color:#BBDDEE">&nbsp;</td>
					</tr>
			</table>
<BR>
<TABLE width="50%" border="1" cellspacing="0" cellpadding="0">
	<TR>
		<TD colspan="2" align="center"><input type="button" name="save" value="Save"  style="font-family:Tahoma,Georgia" onClick="setSave('../jsp/TSSalesOrderReviseExcess.jsp?ID=<%=id%>&ORIG_QTY=<%=orig_qty%>&SO_QTY=<%=so_qty%>&SSD=<%=ssd%>&ACTION=SAVE');">		  &nbsp;&nbsp;&nbsp;&nbsp;
		<INPUT TYPE="button" NAME="winclose" value="Close Window" style="font-family:Tahoma,Georgia" onClick='setCloseWindow();'>		</TD>
	</TR>
</TABLE>
<BR>
<!--%表單參數%-->
<input type="hidden" name="LINENUM" value="<%=LINENUM%>">
<input type="hidden" name="ID" value="<%=id%>">
<input type="hidden" name="ORIG_QTY" value="<%=orig_qty%>">
<input type="hidden" name="SO_QTY" value="<%=so_qty%>">
<input type="hidden" name="SSD" value="<%=ssd%>">
<input type="hidden" name="ACTION" value="">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
