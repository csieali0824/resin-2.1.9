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
 
 String subInventory=request.getParameter("SUBINVENTORY");
 String subInvDesc=request.getParameter("SUBINVDESC");
 String xINDEX=request.getParameter("XINDEX");
 
 
 
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
<title>Page for choose Deliver To Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(subInventory,subInvDesc,xINDEX)
{         
   formSUBINVENTORY_Write = "window.opener.document.MYFORM.SUBINVENTORY"+xINDEX+".value";	
   //alert(subInventory+"   "+subInvDesc+"   "+xINDEX);
   if (xINDEX!=null && xINDEX!="" && xINDEX!="null")     
   {   
	   window.opener.document.MYFORM.SUBINVENTORY<%=xINDEX%>.value=subInventory;
	    window.opener.document.MYFORM.SUBINVDESC<%=xINDEX%>.value=subInvDesc;
	   //alert(window.opener.document.getElementById("MYFORM.SUBINVENTORY"+xINDEX).value);
	   //alert(window.opener.document.getElementsByName('SUBINVENTORY')[<%=xINDEX%>].value);	   
	   //window.opener.document.getElementById("MYFORM.SUBINVENTORY"+xINDEX).value=subInventory;
   } else {
				          window.opener.document.MYFORM.SUBINVENTORY.value=subInventory;
						  window.opener.document.MYFORM.SUBINVDESC.value=subInvDesc;
		   }
  //window.opener.document.MYFORM.SUBINVENTORY.value=subInventory; 
  //window.opener.document.MYFORM.SUBINVDESC.value=subInvDesc;
  this.window.close();
}

</script>
<body>  
<FORM action="TSCSubInventoryFind.jsp" METHOD="post" NAME="SUBINVFORM">
  <font size="-1">Sub-Inventory名稱: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  <input type="hidden" name="XINDEX" value="<%=xINDEX%>">
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  -----Sub Inventory資訊--------------------------------------------     
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
	               if (organizationID!=null)  // 若有傳入Organization_ID
				   {
				      sql ="select ORGANIZATION_ID, SECONDARY_INVENTORY_NAME, DESCRIPTION "+		                  
						   "from MTL_SECONDARY_INVENTORIES ";						        		                      									  
					  where = "where ORGANIZATION_ID ='"+organizationID+"' ";					          		 													  
				      order = "order by SECONDARY_INVENTORY_NAME ";						 
					  
					  String sqlCNT = "select count(DISTINCT SECONDARY_INVENTORY_NAME) "+
					                    "from MTL_SECONDARY_INVENTORIES "+ where;       						 
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
				      sql ="select ORGANIZATION_ID, SECONDARY_INVENTORY_NAME, DESCRIPTION "+		                  
						   "from MTL_SECONDARY_INVENTORIES ";						        		                      									  
					  where = "where ORGANIZATION_ID ='"+organizationID+"' ";					          		 													  
				      order = "order by SECONDARY_INVENTORY_NAME "; 				  
					  
					  where = where + "and SECONDARY_INVENTORY_NAME like '"+searchString+"%' ";
					  
					  String sqlCNT = "select count(DISTINCT SECONDARY_INVENTORY_NAME) "+
					                    "from MTL_SECONDARY_INVENTORIES "+ where;       						 
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
        for (int i=2;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
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
		  subInventory=rs.getString(2);
		  subInvDesc=rs.getString(3);				 
		  out.println("<input type='hidden' name='SUBINVENTORY' value='"+subInventory+"' >");		 
		  out.println("<input type='hidden' name='SUBINVDESC' value='"+subInvDesc+"' >");		
		  buttonContent="this.value=sendToMainWindow("+'"'+subInventory+'"'+","+'"'+subInvDesc+'"'+","+'"'+xINDEX+'"'+")";	
		 }	 
			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD><INPUT TYPE=button NAME='button' VALUE='");%>帶入<%
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
	 
	   
	    if (queryCount==1) //若取到的查詢數 == 1, 則直接帶回原視窗
	    {
	        %>
		    <script LANGUAGE="JavaScript">	
			  //alert("TEST");		
			    formSUBINVENTORY_Write = "window.opener.document.MYFORM.SUBINVENTORY"+document.SUBINVFORM.XINDEX.value+".value";	
				if (document.SUBINVFORM.XINDEX.value!=null && document.SUBINVFORM.XINDEX.value!="")
				{
				  eval(formSUBINVENTORY_Write)=document.SUBINVFORM.SUBINVENTORY.value;
				} else {
				          window.opener.document.MYFORM.SUBINVENTORY.value=document.SUBINVFORM.SUBINVENTORY.value;
						}
                window.opener.document.MYFORM.SUBINVDESC.value=document.SUBINVFORM.SUBINVDESC.value; 					   	
				this.window.close(); 			  	
            </script>
		   <%
	     } // end of if (queryCount==1)	   
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
