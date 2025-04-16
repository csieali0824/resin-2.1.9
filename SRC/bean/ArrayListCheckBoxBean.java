package bean;

import java.io.Serializable;

public class ArrayListCheckBoxBean implements Serializable
{
  private String fieldName="";  
  private String [] arrayString;
  private String [][] array2DString;
  private String [][] array2DCheck;
  private String selection="";

  public ArrayListCheckBoxBean()
  {}  
 
 public String getSelection()
 {
  return selection;
 }

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
   
 public void setArray2DCheck(String ckStr[][])  
 {
  array2DCheck=ckStr;
 } //end of setArray2DCheck 

  public String [][] getCheckContent()  
 {
   return array2DCheck;
 } //end of getCheckContent 

  public String getArrayString() throws Exception
  {          
    StringBuffer sb=new StringBuffer();        
    int i=1;    
    
    sb.append("<TABLE>");         
    for (i=0;i<arrayString.length;i++)
    {                          
        String s1=(String)arrayString[i]; 
        sb.append("<TR BGCOLOR=E3E3CF>");                 
        if (s1.equals(selection)) 
        {
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD><TD><FONT SIZE=1>"+s1+"</TD>");                                    
        } else {
          sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD><TD><FONT SIZE=1>"+s1+"</TD>");
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
    if (arrayString!=null && arrayString.length>0) //若有table header,就置入之
    {
     sb.append("<TR BGCOLOR=BLACK>"); 
     for (i=0;i<arrayString.length;i++)
     {          
      String s1=(String)arrayString[i];
      sb.append("<TD><FONT SIZE=2 COLOR=WHITE>"+s1+"</TD>");
     }
     sb.append("</TR>");
    }

    for (i=0;i<array2DString.length;i++)
    {   
      sb.append("<TR BGCOLOR=E3E3CF>");                 
      String s1=(String)array2DString[i][0];
      if (s1.equals(selection)) 
      {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD><TD><FONT SIZE=2>"+s1+"</TD>");                                    
      } else {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD><TD><FONT SIZE=2>"+s1+"</TD>");
      }                      
      for (j=1;j<array2DString[i].length;j++)      
      {
        String s2=(String)array2DString[i][j];                  
        sb.append("<TD><FONT SIZE=1>"+s2+"</TD>");        
      } //end of for j
      sb.append("</TR>");
    } //end of for i
    sb.append("</TABLE>"); 
   
    //empty variable
    selection="";

    return sb.toString();
  } // end of getArray2DString

  public String getResultString() throws Exception
  {          
    StringBuffer sb=new StringBuffer();        
    int i=1,j=1;    
    
    sb.append("<TABLE>");         
    if (arrayString!=null && arrayString.length>0) //若有table header,就置入之
    {
     sb.append("<TR BGCOLOR=BLACK>"); 
     for (i=0;i<arrayString.length;i++)
     {          
      String s1=(String)arrayString[i];
      sb.append("<TD><FONT SIZE=1 COLOR=WHITE>"+s1+"</TD>");
     }
     sb.append("</TR>");
    }

    for (i=0;i<array2DString.length;i++)
    {   
      sb.append("<TR BGCOLOR=E3E3CF>");            
      sb.append("<TD>&nbsp;&nbsp;</TD>");
      for (j=0;j<array2DString[i].length;j++)      
      {
        String s1=(String)array2DString[i][j];                           
        sb.append("<TD><FONT SIZE=1>"+s1+"</TD>");
      } //end of for j
      sb.append("</TR>");
    } //end of for i
    sb.append("</TABLE>");    
    
    return sb.toString();
  } // end of getResultString
} //end of this class