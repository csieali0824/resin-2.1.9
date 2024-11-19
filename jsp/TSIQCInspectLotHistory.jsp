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
  String inquType=request.getParameter("INQUTYPE");
  String inspLotNo=request.getParameter("INSPLOTNO"); 
  String line_No=request.getParameter("LINE_NO"); 
  String interfaceID=request.getParameter("ID");
  
  String vendorLotNum=request.getParameter("VENDORLOTNO");
  
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
  
  //String invItem="", itemDesc="",transactionDate="",frOpSeqNum="",frOpCode="",toOpSeqNum="",toOpCode="";
  //String stepTypeCode="",transactionQty="",transactionUom="",lastUpdateBy="",lastUpdateDate="";
  
  if (inquType==null || inquType.equals(""))  inquType = "IQC"; // 由IQC 查詢,則含倉庫暫收資訊皆顯示
  
  if (inspLotNo==null || inspLotNo.equals("") || inspLotNo.equals("null")) inspLotNo = "尚未檢驗";
  
  if (interfaceID==null || interfaceID.equals("")) interfaceID = "";
  
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
	 
	/*  
	 if (interfaceID==null || interfaceID.equals(""))
	 { // 以IQC查詢,則找出當初暫收ID
	    //  取PO收料接收日期  // 
	    
	   String sqlRCVDate = "select INTERFACE_TRANSACTION_ID from RCV_TRANSACTIONS where ATTRIBUTE6 = '"+inspLotNo+"' and TRANSACTION_TYPE ='RECEIVE' ";
	   Statement stateRCVDate=con.createStatement(); 
       ResultSet rsRCVDate=stateRCVDate.executeQuery(sqlRCVDate); 
	   if (rsRCVDate.next())
	   {
	      interfaceID = rsRCVDate.getString("INTERFACE_TRANSACTION_ID");
	   }
	   rsRCVDate.close();
	   stateRCVDate.close();
	   //  取PO收料接收日期  //	 
	 }
     */ 
 %>
   <%
      String sqlRCV = " select ROWNUM, a.RECEIPT_NUM, a.PO_NUM, a.ATTRIBUTE6, a.VENDOR_LOT_NUM, a.VENDOR_NAME, a.VENDOR_LOT_NUM, "+
	                  "        a.ITEM_DESC, a.TRANSACT_QTY, a.TRANSACT_UOM, a.TRANSACTION_TYPE, b.USER_NAME, a.TRANSACTION_DATE "+		 
 			          "   from RCV_VRC_TXS_V a, FND_USER b ";
      String whereRCV = " where a.CREATED_BY = b.USER_ID ";	                  
	                   // "   and a.TRANSACTION_TYPE ='RECEIVE' ";
      String orderByRCV = "order by a.TRANSACTION_DATE ";
   %>
     <BR><font color="#330066" size="+2">倉庫接收資訊</font><font color="#993333" size="+2">(</font><font color="#993300" size="+2"><%=interfaceID%></font><font color="#993333" size="+2">)</font>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">
	   <TD NOWRAP><FONT color="#FFFFFF">項序</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收類型</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>供應商</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>暫收單號</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收日期</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收數量</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收單位</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>品名/規格</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>執行人員</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>批號</FONT></TD>	   
	  </TR> 
 <%
       if (interfaceID!=null && !interfaceID.equals(""))  whereRCV = whereRCV + "and a.INTERFACE_TRANSACTION_ID = "+interfaceID+" ";
	   if (vendorLotNum!=null && !vendorLotNum.equals("")) whereRCV = whereRCV + " and a.VENDOR_LOT_NUM = '"+vendorLotNum+"' ";
	   if (inspLotNo!=null && !inspLotNo.equals("")) whereRCV = whereRCV + " and a.ATTRIBUTE6 = '"+inspLotNo+"' ";
       sqlRCV = sqlRCV + whereRCV + orderByRCV;	
    //out.println("sqlRCV="+sqlRCV);
    Statement stateRCV=con.createStatement(); 
    ResultSet rsRCV=stateRCV.executeQuery(sqlRCV);
	while (rsRCV.next())
    {
 %>	
	  <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("ROWNUM")%></FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("TRANSACTION_TYPE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("VENDOR_NAME")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("RECEIPT_NUM")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getDate("TRANSACTION_DATE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("TRANSACT_QTY")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("TRANSACT_UOM")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("ITEM_DESC")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("USER_NAME")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("VENDOR_LOT_NUM")%></FONT></TD>	   	  
	  </TR>     
 <%  
    } // End of while	 
	rsRCV.close();
	stateRCV.close(); 
	
 %>
 </TABLE><BR>
<%
 if (inquType.equals("IQC")) // 已經IQC檢驗批
 {
  
  String Sql="";
  String conti="N";
  int k=1;
  
  try
  {   
    String sql = " select DISTINCT IQHI.SERIALROW, IQH.INSPLOT_NO, IQD.LINE_NO, IQH.IQC_CLASS_CODE, IQH.SUPPLIER_NAME, IQD.PO_NO, IQD.RECEIPT_NO, to_char(to_date(IQD.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as INSPECT_DATE, "+
       		     "        IQHI.ORISTATUSID, IQHI.ORISTATUS, IQHI.ACTIONNAME, IQHI.UPDATEUSERID, FU.DESCRIPTION, to_char(to_date(IQHI.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CDATETIME, "+
				 "        IQHI.PROCESS_REMARK, IQD.INTERFACE_TRANSACTION_ID, IQS.CLASS_NAME, FU.USER_NAME "+			 
 			     "   from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQH, ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQD, "+
				 "        ORADDMAN.TSCIQC_LOTINSPECT_HISTORY IQHI, FND_USER FU, ORADDMAN.TSCIQC_CLASS IQS ";
    String where = " where IQH.INSPLOT_NO=IQD.INSPLOT_NO and FU.USER_NAME=IQHI.UPDATEUSERID "+
	               "   and IQHI.INSPLOT_NO = IQD.INSPLOT_NO  and IQD.LINE_NO = IQHI.LINE_NO "+
				   "   and IQH.IQC_CLASS_CODE = IQS.CLASS_ID and IQH.PO_NUMBER = IQD.PO_NO "+
	               "   and IQD.INSPLOT_NO = '"+inspLotNo+"' ";
				   
	if (line_No!=null && !line_No.equals("")) where = where + "and IQD.LINE_NO = "+line_No+" ";
	 			   				   				 
    String orderBy = " order by IQD.LINE_NO, IQHI.SERIALROW ";				 			   				   
	 
    sql = sql + where + orderBy;	
    //out.println("sql="+sql);
    Statement statement=con.createStatement(); 
    ResultSet rs=statement.executeQuery(sql);	
    
   %>
    <BR><font color="#330066" size="+2">檢驗批單號 :</font><font color="#993333" size="+2">(</font><font color="#993300" size="+2"><%=inspLotNo%></font><font color="#993333" size="+2">)</font>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">
	   <TD NOWRAP><FONT color="#FFFFFF">項次</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>檢驗類型</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>供應商</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>採購單號</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收日期</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>檢驗日期</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>原狀態</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>執行動作</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>執行人員</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>執行日期</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>備註說明</FONT></TD>	   
	  </TR> 
   <%   
   while (rs.next())
   { 
     //out.println("1");
     //  取PO收料接收日期  // 
	   String receiptDate = "";
	   String sqlRCVDate = "select to_char(TRANSACTION_DATE,'YYYY/MM/DD HH24:MI:SS') as TRANSACTION_DATE from RCV_TRANSACTIONS where INTERFACE_TRANSACTION_ID = "+rs.getString("INTERFACE_TRANSACTION_ID")+" ";
	   Statement stateRCVDate=con.createStatement(); 
       ResultSet rsRCVDate=stateRCVDate.executeQuery(sqlRCVDate); 
	   if (rsRCVDate.next())
	   {
	      receiptDate = rsRCVDate.getString(1);
	   }
	   rsRCVDate.close();
	   stateRCVDate.close();
	 //  取PO收料接收日期  // 
	 
   //out.println("2");
	
   String itemNo="",className="",supplierName="",poNum="",inspectDate="";
   String action="",oriStatusId="",oriStatus="",lastUpdateBy="",lastUpdateDate="",processRemark="";
   //out.println("3");
     itemNo=rs.getString("LINE_NO");  
	 className=rs.getString("CLASS_NAME");
	 supplierName=rs.getString("SUPPLIER_NAME");
	 poNum=rs.getString("PO_NO");	 
	 inspectDate=rs.getString("INSPECT_DATE");	 
	 action=rs.getString("ACTIONNAME");
	 oriStatusId=rs.getString("ORISTATUSID");
	 oriStatus=rs.getString("ORISTATUS");
	 lastUpdateBy=rs.getString("USER_NAME");
	 lastUpdateDate=rs.getString("CDATETIME");
	 processRemark=rs.getString("PROCESS_REMARK");
	 oriStatus = oriStatusId + "("+oriStatus+")";
	//out.println("4"); 
    %>	 	 
     <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'><%=itemNo%></FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#000000'><%=className%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=supplierName%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=poNum%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=receiptDate%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=inspectDate%></FONT></TD>
	   <TD NOWRAP align="center"><FONT COLOR='#000000'><%=oriStatus%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=action%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=lastUpdateBy%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=lastUpdateDate%></FONT></TD>
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
  
 }  // End of if (inquType.equals("IQC"))
%>
 </TABLE>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

