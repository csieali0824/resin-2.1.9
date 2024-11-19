<%@ page import="PoolBean"%>
<jsp:useBean id="oradTst2poolBean" scope="application" class="PoolBean"/>
<%
 // Strat Connection for Oracle AddOn System Server
Connection conTst2=null;
try
{    
  if (oradTst2poolBean.getDriver()==null)
  {
   oradTst2poolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   oradTst2poolBean.setURL(application.getInitParameter("ORADTST2_JDBC_URL"));
   oradTst2poolBean.setURL2(application.getInitParameter("ORADTST2_JDBC_URL"));
   oradTst2poolBean.setUsername("APPS");
   oradTst2poolBean.setPassword("APPS");   
   oradTst2poolBean.setSize(3);
   oradTst2poolBean.initializePool();
  } //end of if
  oradTst2poolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  oradTst2poolBean.setBeanID("oradTst2poolBean");
  oradTst2poolBean.setUsingURL(request.getRequestURL().toString());
  conTst2=oradTst2poolBean.getConnection();	  
  conTst2.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Oracle Add On System DB    
%>