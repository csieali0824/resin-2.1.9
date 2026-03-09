<%@ page import="TelnetBean,bean.DateBean"%>
<jsp:useBean id="telnetBean_TPE" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="bean.DateBean"/>

<%
//Start to telnet to TPE UNIX Server
try
{      
  if (telnetBean_TPE.isMonReady!=true)
  {    
    //�YtelnetBean_TPE.isMonReady==false��ܥثe���s�u�Ϊ̳s�u���`,�h���s�s���@��
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
