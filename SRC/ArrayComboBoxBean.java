public class ArrayComboBoxBean implements java.io.Serializable
{
    private String fieldName="";
    private String [] arrayString;
    private String [][] arrayString2D;
    private String selection="";
    private String noNull="N";
    private String onChangeJS="";
    private int fontSize=12; //to set the font size of the COMBOBOX

    public ArrayComboBoxBean()
    {}

    public int getFontSize()
    {
        return fontSize;
    }

    public void setFontSize(int fs)
    {
        this.fontSize=fs;
    } //end of setFontSize

    public String getOnChangeJS()
    {
        return onChangeJS;
    }

    public void setOnChangeJS(String ocjs)
    {
        this.onChangeJS=ocjs;
    } //end of setOnChangeJS

    public String getNoNull()
    {
        return noNull;
    }

    public void setNoNull(String d)
    {
        this.noNull=d;
    } //end of setSelection

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

    public void setArrayString(String asStr[])
    {
        arrayString=asStr;
    } //end of arrayString

    public void setArrayString2D(String asStr[][])
    {
        arrayString2D=asStr;
    } //end of arrayString2D

    public String getArrayString() throws Exception
    {
        StringBuffer sb=new StringBuffer();
        int i=1;

        if (onChangeJS.equals("")) //如果有設定JavaScript之on Change事件時執行Function,則在選單中加入
        {
            sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+"'>");
        } else {
            sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+"' onChange='"+onChangeJS+"'>");
        } //end of if=>onChangeJS.equals("")

        if (!noNull.equals("Y")) //若沒有設定不有null或--時,則一律會有--
        {
            sb.append("<OPTION VALUE=-->--");
        }
        for (i=0;i<arrayString.length;i++)
        {
            String s1=(String)arrayString[i];

            if (s1.equals(selection))
            {
                sb.append("<OPTION VALUE='"+s1+"' SELECTED>"+s1);
            } else {
                sb.append("<OPTION VALUE='"+s1+"'>"+s1);
            }
        } //end of while
        sb.append("</select>");

        //empty variable
        selection="";

        return sb.toString();
    } // end of getArrayString

    public String getArrayString2D() throws Exception
    {
        StringBuffer sb=new StringBuffer();
        int i=1;

        if (onChangeJS.equals("")) //如果有設定JavaScript之on Change事件時執行Function,則在選單中加入
        {
            sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+"'>");
        } else {
            sb.append("<select NAME="+fieldName+" style='font-size:"+fontSize+"' onChange='"+onChangeJS+"'>");
        } //end of if=>onChangeJS.equals("")

        if (!noNull.equals("Y")) //若沒有設定不有null或--時,則一律會有--
        {
            sb.append("<OPTION VALUE=-->--");
        }
        for (i=0;i<arrayString2D[0].length;i++)
        {
            String s1=(String)arrayString2D[0][i]; //此為其名稱
            String s2=(String)arrayString2D[1][i]; //此為其值

            if (s2.equals(selection))
            {
                sb.append("<OPTION VALUE='"+s2+"' SELECTED>"+s1);
            } else {
                sb.append("<OPTION VALUE='"+s2+"'>"+s1);
            }
        } //end of while
        sb.append("</select>");

        //empty variable
        selection="";

        return sb.toString();
    } // end of getArrayString
} //end of this class