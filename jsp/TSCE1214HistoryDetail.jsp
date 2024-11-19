<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*,java.text.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<html>
<head>
<title>TSCE HUB PO Detail</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--=================================-->
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   {background-color:#E1CDC8}
  .style2   {font-family:Tahoma,Georgia;border:none}
  .style3   {font-family:Tahoma,Georgia;color:#000000;font-size:12px;border:none;font-weight:bold}
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
function showNoticeWindow(seqno,customerpo,versionid)
{
	document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open("../jsp/TSCE1214DetailNotice.jsp?CUSTPO="+customerpo+"&VER="+versionid+"&SEQNO="+seqno,"subwin","left=500,width=500,height=300,scrollbars=yes,menubar=no");  
}
</script>
<%
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO==null) CUSTPO="";
	String VERSIONID = request.getParameter("VERSIONID");
	if (VERSIONID==null) VERSIONID="";
	String ERPCUSTOMERID = "";
	String sql = "",CREATION_DATE="",CREATED_BY="",CUSTNAME="",VERSION_ID="",CUSTOMER_NAME="",CURRENCY="";
	
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
	cs1.setString(1,"41"); 
	cs1.execute();
	cs1.close();
	
	boolean bNotFound = false;
	
	try
	{
		sql = " select a.erp_customer_id,to_char(a.CREATION_DATE,'yyyy-mm-dd hh24:mi') creation_date,b.CUSTOMER_NAME as CUSTNAME,'001' AS SALES_AREA_NO,(select currency_code from oraddman.tsce_purchase_order_lines x where x.customer_po = a.customer_po and x.version_id = a.version_id and rownum=1) currency_code "+
		      " from oraddman.tsce_purchase_order_headers a,oraddman.tsce_end_customer_list b"+
			  " where substr(a.customer_po,0,instr(a.customer_po,'-')-1)= b.customer_id(+) "+
			  " and a.CUSTOMER_PO=? AND a.version_id=?";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,CUSTPO);
		statement.setString(2,VERSIONID);
		ResultSet rs=statement.executeQuery();
		if (rs.next())
		{
			CUSTNAME = rs.getString("CUSTNAME");
			CURRENCY = rs.getString("CURRENCY_CODE");
			CREATION_DATE = rs.getString("CREATION_DATE");
			ERPCUSTOMERID = rs.getString("ERP_CUSTOMER_ID");
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
			alert("查無資料!!請重新確認,謝謝!");
			closeWindow();
		</script>
		<%
	}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<FORM ACTION="TSCE1214HistoryDetail.jsp" METHOD="post" NAME="MYFORM">
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
		<td align="left"><font style="font-weight:bold;font-size:20px;color:#003366;font-family:Tahoma,Georgia">TSCE Hub PO Detail Query</font>
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td align="right"><a href="TSCE1214HistoryQuery.jsp" id="myLINK"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></a></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width="100%" border="1" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td bgcolor='#64B077'><font style="color:#ffffff">End Customer Name</font></td>
					<td><input type="text" name="CUSTNAME" value="<%=CUSTNAME%>" size="40" class="style3" onKeyDown="return (event.keyCode!=8);" readonly><input type="hidden" name="ERPCUSTOMERID" value="<%=ERPCUSTOMERID%>"></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Customer PO</font></td>
					<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Version ID</font></td>
					<td><input type="text" name="VERSIONID" value="<%=VERSIONID%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Currency Code</font></td>
					<td><input type="text" name="CURRENCY" value="<%=CURRENCY%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor='#64B077'><font style="color:#ffffff">Creation Date</font></td>
					<td><input type="text" name="REQUEST_DATE" value="<%=CREATION_DATE%>" class="style3" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
			<%
			try
			{
				/*
				sql = " select customer_line_number,customer_shipment_number,row_number() over (partition by customer_shipment_number order by creation_date desc) ROW_CNT,"+
                      " TYPE,requestno,line_no,ordered_item,item_name,item_desc,ordered_quantity,shipping_method_code, REQUEST_DATE, SCHEDULE_SHIP_DATE,line_number,shipment_number,status ,creation_date,created_by,UNIT_SELLING_PRICE"+
                      " from (select a.customer_line_number,to_number(a.customer_shipment_number) customer_shipment_number,'1','MO' TYPE,to_char(b.order_number) requestno,line_number||'.'||a.shipment_number line_no,a.ordered_item,c.segment1 item_name,c.description item_desc,a.ordered_quantity,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyymmdd') REQUEST_DATE,to_char( a.SCHEDULE_SHIP_DATE,'yyyymmdd')  SCHEDULE_SHIP_DATE,a.line_number,a.shipment_number,a.FLOW_STATUS_CODE status ,to_char(a.creation_date,'yyyymmdd') creation_date,d.user_name created_by,a.UNIT_SELLING_PRICE"+
                      " from ont.oe_order_lines_all a,ont.oe_order_headers_all b ,inv.mtl_system_items_b c,fnd_user d"+
                      " where b.SOLD_TO_ORG_ID=?"+
                      " and a.customer_line_number=?"+
                      " and a.header_id=b.header_id"+
                      " and a.ordered_quantity>0"+
                      " and a.FLOW_STATUS_CODE <>'CANCELLED'"+
                      " and a.inventory_item_id = c.inventory_item_id"+
                      " and b.ship_from_org_id=c.organization_id"+
                      " and a.created_by = d.user_id"+
                      " union all"+
                      " select a.CUST_PO_NUMBER,to_number(a.CUST_PO_LINE_NO) customer_shipment_number,'2','RFQ' TYPE,a.dndocno requestno,to_char(a.line_no) line_no,a.ordered_item,a.item_segment1 item_name,a.item_description item_desc,a.quantity*1000 ordered_quantity,a.shipping_method,a.CUST_REQUEST_DATE REQUEST_DATE,substr(a.REQUEST_DATE,1,8) SCHEDULE_SHIP_DATE,line_no line_number,0 shipment_number ,a.LSTATUS  status,to_char(to_date(a.creation_date,'yyyymmdd hh24miss'),'yyyymmdd') creation_date,(select username from oraddman.wsuser c where c.webid = a.created_by and c.lockflag='N' and rownum=1) created_by,a.selling_price UNIT_SELLING_PRICE"+
                      " from oraddman.tsdelivery_notice_detail a,oraddman.tsdelivery_notice b"+
                      " where a.dndocno = b.dndocno"+
                      " and b.TSCUSTOMERID=?"+
                      " and a.CUST_PO_NUMBER =?"+
                      " AND (ORDERNO is null or ORDERNO ='N/A')"+
                      " and a.LSTATUSID not in ('001','010','012')"+
					  " union all"+
					  " select b.CUSTOMER_PO CUST_PO_NUMBER,to_number(a.PO_LINE_NO) customer_shipment_number,'3',' ' TYPE,'' as requestno,'' as line_no,a.CUST_PART_NO ordered_item,'' as item_name,a.TSC_PART_NO item_desc, decode(a.UOM,'KPC',a.QUANTITY*1000,a.QUANTITY) ordered_quantity,'' as shipping_method,a.CRD  REQUEST_DATE, '' as SCHEDULE_SHIP_DATE, 0 line_number,0 shipment_number,'AWAITING_CONFIRM' AS status,''  AS creation_date, '' AS created_by,a.UNIT_PRICE as UNIT_SELLING_PRICE "+
					  " from oraddman.tsce_purchase_order_lines a,oraddman.tsce_purchase_order_headers b"+
					  " where a.DATA_FLAG=?"+
					  " and b.CUSTOMER_PO=?"+
					  " and b.version_id=?"+
					  " and b.CUSTOMER_PO=a.CUSTOMER_PO"+
					  " and b.VERSION_ID=a.VERSION_ID"+
                      " )"+
                      " ORDER BY 1,2,3 DESC";
				*/
				sql = " select b.po_line_no"+
				      ",b.cust_part_no"+
					  ",b.tsc_part_no"+
					  ",b.quantity"+
					  ",b.CRD"+
					  ",b.unit_price"+
					  ",decode(c.dndocno,null,'',c.dndocno ||'/'|| c.line_no) rfq"+
					  ",c.rfq_quantity"+
					  ",d.order_number || lpad(d.order_lineno,7,' ') order_number"+
					  ",d.order_lineno"+
					  ",d.ordered_quantity"+
					  ",d.REQUEST_DATE"+
					  ",d.SCHEDULE_SHIP_DATE"+
					  ",d.shipping_method_code"+
					  ",d.creation_date"+
					  ",c.dndocno"+
					  ",c.CREATION_DATE rfq_CREATION_DATE"+
					  ",decode(b.DATA_FLAG,'C','Cancelled','') status"+
					  ",b.REMARKS"+
				      " from oraddman.tsce_purchase_order_headers a"+
					  "     ,oraddman.tsce_purchase_order_lines b"+
					  "     ,(select x.tscustomerid,y.dndocno,y.line_no,y.cust_po_number,y.CUST_PO_LINE_NO,y.quantity *1000 rfq_quantity ,x.CREATION_DATE "+
					  "       from oraddman.tsdelivery_notice x"+
					  "            ,oraddman.tsdelivery_notice_detail y "+
					  "       where x.dndocno = y.dndocno "+
					  "       and x.TSAREANO='001'"+
					  "       and y.LSTATUSID<>'012'"+
					  "       and exists (select 1 from oraddman.tsce_purchase_order_headers g where g.customer_po=? and g.version_id=? and g.erp_customer_id = x.tscustomerid)) c"+
					  "     ,(select b.SOLD_TO_ORG_ID,a.customer_line_number,to_number(a.customer_shipment_number) customer_shipment_number,to_char(b.order_number) order_number,line_number||'.'||a.shipment_number order_lineno,a.ordered_quantity,a.shipping_method_code, to_char(a.REQUEST_DATE,'yyyymmdd') REQUEST_DATE,to_char( a.SCHEDULE_SHIP_DATE,'yyyymmdd')  SCHEDULE_SHIP_DATE,a.FLOW_STATUS_CODE status ,to_char(a.creation_date,'yyyymmdd') creation_date"+
                      "      from ont.oe_order_lines_all a"+
					  "          ,ont.oe_order_headers_all b "+
                      "      where a.header_id=b.header_id"+
                      "      and a.ordered_quantity>0"+
                      "      and a.FLOW_STATUS_CODE <>'CANCELLED'"+
					  "	     and exists (select 1 from oraddman.tsce_purchase_order_headers g where g.customer_po=? and g.version_id=? and g.erp_customer_id = a.sold_to_org_id)) d"+
					  " where a.customer_po = b.customer_po"+
					  " and a.version_id = b.version_id"+
					  //" and a.erp_customer_id = c.tscustomerid"+
					  " and b.customer_po = c.cust_po_number(+)"+
					  " and b.po_line_no = c.cust_po_line_no(+)"+
					  //" and a.erp_customer_id = d.sold_to_org_id"+
					  " and b.customer_po = d.customer_line_number(+)"+
					  " and b.po_line_no = d.customer_shipment_number(+)"+
					  " and a.customer_po=?"+
					  " and a.version_id=?"+
					  " order by b.po_line_no";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,CUSTPO);
				statement.setString(2,VERSIONID);
				statement.setString(3,CUSTPO);
				statement.setString(4,VERSIONID);
				statement.setString(5,CUSTPO);
				statement.setString(6,VERSIONID);
				ResultSet rs=statement.executeQuery();
				int i =0,totQty=0;
				String cust_po_line_no ="",strTotQty="",cust_part_no="",tsc_part_no="",qty="",unit_price="",crd="",rfq="",mo="",rfq_list="",mo_list="",status="",remarks="";
				while (rs.next())
				{
					if (i==0)
					{
				%>
				<tr>
					<td colspan="10">
						<table align="center" width='100%' border='1' bordercolorlight='#64B077' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
							<tr style="color:#64B077">
								<td colspan="16">PO Detail:</td>
							</tr>
							<tr bgcolor='#64B077' style="color:#FFFFFF">
								<td align="center" width="7%"><jsp:getProperty name='rPH' property='pgCustPOLineNo'/></td>
								<td align="center" width="12%"><jsp:getProperty name='rPH' property='pgCustItemNo'/></td>
								<td align="center" width="12%"><jsp:getProperty name='rPH' property='pgTSCAlias'/><jsp:getProperty name='rPH' property='pgItemDesc'/></td>
								<td align="center" width="4%">&nbsp;</td>
								<td align="center" width="7%">CRD</td>
								<td align="center" width="6%"><jsp:getProperty name='rPH' property='pgQty'/>(PCE)</td>
								<td align="center" width="6%">Selling<BR>Price</td>
								<td align="center" width="6%">Status</td>
								<td align="center" width="20%">Remarks</td>
								<td align="center" width="11%">RFQ/Line</td>
								<td align="center" width="11%">ERP MO/Line</td>
							</tr>
				<%	
						cust_po_line_no=rs.getString("po_line_no");
						cust_part_no=rs.getString("cust_part_no");
						tsc_part_no=rs.getString("tsc_part_no");
						crd=rs.getString("crd");
						qty=rs.getString("QUANTITY");
						unit_price=rs.getString("UNIT_PRICE");
						status=rs.getString("status");
						remarks=rs.getString("remarks");
					}
					if (!cust_po_line_no.equals(rs.getString("po_line_no")))
					{
						out.println("<tr>");
						out.println("<td>"+cust_po_line_no+"</td>");
						out.println("<td>"+(cust_part_no==null?"&nbsp;":cust_part_no)+"</td>");
						out.println("<td>"+(tsc_part_no==null?"&nbsp;":tsc_part_no)+"</td>");
						out.println("<td><input type='button' name='btn_"+cust_po_line_no+"' value='訂單備註' onClick='showNoticeWindow("+'"'+cust_po_line_no+'"'+","+'"'+CUSTPO+'"'+","+'"'+VERSIONID+'"'+")'  style='font-family:Tahoma,Georgia;font-size:11px'></td>");
						out.println("<td align='center'>"+(crd==null?"&nbsp;":crd)+"</td>");
						out.println("<td align='right'>"+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(qty))+"</td>");
						out.println("<td align='right'>"+(new DecimalFormat("####0.00000")).format(Float.parseFloat(unit_price))+"</td>");
						out.println("<td style='color:#ff0000'><div id='flag_"+cust_po_line_no+"'>"+(status==null || status.equals("")?"&nbsp;":status)+"</div></td>");
						out.println("<td style='color:#ff0000'><div id='remark_"+cust_po_line_no+"'>"+(remarks==null || remarks.equals("")?"&nbsp;":remarks)+"</div></td>");
						out.println("<td>"+(rfq_list.equals("")?"&nbsp;":rfq_list)+"</td>");
						out.println("<td>"+(mo_list.equals("")?"&nbsp;":mo_list)+"</td>");
						out.println("</tr>");
						cust_po_line_no=rs.getString("po_line_no");
						cust_part_no=rs.getString("cust_part_no");
						tsc_part_no=rs.getString("tsc_part_no");
						crd=rs.getString("crd");
						qty=rs.getString("QUANTITY");
						unit_price=rs.getString("UNIT_PRICE");
						status=rs.getString("status");
						remarks=rs.getString("remarks");
						rfq_list ="";mo_list="";
					}
					if (!rfq.equals(rs.getString("rfq")) && rs.getString("rfq") != null)
					{
						if (rfq_list.length() >0) rfq_list+="<br>";
						rfq_list += "<a href='../jsp/TSSDRQInformationQuery.jsp?DNDOCNOSET="+rs.getString("dndocno")+"&YEARFR="+rs.getString("rfq_CREATION_DATE").substring(0,4)+"&MONTHFR="+rs.getString("rfq_CREATION_DATE").substring(4,6)+"&DAYFR="+rs.getString("rfq_CREATION_DATE").substring(6,8)+"&YEARTO="+rs.getString("rfq_CREATION_DATE").substring(0,4)+"&MONTHTO="+rs.getString("rfq_CREATION_DATE").substring(4,6)+"&DAYTO="+rs.getString("rfq_CREATION_DATE").substring(6,8)+"'>"+rs.getString("rfq")+"</a>";
						rfq=rs.getString("rfq");
					}
					if (!mo.equals(rs.getString("order_number")) && rs.getString("order_number") != null)
					{
						if (mo_list.length() >0) mo_list+="<br>";
						mo_list +=rs.getString("order_number");
						mo=rs.getString("order_number");
					}
					i++;
				}
				rs.close();
				statement.close();
				
				if (i>0)
				{
					out.println("<tr>");
					out.println("<td>"+cust_po_line_no+"</td>");
					out.println("<td>"+(cust_part_no==null?"&nbsp;":cust_part_no)+"</td>");
					out.println("<td>"+(tsc_part_no==null?"&nbsp;":tsc_part_no)+"</td>");
					out.println("<td><input type='button' name='btn_"+cust_po_line_no+"' value='訂單備註' onClick='showNoticeWindow("+'"'+cust_po_line_no+'"'+","+'"'+CUSTPO+'"'+","+'"'+VERSIONID+'"'+")'  style='font-family:Tahoma,Georgia;font-size:11px'></td>");
					out.println("<td align='center'>"+(crd==null?"&nbsp;":crd)+"</td>");
					out.println("<td align='right'>"+(new DecimalFormat("##,###,##0")).format(Float.parseFloat(qty))+"</td>");
					out.println("<td align='right'>"+(new DecimalFormat("####0.00000")).format(Float.parseFloat(unit_price))+"</td>");
					out.println("<td style='color:#ff0000'><div id='flag_"+cust_po_line_no+"'>"+(status==null || status.equals("")?"&nbsp;":status)+"</div></td>");
					out.println("<td style='color:#ff0000'><div id='remark_"+cust_po_line_no+"'>"+(remarks==null || remarks.equals("")?"&nbsp;":remarks)+"</div></td>");
					out.println("<td>"+(rfq_list.equals("")?"&nbsp;":rfq_list)+"</td>");
					out.println("<td>"+(mo_list.equals("")?"&nbsp;":mo_list)+"</td>");
					out.println("</tr>");
					out.println("</table></td></tr>");
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
<%
	sql = " SELECT customer_name,customer_po,version_id,to_char(creation_date,'yyyy-mm-dd hh24:mi') creation_date,SOURCE_FILE_NAME  from oraddman.tsce_purchase_order_headers a"+
		  " where customer_po=?"+
		  " order by version_id";
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,CUSTPO);
	ResultSet rs=statement.executeQuery();
	int i =0;
	while (rs.next())
	{
		if (i==0)
		{
%>		
<table width="100%">
	<tr>
		<td>
			<table align="center" width="100%" border="0" bordercolorlight="#64B077" bordercolordark="#ffffff" cellPadding="1"  cellspacing="0">
				<tr>
					<td><font style="color:#8F996C">PO History:</font></td>
				</tr>
			</table>		
		</td>
	</tr>
	<tr>
		<td>
			<table align="center" width='100%' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
				<tr bgcolor="#336666" style="color:#FFFFFF">
					<td align="center" width="20%">End Customer Name</td>
					<td align="center" width="15%">Customer PO</td>
					<td align="center" width="5%">Version ID</td>
					<td align="center" width="10%">Creation Date</td>
					<td align="center" width="50%">Source File</td>
				</tr>
<%
		}
		out.println("<tr>");
		out.println("<td align='center'>"+rs.getString("customer_name")+"</td>");
		out.println("<td align='center'>"+rs.getString("customer_po")+"</td>");
		out.println("<td align='center'>"+rs.getString("version_id")+"</td>");
		out.println("<td align='center'>"+rs.getString("creation_date")+"</td>");
		out.println("<td title='按下滑鼠右鍵,可下載excel檔!'><a href='\\\\10.0.3.109\\FTP_DownloadFiles\\PurchaseOrders\\Backup\\"+rs.getString("SOURCE_FILE_NAME")+"' target='_blank'><img src='images/xls.gif' border='0'>"+rs.getString("SOURCE_FILE_NAME")+"</a></td>");
		out.println("</tr>");
		i++;
	}
%>

			</table>
		</td>
	</tr>
</table>	
<%			
	rs.close();
	statement.close();	  
%>
<P>
<div align="center"><INPUT TYPE="button" name="exit" value='離開' onClick='setClose("../jsp/TSCE1214HistoryQuery.jsp")' ></div>
<input name="PROGRAMNAME" type="hidden" value="ORDERQUERY">
</FORM>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
