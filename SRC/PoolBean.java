import java.io.*;
import java.sql.*;
import java.util.Date;
import java.util.*;
//import ConnBean;
//import DateBean;

public class PoolBean implements Serializable
{
 private String driver=null;
 private String url=null,url2=null,url3=null;//url2�Ofor failover�ɥΤ����Nserver
 private int size=0;
 private String username="";
 private String password="";
 private ConnBean connBean=null;
 private Vector pool=null;
 private String hostinfo=""; //���o�ϥΦ�Bean���D����T
 private String beanID=""; //���o�ϥΦ�Bean���ѧO��T
 private String fieldName="";//�]�w������������W��
 private String usingURL="";

 public PoolBean()
 {}

 public void resetPool() //�ΨӱNConnection�_�u�᭫�s�ҥ�
 {
  pool=new Vector(size);
  System.err.println("Conn of "+beanID+" has been reseted at "+new java.util.Date());
 }

 public String getFieldName()
 {
  return fieldName;
 }

  public void setFieldName(String fieldName)
  {
   this.fieldName=fieldName;
  } //end of setFieldName


 public void setHostInfo(String h)
 {
  if (h!=null) hostinfo=h;
 }

 public String getHostInfo()
 {
  return hostinfo;
 }

 public void setUsingURL(String uu)
 {
  if (uu!=null) usingURL=uu;
 }

 public String getUsingURL()
 {
  return usingURL;
 }

 public void setBeanID(String b)
 {
  if (b!=null) beanID=b;
 }

 public String getBeanID()
 {
  return beanID;
 }

 public void setDriver(String d)
 {
  if (d!=null) driver=d;
 } //end of setDriver

 public String getDriver()
 {
  return driver;
 }

 public void setURL(String u)
 {
  if (u!=null) url=u;
 }

 public String getURL()
 {
  return url;
 }

 public void setURL2(String u)
 {
  if (u!=null) url2=u;
 }

 public String getURL2()
 {
  return url2;
 }

 public void setURL3(String u)
 {
  if (u!=null) url3=u;
 }

 public String getURL3()
 {
  return url3;
 }

 public void setSize(int s)
 {
  if (s>1) size=s;
 }

 public int getSize()
 {
  return size;
 }

 public void setUsername(String un)
 {
  if (un!=null) username=un;
 }

 public String getUserName()
 {
  return username;
 }

 public void setPassword(String pw)
 {
  if (pw!=null) password=pw;
 }

 public String getPassword()
 {
  return password;
 }

 public void setConnBean(ConnBean cb)
 {
  if (cb!=null) connBean=cb;
 }

 public ConnBean getConnBean() throws Exception
 {
  Connection con=getConnection();
  ConnBean cb=new ConnBean(con);
  cb.setInuse(true);
  return cb;
 } // end of getConnBean

 private Connection createConnection() throws Exception
 {
  Connection con=null;
  try
  {
    con=DriverManager.getConnection(url,username,password);
    return con;
  } //end of try
  catch (Exception e)
  {
    try
    {
     con=DriverManager.getConnection(url2,username,password);
     System.err.println("Alert!!The Primary database is error , now switching to standby mode");
     return con;
    }
    catch (Exception e2)
    {
      con=DriverManager.getConnection(url3,username,password);
      System.err.println("Alert!!The Primary and Secondary database is error , now switching to standby mode");
      return con;
    }
  }
 } // end of createConnection

 public synchronized void initializePool() throws Exception
 {
  if (driver==null) throw new Exception("There is no Driver's Name provided");
  if (url==null) throw new Exception("There is no URL provided");
  if (size<1) throw new Exception("The Size of ConnPool is small than 1");
  try
  {
   Class.forName(driver);
   for (int i=0;i<size;i++)
   {
    Connection con=createConnection();
    if (con!=null)
    {
     ConnBean connBean=new ConnBean(con);
     addConnection(connBean);
    }//end of if
   } //end of for
  }//end of try
  catch (Exception e)
  {
   System.err.println(e.getMessage());
   throw new Exception(e.getMessage());
  }
 }//end of initializePool

 private void addConnection(ConnBean connBean)
 {
  if (pool==null)pool=new Vector(size);
  pool.addElement(connBean);
 }

 public synchronized void releaseConnection(Connection con)
 {
  for (int i=0;i<pool.size();i++)
  {
   ConnBean connBean=(ConnBean)pool.elementAt(i);
   if (connBean.getConnection()==con)
   {
    //System.err.println("Release No:"+i+" Conn by "+beanID+"("+hostinfo+") at "+new java.util.Date());
    connBean.setInuse(false);
    break;
   } //end of if
  } //end of For
 }//end of releaseConnection

