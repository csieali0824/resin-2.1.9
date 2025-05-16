package bean;

import java.io.Serializable;

public class ArrayCheckBoxBean implements Serializable
{
  private String fieldName="";
  private String [] arrayString;
  private String [][] array2DString;
  private String selection="";
  private int fontSize=1; //to set the font size of the table row data
  private String trBgColor="#000099"; //to set the font color of the table row data

  public ArrayCheckBoxBean()
  {}

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

 public String getTrBgColor()
 {
  return trBgColor;
 }

 public void setTrBgColor(String trBgColor)
 {
   this.trBgColor=trBgColor;
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
    for (i=0;i<array2DString.length;i++)
    {
      sb.append("<TR BGCOLOR=E3E3CF>");
      String s1=(String)array2DString[i][0];
      if (s1.equals(selection))
      {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD><TD><FONT SIZE="+fontSize+">"+s1+"</TD>");
      } else {
        sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD><TD><FONT SIZE="+fontSize+">"+s1+"</TD>");
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

  public String getArrayWip2DString() throws Exception
  {
    StringBuffer sb=new StringBuffer();
    int i=1,j=1,k=1;

    sb.append("<TABLE width='30%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
    if(arrayString != null && arrayString.length > 0)
    {
            sb.append("<TR BGCOLOR="+trBgColor+">");
            for(k = 0; k < arrayString.length; k++)
            {
                String s = arrayString[k];
                sb.append("<TD NOWRAP><FONT COLOR=WHITE>" + s + "</FONT></TD>");
            }
            sb.append("</TR>");
    }
    for (i=0;i<array2DString.length;i++)
    { //System.out.println("3");
      sb.append("<TR BGCOLOR=E3E3CF>");
      String s1=(String)array2DString[i][0];
      if (s1.equals(selection))
      {
        sb.append("<TD NOWRAP><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"' CHECKED></TD><TD NOWRAP><FONT SIZE="+fontSize+">"+s1+"</TD>");
      } else {
        sb.append("<TD NOWRAP><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+s1+"'></TD><TD NOWRAP><FONT SIZE="+fontSize+">"+s1+"</TD>");
      }
      //System.out.println("4");
      for (j=1;j<array2DString[i].length;j++)
      {
        String s2=(String)array2DString[i][j];
        sb.append("<TD NOWRAP><FONT SIZE="+fontSize+">"+s2+"</TD>");
      } //end of for j
      sb.append("</TR>");
      //System.out.println("5");
    } //end of for i
    sb.append("</TABLE>");

    //empty variable
    selection="";

    return sb.toString();
  } // end of getArrayWip2DString

} //end of this class