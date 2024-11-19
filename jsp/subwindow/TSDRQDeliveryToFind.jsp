<%@ page language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String customerNo=request.getParameter("CUSTOMERNO");
 String name=request.getParameter("NAME");
 //String description=request.getParameter("DESCRIPTION");
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {     	  
	 if (customerNo!=null && !customerNo.equals("")) searchString=customerNo;
	 else if (name!=null && !name.equals("")) searchString=name;
	 else { searchString="%"; }
   } 
    else {  //out.println("NULL input");
	     }
	//out.println("invItem="+invItem+"<BR>");
	//out.println("itemDesc="+itemDesc+"<BR>");
	//out.println("searchString="+searchString+"<BR>");
	
	//  CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	//  cs1.setString(1,"41");
	//  cs1.execute();
      //out.println("Procedure : Execute Success !!! ");
    //  cs1.close();
   
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose Payment Term List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(custID,custNo,custName,custActive,custAROverdue)
{
  window.opener.document.MYFORM.CUSTACTIVE.value=custActive;
  window.opener.document.MYFORM.CUSTOMERID.value=custID; 
  window.opener.document.MYFORM.CUSTOMERNO.value=custNo;
  window.opener.document.MYFORM.CUSTOMERNAME.value=custName;
  window.opener.document.MYFORM.CUSTOMERAROVERDUE.value=custAROverdue;
  if (custAROverdue=="Y")
  {
    window.opener.document.MYFORM.AROVERDUEDESC.value="Customer AR overdue 90 days!! ";
  } else
  {
    window.opener.document.MYFORM.AROVERDUEDESC.value=" ";
  } 
  //window.opener.document.location.reload();
  this.window.close();
}