 public synchronized Connection getConnection() throws Exception
 {
  ConnBean connBean=null;
  DateBean dateBean=new DateBean();
  for (int i=0;i<pool.size();i++)
  {
   connBean=(ConnBean)pool.elementAt(i);
   if (connBean.getInuse()==false)
   {
    connBean.setInuse(true);
    Connection con=connBean.getConnection();
     try
     {
       Statement testConnStat=con.createStatement(); //�o��{���ت��b���ո�Ʈw�s�u�O�_���`
       if (!hostinfo.equals(connBean.getHostInfo())) //�Y���P�@SESSION�h���Ashow�X�T��
       {
         System.err.println("Create No:"+i+" Conn by "+beanID+"("+hostinfo+") at "+new java.util.Date());
       }
       connBean.setHostInfo(hostinfo);//�]���{���ϥΤ���host��information
       connBean.setUseTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());//�]���ϥήɶ�
       connBean.setUseHMTime(dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());//�]���ϥήɶ��r��
       connBean.setUsingURL(usingURL);//�]���{���ϥΤ���URL
       testConnStat.close();
       return con;
     } //end of try
     catch (SQLException se)
     {
       System.err.println("Warrning!!Connection error,try to switch another Connection!");
       if (!hostinfo.equals(connBean.getHostInfo())) //�Y���P�@SESSION�h���Ashow�X�T��
       {
         System.err.println("Create No:"+i+" Conn by "+beanID+"("+hostinfo+") at "+new java.util.Date());
       }
       connBean.setHostInfo(hostinfo);//�]���{���ϥΤ���host��information
       connBean.setUseTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());//�]���ϥήɶ�
       connBean.setUseHMTime(dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());//�]���ϥήɶ��r��
       connBean.setUsingURL(usingURL);//�]���{���ϥΤ���URL
       Connection temp_con=createConnection();
       connBean.setConnection(temp_con); //�Y�]��Ʈw�s�u�����`,�h���s�]�w�s�u
       con=connBean.getConnection();
       return con;
     }
   } //end of getInuse if
  } //end of for
  try
  {
   Connection con=createConnection();
   connBean=new ConnBean(con);
   connBean.setInuse(true);
   connBean.setHostInfo(hostinfo);
   connBean.setUseTime(dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute());//�]���ϥήɶ�
   connBean.setUseHMTime(dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond());//�]���ϥήɶ��r��
   connBean.setUsingURL(usingURL);//�]���{���ϥΤ���URL
   pool.addElement(connBean);
  } // end of try
  catch (Exception e)
  {
   System.err.println("!Hello!");
   System.err.println(e.getMessage());
   throw new Exception(e.getMessage());
   }
  return connBean.getConnection();
 } //end of getConnection

 public synchronized void emptyPool()
 {
  for (int i=0;i<pool.size();i++)
  {
   System.err.println("Shut the No."+i+" of "+beanID+" Connection down");
   ConnBean connBean=(ConnBean)pool.elementAt(i);
   if (connBean.getInuse()==false)
     connBean.close();
   else
   {
    try
    {
     java.lang.Thread.sleep(20000);
     connBean.close();
    }//end of try
    catch (InterruptedException ie)
    {
     System.err.println(ie.getMessage());
    }
   }
  } //end of for
 }//end of getConnection

 public String getConnStatus() throws Exception
  {
    StringBuffer sb=new StringBuffer();
    String bgColor="E3E3CF";

    sb.append("<FONT SIZE=2>Connection id:"+beanID+"</FONT>");
    sb.append("<TABLE>");
    sb.append("<TR>");
    sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;&nbsp;</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Conn#</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>InUse?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Who is in use?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Time to use?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Which URL is calling?</TH>");
    sb.append("</TR>");

    for (int i=0;i<pool.size();i++)
    {
      sb.append("<TR BGCOLOR="+bgColor+">");
      ConnBean connBean=(ConnBean)pool.elementAt(i);
      if (connBean.getInuse()==true)
      {
       sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+i+"'></TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>"+connBean.getHostInfo()+"</TD><TD><FONT SIZE=2>"+connBean.getUseTime()+"</TD><TD><FONT SIZE=2>"+connBean.getUsingURL()+"</TD>");
      } else {
       sb.append("<TD>&nbsp;&nbsp;</TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>--</TD><TD><FONT SIZE=2>-------------</TD><TD><FONT SIZE=2>&nbsp;&nbsp;</TD>");
      }
      sb.append("</TR>");
      if (bgColor.equals("E3E3CF")) //���j�C�C��ﴫ
      {
        bgColor="E3E3B0";
      } else {
        bgColor="E3E3CF";
      }
    } //end of for
    sb.append("</TABLE>");
    return sb.toString();
  } // end of getConnStatus

  public String getSelALLConnStatus() throws Exception
  {
    StringBuffer sb=new StringBuffer();
    DateBean dateBean=new DateBean();
    //ConnBean connBean=null;

    String bgColor="E3E3CF";

    sb.append("<FONT SIZE=2>Connection id:"+beanID+"</FONT>");
    sb.append("<TABLE>");
    sb.append("<TR>");
    sb.append("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>&nbsp;&nbsp;</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Conn#</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>InUse?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Who is in use?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Time to use?</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Current Time</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Working Time</TH><TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=2>Which URL is calling?</TH>");
    sb.append("</TR>");

    for (int i=0;i<pool.size();i++)
    {
      sb.append("<TR BGCOLOR="+bgColor+">");
      ConnBean connBean=(ConnBean)pool.elementAt(i);
      Connection con = connBean.getConnection();    // ����Ʈw�s�u,�P�_�s�u�ɶ�
      if (connBean.getInuse()==true)
      {
        Statement stateConnTime=con.createStatement();  //
        ResultSet rsConnTime=stateConnTime.executeQuery("select ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date('"+connBean.getUseHMTime()+"','YYYYMMDDHH24MISS')) * 24,2) from DUAL ");
        if (rsConnTime.next())
        {
           if (rsConnTime.getFloat(1)>1)   // �j�� 1 �Ӥp��  ���B�z�����s�u�@�v�M��
           {
             sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+i+"' checked></TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>"+connBean.getHostInfo()+"</TD><TD><FONT SIZE=2>"+connBean.getUseTime()+"</TD><TD><FONT SIZE=2>"+dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute()+"</TD><TD><FONT SIZE=2>"+rsConnTime.getString(1)+"</TD><TD><FONT SIZE=2>"+connBean.getUsingURL()+"</TD>");
           } else {
                   sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+i+"'></TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>"+connBean.getHostInfo()+"</TD><TD><FONT SIZE=2>"+connBean.getUseTime()+"</TD><TD><FONT SIZE=2>"+dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute()+"</TD><TD><FONT SIZE=2>"+rsConnTime.getString(1)+"</TD><TD><FONT SIZE=2>"+connBean.getUsingURL()+"</TD>");
                  }
        } else {
                 sb.append("<TD><INPUT TYPE=checkbox NAME="+fieldName+" VALUE='"+i+"'></TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>"+connBean.getHostInfo()+"</TD><TD><FONT SIZE=2>"+connBean.getUseTime()+"</TD><TD><FONT SIZE=2>"+dateBean.getYearMonthDay()+"-"+dateBean.getHourMinute()+"</TD><TD><FONT SIZE=2>N/A</TD><TD><FONT SIZE=2>"+connBean.getUsingURL()+"</TD>");
               }
        rsConnTime.close();
        stateConnTime.close();

      } else {
       sb.append("<TD>&nbsp;&nbsp;</TD><TD><FONT SIZE=2>"+i+"</TD><TD><FONT SIZE=2>"+connBean.getInuse()+"</TD><TD><FONT SIZE=2>--</TD><TD><FONT SIZE=2>-------------</TD><TD><FONT SIZE=2>-------------</TD><TD><FONT SIZE=2>-------------</TD><TD><FONT SIZE=2>&nbsp;&nbsp;</TD>");
      }
      sb.append("</TR>");
      if (bgColor.equals("E3E3CF")) //���j�C�C��ﴫ
      {
        bgColor="E3E3B0";
      } else {
        bgColor="E3E3CF";
      }
    } //end of for
    sb.append("</TABLE>");
    return sb.toString();
  } // end of getSelALLConnStatus


  public synchronized void releaseWhichConn(int no[]) //����S�w�s��
  {
    for (int i=0;i<no.length;i++)
    {
     ConnBean connBean=(ConnBean)pool.elementAt(no[i]);
     connBean.setInuse(false);
    }//end of for
  }//end of releaseWhichConn


  public synchronized void setConRollback() throws Exception
  {
   try
   {
    Connection con=getConnection();
    con.rollback();
   }
   catch (SQLException sqle)
   {
    System.err.println(sqle.getMessage());
   }
  }

}