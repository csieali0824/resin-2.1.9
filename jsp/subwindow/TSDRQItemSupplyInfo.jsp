<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="StockInfoBean" scope="session" class="Array2DimensionInputBean"/>
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
</STYLE>
<title>SG Item Supply Info</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{ 
	if (event.clientY < 0)  
	{
		alert("Please use the submit or exit button to close this page!");
		return false;
	}
}

function setClick(irow)
{
	if (document.SUBFORM.chkbox.length != undefined)
	{
		if (document.SUBFORM.chkbox[irow].checked)
		{
			for (var i =0 ; i < document.SUBFORM.chkbox.length ;i++)
			{
				if (i!=irow)
				{
					document.SUBFORM.chkbox[i].checked= false;
				}
			}
		}		
	}
}
function setSubmit1()
{
	var iLen=0;
	var chkvalue = false;
	var line="";
	var chkline="";
	var chkcnt=0;
	var rec_year="",rec_month="",rec_day=""
	if (document.SUBFORM.chkbox.length != undefined)
	{
		iLen = document.SUBFORM.chkbox.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.SUBFORM.chkbox.checked;
			chkline = document.SUBFORM.chkbox.value;
		}
		else
		{
			chkvalue = document.SUBFORM.chkbox[i-1].checked;
			chkline = document.SUBFORM.chkbox[i-1].value;
		}
		if (chkvalue==true)
		{
			if (chkline =="PRPO")
			{
				if (document.SUBFORM.SUPPLIERS.value=="--"||document.SUBFORM.SUPPLIERS.value=="")
				{
					alert("Please choose a supplier!");
					document.SUBFORM.SUPPLIERS.focus();
					return false;
				}
				else if (document.SUBFORM.SUPPLYDATE.value=="")
				{
					alert("Please enter a supply date!");
					document.SUBFORM.SUPPLYDATE.focus();
					return false;
				}
				else
				{
					rec_year = document.SUBFORM.SUPPLYDATE.value.substr(0,4);
					rec_month= document.SUBFORM.SUPPLYDATE.value.substr(4,2);
					rec_day  = document.SUBFORM.SUPPLYDATE.value.substr(6,2);
					if (rec_month <1 || rec_month >12)
					{
						alert("The month value error!!");
						document.SUBFORM.SUPPLYDATE.style.bgcolor="#ff0000";
						document.SUBFORM.SUPPLYDATE.focus();
						return false;			
					}	
					else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
					{
						alert("The supply date error!!");
						document.SUBFORM.SUPPLYDATE.style.bgcolor="#ff0000";
						document.SUBFORM.SUPPLYDATE.focus();
						return false;			
					} 
					else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
					{
						alert("The supply date error!!");
						document.SUBFORM.SUPPLYDATE.style.bgcolor="#ff0000";
						document.SUBFORM.SUPPLYDATE.focus();
						return false;			
					} 
					else if (rec_month == 2)
					{
						if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
						{
							alert("The supply date error!!");
							document.SUBFORM.SUPPLYDATE.style.bgcolor="#ff0000";
							document.SUBFORM.SUPPLYDATE.focus();
							return false;	
						}		
					}
					
				}
			}
			chkcnt++;
		}
	}
	if (chkcnt==0)
	{
		alert("Please choose Supply Item!!");
		return false;
	}
	document.SUBFORM.submit1.disabled= true;
	document.SUBFORM.exit1.disabled= true;
	window.opener.document.DISPLAYREPAIR.elements["SUPPLY_SOURCE_"+document.SUBFORM.LINENO.value].value="chkline";
	document.SUBFORM.action="TSDRQItemSupplyInfo.jsp?ACODE=SAVE";
	document.SUBFORM.submit();	
}
function setClose()
{
	window.close();				
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
	{ 
		return true; 
	}  
	return false; 
} 
</script>
<body>  
<FORM METHOD="post" ACTION="TSDRQItemSupplyInfo.jsp" NAME="SUBFORM">
<%
String sql = "",v_checked="";
String ITEM_ID = request.getParameter("ITEMID");
if (ITEM_ID==null) ITEM_ID="0";
String REQUEST_DATE = request.getParameter("REQDATE");
if (REQUEST_DATE==null) REQUEST_DATE="";
String REQUEST_QTY = request.getParameter("REQQTY");
if (REQUEST_QTY==null) REQUEST_QTY="";
String SUPPLIERS = request.getParameter("SUPPLIERS");
if (SUPPLIERS==null) SUPPLIERS="";
String SUPPLYDATE = request.getParameter("SUPPLYDATE");
if (SUPPLYDATE==null) SUPPLYDATE="";
String ITEM_NAME = "",ITEM_DESC="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String DNDOCNO = request.getParameter("DNDOCNO");
if (DNDOCNO==null) DNDOCNO="";
String LINENO=request.getParameter("LINENO");
if (LINENO==null) LINENO="";
String ORDERTYPE=request.getParameter("ORDERTYPE");
if (ORDERTYPE==null) ORDERTYPE="";
String PGCODE=request.getParameter("PGCODE");
if (PGCODE==null) PGCODE="";
String v_typename="";
double allot_qty =0;
String ORG_ID="";
int icnt=0;

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

