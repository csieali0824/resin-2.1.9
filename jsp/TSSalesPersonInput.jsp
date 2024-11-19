<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ page import="ComboBoxBean"%>
<html>
<head>
<title>Sales Person Input Form</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
</head>
<body>
<FORM ACTION="../jsp/TSSalesPersonInsert.jsp" METHOD="post" name="MYFORM">
<%
       String choiceCenterNo=request.getParameter("SALES_AREA_NO");
       String UserID = request.getParameter("USERID");

       String maxSalesPersonNo = "";
    
       Statement stateMaxRID=con.createStatement();
       ResultSet rsMaxRID=stateMaxRID.executeQuery("select lpad(max(RECPERSONNO)+1,3,'0') from ORADDMAN.TSRECPERSON where LOCALE='"+locale+"' and TSSALEAREANO='"+choiceCenterNo+"' "); 
       if (rsMaxRID.next()) maxSalesPersonNo = rsMaxRID.getString(1);	   
       rsMaxRID.close();
       stateMaxRID.close(); 


      if (maxSalesPersonNo==null || maxSalesPersonNo=="" || maxSalesPersonNo.equals("")) maxSalesPersonNo="001";

%>
  <font color="#0080FF" size="5"><strong><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgBasicInf"/><jsp:getProperty name="rPH" property="pgNew"/></strong></font> 
  <table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="90%" bordercolorlight="#FFFFCC"  border="1">
    <tr> 
      <td width="48%" nowrap><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgSalesArea"/><jsp:getProperty name="rPH" property="pgNo"/>
	  <%      
	  try
      {       
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select SALES_AREA_NO,SALES_AREA_NO||'--'||SALES_AREA_NAME from ORADDMAN.TSSALES_AREA order by SALES_AREA_NO");
	   out.println("<select NAME='SALES_AREA_NO' onChange='return setSubmit("+'"'+"TSSalesPersonInput.jsp"+'"'+")'>");
       out.println("<OPTION VALUE=-->--");     
       while (rs.next())
       {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
           if (s1.equals(choiceCenterNo)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
       } //end of while
       out.println("</select>");
	   //comboBoxBean.setSelection(repCenterNo);
       //comboBoxBean.setRs(rs);	   
	   //comboBoxBean.setFieldName("SALES_AREA_NO");	   
       //out.println(comboBoxBean.getRsString());
       rs.close();       
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
       %></font>
      </td>
      <td width="31%"><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgAccount"/><jsp:getProperty name="rPH" property="pgNo"/>
        <INPUT TYPE="text" NAME="RECPERSONNO" size="3" value="<% if (maxSalesPersonNo!=null && !maxSalesPersonNo.equals("")) out.println(maxSalesPersonNo); else out.println(""); %>" readonly=""></font> </td>
      <td width="21%"><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgLocale"/><jsp:getProperty name="rPH" property="pgCode"/>
        <INPUT TYPE="text" NAME="LOCALE" size="3" value="<%=locale%>"></font></td>
    </tr>
    <tr> 
      <td><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgAccount"/><jsp:getProperty name="rPH" property="pgEmpID"/> 
        <INPUT TYPE="text" NAME="USERID" size="10"></font> </td>
      <td colspan="1" nowrap><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgAccount"/><jsp:getProperty name="rPH" property="pgFLName"/> 
        <INPUT TYPE="text" NAME="USERNAME" size="20"></font></td>
	  <td colspan="1" nowrap><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgCode"/> 
        <INPUT TYPE="text" NAME="SALESRESID" size="20"></font></td>	
    </tr>
  </table>
  <p> 
    <INPUT TYPE="button" NAME="submit2" value='<-<jsp:getProperty name="rPH" property="pgSave"/>' onClick='return setSubmit("../jsp/TSSalesPersonInsert.jsp")'>
  </p>
  </FORM>
  <A HREF="../jsp/TSSalesPersonQueryAll.jsp"><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgAllRecords"/></A> 
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
