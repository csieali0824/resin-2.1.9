<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To ger the Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,ArrayComboBoxBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<html>
<head>
<title>PIT VERSION EDIT FORM</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<body>
<%
String version=request.getParameter("T_VERSION");
Statement statement=con.createStatement();
ResultSet rs=null;
String model="",object="",country="",product="",verDesc="";
//?出?彿¬⽿?瀨¨?
try
{     	         
   rs=statement.executeQuery("select * from PIT_VERSION where T_VERSION='"+version+"'");	   
   if (rs.next())
   {
	 model=rs.getString("MODEL");
	 product=rs.getString("PRODUCT");
	 country=rs.getString("COUNTRY");
	 object=rs.getString("T_OBJECT");
	 verDesc=rs.getString("DESCRIPTION");
   }   
   rs.close();       
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}
%>
<FORM ACTION="WSPIT_VersionUpdate.jsp" METHOD="post">
  <font color="#0080FF" size="5"><strong>測試發行 版本資訊</strong></font> 
  <table width="88%" border="1">
    <tr> 
      <td width="45%">PRODUCT:<font size="2">
        <%      
	  try
      {     	         
       rs=statement.executeQuery("select PROD_CLASS A,PROD_CLASS B from MRPRODCLS order by A");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("PRODUCT");	   
	   comboBoxBean.setSelection(product);	 
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
      <td width="55%">MODEL:<font size="2">
      <%      
	  try
      {     	         
       rs=statement.executeQuery("select trim(PROJECTCODE) as x,trim(PROJECTCODE) from PIMASTER order by x");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("MODEL");	  
	   comboBoxBean.setSelection(model); 
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
    </tr>
    <tr>
      <td>OBJECT:<font size="2">
      <%      
	  try
      {     	         
       rs=statement.executeQuery("select OBJECTID,NAME from PIT_OBJECT order by OBJECTID");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("OBJECT");	  
	   comboBoxBean.setSelection(object); 
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
      </font></td>
    <td>COUNTY:<font size="2">
      <%      
	  try
      {     	         
       rs=statement.executeQuery("select LOCALE,LOCALE_ENG_NAME||'('||LOCALE||')' from WSLOCALE order by LOCALE_ENG_NAME");	   
	   comboBoxBean.setRs(rs);	   
	   comboBoxBean.setFieldName("COUNTRY");	
	   comboBoxBean.setSelection(country);   
       out.println(comboBoxBean.getRsString());	   
	   
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %>
    </font></td>
    </tr>
    <tr>
      <td colspan="2">VERSION:<%=version%><input name="VERSION" type="HIDDEN" value='<%=version%>'></td>
    </tr>
    <tr> 
      <td colspan="2">Description of VERSION : 
        <INPUT TYPE="text" NAME="DESC" size="60" value=<%=verDesc%>></td>
    </tr>
  </table>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value="SAVE">
  </p>   	
</FORM>
  <A HREF="WSPIT_VersionQueryAll.jsp">測試發行版本 清單</A> 
</body>
</html>
<%
  statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->