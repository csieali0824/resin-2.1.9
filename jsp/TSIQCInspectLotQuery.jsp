<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
 document.MYFORM.MARKETTYPE.value =""; 
 document.MYFORM.CLASSID.value =""; 
 document.MYFORM.WONO.value ="";
 document.MYFORM.INVITEM.value ="";
 document.MYFORM.ITEMDESC.value ="";
 document.MYFORM.WAFERLOT.value ="";
 document.MYFORM.MONTHFR.value ="";
 document.MYFORM.DAYFR.value ="";
 document.MYFORM.MONTHTO.value ="";
 document.MYFORM.DAYTO.value ="";
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

function objChange()
{
	document.MYFORM.YEARFR.value = "--";
	document.MYFORM.MONTHFR.value = "--";
 	document.MYFORM.DAYFR.value ="--";
	document.MYFORM.YEARTO.value = "--";
 	document.MYFORM.MONTHTO.value ="--";
 	document.MYFORM.DAYTO.value ="--";
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
<title>Oracle Add On System Information Query</title>
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
if (dateSetBegin==null ) dateSetBegin=YearFr+MonthFr+DayFr;

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
if (dateSetEnd==null ) dateSetEnd=YearTo+MonthTo+DayTo; 

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
String woUom=request.getParameter("WOUOM");
String waferLot=request.getParameter("WAFERLOT");
String waferQty=request.getParameter("WAFERQTY");          //使用晶片數量
String waferUom=request.getParameter("WAFERUOM");          //晶片單位
String waferYld=request.getParameter("WAFERYLD");          //晶片良率
String waferVendor=request.getParameter("WAFERVENDOR");   //晶片供應商
String waferKind=request.getParameter("WAFERKIND");       //晶片類別
String waferElect=request.getParameter("WAFERELECT");     //電阻系數��
String waferPcs=request.getParameter("WAFERPCS");         //使用晶片片數���
String waferIqcNo=request.getParameter("WAFERIQCNO");     //檢驗單號	
String tscPackage=request.getParameter("TSCPACKAGE");     //
String tscFamily=request.getParameter("TSCFAMILY");     //
String tscPacking=request.getParameter("TSCPACKING");
String tscAmp=request.getParameter("TSCAMP");		      //安培數
String alternateRouting=request.getParameter("ALTERNATEROUTING"); 
String customerName=request.getParameter("CUSTOMERNAME");	
String customerNo=request.getParameter("CUSTOMERNO");
String customerId=request.getParameter("CUSTOMERID");
String customerPo=request.getParameter("CUSTOMERPO");
String oeOrderNo=request.getParameter("OEORDERNO");	
String deptNo=request.getParameter("DEPT_NO");	
String deptName=request.getParameter("DEPT_NAME");	
String preFix=request.getParameter("PREFIX");
String oeHeaderId=request.getParameter("OEHEADERID");	
String oeLineId=request.getParameter("OELINEID");	
String organizationId=request.getParameter("ORGANIZATION_ID");
String singleLotQty=null,createDate=null,userName=null,completeQty="0",scrapQty="0",woStatus="",olStatus="";
  
if (dnDocNo==null || dnDocNo.equals("")) dnDocNo=""; //選擇展開的
if (dnDocNoSet==null || dnDocNoSet.equals("")) dnDocNoSet=""; // 使用者輸入的
if (customerId==null || customerId.equals("")) customerId="";
if (customerNo==null || customerNo.equals("")) customerNo="";
if (customerName==null || customerName.equals("")) customerName="";
if (custPONo==null || custPONo.equals("")) custPONo="";
if (createdBy==null || createdBy.equals("")) createdBy="";


if (statusCode==null || statusCode.equals("")) statusCode="";  

if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
if (spanning==null || spanning.equals("")) spanning = "TRUE";
if (listMode==null) listMode = "TRUE";
int iDetailRowCount = 0;


if (classID==null || classID.equals("")) classID="--"; 
if (woNo==null || woNo.equals("")) woNo=""; 
if (waferIqcNo==null || waferIqcNo.equals("")) waferIqcNo="";   
  
  
// 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
String clientID = "";
if (organizationId=="46" || organizationId.equals("46"))
{  
	clientID = "42"; 
}
else 
{ 
	clientID = "41"; 
}

CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
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
<FORM ACTION="../jsp/TSCMfgWoQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>IQC檢驗批資料查詢</a></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp">回首頁</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
  //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
sWhereGP = "  ";

workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  

String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */
try
{
	sSql = " select distinct IQH.INSPLOT_NO, IQD.LINE_NO, decode(IQH.ORGANIZATION_ID,'326','內銷','327','外銷',IQH.ORGANIZATION_ID) as MARKET_TYPE, "+
	        "      IQS.CLASS_NAME ,IQD.INV_ITEM, REPLACE(IQD.INV_ITEM_DESC,'"+"\""+"','') as INV_ITEM_DESC, IQD.RECEIPT_QTY, IQD.INSPECT_QTY, "+
	   		"      IQD.SUPPLIER_LOT_NO, IQD.UOM, TO_CHAR(TO_DATE(IQD.RECEIPT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') RECEIPT_DATE, "+
			"      TO_CHAR(TO_DATE(IQD.INSPECT_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') INSPECT_DATE, "+
	   		" 	   IQD.INSPECTOR,IQD.LSTATUS, TO_CHAR(TO_DATE(IQD.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') as CREATEDATE,IQD.ORGANIZATION_ID "+
			" from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQH ,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQD, ORADDMAN.TSCIQC_CLASS IQS "+
			" where IQH.INSPLOT_NO=IQD.INSPLOT_NO and IQH.IQC_CLASS_CODE = IQS.CLASS_ID";

   	sSqlCNT = " select count(distinct IQH.INSPLOT_NO) CaseCount from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQH ,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQD, ORADDMAN.TSCIQC_CLASS IQS "+
  			  " where IQH.INSPLOT_NO=IQD.INSPLOT_NO and IQH.IQC_CLASS_CODE = IQS.CLASS_ID";
			
   //sWhere =  "  where IQH.INSPLOT_NO=IQD.INSPLOT_NO and IQH.IQC_CLASS_CODE = IQS.CLASS_ID ";

			 
   	sWhereSDRQ = "";
			 
  	if (marketType!=null && !marketType.equals("--") && !marketType.equals(""))
	{
		sWhere+=" and IQD.ORGANIZATION_ID ='"+marketType+"'";
	}
  
	if (classID!=null && !classID.equals("--")) 
	{
		sWhere+=" and IQH.IQC_CLASS_CODE ='"+classID+"'";
	}
  
	if (woNo!=null && !woNo.equals(""))
	{
		sWhere+=" and ( IQH.INSPLOT_NO ='"+woNo+"' or to_char(IQD.PO_NO)= '"+woNo+"' or IQD.RECEIPT_NO= '"+woNo+"' or IQD.SUPPLIER_LOT_NO ='"+woNo+"' ) "; 	
	}

   	if (invItem!=null && !invItem.equals(""))
   	{
		sWhere+=" and IQD.INV_ITEM ='"+invItem+"'";
   	}

	if (itemDesc!=null && !itemDesc.equals("")) 
	{
		sWhere+=" and IQD.INV_ITEM_DESC ='"+itemDesc+"'"; 
	}
   
	if (waferLot!=null && !waferLot.equals(""))  
	{
		sWhere+=" and IQD.SUPPLIER_LOT_NO ='"+waferLot+"'";
	}
	
	//modify by Peggy 20141203
	if ((YearFr !=null && !YearFr.equals("--")) || (MonthFr !=null && !MonthFr.equals("--")) || (DayFr !=null && !DayFr.equals("--")))
	{
		sWhere+=" and substr(IQD.RECEIPT_DATE,0,8)>="+ (!YearFr.equals("--")?YearFr:"0000")+(!MonthFr.equals("--")?MonthFr:"00")+(!DayFr.equals("--")?DayFr:"00");
	}
	//modify by Peggy 20141203
	if ((YearTo != null && !YearTo.equals("--")) || (MonthTo !=null && !MonthTo.equals("--")) || (DayTo!=null && !DayTo.equals("--")))
	{
		sWhere+=" and substr(IQD.RECEIPT_DATE,0,8)<="+ (!YearTo.equals("--")?YearTo:"0000")+(!MonthTo.equals("--")?MonthTo:"00")+(!DayTo.equals("--")?DayTo:"00");
	}
  
  	if (sWhere.equals(""))
	{
		YearFr=dateBean.getYearString();MonthFr=dateBean.getMonthString();DayFr=dateBean.getDayString();
		sWhere+=" and substr(IQD.RECEIPT_DATE,0,8)>="+ YearFr+MonthFr+DayFr;
	}
   	havingGrp = "  ";      
   	havingGrpSDRQ = "  ";  
   	sOrder = "  order by IQH.INSPLOT_NO, IQD.LINE_NO ";
 
  	SWHERECOND = sWhere+ sWhereGP;
  	sSql = sSql + sWhere +  sOrder;  
  	sSqlCNT = sSqlCNT + sWhere ;
  	//out.println("sSqlTT="+sSql); 
   
   	String sqlOrgCnt = " select count(distinct IQH.INSPLOT_NO) CaseCountORG from ORADDMAN.TSCIQC_LOTINSPECT_HEADER IQH ,ORADDMAN.TSCIQC_LOTINSPECT_DETAIL IQD, ORADDMAN.TSCIQC_CLASS IQS where IQH.INSPLOT_NO=IQD.INSPLOT_NO and IQH.IQC_CLASS_CODE = IQS.CLASS_ID ";
  	sqlOrgCnt = sqlOrgCnt + sWhere + sWhereGP;
   	//out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
   
   	Statement statement2=con.createStatement();
   	ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   	if (rs2.next())
   	{
    	CaseCountORG = rs2.getInt("CaseCountORG");     
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
	    <td width="13%" colspan="1" nowrap>
		<font color="#006666"><strong>
		內銷/外銷</strong></font>       </td> 
		<td width="12%">
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
       %>
	   </td>
		<td width="14%">
		  <font color="#006666"><strong>
	      檢驗類別</strong></font>	   </td>   
		<td width="19%" colspan="1" nowrap>   
		      <%
                 try
                 {  
				   //-----取檢驗類型  
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sqlOrgInf = " select CLASS_ID,CLASS_ID||'('||CLASS_NAME||')' as CLASS_NAME from ORADDMAN.TSCIQC_CLASS ";
			        String whereOType = " where CLASS_ID IS NOT NULL  ";								  
				   String orderType = "  ";			   
				   sqlOrgInf = sqlOrgInf + whereOType;
				   //out.println(sqlOrgInf);
                   rs=statement.executeQuery(sqlOrgInf);
		           comboBoxBean.setRs(rs);
		           comboBoxBean.setSelection(classID);
	               comboBoxBean.setFieldName("CLASSID");	   
                   out.println(comboBoxBean.getRsString());
		           rs.close();   
				   statement.close();  
				   //  out.print("whereOType="+woType);  
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		  %>		   
	   </td>    
	   <td width="21%" nowrap><font color="#006666"><strong>採購單號、收料單號或檢驗批單號</strong></font></td>
	   <td width="21%">&nbsp;&nbsp;
       <input type="text" name="WONO" value="<%=woNo%>" style="font-family: Tahoma,Georgia" onChange="objChange();"></td>
	 </tr>
  </table>
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
	 <tr>
     <td width="25%"><font color="#006666" face="Arial"><strong>
     料號：</strong></font>
       <input type="text" name="INVITEM" tabindex="4" size="23" style="font-family: Tahoma,Georgia" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.ORGANIZATIONID.value)"><INPUT TYPE="button" tabindex="12" value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'>
     </td>
	 <td width="26%"><font color="#006666" face="Arial"><strong>
     品名/規格：
	 </strong></font><input type="text" name="ITEMDESC" tabindex="5" size="20" style="font-family: Tahoma,Georgia" onKeyDown="setItemFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.ORGANIZATIONID.value)"><INPUT TYPE="button" tabindex="14"  value="..." onClick='subWindowItemFind(this.form.INVITEM.value,this.form.ITEMDESC.value)'></td>	 
		
	    <td width="24%" ><font color="#006666" face="Arial"><strong>
	      晶片批號：</strong></font><input type="text" name="WAFERLOT" tabindex="11" size="16" style="font-family: Tahoma,Georgia" onKeyDown='setWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value)'>
         <input name="button3" type="button" tabindex="12" onClick='subWinWaferLotFindCheck(this.form.INVITEM.value,this.form.ITEMDESC.value,this.form.WAFERLOT.value)' value="...">
       </td>	
		<td width="25%"> 
		   <font color="#006666" face="Arial"><strong>&nbsp;&nbsp;</strong></font>
		</td>   
	 </tr>
</table>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666"><strong>接收日期起</strong></font>
        <%
		  String CurrYear = null;	     		 
	     try
         {       
			int  j =0; 
          	//String a[]={"2006","2007","2008","2009","2010","2011","2012"};
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i = 2006; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
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
          out.println("Exception  year:"+e.getMessage());
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
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
       <font color="#006666"><strong>接收日期訖</strong></font> 
        <%
		  String CurrYearTo = null;	     		 
	     try
         {       
          //String a[]={"2006","2007","2008","2009","2010","2011","2012"};
			int  j =0; 
			String a[]= new String[Integer.parseInt(dateBean.getYearString())-2006+1];
			for (int i = 2006; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
			{
				a[j++] = ""+i; 
			}
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
	<td width="39%" colspan="2">
		    <INPUT TYPE="button" align="middle"  value='查詢' onClick='setSubmit("../jsp/TSIQCInspectLotQuery.jsp")' > 
			<input type="reset" name="RESET" align="middle"  value='重置' onClick='setSubmit2("../jsp/TSIQCInspectLotQuery.jsp")' >
			<!--INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit1(this.form.WOTYPE.value,this.form.DATESETBEGIN.value,this.form.DATESETEND.value)' -->  
			<INPUT TYPE="button" align="middle" value='EXCEL' onClick='setSubmit1(this.form.CLASSID.value,this.form.MARKETTYPE.value)' disabled> 
	</td>
   </tr>
  </table>  
<%  
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
%>
<table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
    <tr bgcolor="#BBD3E1"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" face="Arial">&nbsp;</font></div></td> 
	  <td width="11%" height="22" nowrap><div align="center"><font color="#006666" face="Arial">檢驗批單號</font></div></td>               
	  <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">項次</font></div></td>
      <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">檢驗類別</font></div></td>           
      <td width="11%" nowrap><div align="center"><font color="#006666" face="Arial">料號/品名規格</font></div></td> 	  
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">接收數量</font></div></td>
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">檢驗數量</font></div></td>
	  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">供應商批號</font></div></td>	 
	  <td width="6%" nowrap><div align="center"><font color="#006666" face="Arial">單位</font></div></td>  	   
	  <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial">接收日期</font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial">入庫日期</font></div></td>
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">處理人員</font></div></td>	
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">檢驗日期</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">狀態</font></div></td>
	  	    
	  	  	  
    </tr>
	
    <% 
	while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "#D8E6E7";
	     }
	    else{
	       colorStr = "#BBD3E1"; }		   

//  欄位辨識
         String marketCode=null;
         String woTypeCode=null;

	     String sqlm1 = " select code_desc MARKETCODE from yew_mfg_defdata where def_type='MARKETTYPE' and code='"+marketType+"' ";
		//out.print("sqlm1"+sqlm1);		 
		 Statement statem1=con.createStatement();
	     ResultSet rsm1=statem1.executeQuery(sqlm1);
		 if (rsm1.next())
		 { 	marketCode   = rsm1.getString("MARKETCODE");   }
		 rsm1.close();
	     statem1.close();  
		   
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#BBD3E1" width="2%" nowrap><div align="center"><font color="#006666" face="Arial"><a name='#<%=rsTC.getString("INSPLOT_NO")%>'><% out.println(rs1__index+1);%></a></font></div></td>
	  <td nowrap><div align="center"><font color="#006666" face="Arial"><a href="../jsp/TSIQCInspectLotClosedPage.jsp?INSPLOTNO=<%=rsTC.getString("INSPLOT_NO")%>&LINENO=<%=rsTC.getString("LINE_NO")%>" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=150;this.T_OPACITY=80;return escape("點擊連結查詢明細")'><%=rsTC.getString("INSPLOT_NO")%></a></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("LINE_NO")%></font></div></td>
	  <td nowrap><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("CLASS_NAME")%></font></div></td>
	  <td nowrap><div align="left"><font color="#006666" face="Arial"><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=150;this.T_OPACITY=80;return escape("<%=rsTC.getString("INV_ITEM_DESC")%>")'><%=rsTC.getString("INV_ITEM")%></a></font></div></td>	  
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("RECEIPT_QTY")%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("INSPECT_QTY")%></font></div></td>	  
	  <td nowrap><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("SUPPLIER_LOT_NO")%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("UOM")%></font></div></td>	  
	  <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("RECEIPT_DATE")%></font></div></td>
      <td ><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("INSPECT_DATE")%></font></div></td> 
	  <td nowrap><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("INSPECTOR")%></font></div></td>
      <td nowrap><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("INSPECT_DATE")%></font></div></td>  
	  <td nowrap><div align="center"><font color="#006666" face="Arial"><%=rsTC.getString("LSTATUS")%></font></div></td> 
    </tr>
    <%
   rs1__index++;
   rs_hasDataTC = rsTC.next();
   counta = rs1__index ;
  }  // End of While 
%>
    <tr bgcolor="#BBD3E1"> 
      <td height="23" colspan="15" ><font color="#006666">檢驗單筆數</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">	 <font color='#000066' face="Arial"><strong><%=counta%></strong></font>
	 
	 </td>      
    </tr>
  </table>
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
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
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
