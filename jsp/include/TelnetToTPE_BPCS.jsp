<%@ page import="TelnetBean,DateBean"%>
<jsp:useBean id="telnetBean_TPE" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="DateBean"/>

<%
//Start to telnet to TPE UNIX Server
try
{      
  if (telnetBean_TPE.isMonReady!=true)
  {    
    //若telnetBean_TPE.isMonReady==false表示目前未連線或者連線異常,則重新連結一次
	telnetBean_TPE.setHost("203.66.141.2");
    telnetBean_TPE.setPort("23");
    telnetBean_TPE.setUser("pgsrc");
    telnetBean_TPE.setPassword("mis110");
    telnetBean_TPE.setOpMan((String)session.getAttribute("USERNAME")); 
    telnetBean_TPE.setOpTime(unixDateBean.getYearMonthDay()+"-"+unixDateBean.getHourMinuteSecond());

    telnetBean_TPE.connTelnet(); 	
  }             
} //end of try
catch (Exception e)
{
 out.println("JSP Exception:"+e.getMessage());
}
// End of Telnet to Shanghai UNIX Server
%>
