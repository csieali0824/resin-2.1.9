<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>

<%
 String tsInvoiceNo  =request.getParameter("TSINVOICENO");
 String newTsInvoiceNo = request.getParameter("NEWTSINVOICENO");
 String oCustomerNo =request.getParameter("CUSTOMERNO");
 String oShipToOrg	 =request.getParameter("SHIPTOORG"); 
 String oShipMethod	 =request.getParameter("SHIPMETHOD");
 String oFobPoint	 =request.getParameter("FOBPOINT");
 String oPaymentTerm	 =request.getParameter("PAYTERM");
 String wCustomerNo =request.getParameter("CUSTOMERNO");
 String wShipToOrg	 =request.getParameter("SHIPTOORG"); 
 String wShipMethod	 =request.getParameter("SHIPMETHOD");
 String wFobPoint	 =request.getParameter("FOBPOINT");
 String wPaymentTerm	 =request.getParameter("PAYTERM");
 String nCustomerNo =request.getParameter("CUSTOMERNO");
 String nShipToOrg	 =request.getParameter("SHIPTOORG"); 
 String nShipMethod	 =request.getParameter("SHIPMETHOD");
 String nFobPoint	 =request.getParameter("FOBPOINT");
 String nPaymentTerm	 =request.getParameter("PAYTERM");
 String nStatus  =request.getParameter("STATUS");
 String cntItem	 =request.getParameter("CNTITEM"); 
 String wshStatusCode=request.getParameter("WSHSTATUS");
 String countWsh = request.getParameter("COUNTWSH");  
 String setInvoice ="";
 String chkFlag ="";
 String colorStr="";
 String oriInvCustNo = "";
 int cntWsh = 0;
 

 try
  {
   if (tsInvoiceNo==null)
     { tsInvoiceNo="0";  }
	 
   if (newTsInvoiceNo==null)
     { newTsInvoiceNo="";  } 
  } 
 catch (Exception e)
  {
    out.println("Exception 1:"+e.getMessage());
  }   
%>
<html>
<head>
<title>TSC Invoice Number Change</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit1a(URL)
{ 
 if (event.keyCode==13)
 {   
 	 document.MYFORM.SETINVOICE.value ="Y"; 
     document.MYFORM.action=URL;
     document.MYFORM.submit();
  }//end if keycode
}

function setSubmit(URL)   //Query
{ 
  if (document.MYFORM.NEWTSINVOICENO.value =="" )
  {
    alert("Please Assign NEW Invoice Number!!!");
	return false; 
  } 
  else
  {  
 	document.MYFORM.SETINVOICE.value ="Y";  
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }
} 
function setSubmit2(URL)
{   
    document.MYFORM.action=URL;
    document.MYFORM.submit();
}
function chkInvoice(URL)
{   
   // document.MYFORM.action='../jsp/TSSHPInvoiceNoUpdate.jsp';
    document.MYFORM.action=URL;
    document.MYFORM.submit();
}


</script>
<body >  
<%@ include file="/jsp/include/TSCMfgDocHyperLinkPage.jsp"%>  
<FORM METHOD="post" ACTION="TSSHPInvoiceUpdateProcess.jsp" NAME="MYFORM">
<%

 /*  找尋舊發票資訊,供比對 */
try
{
  if( tsInvoiceNo !=null )
    {       
       String  sqlInvNo =  " select CUSTOMERNO,SHIPTOORG,SHIPMETHOD,FOBPOINT,PAYTERM from TSC_DROPSHIP_SHIP_HEADER where  TSINVOICENO = upper('"+tsInvoiceNo+"')" ;
       //out.println("sqlInvNo="+sqlInvNo);
       Statement stateInvNo=con.createStatement();
       ResultSet rsInvNo=stateInvNo.executeQuery(sqlInvNo);
	   if (rsInvNo.next())
		 {
		    oCustomerNo     = rsInvNo.getString("CUSTOMERNO");
			oShipToOrg      = rsInvNo.getString("SHIPTOORG");
			oShipMethod     = rsInvNo.getString("SHIPMETHOD");
			oFobPoint       = rsInvNo.getString("FOBPOINT");
			oPaymentTerm    = rsInvNo.getString("PAYTERM");
		  }
		   rsInvNo.close();
           stateInvNo.close();	
     }//end if tsInvoiceNo !=null 

  } //end of try
  catch (Exception e)
   {
    out.println("Exception 2:"+e.getMessage());
   }

 /*  找尋新輸入發票資訊 */
