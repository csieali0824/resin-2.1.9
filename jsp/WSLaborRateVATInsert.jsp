<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ page import="DateBean,Array2DimensionInputBean" %>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>WINS system - Price Segment Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String comp=request.getParameter("COMP");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");
String type=request.getParameter("TYPE");
String curr=request.getParameter("CURR");
//String cUser=request.getParameter("CUSER");

   String userID=""; 

   String sSql = "select WEBID from WSUSER ";
   String sWhere= "where USERNAME='"+UserName+"' "; 
   sSql = sSql+sWhere;		  
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery(sSql);
   if (rs.next()) { userID = rs.getString(1); }
   rs.close();
   statement.close();

String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="";  
   if (a!=null) 
   {   
     String ym[]=array2DimensionInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	 
	   for (int subac=2;subac<a[ac].length;subac=subac+2)
	   {
	     String tpym=ym[subac+1]; 
	     String tpy=tpym.substring(5,7).trim(); //get Segment String         
	     String tpyear=tpym.substring(50,54); //get year String 取年月,跳過<font color='#FFFF00'><div align='center'><strong> //
		 String tpmonth=tpym.substring(55,57); //get month String,跳過<font color='#FFFF00'><div align='center'><strong> //
         //out.println(tpyear+" "+tpmonth);
           
		 //String tpm=tpym.substring(5,7); //get month String
		 //String c_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位
          // sql="insert into PSALES_FORE_COST(FCCOMP,FCYEAR,FCMONTH,FCREG,FCCOUN,FCTYPE,FCPRJCD,FCCOST,FCMVER,FCLUSER,FCCURR) values(?,?,?,?,?,?,?,?,?,?,?)";
           sql="insert into PSALES_LBLRATE_VAT(REGION,COUNTRY,INT_MODEL,SYEAR,SMONTH,LBL_LOAD,EXRATE,VAT,MTDATE,MTUSER) values(?,?,?,?,?,?,?,?,?,?)";
           //sql="insert into PRPRODUCT_CENTER(INTER_MODEL,CREATE_USER) values(?,?)";
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,region);
           pstmt.setString(2,country);
           pstmt.setString(3,a[ac][0]);  
           pstmt.setString(4,tpyear);  // 取得 Content 上 Segment 的內容
           pstmt.setString(5,tpmonth);
           pstmt.setString(6,a[ac][subac]);
           pstmt.setString(7,a[ac][subac+1]);
           pstmt.setString(8,a[ac][1]);                       
           pstmt.setString(9,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
           pstmt.setString(10,userID);    
          
         /* 
           pstmt=con.prepareStatement(sql);  
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
         */
           pstmt.executeUpdate();
		   pstmt.close();
		} //end of sub for   
      // 外圈,(即陣列的列)同時寫入一筆 VAT 於 VAT MASTER FILE 起 
        try
        {  PreparedStatement pstmtVAT=null;
           String sqlVAT="insert into PSALES_VAT_MASTER(REGION,COUNTRY,VAT) values(?,?,?)";
           //sql="insert into PRPRODUCT_CENTER(INTER_MODEL,CREATE_USER) values(?,?)";
           pstmtVAT=con.prepareStatement(sqlVAT);  
           pstmtVAT.setString(1,region);
           pstmtVAT.setString(2,country);
           pstmtVAT.setString(3,a[ac][1]); 
           pstmtVAT.executeUpdate();
           pstmtVAT.close();   
        } //end of try
        catch (Exception e)
        {
         out.println(e.getMessage());
        }//end of catch
      // 外圈,(即陣列的列)同時寫入一筆 VAT 於 VAT MASTER FILE 起
	} //enf of for	
  } //end of array if null
  
  out.println("Input LABOR LOAD 、RATE、VAT Data Successfully!!<BR>");
  //out.println("<A HREF=../jsp/WSForePriCostEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Price & Cost of Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastEntry.jsp?COMP="+comp+"&TYPE="+type+"&REGION="+region+"&COUNTRY="+country+">Sales Forecast data Entry</A>&nbsp;&nbsp;<A HREF=../jsp/WSForecastMenu.jsp>Back to C&F Sub Menu</A>&nbsp;&nbsp;<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSLaborRateVATEntry.jsp>FORECAST LABOR LOAD(RATE、VAT) DATA INPUT PAGE</A>");
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSLaborRateVATMaintence.jsp>FORECAST LABOR LOAD(RATE、VAT) INQUIRY</A>");
  
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(array2DimensionInputBean.getResultString());		
     array2DimensionInputBean.setArray2DString(null);  // 印完後即釋放arrayBean的內容		   	 
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
