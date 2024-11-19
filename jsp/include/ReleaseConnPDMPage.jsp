<%
try
{      
 pdmcon.commit();      
 pdmcon.setAutoCommit(true);   
 pdmPoolBean.releaseConnection(pdmcon);  
 //pdmcon.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>