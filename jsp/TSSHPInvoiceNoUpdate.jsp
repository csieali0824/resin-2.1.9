<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
	   gfPop.fHideCal();
	
}

function setSubmit1a(URL)
{ 
 if (event.keyCode==13)
 {   
 	 document.MYFORM.CHKQUERY.value ="Y"; 
     document.MYFORM.action=URL;
     document.MYFORM.submit();
  }//end if keycode
}

function setSubmit(URL)   //Query
{ 
  if (document.MYFORM.TSINVOICENO.value ==""  && document.MYFORM.TSINVOICENO.value=="" )
  {
    alert("Please Assign TS Invoice Number!!!");
	return false; 
  } 
  else
  {  
 	document.MYFORM.CHKQUERY.value ="Y";  
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
} 



function setSubmit1(URL) //shipConfirm
{ 
 
  if (document.MYFORM.TSINVOICENO.value ==""  && document.MYFORM.TSINVOICENO.value=="" )
  {
    alert("Please Assign TS Invoice Number!!!");
	return false; 
  } 
  else
  {
      //alert(document.MYFORM.SHIPDATE.value);
 	document.MYFORM.CHKQUERY.value ="N";  
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
}  



function chkStatus()
{    
   document.MYFORM.action="../jsp/TSSHPInvoiceNoUpdate.jsp";
   document.MYFORM.submit();
} 
</script>
<html>
<head>

<title>Invoice Ship Confirm Process</title>
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
String sSqlCNTITEM = "";
String sWhere = "";
String sWhereGP = "";
String sOrderBy = "";

String havingGrp = "";

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
      if (dateSetBegin==null) dateSetBegin=YearFr+MonthFr+DayFr;  

String YearTo=request.getParameter("YEARTO");
String MonthTo=request.getParameter("MONTHTO");
String DayTo=request.getParameter("DAYTO");
      if (dateSetEnd==null) dateSetEnd=YearTo+MonthTo+DayTo; 
	 
String [] selectFlag=request.getParameterValues("SELECTFLAG");	  


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
  String status=request.getParameter("STATUS");
  String statusCode=request.getParameter("STATUSCODE");  
  
   String ShipToOrg = request.getParameter("SHIPTOORG"); 
   String shipAddress = request.getParameter("SHIPADDRESS");
   String billAddress = request.getParameter("BILLADDRESS");
   String shipCountry = request.getParameter("SHIPCOUNTRY"); 
   String billCountry = request.getParameter("BILLCOUNTRY"); 
   String line_No=request.getParameter("LINE_NO");
   String shipTo = request.getParameter("SHIPTO"); 
   String billTo = request.getParameter("BILLTO"); 
   String deliverTo = request.getParameter("DELIVERTO");
   String shipMethod = request.getParameter("SHIPMETHOD");
   String fobPoint = request.getParameter("FOBPOINT");
   String paymentTerm = request.getParameter("PAYTERM");
   String pTermDesc = "";
   String payTerm = request.getParameter("PAYTERM");
   String payTermID = request.getParameter("PAYTERMID");
   
   String promiseDate = request.getParameter("PROMISEDATE");
   String custItemNo = request.getParameter("CUSTITEMNO");
   String custItemID = request.getParameter("CUSTITEMID");
   String custItemType = request.getParameter("CUSTITEMTYPE");
   String tsCustomerID = "6626";
   String [] check=request.getParameterValues("CHKFLAG");
//LILY CREAT
   String rcvQty = request.getParameter("RCVQTY");
   String tsInvoiceNo = request.getParameter("TSINVOICENO"); 
   String shipDate = request.getParameter("SHIPDATE");
   String itemDesc = request.getParameter("ITEM_DESC");
   String itemUom = request.getParameter("ITEM_UOM");
   String poUom = request.getParameter("PO_UOM");   
   String CREATE_BY = request.getParameter("CREATE_BY");
   String PO_HEADER_ID = request.getParameter("PO_HEADER_ID");
   String PO_LINE_ID = request.getParameter("PO_LINE_ID");
   String printFlag="";   //判斷列印否,若未列印,無法SHIP CONFIRM 
   String chkQuery = request.getParameter("CHKQUERY");  
   String orderLineId = request.getParameter("ORDER_LINE_ID");   
   String unitSellingPrice = request.getParameter("UNIT_SELLING_PRICE");
   
   shipDate ="";
   shipAddress="";
   
  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  
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
  
  if (ShipToOrg==null) ShipToOrg = "";
  if (shipMethod==null) shipMethod = "";
  if (fobPoint==null) fobPoint = "";
  if (paymentTerm==null) paymentTerm = "";
  if (printFlag==null) printFlag = "";
  
  

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  
  if (tsInvoiceNo==null) tsInvoiceNo = "";
  if (chkQuery==null || chkQuery.equals("")) chkQuery = "N";  
  
  int iDetailRowCount = 0;
  
  
 // if (shipDate==null || shipDate.equals("")) shipDate = dateBean.getYearMonthDay();


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
.style4 {
	color: #000066;
	font-weight: bold;
}
.style15 {color: #000066}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>   
<FORM ACTION="TSSHPInvoiceNoUpdate.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>
<jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgChange"/></strong></font>
<% 
    try
	{ 
	   if (tsInvoiceNo!=null)
       {
	     //判斷此INVOICE是否"CLOSED"
         Statement statefnds=con.createStatement();
         ResultSet rsfnds=statefnds.executeQuery("select TRIM(STATUS) AS STATUS,TRIM(PRINTED_FLAG) AS PRINTED_FLAG from APPS.TSC_DROPSHIP_SHIP_HEADER where tsinvoiceno = upper('"+tsInvoiceNo+"') ");
		 if (rsfnds.next())
		   { statusCode     = rsfnds.getString("STATUS"); 
		     printFlag		= rsfnds.getString("PRINTED_FLAG");      
		   }
		  rsfnds.close();
          statefnds.close();	
		 // out.println("statusCode"+statusCode);
		  //out.println("PRINTED_FLAG"+printFlag);		  
	      } //end if  (tsInvoiceNo!=null)

       if (statusCode ==null || statusCode.equals("") || statusCode.equals("OPEN"))		
		 {
           String sqlInvNo =  " select A.TSINVOICENO,A.SHIPDATE,A.CUSTOMERNO,A.CUSTOMERNAME,A.PRINTED_FLAG, "+
       					      "        A.SHIPTOORG,A.SHIPADDRESS,A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM, "+
                              "        B.SALESORDERNO,B.LINE_NO,B.INV_ITEM,B.ITEM_DESC,B.CUSTITEMNO,B.PO_UOM,B.RCVQTY "+
                              "   from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B "+
                              "  where A.TSINVOICENO=B.TSINVOICENO "+
                              "      and NVL(A.STATUS,'OPEN') != 'CLOSED' "+
  			                  "      and NVL(b.line_STATUS,'OPEN') != 'CLOSED' "+
							  //"      and NVL(A.PRINTED_FLAG,'N') = 'Y' "+
                              "      and A.TSINVOICENO = upper('"+tsInvoiceNo+"') ";
							
         //out.println("<BR>sqlInvNo="+sqlInvNo);
         Statement stateInvNo=con.createStatement();
         ResultSet rsInvNo=stateInvNo.executeQuery(sqlInvNo);
		 if (rsInvNo.next())
		 {
		    customerNo     = rsInvNo.getString("CUSTOMERNO");
			customerName   = rsInvNo.getString("CUSTOMERNAME");
			ShipToOrg      = rsInvNo.getString("SHIPTOORG");
			shipAddress    = rsInvNo.getString("SHIPADDRESS");
			shipDate       = rsInvNo.getString("SHIPDATE");
			shipMethod     = rsInvNo.getString("SHIPMETHOD");
			fobPoint       = rsInvNo.getString("FOBPOINT");
			paymentTerm    = rsInvNo.getString("PAYTERM");
			salesOrderNo    = rsInvNo.getString("SALESORDERNO");
			line_No        = rsInvNo.getString("LINE_NO");
			invItem        = rsInvNo.getString("INV_ITEM");
			itemDesc       = rsInvNo.getString("ITEM_DESC");
			custItemNo     = rsInvNo.getString("CUSTITEMNO");
			poUom        = rsInvNo.getString("PO_UOM");
			rcvQty         = rsInvNo.getString("RCVQTY");
		  }
		   rsInvNo.close();
           stateInvNo.close();	
	     } //end of status==null
		else
		 {
		 %>
		   <script language="javascript">
		     alert("This Invoice Already Closed!!");
			 chkStatus();
			 //response.sendRedirect("../jsp/TSSHPInvoiceQuery.jsp");  
		   </script>
		 <%
		  }

		 
	  //end of tsinvoiceno!=null
	} //end of try
    catch (Exception e)
    {
          out.println("Exception:"+e.getMessage());
    }   
	

 
/*  找尋合法的發票資訊 */


        sSql =  " select B.SALESORDERNO||'-'|| B.LINE_NO as SELECTFLAG, A.TSINVOICENO,A.SHIPDATE,A.CUSTOMERNO,A.CUSTOMERNAME, "+
       			"        A.SHIPTOORG,A.SHIPADDRESS,A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM,B.SALESORDERNO,B.LINE_NO,B.ORDER_LINE_ID, "+
                "        B.INV_ITEM,B.ITEM_DESC,B.CUSTITEMNO,B.PO_UOM,B.RCVQTY ,A.CREATE_BY,B.PO_HEADER_ID,B.PO_LINE_ID,A.PRINTED_FLAG ";
                           
							
String sFrom =  "   from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B " ;


   sSqlCNT     = "  select count(distinct A.TSINVOICENO) as CASECOUNT ";
   sSqlCNTITEM = "  select count(B.LINE_NO) as iDetailRowCount ";

   sWhere =  "  where A.TSINVOICENO=B.TSINVOICENO "+
             "      and NVL(A.STATUS,'OPEN') != 'CLOSED' "+
			 //"      and NVL(A.PRINTED_FLAG,'N') = 'Y' "+
             "      and NVL(b.line_STATUS,'OPEN') != 'CLOSED' "+
             "      and A.TSINVOICENO = upper('"+tsInvoiceNo+"') ";
			 
 sOrderBy =  " order by A.TSINVOICENO, B.SALESORDERNO,B.LINE_NO  ";			 


  sSql = sSql + sFrom + sWhere + sOrderBy ;
  sSqlCNT = sSqlCNT  + sFrom + sWhere ;
  sSqlCNTITEM = sSqlCNTITEM + sFrom + sWhere ;
  //out.println("sSqlCNT ="+sSqlCNT ); 
  //out.println("sSqlCNT ="+sSqlCNTITEM ); 
  //out.println("sSqlTT="+sSql);    
 
   String sqlOrgCnt ="  select count(B.LINE_NO) as iDetailRowCount ";
   sqlOrgCnt = sqlOrgCnt +  sFrom+sWhere + sWhereGP + havingGrp;
   //out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
 
   Statement statement2=con.createStatement();
   ResultSet rs2=statement2.executeQuery(sqlOrgCnt);
   if (rs2.next())
   {
     CaseCountORG = rs2.getInt("iDetailRowCount"); //計算筆數

	 // 給使用者查不到任何發票資訊的訊息盒_起	
	 if (CaseCountORG==0 && tsInvoiceNo!=null && !tsInvoiceNo.equals(""))
	 {
	   %>
	     <script language="javascript">
		    alert("<jsp:getProperty name='rPH' property='pgNotFoundMsg'/>");
		 </script>
	   <%
	 }
	 // 給使用者查不到任何發票資訊的訊息盒_迄    
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
		   CaseCount = rs3.getInt("CASECOUNT");
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
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td valign="middle" nowrap><font color="#006666" size="3"><strong>&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/></strong></font> 
		  <input type="text" size="15" name="TSINVOICENO" tabindex='4' maxlength="20" value="<%=tsInvoiceNo.toUpperCase()%>" onKeyDown="setSubmit1a('../jsp/TSSHPInvoiceNoUpdate.jsp')">
		  <INPUT TYPE="button" name="QUERY" align="middle"  value="<jsp:getProperty name='rPH' property='pgQuery'/>" onClick="setSubmit('../jsp/TSSHPInvoiceNoUpdate.jsp')" >

        <%  if ((chkQuery=="Y" || chkQuery.equals("Y")) && CaseCountORG !=0 ) { %>		  
		   <INPUT TYPE="button"  name="UPDATE" align="middle"  value="<jsp:getProperty name='rPH' property='pgChange'/>" onClick="setSubmit1('../jsp/TSSHPInvoiceUpdateProcess.jsp')" > 
        <% } %>  
     </tr>
  </table>  
  <hr>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#0066FF" bgcolor="#999FFF" >
  <tr height="30">
    <td width="8%" ><div align="center" ><font size="2"><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></div></td>
    <td width="17%" colspan=3 bgcolor="#FFFFFF"><div align="left" ><font face="Arial" color="#006666" size="2"><%=customerNo%>&nbsp;&nbsp;<%=customerName%></font></div></td>
	<td width="8%"><div align="center" ><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font></div></td>
    <td colspan=4 bgcolor="#FFFFFF"><div align="left"><font  face="Arial" color="#006666" size="2"><%=ShipToOrg%>&nbsp;&nbsp;<%=shipAddress%></font></div></td>
  </tr>
    <tr  height="30"  bgcolor="#999FFF">
	<td width="8%"><div align="center"><font face="Arial" size="2"><strong><jsp:getProperty name="rPH" property="pgShipDate"/></strong></font></div></td>
    <td width="15%" bgcolor="#FFFFFF"><div align="left"><font  face="Arial" color="#006666" size="2"><%=shipDate%></font></div></td>
    <td width="8%"><div align="center"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShippingMethod"/></strong></font></div></td>
    <td width="12%" bgcolor="#FFFFFF"><div align="left"><font  face="Arial" color="#006666" size="2"><%=shipMethod%></font></div></td>
	<td width="10%" ><div align="center" ><font size="2"><strong><jsp:getProperty name="rPH" property="pgFOB"/></strong></font></div></td>
    <td width="8%" bgcolor="#FFFFFF"><div align="left" ><font  face="Arial" color="#006666" size="2"><%=fobPoint%></font></div></td>
	<td width="10%"><div align="center"><font size="2"><strong><jsp:getProperty name="rPH" property="pgPaymentTerm"/></strong></font></div></td>
    <td width="15%" bgcolor="#FFFFFF"><div align="left" ><font  face="Arial" color="#006666" size="2"><%=paymentTerm%></font></div></td>
  </tr>
  </table>
  <table width="100%"  height="25" border="1" cellpadding="-1" cellspacing="-1"  bordercolor="#0066FF" bgcolor="#999FFF">
    <tr > 
	  <td width="3%" ><div align="center"><font size="2">&nbsp;</font></div></td>
      <td width="12%"><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></div></td>
      <td width="5%" ><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgDetail"/><jsp:getProperty name="rPH" property="pgAnItem"/> </font></div></td>            
      <td width="15%"><div align="center" ><font size="2"><jsp:getProperty name="rPH" property="pgPart"/></font></div></td> 
	  <td width="20%"><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></font></div></td> 
	  <td width="20%"><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="5%" ><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgUOM"/></font></div></td> 
	  <td width="10%"><div align="center"><font size="2"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgQty"/>
	  </font></div></td> 
	 
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "#FFCC99";
	     }
	    else{
	       colorStr = "#FFCC66"; }
		printFlag=rsTC.getString("PRINTED_FLAG");
        orderLineId = rsTC.getString("ORDER_LINE_ID");		   
    %>
      <tr bgcolor="#FFFFFF" > 
      <td width="3%"><div align="center"><font size="2" face="Arial"><a name='#<%//=rsTC.getString("ORDER_NUM")%>'>
        <%out.println(rs1__index+1);%>
      </a></font></div></td> 
      <td width="12%" nowrap><div align="center" ><font size="2" color="#006666" face="Arial"><%=rsTC.getString("SALESORDERNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("LINE_NO")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("ITEM_DESC")%></font></div></td>
	  <td width="20%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("CUSTITEMNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("PO_UOM")%></font></div></td>
	  <td width="12%" nowrap><div align="center"><font size="2" color="#006666" face="Arial"><%=rsTC.getString("RCVQTY")%></font></div></td>
      <input type="hidden" name="POHEADERID"  maxlength="5" size="5" value="<%=rsTC.getString("PO_HEADER_ID")%>">
      <input type="hidden" name="POLINEID"  maxlength="5" size="5" value="<%=rsTC.getString("PO_LINE_ID")%>">
     </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
  chkQuery="N";
}
%>
    <tr bgcolor="#999FFF"> 
	<td>
	</td>
	 <td height="23" colspan="10" ><font color="#000066" size="2"></font> 
       
	  &nbsp;&nbsp;<font size="2"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#CC3388' face="Arial"><strong><%=CaseCountORG%></strong></font>
	 </td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  %>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
	
<!--選擇全部,存檔 -->

<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>" >
<input type="hidden" name="CHKQUERY" value="<%=chkQuery%>" >



</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
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
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
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
