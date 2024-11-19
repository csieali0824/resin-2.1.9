<%@ page import="PoolBean"%>
<jsp:useBean id="oraddspoolBean" scope="application" class="PoolBean"/>
<%
 // Strat Connection for Oracle AddOn System Server
Connection con=null;
try
{    
  if (oraddspoolBean.getDriver()==null)
  {
   oraddspoolBean.setDriver("oracle.jdbc.driver.OracleDriver");      
   oraddspoolBean.setURL(application.getInitParameter("ORADDS_JDBC_URL"));
   oraddspoolBean.setURL2(application.getInitParameter("ORADDS_JDBC_URL"));   
   //oraddspoolBean.setURL3(application.getInitParameter("ORARFQDB_JDBC_URL"));
   oraddspoolBean.setUsername("APPS");
   oraddspoolBean.setPassword("TSCApps12");   
   oraddspoolBean.setSize(3);
   oraddspoolBean.initializePool();
  } //end of if
  oraddspoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oraddspoolBean.setBeanID("oraddspoolBean");
  oraddspoolBean.setUsingURL(request.getRequestURL().toString());
  con=oraddspoolBean.getConnection();	  
  con.setAutoCommit(false);//Setting AutoCommit for false to permmit Network connection Error
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>