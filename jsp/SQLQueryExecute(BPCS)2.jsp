<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>BPCS RsTest</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%  
  String sqlStat="SELECT DISTINCT r1.arodyr,r1.arodpx,r1.rinvc,r1.rcust,r2.arsord,cnme FROM rar r1,rar r2, rcm WHERE (r1.arodyr=r2.arodyr AND r1.arodpx=r2.arodpx AND r1.rinvc=r2.rinvc AND r1.rseq=r2.rnxt AND r1.rcust=ccust) AND (r1.rrid IN ('RP','RC') AND r1.rseq>=1 ) AND (r2.rrid='RI' AND r2.rrem=0 ) AND (r1.rdate ='20040629') order by r1.rcust,r2.arsord,r1.arodyr,r1.arodpx,r1.rinvc ";
  try
  {   
   Statement statement=bpcscon.createStatement();
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
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