try
{
  if( newTsInvoiceNo !=null && !newTsInvoiceNo.equals("") )
    {  
      if (newTsInvoiceNo.toUpperCase()==tsInvoiceNo.toUpperCase() || newTsInvoiceNo.toUpperCase().equals(tsInvoiceNo.toUpperCase()))  //要替換的號碼與原本的一樣,不予更改
      { %>			
		 <script language="javascript">
		    alert("please assign new number!!"); 	
            chkInvoice('../jsp/TSSHPInvoiceNoUpdate.jsp');
    	 </script>						
		        <%	chkFlag="N";   
                    setInvoice="N";
       } 

       //查詢在WSH_NEW_DELIVERIES中,是否已存在該invoice no,若存在要帶出相關客戶資訊做比對
	   String sqlw = " SELECT count(DISTINCT wnd.delivery_id) as COUNTWSH  "+
          				 "    FROM apps.wsh_delivery_assignments wda, apps.wsh_delivery_details wdd, "+
                		 "         apps.wsh_new_deliveries wnd, apps.ra_customers ra "+
         				 "    WHERE wda.delivery_detail_id = wdd.delivery_detail_id "+
            			 "      AND wda.delivery_id = wnd.delivery_id  AND ra.customer_id = wnd.customer_id "+
						 "      AND wnd.name= upper('"+newTsInvoiceNo+"') ";
           //out.println("<BR>sqlw="+sqlw);
       Statement statecw=con.createStatement();
       ResultSet rscw=statecw.executeQuery(sqlw);
	   if (rscw.next())
		   { countWsh  = rscw.getString("COUNTWSH"); cntWsh  = rscw.getInt("COUNTWSH");  }  
	   rscw.close();
       statecw.close(); 

       if (countWsh !="0" || !countWsh.equals("0") )		//有INVOICE存在,則抓INVOICE的客戶資訊
	     { 
		   String customerID = "0";
		   String sqlwsh = " select distinct WND.FOB_CODE,WND.SHIP_METHOD_CODE ,WDD.SHIP_TO_SITE_USE_ID,RA.CUSTOMER_NUMBER "+
								" from APPS.WSH_DELIVERY_ASSIGNMENTS WDA, APPS.WSH_DELIVERY_DETAILS WDD, APPS.WSH_NEW_DELIVERIES WND ,APPS.RA_CUSTOMERS RA "+
								" where WDA.DELIVERY_DETAIL_ID=WDD.DELIVERY_DETAIL_ID  and WDA.DELIVERY_ID=WND.DELIVERY_ID "+
								" 	  and RA.CUSTOMER_ID=WND.CUSTOMER_ID  and WND.NAME = upper('"+tsInvoiceNo+"') ";
          // out.println("<BR>sqlInvCust="+sqlwsh);
           Statement stateWsh=con.createStatement();
           ResultSet rsWsh=stateWsh.executeQuery(sqlwsh);
		   if (rsWsh.next())
		   {
		      wCustomerNo     = rsWsh.getString("CUSTOMER_NUMBER");
			  wShipToOrg      = rsWsh.getString("SHIP_TO_SITE_USE_ID");
			  wShipMethod     = rsWsh.getString("SHIP_METHOD_CODE");
			  wFobPoint       = rsWsh.getString("FOB_CODE");

          // out.println("wCustomer="+wCustomerNo+"  "+"oCustomerNo"+oCustomerNo);

 
			 oriInvCustNo = wCustomerNo;  // 若舊發票已存在,則將發票對應的客戶代號存起來...
			 
			
			 String sqlGetWAdd = "select a.SITE_USE_CODE, a.PRIMARY_FLAG, a.SITE_USE_ID, b.COUNTRY, b.ADDRESS1,  "+		
				                 "       a.PAYMENT_TERM_ID, a.PAYMENT_TERM_NAME, a.SHIP_VIA, a.FOB_POINT, a.PRICE_LIST_ID, c.DESCRIPTION, "+  
					             "       a.ATTRIBUTE1, d.CURRENCY_CODE, f.MASTER_GROUP_ID "+
					             "  from AR_SITE_USES_V a,RA_ADDRESSES_ALL b, RA_TERMS_VL c, "+  
					             "       SO_PRICE_LISTS d, TSC_OM_GROUP e, TSC_OM_GROUP_MASTER f "+				  
					             " where a.ADDRESS_ID = b.ADDRESS_ID and a.STATUS=b.STATUS and a.STATUS='A' and a.PAYMENT_TERM_ID = c.TERM_ID(+) "+		
					             "   and a.PRIMARY_FLAG='Y' and a.ADDRESS_ID in (select CUST_ACCT_SITE_ID from HZ_CUST_ACCT_SITES_ALL "+		
							                                                "where to_char(CUST_ACCOUNT_ID) ='"+customerID+"') "+
	                             "   and a.PRICE_LIST_ID = d.PRICE_LIST_ID "+
   	                             "   and a.ATTRIBUTE1 = e.GROUP_ID(+) "+
       	                         "   and e.MASTER_GROUP_ID = f.MASTER_GROUP_ID(+) "+
				                 " order by a.SITE_USE_CODE DESC";
			Statement stateGetWAdd=con.createStatement();
            ResultSet rsGetWAdd=stateGetWAdd.executeQuery(sqlGetWAdd);  
			if (rsGetWAdd.next())
			{
			  //shipAddress    =  rsGetWAdd.getString("ADDRESS1");
			  wPaymentTerm    =  rsGetWAdd.getString("PAYMENT_TERM_NAME");
			  if (oShipMethod==null) wShipMethod = rsGetWAdd.getString("SHIP_VIA");
			  if (oFobPoint==null) wFobPoint = rsGetWAdd.getString("FOB_POINT");
			}
			rsGetWAdd.close();
			stateGetWAdd.close(); 

/*替換的發票已存在則比對條件*/
        if ( (oCustomerNo!= wCustomerNo || !oCustomerNo.equals(wCustomerNo) ) || 
            (oShipToOrg!=wShipToOrg  && !oShipToOrg.equals(wShipToOrg) )     || 
            (oShipMethod!=wShipMethod  && !oShipMethod.equals(wShipMethod) ) ||
            (oFobPoint!=wFobPoint  && !oFobPoint.equals(wFobPoint)  )        ||
            (oPaymentTerm!=wPaymentTerm  && !oPaymentTerm.equals(wPaymentTerm)) 
           )
		   { %>			
		      <script language="javascript">
		        alert("The Number Cannot change to  different condition W!!"); 
               //chkInvoice('../jsp/TSSHPInvoiceNoUpdate.jsp');
		      </script>			   	
		     <%	chkFlag="N"; 
            }
	       } //end if (rsWsh.next())
	       rsWsh.close();
           stateWsh.close();
	

        }//(countWsh !="0" || !countWsh.equals("0") )   

       String Sqlc="select count(*) cntItem from TSC_DROPSHIP_SHIP_HEADER where  TSINVOICENO='"+newTsInvoiceNo+"'";
		//out.println("Sqln="+Sqln);
       Statement statec=con.createStatement();
       ResultSet rsc=statec.executeQuery(Sqlc);
	   if (rsc.next())
		 {	cntItem	= rsc.getString("CNTITEM"); }
		rsc.close();
        statec.close();	
		out.println("cntItem="+cntItem);
      
	  if (cntItem!="0" && !cntItem.equals("0"))  
      {
	   String Sqln="select STATUS,CUSTOMERNO,SHIPTOORG,SHIPMETHOD,FOBPOINT,PAYTERM from TSC_DROPSHIP_SHIP_HEADER where  TSINVOICENO= upper('"+newTsInvoiceNo+"')";
		//out.println("Sqln="+Sqln);
       Statement statenInvNo=con.createStatement();
       ResultSet rsnInvNo=statenInvNo.executeQuery(Sqln);
	   if (rsnInvNo.next())
		{
			nStatus			= rsnInvNo.getString("STATUS");
		    nCustomerNo     = rsnInvNo.getString("CUSTOMERNO");
			nShipToOrg      = rsnInvNo.getString("SHIPTOORG");
			nShipMethod     = rsnInvNo.getString("SHIPMETHOD");
			nFobPoint       = rsnInvNo.getString("FOBPOINT");
			nPaymentTerm    = rsnInvNo.getString("PAYTERM");
		    // out.println("nStatus="+nStatus);

		     if (nStatus =="CLOSED" || nStatus.equals("CLOSED") )
			  {  %>			
		            <script language="javascript">
		             alert("The Number already Closed!!"); 	
                    // chkInvoice('../jsp/TSSHPInvoiceNoUpdate.jsp'); 
                     </script>						
		        <%	chkFlag="N"; } // End of if (nStatus =="CLOSED" && nStatus.equals("CLOSED") )
               else{
                    chkFlag="Y";
                    setInvoice="Y";
                   }

/*替換的發票已存在則比對條件*/

      if ( (oCustomerNo!= nCustomerNo && !oCustomerNo.equals(nCustomerNo) ) || 
           (oShipToOrg!=nShipToOrg  && !oShipToOrg.equals(nShipToOrg) )     || 
           (oShipMethod!=nShipMethod  && !oShipMethod.equals(nShipMethod) ) ||
           (oFobPoint!=nFobPoint  && !oFobPoint.equals(nFobPoint)  )        ||
           (oPaymentTerm!=nPaymentTerm  && !oPaymentTerm.equals(nPaymentTerm)) 
          )
		{ %>			
		   <script language="javascript">
		     alert("The Number Cannot change to  different condition !!"); 
           //  chkInvoice('../jsp/TSSHPInvoiceUpdateProcess.jsp');
		   </script>			   	
		 <%	chkFlag="N";	}
         else{
              chkFlag="Y";
              setInvoice="Y";
             }

       if (newTsInvoiceNo==tsInvoiceNo || newTsInvoiceNo.equals(tsInvoiceNo))
          {   chkFlag="N";
              setInvoice="N";}

          } //end  if (rsnInvNo.next())
        rsnInvNo.close();
        statenInvNo.close();	
       } //end cntItem !=0
       else
        {
          chkFlag="Y";
          setInvoice="Y";
        }
     }//end if if( newTsInvoiceNo !=null && !newTsInvoiceNo.equals("") )

  } //end of try
  catch (Exception e)
   {
    out.println("Exception 3:"+e.getMessage());
   }
