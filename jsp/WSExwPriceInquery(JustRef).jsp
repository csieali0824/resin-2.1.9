<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ArrayComboBoxBean,ComboBoxBean,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{ 
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
<title>Monthly Exworks Price Inquery</title>
</head>
<body>
<FORM ACTION="WSExwPriceInquery(JustRef).jsp" METHOD="post" NAME="MYFORM">
<%   
String vYear=request.getParameter("VYEAR");
if (vYear==null) vYear=dateBean.getYearString();
String vMonth=request.getParameter("VMONTH");
if (vMonth==null) vMonth=dateBean.getMonthString();
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
String model=request.getParameter("MODEL");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");   
String curr="RMB";  
String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="12%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black"><strong>Year</strong></font>
        <%    	      		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (vYear==null)
		  {		    
		    arrayComboBoxBean.setSelection(dateBean.getYearString());
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vYear);
		  }
	      arrayComboBoxBean.setFieldName("VYEAR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %>
        <font color="#330099" face="Arial Black"><strong></strong></font><font color="#330099" size="2" face="Arial Black">&nbsp;</font> </td> 
      <td width="12%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" size="2" face="Arial Black"></font><font color="#330099" face="Arial Black"><strong>Month</strong></font>
          <%		       		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (vMonth==null)
		  {		    
		    arrayComboBoxBean.setSelection(dateBean.getMonthString());			
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vMonth);
		  }
	      arrayComboBoxBean.setFieldName("VMONTH");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> 
      </td>
      <td width="17%"><font color="#333399" size="2" face="Arial Black"><strong>Region: 
            <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select Unique REGION as x , REGION from WSREGION";		  
		  sWhere = " order by x";		 
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSExwPriceInquery(JustRef).jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
            if (s1.equals(region)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
           } //end of while
           out.println("</select>"); 	  		  		  
        
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
</strong></font>        
      </td>
      <td width="26%"><font size="2"><font color="#333399" face="Arial Black"><strong>Country:
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where REGION='"+region+"' and x.LOCALE=y.LOCALE  order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 
		  if (country!=null) comboBoxBean.setSelection(country);
	      comboBoxBean.setFieldName("COUNTRY");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </strong></font></font></td>
      <td width="24%">
        <font color="#330099" face="Arial Black"><strong>Model</strong></font><font size="2">
        <%	    	     		 		 
	     try
         {		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		  		             		 
		  sSqlC = "select trim(INTER_MODEL) as x,trim(INTER_MODEL) from PSALES_PROD_CENTER ";		  
		  sWhereC= "where INTER_MODEL IS NOT NULL order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if ( model!=null && !model.equals("--"))  comboBoxBean.setSelection(model);		  		  		  
	      comboBoxBean.setFieldName("MODEL");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td width="9%"><font size="2"> <font color="#333399" face="Arial Black"><strong>	   </strong></font>
        <INPUT TYPE="submit"  value="Inquery">
	  </font></td>     
  </tr>
</table>
<font color="#54A7A7" face="Times New Roman" size="5"><STRONG>DBTEL</font><font color="#000000" size="5" face="Times New Roman"> <strong>Ship-out
 Price Inquery</strong></font>
 <font color="#000000" size="+2" face="Times New Roman"><strong> </strong></font> &nbsp; &nbsp; &nbsp; &nbsp;<A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSExwPriCogsEntry.jsp">Entry
Ship-Out Price/COGs</A> 
<%  
out.println("<BR><font color='#330099' face='Times New Roman' size='4'><strong>This Month is :"+thisDateBean.getYearString()+"/"+thisDateBean.getMonthString()+"&nbsp;&nbsp;&nbsp;&nbsp;Currency:"+curr+"</strong></font>");
try 
{  
  dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<BR>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="6%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Int. Model</font></strong></td>
	  <td width="6%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Ext. Model</font></strong></td>
	  <td width="10%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Country</font></strong></td>
	  <td width="8%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Region</font></strong></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font face="Times New Roman">
          <%
		ymh1=dateBean.getYearString()+"/"+dateBean.getMonthString();
		out.println(ymh1);
		%>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font face="Times New Roman">
	    <%dateBean.setAdjMonth(1);
	  ymh2=dateBean.getYearString()+"/"+dateBean.getMonthString();
	  out.println(ymh2);
	  %>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh3=dateBean.getYearString()+"/"+dateBean.getMonthString();
	    out.println(ymh3);
	  %>
      </font></strong></div></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh4=dateBean.getYearString()+"/"+dateBean.getMonthString();
	  out.println(ymh4);
	  %>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh5=dateBean.getYearString()+"/"+dateBean.getMonthString();
	    out.println(ymh5);
	  %>
      </font></strong></div></td> 
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
          <%dateBean.setAdjMonth(1);
		 ymh6=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh6);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh7=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh7);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh8=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh8);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh9=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh9);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh10=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh10);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh11=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh11);
	 %>
      </font></strong></div></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh12=dateBean.getYearString()+"/"+dateBean.getMonthString();
         out.println(ymh12);
	 %>
      </font></strong></div></td>	  
    </tr>	
