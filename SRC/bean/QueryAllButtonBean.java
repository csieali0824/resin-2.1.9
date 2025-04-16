package bean;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class QueryAllButtonBean implements Serializable
{
  ResultSet rs=null;
  private String buttonName="";  
  private String buttonContent="";
  private String rsString="";

  public QueryAllButtonBean()
  {} 

 public String getButtonName()
 {
  return buttonName;
 }

 public void setButtonName(String buttonName)  
  {
   this.buttonName=buttonName;
  } //end of setButtonName 

  public String getButtonContent()
 {
  return buttonContent;
 }

 public void setButtonContent(String buttonContent)  
  {
   this.buttonContent=buttonContent;
  } //end of setButtonContent 

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
    int colCount=md.getColumnCount();
    String colLabel[]=new String[colCount+1];
    StringBuffer sb=new StringBuffer();

    sb.append("<TABLE>");      
    sb.append("<TR>");
    sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>&nbsp;</TH>");
    for (int i=1;i<=colCount;i++)
    {
      colLabel[i]=md.getColumnLabel(i);
      sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
    } //end of for 
    sb.append("</TR>");
 
    while (rs.next())
    {
      sb.append("<TR BGCOLOR=E3E3CF><TD><INPUT TYPE=button NAME='button' VALUE="+buttonName+" onClick="+buttonContent+"()></TD>");
      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
        sb.append("<TD><FONT SIZE=2>"+s+"</TD>");
       } //end of for
       sb.append("</TR>");
    } //end of while
    sb.append("</TABLE>");
    return sb.toString();               
  } // end of getRsString
} //end of this class