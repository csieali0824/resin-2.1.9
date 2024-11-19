<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>管理員WIP系統移站異常處理</title>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
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
</head>
<script language="JavaScript" type="text/JavaScript">

var checkflag = "false";
function check(field,ms1,ms2) {
	if (checkflag == "false") {
		for (i = 0; i < field.length; i++) {
			field[i].checked = true;
		}
		checkflag = "true";
		return ms1; 
	} else {
		for (i = 0; i < field.length; i++) {
			field[i].checked = false; 
		}
		checkflag = "false";
		return ms2; 
	} // end if-else
}// end function

function NeedConfirm(ms1) { 
	flag=confirm(ms1); 
	return flag;
}
function setFindWO(URL,wipEntityName,runCardNo) 
{   
	document.MOVEFORM.action=URL+"?WO_NO="+wipEntityName+"&RUNCARD_NO="+runCardNo;
	document.MOVEFORM.submit();
}
function setSubmit(URL,wipEntityName,runCardNo) 
{   
	document.MOVEFORM.action=URL+"?WO_NO="+wipEntityName+"&RUNCARD_NO="+runCardNo;
	document.MOVEFORM.submit();
}
</script>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<form name="MOVEFORM" method="post" action="TSCMfgMovePendingResubmit.jsp">
<%
    String woNo=request.getParameter("WO_NO");   //工單號
    String runCardNo=request.getParameter("RUNCARD_NO");   //工單號
    String fndUserName=request.getParameter("FNDUSERNAME"); 
    String fmOperSeqNo=request.getParameter("FMOPERSEQNO"); 
    String transID=request.getParameter("TRANSID"); 
	
	if (woNo==null) woNo="";
	if (runCardNo==null) runCardNo="";
	if (fndUserName==null) fndUserName = "";
	if (fmOperSeqNo==null) fmOperSeqNo="";
	if (transID==null) transID = "";
    
%>
<table cellSpacing="1" bordercolordark="#B5B89A" cellPadding="1" width="37%" bordercolorlight="#FFFFFF"  border="0">
  <tr bgcolor="#CCCC99">
    <td>Pending Move Transaction</td>
  </tr>
  <tr bgcolor="#CCCC99">
   <td>WO No :<input name="WO_NO" type="text" value='' size="10"> or RunCard No.:<input name="RUNCARD_NO" type="text" value='' size="10">
   </td>
  </tr>
  
   <tr bgcolor="#CCCC99">
     <td>
        <input name="OK" type="button" value='依工令或流程卡查詢移站資訊' onclick='setFindWO("../jsp/TSCMfgMoveTransactionPage.jsp",this.form.WO_NO.value,this.form.RUNCARD_NO.value)'>
	 </td>
   </tr>
</table>
<BR>
<strong><font color="#0080C0" size="5">管理員流程卡異常移站處理</font></strong> 
<%
   	
	//out.println("--"+searchString);
	String scrollRow=request.getParameter("SCROLLROW");  
	String where = "";
	if (woNo==null) { where = where + ""; }
	if (woNo!=null && !woNo.equals(""))
    {		
		where = where + " and WIP_ENTITY_NAME = '"+woNo+"' ";		
	}
	if (runCardNo!=null && !runCardNo.equals("")) {  where = where + " and ATTRIBUTE2 = '"+runCardNo+"' ";  }
	if (fndUserName!=null && !fndUserName.equals("")) { where = where + " and CREATED_BY_NAME = '"+fndUserName+"' ";  }
	if (fmOperSeqNo!=null && !fmOperSeqNo.equals("")) { where = where + " and FM_OPERATION_SEQ_NUM = '"+fmOperSeqNo+"' ";  }
	if (transID!=null && !transID.equals("")) { where = where + " and TRANSACTION_ID = '"+fmOperSeqNo+"' ";  }
	//out.println(where);
	
%>
<%   
	int pageRow = 30;
	int maxrow=0;//查詢資料總筆數 
	int currentPageNumber=0,totalPageNumber=0,rowNumber=0;
	try {   
		String sql = "select count(*) from WIP_MOVE_TXN_INTERFACE where ORGANIZATION_ID in (326,327) and ATTRIBUTE2 is not null "+where;
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);
		rs.next();   
		maxrow=rs.getInt(1);
		rs.close();
		statement.close();
		out.println("<FONT SIZE='2'>(");
		%>(總共<%
		out.println(maxrow);
		%>筆記錄)<%
		out.println(")</FONT>");

		totalPageNumber=maxrow/pageRow+1;
		
		rowNumber=qryAllChkBoxEditBean.getRowNumber();
		//out.println("row="+rowNumber);
		if (scrollRow==null || scrollRow.equals("FIRST")) {
		   rowNumber=1;
		   currentPageNumber=1;
		   //out.println("next row1="+rowNumber);
		   qryAllChkBoxEditBean.setRowNumber(rowNumber);
		} else {
			if (scrollRow.equals("LAST")) {
				 if (maxrow>pageRow) {rowNumber=maxrow-pageRow;} else {rowNumber=1;}
				 currentPageNumber=totalPageNumber;
				 //out.println("next row2="+rowNumber);
				 qryAllChkBoxEditBean.setRowNumber(rowNumber);	 
			} else {
				rowNumber=rowNumber+Integer.parseInt(scrollRow);
				//out.println("next row3="+rowNumber);				
				if (rowNumber<=0) { rowNumber=1; currentPageNumber=1;
				} else {
					if (rowNumber>=maxrow) {
						if (maxrow>pageRow) {rowNumber=maxrow-pageRow;} else {rowNumber=1;}
						currentPageNumber=totalPageNumber;
					} else {
						currentPageNumber=rowNumber/pageRow+1;				
					}// end if-else
				} // end if-else
				qryAllChkBoxEditBean.setRowNumber(rowNumber);
			} // end if-else
		}  // end if-else
		if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
	} //end of try
	catch (Exception e){
		out.println("Exception:"+e.getMessage());
	}   
