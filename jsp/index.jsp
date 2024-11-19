<%@ page contentType="text/html; charset=utf-8" language="java" %>
<%@ page import="java.sql.*" %>
<script language="JavaScript">
function goHome() 
{
var language = "";
var browserLang = "";
if (navigator.language)
{
 language = navigator.language;
 //alert("navigator.language="+language);
}
if (navigator.browserLanguage)
{
    language = navigator.browserLanguage;
	//alert("navigator.browserLanguage="+language);
}
if (language == "")
   language = "en";
else
{
   browserLang = language;
   language = language.substring(0,2);
}   
 if (language == 'es')
 {
  //window.location.href="/espanol/default.asp";
  alert("language="+language);
 }
 else if (language == "de") 
 {
  //window.location.href="/deutsch/default.asp";
  alert("language="+language);
 }
 else if (language == "fr") {
  //window.location.href="/francais/default.asp";
  alert("language="+language);
 }
 else {
  //window.location.href="/english/default.asp";
  //alert("language="+language);
 }
}
</script>
<%
String loginOut=request.getParameter("LOGINOUT");
if (loginOut==null) {
	Cookie[] cookies = null;
	try  {     
		//檢查是否存在NOTES之SSO===================
		cookies = request.getCookies();
		if (cookies != null) {
			for (int iCookieCounter = 0; iCookieCounter < cookies.length;iCookieCounter++)  {                                      	
				if (cookies[iCookieCounter].getName().equals("LtpaToken") 
				&& !cookies[iCookieCounter].getValue().equals("") 
				&& cookies[iCookieCounter].getValue()!=null) {            	
					response.sendRedirect("login.jsp");				
					break;                             
				} // end if
			} // end for
		} //enf of cookies if
	//======================================   
	} catch (Exception e) {
		e.printStackTrace();
		out.println("Exception:"+e.getMessage());
	}
}

String langCh=request.getParameter("LANGCH");

if (langCh==null || langCh.equals("")) langCh = "zh-tw";
%>

<html>
<head>

<title></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body topmargin="0" onLoad="goHome()"> 
<table width="704" border="0" align="center" cellspacing="0">
  <tr>
    <td height="112" background="../image/aa.jpg" bgcolor="#FFFFFF">&nbsp; </td>
  </tr>
</table>
<hr>
<table width="40%" border="0" align="center" cellspacing="0" bordercolor="#000000">
  <tr>
    <td align="center" bgcolor="#0066CC" ><font color="#FFFFFF" size="3"><strong>Login</strong></font></td>
  </tr>
</table>
<FORM METHOD=post ACTION="Login.jsp" NAME="signform" >
<table width="317" border="2" align="center" cellpadding="2" bordercolor="#FFFFFF">
  <tr>
      
    <td BGCOLOR="#FFFFFF" width="32%">
	<%  if (langCh.equals("zh-tw")) 
	    {
		 out.println("帳號：");
		} else if (langCh.equals("zh-cn"))
		       {
			     out.println("帐号：");
			   } else if (langCh.equals("en-us"))
			   { 
			     out.println("Username：");  
			   }	
	%>
	</td>
    <td BGCOLOR="#FFFFFF" width="68%"> 
      <INPUT NAME="UserName" VALUE="" maxlength=256>
    </td>
    </tr>
  <tr>      
    <td BGCOLOR="#FFFFFF" width="32%">
	<%  
	    if (langCh.equals("zh-tw")) 
	    {
		 out.println("密碼：");
		} else if (langCh.equals("zh-cn"))
		       {
			     out.println("密码：");
			   } else if (langCh.equals("en-us"))
			   { 
			     out.println("Password：");  
			   }	
	%>
	</td>
    <td BGCOLOR="#FFFFFF"width="68%"> 
      <INPUT NAME="Password" VALUE="" TYPE=password  maxlength=256>
	  <%  
	    if (langCh.equals("zh-tw")) 
	    {
		 out.println("<INPUT TYPE=submit value='登入' onClick='return check();'>");
		} else if (langCh.equals("zh-cn"))
		       {
			     out.println("<INPUT TYPE=submit value='登入' onClick='return check();'>");
			   } else if (langCh.equals("en-us"))
			   { 
			     out.println("<INPUT TYPE=submit value='Login' onClick='return check();'>"); 
			   }	
	  
	  %>      
    </td>
  </tr> 
 </TABLE>
 <div align="center">
 <Table>
    <tr>
     <td><%  if (langCh.equals("zh-tw")) { %><a href="../jsp/index.jsp?LANGCH=zh-tw"><img name="NLS_TW_A" src="../image/nls_zht_a.gif" border="0"></a><%  } else { %><a href="../jsp/index.jsp?LANGCH=zh-tw"><img name="NLS_TW" src="../image/nls_zht.gif" border="0"></a><%   } %></td>
	 <td><%  if (langCh.equals("zh-cn")) { %><a href="../jsp/index.jsp?LANGCH=zh-cn"><img name="NLS_TW_A" src="../image/nls_zhs_a.gif" border="0"></a><% } else { %><a href="../jsp/index.jsp?LANGCH=zh-cn"><img name="NLS_TW" src="../image/nls_zhs.gif" border="0"></a><%   } %></td>
	 <td><% if (langCh.equals("en-us"))  { %><a href="../jsp/index.jsp?LANGCH=en-us"><img name="NLS_TW_A" src="../image/nls_us_a.gif" border="0"></a><% } else { %><a href="../jsp/index.jsp?LANGCH=en-us"><img name="NLS_US" src="../image/nls_us.gif" border="0"></a><%   } %></td>
    </tr>
 </Table>
 </div>
 <input name="LANGCH" type="HIDDEN" value="<%=langCh%>" > 
 </FORM>
<hr>
<table width="50%" border="0" align="center" cellspacing="0" bgcolor="#FFFFFF">
  <tr>
    <td><div align="center"><font color="#999999"><em>您可輸入以 Oracle E-Business 帳戶資訊認證方式登入本系統</em></font></div></td>
  </tr>
</table>
<table width="45%" border="0" align="center">
  <tr>
    <td align="center"><font color="#999999"><em>帳戶資訊請注意字體大小寫</em></font></td>
  </tr>
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
        3.0以上瀏覽 最佳瀏覽畫面 1024*768</font><br>
        </em> </div></td>
  </tr>
  <tr> 
    <td rowspan="2" align="center" valign="middle" bgcolor="#FFFFFF">&nbsp;</td>
    <td align="center" bgcolor="#FFFFFF"><div align="center"><em><font color="#999999">台灣半導體股份有限公司　版權所有</font></em></div></td>
  </tr>
  <tr> 
    <td align="center" bgcolor="#FFFFFF"><div align="center"><font color="#999999"><em>Copyright 
        c 2005, TS Taiwan Limited. All Rights Reserved</em></font></div></td>
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
