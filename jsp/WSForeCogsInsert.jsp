<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,ForePriCostInputBean" %>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Sales Forecast COGs Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String comp=request.getParameter("COMP");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");
String type=request.getParameter("TYPE");
String curr=request.getParameter("CURR");

String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="";  
   if (a!=null) 
   {   
     String ym[]=forePriCostInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	 
	   for (int subac=1;subac<a[ac].length;subac++)
	   {
	     String tpym=ym[subac+1]; 
	     String tpy=tpym.substring(0,4); //get year String
		 String tpm=tpym.substring(5,7); //get month String
		 String c_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位
           sql="insert into PSALES_FORE_COGS(FCCOMP,FCYEAR,FCMONTH,FCREG,FCCOUN,FCTYPE,FCPRJCD,FCCOGS,FCMVER,FCLUSER,FCCURR) values(?,?,?,?,?,?,?,?,?,?,?)";
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,comp);
           pstmt.setString(2,tpy);  
           pstmt.setString(3,tpm);
           pstmt.setString(4,region);
           pstmt.setString(5,country);
           pstmt.setString(6,type);
           pstmt.setString(7,a[ac][0]); //MODEL
           pstmt.setString(8,c_in_array); 
		   a[ac][subac]=c_in_array; //將之塞入對應之陣列內容
		   pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinute());
           pstmt.setString(10,UserName);
		   pstmt.setString(11,curr);
  
           pstmt.executeUpdate();
		   pstmt.close();
		} //end of sub for   
	} //enf of for	
  } //end of array if null
  
  out.println("Input COGs of Forecast Data Successfully!!<BR>");
  out.println("<A HREF=../jsp/WSExwPriCogsEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Exworks Price & COGs of Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Sales Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to C&F Sub Menu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  
  
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
