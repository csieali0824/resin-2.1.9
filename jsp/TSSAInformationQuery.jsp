<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
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
function setOmGroupFind(Group_ID,Group_Name)
{      
    subWin=window.open("../jsp/subwindow/TSDRQOmGroupInfoFind.jsp?OMGROUPID="+Group_ID+"&OMGROUPNAME="+Group_Name,"subwin");  
}
</script>
<html>
<head>

<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
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
String group_Name = request.getParameter("GROUP_NAME");

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

  if (organizationId==null || organizationId.equals("")) { organizationId="44"; }
  if (spanning==null || spanning.equals("")) spanning = "TRUE";
  
  int iDetailRowCount = 0;


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
  
<FORM ACTION="../jsp/TSSAInformationQuery.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<BR>
  <A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%
 
  sWhereGP = " and c.DNDOCNO IS NOT NULL ";
  
  workingDateBean.setAdjWeek(-1); //out.println("workingDateBean.getWeek()="+workingDateBean.getWeek());
  workingDateBean.setDefineWeekFirstDay(1);  // 設定每週第一天為星期日  
  
  String strFirstDayWeek = workingDateBean.getFirstDateOfWorkingWeek();   // 取起始週第一天
  String strLastDayWeek = workingDateBean.getLastDateOfWorkingWeek();  // 取起始週最後一天 
  String currentWeek = workingDateBean.getWeekString();

/*  檢查使用是否有查詢其它維修點維修單的權限 -- 依登入時的使用者群組 */

