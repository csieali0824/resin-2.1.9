<%@ page import="TelnetBean,DateBean"%>
<jsp:useBean id="telnetBean_TEST" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="DateBean"/>

<%
//Start to telnet to TPE UNIX Server
try
{      
  if (telnetBean_TEST.isMonReady!=true)
  {    
    //若telnetBean_TEST.isMonReady==false表示目前未連線或者連線異常,則重新連結一次
	telnetBean_TEST.setHost("10.0.1.7");
    telnetBean_TEST.setPort("23");
    telnetBean_TEST.setUser("oradev");
    telnetBean_TEST.setPassword("siemens");
    telnetBean_TEST.setOpMan((String)session.getAttribute("USERNAME")); 
    telnetBean_TEST.setOpTime(unixDateBean.getYearMonthDay()+"-"+unixDateBean.getHourMinuteSecond());

    telnetBean_TEST.connTelnet(); 	
  }             
} //end of try
catch (Exception e)
{
 out.println("JSP Exception:"+e.getMessage());
}
// End of Telnet to Shanghai UNIX Server
%>
