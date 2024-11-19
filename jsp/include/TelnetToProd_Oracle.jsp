<%@ page import="TelnetBean,DateBean"%>
<jsp:useBean id="telnetBean_PROD" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="DateBean"/>

<%
//Start to telnet to TPE UNIX Server
try
{      
  if (telnetBean_PROD.isMonReady!=true)
  {    
    //若telnetBean_TEST.isMonReady==false表示目前未連線或者連線異常,則重新連結一次
	telnetBean_PROD.setHost("10.0.1.5");
    telnetBean_PROD.setPort("23");
    telnetBean_PROD.setUser("oraprod");
    telnetBean_PROD.setPassword("-pl,0okm");
    telnetBean_PROD.setOpMan((String)session.getAttribute("USERNAME")); 
    telnetBean_PROD.setOpTime(unixDateBean.getYearMonthDay()+"-"+unixDateBean.getHourMinuteSecond());

    telnetBean_PROD.connTelnet(); 	
  }             
} //end of try
catch (Exception e)
{
 out.println("JSP Exception:"+e.getMessage());
}
// End of Telnet to Shanghai UNIX Server
%>
