<!--20151014 by Peggy,for 新版ECN調整-->
<!--20151204 by Peggy,TSC_PROD_ROUP更名,Rect=>PRD,SSP=>SSD-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.lang.*,java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,WriteLogToFileBean,DateBean,ComboBoxBean,ArrayComboBoxBean,javax.xml.parsers.*,CodeUtil"%>
<%@ page import="org.w3c.dom.*" %>
<%@ page import="org.xml.sax.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean"%>
<jsp:useBean id="writeLogToFileBean" scope="page" class="WriteLogToFileBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="codeUtil" scope="page" class="CodeUtil"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<html> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title></title>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style5   {font-family:Tahoma,Georgia;font-size:12px;}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function chkall()
{
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.CHKBOX.length ;i++)
		{
			document.MYFORM.CHKBOX[i].checked= document.MYFORM.CHKBOXALL.checked;
			setCheck((i+1));
		}
	}
	else
	{
		document.MYFORM.CHKBOX.checked = document.MYFORM.CHKBOXALL.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		chkflag = document.MYFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.MYFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor = "#D9D540";
		if (document.MYFORM.elements["td_sourcetype_"+irow].value!="ERP")
		{
			document.MYFORM.elements["td_datecode_"+irow].value = document.MYFORM.DATECODE.value;
		}
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
		document.MYFORM.elements["td_datecode_"+irow].value ="";
	}
}

function subWindowConditionList(obj)
{   
	if (document.MYFORM.TSCPRODGROUP.value==null || document.MYFORM.TSCPRODGROUP.value=="")
	{
		alert("please choose prod group!");
		return false;
	}
	if (obj != null)
	{ 
		var objvalue = document.MYFORM.elements[obj].value;
		var varray = objvalue.split("\n");
		var value="";
		for (var i=0; i < varray.length ; i++)
		{
			if (value.length >0) value = value+";";
			value = value+varray[i]; 
		}
		
		subWin=window.open("../jsp/subwindow/TSCQRAConditionsFind.jsp?TYPE="+obj+"&VALUE="+value+"&PGROUP="+document.MYFORM.TSCPRODGROUP.value,"subwin","width=340,height=480,scrollbars=yes,menubar=no");
	}
}

function subWindowCustomerList()
{
	var objvalue = document.MYFORM.elements["TERRITORY"].value;
	var varray = objvalue.split("\n");
	var territory="",marketgroup="",custlist="";
	for (var i=0; i < varray.length ; i++)
	{
		if (territory.length >0) territory= territory+";";
		territory = territory+varray[i]; 
	}
	var objvalue1 = document.MYFORM.elements["MARKETGROUP"].value;
	var varray1 = objvalue1.split("\n");
	for (var i=0; i < varray1.length ; i++)
	{
		if (marketgroup.length >0) marketgroup=marketgroup+";";
		marketgroup = marketgroup+varray1[i]; 
	}
	if ((objvalue==null || objvalue=="") && (objvalue1==null || objvalue1==""))
	{
		alert("Territory or Market Group必須擇一輸入，不可空白!!");
		return false;
	}
	var objvalue2 = document.MYFORM.elements["CUSTOMER"].value;
	var varray2 = objvalue2.split("\n");
	for (var i=0; i < varray2.length ; i++)
	{
		if (custlist.length >0) custlist=custlist+";";
		custlist = custlist+varray2[i].substr(varray2[i].indexOf("(")+1,varray2[i].indexOf(")")-1); 
	}
	subWin=window.open("../jsp/subwindow/TSCQRACustomerFind.jsp?TERRITORY="+territory+"&MARKETGROUP="+marketgroup+"&CUSTLIST="+custlist,"subwin","width=840,height=480,scrollbars=yes,menubar=no");
}

