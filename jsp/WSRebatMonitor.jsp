<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ArrayComboBoxBean,ComboBoxBean,DateBean,java.text.DecimalFormat,RsCountBean,ArraySearchBean" %>
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
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Real Time Channel/Retailer Rebat Information Monitor </title>
</head>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM ACTION="WSRebatMonitor.jsp" METHOD="post" NAME="MYFORM" onSubmit="rstart()">
<%   
String vYear=request.getParameter("VYEAR");
if (vYear==null) vYear=dateBean.getYearString();
String vMonth=request.getParameter("VMONTH");
if (vMonth==null) vMonth=dateBean.getMonthString();
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
DecimalFormat df=new DecimalFormat(",000");
%>
<font color="#54A7A7" face="Times New Roman" size="5">DBTEL</font><font color="#000000" size="5" face="Times New Roman"> <strong>門市經銷商紅利回饋即時資訊(<%=vYear%>/<%=vMonth%>)</strong></font>
   &nbsp; &nbsp; &nbsp; &nbsp;<A HREF="../WinsMainMenu.jsp">HOME</A>
   &nbsp; &nbsp; &nbsp; &nbsp;<font size="2">
   <INPUT name="submit" TYPE="submit"  value="Refresh">
   </font><BR>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr bgcolor="#FF0000">
    <td><strong><font color="#FFFFFF">店家</font></strong></td>
    <td><div align="right"><strong><font color="#FFFFFF">進貨量</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">進貨總額</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">紅利</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">通路支援費</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">額外貢獻金</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">未結貨款</font></strong></div></td>
    <td><div align="right"><strong><font color="#FFFFFF">信用額度</font></strong></div></td>
  </tr> 
<%	
//MAIN PROCESS
String sqlStat="select cnme,ilcust,sum(ilqty) as qty,sum(ilnet*ilqty) as amount,crdol from sil ,iim,rcm,ecl where ilprod=iprod and iityp='F' and  ildate between "+dateBean.getYearString()+dateBean.getMonthString()+"01 and "+dateBean.getYearString()+dateBean.getMonthString()+"31 and ilcust=ccust and cmsttp!='A' and ILWHS in (71,72,73) and ilord=lord and ilprod=lprod and lloc='M001'  and ilnet>=(select PFCT*1.08 from tesp where PRKEY=iabbt and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886' and PVER=(select max(PVER) from tesp where  PRKEY=iabbt and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886' ) ) group by cnme,ilcust,crdol having sum(ilqty)>0 order by qty DESC";
String outCNME="",outILCUST="",outQTY="",outAMOUNT="",outCREDIT="",outAR="",outREBAT="",outMISCFEE="",outCONTRIBUTION="";
String outTotalQTY="",outTotalAMOUNT="",outTotalREBAT="",outTotalMISCFEE="",outTotalCONTRIBUTION="",outTotalAR="";
int QTY=0,AMOUNT=0,CREDIT=0,totalQTY=0;
long REBAT=0,MISCFEE=0,CONTRIBUTION=0,AR=0,totalAMOUNT=0,totalREBAT=0,totalMISCFEE=0,totalCONTRIBUTION=0,totalAR=0;

