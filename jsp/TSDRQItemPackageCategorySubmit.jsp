<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<html>
<head>
<title>Item Package Category Packing Code Edit Submit</title>
</head>
<body>
<%
     //String localeSet=request.getParameter("LOCALE");     

     String intType=request.getParameter("INTTYPE");
     String packClass=request.getParameter("PACKCLASS");
	 String outline=request.getParameter("OUTLINE");  
     String packageCode=request.getParameter("PACKCODE"); 
	 String prodType=request.getParameter("PRODTYPE");
	 String reel=request.getParameter("REEL");   
	 String carton=request.getParameter("CARTON"); 
     String mUser=request.getParameter("MUSER");
     String mDate=request.getParameter("MDATE");
     String mTime=request.getParameter("MTIME");
	 
	// out.print("active:"+active);
     
     //if (modelCode==null || itemNo.equals("")) { itemNo= ""; }
     //if (symptomCode==null || symptomCode.equals("") ) { symptomCode= ""; }    
     
     try
     {  
      // ¥y§o·sou-×RA¥o¥DAE
       String sSqUpMAT="update ORADDMAN.TSITEM_PACKING_CATE set PROD_TYPE=?, REEL=?, CARTON=?, LAST_UPDATE_DATE=?, LAST_UPDATED_BY=? where INT_TYPE='"+intType+"' and PACKING_CLASS='"+packClass+"' and OUTLINE='"+outline+"' and PACKAGE_CODE='"+packageCode+"' ";   
       //out.println(sSqUpMAT+" "+intType+" "+packClass+" "+outline+" "+packageCode+"--> "+prodType+"--> "+reel+"--> "+carton);
       //out.println("<BR>"+mUser+" ");  
       PreparedStatement stmtUpMAT=con.prepareStatement(sSqUpMAT); 
       stmtUpMAT.setString(1,prodType);
       stmtUpMAT.setString(2,reel);
       stmtUpMAT.setString(3,carton);
	   stmtUpMAT.setString(4,mDate+mTime);
	   stmtUpMAT.setString(5,mUser);                   
       stmtUpMAT.executeUpdate();
       stmtUpMAT.close(); 
          
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     } 
     
%>  
 
<%
  response.sendRedirect("../jsp/TSDRQItemPackageCategorySetting.jsp?INTTYPE="+intType+"&PACKCLASS="+packClass);	 
%>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

