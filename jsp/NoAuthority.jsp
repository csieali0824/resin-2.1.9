<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%
//找是否有特定cookie,若有則清除之以使該cookei徹底失效 
Cookie logoutCookie=new Cookie("LtpaToken", ""); 
 try{
        logoutCookie.setDomain(".ts.com.tw");                                                                    
        logoutCookie.setMaxAge(-1);
		logoutCookie.setPath("/");        
		response.addCookie(logoutCookie);        
    }//end of try
 catch (Exception e)
    {
        out.println("Exception:"+e.getMessage());
    }
%>
<% String UserName=request.getParameter("UserName"); %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>index.jsp</title>
</head>

<body topmargin="0"> 
<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td height="112" background="../image/logo.jpg" bgcolor="#FFFFFF" align="center" valign="top">&nbsp; </td>
  </tr>
</table>

<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td height="90" background="" bgcolor="#FFFFFF">&nbsp; </td>
  </tr>
</table>

<table border="2" align="center" cellpadding="2" bordercolor="#FFFFFF">
<tr><td align="center" BGCOLOR="#FFFFFF" width="70%"><font color="#FF0000" size="+3">抱歉! <%=UserName%> 未被授權使用!</font></td></tr>
<tr><td align="center"><font color="#999999">請注意字體大小寫</font></td></tr>
<tr><td width="30"></td></tr>
<tr><td align="center"><font size="+2"><a href="index.jsp">重新登入</a></font></td></tr>

</table>

<table width="100%" border="0" cellspacing="0">
  <tr align="center"> 
    <td colspan="2"><font color="#999999">&nbsp;</font></td>
  </tr>
  <tr align="center"> 
    <td colspan="2"> <script>
var mydate=new Date()
var year=mydate.getYear()
if (year < 1000)
year+=1900
var day=mydate.getDay()
var month=mydate.getMonth()
var daym=mydate.getDate()
if (daym<1×10)
daym="0"+daym
var dayarray=new Array("Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday")
var montharray=new Array("January","February","March","April","May","June","July","August","September","October","November","December")
document.write("<small><font color='#999999' face='Arial'><b>"+dayarray[day]+", "+montharray[month]+" "+daym+", "+year+"</b></font></small>")

</script> </td>
  </tr>
  <tr> 
    <td width="5%" bgcolor="#FFFFFF">&nbsp;</td>
    <td> <div align="center"><em><font color="#999999">建議使用版本IE 4.0 以上或Netscape 
        3.0以上瀏覽 最佳瀏覽畫面 800*600</font><br>
        </em> </div></td>
  </tr>
  <tr> 
    <td rowspan="2" align="center" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
    <td align="center" bgcolor="#FFFFFF"><div align="center"><em><font color="#999999">台灣半導體股份有限公司　版權所有</font></em></div></td>
  </tr>
  <tr> 
    <td align="center" bgcolor="#FFFFFF"><div align="center"><font color="#999999"><em>Copyright 
        c 2003,Taiwan Semiconductor Limited. All Rights Reserved</em></font></div></td>
  </tr>
</table>
<table width="199" height="34" border="0" align="center" cellspacing="0" background="../image/welcome.gif">
  <tr>
    <td width="224">&nbsp;</td>
  </tr>
</table>

<p>&nbsp;</p>
</body>
</html>
<script language="JavaScript1.1"> 
     
function check() {
      if (document.signform.UserName.value == "") {
           alert("請輸入帳號!");
		   return (false);
      }else if(document.signform.Password.value == ""){
	        alert("請輸入密碼!");
			return (false);
	  }else {
	      document.signform.submit();
      }
}
</script> 
