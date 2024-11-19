<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="PoolBean,ConnBean"%>
<jsp:useBean id="poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="authPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="dmpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="bpcsPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mespoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssql65poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbexpPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbglobalPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTestPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDistPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxShoesPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="repairpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTstexpPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="cqPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="pdmPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="oraddspoolBean" scope="application" class="PoolBean"/>

<jsp:useBean id="ifxNetPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxdbintPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbgroupPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTechPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxmicroPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxaresPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxwwwPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxDbtelPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxNSalTestPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxNotesSalPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxTmpBOMPoolBean" scope="application" class="PoolBean"/>
<script language="JavaScript" type="text/JavaScript">
function submit()
{   
  this.submit();
}
function releaseInActiveConn()
{
   window.document.MYFORM.RELEASE.click();
   return false;
}
var checkflag = "false";
function check(field) 
{
 
  if(field!=undefined )
  {
	  if (checkflag == "false") 
	  {
		for (i = 0; i < field.length; i++) 	{ field[i].checked = true;}
		checkflag = "true";
		return "Cancel Selected"; 
	  } else {
		 for (i = 0; i < field.length; i++) { field[i].checked = false;}
		 checkflag = "false";
		 return "Select All"; 
	  }
  }	else {
    return "Select All";
  }  
}
</script>
<FORM name="MYFORM" ACTION="ConnectionALLRelease.jsp" METHOD="post">
<INPUT TYPE="button" name="RELEASE" value="Release Selected Connection" onClick='submit()' >
<BR>
<% 
 String releaseFlag=request.getParameter("RELEASEFLAG");  
 if (releaseFlag==null) releaseFlag = "N";
 
try
{    
  if (poolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.POOLBEANCHOICE)' value='Select All'>");
   poolBean.setFieldName("POOLBEANCHOICE");
   out.println(poolBean.getSelALLConnStatus());  
   out.println("<BR>"); 
  } //end of if  
  
  if (authPoolBean.getDriver()!=null)
  {   
  out.println("<input name='button' type='button' onClick='this.value=check(this.form.AUTHPOOLBEANCHOICE)' value='Select All'>");
   authPoolBean.setFieldName("AUTHPOOLBEANCHOICE");
   out.println(authPoolBean.getSelALLConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (oraddspoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.ORADDSPOOLBEANCHOICE)' value='Select All'>");
   oraddspoolBean.setFieldName("ORADDSPOOLBEANCHOICE");
   out.println(oraddspoolBean.getSelALLConnStatus());  
   out.println("<BR>");    
  } //end of if 
  
  if (mssqlpoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.MSSQLPOOLBEANCHOICE)' value='Select All'>");
   mssqlpoolBean.setFieldName("MSSQLPOOLBEANCHOICE");
   out.println(mssqlpoolBean.getSelALLConnStatus());    
   out.println("<BR>"); 
  } //end of if 
  
  if (mssql65poolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.MSSQL65POOLBEANCHOICE)' value='Select All'>");
   mssql65poolBean.setFieldName("MSSQL65POOLBEANCHOICE");
   out.println(mssql65poolBean.getSelALLConnStatus());    
   out.println("<BR>"); 
  } //end of if  
  
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB

%>

<%
  if (releaseFlag.equals("Y"))
  {     
%>
<script language="javascript">
     //submit();  
    releaseInActiveConn();
	 //this.submit();   	 
</script>
<%
   } // End of if
%>
</FORM>
