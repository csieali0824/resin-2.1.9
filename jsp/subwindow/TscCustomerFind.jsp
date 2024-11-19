<%@ page language="java" import="java.sql.*,java.net.*,java.io.*"%>
<!--=============???????????==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
 
<%
// String primaryFlag=request.getParameter(java.net.URLDecoder.decode("PRIMARYFLAG"));
 // java.net.URLDecoder.decode(PRIMARYFLAG)
// String line_no=request.getParameter("line_no");
 //String inventory_Item_ID=request.getParameter("inventory_Item_ID");
 //String customerPO=request.getParameter("customerPO");
 //String keyID=request.getParameter("ID");
 //String searchString=request.getParameter("SEARCHSTRING");
 //out.println("line_no="+line_no+"<br>");
 // out.println("customerPO="+customerPO+"<br>");
 //  out.println("primaryFlag="+primaryFlag+"<br>");
  String searchString=request.getParameter("SEARCHSTRING");
  String keyID=request.getParameter("ID");
 
  String c_Cust_Account_ID = "";
  String c_Customer_Number = "";
  String c_Customer_Name = "";
  String c_Party_Number = "";
  String c_Payterm_ID ="";
  String c_BillToID ="";
  String c_Currency_Code ="";
  String c_Price_List_ID= "";
  String c_ShipToID = ""; //20110323 add by Peggychen
 

   
   //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO('41')}");
  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', '41')}");
   //cs1.setString(1,userParOrgID);  // 取業務員隸屬ParOrgID
   cs1.execute();
   //out.println("Procedure : Execute Success !!! ");
    cs1.close();
 
 

  
  
%>
<html>
<head>
<title> </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
 
//function setSubmit(primaryFlag,customerPO,line_no) 
//{    
 // subWin=window.opener( );  
//}
function setSubmit(URL)
{  
  //alert(document.DISPLAYREPAIR.CHKFLAG.length); 
    //chkFlag="TURE";   
 //var linkURL = "#test";
 //alert(linkURL);
 window.opener.document.form1.action=URL;
 window.opener.document.form1.submit(); 
 this.window.close();
}
</script>
<body >  
<FORM METHOD="post" name ="form1" action="TscCustomerFind.jsp?">
<TD ><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003399" size="+2" face="Arial Black">TSC</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> <strong> Customer Name Select :</strong></font></TD>
<br>
 
<%
 //out.println("<input type='submit' name='Submit' value='complete' onClick='setCreate("+'"'+"TscProductFind.jsp?PRIMARYFLAG="+new+"&customerPO="+customerPO+"&line_no="+line_no+'"'+")'>");
