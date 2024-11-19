<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<html>
<head>
<title>Edit Sales Person Data Page</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="application" class="ComboBoxBean"/>
</head>
<body>
<%
String v_userID=request.getParameter("keycol1");
String v_salesArea=request.getParameter("keycol2");
String repCenterNo="",repPersonNo="",v_userName="",v_salesResID="";
try
{   
	String sql = "select * from ORADDMAN.TSRECPERSON WHERE trim(USERID)='"+v_userID+"' and TSSALEAREANO='"+ v_salesArea+"'";
	//out.println(sql);   	
	Statement docstatement=con.createStatement();
   	ResultSet docrs=docstatement.executeQuery(sql);
   	if (docrs.next())
	{
		repCenterNo=docrs.getString("TSSALEAREANO");
		repPersonNo=docrs.getString("RECPERSONNO");
		v_userName=docrs.getString("USERNAME");	    
		v_salesResID=docrs.getString("SALESPERSONID");	
	}	   
	docrs.close();  
	docstatement.close();              	   
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
<FORM ACTION="/oradds/jsp/TSSalesPersonUpdate.jsp?USERID=<%=v_userID%>&SALESAREA=<%=v_salesArea%>" METHOD="post">
  <font color="#0080FF" size="5"><strong><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgInfo"/></strong></font> 
  <A HREF="../jsp/TSSalesPersonQueryAll.jsp"><jsp:getProperty name="rPH" property="pgQuery"/><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgAllRecords"/></A>   
  <table cellSpacing="0" bordercolordark="#99CC99" cellPadding="1" width="78%" bordercolorlight="#FFFFCC"  border="1">
    <tr> 
      <td width="48%"><font color="#CC0033" size="2"><jsp:getProperty name="rPH" property="pgSalesArea"/>: 
<%
try
{       
	Statement statement=con.createStatement();
    ResultSet rs=statement.executeQuery("select SALES_AREA_NO,SALES_AREA_NO||'--'||SALES_AREA_NAME from ORADDMAN.TSSALES_AREA order by SALES_AREA_NO");
	comboBoxBean.setSelection(repCenterNo);
    comboBoxBean.setRs(rs);	   
	comboBoxBean.setFieldName("SALES_AREA_NO");	   
    out.println(comboBoxBean.getRsString());
    rs.close(); 
	statement.close();      
} //end of try
catch (Exception e)
{
	out.println("Exception:"+e.getMessage());
}
%>
      </font></td>
    <td width="52%"><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/>NO.: 
        <INPUT TYPE="text" NAME="REPPERSONNO"  value="<%=repPersonNo%>" size="5"></font> </td>
    </tr>
    <tr> 
      <td><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/>ID:<%=v_userID%></font> </td>
      <td><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgName"/>: 
        <INPUT TYPE="text" NAME="USERNAME"  value="<%=v_userName%>" size="20"></font></td>
    </tr>		
    <tr> 		
	  <td colspan="2"><font color="#003366" size="2"><jsp:getProperty name="rPH" property="pgSalesMan"/><jsp:getProperty name="rPH" property="pgCode"/>	
	    <INPUT TYPE="text" NAME="SALESRESID"  value="<% if (v_salesResID==null) out.println(""); else out.println(v_salesResID);%>" size="20"></font></td>
    </tr>
  </table>
  <BR>
  <p> 
    <INPUT TYPE="submit" NAME="submit" value='<jsp:getProperty name="rPH" property="pgSave"/>'>
  </p>
</FORM>
  </body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>

