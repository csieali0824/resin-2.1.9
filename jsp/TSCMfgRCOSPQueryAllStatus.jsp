<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--========2007/09/25 Moon Festiva by Kerwin=============-->
<%@ include file="/jsp/include/YEWUserSiteChecker.jsp"%>
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
<title>Query All QC Inspection Lot Data by status</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function searchRepNo(svrTypeNo,statusID,pageURL) 
{   
  location.href="../jsp/TSCMfgDRQQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&MARKETTYPE="+document.MYFORM.MARKETTYPE.value+"&WOTYPE="+document.MYFORM.WOTYPE.value ;
}
function searchIQCDocNo(statusID,pageURL) 
{   
  location.href="../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID="+statusID+"&PAGEURL="+pageURL+"&SEARCHSTRING="+document.MYFORM.SEARCHSTRING.value+"&FROMYEAR="+document.MYFORM.FROMYEAR.value+"&FROMMONTH="+document.MYFORM.FROMMONTH.value+"&FROMDAY="+document.MYFORM.FROMDAY.value+"&TOYEAR="+document.MYFORM.TOYEAR.value+"&TOMONTH="+document.MYFORM.TOMONTH.value+"&TODAY="+document.MYFORM.TODAY.value+"&MARKETTYPE="+document.MYFORM.MARKETTYPE.value+"&WOTYPE="+document.MYFORM.WOTYPE.value ;
}
function submitCheck(ms1,ms2)
{  
  if (document.MYFORM.ACTIONID.value=="--")  //表示沒選任何動作
  {       
   return(false);
  } 
  
  if (document.MYFORM.ACTIONID.value=="004")  //表示為CANCE動作
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  } 
  /*
  if (document.MYFORM.ACTIONID.value=="013")  //表示為選擇ABORT動作,要求使用者確認是否客戶相同,方產生新的交期詢問單
  { 
   flag=confirm(ms1);      
   if (flag==false)  return(false);
  }
 */
  if ( document.MYFORM.ACTIONID.value=="005" & (document.MYFORM.CHANGEREPPERSONID==null || document.MYFORM.CHANGEREPPERSONID.value=="--")  )
   { 
    alert(ms2);   
    return(false);
   }  
   return(true);      
}  
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%   
  String searchString=request.getParameter("SEARCHSTRING");
  if (searchString==null) searchString="";
  String statusID=request.getParameter("STATUSID");  
  String statusDesc="",statusName="";
  String pageURL=request.getParameter("PAGEURL");
  String svrTypeNo=request.getParameter("SVRTYPENO");    
  String fromYearString="",fromMonthString="",fromDayString="",toYearString="",toMonthString="",toDayString=""; 
  String queryDateFrom="",queryDateTo=""; 
  String fromYear=request.getParameter("FROMYEAR");  
  if (fromYear==null || fromYear.equals("--") || fromYear.equals("null")) fromYearString="2000"; else fromYearString=fromYear;
  String fromMonth=request.getParameter("FROMMONTH"); 
  if (fromMonth==null || fromMonth.equals("--") || fromMonth.equals("null")) fromMonthString="01"; else fromMonthString=fromMonth; 
  String fromDay=request.getParameter("FROMDAY");
  if (fromDay==null || fromDay.equals("--") || fromDay.equals("null")) fromDayString="01"; else fromDayString=fromDay;
  queryDateFrom=fromYearString+fromMonthString+fromDayString;//設為搜尋收件起始日期的條件
  String toYear=request.getParameter("TOYEAR");
  if (toYear==null || toYear.equals("--") || toYear.equals("null")) toYearString="3000"; else toYearString=toYear;
  String toMonth=request.getParameter("TOMONTH");
  if (toMonth==null || toMonth.equals("--") || toMonth.equals("null")) toMonthString="12"; else toMonthString=toMonth; 
  String toDay=request.getParameter("TODAY");
  if (toDay==null || toDay.equals("--") || toDay.equals("null")) toDayString="31"; else toDayString=toDay; 
  queryDateTo=toYearString+toMonthString+toDayString;//設為搜尋收件截止日期的條件
  int maxrow=0;//查詢資料總筆數 
  String marketType=request.getParameter("MARKETTYPE");
   if (marketType==null || marketType.equals("--")) marketType="%";
  String woType=request.getParameter("WOTYPE");  
   if (woType==null || woType.equals("--")) woType="%";  
 
  String runCardNo = "";  
  
 // arrayIQCDocumentInputBean.setArray2DString(null);
   
  
   // 判斷若為WO生成,則重置MO單其他資訊_起
   if (statusID.equals("040")) //  若狀態是 009 訂單生成中,才顯示明細供使用者設定相關參數,否則,使用者無法作任何Submit...(防止User自行於網址列輸入LineNO)
   {
    
  
   } // End of if (statusID.equals("009"))
  // 判斷若為訂單生成,則重置MO單其他資訊_迄  
  
  try
  {   
  
   Statement statement=con.createStatement();
   ResultSet  rs=statement.executeQuery("select LOCALDESC,STATUSNAME from ORADDMAN.TSWFSTATDESCRF where STATUSID='"+statusID+"' and LOCALE='"+locale+"'");
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集
   String sql=null;
   rs.next();
   statusDesc=rs.getString("LOCALDESC");
   statusName=rs.getString("STATUSNAME");     
   
   rs.close();  
 
   //取得資料總筆數
   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0 ) //若為admin則可看到全部
   {	 
     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	 {	  	    
		lotRs=lotStat.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
		lotRs.next();
	    if (lotRs.getInt(1)>0) //若有存在批號的話
	    {		   
	       rs=statement.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and B.RUNCARD_NO ='"+searchString+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	    } else {
           rs=statement.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and (a.OE_ORDER_NO like '"+searchString+"%' or a.WO_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"') and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
        } //end of lotRs if
		  
     } else { 	
	         //out.print("step2"+" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B where A.WO_NO=B.WO_NO and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");   
			 // 20110623 Marvie Update : Performance Issue
			 //String sqlQ = " select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";
			 String sqlQ = " select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and c.vendor_id=7602 and c.closed_code='OPEN' ";
	         rs=statement.executeQuery(sqlQ);
	       }	 
   } else { 
            if (UserRoles.indexOf("YEW_STOCKER")>=0) // // 若是前段半成品倉人員,則只看針對前段工令_起
			{
			    if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	            {	  	    
		           lotRs=lotStat.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
		           lotRs.next();
	               if (lotRs.getInt(1)>0) //若有存在批號的話
	               {		   
	                  rs=statement.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and B.RUNCARD_NO ='"+searchString+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	
	               } else {
                           rs=statement.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and (a.OE_ORDER_NO like '"+searchString+"%' or a.WO_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"') and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");	 	 
                          } //end of lotRs if
		  
                } else { 	
	                     //out.print("step2"+" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B where A.WO_NO=B.WO_NO and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'");   
			             // 20110623 Marvie Update : Performance Issue
			             //String sqlQ = " select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' ";
			             String sqlQ = " select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and c.vendor_id=7602 and c.closed_code='OPEN' ";
	                     rs=statement.executeQuery(sqlQ);
	                   }			
			} // 若是前段半成品倉人員,則只看針對前段工令_迄             
          }  // end of else 

 /*		   
    // 取自己及自己所屬檢驗單位所開立的檢驗批單據          
    if (statusID.equals("042")) //若
	{
	  if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {  
	     lotRs=lotStat.executeQuery("select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
  		 lotRs.next();
	     if (lotRs.getInt(1)>0) //若有存在批號的話
	     {
		   sql = "select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and a.DEPT_NO in ("+userMfgDeptNo+") and (a.OE_ORDER_NO like '"+searchString+"%' or A.WO_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"') and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";		
		 } else {
	             sql = "select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and a.DEPT_NO in ("+userMfgDeptNo+") and (a.OE_ORDER_NO like '"+searchString+"%' or A.WO_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"') and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
		        } 	 
	  } else {
		        sql = "select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and a.DEPT_NO in ("+userMfgDeptNo+") and (a.OE_ORDER_NO like '"+searchString+"%' or A.WO_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"') and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
	         }	
	 // out.println("sql1="+sql);
 	  rs=statement.executeQuery(sql);	//out.println("Step10"); 
    } else {
	
	   if (statusID.equals("042")) //若為狀態為待倉管入庫中、待倉管批退供應商中或角色為物管且狀態是物管審核批退批確認中則可看到隸屬於其下之詢問單據
       {	
	       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	      {
		    
			 lotRs=lotStat.executeQuery(" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"' ");	
  		     lotRs.next();
 	         if (lotRs.getInt(1)>0) //若有存在批號的話
	         {
			   sql ="select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and B.DEPT_NO in ("+userMfgDeptNo+") and (b.RUNCRAD_NO like '"+searchString+"%' or B.RUNCARD_NO like '"+searchString+"%' or a.OE_ORDER_NO like '"+searchString+"') and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
			 } else {			 
      	             sql ="select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and a.DEPT_NO in ("+userMfgDeptNo+") and (a.OE_ORDER_NO like '"+searchString+"%' or a.WAFER_IQC_NO like '"+searchString+"%' or a.WAFER_LOT_NO like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";	
			        }  
			
          } else {
	                 sql ="select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and a.DEPT_NO in ("+userMfgDeptNo+") and (a.OE_ORDER_NO like '"+searchString+"%' or a.WAFER_IQC_NO like '"+searchString+"%' or a.WAFER_LOT_NO like '"+searchString+"') and substr(a.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'";
    	         }	
				// out.println("sql2="+sql);
	      rs=statement.executeQuery(sql);	   
	   } else {
	     
			  sql =" select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'" ;	 	
			  //out.println(UserRoles+"<BR>");
			  //out.println("sql="+sql);
	          rs=statement.executeQuery(sql);	
		   }  //enf of 是否為
	   } //end of 
  */	   
	   
   //	} //end of 	
   rs.next();   
   maxrow=rs.getInt(1);
    
   statement.close();
   rs.close();   
   if (lotRs!=null) lotRs.close();
   lotStat.close();
  } //end of try
  catch (SQLException e)
  {
   out.println("ExceptionCOUNT:"+e.getMessage());
  } 
  
  String scrollRow=request.getParameter("SCROLLROW");    
  int rowNumber=qryAllChkBoxEditBean.getRowNumber();
  if (scrollRow==null || scrollRow.equals("FIRST")) 
  {
   rowNumber=1;
   qryAllChkBoxEditBean.setRowNumber(rowNumber);
  } else {
   if (scrollRow.equals("LAST")) 
   {  	 	 
	 qryAllChkBoxEditBean.setRowNumber(maxrow);	 
	 rowNumber=maxrow-300;	 	 	   
   } else {     
	 rowNumber=rowNumber+Integer.parseInt(scrollRow);
     if (rowNumber<=0) rowNumber=1;
     qryAllChkBoxEditBean.setRowNumber(rowNumber);
   }	 
  }          
  
  int currentPageNumber=0,totalPageNumber=0;
  totalPageNumber=maxrow/300+1;
  if (rowNumber==0 || rowNumber<0)
  {
    currentPageNumber=rowNumber/301+1;  
  } else {
    currentPageNumber=rowNumber/300+1; 
  }	
  if (currentPageNumber>totalPageNumber) currentPageNumber=totalPageNumber;  
