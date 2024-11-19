<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@page contentType="image/gif; charset=big5" %><%
    out.clearBuffer();
    String filename = request.getParameter("file");
    OutputStream o = response.getOutputStream();
										   int  index_length =  filename.lastIndexOf("_");
										   int  s_length =  filename.length();
   										   String mid_link = (filename.substring(index_length+1,s_length));
    response.setHeader("Content-disposition","attachment;filename="+java.net.URLEncoder.encode(mid_link));
    FileInputStream is = new FileInputStream(application.getRealPath("/jsp/upload_xml")+"/"+filename);
    byte[] buf = new byte[32 * 1024]; // 32k buffer
    int nRead = 0;
    while( (nRead=is.read(buf)) != -1 ) {
        o.write(buf, 0, nRead);
    }
    o.flush();
    o.close();
    if(is!=null)
       is.close();
%>