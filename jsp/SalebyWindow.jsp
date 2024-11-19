<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>SalebyWindow.jsp</title>
</head>

<body background="../image/b01.jpg">
<%
 String searchString="";
 String WebID=(String)session.getAttribute("WEBID");
 //out.print(WebID);
try
 {
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select SEARCHSTRING from WSSALESSEARCH WHERE WEBID='"+WebID+"'"); 
   if(rs.next()){
	 searchString = rs.getString("SEARCHSTRING");
   //	out.print(searchString);
	}
	
	if (searchString!="" && searchString!=null) {
	  Statement statementB=ifxdistcon.createStatement();
        //ResultSet rs=statement.executeQuery("select csal,sname,cnme,ccust,ccon,cphon,cmfaxn,cad1,cad2,cad3,crdol from rcm,ssm where trim(csal) like '"+searchString+"%' and csal='"+ssal+"' order by csal,ccust");
       String sql="select csal,sname,cnme,ccust,ccon,cphon,cmfaxn,cad1,cad2,cad3,crdol from rcm,ssm where  csal= '"+searchString+"' and csal=ssal order by csal,ccust";
	
	   ResultSet rs1=statementB.executeQuery(sql);
	      out.println("<a href=../WinsMainMenu.jsp>回首頁</a>");
	   	  out.println("<table width = 150% border=0>");
		  out.println("<tr>");
		  out.println("<td width = 8%  bgcolor=#33CC33>");out.println("業務員代號");out.println("</td>");
		  out.println("<td width = 8% bgcolor=#33CC33>");out.println("業務員");out.println("</td>");
		  out.println("<td width = 13% bgcolor=#33CC33>");out.println("客戶名稱");out.println("</td>");
		  out.println("<td width = 7% bgcolor=#33CC33>");out.println("客戶代號");out.println("</td>");
		  out.println("<td width = 10% bgcolor=#33CC33>");out.println("聯絡人");out.println("</td>");
		  out.println("<td width = 10% bgcolor=#33CC33>");out.println("聯絡電話");out.println("</td>");
		  out.println("<td width = 10% bgcolor=#33CC33>");out.println("傳真");out.println("</td>");
		  out.println("<td width = 20% bgcolor=#33CC33>");out.println("地址1");out.println("</td>");
		  out.println("<td width = 20% bgcolor=#33CC33 nowrap>");out.println("地址2");out.println("</td>");
	      out.println("<td width = 12% bgcolor=#33CC33 nowrap>");out.println("地址3");out.println("</td>");
	      out.println("<td  width =3% bgcolor=#33CC33>");out.println("額度");out.println("</td>");
		  out.println("</tr>");
 
         while(rs1.next())
	     {
		  out.println("<tr>");
		  out.println("<td   >");out.println(rs1.getString("csal"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("sname"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("cnme"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("ccust"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("ccon"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("cphon"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("cmfaxn"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("cad1"));out.println("</td>");
		  out.println("<td  nowrap>");out.println(rs1.getString("cad2"));out.println("</td>");
		  out.println("<td  nowrap>");out.println(rs1.getString("cad3"));out.println("</td>");
		  out.println("<td  >");out.println(rs1.getString("crdol"));out.println("</td>");
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
