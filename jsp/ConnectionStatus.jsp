<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="PoolBean"%>
<jsp:useBean id="poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="authPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="dmpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="ifxpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="bpcsPoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mespoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssql65poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="msTpe70poolBean" scope="application" class="PoolBean"/>


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
<FORM ACTION="ConnectionRelease.jsp" METHOD="post" >
<INPUT TYPE="button"  value="Release Selected Connection" onClick='submit()' >
<BR>
<% 
try
{    
  if (poolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.POOLBEANCHOICE)' value='Select All'>");
   poolBean.setFieldName("POOLBEANCHOICE");
   out.println(poolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if  
  
  if (authPoolBean.getDriver()!=null)
  {   
  out.println("<input name='button' type='button' onClick='this.value=check(this.form.AUTHPOOLBEANCHOICE)' value='Select All'>");
   authPoolBean.setFieldName("AUTHPOOLBEANCHOICE");
   out.println(authPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (oraddspoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.ORADDSPOOLBEANCHOICE)' value='Select All'>");
   oraddspoolBean.setFieldName("ORADDSPOOLBEANCHOICE");
   out.println(oraddspoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 

  if (dmpoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.DMPOOLBEANCHOICE)' value='Select All'>");
   dmpoolBean.setFieldName("DMPOOLBEANCHOICE");
   out.println(dmpoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if   
  
  if (cqPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.CQPOOLBEANCHOICE)' value='Select All'>");
   cqPoolBean.setFieldName("CQPOOLBEANCHOICE");
   out.println(cqPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if   
  
  if (pdmPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.PDMPOOLBEANCHOICE)' value='Select All'>");
   pdmPoolBean.setFieldName("PDMPOOLBEANCHOICE");
   out.println(pdmPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if  
  
  if (repairpoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.REPAIRPOOLBEANCHOICE)' value='Select All'>");
   repairpoolBean.setFieldName("REPAIRPOOLBEANCHOICE");
   out.println(repairpoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if  
  
  if (ifxpoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXPOOLBEANCHOICE)' value='Select All'>");
    ifxpoolBean.setFieldName("IFXPOOLBEANCHOICE");
    out.println(ifxpoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxDbexpPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDBEXPPOOLBEANCHOICE)' value='Select All'>");
    ifxDbexpPoolBean.setFieldName("IFXDBEXPPOOLBEANCHOICE");
    out.println(ifxDbexpPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxTmpBOMPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXTMPBOMPOOLBEANCHOICE)' value='Select All'>");
    ifxTmpBOMPoolBean.setFieldName("IFXTMPBOMPOOLBEANCHOICE");
    out.println(ifxTmpBOMPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  
  if (ifxDbglobalPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDBGLOBALPOOLBEANCHOICE)' value='Select All'>");
    ifxDbglobalPoolBean.setFieldName("IFXDBGLOBALPOOLBEANCHOICE");
    out.println(ifxDbglobalPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
   if (ifxTestPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXTESTPOOLBEANCHOICE)' value='Select All'>");
    ifxTestPoolBean.setFieldName("IFXTESTPOOLBEANCHOICE");
    out.println(ifxTestPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxDistPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDISTPOOLBEANCHOICE)' value='Select All'>");
    ifxDistPoolBean.setFieldName("IFXDISTPOOLBEANCHOICE");
    out.println(ifxDistPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxShoesPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXSHOESPOOLBEANCHOICE)' value='Select All'>");
    ifxShoesPoolBean.setFieldName("IFXSHOESPOOLBEANCHOICE");
    out.println(ifxShoesPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (mespoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.MESPOOLBEANCHOICE)' value='Select All'>");
   mespoolBean.setFieldName("MESPOOLBEANCHOICE");
   out.println(mespoolBean.getConnStatus());    
   out.println("<BR>"); 
  } //end of if
  
  if (mssqlpoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.MSSQLPOOLBEANCHOICE)' value='Select All'>");	 
    mssqlpoolBean.setFieldName("MSSQLPOOLBEANCHOICE");	 
    out.println(mssqlpoolBean.getConnStatus());   	  
    out.println("<BR>"); 
  } //end of if 
  
  if (mssql65poolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.MSSQL65POOLBEANCHOICE)' value='Select All'>");
   mssql65poolBean.setFieldName("MSSQL65POOLBEANCHOICE");
   out.println(mssql65poolBean.getConnStatus());    
   out.println("<BR>"); 
  } //end of if 
  
  if (msTpe70poolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.MSTPE70POOLBEANCHOICE)' value='Select All'>");
   msTpe70poolBean.setFieldName("MSTPE70POOLBEANCHOICE");
   out.println(mssql65poolBean.getConnStatus());    
   out.println("<BR>"); 
  } //end of if 
  
  if (bpcsPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.BPCSPOOLBEANCHOICE)' value='Select All'>");
    bpcsPoolBean.setFieldName("BPCSPOOLBEANCHOICE");
    out.println(bpcsPoolBean.getConnStatus());  
	out.println("<BR>"); 
  } //end of if  
  
  if (ifxDbgroupPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDBGROUPPOOLBEANCHOICE)' value='Select All'>");
   ifxDbgroupPoolBean.setFieldName("IFXDBGROUPPOOLBEANCHOICE");
   out.println(ifxDbgroupPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxTechPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXTECHPOOLBEANCHOICE)' value='Select All'>");
   ifxTechPoolBean.setFieldName("IFXTECHPOOLBEANCHOICE");
   out.println(ifxTechPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxNetPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXNETPOOLBEANCHOICE)' value='Select All'>");
   ifxNetPoolBean.setFieldName("IFXNETPOOLBEANCHOICE");
   out.println(ifxNetPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxdbintPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDBINTPOOLBEANCHOICE)' value='Select All'>");
   ifxdbintPoolBean.setFieldName("IFXDBINTPOOLBEANCHOICE");
   out.println(ifxdbintPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxmicroPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXMICROPOOLBEANCHOICE)' value='Select All'>");
   ifxmicroPoolBean.setFieldName("IFXMICROPOOLBEANCHOICE");
   out.println(ifxmicroPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxaresPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXARESPOOLBEANCHOICE)' value='Select All'>");
   ifxaresPoolBean.setFieldName("IFXARESPOOLBEANCHOICE");
   out.println(ifxaresPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if 
  
  if (ifxwwwPoolBean.getDriver()!=null)
  {   
   out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXWWWPOOLBEANCHOICE)' value='Select All'>");
   ifxwwwPoolBean.setFieldName("IFXWWWPOOLBEANCHOICE");
   out.println(ifxwwwPoolBean.getConnStatus());  
   out.println("<BR>"); 
  } //end of if   
  
  if (ifxTstexpPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXTSTEXPPOOLBEANCHOICE)' value='Select All'>");
    ifxTstexpPoolBean.setFieldName("IFXTSTEXPPOOLBEANCHOICE");
    out.println(ifxTstexpPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxDbtelPoolBean.getDriver()!=null)
  { 
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXDBTELPOOLBEANCHOICE)' value='Select All'>");  
    ifxDbtelPoolBean.setFieldName("IFXDBTELPOOLBEANCHOICE");
    out.println(ifxDbtelPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
  if (ifxNSalTestPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXNOTESALTESTPOOLBEANCHOICE)' value='Select All'>");
    ifxNSalTestPoolBean.setFieldName("IFXNOTESALTESTPOOLBEANCHOICE");
    out.println(ifxNSalTestPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if
   if (ifxNotesSalPoolBean.getDriver()!=null)
  {   
    out.println("<input name='button' type='button' onClick='this.value=check(this.form.IFXNOTESSALPOOLBEANCHOICE)' value='Select All'>");
    ifxNotesSalPoolBean.setFieldName("IFXNOTESSALPOOLBEANCHOICE");
    out.println(ifxNotesSalPoolBean.getConnStatus());  
	out.println("<BR>");    
  } //end of if 
  
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB
%>
</FORM>
