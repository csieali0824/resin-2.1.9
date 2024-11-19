<!-- 20151119 Peggy,for同一lot d/c不同,畫面增加datecode欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setCancel()
{
	document.MYFORM.action="../jsp/TEWLotReservationQuery.jsp";
 	document.MYFORM.submit();
}
function setClear()
{
	document.MYFORM.ADVISENO.value ="";
	document.MYFORM.SO_LINE_ID.value ="";
	document.MYFORM.MO.value ="";
	document.MYFORM.MOLINE.value ="";
	document.MYFORM.ITEMNAME.value ="";
	document.MYFORM.ITEMDESC.value ="";
	document.MYFORM.CUSTITEM.value ="";
	document.MYFORM.PC_ADVISE_ID.value ="";
	document.MYFORM.CUSTPO.value ="";
	document.MYFORM.SHIPQTY.value ="";
	document.MYFORM.CARTONLIST.value ="";
	document.MYFORM.RESERVE_LOT.value ="";
	document.MYFORM.RESERVE_DC.value ="";  //add by Peggy 20151119
	document.MYFORM.RESERVE_SCARTON.value ="";
	document.MYFORM.RESERVE_ECARTON.value ="";
	document.MYFORM.RESERVE_QTY.value ="";
	document.MYFORM.VENDOR.value ="";
	document.MYFORM.CARTON_LIST1.value ="";
}
function setSubmit(URL)
{ 
	if (document.MYFORM.ADVISENO.value==null || document.MYFORM.ADVISENO.value=="")
	{
		alert("請輸入ADVISE NO!"); 
		document.MYFORM.ADVISENO.focus();
		return false;	
	}
	if (document.MYFORM.RESERVE_SCARTON.value==null || document.MYFORM.RESERVE_SCARTON.value=="")
	{
		alert("請輸入箱號!"); 
		document.MYFORM.RESERVE_SCARTON.focus();
		return false;	
	}
	if (document.MYFORM.RESERVE_ECARTON.value==null || document.MYFORM.RESERVE_ECARTON.value=="")
	{
		alert("請輸入箱號!"); 
		document.MYFORM.RESERVE_ECARTON.focus();
		return false;	
	}
	if ( eval(document.MYFORM.RESERVE_SCARTON.value)>eval(document.MYFORM.RESERVE_ECARTON.value))
	{
		alert("箱號錯誤!"); 
		document.MYFORM.RESERVE_SCARTON.focus();
		return false;		
	}
	else
	{
		for (var i = eval(document.MYFORM.RESERVE_SCARTON.value) ; i <= eval(document.MYFORM.RESERVE_ECARTON.value);i ++)
		{
			if ((","+document.MYFORM.CARTON_LIST1.value+",").indexOf(","+i+",")==-1)
			{
				alert("箱號錯誤!"); 
				return false;	
			}
		}
	}
	if (document.MYFORM.RESERVE_LOT.value==null || document.MYFORM.RESERVE_LOT.value=="")
	{
		alert("請輸入批號!"); 
		document.MYFORM.RESERVE_LOT.focus();
		return false;	
	}
	if (document.MYFORM.RESERVE_QTY.value==null || document.MYFORM.RESERVE_QTY.value=="")
	{
		alert("請輸入數量!"); 
		document.MYFORM.RESERVE_QTY.focus();
		return false;	
	}
	else if (eval(document.MYFORM.RESERVE_QTY.value)<=0)
	{
		alert("請輸入數量!"); 
		document.MYFORM.RESERVE_QTY.focus();
		return false;		
	}
	else if (eval(document.MYFORM.RESERVE_QTY.value)>eval(document.MYFORM.SHIPQTY.value))
	{
		alert("預約數量不可大於出貨數量!"); 
		document.MYFORM.RESERVE_QTY.focus();
		return false;		
	}
	document.MYFORM.btnSubmit.disabled =true;
	document.MYFORM.btnCancel.disabled =true;
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function chooseMOinfo()
{
	if (document.MYFORM.ADVISENO.value==null || document.MYFORM.ADVISENO.value=="")
	{
		alert("請輸入ADVISE NO!"); 
		document.MYFORM.ADVISENO.focus();
		return false;	
	}
	subWin=window.open("../jsp/subwindow/TEWAdviseNoListFind.jsp?TYPE=RESERVATION&ADVISENO="+document.MYFORM.ADVISENO.value,"subwin","width=900,height=500,scrollbars=yes,menubar=no");  
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>TEW Reservation Lot</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TEWLotReservation.jsp" METHOD="POST"> 
<%
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String ADVISENO=request.getParameter("ADVISENO");
if (ADVISENO==null) ADVISENO="";
String SO_LINE_ID=request.getParameter("SO_LINE_ID");
if (SO_LINE_ID==null) SO_LINE_ID="";
String MO=request.getParameter("MO");
if (MO==null) MO="";
String MOLINE=request.getParameter("MOLINE");
if (MOLINE==null) MOLINE="";
String ITEMNAME=request.getParameter("ITEMNAME");
if (ITEMNAME==null) ITEMNAME="";
String ITEMDESC=request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUSTITEM=request.getParameter("CUSTITEM");
if (CUSTITEM==null) CUSTITEM="";
String PC_ADVISE_ID = request.getParameter("PC_ADVISE_ID");
if (PC_ADVISE_ID==null) PC_ADVISE_ID="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO==null) CUSTPO="";
String SHIPQTY = request.getParameter("SHIPQTY");
if (SHIPQTY==null) SHIPQTY="";
String CARTONLIST = request.getParameter("CARTONLIST");
if (CARTONLIST==null) CARTONLIST="";
String RESERVE_LOT = request.getParameter("RESERVE_LOT");
if (RESERVE_LOT==null) RESERVE_LOT="";
String RESERVE_DC = request.getParameter("RESERVE_DC");  //add by Peggy 20151119
if (RESERVE_DC==null) RESERVE_DC="";
String RESERVE_SCARTON = request.getParameter("RESERVE_SCARTON");
if (RESERVE_SCARTON==null) RESERVE_SCARTON="";
String RESERVE_ECARTON = request.getParameter("RESERVE_ECARTON");
if (RESERVE_ECARTON==null) RESERVE_ECARTON="";
String RESERVE_QTY = request.getParameter("RESERVE_QTY");
if (RESERVE_QTY==null) RESERVE_QTY="";
String VENDOR = request.getParameter("VENDOR");
if (VENDOR==null) VENDOR="";
String CARTON_LIST1 = request.getParameter("CARTON_LIST1");
if (CARTON_LIST1==null) CARTON_LIST1="";
String sql ="",ADVISE_LINE_ID="",SEQ_ID="",strmsg="";
long CARTON_PER_QTY=0,ALLOT_QTY=0,BOOK_QTY=0;
int icnt=0;
try
{
	if (ACODE.equals("SAVE"))
	{
		BOOK_QTY=Long.parseLong(RESERVE_QTY);
		for (int i = Integer.parseInt(RESERVE_SCARTON) ; i <= Integer.parseInt(RESERVE_ECARTON) ; i++)
		{
			icnt=0;
			if (BOOK_QTY<=0) break;
			sql = " select y.advise_line_id"+
			      ",y.CARTON_PER_QTY"+
			      ",y.pc_advise_id"+
				  ",y.PO_HEADER_ID"+
				  ",y.inventory_item_id"+
				  ",y.PO_UNIT_PRICE"+
				  ",y.CUST_PARTNO"+
				  ",y.ORDER_QTY"+
				  ",x.lot_number"+
				  ",x.DATE_CODE"+
                  ",x.seq_id"+
                  ",x.onhand"+
				  " from (select pla.po_header_id,pla.item_id,trd.PO_LINE_LOCATION_ID,trd.LOT_NUMBER,trd.DATE_CODE,trd.seq_id"+
				  " ,(nvl(trd.RECEIVED_QUANTITY,0)*1000)-(nvl(trd.SHIPPED_QUANTITY,0)*1000)-nvl(tew_rcv_pkg.get_lot_allot_qty(trd.seq_id),0) onhand"+
				  " ,nvl(odr.cust_partno,pla.note_to_vendor) cust_partno,pll.price_override PO_UNIT_PRICE"+
				  " from oraddman.tewpo_receive_detail trd,"+
				  " po.po_line_locations_all pll,"+
				  " po.po_lines_all pla,"+
				  " (SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
				  "              FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
				  "              WHERE a.header_id = b.header_id) WHERE seqno = 1) odr "+
				  " where trd.LOT_NUMBER=?"+
				  " and trd.DATE_CODE LIKE ?"+
				  " and trd.PO_LINE_LOCATION_ID=pll.LINE_LOCATION_ID"+
				  " and pll.PO_LINE_ID=pla.PO_LINE_ID"+
				  " and SUBSTR (pll.note_to_receiver,1, INSTR (pll.note_to_receiver, '.') - 1) = odr.order_number(+)"+
				  " and SUBSTR (pll.note_to_receiver,INSTR (pll.note_to_receiver, '.') + 1,LENGTH (pll.note_to_receiver)) = odr.line_number(+)) x,"+
                  " (select m.advise_line_id,m.CARTON_PER_QTY-NVL((select sum(decode(RESERVATION_UOM,'KPC',RESERVATION_QTY*1000,RESERVATION_QTY)) from oraddman.tew_lot_reservation_detail r where "+
                  " r.advise_line_id=m.advise_line_id and r.carton_num=?),0) CARTON_PER_QTY ,n.PC_ADVISE_ID,n.po_header_id, n.po_unit_price, n.order_qty-"+
                  " NVL((select sum(decode(RESERVATION_UOM,'KPC',RESERVATION_QTY*1000,RESERVATION_QTY)) from oraddman.tew_lot_reservation_detail r where "+
                  " r.PO_HEADER_ID=n.PO_HEADER_ID and r.advise_line_id=m.advise_line_id and r.carton_num=?),0) order_qty,"+
                  " n.cust_partno, n.inventory_item_id  from tsc.tsc_shipping_advise_lines m,tsc.tsc_shipping_po_price n  "+
                  " where m.pc_advise_id=?  and  ? between m.carton_num_fr and m.carton_num_to"+
                  " and m.pc_advise_id=n.pc_advise_id) y"+
				  " where x.po_header_id=y.po_header_id"+
				  " and x.item_id=y.inventory_item_id"+
				  " and NVL(x.CUST_PARTNO,'N/A')=y.CUST_PARTNO"+
				  " and x.PO_UNIT_PRICE=y.PO_UNIT_PRICE ";
				  //" group by y.advise_line_id,y.CARTON_PER_QTY,y.pc_advise_id,y.PO_HEADER_ID,y.inventory_item_id,y.PO_UNIT_PRICE,y.CUST_PARTNO,y.ORDER_QTY,x.lot_number,x.DATE_CODE";
			//out.println(sql);	
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,RESERVE_LOT);
			statement.setString(2,(RESERVE_DC.equals("")?"%":RESERVE_DC));
			statement.setInt(3,i);
			statement.setInt(4,i);
			statement.setString(5,PC_ADVISE_ID);
			statement.setInt(6,i);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				if (rs.getLong("onhand")==0) continue;
				if (icnt==0)
				{
					ADVISE_LINE_ID=rs.getString("advise_line_id");
					CARTON_PER_QTY=rs.getLong("CARTON_PER_QTY");
					if (CARTON_PER_QTY <=0) throw new Exception("第"+i+"箱可預約分配量不足!!");
					if (BOOK_QTY<CARTON_PER_QTY) CARTON_PER_QTY=BOOK_QTY;
				}
				SEQ_ID=rs.getString("seq_id"); 
				ALLOT_QTY = (rs.getLong("onhand") > CARTON_PER_QTY?CARTON_PER_QTY:rs.getLong("onhand")); 
				ALLOT_QTY = (ALLOT_QTY > rs.getLong("ORDER_QTY")?rs.getLong("ORDER_QTY"):ALLOT_QTY );
				if (ALLOT_QTY<=0) break;
				CARTON_PER_QTY=CARTON_PER_QTY-ALLOT_QTY;
				BOOK_QTY=BOOK_QTY-ALLOT_QTY;
				
				sql = " select 1 from oraddman.tew_lot_reservation_detail a"+
				      " where a.advise_line_id=?"+
					  " and a.carton_num=?"+
					  " and a.seq_id=?";
				PreparedStatement statement2 = con.prepareStatement(sql);
				statement2.setString(1,ADVISE_LINE_ID);
				statement2.setInt(2,i);
				statement2.setString(3,SEQ_ID);
				ResultSet rs2=statement2.executeQuery();
				if (rs2.next())
				{
					sql = " update oraddman.tew_lot_reservation_detail a"+
					      " set reservation_qty=reservation_qty+(?/1000)"+
						  " where advise_line_id=?"+
						  " and a.carton_num=?"+
					      " and a.seq_id=?"; 
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,""+ALLOT_QTY); 
					pstmtDt.setString(2,ADVISE_LINE_ID);
					pstmtDt.setInt(3,i); 
					pstmtDt.setString(4,SEQ_ID);
					pstmtDt.executeQuery();
					pstmtDt.close();
					//out.println(sql);
						  
				}
				else
				{  
					sql = " INSERT INTO oraddman.tew_lot_reservation_detail("+
						  " reservation_id"+
						  ",so_no"+
						  ",so_header_id"+
						  ",so_line_id"+
						  ",po_no"+
						  ",po_header_id"+
						  ",po_line_location_id"+
						  ",inventory_item_id"+
						  ",reservation_qty"+
						  ",reservation_uom"+
						  ",lot_number"+
						  ",created_by"+
						  ",creation_date"+
						  ",last_updated_by"+
						  ",last_update_date"+
						  ",carton_num"+
						  ",seq_id"+
						  ",status"+
						  ",orig_seq_id"+
						  ",advise_line_id)"+
						  " select TEW_LOT_RESERVATION_ID_S.nextval"+
						  ",a.SO_NO"+
						  ",a.SO_HEADER_ID"+
						  ",a.SO_LINE_ID"+
						  ",c.po_no"+
						  ",c.po_header_id"+
						  ",b.po_line_location_id"+
						  ",c.inventory_item_id"+
						  ",(?/1000)"+
						  ",'KPC'"+
						  ",b.lot_number"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",b.seq_id"+
						  ",'A'"+
						  ",NULL"+
						  ",a.advise_line_id"+
						  " from tsc.tsc_shipping_advise_lines a"+
						  ",oraddman.tewpo_receive_detail b"+
						  ",oraddman.tewpo_receive_header c"+
						  " where a.advise_line_id=?"+
						  " and a.inventory_item_id=c.inventory_item_id "+
						  " and c.po_line_location_id=b.po_line_location_id"+
						  " and b.seq_id=?";
					PreparedStatement pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,""+ALLOT_QTY); 
					pstmtDt.setString(2,UserName);
					pstmtDt.setString(3,UserName); 
					pstmtDt.setInt(4,i); 
					pstmtDt.setString(5,ADVISE_LINE_ID);
					pstmtDt.setString(6,SEQ_ID);
					pstmtDt.executeQuery();
					pstmtDt.close();
					//out.println(sql);
				}
				rs2.close();	
				statement2.close();	
				
				icnt++; 
				if (CARTON_PER_QTY<=0) break; 
			}
			rs.close();	
			statement.close();		  
			
			if (icnt==0)
			{
				throw new Exception("查無批號!!");
			}
			else if (CARTON_PER_QTY>0)
			{
				throw new Exception("庫存不足!!");
			}
		}
		con.commit();
		ACODE="";
		ADVISENO="";
		SO_LINE_ID="";
		MO="";
		MOLINE="";
		ITEMNAME="";
		ITEMDESC="";
		CUSTITEM="";
		PC_ADVISE_ID="";
		CUSTPO="";
		SHIPQTY="";
		CARTONLIST="";
		RESERVE_LOT="";
		RESERVE_DC="";  //add by Peggy 20151119
		RESERVE_SCARTON="";
		RESERVE_ECARTON="";
		RESERVE_QTY="";
		VENDOR="";
		CARTON_LIST1="";
		strmsg="<font color='blue'>交易成功!!</font>";
	}
}
catch(Exception e)
{
	con.rollback();
	strmsg="<font color='red'>交易失敗!!原因:"+e.getMessage()+"</font>";
	//out.println("<div align='center' style='color:#ff0000'>交易失敗!!原因:"+e.getMessage()+"</div>");
}
%>
<table align="center" width="60%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">TEW Reservation Lot To Allot</font></strong>
		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="30%" height="25" bgcolor="#C9E2D0" nowrap>Advise No：</td>
					<td nowrap><input type="TEXT" name="ADVISENO" value="<%=ADVISENO%>" style="font-family: Tahoma,Georgia;font-size:12px"><input type="hidden" name="PC_ADVISE_ID" value="<%=PC_ADVISE_ID%>"></td>
				</tr>
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>訂單號碼：</td>
					<td nowrap><input type="TEXT" name="MO" value="<%=MO%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);"  readonly><input type="button" name="btn1" value=".." style="font-size:11px;font-family: Tahoma,Georgia;" onClick="chooseMOinfo()"></td>
				</tr>				
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>訂單項次：</td>
					<td nowrap><input type="TEXT" name="MOLINE" value="<%=MOLINE%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" size="10"  readonly><input type="hidden" name="SO_LINE_ID" value="<%=SO_LINE_ID%>"></td>
				</tr>
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>料號：</td>
					<td nowrap><input type="TEXT" name="ITEMNAME" value="<%=ITEMNAME%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" size="40" readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>型號：</td>
					<td nowrap><input type="TEXT" name="ITEMDESC" value="<%=ITEMDESC%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" size="40" readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>客戶品號：</td>
					<td nowrap><input type="TEXT" name="CUSTITEM" value="<%=CUSTITEM%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" size="40" readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>客戶PO：</td>
					<td nowrap><input type="TEXT" name="CUSTPO" value="<%=CUSTPO%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);"  size="40" readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>編箱明細：</td>
				  <td nowrap>
					<input type="TEXT" name="CARTONLIST" value="<%=CARTONLIST%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" readonly><INPUT TYPE="hidden" name="CARTON_LIST1" value="<%=CARTON_LIST1%>"></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>出貨量(PCE)：</td>
					<td nowrap><input type="TEXT" name="SHIPQTY" value="<%=SHIPQTY%>" style="text-align:right;background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);"  readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>供應商：</td>
				  <td nowrap>
					<input type="TEXT" name="VENDOR" value="<%=VENDOR%>" style="background-color:#F0F0F0;font-family: Tahoma,Georgia;font-size:12px" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>預約起訖箱號：</td>
					<td nowrap>
					<input type="TEXT" name="RESERVE_SCARTON" value="<%=RESERVE_SCARTON%>" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" size="7" onKeyDown="return (event.keyCode>=48 && event.keyCode<=57);">
					-
					<input type="TEXT" name="RESERVE_ECARTON" value="<%=RESERVE_ECARTON%>" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" size="7" onKeyDown="return (event.keyCode>=48 && event.keyCode<=57);">
					</td>
				</tr>					
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>預約批號：</td>
					<td nowrap><input type="TEXT" name="RESERVE_LOT" value="<%=RESERVE_LOT%>" style="font-family: Tahoma,Georgia;font-size:12px"></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>預約D/C：</td>
					<td nowrap><input type="TEXT" name="RESERVE_DC" value="<%=RESERVE_DC%>" style="font-family: Tahoma,Georgia;font-size:12px"></td>
				</tr>	
				<tr>
					<td width="30%" bgcolor="#C9E2D0" nowrap>預約數量(PCE)：</td>
					<td nowrap><input type="TEXT" name="RESERVE_QTY" value="<%=RESERVE_QTY%>" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57"></td>
				</tr>																				
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input name="btnSubmit" type="button" onClick='setSubmit("../jsp/TEWLotReservation.jsp?ACODE=SAVE")' value="Submit" style="font-family:Tahoma,Georgia;font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type="button" onClick='setCancel()' value="Exit" style="font-family:Tahoma,Georgia;font-size:12px">
					</td>    
  				</tr>
				<tr><td><div align="center"><%=strmsg%></div></td></tr>
			</table>
		</td>
	</tr>
</table>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
