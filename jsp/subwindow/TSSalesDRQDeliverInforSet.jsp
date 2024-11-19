<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>Sales Delivery Request Data Edit Page for Generating Sales Order</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="CheckBoxBean,ComboBoxBean,Array2DimensionInputBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/>
<script language="JavaScript" type="text/JavaScript">
function subWindowNotifyToFind(useCode,nContactID,nContact,nLocationID,nLocation,customerID,deliverTo)
{    
  //subWin=window.open("../subwindow/TSDRQNotifyToFind.jsp?NAME="+name+"&CUSTOMERID="+customerID);  
  if (useCode=="N_CONTACT")
  {
   document.MYFORM.action="../subwindow/TSDRQNotifyToFind.jsp?USECODE="+useCode+"&NCONTACTID="+nContactID+"&NCONTACT="+nContact+"&NLOCATIONID="+nLocationID+"&NLOCATION="+nLocation+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
   document.MYFORM.submit(); 
  } else if (useCode=="N_LOCATION")
         {
		   document.MYFORM.action="../subwindow/TSDRQNotifyToFind.jsp?USECODE="+useCode+"&NCONTACTID="+nContactID+"&NCONTACT="+nContact+"&NLOCATIONID="+nLocationID+"&NLOCATION="+nLocation+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
           document.MYFORM.submit();   
		 }
		 else if (useCode=="N_SHIPCONT")
              {
		        document.MYFORM.action="../subwindow/TSDRQNotifyToFind.jsp?USECODE="+useCode+"&NCONTACTID="+nContactID+"&NCONTACT="+nContact+"&NLOCATIONID="+nLocationID+"&NLOCATION="+nLocation+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
                document.MYFORM.submit();   
		      }
   
} 
function subWindowDeliveryToFind(useCode,dCustID,dCustomer,dLocationID,dLocation,dContactID,dDeliverContact,dDeliverTo,dDeliverAddress,customerID,deliverTo)
{ 
  if (useCode=="D_CUSTOMER")
  {   
   document.MYFORM.action="../subwindow/TSDRQDeliverToFind.jsp?USECODE="+useCode+"&DCUSTOMERID="+dCustID+"&DCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&DDELIVERTO="+dDeliverTo+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
   document.MYFORM.submit();
  } else if (useCode=="D_LOCATION")
          {
		    document.MYFORM.action="../subwindow/TSDRQDeliverToFind.jsp?USECODE="+useCode+"&DCUSTOMERID="+dCustID+"&DCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&DDELIVERTO="+dDeliverTo+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
            document.MYFORM.submit();  
		  } else if (useCode=="D_CONTACT")
                  {
		           document.MYFORM.action="../subwindow/TSDRQDeliverToFind.jsp?USECODE="+useCode+"&DCUSTOMERID="+dCustID+"&DCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&DDELIVERTO="+dDeliverTo+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
                   document.MYFORM.submit();  
         		  } else if (useCode=="D_TO")
		                 {
				           document.MYFORM.action="../subwindow/TSDRQDeliverToFind.jsp?USECODE="+useCode+"&DCUSTOMERID="+dCustID+"&DCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&DDELIVERTO="+dDeliverTo+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo;
                           document.MYFORM.submit();           
				         }
} 
function setNotifyOK(setVal)
{    
 window.opener.document.DISPLAYREPAIR.NOTIFYSET.value=setVal;
 this.window.close();
}
function setNotifyCancel(setVal)
{
 window.opener.document.DISPLAYREPAIR.ACTIONID.value="--";    
 window.opener.document.DISPLAYREPAIR.NOTIFYSET.value=setVal;
 this.window.close();
}
function setDeliverOK(setVal)
{   
 window.opener.document.DISPLAYREPAIR.ACTIONID.value="--"; 
 window.opener.document.DISPLAYREPAIR.DELIVERSET.value=setVal;
 this.window.close();
}
function setDeliverCancel(setVal)
{
 window.opener.document.DISPLAYREPAIR.ACTIONID.value="--";    
 window.opener.document.DISPLAYREPAIR.DELIVERSET.value=setVal;
 this.window.close();
}
</script>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<style type="text/css">
<!--

