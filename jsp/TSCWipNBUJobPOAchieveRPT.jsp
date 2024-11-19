<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean,MiscellaneousBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function setSubmit2(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function subWindowCustInfoFind(custNo,custName)
{ 
   if (event.keyCode==13)
   {    
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
   }	
}
function setCustInfoFind(custNo,custName)
{      
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
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
<title>WIP Job / PO Achieve Report</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
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
int rs1__numRows = 1000;
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
      if (dateSetBegin==null && YearFr==null && MonthFr==null && DayFr==null) 
	  {
	    dateBean.setAdjDate(-4);
	    dateSetBegin = dateBean.getYearMonthDay();	    
        dateBean.setAdjDate(4);
		YearFr = dateSetBegin.substring(0,4);
		MonthFr = dateSetBegin.substring(4,6);
		DayFr = dateSetBegin.substring(6,8);
	  }
	  else dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null && YearTo==null && MonthTo==null && DayTo==null) 
	  {   
	    dateSetEnd = dateBean.getYearMonthDay();	 
      }
	  else dateSetEnd=YearTo+MonthTo+DayTo; 


String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");

String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");

String factory=request.getParameter("FACTORY"); // 生產廠區
  if (factory==null || factory.equals("")) factory = "NBU";
  
 // out.println("factory="+factory);
  
  String vendorName=request.getParameter("VENDORNAME");

  String tscPackage=request.getParameter("TSCPACKAGE");
  String salesPerson=request.getParameter("SALESPERSON");
  String wipJobName=request.getParameter("WIPJOBNAME");
  //String UserPlanCenterNo=request.getParameter("USERPLANCENTERNO");  
  String prodDesc=request.getParameter("PRODDESC");
  
  String listMode=request.getParameter("LISTMODE");  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  String sqlDtl = "";
   
  if (wipJobName==null || wipJobName.equals("")) wipJobName="";
  if (prodDesc==null || prodDesc.equals("")) prodDesc="";
  if (vendorName==null || vendorName.equals("")) vendorName=""; 
  if (tscPackage==null || tscPackage.equals("")) tscPackage="";   

  if ((organizationId==null || organizationId.equals("")) && factory.equals("NBU"))
  {  
    organizationId="49"; // I1 Semiconductor
  } //I1 (Semiconductor)
  else {
         organizationId="326,327";
       }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (listMode==null) listMode = "TRUE";
  
  int iDetailRowCount = 0;

    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else {
	         if (factory.equals("NBU"))
			 { 
	           clientID = "41"; // TSC Semi
			 } else {
			         clientID = "325";  // YEW   
			        }
	      }
  
     CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機  325 --> 事務機  */
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
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>  
<FORM ACTION="../jsp/TSCWipNBUJobPOAchieveRPT.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>WIP <jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgIssDelivery"/><jsp:getProperty name="rPH" property="pgDetailRpt"/></strong></font>
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
{
    sSql = "SELECT WDJ.WIP_ENTITY_ID, WDJ.WIP_ENTITY_NAME, WDJ.STATUS_TYPE_DISP , to_char(WDJ.DATE_RELEASED,'YYYY/MM/DD') as LTDATE,MSI.SEGMENT1,MSI.DESCRIPTION, MIC.SEGMENT1 as TSC_PACKAGE, "+
		        " to_char(WDJ.SCHEDULED_START_DATE,'YYYY/MM/DD') as RELEASE_DATE, to_char(WDJ.SCHEDULED_COMPLETION_DATE,'YYYY/MM/DD') as JOB_DATE, WDJ.START_QUANTITY, MIC.SEGMENT1, "+ 
				" PRH.SEGMENT1 AS PR,PRL.ITEM_DESCRIPTION,PRL.ITEM_ID,to_char(PRL.NEED_BY_DATE,'YYYY/MM/DD') as NEED_DATE, PRL.WIP_ENTITY_ID, "+  
				" POH.SEGMENT1 AS PO,POH.PO_HEADER_ID,POH.VENDOR_ID,POL.PO_LINE_ID,POL.LIST_PRICE_PER_UNIT, POL.QUANTITY, VND.VENDOR_NAME "+      		 
		  "  FROM WIP_DISCRETE_JOBS_V WDJ, MTL_SYSTEM_ITEMS  MSI , "+
		    "     MTL_ITEM_CATEGORIES_V MIC, "+
			"     PO_REQUISITION_HEADERS_ALL PRH, PO_REQUISITION_LINES_ALL PRL, "+	
			"     PO_LINE_LOCATIONS_ALL PLL, "+	
			"     PO_HEADERS_ALL POH,  PO_LINES_ALL POL, PO_VENDORS VND ";			
   sSqlCNT = "SELECT count(DISTINCT WDJ.WIP_ENTITY_NAME) as CaseCount "+
             "  FROM WIP_DISCRETE_JOBS_V WDJ, MTL_SYSTEM_ITEMS  MSI , "+
		       "     MTL_ITEM_CATEGORIES_V MIC, "+
			   "     PO_REQUISITION_HEADERS_ALL PRH, PO_REQUISITION_LINES_ALL PRL, "+		
			   "     PO_LINE_LOCATIONS_ALL PLL, "+	
			   "     PO_HEADERS_ALL POH,  PO_LINES_ALL POL, PO_VENDORS VND ";	
   sWhere =  "WHERE WDJ.PRIMARY_ITEM_ID = MSI.INVENTORY_ITEM_ID  AND WDJ.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+					
			 " AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID  "+
			 " AND PRH.REQUISITION_HEADER_ID =PRL.REQUISITION_HEADER_ID "+
			 " AND POL.PO_LINE_ID = PLL.PO_LINE_ID(+) AND POH.PO_HEADER_ID = PLL.PO_HEADER_ID "+
			 " AND POH.PO_HEADER_ID = POL.PO_HEADER_ID "+
			 " AND POH.ORG_ID = POL.ORG_ID "+
			 //" AND POH.AGENT_ID= PRH.PREPARER_ID "+
			 " AND POL.ITEM_ID = PRL.ITEM_ID AND POH.VENDOR_ID = VND.VENDOR_ID "+
			 " AND WDJ.START_QUANTITY = POL.QUANTITY "+  // 工單數量 = 採購單數量
			 //" AND WDJ.QUANTITY_COMPLETED = PLL.QUANTITY_ACCEPTED "+ // 工單完工數 = 驗收入庫數
			 //" AND WDJ.QUANTITY_COMPLETED = PLL.QUANTITY_RECEIVED "+ // 工單完工數 = 暫收數
			 " AND WDJ.ORGANIZATION_ID in ("+organizationId+") "+ // 限定選擇的OrganizationId
			 " AND PRL.CREATION_DATE>= WDJ.CREATION_DATE "+ 
			 " AND PRH.INTERFACE_SOURCE_CODE ='WIP' AND PRH.ORG_ID = PRL.ORG_ID AND PRL.WIP_ENTITY_ID=	WDJ.WIP_ENTITY_ID "+
			 " AND MIC.CATEGORY_SET_NAME ='TSC_Package' AND to_char(SCHEDULED_START_DATE,'YYYYMMDD') ='"+dateBean.getYearMonthDay()+"' "; 
   sOrder = " ORDER BY WDJ.WIP_ENTITY_NAME ";  
   
   SWHERECOND = sWhere;
   sSql = sSql + sWhere + sOrder;
   sSqlCNT = sSqlCNT + sWhere;   
   //out.println("sSql="+ sSql);   
   
   try
        {		
         Statement statement1=con.createStatement();
         ResultSet rs1=statement1.executeQuery(sSqlCNT);
		 if (rs1.next())
		 {
		   CaseCount = rs1.getInt("CaseCount");
		   CaseCountORG = rs1.getInt("CaseCount");
		   
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
   sSql = "SELECT WDJ.WIP_ENTITY_ID, WDJ.WIP_ENTITY_NAME, WDJ.STATUS_TYPE_DISP , to_char(WDJ.DATE_RELEASED,'YYYY/MM/DD') as LTDATE,MSI.SEGMENT1,MSI.DESCRIPTION, MIC.SEGMENT1 as TSC_PACKAGE, "+
		        " to_char(WDJ.SCHEDULED_START_DATE,'YYYY/MM/DD') as RELEASE_DATE, to_char(WDJ.SCHEDULED_COMPLETION_DATE,'YYYY/MM/DD') as JOB_DATE, WDJ.START_QUANTITY, MIC.SEGMENT1, "+ 
				" PRH.SEGMENT1 AS PR,PRL.ITEM_DESCRIPTION,PRL.ITEM_ID,to_char(PRL.NEED_BY_DATE,'YYYY/MM/DD') as NEED_DATE, PRL.WIP_ENTITY_ID, "+  
				" POH.SEGMENT1 AS PO,POH.PO_HEADER_ID,POH.VENDOR_ID,POL.PO_LINE_ID,POL.LIST_PRICE_PER_UNIT, POL.QUANTITY, VND.VENDOR_NAME "+      		 
		  "  FROM WIP_DISCRETE_JOBS_V WDJ, MTL_SYSTEM_ITEMS  MSI , "+
		    "     MTL_ITEM_CATEGORIES_V MIC, "+
			"     PO_REQUISITION_HEADERS_ALL PRH, PO_REQUISITION_LINES_ALL PRL, "+	
			"     PO_LINE_LOCATIONS_ALL PLL, "+	
			"     PO_HEADERS_ALL POH,  PO_LINES_ALL POL, PO_VENDORS VND ";	
   sSqlCNT = "SELECT count(DISTINCT WDJ.WIP_ENTITY_NAME) as CaseCount "+
             "  FROM WIP_DISCRETE_JOBS_V WDJ, MTL_SYSTEM_ITEMS  MSI , "+
		       "     MTL_ITEM_CATEGORIES_V MIC, "+
			   "     PO_REQUISITION_HEADERS_ALL PRH, PO_REQUISITION_LINES_ALL PRL, "+		
			   "     PO_LINE_LOCATIONS_ALL PLL, "+	
			   "     PO_HEADERS_ALL POH,  PO_LINES_ALL POL, PO_VENDORS VND ";	
   sWhere =  "WHERE WDJ.PRIMARY_ITEM_ID = MSI.INVENTORY_ITEM_ID AND WDJ.ORGANIZATION_ID = MSI.ORGANIZATION_ID "+				
			 " AND MSI.INVENTORY_ITEM_ID = MIC.INVENTORY_ITEM_ID AND MSI.ORGANIZATION_ID = MIC.ORGANIZATION_ID "+
			 " AND PRH.REQUISITION_HEADER_ID =PRL.REQUISITION_HEADER_ID "+
			 " AND POL.PO_LINE_ID = PLL.PO_LINE_ID(+) AND POH.PO_HEADER_ID = PLL.PO_HEADER_ID "+  // Outer 收料入庫的Table
			 " AND POH.PO_HEADER_ID = POL.PO_HEADER_ID "+
			 " AND POH.ORG_ID = POL.ORG_ID "+
			 // " AND POH.AGENT_ID= PRH.PREPARER_ID "+
			 " AND POL.ITEM_ID = PRL.ITEM_ID AND POH.VENDOR_ID = VND.VENDOR_ID "+
			 " AND WDJ.START_QUANTITY = POL.QUANTITY "+  // 工單數量 = 採購單數量
			// " AND WDJ.QUANTITY_COMPLETED = PLL.QUANTITY_ACCEPTED "+ // 工單完工數 = 驗收入庫數
			// " AND WDJ.QUANTITY_COMPLETED = PLL.QUANTITY_RECEIVED "+ // 工單完工數 = 暫收數
			 //" AND POL.CREATION_DATE >= PRL.CREATION_DATE "+
			 //" AND PRL.CREATION_DATE>= WDJ.CREATION_DATE "+  // 轉請購單日期 >= WIP 工單開單日
			 " AND PRH.INTERFACE_SOURCE_CODE ='WIP' AND PRH.ORG_ID = PRL.ORG_ID AND PRL.WIP_ENTITY_ID=WDJ.WIP_ENTITY_ID "+
			 " AND MIC.CATEGORY_SET_NAME ='TSC_Package' "; 
   sOrder = " ORDER BY WDJ.WIP_ENTITY_NAME ";  
			 
   if (wipJobName==null || wipJobName.equals("")) { sWhere=sWhere+" "; }
   else {sWhere=sWhere+" and WDJ.WIP_ENTITY_NAME ='"+wipJobName+"'"; }
  
   if (prodDesc==null || prodDesc.equals(""))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and MSI.DESCRIPTION ='"+prodDesc+"'"; }     
  
   if (vendorName!=null && !vendorName.equals("")) { sWhere=sWhere+" and VND.VENDOR_NAME like'%"+vendorName+"%'";	} 
   
   if (tscPackage!=null && !tscPackage.equals("")) { sWhere=sWhere+" and MIC.SEGMENT1 ='"+tscPackage+"'"; }
    
	// out.print("aaaaaaaaaDayFr="+DayFr+",DayTo="+DayTo+", salesAreaNo="+salesAreaNo+"......");
   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and to_char(WDJ.SCHEDULED_START_DATE,'YYYYMMDD') >="+"'"+dateSetBegin+"'";
   if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and to_char(WDJ.SCHEDULED_START_DATE,'YYYYMMDD') >= "+"'"+dateSetBegin+"'"+" AND to_char(WDJ.SCHEDULED_START_DATE,'YYYYMMDD') <= "+"'"+dateSetEnd+"'";  
      
   if (organizationId==null || organizationId.equals("")) { sWhere=sWhere+" AND WDJ.ORGANIZATION_ID in ("+organizationId+") "; } // 限定選擇的OrganizationId;
   
  SWHERECOND = sWhere;
  sSql = sSql + sWhere + sOrder;
  sSqlCNT = sSqlCNT + sWhere;
  //out.println("sSql="+sSql);    
   
   String sqlOrgCnt = "select count(DISTINCT WDJ.WIP_ENTITY_NAME) as CaseCountORG "+
                       "  FROM WIP_DISCRETE_JOBS_V WDJ, MTL_SYSTEM_ITEMS  MSI , "+
		               "       MTL_ITEM_CATEGORIES_V MIC, "+
			           "       PO_REQUISITION_HEADERS_ALL PRH, PO_REQUISITION_LINES_ALL PRL, "+	
					   "       PO_LINE_LOCATIONS_ALL PLL, "+	
			           "       PO_HEADERS_ALL POH,  PO_LINES_ALL POL, PO_VENDORS VND ";	
   sqlOrgCnt = sqlOrgCnt + sWhere;
   //out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
     CaseCountORG = rs2.getInt("CaseCountORG");     
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
          out.println("Exception:"+e.getMessage());
        }
   
}
// 準備予維修方式使用的Statement Con //
//Statement stateAct=con.createStatement();
//out.println(sSql);
sqlGlobal = sSql;
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
  <table cellSpacing='0' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>     	 	 
     <tr>
	   <td><font color="#006666"><strong>Manufactory</strong></font> 
	   </td>
	   <td colspan="3">
	       <select name="FACTORY">
	         <option value="NBU" <% if (factory.equals("NBU")) out.println("selected"); %>>NBU事業處</option>
	         <option value="YEW" <% if (factory.equals("YEW")) out.println("selected"); %>>山東陽信廠</option>		     
		   </select>
	   </td>
	 </tr>
     <tr>
	    <td width="13%" colspan="1" nowrap><font color="#006666"><strong>WIP No.</strong></font>         
        </td> 
		<td width="39%">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
		    <input type="text" name="WIPJOBNAME" value="<%=wipJobName%>">
		   </div>
		</td> 
		<td width="19%">
		   <div align="left">
		   <font color="#006666"><strong>Assembly Device</strong></font>
		   </div>
		</td>
		<td width="29%">   
		  <div align="left">
		   <font color="#006666"><strong>
		     <input type="text" name="PRODDESC" value="<%=prodDesc%>">
		   </strong></font>		   
		  </div>	   
		</td>   
	 </tr>	
	 <tr>
	    <td width="13%" colspan="1" nowrap><font color="#006666"><strong>Vendor Name</strong></font>         
        </td> 
		<td width="39%">
		   <div align="left">
		   <font color="#006666"><strong><input type="text" name="VENDORNAME" value="<%=vendorName%>"></strong></font>
		   <%
		       /*
			   try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select MANUFACTORY_NO, MANUFACTORY_NAME as PRODMANUFACTORY "+
			                        "from ORADDMAN.TSPROD_MANUFACTORY "+
			                        "where MANUFACTORY_NO > 0 "+																  
								     "order by MANUFACTORY_NO "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxAllBean.setRs(rsGetP);
		           comboBoxAllBean.setSelection(prodManufactory);
	               comboBoxAllBean.setFieldName("PRODMANUFACTORY");					     
                   out.println(comboBoxAllBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
				*/
		   %>
		   </div>
		</td> 
		<td width="19%">
		   <div align="left">
		   <font color="#006666"><strong>Package</strong></font>
		   </div>
		</td>
		<td width="29%"> <input type="text" name="TSCPACKAGE" value="<%=tscPackage%>">  
		   <%
		   /*
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP=null;				      									  
				   String sqlGetP = "select STATUSID, STATUSNAME||'-'||STATUSDESC as STATUS "+
			                        "from ORADDMAN.TSWFSTATUS "+
			                        "where STATUSID <> '006' "+																  
								     "order by STATUSID "; 		  
                   rsGetP=stateGetP.executeQuery(sqlGetP);
				   comboBoxAllBean.setRs(rsGetP);
		           comboBoxAllBean.setSelection(status);
	               comboBoxAllBean.setFieldName("STATUS");					     
                   out.println(comboBoxAllBean.getRsString());				
					           
				    stateGetP.close();		  		  
		            rsGetP.close();
	            } //end of try		 
                catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		*/		
		   %>	   
		</td>   
	 </tr>	  
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666"><strong>Job Start Date From</strong></font>
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearFr==null)
		  {
		    CurrYear=dateBean.getYearString();

		    arrayComboBoxBean.setSelection(CurrYear);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearFr);
		  }
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <%
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
        <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font>
        <font color="#CC3366" size="2" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
       <font color="#006666"><strong>To </strong></font>
        <%
		  String CurrYearTo = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearTo==null)
		  {
		    CurrYearTo=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYearTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearTo);
		  }
	      arrayComboBoxBean.setFieldName("YEARTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
       <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
       <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>  
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSCWipNBUJobPOAchieveRPT.jsp")' > 			 
	</td>
   </tr>
  </table>  
<%
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
 
%>
  <table width="100%" border="0" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#D8DEA9">
	  <td width="4%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td> 	               	  
	  <td width="5%" nowrap><div align="center"><font color="#006666">WIP NO</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666">Status</font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666">Device</font></div></td>
      <td width="10%" nowrap><div align="center"><font color="#006666">Assembly house</font></div></td>
	  <td width="4%" height="22" nowrap><div align="center"><font color="#006666">PR</font></div></td>  
	  <td width="4%" height="22" nowrap><div align="center"><font color="#006666">PO</font></div></td> 
	  <td width="4%" height="22" nowrap><div align="center"><font color="#CC0033">PRICE</font></div></td>  
	  <td width="7%" nowrap><div align="center"><font color="#006666">Dice type</font></div></td>
	  <td width="6%" nowrap><div align="center"><font color="#006666">Date Code</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666">Package</font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">Release Date</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666">L/T</font></div></td>    
	  <td width="6%" nowrap><div align="center"><font color="#006666">Issue_Q'ty</font></div></td> 
	  <td width="10%" nowrap><div align="center"><font color="#006666">Accumulative Q'ty</font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666">PO Q'ty</font></div></td>   
	  <td width="10%" nowrap><div align="center"><font color="#006666">Received Q'ty</font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666">Remnant Q'ty</font></div></td>         	  
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "FFFFCC";
		   //colorStr = "FFFFFF";
	     }
	    else{
	         colorStr = "#D8DEA9";
			 //colorStr = "#FFFFFF";
		    }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#D8DEA9" width="4%" nowrap><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("WIP_ENTITY_NAME")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td nowrap><div align="center"><font color="#006666"><%=rsTC.getString("WIP_ENTITY_NAME")%></font></div></td>
	  <td nowrap><div align="center"><font color="#006666"><%=rsTC.getString("STATUS_TYPE_DISP")%></font></div></td>     	             
	  <td width="5%" nowrap><div align="center"><font size="2" color="#000099"><%=rsTC.getString("DESCRIPTION")%></font></div></td>
	  <td width="4%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("VENDOR_NAME")%></font></div></td> 
      <td width="10%" nowrap><div align="center"><font size="2" color="#006666">
	          <% out.println(rsTC.getString("PR")); %></font></div>
	  </td>
	  <td width="7%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("PO")%></font></div></td>
	  <td width="7%" nowrap><div align="center"><font color="#006666">
	         <%//=rsTC.getString("LIST_PRICE_PER_UNIT")
			       try
				   {
						   miscellaneousBean.setRoundDigit(3);						   
                           String listPrice = miscellaneousBean.getFloatRoundStr(rsTC.getFloat("LIST_PRICE_PER_UNIT"));
                           out.println("<font color='#CC0033'>"+listPrice+"</font>"); 
				          
				    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }
			 %></font></div></td> 
	  <td width="6%" nowrap><div align="center"><font color="#006666">
	      <%//=rsTC.getString("ITEM_DESCRIPTION")
		     try
			 { 
			     out.println("<table width='100%' border='0' cellpadding='1' cellspacing='0' bordercolorlight='#9999FF' bordercolordark='#FFFF99'>");
			     String sqlWREQ = "SELECT W.INVENTORY_ITEM_ID, W.ITEM_DESCRIPTION FROM WIP_REQUIREMENT_OPERATIONS_V W, MTL_MATERIAL_TRANSACTIONS T WHERE T.INVENTORY_ITEM_ID = W.INVENTORY_ITEM_ID and W.WIP_ENTITY_ID = T.TRANSACTION_SOURCE_ID and W.WIP_ENTITY_ID='"+rsTC.getInt("WIP_ENTITY_ID")+"' ";
				 Statement stateWREQ=con.createStatement();
                 ResultSet rsWREQ=null;				      									  						  
                 rsWREQ=stateWREQ.executeQuery(sqlWREQ);
				 if (rsWREQ.next())
				 { 
				   out.print("<tr>");
				   out.print("<td nowrap><font size=2 color='990000'>"+rsWREQ.getString("ITEM_DESCRIPTION")+"</font></td>");
				   out.print("</tr>");
				 }
				 rsWREQ.close();
				 stateWREQ.close();
				 out.println("</table>");
			 } //end of try
             catch (Exception e)
             {
               out.println("Exception:"+e.getMessage());
             }	
		  %></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#006666"><%="N/A"%></font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("TSC_PACKAGE")%></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("RELEASE_DATE")%></font></div></td> 
	  <td width="6%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("LTDATE")%></font></div></td> 
	  <td width="10%" nowrap><div align="center"><font color="#006666">
	             <%//
				   try
				   {
						   miscellaneousBean.setRoundDigit(3);						   
                           String issQty = miscellaneousBean.getFloatRoundStr(rsTC.getFloat("START_QUANTITY"));
                           out.println(issQty); 
				          
				    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }
				 %></font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">
	          <%
			       try
				   {
						   miscellaneousBean.setRoundDigit(3);						   
                           String accQty = miscellaneousBean.getFloatRoundStr(rsTC.getFloat("START_QUANTITY"));
                           out.println(accQty); 
				          
				    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }
			  %></font></div></td>
	  <td width="10%" nowrap><div align="center"><font color="#006666">
	       <%
		           try
				   {
						   miscellaneousBean.setRoundDigit(3);						   
                           String poQty = miscellaneousBean.getFloatRoundStr(rsTC.getFloat("START_QUANTITY"));
                           out.println(poQty); 
				          
				    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }
		   %></font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666">
	     <%//rsTC.getString("SALESPERSON")
			 float accRecQty = 0;
			 try
			 { 
			     out.println("<table width='100%' border='0' cellpadding='1' cellspacing='0' bordercolorlight='#9999FF' bordercolordark='#FFFF99'>");
			     String sqlRECP = "SELECT TRANSACTION_ID, to_char(TRANSACTION_DATE,'YYYY/MM/DD') as T_DATE,RECEIVER, TRANSACT_QTY  FROM RCV_VRC_TXS_V WHERE PO_HEADER_ID = '"+rsTC.getInt("PO_HEADER_ID")+"' "+
				                  "AND WIP_ENTITY_ID='"+rsTC.getInt("WIP_ENTITY_ID")+"' AND PO_LINE_ID = '"+rsTC.getInt("PO_LINE_ID")+"' "+
								  "AND TRANSACTION_TYPE='DELIVER' ";
								 // "AND TRANSACTION_TYPE='RECEIVE' ";
				 Statement stateRECP=con.createStatement();
                 ResultSet rsRECP=null;				      									  						  
                 rsRECP=stateRECP.executeQuery(sqlRECP);
				 while (rsRECP.next())
				 { 
				   out.print("<tr>");
				   out.print("<td nowrap><font size=2 color='339999'>");
				   //out.print("<A HREF=javaScript:popMenuMsg('"+rsRECP.getString("TRANSACTION_ID")+"') "); out.print(" onMouseOver=window[");out.print("'myTable"+rsRECP.getString("TRANSACTION_ID")+"'].style.display='block'"); out.print(" onMouseOut=window[");out.print("'myTable"+rsRECP.getString("TRANSACTION_ID")+"'].style.display='none'>");out.print(rsRECP.getString("TRANSACT_QTY"));out.println("</A>");
				   //out.println("<table border='0' id='myTable"+rsRECP.getString("TRANSACTION_ID")+"' bgcolor='#FFFFCC' style='display:none'>");
				   //out.print("<tr><td><font size='2' color='#FF9900'>"+rsRECP.getString("T_DATE")+"</font></td></tr>");
				   //out.print("<tr><td><font size='2' color='#FF9900'>"+rsRECP.getString("RECEIVER")+"</font></td></tr>");
				   //out.print("</table>");				   
				   try
				   {
						   miscellaneousBean.setRoundDigit(3);						   
                           String recQty = miscellaneousBean.getFloatRoundStr(rsRECP.getFloat("TRANSACT_QTY"));
                           out.println(recQty); 
				          
				    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }			   
				   out.print("</font></td>");
				   out.print("<td nowrap><font size=2 color='339999'>");				  
				   out.print(rsRECP.getString("T_DATE"));				   
				   out.print("</font></td>");
				   out.print("</tr>");
				   accRecQty = accRecQty + rsRECP.getFloat("TRANSACT_QTY");
				 }
				 rsRECP.close();
				 stateRECP.close();
				 out.println("</table>");
			 } //end of try
             catch (Exception e)
             {
               out.println("Exception:"+e.getMessage());
             }			 
		  %></font></div></td>  
	  <td width="8%" nowrap><div align="center"><font color="#990000">
	      <%//rsTC.getString("SALESPERSON")
		      float RemPOQty = 0;			 
			  RemPOQty = rsTC.getFloat("START_QUANTITY") - accRecQty;		      
			  try
			  {
				miscellaneousBean.setRoundDigit(3);						   
                String remPOQtyStr = miscellaneousBean.getFloatRoundStr(RemPOQty);
                out.println(remPOQtyStr); 				          
			  } //end of try
              catch (Exception e)
              {
                 out.println("Exception:"+e.getMessage());
              }	
		  
		  %></font></div></td> 	  	                
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#D8DEA9"> 
      <td height="23" colspan="18" ><font color="#006666"><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>	 
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="DATESETBEGIN" type="hidden" value="<%=dateSetBegin%>">
<input name="DATESETEND" type="hidden" value="<%=dateSetEnd%>">
<input name="PRODDESC" type="hidden" value="<%=prodDesc%>">
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveFirst%>"><jsp:getProperty name="rPH" property="pgFirst"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_movePrev%>"><jsp:getProperty name="rPH" property="pgPrevious"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveNext%>"><jsp:getProperty name="rPH" property="pgNext"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#003366"><strong>[<A HREF="<%=MM_moveLast%>"><jsp:getProperty name="rPH" property="pgLast"/><jsp:getProperty name="rPH" property="pgPage"/></A>]</strong></font></pre>
      </div></td>
  </tr>
</table>

<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
<%
rsTC.close();
statementTC.close();
%>


