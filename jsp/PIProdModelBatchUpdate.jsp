<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<!--=============Open Connection==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp/"%>

<%
try {

	String sDateTime = dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond();
	out.println("<br>"+sDateTime);
	dateBean.setAdjMonth(-3);
	String sYear = dateBean.getYearString();
	String sMonth = dateBean.getMonthString();
	String sDate = sYear+sMonth+"01";
	out.println("<br>"+sDate);


	//MFLAG-重點機種:列入PIS的機種,要歸零
	//AFLAG-結轉機種:重點機種與曾經有出貨紀錄,不歸零
	//RFLAG-全系列機種:重點機種與3個月人有出貨或銷售預測,要歸零
	PreparedStatement ps=con.prepareStatement("UPDATE PRODMODEL SET MFLAG=0,RFLAG=0 ");
	ps.executeUpdate();
	ps.close();
	out.println("<br>"+"flag歸零完成");

	// update MFLAG-重點機種,AFLAG-結轉機種,RFLAG-全系列機種
	out.println("<br>"+"Update MFLAG=1");
	String sql = "'2037AC','2037BO','2039C','2042','2047C','2052C','2054U','2056M','2058','2068C','2072A','2092T','AMCF103C','SGCT112C'";
	ps=con.prepareStatement("UPDATE PRODMODEL SET MFLAG=1,AFLAG=1,RFLAG=1,LMDATE= "+sDateTime+" WHERE trim(MPROJ) IN ("+sql+")");
    ps.executeUpdate();
	ps.close();
	out.println("<br>"+sql);
	out.println("<br>"+"MFLAG-重點機種完成");

	out.println("<br>"+"Update RFLAG=1");
	Statement stITH = bpcscon.createStatement();
	ResultSet rsITH = stITH.executeQuery("SELECT DISTINCT ilprod AS tprod FROM sih,sil,iim "+
	" WHERE ilodyr=ihodyr AND ilodpx=ihodpx AND ilinvn=siinvn AND ilcust=sicust AND ilord=siord "+
	" AND ilprod=iprod AND iityp='F' AND iclas='MB' AND SUBSTR(iprod,1,1)='0' "+
	" AND ilwhs IN ('52','71','72','73') AND siinvd>="+sDate);
	while( rsITH.next()) {
		String sItem = rsITH.getString("tprod").trim();
		out.println("<br>"+sItem);
		PreparedStatement psPM=con.prepareStatement("UPDATE PRODMODEL SET RFLAG=1,AFLAG=1,LMDATE="+sDateTime+
		" WHERE trim(mitem)='"+sItem+"' ");
		psPM.executeUpdate();
		psPM.close();

	} // end while
	rsITH.close();
	stITH.close();

	String sSql = "SELECT DISTINCT mitem FROM psales_fore_month p,prodmodel "+
	" WHERE fmprjcd=mproj AND to_char(fmcoun)=mcountry AND fmqty>0 AND fmtype='001' "+
	" AND ( (fmyear='"+sYear+"' AND fmmonth>='"+sMonth+"') OR fmyear>'"+sYear+"' ) "+ // 如果有跨年時
	" and fmver=(select max(fmver) from psales_fore_month f "+ 
	"  where f.fmyear=p.fmyear and f.fmmonth=p.fmmonth and f.fmprjcd=p.fmprjcd and f.fmcoun=p.fmcoun and f.fmcolor=p.fmcolor)"; 
	//out.println(sSql);
	Statement stFore = con.createStatement();
	ResultSet rsFore = stFore.executeQuery(sSql);
	while ( rsFore.next() ) {
		String sItem = rsFore.getString("mitem").trim();
		out.println("<br>"+sItem);
		PreparedStatement psPM=con.prepareStatement("UPDATE PRODMODEL SET RFLAG=1,LMDATE="+sDateTime+
		" WHERE trim(mitem)='"+sItem+"' ");
		//psPM.setString(1,"1");
		//psPM.setString(2,sDateTime);
		psPM.executeUpdate();
		psPM.close();
	}
	rsFore.close();
	stFore.close();
	out.println("<br>"+"RFLAG-全系列機種完成");

/*	第一次時才需作, 以後從update RFLAG=1做即可
	out.println("<br>"+"Update AFLAG=1 from TRYM");
	Statement st = bpcscon.createStatement();
	ResultSet rs = st.executeQuery("SELECT DISTINCT tmprod AS tmprod FROM trym,iim "+
	" WHERE tmprod=iprod AND iityp='F' AND iclas='MB' AND SUBSTR(iprod,1,1)='0' AND tmtype='B' ";
	while (rs.next()) {	
		String sItem = rs.getString("tmprod").trim();
		out.println("<br>"+sItem);
		PreparedStatement psPM=con.prepareStatement("UPDATE PRODMODEL SET AFLAG=1,LMDATE="+sDateTime+
		" WHERE trim(mitem)='"+sItem+"' ");
		//psPM.setString(1,"1");
		//psPM.setString(2,sDateTime);
		psPM.executeUpdate();
		psPM.close();
	} // end while
	rs.close();
	st.close();
*/


	// update description
	out.println("<br>"+"Update Description");
	Statement stWINS=con.createStatement();
	ResultSet rsWINS = stWINS.executeQuery("SELECT MITEM, trim(MDESC) AS MDESC, to_char(sysdate,'YYYYMMDDHH24MISS') AS LMDATE FROM PRODMODEL");
	while (rsWINS.next()){
		out.println("<br>"+rsWINS.getString("MITEM"));
		PreparedStatement stBPCS=bpcscon.prepareStatement("SELECT trim(IDESC||IDSCE) AS DESC FROM IIM WHERE IPROD='"+rsWINS.getString("MITEM")+"'");
		ResultSet rsBPCS = stBPCS.executeQuery();
		if (rsBPCS.next()) {
			String sDesc = rsBPCS.getString("DESC").trim();
			if ( !sDesc.equals(rsWINS.getString("MDESC")) || rsWINS.getString("MDESC")==null ) {
				out.println("  "+sDesc);
				
				PreparedStatement pstmt=con.prepareStatement("UPDATE PRODMODEL SET MDESC=?,LMDATE=? WHERE MITEM='"+rsWINS.getString("MITEM")+"' ");
				pstmt.setString(1,sDesc);
				pstmt.setString(2,rsWINS.getString("LMDATE"));
				pstmt.executeUpdate();
				pstmt.close();
				
			} // end if
		} // end if
		rsBPCS.close();
		stBPCS.close();
	} // end while
	rsWINS.close();
	stWINS.close();
	out.println("<br>"+"Update Description完成");

} catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><%
} // end try-catch

%>

<!--=============Release Connectiong==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Product Model Batch Update</title>
</head>

<body>
</body>
</html>