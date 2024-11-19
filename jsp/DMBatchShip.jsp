<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,WorkingDateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%
String sDateSt = request.getParameter("DATESTART");
String sDateEn = request.getParameter("DATEEND");
if (sDateSt==null || sDateSt.equals("")) { dateBean.setAdjDate(-1); sDateSt = dateBean.getYearMonthDay();}
if (sDateEn==null || sDateEn.equals("")) { sDateEn = sDateSt;}

out.println("DATE START:"+sDateSt+"DATE END:"+sDateEn+"<br>");

String sDate = sDateSt;

try {
	dateBean.setDate(Integer.parseInt(sDateSt.substring(0,4)),Integer.parseInt(sDateSt.substring(4,6)),Integer.parseInt(sDateSt.substring(6,8)));

	//delete daily data
	PreparedStatement psDel = dmcon.prepareStatement("DELETE FROM stock_ship_day WHERE ddate>="+sDateSt);
	psDel.executeUpdate();
	psDel.close();

	//create temp table
	PreparedStatement psTemp = dmcon.prepareStatement("CREATE GLOBAL TEMPORARY TABLE tmp1 "
	+" (tmodel varchar2(15),titem varchar2(15),tqty number(7,0),twqty number(7,0),tsqty number(7,0),ttqty number(7,0),tyqty number(7,0) "
	+" ,tamt number(11,2),twamt number(11,2),tsamt number(11,2),ttamt number(11,2),tyamt number(11,2) "
	+" ) ON COMMIT DELETE ROWS");
	psTemp.executeUpdate();
	psTemp.close();

	psTemp = dmcon.prepareStatement("CREATE GLOBAL TEMPORARY TABLE tmp2 "
	+" (titem varchar2(15),tstdm number(15,5),tstdl number(15,5),tstdoh number(15,5)"
	+" ) ON COMMIT DELETE ROWS");
	psTemp.executeUpdate();
	psTemp.close();
		
	workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日
	while (Integer.parseInt(sDate)<=Integer.parseInt(sDateEn)) {
		dateBean.setDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(4,6)),Integer.parseInt(sDate.substring(6,8)));
		workingDateBean.setWorkingDate(Integer.parseInt(sDate.substring(0,4)),Integer.parseInt(sDate.substring(4,6)),Integer.parseInt(sDate.substring(6,8)));
		String sYear = dateBean.getYearString();
		String sMonth = dateBean.getMonthString();
		String sWeek = workingDateBean.getWeekString();
		String sWeekFr = workingDateBean.getFirstDateOfWorkingWeek();   // 取當週第一天
		String sWeekTo = workingDateBean.getLastDateOfWorkingWeek();  // 取當週最後一天
		out.println("<br>"+"Date="+sDate+" Y/M="+sYear+"/"+sMonth+" Week="+sWeek+" Week date from "+sWeekFr+" to "+sWeekTo);	
	
		dateBean.setAdjDate(-1);
		String sDatePre = dateBean.getYearMonthDay();
		String sYearPre = dateBean.getYearString();
		String sMonthPre = dateBean.getMonthString();
		workingDateBean.setWorkingDate(Integer.parseInt(sDatePre.substring(0,4)),Integer.parseInt(sDatePre.substring(4,6)),Integer.parseInt(sDatePre.substring(6,8)));
		String sWeekPre = workingDateBean.getWeekString();
		out.println("<br>"+"Pre-Date="+sDatePre+" Pre-Y/M="+sYearPre+"/"+sMonthPre+"Pre-Week="+sWeekPre);

		// insert into log file
		/*
		psTemp = dmcon.prepareStatement("INSERT INTO t_ctl (cname,cdesc,cpara,cstdt,cendt,csts,cerr) "
		+" VALUES ('T_SHIP_BATCH','SHIP BATCH','DATE="+sDate+"',TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),0,'R','')");
		psTemp.executeUpdate();
		psTemp.close();
		*/
		// clear temp table
		psTemp = dmcon.prepareStatement("DELETE FROM tmp1 ");
		psTemp.executeUpdate();
		psTemp.close();

		//delete weekly data
		psDel = dmcon.prepareStatement("DELETE FROM stock_ship_week WHERE wdatefr>="+sWeekFr);
		psDel.executeUpdate();
		psDel.close();
		// delete monthly data
		psDel = dmcon.prepareStatement("DELETE FROM stock_ship_mon WHERE (ssyear="+sYear+" AND ssmonth>="+sMonth+") OR ssyear>"+sYear);
		psDel.executeUpdate();
		psDel.close();

		//input the day value into temp table
		PreparedStatement psIns = dmcon.prepareStatement("INSERT INTO tmp1 (tmodel,titem,tqty,twqty,tsqty,ttqty,tyqty,tamt,twamt,tsamt,ttamt,tyamt) "+
		" VALUES (?,?,?,?,?,?,?,?,?,?,?,?)" );
		Statement st = dmcon.createStatement();
		ResultSet rs = st.executeQuery("SELECT tmodel,tprod,tqty,tamt "+" FROM t_ship WHERE tdate="+sDate);
		while ( rs.next() ) {
			String sModel = rs.getString("tmodel");
			String sItem = rs.getString("tprod").trim();
			String sQty = rs.getString("tqty");
			String sAmt = rs.getString("tamt");
			//out.println("<br>"+sModel+","+sItem+","+sQty);
			psIns.setString(1,sModel);
			psIns.setString(2,sItem);
			psIns.setString(3,sQty);
			psIns.setString(4,sQty);
			psIns.setString(5,sQty);
			psIns.setString(6,sQty);
			psIns.setString(7,sQty);
			psIns.setString(8,sAmt);
			psIns.setString(9,sAmt);
			psIns.setString(10,sAmt);
			psIns.setString(11,sAmt);
			psIns.setString(12,sAmt);
			psIns.executeUpdate();
		} // end while
		psIns.close();
		rs.close();
		st.close();
	
		//input previous day value into temp table
		psIns = dmcon.prepareStatement("INSERT INTO tmp1 (tmodel,titem,tqty,twqty,tsqty,ttqty,tyqty,tamt,twamt,tsamt,ttamt,tyamt) "+
		" VALUES (?,?,?,?,?,?,?,?,?,?,?,?)" );
		st = dmcon.createStatement();
		rs = st.executeQuery("SELECT dyear,dmonth,dmodelno,ditemno,dqty,dwqty,dsqty,dtqty,dyqty,damt,dwamt,dsamt,dtamt,dyamt "
		+" FROM stock_ship_day WHERE ddate="+sDatePre);
		while (rs.next()) {
			//out.println(rs.getString("dmodelno")+","+rs.getString("ditemno"));
			//跨年或跨月的處理
			String sQtyWeek = rs.getString("dwqty");
			String sQtyMonth = rs.getString("dsqty");
			String sQtyYear = rs.getString("dyqty");
			String sAmtWeek = rs.getString("dwamt");
			String sAmtMonth = rs.getString("dsamt");
			String sAmtYear = rs.getString("dyamt");
			if ( !sWeek.equals(sWeekPre) ) { sQtyWeek = "0"; sAmtWeek = "0";
			}
			if ( !sMonth.equals(sMonthPre) ) { sQtyMonth = "0"; sAmtMonth = "0";
			}
			if ( !sYear.equals(sYearPre) ) { sQtyYear = "0"; sAmtYear = "0";
			}
			psIns.setString(1,rs.getString("dmodelno"));
			psIns.setString(2,rs.getString("ditemno"));
			psIns.setString(3,"0");
			psIns.setString(4,sQtyWeek);
			psIns.setString(5,sQtyMonth);
			psIns.setString(6,rs.getString("dtqty"));
			psIns.setString(7,sQtyYear);
			psIns.setString(8,"0");
			psIns.setString(9,sAmtWeek);
			psIns.setString(10,sAmtMonth);
			psIns.setString(11,rs.getString("dtamt"));
			psIns.setString(12,sAmtYear);
			psIns.executeUpdate();
		} // end while
		psIns.close();
		rs.close();
		st.close();

		//insert into from temp table
		PreparedStatement psDay = dmcon.prepareStatement("INSERT INTO stock_ship_day "
		+" (dyear,dmonth,ddate,dmodelno,ditemno,dqty,dwqty,dsqty,dtqty,dyqty,damt,dwamt,dsamt,dtamt,dyamt "
		+" ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" );
		PreparedStatement psWeek = dmcon.prepareStatement("INSERT INTO stock_ship_week "
		+"(wyear,wmonth,wweek,wdatefr,wdateto,wmodelno,witemno,wqty,wsqty,wtqty,wyqty,wamt,wsamt,wtamt,wyamt "
		+" ) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" );
		PreparedStatement psMon = dmcon.prepareStatement("INSERT INTO stock_ship_mon "
		+"(ssyear,ssmonth,ssmodelno,ssitemno,ssqty,stqty,syqty,ssamt,stamt,syamt "
		+" ) VALUES (?,?,?,?,?,?,?,?,?,?)" );
		st = dmcon.createStatement();
		rs = st.executeQuery("SELECT tmodel,titem,SUM(tqty) AS tqty,SUM(twqty) AS twqty,SUM(tsqty) AS tsqty,SUM(ttqty) AS ttqty,SUM(tyqty) AS tyqty "
		+" ,SUM(tamt) AS tamt,SUM(twamt) AS twamt,SUM(tsamt) AS tsamt,SUM(ttamt) AS ttamt,SUM(tyamt) AS tyamt "
		+" FROM tmp1 GROUP BY tmodel,titem");
		while (rs.next()) {
			out.println("<br>"+rs.getString("tmodel")+","+rs.getString("titem"));
			out.println(","+rs.getString("tqty")+","+rs.getString("twqty")+","+rs.getString("tsqty")+","+rs.getString("tyqty")+","+rs.getString("ttqty"));
			psDay.setString(1,sYear);
			psDay.setString(2,sMonth);
			psDay.setString(3,sDate);
			psDay.setString(4,rs.getString("tmodel"));
			psDay.setString(5,rs.getString("titem"));
			psDay.setString(6,rs.getString("tqty"));
			psDay.setString(7,rs.getString("twqty"));
			psDay.setString(8,rs.getString("tsqty"));
			psDay.setString(9,rs.getString("ttqty"));
			psDay.setString(10,rs.getString("tyqty"));
			psDay.setString(11,rs.getString("tamt"));
			psDay.setString(12,rs.getString("twamt"));
			psDay.setString(13,rs.getString("tsamt"));
			psDay.setString(14,rs.getString("ttamt"));
			psDay.setString(15,rs.getString("tyamt"));
			psDay.executeUpdate();

			psWeek.setString(1,sYear);
			psWeek.setString(2,sMonth);
			psWeek.setString(3,sWeek);
			psWeek.setString(4,sWeekFr);
			psWeek.setString(5,sWeekTo);
			psWeek.setString(6,rs.getString("tmodel"));
			psWeek.setString(7,rs.getString("titem"));
			psWeek.setString(8,rs.getString("twqty"));
			psWeek.setString(9,rs.getString("tsqty"));
			psWeek.setString(10,rs.getString("ttqty"));
			psWeek.setString(11,rs.getString("tyqty"));
			psWeek.setString(12,rs.getString("twamt"));
			psWeek.setString(13,rs.getString("tsamt"));
			psWeek.setString(14,rs.getString("ttamt"));
			psWeek.setString(15,rs.getString("tyamt"));
			psWeek.executeUpdate();

			psMon.setString(1,sYear);
			psMon.setString(2,sMonth);
			psMon.setString(3,rs.getString("tmodel"));
			psMon.setString(4,rs.getString("titem"));
			psMon.setString(5,rs.getString("tsqty"));
			psMon.setString(6,rs.getString("ttqty"));
			psMon.setString(7,rs.getString("tyqty"));
			psMon.setString(8,rs.getString("tsamt"));
			psMon.setString(9,rs.getString("ttamt"));
			psMon.setString(10,rs.getString("tyamt"));
			psMon.executeUpdate();
		} // end while
		psDay.close();
		psWeek.close();
		psMon.close();
		rs.close();
		st.close();

		// clear temp table
		/*
		psTemp = dmcon.prepareStatement("DELETE FROM tmp2 ");
		psTemp.executeUpdate();
		psTemp.close();
		*/

		//generate temp data
		/*
		psTemp = dmcon.prepareStatement("insert into tmp2 (titem,tstdm,tstdl,tstdoh) "
		+" select distinct a.tprod,a.tstdm,a.tstdl,a.tstdoh from t_ship a "
		+" where a.tdate=(select max(b.tdate) from t_ship b where b.tprod=a.tprod)");
		psTemp.executeUpdate();
		psTemp.close();
		*/

		// update standard cost
		/*
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdm = "
		+" (select tstdm from tmp2 where titem=ditemno) where ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdl = "
		+" (select tstdl from tmp2 where titem=ditemno) where ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdoh = "
		+" (select tstdoh from tmp2 where titem=ditemno) where ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdm =0 " // handle null value
		+" where dstdm is null and ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdl =0 " // handle null value
		+" where dstdl is null and ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set dstdoh =0 " // handle null value
		+" where dstdoh is null and ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		psDay = dmcon.prepareStatement("update stock_ship_day set "
		+" dcst=dqty*(dstdm+dstdl+dstdoh),dscst=dsqty*(dstdm+dstdl+dstdoh),dycst=dyqty*(dstdm+dstdl+dstdoh),dtcst=dtqty*(dstdm+dstdl+dstdoh) "
		+" where ddate="+sDate);
		psDay.executeUpdate();
		psDay.close();
		
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdm = "
		+" (select tstdm from tmp2 where titem=ssitemno) where ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdl = "
		+" (select tstdl from tmp2 where titem=ssitemno) where ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdoh = "
		+" (select tstdoh from tmp2 where titem=ssitemno) where ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdm=0 " // handle null value
		+" where sstdm is null and ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdl=0 " // handle null value
		+" where sstdl is null and ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set sstdoh=0 " // handle null value
		+" where sstdoh is null and ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		psMon = dmcon.prepareStatement("update stock_ship_mon set "
		+" sscst=ssqty*(sstdm+sstdl+sstdoh),sycst=syqty*(sstdm+sstdl+sstdoh),stcst=stqty*(sstdm+sstdl+sstdoh) "
		+" where ssyear="+sYear+" and ssmonth="+sMonth);
		psMon.executeUpdate();
		psMon.close();
		*/

		// update log file
		/*
		psTemp = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='S' "
		+" WHERE cname='T_SHIP_BATCH' AND csts='R' AND cpara='DATE="+sDate+"'");
		psTemp.executeUpdate();
		psTemp.close();
		*/

		//set next processing date
		dateBean.setAdjDate(+2); //回到原來那天的隔一天
		sDate = dateBean.getYearMonthDay();

	} // end while
	
	//drop temp table
	psTemp = dmcon.prepareStatement("DROP TABLE tmp1");
	psTemp.executeUpdate();
	psTemp.close();
	psTemp = dmcon.prepareStatement("DROP TABLE tmp2");
	psTemp.executeUpdate();
	psTemp.close();
   


} // end try
catch (Exception ee) { out.println("Exception:"+ee.getMessage()); 
	try {
		PreparedStatement psTemp = dmcon.prepareStatement("DROP TABLE tmp1");
		psTemp.executeUpdate();
		psTemp.close();
		psTemp = dmcon.prepareStatement("DROP TABLE tmp2");
		psTemp.executeUpdate();
		psTemp.close();
	
		// update log file
		/*
		psTemp = dmcon.prepareStatement("UPDATE t_ctl SET cendt=TO_CHAR(SYSDATE,'YYYYMMDDHH24MISS'),csts='F',cerr='"+ee.getMessage()+"' "
		+" WHERE cname='T_SHIP_BATCH' AND csts='R' AND cpara='DATE="+sDate+"'");
		psTemp.executeUpdate();
		psTemp.close();
		*/
%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%	} catch (Exception eee) { out.println("Exception:"+eee.getMessage());
	} // end try-catch
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
<title>出貨統計</title>
</head>

<body>

</body>
</html>
