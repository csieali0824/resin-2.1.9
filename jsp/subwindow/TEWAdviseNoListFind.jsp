<!-- 20150122 by Peggy,廣東君耀與君耀為同家公司,可合併-->
<!-- 20151026 by Peggy,已開發票advise不可併新單--> 
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String sql = "";
String TYPE= request.getParameter("TYPE");
if (TYPE==null) TYPE="";
String ADVISENO = request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String SSD = request.getParameter("SSD");
if (SSD==null) SSD="";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEW Advise No List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(ADVISENO,REGION,SHIPPINGMETHOD,VENDOR_SITE_ID,TOTW,SSD)
{
	window.opener.document.MYFORM.ADVISE_NO.value = ADVISENO;
	//window.opener.document.MYFORM.CUSTOMER_ID.value = CUSTOMER;
	window.opener.document.MYFORM.SALESAREA.value = REGION;
	window.opener.document.MYFORM.VENDORFORM.value = VENDOR_SITE_ID;
	window.opener.document.MYFORM.SHIPPINGMETHOD.value = SHIPPINGMETHOD;
	window.opener.document.MYFORM.TOTW.value = TOTW;
	window.opener.document.MYFORM.SHIPDATE.value = SSD;
	//window.opener.document.MYFORM.CURR.value = CURR;
	//window.opener.document.MYFORM.SHIPTO.value = SHIPTO;
	this.window.close();
}
function setSubmit1(lineno)
{
	window.opener.document.MYFORM.MO.value = document.getElementById("divc"+lineno).innerHTML;
	window.opener.document.MYFORM.MOLINE.value = document.getElementById("divd"+lineno).innerHTML;
	window.opener.document.MYFORM.ITEMNAME.value = document.SUBFORM.elements["ITEMNAME"+lineno].value;
	window.opener.document.MYFORM.ITEMDESC.value = document.getElementById("dive"+lineno).innerHTML;
	window.opener.document.MYFORM.CUSTITEM.value = document.getElementById("divf"+lineno).innerHTML;
	window.opener.document.MYFORM.CUSTPO.value = document.getElementById("divg"+lineno).innerHTML;
	window.opener.document.MYFORM.SHIPQTY.value = document.getElementById("divh"+lineno).innerHTML;
	window.opener.document.MYFORM.CARTONLIST.value = document.getElementById("divi"+lineno).innerHTML;
	window.opener.document.MYFORM.VENDOR.value = document.getElementById("divb"+lineno).innerHTML;
	window.opener.document.MYFORM.SO_LINE_ID.value = document.SUBFORM.elements["SO_LINE_ID"+lineno].value;
	window.opener.document.MYFORM.PC_ADVISE_ID.value =  document.SUBFORM.elements["PC_ADVISE_ID"+lineno].value;
	window.opener.document.MYFORM.CARTON_LIST1.value =  document.SUBFORM.elements["CARTON_LIST1_"+lineno].value;
	this.window.close();
}
</script>
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
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<body >  
<FORM METHOD="post" ACTION="TEWAdviseNoListFind.jsp" NAME="SUBFORM">
<table>
<%
if (TYPE.equals("BOX"))
{
%>
	<tr>
		<td>
			<%     
				try
				{ 
					String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
					PreparedStatement pstmt1=con.prepareStatement(sql1);
					pstmt1.executeUpdate(); 
					pstmt1.close();	
								
					sql = " select distinct a.tew_advise_no advise_no"+
						  ",CASE WHEN b.TO_TW='Y' THEN 'TSCT' ELSE a.REGION_CODE END  as REGION_CODE"+
						  ",b.SHIPPING_METHOD"+
						  ",c.vendor_site_id"+
						  ",c.vendor_site_code"+
						  ",b.to_tw"+
						  ",TO_CHAR(a.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SSD"+
					      " from tsc.tsc_shipping_advise_lines a"+
						  ",tsc.tsc_shipping_advise_headers b"+
						  ",ap.ap_supplier_sites_all c"+
                          " where a.advise_header_id = b.advise_header_id"+
						  " and a.vendor_site_id = c.vendor_site_id"+
						  " and b.shipping_from =?"+ 
                          " and exists (select 1 from tsc.TSC_SHIPPING_ADVISE_PC_TEW x "+
						  " where x.shipping_from = b.shipping_from "+
                          " and x.SHIPPING_METHOD=b.SHIPPING_METHOD "+
						  //" and x.VENDOR_SITE_ID=a.VENDOR_SITE_ID"+
						  " and DECODE(x.VENDOR_SITE_ID,311965,102965,x.VENDOR_SITE_ID)=DECODE(a.VENDOR_SITE_ID,311965,102965,a.VENDOR_SITE_ID)"+ //modify by Peggy 20150122,廣東君耀與君耀為同家公司,可合併
						  " and x.TO_TW=b.TO_TW"+
						  " and (CASE WHEN x.TO_TW='Y' THEN 'TSCT' ELSE x.REGION_CODE END =CASE WHEN b.TO_TW='Y' THEN 'TSCT' ELSE a.REGION_CODE END  "+
						  //" or  decode(x.REGION_CODE,'TSCC-SH','TSCH-HK',x.REGION_CODE)=a.REGION_CODE)"+
						  " or  decode(x.REGION_CODE,'TSCC-SH','TSCH-HK',x.REGION_CODE)=decode(a.REGION_CODE,'TSCC-SH','TSCH-HK',a.REGION_CODE))"+ //modify by Peggy 20131127
						  " and x.PC_SCHEDULE_SHIP_DATE = a.PC_SCHEDULE_SHIP_DATE "+
						  " and x.orig_advise_no = ?)"+
						  " and not exists (select 1  from TSC_VENDOR_INVOICE_LINES x where x.TEW_ADVISE_NO=a.tew_advise_no)"+  //add by Peggy 20151026
                          " order by a.tew_advise_no";
					//out.println(sql);
					PreparedStatement statement = con.prepareStatement(sql);
					statement.setString(1,"TEW");
					statement.setString(2,ADVISENO);
					ResultSet rs=statement.executeQuery();
					int vline=0;
					while (rs.next())
					{
						if (vline==0)
						{
							out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
							out.println("<TR bgcolor='#cccccc'><TH style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
							out.println("<TH style='font-size:12px;font-family:arial'>Advise No</TH>");
							//out.println("<TH style='font-size:12px;font-family:arial'>客戶</TH>");
							out.println("<TH style='font-size:12px;font-family:arial'>供應商</TH>");
							out.println("<TH style='font-size:12px;font-family:arial'>業務區</TH>");
							out.println("<TH style='font-size:12px;font-family:arial'>出貨方式</TH>");
							out.println("<TH style='font-size:12px;font-family:arial'>排定出貨日</TH>");
							//out.println("<TH style='font-size:12px;font-family:arial'>幣別</TH>");
							out.println("<TH style='font-size:12px;font-family:arial'>回T</TH>");
							out.println("</TR>");
						}
						out.println("<TR id='tr_"+vline+"'>");
						out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick="+'"'+"setSubmit('"+rs.getString("advise_no")+"','"+rs.getString("REGION_CODE")+"','"+rs.getString("SHIPPING_METHOD")+"','"+rs.getString("vendor_site_id")+"','"+rs.getString("TO_TW")+"','"+rs.getString("SSD").replace("/","")+"');"+'"'+"></TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("advise_no")+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("vendor_site_code")+"</TD>");
						//out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("CUSTOMER_NAME")+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("REGION_CODE")+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("SHIPPING_METHOD")+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("SSD")+"</TD>");
						//out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("CURRENCY_CODE")+"</TD>");
						out.println("<TD style='font-size:12px;font-family:arial'>"+ (rs.getString("TO_TW").equals("Y")?"是":"否")+"</TD>");
						out.println("</TR>");	
						vline++;
					}
					if (vline>0)
					{
						out.println("</TABLE>");	
					}
					else
					{
						out.println("<div><font color='red'>查無符合條件資料</font></div>");
					}
					rs.close();  
					statement.close();    
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				
			%>
		</td>
	</tr>
<%
}
else if (TYPE.equals("RESERVATION"))
{
	try
	{
		sql = " SELECT x.VENDOR_SITE_CODE"+
		      ",x.vendor_site_id"+
			  ",x.shipping_method"+
			  ",x.SHIPPING_REMARK"+
			  ",x.advise_no"+
			  ",x.advise_header_id"+
			  ",x.so_no"+
			  ",x.so_header_id"+
			  ",x.po_no"+
			  ",x.pc_advise_id"+
			  ",x.cust_partno"+
              ",x.so_line_id"+
			  ",x.so_line_number"+
			  ",x.item_no"+
			  ",x.item_desc"+
			  ",x.inventory_item_id"+
			  ",x.pc_schedule_ship_date"+
			  ",x.POST_FIX_CODE"+
			  ",sum(x.SHIP_QTY/1000) SHIP_QTY"+
              ",min(x.carton_num_fr) carton_num_fr"+
			  ",max(x.carton_num_to) carton_num_to"+
			  ",sum(x.TOTAL_QTY) TOTAL_QTY "+
              ",TEW_RCV_PKG.GET_ORDER_CARTON_LIST('ORDER_LINE',x.tew_advise_no,x.so_line_id,'0','0') carton_list"+
              ",TEW_RCV_PKG.GET_ORDER_CARTON_LIST('ORDER_LINE_CARTON_LIST',x.tew_advise_no,x.so_line_id,'0','0') carton_list_1"+
              " FROM (select a.tew_advise_no,c.VENDOR_SITE_CODE ,a.vendor_site_id ,b.shipping_method ,a.SHIPPING_REMARK ,a.tew_advise_no advise_no,b.advise_header_id"+
              "       ,a.advise_line_id,a.so_no,a.so_header_id,a.so_line_id,a.so_line_number,a.item_no,a.item_desc,a.inventory_item_id,to_char(a.pc_schedule_ship_date,'yyyy-mm-dd') pc_schedule_ship_date"+
              "       ,b.POST_FIX_CODE,a.ship_qty,a.carton_num_fr,a.carton_num_to,a.CARTON_PER_QTY CARTON_PER_QTY,a.TOTAL_QTY"+
              "       ,a.po_no,a.pc_advise_id,DECODE (d.item_identifier_type,'CUST', d.ordered_item,'') cust_partno"+
              "       FROM tsc.tsc_shipping_advise_lines a"+
              "       ,tsc.tsc_shipping_advise_headers b"+
              "       ,ap.ap_supplier_sites_all c"+
              "       ,ont.oe_order_lines_all d "+
              "       where  a.tew_advise_no=?"+
              "       and b.SHIPPING_FROM=?"+
              "       and b.advise_header_id = a.advise_header_id "+
              "       and a.vendor_site_id = c.vendor_site_id(+)"+
              "       and a.so_line_id=d.line_id"+
              "       and NOT exists (select 1 from oraddman.tew_lot_allot_detail x where x.advise_line_id = a.advise_line_id)"+
              "       order by a.carton_num_fr,a.carton_num_to,a.advise_line_id ) x "+
              " group by x.VENDOR_SITE_CODE,x.vendor_site_id,x.shipping_method,x.SHIPPING_REMARK,x.advise_no,x.advise_header_id,x.so_no,x.so_header_id,x.pc_advise_id"+
              " ,x.so_line_id,x.so_line_number,x.item_no,x.item_desc,x.inventory_item_id,x.pc_schedule_ship_date,x.POST_FIX_CODE,x.po_no,x.cust_partno"+
              " ORDER BY CARTON_NUM_FR";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ADVISENO);
		statement.setString(2,"TEW");
		ResultSet rs=statement.executeQuery();
		int vline=0;
		while (rs.next())
		{
			if (vline==0)
			{
				out.println("<div>Advise NO:"+ ADVISENO+"</div>");
				out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
				out.println("<TR bgcolor='#cccccc'><TD width='4%'>&nbsp;</TD>");        
				out.println("<TD width='10%'>訂單號碼</TD>");
				out.println("<TD width='6%'>訂單項次</TD>");
				out.println("<TD width='14%'>型號</TD>");
				out.println("<TD width='14%'>客戶品號</TD>");
				out.println("<TD width='20%'>客戶PO</TD>");
				out.println("<TD width='10%'>出貨量(PCE)</TD>");
				out.println("<TD width='12%'>編箱明細</TD>");
				out.println("<TD width='10%'>供應商</TD>");
				out.println("</TR>");
			}
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='text-align:center;font-size:11px;font-family: Tahoma,Georgia;' onclick="+'"'+"setSubmit1("+vline+")"+'"'+"><input type='hidden' name='PC_ADVISE_ID"+vline+"' value='"+rs.getString("PC_ADVISE_ID")+"'><input type='hidden' name='SO_LINE_ID"+vline+"' value='"+rs.getString("SO_LINE_ID")+"'><input type='hidden' name='ITEMNAME"+vline+"' value='"+rs.getString("ITEM_NO")+"'><input type='hidden' name='CARTON_LIST1_"+vline+"' value='"+rs.getString("CARTON_LIST_1")+"'></TD>");
			out.println("<TD><div id='divc"+vline+"'>"+ rs.getString("SO_NO")+"</div></TD>");
			out.println("<TD><div id='divd"+vline+"'>"+ rs.getString("SO_LINE_NUMBER")+"</div></TD>");
			out.println("<TD><div id='dive"+vline+"'>"+ rs.getString("ITEM_DESC")+"</div></TD>");
			out.println("<TD><div id='divf"+vline+"'>"+ rs.getString("CUST_PARTNO")+"</div></TD>");
			out.println("<TD><div id='divg"+vline+"'>"+ rs.getString("PO_NO")+"</div></TD>");
			out.println("<TD align='right'><div id='divh"+vline+"'>"+ rs.getString("TOTAL_QTY")+"</div></TD>");
			out.println("<TD><div id='divi"+vline+"'>"+ rs.getString("CARTON_LIST")+"</div></TD>");
			out.println("<TD><div id='divb"+vline+"'>"+ rs.getString("vendor_site_code")+"</div></TD>");
			out.println("</TR>");
			vline++;
		}
		if (vline>0)
		{
			out.println("</TABLE>");	
		}
		else
		{
			out.println("<div><font color='red'>查無符合條件資料</font></div>");
		}
		rs.close();
		statement.close();
	}
	catch(Exception e)
	{
		out.println("Exception2:"+e.getMessage());
	}
}
else
{
	try
	{ 
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate(); 
		pstmt1.close();	
					
		sql = " select distinct b.advise_no"+
		      //",b.CUSTOMER_ID CUSTOMER"+
			  ",b.REGION_CODE"+
			  ",b.SHIPPING_METHOD"+
			  ",c.vendor_site_id"+
			  ",c.vendor_site_code"+
			  ",b.to_tw"+
			  ",TO_CHAR(b.PC_SCHEDULE_SHIP_DATE,'yyyy/mm/dd') SSD"+
			  //",b.CURRENCY_CODE"+
			  //",ra.CUSTOMER_NAME_PHONETIC CUSTOMER_NAME"+
			  //",b.SHIP_TO_ORG_ID"+
			  " from tsc.tsc_shipping_advise_pc_tew b,ap.ap_supplier_sites_all c"+
			  //", AR_CUSTOMERS ra"+
			  " where b.vendor_site_id = c.vendor_site_id"+
			  //" and b.CUSTOMER_ID = ra.CUSTOMER_ID"+
			  " and b.shipping_from =?"+ 
			  " and not exists (select 1 from tsc.TSC_SHIPPING_ADVISE_HEADERS x where x.advise_no = b.advise_no)"+
			  " and b.PC_SCHEDULE_SHIP_DATE=TO_DATE(?,'yyyymmdd')"+
			  " and b.advise_no is not null"+
			  " order by b.advise_no";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"TEW");
		statement.setString(2,SSD);
		ResultSet rs=statement.executeQuery();
		int vline=0;
		while (rs.next())
		{
			if (vline==0)
			{
				out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
				out.println("<TR bgcolor='#cccccc'><TH width='5%' style='font-size:12px;font-family:arial'>&nbsp;</TH>");        
				out.println("<TH width='15%' style='font-size:12px;font-family:arial'>Advise No</TH>");
				out.println("<TH width='15%' style='font-size:12px;font-family:arial'>供應商</TH>");
				//out.println("<TH width='20%' style='font-size:12px;font-family:arial'>客戶</TH>");
				out.println("<TH width='10%' style='font-size:12px;font-family:arial'>業務區</TH>");
				out.println("<TH width='10%' style='font-size:12px;font-family:arial'>出貨方式</TH>");
				out.println("<TH width='10%' style='font-size:12px;font-family:arial'>排定出貨日</TH>");
				//out.println("<TH width='10%' style='font-size:12px;font-family:arial'>幣別</TH>");
				out.println("<TH width='10%' style='font-size:12px;font-family:arial'>回T</TH>");
				out.println("</TR>");
			}
			out.println("<TR id='tr_"+vline+"'>");
			out.println("<TD><input type='button' name='Set"+vline+"' value='SET' style='font-size:12px;font-family:arial' onclick="+'"'+"setSubmit('"+rs.getString("advise_no")+"','"+rs.getString("REGION_CODE")+"','"+rs.getString("SHIPPING_METHOD")+"','"+rs.getString("vendor_site_id")+"','"+rs.getString("TO_TW")+"','"+rs.getString("SSD").replace("/","")+"');"+'"'+"></TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("advise_no")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("vendor_site_code")+"</TD>");
			//out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("CUSTOMER_NAME")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("REGION_CODE")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("SHIPPING_METHOD")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("SSD")+"</TD>");
			//out.println("<TD style='font-size:12px;font-family:arial'>"+ rs.getString("CURRENCY_CODE")+"</TD>");
			out.println("<TD style='font-size:12px;font-family:arial'>"+ (rs.getString("TO_TW").equals("Y")?"是":"否")+"</TD>");
			out.println("</TR>");
			vline++;
		}
		if (vline>0)
		{
			out.println("</TABLE>");	
		}
		else
		{
			out.println("<div><font color='red'>查無符合條件資料</font></div>");
		}
		rs.close();  
		statement.close();     
	}
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}
}
%>
</table>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
