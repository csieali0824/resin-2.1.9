<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Invoice Number Status Query</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	if (document.MYFORM.INVOICE_YEAR.value=="--" ||document.MYFORM.INVOICE_YEAR.value==null)
	{
		alert("Please input the invoice year!");
		document.MYFORM.INVOICE_YEAR.focus();
		return false;
	}
	if ((document.MYFORM.INVOICEDATE.value!="" && document.MYFORM.INVOICEDATEEND.value=="") || (document.MYFORM.INVOICEDATE.value=="" && document.MYFORM.INVOICEDATEEND.value!=""))
	{	
		alert("Please input the search start date and end date!");
		if (document.MYFORM.INVOICEDATE.value=="")
		{
			document.MYFORM.INVOICEDATE.focus();
		}
		else
		{
			document.MYFORM.INVOICEDATEEND.focus();
		}
		return false;	
	}	
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setUpload(URL)
{
	subWin=window.open(URL,"subwin","left=100,width=840,height=880,scrollbars=yes,menubar=no");  
}

function setExcel(URL)
{
	if (document.MYFORM.INVOICE_YEAR.value=="--" ||document.MYFORM.INVOICE_YEAR.value==null)
	{
		alert("Please input the invoice year!");
		document.MYFORM.INVOICE_YEAR.focus();
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setAutoCheck()
{
	if (document.MYFORM.AUTOCHK.checked)
	{
		document.MYFORM.chkall.checked=false;
		checkall();
		document.MYFORM.INVOICECNT.value="";
		document.MYFORM.INVOICECNT.disabled=false;
		document.MYFORM.INVOICESNO.value="";
		document.MYFORM.INVOICESNO.disabled=false;
		for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
		{
			document.MYFORM.rdo1[i].checked=false;
			document.MYFORM.rdo1[i].disabled=false;
		}		
	}
	else
	{
		document.MYFORM.INVOICECNT.value="";
		document.MYFORM.INVOICECNT.disabled=true;
		document.MYFORM.INVOICESNO.value="";
		document.MYFORM.INVOICESNO.disabled=true;
		for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
		{		
			document.MYFORM.rdo1[i].checked=false;
			document.MYFORM.rdo1[i].disabled=true;
		}
	}
}

function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =1 ; i <= document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i-1].disabled==false)
			{
				document.MYFORM.chk[i-1].checked= document.MYFORM.chkall.checked;
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
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.MYFORM.AUTOCHK.checked=false;
		setAutoCheck();
		document.getElementById("tr_"+irow).style.backgroundColor ="#D8E2E9";
		document.getElementById("INVOICENO_"+irow).style.visibility="visible";
		document.getElementById("INVOICENO_"+irow).style.width="90px";
		document.getElementById("INVOICENO_"+irow).value=document.MYFORM.elements["INVOICESEQ_"+irow].value;
		document.getElementById("INVOICEDATE_"+irow).style.visibility="visible";
		document.getElementById("INVOICEDATE_"+irow).style.width="55px";
		document.getElementById("INVOICEDATE_"+irow).value=document.MYFORM.SYSDATE.value;
		document.getElementById("SALESGROUP_"+irow).style.visibility="visible";
		document.getElementById("SALESGROUP_"+irow).style.width="55px";
		document.getElementById("SHIPPINGMARKS_"+irow).style.visibility="visible";
		document.getElementById("SHIPPINGMARKS_"+irow).style.width="120px";
		document.getElementById("SHIPMETHOD_"+irow).style.visibility="visible";
		document.getElementById("SHIPMETHOD_"+irow).style.width="55px";
		document.getElementById("CURRENCY_"+irow).style.visibility="visible";
		document.getElementById("CURRENCY_"+irow).style.width="30px";
		document.getElementById("ORDER_"+irow).style.visibility="visible";
		document.getElementById("ORDER_"+irow).style.width="230px";
		document.getElementById("SOURCENO_"+irow).style.visibility="visible";
		document.getElementById("SOURCENO_"+irow).style.width="80px";
		document.getElementById("REMARKS_"+irow).style.visibility="visible";
		document.getElementById("REMARKS_"+irow).style.width="60px";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		document.getElementById("INVOICENO_"+irow).style.visibility="hidden";
		document.getElementById("INVOICENO_"+irow).style.width="0px";
		document.getElementById("INVOICEDATE_"+irow).style.visibility="hidden";
		document.getElementById("INVOICEDATE_"+irow).style.width="0px";
		document.getElementById("SALESGROUP_"+irow).style.visibility="hidden";
		document.getElementById("SALESGROUP_"+irow).style.width="0px";
		document.getElementById("SHIPPINGMARKS_"+irow).style.visibility="hidden";
		document.getElementById("SHIPPINGMARKS_"+irow).style.width="0px";
		document.getElementById("SHIPMETHOD_"+irow).style.visibility="hidden";
		document.getElementById("SHIPMETHOD_"+irow).style.width="0px";
		document.getElementById("CURRENCY_"+irow).style.visibility="hidden";
		document.getElementById("CURRENCY_"+irow).style.width="0px";
		document.getElementById("ORDER_"+irow).style.visibility="hidden";
		document.getElementById("ORDER_"+irow).style.width="0px";
		document.getElementById("SOURCENO_"+irow).style.visibility="hidden";
		document.getElementById("SOURCENO_"+irow).style.width="0px";		
		document.getElementById("REMARKS_"+irow).style.visibility="hidden";
		document.getElementById("REMARKS_"+irow).style.width="0px";		
	}
}

