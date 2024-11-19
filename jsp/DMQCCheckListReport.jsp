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
		
		if ( sModelNo==null )  { sModelNo = ""; out.println("未傳入MODELNO");}
	%>
</p>
<p><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font> 
  <font color="#000000" size="+2" face="Times New Roman"><strong><%=sModelNo%> 開發問題總覽表</strong></font></p>
<font color="#FFFF00"> 
<%    
                
                String sFRCName = "";

                String sql="SELECT * FROM FILEREFCTL F WHERE  FRMODELNO = '"+sModelNo+"'  AND FRTYPE ='CHECKLIST' AND  FRTRANSDTIME = (SELECT MAX(F2.FRTRANSDTIME) FROM FILEREFCTL F2 WHERE  F2.FRMODELNO = '"+sModelNo+"'  AND F2.FRTYPE ='CHECKLIST' ) ";
                Statement state=dmcon.createStatement(); 
                //out.println(sql);     
                ResultSet rsFRC=state.executeQuery(sql);
                if (rsFRC.next())       
                { 
                  // sFRCName =  rsFRC.getString("FRFILENAME");
				  // out.print("sFRCName:"+sFRCName+"<BR>");
				  // int idxCheckList = sFRCName.indexOf("_");
				  //int nLength = sFRCName.length();
				  //int  nNLength = nLength - idxCheckList - 1
                  //String getFileName = sFRCName.substring(idxCheckList+1, idxCheckList+1+nNLength);
  	              //{out.println("<font size='2'  ><A HREF='/wins/report/"+sModelNo+"_CHECKLIST_"+getDate+".xls'> Excel View</A></font>");}	

				   //String URLStr = "A HREF=/wins/report/"+sModelNo+"CHECKLIST.xls";  
	               //out.println(URLStr);
				    response.setContentType("application/vnd.ms-excel");					
					response.sendRedirect("/wins/report/"+sModelNo+"CHECKLIST.xls");  
					
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