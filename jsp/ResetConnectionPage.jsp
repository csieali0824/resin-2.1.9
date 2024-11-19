<%@ page import="PoolBean,TelnetBean"%>
<jsp:useBean id="poolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="authPoolBean" scope="application" class="PoolBean"/>

<jsp:useBean id="oraddspoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssqlpoolBean" scope="application" class="PoolBean"/>
<jsp:useBean id="mssql65poolBean" scope="application" class="PoolBean"/>

<jsp:useBean id="telnetBean" scope="application" class="TelnetBean"/>
<jsp:useBean id="telnetBean_TPE" scope="application" class="TelnetBean"/>


<%
try
{    
  if (poolBean.getDriver()!=null)
  {   
   poolBean.emptyPool();   
   poolBean.resetPool();       
  } //end of if  
  
  if (authPoolBean.getDriver()!=null)
  {   
   authPoolBean.emptyPool();   
   authPoolBean.resetPool();       
  } //end of if   
  
  if (oraddspoolBean.getDriver()!=null)
  {   
   oraddspoolBean.emptyPool();   
   oraddspoolBean.resetPool();       
  } //end of if 
  
  // Reset MS-SQL6.5 Server pool (for TEW/ILAN System )
  if (mssqlpoolBean.getDriver()!=null)
  {   
   mssqlpoolBean.emptyPool();   
   mssqlpoolBean.resetPool();    
  } //end of if
  
  // Reset MS-SQL6.5 Server pool (for YEW System )
  if (mssql65poolBean.getDriver()!=null)
  {   
   mssql65poolBean.emptyPool();   
   mssql65poolBean.resetPool();    
  } //end of if
  
  
  out.println("Has Closed All Database Connection !!");
  
  //telnet to SHANGHAI unix server
  if (telnetBean.getInuse()==false)
  {    
    telnetBean.disconnect(); 
  }	
  //telnet to TAIPEI unix server
  if (telnetBean_TPE.getInuse()==false)
  {    
    telnetBean_TPE.disconnect(); 
  }	
  
  
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB
%>

