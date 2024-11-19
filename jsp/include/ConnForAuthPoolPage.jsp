<%@ page import="PoolBean"%>
<jsp:useBean id="authPoolBean" scope="application" class="PoolBean"/>
<%
//Start connect Oracle prod ORADDMAN,This Connection is for Authentication only
Connection authcon=null;
try
{     
  if (authPoolBean.getDriver()==null)
  {
   authPoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   authPoolBean.setURL(application.getInitParameter("ORADDS_JDBC_URL"));  // Production
   authPoolBean.setURL2(application.getInitParameter("ORADDS_JDBC_URL"));  // Production  
   //authPoolBean.setURL(application.getInitParameter("ORADTST2_JDBC_URL")); // Testing
   //authPoolBean.setURL2(application.getInitParameter("ORADTST_JDBC_URL")); // Testing   
   //authPoolBean.setURL(application.getInitParameter("ORADTST_JDBC_URL")); // Testing  
   //authPoolBean.setURL2(application.getInitParameter("ORADTST2_JDBC_URL")); // Testing
   //authPoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL")); // Testing
   authPoolBean.setUsername("APPS");
   authPoolBean.setPassword("TSCApps12");   
   authPoolBean.setSize(3);   
   authPoolBean.initializePool();
  } //end of if
  authPoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  authPoolBean.setBeanID("authPoolBean");
  authPoolBean.setUsingURL(request.getRequestURL().toString());
  authcon=authPoolBean.getConnection();	  
  authcon.setAutoCommit(false);
} //end of try
catch (Exception e)
{
 out.println("JSP Exception:"+e.getMessage());
}
// End of Connect to PROD ORADDMAN
%>
