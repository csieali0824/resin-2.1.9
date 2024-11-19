<%@ page import="PoolBean"%>
<jsp:useBean id="pdmPoolBean" scope="application" class="PoolBean"/>

<%
 // Strat Connection for Oracle PDM Server
Connection pdmcon=null;
try
{    
  if (pdmPoolBean.getDriver()==null)
  {
   pdmPoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   //pdmPoolBean.setURL("jdbc:oracle:thin:@203.66.141.21:1521:PDMSVR");
   pdmPoolBean.setURL(application.getInitParameter("PDMSVR_JDBC_URL"));
   pdmPoolBean.setURL2(application.getInitParameter("PDMSVR_JDBC_URL")); 
   pdmPoolBean.setUsername("WTADMIN");
   pdmPoolBean.setPassword("WTADMIN");   
   pdmPoolBean.setSize(3);
   pdmPoolBean.initializePool();
  } //end of if
  pdmPoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  pdmPoolBean.setBeanID("pdmPoolBean");
  pdmPoolBean.setUsingURL(request.getRequestURL().toString());
  pdmcon=pdmPoolBean.getConnection();	  
  pdmcon.setAutoCommit(false);
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for PDM DB    
%>
