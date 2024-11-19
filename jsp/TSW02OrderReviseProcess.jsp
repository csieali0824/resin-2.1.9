<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="MOShipBean" scope="session" class="Array2DimensionInputBean"/>
<html>
<head>
<title>Sales Order Revise Process</title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSW02OrderReviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql11="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt11=con.prepareStatement(sql11);
pstmt11.executeUpdate(); 
pstmt11.close();

String sql ="",vRequestNo="",v_result="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String REQNO = request.getParameter("REQNO");
if (REQNO==null) REQNO="";
int rowcnt=0,err_cnt=0;
String group_id ="";

if (ACODE.equals("SAVE"))
{
	try
	{
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select apps.ts_w02_order_revise_group_id_s.nextval from dual");
		if (!rs.next())
		{
			throw new Exception("GROUP ID not Found!!");
		}
		else
		{
			group_id = rs.getString(1);
		}
		rs.close();
		statement.close();	
			
		sql = " update oraddman.tsc_om_salesorderrevise_w02 a"+
			  " set LAST_UPDATED_BY=?"+
			  ",LAST_UPDATE_DATE=SYSDATE"+
			  ",TEMP_GROUP_ID=?"+
			  " WHERE REQUEST_NO=?"+
			  " AND STATUS=?";
		PreparedStatement pstmtDt=con.prepareStatement(sql);  
		pstmtDt.setString(1,UserName);
		pstmtDt.setString(2,group_id);
		pstmtDt.setString(3,REQNO);
		pstmtDt.setString(4,"CONFIRMED");
		pstmtDt.executeQuery();
		pstmtDt.close();
		con.commit();

		try
		{
			//改單
			CallableStatement cs3 = con.prepareCall("{call tsc_order_revise_w02_pkg.main(?,?)}");			 
			cs3.setString(1,group_id); 
			cs3.setString(2,UserName); 
			cs3.execute();		
			cs3.close();
	
			sql = " select a.request_no"+
				  ", a.seq_id"+
				  ", a.so_no"+
				  ", a.line_no"+
				  ", a.source_item_desc"+
				  ", a.source_so_qty"+
				  ", to_char(a.source_ssd,'yyyymmdd') source_ssd"+
				  ", to_char(a.source_request_date,'yyyymmdd') source_request_date"+
				  ", a.item_name"+
				  ", a.item_desc"+
				  ", nvl(a.shipping_method,a.SOURCE_SHIPPING_METHOD) shipping_method"+
				  ", a.SOURCE_SHIPPING_METHOD"+
				  ", a.so_qty"+
				  ", to_char(a.request_date,'yyyymmdd') request_date"+
				  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
				  ", a.remarks"+
				  ", a.status"+
				  ", a.new_so_no"+
				  ", a.new_line_no"+
				  ", ar.account_number"+
				  ", nvl(ar.customer_sname,ar.customer_name) customer"+
				  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
				  ",row_number() over (partition by a.SALES_GROUP,request_no,a.SO_NO||'-'||a.LINE_NO order by a.seq_id, nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
				  ",count(1) over (partition by a.request_no,a.so_line_id) line_cnt"+
				  ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end as result"+
				  ",decode(a.NEW_SO_NO ,null,'',' New MO#：'||a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '<br>New Line#'||a.NEW_LINE_NO) || decode(a.ERROR_MESSAGE,NULL,'','<br>'||a.ERROR_MESSAGE)||decode(a.SYSTEM_REMARKS,NULL,'','<br>'||a.SYSTEM_REMARKS)  as result_remark"+
				  ",a.source_customer_po"+
				  ",a.customer_dock_code"+ //add by Peggy 20220805
				  " from oraddman.tsc_om_salesorderrevise_w02 a"+
				  ",ont.oe_order_headers_all c"+
				  ",ont.oe_order_lines_all d"+
				  ",tsc_customer_all_v ar"+
				  " where a.so_header_id=c.header_id(+)"+  
				  " and a.so_line_id=d.line_id(+)"+
				  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
				  " and a.temp_group_id='"+group_id+"'"+ 
				  " order by a.SALES_GROUP,request_no,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
			//out.println(sql);
			statement=con.createStatement();
			rs=statement.executeQuery(sql);
			while (rs.next())
			{
				if (rowcnt==0)
				{
				%>
					<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
						<tr style="background-color:#E1E3F0;color:#000000">
							<td rowspan="2" width="3%" align="center">Cust#</td>
							<td rowspan="2" width="8%" align="center">Customer</td>
							<td rowspan="2" width="6%" align="center">MO#</td>
							<td rowspan="2" width="3%" align="center">Line#</td>	
							<td rowspan="2" width="10%" align="center">Orig Item Desc </td>	
							<td rowspan="2" width="4%" align="center">Orig Qty </td>	
							<td rowspan="2" width="4%" align="center">Orig CRD </td>
							<td rowspan="2" width="4%" align="center">Orig SSD </td>	
							<td rowspan="2" width="8%" align="center">Cust PO</td>	
							<td width="35%" style="background-color:#006699;color:#ffffff" colspan="4" align="center">Order Revise Detail </td>
							<td rowspan="2" width="10%" align="center">Execution Result </td>
							<td rowspan="2" width="12%" align="center">System Remarks</td>

						</tr>
						<tr style="background-color:#BDD2DD;">
							<td width="5%" align="center">Request No</td>
							<td width="4%" align="center">Sales CFM Qty</td>
							<td width="4%" align="center">Slaes CFM CRD</td>
							<td width="4%" align="center">Slaes CFM SSD</td>
							<td width="5%" align="center">Customer Dock</td>
						</tr>
				<%
				}
				%>
				<tr <%=(!(rs.getString("result")).toUpperCase().equals("OK")?"style='background-color:#E7FA5F'":"")%>>
					<%
					if (rs.getInt("line_seq")==1)
					{
								
					%>		
					<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("account_number")%></td>		
					<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("customer")%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("SO_NO")%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("LINE_NO")%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_ITEM_DESC")%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="right"><%=rs.getString("SOURCE_SO_QTY")%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=(rs.getString("source_request_date")==null?"&nbsp;":rs.getString("source_request_date"))%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=(rs.getString("SOURCE_SSD")==null?"&nbsp;":rs.getString("SOURCE_SSD"))%></td>
					<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("source_customer_po")%></td>
					<%
					}
					%>
					<td align="center"><%=(rs.getString("REQUEST_NO")==null?"&nbsp;":rs.getString("REQUEST_NO"))%></td>
					<td align="right"><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
					<td align="center"><%=(rs.getString("request_date")==null?"&nbsp;":rs.getString("request_date"))%></td>
					<td align="center"><%=(rs.getString("schedule_ship_date")==null?"&nbsp;":rs.getString("schedule_ship_date"))%></td>
					<td align="center"><%=(rs.getString("customer_dock_code")==null?"&nbsp;":rs.getString("customer_dock_code"))%></td>
					<td align="center"><%=(rs.getString("RESULT")==null?"&nbsp;":((rs.getString("RESULT")).toUpperCase().equals("OK")?"<font style='color:#0000ff;font-weight:bold'>"+rs.getString("RESULT")+"</font>":"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("result")+"</font>"))%></td>
					<td><%=(rs.getString("RESULT_REMARK")==null?"&nbsp;":rs.getString("RESULT_REMARK"))%></td>
				</tr>
			<%	
				rowcnt++;
			}
			rs.close();
			statement.close();	
			if (rowcnt>0)
			{
			%>
			</table>
			<%
			}
			%>
			<p>
			<div align="center"><a href="TSW02OrderReviseRequest.jsp" style="font-size:12px">回1181訂單整批變更作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
		<%	
		}
		catch(Exception e)
		{
			sql = " update oraddman.tsc_om_salesorderrevise_w02 a"+
				  " set STATUS=?"+
				  ",SYSTEM_REMARKS=NULL"+
				  " WHERE TEMP_GROUP_ID=?"+
				  " AND STATUS=?";
			pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"FAIL");
			pstmtDt.setString(2,group_id);
			pstmtDt.setString(3,"CONFIRMED");
			pstmtDt.executeQuery();
			pstmtDt.close();
			con.commit();	
			
			throw new Exception(e.getMessage());		
		}	
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>Exceution Fail!!Please contact MIS!!<br>"+e.getMessage()+"<br><br><a href='TSW02OrderReviseRequest.jsp'>回1181訂單整批變更作業</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

