<%@ page import="PoolBean"%>
<jsp:useBean id="oradTstpoolBean" scope="application" class="PoolBean"/>
<%
 // Strat Connection for Oracle AddOn System Server
Connection conTst=null;
try
{    
  if (oradTstpoolBean.getDriver()==null)
  {
   oradTstpoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   oradTstpoolBean.setURL(application.getInitParameter("ORADTST_JDBC_URL"));
   oradTstpoolBean.setURL2(application.getInitParameter("ORADTST_JDBC_URL"));
   oradTstpoolBean.setUsername("APPS");
   oradTstpoolBean.setPassword("APPS");   
   oradTstpoolBean.setSize(3);
   oradTstpoolBean.initializePool();
  } //end of if
  oradTstpoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oradTstpoolBean.setBeanID("oraddspoolBean");
  oradTstpoolBean.setUsingURL(request.getRequestURL().toString());
  conTst=oradTstpoolBean.getConnection();	  
  conTst.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>