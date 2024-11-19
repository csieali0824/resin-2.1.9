// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   QueryAllBean.java

import java.io.Serializable;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.io.DataInputStream;
import java.text.DecimalFormat;


public class QueryAllBean
    implements Serializable
{

    public QueryAllBean()
    {
        rs = null;
        fieldName = "";
        rsString = "";
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
        ResultSetMetaData resultsetmetadata = rs.getMetaData();
        int i = resultsetmetadata.getColumnCount();
        String as[] = new String[i + 1];
        StringBuffer stringbuffer = new StringBuffer();
        String s = "E3E3CF";
        stringbuffer.append("<TABLE>");
        stringbuffer.append("<TR>");
        for(int j = 1; j <= i; j++)
        {
            as[j] = resultsetmetadata.getColumnLabel(j);
            stringbuffer.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>" + as[j] + "</TH>");
        }

        stringbuffer.append("</TR>");
        while(rs.next())
        {
            stringbuffer.append("<TR BGCOLOR=" + s + ">");
            for(int k = 1; k <= i; k++)
            {
                String s1 = rs.getString(k);
                stringbuffer.append("<TD><FONT SIZE=2>" + s1 + "</TD>");
            }

            stringbuffer.append("</TR>");
            if(s.equals("E3E3CF"))
                s = "E3E3B0";
            else
                s = "E3E3CF";
        }
        stringbuffer.append("</TABLE>");
        return stringbuffer.toString();
    }

    public String getRsByteString()
        throws Exception
    {
        ResultSetMetaData resultsetmetadata = rs.getMetaData();
        int i = resultsetmetadata.getColumnCount();
        String as[] = new String[i + 1];
        StringBuffer stringbuffer = new StringBuffer();
        String s = "E3E3CF";
        stringbuffer.append("<TABLE>");
        stringbuffer.append("<TR>");
        for(int j = 1; j <= i; j++)
        {
            as[j] = resultsetmetadata.getColumnLabel(j);
            stringbuffer.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>" + as[j] + "</TH>");
        }

        stringbuffer.append("</TR>");
        while(rs.next())
        {
            stringbuffer.append("<TR BGCOLOR=" + s + ">");
            for(int k = 1; k <= i; k++)
            {
                byte s1 = rs.getByte(k);
                stringbuffer.append("<TD><FONT SIZE=2>" + s1 + "</TD>");
            }

            stringbuffer.append("</TR>");
            if(s.equals("E3E3CF"))
                s = "E3E3B0";
            else
                s = "E3E3CF";
        }
        stringbuffer.append("</TABLE>");
        return stringbuffer.toString();
    }

    public String getRsBinaryStream()
        throws Exception
    {
        ResultSetMetaData resultsetmetadata = rs.getMetaData();
        int i = resultsetmetadata.getColumnCount();
        String as[] = new String[i + 1];
        StringBuffer stringbuffer = new StringBuffer();
        String s = "E3E3CF";
        stringbuffer.append("<TABLE>");
        stringbuffer.append("<TR>");
        for(int j = 1; j <= i; j++)
        {
            as[j] = resultsetmetadata.getColumnLabel(j);
            stringbuffer.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>" + as[j] + "</TH>");
        }

        stringbuffer.append("</TR>");
        while(rs.next())
        {
            stringbuffer.append("<TR BGCOLOR=" + s + ">");
            for(int k = 1; k <= i; k++)
            {
                String s1 = "";
                String stermca="";
				DataInputStream inputS=new DataInputStream(rs.getBinaryStream(k));
                try
				{
				   stermca=inputS.readLine();
				   stermca =CodeUtil.big5ToUnicode(stermca);
				   s1 = stermca;
				} 	 catch(Exception e)  {
				                          System.out.print("&nbsp;");
                                         }

                stringbuffer.append("<TD><FONT SIZE=2>" + s1 + "</TD>");
            }

            stringbuffer.append("</TR>");
            if(s.equals("E3E3CF"))
                s = "E3E3B0";
            else
                s = "E3E3CF";
        }
        stringbuffer.append("</TABLE>");
        return stringbuffer.toString();
    }

    public String getRsTextString()
        throws Exception
    {
        StringBuffer stringbuffer = new StringBuffer();
        for(int i = 1; rs.next(); i++)
        {
            String s = rs.getString(1);
            if(i > 1)
                stringbuffer.append("/" + s);
            else
                stringbuffer.append(s);
        }

        return stringbuffer.toString();
    }

    ResultSet rs;
    private String fieldName;
    private String rsString;
}