<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>產品機種編碼</title>

<%@ page import="CheckBoxBeanNew,CheckBoxBean,ComboBoxBean,ArrayComboBoxBean,DateBean,ArrayCheckBoxBean"%>
<jsp:useBean id="checkBoxBean" scope="page" class="CheckBoxBean"/>
<jsp:useBean id="checkBoxBeanNew" scope="page" class="CheckBoxBeanNew"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayCheckBoxBean" scope="session" class="ArrayCheckBoxBean"/> <!--|1bean§@¥I|b|s?J?G?U’y-z-->
<%
  arrayCheckBoxBean.setArray2DString(null);//±N|1bean-E2MaA¥H?°?£|Pcase¥i¥H-?·s1B§@
%>
</head>

<body>
    <%	    	     		 		 
       String chooseItem=request.getParameter("chooseItem");
       String userName=request.getParameter("userName");
    %>
<FORM ACTION="WSDOCMNTInput.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()'>
  <p><strong><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
    <strong> 產品編碼系統-產品<font color="#FF0000">規格補登</font></strong></font></strong></p>
  <p><strong><font color="#0000FF" face="Arial">機種編碼 : </font><font size="2" face="Times New Roman, Times, serif">
    <%	    	     		 		 
	     try
         {  		 
//          String MODELNO=request.getParameter("MODELNO");
          String APPNO=request.getParameter("APPNO");
		  String sSqlC = "";
		  String sWhereC = "";
		
          sSqlC = "select a.APPNO as x, a.MODELNO from MRMODELAPP a,MRMODEL_DOCMNT b ";
    	  sWhereC= "where a.APPNO=b.APPNO AND (b.SPECFILE_NAME IS NULL OR b.IMAGEVIEW_NAME IS NULL) order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (chooseItem!=null && !chooseItem.equals("--"))  comboBoxBean.setSelection(APPNO);		  		  		  
	      comboBoxBean.setFieldName("APPNO");	   
          out.println(comboBoxBean.getRsString());
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
    </font><font color="#0000FF" face="Arial"> 
    <input name="Search"  type="submit" value="Query">
    </font></strong></p>
  <p> <em>　 </em> </p>
  </form>
<p><em>　</em></p>
<p>&nbsp;</p><p>&nbsp;</p>
<p>&nbsp; </p>
</body>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>

<script language="JavaScript"> 
 function submit_check(){
	if (document.MYFORM.APPNO.value == "") 
	 {
	    alert("請選澤產品編號!");
	   return (false);
	 }
    else 
     {
      document.signform.submit();
     }
    </script>  
