<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<html>
<head>
<title>Domino Connection test page</title>
</head>
<body>
<%@ page import="DominoBean" %>
<jsp:useBean id="domino" scope="session" class="DominoBean"/>
<%
 domino.setUserName("ROGER CHANG");
 domino.setPassword("9103");
 domino.setServerName("document.dbtel.com.tw");
 domino.setFileName("log.nsf");
 domino.setViewName("($Inbox)");
 domino.connectDomino();
 out.println(request.getServerName()); 
%>
      <br>
      <center>
            
  <h2>Domino Connection test page</h2>
      </center>
      <br>
      <center>
            <table>
                  <tbody>
                        <tr>
                              <td>
                                  <b>Server:</b>
                              </td>
                              <td>
             <jsp:getProperty name="domino" property="serverName"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>User:</b>
                              </td>
                              <td>
         <jsp:getProperty name="domino" property="commonUserName"/>
        </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>Version:</b>
                              </td>
                              <td>
                <jsp:getProperty name="domino" property="version"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>Platform:</b>
                              </td>
                              <td>
               <jsp:getProperty name="domino" property="platform"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>File:</b>
                              </td>
                              <td>
               <jsp:getProperty name="domino" property="fileName"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>File path:</b>
                              </td>
                              <td>
               <jsp:getProperty name="domino" property="filePath"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
                                    <b>Size:</b>
                              </td>
                              <td>
                <jsp:getProperty name="domino" property="dbSize"/>
                              </td>
                        </tr>
                        <tr>
                              <td>
      	                              <b>Title:</b>
                              </td>
                              <td>
                <jsp:getProperty name="domino" property="dbTitle"/>
                              </td>
                        </tr>
                  </tbody>
            </table>
      </center>
      <br>
	  <%
	  //out.println(domino.getDocumentsString());
	  %>
</body>
</html>
