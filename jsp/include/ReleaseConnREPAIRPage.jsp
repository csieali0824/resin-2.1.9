<%
try
{          

 conREPAIR.commit();      
 conREPAIR.setAutoCommit(true);   
 repairpoolBean.releaseConnection(conREPAIR); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>