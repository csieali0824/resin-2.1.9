<!-- 20150129 Peggy,新增P/L not transfer to 1211 list報表下載功能-->
<!-- 20170810 Peggy,TSCE老是將轉賣的資料當成1211拋過來,為讓USER可自行處理,新增delete功能供user刪除非1211資料-->
<!-- 20171117 Peggy,歐洲系統bug,將QUANTITY=0也丟進來,故增加QUANTITY>0判斷條件-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="ComboBoxBean,DateBean"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBeans" scope="page" class="DateBean"/>
<jsp:useBean id="dateBeane" scope="page" class="DateBean"/>
<title></title>
<%
String ATYPE = request.getParameter("ATYPE");   //add by Peggy 20120713
if (ATYPE==null) ATYPE="ASC";
String BTYPE = request.getParameter("BTYPE");   //add by Peggy 20120713
if (BTYPE==null) BTYPE="ASC";
String CTYPE = request.getParameter("CTYPE");   //add by Peggy 20120713
if (CTYPE==null) CTYPE="ASC";
String DTYPE = request.getParameter("DTYPE");   //add by Peggy 20120713
if (DTYPE==null) DTYPE="ASC";
String ETYPE = request.getParameter("ETYPE");   //add by Peggy 20140305
if (ETYPE==null) ETYPE="ASC";
String SORTING = request.getParameter("SORTING"); //add by Peggy 20120713
if (SORTING==null) SORTING=""; 
String sql = (String)session.getAttribute("D4001SQL"); //add by Peggy 20120713
if (sql == null) sql = "";
String packingListNumber ="";
String customerPO="";
String packingListDate="";
String line_no="";
String customerName="";
String checkbox[]= request.getParameterValues("checkbox");  //add by Peggy 20170810
String DELFALG = request.getParameter("DELFALG");      ///add by Peggy 20170810
if (DELFALG==null) DELFALG="";
String q_Begin_Date=request.getParameter("q_Begin_Date");
String q_End_Date  =request.getParameter("q_End_Date");
if (q_Begin_Date == null)
{
	dateBeans.setAdjDate(-29);
	q_Begin_Date = dateBeans.getYearMonthDay();
}
if (q_End_Date == null)
{
	q_End_Date = dateBeane.getYearMonthDay();
}
String str_Q_Begin_Date = "";
// 20101222 Marvie Add : set processed
//String q_Processed =request.getParameter("q_Processed");
//out.println("q_Processed="+q_Processed+"<br>");
//String str_Q_Processed = "";
if (q_Begin_Date!= "" && q_Begin_Date.length() >0 && q_End_Date!="" && q_End_Date.length()>0) 
{
	//str_Q_Begin_Date = " and a.PackingListDate BETWEEN '"+q_Begin_Date+"' and '"+q_End_Date+"' " ;
	//str_Q_Begin_Date = " and to_char(a.PackingListDate,'yyyymmdd') BETWEEN '"+q_Begin_Date+"' and '"+q_End_Date+"' " ;
	//modify by Peggy 20140305,改為creation date
	str_Q_Begin_Date = " and to_char(a.creation_date,'yyyymmdd') BETWEEN '"+q_Begin_Date+"' and '"+q_End_Date+"' " ; 
}
else if (q_Begin_Date!= "" && q_Begin_Date.length() >0)
{
	//str_Q_Begin_Date = " and a.PackingListDate >= '" + q_Begin_Date + "'";
	//str_Q_Begin_Date = " and to_char(a.PackingListDate,'yyyymmdd') >= '" + q_Begin_Date + "'";
	//modify by Peggy 20140305,改為creation date
	str_Q_Begin_Date = " and to_char(a.creation_date,'yyyymmdd') >= '" + q_Begin_Date + "'";
}
else if (q_End_Date != "" && q_End_Date.length() >0)
{
	//str_Q_Begin_Date = " and a.PackingListDate <= '" + q_End_Date + "'";
	//str_Q_Begin_Date = " and to_char(a.PackingListDate,'yyyymmdd') <= '" + q_End_Date + "'";
	//modify by Peggy 20140305,改為creation date
	str_Q_Begin_Date = " and to_char(a.creation_date,'yyyymmdd') <= '" + q_End_Date + "'";
} 
else 
{
	str_Q_Begin_Date = "";
}

