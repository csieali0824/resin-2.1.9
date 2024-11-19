<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="SalesDRQPageHeaderBean" %-->
<!--jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/-->
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
<title>The History Record about WorkOrder Transaction Data</title>
</head>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<% 
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 3]cw‥C?g2A?@?N?°?P’A?e  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // ‥u°_cl?g2A?@?N
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // ‥u°_cl?g3I?a?@?N 
  String currentWeek = workingDateBean.getWeekString();

  String woNo=request.getParameter("WONO");
  String runCardNo=request.getParameter("RUNCARDNO");
  
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
  if (YearTo==null && MonthTo==null && DayTo==null) dateSetEnd="20101231"; 
  else  dateSetEnd = YearTo+MonthTo+DayTo;
  
  String oriQty="", oriReason="",creationDate="",creationBy="",updateQty="",updateReason="" ;

  
   
  String conti="N";
  int k=1;
  
  try
  {   
    String sqla = " SELECT ORGANIAL_QTY,ORGANIAL_REASON,CREATION_DATE,CREATION_BY,UPDATED_QTY,UPDATED_REASON FROM YEW_WO_TRANSACTIONS ";
    String where = " WHERE WO_NO= '"+woNo+"' ";
	 			   				   				 
    String orderBy = " order by CREATION_DATE ";				 			   				   
	 
    sqla = sqla + where + orderBy;	
     //out.println("sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqla);	
    
   %>
     <TABLE cellSpacing='0' bordercolordark='#FFCC99' cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR BGCOLOR='#FFFFCC'>
	   <TH NOWRAP><FONT  COLOR='#CC6000'>No</FONT></TH>
	   <TH NOWRAP><FONT  COLOR='#CC6600'>異動日期</FONT></TH>	   
	   <TH NOWRAP><FONT  COLOR='#CC6000'>原始數量</FONT></TH>
	   <TH NOWRAP><FONT  COLOR='#CC6600'>原始備註</FONT></TH>
	   <TH NOWRAP><FONT  COLOR='#CC6600'>異動後數量</FONT></TH>
	   <TH NOWRAP><FONT  COLOR='#CC6600'>異動後備註</FONT></TH>
	   <TH NOWRAP><FONT  COLOR='#CC6600'>異動人</FONT></TH>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
   
   
     oriQty=rs.getString("ORGANIAL_QTY");  
	 oriReason=rs.getString("ORGANIAL_REASON");
	 creationDate=rs.getString("CREATION_DATE");
	 creationBy=rs.getString("CREATION_BY");
	 updateQty=rs.getString("UPDATED_QTY");
	 updateReason=rs.getString("UPDATED_REASON");
    %>	 
	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT SIZE=2><%=k%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=creationDate%></FONT></TD>	   
	   <TD NOWRAP><FONT SIZE=2><%=oriQty%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=oriReason%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=updateQty%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=updateReason%></FONT></TD>
	   <TD NOWRAP><FONT SIZE=2><%=creationBy%></FONT></TD>	   
    </TR> 
	<%
	k=k+1;
   } //end of while
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

