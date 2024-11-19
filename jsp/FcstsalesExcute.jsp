<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%//@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>

<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<!--=================================-->
</head>

<body>
<%
        	
    try 
    {   int fcstyear=0;	
	     int fcstmon=0;
	     String modelno=null; 		
	     String prodcol=null; 
	     String fcstto=null; 
	      int fcstqty=0; 
	      float fcstpric=0; 
	    String sSql= "Select distinct FMYEAR,FMMONTH,FMPRJCD,COLORDESC,FMCOUN,FMQTY,FPPRI"+ " "+
                         "from PSALES_FORE_MONTH Q,PICOLOR_MASTER C ,PSALES_FORE_PRICE P  " ;
	    String sWhere="WHERE FMCOLOR=COLORCODE "+ " "+
                          "AND Q.FMVER=(SELECT MAX(FMVER) FROM PSALES_FORE_MONTH WHERE FMYEAR=Q.FMYEAR  AND FMMONTH= Q.FMMONTH"+ " "+
                          "AND FMPRJCD= Q.FMPRJCD AND FMCOLOR=Q.FMCOLOR AND FMCOUN=Q.FMCOUN"+ " "+
                          "AND FMREG=Q.FMREG ) AND Q.FMQTY>0"+ " "+
                          "AND P.FPPRJCD=Q.FMPRJCD "+ " "+
                          "AND P.FPCOUN=Q.FMCOUN"+ " "+
                          "AND P.FPYEAR=Q.FMYEAR  AND P.FPMONTH=Q.FMMONTH"+ " "+
                          "AND P.FPREG=Q.FMREG"+ " "+      
                          "AND P.FPMVER=(SELECT MAX(FPMVER) FROM PSALES_FORE_PRICE WHERE FPYEAR=P.FPYEAR  AND FPMONTH=P.FPMONTH"+ " "+
                          "AND  FPPRJCD=P.FPPRJCD  AND  FPCOUN=P.FPCOUN"+ " "+
                          "AND  FPREG=P.FPREG )  AND P.FPPRI>0 "; 
	   String sOrderTC = "order by 1,2,3 asc";
	   sSql=sSql+sWhere+sOrderTC; 
	  //out.println(sSql);      
      Statement statement=con.createStatement();
	  
	  ResultSet rs=statement.executeQuery(sSql);
	  String sqld="delete from Fcstsales";   
      PreparedStatement dstmt=dmcon.prepareStatement(sqld);      
      dstmt.executeUpdate();           
      dstmt.close();
	    
		 while (rs.next())
	     {		  
	       fcstyear=rs.getInt("FMYEAR");
		   fcstmon= rs.getInt("FMMONTH");
		   modelno= rs.getString("FMPRJCD");	 
		   prodcol= rs.getString("COLORDESC");	
		   fcstto= rs.getString("FMCOUN");	  
		   fcstqty=rs.getInt("FMQTY"); 
		   fcstpric=rs.getFloat("FPPRI"); 
		  // out.println(fcstyear);      
		   String sql="insert into Fcstsales(fcstyear,fcstmon,modelno,prodcol,fcstto,fcstqty,fcstpric) values(?,?,?,?,?,?,?)";
		   //out.println(sql); 
           PreparedStatement fcststmt=dmcon.prepareStatement(sql);   
           fcststmt.setInt(1,fcstyear);
           fcststmt.setInt(2,fcstmon);
           fcststmt.setString(3,modelno); 
           fcststmt.setString(4,prodcol); 
           fcststmt.setString(5,fcstto); 
           fcststmt.setInt(6,fcstqty); 
		   fcststmt.setFloat(7,fcstpric); 
		         
           fcststmt.executeUpdate();		  
		   fcststmt.close();   		 
		  }
           
	statement.close();
	rs.close();
        
		} //end of try
          catch (Exception e)
          {
           e.printStackTrace();
           out.println(e.getMessage());
          }//end of catch


%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%//@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>

<!--=================================-->
</html>