%>
<body>
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>
<FORM NAME="MYFORM" onsubmit='return submitCheck("確認取消","確認特採項目")' ACTION="../jsp/TSCMfgWoOSPMProcess.jsp?FORMID=WO&FROMSTATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>" METHOD="POST"> 
<strong><font color="#0080C0" size="5">流程卡委外加工單據處理</font></strong> <FONT COLOR=RED SIZE=4>&nbsp;&nbsp;流程卡狀態:<%=statusName%>(<%=statusDesc%>)</FONT><FONT COLOR=BLACK SIZE=2>(總共<%=maxrow%>&nbsp;筆記錄)</FONT>
<table width="100%" border="0">
  <tr>
    <td width="16%"> <input name="button" type=button onClick="this.value=check(this.form.CH)" value='選擇全部'>
      &nbsp;&nbsp;</td>
    <td width="84%"><strong><font color="#400040" size="2">請輸入工令號,流程卡號:</font></strong>
<INPUT type="text" name="SEARCHSTRING" size=16 <%if (searchString!=null) out.println("value="+searchString);%>>
     <%
		         try
                 {   
				   //-----取內外銷別
		           Statement statementa=con.createStatement();
                   ResultSet rsa=null;	
			       String sqlOrgInfa = " select CODE,CODE_DESC from apps.YEW_MFG_DEFDATA where DEF_TYPE='MARKETTYPE' ";
                   rsa=statementa.executeQuery(sqlOrgInfa);
				 
		           comboBoxBean.setRs(rsa);
		           comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());

		           rsa.close();   
				   statementa.close();
				  } //end of try		 
                 catch (Exception e)
				  { out.println("Exception:"+e.getMessage()); } 
				  
			    try
                 {   	   
				   //-----取工單類別  
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select CODE as WOTYPE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
			        String whereOType = " where DEF_TYPE='WO_TYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
				   /*
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(woType);
	               comboBoxBean.setFieldName("WOTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   */
				   out.println("<select NAME='WOTYPE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWoCreate.jsp"+'"'+")'>");
                   out.println("<OPTION VALUE=-->--");     
                   while (rs.next())
                  {            
                    String s1=(String)rs.getString(1); 
                    String s2=(String)rs.getString(2); 
                        
                     if (s1.equals(woType)) 
                    {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                    }   
			        else 
			        {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                    }        
                   } //end of while
                   out.println("</select>"); 	  		  
		           rs.close();   
				   statement.close();   				   
                 } //end of try		 
                 catch (Exception e)
				  { out.println("Exception:"+e.getMessage()); }
			
		%>



      <input name="search" type=button onClick="searchIQCDocNo('<%=statusID%>','<%=pageURL%>')" value='<-查詢'> 
    </td>
  </tr>
