package bean;

import java.io.Serializable;
import java.sql.ResultSet;

public class RsCountBean implements Serializable
{
  ResultSet rs=null;  
  
 public RsCountBean()
 {}
 
 public void setRs(ResultSet rs)
 {
  this.rs=rs;
 }
 
  public ResultSet getRs()
  {
    return rs;
  }//enf of ResultSet  
   
  public int getRsCount() throws Exception
  {    
    int rsCount=0;	
    rs.beforeFirst();
    while (rs.next())
    {
      rsCount++;
    } //end of while
    
    rs.beforeFirst();
    return rsCount;
  } // end of getRsCount
} //end of this class