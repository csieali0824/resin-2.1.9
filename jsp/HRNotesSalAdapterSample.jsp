<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>             <!--% // ***** ----------登入WINS系統的認證頁面 -------*****%-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnNoteSalTestPoolPage.jsp"%>   <!--% // ***** ----------針對 Notes Salary測試資料庫的連線 -------***** %-->
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>NOTESHRxxx.jsp</title>               <!--%//  頁面抬頭 (程式名稱) %-->  
</head>

<body> 

<%
   // -------*****變數宣告 及參數傳遞 ****** -------- 

  int beginTime=0;
  String chineseName="";
  String employeCd=request.getParameter("EMPLOYECD");
  String offworkType=request.getParameter("OFFWORKTYPE");
  
  // -------*****變數宣告 及參數傳遞 ****** -------- 
   
  try
  {           // *****---------  利用 ConnNoteSalTestPoolPage 的連線 ifxnsaltestcon 產生一資料庫連線敘述  -------*****//
        	  Statement statement=ifxnsaltestcon.createStatement();   
	          //***** ----- 你的 Select SQL 語句  -------*****//
	          ResultSet rs=statement.executeQuery("select SERIALCOLUMN,BEGINTIME from OFFWORKRECORD where EMPLOYECD='"+employeCd+"' ");
              if (rs.next()) {
			       beginTime=rs.getInt("BEGINTIME");   
			       //out.print("Max:"+Max+"<br>");
			  }			 
               rs.close();    
		       statement.close(); 
  //  ***** ------  你的寫入資料庫的 SQL 語句  --------*****//
   String sql="insert into OFFWORKRECORD(EMPLOYECD,OFFWORKTYPE,BEGINDATE,BEGINTIME,ENDDATE,ENDTIME,OFFWORKDAYS,OFFWORKHOURS) "+
                    "values(?,?,?,?,?,?,?,?)";
   // 資料新增至資料庫
  // ***** ------   同樣利用 ifxnsaltestcon 連線  -------*****
	 PreparedStatement pstmt=ifxnsaltestcon.prepareStatement(sql);	 	 
	 
	 pstmt.setString(1,ROLENAME);
	 pstmt.setString(2,address);
	 pstmt.setString(3,ADDRESSDESC);
	 pstmt.setString(4,model);
	 pstmt.setString(5,programmername);
	 pstmt.setInt(6,Max);
	 pstmt.setInt(7,Max);
	 pstmt.setInt(8,Max);
	 pstmt.executeUpdate(); 
	 pstmt.close();
	 	 
   } 
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
 <br>出差申請寫入SALARY:<%= ROLENAME %> 加入記錄完成!<br>
 <a href="/wins/WinsMainMenu.jsp">回首頁</a> <br>
</body>
<!--%   // ***** ------- 記得務必程式碼最後段 include 釋放 Connection Pool 的 jsp  ------ *****%-->
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnNoteSalTestPage.jsp"%>      
<!--=================================-->
</html>
