<!-- 20150618 Peggy,TSCE SHIP TO CONTACT依SHIP_TO為主-->
<!-- 20180720 Peggy,for TSCA CUSTOMER DIGIKEY ISSUE-->
<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String customerID=request.getParameter("CUSTOMERID");
String siteUseCode=request.getParameter("SITEUSECODE");
String shipToOrg=request.getParameter("SHIPTOORG");
String billTo=request.getParameter("BILLTO");
String searchString=request.getParameter("SEARCHSTRING");
String salesAreaNo=request.getParameter("SALESAREANO");
String FuncName=request.getParameter("FUNC");  //add by Peggy 20120215
if (FuncName==null) FuncName="D1007";          //add by Peggy 20120215
String setEnter = "N";
String Address=request.getParameter("ADDRESS");
if (Address==null) Address ="";   //add by Peggy 20121029
String EDICODE=request.getParameter("EDICODE");
if (EDICODE==null) EDICODE="";    //add by Peggy 20130606

try
{
	if (searchString==null)
   	{ 
		if (FuncName.equals("D1001") || FuncName.equals("D1007"))
		{ 
			if (Address!=null && !Address.equals(""))
			{
				searchString=Address; 
			}
			else if (shipToOrg!=null && !shipToOrg.equals(""))
			{
				searchString=shipToOrg; 
			}
			else if (billTo!=null && !billTo.equals(""))
			{
				searchString=billTo; 
			}
			else
			{
				searchString="%";
			}
		}
		else 
		{ 
			searchString="%"; 
		}
	}
    String orgID = "";
	Statement stateOrg=con.createStatement();			  
    ResultSet rsOrg=stateOrg.executeQuery("select PAR_ORG_ID from ORADDMAN.TSSALES_AREA where SALES_AREA_NO = '"+salesAreaNo+"' ");
	if (rsOrg.next()) orgID = rsOrg.getString("PAR_ORG_ID");
	rsOrg.close();
	stateOrg.close();
	
	//CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	cs1.setString(1,orgID);
	cs1.execute();
    //out.println("Procedure : Execute Success !!! ");
    cs1.close();
} 
catch (Exception e)
{
	out.println("Exception1:"+e.getMessage());
}   
%>
<html>
<head>
<title>Page for choose Customer ShipTo or BillTo Address List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(siteUseCode,sitUseID,country,address1,setEnter,fob,taxCode,pricelist,paymentid,paymentname,shipToContact,shipToContactid,salesGroupId,paymentdesc)
{
	if (siteUseCode=="SHIP_TO")   
 	{ 
  		//alert(window.opener.document.referrer);
  		if (document.SITEFORM.FUNC.value =="D1001")
  		{
  			window.opener.document.MYFORM.SHIPTOORG.value=sitUseID; 
  			window.opener.document.MYFORM.SHIPCOUNTRY.value=country;
  			window.opener.document.MYFORM.SHIPADDRESS.value=address1;
			if (window.opener.document.MYFORM.SALESAREANO.value =="001")
			{  
				if (window.opener.document.MYFORM.PREORDERTYPE.value!="1156" && window.opener.document.MYFORM.PREORDERTYPE.value!="1142" && window.opener.document.MYFORM.PREORDERTYPE.value!="1141") //add by Peggy 20220808
				{			
		  			window.opener.document.MYFORM.FOBPOINT.value=fob; //add by Peggy 20121026
					window.opener.document.MYFORM.LINEFOB.value=fob; //add by Peggy 20121026
				}
			}
			else
			{
				window.opener.document.MYFORM.FOBPOINT.value=fob; //add by Peggy 20121026
				window.opener.document.MYFORM.LINEFOB.value=fob; //add by Peggy 20121026
			}
			//if (window.opener.document.MYFORM.SALESAREANO.value !="001")  //modify by Peggy 20150618,TSCE依SHIP_TO的SHIP TO CONTACT
			//{
				window.opener.document.MYFORM.SHIPTOCONTACTID.value= shipToContactid;  //add by Peggy 20131220
				window.opener.document.MYFORM.SHIPTOCONTACT.value=shipToContact;       //add by Peggy 20131220
			//}
			if (siteUseCode=="BILLTO") //add by Peggy 20210528 
			{
				window.opener.document.MYFORM.SALES_GROUP_ID.value = salesGroupId;   
				if (window.opener.document.MYFORM.SALES_GROUP_ID.value=="509")
				{
					window.opener.document.MYFORM.PREORDERTYPE.value="1763"; //1132訂單 add by Peggy 20210528
				}	
			}
						
			if (window.opener.document.MYFORM.SALESAREANO.value == "008")  //TSCA issue,add by Peggy 20180719
			{
				if (window.opener.document.MYFORM.SHIPTOORG.value=="55839")
				{
					var iLen=0;
					if (window.opener.document.MYFORM.ADDITEMS.length != undefined)	
					{
						iLen = window.opener.document.MYFORM.ADDITEMS.length;
					}
					else
					{
						iLen = 1;
					}
					for (var i=1; i<= iLen ; i++)
					{	
						if (window.opener.document.MYFORM.elements["MONTH"+(i-1)+"-16"].value=="1141")
						{	
							window.opener.document.MYFORM.elements["MONTH"+(i-1)+"-6"].value="FEDEX ECNOMY";	
							window.opener.document.MYFORM.elements["MONTH"+(i-1)+"-18"].value="FCA";	
						}
					}
				}
			}				
		}
		else if (document.SITEFORM.FUNC.value =="D9002" || document.SITEFORM.FUNC.value =="D11001") //add by Peggy 20140103
		{
  			window.opener.document.MYFORM.SHIPTOID.value=sitUseID; 
  			window.opener.document.MYFORM.SHIPTO.value="("+sitUseID+")"+address1;
		}
		else if (document.SITEFORM.FUNC.value =="D9001") //add by Peggy 20130613
		{
  			window.opener.document.MYFORM.SHIPTOID.value=sitUseID; 
  			window.opener.document.MYFORM.SHIPTO.value=address1;
		}
		else
		{
  			window.opener.document.DISPLAYREPAIR.SHIPTOORG.value=sitUseID; 
  			window.opener.document.DISPLAYREPAIR.SHIPCOUNTRY.value=country;
  			window.opener.document.DISPLAYREPAIR.SHIPADDRESS.value=address1;	
			if (document.SITEFORM.FUNC.value =="D4002") //add by Peggy 20220525
			{
				window.opener.document.DISPLAYREPAIR.FOBPOINT.value=fob;
				window.opener.document.DISPLAYREPAIR.PAYTERMID.value=paymentid;
				window.opener.document.DISPLAYREPAIR.PAYTERM.value=paymentname+"("+paymentdesc+")";
				for (var i = 1 ; i <= window.opener.document.DISPLAYREPAIR.lineCnt.value ;i++)
				{
					window.opener.document.DISPLAYREPAIR.elements["FOB"+i].value = fob;
				}				
			}
		}
 	} 
	else if (siteUseCode=="BILL_TO") 
    {
  		if (document.SITEFORM.FUNC.value =="D1001")
  		{	
            window.opener.document.MYFORM.BILLTO.value=sitUseID; 
            window.opener.document.MYFORM.BILLCOUNTRY.value=country;
            window.opener.document.MYFORM.BILLADDRESS.value=address1;		
		}
		else if (document.SITEFORM.FUNC.value =="D9002" || document.SITEFORM.FUNC.value =="D11001") //add by Peggy 20140103
		{
            window.opener.document.MYFORM.BILLTOID.value=sitUseID; 
            window.opener.document.MYFORM.BILLTO.value="("+sitUseID+")"+address1;
  			window.opener.document.MYFORM.FOB.value=fob; 
			window.opener.document.MYFORM.PAYTERMID.value=paymentid;
			window.opener.document.MYFORM.PAYMENTTERM.value=paymentname;
			window.opener.document.MYFORM.PRICELIST.value=pricelist;
			for (var i = 1 ; i <= window.opener.document.MYFORM.MAXLINE.value ;i++)
			{
				window.opener.document.MYFORM.elements["LINE_FOB_"+i].value = fob;
			}
		}
		else
		{
            window.opener.document.DISPLAYREPAIR.BILLTO.value=sitUseID; 
            window.opener.document.DISPLAYREPAIR.BILLCOUNTRY.value=country;
            window.opener.document.DISPLAYREPAIR.BILLADDRESS.value=address1; 
		}   
    }
	else if (siteUseCode=="DELIVER_TO") 
    {
  		if (document.SITEFORM.FUNC.value =="D1001")
  		{	
            window.opener.document.MYFORM.DELIVERYTO.value=sitUseID; 
            window.opener.document.MYFORM.DELIVERYCOUNTRY.value=country;
            window.opener.document.MYFORM.DELIVERYADDRESS.value=address1;	
			//add by Peggy 20130411 
			if (window.opener.document.MYFORM.SALESAREANO.value =="001")
			{  
				window.opener.document.MYFORM.TAXCODE.value=taxCode; 
				//window.opener.document.MYFORM.SHIPTOCONTACTID.value= shipToContactid;  //add by Peggy 20131220
				//window.opener.document.MYFORM.SHIPTOCONTACT.value=shipToContact;       //add by Peggy 20131220
				if (window.opener.document.MYFORM.PREORDERTYPE.value=="1022" || window.opener.document.MYFORM.PREORDERTYPE.value=="1175" || window.opener.document.MYFORM.PREORDERTYPE.value=="1322") //add by Peggy 20220808
				{
		  			window.opener.document.MYFORM.FOBPOINT.value=fob;
					window.opener.document.MYFORM.LINEFOB.value=fob; 
				}
			}
		}  
		else if ( document.SITEFORM.FUNC.value =="D9002" || document.SITEFORM.FUNC.value =="D11001") //add by Peggy 20140103
		{
            window.opener.document.MYFORM.DELIVERYTOID.value=sitUseID; 
            window.opener.document.MYFORM.DELIVERYTO.value="("+sitUseID+")"+address1;	
			if (window.opener.document.MYFORM.SALESAREANO.value =="001" && document.SITEFORM.FUNC.value !="D11001")
			{  
				window.opener.document.MYFORM.TAXCODE.value=taxCode; 
			}
		}
    }
 	this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQSiteUseInfoFind.jsp" NAME=SITEFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgShipToOrg"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgBillTo"/><jsp:getProperty name="rPH" property="pgCode"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgConReg"/>/<jsp:getProperty name="rPH" property="pgAddr"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
<%  
	int queryCount = 0;
    Statement statement=con.createStatement();
	String primaryFlag=null,siteUseID=null,country=null,address1=null,address2=null,address3=null,address4=null;
	String customerName=null,customerNum=null,fob="";//fob,add by Peggy 20121026
	String taxCode="",pricelist="",paymentid="",paymentname="",paymentdesc="";  //add by Peggy 20130606
	String shipToContact ="",shipToContactid="",salesGroupId="";    //add by Peggy 20131220
	
	try
    { 
		if (searchString!="" && searchString!=null) 
	   	{  
			//sql改寫,參考來源為ERP OM的ship to location的SQL
			String sql = " select * from (SELECT  site.primary_flag,cust_acct.account_number \"CUSTOMER#\",party.party_name customer_name,site.site_use_id,loc.country,"+
				  " loc.address1 , loc.address2 , loc.address3 ,DECODE (loc.city, NULL, NULL, loc.city || ', ') || DECODE (loc.state, NULL,loc.province || ', ',loc.state || ', ') || DECODE (loc.postal_code, NULL, NULL, loc.postal_code || ', ') || DECODE (loc.country, NULL, NULL, loc.country) address4,"+
				  " cust_acct.party_id,site.fob_point "+
				  ",site.tax_code"+ //add by Peggy 20130411
				  ",acct_site.ECE_TP_LOCATION_CODE"+ //add by Peggy 20130606
				  ",site.price_list_id"+        //add by Peggy 20130606
                  ",site.payment_term_id"+      //add by Peggy 20130606
				  ",term.name"+                 //add by Peggy 20130606
   			      ",site.attribute1"+           //add by Peggy 20210528
				  ",term.description"+          //add by Peggy 20220525
    			  " FROM hz_cust_acct_sites acct_site,"+
                  " hz_party_sites party_site,"+
                  " hz_locations loc,"+
                  " hz_cust_site_uses_all site,"+
                  " hz_parties party,"+
                  " hz_cust_accounts cust_acct,"+
                  " hr_all_organization_units_tl ou,"+
				  " ra_terms term"+
                  " WHERE site.site_use_code = '"+siteUseCode+"' "+
                  " AND site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                  " AND acct_site.party_site_id = party_site.party_site_id"+
                  " AND party_site.location_id = loc.location_id"+
                  " AND acct_site.status = 'A'"+
                  " AND acct_site.cust_account_id ="+customerID+""+
                  " AND acct_site.cust_account_id = cust_acct.cust_account_id"+
                  " AND cust_acct.party_id = party.party_id"+
                  " AND cust_acct.status = 'A'"+
                  " AND site.status = 'A'"+
                  " AND site.org_id = ou.organization_id"+
				  " AND site.payment_term_id=term.term_id(+)"+
                  " AND ou.language = 'US'";
			if (!salesAreaNo.equals("001"))
			{
				sql += " UNION"+
					   " SELECT site.primary_flag,cust_acct.account_number \"CUSTOMER#\",party.party_name customer_name,site.site_use_id,loc.country,"+
					   " loc.address1 , loc.address2 , loc.address3 ,DECODE (loc.city, NULL, NULL, loc.city || ', ') || DECODE (loc.state, NULL,loc.province || ', ',loc.state || ', ') || DECODE (loc.postal_code, NULL, NULL, loc.postal_code || ', ') || DECODE (loc.country, NULL, NULL, loc.country) address4,"+
   				       " cust_acct.party_id,site.fob_point "+
				       ",site.tax_code"+ //add by Peggy 20130411
					   ",acct_site.ECE_TP_LOCATION_CODE"+ //add by Peggy 20130606
				 	   ",site.price_list_id"+        //add by Peggy 20130606
					   ",site.payment_term_id"+      //add by Peggy 20130606
				       ",term.name"+                 //add by Peggy 20130606
					   ",site.attribute1"+           //add by Peggy 20210528
					   ",term.description"+          //add by Peggy 20220525
                       " FROM hz_cust_acct_sites acct_site,"+
                       " hz_party_sites party_site,"+
                       " hz_locations loc,"+
                       " hz_cust_site_uses_all site,"+
                       " hz_parties party,"+
                       " hz_cust_accounts cust_acct,"+
                       " hr_all_organization_units_tl ou,"+
                       " hz_cust_acct_relate acct_relate,"+
 		        	   " ra_terms term"+
                       " WHERE site.site_use_code = '"+siteUseCode+"' "+
                       " AND site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                       " AND acct_site.party_site_id = party_site.party_site_id"+
                       " AND party_site.location_id = loc.location_id"+
                       " AND acct_site.status = 'A'"+
                       " AND acct_site.cust_account_id = acct_relate.cust_account_id "+
                       " AND acct_relate.related_cust_account_id="+customerID+""+
                       " AND acct_relate.status = 'A'"+                                 
                       " AND acct_relate.ship_to_flag = 'Y'"+                           
                       " AND acct_site.cust_account_id = cust_acct.cust_account_id"+
                       " AND cust_acct.party_id = party.party_id"+
                       " AND cust_acct.status = 'A'"+
                       " AND site.status = 'A'"+
                       " AND site.org_id = ou.organization_id"+
				       " AND site.payment_term_id=term.term_id(+)"+
                       " AND ou.language = 'US'";
				}
			sql += " ORDER BY 4) a where 1=1 ";
			if (searchString != null && !searchString.equals(""))  //modify by Peggy 20121029
			{
				sql += " and (a.SITE_USE_ID like '"+searchString+"%' or a.ADDRESS1 like '"+searchString+"%')";	
			}
			if (FuncName.equals("D9002"))
			{
				sql += " and a.ECE_TP_LOCATION_CODE='"+EDICODE+"'";
			}
			sql += " order by 2";
		    //out.println(sql);		
        	ResultSet rs=statement.executeQuery(sql);
	    	ResultSetMetaData md=rs.getMetaData();
        	int colCount=md.getColumnCount();
        	String colLabel[]=new String[colCount];        
        	out.println("<TABLE>");      
        	out.println("<TR><TH BGCOLOR='BLACK'><FONT COLOR='WHITE' SIZE='1'>&nbsp;</TH>");   
        	for (int i=1;i<=colCount-4;i++) // 不顯示第一欄資料, 故 for 由 2開始
        	{
         		colLabel[i-1]=md.getColumnLabel(i);
         		out.println("<TH BGCOLOR='BLACK' nowrap><FONT COLOR='WHITE' SIZE='1'>"+colLabel[i-1]+"</TH>");
        	} //end of for 
        	out.println("</TR>");
     		
			primaryFlag=null;siteUseID=null;country=null;address1=null;address2=null;address3=null;address4=null;
			customerName=null;customerNum=null;fob="";taxCode="";pricelist="";paymentid="";paymentname="";paymentdesc="";
			
        	String buttonContent=null;
			String trBgColor = "";
        	while (rs.next())
        	{		
		 		primaryFlag=rs.getString("PRIMARY_FLAG");
		 		siteUseID=rs.getString("SITE_USE_ID");
		 		country=rs.getString("COUNTRY");
		 		address1=rs.getString("ADDRESS1");
				if (address1==null) address1="";
				address1=address1.replace("'","");
		 		address2=rs.getString("ADDRESS2");
				if (address2==null) address2="";
				address2=address2.replace("'","");
		 		address3=rs.getString("ADDRESS3");
				if (address3==null) address3="";
				address3=address3.replace("'","");
		 		address4=rs.getString("ADDRESS4");
				if (address4==null) address4="";
				address4=address4.replace("'","");
				fob=rs.getString("FOB_POINT"); //add by Peggy 20121026
		 		customerName=rs.getString("customer_name");
		  		customerNum=rs.getString("customer#");
				taxCode=rs.getString("Tax_code");           //add by Peggy 20130411
				pricelist=rs.getString("price_list_id");    //add by Peggy 20130606
				paymentid=rs.getString("payment_term_id");  //add by Peggy 20130606
				paymentname=rs.getString("name");           //add by Peggy 20130606
				salesGroupId=rs.getString("attribute1");    //add by Peggy 20210528
				paymentdesc=rs.getString("description");    //add by Peggy 20220525
		 		/*
				Statement stateCustomer=con.createStatement(); 
				//ResultSet rsCustomer = stateCustomer.executeQuery("select CUSTOMER_NAME, CUSTOMER_NUMBER from RA_CUSTOMERS where PARTY_ID = "+rs.getString("PARTY_ID")+" ");
				//20110826 modify by Peggy for R12 upgrade
				ResultSet rsCustomer = stateCustomer.executeQuery("select SUBSTRB (party.party_name, 1, 50) CUSTOMER_NAME,cust.account_number CUSTOMER_NUMBER "+
								" FROM hz_cust_accounts cust, hz_parties party WHERE cust.party_id = party.party_id"+
        						" and party.PARTY_ID = "+rs.getString("PARTY_ID")+" ");
				if (rsCustomer.next()) 
				{ 
		  			customerName=rsCustomer.getString(1);
		  			customerNum=rsCustomer.getString(2);
				}
				rsCustomer.close(); 	
				stateCustomer.close();
		 		*/
				
				//add by Peggy 20131220
				if (siteUseCode.equals("SHIP_TO"))
				{
					Statement statementx=con.createStatement();
					String sqlx = " select LAST_NAME || DECODE(FIRST_NAME, NULL,NULL, ', '||FIRST_NAME)|| DECODE(TITLE,NULL, NULL, ' '||TITLE) contact_name,con.contact_id"+
								  " from ar_contacts_v con,hz_cust_site_uses_all su"+
								  " where  con.customer_id ='"+customerID+"'"+
								  " and con.status='A'"+
								  " AND con.address_id=su.cust_acct_site_id"+
								  " AND su.site_use_code='"+siteUseCode+"'"+
								  " AND su.SITE_USE_ID='"+siteUseID+"'";
					//out.println(sqlx);
					ResultSet rsx=statementx.executeQuery(sqlx);	  			  				     
					if (rsx.next())
					{
						shipToContact = rsx.getString("contact_name");
						shipToContactid = rsx.getString("contact_id");
					}
					rsx.close();
					statementx.close();
				}
				
		 		out.println("<input type='hidden' name='SITEUSEID' value='"+siteUseID+"' >");
		 		out.println("<input type='hidden' name='COUNTRY' value='"+country+"' >");
		 		out.println("<input type='hidden' name='ADDRESS1' value='"+address1+"' >");
		 		out.println("<input type='hidden' name='SETENTER' value='Y' >");
		 		out.println("<input type='hidden' name='FOB' value='"+fob+"' >"); //add by Peggy 20121026
		 		out.println("<input type='hidden' name='TAXCODE' value='"+taxCode+"' >"); //add by Peggy 20130411
		 		out.println("<input type='hidden' name='SHIPTOCONTACT' value='"+shipToContact+"' >");     //add by Peggy 20131220
		 		out.println("<input type='hidden' name='SHIPTOCONTACTID' value='"+shipToContactid+"' >"); //add by Peggy 20131220
		 
		 		if (primaryFlag=="Y" || primaryFlag.equals("Y"))				 	 
		 		{ 
					trBgColor = "FFCC66"; 
				}
		 		else 
				{ 
					trBgColor = "E3E3CF"; 
				}
		 		buttonContent="this.value=sendToMainWindow("+'"'+siteUseCode+'"'+","+'"'+siteUseID+'"'+","+'"'+country+'"'+","+'"'+address1+'"'+","+'"'+setEnter+'"'+","+'"'+fob+'"'+","+'"'+taxCode+'"'+","+'"'+pricelist+'"'+","+'"'+paymentid+'"'+","+'"'+paymentname+'"'+","+'"'+shipToContact.replace("'","")+'"'+","+'"'+shipToContactid+'"'+","+'"'+salesGroupId+'"'+","+'"'+paymentdesc+'"'+")";		
         		out.print("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 		out.println("' onClick='"+buttonContent+"'></TD>");		
         		for (int i=1;i<=colCount-4;i++) // 不顯示第一欄資料, 故 for 由 2開始
         		{
           			String s=(String)rs.getString(i);		  
           			out.println("<TD nowrap><FONT SIZE='2'>"+s+"</TD>");
         		} //end of for
          		out.println("</TR>");	
				queryCount++;
        	} //end of while
        	out.println("</TABLE>");						
		
        	rs.close();       
	   	}//end of while
		%>
		<INPUT TYPE="hidden" NAME="SITEUSECODE" SIZE=5 value="<%=siteUseCode%>" >
		<INPUT TYPE="hidden" NAME="CUSTOMERID" SIZE=5 value="<%=customerID%>" >
		<INPUT TYPE="hidden" NAME="FUNC" SIZE=5 value="<%=FuncName%>" >
		<INPUT TYPE="hidden" NAME="SALESAREANO" SIZE=10 value="<%=salesAreaNo%>">
		<INPUT TYPE="hidden" NAME="EDICODE" value="<%=EDICODE%>">
		<%	   
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
		%>
		<script LANGUAGE="JavaScript">   
			sendToMainWindow("<%=siteUseCode%>","<%=siteUseID%>","<%=country%>","<%=address1%>","<%=setEnter%>","<%=fob%>","<%=taxCode%>","<%=pricelist%>","<%=paymentid%>","<%=paymentname%>","<%=shipToContact%>","<%=shipToContactid%>","<%=salesGroupId%>","<%=paymentdesc%>");		                   
		</script> 
		<%		
	    }  // End of if (queryCount==1)
    } //end of try
    catch (Exception e)
    {
    	out.println("Exception:"+e.getMessage());
    }
	statement.close();
	%>
  <BR>
<!--%表單參數%-->
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
