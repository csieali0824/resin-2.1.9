<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<title>無標題文件</title>
</head>

<body>

<%
  int requestID  = 0;

                            String sqlfnd = " select USER_ID   from APPS.FND_USER A, ORADDMAN.WSUSER B "+
 						   		 	        " where A.USER_NAME = UPPER(B.USERNAME)  and B.USERNAME = '"+UserName+ "'";
						    Statement stateFndId=con.createStatement();
                            ResultSet rsFndId=stateFndId.executeQuery(sqlfnd);
						    //out.println("sqlfnd="+sqlfnd);
		                    if (rsFndId.next())
		                    {		                      						
						       // run "Receiving Transaction Processor"
						       CallableStatement cs4 = con.prepareCall("{call TSC_CALL_RCV_REQUEST_JSP(?,?)}");			 
			  	               cs4.setInt(1,Integer.parseInt(rsFndId.getString("USER_ID")));       //USER REQUEST 
				               cs4.registerOutParameter(2, Types.VARCHAR);                  //回傳 REQUEST_ID
						       cs4.execute();
               	   		       requestID = cs4.getInt(2);   //  回傳 REQUEST_ID
				               cs4.close();			
						       out.println("<table bgcolor='#FFFFCC'><tr> <td><strong><font color='#000099'>Request ID=  </font></td><td><font color='#FF0000'>"+requestID+"</td></font></strong></tr></table>");
							   
						       //out.println("sqlfnd="+sqlfnd);	
						     }  //end if (rsFndId.next()) 
							 rsFndId.close();
                             stateFndId.close();

%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
