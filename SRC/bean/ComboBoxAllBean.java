package bean;// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   ComboBoxAllBean.java

import java.io.Serializable;
import java.sql.ResultSet;

public class ComboBoxAllBean
    implements Serializable
{

    public ComboBoxAllBean()
    {
        rs = null;
        fieldName = "";
        rsString = "";
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

    public void setRs(ResultSet resultset)
    {
        rs = resultset;
    }

    public ResultSet getRs()
    {
        return rs;
    }

    public void setRsString(String s)
    {
        rsString = new String(s);
    }

    public String getRsString()
        throws Exception
    {
        java.sql.ResultSetMetaData resultsetmetadata = rs.getMetaData();
        StringBuffer stringbuffer = new StringBuffer();
        boolean flag = true;
        stringbuffer.append("<select NAME=" + fieldName + ">");
        stringbuffer.append("<OPTION VALUE=-->ALL");
        while(rs.next())
        {
            String s = rs.getString(1);
            String s1 = rs.getString(2);
            if(s.equals(selection))
                stringbuffer.append("<OPTION VALUE=" + s + " SELECTED>" + s1);
            else
                stringbuffer.append("<OPTION VALUE=" + s + ">" + s1);
        }
        stringbuffer.append("</select>");
        selection = "";
        return stringbuffer.toString();
    }

    ResultSet rs;
    private String fieldName;
    private String rsString;
    private String selection;
}