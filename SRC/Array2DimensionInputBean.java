// Decompiled by DJ v3.5.5.77 Copyright 2003 Atanas Neshkov  Date: 2005/12/1 下午 04:20:46
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3)
// Source File Name:   Array2DimensionInputBean.java

import java.io.Serializable;

public class Array2DimensionInputBean
    implements Serializable
{

    public Array2DimensionInputBean()
    {
        fieldName = "";
        selection = "";
        commitmentMonth = 0;
        onClickEvent = ""; //add by Peggy 20120328
        linenum =1;        //add by Peggy 20130306
        eventName="";      //add by Peggy 20130522
    }

    public int getCommitmentMonth()
    {
        return commitmentMonth;
    }

    public void setCommitmentMonth(int i)
    {
        commitmentMonth = i;
    }

    public String getSelection()
    {
        return selection;
    }

    public void setSelection(String s)
    {
        selection = s;
    }

    public String getFieldName()
    {
        return fieldName;
    }

    public void setFieldName(String s)
    {
        fieldName = s;
    }

    public String getClickEvent()
    {
        return onClickEvent;
    }

    public void setClickEvent(String s)
    {
        onClickEvent = s;
    }
    
    public int getLineNum()
    {
        return linenum;
    }

    public void setLineNum(int i)
    {
        linenum = i;
    }
        
    public String getEventName()
    {
        return eventName;
    }

    public void setEventName(String s)
    {
        eventName = s;
    }
        
    public String[] getArrayContent()
    {
        return arrayString;
    }

    public String[][] getArray2DContent()
    {
        return array2DString;
    }

    public String[][] getArray2DFrToContent()
    {
        return array2DString;
    }

    public void setArrayString(String as[])
    {
        arrayString = as;
    }

    public void setArray2DString(String as[][])
    {
        array2DString = as;
    }

    public void setArray2DCheck(String as[][])
    {
        array2DCheck = as;
    }

    public void setArray2DBufferString(String as[][])
    {
        for (int i=0;i<as.length;i++)
        {
          for (int j=0;j<as[i].length;j++)
          {
            if (as[i][j]!=null && as[i][j].trim()!="") array2DString = as;
          }
        }
    }

    public void setArray2DBufferCheck(String as[][])
    {
        for (int i=0;i<as.length;i++)
        {
          for (int j=0;j<as[i].length;j++)
          {
            if (as[i][j]!=null && as[i][j].trim()!="") array2DCheck = as;
          }
        }
    }

    public String[][] getCheckContent()
    {
        return array2DCheck;
    }

    public String getArrayString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        stringbuffer.append("<TABLE>");
        for(int i = 0; i < arrayString.length; i++)
        {
            String s = arrayString[i];
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            if(s.equals(selection))
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s + "' CHECKED></TD><TD><FONT SIZE=1>" + s + "</TD>");
            else
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s + "'></TD><TD><FONT SIZE=1>" + s + "</TD>");
            stringbuffer.append("</TR>");
        }

        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length-1; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1.equals(selection))
            {
              stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");

            }
            else
            {
              stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");

            }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                 stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");

                }
                else
                {
                      if (k==1 || k==2)
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                      }
                      else
                      {
                        stringbuffer.append("<TD><FONT SIZE=1><input type='text' name=" + s3 + " size='15' value='" + s2 + "'></TD>");
                      }
                }
            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DTempString()
        throws Exception
    {
    	StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        //for(int j = 0; j < array2DString.length - 1; j++)
        for (int j = 0; j < array2DString.length - linenum;j++)  //modify by Peggy 20130306
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1 == null)
            {
              //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
              break;
            } 
            else if(s1.equals(selection))
            {
               	stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            } 
            else
            {
               	stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            for(int k = 1; k < array2DString[j].length; k++)
            {
               	String s2 = array2DString[j][k];
               	String s3 = "MONTH" + j + "-" + k;
               	String s4 = array2DCheck[j][k];
               	if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
               	{
            		stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    	continue;
                }
                // 20110302 Marvie Update : D Display, U Update, P protect
                // 20120328 modify by Peggy, Add B:Button click event
                //if (k == 1 || k == 2)
                if (k == 1 || k == 2 || s4.equals("D") || s4.equals("P"))
                {
                	//stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
			stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value=" +'"' + s2 + '"'+" readonly>" + s2 + "</FONT></TD>"); //解決字串裡單引號問題,modify by Peggy 20120523                
		} 
                else if (k == 3)
                {
                    	//stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value='" + s2 + "'></TD>");
                    	stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value=" +'"' + s2 + '"'+"></TD>");  //解決字串裡單引號問題,modify by Peggy 20120523                
                }
                //else
                else if (!s4.equals("P"))
                {
                	if (s4.equals("B") && !onClickEvent.equals(""))  //add by Peggy 20120328
                	{
                		//stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value='" + s2 + "'><input type='button' name="+"btn_"+s3+ " value='..' onclick="+onClickEvent+"('"+j+"','"+k+"')></TD>");
                		stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value=" +'"'+ s2 +'"'+ "><input type='button' name="+"btn_"+s3+ " value='..' onclick="+onClickEvent+"('"+j+"','"+k+"')></TD>"); //解決字串裡單引號問題,modify by Peggy 20120523                
                	}
                	//else if (objTextArea.indexOf(','+k+',')>0)
                	else if (s4.equals("T"))
                	{
                		stringbuffer.append("<TD><FONT SIZE=1><textarea cols='20' rows='2' name=" +'"'+  s3 +'"'+ ">"+s2+"</textarea></TD>");
                	}
                	else
                	{
                		//stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value='" + s2 + "'></TD>");
                		stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='8' value=" +'"'+ s2 +'"'+ " "+ eventName+ "></TD>"); //解決字串裡單引號問題,modify by Peggy 20120523                
                	}
                }
            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }
    // RFQ 已結案增加項目至已生成MO單
    public String getArray2DClosedString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length - 1; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1 == null)
            {
              //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
              break;
            } else
            if(s1.equals(selection))
            {
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            } else
            {
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }
                if(k == 1 || k == 2)
                {
                    stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                }else if (k == 3)
                {
                    stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='5' value='" + s2 + "'></TD>");
                } else
                     {
                      stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='5' value='" + s2 + "'></TD>");
                     }
            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DRFQString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE border='1' cellpadding='0' cellspacing='0' align='center' width='100%'  bordercolor='#999966' bordercolorlight='#999999' bordercolordark='#CCCC99' bgcolor='#CCCC99'>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if (s1==null)
            {
              stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + "5" + "' CHECKED></TD><TD><FONT SIZE=2>" + "5" + "</TD>");
            }
            else if(s1.equals(selection))
            {
                stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            else
                {
                  stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
                }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(s4!=null && !s4.equals("N") && k <= commitmentMonth)
                {
                  stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                }
                else
                    {
                      if (k==1)
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='10' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                      }
                      else
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='10' value='" + s2 + "' readonly>"+ s2 + "</FONT></TD>");
                      }
                    }

            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    // 顯示IQC 系統檢驗批 2D Array Bean
    public String getArray2DIQCString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD NOWRAP><FONT COLOR=WHITE>" + s + "</FONT></TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            String interfaceID = array2DString[j][1];
            String receiptNumber = array2DString[j][2];
            System.out.println("interfaceID ="+interfaceID);
            System.out.println("receiptNumber ="+receiptNumber);
            if (interfaceID!=null && !interfaceID.equals("") && receiptNumber!=null && !receiptNumber.equals(""))
            {

              if(s1 == null)
              {
                //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
               break;
              } else
                    if(s1.equals(selection))
                   {
                      stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD>" + s1 + "</TD>");
                   } else
                        {
                          stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD>" + s1 + "</TD>");
                        }
            } else { System.out.println("interfaceID ="+interfaceID+" break ");
                     continue;
                   }// End of else 判斷InterfaceID及ReceiptNo不為Null表示是刪除的按鈕,故不作Append

            for(int k = 1; k < array2DString[j].length; k++)
            {

                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];

                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED NOWRAP><FONT COLOR=WHITE>" + s4 + "</FONT><input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }
                else
                {
                  if ( k == 1 && (s2==null || s2.trim()=="" || s2.equals("")) ) // 當 為第一欄(序號欄)不為空,判斷若InterfaceID及 ReceiptNumber為Null,則不Append Array
                  {
                     break;
                  }
                  else if(k == 1 || k == 2)
                  {
                    stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</TD>");
                  }else if (k == 3)
                       {
                          stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='15' value='" + s2 + "' readonly>" + s2 + "</TD>");
                       } else
                            {
                             stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='10' value='" + s2 + "'>" + s2 + "</TD>");
                            }
                } // End of else
            } // End of for
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    // 顯示WIP 系統工令 2D Array Bean
    public String getArray2DWIPString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                if (i==8 || i==9 || i==10 || i==14 || i==15 || i==16 || i==17 || i==18 || i==20)     // 不顯示的欄位
                {
                } else {
                        stringbuffer.append("<TD NOWRAP><FONT COLOR=WHITE>" + s + "</FONT></TD>");
                       }
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            String interfaceID = array2DString[j][1];
            String receiptNumber = array2DString[j][2];
            System.out.println("interfaceID ="+interfaceID);
            System.out.println("receiptNumber ="+receiptNumber);
            if (interfaceID!=null && !interfaceID.equals("") && receiptNumber!=null && !receiptNumber.equals(""))
            {
              if(s1 == null)
              {
                //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
               break;
              } else
                    if(s1.equals(selection))
                   {
                      stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD>" + s1 + "</TD>");
                   } else
                        {
                          stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD>" + s1 + "</TD>");
                        }
            } else { System.out.println("interfaceID ="+interfaceID+" break ");
                     continue;
                   }// End of else 判斷InterfaceID及ReceiptNo不為Null表示是刪除的按鈕,故不作Append

            for(int k = 1; k < array2DString[j].length; k++)
            {

                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];

                if (s2==null || s2.equals("null")) s2 = "";  // null值不顯示為null

                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED NOWRAP><FONT COLOR=WHITE>" + s4 + "</FONT><input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }
                else
                {
                  if ( k == 1 && (s2==null || s2.trim()=="" || s2.equals("")) ) // 當 為第一欄(序號欄)不為空,判斷若InterfaceID及 ReceiptNumber為Null,則不Append Array
                  {
                     break;
                  }
                  else if(k == 1 || k == 2)
                  {
                    stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</TD>");
                  } else if (k==7 || k ==8 || k==9 || k==13 || k==14 || k==15 || k==16 || k==17 || k==19)
                            { //僅計入Hidden Text,不顯示為Html
                             stringbuffer.append("<input type='hidden' name=" + s3 + " size='10' value='" + s2 + "'>");
                            } else {
                                    stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='15' value='" + s2 + "' readonly>" + s2 +"</TD>");
                                   }
                } // End of else
            } // End of for
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    // 顯示WIP 系統領料 2D Array Bean
    public String getArray2DWipIssString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD NOWRAP><FONT COLOR=WHITE>" + s + "</FONT></TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            String wipEntityInfo = array2DString[j][1];
            String invItemID = array2DString[j][2];
            System.out.println("wipEntityInfo ="+wipEntityInfo);
            System.out.println("invItemID ="+invItemID);
            if (wipEntityInfo!=null && !wipEntityInfo.equals("") && invItemID!=null && !invItemID.equals(""))
            {
              if(s1 == null)
              {
                //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
               break;
              } else
                    if(s1.equals(selection))
                   {
                      stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD>" + s1 + "</TD>");
                   } else
                        {
                          stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD>" + s1 + "</TD>");
                        }
            } else { System.out.println("wipEntityInfo ="+wipEntityInfo+" break ");
                     continue;
                   }// End of else 判斷wipEntityInfo及invItemID不為Null表示是刪除的按鈕,故不作Append

            for(int k = 1; k < array2DString[j].length; k++)
            {

                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];

                if (s2==null || s2.equals("null")) s2 = "";  // null值不顯示為null

                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED NOWRAP><FONT COLOR=WHITE>" + s4 + "</FONT><input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }
                else
                {
                  if ( k == 1 && (s2==null || s2.trim()=="" || s2.equals("")) ) // 當 為第一欄(序號欄)不為空,判斷若wipEntityInfo及 invItemID為Null,則不Append Array
                  {
                     break;
                  }
                  else if(k == 1 || k == 2)
                  {
                    stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</TD>");
                  }  else {
                            stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='15' value='" + s2 + "' readonly>" + s2 +"</TD>");
                          }
                } // End of else
            } // End of for
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DDrawString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE width='100%' border='1' cellpadding='0' cellspacing='0' bordercolorlight='#FFFFFF' bordercolordark='#B9BB99'>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD NOWRAP><FONT COLOR=WHITE>" + s + "</FONT></TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            String interfaceID = array2DString[j][1];
            String receiptNumber = array2DString[j][2];
            System.out.println("interfaceID ="+interfaceID);
            System.out.println("receiptNumber ="+receiptNumber);
            if (interfaceID!=null && !interfaceID.equals("") && receiptNumber!=null && !receiptNumber.equals(""))
            {

              if(s1 == null)
              {
                //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
               break;
              } else
                    if(s1.equals(selection))
                   {
                      stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD>" + s1 + "</TD>");
                   } else
                        {
                          stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD>" + s1 + "</TD>");
                        }
            } else { System.out.println("interfaceID ="+interfaceID+" break ");
                     continue;
                   }// End of else 判斷InterfaceID及ReceiptNo不為Null表示是刪除的按鈕,故不作Append

            for(int k = 1; k < array2DString[j].length; k++)
            {

                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];

                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED NOWRAP><FONT COLOR=WHITE>" + s4 + "</FONT><input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }
                else
                {
                  if ( k == 1 && (s2==null || s2.trim()=="" || s2.equals("")) ) // 當 為第一欄(序號欄)不為空,判斷若InterfaceID及 ReceiptNumber為Null,則不Append Array
                  {
                     break;
                  }
                  else if(k == 1 || k == 2)
                  {
                    stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</TD>");
                  }else if (k == 3)
                       {
                          stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='15' value='" + s2 + "' readonly>" + s2 +"</TD>");
                       } else
                            {
                             stringbuffer.append("<TD NOWRAP><input type='hidden' name=" + s3 + " size='10' value='" + s2 + "' readonly>" + s2 +"</TD>");
                            }
                } // End of else
            } // End of for
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DShipString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length ; j++)
        {
            stringbuffer.append("<TR BGCOLOR='#EAFAFA'>");
            String s1 = array2DString[j][0];
            if(s1 == null)
            {
              //stringbuffer.append((new StringBuilder()).append("<TD><INPUT TYPE=checkbox NAME=").append(fieldName).append(" VALUE='").append("5").append("' CHECKED></TD><TD><FONT SIZE=2>").append("5").append("</TD>").toString());
              break;
            } else
            if(s1.equals(selection))
            {
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            } else
            {
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(s4 != null && !s4.equals("N") && k <= commitmentMonth)
                {
                    stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                    continue;
                }

                stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
               /*
                if(k == 1 || k == 2)
                {
                    stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                }else if (k == 3)
                {
                    stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='20' value='" + s2 + "'></TD>");
                } else
                     {
                      stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='15' value='" + s2 + "'></TD>");
                     }
               */
            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DBufferString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length-1; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1==null) { break; }
            else if(s1.equals(selection))
            {
              stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            else
                {
                  stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
                }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
//System.out.println("<BR>s2="+s2+" s3="+s3+" s4="+s4+"<BR>");
                // 20110302 Marvie Update : D Display, U Update, P protect
                //if (s2==null || s2.trim()=="" || s4==null || s4.trim()=="") { break; }
                if (s2==null || s4==null || s4.trim()=="") { break; }
                else if(s2!=null && s4!=null && !s4.equals("N") && k <= commitmentMonth)
                {
                  stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                }
                else
                    {
                      // 20110302 Marvie Update : D Display, U Update, P protect
                      //if (k==1 || k==2)
                      if (k==1 || k==2 || s4.equals("D"))
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='20' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                      }
                      //else
                      else if (!s4.equals("P"))
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='14' value='" + s2 + "'></TD>");
                      }
                    }
            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    // 2 Dimension & 2 Key String Array Display
    public String getArray2D2KeyString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }
            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if (s1==null)
            {
              stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + "5" + "' CHECKED></TD><TD><FONT SIZE=2>" + "5" + "</TD>");
            }
            else if(s1.equals(selection))
            {
                stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            }
            else
                {
                  stringbuffer.append("<TD NOWRAP><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
                }
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(s4!=null && !s4.equals("N") && k <= commitmentMonth)
                {
                  stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                }
                else
                    {
                      if (k==1)
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=2><input type='hidden' name=" + s3 + " size='10' value='" + s2 + "' readonly>" + s2 + "</FONT></TD>");
                      }
                      else
                      {
                        stringbuffer.append("<TD NOWRAP><FONT SIZE=1><input type='text' name=" + s3 + " size='10' value='" + s2 + "'></TD>");
                      }
                    }

            }
            stringbuffer.append("</TR>");
        }
        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getArray2DFrToString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=000099>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=1 COLOR=WHITE>" + s + "</TD>");
            }

            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1.equals(selection))
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=1>" + s1 + "</TD>");
            else
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=1>" + s1 + "</TD>");
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(!s4.equals("N") && k <= commitmentMonth)
                    stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=1 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                else
                    stringbuffer.append("<TD><FONT SIZE=1><input type='text' name=" + s3 + " size='4' value='" + s2 + "'></TD>");
            }

            stringbuffer.append("</TR>");
        }

        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    public String getResultString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=BLUE>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=2 COLOR=WHITE>" + s + "</TD>");
            }

            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            stringbuffer.append("<TD>&nbsp;&nbsp;</TD>");
            for(int k = 0; k < array2DString[j].length; k++)
            {
                String s1 = array2DString[j][k];
                stringbuffer.append("<TD><FONT SIZE=2>" + s1 + "</TD>");
            }

            stringbuffer.append("</TR>");
        }

        stringbuffer.append("</TABLE>");
        return stringbuffer.toString();
    }

    public String getResultFrToString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        boolean flag1 = true;
        stringbuffer.append("<TABLE>");
        if(arrayString != null && arrayString.length > 0)
        {
            stringbuffer.append("<TR BGCOLOR=BLUE>");
            for(int i = 0; i < arrayString.length; i++)
            {
                String s = arrayString[i];
                stringbuffer.append("<TD><FONT SIZE=1 COLOR=WHITE>" + s + "</TD>");
            }

            stringbuffer.append("</TR>");
        }
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            stringbuffer.append("<TD>&nbsp;&nbsp;</TD>");
            for(int k = 0; k < array2DString[j].length; k++)
            {
                String s1 = array2DString[j][k];
                stringbuffer.append("<TD><FONT SIZE=1>" + s1 + "</TD>");
            }

            stringbuffer.append("</TR>");
        }

        stringbuffer.append("</TABLE>");
        return stringbuffer.toString();
    }

    private String fieldName;
    private String arrayString[];
    private String array2DString[][];
    private String array2DCheck[][];
    private String selection;
    private int commitmentMonth;
    private String onClickEvent;  //add by Peggy 20120328
    private int linenum;          //add by Peggy 20130306
    private String eventName;     //add by Peggy 20130522
}