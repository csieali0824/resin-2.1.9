<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=======To get Connection from different DB======-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp" %>
<%@ page import="ComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Report on Web -DBTEL Incorporated</title>
</head>

<body>
<table width="100%" border="0">

</table>


<%

    String userid=(String)session.getAttribute("WEBID");
	out.println("userid"+userid);
	String userName=(String)session.getAttribute("USERNAME"); 
	out.println("UserName"+UserName);
	String userRole=(String)session.getAttribute("USERROLES"); 
	out.println("userRole"+userRole);
	String comp=request.getParameter("COMP");

%>
<form action="../jsp/BPCSFinUserMenu.jsp?USERID=<%=userid%>" method="post">
<a href="../WinsMainMenu.jsp">HOME</a>

<%
        
     String  arrayRole[]=userRole.split(",");
     try
     {
		for (int i=0;i< arrayRole.length;i++)
		String ssqlRoleComp="SELECT comp FROM wsrole_comp WHERE role_name ='"+arrayRole[i]+"' AND comp ='*' ";
		PreparedStatement pt=con.prepareStatement(ssqlRoleComp);
        ResultSet rs=pt.executeQuery();
        if (rs.next())
        {   
			 
             String ssqlcomp="SELECT mccomp as COMP,mcdesc as COMPDESC FROM wsmulti_comp  "+
			                   "WHERE  trim(MCSERVER)='dbtah0172' and trim(mccomp) !='00' ORDER BY MCCOMP";
             PreparedStatement ptcomp=con.prepareStatement(ssqlcomp);			  
             ResultSet rscomp=ptcomp.executeQuery();
		     //out.println("<select NAME='COMP' onChange='setSubmit2("+'"'+"../jsp/WSShippingInputEntry.jsp"+'"'+")'>");
			 out.println("<select NAME='COMP' ");
             out.println("<OPTION VALUE=-->--");     
             while (rscomp.next())
             {            
                   String s1=(String)rs.getString(1).trim(); 
                   String s2=(String)rs.getString(2).trim(); 
                        
                   if (s1.equals(comp)) 
                   {
                       out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                   } 
                   else 
                   {
                       out.println("<OPTION VALUE='"+s1+"'>"+s2);
                   }        
             } //end of while
			 out.println("</select>"); 	  		  		  
  		    ptcomp.close();        
            rscomp.close();    
		 
        }//end of if
        pt.close();
        rs.close();
     }//end of try		
      catch (Exception e)
     {
		  out.println("Exception :"+e.getMessage());
     }
	   
%>


<p><input type="submit" name="submit" value="SUBMIT"></p>

<table width="391">
    <tr><td width="381" height="34"><p><font color="#3333FF">大霸集團 版權所有</font></p></td></tr>
</table>

</form>

</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp" %>
<!--===========================================-->