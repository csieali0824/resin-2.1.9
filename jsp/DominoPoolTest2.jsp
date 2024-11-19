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
  dominoPool.setPassword("9103");
  dominoPool.setServerName("notesapp.dbtel.com.tw"); 
  dominoPool.setSecondaryServerName("tptest1.dbtel.com.tw"); 
  s=dominoPool.connectDomino();
  
  Database db=s.getDatabase(s.getServerName(),"dbtel_tp/tpepu.nsf"); //取下一層目錄的資料庫其符號為右上左下的斜線"/"
  out.println(db.getTitle()+"<BR>");
  View v=(View)db.getView("AllDocByDocNo");
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
  Document doc=v.getDocumentByKey("PUT0500087");  
  if (doc!=null) 
  {
	  Vector im1=doc.getItemValue("EmpID");
	  for (int i=0;i<im1.size();i++)
	  {
		out.println((String)im1.elementAt(i));
	  }	
	  out.println("--");
	  out.println(doc.getItemValue("DocMstat"));
	  out.println("<BR>"); 
	  Vector im2=doc.getItemValue("p_Item");
	  Vector im3=doc.getItemValue("p_Unit");
	  Vector im4=doc.getItemValue("p_Qnt");
	  for (int i=0;i<im2.size();i++)
	  {
		out.println((i+1)+":"+(String)im2.elementAt(i)+"|"+(String)im3.elementAt(i)+"|"+(String)im4.elementAt(i)+"<BR>");
	  }	
  } //end of doc!=null if	  
  
  out.println("<BR>");
  DocumentCollection dc=db.FTSearch("PUT0500087",100);
  out.println("There is "+dc.getCount()+" records");
  
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
