<%
try
{          
 authcon.commit();      
 authcon.setAutoCommit(true);   
 authPoolBean.releaseConnection(authcon);
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>