<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean,Array2DimensionInputBean"%>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
		lineid = document.MYFORM.chk[irow].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		document.getElementById("div_"+lineid).innerHTML ="&nbsp;";
		document.MYFORM.elements["btn_"+lineid].disabled=false;
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.getElementById("div_"+lineid).innerHTML ="&nbsp;";
		document.MYFORM.elements["btn_"+lineid].disabled=true;	
	}
}
function setSubmit(URL)
{    
	if ((document.MYFORM.SUPPLIERSITEID.value =="" || document.MYFORM.SUPPLIERSITEID.value ==null)  && (document.MYFORM.PONO.value =="" || document.MYFORM.PONO.value ==null) && (document.MYFORM.ITEM.value =="" || document.MYFORM.ITEM.value ==null))
	{
		alert("採購單號或供應商或品名必須擇一輸入,不可同時空白!");
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
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
			if (document.getElementById("div_"+lineid).innerHTML  =="" || document.getElementById("div_"+lineid).innerHTML  =="&nbsp;" || document.getElementById("div_"+lineid).innerHTML ==null)
			{
				alert("項次"+i+":本次收貨數量必須輸入!");
				return false;
			}
			else
			{
				var receive_qty = document.getElementById("div_"+lineid).innerHTML;
				var unreceive_qty = document.MYFORM.elements["UNRECEIVE_"+lineid].value;
				if (parseFloat(receive_qty) > parseFloat(unreceive_qty))
				{
					alert("本次收貨數量("+receive_qty+")不可大於未收數量("+unreceive_qty+")!");
					return false;
				}
			}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}

	document.MYFORM.save.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setSubmit2(URL)
{
	if (document.MYFORM.SUPPLIERSITEID.value =="" || document.MYFORM.SUPPLIERSITEID.value ==null )
	{
		alert("請先指定供應商!");
		return false;
	}
	document.getElementById("alpha").style.width="100%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL+"?ORGCODE="+document.MYFORM.ORGCODE.value+"&VENDORID="+document.MYFORM.SUPPLIERSITEID.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function subWindowSupplierFind(Supplier)
{
	subWin=window.open("../jsp/subwindow/TSCSGPOSupplierFind.jsp?SEARCHSTR="+Supplier+"&ORGCODE="+document.MYFORM.ORGCODE.value,"subwin","width=740,height=480,scrollbars=yes,menubar=no");  
}
function showActionType()
{
	var chvalue="";
	for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
	{
		if (document.MYFORM.rdo1[i].checked)
		{
			 chvalue = document.MYFORM.rdo1[i].value;
			 break;
		}
	}

}
</script>
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
  .text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
<title>SG PO Receiving</title>
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
<jsp:useBean id="POReceivingBean" scope="session" class="Array2DimensionInputBean"/>
<%
String sql = "";
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String SUPPLIERSITEID = request.getParameter("SUPPLIERSITEID");
if (SUPPLIERSITEID==null) SUPPLIERSITEID="";
String PONO = request.getParameter("PONO");
if (PONO==null) PONO="";
String ITEM = request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String CUST_ITEM = request.getParameter("CUST_ITEM");
if (CUST_ITEM==null) CUST_ITEM="";
String PO_LINE_LIST="";
float TOTQTY=0;
Hashtable hashtb = (Hashtable)session.getAttribute("H12001");
String ACTIONCODE = request.getParameter("ACTIONCODE");
if (ACTIONCODE ==null) ACTIONCODE="";
if (ACTIONCODE.equals("UPLOAD"))
{
	if (hashtb!=null)
	{
		Enumeration enkey  = hashtb.keys(); 
		while (enkey.hasMoreElements())   
		{
			PO_LINE_LIST += enkey.nextElement()+","; 
		} 
		if (!PO_LINE_LIST.equals("")) PO_LINE_LIST = PO_LINE_LIST.substring(0,PO_LINE_LIST.length()-1);
		//out.println(PO_LINE_LIST);
	}
}
else
{
	POReceivingBean.setArray2DString(null); 
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="TSCSGPOReceive.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;font-family:Tahoma,Georgia;">SG PO Receiving</font></strong>
<BR>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 400px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
</table>
<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
	<tr>
		<td width="8%"><font color="#666600" >內外銷:</font></td>   
		<td width="7%">
		<%		
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG1','SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>	
		<!--<select NAME="ORGCODE" style="font-family:ARIAL;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		<OPTION VALUE="906" <%if (ORGCODE.equals("908")) out.println("selected");%>>SG2</OPTION>
		</select>-->
		</td>    
		<td width="8%"><font color="#666600">供應商:</font></td>
		<td width="13%"><input type="text" name="SUPPLIER" value="<%=SUPPLIER%>" style="font-family:Arial;font-size:12px" size="15"><input type="hidden" name="SUPPLIERSITEID" value="<%=SUPPLIERSITEID%>"><input type="button"  height="8" name="btnSupplier" value=".." onClick="subWindowSupplierFind(this.form.SUPPLIER.value)"></td>
		<td width="8%"><font color="#666600">採購單號:</font></td>
		<td width="10%"><input type="text" name="PONO" value="<%=PONO%>" style="font-family:Arial;font-size:12px" size="12"></td>
		<td width="10%"><font color="#666600">料號或型號:</font></td>
		<td width="15%"><input type="text" name="ITEM" value="<%=ITEM%>" style="font-family:Arial;font-size:12px" size="25"></td>
		<td width="8%"><font color="#666600">客戶品號:</font></td>
		<td width="13%"><input type="text" name="CUST_ITEM" value="<%=CUST_ITEM%>" style="font-family:Arial;font-size:12px" size="20"></td>
	</tr>
	<tr>
		<td colspan="10" align="center">
			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGPOReceive.jsp?ACTIONCODE=Q")' > 
			&nbsp;&nbsp;&nbsp;&nbsp;
			<INPUT TYPE="button" align="middle"  value='上傳匯入' onClick='setSubmit2("../jsp/TSCSGPOReceiveUploadImport.jsp")' > 
		</td>
	</tr>
</table> 
<HR>
<%
if (ACTIONCODE.equals("Q") || ACTIONCODE.equals("UPLOAD"))
{
	try
	{
		sql = " SELECT a.PO_HEADER_ID,"+
		      " b.PO_LINE_ID,"+
			  " D.vendor_name,"+
			  " A.SEGMENT1 PO_NO,"+
			  " to_char(B.creation_date,'yyyy-mm-dd') creation_date"+
			  ",C.LINE_LOCATION_ID,"+
			  " to_char(c.need_by_date,'yyyy-mm-dd') need_by_date,"+
			  " E.SEGMENT1 ITEM_NAME,"+
			  " E.DESCRIPTION ITEM_DESC,"+
			  " c.PRICE_OVERRIDE unit_price,"+
			  " A.CURRENCY_CODE,"+
			  " C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0) QUANTITY,"+
			  " C.UNIT_MEAS_LOOKUP_CODE UOM,"+
			  " C.QUANTITY_RECEIVED,"+
			  " C.QUANTITY_CANCELLED,"+
			  " C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)  UNRECEIVE_QTY,"+
			  " 0 RECEIVED_QUANTITY,"+
			  " B.note_to_vendor,"+
			  " C.note_to_receiver,"+
			  " C.SHIP_TO_ORGANIZATION_ID,"+
			  " E.INVENTORY_ITEM_ID ITEM_ID,"+
			  " a.VENDOR_SITE_ID,"+
			  " g.vendor_site_code,"+
			  //" nvl(odr.cust_partno,B.note_to_vendor) cust_partno,"+
			  //" nvl(odr.cust_partno,nvl(TRIM(REPLACE(REPLACE(CASE INSTR(B.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN B.NOTE_TO_VENDOR ELSE SUBSTR(B.NOTE_TO_VENDOR,1,INSTR(B.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，','')),'N/A')) cust_partno,"+
			  " nvl(odr.cust_partno,nvl(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(B.NOTE_TO_VENDOR),'N/A')) cust_partno,"+		//moidfy by Peggy 20230607	  
			  " b.line_num"+ 
   		      ",case mp.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else mp.organization_code end as organization_name"+
			  " FROM PO.PO_HEADERS_ALL A,"+
			  " PO.PO_LINES_ALL B,"+
			  " PO.PO_LINE_LOCATIONS_ALL C,"+
			  " AP.AP_SUPPLIERS D,"+
			  " AP.AP_SUPPLIER_SITES_ALL G,"+
			  " INV.MTL_SYSTEM_ITEMS_B E,"+
			  " INV.MTL_PARAMETERS MP,"+
              " (SELECT *  FROM (SELECT a.order_number, b.line_number,DECODE (b.item_identifier_type,'CUST', b.ordered_item,'') cust_partno,ROW_NUMBER () OVER (PARTITION BY a.order_number, b.line_number  ORDER BY shipment_number) seqno"+
              "                  FROM ont.oe_order_headers_all a, ont.oe_order_lines_all b"+
              "                  WHERE a.header_id = b.header_id) WHERE seqno = 1) odr"+
			  " WHERE A.ORG_ID in (?,?)"+
			  " AND A.TYPE_LOOKUP_CODE='STANDARD'"+
			  " AND A.ORG_ID=B.ORG_ID"+
			  " AND B.ORG_ID=C.ORG_ID"+
			  " AND A.PO_HEADER_ID = B.PO_HEADER_ID"+
			  " AND B.PO_HEADER_ID = C.PO_HEADER_ID"+
			  " AND B.PO_LINE_ID = C.PO_LINE_ID"+
			  " AND NVL(A.approved_flag, 'N') = 'Y' "+
			  " AND NVL(A.cancel_flag,'N') = 'N'"+
			  " AND NVL(A.closed_code,'OPEN') NOT LIKE '%CLOSED%'"+
			  " AND NVL(B.cancel_flag,'N') = 'N'"+
			  " AND NVL(B.closed_code,'OPEN') <> 'CLOSED'"+
			  " AND NVL(B.closed_flag,'N') <> 'Y'"+
			  " AND NVL(C.cancel_flag,'N') <> 'Y' "+
			  " AND NVL(C.CLOSED_CODE,'OPEN') NOT LIKE  '%CLOSED%'"+
			  " AND C.quantity - NVL (C.quantity_received, 0) > 0"+
			  " AND C.ship_to_organization_id=MP.organization_id"+
		      " AND mp.organization_code in ('SG1','SG2','I1')";			  
		if (!ORGCODE.equals(""))
		{
			sql += "  AND C.ship_to_organization_id="+ORGCODE+"";
		}
		//else 
		//{
		//	sql += "  AND C.ship_to_organization_id in (49,887,888,906)";
		//}			  
		if (!PONO.equals(""))
		{
			sql += " AND A.SEGMENT1 LIKE '"+ PONO+"%'";
		}
		if (!ITEM.equals(""))
		{
			sql += " AND (E.SEGMENT1 LIKE '"+ ITEM.toUpperCase()+"%' OR E.DESCRIPTION LIKE '"+ITEM.toUpperCase()+"%')";
		}
		if (!SUPPLIER.equals(""))
		{
			sql += " AND EXISTS (SELECT 1 from  PO.PO_HEADERS_ALL z where VENDOR_SITE_ID = '"+SUPPLIERSITEID+"' and z.po_header_id = A.po_header_id)";
		}
		if (ACTIONCODE.equals("UPLOAD"))
		{
			sql += " AND C.LINE_LOCATION_ID IN ("+PO_LINE_LIST+")";
		}
		sql +=" AND A.vendor_id = D.vendor_id"+
			  " AND A.vendor_site_id = g.vendor_site_id"+
			  " AND B.ITEM_ID = E.INVENTORY_ITEM_ID"+
			  " AND C.SHIP_TO_ORGANIZATION_ID = E.ORGANIZATION_ID"+
			  " AND length(E.SEGMENT1)>=?"+
              " AND SUBSTR (c.note_to_receiver,1, INSTR (c.note_to_receiver, '.') - 1) = odr.order_number(+)"+
              " AND SUBSTR (c.note_to_receiver,INSTR (c.note_to_receiver, '.') + 1,LENGTH (c.note_to_receiver)) = odr.line_number(+)"+
		      //" AND exists (select 1 from po.po_agents x where x.agent_id = a.agent_id and x.attribute1='TEW') "+			  
			  " AND C.QUANTITY-NVL(C.QUANTITY_CANCELLED,0)-NVL(C.QUANTITY_RECEIVED,0)>0";
		if (!ITEM.equals(""))
		{
			sql += " AND (UPPER(E.SEGMENT1) LIKE '"+ ITEM.toUpperCase()+"%' OR UPPER(E.DESCRIPTION) LIKE '"+ITEM.toUpperCase()+"%')";
		}
		if (!CUST_ITEM.equals(""))
		{
			sql += " AND nvl(odr.cust_partno,B.note_to_vendor) LIKE '"+ CUST_ITEM+"%'";
		}
		if (ACTIONCODE.equals("UPLOAD"))
		{
			sql += " AND C.LINE_LOCATION_ID IN ("+PO_LINE_LIST+")"+
			       " order by E.DESCRIPTION,A.SEGMENT1";
		}
		else
		{
			sql += " order by a.vendor_site_id,to_char(c.need_by_date,'yyyy-mm-dd'),c.po_header_id,c.line_location_id";
		}
		//out.println(sql);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,"41");
		statement.setString(2,"906");
		statement.setString(3,"22");
		ResultSet rs=statement.executeQuery();
		int icnt =0;
		while (rs.next())
		{
			if (icnt ==0)
			{
%>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr bgcolor="#C8E3E8" style="font-family:'細明體';font-size:11px" align="center">
					<td width="2%"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="5%">&nbsp;</td>
					<td width="5%">內外銷</td>
					<td width="6%">供應商</td>
					<td width="6%">採購單號</td>
					<td width="4%">採購項次</td>
					<td width="11%">料號</td>
					<td width="10%">型號</td>
					<td width="8%">客戶品號</td>
					<td width="6%">需求日期</td>
					<td width="6%">採購數量(K)</td>
					<td width="7%">已入ERP數量(K)</td>
					<td width="9%">已收未入ERP數量(K)</td>
					<td width="6%">未交數量(K)</td>
					<td width="3%">單位</td>
					<td width="6%">本次收料數量(K)</td>
				</tr>
			
<%		
			}
%>
				<tr <%=(ACTIONCODE.equals("UPLOAD")?"style='background-color:#daf1a9;font-size:11px'":"style='font-size:11px'")%> id="tr_<%=rs.getString("line_location_id")%>">
					<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("line_location_id")%>" onClick="setCheck(<%=icnt%>)" <%=(ACTIONCODE.equals("UPLOAD")?"checked":"")%>></td>
					<td align="center"><input type="button" name="btn_<%=rs.getString("line_location_id")%>" value="收貨" <%=(ACTIONCODE.equals("UPLOAD")?"":"disabled")%> onClick="window.open('../jsp/TSCSGPOReceiveDetail.jsp?ID=<%=rs.getString("line_location_id")%>&QTY=<%=rs.getString("UNRECEIVE_QTY")%>','subwin','width=1000,height=680,scrollbars=yes,menubar=no')"></td>
					<td align="center"><%=rs.getString("organization_name")%></td>
					<td align="left"><%=rs.getString("vendor_site_code")%><input type="hidden" name="VENDOR_NAME_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("vendor_name")%>"><input type="hidden" name="VENDOR_SITE_ID_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("vendor_site_id")%>"><input type="hidden" name="ORG_ID_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("SHIP_TO_ORGANIZATION_ID")%>"><input type="hidden" name="PO_HEADER_ID_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("PO_HEADER_ID")%>"><input type="hidden" name="PO_LINE_ID_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("PO_LINE_ID")%>"></td>
					<td align="center"><%=rs.getString("PO_NO")%><input type="hidden" name="PO_NO_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("PO_NO")%>"></td>
					<td align="center"><%=rs.getString("line_num")%></td>
					<td align="left"><%=rs.getString("ITEM_name")%><input type="hidden" name="ITEM_NAME_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("ITEM_NAME")%>"><input type="hidden" name="ITEM_ID_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("ITEM_ID")%>"></td>
					<td align="left"><%=rs.getString("ITEM_DESC")%><input type="hidden" name="ITEM_DESC_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("ITEM_DESC")%>"></td>
					<td align="left"><%=(rs.getString("CUST_PARTNO")==null?"&nbsp;":rs.getString("CUST_PARTNO"))%></td>
					<td align="center"><%=rs.getString("need_by_date")%></td>
					<td align="right"><%=(new DecimalFormat("#####.###")).format(Float.parseFloat(rs.getString("QUANTITY")))%></td>
					<td align="right"><%=(new DecimalFormat("#####.###")).format(Float.parseFloat(rs.getString("QUANTITY_RECEIVED")))%></td>
					<td align="right"><%=(new DecimalFormat("#####.###")).format(Float.parseFloat(rs.getString("RECEIVED_QUANTITY")))%></td>
					<td align="right"><%=(new DecimalFormat("#####.###")).format(Float.parseFloat(rs.getString("UNRECEIVE_QTY")))%><input type="hidden" name="UNRECEIVE_<%=rs.getString("line_location_id")%>" value="<%=rs.getString("UNRECEIVE_QTY")%>"></td>
					<td align="center"><%=rs.getString("UOM")%></td>
					<td><div id="div_<%=rs.getString("line_location_id")%>" style="text-align:right;font-weight:bold;color:#0000FF;font-size:13px;"><%=(ACTIONCODE.equals("UPLOAD")?""+((new DecimalFormat("######.###")).format(Float.parseFloat((String)hashtb.get(rs.getString("line_location_id")))/1000)):"&nbsp;")%></div></td>
				</tr>
<%
			if (ACTIONCODE.equals("UPLOAD"))
			{
				TOTQTY += Float.parseFloat((String)hashtb.get(rs.getString("line_location_id")));
			}
			icnt++;
		}
		if (icnt >0)
		{
%>
			</table>
<%
			if (ACTIONCODE.equals("UPLOAD"))
			{
%>
			<table width="100%">
				<tr><td align="right"><font style="font-size:12px">總收貨量：&nbsp;&nbsp;&nbsp;</font><font style="font-weight:bold;color:#0000FF;font-size:13px"><%=(TOTQTY/1000)%></font></td></tr>
			</table>
<%
			}
%>

			<table width="100%">
				<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGPOReceiveProcess.jsp')"></td></tr>
			</table>
<%

		}
		else
		{
			out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
		}
		rs.close();
		statement.close();
	}
	catch(Exception e)
	{
		out.println("Exception1:"+e.getMessage());
	}
}
%>
<input type="hidden" name="TRANSTYPE" value="RECEIVE">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

