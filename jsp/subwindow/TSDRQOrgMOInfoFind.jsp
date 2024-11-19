<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 String useCode=request.getParameter("USECODE");

 //String orgID=request.getParameter("ORGID");
 String organizationID=request.getParameter("ORGANIZATIONID");
 String searchString=request.getParameter("SEARCHSTRING");
 String custID=request.getParameter("CUSTID");
 String custPO=request.getParameter("CUSTPO");
 String orderTypeID=request.getParameter("ORDERTYPEID");
 String priceListID=request.getParameter("PRICELISTID");
 String rfqNo=request.getParameter("RFQNO");
 String xINDEX=request.getParameter("XINDEX");
 String orgMO=request.getParameter("ORGMO"); 
/* 
 out.println("custID="+custID);
 out.println("custPO="+custPO);
 out.println("orderTypeID="+orderTypeID);
 out.println("priceListID="+priceListID);
 out.println("orgMO="+orgMO);
*/ 
 //String subInventory="";
 
 //String moOtherInfo[]=new String[7]; // 宣告一維陣列,將其它設定資訊置入Array
 
 try
 {
   if (searchString==null)
   {     	  
	 searchString=""; 
   } 
    else {  //out.println("NULL input");
	     }
	
	/*
	  CallableStatement cs1 = con.prepareCall("{call DBMS_APPLICATION_INFO.SET_CLIENT_INFO(?)}");
	  cs1.setString(1,orgID);
	  cs1.execute();
      //out.println("Procedure : Execute Success !!! ");
      cs1.close();
    */
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose SubInv OnHand Qty Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(mfgFactory,orgMO,xINDEX)
{         
   
   if (xINDEX!=null && xINDEX!="" && xINDEX!="null")     
   {   
       //formSUBINVENTORY_Write = "window.opener.document.DISPLAYREPAIR.SUBINVENTORY"+xINDEX+".value";	
       //formONHANDQTY_Write = "window.opener.document.DISPLAYREPAIR.REINVQTY"+xINDEX+".value";
	   window.opener.document.DISPLAYREPAIR.MFGFACTORY<%=xINDEX%>.value=mfgFactory;
	   window.opener.document.DISPLAYREPAIR.ORGORDER<%=xINDEX%>.value=orgMO;	   
	   //alert(window.opener.document.getElementById("DISPLAYREPAIR.SUBINVENTORY"+xINDEX).value);	   	   
	   //window.opener.document.getElementById("DISPLAYREPAIR.SUBINVENTORY"+xINDEX).value=subInventory;
   } else {
              window.opener.document.DISPLAYREPAIR.MFGFACTORY.value=mfgFactory;
			  window.opener.document.DISPLAYREPAIR.ORGORDER.value=orgMO;
		   } 
  this.window.close();
}

</script>
<body>  
<FORM action="TSDRQOrgMOInfoFind.jsp" METHOD="post" NAME="SUBMOFORM">
  <font size="-1">MO Number: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  <input type="hidden" name="XINDEX" value="<%=xINDEX%>">
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  -----MO Information--------------------------------------------     
  <BR>
  <%  
      int queryCount = 0;
	 
      Statement statement=con.createStatement();
	  try
      { 
	     String sql = "";
		 String where =""; 
		 String order =	"";	
	   if (searchString=="" || searchString.equals(""))
	   {
	              
				      sql ="select DISTINCT OOH.ORDER_NUMBER, OOH.CUST_PO_NUMBER, OOL.PACKING_INSTRUCTIONS "+		                  
						   "from OE_ORDER_HEADERS_ALL OOH, OE_ORDER_LINES_ALL OOL ";						        		                      									  
					  where = "where OOH.HEADER_ID = OOL.HEADER_ID "+
					          "  and OOH.SOLD_TO_ORG_ID = "+custID+" "+
					          "  and ( OOH.CUST_PO_NUMBER = '"+custPO+"' or OOH.ATTRIBUTE10 = '"+rfqNo+"' ) "+
					          "  and OOH.ORDER_TYPE_ID = "+orderTypeID+" "+
							  "  and OOH.PRICE_LIST_ID = "+priceListID+" "+
							  "  and OOH.OPEN_FLAG = 'Y' and OOH.BOOKED_FLAG = 'N' ";							 					          		 													  
				      order = "order by OOH.ORDER_NUMBER ";							 
					  
					  String sqlCNT = "select count(OOH.ORDER_NUMBER) "+
					                  "from OE_ORDER_HEADERS_ALL OOH, OE_ORDER_LINES_ALL OOL "+ where;     						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				 
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        
				 
				      sql ="select DISTINCT OOH.ORDER_NUMBER, OOH.CUST_PO_NUMBER, OOL.PACKING_INSTRUCTIONS "+		                  
						   "from OE_ORDER_HEADERS_ALL OOH, OE_ORDER_LINES_ALL OOL ";						        		                      									  
					  where = "where OOH.HEADER_ID = OOL.HEADER_ID "+
					          "  and OOH.SOLD_TO_ORG_ID = "+custID+" "+
					          "  and ( OOH.CUST_PO_NUMBER = '"+custPO+"' or OOH.ATTRIBUTE10 = '"+rfqNo+"' ) "+
					          "  and OOH.ORDER_TYPE_ID = "+orderTypeID+" "+
							  "  and OOH.PRICE_LIST_ID = "+priceListID+" "+
							  "  and OOH.OPEN_FLAG = 'Y' and OOH.BOOKED_FLAG = 'N' ";							 					          		 													  
				      order = "order by OOH.ORDER_NUMBER ";				  
					  
					  where = where + "and OOH.ORDER_NUMBER like ( '"+searchString+"%' or  '"+orgMO+"%' ) ";
					  
					  String sqlCNT = "select count(OOH.ORDER_NUMBER) "+
					                  "from OE_ORDER_HEADERS_ALL OOH, OE_ORDER_LINES_ALL OOL "+ where;       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				  
	   }//end of else if ( searchString!=null && !searchString.equals("") )  
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
        for (int i=1;i<=colCount;i++) // 不顯示第1(原MO生產地)欄資料, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
		
        out.println("</TR>");
		//out.println("2="+"<BR>");
		String onHandQty=null;
      	String mfgFactory="";	
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {			 
		  trBgColor = "E3E3CF";
		  //out.println("Step0");		 
		  mfgFactory=rs.getString(3);
		  orgMO=rs.getString(1);
		  //subInvDesc=rs.getString(3);	 
		  
		  out.println("<input type='hidden' name='MFGFACTORY' value='"+mfgFactory+"' >");				 
		  out.println("<input type='hidden' name='ORDERNO' value='"+orgMO+"' >");		  	  
		  buttonContent="this.value=sendToMainWindow("+'"'+mfgFactory+'"'+","+'"'+orgMO+'"'+")";	
		 			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%>Add<%
		 out.println("' onClick='"+buttonContent+"'></TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第1(原MO生產地)欄資料, 故 for 由 2開始
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for		  
         out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       	 
	   
	    if (queryCount==1) //若取到的查詢數 == 1, 則直接帶回原視窗
	    {
	        %>
		    <script LANGUAGE="JavaScript">	
			  //alert("TEST");		
			    	
				if (document.SUBINVFORM.XINDEX.value!=null && document.SUBINVFORM.XINDEX.value!="")
				{
				  formMFGFACTORY_Write = "window.opener.document.DISPLAYREPAIR.MFGFACTORY"+document.SUBMOFORM.XINDEX+".value";	
				  formORGORDER_Write = "window.opener.document.DISPLAYREPAIR.ORGORDER"+document.SUBMOFORM.XINDEX+".value";
				  eval(formMFGFACTORY_Write)=document.SUBMOFORM.MFGFACTORY.value;					  
				  eval(formORGORDER_Write)=document.SUBMOFORM.ORDERNO.value;				  
				} else {
				          window.opener.document.DISPLAYREPAIR.MFGFACTORY.value=document.SUBMOFORM.MFGFACTORY.value;
				          window.opener.document.DISPLAYREPAIR.ORGORDER.value=document.SUBMOFORM.ORDERNO.value;
						}                					   	
				this.window.close(); 			  	
            </script>
		   <%
	     } // end of if (queryCount==1)			   
		 else if (queryCount==0)   
		      {
			     %>
		          <script LANGUAGE="JavaScript">			 
				   alert("No MO be created for this Customer Purchase Order!!!");          					   	
				   //this.window.close(); 			  	
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
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
