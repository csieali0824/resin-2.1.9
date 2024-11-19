<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ArrayComboBoxBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============Process Start==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipping Check</title>

</head>

<body>
<form NAME="MYFORM" METHOD="post" ACTION="WSShippingCheck.jsp">
<%
	String YearFr = request.getParameter("YEARFR");
	String MonthFr = request.getParameter("MONTHFR");
	//out.println(YearFr); out.println(MonthFr);
	if (YearFr!=null && !YearFr.equals("--") && MonthFr!=null && !MonthFr.equals("--")) { 
		dateBean.setDate(Integer.parseInt(YearFr),Integer.parseInt(MonthFr),1); 
	} // end if


%>
<font face="Arial" size="+1"></font>年</font>
<%
	//String CurrYear = null;
	String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
	arrayComboBoxBean.setArrayString(a);
	if (YearFr==null) {
		//CurrYear=dateBean.getYearString();
		arrayComboBoxBean.setSelection(dateBean.getYearString());
	} 
	else {
	arrayComboBoxBean.setSelection(YearFr);
	}
	arrayComboBoxBean.setFieldName("YEARFR");	   
	out.println(arrayComboBoxBean.getArrayString());		      		 
%>
<font face="Arial" size="+1"></font>月</font>
<%
	//String CurrMonth = null;
	String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
	arrayComboBoxBean.setArrayString(b);
	if (MonthFr==null) {
	//CurrMonth=dateBean.getMonthString();
	arrayComboBoxBean.setSelection(dateBean.getMonthString());
	} 
	else {
	arrayComboBoxBean.setSelection(MonthFr);
	}
	arrayComboBoxBean.setFieldName("MONTHFR");	   
	out.println(arrayComboBoxBean.getArrayString());		      		 



%>
<input name="Query" type="submit">

<%



try {
	
	String isAdmin = "N";
	//Statement stAdmin=con.createStatement();
	//ResultSet rsAdmin = stAdmin.executeQuery("SELECT * FROM  wsgroupuserrole where ROLENAME='admin' AND groupusername='"+UserName+"'");
	//if (rsAdmin.next()) { isAdmin = "Y"; }
	//rsAdmin.close();
	//stAdmin.close();
	//out.println(isAdmin);
	//out.println(UserRoles);
	int i = UserRoles.indexOf("admin");
	//out.println(i);
	if (i >= 0) {isAdmin = "Y";
	}
	else { isAdmin = "N"; 
	}
	
		
	String sWhs = "";
	if (isAdmin.equals("N")) {
		Statement stWhs=con.createStatement();
		ResultSet rsWhs=stWhs.executeQuery("select BLWHS from WSSHP_CENTER "+
					"where CENTERNO ='"+userActCenterNo+"'");
		if (rsWhs.next()) { sWhs = rsWhs.getString("BLWHS"); }
		rsWhs.close();
		stWhs.close();
	} // end if
	//out.println(sWhs);
	
	String sYear = dateBean.getYearString();
	String sMonth = dateBean.getMonthString();
	String sDateFr = sYear+sMonth+"01";
	String sDateTo = sYear+sMonth+"31";
	//out.println(sDateFr+"~"+sDateTo);
%>
<table border="1">
<tr bgcolor="#00FFFF">
<td>WHS</td> <td>ORDER</td> <td>PROD</td> <td>BPCS QTY</td> <td>Ship Qty</td> <td>Variance</td>
</tr>
<%
	int iSumQtyITH = 0;
	int iSumQtyShip = 0;

	String sITH = "SELECT TWHS,TREF,TPROD,SUM(TQTY*-1) AS TQTY FROM ITH"+
	" WHERE TWHS IN ('52','71','72','73') AND TTYPE IN ('B') AND TCLAS='MB' AND SUBSTR(TPROD,1,1)='0' "+
	" AND TTDTE>="+sDateFr+" AND TTDTE<="+sDateTo;
	if (isAdmin.equals("N")) { sITH = sITH + " AND TWHS='"+sWhs+"' "; }
	sITH = sITH + " GROUP BY TWHS,TREF,TPROD ORDER BY TWHS,TREF,TPROD";
	Statement stITH=bpcscon.createStatement();
	ResultSet rsITH = stITH.executeQuery(sITH);
	while (rsITH.next()){
		String sShipQty = "0";
		String sSql = "SELECT COUNT(*) AS SQTY FROM WSSHIP_IMEI_T,WSSHP_CENTER "+
		" WHERE IN_CENTERNO=CENTERNO AND SHP_NOTES IS NULL AND SUBSTR(INSERT_DTIME,1,4)='"+sYear+"' AND SUBSTR(INSERT_DTIME,5,2)='"+sMonth+"' "+
		" AND BLWHS='"+rsITH.getString("TWHS")+"' "+" AND ERP_CONO='"+rsITH.getString("TREF")+"' "+
		" AND ERP_ITEMNO='"+rsITH.getString("TPROD").trim()+"' ";
		//out.println(sSql);
		Statement stWS=con.createStatement();
		ResultSet rsWS = stWS.executeQuery(sSql);
		if (rsWS.next()) { 
			sShipQty = rsWS.getString("SQTY");
			if (sShipQty==null || sShipQty.equals("")) { sShipQty = "0"; } 
		} // end if rsWS
		rsWS.close();
		stWS.close();
%>
<tr>
<td><%=rsITH.getString("TWHS")%></td>
<td><%=rsITH.getString("TREF")%></td>
<td><%=rsITH.getString("TPROD")%></td>
<td align="right"><%=rsITH.getString("TQTY")%></td>
<td align="right"><%=sShipQty%></td>
<td align="right"><%=rsITH.getInt("TQTY")-Integer.parseInt(sShipQty)%></td>
</tr>
<%	
	iSumQtyITH = iSumQtyITH + rsITH.getInt("TQTY");
	iSumQtyShip = iSumQtyShip + Integer.parseInt(sShipQty);
	}
	rsITH.close();
	stITH.close();

%>
<tr>
<td colspan="3">合計</td>
<td align="right"><%=iSumQtyITH%></td>
<td align="right"><%=iSumQtyShip%></td>
<td align="right"><%=iSumQtyITH-iSumQtyShip%></td>
</tr>

<%

} // end try
catch (Exception e) {out.println("Exception:"+e.getMessage());}
%>
</table>
</form>
</body>
</html>
<!--=============Process End==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>