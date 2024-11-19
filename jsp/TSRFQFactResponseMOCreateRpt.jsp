<!-- 20150123 Peggy,修正客戶品號顯示應抓raddman.tsdelivery_notice_detail.ordered_item-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
<title>Oracle Add On System Information Query</title>
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
	//dateBean.setAdjDate(-4);
	//dateSetBegin = dateBean.getYearMonthDay();	    
    //dateBean.setAdjDate(4);
	//YearFr = dateSetBegin.substring(0,4);
	//MonthFr = dateSetBegin.substring(4,6);
	//DayFr = dateSetBegin.substring(6,8);
	dateSetBegin = "";
	YearFr = "--";
	MonthFr = "--";
	DayFr = "--";
}
else dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
if (dateSetEnd==null && YearTo==null && MonthTo==null && DayTo==null) 
{   
	dateSetEnd  = "";
	//dateSetEnd = dateBean.getYearMonthDay();	 
}
else dateSetEnd=YearTo+MonthTo+DayTo; 

//add by Peggy 20120222,add 業務開單日期查詢條件
String CdateSetBegin=request.getParameter("CDATESETBEGIN");
String CdateSetEnd=request.getParameter("CDATESETEND");
String CYearFr=request.getParameter("CYEARFR");
String CMonthFr=request.getParameter("CMONTHFR");
String CDayFr=request.getParameter("CDAYFR");
if (CdateSetBegin==null && CYearFr==null && CMonthFr==null && CDayFr==null) 
{
	dateBean.setAdjDate(-4);
	CdateSetBegin = dateBean.getYearMonthDay();	    
    dateBean.setAdjDate(4);
	CYearFr = CdateSetBegin.substring(0,4);
	CMonthFr = CdateSetBegin.substring(4,6);
	CDayFr = CdateSetBegin.substring(6,8);
}
else
{ 
	CdateSetBegin=CYearFr+CMonthFr+CDayFr;  
	if (CdateSetBegin.equals("------")) CdateSetBegin="";
}

String CYearTo=request.getParameter("CYEARTO");
String CMonthTo=request.getParameter("CMONTHTO");
String CDayTo=request.getParameter("CDAYTO");
if (CdateSetEnd==null && CYearTo==null && CMonthTo==null && CDayTo==null) 
{   
	CdateSetEnd = dateBean.getYearMonthDay();	
	CYearTo= CdateSetEnd.substring(0,4);
	CMonthTo=CdateSetEnd.substring(4,6);
	CDayTo =CdateSetEnd.substring(6,8);
}
else 
{
	CdateSetEnd=CYearTo+CMonthTo+CDayTo;
	if (CdateSetEnd.equals("------")) CdateSetEnd=""; 
}
String NYearFr=request.getParameter("NYEARFR");
if (NYearFr==null) NYearFr="--";
String NMonthFr=request.getParameter("NMONTHFR");
if (NMonthFr==null) NMonthFr="--";
String NDayFr=request.getParameter("NDAYFR");
if (NDayFr==null) NDayFr="--";
String NYearTo=request.getParameter("NYEARTO");
if (NYearTo==null) NYearTo="--";
String NMonthTo=request.getParameter("NMONTHTO");
if (NMonthTo==null) NMonthTo="--";
String NDayTo=request.getParameter("NDAYTO");
if (NDayTo==null) NDayTo="--";

String owner=request.getParameter("OWNER");
String objectType=request.getParameter("OBJECTTYPE");
String spanning=request.getParameter("SPANNING");
String dnDocNoSet=request.getParameter("DNDOCNOSET");
String invItem=request.getParameter("INVITEM");
String dnDocNo=request.getParameter("DNDOCNO");
String organizationId=request.getParameter("ORGANIZATION_ID");
String organizationCode=request.getParameter("ORGANIZATION_CODE");
String customerId=request.getParameter("CUSTOMERID");
String customerNo=request.getParameter("CUSTOMERNO");
String customerName=request.getParameter("CUSTOMERNAME");
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
String sqlDtl = "";
  
if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //選擇展開的
if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // 使用者輸入的
if (customerId==null || customerId.equals("")) customerId="";
if (customerNo==null || customerNo.equals("")) customerNo="";
if (customerName==null || customerName.equals("")) customerName="";
if (custPONo==null || custPONo.equals("")) custPONo="";
if (createdBy==null || createdBy.equals("")) createdBy="";
if (salesPerson==null || salesPerson.equals("")) salesPerson="";
if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="";
if (statusCode==null || statusCode.equals("")) statusCode="";  
if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
if (spanning==null || spanning.equals("")) spanning = "TRUE";
if (listMode==null) listMode = "TRUE";
int iDetailRowCount = 0;

// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
String clientID = "";
if (organizationId=="46" || organizationId.equals("46"))
{  
	clientID = "42"; 
}
else if (organizationId=="326" || organizationId.equals("326"))
{  
	clientID = "325"; 
}
else 
{ 
	clientID = "41";
}
  
//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");	 
cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
cs1.execute();
cs1.close();
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
<FORM ACTION="../jsp/TSRFQFactResponseMOCreateRpt.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgFactoryResponse"/><jsp:getProperty name="rPH" property="pgWith"/><jsp:getProperty name="rPH" property="pgOrdCreate"/><jsp:getProperty name="rPH" property="pgDetailRpt"/></strong></font>

