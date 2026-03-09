<%@ page language="java" import="java.sql.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection Pool==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="bean.ComboBoxBean,bean.DateBean,bean.ArrayComboBoxBean,bean.Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="bean.ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="bean.ArrayComboBoxBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="bean.Array2DimensionInputBean"/>
<jsp:useBean id="dateBean" scope="page" class="bean.DateBean"/>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="bean.SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="bean.SalesDRQPageHeaderBean"/>

<%

//out.println(arrayRFQDocumentInputBean.getArray2DContent());
out.println(arrayRFQDocumentInputBean.getArray2DBufferString());
%>


</body>
<!--=============�H�U�Ϭq������s����==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
