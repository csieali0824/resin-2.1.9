<!--20150817 by Peggy,改為欄位名稱改為英文-->
<!--20160324 by Peggy,加上ERP MO Status-->
<!--20181222 by Peggy,新增original customer part no-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>Order Change Confirm</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8}
  .style2   {font-family:Tahoma,Georgia;border:none}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:11px;border:none;font-weight:bold}
  .style4   {font-family:Tahoma,Georgia;border-left:none;border-right:none;border-top:none;color:#000000;border-color:#CCCCCC}
  .style5   {font-family:Tahoma,Georgia}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setClose(URL)
{
	location.href=URL;
}
function subWindowDetail(ERPCUSTOMERID,REQUESTNO)
{
	subWin=window.open("../jsp/TSCEDIOrderDetail.jsp?ERPCUSTOMERID="+ERPCUSTOMERID+"&REQUESTNO="+REQUESTNO,"subwin","width=1200,height=500,scrollbars=yes,menubar=no,location=no");
}
function showNoticeWindow(seqno,customerpo,erpcustid)
{
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSCEDIOrderDetailNotice.jsp?CUSTPO="+customerpo+"&CUSTID="+erpcustid+"&SEQNO="+seqno,"subwin","left=500,width=500,height=300,scrollbars=yes,menubar=no");  
}
function sendMailWindow(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();	
}
</script>
<%
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String ERPCUSTOMERID = request.getParameter("ERPCUSTOMERID");
	if (ERPCUSTOMERID==null) ERPCUSTOMERID="";
	String DATAFLAG=request.getParameter("DFLAG");
	if (DATAFLAG==null) DATAFLAG ="";  //add by Peggy 20140205
	String sql = "",CREATION_DATE="",CREATED_BY="",CUSTNAME="",VERSION_ID="",CUSTOMER_NAME="",REQUEST_DATE="",CURRENCY="",MAIL_TO_CUST_FLAG="";
	
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
	
	boolean bNotFound = false;
	
	try
	{
		sql = " select a.*,'('||c.customer_number||')'||c.CUSTOMER_NAME as CUSTNAME,d.SALES_AREA_NO,c.CUSTOMER_NAME "+
		      ",nvl(MAIL_TO_CUST_FLAG,'N') MAIL_TO_CUST_FLAG"+ //add by Peggy 20140717
		      " from tsc_edi_orders_header a,ar_customers c,tsc_edi_customer d "+
			  " where a.ERP_CUSTOMER_ID= c.customer_id  and a.DATA_FLAG=? and a.ERP_CUSTOMER_ID=? and a.CUSTOMER_PO=?"+
			  " and a.ERP_CUSTOMER_ID=d.CUSTOMER_ID";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		//statement.setString(1,"Y");
		statement.setString(1,DATAFLAG);  //add by Peggy 20140205
		statement.setString(2,ERPCUSTOMERID);
		statement.setString(3,CUSTPO);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUSTNAME = rs.getString("CUSTNAME");
			CURRENCY = rs.getString("CURRENCY_CODE");
			CUSTOMER_NAME = rs.getString("CUSTOMER_NAME");
			REQUEST_DATE = rs.getString("REQUEST_DATE");
			MAIL_TO_CUST_FLAG = rs.getString("MAIL_TO_CUST_FLAG"); //add by Peggy 20140717
		}
		else
		{
			bNotFound = true;
		}
		rs.close();
		statement.close();	
	
	}
	catch(Exception e)
	{
		out.println("Exception1:"+e.getMessage());
		//bNotFound = true;
	}	
	
	if (bNotFound)
	{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!申請單狀態可能不符合條件,請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCEDIDetailQuery.jsp" METHOD="post" NAME="MYFORM">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料搜尋中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">EDI	Customer Order Query</font>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td align="right"><a href="TSCEDIHistoryQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0" bordercolor="#cccccc">
				<tr>
					<td bgcolor='#64B077'><font style="color:#ffffff">Customer</font></td>
					<td><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" size="40" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"><input type="hidden" name="CUSTOMER_NAME" value="<%=CUSTOMER_NAME%>"></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Customer PO</font></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Currency Code</font></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Creation Date</font></td>
					<td><input type="text" name="REQUEST_DATE" value="<%=REQUEST_DATE%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
			<%
			try
			{
				sql = " select a.ERP_CUSTOMER_ID,a.customer_po,a.cust_po_line_no,a.seq_no,a.cust_item_name,"+
				      " a.tsc_item_name,a.unit_price,"+
					  " (select count(1)  from tsc_edi_orders_detail b where b.customer_po=a.customer_po and b.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID and b.CUST_PO_LINE_NO=a.CUST_PO_LINE_NO) po_line_cnt, "+
					  " a.cust_request_date,a.quantity,a.uom,decode(nvl(a.data_flag,''),'C','Cancelled','P',a.ISSUE_REASON,'') data_flag,decode(nvl(a.data_flag,''),'P','Mailed Date:'||TO_CHAR(MAILED_DATE,'yyyy-mm-dd hh24:mi')||'<br>','') ||a.remarks remarks"+
					  ",a.orig_cust_item_name,a.orig_tsc_item_name"+ //add by Peggy 20181222
                      " from tsc_edi_orders_detail a"+
                      " where a.customer_po=?"+
                      " and a.ERP_CUSTOMER_ID=?"+
                      " order by a.ERP_CUSTOMER_ID,a.customer_po,to_number(a.cust_po_line_no),a.seq_no";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,CUSTPO);
				statement.setString(2,ERPCUSTOMERID);
				ResultSet rs=statement.executeQuery();
				int i =0;
				String cust_po_line_no ="",strTotQty="",rfq_list="",mo_list="",mo_status_list="";
				while (rs.next())
				{
					if (i==0)
					{
				%>
				<tr>
					<td colspan="8">
						<table align="center" width='100%' border='1' bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bordercolor="#64B077">
							<tr style="color:#64B077">
								<td colspan="14">Order Detail:</td>
							</tr>
							<tr bgcolor='#64B077' style="color:#FFFFFF">
								<%
								if (MAIL_TO_CUST_FLAG.equals("Y"))
								{
								%>
								<td align="center" width="5%">&nbsp;</td>
								<%
								}
								%>
								<td align="center" width="6%">PO Line</td>
								<td align="center" width="8%">Customer PN</td>
								<td align="center" width="8%">Orig Cust PN</td>
								<td align="center" width="8%">TSC PN</td>
								<td align="center" width="8%">Orig TSC PN</td>
								<td align="center" width="4%">Selling Price</td>
								<td align="center" width="4%">&nbsp;</td>
								<td align="center" width="5%">CRD</td>
								<td align="center" width="5%">Qty</td>
								<td align="center" width="4%">UOM</td>
								<td align="center" width="5%">Status</td>
								<td align="center" width="11%">Remarks</td>
								<td align="center" width="10%">RFQ#</td>
								<td align="center" width="8%">ERP MO#</td>
								<td align="center" width="9%">ERP MO Status</td>
							</tr>
				<%
					}
					out.println("<tr>");
					if (!cust_po_line_no.equals(rs.getString("CUST_PO_LINE_NO")))
					{
						if (MAIL_TO_CUST_FLAG.equals("Y"))
						{
							out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"' align='center'><input type='button' name='btnx_"+rs.getString("seq_no")+"' value='EMAIL' onClick='sendMailWindow("+'"'+"../jsp/TSCEDIMailProcess.jsp?POLINE="+rs.getString("CUST_PO_LINE_NO")+"&CUSTPO="+CUSTPO+"&ERPCUSTOMERID="+ERPCUSTOMERID+'"'+")' style='font-family:Tahoma,Georgia;font-size:11px'></td>");
						}
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rs.getString("CUST_PO_LINE_NO")==null?"&nbsp;":rs.getString("CUST_PO_LINE_NO"))+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rs.getString("ORIG_CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("ORIG_CUST_ITEM_NAME"))+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rs.getString("TSC_ITEM_NAME")==null?"&nbsp;":rs.getString("TSC_ITEM_NAME"))+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rs.getString("ORIG_TSC_ITEM_NAME")==null?"&nbsp;":rs.getString("ORIG_TSC_ITEM_NAME"))+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"' align='right'>"+(new DecimalFormat("####0.00000")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"</td>");
						rfq_list="";mo_list="";mo_status_list="";
					}
					out.println("<td><input type='button' name='btn_"+rs.getString("seq_no")+"' value='Remark' onClick='showNoticeWindow("+'"'+rs.getString("seq_no")+'"'+","+'"'+CUSTPO+'"'+","+'"'+ERPCUSTOMERID+'"'+")'  style='font-family:Tahoma,Georgia;font-size:11px'></td>");
					out.println("<td align='center'>"+(rs.getString("CUST_REQUEST_DATE")==null?"&nbsp;":rs.getString("CUST_REQUEST_DATE"))+"</td>");
					out.println("<td align='right'>"+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs.getString("QUANTITY")))+"</td>");
					out.println("<td align='center'>"+(rs.getString("UOM")==null?"&nbsp;":rs.getString("UOM"))+"</td>");
					out.println("<td align='center'><div id='flag_"+rs.getString("seq_no")+"'>"+(rs.getString("DATA_FLAG")==null?"&nbsp;":"<font color='#ff0000'>"+rs.getString("DATA_FLAG")+"</font>")+"</div></td>");
					out.println("<td align='center'><div id='remark_"+rs.getString("seq_no")+"'>"+(rs.getString("REMARKS")==null||rs.getString("REMARKS").equals("null")?"&nbsp;":"<font color='#ff0000'>"+rs.getString("REMARKS")+"</font>")+"</div></td>");
					if (!cust_po_line_no.equals(rs.getString("CUST_PO_LINE_NO")))
					{
						sql = " select '1',b.dndocno odrno,to_char(b.LINE_NO) line_no,b.LSTATUS status_code "+
						      " from oraddman.tsdelivery_notice a,oraddman.tsdelivery_notice_detail b"+
                              " where a.TSCUSTOMERID=?"+
                              " and a.dndocno = b.dndocno "+
                              " and b.CUST_PO_NUMBER=?"+
                              " and b.CUST_PO_LINE_NO=? "+
							  " and b.LSTATUSID not in ('001','012')"+
                              " union all "+
                              " select '2',to_char(a.order_number) odrno,b.line_number||'.'||b.shipment_number line_no,b.flow_status_code status_code"+
                              " from ont.oe_order_headers_all a,ont.oe_order_lines_all b"+
                              " where a.header_id= b.header_id"+
							  " and b.ordered_quantity>0"+
                              " and b.FLOW_STATUS_CODE <>'CANCELLED'"+
                              " and a.sold_to_org_id=?"+
                              " and b.customer_line_number=?"+
                              " and b.customer_shipment_number=?";							  
						PreparedStatement statement1 = con.prepareStatement(sql);
						statement1.setString(1,ERPCUSTOMERID);
						statement1.setString(2,CUSTPO);
						statement1.setString(3,rs.getString("CUST_PO_LINE_NO"));
						statement1.setString(4,ERPCUSTOMERID);
						statement1.setString(5,CUSTPO);
						statement1.setString(6,rs.getString("CUST_PO_LINE_NO"));
						ResultSet rs1=statement1.executeQuery();
						while (rs1.next())
						{
							if (rs1.getString(1).equals("1"))
							{
								rfq_list += ("<a href='../jsp/TSSDRQInformationQuery.jsp?DNDOCNOSET="+rs1.getString(2)+"&YEARFR=2010&MONTHFR=01&DAYFR=01'>"+rs1.getString(2)+"&nbsp;&nbsp;&nbsp;"+rs1.getString(3)+"</a><br>");
							}
							else if (rs1.getString(1).equals("2"))
							{
								mo_list += (""+rs1.getString(2)+"&nbsp;&nbsp;&nbsp;"+rs1.getString(3)+"<br>");
								mo_status_list += (""+rs1.getString(4)+"<br>");
							}
						}
						rs1.close();
						statement1.close();
						
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(rfq_list.equals("")?"&nbsp;":rfq_list)+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(mo_list.equals("")?"&nbsp;":mo_list)+"</td>");
						out.println("<td rowspan='"+rs.getString("PO_LINE_CNT")+"'>"+(mo_status_list.equals("")?"&nbsp;":mo_status_list)+"</td>");
						cust_po_line_no=rs.getString("CUST_PO_LINE_NO");
					}
					out.println("</tr>");
					//out.println("<td>"+(rs.getString("dndocno")==null?"&nbsp;":"<a href='../jsp/TSSDRQInformationQuery.jsp?DNDOCNOSET="+rs.getString("dndocno")+"&YEARFR="+rs.getString("rfq_CREATION_DATE").substring(0,4)+"&MONTHFR="+rs.getString("rfq_CREATION_DATE").substring(4,6)+"&DAYFR="+rs.getString("rfq_CREATION_DATE").substring(6,8)+"&YEARTO="+rs.getString("rfq_CREATION_DATE").substring(0,4)+"&MONTHTO="+rs.getString("rfq_CREATION_DATE").substring(4,6)+"&DAYTO="+rs.getString("rfq_CREATION_DATE").substring(6,8)+"'>"+rs.getString("rfq")+"</a>")+"</td>");
					//out.println("<td align='right'>"+(!rs.getString("QUANTITY").equals(rs.getString("rfq_quantity"))?"<font color:#0000ff>":"<font color:#000000>")+(rs.getString("rfq_quantity")==null?"&nbsp;":(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs.getString("rfq_QUANTITY"))))+"</font></td>");
					//out.println("<td>"+(rs.getString("order_number")==null?"&nbsp;":rs.getString("order_number"))+"</td>");
					//out.println("<td>"+(rs.getString("order_lineno")==null?"&nbsp;":rs.getString("order_lineno"))+"</td>");
					//out.println("<td>"+(rs.getString("creation_date")==null?"&nbsp;":rs.getString("creation_date"))+"</td>");
					//out.println("<td align='right'>"+(!rs.getString("QUANTITY").equals(rs.getString("ordered_quantity"))?"<font color:#0000ff>":"<font color:#000000>")+(rs.getString("ordered_quantity")==null?"&nbsp;":(new DecimalFormat("##,###,##0")).format(Float.parseFloat(rs.getString("ordered_quantity"))))+"</font></td>");
					//out.println("<td>"+(rs.getString("request_date")==null?"&nbsp;":rs.getString("request_date"))+"</td>");
					//out.println("<td>"+(rs.getString("shipping_method_code")==null?"&nbsp;":rs.getString("shipping_method_code"))+"</td>");
					//out.println("<td>"+(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))+"</td>");
					//out.println("<td>"+(rs.getString("status")==null?"&nbsp;":rs.getString("status"))+"</td>");
					//out.println("<td><font color='#ff0000'>"+(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))+"</font></td>");
					i++;
				}
				rs.close();
				statement.close();
				
				if (i >0)
				{
				%>
						</table>
					</td>
				</tr>
				<%
				}
			}
			catch(Exception e)
			{
				out.println("Exception2:"+e.getMessage());
			}	
			%>
			</table>
		</td>
	</tr>
