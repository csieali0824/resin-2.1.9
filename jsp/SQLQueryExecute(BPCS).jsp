<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"  %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<!--=================================-->
<html>
<head>
<title>BPCS RsTest</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%    
  //String sqlStat="select cnme,ilcust,sum(ilqty) as qty,sum(ilnet*ilqty) from sil ,iim,rcm a,ecl where ilprod=iprod and iityp='F' and  ildate between 20040801 and 20040831 and ilcust=ccust and cmsttp!='A' and ILWHS in (71,72,73) and ilord=lord and ilprod=lprod and lloc='M001'  and ilnet>=(select PFCT*1.08 from tesp where PRKEY=iabbt and psdte='200408' and PCOMP='886' and PVER=(select max(PVER) from tesp where  PRKEY=iabbt and psdte='200408' and PCOMP='886' ) )  group by cnme,ilcust order by qty DESC";
  //String sqlStat="SELECT  Unique CSAL,SNAME from RCM,SSM where CTYPE in ('11','12','13') and CSAL=SSAL order by CSAL";
  //String sqlStat="select PRKEY,pfct from tesp where prkey in (select IABBT from sil ,iim,ecl where ilprod=iprod and iityp='F' and  ildate between 20040801 and 20040831 and ilcust=159246 and ILWHS in (71,72,73) and ilord=lord and ilprod=lprod and lloc='M001' and ilnet>=(select PFCT*1.08 from tesp where PRKEY=iabbt and psdte='200408' and PCOMP='886' and PVER=(select max(PVER) from tesp where  PRKEY=iabbt and psdte='200408' and PCOMP='886' ) ) )  and psdte='200408' and PCOMP='886' and PVER=(select max(PVER) from tesp where psdte='200408' and PCOMP='886')";
  //String sqlStat="select PRKEY,pfct from tesp where psdte='200408' and PCOMP='886' and PVER=(select max(PVER) from tesp where psdte='200408' and PCOMP='886')";
  //String sqlStat="select CNME||'('||LCUST||')' as cust, LORD, LLINE,LPROD,LDESC,LQORD,LQSHP,LRDTE,LNET from ecl,rcm  where lcust=ccust and  lcust in (159086) and lrdte <=20041231 and LWHS=86 order by CUST,LORD,LLINE";
  //String sqlStat="select CNME||'('||LCUST||')' as cust, LORD, LLINE,LPROD,LDESC,LQORD,LQSHP,LRDTE,LNET from ecl,rcm  where lcust=ccust and  lcust in (159086) and lrdte <=20041231 and LLOC='M002' order by CUST,LORD,LLINE";
  String sqlStat="select unique APOVND,VNDNAM,APCURR from apo,avm where APOVND=VENDOR AND APCURR in ('USD')";
  try
  {   
   Statement statement=bpcscon.createStatement();
   //Statement statement=ifxdistcon.createStatement();
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
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<!--=================================-->
</html>
