<%@ page import="PoolBean"%>
<jsp:useBean id="oraRFQpoolBean" scope="application" class="PoolBean"/>
<%
 // Strat Connection for Oracle AddOn System Server
Connection conRFQ=null;
try
{    
  if (oraRFQpoolBean.getDriver()==null)
  {
   oraRFQpoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   oraRFQpoolBean.setURL(application.getInitParameter("ORARFQDB_JDBC_URL"));
   oraRFQpoolBean.setURL2(application.getInitParameter("ORARFQDB_JDBC_URL"));
   oraRFQpoolBean.setUsername("ORADDMAN");
   oraRFQpoolBean.setPassword("ORADDMAN");   
   oraRFQpoolBean.setSize(3);
   oraRFQpoolBean.initializePool();
  } //end of if
  oraRFQpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oraRFQpoolBean.setBeanID("oraRFQpoolBean");
  oraRFQpoolBean.setUsingURL(request.getRequestURL().toString());
  conRFQ=oraRFQpoolBean.getConnection();	  
  conRFQ.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>
