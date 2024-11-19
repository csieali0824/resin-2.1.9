<!--20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!--20160313 by Peggy,add sample order direct ship to cust flag-->
<!--20170216 by Peggy,add sales region for bi-->
<!--20170512 by Peggy,add end cust ship to id-->
<!--20190225 by Peggy,add End customer part name-->
<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page import="com.jspsmart.upload.*"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Excel Upload To Create a TSCR New RFQ Order</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function focuscolor(objid)
{
	var color2 = document.form1.HIGHLIGHTOLOR.value;
	color2=color2.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color2;
	document.getElementById("tdb"+objid).style.backgroundColor =color2;
	document.getElementById("tdc"+objid).style.backgroundColor =color2;
	for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
	{
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdg"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdh"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdi"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdj"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdk"+objid)[i].style.backgroundColor =color2;
		document.getElementsByName("tdl"+objid)[i].style.backgroundColor =color2;
	}
}
function unfocuscolor(objid)
{
	var color1 = document.form1.ROWCOLOR.value;
	color1=color1.toLowerCase();
	document.getElementById("tda"+objid).style.backgroundColor =color1;
	document.getElementById("tdb"+objid).style.backgroundColor =color1;
	document.getElementById("tdc"+objid).style.backgroundColor =color1;
	for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
	{
		document.getElementsByName("tdd"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tde"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdf"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdg"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdh"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdi"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdj"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdk"+objid)[i].style.backgroundColor =color1;
		document.getElementsByName("tdl"+objid)[i].style.backgroundColor =color1;
	}
}
function delData(URL)
{ 
	if (confirm("您確定要刪除資料?"))
	{
		document.form1.action=URL;		
		document.form1.submit();
	}
}
function setSearch(URL)
{  
	document.form1.action=URL;
	document.form1.submit(); 
}
</script>
</head>
<body>
<form name="form1"  METHOD="post">
<%
String rowColor="#ffffff",highlightColor="#EEDDCC";
String CustomerID=request.getParameter("CUSTOMERID");
String CustomerNo=request.getParameter("CUSTOMERNO");
String CustomerName=request.getParameter("CUSTOMERNAME");
String strCustPO=request.getParameter("CUSTOMERPO");
String SalesAreaNo="009";
String strRemark="Order Import from file";
String strOtypeID=request.getParameter("ODRTYPE");
String strCurr="USD";
String strRFQType=request.getParameter("RFQTYPE");
String InsertFlag=request.getParameter("INSERTFLAG");
if (InsertFlag==null) InsertFlag="";
String DelFlag=request.getParameter("DELFLAG");
if (DelFlag==null) DelFlag="";
String DelAll=request.getParameter("DELALL");
if (DelAll==null) DelAll="";
String CUSTNAME = request.getParameter("CUSTNAME");
if (CUSTNAME == null) CUSTNAME="";
String CUSTPO = request.getParameter("CUSTPO");
if (CUSTPO == null) CUSTPO="";
String UPLOADBY = request.getParameter("UPLOADBY");
if (UPLOADBY == null) UPLOADBY="";

if (InsertFlag.equals("Y"))
{
	String aa [][] = new String[1][1];
	int icnt =0;
	String sql = " SELECT a.customer_no,a.customer_id,"+
				 " a.customer_name, a.customer_po, b.description,b.segment1,"+
				 " a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,b.PRIMARY_UOM_CODE uom,a.crd,a.factory,a.fob,"+
				 " a.shipping_method, a.fob, a.remarks, d.ORDER_NUM order_type, a.line_type,a.customer_po_line_number ,"+
				 " (select count(1) from oraddman.tsc_rfq_upload_temp c where  c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by) rowcnt"+
		  	     ",e.customer_number END_CUSTOMER_ID,a.END_CUSTOMER,a.QUOTE_NUMBER,PO_LINE_NO"+  //add by Peggy 20140825
				 " FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
				 ",ar_customers e"+
				 " where a.create_flag='N'"+
				 " and a.salesareano='009'"+
				 " and b.organization_id=43"+
				 " and a.inventory_item_id = b.inventory_item_id"+
				 " and a.customer_no = '"+CustomerNo+"'"+
				 " and a.customer_po = '"+strCustPO+"'"+
				 " and a.upload_by ='" + UPLOADBY+"'"+
				 " and a.salesareano=d.SAREA_NO"+
				 " and a.order_type=d.OTYPE_ID"+
		         " and a.end_customer_id=e.customer_id(+)"+
				 " order by a.customer_no,a.customer_po,a.line_no,b.description";
	//out.println(sql);
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sql);
	while(rs.next())
	{
		if (icnt ==0) aa=new String[Integer.parseInt(rs.getString("rowcnt"))][30];
		
		aa[icnt][0]=""+(icnt+1);
		aa[icnt][1]=rs.getString("segment1");
		aa[icnt][2]=rs.getString("description");
		aa[icnt][3]=rs.getString("qty");
		aa[icnt][4]=rs.getString("uom");
		aa[icnt][5]=rs.getString("crd");
		aa[icnt][6]=rs.getString("shipping_method");
		aa[icnt][7]=rs.getString("request_date");
		aa[icnt][8]=rs.getString("customer_po_line_number");
		aa[icnt][9]=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"));
		aa[icnt][10]="N";
		aa[icnt][11]="0";
		aa[icnt][12]="0";
		aa[icnt][13]=rs.getString("factory");
		aa[icnt][14]=(rs.getString("cust_item_name")==null?"&nbsp;":rs.getString("cust_item_name"));
		aa[icnt][15]=rs.getString("selling_price");
		aa[icnt][16]=rs.getString("order_type");
		aa[icnt][17]=rs.getString("line_type");
		aa[icnt][18]=rs.getString("fob");
		aa[icnt][19]=(rs.getString("PO_LINE_NO")==null?"":rs.getString("PO_LINE_NO"));  //add by Peggy 20221221
		aa[icnt][20]=(rs.getString("QUOTE_NUMBER")==null?"&nbsp;":rs.getString("QUOTE_NUMBER")); //add by Peggy 20190304
		aa[icnt][21]=(rs.getString("end_customer_id")==null?"&nbsp;":rs.getString("end_customer_id"));   //add by Peggy 20140825
		aa[icnt][22]="&nbsp;";    //add by Peggy 20130305
		aa[icnt][23]="&nbsp;";    //add by Peggy 20130305
		aa[icnt][24]=(rs.getString("end_customer")==null?"&nbsp;":rs.getString("end_customer"));  //add by Peggy 20140825
		aa[icnt][25]="&nbsp;";      //ORIG SO LINE ID,add by Peggy 20150519
		aa[icnt][26]="&nbsp;";      //direct ship to cust,add by Peggy 20160313
		aa[icnt][27]="&nbsp;";      //bi region,add by Peggy 20170222
		aa[icnt][28]="&nbsp;";      //END CUSTOMER SHIP TO ID,add by Peggy 20170512
		aa[icnt][29]="&nbsp;";      //END CUSTOMER PARTNO,add by Peggy 20190225
		icnt++; 
	}
	rs.close();
	st.close();

	arrayRFQDocumentInputBean.setArray2DString(aa);
	session.setAttribute("SPQCHECKED","N");
	session.setAttribute("CUSTOMERID",CustomerID);
	session.setAttribute("CUSTOMERNO",CustomerNo);
	session.setAttribute("CUSTOMERNAME",CustomerName);
	session.setAttribute("CUSTOMERPO", strCustPO);
	session.setAttribute("CUSTACTIVE","Y");
	session.setAttribute("SALESAREANO",SalesAreaNo);
	session.setAttribute("REMARK",strRemark);
	session.setAttribute("PREORDERTYPE",strOtypeID);
	session.setAttribute("ISMODELSELECTED","Y");
	session.setAttribute("CUSTOMERIDTMP",CustomerID);
	session.setAttribute("INSERT","Y");	
	session.setAttribute("RFQ_TYPE",strRFQType);	
	session.setAttribute("MAXLINENO",""+aa.length);
	session.setAttribute("CURR", strCurr);
	session.setAttribute("PROGRAMNAME","D4-012");
	String urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
			 "&SPQCHECKED=N"+
			 "&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
			 "&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName)+
			 "&CUSTACTIVE=A"+
			 "&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
			 "&CUSTOMERPO="+java.net.URLEncoder.encode(strCustPO)+
			 "&CURR="+java.net.URLEncoder.encode(strCurr)+
			 "&REMARK="+java.net.URLEncoder.encode(strRemark)+
			 "&PREORDERTYPE="+java.net.URLEncoder.encode(strOtypeID)+
			 "&ISMODELSELECTED=Y"+
			 "&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
			 //"&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerID)+
			 "&INSERT=Y"+
			 "&RFQTYPE="+java.net.URLEncoder.encode(strRFQType)+
			 "&PROGRAMNAME=D4-012";
	try
	{
		response.sendRedirect(urlDir);
	}
	catch(Exception e) 
	{
		out.println("Error:"+e.getMessage());
	}
}

