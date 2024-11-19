<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>BPCS RsTest</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%    
  String sqlStat="select a.HORD,a.HEDTE,a.HCUST,a.HNAME,substr(b.PHRQID,1,7) as EmpID from ech a,dbtel@dbtah0172_net:hph b where a.HORD=b.PHORD and a.hid='CH' and a.CHENUS='TTRF920' order by EmpID,a.HORD";
  try
  {   
   Statement statement=ifxdbexpcon.createStatement();
   ResultSet rs=statement.executeQuery(sqlStat);   
   
    ResultSetMetaData md=rs.getMetaData();
    int colCount=md.getColumnCount();
    String colLabel[]=new String[colCount+1];    
    String bgColor="E3E3CF";

    out.println("<TABLE>");      
    out.println("<TR>");
    for (int i=1;i<=colCount;i++)
    {
      colLabel[i]=md.getColumnLabel(i);
      out.println("<TH BGCOLOR=BLACK><FONT COLOR=WHITE SIZE=1>"+colLabel[i]+"</TH>");
    } //end of for 
    out.println("</TR>");
 
    while (rs.next())
    {      
      out.println("<TR BGCOLOR="+bgColor+">");
      for (int i=1;i<=colCount;i++)
      {
        String s=(String)rs.getString(i);
        out.println("<TD><FONT SIZE=2>"+s+"</TD>");
       } //end of for
       out.println("</TR>");
      if (bgColor.equals("E3E3CF")) //間隔列顏色改換
      {
        bgColor="E3E3B0";
      } else {
        bgColor="E3E3CF";
      }
    } //end of while
    out.println("</TABLE>");
   
   
   statement.close();
   rs.close();  
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</body>
 <!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<!--=================================-->
</html>
