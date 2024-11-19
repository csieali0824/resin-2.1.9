<!-- 20141211 by Peggy,EDI客戶的RFQ也須要求輸入CUSTOMER PO LINE NUMBER-->
<!-- 20160321 by Peggy,for cust price issue-->
<!-- 20160805 by Peggy,開放樣品rfq給他區查詢-->
<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String orgID=request.getParameter("ORGID");
String customerNo=request.getParameter("CUSTOMERNO");
String name=request.getParameter("NAME");
String salesAreaNo=request.getParameter("SAREANO");  // 2007/05/17 增加依業務人員主要地區
String searchString=request.getParameter("SEARCHSTRING");
String FuncName=request.getParameter("FuncName");  //add by Peggy 20111004
if (FuncName == null) FuncName = ""; //add by Peggy 20111004
String ODRTYPE=request.getParameter("ODRTYPE"); //add by Peggy 20220808
if (ODRTYPE==null || ODRTYPE.equals("--")) ODRTYPE="";

//out.println("FuncName="+FuncName);
if (orgID==null || orgID.equals("")) orgID = "41"; // 若沒給或沒取到,則預設是半導體業務部
 
try
{
	if (searchString==null)
   	{     	  
		if (customerNo!=null && !customerNo.equals(""))
		{
			searchString=customerNo;
		}
	 	else if (name!=null && !name.equals(""))
		{
			searchString=name;
		}
	 	else 
		{ 
			searchString="%"; 
		}
   	} 
    else 
	{  
	}


} 
catch (Exception e)
{
	out.println("Exception2:"+e.getMessage());
}   

/*
//20110627 liling for excle 上傳沒抓到業務區
if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("null"))
{ 
	Statement statement=con.createStatement();
 	ResultSet rs=null;	
 	String SQL = "select SALES_AREA_NO from ORADDMAN.TSSALES_AREA WHERE SALES_AREA_NO='"+userActCenterNo+"' ";				   
 	rs=statement.executeQuery(SQL);		           
 	if (rs.next())   
 	{	 
   		salesAreaNo=rs.getString(1);
  	}
  	rs.close();   
  	statement.close(); 
}

// 2007/05/17 依使用者選擇的業務地區代號取出業務群組找出可供挑選的客戶
String salesChGroupID = userSalesGroupID; // 預設值是使用者的預設業務群組
Statement stateGrpID=con.createStatement();
String PAR_ORG_ID = ""; //add by Peggy 20120525
String sqlGrpID = "select GROUP_ID,PAR_ORG_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = '"+salesAreaNo+"' ";  
ResultSet rsGrpID = stateGrpID.executeQuery(sqlGrpID);
if (rsGrpID.next())
{
	salesChGroupID = rsGrpID.getString("GROUP_ID");
	PAR_ORG_ID = rsGrpID.getString("PAR_ORG_ID");
}
rsGrpID.close();
stateGrpID.close();
*/

//modify by Peggy 20140314,調整code寫法,減少read db次數
String salesChGroupID = "";
String PAR_ORG_ID = ""; 
Statement statementk=con.createStatement();
String SQL = "select SALES_AREA_NO ,GROUP_ID,PAR_ORG_ID from ORADDMAN.TSSALES_AREA WHERE 1=1";
if (FuncName.equals("D2002") && customerNo.equals("10877"))  
{
	salesAreaNo ="020"; //開放他區業務可查樣品區rfq,add by Peggy 20160805
}
if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("null"))
{
	SQL += " and SALES_AREA_NO in ("+UserRegionSet+")";
}
else
{
	SQL += " and SALES_AREA_NO = '"+salesAreaNo+"'";
}
ResultSet rsk =statementk.executeQuery(SQL);		           
while (rsk.next())   
{	
	if (salesAreaNo==null || salesAreaNo.equals("") || salesAreaNo.equals("null"))
	{ 
		salesAreaNo=rsk.getString(1);
	}
	if (PAR_ORG_ID==null || PAR_ORG_ID.equals(""))
	{
		PAR_ORG_ID=rsk.getString(3);
	}
	if (!salesChGroupID.equals("")) salesChGroupID +=",";
	salesChGroupID  += rsk.getString(2);
}
if (salesChGroupID.equals("")) salesChGroupID =userSalesGroupID;

rsk.close();   
statementk.close(); 

