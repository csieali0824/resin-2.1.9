package bean;

import java.sql.ResultSet;
import java.sql.ResultSetMetaData;

public class QryAllChkBoxEditBean implements java.io.Serializable
{
  ResultSet rs=null;
  ResultSet rsPO=null;
  private String [] headerArray;
  private String fieldName="";
  private String rsString="";
  private String searchKey="";
  private String [] searchKeyArray;
  private String tableWrapAttr="";    // 設定是否表格欄位不折行屬性
  private String tdTipCh="";          // 設定顯示 TD 的欄位 Ch
  private String tdMouseMoveAttr="";  // 顯示Table表欄位(TD)ToolTip屬性
  private String pageURL="";
  private String pageURL2="";
  private int scrollRowNumber=0; //設定頁面資料數
  int rowNumber=0;//設定現在資料列游標在第幾筆
  private String rowColor1="";//to set the background color of table row
  private String rowColor2="";//to set the background color of table row
  private String headColor=null;//to set the background color of table head
  private String headFontColor=null;//to set the font color of table head
  private int subSearchStrIndx = 0; // 設定取完整字串長度減去本索引值方為搜尋關鍵字
  private String hideURL="";    //20110311 add by Peggy
  private String onClickJS="";  //20121210 add by Peggy
  private int [] keyColumn;  //add by Peggy 20121218

  public QryAllChkBoxEditBean()
  {
  }

  public void setHeaderArray(String asStr[])
  {
    headerArray=asStr;
  } //end of headerArray

  public String getHeadColor()
  {
    return headColor;
  }

  public void setHeadColor(String headColor)
  {
    this.headColor=headColor;
  } //end of setHeadColor

  public String getHeadFontColor()
  {
    return headFontColor;
  }

  public void setHeadFontColor(String headFontColor)
  {
    this.headFontColor=headFontColor;
  } //end of setHeadFontColor

  public String getRowColor1()
  {
    return rowColor1;
  }

  public void setRowColor1(String rowColor1)
  {
    this.rowColor1=rowColor1;
  } //end of setRowColor1

  public String getRowColor2()
  {
    return rowColor2;
  }

  public void setRowColor2(String rowColor2)
  {
    this.rowColor2=rowColor2;
  } //end of setRowColor2

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

  public String getPageURL2()
  {
    return pageURL2;
  }

  public void setPageURL2(String pageURL2)
  {
    this.pageURL2=pageURL2;
  } //end of setpageURL2

  public String getSearchKey()
  {
    return searchKey;
  }

  public void setSearchKey(String searchKey)
  {
    this.searchKey=searchKey;
  } //end of setSearchKey

  public String [] getSearchKeyArray()
  {
    return searchKeyArray;
  } //end of getSearchKeyArray

  public void setSearchKeyArray(String searchKeyArray[])
  {
    this.searchKeyArray=searchKeyArray;
  } //end of setSearchKeyArray

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

  public void setRsPO(ResultSet rsPO)
  {
    this.rsPO=rsPO;
  }

  public ResultSet getRs()
  {
    return rs;
  }//enf of ResultSet

  public ResultSet getRsPO()
  {
    return rsPO;
  }//enf of ResultSet

  public void setRsString(String rsStr)
  {
    rsString=new String(rsStr);
  } //end of setRsString

  public int getSubSearchStrIndx()
  {
    return subSearchStrIndx;
  }

  public void setSubSearchStrIndx(int subSearchStrIndx)
  {
    this.subSearchStrIndx=subSearchStrIndx;
  } //end of subSearchStrIndx

  public String getTableWrapAttr()
  {
    return tableWrapAttr;
  }

  public void setTableWrapAttr(String tableWrapAttr)
  {
    this.tableWrapAttr=tableWrapAttr;
  } //end of setTableWrapAttr

  public String getTDMouseMoveAttr()
  {
    return tdMouseMoveAttr;
  }

  public void setTDMouseMoveAttr(String tdMouseMoveAttr)
  {
    this.tdMouseMoveAttr=tdMouseMoveAttr;
  } //end of setTDMouseMoveAttr

  public String getTDTipCh()
  {
    return tdTipCh;
  }

  public void setTDTipCh(String tdTipCh)
  {
    this.tdTipCh=tdTipCh;
  } //end of setTDMouseMoveAttr

  //20110311 add by Peggychen
  public String getHideURL()
  {
    return hideURL;
  }
  //20110311 add by Peggychen
  public void setHideURL(String hideURL)
  {
    this.hideURL=hideURL;
  } //end of setHideURL

  public String getOnClickJS()
  {
    return onClickJS;
  }

  public void setOnClickJS(String ocjs)
  {
    this.onClickJS=ocjs;
  }

