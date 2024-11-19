<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{   
	if (document.MYFORM.ORGCODE.value=="--" && document.MYFORM.SUPPLIER.value=="--" && document.MYFORM.ITEM.value=="" && document.MYFORM.LOT_NUMBER.value=="" && document.MYFORM.DATE_CODE.value=="")
	{
		alert("請輸入查詢條件!");
		return false;
	}

	document.MYFORM.action=URL+"?ATYPE=Q";
 	document.MYFORM.submit();
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i+1);
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
		lineid = document.MYFORM.chk[irow-1].value;
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		lineid = document.MYFORM.chk.value;
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["TO_SUBINV_"+lineid].style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["remark_"+lineid].style.backgroundColor ="#daf1a9";
		document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].disabled =false;
		document.MYFORM.elements["remark_"+lineid].disabled =false;
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["TO_SUBINV_"+lineid].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].style.backgroundColor ="#DDDDDD";
		document.MYFORM.elements["remark_"+lineid].style.backgroundColor ="#DDDDDD";
		document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].value ="";
		document.MYFORM.elements["remark_"+lineid].value ="";
		document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].disabled =true;
		document.MYFORM.elements["remark_"+lineid].disabled =true;
	}
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
	for (var i=0; i< iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i].checked;
			lineid = document.MYFORM.chk[i].value;
		}
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].value=="")
			{
				alert("轉入數量必須輸入!");
				document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].focus();
				return false;
			}
			else if (eval(document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].value)==0)
			{
				alert("轉入數量必須大於0!");
				document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].focus();
				return false;			
			}
			else if (eval(document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].value)>eval(document.MYFORM.elements["ONHAND_"+lineid].value))
			{
				alert("轉入數量不可大於庫存量!");
				document.MYFORM.elements["TO_TRANFER_QTY_"+lineid].focus();
				return false;	
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

</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
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
  select   {  font-family:  Tahoma,Georgia; color: #000000; font-size: 12px}
</STYLE>
<title>SG Stock Inter Org Transfer</title>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String ORGCODE= request.getParameter("ORGCODE");
if (ORGCODE==null) ORGCODE="";
String SUPPLIER = request.getParameter("SUPPLIER");
if (SUPPLIER==null) SUPPLIER="";
String LOT_NUMBER = request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String DATE_CODE = request.getParameter("DATE_CODE");
if (DATE_CODE==null) DATE_CODE="";
String ITEM=request.getParameter("ITEM");
if (ITEM==null) ITEM="";
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String sql ="",stock_color="";
%>
</head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCSGStockInterOrgTransfer.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:20px;color:#006666">SG Stock Inter Org Tranfer</font></strong>
<BR>
  <div align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></div>
  <table cellSpacing='0' cellPadding='1' width='100%' align='center' borderColorLight="#CFDAD8"  bordercolordark="#5C7671" border='1'>
     <tr>
		<td Width="8%" bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666;font-family: Tahoma,Georgia">內外銷:</td>   
		<td width="7%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = " select organization_id,case  organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else organization_code end as organization_code from inv.mtl_parameters a where organization_code IN ('SG2')";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:12px'>");
			//out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
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
	    <td width="8%" bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">供應商:</td> 
		<td width="12%">
		<%
		try
		{
			sql = " select y.vendor_site_id,y.vendor_site_code from po_headers_all x,ap_supplier_sites_all y where x.TYPE_LOOKUP_CODE='BLANKET' and x.vendor_site_id=y.vendor_site_id and x.org_id=906 and y.vendor_site_code like '%-E' order by 2";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);
			comboBoxBean.setRs(rs);
			comboBoxBean.setSelection(SUPPLIER);
			comboBoxBean.setFieldName("SUPPLIER");	
			comboBoxBean.setFontName("Tahoma,Georgia");   
			out.println(comboBoxBean.getRsString());
			rs.close();   
			statement.close();     	 		
		}
		catch(Exception e)
		{
			out.println("<font color='red'>error</font>");
		}
		%>
		</td>
		<td bgcolor="#D3E6F3"  style="font-weight:bold;color:#006666">台半型號:</td>   
		<td><textarea cols="40" rows="5" name="ITEM"><%=ITEM%></textarea></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">LOT Number:</td> 
		<td><textarea cols="40" rows="5" name="LOT_NUMBER"><%=LOT_NUMBER%></textarea></td>
	    <td bgcolor="#D3E6F3" style="font-weight:bold;color:#006666">Date Code:</td> 
		<td><textarea cols="20" rows="5" name="DATE_CODE"><%=DATE_CODE%></textarea></td>
	</tr>
