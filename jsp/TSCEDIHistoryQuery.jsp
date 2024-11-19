<!-- 20141029 by Peggy,增加幣別欄位-->
<!-- 20141119 by Peggy,PO狀態欄位增加Quantity or Price issue-->
<!-- 20150817 by Peggy,改為欄位名稱改為英文-->
<!-- 20160324 by Peggy,po status選單增加PO Status closed項目-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*"%>
<%@ page import="ComboBoxBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{    
	var CUSTOMER = document.MYFORM.CUSTOMER.value;
	var CUSTPO = document.MYFORM.CUSTPO.value;
    var CYEARFR = document.MYFORM.CYEARFR.value;
	var CMONTHFR = document.MYFORM.CMONTHFR.value;
    var CDAYFR = document.MYFORM.CDAYFR.value;
    var CYEARTO = document.MYFORM.CYEARTO.value;
    var CMONTHTO = document.MYFORM.CMONTHTO.value;
    var CDAYTO = document.MYFORM.CDAYTO.value;
	var PDNFLAG = "N";
	if (document.MYFORM.PDNFLAG.checked)
	{
		 PDNFLAG = "Y";
	}
	document.MYFORM.action=URL+"?CUSTOMER="+CUSTOMER+"&CUSTPO="+CUSTPO+"&CYEARFR="+CYEARFR+"&CMONTHFR="+CMONTHFR+"&CDAYFR="+CDAYFR+"&CDAYFR="+CDAYFR+"&CMONTHTO="+CMONTHTO+"&CDAYTO="+CDAYTO+"&PDNFLAG="+PDNFLAG;
 	document.MYFORM.submit();
}
function openSubWindow(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function toUpper()
{
	if (event.KeyCode !=08 && event.KeyCode !=37 && event.KeyCode !=39)
	{
		document.MYFORM.elements["CURRENCY"].value = document.MYFORM.elements["CURRENCY"].value.toUpperCase();
	}
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
				setCheck((i+1));
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
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
}
function setPass()
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.passreason.value=="")
	{
		alert("Please enter a pass reason!");
		return false;
	}
	chkcnt=0;	
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
			chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("Please choose pass po!");
		return false;
	}
	document.MYFORM.action="../jsp/TSCEDIHistoryQuery.jsp?PASS_FLAG=Y";
 	document.MYFORM.submit();	
}
function setPOChange()
{
	document.MYFORM.POSTATUS.value ="--";
}
</script>
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
<title>EDI Transaction Confirm</title>
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
<%
//dateBean.setAdjDate(-45);
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String CYearFr = request.getParameter("CYEARFR");
//if (CYearFr==null)  CYearFr=dateBean.getYearString();
if (CYearFr==null)  CYearFr="--";
String CMonthFr = request.getParameter("CMONTHFR");
//if (CMonthFr==null) CMonthFr=dateBean.getMonthString();
if (CMonthFr==null) CMonthFr="--";
String CDayFr = request.getParameter("CDAYFR");
//if (CDayFr==null) CDayFr=dateBean.getDayString();
if (CDayFr==null) CDayFr="--";
//dateBean.setAdjDate(45);
String CYearTo= request.getParameter("CYEARTO");
//if (CYearTo==null) CYearTo=dateBean.getYearString();
if (CYearTo==null) CYearTo="--";
String CMonthTo = request.getParameter("CMONTHTO");
//if (CMonthTo==null) CMonthTo=dateBean.getMonthString();
if (CMonthTo==null) CMonthTo="--";
String CDayTo = request.getParameter("CDAYTO");
//if (CDayTo==null) CDayTo=dateBean.getDayString();
if (CDayTo==null) CDayTo="--";
String PDNFLAG = request.getParameter("PDNFLAG");
if (PDNFLAG==null) PDNFLAG="";
String POSTATUS = request.getParameter("POSTATUS");
if (POSTATUS==null) POSTATUS="0";
String CURRENCY = request.getParameter("CURRENCY");
if (CURRENCY==null) CURRENCY=""; //add by Peggy 20141029
String PASS_REASON = request.getParameter("passreason");
if (PASS_REASON==null) PASS_REASON="";
String PASS_FLAG= request.getParameter("PASS_FLAG");
if (PASS_FLAG==null) PASS_FLAG="";
//String OCSTATUS = request.getParameter("OCSTATUS");
//if (OCSTATUS==null) OCSTATUS="";
String sql = "",sql1="";
if (PASS_FLAG.equals("Y"))
{
	String chk[]= request.getParameterValues("chk");
	if (chk.length <=0)
	{
		throw new Exception("No Data Found!!");
	}
	else
	{
		for(int i=0; i< chk.length ;i++)
		{
			sql = " update tsc_edi_orders_header a"+
				  " set NON_EXP_FLAG=?"+
				  ",NON_EXP_REMARKS=?"+
				  ",LAST_UPDATED_BY=?"+
				  ",LAST_UPDATE_DATE=SYSDATE"+
				  " WHERE ERP_CUSTOMER_ID||'_'||CUSTOMER_PO=?";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,"Y");
			pstmtDt.setString(2,PASS_REASON);
			pstmtDt.setString(3,UserName);
			pstmtDt.setString(4,chk[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();
		}
		con.commit();		
	}
}
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCEDIHistoryQuery.jsp" METHOD="post" NAME="MYFORM" >
<strong><font style="font-size:18px;color:#000099">EDI Customer Order Query</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr>
		<td>
  			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7" bordercolor="#CCCCCC">
     			<tr>
					<td width="7%"><font color="#666600" >Customer:</font></td>   
					<td width="15%">
					<%
					try
					{
						sql = " select CUSTOMER_ID,'('|| CUSTOMER_NUMBER ||')' || CUSTOMER_NAME from ar_customers a"+
						      " where exists (select 1 from tsc_edi_customer b where b.CUSTOMER_ID=a.CUSTOMER_ID"+
							  " and (b.INACTIVE_DATE is null or trunc(b.INACTIVE_DATE) > trunc(sysdate))";
						if (UserRoles!="admin" && !UserRoles.equals("admin")) 
						{ 
							sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
						}
						sql +=")";
						//out.println(sql);
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);		
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(CUSTOMER); 
						comboBoxBean.setFieldName("CUSTOMER");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close(); 
					}
					catch(Exception e)
					{
						out.println("<font color='red'>Exception Error</font>");
					}
					%>
					</td>    
					<td width="7%"><font color="#666600" >Customer PO:</font></td>
					<td width="10%"><input type="text" name="CUSTPO" value="<%=CUSTPO%>" style="font-family:Arial;font-size:12px" size="15" onChange="setPOChange()"></td>
					<td width="5%"><font color="#666600" >Currency:</font></td>
					<td width="10%"><input type="text" name="CURRENCY" value="<%=CURRENCY%>" style="font-family:Arial;font-size:12px" size="5" onKeyUp="toUpper()"></td>
					<td width="5%"><font color="#666600" >PO Status:</font></td>  
					<td width="15%"><SELECT NAME="POSTATUS" style="font-family:Tahoma,Georgia;font-size:12px">
					    <option value="--" selected>--
						<option value="0" <% if (POSTATUS.equals("0")) out.println("selected");%>>All(Include All Exception)
						<option value="1" <% if (POSTATUS.equals("1")) out.println("selected");%>>PO Unconfirm
						<option value="2" <% if (POSTATUS.equals("2")) out.println("selected");%>>PO Untransfer MO
						<option value="3" <% if (POSTATUS.equals("3")) out.println("selected");%>>MO Created & OC not yet reply
						<option value="4" <% if (POSTATUS.equals("4")) out.println("selected");%>>PO Confirmed & OC not yet reply
						<option value="5" <% if (POSTATUS.equals("5")) out.println("selected");%>>Waiting Customer Reply
						<option value="6" <% if (POSTATUS.equals("6")) out.println("selected");%>>Quantity or Price Issue
						<option value="7" <% if (POSTATUS.equals("7")) out.println("selected");%>>PO Status Closed
						</SELECT>						
					</td> 
					<td width="6%"><font color="#666600" ><input type="checkbox" name="PDNFLAG" value="Y" <%if (PDNFLAG.equals("Y")){out.println("checked");}%>>PCN Remark</font></td>
				</tr>
				<tr>
					<td><font color="#666600">Request Date:</font></td>
					<td>
    				<%
					try
					{     
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
						arrayComboBoxBean.setArrayString(a);
						arrayComboBoxBean.setSelection(CYearFr);
						arrayComboBoxBean.setFieldName("CYEARFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					<%
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
						arrayComboBoxBean.setSelection(CMonthFr);
						arrayComboBoxBean.setFieldName("CMONTHFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					<%
					String CCDay = null;	     		 
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
						arrayComboBoxBean.setSelection(CDayFr);
						arrayComboBoxBean.setFieldName("CDAYFR");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					<font color="#006666"><strong>~</strong></font>
					<%
					try
					{       
						int  j =0; 
						String a[]= new String[Integer.parseInt(dateBean.getYearString())-2013+1];
						for (int i = 2013; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
						{
							a[j++] = ""+i; 
						}
						arrayComboBoxBean.setArrayString(a);
						arrayComboBoxBean.setSelection(CYearTo);
						arrayComboBoxBean.setFieldName("CYEARTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>        
					<%
					String CCMonthTo = null;	     		 
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
						arrayComboBoxBean.setSelection(CMonthTo);
						arrayComboBoxBean.setFieldName("CMONTHTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>        
					<%
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
						arrayComboBoxBean.setSelection(CDayTo);
						arrayComboBoxBean.setFieldName("CDAYTO");	   
						out.println(arrayComboBoxBean.getArrayString());		      		 
					} //end of try
					catch (Exception e)
					{
						out.println("Exception:"+e.getMessage());
					}
					%>
					</td>
					<td colspan="10">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		    			<INPUT TYPE="button" align="middle"  value="Query" style="font-family: Tahoma,Georgia; font-size: 12px" onClick='setSubmit("../jsp/TSCEDIHistoryQuery.jsp")' > 
						&nbsp;&nbsp;&nbsp;
						<input type="button" name="submit1" value="Export To Excel" style="font-family: Tahoma,Georgia; font-size: 12px" onClick='setSubmit1("../jsp/TSCEDIHistoryExcel.jsp")'>
					</td>
   				</tr>
			</table>  
		</td>
	</tr>
	<tr>
		<td width="15">&nbsp;</td>
	</tr>
	<%
	try
	{
		if (PDNFLAG.equals("Y"))
		{
			sql = " SELECT a.order_number \"M/O\",b.line_number||'.'||b.shipment_number \"Line No.\","+
				  " b.customer_shipment_number \"Customer PO Line No.\",e.description \"Part Number\","+
				  " b.ordered_item \"Cust P/N\",d.customer_name \"Customer\",b.customer_line_number \"P/O No.\","+
				  " to_char(b.creation_date,'yyyy-mm-dd') \"Order Date\",to_char(b.schedule_ship_date,'yyyy-mm-dd') SSD,to_char(b.request_date,'yyyy-mm-dd') CRD,b.shipping_method_code \"Shipping Method\",b.ordered_quantity Qty ,REMARK \"備註\""+
				  " FROM ont.oe_order_headers_all a,ont.oe_order_lines_all b ,(select distinct c.REQUEST_DATE, c.currency_code,c.erp_customer_id,c.customer_po,d.cust_po_line_no,d.REMARK from "+
				  " tsc_edi_orders_his_h c,tsc_edi_orders_his_d d where c.request_no =d.request_no and c.erp_customer_id= d.erp_customer_id and d.PDN_FLAG='Y') c,ar_customers d,inv.mtl_system_items_b e,tsc_edi_customer f"+
				  " where a.header_id = b.header_id"+
				  " and a.sold_to_org_id=c.erp_customer_id"+
				  " and b.customer_line_number=c.customer_po"+
				  " and b.customer_shipment_number=c.cust_po_line_no"+
				  " and a.sold_to_org_id=d.customer_id"+
				  " and b.inventory_item_id=e.inventory_item_id"+
				  " and a.SHIP_FROM_ORG_ID=e.organization_id"+
				  " and a.sold_to_org_id =f.customer_id";
			if (!CUSTPO.equals(""))
			{
				sql += " and c.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
			}
			if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
			{
				sql += " and c.erp_customer_id ='" + CUSTOMER +"'";
			}
			if (!CURRENCY.equals(""))  //add by Peggy 20141029
			{
				sql += " and c.CURRENCY_CODE ='" +CURRENCY.toUpperCase() +"'";
			}			
			if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
			{
				sql += " and c.REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
			}
			if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
			{
				sql += " and c.REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
			}
			if (UserRoles!="admin" && !UserRoles.equals("admin")) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=f.SALES_AREA_NO)";
			}						
			//out.println(sql);
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);	
			int i =0;	
			while (rs.next())
			{
				i++;
				if ( i==1)
				{
					out.println("<tr>");
					out.println("<td>");
					out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#ffffff' bordercolordark='#A289B1' bordercolor='#8B9F79'>");
					out.println("<tr bgcolor='#8B9F79'>");
					out.println("<td width='5%' height='20' nowrap><div align='center'><font color='#ffffff'>Seq No</font></div></td>");
					out.println("<td width='10%' height='20' nowrap><div align='center'><font color='#ffffff'>M/O</font></div></td>");
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Line No.</font></div></td>");            
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Customer PO Line No.</font></div></td>");
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Part Number</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Cust P/N</font></div></td>"); 
					out.println("<td width='14%' nowrap><div align='center'><font color='#ffffff'>Customer</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>P/O No.</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Order Date</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>SSD</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>CRD</font></div></td>"); 
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Shipping Method</font></div></td>"); 
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Qty</font></div></td>"); 
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>Remarks</font></div></td>"); 
					out.println("</tr>");
				}
				out.println("<tr bgcolor='#CFD1C0' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#CFD1C0',style.color='#000000';this.style.fontWeight='normal'"+'"'+">");    
				out.println("<td align='center'>"+(i)+"</td>");
				out.println("<td align='left'>"+rs.getString("M/O")+"</td>");
				out.println("<td align='center'>"+rs.getString("Line No.")+"</td>");
				out.println("<td align='center'>"+rs.getString("Customer PO Line No.")+"</td>");
				out.println("<td align='center'>"+rs.getString("Part Number")+"</td>");
				out.println("<td align='center'>"+rs.getString("Cust P/N")+"</td>");
				out.println("<td align='center'>"+rs.getString("Customer")+"</td>");
				out.println("<td align='center'>"+rs.getString("P/O No.")+"</td>");
				out.println("<td align='center'>"+rs.getString("Order Date")+"</td>");
				out.println("<td align='center'>"+rs.getString("SSD")+"</td>");
				out.println("<td align='center'>"+rs.getString("CRD")+"</td>");
				out.println("<td align='center'>"+rs.getString("Shipping Method")+"</td>");
				out.println("<td align='center'>"+rs.getString("Qty")+"</td>");
				out.println("<td align='center'>"+(rs.getString("備註")==null?"&nbsp;":rs.getString("備註"))+"</td>");
				out.println("</tr>");
			}
			rs.close();
			statement.close();
			if (i >0)
			{	
				out.println("</table>");
				out.println("</td>");
				out.println("</tr>");
			}
			else
			{
				out.println("<tr><td align='center'><font color='red'>No Data Found!!</font></td></tr>");
			}
		}
		else
		{
			if (!POSTATUS.equals("6"))
			{
				/*
				//sql = " select a.ERP_CUSTOMER_ID, CUSTOMER_NAME \"客戶\", a.CUSTOMER_PO \"客戶訂單\",d.REQUEST_DATE \"申請日期\" "+
				//	  ",CASE WHEN a.data_flag='C' then 'Cancelled' when (SELECT COUNT(1) FROM oraddman.tsdelivery_notice_detail y  WHERE y.CUST_PO_NUMBER =a.CUSTOMER_PO AND LSTATUSID not in ('010','012')) > 0 THEN 'In Progress' ELSE 'Closed' END  AS \"PO狀態\""+
				//	  ", NVL(pi_seqno,'') \"OC狀態\",nvl(c.UPDATED_DATE,'') \"OC更新時間\" ,a.remarks,a.data_flag"+
				//	  ", nvl((select TO_CHAR(max(CREATION_DATE) ,'yyyy-mm-dd hh24:mi') FROM tsc_edi_orders_detail x where x.CUSTOMER_PO=a.CUSTOMER_PO and x.ERP_CUSTOMER_ID=a.ERP_CUSTOMER_ID),'') last_update_date"+
				//	  ", (select count(1) from tsc_edi_orders_his_d x,tsc_edi_orders_his_h y where x.request_no=y.request_no and x.erp_customer_id = y.erp_customer_id and y.erp_customer_id=a.erp_customer_id and y.customer_po= a.customer_po and x.DATA_FLAG IN ('N')) UNCONFIRM_CNT "+
				//	  " from tsc_edi_orders_header a,tsc_edi_customer b, "+
				//	  " (select pi_seqno ||'-'||version_number pi_seqno,CUST_PO_NUMBER,TO_char(max(UPDATED_DATE),'yyyy-mm-dd hh24:mi') UPDATED_DATE from daphne_pi_temp x group by  pi_seqno ||'-'||version_number,CUST_PO_NUMBER) c,"+
				//	  " (select customer_po,erp_customer_id,max(REQUEST_DATE) REQUEST_DATE from tsc_edi_orders_his_h y group by customer_po,erp_customer_id)  d"+ 
				//	  " WHERE a.erp_customer_id=b.CUSTOMER_ID"+
				//	  " and a.CUSTOMER_PO=c.cust_po_number(+)"+
				//	  " and a.customer_po=d.customer_po"+
				//	  " and a.erp_customer_id=d.erp_customer_id";
				sql = " SELECT a.erp_customer_id,"+
					  " b.customer_name ,"+
					  " a.customer_po,"+
					  " max(d.request_date) request_date,"+
					  //" to_char(max(c.creation_date),'yyyy-mm-dd hh24:mi') last_update_date,"+
					  " NVL(to_char(max(c.creation_date),'yyyy-mm-dd hh24:mi'),(select to_char(max(x.last_update_date),'yyyy-mm-dd hh24:mi') from tsc_edi_orders_his_d x, tsc_edi_orders_his_h y  where x.request_no=y.request_no and x.erp_customer_id=y.erp_customer_id and y.customer_po =a.customer_po and y.erp_customer_id=a.erp_customer_id and x.DATA_FLAG='Y')) last_update_date,"+
					  " nvl(e.unconfirm_cnt,0) unconfirm_cnt,"+
					  " nvl(g.open_cnt,0) open_cnt,"+
					  " max(f.pi_seqno || nvl2(f.pi_seqno,'-','') || version_number) OC_NO,"+
					  " TO_CHAR (MAX (f.updated_date), 'yyyy-mm-dd hh24:mi') OC_LAST_UPDATE_DATE,"+
					  " case when nvl(h.pending_cnt,0)>0 then 'Mail to customer: '||h.MAILED_DATE||' - await ctm order change.<br>' else '' end || a.remarks remarks,"+
					  " a.data_flag,"+
					  " nvl(h.pending_cnt,0) pending_cnt"+
					  " ,a.CURRENCY_CODE"+ //add by Peggy 20141029
					  " FROM tsc_edi_orders_header a,"+
					  " tsc_edi_customer b,"+
					  " tsc_edi_orders_detail c,"+
					  " (select customer_po,erp_customer_id, request_date from tsc_edi_orders_his_h  "+
					  " where 1=1";
				if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
				{
					sql += " and REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
				}
				if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
				{
					sql += " and REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
				}				  
				sql += ") d,"+
					   " (SELECT y.customer_po,y.erp_customer_id,count(1) unconfirm_cnt"+
					   " FROM tsc_edi_orders_his_d x, tsc_edi_orders_his_h y"+
					   " WHERE     x.request_no = y.request_no"+
					   " AND x.erp_customer_id = y.erp_customer_id"+
					   " AND x.data_flag IN ('N') AND MAILED_DATE IS NULL"+
					   " group by y.customer_po,y.erp_customer_id) e,"+
					   " daphne_pi_temp f,"+
					   " (SELECT a.erp_customer_id, a.customer_po,count(1) open_cnt"+
					   " FROM tsc_edi_orders_detail a"+
					   " WHERE  DATA_FLAG IS NULL "+
					   " and NOT EXISTS (SELECT 1 FROM ONT.OE_ORDER_LINES_ALL m,ONT.OE_ORDER_HEADERS_ALL n "+
					   " WHERE n.HEADER_ID = m.HEADER_ID  and  m.ordered_quantity>0 and m.FLOW_STATUS_CODE <>'CANCELLED' "+
					   " AND EXISTS (SELECT 1 FROM tsc_edi_customer x where x.customer_id=n.sold_to_org_id) and n.SOLD_TO_ORG_ID = a.erp_customer_id and m.customer_line_number = a.customer_po "+
					   " AND m.customer_shipment_number= a.CUST_PO_LINE_NO)"+
					   " group by a.erp_customer_id, a.customer_po) g"+
					   " ,(select erp_customer_id, customer_po ,count(1) pending_cnt,to_char(max(MAILED_DATE),'yyyy-mm-dd') MAILED_DATE"+
					   " from tsc_edi_orders_detail where DATA_FLAG='P' group by erp_customer_id, customer_po ) h"+
					   " WHERE     a.erp_customer_id = b.customer_id"+
					   " AND a.customer_po = d.customer_po"+
					   " AND a.erp_customer_id = d.erp_customer_id"+
					   " AND a.customer_po = c.customer_po(+)"+
					   " AND a.erp_customer_id = c.erp_customer_id(+)"+
					   " AND a.customer_po = e.customer_po(+)"+
					   " AND a.erp_customer_id = e.erp_customer_id(+)"+
					   " AND a.customer_po=f.cust_po_number(+)"+
					   " AND a.customer_po = g.customer_po(+)"+
					   " AND a.erp_customer_id = g.erp_customer_id(+)"+
					   " AND a.customer_po = h.customer_po(+)"+
					   " AND a.erp_customer_id = h.erp_customer_id(+)";
				if (!CUSTPO.equals(""))
				{
					sql += " and a.CUSTOMER_PO  ='"+CUSTPO+"'";
				}
				if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
				{
					sql += " and b.CUSTOMER_ID ='" + CUSTOMER +"'";
				}
				if (!CURRENCY.equals(""))  //add by Peggy 20141029
				{
					sql += " and a.CURRENCY_CODE ='" +CURRENCY.toUpperCase() +"'";
				}			
				
				if (UserRoles!="admin" && !UserRoles.equals("admin")) 
				{ 
					sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
				}
				sql += "group by a.erp_customer_id,b.customer_name ,a.customer_po,a.remarks,a.currency_code,a.data_flag,nvl(e.unconfirm_cnt,0),nvl(g.open_cnt,0),nvl(h.pending_cnt,0),h.MAILED_DATE";
				if (!POSTATUS.equals("--") && !POSTATUS.equals(""))
				{
					if (POSTATUS.equals("0"))
					{
						//sql += " having  a.customer_po  <> '1301422229' and a.customer_po  <> '1301441404' and (nvl(e.unconfirm_cnt,0) >0 or nvl(g.open_cnt,0) >0 or  max(f.pi_seqno) IS NULL or  (nvl(e.unconfirm_cnt,0)=0 and max(c.creation_date) is not null and max(f.updated_date) is not null and max(c.creation_date)>max(f.updated_date)) or nvl(h.pending_cnt,0) >0)";
						sql += " having  a.customer_po  <> '1301422229' and a.customer_po  <> '1301441404' and sum(case when C.DATA_FLAG='C' THEN 0 ELSE 1 END ) >0 and (nvl(e.unconfirm_cnt,0) >0 or nvl(g.open_cnt,0) >0 or  max(f.pi_seqno) IS NULL or  (nvl(e.unconfirm_cnt,0)=0 and max(f.updated_date) is not null and NVL(max(c.creation_date),(SELECT MAX (x.last_update_date) FROM tsc_edi_orders_his_d x, tsc_edi_orders_his_h y WHERE x.request_no = y.request_no AND x.erp_customer_id = y.erp_customer_id AND y.customer_po = a.customer_po AND y.erp_customer_id = a.erp_customer_id AND x.data_flag = 'Y'))>max(f.updated_date)) or nvl(h.pending_cnt,0) >0)";						
					}
					else if (POSTATUS.equals("1"))
					{
						sql += " having nvl(e.unconfirm_cnt,0) >0 ";
					}
					else if (POSTATUS.equals("2"))
					{
						sql += " having nvl(g.open_cnt,0) >0 ";
					}
					else if (POSTATUS.equals("3"))
					{
						//sql += " having  max(f.pi_seqno) IS NULL";
						sql += " having  a.customer_po  <> '1301422229' and a.customer_po  <> '1301441404' and nvl(e.unconfirm_cnt,0)=0 AND nvl(g.open_cnt,0) =0 AND nvl(h.pending_cnt,0)=0 AND max(f.pi_seqno) IS NULL and sum(case when C.DATA_FLAG='C' THEN 0 ELSE 1 END ) >0"; //modify by Peggy 20140514
					}
					else if (POSTATUS.equals("4"))					
					{
						//sql += " having (nvl(e.unconfirm_cnt,0)=0 and nvl(h.pending_cnt,0)=0 and max(c.creation_date) is not null and max(f.updated_date) is not null and max(c.creation_date)>max(f.updated_date)) ";
						sql += " having sum(case when C.DATA_FLAG='C' THEN 0 ELSE 1 END ) >0 and (nvl(e.unconfirm_cnt,0)=0 and nvl(h.pending_cnt,0)=0 and max(f.updated_date) is not null and NVL(max(c.creation_date),(SELECT MAX (x.last_update_date) FROM tsc_edi_orders_his_d x, tsc_edi_orders_his_h y WHERE x.request_no = y.request_no AND x.erp_customer_id = y.erp_customer_id AND y.customer_po = a.customer_po AND y.erp_customer_id = a.erp_customer_id AND x.data_flag = 'Y'))>max(f.updated_date)) ";
					}
					else if (POSTATUS.equals("5"))					
					{
						sql += " having nvl(h.pending_cnt,0) >0";
					}				
				}
				sql += " order by 	a.erp_customer_id,	a.customer_po";	
				*/
				sql = " SELECT tt.* "+
                      " FROM (SELECT b.erp_customer_id customer_id,"+
                      "              a.customer_name,"+
                      "              b.customer_po,"+
                      "              b.data_flag,"+
                      "              b.currency_code,"+
                      "              TO_CHAR (NVL (c.creation_date, e.last_update_date),'yyyy-mm-dd hh24:mi') last_update_date,"+
                      "              (SELECT MAX (request_date) FROM tsc_edi_orders_his_h x WHERE x.erp_customer_id = b.erp_customer_id AND x.customer_po = b.customer_po) request_date,"+
                      "              nvl(c.cust_order_cnt,0) cust_order_cnt,"+
                      "              nvl(c.pending_cnt,0) pending_cnt,"+
                      "              c.mailed_date,"+
                      "              MAX (d.pi_seqno || NVL2 (d.pi_seqno, '-', '') || version_number) oc_no,"+
                      "              TO_CHAR (MAX (d.updated_date), 'yyyy-mm-dd hh24:mi') oc_last_update_date,"+
                      "              NVL (e.unconfirm_cnt, 0) unconfirm_cnt,"+
                      "              NVL (b.customer_po_line_cnt, 0) tsc_order_cnt,"+
                      "              NVL (c.cust_order_cnt, 0) - NVL (b.customer_po_line_cnt, 0) open_cnt,"+
                      "              CASE WHEN NVL (c.pending_cnt, 0) > 0 THEN 'Mail to customer: '|| c.mailed_date|| ' - await ctm order change.' ELSE '' END || b.remarks as remarks,"+
                      "              NVL (b.customer_po_line_open, 0) tsc_order_open_cnt,"+
					  "              b.NON_EXP_FLAG,"+
					  "              case when nvl(b.NON_EXP_FLAG,'N')='Y' THEN b.NON_EXP_REMARKS||' Pass by '|| b.LAST_UPDATED_BY||' on '|| to_char(b.LAST_UPDATE_DATE,'yyyymmdd') else '' end as header_remarks"+
					  "              ,ac.customer_number"+
                      "        FROM tsc_edi_customer a,"+
                      "             (select b.*,po.CUSTOMER_PO_LINE_CNT,po.CUSTOMER_PO_LINE_OPEN "+
					  "             from tsc_edi_orders_header b, "+
					  "             table(tsc_edi_pkg.GET_OPEN_PO_INFO(ERP_CUSTOMER_ID,CUSTOMER_PO)) po"+
					  "              where exists (select 1 from TSC_EDI_ORDERS_HIS_H teoh where 1=1"+
				      "              and teoh.REQUEST_DATE between rpad('"+CYearFr.replace("-","2013")+"',4,'0')||rpad('"+CMonthFr.replace("-","01")+"',2,'0')||rpad('"+CDayFr.replace("-","01")+"',2,'0')"+
					  "              and rpad('"+CYearTo.replace("-",dateBean.getYearString())+"',4,'0')||rpad('"+CMonthTo.replace("-",dateBean.getMonthString())+"',2,'0')||rpad('"+CDayTo.replace("-",dateBean.getDayString())+"',2,'0')"+
				      "              and teoh.erp_customer_id=b.erp_customer_id and teoh.customer_po=b.customer_po)) b"+
				      "            ,(SELECT erp_customer_id,customer_po,MAX (creation_date) creation_date,SUM (CASE WHEN data_flag = 'P' THEN 1 ELSE 0 END)  AS pending_cnt, MAX (CASE WHEN data_flag = 'P' THEN mailed_date  ELSE NULL END) AS mailed_date,COUNT (DISTINCT CASE WHEN NVL (data_flag, 'XX') = 'XX' and QUANTITY>0 THEN cust_po_line_no ELSE NULL END) AS cust_order_cnt"+
					  "             , CASE WHEN COUNT(DISTINCT CUST_PO_LINE_NO) = COUNT(DISTINCT CASE WHEN NVL (data_flag, 'XX') = 'C' and trunc(creation_date)>=to_date('20190101','yyyymmdd') THEN cust_po_line_no ELSE NULL END) THEN 'Y' ELSE 'N' END as po_all_cancel_flag "+ //add by Peggy 20190515
					  "             FROM tsc_edi_orders_detail GROUP BY erp_customer_id, customer_po) c,"+
                      "             daphne_pi_temp d,"+
                      "             (SELECT y.erp_customer_id, y.customer_po cust_po_number,SUM (CASE WHEN x.data_flag = 'N' AND x.mailed_date IS NULL THEN 1 ELSE 0 END) unconfirm_cnt, MAX (CASE WHEN x.data_flag = 'Y' THEN x.last_update_date  ELSE NULL END) AS last_update_date FROM tsc_edi_orders_his_d x, tsc_edi_orders_his_h y WHERE x.request_no = y.request_no AND x.erp_customer_id = y.erp_customer_id "+
				      "              and y.REQUEST_DATE between rpad('"+CYearFr.replace("-","2013")+"',4,'0')||rpad('"+CMonthFr.replace("-","01")+"',2,'0')||rpad('"+CDayFr.replace("-","01")+"',2,'0')"+
					  "              and rpad('"+CYearTo.replace("-",dateBean.getYearString())+"',4,'0')||rpad('"+CMonthTo.replace("-",dateBean.getMonthString())+"',2,'0')||rpad('"+CDayTo.replace("-",dateBean.getDayString())+"',2,'0')"+
					//if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
					//{
					//	sql += " and y.REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
					//}
					//if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
					//{
					//	sql += " and y.REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
					//}	
         "             GROUP BY y.erp_customer_id, y.customer_po ) e,"+
                      //"             tsc_edi_erp_orders_v f,"+
					  "             ar_customers ac"+
                      "        WHERE  a.customer_id = b.erp_customer_id"+
                      "        AND b.customer_po = c.customer_po"+
                      "        AND b.erp_customer_id = c.erp_customer_id"+
                      "        AND b.customer_po = d.cust_po_number(+)"+
					  "        AND b.erp_customer_id=d.customer_id(+)"+
                      "        AND b.erp_customer_id = e.erp_customer_id"+
                      "        AND b.customer_po = e.cust_po_number"+
                      //"        AND b.erp_customer_id = f.customer_id(+)"+
					  "        AND a.customer_id=ac.customer_id";
                      //"        AND b.customer_po = f.customer_po(+)";
					  //"        AND NVL(b.non_exp_flag,'N')='N'"; //add by Peggy 20160321
				if (!CUSTPO.equals(""))
				{
					sql += " and b.CUSTOMER_PO  ='"+CUSTPO+"'";
				}
				if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
				{
					sql += " and b.erp_customer_id ='" + CUSTOMER +"'";
				}
				if (!CURRENCY.equals(""))  //add by Peggy 20141029
				{
					sql += " and b.CURRENCY_CODE ='" +CURRENCY.toUpperCase() +"'";
				}			
				if (UserRoles!="admin" && !UserRoles.equals("admin")) 
				{ 
					sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=a.SALES_AREA_NO)";
				}	
				sql += "       GROUP BY b.erp_customer_id,"+
                       "                a.customer_name,"+
                       "                b.customer_po,"+
                       "                b.data_flag,"+
                       "                b.currency_code,"+
                       "                b.remarks,"+
                       "                c.creation_date,"+
                       "                c.mailed_date,"+
                       "                c.cust_order_cnt,"+
                       "                c.pending_cnt,"+
                       "                e.unconfirm_cnt,"+
                       "                e.last_update_date,"+
                       //"                f.customer_po_line_cnt,"+
					   //"                f.CUSTOMER_PO_LINE_OPEN,"+
                       "                b.customer_po_line_cnt,"+
					   "                b.CUSTOMER_PO_LINE_OPEN,"+
					   "                b.NON_EXP_FLAG,"+
					   "                b.NON_EXP_REMARKS,"+
					   "                b.LAST_UPDATED_BY,"+
					   "                b.LAST_UPDATE_DATE,"+
					   "                c.po_all_cancel_flag,"+ //add by Peggy 20190515
					   "                ac.customer_number"+
					   //"  "+(!POSTATUS.equals("--") && !POSTATUS.equals("")?"  having nvl(c.cust_order_cnt,0) >0 and nvl(B.non_exp_flag,'N')<>'Y' ":"")+") tt"+
					   "  "+(!POSTATUS.equals("--") && !POSTATUS.equals("")?"  having (nvl(c.cust_order_cnt,0) >0  or c.po_all_cancel_flag='Y') and nvl(B.non_exp_flag,'N')<>'Y' ":"")+") tt"+
					   " WHERE  1=1 ";
				if (POSTATUS.equals("1") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" tt.unconfirm_cnt > 0";
                if (POSTATUS.equals("2") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" tt.open_cnt > 0";
                if (POSTATUS.equals("3") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" (tt.unconfirm_cnt =0 and tt.open_cnt =0 and tt.oc_no IS NULL)";
                //if (POSTATUS.equals("4") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" (tt.unconfirm_cnt =0 and tt.open_cnt =0 and tt.tsc_order_open_cnt >0 and tt.oc_no IS NOT NULL AND tt.last_update_date > tt.oc_last_update_date)";
				if (POSTATUS.equals("4") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" (tt.unconfirm_cnt =0 and tt.open_cnt =0 and tt.oc_no IS NOT NULL AND tt.last_update_date > tt.oc_last_update_date)";
				if (POSTATUS.equals("5") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" tt.pending_cnt > 0";
                if (POSTATUS.equals("7") || POSTATUS.equals("0")) sql1+= (sql1.length()>0?" or ":"")+" (tt.unconfirm_cnt =0 and tt.open_cnt =0 and tt.tsc_order_open_cnt =0 and tt.oc_no IS NOT NULL AND tt.last_update_date > tt.oc_last_update_date)";
				sql += (sql1.length()>0?" and ("+sql1+") ":"") +" ORDER BY tt.customer_id, tt.customer_po";
				//out.println(sql);
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);	
				int i =0;	
				String str_remark = ""; //add by Peggy 20140224
				String linkurl="";
				while (rs.next())
				{
					i++;
					if ( i==1)
					{
						out.println("<tr>");
						out.println("<td>");
						out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#ffffff' bordercolordark='#A289B1' bordercolor='#8B9F79'>");
						out.println("<tr align='center' height='25' bgcolor='#8B9F79' valign='middle'>");
						out.println("<td width='3%'><input type='checkbox' name='chkall' onClick='checkall()' "+(POSTATUS.equals("7")?"":"disabled")+"></td>");					
						out.println("<td width='3%' height='20' nowrap><div align='center'><font color='#ffffff'>Seq No</font></div></td>");
						out.println("<td width='4%' nowrap><div align='center'><font color='#ffffff'>Cust#</font></div></td>");            
						out.println("<td width='17%' nowrap><div align='center'><font color='#ffffff'>Customer</font></div></td>");            
						out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Customer PO</font></div></td>");
						out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Currency</font></div></td>");
						out.println("<td width='6%' nowrap><div align='center'><font color='#ffffff'>Last Request Date</font></div></td>"); 
						out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Last Update Date</font></div></td>"); 
						out.println("<td width='7%' nowrap><div align='center'><font color='#ffffff'>PO Unconfirm</font></div></td>"); 
						out.println("<td width='7%' nowrap><div align='center'><font color='#ffffff'>PO Untransfer MO</font></div></td>");
						out.println("<td width='7%' nowrap><div align='center'><font color='#ffffff'>Waiting Customer Reply</font></div></td>");
						out.println("<td width='7%' nowrap><div align='center'><font color='#ffffff'>OC Version</font></div></td>"); 
						out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>OC Last Update Date</font></div></td>"); 
						out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>Remarks</font></div></td>"); 
						out.println("</tr>");
					}
					linkurl="onclick='openSubWindow("+'"'+"../jsp/TSCEDIDetailQuery.jsp?ERPCUSTOMERID="+rs.getString("CUSTOMER_ID")+"&DFLAG="+rs.getString("data_flag")+"&CUSTPO="+rs.getString("CUSTOMER_PO")+'"'+")'";
					out.println("<tr bgcolor='#CFD1C0' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#CFD1C0',style.color='#000000';;this.style.fontWeight='normal'"+'"'+"  title='Press the left mouse button, enter the order details inquiry screen!' >");    
					out.println("<td align='center'><input type='checkbox' name='chk' value='"+rs.getString("CUSTOMER_ID")+"_"+rs.getString("CUSTOMER_PO")+"' onClick='setCheck("+(i)+")' "+(POSTATUS.equals("7")?"":"disabled")+"></td>");
					out.println("<td align='center'>"+(i)+"</td>");
					out.println("<td align='center'" +linkurl+">"+rs.getString("customer_number")+"</td>");
					out.println("<td align='left'" +linkurl+">"+rs.getString("customer_name")+"</td>");
					out.println("<td align='left'" +linkurl+">"+rs.getString("customer_po")+"</td>");
					out.println("<td align='center'" +linkurl+">"+rs.getString("currency_code")+"</td>");  //add by Peggy 20141029
					out.println("<td align='center'" +linkurl+">"+rs.getString("request_date")+"</td>");
					out.println("<td align='center'" +linkurl+">"+(rs.getString("last_update_date")==null||rs.getString("last_update_date").equals("null")?"&nbsp;":rs.getString("last_update_date"))+"</td>");
					out.println("<td align='center'" +linkurl+">"+(!rs.getString("UNCONFIRM_CNT").equals("0")?"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("UNCONFIRM_CNT")+"</font>":rs.getString("UNCONFIRM_CNT"))+"</td>");
					out.println("<td align='center'" +linkurl+">"+(!rs.getString("open_CNT").equals("0")?"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("open_cnt")+"</font>":rs.getString("open_CNT"))+"</td>");
					out.println("<td align='center'" +linkurl+">"+(!rs.getString("pending_CNT").equals("0")?"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("pending_cnt")+"</font>":rs.getString("pending_CNT"))+"</td>");
					if (rs.getString("UNCONFIRM_CNT").equals("0"))
					{
						if (rs.getString("OC_LAST_UPDATE_DATE")!=null && rs.getString("last_update_date") != null)
						{
							SimpleDateFormat sy1=new SimpleDateFormat("yyyy-MM-dd HH:mm");
							if (sy1.parse(rs.getString("OC_LAST_UPDATE_DATE")).before(sy1.parse(rs.getString("last_update_date"))))
							{
								out.println("<td align='center' title='Please note that the po has not been reply order change'" +linkurl+"><font style='color:#ff0000;font-weight:bold'>"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</font></td>");
							}
							else
							{
								out.println("<td align='center'" +linkurl+">"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
							}
						}
						else
						{
							out.println("<td align='center'" +linkurl+">"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
						}
					}
					else
					{
						out.println("<td align='center'" +linkurl+">"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
					}
					out.println("<td align='center'" +linkurl+">"+(rs.getString("OC_LAST_UPDATE_DATE")==null||rs.getString("OC_LAST_UPDATE_DATE").equals("null")?"&nbsp;":rs.getString("OC_LAST_UPDATE_DATE"))+"</td>");
					str_remark =(rs.getString("header_remarks")==null?"":rs.getString("header_remarks"));
					if (rs.getString("remarks")!=null && !rs.getString("remarks").equals("null"))
					{
						str_remark += (str_remark.equals("")?"":"<br>")+rs.getString("remarks");
					}	
					if (str_remark.equals("")) str_remark  = "&nbsp;";				
					out.println("<td align='LEFT'" +linkurl+">"+str_remark +"</td>");
					out.println("</tr>");
				}
				rs.close();
				statement.close();
				if (i >0)
				{	
					out.println("</table>");
					out.println("<hr>");
					out.println("<div>");
					out.println("<input type='button' name='btn1' value='PASS' onclick='setPass()' style='font-family: Tahoma,Georgia; font-size:12px' "+(POSTATUS.equals("7")?"":"disabled")+">&nbsp;&nbsp;Pass Reason:<input type='text' name='passreason' value='' style='font-family:Tahoma,Georgia;font-size:12px' "+(POSTATUS.equals("7")?"":"disabled")+">");
					out.println("</td>");
					out.println("</tr>");
				}
				else
				{
					out.println("<tr><td align='center'><font color='red'>No Data Found!!</font></td></tr>");
				}
			}
			else //quantity or price issue,add by Peggy 20141120
			{
				String ERP_CUSTOMER_ID="",CUSTOMER_PO="",CUSTOMER_PO_LINE="",STRBGCOLOR="",ORDER_QTY="",UNIT_PRICE="";
				sql = " select a.erp_customer_id,b.customer_name,a.currency_code,a.customer_po,a.cust_po_line_no,a.cust_item_name,a.tsc_item_name,a.quantity,a.uom,a.unit_price,a.cust_request_date,d.creation_date,d.last_update_date,"+
                      " e.ORDER_NUMBER,e.lineno,e.ORDERED_ITEM,e.DESCRIPTION,e.ORDERED_QUANTITY,e.UNIT_SELLING_PRICE,e.po_line_cnt ,e.po_line_tot_qty,to_char(e.request_date,'yyyymmdd') request_date "+
					  " ,ac.customer_number"+
                      " FROM (select a.ERP_CUSTOMER_ID,a.CURRENCY_CODE,a.CUSTOMER_PO,b.CUST_PO_LINE_NO,b.CUST_ITEM_NAME,b.TSC_ITEM_NAME,sum(b.QUANTITY) QUANTITY,b.UOM,b.UNIT_PRICE,b.CUST_REQUEST_DATE from tsc_edi_orders_header a,tsc_edi_orders_detail b "+
                      " where  a.customer_po = b.customer_po(+)"+
                      " AND a.erp_customer_id = b.erp_customer_id(+)"+
                      " group by a.ERP_CUSTOMER_ID,a.CURRENCY_CODE,a.CUSTOMER_PO,b.CUST_PO_LINE_NO,b.CUST_ITEM_NAME,b.TSC_ITEM_NAME,b.UOM,b.UNIT_PRICE,b.CUST_REQUEST_DATE"+
                      ") a,"+
                      " tsc_edi_customer b,"+
                      " (select  distinct erp_customer_id, customer_po,min(request_date) over(partition by erp_customer_id,customer_po) creation_date,max(request_date) over(partition by erp_customer_id,customer_po) last_update_date "+
					  " from tsc_edi_orders_his_h where 1=1";
				if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
				{
					sql += " and REQUEST_DATE >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
				}
				if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
				{
					sql += " and REQUEST_DATE <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
				}				  
				sql += ") d,"+
                      " (select a.sold_to_org_id,a.order_number,b.line_number||'.'||b.shipment_number lineno,b.customer_line_number,b.customer_shipment_number"+
                      " ,b.ordered_item,c.segment1,c.description,b.unit_selling_price,b.ordered_quantity,b.order_quantity_uom,b.request_date"+
                      " ,sum(b.ordered_quantity) over(partition by a.sold_to_org_id,b.customer_line_number,b.customer_shipment_number,trunc(b.request_date)) po_line_tot_qty"+
                      " ,row_number() over(partition by a.sold_to_org_id,b.customer_line_number,b.customer_shipment_number,trunc(b.request_date) order by a.sold_to_org_id,b.customer_line_number) po_line_cnt"+
                      " from ont.oe_order_headers_all a,ont.oe_order_lines_all b,inv.mtl_system_items_b c"+
                      " where a.header_id=b.header_id"+
                      " and nvl(b.cancelled_flag,'N') = 'N'"+
                      " and nvl(a.cancelled_flag,'N') = 'N'"+
                      " and b.flow_status_code not in ('CANCELLED')"+
                      " and b.inventory_item_id=c.inventory_item_id"+
                      " and b.ship_from_org_id=c.organization_id"+
                      " and exists (select 1 from tsc_edi_customer d where d.customer_id=a.sold_to_org_id)) e"+
					  ",ar_customers ac"+
                      " WHERE     a.erp_customer_id = b.customer_id"+
                      " AND a.customer_po = d.customer_po"+
                      " AND a.erp_customer_id = d.erp_customer_id"+
                      " and a.erp_customer_id=e.sold_to_org_id"+
                      " and a.customer_po=e.customer_line_number"+
                      " and a.cust_po_line_no=e.CUSTOMER_SHIPMENT_NUMBER"+
					  " and a.CUST_REQUEST_DATE=to_char(e.request_date,'yyyymmdd')"+
                      " and (a.quantity<>e.PO_LINE_TOT_QTY"+
                      " or exists (select 1 from ont.oe_order_headers_all m,ont.oe_order_lines_all n "+
                      " where m.header_id=n.header_id "+
                      " and m.sold_to_org_id=a.erp_customer_id"+
                      " and n.customer_line_number=a.customer_po"+
                      " and n.customer_shipment_number=a.cust_po_line_no"+
					  " and to_char(n.request_date,'yyyymmdd') =a.CUST_REQUEST_DATE"+
					  " and b.customer_id=ac.customer_id"+
                      " and n.unit_selling_price <> a.unit_price))";
				if (!CUSTPO.equals(""))
				{
					sql += " and a.CUSTOMER_PO = '"+CUSTPO+"'";
				}
				if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
				{
					sql += " and b.CUSTOMER_ID ='" + CUSTOMER +"'";
				}
				if (!CURRENCY.equals(""))  //add by Peggy 20141029
				{
					sql += " and a.CURRENCY_CODE ='" +CURRENCY.toUpperCase() +"'";
				}			
				
				if (UserRoles!="admin" && !UserRoles.equals("admin")) 
				{ 
					sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=b.SALES_AREA_NO)";
				}
				sql += "order by a.erp_customer_id,b.customer_name,a.customer_po,a.cust_po_line_no,e.po_line_cnt desc";
					  
				//out.println(sql);
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);	
				int i =0;	
				String str_remark = ""; //add by Peggy 20140224
				while (rs.next())
				{
					if ( i==0)
					{
						out.println("<tr>");
						out.println("<td>");
						out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#ffffff' bordercolordark='#A289B1' bordercolor='#8B9F79'>");
						out.println("<tr height='25' bgcolor='#8B9F79' valign='middle' style='font-size:11px'>");
						out.println("<td width='3%' rowspan='2' height='20' nowrap><font color='#ffffff'>Seq No</font></td>");
						out.println("<td colspan='11' height='20' nowrap style='text-align:center;background-color:#CFD1C0'>EDI</td>");
						out.println("<td colspan='6' height='20' nowrap style='text-align:center;background-color:#AFD1A0'>ERP</td>");
						out.println("</tr>");
						out.println("<tr height='25' bgcolor='#8B9F79' valign='middle' style='font-size:11px;color:#ffffff'>");
						out.println("<td width='3%' align='center'  nowrap>Cust#</td>");      
						out.println("<td width='10%' align='center'  nowrap>Customer</td>");      
						out.println("<td width='3%' align='center'  nowrap>Currency</td>"); 
						out.println("<td width='8%' align='center'  nowrap>Customer PO</td>"); 
						out.println("<td width='4%' align='center'  nowrap>PO Line</td>");  
						out.println("<td width='9%' align='center'  nowrap>TSC PN</td>"); 
						out.println("<td width='5%' align='center'  nowrap>Qty</td>"); 
						out.println("<td width='3%' align='center'  nowrap>Uom</td>"); 
						out.println("<td width='4%' align='center'  nowrap>Selling Price</td>"); 
						out.println("<td width='4%' align='center'  nowrap>CRD</td>"); 
						out.println("<td width='5%' align='center'  nowrap>Creation Date</td>"); 
						out.println("<td width='5%' align='center'  nowrap>Last Update Date</td>"); 
						out.println("<td width='7%' align='center'  nowrap>MO</td>"); 
						out.println("<td width='2%' align='center'  nowrap>MO Line</td>"); 
						out.println("<td width='9%' align='center'  nowrap>TSC PN</td>"); 
						out.println("<td width='5%' align='center'  nowrap>CRD</td>"); 
						out.println("<td width='5%' align='center'  nowrap>MO Qty</td>"); 
						out.println("<td width='5%' align='center'  nowrap>MO Selling Price</td>"); 
						out.println("</tr>");
					}
					if (!ERP_CUSTOMER_ID.equals(rs.getString("erp_customer_id")) || !CUSTOMER_PO.equals(rs.getString("customer_po")) || !CUSTOMER_PO_LINE.equals(rs.getString("CUST_PO_LINE_NO")))
					{
						ERP_CUSTOMER_ID=rs.getString("erp_customer_id");
						CUSTOMER_PO=rs.getString("customer_po");
						CUSTOMER_PO_LINE=rs.getString("CUST_PO_LINE_NO");
						ORDER_QTY=rs.getString("QUANTITY");
						UNIT_PRICE=rs.getString("UNIT_PRICE");
						if (i%2==1)
						{
							STRBGCOLOR="#AFD1A0";
						}
						else
						{
							STRBGCOLOR="#CFD1C0";
						}
						out.println("<tr bgcolor='"+STRBGCOLOR+"' style='font-size:11px'>");    
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+(i+1)+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("customer_number")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("customer_name")+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("currency_code")+"</td>");  
						out.println("<td align='left' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("customer_po")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("CUST_PO_LINE_NO")+"</td>");
						//out.println("<td align='left' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("CUST_ITEM_NAME")+"</td>");
						out.println("<td align='left' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("TSC_ITEM_NAME")+"</td>");
						out.println("<td align='right' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("QUANTITY")+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("UOM")+"</td>");
						out.println("<td align='right' rowspan='"+rs.getString("po_line_cnt")+"'>"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("UNIT_PRICE")))+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("CUST_REQUEST_DATE")+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("CREATION_DATE")+"</td>");
						out.println("<td align='center' rowspan='"+rs.getString("po_line_cnt")+"'>"+rs.getString("LAST_UPDATE_DATE")+"</td>");
						i++;
					}
					else
					{
						out.println("<tr bgcolor='"+STRBGCOLOR+"' style='font-size:11px'>");    
					}
					out.println("<td align='center'>"+rs.getString("ORDER_NUMBER")+"</td>");
					out.println("<td align='center'>"+rs.getString("LINENO")+"</td>");
					//out.println("<td align='left'>"+rs.getString("ORDERED_ITEM")+"</td>");
					out.println("<td align='left'>"+rs.getString("DESCRIPTION")+"</td>");
					out.println("<td align='center'>"+rs.getString("REQUEST_DATE")+"</td>");
					out.println("<td align='right'"+ (!ORDER_QTY.equals(rs.getString("po_line_tot_qty"))?" style='color:#ff0000'":"")+">"+rs.getString("ORDERED_QUANTITY")+"</td>");
					out.println("<td align='right'"+ (!UNIT_PRICE.equals(rs.getString("UNIT_SELLING_PRICE"))?" style='color:#ff0000'":"")+">"+(new DecimalFormat("######0.####")).format(Float.parseFloat(rs.getString("UNIT_SELLING_PRICE")))+"</td>");
					out.println("</tr>");
              	}   
				rs.close();
				statement.close();
				if (i >0)
				{	
					out.println("</table>");
					out.println("</td>");
					out.println("</tr>");
				}
				else
				{
					out.println("<tr><td align='center'><font color='red'>No Data Found!!</font></td></tr>");
				}
				       
			}
		}
	}
	catch(Exception e)
	{
		out.println("<div align='center'><font color='red'>~~ "+e.getMessage()+" ~~</font></div>");
	}
	%>
</table>
</FORM>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>