if (DELFALG.equals("Y"))
{
	try
	{
		for(int i=0; checkbox != null && i<checkbox.length ;i++)
		{
			sql = " delete tsc_packinglist_data a" +
				   " where a.PACKINGLISTNUMBER=?"+
				   " and not exists (select 1 from tsc_oe_auto_headers b where b.customerpo||'.'||b.packinglistnumber=a.customerpo||'.'||a.packinglistnumber)";
			PreparedStatement pstmtDt=con.prepareStatement(sql);  
			pstmtDt.setString(1,checkbox[i]);
			pstmtDt.executeQuery();
			pstmtDt.close();			   
		}
		con.commit();
	}
	catch(Exception e)
	{
		con.rollback();
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("刪除動作失敗,請洽系統管理人員處理!")
		</script>
	<%
	}
}
%>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; font-size: 12px ;table-layout:fixed; word-break :break-all}  
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function setLink(URL)
{  
	document.form1.action=URL;
	document.form1.submit(); 
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
	document.form1.action="Tsc1211GenerateXmlAll.jsp?SORTING="+objname;
	document.form1.submit(); 
}
function setcheck(rowline)
{
	if (document.form1.checkbox.length ==undefined)
	{
		if (document.form1.checkbox.checked==true)
		{
			document.getElementById("row"+rowline).style.backgroundColor="#CEE3D9";
		}
		else
		{
			document.getElementById("row"+rowline).style.backgroundColor="#FFFFFF";
		}
	}
	else
	{
		if (document.form1.checkbox[rowline-1].checked ==true)
		{
			document.getElementById("row"+rowline).style.backgroundColor="#CEE3D9";
		}
		else
		{
			document.getElementById("row"+rowline).style.backgroundColor="#FFFFFF";
		}
	}

}
function checkall()
{
	if (document.form1.checkbox.length != undefined)
	{
		for (var i =0 ; i < document.form1.checkbox.length ;i++)
		{
			document.form1.checkbox[i].checked= document.form1.chkall.checked;
			setcheck((i+1));
		}
	}
	else
	{
		document.form1.checkbox.checked = document.form1.chkall.checked;
		setcheck(1);
	}
}
function setExportXLS(URL)
{    
	if (document.form1.q_Begin_Date.value =="")
	{
		alert("Please enter a start date!");
		document.form1.q_Begin_Date.focus(); 
		return false;
	}
	else if (document.form1.q_End_Date.value =="")
	{
		alert("Please enter a end date!");
		document.form1.q_End_Date.focus(); 
		return false;
	}
	document.form1.action=URL;
 	document.form1.submit();
}
function setDelete(URL)
{  
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var packinglist="";
	if (document.form1.checkbox.length != undefined)
	{
		iLen = document.form1.checkbox.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.form1.checkbox.checked;
			packinglist = document.form1.checkbox.value;
		}
		else
		{
			chkvalue = document.form1.checkbox[i-1].checked;
			packinglist = document.form1.checkbox[i-1].value;
		}
		if (chkvalue==true)
		{
		 	chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("請先勾選資料!");
		return false;
	}
	if (confirm("資料一經刪除,即無法復原,您確定要刪除??"))
	{
		document.form1.action=URL;
		document.form1.submit(); 
	}
}
</script>
</head>
<body>
<form name="form1" method="post">
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<table width="80%"  border="0" align="center" cellpadding="0" cellspacing="0">
	<tr><td><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">Packing List Number</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Data Query </strong></font></p>
	</td></tr>
	<tr><td> <%@ include file="Tsc1211head.jsp"%></td></tr>
	<tr><td>&nbsp;</td></tr>
 	<tr>
		<td>
			<table width="100%"  border="1" align="center" cellpadding="0" cellspacing="0">
				<tr>
    				<td bgcolor="#99CCFF" class="tableTitle" width="10%" ><font size= "2">Begin time</font></td>
					<td width="25%">
						<input name="q_Begin_Date" type="text" id="q_Begin_Date" size="15" style="font-family: Tahoma,Georgia" value= "<%=q_Begin_Date%>"  readonly >
						<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.form1.q_Begin_Date);return false;'><img name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></a> </td>
					<td bgcolor="#99CCFF" class="tableTitle" width="10%" ><font  size= "2">End Time</font></td>
					<td width="25%">
						<input name="q_End_Date" type="text" id="q_End_Date" size="15"  style="font-family: Tahoma,Georgia" value= "<%=q_End_Date %>" readonly>
						<a href='javascript:void(0)' onClick='gfPop.fPopCalendar(document.form1.q_End_Date);return false;'><img name='popcal' src='images/calbtn.gif' width='20' height='15' border=0 alt=''></a></td>
					<td width="30%">
						<input name="search" type="button" id="search2" value="Search"  style="font-family: Tahoma,Georgia"  onClick='setLink("Tsc1211GenerateXmlAll.jsp")'>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							
						<input name="excel" type="button" id="excel" value="Export To Excel" style="font-family: Tahoma,Georgia" onClick='setExportXLS("../jsp/Tsc1211EmailNotice.jsp?RTYPE=WAITING")'>
						
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td>
			<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="6">
						<!--<input type="button" name="Submit" value="Submit" onClick='setLink("Tsc1211GenerateXmladd.jsp")'>-->
						<input type="button" name="Submit" value="Submit" style="font-family: Tahoma,Georgia" onClick='setLink("Tsc1211GenerateXmlImport.jsp")'>
						&nbsp;&nbsp;
						<input type="button" name="Delete" value="Delete" style="font-family: Tahoma,Georgia" onClick='setDelete("Tsc1211GenerateXmlAll.jsp?DELFALG=Y")'>
					</td>
				</tr>
				<tr bgcolor="#99CCFF" class="tableTitle">
					<td width="3%" align="center"><input type="checkbox" name="chkall"  onClick="checkall()"></td>
					<td width="15%"><font face="Arial" size="2">Packing Number&nbsp;<a href='javascript:void(0)' onClick="setSubmit('ATYPE')"><%if (ATYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></td>
					<!--<td width="15%"><font face="Arial" size="2">Customer PO&nbsp;<a href='javascript:void(0)' onClick="setSubmit('BTYPE')"><%if (BTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></td>-->
					<td width="30%"><font face="Arial" size="2">Customer Name&nbsp;<a href='javascript:void(0)' onClick="setSubmit('CTYPE')"><%if (CTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></td>
					<td width="20%"><font face="Arial" size="2">Packing Date&nbsp;<a href='javascript:void(0)' onClick="setSubmit('DTYPE')"><%if (DTYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></td>
					<!--<td width="7%"><font face="Arial" size="2">Line Number</font></td>-->
					<td width="5%"><font face="Arial" size="2">PO Count</font></td>
					<td width="10%" align="center"><font face="Arial" size="2">Import Date&nbsp;<a href='javascript:void(0)' onClick="setSubmit('ETYPE')"><%if (ETYPE.equals("ASC")) out.println("<img src='../image/arrowdn.gif' width='10' height='10' border=0 title='由大至小排序' alt=''>"); else out.println("<img src='../image/arrowup.gif' width='10' height='10' border=0 title='由小至大排序' alt=''>");%></a></font></td>
				</tr>
<%
//Connection conn=null;
try
{
	//Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
	//conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.1.18:1433;DatabaseName=BufferNetSQL;User=web;Password=6227");
	//out.println(conn);
	if (SORTING.equals(""))
	{
		/*
		sql = " SELECT a.PackingListNumber, a.PackingListDate, b.CustomerPO, COUNT(b.CustomerPO) line_no, c.name"+ 
			  " FROM PackingList a, PackingListDetails b ,Customerdata c"+
			  " WHERE a.ID = b.packinglistid "+ str_Q_Begin_Date +
			  // 20101222 Marvie Add : set processed
			  " AND " + str_Q_Processed + " EXISTS(SELECT p.PackingListNumber FROM PackingListProcessed p" +
			  " WHERE a.PackingListNumber = p.PackingListNumber" +
			  " AND b.CustomerPO = p.CustomerPO)"+
			  " AND a.customerid = c.id   "+
			  " GROUP BY  a.PackingListNumber, a.PackingListDate, b.CustomerPO , c.name";
			  //" ORDER BY packinglistdate desc";
		*/
		//modify by Peggy 20120927
		/*
		sql = " SELECT a.PackingListNumber, a.PackingListDate, a.name,count(1) PO_CNT"+
		      " FROM (SELECT  a.PackingListNumber, a.PackingListDate, c.name,ltrim(rtrim(b.CustomerPO)) CustomerPO "+ 
			  " FROM PackingList a, PackingListDetails b ,Customerdata c"+
			  " WHERE a.ID = b.packinglistid "+ str_Q_Begin_Date +
			  // 20101222 Marvie Add : set processed
			  " AND " + str_Q_Processed + " EXISTS (SELECT p.PackingListNumber FROM PackingListProcessed p" +
			  " WHERE a.PackingListNumber = p.PackingListNumber" +
			  " AND ltrim(rtrim(b.CustomerPO)) = ltrim(rtrim(p.CustomerPO)))"+
			  " AND a.customerid = c.id   "+
			  " GROUP BY  a.PackingListNumber, a.PackingListDate, c.name,ltrim(rtrim(b.CustomerPO))) a"+  //add trim() by Peggy 20121106
			  " group by a.PackingListNumber, a.PackingListDate, a.name";
		*/
		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
		cs1.execute();
		cs1.close();	
		
		//modify by Peggy 20130327
		//sql = " SELECT a.PackingListNumber, a.PackingListDate, a.name,count(1) PO_CNT"+
		//      " FROM (SELECT  a.PackingListNumber, a.PackingListDate, NVL(REPLACE(c.CUSTOMER_NAME,'\''',' '),a.customer_name) name,TRIM(a.CustomerPO) CustomerPO "+ 
		//	  " FROM TSC_PACKINGLIST_DATA a ,APPS.AR_CUSTOMERS c "+
		//	  " WHERE a.BILLTOADDRESSID=c.CUSTOMER_NUMBER(+)  "+
		//	  " "+ str_Q_Begin_Date +
		//	  " AND not exists (select 1 from apps.TSC_OE_AUTO_HEADERS p "+
		//	  " WHERE a.PackingListNumber = p.PackingListNumber" +
		//	  " AND TRIM(a.CustomerPO) = TRIM(p.CustomerPO))"+
		//	  " GROUP BY  a.PackingListNumber, a.PackingListDate,  NVL(REPLACE (c.customer_name, '''', ' '),a.customer_name),TRIM(a.CustomerPO)) a"+  //add trim() by Peggy 20121106
		//	  " group by a.PackingListNumber, a.PackingListDate, a.name";
		sql = " SELECT a.PackingListNumber, a.PackingListDate, a.name,count(1) PO_CNT,CREATION_DATE"+
		      " from (SELECT  a.PackingListNumber, a.PackingListDate, NVL(REPLACE(c.CUSTOMER_NAME,'\''',' '),a.customer_name) name,TRIM(a.CustomerPO) CustomerPO,to_char(a.CREATION_DATE,'yyyy-mm-dd') CREATION_DATE "+ 
			  " FROM TSC_PACKINGLIST_DATA a ,APPS.AR_CUSTOMERS c "+
			  " WHERE a.BILLTOADDRESSID=c.CUSTOMER_NUMBER(+)  "+
			  " and trunc(a.CREATION_DATE) < to_date('2013-06-04','yyyy-mm-dd')"+
			  " "+ str_Q_Begin_Date +
			  " AND not exists (select 1 from apps.TSC_OE_AUTO_HEADERS p "+
			  " WHERE a.PackingListNumber = p.PackingListNumber" +
			  " AND TRIM(a.CustomerPO) = TRIM(p.CustomerPO))"+
			  " GROUP BY  a.PackingListNumber, a.PackingListDate, NVL(REPLACE (c.customer_name, '''', ' '),a.customer_name),TRIM(a.CustomerPO),to_char(a.CREATION_DATE,'yyyy-mm-dd')"+ 
			  " union all "+
		      " SELECT  a.PackingListNumber, a.PackingListDate ,REPLACE(d.CUSTOMER_NAME,''\'',' ') name,TRIM(a.CustomerPO) CustomerPO,to_char(a.CREATION_DATE,'yyyy-mm-dd') CREATION_DATE "+ 
			  " FROM TSC_PACKINGLIST_DATA a ,hz_cust_site_uses_all b,HZ_CUST_ACCT_SITES_all c,APPS.AR_CUSTOMERS  d"+
              " where a.BILLTOADDRESSID=b.site_use_id(+)"+
              " and b.cust_acct_site_id=c.cust_acct_site_id(+)"+
              " and c.cust_account_id=d.CUSTOMER_ID(+) "+
			  " and a.QUANTITY>0"+ //add by Peggy 20171117
			  " and trunc(a.CREATION_DATE) >= to_date('2013-06-04','yyyy-mm-dd')"+
			  " "+ str_Q_Begin_Date +
			  " AND not exists (select 1 from apps.TSC_OE_AUTO_HEADERS p "+
			  " WHERE a.PackingListNumber = p.PackingListNumber" +
			  " AND TRIM(a.CustomerPO) = TRIM(p.CustomerPO))"+
			  " GROUP BY  a.PackingListNumber, a.PackingListDate, d.CUSTOMER_NAME,TRIM(a.CustomerPO),to_char(a.CREATION_DATE,'yyyy-mm-dd')) a"+  //add trim() by Peggy 20121106
			  " group by a.PackingListNumber, a.PackingListDate, a.name,a.CREATION_DATE";
	}
	session.setAttribute("D4001SQL",sql); //add by Peggy 20120713
	if (SORTING.equals("ATYPE")) sql += " order by a.PackingListNumber "+ ATYPE + ",a.name "+ CTYPE +", a.PackingListDate "+ DTYPE +",a.creation_Date "+ ETYPE ;
	if (SORTING.equals("CTYPE")) sql += " order by a.name "+ CTYPE +",a.PackingListNumber "+ ATYPE + ",a.PackingListDate "+ DTYPE +",a.creation_Date "+ ETYPE ;
	if (SORTING.equals("") || SORTING.equals("DTYPE")) sql += " order by a.PackingListDate "+ DTYPE +",a.PackingListNumber "+ ATYPE + ",a.name "+ CTYPE +",a.creation_Date "+ ETYPE ;
	if (SORTING.equals("ETYPE")) sql += " order by a.creation_Date "+ ETYPE +",a.PackingListNumber "+ ATYPE + ",a.name "+ CTYPE +",a.PackingListDate "+ DTYPE ;
	//Statement st = null;
	//ResultSet rs = null;
	//out.println(sql);
	//st = conn.createStatement();
	//rs = st.executeQuery(sql);
	//out.println(sql);
	Statement st = con.createStatement();
	ResultSet rs =  st.executeQuery(sql);	
	int rowcnt=1; //add by Peggy 20120716
	while(rs.next())
	{
		packingListNumber=rs.getString("PackingListNumber");
		//customerPO=rs.getString("CustomerPO");
		packingListDate=rs.getString("PackingListDate");
		//line_no=rs.getString("line_no");
		customerName = rs.getString("name");
				 
  		out.println("<tr id='row"+rowcnt+"'>");
    	//out.println("<td align ='center'><input type='checkbox' name='checkbox' value='"+customerPO+","+packingListNumber+"' onclick='setcheck("+'"'+rowcnt+'"'+")'></td>");
		out.println("<td align ='center'><input type='checkbox' name='checkbox' value='"+packingListNumber+"' onclick='setcheck("+'"'+rowcnt+'"'+")'></td>");
		out.println("<td><font face='Arial' size='2'>"+packingListNumber+"</font></td>");
    	//out.println("<td><font face='Arial' size='2'>"+customerPO+"</font></td>");
    	out.println("<td><font face='Arial' size='2'>"+customerName+"</font></td>");
    	out.println("<td><font face='Arial' size='2'>"+packingListDate+"</font></td>");
    	//out.println("<td><font face='Arial' size='2'>"+line_no+"</font></td>");
    	out.println("<td align='center'><font face='Arial' size='2'>"+rs.getString("po_cnt")+"</font></td>");
    	out.println("<td align='center'><font face='Arial' size='2'>"+rs.getString("creation_date")+"</font></td>");
  		out.println("</tr>");
		rowcnt++; //add by Peggy 20120716
	}
}
catch(SQLException e)
{
	System.out.println(e.toString());
}
finally
{
	//if(conn!=null)
	//{
	//	conn.close();
	//	conn=null;
	//	//response.sendRedirect("Tsc1211XmlUpload.jsp");
    //}
}
%> 
				<tr>
					<td colspan="6">
						<!--<input type="button" name="Submit1" value="Submit" onClick='setLink("Tsc1211GenerateXmladd.jsp")'>-->
						<input type="button" name="Submit1" value="Submit" style="font-family: Tahoma,Georgia" onClick='setLink("Tsc1211GenerateXmlImport.jsp")'>
						&nbsp;&nbsp;
						<input type="button" name="Delete1" value="Delete" style="font-family: Tahoma,Georgia" onClick='setDelete("Tsc1211GenerateXmlAll.jsp?DELFALG=Y")'>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<input type="hidden" name="ATYPE" value="<%=ATYPE%>">
<input type="hidden" name="BTYPE" value="<%=BTYPE%>">
<input type="hidden" name="CTYPE" value="<%=CTYPE%>">
<input type="hidden" name="DTYPE" value="<%=DTYPE%>">
<input type="hidden" name="ETYPE" value="<%=ETYPE%>">
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</form>
</body>
</html>
