<% 
 String pageHeaderURL=null;
 String clientLocale=request.getLocale().toString(); 
 //out.println(clientLocale);
 if (clientLocale.equals("zh_TW"))
 {
  pageHeaderURL="/jsp/include/PageHeader_TW.jsp";
  response.setContentType("text/html; charset=utf-8");
 } else {
   if (clientLocale.equals("zh_CN"))
   {
     pageHeaderURL="/jsp/include/PageHeader_CN.jsp";
     response.setContentType("text/html; charset=utf-8");
   } else {
     pageHeaderURL="/jsp/include/PageHeader_EN.jsp";
     response.setContentType("text/html; charset=ISO8859_1");
   }	
 } 
%>
<jsp:include page="<%= pageHeaderURL %>"/>
