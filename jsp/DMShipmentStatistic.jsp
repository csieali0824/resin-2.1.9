<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,RsCountBean,java.text.DecimalFormat" %>
<!--=============To get the Authentication==========-->
<!--%@include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Shipment Statistic Report</title>
</head>
<body>
<form ACTION="../jsp/DMShipmentStatistic.jsp" METHOD="post">
<% 
//取得傳入參數
String sModelNo=request.getParameter("MODELNO");
String country=request.getParameter("COUNTRY");

//Statement stateTpeShip=bpcscon.createStatement(); 
Statement stateTpeShip=dmcon.createStatement();
ResultSet rsTpeShip=null;		   
Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY); 
ResultSet rs=null;
//Statement repairStat=conREPAIR.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
Statement repairStat=dmcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet subRs=null;
String modelArray[]=null; //做為存model的陣列		 
String [][] itemCode=null;//定義為存放成品料號與顏色代碼之陣列
String [][] colorCode=null;//定義為存放該model之顏色代碼之陣列
String itemCodeString=null;
String yearMonthString[][]=new String[4][2]; //做為存入year及month陣列
String ymCurrFr = dateBean.getYearString()+dateBean.getMonthString()+dateBean.getDayString();//今天日期
String currentDayStr=dateBean.getYearString()+"/"+dateBean.getMonthString()+"/"+dateBean.getDayString();
String sql = "";

if (country==null || country.equals("")) country = "886"; // 若未給定國別,則預設取台灣(886)

String dateStringArray[]=new String[7]; //做為存入DATE之陣列
dateBean.setAdjDate(-7);
for (int i=0;i<7;i++) {
 	dateBean.setAdjDate(1);
 	dateStringArray[i]=dateBean.getYearMonthDay();  
}		

dateBean.setAdjMonth(-4);
for (int i=0;i<4;i++) {
  	dateBean.setAdjMonth(1);
  	yearMonthString[i][0]=dateBean.getYearString();
	yearMonthString[i][1]=dateBean.getMonthString();  
}		 

if ( sModelNo!=null ) {
  modelArray=new String[1];
  modelArray[0]=sModelNo;
} else {
  /*
  //還要看其是否有實際出貨過,才入陣列中
  subRs=repairStat.executeQuery("select unique trim(PMODEL) as PRJCD from PISSHIPCNT where COUNTRY='886' and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"' and PCLASS='MO' order by PRJCD");	 
  */
  //由PRODMODEL中之MFLAG=1決定其是否顯示出來
  subRs=statement.executeQuery("select unique trim(MPROJ) as PRJCD from PRODMODEL where MFLAG='1'");
  rsCountBean.setRs(subRs); //取得其總筆數
  modelArray=new String[rsCountBean.getRsCount()];
  int mac=0;
  while (subRs.next()) {
    modelArray[mac]=subRs.getString("PRJCD");	
    mac++;
  }
  subRs.close();
   
  	//將所有model印出來 
  	out.println("<table width='100%' border='0'>");   
  	for (int kk=0;kk<modelArray.length;kk++) {    
    	if (  (kk)%10==0 ) { //若除以10取餘數為零者	
	 		out.println("<TR>"); 
		}	
		out.println("<TD width='5%'><a href='#"+modelArray[kk]+"'>"+modelArray[kk]+"</a></TD>");	
		if (  (kk)%10==9 ) {//若除以10取餘數為9者	
	 		out.println("</TR>");   
		}	
  	} 
  	out.println("</table>");
}// end if-else

DecimalFormat df=new DecimalFormat(",000"); //做為輸出數字時有,的輸出物件

