<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<html>
<head>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Product Detail Schedule </title>
</head>

<body>
<p><A HREF='../WinsMainMenu.jsp'>HOME</A>
  <% 
		//取得傳入參數
		String sModelNo=request.getParameter("MODELNO");
		
		if ( sModelNo==null )  { sModelNo = ""; out.println("沒有紀錄");}
	%>
</p>
<p><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font> 
  <font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> Product Detail Schedule Report</strong></font></p>
<font color="#6699CC"> 
<%    
                String sFRCName = "";

                String sql="SELECT * FROM FILEREFCTL WHERE  FRMODELNO = '"+sModelNo+"'  AND FRTYPE ='PDS' AND  FRTRANSDTIME = (SELECT MAX(FRTRANSDTIME) FROM FILEREFCTL WHERE  FRMODELNO = '"+sModelNo+"' AND FRTYPE ='PDS' )  ";
                Statement state=dmcon.createStatement(); 
                //out.println(sql);     
                ResultSet rsFRC=state.executeQuery(sql);
                if (rsFRC.next())       
                 { 
                  //sFRCName =  rsFRC.getString("FRFILENAME");
				  // int idxPDS =sFRCName.indexOf("PDS_");
                  // String getDate = sFRCName.substring(idxPDS+4, idxPDS+4+8);
                  //out.println("getDate = "+getDate);
	              //upload_file.saveAs("c://clientupload/"+sModelNo+"_PDS_"+getDate); // save file o server
            	  //{out.println("<font size='2'  ><A HREF='/wins/report/"+sModelNo+"_PDS_"+getDate+".xls'> Excel View</A></font>");}					
				  //String URLStr = "http://winstst.dbtel.com.tw/wins/report/"+sModelNo+"_PDS_"+getDate+".xls";
	               //out.println(URLStr);
				    response.setContentType("application/vnd.ms-excel");					
				    //response.sendRedirect("http://winstst.dbtel.com.tw/wins/report/"+sModelNo+"_PDS_"+getDate+".xls"); 
					response.sendRedirect("/wins/report/"+sModelNo+"PDS.xls");
                 }
			     	else { out.println("沒有紀錄"); }
                rsFRC.close();
                state.close();       

  %>
	    
      
</font>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->