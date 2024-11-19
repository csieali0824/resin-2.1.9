import java.io.Serializable;
import java.sql.*;

public class CheckBoxBeanNew implements java.io.Serializable
{
  ResultSet rs=null;
  private String fieldName="";
  private int column=1;
  private String rsString="";
  private String [] checked;  

  public CheckBoxBeanNew()
  {}

  public String [] getChecked()
 {
  return checked;
 } 

 public void setChecked(String checked[])  
  {
   this.checked=checked;
  } //end of setChecked 

  public int getColumn()
  {
   return column;
  }

  public void setColumn(int column)  
  {
   this.column=column;
  } //end of setColumn

 public String getFieldName()
 {
  return fieldName;
 }

 public void setFieldName(String fieldName)  
  {
   this.fieldName=fieldName;
  } //end of setFieldName 

 public void setRs(ResultSet rs)
 {
  this.rs=rs;
 }
 
  public ResultSet getRs()
  {
    return rs;
  }//enf of ResultSet
 
  public void setRsString(String rsStr)  
  {
   rsString=new String(rsStr);
  } //end of setRsString
   
  public String getRsString() throws Exception
  {
    ResultSetMetaData md=rs.getMetaData();       
    StringBuffer sb=new StringBuffer();        
    int i=1;    
    
    sb.append("<TABLE>");     
    while (rs.next())
    {            
        String s1=(String)rs.getString(1); 
        String s2=(String)rs.getString(2); 
        String checkedFlag="N";
        for (int j=0;j<checked.length;j++)
        {
         if (s1.equals(checked[j])) checkedFlag="Y";
        }

        if (i==1) sb.append("<TR>");             
        if (checkedFlag.equals("Y")) {             
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED>"+s2+"</TD>");                                     
        } else {
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'>"+s2+"</TD>");
        }
        if (i==column) 
        {
         i=1;
        } else {
         i++;
        }        
        if (i==1) sb.append("</TR>");
    } //end of while
    sb.append("</TABLE>"); 
   
    //empty variable
    checked=null;

    return sb.toString();
  } // end of getRsString
} //end of this class