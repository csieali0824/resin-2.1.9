<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="array2DimensionInputBean" scope="session" class="Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
 
<jsp:useBean id="array2DGenerateSOrderBean" scope="session" class="Array2DimensionInputBean"/>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
 
String line_Type1 =request.getParameter("line_Type1");
String customerPO=request.getParameter("customerPO");
String line_no =request.getParameter("line_no");
 out.println(line_Type1);
 out.println(line_no);
  out.println(customerPO);

   
// response.sendRedirect("Tsc1211ConfirmDetailList.jsp?customerPO="+customerPO);

%>

 
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->

</form>
</body>
</html>
