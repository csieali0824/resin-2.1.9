<%@ page import="TelnetBean,bean.DateBean"%>
<jsp:useBean id="telnetBean_PROD" scope="application" class="TelnetBean"/>
<jsp:useBean id="unixDateBean" scope="page" class="bean.DateBean"/>

<%
//Start to telnet to TPE UNIX Server
try
{      
  if (telnetBean_PROD.isMonReady!=true)
  {    
    //�YtelnetBean_TEST.isMonReady==false��ܥثe���s�u�Ϊ̳s�u���`,�h���s�s���@��
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
