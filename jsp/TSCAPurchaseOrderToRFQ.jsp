<%@ page contentType="text/html; charset=big5" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>PC Request Order Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean,,Array2DimensionInputBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setRadio(objname)
{
	var chkvalue="";
	var chkname="";
	var iRow=0;
	if (document.MYFORM.rdocust.length != undefined)
	{
		iRow = document.MYFORM.rdocust.length;
	}
	else
	{
		iRow = 1;	
	}	
	for (var k =0 ; k <iRow ;k++)
	{
		if (iRow==1)
		{
			chkvalue=document.MYFORM.rdocust.checked;
			chkname=document.MYFORM.rdocust.value;	
			setcheck(chkname,chkvalue);				
		}
		else
		{	
			chkvalue=document.MYFORM.rdocust[k].checked;
			chkname=document.MYFORM.rdocust[k].value;
			if (chkname!=objname)
			{
				document.MYFORM.rdocust[k].checked=false;
				chkvalue=document.MYFORM.rdocust[k].checked;
			}
			setcheck(chkname,chkvalue);
		}
	}
}
function setcheck(objname,objvalue)
{
	var iRow=0;
	var chkvalue = false;
	var chkcnt =0;	

	if (document.MYFORM.elements["chkline_"+objname].length != undefined)
	{
		iRow = document.MYFORM.elements["chkline_"+objname].length;
	}
	else
	{
		iRow = 1;	
	}

	for (var i=1; i<= iRow ; i++)
	{
		if (iRow==1)
		{
			document.MYFORM.elements["chkline_"+objname].checked=objvalue;
		}
		else
		{
			document.MYFORM.elements["chkline_"+objname][i-1].checked=objvalue;
		}	
	}
}

function setClose()
{
	if (confirm("Are you sure to exit this function?"))
	{
		location.href="/oradds/ORADDSMainMenu.jsp";
	}
}

