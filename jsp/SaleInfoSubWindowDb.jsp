<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SaleInfoSubWindowDb</title>
</head>

<body>
<%
       String searchString=request.getParameter("SEARCHSTRING");

      //out.print("searchString"+searchString);
      try
      { 
	  if (searchString!="" && searchString!=null) {
	  Statement statement= ifxdistcon.createStatement();
        //ResultSet rs=statement.executeQuery("select csal,sname,cnme,ccust,ccon,cphon,cmfaxn,cad1,cad2,cad3,crdol from rcm,ssm where trim(csal) like '"+searchString+"%' and csal='"+ssal+"' order by csal,ccust");
       String sql="select csal,sname,cnme,ccust,ccon,cphon,cmfaxn,cad1,cad2,cad3,crdol from rcm,ssm where  csal= '"+searchString+"' and csal=ssal order by csal,ccust";
	
	   ResultSet rs=statement.executeQuery(sql);
	   
	   /*while(rs1.next()){
	   String csal=rs1.getString("csal");
	   String sname=rs1.getString("sname");
	   String cnme=rs1.getString("cnme");
	   String ccust=rs1.getString("ccust");
	   String ccon=rs1.getString("ccon");
	   String cphon=rs1.getString("cphon");
	   String cmfaxn=rs1.getString("cmfaxn");
	   String cad1=rs1.getString("cad1");
	   String cad2=rs1.getString("cad2");
	   String cad3=rs1.getString("cad3");
	   String crdol=rs1.getString("crdol");
	   
	   
	   out.print(csal+sname+cnme+ccust+ccon+cphon+cmfaxn+cad1+cad2+cad3+crdol+"<br>");*/
	   
	      out.println("<a href=../WinsMainMenu.jsp>回首頁</a>");
	   	  out.println("<table width = 100% border=1>");
		  out.println("<tr>");
		  out.println("<td width = 8%  height='10' bgcolor=#6699FF><font size='2'>");out.println("業務員代號");out.println("</td>");
		  out.println("<td width = 10% height='10' bgcolor=#6699FF><font size='2'>");out.println("業務員");out.println("</td>");
		  out.println("<td width = 9% height='10' bgcolor=#6699FF><font size='2'>");out.println("客戶名稱");out.println("</td>");
		  out.println("<td width = 8% height='10' bgcolor=#6699FF><font size='2'>");out.println("客戶代號");out.println("</td>");
		  out.println("<td width = 8% height='10' bgcolor=#6699FF><font size='2'>");out.println("聯絡人");out.println("</td>");
		  out.println("<td width = 7% height='10' bgcolor=#6699FF><font size='2'>");out.println("聯絡電話");out.println("</td>");
		  out.println("<td width = 7% height='10' bgcolor=#6699FF><font size='2'>");out.println("傳真");out.println("</td>");
		  out.println("<td width = 20% height='10' bgcolor=#6699FF><font size='2'>");out.println("地址1");out.println("</td>");
		  out.println("<td width = 10% height='10' bgcolor=#6699FF nowrap><font size='2'>");out.println("地址2");out.println("</td>");
	      out.println("<td width = 10% height='10' bgcolor=#6699FF nowrap><font size='2'>");out.println("地址3");out.println("</td>");
	      out.println("<td  width =3% height='10' bgcolor=#6699FF><font size='2'>");out.println("額度");out.println("</td>");
		  out.println("</tr>");
		  while(rs.next())
	     {
		  out.println("<tr>");
		  out.println("<td  width = 8% ><font size='2'>");out.println(rs.getString("csal"));out.println("</td>");
		  out.println("<td  width = 10% ><font size='2'>");out.println(rs.getString("sname"));out.println("</td>");
		  out.println("<td  width = 9% ><font size='2'>");out.println(rs.getString("cnme"));out.println("</td>");
		  out.println("<td  width = 8% ><font size='2'>");out.println(rs.getString("ccust"));out.println("</td>");
		  out.println("<td  width = 8% ><font size='2'>");out.println(rs.getString("ccon"));out.println("</td>");
		  out.println("<td  width = 7% ><font size='2'>");out.println(rs.getString("cphon"));out.println("</td>");
		  out.println("<td  width = 7% ><font size='2'>");out.println(rs.getString("cmfaxn"));out.println("</td>");
		  out.println("<td  width = 20% ><font size='2'>");out.println(rs.getString("cad1"));out.println("</td>");
		  out.println("<td  width = 10% ><font size='2'>");out.println(rs.getString("cad2"));out.println("</td>");
		  out.println("<td  width = 10% ><font size='2'>");out.println(rs.getString("cad3"));out.println("</td>");
		  out.println("<td  width = 3% ><font size='2'>");out.println(rs.getString("crdol"));out.println("</td>");
		  out.println("</tr>");
	     }//end of while
	      out.println("</table>");
	   }//end of if
	 }//end of try
	 catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());
      }
%>
</body>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
</html>
