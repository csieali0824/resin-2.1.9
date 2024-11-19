<%
try
{          

 conDev.commit();      
 conDev.setAutoCommit(true);   
 oraDevpoolBean.releaseConnection(conDev); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>