function setUpdate(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
		if (chkflag)
		{
			document.MYFORM.chk[irow-1].checked=false;
		}
		else
		{
			document.MYFORM.chk[irow-1].checked=true;
		}
		
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
		if (chkflag)
		{
			document.MYFORM.chk.checked=false;
		}
		else
		{
			document.MYFORM.chk.checked=true;
		}
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#D8E2E9";
		document.getElementById("SHIPPINGMARKS_"+irow).style.visibility="visible";
		document.getElementById("SHIPPINGMARKS_"+irow).style.width="120px";
		document.getElementById("SOURCENO_"+irow).style.visibility="visible";
		document.getElementById("SOURCENO_"+irow).style.width="80px";
		document.getElementById("REMARKS_"+irow).style.visibility="visible";
		document.getElementById("REMARKS_"+irow).style.width="60px";
		document.getElementById("diva_"+irow).style.visibility="hidden";
		document.getElementById("divb_"+irow).style.visibility="hidden";
		document.getElementById("divd_"+irow).style.visibility="hidden";
		document.getElementById("imga_"+irow).style.visibility="hidden";
		document.getElementById("imgc_"+irow).style.visibility="visible";
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		document.getElementById("SHIPPINGMARKS_"+irow).style.visibility="hidden";
		document.getElementById("SHIPPINGMARKS_"+irow).style.width="0px";
		document.getElementById("SOURCENO_"+irow).style.visibility="hidden";
		document.getElementById("SOURCENO_"+irow).style.width="0px";		
		document.getElementById("REMARKS_"+irow).style.visibility="hidden";
		document.getElementById("REMARKS_"+irow).style.width="0px";		
		document.getElementById("diva_"+irow).style.visibility="visible";
		document.getElementById("divb_"+irow).style.visibility="visible";
		document.getElementById("divd_"+irow).style.visibility="visible";
		document.getElementById("imga_"+irow).style.visibility="visible";
		document.getElementById("imgc_"+irow).style.visibility="hidden";
	}
}
function setSave()
{
	setSubmit("../jsp/TSShippingInvoiceNumberProcess.jsp?ATYPE=UPD");
}
function setSubmit(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.AUTOCHK.checked)
	{
		if (document.MYFORM.INVOICE_YEAR.value=="--" ||document.MYFORM.INVOICE_YEAR.value==null)
		{
			alert("Please input the invoice year!");
			document.MYFORM.INVOICE_YEAR.focus();
			return false;
		}	
		if (document.MYFORM.INVOICECNT.value=="")
		{
			alert("請輸入發票張數!!");
			document.MYFORM.INVOICECNT.focus;
			return false;
		}
		for (var i =0 ; i <document.MYFORM.rdo1.length ;i++)
		{
			if (document.MYFORM.rdo1[i].checked) chkcnt++;
		}
		if (chkcnt==0)
		{
			alert("請指定是否需要連號??");
			return false;			
		}			
	}
	else
	{
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
				if (document.MYFORM.elements["INVOICENO_"+lineid].value==null || document.MYFORM.elements["INVOICENO_"+lineid].value =="")
				{
					alert("發票號碼必須輸入!!");
					document.MYFORM.elements["INVOICENO_"+lineid].focus;
					return false;
				}
				else if (document.MYFORM.elements["INVOICENO_"+lineid].value.length<document.MYFORM.elements["INVOICESEQ_"+lineid].length)
				{
					alert("發票號碼長度有誤!!");
					document.MYFORM.elements["INVOICENO_"+lineid].focus;
					return false;
				}
				else if (document.MYFORM.elements["INVOICENO_"+lineid].value.substr(0,document.MYFORM.elements["INVOICESEQ_"+lineid].value.length) != document.MYFORM.elements["INVOICESEQ_"+lineid].value)
				{
					alert("發票號碼前九碼必須與發票序號相同!!");
					document.MYFORM.elements["INVOICENO_"+lineid].focus;
					return false;			
				}
				if (document.MYFORM.elements["REMARKS_"+lineid].value!=null && document.MYFORM.elements["REMARKS_"+lineid].value.toUpperCase().indexOf("DELTA")>=0)
				{
					if (document.MYFORM.elements["SOURCENO_"+lineid].value==null || document.MYFORM.elements["SOURCENO_"+lineid].value=="")
					{
						alert("預支DELTA發票號時,請務必填寫來源單據號碼!!");
						document.MYFORM.elements["SOURCENO_"+lineid].focus;
						return false;
					}
					else if (document.MYFORM.elements["SOURCENO_"+lineid].value.toUpperCase().indexOf("EW2")>=0 || document.MYFORM.elements["SOURCENO_"+lineid].value.toUpperCase().indexOf("SGT-")>=0)
					{
						if (document.MYFORM.elements["SHIPPINGMARKS_"+lineid].value==null || document.MYFORM.elements["SHIPPINGMARKS_"+lineid].value =="")
						{
							alert("預支DELTA發票號時,請務必填DELTA PO前四碼在客戶欄位上!!");
							document.MYFORM.elements["SHIPPINGMARKS_"+lineid].focus;
							return false;
						}
						else if (document.MYFORM.elements["SHIPPINGMARKS_"+lineid].value.length<4)
						{
							alert("字數不足,請填DELTA PO前四碼在客戶欄位上!!");
							document.MYFORM.elements["SHIPPINGMARKS_"+lineid].focus;
							return false;					
						}
					}
				}
				chkcnt ++;
			}
			
		}
		if (chkcnt <=0)
		{
			alert("請先勾選發票號!");
			return false;
		}
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.btnQuery.disabled=true;
	document.MYFORM.btnSubmit.disabled=true;
	document.MYFORM.btnExcel.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setOpt(choosevalue)
{
	if (choosevalue=="UNUSED")
	{
		document.MYFORM.btnSubmit.disabled=false;
		document.MYFORM.INVOICE_NO.disabled=true;
		document.MYFORM.SALES_GROUP.disabled=true;
		document.MYFORM.SHIPPING_MARKS.disabled=true;
		document.MYFORM.SHIPPING_METHOD.disabled=true;
		document.MYFORM.MO_NO.disabled=true;
		document.MYFORM.SOURCE_NO.disabled=true;
		document.MYFORM.INVOICE_NO.value="";
		document.MYFORM.SALES_GROUP.value="";
		document.MYFORM.SHIPPING_MARKS.value="";
		document.MYFORM.SHIPPING_METHOD.value="";
		document.MYFORM.MO_NO.value="";
		document.MYFORM.SOURCE_NO.value="";		
		document.MYFORM.MAX_ROW.value="100";
	}
	else
	{
		document.MYFORM.btnSubmit.disabled=true;
		document.MYFORM.INVOICE_NO.disabled=false;
		document.MYFORM.SALES_GROUP.disabled=false;
		document.MYFORM.SHIPPING_MARKS.disabled=false;
		document.MYFORM.SHIPPING_METHOD.disabled=false;
		document.MYFORM.MO_NO.disabled=false;
		document.MYFORM.SOURCE_NO.disabled=false;
		document.MYFORM.MAX_ROW.value="";
	
	}
	//setQuery("../jsp/TSShippingInvoiceNumberQuery.jsp");	
}
function monchange()
{
	document.MYFORM.MAX_ROW.value="";
}

