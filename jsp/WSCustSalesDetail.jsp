<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat,RsCountBean,ArraySearchBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<jsp:useBean id="arraySearchBean" scope="application" class="ArraySearchBean"/>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
 rstart();
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Customer Sales Information Detail </title>
</head>
<body>
<!--%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>-->
<FORM ACTION="WSCustSalesDetail.jsp" METHOD="post" NAME="MYFORM" onSubmit="rstart()">
<%   
String vYear=request.getParameter("VYEAR");
if (vYear==null) vYear=dateBean.getYearString();
String vMonth=request.getParameter("VMONTH");
if (vMonth==null) vMonth=dateBean.getMonthString();
String cust=request.getParameter("CUST");
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
DecimalFormat df=new DecimalFormat(",000");
%>
<font color="#54A7A7" face="Times New Roman" size="5">DBTEL</font><font color="#000000" size="5" face="Times New Roman"> <strong>門市經銷商銷售資訊(<%=vYear%>/<%=vMonth%>)</strong></font>
   &nbsp; &nbsp; &nbsp; &nbsp;<A HREF="../WinsMainMenu.jsp">HOME</A>
   &nbsp; &nbsp; &nbsp; &nbsp;<font size="2">
   
   </font><BR>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr bgcolor="#3300FF">
    <td><strong><font color="#FFFFFF">銷售商品</font></strong></td>
    <td><div align="right"><strong><font color="#FFFFFF">銷售數量</font></strong></div></td>
    <td bgcolor="#3300FF"><div align="right"><strong><font color="#FFFFFF">銷售單價</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">銷售總額</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">銷售日期</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">銷售人員</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">訂單號碼</font></strong></div></td>
    </tr> 
<%	
//MAIN PROCESS
String sqlStat="select ilprod,ilcust,ilnet,ilqty,ildate,sname,ilnet*ilqty as AMOUNT,ilord from sil,ssm where ilsal1=ssal and  ilcust='"+cust+"' and ildate between "+dateBean.getYearString()+dateBean.getMonthString()+"01 and "+dateBean.getYearString()+dateBean.getMonthString()+"31 order by ildate";
String cnme="",outQTY="",outAMOUNT="",outNET="",saleDate="",salePerson="",orderNumber="",prod="";
String outTotalQTY="",outTotalAMOUNT="",outTotalNET="";
int QTY=0,totalQTY=0;
long NET=0,totalNET=0,AMOUNT=0,totalAMOUNT=0;

try 
{     
  Statement statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=statement.executeQuery(sqlStat); 
  int ac=0;  
  while (rs.next())
  {  
   QTY=0; //歸零
   NET=0; //歸零
   AMOUNT=0;   
   QTY=rs.getInt("ILQTY");
   totalQTY=totalQTY+QTY;
   if(QTY>=1000 || QTY<=-1000)   
   {
    outQTY=df.format(QTY); 
   } else {
    outQTY=String.valueOf(QTY);
   }   	
   		
   AMOUNT=rs.getInt("AMOUNT");
   totalAMOUNT=totalAMOUNT+AMOUNT;
   if(AMOUNT>=1000 || AMOUNT<=-1000)   
   {
    outAMOUNT=df.format(AMOUNT); 
   } else {
    outAMOUNT=String.valueOf(AMOUNT);
   }    
   
   NET=rs.getInt("ILNET");
   totalNET=totalNET+NET;
   if(NET>=1000 || NET<=-1000)   
   {
    outNET=df.format(NET); 
   } else {
    outNET=String.valueOf(NET);
   } 	  
   
   saleDate=rs.getString("ILDATE");
   salePerson=rs.getString("SNAME");
   orderNumber=rs.getString("ILORD");
   prod=rs.getString("ILPROD");
   
  %>
   <tr bgcolor="#FFFFFF">
    <td><%=prod%></td>
    <td><div align="right"><%=outQTY%></div></td>
    <td><div align="right"><%=outNET%></div></td>
    <td><div align="right"><%=outAMOUNT%></div></td>
    <td><div align="right"><%=saleDate%></div></td>
    <td><div align="right"><%=salePerson%></div></td>
    <td><div align="right"><%=orderNumber%></div></td>
    </tr>   
  <%   
  } //end of rs.next While   
  
  if(totalQTY>=1000 || totalQTY<=-1000)   
  {
    outTotalQTY=df.format(totalQTY); 
  } else {
    outTotalQTY=String.valueOf(totalQTY);
  }  
  if(totalAMOUNT>=1000 || totalAMOUNT<=-1000)   
  {
    outTotalAMOUNT=df.format(totalAMOUNT); 
  } else {
    outTotalAMOUNT=String.valueOf(totalAMOUNT);
  } 
  if(totalNET>=1000 || totalNET<=-1000)   
  {
    outTotalNET=df.format(totalNET); 
  } else {
    outTotalNET=String.valueOf(totalNET);
  }  
  
  rs.close();    
  statement.close();
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}   
%>  
 <tr bgcolor="#FF0000">      
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF">TOTAL</font></div></td>
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF"><%=outTotalQTY%></font></div></td>
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF"><%=outTotalNET%></font></div></td>
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF"><%=outTotalAMOUNT%></font></div></td>
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF">--</font></div></td>
      <td bgcolor="#3300FF"><div align="right"><font color="#FFFFFF">--</font></div></td>
      <td bgcolor="#3300FF"><font color="#FFFFFF">--</font></td>
    </tr>	
</TABLE> 
<BR>	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>