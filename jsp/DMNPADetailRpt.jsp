<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理完成開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NPA Detail</title>
</head>

<body>
<% 
	//取得傳入參數
	String sModelNo=request.getParameter("MODELNO");
	String sDate=request.getParameter("NDATE");
	String sClass=request.getParameter("CLASS");
	String sStat=request.getParameter("STAT");
	String sD = "";
	if ( sDate!=null && !sDate.equals("") ) { sD = sDate.substring(0,4)+"/"+sDate.substring(4,6)+"/"+sDate.substring(6,8);}
	else { sD = "沒有最後一次更新紀錄"; }
	String sClassName = "";
	if (sClass.equals("EX")) { sClassName = "電子"; } else {
		if (sClass.equals("MK")) { sClassName = "機構"; } else {
			if (sClass.equals("PK")) { sClassName = "包材"; } else {
				if (sClass.equals("PL")) { sClassName = "塑膠"; } else {
					if (sClass.equals("OT")) { sClassName = "其他"; } else {
					} // end if OT
				} // end if PL
			} // end if PK
		} // end if MK
	} // end if EX

%>
<font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%></strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong><%=sClassName%></strong></font>
<font color="#000000" size="+2" face="Times New Roman"><strong>NPA STATUS DETAIL</strong></font>
<table border="1">
<tr bgcolor="#0072A8">
	<td><font color="#FFFF00" size="2" face="Arial">更新日期</font></td>
	<td colspan="6"><font color="#FFFF00" size="2" face="Arial"><%=sD%></font></td>
</tr>

<tr>
	<td><font color="#000000" size="2" face="Arial">序號</font></td>
	<td><font color="#000000" size="2" face="Arial">料號</font></td>
	<td><font color="#000000" size="2" face="Arial">規格說明</font></td>
	<td><font color="#000000" size="2" face="Arial">類別</font></td>
	<td><font color="#000000" size="2" face="Arial">廠商</font></td>
	<td><font color="#000000" size="2" face="Arial">已承認</font></td>
	<td><font color="#000000" size="2" face="Arial">未承認</font></td>
</tr>

<%
try
{
	
	if ( sModelNo!=null && !sModelNo.equals("") && sDate!=null && !sDate.equals("") && 
		sClass!=null && !sClass.equals("") && sStat!=null && !sStat.equals(""))
	{
		String sql = "SELECT ITEMNO,NPA.ICLAS AS ICLASS,ICDES,OKCNT,NGCNT,NDATE,IDESC||IDSCE AS DESC FROM NPA,IIM"+
			" WHERE ITEMNO=IPROD AND MODELNO='"+sModelNo+"' AND NDATE="+sDate;
		if (sClass.equals("EX")) { sql = sql + " AND NPA.ICLAS='EX'"; } else {
			if (sClass.equals("MK")) { sql = sql + " AND NPA.ICLAS IN ('MK','MB')"; } else {
				if (sClass.equals("PK")) { sql = sql + " AND NPA.ICLAS='PK'"; } else {
					if (sClass.equals("PL")) { sql = sql + " AND NPA.ICLAS='PL'"; } else {
						if (sClass.equals("OT")) { sql = sql + " AND NPA.ICLAS NOT IN ('EX','MK','MB','PK','PL')"; } else {
						} // end if OT
					} // end if PL
				} // end if PK
			} // end if MK
		} // end if EX
		if (sStat.equals("Y")) { sql = sql + " AND OKCNT=1 "; } else { 
			if (sStat.equals("N")) {sql = sql + " AND NGCNT=1 ";} 
		}
		sql = sql + " ORDER BY NPA.ICLAS,ITEMNO,OKCNT ";
		//out.println(sql);
		
		Statement state=bpcscon.createStatement();
		ResultSet rs=state.executeQuery(sql);
		boolean rs_isEmpty = !rs.next();		
		boolean rs_hasData = !rs_isEmpty;
		int n = 0;
		
		while (rs_hasData)
		{
			n++;
			sClassName = "";
			String sIclas = rs.getString("ICLASS");
			if (sIclas.equals("EX")) { sClassName = "電子"; } else {
				if (sIclas.equals("MK") || sIclas.equals("MB")) { sClassName = "機構"; } else {
					if (sIclas.equals("PK")) { sClassName = "包材"; } else {
						if (sIclas.equals("PL")) { sClassName = "塑膠"; } else {
							sClassName = rs.getString("ICDES");							
						} // end if PL
					} // end if PK
				} // end if MK
			} // end if EX
			int iOK = rs.getInt("OKCNT");
			int iNG = rs.getInt("NGCNT");
			String sOK = "";
			String sNG = "";
			if (iOK == 1 ) { sOK = "V"; sNG = ""; }
			else { sOK = ""; sNG = "V"; }
%>
<tr>
	<td><font color="#000000" size="2" face="Arial"><%=n%></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=rs.getString("ITEMNO")%></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=rs.getString("DESC")%></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=sClassName%></font></td>
	<td><font color="#000000" size="2" face="Arial"></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=sOK%></font></td>
	<td><font color="#000000" size="2" face="Arial"><%=sNG%></font></td>
</tr>
<%
			rs_isEmpty = !rs.next();		
			rs_hasData = !rs_isEmpty;
		} // end while
		
		rs.close();
		state.close();
		
	} // end if
	
} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</table>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>