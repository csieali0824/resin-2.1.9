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
function setSubmit1(URL)
{ 

  if (document.MYFORM.TSINVOICENO.value ==""  && document.MYFORM.TSINVOICENO.value=="null" )
  {
    alert("Please Assign TS Invoice Number!!!");
	return false; 
  } 
  else
  {
 	document.MYFORM.CUSTOMERNO.value ="";
 	document.MYFORM.CUSTOMERNAME.value ="";
	document.MYFORM.SHIPTOORG.value ="";
	document.MYFORM.SHIPADDRESS.value ="";
 	document.MYFORM.SHIPDATE.value ="";
	document.MYFORM.SHIPMETHOD.value ="";
	document.MYFORM.FOBPOINT.value ="";
 	document.MYFORM.PAYMENTTERM.value ="";
	document.MYFORM.CHKDEL.value='N';
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
}  

function setSubmit1a(URL)
{ 

 if (event.keyCode==13)
 {
   if (document.MYFORM.TSINVOICENO.value ==""  && document.MYFORM.TSINVOICENO.value=="" )
    {
     alert("Please Assign TS Invoice Number!!!");
	  return false; 
    } 
   else
    {
	 document.MYFORM.CUSTOMERNO.value ="";
 	 document.MYFORM.CUSTOMERNAME.value ="";
	 document.MYFORM.SHIPTOORG.value ="";
	 document.MYFORM.SHIPADDRESS.value ="";
 	 document.MYFORM.SHIPDATE.value ="";
	 document.MYFORM.SHIPMETHOD.value ="";
	 document.MYFORM.FOBPOINT.value ="";
 	 document.MYFORM.PAYMENTTERM.value ="";
     document.MYFORM.CHKDEL.value='N';
     document.MYFORM.action=URL;
     document.MYFORM.submit();
    }//end else
   }
}//end if function

function setSubmit2(URL)
{    
 document.MYFORM.TSINVOICENO.value ="";
 document.MYFORM.CUSTOMERNO.value ="";
 document.MYFORM.CUSTOMERNAME.value ="";
 document.MYFORM.SHIPTOORG.value ="";
 document.MYFORM.SHIPADDRESS.value ="";
 document.MYFORM.SHIPDATE.value ="";
 document.MYFORM.SHIPMETHOD.value ="";
 document.MYFORM.FOBPOINT.value ="";
 document.MYFORM.PAYMENTTERM.value ="";
 document.MYFORM.CHKDEL.value='N'; 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}

function setSubmit3(URL)
{ 
  
  if (document.MYFORM.TSINVOICENO.value ==""  && document.MYFORM.TSINVOICENO.value=="" ) 
  {
    alert("Please Assign TS Invoice Number!!!");
	return false; 
  } 
  else
  {
 	document.MYFORM.CUSTOMERNO.value ="";
	document.MYFORM.CUSTOMERNAME.value ="";
 	document.MYFORM.SHIPTOORG.value ="";
 	document.MYFORM.SHIPADDRESS.value ="";
 	document.MYFORM.SHIPDATE.value ="";
 	document.MYFORM.SHIPMETHOD.value ="";
 	document.MYFORM.FOBPOINT.value ="";
 	document.MYFORM.PAYMENTTERM.value ="";
    document.MYFORM.CHKDEL.value='N';
   	document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
} 


function setSubmit5(URL)
{ 
    document.MYFORM.action=URL;
    document.MYFORM.submit();
 
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
 if((year%4==0&&year%100!=0)||(year%400==0)) 
 { 
 return true; 
 }  
 return false; 
} 


function check(field) 
{
 if (checkflag == "false") 
 {
    for (i = 0; i < field.length; i++)
    {  field[i].checked = true; }
     checkflag = "true";
   return "Cancel Selected";
}
else {
       for (i = 0; i < field.length; i++) 
       {  field[i].checked = false; }
       checkflag = "false";
       return "Select All";
	 }
}
</script>
<html>
<head>

<title>Invoice Information Query</title>
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
   String poUom = request.getParameter("PO_UOM");
   String chkDel = request.getParameter("CHKDEL");
   String dsLineId = request.getParameter("DS_LINE_ID");  
   String confirmDate = request.getParameter("CONFIRM_DATE");
   String confirmBy = request.getParameter("CONFIRM_BY");   
   String totalAmt = request.getParameter("TOTALAMT"); 
   String currencyCode = request.getParameter("CURRENCY_CODE"); 

   shipDate ="";
   shipAddress="";
   
  
  
  String sqlGlobal = "";
  String sWhereGlobal = "";
  
  if (totalAmt==null || totalAmt.equals("null")) totalAmt="0"; 
  if (currencyCode==null || currencyCode.equals("")) currencyCode=""; 
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
  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  if (tsInvoiceNo==null) tsInvoiceNo = "";
  if (confirmDate==null) confirmDate = "";  
  if (confirmBy==null) confirmBy = "";  
  

  int iDetailRowCount = 0;
  

  
 // if (shipDate==null || shipDate.equals("")) shipDate = dateBean.getYearMonthDay();


    // 因關聯 訂單主檔及明細檔,故需呼叫SET Client Information Procedure
     String clientID = "";
	 if (organizationId=="46" || organizationId.equals("46"))
	 {  clientID = "42"; }
	 else { clientID = "41"; }
  
     //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	 cs1.setString(1,clientID);  /*  41 --> 為半導體  42 --> 為事務機 */
	 cs1.execute();
    // out.println("Procedure : Execute Success !!! ");
     cs1.close();
	 
  //  


%>
<% /* 建立本頁面資料庫連線  */ %>
<style type="text/css">
<!--
.style2 {
	color: #FF0099;
	font-weight: bold;
}
.style4 {
	color: #000099;
	font-weight: bold;
}
.style7 {color: #0080FF; font-weight: bold; }
.style9 {color: #0080FF}
.style14 {color: #003300}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>  
<FORM ACTION="TSSHPInvoiceAdd.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<%
    try
	{
	   if (selectFlag!=null  && chkDel.equals("Y")) // 將被選取的line做delete
	   {
	     for (int i=0;i<selectFlag.length;i++)
		 {
		    String sql ="delete from APPS.TSC_DROPSHIP_SHIP_LINE where DS_LINE_ID = '"+selectFlag[i]+"' ";
			//out.println("sql="+sql);
            PreparedStatement pstmt=con.prepareStatement(sql); 
			pstmt.executeUpdate(); 
            pstmt.close(); 
			
		 }
		 
		 //計算該invoice的line table裡明細是否都被刪除,沒有明細資料者invoice no 在 header table亦一併刪除
		 String sqllinecount = " select COUNT(A.TSINVOICENO) as LINECOUNT from APPS.TSC_DROPSHIP_SHIP_LINE A "+
                               " where A.TSINVOICENO = '"+tsInvoiceNo+"'";
		 //out.println("<BR>sqllinecount="+sqllinecount);
		 Statement statelinecount=con.createStatement();
         ResultSet rslinecount=statelinecount.executeQuery(sqllinecount);
		 if (rslinecount.next())
		  {
			 if (rslinecount.getInt("LINECOUNT") == 0 )//刪除header中的invoiceno
		      {
		       String sqlinvDel = " delete from APPS.TSC_DROPSHIP_SHIP_HEADER where TSINVOICENO = '"+tsInvoiceNo+"'";
			   //out.println("<BR>sqlinvdel="+sqlinvDel);
               PreparedStatement pstmt=con.prepareStatement(sqlinvDel); 
			   pstmt.executeUpdate(); 
               pstmt.close(); 
		      }
		 
		     rslinecount.close();
             statelinecount.close();	
	      }
	  } //end (selectFlag!=null)if 
    } //end of try
    catch (Exception e)
    {
      out.println("Exception:"+e.getMessage());
    }   


    try
	{
	   if (tsInvoiceNo!=null)
       {
         String sqlInvNo =  " select A.TSINVOICENO,A.SHIPDATE,A.CUSTOMERNO,A.CUSTOMERNAME,B.LINE_STATUS AS STATUS, "+
       						"        A.SHIPTOORG,A.SHIPADDRESS,A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM,A.CURRENCY_CODE , "+
                            "        B.SALESORDERNO,B.LINE_NO,B.INV_ITEM,B.ITEM_DESC,B.CUSTITEMNO,B.PO_UOM,B.RCVQTY "+
                            "   from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B "+
                            "  where A.TSINVOICENO=B.TSINVOICENO "+
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
		    currencyCode   = rsInvNo.getString("CURRENCY_CODE");
			salesOrderNo    = rsInvNo.getString("SALESORDERNO");
			line_No        = rsInvNo.getString("LINE_NO");
			invItem        = rsInvNo.getString("INV_ITEM");
			itemDesc       = rsInvNo.getString("ITEM_DESC");
			custItemNo     = rsInvNo.getString("CUSTITEMNO");
			poUom          = rsInvNo.getString("PO_UOM");
			rcvQty         = rsInvNo.getString("RCVQTY");
			status         = rsInvNo.getString("STATUS");	
					
		  }
		   rsInvNo.close();
           stateInvNo.close();	
	     } 
//計算發票總金額
         String Sqla=" select sum(rcvqty*unit_selling_price)*decode(PO_UOM,'KPC',1000,'PCE',1) as TOTALAMT "+
                     " from tsc_dropship_ship_line where tsinvoiceno=upper('"+tsInvoiceNo+"') group by PO_UOM  ";
         Statement statea=con.createStatement();
         ResultSet rsa=statea.executeQuery(Sqla);
		 if (rsa.next())
		 {
			totalAmt = rsa.getString("TOTALAMT");	
         }
		   rsa.close();
           statea.close();	
           if (totalAmt==null || totalAmt.equals("null")) totalAmt="0"; 
	} //end of try
    catch (Exception e)
    {
          out.println("Exception:"+e.getMessage());
    }   
	
%>


<%
 
  sWhereGP = " ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  找尋合法的發票資訊 */


        sSql =  " select B.SALESORDERNO||'-'|| B.LINE_NO as SELECTFLAG, A.TSINVOICENO,A.SHIPDATE,A.CUSTOMERNO,A.CUSTOMERNAME,B.LINE_STATUS AS STATUS, "+
       			"        A.CONFIRM_DATE,A.CONFIRM_BY,A.SHIPTOORG,A.SHIPADDRESS,A.SHIPMETHOD,A.FOBPOINT,A.PAYTERM, "+
                "        B.SALESORDERNO,B.LINE_NO,B.INV_ITEM,B.ITEM_DESC,B.CUSTITEMNO,B.PO_UOM,B.RCVQTY,B.DS_LINE_ID,B.PO_NUM ";
                           
							
String sFrom =  "   from APPS.TSC_DROPSHIP_SHIP_HEADER A,APPS.TSC_DROPSHIP_SHIP_LINE B " ;


   sSqlCNT     = "  select count(distinct A.TSINVOICENO) as CASECOUNT ";
   sSqlCNTITEM = "  select count(B.LINE_NO) as iDetailRowCount ";

   sWhere =  "  where A.TSINVOICENO=B.TSINVOICENO "+
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
     CaseCountORG = rs2.getInt("iDetailRowCount"); 
	 
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
  
 /* 
         String Sqla="select STATUS from APPS.TSC_DROPSHIP_SHIP_HEADER  where TSINVOICENO ='"+tsInvoiceNo+"' ";
         Statement statelrsac=con.createStatement();
         ResultSet rsa=statelrsac.executeQuery(Sqla);
		 if (rsa.next())
		  {
		   status_Code=request.getParameter("STATUS"); 
    	   //out.println("Sqla="+Sqla);
		   out.print("status_Code="+status_Code);  
		   	   }
        rsa.close();
        statelrsac.close();	
    */      
}

%>  
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td valign="middle" nowrap><font color="#006666" size="3"><strong>&nbsp;&nbsp;&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/></strong></font> 
		  <input type="text" size="15" name="TSINVOICENO" tabindex='4' maxlength="20" value="<%=tsInvoiceNo.toUpperCase()%>" onKeyDown="setSubmit1a('../jsp/TSSHPInvoiceQuery.jsp')">
		  <INPUT TYPE="button" name="QUERY" align="middle"  value="<jsp:getProperty name='rPH' property='pgQuery'/>" onClick="setSubmit1('../jsp/TSSHPInvoiceQuery.jsp')" >
		  <INPUT type="reset" name="RESET" align="middle"  value="<jsp:getProperty name='rPH' property='pgReset'/>"  onClick="setSubmit2('../jsp/TSSHPInvoiceQuery.jsp')">
	      <INPUT TYPE="button"  name="ADDMO" align="middle"  value="<jsp:getProperty name='rPH' property='pgAdd'/><jsp:getProperty name='rPH' property='pgShipType'/><jsp:getProperty name='rPH' property='pgDetail'/>" onClick="setSubmit3('../jsp/TSSHPInvoiceAdd.jsp')" >     
	   </td>
    </tr>
  </table>  
  <hr>
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolor="#CCCCCC" bordercolorlight="#999999" bordercolordark="#FFFFFF" bgcolor="#FFCC66">
  <tr>
    <td width="10%" height="22" nowrap bordercolor="#FFFFFF" bgcolor="#CCFFCC"><div align="center" class="style2 style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></div></td>
    <td colspan=3 width="30%" height="22" nowrap bordercolor="#FFFFFF" bgcolor="#CCFFCC"><div align="left" class="style7"><font size="2"><input type="text" size="5" name="CUSTOMERNO" value="<%=customerNo%>" readonly>
	<input type="text" size="40" name="CUSTOMERNAME" value="<%=customerName%>" readonly></font></div></td>
	<td width="10%" height="22" nowrap bordercolor="#FFFFFF" bgcolor="#CCFFCC"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgAddr"/></strong></font></div></td>
    <td colspan=4 width="30%" height="22" nowrap bordercolor="#FFFFFF" bgcolor="#CCFFCC"><div align="left" class="style9"><font size="2"><input type="text" size="5" name="SHIPTOORG" value="<%=ShipToOrg%>" readonly>
	<input type="text" size="50" name="SHIPADDRESS" value="<%=shipAddress%>" readonly></font></div></td>
  </tr>
    <tr bordercolor="#FFFFFF">
	<td width="10%" height="22" nowrap bgcolor="#CCFFCC"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShipDate"/></strong></font></div></td>
    <td width="10%" height="22" nowrap bgcolor="#CCFFCC"><div align="left" class="style9"><font size="2"><input type="text" size="15" name="SHIPDATE" value="<%=shipDate%>" readonly></font></div></td>
    <td width="10%" height="22" nowrap bgcolor="#CCFFCC"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgShippingMethod"/></strong></font></div></td>
    <td width="15%" height="22" nowrap bgcolor="#CCFFCC"><div align="left" class="style9"><font size="2"><input type="text" size="20" name="SHIPMETHOD" value="<%=shipMethod%>" readonly></font></div></td>
	<td width="10%" height="22" nowrap bgcolor="#CCFFCC"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgFOB"/></strong></font></div></td>
    <td width="15%" height="22" nowrap bgcolor="#CCFFCC"><div align="left" class="style9"><font size="2"><input type="text" size="15" name="FOBPOINT" value="<%=fobPoint%>" readonly></font></div></td>
	<td width="10%" height="22" nowrap bgcolor="#CCFFCC"><div align="center" class="style9"><font size="2"><strong><jsp:getProperty name="rPH" property="pgPaymentTerm"/>	</strong></font></div></td>
    <td width="15%" height="22" nowrap bgcolor="#CCFFCC"><div align="left" class="style9"><font size="2"><input type="text" size="15" name="PAYMENTTERM" value="<%=paymentTerm%>" readonly></font></div></td>
  </tr>
  </table>
  <table width="100%">
    <tr bgcolor="#99CC99"> 
	  <td width="3%" height="22" nowrap><div align="center" class="style14"><font size="2">&nbsp;</font></div></td> 
	  <td width="8%" height="22" nowrap><div align="center" class="style14"><font size="2">
	    <input name="SELECTALL" type=button onClick="this.value=check(this.form.SELECTFLAG)" value='<jsp:getProperty name="rPH" property="pgSelectAll"/>'>
	  </font></div></td> 
      <td width="12%" nowrap><div align="center" class="style14"><font size="2">
        <jsp:getProperty name="rPH" property="pgSalesOrderNo"/>
      </font></div></td>
      <td width="5%" nowrap><div align="center" class="style14"><font size="2">
        <jsp:getProperty name="rPH" property="pgDetail"/>
        <jsp:getProperty name="rPH" property="pgAnItem"/>
      </font></div></td>            
      <td width="15%" nowrap><div align="center" class="style14"><font size="2">
        <jsp:getProperty name="rPH" property="pgPart"/>
      </font></div></td> 
	  <td width="18%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></font></div></td> 
	  <td width="18%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="5%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgUOM"/></font></div></td> 
	  <td width="8%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td> 
	  <td width="15%" nowrap><div align="center" class="style14"><font size="2"> <jsp:getProperty name="rPH" property="pgPono"/></font></div></td> 
	 <td width="5%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgRepStatus"/></font></div></td> 
	 <td width="5%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgConfirm"/><jsp:getProperty name="rPH" property="pgProcessDate"/></font></div></td> 
	 <td width="5%" nowrap><div align="center" class="style14"><font size="2">
	    <jsp:getProperty name="rPH" property="pgConfirm"/><jsp:getProperty name="rPH" property="pgAccount"/></font></div></td>  			 		
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCFFCC";
	     }
	    else{
	       colorStr = "CCFFFF"; }
		   
       confirmDate    = rsTC.getString("CONFIRM_DATE");	
	   confirmBy      = rsTC.getString("CONFIRM_BY");	
       if (confirmDate==null) confirmDate = "";  
       if (confirmBy==null) confirmBy = "";				
   
    %>
		
   <font face="Arial, Helvetica, sans-serif"> <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#99CC99" width="3%"><div align="center"><font size="2" color="#006666"><a name='#<%//=rsTC.getString("ORDER_NUM")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td width="2%"> <div align="center"><font size="2" color="#000000">
	    <% 
		  if (rsTC.getString("STATUS")=="OPEN" || rsTC.getString("STATUS").equals("OPEN") || rsTC.getString("STATUS")=="")
	        { %> <input type="checkbox" name="SELECTFLAG" value="<%=rsTC.getString("DS_LINE_ID")%>"> <% } %>
	  </font></div> </td>     	        
      <td width="12%" nowrap><div align="center" class="style4"><font size="2" color="#CC3366"><%=rsTC.getString("SALESORDERNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("LINE_NO")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("ITEM_DESC")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("CUSTITEMNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("PO_UOM")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("RCVQTY")%></font></div></td>
	  <td width="15%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("PO_NUM")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#CC3366"><%=rsTC.getString("STATUS")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font size="2" color="#CC3366"><%=confirmDate%></font></div></td>	
	  <td width="5%" nowrap><div align="center"><font size="2" color="#CC3366"><%=confirmBy%></font></div></td>	
     </tr></font>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#99CC99"> 
	<td>
	</td>
	<td align="center"> <INPUT name="DELETE" TYPE="button" onClick='setSubmit5("../jsp/TSSHPInvoiceQuery.jsp?CHKDEL=Y")'  value='<jsp:getProperty name="rPH" property="pgDelete"/>' > </td>
      <td height="23" colspan="4" ><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#CC3388' face="Arial"><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#CC3388' face="Arial"><strong><%=CaseCountORG%></strong></font></td>
     <td ><div align="right"><font color="#006666" face="Arial" size="2">Invoice Total Amount=</font></div></td> 
     <td colspan="6"><font color="#CC3388" face="Arial" size="3"><strong>&nbsp;<%=totalAmt+"  ("+currencyCode+")"%></strong></font></td>      
    </tr>
  </table>
  <!--%每頁筆●顯示筆到筆總共有資料%-->
  <div align="center"> <font color="#993366" size="2">
    <% if (rs_isEmptyTC ) {  
	customerNo="";
	customerName="";
	ShipToOrg=""; 
	shipAddress="";
	shipMethod="";
	fobPoint="";
	paymentTerm="";	
	%>
    <strong>No Record Found</strong> 
    <% } /* end RpRepair_isEmpty */ %>
    </font> </div>
	
<!--選擇全部,存檔 -->

<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<input type="hidden" name="SWHERECOND" value="<%=SWHERECOND%>" maxlength="256" size="256">
<input type="hidden" name="SPANNING"  maxlength="5" size="5" value="<%=spanning%>">
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
<input type="hidden" name="CHKDEL"  maxlength="5" size="5" value="<%=chkDel%>">


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
