package bean;

import java.io.Serializable;
import java.sql.Blob;
import java.sql.ResultSet;


public class ShowImageBean implements Serializable
{
  ResultSet rs=null;  
  int    bbuffSize = 64 ;
  byte[]  bbuff = new byte[bbuffSize] ;  
  byte[]  emptybbuff = new byte[bbuffSize] ; //if there is no any buffer
  Blob blob ;
  String whichView="";      

 public ShowImageBean()
 {} 

 public void setWhichView(String whichView)  
 {
  this.whichView=whichView;
 } //end of setWhichView

 public void setRs(ResultSet rs)
 {
  this.rs=rs;
 }
 
  public ResultSet getRs()
  {
    return rs;
  }//enf of ResultSet 
   
  public byte [] getBLOB() throws Exception
  {       
   if (rs.next())
   {
    blob = (Blob)rs.getObject(whichView) ;  
    bbuff = blob.getBytes(1, (int)blob.length()); 
    return bbuff;             
   } else {
    return emptybbuff; 
   }            
  } // end of getBLOB
} //end of this class