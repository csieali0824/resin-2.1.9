<!--20160328 by Peggy,改單量大於原訂單量兩倍時,顯示訊息確認-->
<!--20160713 by Peggy,Resend訂單SSD可改,但必須大於等於前次申請的SSD-->
<!--20170426 by Peggy,取消Resend訂單ssd必須大於等於前次申請ssd限制(但必須大於等於系統日+7天),及resend時開放可改request date及記錄resend原始temp_id及seq_id-->
<!--20180208 by Peggy,ITEM不符SPQ能提示並顯示SPQ數量For TSCT-DA & TSCT-Disty-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
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
<title>Sales Order Request for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean1" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setUpload()
{
	//if (document.MYFORM.SALESGROUP.value==null || document.MYFORM.SALESGROUP.value=="" || document.MYFORM.SALESGROUP.value=="--")
	//{
	//	alert("請指定Sales Group!"); 
	//	document.MYFORM.SALESGROUP.focus();
	//	return false;	
	//}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	//subWin=window.open("../jsp/TSSalesOrderReviseUpload.jsp?SGROUP="+document.MYFORM.SALESGROUP.value,"subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
	subWin=window.open("../jsp/TSSalesOrderReviseUpload.jsp","subwin","left=100,width=740,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit(URL)
{
	var shippingMethod = document.MYFORM.SHIPPINGMETHODLIST.value;
	var strlen = shippingMethod.split(";");
	var v_exist =false;
	var rec_year="",rec_month="",rec_day="";
	for (var i = 1; i <= document.MYFORM.ROWCNT.value ; i++)
	{
		if ((document.MYFORM.elements["CHANGE_QTY_"+i].value != "" && document.MYFORM.elements["CHANGE_QTY_"+i].value !=document.MYFORM.elements["SOURCE_QTY_"+i].value) 
		  || (document.MYFORM.elements["SOURCE_SHIPTO_ID_"+i].value !="" && document.MYFORM.elements["SOURCE_SHIPTO_ID_"+i].value !=document.MYFORM.elements["SHIPTO_ID_"+i].value)
		  || (document.MYFORM.elements["SOURCE_CUST_ID_"+i].value != "" && document.MYFORM.elements["SOURCE_CUST_ID_"+i].value !=document.MYFORM.elements["CUST_ID_"+i].value)
		  || (document.MYFORM.elements["SOURCE_ITEMID_"+i].value != "" && document.MYFORM.elements["SOURCE_ITEMID_"+i].value !=document.MYFORM.elements["ITEMID_"+i].value)
		  || (document.MYFORM.elements["SOURCE_CUST_ITEMID_"+i].value !="" && document.MYFORM.elements["SOURCE_CUST_ITEMID_"+i].value !=document.MYFORM.elements["CUST_ITEMID_"+i].value)
		  || (document.MYFORM.elements["ODRTYPE_"+i].value !="" && document.MYFORM.elements["ODRTYPE_"+i].value != document.MYFORM.elements["MO_"+i].value.substr(1,4))
		   )
		{
			if (document.MYFORM.elements["CHANGE_REASON_"+i].value=="--"|| document.MYFORM.elements["CHANGE_REASON_"+i].value=="")
			{
				document.MYFORM.elements["CHANGE_REASON_"+i].style.backgroundColor="#FFCCCC";  
				alert("Line:"+i+" Please choose a change reason!!");
				return false;
			}
			//改單量大於原訂單量兩倍以上,顯示訊息確認,add by Peggy 20160328
			if (document.MYFORM.elements["CHANGE_QTY_"+i].value != "" && (eval(document.MYFORM.elements["CHANGE_QTY_"+i].value)/eval(document.MYFORM.elements["SOURCE_QTY_"+i].value))>2)
			{
				document.getElementById("tr_"+i).style.backgroundColor ="#ffff33";	
				if (!confirm("MO#"+document.MYFORM.elements["MO_"+i].value+"  Line#"+document.getElementById("line_"+i).innerHTML+"\n"+"Are you sure to change order quantity from "+document.MYFORM.elements["SOURCE_QTY_"+i].value+" pce to "+document.MYFORM.elements["CHANGE_QTY_"+i].value+" pce?"))
				{
					return false;
				}
			}
			if (document.MYFORM.RESEND_FLAG.value=="Y")
			{
				//檢查resend不可修改數量=0,add by Peggy 20210309
				if (document.MYFORM.elements["ORIG_CHANGE_QTY_"+i].value != document.MYFORM.elements["CHANGE_QTY_"+i].value && document.MYFORM.elements["CHANGE_QTY_"+i].value == "0")
				{
					alert("Line:"+i+" Qty can not change to zero when resend status!!");
					return false;
				}				
				
				//檢查運輸方式
				if (document.MYFORM.elements["SHIPMETHOD_"+i].value!=null && document.MYFORM.elements["SHIPMETHOD_"+i].value!="")
				{
					v_exist =false;
					for (var x= 0 ; x< strlen.length ; x++)
					{
						if (strlen[x] == document.MYFORM.elements["SHIPMETHOD_"+i].value)
						{
							v_exist = true;
							break;
						}
					}
					if (v_exist ==false)
					{
						alert("Line:"+i+" Shipping Method:"+document.MYFORM.elements["SHIPMETHOD_"+i].value+" not found in ERP!!");
						return false;
					}
				}
			
				//add by Peggy 20170426,resend申請單可改ssd,但ssd必須大於等於系統日+7天
				//if (document.MYFORM.elements["CHANGE_SSD_"+i].value != null && eval(document.MYFORM.elements["CHANGE_SSD_"+i].value) < eval(document.MYFORM.elements["CHANGE_SSD_T_"+i].value))
				if (document.MYFORM.elements["CHANGE_SSD_"+i].value != null && document.MYFORM.elements["CHANGE_SSD_"+i].value != document.MYFORM.elements["SOURCE_SSD_"+i].value &&  eval(document.MYFORM.elements["CHANGE_SSD_"+i].value) < eval(document.MYFORM.limit_date.value))
				{
					if (document.MYFORM.elements["CHANGE_QTY_"+i].value == null || document.MYFORM.elements["CHANGE_QTY_"+i].value == "" || document.MYFORM.elements["CHANGE_QTY_"+i].value !="0") //add by Peggy 20200416
					{
						alert("New SSD:"+document.MYFORM.elements["CHANGE_SSD_"+i].value+" must be greater than or equals the system date plus 7 days("+document.MYFORM.limit_date.value+")");
						return false;
					}
				}
				else if (document.MYFORM.elements["CHANGE_SSD_"+i].value != null && document.MYFORM.elements["CHANGE_SSD_"+i].value.length >0)
				{
					if (document.MYFORM.elements["CHANGE_SSD_"+i].value.length!=8)
					{
						alert("NEW SSD:"+document.MYFORM.elements["CHANGE_SSD_"+i].value+" format error!(date format=YYYYMMDD)");
						return false;
					}
					else 
					{
						rec_year = document.MYFORM.elements["CHANGE_SSD_"+i].value.substr(0,4);
						rec_month= document.MYFORM.elements["CHANGE_SSD_"+i].value.substr(4,2);
						rec_day  = document.MYFORM.elements["CHANGE_SSD_"+i].value.substr(6,2);
						if (rec_month <1 || rec_month >12)
						{
							alert("line"+i+":SSD month value error!!");
							document.MYFORM.elements["CHANGE_SSD_"+i].focus();
							return false;			
						}	
						else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
						{
							alert("line"+i+":SSD day value error!!");
							document.MYFORM.elements["CHANGE_SSD_"+i].focus();
							return false;			
						} 
						else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
						{
							alert("line"+i+":SSD day value error!!");
							document.MYFORM.elements["CHANGE_SSD_"+i].focus();
							return false;			
						} 
						else if (rec_month == 2)
						{
							if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
							{
								alert("line"+i+":SSD day value error!!");
								document.MYFORM.elements["CHANGE_SSD_"+i].focus();
								return false;			
							}		
						}
					}
				}
				
				if (document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value != null && document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value.length >0)
				{
					if (document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value.length!=8)
					{
						alert("NEW Request Date:"+document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value+" format error!(date format=YYYYMMDD)");
						return false;
					}
					else 
					{
						rec_year = document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value.substr(0,4);
						rec_month= document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value.substr(4,2);
						rec_day  = document.MYFORM.elements["CHANGE_REQ_DATE_"+i].value.substr(6,2);
						if (rec_month <1 || rec_month >12)
						{
							alert("line"+i+":Request Date month value error!!");
							document.MYFORM.elements["CHANGE_REQ_DATE_"+i].focus();
							return false;			
						}	
						else if ((rec_month ==1 || rec_month==3 || rec_month == 5 || rec_month ==7 || rec_month==8 || rec_month==10 || rec_month ==12)	 && rec_day > 31)
						{
							alert("line"+i+":NEW Request Date day value error!!");
							document.MYFORM.elements["CHANGE_REQ_DATE_"+i].focus();
							return false;			
						} 
						else if ((rec_month == 4 || rec_month==6 || rec_month == 9 || rec_month ==11)	 && rec_day > 30)
						{
							alert("line"+i+":NEW Request Date day value error!!");
							document.MYFORM.elements["CHANGE_REQ_DATE_"+i].focus();
							return false;			
		
						} 
						else if (rec_month == 2)
						{
							if ((isLeapYear(rec_year) && rec_day > 29) || (!isLeapYear(rec_year) && rec_day > 28))
							{
								alert("line"+i+":NEW Request Date day value error!!");
								document.MYFORM.elements["CHANGE_REQ_DATE_"+i].focus();
								return false;			
							}		
						}
					
					}
				}
			}
		}
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.save1.disabled= true;
	document.MYFORM.exit1.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setClose()
{
	if (confirm("Are you sure to exit this function?"))
	{
		location.href="/oradds/ORADDSMainMenu.jsp";
	}
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
<%
String sql = "";
//String salesGroup=request.getParameter("SALESGROUP");
//if (salesGroup==null) salesGroup="";
String ATYPE = request.getParameter("ActionType");
if (ATYPE==null) ATYPE="";
String temp_id = request.getParameter("ID");
if (temp_id==null) temp_id="";
String screenWidth=request.getParameter("SWIDTH");
if (screenWidth==null) screenWidth="0";
String screenHeight=request.getParameter("SHEIGHT");
if (screenHeight==null) screenHeight="0";
String RESEND_FLAG = request.getParameter("RESEND_FLAG");  //add by Peggy 20160713
if (RESEND_FLAG==null) RESEND_FLAG="";
Hashtable hashtb = (Hashtable)session.getAttribute("D12001");
String MOArray []=null;
String strBackGround="color:#ff0000;";
int i=0;
//dateBean1.setAdjDate(7);
//String limit_date=dateBean1.getYearMonthDay();
//dateBean1.setAdjDate(-7);
String limit_date=request.getParameter("limit_date");
if (limit_date==null || limit_date.equals(""))
{
	sql = "SELECT to_char((trunc(SYSDATE,'IW')+6),'yyyymmdd') FROM DUAL";
	Statement statementq=con.createStatement();					 
	ResultSet rsq=statementq.executeQuery(sql);
	while (rsq.next())
	{
		limit_date = rsq.getString(1);
	}
	rsq.close();
	statementq.close();
}

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
String shipping_method_list = "";
sql = " select distinct SHIPPING_METHOD"+
      " from ASO_I_SHIPPING_METHODS_V a ";
Statement statement=con.createStatement();					 
ResultSet rs=statement.executeQuery(sql);
while (rs.next())
{
	shipping_method_list += rs.getString(1)+";";
}
rs.close();
statement.close();

/*if (salesGroup.equals(""))
{
	//sql = " SELECT distinct g.master_group_name"+
	//	  " FROM oraddman.wsuser a,fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f,tsc_om_group_master g"+
	//	  " WHERE a.username = ?"+
	//	  " AND a.erp_user_id=b.user_id"+
	//	  " and b.employee_id = c.person_id"+
	//	  " AND c.employee_number = d.salesrep_number"+
    //     " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
	//	  " and e.group_id=f.group_id"+
	//	  " and f.master_group_id=g.master_group_id";
	sql = " SELECT DISTINCT tog.group_name "+
	      " FROM TSC_OM_GROUP_SALESREP togs,TSC_OM_GROUP tog  WHERE  togs.GROUP_ID=tog.GROUP_ID"+
          " AND (tog.END_DATE IS NULL OR tog.END_DATE > TRUNC(SYSDATE))"+
          " AND EXISTS (SELECT 1 FROM oraddman.tsrecperson a,oraddman.tssales_area B WHERE A.USERNAME =? AND A.TSSALEAREANO=B.SALES_AREA_NO "+
          " AND ','||B.GROUP_ID||',' LIKE '%,'||tog.GROUP_ID||',%')";
	if (UserName.equals("COCO")) sql += " and tog.group_name='TSCH-HK'";		  
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,UserName);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{
		salesGroup=rs1.getString("group_name");
	}
	rs1.close();
	statement1.close();
}*/
%>
<body> 
<FORM ACTION="../jsp/TSSalesOrderReviseRequest.jsp" METHOD="post" NAME="MYFORM">
<input type="hidden" name="SHIPPINGMETHODLIST" value="<%=shipping_method_list%>">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Order Request for Revise</div>
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
<TABLE border="0" width="100%" bgcolor="#CEEAD7">
	<!--<tr>
		<td width="10%" style="font-size:12px" align="right">Sales Group：</td>
		<td width="30%">
		<%
		/*
		try
		{   
			sql = "select MASTER_GROUP_NAME, MASTER_GROUP_NAME from tsc_om_group_master a where org_id in (41,325) ";
			if (UserRoles.indexOf("admin")<0)
			{
				sql += " and a.MASTER_GROUP_NAME='"+salesGroup+"'";
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFieldName("SALESGROUP");	
			if (UserRoles.indexOf("admin")<0 )
			{
				comboBoxBean.setOnChangeJS("this.value="+'"'+salesGroup+'"');
			}			   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}
		*/ 	
		%>	
		</td>
		<td width="30%">&nbsp;</td>
		<td>&nbsp;</td>
	</tr>-->
	<tr>
		<td width="10%" style="font-size:12px" align="right">Created By：</td>
		<td width="30%"><%=UserName%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td style="font-size:12px" align="right">Request Date：</td>
		<td><%=dateBean.getYearMonthDay()%></td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>		
	</tr>
	<tr>
		<td style="font-size:12px" align="right">Sample File：</td>
		<td><A HREF="../jsp/samplefiles/D12-001_SampleFile.xls">Download Sample File</A></td>
		<td><input type="button" name="btnUpload" value="Excel Upload"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload()">
		</td>
		<td align="right">&nbsp;</td>
	</tr>
	
</TABLE>
<hr>
<%
	
try
{
	if (ATYPE.equals("UPLOAD") && !temp_id.equals("") && temp_id != null)
	{
		sql = " update oraddman.TSC_OM_SALESORDERREVISE_TEMP a "+
			  " set ( a.source_customer_id"+
			  ",a.source_ship_to_org_id"+
			  ",a.source_ship_from_org_id"+
			  ",a.source_item_id"+
			  ",a.source_item_desc"+
			  ",a.source_cust_item_id"+
			  ",a.source_cust_item_name"+
			  ",a.source_customer_po"+
			  ",a.source_shipping_method"+
			  ",a.source_so_qty"+
			  ",a.source_ssd"+
			  ",a.source_request_date"+
			  ",a.source_bill_to_org_id"+
			  ",a.source_bill_to_location_id"+
			  ",a.source_ship_to_location_id"+
			  ",a.source_deliver_to_location_id"+
			  ",a.source_fob_point_code"+
			  ",a.source_end_customer_id"+
			  ",a.source_end_customer_no"+
			  ",a.source_selling_price"+
			  ",a.source_currency_code"+
			  ",a.source_tax_code"+
			  ",a.source_price_list_id)="+
			  "(select oha.sold_to_org_id "+
			  ",ola.ship_to_org_id"+
			  ",ola.ship_from_org_id"+
			  ",ola.inventory_item_id"+
			  ",msi.description"+
			  ",ola.ORDERED_ITEM_ID"+
			  ",ola.ORDERED_ITEM"+
			  ",nvl(ola.customer_line_number,ola.cust_po_number)"+
			  ",ola.shipping_method_code"+
			  ",ola.ordered_quantity"+
			  ",trunc(ola.schedule_ship_date)"+
			  ",trunc(ola.request_date)"+
			  ",ola.invoice_to_org_id"+
			  ",bill_site.location"+
			  ",ship_site.location"+
			  ",deliver_site.location"+
			  ",ola.FOB_POINT_CODE"+
			  ",ola.end_customer_id"+
			  ",e_cust.customer_number"+
			  ",ola.UNIT_SELLING_PRICE"+
			  ",oha.transactional_curr_code"+
			  ",ola.TAX_CODE"+                   
			  ",ola.PRICE_LIST_ID"+  
			  " from ont.oe_order_lines_all ola"+
			  " ,ont.oe_order_headers_all oha"+  
			  " ,inv.mtl_system_items_b msi"+ 
			  " ,ar_customers e_cust"+    
			  " ,ar.hz_cust_site_uses_all ship_site"+    
			  " ,ar.hz_cust_site_uses_all bill_site"+  
			  " ,ar.hz_cust_site_uses_all deliver_site"+       
			  "  where a.so_line_id=ola.line_id"+                    
			  " and ola.header_id=oha.header_id"+                     
			  " and ola.inventory_item_id=msi.inventory_item_id"+   
			  " and ola.ship_from_org_id=msi.organization_Id"+         
			  " and ola.end_customer_id=e_cust.customer_id(+)"+         
			  " and ola.ship_to_org_id=ship_site.site_use_id(+)"+     
			  " and ola.invoice_to_org_id=bill_site.site_use_id(+)"+   
			  " and ola.deliver_to_org_id=deliver_site.site_use_id(+))"+
			  " where a.temp_id=?";
		//out.println(sql);
		//out.println(temp_id);
		PreparedStatement pstmtDt=con.prepareStatement(sql); 
		pstmtDt.setString(1,temp_id); 
		pstmtDt.executeQuery();
		pstmtDt.close();	
		con.commit();
						  
		sql = " select a.temp_id"+
			  ",a.sales_group"+
			  ",a.so_no"+
			  ",a.line_no line_no"+
			  ",a.so_header_id"+
			  ",a.so_line_id"+
			  ",nvl(a.order_type,'') order_type "+
			  ",a.customer_number"+
			  ",a.customer_name"+
			  ",a.ship_to_org_id"+
			  ",a.ship_to"+
			  ",nvl(a.inventory_item_id,a.source_item_id) inventory_item_id "+
			  ",a.item_name"+
			  ",a.item_desc"+
			  ",nvl(a.cust_item_id,a.source_cust_item_id) cust_item_id "+
			  ",a.cust_item_name"+
			  ",a.customer_po"+
			  ",a.shipping_method"+
			  ",a.so_qty"+
			  ",to_char(a.request_date,'yyyymmdd') request_date "+
			  ",to_char(nvl(a.schedule_ship_date_tw,a.schedule_ship_date),'yyyymmdd') schedule_ship_date"+
			  ",a.packing_instructions"+
			  ",a.plant_code"+
			  ",a.change_reason"+
			  ",a.change_comments"+
			  ",a.created_by"+
			  ",a.creation_date"+
			  ",a.source_so_qty"+
			  ",nvl(b.customer_id,a.source_customer_id) customer_id"+
			  ",a.SOURCE_ITEM_ID"+
			  ",a.SOURCE_CUST_ITEM_ID"+
			  ",a.source_customer_id"+
			  ",a.SEQ_ID"+
			  ",to_char(a.source_ssd,'yyyymmdd') source_ssd"+
			  ",a.SOURCE_SHIP_TO_ORG_ID"+
			  //",case when a.so_qty='0' and instr(lower(a.remarks),'cancel')<=0 then 'cancel'|| case when  length(nvl(a.remarks,''))>0 then ','||a.remarks else a.remarks end else a.remarks end as remarks "+
			  ",case when a.so_qty='0'  and  (a.remarks is null or instr(UPPER(a.remarks),'CANCEL')=0) then 'CANCEL'|| case when  length(nvl(a.remarks,''))>0 then ','||a.remarks else a.remarks end else a.remarks end as remarks"+
			  ",a.SHIP_TO_LOCATION_ID"+
			  ",a.SOURCE_ITEM_DESC"+
			  ",a.SOURCE_CUSTOMER_PO"+
			  ",a.DELIVER_TO_LOCATION_ID"+
			  ",a.DELIVER_TO"+
			  ",a.SOURCE_DELIVER_TO_ORG_ID"+
			  ",a.DELIVER_TO_ORG_ID"+
			  ",a.BILL_TO_LOCATION_ID"+
			  ",a.BILL_TO"+
			  ",a.SOURCE_BILL_TO_ORG_ID"+
			  ",a.BILL_TO_ORG_ID"+
			  ",a.FOB"+
			  ",(c.SPQ/1000) SPQ"+ //add by Peggy 20180208
			  ",(c.MOQ/1000) MOQ"+ //add by Peggy 20180208
			  ",CASE WHEN a.SALES_GROUP IN ('TSCT-DA','TSCT-Disty','TSCE') AND nvl(a.SO_QTY,0)>0 AND mod(nvl(a.SO_QTY,0),c.SPQ) <> 0 THEN 1 ELSE 0 END AS SPQ_CHECK"+ //add by Peggy 20180208,ADD TSCE BY PEGGY 20211019
			  ",to_char(a.SCHEDULE_SHIP_DATE_TW,'yyyymmdd') SCHEDULE_SHIP_DATE_TW"+          //add by Peggy 20191003
			  ",nvl(a.TO_TW_DAYS,0) TO_TW_DAYS "+  //add by Peggy 20191003
			  " from oraddman.tsc_om_salesorderrevise_temp a"+
			  ",ar_customers b"+
			  ",table(tsc_get_item_spq_moq(a.inventory_item_id,'TS',a.plant_code)) c"+  //add by Peggy 20180208
			  " where a.temp_id='"+temp_id+"'"+
			  " and a.CREATED_BY='"+ UserName+"'"+
			  " and a.customer_number=b.customer_number(+)"+
			  " order by a.so_no,a.line_no,a.seq_id";
		//out.println(sql);
		statement=con.createStatement();
		rs=statement.executeQuery(sql);
		while (rs.next())
		{
			if (i ==0)
			{
		%>
<table width="100%">
	<tr>
		<td style="font-size:11px;color:#000000;font-family:Tahoma,Georgia">Notice:No change field please keep blank.</td>
		<td style="font-size:11px;color:#000000;font-family:Tahoma,Georgia">Qty Uom：PCE</td>
	</tr>
</table>
<table align="center" width='1800' border='1' bordercolorlight='#333366' bordercolordark='#ffffff' cellPadding='1' cellspacing='0'>
	<tr style="background-color:#006666;color:#FFFFFF;">
		<td width="10" align="center">&nbsp;</td>
		<td width="70" align="center">MO#</td>
		<td width="30" align="center">Line#</td>	
		<td width="110" align="center">Item Desc </td>	
		<td width="90" align="center">Customer PO</td>	
		<td width="50" style="background-color:#66CC99;" align="center">Order Type</td>	
		<td width="90" style="background-color:#66CC99;">Customer</td>
		<td width="90" style="background-color:#66CC99;">Item Desc</td>
		<td width="90" align="center" style="background-color:#66CC99;">Cust P/N</td>
		<td width="90" align="center" style="background-color:#66CC99;">Cust PO</td>
		<td width="70" align="center" style="background-color:#66CC99;">Shipping Method</td>
		<td width="50" align="center" style="background-color:#66CC99;">Order Qty</td>
		<td width="70" align="center" style="background-color:#66CC99;">SSD pull in/out</td>
		<td width="70" align="center" style="background-color:#66CC99;">Request Date</td>
		<td width="70" style="background-color:#66CC99;">Ship To</td>
		<td width="70" style="background-color:#66CC99;">Bill To</td>
		<td width="70" style="background-color:#66CC99;">Deliver To</td>
		<td width="70" align="center" style="background-color:#66CC99;">FOB</td>
		<td width="70" align="center" style="background-color:#66CC99;">Remarks</td>
		<td width="100" align="center" style="background-color:#66CC99;">Change Reason</td>
		<td width="100" align="center" style="background-color:#66CC99;">Change Comments</td>

	</tr>
	<%
			}
			i ++;
	%>
	<tr id="tr_<%=i%>">
		<td align="center"><%=i%></td>
		<td align="center"><input type="TEXT" NAME="MO_<%=i%>" value="<%=(rs.getString("SO_NO")==null?"":rs.getString("SO_NO"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="12" readonly><input type="hidden" name="SEQ_ID_<%=i%>" value="<%=rs.getString("seq_id")%>"></td>
		<td align="center"><div id="line_<%=i%>"><%=(rs.getString("LINE_NO")==null?"":rs.getString("LINE_NO"))%></div><input type="hidden" name="LINE_ID_<%=i%>" value="<%=(rs.getString("SO_LINE_ID")==null?"":rs.getString("SO_LINE_ID"))%>"></td>
		<td><%=(rs.getString("SOURCE_ITEM_DESC")==null?"":rs.getString("SOURCE_ITEM_DESC"))%></td>
		<td><%=(rs.getString("SOURCE_CUSTOMER_PO")==null?"":rs.getString("SOURCE_CUSTOMER_PO"))%></td>
		<td><input type="TEXT" NAME="ODRTYPE_<%=i%>" value="<%=(rs.getString("ORDER_TYPE")==null?"":rs.getString("ORDER_TYPE"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="4" readonly></td>
		<td><input type="TEXT" NAME="CUST_<%=i%>" value="<%=(rs.getString("CUSTOMER_NAME")==null?"":rs.getString("CUSTOMER_NAME"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="18" readonly><input type="hidden" name="SOURCE_CUST_ID_<%=i%>" value="<%=rs.getString("SOURCE_CUSTOMER_ID")%>"><input type="hidden" name="CUST_ID_<%=i%>" value="<%=rs.getString("customer_id")%>"></td>
		<td><input type="TEXT" NAME="ITEMDESC_<%=i%>" value="<%=(rs.getString("ITEM_DESC")==null?"":rs.getString("ITEM_DESC"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="13" readonly><input type="hidden" name="SOURCE_ITEMID_<%=i%>" value="<%=rs.getString("SOURCE_ITEM_ID")%>"><input type="hidden" name="ITEMID_<%=i%>" value="<%=rs.getString("INVENTORY_ITEM_ID")%>"></td>
		<td><input type="TEXT" NAME="CUSTPN_<%=i%>" value="<%=(rs.getString("CUST_ITEM_NAME")==null?"":rs.getString("CUST_ITEM_NAME"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="13" readonly><input type="hidden" name="SOURCE_CUST_ITEMID_<%=i%>" value="<%=rs.getString("SOURCE_CUST_ITEM_ID")%>"><input type="hidden" name="CUST_ITEMID_<%=i%>" value="<%=rs.getString("CUST_ITEM_ID")%>"></td>
		<td><input type="TEXT" NAME="CUSTPO_<%=i%>" value="<%=(rs.getString("CUSTOMER_PO")==null?"":rs.getString("CUSTOMER_PO"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="10" readonly></td>
		<td><input type="TEXT" NAME="SHIPMETHOD_<%=i%>" value="<%=(rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD")) %>" style="font-size:11px;font-family: Tahoma,Georgia;" size="12" <%=(RESEND_FLAG.equals("Y") ?"":"readonly")%>></td>
		<td align="center"><input type="TEXT" NAME="CHANGE_QTY_<%=i%>" value="<%=((rs.getString("SO_QTY") != null && !rs.getString("SO_QTY").equals(rs.getString("source_so_qty"))) || (rs.getString("SCHEDULE_SHIP_DATE")!=null && !rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("source_ssd")))?(rs.getString("SO_QTY")==null?"":rs.getString("SO_QTY")):"")%>" style="text-align:right;font-size:11px;font-family:Tahoma,Georgia;<%=(rs.getString("SPQ_CHECK").equals("1")?"background-color:#FF99CC":"")%>" size="7"><%=(rs.getString("SPQ_CHECK").equals("1")?"<BR><font color='red'>SPQ:"+rs.getString("SPQ")+"k<font>":"")%><input type="hidden" name="SOURCE_QTY_<%=i%>" value="<%=rs.getString("source_so_qty")%>"><input type="hidden" name="ORIG_CHANGE_QTY_<%=i%>" value="<%=(rs.getString("SO_QTY")==null?"":rs.getString("SO_QTY"))%>"></td>
		<td align="center"><input type="TEXT" NAME="CHANGE_SSD_<%=i%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="6" <%=(RESEND_FLAG.equals("Y") ?"":"readonly")%>><input type="hidden" NAME="CHANGE_SSD_T_<%=i%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>"><input type="hidden" NAME="SOURCE_SSD_<%=i%>" value="<%=(rs.getString("source_ssd")==null?"":rs.getString("source_ssd"))%>"></td>						
		<td align="center"><input type="TEXT" NAME="CHANGE_REQ_DATE_<%=i%>" value="<%=(rs.getString("REQUEST_DATE")==null?"":rs.getString("REQUEST_DATE"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="6" <%=(RESEND_FLAG.equals("Y") ?"":"readonly")%>></td>
		<td><input type="TEXT" NAME="SHIPTO_<%=i%>" value="<%=(rs.getString("SHIP_TO_LOCATION_ID")==null?"":"("+rs.getString("SHIP_TO_LOCATION_ID")+")"+rs.getString("ship_to"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="13" readonly></A><input type="hidden" name="SOURCE_SHIPTO_ID_<%=i%>" value="<%=rs.getString("SOURCE_SHIP_TO_ORG_ID")%>"><input type="hidden" name="SHIPTO_ID_<%=i%>" value="<%=rs.getString("SHIP_TO_ORG_ID")%>"></td>
		<td><input type="TEXT" NAME="BILLTO_<%=i%>" value="<%=(rs.getString("BILL_TO_LOCATION_ID")==null?"":"("+rs.getString("BILL_TO_LOCATION_ID")+")"+rs.getString("bill_to"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="13" readonly></A><input type="hidden" name="SOURCE_BILLTO_ID_<%=i%>" value="<%=rs.getString("SOURCE_BILL_TO_ORG_ID")%>"><input type="hidden" name="BILLTO_ID_<%=i%>" value="<%=rs.getString("BILL_TO_ORG_ID")%>"></td>
		<td><input type="TEXT" NAME="DELIVERTO_<%=i%>" value="<%=(rs.getString("DELIVER_TO_LOCATION_ID")==null?"":"("+rs.getString("DELIVER_TO_LOCATION_ID")+")"+rs.getString("deliver_to"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="13" readonly></A><input type="hidden" name="SOURCE_DELIVERTO_ID_<%=i%>" value="<%=rs.getString("SOURCE_DELIVER_TO_ORG_ID")%>"><input type="hidden" name="DELIVERTO_ID_<%=i%>" value="<%=rs.getString("DELIVER_TO_ORG_ID")%>"></td>
		<td align="center"><input type="TEXT" NAME="FOB_<%=i%>" value="<%=(rs.getString("FOB")==null?"":rs.getString("FOB"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="6" readonly></td>
		<td align="center"><input type="TEXT" NAME="REMARKS_<%=i%>" value="<%=(rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="6"></td>
		<td>
		<%
			try
			{   
				sql = " SELECT MEANING ,MEANING  FROM fnd_lookup_values  WHERE lookup_type = 'CANCEL_CODE'"+
					  " AND language = 'US' AND enabled_flag = 'Y'"+
					  //" AND LOOKUP_CODE IN ('Credit problem','CUSTOMER REQUIRE','PART NO AMEND','QTY/SSD REVISE','RELATED PO CHANGES','SALES')"+
					  " ORDER BY LOOKUP_CODE";
				Statement st2=con.createStatement();
				ResultSet rs2=st2.executeQuery(sql);
				comboBoxBean.setRs(rs2);
				comboBoxBean.setFontSize(11);
				comboBoxBean.setFontName("Tahoma,Georgia");
				comboBoxBean.setSelection((rs.getString("CHANGE_REASON")==null?"":rs.getString("CHANGE_REASON")));
				comboBoxBean.setFieldName("CHANGE_REASON_"+i);	   
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
		<td><input type="TEXT" NAME="CHANGE_COMMENTS_<%=i%>" value="<%=(rs.getString("CHANGE_COMMENTS")==null?"":rs.getString("CHANGE_COMMENTS"))%>" style="font-size:11px;font-family: Tahoma,Georgia;"  onKeyUp="setCheck(<%=i%>)" size="15"></td>
		<!--<td><img src="images/delete.png" title="delete record" onClick="setDelete(<%=i%>)" width="14"></td>-->
	</tr>	
		<%
		}
		rs.close();
		statement.close();
		if (i >0)
		{
	%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#CEEAD7">
	<tr>
		<td align="center">
			<input type="button" name="save1" value="Submit" onClick='setSubmit("../jsp/TSSalesOrderReviseProcess.jsp?ACODE=SAVE&ID=<%=temp_id%>&RESEND_FLAG=<%=RESEND_FLAG%>")' style="font-family: Tahoma,Georgia;">
			&nbsp;&nbsp;&nbsp;<input type="button" name="exit1" value="Exit" onClick='setClose()' style="font-family: Tahoma,Georgia;">
		</td>
	</tr>
</table>
<input type="hidden" name="ROWCNT" value="<%=i%>">
<input type="hidden" name="RESEND_FLAG" value="<%=RESEND_FLAG%>">
<input type="hidden" name="limit_date" value="<%=limit_date%>">
<hr>
<%
		}
	}
}
catch (Exception e) 
{ 
	out.println("Exception1:"+e.getMessage()+sql); 
} 	
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

