<%
try
{          

 conCQ.commit();      
 conCQ.setAutoCommit(true);   
 cqPoolBean.releaseConnection(conCQ); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>