-->
</style>
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
</head>
<%
%>
<body>
<FORM action="../jsp/TSSalesDRQDeliverInforSet.jsp" method="post" name="MYFORM">
<%
  String pageCh=request.getParameter("PAGECH");
  String customerID=request.getParameter("CUSTOMERID");
  
  String notifyContact=request.getParameter("NOTIFYCONTACT");
  String notifyLocation=request.getParameter("NOTIFYLOCATION");
  String shipContact=request.getParameter("SHIPCONTACT");
  String nContactID=request.getParameter("NCONTACTID");
  String nLocationID=request.getParameter("NLOCATIONID");
  String nShipContID=request.getParameter("NSHIPCONTID");
 /* 
  String ntfContact=request.getParameter("NCONTACT");
  String ntfLocation=request.getParameter("NLOCATION");
  String shpContact=request.getParameter("SCONTACT");
 */ 
  String deliverCustomer=request.getParameter("DELIVERCUSTOMER");
  String deliverLocation=request.getParameter("DELIVERLOCATION");
  String deliverContact=request.getParameter("DELIVERCONTACT");
  String deliverTo=request.getParameter("DELIVERTO");
  String deliverAddress=request.getParameter("DELIVERADDRESS");
  String dCustomerID=request.getParameter("DCUSTOMERID");
  String dLocationID=request.getParameter("DLOCATIONID");
  String dContactID=request.getParameter("DCONTACTID");
  String dDeliverTo=request.getParameter("DDELIVERTO");
  //String dDeliverAddress=request.getParameter("DLVADDRESS");
  
   //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
   cs1.setString(1,"41");
   cs1.execute();   
   cs1.close();
  
  
  
  
  String moContactInfo[]=new String[6]; // 宣告一維陣列,將Contact設定資訊置入Array
  String moDeliverInfo[]=new String[10]; // 宣告一維陣列,將Deliver設定資訊置入Array
  
  String a[]=array2DMOContactInfoBean.getArrayContent(); // 取一維陣列內容
  if (a!=null)
  {
    //out.println(array2DMOContactInfoBean.getArrayString()); // 把內容印出來
	//out.println("a[0]="+a[0]+ " a[1]=" +a[1]+" a[2]=" +a[2]+" a[3]="+a[3]+ " a[4]=" +a[4]+" a[5]=" +a[5]+"<BR>"); 
  }
  
  String b[]=array2DMODeliverInfoBean.getArrayContent(); // 取一維陣列內容
  if (b!=null)
  {
    //out.println(array2DMOContactInfoBean.getArrayString()); // 把內容印出來
	//out.println("b[0]="+b[0]+ " b[1]=" +b[1]+" b[2]=" +b[2]+" b[3]=" +b[3]+" b[4]="+b[4]+ " b[5]=" +b[5]+" b[6]=" +b[6]+" b[7]=" +b[7]+" b[8]=" +b[8]+" b[9]=" +b[9]+"<BR>"); 
  }
 
 if (pageCh.equals("DELIVER"))
 { 
  //若前一頁未取得DELIVER_TO 則,本頁預設由CUSTOMER_ID取_起
  if (deliverTo==null || deliverTo.equals("") || deliverTo.equals("null"))
  {
              Statement stateDlvTo=con.createStatement();
		      ResultSet rsDlvTo = stateDlvTo.executeQuery("select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1, a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME,"+
			                                              "a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION "+
														  "from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c "+
														  "where a.ADDRESS_ID = b.ADDRESS_ID and a.STATUS=b.STATUS "+
														  "and a.STATUS='A' and a.PAYMENT_TERM_ID = c.TERM_ID(+) and a.PRIMARY_FLAG='Y' "+
														  "and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+
														  "where to_char(CUST_ACCOUNT_ID) ='"+customerID+"' ) "+
														  "and a.SITE_USE_CODE = 'DELIVER_TO' ");
		      if (rsDlvTo.next()) 
		      { 
		        deliverTo = rsDlvTo.getString("SITE_USE_ID");
		      }
		      rsDlvTo.close();
		      stateDlvTo.close();
			  
		   // 若使用者未設定其他DeliverTo帶出Address則取客戶預設值__迄
		   if (deliverAddress==null || deliverAddress.equals("") || deliverAddress.equals("null"))
		   {  //out.println("NULL ADDRESS !");
		      // 取預設由客戶預設帶入的DeliverTo之對應DeliverAddress		   
		      Statement stateAds=con.createStatement();
		      ResultSet rsAds = stateAds.executeQuery("select LOCATION_ID,ADDRESS_LINE_1 from OE_DELIVER_TO_ORGS_V "+
		                                              "where to_char(CUSTOMER_ID) = '"+customerID+"' and PRIMARY_FLAG='Y' ");
		      if (rsAds.next()) 
		      { 
			    dLocationID = rsAds.getString("LOCATION_ID");
		        deliverAddress = rsAds.getString("ADDRESS_LINE_1");
		      }
		      rsAds.close();
		      stateAds.close();
		   } 
		   else {
		            //out.println("NULL ADDRESS 2!");
		        }
				// 若使用者未設定其他DeliverTo帶出Address則取客戶預設值_迄
		   
		   // 若使用者未設定其他DeliverLocation帶出Customer則取客戶預設值_起
		   if (deliverCustomer==null || deliverCustomer.equals("") || deliverCustomer.equals("null"))
		   {
		   
		      Statement stateCust=con.createStatement();
			  String sqlCust = "select /*+ INDEX(ACCT_SITE,HZ_CUST_ACCT_SITES_N2) */ "+
		                                                         "PARTY.PARTY_NAME CUSTOMER_NAME, cust_acct.account_number customer_Number, "+
													  "CUST_ACCT.CUST_ACCOUNT_ID "+		 
													  "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
													       "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
													       "HZ_CUST_ACCOUNTS CUST_ACCT "+
													  "where SITE.SITE_USE_CODE ='DELIVER_TO' "+
													    "and SITE.CUST_ACCT_SITE_ID = ACCT_SITE.CUST_ACCT_SITE_ID "+
													    "and ACCT_SITE.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID "+
													    "and PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID "+
														"and acct_site.status='A' and ACCT_SITE.CUST_ACCOUNT_ID='"+customerID+"' "+
														"and ACCT_SITE.CUST_ACCOUNT_ID=CUST_ACCT.CUST_ACCOUNT_ID "+
														"and CUST_ACCT.PARTY_ID=PARTY.PARTY_ID"+
														"and NVL(SITE.ORG_ID,NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1) ,' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99)) = "+
														    "NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99) "+
														"and NVL(ACCT_SITE.ORG_ID,NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99)) = "+
														    "NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99) "+
														"and CUST_ACCT.status='A' and site.status='A' "+
													  "order by SITE.LOCATION";
			  //out.println(sqlCust);
		      ResultSet rsCust = stateCust.executeQuery("select  /*+ INDEX(ACCT_SITE,HZ_CUST_ACCT_SITES_N2) */ "+
		                                                         "PARTY.PARTY_NAME CUSTOMER_NAME, cust_acct.account_number customer_Number, "+
																 "CUST_ACCT.CUST_ACCOUNT_ID "+
													  "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
													       "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
													       "HZ_CUST_ACCOUNTS CUST_ACCT "+
													  "where SITE.SITE_USE_CODE ='DELIVER_TO' "+
													    "and SITE.CUST_ACCT_SITE_ID = ACCT_SITE.CUST_ACCT_SITE_ID "+
													    "and ACCT_SITE.PARTY_SITE_ID = PARTY_SITE.PARTY_SITE_ID "+
													    "and PARTY_SITE.LOCATION_ID = LOC.LOCATION_ID "+
														"and acct_site.status='A' and to_char(ACCT_SITE.CUST_ACCOUNT_ID)='"+customerID+"' "+
														"and ACCT_SITE.CUST_ACCOUNT_ID=CUST_ACCT.CUST_ACCOUNT_ID "+
														"and CUST_ACCT.PARTY_ID=PARTY.PARTY_ID "+
														"and NVL(SITE.ORG_ID,NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1) ,' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99)) = "+
														    "NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99) "+
														"and NVL(ACCT_SITE.ORG_ID,NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99)) = "+
														    "NVL(TO_NUMBER(DECODE(SUBSTRB(USERENV('CLIENT_INFO'),1,1),' ',NULL,SUBSTRB(USERENV('CLIENT_INFO'),1,10))),-99) "+
														"and CUST_ACCT.status='A' and site.status='A' "+
													  "order by SITE.LOCATION");
		      if (rsCust.next()) 
		      { 
			    dCustomerID = rsCust.getString("CUST_ACCOUNT_ID");
		        deliverCustomer = rsCust.getString("CUSTOMER_NAME");				
		      }
		      rsCust.close();
		      stateCust.close();
		   } // 
		   // 若使用者未設定其他DeliverLocation帶出Customer則取客戶預設值_迄  
  } // End of if (deliverTo==null || deliverTo.equals("") || deliverTo.equals("null"))
  else {
           if (deliverAddress==null || deliverAddress.equals("") || deliverAddress.equals("null"))
		   {  
		      // 取預設由客戶預設帶入的DeliverTo之對應DeliverAddress		   
		      Statement stateAds=con.createStatement();
		      ResultSet rsAds = stateAds.executeQuery("select LOCATION_ID,ADDRESS_LINE_1 from OE_DELIVER_TO_ORGS_V "+
		                                              "where to_char(CUSTOMER_ID) = '"+customerID+"' and PRIMARY_FLAG='Y' ");
		      if (rsAds.next()) 
		      { 
			    dLocationID = rsAds.getString("LOCATION_ID");
		        deliverAddress = rsAds.getString("ADDRESS_LINE_1");
		      }
		      rsAds.close();
		      stateAds.close();
		   } 
       } // enf of else 
  //若前一頁未取得DELIVER_TO 則,本頁預設由CUSTOMER_ID取_迄  
  
 } // End of if (pageCh.equals("DELIVER"))
  
  if (notifyContact==null || notifyContact.equals("") || notifyContact.equals("null")) { notifyContact = ""; }
  
  if (nContactID==null || nContactID.equals("") || nContactID.equals("null") ) { nContactID= ""; }
  if (nContactID!=null && !nContactID.equals("") && !nContactID.equals("null")) 
  { moContactInfo[0] = nContactID;    
    moContactInfo[3] = notifyContact;  
  } else { 
           if (a!=null) 
		   { 
		     moContactInfo[0] = a[0]; 
			 moContactInfo[3] = a[3];
		   } 
         }
  
  if (notifyLocation==null || notifyLocation.equals("") || notifyLocation.equals("null")) { notifyLocation = ""; }
  
  if (nLocationID==null || nLocationID.equals("") || nLocationID.equals("null")) nLocationID = "";
  if (nLocationID!=null && !nLocationID.equals("") && !nLocationID.equals("null")) 
  { 
   moContactInfo[1] = nLocationID; 
   moContactInfo[4] = notifyLocation; 
  } else {
          if (a!=null) 
		  {  
		   moContactInfo[1] = a[1]; 
		   moContactInfo[4] = a[4];
		  }
         }
  
  if (shipContact==null || shipContact.equals("") || shipContact.equals("null")) { shipContact = ""; }
  if (shipContact!=null && !shipContact.equals("") && !shipContact.equals("null")) 
  {
   moContactInfo[2] = nShipContID;  
   moContactInfo[5] = shipContact;      
  } else {
           if (a!=null) 
		   {  
		     moContactInfo[2] = a[2];
			 moContactInfo[5] = a[5];
		   }
         } 
 
  
  if (deliverCustomer==null || deliverCustomer.equals("null")) deliverCustomer = "";
  if (dCustomerID!=null && !dCustomerID.equals("") && !dCustomerID.equals("null"))
  {
     moDeliverInfo[0] = dCustomerID;
	 moDeliverInfo[4] = deliverCustomer;
  } else {
            if (b!=null)
			{
			  moDeliverInfo[0] = b[0];
	          moDeliverInfo[4] = b[4];
			} 
         }
  if (deliverLocation==null || deliverLocation.equals("") || deliverLocation.equals("null")) deliverLocation = deliverTo;
  if (dLocationID !=null && !dLocationID.equals("") && !dLocationID.equals("null"))
  {
     moDeliverInfo[1] = dLocationID;
	 moDeliverInfo[5] = deliverLocation;   
  } else {
            if (b!=null)
			{  
			  moDeliverInfo[1] = b[1];
	          moDeliverInfo[5] = b[5];    
			}    
         }
  if (deliverContact==null || deliverContact.equals("") || deliverContact.equals("null")) deliverContact = "";
  if (dContactID !=null && !dContactID.equals("") && !dContactID.equals("null")) 
  {
     moDeliverInfo[8] = dContactID;
	 moDeliverInfo[9] = deliverContact;  
  } else {
            if (b!=null)
			{ 
			  moDeliverInfo[8] = b[8];
	          moDeliverInfo[9] = b[9];          
			}  
         }
		 
		 
  if (deliverTo!=null && !deliverTo.equals("") && !deliverTo.equals("null")) 
  { 
     moDeliverInfo[2] = deliverTo; 
	 moDeliverInfo[6] = deliverTo; 
  }
  else { 
            if (b!=null)
			{
			   moDeliverInfo[2] = b[2];  
			   moDeliverInfo[6] = b[6]; 
			}   
       }
  if (deliverAddress==null || deliverAddress.equals("") || deliverAddress.equals("null")) deliverAddress="";
  if (deliverAddress!=null && !deliverAddress.equals("") && !deliverAddress.equals("null"))
  {
     moDeliverInfo[7] = deliverAddress;
  }
  else {
         if (b!=null)
		 {
		   moDeliverInfo[7] = b[7]; 
		 }           
       }
  
  
  //out.println(deliverTo);
 /* 
  String a[]=array2DMOContactInfoBean.getArrayContent(); // 取一維陣列內容
  if (a!=null)
  {
    //out.println(array2DMOContactInfoBean.getArrayString()); // 把內容印出來
	out.println("a[0]="+a[0]+ " a[1]=" +a[1]+" a[2]=" +a[2]+" a[3]=" +a[3]+" a[4]=" +a[4]+" a[5]=" +a[5]+" a[6]=" +a[6]+"<BR>"); 
  }
  */
  String imgBaseL = "../images/tl_j.gif";
  String imgBaseC = "../images/tc_j.gif";
  String imgBaseR = "../images/tr_j.gif";
  String imgChoseL = "../images/ttl_j.gif";
  String imgChoseC = "../images/ttc_j.gif";
  String imgChoseR = "../images/ttr_j.gif";
  
  
 
 
