<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%
String sDateSt = request.getParameter("DATESTART");
String sDateEn = request.getParameter("DATEEND");
if (sDateSt==null || sDateSt.equals("")) { dateBean.setAdjDate(-1); sDateSt = dateBean.getYearMonthDay();
}
if (sDateEn==null || sDateEn.equals("")) { sDateEn = sDateSt;
}

out.println("DATE START:"+sDateSt+"DATE END:"+sDateEn);

String sDate = sDateSt;

try {

	// Prod-Model
	int nCnt = 0;
	Statement stCNT = con.createStatement();
	ResultSet rsCNT = stCNT.executeQuery("SELECT count(*) AS cnt FROM prodmodel");
	if (rsCNT.next()) {
		nCnt = rsCNT.getInt("cnt");
	} // end if
	//out.println(nCnt);
	rsCNT.close();
	stCNT.close();
	
	String pm[][] = new String[nCnt][2];
	int i = 0;
	Statement stPM = con.createStatement();
	ResultSet rsPM = stPM.executeQuery("SELECT mproj,mitem FROM prodmodel ORDER BY mproj,mitem");
	while ( rsPM.next()) {
		pm[i][0] = rsPM.getString("mproj");
		pm[i][1] = rsPM.getString("mitem");
		//out.println(pm[i][0]+pm[i][1]);
		i++;
	} // end while
	rsPM.close();
	stPM.close();

	PreparedStatement ps = dmcon.prepareStatement("DELETE FROM t_sample WHERE tdate>="+sDateSt);
	ps.executeUpdate();
	ps.close();


	while (Integer.parseInt(sDate)<=Integer.parseInt(sDateEn)) {
		dateBean.setDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(4,6)),Integer.parseInt(sDate.substring(6,8)));
		out.println("<br>"+sDate);

		// insert into log file
		ps = dmcon.prepareStatement("INSERT INTO t_ctl (cname,cdesc,cpara,cstdt,cendt,csts,cerr) "
		+" VALUES ('T_SAMPLE','SAMPLE REQUEST','DATE="+sDate+"',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),0,'R','')");
		ps.executeUpdate();
		ps.close();

	
		ps = dmcon.prepareStatement("INSERT INTO t_sample (tdate,tprod,tqty,tmodel) VALUES (?,?,?,?)");
	
		Statement st = bpcscon.createStatement();
		ResultSet rs = st.executeQuery("SELECT tdate,tprod,tqty FROM t_sample WHERE tdate="+sDate);
		while (rs.next()) {
			String sModel = "";
			String sItem = rs.getString("tprod").trim();
			for (i=0;i<nCnt;i++) {
				if ( sItem.equals(pm[i][1]) ) { sModel = pm[i][0]; break; }
			} // end for
			out.println("<br>"+sModel+","+sItem+","+rs.getString("tqty"));
			ps.setString(1,rs.getString("tdate"));
			ps.setString(2,sItem);
			ps.setString(3,rs.getString("tqty"));
			ps.setString(4,sModel);
			ps.executeUpdate();
	
		} //end while
		rs.close();
		st.close();
		ps.close();



		// update log file
		ps = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='S' "
		+" WHERE cname='T_SAMPLE' AND csts='R' AND cpara='DATE="+sDate+"'");
		ps.executeUpdate();
		ps.close();

		//set next processing date
		dateBean.setAdjDate(+1); 
		sDate = dateBean.getYearMonthDay();

	} // end while



} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); 
	// update log file
	PreparedStatement ps = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='F',cerr='"+e.getMessage()+"' "
	+" WHERE cname='T_SAMPLE' AND csts='R' AND cpara='DATE="+sDate+"'");
	ps.executeUpdate();
	ps.close();


}
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>每日樣品領用轉入</title>
</head>

<body>

</body>
</html>
