// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   Array2DEstimatingInputBean.java

import java.io.Serializable;

public class Array2DEstimatingInputBean
    implements Serializable
{

    public Array2DEstimatingInputBean()
    {
        fieldName = "";
        selection = "";
        commitmentMonth = 0;
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
        for(int j = 0; j < array2DString.length; j++)
        {
            stringbuffer.append("<TR BGCOLOR=E3E3CF>");
            String s1 = array2DString[j][0];
            if(s1.equals(selection))
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "' CHECKED></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            else
                stringbuffer.append("<TD><INPUT TYPE=checkbox NAME=" + fieldName + " VALUE='" + s1 + "'></TD><TD><FONT SIZE=2>" + s1 + "</TD>");
            for(int k = 1; k < array2DString[j].length; k++)
            {
                String s2 = array2DString[j][k];
                String s3 = "MONTH" + j + "-" + k;
                String s4 = array2DCheck[j][k];
                if(!s4.equals("N") && k <= commitmentMonth)
                    stringbuffer.append("<TD BGCOLOR=RED><FONT SIZE=2 COLOR=WHITE>" + s4 + "<input type='HIDDEN' name=" + s3 + " value='" + s4 + "'></TD>");
                else
                    stringbuffer.append("<TD><FONT SIZE=1><input type='text' name=" + s3 + " size='10' value='" + s2 + "'></TD>");
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
}