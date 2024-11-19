<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 String useCode=request.getParameter("USECODE");

 String primaryItemID=request.getParameter("PRIMARYITEMID");
 String organizationID=request.getParameter("ORGANIZATIONID");
 String searchString=request.getParameter("SEARCHSTRING");
 
 String routingRefID=request.getParameter("ROUTINGREFID");
 String altRoutingDest=request.getParameter("ALTROUTINGDEST");
 
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
<title>Page for choose Bom Routing Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(routingRefID,altRoutingDest)
{         
  window.opener.document.DISPLAYREPAIR.ROUTINGREFID.value=routingRefID; 
  window.opener.document.DISPLAYREPAIR.ALTROUTINGDEST.value=altRoutingDest;
  this.window.close();
}

</script>
<body>  
<FORM action="TSMfgBomRoutingFind.jsp" METHOD="post" NAME="SUBINVFORM">
  <font size="-1">Bom Routing 成品料號: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  -----Bom Routing資訊--------------------------------------------     
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
	   { //out.println("0="+organizationID);
	               if (organizationID!=null)  // 若有傳入Organization_ID
				   {
				      sql ="select a.ROUTING_SEQUENCE_ID, a.ALTERNATE_ROUTING_DESIGNATOR, b.DESCRIPTION as ASSEMBLY_ITEM_DESC "+		                  
						   "from BOM_OPERATIONAL_ROUTINGS a, MTL_SYSTEM_ITEMS b ";						        		                      									  
					  where = "where a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
					          "  and a.ORGANIZATION_ID ='"+organizationID+"' "+
							  "  and a.ASSEMBLY_ITEM_ID = b.INVENTORY_ITEM_ID ";
					  // if (routingRefID!=null) where = where + " and a.ROUTING_SEQUENCE_ID = '"+routingRefID+"' ";	
					  if (primaryItemID!=null) where = where + " and a.ASSEMBLY_ITEM_ID = '"+primaryItemID+"' ";
					   				          		 													  
				      order = "order by a.ROUTING_SEQUENCE_ID ";						 
					  
					  String sqlCNT = "select count(DISTINCT a.ROUTING_SEQUENCE_ID) "+
					                    "from BOM_OPERATIONAL_ROUTINGS a, MTL_SYSTEM_ITEMS b "+ where;       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				   }	
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        
				   if (organizationID!=null)  // 若有傳入Organization_ID
				   {
				      sql ="select a.ROUTING_SEQUENCE_ID, a.ALTERNATE_ROUTING_DESIGNATOR, b.DESCRIPTION as ASSEMBLY_ITEM_DESC "+		                  
						   "from BOM_OPERATIONAL_ROUTINGS a, MTL_SYSTEM_ITEMS b ";						        		                      									  
					  where = "where a.ORGANIZATION_ID = b.ORGANIZATION_ID "+
					          "  and a.ORGANIZATION_ID ='"+organizationID+"' "+
							  "  and a.ASSEMBLY_ITEM_ID = b.INVENTORY_ITEM_ID "+
							  "  and a.ROUTING_SEQUENCE_ID = '"+routingRefID+"' ";
					  // if (routingRefID!=null) where = where + " and a.ROUTING_SEQUENCE_ID = '"+routingRefID+"' ";	
					  if (primaryItemID!=null) where = where + " and a.ASSEMBLY_ITEM_ID = '"+primaryItemID+"' ";					 
					   				          		 													  
				      order = "order by a.ROUTING_SEQUENCE_ID ";					  
					  
					  
					 String sqlCNT = "select count(DISTINCT a.ROUTING_SEQUENCE_ID) "+
					                    "from BOM_OPERATIONAL_ROUTINGS a, MTL_SYSTEM_ITEMS b "+ where;        						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				   }	
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
        for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		//out.println("2="+"<BR>");
		//String subInventory=null,subInvDesc=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {			 
		 trBgColor = "E3E3CF";
		 //out.println("Step0");		 
		 if (organizationID!=null)
		 {  
		  routingRefID=rs.getString(1);
		  altRoutingDest=rs.getString(2);	
		  if (altRoutingDest==null || altRoutingDest.equals("")) altRoutingDest = "";
		  			 
		  out.println("<input type='hidden' name='ROUTINGREFID' value='"+routingRefID+"' >");		 
		  out.println("<input type='hidden' name='ALTROUTINGDEST' value='"+altRoutingDest+"' >");		
		  //buttonContent="this.value=sendToMainWindow("+'"'+subInventory+'"'+","+'"'+subInvDesc+'"'+")";	
		 }	 
			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD>");
		 //<INPUT TYPE=button NAME='button' VALUE='");
		 %>
         <INPUT TYPE=button NAME='button' VALUE='帶入' onClick='sendToMainWindow("<%=routingRefID%>","<%=altRoutingDest%>")'>
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
	 
	   
	    if (queryCount==1) //若取到的查詢數 == 1, 則直接帶回原視窗
	    {
	        %>
		    <script LANGUAGE="JavaScript">	
			  //alert("TEST");			
				window.opener.document.DISPLAYREPAIR.ROUTINGREFID.value=document.SUBINVFORM.ROUTINGREFID.value;
                window.opener.document.DISPLAYREPAIR.ALTROUTINGDEST.value=document.SUBINVFORM.ALTROUTINGDEST.value; 					   	
				//this.window.close(); 			  	
            </script>
		   <%
	     } // end of if (queryCount==1)	   
		 else if (queryCount==0)
		      {   
			      %>
		         <script LANGUAGE="JavaScript">	
			       alert("Routing does not exist for this assembly");			 			  	
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
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
