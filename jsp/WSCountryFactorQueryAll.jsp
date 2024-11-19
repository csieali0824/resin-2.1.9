<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="QryAllChkBoxEditBean" %>

<html>
<head>
<title>Query All Country Factor</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>

<%-- 下方的函數是用來控制是否刪除之確認動作 --%>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "CANCEL Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "SELECT ALL"; }
}
function NeedConfirm()
{ 
 flag=confirm("ARE YOU SURE YOU WANT TO DELETE?"); 
 return flag;
}
</script>

<body>
<FORM ACTION="../jsp/WSCountryFactorDel.jsp" METHOD="POST" onSubmit="return NeedConfirm()"> 
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Sales Forecast Country Factors List</strong></font><BR>
<input name="button" type=button onClick="this.value=check(this.form.CH)" value="SELECT ALL">
<INPUT TYPE="submit" value="DELETE">
&nbsp;&nbsp;<A HREF="WSCountryFactorEntry.jsp">Add New Country Factor</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp; <A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A> 
<jsp:useBean id="qryAllChkBoxEditBean" scope="page" class="QryAllChkBoxEditBean"/>
<%  
  try
  {   
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select COUNTRY,LOCALE_NAME,REGION,EXW_ADJ,VAT,EX_RATE from PSALES_COUNTRY_FACTOR,WSLOCALE where COUNTRY=LOCALE ORDER BY REGION,COUNTRY");        
      
   out.println("<TABLE>");
   out.println("<TR BGCOLOR=BLACK><TH>&nbsp;</TH><TH>&nbsp;</TH><TH><FONT COLOR=WHITE>COUNTRY</FONT></TH><TH><FONT COLOR=WHITE>REGION</FONT></TH><TH><FONT COLOR=WHITE>S/O Price Adj</FONT></TH><TH><FONT COLOR=WHITE>VAT(%)</FONT></TH><TH><FONT COLOR=WHITE>EX. RATE</FONT></TH></TR>");
   String bgcolor="B0E0E6";
   
   while (rs.next())
   {
    if (bgcolor.equals("B0E0E6"))
	{
	 out.println("<TR BGCOLOR=B0E0E6>");
	 bgcolor="ADD8E6";	 
	} else {
	 out.println("<TR BGCOLOR=ADD8E6>");
	 bgcolor="B0E0E6";
	}
		 
	 out.println("<TD><INPUT TYPE=checkbox NAME=CH VALUE="+(String)rs.getString(1)+"></TD>");
	 out.println("<TD><A HREF='../jsp/WSCountryFactorEdit.jsp?COUNTRY="+(String)rs.getString(1)+"'><img src='../image/docicon.gif'></A></TD>");     
     String s=(String)rs.getString(2);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");
	 s=(String)rs.getString(3);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");	 
	 int kf=(int)(rs.getFloat(4)*100);	 
	 kf=kf-100;	 
	 if (kf==0)
	 {
      out.println("<TD><FONT SIZE=2>--</TD>"); //SHIP-OUT PRICE ADJ
	 } else {
	   if (kf>0) out.println("<TD><FONT SIZE=2>+"+(float)(kf*0.01)+"</TD>"); else out.println("<TD BGCOLOR=RED><FONT SIZE=2>"+(float)(kf*0.01)+"</TD>");
	 }
	 float fs=rs.getFloat(5);
     out.println("<TD><FONT SIZE=2>"+(int)(fs*100)+"</TD>"); //VAT
	 s=(String)rs.getString(6);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");
      
     out.println("</TR>");
    } //end of while
   
   out.println("</TABLE>");
   
   rs.close();
   statement.close();                         
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