try 
{     
  Statement statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
  Statement subStmt=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);  
  ResultSet rs=statement.executeQuery(sqlStat); 
  String subSql="select ilcust,prkey,ilnet,PFCT,sum(ilqty) as qty from sil,iim,rcm,ecl,tesp where ilprod=iprod and iityp='F' and prkey=IABBT and ildate between "+dateBean.getYearString()+dateBean.getMonthString()+"01 and "+dateBean.getYearString()+dateBean.getMonthString()+"31 and ilcust=ccust and cmsttp!='A' and ILWHS in (71,72,73) and ilord=lord and ilprod=lprod and lloc='M001' and ilnet>=(select PFCT*1.08 from tesp where PRKEY=iabbt and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886' and PVER=(select max(PVER) from tesp where PRKEY=iabbt and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886' ) )  and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886' and PVER=(select max(PVER) from tesp where PRKEY=iabbt and psdte='"+dateBean.getYearString()+dateBean.getMonthString()+"' and PCOMP='886') group by ilcust,prkey,pfct,ilnet having sum(ilqty)>0 order by ilcust";
  ResultSet subRs=subStmt.executeQuery(subSql);
  rsCountBean.setRs(subRs);
  int rsLength=rsCountBean.getRsCount();
  String array2DString[][]=new String[rsLength][5];
  String arraySearch[]=new String[rsLength];
  int ac=0;
  while (subRs.next())
  {  	
    arraySearch[ac]=subRs.getString("ILCUST");//此為搜尋用暫時性陣列
	
    array2DString[ac][0]=subRs.getString("ILCUST");
	array2DString[ac][1]=subRs.getString("PRKEY"); 
	array2DString[ac][2]=String.valueOf(subRs.getInt("ILNET"));//賣價
	array2DString[ac][3]=String.valueOf(subRs.getInt("PFCT"));//最低零售價
	array2DString[ac][4]=String.valueOf(subRs.getInt("QTY")); //數量
	ac++;
  }  
  subRs.close();  
  
  arraySearchBean.setArraySearch(arraySearch); //將搜尋用暫時性陣列置入搜尋機制中以便隨時引用
   
  while (rs.next())
  {  
   REBAT=0; //歸零
   MISCFEE=0; //歸零
   CONTRIBUTION=0;   
   outCNME=rs.getString("CNME");
   outILCUST=rs.getString("ILCUST");   
   QTY=rs.getInt("QTY");
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
   
   CREDIT=rs.getInt("CRDOL");
   if(CREDIT>=1000 || CREDIT<=-1000)   
   {
    outCREDIT=df.format(CREDIT); 
   } else {
    outCREDIT=String.valueOf(CREDIT);
   } 	
   
   arraySearchBean.setKeyString(outILCUST);    
   int whereIs=arraySearchBean.getElementAt();//取得其在陣列中位置   
   for (int i=whereIs;i<rsLength;i++)   
   {          
	 //out.println(array2DString[i][0]+"|"+array2DString[i][1]+"|"+array2DString[i][2]+"|"+array2DString[i][3]+"|"+array2DString[i][4]);     
     if (!outILCUST.equals(array2DString[i][0])) break;
	 int j=Integer.parseInt(array2DString[i][3]);	 
	 int k=Integer.parseInt(array2DString[i][4]);
	 int l=Integer.parseInt(array2DString[i][2]); //賣價 	  
     REBAT=REBAT+Math.round(j*k*0.05);//紅利	
	 MISCFEE=MISCFEE+Math.round(j*k*0.03);//通路支援費
	 CONTRIBUTION=CONTRIBUTION+((l-Math.round(j*1.08))*k);//額外貢獻金
   }
   
   totalREBAT=totalREBAT+REBAT;
   if(REBAT>=1000 || REBAT<=-1000)   
   {
    outREBAT=df.format(REBAT); 
   } else {
    outREBAT=String.valueOf(REBAT);
   } 	
   
   totalMISCFEE=totalMISCFEE+MISCFEE;
   if(MISCFEE>=1000 || MISCFEE<=-1000)   
   {
    outMISCFEE=df.format(MISCFEE); 
   } else {
    outMISCFEE=String.valueOf(MISCFEE);
   } 	
   
   totalCONTRIBUTION=totalCONTRIBUTION+CONTRIBUTION;
   if(CONTRIBUTION>=1000 || CONTRIBUTION<=-1000)   
   {
    outCONTRIBUTION=df.format(CONTRIBUTION); 
   } else {
    outCONTRIBUTION=String.valueOf(CONTRIBUTION);
   } 	
   
   subRs=subStmt.executeQuery("select sum(rrem) as AR from rar where rrid='RI' AND rrem!=0 and rcust="+outILCUST+" and ridte between "+dateBean.getYearString()+dateBean.getMonthString()+"01 and "+dateBean.getYearString()+dateBean.getMonthString()+"31");
   if (subRs.next()) AR=subRs.getLong("AR");
   totalAR=totalAR+AR;
   if(AR>=1000 || AR<=-1000)   
   {
    outAR=df.format(AR); 
   } else {
    outAR=String.valueOf(AR);
   } 	       
  %>
   <tr bgcolor="#FFFFFF">
    <td><a href="WSCustSalesDetail.jsp?CUST=<%=outILCUST%>"><%=outCNME%>(<%=outILCUST%>)</a></td>
    <td><div align="right"><%=outQTY%></div></td>
    <td><div align="right"><%=outAMOUNT%></div></td>
    <td><div align="right"><%=outREBAT%></div></td>
    <td><div align="right"><%=outMISCFEE%></div></td>
    <td><div align="right"><%=outCONTRIBUTION%></div></td>
    <td><div align="right"><%=outAR%></div></td>
    <td><div align="right"><%=outCREDIT%></div></td>
  </tr>   
  <%
   subRs.close();
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
  if(totalREBAT>=1000 || totalREBAT<=-1000)   
  {
    outTotalREBAT=df.format(totalREBAT); 
  } else {
    outTotalREBAT=String.valueOf(totalREBAT);
  }
  if(totalMISCFEE>=1000 || totalMISCFEE<=-1000)   
  {
    outTotalMISCFEE=df.format(totalMISCFEE); 
  } else {
    outTotalMISCFEE=String.valueOf(totalMISCFEE);
  }  
  if(totalCONTRIBUTION>=1000 || totalCONTRIBUTION<=-1000)   
  {
    outTotalCONTRIBUTION=df.format(totalCONTRIBUTION); 
  } else {
    outTotalCONTRIBUTION=String.valueOf(totalCONTRIBUTION);
  }    	
  if(totalAR>=1000 || totalAR<=-1000)   
  {
    outTotalAR=df.format(totalAR); 
  } else {
    outTotalAR=String.valueOf(totalAR);
  }  
  
  rs.close();  
  subStmt.close();   
  statement.close();
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}   
%>  
 <tr bgcolor="#FF0000">      
      <td><div align="right"><font color="#FFFFFF">TOTAL</font></div></td>
      <td><div align="right"><font color="#FFFFFF"><%=outTotalQTY%></font></div></td>
      <td><div align="right"><font color="#FFFFFF"><%=outTotalAMOUNT%></font></div></td>
      <td><div align="right"><font color="#FFFFFF"><%=outTotalREBAT%></font></div></td>
      <td><div align="right"><font color="#FFFFFF"><%=outTotalMISCFEE%></font></div></td>
      <td><div align="right"><font color="#FFFFFF"><%=outTotalCONTRIBUTION%></font></div></td>
      <td><font color="#FFFFFF"><%=outTotalAR%></font></td>
      <td><font color="#FFFFFF">--</font></td>
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