function onRelease(invoiceno)
{
	if (confirm("Are you sure to release the invoice number:"+invoiceno.replace("*","T-")))
	{
		setQuery("../jsp/TSShippingInvoiceNumberQuery.jsp?ATYPE=RELEASE&INNO="+invoiceno);	
	}
}
</script>
<STYLE TYPE='text/css'> 
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<%
response.setHeader("refresh" , "120" ); 
String sql = "";
String INVOICE_YEAR=request.getParameter("INVOICE_YEAR");
if (INVOICE_YEAR==null || INVOICE_YEAR.equals("--")) INVOICE_YEAR=dateBean.getYearString();
String INVOICE_MONTH=request.getParameter("INVOICE_MONTH");
if (INVOICE_MONTH==null || INVOICE_MONTH.equals("--")) INVOICE_MONTH="";
String INVOICE_NO=request.getParameter("INVOICE_NO");
if (INVOICE_NO==null) INVOICE_NO="";
String INVOICEDATE=request.getParameter("INVOICEDATE");
if (INVOICEDATE==null) INVOICEDATE="";
String INVOICEDATEEND=request.getParameter("INVOICEDATEEND");
if (INVOICEDATEEND==null) INVOICEDATEEND="";
String SALES_GROUP=request.getParameter("SALES_GROUP");
if (SALES_GROUP==null) SALES_GROUP="";
String SHIPPING_MARKS=request.getParameter("SHIPPING_MARKS");
if (SHIPPING_MARKS==null) SHIPPING_MARKS="";
String SHIPPING_METHOD=request.getParameter("SHIPPING_METHOD");
if (SHIPPING_METHOD==null) SHIPPING_METHOD="";
String MO_NO=request.getParameter("MO_NO");
if (MO_NO==null) MO_NO="";
String SOURCE_NO=request.getParameter("SOURCE_NO");
if (SOURCE_NO==null) SOURCE_NO="";
String V_STATUS=request.getParameter("rdo_status");
if (V_STATUS==null) V_STATUS="UNUSED";
//String AUTOFLAG=request.getParameter("AUTOCHK");
//if (AUTOFLAG==null) AUTOFLAG="";
String AUTOFLAG="";
String V_CONT=request.getParameter("rdo1");
if (V_CONT==null) V_CONT="";
String max_row = request.getParameter("MAX_ROW");
//--START 20211228 BY PEGGY 
String ATYPE=request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String INNO=request.getParameter("INNO");
if (INNO==null) INNO="";
boolean b_release_flag =false;

if (ATYPE.equals("RELEASE"))
{
	if (!INNO.equals(""))
	{
		sql = " SELECT COUNT(1)  FROM TSC_INVOICE_HEADERS A WHERE SUBSTR(INVOICE_NO,1,LENGTH(?))=?";	
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,INNO.replace("*","T-"));
		statement.setString(2,INNO.replace("*","T-"));
		ResultSet rs=statement.executeQuery();			
		if (rs.next()) 
		{
			if (rs.getInt(1)==0)
			{
				b_release_flag=true;	
			}
		}
		rs.close();
		statement.close();	
		
		if (b_release_flag)
		{	
			CallableStatement cs1 = con.prepareCall("{call tsc_shipping_invoice_pkg.RELEASE_INVOICE_SEQ(?,?)}");
			cs1.setString(1,INNO.replace("*","T-"));    
			cs1.setString(2,UserName);    
			cs1.execute();
			cs1.close();	
			con.commit();
			V_STATUS="UNUSED";
		}
		else
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("The invoice number cannot be released because the invoice has already been generated!");
			document.MYFORM.submit();		
		</script>	
		<%
		}
	}
}
//--END 20211228 BY PEGGY

if (max_row==null || max_row.equals("") || !INVOICEDATE.equals(""))
{
	if (V_STATUS.equals("UNUSED"))
	{
		max_row="100";
	}
	else
	{
		if (V_STATUS.equals("USED") && INVOICEDATE.equals("") && INVOICE_MONTH.equals(""))
		{
			max_row="200";
		}
		else
		{
			try
			{
			
				sql = "select count(1) from  oraddman.TSC_SHIPPING_INVOICE_DETAIL tsid where tsid.INVOICE_YEAR="+INVOICE_YEAR+"";
				if (V_STATUS.equals("USED"))
				{
					sql += " and tsid.INVOICE_DATE is not null";		
				}
				if (!INVOICE_MONTH.equals(""))
				{
					sql += " and TO_NUMBER(TO_CHAR(nvl(pickup_date,tsid.INVOICE_DATE),'MM'))="+INVOICE_MONTH+" ";		
				}				
				if (!INVOICEDATE.equals(""))
				{
					sql += " and nvl(pickup_date,tsid.INVOICE_DATE) between TO_DATE('"+INVOICEDATE+"','YYYYMMDD') and TO_DATE('"+INVOICEDATE+"','YYYYMMDD')+0.99999 ";		
				}
				Statement statementt=con.createStatement(); 
				ResultSet rss=statementt.executeQuery(sql);
				if (rss.next()) 
				{
					max_row =rss.getString(1);
					if (max_row.equals("0")) max_row="100";
				}
				else
				{
					max_row="100";
				}
				rss.close();
				statementt.close();
			}
			catch(Exception e)
			{
				max_row="2000";
			}	
		}	
	}
}
	
