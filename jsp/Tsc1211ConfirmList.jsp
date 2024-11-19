<!-- 20150129 by Peggy,新增P/L list報表下載功能-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.Base64" %>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TSC轉出訂單頁面</title>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeane" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
function focuscolor(objid)
{
	var color2 = document.form1.HIGHLIGHTOLOR.value;
	color2=color2.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color2;
	document.getElementById("tdb"+objid).style.backgroundColor =color2;
	for (var i =0; i <document.getElementsByName("tdc"+objid).length;i++)
	{
		document.getElementsByName("tdc"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color2;
	}
}
function unfocuscolor(objid)
{
	var color1 = document.form1.ROWCOLOR.value;
	color1=color1.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color1;
	document.getElementById("tdb"+objid).style.backgroundColor =color1;
	for (var i =0; i <document.getElementsByName("tdc"+objid).length;i++)
	{
		document.getElementsByName("tdc"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color1;
	}
}
function setSubmit(objname)
{
	if (document.form1.elements[objname].value=="ASC") 
	{
		document.form1.elements[objname].value ="DESC";
	}
	else		
	{
		document.form1.elements[objname].value ="ASC";
	}
	document.form1.action="Tsc1211ConfirmList.jsp?SORTING="+objname;
	document.form1.submit(); 
}
function setExportXLS(URL)
{    
	if (document.form1.q_begin_date.value =="")
	{
		alert("Please enter a start date!");
		document.form1.q_begin_date.focus(); 
		return false;
	}
	else if (document.form1.q_end_date.value =="")
	{
		alert("Please enter a end date!");
		document.form1.q_end_date.focus(); 
		return false;
	}
	document.form1.action=URL;
 	document.form1.submit();
}
function setBilling(URL)
{    
	if (document.form1.q_begin_date.value =="")
	{
		alert("Please enter a start date!");
		document.form1.q_begin_date.focus(); 
		return false;
	}
	else if (document.form1.q_end_date.value =="")
	{
		alert("Please enter a end date!");
		document.form1.q_end_date.focus(); 
		return false;
	}
	document.form1.action=URL;
 	document.form1.submit();
}
</script>
<%
String  keyID = "",customerPO = "",packingListNumber = "",customerName = "",shipmentTerms = "",c_Date  = "",status = "", sys_status = "N",created_By = "",orderNumber = "",invoiceNumber = "";
String	q_begin_date	=	request.getParameter("q_begin_date"),q_end_date		=	request.getParameter("q_end_date");	
if (q_begin_date == null)
{
	dateBeans.setAdjDate(-6);
	q_begin_date = dateBeans.getYearMonthDay();
}
if (q_end_date == null)	q_end_date = dateBeane.getYearMonthDay();
String	q_status		=	request.getParameter("q_status");
if (q_status==null)  q_status="OPEN"; //add by Peggy 20121214
String	q_customerName		=	request.getParameter("q_customerName");
if (q_customerName == null) q_customerName ="";
String  q_created_By 		  =request.getParameter("q_created_By");
String  packing = request.getParameter("packingnumber");
if (packing ==null) packing="";
String	str_q_customer	=	""; 
String	str_q_begin_date = "",str_q_end_date = "",str_q_status = "",str_created_By = "",str_packing = "",rowColor = "";
String  highlightColor = "#91F8C1";
String ATYPE = request.getParameter("ATYPE");   //add by Peggy 20120713
if (ATYPE==null) ATYPE="ASC";
String BTYPE = request.getParameter("BTYPE");   //add by Peggy 20120713
if (BTYPE==null) BTYPE="ASC";
String CTYPE = request.getParameter("CTYPE");   //add by Peggy 20120713
if (CTYPE==null) CTYPE="ASC";
String DTYPE = request.getParameter("DTYPE");   //add by Peggy 20120713
if (DTYPE==null) DTYPE="ASC";
String SORTING = request.getParameter("SORTING"); //add by Peggy 20120713
if (SORTING==null) SORTING=""; 
String EXPSQL = request.getParameter("EXPSQL");
if(EXPSQL==null) EXPSQL ="";
Base64.Decoder decoder = Base64.getDecoder();
EXPSQL=new String(decoder.decode(EXPSQL), "UTF-8");
//out.println(EXPSQL);
if (!q_customerName.equals(""))
{
	str_q_customer  = "  WHERE CUSTOMERNAME like '%"+q_customerName+"%'";		
}
else
{
	str_q_customer  = " where 1=1 ";
}
if (q_status!=null && !q_status.equals("--"))
{
	str_q_status =" and  status= '"+q_status+"'";		
}
	
if(q_created_By==null || q_created_By.equals("--"))
{
	str_created_By=" ";
}
else
{
	str_created_By =" and CREATED_BY= '"+q_created_By+"'";		
}
if (q_begin_date !="" && q_begin_date.length()>0  &&  q_end_date != "" && q_end_date.length()>0 )
{
	str_q_begin_date = " and to_date(C_DATE,'yyyy-mm-dd') between  to_date('"+q_begin_date+"','yyyy-mm-dd') and  to_date('"+q_end_date+"','yyyy-mm-dd')";
}
else if (q_begin_date !="" &&  q_begin_date.length()>0 )
{
	str_q_begin_date = " and to_date(C_DATE,'yyyy-mm-dd') >=  to_date('" + q_begin_date + "','yyyy-mm-dd')";
}
else if (q_end_date != "" && q_end_date.length()>0 )
{
	str_q_begin_date = " and to_date(C_DATE,'yyyy-mm-dd') <=  to_date('" + q_end_date + "','yyyy-mm-dd')";
}
else
{
	str_q_begin_date = " ";
}
if (!packing.equals(""))
{
	str_packing = " and ID like '%"+packing +"%'";
}
%>
<style type="text/css">
<!--
.style1 {color: #000000}
-->
</style>
</head>

<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<body>
<form name="form1" method="post" action="Tsc1211confirmList.jsp">
 <iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Order Temp List </strong></font></p>
	</td></tr>
	<tr><td> <%@ include file="Tsc1211head.jsp"%></td></tr>
	<tr><td>&nbsp;</td></tr>
  	<tr>
		<td>
			<table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table cellSpacing="0" borderColorDark="#aaaaaa"  cellPadding="0" width="100%" align="left" borderColorLight="#ffffff" border="1">
							<tr >
								<td colspan="7" bgcolor="#92D08A" class="tableTitle" ><span class="style1"><font face='Arial' size="2">文件搜尋選擇 :</font></span></td>
							</tr>
							<tr>
								<td width="15%" bgcolor="#92D08A" class="tableTitle" ><span class="style1"><font face='Arial' size= "2">客戶名稱</font></span></td>
								<td width="15%"><input type="text" name="q_customerName" size="30" value="<%=q_customerName%>">
								</td>
								<td bgcolor="#92D08A" class="tableTitle" width="5%" ><span class="style1"><font face='Arial' size= "2">搜尋開始時間</font></span></td>
								<td width="10%"><input name="q_begin_date" type="text" id="q_begin_date" size="15" value="<%=q_begin_date%>" readonly>
									<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_begin_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
								<td bgcolor="#92D08A" class="tableTitle" width="5%" ><span class="style1"><font  face='Arial' size= "2">搜尋結束時間</font></span></td>
								<td width="10%"><input name="q_end_date" type="text" id="q_end_date" size="15" value="<%=q_end_date%>" readonly>
									<A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.form1.q_end_date);return false;'><IMG name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></A></td>
						 	</tr>
							<tr>
								<td bgcolor="#92D08A" class="tableTitle"><span class="style1"><font face='Arial' size= "2">PackingNumber(or Customer PO)</font></span></td>
								<td><input type="text" name="packingnumber" size="30" value="<%=packing%>"></td>
								<td bgcolor="#92D08A" class="tableTitle" ><span class="style1"><font face='Arial' size="2">建立人員</font></span></td>
								<td>
<%
try
{   
	Statement st2=con.createStatement();
    ResultSet rs2=null;
	String sql2 = "select DISTINCT created_By , created_By from TSC_OE_AUTO_HEADERS  WHERE SALES_REGION ='TSCE' AND UPPER(created_By) not in ('KERWIN','JINGKER','PEGGY_CHEN','JINKER','SUMING') ORDER BY 1";   //要傳兩個變數
    rs2=st2.executeQuery(sql2);
	comboBoxBean.setRs(rs2);
	comboBoxBean.setSelection(q_created_By);
	comboBoxBean.setFieldName("q_created_By");	   
    out.println(comboBoxBean.getRsString());				   
	rs2.close();   
	st2.close();     	 
} //end of try		 
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
%>
								</td>
								<td bgcolor="#92D08A" class="tableTitle" ><span class="style1"><font face='Arial' size="2">訂單狀態</font></span></td>
								<td>
<%
try
{   
	Statement st1=con.createStatement();
	ResultSet rs1=null;
	String sql = "select DISTINCT status , status from TSC_OE_AUTO_HEADERS WHERE SALES_REGION ='TSCE' ";   //要傳兩個變數
	rs1=st1.executeQuery(sql);
	comboBoxBean.setRs(rs1);
	comboBoxBean.setSelection(q_status);
	comboBoxBean.setFieldName("q_status");	  
	//if (comboBoxBean.getSelection()==null || comboBoxBean.getSelection()=="" || comboBoxBean.getSelection()=="--")
	//{   
	//	comboBoxBean.setSelection("OPEN"); //20110309 add by Peggychen  
	//}
	out.println(comboBoxBean.getRsString());				    
	rs1.close();   
	st1.close();     	 
} //end of try		 
catch (Exception e) 
{ 
	out.println("Exception:"+e.getMessage()); 
} 
%> 
								</td> 
							</tr>
							<tr>
								<td colspan="6" align="center">
								  <p>
  <input name="search" type="submit" id="search" value="Search" style="font-family:arial">
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							
								    <input name="excel" type="button" id="excel" value="Downlad P/L Report" style="font-family:arial" onClick='setExportXLS("../jsp/Tsc1211EmailNotice.jsp?RTYPE=PACKING")'>
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							
								    <input name="invoicexls" type="button" value="Downlad P/L Report for invoice" style="font-family:arial" onClick='setBilling("../jsp/Tsc1211BillingReport.jsp")'>
  &nbsp;&nbsp;				
									<A HREF="../1211InvoiceRule/1211 invoice rule.xls" style="font-size:11px;font-family:Tahoma,Georgia;">Download Invoice Rule File</A>
								  </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%"   bordercolordark="#92D08A" border="1" cellpadding="1" cellspacing="0" class="innTable" bordercolorlight="#ffffff"  background="#334455">
			  <tr bgcolor="#92D08A">
				<td width="35%"><div align="center"><font face='Arial' size= "2">Customer&nbsp;<a href='javascript:void(0)' onClick="setSubmit('CTYPE')"><%if (CTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></div></td>
				<td width="15%"><div align="center"><font face='Arial' size= "2">Packing Number&nbsp;<a href='javascript:void(0)' onClick="setSubmit('ATYPE')"><%if (ATYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></div></td>
				<td width="15%"><div align="center"><font face='Arial' size= "2">Customer PO&nbsp;<a href='javascript:void(0)' onClick="setSubmit('BTYPE')"><%if (BTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></div></td>
				<td width="10%"><div align="center"><font face='Arial' size= "2">Creation Date&nbsp;<a href='javascript:void(0)' onClick="setSubmit('DTYPE')"><%if (DTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></div></td>
				<td width="15%"><div align="center"><font face='Arial' size= "2">Order Number </font></div></td>
				<td width="10%"><div align="center"><font face='Arial' size= "2">Status</font></div></td>
			  </tr>
<%
if(sys_status =="N")
{
	String sSql =EXPSQL;
	try
	{
		if (SORTING.equals(""))
		{
			sSql="select (select count(1) from tsc_oe_auto_headers b where b.packinglistnumber=a.packinglistnumber AND nvl(b.ORDER_NUMBER,999) = nvl(a.ORDER_NUMBER,999) and b.status=a.status) rowcnt,a.* from TSC_OE_AUTO_HEADERS a "+str_q_customer+" and SALES_REGION='TSCE' "+ str_q_status +str_created_By+str_q_begin_date+str_packing;
		}
		Base64.Encoder encoder = Base64.getEncoder();
		out.println("<input type='hidden' name='EXPSQL' value="+'"'+encoder.encodeToString(sSql.getBytes("UTF-8"))+'"'+">");
		//sSql+= " order by c_Date desc ";
		if (SORTING.equals("") || SORTING.equals("ATYPE")) sSql += " order by a.PACKINGLISTNUMBER "+ ATYPE + ",a.CUSTOMERPO "+ BTYPE + ",a.CUSTOMERNAME "+ CTYPE +", a.C_DATE "+ DTYPE;
		if (SORTING.equals("BTYPE")) sSql += " order by a.CUSTOMERPO "+ BTYPE + ",a.PACKINGLISTNUMBER "+ ATYPE + ",a.CUSTOMERNAME "+ CTYPE +", a.C_DATE "+ DTYPE;
		if (SORTING.equals("CTYPE")) sSql += " order by a.CUSTOMERNAME "+ CTYPE +",a.PACKINGLISTNUMBER "+ ATYPE + ",a.CUSTOMERPO "+ BTYPE + ",a.C_DATE "+ DTYPE;
		if (SORTING.equals("DTYPE")) sSql += " order by a.C_DATE "+ DTYPE +",a.PACKINGLISTNUMBER "+ ATYPE + ",a.CUSTOMERPO "+ BTYPE + ",a.CUSTOMERNAME "+ CTYPE ;
	 	Statement st = con.createStatement();
		ResultSet rs = st.executeQuery(sSql);
		//out.println(sSql);
		int i = 0;
		String packingnum="";
		while(rs.next())
		{
			customerPO		  = rs.getString("CUSTOMERPO");
			packingListNumber = rs.getString("PACKINGLISTNUMBER");
			customerName      = rs.getString("CUSTOMERNAME");
			shipmentTerms     = rs.getString("SHIPMENTTERMS");
			c_Date            = rs.getString("C_DATE");
			status 			  = rs.getString("status");
			orderNumber 	  = rs.getString("ORDER_NUMBER");
			keyID 	  		  = rs.getString("ID");
			if(status=="OPEN"||status.equals("OPEN"))
			{
				rowColor="#CEDBDD";
			}
			else
			{
				rowColor="#D9BFDB";
			}
			//out.println("<tr id='tr"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")' bgcolor='"+rowColor+"' onclick=javascript:location.href='Tsc1211ConfirmDetailList.jsp?packing_List_Number="+java.net.URLEncoder.encode(packingListNumber)+"&STATUS="+status+"' title='按下滑鼠左鍵,進入Detail畫面'>");
			//out.println("<tr id='tr"+i+"' bgcolor='"+rowColor+"' onclick=javascript:location.href='Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(packingListNumber)+"&STATUS="+status+"' title='按下滑鼠左鍵,進入Detail畫面'>");
			out.println("<tr id='tr"+i+"' bgcolor='"+rowColor+"' onclick=javascript:location.href='Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(packingListNumber)+"&ORDERNUM="+orderNumber+"&STATUS="+status+"' title='按下滑鼠左鍵,進入Detail畫面'>");
			if (packingnum.equals("") || !packingnum.equals(packingListNumber) || rs.getString("rowcnt").equals("1"))
			{
				i++;
				out.println("<td id='tda"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")' rowspan='"+rs.getString("rowcnt")+"'><div align='left'><font face='Arial'  size=2 >"+customerName+"</font></div></td>");
				out.println("<td id='tdb"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")' rowspan='"+rs.getString("rowcnt")+"'><div align='left'><font face='Arial'  size=2>"+packingListNumber+"</font></div></td>");
				packingnum=packingListNumber;
			}
			out.println("<td id='tdc"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")'><div align='left'><font face='Arial' size=2>"+customerPO+"</font></div></td>");
			out.println("<td id='tdd"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")'><div align='center'><font face='Arial' size=2>"+c_Date +"</font></div></td>");
			out.println("<td id='tde"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")'><div align='center'><font face='Arial' size=2>"+((orderNumber==null)?"&nbsp;":orderNumber)+"</font></div></td>");
			out.println("<td id='tdf"+i+"' onMouseOver='focuscolor("+i+")' onMouseOut='unfocuscolor("+i+")'><div align='center'><font face='Arial' size=2>"+status+"</font></div></td>");
			out.println("</tr>"); 
			
		} 
	}
	catch(SQLException e)
	{
		out.println(e.toString());
	}
}
else
{
%>
				  <tr>
					<td height="10" colspan="8" align="center"><em><font size= "2">Not Data !!</font></em></td>
				  </tr>
<% 
} 
%>
			</table>
		</td>
	</tr>
</table>
<input type="hidden" name="ATYPE" value="<%=ATYPE%>">
<input type="hidden" name="BTYPE" value="<%=BTYPE%>">
<input type="hidden" name="CTYPE" value="<%=CTYPE%>">
<input type="hidden" name="DTYPE" value="<%=DTYPE%>">
<input name="ROWCOLOR" type="HIDDEN" value="<%=rowColor%>">	
<input name="HIGHLIGHTOLOR" type="HIDDEN" value="<%=highlightColor%>">	
</form>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
