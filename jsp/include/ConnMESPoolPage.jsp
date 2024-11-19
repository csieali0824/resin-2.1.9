<%@ page import="PoolBean"%>
<jsp:useBean id="mespoolBean" scope="application" class="PoolBean"/>

<%
 // Strat Connection for Oracle MES Server
Connection conMES=null;
try
{    
  if (mespoolBean.getDriver()==null)
  {
   mespoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   //mespoolBean.setURL("jdbc:oracle:thin:@10.0.1.21:1521:DBTPEDC");
   mespoolBean.setURL(application.getInitParameter("MES_JDBC_URL"));
   mespoolBean.setURL2(application.getInitParameter("MES_JDBC_URL"));
   mespoolBean.setUsername("SFIS1");
   mespoolBean.setPassword("SFIS1");   
   mespoolBean.setSize(3);
   mespoolBean.initializePool();
  } //end of if
  mespoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  mespoolBean.setBeanID("mespoolBean");
  mespoolBean.setUsingURL(request.getRequestURL().toString());
  conMES=mespoolBean.getConnection();	  
  conMES.setAutoCommit(false);//設定AutoCommit為false以防止網路連線異常時發生錯誤
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for MES DB    
%>
