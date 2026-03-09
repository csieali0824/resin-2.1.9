<%@ page import="bean.PoolBean"%>
<jsp:useBean id="oraddspoolBean" scope="application" class="bean.PoolBean"/>

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
   oraddspoolBean.setUsername("APPS");
   oraddspoolBean.setPassword("TSCApps12");   
   oraddspoolBean.setSize(3);
   oraddspoolBean.initializePool();
  } //end of if
  oraddspoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oraddspoolBean.setBeanID("oraddspoolBean");
  oraddspoolBean.setUsingURL(request.getRequestURL().toString());
  con=oraddspoolBean.getConnection();	  
  con.setAutoCommit(false);//�]�wAutoCommit��false�H��������s�u���`�ɵo�Ϳ��~
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>
