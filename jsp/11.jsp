<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,java.text.*" %>
<!--=============以下區段為安全認證機制==========-->
 
<!--=============以下區段為取得連結池==========-->
 
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>無標題文件</title>
 


</head>

<body>
<form name="form1"   >
<%

float ss = (float)1.4444;
out.println("ss="+ss);
Connection conn=null;
try{  


	    Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver").newInstance();
		conn = DriverManager.getConnection("jdbc:microsoft:sqlserver://10.0.2.14:1433;DatabaseName=BufferStock;User=sa;Password=gt2000");
		
		String sql =" select * from packinglist ";
		//out.println(sql);
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(sql);
		int k=0;
		
		   //rsfist = t_bookdao.findSeqByRe(id);
           if(rs.next()){
             String b_k = rs.getString("packinglistid");
             String b_i = rs.getString("packinglistnumber");
             String b_ed = rs.getString("customerid");
			 out.println("b_k="+b_k);
			 out.println("b_i="+b_i);
			 out.println("b_ed="+b_ed);
             //b_sd = rs.getString("Book_Sfdate"); 
           }
		
		
		/* while(rs.next()){
		 	if(k==0){
				out.println("k1="+k);
		 	}else if (k>0){ 
				out.println("k="+k);
			}k++;
		 }
		 */
	}catch(SQLException e){out.println(e.toString());} 
	finally{
	 if(conn!=null){
          //conn.setAutoCommit(true);
          conn.close();
	  //con1=null;
      }
	
	}
 

%> 
 
 <input type='submit' name='Submit' value='Submit' id='show1' onClick="sethidden()"  >
 
</form>
</body>
<!--=============以下區段為釋放連結池==========-->
 

<!--=================================-->
</html>
