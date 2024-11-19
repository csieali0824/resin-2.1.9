<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>Repair System-Action Code Edit Commit Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
     //String localeSet=request.getParameter("LOCALE"); 
	 String RCUST=request.getParameter("RCUST");    
     String CNME=request.getParameter("CNME");
     String RIDTE=request.getParameter("RIDTE");	 
     String RDDTE=request.getParameter("RDDTE");
     String RCURR=request.getParameter("RCURR"); 
	 String RAMT=request.getParameter("RAMT");
     String RCNVFC=request.getParameter("RCNVFC");
     String RCAMT=request.getParameter("RCAMT");
     String SSAL=request.getParameter("SSAL");
	 String version=request.getParameter("FCMVER");
	 String SERIAL=request.getParameter("SERIAL");   	 
	 String DUNCODE2=request.getParameter("DUNCODE2"); 
	 String DUNDESP2=request.getParameter("DUNDESP2");
	 String RECDATE2=request.getParameter("RECDATE2");
	 out.println("DUNCODE2"+DUNCODE2);
	 out.println("DUNDESP2="+DUNDESP2);
	 out.println("RECDATE2"+RECDATE2);
	  out.println(SERIAL); 
	
	 
     
     try
     {   
	     //out.println("DUNDESP2="+DUNDESP2);
		 //if (DUNCODE2==null ||DUNCODE2=="" || DUNCODE2.equals("")){ DUNDESP2=""; }
		 //else if (DUNCODE2=="1" || DUNCODE2.equals("1")) { DUNDESP2="預計5-15天內收回"; }
		 //else if (DUNCODE2=="2" || DUNCODE2.equals("2")) { DUNDESP2="預計15-20天內收回"; }
		 //else if (DUNCODE2=="3" || DUNCODE2.equals("3")) { DUNDESP2="預計20-30天內收回";  }
		 //else if (DUNCODE2=="4" || DUNCODE2.equals("4")) { DUNDESP2="可能收不回,將上簽呈處理"; }
		 //else if (DUNCODE2=="5" || DUNCODE2.equals("5")) { DUNDESP2=DUNDESP2; }
		 //else if (DUNCODE2=="6" || DUNCODE2.equals("6")) { DUNDESP2="已收款未沖帳"; }
		 
		 //if (DUNCODE2==null || DUNCODE2=="" || DUNCODE2.equals("")) { RECDATE2=""; }
		 //else if (DUNCODE2=="1" || DUNCODE2.equals("1")) { dateBean.setAdjDate(15); RECDATE2=dateBean.getYearMonthDay(); }
		 //else if (DUNCODE2=="2" || DUNCODE2.equals("2")) { dateBean.setAdjDate(20); RECDATE2=dateBean.getYearMonthDay(); }
		 //else if (DUNCODE2=="3" || DUNCODE2.equals("3")) { dateBean.setAdjDate(30); RECDATE2=dateBean.getYearMonthDay(); }
		 //else if (DUNCODE2=="4" || DUNCODE2.equals("4")) { RECDATE2="" ; }
		 //else if (DUNCODE2=="5" || DUNCODE2.equals("5")) { RECDATE2=dateBean.getYearMonthDay(); }
		 //else if (DUNCODE2=="6" || DUNCODE2.equals("6")) { RECDATE2="" ; }																											       		
																								
		 
		 
		 
											  													
											 
	   
      // !±o!Psou-!N-i|]¢DDAE
       String sSqUpMAT="update overduear set DUNCODE=?,DUNDESP=?,RECDATE=?,REPLYDATE=? where SERIAL='"+SERIAL+"' ";   
       out.println(sSqUpMAT);
         
       PreparedStatement stmtUpMAT=bpcscon.prepareStatement(sSqUpMAT);             
       stmtUpMAT.setString(1,DUNCODE2); 
	   stmtUpMAT.setString(2,DUNDESP2); 
	   stmtUpMAT.setString(3,RECDATE2); 
	   stmtUpMAT.setString(4,thisDateBean.getYearMonthDay()); 
	   
       //stmtUpMAT.setString(2,dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()); 
       //stmtUpMAT.setString(2,userID);                
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close();      
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%> 
 <input name="RCUST" type="hidden" value="<%=RCUST%>">
 <input name="CNME" type="hidden" value="<%=CNME%>">
 <input name="RIDTE" type="hidden" value="<%=RIDTE%>">  
 <input name="RDDTE" type="hidden" value="<%=RDDTE%>">
 <input name="RCURR" type="hidden" value="<%=RCURR%>">
 <input name="RAMT" type="hidden" value="<%=RAMT%>">  
 <input name="RCNVFC" type="hidden" value="<%=RCNVFC%>">
 <input name="RCAMT" type="hidden" value="<%=RCAMT%>"> 
 <input name="SSAL" type="hidden" value="<%=SSAL%>"> 
 <input name="SERIAL" type="hidden" value="<%=SERIAL%>">
 <input name="DUNCODE2" type="hidden" value="<%=DUNCODE2%>">
 <input name="DUNDESP2" type="hidden" value="<%=DUNDESP2%>"> 
 <input name="RECDATE2" type="hidden" value="<%=RECDATE2%>">  

  
<%
// response.sendRedirect("../jsp/WSARMaintenance.jsp?RCUST="+RCUST+"&CNME="+CNME+"&DUNCODE2="+DUNCODE2+"&DUNDESP2="+DUNDESP2+"&RECDATE2="+RECDATE2+"&RIDTE="+RIDTE+"&RDDTE="+RDDTE+"&RCURR="+RCURR+"&RAMT="+RAMT+"&RCNVFC="+RCNVFC+"&RCAMT="+RCAMT+"&SSAL="+SSAL+"&SERIAL="+SERIAL);	 
%>
</body>
<!--=============¢FFDH?U¢FFXI?q?¢FFXAAcn3s¢FGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
