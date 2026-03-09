<%@ page import="bean.PoolBean,IfxPoolBean"%>
<jsp:useBean id="poolBean" scope="application" class="bean.PoolBean"/>
<%
try
{    
  if (poolBean.getDriver()!=null)
  {
   out.println(poolBean.pool.getSize());  
  } //end of if  
  
} //end of try
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
// End of Connect to WINSDB
%>