<%	
String interModel="";
try 
{ 
  String  countrySql="",countryWhere="",countryOrder;  
  Statement countryStmt=con.createStatement();
  countrySql="select count (*) from PSALES_COUNTRY_FACTOR,WSLOCALE";
  countryWhere=" where COUNTRY=LOCALE";
  if (region!=null && !region.equals("--")) countryWhere=countryWhere+" and REGION='"+region+"'";
  if (country!=null && !country.equals("--")) countryWhere=countryWhere+" and COUNTRY='"+country+"'"; 
  countrySql=countrySql+countryWhere; 
  ResultSet countryRs=countryStmt.executeQuery(countrySql); 
  int arrayIdx=0;
  if (countryRs.next()) 
  {
   arrayIdx=countryRs.getInt(1);      
  }   
  String countryArray[][]=new String[arrayIdx][6]; 
  countryRs.close();
  countrySql="select LOCALE_NAME,REGION,COUNTRY,EXW_ADJ,BASECOUNTRY from PSALES_COUNTRY_FACTOR,WSLOCALE";
  countryWhere=" where COUNTRY=LOCALE";
  if (region!=null && !region.equals("--")) countryWhere=countryWhere+" and REGION='"+region+"'";
  if (country!=null && !country.equals("--")) countryWhere=countryWhere+" and COUNTRY='"+country+"'";  
  countryOrder=" order by REGION,COUNTRY";
  countrySql=countrySql+countryWhere+countryOrder; 
  countryRs=countryStmt.executeQuery(countrySql); 
  int countryCount=0;  
  while (countryRs.next())
  {    
    countryArray[countryCount][0]=countryRs.getString("COUNTRY");
	countryArray[countryCount][1]=countryRs.getString("LOCALE_NAME");
	countryArray[countryCount][2]=countryRs.getString("REGION");
	countryArray[countryCount][3]=countryRs.getString("EXW_ADJ"); //EXW-PRICE Adjustment of country
	countryArray[countryCount][4]=countryRs.getString("BASECOUNTRY"); //TO GET BASECOUNTRY	
	countryCount++;
  }  
  countryRs.close();
  countryStmt.close();
  
  String sSql = "",subSql="";
  String sWhere = "",subWhere="";
  String sOrder = "",subOrder="";  
  float exw_adj=1; //EXW-PRICE Adjustment of country
  int exw_price=0; //EXW PRICE
  float brand_adj=1; //算若無出廠價時用來由零售價推算出出廠價
  int t_exw_price=0;//計算出來之出廠價
  int smallerExwPrice=0;//較小之出廠價
  int biggerExwPrice=0;
  String brand="";

  //取得基準國vat
  float vatAdj=1;
  Statement vatStmt=con.createStatement(); 
  ResultSet vatRs=vatStmt.executeQuery("select VAT from PSALES_COUNTRY_FACTOR where COUNTRY='"+countryArray[0][4]+"'");
  if (vatRs.next()) vatAdj=1+vatRs.getFloat("VAT");
  vatRs.close();
  vatStmt.close();
		  
  sSql = "select trim(INTER_MODEL) as INTERMODEL,EXT_MODEL,BRAND_ADJ,x.BRAND from PSALES_PROD_CENTER x,PIBRAND y";
  sWhere = " where x.BRAND=y.BRAND";
  if (model!=null && !model.equals("--")) sWhere = sWhere+" and trim(INTER_MODEL)='"+model+"'";	  
  sOrder = " order by x.BRAND,INTERMODEL";		 
  sSql = sSql+sWhere+sOrder;		
 		  		      
  Statement statement=con.createStatement();  
  ResultSet rs=statement.executeQuery(sSql); 
  Statement subStmt=con.createStatement();	  
  ResultSet subRs=null;  
  
  while (rs.next())
  {         
   out.println("<TR>"); 
   interModel=rs.getString("INTERMODEL");
   brand_adj=rs.getFloat("BRAND_ADJ"); 
   brand=rs.getString("BRAND");  
   if (brand.equals("DBTEL")) 
   {
    out.println("<TD><font face='Times New Roman'>"+interModel+"</font></TD>"); 
    out.println("<TD><font face='Times New Roman'>"+rs.getString("EXT_MODEL")+"</font></TD>");   
   } else {
    out.println("<TD BGCOLOR=FFE4E1><font face='Times New Roman'>"+interModel+"</font></TD>"); 
    out.println("<TD BGCOLOR=FFE4E1><font face='Times New Roman'>"+rs.getString("EXT_MODEL")+"</font></TD>"); 
   }   
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	  	 	   
	  out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][1]+"</FONT></TD></TR>");	  	  		  
	} //end of countryArray for	
	out.println("</TABLE></TD>");
	
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	  	 	   
	  out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][2]+"</FONT></TD></TR>");	  	  		  
	} //end of countryArray for	
	out.println("</TABLE></TD>");
	
	for (int cac=0;cac<countryArray.length;cac++)
	{	
   	 countryArray[cac][5]="9999999"; //此為前一個月的出廠價,初始值設為極大值
	} //end of countryArray for	
	
     //FIRST MONTH   
     subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 //subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[cac][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh1.substring(0,4)+"' and FPMONTH='"+ymh1.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh1.substring(0,4)+"' and FPMONTH='"+ymh1.substring(5,7)+"' order by FPMVER DESC"; 
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh1.substring(0,4)+"' and FPMONTH='"+ymh1.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
   out.println("<TD><TABLE border=0>"); 
   for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	   countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用	   
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 } 
	} //end of countryArray for						
	out.println("</TABLE></TD>");
	
	//SECOND MONTH
	 subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh2.substring(0,4)+"' and FPMONTH='"+ymh2.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {
	   exw_price=subRs.getInt("FPEXWPRI");  	     	   
	 } else {
       exw_price=0;	   
	 }		
	 subRs.close();   	  		  
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh2.substring(0,4)+"' and FPMONTH='"+ymh2.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}	
	out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }  
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
	
	//THIRD MONTH
	 subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh3.substring(0,4)+"' and FPMONTH='"+ymh3.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh3.substring(0,4)+"' and FPMONTH='"+ymh3.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'2>--</FONT></TD></TR>");
	 }  	  		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");	
	
	//FOURTH MONTH
	 subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh4.substring(0,4)+"' and FPMONTH='"+ymh4.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh4.substring(0,4)+"' and FPMONTH='"+ymh4.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
	out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 } 
	} //end of countryArray for						
	out.println("</TABLE></TD>");
    
	//FIFTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh5.substring(0,4)+"' and FPMONTH='"+ymh5.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh5.substring(0,4)+"' and FPMONTH='"+ymh5.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
	out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }   		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");

    //SIXTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh6.substring(0,4)+"' and FPMONTH='"+ymh6.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh6.substring(0,4)+"' and FPMONTH='"+ymh6.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 } 	  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
    
	//SEVENTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh7.substring(0,4)+"' and FPMONTH='"+ymh7.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh7.substring(0,4)+"' and FPMONTH='"+ymh7.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }   	  		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
	
	//EIGHTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh8.substring(0,4)+"' and FPMONTH='"+ymh8.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh8.substring(0,4)+"' and FPMONTH='"+ymh8.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }   		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");

    //NIGHTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh9.substring(0,4)+"' and FPMONTH='"+ymh9.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh9.substring(0,4)+"' and FPMONTH='"+ymh9.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }  	  		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
	
	//TENTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh10.substring(0,4)+"' and FPMONTH='"+ymh10.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh10.substring(0,4)+"' and FPMONTH='"+ymh10.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	  if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }  		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");

    //ELEVENTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh11.substring(0,4)+"' and FPMONTH='"+ymh11.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh11.substring(0,4)+"' and FPMONTH='"+ymh11.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }   		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
  
    //TWENTH MONTH
	subSql="select FPEXWPRI from PSALES_FORE_EXWPRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh12.substring(0,4)+"' and FPMONTH='"+ymh12.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;
     subRs=subStmt.executeQuery(subSql);	   
	 if (subRs.next())
	 {	   
	   exw_price=subRs.getInt("FPEXWPRI");	  	      	   	   
	 } else {
	   exw_price=0;
	 }		
	 subRs.close(); 
	 
	 //============取得零售價===========================================
	 subSql="select FPPRI from PSALES_FORE_PRICE"; 
	 subWhere=" where FPCURR='"+curr+"' and FPCOUN='"+countryArray[0][4]+"' and FPPRJCD='"+interModel+"' and FPYEAR='"+ymh12.substring(0,4)+"' and FPMONTH='"+ymh12.substring(5,7)+"' order by FPMVER DESC"; 	 	
	 subSql=subSql+subWhere;  	
	 subRs=subStmt.executeQuery(subSql);
	 if (subRs.next()) { t_exw_price=Math.round((subRs.getInt("FPPRI")/vatAdj)*brand_adj); } else { t_exw_price=0;}		
	 subRs.close(); 	 
	 //=========================================================  
	 smallerExwPrice=Math.min(exw_price,t_exw_price);		  
	 biggerExwPrice=Math.max(exw_price,t_exw_price);
	 if (smallerExwPrice>0) { exw_price=smallerExwPrice;} else { exw_price=biggerExwPrice;}
    out.println("<TD><TABLE border=0>");
    for (int cac=0;cac<countryArray.length;cac++)
	{	
	 exw_adj=Float.parseFloat(countryArray[cac][3]);
	 
	 if (exw_price>0)
	 {
	   if (Integer.parseInt(countryArray[cac][5])>=Math.round(exw_price*exw_adj)) 
	   {
	      out.println("<TR><TD><FONT face='Times New Roman'>"+Math.round(exw_price*exw_adj)+"</FONT></TD></TR>");
	      countryArray[cac][5]=String.valueOf(Math.round(exw_price*exw_adj)); //設當月值做為下一個月之計算用
	   } else {out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][5]+"</FONT></TD></TR>");  }
	 } else {  
	  out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	 }   		  
	} //end of countryArray for						
	out.println("</TABLE></TD>");
			  
    out.println("</TR>"); //main table end	
  } //end of rs.next While     
  rs.close();   
  subStmt.close();
  statement.close();
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}   
%>  
</TABLE> 
<BR>	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