function setSubmit(URL)
{  
	if (document.MYFORM.QSEQNO.value == "" || document.MYFORM.QSEQNO.value=="null")
	{
		alert("請先輸入Sequence ID!!");
		document.MYFORM.QSEQNO.focus()
		return false;
	}
	
	//if (document.MYFORM.QTYPE.value=="" || document.MYFORM.QTYPE.value=="--")
	//{
	//	alert("請選擇Type!");
	//	document.MYFORM.QTYPE.focus();
	//	return false;
	//}
	
	//if (document.MYFORM.TSCPRODGROUP.value =="" || document.MYFORM.TSCPRODGROUP.value=="--")
	//{
	//	alert("請選擇Prod Group!");
	//	document.MYFORM.TSCPRODGROUP.focus();
	//	return false;
	//}
		
	document.getElementById("alpha").style.width=document.body.scrollWidth+"%";
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit1(URL,QKIND)
{   
	if (event.keyCode == 13)
	{ 
		if (QKIND=="QSEQNO")
		{
			document.MYFORM.action=URL+"?SQSEQNO="+document.MYFORM.QSEQNO.value;
		}
		else
		{
			document.MYFORM.action=URL+"?SQNO="+document.MYFORM.QNO.value;
		}
		document.MYFORM.submit();
	}
}

function setSubmit2(URL)
{
	//modify by Peggy 20140515
	if (document.MYFORM.QSEQNO.value=="" || document.MYFORM.QSEQNO.value==null) 
	{
		alert("SequenceID必須輸入,不可空白!");
		return false;	
	}	
	
	if (document.MYFORM.SHIPFROMDATE.value =="" || document.MYFORM.SHIPFROMDATE.value =="null" || document.MYFORM.SHIPTODATE.value=="" || document.MYFORM.SHIPTODATE.value=="null")
	{
		alert("請輸入Actual Shipment Date!!");
		return false;
	}
		
	//if (document.MYFORM.QTYPE.value=="" || document.MYFORM.QTYPE.value=="--")
	//{
	//	alert("請選擇Type!");
	//	document.MYFORM.QTYPE.focus();
	//	return false;
	//}

	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	if (document.MYFORM.CHKBOX.length != undefined)
	{
		iLen = document.MYFORM.CHKBOX.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.CHKBOX.checked;
		}
		else
		{
			chkvalue = document.MYFORM.CHKBOX[i-1].checked 
		}
		if (chkvalue==true)
		{
			//if (document.MYFORM.elements["td_sourcetype_"+i].value!="ERP" && document.MYFORM.elements["td_datecode_"+i].value=="")
			//{
			//	alert("Date Code必須輸入!");
			//	document.MYFORM.elements["td_datecode_"+i].focus();
			//	return false;
			//}
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	else
	{
		document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setSubmit3(URL)
{
	if (confirm("您確定要從官網匯入PartNo資料嗎?"))
	{
		document.getElementById("alpha").style.width=document.body.scrollWidth+"px";
		document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
		document.getElementById("showimage").style.visibility = '';
		document.getElementById("blockDiv").style.display = '';
		location.href=URL;  
	}
}


function toUpper(objname)
{
	if (event.KeyCode !=08 && event.KeyCode !=37 && event.KeyCode !=39)
	{
		if (objname!=null)
		{
			document.MYFORM.elements[objname].value = document.MYFORM.elements[objname].value.toUpperCase();
		}
	}
}

function setDateCode(line)
{
	if (document.MYFORM.elements["td_datecode_"+line].value!="")
	{
		document.MYFORM.DATECODE.value = document.MYFORM.elements["td_datecode_"+line].value;
	}
}

function setClear()
{
	document.MYFORM.QSEQNO.value="";
	//document.MYFORM.QNO.value ="";
	document.MYFORM.TSCFAMILY.value="";
	document.MYFORM.TSCPACKAGE.value="";
	document.MYFORM.TSCPACKINGCODE.value="";
	document.MYFORM.TSCAMP.value="";
	document.MYFORM.TERRITORY.value="";
	document.MYFORM.MARKETGROUP.value="";
	document.MYFORM.CUSTOMER.value="";
	document.MYFORM.MANUFACTORY.value="";
	document.MYFORM.ITEMSTATUS.value="--";
	document.MYFORM.SHIPFROMDATE.value="";
	document.MYFORM.SHIPTODATE.value="";
	document.MYFORM.TSCPRODGROUP.value="--";
	document.MYFORM.CREATIONDATE.value="";
	document.MYFORM.ENDDATE.value="";
	document.MYFORM.ORGID.value="";
	document.MYFORM.TSCPARTNO.value="";
	document.MYFORM.QTYPE.value="";
}

function DateChange()
{
	document.MYFORM.SHIPFROMDATE.value="";
	document.MYFORM.SHIPTODATE.value="";
	if (document.MYFORM.DATETYPE.value !="")
	{
		document.MYFORM.SHIPFROMDATE.value=document.MYFORM.DATETYPE.value.substr(0,document.MYFORM.DATETYPE.value.indexOf("-"));
		document.MYFORM.SHIPTODATE.value=document.MYFORM.DATETYPE.value.substr(document.MYFORM.DATETYPE.value.indexOf("-")+1);
	}
}

function setExportXLS(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setUpload(URL)
{
	if (document.MYFORM.QSEQNO.value=="" || document.MYFORM.QSEQNO.value==null) 
	{
		alert("SequenceID必須輸入,不可空白!");
		return false;	
	}	

	subWin=window.open(URL+"?QSEQNO="+document.MYFORM.QSEQNO.value,"subwin","left=200,width=740,height=480,scrollbars=yes,menubar=no");  
}
</script>
</head>
<%
String QTRANS = request.getParameter("QTRANS");
if (QTRANS==null) QTRANS="";
String SQNO = request.getParameter("SQNO");
if (SQNO==null) SQNO="";
String SQSEQNO = request.getParameter("SQSEQNO");
if (SQSEQNO==null) SQSEQNO="";
String QSEQNO = request.getParameter("QSEQNO");
if (QSEQNO==null) QSEQNO="";
String QNO = request.getParameter("QNO");
if (QNO==null) QNO="";
String QTYPE = request.getParameter("QTYPE");
if (QTYPE==null) QTYPE="";
String TSCPRODGROUP = request.getParameter("TSCPRODGROUP");
if (TSCPRODGROUP==null)
{
	TSCPRODGROUP="";
}
else
{
	TSCPRODGROUP = (TSCPRODGROUP.equals("SSP")?"SSD": (TSCPRODGROUP.equals("Rect")?"PRD":TSCPRODGROUP));
}
String TSCFAMILY = request.getParameter("TSCFAMILY");
if (TSCFAMILY==null) TSCFAMILY="";
String TSCPACKAGE = request.getParameter("TSCPACKAGE");
if (TSCPACKAGE==null) TSCPACKAGE="";
String TSCPACKINGCODE = request.getParameter("TSCPACKINGCODE");
if (TSCPACKINGCODE==null) TSCPACKINGCODE="";
String TSCAMP = request.getParameter("TSCAMP");
if (TSCAMP==null) TSCAMP="";
String TERRITORY = request.getParameter("TERRITORY");
if (TERRITORY==null) TERRITORY="";
String CUSTOMER = request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String MARKETGROUP = request.getParameter("MARKETGROUP");
if (MARKETGROUP==null) MARKETGROUP="";
String CREATIONDATE = request.getParameter("CREATIONDATE");
if (CREATIONDATE==null || CREATIONDATE.equals("")) CREATIONDATE=dateBean.getYearMonthDay();
String ENDDATE = request.getParameter("ENDDATE");
if (ENDDATE==null) ENDDATE="";
String MANUFACTORY = request.getParameter("MANUFACTORY");
if (MANUFACTORY==null) MANUFACTORY="";
//String CYEARFR = request.getParameter("CYEARFR");
//if (CYEARFR==null) CYEARFR="--";
//String CMONTHFR = request.getParameter("CMONTHFR");
//if (CMONTHFR==null) CMONTHFR="--";
//String CDAYFR = request.getParameter("CDAYFR");
//if (CDAYFR==null) CDAYFR="--";
//String CYEARTO = request.getParameter("CYEARTO");
//if (CYEARTO==null) CYEARTO="--";
//String CMONTHTO = request.getParameter("CMONTHTO");
//if (CMONTHTO==null) CMONTHTO="--";
//String CDAYTO = request.getParameter("CDAYTO");
//if (CDAYTO==null) CDAYTO="--";
String SHIPFROMDATE = request.getParameter("SHIPFROMDATE");
if (SHIPFROMDATE==null) SHIPFROMDATE="";
String SHIPTODATE = request.getParameter("SHIPTODATE");
if (SHIPTODATE==null) SHIPTODATE="";
String ITEMSTATUS = request.getParameter("ITEMSTATUS");
if (ITEMSTATUS==null) ITEMSTATUS="";
String ORGID = request.getParameter("ORGID");
if (ORGID==null) ORGID="";
String TSCPARTNO = request.getParameter("TSCPARTNO");
if (TSCPARTNO==null) TSCPARTNO="";
String AECQ = request.getParameter("AECQ");
if (AECQ==null) AECQ="";
String COMPOUND = request.getParameter("COMPOUND");
if (COMPOUND==null) COMPOUND="";
String sql ="",sql1="",where="",where1="",where2="",where3="";
%>
<body>
<form name="MYFORM"  METHOD="post" ACTION="TSCQRAProductChangeModify.jsp">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<font size=4><strong>PCN/PDN/IN資料維護</strong></font>
<%
try
{
	sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
	PreparedStatement pstmt=con.prepareStatement(sql1);
	pstmt.executeUpdate(); 
	pstmt.close();	

	if (!SQNO.equals("") || !SQSEQNO.equals(""))
	{
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		/*
		Connection conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.12:1433;DatabaseName=TSCflow;User=sa;Password=motorola");
		//modify by Peggy 20140430
		sql = " select af.sequenceid ,afp.apporg,afp.FNO,afp.FKIND,afp.QNO,afp.FAMILY,afp.PACKAGE"+
              ",case afp.HQPROD  when '1' then 'PRD' when '4' then 'SSD' when '5' then 'PMD' else '--' end as HQPROD"+
              ",'' pcndate,'' enddate "+
              " from afs_flow af left join afu_form_pcn01 afp "+
              " on af.serialid=afp.serialid "+          
              " where 1=1 ";		
		if (!SQSEQNO.equals(""))
		{
			sql +=" and af.sequenceid='"+SQSEQNO+"'";
		}
		else if (!SQNO.equals(""))
		{
			sql +=" and afp.QNO='"+SQNO+"'";
		}
		//sql += " order by sidentityid desc";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) 
		{
			QSEQNO = rs.getString("sequenceid");
			if (QSEQNO==null) QSEQNO="";
			QNO = rs.getString("QNO");
			if (QNO==null) QNO="";
			QTYPE = rs.getString("FKIND");
			//modify by Peggy 20140508,不帶e-form上面的family
			//TSCFAMILY = rs.getString("FAMILY").replace(",","\n");
			//if (TSCFAMILY.equals("ALL")) TSCFAMILY="";
			TSCPRODGROUP = rs.getString("HQPROD");
			TSCPACKAGE =rs.getString("PACKAGE").trim();
			if (TSCPACKAGE.equals("ALL")) TSCPACKAGE="";
			ORGID=rs.getString("APPORG");
			CREATIONDATE = rs.getString("PCNDATE");
			ENDDATE = rs.getString("ENDDATE");
		}
		rs.close();
		st.close();
		conn.close();
		*/
		//Connection conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.12:1433;DatabaseName=TSCflow;User=sa;Password=motorola");
		Connection conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.180:1433;DatabaseName=BPMPro;User=bpm;Password=S#Tsc&Bpm2@22");
		//新版ECN
		/*sql = " select afe.CIR_FACTORY apporg"+
			  ",afe.decision FKIND"+
			  ",afe.decision_no QNO"+
			  ",afe.FAMILY"+
			  ",afe.PACKAGE"+
              ",case when afe.prod_group not in ('PRD','PMD','SSD') THEN  '--' else afe.prod_group end as HQPROD"+
              ",'' pcndate,'' enddate "+
			  ",mold_compound"+
			  ",aecq"+
			  ",ecn_no sequenceid"+
              " from afu_form_ECN afe"+
              " where 1=1 ";
		*/
		sql = " select afe.affect_site apporg "+
              ",afe.change_category fkind "+
              ",afe.decision_no qno"+
              ",afe.family"+
              ",afe.package"+
              //",case when afe.prod_group not in ('PRD','PMD','SSD') then  '--' else afe.prod_group end as hqprod"+
			  ",afe.prod_group"+ //add by Peggy 20230817
              ",'' pcndate,'' enddate "+
              ",mold_compound"+
              ",'' aecq"+
              ",cn_no sequenceid  "+
              " from fm7t_change_m afe"+
              " where 1=1 ";
		if (!SQSEQNO.equals(""))
		{
			sql +=" and afe.cn_no='"+SQSEQNO+"'";
		}
		else if (!SQNO.equals(""))
		{
			sql +=" and afe.decision_no='"+SQNO+"'";
		}
		//sql += " order by sidentityid desc";
		//out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		if (rs.next()) 
		{
			QSEQNO = rs.getString("sequenceid");
			if (QSEQNO==null) QSEQNO="";
			QNO = rs.getString("QNO");
			if (QNO==null) QNO="";
			if (rs.getString("FKIND")!=null) 
			{
				QTYPE = rs.getString("FKIND").toUpperCase();
			}
			else
			{
				QTYPE="";
			}
			//modify by Peggy 20140508,不帶e-form上面的family
			TSCFAMILY = rs.getString("FAMILY").replace(",","\n");
			if (TSCFAMILY.equals("ALL")) TSCFAMILY="";
			//TSCPRODGROUP = rs.getString("HQPROD");
			TSCPRODGROUP = rs.getString("prod_group");
			TSCPACKAGE =rs.getString("PACKAGE").replace(",","\n");
			if (TSCPACKAGE.equals("ALL")) TSCPACKAGE="";
			ORGID=rs.getString("APPORG");
			if (ORGID==null) ORGID="";
			if (!ORGID.equals("") || ORGID.toUpperCase().indexOf("ALL")<0)
			{
				ORGID=ORGID.replace("B","I");
				if (TSCPRODGROUP.equals("PMD (B&S)"))
				{
					ORGID=ORGID.replace("O","E");
				}
				else if (TSCPRODGROUP.equals("PRD") || TSCPRODGROUP.equals("SSD"))
				{
					ORGID=ORGID.replace("O","T");
					if (TSCPRODGROUP.equals("SSD")) //台灣供應商
					{
						ORGID=ORGID+",I";
					}
				}
				MANUFACTORY=ORGID.replace(",","\n");
			}
			if (TSCPRODGROUP.equals("PMD (B&S)") || TSCPRODGROUP.equals("PMD (OSAT)"))
			{
				TSCPRODGROUP="PMD";
			} 
			//out.println(MANUFACTORY);
			CREATIONDATE = rs.getString("PCNDATE");
			ENDDATE = rs.getString("ENDDATE");
			COMPOUND=rs.getString("mold_compound").toUpperCase();
			if (COMPOUND==null) COMPOUND="";
			AECQ=rs.getString("aecq").toUpperCase();
			if (AECQ==null) AECQ="";
		}
		rs.close();
		st.close();
		
		if (TSCPACKAGE.equals(""))
		{
			sql =" select cn_no ,prod_group,package"+
				 //" from afu_form_change afe"+
				 " from fm7t_change_m "+
				 " where decision_no='"+SQSEQNO+"'";
			//out.println(sql);
			st = conn.createStatement();
			rs = st.executeQuery(sql);
			while (rs.next()) 
			{
				//out.println(rs.getString("serialid"));
				TSCPRODGROUP = rs.getString("prod_group");
				TSCPACKAGE =rs.getString("PACKAGE").replace(",","\n");
				if (TSCPACKAGE.equals("ALL")) TSCPACKAGE="";
			}
			rs.close();
			st.close();
		}
		conn.close();
		
		sql = " select PCN_CREATION_DATE,PCN_END_DATE from oraddman.tsqra_pcn_item_header a where PCN_NUMBER ='"+SQNO+"'";
		Statement statement8=con.createStatement();
		ResultSet rs8=statement8.executeQuery(sql);
		if (rs8.next()) 
		{
			CREATIONDATE = rs8.getString("PCN_CREATION_DATE");
			ENDDATE = rs8.getString("PCN_END_DATE");
		}
		rs8.close();
		statement8.close();
	}
}
catch(SQLException e)
{
	out.println(e.toString());
}
	
%>
<table width="100%">
	<tr>
		<td align="right">
		<A href="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
		&nbsp;&nbsp;&nbsp;&nbsp;
		<A href="TSCQRAProductChangeSummary.jsp"><jsp:getProperty name="rPH" property="pgReturn"/><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgFunction"/></A>
		</td>
	</tr>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#CFDAD8" border='1'>
				<tr>
					<td width="7%" style="background-color:#DCE6E7"><font color="#006666">ECN NO </font></td>
					<td width="10%"><input type="text" name="QSEQNO" class="style5" value="<%=QSEQNO%>"  onKeyPress="setSubmit1('../jsp/TSCQRAProductChangeModify.jsp','QSEQNO')" onKeyUp="toUpper('QSEQNO')" size="22"></td>
					<td width="6%" style="background-color:#DCE6E7"><font color="#006666">Type</font></td>
					<td width="12%"><SELECT NAME="QTYPE" class="style5">
					    <option value="--" selected>--
						<option value="PCN" <% if (QTYPE.equals("PCN")) out.println("selected");%>>PCN
						<option value="PDN" <% if (QTYPE.equals("PDN")) out.println("selected");%>>PDN
						<option value="IN" <% if (QTYPE.equals("IN")) out.println("selected");%>>IN
						<option value="NO INFORM" <% if (QTYPE.equals("NO INFORM")) out.println("selected");%>>No Inform
						</SELECT>						
					</td>					
					<td width="7%" style="background-color:#DCE6E7"><font color="#006666">Item Status</font></td>
					<td width="7%"><SELECT NAME="ITEMSTATUS" class="style5">
					    <option value="--" selected>--
						<option value="Active" <% if (ITEMSTATUS.equals("Active")) out.println("selected");%>>Active
						<option value="Inactive" <% if (ITEMSTATUS.equals("Inactive")) out.println("selected");%>>Inactive
						</SELECT>						
					</td>
					<td width="10%" style="background-color:#DCE6E7"><font color="#006666">Product Group</font></td>
					<td width="7%">
					<%
						try
						{   
							sql = " SELECT DISTINCT CASE WHEN SEGMENT1='SSP' THEN 'SSD' WHEN SEGMENT1='Rect' THEN 'PRD' ELSE SEGMENT1 END AS fieldvalue, CASE WHEN SEGMENT1='SSP' THEN 'SSD'  WHEN SEGMENT1='Rect' THEN 'PRD' ELSE SEGMENT1 END AS SEGMENT1"+
										 " FROM MTL_CATEGORIES_V "+
										 " WHERE STRUCTURE_NAME='TSC_PROD_GROUP'"+
										 " AND DISABLE_DATE IS NULL AND upper(SEGMENT1) in ('RECT','SSP','PMD','PRD','SSD') order by SEGMENT1";
							Statement statement1=con.createStatement();
							ResultSet rs1=statement1.executeQuery(sql);
							comboBoxBean.setRs(rs1);
							comboBoxBean.setSelection(TSCPRODGROUP);
							comboBoxBean.setFieldName("TSCPRODGROUP");	 
							out.println(comboBoxBean.getRsString());
							rs1.close();   
							statement1.close();
						 } //end of try		 
						 catch (Exception e)
						 { 
							out.println("Exception:"+e.getMessage()); 
						 }  
					%>					
					</td>
					<td width="9%" style="background-color:#DCE6E7"><font color="#006666">Mold Compound</font></td>
					<td width="12%"><SELECT NAME="COMPOUND" class="style5">
					    <option value="--" selected>--
						<option value="STANDARD" <% if (COMPOUND.equals("GREEN")) out.println("selected");%>>Standard
						<option value="GREEN" <% if (COMPOUND.equals("GREEN")) out.println("selected");%>>Green
						</SELECT>						
					</td>					
					<td width="6%" style="background-color:#DCE6E7"><font color="#006666">AECQ</font></td>
					<td width="10%"><SELECT NAME="AECQ" class="style5">
					    <option value="--" selected>--
						<option value="COMMERCIAL" <% if (AECQ.equals("COMMERCIAL")) out.println("selected");%>>Commercial
						<option value="AUTOMOTIVE" <% if (AECQ.equals("AUTOMOTIVE")) out.println("selected");%>>Automotive
						</SELECT>						
					</td>					
				</tr>
				<tr>
					<td style="background-color:#DCE6E7"><font color="#006666">Customer</font></td>
					<td><textarea cols="20" rows="6" name="CUSTOMER" class="style5"><%=CUSTOMER%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Family</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Family選單畫面" onClick="subWindowConditionList('TSCFAMILY')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="30" rows="6" name="TSCFAMILY" class="style5"><%=TSCFAMILY%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Manufactory</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Manufactory選單畫面"  onclick="subWindowConditionList('MANUFACTORY')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="18" rows="6" name="MANUFACTORY" class="style5"><%=MANUFACTORY%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Io(Amp)</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Amp選單畫面" onClick="subWindowConditionList('TSCAMP')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="18" rows="6" name="TSCAMP" class="style5"><%=TSCAMP%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">TSC P/N</font></td>
					<td colspan="3"><textarea cols="25" rows="6" name="TSCPARTNO" class="style5"><%=TSCPARTNO%></textarea></td>
				</tr>
				<tr>
					<td style="background-color:#DCE6E7"><font color="#006666">Territory</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Territory選單畫面" onClick="subWindowConditionList('TERRITORY')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="20" rows="6" name="TERRITORY" class="style5"><%=TERRITORY%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Package</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Package選單畫面" onClick="subWindowConditionList('TSCPACKAGE')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="30" rows="6" name="TSCPACKAGE" class="style5"><%=TSCPACKAGE%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Market Goup</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Market Group選單畫面" onClick="subWindowConditionList('MARKETGROUP')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="18" rows="6" name="MARKETGROUP" class="style5"><%=MARKETGROUP%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Packing Code</font><br><A href="javascript:void(0)" title="按下滑鼠左鍵，開啟Packing選單畫面" onClick="subWindowConditionList('TSCPACKINGCODE')"><img src="images/search.gif" border="0"></A></td>
					<td><textarea cols="18" rows="6" name="TSCPACKINGCODE" class="style5"><%=TSCPACKINGCODE%></textarea></td>
					<td style="background-color:#DCE6E7"><font color="#006666">Exclude<br>Custom<br>Type</font></td>
				  	<td>
						<input type="checkbox" name="chk" value="01">客戶特規<font style="font-size:8px">(Exp:HS1M-08 E2)</font><br>
						<input type="checkbox" name="chk" value="02">供應商特規<font style="font-size:8px"><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(Exp:1N4148W-B0 RH)<br></font>
						<input type="checkbox" name="chk" value="03">產品特規<font style="font-size:8px">(Exp:F1T2-D R0)</font><br>
						<input type="checkbox" name="chk" value="04">TSCC-OEM
				  	</td>
					<td style="background-color:#DCE6E7"><font color="#006666"><%=(Integer.parseInt(dateBean.getYearMonthDay())>20231101?"Ordered Date":"Actual<br>Shipment<br>Date")%></font></td>
					<td>  
						<div><select NAME="DATETYPE" style="font-family:arial" onChange="DateChange();">
							<OPTION VALUE="" selected="selected">--</OPTION>
					<%						
						sql = " SELECT 'Past Year' date_type,to_char(add_months(trunc(sysdate),-12),'yyyymmdd')||'-'||to_char(trunc(sysdate),'yyyymmdd') DATE_RANGE from dual"+
	                          " UNION ALL"+
							  " SELECT 'Past Three Years' date_type,to_char(add_months(trunc(sysdate),-36),'yyyymmdd')||'-'||to_char(trunc(sysdate),'yyyymmdd') DATE_RANGE from dual";
						Statement statement88=con.createStatement();
						ResultSet rs88=statement88.executeQuery(sql);
						while (rs88.next()) 
						{
					%>
							<OPTION VALUE="<%=rs88.getString("date_range")%>"><%=rs88.getString("date_type")%></OPTION>
					<%
						}
						rs88.close();
						statement88.close();					
					%>
						</select></div>
						<p>
						<font style="arial">From:</font><input type="text" name="SHIPFROMDATE" class="style5" value="<%=SHIPFROMDATE%>" SIZE="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SHIPFROMDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
						<br>
						<font style="arial">&nbsp;&nbsp;&nbsp;To:</font>
					      <input type="text" name="SHIPTODATE" class="style5" value="<%=SHIPTODATE%>" size="8" onKeypress="return event.keyCode >= 48 && event.keyCode <=57">
						  <A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.SHIPTODATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
				      </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">
		<input type="button" name="submit1" value="Query" style="font-family:arial" onClick='setSubmit("../jsp/TSCQRAProductChangeModify.jsp?QTRANS=Q")'>
		&nbsp;<input type="button" name="submit2" value="資料匯出" style="background-color:#33CC99;" onClick='setSubmit("../jsp/TSCQRAProductChangeModify.jsp?QTRANS=O")'>
		&nbsp;<input type="button" name="submit5" value="資料匯入" style="background-color:#FF9933;" onClick='setUpload("../jsp/TSCQRAProductChangeUpload.jsp")'>
		&nbsp;<input type="button" name="submit3" value="匯入官網產品明細" style="background-color:#99CC99;" onClick='setSubmit3("../jsp/TSCQRAPartNoListImport.jsp")' title="點我,可匯入官網上所有產品資料">
		&nbsp;<input type="button" name="clear" value="Clear" style="font-family:arial" onClick="setClear()">
		</td>
	</tr>
<%
try
{
	int rec_cnt =0;
	where ="";where1="";sql ="";sql1="";
	if (QTRANS.equals("Q") || QTRANS.equals("O"))
	{		
		Statement statementa=con.createStatement();
		ResultSet rsa=statementa.executeQuery(" select trunc(sysdate)-trunc(min(creation_date)) from  oraddman.tsqra_product_list");
		if (rsa.next())
		{
			if (rsa.getInt(1)>30)
			{
				QTRANS ="";
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("產品資料已超過30天未更新,請先從官網上下載最新產品明細,謝謝!");
		</script>
		<%
			}
		}
		else
		{
			QTRANS ="";
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("請先從官網上下載產品明細,謝謝!");
		</script>
		<%
		}
		rsa.close();
		statementa.close();
	}
	
	if (QTRANS.equals("Q") || QTRANS.equals("O") || QTRANS.equals("U"))
	{	
	%>
	<tr>
		<td>
			<table cellSpacing="0" bordercolordark="#5C7671"  cellPadding="1" width="100%" align="center" borderColorLight="#ffffff" border='1'>
				<tr style="background-color:#006666;color:#ffffff;">
					<td width="3%"  style="font-family:arial;font-size:12px">&nbsp;</td>
					<td width="2%"  style="font-family:arial;font-size:12px"><input type='checkbox' name='CHKBOXALL' onClick='chkall();'></td>
					<td width="20%" style="font-family:arial;font-size:12px">TSC P/N</td>
					<td width="10%"  style="font-family:arial;font-size:12px">Status</td>
					<td width="10%"  style="font-family:arial;font-size:12px">Prod<BR>Group</td>
					<td width="20%"  style="font-family:arial;font-size:12px">Family</td>
					<td width="20%"  style="font-family:arial;font-size:12px">Package</td>
					<td width="10%"  style="font-family:arial;font-size:12px">Packing<br>Code</td>
					<td width="5%"  style="font-family:arial;font-size:12px">Io(Amp)</td>
					<!--<td width="7%"  style="font-family:arial;font-size:12px">Territory</td>-->
					<!--<td width="4%"  style="font-family:arial;font-size:12px">Market<br>Group</td>-->
					<!--<td width="12%" style="font-family:arial;font-size:12px">Customer</td>-->
					<!--<td width="10%" style="font-family:arial;font-size:12px">Cust P/N</td>-->
					<!--<td width="5%"  style="font-family:arial;font-size:12px">Factory</td>-->
					<!--<td width="5%"  style="font-family:arial;font-size:12px">Source<br>Type</td>-->
					<!--<td width="5%"  style="font-family:arial;font-size:12px">Date<br>Code</td>-->
				</tr>
		<%
		if (QTRANS.equals("Q") || QTRANS.equals("O"))
		{
			CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
			cs1.setString(1,"41"); 
			cs1.execute();
			cs1.close();
			String AmpList = "";
		
			if (!TSCAMP.equals("") && !TSCAMP.equals("--"))
			{
				String [] strAmp = TSCAMP.split("\n");
				for (int x = 0 ; x < strAmp.length ; x++)
				{
					if (AmpList.length() >0) AmpList += ",";
					AmpList += strAmp[x].trim();
				}
				if (AmpList.length()>0) AmpList = AmpList+",";
			}	
			sql1= " SELECT 'N/A' as d_type,a.TSC_ITEM_DESC \"TSC P/N\", 'Active' STATUS"+
				  " ,TSC_PROD_GROUP PROD_GROUP,TSC_PACKAGE PACKAGE,TSC_FAMILY FAMILY ,TSC_PACKING_CODE \"PACKING CODE\""+
				  ", case when length('"+AmpList+"') >0 then case when instr(',"+AmpList+"',','||TSC_AMP1||',')>0 then TSC_AMP1 ELSE TSC_AMP2 END else decode(TSC_AMP1,'0A',TSC_AMP2,TSC_AMP1) end AS AMP"+
				  ",'N/A' MARKET_GROUP"+
				  //",'N/A' customer_number"+
				  ",'N/A' customer"+
				  ",'N/A' TERRITORY"+
				  ",'N/A' \"CUST P/N\""+
				  ",'N/A' FACTORY"+
				  ",'' datecode"+
				  " from  oraddman.tsqra_product_list a where 1=1";
			//out.println(sql1); 
			sql = "select DISTINCT 'ERP' AS d_type,"+
				  "a.description \"TSC P/N\","+
				  "a.status,"+
				  "a.prod_group,"+
				  "a.package,"+
				  "a.family,"+
				  "a.\"PACKING CODE\","+
				  "a.amp,"+
				  "b.attribute2 market_group,"+
				  "b.customer_name_phonetic customer,"+
				  "b.territory,"+
				  "NVL (replace(c.item,chr(13),''), 'N/A') \"CUST P/N\","+
				  //" b.ORDERED_ITEM \"CUST P/N\","+
				  "b.packing_instructions factory,"+
				  "'' datecode "+
				  " from (SELECT DISTINCT 'ERP' AS d_type, a.description,a.inventory_item_id,a.organization_id,"+
				  " a.inventory_item_status_code status,grp.CONCATENATED_SEGMENTS  prod_group, pkg.CONCATENATED_SEGMENTS package,"+
				  " fay.CONCATENATED_SEGMENTS family ,tsc_get_item_packing_code (a.organization_id, a.inventory_item_id) AS \"PACKING CODE\", ap.CONCATENATED_SEGMENTS  amp"+
				  " FROM inv.mtl_system_items_b a"+
				  ",(SELECT mic.organization_id,mic.inventory_item_id,MC.CONCATENATED_SEGMENTS FROM MTL_ITEM_CATEGORIES MIC, MTL_CATEGORIES_B_KFV MC, MTL_CATEGORY_SETS_TL MCST WHERE mic.category_id = mc.category_id AND mic.category_set_id = mcst.category_set_id AND mcst.category_set_name = 'TSC_PROD_GROUP'  AND mcst.language = 'US' ) grp"+
				  ",(SELECT mic.organization_id,mic.inventory_item_id,MC.CONCATENATED_SEGMENTS FROM MTL_ITEM_CATEGORIES MIC, MTL_CATEGORIES_B_KFV MC, MTL_CATEGORY_SETS_TL MCST WHERE mic.category_id = mc.category_id AND mic.category_set_id = mcst.category_set_id AND mcst.category_set_name in ( 'TSC_Family','TSC_PROD_FAMILY') AND mcst.language = 'US') fay"+
				  ",(SELECT mic.organization_id,mic.inventory_item_id,MC.CONCATENATED_SEGMENTS FROM MTL_ITEM_CATEGORIES MIC, MTL_CATEGORIES_B_KFV MC, MTL_CATEGORY_SETS_TL MCST WHERE mic.category_id = mc.category_id AND mic.category_set_id = mcst.category_set_id AND mcst.category_set_name = 'TSC_Package' AND mcst.language = 'US') pkg"+
				  ",(SELECT mic.organization_id,mic.inventory_item_id,MC.CONCATENATED_SEGMENTS FROM MTL_ITEM_CATEGORIES MIC, MTL_CATEGORIES_B_KFV MC, MTL_CATEGORY_SETS_TL MCST WHERE mic.category_id = mc.category_id AND mic.category_set_id = mcst.category_set_id AND mcst.category_set_name = 'TSC_Amp' AND mcst.language = 'US') ap"+
				  " WHERE a.inventory_item_id = grp.inventory_item_id(+) AND a.organization_id = grp.organization_id(+)  and a.inventory_item_id = fay.inventory_item_id(+)  AND a.organization_id = fay.organization_id(+)  and a.inventory_item_id = pkg.inventory_item_id(+)  AND a.organization_id = pkg.organization_id(+)   and a.inventory_item_id = ap.inventory_item_id(+) AND a.organization_id = ap.organization_id(+)"+
				  " ?01) a"+
				  ",(SELECT distinct b.packing_instructions, b.ORDERED_ITEM, c.sold_to_org_id,b.ship_from_org_id, b.inventory_item_id,b.ORDERED_ITEM_ID, c.territory, c.attribute2,  c.customer_number, c.customer_name_phonetic, c.customer_name "+
				  "  FROM ont.oe_order_lines_all b"+
				  //",(SELECT invoice_to_org_id, order_number, org_id, sold_to_org_id,header_id, c.description,tsc_intercompany_pkg.get_sales_group (a.header_id) territory,d.attribute2, d.customer_number, NVL (DECODE (SUBSTR ( a.order_number, 1, 4),'4131', NVL (c.description, d.customer_name_phonetic),d.customer_name_phonetic),d.customer_name ) customer_name_phonetic, d.customer_name"+
				  ",(SELECT invoice_to_org_id, order_number, org_id, sold_to_org_id,header_id, c.description,TSC_OM_Get_Sales_Group(a.header_id) territory,d.attribute2, d.customer_number, NVL (DECODE (SUBSTR ( a.order_number, 1, 4),'4131', NVL (c.description, d.customer_name_phonetic),d.customer_name_phonetic),d.customer_name ) customer_name_phonetic, d.customer_name"+
				  " FROM ont.oe_order_headers_all a,(SELECT pk1_value,document_id FROM fnd_attached_documents WHERE entity_name ='OE_ORDER_HEADERS' AND category_id =1000405) b,(SELECT document_id,description FROM fnd_documents_tl  WHERE language ='US') c,ar_customers d  WHERE a.header_id = b.pk1_value(+) AND b.document_id =  c.document_id(+) and SUBSTR (a.order_number, 1, 4) NOT IN ('1214','4121','4131')"+
				  " AND a.sold_to_org_id = d.customer_id  AND d.customer_number <> 10877 ?02) c "+
				  " WHERE b.header_id = c.header_id  AND  ((b.org_id = 325 AND b.ship_from_org_id = 326) or b.org_id = 41) and c.territory <>'-'"+
				  " ?03) b "+
				  ",oe_items_v c"+
				  " where  a.organization_id = b.ship_from_org_id"+
				  " AND a.inventory_item_id = b.inventory_item_id"+
				  " AND b.sold_to_org_id = c.sold_to_org_id(+)"+
				  " AND b.inventory_item_id = c.inventory_item_id(+)"+
				  " AND b.ORDERED_ITEM_ID = c.ITEM_ID(+)";
			if (!TSCPRODGROUP.equals("") && !TSCPRODGROUP.equals("--"))
			{
				//where += " and upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_GROUP')) like '"+TSCPRODGROUP.toUpperCase()+"%'";
				where += " and UPPER(grp.CONCATENATED_SEGMENTS) LIKE '"+TSCPRODGROUP.toUpperCase()+"%'";
				//where1 += " and upper(TSC_PROD_GROUP) like '"+(TSCPRODGROUP.toUpperCase().equals("SSD")?"SSP":TSCPRODGROUP.toUpperCase())+"%'";
				where1 += " and case upper(TSC_PROD_GROUP) when 'SSP' THEN 'SSD' when 'RECT' THEN 'PRD' else upper(TSC_PROD_GROUP)  END like '"+TSCPRODGROUP.toUpperCase()+"%'";
			}
			if (!ITEMSTATUS.equals("") && !ITEMSTATUS.equals("--"))
			{
				if (ITEMSTATUS.toUpperCase().equals("ACTIVE"))
				{
					where += " and a.inventory_item_status_code in ('Active','NRND')";
					where1 += " and decode(trim(upper(a.item_status)),'ACTIVE','Active','NRND','NRND','Inactive')  in ('Active','NRND')";
				}
				else
				{
					where += " and a.inventory_item_status_code ='" +ITEMSTATUS+"'";
					where1 += " and decode(trim(upper(a.item_status)),'ACTIVE','Active','Inactive') ='" +ITEMSTATUS+"'";
				}
			}
			if (!TSCFAMILY.equals("--") && !TSCFAMILY.equals(""))
			{
				String [] strFamily = TSCFAMILY.split("\n");
				String FamilyList = "";
				for (int x = 0 ; x < strFamily.length ; x++)
				{
					if (FamilyList.length() >0) FamilyList += ",";
					FamilyList += "'"+strFamily[x].trim().toUpperCase()+"'";
				}
				//where += " and (TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Family') in ("+FamilyList+") or TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_PROD_FAMILY') in ("+FamilyList+"))";
				where += " and upper(fay.CONCATENATED_SEGMENTS) in ("+FamilyList+")";
				where1 += " and upper(TSC_FAMILY) in ("+FamilyList+")";
			}
			if (!TSCPACKAGE.equals("") && !TSCPACKAGE.equals("--"))
			{
				String [] strPackage = TSCPACKAGE.split("\n");
				String PackageList = "";
				for (int x = 0 ; x < strPackage.length ; x++)
				{
					if (PackageList.length() >0) PackageList += ",";
					PackageList += "'"+strPackage[x].trim().toUpperCase()+"'";
				}
				//where += " and upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Package')) in ("+PackageList+")";
				where += " and upper(pkg.CONCATENATED_SEGMENTS) IN  ("+PackageList+")";
				where1 += " and upper(TSC_PACKAGE) in ("+PackageList+")";
			}
			if (!TSCPACKINGCODE.equals("") && !TSCPACKINGCODE.equals("--"))
			{
				String [] strPacking = TSCPACKINGCODE.split("\n");
				String PackingList = "";
				for (int x = 0 ; x < strPacking.length ; x++)
				{
					if (PackingList.length() >0) PackingList += ",";
					PackingList += "'"+strPacking[x].trim().toUpperCase()+"'";
				}
				where += " and upper(TSC_GET_ITEM_PACKING_CODE(a.ORGANIZATION_ID,a.INVENTORY_ITEM_ID)) in ("+PackingList+")";
				where1 += " and upper(TSC_PACKING_CODE) in ("+PackingList+")";
			}
			if (!TSCAMP.equals("") && !TSCAMP.equals("--"))
			{
				String [] strAmp = TSCAMP.split("\n");
				AmpList="";
				for (int x = 0 ; x < strAmp.length ; x++)
				{
					if (AmpList.length() >0) AmpList += ",";
					AmpList += "'"+strAmp[x].trim().toUpperCase()+"'";
				}
				//where += " and upper(TSC_OM_CATEGORY(a.INVENTORY_ITEM_ID,a.ORGANIZATION_ID,'TSC_Amp')) in ("+AmpList+")";
				where += " and upper(ap.CONCATENATED_SEGMENTS) IN ("+AmpList+")";
				where1 += " and ( upper(TSC_AMP1) in ("+AmpList+") or upper(TSC_AMP2) in ("+AmpList+"))";
			}
			if (!TERRITORY.equals("") && !TERRITORY.equals("--"))
			{
				String [] strTerritory = TERRITORY.split("\n");
				String TerritoryList = "";
				for (int x = 0 ; x < strTerritory.length ; x++)
				{
					if (TerritoryList.length() >0) TerritoryList += ",";
					TerritoryList += "'"+strTerritory[x].trim().toUpperCase()+"'";
				}
				//where2 += " and upper(Tsc_Intercompany_Pkg.get_sales_group(a.header_id)) in ("+TerritoryList+")";
				where2 += " and upper(TSC_OM_Get_Sales_Group(a.header_id)) in ("+TerritoryList+")";
			}
			if (!MARKETGROUP.equals("") && !MARKETGROUP.equals("--"))
			{
				String [] strMarketGroup = MARKETGROUP.split("\n");
				String MarketGroupList = "";
				for (int x = 0 ; x < strMarketGroup.length ; x++)
				{
					if (MarketGroupList.length() >0) MarketGroupList += ",";
					MarketGroupList += "'"+strMarketGroup[x].trim().toUpperCase()+"'";
				}
				where2 += " and upper(d.attribute2) in ("+MarketGroupList+")";
			}
			if (!CUSTOMER.equals("") && !CUSTOMER.equals("--"))
			{
				String [] sArray = CUSTOMER.split("\n");
				String sList = "";
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						where3 += " and (";
					}
					else
					{
						where3 += " or ";
					}
					sArray[x] = sArray[x].trim();
					where3 += " lower(c.customer_name_phonetic) like '%"+sArray[x].toLowerCase()+"%'";
				}
				where3 += " )";
			}
			if (!MANUFACTORY.equals("") && !MANUFACTORY.equals("--"))
			{
				String [] sArray = MANUFACTORY.split("\n");
				String sList = "";
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (sList.length() >0) sList += ",";
					sArray[x] = sArray[x].trim();
					sList += ("'"+sArray[x].substring(0,sArray[x].indexOf("-"))+"'");
					//if (sArray[x].substring(0,sArray[x].indexOf("-")).equals("Y") || sArray[x].substring(0,sArray[x].indexOf("-")).equals("E")) sList += ",'I'";
				}
				where3 += " and b.packing_instructions in ("+sList+")";
			}
			if (!TSCPARTNO.equals("") && !TSCPARTNO.equals("--"))
			{
				String [] sArray = TSCPARTNO.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						where += " and (upper(a.description) like '"+sArray[x].trim().toUpperCase()+"%'";
						if (x==sArray.length -1) where += ")";
						where1 += " and (upper(a.TSC_ITEM_DESC) like '"+sArray[x].trim().toUpperCase()+"%'";
						if (x==sArray.length -1) where1 += ")";
						
					}
					else if (x==sArray.length -1)
					{
						where += " or upper(a.description) like '"+sArray[x].trim().toUpperCase()+"%')";
						where1 += " or upper(a.TSC_ITEM_DESC) like '"+sArray[x].trim().toUpperCase()+"%')";
					}
					else
					{
						where += " or upper(a.description) like '"+sArray[x].trim().toUpperCase()+"%'";
						where1 += " or upper(a.TSC_ITEM_DESC) like '"+sArray[x].trim().toUpperCase()+"%'";
					}
				}
			}
			if (!AECQ.equals("") && !AECQ.equals("--"))
			{
				if (AECQ.equals("AUTOMOTIVE"))
				{
					where1 += " AND upper(a.AECQ) = 'Y'";
				}
				else
				{
					where1 += " AND upper(a.AECQ) <> 'Y'";
				}
			}
			if (!COMPOUND.equals("") && !COMPOUND.equals("--"))
			{
				where1 += " AND LENGTH(a.TSC_PACKING_CODE) = CASE WHEN '"+COMPOUND+"'='GREEN' THEN 3 ELSE 2 END";
			}	
			if (QSEQNO.equals("DANNY")) //add by Peggy 20200518
			{
				where1 += " AND EXISTS (SELECT 1 FROM temp_peggy_x tmp where instr(a.tsc_item_desc,tmp.partno)>0)";
			}					
			where3 += " and b.actual_shipment_date between to_date('"+SHIPFROMDATE+"','yyyymmdd') and to_date('"+SHIPTODATE+"','yyyymmdd')+0.99999";		
			sql = sql1+ where1+ " order by 1,2,10,12";
			
			//out.println(sql);
			//sql ="";
			if (QTRANS.equals("Q"))
			{
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);
				while (rs.next())
				{
					out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
					out.println("<td style='font-family:arial;font-size:12px'>"+(rec_cnt+1)+"</td>");
					out.println("<td style='font-family:arial;font-size:12px'><input type='checkbox' name='CHKBOX' value='"+(rec_cnt+1)+"'  onclick=setCheck('"+(rec_cnt+1)+"');></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("TSC P/N")+"<input type='hidden' name='td_tscpn_"+(rec_cnt+1)+"' value='"+rs.getString("TSC P/N")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("STATUS")+"<input type='hidden' name='td_status_"+(rec_cnt+1)+"' value='"+rs.getString("STATUS")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("PROD_GROUP")+"<input type='hidden' name='td_prodgroup_"+(rec_cnt+1)+"' value='"+rs.getString("PROD_GROUP")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("FAMILY")==null?"&nbsp;":rs.getString("FAMILY"))+"<input type='hidden' name='td_family_"+(rec_cnt+1)+"' value='"+rs.getString("FAMILY")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("PACKAGE")+"<input type='hidden' name='td_package_"+(rec_cnt+1)+"' value='"+rs.getString("PACKAGE")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("PACKING CODE")==null?"&nbsp;":rs.getString("PACKING CODE"))+"<input type='hidden' name='td_packingcode_"+(rec_cnt+1)+"' value='"+rs.getString("PACKING CODE")+"'></td>");
					out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("AMP")==null?"N/A":rs.getString("AMP"))+"<input type='hidden' name='td_amp_"+(rec_cnt+1)+"' value='"+rs.getString("AMP")+"'>");
					out.println("<input type='hidden' name='td_territory_"+(rec_cnt+1)+"' value=''>");
					out.println("<input type='hidden' name='td_market_"+(rec_cnt+1)+"' value=''>");
					out.println("<input type='hidden' name='td_customer_"+(rec_cnt+1)+"' value=''>");
					out.println("<input type='hidden' name='td_custpn_"+(rec_cnt+1)+"' value=''>");
					out.println("<input type='hidden' name='td_sourcetype_"+(rec_cnt+1)+"' value=''>");
					out.println("<input type='hidden' name='td_datecode_"+(rec_cnt+1)+"'value=''>");
					out.println("</td>");
					//out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("TERRITORY")==null?"N/A":rs.getString("TERRITORY"))+"<input type='hidden' name='td_territory_"+(rec_cnt+1)+"' value='"+rs.getString("TERRITORY")+"'></td>");
					//out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("MARKET_GROUP")==null?"N/A":rs.getString("MARKET_GROUP"))+"<input type='hidden' name='td_market_"+(rec_cnt+1)+"' value='"+rs.getString("MARKET_GROUP")+"'></td>");
					//out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("CUSTOMER")==null?"N/A":rs.getString("CUSTOMER"))+"<input type='hidden' name='td_customer_"+(rec_cnt+1)+"' value='"+rs.getString("CUSTOMER")+"'></td>");
					//out.println("<td style='font-family:arial;font-size:12px'>"+(rs.getString("CUST P/N")==null || rs.getString("CUST P/N").equals("null")?"N/A":rs.getString("CUST P/N"))+"<input type='hidden' name='td_custpn_"+(rec_cnt+1)+"' value='"+rs.getString("CUST P/N")+"'></td>");
					//out.println("<td style='font-family:arial;font-size:12px' align='center'>"+rs.getString("factory")+"</td>");
					//out.println("<td style='font-family:arial;font-size:12px'>"+rs.getString("d_type")+"<input type='hidden' name='td_sourcetype_"+(rec_cnt+1)+"' value='"+rs.getString("d_type")+"'></td>");
					//out.println("<td style='font-family:arial;font-size:12px'><input type='TEXT' class='style5' name='td_datecode_"+(rec_cnt+1)+"' size='8' value='"+(rs.getString("datecode")==null?"":rs.getString("datecode"))+"' onChange='setDateCode("+(rec_cnt+1)+");'></td>");
					out.println("</tr>");
					rec_cnt ++;
				}
				rs.close();
				statement.close();
			}
		}
		else if (QTRANS.equals("U"))
		{
			rec_cnt=0;
			String arraylist [][] = (String [][])session.getAttribute("G1001TB");
			for (int i =0 ; i < arraylist.length; i++)
			{
				out.println("<tr id='tr_"+(rec_cnt+1)+"'>");
				out.println("<td style='font-family:arial;font-size:12px'>"+(rec_cnt+1)+"</td>");
				out.println("<td style='font-family:arial;font-size:12px'><input type='checkbox' name='CHKBOX' value='"+(rec_cnt+1)+"'  onclick='setCheck("+(rec_cnt+1)+");' CHECKED></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+arraylist[i][0]+"<input type='hidden' name='td_tscpn_"+(rec_cnt+1)+"' value='"+arraylist[i][0]+"'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>ACTIVE<input type='hidden' name='td_status_"+(rec_cnt+1)+"' value='ACTIVE'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+arraylist[i][1]+"<input type='hidden' name='td_prodgroup_"+(rec_cnt+1)+"' value='"+arraylist[i][1]+"'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+arraylist[i][2]+"<input type='hidden' name='td_family_"+(rec_cnt+1)+"' value='"+arraylist[i][2]+"'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+arraylist[i][3]+"<input type='hidden' name='td_package_"+(rec_cnt+1)+"' value='"+arraylist[i][3]+"'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+arraylist[i][4]+"<input type='hidden' name='td_packingcode_"+(rec_cnt+1)+"' value='"+arraylist[i][4]+"'></td>");
				out.println("<td style='font-family:arial;font-size:12px'>"+(arraylist[i][5]==null?"N/A":arraylist[i][5])+"<input type='hidden' name='td_amp_"+(rec_cnt+1)+"' value='"+arraylist[i][5]+"'>");
				out.println("<input type='hidden' name='td_territory_"+(rec_cnt+1)+"' value=''>");
				out.println("<input type='hidden' name='td_market_"+(rec_cnt+1)+"' value=''>");
				out.println("<input type='hidden' name='td_customer_"+(rec_cnt+1)+"' value=''>");
				out.println("<input type='hidden' name='td_custpn_"+(rec_cnt+1)+"' value=''>");
				out.println("<input type='hidden' name='td_sourcetype_"+(rec_cnt+1)+"' value=''>");
				out.println("<input type='hidden' name='td_datecode_"+(rec_cnt+1)+"'value=''>");
				out.println("</td>");
				//out.println("<td style='font-family:arial;font-size:12px'>N/A<input type='hidden' name='td_territory_"+(rec_cnt+1)+"' value=''></td>");
				//out.println("<td style='font-family:arial;font-size:12px'>N/A<input type='hidden' name='td_market_"+(rec_cnt+1)+"' value=''></td>");
				//out.println("<td style='font-family:arial;font-size:12px'>N/A<input type='hidden' name='td_customer_"+(rec_cnt+1)+"' value=''></td>");
				//out.println("<td style='font-family:arial;font-size:12px'>N/A<input type='hidden' name='td_custpn_"+(rec_cnt+1)+"' value=''></td>");
				//out.println("<td style='font-family:arial;font-size:12px' align='center'>N/A</td>");
				//out.println("<td style='font-family:arial;font-size:12px'>N/A<input type='hidden' name='td_sourcetype_"+(rec_cnt+1)+"' value='N/A'></td>");
				//out.println("<td style='font-family:arial;font-size:12px'><input type='TEXT' class='style5' name='td_datecode_"+(rec_cnt+1)+"' size='8' value='' onChange='setDateCode("+(rec_cnt+1)+");'></td>");
				out.println("</tr>");
				rec_cnt++;
			}
		}
%>			
			</table>
		</td>
	</tr>
<%
		if (QTRANS.equals("Q") || QTRANS.equals("U"))
		{
			if (rec_cnt >0)
			{
%>
	<tr>
		<td  colspan="10" align="center"><input type="button" name="submit2" value="Submit" style="font-family:arial" onClick='setSubmit2("../jsp/TSCQRAProductProcess.jsp")'></td>
	</tr>
<%
			}
			else
			{
%>
	<tr>
		<td  colspan="10" align="center" style="font-family:'細明體';font-size:12px;color:#FF0000">查無符合條件資料,請重新確認,謝謝!</td>
	</tr>
<%
			}
		}
	}
}
catch(Exception e)
{
	out.println("exception2:"+e.toString());
}
%>			
</table>
<%
if (QTRANS.equals("O"))
{
	session.setAttribute("TSCQRAProductSQL",sql);
%>
<script language="JavaScript" type="text/JavaScript">
	setExportXLS("../jsp/TSCQRAProductChangeExcel.jsp");
</script>
<%
}
%>
<input type="hidden" name="DATECODE" value="">
<input type="hidden" name="ENDDATE" value="">
<input type="hidden" name="ORGID" value="">
<input type="hidden" name="CREATIONDATE" value="<%=CREATIONDATE%>">
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</html>