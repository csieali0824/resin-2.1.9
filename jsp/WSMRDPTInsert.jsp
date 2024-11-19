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
<title>產品研發單位新增</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>
<body>
<%
String comp=request.getParameter("COMP");
String rddpt_No=request.getParameter("RDDPT_NO");
String rd_Code=request.getParameter("RD_CODE");
String rddpt=request.getParameter("RDDPT");
String rddpr_Desc=request.getParameter("RDDPR_DESC");

String a[][]=array2DimensionInputBean.getArray2DContent();//取得目前陣列內容

try
{  
  String sql="";  
   if (a!=null) 
   {   
     String ym[]=array2DimensionInputBean.getArrayContent();   
     for (int ac=0;ac<a.length;ac++)
     { 	 
	   //for (int subac=1;subac<a[ac].length;subac++)
	   //{
	     //String tpym=ym[subac+1]; 
	     //String tpy=tpym.substring(0,4); //get year String
		 //String tpm=tpym.substring(5,7); //get month String
		 //String c_in_array=request.getParameter("MONTH"+ac+"-"+subac);//取前一頁之輸入欄位
          // sql="insert into PSALES_FORE_COST(FCCOMP,FCYEAR,FCMONTH,FCREG,FCCOUN,FCTYPE,FCPRJCD,FCCOST,FCMVER,FCLUSER,FCCURR) values(?,?,?,?,?,?,?,?,?,?,?)";
           sql="insert into MRDPT(RD_CODE,RDDPT_NO,RDDPT,RDDPR_DESC) values(?,?,?,?)";
           //sql="insert into PRPRODUCT_CENTER(INTER_MODEL,CREATE_USER) values(?,?)";
           PreparedStatement pstmt=con.prepareStatement(sql);  
           pstmt.setString(1,a[ac][0]);
           pstmt.setString(2,a[ac][1]);  
           pstmt.setString(3,a[ac][2]);           
           pstmt.setString(4,a[ac][3]);           
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
		//} //end of sub for   
	} //enf of for	
  } //end of array if null
  
  out.println("輸入產品研發單位新增成功 !!!<BR>");
  out.println("<A HREF=/wins/WinsMainMenu.jsp>首頁</A>&nbsp;&nbsp;<A HREF=../jsp/WSMRDPTInput.jsp?BACK=TRUE>產品研發單位代碼資料新增</A>&nbsp;&nbsp;<A HREF='../jsp/WSMRDPTInquiry.jsp'>產品研發單位查詢</A> ");
  
  
   if (a!=null) //印出bean內中之資訊
  {      
     out.println("<BR><FONT color='BLUE'>==============Detail of Data Inputed =====================</FONT>");				 			 	   			 
     out.println(array2DimensionInputBean.getResultString());		  		   	 
     array2DimensionInputBean.setArray2DString(null);
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
