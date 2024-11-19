<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
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
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
 /*
 if(document.MYFORM.ORDERNO.value==null && document.MYFORM.DATECODE.value <> null)
    {
	 alert("will take a long time!!")
	// document.MYFORM.SHIPFROMORG.focus(); 
	// return(false);
	} 
 */

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit1(xItem,xOrgId)
//function setSubmit1(URL)
{

 if(document.MYFORM.SHIPFROMORG.value==null ||  document.MYFORM.SHIPFROMORG.value=="--")
    {
	 alert("Choose one of Organization!!")
	 document.MYFORM.SHIPFROMORG.focus(); 
	 return(false);
	} 

 // if(document.MYFORM.SHIPFROMORG.value=="49")
  //   {
//	  alert("Will be take a long time!!");
	//  URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=4&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
	//} 

  if(document.MYFORM.SHIPFROMORG.value=="163")
     {
	  alert("Will take a long time!!")
	  URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=5&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
	} else
        {
	       alert("Will take a long time!!");
	       URL="../jsp/TSCINVI6StockExcel.jsp?TYPEID=4&ITEM="+xItem+"&ORGANIZATION_ID="+xOrgId;
          }
  // URL="../jsp/TSCMfgWoExceltype1.jsp?WOTYPE=1&MARKETTYPE="+xMARKETTYPE+"&DATESETBEGIN="+document.MYFORM.YEARFR.value+document.MYFORM.MONTHFR.value+document.MYFORM.DAYFR.value+"&DATESETEND="+document.MYFORM.YEARTO.value+document.MYFORM.MONTHTO.value+document.MYFORM.DAYTO.value+"&WONO="+document.MYFORM.WONO.value+"&MFGDEPTNO="+document.MYFORM.MFGDEPTNO.value+"&INVITEM="+document.MYFORM.INVITEM.value+"&WAFERLOT="+document.MYFORM.WAFERLOT.value; 
  document.MYFORM.action=URL;
  document.MYFORM.submit();
}


function setSubmit2(URL)  //清除畫面條件,重新查詢!
{  
 document.MYFORM.ORDERNO.value =""; 
 document.MYFORM.ITEM.value ="";
 document.MYFORM.DATECODE.value ="";
 //document.MYFORM.MONTHFR.value ="";
 //document.MYFORM.DAYFR.value ="";
 //document.MYFORM.MONTHTO.value ="";
 //document.MYFORM.DAYTO.value ="";
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}


function TSCINVI6StockDetail(itemid,typeId,subInv,orgId)
{            
    subWin=window.open("../jsp/TSCINVI6StockDetail.jsp?ITEM_ID="+itemid+"&TYPEID="+typeId+"&SUBINV="+subInv+"&ORGANIZATION_ID="+orgId,"subwin","top=0,left=0,width=1000,height=650,scrollbars=yes,menubar=no,status=yes");    	
}

