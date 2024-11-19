<!--modify by Peggy 20150105,年度下拉選單程式改寫-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.math.BigDecimal,java.text.DecimalFormat" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(xCLASSID,xMARKETTYPE)
{
    if(document.MYFORM.CLASSID.value==null ||  document.MYFORM.CLASSID.value=="--")
    {
	 alert("請選擇檢驗類型!!")
	 document.MYFORM.CLASSID.focus();
	 return(false);
	}
 
   document.MYFORM.action=URL;
   document.MYFORM.submit();
}

function setSubmit2(URL)  //清除畫面條件,重新查詢!
{   
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setItemFindCheck(invItem,itemDesc,organizationId)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes"); 
 //  subWin=window.open("../jsp/subwindow/TSMfgItemPackageFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&SAMPLEORDCH="+sampleOrdCh,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 	
   }
}

function subWindowItemFind(invItem,itemDesc,organizationId)
{    
  subWin=window.open("../jsp/subwindow/TSMfgItemFind.jsp?INVITEM="+invItem+"&ITEMDESC="+itemDesc+"&ORGANIZATIONID="+organizationId,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}


function setWaferLotFindCheck(invItemNo,invItemDesc,waferLot)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&WAFERLOT="+waferLot,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=no"); 
   }
}

function subWinWaferLotFindCheck(invItemNo,invItemDesc,waferLot)
{
    subWin=window.open("../jsp/subwindow/TSMfgWaferLotFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&WAFERLOT="+waferLot,"subwin","width=640,height=480,scrollbars=yes,menubar=no"); 

}