%>
<input name="search" type="button" onClick='setSubmit("../jsp/TSCMfgMovePending.jsp",this.form.WO_NO.value,this.form.RUNCARD_NO.value)' value='查詢' >
<br> <!--換行 -->
<A HREF="../jsp/TSCMfgMovePending.jsp?SCROLLROW=FIRST&WO_NO=<%if (woNo!=null) out.println(woNo);%>&RUNCARD_NO=<%=runCardNo%>&FNDUSERNAME=<%=fndUserName%>&FMOPERSEQNO=<%=fmOperSeqNo%>&TRANSID=<%=transID%>">
<strong><font color="#FF0080">第一頁</font></strong>
</A>

<A HREF="../jsp/TSCMfgMovePending.jsp?SCROLLROW=30&WO_NO=<%if (woNo!=null) out.println(woNo);%>&RUNCARD_NO=<%=runCardNo%>&FNDUSERNAME=<%=fndUserName%>&FMOPERSEQNO=<%=fmOperSeqNo%>&TRANSID=<%=transID%>">
<strong><font>下一頁</font></strong>
</A>

<A HREF="../jsp/TSCMfgMovePending.jsp?SCROLLROW=-30&WO_NO=<%if (woNo!=null) out.println(woNo);%>&RUNCARD_NO=<%=runCardNo%>&FNDUSERNAME=<%=fndUserName%>&FMOPERSEQNO=<%=fmOperSeqNo%>&TRANSID=<%=transID%>">
<strong><font>前一頁</font></strong>
</A>
 
<A HREF="../jsp/TSCMfgMovePending.jsp?SCROLLROW=LAST&WO_NO=<%if (woNo!=null) out.println(woNo);%>&RUNCARD_NO=<%=runCardNo%>&FNDUSERNAME=<%=fndUserName%>&FMOPERSEQNO=<%=fmOperSeqNo%>&TRANSID=<%=transID%>">
<strong><font color="#FF0080">最後頁</font></strong>
</A>

<font>(第<%=currentPageNumber%>頁/總共<%=totalPageNumber%>頁)</font>
<% 
	try {  
	    
		String sql = " select TRANSACTION_ID as TRANSID, ATTRIBUTE2 as RUNCARD_NO, WIP_ENTITY_ID, WIP_ENTITY_NAME as 工令號, decode(ORGANIZATION_ID,326,'內銷',327,'外銷') as 市場型態, CREATED_BY_NAME as 原移站人員, FM_OPERATION_SEQ_NUM as 站別_起, TO_OPERATION_SEQ_NUM as 站別_迄, decode(TO_INTRAOPERATION_STEP_TYPE,1,'QUEUE',5,'SCRAP',3,'COMPLETE',TO_INTRAOPERATION_STEP_TYPE) as 移站別, "+
		             "        TRANSACTION_QUANTITY as 移站數, TRANSACTION_UOM as 單位, decode(PROCESS_STATUS,1,'PENDING',3,'ERROR',2,'RUNNING',PROCESS_STATUS) as 處理狀態 "+
		             " from WIP_MOVE_TXN_INTERFACE "+
					 " where ORGANIZATION_ID in (326,327) and ATTRIBUTE2 is not null "+where+" order by TRANSID ";
		//out.println(sql);
		Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
		ResultSet rs=statement.executeQuery(sql);
		if (rowNumber==1)  {
		//out.println("A");
			rs.beforeFirst(); //移至第一筆資料列  
		} else {
			if (rowNumber<=maxrow) { //若小於總筆數時才繼續換頁
				rs.absolute(rowNumber); //移至指定資料列
				//out.println("B");
			} //end if
		} //end if-else
		
		 String sKeyArray[]=new String[3];   
         sKeyArray[0]="TRANSID";
         sKeyArray[1]="RUNCARD_NO";
         sKeyArray[2]="WIP_ENTITY_ID";  
		
		
		 qryAllChkBoxEditBean.setPageURL("../jsp/"+"TSCMfgMoveTransactionPage.jsp");
         qryAllChkBoxEditBean.setPageURL2("");     
         qryAllChkBoxEditBean.setHeaderArray(null);    
         qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
         qryAllChkBoxEditBean.setFieldName("CH");
         qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
         qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
         qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
         qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
         //qryAllChkBoxEditBean.setRowColor1("B0E0E6"); 
         qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
         qryAllChkBoxEditBean.setRs(rs);   
         qryAllChkBoxEditBean.setScrollRowNumber(100);      
         out.println(qryAllChkBoxEditBean.getRsString());
		
		
		rs.close();     
		statement.close();    
	} //end of try
	catch (Exception e) {
		out.println("Exception:"+e.getMessage());
	}
%>
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
