<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="RsBean,WorkingDateBean" %>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>The History Record about Sales Delivery  Request Data</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>  
<% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
  String currentWeek = workingDateBean.getWeekString();

  String dnDocNo=request.getParameter("DNDOCNO");
  String distDnDocNo="'"+request.getParameter("DISTDNDOCNO")+"'";
  
  String dateSetBegin=request.getParameter("DATESETBEGIN");
  String dateSetEnd=request.getParameter("DATESETEND");
  
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");    
  if (YearFr==null && MonthFr==null && DayFr==null) dateSetBegin="20060110"; 
  else  dateSetBegin = YearFr+MonthFr+DayFr;  

  String YearTo=request.getParameter("YEARTO");
  String MonthTo=request.getParameter("MONTHTO");
  String DayTo=request.getParameter("DAYTO");
  if (YearTo==null && MonthTo==null && DayTo==null) dateSetEnd="20991231"; 
  else  dateSetEnd = YearTo+MonthTo+DayTo;
  
  String salesAreaNo=request.getParameter("SALESAREANO");
  String prodManufactory=request.getParameter("PRODMANUFACTORY");
  
  
  
  String imei="",dup_imei="";
  String Sql="";
  String conti="N";
  try
  {   
   Statement statement=con.createStatement();
   
   
   Sql = " select DNDOCNO || '-' || ASSIGN_LNO from ORADDMAN.TSDELIVERY_NOTICE_DETAIL where DNDOCNO !='"+dnDocNo+"'"; //取出是否有拆單(指派於兩個生產地)
   ResultSet rsR=statement.executeQuery(Sql);
   while (rsR.next())
   {
        distDnDocNo = distDnDocNo+",'"+rsR.getString(1)+"'";
   }
   rsR.close(); 
   //out.println(Sql); 
//   out.println(repNo); 
   //ResultSet rs=statement.executeQuery("select * from RPREPHISTORY WHERE REPNO='"+repNo+"' ORDER BY UPDATEDATE,UPDATETIME");
   
  String sql = "select DISTINCT a.DNDOCNO,a.LINE_NO,d.ITEM_DESCRIPTION, a.ORISTATUS as STATUSDESC, "+
               "       a.ORISTATUS, a.ACTIONNAME, a.UPDATEUSERID, "+
               "       TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'), "+
			   "       b.SALES_AREA_NAME, d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, f.DNDOCNO as NEW_DNDOCNO, a.REMARK "+
			   "  from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a, ORADDMAN.TSSALES_AREA b, "+
			   "       ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, "+
			   "       ORADDMAN.TSPROD_MANUFACTORY e, ORADDMAN.TSDELIVERY_NOTICE f ";
  String where = " where a.DNDOCNO = c.DNDOCNO and a.DNDOCNO = d.DNDOCNO "+
				 //"   and (a.DNDOCNO = '"+dnDocNo+"' ) and a.LINE_NO = d.LINE_NO "+
				 "   and a.LINE_NO = d.LINE_NO "+
			     "   and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
				 // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
				 "   and c.TSAREANO=b.SALES_AREA_NO and b.LOCALE='"+locale+"' "+
			     "   and c.DNDOCNO = f.ORIDOCNO(+) "; 			 			   				   				 
 String orderBy = " order by a.DNDOCNO, a.LINE_NO, TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";				 			   				   
    
     if (dnDocNo==null || dnDocNo.equals("")) {} 
	 else { where=where+" and a.DNDOCNO = '"+dnDocNo+"' "; }
 
     if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") where=where+" and substr(d.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
     if (DayFr!="--" && DayTo!="--") where=where+" and substr(d.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(d.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 									   
	 if (salesAreaNo!=null && !salesAreaNo.equals(""))  { where=where+" and substr(d.DNDOCNO,3,3) ='"+salesAreaNo+"'"; }
	 if (prodManufactory==null || prodManufactory.equals("")) {where=where+" ";}
     else {where=where+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
	 
   sql = sql + where + orderBy;	 
   sql = "select DISTINCT a.DNDOCNO,a.LINE_NO, a.ORISTATUS as STATUSDESC,TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'), a.REMARK from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where a.DNDOCNO = '"+dnDocNo+"'  ";
   ResultSet rs=statement.executeQuery(sql);	
	 
   ResultSetMetaData md=rs.getMetaData();
   int colCount=md.getColumnCount();
   //rsBean.setRs(rs);   
   out.println("sql="+sql);
   out.println("<TABLE cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='97%' align='left' bordercolorlight='#FFFFFF'  border='1'>");
   out.println("<TR BGCOLOR='#665500'><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgQDocNo"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgAnItem"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgWKFDESC"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgOriStat"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgAction"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%>
   <jsp:getProperty name="rPH" property="pgExecutor"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgExeTime"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgSalesArea"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgDocAssignFac"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgNewNo"/><jsp:getProperty name="rPH" property="pgQDocNo"/><%out.println("</TH><TH><FONT SIZE=2 COLOR='#FFFFF6'>");%><jsp:getProperty name="rPH" property="pgRemark"/><%out.println("</TH></TR>");
   while (rs.next())
   {
   
     out.println("<TR BGCOLOR='#FFFFFF'>");
      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
		if (s==null || s.equals("") || s.equals("null"))
		{ s="&nbsp;" ;}
		if (i==4)
		{ 
		   String statusDesc = "";
		   Statement stateFLDESC=con.createStatement();
           ResultSet rsFLDESC=stateFLDESC.executeQuery("select STATUSDESC from ORADDMAN.TSWFSTATUS where STATUSNAME = '"+s+"' ");
		   if (rsFLDESC.next())
		   {
		     statusDesc = rsFLDESC.getString("STATUSDESC");
		   }
		   rsFLDESC.close();
		   stateFLDESC.close(); 
		   out.println("<TD><FONT SIZE=2>"+statusDesc+"</TD>");
	    }
        else
		{ out.println("<TD><FONT SIZE=2>"+s+"</TD>"); }
       } //end of for
       out.println("</TR>"); 
	   
   }
   out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
