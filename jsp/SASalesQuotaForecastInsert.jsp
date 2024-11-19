<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,ForePriCostInputBean,WorkingDateBean" %>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<title>Sales Monthly Forecast Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String comp=request.getParameter("COMP");
String dept=request.getParameter("DEPT");
String curr=request.getParameter("CURR");
String country=request.getParameter("COUNTRY");
String user=request.getParameter("TYPE");

String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="",Delsql="";  
   if (a!=null) 
   {   
     String ym[]=forePriCostInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)     
	 { 	
//	   String fmPrjcd=a[ac][0].substring(0,a[ac][0].indexOf("@"));
//	   String fmColor=a[ac][0].substring(a[ac][0].indexOf("@")+1); 
	   String sales=a[ac][0].substring(1,a[ac][0].indexOf("@"));  //工號第一碼T 不抓
	   String fname=a[ac][0].substring(a[ac][0].indexOf("@")+1); 
	   for (int subac=1;subac<a[ac].length;subac++)
	   {
	     String tpym=ym[subac+1]; 
	     String tpy=tpym.substring(0,4); //get year String
		 String tpm=tpym.substring(5,7); //get month String
		 String qty_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位

         Statement stmt=con.createStatement();
         ResultSet rsSel=null;
		 rsSel=stmt.executeQuery("select *  FROM PSALES_HIRECHY_SQUOTA where FPCOMP='"+comp+"' AND FPYEAR='"+tpy+"' AND FPMONTH='"+tpm+"' AND FSHIERCHY='"+dept+"' AND FSALES='"+sales+"' ");                  				  
		 if (rsSel.next())  // 如果資料已存在 先刪除
          {
		    Delsql = "Delete  FROM PSALES_HIRECHY_SQUOTA where FPCOMP='"+comp+"' AND FPYEAR='"+tpy+"' AND FPMONTH='"+tpm+"' AND FSHIERCHY='"+dept+"' AND FSALES='"+sales+"' ";                  				  
            PreparedStatement pstmtD=con.prepareStatement(Delsql);  
            pstmtD.executeUpdate();	
		    pstmtD.close();		   
		  }
         rsSel.close();		  
		 stmt.close();  
		 
         sql="insert into PSALES_HIRECHY_SQUOTA(FPCOMP,FPYEAR,FPMONTH,FSHIERCHY,FSALES,FNAME,FSQUOTA,FPCURR,FPMVER,FPLUSER) values(?,?,?,?,?,?,?,?,?,?)"; 
         PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,comp);
           pstmt.setString(2,tpy);  
           pstmt.setString(3,tpm);
           pstmt.setString(4,dept);
           pstmt.setString(5,sales);
           pstmt.setString(6,fname);
           pstmt.setString(7,qty_in_array); 
		   a[ac][subac]=qty_in_array; //將之塞入對應之陣列內容
           pstmt.setString(8,curr);
		   pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
           pstmt.setString(10,UserName);
           pstmt.executeUpdate();	
		   pstmt.close();		   
		   
		} //end of sub for   		
	} //enf of for	
  } //end of array if null
  
  out.println("Input Monthly Forecast Data Successfully!!<BR>");
  out.println("<A HREF=../jsp/SASalesQuotaForeEntry.jsp>業務員銷售業績額度輸入</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to SubMenu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");    
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(forePriCostInputBean.getResultString());		  		   	 
   }	//enf of a!=null if         
 
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