int rowcnt=0;
if (UserRoles==null || (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("TSC_Shipping")<0))
{
%>
		<script language="JavaScript" type="text/JavaScript">
			alert("您無此功能權限,請洽系統管理人員...");
			location.href("../jsp/Logout.jsp");
		</script>	
<%	
}
%>
<body> 
<FORM ACTION="../jsp/TSShippingInvoiceNumberQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Invoice Number Status Query</div>
<div align="right"><A HREF="../jsp/Logout.jsp" style="font-size:11px">登出</A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#ffffff" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE border="1" cellpadding="1" cellspacing="0" width="100%" bgcolor="#CFDAC9" bordercolorlight="#333366" bordercolordark="#ffffff">
	<tr>
		<td width="6%" style="font-size:11px" align="center">發票年度/月份</td>
		<td width="8%">
		<%
		try
		{   
			sql = "select distinct invoice_year,invoice_year invoice_year1 from oraddman.TSC_SHIPPING_INVOICE_DETAIL order by invoice_year";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(INVOICE_YEAR);
			comboBoxBean.setFieldName("INVOICE_YEAR");	 
			comboBoxBean.setOnChangeJS("monchange()");	 
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}	
		try
		{   
			sql = "SELECT ROWNUM AS MONTHS,ROWNUM AS MONTHS1 FROM DUAL CONNECT BY ROWNUM<=12";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(INVOICE_MONTH);
			comboBoxBean.setFieldName("INVOICE_MONTH");
			comboBoxBean.setOnChangeJS("monchange()");	 
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
		<td width="4%" align="center" rowspan="3">發票號碼</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="INVOICE_NO"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=INVOICE_NO%></textarea></td>
		<td width="4%" align="center" rowspan="3">業務區</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="SALES_GROUP"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=SALES_GROUP%></textarea></td>
		<td width="3%" align="center" rowspan="3">客戶</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="SHIPPING_MARKS"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=SHIPPING_MARKS%></textarea></td>
		<td width="4%" align="center" rowspan="3">出貨方式</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="SHIPPING_METHOD"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=SHIPPING_METHOD%></textarea></td>
		<td width="4%" align="center" rowspan="3">訂單號碼</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="MO_NO"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=MO_NO%></textarea></td>
		<td width="6%" align="center" rowspan="3">來源單據號碼</td>
		<td width="10%" rowspan="3"><textarea cols="20" rows="8" name="SOURCE_NO"  style="font-family: Tahoma,Georgia;font-size:11px" <%=(V_STATUS.equals("UNUSED")?"disabled":"")%>><%=SOURCE_NO%></textarea></td>
	</tr>
	<tr>
		<td style="font-size:11px" align="center">發票取號日期</td>
		<td>
		<input type="text" size="6" name="INVOICEDATE" style="font-family: Tahoma,Georgia;font-size:11px" value="<%=INVOICEDATE%>">
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.INVOICEDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="text" size="6" name="INVOICEDATEEND" style="font-family: Tahoma,Georgia;font-size:11px" value="<%=INVOICEDATEEND%>">
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.INVOICEDATEEND);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
	</tr>
	<tr>		
		<td style="font-size:11px" align="center">發票使用狀態</td>
		<td>
		    <input type="radio" name="rdo_status" value="ALL" <%=(V_STATUS.equals("ALL")?"checked":"")%> onClick="setOpt('ALL')">
		    全部<br>
		    <input type="radio" name="rdo_status" value="USED" <%=(V_STATUS.equals("USED")?"checked":"")%> onClick="setOpt('USED')">
		    已使用<br>
		    <input type="radio" name="rdo_status" value="UNUSED" <%=(V_STATUS.equals("UNUSED")?"checked":"")%> onClick="setOpt('UNUSED')">
		    未使用<br>(顯示<input type="text" name="MAX_ROW" value="<%=max_row%>" size="5" maxlength="5" style="font-family: Tahoma,Georgia;text-align:center;border-bottom-color:#000000;background-color:#CFDAC9;border-top:none;border-right:none;border-left:none;font-size:11px" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)">號)
	    </td>
	</tr>
	<tr>
		<td colspan="14" align="center">
		<input type="button" name="btnQuery" value="查詢"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSShippingInvoiceNumberQuery.jsp')">
		&nbsp;&nbsp;
		<input type="button" name="btnExcel" value="匯出EXCEL"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSShippingInvoiceNumberReport.jsp')">
		&nbsp;&nbsp;
		<input type="button" name="btnUpload" value="1211/1215上傳"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload('../jsp/TSShippingInvoiceNumberUpload.jsp')">
		</td>
	</tr>
