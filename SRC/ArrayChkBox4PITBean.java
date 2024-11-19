import java.io.Serializable;
import java.sql.*;

public class ArrayChkBox4PITBean implements java.io.Serializable
{
  private String fieldName="";  
  private String [] arrayString;
  private String [][] array2DString;
  private String selection="";
  private int fontSize=1; //to set the font size of the table row data
  private String [] headerArray;

  public ArrayChkBox4PITBean()
  {}  
 
 public void setHeaderArray(String asStr[])  
 {
   headerArray=asStr;
 } //end of headerArray
 
 public String getSelection()
 {
  return selection;
 }

 public int getFontSize()
 {
  return fontSize;
 }

 public void setFontSize(int fs)  
 {
   this.fontSize=fs;
 } //end of setFontSize

 public void setSelection(String selection)  
  {
   this.selection=selection;
  } //end of setSelection 

 public String getFieldName()
 {
  return fieldName;
 }

 public void setFieldName(String fieldName)  
  {
   this.fieldName=fieldName;
  } //end of setFieldName  
 
 public String [] getArrayContent()  
  {
   return arrayString;
  } //end of getArrayContent

 public String [][] getArray2DContent()  
 {
   return array2DString;
 } //end of get2DArrayContent 

  public void setArrayString(String asStr[])  
  {
   arrayString=asStr;
  } //end of arrayString

 public void setArray2DString(String asStr[][])  
 {
  array2DString=asStr;
 } //end of setArray2DString 
   
  public String getArrayString() throws Exception
  {          
    StringBuffer sb=new StringBuffer();        
    int i=1;    
    
    sb.append("<TABLE>");         
    if (headerArray!=null && headerArray.length>0) //若有table header,就置入之
    {
         for (int j=0;j<headerArray.length;j++)
         {          
           String h1=(String)headerArray[j];
           sb.append("<TH BGCOLOR='BLACK'><FONT COLOR='WHITE' SIZE="+fontSize+">"+h1+"</TH>");
         }
    }  
    for (i=0;i<arrayString.length;i++)
    {                          
        String s1=(String)arrayString[i]; 
        sb.append("<TR BGCOLOR=E3E3CF>");                 
        if (s1.equals(selection)) 
        {
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD><TD><FONT SIZE="+fontSize+">"+s1+"</TD>");                                    
        } else {
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD><TD><FONT SIZE="+fontSize+">"+s1+"</TD>");
        }       
       sb.append("</TR>");   
    } //end of while
    sb.append("</TABLE>"); 
   
    //empty variable
    selection="";

    return sb.toString();
  } // end of getArrayString

  public String getArray2DString() throws Exception
  {          
    StringBuffer sb=new StringBuffer();        
    int i=1,j=1;    
    
    sb.append("<TABLE>"); 
    if (headerArray!=null && headerArray.length>0) //若有table header,就置入之
    {
         for (int k=0;k<headerArray.length;k++)
         {          
           String h1=(String)headerArray[k];
           sb.append("<TH BGCOLOR='BLACK'><FONT COLOR='WHITE' SIZE="+fontSize+">"+h1+"</TH>");
         }
    }            
    for (i=0;i<array2DString.length;i++)
    {   
      sb.append("<TR BGCOLOR=E3E3CF>");                 
      String s1=(String)array2DString[i][0];
      if (s1.equals(selection)) 
      {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD>");                                    
      } else {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD>");
      }                        
      for (j=1;j<array2DString[i].length;j++)      
      {
        String s2=(String)array2DString[i][j];                   
        sb.append("<TD><FONT SIZE="+fontSize+">"+s2+"</TD>");
      } //end of for j
      sb.append("</TR>");
    } //end of for i
    sb.append("</TABLE>"); 
   
    //empty variable
    selection="";

    return sb.toString();
  } // end of getArray2DString
} //end of this class