<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
sWhereGP = " and c.DNDOCNO IS NOT NULL ";
workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */
//if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
//modify by Peggy 2012022,增加業務開單日判斷
if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")) && (CdateSetBegin==null || CdateSetBegin.equals("")) && (CdateSetEnd==null || CdateSetEnd.equals("")))
{
	sSql = "select DISTINCT c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+
          //"TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'),"+
		  "       b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  "       c.CREATED_BY, c.SALESPERSON, c.REQREASON, count(DISTINCT  d.line_no) as MAXLINE, f.SDRQCOUNT "+
          //"a.ASSIGN_FACTORY,"+"d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, c.REMARK "+
		  "  from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, "+
		  "       ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
		  " 	  (select d1.DNDOCNO, sum(decode(d1.SDRQ_EXCEED,'Y',1,0)) as SDRQCOUNT "+ //計算四日過期Line的筆數
          "          from ORADDMAN.TSDELIVERY_NOTICE_DETAIL d1 "+
          "         group by d1.DNDOCNO ) f ";
			   //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   	sSqlCNT = "select count(DISTINCT c.DNDOCNO) as CaseCount "+
             "  from ORADDMAN.TSSALES_AREA b, "+
		     "       ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
					//"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   	sWhere =  "where c.DNDOCNO = d.DNDOCNO "+
			 "  and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			 // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "  and b.LOCALE='"+locale+"' "+
			 "  and b.SALES_AREA_NO=c.TSAREANO ";
   	sWhereSDRQ = "  and f.DNDOCNO = d.DNDOCNO ";
   	havingGrp = "group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		                "b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
			            "c.CREATED_BY, c.SALESPERSON, c.REQREASON ";               
   	havingGrpSDRQ = " ,f.SDRQCOUNT ";
   	sOrder = "order by c.DNDOCNO";
   	//TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   	if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
	{
		sWhere+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
	}
	   
   	//add by Peggy 20120413
	if (salesAreaNo != null && !salesAreaNo.equals("--") && !salesAreaNo.equals(""))
	{
		sWhere+=" and c.TSAREANO ='" +salesAreaNo+"'";  
	}
	if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
	{
		sWhere+= " and substr(d.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
	}
	if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
	{
  		sWhere+= " and substr(d.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
	}
	if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("PRD_PM")>=0)  //add by Peggy 20210609
	{
		sWhere+=" and d.TSC_PROD_GROUP in ('PRD','PRD-Subcon')";  	
	}	
	  
   	SWHERECOND = sWhere + sWhereGP + havingGrp;
   	sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   	sSqlCNT = sSqlCNT + sWhere + sWhereGP;   
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
	sSql = "select DISTINCT c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+
          //"TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS'),"+
		  "       b.ALCHNAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  "       c.CREATED_BY, c.SALESPERSON, c.REQREASON, count(DISTINCT d.line_no) as MAXLINE, f.SDRQCOUNT "+
          //"a.ASSIGN_FACTORY,"+"d.ASSIGN_MANUFACT ||'-' ||e.MANUFACTORY_NAME, c.REMARK "+
		  "  from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, "+
		  "       ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
		  " 	  (select d1.DNDOCNO, sum(decode(d1.SDRQ_EXCEED,'Y',1,0)) as SDRQCOUNT "+ //計算四日過期Line的筆數
          "          from ORADDMAN.TSDELIVERY_NOTICE_DETAIL d1 "+
          "         group by d1.DNDOCNO ) f ";
			   //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   	sSqlCNT = "select count(DISTINCT c.DNDOCNO) as CaseCount "+
                  "from ORADDMAN.TSSALES_AREA b, "+
		          "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
				  //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   	sWhere =  "where c.DNDOCNO = d.DNDOCNO "+
             //"and d.LINE_NO = f.LINE_NO "+
			 "  and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
			 // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
			 "  and b.LOCALE='"+locale+"' "+
			 "  and b.SALES_AREA_NO=c.TSAREANO ";
   	sWhereSDRQ = "  and f.DNDOCNO = d.DNDOCNO ";
			 
   	if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
	{
		sWhere+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
	}
  
	if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
	{
		sWhere+= " and substr(d.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
	}
	if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
	{
  		sWhere+= " and substr(d.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
	}
	  
   	if (status!=null && !status.equals("--"))  
	{
		if (status.equals("005"))
		{
			sWhere+=" and NVL(d.EDIT_CODE,'') ='R'"; 
		}
		else
		{
			sWhere+=" and d.LSTATUSID ='"+status+"'"; 
		}
	}
   
   	if (statusCode.equals("O")) 
	{ 
		sWhere+=" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  
	} // 只找開單處理中的單據
   	else if (statusCode.equals("C")) 
	{ 
		sWhere+=" and d.LSTATUSID in ('010') ";  
	} // 只找已結案的單據
   	else if (statusCode.equals("A")) 
	{ 
		sWhere+=" and d.LSTATUSID in ('012') ";  
	} // 只找放棄的單據
   //else if (statusCode.equals("P")) { sWhere=sWhere+" and f.ORISTATUSID in ('002','007') ";  }   // 只找企劃處理過的單據 (對應HISTORY 的 ORISTATUSID in ('002','007') )
   //else if (statusCode.equals("F")) { sWhere=sWhere+" and f.ORISTATUSID in ('003','004') ";  } // 只找工廠處理過的單據 (對應HISTORY 的 ORISTATUSID in ('003','004') )
   
   	//add by Peggy 20120413
	if (salesAreaNo != null && !salesAreaNo.equals("--") && !salesAreaNo.equals(""))
	{
		sWhere+=" and c.TSAREANO ='" +salesAreaNo+"'";  
	}
	if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("PRD_PM")>=0)  //add by Peggy 20210609
	{
		sWhere+=" and d.TSC_PROD_GROUP in ('PRD','PRD-Subcon')";  	
	}		
			 
   	havingGrp = " group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		       "          b.ALCHNAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
			   "          c.CREATED_BY, c.SALESPERSON, c.REQREASON ";      
   	havingGrpSDRQ = " ,f.SDRQCOUNT ";  
   	sOrder = "order by c.DNDOCNO";
   	
	
	//if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
   	//if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
	//modify by Peggy 20120221
	String date_where = "";
	if ((!DayFr.equals("--") && !DayFr.equals("00")) && DayTo=="--")
	{
		if (date_where.length() >0) date_where += "or";
		date_where+= " exists (select 1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.ORISTATUSID = '004' and x.ACTIONID = '009' and substr(x.CDATETIME,0,8) >="+"'"+dateSetBegin+"' and x.dndocno=d.dndocno and x.line_no = d.line_no)";
	}
	else  if (!DayFr.equals("--") && !DayTo.equals("--")) 
	{
		if (date_where.length() >0) date_where += "or";
		date_where+= " exists (select 1 from ORADDMAN.TSDELIVERY_DETAIL_HISTORY x where x.ORISTATUSID = '004' and x.ACTIONID = '009' and substr(x.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(x.CDATETIME,0,8) <= "+"'"+dateSetEnd+"'  and x.dndocno=d.dndocno and x.line_no = d.line_no)";  
	}
      
	//add by Peggy 20120222
	if ((CdateSetBegin != null && !CdateSetBegin.equals("")) && (CdateSetEnd==null || CdateSetEnd=="" ))
	{
		if (date_where.length() >0) date_where += "or";
		date_where+= " substr(c.CREATION_DATE,0,8) >="+"'"+CdateSetBegin+"'";
	}
	else if (CdateSetBegin!= null && CdateSetEnd != null && !CdateSetBegin.equals("") && !CdateSetEnd.equals("--")) 
	{
		if (date_where.length() >0) date_where += "or";
		date_where+= " substr(c.CREATION_DATE,0,8) >= '"+CdateSetBegin+"' AND substr(c.CREATION_DATE,0,8) <= '"+CdateSetEnd+"'";
	}
	if (date_where.length() >0) sWhere+= " and ("+date_where+")";
		  
	if (customerId!=null && !customerId.equals("") && !customerId.equals("--")) 
	{ 
		sWhere+=" and c.TSCUSTOMERID ='"+customerId+"'"; 
	}
	else if (dnDocNoSet!=null && !dnDocNoSet.equals("")) 
	{ 
		sWhere+=" and c.dnDocNo ='"+dnDocNoSet+"'"; 
	}
    else if (preOrderType!=null && !preOrderType.equals("--")) 
	{ 
		sWhere+=" and to_char(c.ORDER_TYPE_ID) ='"+preOrderType+"'"; 
	}
    else if (custPONo!=null && !custPONo.equals("")) 
	{ 
		sWhere+=" and c.CUST_PO ='"+custPONo+"'"; 
	}
    else if (salesPerson!=null && !salesPerson.equals("")) 
	{ 
		sWhere+=" and SALESPERSON ='"+salesPerson+"'"; 
	}
    else if (status!=null && !status.equals("--")) 
	{ 
		if (status.equals("005"))
		{
			sWhere+=" and NVL(d.EDIT_CODE,'') ='R'";
		}
		else
		{
			sWhere+=" and d.LSTATUSID ='"+status+"'"; 
		}
	}
    else if (salesOrderNo!=null && !salesOrderNo.equals("")) 
	{  
		sWhere+=" and d.ORDERNO = '"+salesOrderNo+"' ";  
	}
	
	if (createdBy!=null && !createdBy.equals("")) 
	{ 
		sWhere+=" and c.CREATED_BY ='"+createdBy+"'"; 
	}
 
  	SWHERECOND = sWhere+ sWhereGP;
  	sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
  	sSqlCNT = sSqlCNT + sWhere + sWhereGP;
    //out.println("sSql="+sSql);    
   
   	String sqlOrgCnt = "select count(DISTINCT c.DNDOCNO) as CaseCountORG "+
                        "from ORADDMAN.TSSALES_AREA b, "+
		                     "ORADDMAN.TSDELIVERY_NOTICE c, ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
							 //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";
   	sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP + havingGrp;
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
sqlGlobal = sSql;
Statement statementTC=con.createStatement(); 
ResultSet rsTC=statementTC.executeQuery(sSql);
boolean rs_isEmptyTC = !rsTC.next();
boolean rs_hasDataTC = !rs_isEmptyTC;
Object rs_dataTC;  
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables
int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;
if (rs_isEmptyTC) 
{
	rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) 
{
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
if (!MM_paramIsDefined && MM_rsCount != 0) 
{
	//use index parameter if defined, otherwise use offset parameter
  	String r = request.getParameter("index");
  	if (r==null) r = request.getParameter("offset");
  	if (r!=null) MM_offset = Integer.parseInt(r);

  	// if we have a record count, check if we are past the end of the recordset
  	if (MM_rsCount != -1) 
	{
    	if (MM_offset >= MM_rsCount || MM_offset == -1) 
		{  // past end or move last
      		if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        		MM_offset = MM_rsCount - MM_rsCount % MM_size;
      		else
        		MM_offset = MM_rsCount - MM_size;
    	}
  	}

  	//move the cursor to the selected record
  	int i;
  	for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}
  	if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) 
{
	// walk to the end of the display range for this page
  	int i;
  	for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}

  	// if we walked off the end of the recordset, set MM_rsCount and MM_size
  	if (!rs_hasDataTC) 
	{
    	MM_rsCount = i;
    	if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  	}

  	// if we walked off the end, set the offset based on page size
  	if (!rs_hasDataTC && !MM_paramIsDefined) 
	{
    	if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) 
		{ //check if past end or last
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
  	for (i=0; rs_hasDataTC && i < MM_offset; i++) 
	{
    	rs_hasDataTC = MM_rs.next();
  	}
}
// *** Move To Record: update recordset stats

// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) 
{
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
if (request.getQueryString() != null) 
{
	MM_keepURL = '&' + request.getQueryString();
  	for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) 
	{
  		int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    	if (start >= 0 && MM_keepURL.charAt(start) == '&' && MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') 
		{
      		int stop = MM_keepURL.indexOf('&', start + 1);
      		if (stop == -1) stop = MM_keepURL.length();
      		MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    	}
  	}
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) 
{
	java.util.Enumeration items = request.getParameterNames();
  	while (items.hasMoreElements()) 
	{
    	String nextItem = (String)items.nextElement();
    	boolean found = false;
    	for (int i=0; !found && i < MM_removeList.length; i++) 
		{
      		if (MM_removeList[i].equals(nextItem)) found = true;
    	}
    	if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) 
		{
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
  	if (MM_size > 1) 
	{
    	MM_moveParam = "offset=";
    	int start = MM_keepMove.indexOf(MM_moveParam);
    	if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) 
		{
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
  <table cellSpacing='1' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bordercolor="#cccccc">     	 	 
	 <tr>
	    <td width="14%" colspan="1" nowrap><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgProdFactory"/> </strong></font>         
        </td> 
		<td width="25%">
		   <div align="left">
		   <font color="#006666"><strong> </strong></font>
	<%
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
    catch (Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	} 
	%>
	</div>
	</td> 
	<td width="19%" colspan="1" nowrap>
	<font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgSalesArea"/></strong></font>        
	</td> 
	<td width="20%">
	<%		 
	try
    {   
		Statement statement=con.createStatement();
        ResultSet rs=null;	
		String sql = "select distinct SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA where SALES_AREA_NO > 0  order by SALES_AREA_NO";
		//if (UserRoles=="admin" || UserRoles.equals("admin") || UserRoles=="audit" || UserRoles.equals("audit")) 
		//{ 
		//}  
		//else 
		//{  
		//	sql += " and SALES_AREA_NO in (select tssaleareano from oraddman.tsrecperson  where (USERID='"+UserName+"' or USERNAME='"+UserName+"'))";
		//}  
        rs=statement.executeQuery(sql);		           
		comboBoxAllBean.setRs(rs);
		if (salesAreaNo!=null)
		{ 
			comboBoxAllBean.setSelection(salesAreaNo); 
		}
	    comboBoxAllBean.setFieldName("SALESAREANO");	   
        out.println(comboBoxAllBean.getRsString());
		rs.close();   
		statement.close(); 
	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }		   
	%>		
	</td>
	<td width="17%">
	<div align="left">
	<font color="#006666"><strong><jsp:getProperty name="rPH" property="pgRepStatus"/> </strong></font>
	</div>
	</td>
		<td width="22%">   
	<%
	try
    { // 動態去取生產地資訊 						  
		Statement stateGetP=con.createStatement();
        ResultSet rsGetP=null;				      									  
		String sqlGetP = "select UNIQUE STATUSID, STATUSNAME||'-'||STATUSDESC as STATUS "+
			             "from ORADDMAN.TSWFSTATUS a, ORADDMAN.TSWORKFLOW b  "+
			             "where a.STATUSID = b.FROMSTATUSID and b.FORMID = 'TS' and a.STATUSID <> '006' "+	
						 "union all "+
						 "select distinct STATUSID, STATUSNAME||'-'||STATUSDESC as STATUS "+	
						 "from ORADDMAN.TSWFSTATUS a "+
						 "where a.STATUSID ='005'"+ //add status=REJECTED by Peggy 20130610													  
						 "order by STATUSID "; 		  
        rsGetP=stateGetP.executeQuery(sqlGetP);
		comboBoxAllBean.setRs(rsGetP);
		comboBoxAllBean.setSelection(status);
	    comboBoxAllBean.setFieldName("STATUS");					     
        out.println(comboBoxAllBean.getRsString());				
		stateGetP.close();		  		  
		rsGetP.close();
	} //end of try		 
    catch (Exception e) 
	{ 
		out.println("Exception:"+e.getMessage()); 
	} 
	%>	   
		</td>   
	 </tr>	  
     <tr>	    
	   <td nowrap colspan="4"><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgFactoryResponse"/><jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
    <%
	String CurrYear = null;	     		 
	try
    {       
    	//String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012"};
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}	        
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
    <font color="#006666"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
    <%
	String CurrYearTo = null;	     		 
	try
	{       
    	//String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010","2011","2012"};
		//modify by Peggy 20120222  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}		
        arrayComboBoxBean.setArrayString(a);
		if (YearTo==null)
		{
			//CurrYearTo=dateBean.getYearString();
		    //arrayComboBoxBean.setSelection(CurrYearTo);
			arrayComboBoxBean.setSelection("--"); //modify by Peggy 20120223
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
			//CurrMonthTo=dateBean.getMonthString();
		    //arrayComboBoxBean.setSelection(CurrMonthTo);
			arrayComboBoxBean.setSelection("--"); //modify by Peggy 20120223
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
			//CurrDayTo=dateBean.getDayString();
		    //arrayComboBoxBean.setSelection(CurrDayTo);
			arrayComboBoxBean.setSelection("--"); //modify by Peggy 20120223
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
	<td rowspan="3" colspan="2" style="vertical-align:bottom">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSRFQFactResponseMOCreateRpt.jsp")' > 
			<INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit("../jsp/TSRFQFactResponseMO2Excel.jsp")' >  
			<% 
			if (UserRoles.indexOf("admin")>=0 || ((UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && (userProdCenterNo != null && (userProdCenterNo.equals("008")||userProdCenterNo.equals("005")||userProdCenterNo.equals("011")))))
			{
			%>
			<INPUT TYPE="button" value="Excel(For TEW)" onClick='setSubmit("../jsp/TSRFQFactResponseVendorExcel.jsp")' >  
			<%
			}
			%>
	</td>
   </tr>
   <tr>	    
	   <td nowrap colspan="4"><font color="#006666"><strong>業務開單<jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
    <%
	String CCYear = null;	     		 
	try
    {     
		//add by Peggy 20120222  
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
        arrayComboBoxBean.setArrayString(a);
		if (CYearFr==null)
		{
			CCYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CCYear);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(CYearFr);
		}
	    arrayComboBoxBean.setFieldName("CYEARFR");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    <%
	String CCMonth = null;	     		 
	try
    {       
		//add by Peggy 20120222  
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}
        arrayComboBoxBean.setArrayString(b);
		if (CMonthFr==null)
		{
			CCMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CCMonth);
		} 
		else 
		{
			arrayComboBoxBean.setSelection(CMonthFr);
		}
	    arrayComboBoxBean.setFieldName("CMONTHFR");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
   	} //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    <%
	String CCDay = null;	     		 
	try
    {      
		//add by Peggy 20120222  
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
        arrayComboBoxBean.setArrayString(c);
		if (CDayFr==null)
		{
			CCDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CCDay);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(CDayFr);
		}
	    arrayComboBoxBean.setFieldName("CDAYFR");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    <font color="#006666"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
    <%
	String CCYearTo = null;	     		 
	try
	{       
		//add by Peggy 20120222 
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
        arrayComboBoxBean.setArrayString(a);
		if (CYearTo==null)
		{
			CCYearTo=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CCYearTo);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(CYearTo);
		}
	    arrayComboBoxBean.setFieldName("CYEARTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>        
    <%
	String CCMonthTo = null;	     		 
	try
    {       
		//add by Peggy 20120222  
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(b);
		if (CMonthTo==null)
		{
			CCMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CCMonthTo);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(CMonthTo);
		}
	    arrayComboBoxBean.setFieldName("CMONTHTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>        
    <%
	String CCDayTo = null;	     		 
	try
    {       
		//add by Peggy 20120222  
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}			
        arrayComboBoxBean.setArrayString(c);
		if (CDayTo==null)
		{
			CCDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CCDayTo);
		} 
		else 
		{
		    arrayComboBoxBean.setSelection(CDayTo);
		}
	    arrayComboBoxBean.setFieldName("CDAYTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    </td>  
	</tr>   
   <tr>	    
	   <td nowrap colspan="4"><font color="#006666"><strong>業務需求<jsp:getProperty name="rPH" property="pgDateFr"/></strong></font>
    <%
	try
    {     
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
        arrayComboBoxBean.setArrayString(a);
		arrayComboBoxBean.setSelection((NYearFr==null?"":NYearFr));
	    arrayComboBoxBean.setFieldName("NYEARFR");	   
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
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}
        arrayComboBoxBean.setArrayString(b);
		arrayComboBoxBean.setSelection((NMonthFr==null?"":NMonthFr));
	    arrayComboBoxBean.setFieldName("NMONTHFR");	   
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
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}	
        arrayComboBoxBean.setArrayString(c);
	    arrayComboBoxBean.setSelection((NDayFr==null?"":NDayFr));
	    arrayComboBoxBean.setFieldName("NDAYFR");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    <font color="#006666"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
    <%
	try
	{       
		int  j =0; 
		String a[]= new String[Integer.parseInt(dateBean.getYearString())-2002+1];
		for (int i = 2002; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
		{
			a[j++] = ""+i; 
		}
        arrayComboBoxBean.setArrayString(a);
	    arrayComboBoxBean.setSelection((NYearTo==null?"":NYearTo));
	    arrayComboBoxBean.setFieldName("NYEARTO");	   
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
		int  j =0; 
		String b[]= new String[12];
		for (int i =1;i <= 12;i++)
		{
			if (i <10)	b[j++] = "0"+i;
			else b[j++] = ""+i;		
		}	
		arrayComboBoxBean.setArrayString(b);
	    arrayComboBoxBean.setSelection((NMonthTo==null?"":NMonthTo));
	    arrayComboBoxBean.setFieldName("NMONTHTO");	   
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
		int  j =0; 
		String c[]= new String[31];
		for (int i =1;i <= 31;i++)
		{
			if (i <10)	c[j++] = "0"+i;
			else c[j++] = ""+i;		
		}			
        arrayComboBoxBean.setArrayString(c);
	    arrayComboBoxBean.setSelection((NDayTo==null?"":NDayTo));
	    arrayComboBoxBean.setFieldName("NDAYTO");	   
        out.println(arrayComboBoxBean.getArrayString());		      		 
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
    %>
    </td>  
	</tr>   
  </table>  
<%
}  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
  <table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF" bordercolor="#D8DEA9">
    <tr bgcolor="#D8DEA9"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></div></td>               	  
	  <td width="9%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgQDocNo"/></font></div></td>
	  <td width="9%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgSalesMan"/></font></div></td>
      <td width="20%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>                   	  
    </tr>
    <% 
	while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
	{ 
		if ((rs1__index % 2) == 0)
		{
	    	colorStr = "FFFFCC";
	    }
	    else
		{
	    	colorStr = "#D8DEA9"; 
		}
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#D8DEA9" width="2%" nowrap><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("DNDOCNO")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td nowrap><font color="#006666"><%=rsTC.getString("ALCHNAME")%></font></td>     	             
	  <td width="9%" nowrap><font size="2" color="#006666"><%=rsTC.getString("DNDOCNO")%></font></td>
	  <td><font color="#006666"><%=rsTC.getString("SALESPERSON")%></font></td> 
      <td width="48%" nowrap><font size="2" color="#006666">
	 <%  
		iDetailRowCount = iDetailRowCount + rsTC.getInt("MAXLINE"); // 累加明細數量
		String subColStr = "";
		if ((rs1__index % 2) == 0)
		{ 
			subColStr = "D8DEA9"; 
		}
	    else
		{ 
			subColStr = "FFFFCC"; 
		}			    
		out.println("<table cellSpacing='0' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");			 
		if (spanning=="FALSE" || spanning.equals("FALSE"))
		{ 
			out.print("<tr><td nowrap>"); 
			out.println("<font size='-1' color='#006666'>");
			%><jsp:getProperty name="rPH" property="pgTotal"/><%
			out.println(rsTC.getString("MAXLINE"));
			%><jsp:getProperty name="rPH" property="pgItemQty"/><%
			out.println("</font>"); %><a href="../jsp/TSRFQFactResponseMOCreateRpt.jsp?SPANNING=TRUE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a>
			<% 
			out.println("<font size='-1' color='#006666'>");
			%><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
			String sqlCrUser = "select upper(USERNAME) from ORADDMAN.WSUSER where WEBID = '"+rsTC.getString("CREATED_BY")+"' "; // 取開單人員							   
			Statement stateCrUser=con.createStatement();
            ResultSet rsCrUser=stateCrUser.executeQuery(sqlCrUser);
			if (rsCrUser.next())
			{ 
				out.println(" : <font color='#CC3366'>"+rsCrUser.getString(1)+"</font>");// 取大寫名稱
			}
			rsCrUser.close();
			stateCrUser.close();				           
			out.println("</font>"); 
			out.println("</td></tr>");
		} 
		else if ( spanning==null || spanning.equals("") ||  spanning=="TRUE" || spanning.equals("TRUE") )
		{	
            //再判段若是 Entity ID 才顯示明細,點擊符號顯示 MINUS 
        	out.print("<tr>");
		   	out.println("<td colspan=12>"); 							   
		   	out.println("<font color='#006666'>");
		   	%><jsp:getProperty name="rPH" property="pgCustomerName"/><%
		   	out.println(" : "+rsTC.getString("CUSTOMER")+"&nbsp;&nbsp;&nbsp;");
		   	%><jsp:getProperty name="rPH" property="pgTotal"/><%
		   	out.println(rsTC.getString("MAXLINE"));
		   	%><jsp:getProperty name="rPH" property="pgItemQty"/><%
		   	out.println("</font>"); 
		   	%><a href="../jsp/TSRFQFactResponseMOCreateRpt.jsp?SPANNING=FALSE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/MINUS.gif" width="14" height="15" border="0"></a>
		   	<% 
			out.println("<font color='#006666'>");
		   	%><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
			String sqlCrUser = "select upper(USERNAME) from ORADDMAN.WSUSER where WEBID = '"+rsTC.getString("CREATED_BY")+"' "; // 取開單人員							   
			Statement stateCrUser=con.createStatement();
            ResultSet rsCrUser=stateCrUser.executeQuery(sqlCrUser);
			if (rsCrUser.next())
			{ 
				out.println(" : <font color='#CC3366'>"+rsCrUser.getString(1)+"</font>");// 取大寫名稱
			}
			rsCrUser.close();
			stateCrUser.close();
            out.println("</font></td>");
		   	out.println("</tr>");						   
			int iRow = 0; 	
			
			String sqlM = "select DISTINCT d.LINE_NO,decode(d.EDIT_CODE,'R','REJECTED',d.LSTATUS) LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
                          //"TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
						  //modify by Peggy 20120221,暫時解決時間格式跑掉問題
						  "TO_CHAR (TO_DATE (case when length(d.request_date)=14 then  d.request_date else substr(d.request_date,1,8) end , 'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
						  //  "substr(d.REQUEST_DATE,0,8),"+ // For 資料異常
					      "d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO,"+
                          "e.MANUFACTORY_NAME,d.REMARK, d.INVENTORY_ITEM_ID"+
						  ",case when length(f.ARRANGED_DATE)>=8 then f.ARRANGED_DATE else 'N/A' end as ARRANGED_DATE "+ //add ARRANGED_DATE by Peggy 20120413
						  ",d.ORDERED_ITEM "+ //add by Peggy 20150123
						  "from ORADDMAN.TSSALES_AREA b, "+
						  "ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
						  "(select DNDOCNO,LINE_NO,CDATETIME,ARRANGED_DATE from ORADDMAN.TSDELIVERY_DETAIL_HISTORY where ORISTATUSID = '004' and ACTIONID = '009') f ";										     
			String whereM = "where d.DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' "+
			                "and d.DNDOCNO = f.DNDOCNO(+) and d.LINE_NO = f.LINE_NO(+) "+
					        "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+		
							"and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='"+locale+"' ";				
			String orderM = "order by d.LINE_NO";				   
			if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
			{
				whereM+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
			}
  
            if (status!=null && !status.equals("--")) 
			{
				if (status.equals("005"))
				{
					whereM+=" and NVL(d.EDIT_CODE,'') ='R'"; 
				}
				else
				{
					whereM+=" and d.LSTATUSID ='"+status+"'"; 
				}
			}
							   
			//if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") whereM=whereM+" and substr(f.CDATETIME,0,8) >="+"'"+dateSetBegin+"' "; 
            //if (DayFr!="--" && DayTo!="--") whereM=whereM+" and substr(f.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(f.CDATETIME,0,8) <= "+"'"+dateSetEnd+"' ";
			//modify by Peggy 20120221
			if ((!DayFr.equals("--") && !DayFr.equals("00")) && DayTo=="--")
			{
				whereM+= " and substr(f.CDATETIME,0,8) >="+"'"+dateSetBegin+"' ";
			}
			//modify by Peggy 20120221
			if (!DayFr.equals("--") && !DayTo.equals("--")) 
			{
				whereM+= " and substr(f.CDATETIME,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(f.CDATETIME,0,8) <= "+"'"+dateSetEnd+"' ";  
			}
			if (!NYearFr.equals("--") || !NMonthFr.equals("--") || !NDayFr.equals("--"))
			{
				whereM+= " and substr(d.REQUEST_DATE,1,8) >= '"+ (NYearFr.equals("--")?""+(dateBean.getYear()-2):NYearFr)+(NMonthFr.equals("--")?"01":NMonthFr)+(NDayFr.equals("--")?"01":NDayFr)+"' ";
			}
			if (!NYearTo.equals("--") || !NMonthTo.equals("--") || !NDayTo.equals("--"))
			{
				whereM+= " and substr(d.REQUEST_DATE,1,8) <= to_char(to_date('"+ (NYearTo.equals("--")?""+dateBean.getYear():NYearTo)+(NMonthTo.equals("--")?""+dateBean.getMonth():(NDayTo.equals("--")?("0"+(Integer.parseInt(NMonthTo)+1)).substring(("0"+(Integer.parseInt(NMonthTo)+1)).length()-2):NMonthTo))+(NDayTo.equals("--")?(NMonthTo.equals("--")?""+dateBean.getDay():"01"):""+NDayTo)+"','yyyymmdd')-"+(!NMonthTo.equals("--")&&NDayTo.equals("--")?1:0)+",'yyyymmdd')";
			}			
					
			if (statusCode.equals("O")) 
			{ 
				whereM+=" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  
			} // 只找開單處理中的單據
            else if (statusCode.equals("C")) 
			{ 
				whereM+=" and d.LSTATUSID in ('010') ";  
			} // 只找已結案的單據
            else if (statusCode.equals("A")) 
			{ 
				whereM+=" and d.LSTATUSID in ('012') ";  
			} // 只找放棄的單據
            else if (statusCode.equals("P")) 
			{ 
				whereM+=" and f.ORISTATUSID in ('002','007') ";  
			}   // 只找企劃處理過的單據 (對應HISTORY 的 ORISTATUSID in ('002','007') )
            else if (statusCode.equals("F")) 
			{ 
				whereM+=" and f.ORISTATUSID in ('003','004') ";  
			} // 只找工廠處理過的單據 (對應HISTORY 的 ORISTATUSID in ('003','004') )
				
			if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("PRD_PM")>=0)  //add by Peggy 20210609
			{
				whereM+=" and d.TSC_PROD_GROUP in ('PRD','PRD-Subcon')";  	
			}					
			sqlM = sqlM + whereM + orderM;
			sqlDtl = sqlM; // 把給Excel明細sql傳予sqlDtl 變數
							   
			Statement stateM=con.createStatement();
			//out.println(sqlM);
            ResultSet rsM=stateM.executeQuery(sqlM); 							  
			while (rsM.next())
			{ 
				/*
				// 2007/03/29 增加顯示客戶品號於_起		   
				String custItem = null;	 			 
				Statement stateCI=con.createStatement();
				String sqlCI = "select ITEM_ID, trim(ITEM) as CUST_ITEM, ITEM_DESCRIPTION, "+					       
								 "       ITEM_IDENTIFIER_TYPE "+
								 "  from oe_items_v  ";			                      														  
				String whereCI = "where to_char(sold_to_org_id) = '"+rsTC.getString("TSCUSTOMERID")+"' "+					           	
								   "  and nvl(cross_ref_status,'ACTIVE') <> 'INACTIVE' " +							
								   "  and INVENTORY_ITEM_ID ="+rsM.getInt("INVENTORY_ITEM_ID")+" ";
								   
				sqlCI = sqlCI + whereCI;
				//out.println(sqlCI);		
				ResultSet rsCI=stateCI.executeQuery(sqlCI);
				if (rsCI.next())
				{
					custItem = rsCI.getString("CUST_ITEM");  // 客戶品號
				} 
				else 
				{
					custItem = "N/A";
				}
				rsCI.close();
				stateCI.close();		  
				// 2007/03/29 增加顯示客戶品號於_迄
				*/
				String custItem = rsM.getString("ORDERED_ITEM"); //modify by Peggy 20150123
							   
				if (iRow==0 ) // 若第一筆資料才列印標頭列 //
				{ 
					out.println("<tr align='center' bgcolor='#CC6633'><td width='1%' nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgProdFactory"/><%								
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgFactoryResponse"/><jsp:getProperty name="rPH" property="pgDay"/><%								
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgAnItem"/><%								
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgCustItemNo"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgUOM"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgQty"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgRequestDate"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgFTArrangeDate"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgFTConfirmDate"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgOrdCreateDate"/><%
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><%															
					out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
					%><jsp:getProperty name="rPH" property="pgRepStatus"/><%	
					out.println("</font></td></tr>");
				}// End of if (iRow==0)
								
				out.println("<tr bgcolor="+subColStr+">");
				out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("MANUFACTORY_NAME")+"</font></td>");
				// 取工廠交期回覆時間_起
				String sqlC = "select TO_CHAR(TO_DATE(a.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD')  "+ 
				//String sqlC = "select substr(a.CDATETIME,0,8)  "+    // For 資料異常                                          
                               "from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a "+                                            
							   "where a.DNDOCNO='"+rsTC.getString("DNDOCNO")+"' and to_char(a.LINE_NO) = '"+rsM.getString("LINE_NO")+"' "+
							   "and a.ORISTATUSID = '004' and a.ACTIONID = '009' "; // 取狀態是判定且動作給交期確認(CONFIRM)
				//out.println(sqlC);
				Statement stateC=con.createStatement();
                ResultSet rsC=stateC.executeQuery(sqlC); 
				if (rsC.next())
				{
					out.println("<td align='center' width='1%' nowrap><font size=-2 color='#CC6633'>"+rsC.getString(1)+"</font></td>");							    
				} 
				else 
				{
					out.println("<td align='center' width='1%' nowrap><font size=-2 color='#CC6633'>N/A</font></td>");	
				}								
				rsC.close();
				stateC.close();
				// 取工廠交期回覆時間_迄
				out.println("<td width='1%' nowrap><font size='-2' color='#006666'><div align='center'>"+rsM.getString("LINE_NO")+"</div></font></td>");								
				out.println("<td nowrap><font size='-2' color='#CC6633'>"+rsM.getString("ITEM_DESCRIPTION")+"</font></td>");
				out.println("<td nowrap><font size='-2' color='#CC6633'>"+custItem+"</font></td>");
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>"+rsM.getString("UOM")+"</font></td>");
				out.println("<td nowrap align='right'><font size='-2' color='#006666'>"+rsM.getString("QUANTITY")+"</font></td>");
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>"+rsM.getString(6)+"</font></td>");								
				//out.println("<td nowrap><font size='-2' color='#006666'>");
				//if (rsM.getString("PCCFMDATE")==null || rsM.getString("PCCFMDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCCFMDATE").substring(0,4)+"/"+rsM.getString("PCCFMDATE").substring(4,6)+"/"+rsM.getString("PCCFMDATE").substring(6,8)); 
				//out.println("</font></td>");
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
				if (rsM.getString("FTACPDATE")==null || rsM.getString("FTACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("FTACPDATE").substring(0,4)+"/"+rsM.getString("FTACPDATE").substring(4,6)+"/"+rsM.getString("FTACPDATE").substring(6,8)); 
				out.println("</font></td>");	
				//add by Peggy 20120413							
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
				if (rsM.getString("ARRANGED_DATE")==null || rsM.getString("ARRANGED_DATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("ARRANGED_DATE").substring(0,4)+"/"+rsM.getString("ARRANGED_DATE").substring(4,6)+"/"+rsM.getString("ARRANGED_DATE").substring(6,8)); 
				out.println("</font></td>");								
				//out.println("<td nowrap><font size='-2' color='#006666'>");
				//if (rsM.getString("PCACPDATE")==null || rsM.getString("PCACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCACPDATE").substring(0,4)+"/"+rsM.getString("PCACPDATE").substring(4,6)+"/"+rsM.getString("PCACPDATE").substring(6,8)); 
				//out.println("</font></td>");								
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
				if (rsM.getString("SASCODATE")==null || rsM.getString("SASCODATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("SASCODATE").substring(0,4)+"/"+rsM.getString("SASCODATE").substring(4,6)+"/"+rsM.getString("SASCODATE").substring(6,8)); 
				out.println("</font></td>");			
				out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
				if (rsM.getString("ORDERNO")==null || rsM.getString("ORDERNO").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("ORDERNO")); 
				out.println("</font></td>");					
				out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("LSTATUS")+"</font></td>");
				out.println("</tr>");
								
				iRow++;
			} // End of while
			rsM.close();
			stateM.close();
		}  // End of else if (spannin==null)
		out.println("</table>");   
	  	%>
		</font></td> 	  	                
    </tr>
<%
		rs1__index++;
  		rs_hasDataTC = rsTC.next();
	}
%>
    <tr bgcolor="#D8DEA9"> 
      <td height="23" colspan="10" ><font color="#006666"><jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	if (CaseCount==0) 
	{ //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
	} 
	else 
	{ 
		out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); 
	}
  	workingDateBean.setAdjWeek(1);  // 把週別調整回來
%>
<input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color="#006666"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#000066' face="Arial"><strong><%=iDetailRowCount%></strong></font>
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% 
	if (rs_isEmptyTC ) 
	{  
	%>
    <strong>No Record Found</strong> 
    <% 
	} /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input name="SQLDETAIL" type="hidden" value="<%=sqlDtl%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input name="DATESETBEGIN" type="hidden" value="<%=dateSetBegin%>">
<input name="DATESETEND" type="hidden" value="<%=dateSetEnd%>">
<input name="STATUS" type="hidden" value="<%=status%>">
<input name="CDATESETBEGIN" type="hidden" value="<%=CdateSetBegin%>"> 
<input name="CDATESETEND" type="hidden" value="<%=CdateSetEnd%>">
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