%>
<table width='85%'  cellspacing=0 cellpadding=2 border=0>
<tr><td align='left' colspan=3>
<A href="/oradds/ORAddsMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHOME"/></A>
</td></tr>
</table>
	<TABLE WIDTH='85%'  CELLSPACING=0 CELLPADDING=0 border=0>
<TR>
<TD align=left width="100%">
 <TABLE CELLSPACING=0 CELLPADDING=0 border=0 align="left">
   <TR>   
    <td width=9><img src='<% if (pageCh.equals("NOTIFY")) out.print(imgChoseL); else out.println(imgBaseL); %>' width=9 height=27></td><td background='<% if (pageCh.equals("NOTIFY")) out.print(imgChoseC); else out.println(imgBaseC); %>'>
	<a href="../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=NOTIFY&NCONTACTID=<%=nContactID%>&NOTIFYCONTACT=<%=notifyContact%>&NLOCATIONID=<%=nLocationID%>&NOTIFYLOCATION=<%=notifyLocation%>&NSHIPCONTID=<%=nShipContID%>&SHIPCONTACT=<%=shipContact%>&DELIVERCUSTOMER=<%=deliverCustomer%>&DELIVERLOCATION=<%=deliverLocation%>&DELIVERTO=<%=deliverTo%>&DELIVERADDRESS=<%=deliverAddress%>&CUSTOMERID=<%=customerID%>"><font color=black>
	<jsp:getProperty name="rPH" property="pgNotifyContact"/>    
	</font></a>
	</td>
    <td width=9><img src='<% if (pageCh.equals("NOTIFY")) out.print(imgChoseR); else out.println(imgBaseR); %>' width=9 height=27></td>	
    <td width=9><img src='<% if (pageCh.equals("DELIVER")) out.print(imgChoseL); else out.println(imgBaseL); %>' width=9 height=27></td><td background='<% if (pageCh.equals("DELIVER")) out.print(imgChoseC); else out.println(imgBaseC); %>'>
	<a href="../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=DELIVER&NCONTACTID=<%=nContactID%>&NOTIFYCONTACT=<%=notifyContact%>&NLOCATIONID=<%=nLocationID%>&NOTIFYLOCATION=<%=notifyLocation%>&NSHIPCONTID=<%=nShipContID%>&SHIPCONTACT=<%=shipContact%>&DELIVERCUSTOMER=<%=deliverCustomer%>&DELIVERLOCATION=<%=deliverLocation%>&DELIVERTO=<%=deliverTo%>&DELIVERADDRESS=<%=deliverAddress%>&CUSTOMERID=<%=customerID%>&DCUSTOMERID=<%=dCustomerID%>&DELIVERCUSTOMER=<%=deliverCustomer%>"><font color=black>
	<jsp:getProperty name="rPH" property="pgDeliverCustomer"/>
	</font></a>
	</td><td width=9><img src='<% if (pageCh.equals("DELIVER")) out.print(imgChoseR); else out.println(imgBaseR); %>' width=9 height=27></td>
   </TR>
  </TABLE>