</table>
<A HREF="../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=FIRST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">第一頁</font></strong></font></A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=LAST&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>"><font size="2"><strong><font color="#FF0080">最終頁</font></strong></font></A><font color="#FF0080"><strong><font size="2">&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">下一頁</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/TSCMfgRCOSPQueryAllStatus.jsp?STATUSID=<%=statusID%>&PAGEURL=<%=pageURL%>&SEARCHSTRING=<%=searchString%>&SCROLLROW=-300&FROMYEAR=<%=fromYear%>&FROMMONTH=<%=fromMonth%>&FROMDAY=<%=fromDay%>&TOYEAR=<%=toYear%>&TOMONTH=<%=toMonth%>&TODAY=<%=toDay%>">前一頁</A>&nbsp;&nbsp;(第<%=currentPageNumber%>&nbsp;頁/共<%=totalPageNumber%>&nbsp;頁)</font></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;開單日期
:FROM
<%
     //try
     // {	   
     //  String a[]={"2006","2007","2008","2009","2010","2010","2011","2012"};
     //  arrayComboBoxBean.setArrayString(a);	   
	 //  if (fromYear!=null) arrayComboBoxBean.setSelection(fromYearString); 
	 //  arrayComboBoxBean.setFieldName("FROMYEAR");	   
     //  out.println(arrayComboBoxBean.getArrayString());              
     //  } //end of try
     //  catch (Exception e)
     //  {
     //   out.println("Exception:"+e.getMessage());
     //  }
		//modify by Peggy 20150105
		try
		{     
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i = Integer.parseInt(dateBean.getYearString()) ; i >=2006 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((fromYear==null?"--":fromYear));
			arrayComboBoxBean.setFieldName("FROMYEAR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}	 
       %>
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);
	   if (fromMonth!=null) arrayComboBoxBean.setSelection(fromMonth);     	   
	   arrayComboBoxBean.setFieldName("FROMMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   	   
	   if (fromDay!=null) arrayComboBoxBean.setSelection(fromDay);
	   arrayComboBoxBean.setFieldName("FROMDAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
~
TO
<%
     //try
     // {	   
     //  String a[]={"2006","2007","2008","2009","2010","2011","2012"};
     // arrayComboBoxBean.setArrayString(a);	   
	 //  if (toYear!=null) arrayComboBoxBean.setSelection(toYear); 
	 //  arrayComboBoxBean.setFieldName("TOYEAR");	   
     //  out.println(arrayComboBoxBean.getArrayString());              
     //  } //end of try
     //  catch (Exception e)
     //  {
     //   out.println("Exception:"+e.getMessage());
     //  }
		//modify by Peggy 20150105
		try
		{       
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i =Integer.parseInt(dateBean.getYearString()) ; i >= 2006 ; i--)
			{
				a[j++] = ""+i; 
			}
			arrayComboBoxBean.setArrayString(a);
			arrayComboBoxBean.setSelection((toYear==null?"--":toYear));
			arrayComboBoxBean.setFieldName("TOYEAR");	
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}		 
       %>
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
       arrayComboBoxBean.setArrayString(a);
	   if (toMonth!=null) arrayComboBoxBean.setSelection(toMonth);     	   
	   arrayComboBoxBean.setFieldName("TOMONTH");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
/
<%
	  try
      {       
       String a[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
       arrayComboBoxBean.setArrayString(a);  	   	   
	   if (toDay!=null) arrayComboBoxBean.setSelection(toDay); 
	   arrayComboBoxBean.setFieldName("TODAY");	   
       out.println(arrayComboBoxBean.getArrayString());              
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
<%   
 try
  {   
   //out.println("Step1"); 
  
   Statement lotStat=con.createStatement();
   ResultSet lotRs=null; //做為搜尋是否有批號存在之資料集   
   Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
   ResultSet rs=null;
   String sql=null;  
   if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("YEW_WIP_ADMIN")>=0 ) //若角色為admin則可看到全部詢問單
   {  
       if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	   { 	
	      lotRs=lotStat.executeQuery("select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
 		  lotRs.next();
	      if (lotRs.getInt(1)>0) //若有存在批號的話
	      { 		
		    rs=statement.executeQuery(" select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,d.UNIT_MEAS_LOOKUP_CODE as 單位, SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) AND B.STATUSID='"+statusID+"' and ( B.WO_NO ='"+searchString+"' or B.RUNCARD_NO like '"+searchString+"' ) and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by B.RUNCARD_NO,substr(B.CREATION_DATE,0,8) ASC"); 
		  } else {	//out.print("stept1-1");		  
            rs=statement.executeQuery(" select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC");	 	 
          }			
       } else {  	             //out.print("select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(b.DEPT_NO,'1','製一','2','製二','3','製三',b.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' and c.vendor_id = 7602 order by b.runcard_no");
		         // 20110623 Marvie Add : Performance Issue
				 //rs=statement.executeQuery("select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.runcard_no ,b.creation_date");
		         rs=statement.executeQuery("select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(b.DEPT_NO,'1','製一','2','製二','3','製三',b.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' and c.vendor_id=7602 and c.closed_code='OPEN' order by b.runcard_no");
	          }	
		   
   } else {  //out.println("UserRoles="+UserRoles);
		     if (UserRoles.indexOf("YEW_STOCKER")>=0) //若為待入庫,則予前段倉管人員可看到_起
		     {
		          if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	              { 	
	                lotRs=lotStat.executeQuery("select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
 		            lotRs.next();
	                if (lotRs.getInt(1)>0) //若有存在批號的話
	                { 		
		              rs=statement.executeQuery(" select b.WO_NO, b.RUNCARD_NO ,b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,d.UNIT_MEAS_LOOKUP_CODE as 單位, SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) AND B.STATUSID='"+statusID+"' and ( B.WO_NO ='"+searchString+"' or B.RUNCARD_NO like '"+searchString+"' ) and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.MARKET_TYPE like '"+marketType+"' and a.workorder_type like '"+woType+"' order by B.RUNCARD_NO,substr(B.CREATION_DATE,0,8) ASC"); 
		            } else {	//out.print("stept1-1");		  
                            rs=statement.executeQuery(" select b.WO_NO, b.RUNCARD_NO ,b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.MARKET_TYPE like '"+marketType+"' and a.WORKORDER_TYPE like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC");	 	 
                           }			
                  } else {                //out.print("select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(b.DEPT_NO,'1','製一','2','製二','3','製三',b.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' and c.vendor_id = 7602 order by b.runcard_no");
		                  // 20110623 Marvie Add : Performance Issue
		                  //rs=statement.executeQuery("select b.WO_NO, b.RUNCARD_NO ,b.OPERATION_SEQ_NUM as OP_SEQ, decode(A.DEPT_NO,'1','製一','2','製二','3','製三',A.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.MARKET_TYPE like '"+marketType+"' and a.WORKORDER_TYPE like '"+woType+"' order by b.RUNCARD_NO ,b.CREATION_DATE");
		                  rs=statement.executeQuery("select b.WO_NO, b.RUNCARD_NO, b.OPERATION_SEQ_NUM as OP_SEQ, decode(b.DEPT_NO,'1','製一','2','製二','3','製三',b.DEPT_NO) as 製造部別, c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER and B.STATUSID='"+statusID+"' and substr(B.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' and c.vendor_id=7602 and c.closed_code='OPEN' order by b.runcard_no");
	                     } 
		     }  // //若為待入庫,則予前段倉管人員可看到_迄
		  } // 不是管理員身份_迄
   
 /*  
   else {                     
         // out.println("Step2");   
  
    // 若狀態為檢驗單位(01 ~ 03 )則只取自己所屬檢驗單位所開立的檢驗批單據 
	// 若是業務,則看到的是企劃安排的交期(PCACPDATE)
    if (statusID.equals("042") ) //若為維修中或判定中狀態則select條件為維修工程師個人
	{   //out.println("Step2-1"); 
	  if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	  {  //out.println("Step2-2"); 
	     lotRs=lotStat.executeQuery("select count(B.RUNCARD_NO) from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.RUNCARD_NO='"+searchString+"'");	
 		 lotRs.next();
	     if (lotRs.getInt(1)>0) //若有存在批號的話
	     {   //out.println("Step2-3"); 
		    sql = " select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC ";	
	     } 
		 //2005-05-16 add
		

      } else {  //out.println("Step2-6"); 
		      if (statusID.equals("040")) //2005-05-16 add			
		      { sql = " select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC ";
			  }

	        }		
//out.println("Step3");
//out.println("sql"+sql);
	  rs=statement.executeQuery(sql);	  
    } else { //out.println("Step15");  // 流程卡資料查詢
	  if (statusID.equals("042")) //若為工廠則可看到隸屬於其下之所有被指派之詢問單
	  {
	     if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	     {
		    lotRs=lotStat.executeQuery("select count(*) from APPS.YEW_RUNCARD_ALL A where a.RUNCARD_NO ='"+searchString+"'");	
 		    lotRs.next();
	        if (lotRs.getInt(1)>0) //若有存在批號的話
	        {
			  sql =" select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%') and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.wo_no,b.runcard_no, substr( b.CREATION_DATE,0,8) ASC";			 
	        } else {
			  sql =" select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC";	 
            }			  
         } 		
		// out.println("Sales SQL="+sql);  
	     rs=statement.executeQuery(sql);
	  } else 
	    {  //out.println("Step16");
//out.println("Step4");		
		 if (searchString!=null && !searchString.equals("")) //如果有搜尋特定單號則另下SQL
	     {
		    lotRs=lotStat.executeQuery("select count(*) from APPS.YEW_WORKORDER_ALL A where a.RUNCARD_NO='"+searchString+"'");	
 		    lotRs.next();
	        if (lotRs.getInt(1)>0) //若有存在批號的話
	        { 
			  sql =" select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID='"+statusID+"' and b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%') and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.wo_no,b.runcard_no, substr( b.CREATION_DATE,0,8) ASC" ;			 
	        } else {
			  sql =" select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' or a.oe_order_no like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"'  and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"' order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC";	 
            }			  
         } else { 
	             sql =" select b.wo_no, b.runcard_no,c.SEGMENT1 as PO_NO, b.inv_item 料號, b.item_desc 料號說明, b.RUNCARD_QTY as 流程卡數, b.QTY_IN_TOMOVE as 委外加工數,d.QUANTITY as PO數量, d.UNIT_MEAS_LOOKUP_CODE as 單位,SUBSTR (b.creation_date, 0, 8) AS 流程卡展開日 from APPS.YEW_WORKORDER_ALL A,APPS.YEW_RUNCARD_ALL B, PO_HEADERS_ALL c, PO_LINE_LOCATIONS_ALL d where A.WO_NO=B.WO_NO and c.PO_HEADER_ID = d.PO_HEADER_ID and b.RUNCARD_NO=d.NOTE_TO_RECEIVER(+) and B.STATUSID= '"+statusID+"' and  (b.WO_NO like '"+searchString+"%' or b.RUNCARD_NO like '"+searchString+"%' or a.oe_order_no like '"+searchString+"%' ) and substr(b.CREATION_DATE,0,8) between '"+queryDateFrom+"' and '"+queryDateTo+"' and a.market_type like '"+marketType+"' and a.workorder_type like '"+woType+"'  order by b.WO_NO,b.RUNCARD_NO, substr( B.CREATION_DATE,0,8) ASC";
	            }	
	  
	  } //end of 三級維修狀態判定
	} //end of 維修中狀態判定	
   }
  
  */ 

   if (rowNumber==1 || rowNumber<0)
   { 
     rs.beforeFirst(); //移至第一筆資料列  
   } else { 
      if (rowNumber<=maxrow) //若小於總筆數時才繼續換頁
	  {
        rs.absolute(rowNumber); //移至指定資料列	 
	  }	
   }
   
   String sKeyArray[]=new String[4];   
   sKeyArray[0]="WO_NO";
   sKeyArray[1]="RUNCARD_NO";
   sKeyArray[2]="PO_NO";
   sKeyArray[3]="OP_SEQ";
   //sKeyArray[2]="ASSIGN_MANUFACT";
   //sKeyArray[3]="ORDER_TYPE_ID";
   //sKeyArray[4]="LINE_TYPE";   
   
   	
   qryAllChkBoxEditBean.setPageURL("../jsp/"+pageURL);
   qryAllChkBoxEditBean.setPageURL2("");     
   qryAllChkBoxEditBean.setHeaderArray(null);   
   //qryAllChkBoxEditBean.setSearchKey("DNDOCNO");
   qryAllChkBoxEditBean.setSearchKeyArray(sKeyArray); // 以setSearchKeyArray取代之, 因本頁需傳遞兩個網頁參數
   qryAllChkBoxEditBean.setFieldName("CH");
   qryAllChkBoxEditBean.setHeadColor("#D8DEA9");
   qryAllChkBoxEditBean.setHeadFontColor("#0066CC");
   qryAllChkBoxEditBean.setRowColor1("#E3E4B6");
   qryAllChkBoxEditBean.setRowColor2("#ECEDCD");
   //qryAllChkBoxEditBean.setRowColor1("B0E0E6"); 
   qryAllChkBoxEditBean.setTableWrapAttr("nowrap");
   qryAllChkBoxEditBean.setRs(rs);   
   qryAllChkBoxEditBean.setScrollRowNumber(300);      
   out.println(qryAllChkBoxEditBean.getRsString());
 //  out.print("woNo="+WO_NO);
   statement.close();
   rs.close();   
   if (lotRs!=null) lotRs.close();
   lotStat.close();
   //取得維修處理狀態      
  } //end of try
  
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
	  try
      {       
       //2005-05-13 add 038	
	   
	      
	   if (statusID.equals("003") || (statusID.equals("004")) || statusID.equals("008"))
	   { 
	     String sqlAct = null;
		 String whereAct = null;
		 		 
		 if (statusID.equals("003") || statusID.equals("004"))
		 { 
		   sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
		   whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";		   
		 } 
		 else if (statusID.equals("008")) {
		                                   sqlAct = "select DISTINCT x1.ACTIONID,x2.ACTIONNAME from ORADDMAN.TSWORKFLOW x1,ORADDMAN.TSWFACTION x2 ";
										   whereAct = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and x1.ACTIONID !='013' and x1.LOCALE='"+locale+"'";         										   
		                                  }
		 // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		 if (UserRoles.equals("admin")) whereAct = whereAct+"";  //若是管理員,則任何動作不受限制
		 else {
		         if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereAct = whereAct+"and FORMID='WO' "; // 若是上海內銷辦事處
				 else whereAct = whereAct+"and FORMID='WO' "; // 否則一律皆為外銷流程
		      }
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_迄		  
	     sqlAct = sqlAct + whereAct;
         Statement statement=con.createStatement();
         ResultSet rs=statement.executeQuery(sqlAct);
         comboBoxBean.setRs(rs);
	     comboBoxBean.setFieldName("ACTIONID");	 
		 out.println("</font></strong></td><TR><TR><td>");%>備註<%out.println(":<INPUT TYPE='TEXT' NAME='REMARK' SIZE=60></td></tr></table>");
         // 2005-05-13 add 038 
		// if ((statusID.equals("003") && userActCenterNo.equals("001")) || UserRoles.equals("admin"))
		 if (UserRoles.equals("PCController"))
		 { 
		 
		   out.println("<strong><font color='#CC3366'>");%>工廠-><%out.println("</font></strong>");
		   Statement stateShip=con.createStatement();
           ResultSet rsShip=stateShip.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'('||MANUFACTORY_NAME||')' from ORADDMAN.TSPROD_MANUFACTORY where LOCALE >'0' order by MANUFACTORY_NO");	   
	       shipTypecomboBoxBean.setRs(rsShip);	   
	       shipTypecomboBoxBean.setSelection("--");
	       shipTypecomboBoxBean.setFieldName("MANUFACTORY_NO");	   
           out.println(shipTypecomboBoxBean.getRsString());	
		   stateShip.close();
		   rsShip.close();
		   out.println("<BR>");
		   
		} // 執行動作
	     out.println("<strong><font color='#FF0000'>");%>執行動作-><%out.println("</font></strong>");
         out.println(comboBoxBean.getRsString());    
		 
		 String sqlCnt = "select COUNT (*) from ORADDMAN.TSWORKFLOW x1, ORADDMAN.TSWFACTION x2 ";
		 String whereCnt = "WHERE FROMSTATUSID='"+statusID+"' AND x1.ACTIONID=x2.ACTIONID and  x1.LOCALE='"+locale+"'";       
		 // 2006/04/13加入特殊內銷流程,針對上海內銷_起								  
		 if (UserRoles.equals("admin")) whereCnt = whereCnt+"";  //若是管理員,則任何動作不受限制
		 else {
		         if (userActCenterNo.equals("010") || userActCenterNo.equals("011")) whereCnt = whereCnt+"and FORMID='WO' "; // 若是上海內銷辦事處
				 else whereCnt = whereCnt+"and FORMID='WO' "; // 否則一律皆為外銷流程
		      }
	     // 2006/04/13加入特殊內銷流程,針對上海內銷_迄	
		 sqlCnt = sqlCnt + whereCnt;
	     rs=statement.executeQuery(sqlCnt);
	     rs.next();
	     if (rs.getInt(1)>0) //判斷若沒有動作可選擇就不出現submit按鈕
	     {	      
           out.println("<INPUT TYPE='submit' NAME='submit' value='Submit'>");
		   if (statusID.equals("003") || statusID.equals("004") || statusID.equals("017") )
		   {
		     out.println("<INPUT TYPE='checkBox' NAME='SENDMAILOPTION' VALUE='YES' checked>");%>寄發郵件通知<%
           }			 
	     } 
		 
		 statement.close();		 
         rs.close();       
		} //end of if "003":"008":"010":"006":"015":"016":"017" 
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
	   
<input name="RUNCARDNO" type="hidden" value="<%=runCardNo%>" >
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>


