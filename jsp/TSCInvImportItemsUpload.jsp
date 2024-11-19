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
<style type="text/css">
<!--
.style1 {color: #FF0000}
-->
</style>
</head>

<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSCInvImportItemsUploadInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<A HREF='/Oradds/ORAddsMainMenu.jsp'>HOME</A><BR>  
<strong><font color="#004080" size="4">Inventory Import Items File Uploading Center</font></strong>
<table width="64%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
    <tr> 
      <td width="26%"><div align="right"><font color="#004080"><strong>      Organization</strong></font></div></td> 
      <td>
          <%
           try
           {   
		      Statement statement=con.createStatement();
              ResultSet rs=null;	
			  String sqlOrgInf = "select a.ORGANIZATION_ID as ORGANIZATION_ID, a.ORGANIZATION_ID||'('||a.ORGANIZATION_CODE||'-'||b.NAME||')' as ORGANIZATION_CODE "+
			                     "from MTL_PARAMETERS a, HR_ORGANIZATION_UNITS b, PER_ORG_STRUCTURE_ELEMENTS c, HR_ORGANIZATION_UNITS d "+
			                     "where a.ORGANIZATION_ID=b.ORGANIZATION_ID and a.ORGANIZATION_ID=c.ORGANIZATION_ID_CHILD "+
								 "and c.ORGANIZATION_ID_PARENT = d.ORGANIZATION_ID "+
								 "order by to_number(substr(a.ORGANIZATION_CODE,2,3)) ";  
			  
              rs=statement.executeQuery(sqlOrgInf);
		  
		      out.println("<select NAME='ORGANIZATION_ID' onChange='setSubmit("+'"'+"../jsp/TSCInvImportItemsUpload.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->--");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(organizationId)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);   
					 organizationCode = s2;                                  
                  } else {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		        } //end of while
		      out.println("</select>"); 	  		  		  
		      rs.close();        	 
           } //end of try		 
           catch (Exception e) { out.println("Exception:"+e.getMessage()); }    
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
  <BR> 
    <INPUT TYPE="submit" value="UPLOAD">
  <BR>
  <span class="style1">*Please  remember ! The uploading file must have &quot;TSC&quot; in leading sheet name.</span> 
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->