try {  

	for (int g=0;g<modelArray.length;g++) { //main for loop
     	itemCodeString=null;
	 	itemCode=null;//定義為存放成品料號與顏色代碼及顏色描述之陣列
	 	colorCode=null;//定義為存放該model之顏色代碼之陣列
	 	sql = "select unique trim(a.MITEM) as ITEMNO,trim(a.MCOLOR) as COLOR,trim(b.COLORDESC) as COLORDESC "
		+" from PRODMODEL a,PICOLOR_MASTER b "
		+" where a.MCOLOR=b.COLORCODE and a.MPROJ='"+modelArray[g]+"' and a.MCOUNTRY = '"+country+"' "
		//+" from PRODMODEL a,PICOLOR_MASTER b,PSALES_FORE_MONTH c "
		//+" where a.MPROJ=c.FMPRJCD and c.FMCOLOR=b.COLORCODE and MPROJ='"+modelArray[g]+"' and MCOUNTRY = '"+country+"' "
		+" order by COLORDESC ";
		//out.println(sql);
		rs=statement.executeQuery(sql);
	 	// 取條件內的機種成品料號 //
	 	rsCountBean.setRs(rs); //取得其總筆數
	 	if (rsCountBean.getRsCount()>0) {
	   		itemCode=new String[rsCountBean.getRsCount()][3];    
	 
	   		int ic=0;
	   		while (rs.next())  { 
	     		itemCode[ic][0]=rs.getString("COLORDESC"); 
	     		itemCode[ic][1]=rs.getString("COLOR");		           
		 		itemCode[ic][2]=rs.getString("ITEMNO");
		 		//out.println("<br>"+itemCode[ic][0]+itemCode[ic][1]+itemCode[ic][2]);
		 		if (itemCodeString==null) {
					itemCodeString="'"+rs.getString("ITEMNO")+"'";
		 		} else {
					itemCodeString=itemCodeString+",'"+rs.getString("ITEMNO")+"'";
		 		} // end if
		 		ic++; 
	   		} //end of while    
	 	}  // end if
		rs.close();  				
	 
	 	// 取條件內的機種顏色代碼 //
		//sql = "select unique trim(a.MCOLOR) as COLOR,trim(b.COLORDESC) as COLORDESC "
		//+" from PRODMODEL a,PICOLOR_MASTER b,PSALES_FORE_MONTH c "
		//+" where  a.MPROJ=c.FMPRJCD and c.FMCOLOR=b.COLORCODE and MPROJ='"+modelArray[g]+"' "
		//+" order by COLORDESC";		
		//sql = "select unique trim(a.MCOLOR) as COLOR,trim(b.COLORDESC) as COLORDESC "
		//+" from PRODMODEL a,PICOLOR_MASTER b "
		//+" where a.MCOLOR=b.COLORCODE and a.MPROJ='"+modelArray[g]+"' and a.MCOUNTRY = '"+country+"' "
		//+" order by COLORDESC";		
	 	sql = "select unique trim(b.colorcode) as COLOR,trim(b.COLORDESC) as COLORDESC "
		+" from PICOLOR_MASTER b,PSALES_FORE_MONTH c "
		+" where c.FMCOLOR=b.COLORCODE and c.FMPRJCD='"+modelArray[g]+"' "
		+" order by COLORDESC";
		//out.println(sql);
		rs=statement.executeQuery(sql);
	 	rsCountBean.setRs(rs); //取得其總筆數
	 	if (rsCountBean.getRsCount()>0) {
	   		colorCode=new String[rsCountBean.getRsCount()][2];    
	   		int ic=0;
	   		while (rs.next())  {          
	     		colorCode[ic][0]=rs.getString("COLORDESC");		 
		 		colorCode[ic][1]=rs.getString("COLOR");			 	
		 		//out.println("<br>"+colorCode[ic][0]+colorCode[ic][1]);
				ic++; 
	   		} //end of while    
	 	}  // end if
	 	rs.close();  								
%>
<table width="100%" border="1">
  <tr bgcolor="#0072A8">
    <td colspan="13">
	<font color="WHITE" size="+2" face="Times New Roman"><strong><a name='<%=modelArray[g]%>'><%=modelArray[g]%></a> 出貨統計明細 </strong></font> <font face="Arial" color="#FFFFFF"> 
        <strong>( 
        <%
		     out.println(currentDayStr);//秀出今天日期         
        %>
      )</strong>
    </font>
	&nbsp;&nbsp;&nbsp;&nbsp;
	<strong><font color='WHITE' face='Arial'>累計出貨總數:
<%          
	int sumTpeShip = 0; 
   		if (itemCode==null || itemCode.length<1) {
	 		out.println("N/A");       
   		} else {				         
			//2005.06.20 Ivy Yang改成到Data Center抓資料
				//String sqlTpeShip="select sum(ILQTY) as qty from SIH h,SIL l where h.SIINVD <= '"+ymCurrFr+"' "+   
				//"and h.SICUST=l.ILCUST and h.SIORD=l.ILORD and h.IHODYR=l.ILODYR and h.IHODPX=l.ILODPX and h.SIINVN=l.ILINVN  "+ 
				//"and h.SFRES not in('REPAI') and (h.SICTYP not in ('12','13') or h.SICUST  in('210040')) "+             
				//"and l.ILPROD in ("+itemCodeString+") ";	                     			                                                                                                                          
				//rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
			String sqlTpeShip="select sum(stqty) as qty from stock_ship_mon where ssyear="+yearMonthString[3][0]+" and ssmonth="+yearMonthString[3][1]+" AND ssitemno in ("+itemCodeString+") ";
			rsTpeShip = repairStat.executeQuery(sqlTpeShip);
			if (rsTpeShip.next() && rsTpeShip.getInt(1)>0) { 
		  		sumTpeShip =rsTpeShip.getInt(1);
		  		if (sumTpeShip>=1000) {
		    		out.println(df.format(sumTpeShip));
		  		} else {
		    		out.println(sumTpeShip);
		  		}  // end if-else                           		                                                                   
			} else {                                                                     
		  		out.println("&nbsp;");  
			} // end if-else                    
			rsTpeShip.close();              					        
   		} // end if-else  
                   			
%>
    </font></strong></td>
    </tr>
  <tr>
    <td width="10%" rowspan="2"><font size=2>顏色</font></td>
    <td width="10%" rowspan="2">
      <div align="center"><font size=2>項目資訊</font></div></td>
    <td colspan="4"><font color="#000000" size="2" face="Arial">月 出貨/銷售預測資訊</font></td>
    <td colspan="7"><font color="#000000" size="2" face="Arial">日 出貨資訊</font></td>
  </tr>
  <tr>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% out.println(yearMonthString[0][1]+"月"); %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <%  out.println(yearMonthString[1][1]+"月"); %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <%  out.println(yearMonthString[2][1]+"月"); %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">本月</font>
	 <BR><font size="1">(不含今日)</font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	   out.println(dateStringArray[0].substring(4,6)+"/"+ dateStringArray[0].substring(6,8)); 	    
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	  out.println(dateStringArray[1].substring(4,6)+"/"+ dateStringArray[1].substring(6,8)); 
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	    out.println(dateStringArray[2].substring(4,6)+"/"+ dateStringArray[2].substring(6,8)); 
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	   out.println(dateStringArray[3].substring(4,6)+"/"+ dateStringArray[3].substring(6,8)); 
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	   out.println(dateStringArray[4].substring(4,6)+"/"+ dateStringArray[4].substring(6,8)); 
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">
      <% 
	   out.println(dateStringArray[5].substring(4,6)+"/"+ dateStringArray[5].substring(6,8)); 
	  %>
    </font></td>
    <td width="7%"><font color="#000000" size="2" face="Arial">本日	
    </font></td>
  </tr>
<%
	int sumShipTTLMonth[]={0,0,0,0};      
	int sumForecastTTLMonth[]={0,0,0,0}; 
	int sumShipTTLDay[]={0,0,0,0,0,0,0};
	String total_shipmentQTY[]={"-","-","-","-"}; //做為存入shipment各月數量之陣列加總
	String total_forecastQTY[]={"-","-","-","-"}; //做為存入sales forecast各月數量之陣列加總
	String total_shipmentQTY_day[]={"-","-","-","-","-","-","-"}; //做為存入shipment本週數量之陣列加總  

		if (modelArray[g]!=null && modelArray[g]!="" && colorCode!=null && colorCode.length>0 ) {				    
			for (int jj=0;jj<colorCode.length;jj++) {
	   			String showThisRow="N"; //是否要show出此列
	   			String shipmentQTY[]={"-","-","-","-"}; //做為存入shipment各月數量之陣列
	   			String shipmentQTY_day[]={"-","-","-","-","-","-","-"}; //做為存入shipment本週數量之陣列  
	   			String forecastQTY[]={"-","-","-","-"}; //做為存入sales forecast各月數量之陣列 

	   			itemCodeString=null;
	   			//取得看該顏色存在哪些料號
	   			for (int gc=0;gc<itemCode.length;gc++) {
	     			if (itemCode[gc][1].equals(colorCode[jj][1])) { //如果顏色相同才取出料號
	       				if (itemCodeString==null) {
			  				itemCodeString="'"+itemCode[gc][2]+"'";
		   				} else {
			 				 itemCodeString=itemCodeString+",'"+itemCode[gc][2]+"'";
		   				}
		 			}  
	   			} //end of gc for loop 
				//out.println("<br>"+modelArray[g]+" "+colorCode[jj][0]+" "+colorCode[jj][1]+" "+itemCodeString+" ");


				//2005.06.20 Ivy Yang 改由Data Center取得出貨統計
					//自維修系統中取得月出貨資訊   
       				//subRs=repairStat.executeQuery("select sum(PCOUNT) as shqty,PYEAR||PMONTH as yearmonth from PISSHIPCNT where PCLASS='MO' and COUNTRY='886' and trim(PMODEL)='"+modelArray[g]+"' and trim(PCOLOR)='"+colorCode[jj][0]+"' and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"' group by PYEAR||PMONTH order by PYEAR||PMONTH");	     
	   			subRs=repairStat.executeQuery("SELECT SUM(ssqty) AS shqty,ssyear,ssmonth FROM stock_ship_mon"
	   			+" WHERE ssitemno in ("+itemCodeString+")"
	   			+" AND ((ssyear="+yearMonthString[0][0]+" AND ssmonth>="+yearMonthString[0][1]+") OR (ssyear="+yearMonthString[3][0]+" AND ssmonth<="+yearMonthString[3][1]+"))" //處理跨年
	   			+" GROUP BY ssyear,ssmonth HAVING SUM(ssqty)!=0 ORDER BY ssyear,ssmonth ");
				while (subRs.next()) {
	   				//if (subRs.next()) {
					for (int i=0;i<yearMonthString.length;i++) {//取得各月之出貨數量
	         			//String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	        		 	//if (yearmonthStr.equals(subRs.getString("yearmonth"))) {
						if (subRs.getInt("ssyear")==Integer.parseInt(yearMonthString[i][0]) && subRs.getInt("ssmonth")==Integer.parseInt(yearMonthString[i][1])) {
							if (subRs.getInt("shqty")==0) {
		          				shipmentQTY[i]=subRs.getString("shqty");		   
		       				} else {
		          				if (subRs.getString("shqty").length()<3) {
			         				shipmentQTY[i]=subRs.getString("shqty");	
			      				} else {
		             				shipmentQTY[i]=df.format(Integer.parseInt(subRs.getString("shqty")));	
			  					} // end if	
				  				sumShipTTLMonth[i]=sumShipTTLMonth[i]+subRs.getInt("shqty"); 
				  				showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目
		       				} // end if			   	   
		       				break;
			   				//if (!subRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		     			} // end if
	      			}  // end of yearMonthSring for loop
       			} //end while
       			subRs.close(); 
	   			for (int ic=0;ic<sumShipTTLMonth.length;ic++) { //將數字用特定格式輸出
	      			if (sumShipTTLMonth[ic]<1000) {
			 			total_shipmentQTY[ic]=String.valueOf(sumShipTTLMonth[ic]);	
		  			} else {
		     			total_shipmentQTY[ic]=df.format(sumShipTTLMonth[ic]);	
	      			}	
	   			} // end for
	   
	   //取得BPCS中一週內每日之出貨資訊
	   //2005.06.20 Ivy Yang 改由Data Center取得
	   //String sqlTpeShip="select sum(ILQTY) as qty,SIINVD from SIH h,SIL l "
	   //+" where h.SIINVD between '"+dateStringArray[0]+"' and '"+dateStringArray[6]+"' "   
       //+" and h.SICUST=l.ILCUST and h.SIORD=l.ILORD and h.IHODYR=l.ILODYR and h.IHODPX=l.ILODPX and h.SIINVN=l.ILINVN  " 
       //+" and h.SFRES not in('REPAI') and (h.SICTYP not in ('12','13') or h.SICUST  in('210040')) "             
       //+" and l.ILPROD in ("+itemCodeString+") group by SIINVD order by SIINVD";
      String sqlTpeShip="SELECT sum(dqty) AS qty, ddate AS siinvd "
	  +" FROM stock_ship_day "
	  +" WHERE ddate between "+dateStringArray[0]+" and "+dateStringArray[6]
	  +" AND ditemno in ("+itemCodeString+")"
	  +" GROUP BY ddate ORDER BY ddate ";
	  //out.println(sqlTpeShip);
	  rsTpeShip=stateTpeShip.executeQuery(sqlTpeShip);
	  //if (rsTpeShip.next()) {
	  while (rsTpeShip.next()) {
		  for (int i=0;i<dateStringArray.length;i++) {//取得一週內每天之出貨數量
	         String dateStr=dateStringArray[i]; //out.println(dateStr+rsTpeShip.getString("SIINVD"));
	         if (dateStr.equals(rsTpeShip.getString("SIINVD"))) {
		       if (rsTpeShip.getString("qty").equals("0") ) {
		          shipmentQTY_day[i]=rsTpeShip.getString("qty");		   
		       } else {
		          if (rsTpeShip.getInt("qty")<1000) {
			         shipmentQTY_day[i]=String.valueOf(rsTpeShip.getInt("qty"));	
			      } else {
		             shipmentQTY_day[i]=df.format(rsTpeShip.getInt("qty"));	
			      }	
				  sumShipTTLDay[i]=sumShipTTLDay[i]+rsTpeShip.getInt("qty"); 
				  showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目 
		       }			   	   
		       //if (!rsTpeShip.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		     }
	      }  // end of yearMonthSring for loop
       } //enf of while
       rsTpeShip.close();
	   for (int ic=0;ic<sumShipTTLDay.length;ic++) //將數字用特定格式輸出
	   {
	      if (sumShipTTLDay[ic]<1000) {
			 total_shipmentQTY_day[ic]=String.valueOf(sumShipTTLDay[ic]);	
		  } else {
		     total_shipmentQTY_day[ic]=df.format(sumShipTTLDay[ic]);	
	      }	
	   } 
	   
	    //取得月份之銷售預測數字
		String fcSql="select f.FMQTY,f.FMYEAR||f.FMMONTH as yearmonth from PSALES_FORE_MONTH f"+
		             " where f.FMTYPE='001' and f.FMCOUN=886 and f.FMCOLOR='"+colorCode[jj][1]+"' and f.FMPRJCD='"+modelArray[g]+"'"+
					 " and f.FMYEAR||f.FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[3][0]+yearMonthString[3][1]+"'"+
					 " and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)"+
					 " order by f.FMYEAR||f.FMMONTH";
	    //out.println(fcSql);
		rs=statement.executeQuery(fcSql);		
		
        if (rs.next())  
        {
           for (int i=0;i<yearMonthString.length;i++) //取得各月之sales forecast數量
           {	     
	          String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	          if (yearmonthStr.equals(rs.getString("yearmonth")))
		      {		   
		        if (rs.getString("FMQTY").equals("0") )
		        {
		           forecastQTY[i]=rs.getString("FMQTY");	  				   
		        } else {		    
		           forecastQTY[i]=df.format(Math.round(Float.parseFloat(rs.getString("FMQTY"))*1000));//因為單位是K所以必須乘以1000			  	 
				   sumForecastTTLMonth[i]=sumForecastTTLMonth[i]+(Math.round(Float.parseFloat(rs.getString("FMQTY"))*1000)); 
				   showThisRow="Y"; //若有資料則準備SHOW出此ITEM項目				   
		        }
		        if (!rs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		      }
	       }  // end of yearMonthSring for loop
        } //enf of subRs.next if
        rs.close();  
		for (int ic=0;ic<sumForecastTTLMonth.length;ic++) //將數字用特定格式輸出
	    {
	      if (sumForecastTTLMonth[ic]<1000)
		  {
			 total_forecastQTY[ic]=String.valueOf(sumForecastTTLMonth[ic]);	
		  } else {
		     total_forecastQTY[ic]=df.format(sumForecastTTLMonth[ic]);	
	      }	
	    } 
		
		if (showThisRow.equals("Y") ) //若有月出貨/日出貨/銷售預測資料則準備SHOW出此ITEM項目
		{
%>
  <tr>
    <td rowspan="2"><%=colorCode[jj][0]%></td>
    <td><font size=2>出貨</font></td>
    <td><div align="right"><font size="2" face="Arial"><%=shipmentQTY[0]%></font></div></td>
    <td><div align="right"><font size="2" face="Arial"><%=shipmentQTY[1]%></font></div></td>
    <td><div align="right"><font size="2" face="Arial"><%=shipmentQTY[2]%></font></div></td>
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
    <td><font color="#CC0066" size='2' face='Arial'>銷售預測</font></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[0]%></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[1]%></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[2]%></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><%=forecastQTY[3]%></font></div></td>
    </tr>
<%     
    } // end of itemCode array for loop  
  } //end of showThisRow="Y" if                  
%>
  <tr>
    <td rowspan="2"><font color='#000000' size='2' face='Arial'><strong>合計</strong></font></td>
    <td><font size=2><strong>出貨</strong></font></td>
    <td><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[0]%></strong></font></div></td>
    <td><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[1]%></strong></font></div></td>
    <td><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[2]%></strong></font></div></td>
    <td><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY[3]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[0]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[1]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[2]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[3]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[4]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[5]%></strong></font></div></td>
    <td rowspan="2"><div align="right"><font size="2" face="Arial"><strong><%=total_shipmentQTY_day[6]%></strong></font></div></td>
  </tr>
  <tr>
    <td><font color="#CC0066" size='2' face='Arial'><strong>銷售預測</strong></font></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[0]%></strong></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[1]%></strong></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[2]%></strong></font></div></td>
    <td><div align="right"><font color="#CC0066" size="2" face="Arial"><strong><%=total_forecastQTY[3]%></strong></font></div></td>
    </tr>
<%
  		} // end of if itemCode
	} //end of main for loop modelArray
	stateTpeShip.close();
	statement.close();	
	repairStat.close();
} catch (Exception ee) {out.println("Exception:"+ee.getMessage());
	%><%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%><%
} //end of try                  

%>
</table>
<BR>
</form>
</body>
</html>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