</script>
<body >  
<FORM METHOD="post" ACTION="TSDRQCustomerInfoFind.jsp" NAME=CUSTFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgCustNo"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgCustomerName"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgCustomerName"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
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
				   if (UserRoles.equals("admin"))  // 設定管理員可看得到所有客戶
				   {
				      sql = "select CUSTOMER_ID, CUSTOMER_NUMBER, CUSTOMER_NAME, nvl(ATTRIBUTE3,'N') as AR_OVERDUE "+
			                "  from APPS.RA_CUSTOMERS ";
			                        //"where status = 'A' "+	
									//"and ( CUSTOMER_NUMBER like '"+searchString+"%' or CUSTOMER_NAME like '"+searchString+"%' or CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') "+															  
					  where = "where  "+	
					          "(CUSTOMER_NUMBER ='"+searchString+"' or CUSTOMER_NUMBER like '"+searchString+"%' or CUSTOMER_NAME like '"+searchString+"%' or CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') ";															  
				              					 													  
				      order = "order by CUSTOMER_ID "; 
					  
					  String sqlCNT = "select count(DISTINCT CUSTOMER_ID) from APPS.RA_CUSTOMERS " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 
				                    
				   }
				   else if (userSalesGroupID!=null && !userSalesGroupID.equals(""))
				   {				    			 
				      sql = "select DISTINCT a.CUST_ACCOUNT_ID, c.CUSTOMER_NUMBER, c.CUSTOMER_NAME, nvl(c.ATTRIBUTE3,'N') as AR_OVERDUE "+
			                "  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c ";			                          
									    	
					  where = "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID and  b.attribute1 in ("+userSalesGroupID+") "+	
							  "  and a.STATUS = b.STATUS and a.ORG_ID = b.ORG_ID "+										
							  "  and a.ORG_ID ='41' and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
							  "  and (CUSTOMER_NUMBER ='"+searchString+"' or c.CUSTOMER_NUMBER like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') ";
					  order = "order by CUST_ACCOUNT_ID ";    
					  
					  String sqlCNT = "select count(DISTINCT a.CUST_ACCOUNT_ID) from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();  									
					  //out.println(sqlCNT);  
				   }
				   else {
				          sql = "select DISTINCT a.CUST_ACCOUNT_ID, c.CUSTOMER_NUMBER, c.CUSTOMER_NAME, nvl(c.ATTRIBUTE3,'N') as AR_OVERDUE "+
			                    "  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c ";			                          
									    
						  where = "where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID "+	
							      "  and a.STATUS = b.STATUS and a.ORG_ID = b.ORG_ID "+										
								  "  and a.ORG_ID ='41' and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID "+ 
								  "  and (CUSTOMER_NUMBER ='"+searchString+"' or c.CUSTOMER_NUMBER like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString+"%' or c.CUSTOMER_NAME like '"+searchString.toUpperCase()+"%') ";				    
						  order = "order by CUST_ACCOUNT_ID ";
						  
						  String sqlCNT = "select count(DISTINCT a.CUST_ACCOUNT_ID) from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.RA_CUSTOMERS c " + where;  
					      ResultSet rsCNT = statement.executeQuery(sqlCNT);
					      if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		                  rsCNT.close();
						  //out.println(sqlCNT); 
				        }	
		//out.println("sql="+sql);  
		sql = sql + where + order;
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String custActive=null,customerID=null,custNo=null,custName=null,custAROverdue=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {		
		 // 取各別的客戶STATUS狀態
		 Statement stateStatus=con.createStatement();
		 ResultSet rsStatus=stateStatus.executeQuery("select STATUS from RA_CUSTOMERS where CUSTOMER_NUMBER = '"+rs.getString("CUSTOMER_NUMBER")+"' ");
		 if (rsStatus.next()) custActive=rsStatus.getString(1);
		 rsStatus.close();
		 stateStatus.close();
		 // 取各別的客戶STATUS狀態  		 
		 
		 customerID=rs.getString(1);
		 custNo=rs.getString("CUSTOMER_NUMBER");
		 custName=rs.getString("CUSTOMER_NAME");
		 custAROverdue=rs.getString("AR_OVERDUE");
		 out.println("<input type='hidden' name='CUSTACTIVE' value='"+custActive+"' >");
		 out.println("<input type='hidden' name='CUSTID' value='"+customerID+"' >");
		 out.println("<input type='hidden' name='CUSTNO' value='"+custNo+"' >");
		 out.println("<input type='hidden' name='CUSTNAME' value='"+custName+"' >");
		 out.println("<input type='hidden' name='CUSTAROVERDUE' value='"+custAROverdue+"' >");
		 
		 if (customerNo==null) { trBgColor = "E3E3CF"; }
		 else if (customerNo==rs.getString("CUSTOMER_NUMBER") || customerNo.equals(rs.getString("CUSTOMER_NUMBER")))				 	 
		 { trBgColor = "FFCC66"; }
		 else { trBgColor = "E3E3CF"; }
		 buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+custNo+'"'+","+'"'+custName+'"'+","+'"'+custActive+'"'+","+'"'+custAROverdue+'"'+")";		
         out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
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
	     //out.println("queryCount="+queryCount);
	     %>
		    <script LANGUAGE="JavaScript">		
			    //window.opener.document.location.reload();
			    window.opener.document.MYFORM.CUSTACTIVE.value = document.CUSTFORM.CUSTACTIVE.value;	   
				window.opener.document.MYFORM.CUSTOMERID.value = document.CUSTFORM.CUSTID.value;
				window.opener.document.MYFORM.CUSTOMERNO.value = document.CUSTFORM.CUSTNO.value; 
				window.opener.document.MYFORM.CUSTOMERNAME.value = document.CUSTFORM.CUSTNAME.value;   
                window.opener.document.MYFORM.CUSTOMERAROVERDUE.value = document.CUSTFORM.CUSTAROVERDUE.value;
                if (document.CUSTFORM.CUSTAROVERDUE.value=="Y")
                {
                   window.opener.document.MYFORM.AROVERDUEDESC.value="Customer AR overdue 90 days!! ";
                } else
                {
                   window.opener.document.MYFORM.AROVERDUEDESC.value=" ";
                } 
				this.window.close(); 
            </script>
		 <%
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
<INPUT TYPE="hidden" NAME="CUSTOMERNO" SIZE=10 value="<%=customerNo%>" >
<INPUT TYPE="hidden" NAME="NAME" SIZE=30 value="<%=name%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