/* 執行INVOICE NO 更新    */
try
{ 
   //out.println("setInvoice= "+setInvoice+"   "+"chkFlag="+chkFlag);

  if ( (setInvoice=="Y" && setInvoice.equals("Y")) && (chkFlag =="Y" && chkFlag.equals("Y")) )
    {
      if (cntItem!="0" && !cntItem.equals("0") && ((newTsInvoiceNo!=tsInvoiceNo && !newTsInvoiceNo.equals(tsInvoiceNo))))  //舊invoice ,要把表頭的刪除
      {
  	    String sql1=" delete TSC_DROPSHIP_SHIP_HEADER  where STATUS !='CLOSED' and TSINVOICENO= upper('"+tsInvoiceNo+"')";
   	    out.println("sql1="+sql1);           
	    String sql2=" update TSC_DROPSHIP_SHIP_LINE set TSINVOICENO= '"+newTsInvoiceNo+"' where LINE_STATUS !='CLOSED' and TSINVOICENO= upper('"+tsInvoiceNo+"')";
   	    //out.println("sql2="+sql2);
        PreparedStatement pstmt=con.prepareStatement(sql1);
        pstmt.executeUpdate(); 
        pstmt.close();				
        PreparedStatement pstmt2=con.prepareStatement(sql2);
        pstmt2.executeUpdate(); 
        pstmt2.close();
		%><tr><td><font color="#000066" size="4" face="Arial">Invoice Number</font></td>
              <td><font color="#FF0000" size="4" face="Arial"><%=newTsInvoiceNo%></font></td>
              <td><font color="#000066" size="4" face="Arial">Update Success!!</font></td></tr><%
        tsInvoiceNo=newTsInvoiceNo;
	    newTsInvoiceNo="";
    
      }

      if (cntItem =="0" || cntItem.equals("0"))  //新的invoice號碼則全改
      { 
  	    String sql3=" update TSC_DROPSHIP_SHIP_HEADER set TSINVOICENO= '"+newTsInvoiceNo+"' where STATUS !='CLOSED' and TSINVOICENO= upper('"+tsInvoiceNo+"')";
   	    //out.println("sql3="+sql3);           
	    String sql4=" update TSC_DROPSHIP_SHIP_LINE set TSINVOICENO= '"+newTsInvoiceNo+"' where LINE_STATUS !='CLOSED' and TSINVOICENO= upper('"+tsInvoiceNo+"')";
   	    //out.println("sql4="+sql4);
        PreparedStatement pstmt3=con.prepareStatement(sql3);
        pstmt3.executeUpdate(); 
        pstmt3.close();				
        PreparedStatement pstmt4=con.prepareStatement(sql4);
        pstmt4.executeUpdate(); 
        pstmt4.close();
		%><tr><td><font color="#000066" size="4" face="Arial">Invoice Number</font></td>
              <td><font color="#FF0000" size="4" face="Arial"><%=newTsInvoiceNo%></font></td>
              <td><font color="#000066" size="4" face="Arial">Update Success!!</font></td></tr><%
        tsInvoiceNo=newTsInvoiceNo;
        newTsInvoiceNo="";
      }//end else if

    } 
 } //end of try
  catch (Exception e)
   {
    out.println("Exception 4:"+e.getMessage());
   }