function setMoFindCheck(invItemNo,invItemDesc,oeOrderNo,itemId)
{
   if (event.keyCode==13)
   { 
    subWin=window.open("../jsp/subwindow/TSMfgMoFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&OEORDERNO="+oeOrderNo,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes"); 
   }
}

function subWinMoFindCheck(invItemNo,invItemDesc,oeOrderNo)
{
    subWin=window.open("../jsp/subwindow/TSMfgMoFind.jsp?INVITEM="+invItemNo+"&ITEMDESC="+invItemDesc+"&OEORDERNO="+oeOrderNo,"subwin","width=640,height=480,scrollbars=yes,menubar=yes,status=yes"); 
}

</script>
<html>
<head>
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
.style1 {
	color: #CC0033;
	font-size: 14px;
	font-weight: bold;
}
</STYLE>
<title>生產系統-流程卡與單站統計表</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<%
int rs1__numRows = 500;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "";
String sSqlCNT = "";
String sWhere = "";
String sWhereSDRQ = "";
String sWhereGP = "";
String havingGrpSDRQ = "";
String sOrder = "";

String havingGrp = "";
String lightStatus ="";

//String fjamDesc = ""; 

//String link2ExcelURL = "";

int counta=0;
int CASECOUNT=0;
float CASECOUNTPCT=0;
String sCSCountPCT="";
int idxCSCount=0;

float CASECOUNTORG=0;

//String RepLocale=(String)session.getAttribute("LOCALE"); 		
String SWHERECOND = "";
int CaseCount = 0;
int CaseCountORG =0;
float CaseCountPCT = 0;

String colorStr = "";

String dateStringBegin=request.getParameter("DATEBEGIN");
String dateStringEnd=request.getParameter("DATEEND");

String dateSetBegin=request.getParameter("DATESETBEGIN");
String dateSetEnd=request.getParameter("DATESETEND");

String YearFr=request.getParameter("YEARFR");
String MonthFr=request.getParameter("MONTHFR");
String DayFr=request.getParameter("DAYFR");

      if (YearFr==null ) YearFr = dateBean.getYearString();
	  if (MonthFr==null ) MonthFr = dateBean.getMonthString();
      if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr;

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo; 

String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String dnDocNo=request.getParameter("DNDOCNO");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
String custActive=request.getParameter("CUSTACTIVE");
  
  String salesAreaNo=request.getParameter("SALESAREANO");
  String salesOrderNo=request.getParameter("SALESORDERNO");
  String preOrderType=request.getParameter("PREORDERTYPE");
  String custPONo=request.getParameter("CUSTPONO");
  String createdBy=request.getParameter("CREATEDBY");
  String salesPerson=request.getParameter("SALESPERSON");
  String prodManufactory=request.getParameter("PRODMANUFACTORY");
  //String UserPlanCenterNo=request.getParameter("USERPLANCENTERNO");  
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE"); 
  
  String listMode=request.getParameter("LISTMODE");  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  
//liling create
	String woNo=request.getParameter("WONO"); 
    String marketType=request.getParameter("MARKETTYPE");
	String classID=request.getParameter("CLASSID");
	String woKind=request.getParameter("WOKIND");         //工單類別 1:標準,2:非標準
	String startDate=request.getParameter("STARTDATE");
	String endDate=request.getParameter("ENDDATE");
	String woQty=request.getParameter("WOQTY");
	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");	
	String itemDesc=request.getParameter("ITEMDESC");	
	
	String woType=request.getParameter("WOTYPE");	
	
	if (woType==null || woType.equals("")) woType="ALL";   // 全部條件 = ALL 
	
	String opCode=request.getParameter("OPCODE");
    if (opCode==null || opCode.equals("")) opCode="ALL"; // 沒特別指定 = ALL
	
	if (marketType==null) marketType = "326";
  
    String orgCode = "內銷";
    if (marketType.equals("326")) orgCode = "內銷";
    else if (marketType.equals("327")) orgCode = "外銷";
	
	String organizationId=request.getParameter("ORGANIZATION_ID");
    String singleLotQty=null,createDate=null,userName=null,completeQty="0",scrapQty="0",woStatus="",olStatus="";
	
	String acctPeriodID = "0"; // 預設的Account Period ID
   
  if (statusCode==null || statusCode.equals("")) statusCode="";  

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (listMode==null) listMode = "TRUE";
  int iDetailRowCount = 0;
  
  
  if (classID==null || classID.equals("")) classID="--"; 
 
  
    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  
%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">    
<FORM ACTION="../jsp/TSCMfgWoQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>生產月報統計表-流程卡與單站統計</a></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp">回首頁</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
  //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  
  // 未指定生產月份預設取所在月份的AccountPeriodID_起
     /* 
	     String sqlAP = " select ACCT_PERIOD_ID from ORG_ACCT_PERIODS where ORGANIZATION_ID = "+marketType+" and to_char(PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"'  ";
		 //out.print("sqlm1"+sqlm1);		 
		 Statement stateAP=con.createStatement();
	     ResultSet rsAP=stateAP.executeQuery(sqlAP);
		 if (rsAP.next())
		 { 	acctPeriodID   = rsAP.getString("MARKETCODE");   }
		 rsAP.close();
	     stateAP.close();
	  */
  // 未指定生產月份預設取所在月份的AccountPeriodID_迄
 
  sWhereGP = "  ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ( dateSetBegin==null || dateSetBegin.equals("") )
{
  try
  {   // out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());

     sSql = " select YWA.INV_ITEM, YWA.WO_NO , sum(YWO.QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
	        "        sum(YWO.QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(YWO.QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"        sum(YWO.QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(YWO.QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"        sum(YWO.QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE, sum(YWO.WORK_TIME) as WORK_TIME "+
	        "   from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA ";	

   sSqlCNT = " select count(YWA.INV_ITEM) CaseCount from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA  ";
			
   sWhere =  "  where YWO.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWO.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID and YWO.ORGANIZATION_ID = "+marketType+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' "+
             "    and YWO.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID and YWO.OPERATION_CODE != '9998'  "+
			 "    and YWO.DEPT_NO in ('1','2','3') "; //  確保由生產系統(不含一月份舊系統麗玲手開工令)
			 
   sWhereSDRQ = " ";
   havingGrp = "group by YWA.INV_ITEM, YWA.WO_NO ";               
   havingGrpSDRQ = "  ";
   sOrder = "   order by YWA.INV_ITEM, YWA.WO_NO  ";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + havingGrp + sOrder;
   sSqlCNT = sSqlCNT +  sWhere;   
   //out.println("sSql="+ sSql);   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception dateSetBegin :"+e.getMessage());
  }
   
     try
     {			
         Statement statement1=con.createStatement();
         ResultSet rs1=statement1.executeQuery(sSqlCNT);
		 if (rs1.next())
		 {
		   CaseCount = rs1.getInt("CaseCount");
		   CaseCountORG = rs1.getInt("CaseCountOrg");
		   
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = Math.round((float)(CaseCount/CaseCountORG)*100);
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   		   
		   rs1.close();
		   statement1.close();
		 }
		 
		} //end of try
        catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        }
}
else
{ 
   
   
     sSql = " select YWA.INV_ITEM, YWA.WO_NO , sum(YWO.QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
	        "        sum(YWO.QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(YWO.QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"        sum(YWO.QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(YWO.QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"        sum(YWO.QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE, sum(YWO.WORK_TIME) as WORK_TIME "+
	        "   from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA ";	

   sSqlCNT = " select count(YWA.INV_ITEM) CaseCount from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA  ";
			
   sWhere =  "  where YWO.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWO.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID and YWO.ORGANIZATION_ID = "+marketType+" "+
             //" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' "+
             "    and YWO.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID and YWO.OPERATION_CODE != '9998'  "+
			 "    and YWO.DEPT_NO in ('1','2','3') "; //  確保由生產系統(不含一月份舊系統麗玲手開工令)
			 
			 
     sWhereSDRQ = "  ";
			 
     if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWO.ORGANIZATION_ID = 326 "; }
     else { sWhere=sWhere+" and YWO.ORGANIZATION_ID = "+marketType+" "; }
     //out.println(dateSetBegin); out.println(MonthFr);
     if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
     else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 
	 if (woType==null || woType.equals("--") || woType.equals("ALL")) { sWhere=sWhere+" "; }
     else { sWhere=sWhere+" and YWO.WORKORDER_TYPE = '"+woType+"' "; }  // 工令類別
	 
	 if (opCode==null || opCode.equals("--") || opCode.equals("ALL")) { sWhere=sWhere+" "; }
     else { sWhere=sWhere+" and YWO.OPERATION_CODE = '"+opCode+"' "; }  // 站別
   
     havingGrp = "group by YWA.INV_ITEM, YWA.WO_NO ";      
     havingGrpSDRQ = "  ";  
     sOrder = "  order by YWA.INV_ITEM, YWA.WO_NO ";
 
     SWHERECOND = sWhere+ sWhereGP;
     //  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
     sSql = sSql + sWhere + havingGrp + sOrder; 
     sSqlCNT = sSqlCNT + sWhere ;
     //out.println("sSql="+sSql); 
   
     String sqlOrgCnt = " select count(YWO.INV_ITEM) CaseCount from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA ";
     sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
     //out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
   
     Statement statement2=con.createStatement();
     ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
     if (rs2.next())
     {
       CaseCountORG = rs2.getInt("CaseCount");     
     }
     rs2.close();
     statement2.close();
   
    
	
   try
   {       	 	
         Statement statement3=con.createStatement();
         ResultSet rs3=statement3.executeQuery(sSqlCNT);
		 if (rs3.next())
		 {
		   //CaseCountORG = CaseCount;
		   CaseCount = rs3.getInt("CaseCount");
		   if (CaseCountORG!=0)
		   {
		     CaseCountPCT = (float)(CaseCount/CaseCountORG)*100;
			 //out.println("CaseCount="+CaseCount);
			 //out.println("CaseCountPCT="+CaseCountPCT);
			 // 取小數1位
			sCSCountPCT = Float.toString(CaseCountPCT);
			idxCSCount = sCSCountPCT.indexOf('.');
			sCSCountPCT = sCSCountPCT.substring(0,idxCSCount+1)+sCSCountPCT.substring(idxCSCount+1,idxCSCount+2);
		   }
		   else
		   {
		     CaseCountPCT = 0;
			 //out.println(CaseCountPCT);
		   }
		   rs3.close();
		   statement3.close();
		 }
		 
		} //end of try
        catch (Exception e)
        {
          out.println("Exception 3:"+e.getMessage());
        }
   
}//end of else 


// 準備予維修方式使用的Statement Con //
//Statement stateAct=con.createStatement();
//out.println(sSql);
/*
sSql = "select YWO.INV_ITEM, YWA.WO_NO , sum(YWO.QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE,  "+
       "       sum(YWO.QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(YWO.QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
	   "       sum(YWO.QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(YWO.QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED,  "+
	   "       sum(YWO.QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE, sum(YWO.WORK_TIME) as WORK_TIME "+
	   "       from YEW_WIP_WIPIO YWO, ORG_ACCT_PERIODS OAP, YEW_WORKORDER_ALL YWA "+
	   "       where YWO.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWO.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID and YWO.ORGANIZATION_ID = 327 "+
	   "         and YWO.WIP_ENTITY_ID = YWA.WIP_ENTITY_ID and YWO.OPERATION_CODE != '9998' "+
	   "         group by YWO.INV_ITEM, YWA.WO_NO "+
	   "         order by YWO.INV_ITEM, YWA.WO_NO";
*/
sqlGlobal = sSql;
//out.print("sqlGlobal="+sqlGlobal+"<br>");
//PreparedStatement StatementRpRepair = ConnRpRepair.prepareStatement(sSql);
Statement statementTC=con.createStatement(); 
//ResultSet rsTC = StatementRpRepair.executeQuery();
ResultSet rsTC=statementTC.executeQuery(sSql);
   //boolean RpRepair_isEmpty = !RpRepair.next();
   //boolean RpRepair_hasData = !RpRepair_isEmpty;
   //Object RpRepair_data;
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  
//int RpRepair_numRows = 0;

// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;


if (rs_isEmptyTC) {
  rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) {
  rs_numRows = 1;
}

String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = rsTC;
int       MM_rsCount = rs_total;
int       MM_size = rs_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) {
    rs_hasDataTC = MM_rs.next();
  }
  if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    rs_hasDataTC = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
  if (!rs_hasDataTC) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!rs_hasDataTC && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  rsTC.close();
  rsTC = statementTC.executeQuery(sSql);
  rs_hasDataTC = rsTC.next();
  MM_rs = rsTC;

  // move the cursor to the selected record
  for (i=0; rs_hasDataTC && i < MM_offset; i++) {
    rs_hasDataTC = MM_rs.next();
  }
}

// *** Move To Record: update recordset stats

// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  rs_first = Math.min(rs_first, MM_rsCount);
  rs_last  = Math.min(rs_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}


// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


// *** Move To Record: set the strings for the first, last, next, and previous links

String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
}



%> 
<%
  if (listMode==null || listMode.equals("TRUE"))
  {
%>     
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
     <tr>
	    <td width="10%" colspan="1" nowrap>
		<font color="#006666"><strong>
		內銷/外銷</strong></font>       </td> 
		<td width="13%">
	   <%		 
	             try
                 {  
				   //-----取內外銷別
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select ORGANIZATION_ID as MARKETTYPE,CODE_DESC from apps.YEW_MFG_DEFDATA ";
			       String whereOType = " where DEF_TYPE='MARKETTYPE'  ";								  
				   String orderType = "  ";  
				   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();
				//out.print("MARKETTYPE"+marketType);
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }	   
       %>	   </td>
	   <td nowrap colspan="2"><font color="#006666"><strong>生產月份</strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font> 
        <%
		  //String CurrYear = null;	     		 
	     //try
         //{       
         // String a[]={"2006","2007","2008","2009","2010","2011","2012"};
         // arrayComboBoxBean.setArrayString(a);
		 // if (YearFr==null)
		 // {
		 //   CurrYear=dateBean.getYearString();
		 //   arrayComboBoxBean.setSelection(CurrYear);
		 // } 
		 // else 
		 // {
		 //  arrayComboBoxBean.setSelection(YearFr);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARFR");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         // out.println("Exception  year:"+e.getMessage());
         //}
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
			arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
			arrayComboBoxBean.setFieldName("YEARFR");	   
			out.println(arrayComboBoxBean.getArrayString());		      		 
		} //end of try
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}			 
		 String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>             
    </td>  
	<td nowrap colspan="2"><font color="#006666"><strong>工令類別</strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font>
	   <%
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
		           comboBoxAllBean.setRs(rs);
		           comboBoxAllBean.setSelection(woType);
	               comboBoxAllBean.setFieldName("WOTYPE");	   
                   out.println(comboBoxAllBean.getRsString());
				   */
				   out.println("<select NAME='WOTYPE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWIPSingleOPRpt.jsp"+'"'+")'>");
                   out.println("<OPTION VALUE=ALL>ALL");     
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
				 { 
				   out.println("Exception:"+e.getMessage());
				 }
	   %>
	</td>
	<td nowrap colspan="2"><font color="#006666"><strong>站別</strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font>
	   <%
	             try
                 {  
				   //-----取站別  
		           Statement stateOP=con.createStatement();
                   ResultSet rsOP=null;	
			       String sqlOP = " select DISTINCT OPERATION_CODE, OPERATION_CODE || '(' || WOP.DESCRIPTION || ')' "+
				                  " from YEW_WIP_WIPIO YWWI, WIP_OPERATIONS WOP ";
			       String whereOP = " where YWWI.OPERATION_SEQ_NUM = WOP.OPERATION_SEQ_NUM "+
				                    "   and YWWI.WIP_ENTITY_ID = WOP.WIP_ENTITY_ID "+
				                    "   and YWWI.OPERATION_CODE IS NOT NULL ";								  
				   String orderOP = "  ";  
				   if (woType!=null && !woType.equals("ALL")) whereOP =  whereOP + " and YWWI.WORKORDER_TYPE ='"+woType+"' ";
				   sqlOP = sqlOP + whereOP;
				   //out.println(sqlOP);
                   rsOP=stateOP.executeQuery(sqlOP);
				   
		           comboBoxAllBean.setRs(rsOP);
		           comboBoxAllBean.setSelection(opCode);
	               comboBoxAllBean.setFieldName("OPCODE");	   
                   out.println(comboBoxAllBean.getRsString());
		           rsOP.close();   
				   stateOP.close();  
	             } //end of try		 
                 catch (Exception e) 
				 { 
				   out.println("Exception:"+e.getMessage());
				 }
	   %>
	</td>
	<td width="22%" colspan="2">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSCMfgWIPSingleOPRpt.jsp")' > 
			<input type="reset" name="RESET" align="middle"  value='重置' onClick='setSubmit2("../jsp/TSCMfgWIPSingleOPEntry.jsp")' >
			<!--INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.DATESETBEGIN.value,this.form.DATESETEND.value)' -->  
			<INPUT TYPE="button" align="middle" value='EXCEL' onClick='setSubmit1(this.form.CLASSID.value,this.form.MARKETTYPE.value)' disabled>	
	</td>
   </tr>
  </table>  
