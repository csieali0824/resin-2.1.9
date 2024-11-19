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
<title>WINS system - Price Segment Data Insert</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%

String region=request.getParameter("REGION");
String type=request.getParameter("TYPE");
String curr=request.getParameter("CURR");
String brand="DBTEL";  

String a[][]=forePriCostInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="";  
   if (a!=null) 
   {   
     String ym[]=forePriCostInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	 
	   for (int subac=1;subac<a[ac].length;subac=subac+2)
	   {
	     String tpym=ym[subac+1]; 
	     String tpy=tpym.substring(5,7).trim(); //get Segment String
         if ( (a[ac][subac]=="0" || a[ac][subac].equals("0") ) && (a[ac][subac+1]=="0" || a[ac][subac+1].equals("0") ) ) {  /* Don't inser while user didn't input any values */ }
         else {
		 //String tpm=tpym.substring(5,7); //get month String
		   String c_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位
          // sql="insert into PSALES_FORE_COST(FCCOMP,FCYEAR,FCMONTH,FCREG,FCCOUN,FCTYPE,FCPRJCD,FCCOST,FCMVER,FCLUSER,FCCURR) values(?,?,?,?,?,?,?,?,?,?,?)";
           sql="insert into PSALES_PRICE_SGMNT(SREGION,SCOUNTRY,SG_BRAND,SEGMENT,SGMNT_FR,SGMNT_TO,GDATE,GUSER) values(?,?,?,?,?,?,?,?)";           
           //out.println("sql="+sql);      
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,region); //out.println("region="+region);    
           pstmt.setString(2,a[ac][0]); //out.println("a[ac][0]="+a[ac][0]);//country
           pstmt.setString(3,brand); //out.println("brand="+brand);   
           pstmt.setString(4,tpy);  //out.println("tpy="+tpy); // 取得 Content 上 Segment 的內容
		   //pstmt.setString(4,c_in_array); out.println("c_in_array="+c_in_array); // 取得 Content 上 Segment 的內容
           pstmt.setString(5,a[ac][subac]); //out.println("a[ac][subac]="+a[ac][subac]);
           pstmt.setString(6,a[ac][subac+1]);   //out.println("a[ac][subac+1]="+a[ac][subac+1]);                    
           pstmt.setString(7,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());
           pstmt.setString(8,userID); //out.println("userID="+userID);          
       
           pstmt.executeUpdate();
		   pstmt.close();
          }  // end of else (line not null segment )
		} //end of sub for   
	} //enf of for	
  } //end of array if null
  
  out.println("Input PRICE SEGMENT Data Successfully!!<BR>");
  out.println("<A HREF=/wins/WinsMainMenu.jsp>HOME</A>");
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSPriceSegmentEntry.jsp>PRICE SEGMENT DATA INPUT PAGE</A>");
  out.println("&nbsp;&nbsp;");
  out.println("<A HREF=/wins/jsp/WSPriceSegmentMaintHView.jsp>PRICE SEGMENT INQUIRY</A>");
  
  
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