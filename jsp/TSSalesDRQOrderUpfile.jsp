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
<FORM NAME="MYFORM" ACTION="../jsp/TSSalesDRQOrderUpfileInsert.jsp" METHOD="post" ENCTYPE="multipart/form-data">
<A HREF='../OraddsMainMenu.jsp'>HOME</A><BR>  
<strong><font color="#004080" size="4">RFQ Sales Order File Upload Center</font></strong>
<table width="64%" border="1">
    <tr> 
      <td colspan="1"><div align="right"><font color="#004080"><strong>      Sales Area</strong></font></div></td>               
	  <td>
          <%		 
	       try
           {   
		           Statement statement=con.createStatement();
                   ResultSet rs=null;	
			       String sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA ";
				   String sWhere = "where SALES_AREA_NO > 0 ";
				   if (UserRoles=="admin" || UserRoles.equals("admin")) { }  // 若為管理員,可開立任何一區詢問單
				   else {  sWhere = sWhere + "and SALES_AREA_NO='"+userActCenterNo+"' ";}  // 否則,就只能開立所屬區域單
				   sql = sql + sWhere;
				   //out.println(sql);
                   rs=statement.executeQuery(sql);	
				  /* 	           
				   comboBoxBean.setRs(rs);
				   if (salesAreaNo==null)
		           { comboBoxBean.setSelection(userActCenterNo); }
				   else { comboBoxBean.setSelection(salesAreaNo); }
	               comboBoxBean.setFieldName("SALESAREANO");	   
                   out.println(comboBoxBean.getRsString());
				   */
				   out.println("<select NAME='SALESAREANO' tabindex='1' onChange='setSubmit3("+'"'+"../jsp/TSSalesDRQ_Create.jsp?INSERT=Y"+'"'+")'>");				  				  
	               out.println("<OPTION VALUE=-->--");     
	               while (rs.next())
	               {            
		             String s1=(String)rs.getString(1); 
		             String s2=(String)rs.getString(2); 
                     if (s1.equals(salesAreaNo) || s1.equals(userActCenterNo)) 
  		             {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
                     } else {
                             out.println("<OPTION VALUE='"+s1+"'>"+s2);
                            }        
	               } //end of while
	               out.println("</select>"); 
		           rs.close();   
				   statement.close(); 
		    } //end of try
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }		   
       %>
      </td>
    </tr>      
    <tr> 
      <td width="39%"><div align="right"><font color="#004080"><strong>      Upload File</strong></font></div></td>
      <td width="61%"><font size="2"> 
        <INPUT TYPE="FILE" NAME="UPLOADFILE">
        </font></td>
    </tr>
  </table>  
  <BR> 
    <INPUT TYPE="submit" value="UPLOAD">
  <BR>  
</FORM>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=============以下區段為釋放連結池==========-->

