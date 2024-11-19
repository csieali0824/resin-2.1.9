<!-- 20141008 by Peggy,ccyang可查看所有statuscode=014的rfq-->
<!-- 20141211 by Peggy,EDI客戶的RFQ也須要求輸入CUSTOMER PO LINE NUMBER-->
<!-- 20151221 by Peggy,read oe_items_v常發生table lock且不知為何要顯示所有客戶品號故先mark-->
<%@ page language="java" import="java.sql.*,java.text.*"%>
<html>
<%@ page import="DateBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<title>Sales Delivery Request Notice Data Display Page</title>
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
.style17 {
	color: #000099;
	font-family: Georgia;
	font-weight: bold;
	font-size: large;
}
</STYLE>
<script language="JavaScript" type="text/JavaScript">
function historyByDOCNO(pp)
{   
	subWin=window.open("TSSalesDRQHistoryDetail.jsp?DNDOCNO="+pp,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function historyByCust(pp,qq,rr)
{   
  	subWin=window.open("TSSDRQInformationQuery.jsp?CUSTOMERNO="+pp+"&CUSTOMERNAME="+qq+"&DATESETBEGIN=20000101"+"&DATESETEND=20991231"+"&CUSTOMERID="+rr,"subwin");  
}
function resultOfDOAP(repno,svrtypeno)
{   
  	subWin=window.open("../jsp/subwindow/DOAPResultQuerySubWindow.jsp?REPNO="+repno+"&SVRTYPENO="+svrtypeno,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function RFQDetailHistQuery(dnDocNo,lineNo)
{     
    subWin=window.open("../jsp/TSSalesDRQHistoryDetail.jsp?DNDOCNO="+dnDocNo+"&LINENO="+lineNo,"subwin","width=800,height=480,scrollbars=yes,menubar=no");    	
}
function ExpandBasicInfoDisplay(expand)
{       
	var subURL = location.href.substring(0,location.href.indexOf("EXPAND")-1); 
 	var URL = location.href;
 	if (location.href.indexOf("EXPAND")<0)
 	{
    	if (expand=="OPEN")
		{ 
			document.DISPLAYREPAIR.action=URL;  
		} 
		else 
		{ 
        	document.DISPLAYREPAIR.action=URL+"&EXPAND="+expand;
		}
 	}
	else 
	{
    	if (expand=="OPEN")
		{ 
			document.DISPLAYREPAIR.action=subURL; 
		}
		else
		{
		   	document.DISPLAYREPAIR.action=subURL+"&EXPAND="+expand;
		}
  	}
	window.document.DISPLAYREPAIR.submit();
}

function TSCInvItemQtyDetail(itemid,assignFactory)
{     
	subWin=window.open("../jsp/TSCInvItemQtyDetail.jsp?ITEM_ID="+itemid+"&ASSIGN_MANUFACT="+assignFactory,"subwin","width=900,height=480,scrollbars=yes,menubar=no");    	
}
</script>
<%

String expand=request.getParameter("EXPAND");
String lineStatusID=request.getParameter("LSTATUSID"); // ??????? HeadQueryAllStatus????
String tsAreaNo="",reqPersonID="",reqPerson="",tsCustomerID="",customer="",custPO="",frStatID="",curr="",requireDate="",pcConfirmDate="";
String amount="",facPromiseDate="",prodFactory="",statusid="",status="",creationDate="",creationTime="",createdBy="",lastUpdateDate="",lastUpdateTime="",lastUpdateBy="";
String toPersonID="",orderTypeID="",orderTypeName="",oTypeDesc="",soldToOrg="",priceList="",shipToOrg="";
String salesAreaName="",recSalesNo="",recSalesName="",bRemark="",salesPerson="";
String customerNo="",recCenterName="",customerName="",recPersonName="";
String preRepMethod="",preRepMethodName="",actRepMethod="",actRepMethodName="",actRepDesc="",isTransmitted="";
String preLineType="",swapIMEI="",itemDesc="",recDate="",recItemNo2="",recItemName2="";
String isQuoted="N";//?O§_|33o?u﹐eRA
String repairingCost="",itemCost="",transCost="",otherCost="";//3o?uAEAU?A
String agentName="",agentNo="",recType="",recTypeName="",qty="";
String Limited=""; //?OcT’A--
String hStatusID ="",hStatus="";
String sampleOrder = "",sampleCharge = "";
String showSSD ="N"; //add by Peggychen 20110621
String CUSTMARKETGROUP=""; //add by Peggy 20111005
if (sampleOrder==null) sampleOrder = "N";
if (expand==null) expand = "OPEN";
String shiptoaddr="",billtoaddr="",paymentterm="",billtoorg="",FOB_POINT="",PAYTERM_ID="",priceListCode="",autoCreate_Flag=""; //add by Peggy 20120222
String shipToContact="",shipToContactid="",deliveryToOrg="",deliverytoaddr="";//add by Peggy 20130220
String custPOLineNo_flag="";//add by Peggy 20120531
String rfq_Type="";         //add by Peggy 20130318

//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
//20110825 for ERP R12 Upgrade to modify 
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
cs1.setString(1,"41");
cs1.execute();

try
{      	
	Statement docstatement=con.createStatement();
	String sqlDocs = "";
	//if (UserRoles.indexOf("admin")>=0) // ???,???????
	if (UserRoles.indexOf("admin")>=0  || (UserRoles.indexOf("SMCUser")>=0 && (UserName.equals("CCYANG") || UserName.equals("RITA_ZHOU")) && lineStatusID.equals("014")) ) //modif by Peggy 20141008 
	{ 
		sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME "+
				 "from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				 "WHERE a.DNDOCNO=b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"' ";		 
	}
	else if (UserRoles.indexOf("SalesPlanner")>=0 || UserRoles.indexOf("CInternal_Planner")>=0) // 企劃Assigning?RESPONDING
	{ 
		sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	             "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				 "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME "+			
				 "from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				 "WHERE a.DNDOCNO=b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"' "; 
				 
		if (UserRegionSet==null || UserRegionSet.equals(""))
		{
			sqlDocs = sqlDocs + " and (b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(a.DNDOCNO,3,3) >='"+userActCenterNo+"' ) "; // 若是空的地區集,則以主要的業務區
		} 
		else 
		{
			sqlDocs = sqlDocs + " and ( b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(a.DNDOCNO,3,3) >='"+userActCenterNo+"' )  ";
		}	 
   	}
	else //業務或工廠PC
	{  
		sqlDocs="select a.*,b.LSTATUSID,b.LSTATUS,TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as LUPDATE, "+
	              "TO_CHAR(to_date(b.LAST_UPDATE_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as LUPTIME, "+
				  "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD ') as CREATEDATE, "+
				  "TO_CHAR(to_date(b.CREATION_DATE,'YYYYMMDDHH24MISS'),'HH24:MI:SS') as CREATETIME "+	
	              "from ORADDMAN.TSDELIVERY_NOTICE a,ORADDMAN.TSDELIVERY_NOTICE_DETAIL b "+
				  "WHERE a.DNDOCNO=b.DNDOCNO and a.DNDOCNO='"+dnDocNo+"'  "; 
				  
		if (UserRegionSet==null || UserRegionSet.equals(""))
		{
			sqlDocs = sqlDocs + " and (b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(a.DNDOCNO,3,3) ='"+userActCenterNo+"' ) "; // 若是空的地區集,則以主要的業務區
		} 
		else 
		{
		    sqlDocs = sqlDocs + " and (b.ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(a.DNDOCNO,3,3) in ("+UserRegionSet+") )  ";
		}
	}
    if (line_No!=null && !line_No.equals("")) { sqlDocs = sqlDocs+"and to_char(b.LINE_NO) ='"+line_No+"' "; } // ????Line_No???
	if (lineStatusID!=null && !lineStatusID.equals("")) {  sqlDocs = sqlDocs+"and b.LSTATUSID ='"+lineStatusID+"' "; }
    ResultSet docrs=docstatement.executeQuery(sqlDocs);
    docrs.next();
	dnDocNo=docrs.getString("DNDOCNO");
	tsAreaNo=docrs.getString("TSAREANO");
	reqPersonID=docrs.getString("REQPERSONID");
	reqPerson=docrs.getString("REQREASON");
	tsCustomerID=docrs.getString("TSCUSTOMERID");
	customer=docrs.getString("CUSTOMER");
	custPO=docrs.getString("CUST_PO");
	curr=docrs.getString("CURR");
	amount=docrs.getString("AMOUNT");
	requireDate=docrs.getString("REQUIRE_DATE");
	pcConfirmDate=docrs.getString("PCCFIRM_DATE");
	facPromiseDate=docrs.getString("FCTPOMS_DATE");
	prodFactory=docrs.getString("PROD_FACTORY");
	bRemark=docrs.getString("REMARK");
	statusid=docrs.getString("LSTATUSID");
	status=docrs.getString("LSTATUS");
	hStatusID=docrs.getString("STATUSID");
	hStatus=docrs.getString("STATUS");
	creationDate=docrs.getString("CREATEDATE");
	creationTime=docrs.getString("CREATETIME");
	createdBy=docrs.getString("CREATED_BY");
	lastUpdateDate=docrs.getString("LUPDATE");
	lastUpdateTime=docrs.getString("LUPTIME");
	lastUpdateBy=docrs.getString("LAST_UPDATED_BY");
	toPersonID=docrs.getString("TOPERSONID");
	orderTypeID=docrs.getString("ORDER_TYPE_ID");
	soldToOrg=docrs.getString("SOLD_TO_ORG");
	priceList=docrs.getString("PRICE_LIST");
	shipToOrg=docrs.getString("SHIP_TO_ORG");//?a°eou-×|?￥o?μ￥O
	if (shipToOrg == null) shipToOrg = "";
	salesPerson=docrs.getString("SALESPERSON");
	sampleOrder =docrs.getString("SAMPLE_ORDER");
	sampleCharge =docrs.getString("SAMPLE_CHARGE");
	billtoorg=docrs.getString("BILL_TO_ORG");  //add by Peggy 20120222
	if (billtoorg == null) billtoorg = "";
	PAYTERM_ID=docrs.getString("PAYTERM_ID");  //add by Peggy 20120222
	if (PAYTERM_ID == null) PAYTERM_ID = "";
	FOB_POINT=docrs.getString("FOB_POINT");    //add by Peggy 20120222
	if (FOB_POINT==null) FOB_POINT="";
	autoCreate_Flag=docrs.getString("AUTOCREATE_FLAG");  //add by Peggy 20120222
	if (autoCreate_Flag==null) autoCreate_Flag="N";
	deliveryToOrg=docrs.getString("DELIVERY_TO_ORG");  //add by Peggy 20130220
	if (deliveryToOrg==null) deliveryToOrg="";
	shipToContactid=docrs.getString("SHIP_TO_CONTACT_ID"); //add by Peggy 20130220
	if (shipToContactid==null) shipToContactid="";     
	rfq_Type=docrs.getString("RFQ_TYPE");          //add by Peggy 20130318
	if (rfq_Type==null) rfq_Type="";  
    frStatID=statusid; 
    docrs.close();  
	  
	if (tsAreaNo!=null)
	{ 
		docrs=docstatement.executeQuery("select * from ORADDMAN.TSSALES_AREA WHERE SALES_AREA_NO='"+tsAreaNo+"' ");
        docrs.next();             
	    salesAreaName=docrs.getString("SALES_AREA_NAME");
		showSSD=docrs.getString("SSD_FLAG");  //add by Peggychen 20110621
	    docrs.close();
	} 	  
	  
	if (tsAreaNo!=null && reqPersonID!=null)
	{ 
		docrs=docstatement.executeQuery("select * from ORADDMAN.TSRECPERSON WHERE USERID='"+reqPersonID+"' and TSSALEAREANO = '"+tsAreaNo+"' ");
        if (docrs.next())      
		{        
			recSalesNo=docrs.getString("RECPERSONNO");
	      	recSalesName=docrs.getString("USERNAME");
		} 
	    docrs.close();
	} 	  	  
  	  		  	 	  
	if (tsCustomerID!=null)
	{
		docrs=docstatement.executeQuery("select DISTINCT a.CUSTOMER_NUMBER,a.attribute2 marketgroup "+
		 //"from APPS.RA_CUSTOMERS_VIEW a, APPS.RA_CUSTOMER_SHIP_VIEW b, APPS.RA_CUSTOMER_BILL_VIEW c "+
		   //20110825 for ERP R12 -- Change APPS.RA_CUSTOMERS_VIEW to APPS.AR_CUSTOMERS
		" from APPS.AR_CUSTOMERS a, APPS.RA_CUSTOMER_SHIP_VIEW b, APPS.RA_CUSTOMER_BILL_VIEW c "+
		" where a.STATUS='A' and a.CUSTOMER_ID = b.CUSTOMER_ID and b.CUSTOMER_ID = c.CUSTOMER_ID and a.CUSTOMER_ID='"+tsCustomerID+"'");
        if (docrs.next())
		{
	    	customerNo=docrs.getString("CUSTOMER_NUMBER");
			CUSTMARKETGROUP=docrs.getString("marketgroup"); //add by Peggy 20111005
			if (CUSTMARKETGROUP ==null) CUSTMARKETGROUP = ""; //add by Peggy 20111005
		}
	    docrs.close();
	}    
		 
	if (orderTypeID!=null)
	{ 		 			 			                         	  
		docrs=docstatement.executeQuery("select * from ORADDMAN.TSAREA_ORDERCLS WHERE OTYPE_ID='"+orderTypeID+"' and SAREA_NO='"+tsAreaNo+"' ");
        if (docrs.next())      
		{        
			orderTypeName=docrs.getString("OTYPE_NAME");
	      	oTypeDesc=docrs.getString("DESCRIPTION");
		} 
		else 
		{ 
			orderTypeName="N/A";  
			oTypeDesc="N/A"; 
		}
	    docrs.close();
	}
	
	//add by Peggy 20120531
	if (tsCustomerID!=null && tsAreaNo!=null)
	{
		docrs=docstatement.executeQuery(" SELECT 1 FROM ORADDMAN.tscust_special_setup WHERE sales_area_no ='"+tsAreaNo+"' AND customer_id='"+ tsCustomerID +"' AND active_flag='A'"+
	                                    " UNION ALL"+
										" SELECT distinct 1 FROM TSC_EDI_CUSTOMER WHERE SALES_AREA_NO ='"+tsAreaNo+"' AND CUSTOMER_ID ='"+ tsCustomerID +"' and (INACTIVE_DATE IS NULL OR INACTIVE_DATE > TRUNC(SYSDATE))"); //add by Peggy 20141211
        if (docrs.next())      
		{        
			custPOLineNo_flag = "Y";
		} 
		else 
		{ 
			custPOLineNo_flag = "N";
		}
	    docrs.close();
	}
	else
	{
		custPOLineNo_flag = "N";
	}

 	docstatement.close();
} //end of try
catch (Exception e)
{
	out.println("Exception2:"+e.getMessage());
}
%>
<body>
<font color="#0080FF" size="5"><strong><jsp:getProperty name="rPH" property="pgSalesDRQ"/></strong></font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#8000FF" size="3"><strong><jsp:getProperty name="rPH" property="pgRepStatus"/>:</strong></font> 
  <font color="#CC0033" size="3" face="MS Sans Serif"><strong><%=status%></strong></font><BR>
  <strong><font size="3" color="#000066"><jsp:getProperty name="rPH" property="pgQDocNo"/>:</font><%=dnDocNo%></strong> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#8000FF"> 
<%
     
     String custPOStr = "";
	 if (custPO!=null && custPO.equals("")) custPO.replace("'","");  // 把 ' 字眼取代成空字串(2006/12/12)
     Statement seqStat=con.createStatement();
     ResultSet seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSDELIVERY_NOTICE where DNDOCNO !='"+dnDocNo+"' and REPLACE(CUST_PO,'\''','') = '"+custPOStr+"' ");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6' size='2'><A HREF='javaScript:historyByDOCNO("<%=dnDocNo%>")'><jsp:getProperty name="rPH" property="pgTSDRQNoHistory"/>(by DRQNo.)</A></font>
 <%	
 	 }     
     seqRs.close(); //add by Peggy 20160331
	 
	 seqRs=seqStat.executeQuery("select COUNT (*) from ORADDMAN.TSDELIVERY_NOTICE where DNDOCNO !='"+dnDocNo+"' and TSCUSTOMERID='"+tsCustomerID+"'");
     seqRs.next();
     if (seqRs.getInt(1)>0)
     {  %>
       &nbsp;&nbsp;&nbsp;&nbsp;<font color='DA70D6' size='2'><A HREF='javaScript:historyByCust("<%=customerNo%>","<%=customer%>","<%=tsCustomerID%>")'><jsp:getProperty name="rPH" property="pgTSDRQNoHistory"/>(by Customer)</A></font>
<% 
	 }	     
	 //} //END OF DAO/DAP§Pcwμ2aGif
	 seqStat.close();
     seqRs.close();
%> 
<!--%<a href="../jsp/include/TSDRQBasicInfoDisplayPage.jsp?EXPAND=FALSE"><img src="/include/MINUS.gif" width="14" height="15" border="0"></a> %-->
<table cellSpacing="0" bordercolordark="#66CC99"  cellPadding="1" width="97%" align="center" borderColorLight="#ffffff" border="1">
  <tr> 
    <td nowrap>     
      <jsp:getProperty name="rPH" property="pgSalesArea"/> 
      :<%=tsAreaNo%>(<%=salesAreaName%>)
	</td>
	<td>
	<jsp:getProperty name="rPH" property="pgPreOrderType"/>:<%if (orderTypeID.equals("0")) out.println("N/A"); else out.println(orderTypeID); %>(<%=orderTypeName%>)<BR>
	<jsp:getProperty name="rPH" property="pgPreOrderType"/><jsp:getProperty name="rPH" property="pgDesc"/>:<%=oTypeDesc%><BR>
    <jsp:getProperty name="rPH" property="pgCreateFormDate"/>
    :<%=requireDate.substring(0,4)%>/<%=requireDate.substring(4,6)%>/<%=requireDate.substring(6,8)%></td>
    <td>      
	  <jsp:getProperty name="rPH" property="pgCreateFormUser"/>
	  :<%=recSalesNo%>(<%=recSalesName%>)<BR>
	  <jsp:getProperty name="rPH" property="pgSalesMan"/>
	  :<%=toPersonID%>(<%=salesPerson%>)
	</td>
  </tr>
  <tr> 
    <td width="30%">
      <jsp:getProperty name="rPH" property="pgCustNo"/>
      :<%=customerNo%></td>
    <td width="43%">
      <jsp:getProperty name="rPH" property="pgIdentityCode"/>
      :<%=tsCustomerID%></td>
    <td width="27%">
      <jsp:getProperty name="rPH" property="pgCustPONo"/>
      :<%=custPO%></td>
  </tr>
  <tr> 
    <td colspan="2">
      <jsp:getProperty name="rPH" property="pgCustomerName"/>
      :<%=customer%></td>
    <td>
      <jsp:getProperty name="rPH" property="pgCurr"/>
      :<%=curr%></td>
  </tr>  
  <%
	if (hStatusID.equals("001") || hStatusID.equals("008"))  //add by peggy 2012022,草稿才顯示出貨地址,立帳地址,付款條件,FOB
  	{
		if (!PAYTERM_ID.equals("") && !PAYTERM_ID.equals("N/A"))
		{
			Statement Statx=con.createStatement();
			ResultSet rsx=Statx.executeQuery("select a.NAME from RA_TERMS_VL a  where a.IN_USE ='Y'  and a.TERM_ID ='"+PAYTERM_ID+"'"); 
			if (rsx.next())
			{
				paymentterm=rsx.getString("NAME");
			}
			rsx.close();
			Statx.close();	
		}
		
		if (!billtoorg.equals("") && !shipToOrg.equals(""))
		{
			Statement Statx=con.createStatement();
			ResultSet rsx=  Statx.executeQuery(" select  a.SITE_USE_ID,a.SITE_USE_CODE, loc.COUNTRY, replace(loc.ADDRESS1,'''') as ADDRESS1"+
											" from ar_site_uses_v a,HZ_CUST_ACCT_SITES ADDR, hz_party_sites party_site, hz_locations loc"+
											" where a.ADDRESS_ID = addr.cust_acct_site_id"+
											" AND addr.party_site_id = party_site.party_site_id"+
											" AND loc.location_id = party_site.location_id"+
											" AND a.SITE_USE_ID IN ('"+billtoorg+"','"+shipToOrg+"','"+deliveryToOrg+"')");
			while(rsx.next())
			{
				if (rsx.getString("SITE_USE_CODE").equals("BILL_TO"))
				{
					billtoaddr = rsx.getString("ADDRESS1");
				}
				else if (rsx.getString("SITE_USE_CODE").equals("SHIP_TO"))
				{
					shiptoaddr = rsx.getString("ADDRESS1");
				}
				else if (rsx.getString("SITE_USE_CODE").equals("DELIVER_TO")) //add by Peggy 20130220
				{
					deliverytoaddr = rsx.getString("ADDRESS1");
				}
			}
			rsx.close();
			Statx.close();
		}
		
		if (!priceList.equals(""))
		{
			Statement Statx=con.createStatement();
			String sqlx = " select LIST_HEADER_ID||'('||NAME||')' as LIST_CODE "+
						" from qp_list_headers_v "+
						" where ACTIVE_FLAG = 'Y'"+
						"  AND LIST_HEADER_ID='"+ priceList+"'"; 
			ResultSet rsx=Statx.executeQuery(sqlx);
			while (rsx.next())
			{            
				priceListCode=rsx.getString("LIST_CODE"); 
			} 
			Statx.close();		  		  
			rsx.close();  
		}
		 
		if (!shipToContactid.equals(""))
		{
			Statement Statx=con.createStatement();
	        String sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name"+
                          " from ar_contacts_v con,hz_cust_site_uses su "+
                          " where con.status='A'"+
			              " AND con.address_id=su.cust_acct_site_id"+
				          " AND su.site_use_code='SHIP_TO'"+
						  " AND con.contact_id='"+ shipToContactid+"'";
			ResultSet rsx=Statx.executeQuery(sqlx);
			while (rsx.next())
			{            
				shipToContact=rsx.getString("contact_name"); 
			} 
			Statx.close();		  		  
			rsx.close();  
		}
		
  		out.println("<tr>");
    	out.println("<td colspan='2'>");
		%>
      	<jsp:getProperty name='rPH' property='pgShipType'/><jsp:getProperty name='rPH' property='pgAddr'/>:
		<%
      	out.println(shiptoaddr);
		out.println("</td>");
    	out.println("<td>");
		%>
      	<jsp:getProperty name='rPH' property='pgPaymentTerm'/>:
		<%
      	out.println(paymentterm);
		out.println("</td>");
 		out.println("</tr>");
  		out.println("<tr>");
    	out.println("<td colspan='2'>");
		%>
      	<jsp:getProperty name='rPH' property='pgBillTo'/>:
		<%
      	out.println(billtoaddr);
		out.println("</td>");
    	out.println("<td>");
		%>
      	<jsp:getProperty name='rPH' property='pgFOB'/>:
		<%
      	out.println(FOB_POINT);
		out.println("</td>");
 		out.println("</tr>");  
  		out.println("<tr>");
    	out.println("<td colspan='2'>");
		%>
      	<jsp:getProperty name='rPH' property='pgDeliverTo'/>:
		<%
      	out.println(deliverytoaddr);
		out.println("</td>");
    	out.println("<td>Ship To Contact:");
      	out.println(shipToContact);
		out.println("</td>");
 		out.println("</tr>");  
		
   	}
  %>
  <tr>
    <td><jsp:getProperty name="rPH" property="pgSetSampleOrder"/>:
	  <%
	     if (sampleOrder.equals("N")) out.println("<font color='#FF0000' face='Arial' size='2'>"+"NO"+"");
		 else out.println("<font color='#FF0000' face='Arial' size='2'>"+"YES"+"");
	  %>
	</td>
	<td colspan="1"><jsp:getProperty name="rPH" property="pgPriceList"/>
	:<%=priceListCode%>
	</td>
	<td colspan="1"><jsp:getProperty name="rPH" property="pgQuotation"/>:
	  <%
	     if (sampleCharge==null || sampleCharge.equals("") || sampleCharge.equals("N")) out.println("<font color='#FF0000' face='Arial' size='2'>"+"NO"+"");
		 else out.println("<font color='#FF0000' face='Arial' size='2'>"+"YES"+"");
	  %>
	</td>
  </tr>    
  <tr> 
    <td colspan="2">
      <jsp:getProperty name="rPH" property="pgRequireReason"/>
      :<%=reqPerson%> 
    </td>  
	<td colspan="1"><jsp:getProperty name="rPH" property="pgRFQType"/>:
	  <%
	 	if (rfq_Type==null || rfq_Type.equals(""))
		{
			out.println("<font color='#000000' face='Arial' size='2'>&nbsp;</font>");
		}	
		else if (rfq_Type.equals("1"))
		{
			out.println("<font color='#0000FF' face='Arial' size='3'>Normal</font>");
		}
		else if (rfq_Type.equals("2"))
		{
			out.println("<font color='#FF0000' face='Arial' size='3'>Forecast</font>");
		}
	  %>
	</td>
  </tr>
  <tr> 
    <td colspan="3">
      <jsp:getProperty name="rPH" property="pgContent"/><jsp:getProperty name="rPH" property="pgDetail"/>
      : 
	<%  
	if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	{
	%>
	    <a href='javaScript:ExpandBasicInfoDisplay("CLOSE")'><img src='../image/folder_lock.gif' style="vertical-align:middle " align="middle" border='0'></a>
	<%
	} 
	else 
	{	   
	%>	
	    <a href='javaScript:ExpandBasicInfoDisplay("OPEN")'><img src='../image/folder_open.gif' style="vertical-align:middle " align="middle" border='0'></a>
	<%
	}
	%>
	<% 
	if (expand==null || expand.equals("OPEN") || expand.equals("null"))
	{
	%> 
    <%
		try
      	{   
	   		out.println("<TABLE cellSpacing='0' bordercolordark='#66CC99'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1'>");
	   		out.println("<tr bgcolor='#66CC99'><td nowrap><font color='WHITE'>&nbsp;</td><td nowrap><font color='WHITE'>");	   
		%>
	   		<jsp:getProperty name="rPH" property="pgAnItem"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgOrderedItem"/>
	   	<%
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   	<%
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgDesc"/>
	   	<%
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgQty"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgUOM"/>
	   	<% 
	   		if (showSSD.equals("Y"))   //add by Peggychen 20110621
	   		{
	   			out.println("</td><td nowrap><font color='WHITE'>");
	   		%>
	   			<jsp:getProperty name="rPH" property="pgCRDate"/>
	   		<%
	   		}
	   
	   		if (showSSD.equals("Y") || showSSD.equals("S"))   //modify by Peggychen 20120209
	   		{
	   			out.println("</td><td nowrap><font color='WHITE'>");
	   		%>
	   			<jsp:getProperty name="rPH" property="pgShippingMethod"/>
	   		<%
	   		}
	   	%>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgRequestDate"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>
	   		<jsp:getProperty name="rPH" property="pgFirmOrderType"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");
	   	%>	   
	   		<jsp:getProperty name="rPH" property="pgRemark"/>
	   	<% 
	   		out.println("</td>");
	   		out.println("<td nowrap><font color='WHITE'>");	   
	   	%>
	   		<jsp:getProperty name="rPH" property="pgAssignTo"/>
	   	<% 
	   		out.println("</td>");
	   		out.println("<td nowrap><font color='WHITE'>");	   
	   	%>
	   		<jsp:getProperty name="rPH" property="pgProdFactory"/>
	  	<% 
	   		out.println("</td>");
	   		out.println("<td nowrap><font color='WHITE'>");	   
	   	%>
       		<jsp:getProperty name="rPH" property="pgFTArrangeDate"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");	   
	   	%>
	   	 	<jsp:getProperty name="rPH" property="pgSSD"/>
	   	<% 
	   		out.println("</td><td nowrap><font color='WHITE'>");	   
	   	%>
	   		<jsp:getProperty name="rPH" property="pgOrdCreateDate"/>
	   	<% 
	   		out.println("</td></TR>");    
	   		String jamString="";
       		Statement statement=con.createStatement();
       		String sqlDTL = "";
	   		//if (UserRoles.indexOf("admin")>=0) // ???,????????
			if (UserRoles.indexOf("admin")>=0  || (UserRoles.indexOf("SMCUser")>=0 && (UserName.equals("CCYANG") || UserName.equals("RITA_ZHOU")) && lineStatusID.equals("014")) ) //modif by Peggy 20141008 
       		{ // 管理員
	   			sqlDTL ="select LINE_NO, ITEM_SEGMENT1, ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE,"+
		   				" REMARK,ASSIGN_MANUFACT,substr(PCCFMDATE,1,8) as PCCFMDATE,substr(FTACPDATE,1,8) as FTACPDATE,"+
		   				"substr(PCACPDATE,1,8) as PCACPDATE,substr(SASCODATE,1,8) as SASCODATE,SDRQ_EXCEED,"+
		   				" ORDERNO, INVENTORY_ITEM_ID,substr(SHIP_DATE,1,8) as SHIP_DATE, "+
		   				" cust_request_date,shipping_method"+ //add by Peggychen 20110621
				 		",ORDERED_ITEM,nvl((select b.order_num from oraddman.tsarea_ordercls b where b.sarea_no ='"+tsAreaNo+"' and  TO_CHAR(a.order_type_id) = b.OTYPE_ID),'N/A') ORDER_TYPE"+//add by Peggy 20120222				
		           		" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a "+
				   		" where DNDOCNO='"+dnDocNo+"' "+
				   		" order by LINE_NO";
	   		}
       		else if ((statusid.equals("002") || statusid.equals("007")) && ( UserRoles.indexOf("SalesPlanner")>=0) || UserRoles.indexOf("CInternal_Planner")>=0) // ????????Assigning?RESPONDING
       		{ // 企劃人員(內外銷)
	      		sqlDTL =" select LINE_NO, ITEM_SEGMENT1, ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE,"+
		  				" REMARK,ASSIGN_MANUFACT,substr(PCCFMDATE,1,8) as PCCFMDATE,substr(FTACPDATE,1,8) as FTACPDATE,"+
		  				"substr(PCACPDATE,1,8) as PCACPDATE,substr(SASCODATE,1,8) as SASCODATE,SDRQ_EXCEED, ORDERNO,"+
		  				" INVENTORY_ITEM_ID,substr(SHIP_DATE,1,8) as SHIP_DATE, "+
		   				" cust_request_date,shipping_method"+ //add by Peggychen 20110621
				 		",ORDERED_ITEM,nvl((select b.order_num from oraddman.tsarea_ordercls b where b.sarea_no ='"+tsAreaNo+"' and  TO_CHAR(a.order_type_id) = b.OTYPE_ID),'N/A') ORDER_TYPE"+//add by Peggy 20120222				
		          		" from ORADDMAN.TSDELIVERY_NOTICE_DETAIL a"+
				  		" where DNDOCNO='"+dnDocNo+"' ";
		    	if (UserRegionSet==null || UserRegionSet.equals(""))
				{
			   		sqlDTL += " and ( ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(DNDOCNO,3,3) >='"+userActCenterNo+"' ) "; // 若是空的地區集,則以主要的業務區
		    	} 
				else 
				{
					sqlDTL += " and (ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(DNDOCNO,3,3) in ("+UserRegionSet+") or substr(DNDOCNO,3,3) >='"+userActCenterNo+"' )  ";
				}		  
		  		sqlDTL +=" order by LINE_NO";    
	   		}
       		else 
			{  // 工廠生管或業務
	        	sqlDTL ="select LINE_NO, ITEM_SEGMENT1, ITEM_DESCRIPTION, QUANTITY, UOM, REQUEST_DATE,"+
			   			" REMARK,ASSIGN_MANUFACT,substr(PCCFMDATE,1,8) as PCCFMDATE,substr(FTACPDATE,1,8) as FTACPDATE,"+
			   			"substr(PCACPDATE,1,8) as PCACPDATE,substr(SASCODATE,1,8) as SASCODATE,SDRQ_EXCEED,"+
			   			" ORDERNO, INVENTORY_ITEM_ID,substr(SHIP_DATE,1,8) as SHIP_DATE, "+
		       			" cust_request_date,shipping_method"+ //add by Peggychen 20110621
				 		",ORDERED_ITEM,nvl((select b.order_num from oraddman.tsarea_ordercls b where b.sarea_no ='"+tsAreaNo+"' and  TO_CHAR(a.order_type_id) = b.OTYPE_ID),'N/A') ORDER_TYPE"+//add by Peggy 20120222				
			           	"  from ORADDMAN.TSDELIVERY_NOTICE_DETAIL  a"+
					   	" where DNDOCNO='"+dnDocNo+"' ";										  
				if (UserRegionSet==null || UserRegionSet.equals(""))
			    {
			    	sqlDTL += " and ( ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(DNDOCNO,3,3) ='"+userActCenterNo+"' ) "; // 若是空的地區集,則以主要的業務區
		        } 
				else 
				{
					sqlDTL += " and ( ASSIGN_MANUFACT = '"+userProdCenterNo+"' or substr(DNDOCNO,3,3) in ("+UserRegionSet+") )  ";
				}
				sqlDTL += " order by LINE_NO";  	   
			} // ENd of else
	   		//out.println(sqlDTL);	
       		ResultSet rs=statement.executeQuery(sqlDTL);	   
	   		while (rs.next())
	   		{
	    		String assignFactory= "N/A";
				String assignUser="N/A";
				//out.println(rs.getString("ASSIGN_MANUFACT"));
	    		// ??????????,???????
	    		if (rs.getString("ASSIGN_MANUFACT").trim()!="N/A")
				{
		  			Statement stateAssignFact=con.createStatement();
	      			ResultSet rsAssignFact=stateAssignFact.executeQuery("select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO='"+rs.getString("ASSIGN_MANUFACT")+"' ");
		  			if (rsAssignFact.next())
		  			{  
						assignFactory=rsAssignFact.getString("MANUFACTORY_NAME"); 
					}		  
		  			rsAssignFact.close();
		  
		  			//?????????
		  			//out.println("select USERNAME from ORADDMAN.TSRECPERSON a, ORADDMAN.TSDELIVERY_DETAIL_HISTORY b where a.USERID= b.UPDATEUSERID and b.DNDOCNO= '"+dnDocNo+"' and to_char(b.LINE_NO)='"+rs.getString("LINE_NO")+"' ");
		  			ResultSet rsAssignUser=stateAssignFact.executeQuery("select USERNAME from ORADDMAN.TSRECPERSON a, ORADDMAN.TSDELIVERY_DETAIL_HISTORY b where a.USERID= b.UPDATEUSERID and b.DNDOCNO= '"+dnDocNo+"' and to_char(b.LINE_NO)='"+rs.getString("LINE_NO")+"' and b.ORISTATUSID = '002'  "); // ??????
		  			if (rsAssignUser.next())
		  			{  
						assignUser=rsAssignUser.getString("USERNAME"); 
					}		  
		  			rsAssignUser.close();		  
		  			stateAssignFact.close();
				} 
				else 
		    	{ 
			 		assignFactory=rs.getString("ASSIGN_MANUFACT"); 
				} // ???? "N/A"
				//out.println("Step1");
				// 2007/03/29 增加顯示客戶品號於 ToolTip_起
		   
		     	//String detailHdr = null;
		     	//String detailLot = null;
			 
		     	//Statement stateCI=con.createStatement();
		     	//String sqlCI = "select ITEM_ID, trim(ITEM) as CUST_ITEM, ITEM_DESCRIPTION, "+					       
                //            	"       ITEM_IDENTIFIER_TYPE "+
                //            	"  from oe_items_v  ";			                      														  
			 	//String whereCI = "where to_char(sold_to_org_id) = '"+tsCustomerID+"' "+					           	
				//			  	"  and nvl(cross_ref_status,'ACTIVE') <> 'INACTIVE' " +							
				//	          	"  and INVENTORY_ITEM_ID ="+rs.getInt("INVENTORY_ITEM_ID")+" "+
				//			  	"  ";
			 	//sqlCI = sqlCI + whereCI;
			 	//detailHdr = "<table cellspacing=0 bordercolordark=#CCCC66 cellpadding=1 width=100% bordercolorlight=#ffffff border=0>";
			 	////detailHdr = "<table border=1>";
			 	//detailLot = "";
		     	//ResultSet rsCI=stateCI.executeQuery(sqlCI);
			 	//while (rsCI.next())
				//{
			    //	detailLot = detailLot +"<tr><td>"+rsCI.getString("ITEM_ID")+"</td><td><div align=right>"+rsCI.getString("CUST_ITEM")+"</div></td><td><div align=right>"+rsCI.getString("ITEM_DESCRIPTION")+"</div></td><td><div align=right>"+rsCI.getString("ITEM_IDENTIFIER_TYPE")+"</div></td></tr>";  // 組合前段予後段領用的批號
				//}
			 	//rsCI.close();
			 	//stateCI.close();
			 
			 	//detailLot = detailLot + "</table>";				   
			 	//detailHdr = detailHdr + detailLot;
		  
				// 2007/03/29 增加顯示客戶品號於 ToolTip_迄
				//out.println(assignFactory);
				//out.println("select MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY where MANUFACTORY_NO='"+rs.getString("ASSIGN_MANUFACT")+"'");
	    		out.print("<TR onmouseover=bgColor='#FBFE81' onmouseout=bgColor='#FFFFFF'>");
				out.println("<TD><font size='2'>");			
			%>
		  		<a href='javaScript:RFQDetailHistQuery("<%=dnDocNo%>","<%=rs.getString("LINE_NO")%>")'><img src='../image/point_arrow.gif' border='0'></a>
			<%
				out.println("</TD>");
				out.println("<TD><font size='2'>");
				if (rs.getString("SDRQ_EXCEED")=="Y" || rs.getString("SDRQ_EXCEED").equals("Y"))
				{	  
					out.println("<font color='RED'><strong>#</strong>"); 
				}
				out.println(rs.getString("LINE_NO")+"</TD>");
				out.println("<TD><font color='#000000'>"+rs.getString("ITEM_SEGMENT1")+"</TD><TD><font color='#000000'>");
			%>
		  		<!--<a onmouseover='this.T_STICKY=true;this.T_WIDTH=250;this.T_CLICKCLOSE=false;this.T_BGCOLOR="#CCFF66";this.T_SHADOWCOLOR="#FFFF99";this.T_TITLE="ID&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;CUST ITEM&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DESCRIPTION&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;TYPE";this.T_OFFSETY=-32;return escape("")'>-->
			<%		 
				out.print(rs.getString("ITEM_DESCRIPTION"));		 
			%>
		  		</a>
			<%
				out.println("</font></TD>");
				out.println("<TD><font color='#000000'>"+rs.getString("ORDERED_ITEM")+"</TD>");  //ADD BY PEGGY 20120222
				out.println("<TD><font color='#000000'>"+(new DecimalFormat("######.###")).format(rs.getFloat("QUANTITY"))+"</TD>");
				out.println("<TD><font color='#000000'>"+rs.getString("UOM")+"</TD>");
				if (showSSD.equals("Y"))  //modify by Peggy 20120209
				{
					if (rs.getString("CUST_REQUEST_DATE") ==null)
					{
						out.println("<TD><font color='#000000'>&nbsp;</TD>");
					}
					else
					{
						out.println("<TD><font color='#000000'>"+rs.getString("CUST_REQUEST_DATE")+"</TD>");
					}
				}
				if (showSSD.equals("Y") || showSSD.equals("S")) //modify by Peggy 20120209
				{
					if (rs.getString("SHIPPING_METHOD") == null)
					{
						out.println("<TD><font color='#000000'>&nbsp;</TD>");
					}
					else
					{
						out.println("<TD><font color='#000000'>"+rs.getString("SHIPPING_METHOD")+"</TD>");
					}		
				}
				if (rs.getString("REQUEST_DATE").equals("N/A") || rs.getString("REQUEST_DATE") ==null || rs.getString("REQUEST_DATE").length()<8)
				{
					out.println("<TD><font color='#000000'>&nbsp;</TD>");
				}
				else
				{
					out.println("<TD><font color='#000000'>"+rs.getString("REQUEST_DATE").substring(0,8)+"</TD>");
				}
				out.println("<TD><font color='#000000'>"+rs.getString("ORDER_TYPE")+"</TD>"); //add by Peggy 20120222
				out.println("<TD NOWRAP><font color='#000000'>");
				if (rs.getString("REMARK")==null || rs.getString("REMARK").equals("")) out.println("&nbsp;");
				else out.println(rs.getString("REMARK"));		
				out.println("</TD>");
				out.println("<TD NOWRAP><font color='#000000'>");
				out.println(assignUser);	// ???Line????
				out.println("</TD>");
				out.print("<TD><font color='#000000'>"+assignFactory+"</TD><TD><font color='#000000'>"+rs.getString("FTACPDATE")+"</TD><TD><font color='#000000'>"+rs.getString("SHIP_DATE")+"</TD>");
				out.println("<TD><a onMouseOver='this.T_ABOVE=false;this.T_WIDTH=80;this.T_OPACITY=80;return escape("+'"'+rs.getString("ORDERNO")+'"'+")'><font color='#000000'>"+rs.getString("SASCODATE")+"</a></TD></TR>");		
	   		}    	   	   	 
	   		out.println("</TABLE>");
	   		statement.close();
       		rs.close();        
       	} //end of try
       	catch (Exception e)
       	{
        	out.println("Exception1:"+e.getMessage());
       	}
	}
	%> 
	 
	</td>      
  </tr>
  <tr> 
    <td colspan="3">
      <jsp:getProperty name="rPH" property="pgRemark"/>
      : <%=bRemark%></td>   
  </tr>	  
  <tr> 
    <td>
      <jsp:getProperty name="rPH" property="pgCreateFormUser"/>
      :<%=createdBy%></td>
    <td>
      <jsp:getProperty name="rPH" property="pgCreateFormDate"/>
      :
	  <%=creationDate
	  //if (prodFactory.equals("VALID"))
	  //{ 
	 %></td>
    <td>
      <jsp:getProperty name="rPH" property="pgCreateFormTime"/>
      :<%=creationTime%></td>
  </tr>
  <tr>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgPreProcessUser"/>:<%=lastUpdateBy%></font></td>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgPreProcessDate"/>:<%=lastUpdateDate%></font>
    </td>
    <td><font color="#0080C0"><jsp:getProperty name="rPH" property="pgPreProcessTime"/>: 
	<%=lastUpdateTime%></font>
    </td>
  </tr>  
</table>   
<% 
if (frStatID.equals("009"))  
{ 
%>
&nbsp;&nbsp;&nbsp;<font color="RED"><jsp:getProperty name="rPH" property="pgMark"/><strong> # </strong><jsp:getProperty name="rPH" property="pgDenote"/> <jsp:getProperty name="rPH" property="pgExceedValidDate"/>,<jsp:getProperty name="rPH" property="pgAlertSysNotAllowGen"/><jsp:getProperty name="rPH" property="pgSalesOrder"/></font>
<%        
} 
%>
<!--3o?u?O￥I°I-->

  <!-- ai3a°N?A -->  
    <input name="FORMID" type="HIDDEN" value="TS" > 	
	<input name="FROMSTATUSID" type="HIDDEN" value="<%=frStatID%>" >   
	<input name="PRODFACTORY" type="HIDDEN" value="<%=prodFactory%>"> 	 
	<input name="CURR" type="HIDDEN" value="<%=curr%>">	
	<input name="TSAREANO" type="HIDDEN" value="<%=tsAreaNo%>">		
	<input name="ISTRANSMITTED" type="HIDDEN" value="<%=isTransmitted%>">
	<input name="PREVIOUSPAGEADDRESS" type="HIDDEN" value=""> 
	<input name="PREORDERTYPE" type="HIDDEN" value="<%=orderTypeID%>"> 
	<input name="LSTATUSID" type="HIDDEN" value="<%=frStatID%>" >   
  <!-- add 2004-10-05  next 4 line -->
    <input nmae="EXPAND" type="hidden" value="<%=expand%>">
	<input name="AUTOCREATE_FLAG" type="hidden" value="<%=autoCreate_Flag%>">
	<input name="CUSTPO" type="hidden" value="<%=custPO%>">
	<input name="CUSTOMERNO" type="hidden" value="<%=customerNo%>"> <!--add by Peggy 20120430-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