<%  
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
   <tr>
      <td colspan="11"><div align="center"><strong>陽信長威電子有限公司</strong></div></td>
   </tr>
   <tr>
      <td colspan="11"><div align="center">流程卡與單站統計(<%=orgCode%>)</div></td>
   </tr>
   <tr bgcolor="#BBD3E1"> 	  
	  <td width="10%" height="22" nowrap><div align="center"><font color="#006666" face="Arial">料號</font></div></td>               
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">工令</font></div></td>
      <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">期初數</font></div></td>           
      <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">接收數</font></div></td> 	 
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">處理數</font></div></td>  
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">產出數</font></div></td>
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">耗損數</font></div></td>
	  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">期末數</font></div></td>	 
	  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">工時</font></div></td>  	   
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">良品率</font></div></td>
	  <td width="6%" nowrap><div align="center"><font color="#006666" face="Arial">PPH</font></div></td>  	  	  
    </tr>	
    <% 
	   float beginBalTotal=0, qtyReceiptTotal=0, qtyProcessTotal=0, qtyCompleteTotal=0, qtyScrapTotal=0, endBalTotal=0, workTimeTotal=0; 
	   float yieldRateLPL = 0, pphValue = 0;
	   String yieldRateLPLStr = "", pphValueStr = "";
	   java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
	   java.math.BigDecimal bd = null;
	   
	   java.text.DecimalFormat nf2 = new java.text.DecimalFormat("###,##0.00"); // 取小數後二位 
	   java.math.BigDecimal bd2 = null;
	  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
	  {
    %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0) {
	       colorStr = "#D8E6E7";
	     }
	     else {
	           colorStr = "#BBD3E1"; }		
    %>     
	  <%
	  %>     
    <tr bgcolor="<%=colorStr%>">  	  
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("WO_NO")%></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <% 		     
				   out.println(rsTC.getFloat("QUANTITY_BEGIN_BALANCE"));
				   beginBalTotal=beginBalTotal+rsTC.getFloat("QUANTITY_BEGIN_BALANCE"); 
			   %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%
	               out.println(rsTC.getFloat("QUANTITY_RECEIVED"));
				   qtyReceiptTotal=qtyReceiptTotal+rsTC.getFloat("QUANTITY_RECEIVED");
	           %>
	  </font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%			      			     
				 out.println(rsTC.getFloat("QUANTITY_PROCESSED"));	
				  qtyProcessTotal=qtyProcessTotal+rsTC.getFloat("QUANTITY_PROCESSED");		      
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%
			     out.println(rsTC.getFloat("QUANTITY_COMPLETED"));	
				 qtyCompleteTotal=qtyCompleteTotal+rsTC.getFloat("QUANTITY_COMPLETED");		   
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%    
			         out.println(rsTC.getFloat("QUANTITY_SCRAPPED")); 	                 
					 qtyScrapTotal=qtyScrapTotal+rsTC.getFloat("QUANTITY_SCRAPPED"); 
			   %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <% out.println(rsTC.getFloat("QUANTITY_END_BALANCE")); 
			     //frontEndBalTotal=frontEndBalTotal+rsTC.getFloat("QUANTITY_END_BALANCE"); 
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <% 
			      out.println(rsTC.getFloat("WORK_TIME")); 
			      workTimeTotal=workTimeTotal+rsTC.getFloat("WORK_TIME");
			   %></font></div></td>	  
	     <%
	     // 計算LPL (良率及PPH值)
		     yieldRateLPL = rsTC.getFloat("QUANTITY_COMPLETED") / ( rsTC.getFloat("QUANTITY_BEGIN_BALANCE") + rsTC.getFloat("QUANTITY_PROCESSED") )*100; //  良率 = 產出數 / (期初 + 處理數) * 100%
			 yieldRateLPLStr = Float.toString(yieldRateLPL);
			 
		   
			if (rsTC.getFloat("WORK_TIME")>0) // 若工時 > 0 方能計算PPH值,否則,其值顯示 " 未輸入工時"
			{
			  pphValue = rsTC.getFloat("QUANTITY_COMPLETED") / rsTC.getFloat("WORK_TIME"); // PPH 值 = 產出數 / 工時			  
			  // 計算 (PPH值)
		      try
		      { 		           
			       pphValueStr = nf.format(pphValue);
				   bd = new java.math.BigDecimal(pphValueStr);
				   java.math.BigDecimal pphValueStrQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				   pphValue = pphValueStrQty.floatValue();
		      } //end of try
              catch (NumberFormatException e)
              {
			   e.printStackTrace();
               System.out.println("Exception: PPH"+e.getMessage());
              }
			  
			  pphValueStr =  Float.toString(pphValue);
			  
			}
			else { 
			       pphValue = 0; 
				   pphValueStr = "未輸工時";
				 }
		  
		 // 計算(良率)
		  try
		  { 		           
			       yieldRateLPLStr = nf2.format(yieldRateLPL);
				   bd2 = new java.math.BigDecimal(yieldRateLPLStr);
				   java.math.BigDecimal yieldRateLPLStrQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				   yieldRateLPL = yieldRateLPLStrQty.floatValue();
		  } //end of try
          catch (NumberFormatException e)
          {
		   e.printStackTrace();
           System.out.println("Exception:LPL"+e.getMessage());	   
          }
		  
		   
	    %>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=yieldRateLPL+"%"%></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial"><%=pphValueStr%></font></div></td> 	    
    </tr> 
    <%
         rs1__index++;
         rs_hasDataTC = rsTC.next();
         counta = rs1__index ;		 
       }  // End of While 
	   
	   // 計算總計的良率及PPH值
	   java.text.DecimalFormat nfSum = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位 
	   java.math.BigDecimal bdSum = null;
	   
	   java.text.DecimalFormat nfSum2 = new java.text.DecimalFormat("###,##0.00"); // 取小數後二位 
	   java.math.BigDecimal bdSum2 = null;
	   
	   float sumYieldRateLPL = 0, sumPPHValue = 0;
	   
	   sumYieldRateLPL = qtyCompleteTotal / ( beginBalTotal + qtyProcessTotal )*100; //  良率 = 產出數 / (期初 + 處理數) * 100%
	 
	 /* 
	      // 計算(總良率)
		  try
		  { 		           
			       String sumYieldRateLPLStr = nfSum2.format(sumYieldRateLPL);
				   bdSum2 = new java.math.BigDecimal(sumYieldRateLPLStr);
				   java.math.BigDecimal sumYieldRateLPLStrQty = bdSum2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				   sumYieldRateLPL = sumYieldRateLPLStrQty.floatValue();
		  } //end of try
          catch (NumberFormatException e)
          {
           out.println("Exception:SUMLPL"+e.getMessage());
		   e.printStackTrace();
          }
	  */
	   if (workTimeTotal>0) // 避免分母為零,若工時 > 0 方能計算PPH值,否則,其值顯示 " 未輸入工時"
	   {
	     sumPPHValue = qtyCompleteTotal / workTimeTotal; // PPH 值 = 產出數 / 工時	
		 
		      // 計算 (PPH值)
		      try
		      { 		           
			       String sumPPHValueStr = nf.format(sumPPHValue);
				   bdSum = new java.math.BigDecimal(sumPPHValue);
				   java.math.BigDecimal sumPPHValueStrQty = bdSum.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				   sumPPHValue = sumPPHValueStrQty.floatValue();
		      } //end of try
              catch (NumberFormatException e)
              {
               out.println("Exception: PPH"+e.getMessage());
              }
	   }	
	   // 計算總計的良率及PPH值
    %>
	<tr>
	   <td colspan="2"><div align="center"><font color="#006666" face="Arial">總計</font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=beginBalTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=qtyReceiptTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=qtyProcessTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=qtyCompleteTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=qtyScrapTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=endBalTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=workTimeTotal%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=sumYieldRateLPL+"%"%></font></div></td>
	   <td><div align="right"><font color="#006666" face="Arial"><%=sumPPHValue%></font></div></td>	   
	</tr>
 </table> 
 
 <!--% 以下為分頁次 %--> 
 <table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveFirst%>">第一頁</A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_movePrev%>">前一頁</A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveNext%>">下一頁</A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveLast%>">最後頁</A>]</strong></font></pre>
      </div></td>
  </tr>
</table> 
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=%>">
<input type="hidden" name="SWHERECOND" value="<%=%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">

<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="ORGANIZATIONID" type="HIDDEN" value="<%=organizationId%>">
<input type="hidden" name="ITEMID" value="<%=%>" >
<input type="hidden" name="WOUOM" value="<%=%>" >
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
rsTC.close();
statementTC.close();
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>

