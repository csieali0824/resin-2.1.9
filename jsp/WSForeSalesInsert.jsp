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
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");
String type=request.getParameter("TYPE");

String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="",weekSql="";  
   if (a!=null) 
   {   
     String ym[]=forePriCostInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)     
	 { 	
	   String fmPrjcd=a[ac][0].substring(0,a[ac][0].indexOf("@"));
	   String fmColor=a[ac][0].substring(a[ac][0].indexOf("@")+1); 
	   for (int subac=1;subac<a[ac].length;subac++)
	   {
	     String tpym=ym[subac+1]; 
	     String tpy=tpym.substring(0,4); //get year String
		 String tpm=tpym.substring(5,7); //get month String
		 workingDateBean.setWorkingDate(Integer.parseInt(tpy),Integer.parseInt(tpm),1); //設定成當月日期
		 
		 String qty_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位				 
           sql="insert into PSALES_FORE_MONTH(FMCOMP,FMYEAR,FMMONTH,FMREG,FMCOUN,FMTYPE,FMPRJCD,FMQTY,FMVER,FMLUSER,FMLDATE,FMCOLOR) values(?,?,?,?,?,?,?,?,?,?,?,?)";
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,comp);
           pstmt.setString(2,tpy);  
           pstmt.setString(3,tpm);
           pstmt.setString(4,region);
           pstmt.setString(5,country);
           pstmt.setString(6,type);
           pstmt.setString(7,fmPrjcd); //MODEL
           pstmt.setString(8,qty_in_array); 
		   a[ac][subac]=qty_in_array; //將之塞入對應之陣列內容
		   pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinute());
           pstmt.setString(10,UserName);
		   pstmt.setString(11,dateBean.getYearMonthDay());
		   pstmt.setString(12,fmColor); //COLOR		     
           pstmt.executeUpdate();	
		   pstmt.close();		   
		   
		   //-----------以下為寫入當月的forecast將之分為各該當月的工作週數--------- 
		   String weekArray[]= workingDateBean.getWWArrayOfMonth(Integer.parseInt(tpm));
		   int weekNo=weekArray.length;		   
		   for (int wn=0;wn<weekNo;wn++) 	 
		   {
		     weekSql="insert into PSALES_FORE_WEEK(FWCOMP,FWYEAR,FWMONTH,FWREG,FWCOUN,FWTYPE,FWPRJCD,FWQTY,FWORKWEEK,FWWVER,FWLUSER,FWCOLOR) values(?,?,?,?,?,?,?,?,?,?,?,?)";
             PreparedStatement weekPstmt=con.prepareStatement(weekSql);  
             weekPstmt.setString(1,comp);
             weekPstmt.setString(2,tpy);  
             weekPstmt.setString(3,tpm);
             weekPstmt.setString(4,region);
             weekPstmt.setString(5,country);
             weekPstmt.setString(6,type);
             weekPstmt.setString(7,fmPrjcd); //MODEL			 
			 float qqty=Float.parseFloat(qty_in_array)/weekNo;//因為是工作週,故數量要除以工作週數 
             weekPstmt.setFloat(8,qqty);		   
		     weekPstmt.setString(9,tpy.substring(3,4)+weekArray[wn]);
             weekPstmt.setString(10,dateBean.getYearMonthDay()+dateBean.getHourMinute());
             weekPstmt.setString(11,UserName);  
			 weekPstmt.setString(12,fmColor); //COLOR		
             weekPstmt.executeUpdate();			 
			 weekPstmt.close();
		   } //end of weekArray for
		   //---------------------------------------------------------- 		   
		} //end of sub for   		
	} //enf of for	
  } //end of array if null
  
  out.println("Input Monthly Forecast Data Successfully!!<BR>");
  out.println("<A HREF=../jsp/WSForecastEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Sales Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to SubMenu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");    
  
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
