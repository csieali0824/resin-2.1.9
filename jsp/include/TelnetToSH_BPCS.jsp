<%@ page import="TelnetBean,DateBean"%>
<jsp:useBean id="telnetBean" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="DateBean"/>

<%
//Start to telnet to Shanghai UNIX Server
try
{      
  if (telnetBean.isMonReady!=true)
  {    
    //若telnetBean.isMonReady==false表示目前未連線或者連線異常,則重新連結一次
	telnetBean.setHost("203.74.244.156");
    telnetBean.setPort("23");
    telnetBean.setUser("pgsrc");
    telnetBean.setPassword("pgsrc");
    telnetBean.setOpMan((String)session.getAttribute("USERNAME")); 
    telnetBean.setOpTime(unixDateBean.getYearMonthDay()+"-"+unixDateBean.getHourMinuteSecond());

    telnetBean.connTelnet(); 	
  }             
} //end of try
catch (Exception e)
{
 out.println("JSP Exception:"+e.getMessage());
}
// End of Telnet to Shanghai UNIX Server
%>
