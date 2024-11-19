<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
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
<A HREF="/oradds/ORADDSMainMenu.jsp">首頁</A> 
<% 
   //out.println("0");
  String marketType=request.getParameter("ORGANIZATION_ID");
  String acctPeriodID=request.getParameter("ACCT_PERIOD"); 
  String operationCode=request.getParameter("OPERATION_CODE"); 
  String partNo=request.getParameter("PART_NO");
  
   
   String orgOU = "";
   Statement stateOU=con.createStatement();   
   ResultSet rsOU=stateOU.executeQuery("select ORGANIZATION_ID from hr_organization_units where NAME like 'YEW%OU%' ");
   if (rsOU.next())
   {
     orgOU = rsOU.getString(1);
   }
   rsOU.close();
   stateOU.close();
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 //cs1.setString(1,"305"); 
	 cs1.setString(1,orgOU);  /*  41 --> 為台半半導體  42 --> 為事務機   325 --> YEW SEMI  */ 
	 cs1.execute();
     // out.println("Procedure : Execute Success !!! ");
     cs1.close(); 
	 
	
 %>   
 </TABLE><BR>
<%
  
  
  String Sql="";
  String conti="N";
  int k=1;
  
  try
  {   
                                   
			       String sqlDTL = " select YWA.WO_NO, YWA.ITEM_DESC,  "+
				                     "      sum(YWW.QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, sum(YWW.QUANTITY_RECEIVED) as QUANTITY_RECEIVED, "+
									 "      sum(YWW.QUANTITY_PROCESSED) as QUANTITY_PROCESSED, sum(YWW.QUANTITY_COMPLETED) as QUANTITY_COMPLETED, "+
									 "      sum(YWW.QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, sum(YWW.QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE, "+
									 "      sum(YWW.WORK_TIME) as WORK_TIME "+
									 "   from YEW_WIP_WIPIO YWW , YEW_WORKORDER_ALL YWA ";
			       String whereDTL = " where YWW.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID and YWW.PART_NO = '"+partNo+"' "+
				                     "   and YWW.OPERATION_CODE = '"+operationCode+"' and YWW.ORGANIZATION_ID = "+marketType+" "+
									 "   and YWW.ACCT_PERIOD_ID = "+acctPeriodID+"  "+
				                     "   and YWW.DEPT_NO in ('1','2','3') "; //  確保由生產系統(不含一月份舊系統麗玲手開工令)	  	
				   String groupDTL = " group by YWA.WO_NO, YWA.ITEM_DESC ";						  
				   String orderDTL = " order by YWA.WO_NO, YWA.ITEM_DESC "; 				   
				   sqlDTL = sqlDTL + whereDTL + groupDTL + orderDTL;			 			   				   
	 
     
    //out.println("sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sqlDTL);	
    
   %>
    <BR><font color="#330066" size="+2">工令站別統計處理明細 :</font><font color="#993333" size="+2">(</font><font color="#993300" size="+2"><%=partNo%></font><font color="#993333" size="+2">)</font>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">
	   <TD width="4%" NOWRAP><FONT color="#FFFFFF">項次</FONT></TD>	   
	   <TD width="17%" NOWRAP><FONT COLOR='#FFFFFF'>工令號</FONT></TD>
	   <TD width="17%" NOWRAP><FONT COLOR='#FFFFFF'>產品型號</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>期初</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>接收</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>產出</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>損耗</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>期末</FONT></TD>
	   <TD width="9%" NOWRAP><FONT COLOR='#FFFFFF'>工時</FONT></TD>		  
	   <TD width="17%" NOWRAP><FONT COLOR='#FFFFFF'>備註說明</FONT></TD>	   
	  </TR> 
   <%   
   while (rs.next())
   {   
	 
   //out.println("2");
	
   String lineNo="",wipEntityName="",prodName="",beginQty="",receiptQty="";
   String outputQty="",scrapQty="", endQty="",workTime="",processRemark="";
   //out.println("3");
     lineNo=Integer.toString(k);  
	 wipEntityName=rs.getString("WO_NO");
	 prodName=rs.getString("ITEM_DESC");
	 beginQty=rs.getString("QUANTITY_BEGIN_BALANCE");	 
	 receiptQty=rs.getString("QUANTITY_RECEIVED");	 
	 outputQty=rs.getString("QUANTITY_COMPLETED");
	 scrapQty=rs.getString("QUANTITY_SCRAPPED");
	 endQty=rs.getString("QUANTITY_END_BALANCE");
	 
	 workTime=rs.getString("WORK_TIME");
	 processRemark="&nbsp;";
	 
	//out.println("4"); 
    %>	 	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'><%=lineNo%></FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#000000'><%=wipEntityName%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=prodName%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=beginQty%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=receiptQty%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=outputQty%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=scrapQty%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=endQty%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=workTime%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=processRemark%></FONT></TD>	  
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

