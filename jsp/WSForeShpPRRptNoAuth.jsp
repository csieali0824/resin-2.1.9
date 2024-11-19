<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,java.text.DecimalFormat" %>
<!--=============To get the Authentication==========-->
<!-- include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnREPAIRPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
</script>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Forecast/Shipment/Purchase Requirement Report </title>
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
<FORM ACTION="../jsp/WSForeShpPRRptNoAuth.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#000000" size="+2" face="Arial Black"><span class="style15"><font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font></span></font></font></font></font><strong><font color="#000000" size="+2" face="Times New Roman"> 
Forecast/Shipment/Purchase Requirement </font></strong><font color="#000000" size="+2" face="Times New Roman"><strong> 
</strong>Consolidate Report</font> 
<%    
  String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
  String v_country=request.getParameter("COUNTRY");
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");   
  String v_modelNo=request.getParameter("MODELNO");   
  String yearMonthString[][]=new String[6][2]; //做為存入year及month陣列  
 
  if (YearFr==null || YearFr.equals(""))
  {YearFr=dateBean.getYearString();}
  if (MonthFr==null || MonthFr.equals(""))
  {MonthFr=dateBean.getMonthString();}  
  adjDateBean.setDate(Integer.parseInt(YearFr),Integer.parseInt(MonthFr),1);
  
  String dateYearCurr = dateBean.getYearString();
  String dateMonCurr = dateBean.getMonthString();     
  String fmPrjCode = "";  	
    
  Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  Statement subStat=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  ResultSet subRs=null;
  ResultSet rs=null;
  //Statement repairStat=conREPAIR.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);  
  Statement repairStat=dmcon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
  DecimalFormat df=new DecimalFormat(",000"); //做為輸出數字時有,的輸出物件
 %>
<table width="100%" border="0">
    <tr bgcolor="#99CCCC"> 
      <td width="30%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>Region
          <% 
		 String REGION="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";		  
		 
		  sSql = "select DISTINCT REGION as REGION,  REGION from WSADMIN.WSREGION ";
		  sWhere = "where REGION >'0' ";
		  sSql = sSql+sWhere;
		  //out.println(sSql);		      
         
          rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(regionNo);
	      comboBoxAllBean.setFieldName("REGION");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
            regionNo= rs.getString("REGION");		    
		  }
          rs.close();   		 		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font>      </td>
      <td width="52%"><font color="#333399" face="Arial Black"><strong>Country
        <% 
		 String COUNTRY="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select LOCALE, LOCALE_ENG_NAME||'('||LOCALE_NAME||')' from WSLOCALE ";		  
		  sWhere = "where LOCALE IS NOT  NULL order by LOCALE_ENG_NAME ";		                 		 
		  sSql = sSql+sWhere;		  
		                 
          rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(v_country);
	      comboBoxAllBean.setFieldName("COUNTRY");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          v_country= rs.getString("LOCALE");
		  }
          rs.close();   		 		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font>        </td>
      <td width="18%">&nbsp; </td>     
  </tr>
    <tr bgcolor="#99CCCC"> 
      <td><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
      <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
		  arrayComboBoxBean.setNoNull("Y");
          arrayComboBoxBean.setArrayString(a);		  
   	      arrayComboBoxBean.setSelection(YearFr);		  
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %> &nbsp;&nbsp;<font color="#330099" face="Arial Black"><strong>Month</strong></font>
      <%
		 String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
		  arrayComboBoxBean.setNoNull("Y");
          arrayComboBoxBean.setArrayString(b);		
  	      arrayComboBoxBean.setSelection(MonthFr);		 
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %></td>
      <td><font color="#333399" face="Arial Black"><strong>Model</strong></font>
        <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";		  
		  
		  sSql = "select trim(INTER_MODEL) as MODEL,trim(INTER_MODEL)||'('||trim(EXT_MODEL)||')' from PSALES_PROD_CENTER ";		  
		  sWhere= "where INTER_MODEL IS NOT NULL order by MODEL";			                 		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		               
          rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(v_modelNo);
	      comboBoxAllBean.setFieldName("MODELNO");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          v_modelNo= rs.getString("MODEL");
		  }
          rs.close();     		  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td><font color="#333399" face="Arial Black">&nbsp; </font>      <input name="submit1" type="submit" value="Inquiry"></td>
    </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>
      <td width="7%" nowrap><span class="style19">地區</span></td>
      <td width="11%" nowrap><span class="style19">國家</span></td>
	  <td width="7%" nowrap><span class="style19">機種</span></td>
      <td width="6%" nowrap><span class="style19">顏色</span></td>
	  <td width="8%"><span class="style19">項目</span></td>
	
      <td width="7%" colspan="1"><div align="center" class="style16 style20">
        <% 	  
	     out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
 	      yearMonthString[0][0] = adjDateBean.getYearString();yearMonthString[0][1]= adjDateBean.getMonthString();%>
      </div></td> 
	  <td width="7%" colspan="1"><div align="center" class="style19">
	    <% adjDateBean.setAdjMonth(1);
        out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
		  yearMonthString[1][0] = adjDateBean.getYearString();yearMonthString[1][1]= adjDateBean.getMonthString();%>
	  </div></td> 
	  <td width="7%" colspan="1"><div align="center" class="style19">
	    <% adjDateBean.setAdjMonth(1);
        out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
		  yearMonthString[2][0] = adjDateBean.getYearString();yearMonthString[2][1]= adjDateBean.getMonthString();%>
	  </div></td>
	  <td width="7%" colspan="1"><div align="center" class="style19">
	    <% adjDateBean.setAdjMonth(1);
        out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
	      yearMonthString[3][0] = adjDateBean.getYearString();yearMonthString[3][1]= adjDateBean.getMonthString();%>
	  </div></td> 
	  <td width="7%" colspan="1"><div align="center" class="style19">
	    <% adjDateBean.setAdjMonth(1);
        out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
 	      yearMonthString[4][0] = adjDateBean.getYearString();yearMonthString[4][1]= adjDateBean.getMonthString();%>
	  </div></td> 
	  <td width="7%" colspan="1"><div align="center" class="style19">
	    <% adjDateBean.setAdjMonth(1);
        out.println("<strong>"+adjDateBean.getYearString()+"/"+adjDateBean.getMonthString()+"</strong>");
	      yearMonthString[5][0] = adjDateBean.getYearString();yearMonthString[5][1]= adjDateBean.getMonthString();%>
	  </div></td>  
    </tr>
