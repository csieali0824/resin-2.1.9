<!-- modify by Peggy 20151118,新增內外銷調撥選項-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setCancel()
{
	self.close();
}
function setSubmit(URL)
{ 
	var chkvalue="";
	var v_date = document.MYFORMD.NEW_RDATE.value;
	if (v_date =="")
	{
		alert("請輸入收料日期!!");
		document.MYFORMD.NEW_RDATE.focus();
		return false;
	}
	else if (v_date.length!=8)
	{
		alert("收料日期格式錯誤(正確格式為YYYYMMDD)!!");
		document.MYFORMD.NEW_RDATE.focus();
		return false;			
	}
	else
	{
		rec_year = v_date.substr(0,4);
		rec_month= v_date.substr(4,2);
		rec_day  = v_date.substr(6,2);
		if (rec_month <1 && rec_month >12)
		{
			alert("收料月份有誤!!");
			document.MYFORMD.NEW_RDATE.focus();
			return false;			
		}
		if (rec_month <1 && rec_month >12)
		{
			alert("收料月份有誤!!");
			document.MYFORMD.NEW_RDATE.focus();
			return false;			
		}	
		else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
		{
			alert("收料日期有誤!!");
			document.MYFORMD.NEW_RDATEfocus();
			return false;			
		} 
		else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
		{
			alert("收料日期有誤!!");
			document.MYFORMD.NEW_RDATE.focus();
			return false;			
		} 
		else if (rec_month == 2)
		{
			if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
			{
				alert("收料日期有誤!!");
				document.MYFORMD.NEW_RDATE.focus();
				return false;	
			}		
		}
	}
	if (document.MYFORMD.NEW_LOT.value == null || document.MYFORMD.NEW_LOT.value == "")
	{
    	alert("請輸入LOT!!");
     	document.MYFORMD.NEW_LOT.focus();
   		return false;
	}
	if (document.MYFORMD.NEW_DC.value == null || document.MYFORMD.NEW_DC.value == "")
	{
    	alert("請選擇Date Code!");
     	document.MYFORMD.NEW_DC.focus();
   		return false;
	}
	if (isNaN(document.MYFORMD.NEW_QTY.value))
	{
		document.MYFORMD.NEW_QTY.focus();
		alert("請輸入數字型態!!");
		return false;
	}	
	else if (parseFloat(document.MYFORMD.NEW_QTY.value) < (parseFloat(document.MYFORMD.ERP_QTY.value)+parseFloat(document.MYFORMD.PICK_QTY.value)))
	{
		document.MYFORMD.NEW_QTY.focus();
		alert("數量"+parseFloat(document.MYFORMD.NEW_QTY.value)+"不可小於已出貨+已撿貨未出數量"+(parseFloat(document.MYFORMD.ERP_QTY.value)+parseFloat(document.MYFORMD.PICK_QTY.value))+"!!");
		return false;	
	}
	else if (parseFloat(document.MYFORMD.NEW_QTY.value) > parseFloat(document.MYFORMD.QTY.value))
	{
		//alert(document.MYFORMD.NEW_QTY.value);
		//alert(document.MYFORMD.QTY.value);
		document.MYFORMD.NEW_QTY.focus();
		alert("數量只可減少不可增加!!");
		return false;		
	}
	if (document.MYFORMD.NEW_LOT.value == document.MYFORMD.LOT.value &&
	    document.MYFORMD.NEW_DC.value == document.MYFORMD.DC.value &&
		document.MYFORMD.NEW_QTY.value == document.MYFORMD.QTY.value &&
		document.MYFORMD.NEW_RDATE.value == document.MYFORMD.RDATE.value.replace(/\\/g,""))
	{
		alert("資料無異動,請重新確認!!");
		return false;		
	}
	for (var i =0 ; i <document.MYFORMD.rdo1.length ;i++)
	{
		if (document.MYFORMD.rdo1[i].checked)
		{
			 chkvalue = document.MYFORMD.rdo1[i].value;
			 break;
		}
	}
	if (chkvalue == "")
	{
		alert("請選擇異動原因!");
		return false;
	}
	else if (chkvalue =="1")
	{
		if (document.MYFORMD.RETURN_TYPE.value =="")
		{
			alert("請選擇退貨原因!");
			document.MYFORMD.RETURN_TYPE.focus();
			return false;
		}
		else if (document.MYFORMD.RETURN_TYPE.value =="其他" && (document.MYFORMD.REASON1.value==null || document.MYFORMD.REASON1.value==""))
		{
			alert("請填入退貨原因!");
			document.MYFORMD.REASON1.focus();
			return false;
		}
		else if (document.MYFORMD.NEW_LOT.value != document.MYFORMD.LOT.value ||
	    document.MYFORMD.NEW_DC.value != document.MYFORMD.DC.value ||
		document.MYFORMD.NEW_RDATE.value != document.MYFORMD.RDATE.value.replace(/\\/g,""))
		{
			alert("退貨回供應商時,只允許修改數量!!");
			return false;		
		}
	}	
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
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
 
function radioChange()
{
	var chkvalue="";
	for (var i =0 ; i <document.MYFORMD.rdo1.length ;i++)
	{
		if (document.MYFORMD.rdo1[i].checked)
		{
			 chkvalue = document.MYFORMD.rdo1[i].value;
			 break;
		}
	}

	if (chkvalue =="1")
	{
		document.MYFORMD.RETURN_TYPE.value ="";
		document.MYFORMD.RETURN_TYPE.style.visibility ="visible";
		document.MYFORMD.REA1.style.visibility ="visible";
		document.MYFORMD.REA2.style.visibility ="hidden";
		document.MYFORMD.REASON.value="";
		document.MYFORMD.REASON.style.visibility ="hidden";
		document.MYFORMD.REASON1.value="";
		document.MYFORMD.REASON1.style.visibility ="hidden";
	}
	else if (chkvalue =="2")
	{
		document.MYFORMD.REA1.style.visibility ="hidden";
		document.MYFORMD.REA2.style.visibility ="visible";
		document.MYFORMD.RETURN_TYPE.value ="";
		document.MYFORMD.RETURN_TYPE.style.visibility ="hidden";
		document.MYFORMD.REASON.value="";
		document.MYFORMD.REASON.style.visibility ="visible";
		document.MYFORMD.REASON1.value="";
		document.MYFORMD.REASON1.style.visibility ="hidden";
	}
	else
	{
		document.MYFORMD.REA1.style.visibility ="hidden";
		document.MYFORMD.REA2.style.visibility ="hidden";
		document.MYFORMD.RETURN_TYPE.value ="";
		document.MYFORMD.RETURN_TYPE.style.visibility ="hidden";
		document.MYFORMD.REASON.value="";
		document.MYFORMD.REASON.style.visibility ="hidden";
		document.MYFORMD.REASON1.value="";
		document.MYFORMD.REASON1.style.visibility ="hidden";
	}
}

function selectChange()
{
	if (document.MYFORMD.RETURN_TYPE.value =="其他")
	{
		document.MYFORMD.REASON1.value="";
		document.MYFORMD.REASON1.style.visibility ="visible";
	}
	else
	{
		document.MYFORMD.REASON1.value="";
		document.MYFORMD.REASON1.style.visibility ="hidden";
	}
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
<title>TEW PO Receive Date Revise</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TEWPOReceiveRevise.jsp" METHOD="POST"> 
<%
String LINE = request.getParameter("LINE");
if (LINE==null) LINE="";
String ID = request.getParameter("ID");
if (ID == null) ID="";
String LOT = request.getParameter("LOT");
if (LOT == null) LOT = "";
String RDATE = request.getParameter("RDATE");
if (RDATE == null) RDATE = "";
String DC = request.getParameter("DC");
if (DC == null) DC= "";
String SEQ_ID = request.getParameter("SEQ_ID");
if (SEQ_ID ==null) SEQ_ID="";
String NEW_LOT = request.getParameter("NEW_LOT");
if (NEW_LOT == null) NEW_LOT = LOT;
String NEW_RDATE = request.getParameter("NEW_RDATE");
if (NEW_RDATE == null) NEW_RDATE = RDATE;
String NEW_DC = request.getParameter("NEW_DC");
if (NEW_DC == null) NEW_DC= DC;
String NEW_QTY = request.getParameter("NEW_QTY");
if (NEW_QTY == null) NEW_QTY= "";
String REASON = request.getParameter("REASON");
if (REASON==null) REASON ="";
String ACODE = request.getParameter("ACODE");
if (ACODE == null) ACODE="";
String RETURN_TYPE = request.getParameter("RETURN_TYPE");
if (RETURN_TYPE==null) RETURN_TYPE="";
String REASON1 = request.getParameter("REASON1");
if (REASON1==null) REASON1 ="";
String CHANGE_TYPE = request.getParameter("rdo1");
if (CHANGE_TYPE==null) CHANGE_TYPE="";
String CUSTITEM= request.getParameter("CUSTITEM");
if (CUSTITEM==null) CUSTITEM="";
String SUPPLIER="",PONO="",ITEMNAME="",ITEMDESC="",ERP_QTY="0",QTY="0",PICK_QTY="";  
String sql ="",DC_MSG="";
sql = " SELECT COUNT(1) FROM oraddman.tewpo_receive_revise a"+
	  " WHERE PO_LINE_LOCATION_ID=?"+
	  " and a.old_lot_number=?"+
	  " and a.old_date_code=?"+
	  " and to_char(a.old_received_date,'yyyymmdd')=?"+
	  " and a.seq_id=?"+
	  " and a.APPROVE_FLAG=?";
PreparedStatement statement1 = con.prepareStatement(sql);
statement1.setString(1,ID);
statement1.setString(2,LOT);
statement1.setString(3,DC);
statement1.setString(4,RDATE);
statement1.setString(5,SEQ_ID);
statement1.setString(6,"N");
ResultSet rs1=statement1.executeQuery();
if (rs1.next())
{	
	if (rs1.getInt(1) >0)
	{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("異動資料處理完畢後,才可申請修改!");
			this.window.close();
		</script>
<%
	}
}
rs1.close();
statement1.close();
	
try
{  
	sql = " SELECT  a.po_line_location_id"+
	      ",a.VENDOR_NAME"+
		  ",a.PO_NO"+
		  ",a.ITEM_NAME"+
		  ",a.ITEM_DESC"+
		  ",a.LOT_NUMBER"+
		  ",a.DATE_CODE"+
		  ",a.RECEIVED_DATE"+
		  ",a.RECEIVED_QUANTITY"+
		  ",a.SHIPPED_QUANTITY"+
		  ",nvl(c.allot_qty,0) allot_qty"+
		  ",nvl(nvl(odr.cust_partno,pla.note_to_vendor),'N/A') cust_partno"+
		  " FROM (SELECT  b.po_line_location_id,a.VENDOR_NAME,a.PO_NO,a.ITEM_NAME,a.ITEM_DESC,b.LOT_NUMBER,b.DATE_CODE,b.RECEIVED_DATE,b.seq_id,nvl(sum(b.RECEIVED_QUANTITY),0) RECEIVED_QUANTITY,nvl(sum(b.SHIPPED_QUANTITY),0) SHIPPED_QUANTITY FROM oraddman.TEWPO_RECEIVE_HEADER a,oraddman.TEWPO_RECEIVE_DETAIL b "+
		  " where a.po_line_location_id = b.po_line_location_id"+
		  " and b.po_line_location_id=?"+
		  " and b.lot_number=?"+
		  " and b.date_code=?"+
		  " and to_char(b.received_date,'yyyymmdd')=?"+
		  " and b.seq_id=?"+
		  " GROUP BY b.po_line_location_id,a.VENDOR_NAME,a.PO_NO,a.ITEM_NAME,a.ITEM_DESC,b.LOT_NUMBER,b.DATE_CODE,b.RECEIVED_DATE,b.seq_id) a"+
		  ",(SELECT po_line_location_id,lot_number,seq_id,sum(allot_qty)/1000 allot_qty FROM oraddman.tew_lot_allot_detail WHERE NVL(CONFIRM_FLAG,'N')<>'Y' group by po_line_location_id,lot_number,seq_id) c"+
   		  ",(SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'N/A') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
          "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
          "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr"+
          " ,po.po_line_locations_all plla"+
		  " ,po.po_lines_all pla"+		  
		  " where a.PO_LINE_LOCATION_ID=c.PO_LINE_LOCATION_ID(+)"+
		  " and a.LOT_NUMBER=c.LOT_NUMBER(+)"+
		  " and a.seq_id = c.seq_id(+)"+
		  " and a.po_line_location_id=plla.line_location_id"+
		  " and plla.PO_LINE_ID = pla.PO_LINE_ID"+
          " AND SUBSTR (plla.note_to_receiver,1, INSTR (plla.note_to_receiver, '.') - 1) = odr.order_number(+)"+
          " AND SUBSTR (plla.note_to_receiver,INSTR (plla.note_to_receiver, '.') + 1,LENGTH (plla.note_to_receiver)) = odr.line_number(+)";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ID);
	statement.setString(2,LOT);
	statement.setString(3,DC);
	statement.setString(4,RDATE);
	statement.setString(5,SEQ_ID);
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{
		SUPPLIER=rs.getString("VENDOR_NAME");
		PONO=rs.getString("PO_NO");
		ITEMNAME=rs.getString("ITEM_NAME");
		ITEMDESC=rs.getString("ITEM_DESC");
		QTY=rs.getString("RECEIVED_QUANTITY");
		ERP_QTY=rs.getString("SHIPPED_QUANTITY");
		PICK_QTY = rs.getString("ALLOT_QTY");
		CUSTITEM = rs.getString("CUST_PARTNO");
		if (NEW_QTY.equals("")) NEW_QTY=QTY;
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料,請重新確認,謝謝!");
			this.window.close();
		</script>
	<%				
	}
	rs.close();
	statement.close();
%>
<table align="center" width="50%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">TEW PO Receive Data to Revise</font></strong>
		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>供應商：</td>
					<td nowrap><%=SUPPLIER%><input type="hidden" name="SUPPLIER" value="<%=SUPPLIER%>"><input type="hidden" name="ID" value="<%=ID%>"><input type="hidden" name="LINE" value="<%=LINE%>"><input type="hidden" name="SEQ_ID" value="<%=SEQ_ID%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>採購單號：</td>
					<td nowrap><%=PONO%><input type="hidden" name="PONO" value="<%=PONO%>"></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>料號：</td>
					<td nowrap><%=ITEMNAME%><input type="hidden" name="ITEMNAME" value="<%=ITEMNAME%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>型號：</td>
					<td nowrap><%=ITEMDESC%><input type="hidden" name="ITEMDESC" value="<%=ITEMDESC%>"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>客戶品號：</td>
					<td nowrap><%=CUSTITEM%><input type="hidden" name="CUSTITEM" value="<%=CUSTITEM%>"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>調整前收貨數量(K)：</td>
					<td nowrap><input type="TEXT" name="QTY" style="border-top-style:none;border-right-style:none;border-left-style:none;text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(QTY))%>" size="10" readonly></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>已出貨數量(K)：</td>
					<td nowrap><input type="TEXT" name="ERP_QTY" style="border-top-style:none;border-right-style:none;border-left-style:none;text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(ERP_QTY))%>" size="10" readonly></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>已撿貨未出數量(K)：</td>
					<td nowrap><input type="TEXT" name="PICK_QTY" style="border-top-style:none;border-right-style:none;border-left-style:none;text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(PICK_QTY))%>" size="10" readonly></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>調整後收貨數量(K)：</td>
					<td nowrap><input type="TEXT" name="NEW_QTY" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(NEW_QTY))%>" size="10"><font color="blue">(調整後收貨數量=調整前收貨數量-退貨數量)</font></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>收料日期：</td>
					<td nowrap><input type="TEXT" name="NEW_RDATE" style="font-family: Tahoma,Georgia;font-size:12px" value="<%=NEW_RDATE%>" size="10"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.NEW_RDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A><input type="hidden" name="RDATE" value="<%=RDATE%>"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>LOT：</td>
					<td nowrap><input type="TEXT" name="NEW_LOT"  style="font-family: Tahoma,Georgia;font-size:12px" value="<%=NEW_LOT%>" size="10"><input type="hidden" name="LOT" value="<%=LOT%>"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Date Code：</td>
					<td nowrap><input type="TEXT" name="NEW_DC"  style="font-family: Tahoma,Georgia;font-size:12px" value="<%=NEW_DC%>" size="10"><input type="hidden" name="DC" value="<%=DC%>"><div id="div1" style="font-weight:BOLD;color:#FF0000"><%=DC_MSG%></div></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>異動原因：</td>
					<td nowrap>
					<input type="radio" name="rdo1" value="1"  onClick="radioChange();" <%=(CHANGE_TYPE.equals("1")?"checked":"")%>>退貨回供應商
					<input type="text" name="REA1" value="原因:" style="border-bottom:none;border-top:none;border-right:none;border-left:none;<%=(CHANGE_TYPE.equals("1")?"":"visibility:hidden")%>" size="5">
					<select name="RETURN_TYPE" style="font-family: Tahoma,Georgia;font-size:12px;<%=(CHANGE_TYPE.equals("1")?"":"visibility:hidden")%>" onChange="selectChange()">
					<option value="" <%=(RETURN_TYPE.equals("")?"selected":"")%>></option>
					<option value="品質異常" <%=(RETURN_TYPE.equals("品質異常")?"selected":"")%>>品質異常</option>
					<option value="供應商超交" <%=(RETURN_TYPE.equals("供應商超交")?"selected":"")%>>供應商超交</option>
					<option value="來料錯誤" <%=(RETURN_TYPE.equals("來料錯誤")?"selected":"")%>>來料錯誤</option>
					<option value="其他" <%=(RETURN_TYPE.equals("其他")?"selected":"")%>>其他</option>
					</select>
					<input type="TEXT" name="REASON1" style="border-bottom-color:#000000;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;font-size:12px;<%=(RETURN_TYPE.equals("其他")?"":"visibility:hidden")%>" value="<%=REASON1%>" size="25">					
					<br>
					<input type="radio" name="rdo1" value="2" onClick="radioChange()"  <%=(CHANGE_TYPE.equals("2")?"checked":"")%>>人為手誤修改
					<input type="text" name="REA2" value="原因:" style="border-bottom:none;border-top:none;border-right:none;border-left:none;<%=(CHANGE_TYPE.equals("2")?"":"visibility:hidden")%>" size="5">
					<input type="TEXT" name="REASON" style="border-bottom-color:#000000;border-top:none;border-right:none;border-left:none;font-family: Tahoma,Georgia;font-size:12px;<%=(CHANGE_TYPE.equals("2")?"":"visibility:hidden")%>" value="<%=REASON%>" size="30">
					<br>
					<input type="radio" name="rdo1" value="3" onClick="radioChange()"  <%=(CHANGE_TYPE.equals("3")?"checked":"")%>>內外銷調撥
					</td>
				</tr>																								
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>申請人：</td>
					<td nowrap><%=UserName%></td>
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
    				<td width="16%"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TEWPOReceiveRevise.jsp?ACODE=SAVE&ID=<%=ID%>&DC=<%=DC%>&LOT=<%=LOT%>&RDATE=<%=RDATE%>")' value="Submit" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type=button onClick='setCancel()' value="Cancel" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		try
		{
			sql = " select count(1) from tsc.TSC_DATE_CODE where date_code ='"+ NEW_DC+"'";
			Statement statement2=con.createStatement(); 
			ResultSet rs2=statement2.executeQuery(sql);
			if (rs2.next()) 
			{
				if (rs2.getInt(1)>0)
				{
					sql = " insert into oraddman.tewpo_receive_revise "+
						  " (request_id"+
						  " ,po_line_location_id"+
						  " ,old_lot_number"+
						  " ,old_date_code"+
						  " ,old_received_quantity"+
						  " ,old_received_date"+
						  " ,new_lot_number"+
						  " ,new_date_code"+
						  " ,new_received_quantity"+
						  " ,new_received_date"+
						  " ,approve_flag"+
						  " ,creation_date"+
						  " ,created_by"+
						  " ,last_update_date"+
						  " ,last_updated_by"+
						  " ,remark"+
						  " ,change_type"+
						  " ,SEQ_ID)"+
						  " select nvl(max(request_id),0)+1"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",to_date(?,'yyyymmdd')"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",TO_DATE(?,'yyyymmdd')"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  " from oraddman.tewpo_receive_revise";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,ID);	
					st1.setString(2,LOT);
					st1.setString(3,DC); 
					st1.setString(4,QTY);
					st1.setString(5,RDATE);  
					st1.setString(6,NEW_LOT);  
					st1.setString(7,NEW_DC);  
					st1.setString(8,NEW_QTY); 
					st1.setString(9,NEW_RDATE); 
					st1.setString(10,"N"); 
					st1.setString(11,UserName); 
					st1.setString(12,UserName); 
					if (CHANGE_TYPE.equals("3"))
					{
						st1.setString(13,"內外銷調撥");
					}
					else
					{
						st1.setString(13,(CHANGE_TYPE.equals("1")?(RETURN_TYPE.equals("其他")?REASON1:RETURN_TYPE):(REASON.equals("")?"人為手誤修改":REASON))); 
					}
					st1.setString(14,CHANGE_TYPE); 
					st1.setString(15,SEQ_ID); 
					st1.executeUpdate();
					st1.close();
	%>
					<script language = "JavaScript">
						alert('申請成功!');
						window.opener.document.getElementById("btn_"+document.MYFORMD.LINE.value).style.visibility="hidden";
						window.opener.document.getElementById("btn_"+document.MYFORMD.LINE.value).style.width="0px";
						window.opener.document.getElementById("img_"+document.MYFORMD.LINE.value).style.visibility="visible";
						window.opener.document.getElementById("img_"+document.MYFORMD.LINE.value).style.width="20px";
						window.opener.document.getElementById("tr_"+document.MYFORMD.LINE.value).title ="簽核中";
						this.window.close();
					</script>
	<%
				}
				else
				{
	%>
					<script language="javascript">
						document.getElementById("div1").innerHTML ="Date Code Not Found!!";
						document.MYFORMD.btnSubmit.disabled =false;
						document.MYFORMD.btnCancel.disabled =false;
					</script>
	<%
				}
			}
			rs2.close();
			statement2.close();
		}
		catch(Exception e)
		{
			out.println("Exception1:"+e.getMessage());
		}
	}
}
catch(Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
