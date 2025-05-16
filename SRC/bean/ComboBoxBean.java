package bean;

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class ComboBoxBean implements Serializable
{
  ResultSet rs=null;
  private String fieldName="";
  private String rsString="";
  private String selection="";
  private String onChangeJS="";
  private int fontSize=12; //to set the font size of the COMBOBOX
  private String fontName="Arial";
  private String tabIndex="";

 public ComboBoxBean()
 {}

 public int getFontSize()
 {
  return fontSize;
 }

 public void setFontSize(int fs)
 {
   this.fontSize=fs;
 } //end of setFontSize

 public String getFontName()
 {
  return fontName;
 }

 public void setFontName(String fn)
 {
   this.fontName=fn;
 } 
 
 public String getTabIndex()
 {
  return tabIndex;
 }

 public void setTabIndex(String tabOrder)
 {
   this.tabIndex=tabOrder;
 } //end of setTabIndex

 public String getOnChangeJS()
 {
  return onChangeJS;
 }

 public void setOnChangeJS(String ocjs)
  {
   this.onChangeJS=ocjs;
  } //end of setOnChangeJS


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

    if (onChangeJS.equals("")) //如果有設定JavaScript之on Change事件時執行Function,則在選單中加入
    {
       if (tabIndex.equals(""))
       {
          sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+";font-family:"+fontName+"'>");
       } else {
                sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+";font-family:"+fontName+"' tabindex='"+tabIndex+"'>");
              }      // 如果有設定物件的TabIndex時則選單中加入
    } else {
             if (tabIndex.equals(""))
             {
              sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+";font-family:"+fontName+"' onChange='"+onChangeJS+"'>");
             } else {
                      sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+";font-family:"+fontName+"' onChange='"+onChangeJS+"' tabindex='"+tabIndex+"'>");
                    } // 如果有設定物件的TabIndex時則選單中加入
           }

    sb.append("<OPTION VALUE=-->--");
    while (rs.next())
    {
        String s1=(String)rs.getString(1);
        String s2=(String)rs.getString(2);

        if (s1.equals(selection))
        {
          sb.append("<OPTION VALUE='"+s1+"' SELECTED>"+s2);
        } else {
          sb.append("<OPTION VALUE='"+s1+"'>"+s2);
        }
    } //end of while
    sb.append("</select>");

    //empty variable
    selection="";

    return sb.toString();
  } // end of getRsString
} //end of this class