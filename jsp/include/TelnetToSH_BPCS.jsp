<%@ page import="TelnetBean,bean.DateBean"%>
<jsp:useBean id="telnetBean" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="bean.DateBean"/>

<%
//Start to telnet to Shanghai UNIX Server
try
{      
  if (telnetBean.isMonReady!=true)
  {    
    //�YtelnetBean.isMonReady==false��ܥثe���s�u�Ϊ̳s�u���`,�h���s�s���@��
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
