package bean;// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   ArrayCheckBoxBean.java

import java.io.Serializable;

public class ArrayCheckInputBoxBean
    implements Serializable
{

    public ArrayCheckInputBoxBean()
    {
        fieldName = "";
        selection = "";
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

    public String getField1Name()
    {
        return field1Name;
    }
 /*
    public void setField1Name(String s1)
    {
        field1Name = s1;
    }

    public String getField2Name()
    {
        return field2Name;
    }

    public void setField2Name(String s1)
    {
        field2Name = s1;
    }
 */
    public String[] getArrayContent()
    {
        return arrayString;
    }

    public String[][] getArray2DContent()
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
        for(int i = 0; i < array2DString.length; i++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s = array2DString[i][0];
            if(s.equals(selection))
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s + "' CHECKED></TD><TD><FONT SIZE=1>" + s + "</TD>");
            else
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s + "'></TD><TD><FONT SIZE=1>" + s + "</TD>");
            for(int j = 1; j < array2DString[i].length; j++)
            {
                String s1 = array2DString[i][j];
                String s2 = "WHS" + i ;
                String s3 = "LOC" + i ;

                if (j < 2)
                   stringbuffer.append("<TD><FONT SIZE=1>" + s1 + "</TD>");
                else if (j < 3)
                   stringbuffer.append("<TD><INPUT TYPE=TEXT NAME=" + s2 + " size=2 maxlength=2 VALUE='" + s1 + "'></TD>");
                else
                   stringbuffer.append("<TD><INPUT TYPE=TEXT NAME=" + s3 + " size=6 maxlength=6 VALUE='" + s1 + "'></TD>");
            }

            stringbuffer.append("</TR>");
        }

        stringbuffer.append("</TABLE>");
        selection = "";
        return stringbuffer.toString();
    }

    private String fieldName;
    private String field1Name;
    private String field2Name;
    private String arrayString[];
    private String array2DString[][];
    private String selection;
}