<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean,Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="array2DMODeliverInfoBean" scope="session" class="Array2DimensionInputBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String useCode=request.getParameter("USECODE");
 String dCustomerID=request.getParameter("DCUSTOMERID");
 String dCustomer=request.getParameter("DCUSTOMER");
 String dLocationID=request.getParameter("DLOCATIONID");
 String dLocationName=request.getParameter("DLOCATIONNAME");
 String dContactID=request.getParameter("DCONTACTID");
 String dDeliverContact=request.getParameter("DELIVERCONTACT");
 String dDeliverTo=request.getParameter("DDELIVERTO");
 String dDeliverAddress=request.getParameter("DELIVERADDRESS");
 String customerID=request.getParameter("CUSTOMERID");
 String deliverTo=request.getParameter("DELIVERTO");
 //String description=request.getParameter("DESCRIPTION");
 String searchString=request.getParameter("SEARCHSTRING");
 
 String moOtherInfo[]=new String[7]; // 宣告一維陣列,將其它設定資訊置入Array
 
 try
 {
   if (searchString==null)
   {     	  
	 searchString="%"; 
   } 
    else {  //out.println("NULL input");
	     }
	//out.println("invItem="+invItem+"<BR>");
	//out.println("itemDesc="+itemDesc+"<BR>");
	//out.println("searchString="+searchString+"<BR>");
	
	  //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
	  cs1.setString(1,"41");
	  cs1.execute();
      //out.println("Procedure : Execute Success !!! ");
      cs1.close();
   
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose Deliver To Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(customerID,contactID,contactName,URL)
{       
  //window.opener.document.MYFORM.NOTIFYCONTACT.value=contactName; 
  //window.opener.document.MYFORM.NCONTACT.value=contactName;  
  //alert(URL+"&CUSTOMERID="+customerID);
  document.MYFORM.action=URL+"&CUSTOMERID="+customerID;
  document.MYFORM.submit();  
  //this.window.close();
}

</script>
<body>  
<FORM action="TSDRQNotifyToFind.jsp" METHOD="post" NAME="MYFORM">
  <font size="-1"><jsp:getProperty name="rPH" property="pgDeliverCustomer"/>,<jsp:getProperty name="rPH" property="pgDeliverLocation"/>,<jsp:getProperty name="rPH" property="pgDeliveryTo"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgDeliverAddress"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="button" NAME="button1" value="<jsp:getProperty name="rPH" property="pgQuery"/>" onClick='setSubmit("../subwindow/TSDRQNotifyToFind.jsp")'><BR>
  -----<jsp:getProperty name="rPH" property="pgDeliverTo"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
  <%  
      int queryCount = 0;
	 
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
	     //out.println("1");
		 String sql = "";
		 String where =""; 
		 String order =	"";		        
				   if (useCode.equals("D_CUSTOMER"))  // 設定管理員可看得到所有客戶
				   {
				      sql ="select  /*+ INDEX(ACCT_SITE,HZ_CUST_ACCT_SITES_N2) */ "+
		                   "PARTY.PARTY_NAME CUSTOMER_NAME, cust_acct.account_number customer_Number "+
						   "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
						   "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
						   "HZ_CUST_ACCOUNTS CUST_ACCT ";			                      									  
					  where = "where SITE.SITE_USE_CODE ='DELIVER_TO' "+
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
								"and CUST_ACCT.status='A' and site.status='A' ";														  
				              					 													  
				      order = "order by SITE.LOCATION "; 
					  
					  String sqlCNT = "select count(DISTINCT cust_acct.account_number ) "+
					                    "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
						                     "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
      						                 "HZ_CUST_ACCOUNTS CUST_ACCT " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 
				                    
				   }
				   else if (useCode.equals("D_LOCATION"))
				   {	
				      sql ="select /*+ INDEX(ACCT_SITE,HZ_CUST_ACCT_SITES_N2) */ "+
		                   "SITE.LOCATION, PARTY.PARTY_NAME CUSTOMER_NAME, cust_acct.account_number customer_Number, "+
						   "LOC.ADDRESS1, LOC.ADDRESS2, LOC.ADDRESS3, "+
						   "decode(LOC.CITY,null, null, LOC.CITY|| ', ')||decode(LOC.state, null, null, LOC.state || ', ')||"+
						   "decode(LOC.postal_code,null, null, LOC.postal_code || ', ') || decode(LOC.country, null, null, LOC.country) CITY_STATE_ZIP "+
						   "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
						        "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
						        "HZ_CUST_ACCOUNTS CUST_ACCT ";			                      									  
					  where = "where SITE.SITE_USE_CODE ='DELIVER_TO' "+
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
								"and CUST_ACCT.status='A' and site.status='A' ";														  
				              					 													  
				      order = "order by SITE.LOCATION "; 
					 
					  String sqlCNT = "select count(DISTINCT cust_acct.account_number ) "+
					                    "from HZ_CUST_ACCT_SITES_ALL ACCT_SITE, HZ_PARTY_SITES PARTY_SITE, "+
						                     "HZ_LOCATIONS LOC, HZ_CUST_SITE_USES_ALL SITE, HZ_PARTIES PARTY, "+
      						                 "HZ_CUST_ACCOUNTS CUST_ACCT " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 
				   }
				   else if (useCode.equals("D_CONTACT"))
				   {	
				      sql ="select con.contact_id, LAST_NAME || DECODE(FIRST_NAME, NULL, NULL, ', '||FIRST_NAME) "+
		                   "|| DECODE(TITLE, NULL, NULL, ' '||TITLE) NAME, job_title, con.email_address  "+
						   "from ra_contacts con, ra_contact_roles rcr ";   
					  where = "where to_char(con.customer_id) ='"+customerID+"' "+
								"and con.status='A' "+
								"and con.contact_id=rcr.contact_id(+) "+
								"and nvl(RCR.USAGE_CODE,'DELIVER_TO') = 'DELIVER_TO' ";  
				      order = "order by last_name,first_name "; 
					  //out.println(sql+where+order);
					  String sqlCNT = "select count(DISTINCT con.contact_id) "+
					                  "from ra_contacts con, ra_contact_roles rcr " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 
				   }
				   else if (useCode.equals("D_TO"))
				         {
						 
				          sql = "select LOCATION_ID,ADDRESS_LINE_1  "+
			                    "from APPS.OE_DELIVER_TO_ORGS_V ";			                      									  
					      where = "where to_char(CUSTOMER_ID) = '"+customerID+"' ";
					              //"and (to_char(CONTACT_ID) ='"+searchString+"' or to_char(CONTACT_ID) like '"+searchString+"%' or NAME like '"+searchString+"%' or NAME like '"+searchString.toUpperCase()+"%') ";															  
				              					 													  
				          order = "order by LOCATION_ID "; 
						  
						  String sqlCNT = "select count(DISTINCT LOCATION_ID) from APPS.OE_DELIVER_TO_ORGS_V " + where;  
					      ResultSet rsCNT = statement.executeQuery(sqlCNT);
					      if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		                  rsCNT.close();
						  //out.println(sqlCNT); 
						 
				        }						
		 
		sql = sql + where + order;
		//out.println("sql="+sql); 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
		//out.println("1="+"<BR>");
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		//out.println("2="+"<BR>");
		String contactID=null,contactName=null,locationName=null,locationDesc=null,locationID=null,shpContact=null,shpDesc=null,shpContID=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {			 
		 trBgColor = "E3E3CF";
		 //out.println("Step0");		 
		 if (useCode.equals("D_CUSTOMER"))
		 {  
		  dCustomerID=rs.getString(2);
		  dCustomer=rs.getString(1);				 
		  out.println("<input type='hidden' name='DCUSTOMERID' value='"+dCustomerID+"' >");		 
		  out.println("<input type='hidden' name='DCUSTOMERNAME' value='"+dCustomer+"' >");		
		  buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+dCustomerID+'"'+","+'"'+dCustomer+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=DELIVER&DCUSTOMERID="+dCustomerID+"&DELIVERCUSTOMER="+dCustomer+"&CUSTOMERID="+customerID+"&DELIVERTO="+deliverTo+'"'+")";	
		 }
		 else if (useCode.equals("D_LOCATION"))	
		      { 
			     dLocationID=rs.getString(1);
		         dLocationName=dLocationID;		
				 dDeliverAddress=rs.getString("ADDRESS1"); 
		         out.println("<input type='hidden' name='DLOCATIONID' value='"+dLocationID+"' >");		 
		         out.println("<input type='hidden' name='DLOCATIONAME' value='"+dLocationName+"' >");	
				 
			     buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+dLocationID+'"'+","+'"'+dLocationName+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=DELIVER&DCUSTOMERID="+dCustomerID+"&DELIVERCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DELIVERLOCATION="+dLocationName+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERADDRESS="+dLocationID+"&DELIVERTO="+dLocationID+'"'+")";	
			  } else if (useCode.equals("D_CONTACT"))	
		      { 
			     dContactID=rs.getString(1);		        	
				 dDeliverContact=rs.getString(2); 
		         out.println("<input type='hidden' name='DCONTACTID' value='"+dContactID+"' >");		 
		         out.println("<input type='hidden' name='DELIVERCONTACT' value='"+dDeliverContact+"' >");	
				 
			     buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+dLocationID+'"'+","+'"'+dLocationName+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=DELIVER&DCUSTOMERID="+dCustomerID+"&DELIVERCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DELIVERLOCATION="+dLocationName+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&DELIVERADDRESS="+dDeliverAddress+"&CUSTOMERID="+customerID+"&DELIVERADDRESS="+dLocationID+"&DELIVERTO="+dLocationID+'"'+")";	
			  } else if (useCode.equals("D_TO"))
			         {
					   dDeliverTo=rs.getString(1);
		               dDeliverAddress=rs.getString(2);				 
		               out.println("<input type='hidden' name='DDELIVERTO' value='"+dDeliverTo+"' >");		 
		               out.println("<input type='hidden' name='DELIVERADDRESS' value='"+dDeliverAddress+"' >");
					   buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+dDeliverTo+'"'+","+'"'+dDeliverAddress+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=DELIVER&NCONTACTID="+dCustomerID+"&DELIVERCUSTOMER="+dCustomer+"&DLOCATIONID="+dLocationID+"&DELIVERLOCATION="+dLocationName+"&DCONTACTID="+dContactID+"&DELIVERCONTACT="+dDeliverContact+"&CUSTOMERID="+customerID+"&DELIVERTO="+dDeliverTo+"&DELIVERADDRESS="+dDeliverAddress+'"'+")";	
					 }
			  
         out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
          out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   }//end of while
	   
	    if (queryCount==1) //若取到的查詢數 == 1
	    {
	     /*
		  if (useCode.equals("D_CUSTOMER"))
		  {
	     %>
		    <script LANGUAGE="JavaScript">					    
				window.opener.document.MYFORM.DCUSTOMERID.value = document.MYFORM.DCUSTOMERID.value;
				window.opener.document.MYFORM.DELIVERCUSTOMER.value = document.MYFORM.DCUSTOMERNAME.value; 
				this.window.close(); 
            </script>
		   <%
		   } else if (useCode.equals("D_LOCATION"))
		          { 
				   %>
				       <script LANGUAGE="JavaScript">		
			           //window.opener.document.location.reload();							
				        window.opener.document.MYFORM.DLOCATIONID.value = document.MYFORM.DDELIVERTO.value;
				        window.opener.document.MYFORM.DELIVERLOCATION.value = document.MYFORM.DELIVERADDRESS.value; 
				        this.window.close(); 
                        </script>
				   <%  
				  } else if (useCode.equals("D_TO"))
				         {
						   %>
						      <script LANGUAGE="JavaScript">					           	
				               window.opener.document.MYFORM.DELIVERTO.value = document.MYFORM.CONTACTNAME.value;
				               window.opener.document.MYFORM.DDELIVERTO.value = document.MYFORM.CONTACTNAME.value; 
				               this.window.close(); 
                              </script>
						   <%  
						 }
			  */ 
	    }
	   
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
