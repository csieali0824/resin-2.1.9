<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayListCheckBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnMESPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>寄售出庫完成</title>
</head>
<body>

<font color="#3366FF" size="+2" face="Arial"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Arial"><strong>寄售出庫完成</strong></font>
<br>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A> &nbsp
<A HREF="../jsp/WSShippingConsignEntry.jsp">寄售出庫作業</A>&nbsp
<A HREF="../jsp/WSShippingConsignReturn.jsp">寄售繳回作業</A>&nbsp
<A HREF="../jsp/WSShippingConsignQuery.jsp">寄售查詢作業</A>
<br>

<%
try
{
	// get parameter
	String Warehouse = request.getParameter("WAREHOUSE");
	String CustNo = request.getParameter("CUSTNO");
	String CustName = request.getParameter("CUSTNAME");
	String Addr = request.getParameter("ADDR");
	String SalesRepNo = request.getParameter("SALESREPNO");
	String SalesRepName = request.getParameter("SALESREPNAME");
	String a[][]=arrayListCheckBoxBean.getArray2DContent();
	String CenterNo = userActCenterNo;
	
	String Locale = "886";
	
	String sql = "select ACTLOCALE from WSSHIPPER where ACTUSERID='"+userID+"' ";
	//out.println(sql);
	Statement state=con.createStatement();
	ResultSet rs=state.executeQuery(sql);
	if (rs.next()){ Locale = rs.getString("ACTLOCALE"); }
	else { Locale = ""; }
	rs.close();
	state.close();
%>
	<table border='1'  cellspacing="0" cellpadding="0" bgcolor="#CCFFCC">
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">LOCALE</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=Locale%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CENTER</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=CenterNo%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black">WHS</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=Warehouse%></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">CUST</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=CustNo%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CUST NAME</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=CustName%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black">CUST ADDRESS</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=Addr%></font></td>
	</tr>
	<tr>
		<td><font color="#333399" font size="2" face="Arial Black">SALES REP</font></td>
		<td><font color="#333399" font size="2" face="Arial Black"><%=SalesRepNo%></font></td>
		<td><font color="#333399" font size="2" face="Arial Black">SALES REP NAME</font></td>
		<td colspan="3"><font color="#333399" font size="2" face="Arial Black"><%=SalesRepName%></font></td>
	</tr>
</table>
<%
	String sFlag = "Y";
	if (Warehouse==null || Warehouse.equals("--")) sFlag = "N";
	if (CustNo==null || CustNo.equals("--")) sFlag = "N";
	if (CustName==null || CustNo.equals("")) sFlag = "N";
	if (Addr==null || CustNo.equals("")) sFlag = "N";
	if (SalesRepNo==null || CustNo.equals("")) sFlag = "N";
	if (SalesRepName==null || CustNo.equals("")) sFlag = "N";
	if (a==null) sFlag = "N";

	out.println("<table border ='2'>");
	
	if (sFlag.equals("Y"))
	{

		// get next shipping number
		String shipNo="";
		String shipNo1 = "00001";
	
		String strDateTime ="SH"+CenterNo+dateBean.getYearMonthDay();
		String sqlShip = "select trim(to_char(substr(max(SHIPPNO),14,5)+1,'00000')) SHIPPNO from WSSHIP_IMEI_T"+
			" where substr(SHIPPNO,1,13)='"+strDateTime+"' ";
		Statement stateShip=con.createStatement();
		ResultSet rsShip=stateShip.executeQuery(sqlShip);
		if (rsShip.next())
		{
			shipNo1 = rsShip.getString("SHIPPNO");				 
			if (shipNo1==null || shipNo1.equals("")) { shipNo1 = "00001"; }
		}
		else { shipNo1 = "00001"; }
		
		rsShip.close();
		stateShip.close();
		
		shipNo = strDateTime + shipNo1;
		out.println("<tr><td><font color='#333399' font size='2' face='Arial Black'>SHIPNO</font></td><td colspan ='6'><font color='#333399' font size='2' face='Arial Black'>"+shipNo+"</font></td></tr>");
		// end get next shipping number

		String sqlInsert = "insert into WSSHIP_IMEI_T (IMEI,IN_DATETIME,IN_USER,IN_CENTERNO,IN_LOCALE,SHIPPNO,ERP_CONO,ERP_ITEMNO,"+
		" ERP_DEST,ERP_CUSTNO,ERP_CUSTNAME,MES_CARTON_NO,SALES,SALES_NAME,VERSION,SHP_NOTES)"+
		" values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		//out.println(sqlInsert);
		
		PreparedStatement pstmt=con.prepareStatement(sqlInsert);
		
		for (int i=0;i<a.length;i++)
		{
			
			
			String version = "";
			String sqlR = "select VERSION VER from SFISM4.R_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+a[i][4]+"' ";
			String sqlH = "select VERSION VER from SFISM4.H_WIP_KEYPARTS_T where SERIAL_NUMBER = '"+a[i][4]+"' ";
			//out.println(sqlR);
			Statement stateR=conMES.createStatement();
			ResultSet rsR=stateR.executeQuery(sqlR);
			if (rsR.next()){ version = rsR.getString("VER"); }  
			else
			{
				//out.println(sqlH);
				rsR=stateR.executeQuery(sqlH);
				if (rsR.next()){ version = rsR.getString("VER"); }
				else { version = ""; }
			}

			rsR.close();
			stateR.close();	
			
			out.println("<tr>"); //out.println(a[i][0]);out.println(a[i][1]);out.println(a[i][2]);out.println(a[i][3]);
			out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+String.valueOf(i+1)+"</font></td>");
			pstmt.setString(1,a[i][0]); out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+a[i][0]+"</font></td>");
			pstmt.setString(2,a[i][3]); out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+a[i][3]+"</font></td>");
			pstmt.setString(3,userID);
			pstmt.setString(4,CenterNo);
			pstmt.setString(5,Locale);
			pstmt.setString(6,shipNo);
			pstmt.setString(7,"0");
			pstmt.setString(8,a[i][1]); out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+a[i][1]+"</font></td>");
			pstmt.setString(9,Addr);
			pstmt.setString(10,CustNo);
			pstmt.setString(11,CustName);
			pstmt.setString(12,a[i][2]); out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+a[i][2]+"</font></td>");
			pstmt.setString(13,SalesRepNo.trim());
			pstmt.setString(14,SalesRepName.trim());
			pstmt.setString(15,version); out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+a[i][4]+"</font></td>");
				out.println("<td><font color='#333399' font size='2' face='Arial Black'>"+version+"</font></td>");
			pstmt.setString(16,"S"); // consign out
			
			pstmt.executeUpdate();
			
			out.println("</tr>");
			
		} // end for i
		
		pstmt.close();
		
		arrayListCheckBoxBean.setArray2DString(null); // clear array bean data
		
	} // end if sFlag.equals("Y")
	
	else { out.println("<tr><td>INPUT DATA NOT FOUND</td></tr>"); }
	
	out.println("</table>");
		
}  // end try
catch (Exception e) {out.println("Exception:"+e.getMessage());}
%>





</body>
</html>

<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnMESPage.jsp"%>
