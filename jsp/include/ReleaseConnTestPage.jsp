<%
try
{          

 conTst.commit();      
 conTst.setAutoCommit(true);   
 oradTstpoolBean.releaseConnection(conTst); 
 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>