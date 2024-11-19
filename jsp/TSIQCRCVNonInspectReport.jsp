<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="WorkingDateBean,DateBean" %>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<script language="JavaScript" type="text/JavaScript">
function setGeneratePDF(URL)
{
  document.DISPLAYREPAIR.action=URL;  
  document.DISPLAYREPAIR.submit();  
}
</script>
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
<title>The Receipt Exceed 3 Days non-Inspect Report</title>
</head>
<body>
<FORM NAME="DISPLAYREPAIR" ACTION="../jsp/TSIQCRCVNonInspectReport.jsp" METHOD="post">
<A HREF="/oradds/ORADDSMainMenu.jsp">首頁</A> 
<% 
   //out.println("0");
  String inquType=request.getParameter("INQUTYPE");
  String inspLotNo=request.getParameter("INSPLOTNO"); 
  String line_No=request.getParameter("LINE_NO"); 
  String interfaceID=request.getParameter("ID");
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
      String sqlRCV = " select ROWNUM, RT.INTERFACE_TRANSACTION_ID, RT.PO_HEADER_ID, RT.UOM_CODE, RT.VENDOR_ID, replace(RT.VENDOR_LOT_NUM,'null','') as VENDOR_LOT_NUM, RT.CURRENCY_CODE, "+
	                  "        RSH.RECEIPT_NUM, PH.SEGMENT1, RT.PO_LINE_ID, RT.PO_LINE_LOCATION_ID, RT.SHIPMENT_HEADER_ID, RT.SHIPMENT_LINE_ID, RT.ORGANIZATION_ID, "+
	                  "        RT.SOURCE_DOC_QUANTITY, PL.ITEM_DESCRIPTION, RT.QUANTITY, RT.TRANSACTION_TYPE, b.USER_NAME, RT.TRANSACTION_DATE, "+
					  "        RSL.QUANTITY_SHIPPED, RSL.QUANTITY_RECEIVED  "+		 
 			          "   from RCV_TRANSACTIONS RT, FND_USER b, PO_HEADERS_ALL PH, PO_LINES_ALL PL, RCV_SHIPMENT_HEADERS RSH, RCV_SHIPMENT_LINES RSL ";
					  //"       ,( select count(SHIPMENT_LINE_ID) as COUNT_RCV, SHIPMENT_LINE_ID from RCV_TRANSACTIONS where TRANSACTION_TYPE='RECEIVE' group by SHIPMENT_LINE_ID ) CNT ";
      String whereRCV = "  where RT.CREATED_BY = b.USER_ID "+
	                    "    and PH.PO_HEADER_ID = PL.PO_HEADER_ID and RT.PO_HEADER_ID = PH.PO_HEADER_ID  "+
                        "    and RT.PO_HEADER_ID = PH.PO_HEADER_ID and RT.PO_LINE_ID = PL.PO_LINE_ID "+
                        "    and RT.SHIPMENT_HEADER_ID = RSH.SHIPMENT_HEADER_ID "+
					    "    and RT.SHIPMENT_LINE_ID = RSL.SHIPMENT_LINE_ID "+
					    "    and RSH.SHIPMENT_HEADER_ID = RSL.SHIPMENT_HEADER_ID "+
						//"    and CNT.COUNT_RCV = (select count(SHIPMENT_LINE_ID) from RCV_TRANSACTIONS "+
						//"                          where SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID ) "+
						//"    and CNT.SHIPMENT_LINE_ID = RT.SHIPMENT_LINE_ID "+ 
	                    "    and RT.INTERFACE_TRANSACTION_ID not in ( select INTERFACE_TRANSACTION_ID from ORADDMAN.TSCIQC_LOTINSPECT_DETAIL where LSTATUSID != '013' ) "+
	                    "    and RT.TRANSACTION_TYPE ='RECEIVE' and PH.ORG_ID = 325  "+
					    "    and RT.WIP_ENTITY_ID IS NULL and PL.LINE_TYPE_ID = 1 "+
					    "    and RT.TRANSACTION_DATE+4 < SYSDATE ";
     String orderByRCV = " order by RT.VENDOR_LOT_NUM, RT.TRANSACTION_DATE, RT.TRANSACTION_TYPE  ";
   %>
    <input type="button" name="TOPDF" value="PDF" onClick='setGeneratePDF("../jsp/TSIQCRCVNonInspect2PDF.jsp")'>
     <BR><font color="#330066" size="+2">倉庫接收三日未檢驗入庫明細表</font><font color="#993333" size="+2">(</font><font color="#993300" size="+2"><%=dateBean.getYearMonthDay()%></font><font color="#993333" size="+2">)</font>
     <TABLE cellSpacing='0' bordercolordark="#6699CC" cellPadding='1' width='100%' bordercolorlight='#FFFFFF'  border='1'> 
      <TR bgcolor="#003399">
	   <TD NOWRAP><FONT color="#FFFFFF">項序</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收類型</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>批號</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>供應商</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>採購單號</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>採購數量</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>幣別</FONT></TD> 
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>暫收單號</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收日期</FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收數量</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>接收單位</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>品名/規格</FONT></TD>
	   <TD NOWRAP><FONT COLOR='#FFFFFF'>執行人員</FONT></TD>
	  </TR> 
 <%
       sqlRCV = sqlRCV + whereRCV + orderByRCV;	
    //out.println("sql="+sql);
	int i = 1;
    Statement stateRCV=con.createStatement(); 
    ResultSet rsRCV=stateRCV.executeQuery(sqlRCV);		
	while (rsRCV.next())
	{
	 
	 boolean rtnFlag = false;
	 String rtnExplan = "";
	 Statement stateRtn=con.createStatement(); 
     ResultSet rsRtn=stateRtn.executeQuery("select sum(QUANTITY) as QUANTITY from RCV_TRANSACTIONS where PO_HEADER_ID = "+rsRCV.getString("PO_HEADER_ID")+" "+
	                                       "   and PO_LINE_ID = "+rsRCV.getString("PO_LINE_ID")+" and SHIPMENT_LINE_ID = "+rsRCV.getString("SHIPMENT_LINE_ID")+" "+
										   "   and TRANSACTION_TYPE = 'RETURN TO VENDOR' "); 
										   
	 if (rsRtn.next() && rsRtn.getFloat("QUANTITY")>0) 
	 {
	   //out.println("QUANTITY="+rsRtn.getString("QUANTITY"));	  
	   rtnFlag = true; 
	   rtnExplan = rtnExplan +"<font color='#FF0000'>(Partial Return Q'ty="+rsRtn.getString("QUANTITY")+")</font>";	     
	 }  else {
	           rtnExplan = "";
	         }
	 rsRtn.close();
	 stateRtn.close();	  
	  
 %>	
	  <TR BGCOLOR='#FFFFFF'> 
	   <TD NOWRAP><FONT COLOR='#000000'><%=i%></FONT></TD>	   
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("TRANSACTION_TYPE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("VENDOR_LOT_NUM")+rtnExplan%></FONT></TD>	
	   <TD NOWRAP><FONT COLOR='#000000'>
	      <%//rsRCV.getString("VENDOR_NAME")
		      Statement stateVnd=con.createStatement(); 
              ResultSet rsVnd=stateVnd.executeQuery("select VENDOR_NAME from PO_VENDORS where VENDOR_ID = "+rsRCV.getString("VENDOR_ID")+" "); 
			  if (rsVnd.next())
			  {
			     out.println(rsVnd.getString("VENDOR_NAME"));
			  }
			  rsVnd.close();
			  stateVnd.close();
		  %></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("SEGMENT1")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("SOURCE_DOC_QUANTITY")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("CURRENCY_CODE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("RECEIPT_NUM")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getDate("TRANSACTION_DATE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("QUANTITY")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("UOM_CODE")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("ITEM_DESCRIPTION")%></FONT></TD>
	   <TD NOWRAP><FONT COLOR='#000000'><%=rsRCV.getString("USER_NAME")%></FONT></TD>	      	  
	  </TR>     
 <%  
       i++;	  
	  
    } // End of while
	rsRCV.close();
	stateRCV.close(); 
	
 %>
 </TABLE><BR>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

