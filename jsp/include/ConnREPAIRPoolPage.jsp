<%@ page import="bean.PoolBean"%>
<jsp:useBean id="repairpoolBean" scope="application" class="bean.PoolBean"/>

<%
 // Strat Connection for Oracle REPAIR Server
Connection conREPAIR=null;
try
{    
  if (repairpoolBean.getDriver()==null)
  {
   repairpoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   repairpoolBean.setURL(application.getInitParameter("REPAIR_JDBC_URL"));
   repairpoolBean.setURL2(application.getInitParameter("REPAIR_JDBC_URL2"));
   repairpoolBean.setUsername("RPADMIN");
   repairpoolBean.setPassword("RPADMIN");   
   repairpoolBean.setSize(3);
   repairpoolBean.initializePool();
  } //end of if
  repairpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  repairpoolBean.setBeanID("repairpoolBean");
  repairpoolBean.setUsingURL(request.getRequestURL().toString());
  conREPAIR=repairpoolBean.getConnection();	  
  conREPAIR.setAutoCommit(false);//�]�wAutoCommit��false�H��������s�u���`�ɵo�Ϳ��~
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for REPAIR DB    
%>
