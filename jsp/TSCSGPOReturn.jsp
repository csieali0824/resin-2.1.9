<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11x }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11x } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Confirm for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck(i);
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
		document.MYFORM.elements["return_qty_"+lineid].style.backgroundColor ="#daf1a9";
		if (eval(document.MYFORM.elements["rcv_qty_"+lineid].value)<=eval(document.MYFORM.elements["onhand_"+lineid].value))
		{
			document.MYFORM.elements["return_qty_"+lineid].value = document.MYFORM.elements["rcv_qty_"+lineid].value;
			document.MYFORM.elements["return_qty_"+lineid].style.color="#0000FF";
		}
		else
		{
			document.MYFORM.elements["return_qty_"+lineid].value = document.MYFORM.elements["onhand_"+lineid].value;
			document.MYFORM.elements["return_qty_"+lineid].style.color="#ff0000";
		}
		document.MYFORM.elements["return_reason_"+lineid].style.backgroundColor ="#daf1a9";
		
	}
	else
	{
		document.getElementById("tr_"+lineid).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["return_qty_"+lineid].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["return_qty_"+lineid].value="";
		document.MYFORM.elements["return_reason_"+lineid].style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["return_reason_"+lineid].value="";
	}
}
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="";
	if (document.MYFORM.chk.length != undefined)
	{
		chk_len = document.MYFORM.chk.length;
	}
	else
	{
		chk_len = 1;
	}

	for (var i =0 ; i < chk_len ;i++)
	{
		if (chk_len==1)
		{
			chkflag = document.MYFORM.chk.checked; 
			id = document.MYFORM.chk.value;		
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
			id = document.MYFORM.chk[i].value;		
		}
		if (eval(document.MYFORM.elements["return_qty_"+id].value)==0)
		{
			alert("The return Qty must be granter than zero!");
			document.MYFORM.elements["return_qty_"+id].focus();
			return false;
		}
		else if (eval(document.MYFORM.elements["return_qty_"+id].value)>eval(document.MYFORM.elements["rcv_qty_"+id].value) || eval(document.MYFORM.elements["return_qty_"+id].value)>eval(document.MYFORM.elements["onhand_"+id].value))
		{
			alert("The return Qty error!");
			document.MYFORM.elements["return_qty_"+id].focus();
			return false;
		}
		if (chkflag==true) chkcnt ++;
	}
	if (chkcnt ==0)
	{
		alert("Please select process data!");
		return false;
	}
	if (document.MYFORM.ACTIONTYPE.value==""||document.MYFORM.ACTIONTYPE.value=="--")
	{
		alert("Please choose action type!");
		document.MYFORM.ACTIONTYPE.focus();
		return false;	
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;	
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
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
function chgObj(objvalue)
{
	if (objvalue!="")
	{
		document.MYFORM.YEARFR.value = "--";
		document.MYFORM.MONTHFR.value = "--";
		document.MYFORM.DAYFR.value = "--";
		document.MYFORM.YEARTO.value = "--";
		document.MYFORM.MONTHTO.value = "--";
		document.MYFORM.DAYTO.value = "--";	
		document.MYFORM.EYEARFR.value = "--";
		document.MYFORM.EMONTHFR.value = "--";
		document.MYFORM.EDAYFR.value = "--";
		document.MYFORM.EYEARTO.value = "--";
		document.MYFORM.EMONTHTO.value = "--";
		document.MYFORM.EDAYTO.value = "--";	
	}
}
</script>
<%
String sql = "";
String RECEIVE_DATE=request.getParameter("RECEIVE_DATE");
if (RECEIVE_DATE==null) RECEIVE_DATE="";
String RECEIPT_NUM=request.getParameter("RECEIPT_NUM");
if (RECEIPT_NUM==null) RECEIPT_NUM="";
String ORGCODE=request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String VENDOR_NAME = request.getParameter("VENDOR_NAME");
if (VENDOR_NAME==null) VENDOR_NAME="";
String ACTIONTYPE=request.getParameter("ACTIONTYPE");
if (ACTIONTYPE==null) ACTIONTYPE="RETURN TO VENDOR";
String STATUS="CLOSED",id="";
String LOT_NUMBER=request.getParameter("LOT_NUMBER");
if (LOT_NUMBER==null) LOT_NUMBER="";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr=dateBean.getYearString();
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr=dateBean.getMonthString();
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr=dateBean.getDayString();;
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo="--"; 
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo="--";
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo="--";
if (YearFr.equals("--") && MonthFr.equals("--") && DayFr.equals("--") && YearTo.equals("--") && MonthTo.equals("--") && DayTo.equals("--") && ORGCODE.equals("--") && LOT_NUMBER.equals("") && VENDOR_NAME.equals("--") && RECEIPT_NUM.equals("--") && ITEMDESC.equals(""))
{
	YearFr =dateBean.getYearString();
	MonthFr =dateBean.getMonthString();
	DayFr =dateBean.getDayString();
}

int rowcnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSCSGPOReturn.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">SG PO Return </div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#DAF0FC">
	<tr>
		<td width="5%" style="font-family:Tahoma,Georgia;font-size:11px">內外銷:</td>   
		<td width="6%">
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
		<!--<select NAME="ORGCODE" style="font-size:11px;font-family:Tahoma,Georgia;">
		<OPTION VALUE=-- <%if (ORGCODE.equals("")) out.println("selected");%>>--</OPTION>
		<OPTION VALUE="887" <%if (ORGCODE.equals("907")) out.println("selected");%>>SG1</OPTION>
		</select>-->
		</td>
		<td width="6%" style="font-family:Tahoma,Georgia;font-size:11px">Receive Date:</td>   
		<td width="12%" colspan="3">
<%
	String CurrYear = null;	 
	try
    {       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2020+1];
		for (int i = 2020; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
		if (YearFr==null)
		{
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(YearFr);
		}
		arrayComboBoxBean.setFieldName("YEARFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
		  
	String CurrMonth = null;	     		 
	try
    {  
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}
		arrayComboBoxBean.setArrayString(b);
	  	if (MonthFr==null)
	  	{
			CurrMonth=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonth);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthFr);
	  	}
		arrayComboBoxBean.setFieldName("MONTHFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
    catch (Exception e)
    {
    	out.println("Exception2:"+e.getMessage());
    }

	String CurrDay = null;	     		 
	try
	{       
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(c);
		if (DayFr==null)
		{
			CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(DayFr);
		}
		arrayComboBoxBean.setFieldName("DAYFR");	   
		out.println(arrayComboBoxBean.getArrayString());		      		 
	} 
	catch (Exception e)
	{
		out.println("Exception3:"+e.getMessage());
	}	
%>
		~</strong></font><br>
<%
	String CurrYearTo = null;	     		 
	try
    {  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2020+1];
		for (int i = 2020; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
		arrayComboBoxBean.setArrayString(a);
	  	if (YearTo==null)
	  	{
			CurrYearTo=dateBean.getYearString();
			arrayComboBoxBean.setSelection(CurrYearTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(YearTo);
	  	}
		arrayComboBoxBean.setFieldName("YEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
	}
    catch (Exception e)
    {
    	out.println("Exception4:"+e.getMessage());
    }
	
	String CurrMonthTo = null;	     		 
	try
    {   
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}
		arrayComboBoxBean.setArrayString(b);
	  	if (MonthTo==null)
	  	{
			CurrMonthTo=dateBean.getMonthString();
			arrayComboBoxBean.setSelection(CurrMonthTo);
	  	} 
	  	else 
	  	{
			arrayComboBoxBean.setSelection(MonthTo);
	  	}
		arrayComboBoxBean.setFieldName("MONTHTO");	   
		out.println(arrayComboBoxBean.getArrayString());		    
	}
	catch (Exception e)
	{
		out.println("Exception5:"+e.getMessage());
	}
	
	String CurrDayTo = null;	     		 
	try
    {     
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(c);
		if (DayTo==null)
		{
			CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(DayTo);
		}
		arrayComboBoxBean.setFieldName("DAYTO");	   
    	out.println(arrayComboBoxBean.getArrayString());	
	}
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
%>    
		</td>  
		
		<td width="8%" style="font-family:Tahoma,Georgia;font-size:11px">Receipt Num ：</td>
		<td width="10%"><input type="text" name="RECEIPT_NUM" value="<%=RECEIPT_NUM%>" style="font-family:Tahoma,Georgia;font-size:11px" size="10" onChange="chgObj(this.form.RECEIPT_NUM.value);">
		<%
		/*try
		{   
			sql = "select distinct a.receipt_num,a.receipt_num receipt_num1 "+
			      " from oraddman.tssg_po_receive_detail a"+
			      ",po.rcv_shipment_headers b"+
				  " where a.receipt_num=b.receipt_num"+
				  " and not exists (select 1 from apps.tsc_export_to_eform c where c.export_data_no=b.waybill_airbill_num and c.export_flag='Y')"+
				  " and a.status ='"+STATUS+"'"+
				  " order by receipt_num";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(RECEIPT_NUM);
			comboBoxBean.setFieldName("RECEIPT_NUM");	
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}*/		
		%>
		</td>		
		<td width="8%" style="font-family:Tahoma,Georgia;font-size:11px">Vendor Name：</td>
		<td width="12%">
		<%
		try
		{   
			sql = " select distinct vendor_name,vendor_name vendor_name1 from oraddman.tssg_po_receive_detail where status ='"+STATUS+"' order by vendor_name";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(VENDOR_NAME);
			comboBoxBean.setFieldName("VENDOR_NAME");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>			
		</td>
		<td width="6%" style="font-family:Tahoma,Georgia;font-size:11px">Item Desc：</td> 
		<td width="7%"><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" style="font-family:Tahoma,Georgia;font-size:11px" size="10"></td>
		<td width="6%" style="font-family:Tahoma,Georgia;font-size:11px">Lot Number：</td> 
		<td width="7%"><input type="text" name="LOT_NUMBER" value="<%=LOT_NUMBER%>" style="font-family:Tahoma,Georgia;font-size:11px" size="10"></td>
	</tr>
</TABLE>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setQuery('../jsp/TSCSGPOReturn.jsp')">&nbsp;&nbsp;
		</DIV>
        <HR>
<%
try
{
	sql = " SELECT a.rcv_group_id"+
	      ",a.po_header_id"+
		  ",a.po_line_id"+
		  ",a.po_line_location_id"+
		  ",a.lot_number"+
		  ",a.date_code"+
		  ",a.rcv_qty/1000 rcv_qty"+
		  ",a.po_no"+
		  ",a.vendor_name"+
		  ",a.inventory_item_id"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",to_char(a.receive_date,'yyyy/mm/dd') receive_date"+
		  ",a.inspect_result"+
		  ",a.inspect_reason"+
		  ",a.inspect_remark"+
		  ",a.receipt_num"+
		  ",a.organization_id"+
		  ",a.vendor_site_id"+
		  ",a.status"+
		  ",b.organization_code"+
		  ",a.receive_trx_id"+
		  ",a.rcv_deliver_trx_id"+
   		  ",case b.organization_code when 'SG1' then '內銷' when 'SG2' then '外銷' else b.organization_code end as organization_name"+
		  ",d.vendor_site_code"+
		  ",tsc_inv_category(a.inventory_item_id,43,1100000003) tsc_prod_group"+
		  ",nvl(moq.TRANSACTION_QUANTITY / case when moq.TRANSACTION_UOM_CODE='PCE' then 1000 else 1 end,0) onhand"+
		  ",to_char(plla.need_by_date,'yyyy/mm/dd') need_by_date"+
		  ",(SELECT SUM(tpcl.QTY/ CASE WHEN tsal.UOM='PCE' then 1000 else 1 end) QTY FROM TSC.TSC_PICK_CONFIRM_HEADERS tpch,TSC.TSC_PICK_CONFIRM_LINES tpcl,ORADDMAN.TSSG_STOCK_OVERVIEW tso,TSC_SHIPPING_ADVISE_LINES tsal"+
          "  WHERE tpch.PICK_CONFIRM_DATE IS NULL"+
		  "  AND tpcl.ORGANIZATION_ID IN (907,908)"+
          "  AND tpch.ADVISE_HEADER_ID=tpcl.ADVISE_HEADER_ID"+
		  "  AND tpch.ADVISE_HEADER_ID=tsal.ADVISE_HEADER_ID"+
		  "  AND tpcl.ADVISE_LINE_ID=tsal.ADVISE_LINE_ID"+
          "  AND tpcl.SG_STOCK_ID=tso.SG_STOCK_ID"+
          "  AND tso.VENDOR_SITE_ID=a.VENDOR_SITE_ID"+
          "  AND tso.ORGANIZATION_ID=a.ORGANIZATION_ID"+
          "  AND tso.INVENTORY_ITEM_ID=a.INVENTORY_ITEM_ID"+
          "  AND tso.SUBINVENTORY_CODE=a.SUBINVENTORY_CODE"+
          "  AND tso.LOT_NUMBER=a.LOT_NUMBER"+
          "  AND tso.DATE_CODE=a.DATE_CODE"+
          "  AND tso.PO_LINE_LOCATION_ID=a.PO_LINE_LOCATION_ID"+
          "  AND TRUNC(tso.RECEIVED_DATE)=TRUNC(a.RECEIVE_DATE)"+
          "  AND NVL(tso.VENDOR_CARTON_NO,'-999')=NVL(a.VENDOR_CARTON_NO,'-999')"+
          "  AND tso.RECEIPT_NUM=a.RECEIPT_NUM) PICK_QTY"+
		  ",pha.AUTHORIZATION_STATUS"+ //add by Peggy 20210712
          " FROM oraddman.tssg_po_receive_detail a"+
		  ",mtl_parameters b"+
		  ",po.rcv_shipment_headers c"+
		  ",ap_supplier_sites_all d"+
		  ",po.rcv_transactions rcv"+
		  ",(select inventory_item_id,organization_id,subinventory_code,lot_number,TRANSACTION_UOM_CODE,sum(TRANSACTION_QUANTITY) TRANSACTION_QUANTITY from inv.mtl_onhand_quantities_detail group by inventory_item_id,organization_id,subinventory_code,lot_number,TRANSACTION_UOM_CODE) moq"+
		  ",po.po_line_locations_all plla"+
		  ",po.po_headers_all pha"+ //add by Peggy 20210712
          " where a.status='"+STATUS+"'"+
		  " and a.deliver_result='DELIVER'"+
		  " and a.rcv_deliver_trx_id is not null"+
		  " and a.organization_id=b.organization_id"+
		  " and a.receipt_num=c.receipt_num"+
		  " and a.vendor_site_id=d.vendor_site_id"+
		  " and a.rcv_deliver_trx_id=rcv.interface_transaction_id"+
		  " and c.shipment_header_id=rcv.shipment_header_id"+
		  " and a.inventory_item_id=moq.inventory_item_id(+)"+
		  " and a.organization_Id=moq.organization_id(+)"+
		  " and a.subinventory_code=moq.subinventory_code(+)"+
		  " and a.lot_number=moq.lot_number(+)"+
		  " and a.po_line_location_id=plla.line_location_id"+
		  " and a.po_header_id=pha.po_header_id"+
          " and not exists (select 1 from (select x.shipment_header_id,x.shipment_line_id,min(x.parent_transaction_id) parent_transaction_id "+
          "                 from po.rcv_transactions x ,oraddman.tssg_po_receive_detail y"+
          "                 where y.status='"+STATUS+"'"+
		  "                 and y.deliver_result='DELIVER'"+
          "                 and y.rcv_deliver_trx_id is not null"+
          "                 and x.shipment_header_id=y.shipment_header_id"+
          "                 and x.transaction_type in ('RETURN TO RECEIVING','RETURN TO VENDOR') "+
          "                 group by x.shipment_header_id,x.shipment_line_id) y where y.parent_transaction_id=rcv.transaction_id)"+
		  " and not exists (select 1 from apps.tsc_export_to_eform d where d.export_data_no=c.waybill_airbill_num and d.export_flag='Y')"+
		  " and not exists (select 1 from po.rcv_transactions e where e.interface_transaction_id=a.rcv_deliver_trx_id"+
		  "                 and exists (select 1 from po.rcv_transactions x where x.parent_transaction_id=e.transaction_id))";
	if (!ORGCODE.equals("--") && !ORGCODE.equals(""))
	{
		sql += " and a.organization_id='"+ORGCODE+"'";
	}
	if (!ITEMDESC.equals("") && !ITEMDESC.equals("--"))
	{
		sql += " and a.item_desc ='"+ITEMDESC+"'";
	}
	if (!LOT_NUMBER.equals("") && !LOT_NUMBER.equals("--"))
	{
		sql += " and a.lot_number ='"+LOT_NUMBER+"'";
	}	
	if (!VENDOR_NAME.equals("") && !VENDOR_NAME.equals("--"))
	{
		sql += " and a.vendor_name ='"+VENDOR_NAME+"'";
	}	
	if (!RECEIPT_NUM.equals("") && !RECEIPT_NUM.equals("--"))
	{
		sql += " and a.receipt_num ='"+RECEIPT_NUM+"'";
	}		
	if ((!YearFr.equals("--") && !YearFr.equals("")) || (!MonthFr.equals("--") && !MonthFr.equals("")) || (!DayFr.equals("--") && !DayFr.equals("")))
	{
		sql += " AND a.receive_date >= to_date('" + (YearFr.equals("--") || YearFr.equals("")?"2020":YearFr)+(MonthFr.equals("--") || MonthFr.equals("")?"01":MonthFr)+(DayFr.equals("--") || DayFr.equals("")?"00":DayFr)+"','yyyymmdd')";
	}
	if ((!YearTo.equals("--") && !YearTo.equals("")) || (!MonthTo.equals("--") && !MonthTo.equals("")) || (!DayTo.equals("--") || !DayTo.equals("")))
	{
		sql += " AND a.receive_date <=  to_date('" + (YearTo.equals("--") || YearTo.equals("")?dateBean.getYearString():YearTo)+(MonthTo.equals("--") || MonthTo.equals("")?dateBean.getMonthString():MonthTo)+(DayTo.equals("--") || DayTo.equals("")?dateBean.getDayString():DayTo)+"','yyyymmdd')+0.99999";
	}		  
	
	sql += " order by b.organization_code,a.vendor_name,tsc_inv_category(a.inventory_item_id,43,1100000003),a.receipt_num,a.item_desc,a.receive_date,a.po_line_location_id,a.lot_number";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="2%" align="center" style="background-color:#66CCCC;color:#000000">&nbsp;</td>
		<td width="2%" align="center" style="background-color:#66CCCC;color:#000000"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
		<td width="5%" align="center" style="background-color:#66CCCC;color:#000000">Return Qty</td>
		<td width="8%" align="center" style="background-color:#66CCCC;color:#000000">Return Reason</td>
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">內外銷</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receipt Num</td>
		<td width="7%" style="background-color:#51874E;color:#FFFFFF;" align="center">PO NO</td>
		<td width="7%" style="background-color:#51874E;color:#FFFFFF;" align="center">Vendor Name</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Prod Group</td>
		<td width="12%" style="background-color:#51874E;color:#FFFFFF;" align="center">Item Desc</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Need by Date</td>
		<td width="11%" style="background-color:#51874E;color:#FFFFFF;" align="center">Lot Number</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Date Code</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receive Qty(K)</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Pick Qty(K)</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">On hand(K)</td>
		<td width="6%" style="background-color:#51874E;color:#FFFFFF;" align="center">Receive Date</td>
	</tr>
		<%
		}
		id = rs.getString("receive_trx_id");
		rowcnt++;
		%>
	<tr id="tr_<%=id%>">
		<td><%=rowcnt%></td>
		<td id="tda_<%=id%>" align="center">
			<input type="checkbox" name="chk" value="<%=id%>" onClick="setCheck(<%=(rowcnt-1)%>)" <%=(rs.getString("pick_qty")==null && rs.getString("AUTHORIZATION_STATUS").equals("APPROVED")?" ":" disabled")%>></td>
		<td align="center"><input type="text" name="return_qty_<%=id%>" value="" style="text-align:right;border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;" size="4"></td>
		<td align="center"><input type="text" name="return_reason_<%=id%>" value="" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;" size="15"></td>
		<td align="center"><%=rs.getString("organization_name")%></td>
		<td align="center"><%=rs.getString("receipt_num")%></td>
		<td align="center"><%=rs.getString("po_no")%><%=(!rs.getString("AUTHORIZATION_STATUS").equals("APPROVED")?"<br><font color='#ff0000'>"+rs.getString("AUTHORIZATION_STATUS")+"</font>":"")%></td>
		<td><%=rs.getString("vendor_site_code")%></td>
		<td><%=rs.getString("tsc_prod_group")%></td>
		<td><%=rs.getString("item_desc")%></td>
		<td align="center"><%=rs.getString("need_by_date")%></td>
		<td><%=rs.getString("lot_number")%></td>
		<td align="center"><%=rs.getString("date_code")%></td>
		<td align="right"><%=(rs.getString("rcv_qty")==null?"&nbsp;":rs.getString("rcv_qty"))%><input type="hidden" name="rcv_qty_<%=id%>" value="<%=rs.getString("rcv_qty")%>"></td>
		<td align="right"><%=(rs.getString("pick_qty")==null?"&nbsp;":"<font style='font-weight:bold;color:#FF0000;'>"+rs.getString("pick_qty")+"</font>")%><input type="hidden" name="pick_qty_<%=id%>" value="<%=rs.getString("pick_qty")%>"></td>
		<td align="right"><%=(rs.getString("onhand")==null?"&nbsp;":rs.getString("onhand"))%><input type="hidden" name="onhand_<%=id%>" value="<%=rs.getString("onhand")%>"></td>
		<td align="center"><%=(rs.getString("receive_date")==null?"&nbsp;":rs.getString("receive_date"))%></td>
	</tr>	
	<%
	}
	rs.close();
	statement.close();
	
	if (rowcnt >0) 
	{
%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#DAF0FC">
	<tr>
		<td>
		<font style="font-family:Tahoma,Georgia;">Action：</font><select NAME="ACTIONTYPE" style="font-family:Tahoma,Georgia;" onChange="changobj()">
				<OPTION VALUE=-- <%if (ACTIONTYPE.equals("")) out.println("selected");%>>--</OPTION>
				<OPTION VALUE="RETURN TO VENDOR" <%if (ACTIONTYPE.equals("RETURN TO VENDOR")) out.println("selected");%>>Return to Supplier</OPTION>
				</select>
		<input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSCSGPOReceiveProcess.jsp?TRANSTYPE=RETURN")'></td>
	</tr>
</table>
<hr>
	<%
	}
	else
	{
		out.println("<div style='color:#0000ff;font-size:16px' align='center'>No Data Found!!</div>");
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='font-size:11px;color:#ff0000'>Exception:"+e.getMessage()+"</div>");
}
%>
<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

