<!-- 20140820 by Peggy,新增ERP END CUSTOMER ID欄位-->
<!-- 20150519 by Peggy,add column "tsch orderl line id" for tsch case-->
<!-- 20151008 by Peggy,mtl_system_items_b加入CUSTOMER_ORDER_FLAG=Y AND CUSTOMER_ORDER_ENABLED_FLAG=Y判斷-->
<!-- 20151202 by Peggy,H CODE型號判斷-->
<!-- 20160512 by Peggy,型號不存在者,顯示error,提示使用者-->
<!-- 20160929 by Peggy,add customer p/n-->
<!-- 20161024 by Peggy,TSCJ要求SFAF508G C0轉下給YEW生產-->
<!-- 20161107 by Peggy,新增22D欄位-->
<!-- 20180703 by Peggy,下S1JM-02HRSG且EndCustomer=SWS或IMASEN,自動綁定這個22D#8001-031RS211JM0000002-->
<!-- 20200113 by Peggy,檢查出貨方式是否合法-->
<%@ page contentType="text/html; charset=big5" language="java" import="java.util.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,java.lang.*" %>
<jsp:useBean id="myUpload" scope="page" class="com.jspsmart.upload.SmartUpload" />
<!--%@ page contentType="text/html; charset=big5" language="java" %-->
<%@ page import="java.net.*" %>
<%@ page import="java.text.*" %>
<%@ page import="jxl.*" %>
<%@ page import="java.lang.*" %>
<%@ page import="java.io.File.*"%>
<%@ page import="DateBean,Array2DimensionInputBean"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
	//add by Peggy 20120223
	function subWindowPayTermFind(primaryFlag)
	{
		subWin=window.open("../jsp/subwindow/TSDRQPaymentTermFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D4002","subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}
	//add by Peggy 20120223
	function subWindowFOBPointFind(primaryFlag,fieldType)
	{
		subWin=window.open("../jsp/subwindow/TSDRQFOBPointFind.jsp?PRIMARYFLAG="+primaryFlag+"&FUNC=D4002&FTYPE="+fieldType,"subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}
	//add by Peggy 20120223
	function subWindowShipToFind(siteUseCode,customerID,shipToOrg,salesAreaNo)
	{
		subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SHIPTOORG="+shipToOrg+"&SALESAREANO="+salesAreaNo+"&FUNC=D4002","subwin","width=640,height=480,scrollbars=yes,menubar=no");
	}
	//add by Peggy 20120308
	function subWindowOrderTypeFind(salesAreaNo,itemFactory,lineNo)
	{
		var orderType = document.DISPLAYREPAIR.elements["odrType"+lineNo].value;
		salesAreaNo = "00"+salesAreaNo;
		salesAreaNo = salesAreaNo.substring(salesAreaNo.length-3);
		itemFactory = "00"+itemFactory;
		itemFactory = itemFactory.substring(itemFactory.length-3);
		subWin=window.open("../jsp/subwindow/TSDRQOrderTypeFind.jsp?PRIMARYFLAG="+orderType+"&SalesAreaNo="+salesAreaNo+"&MANUFACTORY="+itemFactory+"&LINENO="+lineNo,"subwin","top=200,left=500,width=300,height=450,scrollbars=yes,menubar=no");
	}
	//add by Peggy 20120308
	function subWindowLineTypeFind(salesAreaNo,lineNo)
	{
		var lineType = document.DISPLAYREPAIR.elements["lineType"+lineNo].value;
		var orderType = document.DISPLAYREPAIR.elements["odrType"+lineNo].value;
		salesAreaNo = "00"+salesAreaNo;
		salesAreaNo = salesAreaNo.substring(salesAreaNo.length-3);
		subWin=window.open("../jsp/subwindow/TSDRQLineTypeFind.jsp?PRIMARYFLAG="+lineType+"&SalesAreaNo="+salesAreaNo+"&orderType="+orderType+"&LINENO="+lineNo,"subwin","top=200,left=500,width=300,height=450,scrollbars=yes,menubar=no");
	}
	function setSubmit()
	{

		for (var i = 1 ; i < document.DISPLAYREPAIR.lineCnt.value ;i++)
		{
			if (document.DISPLAYREPAIR.elements["ENDCUSTID"+i].value != null && document.DISPLAYREPAIR.elements["ENDCUSTID"+i].value !="")
			{
				if (document.DISPLAYREPAIR.elements["ENDCUST"+i].value == null || document.DISPLAYREPAIR.elements["ENDCUST"+i].value =="")
				{
					alert("End Customer ID:"+document.DISPLAYREPAIR.elements["ENDCUSTID"+i].value+" Not Found!");
					return false;
				}
			}
		}
		document.DISPLAYREPAIR.submit();
	}
</script>
<%
	String fileName = request.getParameter("fileName");
	String errorMessage = null;
	String pgmName = "D4002_"; //add by Peggy 20110629
	if(fileName==null )
	{
		myUpload.initialize(pageContext);
		myUpload.upload();

		if(myUpload.getFiles().getCount()>0)
		{
			com.jspsmart.upload.File myFile = myUpload.getFiles().getFile(0);
			if (!myFile.isMissing())
			{
				fileName = myFile.getFileName();
				fileName = pgmName+fileName; //add by Peggy 20110629
				myFile.saveAs("/jsp/upload_exl/"+fileName);
				session.setAttribute("pic",fileName);
			}
		}
	}
//response.sendRedirect("TscJapanExlRfqUpload.jsp");
%>
<!--=============以下區段為安全認證機制==========-->
<%

	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
	cs1.execute();
	cs1.close();

//add by Peggy 20120605
	String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate();
	pstmt.close();

	String dateString=null;
	String docNo=request.getParameter("DOCNO");
	String targetYear="";
	String targetMonth="";
	String seqno=null;
	String seqkey=null;
	String customerId=request.getParameter("CUSTOMERID");
	String customerPO_Easy ="";
	String salesAreaNo="003";
	String salesPersonID=request.getParameter("SALESPERSONID");
	String receptDate=request.getParameter("RECEPTDATE");
	String curr=request.getParameter("CURR");
	String remark=request.getParameter("REMARK");
	String requireReason=request.getParameter("REQUIREREASON");
	String preOrderType=request.getParameter("PREORDERTYPE");
	String isModelSelected=request.getParameter("ISMODELSELECTED");
	String processArea=request.getParameter("PROCESSAREA");
	String salesPerson=request.getParameter("SALESPERSON");
	String toPersonID=request.getParameter("TOPERSONID");
	String customerIdTmp=request.getParameter("CUSTOMERIDTMP");
	String insertPage=request.getParameter("INSERT");
	String preSeqNo=request.getParameter("PREDNDOCNO");
	String repeatInput=request.getParameter("REPEATINPUT");
	String itemFactory = "";
	String uom =  "";
	String priceCategory  ="";
	String orderType = "";  //add by Peggy 20120302
	String lineType = "";   //add by Peggy 20120307
	String tscProdGroup=""; //add by Peggy 20120308
	String lineFob="";      //add by Peggy 20120329

	/* XML 抓取 JSP 程式 編號  TU-001 */
	java.util.Date datetime = new java.util.Date();
	SimpleDateFormat formatter = new SimpleDateFormat ("yyyy/MM/dd");
	SimpleDateFormat formatter1 = new SimpleDateFormat ("yyyy/MM/dd HH:mm:ss");
	String RevisedTime = (String) formatter.format( datetime );         //2003/01/01
	String RevisedTimes = (String) formatter1.format( datetime );         //2003/01/01
	String  arr[][];
//add by Peggy 20120223 start
	String CUSTOMERNO = "4777";
	String CUSTOMERNUMBER = "2439";
	String CUSTOMERNAME = "TAIWAN SEMICONDUCTOR JAPAN CO.,LTD";
	String price_List = "";
	String ShipToOrg = request.getParameter("SHIPTOORG");
	if (ShipToOrg==null) ShipToOrg="";
	String billTo = request.getParameter("BILLTO");
	if (billTo==null) billTo="";
	String shipAddress = request.getParameter("SHIPADDRESS");
	if (shipAddress==null) shipAddress="";
	String billAddress = request.getParameter("BILLADDRESS");
	if (billAddress==null) billAddress="";
	String shipCountry = request.getParameter("SHIPCOUNTRY");
	if (shipCountry==null) shipCountry="";
	String billCountry = request.getParameter("BILLCOUNTRY");
	if (billCountry==null) billCountry="";
	String paymentTerm = request.getParameter("PAYTERM");
	if (paymentTerm==null || paymentTerm.equals("")) paymentTerm="";
	String payTermID = request.getParameter("PAYTERMID");
	if (payTermID==null) payTermID="";
	String fobPoint = request.getParameter("FOBPOINT");
	if (fobPoint==null) fobPoint="";
	int lineCnt=0,err_cnt=0;
	String item_name="",v_shipmethod_flag=""; //add by Peggy 20161107

%>

<html>
<head>
	<title>EXL Parser Test Page</title>
	<STRI>
		<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<STYLE TYPE='text/css'>
	BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
	P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
	TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 11px ;table-layout:fixed; word-break :break-all}
</STYLE>
<body>

<FORM  action="TscJapanExlPaserGetArr.jsp" method="post" name="DISPLAYREPAIR">
	<%@ include file="TscJapanHead.jsp"%>
	<input name="Submit" type="button"   value="產生詢問單" onClick="setSubmit();" disabled>
	<br>
	<%

		//get a new document builder
//load exl
		try
		{
			Workbook workbook = Workbook.getWorkbook(new File("\\resin-2.1.9\\webapps\\oradds\\jsp\\upload_exl\\"+fileName));
			Sheet sheet = workbook.getSheet(0);
			int  number =  sheet.getRows();
			Cell cellpartdesc = null;
			Cell cellmetheddesc = null;
			Cell cellitemname= null;
			Cell cellEndCustomer=null;
			Cell cellCustomerPN=null; //add by Peggy 20230309

// 若單號未取得,則呼叫取號程序
			try
			{
				if (docNo==null || docNo.equals(""))
				{
					dateString=dateBean.getYearMonthDay();
					if (salesAreaNo==null || salesAreaNo.equals("--")) seqkey="TS"+userActCenterNo+dateString; //但仍以預設為使用者地區
					else seqkey="TS"+salesAreaNo+dateString;         // 2006/01/10 改以選擇的業務地區代號產生單號
					//====先取得流水號=====
					Statement statement=con.createStatement();
					ResultSet rs=statement.executeQuery("select * from ORADDMAN.TSDOCSEQ where header='"+seqkey+"'");
					//out.println("seqkey="+seqkey);
					if (rs.next()==false)
					{
						String seqSql="insert into ORADDMAN.TSDOCSEQ values(?,?)";
						PreparedStatement seqstmt=con.prepareStatement(seqSql);
						seqstmt.setString(1,seqkey);
						seqstmt.setInt(2,1);

						seqstmt.executeUpdate();
						seqno=seqkey+"-001";
						seqstmt.close();
					}
					else
					{
						int lastno=rs.getInt("LASTNO");
						String sql = "select * from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' "+
								" and to_number(substr(DNDOCNO,15,3))= '"+lastno+"' ";
						ResultSet rs2=statement.executeQuery(sql);
						//===(處理跳號問題)若rprepair及rpdocseq皆存在相同最大號=========依原方式取最大號 //
						if (rs2.next())
						{
							lastno++;
							String numberString = Integer.toString(lastno);
							String lastSeqNumber="000"+numberString;
							lastSeqNumber=lastSeqNumber.substring(lastSeqNumber.length()-3);
							seqno=seqkey+"-"+lastSeqNumber;

							String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
							PreparedStatement seqstmt=con.prepareStatement(seqSql);
							seqstmt.setInt(1,lastno);
							seqstmt.executeUpdate();
							seqstmt.close();
						}
						else
						{
							//===========(處理跳號問題)否則以實際rpRepair內最大流水號為目前rpdocSeq的lastno內容(會依維修地區別)
							String sSql = "select to_number(substr(max(DNDOCNO),15,3)) as LASTNO "+
									" from ORADDMAN.TSDELIVERY_NOTICE where substr(DNDOCNO,1,13)='"+seqkey+"' ";
							ResultSet rs3=statement.executeQuery(sSql);

							if (rs3.next()==true)
							{
								int lastno_r=rs3.getInt("LASTNO");
								lastno_r++;
								String numberString_r = Integer.toString(lastno_r);
								String lastSeqNumber_r="000"+numberString_r;
								lastSeqNumber_r=lastSeqNumber_r.substring(lastSeqNumber_r.length()-3);
								seqno=seqkey+"-"+lastSeqNumber_r;
								out.println("<tr><tr>");
								out.println("<TD>詢問單號="+seqno+"</TD><BR>");
								out.println("<TD>台半工號="+userID+"</TD><BR>");
								out.println("<TD>業務區碼="+salesAreaNo+"</TD><BR>");
								out.println("</tr></tr><br>");
								String seqSql="update ORADDMAN.TSDOCSEQ SET LASTNO=? WHERE HEADER='"+seqkey+"'";
								PreparedStatement seqstmt=con.prepareStatement(seqSql);
								seqstmt.setInt(1,lastno_r);
								seqstmt.executeUpdate();
								seqstmt.close();
							}  // End of if (rs3.next()==true)
						} // End of Else  //===========(處理跳號問題)
					} // End of Else
					docNo = seqno; // 把取到的號碼給本次輸入
				} // End of if (docNo==null || docNo.equals(""))
				else
				{
				}
			} //end of try
			catch (Exception e)
			{
				out.println("Exception:"+e.getMessage());
			}

			try
			{
				//add by Peggy 20140820
				String sql = "	SELECT distinct c.customer_number,c.customer_id,c.CUSTOMER_NAME_PHONETIC"+
						" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+
						" ,(select * from oraddman.tssales_area where SALES_AREA_NO='"+salesAreaNo+"') d"+
						" where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
						" and ','||d.GROUP_ID||',' like '%,'||b.attribute1||',%'"+
						" and a.STATUS = b.STATUS "+
						" and a.ORG_ID = b.ORG_ID "+
						" and a.ORG_ID = d.PAR_ORG_ID"+
						" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+
						" and c.STATUS='A'"+
						" and c.customer_number <>'"+CUSTOMERNUMBER+"'"+
						" order by c.customer_id";
				//out.println(sql);
				Statement statements=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rss = statements.executeQuery(sql);

				//add by Peggy 20200113
				sql = " SELECT lookup_code,meaning FROM fnd_lookup_values lv"+
						" WHERE language = 'US'"+
						" AND view_application_id = 3"+
						" AND lookup_type = 'SHIP_METHOD'"+
						" AND security_group_id = 0"+
						" AND ENABLED_FLAG='Y'"+
						" AND (end_date_active IS NULL OR end_date_active > SYSDATE)";
				Statement statementh=con.createStatement( ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
				ResultSet rsh = statementh.executeQuery(sql);

				Statement statement=con.createStatement();
				ResultSet rs=null;
				sql = " select case when upper(a.site_use_code)='BILL_TO' then 1 else 2 end as segno,"+ //add by Peggy 20120914
						" a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+
						" a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION"+
						" from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
						" where  a.ADDRESS_ID = b.cust_acct_site_id"+
						" AND b.party_site_id = party_site.party_site_id"+
						" AND loc.location_id = party_site.location_id "+
						" and a.STATUS='A' "+
						" and a.PRIMARY_FLAG='Y'"+
						" and b.CUST_ACCOUNT_ID ='"+CUSTOMERNO+"'"+
						" and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
						" order by case when upper(a.site_use_code)='BILL_TO' then 1 else 2 end";  //add by Peggy 20120914
				rs=statement.executeQuery(sql);
				while (rs.next())
				{
					if (rs.getString("SITE_USE_CODE").equals("SHIP_TO"))
					{
						ShipToOrg =rs.getString("SITE_USE_ID");
						shipAddress = rs.getString("ADDRESS1");
						payTermID = rs.getString("PAYMENT_TERM_ID");
						paymentTerm = rs.getString("PAYMENT_TERM_NAME");
						fobPoint = rs.getString("FOB_POINT");
						price_List = rs.getString("PRICE_LIST_ID");
						shipCountry = rs.getString("COUNTRY");

					}
					else if (rs.getString("SITE_USE_CODE").equals("BILL_TO"))
					{
						billTo = rs.getString("SITE_USE_ID");
						billAddress = rs.getString("ADDRESS1");
						billCountry = rs.getString("COUNTRY");
					}
				}
				rs.close();

				out.println("<table width='100%' border='0'><tr><td><table width='100%' height='74' border='1' align='left' cellpadding='0' cellspacing='1'   bordercolor='#3399CC'>");
				//add by Peggy 20120223,增加客戶名稱,price list,payment term,fob,shiptoaddress,billtoaddress
				out.println("<tr>");
				out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgCustomerName"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'><div align='left'>");
		out.println("<input type='text' name='CUSTOMERNUMBER' size='8' value='"+CUSTOMERNUMBER+"' style='font-size:11px;font-family: Tahoma,Georgia;' readonly><input type='hidden' name='CUSTOMERNO' size='8' value='"+CUSTOMERNO+"'>");
		out.println("<input type='text' name='CUSTOMERNAME' size='80' value='"+CUSTOMERNAME+"' style='font-size:11px;font-family: Tahoma,Georgia;' readonly></td>");
		out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgPriceList"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'>");
		try
		{
			//Statement statement=con.createStatement();
			//ResultSet rs=null;
			sql = " select LIST_HEADER_ID, LIST_HEADER_ID||'('||NAME||')' as LIST_CODE, CURRENCY_CODE "+
					" from qp_list_headers_v "+
					" where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' "+
					"  AND (exists (select 1 from ORADDMAN.TSSALES_AREA x where x.SALES_AREA_NO='"+salesAreaNo+"' and x.PAR_ORG_ID=ORIG_ORG_ID) or ORIG_ORG_ID IS NULL ) ";
			rs=statement.executeQuery(sql);
			out.println("<select NAME='FIRMPRICELIST' tabindex='3' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' >");
			out.println("<OPTION VALUE=-->--");
			while (rs.next())
			{
				String s1=(String)rs.getString(1);
				String s2=(String)rs.getString(2);
				String s3=(String)rs.getString(3);
				if (s1==price_List || s1.equals(price_List))
				{
					out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
				}
				else
				{
					out.println("<OPTION VALUE='"+s1+"'>"+s2);
				}
			}
			out.println("</select>");
			statement.close();
			rs.close();
		}
		catch (Exception e)
		{
			out.println("Exception3:"+e.getMessage());
		}
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'><div align='left'>");
		out.println("<input type='text' size='8' name='SHIPTOORG' tabindex='4' value='"+ShipToOrg+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66'>");
		out.println("<INPUT TYPE='button' tabindex='5'  value='...' onClick='subWindowShipToFind("+'"'+"SHIP_TO"+'"'+",this.form.CUSTOMERNO.value,this.form.SHIPTOORG.value,"+'"'+salesAreaNo+'"'+")'>");
		out.println("<INPUT TYPE='text' NAME='SHIPADDRESS' tabindex='6' SIZE='90' value='"+shipAddress+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' readonly>");
		out.println("<INPUT TYPE='text' NAME='SHIPCOUNTRY' tabindex='7' SIZE=3 value='"+shipCountry+"'  style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' readonly>");
		out.println("</td>");
		out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgPaymentTerm"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'>");
		out.println("<input type='text' size='35' name='PAYTERM' value='"+paymentTerm+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' >");
		out.println("<INPUT TYPE='button' value='...' onClick='subWindowPayTermFind(this.form.PAYTERMID.value)'>");
		out.println("<input type='hidden' size='10' name='PAYTERMID' tabindex='13' value='"+payTermID+"'>");
		out.println("</td>");
		out.println("</tr>");
		out.println("<tr>");
		out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgBillTo"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'><div align='left'>");
		out.println("<input type='text' size='8' name='BILLTO' tabindex='4' value='"+billTo+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66'>");
		out.println("<INPUT TYPE='button' tabindex='5'  value='...' onClick='subWindowShipToFind("+'"'+"BILL_TO"+'"'+",this.form.CUSTOMERNO.value,this.form.SHIPTOORG.value,"+'"'+salesAreaNo+'"'+")'>");
		out.println("<INPUT TYPE='text' NAME='BILLADDRESS' tabindex='6' SIZE='90' value='"+billAddress+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' readonly>");
		out.println("<INPUT TYPE='text' NAME='BILLCOUNTRY' tabindex='11' SIZE=3 value='"+billCountry+"' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' readonly>");
		out.println("</td>");
		out.println("<td colspan='2' bgcolor='#CCFFCC'><div align='center'>");
	%>
	<jsp:getProperty name="rPH" property="pgFOB"/>
	<%
		out.println("</td>");
		out.println("<td colspan='8'>");
		out.println("<input type='text' size='35' name='FOBPOINT' value='"+fobPoint+"'style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' >");
		out.println("<INPUT TYPE='button' value='...' onClick='subWindowFOBPointFind(this.form.FOBPOINT.value,null)'>");
		out.println("</td>");
		out.println("</tr>");
		out.println("<td width='2%' bgcolor='#CCFFCC'><div align='center'>項次</div></td>");
		//out.println("<td width='20' bgcolor='#CCFFCC'><div align='center'>F.O.B</div></td>");
		out.println("<td width='8%' bgcolor='#CCFFCC'><div align='center'>CustomerPO</div></td>");
		out.println("<td width='4%' bgcolor='#CCFFCC'><div align='center'>數量</div></td>");
		out.println("<td width='4%' bgcolor='#CCFFCC'><div align='center'>價格</div></td>");
		out.println("<td width='4%' bgcolor='#CCFFCC'><div align='center'>型號ID</div></td>");
		out.println("<td width='12%' bgcolor='#CCFFCC'><div align='center'>型號內碼</div></td>");
		out.println("<td width=8%' bgcolor='#CCFFCC'><div align='center'>型號</div></td>");
		out.println("<td width=8%' bgcolor='#CCFFCC'><div align='center'>客戶品號</div></td>");
		out.println("<td width='15%' bgcolor='#CCFFCC'><div align='center'>LINE說明</div></td>");
		out.println("<td width='8%' bgcolor='#CCFFCC'><div align='center'>客戶</div></td>");
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>生產工廠</div></td>");
		out.println("<td width='4%' bgcolor='#CCFFCC'><div align='center'>最小單位</div></td>");
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>名目價格</div></td>");
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>需求日期</div></td>"); //add by Peggy 20120113
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>出貨方式</div></td>"); //add by Peggy 20120223
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>訂單類型</div></td>"); //add by Peggy 20120223
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>Line Type</div></td>"); //add by Peggy 20120223
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>FOB</div></td>");       //add by Peggy 20120329
		out.println("<td width='5%' bgcolor='#CCFFCC'><div align='center'>End Cust ID</div></td>"); //add by Peggy 20140820
		out.println("</tr>");
		// Process to determine the total item records
		int itemCNTtotal = 0;
		int itemCNTsub[] = new int[number];
		String partdesc="",metheddesc="",endcust="",cust_pn="";  //add by Peggy 20180703

		for ( int itemno=1 ; itemno < number ; itemno++)
		{
			cellpartdesc   = sheet.getCell(16,itemno);
			partdesc =   cellpartdesc.getContents();
			cellmetheddesc = sheet.getCell(17,itemno);
			metheddesc =   cellmetheddesc.getContents();
			if (metheddesc ==null) metheddesc="";
			cellEndCustomer = sheet.getCell(25,itemno);
			endcust =   cellEndCustomer.getContents();
			//out.println("endcust="+endcust);
			//String partdescCNT =    partdesc+" "+metheddesc;
			String partdescCNT =    partdesc+(metheddesc==null || metheddesc.equals("")?"":" "+metheddesc);//modify by Peggy 20210716
			if (metheddesc.length() >=3 && metheddesc.startsWith("H"))  //add by Peggy 20151202
			{
				partdescCNT = partdesc+metheddesc;
			}
			cellitemname = sheet.getCell(29,itemno); //add by Peggy 20161107
			item_name=cellitemname.getContents();
			if (item_name==null) item_name="";

			cellCustomerPN = sheet.getCell(27,itemno);  //add by Peggy 20230309
			cust_pn=cellCustomerPN.getContents();
			if (cust_pn==null) cust_pn="";

			// Get TSC Part Number
			try
			{
				// To Check the ITEM result record
				String sqlCNTitem = "";
				//sqlCNTitem = "select count(1) "+
				sqlCNTitem = " select sum(case when inventory_item_status_code='Active' then 1 else 0 end) OVER (PARTITION BY 1) ROW_CNT,inventory_item_status_code,NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N') CUSTOMER_ORDER_ENABLED_FLAG,tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate)) pnc_flag"+ //modify by Peggy 20230217
						" from APPS.MTL_SYSTEM_ITEMS a"+
						" where ORGANIZATION_ID = '49' "+
						" and tsc_get_item_coo(a.inventory_item_id) =(\n" + //add by Mars 20250108
						"     case when TSC_INV_CATEGORY(a.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
						"     then 'CN' else tsc_get_item_coo(a.inventory_item_id) end) \n"+ //add by Mars 20250108
						" and DESCRIPTION = '"+partdescCNT+"' ";
				if (!cust_pn.equals(""))
				{
					sqlCNTitem += " and exists (select 1 from oe_items_v x where x.item ='"+cust_pn+"' and x.inventory_item_id=a.inventory_item_id)";
				}
				//" and inventory_item_status_code <>'Inactive' "+ //add by Peggy 20110705
				//" and NVL(CUSTOMER_ORDER_FLAG,'N')='Y'"+//add by Peggy 20170804
				//" and NVL(CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+ //add by Peggy 20170804
				//" and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'";  //add by Peggy 20230116
				//if (partdesc.equals("S1JM-02") && (endcust.indexOf("IMASEN")>=0 || endcust.indexOf("SWS")>=0 || endcust.indexOf("HONDA LOCK")>=0 || endcust.indexOf("NIDEC ELESYS")>=0 || endcust.indexOf("NIPPON SEIKI")>=0))
				//S1JM-02/S1GM-02不用綁定30D bonnie說 20230921
			/*if (partdesc.equals("S1JM-02")) //modify by Peggy 20210625 除了IMASEN 是要綁8001-031RS211JM0000002, 其他客戶都是下新的30D 8001-031RS211JM000000200000F00
			{
				//if (endcust.indexOf("IMASEN")>=0)
				//{
				//	item_name="8001-031RS211JM0000002";
				//}
				////else if (endcust.indexOf("SWS")>=0 || endcust.indexOf("HONDA LOCK")>=0 || endcust.indexOf("NIDEC ELESYS")>=0 || endcust.indexOf("NIPPON SEIKI")>=0)  //add HONDA LOCK/NIDEC ELESYS by Peggy 20210618,add by Peggy 20210604 from bonnie issue
				//else
				//{
					item_name="8001-031RS211JM000000200000F00";
				//}
			}
			else if (partdesc.equals("S1GM-02") && endcust.indexOf("SWS")>=0) //add by Peggy 20201111
			{
				item_name="8001-031MS211GM000000200000F00";
			}
			*/
				if (!item_name.equals(""))  //add by Peggy 20161107
				{
					sqlCNTitem += " and segment1='"+ item_name+"'";
				}
				sqlCNTitem += " order by  case when inventory_item_status_code='Active' then 1 else 2 end";
				//out.println(sqlCNTitem);
				Statement stateCNTitem=con.createStatement();
				ResultSet rsCNTitem=stateCNTitem.executeQuery(sqlCNTitem);
				if (rsCNTitem.next())
				{
					if (rsCNTitem.getInt(1) >1)
					{
						throw new Exception("Item:"+partdescCNT +" is more than one<br>");
					}
					else if (rsCNTitem.getString(2).equals("Inactive<br>"))
					{
						throw new Exception("Item:"+partdescCNT +" is inactive<br>");
					}
					else if (rsCNTitem.getString(3).equals("N"))
					{
						throw new Exception("Item:"+partdescCNT +" customer order disenabled<br>");
					}
					else if (rsCNTitem.getString(4).equals("Y"))
					{
						throw new Exception("Item:"+partdescCNT +" has been IN/PCN/PDN<br>");
					}
				}
				else
				{
					throw new Exception("Item:"+partdescCNT +" does not exist ERP system<br>");
				}
				itemCNTsub[itemno] = rsCNTitem.getInt(1);
				itemCNTtotal = itemCNTtotal + itemCNTsub[itemno];
			}
			catch (Exception e)
			{
				out.println("<font style='color:#ff0000;font-size:12px'>Exception:"+e.getMessage()+"</font>");
			}
		}

		Cell c_customerPO_Easy = sheet.getCell(15,1);
		String  p_customerPO_Easy = c_customerPO_Easy.getContents();
		if(p_customerPO_Easy.startsWith("/") !=true)
		{
			customerPO_Easy=p_customerPO_Easy;
		}
		else
		{
			int a_begin =  p_customerPO_Easy.indexOf("/");
			int b_end =  p_customerPO_Easy.length();
			customerPO_Easy = p_customerPO_Easy.substring(0,a_begin);   		// 表示字串中","之前的字串也就是 CUSTOMER PO
		}
		//arr = new String[17][itemCNTtotal+1];
		arr = new String[27][itemCNTtotal+1]; //add by Peggy 201519
		int x=1;
		String customerPO="",partNumber="",packageMethod="",quantity="",unitPrice="",shipMethod="",endCustomer="",yyyymmdd="",item="",po_Header="",erpEndCustomer="",erpEndCustID="",erpEndCustID1="";
		String custPN="",v_date_msg=""; //add by Peggy 20160929

		for(int i=1;i<number;i++)
		{
			int  c_lineNumber = i;
			//Cell c_OrderFrom = sheet.getCell(8,i);
			Cell c_OrderFrom = sheet.getCell(10,i); //modify by Peggy 20140107
			//Cell c_Fob_Point = sheet.getCell(12,i);
			Cell c_shipMethod = sheet.getCell(12,i); //modify by Peggy 20120223
			Cell c_customerPO = sheet.getCell(15,i);
			Cell c_partNumber = sheet.getCell(16,i);
			Cell c_packageMethod = sheet.getCell(17,i);
			Cell c_quantity = sheet.getCell(18,i);    //  1代表row  2 代表column
			Cell c_unitPrice = sheet.getCell(19,i);
			Cell c_EndCustomer = sheet.getCell(25,i);
			Cell c_RequestDate = sheet.getCell(21,i);
			Cell c_CustomerPN = sheet.getCell(27,i); //add by Peggy 20160929
			Cell c_EndCustomerID = sheet.getCell(28,i); //add by Peggy 20140820
			Cell c_item_name = sheet.getCell(29,i); //add by Peggy 20161107
			String orderFrom = c_OrderFrom.getContents();
			int count_orderFrom_Arr = orderFrom.toUpperCase().trim().replaceAll(" ","").length();
			String orderFrom_Arr ="";
			if(count_orderFrom_Arr>17)
			{
				orderFrom_Arr =orderFrom.toUpperCase().trim().replaceAll(" ","").substring(0,17);
				if(orderFrom_Arr=="KOMATSUTRILINKLTD" ||  orderFrom_Arr.equals("KOMATSUTRILINKLTD") || orderFrom_Arr=="KOMASTSUTRILINKLT" || orderFrom_Arr.equals("KOMASTSUTRILINKLT"))
				{
					orderFrom_Arr ="KTL-HK";
				}
				else if(orderFrom_Arr=="KOMATSUTRILINKPTE" ||  orderFrom_Arr.equals("KOMATSUTRILINKPTE") || orderFrom_Arr=="KOMATSUTRILINKPT" ||  orderFrom_Arr.equals("KOMATSUTRILINKPT"))
				{
					orderFrom_Arr ="KTL-S";
				}
				else if(orderFrom_Arr=="KANEMATSUSEMICOND" ||  orderFrom_Arr.equals("KANEMATSUSEMICOND") || orderFrom_Arr=="KANEMATSUSEMICON" ||  orderFrom_Arr.equals("KANEMATSUSEMICON"))
				{
					orderFrom_Arr ="KSS-S";
				}
				else if(orderFrom_Arr=="KANEMATSUCORPORAT" ||  orderFrom_Arr.equals("KANEMATSUCORPORAT") || orderFrom_Arr=="KANEMATSUCORPORA" || orderFrom_Arr.equals("KANEMATSUCORPORA"))
				{
					orderFrom_Arr  ="KSS-HK";
				}
				else if(orderFrom_Arr=="TAIWANSEMICONDUCT" ||  orderFrom_Arr.equals("TAIWANSEMICONDUCT") || orderFrom_Arr=="TAIWANSEMICONDUC" ||  orderFrom_Arr.equals("TAIWANSEMICONDUC"))
				{
					orderFrom_Arr  ="TSCJ";
				}
				else if(orderFrom_Arr=="WELLSPERTINVESTME" ||  orderFrom_Arr.equals("WELLSPERTINVESTME") || orderFrom_Arr=="WELLSPERTINVESTM" ||  orderFrom_Arr.equals("WELLSPERTINVESTM"))
				{
					orderFrom_Arr  ="KSS-SA-HK";
				}
				else if(orderFrom_Arr=="TOKYOCOMPONENTS(H" ||  orderFrom_Arr.equals("TOKYOCOMPONENTS(H") || orderFrom_Arr=="TOKYOCOMPONENTS(" ||  orderFrom_Arr.equals("TOKYOCOMPONENTS("))
				{
					orderFrom_Arr  ="TCH";
				}
				else if(orderFrom_Arr=="TOKYOCOMPONENTSCO" ||  orderFrom_Arr.equals("TOKYOCOMPONENTSCO") || orderFrom_Arr=="TOKYOCOMPONENTSC" ||  orderFrom_Arr.equals("TOKYOCOMPONENTSC"))
				{
					orderFrom_Arr  ="TCJ";
				}
				else
				{
					orderFrom_Arr = orderFrom;
				}
			}
			else
			{
				orderFrom_Arr = orderFrom;
			}

			customerPO = c_customerPO.getContents();
			partNumber = c_partNumber.getContents();
			packageMethod = c_packageMethod.getContents();
			//String quantity =  c_quantity.getContents();
			quantity =  c_quantity.getContents().replace(",",""); //modify by Peggy 20111202
			//String unitPrice = c_unitPrice.getContents();
			unitPrice = c_unitPrice.getContents().replace("$",""); //modify by Peggy 20111202
			//String fobpoint = c_Fob_Point.getContents();
			shipMethod = c_shipMethod.getContents();  //modify by Peggy 20120223
			shipMethod = shipMethod.toUpperCase();    //add by Peggy 20200114
			item_name = c_item_name.getContents();    //add by Peggy 20161107
			if (item_name==null) item_name="";
			endCustomer = c_EndCustomer.getContents();
			erpEndCustID = c_EndCustomerID.getContents(); //add by Peggy 20140820
			if (erpEndCustID==null) erpEndCustID="";
			erpEndCustomer="";erpEndCustID1="";
			if (!erpEndCustID.equals(""))
			{
				if (rss.isBeforeFirst() ==false) rss.beforeFirst();
				while (rss.next())
				{
					if (rss.getString("customer_number").equals(erpEndCustID))
					{
						erpEndCustID1 = rss.getString("customer_id");
						erpEndCustomer = rss.getString("CUSTOMER_NAME_PHONETIC");
						break;
					}
				}
			}
			custPN = c_CustomerPN.getContents(); //add by Peggy 20160929
			if (custPN==null) custPN="";

			//String requestDate = c_RequestDate.getContents();
			//String yyyymmdd = (requestDate.replaceAll("/","")).substring(4,8)+(requestDate.replaceAll("/","")).substring(2,4)+(requestDate.replaceAll("/","")).substring(0,2);
			//modify by Peggy 20120113 start
			yyyymmdd ="";v_date_msg="";
			if (c_RequestDate.getType() == CellType.DATE)
			{
				DateCell dc = (DateCell)c_RequestDate;
				java.util.Date strDate = dc.getDate();
				yyyymmdd = ((String)formatter.format(strDate)).replaceAll("/","");
				if ( (strDate.getYear() - datetime.getYear())*12 + (strDate.getMonth() - datetime.getMonth())>24)  //12月改18月,因為tscj有下到隔年11月,modify by Peggy 20170704,18改24月 by Peggy 20210518
				{
					v_date_msg = "<br><font color='red'>Request Date:"+c_RequestDate.getContents()+" is not available</font>";
	%>
	<script language="javascript">
		document.DISPLAYREPAIR.Submit.disabled=true;
	</script>
	<%
		}
	}
	else
	{
		v_date_msg = "<br><font color='red'>Request Date:"+c_RequestDate.getContents()+" format Error</font>";
	%>
	<script language="javascript">
		document.DISPLAYREPAIR.Submit.disabled=true;
	</script>
	<%
			}
			//modify by Peggy 20120113 end

			if(endCustomer=="NA" || endCustomer.equals("NA"))
			{
				endCustomer="";
			}
			item =  partNumber+" "+packageMethod;
			item =  partNumber+(packageMethod==null||packageMethod.equals("")?"":" "+packageMethod); //modify by Peggy 20210716
			if (packageMethod.length() >=3 && packageMethod.startsWith("H"))  //add by Peggy 20151202
			{
				item =  partNumber+packageMethod;
			}
			if (endCustomer.indexOf("/")>=0)
			{
				po_Header = customerPO+"("+orderFrom_Arr+"/"+endCustomer.substring(0,endCustomer.indexOf("/"))+")";
			}
			else
			{
				po_Header = customerPO+"("+orderFrom_Arr+"/"+endCustomer+")";
			}
			if (endCustomer.indexOf("(")>=0)
			{
				po_Header = customerPO+"("+orderFrom_Arr+"/"+endCustomer.substring(0,endCustomer.indexOf("("))+")";
			}
			else
			{
				po_Header = customerPO+"("+orderFrom_Arr+"/"+endCustomer+")";
			}
			int poHeaderLegth = po_Header.length();
			//if (poHeaderLegth>50)
			//{
			//	po_Header = customerPO+"("+orderFrom_Arr+"/"+endCustomer.substring(0,endCustomer.length()-(poHeaderLegth-50))+")";
			//	poHeaderLegth = po_Header.length();
			//}
			if (endCustomer=="" || endCustomer.equals(""))
			{
				po_Header = po_Header.substring(0,poHeaderLegth-2);
				po_Header = po_Header + ")";
			}
			try
			{
				String sql_item = "";
				String i_inventory_item_id = "";
				String i_inventory_item	= "";
				String i_Item_Description  = "";
				String i_Item_Identifier_Type = "";
				String i_cust_item_id="";  //add by Peggy 20160929
				String i_cust_item="";     //add by Peggy 20160929
				if (custPN.equals(""))     //add by Peggy 20160929
				{
					sql_item =	" select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
							" ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v a "+
							" where ITEM_IDENTIFIER_TYPE = 'INT'"+
							" and  ITEM_DESCRIPTION = '"+item+"'" +
							" and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"+
							"and exists (select 1 from MTL_SYSTEM_ITEMS_B b \n" +
							"            where a.inventory_item_id= b.inventory_item_id \n" +
							"            and b.inventory_item_status_code='Active'\n" +
							" 			 and tsc_get_item_coo(b.inventory_item_id) =(\n" + //add by Mars 20250108
							"     				case when TSC_INV_CATEGORY(b.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
							"     				then 'CN' else tsc_get_item_coo(b.inventory_item_id) end) \n"+ //add by Mars 20250108
							"            and b.organization_id ='43')"; //add by Mars 20241114
					//if (partNumber.equals("S1JM-02") && (endCustomer.indexOf("IMASEN")>=0 || endCustomer.indexOf("SWS")>=0))
					//{
					//	sql_item += " and INVENTORY_ITEM='8001-031RS211JM0000002'";
					//}
					//if (partNumber.equals("S1JM-02") && (endCustomer.indexOf("IMASEN")>=0 ||endCustomer.indexOf("SWS")>=0 || endCustomer.indexOf("HONDA LOCK")>=0 || endCustomer.indexOf("NIDEC ELESYS")>=0 || endCustomer.indexOf("NIPPON SEIKI")>=0))
					//S1JM-02/S1GM-02不用綁定30D bonnie說 20230921
				/*if (partNumber.equals("S1JM-02")) //modify by Peggy 20210625 除了IMASEN 是要綁8001-031RS211JM0000002, 其他客戶都是下新的30D 8001-031RS211JM000000200000F00
				{
					//if (endCustomer.indexOf("IMASEN")>=0)
					//{
					//	sql_item += " and INVENTORY_ITEM='8001-031RS211JM0000002'";
					//}
					////else if (endCustomer.indexOf("SWS")>=0 || endCustomer.indexOf("HONDA LOCK")>=0 || endCustomer.indexOf("NIDEC ELESYS")>=0 || endCustomer.indexOf("NIPPON SEIKI")>=0)  //add HONDA LOCK/NIDEC ELESYS by Peggy 20210618,add by Peggy 20210604 from bonnie issue
					//else
					//{
						sql_item += " and INVENTORY_ITEM='8001-031RS211JM000000200000F00'";
					//}
				}
				else if (partNumber.equals("S1GM-02") && endcust.indexOf("SWS")>=0) //add by Peggy 20201111
				{
					sql_item += " and INVENTORY_ITEM='8001-031MS211GM000000200000F00'";
				}
				else if (!item_name.equals(""))
				{
					sql_item += " and 	INVENTORY_ITEM='"+item_name+"'";
				}
				*/
					if (!item_name.equals(""))
					{
						sql_item += " and 	INVENTORY_ITEM='"+item_name+"'";
					}
				}
				else
				{
					sql_item =	" select ITEM,ITEM_ID,ITEM_DESCRIPTION,INVENTORY_ITEM_ID,INVENTORY_ITEM, "+
							" ITEM_IDENTIFIER_TYPE, SOLD_TO_ORG_ID from oe_items_v a"+
							" where ITEM_IDENTIFIER_TYPE = 'CUST'"+
							" and  ITEM_DESCRIPTION = '"+item+"'" +
							" and SOLD_TO_ORG_ID='"+CUSTOMERNO+"'"+
							" and ITEM='"+custPN+"'"+
							" and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"+
							"and exists (select 1 from MTL_SYSTEM_ITEMS_B b \n" +
							"            where a.inventory_item_id= b.inventory_item_id \n" +
							"            and b.inventory_item_status_code='Active'\n" +
							" 			 and tsc_get_item_coo(b.inventory_item_id) =(\n" + //add by Mars 20250108
							"     				case when TSC_INV_CATEGORY(b.inventory_item_id,43,23) IN ('SMA', 'SMB', 'SMC', 'SOD-123W', 'SOD-128')\n" + //add by Mars 20250108
							"     				then 'CN' else tsc_get_item_coo(b.inventory_item_id) end) \n"+ //add by Mars 20250108
							"            and b.organization_id ='43')"; //add by Mars 20241114
					if (!item_name.equals(""))
					{
						sql_item += " and 	INVENTORY_ITEM='"+item_name+"'";
					}
				}
				//out.println(sql_item);
				Statement st = con.createStatement();
				//ResultSet rs =  null;
				rs=st.executeQuery(sql_item);
				int y= 0;
				while(rs.next())
				{
					y++;
					i_inventory_item_id = rs.getString("INVENTORY_ITEM_ID");
					i_inventory_item	= rs.getString("INVENTORY_ITEM");
					i_Item_Description  = rs.getString("ITEM_DESCRIPTION");
					i_Item_Identifier_Type = rs.getString("ITEM_IDENTIFIER_TYPE");
					if (!rs.getString("INVENTORY_ITEM").equals(rs.getString("ITEM"))) //add by Peggy 20160929
					{
						i_cust_item_id = rs.getString("ITEM_ID");
						i_cust_item = rs.getString("ITEM");
					}
					else
					{
						i_cust_item_id ="0";
						i_cust_item ="N/A";
					}
				}
				rs.close();
				st.close();


				if (y==0)
				{
					if (custPN.equals(""))
					{
						throw new Exception("ERP查無台半品號:"+item);
					}
					else
					{
						throw new Exception("ERP查無客戶品號:"+custPN );
					}
				}
				else if ( y>1)
				{
					if (custPN.equals(""))
					{
						throw new Exception("台半品號:"+item+"在ERP有兩個以上");
					}
					else
					{
						throw new Exception("客戶品號:"+custPN+"在ERP有兩個以上" );
					}
				}
				else
				{
					Statement st2=con.createStatement();
					String sql_item2 = "select a.INVENTORY_ITEM_ID, a.PRIMARY_UOM_CODE, NVL(a.ATTRIBUTE3,'N/A') ATTRIBUTE3, b.SEGMENT1  "+
							//",TSC_RFQ_CREATE_ERP_ODR_PKG.tsc_get_order_type(a.ATTRIBUTE3) as ORDER_TYPE "+
							",TSC_RFQ_CREATE_ERP_ODR_PKG.tsc_get_order_type(a.INVENTORY_ITEM_ID) as ORDER_TYPE "+  //modify by Peggy 20191122
							",upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_GROUP')) as TSC_PROD_GROUP "+
							" from APPS.MTL_SYSTEM_ITEMS a, APPS.MTL_ITEM_CATEGORIES_V b "+
							" where a.INVENTORY_ITEM_ID = b.INVENTORY_ITEM_ID "+
							" and a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
							" and a.ORGANIZATION_ID = '49'"+
							" and b.CATEGORY_SET_ID = 6 "+
							" and NVL(a.CUSTOMER_ORDER_FLAG,'N')='Y'"+   //20151008 by Peggy
							" and NVL(a.CUSTOMER_ORDER_ENABLED_FLAG,'N')='Y'"+  //20151008 by Peggy
							" and tsc_item_pcn_flag(43,a.inventory_item_id,trunc(sysdate))='N'"+  //add by Peggy 20230117
							" and a.SEGMENT1 = '"+i_inventory_item+"' ";
					ResultSet rs_item =st2.executeQuery(sql_item2);
					if (rs_item.next())
					{
						itemFactory = rs_item.getString("ATTRIBUTE3");
						uom = rs_item.getString("PRIMARY_UOM_CODE");
						priceCategory = rs_item.getString("SEGMENT1");
						orderType= rs_item.getString("ORDER_TYPE");
						tscProdGroup = rs_item.getString("TSC_PROD_GROUP");
						if (i_Item_Description.equals("SFAF508G C0"))  //add by Peggy 20161024,TSCJ要求SFAF508G C0轉下給YEW生產
						{
							itemFactory ="002";
							orderType="1156";

						}
						if (orderType.equals("1141"))
						{
							lineFob = "FOB TAIWAN";
						}
						else if (orderType.equals("1142") || orderType.equals("1156"))
						{
							lineFob = "FOB CHINA";
						}
						else
						{
							lineFob =fobPoint;
						}

						//add by Peggy 20120430
						if (orderType.equals("1156"))
						{
							lineType ="1173";
						}
						else
						{
							Statement sta=con.createStatement();
							String sqla = " SELECT DISTINCT a.DEFAULT_ORDER_LINE_TYPE"+
									" FROM ORADDMAN.TSAREA_ORDERCLS  A ,ORADDMAN.TSPROD_ORDERTYPE B "+
									" WHERE A.ACTIVE ='Y' "+
									" AND A.ORDER_NUM = B.ORDER_NUM "+
									" and A.SAREA_NO = '"+salesAreaNo+"' "+
									" AND B.MANUFACTORY_NO = '"+itemFactory+"' "+
									" AND A.ORDER_NUM ='"+orderType+"'";
							ResultSet rsa=sta.executeQuery(sqla);
							if (rsa.next())
							{
								lineType = rsa.getString("DEFAULT_ORDER_LINE_TYPE");
							}
							else
							{
								lineType="N/A";
							}
							rsa.close();
							sta.close();
						}
					}
					else
					{
						itemFactory="N/A"; uom="N/A"; priceCategory = ""; orderType="";lineType="N/A";tscProdGroup ="";
					}
					rs_item.close();
					st2.close();

					String listPrice = "";
					Statement stateListPrice=con.createStatement();
					String sqlLPrice = "select OPERAND from ORADDMAN.TSITEM_LIST_PRICE "+
							"where LIST_HEADER_ID =  '6038' and PRODUCT_ATTR_VAL_DISP = '"+priceCategory+"' ";
					ResultSet rsLPrice=stateListPrice.executeQuery(sqlLPrice);
					if (rsLPrice.next())
					{
						listPrice = rsLPrice.getString("OPERAND");
					}
					else
					{
						listPrice = "0";
					}
					rsLPrice.close();
					stateListPrice.close();
					//add by Peggy 20200113
					v_shipmethod_flag="N";
					if (rsh.isBeforeFirst() ==false) rsh.beforeFirst();
					while (rsh.next())
					{
						if (rsh.getString("MEANING").equals(shipMethod) || rsh.getString("LOOKUP_CODE").equals(shipMethod))
						{
							v_shipmethod_flag="Y";
							shipMethod=rsh.getString("LOOKUP_CODE");
							break;
						}
					}
					if (v_shipmethod_flag.equals("N"))
					{
						throw new Exception("Shipping Method:"+shipMethod+" not defined");
					}


					arr[0][x]  =  customerPO;
					arr[1][x]  =  quantity;
					arr[2][x]  =  unitPrice;
					//arr[3][x]  =  fobpoint;
					arr[3][x]  =  shipMethod;  //modify by Peggy 20120223
					arr[4][x]  =  i_inventory_item_id;
					arr[5][x]  =  i_inventory_item;
					arr[6][x]  =  i_Item_Description;
					arr[7][x]  =  i_Item_Identifier_Type;
					arr[8][x]  =  orderFrom_Arr;
					arr[9][x]  =  endCustomer;
					arr[10][x] =  yyyymmdd;
					arr[11][x] = itemFactory;
					arr[12][x] = uom;
					arr[13][x] = priceCategory;
					arr[14][x] = listPrice;
					if(y>1)
					{
						arr[15][x] = "===Duplicate===";
					}
					else
					{
						arr[15][x] = "";
					}
					arr[16][x] = po_Header;      // 2006/06/06 By Kerwin add
					arr[17][x] = tscProdGroup;   //add by Peggy 20120308
					arr[18][x] = "";             //customer po line no,add by Peggy 20120531
					arr[19][x] = "";             //quote number,add by Peggy 20120917
					arr[20][x] = erpEndCustID1;  //end customer id, add by Peggy 20140820
					arr[21][x] = "";             //shipping marks,add by Peggy 20130305
					arr[22][x] = "";             //remarks,add by Peggy 20130305
					arr[23][x] = erpEndCustomer; //end customer, add by Peggy 20140820
					arr[24][x] = "";             //orig so line id, add by Peggy 20150519
					arr[25][x] = i_cust_item_id; //cust item id,add by Peggy 20160929
					arr[26][x] = i_cust_item;    //cust item id,add by Peggy 20160929
					out.println("<tr>");
					out.println("<td>"+c_lineNumber+"</td>");
					//out.println("<td>"+fobpoint+"</td>");
					out.println("<td>"+customerPO+"</td>");
					out.println("<td>"+Float.parseFloat(quantity)/1000+"</td>");
					out.println("<td>"+unitPrice+"</td>");
					out.println("<td>"+i_inventory_item_id+"</td>");
					out.println("<td>"+i_inventory_item+"</td>");
					out.println("<td>"+i_Item_Description+"</td>");
					out.println("<td>"+i_cust_item+"</td>"); //add by Peggy 20160929
					out.println("<td>"+po_Header+"</td>");
					out.println("<td>"+endCustomer+"</td>");
					out.println("<td>"+itemFactory+"</td>");
					out.println("<td>"+uom+"</td>");
					out.println("<td>"+listPrice+"</td>");
					out.println("<td>"+yyyymmdd+v_date_msg+"</td>");   //Add by Peggy 20120113
					out.println("<td>"+shipMethod+"</td>"); //modify by Peggy 20120223
					String hyperlink = "<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='subWindowOrderTypeFind("+salesAreaNo+","+itemFactory+","+x+")' title='請按我!'>";
					out.println("<td><input type='text' size='4' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' name='odrType"+x+"' value='"+orderType+"'>"+hyperlink+"</td>");  //Add by Peggy 20120223
					hyperlink = "<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='subWindowLineTypeFind("+salesAreaNo+","+x+")' title='請按我!'>";
					out.println("<td><input type='text' size='4' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' name='lineType"+x+"' value='"+lineType+"'>"+hyperlink+"</td>");  //Add by Peggy 20120223
					hyperlink = "<IMG name='ppp' src='images/search.gif' width='20' height='20' border=0 alt='' onClick='subWindowFOBPointFind(null,"+x+")' title='請按我!'>";
					out.println("<td><input type='text' size='10' style='font-size:11px;font-family: Tahoma,Georgia;background-color:#FFFF66' name='FOB"+x+"' value='"+lineFob+"'>"+hyperlink+"</td>");  //Add by Peggy 20120329
					out.println("<td><input type='text' size='4' style='font-size:11px;font-family: Tahoma,Georgia;' name='ENDCUSTID"+x+"' value='"+erpEndCustID+"' readonly>");
					out.println("<input type='hidden' name='ENDCUST"+x+"' value='"+erpEndCustomer+"'>");
					out.println("</td>");  //Add by Peggy 20140822
					out.println("</tr>");
					x++;
					array2DimensionInputBean.setArray2DString(arr);
				}
			}
			catch (Exception e)
			{
				//out.println("</table></td></tr></table>");
				//out.println("<p><table width='100%'><tr><td align='center'><font style='color:#ff0000;font-size:12px'>Exception:"+e.getMessage()+"</font></td></tr></table>");
				out.println("<font style='color:#ff0000;font-size:12px'>Exception:"+e.getMessage()+"</font>");
				err_cnt ++;
			}
		}
		lineCnt = (x-1);
		out.println("</table></td></tr></table>");
		if (err_cnt==0)
		{
			//out.println("</table></tr></table>");
	%>
	<script language="JavaScript" type="text/JavaScript">
		document.DISPLAYREPAIR.Submit.disabled=false;
	</script>
	<%
				}
				rss.close();
				statements.close();
			}
			catch (Exception e)
			{
				out.println("Exception1:"+e.getMessage());
			}
		}
		catch(Exception e)
		{
			out.println(e.getMessage());
		}

	%>
	<input type="hidden" name="seqno" value="<%=seqno%>">
	<input type="hidden" name="customerPO_Easy" value="<%=customerPO_Easy%>">
	<input type="hidden" name="SalesAreaNo" value="<%=salesAreaNo%>">
	<input type="hidden" name="lineCnt" value="<%=lineCnt%>">
	<BR>
	<BR>

</FORM>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
 
