<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.*"%>
<%@ page import="TelnetBean,DateBean" %>
<jsp:useBean id="telnetBean" scope="application" class="TelnetBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ include file="/jsp/include/ConnBPCSTstexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>TEST CONNECTION TO UNIX</title>
</head>
<body>
<%
//Statement statement=ifxdbexpcon.createStatement();
Statement statement=ifxTstexpcon.createStatement();
ResultSet rs=null;

//telnetBean.setHost("203.74.244.158");
//telnetBean.setPort("23");
//telnetBean.setUser("pgsrc");
//telnetBean.setPassword("pgsrc");
//telnetBean.setOpMan("BO1732");
//telnetBean.setOpTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinuteSecond());

//telnetBean.connTelnet();
out.println(telnetBean.isMonReady);

String rtPrompt="",waitforPrompt="";
rtPrompt=telnetBean.getCMDPrompt();
//telnetBean.specialRunComnd("/home/pgsrc/cron610/tppo2shco_test.sh test 23559 102 GSM roger_chang@dbtel.com.tw");
//waitforPrompt=telnetBean.runComnd("/home/pgsrc/cron610/tppo2shco_all.sh dbexp 23450 102 GSM sandy_chan@dbtel.com.tw");
//System.err.println(waitforPrompt);
waitforPrompt=telnetBean.runComnd(""); // to send the "ENTER"/"RETURN" COMMAND 
//waitforPrompt=telnetBean.specialRunComnd("");
if (waitforPrompt!=null &&  waitforPrompt.trim().equals(rtPrompt.trim()))
{
 out.println("Connection alive!!<BR>");
 out.println("<br>IsMonReady:"+telnetBean.isMonReady);
} else {
  if (telnetBean.isMonReady==true)
  {
    out.println("Connection Still alive but.....!! 1:"+rtPrompt+" 2:"+waitforPrompt+"<BR>");   
    out.println("<br>IsMonReady:"+telnetBean.isMonReady); 
  }	else {
    out.println("Connection Dead!! 1:"+rtPrompt+" 2:"+waitforPrompt+"<BR>");   
    out.println("<br>IsMonReady:"+telnetBean.isMonReady); 
  }
}
//out.println(rtPrompt);
//out.println(telnetBean.getSetPrompt(rtPrompt));
//telnetBean.runComnd("cd cron610"); 
//out.println("<BR>"+telnetBean.getSetPrompt(rtPrompt));
//out.println("<BR>"+telnetBean.runComnd("mailx -s FROM_SHANGHAI roger_chang@dbtel.com.tw < /home/pgsrc/cron610/tppo2shco_all.txt"));
telnetBean.disconnect(); 
//System.err.println(waitforPrompt);
/*
if (waitforPrompt==null) //若回應為null,表示正由SMG處理中
{
	int cc=0;
	while (true)
	{
	  java.lang.Thread.sleep(5000);
	  rs=statement.executeQuery("select * from ECH where HCPO='23450'");
	  
	  System.err.println("count:"+cc+" waiting......;");
	  if (cc>24)
	  {	    
	    telnetBean.disconnect(); 
		out.println("System Error!! Please Try it again!");
		break; 	    
	  }	else {
	    if (rs.next())
	    {
		  java.lang.Thread.sleep(5000); //再多延遲一下以讓SMG後續工作完成
		  telnetBean.disconnect(); 
		  out.println("OK! Got it!!The CO No. is "+rs.getString("HORD"));
		  break;
	    } 	  
	  }
	  cc++;
	  rs.close();  
	} 
} else {
  telnetBean.disconnect(); 
} 
*/
%>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTstexpPage.jsp"%>
</html>
