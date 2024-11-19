<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,DateBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%
	String name 		= request.getParameter("Name");
	String department	= request.getParameter("Department");
	String title		= request.getParameter("Title");
	String company 		= request.getParameter("Company");
	String email		= request.getParameter("Email");
	String telephone	= request.getParameter("Telephone");
	String fax			= request.getParameter("Fax");
	String q1 = request.getParameter("Q1");
	String q2 = request.getParameter("Q2");
	String q3 = request.getParameter("Q3");
	String q4 = request.getParameter("Q4");
	String q5 = request.getParameter("Q5");
	String q6 = request.getParameter("Q6");
	String q7 = request.getParameter("Q7");
	String q8 = request.getParameter("Q8");
	String q9 = request.getParameter("Q9");
	String q10 = request.getParameter("Q10");
	String q11 = request.getParameter("Q11");
	String comment = request.getParameter("comment");
	//String f_date = Date;

	try{
		Connection conn=null;
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://ap:1433;DatabaseName=BufferStock;User=sa;Password=gt2000");
		
		String sql =" Insert into tsc_collect_one " + 
					" (name , department , title , company , email ," +
					" telephone , fax , q1 , q2 , q3 , q4 , q5 , q6 , q7 ,"+
					" q8 , q9 , q10 , q11, comment) "+
 					" VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
					
		con.setAutoCommit(false);
		PreparedStatement st1 = con.prepareStatement(sql);
			st1.setString(1,name);	  //CUSTOMERPO
			st1.setString(2,department);
			st1.setString(3,title);
			st1.setString(4,company);
			st1.setString(5,email);
			st1.setString(6,telephone);
			st1.setString(7,fax);
			st1.setString(8,q1);
			st1.setString(9,q2);
			st1.setString(10,q3);
			st1.setString(11,q4);
			st1.setString(12,q5);
			st1.setString(13,q6);
			st1.setString(14,q7); 
			st1.setString(15,q8);
			st1.setString(16,q9);
			st1.setString(17,q10);
			st1.setString(18,q11);
			st1.setString(19,q12);
			st1.setString(19,comment);
			//st1.executeUpdate();
			st1.execute() ;

								 
	}catch(SQLException e){
		System.out.println(e.toString());
	}finally{
	   	if(conn!=null){
		  	conn.close();
			conn=null;
		    response.sendRedirect("http://www.taiwansemiconductor.com.tw");
		}
	}
 

 
 
 
%>
</body>
</html>
