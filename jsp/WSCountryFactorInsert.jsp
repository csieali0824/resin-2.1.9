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
<title>WINS system - Country Factor Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String baseCountry=request.getParameter("BASECOUNTRY");
String region=request.getParameter("REGION");
String curr=request.getParameter("CURR");
String brand=request.getParameter("BRAND");  

String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql=""; 
  String c_in_array=""; 
   if (a!=null) 
   {          
     for (int ac=0;ac<a.length;ac++)
     { 	 	           
        sql="insert into PSALES_COUNTRY_FACTOR(BASECOUNTRY,REGION,BRAND,COUNTRY,EXW_ADJ,VAT,LL_BASECOUN,LL_COUN_ADJ,EX_RATE,CURR) values(?,?,?,?,?,?,?,?,?,?)";           
        PreparedStatement pstmt=con.prepareStatement(sql);
		pstmt.setString(1,baseCountry);  
        pstmt.setString(2,region);
		pstmt.setString(3,brand);
        pstmt.setString(4,a[ac][0]); //country
		c_in_array=request.getParameter("MONTH"+ac+"-1");//取前一頁之輸入欄位 
		a[ac][1]=c_in_array; //將之塞入對應之陣列內容
		pstmt.setString(5,c_in_array); //exw_adj or ship-out adj
		
		c_in_array=request.getParameter("MONTH"+ac+"-2");//取前一頁之輸入欄位 
		a[ac][2]=c_in_array; //將之塞入對應之陣列內容
		float f_vat=Float.parseFloat(c_in_array);
		pstmt.setFloat(6,f_vat/100); //VAT
		
		c_in_array=request.getParameter("MONTH"+ac+"-3");//取前一頁之輸入欄位 
		a[ac][3]=c_in_array; //將之塞入對應之陣列內容
		pstmt.setString(7,c_in_array); //l&l of basecountry  
		
		c_in_array=request.getParameter("MONTH"+ac+"-4");//取前一頁之輸入欄位 
		a[ac][4]=c_in_array; //將之塞入對應之陣列內容
		pstmt.setString(8,c_in_array); //l&l country adj
		
		c_in_array=request.getParameter("MONTH"+ac+"-5");//取前一頁之輸入欄位 
		a[ac][5]=c_in_array; //將之塞入對應之陣列內容
		pstmt.setString(9,c_in_array); //exchange rate	   
	   pstmt.setString(10,curr);
	   
	   pstmt.executeUpdate();	
	   pstmt.close();  
	} //enf of for	
  } //end of array if null
  
  out.println("Input COUNTRY FACTOR Data Successfully!!<BR>");
  out.println("<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSCountryFactorEntry.jsp>COUNTRY FACTOR ENTRY PAGE</A>");
  out.println("&nbsp;&nbsp;");      
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(forePriCostInputBean.getResultString());		
     forePriCostInputBean.setArray2DString(null);  // 印完後即釋放arrayBean的內容		   	 
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