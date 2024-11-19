<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<script language="javascript">
function YEWURL() 
{
   location.href = "http://yewintra.ts.com.tw:8080/oradds/jsp/";
}
</script>
<%
   String siteLogin = "";  // 判定使用者由何網域登入決定其使用之Web AP Server 2007/08/29
   int remoteAddrLength = request.getRemoteAddr().length();
   boolean YEWUserFlag = false;  // 預設非陽信使用者
   
         // 2007/09/17 另外判斷使用者是否為山東陽信_起
			 Statement stmtERP=con.createStatement(); 
			 String sqlERP = " select a.USER_NAME "+
	                      " from FND_USER a, ORADDMAN.WSUSER b "+
		                  " where upper(a.USER_NAME) = upper(b.USERNAME) "+
		                  "   and upper(a.USER_NAME) = upper('"+UserName+"') and a.DESCRIPTION like '%陽信%' ";	
	         //out.print(sql);		
	         ResultSet rsERP=stmtERP.executeQuery(sqlERP);	   
	         if (rsERP.next())
			 {
			   YEWUserFlag = true;
			 } else { YEWUserFlag = false; }
			 rsERP.close();
			 stmtERP.close();
		 // 2007/09/17 另外判斷使用者是否為山東陽信_迄
		 
		    if (remoteAddrLength>9) // 
            {
              siteLogin = request.getRemoteAddr().substring(0,10); // 若為YEW, 則一律以特定  
			  String reqURL = request.getRequestURL().toString();
             
	          if (siteLogin.indexOf("192.168.5.")>=0 )
	          {
			    if (reqURL.indexOf("http://intranet.ts.com.tw:8080/oradds")>=0 || reqURL.indexOf("http://210.62.146.199:8080/oradds/jsp")>=0 || reqURL.indexOf("http://intranet.ts.com.tw:8080/oradds/jsp")>=0)
				{
	              %>
	               <script language="javascript">
	                 alert("                 您屬於山東陽信使用者\n 點擊確定後系統會自動將您轉至專屬服務主機!!!");		  
		             setTimeout('YEWURL()',500);
		           </script>
	              <%
				}  
			  }
				 
            } 

%>
 
