<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--===========================================-->
<%
 
 String organizationID=request.getParameter("ORGANIZATIONID");
 String searchString=request.getParameter("SEARCHSTRING"); 
 
 String wipEntityId=request.getParameter("WIPENTITYID");
 
 
 //String subInventory="";  
   
 try
 {
   if (searchString==null || searchString.equals(""))
   {     	  
	 searchString=wipEntityId; 
	 
	 if ( (wipEntityId==null || wipEntityId.equals("") ) )
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
	            if (wipEntityId!=null && !wipEntityId.equals(""))  searchString = wipEntityId;				
	 
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
<title>Page for choose Discrete Job Operation List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(Operation,OperDesc)
{         
  window.opener.document.MYFORM.OPERATION.value=Operation;  
  window.opener.document.MYFORM.OPERDESC.value=OperDesc;
  this.window.close();
}

</script>
<body>  
<FORM action="TSMfgWipDiscreteJobFind.jsp" METHOD="post" NAME="SUBOPERFORM">
  <font size="-1" color='BLUE'>工令站別: 
  <input type="text" name="SEARCHSTRING" size=30 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="button1" value="查詢"><BR>
  <font size="-1" color='BLUE'>-----站別資訊--------------------------------------------</font>     
  <BR>
  <%  
      int queryCount = 0;
	  String operation="";
	  String departCode="";
	  String operDesc="";
      Statement statement=con.createStatement();
	  try
      { 
	     String sql = "";
		 String where =""; 
		 String order =	"";	
	   if (searchString=="" || searchString.equals(""))
	   {	              
				      sql ="select a.WIP_ENTITY_ID, a.OPERATION_SEQ_NUM, b.DEPARTMENT_CODE, a.DESCRIPTION, a.QUANTITY_IN_QUEUE as Queue, "+
					       " a.QUANTITY_RUNNING as Run, a.QUANTITY_WAITING_TO_MOVE as ToMove, a.QUANTITY_REJECTED as Reject, "+
						   " a.QUANTITY_SCRAPPED as Scrap "+		                  
						   "from WIP_OPERATIONS a, BOM_DEPARTMENTS b ";						        		                      									  
					  where = "where a.DEPARTMENT_ID = b.DEPARTMENT_ID "+
					          "  and a.WIP_ENTITY_ID = "+wipEntityId+" ";					          		 													  
				      order = "order by a.OPERATION_SEQ_NUM "; 				  
					  
					  //where = where + "and SECONDARY_INVENTORY_NAME like '"+searchString+"%' ";					  
					  String sqlCNT = "select count(a.WIP_ENTITY_ID) "+
					                    "from WIP_OPERATIONS a, BOM_DEPARTMENTS b "+ where;       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();   				   	
	   }
	   else if ( searchString!=null && !searchString.equals("") ) 
	   {  	
	     //out.println("1");			        				   
				      sql ="select a.WIP_ENTITY_ID, a.OPERATION_SEQ_NUM, b.DEPARTMENT_CODE, a.DESCRIPTION, a.QUANTITY_IN_QUEUE as Queue, "+
					       " a.QUANTITY_RUNNING as Run, a.QUANTITY_WAITING_TO_MOVE as ToMove, a.QUANTITY_REJECTED as Reject, "+
						   " a.QUANTITY_SCRAPPED as Scrap "+		                  
						   "from WIP_OPERATIONS a, BOM_DEPARTMENTS b ";						        		                      									  
					  where = "where a.DEPARTMENT_ID = b.DEPARTMENT_ID "+
					          "  and a.WIP_ENTITY_ID = "+wipEntityId+" ";					          		 													  
				      order = "order by a.OPERATION_SEQ_NUM "; 				  
					  
					  //where = where + "and SECONDARY_INVENTORY_NAME like '"+searchString+"%' ";
					  
					  String sqlCNT = "select count(a.WIP_ENTITY_ID) "+
					                    "from WIP_OPERATIONS a, BOM_DEPARTMENTS b "+ where;       						 
					  ResultSet rsCNT = statement.executeQuery(sqlCNT);
					  if (rsCNT.next()) queryCount = rsCNT.getInt(1);
		              rsCNT.close();		   
					  //out.println(sqlCNT); 				                    
				 
	   }//end of else if ( searchString!=null && !searchString.equals("") )  
		sql = sql + where + order;
		out.println("sql="+sql); 
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
		 
		  operation=rs.getString(2);
		  departCode=rs.getString(3);
		  operDesc=rs.getString(4);		  		 			 
		  	 
		  out.println("<input type='hidden' name='OPERATION' value='"+operation+"' >");	
		  out.println("<input type='hidden' name='OPERDESC' value='"+operDesc+"' >");		  
		  //buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";	
		  
		 // buttonContent="this.value=sendToMainWindow("+'"'+supplyVndID+'"'+","+'"'+supplyVndNo+'"'+","+'"'+supplyVnd+'"'+")";			 	 			  
         out.print("<TR BGCOLOR='"+trBgColor+"'><TD>");
		 %><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='this.value=sendToMainWindow("<%=operation%>","<%=operDesc%>")'><%
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
			    window.opener.document.MYFORM.OPERATION.value=document.SUBJOBFORM.OPERATION.value;
				window.opener.document.MYFORM.OPERDESC.value=document.SUBJOBFORM.OPERDESC.value;                 						   	
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
