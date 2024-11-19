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

function setSubmit2(URL)  //清除畫面條件,重新查詢!{  
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
<title>生產系統-產品別良率統計表</title>
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
int rs1__numRows = 200;
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
	
	String partNo=request.getParameter("PARTNO");	
	
	if (partNo==null) partNo = "";
 
	
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
<FORM ACTION="../jsp/TSCMfgWIPProdYieldRpt.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>生產月報統計表-產品別良率</a></strong></font>
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

     sSql = " select DISTINCT YWWA.PART_NO, YWWA.ACCT_PERIOD_ID "+
	        " from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP, "+
			"     (select PART_NO, ACCT_PERIOD_ID,  "+
			"             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			"             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			"        from YEW_WIP_WIPIO_ALL "+
			"       where ORGANIZATION_ID ="+marketType+" "+
			"         and OPERATION_CODE != '9998' "+
			"         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			"    GROUP BY PART_NO, ACCT_PERIOD_ID "+
			"     ) YWWB ";	

   sSqlCNT = " select count(DISTINCT YWWA.PART_NO) CaseCount from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP,  "+
             "     (select PART_NO, ACCT_PERIOD_ID,  "+
			"             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			"             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			"        from YEW_WIP_WIPIO_ALL "+
			"       where ORGANIZATION_ID ="+marketType+" "+
			"         and OPERATION_CODE != '9998' "+
			"         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			"    GROUP BY PART_NO, ACCT_PERIOD_ID "+
			 "     ) YWWB ";
			
   sWhere =  "  where YWWA.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWWA.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID "+
                " and YWWA.ORGANIZATION_ID = "+marketType+" and YWWA.OPERATION_CODE != '9998' "+
				" and YWWA.ACCT_PERIOD_ID = YWWB.ACCT_PERIOD_ID "+
				" and YWWA.PART_NO = YWWB.PART_NO  "+
				" and ( YWWB.QUANTITY_BEGIN_BALANCE > 0 "+
				"     or YWWB.QUANTITY_RECEIVED >0 or YWWB.QUANTITY_PROCESSED >0 "+
				"     or YWWB.QUANTITY_COMPLETED > 0 or YWWB.QUANTITY_SCRAPPED >0 "+
				"     or YWWB.QUANTITY_END_BALANCE > 0 ) "+
				" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";
			 
   sWhereSDRQ = " ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "   order by YWWA.PART_NO ";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   sSqlCNT = sSqlCNT +  sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ;   
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
   
  try
  {   
     sSql = " select DISTINCT YWWA.PART_NO, YWWA.ACCT_PERIOD_ID "+
	        " from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP, "+
			"     (select PART_NO, ACCT_PERIOD_ID,  "+
			"             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			"             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			"        from YEW_WIP_WIPIO_ALL "+
			"       where ORGANIZATION_ID ="+marketType+" "+
			"         and OPERATION_CODE != '9998' "+
			"         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			"    GROUP BY PART_NO, ACCT_PERIOD_ID "+
			"     ) YWWB ";		

     sSqlCNT = " select count(DISTINCT YWWA.PART_NO) CaseCount from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP,  "+
             "     (select PART_NO, ACCT_PERIOD_ID,  "+
			"             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			"             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			"             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			"             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			"        from YEW_WIP_WIPIO_ALL "+
			"       where ORGANIZATION_ID ="+marketType+" "+
			"         and OPERATION_CODE != '9998' "+
			"         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			"    GROUP BY PART_NO, ACCT_PERIOD_ID "+
			 "     ) YWWB ";
			
      sWhere =  " where YWWA.ORGANIZATION_ID = OAP.ORGANIZATION_ID and YWWA.ACCT_PERIOD_ID = OAP.ACCT_PERIOD_ID "+
                "   and YWWA.ORGANIZATION_ID = "+marketType+" "+
				"   and YWWA.ACCT_PERIOD_ID = YWWB.ACCT_PERIOD_ID "+
				"   and YWWA.PART_NO = YWWB.PART_NO  "+
				"   and ( YWWB.QUANTITY_BEGIN_BALANCE > 0 "+
				"       or YWWB.QUANTITY_RECEIVED >0 or YWWB.QUANTITY_PROCESSED >0 "+
				"       or YWWB.QUANTITY_COMPLETED > 0 or YWWB.QUANTITY_SCRAPPED >0 "+
				"       or YWWB.QUANTITY_END_BALANCE > 0 ) "+
				"   and YWWA.OPERATION_CODE != '9998' "; // 不含外購
			 
			 
     sWhereSDRQ = "  ";
			 
     if (marketType==null || marketType.equals("--") || marketType.equals("")) { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = 326 "; }
     else { sWhere=sWhere+" and YWWA.ORGANIZATION_ID = "+marketType+" "; }
   
     if (MonthFr!="--" && !MonthFr.equals("--")) sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateSetBegin+"' ";  
     else	sWhere=sWhere+" and to_char(OAP.PERIOD_START_DATE,'YYYYMM')= '"+dateBean.getYearString()+dateBean.getMonthString()+"' ";   
	 	 
	 if (partNo==null || partNo.equals("--") || partNo.equals("")) { sWhere=sWhere+"  "; }
     else { sWhere=sWhere+" and YWWA.PART_NO =  '"+partNo+"' "; }
   
     havingGrp = "  ";      
     havingGrpSDRQ = "  ";  
     sOrder = "  order by YWWA.PART_NO ";
 
     SWHERECOND = sWhere+ sWhereGP;
     //  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
     sSql = sSql + sWhere +  sOrder;  
     sSqlCNT = sSqlCNT + sWhere ;
     //out.println("sSql="+sSql); 
   
     String sqlOrgCnt = " select count(DISTINCT YWWA.PART_NO) CaseCount "+
	                    " from YEW_WIP_WIPIO_ALL YWWA, ORG_ACCT_PERIODS OAP, "+
	           		    "     (select PART_NO, ACCT_PERIOD_ID,  "+
			            "             sum(QUANTITY_BEGIN_BALANCE) as QUANTITY_BEGIN_BALANCE, "+
			            "             sum(QUANTITY_RECEIVED) as QUANTITY_RECEIVED, sum(QUANTITY_PROCESSED) as QUANTITY_PROCESSED, "+
			            "             sum(QUANTITY_COMPLETED) as QUANTITY_COMPLETED, sum(QUANTITY_SCRAPPED) as QUANTITY_SCRAPPED, "+
			            "             sum(QUANTITY_END_BALANCE) as QUANTITY_END_BALANCE "+
			            "        from YEW_WIP_WIPIO_ALL "+
			            "       where ORGANIZATION_ID ="+marketType+" "+
			            "         and OPERATION_CODE != '9998' "+
						"         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
			            "    GROUP BY PART_NO, ACCT_PERIOD_ID "+
			            "     ) YWWB ";	
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
   
   } //end of try
   catch (Exception e)
   {
     out.println("Exception 2:"+e.getMessage());
   }
	
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
	    <td width="12%" colspan="1" nowrap>
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
				   //rs=statement.executeQuery(sqlOrgInf);
				 
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(marketType);
	               comboBoxBean.setFieldName("MARKETTYPE");	   
                   out.println(comboBoxBean.getRsString());
				   /*
				   out.println("<select NAME='MARKETTYPE' onChange='setSubmit("+'"'+"../jsp/TSCMfgWIPProdYieldRpt.jsp"+'"'+")'>");
                   out.println("<OPTION VALUE=-->--");     
                   while (rs.next())
                   {            
                    String s1=(String)rs.getString(1); 
                    String s2=(String)rs.getString(2); 
                        
                     if (s1.equals(marketType)) 
                    {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                    }   
			        else 
			        {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                    }        
                   } //end of while
                   out.println("</select>"); 
				  */
		           rs.close();   
				   statement.close();
				//out.print("MARKETTYPE"+marketType);
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); }	   
       %>	   </td>
	   <td nowrap colspan="2"><font color="#006666"><strong>生產月份</strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font>             
        
        <%
		 // String CurrYear = null;	     		 
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
		 //   arrayComboBoxBean.setSelection(YearFr);
		 // }
	     // arrayComboBoxBean.setFieldName("YEARFR");	   
         // out.println(arrayComboBoxBean.getArrayString());		      		 
         //} //end of try
         //catch (Exception e)
         //{
         //out.println("Exception  year:"+e.getMessage());
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
	   <td nowrap><font color="#006666"><strong>成本代號</strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font>
	   <%
	             try
                 {  
				   //-----取站別  
		           Statement stateOP=con.createStatement();
                   ResultSet rsOP=null;	
			       String sqlOP = " select DISTINCT PART_NO, PART_NO "+
				                  " from YEW_WIP_WIPIO_ALL ";
			       String whereOP = " where ORGANIZATION_ID IS NOT NULL ";			
				   
				   if (marketType!=null && !marketType.equals("") && !marketType.equals("--"))	
				   {  whereOP = whereOP + " and ORGANIZATION_ID  = "+marketType+" "; }  
				   					  
				   String orderOP = "  ";  				   
				   sqlOP = sqlOP + whereOP;
				   //out.println(sqlOP);
                   rsOP=stateOP.executeQuery(sqlOP);
				   
		           comboBoxAllBean.setRs(rsOP);
		           comboBoxAllBean.setSelection(partNo);
	               comboBoxAllBean.setFieldName("PARTNO");	   
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
	<td width="31%" colspan="2">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSCMfgWIPProdYieldRpt.jsp")' > 
			<input type="button" name="RESET" align="middle"  value='重置' onClick='setSubmit2("../jsp/TSCMfgWIPProdYieldEntry.jsp")' >
			<!--INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.DATESETBEGIN.value,this.form.DATESETEND.value)' -->  
			<INPUT TYPE="button" align="middle" value='EXCEL' onClick='setSubmit("../jsp/TSCMfgWIPProdYield2Excel.jsp")'>	</td>
   </tr>
  </table>  
