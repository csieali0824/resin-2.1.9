<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<!--% @ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=======To get Connection from different DB======-->
<%@ include file ="/jsp/include/ConnBPCSWww602PoolPage.jsp" %>
<%@ page import="ComboBoxBean" %>

<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<script language="JavaScript" type="text/JavaScript"></script>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Report on Web -DBTEL Incorporated</title>
</head>

<body>
<form action="../jsp/BPCSFinUserProg.jsp" method="post">
<p><A HREF="../BPCSFinMenu.jsp"Fin Menu></A> 

<%
      //String userid=request.getParameter("USERID");
	  //userid = 'T'+userid;
	  String user=request.getParameter("USERID");
	  user = 'T'+user;
	  String comp =request.getParameter("COMP");
	  out.println("<font size='+3'>"+comp+"</font>");
	  String userid="cherry";
	  out.println("<p align='center'><font size='+2'>"+userid+"</font></p>");
	  String comboprog=request.getParameter("COMBOPROG");

%>

<%

    String sData ="N";
    //畫每個人員所有程式清單
    try 
	   {
         String sProgram="",sProgDesc="",sProg="";
		 int nCount=1;
		 
		 sProg="SELECT PROGID,PGDESC FROM USERMENU,PROGMENU WHERE  PROGRAM=PROGID "+
	     "AND USERID='"+userid+"' AND COMPID='"+comp+"' ";
		 //out.println("sProg"+sProg);
		 PreparedStatement ptCount = ifxwwwcon.prepareStatement(sProg);
		 ResultSet rsCount=ptCount.executeQuery();
		 if (rsCount.next())
		    {
			  sData="Y";
			  out.println("<p align='center'><font color='#0000FF' font size='4'>Following are your authorized programs</font></p>");
			}
		 else 
		   {
		     sData="N";
			 out.println("<p align='center'><font color='#0000FF' font size='4'>No authorized program found in this database</font><p>");
			 out.println("<p align='center'><font cloro='#0000FF' font size='4'>Please contact MIS or </font><a href='../jsp/BPCSFinMenu.jsp'>Return to Finincial Menu</a></p>") ;
		   }
		 rsCount.close();
		 ptCount.close();	
		 
		 if (sData =="Y" || sData.equals("Y"))
		   {
	         Statement stProg = ifxwwwcon.createStatement();
	         ResultSet rsProg = stProg.executeQuery(sProg);
		     while (rsProg.next())
		       {
			     if (nCount==1)
			      {
				    out.println("<table width='600' border=1>"); 
				    out.println("<tr><td width='250' height='23' bgcolor='#99CCFF'><font color='#FFFFFF'>PROGRAM ID</font></td>");
                    out.println("<td width='350' height='23' bgcolor='#99CCFF'><font color='#FFFFFF'>PROGRAM DESCRIPTION</font></td></tr></table>");
				  } //end of if
			     sProgram = rsProg.getString(1);
		         sProgDesc = rsProg.getString(2);
	             out.println("<table width='600'  border='1'>");
		         out.println("<tr><td width='250' height='23'>"+sProgram+"</td>");
		         out.println("<td width='350' height='23'>"+sProgDesc+"</td></tr>");
 	             out.println("</table>");
			     nCount = nCount+1;
		     } //end of while
			 
			 //文字說明
			 out.println("<p><table width='480'  align='center' border='0'></p>");
			 out.println("<tr><td height='23' align='center'><font size='4'>Please select one of the programs listed above</font></td></tr>");
             out.println("<tr><td height='23' align='center'><font size='4'>and press <font color='#FF0000'>SUBMIT</font> to execute </font></td></tr>");
			 //combobox 內容
			 String sComboProg="SELECT PROGID,PROGID FROM USERMENU,PROGMENU WHERE  PROGRAM=PROGID "+
	         "AND USERID='"+userid+"' AND COMPID='"+comp+"' ";
		     PreparedStatement ptCombo=ifxwwwcon.prepareStatement(sComboProg);
		     ResultSet rsCombo=ptCombo.executeQuery();
		     comboBoxBean.setRs(rsCombo);		  
		     if (comboprog !=null) comboBoxBean.setSelection(comboprog);
	         comboBoxBean.setFieldName("COMBOPROG");	   
             out.println("<tr><td height='23' align='center'>"+comboBoxBean.getRsString()+"</td></tr>");		 
		     ptCombo.close();
		     rsCombo.close();
             out.println("<tr><td height='23' align='center'><input type='submit' name='submit' value='SUBMIT'></td></tr>");
             out.println("<tr><td height='23' align='center'><font size='4'><a href='../jsp/BPCSFinMenu.jsp'>Return to Finincial Menu</a></font></td></tr>");
			 
		   }//end of if sData	     
	   }//end of try

	   catch (Exception e)
	      {
		   out.println("Exception:"+e.getMessage());
		  }	   
%>
</p>

</form>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSWww602Page.jsp" %>
<!--===========================================-->