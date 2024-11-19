<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Buffernet產生XML頁面</title>
<SCRIPT Language = javascript>
function datacheck(){
   if(form1.packingnumber.value == ""){
      window.alert("It is empty of Packingnumber field!!");
      //
      document.form1.packingnumber.focus();
      //
      return;
   }
      if(form1.customerpo.value == ""){
      window.alert("It is empty of CustomerPO field!!");
      //
      document.form1.customerpo.focus();
      //
      return;
   }

	form1.submit();

	
}
</script>
</head>

<body>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
<%@ include file="Tsc1211head.jsp"%>
<p>&nbsp;</p>
<%
//out.print("UserName="+UserName);
 %>
<form name="form1" method="post" action="Tsc1211generateXmlDetail.jsp">
<table  width="400" height="74" border="1" align="center" cellpadding="0" cellspacing="1"   bordercolor="#3399CC">
   <TR  bgcolor="#E6FFE6">
    <td colspan="2"><div align="center"><font size="4" face="Arial"><strong>XML Generate </strong></font></div></td>
    </tr>
  <TR  bgcolor="#E6FFE6">
    <td><div align="center"><font size="3" face="Arial"><strong>Packing Number</strong></font></div></td>
    <td><input name="packingnumber" type="text" id="packingnumber"></td>
  </tr>
  <TR  bgcolor="#E6FFE6">
    <td><div align="center"><font size="3" face="Arial"><strong>Customer PO</strong></font></div></td>
    <td><input name="customerpo" type="text" id="customerpo"></td>
  </tr>
 
  <TR  bgcolor="#E6FFE6">
    <td height="35" colspan="2"><div align="right">
      <input type="button" name="Submit" value="Submit"  onClick="datacheck()">
    </div></td>
    </tr>
</table>
</form>
<p>&nbsp;</p>

</body>
</html>
