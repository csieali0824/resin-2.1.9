<%@ page import="PoolBean"%>
<jsp:useBean id="oraDevpoolBean" scope="application" class="PoolBean"/>
<%
 // Strat Connection for Oracle AddOn System Server
Connection conDev=null;
try
{    
  if (oraDevpoolBean.getDriver()==null)
  {
   oraDevpoolBean.setDriver("oracle.jdbc.driver.OracleDriver");      
   oraDevpoolBean.setURL(application.getInitParameter("ORADTST_JDBC_URL"));
   oraDevpoolBean.setURL2(application.getInitParameter("ORADTST2_JDBC_URL"));   
   //oraDevpoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL"));
   oraDevpoolBean.setUsername("APPS");
   oraDevpoolBean.setPassword("APPS");   
   oraDevpoolBean.setSize(3);
   oraDevpoolBean.initializePool();
  } //end of if
  oraDevpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oraDevpoolBean.setBeanID("oraDevpoolBean");
  oraDevpoolBean.setUsingURL(request.getRequestURL().toString());
  conDev=oraDevpoolBean.getConnection();	  
  conDev.setAutoCommit(false);//Setting AutoCommit for false to permmit Network connection Error
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>