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
	var POSTATUS = document.MYFORM.POSTATUS.value;
	//var OCSTATUS = document.MYFORM.OCSTATUS.value;
	var PDNFLAG = "N";
	if (document.MYFORM.PDNFLAG.checked)
	{
		 PDNFLAG = "Y";
	}
	document.MYFORM.action=URL+"?CUSTOMER="+CUSTOMER+"&CUSTPO="+CUSTPO+"&CYEARFR="+CYEARFR+"&CMONTHFR="+CMONTHFR+"&CDAYFR="+CDAYFR+"&CDAYFR="+CDAYFR+"&CMONTHTO="+CMONTHTO+"&CDAYTO="+CDAYTO+"&PDNFLAG="+PDNFLAG+"&POSTATUS="+POSTATUS;
 	document.MYFORM.submit();
}
function openSubWindow(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function objChange()
{
	if (document.MYFORM.CUSTPO.value ==null || document.MYFORM.CUSTPO.value =="")
	{
		return false;
	}
	document.MYFORM.POSTATUS.value ="--";
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed; word-break :break-all}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>TSCE Hub PO Query</title>
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
//dateBean.setAdjDate(-30);
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER == null) CUSTOMER ="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO ="";
String ORDERS = "ORDERS",ORDCHG="ORDCHG";
String CYearFr = request.getParameter("CYEARFR");
if (CYearFr==null)  CYearFr="--";
String CMonthFr = request.getParameter("CMONTHFR");
if (CMonthFr==null) CMonthFr="--";
String CDayFr = request.getParameter("CDAYFR");
if (CDayFr==null) CDayFr="--";
//dateBean.setAdjDate(30);
String CYearTo= request.getParameter("CYEARTO");
if (CYearTo==null) CYearTo="--";
String CMonthTo = request.getParameter("CMONTHTO");
if (CMonthTo==null) CMonthTo="--";
String CDayTo = request.getParameter("CDAYTO");
if (CDayTo==null) CDayTo="--";
String PDNFLAG = request.getParameter("PDNFLAG");
if (PDNFLAG==null) PDNFLAG="";
String POSTATUS = request.getParameter("POSTATUS");
if (POSTATUS==null) POSTATUS="0";
//String OCSTATUS = request.getParameter("OCSTATUS");
//if (OCSTATUS==null) OCSTATUS="";
String ERPCUSTOMERID="1411";
String sql = "";
%>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSCE1214HistoryQuery.jsp" METHOD="post" NAME="MYFORM">
<strong><font style="font-size:18px;color:#000099">TSCE Hub PO Query</font></strong>
<BR>
<table width="100%">
	<tr>
		<td align="right"><A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A></td>
	</tr>
	<tr>
		<td>
  			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1' bgcolor="#DCE6E7">
     			<tr>
					<td width="10%"><font color="#666600" >End Customer:</font></td>   
					<td width="10%"><input type="text" name="CUSTOMER" value="<%=CUSTOMER%>" style="font-family:Arial;font-size:12px" size="20"></td>    
					<td width="5%"><font color="#666600" >Customer PO:</font></td>
					<td width="10%"><input type="text" name="CUSTPO" value="<%=CUSTPO%>" style="font-family:Arial;font-size:12px" size="15" onChange="objChange()"></td>
					<td width="5%"><font color="#666600">Creation Date</font></td>
					<td width="24%">
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
					<td width="5%"><font color="#666600" >PO Status:</font></td>  
					<td width="8%"><SELECT NAME="POSTATUS" style="font-family:Tahoma,Georgia;font-size:12px">
					    <option value="--" selected>--
						<option value="0" <% if (POSTATUS.equals("0")) out.println("selected");%>>All
						<option value="1" <% if (POSTATUS.equals("1")) out.println("selected");%>>PO異常尚未確認
						<option value="2" <% if (POSTATUS.equals("2")) out.println("selected");%>>PO未轉MO
						<option value="3" <% if (POSTATUS.equals("3")) out.println("selected");%>>PO已轉MO,OC未發
						<option value="4" <% if (POSTATUS.equals("4")) out.println("selected");%>>PO異動,OC未重發
						</SELECT>					
					</td> 
					<td width="10%"><font color="#666600" ><input type="checkbox" name="PDNFLAG" value="Y" <%if (PDNFLAG.equals("Y")){out.println("checked");}%>>工程變更註記</font></td>
				</tr>
				<tr>
					<td colspan="12" align="center">
		    			<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCE1214HistoryQuery.jsp")' > 
						&nbsp;&nbsp;&nbsp;
						<input type="button" name="submit1" value="匯出Excel" onClick='setSubmit1("../jsp/TSCE1214HistoryExcel.jsp")'>
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
			sql = " SELECT a.order_number \"M/O\""+
			      ",b.line_number||'.'||b.shipment_number \"Line No.\""+
				  ",b.customer_shipment_number \"Customer PO Line No.\""+
				  ",e.description \"Part Number\","+
				  " b.ordered_item \"Cust P/N\""+
				  ",d.customer_name \"Customer\""+
				  ",b.customer_line_number \"P/O No.\""+
				  ",to_char(b.creation_date,'yyyy-mm-dd') \"Order Date\""+
				  ",to_char(b.schedule_ship_date,'yyyy-mm-dd') SSD"+
				  ",to_char(b.request_date,'yyyy-mm-dd') CRD"+
				  ",b.shipping_method_code \"Shipping Method\""+
				  ",b.ordered_quantity Qty "+
				  ",REMARK \"備註\""+
				  " FROM ont.oe_order_headers_all a"+
				  ",ont.oe_order_lines_all b"+
				  " ,(select distinct c.creation_date,c.customer_po,d.po_line_no cust_po_line_no,d.REMARKS REMARK,c.customer_name from oraddman.tsce_purchase_order_headers c,oraddman.tsce_purchase_order_lines d where c.customer_po =d.customer_po and c.version_id= d.version_id and d.PDN_FLAG='Y') c"+
				  ",ar_customers d"+
				  ",inv.mtl_system_items_b e"+
				  " where a.header_id = b.header_id"+
				  " and b.customer_line_number=c.customer_po"+
				  " and b.customer_shipment_number=c.cust_po_line_no"+
				  " and a.sold_to_org_id=d.customer_id"+
				  " and b.inventory_item_id=e.inventory_item_id"+
				  " and a.SHIP_FROM_ORG_ID=e.organization_id"+
				  " and a.sold_to_org_id ='"+ERPCUSTOMERID+"'";
			if (!CUSTPO.equals(""))
			{
				sql += " and c.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
			}
			if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
			{
				sql += " and (c.CUSTOMER_PO like '" + CUSTOMER +"%' or  c.CUSTOMER_NAME LIKE '"+ CUSTOMER.toUpperCase() +"%')";
			}
			if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
			{
				sql += " and TO_CHAR(c.CREATION_DATE,'yyyymmdd') >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
			}
			if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
			{
				sql += " and TO_CHAR(c.CREATION_DATE,'yyyymmdd') <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
			}
			if (UserRoles!="admin" && !UserRoles.equals("admin")) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano='001')";
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
					out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#ffffff' bordercolordark='#A289B1'>");
					out.println("<tr bgcolor='#8B9F79'>");
					out.println("<td width='5%' height='20' nowrap><div align='center'><font color='#ffffff'>序號</font></div></td>");
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
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>備註</font></div></td>"); 
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
				out.println("<tr><td align='center'><font color='red'>查無資料!!</font></td></tr>");
			}
		}
		else
		{
			sql = " select a.CUSTOMER_NAME"+
			      ",a.CUSTOMER_PO"+
				  ",a.VERSION_ID"+
				  ",c.CURRENCY_CODE"+
                  ",to_char(a.min_CREATION_DATE,'yyyy-mm-dd hh24:mi') CREATION_DATE"+
                  ",TO_CHAR(b.LAST_UPDATE_DATE,'yyyy-mm-dd hh24:mi')  LAST_UPDATE_DATE"+
                  ",TO_CHAR(g.LAST_UPDATE_DATE,'yyyy-mm-dd hh24:mi')  LAST_UPDATE_DATE1"+
                  ",NVL(d.unconfirm_count,0) unconfirm_cnt"+
                  ",NVL(f.OPEN_COUNT,0) open_cnt"+
                  ",max(e.pi_seqno || nvl2(e.pi_seqno,'-','') || e.version_number) OC_NO"+
                  ",TO_CHAR (MAX (e.updated_date), 'yyyy-mm-dd hh24:mi') OC_LAST_UPDATE_DATE"+
				  ",nvl(a.vaild_cnt,0) vaild_cnt"+
                  " from (select k.* ,(select min(creation_date) FROM oraddman.tsce_purchase_order_headers p where p.customer_po=k.customer_po) min_creation_date  "+
				  ",(select count(1) from  oraddman.tsce_purchase_order_lines tpo where tpo.customer_po=k.customer_po and tpo.version_id=k.version_id and tpo.DATA_FLAG in ('Y','X')) vaild_cnt"+
				  " from oraddman.tsce_purchase_order_headers k where ACTIVE_FLAG='A') a,"+
                  " (select CUSTOMER_PO,max(LAST_UPDATE_DATE) LAST_UPDATE_DATE FROM oraddman.tsce_purchase_order_lines where DATA_FLAG in ('Y','C') AND NVL(no_change_flag,'N') ='N' group by CUSTOMER_PO) b,"+
                  " oraddman.tsce_end_customer_list c,"+
                  " (select customer_po, version_id,count(1) unconfirm_count from oraddman.tsce_purchase_order_lines where NVL(DATA_FLAG,'N') in ('N','E') group by customer_po, version_id) d,"+
                  " daphne_pi_temp e,"+
                  " (SELECT x.customer_po, x.version_id,count(1) open_count "+
				  " FROM oraddman.tsce_purchase_order_lines x,oraddman.tsce_purchase_order_headers y"+
                  " WHERE y.CUSTOMER_PO = x.CUSTOMER_PO AND y.VERSION_ID =x.VERSION_ID AND y.ACTIVE_FLAG='A' AND NOT EXISTS ( SELECT 1 FROM ONT.OE_ORDER_LINES_ALL m,ONT.OE_ORDER_HEADERS_ALL n"+
                  " WHERE n.HEADER_ID = m.HEADER_ID "+
                  " AND n.SOLD_TO_ORG_ID = y.erp_customer_id "+
                  " AND m.customer_line_number = x.customer_po"+
                  " AND m.customer_shipment_number= x.PO_LINE_NO"+
                  " AND m.ordered_quantity>0 "+
                  " and m.FLOW_STATUS_CODE <>'CANCELLED')"+
				  " and x.QUANTITY >0"+
				  " and x.DATA_FLAG not in ('C')"+
                  " group by x.customer_po, x.version_id) f"+
                  " ,(select CUSTOMER_PO,max(LAST_UPDATE_DATE) LAST_UPDATE_DATE FROM oraddman.tsce_purchase_order_lines where DATA_FLAG in ('Y','C') group by CUSTOMER_PO) g"+
                  " where a.CUSTOMER_PO = b.CUSTOMER_PO(+)"+
                  //" AND a.VERSION_ID =b.VERSION_ID"+
                  " AND substr(a.customer_po,0,instr(a.customer_po,'-')-1)=c.CUSTOMER_ID(+)"+
				  " AND a.currency_code=c.currency_code(+)"+ //add by Peggy 20210527
                  " AND a.CUSTOMER_PO = d.CUSTOMER_PO(+)"+
                  " AND a.VERSION_ID = d.VERSION_ID(+)"+
                  " AND a.CUSTOMER_PO = f.CUSTOMER_PO(+)"+
                  " AND a.VERSION_ID = f.VERSION_ID(+)"+
                  " AND a.customer_po=e.cust_po_number(+)"+
				  " AND a.CUSTOMER_PO = g.CUSTOMER_PO(+)";
			if (!CUSTPO.equals(""))
			{
				sql += " and a.CUSTOMER_PO LIKE '"+CUSTPO+"%'";
			}
			if (!CUSTOMER.equals("")  && !CUSTOMER.equals("--"))
			{
				sql += " and (to_char(c.CUSTOMER_ID) ='" + CUSTOMER.toUpperCase() +"' or c.customer_name like '"+ CUSTOMER.toUpperCase()+"%')";
			}
			if (!(CYearFr+CMonthFr+CDayFr).replace("-","").equals(""))
			{
				sql += " and to_char(a.CREATION_DATE,'yyyymmdd') >= rpad('"+CYearFr.replace("-","")+"',4,'0')||rpad('"+CMonthFr.replace("-","")+"',2,'0')||rpad('"+CDayFr.replace("-","")+"',2,'0')";
			}
			if (!(CYearTo+CMonthTo+CDayTo).replace("-","").equals(""))
			{
				sql += " and to_char(a.CREATION_DATE,'yyyymmdd') <= rpad('"+CYearTo.replace("-","")+"',4,'0')||rpad('"+CMonthTo.replace("-","")+"',2,'0')||rpad('"+CDayTo.replace("-","")+"',2,'0')";
			}
			if (UserRoles!="admin" && !UserRoles.equals("admin")) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano='001')";
			}				  
            sql += " group by  a.CUSTOMER_NAME,a.CUSTOMER_PO,a.VERSION_ID,c.CURRENCY_CODE,a.min_CREATION_DATE,b.LAST_UPDATE_DATE,g.LAST_UPDATE_DATE,NVL(d.unconfirm_count,0),NVL(f.OPEN_COUNT,0),nvl(a.vaild_cnt,0)";
			if (!POSTATUS.equals("--") && !POSTATUS.equals(""))
			{
				if (POSTATUS.equals("0"))
				{
					sql += " having NVL(d.unconfirm_count,0) >0 or NVL(f.OPEN_COUNT,0) >0 or  (nvl(a.vaild_cnt,0) >0  and  nvl(d.unconfirm_count,0)=0 and  max(e.pi_seqno) IS NULL ) or  (nvl(a.vaild_cnt,0) >0  and (nvl(d.unconfirm_count,0)=0 and b.LAST_UPDATE_DATE is not null and max(e.updated_date) is not null and b.LAST_UPDATE_DATE>max(e.updated_date))) ";
				}
				else if (POSTATUS.equals("1"))
				{
					sql += " having nvl(d.unconfirm_count,0) >0 ";
				}
				else if (POSTATUS.equals("2"))
				{
					sql += " having nvl(f.OPEN_COUNT,0) >0 ";
				}
				else if (POSTATUS.equals("3"))
				{
					sql += " having  nvl(a.vaild_cnt,0)>0 and  nvl(d.unconfirm_count,0)=0 AND nvl(f.OPEN_COUNT,0) =0 AND max(e.pi_seqno) IS NULL"; 
				}
				else if (POSTATUS.equals("4"))					
				{
					sql += " having nvl(a.vaild_cnt,0) >0 and (nvl(d.unconfirm_count,0)=0 and b.LAST_UPDATE_DATE is not null and max(e.updated_date) is not null and b.LAST_UPDATE_DATE>max(e.updated_date)) ";
				}
			}
			//out.println(sql);
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);	
			int i =0;	
			String str_remark="";
			while (rs.next())
			{
				i++;
				if ( i==1)
				{
					out.println("<tr>");
					out.println("<td>");
					out.println("<table width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#ffffff' bordercolordark='#A289B1'>");
					out.println("<tr bgcolor='#8B9F79'>");
					out.println("<td width='3%' height='20' nowrap><div align='center'><font color='#ffffff'>Seq No</font></div></td>");
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>End Customer</font></div></td>");            
					out.println("<td width='12%' nowrap><div align='center'><font color='#ffffff'>Customer PO</font></div></td>");
					out.println("<td width='4%' nowrap><div align='center'><font color='#ffffff'>Version ID</font></div></td>");            
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Currency Code</font></div></td>");
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>Creation Date</font></div></td>"); 
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>Last Update Date</font></div></td>"); 
					out.println("<td width='5%' nowrap><div align='center'><font color='#ffffff'>Unconfirm Count</font></div></td>"); 
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>Uncreate MO Count</font></div></td>");
					out.println("<td width='8%' nowrap><div align='center'><font color='#ffffff'>OC Version</font></div></td>"); 
					out.println("<td width='10%' nowrap><div align='center'><font color='#ffffff'>OC Last Update Date</font></div></td>"); 
					out.println("</tr>");
				}
				out.println("<tr bgcolor='#CFD1C0' onmouseover="+'"'+"this.style.color='#ffffff';this.style.backgroundColor='#91819A';this.style.fontWeight='bold'"+'"'+" onmouseout="+'"'+"style.backgroundColor='#CFD1C0',style.color='#000000';;this.style.fontWeight='normal'"+'"'+"  title='按下滑鼠左鍵,進入訂單明細查詢畫面!' onclick='openSubWindow("+'"'+"../jsp/TSCE1214HistoryDetail.jsp?VERSIONID="+rs.getString("VERSION_ID")+"&CUSTPO="+rs.getString("customer_po")+'"'+");'>");    
				out.println("<td align='center'>"+(i)+"</td>");
				out.println("<td align='left'>"+rs.getString("customer_name")+"</td>");
				out.println("<td align='left'>"+rs.getString("customer_po")+"</td>");
				out.println("<td align='center'>"+rs.getString("version_id")+"</td>");
				out.println("<td align='center'>"+rs.getString("currency_code")+"</td>");
				out.println("<td align='center'>"+rs.getString("creation_date")+"</td>");
				out.println("<td align='center'>"+(rs.getString("last_update_date1")==null||rs.getString("last_update_date1").equals("null")?"&nbsp;":rs.getString("last_update_date1"))+"</td>");
				out.println("<td align='center'>"+(!rs.getString("UNCONFIRM_CNT").equals("0")?"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("UNCONFIRM_CNT")+"</font>":rs.getString("UNCONFIRM_CNT"))+"</td>");
				out.println("<td align='center'>"+(!rs.getString("open_CNT").equals("0")?"<font style='color:#ff0000;font-weight:bold'>"+rs.getString("open_cnt")+"</font>":rs.getString("open_CNT"))+"</td>");
				if (rs.getString("UNCONFIRM_CNT").equals("0"))
				{
					if (rs.getString("OC_LAST_UPDATE_DATE")!=null && rs.getString("last_update_date") != null)
					{
						SimpleDateFormat sy1=new SimpleDateFormat("yyyy-MM-dd HH:mm");
						if (sy1.parse(rs.getString("OC_LAST_UPDATE_DATE")).before(sy1.parse(rs.getString("last_update_date"))))
						{
							out.println("<td align='center' title='請注意!!PO異動尚未重新發OC'><font style='color:#ff0000;font-weight:bold'>"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</font></td>");
						}
						else
						{
							out.println("<td align='center'>"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
						}
					}
					else
					{
						out.println("<td align='center'>"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
					}
				}
				else
				{
					out.println("<td align='center'>"+(rs.getString("OC_NO")==null||rs.getString("OC_NO").equals("null")?"&nbsp;":rs.getString("OC_NO"))+"</td>");
				}
				out.println("<td align='center'>"+(rs.getString("OC_LAST_UPDATE_DATE")==null||rs.getString("OC_LAST_UPDATE_DATE").equals("null")?"&nbsp;":rs.getString("OC_LAST_UPDATE_DATE"))+"</td>");
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
				out.println("<tr><td align='center'><font color='red'>查無資料!!</font></td></tr>");
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

