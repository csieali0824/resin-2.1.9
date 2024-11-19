<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 
 String organizationID=request.getParameter("ORGANIZATIONID");
 String searchString=request.getParameter("SEARCHSTRING");
 
 String jobOrRunCard=request.getParameter("JOBORRUNCARD"); 
 String statusId=request.getParameter("STATUSID"); 
 //String subInventory="";  
   
 try
 {
   if (searchString==null || searchString.equals(""))
   {     	  
	 searchString=""; 
	 
	 if ( (jobOrRunCard==null || jobOrRunCard.equals("") ) )
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
	            if (jobOrRunCard!=null && !jobOrRunCard.equals(""))  searchString = jobOrRunCard;	 
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
<title>Page for choose Discrete Job Information List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(jobOrRunCard,wipEntityIdCh)
{         
  window.opener.document.MYFORM.SEARCHSTRING.value=jobOrRunCard;
  window.opener.document.MYFORM.WIPENTITYIDCH.value=wipEntityIdCh;  
  window.opener.document.MYFORM.JOBEXISTFLAG.value="Y";
  this.window.close();
}

</script>
<body>  
<FORM action="TSMfgWipDiscreteJobFind.jsp" METHOD="post" NAME="SUBJOBFORM">
  <font size="-1" color='BLUE'>工令號、流程卡號: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  <font size="-1" color='BLUE'>-----工令資訊--------------------------------------------</font>     
  <BR>
  <%  
      int queryCount = 0;
	  String wipEntityIdCh = "";
      Statement statement=con.createStatement();
	  try
      { 
	     String sql = "";
		 String where =""; 
		 String order =	"";	
	   if (searchString=="" || searchString.equals(""))
	   {
	              
				      sql ="select DISTINCT a.WIP_ENTITY_ID, a.WIP_ENTITY_NAME, b.DESCRIPTION "+		                  
						   "from WIP_ENTITIES a, WIP_DISCRETE_JOBS b, YEW_RUNCARD_ALL c ";						        		                      									  
					  where = "where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and b.STATUS_TYPE = 3 "+					          
					          "  and a.WIP_ENTITY_NAME = c.WO_NO ";					          		 													  
				      order = "order by a.WIP_ENTITY_ID "; 				  
					  
					  if (statusId==null || statusId.equals("") || statusId.equals("null"))  { }
					  else where = where +  " and c.STATUSID='"+statusId+"' ";
					  //where = where + "and SECONDARY_INVENTORY_NAME like '"+searchString+"%' ";
					  
					  String sqlCNT = "select count(a.WIP_ENTITY_ID) "+
					                    "from WIP_ENTITIES a, WIP_DISCRETE_JOBS b, YEW_RUNCARD_ALL c "+ where;       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();		                    
				   	
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        
				   
				      sql ="select DISTINCT a.WIP_ENTITY_ID, a.WIP_ENTITY_NAME, b.DESCRIPTION "+		                  
						   "from WIP_ENTITIES a, WIP_DISCRETE_JOBS b, YEW_RUNCARD_ALL c ";						        		                      									  
					  where = "where a.WIP_ENTITY_ID = b.WIP_ENTITY_ID and b.STATUS_TYPE = 3 "+					         
					          "  and a.WIP_ENTITY_NAME = c.WO_NO and (a.WIP_ENTITY_NAME like '"+searchString+"%' or c.RUNCARD_NO like '"+searchString+"%') ";					          		 													  
				      order = "order by a.WIP_ENTITY_ID "; 				  
					  
					  if (statusId==null || statusId.equals("") || statusId.equals("null"))  { }
					  else where = where +  " and c.STATUSID='"+statusId+"' ";
					  
					  String sqlCNT = "select count(a.WIP_ENTITY_ID) "+
					                    "from WIP_ENTITIES a, WIP_DISCRETE_JOBS b, YEW_RUNCARD_ALL c "+ where;       						 
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
		 
		  jobOrRunCard=rs.getString(2);	
		  wipEntityIdCh=rs.getString(1);		 			 
		  	 
		  out.println("<input type='hidden' name='JOBORRUNCARD' value='"+jobOrRunCard+"' >");	
		  out.println("<input type='hidden' name='WIPENTITYIDCH' value='"+wipEntityIdCh+"' >");	  
		  //buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";	
		  
		 // buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";			 	 			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD>");
		 %><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='this.value=sendToMainWindow("<%=jobOrRunCard%>","<%=wipEntityIdCh%>")'><%
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
			    window.opener.document.MYFORM.SEARCHSTRING.value=document.SUBJOBFORM.JOBORRUNCARD.value;
				window.opener.document.MYFORM.WIPENTITYIDCH.value=document.SUBJOBFORM.WIPENTITYIDCH.value;
				window.opener.document.MYFORM.JOBEXISTFLAG.value="Y";                 						   	
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
