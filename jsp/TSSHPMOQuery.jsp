<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">

function setSubmit(URL)
{ 

  if (document.MYFORM.SALESORDERNO.value ==""  && document.MYFORM.SALESORDERNO.value=="null" )
  {
    alert("Please Assign Sales Order Number!!!");
	return false; 
  } 
  else
  {
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
}  

function setSubmit1a(URL)
{ 

 if (event.keyCode==13)
 {
   if (document.MYFORM.SALESORDERNO.value ==""  && document.MYFORM.SALESORDERNO.value=="null" )
    {
     alert("Please Assign Sales Order Number!!!");
	  return false; 
    } 
   else
    {
     document.MYFORM.action=URL;
     document.MYFORM.submit();
    }//end else
   }
}//end if function


</script>
<html>
<head>

<title>SalesOrder Information Query</title>
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
   String poNum = request.getParameter("PO_NUM");
   String poUom = request.getParameter("PO_UOM");
   String chkDel = request.getParameter("CHKDEL");
   String dsLineId = request.getParameter("DS_LINE_ID");  
   String confirmDate = request.getParameter("CONFIRM_DATE");
   String confirmBy = request.getParameter("CONFIRM_BY");   
   int iRow=0;

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
  if (salesOrderNo==null || salesOrderNo.equals("")) salesOrderNo="0";
  
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
  
  int caseCount=0;
  int iDetailRowCount = 0;
  
  if ((iRow % 2) == 0)
     { colorStr = "CCFFCC"; }
  else
     { colorStr = "CCFFFF"; }
  
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
.style4 {
	color: #000099;
	font-weight: bold;
}
.style16 {color: #FF0000}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%>   
<FORM ACTION="TSSHPInvoiceAdd.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong>
<jsp:getProperty name="rPH" property="pgTSCAlias"/>
<jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgQuery"/></strong></font>
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<%


        sSql =  " select H.TSINVOICENO,H.SHIPDATE,H.CUSTOMERNO,H.CUSTOMERNAME,H.SHIPTOORG,H.SHIPMETHOD,L.SALESORDERNO,L.CUSTOMER_PN, "+
       			"	     H.FOBPOINT,L.LINE_NO,L.INV_ITEM,L.ITEM_DESC,L.CUSTITEMNO,L.RCVQTY,L.PO_UOM,L.PO_NUM,H.CONFIRM_DATE,H.CONFIRM_BY ";
                           
String sFrom =  "   from TSC_DROPSHIP_SHIP_HEADER H, TSC_DROPSHIP_SHIP_LINE L  " ;

   sSqlCNT     = "  select count(distinct H.TSINVOICENO) as CASECOUNT ";
   sSqlCNTITEM = "  select count(L.DS_LINE_ID) as iDetailRowCount ";

   // sWhere =  "  where H.DS_HEADER_ID=L.DS_HEADER_ID  and   L.SALESORDERNO = "+salesOrderNo ;
     sWhere =  "  where H.DS_HEADER_ID=L.DS_HEADER_ID  and  (L.SALESORDERNO like '"+salesOrderNo+"' or L.CUSTOMER_PN like '"+custPONo+"')" ; //2006/06/23 新增亦可輸入CUSTOM_PN查詢 
 sOrderBy =  " order by H.TSINVOICENO ";			 


  sSql = sSql + sFrom + sWhere + sOrderBy ;
  sSqlCNT = sSqlCNT  + sFrom + sWhere ;
  sSqlCNTITEM = sSqlCNTITEM + sFrom + sWhere ;
  //out.println("sSqlCNT ="+sSqlCNT ); 
  //out.println("sSqlCNT ="+sSqlCNTITEM ); 
  //out.println("sSqlTT="+sSql);    
 
   String sqlOrgCnt ="  select count(L.DS_LINE_ID) as iDetailRowCount ";
  // sqlOrgCnt = sqlOrgCnt +  sFrom+sWhere + sWhereGP + havingGrp;
    sqlOrgCnt = sqlOrgCnt +  sFrom + sWhere ;
  // out.println("<BR>sqlOrgCnt="+sqlOrgCnt);
 
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

 //計算筆數 
   Statement statementcnt=con.createStatement();
   ResultSet rscnt=statementcnt.executeQuery(sSqlCNT);
   if (rscnt.next())
   {
     CaseCount = rscnt.getInt("CASECOUNT");   
    //out.println("caseCount"+caseCount);  
   }
   rscnt.close();
   statementcnt.close(); 
 
 

Statement statementTC=con.createStatement(); 
ResultSet rsTC=statementTC.executeQuery(sSql);
%>

 
  <table cellSpacing='0' bordercolordark='#CCCC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>
     <tr>
	    <td width="20%" valign="middle" nowrap><font color="#006666" size="3"><strong>&nbsp;&nbsp;&nbsp;&nbsp;
          <jsp:getProperty name="rPH" property="pgSalesOrderNo"/></strong></font>
	      <input type="text" size="15" name="SALESORDERNO" tabindex='4' maxlength="20" value="<%=salesOrderNo%>" onKeyDown="setSubmit1a('../jsp/TSSHPMOQuery.jsp')">
	    </td>
		<td width="20%" valign="middle" nowrap><font color="#006666" size="3"><strong>&nbsp;&nbsp;&nbsp;&nbsp;Customer PO</strong></font> 
		  <input type="text" size="15" name="CUSTPONO" tabindex='4' maxlength="20" value="<%=custPONo%>" onKeyDown="setSubmit1a('../jsp/TSSHPMOQuery.jsp')">
		  </td>
		<td width="20%" valign="middle" nowrap>		  
          <INPUT TYPE="button" name="QUERY" align="middle"  value="<jsp:getProperty name='rPH' property='pgQuery'/>" onClick="setSubmit('../jsp/TSSHPMOQuery.jsp')" >
		</td>
     </tr>
  </table>
 <% 
try
{  
  while (rsTC.next())  
  {  
    if (iRow==0) //列印表頭列
   { %>

  <table width="100%">
    <tr bgcolor="#0080CC" > 
	  <td width="3%" height="22" nowrap><div align="center" ><font color="#FFFFFF" size="2"> &nbsp;</font></div></td> 
	  <td width="8%" height="22" nowrap><div align="center" ><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/></font></div></td> 
      <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgSalesOrderNo"/></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgCustPONo"/></font></div></td>
      <td width="2%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgShipDate"/></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgCustNo"/></font></div></td>            
      <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgCustomerName"/></font></div></td>       
      <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgShippingMethod"/></font></div></td> 
      <td width="5%" nowrap><div align="center" ><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgFOB"/></font></div></td> 
      <td width="2%" nowrap><div align="center" ><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgAnItem"/></font></div></td> 
      <td width="15%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgPart"/></font></div></td> 
	  <td width="15%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/></font></div></td> 
	  <td width="15%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgCustItemNo"/></font></div></td> 
	  <td width="5%" nowrap><div align="center" ><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgShipType"/><jsp:getProperty name="rPH" property="pgQty"/></font></div></td> 
	  <td width="5%" nowrap><div align="center" ><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgUom"/></font></div></td> 
	  <td width="8%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgPono"/></font></div></td> 
	  <td width="15%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgConfirm"/><jsp:getProperty name="rPH" property="pgProcessDate"/></font></div></td> 
	  <td width="5%" nowrap><div align="center"><font color="#FFFFFF" size="2"><jsp:getProperty name="rPH" property="pgConfirm"/><jsp:getProperty name="rPH" property="pgAccount"/></font></div></td>  			 		
    </tr>
   <% } //表頭列印完畢 %>

   <font face="Arial, Helvetica, sans-serif"> </font><tr bgcolor='<%=colorStr%>'> 
      <td width='3%'><div align='center'><font color='#006666' size='2' face="Arial, Helvetica, sans-serif"><%out.println(iRow+1);%></font></div></td>     
      <td width="8%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("TSINVOICENO")%></font></div></td>
      <td width="8%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("SALESORDERNO")%></font></div></td>
      <td width="8%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CUSTOMER_PN")%></font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("SHIPDATE")%></font></div></td>
	  <td width="18%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CUSTOMERNO")%></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CUSTOMERNAME")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("SHIPMETHOD")%></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("FOBPOINT")%></font></div></td>
	  <td width="2%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("LINE_NO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("INV_ITEM")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("ITEM_DESC")%></font></div></td>
	  <td width="15%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CUSTITEMNO")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("RCVQTY")%></font></div></td>
      <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("PO_UOM")%></font></div></td>
	  <td width="8%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("PO_NUM")%></font></div></td>
	  <td width="15%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CONFIRM_DATE")%></font></div></td>
	  <td width="5%" nowrap><div align="center"><font color="#0080C0" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("CONFIRM_BY")%></font></div></td>
     </tr>
    <%
      iRow++;

  }//end of while 

 } //end of try
  catch (Exception e)
   {
     out.println("Exception 2:"+e.getMessage());
   }

//}
%>
    <tr bgcolor="#0080CC"> 
	<td height='23' colspan='18' ><font color='#FFFFFF' size='2'>&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgInvoiceNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
  	 <font color='#CC3366' face='Arial'><strong><%=CaseCount%></strong></font>
	 &nbsp;&nbsp;<font color='#FFFFFF' size='2'><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 <font color='#CC3366' face='Arial'><strong><%=CaseCountORG%></strong></font>
	 </td>      
    </tr>
  </table>

	
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
