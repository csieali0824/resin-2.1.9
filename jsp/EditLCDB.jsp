<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,DateBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>EditLCDB.jsp</title>
</head>

<body background="../image/b01.jpg">
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
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
  String LCNO=request.getParameter("LCNO");
  float LCAMT=0;
  String LCCUR="";
  String LCEFF="";
  String LCDIS="";
  String LCUPDT="";
  String LCUPTM="";
  float LCUSAGE=0;
  try
    {
	Statement statement9=ifxshoescon.createStatement();
    ResultSet rs9=statement9.executeQuery("select LCNO from HLCM WHERE LCNO='"+LCNO+"'");
    rsBean.setRs(rs9);
  if(rs9.next())
   {
	    if (LCNO != null)
	    {
	      Statement statement=ifxshoescon.createStatement();
          String sql="select * from HLCM where LCNO='"+LCNO+"'";	
          ResultSet rs=statement.executeQuery(sql);
	      rs.next();
	      LCAMT=rs.getFloat("LCAMT");
		  LCCUR=rs.getString("LCCUR");
		  LCUSAGE=rs.getFloat("LCUSAGE");
		  LCEFF=rs.getString("LCEFF");
		  LCDIS=rs.getString("LCDIS");
	      /*out.print(LCAMT+"<br>");
		  out.print(LCCUR+"<br>");
		  out.print(LCUSAGE+"<br>");
		  out.print(LCEFF+"<br>");
		  out.print(LCDIS+"<br>");*/
	      rs.close();
		} //end of if
		rs9.close();
   }//end of if
   	else
	{
	   response.sendRedirect("../jsp/EditLC.jsp");
	}
  }//end of try
	catch (Exception e)
     {
       out.println("Exception:"+e.getMessage());
     }
%>


      <form action="UpdateLC.jsp" method="post" name="signform" onsubmit="return validate()">
	  <input type="hidden" name="LCUSAGE" value="<%= LCUSAGE %>" >
	  <input type="hidden" name="LCCUR" value="<%= LCCUR %>" >
	  <input type="hidden" name="LCNO" value="<%= LCNO %>" >
	  <input type="hidden" name="LCUPDT" value="<%= EDITION %>" >
	  <input type="hidden" name="LCUPTM" value="<%= TIME %>" >
<table width="100%" height="31" border="1">
  <tr>
    <td width="50%"><font size="+2"><strong>DBTEL</strong></font></td>
    <td width="50%"><font size="+2"><strong>L/C Maintenance</strong></font></td>
  </tr>
</table>
<table width="100%" border="1">
  <tr> 
    <td height="66">Create Model</td>
  </tr>
</table>
  <table width="100%" border="1">
    <tr> 
      <td rowspan="2"><div align="center"><font color="#0000FF">L/C NO</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Amount</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Currency</font></div></td>
      <td rowspan="2"><div align="center"><font color="#0000FF">Usage</font></div></td>
      <td colspan="2"><div align="center"><font color="#0000FF">Effective Date</font></div></td>
    </tr>
    <tr> 
      <td><div align="center"><font color="#0000FF">From</font></div></td>
      <td><div align="center"><font color="#0000FF">To</font></div></td>
    </tr>
    <tr> 
      <td><div align="center"><%= LCNO %></div></td>
      <td><div align="center"><input type="text" name="LCAMT" size="15" maxlength="15" value=<%= LCAMT %>></div></td>
      <td><div align="center"><%= LCCUR %></div></td>
      <td><div align="center"><%= LCUSAGE %></div></td>
      <td><div align="center"><input type="text" name="LCEFF" size="10" maxlength="8" value=<%= LCEFF %>></div></td>
      <td><div align="center"><input type="text" name="LCDIS" size="10" maxlength="8" value=<%= LCDIS %>></div></td>
    </tr>
  </table>
  <table width="16%" border="0" align="center">
  <tr>
    <td><input type="submit" name="submit" value="Save" ></td>
    
  </tr>
</table>
</form>
</body>
<!--=============¥H?U°I?q?°AAcn3sμ2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>

  <script language="JavaScript"> 

  function checkYMD2(motoText)
  {
    date=motoText.match(/^(\d\d)\/(\d\d)\/(\d\d)$/);
	if(!date){alert("異常"); return false;}
	mm=eval(RegExp.$2);
	dd=eval(RegExp.$3);
	if((mm<1) || (mm>12)) { alert("月份異常"); return false;}
	if((dd<1) || (dd>12)) { alert("日期異常"); return false;}
	alert("正常"); return true;
  }
  
  
   function validate(){
     if (eval(document.signform.LCAMT.value) < eval(document.signform.LCUSAGE.value)) {
	      alert("值不可小於Usage!");
		  return (false);
	 }else {
	      document.signform.submit();
	  }
   }
   
        </script>