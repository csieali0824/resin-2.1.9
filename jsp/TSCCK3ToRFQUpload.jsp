<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
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
<%@ page import="com.mysql.jdbc.StringUtils" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
	<title>TSCC 內外銷RFQ Excel Upload</title>
	<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
	<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
	<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
	<meta http-equiv="Content-Type" content="text/html; charset=big5" />
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
		var chkflag = false;
		var RFQ_TYPE = "";
		var radioLength = document.form1.rfqtype.length;
		if(radioLength == undefined)
		{
			return;
		}
		for(var i = 0; i < radioLength; i++)
		{
			if ( document.form1.rfqtype[i].checked)
			{
				RFQ_TYPE = document.form1.rfqtype[i].value;
				chkflag=true;
				break;
			}
		}
		if (chkflag == false)
		{
			alert("請選擇RFQ類型!");
			return false;
		}
		document.form1.submit1.disabled=true;
		document.getElementById("alpha").style.width="100"+"%";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.form1.action=URL+"&RFQ_TYPE="+RFQ_TYPE;;
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
		document.getElementById("tdo"+objid).style.backgroundColor =color2;
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
			document.getElementsByName("tdm"+objid)[i].style.backgroundColor =color2;
			document.getElementsByName("tdn"+objid)[i].style.backgroundColor =color2;
			document.getElementsByName("tdr"+objid)[i].style.backgroundColor =color2;
		}
	}
	function unfocuscolor(objid)
	{
		var color1 = document.form1.ROWCOLOR.value;
		color1=color1.toLowerCase();
		document.getElementById("tda"+objid).style.backgroundColor =color1;
		document.getElementById("tdo"+objid).style.backgroundColor =color1;
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
			document.getElementsByName("tdm"+objid)[i].style.backgroundColor =color1;
			document.getElementsByName("tdn"+objid)[i].style.backgroundColor =color1;
			document.getElementsByName("tdr"+objid)[i].style.backgroundColor =color1;
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
	function toRFQ(URL)
	{
		document.form1.action=URL;
		document.form1.submit();
	}
	function setSearch(URL)
	{
		document.form1.action=URL;
		document.form1.submit();
	}
</script>
<STYLE TYPE='text/css'>
	BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
	P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
	TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}
	TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
	A         { text-decoration: underline; font-size: 12px  }
	A:visited { color: #990066; text-decoration: underline }
	A:active  { color: #FF0000; text-decoration: underline }
	.board    { background-color: #D6DBE7}
	.text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
</head>
<body>
<%
	String sType = request.getParameter("STYPE");
	if (sType==null) sType="";
	String ACTIONCODE = request.getParameter("ACTIONCODE");
	if (ACTIONCODE == null) ACTIONCODE = "";
	String SalesAreaNo = "002";
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
	String SHIPTO = request.getParameter("SHIPTO");
	if (SHIPTO == null) SHIPTO="";
	String rfqTypeName1= "NORMAL";
	String rfqTypeName2= "FORECAST";
	String ODRTYPE=request.getParameter("ODRTYPE");
	String RFQ_TYPE = request.getParameter("RFQ_TYPE");
	String TEMP_ID = request.getParameter("TEMP_ID");
	if (TEMP_ID==null) TEMP_ID="";
	String rfqTypeNormal = "";
	String rfqTypeForecast = "";
	int icnt=0,ErrCnt=0,sRow=1,rec_cnt=0,insert_cnt=0,col_cnt=32,rfq_col_cnt=30,v_org_id=0,v_Year=0,v_Month=0,v_Days=0;
	String seqno="",seqkey="",strURL="",strTempId="",PREORDERTYPE="";
	String salesPerson="",toPersonID="";
	String IDTYPE = "CUSTID",POTYPE="CUSTPO",strCurr="";
	String strCustNo="",strCustID="",strLineCustPO="",strLineCustPOLineNo="",strLineRemark="",FOBList="",ShippingMethodList="",urlDir ="",OrderTypeList="";
	String sql = "",strOtypeID ="",strUOM="KPC",strFactory="",strHeaderOrderType="",strItemID="",strBIRegion="";
	String strLineType="",strItemName ="",strOrderType="",strOrderTypeID="",strCustName="",strCustPO="",strRFQType="",strItemDesc="";
	String strQty="",strCustItem="",strSellingPrice="",strCRD="",strSSD="",strRequestDate="",strShippingMethod="",strFOB="",strEndCust="",strErr="",strShipTo="",strK3Remarks="",strEndCustSName="";
	String rowColor="#ffffff",highlightColor="#EEDDCC";
	String bkcolor="#C6D1E6";
	String strEndCustID ="",strEndCustID1 ="",BIRegionList="";
	String shipToContact="",shipToContactid=""; //add by Peggy 20170321
	String oneDArray[] = new String [col_cnt];
	String aa [][] = new String[1][1];
	String bb [][] = new String[1][1];
	String strK3OrderNo="",strK3OrderLineNo="",strUom="",strK3CustCode="",strSampleOrder="",strK3AddrCode="",strEndCust1="",strEndCustShipTo="",strPriceList="",strSGShipTo="";
	SimpleDateFormat sy1=new SimpleDateFormat("yyyy/MM/dd");
	String v_normal_inactive_flag=""; //add by Peggy 20230113
	String[] customerNumberForByd = new String[]{"32652", "32653", "32654", "32655"};

	try
	{
		if (!UserRoles.equals("admin") && !UserName.toUpperCase().equals("SPRING_CHUANG") && !UserName.toUpperCase().equals("TSCC JOYCE") && !UserName.toUpperCase().equals("SUNNY_LU"))
		{
%>
<script language="JavaScript" type="text/JavaScript">
	alert("您沒有該區域使用權限,無法使用此功能,謝謝!");
	location.href="../ORAddsMainMenu.jsp";
</script>
<%
		}
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
	if (InsertFlag.equals("Y"))
	{
		try
		{
			sql = " SELECT a.salesareano,a.RFQ_TYPE,a.UPLOAD_BY,a.customer_no,a.customer_id,"+
					" a.customer_name, a.customer_po, b.description,b.segment1,"+
					" a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,b.PRIMARY_UOM_CODE uom,a.crd,a.factory,a.fob,"+
					" a.shipping_method, a.fob, a.remarks, d.ORDER_NUM order_type, a.line_type,a.customer_po_line_number ,"+
					" (select count(1) from oraddman.tsc_rfq_upload_temp c where  c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by and c.ship_to_org_id = a.ship_to_org_id) rowcnt"+
					",e.customer_number END_CUSTOMER_ID,a.END_CUSTOMER,a.ship_to_org_id,d.OTYPE_ID"+
					",a.bi_region,a.k3_order_no,a.k3_order_line_no,a.end_customer_ship_to_org_id"+
					" FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
					",ar_customers e"+
					" where a.create_flag=?"+
					" and a.temp_id=?"+
					" and b.organization_id=43"+
					" and a.inventory_item_id = b.inventory_item_id"+
					" and a.salesareano=d.SAREA_NO"+
					" and a.order_type=d.OTYPE_ID"+
					" and a.end_customer_id=e.customer_id(+)"+
					" order by a.customer_no,a.customer_po,a.line_no,b.description";
			PreparedStatement st = con.prepareStatement(sql);
			st.setString(1,"N");
			st.setString(2,TEMP_ID);
			icnt=0;
			ResultSet rs = st.executeQuery();
			while(rs.next())
			{
				if (icnt ==0)
				{
					bb=new String[Integer.parseInt(rs.getString("rowcnt"))][rfq_col_cnt];
					CustomerNo = rs.getString("CUSTOMER_NO");
					CustomerPO = rs.getString("CUSTOMER_PO");
					CustomerID = rs.getString("CUSTOMER_ID");
					SHIPTO = rs.getString("ship_to_org_id");
					CustomerName = rs.getString("CUSTOMER_NAME");
					UPLOADBY = rs.getString("UPLOAD_BY");
					ODRTYPE = rs.getString("order_type");
					RFQ_TYPE = rs.getString("RFQ_TYPE");
					PREORDERTYPE=rs.getString("OTYPE_ID");
					SalesAreaNo=rs.getString("salesareano");

					//add by Peggy 20170321,add ship to contact
					sql =" select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
							" from ar_contacts_v con,hz_cust_site_uses su,HZ_CUST_SITE_USES_ALL hcsu "+
							" where  con.customer_id ='"+CustomerID+"'"+
							" and con.status='A'"+
							" AND con.address_id=su.cust_acct_site_id"+
							" AND su.site_use_code='SHIP_TO'"+
							" AND hcsu.CUST_ACCT_SITE_ID =con.address_id(+)"+
							" AND hcsu.SITE_USE_ID='"+SHIPTO+"'"+
							" ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+CustomerID+"',1,2)";
					PreparedStatement st1 = con.prepareStatement(sql);
					ResultSet rs1 = st1.executeQuery();
					if (rs1.next())
					{
						shipToContact = rs1.getString("contact_name");
						shipToContactid = rs1.getString("contact_id");
					}
					rs1.close();
					st1.close();
				}
				bb[icnt][0]=""+(icnt+1);
				bb[icnt][1]=rs.getString("segment1");
				bb[icnt][2]=rs.getString("description");
				bb[icnt][3]=rs.getString("qty");
				bb[icnt][4]=rs.getString("uom");
				bb[icnt][5]=rs.getString("crd");
				bb[icnt][6]=rs.getString("shipping_method");
				bb[icnt][7]=rs.getString("request_date");
				bb[icnt][8]=rs.getString("customer_po_line_number");
				bb[icnt][9]=(rs.getString("remarks")==null?"":rs.getString("remarks"));
				bb[icnt][10]="N";
				bb[icnt][11]="0";
				bb[icnt][12]="0";
				bb[icnt][13]=rs.getString("factory");
				bb[icnt][14]=(rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name"));
				bb[icnt][15]=rs.getString("selling_price");
				bb[icnt][16]=rs.getString("order_type");
				bb[icnt][17]=rs.getString("line_type");
				bb[icnt][18]=rs.getString("fob");
				bb[icnt][19]="*"+rs.getString("k3_order_no") +"-"+rs.getString("k3_order_line_no");
				bb[icnt][20]="";
				bb[icnt][21]=(rs.getString("end_customer_id")==null?"":rs.getString("end_customer_id"));
				bb[icnt][22]="";
				bb[icnt][23]="";
				bb[icnt][24]=(rs.getString("end_customer")==null?"":rs.getString("end_customer"));
				bb[icnt][25]="";
				bb[icnt][26]="";
				bb[icnt][27]=(rs.getString("bi_region")==null?"":rs.getString("bi_region"));
				bb[icnt][28]=(rs.getString("end_customer_ship_to_org_id")==null?"":rs.getString("end_customer_ship_to_org_id"));
				bb[icnt][29]="";
				icnt++;
			}
			rs.close();
			st.close();
			arrayRFQDocumentInputBean.setArray2DString(bb);
			session.setAttribute("SPQCHECKED","N");
			session.setAttribute("CUSTOMERID",CustomerID);
			session.setAttribute("CUSTOMERNO",CustomerNo);
			session.setAttribute("CUSTOMERNAME",CustomerName);
			session.setAttribute("CUSTOMERPO", CustomerPO);
			session.setAttribute("CUSTACTIVE","Y");
			session.setAttribute("SALESAREANO",SalesAreaNo);
			session.setAttribute("REMARK",strRemark);
			session.setAttribute("PREORDERTYPE",PREORDERTYPE);
			session.setAttribute("ISMODELSELECTED","Y");
			session.setAttribute("CUSTOMERIDTMP",CustomerID);
			session.setAttribute("INSERT","Y");
			session.setAttribute("RFQ_TYPE",RFQ_TYPE);
			session.setAttribute("MAXLINENO",""+bb.length);
			session.setAttribute("CURR", strCurr);
			session.setAttribute("PROGRAMNAME","D4-016");
			session.setAttribute("SHIPTO",SHIPTO);
			session.setAttribute("UPLOAD_TEMP_ID",TEMP_ID);
			urlDir = "TSSalesDRQ_Create.jsp?CUSTOMERID="+java.net.URLEncoder.encode(CustomerID)+
					"&SPQCHECKED=N"+
					"&CUSTOMERNO="+java.net.URLEncoder.encode(CustomerNo)+
					"&CUSTACTIVE=A"+
					"&SALESAREANO="+java.net.URLEncoder.encode(SalesAreaNo)+
					"&CUSTOMERPO="+java.net.URLEncoder.encode(CustomerPO)+
					"&CURR="+java.net.URLEncoder.encode(strCurr)+
					"&REMARK="+java.net.URLEncoder.encode(strRemark)+
					"&PREORDERTYPE="+java.net.URLEncoder.encode(PREORDERTYPE)+
					"&ISMODELSELECTED=Y"+
					"&PROCESSAREA="+java.net.URLEncoder.encode(SalesAreaNo)+
					"&SHIPTO="+java.net.URLEncoder.encode(SHIPTO)+
					"&INSERT=Y"+
					"&RFQTYPE="+java.net.URLEncoder.encode(RFQ_TYPE)+
					"&UPLOAD_TEMP_ID="+java.net.URLEncoder.encode(TEMP_ID)+
					"&SHIPTOCONTACT="+java.net.URLEncoder.encode(shipToContact)+
					"&SHIPTOCONTACTID="+java.net.URLEncoder.encode(shipToContactid)+
					"&SAMPLEORDER="+(ODRTYPE.equals("8121")?"on":"")+ //add by Peggy 20201111
					"&PROGRAMNAME=D4-016"+
					"&CUSTOMERNAME= "+java.net.URLEncoder.encode(CustomerName);
			try
			{
				response.sendRedirect(urlDir);
			}
			catch(Exception e)
			{
				out.println("Error:"+e.getMessage());
			}
		}
		catch(Exception e)
		{
			out.println("Error7:"+e.getMessage());
		}
	}

	if (DelFlag.equals("Y"))
	{
		String sqlx="update oraddman.tsc_rfq_upload_temp SET CREATE_FLAG='D',LAST_UPDATED_BY=?,LAST_UPDATE_DATE=sysdate WHERE CREATE_FLAG='N' AND TEMP_ID='"+TEMP_ID+"'";
		PreparedStatement seqstmt=con.prepareStatement(sqlx);
		seqstmt.setString(1,UserName);
		seqstmt.executeUpdate();
		seqstmt.close();
	}
%>
<form name="form1"  METHOD="post" ENCTYPE="multipart/form-data">
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
						<td height="50" align="center"><font style="color:#003399;font-weight:bold;font-family:Tahoma,Georgia;font-size:20px">TSCC 內外銷Excel上傳</font></td>
					</tr>
				</table>
			</td>
			<td width="5%">&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
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
									<td bgcolor="#CAE1CF" width="15%" align="center"><a href="../jsp/TSCCK3ToRFQUpload.jsp?ACTIONCODE=DETAIL" style="color:888888;font-size:13px;text-decoration:none;">Pending Detail</a></td>
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
									<td align="right">RFQ Type：</td>
									<%
										v_normal_inactive_flag="";
										if (!UserName.equals("TSCC JOYCE") && !UserName.equals("SU CS-001") && !UserName.equals("SU SALES-001") && !UserName.equals("SH SALES-011")  && !UserName.equals("SH CS-011"))
										{
											v_normal_inactive_flag="disabled";
										}
									%>
									<td ><input type="radio" name="rfqtype" value="<%=rfqTypeName1%>" style="border:none;font-family:Tahoma,Georgia;font-size:13px" <%=v_normal_inactive_flag%>><%=rfqTypeName1%>
										&nbsp;&nbsp;&nbsp;&nbsp;
										<input type="radio" name="rfqtype" value="<%=rfqTypeName2%>"  style="border:none;font-family:Tahoma,Georgia;font-size:13px"><%=rfqTypeName2%>
									</td>
								</tr>
								<tr>
									<td align="right">Upload File：</td>
									<td width="85%" ><INPUT TYPE="FILE" style="font-family:Tahoma,Georgia;font-size:13px" NAME="UPLOADFILE" size="90"></td>
								</tr>
								<tr>
									<td align="right">Sample File：</td>
									<td width="85%" ><A HREF="../jsp/samplefiles/D4-017_SampleFile.xls"><font style="font-size:13px;">Download Sample File</font></A></td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" title="請按我，謝謝!" align="center">
							<input type="button" style="font-size:13px;font-family: Tahoma,Georgia;" name="submit1" value='Upload' onClick="setCreate('../jsp/TSCCK3ToRFQUpload.jsp?ACTIONCODE=UPLOAD')">
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
									<td bgcolor="<%=bkcolor%>" width="15%" height="20" align="center" style="border-color:#CAE1CF;border:insert;font-size:13px"><a href="../jsp/TSCCK3ToRFQUpload.jsp?ACTIONCODE=DETAIL" style="font-size:13px;text-decoration:none;">Pending Detail</a></td>
									<td bgcolor="#CAE1CF" width="15%" align="center"><a href="../jsp/TSCCK3ToRFQUpload.jsp" style="color:888888;font-size:13px;text-decoration:none;">Excel Upload</a></td>
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
				dateBean.setAdjDate(-14);
				String strLimitDate = dateBean.getYearMonthDay();
				dateBean.setAdjDate(7);
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
					cs1.setString(1,"325");  // 取業務員隸屬ParOrgID
					cs1.execute();
					cs1.close();

					sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
							" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
							" ,(select * from oraddman.tssales_area where SALES_AREA_NO in ('012','022')) d"+
							" where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
							" and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
							" and a.STATUS = b.STATUS "+
							" and a.ORG_ID = b.ORG_ID "+
							" and a.ORG_ID = d.PAR_ORG_ID"+
							" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+
							" and c.STATUS='A'"+
							" order by c.customer_id";
					Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					ResultSet rsi = statements.executeQuery(sql);

					cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
					cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
					cs1.execute();
					cs1.close();

					sql = "	SELECT distinct c.customer_id,c.customer_number,c.CUSTOMER_NAME_PHONETIC"+
							" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
							" ,(select * from oraddman.tssales_area where SALES_AREA_NO in ('002')) d"+
							" where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
							" and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
							" and a.STATUS = b.STATUS "+
							" and a.ORG_ID = b.ORG_ID "+
							" and a.ORG_ID = d.PAR_ORG_ID"+
							" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+
							" and c.STATUS='A'"+
							" order by c.customer_id";
					Statement statemento=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
					ResultSet rso = statemento.executeQuery(sql);

					//出貨方式list
					Statement statet=con.createStatement();
					sql = "select a.SHIPPING_METHOD_CODE ,a.SHIPPING_METHOD from ASO_I_SHIPPING_METHODS_V a ";
					ResultSet rst=statet.executeQuery(sql);
					while (rst.next())
					{
						ShippingMethodList += (rst.getString("SHIPPING_METHOD")+"@"+rst.getString("SHIPPING_METHOD_CODE")+";");
					}

					//FOB list
					sql = "select distinct a.FOB_CODE from OE_FOBS_ACTIVE_V a ";
					rst=statet.executeQuery(sql);
					while (rst.next())
					{
						FOBList += (rst.getString("FOB_CODE")+";");
					}

					//BI REGION
					sql = "select distinct a.A_VALUE from oraddman.tsc_rfq_setup a WHERE A_CODE='BI_REGION'";
					rst=statet.executeQuery(sql);
					while (rst.next())
					{
						BIRegionList += (rst.getString("A_VALUE")+";");
					}

					String uploadFilePath="\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\D4016_"+strDateTime+"-"+uploadFile_name;
					upload_file.saveAs(uploadFilePath);
					java.util.Date datetime = new java.util.Date();
					SimpleDateFormat formatter = new SimpleDateFormat ("yyyy-MM-dd");
					String CreationDate = (String) formatter.format( datetime );
					InputStream is = new FileInputStream(uploadFilePath);
					jxl.Workbook wb = Workbook.getWorkbook(is);
					jxl.Sheet sht = wb.getSheet(0);

					arrayRFQDocumentInputBean.setArrayString(oneDArray);
					aa = new String[sht.getRows()-sRow][oneDArray.length];
					//out.println("aa="+aa.length);

					//line detail
					for (int i = sRow; i < sht.getRows(); i++)
					{
						strCustNo="";strEndCust ="";strEndCustID ="";strEndCustSName="";

						//K3單據號碼
						jxl.Cell cellCol1 = sht.getCell(1,i);
						strK3OrderNo = cellCol1.getContents().trim();
						if (strK3OrderNo==null || strK3OrderNo.equals("")) continue;

						//K3單據行號
						jxl.Cell cellCol2 = sht.getCell(2, i);
						strK3OrderLineNo = (cellCol2.getContents()).trim();

						//客戶PO
						jxl.Cell cellCol3 = sht.getCell(3,i);
						strLineCustPO = cellCol3.getContents();
						strLineCustPO=strLineCustPO.replace("'",""); //add by Peggy 20220323
						strLineCustPO=strLineCustPO.replace("（","(").replace("）",")");  //add by Peggy 20211229
						strLineCustPO=strLineCustPO.replace("\n","");  //add by Peggy 20240515

						//台半料號
						jxl.Cell cellCol4 = sht.getCell(4, i);
						strItemName = (cellCol4.getContents()).trim();

						//台半品名
						jxl.Cell cellCol5 = sht.getCell(5, i);
						strItemDesc = (cellCol5.getContents());
						if (strItemDesc == null) strItemDesc= "";

						//客戶品號
						jxl.Cell cellCol6 = sht.getCell(6, i);
						strCustItem = (cellCol6.getContents());
						if (strCustItem == null) strCustItem= "";
						strCustItem=strCustItem.replace("'",""); //add by Peggy 20220323

						//CRD
						jxl.Cell cellColCRD = sht.getCell(7, i);
						if (cellColCRD.getType() == CellType.DATE)
						{
							strCRD =sy1.format(((DateCell)cellColCRD).getDate());
						}
						else
						{
							strCRD= (cellColCRD.getContents()).trim();
						}
						if (strCRD != null) strCRD=strCRD.replace("-","/");
						String  arrayDate[]=strCRD.split("/");

						//SSD
						jxl.Cell cellCol7 = sht.getCell(8, i);
						if (cellCol7.getType() == CellType.DATE)
						{
							strSSD =sy1.format(((DateCell)cellCol7).getDate());
						}
						else
						{
							strSSD= (cellCol7.getContents()).trim();
						}
						if (strSSD != null & !strSSD.equals(""))
						{
							strSSD=strSSD.replace("-","/");
						}
						else
						{
							strSSD=strCRD;  //add by Peggy 20190823
						}
						String  arrayDate1[]=strSSD.split("/");

						//數量
						jxl.Cell cellCol8 = sht.getCell(9, i);
						if (cellCol8.getType() == CellType.NUMBER)
						{
							strQty = ""+((NumberCell) cellCol8).getValue();
						}
						else strQty = (cellCol8.getContents()).trim();
						if (strQty == null) strQty="0";

						//單位
						jxl.Cell cellCol9 = sht.getCell(10, i);
						strUom = (cellCol9.getContents()).trim();
						if (strUom == null) strUom= "";

						//單價
						jxl.Cell cellCol10 = sht.getCell(11, i);
						if (cellCol10.getType() == CellType.NUMBER)
						{
							strSellingPrice = ""+((NumberCell) cellCol10).getValue();
						}
						else strSellingPrice = (cellCol10.getContents()).trim();
						if (strSellingPrice == null) strSellingPrice="0";

						//K3客戶代碼
						jxl.Cell cellCol11 = sht.getCell(13, i);
						strK3CustCode = (cellCol11.getContents()).trim();
						if (strK3CustCode == null) strK3CustCode= "";

						//K3備註
						jxl.Cell cellCol111 = sht.getCell(15, i);
						strK3Remarks = (cellCol111.getContents()).trim();
						if (strK3Remarks == null) strK3Remarks= "";

						//樣品
						jxl.Cell cellCol12 = sht.getCell(17, i);
						strSampleOrder = (cellCol12.getContents()).trim();
						if (strSampleOrder == null) strSampleOrder= "";
						strSampleOrder=strSampleOrder.toUpperCase();

						//K3優先送貨地址代碼
						jxl.Cell cellCol13 = sht.getCell(20, i);
						strK3AddrCode = (cellCol13.getContents()).trim();
						if (strK3AddrCode==null) strK3AddrCode="";

						//bi region
						jxl.Cell cellCol14= sht.getCell(23, i);
						strBIRegion = (cellCol14.getContents()).trim();

						strErr ="";strCustID="";strCustName="";strItemID="";rec_cnt=0;strFactory="";strOrderType="";strOrderTypeID="";strEndCust1="";strEndCustShipTo=""; //初始化

						if (strK3OrderNo.equals(""))
						{
							strErr += "K3單據編號不可空白<br>";
						}

						if (strK3OrderLineNo.equals(""))
						{
							strErr += "K3單據編號項次不可空白<br>";
						}

						//檢查K3單據編號是否有待處理資料
						if (strK3OrderNo != null && !strK3OrderNo.equals("") && strK3OrderLineNo !=null && !strK3OrderLineNo.equals(""))
						{
							Statement statementa=con.createStatement();
							ResultSet rsa=statementa.executeQuery("select 1 from oraddman.TSC_RFQ_UPLOAD_TEMP where K3_ORDER_NO = '"+strK3OrderNo+"'  and K3_ORDER_LINE_NO ='"+strK3OrderLineNo+"' AND CREATE_FLAG IN ('N','Y')");
							if(rsa.next())
							{
								strErr += "K3單據編號:"+strK3OrderNo+"  K3單據編號項次:"+strK3OrderLineNo+"已存在,不可重複上傳!<br>";
							}
							rsa.close();
							statementa.close();

							//add by Peggy 20231229
							if (aa!=null)
							{
								for (int k=0 ; k <aa.length; k++)
								{
									if (aa[k][27]!=null && aa[k][28]!=null && aa[k][27].equals(strK3OrderNo) && aa[k][28].equals(strK3OrderLineNo))
									{
										strErr += "K3單據編號:"+strK3OrderNo+"  K3單據編號項次:"+strK3OrderLineNo+"重複申請!<br>";
									}
								}
							}
						}

						//台半料號
						//if (strItemName == null || strItemName.equals(""))
						//{
						//	strErr += "台半料號不可空白<br>";
						//}
						//else
						if ((strItemName != null && !strItemName.equals("")) || (strItemDesc!=null && !strItemDesc.equals("")))
						{
							sql = " SELECT msi.description"+
									",msi.segment1"+
									",msi.inventory_item_id"+
									",msi.primary_uom_code"+
									",NVL (case when msi.description in ('SFAF1608G C0','SFAF808G C0','SFAF508G C0','SFAF2008G C0','SFF1006G C0','SFF1006G C0G') then '002' when instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','A01')>0 then '010' when instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','YEW')>0 then '002' else msi.attribute3 end, 'N/A') attribute3,"+
									//" case msi.attribute3 when '002' then case '"+strSampleOrder +"' when 'Y' then '4121' else '4131' end else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.attribute3) end  AS order_type"+
									" case when msi.attribute3 in ('002','005','008') and instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','A01')>0 then '1141' "+ //add by Peggy 20201016
									" when msi.attribute3 in ('010') and instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','YEW')>0 then '4131'" + //add by Peggy 20210616
									" when msi.attribute3 in ('005') then case when nvl((select 'Y' from oraddman.tssg_vendor_tw_parts tvtp  where msi.description=tvtp.part_name or tsc_get_item_desc_nopacking(43 ,msi.inventory_item_id)=tvtp.part_name),'N')='N' then  case when '"+ strSampleOrder+"'='Y' then '8121' else '8131' end else '1141' end"+ //add by Peggy 20200221
									//" when (msi.attribute3='002' and instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','TEW')<=0) or msi.description in ('SFAF1608G C0','SFAF808G C0','SFAF508G C0','SFAF2008G C0','SFF1006G C0','SFF1006G C0G') then case '"+strSampleOrder +"' when 'Y' then '4121' else '4131' end "+
									" when (msi.attribute3='002' and (instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','TEW')<=0 and instr('"+(strK3Remarks.equals("")?"0XDKA":strK3Remarks)+"','A01')<=0)) or msi.description in ('SFAF1608G C0','SFAF808G C0','SFAF508G C0','SFAF2008G C0','SFF1006G C0','SFF1006G C0G') then case '"+strSampleOrder +"' when 'Y' then '4121' else '4131' end "+
									" when msi.attribute3 in ('008') or instr('"+strK3Remarks+"','TEW')>0 then  case when '"+ strSampleOrder+"'='Y' then '8121' else '8131' end "+ //add by Peggy 20190918
									"when msi.attribute3 in ('011') and msi.description in (\n" +
									" 'TSM4925DCS RLG','TSM4953DCS RLG','TSM4936DCS RLG','TSM2302CX RFG','TSM2305CX RFG','TSM2306CX RFG','TSM2307CX RFG','TSM2308CX RFG','TSM2312CX RFG',\n" +
									" 'TSM2314CX RFG','TSM2318CX RFG','TSM2323CX RFG','TSM2328CX RFG','TSM9409CS RLG','TSM3443CX6 RFG','TSM3481CX6 RFG','TSM3457CX6 RFG','TSM3911DCX6 RFG') then '8131'\n" +
									" else tsc_rfq_create_erp_odr_pkg.tsc_get_order_type (msi.inventory_item_id) end  AS order_type"+
									//", count(1) over (partition by msi.description) row_cnt"+
									", count(1) over (partition by msi.description,length(msi.segment1)) row_cnt"+ //加上22D或30D筆數,add by Peggy 20230621
									",tsc_inv_category(msi.inventory_item_id,msi.organization_id,'1100000003') tsc_prod_group"+
									" FROM  inv.mtl_system_items_b msi"+
									" WHERE msi.organization_id=49"+
									" AND msi.inventory_item_status_code <> 'Inactive'"+
									" AND NVL(msi.CUSTOMER_ORDER_FLAG,'N')='Y'"+
									" AND NVL(msi.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+
									" AND tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'"+  //add by Peggy 20230118
									" AND (length(msi.segment1)=22 or (length(msi.segment1)=30 and exists (select 1 from oraddman.tscc_k3_cust tkc where tkc.CUST_CODE='"+strK3CustCode+"' and nvl(tkc.CUST_ITEM_CODE,'F00') LIKE '%'|| substr(msi.segment1,-3)||'%')))";
							if (strItemDesc != null && !strItemDesc.equals(""))
							{
								sql +=  " AND msi.description =  '"+strItemDesc+"'";
							}
							if (strItemName != null && !strItemName.equals(""))
							{
								sql += " and msi.segment1 = '"+strItemName+"'";
							}

							sql +=  "AND SUBSTR(msi.segment1, -4) <> 'AF00'\n" +
									"         AND (\n" +
									"                ( TSC_INV_CATEGORY(msi.inventory_item_id, 43, 23)\n" +
									"                    IN ('SMA','SMB','SMC','SOD-123W','SOD-128')\n" +
									"                  AND tsc_get_item_coo(msi.inventory_item_id) = 'CN'\n" +
									"                )\n" +
									"                OR TSC_INV_CATEGORY(msi.inventory_item_id, 43, 23)\n" +
									"                    NOT IN ('SMA','SMB','SMC','SOD-123W','SOD-128')\n" +
									"             )";
							sql += " order by length(msi.segment1) desc,msi.segment1"; //30D優先 by Peggy 20230621
							//out.println(sql);
							Statement statement=con.createStatement();
							ResultSet rs = statement.executeQuery(sql);
							if(rs.next())
							{
								if (rs.getInt("row_cnt")>1 && !strK3CustCode.equals("001.0399"))  //上海禾馥有顆valeo料要下FA6,那顆料沒有F00,其他料一律下F00 BY PEGGY 20230630
								{
									strErr +="品名對應兩筆以上的料號,請指定料號<br>";
									strItemID ="";

								}
								else
								{
									strItemName = rs.getString("segment1");
									strItemID = rs.getString("INVENTORY_ITEM_ID");
									strItemDesc = rs.getString("description");
									strFactory = rs.getString("ATTRIBUTE3");
									strOrderType = rs.getString("ORDER_TYPE");

									//add by Peggy 20200522,YBS3007 RAG&"BAV21W-G RHG不可下內銷訂單,統籌以外銷下單,取得優惠採購價格
									//if (strOrderType.equals("8131") && (strItemDesc.equ`als("YBS3007G RAG") || strItemDesc.equals("BAV21W-G RHG")))
									//if (strOrderType.equals("8131") && (strItemDesc.equals("BAV21W-G RHG"))) //YBS3007G RAG不統一下單 from ava modify by Peggy 20201111
									//{
									//	strErr +=strItemDesc+"統一下外銷訂單,以取得優惠採購價<br>";
									//}

									if (strOrderType.substring(0,1).equals("4"))
									{
										strCustNo="7883";  //上海瀚科國際貿易有限公司
										if (strOrderType.equals("4121"))
										{
											SalesAreaNo="022";
										}
										else
										{
											SalesAreaNo="012";
										}
										v_org_id=325;
									}
									else if (strOrderType.substring(0,1).equals("1"))
									{
										strCustNo="8103";  //SHANGHAI GREAT TECHNOLOGY TRADING CO.LTD.
										SalesAreaNo="002";
										v_org_id=41;
									}
									else if (strOrderType.substring(0,1).equals("8"))  //add by Peggy 20190918
									{
										SalesAreaNo="023";
										if (rs.getString("tsc_prod_group").equals("SSD"))
										{
											strFactory ="005";
										}
										else if (rs.getString("tsc_prod_group").indexOf("PRD")>=0)
										{
											strFactory ="008";
										}
										v_org_id=906;
									}
									else
									{
										strErr +="未經定義的訂單類型<br>";
									}

								}
							}
							else
							{
								strErr +="ERP未定義台半料號:"+strItemName+"<br>";
							}
							rs.close();
							statement.close();

							if (!strItemID.equals(""))
							{
								cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
								cs1.setString(1,""+v_org_id);  // 取業務員隸屬ParOrgID
								cs1.execute();
								cs1.close();


								//檢查優先送貨地址
								strEndCustID1="";strEndCustShipTo="";strSGShipTo="";
								if (!strK3AddrCode.equals(""))
								{
									sql = " SELECT erp_ship_to_location_id,erp_customer_id,sg_ship_to_location_id,cust_eng_short_name  FROM oraddman.tscc_k3_addr_link_erp a"+
											" WHERE  a.addr_code='"+strK3AddrCode+"'";
									//out.println(sql);
									statement=con.createStatement();
									rs = statement.executeQuery(sql);
									if(!rs.next())
									{
										strErr +="未定義K3送貨地址與ERP地址link<br>";
										strEndCustShipTo="";strEndCustID1="";strSGShipTo="";
									}
									else
									{
										strEndCustShipTo = rs.getString("erp_ship_to_location_id");
										strEndCustID1 = rs.getString("erp_customer_id");
										strSGShipTo = rs.getString("sg_ship_to_location_id"); //add by Peggy 20200330
										strEndCustSName = rs.getString("cust_eng_short_name"); //add by Peggy 20240408
										if (strEndCustSName==null) strEndCustSName="";

									}
								}

								//檢查K3客戶代碼
								if (!strK3CustCode.equals(""))
								{
									sql = " SELECT b.customer_name,b.customer_number,b.customer_id,a.cust_eng_short_name "+
											" FROM oraddman.tscc_k3_cust_link_erp a,ar_customers b"+
											" WHERE a.active_flag='A'"+
											" and a.cust_code='"+strK3CustCode+"'"+
											" and a.erp_cust_number=b.customer_number";
									if (!strOrderType.substring(0,1).equals("1") && !strOrderType.substring(0,1).equals("8") && !strEndCustID1.equals(""))
									{
										sql += " and b.customer_id="+strEndCustID1+"";
									}
									sql += " order by decode(a.erp_cust_number,'20971',1,2)";
									//out.println(sql);
									statement=con.createStatement();
									rs = statement.executeQuery(sql);
									if(!rs.next())
									{
										strErr +="未定義K3客戶與ERP客戶link<br>";
										strEndCust ="";strEndCustID ="";strEndCustSName="";
									}
									else
									{
										if (!strOrderType.substring(0,1).equals("8"))  //add by Peggy 20190918
										{
											strEndCust = rs.getString("customer_name");
											strEndCustID = rs.getString("customer_number");
											if (strEndCustSName==null || strEndCustSName.equals("")) //add by Peggy 20240408
											{
												strEndCustSName = rs.getString("cust_eng_short_name"); //add by Peggy 20211229
											}
											if (strEndCustSName==null || strEndCustSName.equals(""))
											{
												strErr +="未定義K3客戶英文簡稱<br>";
											}
										}
										else
										{
											strCustNo=rs.getString("customer_number");
											strEndCust="";strEndCustID="";strEndCustSName="";
										}
									}
									rs.close();
									statement.close();
								}
								else
								{
									strErr +="客戶代碼不可空白<br>";
								}

								strShippingMethod="";strFOB="";strShipTo="";strPriceList="";;
								Statement statementa=con.createStatement();
								ResultSet rsa=statementa.executeQuery("select CUSTOMER_ID,CUSTOMER_NAME from ar_CUSTOMERS where status = 'A' and CUSTOMER_NUMBER ='"+strCustNo+"'");
								if(rsa.next())
								{
									strCustID = rsa.getString("CUSTOMER_ID");
									strCustName=rsa.getString("CUSTOMER_NAME");


									sql = " select 1 as segno,"+
											" a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
											" a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE"+
											" ,a.tax_code" +
											" from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
											" ,SO_PRICE_LISTS d"+
											" where  a.ADDRESS_ID = b.cust_acct_site_id"+
											" AND b.party_site_id = party_site.party_site_id"+
											" AND loc.location_id = party_site.location_id "+
											" and a.STATUS='A' "+
											" and a.site_use_code='SHIP_TO'"+
											" and b.CUST_ACCOUNT_ID ='"+strCustID+"'";
									//if (strOrderType.substring(0,1).equals("4") && strK3AddrCode.equals(""))
									//{
									//	sql += " and a.SITE_USE_ID="+strEndCustShipTo +"";
									//}
									if (strOrderType.substring(0,1).equals("8") && !strSGShipTo.equals("")) //add by Peggy 20200330
									{
										sql+=" and a.location='"+strSGShipTo+"'";
									}
									sql += " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
											" and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)"+
											" order by decode(a.PRIMARY_FLAG,'Y',1,2), a.SITE_USE_ID";
									//out.println(sql);
									Statement statementb=con.createStatement();
									ResultSet rsb=statementb.executeQuery(sql);
									while (rsb.next())
									{
										if (strShipTo==null || strShipTo.equals(""))
										{
											strShipTo=rsb.getString("SITE_USE_ID");
										}
										if ((strShippingMethod ==null || strShippingMethod.equals("")) && rsb.getString("ship_via") != null)
										{
											strShippingMethod = rsb.getString("ship_via");
										}
										if ((strFOB==null || strFOB.equals("")) && rsb.getString("FOB_POINT")!= null)
										{
											strFOB  = rsb.getString("FOB_POINT");
										}
										if ((strPriceList==null || strPriceList.equals("")) && rsb.getString("PRICE_LIST_ID")!= null)  //add by Peggy 20200215
										{
											strPriceList = rsb.getString("PRICE_LIST_ID");
										}
									}
									rsb.close();
									statementb.close();
								}
								else
								{
									strErr += "客戶資訊未定義在ERP<br>";
								}
								rsa.close();
								statementa.close();

								cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
								cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
								cs1.execute();
								cs1.close();

								if (strCustItem != null && !strCustItem.equals(""))
								{
									sql = " select  a.item"+
											" from oe_items_v a,inv.mtl_system_items_b msi "+
											" where a.SOLD_TO_ORG_ID = '"+strCustID+"' "+
											" and a.organization_id = msi.organization_id"+
											" and a.inventory_item_id = msi.inventory_item_id"+
											" and msi.ORGANIZATION_ID = '49'"+
											" and a.CROSS_REF_STATUS='ACTIVE'"+
											" and msi.inventory_item_status_code <> 'Inactive'"+
											" and a.ITEM = '"+strCustItem+"'"+
											" and tsc_item_pcn_flag(43,msi.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230118
									if (strItemDesc != null && !strItemDesc.equals(""))
									{
										sql += " and msi.DESCRIPTION = '"+strItemDesc+"'";
									}
									if (strItemName != null && !strItemName.equals(""))
									{
										sql += " and a.INVENTORY_ITEM = '"+strItemName+"'";
									}
									//out.println(sql);
									statement=con.createStatement();
									rs = statement.executeQuery(sql);
									if (!rs.next())
									{
										strErr +="ERP未定義客戶品號:"+strCustItem+"<br>";
									}
									rs.close();
									statement.close();
								}

								//customer po
								if (strLineCustPO==null || strLineCustPO.equals(""))
								{
									strErr += "Customer PO不可空白<br>";
								}
								else if (strLineCustPO.indexOf("(")>0)
								{
									if (!strOrderType.substring(0,1).equals("1"))
									{
										//strEndCust1 = strLineCustPO.substring(strLineCustPO.indexOf("(")+1,strLineCustPO.lastIndexOf(")"));
										//strLineCustPO = strLineCustPO.substring(0,strLineCustPO.indexOf("("));
										strEndCust1 = strLineCustPO.substring(strLineCustPO.lastIndexOf("(")+1,strLineCustPO.lastIndexOf(")")); //modify Peggy 20211229
										strLineCustPO = strLineCustPO.substring(0,strLineCustPO.lastIndexOf("("));	//modify Peggy 20211229
									}
									else
									{
										if (strCustNo.equals("8103")) //po後面的終端客戶由K3客代帶出,ADD BY PEGGY 20211229
										{
											strLineCustPO = strLineCustPO.substring(0,strLineCustPO.lastIndexOf("("));	//modify Peggy 20211229
										}
										else
										{
											strEndCust1 ="";
										}
									}
								}

								//檢查訂單類型是否正確
								Statement stateodrtype=con.createStatement();
								sql = "SELECT  a.otype_id FROM oraddman.tsarea_ordercls a,oraddman.tsprod_ordertype b"+
										" where b.order_num=a.order_num and a.order_num='"+strOrderType+"'"+
										" and a.SAREA_NO ='"+SalesAreaNo+"' and a.active='Y'"+
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


								//出貨方式
								if (strShippingMethod == null || strShippingMethod.equals(""))
								{
									//	strShippingMethod = "&nbsp;";
									//	strErr +="出貨方式不可空白<br>";
								}
								else
								{
									boolean bolExist = false;
									String [] strarray= ShippingMethodList.split(";");
									for (int x = 0 ; x < strarray.length ; x++)
									{
										String [] strd = strarray[x].split("@");
										if (strShippingMethod.equals(strd[0]) || strShippingMethod.equals(strd[1]))
										{
											bolExist = true;
											strShippingMethod = strd[1];
										}
									}
									if (!bolExist) strErr +="出貨方式不存在<br>";
								}

								//FOB
								if (strFOB == null || strFOB.equals(""))
								{
									//strFOB = "&nbsp;";
									//strErr += "FOB不可空白<br>";
								}
								else
								{
									boolean bolExist = false;
									String [] strarray= FOBList.split(";");
									for (int x = 0 ; x < strarray.length ; x++)
									{
										if (strFOB.equals(strarray[x]))
										{
											bolExist = true;
										}
									}
									if (!bolExist) strErr += "FOB不存在<br>";
								}

								//END CUSTOMER
								strEndCust="";strEndCustID1="";
								if (!strEndCustID.equals(""))
								{
									//end customer id不可與customer id相同
									if (strEndCustID.equals(strCustNo))
									{
										if (strOrderType.equals("4121"))
										{
											strEndCustID="";
										}
										else
										{
											strErr += "End Customer ID不可與Customer ID相同<br>";
										}
									}
									else
									{
										if (strOrderType.substring(0,1).equals("4"))
										{
											if (rsi.isBeforeFirst() ==false) rsi.beforeFirst();
											while (rsi.next())
											{
												if (rsi.getString("customer_number").equals(strEndCustID))
												{
													strEndCust = rsi.getString("CUSTOMER_NAME_PHONETIC");
													strEndCustID1 =""+rsi.getInt("customer_id");
													break;
												}
											}
										}
										else
										{
											if (rso.isBeforeFirst() ==false) rso.beforeFirst();
											while (rso.next())
											{
												if (rso.getString("customer_number").equals(strEndCustID))
												{
													strEndCust = rso.getString("CUSTOMER_NAME_PHONETIC");
													strEndCustID1 =""+rso.getInt("customer_id");
													break;
												}
											}
										}

										if (StringUtils.isNullOrEmpty(strEndCust))
										{
											sql =" SELECT  c.customer_id,c.ACCOUNT_NUMBER customer_number,c.CUSTOMER_SNAME CUSTOMER_NAME_PHONETIC  "+
													//" FROM ar_customers a,ar.hz_cust_acct_relate_all b,ar_customers c"+
													" FROM TSC_CUSTOMER_ALL_V a,ar.hz_cust_acct_relate_all b,TSC_CUSTOMER_ALL_V c"+  //modify by Peggy 20230706
													" where a.customer_id=b.RELATED_CUST_ACCOUNT_ID"+
													" and b.STATUS ='A'"+
													" and a.ACCOUNT_NUMBER="+strCustNo+""+
													" and b.cust_account_id=c.customer_id"+
													" and c.ACCOUNT_NUMBER="+strEndCustID+"";
											Statement statementy=con.createStatement();
											ResultSet rsy=statementy.executeQuery(sql);
											if (rsy.next())
											{
												strEndCust = rsy.getString("CUSTOMER_NAME_PHONETIC");
												strEndCustID1 =""+rsy.getInt("customer_id");
											}
											rsy.close();
											statementy.close();
											if (strEndCust.equals("")) strErr += "End Customer ID不存在ERP<br>";
										}
									}
								}
							}
						}

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
									if (strUom.equals("PCS")) qtynum=qtynum/1000;
									strQty=(new DecimalFormat("#######0.0#")).format(qtynum);
								}
							}
							catch (Exception e)
							{
								strErr += "數量格式錯誤<br>";
							}
						}

						//檢查單位,必須為PCS for Ava,add by Peggy 20191214
						if (!strUom.equals("PCS") && !strUom.equals("KPC") && !strUom.equals("K"))
						{
							strErr +="單位錯誤<br>";
						}

						//單價
						if (strSellingPrice == null || strSellingPrice.equals(""))
						{
							strSellingPrice = "";
							strErr +="Selling Price不可空白<br>";
						}
						else
						{
							try
							{
								double pricenum = Double.parseDouble(strSellingPrice.replace(",",""));
								if ( pricenum < 0  )
								{
									strErr += "Selling Price必須大於等於零<br>";
								}
								else if (!strSampleOrder.equals("Y") &&  pricenum==0)
								{
									strErr += "Selling Price必須大於零<br>";
								}
								else if (pricenum>0)
								{
									strSellingPrice =(new DecimalFormat("###,##0.000##")).format(pricenum);

									//檢查8131訂單價格是否符合客戶價格,add by Peggy 20200215
									if (strOrderType.substring(0,1).equals("8"))
									{
										sql = " SELECT TP_PRICE,TP_PRICE_UOM  FROM TABLE(TSC_ORDER_REVISE_PKG.GET_ITEM_TARGET_PRICE_NEW(907,"+strItemID+",'PCE',"+strPriceList+",TRUNC(SYSDATE),'CNY',null,"+strCustID+"))";
										Statement statementx=con.createStatement();
										//out.println(sql);
										ResultSet rsx=statementx.executeQuery(sql);
										if (rsx.next())
										{
											if (Float.parseFloat(strSellingPrice)!=rsx.getFloat("TP_PRICE"))
											{
												strErr += "訂單價格("+strSellingPrice+")與客戶價格("+rsx.getFloat("TP_PRICE")+")不符<br>";
											}
										}
										else
										{
											strErr += "客戶價格未設定<br>";
										}
										rsx.close();
										statementx.close();
									}
								}
							}
							catch (Exception e)
							{
								strErr += "單價格式錯誤<br>";
							}
						}

						//交貨日期
						if (arrayDate1.length !=3)
						{
							strErr +="SSD:"+strSSD+"格式錯誤<br>";
						}
						else
						{
							v_Year = Integer.parseInt(arrayDate1[0]);
							v_Month =Integer.parseInt(arrayDate1[1]);
							v_Days =Integer.parseInt(arrayDate1[2]);
							if ((""+v_Year).length() !=4)
							{
								strErr +="SSD:"+strSSD+"格式錯誤<br>";
							}
							else if (v_Month <1 && v_Month>12)
							{
								strErr +="SSD:"+strSSD+"格式錯誤<br>";
							}
							else if	(v_Days <1  || v_Days >31)
							{
								strErr +="SSD:"+strSSD+"格式錯誤<br>";
							}
							strSSD = v_Year+("0"+v_Month).substring(("0"+v_Month).length()-2)+("0"+v_Days).substring(("0"+v_Days).length()-2);
						}

						if (strSSD == null || strSSD.equals(""))
						{
							strSSD = "";
							strErr +="SSD不可空白<br>";
						}
						else if (Long.parseLong(strSSD) <= Long.parseLong(strLimitDate))  //sansan說交期小於系統日-7要卡,by Peggy 20230424 add
						{
							strErr +="SSD:"+strSSD+"必須大於"+strCHKDate+"<br>";
						}
						else if (Long.parseLong(strSSD) <= Long.parseLong(strCHKDate))
						{
							strSSD=strCHKDate; //直接更新 BY Peggy 20221209
						}

						if (strBIRegion ==null || strBIRegion.equals(""))
						{
							strErr += "BI Region不可空白<br>";
						}
						else
						{
							boolean bolExist = false;
							String [] strarray= BIRegionList.split(";");
							for (int x = 0 ; x < strarray.length ; x++)
							{
								if (strBIRegion.equals(strarray[x]))
								{
									bolExist = true;
								}
							}
							if (!bolExist) strErr +=  "BI Region必須為"+BIRegionList.replace(";","或")+"<br>";
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
							strErr +="Line Type代碼不可空白<br>";
						}
						rs1.close();
						state1.close();

						//add by Peggy 20230116
						strLineRemark="";
						if (strCustID.equals("445296") || strEndCustID1.equals("445296"))  //青島上泰電子有限公司
						{
							//if (strItemDesc.equals("MMBD4148CC-01 RFG") || strItemDesc.equals("MMBD4148CA-01 RFG") || strItemDesc.equals("BZT52B3V9-01 RHG") || strItemDesc.equals("BZT52B3V9S-01 RRG") || strItemDesc.equals("BZX84C11-01 RF") || strItemDesc.equals("BZX84C3V9-01 RF"))
							if (strItemDesc.equals("MMBD4148CC-01 RFG") || strItemDesc.equals("MMBD4148CA-01 RFG") || strItemDesc.equals("BZT52B3V9-01 RHG") || strItemDesc.equals("BZT52B3V9S-01 RRG")) //nina說取消BZX84C3V9-01 RF,BZX84C11-01 RF by Peggy 20230523
							{
								strLineRemark ="備注用金線";
							}
						}

						if (strErr.length() > 0)
						{
							if (ErrCnt ==0)
							{
	%>
	<table cellspacing="0" bordercolordark="#ffffff" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
		<tr bgcolor="#96AEBC" style="color:#ffffff;font-size:10px;">
			<td width='4%'>Customer No</td>
			<td width='7%'>Customer Name</td>
			<td width='4%'>Ship To ORG ID</td>
			<td width='3%'>RFQ Type</td>
			<td width='3%'>Order Type</td>
			<td width='7%'>Customer PO</td>
			<td width='7%'>TSC P/N</td>
			<td width='7%'>Customer P/N</td>
			<td width='5%'>Qty(KPCS)</td>
			<td width='5%'>Selling<br>Price</td>
			<td width='4%'>SSD</td>
			<td width='5%'>Shipping Method</td>
			<td width='5%'>FOB</td>
			<td width='3%'>End Cust#</td>
			<td width='6%'>End Customer</td>
			<td width='5%'>Remarks</td>
			<td width='7%'>Error<br>Message</td>
		</tr>
		<%
			}
		%>
		<tr bgcolor="#CCFFAC" style="color:#000000;font-size:11px;">
			<td><%=strCustNo%></td>
			<td><%=strCustName%></td>
			<td><%=strShipTo%></td>
			<td><%=strRFQType%></td>
			<td><%=strOrderType%></td>
			<td><%=strLineCustPO%></td>
			<td><%=strItemDesc%></td>
			<td><%=strCustItem%></td>
			<td><%=strQty%></td>
			<td><%=strSellingPrice%></td>
			<td><%=strRequestDate%></td>
			<td><%=strShippingMethod%></td>
			<td><%=strFOB%></td>
			<td><%=(strEndCustID==null ||strEndCustID.equals("")?"":strEndCustID)%></td>
			<td><%=(strEndCust==null || strEndCust.equals("")?"":strEndCust)%></td>
			<td><%=strLineRemark=Arrays.asList(customerNumberForByd).contains(strEndCustID)?"single label":strLineRemark %></td>
			<td style="color:#FF0000"><%=strErr%></td>
		</tr>
		<%
						strErr="";
						ErrCnt ++;
					}

					strCustPO="";strTempId="";
					//if (MTYPE.equals(IDTYPE))
					//{
					for (int g =0 ; g< aa.length ;g++)
					{
						if (aa[g][0] == null) continue;
						if (strCustNo.equals(aa[g][0]) && strCustID.equals(aa[g][19]) && strOrderTypeID.equals(aa[g][16]) && strShipTo.equals(aa[g][23]))
						{
							if (aa[g][3] == null) continue;
							strCustPO=aa[g][3];
							strTempId=aa[g][24];
							break;
						}
					}
					if (strCustPO ==null || strCustPO.equals("")) strCustPO=strLineCustPO;
					//}
					//else
					//{
					//	for (int g =0 ; g < aa.length  ;g++ )
					//	{
					//		if (aa[g][3]==null) continue;
					//		if (strCustNo.equals(aa[g][0]) && strShipTo.equals(aa[g][23]) && strLineCustPO.equals(aa[g][3]))
					//		{
					//			strCustPO=aa[g][3];
					//			strTempId=aa[g][24];
					//			break;
					//		}
					//	}
					//	if (strCustPO ==null || strCustPO.equals("")) strCustPO=strLineCustPO;
					//}

					if (strTempId.equals(""))
					{
						Statement statementa=con.createStatement();
						ResultSet rsa=statementa.executeQuery("select TSC_RFQ_UPLOAD_TEMP_S.nextval from dual");
						if(rsa.next())
						{
							strTempId=rsa.getString(1);
						}
						rsa.close();
						statementa.close();
					}
					aa[icnt][0]=strCustNo;
					aa[icnt][1]=strCustName;
					aa[icnt][2]=RFQ_TYPE;
					aa[icnt][3]=strCustPO;
					aa[icnt][4]=strItemDesc;
					aa[icnt][5]=strItemName;
					aa[icnt][6]=strCustItem;
					aa[icnt][7]=strFactory;
					aa[icnt][8]=strUOM;
					aa[icnt][9]=strQty;
					aa[icnt][10]=strSellingPrice;
					aa[icnt][11]=strSSD;
					aa[icnt][12]=strSSD;
					aa[icnt][13]=strShippingMethod ;
					aa[icnt][14]=(strFOB.startsWith("FOB") && strOrderTypeID.equals("1022")?"FOB TAIWAN":strFOB);
					aa[icnt][15]=Arrays.asList(customerNumberForByd).contains(strEndCustID)?"single label":strLineRemark.replace("&nbsp;","");
					aa[icnt][16]=strOrderTypeID;
					aa[icnt][17]=strLineType;
					aa[icnt][18]=strItemID;
					aa[icnt][19]=strCustID;
					aa[icnt][20]=strLineCustPO+(strCustNo.equals("8103")?"("+strEndCustSName+")":"");
					aa[icnt][21]=strEndCustID1;
					aa[icnt][22]=(strEndCust1.equals("")?strEndCust:strEndCust1);
					aa[icnt][23]=strShipTo;
					aa[icnt][24]=strTempId;
					aa[icnt][25]=strBIRegion;
					aa[icnt][26]=strK3AddrCode;
					aa[icnt][27]=strK3OrderNo;
					aa[icnt][28]=strK3OrderLineNo;
					aa[icnt][29]=SalesAreaNo;
					aa[icnt][30]=strEndCustShipTo;
					icnt++;
				}
				wb.close();
				rsi.close();
				rso.close();
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
							"SHIP_TO_ORG_ID,"+     //25
							"TEMP_ID,"+            //26
							"BI_REGION,"+          //27
							"k3_addr_code,"+       //28
							"k3_order_no,"+        //29
							"k3_order_line_no,"+    //30
							"end_customer_ship_to_org_id,"+  //31
							"PROGRAM_NAME"+                  //32
							")"+
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
							"?,"+                  //25
							"?,"+                  //26
							"?,"+                  //27
							"?,"+                  //28
							"?,"+                  //29
							"?,"+                  //30
							"?,"+                  //31
							"'D4-016')";           //32
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,aa[i][29]);          //salesareano
					pstmt.setString(2,UserName);             //upload_by
					pstmt.setString(3,aa[i][0]);             //customer_no
					pstmt.setString(4,aa[i][1]);             //customer_name
					pstmt.setString(5,aa[i][2].toUpperCase());    //rfq_type
					pstmt.setString(6,aa[i][3]);             //customer_po
					pstmt.setString(7,aa[i][18]);            //inventory_item_id
					pstmt.setString(8,(aa[i][6].equals("")?"":aa[i][6]));             //cust_item_name
					pstmt.setString(9,aa[i][9]);             //qty
					pstmt.setString(10,aa[i][10]);           //selling_price
					pstmt.setString(11,aa[i][11]);           //crd
					pstmt.setString(12,aa[i][12]);           //request_date
					pstmt.setString(13,aa[i][13]);           //shipping_method
					pstmt.setString(14,aa[i][14]);           //fob
					pstmt.setString(15,Arrays.asList(new String[]{"1040292", "1040294", "1040296", "1040298"}).contains(aa[i][21]) ? "single label" : aa[i][15]);
					pstmt.setString(16,aa[i][16]);           //order_type
					pstmt.setString(17,aa[i][17]);           //line_type
					pstmt.setString(18,"N");                 //create_flag
					pstmt.setString(19,aa[i][19]);           //customer_id
					pstmt.setString(20,aa[i][7]);            //factory
					pstmt.setString(21,aa[i][20]);           //customer po line number
					pstmt.setInt(22,(insert_cnt+1));         //line_no
					pstmt.setString(23,aa[i][21]);           //END CUSTOMER Id
					pstmt.setString(24,aa[i][22]);           //END CUSTOMER
					pstmt.setString(25,aa[i][23]);           //SHIP TO
					pstmt.setString(26,aa[i][24]);           //TEMP ID
					pstmt.setString(27,aa[i][25]);           //BI REGION
					pstmt.setString(28,aa[i][26]);           //K3 Addr Code
					pstmt.setString(29,aa[i][27]);           //K3 Order No
					pstmt.setString(30,aa[i][28]);           //k3 Order Line No
					pstmt.setString(31,aa[i][30]);           //end cust ship to
					pstmt.executeQuery();
					pstmt.close();
					insert_cnt++;
				}
				con.commit();
			}

		}
		catch(Exception e)
		{
			e.printStackTrace();
			con.rollback();
			out.println("error1:"+e.getMessage());
		}
		if (insert_cnt >0)
		{
	%>
	<script language="javascript">
		location.href("TSCCK3ToRFQUpload.jsp?ACTIONCODE=DETAIL");
	</script>

	<%
		}
	}
	else if (ACTIONCODE.equals("DETAIL"))
	{
	%>
	<table align="center" border="1" width="100%" cellspacing="0" cellpadding="1" bordercolorlight="#DFD9DD" bordercolordark="#4A598A">
		<tr style="background-color:<%=bkcolor%>;font-size:10px" >
			<td width="8%"  align="center">&nbsp;</td>
			<td width="7%" align="center">Customer Name</td>
			<td width="4%" align="center">Ship to ID</td>
			<td width="4%"  align="center">RFQ Type</td>
			<td width="4%"  align="center">Order Type</td>
			<td width="7%" align="center">Customer PO</td>
			<td width="8%" align="center">TSC P/N</td>
			<td width="8%"  align="center">Customer P/N</td>
			<td width="4%"  align="center">Qty(K)</td>
			<td width="5%"  align="center">Selling<br>Price</td>
			<td width="6%"  align="center">Request Date</td>
			<td width="6%"  align="center">Shipping Method</td>
			<td width="6%"  align="center">FOB</td>
			<td width="5%"  align="center">End Cust#</td>
			<td width="6%"  align="center">End Cust</td>
			<td width="6%" align="center">Upload By</td>
			<td width="5%" align="center">Upload Date</td>
		</tr>
		<%
			try
			{
				int i =0;
				String tempid="";
				sql = " SELECT a.temp_id,a.salesareano, to_char(a.upload_date,'yyyy/mm/dd') upload_date, a.upload_by, a.customer_no,a.customer_id,"+
						" a.customer_name, a.rfq_type, a.customer_po, b.description,"+
						" a.cust_item_name, a.qty, a.selling_price, a.crd, a.request_date,"+
						" a.shipping_method, a.fob, a.remarks,d.OTYPE_ID, d.ORDER_NUM order_type, a.line_type,a.customer_po_line_number,"+
						" (select count(1) from oraddman.tsc_rfq_upload_temp c where c.temp_id=a.temp_id and c.create_flag='N' and c.salesareano=a.salesareano and c.customer_no= a.customer_no and c.customer_po=a.customer_po and c.upload_by=a.upload_by and c.SHIP_TO_ORG_ID=a.SHIP_TO_ORG_ID) rowcnt"+
						",e.customer_number end_customer_id,end_customer,a.ship_to_org_id"+
						",a.bi_region"+
						",row_number() over (partition by a.temp_id,a.customer_id,a.order_type,a.ship_to_org_id  order by a.temp_id,SHIP_TO_ORG_ID,b.description,a.request_date) rank_seq"+
						" FROM oraddman.tsc_rfq_upload_temp a,inv.mtl_system_items_b b,ORADDMAN.TSAREA_ORDERCLS d"+
						",ar_customers e"+
						" where a.create_flag=?"+
						" and a.salesareano in ('002','012','022','023')"+
						" and b.organization_id=43"+
						" and a.inventory_item_id = b.inventory_item_id"+
						" and a.salesareano=d.SAREA_NO"+
						" and a.order_type=d.OTYPE_ID"+
						" and a.end_customer_id = e.customer_id(+)";
				if (UserRoles.indexOf("admin")<0)
				{
					sql += " and a.upload_by='"+ UserName+"'";
				}
				sql += " order by  a.temp_id,CUSTOMER_ID,ORDER_TYPE,SHIP_TO_ORG_ID,b.description,a.request_date";
				//out.println(sql);
				PreparedStatement st = con.prepareStatement(sql);
				st.setString(1,"N");
				ResultSet rs = st.executeQuery();
				while(rs.next())
				{
		%>
		<tr>
			<%
				if (!tempid.equals(rs.getString("temp_id")))
				{
					i++;
			%>
			<td id="tdq<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" align="center">
				<input type="button" name="btnRFQ<%=i%>" value="RFQ" style="font-size:11px;font-family: Tahoma,Georgia;" title="轉RFQ" onClick="toRFQ('../jsp/TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y')">
				&nbsp;
				<input type="button" name="btn<%=i%>" value="Delete" style="font-size:11px;font-family: Tahoma,Georgia;" title="刪除資料" onClick="delData('../jsp/TSCCK3ToRFQUpload.jsp?DELFLAG=Y&TEMP_ID=<%=rs.getString("TEMP_ID")%>')">
			</td>
			<td id="tda<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%="("+rs.getString("customer_no")+")"+rs.getString("customer_name")%></td>
			<td id="tdo<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("ship_to_org_id")%></td>
			<td id="tdc<%=i%>" rowspan="<%=rs.getString("rowcnt")%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("rfq_type")%></td>
			<%
					tempid=rs.getString("TEMP_ID");
				}
			%>
			<td id="tdi<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("order_type")%></td>
			<td id="tdb<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("CUSTOMER_PO_LINE_NUMBER")%></td>
			<td id="tdd<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=rs.getString("description")%></td>
			<td id="tde<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面"><%=(rs.getString("cust_item_name")==null?"":rs.getString("cust_item_name").replace("&nbsp;"," "))%></td>
			<td id="tdf<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.######")).format(rs.getDouble("qty"))%></td>
			<td id="tdg<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="right"><%=(new DecimalFormat("##,##0.######")).format(rs.getDouble("selling_price"))%></td>
			<td id="tdh<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("request_date")%></td>
			<td id="tdj<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("shipping_method")==null?"":rs.getString("shipping_method"))%></td>
			<td id="tdr<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("fob")==null?"":rs.getString("fob"))%></td>
			<td id="tdm<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer_id")==null?"":rs.getString("end_customer_id"))%></td>
			<td id="tdk<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=(rs.getString("end_customer")==null?"":rs.getString("end_customer"))%></td>
			<td id="tdl<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("upload_by")%></td>
			<td id="tdn<%=i%>" onMouseOver="focuscolor(<%=i%>)" onMouseOut="unfocuscolor(<%=i%>)" style="color:#000000;font-size:11px" onClick="javascript:location.href='TSCCK3ToRFQUpload.jsp?TEMP_ID=<%=rs.getString("TEMP_ID")%>&INSERTFLAG=Y'" title="按下滑鼠左鍵,進入Detail畫面" align="center"><%=rs.getString("upload_date")%></td>
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
