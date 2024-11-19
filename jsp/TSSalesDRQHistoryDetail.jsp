<%@ page language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<STYLE TYPE='text/css'>
  .style1 {color: #003399}
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
             
</STYLE>
<title>The History Record about Sales Delivery  Request Data</title>
</head>
<body>
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>   
<% 
workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
String currentWeek = workingDateBean.getWeekString();
String dnDocNo=request.getParameter("DNDOCNO");
String lineNo=request.getParameter("LINENO");
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
if (YearTo==null && MonthTo==null && DayTo==null) dateSetEnd="20991231";   //20110110 update to 20991231
else  dateSetEnd = YearTo+MonthTo+DayTo;
String salesAreaNo=request.getParameter("SALESAREANO");
String prodManufactory=request.getParameter("PRODMANUFACTORY");
String Sql="";
String conti="N";
try
{   
	Statement statement=con.createStatement();
   
	String sql = "select DISTINCT a.DNDOCNO,a.LINE_NO,d.ITEM_DESCRIPTION, a.ORISTATUS as STATUSDESC, "+
               "       a.ORISTATUS, a.ACTIONNAME, a.UPDATEUSERID, "+
               "       TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'), "+
			   "       b.ALCHNAME, d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, f.DNDOCNO as NEW_DNDOCNO, nvl(a.remark,d.REMARK) remark,d.REASONDESC,a.PC_REMARK "+
			   "       ,a.ORISTATUSID"+ //add ORISTATUSID field by Peggy 20120405		
			   "       ,substr(a.ARRANGED_DATE,1,8) ARRANGED_DATE "+ //add by Peggy 20130614	 		
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
 	String orderBy = " order by a.DNDOCNO, a.LINE_NO, TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'),a.ORISTATUSID";		   				   
    
	if (dnDocNo==null || dnDocNo.equals("")) {} 
	else { where=where+" and a.DNDOCNO = '"+dnDocNo+"' "; }
	 
	if (lineNo==null || lineNo.equals("")) {} 
	else { where=where+" and to_char(d.LINE_NO) = '"+lineNo+"' "; }
 
	if (salesAreaNo!=null && !salesAreaNo.equals(""))  { where=where+" and c.TSAREANO ='"+salesAreaNo+"'"; }
	if (prodManufactory==null || prodManufactory.equals("")) {where=where+" ";}
    else {where=where+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
	 
   	sql = sql + where + orderBy;	 
   	ResultSet rs=statement.executeQuery(sql);	
    
	out.println("<TABLE cellSpacing='1' bordercolordark='#6699CC' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1' bardorcolor='#003399'>");
   	out.println("<TR BGCOLOR='#003399'><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgQDocNo"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgAnItem"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgWKFDESC"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgOriStat"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgAction"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
   	<jsp:getProperty name="rPH" property="pgExecutor"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
   	<jsp:getProperty name="rPH" property="pgFactoryDeDate"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgExeTime"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgSalesArea"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgDocAssignFac"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgNewNo"/><jsp:getProperty name="rPH" property="pgQDocNo"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>");
	%>
	<jsp:getProperty name="rPH" property="pgRemark"/>
	<%
	out.println("</TD><TD NOWRAP><FONT COLOR='#FFFFFF'>PC Remark</TD></TR>");
   	while (rs.next())
   	{   
    	out.println("<TR BGCOLOR='#FFFFFF'>");
	 	out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(1)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(2)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(3)+"</TD>");
	    String statusDesc = "";
		Statement stateFLDESC=con.createStatement();
        ResultSet rsFLDESC=stateFLDESC.executeQuery("select STATUSDESC from ORADDMAN.TSWFSTATUS where STATUSNAME = '"+rs.getString(4)+"' ");
		if (rsFLDESC.next())
		{
			statusDesc = rsFLDESC.getString("STATUSDESC");
		}
		rsFLDESC.close();
		stateFLDESC.close(); 

     	String resonDesc ="",newDoc="",comment="",pcRemark="";

     	newDoc =  rs.getString(11);
     	comment =  rs.getString(12);
     	resonDesc =  rs.getString(13);
     	pcRemark =  rs.getString(14);

     	if (newDoc==null || newDoc.equals("null")) newDoc="&nbsp;";  //rs.getString(11);
     	if (comment==null || comment.equals("null")) comment="&nbsp;";  // rs.getString(12);
     	if (resonDesc==null || resonDesc.equals("N/A")) resonDesc="&nbsp;"; //rs.getString(13);
     	if (pcRemark==null || pcRemark.equals("null")) pcRemark="&nbsp;";    //rs.getString(14);

	 	out.println("<TD NOWRAP><FONT COLOR='#000000'>"+statusDesc+"</TD>");
	 	out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(5)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(6)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(7)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(16)+"</TD>"); //add by Peggy 20130614
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(8)+"</TD>");
	 	out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(9)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+rs.getString(10)+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+newDoc+"</TD>");
	 	out.println("<TD NOWRAP><FONT COLOR='#000000'>"+comment+"</TD>");
		out.println("<TD NOWRAP><FONT COLOR='#000000'>"+resonDesc+pcRemark+"</TD>");  //20101202
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