</TABLE>
<hr>
<input type="checkbox" name="AUTOCHK" value="Y" onClick="setAutoCheck()"><font style="font-size:12px">自動取</font><input type="text" name="INVOICECNT" value="" size="2" maxlength="2" style="font-weight:bold;color:#0033CC;font-family:Tahoma,Georgia;font-size:12px" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" <%=(AUTOFLAG.equals("Y")?" ":"disabled")%>>
&nbsp;<font style="font-size:12px">張發票</font>
<input type="radio" name="rdo1" value="Y" <%=(V_CONT.equals("Y")?"checked":"")%> <%=(!AUTOFLAG.equals("Y")?" disabled":"")%>>
<font style="font-size:12px">需連號，從尾碼<input type="text" name="INVOICESNO" value="" size="1" maxlength="1" style="font-weight:bold;color:#0033CC;font-family:Tahoma,Georgia;font-size:12px" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" <%=(AUTOFLAG.equals("Y")?" ":"disabled")%>>&nbsp;開始</font>
<input type="radio" name="rdo1" value="N" <%=(V_CONT.equals("N")?"checked":"")%> <%=(!AUTOFLAG.equals("Y")?" disabled":"")%>><font style="font-size:12px">不需連號</font>
<input type="button" name="btnSubmit" value="人工取號"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setSubmit('../jsp/TSShippingInvoiceNumberProcess.jsp')">
<br>
<%
String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{
	if (V_STATUS.equals("UNUSED"))
	{
		sql = " SELECT tsid.INVOICE_SEQ"+
			  ",tsid.INVOICE_YEAR"+
			  ",to_char(tsid.INVOICE_DATE,'yyyymmdd') INVOICE_DATE"+
			  ",tsid.INVOICE_NUMBER"+
			  ",tsid.SALES_GROUP as SALES_GROUP"+
			  ",tsid.SHIPPING_MARKS as SHIPPING_MARKS"+
			  ",tsid.SHIPPING_METHOD as SHIPPING_METHOD"+
			  ",tsid.CURRENCY_CODE as CURRENCY_CODE"+
			  ",tsid.ORDER_TYPE as ORDER_LIST"+
			  ",tsid.SOURCE_REFERENCE_NO as SOURCE_NO_LIST"+
			  ",to_char(tsid.CREATION_DATE,'yyyymmdd') CREATION_DATE"+
			  ",tsid.CREATED_BY"+
			  ",to_char(tsid.LAST_UPDATE_DATE ,'yyyymmdd') as LAST_UPDATE_DATE"+
			  ",tsid.LAST_UPDATED_BY as LAST_UPDATED_BY"+
			  ",tsid.REMARKS"+
			  ",null pickup_date"+
			  ",row_number() over (partition by tsid.invoice_year order by tsid.invoice_seq) row_seq"+
			  ",null SHIPPINGMARK"+
			  ",0 invoice_cnt"+
			  " from oraddman.tsc_shipping_invoice_detail tsid"+	
			  " where tsid.INVOICE_YEAR="+INVOICE_YEAR+""+
			  " and tsid.INVOICE_NUMBER is null";
	}
	else
	{
		sql = " SELECT tsid.INVOICE_SEQ"+
			  ",tsid.INVOICE_YEAR"+
			  ",to_char(tsid.INVOICE_DATE,'yyyymmdd') INVOICE_DATE"+
			  ",NVL(ship.INVOICE_NO,tsid.INVOICE_NUMBER) INVOICE_NUMBER"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END SALES_GROUP"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN y.SHIPPING_MARKS_list ELSE tsid.SHIPPING_MARKS END SHIPPING_MARKS"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.SHIPPING_METHOD_CODE ELSE tsid.SHIPPING_METHOD END SHIPPING_METHOD"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.CURRENCY_CODE ELSE tsid.CURRENCY_CODE END CURRENCY_CODE"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.ORDER_NUMBER_LIST ELSE tsid.ORDER_TYPE END ORDER_LIST"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN nvl(ship.SOURCE_NO_LIST,tsid.SOURCE_REFERENCE_NO) ELSE tsid.SOURCE_REFERENCE_NO END  SOURCE_NO_LIST"+
			  ",to_char(tsid.CREATION_DATE,'yyyymmdd') CREATION_DATE"+
			  ",tsid.CREATED_BY"+
			  //",to_char(CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.LAST_UPDATE_DATE ELSE tsid.LAST_UPDATE_DATE END,'yyyymmdd') LAST_UPDATE_DATE"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN ship.LAST_UPDATE_BY ELSE tsid.LAST_UPDATED_BY END LAST_UPDATED_BY"+
			  ",CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL OR ORDER_NUMBER_LIST IS NOT NULL THEN NVL(ship.remarks,tsid.REMARKS) else tsid.REMARKS end REMARKS"+
			  ",row_number() over (partition by tsid.invoice_year order by tsid.invoice_seq "+(V_STATUS.equals("USED")?" desc" :"")+") row_seq"+
			  ",to_char(ship.pickup_date,'yyyymmdd') pickup_date"+
			  ",case when ship.SALES_GROUP='TSCE' and ship.SHIPPING_METHOD_CODE in ('AIR(C)','SEA(C)') then replace(TSC_SHIPPING_INVOICE_PKG.GET_INVOICE_SHIPPING_MARKS(NVL(ship.INVOICE_NO,tsid.INVOICE_NUMBER)),chr(10),'<br>') else '' end as SHIPPINGMARK"+ //add by Peggy 20211201
			  ",nvl2(y.invoice_seq,1,0)+ nvl((select distinct 1 from TSC_PICKTEMP_INVOICE_HEADERS xx where instr(xx.attribute1,tsid.INVOICE_SEQ)>0),0) invoice_cnt"+ //add by Peggy 20230616
			  " FROM oraddman.tsc_shipping_invoice_detail tsid"+
			  " ,(SELECT DISTINCT new_dn.*,substr(new_dn.invoice_no,1,9) invoice_seq "+
			  "   FROM (SELECT distinct dn.invoice_no,dn.sales_group,dn.shipping_method_code,dn.currency_code"+
			  //"         ,listagg(dn.shipping_marks,'/') within group(order by dn.shipping_marks) over (partition by dn.invoice_no) shipping_marks"+
			  "         ,listagg(dn.order_number,'/') within group(order by dn.order_number) over (partition by dn.invoice_no) order_number_list"+
			  "         ,listagg(dn.source_no,'/') within group(order by dn.source_no) over (partition by dn.invoice_no) source_no_list"+
			  "         ,listagg(dn.erp_dn_name,'/') within group(order by dn.erp_dn_name) over (partition by dn.invoice_no) erp_dn_name_list"+
			  //"         ,dn.last_update_date"+
			  "         ,dn.last_update_by"+
			  "         ,dn.pickup_date"+
			  "         ,'' remarks"+
			  "          FROM (SELECT DISTINCT  dn_t.invoice_no,"+
			  "                 dn_t.sales_group,"+
			  "                 dn_t.shipping_method_code,"+
			  "                 dn_t.currency_code,"+
			  "                 dn_t.order_number,"+
			  "                 listagg (dn_t.source_no, '/') WITHIN GROUP (ORDER BY dn_t.source_no) OVER (PARTITION BY dn_t.invoice_no) source_no,"+
			  "                 listagg(dn_t.erp_dn_name,'/') WITHIN GROUP (ORDER BY dn_t.erp_dn_name) OVER (PARTITION BY dn_t.invoice_no) erp_dn_name,"+
			  "                 dn_t.last_update_by,"+
			  "                 dn_t.pickup_date"+
			  "          		FROM (SELECT distinct dn_d.invoice_no,dn_d.sales_group,dn_d.shipping_method_code,dn_d.currency_code"+
			  "                		,listagg(dn_d.order_number,'/') WITHIN GROUP (ORDER BY dn_d.order_number) over (partition by dn_d.invoice_no) order_number"+
			  "                		,dn_d.source_no"+
			  "                		,dn_d.erp_dn_name"+
			  //"                	,dn_d.last_update_date"+
			  "                		,dn_d.last_update_by"+
			  "                		,dn_d.pickup_date"+
			  //"        				FROM (SELECT distinct to_char(tih.pickup_date,'yyyymmdd') pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP"+
			  //"        				FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP"+
			  "        				FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,TSC_OM_Get_Sales_Group(til.order_header_id) SALES_GROUP"+  //modify by Peggy 20220531
			  "                      	 ,tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS,tih.shipping_method_code,tih.currency_code"+
			  "                      	 ,til.order_number"+
			  //"                        	,til.bvi_invoice_no source_no"+
			  "                         ,til.bvi_invoice_no||case when instr(til.bvi_invoice_no,'SGT-')>0 THEN '('|| (select DISTINCT ADVISE_NO from TSC.TSC_ADVISE_DN_HEADER_INT y WHERE y.STATUS='S' AND y.INVOICE_NO=til.bvi_invoice_no)||')' ELSE '' END as source_no"+ //modify by Peggy 20230615
			  "                       	,til.ship_transaction_name erp_dn_name"+
			  //"                       ,tih.creation_date last_update_date"+
			  "                       	,tih.created_by last_update_by"+
			  "                        	FROM tsc_invoice_lines til"+
			  "                        	,tsc_invoice_headers tih"+
			  "                        	WHERE  til.invoice_no=tih.invoice_no"+
			  "                        	and til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%'"+
			  "                        	and til.order_header_id is not null"+
			  "                         ?01"+
			  "                        	and not exists (select wnd.name from wsh.wsh_new_deliveries wnd where wnd.name like 'T-%' and case when substr(til.ship_transaction_name,1,2)<>'T-' then til.invoice_no else til.ship_transaction_name end =wnd.name)"+
			  "                       	) dn_d"+
			  "                      ) dn_t"+
			  "                  ) dn"+
			  "          UNION ALL"+
			  "          SELECT distinct dn.invoice_no,dn.sales_group,dn.shipping_method_code,dn.currency_code"+
			  "               ,listagg(dn.order_number,'/') within group(order by dn.order_number) over (partition by dn.invoice_no) order_number_list"+
			  "               ,dn.source_no source_no_list"+
			  "               ,dn.erp_dn_no erp_dn_name_list"+
			  //"               ,dn.last_update_date"+
			  "               ,dn.last_update_by"+
			  "               ,dn.pickup_date"+
			  "               ,dn.remarks ||"+
			  "               (SELECT NVL(E.vendor_name_alt,E.vendor_name)||'直出' AS VENDOR_DIRECT_DELIVERY"+
              "                FROM inv.mtl_material_transactions A,inv.mtl_transaction_lot_numbers B,po.rcv_transactions C,PO_HEADERS_ALL D,AP_SUPPLIERS E"+
              "                     ,tsc.tsc_pick_confirm_lines F,tsc.tsc_pick_confirm_headers G"+
              "                WHERE A.ORGANIZATION_ID=49"+
              "                AND A.TRANSACTION_ID=B.TRANSACTION_ID"+
              "                AND A.TRANSACTION_TYPE_ID=18"+
              "                AND B.LOT_NUMBER=F.LOT"+
              "                AND B.PRIMARY_QUANTITY>0"+
              "                AND F.ADVISE_HEADER_ID=G.ADVISE_HEADER_ID"+
              "                AND G.ADVISE_NO=dn.source_no"+
              "                AND G.file_id IS NOT NULL"+
              "                AND F.PRODUCT_GROUP='PMD'"+
              "                AND A.rcv_transaction_id=C.transaction_id"+
              "                AND C.po_header_id=D.po_header_id"+
              "                AND D.vendor_id=E.vendor_id"+
              "                AND ROWNUM=1) AS remarks"+
			  //"               FROM (SELECT distinct to_char(tih.pickup_date,'yyyymmdd') pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP,"+
			  //"               FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,Tsc_Intercompany_Pkg.get_sales_group(til.order_header_id) SALES_GROUP,"+
			  "               FROM (SELECT distinct trunc(tih.pickup_date) pickup_date, til.invoice_no,TSC_OM_Get_Sales_Group(til.order_header_id) SALES_GROUP,"+  //modify by Peggy 20220531
			  "                    tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS,tih.shipping_method_code,tih.currency_code,"+
			  "                    til.order_number"+
			  //"                    ,x.advise_no source_no"+
			  "                    ,(select advise_no from tsc.tsc_advise_dn_header_int y where y.status='S' and substr(y.invoice_no,1,9)= substr(til.ship_transaction_name,1,9))  source_no "+
			  "                    ,x.delivery_name erp_dn_no"+
			  //"                    ,tih.creation_date last_update_date"+
			  "                    ,tih.created_by last_update_by"+
			  "                    ,case when substr(til.order_number,1,4)=1181 then case when instr(RELEASE,'內銷')>0 THEN '內銷'  when instr(RELEASE,'外銷')>0 THEN '外銷' ELSE '' END ELSE '' END REMARKS"+
			  "                    FROM tsc_invoice_lines til"+
			  "                    ,tsc_invoice_headers tih"+
			  //"                    ,(select tadli.invoice_no,tadli.advise_no,listagg(tadli.delivery_name,'/') within group(order by tadli.delivery_name) over (partition by tadli.invoice_no,tadli.advise_no) delivery_name from (select distinct a.invoice_no,a.advise_no,b.delivery_name from tsc.tsc_advise_dn_line_int b,tsc.tsc_advise_dn_header_int a where a.status='S' and a.interface_header_id=b.interface_header_id AND a.advise_header_id=b.advise_header_id) tadli) x  "+
			  "                    ,(select substr(wnd.name,1,9) invoice_no,listagg(wnd.name,'/') within group (order by wnd.name) over (partition by substr(wnd.name,1,9)) delivery_name  from wsh.wsh_new_deliveries wnd where wnd.name like 'T-%') x"+
			  "                    WHERE  til.invoice_no=tih.invoice_no"+
			  "                    AND til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%'"+
			  "                    AND til.ship_transaction_name LIKE 'T-%'"+
			  "                    and til.order_header_id is not null"+
			  "                    ?01"+
			  "                    and substr(til.ship_transaction_name,1,9)=x.invoice_no"+
			  "                 ) dn"+
			  "          ) new_dn"+
			  "      ) ship"+
			  "    ,(select distinct x.invoice_no,substr(x.invoice_no,1,9) invoice_seq, listagg(x.SHIPPING_MARKS,'/') within group(order by x.SHIPPING_MARKS) over (partition by x.invoice_no) SHIPPING_MARKS_list from (select  distinct til.invoice_no,tsc_get_remark_desc(til.order_header_id,'SHIPPING MARKS') SHIPPING_MARKS  from tsc_invoice_lines til where til.invoice_no LIKE 'T-"+INVOICE_YEAR.substring(2)+"%') x) y"+
			  //" WHERE tsid.invoice_number=ship.invoice_no(+)";
			  " WHERE tsid.invoice_seq=ship.invoice_seq(+)"+
			  " and tsid.invoice_seq=y.invoice_seq(+)";
		if (V_STATUS.equals("USED"))
		{
			sql += " and tsid.INVOICE_NUMBER is not null";
		} 
		if (!INVOICE_YEAR.equals(""))
		{
			sql += " and tsid.INVOICE_YEAR="+INVOICE_YEAR+"";
		}	
		if (!INVOICE_MONTH.equals(""))
		{
			sql += " and TO_NUMBER(TO_CHAR(nvl(pickup_date,tsid.INVOICE_DATE),'MM'))="+INVOICE_MONTH+"";
		}		
		//if (!INVOICEDATE.equals(""))
		if (!INVOICEDATE.equals("") || !INVOICEDATEEND.equals(""))
		{
			sql += " and nvl(pickup_date,tsid.INVOICE_DATE) between TO_DATE('"+INVOICEDATE+"','YYYYMMDD') and TO_DATE('"+INVOICEDATEEND+"','YYYYMMDD')+0.99999 ";
			sql = sql.replace("?01"," and exists (select 1 from oraddman.tsc_shipping_invoice_detail tsd where tsd.INVOICE_YEAR="+INVOICE_YEAR+" and tsd.invoice_seq=substr(til.invoice_no,1,9)) ");
		}	
		else
		{
			sql = sql.replace("?01","");
		}		  
		if (!INVOICE_NO.equals(""))
		{
			String [] sArray = INVOICE_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					//sql += " and (tsid.INVOICE_SEQ like '"+sArray[x].trim().toUpperCase()+"%'";
					sql += " and ('"+sArray[x].trim().toUpperCase()+"' like tsid.INVOICE_SEQ||'%'";
				}
				else
				{
					//sql += " or tsid.INVOICE_SEQ like '"+sArray[x].trim().toUpperCase()+"%'";
					sql += " or '"+sArray[x].trim().toUpperCase()+"' like tsid.INVOICE_SEQ||'%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}
		if (!SALES_GROUP.equals(""))
		{
			String [] sArray = SALES_GROUP.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SALES_GROUP ELSE tsid.SALES_GROUP END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!SHIPPING_MARKS.equals(""))
		{
			String [] sArray = SHIPPING_MARKS.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN y.SHIPPING_MARKS ELSE tsid.SHIPPING_MARKS END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN y.SHIPPING_MARKS ELSE tsid.SHIPPING_MARKS END like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!SHIPPING_METHOD.equals(""))
		{
			String [] sArray = SHIPPING_METHOD.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and CASE WHEN SHIP.SOURCE_NO_LIST IS NOT NULL THEN ship.SHIPPING_METHOD_CODE ELSE tsid.SHIPPING_METHOD END in ('"+sArray[x].trim().toUpperCase()+"'";
				}
				else
				{
					sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
				}
				if (x==sArray.length -1) sql += ")";
			}	
		}	
		if (!MO_NO.equals(""))
		{
			String [] sArray = MO_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				if (x==0)
				{
					sql += " and (ship.ORDER_NUMBER_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or ship.ORDER_NUMBER_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				if (x==sArray.length -1) sql += ")";
			}
		}
		if (!SOURCE_NO.equals(""))
		{
			String [] sArray = SOURCE_NO.split("\n");
			for (int x =0 ; x < sArray.length ; x++)
			{
				//if (x==0)
				//{
				//	sql += " and SHIP.SOURCE_NO_LIST in ('"+sArray[x].trim().toUpperCase()+"'";
				//}
				//else
				//{
				//	sql += " ,'"+sArray[x].trim().toUpperCase()+"'";
				//}
				if (x==0)
				{
					sql += " and (SHIP.SOURCE_NO_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}
				else
				{
					sql += " or SHIP.SOURCE_NO_LIST like '%"+sArray[x].trim().toUpperCase()+"%'";
				}				
				if (x==sArray.length -1) sql += ")";
			}	
		}
	}
	sql += "  order by tsid.INVOICE_YEAR,tsid.INVOICE_SEQ "+(V_STATUS.equals("USED")?" desc" :"");
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 
		if (rowcnt==0)
		{
		%>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0" style="table-layout:fixed">
	<tr style="background-color:#E9F8F2;color:#000000">
		<td width="3%" align="center">序號</td>
		<td width="3%" align="center">年度</td>
		<td width="5%" align="center">發票序號</td>
		<td width="5%" align="center">取號日期</td>
		<td width="4%" align="center">發票日期</td>
		<td width="8%" align="center">發票號碼</td>
		<td width="5%" align="center"><input type="checkbox" name="chkall"  onClick="checkall()" style="visibility:hidden"></td>
		<td width="6%" align="center">備註</td>
		<td width="7%" align="center">來源單據號碼</td>
		<td width="5%" align="center">業務區</td>
		<td width="10%" align="center">客戶</td>
		<td width="9%" align="center">Shipping Marks</td>
		<td width="5%" align="center">出貨方式</td>
		<td width="3%" align="center">幣別</td>
		<td width="18%" align="center">訂單號碼</td>
		<td width="4%" align="center">最後更新者</td>
	</tr>
		<%
		}
		rowcnt++;		
		if ((V_STATUS.equals("UNUSED") || V_STATUS.equals("USED")) && rs.getInt("row_seq")>Integer.parseInt(max_row))
		{
			break;
		}
		%>
	<tr id="tr_<%=rowcnt%>">
		<td align="center"><%=rowcnt%></td>
		<td align="center"><%=rs.getString("INVOICE_YEAR")%></td>
		<td align="center" <%=(rs.getString("INVOICE_SEQ").substring(rs.getString("INVOICE_SEQ").length()-1).equals("1")?" style='font-size:10px;font-weight:bold;color:#0000CC'":"")%>><%=rs.getString("INVOICE_SEQ")%><input type="hidden" name="INVOICESEQ_<%=rowcnt%>" value="<%=rs.getString("INVOICE_SEQ")%>"><input type="hidden" name="<%=rs.getString("INVOICE_SEQ")%>" value="<%=rowcnt%>"></td>
		<td align="center" style="font-size:10px;word-wrap:break-word;"><%=(rs.getString("INVOICE_DATE")==null?"&nbsp;":rs.getString("INVOICE_DATE"))%><input type="text" id="INVOICEDATE_<%=rowcnt%>" name="INVOICEDATE_<%=rowcnt%>" value=""  style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;" readonly></td>
		<td align="center" style="font-size:10px;word-wrap:break-word;"><%=(rs.getString("pickup_date")==null?"&nbsp;":rs.getString("pickup_date"))%></td>
		<td style="font-size:10px;"><%=(rs.getString("INVOICE_NUMBER")==null?"&nbsp;":rs.getString("INVOICE_NUMBER"))%><input type="text" id="INVOICENO_<%=rowcnt%>" name="INVOICENO_<%=rowcnt%>" value="<%=(rs.getString("INVOICE_NUMBER")==null?"":rs.getString("INVOICE_NUMBER"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td align="center"><input type="checkbox" name="chk" value="<%=rowcnt%>" <%=(rs.getString("INVOICE_NUMBER")==null?"style='visibility:visible'":"style='visibility:hidden'")%> onClick="setCheck(<%=rowcnt%>)"><br><%=(rs.getString("INVOICE_NUMBER")==null || rs.getInt("invoice_cnt")>0?"":"<img border='0' id='imga_"+rowcnt+"' src='images/unlock.jpg' height='16' title='釋放發票號' onClick='onRelease("+'"'+rs.getString("INVOICE_SEQ").replace("T-","*")+'"'+")'>&nbsp;<img border='0' id='imgb_"+rowcnt+"' src='images/lang.gif' height='16' onClick='setUpdate("+'"'+rowcnt+'"'+")'>&nbsp;<img border='0' id='imgc_"+rowcnt+"' src='images/attach.gif' height='16' style='visibility:hidden' onClick='setSave()'>")%></td>
		<td><div id="diva_<%=rowcnt%>"><%=(rs.getString("REMARKS")==null?"&nbsp;":rs.getString("REMARKS"))%></div><input type="text" id="REMARKS_<%=rowcnt%>" name="REMARKS_<%=rowcnt%>" value="<%=(rs.getString("REMARKS")==null?"":rs.getString("REMARKS"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="divb_<%=rowcnt%>"><%=(rs.getString("SOURCE_NO_LIST")==null?"&nbsp;":rs.getString("SOURCE_NO_LIST"))%></div><input type="text" id="SOURCENO_<%=rowcnt%>" name="SOURCENO_<%=rowcnt%>" value="<%=(rs.getString("SOURCE_NO_LIST")==null?"":rs.getString("SOURCE_NO_LIST"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="divc_<%=rowcnt%>"><%=(rs.getString("SALES_GROUP")==null?"&nbsp;":rs.getString("SALES_GROUP"))%></div><input type="text" id="SALESGROUP_<%=rowcnt%>" name="SALESGROUP_<%=rowcnt%>" value="<%=(rs.getString("SALES_GROUP")==null?"":rs.getString("SALES_GROUP"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="divd_<%=rowcnt%>"><%=(rs.getString("SHIPPING_MARKS")==null?"&nbsp;":rs.getString("SHIPPING_MARKS"))%></div><input type="text" id="SHIPPINGMARKS_<%=rowcnt%>" name="SHIPPINGMARKS_<%=rowcnt%>" value="<%=(rs.getString("SHIPPING_MARKS")==null?"":rs.getString("SHIPPING_MARKS"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="dive_<%=rowcnt%>"><%=(rs.getString("SHIPPINGMARK")==null?"&nbsp;":rs.getString("SHIPPINGMARK"))%></div></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="divf_<%=rowcnt%>"><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></div><input type="text" id="SHIPMETHOD_<%=rowcnt%>" name="SHIPMETHOD_<%=rowcnt%>" value="<%=(rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:10px;word-wrap:break-word;"><div id="divg_<%=rowcnt%>"><%=(rs.getString("CURRENCY_CODE")==null?"&nbsp;":rs.getString("CURRENCY_CODE"))%></div><input type="text" id="CURRENCY_<%=rowcnt%>" name="CURRENCY_<%=rowcnt%>" value="<%=(rs.getString("CURRENCY_CODE")==null?"":rs.getString("CURRENCY_CODE"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td style="font-size:9px;word-wrap:break-word;"><div id="divh_<%=rowcnt%>"><%=(rs.getString("ORDER_LIST")==null?"&nbsp;":rs.getString("ORDER_LIST"))%></div><input type="text" id="ORDER_<%=rowcnt%>" name="ORDER_<%=rowcnt%>" value="<%=(rs.getString("ORDER_LIST")==null?"":rs.getString("ORDER_LIST"))%>" style="font-family:Tahoma,Georgia;font-size:11px;visibility:hidden;width:0px;"></td>
		<td align="center" style="font-size:10px;word-wrap:break-word;"><div id="divi_<%=rowcnt%>"><%=(rs.getString("LAST_UPDATED_BY")==null?"&nbsp;":rs.getString("LAST_UPDATED_BY"))%></div></td>
	</tr>
		<%
	}
	rs.close();
	statement.close();

	if (rowcnt <=0) 
	{
		out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
	}
	else
	{
	%>
  </table>
	<%
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception:"+e.getMessage()+"</font></div>");
}
%>
<input type="hidden" name="SYSDATE" value="<%=dateBean.getYearMonthDay()%>">
<input type="hidden" name="CREATEDBY" value="<%=UserName%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
