<%@ page contentType="text/html; charset=utf-8" language="java" import="java.util.*,java.text.*,java.io.*,java.sql.*,javax.sql.*,javax.naming.*,DateBean"%>
  <html>
  <body>
<%
	String name 		= request.getParameter("Name");
	//out.println("name="+name);
	String department	= request.getParameter("Department");
	//out.println("department="+department);
	String title		= request.getParameter("Title");
	//out.println("title="+title);
	String company 		= request.getParameter("Company");
	//out.println("company="+company);
	String email		= request.getParameter("Email");
	//out.println("email="+email);
	String telephone	= request.getParameter("Telephone");
	//out.println("telephone="+telephone);
	String fax			= request.getParameter("Fax");
	//out.println("fax="+fax);
	String q1 = request.getParameter("Q1");
	//out.println("q1="+q1);
	String q2 = request.getParameter("Q2");
	//out.println("q2="+q2);
	String q3 = request.getParameter("Q3");
	//out.println("q3="+q3);
	String q4 = request.getParameter("Q4");
	//out.println("q4="+q4);
	String q5 = request.getParameter("Q5");
	//out.println("q5="+q5);
	String q6 = request.getParameter("Q6");
	//out.println("q6="+q6);
	String q7 = request.getParameter("Q7");
//	out.println("q7="+q7);
	String q8 = request.getParameter("Q8");
	//out.println("q8="+q8);
	String q9 = request.getParameter("Q9");
	//out.println("q9="+q9);
	String q10 = request.getParameter("Q10");
	//out.println("q10="+q10);
	String q11 = request.getParameter("Q11");
	//out.println("q11="+q11);
	String comment = request.getParameter("comment");
	//out.println("comment="+comment);
	String id = request.getParameter("id");
	//String f_date = Date; 
Connection con=null;
	try{
		
		Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		con = DriverManager.getConnection("jdbc:microsoft:sqlserver://ap:1433;DatabaseName=tsc_co;User=web;Password=6227");
		//out.println(con);
		String sql =" Insert into tsc_collect_one " + 
					" (name , department , title , company , email ," +
					" telephone , fax , q1 , q2 , q3 , q4 , q5 , q6 , q7 ,"+
					" q8 , q9 , q10 , q11, comment ,customer_id) "+
 					" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) ";
					
					//out.println("sql="+sql);
					
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
			//st1.setString(19,q12);
			st1.setString(19,comment);
			st1.setString(20,id);
			//st1.executeUpdate();
			con.setAutoCommit(true);
			st1.execute();
			//con.setAutoCommit(true);
			//st1.execute();

								 
	}catch(SQLException e){
		System.out.println(e.toString());
	}finally{
	   	if(con!=null){
		  	con.close();
			//con=null;
%>
	<Script language="JavaScript">
		alert("Thanks for your cooperation!!");
		var LL
		LL = "http://WWW.TAIWANSEMI.COM/TSCbig5/front/bin/home.phtml";
		location.href=LL;
	</Script>
<%
		     response.sendRedirect("http://www.ts.com.tw/TSCbig5/front/bin/home.phtml");
		}
	}
 

 
 
 
%>
</body>
</html>
