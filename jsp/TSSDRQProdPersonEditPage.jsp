<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ page import="ComboBoxBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Edit Product Factory Person Data Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
</head>

<body>
<%
String v_userID=request.getParameter("USERID");
String repCenterNo="",repPersonNo="",v_userName="",v_salesResID="";

      try
      {      	
	   Statement docstatement=con.createStatement();
       ResultSet docrs=docstatement.executeQuery("select * from ORADDMAN.TSPROD_PERSON WHERE trim(USERID)='"+v_userID+"'");
       docrs.next();
	   
	   repCenterNo=docrs.getString("PROD_FACNO");
	   repPersonNo=docrs.getString("PROD_PERSONNO");
	   v_userName=docrs.getString("USERNAME");	    
	   v_salesResID="";	
	   
	   //if (v_salesResID==null) v_salesResID="";
	   
       docrs.close();                	   
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
<FORM ACTION="/oradds/jsp/TSSDRQProdPersonUpdate.jsp?USERID=<%=v_userID%>" METHOD="post">
  <font color="#0080FF" size="5"><strong><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgInfo"/></strong></font> 
  <table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="78%" bordercolorlight="#FFFFCC"  border="1">
    <tr> 
      <td width="48%"><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgProdFactory"/>: 
        <%
	  try
      {       
       Statement statement=con.createStatement();
       ResultSet rs=statement.executeQuery("select MANUFACTORY_NO,MANUFACTORY_NO||'--'||MANUFACTORY_NAME from ORADDMAN.TSPROD_MANUFACTORY order by MANUFACTORY_NO");
	   out.println("<select NAME='MANUFACTORY_NO' onChange='return setSubmit("+'"'+"TSSDRQProdPersonInput.jsp"+'"'+")'>");
       out.println("<OPTION VALUE=-->--");     
       while (rs.next())
       {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
           if (s1.equals(repCenterNo)) 
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
       %>
      </font></td>
      <td width="52%"><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgProdPC"/>NO.: 
        <INPUT TYPE="text" NAME="REPPERSONNO"  value=<%=repPersonNo%> size="5"></font> </td>
    </tr>
    <tr> 
      <td><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgProdPC"/>ID:<%=v_userID%></font> </td>
      <td><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgName"/>: 
        <INPUT TYPE="text" NAME="USERNAME"  value=<%=v_userName%> size="20"></font></td>
    </tr>	
	    <INPUT TYPE="hidden" NAME="SALESRESID"  value='<% if (v_salesResID==null) out.println(""); else out.println(v_salesResID);%>' size="20">
    
  </table>
  <BR>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'>
  </p>
  <A HREF="../jsp/TSSDRQProdPersonQueryAll.jsp"><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgProdPC"/><jsp:getProperty name="rPH" property="pgAllRecords"/></A> 
</FORM>
  </body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