function popMenuMsg(xclkDesc)
{
 alert(xclkDesc);
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

<%
int rs1__numRows = 200;
int rs1__index = 0;
int rs_numRows = 0;

rs_numRows += rs1__numRows;

String sSql = "";
String sFrom = "";
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

String colorStr = "",fontcolor = "";
String listMode=request.getParameter("LISTMODE"); 
String mfgDeptNo=request.getParameter("MFGDEPTNO"); 
  
String sqlGlobal = "";
String sWhereGlobal = "";

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
  
String shipFromOrg =request.getParameter("SHIPFROMORG");	
//String OrgFr ="";

	String organizationId=request.getParameter("ORGANIZATION_ID"); 


	String invItem=request.getParameter("INVITEM");
	String itemId=request.getParameter("ITEMID");	
	String itemDesc=request.getParameter("ITEMDESC");		

	String orderNo=request.getParameter("ORDERNO");
    String item=request.getParameter("ITEM"); 
    String dateCode=request.getParameter("DATECODE");
    String lot=request.getParameter("LOT");

	String custPO=request.getParameter("CUSTOMER_LINE_NUMBER");	
	String lineNo=request.getParameter("LINE_NO");
 
    String LotNo=request.getParameter("LOT_NUMBER");
    String LotQty=request.getParameter("LOT_QTY");
    String actulSd=request.getParameter("ACTUAL_SHIPMENT_DATE");
    String oeorderNo=request.getParameter("OEORDERNO");
    String rcDateCode=request.getParameter("RC_DATE_CODE");
    String invoiceNo="",custName=""; 
 

 // if (organizationId==null || organizationId.equals("")) { organizationId="163"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (listMode==null) listMode = "TRUE";
  int iDetailRowCount = 0;
  

  if (orderNo==null || orderNo.equals("")) orderNo=""; 
  if (item==null || item.equals("")) item=""; 
  if (dateCode==null || dateCode.equals("")) dateCode=""; 
  if (lot==null || lot.equals("")) lot=""; 
  

  
	 


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style1 {color: #003399}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM ACTION="../jsp/TSCMfgShipDCQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>Shipping Data Trace</a></strong></font><BR>
<A href="/oradds/ORADDSMainMenu.jsp">Home</A>
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = "  ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

//if (orderNo==null || orderNo.equals("")) orderNo="";

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

//if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
%>
  <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
     <tr>
	   <td width="18%" nowrap><font color="#006666"><strong> &nbsp; Order Number</strong></font> &nbsp;
       <input type="text" name="ORDERNO" value="<%=orderNo%>" size="12"></td>
	   <td width="18%" nowrap><font color="#006666"><strong> &nbsp;Invoice No</strong></font>
        <input type="text" name="ITEM" value="<%=item%>" size="12"></td>
	   <td width="18%" nowrap><font color="#006666"><strong> &nbsp;DateCode</strong></font>
        <input type="text" name="DATECODE" value="<%=dateCode%>" size="10"></td>
	   <td width="18%" nowrap><font color="#006666"><strong> &nbsp;LotNo</strong></font>
        <input type="text" name="LOT" value="<%=lot%>" size="12"></td>

	<td  width="25%">
		    <INPUT TYPE="button" align="middle"  value='Query' onClick='setSubmit("../jsp/TSCMfgShipDCQuery.jsp")' > 
			<INPUT TYPE="reset" name="RESET" align="middle"  value='Reset' onClick='setSubmit2("../jsp/TSCMfgShipDCQuery.jsp")' >
			<!--INPUT TYPE='button' name='IMPORT' value='EXCEL' onClick='setSubmit1(this.form.ITEM.value,this.form.SHIPFROMORG.value)'-->
    </td>
	 </tr>
  </table>
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
	 
</table>
<%


  // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
/*
     String clientID = "";
     if (shipFromOrg=="--" || shipFromOrg.equals("--") ||shipFromOrg==null || shipFromOrg.equals("")) 
       {clientID="41"; }

	 if (shipFromOrg=="326" || shipFromOrg.equals("326"))
	 {  clientID = "325"; }
	 else { clientID = "41"; }
  */
     String clientID = "325";
     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	 cs1.setString(1,clientID);  //  41 --> 為半導體  325 --> 為YEW
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();

  // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
//out.print("<br>orderNo="+orderNo);
//out.print("<br>item="+item);
//out.print("<br>dateCode="+dateCode);

 if ( (item==null || item.equals("")) && (orderNo==null || orderNo.equals("")) && (dateCode==null || dateCode.equals("")) && (lot==null || lot.equals("")))
//if ( orderNo==null || orderNo.equals(""))
   {
    try
    {
    
      sSql = " SELECT TTIL.INVOICE_NO,TTIL.CUSTOMER_SHORT_NAME CUST_NAME,OOH.ORDER_NUMBER, "+
		     "        OOL.LINE_NUMBER||'.'||OOL.SHIPMENT_NUMBER LINE_NO,YRA.INV_ITEM,YRA.ITEM_DESC,OOL.CUSTOMER_LINE_NUMBER, "+
             "        YRA.RC_DATE_CODE,MLN.LOT_NUMBER,ABS(MLN.PRIMARY_QUANTITY) LOT_QTY,  "+
             "        trunc(OOL.ACTUAL_SHIPMENT_DATE) ACTUAL_SHIPMENT_DATE,OOL.CUSTOMER_LINE_NUMBER  ";

   sSqlCNT = " select count(*) as CaseCount ";

    String sqlOrgCnt = " select count(*) as CaseCountORG ";

    sFrom = " FROM MTL_MATERIAL_TRANSACTIONS MMT,MTL_TRANSACTION_LOT_NUMBERS MLN,TSC_TRIANGLE_INVOICE_LINES TTIL,  "+
    		"      OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL,YEW_RUNCARD_ALL YRA ";

   sWhere = " WHERE MMT.TRANSACTION_TYPE_ID = 33   AND MMT.INVENTORY_ITEM_ID = OOL.INVENTORY_ITEM_ID "+
 			"   AND MMT.TRANSACTION_ID = MLN.TRANSACTION_ID   AND MMT.ORGANIZATION_ID = MLN.ORGANIZATION_ID "+
  			"   AND MMT.ORGANIZATION_ID = OOL.SHIP_FROM_ORG_ID   AND MMT.SOURCE_LINE_ID = OOL.LINE_ID  "+  
  			"   AND OOH.HEADER_ID = OOL.HEADER_ID   AND OOH.ORG_ID = OOL.ORG_ID  "+
            "   AND TTIL.ORDER_LINE_ID = OOL.LINE_ID  AND TTIL.INVENTORY_ITEM_ID = OOL.INVENTORY_ITEM_ID "+
            "   AND MLN.ORGANIZATION_ID=YRA.ORGANIZATION_ID   AND MLN.LOT_NUMBER = YRA.RUNCARD_NO 	 "+
            "   AND MMT.TRANSACTION_ID=0 ";
       //     "   AND MMT.TRANSACTION_ID="+orderNo+" ";

   sWhereGP =  "";	
		 
   sWhereSDRQ = " ";
   havingGrp = " ";               
   havingGrpSDRQ = "  ";
   sOrder = "   order by 1,2,3 ";
   //TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";   
   
   SWHERECOND = sWhere + sWhereGP + havingGrp;
   sSql = sSql +sFrom+ sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
   sSqlCNT = sSqlCNT + sFrom+ sWhere + sWhereSDRQ  ;//+ sWhereGP+ havingGrp + havingGrpSDRQ;   

   //out.println("sSql-1="+ sSql);   
  } //end of try
  catch (Exception e)
  {
   out.println("Exception a:"+e.getMessage());
  }

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
  try
 {
   
      sSql = " SELECT TTIL.INVOICE_NO,TTIL.CUSTOMER_SHORT_NAME CUST_NAME,OOH.ORDER_NUMBER, "+
		     "        OOL.LINE_NUMBER||'.'||OOL.SHIPMENT_NUMBER LINE_NO,YRA.INV_ITEM,YRA.ITEM_DESC,OOL.CUSTOMER_LINE_NUMBER, "+
             "        YRA.RC_DATE_CODE,MLN.LOT_NUMBER,ABS(MLN.PRIMARY_QUANTITY) LOT_QTY,  "+
             "        trunc(OOL.ACTUAL_SHIPMENT_DATE) ACTUAL_SHIPMENT_DATE,OOL.CUSTOMER_LINE_NUMBER  ";

   sSqlCNT = " select count(*) as CaseCount ";

    String sqlOrgCnt = " select count(*) as CaseCountORG ";

    sFrom = " FROM MTL_MATERIAL_TRANSACTIONS MMT,MTL_TRANSACTION_LOT_NUMBERS MLN,TSC_TRIANGLE_INVOICE_LINES TTIL,  "+
    		"      OE_ORDER_HEADERS_ALL OOH,OE_ORDER_LINES_ALL OOL,YEW_RUNCARD_ALL YRA ";

   sWhere = " WHERE MMT.TRANSACTION_TYPE_ID = 33   AND MMT.INVENTORY_ITEM_ID = OOL.INVENTORY_ITEM_ID "+
 			"   AND MMT.TRANSACTION_ID = MLN.TRANSACTION_ID   AND MMT.ORGANIZATION_ID = MLN.ORGANIZATION_ID "+
  			"   AND MMT.ORGANIZATION_ID = OOL.SHIP_FROM_ORG_ID   AND MMT.SOURCE_LINE_ID = OOL.LINE_ID  "+  
  			"   AND OOH.HEADER_ID = OOL.HEADER_ID   AND OOH.ORG_ID = OOL.ORG_ID  "+
            "   AND TTIL.ORDER_LINE_ID = OOL.LINE_ID  AND TTIL.INVENTORY_ITEM_ID = OOL.INVENTORY_ITEM_ID "+
            "   AND MLN.ORGANIZATION_ID=YRA.ORGANIZATION_ID   AND MLN.LOT_NUMBER = YRA.RUNCARD_NO 	 ";

   sWhereSDRQ = "  ";
   
   sWhereGP = "   ";

   if (orderNo==null || orderNo.equals(""))  {sWhere=sWhere+" ";}
   else { sWhere = sWhere + " AND OOH.ORDER_NUMBER = '"+orderNo+"'   "; }		
  
  if (item==null || item.equals(""))  {sWhere=sWhere+" ";}
   else { sWhere = sWhere + " AND TTIL.INVOICE_NO = upper('"+item+"')    "; }

  if (dateCode==null || dateCode.equals(""))  {sWhere=sWhere+" ";}
   else { sWhere = sWhere + " AND YRA.RC_DATE_CODE = upper('"+dateCode+"')  "; }

  if (lot==null || lot.equals(""))  {sWhere=sWhere+" ";}
   else { sWhere = sWhere + " AND MLN.LOT_NUMBER = upper('"+lot+"')  "; }
			 
   havingGrp = "  ";      
   havingGrpSDRQ = "  ";  
   sOrder = "   order by 1,2,3 ";
 
  SWHERECOND = sWhere+ sWhereGP;


  sSql = sSql +sFrom+sWhere +  sWhereGP+sOrder;   
  sSqlCNT = sSqlCNT+sFrom + sWhere +  sWhereGP;
  sqlOrgCnt = sqlOrgCnt+ sFrom+ sWhere+  sWhereGP; 


//    out.print("<br>sqlOrgCnt="+sqlOrgCnt);
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
    //out.print("<br>step!!!!!");
     CaseCountORG = rs2.getInt("CaseCountORG");
     //out.print("<br>CaseCountORG="+CaseCountORG);     
   }
   rs2.close();
   statement2.close();
   
  } //end of try
 catch (Exception e)
   {
     out.println("Exception CaseCountORG:"+e.getMessage());
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
//out.println(sSql);
sqlGlobal = sSql; 
Statement statementTC=con.createStatement(); 
ResultSet rsTC=statementTC.executeQuery(sSql);

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
// move end
%> 
<%
  if (listMode==null || listMode.equals("TRUE"))
  {
%> 
 <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">	
     <tr>	    
	   <!--td nowrap colspan="2"><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgWorkOrder"/><jsp:getProperty name="rPH" property="pgCDate"/></strong></font>
        <%

		  String CurrYear = null;	
          String CurrMonth = null;
          String CurrDay = null;   
          String  CurrYearTo = null,CurrMonthTo=null,CurrDayTo = null;	 
       %>
    </td-->  

   </tr>
  </table>  
<HR>
<%  
 }  // End of if (listMode==null || listMode,equals("TRUE")) 
%>

  <table cellspacing="0" bordercolordark="#6699CC" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
    <tr bgcolor="#BBD3E1"> 
	  <td width="3%" height="22" nowrap><div align="center"><font color="#000000" face="Arial">&nbsp;</font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#006666" face="Arial">Invoice No</font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">Customer</font></div></td>
	  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Order No</font></div></td>
	  <td width="3%" nowrap><div align="center"><font color="#006666" face="Arial">lineNo</font></div></td>
      <td width="16%" nowrap><div align="center"><font color="#006666" face="Arial">Item No</font></div></td>           
      <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Description</font></div></td> 
	  <!--td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">InventoryNo</font></div></td-->
      <td width="12%" nowrap><div align="center"><font color="#006666" face="Arial">CustomerPO</font></div></td>	 
	  <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">DateCode</font></div></td> 
	  <td width="9%" nowrap><div align="center"><font color="#006666" face="Arial">Lot No</font></div></td> 	
	  <td width="5%" nowrap><div align="center"><font color="#006666" face="Arial">Lot Qty</font></div></td>   
	  <td width="7%" nowrap><div align="center"><font color="#006666" face="Arial">A.S.D.</font></div></td> 

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
        String rowNo =" ";
       
//
		invoiceNo=rsTC.getString("INVOICE_NO");
		custName=rsTC.getString("CUST_NAME");
		oeorderNo=rsTC.getString("ORDER_NUMBER");
		lineNo=rsTC.getString("LINE_NO");
		invItem=rsTC.getString("INV_ITEM");
		itemDesc=rsTC.getString("ITEM_DESC");
		custPO=rsTC.getString("CUSTOMER_LINE_NUMBER");
		rcDateCode=rsTC.getString("RC_DATE_CODE");
		LotNo=rsTC.getString("LOT_NUMBER");
		LotQty=rsTC.getString("LOT_QTY");
		actulSd=rsTC.getString("ACTUAL_SHIPMENT_DATE");



    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td ><div align="center"><font color="#006666" face="Arial"><%out.println(rs1__index+1);%></font></div></td>
	  <td ><div align="left"><font color="#006666" face="Arial"><%=invoiceNo%></font></div></td>
	  <td ><div align="left"><font color="#006666" face="Arial"><%=custName%></font></div></td>
	  <td ><div align="left"><font color="#006666" face="Arial"><%=oeorderNo%></font></div></td>
	  <td ><div align="left"><font color="#006666" face="Arial"><%=lineNo%></font></div></td>
	  <td ><div align="center"><font color="#006666" face="Arial"><%=invItem%></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=itemDesc%></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=custPO%></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=rcDateCode%>&nbsp;</font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=LotNo%></font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=LotQty%>&nbsp;</font></div></td>
	  <td ><div align="right"><font color="#006666" face="Arial"><%=actulSd%></font></div></td>
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
   counta = rs1__index ;
  }// endof while substate


%>
    <tr bgcolor="#BBD3E1"> 
      <td height="23" colspan="15" ><font color="#006666">ToTal Count:</font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">	 <font color='#000066' face="Arial"><strong><%=CaseCount%></strong></font>
	 
	 </td>      
    </tr>
</table>


  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORDERNO"  maxlength="5" size="5" value="<%=orderNo%>">
<input type="hidden" name="ITEM"  maxlength="5" size="5" value="<%=item%>">
<input type="hidden" name="DATECODE"  maxlength="5" size="5" value="<%=dateCode%>">
<input type="hidden" name="LOT"  maxlength="5" size="5" value="<%=lot%>">
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
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