if ((dateSetBegin==null || dateSetBegin.equals("")) && (dateSetEnd==null || dateSetEnd.equals("")))
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
		  "       b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
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
			 
   if (prodManufactory==null || prodManufactory.equals("--") || prodManufactory.equals("")) {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
  
   if (status==null || status.equals("--"))  {sWhere=sWhere+" ";}
   else {sWhere=sWhere+" and d.LSTATUSID ='"+status+"'"; }
   
   if (statusCode==null || statusCode.equals("")) { } 
   else if (statusCode.equals("O")) { sWhere=sWhere+" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  } // 只找開單處理中的單據
   else if (statusCode.equals("C")) { sWhere=sWhere+" and d.LSTATUSID in ('010') ";  } // 只找已結案的單據
   else if (statusCode.equals("A")) { sWhere=sWhere+" and d.LSTATUSID in ('012') ";  } // 只找放棄的單據
   //else if (statusCode.equals("P")) { sWhere=sWhere+" and f.ORISTATUSID in ('002','007') ";  }   // 只找企劃處理過的單據 (對應HISTORY 的 ORISTATUSID in ('002','007') )
   //else if (statusCode.equals("F")) { sWhere=sWhere+" and f.ORISTATUSID in ('003','004') ";  } // 只找工廠處理過的單據 (對應HISTORY 的 ORISTATUSID in ('003','004') )
   
			 
   havingGrp = " group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		       "          b.SALES_AREA_NAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
			   "          c.CREATED_BY, c.SALESPERSON, c.REQREASON ";      
   havingGrpSDRQ = " ,f.SDRQCOUNT ";  
   sOrder = "order by c.DNDOCNO";
   //, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";     
      
   // if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("--")) {sWhere=sWhere+" ";}
    if (salesAreaNo!=null && !salesAreaNo.equals("--")) 
	{ 
	 sWhere=sWhere+" and c.TSAREANO ='"+salesAreaNo+"'";
	 
	 if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
     if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'";  
	}
  
    //if (customerId==null || customerId.equals("")) {sWhere=sWhere+" ";}
    else if (customerId!=null && !customerId.equals("") && !customerId.equals("--")) { sWhere=sWhere+" and c.TSCUSTOMERID ='"+customerId+"'"; }
  
    //if (dnDocNoSet==null || dnDocNoSet.equals("")) { }
	else if (dnDocNoSet!=null && !dnDocNoSet.equals("")) { sWhere=sWhere+" and c.dnDocNo ='"+dnDocNoSet+"'"; }
  
    //if (preOrderType==null || preOrderType.equals("") || preOrderType.equals("--")) {sWhere=sWhere+" ";}
    else if (preOrderType!=null && !preOrderType.equals("--")) { sWhere=sWhere+" and to_char(c.ORDER_TYPE_ID) ='"+preOrderType+"'"; }
  
    //if (custPONo==null || custPONo.equals("")) {sWhere=sWhere+" ";}
    else if (custPONo!=null && !custPONo.equals("")) { sWhere=sWhere+" and c.CUST_PO ='"+custPONo+"'"; }
  
    //if (createdBy==null || createdBy.equals("")) {sWhere=sWhere+" ";}
    else if (createdBy!=null && !createdBy.equals("")) { sWhere=sWhere+" and CREATED_BY ='"+createdBy+"'"; }
  
    //if (salesPerson==null || salesPerson.equals("")) {sWhere=sWhere+" ";}
    else if (salesPerson!=null && !salesPerson.equals("")) { sWhere=sWhere+" and SALESPERSON ='"+salesPerson+"'"; }
  
    //if (prodManufactory==null || prodManufactory.equals("")) {sWhere=sWhere+" ";}
    else if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) { sWhere=sWhere+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
  
    //if (status==null || status.equals("--")) {sWhere=sWhere+" ";}
    else if (status!=null && !status.equals("--")) { sWhere=sWhere+" and d.LSTATUSID ='"+status+"'"; }
  
    //if (salesOrderNo==null || salesOrderNo.equals("")) { sWhere=sWhere+" "; }
    else if (salesOrderNo!=null && !salesOrderNo.equals("")) {  sWhere=sWhere+" and d.ORDERNO = '"+salesOrderNo+"' ";  }
	else
	   {
	     if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >="+"'"+dateSetBegin+"'";
         if (DayFr!="--" && DayTo!="--") sWhere=sWhere+" and substr(c.CREATION_DATE,0,8) >= "+"'"+dateSetBegin+"'"+" AND substr(c.CREATION_DATE,0,8) <= "+"'"+dateSetEnd+"'"; 
	   }
 
  SWHERECOND = sWhere+ sWhereGP;
  sSql = sSql + sWhere + sWhereSDRQ + sWhereGP + havingGrp + havingGrpSDRQ + sOrder;
  sSqlCNT = sSqlCNT + sWhere + sWhereGP;
  //out.println("sSqlTT="+sSql);    
   
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
	    <td width="19%" colspan="1" nowrap>
		<font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgSalesArea"/></strong></font>        </td> 
		<td></div>
	    <%
		       try
               { // 動態去取生產地資訊 						  
	               Statement stateGetP=con.createStatement();
                   ResultSet rsGetP = null;				      									  
				   String sqlGetP = " select GROUP_ID,GROUP_NAME " +
			                        " from APPS.TSC_OM_GROUP " +
								    " order by GROUP_NAME ";
                   rsGetP = stateGetP.executeQuery(sqlGetP);
				   comboBoxAllBean.setRs(rsGetP);
		           comboBoxAllBean.setSelection(group_Name);
	               comboBoxAllBean.setFieldName("GROUP_NAME");
                   out.println(comboBoxAllBean.getRsString());
				   stateGetP.close();
		           rsGetP.close();
	            } //end of try		 
                catch (Exception e)  { out.println("Exception:" + e.getMessage()); } 
		   %></td>
		<td width="26%">
		   <font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgFirmOrderType"/> </strong></font>		</td>   
		<td width="23%" colspan="1" nowrap><div align="left"></div>		</td>    
	 </tr>
	 <tr>
	   <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCustomerName"/></strong></font></td>
	   <td colspan="3">
	        <input type="text" size="10" name="CUSTOMERNO" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=customerNo%>">
	        <INPUT TYPE="button"  value="..." onClick='setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)'>
			<input type="text" size="50" name="CUSTOMERNAME" onKeyDown='subWindowCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value)' value="<%=customerName%>">
		</div>	   </td>
	 </tr>
	 <tr>
	    <td nowrap colspan="1"><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgDateFr"/><jsp:getProperty name="rPH" property="pgDateFr"/> </strong></font>        </td> 
		<td>
		   <div align="left">
		   <font color="#006666" size="2"><strong> </strong></font>
		   <%
		         try
                 {   
		           String a[] = {"Order Date","Schedule Ship Date","Actual Shipment Date"};
				   arrayComboBoxBean.setArrayString(a);
		           arrayComboBoxBean.setSelection("Order Date");
	               arrayComboBoxBean.setFieldName("DATETYPE");	   
                   out.println(arrayComboBoxBean.getArrayString());     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
		   </div>		</td> 
		<td>
		   <div align="left">
		   <font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgRepStatus"/> </strong></font>		   </div>		</td>
		<td>   
		   <%
		         try
                 {   
		           String a[] = {"Order","Return"};
				   arrayComboBoxBean.setArrayString(a);
		           arrayComboBoxBean.setSelection("--");
	               arrayComboBoxBean.setFieldName("PREORDERTYPE");	   
                   out.println(arrayComboBoxBean.getArrayString());     	 
                 } //end of try		 
                 catch (Exception e) { out.println("Exception:"+e.getMessage()); } 
		       %>
	    <%
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
		   %>		</td>   
	 </tr>
	 <tr>
	   <td><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></strong></font></td>
	   <td colspan="3">
	        <input type="text" size="10" name="SALESORDERNO" value="<%=salesOrderNo%>">	   </td>
	 </tr>
     <tr>	    
	   <td nowrap colspan="2"><font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font>
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
       <font color="#006666" size="2"><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font>
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
       %>    </td>  
	<td colspan="2">
		    <INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSDRQInformationQuery.jsp")' > 
			<INPUT TYPE="button" align="middle" value='<jsp:getProperty name="rPH" property="pgExcelButton"/>' onClick='setSubmit("../jsp/TSSalesDRQAssignInf2Excel.jsp")' >	</td>
   </tr>
  </table>  
 
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr bgcolor="#99CC99"> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#000000" size="2">&nbsp;</font></div></td> 
	  <td width="2%" height="22" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgProductDetail"/></font></div></td>               
	  <%
	  if (userPlanCenterNo!=null && !userPlanCenterNo.equals(""))
	  {
	     out.println("<td width='2%' height='22' nowrap><div align='center'><font color='#006666' size='2'>");
	  %>	 
		 <jsp:getProperty name="rPH" property="pgApproval"/><jsp:getProperty name="rPH" property="pgOrdCreate"/>
	  <% 
	  	 out.println("</font></div></td>");              
      } // End of if
      %>
	  <td width="9%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgQDocNo"/></font></div></td>
      <td width="20%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>            
      <td width="10%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/></font></div></td> 
	  <td width="12%" nowrap><div align="center"><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgCreateFormDate"/></font></div></td>                    
    </tr>
    <% while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) { %>
	<%//out.println("Step1");
	     //Repeat1__index++;
	     if ((rs1__index % 2) == 0){
	       colorStr = "CCFFCC";
	     }
	    else{
	       colorStr = "CCFFFF"; }
    %>
    <tr bgcolor="<%=colorStr%>"> 
      <td bgcolor="#99CC99" width="2%"><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("DNDOCNO")%>'><%out.println(rs1__index+1);%></a></font></div></td>
	  <td><div align="center"><a href="../jsp/TSSalesDRQHistory.jsp?DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATEBEGIN=<%=dateSetBegin%>&DATEEND=<%=dateSetEnd%>"><img src="../image/docicon.gif" width="14" height="15" border="0"></a></div></td>     	        
      <%
	  try
	  {
  	  if (userPlanCenterNo!=null && !userPlanCenterNo.equals(""))
	  {
	  
		 out.println("<td><div align='center'>");
	     //out.println(rsTC.getString("SDRQCOUNT"));
		 if (rsTC.getString("SDRQCOUNT") != "0" && !rsTC.getString("SDRQCOUNT").equals("0") ) {
		    out.println("<a href='../jsp/TSRFQRegenerateDocumentSetActive.jsp?DNDOCNO="+rsTC.getString("DNDOCNO")+"'>");
		    out.println("<img src='../image/YES.gif' width='14' height='15' border='0'></a>");
		 } else
		 { 
		    out.println("<a>&nbsp;</a>");
		 }
		 out.println("</div></td>");
      }
	  } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }	  
	  %>
	  <td width="9%" nowrap><font size="2" color="#006666"><%=rsTC.getString("DNDOCNO")%></font></td>
      <td width="48%" nowrap><font size="2" color="#006666">
	          <%  // out.println(rsTC.getString("SEGMENT1"));
			    iDetailRowCount = iDetailRowCount + rsTC.getInt("MAXLINE"); // 累加明細數量
			  //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
			       String subColStr = "";
			       if ((rs1__index % 2) == 0)
				   { subColStr = "CCFFFF"; }
	               else{ subColStr = "CCFFCC"; }			    
			       out.println("<table cellSpacing='0' bordercolordark='#99CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='1'>");			 
			       if (spanning=="FALSE" || spanning.equals("FALSE")  )
			       { 
			          out.print("<tr><td nowrap>"); 
					  out.println("<font size='-1' color='#006666'>");
					  %><jsp:getProperty name="rPH" property="pgTotal"/><%
					  out.println(rsTC.getString("MAXLINE"));
					  %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					  out.println("</font>"); %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=TRUE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a>
					  <% 
					    out.println("<font size='-1' color='#006666'>");
					  %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					    out.println(" : "+rsTC.getString("CREATED_BY"));					           
					    out.println("</font>"); 
					  out.println("</td></tr>");
			       } else if ( spanning==null || spanning.equals("") ||  spanning=="TRUE" || spanning.equals("TRUE") )
			              {			    
				             //再判段若是 Entity ID 才顯示明細,點擊符號顯示 MINUS 
				            // if ( dnDocNo ==rsTC.getString("DNDOCNO") || dnDocNo.equals(rsTC.getString("DNDOCNO")) )
				             //{ //out.println("wipEntID="+wipEntID);out.println("rsTC.getString(INVENTORY_ITEM_ID)="+rsTC.getString("INVENTORY_ITEM_ID"));
				               out.print("<tr>");
							   
							   out.println("<td colspan=12>"); 							   
					           out.println("<font size='-1' color='#006666'>");
							   %><jsp:getProperty name="rPH" property="pgCustomerName"/><%
							   out.println(" : "+rsTC.getString("CUSTOMER")+"&nbsp;&nbsp;&nbsp;");
					           %><jsp:getProperty name="rPH" property="pgTotal"/><%
					           out.println(rsTC.getString("MAXLINE"));
					           %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					           out.println("</font>"); 
							   %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=FALSE&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/MINUS.gif" width="14" height="15" border="0"></a>
							   <% 
							     out.println("<font size='-1' color='#006666'>");
					           %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					             out.println(" : "+rsTC.getString("CREATED_BY"));					           
					             out.println("</font></td>");
							   
							   //
							   
							   
							   out.println("</tr>");
							   
							   
							   
				               int iRow = 0; 	
							   
				               String sqlM = "select DISTINCT d.LINE_NO,d.LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
                                                    "TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
											        "d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO,"+
                                                    "e.MANUFACTORY_NAME,d.REMARK "+
										     "from ORADDMAN.TSSALES_AREA b, "+
										          "ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e ";
												  //"ORADDMAN.TSDELIVERY_DETAIL_HISTORY f ";										     
							  String whereM = "where (d.DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' ) "+
							                  //"and d.LINE_NO = f.LINE_NO "+
											  "and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
										        // "or  d.DOCNO || '-' || d.ASSIGN_LNO in ("+distDnDocNo+") ) "+
										      "and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='"+locale+"' ";				
							   String orderM = "order by d.LINE_NO";				   
											   //", TO_CHAR(TO_DATE(a.UPDATEDATE||a.UPDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD:HH24:MI:SS')";
						       if (prodManufactory==null || prodManufactory.equals("--") || prodManufactory.equals("")) {whereM=whereM+" ";}
                               else { whereM=whereM+" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; }
  
                               if (status==null || status.equals("--")) {whereM=whereM+" ";}
                               else { whereM=whereM+" and d.LSTATUSID ='"+status+"'"; }
							   
							   if (statusCode==null || statusCode.equals("")) { } 
                               else if (statusCode.equals("O")) { whereM=whereM+" and d.LSTATUSID in ('001','002','003','004','007','008','009','013') ";  } // 只找開單處理中的單據
                               else if (statusCode.equals("C")) { whereM=whereM+" and d.LSTATUSID in ('010') ";  } // 只找已結案的單據
                               else if (statusCode.equals("A")) { whereM=whereM+" and d.LSTATUSID in ('012') ";  } // 只找放棄的單據
                               else if (statusCode.equals("P")) { whereM=whereM+" and f.ORISTATUSID in ('002','007') ";  }   // 只找企劃處理過的單據 (對應HISTORY 的 ORISTATUSID in ('002','007') )
                               else if (statusCode.equals("F")) { whereM=whereM+" and f.ORISTATUSID in ('003','004') ";  } // 只找工廠處理過的單據 (對應HISTORY 的 ORISTATUSID in ('003','004') )
							   
							   sqlM = sqlM + whereM + orderM;
							   			
							   
							   
				               Statement stateM=con.createStatement();
							   //out.println(sqlM);
                               ResultSet rsM=stateM.executeQuery(sqlM); 							  
				               while (rsM.next())
				               { 
							    if (iRow==0 ) // 若第一筆資料才列印標頭列 //
								{ 
								out.println("<tr align='center' bgcolor='#CC3366'><td width='1%' nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRepStatus"/><%								
								out.println("<td width='1%' nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgAnItem"/><%								
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgUOM"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgQty"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRequestDate"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgPCAssignDate"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgFTArrangeDate"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgPCConfirmDate"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgOrdCreateDate"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgRepStatus"/><%
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");								
								%><jsp:getProperty name="rPH" property="pgProdFactory"/><%								
								out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
								%><jsp:getProperty name="rPH" property="pgSalesOrderNo"/><%	
								out.println("</font></td></tr>");
								
								}// End of if (iRow==0)
								
								out.println("<tr bgcolor="+subColStr+">");
								
								//業務confirmdate是否超過24小時
							   String sqlC = " select A.DNDOCNO,A.LINE_NO,A.ASSIGN_DATE,B.COMPLETE_DATE, "+
                                             " round((nvl(TO_DATE(B.COMPLETE_DATE,'YYYYMMDDhh24miss'),sysdate) - TO_DATE(A.ASSIGN_DATE,'YYYYMMDDhh24miss')) * 24,2) countHour "+
                                             " from  "+
                                             "    (select DNDOCNO,LINE_NO,ORISTATUSID,CDATETIME as ASSIGN_DATE "+
                                             "       from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
                                             "      where DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' and LINE_NO = '"+rsM.getString("LINE_NO")+"' and ORISTATUSID='002' ) A, "+
                                             "    (select DNDOCNO,LINE_NO,ORISTATUSID,max(CDATETIME) as COMPLETE_DATE  "+
                                             "       from ORADDMAN.TSDELIVERY_DETAIL_HISTORY "+
                                             "      where DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' and LINE_NO = '"+rsM.getString("LINE_NO")+"' and ORISTATUSID='008'  "+
											 "		group by DNDOCNO,LINE_NO,ORISTATUSID ) B "+
											 "  where a.dndocno=b.dndocno(+) ";
							   sqlC = sqlC  ; 
							    Statement stateC=con.createStatement();
							   //out.println(sqlC);
                               ResultSet rsC=stateC.executeQuery(sqlC); 
							   if (rsC.next())
							   {
							   
							    if (rsC.getInt("countHour") >= 2 )
							    {out.println("<td align='center' width='1%' nowrap><img src='../image/light_red.gif' width='14' height='15' border='0'></td>");}
								else {out.println("<td align='center' width='1%' nowrap><img src='../image/light_green.gif' width='14' height='15' border='0'></td>");}
							   }								
							   rsC.close();
				               stateC.close();
								 
				                out.println("<td width='1%' nowrap><font size='-2' color='#006666'>"+rsM.getString("LINE_NO")+"</font></td>");								
								out.println("<td nowrap><font size='-2' color='#CC0066'>"+rsM.getString("ITEM_DESCRIPTION")+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("UOM")+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("QUANTITY")+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString(6)+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>");
								if (rsM.getString("PCCFMDATE")==null || rsM.getString("PCCFMDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCCFMDATE").substring(0,4)+"/"+rsM.getString("PCCFMDATE").substring(4,6)+"/"+rsM.getString("PCCFMDATE").substring(6,8)); 
								out.println("</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>");
								if (rsM.getString("FTACPDATE")==null || rsM.getString("FTACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("FTACPDATE").substring(0,4)+"/"+rsM.getString("FTACPDATE").substring(4,6)+"/"+rsM.getString("FTACPDATE").substring(6,8)); 
								out.println("</font></td>");								
								out.println("<td nowrap><font size='-2' color='#006666'>");
								if (rsM.getString("PCACPDATE")==null || rsM.getString("PCACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCACPDATE").substring(0,4)+"/"+rsM.getString("PCACPDATE").substring(4,6)+"/"+rsM.getString("PCACPDATE").substring(6,8)); 
								out.println("</font></td>");								
								out.println("<td nowrap><font size='-2' color='#006666'>");
								if (rsM.getString("SASCODATE")==null || rsM.getString("SASCODATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("SASCODATE").substring(0,4)+"/"+rsM.getString("SASCODATE").substring(4,6)+"/"+rsM.getString("SASCODATE").substring(6,8)); 
								out.println("</font></td>");								
								out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("LSTATUS")+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("MANUFACTORY_NAME")+"</font></td>");
								out.println("<td nowrap><font size='-2' color='#006666'>");
								if (rsM.getString("ORDERNO")==null || rsM.getString("ORDERNO").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("ORDERNO")); 
								out.println("</font></td>");
				                out.println("</tr>");
								
								iRow++;
				               } // End of while
				               rsM.close();
				               stateM.close();
							  							   
				           //  }  // End of if (dnDocNo ==rsTC.getString("DNDOCNO") || dnDocNo.equals(rsTC.getString("DNDOCNO"))) 
							  /*
							     else {  // 否則只顯示 PLUS 符號
				                        out.print("<tr><td nowrap>"); 
										//out.println("<font size='-1' color='#006666'>"+rsTC.getString("DNDOCNO")+"</font>"); 
										out.print("<tr><td nowrap>"); 
					                    out.println("<font size='-1' color='#006666'>");
					                    %><jsp:getProperty name="rPH" property="pgTotal"/><%
					                    out.println(rsTC.getString("MAXLINE"));
					                    %><jsp:getProperty name="rPH" property="pgItemQty"/><%
					                    out.println("</font>"); 
										 %><a href="../jsp/TSSDRQInformationQuery.jsp?SPANNING=TRUE&ORGANIZATION_ID=<%=organizationId%>&DNDOCNO=<%=rsTC.getString("DNDOCNO")%>&DATESETBEGIN=<%=dateSetBegin%>&DATESETEND=<%=dateSetEnd%>#<%=rsTC.getString("DNDOCNO")%>"><img src="../image/PLUS.gif" width="14" height="15" border="0"></a>
										 <% 
										 out.println("<font size='-1' color='#006666'>");
					                     %><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
					                     out.println(" : "+rsTC.getString("CREATED_BY"));					           
					                     out.println("</font>");
										out.println("</td></tr>");    
										
				                     }  // End of else
									 */
			            }  // End of else if (spannin==null)
			            out.println("</table>");   
			  
			  
			  %></font></td> 
	  <td width="10%" nowrap><div align="center"><strong><font size="2" color="#CC3366"><%=rsTC.getString("SALESPERSON")%></font></strong></div></td>
	  <td width="12%" nowrap><div align="center"><strong><font size="2" color="#CC3366"><%=rsTC.getString(6)%></font></strong></div></td>                 
    </tr>
    <%
  rs1__index++;
  rs_hasDataTC = rsTC.next();
}
%>
    <tr bgcolor="#99CC99"> 
      <td height="23" colspan="10" ><font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
        <% 
	      if (CaseCount==0) 
		  { //out.println("<input type='hidden' name='STRQUERYFLAG' value='' size='1'  readonly=''>"); 
		  } 
		  else { out.println("<input type='hidden' name='STRQUERYFLAG' value='Y' size='1'  readonly=''>"); }
		  
		  workingDateBean.setAdjWeek(1);  // 把週別調整回來
		  
	 %><input type="hidden" name="CASECOUNT" value=<%=CaseCount%> size="5" readonly="">
	 <font color='#000066' face="Arial"><strong><em><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color="#006666" size="2"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#000066' face="Arial"><strong><%=iDetailRowCount%></strong></font>
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
<input type="hidden" name="CUSTOMERID"  maxlength="5" size="5" value="<%=customerId%>">
<input type="hidden" name="CUSTACTIVE"  maxlength="5" size="5" value="<%=custActive%>">
<input type="hidden" name="ORGANIZATION_CODE" value="<%=organizationCode%>"  maxlength="25" size="25">
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
//rsAct.close();
//stateAct.close();  // 結束Statement Con
//ConnRpRepair.close();
%>