%>

  <table width="45%" border="1"  cellpadding="-1" cellspacing="-1"  bordercolor="#000066" bgcolor="#FFFFFF">
   <tr ></tr>
   <td  height="50" colspan="2"><div align="center" ><font color="#000066" size="5" face="Arial">Invoice Update Process</font></div></td>
    <tr  bgcolor="#99CCFF"> 
	  <td width="15%" height="40" ><div align="center" ><font color="#000066" size="4" face="Arial"><A>Original Invoice No</A></font></div></td> 
	  <td width="30%" nowrap> <div align="center"><font color="#0000FF" face="Arial" size="4"><%=tsInvoiceNo.toUpperCase()%></font></div></td>
    </tr>
    <tr bgcolor="#E8E8E8"> 
	  <td width="15%" height="40"  bgcolor="#E8E8E8" ><div align="center"><font face="Arial" color="#000066" size="4"><A>Update Invoice No</A></font></div></td> 
	  <td><div align="center">
        <input type="text" size="15" name="NEWTSINVOICENO" tabindex='4' maxlength="20" value="<%=newTsInvoiceNo%>" onKeyDown="setSubmit1a('../jsp/TSSHPInvoiceUpdateProcess.jsp')">
		<INPUT TYPE="button" name="CONFIRM" align="middle"  value="Update" onClick="setSubmit('../jsp/TSSHPInvoiceUpdateProcess.jsp')" >
      </div></td>	
   </tr>
  <tr><td colspan="2" height="30" align="center">
        <% if (setInvoice=="Y" || setInvoice.equals("Y")) { %>
        <input name="SUBMIT" type="button"  value="Return" onClick="setSubmit2('../jsp/TSSHPInvoiceNoUpdate.jsp?tsInvoiceNo=<%=newTsInvoiceNo%>')">
       <%} %>
        </td></tr>
</table> 

<input type="hidden" name="SETINVOICE"  maxlength="5" size="5" value="<%=setInvoice%>">
<input type="hidden" name="TSINVOICENO"  maxlength="5" size="5" value="<%=tsInvoiceNo%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
