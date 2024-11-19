import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class QryAllChkBoxEditFBean implements java.io.Serializable
{
  ResultSet rs=null;
  private String fieldName="";  
  private String rsString="";
  private String searchKey="";
  private String pageURL="";
  private int scrollRowNumber=0; //設定頁面資料數
  int rowNumber=0;//設定現在資料列游標在第幾筆

  public QryAllChkBoxEditFBean() {}

 public int getScrollRowNumber()
 {
  return scrollRowNumber;
 }

 public void setScrollRowNumber(int scrollRowNumber)  
  {
   this.scrollRowNumber=scrollRowNumber;
  } //end of setScrollRowNumber 

 public int getRowNumber()
 {
  return rowNumber;
 } 
 
 public void setRowNumber(int rowNumber)  
  {
   this.rowNumber=rowNumber;
  } //end of setRowNumber 

 public String getPageURL()
 {
  return pageURL;
 }

 public void setPageURL(String pageURL)  
  {
   this.pageURL=pageURL;
  } //end of setpageURL 

 public String getSearchKey()
 {
  return searchKey;
 }

 public void setSearchKey(String searchKey)  
  {
   this.searchKey=searchKey;
  } //end of setSearchKey 

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
    int colCount=md.getColumnCount();
    String colLabel[]=new String[colCount+1];
    StringBuffer sb=new StringBuffer();
    String bgColor="E3E3CF";
    //String fontSize="3";

    sb.append("<TABLE>");      
    sb.append("<TR>");
    sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE>&nbsp;</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE>&nbsp;</TH>");
    for (int i=1;i<=colCount;i++)
    {
      colLabel[i]=md.getColumnLabel(i);
      sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
    } //end of for 
    sb.append("</TR>");
    
    int j=0;
    while (rs.next())
    {
      if (j==scrollRowNumber && scrollRowNumber>0) break;      
      j++;      
      sb.append("<TR BGCOLOR="+bgColor+"><TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE="+(String)rs.getString(searchKey)+"></TD>");      
      sb.append("<TD><A HREF='"+pageURL+"?"+searchKey+"="+rs.getString(searchKey)+"'><img src='../image/docicon.gif'></A></TD>");
      
      if (colCount>=7)
      {
        for (int i=1;i<=colCount;i++)
        {
          String s=(String)rs.getString(i);
          sb.append("<TD><FONT SIZE=2>"+s+"</TD>");
         } //end of for
         sb.append("</TR>");

        if (bgColor.equals("E3E3CF")) //間隔列顏色改換
        {
          bgColor="E3E3B0";
        } else {
          bgColor="E3E3CF";
        }
      }
      else
      {
      	for (int i=1;i<=colCount;i++)
        {
          String s=(String)rs.getString(i);
          sb.append("<TD><FONT SIZE=3>"+s+"</TD>");
         } //end of for
         sb.append("</TR>");

        if (bgColor.equals("E3E3CF")) //間隔列顏色改換
        {
          bgColor="E3E3B0";
        } else {
          bgColor="E3E3CF";
        }
      }
    } //end of while
    sb.append("</TABLE>");
    return sb.toString();               
  } // end of getRsString
} //end of this class