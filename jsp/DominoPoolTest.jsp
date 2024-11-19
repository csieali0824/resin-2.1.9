<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.Vector"%>
<%@ page import="lotus.domino.*" %>
<html>
<head>
<title>Domino Connection Pool test page</title>
</head>
<body>
<%@ page import="DominoPoolBean" %>
<jsp:useBean id="dominoPool" scope="session" class="DominoPoolBean"/>
<%
 Session s=null; 
 try
 {    
  dominoPool.setUserName("ROGER CHANG");
  dominoPool.setPassword("ROGERCHANG");
  dominoPool.setServerName("notesapp.ares-comm.com.tw"); 
  dominoPool.setSecondaryServerName("tptest1.dbtel.com.tw"); 
  s=dominoPool.connectDomino();
  
  Database db=s.getDatabase(s.getServerName(),"log.nsf");
  out.println(db.getTitle()+"<BR>");
  View v=(View)db.getView("ReplicationEvents");
  ViewEntryCollection vec=v.getAllEntries();  
  Vector columnNames=v.getColumnNames();
  out.println("<TABLE>");
  out.println("<TR BGCOLOR=DAA520>");
  for (int i=0;i<columnNames.size();i++) 
  {
   out.println("<TD>"+(String)columnNames.elementAt(i)+"</TD>");
  }
  out.println("</TR>");  
  //ViewEntry entry=vec.getFirstEntry();
  //while (entry!=null)
  //{
  // out.println("<TR>");
  // Vector vv=entry.getColumnValues();
  // for (int i=0;i<vv.size();i++) 
  //{
  // out.println("<TD>"+vv.elementAt(i)+"</TD>");  
  //}       
  // out.println("</TR>");
  // entry=vec.getNextEntry(entry);
  //}
  out.println("</TABLE>");  
  out.println(dominoPool.getCommonUserName());
  dominoPool.setDisconnect();
  } //end of try
  catch (NotesException n) 
  {
     out.println("Notes Exception:"+n.getMessage());  
  }	 
  catch (Exception e)
  {
    out.println("Exception:"+e.getMessage());
  } 	            
  			
%>
</body>
</html>