%>

      <%  
       Statement statement=con.createStatement();
	   //primaryFlag = java.net.URLDecoder.decode(primaryFlag);
	   //out.println("A"+primaryFlag+"A");
	   out.println("<table width='580' border='1' align='left' cellpadding='0' cellspacing='1' bordercolor='#3399CC'>");
	   out.println("<tr bgcolor='#EEEEEE'>");
	   out.println("<td width='10'><font size='2'>&nbsp;</font></td>");
	   out.println("<td width='50'><font size='2'>客戶代碼</font></td>");
	   out.println("<td width='50'><font size='2'>客戶編號</font></td>");
	   out.println("<td width='270'><font size='2'>客戶名稱</font></td>");
	   out.println("<td width='50'><font size='2'>幣別</font></td>");
	   out.println("<td width='50'><font size='2'>Payment_ID</font></td>");
	   out.println("<td width='50'><font size='2'>立帳編號</font></td>");
	   out.println("</tr>");
	   //out.println(searchString);
 
	   
	   
			try{ 
				 String sql = 	" SELECT a.CUST_ACCOUNT_ID  , c.party_number  ,  "+
                   			    " c.CUSTOMER_NAME  ,b.attribute1 , b.SITE_USE_CODE ,b.SITE_USE_ID  ,"+  
                    		    " e.payment_term_id   ,b.price_list_id "+
								",NVL(d.CURRENCY_CODE ,e.CURRENCY_CODE) CURRENCY_CODE"+ //modify by Peggy 20120313
								",e.site_use_code bill_use_code,e.site_use_id bill_use_id"+
								//"  from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b, APPS.AR_CUSTOMERS c  , qp_list_headers_v  d ,"+
								" from APPS.HZ_CUST_ACCT_SITES_ALL a, AR.HZ_CUST_SITE_USES_ALL b"+
								", (SELECT cust.CUST_ACCOUNT_ID customer_id, substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
                                " cust.ACCOUNT_NUMBER customer_number,party.party_id, party.party_number,"+
                                " cust.orig_system_reference,cust.price_list_id  FROM  hz_cust_accounts cust, hz_parties party"+
                                " WHERE cust.party_id = party.party_id ) c ,"+
								//" qp_list_headers_v  d ,"+
								"(select LIST_HEADER_ID,CURRENCY_CODE from qp_list_headers_v  where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' ) d,"+ //modify by Peggy 20120313
								" (select c1.CUSTOMER_ID CUSTOMER_ID ,b1.payment_term_id payment_term_id ,c1.CUSTOMER_NAME CUSTOMER_NAME  "+
								",  b1.site_use_id ,b1.site_use_code "+
								", d1.CURRENCY_CODE"+ //add by Peggy 20120313
								//"  from APPS.HZ_CUST_ACCT_SITES_ALL a1, AR.HZ_CUST_SITE_USES_ALL b1, APPS.AR_CUSTOMERS c1    "+	
								"  from APPS.HZ_CUST_ACCT_SITES_ALL a1, AR.HZ_CUST_SITE_USES_ALL b1,"+
								"  (SELECT cust.CUST_ACCOUNT_ID customer_id, substrb(PARTY.PARTY_NAME,1,50) CUSTOMER_NAME,"+
                                "  cust.ACCOUNT_NUMBER customer_number,party.party_id, party.party_number,"+
                                "  cust.orig_system_reference,cust.price_list_id  FROM  hz_cust_accounts cust, hz_parties party"+
                                "  WHERE cust.party_id = party.party_id ) c1    "+	
								" ,(select LIST_HEADER_ID,CURRENCY_CODE from qp_list_headers_v  where ACTIVE_FLAG = 'Y' and TO_CHAR(LIST_HEADER_ID) > '0' ) d1 "+ //modify by Peggy 20120313
								" 	where a1.CUST_ACCT_SITE_ID = b1.CUST_ACCT_SITE_ID "+
								"   and  b1.attribute1 in 1 "+
							    "	and a1.STATUS = 'A' "+
								"   and a1.STATUS = b1.STATUS "+
								"   and a1.ORG_ID = b1.ORG_ID "+  		
							    "	and a1.ORG_ID ='41' "+
								"   and a1.CUST_ACCOUNT_ID = c1.CUSTOMER_ID  "+ 
								"	and b1.SITE_USE_CODE ='BILL_TO'  "+
								"   and b1.price_list_id =d1.LIST_HEADER_ID(+)"+
							    "	and b1.primary_flag ='Y' order by c1.customer_name ) e  "+                        
							    "	where a.CUST_ACCT_SITE_ID = b.CUST_ACCT_SITE_ID  "+   
							    "	and a.STATUS = 'A' and a.STATUS = b.STATUS and a.ORG_ID = b.ORG_ID  "+
								"	and e.CUSTOMER_ID = c.CUSTOMER_ID "+		
							    "	and a.ORG_ID ='41' and a.CUST_ACCOUNT_ID = c.CUSTOMER_ID  "+ 
							    "	and (b.SITE_USE_CODE ='SHIP_TO')"+
							    "   and b.price_list_id =d.LIST_HEADER_ID(+) "+ //modify by Peggy 20120312
								"	and b.primary_flag ='Y' order by c.customer_name ";  
									
								 
			   //out.println(sql);
				 
				ResultSet rs=statement.executeQuery(sql);	
				//out.println("sql12="+sql);
				if(rs!=null){
					while(rs.next()){
							c_Cust_Account_ID = rs.getString("CUST_ACCOUNT_ID");
							c_Party_Number = rs.getString("party_number");
							//c_Customer_Number = rs.getString("CUSTOMER_NUMBER");
							c_Customer_Name = rs.getString("CUSTOMER_NAME");
							c_Payterm_ID = rs.getString("payment_term_id");
						    //c_BillToID = rs.getString("SITE_USE_ID");
							c_ShipToID = rs.getString("SITE_USE_ID");  //add
							c_Currency_Code = rs.getString("CURRENCY_CODE");
							c_Price_List_ID =  rs.getString("price_list_id");
							if (c_Price_List_ID == null) c_Price_List_ID="";
							c_BillToID = rs.getString("BILL_USE_ID");
							
							out.println("<tr bgcolor='#E6FFE6'>");
							// 20110224 Marvie Update : keyID have special characters , space , plus ...
							//out.println("<td><input type='button' value='Set'  onClick='setSubmit("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+keyID+"&c_Cust_Account_ID="+c_Cust_Account_ID+"&c_Party_Number="+c_Party_Number+"&c_Customer_Name="+c_Customer_Name.replaceAll("&","FUCK")+"&c_Payterm_ID="+c_Payterm_ID+"&c_BillToID="+c_BillToID+"&c_Currency_Code="+c_Currency_Code+"&c_Price_List_ID="+c_Price_List_ID+'"'+")' ></td>");
							//out.println("../jsp/Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID)+"&c_Cust_Account_ID="+c_Cust_Account_ID+"&c_Party_Number="+c_Party_Number+"&c_Customer_Name="+c_Customer_Name.replaceAll("&","FUCK")+"&c_Payterm_ID="+c_Payterm_ID+"&c_BillToID="+c_BillToID+"&c_Currency_Code="+c_Currency_Code+"&c_Price_List_ID="+c_Price_List_ID+"&c_ShipToID="+c_ShipToID+'"');
							out.println("<td><input type='button' value='Set'  onClick='setSubmit("+'"'+"../jsp/Tsc1211ConfirmDetailList.jsp?ID="+java.net.URLEncoder.encode(keyID)+"&c_Cust_Account_ID="+c_Cust_Account_ID+"&c_Party_Number="+c_Party_Number+"&c_Customer_Name="+c_Customer_Name.replaceAll("&","FUCK")+"&c_Payterm_ID="+c_Payterm_ID+"&c_BillToID="+c_BillToID+"&c_Currency_Code="+c_Currency_Code+"&c_Price_List_ID="+c_Price_List_ID+"&c_ShipToID="+c_ShipToID+'"'+")' ></td>");
							out.println("<td><div align='right'><font size='2'>"+c_Cust_Account_ID+"</font></div></td>");
							out.println("<td><div align='right'><font size='2'>"+c_Party_Number+"</font></div></td>");
							out.println("<td><div align='left'><font size='2'>"+c_Customer_Name+"</font></div></td>");
							out.println("<td><div align='right'><font size='2'>"+c_Currency_Code+"</font></div></td>");
							out.println("<td><div align='right'><font size='2'>"+c_Payterm_ID+"</font></div></td>");
							out.println("<td><div align='left'><font size='2'>"+c_BillToID+"</font></div></td>");
							out.println("</tr>");
					}
				}else{
							out.println("<tr bgcolor='#E6FFE6'>");
							out.println("<td colspan='6'><div align='center'><font size='2'>No Data !!</font></div></td>");
							out.println("</tr>");
				}
			}catch (Exception e){
				out.println("Exception:"+e.getMessage());}
	      
 	out.println("</table>");
     %>
      <BR>
 
    
    </p>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
