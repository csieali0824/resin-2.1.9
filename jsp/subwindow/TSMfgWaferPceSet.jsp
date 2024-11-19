<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.math.BigDecimal,java.text.DecimalFormat"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 String useCode=request.getParameter("USECODE");

 String woQty=request.getParameter("WOQTY");
 String waferLot=request.getParameter("WAFERLOT");
 String organizationID=request.getParameter("ORGANIZATIONID");
 
 String searchString=request.getParameter("SEARCHSTRING");
 
 String altBomSeqID=request.getParameter("ALTBOMSEQID");
 String altBomDest=request.getParameter("ALTBOMDEST");
 String altDesc=request.getParameter("ALTERNATE_DESC");
 String waferUsedPce="";

 
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
<title>Page for wafer used pce</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(woQty,waferUsedPce)
{         
 // window.opener.document.MYFORM.WOQTY.value=woQty; 
  window.opener.document.MYFORM.WAFERUSEDPCE.value=waferUsedPce;
  this.window.close();
}

</script>
<body>  
<FORM action="TSMfgWaferPceSet.jsp" METHOD="post" NAME="SUBINVFORM">
 
  -----下線片數--------------------------------------------     
  <BR>
  <%  
      int queryCount = 0;
	  float waferused= 0;
	  java.text.DecimalFormat nf = new java.text.DecimalFormat("###,##0.000"); // 取小數後三位
      Statement statement=con.createStatement();
	  try
      { 
	     String sql = "",sfrom="";
		 String where =""; 
		 String order =	"";	
		 String inQty="",outQty,transRate="";
		 
		 
	   if (searchString=="" || searchString.equals(""))
	   { //out.println("0="+organizationID);
	               if (organizationID!=null)  // 若有傳入Organization_ID
				   {
					   				          		 													  
			    	       sql = " SELECT TransOut.PRIMARY_QUANTITY OUTQTY,TransIn.PRIMARY_QUANTITY INQTY, "+
     							 " 		  round(abs(transin.primary_quantity) / abs(transout.primary_quantity),2) rate ";
 						 sfrom = "   FROM "+
								 "     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
    							 "         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
  								 "        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
    	 						 "											 WHERE A.ORGANIZATION_ID="+organizationID+"  AND A.SEGMENT1='重分轉出' ) "+ 
     							 "          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID= "+organizationID+" "+
     							 "          AND MTL.LOT_NUMBER='"+waferLot+"' ) TransOut , "+
								 "     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
    							 "         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
  								 "        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
    	 						 "	                                         WHERE A.ORGANIZATION_ID="+organizationID+"  AND A.SEGMENT1='重分轉入' ) "+
     							 "          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID="+organizationID+" "+
     							 "		    AND MTL.LOT_NUMBER='"+waferLot+"' ) TransIn ";
						where =  "   WHERE TransOut.TRANSACTION_REFERENCE=TransIn.TRANSACTION_REFERENCE "+
								 "     AND TransOut.LOT_NUMBER=TransIn.LOT_NUMBER ";
					  
					  String sqlCNT = "select count(*) "+sfrom+ where;
					  //out.print("a.sqlCNT="+sqlCNT);	
					  				       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					 // out.println(sqlCNT); 	
					 //  out.println("queryCount="+queryCount);			                    
				   }	
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        
				   if (organizationID!=null)  // 若有傳入Organization_ID
				   {
			    	       sql = " SELECT TransOut.PRIMARY_QUANTITY OUTQTY,TransIn.PRIMARY_QUANTITY INQTY, "+
     							 " 		  round(abs(transin.primary_quantity) / abs(transout.primary_quantity),2) rate ";
 						 sfrom = "   FROM "+
								 "     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
    							 "         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
  								 "        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
    	 						 "											 WHERE A.ORGANIZATION_ID="+organizationID+"  AND A.SEGMENT1='重分轉出' ) "+ 
     							 "          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID= "+organizationID+" "+
     							 "          AND MTL.LOT_NUMBER='"+waferLot+"' ) TransOut , "+
								 "     ( SELECT MTL.TRANSACTION_ID,MTL.PRIMARY_QUANTITY ,MMT.TRANSACTION_REFERENCE,MTL.LOT_NUMBER "+
    							 "         FROM MTL_TRANSACTION_LOT_NUMBERS MTL,MTL_MATERIAL_TRANSACTIONS MMT "+
  								 "        WHERE MTL.TRANSACTION_SOURCE_ID=( SELECT A.DISPOSITION_ID FROM MTL_GENERIC_DISPOSITIONS A  "+
    	 						 "	                                         WHERE A.ORGANIZATION_ID="+organizationID+"  AND A.SEGMENT1='重分轉入' ) "+
     							 "          AND MTL.TRANSACTION_ID=MMT.TRANSACTION_ID AND MTL.ORGANIZATION_ID="+organizationID+" "+
     							 "		    AND MTL.LOT_NUMBER='"+waferLot+"' ) TransIn ";
						where =  "   WHERE TransOut.TRANSACTION_REFERENCE=TransIn.TRANSACTION_REFERENCE "+
								 "     AND TransOut.LOT_NUMBER=TransIn.LOT_NUMBER ";
					  
					  
					 String sqlCNT = "select count(*) "+sfrom+ where;      						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  //out.print("b.sqlCNT="+sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				   }	
	   }//end of else if ( searchString!=null && !searchString.equals("") )  
		sql = sql +sfrom+ where ;
		//out.println("sql="+sql); 
        ResultSet rs=statement.executeQuery(sql);
		//out.println("sql="+sql);       		
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
 		//String subInventory=null,subInvDesc=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        if (rs.next())
        {			 
		    trBgColor = "E3E3CF";
 		 if (organizationID!=null)
		 { 
		    outQty=rs.getString(1);
 		    inQty=rs.getString(2);
 		    transRate=rs.getString(3);
    	     //waferUsedPce=String.valueOf(Float.parseFloat(woQty)*rs.getFloat(3));
			waferused= Float.parseFloat(woQty)*rs.getFloat(3);
			
			//計算下線片數,四捨五入
			String strWaferQty = nf.format(waferused);
			java.math.BigDecimal bd = new java.math.BigDecimal(strWaferQty);
			java.math.BigDecimal waferUsedPceq = bd.setScale(3, java.math.BigDecimal.ROUND_HALF_UP);
			waferUsedPce = String.valueOf(waferUsedPceq.floatValue());
			
		  out.println("<input type='hidden' name='OUTQTY' value='"+outQty+"' >");		 
		  out.println("<input type='hidden' name='INQTY' value='"+inQty+"' >");	
		  out.println("<input type='hidden' name='TRANSRATE' value='"+transRate+"' >");	
 		  //buttonContent="this.value=sendToMainWindow("+'"'+subInventory+'"'+","+'"'+subInvDesc+'"'+")";	
		 }	 
		  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD>");
		 //<INPUT TYPE=button NAME='button' VALUE='");
		 %>
         <INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=woQty%>","<%=waferUsedPce%>")'>
		 <input name="WAFERUSEDPCE" type="hidden" value="<%=waferUsedPce%>" >
         <%
		 
		 out.print("</TD>");		
         for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 1開始
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
          out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	 
	   out.print("<br>下線片數="+waferUsedPce);
	    if (queryCount==1) //若取到的查詢數 == 1, 則直接帶回原視窗
	    {
	        %>
		    <script LANGUAGE="JavaScript">	
			  //alert("TEST");			
				//window.opener.document.MYFORM.WOQTY.value=document.SUBINVFORM.WOQTY.value;
                window.opener.document.MYFORM.WAFERUSEDPCE.value=document.SUBINVFORM.WAFERUSEDPCE.value; 
				this.window.close(); 			  	
            </script>
		   <%
	     } // end of if (queryCount==1)	   
		 else if (queryCount==0)
		      {   
			      %>
		         <script LANGUAGE="JavaScript">	
			       alert("查無此批號轉出/轉入數!!");			 			  	
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
<input name="ORGANIZATIONID" type="hidden" value="<%=organizationID%>" > 
<input name="WOQTY" type="hidden" value="<%=woQty%>" >

</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
