<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*,DateBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->

<html>
<head>
<title>LCorderdel</title>
<meta http-equiv="Content-Type" content="text/html; charset=Big5">
</head>

<body>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<%
     String EDITION=null;
	 String dateString=null;
	 String Month=null;
	 String Day=null;
	 String Hour=null;
	 String NEWSID=null;
	 String HourSecond=null;
	 String TIME=null;

  
  
 try
    {
	Statement statement=ifxshoescon.createStatement();
	
	 dateString=dateBean.getYearMonthDay();
     Month=dateBean.getMonthString();
     Day=dateBean.getDayString();
     Hour=dateBean.getHourMinute();
	 HourSecond=dateBean.getHourMinuteSecond();
	 EDITION=dateString;
	 TIME=HourSecond;
     NEWSID=Month+Day+Hour;
	 //out.print(TIME+"<br>");
	 //out.print(EDITION+"<br>");
	 //out.print(NEWSID);
    }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }

%>



<%
String [] choice=request.getParameterValues("CH");
String choiceString=null;

try
{  
  for (int k=0;k<choice.length ;k++)
  {
   if (choiceString==null) 
   {
     choiceString="'"+choice[k]+"'";	 
   } else {	 
    choiceString=choiceString+",'"+choice[k]+"'";    
   }
  } //end of for
  //out.println(choiceString);
  /*String sql="delete from WSUSER where USERNAME in ("+choiceString+")";   
  PreparedStatement pstmt=con.prepareStatement(sql);    
  
  pstmt.executeUpdate();        */
  
  	Statement statement=ifxshoescon.createStatement();  
	String sql_update="UPDATE HLCM SET LCSTAT='D',LCUPDT='"+EDITION+"',LCUPTM='"+TIME+"',LCCFM='"+userID+"',LCID='HZ' WHERE LCNO in ("+choiceString+")";
	statement.executeUpdate(sql_update);
	statement.close();   
  
  out.println("Delete LCNO:"+choiceString+") OK!<BR>");
  statement.close();  
} //end of try
catch (Exception e)
{
 out.println(e.getMessage());
}//end of catch
%>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
