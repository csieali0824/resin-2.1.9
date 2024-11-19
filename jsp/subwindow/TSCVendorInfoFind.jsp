<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 
 String organizationID=request.getParameter("ORGANIZATIONID");
 String searchString=request.getParameter("SEARCHSTRING");
 
 String supplyVndID=request.getParameter("SUPPLVNDID");
 String supplyVndNo=request.getParameter("SUPPLVNDNO");
 String supplyVnd=request.getParameter("SUPPLYVND");
 
 //String subInventory=""; 
 
   
 try
 {
   if (searchString==null || searchString.equals(""))
   {     	  
	 searchString=""; 
	 
	 if ((supplyVndNo==null || supplyVndNo.equals("")) && (supplyVnd==null || supplyVnd.equals("")))
	 {
	  %>
	  <script language="javascript">
	    function checkSearchStr()
		{
	      flag=confirm("未輸入任何查詢關鍵字,可能會需要較久時間 \n 確定嗎?");
		  if (flag==false)
		  { 
		    alert("請於欄位內輸入查詢關鍵字查詢!");
		    return (false);
		  } 
		} 
	  </script>
	 <%
	 } else {
	            if (supplyVndNo!=null && !supplyVndNo.equals(""))  searchString = supplyVndNo;
				else searchString = supplyVnd;
	 
	        }
   } 
    else {  //out.println("NULL input");
	     }
	
	
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose Supplier Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(supplyID,supplyNo,supplyName)
{         
  window.opener.document.MYFORM.SUPPLYVNDID.value=supplyID; 
  window.opener.document.MYFORM.SUPPLYVNDNO.value=supplyNo;
  window.opener.document.MYFORM.SUPPLYVND.value=supplyName;  
  this.window.close();
}

</script>
<body>  
<FORM action="TSCVendorInfoFind.jsp" METHOD="post" NAME="SUBVNDFORM">
  <font size="-1">供應商代號、供應商名稱: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  -----供應商資訊--------------------------------------------     
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
	              
				      sql ="select VENDOR_ID, SEGMENT1, REPLACE(VENDOR_NAME,'\''',' ') as VENDOR_NAME "+		                  
						   //"from PO.PO_VENDORS ";		
						   "from APPS.PO_VENDORS ";	 //modify by Peggy 20111223			        		                      									  
					  where = "where VENDOR_ID is not null ";					          		 													  
				      order = "order by VENDOR_ID "; 				  
					  String sqlCNT = "select count(VENDOR_ID) "+
					                    //"from PO.PO_VENDORS "+ where;       						 
										"from APPS.PO_VENDORS "+ where;   //modify by Peggy 20111223		   						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				   	
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        
				   
				      sql ="select VENDOR_ID, SEGMENT1, REPLACE(VENDOR_NAME,'\''',' ') as VENDOR_NAME "+		                  
						   //"from PO.PO_VENDORS ";	
						   "from APPS.PO_VENDORS ";	 //modify by Peggy 20111223							        		                      									  
					  where = "where (SEGMENT1 like '"+searchString+"%' or VENDOR_NAME like '"+searchString+"%') ";					          		 													  
				      order = "order by VENDOR_ID "; 				  
					  
					  //where = where + "and SECONDARY_INVENTORY_NAME like '"+searchString+"%' ";
					  
					  String sqlCNT = "select count(VENDOR_ID) "+
					                   // "from PO.PO_VENDORS "+ where; 
									   "from APPS.PO_VENDORS "+ where;   //modify by Peggy 20111223      						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();
					  //out.println(sqlCNT); 				                    
				 
	   }//end of else if ( searchString!=null && !searchString.equals("") )  
		sql = sql + where + order;
		//out.println("sql="+sql); 
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
		//out.println("2="+"<BR>");
		//String subInventory=null,subInvDesc=null;
      		
        String buttonContent=null;
		String trBgColor = "";
        while (rs.next())
        {			 
		 trBgColor = "E3E3CF";
		 //out.println("Step0");		 
		 
		  supplyVndID=rs.getString(1);
		  supplyVndNo=rs.getString(2);
		  supplyVnd=rs.getString(3);				 
		  out.println("<input type='hidden' name='SUPPLYVNDID' value='"+supplyVndID+"' >");		 
		  out.println("<input type='hidden' name='SUPPLYVNDNO' value='"+supplyVndNo+"' >");
		  out.println("<input type='hidden' name='SUPPLYVND' value='"+supplyVnd+"' >");	
		  //buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";	
		  
		 // buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";	
		 	 			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD>");
		 %><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='this.value=sendToMainWindow("<%=supplyVndID%>","<%=supplyVndNo%>","<%=supplyVnd%>")'><%
		 out.println("</TD>");		
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
			    window.opener.document.MYFORM.SUPPLYVNDID.value=document.SUBVNDFORM.SUPPLYVNDID.value; 
                window.opener.document.MYFORM.SUPPLYVNDNO.value=document.SUBVNDFORM.SUPPLYVNDNO.value; 
                window.opener.document.MYFORM.SUPPLYVND.value=document.SUBVNDFORM.SUBINVDESC.value;  						   	
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
