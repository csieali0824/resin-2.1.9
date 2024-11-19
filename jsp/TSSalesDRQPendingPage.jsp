<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*"%>
<html>
<head>
<title>Sales Delivery Request Data Edit Page for Assign</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DEstimateFactoryBean" scope="session" class="Array2DimensionInputBean"/>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; font-size: 11x ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.DISPLAYREPAIR.chk.length != undefined)
	{
		for (var i =1 ; i <= document.DISPLAYREPAIR.chk.length ;i++)
		{
			document.DISPLAYREPAIR.chk[i-1].checked= document.DISPLAYREPAIR.chkall.checked;
			setCheck(i);
		}
	}
	else
	{
		document.DISPLAYREPAIR.chk.checked = document.DISPLAYREPAIR.chkall.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	var lineid="";
	if (document.DISPLAYREPAIR.chk.length != undefined)
	{
		chkflag = document.DISPLAYREPAIR.chk[irow-1].checked; 
		lineid = document.DISPLAYREPAIR.chk[irow-1].value;
	}
	else
	{
		chkflag = document.DISPLAYREPAIR.chk.checked; 
		lineid = document.DISPLAYREPAIR.chk.value;
	}
	if (chkflag == true)
	{
		document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].disabled = false;
		document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].disabled = false;
		document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].disabled = false;
		document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].disabled = false;
		document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value = "";
		document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value = "";
		document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value = "";
		document.getElementById("tr"+lineid).style.backgroundColor ="#daf1a9";
		//document.DISPLAYREPAIR.elements["popcal"+lineid].width=20;
		document.getElementById("popcal"+lineid).style.width=20;
	}
	else
	{
		document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].disabled = true;
		document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].disabled = true;
		document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].disabled = true;
		document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].disabled = true;
		document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value = "";
		document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value = "";
		document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value = "";
		document.getElementById("tr"+lineid).style.backgroundColor ="#ffffff";
		//document.DISPLAYREPAIR.elements["popcal"+lineid].width=0;
		document.getElementById("popcal"+lineid).style.width=0;
	}
}
function setSubmit(URL)
{
	var chkflag ="";
	var lineid="";
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var MOQ=0,noremark_cnt=0,qty_cnt=0;	
	//add by Peggy 20160804
	if (document.DISPLAYREPAIR.ACTIONID.value =="--" || document.DISPLAYREPAIR.ACTIONID.value=="")
	{
		document.DISPLAYREPAIR.ACTIONID.focus();
		alert("請選擇執行動作!!");
		return false;	
	}
	if (document.DISPLAYREPAIR.chk.length != undefined)
	{
		iLen = document.DISPLAYREPAIR.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i =1 ; i <= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.DISPLAYREPAIR.chk.checked;
			lineid = document.DISPLAYREPAIR.chk.value;
		}
		else
		{
			chkvalue = document.DISPLAYREPAIR.chk[i-1].checked;
			lineid = document.DISPLAYREPAIR.chk[i-1].value;
		}
		if (chkvalue==true)
		{	
			if (document.DISPLAYREPAIR.ACTIONID.value!="005")
			{
				if (document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value!=null && document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value!="")
				{
					if (parseFloat(document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value)>0)
					{
						if (document.DISPLAYREPAIR.elements["SLOWSEQID"+lineid].value==null || document.DISPLAYREPAIR.elements["SLOWSEQID"+lineid].value=="")  //add by Peggy 20230203
						{
							alert("項次:"+lineid+" 未指定銷庫存明細!!");
							return false;					
						}
					}
				}
				if (document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].value ==null || document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].value=="")
				{
					document.DISPLAYREPAIR.elements["SHIPDATE"+lineid].focus();
					alert("項次:"+lineid+" 交貨日期不可空白!!");
					return false;			
				}
				if (document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value==null || document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value=="" || document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value==null && document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value=="")
				{
					alert("項次:"+lineid+" 請輸入Slow Moving Qty!!");
					document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].focus();
					return false;			
				}
				else
				{
					if (document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value!=null && document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value!="")
					{
						if (parseFloat(document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value)>parseFloat(document.DISPLAYREPAIR.elements["QTY_"+lineid].value))
						{
							document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].focus();
							alert("項次:"+lineid+" Slow Moving Qty不可大於原RFQ數量!!");
							return false;			
						}
						else if (parseFloat(document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value)<0)
						{
							document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].focus();
							alert("項次:"+lineid+" Slow Moving Qty不可小於0!!");
							return false;			
						}
					}
					else if (document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value!=null && document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value!="")
					{
						if (parseFloat(document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value)>parseFloat(document.DISPLAYREPAIR.elements["QTY_"+lineid].value))
						{
							document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].focus();
							alert("項次:"+lineid+" RFQ QTY不可大於原RFQ數量!!");
							return false;			
						}
						else if (parseFloat(document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value)>0 && parseFloat(document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value)< parseFloat(document.DISPLAYREPAIR.elements["SPQ_"+lineid].value))
						{
							document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].focus();
							alert("項次:"+lineid+" RFQ QTY不可小於SPQ:"+document.DISPLAYREPAIR.elements["SPQ_"+lineid].value+"數量!!");
							return false;			
						}
						else if (parseFloat(document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value)<0)
						{
							document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].focus();
							alert("項次:"+lineid+" RFQ QTY不可小於0!!");
							return false;			
						}
					}
				}
			}
			else
			{
				if (document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value!=null && document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value!="")
				{
					if (parseFloat(document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value)>0)
					{
						qty_cnt++;
					}
				}
				if (document.DISPLAYREPAIR.elements["IDLE_REMARK"+lineid].value=="")
				{	
					noremark_cnt ++;
				}
			}
			chkcnt++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}	

 	if (document.DISPLAYREPAIR.ACTIONID.value=="005" && document.DISPLAYREPAIR.REJ_REASON.value=="")
	{
		if (qty_cnt>0)
		{
			alert("有RFQ數量,不允許Reject!!");
			return false;			
		}
		if (noremark_cnt>0)
		{
			document.DISPLAYREPAIR.REJ_REASON.focus();
			alert("請輸入REJECT原因!!");
			return false;	
		}
	}	

	document.DISPLAYREPAIR.submit1.disabled=true;
	document.DISPLAYREPAIR.action=URL;
	document.DISPLAYREPAIR.submit();
}
function showIdleStockInfo(itemname,itemdesc,custid,SREGION,chkline)
{     
	subWin=window.open("../jsp/TscSlowMovingQueryAll.jsp?TSCDESC="+itemname+"&ITEMDESC="+itemdesc+"&QTYPE=sub&CUSTNO="+custid+"&SREGION="+SREGION+"&CHKLINE="+chkline,"subwin","width=1100,height=350,toolbar=no,location=no,resizable=yes,scrollbars=yes,menubar=no");    	
}
function compute(stype,lineid)
{
	var RFQ=document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value;
	if (RFQ == null || RFQ =="") RFQ="0";
	var IDLE=document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value;
	if (IDLE == null || IDLE =="") IDLE="0";
	if (stype=="RFQ")
	{
		document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value=((parseFloat(document.DISPLAYREPAIR.elements["QTY_"+lineid].value)*1000)-(parseFloat(RFQ)*1000))/1000;
		if (document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value==null || document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value=="")
		{
			document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value="0";
		}
	}
	else if (stype=="IDLE")
	{
		document.DISPLAYREPAIR.elements["RFQ_QTY"+lineid].value=((parseFloat(document.DISPLAYREPAIR.elements["QTY_"+lineid].value)*1000)-(parseFloat(IDLE)*1000))/1000;
		if (document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value==null || document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value=="")
		{
			document.DISPLAYREPAIR.elements["IDLE_QTY"+lineid].value="0";
		}
	}
}
function setOPTValue()
{
	if (document.DISPLAYREPAIR.ACTIONID.value=="005")
	{
		document.getElementById("span2").style.visibility ="visible";
		document.DISPLAYREPAIR.REJ_REASON.value="";
	}
	else
	{
		document.getElementById("span2").style.visibility ="hidden";
		document.DISPLAYREPAIR.REJ_REASON.value="";
	}
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<%
String dnDocNo=request.getParameter("DNDOCNO");
String line_No=request.getParameter("LINENO");
String actionID = request.getParameter("ACTIONID");  
String sql ="";   
%>
<body>
<%@ include file="/jsp/include/TSDocHyperLinkPage.jsp"%>
<FORM NAME="DISPLAYREPAIR" ACTION="../jsp/TSSalesDRQSlowMovingProcess.jsp" METHOD="post">
<%@ include file="/jsp/include/TSDRQBasicInfoDisplayPage.jsp"%>
<HR>
<table border="1" cellpadding="1" cellspacing="0" align="center" width="97%" bordercolor="#64698C"  bordercolorlight="#ffffff" bordercolordark="#ccc999" bgcolor="#DFE3EA">
	<tr>
		<td colspan="17"><jsp:getProperty name="rPH" property="pgProcess"/><jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/></td>
	</tr>
<%
	sql = " SELECT a.dndocno, a.line_no, a.inventory_item_id, a.item_segment1,a.ASSIGN_MANUFACT,"+
		  " a.quantity, a.uom, substr(a.request_date,1,8) request_date ,a.line_type,  nvl(a.selling_price,0) selling_price, "+
		  " a.item_description,a.ordered_item, a.ordered_item_id, a.item_id_type,"+
		  " a.tsc_prod_group,  a.spq, a.moq,substr(a.cust_request_date,1,8) cust_request_date, nvl(d.shipping_method,a.shipping_method) shipping_method,"+
		  " a.order_type_id,a.cust_po_line_no,b.ORDER_NUM,a.fob,  "+
		  " NVL(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,49,'TSC_Package'),TSC_OM_CATEGORY(INVENTORY_ITEM_ID,43,'TSC_Package')) as TSC_PACKAGE"+
		  ",mod(a.quantity ,a.spq) spq_value,case when a.quantity <a.moq then 1 else 0 end as moq_value"+
		  ",a.CUST_PO_NUMBER"+
		  ",a.orderno"+
		  ",a.quote_number"+
		  ",a.REMARK"+  
		  ",c.customer_number END_CUSTOMER_ID,a.END_CUSTOMER"+
		  ",a.tsc_desc"+
		  ",a.CURR"+
		  ",nvl(a.selling_price,0)*a.quantity*1000 amt"+
		  ",e.ALNAME"+ //add by Peggy 20221230
		  ",(SELECT COUNT (1) FROM oraddman.tsc_idle_stock_detail x WHERE  EXISTS (SELECT 1 FROM oraddman.tsc_idle_stock_header b WHERE b.version_id = x.version_id  AND b.version_flag = 'A') and x.item_desc1 = a.TSC_desc) idle_cnt"+
		  //" FROM (select a.*,c.CURR,c.order_type_id order_type_id1,CASE WHEN INSTR (a.item_description, '-') > 0 THEN SUBSTR (a.item_description,0,INSTR (a.item_description, '-') - 1) ELSE SUBSTR (a.item_description,0, LENGTH (a.item_description)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END AS TSC_desc"+
		  " FROM (select a.*,c.CURR,c.order_type_id order_type_id1,CASE WHEN INSTR (a.item_description, '-') > 0 THEN SUBSTR (a.item_description,0,INSTR (a.item_description, '-') - 1) ELSE case when apps.tsc_get_item_packing_code (49,inventory_item_id) in ('QQ','QQG') THEN a.item_description ELSE SUBSTR (a.item_description,0, LENGTH (a.item_description)- LENGTH (apps.tsc_get_item_packing_code (49,inventory_item_id)) - 1) END END AS TSC_desc"+
          " from oraddman.tsdelivery_notice_detail a,oraddman.tsdelivery_notice c where a.dndocno = c.dndocno) a"+
		  ",(select distinct SAREA_NO,OTYPE_ID,ORDER_NUM FROM oraddman.tsarea_ordercls) b"+
		  ",ar_customers c"+
		  ",ASO_I_SHIPPING_METHODS_V d"+
		  ",oraddman.tssales_area e"+
		  " where a.dndocno =? "+
		  " and b.SAREA_NO=?"+
		  " and nvl(a.order_type_id,a.order_type_id1)= b.OTYPE_ID(+)"+
		  " and a.END_CUSTOMER_ID=c.customer_id(+)"+
		  " and nvl( a.shipping_method,'') = d.shipping_method_code(+)"+
		  " and a.LSTATUSID=?"+
		  " and b.SAREA_NO=e.sales_area_no"+
		  " order by a.item_description,substr(a.request_date,1,8),to_number(a.line_no)";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,dnDocNo);
	statement.setString(2,tsAreaNo);
	statement.setString(3,frStatID);
	ResultSet rs=statement.executeQuery();
	int i =0;
	while(rs.next())
	{	
		i++;
		if (i==1)
		{
%>
	<tr valign="middle" height="30">
		<td width="2%" align="center"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
		<td width="7%" align="center"><jsp:getProperty name="rPH" property="pgDeliveryDate"/></td>
		<td width="5%" align="center">Slow Moving</td>
		<td width="7%" align="center">Slow Moving Qty(K)</td>
		<td width="7%" align="center">Slow Moving <jsp:getProperty name="rPH" property="pgDesc"/></td>
		<td width="6%" align="center">RFQ Qty(K)</td>
		<td width="2%"><jsp:getProperty name="rPH" property="pgAnItem"/></td>
		<td width="13%"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></td>
		<td width="10%"><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/></td>
		<td width="7%"><jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgDesc"/></td>
		<td width="6%"><jsp:getProperty name="rPH" property="pgRequestDate"/></td>
		<td width="8%" align="center"><jsp:getProperty name="rPH" property="pgQty"/><jsp:getProperty name="rPH" property="pgUOM"/><br><font color="#0000ff"><jsp:getProperty name="rPH" property="pgKPC"/></font></td>
		<td width="6%" align="center"><jsp:getProperty name="rPH" property="pgPrice"/><br>(<jsp:getProperty name="rPH" property="pgCurr"/>:<font color="#0000ff"><%=rs.getString("curr")%></font>)</td>
		<td width="7%"><jsp:getProperty name="rPH" property="pgRemark"/></td>
		<td width="7%"><jsp:getProperty name="rPH" property="pgCustPONo"/></td>
	</tr>
<%
		}
%>
	
	<tr style="background-color:#FFFFFF" id="tr<%=rs.getString("line_no")%>">
		<td align="center"><input type="checkbox" name="chk" value="<%=rs.getString("line_no")%>" onClick="setCheck('<%=""+i%>');"></td>
		<td align="center"><input type="text" name="SHIPDATE<%=rs.getString("line_no")%>" value="<%=rs.getString("request_date")%>" size="8"  style="font-family: Tahoma,Georgia;font-size:11px;" disabled onKeyPress="return (event.keyCode >= -1 && event.keyCode <=-1)"><A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.DISPLAYREPAIR.SHIPDATE<%=rs.getString("line_no")%>);return false;"><img id="popcal<%=rs.getString("line_no")%>" name="popcal<%=rs.getString("line_no")%>" border="0" WIDTH="0" src="../image/calbtn.gif"></A></td>
		<TD align="center"><a href="javaScript:showIdleStockInfo('<%=rs.getString("TSC_DESC")%>','<%=rs.getString("ITEM_DESCRIPTION")%>','<%=tsCustomerID%>','<%=rs.getString("ALNAME")%>','<%=i%>')"><image src="../image/light_yellow.gif" style="border:none"></a><input type="hidden" name="SLOWSEQID<%=rs.getString("line_no")%>" value=""></TD>		
		<td align="center"><input type="text" name="IDLE_QTY<%=rs.getString("line_no")%>" valu="" size="5" style="font-family: Tahoma,Georgia;font-size:11px;" onBlur="compute('IDLE','<%=rs.getString("line_no")%>')" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)" disabled></td>
		<td><input type="text" name="IDLE_REMARK<%=rs.getString("line_no")%>" valu="" size="16" style="font-family: Tahoma,Georgia;font-size:11px;" disabled></td>
		<td align="center"><input type="text" name="RFQ_QTY<%=rs.getString("line_no")%>" valu="" size="5" style="font-family: Tahoma,Georgia;font-size:11px;" onBlur="compute('RFQ','<%=rs.getString("line_no")%>')" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)" disabled></td>
		<td><%=rs.getString("line_no")%></td>
		<td><%=rs.getString("item_segment1")%></td>
		<td><%=rs.getString("item_description")%></td>
		<td><%=rs.getString("ordered_item")%></td>
		<td><%=rs.getString("request_date")%></td>
		<td><font style="text-align:right;width:30"><%=(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("quantity")))%></font>&nbsp;&nbsp;<font style="text-decoration:underline;font-weight:bold;font-family:arial;font-size:11px;	color=#0000ff;">MOQ:<%=rs.getString("moq")%>K</font><input type="hidden" name="QTY_<%=rs.getString("line_no")%>" value="<%=rs.getString("quantity")%>"><input type="hidden" name="SPQ_<%=rs.getString("line_no")%>" value="<%=rs.getString("SPQ")%>"></td>
		<td><font style="text-align:right;width:70"><%=(new DecimalFormat("####0.#####")).format(Float.parseFloat(rs.getString("amt")))%></font></td>
		<td><%=((rs.getString("REMARK")==null || rs.getString("REMARK").equals(""))?"&nbsp;":rs.getString("REMARK"))%></td>
		<td style="font-size:10px"><%=rs.getString("CUST_PO_NUMBER")%></td>
	</tr>
			
	
