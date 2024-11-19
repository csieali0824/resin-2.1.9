<%
try
{             
 ifxShoesPoolBean.releaseConnection(ifxshoescon); 
 //con.close();
} //end of try
 catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
