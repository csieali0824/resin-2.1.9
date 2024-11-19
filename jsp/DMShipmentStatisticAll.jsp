<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,java.text.DecimalFormat,RsCountBean" %>
<!--=============To get the Authentication==========-->
<!-- include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function DetailQueryByModel(modelNo)
{    
  subWin=window.open("DMShipmentStatistic.jsp?MODELNO="+modelNo,"subwin");  
}
</script>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>出貨統計</title>
<style type="text/css">
<!--
.style15 {font-size: 12px; font-weight: bold;}
.style16 {
	color: #808080;
	font-weight: bold;
}
.style19 {color: #000000; font-weight: bold; }
.style20 {color: #000000}
.style21 {color: #FF0000}
-->
</style>
</head>
<body>
<FORM ACTION="../jsp/DMShipmentStatisticAll.jsp" METHOD="post" NAME="MYFORM">
  <font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#000000" size="+2" face="Arial Black"><span class="style15"><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font></span></font></font></font></font><strong><font color="#000000" size="+2" face="Times New Roman"> 
  出貨統計</font></strong> 
<%
String sModelNo=request.getParameter("MODELNO");
String sCountry=request.getParameter("COUNTRY");
//String modelArray[]=null; //做為存model的陣列
String yearMonthString[][]=new String[4][2]; //做為存入year及month陣列
String ymCurrFr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();//今天日期
String currentDayStr=dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString();
String dateStringArray[]=new String[7]; //做為存入DATE之陣列
dateBean.setAdjDate(-7);
for (int i=0;i<7;i++)
{
 dateBean.setAdjDate(1);
 dateStringArray[i]=dateBean.getYearMonthDay();  
}		

dateBean.setAdjMonth(-4);
for (int i=0;i<4;i++)
{
  dateBean.setAdjMonth(1);
  yearMonthString[i][0]=dateBean.getYearString();
  yearMonthString[i][1]=dateBean.getMonthString();  
}		 
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet rs=null;
  Statement itemStat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet itemRs=null;
	Statement repairStat=dmcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	ResultSet subRs=null;
  Statement stateTpeShip=bpcscon.createStatement(); 
  ResultSet rsTpeShip=null;		   
  Statement foreStat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet foreRs=null;
  String itemCodeString=null;
  int sumShipTTLMonth[]={0,0,0,0};      
int sumForecastTTLMonth[]={0,0,0,0}; 
int sumShipTTLDay[]={0,0,0,0,0,0,0};
String total_shipmentQTY[]={"-","-","-","-"}; //做為存入shipment各月數量之陣列加總
String total_forecastQTY[]={"-","-","-","-"}; //做為存入sales forecast各月數量之陣列加總
String total_shipmentQTY_day[]={"-","-","-","-","-","-","-"}; //做為存入shipment本週數量之陣列加總  

  DecimalFormat df=new DecimalFormat(",000"); //做為輸出數字時有,的輸出物件
 %>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#3399CC"> 
      <td width="4%" rowspan="2" nowrap bgcolor="#0072A8"><div align="center"><strong><font color="#FFFFFF">機種</font></strong></div></td>
      <td width="6%" rowspan="2" nowrap bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFFFF">項目</font></strong></div></td>
      <td colspan="4" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFFFF" size="2" face="Arial">月 
          出貨/銷售預測資訊</font></strong></div></td>
      <td colspan="7" nowrap bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFFFF" size="2" face="Arial">日 
          出貨資訊</font></strong></div></td>
    </tr>
    <tr> 
      <td width="8%" height="27" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <%  out.println(yearMonthString[0][1]+"月"); %>
          </font></strong></div></td>
      <td width="8%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <%  out.println(yearMonthString[1][1]+"月"); %>
          </font></strong></div></td>
      <td width="7%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <%  out.println(yearMonthString[2][1]+"月"); %>
          </font></strong></div></td>
      <td width="10%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial">本月</font> 
          <font color="#FFFF00" size="1">(不含今日)</font></strong></div></td>
      <td width="8%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	   out.println(dateStringArray[0].substring(4,6)+"/"+ dateStringArray[0].substring(6,8)); 	    
	  %>
          </font></strong></div></td>
      <td width="7%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	  out.println(dateStringArray[1].substring(4,6)+"/"+ dateStringArray[1].substring(6,8)); 
	  %>
          </font></strong></div></td>
      <td width="8%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	    out.println(dateStringArray[2].substring(4,6)+"/"+ dateStringArray[2].substring(6,8)); 
	  %>
          </font></strong></div></td>
      <td width="7%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	   out.println(dateStringArray[3].substring(4,6)+"/"+ dateStringArray[3].substring(6,8)); 
	  %>
          </font></strong></div></td>
      <td width="7%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	   out.println(dateStringArray[4].substring(4,6)+"/"+ dateStringArray[4].substring(6,8)); 
	  %>
          </font></strong></div></td>
      <td width="7%" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial"> 
          <% 
	   out.println(dateStringArray[5].substring(4,6)+"/"+ dateStringArray[5].substring(6,8)); 
	  %>
          </font></strong></div></td>
      <td width="13%" colspan="1" bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFF00" size="2" face="Arial">本日</font></strong></div></td>
    </tr>
    <%
try
{  
	String sSql = "";
  String sWhere = "";	
  String sOrder="";
  sSql = "select unique trim(MPROJ) as PRJCD from PRODMODEL ";		  
  sWhere= " where   RFLAG='1'  ";
  
  //sSql="select unique trim(PMODEL) as PRJCD from PISSHIPCNT  "; 			                 		 
  //sWhere="where COUNTRY='886' and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"' and PCLASS='MO' "; 
  if (sModelNo!=null && !sModelNo.equals("--"))
  {
    sWhere=sWhere+" and mproj='"+sModelNo+"'";
   }
  if (sCountry!=null && !sCountry.equals("--"))
  {
    sWhere=sWhere+" and mcountry='"+sCountry+"'";
   }

   sOrder=" order by PRJCD";
  
  sSql = sSql+sWhere+sOrder;
  //out.println(sSql); 	
  rs=statement.executeQuery(sSql);
  while (rs.next())  //main while loop
  {
	   String showThisRow="N"; //是否要show出此列
	   String shipmentQTY[]={"-","-","-","-"}; //做為存入shipment各月數量之陣列
	   String shipmentQTY_day[]={"-","-","-","-","-","-","-"}; //做為存入shipment本週數量之陣列  
	   String forecastQTY[]={"-","-","-","-"}; //做為存入sales forecast各月數量之陣列 
    
	   String modelNo="";  
      
       modelNo=rs.getString("PRJCD");
   
     itemCodeString=null;
	  String sitemSql="select unique trim(MITEM) as ITEMNO from PRODMODEL a,PICOLOR_MASTER b where a.MCOLOR=b.COLORCODE and MPROJ='"+modelNo+"' and MCOUNTRY='886'  "; 
	  itemRs=itemStat.executeQuery(sitemSql);		
	 // 取條件內的機種成品料號 //
	//   out.println(sitemSql); 	

	 rsCountBean.setRs(itemRs); //取得其總筆數
	 if (rsCountBean.getRsCount()>0)
	 {
	   //itemCode=new String[rsCountBean.getRsCount()][3];    
	 
	   while (itemRs.next()) 
	   { 
		 		
		 if (itemCodeString==null)
		 {
			itemCodeString="'"+itemRs.getString("ITEMNO")+"'";
		 } 
		 else {
			itemCodeString=itemCodeString+",'"+itemRs.getString("ITEMNO")+"'";
		 }
	   } //end of while    
	 }  
	 itemRs.close();

	//往前推3個月出貨
	//===Ivy Yang 2005.06.16 把這一段改成到Data Center抓===//
	//String ssubSql="select sum(PCOUNT) as shqty,PYEAR||PMONTH as yearmonth from PISSHIPCNT where PCLASS='MO' and COUNTRY='886' and trim(PMODEL)='"+modelNo+"'  and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"' group by PYEAR||PMONTH  order by PYEAR||PMONTH"; 
	//out.println(ssubSql);
	//Statement repairStat=conREPAIR.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
	//ResultSet subRs=null;
	//subRs=repairStat.executeQuery(ssubSql);
	String ssubSql="SELECT SUM(ssqty) AS shqty,ssyear,ssmonth FROM stock_ship_mon "
	+" WHERE ssitemno in ("+itemCodeString+")"
	+" AND ((ssyear="+yearMonthString[0][0]+" AND ssmonth>="+yearMonthString[0][1]+") OR (ssyear="+yearMonthString[3][0]+" AND ssmonth<="+yearMonthString[3][1]+"))" //處理跨年
	+" GROUP BY ssyear,ssmonth HAVING SUM(ssqty)!=0 ORDER BY ssyear,ssmonth "; //out.println(ssubSql);
	subRs=repairStat.executeQuery(ssubSql);
	//if (subRs.next())  {
	while (subRs.next()) {
		for (int i=0;i<yearMonthString.length;i++) { //取得各月之出貨數量
			//String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
			//if (yearmonthStr.equals(subRs.getString("yearmonth")))
			if (subRs.getInt("ssyear")==Integer.parseInt(yearMonthString[i][0]) && subRs.getInt("ssmonth")==Integer.parseInt(yearMonthString[i][1])) {
				if (subRs.getInt("shqty")==0 ) {
					shipmentQTY[i]=subRs.getString("shqty");		   
				} else {
					if (subRs.getString("shqty").length()<3) {
						shipmentQTY[i]=subRs.getString("shqty");	
					} else {
						shipmentQTY[i]=df.format(subRs.getInt("shqty"));	
					} // end if-else
					sumShipTTLMonth[i]=sumShipTTLMonth[i]+subRs.getInt("shqty"); 
					showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目
				} // end if-else	   	   
				//if (!subRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
				break;
			} // end if
		}  // end of yearMonthSring for loop
	} //enf while
	//out.println(showThisRow);
	subRs.close(); 
	
	for (int ic=0;ic<sumShipTTLMonth.length;ic++) { //將數字用特定格式輸出
		if (sumShipTTLMonth[ic]<1000) {
			 total_shipmentQTY[ic]=String.valueOf(sumShipTTLMonth[ic]);	
		} else {
		     total_shipmentQTY[ic]=df.format(sumShipTTLMonth[ic]);	
		}	
	} // end for

	//取得BPCS中一週內每日之出貨資訊
	String sqlTpeShip="select sum(ILQTY) as qty,SIINVD from SIH h,SIL l where h.SIINVD between '"+dateStringArray[0]+"' and '"+dateStringArray[6]+"' "+   
                         "and h.SICUST=l.ILCUST and h.SIORD=l.ILORD and h.IHODYR=l.ILODYR and h.IHODPX=l.ILODPX and h.SIINVN=l.ILINVN  "+ 
                         "and h.SFRES not in('REPAI') and (h.SICTYP not in ('12','13') or h.SICUST  in('210040')) "+             
                         "and l.ILPROD in ("+itemCodeString+") group by SIINVD order by SIINVD";				                                                                                                                          
      rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
	  //out.println(sqlTpeShip); 
	  //if (rsTpeShip.next()) {
	while (rsTpeShip.next()) {
		for (int i=0;i<dateStringArray.length;i++) { //取得一週內每天之出貨數量
			String dateStr=dateStringArray[i];
			if (dateStr.equals(rsTpeShip.getString("SIINVD"))) {
				if (rsTpeShip.getInt("qty")==0) {
					  shipmentQTY_day[i]=rsTpeShip.getString("qty");		   
				} else {
					if (rsTpeShip.getInt("qty")<1000) {
						 shipmentQTY_day[i]=String.valueOf(rsTpeShip.getInt("qty"));	
					} else {
						 shipmentQTY_day[i]=df.format(rsTpeShip.getInt("qty"));	
					}//end if-else
					  sumShipTTLDay[i]=sumShipTTLDay[i]+rsTpeShip.getInt("qty"); 
					  showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目 
				}//end if-else
				//if (!rsTpeShip.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
				break;
			} //end if
		}  // end of yearMonthSring for loop
	} //enf while
	//out.println(showThisRow);
	rsTpeShip.close();
	   
	   for (int ic=0;ic<sumShipTTLDay.length;ic++) //將數字用特定格式輸出
	   {
	      if (sumShipTTLDay[ic]<1000)
		  {
			 total_shipmentQTY_day[ic]=String.valueOf(sumShipTTLDay[ic]);	
		  } else {
		     total_shipmentQTY_day[ic]=df.format(sumShipTTLDay[ic]);	
	      }	
	   } 
	  
   
   
   	    //取得月份之銷售預測數字
		String fcSql="select SUM(f.FMQTY) as fmqty,f.FMYEAR||f.FMMONTH as yearmonth from PSALES_FORE_MONTH f"+
		             " where f.FMTYPE='001' and f.FMCOUN=886  and f.FMPRJCD='"+modelNo+"' "+
					 " and f.FMYEAR||f.FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"'"+
					 " and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)"+
					 " group by f.FMYEAR||f.FMMONTH"+
					 " order by f.FMYEAR||f.FMMONTH";
		//out.println(fcSql); 			 
	    foreRs=foreStat.executeQuery(fcSql);		
		while (foreRs.next()) {
		//if (foreRs.next())  {
			for (int i=0;i<yearMonthString.length;i++) {//取得各月之sales forecast數量
	          String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	          if (yearmonthStr.equals(foreRs.getString("yearmonth"))) {		   
		        if (foreRs.getInt("FMQTY")==0 ) {
		           forecastQTY[i]=foreRs.getString("FMQTY");		   
		        } else {		    
		           forecastQTY[i]=df.format(Math.round(Float.parseFloat(foreRs.getString("FMQTY"))*1000));//因為單位是K所以必須乘以1000			  	 
				   sumForecastTTLMonth[i]=sumForecastTTLMonth[i]+(Math.round(Float.parseFloat(foreRs.getString("FMQTY"))*1000)); 
				   //showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目
		        } // end if-else
		        //if (!foreRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		      	break;
			  } // end if
	       }  // end of yearMonthSring for loop
        } //enf while
        foreRs.close();
		
		for (int ic=0;ic<sumForecastTTLMonth.length;ic++) //將數字用特定格式輸出
	    {
	      if (sumForecastTTLMonth[ic]<1000)
		  {
			 total_forecastQTY[ic]=String.valueOf(sumForecastTTLMonth[ic]);	
		  } else {
		     total_forecastQTY[ic]=df.format(sumForecastTTLMonth[ic]);	
	      }	
	    } 
   
		
		if (showThisRow.equals("Y")) {
%>
    <tr> 
      <td rowspan="2" nowrap align="left"> <a href='javaScript:DetailQueryByModel("<%=modelNo%>")' > <%=modelNo%></a></td>
      <td nowrap><font color="#333333"  size="2">出貨</font></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial"> </font><font color="#0000FF" size="2" face="Arial"> 
          </font><font size="2" face="Arial"><%=shipmentQTY[0]%></font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial"> </font><font size="2" face="Arial"><%=shipmentQTY[1]%></font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial"> </font><font size="2" face="Arial"><%=shipmentQTY[2]%></font></div></td>
      <td><div align="right"><font size="2" face="Arial"><%=shipmentQTY[3]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[0]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[1]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[2]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[3]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[4]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[5]%></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><%=shipmentQTY_day[6]%></font></div></td>
    </tr>
    <tr> 
      <td nowrap><font color="#CC0066"  size="2"><font size="2">銷售預測</font></span></font></span></td>
      <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[0]%></font></div></td>
      <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[1]%></font></div></td>
      <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[2]%></font></div></td>
      <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[3]%></font></div></td>
    </tr>
<%
		} //end if
	}//end of while loop
	rs.close();
	itemStat.close();
	repairStat.close();
	stateTpeShip.close();
	foreStat.close();	
	statement.close();

} catch (Exception ee) { out.println("Exception:"+ee.getMessage());		  
	%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%><%
}//end of try-catch
%>
	<tr bgcolor="#FFFFCC"> 
      <td rowspan="2"><font color="#0000FF">總計</font></td>
      <td nowrap><strong><font color="#333333"  size="2">出貨</font></strong></td>
      <td> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[0]%></strong></font></div></td>
      <td> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[1]%></strong></font></div></td>
      <td> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[2]%></strong></font></div></td>
      <td> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[3]%></strong></font></div></td>
      <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[0]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[1]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[2]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[3]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[4]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[5]%></strong></font></div></td>
      <td rowspan="2"> <div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[6]%></strong></font></div></td>
    </tr>
	<tr> 
      <td nowrap bgcolor="#FFFFCC"><strong><font color="#CC0066"  size="2"><font size="2">銷售預測</font></font></strong></td>
      <td bgcolor="#FFFFCC"> <div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[0]%></strong></font></div></td>
      <td bgcolor="#FFFFCC"> <div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[1]%></strong></font></div></td>
      <td bgcolor="#FFFFCC"> <div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[2]%></strong></font></div></td>
      <td bgcolor="#FFFFCC"> <div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[3]%></strong></font></div></td>
    </tr>
	
  </table>
</FORM>
</body>
<%

%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
</html>