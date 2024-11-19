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
<jsp:useBean id="array2DMOContactInfoBean" scope="session" class="Array2DimensionInputBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
 String useCode=request.getParameter("USECODE");
 String nContactID=request.getParameter("NCONTACTID");
 String nContact=request.getParameter("NCONTACT");
 String nLocationID=request.getParameter("NLOCATIONID");
 String nLocation=request.getParameter("NLOCATION");
 String customerID=request.getParameter("CUSTOMERID");
 String deliverTo=request.getParameter("DELIVERTO");
 String searchString=request.getParameter("SEARCHSTRING");
 
 String moContactInfo[]=new String[3]; // 宣告一維陣列,將其它設定資訊置入Array
 
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
<title>Page for choose Payment Term List</title>
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
  <font size="-1"><jsp:getProperty name="rPH" property="pgNotifyContact"/>、<jsp:getProperty name="rPH" property="pgNotifyLocation"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgShipContact"/>: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="button" NAME="button1" value="<jsp:getProperty name="rPH" property="pgQuery"/>" onClick='setSubmit("../subwindow/TSDRQNotifyToFind.jsp")'><BR>
  -----<jsp:getProperty name="rPH" property="pgNotifyContact"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
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
				   if (useCode.equals("N_CONTACT"))  // 設定管理員可看得到所有客戶
				   {
				      sql = "select CONTACT_ID, NAME "+
			                "  from APPS.OE_CONTACTS_V ";			                      									  
					  where = "where to_char(CUSTOMER_ID) = '"+customerID+"' "+	
					          "and (to_char(CONTACT_ID) ='"+searchString+"' or to_char(CONTACT_ID) like '"+searchString+"%' or NAME like '"+searchString+"%' or NAME like '"+searchString.toUpperCase()+"%') ";															  
				              					 													  
				      order = "order by CONTACT_ID "; 
					  
					  String sqlCNT = "select count(DISTINCT CONTACT_ID) from APPS.OE_CONTACTS_V " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 
				                    
				   }
				   else if (useCode.equals("N_LOCATION"))
				   {				    			 
				      sql = "select LOCATION_ID||'-'||ADDRESS_LINE_1, '"+nContact+"', LOCATION_ID "+
			                "  from APPS.OE_DELIVER_TO_ORGS_V ";			                      									  
					  where = "where to_char(CUSTOMER_ID) = '"+customerID+"' ";	
					          //"and (to_char(CONTACT_ID) ='"+searchString+"' or to_char(CONTACT_ID) like '"+searchString+"%' or NAME like '"+searchString+"%' or NAME like '"+searchString.toUpperCase()+"%') ";															  
				              					 													  
				      order = "order by 1 ";    
					  
					  String sqlCNT = "select count(DISTINCT LOCATION_ID) from APPS.OE_DELIVER_TO_ORGS_V " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();  									
					  //out.println(sqlCNT);  
				   }
				   else if (useCode.equals("N_SHIPCONT"))
				         {
				          sql = "select NAME, CONTACT_ID  "+
			                    "  from APPS.OE_CONTACTS_V ";			                      									  
					      where = "where to_char(CUSTOMER_ID) = '"+customerID+"' ";
					              //"and (to_char(CONTACT_ID) ='"+searchString+"' or to_char(CONTACT_ID) like '"+searchString+"%' or NAME like '"+searchString+"%' or NAME like '"+searchString.toUpperCase()+"%') ";															  
				              					 													  
				          order = "order by NAME "; 
						  
						  String sqlCNT = "select count(DISTINCT CONTACT_ID) from APPS.OE_CONTACTS_V " + where;  
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
		 //		 
		 //
		 if (useCode.equals("N_CONTACT"))
		 {  
		  contactID=rs.getString(1);
		  contactName=rs.getString(2);				 
		  out.println("<input type='hidden' name='CONTACTID' value='"+contactID+"' >");		 
		  out.println("<input type='hidden' name='CONTACTNAME' value='"+contactName+"' >");		
		  buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+contactID+'"'+","+'"'+contactName+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=NOTIFY&NCONTACTID="+contactID+"&DELIVERTO="+deliverTo+"&NOTIFYCONTACT="+contactName+'"'+")";	
		 }
		 else if (useCode.equals("N_LOCATION"))	
		      { 
			     locationName=rs.getString(1);
		         locationDesc=rs.getString(2);		
				 locationID=rs.getString(3);				 
		         out.println("<input type='hidden' name='LOCATIONNAME' value='"+locationName+"' >");		 
		         out.println("<input type='hidden' name='LOCATIONDESC' value='"+locationDesc+"' >");	
				 out.println("<input type='hidden' name='LOCATIONID' value='"+locationID+"' >");	
			     buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+locationName+'"'+","+'"'+locationDesc+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=NOTIFY&NCONTACTID="+nContactID+"&DELIVERTO="+deliverTo+"&NOTIFYCONTACT="+nContact+"&NLOCATIONID="+locationID+"&NOTIFYLOCATION="+locationName+'"'+")";	
			  } else if (useCode.equals("N_SHIPCONT"))
			         {
					   shpContact=rs.getString(1);
		               shpDesc=rs.getString(2);				 
		               out.println("<input type='hidden' name='SHPCONTACT' value='"+shpContact+"' >");		 
		               out.println("<input type='hidden' name='SHPDESC' value='"+shpDesc+"' >");
					   buttonContent="this.value=sendToMainWindow("+'"'+customerID+'"'+","+'"'+shpContact+'"'+","+'"'+shpDesc+'"'+","+'"'+"../subwindow/TSSalesDRQDeliverInforSet.jsp?PAGECH=NOTIFY&NCONTACTID="+nContactID+"&DELIVERTO="+deliverTo+"&NOTIFYCONTACT="+nContact+"&NLOCATIONID="+nLocationID+"&NOTIFYLOCATION="+nLocation+"&NSHIPCONTID="+shpDesc+"&SHIPCONTACT="+shpContact+'"'+")";	
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
	     //out.println("queryCount="+queryCount);
		 //moContactInfo[0] = contactName;  
         //array2DMOContactInfoBean.setArrayString(moContactInfo);
	     %>
		    <script LANGUAGE="JavaScript">		
			    //window.opener.document.location.reload();							
				window.opener.document.MYFORM.NOTIFYCONTACT.value = document.MYFORM.CONTACTNAME.value;
				window.opener.document.MYFORM.NCONTACT.value = document.MYFORM.CONTACTNAME.value;                   
               /* if (document.MYFORM.CUSTAROVERDUE.value=="Y")
                {
                   window.opener.document.MYFORM.AROVERDUEDESC.value="Customer AR overdue 90 days!! ";
                } else
                {
                   window.opener.document.MYFORM.AROVERDUEDESC.value=" ";
                } 
				*/
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
<INPUT TYPE="hidden" NAME="NAME" SIZE=30 value="<%=nContact%>" >
<INPUT TYPE="hidden" NAME="DELIVERTO" SIZE=30 value="<%=deliverTo%>" >
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>