  //add by Peggy 20121218
  public void setKeyColumn(int keyCol[])
  {
    this.keyColumn=keyCol;
  }

  //add by Peggy 20121218
  public int [] getKeyColumn()
  {
    return keyColumn;
  }

  public String getRsString() throws Exception
  {
    ResultSetMetaData md=rs.getMetaData();
    int colCount=md.getColumnCount();
    String colLabel[]=new String[colCount+1];
    StringBuffer sb=new StringBuffer();
    String bgColor="";
    String headBgColor="BLACK";
    if (headColor!=null) headBgColor=headColor; //若有設定table header background color
    String hFontColor="WHITE";
    if (headFontColor!=null) hFontColor=headFontColor;//若有設定table header font color
    if (tableWrapAttr!=null && !tableWrapAttr.equals("")) tableWrapAttr = "nowrap";

    if (rowColor1.equals(""))
    {
      bgColor="E3E3CF";
    }
    else
    {
      bgColor=rowColor1;
    }

    sb.append("<TABLE cellSpacing='1' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");
    sb.append("<TR>");
    if (headerArray!=null && headerArray.length>0) //若有table header,就置入之
    {
      for (int i=0;i<headerArray.length;i++)
      {
        String h1=(String)headerArray[i];
        sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>"+h1+"</FONT></TH>");
      }
    }
    else
    {
      sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH><TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH>");
      if (!pageURL2.equals(""))
      {
        sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH>");
      }
      for (int i=1;i<=colCount;i++)
      {
        colLabel[i]=md.getColumnLabel(i);
        sb.append("<TH BGCOLOR='"+headBgColor+"' "+tableWrapAttr+"><FONT COLOR='"+hFontColor+"' SIZE=2 FACE='ARIAL'>"+colLabel[i]+"</FONT></TH>");
      } //end of for
    } //end of headerArray if
    sb.append("</TR>");

    int j=0;
    String s_key="";//設定為search key字串
    String key_value="";//設定做為select key的內容
    while (rs.next())
    {
      if (j==scrollRowNumber && scrollRowNumber>0) break;
      j++;
      s_key="";
      if (searchKeyArray==null || searchKeyArray.length<1)
      {
        if (subSearchStrIndx==0) // 判斷若subSearchIndx != 0, 則僅取原searchKey.length()-subSearchIndx 的字串為searchKey
        {
          //modify by Peggy 20121218
          if (keyColumn != null)
          {
            for (int x=0 ; x < keyColumn.length ; x++)
            {
              if (x!=0) s_key +="&";
              s_key += "keycol"+(x+1)+"="+rs.getString(keyColumn[x]);
            }
          }
          else
          {
            s_key=searchKey+"="+rs.getString(searchKey);
          }
          if (onClickJS.equals(""))
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey)+"'></TD>");
          }
          else
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey)+"' onClick='"+onClickJS+"("+j+")'></TD>");
          }
        }
        else
        {
          int sKeyLength = rs.getString(searchKey).length();
          //modify by Peggy 20121218
          if (keyColumn != null)
          {
            for (int x=0 ; x < keyColumn.length ; x++)
            {
              if (x!=0) s_key +="&";
              s_key += "keycol"+(x+1)+"="+rs.getString(keyColumn[x]);
            }
          }
          else
          {
            s_key=searchKey+"="+rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx);
          }
          if (onClickJS.equals(""))
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx)+"'></TD>");
          }
          else
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx)+"' onClick='"+onClickJS+"("+j+")'></TD>");
          }
        }
      }
      else
      {
        for (int ci=0;ci<searchKeyArray.length;ci++)
        {
          if (ci<1)
          {
            if (subSearchStrIndx==0) // 判斷若subSearchIndx != 0, 則僅取原searchKey.length()-subSearchIndx 的字串為searchKey
            {
              //modify by Peggy 20121218
              if (keyColumn != null)
              {
                for (int x=0 ; x < keyColumn.length ; x++)
                {
                  if (x!=0) s_key +="&";
                  s_key += "keycol"+(x+1)+"="+rs.getString(keyColumn[x]);
                }
              }
              else
              {
                s_key=searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]);
              }
              key_value=(String)rs.getString(searchKeyArray[ci]);
            }
            else
            {
              int sKeyLength = rs.getString(searchKeyArray[ci]).length();
              //modify by Peggy 20121218
              if (keyColumn != null)
              {
                for (int x=0 ; x < keyColumn.length ; x++)
                {
                  if (x!=0) s_key +="&";
                  s_key += "keycol"+(x+1)+"="+rs.getString(keyColumn[x]);
                }
              }
              else
              {
                s_key=searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]).substring(0,sKeyLength-subSearchStrIndx);
              }
              key_value=(String)rs.getString(searchKeyArray[ci]).substring(0,sKeyLength-subSearchStrIndx);
            }
          }
          else
          {
            //modify by Peggy 20121218
            if (keyColumn != null)
            {
              for (int x=0 ; x < keyColumn.length ; x++)
              {
                if (x!=0) s_key +="&";
                s_key += "keycol"+(x+1)+"="+rs.getString(keyColumn[x]);
              }
            }
            else
            {
              s_key=s_key+"&"+searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]);
            }
            key_value=key_value+"|"+(String)rs.getString(searchKeyArray[ci]);
          }
        } //end of ci count for
        if (onClickJS.equals(""))
        {
          sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+key_value+"'></TD>");
        }
        else
        {
          sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+key_value+"' onClick='"+onClickJS+"("+j+")'></TD>");
        }
      } //end of searchKeyArray==null if
      sb.append("<TD><A HREF='"+pageURL+"?"+s_key+"'><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></A></TD>");
      if (!pageURL2.equals(""))
      {
        sb.append("<TD><A HREF='"+pageURL2+"?"+s_key+"'><img src='../image/questionmarkicon.gif' border='0'></A></TD>");
      }
      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
        if (s==null || s.equals("null")) s = "&nbsp;";
        if (i==1)
        {
          if (tdTipCh==null || tdTipCh.equals("")) sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</A></FONT></TD>");
          else if (tdTipCh.equals("1"))
          {
            sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</A></FONT></TD>");
          }
        }
        else
        {
          if (tdTipCh==null || tdTipCh=="")
          {
            sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
          else if (tdTipCh.equals(i))
          {
            sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
          else
          {
            sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
        }
      } //end of for
      sb.append("</TR>");

      if (rowColor2.equals("")) //若無設定間隔列
      {
        if (bgColor.equals("E3E3CF")) //間隔列顏色改換
        {
          bgColor="E3E3B0";
        }
        else
        {
          bgColor="E3E3CF";
        }
      }
      else
      {
        if (bgColor.equals(rowColor1)) //間隔列顏色改換
        {
          bgColor=rowColor2;
        }
        else
        {
          bgColor=rowColor1;
        }
      } //end of rowColor2 if
    } //end of while
    sb.append("</TABLE>");
    return sb.toString();
  } // end of getRsString

  //20110311 add by Peggychen
  public String getRs2String() throws Exception
  {
    ResultSetMetaData md=rs.getMetaData();
    int colCount=md.getColumnCount();
    String colLabel[]=new String[colCount+1];
    StringBuffer sb=new StringBuffer();
    String bgColor="";
    String headBgColor="BLACK";
    if (headColor!=null) headBgColor=headColor; //若有設定table header background color
    String hFontColor="WHITE";
    if (headFontColor!=null) hFontColor=headFontColor;//若有設定table header font color
    if (tableWrapAttr!=null && !tableWrapAttr.equals("")) tableWrapAttr = "nowrap";


    if (rowColor1.equals(""))
    {
      bgColor="E3E3CF";
    }
    else
    {
      bgColor=rowColor1;
    }

    if (hideURL==null) hideURL="N"; //預設為false
    sb.append("<TABLE cellSpacing='1' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");
    sb.append("<TR>");
    if (headerArray!=null && headerArray.length>0) //若有table header,就置入之
    {
      for (int i=0;i<headerArray.length;i++)
      {
        String h1=(String)headerArray[i];
        sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>"+h1+"</FONT></TH>");
      }
    }
    else
    {
      sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH><TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH>");
      if (!pageURL2.equals(""))
      {
        sb.append("<TH BGCOLOR='"+headBgColor+"'><FONT COLOR='"+hFontColor+"' SIZE=2>&nbsp;</FONT></TH>");
      }
      for (int i=1;i<=colCount;i++)
      {
        colLabel[i]=md.getColumnLabel(i);
        sb.append("<TH BGCOLOR='"+headBgColor+"' "+tableWrapAttr+"><FONT COLOR='"+hFontColor+"' SIZE=2 FACE='ARIAL'>"+colLabel[i]+"</FONT></TH>");
      } //end of for
    } //end of headerArray if
    sb.append("</TR>");

    int j=0;
    String s_key="";    //設定為search key字串
    String key_value="";//設定做為select key的內容
    while (rs.next())
    {
      if (j==scrollRowNumber && scrollRowNumber>0) break;
      j++;
      if (searchKeyArray==null || searchKeyArray.length<1)
      {
        if (subSearchStrIndx==0) // 判斷若subSearchIndx != 0, 則僅取原searchKey.length()-subSearchIndx 的字串為searchKey
        {
          s_key=searchKey+"="+rs.getString(searchKey);
          if (onClickJS.equals(""))
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey)+"'></TD>");
          }
          else
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey)+"' onClick='"+onClickJS+"("+j+")'></TD>");
          }
        }
        else
        {
          int sKeyLength = rs.getString(searchKey).length();
          s_key=searchKey+"="+rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx);
          if (onClickJS.equals(""))
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx)+"'></TD>");
          }
          else
          {
            sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+(String)rs.getString(searchKey).substring(0,sKeyLength-subSearchStrIndx)+"' onClick='"+onClickJS+"("+j+")'></TD>");
          }
        }
      }
      else
      {
        for (int ci=0;ci<searchKeyArray.length;ci++)
        {
          if (ci<1)
          {
            if (subSearchStrIndx==0) // 判斷若subSearchIndx != 0, 則僅取原searchKey.length()-subSearchIndx 的字串為searchKey
            {
              s_key=searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]);
              key_value=(String)rs.getString(searchKeyArray[ci]);
            }
            else
            {
              int sKeyLength = rs.getString(searchKeyArray[ci]).length();
              s_key=searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]).substring(0,sKeyLength-subSearchStrIndx);
              key_value=(String)rs.getString(searchKeyArray[ci]).substring(0,sKeyLength-subSearchStrIndx);
            }
          }
          else
          {
            s_key=s_key+"&"+searchKeyArray[ci]+"="+rs.getString(searchKeyArray[ci]);
            key_value=key_value+"|"+(String)rs.getString(searchKeyArray[ci]);
          }
        } //end of ci count for
        if (onClickJS.equals(""))
        {
          sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+key_value+"'></TD>");
        }
        else
        {
          sb.append("<TR BGCOLOR='"+bgColor+"'><TD "+tableWrapAttr+"><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+key_value+"' onClick='"+onClickJS+"("+j+")'></TD>");
        }
      } //end of searchKeyArray==null if
      //20110311 add by Peggychen
      if (hideURL=="Y" )
      {
        sb.append("<TD><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></TD>");
      }
      else
      {
        sb.append("<TD><A HREF='"+pageURL+"?"+s_key+"'><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></A></TD>");
      }
      //sb.append("<TD><A HREF='"+pageURL+"?"+s_key+"'><img src='../image/docLink.gif' style='border-bottom-color:#CC0000' border='0' hspace='0' vspace='0'></A></TD>");
      //if (!pageURL2.equals(""))
      if (!pageURL2.equals("") && hideURL != "Y" )
      {
        sb.append("<TD><A HREF='"+pageURL2+"?"+s_key+"'><img src='../image/questionmarkicon.gif' border='0'></A></TD>");
      }

      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
        if (s==null || s.equals("null")) s = "&nbsp;";
        if (i==1)
        {
          //if (tdTipCh==null || tdTipCh.equals("")) sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'>"+s+"</A></FONT></TD>");
          //else if (tdTipCh.equals("1"))
          //{
          //  sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'>"+s+"</A></FONT></TD>");
          //}
          //20110311 add by Peggychen
          if (tdTipCh==null || tdTipCh.equals(""))
          {
            if (hideURL=="Y")
            {
              sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
            }
            else
            {
              sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'><input type='hidden' name='"+j +"_"+i+"' value='"+s+"'>"+s+"</A></FONT></TD>");
            }
          }
          else if (tdTipCh.equals("1"))
          {
            if (hideURL == "Y")
            {
              sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'></FONT><input type='hidden' name='"+j +"_"+i+"' value='"+s+"'>"+s+"</TD>");
            }
            else
            {
              sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#000099'><A HREF='"+pageURL+"?"+s_key+"'><input type='hidden' name='"+j +"_"+i+"' value='"+s+"'>"+s+"</A></FONT></TD>");
            }
          }
        }
        else
        {
          if (tdTipCh==null || tdTipCh=="")
          {
            sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
          else if (tdTipCh.equals(i))
          {
            sb.append("<TD "+tableWrapAttr+" "+tdMouseMoveAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j+"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
          else
          {
            sb.append("<TD "+tableWrapAttr+"><FONT SIZE=2 FACE='ARIAL' color='#480000'><input type='hidden' name='"+j +"_"+i+"' value='"+s+"'>"+s+"</FONT></TD>");
          }
        }
      } //end of for
      sb.append("</TR>");

      if (rowColor2.equals("")) //若無設定間隔列
      {
        if (bgColor.equals("E3E3CF")) //間隔列顏色改換
        {
          bgColor="E3E3B0";
        }
        else
        {
          bgColor="E3E3CF";
        }
      }
      else
      {
        if (bgColor.equals(rowColor1)) //間隔列顏色改換
        {
          bgColor=rowColor2;
        }
        else
        {
          bgColor=rowColor1;
        }
      } //end of rowColor2 if
    } //end of while
    sb.append("</TABLE>");
    return sb.toString();
  } // end of getRsString
} //end of this class