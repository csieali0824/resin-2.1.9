<%@ page contentType="text/html; charset=UTF-8" %>
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
	<title>TSCT-DA Excel Upload</title>
	<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
	<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
	<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
	<!--<meta http-equiv="Content-Type" content="text/html; charset=big5">-->
</head>
<script language="JavaScript" type="text/JavaScript">
	function setCreate(URL)
	{
		if (document.form1.UPLOADFILE.value == "")
		{
			alert("請選擇上傳檔案!");
			document.form1.UPLOADFILE.focus();
			return false;
		}
		var filename = document.form1.UPLOADFILE.value;
		filename = filename.substr(filename.length-4);
		if (filename.toUpperCase() != ".XLS")
		{
			alert('上傳檔案必須為office 2003 excel檔!');
			document.form1.UPLOADFILE.focus();
			return false;
		}
		var M_TYPE = "";
		var ckLength = document.form1.checkbox1.length;
		var chkcnt =0;
		for(var i = 0; i < ckLength; i++)
		{
			if ( document.form1.checkbox1[i].checked)
			{
				M_TYPE = document.form1.checkbox1[i].value;
				chkcnt ++;
			}
		}
		if (M_TYPE=="")
		{
			alert("請選擇Group Type!");
			return false;
		}
		if (chkcnt >1)
		{
			alert("Group Type只允許擇一!");
			return false;
		}
		document.form1.submit1.disabled=true;
		document.getElementById("alpha").style.width="100"+"%";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.form1.action=URL+"&MTYPE="+M_TYPE;
		document.form1.submit();
	}
	function setchk(svalue)
	{
		var ckLength = document.form1.checkbox1.length;
		for(var i = 0; i <= ckLength; i++)
		{
			if ( document.form1.checkbox1[i].value!=svalue)
			{
				document.form1.checkbox1[i].checked = false;
			}
		}
	}
	function focuscolor(objid)
	{
		var color2 = document.form1.HIGHLIGHTOLOR.value;
		color2=color2.toLowerCase();
		document.getElementById("tda"+objid).style.backgroundColor =color2;
		document.getElementById("tdc"+objid).style.backgroundColor =color2;
		for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
		{
			document.getElementsByName("tdb"+objid)[i].style.backgroundColor =color2;
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
		document.getElementById("tdc"+objid).style.backgroundColor =color1;
		for (var i =0; i <document.getElementsByName("tdd"+objid).length;i++)
		{
			document.getElementsByName("tdb"+objid)[i].style.backgroundColor =color1;
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
		if (confirm("您確定要刪除此筆資料?"))
		{
			document.form1.action=URL+"&ACTIONCODE=DETAIL";
			document.form1.submit();
		}
	}
	function setSearch(URL)
	{
		document.form1.action=URL;
		document.form1.submit();
	}
</script>
<STYLE TYPE='text/css'>
	BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
	P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
	TD        { font-family: Tahoma,Georgia;font-size: 11px ;word-break :break-all}
	TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
	A         { text-decoration: underline; font-size: 11px  }
	A:visited { color: #990066; text-decoration: underline }
	A:active  { color: #FF0000; text-decoration: underline }
	.board    { background-color: #D6DBE7}
	.text     { font-family: Tahoma,Georgia;  font-size: 11px }
</STYLE>
</head>
<body>
<%
	String sType = request.getParameter("STYPE");
	if (sType==null) sType="";
	String ACTIONCODE = request.getParameter("ACTIONCODE");
	if (ACTIONCODE == null) ACTIONCODE = "";
	String SalesAreaNo = "006";
	String SalesArea = "";
	String SAMPLEFILE = request.getParameter("SAMPLEFILE");
	if (SAMPLEFILE ==null) SAMPLEFILE="";
	String MTYPE= request.getParameter("MTYPE");
	if (MTYPE ==null) MTYPE="";
	String CustomerID=request.getParameter("CUSTOMERID");
	String CustomerNo=request.getParameter("CUSTOMERNO");
	String CustomerName=request.getParameter("CUSTOMERNAME");
	String CustomerPO=request.getParameter("CUSTOMERPO");
	String strRemark="Order Import from file";
	String DelFlag=request.getParameter("DELFLAG");
	if (DelFlag==null) DelFlag="";
	String InsertFlag=request.getParameter("INSERTFLAG");
	if (InsertFlag==null) InsertFlag="";
	String CUSTNAME = request.getParameter("CUSTNAME");
	if (CUSTNAME == null) CUSTNAME="";
	String CUSTPO = request.getParameter("CUSTPO");
	if (CUSTPO == null) CUSTPO="";
	String UPLOADBY = request.getParameter("UPLOADBY");
	if (UPLOADBY == null) UPLOADBY="";
	String ODRTYPE=request.getParameter("ODRTYPE");
	String RFQTYPE=request.getParameter("RFQTYPE");
	int icnt=0,ErrCnt=0,sRow=2,rec_cnt=0,insert_cnt=0;
	String seqno="",seqkey="";
	String salesPerson="",toPersonID="";
	String IDTYPE = "CUSTID",POTYPE="CUSTPO",strCurr="";
	String strCustNo="",strCustID="",strLineCustPO="",strLineCustPOLineNo="",strLineRemark="",FOBList="",ShippingMethodList="",urlDir ="",OrderTypeList="";
	String sql = "",strOtypeID ="",strUOM="KPC",strFactory="",strHeaderOrderType="",strItemID="";
	String strLineType="",strItemName ="",strOrderType="",strOrderTypeID="",strCustName="",strCustPO="",strRFQType="",strItemDesc="",strLineOrderType="";
	String strQty="",strCustItem="",strSellingPrice="",strCRD="",strSSD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strErr="";
	String strSellingPrice_Q="", strEndCustName="",strQuoteNumber="",strItemNoPacking="";
	String rowColor="#ffffff",highlightColor="#EEDDCC";
	String bkcolor="#C6D1E6";
	String strEndCustID ="",strEndCustID1 ="";
	String oneDArray[] = new String [30];
	String aa [][] = new String[1][1];
	try
	{
		sql = "select '('||SALES_AREA_NO||')'||SALES_AREA_NAME from oraddman.tssales_area a where SALES_AREA_NO =?";
		if (UserRoles!="admin" && !UserRoles.equals("admin"))
		{
			sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=a.SALES_AREA_NO)";
		}
		PreparedStatement statex = con.prepareStatement(sql);
		statex.setString(1,SalesAreaNo);
		ResultSet rsx=statex.executeQuery();
		if (!rsx.next())
		{
%>
<script language="JavaScript" type="text/JavaScript">
	alert("您沒有該區域使用權限,無法使用此功能,謝謝!");
	location.href="../ORAddsMainMenu.jsp";
	//closeWindow();
</script>
<%
		}
		else
		{
			SalesArea = rsx.getString(1);
		}
		rsx.close();
		statex.close();
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
	if (InsertFlag.equals("Y"))
	{
		sql = " SELECT a.customer_no,a.customer_id,"+
				" a.customer_name, UTL_I18N.UNESCAPE_REFERENCE(a.customer_po) customer_po, b.description,b.segment1,"+
				" a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,b.PRIMARY_UOM_CODE uom,a.crd,a.factory,a.fob,"+
				" a.shipping_method, a.fob, a.remarks, d.ORDER_NUM order_type, a.line_type,UTL_I18N.UNESCAPE_REFERENCE(a.customer_po_line_number) customer_po_line_number ,"+
				" (select count(1) from oraddman.tsc_rfq_upload_temp c where  c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by) rowcnt"+
				",e.customer_number END_CUSTOMER_ID,a.END_CUSTOMER, a.QUOTE_NUMBER"+
				" FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
				",ar_customers e"+
				" where a.create_flag=?"+
				" and a.salesareano=?"+
				" and b.organization_id=43"+
				" and a.inventory_item_id = b.inventory_item_id"+
				" and a.customer_no = ?"+
				" and a.customer_po = ?"+
				" and a.upload_by =?"+
				" and a.salesareano=d.SAREA_NO"+
				" and a.order_type=d.OTYPE_ID"+
				" and a.end_customer_id=e.customer_id(+)"+
				" order by a.customer_no,a.customer_po,a.line_no,b.description";
		PreparedStatement st = con.prepareStatement(sql);
		st.setString(1,"N");
		st.setString(2,SalesAreaNo);
		st.setString(3,CustomerNo);
		st.setString(4,CustomerPO);
		st.setString(5,UPLOADBY);
		icnt=0;
		//out.println("CustomerPO="+CustomerPO);
		ResultSet rs = st.executeQuery();
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
			aa[icnt][19]="&nbsp;";
			aa[icnt][20]=(rs.getString("QUOTE_NUMBER")==null?"&nbsp;":rs.getString("QUOTE_NUMBER"));
			aa[icnt][21]=(rs.getString("end_customer_id")==null?"&nbsp;":rs.getString("end_customer_id"));
			aa[icnt][22]="&nbsp;";
			aa[icnt][23]="&nbsp;";
			aa[icnt][24]=(rs.getString("end_customer")==null?"&nbsp;":rs.getString("end_customer"));
			aa[icnt][25]="&nbsp;";
			aa[icnt][26]="&nbsp;";
			aa[icnt][27]="&nbsp;";
			aa[icnt][28]="&nbsp;";  //add by Peggy 20170512
			aa[icnt][29]="&nbsp;";  //add by Peggy 20190313
			icnt++;
		}
		rs.close();
		st.close();

		arrayRFQDocumentInputBean.setArray2DString(aa);
		session.setAttribute("SPQCHECKED","N");
		session.setAttribute("CUSTOMERID",CustomerID);
		session.setAttribute("CUSTOMERNO",CustomerNo);
		session.setAttribute("CUSTOMERNAME",CustomerName);
		session.setAttribute("CUSTOMERPO", CustomerPO);
		session.setAttribute("CUSTACTIVE","Y");
		session.setAttribute("SALESAREANO",SalesAreaNo);
		session.setAttribute("REMARK",strRemark);
		session.setAttribute("PREORDERTYPE",ODRTYPE);
		session.setAttribute("ISMODELSELECTED","Y");
		session.setAttribute("CUSTOMERIDTMP",CustomerID);
		session.setAttribute("INSERT","Y");
		session.setAttribute("RFQ_TYPE",RFQTYPE);
		session.setAttribute("MAXLINENO",""+aa.length);
		session.setAttribute("CURR", strCurr);
		session.setAttribute("PROGRAMNAME","D4-019");
		urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
				"&SPQCHECKED=N"+
				"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
				"&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName, "UTF-8").replace("+", "%20") +
				"&CUSTACTIVE=A"+
				"&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
				"&CUSTOMERPO="+java.net.URLEncoder.encode(CustomerPO, "UTF-8").replace("+", "%20") +
				"&CURR="+java.net.URLEncoder.encode(strCurr)+
				"&REMARK="+java.net.URLEncoder.encode(strRemark)+
				"&PREORDERTYPE="+java.net.URLEncoder.encode(ODRTYPE)+
				"&ISMODELSELECTED=Y"+
				"&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
				//"&CUSTOMERIDTMP="+java.net.URLEncoder.encode(CustomerID)+
				"&INSERT=Y"+
				"&RFQTYPE="+java.net.URLEncoder.encode(RFQTYPE)+
				"&PROGRAMNAME=D4-019";
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
		String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG='D',LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG='N' AND CUSTOMER_ID='" + CustomerID +"' AND CUSTOMER_PO='"+ CustomerPO +"' AND UPLOAD_BY ='" + UPLOADBY+"'";
		PreparedStatement seqstmt=con.prepareStatement(sqlx);
		seqstmt.setString(1,UserName);
		seqstmt.executeUpdate();
		seqstmt.close();
	}
%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data" accept-charset="UTF-8">
	<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;">
		<br>
		<table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
			<tr>
				<td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font> <BR>
					<DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
				</td>
			</tr>
		</table>
	</div>
	<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
	<table width="100%" align="center" border="0">
		<tr>
			<td width="5%">&nbsp;</td>
			<td width="90%">
				<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
					<tr>
						<td height="50" align="center">
							<font color="#003399" size="+2"><strong>TSCT-DA </strong></font>
							<font color="#000000" size="+2"> <strong>  Excel Upload</strong></font>	</td>
					</tr>
				</table>
			</td>
			<td width="5%">&nbsp;</td>
		</tr>
		<tr>
			<td width="5%">&nbsp;</td>
			<td width="90%">
				<%
					if (!ACTIONCODE.equals("DETAIL"))
					{
				%>
				<table align="center" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
					<tr>
						<TD width="90%">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="<%=bkcolor%>" width="15%" height="20" align="center" style="border-color:#66CC66;border:insert;font-size:13px">Excel Upload</td>
									<td bgcolor="#CAE1CF" width="15%" align="center"><a href="../jsp/TSCTDistyBufferImport.jsp?ACTIONCODE=DETAIL" style="color:888888;font-size:13px;text-decoration:none;">Pending Detail</a></td>
									<td width="70%" style="border-color:ffffff;">&nbsp;</td>
								</tr>
							</table>
						</TD>
						<TD align="right" width="10%" title="回首頁!">
							<A HREF="../ORAddsMainMenu.jsp" style="font-size:13px;font-family:標楷體;text-decoration:none;color:#0000FF">
								<STRONG>回首頁</STRONG>
							</A>
						</TD>
					</tr>
					<tr><td height="10" colspan="2" bgcolor="<%=bkcolor%>"></td></tr>
					<tr>
						<td colspan="2">
							<table  bordercolordark="#000033" cellspacing="0"  cellpadding="0" width="100%" align="left" bordercolorlight="ffffff" border="1">
								<tr>
									<td width="15%" style="font-size:13px;background-color:<%=bkcolor%>">Sales Area：</td>
									<td ><input type="text" style="color:#000000;border:none;font-size:13px" size="80" name="SalesArea" value="<%=SalesArea%>" onKeyDown="return (event.keyCode!=8);" readonly>
								</tr>
								<tr>
									<td style="font-size:13px;;background-color:<%=bkcolor%>">Group By：</td>
									<td width="85%" ><input type="checkbox" name="checkbox1" value="<%=IDTYPE%>" <% if (MTYPE.equals(IDTYPE)) out.println("CHECKED");%> onClick="setchk('<%=IDTYPE%>');"><font style="font-size:13px;">By Customer ID產生RFQ</font>&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="checkbox" name="checkbox1" value="<%=POTYPE%>" <% if (MTYPE.equals(POTYPE)) out.println("CHECKED");%> onClick="setchk('<%=POTYPE%>');"><font style="font-size:13px;">By Customer PO產生RFQ</font></td>
								</tr>
								<tr>
									<td style="font-size:13px;background-color:<%=bkcolor%>">Upload File：</td>
									<td width="85%" ><INPUT TYPE="FILE" style="font-size:13px" NAME="UPLOADFILE" size="90"></td>
								</tr>
								<tr>
									<td style="font-size:13px;background-color:<%=bkcolor%>">Sample File：</td>
									<td width="85%" ><A HREF="../jsp/samplefiles/D4-019_SampleFile.xls"><font style="font-size:13px;">Download Sample File</font></A></td>
								</tr>
								<tr>
									<td style="font-size:13px;background-color:<%=bkcolor%>">User Guide：</td>
									<td width="85%" ><A HREF="../jsp/samplefiles/D4-019_FuncSpc.doc"><font style="font-size:13px;">Download User Guide</font></A></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" title="請按我，謝謝!" align="center">
							<input type="button" style="font-size:13px;font-family: Tahoma,Georgia;" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCTDistyBufferImport.jsp?ACTIONCODE=UPLOAD')">
						</td>
					</tr>
				</table>
				<%
				}
				else
				{
				%>
				<table align="center" width="100%" cellspacing="0" cellpadding="0" bordercolordark="#990000">
					<tr>
						<TD width="90%">
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tr>
									<td bgcolor="<%=bkcolor%>" width="15%" height="20" align="center" style="border-color:#CAE1CF;border:insert;font-size:13px"><a href="../jsp/TSCTDistyBufferImport.jsp?ACTIONCODE=DETAIL" style="font-size:13px;text-decoration:none;">Pending Detail</a></td>
									<td bgcolor="#CAE1CF" width="15%" align="center"><a href="../jsp/TSCTDistyBufferImport.jsp" style="color:888888;font-size:13px;text-decoration:none;">Excel Upload</a></td>
									<td width="70%" style="border-color:ffffff;">&nbsp;</td>
								</tr>
							</table>
						</TD>
						<TD align="right" width="10%" title="回首頁!">
							<A HREF="../ORAddsMainMenu.jsp" style="font-size:13px;font-family:標楷體;text-decoration:none;color:#0000FF">
								<STRONG>回首頁</STRONG>
							</A>
						</TD>
					</tr>
					<tr><td height="10" colspan="2" bgcolor="<%=bkcolor%>"></td></tr>
				</table>
				<%
					}
				%>
			</td>
			<td width="5%">&nbsp;</td>
		</tr>
	</table>
	<%
		String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
		PreparedStatement pstmt1=con.prepareStatement(sql1);
		pstmt1.executeUpdate();
		pstmt1.close();

		if (ACTIONCODE.equals("UPLOAD"))
		{
			try
			{
				mySmartUpload.initialize(pageContext);
				mySmartUpload.upload();
				String strDate=dateBean.getYearMonthDay();
				String strDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
				dateBean.setAdjDate(7);
				String strCHKDate = dateBean.getYearMonthDay();
				dateBean.setAdjDate(-7);
				com.jspsmart.upload.File upload_file=mySmartUpload.getFiles().getFile(0);
				String uploadFile_name=upload_file.getFileName();
				if (uploadFile_name == null || uploadFile_name.equals("") )
				{
					out.println("<script language=javascript>alert('請先按瀏覽鍵選擇欲上傳的office 2003 excel檔，謝謝!')</script>");
				}
				else if (!(uploadFile_name.toLowerCase()).endsWith("xls"))
				{
					out.println("<script language=javascript>alert('上傳檔案必須為office 2003 excel檔!')</script>");
				}
				else
				{
					CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
					cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
					cs1.execute();
					cs1.close();

					sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
							" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
							" ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+SalesAreaNo+"') d"+
							" where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
							" and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
							" and a.STATUS = b.STATUS "+
							" and a.ORG_ID = b.ORG_ID "+
							" and a.ORG_ID = d.PAR_ORG_ID"+
							" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+
							" and c.STATUS='A'"+
							" order by c.customer_id";
					Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					ResultSet rss = statements.executeQuery(sql);

					String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4019_"+strDateTime+"-"+uploadFile_name;
					upload_file.saveAs(uploadFilePath);
					java.util.Date datetime = new java.util.Date();
					SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
					String CreationDate = (String) formatter.format( datetime );
					InputStream is = new FileInputStream(uploadFilePath);
					jxl.Workbook wb = Workbook.getWorkbook(is);
					jxl.Sheet sht = wb.getSheet(0);


					//RFQ類型
					jxl.Cell cellRFQType = sht.getCell(1,0);
					strRFQType = cellRFQType.getContents();

					arrayRFQDocumentInputBean.setArrayString(oneDArray);
					aa = new String[sht.getRows()-sRow][oneDArray.length];
					//out.println("aa="+aa.length);

					//line detail
					for (int i = sRow; i < sht.getRows(); i++)
					{
						//客戶ID
						jxl.Cell cellCustNo = sht.getCell(0,i);
						strCustNo = cellCustNo.getContents();

						//訂單類型
						jxl.Cell cellOrderType = sht.getCell(1, i);
						strLineOrderType = (cellOrderType.getContents()).trim();

						//CUSTOMER PO
						jxl.Cell cellLineCustPO = sht.getCell(2, i);
						strLineCustPO = (cellLineCustPO.getContents()).trim();

						//台半料號.add by Peggy 20201124
						jxl.Cell cellItemName = sht.getCell(3, i);
						strItemName = (cellItemName.getContents()).trim();
						if (strItemName == null) strItemName= "";

						//台半品名
						jxl.Cell cellItemDesc = sht.getCell(4, i);
						strItemDesc = (cellItemDesc.getContents()).trim();
						if (strItemDesc == null) strItemDesc= "";

						//客戶品號
						jxl.Cell cellCustItem = sht.getCell(5, i);
						strCustItem = (cellCustItem.getContents()).trim();
						if (strCustItem == null) strCustItem= "";
						strCustItem = strCustItem.replace("'","");

						if (strItemDesc.equals("") && strCustItem.equals("")) continue;

						//數量
						jxl.Cell cellQty = sht.getCell(6, i);
						if (cellQty.getType() == CellType.NUMBER)
						{
							strQty = ""+((NumberCell) cellQty).getValue();
						}
						else strQty = (cellQty.getContents()).trim();
						if (strQty == null) strQty="0";

						//單價
						jxl.Cell cellSellingPrice = sht.getCell(7, i);
						if (cellSellingPrice.getType() == CellType.NUMBER)
						{
							strSellingPrice = ""+((NumberCell) cellSellingPrice).getValue();
						}
						else strSellingPrice = (cellSellingPrice.getContents()).trim();
						if (strSellingPrice == null) strSellingPrice="0";

						SimpleDateFormat sy1=new SimpleDateFormat("yyyyMMdd");

						//交貨日期
						try
						{
							jxl.Cell cellRequestDate = sht.getCell(8, i);
							if (cellRequestDate.getType() == CellType.DATE)
							{
								strRequestDate =sy1.format(((DateCell)cellRequestDate).getDate());
							}
							else
							{
								strRequestDate =(cellRequestDate.getContents()).replace("-","");
								if (strRequestDate.length() <8)
								{
									throw new Exception("");
								}
							}
						}
						catch(Exception e)
						{
							strRequestDate ="";
						}

						jxl.Cell cellShippingMethod = sht.getCell(9, i);
						strShippingMethod = (cellShippingMethod.getContents()).trim();
						if (strShippingMethod==null) strShippingMethod="";

						//REMARK
						jxl.Cell cellRemark = sht.getCell(10, i);
						strLineRemark = (cellRemark.getContents()).trim();

						//END CUSTOMER ID,add by Peggy 20140825
						jxl.Cell cellEndCustID = sht.getCell(11, i);
						strEndCustID = (cellEndCustID.getContents()).trim();
						if (strEndCustID==null) strEndCustID="";

						//Quote Number,add by Mars 20250120
						jxl.Cell cellQuoteNumber = sht.getCell(12, i);
						strQuoteNumber = (cellQuoteNumber.getContents()).trim();
						if (strQuoteNumber==null) strQuoteNumber="";

						strErr ="";strCustID="";strCustName="";strItemID="";rec_cnt=0;strFactory="";strOrderType="";strOrderTypeID="";strFOB="";//初始化

						//客戶代號
						if (strCustNo == null || strCustNo.equals(""))
						{
							strErr += "客戶代號不可空白<br>";
						}
						else
						{
							Statement statementa=con.createStatement();
							ResultSet rsa=statementa.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS where status = 'A'  and CUSTOMER_NUMBER ='"+strCustNo+"'");
							if(rsa.next())
							{
								strCustID = rsa.getString("CUSTOMER_ID");
								strCustName=rsa.getString("CUSTOMER_NAME");

								sql =" select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
										" a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
										" a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE"+
										" ,a.tax_code" +
										" from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
										" ,SO_PRICE_LISTS d"+
										" where  a.ADDRESS_ID = b.cust_acct_site_id"+
										" AND b.party_site_id = party_site.party_site_id"+
										" AND loc.location_id = party_site.location_id "+
										" and a.STATUS='A' "+
										" and a.PRIMARY_FLAG='Y'"+
										" and b.CUST_ACCOUNT_ID ='"+strCustID+"'"+
										" and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
										" and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
										" order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end ";
								Statement statementb=con.createStatement();
								ResultSet rsb=statementb.executeQuery(sql);
								while (rsb.next())
								{
									if (strShippingMethod.equals("") && rsb.getString("ship_via") != null)
									{
										strShippingMethod = rsb.getString("ship_via");
									}
									if (strFOB.equals("") && rsb.getString("FOB_POINT")!= null)
									{
										strFOB  = rsb.getString("FOB_POINT");
									}
									//add by Peggy 20171124
									if (strLineOrderType==null || strLineOrderType.equals(""))
									{
										if (rsb.getString("CURRENCY_CODE").equals("USD"))
										{
											strLineOrderType="1141";
										}
										else
										{
											strLineOrderType="1131";
										}
									}
								}
								rsb.close();
								statementb.close();
							}
							else
							{
								strErr += "ERP查無客戶資訊<br>";
							}
							rsa.close();
							statementa.close();
						}
						//customer po
						if (strLineCustPO==null || strLineCustPO.equals(""))
						{
							strErr += "Customer PO不可空白<br>";
						}

						//檢查客戶+customer po是否有待處理資料
						if (strCustNo != null && !strCustNo.equals("") && strLineCustPO !=null && !strLineCustPO.equals(""))
						{
							Statement statementa=con.createStatement();
							ResultSet rsa=statementa.executeQuery("select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where SALESAREANO = '"+SalesAreaNo+"'  and CUSTOMER_NO ='"+strCustNo+"' AND CUSTOMER_PO='"+ strLineCustPO+"' AND CREATE_FLAG='N'");
							if(rsa.next())
							{
								strErr += "Pending Detail已存在此客戶+PO資料!<br>";
							}
							rsa.close();
							statementa.close();
						}

						//品名
						if ((strItemDesc  == null || strItemDesc.equals("")) && (strCustItem == null || strCustItem.equals("")) && (strItemName == null || strItemName.equals("")))
						{
							strItemName = "&nbsp;";
							strItemDesc = "&nbsp;";
							strCustItem = "&nbsp;";
							strErr += "台半料號/品名及客戶品名不可同時空白<br>";
						}
						else
						{
							if (strCustItem != null && !strCustItem.equals(""))
							{
								sql = " select  DISTINCT a.item,a.ITEM_DESCRIPTION,a.INVENTORY_ITEM_ID,"+
										" a.INVENTORY_ITEM, a.SOLD_TO_ORG_ID,msi.PRIMARY_UOM_CODE"+
										" ,NVL(msi.ATTRIBUTE3,'N/A') ATTRIBUTE3"+
										//" ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) AS ORDER_TYPE"+
										" ,tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) AS ORDER_TYPE"+  //modify by Peggy 20191122
										" from oe_items_v a,inv.mtl_system_items_b msi "+
										" ,APPS.MTL_ITEM_CATEGORIES_V c "+
										" where a.SOLD_TO_ORG_ID = '"+strCustID+"' "+
										" and a.organization_id = msi.organization_id"+
										" and a.inventory_item_id = msi.inventory_item_id"+
										" and msi.INVENTORY_ITEM_ID = c.INVENTORY_ITEM_ID "+
										" and msi.ORGANIZATION_ID = c.ORGANIZATION_ID "+
										" and msi.ORGANIZATION_ID = '49'"+
										" and c.CATEGORY_SET_ID = 6"+
										" and a.CROSS_REF_STATUS='ACTIVE'"+
										" and msi.inventory_item_status_code <> 'Inactive'"+
										"and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
										"     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
										"     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+
										" and a.ITEM = '"+strCustItem+"'";
								if (strItemDesc != null && !strItemDesc.equals(""))
								{
									sql += " and a.ITEM_DESCRIPTION = '"+strItemDesc+"'";
								}
								if (strItemName != null && !strItemName.equals(""))
								{
									sql += " and a.INVENTORY_ITEM = '"+strItemName+"'";
								}
								Statement statement=con.createStatement();
								ResultSet rs = statement.executeQuery(sql);
								while(rs.next())
								{
									strItemName = rs.getString("INVENTORY_ITEM");
									strItemID = rs.getString("INVENTORY_ITEM_ID");
									strItemDesc = rs.getString("ITEM_DESCRIPTION");
									//strUOM = rs.getString("PRIMARY_UOM_CODE");
									strFactory = rs.getString("ATTRIBUTE3");
									strOrderType = strLineOrderType;
									//if (strOrderType.equals("1142"))  //add by Peggy 20161024
									//{
									//	strFactory ="008";
									//}
									if (strOrderType.equals("1156"))
									{
										strFactory ="002";
									}
									rec_cnt++;
								}
								rs.close();
								statement.close();
								if (rec_cnt==0)
								{
									strErr += "客戶品號在ERP不存在<br>";
								}
							}
							else
							{
								if ((strItemDesc != null && !strItemDesc.equals("")) || (strItemName != null && !strItemName.equals("")))
								{
									sql = " SELECT DISTINCT msi.description,msi.segment1, msi.inventory_item_id,msi.primary_uom_code,NVL (msi.attribute3, 'N/A') attribute3,"+
											//" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3)  AS order_type"+
											" tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id)  AS order_type"+  //modify by Peggy 20191122
											" FROM  inv.mtl_system_items_b msi, apps.mtl_item_categories_v c"+
											" WHERE msi.inventory_item_id = c.inventory_item_id"+
											" AND msi.organization_id = c.organization_id"+
											" AND msi.organization_id = '49'"+
											" AND c.category_set_id = 6"+
											" AND msi.inventory_item_status_code <> 'Inactive'"+
											" AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+
											" AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+
											" AND msi.description =  nvl('"+strItemDesc+"',msi.description)"+
											"and tsc_get_item_coo(msi.inventory_item_id) =(\n" +
											"     case when TSC_INV_CATEGORY(msi.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" +
											"     then 'CN' else tsc_get_item_coo(msi.inventory_item_id) end) \n"+
											" AND msi.segment1 = nvl('"+strItemName+"',msi.segment1)";
									Statement statement=con.createStatement();
									//out.println(sql);
									ResultSet rs = statement.executeQuery(sql);
									while(rs.next())
									{
										strItemName = rs.getString("segment1");
										strItemID = rs.getString("INVENTORY_ITEM_ID");
										strItemDesc = rs.getString("description");
										strCustItem = "&nbsp;";
										//strUOM = rs.getString("PRIMARY_UOM_CODE");
										strFactory = rs.getString("ATTRIBUTE3");
										strOrderType = strLineOrderType;
										//if (strOrderType.equals("1142")) //add by Peggy 20161024
										//{
										//	strFactory ="008";
										//}
										if (strOrderType.equals("1156"))
										{
											strFactory ="002";
										}

										rec_cnt++;
									}
									rs.close();
									statement.close();
								}
								if (rec_cnt==0)
								{
									strErr += "台半品號在ERP不存在<br>";
								}
							}

							if (rec_cnt >1)
							{
								strErr += "對應的台半料號超過一個以上,請選擇正確台半料號<br>";
							} else {
								if (!strQuoteNumber.equals("") && !strItemDesc.equals(""))
								{
									strSellingPrice_Q="";strEndCustName="";
									Statement state1=con.createStatement();
									//sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, case when INSTR(UPPER(a.createdby),'LISA')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JUNE')>0 THEN '(TSCR)' when INSTR(UPPER(a.createdby),'JWANG')>0 THEN '(TSCR)' ELSE '(TSCI)' END || a.endcustomer end_customer"+
									sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, '('|| a.region ||')'|| a.endcustomer end_customer"+	 //add by Peggy 20240217
											" FROM tsc_om_ref_quotenet a "+
											" where a.quoteid='"+strQuoteNumber+"'"+
											" and a.partnumber='"+strItemDesc+"'"+
											" order by a.quoteid, a.partnumber";
									//out.println(sql);
									ResultSet rs1=state1.executeQuery(sql);
									if (rs1.next())
									{
										strSellingPrice_Q = rs1.getString("PRICE_USD");
										strEndCustName = rs1.getString("END_CUSTOMER");
									}
									rs1.close();
									state1.close();
									if (strSellingPrice_Q.equals(""))
									{
										state1=con.createStatement();
										sql = " SELECT a.quoteid, a.partnumber,a.currency, TO_CHAR(a.pricekusd/1000,'FM99990.0999999') price_usd, '('|| a.region ||')'|| a.endcustomer end_customer"+	 //add by Peggy 20240217
												" FROM tsc_om_ref_quotenet a "+
												" where a.quoteid='"+strQuoteNumber+"'"+
												" and a.partnumber like '"+strItemNoPacking+"%'"+
												" order by a.quoteid, a.partnumber";
										rs1=state1.executeQuery(sql);
										if (rs1.next())
										{
											strSellingPrice_Q = rs1.getString("PRICE_USD");
											strEndCustName = rs1.getString("END_CUSTOMER");
										}
										rs1.close();
										state1.close();
									}
								}
							}
						}

						//檢查訂單類型是否正確
						Statement stateodrtype=con.createStatement();
						sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
								" where b.order_num=a.order_num and a.order_num='"+strOrderType+"' and a.SAREA_NO ='"+SalesAreaNo+"' and a.active='Y'"+
								" and b.MANUFACTORY_NO='"+strFactory+"' and b.ACTIVE='Y'";
						//out.println(sql);
						ResultSet rsodrtype=stateodrtype.executeQuery(sql);
						if (!rsodrtype.next())
						{
							strErr += "訂單類型錯誤<br>";
						}
						else
						{
							strOrderTypeID=rsodrtype.getString(1);

						}
						rsodrtype.close();
						stateodrtype.close();

						//數量
						if (strQty == null || strQty.equals(""))
						{
							strQty = "&nbsp;";
							strErr += "數量不可空白<br>";
						}
						else
						{
							try
							{
								double qtynum = Double.parseDouble(strQty.replace(",",""));
								if ( qtynum <= 0)
								{
									strErr += "數量必須大於零<br>";
								}
								else
								{
									strQty=(new DecimalFormat("#######0.0##")).format(qtynum);
								}
							}
							catch (Exception e)
							{
								strErr += "數量格式錯誤<br>";
							}
						}

						//單價
						if (strSellingPrice == null || strSellingPrice.equals(""))
						{
							if (strSellingPrice_Q == null || strSellingPrice_Q.equals(""))
							{
								strSellingPrice = "";
								strErr +="Selling Price不可空白<br>";
							}
							else
							{
								strSellingPrice=strSellingPrice_Q;
							}
						} else {
							try
							{
								float pricenum = Float.parseFloat(strSellingPrice.replace(",",""));
								if ( pricenum <= 0)
								{
									strErr += "Selling Price必須大於零<br>";
								}
								else if (!strSellingPrice.equals(strSellingPrice_Q)) //add by Peggy 20231229
								{
									strErr += "Selling Price not match quote price("+strSellingPrice_Q+")<br>";
								}
								else
								{
									strSellingPrice =(new DecimalFormat("###,##0.000##")).format(pricenum);
								}
							}
							catch (Exception e)
							{
								strErr += "單價格式錯誤<br>";
							}
						}

						//交貨日期
						if (strRequestDate == null || strRequestDate.equals(""))
						{
							strRequestDate = "&nbsp;";
							strErr +="Request Date不可空白<br>";
						}
						else if (Long.parseLong(strRequestDate) <= Long.parseLong(strCHKDate))
						{
							strErr +="Request Date"+strRequestDate+"必須大於"+strCHKDate+"<br>";
						}

						//出貨方式
						if (strShippingMethod == null || strShippingMethod.equals(""))
						{
							strShippingMethod = "&nbsp;";
							strErr +="出貨方式不可空白<br>";
						}

						//FOB
						if (strFOB == null || strFOB.equals(""))
						{
							strFOB = "&nbsp;";
							strErr += "FOB不可空白<br>";
						}

						//REMARK
						if (strLineRemark == null || strLineRemark.equals(""))
						{
							strLineRemark = "&nbsp;";
						}

						//END CUSTOMER
						strEndCust="";strEndCustID1="";
						if (!strEndCustID.equals(""))
						{
							//end customer id不可與customer id相同
							if (strEndCustID.equals(strCustNo))
							{
								strErr += "End Customer ID不可與Customer ID相同<br>";
							}
							else
							{
								if (rss.isBeforeFirst() ==false) rss.beforeFirst();
								while (rss.next())
								{
									if (rss.getString("customer_number").equals(strEndCustID))
									{
										strEndCust = rss.getString("CUSTOMER_NAME_PHONETIC");
										strEndCustID1 =""+rss.getInt("customer_id");
										break;
									}
								}
								if (strEndCust.equals("")) strErr += "End Customer ID不存在ERP<br>";
							}
						} else if (!strEndCustName.equals("")) {
							strEndCust=strEndCustName;
						}

						if (strErr.length() > 0)
						{
							if (ErrCnt ==0)
							{
	%>
	<table cellspacing="0" bordercolordark="#ffffff" cellpadding="1" width="90%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#96AEBC" style="color:#ffffff;font-size:11px;">
			<td width='4%'>Customer No</td>
			<td width='10%'>Customer Name</td>
			<td width='4%'>RFQ Type</td>
			<td width='8%'>Customer PO</td>
			<td width='4%'>Order Type</td>
			<td width='8%'>TSC P/N</td>
			<td width='8%'>Customer P/N</td>
			<td width='5%'>Qty(KPCS)</td>
			<td width='5%'>Selling<br>Price</td>
			<td width='4%'>SSD</td>
			<td width='7%'>Remarks</td>
			<td width='4%'>End Cust ID</td>
			<td width='6%'>End Customer</td>
			<td width='10%'>Error<br>Message</td>
		</tr>
		<%
			}
		%>
		<tr bgcolor="#CCFFAC" style="color:#000000;font-size:11px;">
			<td><%=strCustNo%></td>
			<td><%=strCustName%></td>
			<td><%=strRFQType%></td>
			<td><%=strLineCustPO%></td>
			<td><%=strOrderType%></td>
			<td><%=strItemDesc%></td>
			<td><%=strCustItem%></td>
			<td><%=strQty%></td>
			<td><%=strSellingPrice%></td>
			<td><%=strRequestDate%></td>
			<td><%=strLineRemark%></td>
			<td><%=(strEndCustID==null ||strEndCustID.equals("")?"&nbsp;":strEndCustID)%></td>
			<td><%=(strEndCust==null || strEndCust.equals("")?"&nbsp;":strEndCust)%></td>
			<td style="color:#FF0000"><%=strErr%></td>
		</tr>
		<%
						strErr="";
						ErrCnt ++;
					}
					Statement state1=con.createStatement();
					sql = " select DEFAULT_ORDER_LINE_TYPE LINE_TYPE_ID from ORADDMAN.TSAREA_ORDERCLS c  where c.SAREA_NO = '"+SalesAreaNo+"' and c.ORDER_NUM='"+strOrderType+"'";
					ResultSet rs1=state1.executeQuery(sql);
					if (rs1.next())
					{
						strLineType = rs1.getString("LINE_TYPE_ID");
					}
					else
					{
						strLineType ="0";
					}
					rs1.close();
					state1.close();

					strCustPO="";
					if (MTYPE.equals(IDTYPE))
					{
						for (int g =0 ; g< aa.length ;g++)
						{
							if (aa[g][0] == null) continue;
							if (strCustNo.equals(aa[g][0]))
							{
								if (aa[g][3] == null) continue;
								strCustPO=aa[g][3];
								break;
							}
						}
						if (strCustPO ==null || strCustPO.equals("")) strCustPO=strLineCustPO;
					}
					else
					{
						strCustPO=strLineCustPO;
					}
					aa[icnt][0]=strCustNo;
					aa[icnt][1]=strCustName;
					aa[icnt][2]=strRFQType;
					aa[icnt][3]=strCustPO;
					aa[icnt][4]=strItemDesc;
					aa[icnt][5]=strItemName;
					aa[icnt][6]=strCustItem;
					aa[icnt][7]=strFactory;
					aa[icnt][8]=strUOM;
					aa[icnt][9]=strQty;
					aa[icnt][10]=strSellingPrice;
					aa[icnt][11]="";
					aa[icnt][12]=strRequestDate;
					aa[icnt][13]=strShippingMethod ;
					aa[icnt][14]=strFOB;
					aa[icnt][15]=strLineRemark.replace("&nbsp;","");
					aa[icnt][16]=strOrderTypeID;
					aa[icnt][17]=strLineType;
					aa[icnt][18]=strItemID;
					aa[icnt][19]=strCustID;
					aa[icnt][20]=strLineCustPO;
					aa[icnt][21]=strEndCustID1;
					aa[icnt][22]=strEndCust;
					aa[icnt][23]=strQuoteNumber; //Quote Number,add by Peggy 20190227
					//out.println("strLineCustPO="+strLineCustPO);
					icnt++;
				}
				wb.close();
				rss.close();
				statements.close();

				if (icnt ==0)
				{
					throw new Exception("上傳內容錯誤!");
				}
			}

			if (ErrCnt >0)
			{
		%>
	</table>
	<%
				out.println("<table width='90%' align='center'><tr><td align='center'><font style='color:#ff0000;font-family:標楷體;font-size:16px'>上傳動作失敗，請洽系統管理員，謝謝!</font></td></tr></table>");
			}
			else
			{
				for (int i =0 ; i < aa.length ; i++)
				{
					if (aa[i][0] == null || aa[i][0].equals("")) continue;
					sql=" insert into oraddman.tsc_rfq_upload_temp("+
							"salesareano,"+        //0
							"upload_date,"+        //1
							"upload_by,"+          //2
							"customer_no,"+        //3
							"customer_name,"+      //4
							"rfq_type,"+           //5
							"customer_po,"+        //6
							"inventory_item_id,"+  //7
							"cust_item_name,"+     //8
							"qty,"+                //9
							"selling_price,"+      //10
							"crd,"+                //11
							"request_date,"+       //12
							"shipping_method,"+    //13
							"fob,"+                //14
							"remarks,"+            //15
							"order_type,"+         //16
							"line_type,"+          //17
							"create_flag,"+        //18
							"CUSTOMER_ID,"+        //19
							"FACTORY,"+            //20
							"customer_po_line_number,"+ //21
							"line_no,"+            //22
							"END_CUSTOMER_ID,"+    //23
							"END_CUSTOMER,"+       //24
							"QUOTE_NUMBER)"+       //25
							" values("+
							"?,"+                  //0
							"SYSDATE,"+            //1
							"?,"+                  //2
							"?,"+                  //3
							"?,"+                  //4
							"?,"+                  //5
							"?,"+                  //6
							"?,"+                  //7
							"?,"+                  //8
							"?,"+                  //9
							"?,"+                  //10
							"?,"+                  //11
							"?,"+                  //12
							"?,"+                  //13
							"?,"+                  //14
							"?,"+                  //15
							"?,"+                  //16
							"?,"+                  //17
							"?,"+                  //18
							"?,"+                  //19
							"?,"+                  //20
							"?,"+                  //21
							"?,"+                  //22
							"?,"+                  //23
							"?,"+                  //24
							"?)";                  //25
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,SalesAreaNo);          //salesareano
					pstmt.setString(2,UserName);             //upload_by
					pstmt.setString(3,aa[i][0]);             //customer_no
					pstmt.setString(4,aa[i][1]);             //customer_name
					pstmt.setString(5,aa[i][2].toUpperCase());    //rfq_type
					pstmt.setString(6,aa[i][3]);             //customer_po
					pstmt.setString(7,aa[i][18]);            //inventory_item_id
					pstmt.setString(8,(aa[i][6].equals("&nbsp;")?"":aa[i][6]));             //cust_item_name
					pstmt.setString(9,aa[i][9]);             //qty
					pstmt.setString(10,aa[i][10]);           //selling_price
					pstmt.setString(11,aa[i][11]);           //crd
					pstmt.setString(12,aa[i][12]);           //request_date
					pstmt.setString(13,aa[i][13]);           //shipping_method
					pstmt.setString(14,aa[i][14]);           //fob
					pstmt.setString(15,aa[i][15]);           //remarks
					pstmt.setString(16,aa[i][16]);           //order_type
					pstmt.setString(17,aa[i][17]);           //line_type
					pstmt.setString(18,"N");                 //create_flag
					pstmt.setString(19,aa[i][19]);           //customer_id
					pstmt.setString(20,aa[i][7]);            //factory
					pstmt.setString(21,aa[i][20]);           //customer po line number
					pstmt.setInt(22,(insert_cnt+1));         //line_no
					pstmt.setString(23,aa[i][21]);           //END CUSTOMER ID,add by Peggy 20140825
					pstmt.setString(24,aa[i][22]);           //END CUSTOMER,add by Peggy 20140825
					pstmt.setString(25,aa[i][23]);           //END CUSTOMER,add by Peggy 20140825
					pstmt.executeQuery();
					pstmt.close();
					insert_cnt++;
				}
				con.commit();
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("error1:"+e.getMessage());
		}
		if (insert_cnt >0)
		{
	%>
	<script language="javascript">
		location.href("TSCTDistyBufferImport.jsp?ACTIONCODE=DETAIL");
	</script>

	<%
		}
	}
	else if (ACTIONCODE.equals("DETAIL"))
	{
	%>
	<table align="center" border="1" width="90%" cellspacing="0" cellpadding="1" bordercolorlight="#DFD9DD" bordercolordark="#4A598A">
		<tr style="background-color:<%=bkcolor%>;font-size:10px" >
			<td width="2%"  align="center">&nbsp;</td>
			<td width="18%" align="center">Customer Name</td>
			<td width="5%"  align="center">RFQ Type</td>
			<td width="10%" align="center">Customer PO</td>
			<td width="10%" align="center">Item Desc</td>
			<td width="9%"  align="center">Customer Item</td>
			<td width="5%"  align="center">Qty</td>
			<td width="5%"  align="center">Selling<br>Price</td>
			<td width="6%"  align="center">Request Date</td>
			<td width="5%"  align="center">Order Type</td>
			<td width="6%"  align="center">End Cust ID</td>
			<td width="10%"  align="center">End Customer</td>
			<td width="10%" align="center">Upload By</td>
		</tr>
		<%
			try
			{
				int i =0;
				String customerpo="",customerno="",upload_by="";
				sql = " SELECT a.salesareano, a.upload_date, a.upload_by, a.customer_no,a.customer_id,"+
						" a.customer_name, a.rfq_type, UTL_I18N.UNESCAPE_REFERENCE(a.customer_po) customer_po, b.description,"+
						" a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,"+
						" a.shipping_method, a.fob, a.remarks,d.OTYPE_ID, d.ORDER_NUM order_type, a.line_type, UTL_I18N.UNESCAPE_REFERENCE(a.customer_po_line_number) customer_po_line_number,"+
						" (select count(1) from oraddman.tsc_rfq_upload_temp c where  c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by) rowcnt"+
						",e.customer_number end_customer_id,end_customer"+
						" FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
						",ar_customers e"+
						" where a.create_flag=?"+
						" and a.salesareano=?"+
						" and b.organization_id=43"+
						" and a.inventory_item_id = b.inventory_item_id"+
						" and a.salesareano=d.SAREA_NO"+
						" and a.order_type=d.OTYPE_ID"+
						" and a.end_customer_id = e.customer_id(+)"+
						" order by a.customer_no, a.customer_po,a.upload_by,a.line_no,b.description";
				PreparedStatement st = con.prepareStatement(sql);
				st.setString(1,"N");
				st.setString(2,SalesAreaNo);
				ResultSet rs = st.executeQuery();
				while(rs.next())
				{
		%>
		<tr>
			<%
				if (!customerpo.equals(rs.getString("customer_po")) || !customerno.equals(rs.getString("customer_no")) || !upload_by.equals(rs.getString("upload_by")))
				{
					i++;
			%>
			<td rowspan="<%=rs.getString("rowcnt")%>" style="color:#000000;font-size:11px"><input type="button" name="btn<%=i%>" value="Delete" style="font-size:11px;font-family: Tahoma,Georgia;" title="刪除資料" onClick="delData('../jsp/TSCTDistyBufferImport.jsp?DELFLAG=Y&CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&UPLOADBY=<%=rs.getString("upload_by")%>')"></td>
			<td id="tda<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%="("+rs.getString("customer_no")+")"+rs.getString("customer_name")%></td>
			<td id="tdc<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("rfq_type")%></td>
			<%
					customerpo=rs.getString("customer_po");
					customerno=rs.getString("customer_no");
					upload_by=rs.getString("upload_by");
				}
			%>
			<td id="tdb<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=java.net.URLEncoder.encode(rs.getString("customer_name"))%>&CUSTOMERPO=<%=java.net.URLEncoder.encode(rs.getString("customer_po"))%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("CUSTOMER_PO_LINE_NUMBER")%></td>
			<td id="tdd<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("description")%></td>
			<td id="tde<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=(rs.getString("cust_item_name")==null?"&nbsp;":rs.getString("cust_item_name"))%></td>
			<td id="tdf<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.######")).format(rs.getDouble("qty"))%></td>
			<td id="tdg<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.######")).format(rs.getDouble("selling_price"))%></td>
			<td id="tdh<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("request_date")%></td>
			<td id="tdi<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("order_type")%></td>
			<td id="tdj<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer_id")==null?"&nbsp;":rs.getString("end_customer_id"))%></td>
			<td id="tdk<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer")==null?"&nbsp;":rs.getString("end_customer"))%></td>
			<td id="tdl<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCTDistyBufferImport.jsp?CUSTOMERID=<%=rs.getString("customer_id")%>&CUSTOMERNO=<%=rs.getString("customer_no")%>&CUSTOMERNAME=<%=rs.getString("customer_name")%>&CUSTOMERPO=<%=rs.getString("customer_po")%>&ODRTYPE=<%=rs.getString("OTYPE_ID")%>&RFQTYPE=<%=rs.getString("rfq_type")%>&UPLOADBY=<%=rs.getString("upload_by")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("upload_by")%></td>
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
	<%
		}
	%>

	<!--=============以下區段為釋放連結池==========-->
	<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
	<input name="ROWCOLOR" type="HIDDEN" value="<%=rowColor%>">
	<input name="HIGHLIGHTOLOR" type="HIDDEN" value="<%=highlightColor%>">
</form>
</body>
</html>