<%  
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
    <% 
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
  <tr>    
   <td>成本代號:<%=rsTC.getString("PART_NO")%></td>
 </tr>
 <tr><td>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
    <tr bgcolor="#BBD3E1"> 	  
	  <td width="7%" height="22" nowrap><div align="center"><font color="#006666" face="Arial">站別</font></div></td>               
	  <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial">站名</font></div></td>
      <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">期初</font></div></td>           
      <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">接收</font></div></td> 	  
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">產出</font></div></td>
	  <td width="10%" nowrap><div align="center"><font color="#006666" face="Arial">耗損</font></div></td>
	  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">期末</font></div></td>	 
	  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">工時</font></div></td>  	   
	  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">良品率</font></div></td>
	  <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">PPH</font></div></td>  	  	  
    </tr>	
	 <%
	     int opCount = 0;
	     float frontBeginBalTotal=0, frontQtyScrapTotal=0, frontEndBalTotal=0,frontWorkTimeTotal=0,frontLPL=0,frontPPH=0;
		 float frontFirstOpRec = 0, frontOSPComplete=0;
		 float frontLPLRate=0,frontPPHRate=0,frontProdLPLRate=1;
	     // 依各個成本代號,找對應結轉各項數據_起
		           Statement stateFront=con.createStatement();
                   
			       String sqlFront = " select OPERATION_SEQ_NUM, OPERATION_CODE, OPERATION_DESCRIPTION, QUANTITY_BEGIN_BALANCE, QUANTITY_RECEIVED, "+
	                                 "        QUANTITY_COMPLETED, QUANTITY_SCRAPPED, QUANTITY_END_BALANCE, WORK_TIME, LPL, PPH "+
									 "   from YEW_WIP_WIPIO_ALL ";
			       String whereFront = " where PART_NO = '"+rsTC.getString("PART_NO")+"' and ORGANIZATION_ID = "+marketType+" and ACCT_PERIOD_ID = "+rsTC.getString("ACCT_PERIOD_ID")+"  "+
				                       "   and TYPE_ID = 1 and OPERATION_CODE != '9998' "+
									   "         and ( FIRST_OPERATION IS NULL or LAST_OPERATION IS NULL ) "+
									   "   and OPERATION_DESCRIPTION not like '%切割%' "+
									   "   and BM in ('1','2','3') ";	//  確保由生產系統(不含一月份舊系統麗玲手開工令)								  
				   String orderFront = "  order by PART_NO, OPERATION_SEQ_NUM "; 				    
				   sqlFront = sqlFront + whereFront + orderFront;
				   ResultSet rsFront=stateFront.executeQuery(sqlFront);	
		 //out.println("sqlFront="+sqlFront);
		 while (rsFront.next())
		 // 依各個成本代號,找對應結轉各項數據_迄	
		 {  
		  opCount++;  // 計數,判斷是否為該機種的第一站,如為第一站(焊接)則存入變數
		  //if (opCount==1)		  
		  if (rsFront.getString("OPERATION_DESCRIPTION").indexOf("焊接")>=0 || opCount==1)  // 2007/03/22 因為第一站未必是焊接站
		  {
		     frontFirstOpRec = rsFront.getFloat("QUANTITY_RECEIVED");
		  }
		  // 取委外加工(外包_9999)產出數為前段產出數
		  if (rsFront.getString("OPERATION_CODE").equals("9999"))
		  {
		    frontOSPComplete = rsFront.getFloat("QUANTITY_COMPLETED");
		  }
		  
		  if (rsFront.getFloat("QUANTITY_COMPLETED")!=0)  // 2007/03/23 若製程無外包站,則判斷產出數給變數
		  {
		     frontOSPComplete = rsFront.getFloat("QUANTITY_COMPLETED");
		  }
	  %>     
    <tr bgcolor="<%=colorStr%>">  	  
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsFront.getString("OPERATION_CODE")%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsFront.getString("OPERATION_DESCRIPTION")%></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <% 
			     
			      float qtyFrontBeginBalance = 0;
				  try
		          { 
			       String strFrontBeginBalance = nf.format(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				   bd = new java.math.BigDecimal(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				   java.math.BigDecimal strFrontBeginBalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				   qtyFrontBeginBalance = strFrontBeginBalQty.floatValue();
			      } //end of try
                  catch (NumberFormatException e)
                  {
                   System.out.println("Exception: Begin Balance"+e.getMessage());
                  }
			       //out.println(qtyFrontBeginBalance); 
				   
				   out.println(rsFront.getFloat("QUANTITY_BEGIN_BALANCE"));
				   frontBeginBalTotal=frontBeginBalTotal+rsFront.getFloat("QUANTITY_BEGIN_BALANCE"); 
			   %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%
			       
			       float qtyFrontReceive = 0;
				   try
		           {
			        String strFrontQtyReceive = nf.format(rsFront.getFloat("QUANTITY_RECEIVED"));
					
				    //bd = new java.math.BigDecimal(strFrontQtyReceive);
					bd = new java.math.BigDecimal(rsFront.getDouble("QUANTITY_RECEIVED"));
					//out.println("bd="+bd);
				    java.math.BigDecimal strFrontReceiveQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    qtyFrontReceive = strFrontReceiveQty.floatValue();
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty to Receive"+e.getMessage());
                   }
				   out.println(qtyFrontReceive);
				   
			     //=rsFront.getFloat("QUANTITY_RECEIVED")
				 //out.println(rsFront.getFloat("QUANTITY_RECEIVED"));			      
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%
			       // 2007/03/29 確認是否結轉產出數 = 接收 + 期初 - 期末 - 耗損, 否則, 以此公式計算產出數
				   float calFrontCompleteQty = rsFront.getFloat("QUANTITY_RECEIVED")+rsFront.getFloat("QUANTITY_BEGIN_BALANCE")-rsFront.getFloat("QUANTITY_END_BALANCE")-rsFront.getFloat("QUANTITY_SCRAPPED"); 
			       try
				   {			         
				    bd = new java.math.BigDecimal(calFrontCompleteQty);
				    java.math.BigDecimal strCalCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    calFrontCompleteQty = strCalCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Complete"+e.getMessage());
                   }
				   			     
			       float qtyFrontComplete = 0;
				   try
				   {
			        String strFrontQtyComplete = nf.format(rsFront.getFloat("QUANTITY_COMPLETED"));
				    bd = new java.math.BigDecimal(rsFront.getFloat("QUANTITY_COMPLETED"));
				    java.math.BigDecimal strFrontCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    qtyFrontComplete = strFrontCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Complete"+e.getMessage());
                   }
				   
				   if (calFrontCompleteQty != qtyFrontComplete)  qtyFrontComplete = calFrontCompleteQty;  // 若不相等,則以計算的產出數為顯示的產出數				   
				   
				   out.println(qtyFrontComplete);
			       //out.println(rsFront.getFloat("QUANTITY_COMPLETED"));		   
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><% out.println(rsFront.getFloat("QUANTITY_SCRAPPED")); frontQtyScrapTotal=frontQtyScrapTotal+rsFront.getFloat("QUANTITY_SCRAPPED"); %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial"><% out.println(rsFront.getFloat("QUANTITY_END_BALANCE")); frontEndBalTotal=frontEndBalTotal+rsFront.getFloat("QUANTITY_END_BALANCE"); %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><% out.println(rsFront.getFloat("WORK_TIME")); frontWorkTimeTotal=frontWorkTimeTotal+rsFront.getFloat("WORK_TIME"); %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial"><%=rsFront.getFloat("LPL")+"%"%></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial"><%=rsFront.getFloat("PPH")%></font></div></td> 	    
    </tr> 
	 <%
	     frontProdLPLRate = frontProdLPLRate*rsFront.getFloat("LPL")/100; // 前段乘績的良率
		 
		 //out.println("frontProdLPLRate"+frontProdLPLRate);
	 
	    } // End of while
		rsFront.close();
		stateFront.close();
		
		// 計算前段的良品率
		 // frontLPLRate=(frontOSPComplete/frontBeginBalTotal)+frontFirstOpRec*100;
		 frontLPLRate=frontOSPComplete/(frontBeginBalTotal+frontFirstOpRec-frontEndBalTotal)*100; //公式:產出/(期初+接收-期末)=良率
		// 計算前段的產出率
		 frontPPHRate=(frontOSPComplete/frontWorkTimeTotal)*1;
		
	  %>	  
    <tr><!--% 前段的加總 %--> 
      <td height="23" colspan="2">前段</td> 
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <% 
			    // miscellaneousBean.setRoundDigit(3);
                //out.println(miscellaneousBean.getFloatRoundStr(frontBeginBalTotal));
				 
				   float frontBeginBalTotalQty = frontBeginBalTotal;
				   try
				   {
			        String strFrontBeginBalTotal = nf.format(frontBeginBalTotal);
				    bd = new java.math.BigDecimal(strFrontBeginBalTotal);
				    java.math.BigDecimal strFrontBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontBeginBalTotalQty = strFrontBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Begin TotQty"+e.getMessage());
                   }
				   
				   out.println(frontBeginBalTotalQty);
				   
				 
			  %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <% 		      
                 //out.println(miscellaneousBean.getFloatRoundStr(frontFirstOpRec));
				 
				   float frontFirstOpRecQty = frontFirstOpRec;
				   try
				   {
			        String strFrontFirstOpRec = nf.format(frontFirstOpRec);
				    bd = new java.math.BigDecimal(strFrontFirstOpRec);
				    java.math.BigDecimal strFrontFirstOpRecQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontFirstOpRecQty = strFrontFirstOpRecQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty First OpQty"+e.getMessage());
                   }
				   
				   out.println(frontFirstOpRecQty);
				 
			  %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <% 
			     //out.println(miscellaneousBean.getFloatRoundStr(frontOSPComplete));
				 
				   float frontOSPCompleteQty = frontOSPComplete;
				   try
				   {
			        String strFrontOSPComplete = nf.format(frontOSPComplete);
				    bd = new java.math.BigDecimal(strFrontOSPComplete);
				    java.math.BigDecimal strFrontOSPCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontOSPCompleteQty = strFrontOSPCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty First OSP Qty"+e.getMessage());
                   }
				   
				   out.println(frontOSPCompleteQty);
				 
			  %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <% 
			     //out.println(miscellaneousBean.getFloatRoundStr(frontQtyScrapTotal));
				 
				   float frontQtyScrapTotalQty = frontQtyScrapTotal;
				   try
				   {
			        String strFrontQtyScrapTotal = nf.format(frontQtyScrapTotal);
				    bd = new java.math.BigDecimal(strFrontQtyScrapTotal);
				    java.math.BigDecimal strFrontQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontQtyScrapTotalQty = strFrontQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }
				   
				   out.println(frontQtyScrapTotalQty);
				 
			  %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <% 
			     //out.println(miscellaneousBean.getFloatRoundStr(frontEndBalTotal));
				 
				   float frontEndBalTotalQty = frontEndBalTotal;
				   try
				   {
			        String strFrontEndBalTotal = nf.format(frontEndBalTotal);
				    bd = new java.math.BigDecimal(strFrontEndBalTotal);
				    java.math.BigDecimal strFrontEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontEndBalTotalQty = strFrontEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }
				   
				   out.println(frontEndBalTotalQty);
				 
			  %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <% 
			       //out.println(miscellaneousBean.getFloatRoundStr(frontWorkTimeTotal));
				 
				   float frontWorkTimeTotalQty = frontWorkTimeTotal;
				   try
				   {
			        String strFrontWorkTimeTotal = nf.format(frontWorkTimeTotal);
				    bd = new java.math.BigDecimal(strFrontWorkTimeTotal);
				    java.math.BigDecimal strFrontWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    frontWorkTimeTotalQty = strFrontWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Scrap Qty"+e.getMessage());
                   }
				   
				   out.println(frontWorkTimeTotalQty);
				 
			  %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <% 
			      //out.println(miscellaneousBean.getFloatRoundStr(frontLPLRate)+"%");
				  
				   float frontLPLRateQty = frontProdLPLRate*100;  //frontLPLRate;
				   try
				   {
			        String strFrontLPLRate = nf2.format(frontProdLPLRate*100);
				    bd2 = new java.math.BigDecimal(strFrontLPLRate);
				    java.math.BigDecimal strFrontLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    frontLPLRateQty = strFrontLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty LPL Rate Total"+e.getMessage());
                   }
				   
				   out.println(frontLPLRateQty+"%");
				  
			  %></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial">
	          <% 
			     //out.println(miscellaneousBean.getFloatRoundStr(frontPPHRate));
				 
				   float frontPPHRateQty = frontPPHRate;
				   try
				   {
			        String strFrontPPHRate = nf2.format(frontPPHRate);
				    bd2 = new java.math.BigDecimal(strFrontPPHRate);
				    java.math.BigDecimal strFrontPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    frontPPHRateQty = strFrontPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty PPH Rate Total"+e.getMessage());
                   }
				   
				   out.println(frontPPHRateQty);
				 
			  %></font></div></td>     
     </tr>
	 <%
	     int bkOpCount = 0;
	     float backBeginBalTotal=0, backQtyScrapTotal=0, backEndBalTotal=0,backWorkTimeTotal=0,backLPL=0,backPPH=0; 
		 float backFirstOpRec=0, backPackComplete=0;
		 float backLPLRate=0,backPPHRate=0,backProdLPLRate=1;
		 float backSumRcptQty=0,backTotalRcptQty = 0;
	     // 依各個成本代號,找對應結轉各項數據_起
		           Statement stateBack=con.createStatement();
                   
			       String sqlBack = " select OPERATION_SEQ_NUM, OPERATION_CODE, OPERATION_DESCRIPTION, QUANTITY_BEGIN_BALANCE, QUANTITY_RECEIVED, "+
	                                 "        QUANTITY_COMPLETED, QUANTITY_SCRAPPED, QUANTITY_END_BALANCE, WORK_TIME, LPL, PPH "+
									 "   from YEW_WIP_WIPIO_ALL ";
			       String whereBack = " where PART_NO = '"+rsTC.getString("PART_NO")+"' and ORGANIZATION_ID = "+marketType+" and ACCT_PERIOD_ID = "+rsTC.getString("ACCT_PERIOD_ID")+"  "+
				                       "   and TYPE_ID = 2 "+
									   "   and BM in ('1','2','3') ";	//  確保由生產系統(不含一月份舊系統麗玲手開工令)
				   String orderBack = "  order by PART_NO, OPERATION_SEQ_NUM "; 
				   sqlBack = sqlBack + whereBack + orderBack;
				   ResultSet rsBack=stateBack.executeQuery(sqlBack);	
		 while (rsBack.next())
		 // 依各個成本代號,找對應結轉各項數據_迄	
		 {  
		   bkOpCount++;
		   // 取後段接收數=TMTT的接收數 
		   if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("TMT.T")>=0 || bkOpCount==1) // 2007/03/22 因為第一站未必是TMT.T 站
		   {
		      backFirstOpRec=rsBack.getFloat("QUANTITY_RECEIVED");
		   }
		 
		   // 取包裝站產出數為前段產出數
		   if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("包裝")>=0)
		   {
		      backPackComplete=rsBack.getFloat("QUANTITY_COMPLETED");
		   }
		   
		   if (backPackComplete==0 && rsBack.getFloat("QUANTITY_COMPLETED")!=0)  // 2007/03/23 若 取得的站別不為包裝站,則仍把產出數給變數
		   {
		      backPackComplete=rsBack.getFloat("QUANTITY_COMPLETED");
		   }
		 
	   %> 
	<tr><!--% 後段的明細 %-->	  
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsBack.getString("OPERATION_CODE")%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsBack.getString("OPERATION_DESCRIPTION")%></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial"><% out.println(rsBack.getFloat("QUANTITY_BEGIN_BALANCE")); backBeginBalTotal=backBeginBalTotal+rsBack.getFloat("QUANTITY_BEGIN_BALANCE"); %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	             <%//rsBack.getFloat("QUANTITY_RECEIVED") // 2007/03/22 更改為判斷如為首站,則為產出 + 耗損
				    if (rsBack.getString("OPERATION_DESCRIPTION").indexOf("TMT.T")>=0 || bkOpCount==1) // 2007/03/22 因為第一站未必是TMT.T 站
		            {					   
					   float backBeginRcptQty = rsBack.getFloat("QUANTITY_COMPLETED")+rsBack.getFloat("QUANTITY_SCRAPPED");
				       try
				       {
			            String strBackBeginRcpt = nf.format(rsBack.getFloat("QUANTITY_COMPLETED")+rsBack.getFloat("QUANTITY_SCRAPPED"));
				        bd = new java.math.BigDecimal(strBackBeginRcpt);
				        java.math.BigDecimal strBackBeginRcptQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				        backBeginRcptQty = strBackBeginRcptQty.floatValue();				    
				       } //end of try
                       catch (NumberFormatException e)
                       {
                        System.out.println("Exception: Qty Back Begin Receipt "+e.getMessage());
                       }
				      
				       out.println(backBeginRcptQty);
					   backSumRcptQty = backBeginRcptQty;  // 2007/03/23 把第一站的接受數(產出 + 耗損)給後段的接收數
					   backTotalRcptQty = backBeginRcptQty;  // 2007/03/23 把第一站的接受數(產出 + 耗損)給全段的接收數
					   
					} else { // 否則即為實際接收數
					         out.println(rsBack.getFloat("QUANTITY_RECEIVED"));
					       }
				 %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	       <%//=rsBack.getFloat("QUANTITY_COMPLETED")
		       //out.println(rsBack.getFloat("QUANTITY_COMPLETED"));
			   
			       // 2007/03/29 確認是否結轉產出數 = 接收 + 期初 - 期末 - 耗損, 否則, 以此公式計算產出數
				   float calBackCompleteQty = rsBack.getFloat("QUANTITY_RECEIVED")+rsBack.getFloat("QUANTITY_BEGIN_BALANCE")-rsBack.getFloat("QUANTITY_END_BALANCE")-rsBack.getFloat("QUANTITY_SCRAPPED"); 
			       try
				   {			         
				    bd = new java.math.BigDecimal(calBackCompleteQty);
				    java.math.BigDecimal strCalCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    calBackCompleteQty = strCalCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Complete"+e.getMessage());
                   }
			    
			   if (rsBack.getFloat("QUANTITY_COMPLETED")==0)
			   { 
			    out.println(backPackComplete); 
			   } else {  // 2007/03/29 判斷若是後段結轉產出數不等於 =  接收 + 期初 - 期末 - 耗損, 否則, 以此公式計算產出數
			             if (calBackCompleteQty!=rsBack.getFloat("QUANTITY_COMPLETED")) out.println(calBackCompleteQty);
						 else {
			                    out.println(rsBack.getFloat("QUANTITY_COMPLETED")); 
							  }
			          }
			  
		   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><% out.println(rsBack.getFloat("QUANTITY_SCRAPPED")); backQtyScrapTotal=backQtyScrapTotal+rsBack.getFloat("QUANTITY_SCRAPPED"); %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial"><% out.println(rsBack.getFloat("QUANTITY_END_BALANCE")); backEndBalTotal=backEndBalTotal+rsBack.getFloat("QUANTITY_END_BALANCE"); %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><% out.println(rsBack.getFloat("WORK_TIME")); backWorkTimeTotal=backWorkTimeTotal+rsBack.getFloat("WORK_TIME"); %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial"><%=rsBack.getFloat("LPL")+"%"%></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial"><%=rsBack.getFloat("PPH")%></font></div></td>	  
	</tr>
	  <%
	     backProdLPLRate = backProdLPLRate*rsBack.getFloat("LPL")/100; // 後段乘績的良率
	  
	    } // End of while
		rsBack.close();
		stateBack.close();
		
		// 計算後段的良品率
		 //backLPLRate=(backPackComplete/backBeginBalTotal)+frontFirstOpRec*100;
		 backLPLRate=backPackComplete/(backBeginBalTotal+frontFirstOpRec-backEndBalTotal)*100; //公式:產出/(期出+接收-期末)=良率
		// 計算後段的產出率
		 backPPHRate=(backPackComplete/backWorkTimeTotal)*1;
	  %>
	<tr><!--% 後段的加總 %--> 
      <td height="23" colspan="2">後段</td> 
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%
			      //miscellaneousBean.setRoundDigit(3);
			      // out.println(miscellaneousBean.getFloatRoundStr(backBeginBalTotal));
				  
				   float backBeginBalTotalQty = backBeginBalTotal;
				   try
				   {
			        String strBackBeginBalTotal = nf.format(backBeginBalTotal);
				    bd = new java.math.BigDecimal(strBackBeginBalTotal);
				    java.math.BigDecimal strBackBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backBeginBalTotalQty = strBackBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Begin Balance Total"+e.getMessage());
                   }
				   
				   out.println(backBeginBalTotalQty);
				  			   
			   %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%//miscellaneousBean.getFloatRoundStr(frontFirstOpRec)
			      
				   float backFirstOpRecQty = backSumRcptQty;//   backFirstOpRec; // frontFirstOpRec;
				   try
				   {
			        String strBackFirstOpRec = nf.format(backFirstOpRecQty);
				    bd = new java.math.BigDecimal(strBackFirstOpRec);
				    java.math.BigDecimal strBackFirstOpRecQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backFirstOpRecQty = strBackFirstOpRecQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back First Receipt Qty"+e.getMessage());
                   }
				   
				   out.println(backFirstOpRecQty);
			   
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%//miscellaneousBean.getFloatRoundStr(backPackComplete)
			   
			       float backPackCompleteQty = backPackComplete;
				   try
				   {
			        String strBackPackComplete = nf.format(backPackCompleteQty);
				    bd = new java.math.BigDecimal(strBackPackComplete);
				    java.math.BigDecimal strBackPackCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backPackCompleteQty = strBackPackCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Complete Qty"+e.getMessage());
                   }				   
				   out.println(backPackCompleteQty);
				   
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%//miscellaneousBean.getFloatRoundStr(backQtyScrapTotal)
			   
			       float backQtyScrapTotalQty = backQtyScrapTotal;
				   try
				   {
			        String strBackQtyScrapTotal = nf.format(backQtyScrapTotalQty);
				    bd = new java.math.BigDecimal(strBackQtyScrapTotal);
				    java.math.BigDecimal strBackQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backQtyScrapTotalQty = strBackQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Scrap Qty"+e.getMessage());
                   }				   
				   out.println(backQtyScrapTotalQty);
			   
			   %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	           <%//miscellaneousBean.getFloatRoundStr(backEndBalTotal)
			   
			       float backEndBalTotalQty = backEndBalTotal;
				   try
				   {
			        String strBackEndBalTotal = nf.format(backEndBalTotalQty);
				    bd = new java.math.BigDecimal(strBackEndBalTotal);
				    java.math.BigDecimal strBackEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backEndBalTotalQty = strBackEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back End Balance Qty"+e.getMessage());
                   }				   
				   out.println(backEndBalTotalQty);
			   
			   %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	           <%//miscellaneousBean.getFloatRoundStr(backWorkTimeTotal)
			   
			       float backWorkTimeTotalQty = backWorkTimeTotal;
				   try
				   {
			        String strBackWorkTimeTotal = nf.format(backWorkTimeTotalQty);
				    bd = new java.math.BigDecimal(strBackWorkTimeTotal);
				    java.math.BigDecimal strBackWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    backWorkTimeTotalQty = strBackWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back Work Time "+e.getMessage());
                   }				   
				   out.println(backWorkTimeTotalQty);
			   %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <%
			      //miscellaneousBean.setRoundDigit(2);
			       //out.println(miscellaneousBean.getFloatRoundStr(backLPLRate)+"%");	
				  
				   float backLPLRateQty = backProdLPLRate*100; //backLPLRate;
				   try
				   {
			        String strBackLPLRate = nf2.format(backProdLPLRate*100);
				    bd2 = new java.math.BigDecimal(strBackLPLRate);
				    java.math.BigDecimal strBackLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    backLPLRateQty = strBackLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back LPL Rate "+e.getMessage());
                   }				   
				   out.println(backLPLRateQty+"%");
				  		  
			  %></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(backPPHRate)
			  
			       float backPPHRateQty = backPPHRate;
				   try
				   {
			        String strBackPPHRate = nf2.format(backPPHRateQty);
				    bd2 = new java.math.BigDecimal(strBackPPHRate);
				    java.math.BigDecimal strBackPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    backPPHRateQty = strBackPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Qty Back PPH Value "+e.getMessage());
                   }				   
				   out.println(backPPHRateQty);
			  
			  %></font></div></td>     
     </tr>
	  <%
	     float sumBeginBalTotal = 0, sumQtyScrapTotal=0, sumEndBalTotal=0, sumWorkTimeTotal=0;
		 float sumReceiptTotal=0;
		 float sumLPLRate=0, sumPPHRate=0;
		 
		 sumBeginBalTotal=frontBeginBalTotal+backBeginBalTotal;
		 sumQtyScrapTotal=frontQtyScrapTotal+backQtyScrapTotal;
		 sumEndBalTotal=frontEndBalTotal+backEndBalTotal;
		 sumWorkTimeTotal=frontWorkTimeTotal+backWorkTimeTotal;
		 sumReceiptTotal=(backPackComplete-sumBeginBalTotal+sumQtyScrapTotal+sumEndBalTotal); //全段(產出-期初+耗損+期末)=全段接收
         if (partNo.equals("4040-01")) 
		 {
		    //out.println("backPackComplete="+backPackComplete);
			//out.println("sumBeginBalTotal="+sumBeginBalTotal);
			//out.println("sumQtyScrapTotal="+sumQtyScrapTotal);
			//out.println("sumEndBalTotal="+sumEndBalTotal);
		 }
		 // 計算全段的良品率
		 sumLPLRate=backPackComplete/(sumBeginBalTotal+sumReceiptTotal-sumEndBalTotal)*100;  //公式:產出/(期出+接收-期末)=良率
		 // 計算全段的產出率
		 sumPPHRate=(backPackComplete/sumWorkTimeTotal)*1; 
		 
		 
	  %>
	 <tr><!--% 全段的加總 %--> 
      <td height="23" colspan="2">全段</td> 
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <%
			    //miscellaneousBean.setRoundDigit(3);
			   // out.println(miscellaneousBean.getFloatRoundStr(sumBeginBalTotal));		
				
				   float sumBeginBalTotalQty = sumBeginBalTotal;
				   try
				   {
			        String strSumBeginBalTotal = nf.format(sumBeginBalTotalQty);
				    bd = new java.math.BigDecimal(strSumBeginBalTotal);
				    java.math.BigDecimal strSumBeginBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumBeginBalTotalQty = strSumBeginBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Begin Balance Qty "+e.getMessage());
                   }				   
				   out.println(sumBeginBalTotalQty);
				   	  
			  %></font></div></td>
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(sumReceiptTotal)
			  
			       float sumReceiptTotalQty = sumReceiptTotal;
				   try
				   {
			        String strSumReceiptTotal = nf.format(sumReceiptTotalQty);
				    bd = new java.math.BigDecimal(strSumReceiptTotal);
				    java.math.BigDecimal strSumReceiptTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumReceiptTotalQty = strSumReceiptTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Begin Balance Qty "+e.getMessage());
                   }				   
				   out.println(sumReceiptTotalQty);
			  
			  %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(backPackComplete)
			  
			       float sumBackPackCompleteQty = backPackComplete;
				   try
				   {
			        String strSumBackPackComplete = nf.format(sumBackPackCompleteQty);
				    bd = new java.math.BigDecimal(strSumBackPackComplete);
				    java.math.BigDecimal strSumBackPackCompleteQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumBackPackCompleteQty = strSumBackPackCompleteQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum PackComplete Qty "+e.getMessage());
                   }				   
				   out.println(sumBackPackCompleteQty);
			  %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(sumQtyScrapTotal)
			  
			       float sumQtyScrapTotalQty = sumQtyScrapTotal;
				   try
				   {
			        String strSumQtyScrapTotal = nf.format(sumQtyScrapTotalQty);
				    bd = new java.math.BigDecimal(strSumQtyScrapTotal);
				    java.math.BigDecimal strSumQtyScrapTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumQtyScrapTotalQty = strSumQtyScrapTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Scrap Total Qty "+e.getMessage());
                   }				   
				   out.println(sumQtyScrapTotalQty);
			  
			  %></font></div></td>	  
	  <td nowrap><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(sumEndBalTotal)
			  
			       float sumEndBalTotalQty = sumEndBalTotal;
				   try
				   {
			        String strSumEndBalTotal = nf.format(sumEndBalTotalQty);
				    bd = new java.math.BigDecimal(strSumEndBalTotal);
				    java.math.BigDecimal strSumEndBalTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumEndBalTotalQty = strSumEndBalTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum Scrap Total Qty "+e.getMessage());
                   }				   
				   out.println(sumEndBalTotalQty);
			  %></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial">
	          <%//miscellaneousBean.getFloatRoundStr(sumWorkTimeTotal)
			  
			  
			       float sumWorkTimeTotalQty = sumWorkTimeTotal;
				   try
				   {
			        String strSumWorkTimeTotal = nf.format(sumWorkTimeTotalQty);
				    bd = new java.math.BigDecimal(strSumWorkTimeTotal);
				    java.math.BigDecimal strSumWorkTimeTotalQty = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
				    sumWorkTimeTotalQty = strSumWorkTimeTotalQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum WorkTIme Total Qty "+e.getMessage());
                   }				   
				   out.println(sumWorkTimeTotalQty);
			  %></font></div></td>	  
	  <td ><div align="right"><font color="#006666" face="Arial">
	        <%
               //miscellaneousBean.setRoundDigit(2);  
 	           //out.println(miscellaneousBean.getFloatRoundStr(sumLPLRate)+"%");
			   
			       float sumLPLRateQty = frontLPLRateQty*backLPLRateQty/100; //sumLPLRate; // 2007/03/22 更改為全段良率 = 前段 * 後段/100
				   try
				   {
			        String strSumLPLRate = nf2.format(sumLPLRateQty);
				    bd2 = new java.math.BigDecimal(strSumLPLRate);
				    java.math.BigDecimal strSumLPLRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    sumLPLRateQty = strSumLPLRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum LPL Rate Qty "+e.getMessage());
                   }				   
				   out.println(sumLPLRateQty+"%");
			   
		    %></font></div></td>
      <td ><div align="right"><font color="#006666" face="Arial">
	        <%//miscellaneousBean.getFloatRoundStr(sumPPHRate)
			
			       float sumPPHRateQty = sumPPHRate;
				   try
				   {
			        String strSumPPHRate = nf2.format(sumPPHRateQty);
				    bd2 = new java.math.BigDecimal(strSumPPHRate);
				    java.math.BigDecimal strSumPPHRateQty = bd2.setScale(2, java.math.BigDecimal.ROUND_HALF_UP);
				    sumPPHRateQty = strSumPPHRateQty.floatValue();				    
				   } //end of try
                   catch (NumberFormatException e)
                   {
                    System.out.println("Exception: Sum PPH Value Qty "+e.getMessage());
                   }				   
				   out.println(sumLPLRateQty);
			
			%></font></div></td>     
     </tr>
  </table><!--% 站別的Group %-->  
  <hr> 
  </td>    
  </tr>  
    <%
         rs1__index++;
         rs_hasDataTC = rsTC.next();
         counta = rs1__index ;
       }  // End of While 
    %>
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
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
<%
rsTC.close();
statementTC.close();
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>