if (DelFlag.equals("Y"))
{
	String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG=? AND CUSTOMER_ID=? AND CUSTOMER_PO=? AND UPLOAD_BY =?";   
	PreparedStatement seqstmt=con.prepareStatement(sqlx);        
	seqstmt.setString(1,"D");   
	seqstmt.setString(2,UserName);   
	seqstmt.setString(3,"N");   
	seqstmt.setString(4,CustomerID);  	
	seqstmt.setString(5,strCustPO);  	
	seqstmt.setString(6,UPLOADBY);   
	seqstmt.executeUpdate(); 
	seqstmt.close(); 
}
else if (DelAll.equals("Y"))
{
	String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG=?,LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG=? AND SALESAREANO=?";   
	PreparedStatement seqstmt=con.prepareStatement(sqlx);        
	seqstmt.setString(1,"D");   
	seqstmt.setString(2,UserName);   
	seqstmt.setString(3,"N");  
	seqstmt.setString(4,"009"); 	 
	seqstmt.executeUpdate(); 
	seqstmt.close(); 
}
%>
<table width="100%" align="center" border="0">
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
				<tr>
					<td height="50" align="center">
						<font color="#003399" size="+2" face="Arial Black">TSCR </font>
						<font color="#000000" size="+2" face="Times New Roman"> <strong>Excel Upload To Create a New RFQ Order</strong></font>
					</td>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="3">
			<table align="center" width="100%" border="0" cellspacing="0" cellpadding="1">
				<tr>
					<td>
						<table align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
							<tr>
								<TD>
									<table width="100%" border="0" cellpadding="0" cellspacing="0">
										<tr>
											<td bgcolor="#544495" width="15%" align="center" style="border-color:#544495;border:insert;color:#ffffff;font-family:Arial;font-size:14px"><a href="../jsp/TSCROWImportHistory.jsp" style="color:ffffff;font-family:Arial;font-size:14px;text-decoration:none;">待處理明細</a></td>
											<td bgcolor="#CECECE" width="15%" height="20" align="center"><a href="../jsp/TSCROWExcelImport.jsp" style="color:000000;font-family:Arial;font-size:14px;text-decoration:none">Excel匯入</a></td>
											<td width="70%" style="border-color:ffffff;">&nbsp;</td>
										</tr>
									</table>
								</TD>
								<TD  align="right" title="回首頁!">
									<A HREF="../ORAddsMainMenu.jsp" style="font-size:14px;font-family:標楷體;text-decoration:none;color:#0000FF">
									<STRONG>回首頁</STRONG>
									</A>
								</TD>
							</tr>
							<tr><td height="10" colspan="2" bgcolor="#544495"></td></tr>
							<tr>
								<td colspan="2">
									<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolordark="#544495">
										<tr>
											<td width="10%" style="color:#ffffff;background-color:#544495;font-family:Arial;font-size:12px">Customer Name</td>
											<td width="20%"><input type="text" name="CUSTNAME" value="" style="font-family:Arial;font-size:12px"></td>
											<td width="10%" style="color:#ffffff;background-color:#544495;font-family:Arial;font-size:12px">Customer PO</td>
											<td width="20%"><input type="text" name="CUSTPO" value="" style="font-family:Arial;font-size:12px"></td>
											<td width="10%" style="color:#ffffff;background-color:#544495;font-family:Arial;font-size:12px">Upload By</td>
											<td><input type="text" name="UPLOADBY" value="" style="font-family:Arial;font-size:12px"></td>
											<td><input type="button" name="Search" value="Search" onClick="setSearch('../jsp/TSCROWImportHistory.jsp')"></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>
						<table align="center" border="1" width="100%" cellspacing="1" cellpadding="1" bordercolorlight="#DFD9DD" bordercolordark="#4A598A">
							<tr>
								<td width="2%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center"><input type="button" name="btnall" value="Delete All" title="刪除全部資料" onClick="delData('../jsp/TSCROWImportHistory.jsp?DELALL=Y')"></td>
								<td width="20%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Customer Name</td>
								<td width="10%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Customer PO</td>
								<td width="6%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">RFQ Type</td>
								<td width="12%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Item Desc</td>
								<td width="8%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Customer Item</td>
								<td width="4%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Qty</td>
								<td width="6%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Selling<br>Price</td>
								<td width="6%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Request Date</td>
								<td width="5%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Order Type</td>
								<td width="5%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">End Cust ID</td>
								<td width="6%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">End Customer</td>
								<td width="10%" style="color:#FFFFFF;background-color:#413F69;font-family:Arial;font-size:12px" align="center">Upload By</td>
							</tr>
					<%
					try
					{
						int i =0;
						String customerpo="",customerno="",upload_by="";
						String sql = " SELECT a.salesareano, a.upload_date, a.upload_by, a.customer_no,a.customer_id,"+
									 " a.customer_name, a.rfq_type, a.customer_po, b.description,"+
									 " a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,"+
									 " a.shipping_method, a.fob, a.remarks,d.OTYPE_ID, d.ORDER_NUM order_type, a.line_type,a.customer_po_line_number,"+
									 " (select count(1) from oraddman.tsc_rfq_upload_temp c where  c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by) rowcnt"+
		  	     					 ",e.customer_number END_CUSTOMER_ID,a.END_CUSTOMER"+  //add by Peggy 20140825
									 " FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
								     ",ar_customers e"+
									 " where a.create_flag='N'"+
									 " and a.salesareano='009'"+
									 " and b.organization_id=43"+
									 " and a.inventory_item_id = b.inventory_item_id"+
		 							 " and a.end_customer_id=e.customer_id(+)"+
									 " and a.salesareano=d.SAREA_NO"+
									 " and a.order_type=d.OTYPE_ID";
						if (!CUSTNAME.equals("") && !DelFlag.equals("Y")) sql += " and (a.customer_no like '"+ CUSTNAME+"' or a.customer_name like '"+CUSTNAME+"%') ";
						if (!CUSTPO.equals("") && !DelFlag.equals("Y")) sql += " and a.customer_po ='" + CUSTPO+"'";
						if (!UPLOADBY.equals("") && !DelFlag.equals("Y")) sql += " and a.upload_by = '" + UPLOADBY+"'";
						sql += " order by a.customer_no, a.customer_po,a.upload_by,a.line_no,b.description";
						Statement st = con.createStatement();
						//out.println(sql);
						ResultSet rs = st.executeQuery(sql);
						while(rs.next())
						{
					%>
							<tr>
					<%
							if (!customerpo.equals(rs.getString("customer_po")) || !customerno.equals(rs.getString("customer_no")) || !upload_by.equals(rs.getString("upload_by")))
							{
								i++;
					%>
								<td rowspan="<%=rs.getString("rowcnt")%>" style="color:#000000;font-family:Arial;font-size:12px"><input type="button" name="btn<%=i%>" value="Delete" title="刪除資料" onClick="delData('../jsp/TSCROWImportHistory.jsp?DELFLAG=Y&CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&UPLOADBY=<%=rs.getString("upload_by")%>')"></td>
								<td id="tda<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%="("+rs.getString("customer_no")+")"+rs.getString("customer_name")%></td>
								<td id="tdb<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("customer_po")%></td>								
								<td id="tdc<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("rfq_type")%></td>								
					<%
								customerpo=rs.getString("customer_po");
								customerno=rs.getString("customer_no");
								upload_by=rs.getString("upload_by");
							}
					%>
								<td id="tdd<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("description")%></td>								
								<td id="tde<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=(rs.getString("cust_item_name")==null?"&nbsp;":rs.getString("cust_item_name"))%></td>								
								<td id="tdf<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.###")).format(Float.parseFloat(rs.getString("qty")))%></td>								
								<td id="tdg<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.######")).format(Float.parseFloat(rs.getString("selling_price")))%></td>								
								<td id="tdh<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("request_date")%></td>								
								<td id="tdi<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("order_type")%></td>								
								<td id="tdj<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer_id")==null?"&nbsp;":rs.getString("end_customer_id"))%></td>								
								<td id="tdk<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer")==null?"&nbsp;":rs.getString("end_customer"))%></td>								
								<td id="tdl<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-family:Arial;font-size:12px" onClick="javascript:location.href='TSCROWImportHistory.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("upload_by")%></td>								
							</tr>
					<%
						}
						st.close();
						rs.close();		
					}
					catch(Exception e)
					{
						out.println("<tr><td colspan='9'>Exception:"+e.getMessage()+"</td></tr>");
					}	 
					%>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<input name="ROWCOLOR" type="HIDDEN" value="<%=rowColor%>">	
<input name="HIGHLIGHTOLOR" type="HIDDEN" value="<%=highlightColor%>">	
</form>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
