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
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
	document.SUBFORM.action=URL;
	document.SUBFORM.submit();
}
function setExcel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<FORM ACTION="TSPCOrderReviseProcess.jsp" METHOD="post" NAME="SUBFORM">
<%
String sql11="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt11=con.prepareStatement(sql11);
pstmt11.executeUpdate(); 
pstmt11.close();

String sql ="",vRequestNo="",v_result="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String PLANTCODE = request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
int rowcnt=0,err_cnt=0;

if (ACODE.equals("SAVE"))
{
	String chk[]= request.getParameterValues("chk");
	String chk1[]=null;
	if (chk.length <=0)
	{
		throw new Exception("No Data Found!!");
	}
	else
	{
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("select tsc_order_revise_pc_pkg.GET_REQUEST_NO(to_char(sysdate,'yyyymmdd')) from dual");
		if (!rs.next())
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			REQUESTNO=rs.getString(1);
		}
		rs.close();
		statement.close();	
				
		for(int i=0; i< chk.length ;i++)
		{
			chk1= request.getParameterValues("chk_"+chk[i]);
			for (int j=0 ; j<chk1.length ; j++)
			{
				sql = " insert into oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
					  "(REQUEST_NO"+
					  ",REQUEST_TYPE"+
					  ",SEQ_ID"+
					  ",SO_NO"+
					  ",LINE_NO"+
					  ",PLANT_CODE"+
					  ",SO_QTY"+
					  ",SCHEDULE_SHIP_DATE"+
					  ",REASON_DESC"+
					  ",REMARKS"+
					  ",ASCRIPTION_BY"+
					  ",CREATED_BY"+
					  ",CREATION_DATE"+
					  ")"+
					  " values"+
					  " ("+
					  " ?"+
					  ",?"+
					  ",APPS.PC_ORDER_REVISE_SEQ_ID_S.NEXTVAL"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",to_date(?,'yyyy/mm/dd')"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  " )";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				//out.println(strarray[i][4]);
				//out.println(strarray[i][3]);
				pstmtDt.setString(1,REQUESTNO);
				pstmtDt.setString(2,request.getParameter("REQTYPE_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("SONO_"+chk[i]));
				pstmtDt.setString(4,request.getParameter("SOLINE_"+chk[i]));
				pstmtDt.setString(5,PLANTCODE);
				pstmtDt.setString(6,request.getParameter("QTY_"+chk1[j]));
				pstmtDt.setString(7,request.getParameter("SSD_"+chk1[j]));
				pstmtDt.setString(8,request.getParameter("REASONCODE_"+chk1[j]));
				pstmtDt.setString(9,request.getParameter("REMARKS_"+chk1[j]));
		    	pstmtDt.setString(10,request.getParameter("rdo_"+chk1[j]));
				pstmtDt.setString(11,UserName);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}	
		}
		
		con.commit();
		
		CallableStatement cs = con.prepareCall("{call tsc_order_revise_pc_pkg.revise_data_check(?,?,?)}");
		cs.setString(1,REQUESTNO);
		cs.setString(2,PLANTCODE);
		cs.registerOutParameter(3, Types.VARCHAR);
		cs.execute();
		v_result = (cs.getString(3)==null?"":cs.getString(3)); 
		cs.close();
		
		if (v_result.equals("ERROR"))
		{
			err_cnt=0;
			statement=con.createStatement();
			sql = " select ROWNUM SEQ,'MO#'||SO_NO ,'Line#'||LINE_NO,ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
				  " WHERE REQUEST_NO='"+REQUESTNO+"' and STATUS='ERR' ORDER BY SEQ_ID";
			rs=statement.executeQuery(sql);
			ResultSetMetaData md=rs.getMetaData();
			while (rs.next())
			{
				if (rs.getInt(1)==1) out.println("<div style='color:#FF0000;font-size:12px'>Upload Fail~~</div><table>");
				out.println("<tr style='color:#FF0000'>");
				out.println("<td>Row#"+(rs.getInt(1)+1)+":</td>");
				for (int j = 2 ; j <= md.getColumnCount() ; j++)
				{
					out.println("<td>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</td>");
				}
				out.println("</tr>");
				err_cnt++;
			}
			rs.close();
			statement.close();
			out.println("</table>");
			if (err_cnt==0)
			{
				out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>申請失敗!!請洽系統管理人員</div>");
			}
		}
		else
		{
			err_cnt=0;
			statement=con.createStatement();
			sql = " select ROWNUM SEQ,'MO#'||SO_NO ,'Line#'||LINE_NO,ERROR_MESSAGE from oraddman.TSC_OM_SALESORDERREVISE_PC_TMP "+
				  " WHERE REQUEST_NO='"+REQUESTNO+"' and STATUS='ERR' ORDER BY SEQ_ID";
			rs=statement.executeQuery(sql);
			ResultSetMetaData md=rs.getMetaData();
			while (rs.next())
			{
				if (rs.getInt(1)==1) out.println("<div align='center' style='color:#FF0000;font-size:12px'>以下訂單未申請成功,錯誤原因如下說明~~</div><table align='center'>");
				out.println("<tr style='color:#FF0000'>");
				out.println("<td>Row#"+(rs.getInt(1)+1)+":</td>");
				for (int j = 2 ; j <= md.getColumnCount() ; j++)
				{
					out.println("<td>"+(rs.getString(j)==null?"&nbsp;":rs.getString(j))+"</tr>");
				}
				err_cnt++;
				out.println("</tr>");
			}
			rs.close();
			statement.close();
			out.println("</table>");	
			
			if (err_cnt==0)
			{
				out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>申請成功!!申請單號:"+REQUESTNO+"</div>");
			}
			else
			{
				statement=con.createStatement();
				sql = " select COUNT(1) from oraddman.TSC_OM_SALESORDERREVISE_PC  WHERE REQUEST_NO='"+REQUESTNO+"'";
				rs=statement.executeQuery(sql);
				if (rs.next())
				{	
					if (rs.getInt(1)>0)
					{
						out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>剩餘其他訂單已申請成功!申請單號:"+REQUESTNO+"</div>");
					}
				}
				rs.close();
				statement.close();			
			}
					
		%>
			<!--<script language="JavaScript" type="text/JavaScript">
				subWin=window.open("../jsp/TSPCOrderReviseConfirmExcel.jsp?ACTTYPE=AUTO&NEW_REQ=<%=REQUESTNO%>","subwin"); 
			</script>-->	
		<%				
		}
		%>
		<br>
		<br>
		<div align="center"><a href="TSPCOrderReviseRequest.jsp" style="font-size:12px">回PC申請變更訂單作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="TSPCOrderReviseQuery.jsp?REQUESTNO=<%=REQUESTNO%>" style="font-size:12px">回PC申請變更訂單歷程查詢</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
		<%
	}
}
else if (ACODE.equals("CANCEL"))
{
	String chk[]= request.getParameterValues("chk");
	String chk1[]=null;
	String v_chk_batch_id="";
	if (chk.length <=0)
	{
		throw new Exception("No Data Found!!");
	}
	else
	{
		Statement statement=con.createStatement();
		ResultSet rs=statement.executeQuery("SELECT APPS.PC_ORDER_CHK_BATCH_ID_S.NEXTVAL FROM DUAL");
		if (!rs.next())
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			v_chk_batch_id=rs.getString(1);
		}
		rs.close();
		statement.close();	
			
		for(int i=0; i< chk.length ;i++)
		{
			chk1= request.getParameterValues("chk_"+chk[i]);
			for (int j=0 ; j<chk1.length ; j++)
			{
				sql = " INSERT INTO ORADDMAN.TSC_OM_SALESORDERREVISE_PC_ATH"+
				      " SELECT ?"+
					  ",SALES_GROUP"+
					  ",SO_NO"+
					  ",LINE_NO"+
					  ",SO_HEADER_ID"+
					  ",SO_LINE_ID"+
					  ",TO_CHAR(SCHEDULE_SHIP_DATE_TW,'YYYY/MM/DD')"+
					  ",SYSDATE"+
					  ",'D'"+
					  " FROM ORADDMAN.TSC_OM_SALESORDERREVISE_PC A"+
                      " WHERE A.SO_NO=?"+
					  " AND A.LINE_NO=?"+
                      " AND A.STATUS=?"+
                      " AND A.REQUEST_TYPE=?"+
					  " AND A.PLANT_CODE=?";	
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,v_chk_batch_id);
				pstmtDt.setString(2,request.getParameter("SONO_"+chk[i]));
				pstmtDt.setString(3,request.getParameter("SOLINE_"+chk[i]));
				pstmtDt.setString(4,"AWAITING_CONFIRM");
				pstmtDt.setString(5,"Early Warning");
				pstmtDt.setString(6,PLANTCODE);
				pstmtDt.executeQuery();
				pstmtDt.close();					  				   
					  
				sql = " UPDATE ORADDMAN.TSC_OM_SALESORDERREVISE_PC A"+
                      " SET A.STATUS =?"+
                      ",LAST_UPDATED_BY=?"+
                      ",LAST_UPDATE_DATE=SYSDATE"+
                      ",SYSTEM_REMARKS=SYSTEM_REMARKS||'Inactive by PC:'||?"+
					  ",CHK_BATCH_ID=?"+
                      " WHERE A.SO_NO=?"+
					  " AND A.LINE_NO=?"+
                      " AND A.STATUS=?"+
                      " AND A.REQUEST_TYPE=?"+
					  " AND A.PLANT_CODE=?";
				//out.println(sql);
				//out.println(request.getParameter("SONO_"+chk[i]));
				//out.println(request.getParameter("SOLINE_"+chk[i]));
				pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"INACTIVE");
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,UserName);
				pstmtDt.setString(4,v_chk_batch_id);
				pstmtDt.setString(5,request.getParameter("SONO_"+chk[i]));
				pstmtDt.setString(6,request.getParameter("SOLINE_"+chk[i]));
				pstmtDt.setString(7,"AWAITING_CONFIRM");
				pstmtDt.setString(8,"Early Warning");
				pstmtDt.setString(9,PLANTCODE);
				pstmtDt.executeQuery();
				pstmtDt.close();
			}	
		}
		
		con.commit();
		
		CallableStatement cs = con.prepareCall("{call tsc_order_revise_pc_pkg.OVERDUE_EARLY_CANCEL_NOTICE(?)}");
		cs.setString(1,v_chk_batch_id);
		cs.execute();
		cs.close();
				
		out.println("<div  align='center' style='color:#0000ff;font-family:Tahoma,Georgia;font-size:16px'>Early Warning取消成功!!</div>");
					
		%>
		<br>
		<br>
		<div align="center"><a href="TSPCOrderReviseRequest.jsp" style="font-size:12px">回PC申請變更訂單作業</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="TSPCOrderReviseQuery.jsp?REQ_TYPE_E=Early Warning" style="font-size:12px">回PC申請變更訂單歷程查詢</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
		<%
	}
}
else if (ACODE.equals("CONFIRMED"))
{
	try
	{
		String id="",group_id="";
		String chk[]= request.getParameterValues("chk");
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery("select apps.ts_pc_order_revise_group_id_s.nextval from dual");
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
				
			for(int i=0; i< chk.length ;i++)
			{
				sql = " update oraddman.tsc_om_salesorderrevise_pc a"+
					  " set SALES_CONFIRMED_QTY=?"+
					  ",SALES_CONFIRMED_SSD=TO_DATE(?,'YYYYMMDD')"+
					  ",SALES_CONFIRMED_RESULT=?"+
					  ",SALES_CONFIRMED_REMARKS=UTL_I18N.UNESCAPE_REFERENCE(?)"+
					  //",SALES_CONFIRMED_REMARKS=?"+
					  ",STATUS=?"+
					  ",SALES_CONFIRMED_BY=?"+
					  ",SALES_CONFIRMED_DATE=SYSDATE"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=SYSDATE"+
					  //",GROUP_ID=?"+
					  ",TEMP_GROUP_ID=?"+
					  ",HOLD_CODE=?"+
					  //",HOLD_REASON=UTL_I18N.UNESCAPE_REFERENCE(?)"+
					  ",HOLD_REASON=?"+
					  ",SHIPPING_METHOD=nvl(?,SOURCE_SHIPPING_METHOD)"+
					  ",SALES_CONFIRMED_SSD_F=TO_DATE(?,'YYYYMMDD')"+
					  ",TSC_ORDER_PASS_FLAG=?"+
					  " WHERE REQUEST_NO=?"+
					  " AND SEQ_ID=?"+
					  " AND STATUS=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,(request.getParameter("rdo_"+chk[i]).equals("A")?request.getParameter("qty_"+chk[i]):null));
				//pstmtDt.setString(2,(request.getParameter("rdo_"+chk[i]).equals("A")?request.getParameter("ssd_"+chk[i]):null));
				//pstmtDt.setString(2,request.getParameter("ssd_"+chk[i]));
				pstmtDt.setString(2,(request.getParameter("tsc_odr_nochange_"+chk[i])!=null&& request.getParameter("tsc_odr_nochange_"+chk[i]).equals("Y")?request.getParameter("source_ssd_"+chk[i]):request.getParameter("ssd_"+chk[i])));
				pstmtDt.setString(3,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(4,request.getParameter("salesremark_"+chk[i]));
				pstmtDt.setString(5,ACODE);
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,UserName);
				pstmtDt.setString(8,group_id);
				//pstmtDt.setString(9,group_id);
				pstmtDt.setString(9,(request.getParameter("chkhold_"+chk[i])==null?"":"YP"));
				pstmtDt.setString(10,(request.getParameter("chkhold_"+chk[i])==null?"":request.getParameter("salesremark_"+chk[i])));
				pstmtDt.setString(11,(request.getParameter("rdo_"+chk[i]).equals("A")?(request.getParameter("shipmethod_"+chk[i])==null?"":request.getParameter("shipmethod_"+chk[i])):""));
				pstmtDt.setString(12,(request.getParameter("rdo_"+chk[i]).equals("A") && Integer.parseInt(request.getParameter("totw_"+chk[i]))>0)?request.getParameter("factory_ssd_"+chk[i]):request.getParameter("ssd_"+chk[i]));
				pstmtDt.setString(13,(request.getParameter("tsc_odr_nochange_"+chk[i])==null?"N":request.getParameter("tsc_odr_nochange_"+chk[i])));
				pstmtDt.setString(14,request.getParameter("REQUESTNO_"+chk[i]));
				pstmtDt.setString(15,chk[i]);
				pstmtDt.setString(16,"AWAITING_CONFIRM");
				pstmtDt.executeQuery();
				pstmtDt.close();
			}
			con.commit();

			
			try
			{
				//改單
				CallableStatement cs3 = con.prepareCall("{call tsc_order_revise_pc_pkg.main(?,?)}");			 
				cs3.setString(1,group_id); 
				cs3.setString(2,UserName); 
				cs3.execute();		
				cs3.close();
	
				sql = " select a.request_no"+
					  ", a.request_type"+
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
					  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
					  ", to_char(a.schedule_ship_date_tw,'yyyymmdd') schedule_ship_date_tw"+
					  ", a.remarks"+
                      ", a.sales_confirmed_qty"+
					  ", to_char(a.sales_confirmed_ssd,'yyyymmdd') sales_confirmed_ssd"+
					  ", a.sales_confirmed_remarks"+				  
					  ", decode(a.sales_confirmed_result,'A','OK','R','REJ',a.sales_confirmed_result) sales_confirmed_result"+
					  ", a.status"+
					  ", a.hold_code"+
					  ", a.hold_reason"+
					  ", a.new_so_no"+
					  ", a.new_line_no"+
					  ", b.MANUFACTORY_NAME"+
					  ", ar.account_number"+
					  ", nvl(ar.customer_sname,ar.customer_name) customer"+
					  //", '('||ar.account_number||')'||nvl(ar.customer_sname,ar.customer_name) customer"+
					  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
					  ",row_number() over (partition by a.SALES_GROUP,a.request_type,request_no,a.SO_NO||'-'||a.LINE_NO order by a.seq_id, nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
					  ",count(1) over (partition by a.request_type,a.request_no,a.so_line_id) line_cnt"+
					  ",to_char(a.source_ssd_tw,'yyyymmdd') source_ssd_tw"+
					  ",to_number(to_char(a.source_ssd_tw,'yyyymmdd'))-to_number(to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd')) change_ssd"+
					  ",case when a.ERROR_MESSAGE is null then 'OK' else 'Fail' end as result"+
					  ",decode(a.NEW_SO_NO ,null,'',' New MO#：'||a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '<br>New Line#'||a.NEW_LINE_NO) || decode(a.ERROR_MESSAGE,NULL,'','<br>'||a.ERROR_MESSAGE)||decode(a.SYSTEM_REMARKS,NULL,'','<br>'||a.SYSTEM_REMARKS)  as result_remark"+
					  ",a.source_customer_po"+
					  " from oraddman.tsc_om_salesorderrevise_pc a"+
					  ",oraddman.tsprod_manufactory b"+
					  ",ont.oe_order_headers_all c"+
					  ",ont.oe_order_lines_all d"+
					  ",tsc_customer_all_v ar"+
					  " where a.so_header_id=c.header_id(+)"+  
					  " and a.so_line_id=d.line_id(+)"+
					  " and a.plant_code =b.manufactory_no(+)"+
					  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
					  " and a.temp_group_id='"+group_id+"'"+ 
					  " order by a.SALES_GROUP,a.request_type,request_no,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
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
								<td rowspan="2" width="5%" align="center">Orig SSD </td>	
								<td rowspan="2" width="8%" align="center">Cust PO</td>	
								<td width="35%" style="background-color:#006699;color:#ffffff" colspan="7" align="center">Order Revise Detail </td>
								<td rowspan="2" width="5%" align="center">Execution Result </td>
								<td rowspan="2" width="13%" align="center">System Remarks</td>
	
							</tr>
							<tr style="background-color:#BDD2DD;">
								<td width="6%" align="center">Request No</td>
								<td width="5%" align="center">Request Type</td>
								<td width="4%" align="center">Sales CFM Qty</td>
								<td width="5%" align="center">Slaes CFM SSD</td>
								<td width="6%" align="center">Shipping Method</td>
								<td width="4%" align="center">Hold</td>
								<td width="5%" align="center">Sales CFM Result</td>
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
						<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=(rs.getString("SOURCE_SSD_TW")==null?"&nbsp;":rs.getString("SOURCE_SSD_TW"))%></td>
						<td rowspan="<%=rs.getString("line_cnt")%>" align="center"><%=rs.getString("source_customer_po")%></td>
						<%
						}
						%>
						<td align="center"><%=(rs.getString("REQUEST_NO")==null?"&nbsp;":rs.getString("REQUEST_NO"))%></td>
						<td align="center"><%=(rs.getString("REQUEST_TYPE")==null?"&nbsp;":rs.getString("REQUEST_TYPE"))%></td>
						<td align="right"><%=(rs.getString("SALES_CONFIRMED_QTY")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_QTY"))%></td>
						<td align="center"><%=(rs.getString("SALES_CONFIRMED_SSD")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_SSD"))%></td>
						<td align="center"><%=(!rs.getString("SOURCE_SHIPPING_METHOD").equals(rs.getString("SHIPPING_METHOD"))?rs.getString("SHIPPING_METHOD"):"&nbsp;")%></td>
						<td align="center"><%=(rs.getString("HOLD_CODE")==null?"&nbsp;":"Y")%></td>
						<td align="center"><%=(rs.getString("SALES_CONFIRMED_RESULT")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_RESULT"))%></td>
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
				<div align="center"><a href="TSPCOrderReviseConfirm.jsp" style="font-size:12px">回業務回覆訂單變更結果</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
				
			<%	
			}
			catch(Exception e)
			{
				sql = " update oraddman.tsc_om_salesorderrevise_pc a"+
					  " set STATUS=?"+
					  ",SYSTEM_REMARKS=NULL"+
					  " WHERE TEMP_GROUP_ID=?"+
					  " AND STATUS=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,"AWAITING_CONFIRM");
				pstmtDt.setString(2,group_id);
				pstmtDt.setString(3,"CONFIRMED");
				pstmtDt.executeQuery();
				pstmtDt.close();
				con.commit();	
				
				throw new Exception(e.getMessage());		
			}	
		}		
	}
	catch(Exception e)
	{	
		con.rollback();
		out.println("<font color='red'>Exceution Fail!!Please contact MIS!!<br>"+e.getMessage()+"<br><br><a href='TSPCOrderReviseConfirm.jsp'>回工廠回覆訂單變更結果</a></font>");
	}
}
%>
</FORM>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

