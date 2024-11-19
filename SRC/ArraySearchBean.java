import java.io.Serializable;
import java.io.*;
import java.util.*;

public class ArraySearchBean implements java.io.Serializable
{  
 private String [] arraySearch; 
 private String keyString="";

 public ArraySearchBean()
 {} 
 
 public String getKeyString()
 {
  return keyString;
 }

 public void setKeyString(String KeyString)  
 {
  this.keyString=keyString;
 } //end of seKeyString 

 public String [] getArraySearch()
 {
  return arraySearch;
 } 

 public void setArraySearch(String arraySearch[])  
 {
   this.arraySearch=arraySearch;
 } //end of setArraySearch 
   
 public int getElementAt() throws Exception
 {       
   int left=0;
   int right=arraySearch.length-1;
   int middle;
   
   while (left<=right)
   {
    middle=(left+right)/2;
     if (keyString.equals(arraySearch[middle]))     
     	return middle;
     else if (keyString.compareTo(arraySearch[middle])<0)
        right=middle-1;
     else 
      left=middle+1;   
   }
   return -1;                
 } // end of getElementAt()
} //end of this class