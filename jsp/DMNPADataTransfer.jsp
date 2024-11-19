<!--transfer bpcs npa to wins npa-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>
<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NPA Data Transfer</title>
</head>

<body>
<%
try
{
	int iToday = Integer.parseInt(dateBean.getYearMonthDay());
	out.println("TODAY "+iToday);
	
	Statement stateBPCS=bpcscon.createStatement();
	ResultSet rsBPCS=stateBPCS.executeQuery("SELECT DISTINCT MODELNO AS MODELNO FROM NPA");
	while (rsBPCS.next())
	{
		String sModelNo = rsBPCS.getString("MODELNO");
		sModelNo = sModelNo.trim();
		out.println("<br>"+sModelNo);
		
		String sqlDel = "DELETE FROM NPA WHERE MODELNO='"+sModelNo+"'";
		PreparedStatement delstmt=dmcon.prepareStatement(sqlDel);
		delstmt.executeUpdate();
		delstmt.close();
		out.println("<br>"+sqlDel);
		
		String sql = "INSERT INTO NPA (MODELNO,ITEMNO,NDATE,ICLAS,ICDES,OKCNT,NGCNT)"+
		" VALUES (?,?,?,?,?,?,?)";
		out.println("<br>"+sql);
		PreparedStatement pstmt=dmcon.prepareStatement(sql);
		
		String sItemNo = "";
		String sClas = "";
		String sDesc = "";
		int iNG = 0;
		int iOK = 0;
		Statement state=bpcscon.createStatement();
		ResultSet rs=state.executeQuery("SELECT ITEMNO,ICLAS,ICDES,NGCNT,OKCNT FROM NPA WHERE MODELNO='"+sModelNo+"'");
		while(rs.next())
		{
			sItemNo = rs.getString("ITEMNO"); out.println(sItemNo);
			sClas = rs.getString("ICLAS");
			sDesc = rs.getString("ICDES");
			iNG = rs.getInt("NGCNT");
			iOK = rs.getInt("OKCNT");
			
			pstmt.setString(1,sModelNo);
			
			pstmt.setString(2,sItemNo);
			pstmt.setInt(3,iToday);
			pstmt.setString(4,sClas);
			pstmt.setString(5,sDesc);
			pstmt.setInt(6,iOK);
			pstmt.setInt(7,iNG);
			
			pstmt.executeUpdate();
			

		} // end while(rs.next())
		rs.close();
		state.close();
		
		pstmt.close();
		
	} // end while (rsBPCS.next())
	rsBPCS.close();
	stateBPCS.close();
	out.println("SUCCESSED");
} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); }

%>
</body>
</html>
<!--=============以下區段為處理完成==========-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
