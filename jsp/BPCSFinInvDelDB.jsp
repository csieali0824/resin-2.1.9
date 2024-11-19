<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>BPCS 財務發票刪除功能</title>
</head>

<body>
<%
      int ninputVendor=request.getParameter("VENDOR");
	  String sinputInv=request.getParameter("INVOICE");
	  out.println("vendor"+ninputVendor+"<br>"+"invoice"+sinputInv);
%>
<%
      String sinv="",ssqlAtx="",ssqlApo="",ssqlApl="",ssqlAph="",ssqlGxr="";
	  int nvendor;
	  float famt;
	  
	  try
	  {
           String ssql="SELECT apvndr,apinv,apcina FROM aph WHERE apvndr="+ninputVendor+" AND apinv='"+sinputInv+"' ";
		   PreparedStetement ptment=dfcon.prepareStatement(ssql);
		   ResultSet rs=ptment.executeQuery();
		   if (rs.next())
		   {
		       nvendor=rs.getInt("apvndr");
			   sinv=rs.getString("apinv");
			   famt=rs.getFloat("apcina");
			   out.println("nvendor"+nvendor+"<br>"+"sinv"+sinv+"<br>"+"famt"+famt);
			   
			   ssqlAtx="DELETE FROM atx WHERE txvndr="+nvendor+" AND txinv='"+sinv+"' ";
			   PreparedStatement ptmentDel=dfcon.prepareStatement();
			   ptmentDel.executeUpdate(ssqlAtx);
               ptmentDel.close();
			   
			   ssqlApo="DELETE FROM apo WHERE apovnd="+nvendor+" AND aporef='"+sinv+"' ";
			   ptmentDel=dfcon.prepareStatement();
			   ptmentDel.executeUpdate(ssqlApo);
               ptmentDel.close();
			   
			   ssqlApl="DELETE FROM apl WHERE plvndr="+nvendor+" AND plinv='"+sinv+"' ";
			   ptmentDel=dfcon.prepareStatement(ssqlApl);
			   ptmentDel.close();
			   
			   ssqlAph="DELETE FROM aph WHERE apvndr="+nvendor+" AND apinv='"+sinv+"' ";
			   ptmentDel=dfcon.prepareStatement(ssqlAph);
			   ptmentDel.close();
			   
			   ssqlGxr="DELETE FROM gxr WHERE xrhvnd="+nvendor+"  AND xrinv='"+sinv+"' ";
               ptmentDel=dfcon.prepareStatement(ssqlGxr);
			   ptmentDel.close();  
			   out.println("發票 : "+sinv+" 刪除成功!!" );
			   
		   }//end of if
		   else 
		   {
		       out.println("無發票資料,請重新輸入!!");
			   response.sendRedirect("BPCSFinInvDelInput.jsp");
		   }
		   ptment.close();
		   rs.close();
	  }//end of try
	  catch (Exception e)
	  {
		  PoolBean.releaseConnection(dfcon);
	      out.println(e.getMessage());
	  }


      
%>
</body>
</html>
