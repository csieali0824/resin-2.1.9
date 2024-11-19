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
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("SELECT count(*) AS cnt FROM prodmodel");
	if (rs.next()) {
		nCnt = rs.getInt("cnt");
	} // end if
	//out.println(nCnt);
	rs.close();

	String pm[][] = new String[nCnt][2];
	int i = 0;
	rs = st.executeQuery("SELECT mproj,mitem FROM prodmodel ORDER BY mproj,mitem");
	while ( rs.next()) {
		pm[i][0] = rs.getString("mproj");
		pm[i][1] = rs.getString("mitem");
		//out.println(pm[i][0]+pm[i][1]);
		i++;
	} // end while
	rs.close();
	st.close();

	PreparedStatement psDM = dmcon.prepareStatement("DELETE FROM t_ship WHERE tdate>="+sDateSt);
	psDM.executeUpdate();
	psDM.close();
	
	while (Integer.parseInt(sDate)<=Integer.parseInt(sDateEn)) {
		dateBean.setDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(4,6)),Integer.parseInt(sDate.substring(6,8)));
		out.println("<br>"+sDate);

		// insert into log file
		PreparedStatement ps = dmcon.prepareStatement("INSERT INTO t_ctl (cname,cdesc,cpara,cstdt,cendt,csts,cerr) "
		+" VALUES ('T_SHIP','SHIP','DATE="+sDate+"',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),0,'R','')");
		ps.executeUpdate();
		ps.close();
		
		psDM = dmcon.prepareStatement("INSERT INTO t_ship (tdate,tprod,tqty,tmodel,tamt,tstdm,tstdl,tstdoh,tcst) VALUES (?,?,?,?,?,?,?,?,?)");

		st = bpcscon.createStatement();
		rs = st.executeQuery("SELECT tdate,tprod,tqty,tamt,tstdm,tstdl,tstdoh,tcst FROM t_ship WHERE tdate="+sDate);
		while (rs.next()) {
			String sModel = "";
			String sItem = rs.getString("tprod").trim();
			for (i=0;i<nCnt;i++) {
				if ( sItem.equals(pm[i][1]) ) { sModel = pm[i][0]; break; }
			} // end for
			out.println("<br>"+rs.getString("tdate")+","+sModel+","+sItem+","+rs.getString("tqty"));
			psDM.setString(1,rs.getString("tdate"));
			psDM.setString(2,sItem);
			psDM.setString(3,rs.getString("tqty"));
			psDM.setString(4,sModel);
			psDM.setString(5,rs.getString("tamt"));
			psDM.setString(6,rs.getString("tstdm"));
			psDM.setString(7,rs.getString("tstdl"));
			psDM.setString(8,rs.getString("tstdoh"));
			psDM.setString(9,rs.getString("tcst"));
			psDM.executeUpdate();
	
		} //end while
		rs.close();
		st.close();
		
		
		psDM.close();

		// update log file
		ps = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='S' "
		+" WHERE cname='T_SHIP' AND csts='R' AND cpara='DATE="+sDate+"'");
		ps.executeUpdate();
		ps.close();

		//set next processing date
		dateBean.setAdjDate(+1);
		sDate = dateBean.getYearMonthDay();

	} // end while

} // end try

catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	try {
		// update log file
		PreparedStatement ps = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='F',cerr='"+ee.getMessage()+"' "
		+" WHERE cname='T_SHIP' AND csts='R' AND cpara='DATE="+sDate+"'");
		ps.executeUpdate();
		ps.close();
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%
	} catch (Exception eee) { out.println("Exception:"+eee.getMessage()); 
	} // end try-catch

}
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>每日出貨轉入</title>
</head>

<body>

</body>
</html>
