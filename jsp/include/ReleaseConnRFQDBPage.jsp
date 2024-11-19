<%
try
{          

 conRFQ.commit();      
 conRFQ.setAutoCommit(true);   
 oraRFQpoolBean.releaseConnection(conRFQ); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
