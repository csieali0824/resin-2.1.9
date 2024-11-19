// Decompiled by Jad v1.5.8e2. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://kpdus.tripod.com/jad.html
// Decompiler options: packimports(3)
// Source File Name:   ConnBean.java

import java.io.PrintStream;
import java.io.Serializable;
import java.sql.Connection;
import java.sql.SQLException;

public class ConnBean
    implements Serializable
{

    public ConnBean()
    {
        conn = null;
        inuse = false;
        hostInfo = "";
        useTime = "";
        usingURL = "";
    }

    public ConnBean(Connection connection)
    {
        conn = null;
        inuse = false;
        hostInfo = "";
        useTime = "";
        usingURL = "";
        if(connection != null)
            conn = connection;
    }

    public Connection getConnection()
    {
        return conn;
    }

    public void setConnection(Connection connection)
    {
        conn = connection;
    }

    public void setInuse(boolean flag)
    {
        inuse = flag;
    }

    public boolean getInuse()
    {
        return inuse;
    }

    public void setHostInfo(String s)
    {
        hostInfo = s;
    }

    public String getHostInfo()
    {
        return hostInfo;
    }

    public void setUseTime(String s)
    {
        useTime = s;
    }

    public String getUseTime()
    {
        return useTime;
    }

    public void setUseHMTime(String s)
    {
        useHMTime = s;
    }

    public String getUseHMTime()
    {
        return useHMTime;
    }

    public void setUsingURL(String s)
    {
        usingURL = s;
    }

    public String getUsingURL()
    {
        return usingURL;
    }

    public void close()
    {
        try
        {
            conn.close();
        }
        catch(SQLException sqlexception)
        {
            System.err.println(sqlexception.getMessage());
        }
    }

    private Connection conn;
    private boolean inuse;
    private String hostInfo;
    private String useTime;
    private String useHMTime;
    private String usingURL;
}