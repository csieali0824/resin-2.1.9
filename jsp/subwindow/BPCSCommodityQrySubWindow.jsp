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
<title>Page for query BPCS Commodity & Charge Code</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
function sendToMainWindow()
{    
 this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="/wins/jsp/subwindow/BPCSCommodityQrySubWindow.jsp">
  <font size="-1">採購物品名稱或料號: 
  <input type="text" name="SEARCHSTRING" size=20 value=<%=searchString%>>
  </font> 
  <INPUT TYPE="submit" NAME="submit" value="查詢"><BR>
  ------------------------------------------------------------------------     
  <BR>
  <%  
	  try
      { 
	   if (searchString!="" && searchString!=null) 
	   {  	    
	    String sql = "select DISTINCT PCDESC,PCCOM from HPC where PCDESC like '%"+searchString+"%' or PCCOM like '"+searchString+"%' order by PCDESC";
        Statement statement=bpcscon.createStatement();
        ResultSet rs=statement.executeQuery(sql);
		//out.println(sql);
       		
	    ResultSetMetaData md=rs.getMetaData();
        int colCount=md.getColumnCount();
        String colLabel[]=new String[colCount];        
        out.println("<TABLE border=1 cellspacing=0>");      
        out.println("<TR>");        
        out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=3>物品名稱</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=3>料號</TH>");       
        out.println("</TR>");		
		 
        while (rs.next())
        {		
         for (int i=1;i<=colCount;i++)
         {
          String s=(String)rs.getString(i);
          out.println("<TD><FONT SIZE=3>"+s+"</TD>");
         } //end of for
          out.println("</TR>");		
        } //end of while
        out.println("</TABLE>");						
		
		statement.close();
        rs.close();       
	   }//end of while
      } //end of try
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
     %>
  <BR>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</body>
</html>
