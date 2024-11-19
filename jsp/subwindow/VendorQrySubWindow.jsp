<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=================================-->
<%
 String searchString=request.getParameter("SEARCHSTRING");
 try
 {
   if (searchString==null)
   {
    searchString="";
   }
 } 
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());
 }   
%>
<html>
<head>
<title>Page for choose vendor to add to PR2PO Generator</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow(vendorNo)
{   
 window.opener.document.MYFORM.VENDORNO.value=vendorNo; 
 this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="VendorQrySubWindow.jsp">
  <font size="-1">廠商名稱或代碼: 
  <input type="text" name="SEARCHSTRING" size=20 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  -----廠商資訊--------------------------------------------     
  <BR>
  <%  
      Statement statement=bpcscon.createStatement();
	  try
      { 
	   if (searchString!="" && searchString!=null) 
	   {  	    
	    String sql = "select VENDOR,VNDNAM,VNDAD1,VNDAD2,VCON,VPHONE from AVM where VNDNAM like '"+searchString+"%' or substr(VENDOR,1) like '"+searchString+"%'";       
        ResultSet rs=statement.executeQuery(sql);
		       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount+1];        
        out.println("<TABLE>");      
        out.println("<TR><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");        
        for (int i=1;i<=colCount;i++)
        {
         colLabel[i]=md.getColumnLabel(i);
         out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
        } //end of for 
        out.println("</TR>");
		String vendorNo=null,vendorName=null,vendorAddr1=null,vendorAddr2=null,vendorContact=null,vendorPhone=null;
      		
        String buttonContent=null;
		 
        while (rs.next())
        {
		 vendorNo=rs.getString("VENDOR");
		 vendorName=rs.getString("VNDNAM");
		 vendorAddr1=rs.getString("VNDAD1");
		 vendorAddr2=rs.getString("VNDAD2");
		 vendorContact=rs.getString("VCON");
		 vendorPhone=rs.getString("VPHONE");		 	 
		 
		 buttonContent="this.value=sendToMainWindow("+'"'+vendorNo+'"'+")";		
         out.println("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE='帶入' onClick='"+buttonContent+"'></TD>");		
         for (int i=1;i<=colCount;i++)
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
          out.println("</TR>");	
        } //end of while
        out.println("</TABLE>");						
		
        rs.close();       
	   }//end of while
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
	  statement.close();
     %>
  <BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</body>
</html>
