<%@ page import="PoolBean"%>
<jsp:useBean id="ifxNotesSalPoolBean" scope="application" class="PoolBean"/>

<%
 // Strat Connection for Informix HR DB Server
Connection ifxnotessalcon=null;
try
{    
  if (ifxNotesSalPoolBean.getDriver()==null)
  {  
   ifxNotesSalPoolBean.setDriver("com.informix.jdbc.IfxDriver");   
   ifxNotesSalPoolBean.setURL(application.getInitParameter("NOTESSAL(SALARY)_JDBC_URL"));
   ifxNotesSalPoolBean.setURL2(application.getInitParameter("NOTESSAL(SALARY)_JDBC_URL2"));
   ifxNotesSalPoolBean.setUsername("notesal");
   ifxNotesSalPoolBean.setPassword("mis110");   
   ifxNotesSalPoolBean.setSize(3);
   ifxNotesSalPoolBean.initializePool();
  } //end of if
  ifxNotesSalPoolBean.setHostInfo(request.getRemoteAddr()+"("+(String)session.getAttribute("USERNAME")+")");
  ifxNotesSalPoolBean.setBeanID("ifxNotesSalPoolBean");
  ifxNotesSalPoolBean.setUsingURL(request.getRequestURL().toString());
  ifxnotessalcon=ifxNotesSalPoolBean.getConnection();   
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Informix DB with database test   
%>
