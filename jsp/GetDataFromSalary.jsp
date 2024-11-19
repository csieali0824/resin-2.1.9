<%@ page contentType="text/html; charset=utf-8" import="java.sql.*,java.util.*,java.io.*"%>
<%@ include file="/jsp/include/ConnNotesSalPoolPage.jsp"%> 
<%				
		String sql = request.getParameter("sql");	
		
	try
	{
		//將所接到的值，利用SQL，寫入資料庫中。				
		Statement stmt = ifxnotessalcon.createStatement();
		ResultSet rs = stmt.executeQuery(sql);			
  	  	
		while (rs.next())
		{
			out.println("MAX:"+rs.getString(1));
		}
		rs.close();
		stmt.close();		
		ifxnotessalcon.close();		
	} //end of try
	catch (Exception e)	{  		
		out.println("error sql="+sql);    		
		out.println(e.getMessage()); 
	} //end of catch
%>	
<%@ include file="/jsp/include/ReleaseConnNotesSalPage.jsp"%> 