</table>
<HR>
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td><font style="color:#8F996C">Order History:</font></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bordercolor="#336699">
				<tr bgcolor='#336699' style="color:#ffffff">
					<td align="center" width="5%">Seq No</td>
					<td align="center" width="10%">Creation Date</td>
					<td align="center" width="10%">Order Type</td>
					<td align="center" width="10%">Request Date</td>
					<td align="center" width="10%">Request No</td>
					<td align="center" width="30%">Source File</td>
					<td align="center" width="10%">Request Detail</td>
				</tr>
			<%
				sql = " SELECT  to_char(to_date(a.request_date,'yyyymmdd'),'yyyy-mm-dd') request_date,a.request_no,decode(a.order_type,'ORDERS','New Order','ORDCHG','Order Change',a.order_type) order_type,"+
                      " b.source_file_name, to_char(a.creation_date,'yyyy-mm-dd hh24:mi') creation_date"+
                      " FROM tsc_edi_orders_his_h a,tsc_edi_element_header b"+
                      " where a.erp_customer_id=?"+
                      " and a.customer_po=?"+
                      " and a.erp_customer_id=b.erp_customer_id"+
                      " and a.REQUEST_NO=b.request_no"+
                      " and a.order_type=b.trans_type"+
                      " order by  a.request_date";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,ERPCUSTOMERID);
				statement.setString(2,CUSTPO);
				ResultSet rs=statement.executeQuery();
				int i =1;
				while (rs.next())
				{
					out.println("<tr>");
					out.println("<td align='center'>"+(i++)+"</td>");
					out.println("<td align='center'>"+rs.getString("creation_date")+"</td>");
					out.println("<td align='center'>"+rs.getString("order_type")+"</td>");
					out.println("<td align='center'>"+rs.getString("request_date")+"</td>");
					out.println("<td align='center'>"+rs.getString("request_no")+"</td>");
					out.println("<td>"+rs.getString("source_file_name")+"</td>");
					out.println("<td align='center'><IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='subWindowDetail("+'"'+ERPCUSTOMERID+'"'+","+'"'+rs.getString("request_no")+'"'+")'></td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();	  
			%>
			</table>
		</td>
	</tr>
</table>
<P>
<div align="center"><INPUT TYPE="button" name="exit" value="Exit" style="font-family: Tahoma,Georgia; font-size: 12px" onClick='setClose("../jsp/TSCEDIHistoryQuery.jsp")' ></div>
<input name="PROGRAMNAME" type="hidden" value="ORDERQUERY">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
