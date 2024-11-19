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
<title>The History Record about RunCard Transaction Data</title>
</head>
<body>
<A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A> 
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
  
  String invItem="", itemDesc="",transactionDate="",frOpSeqNum="",frOpCode="",toOpSeqNum="",toOpCode="";
  String stepTypeCode="",qtyInInput="",transactionQty="",transactionUom="",lastUpdateBy="",lastUpdateDate="",wkTime="";

  String Sql="";
  String conti="N";
  int k=1;
  
  try
  {   
    String sql = " select YRA.INV_ITEM                  "+
                 "       ,YRA.ITEM_DESC                 "+
                 "       ,WMT.TRANSACTION_DATE          "+
                 "       ,WMT.FM_OPERATION_CODE         "+
                 "       ,WIOFM.DESCRIPTION FM_OP_CODE  "+
       			 "       ,WMT.TO_OPERATION_CODE         "+
       			 "       ,WIOTO.DESCRIPTION TO_OP_CODE  "+
       			 "       ,YRR.QTY_IN_INPUT              "+
       			 "       ,WMT.ORGANIZATION_ID           "+
       			 "       ,wmt.FM_OPERATION_SEQ_NUM      "+
				 "		 ,decode(WMT.TO_INTRAOPERATION_STEP_TYPE,'1','QUEUE','2','RUN','3','TO MOVE','5','SCRAP') as ACTION  "+ 
				 "       ,WMT.TRANSACTION_QUANTITY      "+
				 "       ,WMT.TRANSACTION_UOM           "+
				 "       ,FU.USER_NAME                  "+
				 "       ,WMT.LAST_UPDATE_DATE          "+
				 "       ,WMT.WIP_ENTITY_ID             "+  
   				 "   from WIP_MOVE_TRANSACTIONS WMT     "+
   				 "       ,YEW_RUNCARD_ALL YRA           "+
   				 "       ,FND_USER FU                   "+
   				 "       ,WIP_OPERATIONS WIOFM          "+
				 "       ,WIP_OPERATIONS WIOTO          "+
				 "       ,YEW_RUNCARD_RESTXNS YRR       ";
    String where = " where 1=1                          "+
                   "   and WMT.ATTRIBUTE2           = YRA.RUNCARD_NO           "+
                   "   and FU.USER_ID               = WMT.LAST_UPDATED_BY      "+
    			   "   and wmt.FM_OPERATION_SEQ_NUM = wiofm.OPERATION_SEQ_NUM  "+
    			   "   and wmt.WIP_ENTITY_ID        = wiofm.WIP_ENTITY_ID      "+
				   "   and wmt.TO_OPERATION_SEQ_NUM = wioto.OPERATION_SEQ_NUM  "+
				   "   and wmt.WIP_ENTITY_ID        = wioto.WIP_ENTITY_ID      "+  
                   "   and WMT.ATTRIBUTE2           = YRR.RUNCARD_NO           "+
                   "   and WIOFM.OPERATION_SEQ_NUM  = YRR.OPERATION_SEQ_NUM    "+
                   "   and WMT.ATTRIBUTE2           = '"+ runCardNo +"'        ";
		 
    String orderBy = " order by WMT.TRANSACTION_DATE ";				 			   				   

    sql = sql + where + orderBy;	
    // out.println("sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sql);	

   %>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' align='left' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">
	   <TD NOWRAP><FONT color="#FFFFFF">No</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>RunCard No</FONT></TD>
	   <!--TD NOWRAP><FONT COLOR='#FFFFFF'>Item</FONT--></TD>
	   <!--TD NOWRAP><FONT COLOR='#FFFFFF'>Item Desc</FONT--></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Transaction Date</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Work Time</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>From Op</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Op Code</FONT></TD>
       <TD NOWRAP><FONT COLOR='#FFFFFF'>Qty In Input</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>To Op</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Op Code</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Action</FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#FFFFFF'>QTY</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>UOM</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Update By</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>Update Date</FONT></TD>
	  </TR> 
   <%   
   while (rs.next())
   { 
     invItem        = rs.getString("INV_ITEM");
	 itemDesc       = rs.getString("ITEM_DESC");
	 transactionDate= rs.getString("TRANSACTION_DATE");
	 frOpSeqNum     = rs.getString("FM_OPERATION_CODE");
	 frOpCode       = rs.getString("FM_OP_CODE");
     qtyInInput     = rs.getString("QTY_IN_INPUT");
	 toOpSeqNum     = rs.getString("TO_OPERATION_CODE");
	 toOpCode       = rs.getString("TO_OP_CODE");
	 stepTypeCode   = rs.getString("ACTION");
	 transactionQty = rs.getString("TRANSACTION_QUANTITY");
	 transactionUom = rs.getString("TRANSACTION_UOM");
	 lastUpdateBy   = rs.getString("USER_NAME");
	 lastUpdateDate = rs.getString("LAST_UPDATE_DATE");
     if (qtyInInput==null || qtyInInput.equals("")) qtyInInput="&nbsp;";


    //顯示工時資訊
     String wkSql =" select sum(transaction_quantity) WK_TIME  from wip_transactions where transaction_type=1  "+
				   "    and wip_entity_id = "+rs.getString("WIP_ENTITY_ID")+" and organization_id = "+rs.getString("ORGANIZATION_ID")+"  "+
				   "    and attribute2= '"+runCardNo+"'   and OPERATION_SEQ_NUM= '"+rs.getString("FM_OPERATION_SEQ_NUM")+"' ";
    //out.print("wkSql="+wkSql);
    Statement wkstate=con.createStatement(); 
    ResultSet wkrs=wkstate.executeQuery(wkSql);	
    if  (wkrs.next())
    {
     wkTime=wkrs.getString("WK_TIME");
    }
    wkrs.close();   
    wkstate.close();
    if (wkTime==null || wkTime.equals("")) wkTime="&nbsp;";

    %>	 	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'><%=k%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=runCardNo%></FONT></TD>
	   <!--TD NOWRAP><FONT COLOR='#000000'><%//=invItem%></FONT--></TD>
	   <!--TD NOWRAP><FONT COLOR='#000000'><%//=itemDesc%></FONT--></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=transactionDate%></FONT></TD>
        <TD NOWRAP align="right"><FONT COLOR='#000000'><%=wkTime%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=frOpSeqNum%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=frOpCode%></FONT></TD>
       <TD NOWRAP align="right"><FONT COLOR='#000000'><%=qtyInInput%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=toOpSeqNum%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=toOpCode%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=stepTypeCode%></FONT></TD>
	   <TD NOWRAP align="right"><FONT COLOR='#000000'><%=transactionQty%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=transactionUom%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=lastUpdateBy%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=lastUpdateDate%></FONT></TD>
	  </TR> 
	<%
	k=k+1;
   } //end of while
   //out.println("</TABLE>");
   rs.close();   
   statement.close();
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 </TABLE>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

