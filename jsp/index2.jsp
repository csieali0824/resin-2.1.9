<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%
//找是否有特定cookie,若有則清除之以使該cookei徹底失效 
Cookie logoutCookie=new Cookie("LtpaToken", ""); 
 try{
        logoutCookie.setDomain(".dbtel.com.tw");                                                                    
        logoutCookie.setMaxAge(-1);
		logoutCookie.setPath("/");        
		response.addCookie(logoutCookie);        
    }//end of try
 catch (Exception e)
    {
        out.println("Exception:"+e.getMessage());
    }
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>index.jsp</title>
</head>

<body topmargin="0"> 
<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td height="112" background="../image/title.jpg" bgcolor="#FFFFFF">&nbsp; </td>
  </tr>
</table>
<div align="center"> </div>
<table width="40%" border="0" align="center" cellspacing="0" bordercolor="#000000">
  <tr>
    <td align="center" bgcolor="#33CCFF"><font color="#000000" size="3"><b>伺服器登錄</b></font></td>
  </tr>
</table>
<CENTER>

<FORM METHOD=post ACTION="Login.jsp" NAME="signform" >
<table width="317" border="2" align="center" cellpadding="2" bordercolor="#FFFFFF">
  <tr>
      
    <td BGCOLOR="#FFFFFF" width="30%">使用者名稱</td>
    <td BGCOLOR="#FFFFFF" width="70%"> 
      <INPUT NAME="UserName" VALUE="" maxlength=256>
    </td>
    </tr>
  <tr>
      
    <td BGCOLOR="#FFFFFF" width="30%">使用者密碼</td>
    <td BGCOLOR="#FFFFFF"width="70%"> 
      <INPUT NAME="Password" VALUE="" TYPE=password  maxlength=256>
      <INPUT TYPE=submit VALUE="登入" onClick="return check();">
    </td>
    </tr>
	<tr>
	<td></td>
	<td><div align="left"><font color="#FF0000">沒有此ID!請重新登入</font></div></td> </tr>
 </TABLE><CENTER>
 </FORM>
<table width="40%" border="0" align="center" cellspacing="0" bgcolor="#33CCFF">
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table width="45%" border="0" align="center">
  <tr>
    <td align="center"><font color="#999999"><em>與Notes Internet名稱密碼相同請注意字體大小寫</em></font></td>
  </tr>
</table>
<hr>
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
if (daym<10)
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
    <td align="center" bgcolor="#FFFFFF"><div align="center"><em><font color="#999999">大霸電子股份有限公司　版權所有</font></em></div></td>
  </tr>
  <tr> 
    <td align="center" bgcolor="#FFFFFF"><div align="center"><font color="#999999"><em>Copyright 
        c 2003, DBTEL Taiwan Limited. All Rights Reserved</em></font></div></td>
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
