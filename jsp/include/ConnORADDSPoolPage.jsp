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
   oraddspoolBean.setUsername("ORADDMAN");
   oraddspoolBean.setPassword("ORADDMAN");   
   oraddspoolBean.setSize(3);
   oraddspoolBean.initializePool();
  } //end of if
  oraddspoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oraddspoolBean.setBeanID("oraddspoolBean");
  oraddspoolBean.setUsingURL(request.getRequestURL().toString());
  con=oraddspoolBean.getConnection();	  
  con.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>