</table>
<table border="0" width="100%">
	<tr>
		<td align="center">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCSGStockInterOrgTransfer.jsp")' > 
		</td>
   </tr>
</table>  
<hr>
<%
try
{       	 
	int iCnt = 0;
	if (ATYPE.equals("Q"))
	{
		sql = " SELECT X.*,X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY) ONHAND "+
			  " FROM (SELECT A.SG_STOCK_ID"+
			  "       ,A.ORGANIZATION_ID"+
			  "       ,CASE A.ORGANIZATION_ID WHEN 907 THEN '內銷' WHEN 908 THEN '外銷' ELSE '??' END AS organization_name"+
			  "       ,TRUNC(SYSDATE)-TRUNC(A.RECEIVED_DATE) STOCK_AGE"+
			  "       ,A.INVENTORY_ITEM_ID ITEM_ID"+
			  "       ,A.ITEM_NAME"+
			  "       ,A.ITEM_DESC"+
			  "       ,A.SUBINVENTORY_CODE"+
			  "       ,A.LOT_NUMBER"+
			  "       ,A.DATE_CODE"+
			  "       ,NVL(A.RECEIVED_QTY,0)/1000 RECEIVED_QTY"+
			  "       ,NVL(A.ALLOCATE_IN_QTY,0)/1000 ALLOCATE_IN_QTY"+
			  "       ,NVL(A.RETURN_QTY,0)/1000 RETURN_QTY"+
			  "       ,NVL(A.ALLOCATE_OUT_QTY,0)/1000 ALLOCATE_OUT_QTY"+
			  "       ,NVL(A.SHIPPED_QTY,0)/1000 SHIPPED_QTY"+
			  "       ,NVL((SELECT SUM(TPCL.QTY) QTY FROM TSC_PICK_CONFIRM_LINES TPCL,TSC_PICK_CONFIRM_HEADERS TPCH WHERE TPCL.ORGANIZATION_ID IN (907,908) AND TPCH.PICK_CONFIRM_DATE IS NULL AND TPCH.ADVISE_HEADER_ID=TPCL.ADVISE_HEADER_ID AND TPCL.SG_STOCK_ID=A.SG_STOCK_ID),0)/1000 PICK_QTY"+
			  "       ,TO_CHAR(A.RECEIVED_DATE,'YYYY/MM/DD') RECEIVED_DATE"+
			  "       ,B.NOTE_TO_RECEIVER"+
			  "       ,A.VENDOR_CARTON_NO"+
			  "       ,D.SEGMENT1 PO_NO"+
			  "       ,D.CURRENCY_CODE"+
			  "       ,C.LINE_NUM"+
			  "       ,TO_CHAR(B.NEED_BY_DATE,'YYYY/MM/DD') NEED_BY_DATE"+
			  "       ,A.VENDOR_SITE_ID"+
			  "       ,A.VENDOR_SITE_CODE"+
			  //"       ,NVL(A.CUST_PARTNO,NVL(TRIM(REPLACE(REPLACE(CASE INSTR(C.NOTE_TO_VENDOR,'加貼') WHEN 1 THEN NULL WHEN 0 THEN C.NOTE_TO_VENDOR ELSE SUBSTR(C.NOTE_TO_VENDOR,1,INSTR(C.NOTE_TO_VENDOR,'加貼')-1) END,',',''),'，',''))"+
			  "       ,NVL(A.CUST_PARTNO,NVL(TSSG_SHIP_PKG.GET_PO_CUST_ITEM(C.NOTE_TO_VENDOR)"+ //modify by Peggy 20230607
			  "       ,CASE WHEN B.NOTE_TO_RECEIVER IS NOT NULL THEN (SELECT  decode(y.item_identifier_type,'CUST',y.ordered_item,'')"+
			  "       FROM ont.oe_order_headers_all x,ont.oe_order_lines_all y"+
			  "       WHERE x.org_id= CASE WHEN SUBSTR(B.NOTE_TO_RECEIVER,1,1)<>'8' THEN 41 ELSE 906 END"+
			  "       AND x.header_id=y.header_id"+
			  "       AND y.packing_instructions='T'"+
			  "       AND x.order_number= SUBSTR(B.NOTE_TO_RECEIVER,1,INSTR(B.NOTE_TO_RECEIVER,'.')-1)"+
			  "       AND y.shipment_number=1 and y.line_number=SUBSTR(B.NOTE_TO_RECEIVER,INSTR(B.NOTE_TO_RECEIVER,'.')+1))"+
			  "       ELSE '' END)) PO_CUST_PARTNO"+
			  "       ,A.CREATED_BY"+
			  "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,1100000003) TSC_PROD_GROUP"+
			  "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,21) TSC_FAMILY"+
			  "       ,TSC_INV_CATEGORY(A.INVENTORY_ITEM_ID,43,23) TSC_PACKAGE "+   
			  "       ,CASE A.ORGANIZATION_ID WHEN 907 THEN 908 WHEN 908 THEN 907 ELSE 0 END AS to_organization_id"+
			  "       ,CASE A.ORGANIZATION_ID WHEN 907 THEN '外銷' WHEN 908 THEN '內銷' ELSE '??' END AS to_organization_name"+
			  "       FROM ORADDMAN.TSSG_STOCK_OVERVIEW A"+
			  "       ,PO.PO_LINE_LOCATIONS_ALL B"+
			  "       ,PO.PO_LINES_ALL C"+
			  "       ,PO.PO_HEADERS_ALL D"+
			  "       WHERE A.PO_LINE_LOCATION_ID=B.LINE_LOCATION_ID(+)"+
			  "       AND B.PO_LINE_ID=C.PO_LINE_ID(+)"+
			  "       AND A.PO_HEADER_ID=D.PO_HEADER_ID(+)"+
			  "       AND A.SUBINVENTORY_CODE='01') X "+
			  "       WHERE 1=1";
		if (!ORGCODE.equals("") && !ORGCODE.equals("--"))
		{
			sql += " AND X.ORGANIZATION_ID = '"+ ORGCODE+"'";
		}
		if (!SUPPLIER.equals("") && !SUPPLIER.equals("--"))
		{
			sql += " AND X.VENDOR_SITE_ID = '"+ SUPPLIER+"'";
		}	
		if (!ITEM.equals(""))
		{
			String [] sArray = ITEM.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and X.ITEM_DESC in ('"+sArray[x].trim()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim()+"'";
				}
			}
			if (sArray.length>0) sql += ")";			
		}			
	
		if (!LOT_NUMBER.equals(""))
		{
			String [] sArray = LOT_NUMBER.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and X.LOT_NUMBER in ('"+sArray[x].trim()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim()+"'";
				}
			}
			if (sArray.length>0) sql += ")";
			
		}	

		if (!DATE_CODE.equals(""))
		{
			String [] sArray = DATE_CODE.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and X.DATE_CODE in ('"+sArray[x].trim()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim()+"'";
				}
			}
			if (sArray.length>0) sql += ")";
		}	
	
		sql += " AND X.RECEIVED_QTY+X.ALLOCATE_IN_QTY-(X.ALLOCATE_OUT_QTY+X.RETURN_QTY+X.SHIPPED_QTY+X.PICK_QTY)>0"+
			   " ORDER BY X.STOCK_AGE,X.ORGANIZATION_ID,X.ITEM_DESC,X.RECEIVED_DATE,X.LOT_NUMBER,X.DATE_CODE,NVL(X.VENDOR_CARTON_NO,'0')";
		//out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		while (rs.next()) 
		{ 	
			iCnt++;
			if (iCnt ==1)
			{
			%>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" borderColorLight="#CFDAD8"  bordercolordark="#5C7671">
				<tr bgcolor="#C9E2D0"> 
					<td width="8%" style="color:#006666" align="center">供應商</td>
					<td width="15%" style="color:#006666" align="center">料號</td>
					<td width="15%" style="color:#006666" align="center">型號</td>            
					<td width="15%" style="color:#006666" align="center">LOT</td>            
					<td width="6%" style="color:#006666" align="center">D/C</td>
					<td width="5%" style="color:#006666" align="center">庫存量(K)</td>            
					<td width="5%" style="color:#006666" align="center">來源Org</td>
					<td width="5%" style="color:#006666" align="center">來源倉別</td>            
					<td width="5%" style="color:#006666" align="center">目的Org</td>
					<td width="5%" style="color:#006666" align="center">目的倉別</td>            
					<td width="3%" align="center"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="5%" style="color:#006666" align="center">調撥量(K)</td>            
					<td width="6%" style="color:#006666" align="center">調撥原因</td>
				</tr>
			<% 
			}
			%>
			<tr id="tr_<%=rs.getString("SG_STOCK_ID")%>">
				<td><font style="font-size:12px"><%=(rs.getString("VENDOR_SITE_CODE")==null?"&nbsp;":rs.getString("VENDOR_SITE_CODE"))%></font></td>
				<td style="font-size:12px"><%=rs.getString("ITEM_NAME")%></td>
				<td style="font-size:12px"><%=rs.getString("ITEM_DESC")%></td>
				<td><%=rs.getString("LOT_NUMBER")%></td>
				<td><%=rs.getString("DATE_CODE")%></td>
				<td align="right" style="color:#000000;font-weight:bold"><%=(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("ONHAND")))%><input type="hidden" name="ONHAND_<%=rs.getString("SG_STOCK_ID")%>" value="<%=rs.getString("ONHAND")%>"></td>
				<td align="center"><%=rs.getString("ORGANIZATION_NAME")%></td>
				<td align="center"<%=(rs.getString("SUBINVENTORY_CODE").equals("02")?"style='font-weight:bold'":"")%>><%=rs.getString("SUBINVENTORY_CODE")%></td>
				<td align="center"><%=rs.getString("TO_ORGANIZATION_NAME")%><input type="hidden" name="TO_ORG_<%=rs.getString("SG_STOCK_ID")%>" value="<%=rs.getString("TO_ORGANIZATION_ID")%>"></td>
				<td align="center"><input type="text" name="TO_SUBINV_<%=rs.getString("SG_STOCK_ID")%>"  size="6" value="<%=rs.getString("SUBINVENTORY_CODE")%>" style="text-align:center;font-family: Tahoma,Georgia;font-size:12px" readonly></td>
				<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("SG_STOCK_ID")%>" onClick="setCheck(<%=iCnt%>)" ></td>
				<td align="center"><input type="text" name="TO_TRANFER_QTY_<%=rs.getString("SG_STOCK_ID")%>"  size="8" value="" style="color:#0000FF;font-weight:bold;text-align:right;font-family: Tahoma,Georgia;font-size:12px" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57 || event.keyCode ==46)" disabled></td>
				<td align="center"><input type="text" name="remark_<%=rs.getString("SG_STOCK_ID")%>"  size="15" value="" style="font-family: Tahoma,Georgia;font-size:12px" disabled="disabled"></td>
			</tr>
	<%
		}
		rs.close();
		statement.close();
		
		if (iCnt==0)
		{
			out.println("<div align='center'><font color='red' size='2' face='新細明體'><strong>查無資料,請重新篩選查詢條件,謝謝!</strong></font></div>");
		}
		else
		{
	%>
		</table><P>
		<table width="100%">
			<tr><td align="center"><input type="button" name="save" value="Submit" style="font-family: Tahoma,Georgia;" onClick="setSubmit1('../jsp/TSCSGPOReceiveProcess.jsp?TRANSTYPE=ALLOCATE')"></td></tr>
		</table>
	<%
		}
	}
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
</FORM>
<BR>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