function setSubmit(URL)
{
	var chkcnt =0;	
	var chkvalue="";
	var iRow=0;

	if (document.MYFORM.elements["rdocust"].length != undefined)
	{
		iRow = document.MYFORM.elements["rdocust"].length;
	}
	else
	{
		iRow = 1;	
	}
	for (var k =0 ; k <iRow ;k++)
	{
		if (iRow==1)
		{
			if (document.MYFORM.elements["rdocust"].checked)
			{
				chkcnt++;
				chkvalue=document.MYFORM.elements["rdocust"].value;
			}
		}
		else
		{
			if (document.MYFORM.elements["rdocust"][k].checked)
			{
				chkcnt++;
				chkvalue=document.MYFORM.elements["rdocust"][k].value;
			}
		}
	}
	if (chkcnt <=0)
	{
		alert("Please choose data!");
		return false;
	}
	//document.getElementById("alpha").style.width=document.body.clientWidth;
	//document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.btnQuery.disabled=true;
	
	if (document.MYFORM.save1 != undefined)
	{
		document.MYFORM.save1.disabled=true;
	}
	if (document.MYFORM.exit1 != undefined)
	{	
		document.MYFORM.exit1.disabled=true;
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setReqType(objValue)
{
	if (objValue=="AWAITING_RFQ")
	{
		document.MYFORM.SDATE.disabled=true;
		document.MYFORM.EDATE.disabled=true;
		document.MYFORM.TSC_MO_LIST.disabled=true;
		document.MYFORM.TSCA_MO_LIST.disabled=true;	
		document.MYFORM.ITEM_LIST.disabled=true;
		document.MYFORM.END_CUST_PO_LIST.disabled=true;
		document.MYFORM.SDATE.value="";
		document.MYFORM.EDATE.value="";
		document.MYFORM.TSC_MO_LIST.value="";
		document.MYFORM.TSCA_MO_LIST.value="";		
		document.MYFORM.END_CUST_PO_LIST.value="";
		document.MYFORM.ITEM_LIST.value="";	
	}
	else
	{
		document.MYFORM.SDATE.disabled=false;
		document.MYFORM.EDATE.disabled=false;
		document.MYFORM.TSC_MO_LIST.disabled=false;
		document.MYFORM.TSCA_MO_LIST.disabled=false;
		document.MYFORM.ITEM_LIST.disabled=false;
		document.MYFORM.END_CUST_PO_LIST.disabled=false;
		document.MYFORM.SDATE.value="";
		document.MYFORM.EDATE.value="";
		document.MYFORM.TSC_MO_LIST.value="";
		document.MYFORM.TSCA_MO_LIST.value="";		
		document.MYFORM.END_CUST_PO_LIST.value="";
		document.MYFORM.ITEM_LIST.value="";	
	}
}
</script>
<%
String sql = "";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="Q";
String REQ_STATUS = request.getParameter("REQ_STATUS");
if (REQ_STATUS==null) REQ_STATUS="AWAITING_RFQ";
String TSC_MO_LIST=request.getParameter("TSC_MO_LIST");
if (TSC_MO_LIST==null) TSC_MO_LIST="";
String TSCA_MO_LIST=request.getParameter("TSCA_MO_LIST");
if (TSCA_MO_LIST==null) TSCA_MO_LIST="";
String ITEM_LIST=request.getParameter("ITEM_LIST");
if (ITEM_LIST==null) ITEM_LIST="";
String END_CUST_PO_LIST=request.getParameter("END_CUST_PO_LIST");
if (END_CUST_PO_LIST==null) END_CUST_PO_LIST="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String END_CUST=request.getParameter("END_CUST");
if (END_CUST==null) END_CUST="";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String v_orderno="",v_lineno="";
String v_job_id="";
String errorException="";
int irow=0;

try
{
	if (ATYPE.equals("S"))
	{
		String oneDArray[] = {"No.","Inventory Item","Item Description","Order Qty","UOM","Cust Request Date","Shipping Method","Request Date","End-Customer PO","Remark","SPQ Check","SPQ","MOQ","PlantCode","Cust PartNo","Selling Price","Order Type","Line Type","FOB","Cust Po Line No","Quote#","End Customer ID","Shipping Marks","Remarks","End Customer","ORIG SO ID","Delivery Remarks","BI Region","End Cust Ship to","End Cust Partno"};//add by Peggy 20170222
		String aa [][] = new String[1][1];
		String chooseline="",urlDir="",v_custid="",v_custno="",v_custname="",v_custpo="",v_sales_region="",v_remarks="",v_order_type_id="",v_currency="",v_rfq_type="",rdocust="";
		int icnt=0;

		String chk1[]= request.getParameterValues("rdocust");
		if (chk1.length <=0)
		{
			throw new Exception("No Data Found1!!");
		}
		else
		{
			for(int i=0; i< chk1.length ;i++)
			{
				rdocust=chk1[i];	
			}
		}
		
		String chk[]= request.getParameterValues("chkline_"+rdocust);
		if (chk.length <=0)
		{
			throw new Exception("No Data Found!!");
		}
		else
		{
			for(int i=0; i< chk.length ;i++)
			{
				chooseline = chooseline+","+chk[i];	
			}
		}
		
		sql = " SELECT a.job_group_id, a.rfq_sales_region,a.sales_region, a.customer_id, a.customer_number,"+
			  " a.customer_name, a.end_customer_id, a.end_customer_number,"+
			  " a.end_customer_name, a.ship_to_site_use_id, a.inventory_item_id,"+
			  " a.item_name, a.item_description, a.cust_item_id,"+
			  " a.cust_item_name, a.quantity, a.uom, a.unit_price,a.quantity/1000 qty_kpc,"+
			  " to_char(a.cust_required_date,'yyyymmdd') cust_required_date,"+
			  " a.end_cust_po, a.end_cust_po_line,"+
			  " a.cust_po, a.cust_po_line, a.plant_code, a.order_type,"+
			  " a.shipping_method_code, a.shipping_method, a.fob_term,"+
			  " to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date ,"+
			  " a.remarks, a.spq/1000 SPQ, a.moq/1000 MOQ,"+
			  " a.source_header_id, a.source_line_id, a.source_table_name,"+
			  " a.creation_date, a.created_by, a.err_msg"+
			  " ,a.order_type_id,a.currency_code,a.line_type_id"+
			  ",count(1) over (partition by JOB_GROUP_ID ,END_CUSTOMER_ID) row_cnt"+
			  " FROM oraddman.tsrfq_import_iface a"+
			  " where JOB_GROUP_ID||'_'||a.end_customer_id=?"+
			  " and ?||',' like '%,'||a.source_line_id||',%'"+
			  " ORDER BY JOB_GROUP_ID ,END_CUSTOMER_ID,decode(order_type,'1156',1,'1142',2,3),ITEM_DESCRIPTION,CUST_REQUIRED_DATE";
		//out.println(sql);
		//out.println(rdocust);
		//out.println(chooseline);
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,rdocust);
		statement.setString(2,chooseline);		
		ResultSet rs=statement.executeQuery();		
		while (rs.next())
		{
			//out.println(sql);
			if (icnt==0)
			{
				aa = new String[rs.getInt("row_cnt")+1][oneDArray.length];
				v_custid=rs.getString("customer_id");
                v_custno=rs.getString("customer_number");
                v_custname=rs.getString("customer_name");
                v_custpo=rs.getString("cust_po");
                v_sales_region=rs.getString("rfq_sales_region");
                v_remarks=rs.getString("remarks");
				if (v_remarks==null) v_remarks="";
                v_order_type_id=rs.getString("order_type_id");
                v_currency=rs.getString("currency_code");
				v_rfq_type="NORMAL";
			}
			
			aa[icnt][0]=""+(icnt+1);
			aa[icnt][1]=rs.getString("item_name");
			aa[icnt][2]=rs.getString("item_description");
			aa[icnt][3]=rs.getString("qty_kpc");
			aa[icnt][4]="KPC";
			aa[icnt][5]=rs.getString("cust_required_date");
			aa[icnt][6]=rs.getString("shipping_method_code");
			aa[icnt][7]=rs.getString("schedule_ship_date");
			aa[icnt][8]=rs.getString("cust_po");
			aa[icnt][9]=(rs.getString("remarks")==null?"":rs.getString("remarks"));
			aa[icnt][10]="N";
			aa[icnt][11]=rs.getString("SPQ");
			aa[icnt][12]=rs.getString("MOQ");
			aa[icnt][13]=rs.getString("plant_code");
			aa[icnt][14]=(rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name"));
			aa[icnt][15]=rs.getString("unit_price");
			aa[icnt][16]=rs.getString("order_type");
			aa[icnt][17]=rs.getString("line_type_id");
			aa[icnt][18]=rs.getString("fob_term"); 
			//aa[icnt][19]=rs.getString("end_cust_po_line"); 
			aa[icnt][19]=rs.getString("cust_po_line"); 
			aa[icnt][20]=""; 
			aa[icnt][21]=rs.getString("end_customer_number"); 
			aa[icnt][22]="";            //shipping marks
			aa[icnt][23]="";            //shipping marks
			aa[icnt][24]=rs.getString("end_customer_name"); //END customer
			aa[icnt][25]=rs.getString("source_line_id");  //orig so line id
			aa[icnt][26]="";            //direct ship to cust
			aa[icnt][27]="";            //bi region
			aa[icnt][28]="";            //END CUSTOMER SHIP TO ID
			aa[icnt][29]="";            //END CUSTOMER PARTNO
			icnt++;
			//out.println(icnt);
		}
		rs.close();
		statement.close();
	
		arrayRFQDocumentInputBean.setArray2DString(aa);
		session.setAttribute("SPQCHECKED","N");
		session.setAttribute("CUSTOMERID",v_custid);
		session.setAttribute("CUSTOMERNO",v_custno);
		session.setAttribute("CUSTOMERNAME",v_custname);
		session.setAttribute("CUSTOMERPO", v_custpo);
		session.setAttribute("CUSTACTIVE","Y");
		session.setAttribute("SALESAREANO",v_sales_region);
		session.setAttribute("REMARK",v_remarks);
		session.setAttribute("PREORDERTYPE",v_order_type_id);
		session.setAttribute("ISMODELSELECTED","Y");
		session.setAttribute("CUSTOMERIDTMP",v_custid);
		session.setAttribute("INSERT","Y");	
		session.setAttribute("RFQ_TYPE",v_rfq_type);	
		session.setAttribute("MAXLINENO",""+aa.length);
		session.setAttribute("CURR", v_currency);
		session.setAttribute("PROGRAMNAME","D4-020");
		urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(v_custid)+
			 "&SPQCHECKED=N"+
			 "&CUSTOMERNO="+java.net.URLEncoder.encode(v_custno)+
			 "&CUSTOMERNAME= "+java.net.URLEncoder.encode(v_custname)+
			 "&CUSTACTIVE=A"+
			 "&SALESAREANO="+java.net.URLEncoder.encode(v_sales_region)+
			 "&CUSTOMERPO="+java.net.URLEncoder.encode(v_custpo)+
			 "&CURR="+java.net.URLEncoder.encode(v_currency)+
			 "&REMARK="+java.net.URLEncoder.encode(v_remarks)+
			 "&PREORDERTYPE="+java.net.URLEncoder.encode(v_order_type_id)+
			 "&ISMODELSELECTED=Y"+
			 "&PROCESSAREA="+java.net.URLEncoder.encode(v_sales_region)+
			 "&INSERT=Y"+
			 "&RFQTYPE="+java.net.URLEncoder.encode(v_rfq_type)+
			 "&PROGRAMNAME=D4-020";			
		
		try
		{
			response.sendRedirect(urlDir);
		}
		catch(Exception e) 
		{
			out.println("Error:"+e.getMessage());
		}
	}

%>
<body> 
<FORM ACTION="../jsp/TSPCOrderReviseRequest.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">TSCA Purchase Order</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
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
<div id='alpha' class='hidden' style='width:<%=screenWidth%>;height:<%=screenHeight%>;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#CEEAD7" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="10%" style="font-size:11px" align="right">Status:</td>
		<td width="18%" >
		<select NAME="REQ_STATUS" style="font-family: Tahoma,Georgia;font-size:11px" onChange="setReqType(this.value)">
        <OPTION VALUE="AWAITING_RFQ" <%=(REQ_STATUS.equals("AWAITING_RFQ")?" selected ":"")%>>Awaiting RFQ
        <OPTION VALUE="HISTORY" <%=(REQ_STATUS.equals("HISTORY")?" selected ":"")%>>History
		</select>	
		</td>
		<td width="8%" style="font-size:11px" align="right" rowspan="3">TSC MO#/Line#:</td>
		<td width="16%" rowspan="3"><textarea cols="20" rows="5" name="TSC_MO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px;" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>><%=TSC_MO_LIST%></textarea></td>
		<td width="8%" style="font-size:11px" align="right" rowspan="3">TSCA MO#/Line#:</td>
		<td width="12%" rowspan="3"><textarea cols="20" rows="5" name="TSCA_MO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>><%=TSCA_MO_LIST%></textarea></td>
		<td width="8%" style="font-size:11px" align="right" rowspan="3">Part Number:</td>
		<td width="15%" rowspan="3"><textarea cols="20" rows="5" name="ITEM_LIST"  style="font-family: Tahoma,Georgia;font-size:11px" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>><%=ITEM_LIST%></textarea></td>
		<td width="8%" style="font-size:11px" align="right" rowspan="3">End Customer PO:</td>
		<td width="15%" rowspan="3"><textarea cols="20" rows="5" name="END_CUST_PO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>><%=END_CUST_PO_LIST%></textarea></td>
	</tr>
	<tr>
		<td style="font-size:11px" align="right">End Customer:</td>
		<td>
		<%
		try
		{   
			sql = "select distinct a.customer_id,'('||tca.account_number||')'||nvl(tca.customer_sname,tca.customer_name) cust_name from tsca.ta_om_request_supply a,tsc_customer_all_v tca where a.customer_id=tca.customer_id(+) and a.customer_id is not null order by a.customer_id";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(END_CUST);
			comboBoxBean.setFieldName("END_CUST");	 
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
	</tr>
	<tr>
		<td style="font-size:11px" align="right">Plan Request Date:</td>
		<td><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>>						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57" <%=REQ_STATUS.equals("AWAITING_RFQ")?"disabled":""%>>						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
	</tr>
	<tr>
	  <td colspan="12" align="center">
		<input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:11px" onClick="setQuery('../jsp/TSCAPurchaseOrderToRFQ.jsp?ATYPE=Q')">
	</td>
	</tr>
	
</TABLE>
<hr>
<%

	if (ATYPE.equals("Q"))
	{
		if (REQ_STATUS.equals("AWAITING_RFQ"))
		{
			CallableStatement csf = con.prepareCall("{call tsrfq_import_iface(?,?,?,?)}");
			csf.setString(1,"TSCA");
			csf.setString(2,UserName);      
			csf.registerOutParameter(3, Types.VARCHAR);  
			csf.registerOutParameter(4, Types.VARCHAR);
			csf.execute();
			v_job_id = csf.getString(3);
			errorException = csf.getString(4);
			csf.close();
			if (v_job_id.equals("-1"))
			{
				throw new Exception(errorException);
			}
			else if (v_job_id.equals("0"))
			{
				throw new Exception("No data found!!");
			}
				
			sql = " SELECT a.job_group_id, a.sales_region, a.customer_id, a.customer_number,"+
				  " a.customer_name, a.end_customer_id, a.end_customer_number,"+
				  " a.end_customer_name, a.ship_to_site_use_id, a.inventory_item_id,"+
				  " a.item_name, a.item_description, a.cust_item_id,"+
				  " a.cust_item_name, a.quantity, a.uom, a.unit_price,"+
				  " c.unit_selling_price,c.unit_list_price,round((c.unit_list_price-a.unit_price)/c.unit_list_price,2) profit,"+
				  " to_char(a.cust_required_date,'yyyymmdd') cust_required_date,"+
				  " a.end_cust_po, a.end_cust_po_line,"+
				  " a.cust_po, a.cust_po_line, a.plant_code, a.order_type,"+
				  " a.shipping_method_code, a.shipping_method, a.fob_term,"+
				  " to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date ,"+
				  " a.remarks, a.spq, a.moq,"+
				  " a.source_header_id, a.source_line_id, a.source_table_name,"+
				  " a.creation_date, a.created_by, a.err_msg,b.manufactory_name"+
				  " ,row_number() over (partition by a.job_group_id,a.end_customer_id order by ITEM_DESCRIPTION,CUST_REQUIRED_DATE) cust_row_seq"+
				  " ,count(1) over (partition by a.job_group_id,a.end_customer_id) cust_row_cnt"+
				  " ,sum(case when a.err_msg is not null and instr(a.err_msg,'價格')<=0 then 1 else 0 end) over (partition by a.job_group_id,a.end_customer_id) cust_err_cnt"+
				  " FROM oraddman.tsrfq_import_iface a"+
				  ",oraddman.tsprod_manufactory b"+
				  ",ont.oe_order_lines_all c"+
				  " where JOB_GROUP_ID=?"+
				  " and a.source_line_id=c.line_id(+)"+
				  " and a.end_customer_id=nvl(?,a.end_customer_id)"+
				  " and a.plant_code=b.manufactory_no(+)";
//				  " ORDER BY JOB_GROUP_ID ,END_CUSTOMER_ID,ITEM_DESCRIPTION,CUST_REQUIRED_DATE";
			//out.println(v_job_id);
			//out.println(END_CUST);
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,v_job_id);
			statement.setString(2,(END_CUST.equals("--")?"":END_CUST));
			ResultSet rs=statement.executeQuery();		
			while (rs.next())
			{		
				if (irow==0)
				{
				%>
					<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
						<tr style="background-color:#B4C1EF;font-size:10px">
							<td width="1%" align="center">&nbsp;</td>
							<td width="8%" align="center">End Cust</td>
							<td width="1%" align="center">&nbsp;</td>						
							<td width="13%" align="center">22D/30D</td>	
							<td width="8%" align="center">TSC Part No</td>	
							<td width="8%" align="center">Cust Item</td>	
							<td width="4%" align="center">Qty(PCE)</td>	
							<td width="3%" align="center">Buying</td>							
							<td width="3%" align="center">Selling</td>							
							<td width="4%" align="center">CRD</td>	
							<td width="5%" align="center">Schedule Ship Date</td>	
							<td width="5%" align="center">Shipping Method</td>
							<td width="5%" align="center">FOB</td>								
							<td width="6%" align="center">TSCA MO#</td>		
							<td width="4%" align="center">End Cust PO Line</td>		
							<td width="5%" align="center">Factory</td>
							<td width="3%" align="center">Order Type</td>	
							<td width="3%" align="center">Profit</td>	
							<td width="11%" align="center">Err Msg</td>																								
						</tr>
				<%
				}
				%>
				<tr style="font-size:10px">
				<%			
				if (rs.getInt("cust_row_seq")==1)
				{
				%>
					<td rowspan="<%=rs.getInt("cust_row_cnt")%>">
					<%
					if (rs.getInt("cust_row_cnt")!=rs.getInt("cust_err_cnt"))
					{
					%>
					<input type="checkbox" name="rdocust"  value="<%=rs.getString("job_group_id")%>_<%=rs.getString("end_customer_id")%>" onClick="setRadio('<%=rs.getString("job_group_id")%>_<%=rs.getString("end_customer_id")%>')">
					<%
					}
					%>
					</td>
					<td rowspan="<%=rs.getInt("cust_row_cnt")%>"><%="("+rs.getString("END_CUSTOMER_NUMBER")+")"+rs.getString("END_CUSTOMER_NAME")%></td>
				<%
				}
				%>
					<td align="center">
					<%
					if (rs.getString("ERR_MSG")==null || rs.getString("ERR_MSG").indexOf("價格")>=0)
					{
					%>
					<input type="checkbox" name="chkline_<%=rs.getString("job_group_id")%>_<%=rs.getString("end_customer_id")%>" value="<%=rs.getString("source_line_id")%>">
					<%
					}
					%>
					</td>
					<td><%=rs.getString("ITEM_NAME")%></td>	
					<td><%=rs.getString("ITEM_DESCRIPTION")%></td>	
					<td><%=(rs.getString("CUST_ITEM_NAME")==null?"":rs.getString("CUST_ITEM_NAME"))%></td>	
					<td align="right"><%=rs.getString("QUANTITY")%></td>
					<%
					if (rs.getString("UNIT_PRICE")==null || rs.getString("UNIT_PRICE").equals(""))
					{
					%>
						<td align="right">&nbsp;</td>
					<%
					}
					else
					{
					%>
						<td align="right"><%=Double.valueOf(rs.getString("UNIT_PRICE")).doubleValue()%></td>		
					<%
					}
					%>
			<%
					if (rs.getString("UNIT_list_PRICE")==null || rs.getString("UNIT_list_PRICE").equals(""))
					{
					%>
						<td align="right">&nbsp;</td>
					<%
					}
					else
					{
					%>
						<td align="right"><%=Double.valueOf(rs.getString("UNIT_list_PRICE")).doubleValue()%></td>		
					<%
					}
					%>					
					<td align="center"><%=rs.getString("CUST_REQUIRED_DATE")%></td>		
					<td align="center"><%=rs.getString("SCHEDULE_SHIP_DATE")%></td>	
					<td align="center"><%=rs.getString("SHIPPING_METHOD")%></td>	
					<td align="center"><%=rs.getString("FOB_TERM")%></td>
					<td><%=rs.getString("CUST_PO")%></td>
					<td><%=rs.getString("cust_po_line")%></td>	
					<td><%=rs.getString("manufactory_name")%></td>					
					<td align="center"><%=rs.getString("ORDER_TYPE")%></td>	
					<%
					if (rs.getString("PROFIT")==null || Double.valueOf(rs.getString("PROFIT")).doubleValue()>=6 )
					{
					%>
						<td align="center">&nbsp;</td>	
					<%
					}
					else
					{
					%>
					<td align="center" bgcolor="#FF99CC"><%=Double.valueOf(rs.getString("PROFIT")).doubleValue()%></td>	
					<%
					}
					%>
					<td style="color:#ff0000"><%=(rs.getString("ERR_MSG")==null?"":rs.getString("ERR_MSG"))%></td>																																															
				</tr>
				<%
				irow ++;
			}
			rs.close();
			statement.close();
		
			if (irow>0)
			{
			%>
				</table>
				<hr>
				<table border="0" width="100%" bgcolor="#CEEAD7">
					<tr>
						<td align="center">
							<input type="button" name="save1" value="Submit" onClick='setSubmit("../jsp/TSCAPurchaseOrderToRFQ.jsp?ATYPE=S")' style="font-family: Tahoma,Georgia;">
							&nbsp;&nbsp;&nbsp;<input type="button" name="exit1" value="Exit" onClick='setClose()' style="font-family: Tahoma,Georgia;">
						</td>
					</tr>
				</table>
				<hr>			
			<%
			}
			else
			{
				out.println("<div align='center'><font color='#ff0000'>Not data found!!</font></div>");
			}
		}
		else
		{
			sql =" select to_char(a.creation_date,'yyyymmdd hh24:mi') creation_date,a.order_number,a.line,a.customer_po,a.customer_po_line,msi.segment1 item"+
			     ",msi.description item_desc,a.customer_item,a.ordered_qty,to_char(a.request_date,'yyyymmdd') request_date,a.tp_price"+
				 ",a.rfq_no,a.rfq_line,a.rfq_reason,a.supply_order_number,a.supply_line,a.req_supply_status"+
				 ",(select customer_name from ar_customers x where customer_id=a.customer_id) customer_name"+
                 " from tsca.ta_om_request_supply a"+
				 ",tsc_customer_all_v tca "+
				 ",inv.mtl_system_items_b msi"+
                 " where a.customer_id=tca.customer_id(+)"+
                 " and a.inventory_item_id=msi.inventory_item_id"+
                 " and msi.organization_id=?"+
				 " and a.customer_id=nvl(?,a.customer_id)"+
				 " and (a.req_supply_status<>?"+
				 " or a.rfq_no is not null)"+
				 " and to_char(a.creation_date,'yyyymmdd')>=nvl(?,to_char(a.creation_date,'yyyymmdd'))"+
				 " and to_char(a.creation_date,'yyyymmdd')<=nvl(?,to_char(a.creation_date,'yyyymmdd'))";
			if (!TSC_MO_LIST.equals(""))
			{
				String [] sArray = TSC_MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					v_orderno="";
					v_lineno="";
					if (sArray[x].trim().indexOf("/")>0)
					{
						v_orderno=sArray[x].trim().substring(0,sArray[x].trim().indexOf("/"));
						v_lineno=sArray[x].trim().substring(sArray[x].trim().indexOf("/")+1);
					}
					else
					{
						v_orderno=sArray[x].trim();
					}
					if (x==0)
					{
						sql += " and ((a.supply_order_number ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and a.supply_line='"+v_lineno+"'";
						sql += ")";
					}
					else
					{
						sql += " or (a.supply_order_number ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and a.supply_line='"+v_lineno+"'";
						sql += ")";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}			
						
			if (!TSCA_MO_LIST.equals(""))
			{
				String [] sArray = TSCA_MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					v_orderno="";
					v_lineno="";
					if (sArray[x].trim().indexOf("/")>0)
					{
						v_orderno=sArray[x].trim().substring(0,sArray[x].trim().indexOf("/"));
						v_lineno=sArray[x].trim().substring(sArray[x].trim().indexOf("/")+1);
					}
					else
					{
						v_orderno=sArray[x].trim();
					}
					if (x==0)
					{
						sql += " and ((a.ORDER_NUMBER ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and a.line='"+v_lineno+"'";
						sql += ")";
					}
					else
					{
						sql += " or (a.ORDER_NUMBER ='"+v_orderno+"'";
						if (!v_lineno.equals("")) sql += " and a.line='"+v_lineno+"'";
						sql += ")";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}			
			if (!ITEM_LIST.equals(""))
			{
				String [] sArray = ITEM_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or upper(msi.description) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}
			if (!END_CUST_PO_LIST.equals(""))
			{
				String [] sArray = END_CUST_PO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						sql += " and (upper(a.customer_po) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						sql += " or upper(a.customer_po) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) sql += ")";
				}
			}	
			//out.println(sql);			 
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,"49");
			statement.setString(2,(END_CUST.equals("--")?"":END_CUST));
			statement.setString(3,"AWAITING_RFQ");
			statement.setString(4,SDATE);
			statement.setString(5,EDATE);						
			ResultSet rs=statement.executeQuery();		
			while (rs.next())
			{	
				if (irow==0)
				{
				%>
					<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
						<tr style="background-color:#B4C1EF;font-size:10px">
							<td width="6%" align="center">Planed Date</td>
							<td width="5%" align="center">End Cust</td>
							<td width="6%" align="center">TSCA MO</td>
							<td width="3%" align="center">TSCA Line</td>						
							<td width="8%" align="center">Cust PO</td>	
							<td width="3%" align="center">Cust PO Line</td>	
							<td width="11%" align="center">TSC Item Name</td>	
							<td width="8%" align="center">TSC Item Desc</td>
							<td width="11%" align="center">Cust Item</td>	
							<td width="4%" align="center">Qty(PCE)</td>	
							<td width="4%" align="center">Unit Price</td>							
							<td width="5%" align="center">CRD</td>	
							<td width="7%" align="center">RFQ No</td>	
							<td width="3%" align="center">RFQ Line</td>
							<td width="4%" align="center">RFQ Rej Reason</td>								
							<td width="5%" align="center">TSC MO</td>		
							<td width="3%" align="center">TSC Line</td>		
							<td width="5%" align="center">Status</td>
						</tr>
				<%
				}
				%>
				<tr style="font-size:10px">	
					<td><%=rs.getString("CREATION_DATE")%></td>	
					<td><%=rs.getString("customer_name")%></td>	
					<td><%=rs.getString("ORDER_NUMBER")%></td>	
					<td><%=rs.getString("LINE")%></td>	
					<td><%=rs.getString("CUSTOMER_PO")%></td>
					<td><%=(rs.getString("CUSTOMER_PO_LINE")==null?"":rs.getString("CUSTOMER_PO_LINE"))%></td>	
					<td><%=rs.getString("ITEM")%></td>	
					<td><%=rs.getString("ITEM_DESC")%></td>	
					<td><%=rs.getString("CUSTOMER_ITEM")%></td>	
					<td align="right"><%=rs.getString("ORDERED_QTY")%></td>																								
					<td align="right"><%=Double.valueOf((rs.getString("TP_PRICE")==null?"0":rs.getString("TP_PRICE"))).doubleValue()%></td>		
					<td align="center"><%=rs.getString("request_date")%></td>		
					<td><%=(rs.getString("RFQ_NO")==null?"":rs.getString("RFQ_NO"))%></td>	
					<td><%=(rs.getString("RFQ_LINE")==null?"":rs.getString("RFQ_LINE"))%></td>	
					<td><%=(rs.getString("RFQ_REASON")==null?"":rs.getString("RFQ_REASON"))%></td>
					<td><%=(rs.getString("SUPPLY_ORDER_NUMBER")==null?"":rs.getString("SUPPLY_ORDER_NUMBER"))%></td>
					<td><%=(rs.getString("SUPPLY_LINE")==null?"":rs.getString("SUPPLY_LINE"))%></td>	
					<td><%=rs.getString("REQ_SUPPLY_STATUS")%></td>					
				</tr>
				<%			
				irow++;			
			}
			rs.close();	
			statement.close();	
			
			if (irow>0)
			{
			%>
				</table>	
			<%
			}			
		}
	}
}
catch (Exception e) 
{ 
	out.println("<DIV align='center' style='font-size:12px;color:#ff0000'>Exception1:"+e.getMessage()+"</div>"); 
} 
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

