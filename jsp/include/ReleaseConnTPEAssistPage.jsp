<%
try
{          
 tpe70iLncon.commit();      
 tpe70iLncon.setAutoCommit(true);   
 msTpe70poolBean.releaseConnection(tpe70iLncon);
 
 
 msTpe70poolBean.releaseConnection(tpe70iLncon);
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
