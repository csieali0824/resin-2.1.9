<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>產品機種編碼</title>

<%@ page import="ComboBoxBean,DateBean"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
</head>

<body>
    <%	    	     		 		 
       String modelno=request.getParameter("MODELNO");
    %>
<FORM ACTION="WSModelCodeShow.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submit_check()'>
  <p><strong><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font><font color="#000000" size="+2" face="Times New Roman"> 
    <strong> 產品編碼系統-產品代碼</strong></font><font color="#FF0000" size="+2">註銷</font></strong></p>
  <p><strong><font color="#0000FF" face="Arial">機種編碼 : 
    <%	    	     		 		 
	     try
         {  		 
		  String sSqlC = "";
		  String sWhereC = "";
		
          sSqlC = "select MODELNO as x, MODELNO from MRMODELAPP ";
     	  sWhereC= "where MODELNO IS NOT NULL AND PID <> 'MZ' order by x"; 
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();		  
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  comboBoxBean.setSelection(modelno);		  		  		  
	      comboBoxBean.setFieldName("MODELNO");	   
          out.println(comboBoxBean.getRsString());
      
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
    <input name="Search"  type="submit" value="Query">
</form>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
<script language="JavaScript" type="text/JavaScript">
 function submit_check()
  {
	if (document.MYFORM.MODELNO.value == "--") 
	 {
	    alert("請輸入產品編號!");
	   return (false);
	 }
    else 
     {
      document.MYFORM.submit();
     }
  }
</script>  

