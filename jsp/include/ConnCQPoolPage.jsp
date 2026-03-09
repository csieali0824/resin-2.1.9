<%@ page import="bean.PoolBean"%>
<jsp:useBean id="cqPoolBean" scope="application" class="bean.PoolBean"/>

<%
 // Strat Connection for Oracle ClearQuest Server
Connection conCQ=null;
try
{    
  if (cqPoolBean.getDriver()==null)
  {
   cqPoolBean.setDriver("oracle.jdbc.driver.OracleDriver");   
   //cqPoolBean.setURL("jdbc:oracle:thin:@10.0.1.22:1521:CQDB");
   cqPoolBean.setURL(application.getInitParameter("CQ_JDBC_URL"));
   cqPoolBean.setURL2(application.getInitParameter("CQ_JDBC_URL"));
   cqPoolBean.setUsername("SYSTEM");
   cqPoolBean.setPassword("MANAGER");   
   cqPoolBean.setSize(3);
   cqPoolBean.initializePool();
  } //end of if
  cqPoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  cqPoolBean.setBeanID("cqPoolBean");
  cqPoolBean.setUsingURL(request.getRequestURL().toString());
  conCQ=cqPoolBean.getConnection();	  
  conCQ.setAutoCommit(false);//�]�wAutoCommit��false�H��������s�u���`�ɵo�Ϳ��~
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for MES DB    
%>
