package bean;// Decompiled by DJ v3.5.5.77 Copyright 2003 Atanas Neshkov  Date: 2003/12/10 ¤U¤È 02:21:40
// Home Page : http://members.fortunecity.com/neshkov/dj.html  - Check often for new version!
// Decompiler options: packimports(3)
// Source File Name:   SendMailBean.java

import sun.net.smtp.SmtpClient;

import java.io.PrintStream;
import java.io.Serializable;

public class SendMailBean
    implements Serializable
{

    public SendMailBean()
    {
        mailHost = "";
        urlAddr = "";
        reception = "";
        subject = "";
        body = "";
        from = "";
        authorize = "";
    }

    public String getMailHost()
    {
        return mailHost;
    }

    public void setMailHost(String s)
    {
        mailHost = s;
    }

    public String getUrlAddr()
    {
        return urlAddr;
    }

    public String getUrlAddr1()
    {
        return urlAddr1;
    }

    public String getUrlAddr2()
    {
        return urlAddr2;
    }

    public String getUrlAddr3()
    {
        return urlAddr3;
    }

    public String getUrlAddr4()
    {
        return urlAddr4;
    }

    public String getUrlAddr5()
    {
        return urlAddr5;
    }

    public String getAuthorize()
    {
        return authorize;
    }

    public void setUrlAddr(String s)
    {
        urlAddr = s;
    }

    public void setUrlAddr1(String s)
    {
        urlAddr1 = s;
    }

    public void setUrlAddr2(String s)
    {
        urlAddr2 = s;
    }

    public void setUrlAddr3(String s)
    {
        urlAddr3 = s;
    }

    public void setUrlAddr4(String s)
    {
        urlAddr4 = s;
    }

    public void setUrlAddr5(String s)
    {
        urlAddr5 = s;
    }

    public void setUrlName(String s)
    {
        urlName = s;
    }

    public void setUrlName1(String s)
    {
        urlName1 = s;
    }

    public void setUrlName2(String s)
    {
        urlName2 = s;
    }

    public void setUrlName3(String s)
    {
        urlName3 = s;
    }

    public void setUrlName4(String s)
    {
        urlName4 = s;
    }

    public void setUrlName5(String s)
    {
        urlName5 = s;
    }

    public String getReception()
    {
        return reception;
    }

    public void setReception(String s)
    {
        reception = s;
    }

    public String getSubject()
    {
        return subject;
    }

    public void setSubject(String s)
    {
        subject = s;
    }

    public String getBody()
    {
        return body;
    }

    public void setBody(String s)
    {
        body = s;
    }

    public String getFrom()
    {
        return from;
    }

    public void setFrom(String s)
    {
        from = s;
    }

    public void setAuthorize(String s)
    {
        authorize = s;
    }

    public void sendMail()
    {
        try
        {
            SmtpClient smtpclient = new SmtpClient(mailHost);
            smtpclient.from(from);
            smtpclient.to(reception);
            PrintStream printstream = smtpclient.startMessage();
            printstream.println("SUBJECT:" + subject);
            printstream.println(body + "\n");
            if(urlAddr != "" && urlAddr != null)
                printstream.println(urlName + " http://" + urlAddr + "\n");
            if(urlAddr1 != "" && urlAddr1 != null)
                printstream.println(urlName1 + " http://" + urlAddr1 + "\n");
            if(urlAddr2 != "" && urlAddr2 != null)
                printstream.println(urlName2 + " http://" + urlAddr2 + "\n");
            if(urlAddr3 != "" && urlAddr3 != null)
                printstream.println(urlName3 + " http://" + urlAddr3 + "\n");
            if(urlAddr4 != "" && urlAddr4 != null)
                printstream.println(urlName4 + " http://" + urlAddr4 + "\n");
            if(urlAddr5 != "" && urlAddr5 != null)
                printstream.println(urlName5 + " http://" + urlAddr5);
            smtpclient.closeServer();
            System.err.println("Sending E-mail to " + reception);
        }
        catch(Exception exception)
        {
            exception.printStackTrace();
        }
    }

    private String mailHost;
    private String urlAddr;
    private String urlAddr1;
    private String urlAddr2;
    private String urlAddr3;
    private String urlAddr4;
    private String urlAddr5;
    private String urlName;
    private String urlName1;
    private String urlName2;
    private String urlName3;
    private String urlName4;
    private String urlName5;
    private String reception;
    private String subject;
    private String body;
    private String from;
    private String authorize;
}