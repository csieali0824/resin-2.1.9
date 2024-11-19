<%@ page import="DominoPoolBean,lotus.domino.*"%>
<jsp:useBean id="dominoConn" scope="application" class="DominoPoolBean"/>

<%
 // Strat Connection for Domino TPTEST1 Server
Session sess_notes=null;
try
{    
  if (dominoConn.isSessionAlive()==false || !dominoConn.getServerName().equals("tptest1.dbtel.com.tw"))
  {
     dominoConn.setServerName("tptest1.dbtel.com.tw");
	 dominoConn.setSecondaryServerName("tptest1.dbtel.com.tw"); 
     dominoConn.setUserName("NOTES ADMIN");
     dominoConn.setPassword("NOTESADMIN");  
	 sess_notes=dominoConn.connectDomino();  
  } else {
     sess_notes=dominoConn.getSession();
  } //end of if  
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}

// End of Connection for Domino TPTEST1 Server    
%>
