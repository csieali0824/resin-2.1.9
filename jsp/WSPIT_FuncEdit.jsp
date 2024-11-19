<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="DateBean,ComboBoxBean,ArrayComboBoxBean"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<%
String code=request.getParameter("code");
Statement statement=con.createStatement();
ResultSet rs=null;
String name="",desc="",class1="",ref="",locale="";
//取出所有資訊
try  
{     	         
   rs=statement.executeQuery("select * from PIT_FUNCTION where code='"+code+"'");	   
   if (rs.next())
   {
	 name=rs.getString("NAME");
	 desc=rs.getString("DESCRIPTION");
	 class1=rs.getString("CLASS");
	 ref=rs.getString("ref");
	 locale=rs.getString("locale");
   }   
   rs.close();       
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
<html>
<head>
<title>PIT FUNCTION EDIT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<FORM ACTION="../jsp/WSPIT_FuncUpdate.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>修改測試功能項目基本資訊</strong></font> 
 <table width="97%" height="114" border="1">
    <tr> 
      <td width="13%" height="30">Code: 
        <input name="CODE" type="text" size="5" maxlength="5" value="<%=code%>"></td>
      <td width="15%">Class: 
        <%if (class1.equals("M") || class1.equals("m")){out.print("M 主功能");}else{out.print("S 次功能");}%>
        <input name="CLASS1" type="hidden" value="<%=class1%>" size="20"></td>
      <td width="39%">Name: 
        <input name="NAME" type="text" size="30" maxlength="30" value="<%=name%>"></td>
	 <%if (class1.equals("S") || class1.equals("s")){%>
      <td width="8%">Ref: 
        <%      
	  try
      {     	         
       rs=statement.executeQuery("select code as a,code as b from pit_function where class='M' order by code");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("REF");	
	   comboBoxBean.setSelection(ref);	
       out.println(comboBoxBean.getRsString());	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </td>
    <%}%>
    </tr>
    <tr> 
  
      <td height="36" colspan="5">Locale: 
        <%      
	  try
      {     	         
       rs=statement.executeQuery("select LOCALE,LOCALE_ENG_NAME||'('||LOCALE||')' from WSLOCALE order by LOCALE_ENG_NAME");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("LOCALE");	   
	   comboBoxBean.setSelection(locale);	
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </td>
    </tr>
    <tr> 
      <td height="38" colspan="5">Description: 
        <input name="DESC" type="text" size="60" maxlength="60" value="desc"></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>
</FORM>
  <A HREF="WSPIT_FuncQueryAll.jsp">功能項目 清單</A> 
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->