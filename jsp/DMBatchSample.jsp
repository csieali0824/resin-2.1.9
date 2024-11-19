<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

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
	dateBean.setDate(Integer.parseInt(sDateSt.substring(0,4)),Integer.parseInt(sDateSt.substring(4,6)),Integer.parseInt(sDateSt.substring(6,8)));
	String sYear = dateBean.getYearString();
	String sMonth = dateBean.getMonthString();

	//delete data
	PreparedStatement psDel = dmcon.prepareStatement("DELETE FROM stock_sample_day WHERE ddate>="+sDateSt);
	psDel.executeUpdate();
	psDel.close();

	psDel = dmcon.prepareStatement("DELETE FROM stock_sample_mon WHERE (ssyear="+sYear+" AND ssmonth="+sMonth+") OR ssyear>"+sYear);
	psDel.executeUpdate();
	psDel.close();

	//create temp table
	PreparedStatement psTemp = dmcon.prepareStatement("CREATE GLOBAL TEMPORARY TABLE tmp1 (tmodel varchar2(15),titem varchar2(15),tqty number(7,0),tsqty number(7,0),ttqty number(7,0),tyqty number(7,0)) ON COMMIT DELETE ROWS");
	psTemp.executeUpdate();
	psTemp.close();

	//get processing date
	while (Integer.parseInt(sDate)<=Integer.parseInt(sDateEn)) {
		dateBean.setDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(4,6)),Integer.parseInt(sDate.substring(6,8)));
		sYear = dateBean.getYearString();
		sMonth = dateBean.getMonthString();
		out.println("<br>"+sDate);	
		out.println(sYear+"/"+sMonth);

		dateBean.setAdjDate(-1); 
		String sDatePre = dateBean.getYearMonthDay();
		String sYearPre = dateBean.getYearString();
		String sMonthPre = dateBean.getMonthString();
		out.println(sDatePre);	
		out.println(sYearPre+"/"+sMonthPre);

		// insert into log file
		psTemp = dmcon.prepareStatement("INSERT INTO t_ctl (cname,cdesc,cpara,cstdt,cendt,csts,cerr) "
		+" VALUES ('T_SAMPLE_BATCH','SAMPLE REQUEST BATCH','DATE="+sDate+"',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),0,'R','')");
		psTemp.executeUpdate();
		psTemp.close();
	
		psTemp = dmcon.prepareStatement("DELETE FROM tmp1 ");
		psTemp.executeUpdate();
		psTemp.close();
	

		//input previous day value into temp table
		Statement st = dmcon.createStatement();
		ResultSet rs = st.executeQuery("SELECT dyear,dmonth,dmodelno,ditemno,dqty,dsqty,dtqty,dyqty FROM stock_sample_day WHERE ddate="+sDatePre);
		while (rs.next()) {
			String sQtyMonth = rs.getString("dsqty");
			String sQtyYear = rs.getString("dyqty");
			if ( !sMonth.equals(sMonthPre) ) { sQtyMonth = "0";
			}
			if ( !sYear.equals(sYearPre) ) { sQtyYear = "0";
			}
			//out.println("<br>"+rs.getString("dmodelno")+","+rs.getString("ditemno")+","+rs.getString("dtqty"));
			PreparedStatement psIns = dmcon.prepareStatement("INSERT INTO tmp1 (tmodel,titem,tqty,tsqty,ttqty,tyqty)"+
			" VALUES (?,?,?,?,?,?)" );
			psIns.setString(1,rs.getString("dmodelno"));
			psIns.setString(2,rs.getString("ditemno"));
			psIns.setString(3,"0");
			psIns.setString(4,sQtyMonth);
			psIns.setString(5,rs.getString("dtqty"));
			psIns.setString(6,sQtyYear);
			psIns.executeUpdate();
			psIns.close();
		} // end while
		rs.close();
		st.close();

		//input the day value into temp table
		st = dmcon.createStatement();
		rs = st.executeQuery("SELECT tprod,tqty,tmodel FROM t_sample WHERE tdate="+sDate);
		while ( rs.next() ) {
			String sModel = rs.getString("tmodel");
			String sItem = rs.getString("tprod").trim();
			String sQty = rs.getString("tqty");
			out.println("<br>"+sModel+","+sItem+","+sQty);
			PreparedStatement psIns = dmcon.prepareStatement("INSERT INTO tmp1 (tmodel,titem,tqty,tsqty,ttqty,tyqty)"+
			" VALUES (?,?,?,?,?,?)" );
			psIns.setString(1,sModel);
			psIns.setString(2,sItem);
			psIns.setString(3,sQty);
			psIns.setString(4,sQty);
			psIns.setString(5,sQty);
			psIns.setString(6,sQty);
			psIns.executeUpdate();
			psIns.close();
		} // end while
		rs.close();
		st.close();

		//insert into from temp table
		st = dmcon.createStatement();
		rs = st.executeQuery("SELECT tmodel,titem,SUM(tqty) AS tqty,SUM(tsqty) AS tsqty,SUM(ttqty) AS ttqty,SUM(tyqty) AS tyqty FROM tmp1 GROUP BY tmodel,titem");
		while (rs.next()) {
			PreparedStatement psDay = dmcon.prepareStatement("INSERT INTO stock_sample_day (dyear,dmonth,ddate,dmodelno,ditemno,dqty,dsqty,dtqty,dyqty) "+
			" VALUES (?,?,?,?,?,?,?,?,?)" );
			psDay.setString(1,sYear);
			psDay.setString(2,sMonth);
			psDay.setString(3,sDate);
			psDay.setString(4,rs.getString("tmodel"));
			psDay.setString(5,rs.getString("titem"));
			psDay.setString(6,rs.getString("tqty"));
			psDay.setString(7,rs.getString("tsqty"));
			psDay.setString(8,rs.getString("ttqty"));
			psDay.setString(9,rs.getString("tyqty"));
			psDay.executeUpdate();
			psDay.close();

			PreparedStatement psMon = dmcon.prepareStatement("INSERT INTO stock_sample_mon (ssyear,ssmonth,ssmodelno,ssitemno,ssqty,stqty,syqty) "+
			" VALUES (?,?,?,?,?,?,?)" );
			psMon.setString(1,sYear);
			psMon.setString(2,sMonth);
			psMon.setString(3,rs.getString("tmodel"));
			psMon.setString(4,rs.getString("titem"));
			psMon.setString(5,rs.getString("tsqty"));
			psMon.setString(6,rs.getString("ttqty"));
			psMon.setString(7,rs.getString("tyqty"));
			psMon.executeUpdate();
			psMon.close();
		} // end while
		rs.close();
		st.close();

		// update log file
		psTemp = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='S' "
		+" WHERE cname='T_SAMPLE_BATCH' AND csts='R' AND cpara='DATE="+sDate+"'");
		psTemp.executeUpdate();
		psTemp.close();

		//set next processing date
		dateBean.setAdjDate(+2); 
		sDate = dateBean.getYearMonthDay();

	} // end while	
	
	//drop temp table
	psTemp = dmcon.prepareStatement("DROP TABLE tmp1");
	psTemp.executeUpdate();
	psTemp.close();




} // end try
catch (Exception e) { out.println("Exception:"+e.getMessage()); 
	PreparedStatement psTemp = dmcon.prepareStatement("DROP TABLE tmp1");
	psTemp.executeUpdate();
	psTemp.close();

	// update log file
	psTemp = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='F',cerr='"+e.getMessage()+"' "
	+" WHERE cname='T_SAMPLE_BATCH' AND csts='R' AND cpara='DATE="+sDate+"'");
	psTemp.executeUpdate();
	psTemp.close();

/*
	if (dmpoolBean.getDriver()!=null) {   
		   dmpoolBean.emptyPool();   
		   dmpoolBean.resetPool();    
	} 
*/
}

%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%
/*
	if (dmpoolBean.getDriver()!=null)
		 {   
		   dmpoolBean.emptyPool();   
		   dmpoolBean.resetPool();    
		 } 
*/
%>	
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>每日樣品領用統計</title>
</head>

<body>

</body>
</html>