<%
try {
  String regionString=null;
  String countryString=null; 
  String countrySQL=null; 
  if (regionNo!=null && !regionNo.equals("--")) { //若有選擇REGION,則只取出有隸屬該REGION的國家
    regionString="'"+regionNo+"'";
	countrySQL="select trim(LOCALE) from WSREGION where REGION='"+regionNo+"'";
  } else {
     rs=statement.executeQuery("select unique trim(FMREG) from PSALES_FORE_MONTH");
	 while (rs.next()) {
	    if (regionString==null) {
          regionString="'"+rs.getString(1)+"'";	   
	    } else {
	      regionString=regionString+",'"+rs.getString(1)+"'";	
	    } //end of if->regionString==null
	 } //end of while->rs.next()
	 rs.close();
	 countrySQL="select trim(LOCALE) from WSREGION where REGION in ("+regionString+")";
  } //end of if->regionNo!=null   
   rs=statement.executeQuery(countrySQL);
   while (rs.next())
   {	
	  if (countryString==null)
	  {
        countryString="'"+rs.getString(1)+"'";	   
	  } else {
	    countryString=countryString+",'"+rs.getString(1)+"'";	
	  } //end of if->countryString==null
   } //end of while->rs.next()
   rs.close();  
  
  
  //取得期間內有做forecast之所有機種
  String modelString=null;
  //String modelSQL="select unique FMPRJCD||FMCOLOR from PSALES_FORE_MONTH f where FMYEAR||FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' and FMTYPE='001' and FMQTY>'0' and FMVER in (select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)";
  String modelSQL="select unique FMPRJCD from PSALES_FORE_MONTH f where FMYEAR||FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' and FMTYPE='001' and FMQTY>'0' and FMVER in (select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR)";
  if (v_country!=null && !v_country.equals("--")) 
  {
     modelSQL=modelSQL+" and FMCOUN='"+v_country+"'";	  
  } //end of if->v_country!=null
  if (regionNo!=null && !regionNo.equals("--")) //若有選擇REGION,則只取出有隸屬該REGION的國家
  {
    modelSQL=modelSQL+" and FMCOUN in ("+countryString+")";    
  }   
     rs=statement.executeQuery(modelSQL);
     while (rs.next())
	 {
	    if (modelString==null)
	    {
          modelString="'"+rs.getString(1)+"'";	   
	    } else {
	      modelString=modelString+",'"+rs.getString(1)+"'";	
	    } //end of if->modelString==null
	 } //end of while->rs.next()
	 rs.close(); 
  
    
  //取得期間內有出貨之機種
  //2005.06.20 Ivy Yang 改由Data Center取出貨資料
  String shipString=null;
  //String shipSQL="select unique PMODEL||PCOLOR from PISSHIPCNT where PCLASS='MO' and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"'";
  String shipSQL="SELECT DISTINCT trim(ssmodelno)||trim(mcolor) FROM dmadmin.stock_ship_mon a,wsadmin.prodmodel b "
  +" WHERE a.ssitemno=b.mitem "
  +" AND ((ssyear="+yearMonthString[0][0]+" and ssmonth>="+yearMonthString[0][1]+") OR (ssyear="+yearMonthString[5][0]+" and ssmonth<="+yearMonthString[5][1]+"))"; //跨年的處理
  if (v_country!=null && !v_country.equals("--")) {
     //shipSQL=shipSQL+" and COUNTRY='"+v_country+"'";
	 shipSQL=shipSQL+" and b.mCOUNTRY='"+v_country+"'";
  } //end of if->v_country!=null
  if (regionNo!=null && !regionNo.equals("--")) {//若有選擇REGION,則只取出有隸屬該REGION的國家
    //shipSQL=shipSQL+" and COUNTRY in ("+countryString+")";
	shipSQL=shipSQL+" and b.mCOUNTRY in ("+countryString+")";
  }   
     shipSQL=shipSQL+" group by ssmodelno,mcolor having sum(ssqty)!=0";
	 //out.println(shipSQL);
	 subRs=repairStat.executeQuery(shipSQL);
     while (subRs.next())
	 {
	    if (shipString==null) {
          shipString="'"+subRs.getString(1)+"'";	
	    } else {
	      shipString=shipString+",'"+subRs.getString(1)+"'";	
	    } //end of if->shipString==null
	 } //end of while->subRs.next()
	 subRs.close(); 
	 //out.println(shipString);
  
  //取得期間內有做購料需求且核准之所有機種
  String prString=null;
  //String prSQL="select unique PRJCD||COLOR from PSALES_FORE_APP_LN l,PSALES_FORE_APP_HD h where l.DOCNO=h.DOCNO and h.CANCEL!='Y' and h.APPROVED='Y' and h.RQYEAR||h.RQMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' and h.TYPE='001'";
  String prSQL="select unique PRJCD from PSALES_FORE_APP_LN l,PSALES_FORE_APP_HD h where l.DOCNO=h.DOCNO and h.CANCEL!='Y' and h.APPROVED='Y' and h.RQYEAR||h.RQMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' and h.TYPE='001'";
  if (v_country!=null && !v_country.equals("--")) 
  {
     prSQL=prSQL+" and h.COUNTRY='"+v_country+"'";	  
  } //end of if->v_country!=null
  if (regionNo!=null && !regionNo.equals("--")) //若有選擇REGION,則只取出有隸屬該REGION的國家
  {
    prSQL=prSQL+" and h.COUNTRY in ("+countryString+")";    
  }   
     rs=statement.executeQuery(prSQL);
     while (rs.next())
	 {
	    if (prString==null)
	    {
          prString="'"+rs.getString(1)+"'";	   
	    } else {
	      prString=prString+",'"+rs.getString(1)+"'";	
	    } //end of if->prString==null
	 } //end of while->rs.next()
	 rs.close(); 
  
  String sSql = "";
  String sWhere = "";	
  String sOrder="";  
  sSql = "select unique MPROJ,FMCOLOR,c.COLORDESC,MCOUNTRY,l.LOCALE_ENG_NAME,r.REGION from PRODMODEL a,PSALES_FORE_MONTH b,WSLOCALE l,PICOLOR_MASTER c,WSREGION r";		  
  sWhere= " where a.MCOUNTRY=l.LOCALE and a.MPROJ=b.FMPRJCD and a.MCOUNTRY=r.LOCALE and r.REGION in ("+regionString+") and b.FMCOLOR=c.COLORCODE"+          			                 		 
		  " and (MPROJ in ("+modelString+") or trim(MPROJ)||trim(MCOLOR) in ("+shipString+") or MPROJ in ("+prString+") )";			
  if (regionNo!=null && !regionNo.equals("--")) //若有選擇REGION,則只取出有隸屬該REGION的國家
  {
    sWhere=sWhere+" and MCOUNTRY in (select trim(LOCALE) from WSREGION where REGION='"+regionNo+"')";
  }   
  if (v_country!=null && !v_country.equals("--"))
  {
    sWhere=sWhere+" and MCOUNTRY='"+v_country+"'";
  }  
  if (v_modelNo!=null && !v_modelNo.equals("--"))
  {
    sWhere=sWhere+" and MPROJ='"+v_modelNo+"'";
  }
  sOrder=" order by REGION,LOCALE_ENG_NAME,MPROJ";
  
  sSql = sSql+sWhere+sOrder;  
  rs=statement.executeQuery(sSql);  
  
  while (rs.next())  //main while loop
  {
    String forecastQTY[]={"-","-","-","-","-","-"}; //做為存入sales各月數量之陣列 
    String shipmentQTY[]={"-","-","-","-","-","-"}; //做為存入shipment各月數量之陣列 
    String prQTY[]={"-","-","-","-","-","-"}; //做為存入購料需求各月數量之陣列 
  
   String designhouse="",platform="",region="",country="",countryNo="",modelNo="",color="",colorCode="",fcType="";  
      
   region=rs.getString("REGION");
   country=rs.getString("LOCALE_ENG_NAME");
   countryNo=rs.getString("MCOUNTRY");
   modelNo=rs.getString("MPROJ");
   color=rs.getString("COLORDESC");
   colorCode=rs.getString("FMCOLOR");     
   
   subRs=subStat.executeQuery("select f.FMQTY,f.FMYEAR||f.FMMONTH as yearmonth from PSALES_FORE_MONTH f "
   +" where f.FMCOUN="+countryNo+" and f.FMCOLOR='"+colorCode+"' and f.FMPRJCD='"+modelNo+"' and f.FMYEAR||f.FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' and f.FMVER=(select max(FMVER) from PSALES_FORE_MONTH where FMYEAR=f.FMYEAR and FMMONTH=f.FMMONTH and FMCOUN=f.FMCOUN and FMTYPE=f.FMTYPE and FMPRJCD=f.FMPRJCD and FMCOLOR=f.FMCOLOR) and f.FMTYPE='001' order by f.FMYEAR||f.FMMONTH"); //FMTYPE=001表示為SALES	     
   if (subRs.next())  
   {
      for (int i=0;i<yearMonthString.length;i++) //取得各月之sales forecast數量
      {
	     
	     String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	     if (yearmonthStr.equals(subRs.getString("yearmonth")))
		 {		   
		   if (subRs.getString("FMQTY").equals("0") )
		   {
		      forecastQTY[i]=subRs.getString("FMQTY");		   
		   } else {		    
		      forecastQTY[i]=df.format(Math.round(Float.parseFloat(subRs.getString("FMQTY"))*1000));//因為單位是K所以必須乘以1000			  	 
		   }
		   if (!subRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		 }
	  }  // end of yearMonthSring for loop
   } //enf of subRs.next if
   subRs.close();   
   
   //取得已核准之購料需求   
   subRs=subStat.executeQuery("select sum(l.RQQTY) as rqqty,h.RQYEAR||h.RQMONTH as yearmonth "
   +" from PSALES_FORE_APP_LN l,PSALES_FORE_APP_HD h "
   +" where l.DOCNO=h.DOCNO and h.CANCEL!='Y' and h.APPROVED='Y' "
   +" and h.RQYEAR||h.RQMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]+"' "
   +" and h.COUNTRY="+countryNo+" and h.TYPE='001' and l.PRJCD='"+modelNo+"' and l.COLOR='"+color+"' "
   +" group by h.RQYEAR||h.RQMONTH order by h.RQYEAR||h.RQMONTH");	     
   if (subRs.next())  {
      for (int i=0;i<yearMonthString.length;i++) //取得各月之購料需求數量
      {
	     
	     String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	     if (yearmonthStr.equals(subRs.getString("yearmonth")))
		 {
		   if (subRs.getString("rqqty").equals("0"))
		   {
		      prQTY[i]=subRs.getString("rqqty");		   
		   } else {
		      prQTY[i]=df.format(Math.round(Float.parseFloat(subRs.getString("rqqty"))*1000)); //因為單位是K所以必須乘以1000
		   }			   	   
		   if (!subRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		 }
	  }  // end of yearMonthSring for loop
   } //enf of subRs.next if
   subRs.close();  
   
	// 2005.06.20 Ivy Yang改自Data Center取得出貨統計
   		//自維修系統中取得出貨資訊   
   		//subRs=repairStat.executeQuery("select sum(PCOUNT) as shqty,PYEAR||PMONTH as yearmonth from PISSHIPCNT " 
		//+"where PCLASS='MO' and COUNTRY='"+countryNo+"' and PMODEL='"+modelNo+"' and PCOLOR='"+color
		//+"' and PYEAR||PMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[5][0]+yearMonthString[5][1]
		//+"' group by PYEAR||PMONTH order by PYEAR||PMONTH");	     
	sSql = "SELECT sum(a.ssqty) AS shqty,a.ssyear,a.ssmonth FROM dmadmin.stock_ship_mon a,wsadmin.prodmodel b "
  	+" WHERE a.ssitemno=b.mitem "+" AND b.mcountry='"+countryNo+"' and a.ssmodelno='"+modelNo+"' and b.mCOLOR='"+colorCode+"'"
  	+" AND ((a.ssyear="+yearMonthString[0][0]+" and a.ssmonth>="+yearMonthString[0][1]+") OR (a.ssyear="+yearMonthString[5][0]+" and a.ssmonth<="+yearMonthString[5][1]+"))" //跨年的處理;
	+" GROUP BY a.ssyear,a.ssmonth";
	//out.println(sSql);
	subRs=repairStat.executeQuery(sSql);
	if (subRs.next())  {
	  for (int i=0;i<yearMonthString.length;i++)  {
	     //String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	     //if (yearmonthStr.equals(subRs.getString("yearmonth"))) {
		 if (subRs.getInt("ssyear")==Integer.parseInt(yearMonthString[i][0]) && subRs.getInt("ssmonth")==Integer.parseInt(yearMonthString[i][1])) {
		   if (subRs.getInt("shqty")==0) {
		      shipmentQTY[i]=subRs.getString("shqty");		   
		   } else {
		      if (subRs.getString("shqty").length()<3)  {
			     shipmentQTY[i]=subRs.getString("shqty");	
			  } else {
		         shipmentQTY[i]=df.format(Integer.parseInt(subRs.getString("shqty")));	
			  }	 
		   }			   	   
		   if (!subRs.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
		 }
	  }  // end of yearMonthSring for loop
   } //enf of subRs.next if
   subRs.close(); 
%>	    
  <tr>
    <td rowspan="3" nowrap><font size="2"><%=region%>	
	   </font>	</td>
    <td rowspan="3" nowrap>
      <font size="2"><%=country%>
	  </font>	</td>
    <td rowspan="3" nowrap>
      <font size="2"><%=modelNo%>
      </font>	</td>
    <td rowspan="3"><font size="2"><%=color%>
	   </font> </td>
    <td bgcolor="#FFFFDD"><font size="2">銷售預測</font></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[0]%></font></div></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[1]%></font></div></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[2]%></font></div></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[3]%></font></div></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[4]%></font></div></td>
    <td bgcolor="#FFFFDD"><div align="right"><font size="2"><%=forecastQTY[5]%></font></div></td>
  </tr>
  <tr>
    <td><span class="style21"><font size="2">實際出貨</font></span></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[0]%></font></div></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[1]%></font></div></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[2]%></font></div></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[3]%></font></div></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[4]%></font></div></td>
    <td><div align="right" class="style21"><font size="2"><%=shipmentQTY[5]%></font></div></td>
  </tr>
  <tr>
     <td width="8%" bgcolor="#EEEEFF"><span class="style19"><font size="2">請購數量</font></span></td>
     <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[0]%></font></strong></div></td>
    <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[1]%></font></strong></div></td>
    <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[2]%></font></strong></div></td>
    <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[3]%></font></strong></div></td>
    <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[4]%></font></strong></div></td>
    <td width="7%" bgcolor="#EEEEFF"><div align="right" class="style20"><strong><font size="2"><%=prQTY[5]%></font></strong></div></td>
    </tr>  
<%
  }//end of while loop
  rs.close();
} catch (Exception ee) { out.println("Exception:"+ee.getMessage());		  
	%><%@ include file="/jsp/include/ReleaseConnPage.jsp"%><%
	%><%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%><%
}//end of try-catch
%>			
</table>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%">&nbsp;</td>
    <td width="24%">&nbsp;</td>
	<td width="24%">&nbsp;</td>
    <td width="28%">&nbsp;</td>
  </tr>
</table>
</FORM>
</body>
<%
 subStat.close();
 repairStat.close();
 statement.close();
%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnREPAIRPage.jsp"%>
</html>