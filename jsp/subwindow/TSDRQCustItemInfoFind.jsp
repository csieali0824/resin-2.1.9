<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
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
String customerID=request.getParameter("CUSTOMERID"); 
String invItemID=request.getParameter("INVITEMID");
String invItemDesc=request.getParameter("INVITEMDESC");
String dnDocNo=request.getParameter("DNDOCNO");
String lineNo=request.getParameter("LINENO");
String searchString=request.getParameter("SEARCHSTRING");
String PROGID=request.getParameter("PROGID");  //add by Peggy 20130604
if (PROGID==null) PROGID="";
 //String custItemNo=request.getParameter("CUSTITEMNO");
 try
 {
   if (searchString==null)
   {     	  
	  if (invItemDesc!=null) searchString = invItemDesc+"%"; // 若傳入台半料號說明,則以其為查詢依據
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
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(custItemNo,dnDocNo,lineNo,custItemID,custItemType)
{    
	window.opener.document.DISPLAYREPAIR.elements["CITEMDESC"+lineNo].value=custItemNo;
  	window.opener.document.DISPLAYREPAIR.elements["CITEMID"+lineNo].value=custItemID;
  	window.opener.document.DISPLAYREPAIR.elements["CITEMTYPE"+lineNo].value=custItemType;
  	this.window.close();  
}

</script>
<body>  
<FORM METHOD="post" ACTION="TSDRQCustItemInfoFind.jsp" NAME=CUSTFORM>
  <font size="-1"><jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgDesc"/><jsp:getProperty name="rPH" property="pgOR"/><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/>: 
  <input type="text" name="SEARCHSTRING" size=35 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="<jsp:getProperty name="rPH" property="pgQuery"/>"><BR>
  -----<jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgInformation"/>--------------------------------------------     
  <BR>
  <%  
	  // 為顯示說明考量,將語系先設為美國
     String sql_lang = ""; 
	  sql_lang="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
      PreparedStatement pstmt=con.prepareStatement(sql_lang);  
      pstmt=con.prepareStatement(sql_lang);
      pstmt.executeUpdate(); 
      pstmt.close();
	  //完成存檔後回復
  
      //String custItemNo=null;
      int queryCount = 0;
      Statement statement=con.createStatement();
	  try
      { 
	   //if (searchString=="")
	   if (searchString!="" && searchString!=null) 
	   {  	
  	      //CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	 	  CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
  	      cs1.setString(1,"41");
	      cs1.execute();

	     //out.println("1");
		 String sql = "";
		 String where =""; 
		 String order =	"";
		
				      sql = "select item_id, item Cust_Item, item_description, "+
					        "       item_identifier_type Item_Type,  "+
//                            "       decode(item_identifier_type, 'INT', (select meaning from oe_lookups where lookup_type='ITEM_IDENTIFIER_TYPE' and lookup_code = 'INT'),  "+
//							"                                    'CUST', (select meaning from oe_lookups where lookup_type = 'ITEM_IDENTIFIER_TYPE' and lookup_code = 'CUST'),  "+
                            "       decode(item_identifier_type, 'INT', 'Inventory Item Number', "+
							"                                    'CUST','Customer Item Number', "+
							" 						             item_identifier_type) Type_Meaning, Inventory_Item  "+
                            "  from oe_items_v  ";			                      														  
					  where = "where (to_char(sold_to_org_id) = '"+customerID+"' "+ 
					          "    or sold_to_org_id is null) "+     	
							  "  and nvl(cross_ref_status,'ACTIVE') <> 'INACTIVE' " +
							  //"  and to_char(inventory_item_id) ='"+invItemID+"' "+
					          //"  and item like '"+searchString+"%' ";
					          "  and (item like '"+searchString+"%' "+
							  "    or item_description like '"+searchString+"%') ";

					//  out.println("sql="+sql+where+order); 
                      if (!invItemID.equals("0")) where = where + "and to_char(INVENTORY_ITEM_ID) ='"+invItemID+"' ";


/*					  if (invItemID!=null) where = where + "and to_char(INVENTORY_ITEM_ID) ='"+invItemID+"' ";
				              					 													  
				      order = "order by CUSTOMER_ITEM_ID "; 
					  //out.println("sql="+sql+where+order); 
					  String sqlCNT = "select count(CUSTOMER_ITEM_ID) from MTL_CUSTOMER_ITEM_XREFS_V " + where;  
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close(); 
					// 若是 找不到任一筆資料,在找CROSS REFERENCE 內的資料  
					  if (queryCount==0)
					  {
					    sql = "select 'null', CROSS_REFERENCE, CROSS_REFERENCE_TYPE from MTL_CROSS_REFERENCES ";
						where = "where CROSS_REFERENCE_TYPE = 'Customer' and substr(CROSS_REFERENCE,1,1) <> ''''  ";
						if (invItemID!=null) where = where +"and to_char(INVENTORY_ITEM_ID) ='"+invItemID+"' ";
						order = "order by CROSS_REFERENCE ";
					  }
				*/  
				   
		 
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
		String custItemID=null,custItemNo=null,custItemDesc=null,custItemType=null,custItemTypeMeaning=null,invItemNo=null;
      		
        String buttonContent=null;
		String trBgColor = "YELLOW";
		
		// ??????????
		 custItemID="0";
		 custItemNo="N/A";
		 custItemDesc="N/A";
		 custItemType="INT";		
		 custItemTypeMeaning="N/A";
		 invItemNo="N/A";		  
		 out.println("<input type='hidden' name='CUSTITEMID' value='"+custItemID+"' >");
		 out.println("<input type='hidden' name='CUSTITEMNO' value='"+custItemNo+"' >");
		 out.println("<input type='hidden' name='CUSTITEMDESC' value='"+custItemDesc+"' >");		 
		 out.println("<input type='hidden' name='CUSTITEMTYPE' value='"+custItemType+"' >");
		 out.println("<input type='hidden' name='CUSTITEMTYPEMEANING' value='"+custItemTypeMeaning+"' >");
		 out.println("<input type='hidden' name='INVITEMNO' value='"+invItemNo+"' >");		 
		 buttonContent="this.value=sendToMainWindow("+'"'+custItemNo+'"'+","+'"'+dnDocNo+'"'+","+'"'+lineNo+'"'+","+'"'+custItemID+'"'+","+'"'+custItemType+'"'+")";		
         out.println("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%><jsp:getProperty name="rPH" property="pgFetch"/><%
		 out.println("' onClick='"+buttonContent+"'></TD>");	
		 out.println("<TD><FONT SIZE=2>");
		 %><jsp:getProperty name="rPH" property="pgAbortBefore"/><jsp:getProperty name="rPH" property="pgCustItemNo"/><jsp:getProperty name="rPH" property="pgSetup"/><BR><jsp:getProperty name="rPH" property="pgChoice"/><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgPart"/><%
		// out.println("</TD><TD><FONT SIZE=2>"+custItemNo+"</TD>");
		 out.println("</TD><TD><FONT SIZE=2>"+custItemDesc+"</TD>");
		 out.println("</TD><TD><FONT SIZE=2>"+custItemType+"</TD>");
		 out.println("</TD><TD><FONT SIZE=2>"+custItemTypeMeaning+"</TD>");		 
		 out.println("</TD><TD><FONT SIZE=2>"+invItemNo+"</TD>"); 		 
		 out.println("</TR>");	
		 
        while (rs.next())
        {		 
		 custItemID=rs.getString(1);
		 custItemNo=rs.getString(2);
		 custItemDesc=rs.getString(3);
		 custItemType=rs.getString(4);
		 custItemTypeMeaning=rs.getString(5);
		 invItemNo=rs.getString(6);
	 
		 out.println("<input type='hidden' name='CUSTITEMID' value='"+custItemID+"' >");
		 out.println("<input type='hidden' name='CUSTITEMNO' value='"+custItemNo+"' >");
		 out.println("<input type='hidden' name='CUSTITEMDESC' value='"+custItemDesc+"' >");		 
		 out.println("<input type='hidden' name='CUSTITEMTYPE' value='"+custItemType+"' >");
		 out.println("<input type='hidden' name='CUSTITEMTYPEMEANING' value='"+custItemTypeMeaning+"' >");
		 out.println("<input type='hidden' name='INVITEMNO' value='"+invItemNo+"' >");		 
		 		 
		 if (custItemNo==null) { trBgColor = "E3E3CF"; }
		 else if (custItemNo==rs.getString(2) || custItemNo.equals(rs.getString(2)))				 	 
		 { trBgColor = "FFCC66"; }
		 else { trBgColor = "E3E3CF"; }
		 buttonContent="this.value=sendToMainWindow("+'"'+custItemNo+'"'+","+'"'+dnDocNo+'"'+","+'"'+lineNo+'"'+","+'"'+custItemID+'"'+","+'"'+custItemType+'"'+")";		
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
	/*   
	    if (queryCount==1) //若取到的查詢數 == 1, 則直接傳回該筆資訊,並關閉視窗
	    {
	     //out.println("queryCount="+queryCount);
	     %>
		    <script LANGUAGE="JavaScript">	
				//window.opener.document.DISPLAYERREPAIR.CITEMDESC.value = document.CUSTFORM.CUSTITEMNO.value; 			
				window.opener.document.DISPLAYREPAIR.elements["CITEMDESC"+lineNo].value=document.CUSTFORM.CUSTITEMNO.value;	  
				this.window.close(); 
				
            </script>
		 <%
	    }
	*/   
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
	/*  
	  	  // 為顯示說明考量,將語系還原為TW
     // String sql_lang = ""; 
	  sql_lang="alter SESSION set NLS_LANGUAGE = 'TRADITIONAL CHINESE' ";     
      //PreparedStatement pstmt=con.prepareStatement(sql_lang);  
      pstmt=con.prepareStatement(sql_lang);
      pstmt.executeUpdate(); 
      pstmt.close();
	  //完成存檔後回復
	  */
     %>
  <BR>
<!--%表單參數%-->
<INPUT TYPE="hidden" NAME="CUSTOMERID" SIZE=10 value="<%=customerID%>" >
<INPUT TYPE="hidden" NAME="INVITEMID" SIZE=10 value="<%=invItemID%>" >
<INPUT TYPE="hidden" NAME="DNDOCNO" SIZE=20 value="<%=dnDocNo%>" >
<INPUT TYPE="hidden" NAME="LINENO" SIZE=10 value="<%=lineNo%>" >
<INPUT TYPE="hidden" NAME="PROGID" value="<%=PROGID%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->

<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