<%
	}
	rs.close();
	statement.close();
%>
</table>
<hr>
<table width="97%" border="0">
	<tr>
		<td>
		<strong><font color="#FF0000"><jsp:getProperty name="rPH" property="pgAction"/>-&gt;</font></strong> 
<%
try
{  
	Statement statement1=con.createStatement();
	ResultSet rs1=statement1.executeQuery("select x1.ACTIONID, x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 "+
							" WHERE FORMID='TS' AND FROMSTATUSID='"+frStatID+"' AND x1.ACTIONID=x2.ACTIONID "+
							" and  x1.LOCALE='"+locale+"' order by x2.ACTIONNAME desc ");
	comboBoxBean.setRs(rs1);
	comboBoxBean.setSelection(actionID);
	comboBoxBean.setOnChangeJS("setOPTValue()");
	comboBoxBean.setFieldName("ACTIONID");	
	comboBoxBean.setFontName("Tahoma,Georgia");   
	out.println(comboBoxBean.getRsString());
    rs1.close();       
	statement1.close();	
} //end of try
catch (Exception e)
{
	out.println("Exception11:"+e.getMessage());
}		
		%>
			&nbsp;&nbsp;&nbsp;<input type="button" name="submit1" value="Submit" onClick="setSubmit('../jsp/TSSalesDRQSlowMovingProcess.jsp')" style="font-family: Tahoma,Georgia;">
			<br>
			<span id="span2" style="visibility:hidden;font-size:12px">Reject Reason =></font>
  <input type="text"  name="REJ_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia;font-size:12px">
            </span> 
			
		</td>
	</tr>
</table>
<input type="hidden" size="10" name="SALESAREANO" value="<%=tsAreaNo%>">
<input type="hidden" name="DNDOCNO" value="<%=dnDocNo%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