PreparedStatement statementx = con.prepareStatement("select msi.segment1,msi.description,msi.organization_id from inv.mtl_system_items_b msi,inv.mtl_parameters mp where msi.inventory_item_id=? and msi.organization_id=mp.organization_id and mp.organization_code =case when substr('"+ORDERTYPE+"',1,1) in ('8') then 'SG1' else 'SG2' end");
statementx.setString(1,ITEM_ID);
ResultSet rsx = statementx.executeQuery();	
if (rsx.next())
{
	ITEM_NAME = rsx.getString("segment1");
	ITEM_DESC = rsx.getString("description");
	ORG_ID = rsx.getString("organization_id");
}
rsx.close();
statementx.close();
if (!ACODE.equals("SAVE"))
{
	try
	{
%>
		<table width="100%" border="0">
			<tr>
				<td width="15%"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></td>
				<td width="35%"><%=ITEM_NAME%></td>
				<td width="15%"><jsp:getProperty name="rPH" property="pgQty"/></td>
				<td width="35%"><%=REQUEST_QTY%>&nbsp;&nbsp;KPC</td>
			</tr>
			<tr>
				<td><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/></td>
				<td><%=ITEM_DESC%></td>
				<td><jsp:getProperty name="rPH" property="pgRequestDate"/></td>
				<td><%=REQUEST_DATE%></td>
			</tr>
			<tr>
				<td colspan="4">
					<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
	
<%
		String stockArray[][]=StockInfoBean.getArray2DContent();
			
		sql = " select rownum"+
			  //",count(1) over (partition by pu.inventory_item_id order by  pu.inventory_item_id) tot_cnt"+
			  //",row_number() over (partition by flv.meaning order by  flv.meaning,to_char(pu.need_by_date,'yyyymmdd')) group_seq"+
			  //",count(1) over (partition by flv.meaning order by  flv.meaning) group_tot"+
              ",count(1) over (partition by pu.inventory_item_id, flv.meaning ) tot_cnt"+
              ",row_number() over (partition by  pu.inventory_item_id, flv.meaning order by to_char(pu.need_by_date,'yyyymmdd')) group_seq"+
              ",count(1) over (partition by pu.inventory_item_id,flv.meaning order by pu.inventory_item_id,flv.meaning) group_tot"+
			  ",asp.vendor_name"+
			  ",assa.vendor_site_code"+
			  ",flv.meaning type_name"+
			  ",ph.segment1 po_num"+
			  ",pl.line_num"+
			  ",pll.shipment_num"+
			  ",i.segment1 item_num"+
			  ",i.description item_desc"+
			  ",(pu.quantity-nvl(rfq_allocated_quantity,0)) quantity"+
			  ",to_char(pu.need_by_date,'yyyymmdd') need_by_date"+
			  ",rfq_allocated_quantity"+
			  ",po_unallocated_id"+
			  ",i.organization_id"+
			  ",nvl(pll.note_to_receiver,'') note_to_receiver "+
              //",NVL(TRIM(REPLACE(REPLACE(CASE INSTR(pl.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN pl.NOTE_TO_VENDOR ELSE SUBSTR(pl.NOTE_TO_VENDOR,1,INSTR(pl.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
              ",NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(pl.NOTE_TO_VENDOR)"+  //modify by Peggy 20230607
              "    ,CASE WHEN pll.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
              "     FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
              "     WHERE x.org_id= CASE WHEN SUBSTR(pll.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
              "     AND x.header_id=y.header_id"+
              "     AND y.packing_instructions='T'"+
              "     AND x.order_number= SUBSTR(pll.NOTE_TO_RECEIVER,1,INSTR(pll.NOTE_TO_RECEIVER,'.')-1)"+
              "     AND y.shipment_number=1 and y.line_number=SUBSTR(pll.NOTE_TO_RECEIVER,INSTR(pll.NOTE_TO_RECEIVER,'.')+1))"+
              "     ELSE '' END) cust_partno"+	//add by Peggy 20200619
			  ",sum(pu.QUANTITY) over (partition by pu.inventory_item_id,pu.organization_id) tot_qty"+ //add by Peggy 20200717		  
			  " from tsc_po_unallocated pu"+
			  ",fnd_lookup_values_vl flv"+
			  ",mtl_system_items_b i"+
			  ",po_line_locations_all pll"+
			  ",po_lines_all pl"+
			  ",po_headers_all ph"+
			  ",ap_supplier_sites_all assa"+
			  ",ap_suppliers asp"+
			  " where to_char(pu.type_id) = flv.lookup_code"+
			  " and flv.lookup_type = 'TSC_OM_PLAN_TYPE'"+
			  " and pu.organization_id = i.organization_id"+
			  " and pu.inventory_item_id = i.inventory_item_id"+
			  " and pu.po_line_location_id = pll.line_location_id(+)"+
			  " and pll.po_line_id = pl.po_line_id(+)"+
			  " and pll.po_header_id = ph.po_header_id(+)"+
			  " and ph.vendor_site_id=assa.vendor_site_id(+)"+
			  " and assa.vendor_id=asp.vendor_id(+)"+
			  " and pu.quantity-nvl(rfq_allocated_quantity,0) >0"+
			  " and pu.inventory_item_id=?"+
			  " and pu.organization_id =?";
		//if (PGCODE.equals("D1003")) //20200618開會決議,CY可以看全部
		//{
		//	sql += " and pu.type_id=3"; //第一關PC只看庫存
		//}
		sql += " order by  decode(flv.meaning,'On-hand',1,2),3,14";
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ITEM_ID);
		statement.setString(2,ORG_ID);
		ResultSet rs = statement.executeQuery();	
		while (rs.next())
		{
			if (!v_typename.equals(rs.getString("TYPE_NAME")))
			{
				v_typename=rs.getString("TYPE_NAME");
				allot_qty=rs.getInt("quantity");
			}
			else
			{
				if (allot_qty<0)
				{
					allot_qty=rs.getInt("quantity")+(allot_qty);
				}
				else
				{ 
					allot_qty=rs.getInt("quantity");
				}
			}
			
			if (rs.getString("TYPE_NAME").equals("On-hand"))
			{
				if (rs.getInt("group_seq")==1)
				{
					v_checked="";
					if (stockArray!=null)
					{	
						for( int i=0 ; i<stockArray.length ; i++ ) 
						{
							if (DNDOCNO.equals(stockArray[i][0]) && LINENO.equals(stockArray[i][1]))
							{
								if (stockArray[i][2].toUpperCase().equals("Y"))	v_checked="checked";
								break;
							}
						}
						
						for( int j=0 ; j<stockArray.length ; j++ ) 
						{
							if (ITEM_ID.equals(stockArray[j][7]) && stockArray[j][2].equals("Y"))
							{
								if (!DNDOCNO.equals(stockArray[j][0]) || !LINENO.equals(stockArray[j][1]))
								{
									allot_qty -= Float.parseFloat(stockArray[j][9]);
								}
							}
						}						
					}
	%>
					<tr>
						<td width="5%"><input type="checkbox" name="chkbox" value="STOCK" onClick="setClick(<%=icnt%>)" <%=v_checked%>></td>
						<td width="15%'">On Hand</td>
						<td width="80%">
							<table width="100%" border="0">
								<tr bgcolor="#66CC99">
									<td style="border-bottom-style:double">Subinventory</td>
									<td style="border-bottom-style:double">Qty(K)</td>
								</tr>
	<%
				}
	%>
								<tr>
									<td>01</td>
									<td <%=((allot_qty/1000)>=Float.parseFloat(REQUEST_QTY)? "style='color:#0000ff;font-weight:bold'":"style='color:#ff0000;font-weight:bold'")%>><%=(allot_qty/1000)%></td>
								</tr>
	<%
				if (rs.getInt("group_seq")==rs.getInt("group_tot"))
				{
		%>
							</table>
						</td>
					</tr>
		<%
				}
			}
			else
			{
				if (rs.getInt("group_seq")==1)
				{	
					v_checked="";
					if (stockArray!=null)
					{	
						for( int i=0 ; i<stockArray.length ; i++ ) 
						{
							if (DNDOCNO.equals(stockArray[i][0]) && LINENO.equals(stockArray[i][1]))
							{
								if (stockArray[i][3].toUpperCase().equals("Y"))	v_checked="checked";
								break;
							}
						}
						
						for( int j=0 ; j<stockArray.length ; j++ ) 
						{
							if (ITEM_ID.equals(stockArray[j][7]) && stockArray[j][3].equals("Y"))
							{
								if (!DNDOCNO.equals(stockArray[j][0]) || !LINENO.equals(stockArray[j][1]))
								{
									allot_qty -= Float.parseFloat(stockArray[j][9]);
								}
							}
						}						
					}			
		%>
					<tr>
						<td width="5%"><input type="checkbox" name="chkbox" value="PO" onClick="setClick(<%=icnt%>)" <%=v_checked%>></td>
						<td width="15%'">Open PO</td>
						<td width="80%">
							<table width="100%" border="0">
								<tr bgcolor="#66CC99">
									<td style="border-bottom-style:double">PO#</td>
									<td style="border-bottom-style:double">PO Line#</td>
									<td style="border-bottom-style:double">MO#</td>
									<td style="border-bottom-style:double">Cust Part No</td>
									<td style="border-bottom-style:double">Supplier</td>
									<td style="border-bottom-style:double">Need by Date</td>
									<td style="border-bottom-style:double">Qty(K)</td>
								</tr>
	<%
				}
				if (allot_qty >0)
				{
	%>							
								<tr>
									<td><%=rs.getString("PO_NUM")%></td>
									<td><%=rs.getString("LINE_NUM")%></td>
									<td><%=(rs.getString("note_to_receiver")==null?"":"("+rs.getString("note_to_receiver")+")")%></td>
									<td><%=(rs.getString("cust_partno")==null?"N/A":rs.getString("cust_partno"))%></td>
									<td><%=rs.getString("VENDOR_SITE_CODE")%></td>
									<td <%=(rs.getFloat("NEED_BY_DATE")<Float.parseFloat(REQUEST_DATE)? "style='color:#0000ff;font-weight:bold'":"style='color:#ff0000;font-weight:bold'")%>><%=rs.getString("NEED_BY_DATE")%></td>
									<td <%=((allot_qty/1000)>=Float.parseFloat(REQUEST_QTY)? "style='color:#0000ff;font-weight:bold'":"style='color:#ff0000;font-weight:bold'")%> align="right"><%=(allot_qty/1000)%></td>
								</tr>
		<%
				}
				if (rs.getInt("group_seq")==rs.getInt("group_tot"))
				{
		%>						<tr><td colspan="5"></td><td style="border-top-color:#333333;border-top-style:solid;">Totoal:</td><td align="right" style="font-weight:bold;border-top-color:#333333;border-top-style:solid;"><%=rs.getFloat("tot_qty")/1000%></td></tr>
							</table>
						</td>
					</tr>
	<%
				}
			}
			icnt++;
		}
		rs.close();
		statement.close();
	
		/*v_checked="";
		if (stockArray!=null)
		{	
			for( int i=0 ; i<stockArray.length ; i++ ) 
			{
				if (DNDOCNO.equals(stockArray[i][0]) && LINENO.equals(stockArray[i][1]))
				{
					if (stockArray[i][4].toUpperCase().equals("Y"))
					{
						v_checked="checked";
						SUPPLIERS=stockArray[i][5];
						SUPPLYDATE=stockArray[i][6];
					}
					break;
				}
			}
		}
		if (icnt==0) v_checked="checked";*/	
			
			if (icnt==0)
			{
			%>
				<tr><td style="color:#ff0000">No Data Found!</td></tr>
			<%
			}
			%>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center"><input type="button" name="submit1" value="Submit" style="font-family:Tahoma,Georgia" onClick="window.document.body.onbeforeunload=null;setSubmit1()" <%=(icnt==0?"disabled":"")%>>
		&nbsp;&nbsp;
		<input type="button" name="exit1" value="Exit" style="font-family:Tahoma,Georgia" onClick="window.document.body.onbeforeunload=null;setClose()">
		</td>
	</tr>
</table>
<%  
	}
	catch(Exception e)
	{
		out.println("<font color='red'>Error:"+e.getMessage()+"</font>");
	}
}
else
{
	try
	{
		int tot_row  =0;
		String chk[]= request.getParameterValues("chkbox");
		String stockArray [][]=StockInfoBean.getArray2DContent();
		int iLine=0;
		String VendorSiteId="";
		if (stockArray!=null)
		{
			for( int i=0 ; i< stockArray.length ; i++ ) 
			{
				if (stockArray[i][0]!=null && stockArray[i][1]!=null && stockArray[i][0].equals(DNDOCNO) && stockArray[i][1].equals(LINENO))
				{
					tot_row -=1; 
					iLine=i;
					break;
				}
			}
			tot_row = stockArray.length+1;
			iLine=tot_row-1;
		}
		else
		{
			tot_row = 1;
			iLine=0;
		}
		String stock_tot [][] = new String [tot_row][10];
		stock_tot[iLine][0] = DNDOCNO;
		stock_tot[iLine][1] = LINENO;
		stock_tot[iLine][2] = "";
		stock_tot[iLine][3] = "";
		stock_tot[iLine][4] = "";
		stock_tot[iLine][5] = "";
		stock_tot[iLine][6] = "";
		stock_tot[iLine][7] = ITEM_ID;
		stock_tot[iLine][8] = ORG_ID;
		stock_tot[iLine][9] = ""+(Float.parseFloat(REQUEST_QTY)*1000);
		for (int i = 0 ; i < chk.length ; i++)
		{
			if (chk[i].equals("STOCK"))
			{
				stock_tot[iLine][2] = "Y";
			}
			else if (chk[i].equals("PO"))
			{
				stock_tot[iLine][3] = "Y";
			}
			else if (chk[i].equals("PRPO"))
			{
				stock_tot[iLine][4] = "Y";
				stock_tot[iLine][5] = request.getParameter("SUPPLIERS");
				stock_tot[iLine][6] = request.getParameter("SUPPLYDATE");
				VendorSiteId=stock_tot[iLine][5];
			}
		} 
		if (stockArray!=null)
		{
			for( int i=0 ; i< stockArray.length ; i++ ) 
			{
				if (stockArray[i][0]!=null && stockArray[i][1]!=null && stockArray[i][0].equals(DNDOCNO) && stockArray[i][1].equals(LINENO)) continue;
				stock_tot[i][0] = stockArray[i][0];
				stock_tot[i][1] = stockArray[i][1];
				stock_tot[i][2] = stockArray[i][2];
				stock_tot[i][3] = stockArray[i][3];
				stock_tot[i][4] = stockArray[i][4];
				stock_tot[i][5] = stockArray[i][5];
				stock_tot[i][6] = stockArray[i][6];
				stock_tot[i][7] = stockArray[i][7];
				stock_tot[i][8] = stockArray[i][8];
				stock_tot[i][9] = stockArray[i][9];
			}
		}
		StockInfoBean.setArray2DString(stock_tot);
%>
		<script language="JavaScript" type="text/JavaScript">
			setClose();
		</script>
<%			
	}
	catch(Exception e)
	{
		out.println("<font color='red'>"+e.getMessage()+"</font>");
	}
}
%>
<INPUT TYPE="hidden" name="ITEMID" value="<%=ITEM_ID%>">
<INPUT TYPE="hidden" name="REQDATE" value="<%=REQUEST_DATE%>">
<INPUT TYPE="hidden" name="REQQTY" value="<%=REQUEST_QTY%>">
<INPUT TYPE="hidden" name="DNDOCNO" value="<%=DNDOCNO%>">
<INPUT TYPE="hidden" name="LINENO" value="<%=LINENO%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