</TD>
</TR>
</TABLE>
<%
 if (pageCh.equals("NOTIFY"))
 {
   //moContactInfo[0] = notifyContact;
   //moContactInfo[1] = notifyLocation;
   //moContactInfo[2] = shipContact;
   array2DMOContactInfoBean.setArrayString(moContactInfo);
%>
<table border=0 cellspacing=1 cellpadding=4 width='65%' bgcolor="#CCCC99">
<tr class='head'>
<td nowrap align=center width=32%><font color="#993300"><jsp:getProperty name="rPH" property="pgNotifyContact"/></font></td>
<td nowrap align=center width=68%><font color='#993300'><b><input type="hidden" name="NCONTACTID" value="<%if (nContactID!=null && !nContactID.equals("") && !nContactID.equals("null")) out.println(nContactID); else { if (a!=null && a[0]!=null) { out.println(a[0]); } } %>" size="5">
                                                           <input type="text" name="NOTIFYCONTACT" value="<% if (notifyContact!=null && !notifyContact.equals("") && !notifyContact.equals("null")) out.println(notifyContact); else { if (a!=null && a[3]!=null) { out.println(a[3]); } } %>" size="40">
                                                           <INPUT TYPE="button" tabindex='4'  value="..." onClick='subWindowNotifyToFind("N_CONTACT","<%=nContactID%>","<%=notifyContact%>","<%=nLocationID%>","<%=notifyLocation%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td nowrap align=center width=32%><font color='#993300'><jsp:getProperty name="rPH" property="pgNotifyLocation"/></font></td>
<td align=center width=68%><font color='#993300'><b><input type="hidden" name="NLOCATIONID" value="<%if (nLocationID!=null && !nLocationID.equals("") && !nLocationID.equals("null")) out.println(nLocationID); else { if (a!=null && a[1]!=null) { out.println(a[1]); } } %>" size="5">
                                                    <input type="text" name="NOTIFYLOCATION" value="<%if (notifyLocation!=null && !notifyLocation.equals("") && !notifyLocation.equals("null")) out.println(notifyLocation); else { if (a!=null && a[4]!=null) { out.println(a[4]); } } %>" size="40">
													<INPUT TYPE="button" tabindex='6'  value="..." onClick='subWindowNotifyToFind("N_LOCATION","<%=nContactID%>","<%=notifyContact%>","<%=nLocationID%>","<%=notifyLocation%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td width="32%" align=center nowrap><font color='#993300'><b><jsp:getProperty name="rPH" property="pgShipContact"/></b></font></td>
<td width="68%" align=center nowrap><font color='#993300'><b><input type="hidden" name="NSHIPCONTID" value="<%if (nShipContID!=null && !nShipContID.equals("") && !nShipContID.equals("null")) out.println(nShipContID); else { if (a!=null && a[2]!=null) { out.println(a[2]); } }%>" size="5">
                                                             <input type="text" name="SHIPCONTACT" value="<%if (shipContact!=null && !shipContact.equals("") && !shipContact.equals("null")) out.println(shipContact); else { if (a!=null && a[5]!=null) { out.println(a[5]); } }%>" size="40">
															 <INPUT TYPE="button" tabindex='8'  value="..." onClick='subWindowNotifyToFind("N_SHIPCONT","<%=nContactID%>","<%=notifyContact%>","<%=nLocationID%>","<%=notifyLocation%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
</table>
<INPUT TYPE="button" tabindex='9'  value="OK" onClick='setNotifyOK("Y")'>
<INPUT TYPE="button" tabindex='10'  value="Cancel" onClick='setNotifyCancel("N")'>
<%

 } else if (pageCh.equals("DELIVER"))
        {
		   //moDeliverInfo[3] = deliverCustomer;
		   //moDeliverInfo[4] = deliverLocation;
		   //moDeliverInfo[5] = deliverTo;
		   //moDeliverInfo[6] = deliverAddress;
		   array2DMODeliverInfoBean.setArrayString(moDeliverInfo);
		   
		   
%>
<table border=0 cellspacing=1 cellpadding=4 width='65%' bgcolor="#CCCC99">
<tr class='head'>
<td nowrap align=center width=32%><font color='#993300'><jsp:getProperty name="rPH" property="pgDeliverCustomer"/></font></td>
<td nowrap align=center width=68%><font color='#993300'><b><input type="hidden" name="DCUSTOMERID" value="<%if (dCustomerID!=null && !dCustomerID.equals("") && !dCustomerID.equals("null")) out.println(dCustomerID); else { if (b!=null && b[0]!=null) { out.println(b[0]); } }%>" size="5">
                                                           <input type="text" name="DELIVERCUSTOMER" value="<%if (deliverCustomer!=null && !deliverCustomer.equals("") && !deliverCustomer.equals("null")) out.println(deliverCustomer); else { if (b!=null && b[4]!=null) { out.println(b[4]); } }%>" size="40">
														   <INPUT TYPE="button" tabindex='4'  value="..." onClick='subWindowDeliveryToFind("D_CUSTOMER","<%=dCustomerID%>","<%=deliverCustomer%>","<%=dLocationID%>","<%=deliverLocation%>","<%=dContactID%>","<%=deliverContact%>","<%=dDeliverTo%>","<%=deliverAddress%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td nowrap align=center width=32%><font color='#993300'><jsp:getProperty name="rPH" property="pgDeliverLocation"/></font></td>
<td align=center width=68%><font color='#993300'><b><input type="hidden" name="DLOCATIONID" value="<%if (dLocationID!=null && !dLocationID.equals("") && !dLocationID.equals("null")) out.println(dLocationID); else { if (b!=null && b[1]!=null) { out.println(b[1]); } }%>" size="5">
                                                    <input type="text" name="DELIVERLOCATION" value="<%if (deliverLocation!=null && !deliverLocation.equals("") && !deliverLocation.equals("null")) out.println(deliverLocation); else { if (b!=null && b[5]!=null) { out.println(b[5]); } }%>" size="40">
													<INPUT TYPE="button" tabindex='4'  value="..." onClick='subWindowDeliveryToFind("D_LOCATION","<%=dCustomerID%>","<%=deliverCustomer%>","<%=dLocationID%>","<%=deliverLocation%>","<%=dContactID%>","<%=deliverContact%>","<%=dDeliverTo%>","<%=deliverAddress%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td nowrap align=center width=32%><font color='#993300'><jsp:getProperty name="rPH" property="pgDeliverContact"/></font></td>
<td align=center width=68%><font color='#993300'><b><input type="hidden" name="DCONTACTID" value="<%if (dContactID!=null && !dContactID.equals("") && !dContactID.equals("null")) out.println(dContactID); else { if (b!=null && b[8]!=null) { out.println(b[8]); } }%>" size="5">
                                                    <input type="text" name="DELIVERCONTACT" value="<%if (deliverContact!=null && !deliverContact.equals("") && !deliverContact.equals("null")) out.println(deliverContact); else { if (b!=null && b[9]!=null) { out.println(b[9]); } }%>" size="40">
													<INPUT TYPE="button" tabindex='4'  value="..." onClick='subWindowDeliveryToFind("D_CONTACT","<%=dCustomerID%>","<%=deliverCustomer%>","<%=dLocationID%>","<%=deliverLocation%>","<%=dContactID%>","<%=deliverContact%>","<%=dDeliverTo%>","<%=deliverAddress%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td width="32%" align=center nowrap><font color='#993300'><b><jsp:getProperty name="rPH" property="pgDeliveryTo"/></b></font></td>
<td width="68%" align=center nowrap><font color='#993300'><b><input type="hidden" name="DDELIVERTO" value="<%if (dDeliverTo!=null && !dDeliverTo.equals("") && !dDeliverTo.equals("null")) out.println(dDeliverTo); else { if (b!=null && b[2]!=null) { out.println(b[2]); } }%>" size="5">
                                                             <input type="text" name="DELIVERTO" value="<%if (deliverTo!=null && !deliverTo.equals("") && !deliverTo.equals("null")) out.println(deliverTo); else { if (b!=null && b[6]!=null) { out.println(b[6]); } }%>" size="40">
															 <INPUT TYPE="button" tabindex='4'  value="..." onClick='subWindowDeliveryToFind("D_TO","<%=dCustomerID%>","<%=deliverCustomer%>","<%=dLocationID%>","<%=deliverLocation%>","<%=dContactID%>","<%=deliverContact%>","<%=dDeliverTo%>","<%=deliverAddress%>","<%=customerID%>","<%=deliverTo%>")'></b></font></td>
</tr>
<tr class='head'>
<td width="32%" align=center nowrap><font color='#993300'><b><jsp:getProperty name="rPH" property="pgDeliverAddress"/></b></font></td>
<td width="68%" align=center nowrap><font color='#993300'><b><input type="text" name="DELIVERADDRESS" value="<%if (deliverAddress!=null && !deliverAddress.equals("") && !deliverAddress.equals("null")) out.println(deliverAddress); else { if (b!=null && b[7]!=null) { out.println(b[7]); } }%>" size="40"></b></font></td>
</tr>
</table>
<INPUT TYPE="button" tabindex='9'  value="OK" onClick='setDeliverOK("Y")'>
<INPUT TYPE="button" tabindex='10'  value="Cancel" onClick='setDeliverCancel("N")'>
<%
  }  // End of else if (pageCh.equals("DELIVER"))
  
 
%>
<input name="CUSTOMERID" type="hidden" value="<%=customerID%>" >
<input name="NCONTACT" type="hidden" value="<%=notifyContact%>" >
<input name="NLOCATION" type="hidden" value="<%=notifyLocation%>" >
<input name="SCONTACT" type="hidden" value="<%=shipContact%>" >

</FORM>
 <!--=============以下區段為釋放連結池==========--> 
 <%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
