<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get the Authentication==========-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<%@ page import="ComboBoxBean,DateBean"%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<title>Key Account Repair Data File Uploading Center</title>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/RPKeyAccountUpfileInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<A HREF='../RepairMainMenu.jsp'>HOME</A><BR>  
<strong><font color="#004080" size="4">Key Account Repair Data File Uploading Center</font></strong>
<table width="64%" border="1">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>      Key Account</strong></font></div></td> 
      <td>
          <%
               try
               {       
                 Statement statement=con.createStatement();
                 String sql = "select AGENTNO, KEYACCNO||'('|| ACCOUNT_NAME || ')' as ACCOUNTNAME from RPKEYACCOUNT WHERE KEYACCNO != '005'";      
                 //out.println(sql);       
                 ResultSet rs=statement.executeQuery(sql);
                 comboBoxBean.setRs(rs);
                 comboBoxBean.setFieldName("AGENTNO");	   
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
      <td width="26%"><div align="right"><font color="#004080"><strong>      Upload FILE</strong></font></div></td>
      <td width="74%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table>  
  <p> 
    <INPUT TYPE="submit" value="UPLOAD">
  </p>
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