%>
<html>
<head>
<title>Page for choose Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(custID,custNo,custName,custActive,custAROverdue,funcname,custMarketGroup,ShipToOrg,shipAddress,shipCountry,billTo,billAddress,billCountry,payTermID,paymentTerm,fobPoint,firmPriceList,shipVia,curr,salesArea,Flag,deliveryTo,deliveryAddress,deliveryCountry,shipToContactid,shipToContact,taxCode,salesGroupId,SupplierFlag)
{
	if (funcname == "D9001")
	{
		window.opener.document.MYFORM.CUSTOMERID.value=custID; 
		window.opener.document.MYFORM.CUSTOMERNO.value=custNo;
		window.opener.document.MYFORM.CUSTOMERNAME.value=custName;
	}
	else
	{
		window.opener.document.MYFORM.CUSTACTIVE.value=custActive;
		window.opener.document.MYFORM.CUSTOMERID.value=custID; 
		window.opener.document.MYFORM.CUSTOMERNO.value=custNo;
		window.opener.document.MYFORM.CUSTOMERNAME.value=custName;
		window.opener.document.MYFORM.CUSTOMERAROVERDUE.value=custAROverdue;
		if (funcname == "D1001")
		{
			if (fobPoint =="null" || fobPoint==null) fobPoint="";   //add by Peggy 20120522
			if (paymentTerm=="null" || paymentTerm ==null) paymentTerm=""; //add by Peggy 20120522
			window.opener.document.MYFORM.SHIPTOORG.value = ShipToOrg;
			window.opener.document.MYFORM.SHIPADDRESS.value = shipAddress;
			window.opener.document.MYFORM.SHIPCOUNTRY.value = shipCountry;
			window.opener.document.MYFORM.PAYTERM.value = paymentTerm;
			window.opener.document.MYFORM.PAYTERMID.value = payTermID;
			window.opener.document.MYFORM.BILLTO.value = billTo;
			window.opener.document.MYFORM.BILLADDRESS.value= billAddress;
			window.opener.document.MYFORM.BILLCOUNTRY.value=billCountry;
			window.opener.document.MYFORM.FOBPOINT.value=fobPoint;
			window.opener.document.MYFORM.SALES_GROUP_ID.value = salesGroupId;   //add by Peggy 20210528 
			window.opener.document.MYFORM.SUPPLIER_FLAG.value=SupplierFlag;  //add by Peggy 20220428
			if (window.opener.document.MYFORM.SALES_GROUP_ID.value=="509")
			{
				window.opener.document.MYFORM.PREORDERTYPE.value="1763"; //1132訂單 add by Peggy 20210528
			}			
			//modify by Peggy 20130424
			if (window.opener.document.MYFORM.SALESAREANO.value=="001" && custNo =="1202"  && window.opener.document.MYFORM.PREORDERTYPE.value=="1342")
			{
				if (window.opener.document.MYFORM.CURR.value=="USD")
				{
					window.opener.document.MYFORM.FIRMPRICELIST.value="6038";
					window.opener.document.MYFORM.ORIGPRICELIST.value="6038";//add by Peggy 20130909
				}
				else if (window.opener.document.MYFORM.CURR.value=="EUR")
				{
					window.opener.document.MYFORM.FIRMPRICELIST.value="7331";
					window.opener.document.MYFORM.ORIGPRICELIST.value="7331";//add by Peggy 20130909
				}
			}
			else
			{
				window.opener.document.MYFORM.FIRMPRICELIST.value=firmPriceList;
				window.opener.document.MYFORM.ORIGPRICELIST.value=firmPriceList;//add by Peggy 20130909
			}
			window.opener.document.MYFORM.SHIPVIA.value=shipVia;
			window.opener.document.MYFORM.LINEFOB.value=fobPoint; //add by Peggy 20120423
			window.opener.document.MYFORM.DELIVERYTO.value = deliveryTo;           //add by Peggy 20130218
			window.opener.document.MYFORM.DELIVERYADDRESS.value= deliveryAddress;  //add by Peggy 20130218
			window.opener.document.MYFORM.DELIVERYCOUNTRY.value=deliveryCountry;   //add by Peggy 20130218
			window.opener.document.MYFORM.SHIPTOCONTACTID.value= shipToContactid;  //add by Peggy 20130218
			window.opener.document.MYFORM.SHIPTOCONTACT.value=shipToContact;       //add by Peggy 20130218
			//add by Peggy 20130411
			if (window.opener.document.MYFORM.SALESAREANO.value =="001")
			{  
				window.opener.document.MYFORM.TAXCODE.value=taxCode;                   
			}
			if (salesArea !="020" && shipVia != null && shipVia !="null")         //add by Peggy 20120417
			{
				window.opener.document.MYFORM.SHIPPINGMETHOD.value=shipVia;
			}
			//add by Peggy 20130411
			if (window.opener.document.MYFORM.SALESAREANO.value !="001" || window.opener.document.MYFORM.PREORDERTYPE.value != "1342")
			{
				if	(curr==null||curr==""||curr=="null") 
				{
					window.opener.document.MYFORM.CURR.value=""; 
					window.opener.document.MYFORM.ORIGCURR.value="";
				}
				else
				{
					window.opener.document.MYFORM.CURR.value=curr; 
					window.opener.document.MYFORM.ORIGCURR.value=curr;
				}
			}
			if (window.opener.document.MYFORM.CUSTMARKETGROUP.value=="AU" && custMarketGroup != "AU")
			{
				window.opener.document.MYFORM.PLANTCODE.value = "";
			}
			window.opener.document.MYFORM.CUSTMARKETGROUP.value=custMarketGroup;
			if (window.opener.document.MYFORM.CUSTMARKETGROUP.value=="AU" || window.opener.document.MYFORM.showCRD.value=="Y")
			{
				window.opener.document.MYFORM.btplant.disabled=false;
			}
			else
			{
				window.opener.document.MYFORM.btplant.disabled=true;
			}
			if (custAROverdue=="Y")
			{
				window.opener.document.MYFORM.AROVERDUEDESC.value="Customer AR overdue 90 days!! ";
			} 	
			else
			{
				window.opener.document.MYFORM.AROVERDUEDESC.value=" ";
			} 
			if (Flag=="Y")
			{
				window.opener.document.MYFORM.submit();
			}
			else if (window.opener.document.MYFORM.ENDCUSTPOLINENO!=undefined)
			{
				window.opener.document.MYFORM.submit();
			}
			else
			{
				window.opener.document.MYFORM.submit();
			}			
		}
	}
  	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQCustomerInfoFind.jsp" NAME=CUSTFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgCustNo"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgCustomerName"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name='rPH' property='pgQuery'/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgCustomerName"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
<BR>
<%     
	int queryCount = 0;
    Statement statement=con.createStatement();
	try
    { 
		//add by Peggy 20120303
		CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
		cs1.setString(1,PAR_ORG_ID);  // 取業務員隸屬ParOrgID
		cs1.execute();
		cs1.close();	
		if (searchString!="" && searchString!=null) 
	   	{  	
			String sql = "";
		 	String where =""; 
		 	String order =	"";	
			String ShipToOrg ="";     //add by Peggy 20120303
			String shipAddress = "";  //add by Peggy 20120303
			String shipCountry = "";  //add by Peggy 20120303
			String payTermID = "";    //add by Peggy 20120303
			String paymentTerm = "";  //add by Peggy 20120303
			String fobPoint = "";     //add by Peggy 20120303
			String firmPriceList = "";//add by Peggy 20120303
			String billTo = "";       //add by Peggy 20120303
			String billAddress = "";  //add by Peggy 20120303
			String billCountry = "";  //add by Peggy 20120303	
			String ship_via = "";     //add by Peggy 20120321	
			String curr = "";         //add by Peggy 20120326	
			String shipToContact="";  //add by Peggy 20130218
			String shipToContactid="";//add by Peggy 20130218
			String deliveryTo = "",	deliveryAddress = "", deliveryCountry = "";   //add by Peggy 20130218
			String taxCode = "",sales_group_id="";      //add by Peggy 20130411
				        
			if (UserRoles.equals("admin"))  // 設定管理員可看得到所有客戶
			{
				sql = " select a.CUSTOMER_ID, a.CUSTOMER_NUMBER, REPLACE(a.CUSTOMER_NAME,'\''',' ') as CUSTOMER_NAME,"+
					        " nvl(a.ATTRIBUTE3,'N') as AR_OVERDUE "+
							",a.ATTRIBUTE2 market_group "+ //add by Peggy 20111004
							",a.STATUS"+ //add by peggy 20111004
							",decode(d.customer_id, null,'N','Y') flag"+ //add by peggy 20120601
							",TSC_LABEL_PKG.SUPPLIER_NUMBER_REQUIREMENT(a.CUSTOMER_ID) SUPPLIER_FLAG"+//add by Peggy 20220428
			               // "  from APPS.RA_CUSTOMERS ";
						    "  from APPS.AR_CUSTOMERS a"+  //20110826 modify by Peggy for R12 upgrade
							//",(SELECT customer_id FROM ORADDMAN.tscust_special_setup where  sales_area_no ='"+salesAreaNo+"' and active_flag='A') d"; //add by Peggy 20120601
							",(SELECT customer_id FROM ORADDMAN.tscust_special_setup where  sales_area_no ='"+salesAreaNo+"' and active_flag='A'"+   //add by Peggy 20141211
							"  UNION ALL"+
							"  SELECT CUSTOMER_ID FROM TSC_EDI_CUSTOMER WHERE SALES_AREA_NO ='"+salesAreaNo+"' and (INACTIVE_DATE IS NULL OR INACTIVE_DATE > TRUNC(SYSDATE))"+ 
							"  GROUP BY CUSTOMER_ID) d"; 
				where = " where (a.CUSTOMER_NUMBER ='"+searchString+"' or "+
							  " a.CUSTOMER_NUMBER like '"+searchString+"%' or a.CUSTOMER_NAME like '"+searchString+"%' "+
							  " or a.CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') AND a.STATUS='A'"+	 //add by Peggy 20120420 status=A
							  " and a.CUSTOMER_ID=d.customer_id(+)"; //add by Peggy 20120601
				order = " order by a.CUSTOMER_ID "; 
					  
				//String sqlCNT = "select count(DISTINCT CUSTOMER_ID) from APPS.RA_CUSTOMERS " + where;  
				//String sqlCNT = "select count(DISTINCT CUSTOMER_ID) from APPS.AR_CUSTOMERS " + where;  //Add by Peggy 20111019 for R12 Upgrade
				String sqlCNT = "select count(1) from ("+sql+where+order+")";  //modify by Peggy 20120601
				//out.println(sqlCNT);
				ResultSet rsCNT = statement.executeQuery(sqlCNT);
				if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		        rsCNT.close();
			}
			//modify by Peggy 20110623,依User選擇的業務區域帶出對應的客戶list
			else if (salesChGroupID != null && !salesChGroupID.equals("")) 
			{	
				sql = " select DISTINCT a.CUST_ACCOUNT_ID, c.CUSTOMER_NUMBER,"+
					        " REPLACE(c.CUSTOMER_NAME,'\''',' ') as CUSTOMER_NAME, nvl(c.ATTRIBUTE3,'N') as AR_OVERDUE "+
							",c.ATTRIBUTE2 market_group "+ //add by Peggy 20111004
							",c.STATUS"+ //add by peggy 20111004
							", decode(d.customer_id, null,'N','Y') flag"+ //add by peggy 20120601
							",TSC_LABEL_PKG.SUPPLIER_NUMBER_REQUIREMENT(a.CUST_ACCOUNT_ID) SUPPLIER_FLAG"+//add by Peggy 20220428
			                //"  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c ";		
							"  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c "+ //20110826 modify by Peggy for R12 upgrade		
							//",(SELECT customer_id FROM ORADDMAN.tscust_special_setup where  sales_area_no ='"+salesAreaNo+"' and active_flag='A') d"; //add by Peggy 20120601
							",(SELECT customer_id FROM ORADDMAN.tscust_special_setup where  sales_area_no ='"+salesAreaNo+"' and active_flag='A'"+ //add by Peggy 20141211
							"  UNION ALL"+
							"  SELECT CUSTOMER_ID FROM TSC_EDI_CUSTOMER WHERE SALES_AREA_NO ='"+salesAreaNo+"' and (INACTIVE_DATE IS NULL OR INACTIVE_DATE > TRUNC(SYSDATE))"+ 
							"  GROUP BY CUSTOMER_ID) d"; //add by Peggy 20120601
				where = " where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+
					          "  and b.attribute1 in ("+salesChGroupID+") "+
							  "  and a.STATUS = b.STATUS and a.ORG_ID = b.ORG_ID "+										
							  "  and a.ORG_ID ="+orgID+" and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
							  "  and (CUSTOMER_NUMBER ='"+searchString+"' or c.CUSTOMER_NUMBER like '"+searchString+"%' "+
							  " or c.CUSTOMER_NAME like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') and c.STATUS='A'"+ //add by Peggy 20120420 status=A
							  " and a.CUST_ACCOUNT_ID=d.customer_id(+)"; //add by Peggy 20120601
				order = " order by CUST_ACCOUNT_ID ";    
					  
				//String sqlCNT = " select count(DISTINCT a.CUST_ACCOUNT_ID) "+
				//	                  //" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c " + where;  
				//					  " from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c " + where;   //20110826 modify by Peggy for R12 upgrade	
				String sqlCNT = "select count(1) from ("+sql+where+order+")";  //modify by Peggy 20120601
				//out.println(sqlCNT);						
				ResultSet rsCNT = statement.executeQuery(sqlCNT);
				if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		        rsCNT.close();  
			}	
			sql = sql + where + order;
			//out.println("sql="+sql);
			if (sql.length() >0)
			{
				int rowcnt=0,colCount=0;
				String custActive=null,customerID=null,custNo=null,custName=null,custAROverdue=null,custFlag="";
				String custMarketGroup=""; //add by Peggy 20111004
				String buttonContent=null;
				String trBgColor = "";
        		ResultSet rs=statement.executeQuery(sql);	
				while (rs.next())
				{	
					if (rowcnt ==0)
					{
						ResultSetMetaData md=rs.getMetaData();
						colCount=md.getColumnCount();
						String colLabel[]=new String[colCount+1];        
						out.println("<TABLE>");      
						out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
						//for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
						for (int i=2;i<=colCount-2;i++) // modify by Peggy 20111011,status,market group不顯示
						{
							colLabel[i]=md.getColumnLabel(i);
							out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
						} //end of for 
						out.println("</TR>");
					}	
		 
					customerID=rs.getString(1);
					custNo=rs.getString("CUSTOMER_NUMBER");
					custName=rs.getString("CUSTOMER_NAME");
					custAROverdue=rs.getString("AR_OVERDUE");
					custActive=rs.getString("STATUS");
					custMarketGroup=rs.getString("MARKET_GROUP");  //add by Peggy 20111004
					custFlag=rs.getString("FLAG");//add by Peggy 20120601
					if (custMarketGroup==null) custMarketGroup="";
					out.println("<input type='hidden' name='CUSTACTIVE' value='"+custActive+"' >");
					out.println("<input type='hidden' name='CUSTID' value='"+customerID+"' >");
					out.println("<input type='hidden' name='CUSTNO' value='"+custNo+"' >");
					out.println("<input type='hidden' name='CUSTNAME' value='"+custName+"' >");
					out.println("<input type='hidden' name='CUSTAROVERDUE' value='"+custAROverdue+"' >");
					out.println("<input type='hidden' name='CUSTMARKETGROUP' value='"+custMarketGroup+"' >");  //add by Peggy 20111004
		 			out.println("<input type='hidden' name='FuncName' value='"+FuncName+"'>");                  //add by Peggy 20111011
		 			out.println("<input type='hidden' name='FLAG' value='"+custFlag+"'>");                  //add by Peggy 20111011
		 			out.println("<input type='hidden' name='SUPPLIER_FLAG' value='"+rs.getString("SUPPLIER_FLAG")+"'>");  //add by Peggy 20220428 FOR CONTI/VITESCO
					ShipToOrg ="";     //add by Peggy 20120303
					shipAddress = "";  //add by Peggy 20120303
					shipCountry = "";  //add by Peggy 20120303
					payTermID = "";    //add by Peggy 20120303
					paymentTerm = "";  //add by Peggy 20120303
					fobPoint = "";     //add by Peggy 20120303
					firmPriceList = "";//add by Peggy 20120303
					billTo = "";       //add by Peggy 20120303
					billAddress = "";  //add by Peggy 20120303
					billCountry = "";  //add by Peggy 20120303	
					ship_via = "";     //add by Peggy 20120321	
					curr = "";         //add by Peggy 20120326	
					taxCode ="";       //add by Peggy 20130411
					deliveryTo = "";deliveryAddress = ""; deliveryCountry = "";	shipToContact ="";shipToContactid="";//add by Peggy 20130218
					Statement statementa=con.createStatement();
					String sqla = //" select case when upper(a.site_use_code)='BILL_TO' then 1 else 2 end as segno,"+ //add by Peggy 20120914
					              " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
					              " a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, loc.COUNTRY, loc.ADDRESS1,"+       
								  " a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME || '('||c.DESCRIPTION ||')' PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION,nvl(d.CURRENCY_CODE,'') CURRENCY_CODE"+ 
								  " ,a.tax_code" + //add by Peggy 20130411
								  " ,a.attribute1"+ //add by Peggy 20210528
								  " from ar_site_uses_v a,HZ_CUST_ACCT_SITES b, hz_party_sites party_site, hz_locations loc, RA_TERMS_VL c"+
				                  " ,SO_PRICE_LISTS d"+
								  " where  a.ADDRESS_ID = b.cust_acct_site_id"+
								  " AND b.party_site_id = party_site.party_site_id"+
								  " AND loc.location_id = party_site.location_id "+
								  " and a.STATUS='A' "+
								  " and b.status='A'"+ //add b Peggy 20231128
								  " and a.PRIMARY_FLAG='Y'"+
								  " and b.CUST_ACCOUNT_ID ='"+customerID+"'"+
								  " and a.PAYMENT_TERM_ID = c.TERM_ID(+)"+
				                  " and a.PRICE_LIST_ID = d.PRICE_LIST_ID(+)";
					if (salesAreaNo.equals("009") || salesAreaNo.equals("008") || salesAreaNo.equals("018"))  //add by Peggy 20160321,for cust price issue //add TSCA 依ship to的price list by Peggy 20221219
					{
						sqla +=" order by case when upper(a.site_use_code)='SHIP_TO' then 1 when upper(a.site_use_code)='BILL_TO' then 2 else 3 end "; 
					}
					else
					{
						sqla +=" order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end "; 
					}
					ResultSet rsa=statementa.executeQuery(sqla);
					//out.println("sqla="+sqla);
					int rec_cnt =0;
					while (rsa.next())
					{
						if (rsa.getString("SITE_USE_CODE").equals("SHIP_TO"))
						{
							ShipToOrg =rsa.getString("SITE_USE_ID");
							shipAddress = rsa.getString("ADDRESS1");
							shipCountry = rsa.getString("COUNTRY");
							if (!salesAreaNo.equals("001"))
							{
								if (payTermID==null || payTermID.equals(""))
								{
									payTermID = rsa.getString("PAYMENT_TERM_ID");
									paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
								}
								//if (fobPoint == null || fobPoint.equals("") || salesAreaNo.equals("001"))  //歐洲區依ship_to的fob為預設值,modify by Peggy 20121026
								if (fobPoint == null || fobPoint.equals("")) //modify by Peggy 20230825
								{
									fobPoint = rsa.getString("FOB_POINT");
								}
								if (firmPriceList == null || firmPriceList.equals(""))
								{
									firmPriceList = rsa.getString("PRICE_LIST_ID");
								}
								if (curr ==null || curr.equals(""))
								{
									curr = rsa.getString("CURRENCY_CODE");
								}	
							}	
							if (ship_via==null || ship_via.equals(""))
							{
								ship_via = rsa.getString("ship_via");
							}										
						}
						else if (rsa.getString("SITE_USE_CODE").equals("BILL_TO"))
						{
							billTo = rsa.getString("SITE_USE_ID");
							billAddress = rsa.getString("ADDRESS1");
							billCountry = rsa.getString("COUNTRY");
							sales_group_id =rsa.getString("ATTRIBUTE1"); //add by Peggy 20210528
							if (salesAreaNo.equals("001"))
							{	
								if (payTermID == null || payTermID.equals(""))
								{
									payTermID = rsa.getString("PAYMENT_TERM_ID");
									paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
								}	
								if (firmPriceList == null || firmPriceList.equals(""))
								{
									firmPriceList = rsa.getString("PRICE_LIST_ID");
								}	
								if (curr ==null || curr.equals(""))
								{
									curr = rsa.getString("CURRENCY_CODE");
								}																					
							}
							else
							{						
								if (payTermID == null || payTermID.equals(""))
								{
									payTermID = rsa.getString("PAYMENT_TERM_ID");
									paymentTerm = rsa.getString("PAYMENT_TERM_NAME");
								}						
								if (fobPoint==null || fobPoint.equals(""))
								{
									fobPoint = rsa.getString("FOB_POINT");
								}
								if (firmPriceList == null || firmPriceList.equals(""))
								{
									firmPriceList = rsa.getString("PRICE_LIST_ID");
								}	
								if (ship_via==null || ship_via.equals(""))
								{
									ship_via = rsa.getString("ship_via");
								}							
								if (curr ==null || curr.equals(""))
								{
									curr = rsa.getString("CURRENCY_CODE");
								}	
							}				
						}
						else if (rsa.getString("SITE_USE_CODE").equals("DELIVER_TO"))  //add by Peggy 20121026
						{
							deliveryTo = rsa.getString("SITE_USE_ID");    //add by Peggy 20130218
							deliveryAddress = rsa.getString("ADDRESS1");  //add by Peggy 20130218
							deliveryCountry = rsa.getString("COUNTRY");   //add by Peggy 20130218
							if (salesAreaNo.equals("001"))
							{	
								fobPoint = rsa.getString("FOB_POINT");	
								taxCode = rsa.getString("TAX_CODE"); 
							}
							else
							{					
								if (fobPoint==null || fobPoint.equals(""))  //modify by Peggy 20220808 歐洲區1156/1142/1141按deliver to 的fob
								{
									fobPoint = rsa.getString("FOB_POINT");
								}
								taxCode = rsa.getString("TAX_CODE");          //add by Peggy 20130411
								if (taxCode ==null) taxCode="";
							}
						}	
						rec_cnt ++;
					}
					rsa.close();
					statementa.close();
					
					if (rec_cnt ==0)  //add by Peggy 20120517
					{
						sqla = //"SELECT case when upper(a.site_use_code)='BILL_TO' then 1 else 2 end as segno,"+ //add by Peggy 20120914
						       " select case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end as segno,"+ //fob 先依ship_to為主,若無,再依deliver_to為主,modify by Peggy 20121026
						       "a.site_use_code, a.primary_flag, a.site_use_id, loc.country,"+
                               "loc.address1, a.payment_term_id, a.payment_term_name, a.ship_via,"+
                               "a.fob_point, a.price_list_id, c.description"+
  							   ",a.tax_code" + //add by Peggy 20130411
							   " ,a.attribute1"+ //add by Peggy 20210528
                               " FROM ar_site_uses_v a, hz_cust_acct_sites b, hz_party_sites party_site,"+
                               " hz_locations loc, ra_terms_vl c"+
                               " WHERE     a.address_id = b.cust_acct_site_id"+
                               " AND b.party_site_id = party_site.party_site_id"+
                               " AND loc.location_id = party_site.location_id"+
                               " AND a.status = 'A'"+
							   " AND b.status = 'A'"+ //add by Peggy 20231128
                               " AND a.primary_flag = 'Y'"+
                               " AND b.cust_account_id = '"+customerID+"'"+
       						   " AND a.payment_term_id = c.term_id(+)"+
							   " order by case when upper(a.site_use_code)='BILL_TO' then 1 when upper(a.site_use_code)='SHIP_TO' then 2 else 3 end";  //add by Peggy 20120914
						//out.println("sqla="+sqla);
						Statement statementx=con.createStatement();
						ResultSet rsx=statementx.executeQuery(sqla);
						while (rsx.next())
						{
							if (rsx.getString("SITE_USE_CODE").equals("SHIP_TO"))
							{
								ShipToOrg =rsx.getString("SITE_USE_ID");
								shipAddress = rsx.getString("ADDRESS1");
								shipCountry = rsx.getString("COUNTRY");
								if (payTermID==null || payTermID.equals(""))
								{
									payTermID = rsx.getString("PAYMENT_TERM_ID");
									paymentTerm = rsx.getString("PAYMENT_TERM_NAME");
								}
								//if (fobPoint == null || fobPoint.equals("") || salesAreaNo.equals("001"))  //歐洲區依ship_to的fob為預設值,modify by Peggy 20121026
								if (fobPoint == null || fobPoint.equals("")) //add by Peggy 20230825
								{
									fobPoint = rsx.getString("FOB_POINT");
								}
								if (firmPriceList == null || firmPriceList.equals(""))
								{
									firmPriceList = rsx.getString("PRICE_LIST_ID");
								}
								if (ship_via==null || ship_via.equals(""))
								{
									ship_via = rsx.getString("ship_via");
								}		
								if (curr ==null || curr.equals(""))
								{
									curr = rsx.getString("CURRENCY_CODE");
								}					
							}
							else if (rsx.getString("SITE_USE_CODE").equals("BILL_TO"))
							{
								billTo = rsx.getString("SITE_USE_ID");
								billAddress = rsx.getString("ADDRESS1");
								billCountry = rsx.getString("COUNTRY");
								sales_group_id =rsx.getString("ATTRIBUTE1"); //add by Peggy 20210528
								if (payTermID == null || payTermID.equals(""))
								{
									payTermID = rsx.getString("PAYMENT_TERM_ID");
									paymentTerm = rsx.getString("PAYMENT_TERM_NAME");
								}						
								if (fobPoint==null || fobPoint.equals(""))
								{
									fobPoint = rsx.getString("FOB_POINT");
								}
								if (firmPriceList == null || firmPriceList.equals(""))
								{
									firmPriceList = rsx.getString("PRICE_LIST_ID");
								}	
								if (ship_via==null || ship_via.equals(""))
								{
									ship_via = rsx.getString("ship_via");
								}							
								if (curr ==null || curr.equals(""))
								{
									curr = rsx.getString("CURRENCY_CODE");
								}					
							}
							else if (rsx.getString("SITE_USE_CODE").equals("DELIVER_TO"))  //add by Peggy 20121026
							{
								deliveryTo = rsa.getString("SITE_USE_ID");    //add by Peggy 20130218
								deliveryAddress = rsa.getString("ADDRESS1");  //add by Peggy 20130218
								deliveryCountry = rsa.getString("COUNTRY");   //add by Peggy 20130218
								if (fobPoint==null || fobPoint.equals("") || (salesAreaNo.equals("001") && (ODRTYPE.equals("1022") || ODRTYPE.equals("1175") || ODRTYPE.equals("1322"))))  //modify by Peggy 20220808 歐洲區1156/1142/1141按deliver to 的fob
								{
									fobPoint = rsx.getString("FOB_POINT");
								}
								taxCode = rsa.getString("TAX_CODE");          //add by Peggy 20130411
								if (taxCode ==null) taxCode="";
							}	
						}
						rsx.close();
						statementx.close();
					}
					
					//add by Peggy 20130222
					//add by Peggy 20130222
					if (salesAreaNo.equals("001") || salesAreaNo.equals("002"))
					{
						Statement statementx=con.createStatement();
						String sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
									  " from ar_contacts_v con,hz_cust_site_uses_all su"+
									  " where  con.customer_id ='"+customerID+"'"+
									  " and con.status='A'"+
									  " AND con.address_id=su.cust_acct_site_id"+
									  " AND su.site_use_code='SHIP_TO'"+
									  //" AND su.site_use_code=decode('"+salesAreaNo+"','001','DELIVER_TO','SHIP_TO')"+
									  " AND su.SITE_USE_ID='"+ShipToOrg+"'";
									  //" AND su.SITE_USE_ID=decode('"+salesAreaNo+"','001','"+deliveryTo+"','"+ShipToOrg+"')";
						ResultSet rsx=statementx.executeQuery(sqlx);	  			  				     
						if (rsx.next())
						{
							shipToContact = rsx.getString("contact_name");
							shipToContactid = rsx.getString("contact_id");
						}  
						else
						{
							Statement statementy=con.createStatement();
							sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
									  " from ar_contacts_v con,hz_cust_site_uses su "+
									  " where  con.customer_id ='"+customerID+"'"+
									  " and con.status='A'"+
									  " AND con.address_id=su.cust_acct_site_id"+
									  " AND su.site_use_code='SHIP_TO'"+
									  //" AND su.site_use_code=decode('"+salesAreaNo+"','001','DELIVER_TO','SHIP_TO')"+
									  " ORDER BY DECODE(LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE),'"+customerID+"',1,2)";		
							ResultSet rsy=statementy.executeQuery(sqlx);	  			  				     
							if (rsy.next())
							{
								shipToContact = rsy.getString("contact_name");
								shipToContactid= rsy.getString("contact_id");			
							}
							rsy.close();
							statementy.close();
						}
						rsx.close();
						statementx.close();     
					}  
					
					out.println("<input type='hidden' name='SHIPTO' value='"+ShipToOrg+"' >");
					out.println("<input type='hidden' name='SHIPTOADDRESS' value='"+shipAddress.replace("\'","")+"'>");
					out.println("<input type='hidden' name='SHIPTOCOUNTRY' value='"+shipCountry+"'>");
					out.println("<input type='hidden' name='BILLTO' value='"+billTo+"' >");
					out.println("<input type='hidden' name='BILLTOADDRESS' value='"+billAddress.replace("\'","")+"'>");
					out.println("<input type='hidden' name='BILLTOCOUNTRY' value='"+billCountry+"'>");
					out.println("<input type='hidden' name='PAYTERMID' value='"+payTermID+"'>");
					out.println("<input type='hidden' name='PAYMENTTERM' value='"+paymentTerm+"'>");
					out.println("<input type='hidden' name='FOB' value='"+fobPoint+"' >");
					out.println("<input type='hidden' name='PRICELIST' value='"+firmPriceList+"'>");
					out.println("<input type='hidden' name='SHIPVIA' value='"+ship_via+"'>");
					out.println("<input type='hidden' name='CURRENCY' value='"+curr+"'>");
					out.println("<INPUT TYPE='hidden' NAME='SAREANO' SIZE=10 value='"+salesAreaNo+"'>");
					out.println("<input type='hidden' name='DELIVERYTO' value='"+deliveryTo+"' >");           //add by Peggy 20130218
					out.println("<input type='hidden' name='DELIVERYADDRESS' value='"+deliveryAddress.replace("\'","")+"'>"); //add by Peggy 20130218
					out.println("<input type='hidden' name='DELIVERYCOUNTRY' value='"+deliveryCountry+"'>"); //add by Peggy 20130218
					out.println("<input type='hidden' name='SHIPTOCONTACTID' value='"+shipToContactid+"'>"); //add by Peggy 20130218
					out.println("<input type='hidden' name='SHIPTOCONTACT' value='"+shipToContact+"'>");     //add by Peggy 20130218
					out.println("<input type='hidden' name='TAXCODE' value='"+taxCode+"'>");                 //add by Peggy 20130411
					out.println("<input type='hidden' name='SALES_GROUP_ID' value='"+sales_group_id+"'>");   //add by Peggy 20210528

					if (customerNo==null) 
					{ 
						trBgColor = "E3E3CF"; 
					}
					else if (customerNo==rs.getString("CUSTOMER_NUMBER") || customerNo.equals(rs.getString("CUSTOMER_NUMBER")))				 	 
					{ 
						trBgColor = "FFCC66"; 
					}
					else 
					{ 
						trBgColor = "E3E3CF"; 
					}
					//buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+custNo+'"'+","+'"'+custName+'"'+","+'"'+custActive+'"'+","+'"'+custAROverdue+'"'+")";		
					//modify by Peggy 20111004
					buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+custNo+'"'+","+'"'+custName+'"'+","+'"'+custActive+'"'+","+'"'+custAROverdue+'"'+","+'"'+FuncName+'"'+","+'"'+custMarketGroup+'"'+","+ '"'+ShipToOrg+'"'+","+ '"'+shipAddress.replace("\"","").replace("\'","")+'"'+","+ '"'+shipCountry+'"'+","+ '"'+billTo+'"'+","+ '"'+billAddress.replace("\'","")+'"'+","+ '"'+billCountry+'"'+","+ '"'+payTermID+'"'+","+ '"'+paymentTerm+'"'+","+ '"'+fobPoint+'"'+","+ '"'+firmPriceList+'"'+","+'"'+ship_via+'"'+","+'"'+curr+'"'+","+ '"'+ salesAreaNo+'"'+","+'"'+custFlag+'"'+","+ '"'+deliveryTo+'"'+","+ '"'+deliveryAddress.replace("\'","")+'"'+","+ '"'+deliveryCountry+'"'+","+'"'+shipToContactid+'"'+","+'"'+shipToContact+'"'+","+'"'+taxCode+'"'+","+'"'+sales_group_id+'"'+","+'"'+rs.getString("SUPPLIER_FLAG")+'"'+")";		
					//out.println("buttonContent="+buttonContent);
					out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
					out.println("' onClick='"+buttonContent+"'></TD>");		
					//for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
					for (int i=2;i<=colCount-2;i++) // modify by Peggy 20111011,status,market group不顯示
					{
						String s=(String)rs.getString(i);
						out.println("<TD><FONT SIZE=2>"+s+"</TD>");
					} //end of for
					out.println("</TR>");
					rowcnt++;	
				} //end of while
				if (rowcnt >0)
				{
					out.println("</TABLE>");
				}						
				else
				{
					out.println("<font color='red'>No Data found!</font>");
				} 
				rs.close(); 
			}   
			else
			{
				out.println("<font color='red'>No Data found!</font>");
			}  
	   	}//end of while
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     %>
		    <script LANGUAGE="JavaScript">		
				if (document.CUSTFORM.FuncName.value=="D9001")
				{
					window.opener.document.MYFORM.CUSTOMERID.value = document.CUSTFORM.CUSTID.value;
					window.opener.document.MYFORM.CUSTOMERNO.value = document.CUSTFORM.CUSTNO.value; 
					window.opener.document.MYFORM.CUSTOMERNAME.value = document.CUSTFORM.CUSTNAME.value;   
				}
				else
				{
					//window.opener.document.location.reload();
					window.opener.document.MYFORM.CUSTACTIVE.value = document.CUSTFORM.CUSTACTIVE.value;	   
					window.opener.document.MYFORM.CUSTOMERID.value = document.CUSTFORM.CUSTID.value;
					window.opener.document.MYFORM.CUSTOMERNO.value = document.CUSTFORM.CUSTNO.value; 
					window.opener.document.MYFORM.CUSTOMERNAME.value = document.CUSTFORM.CUSTNAME.value;   
					window.opener.document.MYFORM.CUSTOMERAROVERDUE.value = document.CUSTFORM.CUSTAROVERDUE.value;
					if (document.CUSTFORM.FuncName.value=="D1001")
					{
						if (document.CUSTFORM.FOB.value =="null" || document.CUSTFORM.FOB.value==null) document.CUSTFORM.FOB.value="";   //add by Peggy 20120522
						if (document.CUSTFORM.PAYMENTTERM.value=="null" || document.CUSTFORM.PAYMENTTERM.value ==null) document.CUSTFORM.PAYMENTTERM.value=""; //add by Peggy 20120522
						window.opener.document.MYFORM.SHIPTOORG.value = document.CUSTFORM.SHIPTO.value;
						window.opener.document.MYFORM.SHIPADDRESS.value = document.CUSTFORM.SHIPTOADDRESS.value;
						window.opener.document.MYFORM.SHIPCOUNTRY.value = document.CUSTFORM.SHIPTOCOUNTRY.value;
						window.opener.document.MYFORM.PAYTERM.value = document.CUSTFORM.PAYMENTTERM.value;
						window.opener.document.MYFORM.PAYTERMID.value = document.CUSTFORM.PAYTERMID.value;
						window.opener.document.MYFORM.BILLTO.value = document.CUSTFORM.BILLTO.value;
						window.opener.document.MYFORM.BILLADDRESS.value= document.CUSTFORM.BILLTOADDRESS.value;
						window.opener.document.MYFORM.BILLCOUNTRY.value=document.CUSTFORM.BILLTOCOUNTRY.value;
						window.opener.document.MYFORM.FOBPOINT.value=document.CUSTFORM.FOB.value;
						window.opener.document.MYFORM.SALES_GROUP_ID.value = document.CUSTFORM.SALES_GROUP_ID.value;   //add by Peggy 20210528 
						window.opener.document.MYFORM.SUPPLIER_FLAG.value = document.CUSTFORM.SUPPLIER_FLAG.value;   //add by Peggy 20220428
						if (window.opener.document.MYFORM.SALES_GROUP_ID.value=="509")
						{
							window.opener.document.MYFORM.PREORDERTYPE.value="1763"; //1132訂單 add by Peggy 20210528
						}
						//modify by Peggy 20130424
						if (window.opener.document.MYFORM.SALESAREANO.value=="001" && document.CUSTFORM.CUSTNO.value =="1202" && window.opener.document.MYFORM.PREORDERTYPE.value=="1342")
						{
							if (window.opener.document.MYFORM.CURR.value=="USD")
							{
								window.opener.document.MYFORM.FIRMPRICELIST.value="6038";
								window.opener.document.MYFORM.ORIGPRICELIST.value="6038"; //add by Peggy 20130909
							}
							else if (window.opener.document.MYFORM.CURR.value=="EUR")
							{
								window.opener.document.MYFORM.FIRMPRICELIST.value="7331";
								window.opener.document.MYFORM.ORIGPRICELIST.value="7331"; //add by Peggy 20130909
							}
						}
						else
						{
							window.opener.document.MYFORM.FIRMPRICELIST.value=document.CUSTFORM.PRICELIST.value; 
							window.opener.document.MYFORM.ORIGPRICELIST.value=document.CUSTFORM.PRICELIST.value;  //add by Peggy 20130909
						}
						window.opener.document.MYFORM.SHIPVIA.value=document.CUSTFORM.SHIPVIA.value; 
						window.opener.document.MYFORM.LINEFOB.value=document.CUSTFORM.FOB.value; //add by Peggy 20120423
						window.opener.document.MYFORM.DELIVERYTO.value = document.CUSTFORM.DELIVERYTO.value;              //add by Peggy 20130218
						window.opener.document.MYFORM.DELIVERYADDRESS.value = document.CUSTFORM.DELIVERYADDRESS.value;    //add by Peggy 20130218
						window.opener.document.MYFORM.DELIVERYCOUNTRY.value = document.CUSTFORM.DELIVERYCOUNTRY.value;    //add by Peggy 20130218
						window.opener.document.MYFORM.SHIPTOCONTACTID.value= document.CUSTFORM.SHIPTOCONTACTID.value;     //add by Peggy 20130218
						window.opener.document.MYFORM.SHIPTOCONTACT.value=document.CUSTFORM.SHIPTOCONTACT.value;          //add by Peggy 20130218
						//add by Peggy 20130411
						if (window.opener.document.MYFORM.SALESAREANO.value =="001")
						{  
							window.opener.document.MYFORM.TAXCODE.value=document.CUSTFORM.TAXCODE.value;                      
						}
						if (document.CUSTFORM.SAREANO.value !="020" && document.CUSTFORM.SHIPVIA.value != null && document.CUSTFORM.SHIPVIA.value != "null") //add by Peggy 20120417
						{
							window.opener.document.MYFORM.SHIPPINGMETHOD.value=document.CUSTFORM.SHIPVIA.value; 
						}
						//add by Peggy 20130411
						if (window.opener.document.MYFORM.SALESAREANO.value !="001" || window.opener.document.MYFORM.PREORDERTYPE.value != "1342")
						{
							if	(document.CUSTFORM.CURRENCY.value== null || document.CUSTFORM.CURRENCY.value=="" || document.CUSTFORM.CURRENCY.value=="null") 
							{
								window.opener.document.MYFORM.CURR.value=""; 
								window.opener.document.MYFORM.ORIGCURR.value="";
							}
							else
							{
								window.opener.document.MYFORM.CURR.value=document.CUSTFORM.CURRENCY.value; 
								window.opener.document.MYFORM.ORIGCURR.value=document.CUSTFORM.CURRENCY.value; 
							}
						}
						if (window.opener.document.MYFORM.CUSTMARKETGROUP.value=="AU" && document.CUSTFORM.CUSTMARKETGROUP.value != "AU")
						{
							window.opener.document.MYFORM.PLANTCODE.value="";
						}
										
						window.opener.document.MYFORM.CUSTMARKETGROUP.value=document.CUSTFORM.CUSTMARKETGROUP.value;
						if (window.opener.document.MYFORM.CUSTMARKETGROUP.value=="AU" || window.opener.document.MYFORM.showCRD.value=="Y")
						{
							window.opener.document.MYFORM.btplant.disabled=false;
						}
						else
						{
							window.opener.document.MYFORM.btplant.disabled=true;
						}
						if (document.CUSTFORM.CUSTAROVERDUE.value=="Y")
						{
						   window.opener.document.MYFORM.AROVERDUEDESC.value="Customer AR overdue 90 days!! ";
						} 
						else
						{
						   window.opener.document.MYFORM.AROVERDUEDESC.value=" ";
						} 
						if (document.CUSTFORM.FLAG.value=="Y")
						{
							window.opener.document.MYFORM.submit();
						}
						else if (window.opener.document.MYFORM.ENDCUSTPOLINENO!=undefined)
						{
							window.opener.document.MYFORM.submit();
						}
						else
						{
							window.opener.document.MYFORM.submit();
						}
					}
				}
				this.window.close(); 
            </script>
		 <%
	    }
	   
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception1:"+e.getMessage());
    }
	statement.close();
     %>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="CUSTOMERNO" SIZE=10 value="<%=customerNo%>" >
<INPUT TYPE="hidden" NAME="NAME" SIZE=30 value="<%=name%>" >
<INPUT TYPE="hidden" NAME="SEARCHSTRING" SIZE=30 value="<%=searchString%>">
<INPUT TYPE="hidden" NAME="ORGID" SIZE=5 value="<%=orgID%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
