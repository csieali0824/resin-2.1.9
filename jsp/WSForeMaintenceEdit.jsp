<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.util.*"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Weekly Sales Forecast Maintain</title>
</head>
<body bgcolor="#FFFFFF">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#00CC66" size="+2" face="Arial Black">DBTEL</font></font></font></font><font color="#CC0066" size="+2" face="Times New Roman"> 
<strong>Sales Forecast Weekly Maintenance</strong></font><font color="#CC0066" size="+3" face="Times New Roman"><strong> 
</strong></font> 
<FORM ACTION="../jsp/WSForecastWeekMInsert.jsp" METHOD="post">
<%
   int rs1__numRows = 7;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
%>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
  &nbsp;
<%     
String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
  String compNo=request.getParameter("COMPNO");
  String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE");
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR"); 
  String model=request.getParameter("MODEL"); 
  
  if (model=="5688 " || model.equals("5688 "))
  {model="5688+";}
  
  //String [] prjArrWkQty = "";
  int numRow = 0;
  String fmPrjCode = "";
  
  int monCurr = 0;
  int monNext =  0;
  int monNext2 = 0;
  
  if ( (MonthFr== null) || MonthFr.equals(""))
  {
  }
  else
  {
      monCurr = Integer.parseInt(MonthFr);
	  if (monCurr <= 10)
	  {
	    monNext = Integer.parseInt(MonthFr) + 1;
        monNext2 = Integer.parseInt(MonthFr) + 2; 
	  }
	  else 
	  {
	    if (monCurr == 11)
		{ monNext =12;
		  monNext2 = 1;	}
		else
		{ monNext =1;
		  monNext2 = 2;}
	  }      
  }
  
  Statement statH=con.createStatement();
  // COUNT 為此月份條件下的機型筆數
  String sqlH = "select count(*) as COUNT, FMPRJCD  from PSALES_FORE_MONTH f, PIMASTER m ";
  String sWhereH = "where m.PROJECTCODE = f.FMPRJCD " + 
                               "and f.FMCOMP =  '"+compNo+"'  " + 
                               "and f.FMREG = "+regionNo+"  "+
                               "and f.FMCOUN =  "+locale+"  " +
							   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
                               "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+monNext+"'  ";
  String sGroupH = "group by FMPRJCD order by FMPRJCD ";
  sqlH = sqlH + sWhereH + sGroupH;
  //out.println(sqlH);
  
  ResultSet rsH=statH.executeQuery(sqlH);
  
  if (rsH.next())
 {
    int cntFlag =0;
	
	cntFlag = rsH.getInt("COUNT");
	if (cntFlag>= 1)
	{
        //out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?COMPNO="+compNo+"&&REGION="+regionNo+"&&LOCALE="+locale+"&&YEARFR="+YearFr+"&&MONTHFR="+monNext2+"'>EDIT ("+monNext2+"月份)WEEK FORECAST</A>");	  
        while (rsH.next())
	   {
	      //prjArrWkQty[numRow] =  rsH.getString("FMPRJCD");
	    //  numRow = numRow + 1;
	    } 	 
    }
  //out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?"+compNo+"&&"+regionNo+"&&"+locale+"&&"+YearFr+"&&"+MonthFr+"&&'>EDIT WEEK FORECAST</A>");
  }
  rsH.close();
  statH.close();  
  
%>
  
  <table width="100%" border="1">
    <tr bgcolor="#D0FFFF"> 
      <td width="40%" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>Company Code</strong></font> 
          <% 
		 String COMPNO="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select trim(MCCOMP) as MCCOMP,  trim(MCCOMP) || '('||MCDESC||')' from WSMULTI_COMP ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhere = "where MCCOMP IS NOT NULL and trim(MCCOMP) in('01','08','28','45') and trim(MCCOMP)='"+compNo+"' ";		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(compNo);
	      comboBoxAllBean.setFieldName("COMPNO");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          compNo= rs.getString("COMPNO");
		  }
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </td>
      <td width="27%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> 
        <% 
		 String REGION="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select substr(CONTINENT,2,1) as REGION,  CONTINENT|| '('||CONTINENT_NAME||')' from WSADMIN.WSCONTINENT ";		  
		  sWhere = "where CONTINENT IS NOT  NULL ";		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(regionNo);
	      comboBoxAllBean.setFieldName("REGION");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
            regionNo= rs.getString("REGION");
		    //regionNo = regionNo.substring(1,1);
		  }
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	    </td>
      <td colspan="2"> <font color="#333399" face="Arial Black"><strong>Country</strong></font> 
        <% 
		 String COUNTRY="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select LOCALE,  LOCALE|| '(' || LOCALE_NAME||')' from WSLOCALE ";		  
		  sWhere = "where LOCALE IS NOT  NULL and LOCALE in('886','60','61','62','63','65', '66','91') and LOCALE='"+locale+"'  ";		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(locale);
	      comboBoxAllBean.setFieldName("LOCALE");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          locale= rs.getString("LOCALE");
		  }
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	 </td>     
  </tr>
    <tr bgcolor="#D0FFFF"> 
      <td><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearFr==null)
		  {
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearFr);
		  }
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %>
    </td>
      <td> <font color="#330099" face="Arial Black"><strong>Month</strong></font> 
        <%
		 String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
			//arrayComboBoxBean.setSelection(dateStrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> </td>
      <td width="17%"><font color="#333399" face="Arial Black"> <strong>Model</strong></font> 
        <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select SALESCODE as MODEL,  SALESCODE || '('||BRAND||')' from WSADMIN.PIMASTER ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhere = "where PROJECTCODE IS NOT NULL and SALESCODE = '"+model+"' ";		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(model);
	      comboBoxAllBean.setFieldName("MODEL");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
          model= rs.getString("MODEL");
		  }
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
	   </td>
	 <td width="16%"><input name="submit1" type="submit" value="Save"></td>	 
  </tr>
</table>

  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bordercolor="#000000" > 
      <td width="10%" rowspan="2"><font size="-1">機型 </font></td>
      <td colspan="2" rowspan="2" > <div align="center"> <strong><font color="#FF0000" size="-1"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monCurr);}
	  %>
          </font></strong><font size="-1"> 月份 <BR>
          預收訂單(P/O)</font></div>
      <td colspan="6" bgcolor="#CCFFFF"> <div align="center"> <strong><font color="#FF0000" size="-1"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monCurr);}
    %>
          </font></strong><font size="-1"> 月份每週出貨狀況</font></div></td>
      <td colspan="6" bgcolor="#FFFFCC"><div align="center"><strong><font color="#FF0000" size="-1"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monNext);}
         %>
          </font></strong><font size="-1">月份每週預估出貨量</font></div></td>
      <td width="9%"  bgcolor="#FFCCFF" NO WRAP > <div align="center"> <strong><font color="#FF0000" size="-1"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monNext2);}
    %>
          </font></strong><font size="-1"> 月預估出貨量</font></div></td>
    </tr>
    <tr bordercolor="#000000">             
      <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week1</font><font size="-1"><BR>
	     <!--%
		      Statement stateFWC1=con.createStatement();   		
		      try
		     {   
               String sqlFWC1 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFWC1 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWWEEK = '1' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFWC1 = sqlFWC1+ sWhereFWC1;		
		
              //out.println(sqlFW1);
              ResultSet rsFWC1=stateFWC1.executeQuery(sqlFWC1);
			  if (rsFWC1.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='hidden' name='WC1Fr' maxlength='2' size='2' value="+rsFWC1.getString("FWDATFR")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC1.getString("FWDATFR")+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='WC1To' maxlength='2' size='2' value="+rsFWC1.getString("FWDATTO")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC1.getString("FWDATTO")+"</font>");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='text' name='WC1Fr' maxlength='2' size='2' value=''>");
				 out.println("迄");
				 out.println("<input type='text' name='WC1To' maxlength='2' size='2' value=''>");
			  }	  
			  rsFWC1.close();
			  stateFWC1.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>
          <!--% 
		  起 
		  <input type="text" name="WC1Fr" maxlength="2" size="2" value="">
          迄 
          <input type="text" name="WC1To" maxlength="2" size="2"> 
		 %-->
		 <%
		     Calendar rightNow = Calendar.getInstance();
			 int DayOfWeek =  rightNow.getFirstDayOfWeek();
			 int DayOfWeek1 = rightNow.get(rightNow.DAY_OF_MONTH);
			 out.println("DayOfWeek = "+DayOfWeek);
			 out.println("DayOfWeek1 = "+DayOfWeek1);
		 
		 %>
          </font></div></td>
      <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week2</font><font size="-1"><BR>
	      <%
		      Statement stateFWC2=con.createStatement();   		
		      try
		     {   
               String sqlFWC2 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFWC2 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWWEEK = '2' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFWC2 = sqlFWC2+ sWhereFWC2;		
		
              //out.println(sqlFW1);
              ResultSet rsFWC2=stateFWC2.executeQuery(sqlFWC2);
			  if (rsFWC2.next())
			  {
			     out.println("起");			     
				 out.println("<input type='hidden' name='WC2Fr' maxlength='2' size='2' value="+rsFWC2.getString("FWDATFR")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC2.getString("FWDATFR")+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='WC2To' maxlength='2' size='2' value="+rsFWC2.getString("FWDATTO")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC2.getString("FWDATTO")+"</font>");
			  }
			  else
			  {	
			     out.println("起");
			     out.println("<input type='text' name='WC2Fr' maxlength='2' size='2' value=''><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='WC2To' maxlength='2' size='2' value=''>");
			  }	  
			  rsFWC2.close();
			  stateFWC2.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>
          <!--%起 
          <input type="text" name="WC2Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="WC2To" maxlength="2" size="2">
		  %-->
          </font></div></td>
      <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week3</font><font size="-1"><BR>
	      <%
		      Statement stateFWC3=con.createStatement();   		
		      try
		     {   
               String sqlFWC3 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFWC3 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWWEEK = '3' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFWC3 = sqlFWC3+ sWhereFWC3;		
		
              //out.println(sqlFW1);
              ResultSet rsFWC3=stateFWC3.executeQuery(sqlFWC3);
			  if (rsFWC3.next())
			  {
			     out.println("起");			     
				 out.println("<input type='hidden' name='WC3Fr' maxlength='2' size='2' value="+rsFWC3.getString("FWDATFR")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC3.getString("FWDATFR")+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='WC3To' maxlength='2' size='2' value="+rsFWC3.getString("FWDATTO")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC3.getString("FWDATTO")+"</font>");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='text' name='WC3Fr' maxlength='2' size='2' value=''><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='WC3To' maxlength='2' size='2' value=''>");
			  }	  
			  rsFWC3.close();
			  stateFWC3.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>
          <!--%
		   起 
          <input type="text" name="WC3Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="WC3To" maxlength="2" size="2">
		  %-->
          </font></div></td>
      <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week4</font><font size="-1"><BR>
	    <%
		      Statement stateFWC4=con.createStatement();   		
		      try
		     {   
               String sqlFWC4 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFWC4 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWWEEK = '4' "+
										 "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFWC4 = sqlFWC4+ sWhereFWC4;		
		
              //out.println(sqlFW1);
              ResultSet rsFWC4=stateFWC4.executeQuery(sqlFWC4);
			  if (rsFWC4.next())
			  {			     
			     out.println("起");
				 out.println("<input type='hidden' name='WC4Fr' maxlength='2' size='2' value="+rsFWC4.getString("FWDATFR")+" NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC4.getString("FWDATFR")+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='WC4To' maxlength='2' size='2' value="+rsFWC4.getString("FWDATTO")+" NO WRAP>");
         		 out.println("<font color='#3300FF' size='-1' >"+rsFWC4.getString("FWDATTO")+"</font>");
			  }
			  else
			  {	
			      out.println("起");
			     out.println("<input type='text' name='WC4Fr' maxlength='2' size='2' value=''><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='WC4To' maxlength='2' size='2' value=''>");
			  }	  
			  rsFWC4.close();
			  stateFWC4.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
	  %>
      <!--%  起 
          <input type="text" name="WC4Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="WC4To" maxlength="2" size="2">
	  %-->
          </font></div></td>
      <td width="5%" bgcolor="#CCFFFF"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week5</font><font size="-1"><BR>
	       <%
		      Statement stateFWC5=con.createStatement();   		
		      try
		     {   
               String sqlFWC5 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFWC5 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWWEEK = '5' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFWC5 = sqlFWC5+ sWhereFWC5;		
		
              //out.println(sqlFW1);
              ResultSet rsFWC5=stateFWC5.executeQuery(sqlFWC5);
			  if (rsFWC5.next())
			  { 
			     out.println("起");			     
				 out.println("<input type='hidden' name='WC5Fr' maxlength='2' size='2' value="+rsFWC5.getString("FWDATFR")+"NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC5.getString("FWDATFR")+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='WC5To' maxlength='2' size='2' value="+rsFWC5.getString("FWDATTO")+"NO WRAP>");
				 out.println("<font color='#3300FF' size='-1' >"+rsFWC5.getString("FWDATTO")+"</font>");
			  }
			  else
			  {
			      out.println("起");	
			     out.println("<input type='text' name='WC5Fr' maxlength='2' size='2' value=''><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='WC5To' maxlength='2' size='2' value=''>");
			  }	  
			  rsFWC5.close();
			  stateFWC5.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>
          <!--%
		  起 
          <input type="text" name="WC5Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="WC5To" maxlength="2" size="2">
		 %-->
          </font></div></td>
      <td width="6%" bgcolor="#CCFFFF"><div align="right"><font size="-1"><strong>Sub. TTL</strong></font></div></td>
      <td width="6%" bgcolor="#FFFFCC"> <div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week1</font><font size="-1"><BR>
          <!--%起 
          <input type="text" name="W1Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W1To" maxlength="2" size="2"> %-->
		  <%
		      Statement stateFNeW1=con.createStatement();   		
		      try
		     {   
               String sqlFNeW1 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFNeW1 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWWEEK = '1' "+
										 "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFNeW1 = sqlFNeW1+ sWhereFNeW1;		
		
              //out.println(sqlFNeW1);
              ResultSet rsFNeW1=stateFNeW1.executeQuery(sqlFNeW1);
			  if (rsFNeW1.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='text' name='W1Fr' maxlength='2' size='2' value="+rsFNeW1.getString("FWDATFR")+"><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='W1To' maxlength='2' size='2' value="+rsFNeW1.getString("FWDATTO")+">");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='hidden' name='W1Fr' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='W1To' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  }	  
			  rsFNeW1.close();
			  stateFNeW1.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>
       </font></div>
	   </td>
      <td width="5%" bgcolor="#FFFFCC"><div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week2</font><font size="-1"><BR>
       <!--%   起 
          <input type="text" name="W2Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W2To" maxlength="2" size="2"> 
	   %-->
		  <%
		      Statement stateFNeW2=con.createStatement();   		
		      try
		     {   
               String sqlFNeW2 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFNeW2 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWWEEK = '2' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFNeW2 = sqlFNeW2+ sWhereFNeW2;		
		
              //out.println(sqlFW1);
              ResultSet rsFNeW2=stateFNeW2.executeQuery(sqlFNeW2);
			  if (rsFNeW2.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='text' name='W2Fr' maxlength='2' size='2' value="+rsFNeW2.getString("FWDATFR")+"><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='W2To' maxlength='2' size='2' value="+rsFNeW2.getString("FWDATTO")+">");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='hidden' name='W2Fr' maxlength='2' size='2' value=''>");
				out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='W2To' maxlength='2' size='2' value=''>");
				out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  }	  
			  rsFNeW2.close();
			  stateFNeW2.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>  
       </font></div></td>
      <td width="6%" bgcolor="#FFFFCC"><div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week3</font><font size="-1"> 
          <BR>
          <!--% 起 
          <input type="text" name="W3Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W3To" maxlength="2" size="2"> 
		 %-->
		   <%
		      Statement stateFNeW3=con.createStatement();   		
		      try
		     {   
               String sqlFNeW3 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFNeW3 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWWEEK = '3' "+
										  "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFNeW3 = sqlFNeW3+ sWhereFNeW3;		
		
              //out.println(sqlFW1);
              ResultSet rsFNeW3=stateFNeW3.executeQuery(sqlFNeW3);
			  if (rsFNeW3.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='text' name='W3Fr' maxlength='2' size='2' value="+rsFNeW3.getString("FWDATFR")+"><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='W3To' maxlength='2' size='2' value="+rsFNeW3.getString("FWDATTO")+">");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='hidden' name='W3Fr' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='W3To' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  }	  
			  rsFNeW3.close();
			  stateFNeW3.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>   
       </font></div></td>
      <td width="5%" bgcolor="#FFFFCC"><div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week4</font><font size="-1">
          <!--% 起 
          <input type="text" name="W4Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W4To" maxlength="2" size="2"> %-->
		   <%
		      Statement stateFNeW4=con.createStatement();   		
		      try
		     {   
               String sqlFNeW4 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFNeW4 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                             "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                         "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                             "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                 "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWWEEK = '4' "+
										 "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFNeW4 = sqlFNeW4+ sWhereFNeW4;		
		
              //out.println(sqlFW1);
              ResultSet rsFNeW4=stateFNeW4.executeQuery(sqlFNeW4);
			  if (rsFNeW4.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='text' name='W4Fr' maxlength='2' size='2' value="+rsFNeW4.getString("FWDATFR")+"><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='W4To' maxlength='2' size='2' value="+rsFNeW4.getString("FWDATTO")+">");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='hidden' name='W4Fr' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
				 out.println("迄");
				 out.println("<input type='hidden' name='W4To' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  }	  
			  rsFNeW4.close();
			  stateFNeW4.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>  
		   
        </font></div></td>
      <td width="7%" bgcolor="#FFFFCC"><div align="center"><font color="#CC0066" size="-1" face="Comic Sans MS">Week5</font><font size="-1"> <BR>
          <!--% 起 
          <input type="text" name="W5Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W5To" maxlength="2" size="2"> %-->
		   <%
		      Statement stateFNeW5=con.createStatement();   		
		      try
		     {   
               String sqlFNeW5 = "select w.FWDATFR, w.FWDATTO from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		       String sWhereFNeW5 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                                         "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                                     "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                                         "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                                             "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWWEEK = '5' "+
										            "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
		       sqlFNeW5 = sqlFNeW5+ sWhereFNeW5;		
		
              //out.println(sqlFW1);
              ResultSet rsFNeW5=stateFNeW5.executeQuery(sqlFNeW5);
			  if (rsFNeW5.next())
			  {	
			     out.println("起");		     
				 out.println("<input type='text' name='W5Fr' maxlength='2' size='2' value="+rsFNeW5.getString("FWDATFR")+"><BR>");
				 out.println("迄");
				 out.println("<input type='text' name='W5To' maxlength='2' size='2' value="+rsFNeW5.getString("FWDATTO")+">");
			  }
			  else
			  {
			     out.println("起");	
			     out.println("<input type='hidden' name='W5Fr' maxlength='2' size='2' value=''>");
				out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font><BR>");
				 out.println("迄");
				 out.println("<input type='hidden' name='W5To' maxlength='2' size='2' value=''>");
				 out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  }	  
			  rsFNeW5.close();
			  stateFNeW5.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         } 
		%>	  
        </font></div></td>
      <td width="8%" bgcolor="#FFFFCC"><div align="right"><font size="-1"><strong>Sub. TTL</strong></font></div></td>
      <td width="9%" bgcolor="#FFCCFF"><div align="right"><font size="-1"><strong>Forecast</strong></font></div></td>
    </tr>
    <% //Main Loop  Start 
       //ResultSet RpRepair = StatementRpRepair.executeQuery(); 
  
        Statement statement=con.createStatement();   
		try
		{
		//先抓相同月份下的不存在週機種String Combination  //
		 /*String RCTPString = "";
		 String RCTPSGet = "";
		      int RCTPlight = 0;
		
		 String sSqlFW = "select distinct w.FWPRJCD from WSADMIN.PSALES_FORE_WEEK w where  w.FWCOMP =  '"+compNo+"'  and w.FWREG = '"+regionNo+"'  and w.FWCOUN =  '"+locale+"'  " +
		                           "and w.FWYEAR = '"+YearFr+"' and w.FWMONTH between '"+MonthFr+"'  and  '"+monNext+"'  ";
         
         ResultSet rsFW = statement.executeQuery(sSqlFW);
		 
		 while(rsFW.next())
		 {
			   RCTPString =rsFW.getString("FWPRJCD");
			   RCTPSGet = RCTPSGet+"'"+RCTPString+"'"+",";			   
		 }
		 RCTPlight=RCTPSGet.length()-1;
		 RCTPSGet = RCTPSGet.substring(0, RCTPlight);
			//out.print(RCTPSGet);  */
			
		 String prjCDDesc = null;
         String prjCDDescGet = "";
          int prjCDGetLength = 0;
   
           String sSqlFW = "select distinct w.FWPRJCD from WSADMIN.PSALES_FORE_WEEK w ";
           String sWhereFW = "where  w.FWCOMP =  '"+compNo+"'  and w.FWREG = '"+regionNo+"'  and w.FWCOUN =  '"+locale+"'  "+
                                           "and w.FWYEAR = '"+YearFr+"' and w.FWMONTH = '"+MonthFr+"'  ";          
  
           sSqlFW = sSqlFW + sWhereFW ;
  
           ResultSet rsFW=statement.executeQuery(sSqlFW);
           while (rsFW.next())
           { 
		        prjCDDesc = rsFW.getString("FWPRJCD");
	            prjCDDescGet = prjCDDescGet+"'"+prjCDDesc+"'"+",";            
            }
            prjCDGetLength = prjCDDescGet.length()-1;
            prjCDDescGet = prjCDDescGet.substring(0,prjCDGetLength);
			
		 String sql = "select 'DBTEL'|| m.SALESCODE as SALESCODE, m.PROJECTCODE,f.FMQTY "+
		                    "from PSALES_FORE_MONTH f, PIMASTER m ";
		 String sWhere = "where m.PROJECTCODE = f.FMPRJCD   "+  //  <-- 只挑月預估存在,但週預估不存在的機種 //
		                     //       "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
							//	   "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
		                     //      "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
		                           "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  ";
							//	   "and f.FMPRJCD not in("+RCTPSGet+") ";
							 //	   "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);								   
		  if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		  else { sWhere = sWhere + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		  if (compNo==null || compNo.equals("--")) {   sWhere = sWhere + "and f.FMCOMP !=  'ALL'  "; }
		  else { sWhere = sWhere + "and f.FMCOMP =  '"+compNo+"'  "; }
          if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(f.FMREG) != 'ALL'  "; }
		  else { sWhere = sWhere +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
		  if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		  else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
		  
		  if ( prjCDDescGet == null || prjCDDescGet.equals("") ){}
		  else {sWhere = sWhere + "and f.FMPRJCD not in("+prjCDDescGet+") ";}
		
		 String sOrder = "order by m.PROJECTCODE ";
		 
		 sql = sql + sWhere+sOrder;		
		 
         //out.println(sql);
         ResultSet rs=statement.executeQuery(sql);
				
		 boolean rs_isEmpty = !rs.next();
         boolean rs_hasData = !rs_isEmpty;
         Object rs_data;
		 
	     // 加入分頁-起
		 
// *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

int rs_first = 1;
int rs_last  = 1;
int rs_total = -1;


if (rs_isEmpty) {
  rs_total = rs_first = rs_last = 0;
}

//set the number of rows displayed on this page
if (rs_numRows == 0) {
  rs_numRows = 1;
}

String MM_paramName = "";

// *** Move To Record and Go To Record: declare variables

ResultSet MM_rs = rs;
int       MM_rsCount = rs_total;
int       MM_size = rs_numRows;
String    MM_uniqueCol = "";
          MM_paramName = "";
int       MM_offset = 0;
boolean   MM_atTotal = false;
boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);

// *** Move To Record: handle 'index' or 'offset' parameter

if (!MM_paramIsDefined && MM_rsCount != 0) {

  //use index parameter if defined, otherwise use offset parameter
  String r = request.getParameter("index");
  if (r==null) r = request.getParameter("offset");
  if (r!=null) MM_offset = Integer.parseInt(r);

  // if we have a record count, check if we are past the end of the recordset
  if (MM_rsCount != -1) {
    if (MM_offset >= MM_rsCount || MM_offset == -1) {  // past end or move last
      if (MM_rsCount % MM_size != 0)    // last page not a full repeat region
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  //move the cursor to the selected record
  int i;
  for (i=0; rs_hasData && (i < MM_offset || MM_offset == -1); i++) {
    rs_hasData = MM_rs.next();
  }
  if (!rs_hasData) MM_offset = i;  // set MM_offset to the last possible record
}

// *** Move To Record: if we dont know the record count, check the display range

if (MM_rsCount == -1) {

  // walk to the end of the display range for this page
  int i;
  for (i=MM_offset; rs_hasData && (MM_size < 0 || i < MM_offset + MM_size); i++) {
    rs_hasData = MM_rs.next();
  }

  // if we walked off the end of the recordset, set MM??佃?????o???_rsCount and MM_size
  if (!rs_hasData) {
    MM_rsCount = i;
    if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
  }

  // if we walked off the end, set the offset based on page size
  if (!rs_hasData && !MM_paramIsDefined) {
    if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
      if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
        MM_offset = MM_rsCount - MM_rsCount % MM_size;
      else
        MM_offset = MM_rsCount - MM_size;
    }
  }

  // reset the cursor to the beginning
  rs.close();
  //rs = Statement.executeQuery(s);
  rs=statement.executeQuery(sql);
  rs_hasData = rs.next();
  MM_rs = rs;

  // move the cursor to the selected record
  for (i=0; rs_hasData && i < MM_offset; i++) {
    rs_hasData = MM_rs.next();
  }
}

// *** Move To Record: update recordset stats

// set the first and last displayed record
rs_first = MM_offset + 1;
rs_last  = MM_offset + MM_size;
if (MM_rsCount != -1) {
  rs_first = Math.min(rs_first, MM_rsCount);
  rs_last  = Math.min(rs_last, MM_rsCount);
}

// set the boolean used by hide region to check if we are on the last record
MM_atTotal  = (MM_rsCount != -1 && MM_offset + MM_size >= MM_rsCount);
%>
<%
// *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
String[] MM_removeList = { "index", MM_paramName };

// create the MM_keepURL string
if (request.getQueryString() != null) {
  MM_keepURL = '&' + request.getQueryString();
  for (int i=0; i < MM_removeList.length && MM_removeList[i].length() != 0; i++) {
  int start = MM_keepURL.indexOf(MM_removeList[i]) - 1;
    if (start >= 0 && MM_keepURL.charAt(start) == '&' &&
        MM_keepURL.charAt(start + MM_removeList[i].length() + 1) == '=') {
      int stop = MM_keepURL.indexOf('&', start + 1);
      if (stop == -1) stop = MM_keepURL.length();
      MM_keepURL = MM_keepURL.substring(0,start) + MM_keepURL.substring(stop);
    }
  }
}

// add the Form variables to the MM_keepForm string
if (request.getParameterNames().hasMoreElements()) {
  java.util.Enumeration items = request.getParameterNames();
  while (items.hasMoreElements()) {
    String nextItem = (String)items.nextElement();
    boolean found = false;
    for (int i=0; !found && i < MM_removeList.length; i++) {
      if (MM_removeList[i].equals(nextItem)) found = true;
    }
    if (!found && MM_keepURL.indexOf('&' + nextItem + '=') == -1) {
      MM_keepForm = MM_keepForm + '&' + nextItem + '=' + java.net.URLEncoder.encode(request.getParameter(nextItem));
    }
  }
}

// create the Form + URL string and remove the intial '&' from each of the strings
MM_keepBoth = MM_keepURL + MM_keepForm;
if (MM_keepBoth.length() > 0) MM_keepBoth = MM_keepBoth.substring(1);
if (MM_keepURL.length() > 0)  MM_keepURL = MM_keepURL.substring(1);
if (MM_keepForm.length() > 0) MM_keepForm = MM_keepForm.substring(1);


// *** Move To Record: set the strings for the first, last, next, and previous links

//String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
{
  String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
  String MM_moveParam = "index=";

  // if the page has a repeated region, remove 'offset' from the maintained parameters
  if (MM_size > 1) {
    MM_moveParam = "offset=";
    int start = MM_keepMove.indexOf(MM_moveParam);
    if (start != -1 && (start == 0 || MM_keepMove.charAt(start-1) == '&')) {
      int stop = MM_keepMove.indexOf('&', start);
      if (start == 0 && stop != -1) stop++;
      if (stop == -1) stop = MM_keepMove.length();
      if (start > 0) start--;
      MM_keepMove = MM_keepMove.substring(0,start) + MM_keepMove.substring(stop);
    }
  }

  // set the strings for the move to links
  StringBuffer urlStr = new StringBuffer(request.getRequestURI()).append('?').append(MM_keepMove);
  if (MM_keepMove.length() > 0) urlStr.append('&');
  urlStr.append(MM_moveParam);
  MM_moveFirst = urlStr + "0";
  MM_moveLast  = urlStr + "-1";
  MM_moveNext  = urlStr + Integer.toString(MM_offset+MM_size);
  MM_movePrev  = urlStr + Integer.toString(Math.max(MM_offset-MM_size,0));
}

// 加入分頁 - 迄 /
         
		 		
		
		while ((rs_hasData)&&(rs1__numRows-- != 0)) 
		{		 
		  getDataFlag = true;
		  numRow = numRow + 1;      // 用來計算抓到條件下機型的筆數;
		  fmPrjCode =  rs.getString("PROJECTCODE");
       %>
    <tr bordercolor="#000000"> 
      <td rowspan="3"><font size="-1" color="#CC0066" ><%=(((rs_data = rs.getObject("SALESCODE"))==null || rs.wasNull())?"":rs_data)+"<BR><BR>"+(((rs_data = rs.getObject("PROJECTCODE"))==null || rs.wasNull())?"":rs_data)%></font></td>
      <td nowrap><font size="-1" color="#CC0066">預估出貨</font></td>
      <td nowrap> <div align="right"><font color="#1B0378" size="-1"><%=(((rs_data = rs.getObject("FMQTY"))==null || rs.wasNull())?"":rs_data)%></font></div></td>
      <td nowrap> <div align="right"><font color="#1B0378" size="-1"> 
          <% //Week 1 Forecast  
        
            Statement stateFW1=con.createStatement();   
		
		    try
		   {   
             String sqlFW1 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW1 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
									    "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD =  '"+fmPrjCode+"'  and w.FWWEEK = '1'  ";
		     sqlFW1 = sqlFW1+ sWhereFW1;		
		
            //out.println(sqlFW1);
            ResultSet rsFW1=stateFW1.executeQuery(sqlFW1);
			if (rsFW1.next())
			{out.println(rsFW1.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='WeekC" + numRow + "1Val'  value='"+rsFW1.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='WeekC" + numRow + "1Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}			 
			else
			{//out.println("<input type='text' name='WeekC1Val'  size='5'>");
			  String sTemp = "<input type='text' name='WeekC" + numRow + "1Val'  size='5'>";
			  out.println(sTemp);
			 }
			rsFW1.close();
			stateFW1.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
		
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <% //Week 2 Forecast  
        
            Statement stateFW2=con.createStatement();   
		
		    try
		   {   
             String sqlFW2 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW2 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '2' ";
		     sqlFW2 = sqlFW2+ sWhereFW2;		
		
            //out.println(sqlFW1);
            ResultSet rsFW2=stateFW2.executeQuery(sqlFW2);
			if (rsFW2.next())
			{out.println(rsFW2.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='WeekC" + numRow + "2Val'  value='"+rsFW2.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='WeekC" + numRow + "2Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{ String sTemp = "<input type='text' name='WeekC" + numRow + "2Val'  size='5'>";
			   out.println(sTemp);
			   //out.println("<input type='text' name='WeekC"+numRow+"2Val'  size='5'>");
			}
			rsFW2.close();
			stateFW2.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="-1"> 
          <% //Week 3 Forecast  
        
            Statement stateFW3=con.createStatement();   
		
		    try
		   {   
             String sqlFW3 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW3 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '3' ";
		     sqlFW3 = sqlFW3+ sWhereFW3;		
		
            //out.println(sqlFW1);
            ResultSet rsFW3=stateFW3.executeQuery(sqlFW3);
			if (rsFW3.next())
			{out.println(rsFW3.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='WeekC" + numRow + "3Val'  value='"+rsFW3.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='WeekC" + numRow + "3Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{String sTemp = "<input type='text' name='WeekC" + numRow + "3Val'  size='5'>";
			  out.println(sTemp);
			  //out.println("<input type='text' name='WeekC"+numRow+"3Val'  size='5'>");
			}
			rsFW3.close();
			stateFW3.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="-1"> 
          <% //Week 4 Forecast  
        
            Statement stateFW4=con.createStatement();   
		
		    try
		   {   
             String sqlFW4 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW4 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '4' ";
		     sqlFW4 = sqlFW4+ sWhereFW4;		
		
            //out.println(sqlFW1);
            ResultSet rsFW4=stateFW4.executeQuery(sqlFW4);
			if (rsFW4.next())
			{out.println(rsFW4.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='WeekC" + numRow + "4Val'  value='"+rsFW4.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='WeekC" + numRow + "4Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{String sTemp = "<input type='text' name='WeekC" + numRow + "4Val'  size='5'>";
			  out.println(sTemp);
			  //out.println("<input type='text' name='WeekC"+numRow+"4Val'  size='5'>");
			}
			rsFW4.close();
			stateFW4.close();
						
		   } //end of try
           catch (Exception e)
          {
            out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="-1"> 
          <% //Week 5 Forecast  
        
            Statement stateFW5=con.createStatement();   
		
		    try
		   {   
             String sqlFW5 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW5 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '5' ";
		     sqlFW5 = sqlFW5+ sWhereFW5;		
		
            //out.println(sqlFW1);
            ResultSet rsFW5=stateFW5.executeQuery(sqlFW5);
			if (rsFW5.next())
			{out.println(rsFW5.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='WeekC" + numRow + "5Val'  value='"+rsFW5.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='WeekC" + numRow + "5Val'  value='"+0+"' size='5'>";
			 out.println(sTemp);
		    }
			else
			{String sTemp = "<input type='text' name='WeekC" + numRow + "5Val'  size='5'>";
			  out.println(sTemp);
			  //out.println("<input type='text' name='WeekC"+numRow+"5Val'  size='5'>");
			}
			rsFW5.close();
			stateFW5.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td bgcolor="#CCFFFF"><div align="right"><font color="#1B0378" size="-1"><%=(((rs_data = rs.getObject("FMQTY"))==null || rs.wasNull())?"":rs_data)%></font></div></td>
      <td><div align="right"><font size="-1"> 
	     <% 
		   ///   String sTemp1 = "<input type='text' name='Week" + numRow + "1Val'  size='5'>";
			///  out.println(sTemp1);
		      //out.println("<input type='text' name='Week"+numRow+"1Val'  size='5'>");
		    Statement stateFNW1=con.createStatement();   		
		    try
		   {   
             String sqlFNW1 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFNW1 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWPRJCD =  '"+fmPrjCode+"'  and w.FWWEEK = '1'  ";
		     sqlFNW1 = sqlFNW1+ sWhereFNW1;		
		
            //out.println(sqlFNW1);
            ResultSet rsFNW1=stateFNW1.executeQuery(sqlFNW1);
			if (rsFNW1.next())
			{out.println(rsFNW1.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='Week" + numRow + "1Val'  value='"+rsFNW1.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='Week" + numRow + "1Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{//out.println("<input type='text' name='WeekC1Val'  size='5'>");
			  String sTemp1 = "<input type='hidden' name='Week" + numRow + "1Val'  size='5'>";
			  out.println(sTemp1);
			  out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			 }
			rsFNW1.close();
			stateFNW1.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
			  
	 %>        
        </font></div></td>
     <td><div align="right"><font size="-1"> 
	    <% 
		     ///String sTemp2 = "<input type='text' name='Week" + numRow + "2Val'  size='5'>";
			 ///out.println(sTemp2);
		     //out.println("<input type='text' name='Week"+numRow+"2Val'  size='5'>")
			 Statement stateFNW2=con.createStatement();   		
		    try
		   {   
             String sqlFNW2 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFNW2 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '2' ";
		     sqlFNW2 = sqlFNW2+ sWhereFNW2;		
		
            //out.println(sqlFW1);
            ResultSet rsFNW2=stateFNW2.executeQuery(sqlFNW2);
			if (rsFNW2.next())
			{ out.println(rsFNW2.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='Week" + numRow + "2Val'  value='"+rsFNW2.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='Week" + numRow + "2Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{ String sTemp2 = "<input type='hidden' name='Week" + numRow + "2Val'  size='5'>";
			   out.println(sTemp2);
			   out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			   //out.println("<input type='text' name='WeekC"+numRow+"2Val'  size='5'>");
			}
			rsFNW2.close();
			stateFNW2.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          }   
			  
	   %>          
      </font></div></td>
     <td><div align="right"><font size="-1"> 
	    <% 
		     /// String sTemp3 = "<input type='text' name='Week" + numRow + "3Val'  size='5'>";
			 /// out.println(sTemp3);
		      //out.println("<input type='text' name='Week"+numRow+"3Val'  size='5'>")
			  
			Statement stateFNW3=con.createStatement();   
		    try
		   {   
             String sqlFNW3 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFNW3 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '3' ";
		     sqlFNW3 = sqlFNW3+ sWhereFNW3;		
		
            //out.println(sqlFW1);
            ResultSet rsFNW3=stateFNW3.executeQuery(sqlFNW3);
			if (rsFNW3.next())
			{ out.println(rsFNW3.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='Week" + numRow + "3Val'  value='"+rsFNW3.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='Week" + numRow + "3Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{String sTemp3 = "<input type='hidden' name='Week" + numRow + "3Val'  size='5'>";
			  out.println(sTemp3);
			  out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  //out.println("<input type='text' name='WeekC"+numRow+"3Val'  size='5'>");
			}
			rsFNW3.close();
			stateFNW3.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
	    %>          
        </font></div></td>
      <td><div align="right"><font size="-1"> 
        <% 
		    ///   String sTemp4 = "<input type='text' name='Week" + numRow + "4Val'  size='5'>";
			///  out.println(sTemp4);
		    //out.println("<input type='text' name='Week"+numRow+"4Val'  size='5'>")
			
			Statement stateFNW4=con.createStatement();   
		    try
		   {   
             String sqlFNW4 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFNW4 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '4' ";
		     sqlFNW4 = sqlFNW4+ sWhereFNW4;		
		
            //out.println(sqlFW1);
            ResultSet rsFNW4=stateFNW4.executeQuery(sqlFNW4);
			if (rsFNW4.next())
			{ out.println(rsFNW4.getInt("FWQTY"));
			  //String sTemp = "<input type='hidden' name='Week" + numRow + "4Val'  value='"+rsFNW4.getInt("FWQTY")+"' size='5'>";
			  String sTemp = "<input type='hidden' name='Week" + numRow + "4Val'  value='"+0+"' size='5'>";
			  out.println(sTemp);
			}
			else
			{String sTemp4 = "<input type='hidden' name='Week" + numRow + "4Val'  size='5'>";
			  out.println(sTemp4);
			  out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  //out.println("<input type='text' name='WeekC"+numRow+"3Val'  size='5'>");
			}
			rsFNW4.close();
			stateFNW4.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		%>  
        </font></div></td>
      <td><div align="right"><font size="-1"> 
        <% 
		     //String sTemp5 = "<input type='text' name='Week" + numRow + "5Val'  size='5'>";
			 //out.println(sTemp5);
		    //out.println("<input type='text' name='Week"+numRow+"5Val'  size='5'>")
			Statement stateFNW5=con.createStatement();   
		    try
		   {   
             String sqlFNW5 = "select w.FWQTY from PSALES_FORE_MONTH f, PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFNW5 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			                           "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
									   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+monNext+"'  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '5' ";
		     sqlFNW5 = sqlFNW5+ sWhereFNW5;		
		
            //out.println(sqlFW1);
            ResultSet rsFNW5=stateFNW5.executeQuery(sqlFNW5);
			if (rsFNW5.next())
			{out.println(rsFNW5.getInt("FWQTY"));
			 //String sTemp = "<input type='hidden' name='Week" + numRow + "5Val'  value='"+rsFNW5.getInt("FWQTY")+"' size='5'>";
			 String sTemp = "<input type='hidden' name='Week" + numRow + "5Val'  value='"+0+"' size='5'>";
			 out.println(sTemp);
			}
			else
			{String sTemp5 = "<input type='hidden' name='Week" + numRow + "5Val'  size='5'>";
			  out.println(sTemp5);
			  out.println("<font color='#1B0378' size='-1' >"+"N/A"+"</font>");
			  //out.println("<input type='text' name='WeekC"+numRow+"3Val'  size='5'>");
			}
			rsFNW5.close();
			stateFNW5.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		%>  
        </font></div></td>
      <td bgcolor="#FFFFCC"><div align="right"><font size="-1" color="#1B0378"> 
        <%
		   try
		   {
	         Statement stateNTTL=con.createStatement();   
		 
             String sqlNTTL = "select f.FMQTY from PSALES_FORE_MONTH f, PIMASTER m ";
		     String sWhereNTTL= "where m.PROJECTCODE = f.FMPRJCD and f.FMCOMP =  '"+compNo+"'  and f.FMREG = "+regionNo+"  and f.FMCOUN =  "+locale+"  " +
			                           "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+monNext+"'  ";
		     sqlNTTL = sqlNTTL + sWhereNTTL;		
		
             //out.println(sql);
             ResultSet rsNTTL=stateNTTL.executeQuery(sqlNTTL);
	         //if (rsF.next())
		     if (rsNTTL.next())
		    {out.println(rsNTTL.getInt("FMQTY"));}
			else
			{out.println("N/A");}
		     rsNTTL.close();
		     stateNTTL.close();
		 } //end of try
         catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        } 
	    %>
        </font></div></td>
      <td bgcolor="#FFCCFF"><div align="right"><font color="#1B0378" size="-1"> 
       <%
		 try
		{ 	  
	     Statement stateFore=con.createStatement();   
		 
         String sqlF = "select f.FMQTY from PSALES_FORE_MONTH f, PIMASTER m ";
		 String sWhereF= "where m.PROJECTCODE = f.FMPRJCD and f.FMCOMP =  '"+compNo+"'  and f.FMREG = "+regionNo+"  and f.FMCOUN =  "+locale+"  " +
		                          "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                          "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+monNext2+"'  ";
		 sqlF = sqlF + sWhereF;		
		
        //out.println(sql);
         ResultSet rsF=stateFore.executeQuery(sqlF);
	     //if (rsF.next())
		 if (rsF.next())
		 {out.println(rsF.getInt("FMQTY"));}
		 else
		 {out.println("N/A");}
		 rsF.close();
		 stateFore.close();
	   } //end of try
       catch (Exception e)
      {
        out.println("Exception:"+e.getMessage());
      } 
	%>
          </font></div></td>
    </tr>
    <tr bordercolor="#000000">       
      <td><font size="-1" color="#CC0066">實際出貨</font></td>
      <td><font size="-1">&nbsp;</font> </td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDW1 = rs.getString("PROJECTCODE");
	           String strShpYMW1 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH=con.createStatement();
				
				ResultSet rsW1=stateITH.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                        "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='1' ");
                if (rsW1.next())
				{  fwDatFr = rsW1.getString("FWDATFR");
				    fwDatTo = rsW1.getString("FWDATTO");}
				 rsW1.close();
				 
				 fwDatFr = strShpYMW1 + fwDatFr;
				 fwDatTo = strShpYMW1 + fwDatTo;
  
                String sqlITH = "select sum(abs(TQTY)) as SUMW1 from ITH m, PRODMODEL p ";
                String sWhereITH= "where trim(m.tprod) = p.MITEM  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW1+"'  and m.ttype = 'B' ";
                 sqlITH = sqlITH + sWhereITH;
  
                ResultSet rsITH=stateITH.executeQuery(sqlITH);
  
                if (rsITH.next())
				{out.println(rsITH.getInt("SUMW1"));}
				rsITH.close();
				stateITH.close();	       
			 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDW2 = rs.getString("PROJECTCODE");
	           String strShpYMW2 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH2=con.createStatement();
				String sqlW2 = "select f.FWDATFR, f.FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = "+regionNo+"  and f.FWCOUN =  "+locale+"  " +
				                        "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='2' ";
				ResultSet rsW2=stateITH2.executeQuery(sqlW2);
                if (rsW2.next())
				{  fwDatFr = rsW2.getString("FWDATFR");
				    fwDatTo = rsW2.getString("FWDATTO");}
				 rsW2.close();
				 
				 //out.println(sqlW2);
				 
				 fwDatFr = strShpYMW2 + fwDatFr;
				 fwDatTo = strShpYMW2 + fwDatTo;
  
                String sqlITH2 = "select sum(abs(TQTY)) as SUMW2 from ITH m, PRODMODEL p ";
                String sWhereITH2= "where trim(m.tprod) = p.MITEM  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW2+"'  and m.ttype='B' ";
                 sqlITH2 = sqlITH2 + sWhereITH2;
				 
				// out.println(sqlITH2);
  
                ResultSet rsITH2=stateITH2.executeQuery(sqlITH2);
  
                if (rsITH2.next())
				{out.println(rsITH2.getInt("SUMW2"));}
				rsITH2.close();
				stateITH2.close();	       
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDW3 = rs.getString("PROJECTCODE");
	           String strShpYMW3 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH3=con.createStatement();
				
				//ResultSet rsW3=stateITH3.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = "+regionNo+"  and f.FWCOUN =  "+locale+"  " +
		        //                                                                "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='3' ");
				ResultSet rsW3=stateITH3.executeQuery("select FWDATFR,FWDATTO from PSALES_FORE_WEEK f,  PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP='"+compNo+"' and f.FWREG="+regionNo+" and f.FWCOUN="+locale+" " +
				                                                                "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
				                                                                "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='3' ");
                if (rsW3.next())
				{  fwDatFr = rsW3.getString("FWDATFR");
				    fwDatTo = rsW3.getString("FWDATTO");}
				 rsW3.close();
				 
				 fwDatFr = strShpYMW3 + fwDatFr;
				 fwDatTo = strShpYMW3 + fwDatTo;
  
                String sqlITH3 = "select sum(abs(TQTY)) as SUMW3 from ITH m, PRODMODEL p ";
                String sWhereITH3= "where trim(m.tprod) = p.MITEM  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW3+"'  and m.ttype = 'B' ";
                 sqlITH3 = sqlITH3 + sWhereITH3;
  
                ResultSet rsITH3=stateITH3.executeQuery(sqlITH3);
  
                if (rsITH3.next())
				{out.println(rsITH3.getInt("SUMW3"));}
				rsITH3.close();
				stateITH3.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDW4 = rs.getString("PROJECTCODE");
	           String strShpYMW4 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH4=con.createStatement();
				
				//ResultSet rsW3=stateITH3.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = "+regionNo+"  and f.FWCOUN =  "+locale+"  " +
		        //                                                                "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='3' ");
				ResultSet rsW4=stateITH4.executeQuery("select FWDATFR,FWDATTO from PSALES_FORE_WEEK f,  PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP='"+compNo+"' and f.FWREG="+regionNo+" and f.FWCOUN="+locale+" " +
				                                                                "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
				                                                                "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='4' ");
                if (rsW4.next())
				{  fwDatFr = rsW4.getString("FWDATFR");
				    fwDatTo = rsW4.getString("FWDATTO");}
				 rsW4.close();
				 
				 fwDatFr = strShpYMW4 + fwDatFr;
				 fwDatTo = strShpYMW4 + fwDatTo;
  
                String sqlITH4 = "select sum(abs(TQTY)) as SUMW4 from ITH m, PRODMODEL p ";
                String sWhereITH4= "where trim(m.tprod) = p.MITEM  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW4+"'  and m.ttype = 'B' ";
                 sqlITH4 = sqlITH4 + sWhereITH4;
  
                ResultSet rsITH4=stateITH4.executeQuery(sqlITH4);
  
                if (rsITH4.next())
				{out.println(rsITH4.getInt("SUMW4"));}
				rsITH4.close();
				stateITH4.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDW5 = rs.getString("PROJECTCODE");
	           String strShpYMW5 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH5=con.createStatement();
				
				ResultSet rsW5=stateITH5.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                        "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='5' ");
                if (rsW5.next())
				{  fwDatFr = rsW5.getString("FWDATFR");
				    fwDatTo = rsW5.getString("FWDATTO");}
				 rsW5.close();
				 
				 fwDatFr = strShpYMW5 + fwDatFr;
				 fwDatTo = strShpYMW5 + fwDatTo;
  
                String sqlITH5 = "select sum(abs(TQTY)) as SUMW5 from ITH m, PRODMODEL p ";
                String sWhereITH5= "where trim(m.tprod) = p.MITEM  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW5+"'  and m.ttype = 'B' ";
                 sqlITH5 = sqlITH5 + sWhereITH5;
  
                ResultSet rsITH5=stateITH5.executeQuery(sqlITH5);
  
                if (rsITH5.next())
				{out.println(rsITH5.getInt("SUMW5"));}
				rsITH5.close();
				stateITH5.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td bgcolor="#CCFFFF"><div align="right"><font color="#1B0378" size="-1"> 
          <%
		      try
			  {
	           String strPrjCDActTTL = rs.getString("PROJECTCODE");
	           String strShpYMActTTL = YearFr+MonthFr;		  		  
		   
	            Statement stateActTTL=con.createStatement();
				 
                String sqlActTTL = "select sum(abs(TQTY)) as SUMActTTL from ITH m, PRODMODEL p ";
                String sWhereActTTL= "where trim(m.tprod) = p.MITEM  and  substr(m.TTDTE,1,6) = '"+strShpYMActTTL+"'  "+
                                                     "and p.MPROJ = '"+strPrjCDActTTL+"'  and m.TTYPE = 'B' ";
                 sqlActTTL= sqlActTTL + sWhereActTTL;
  
                ResultSet rsActTTL=stateActTTL.executeQuery(sqlActTTL);
  
                if (rsActTTL.next())
				{out.println(rsActTTL.getInt("SUMActTTL"));}
				rsActTTL.close();
				stateActTTL.close();	       
			 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
          </font></div></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td bgcolor="#FFFFCC"><font size="-1">-</font></td>
      <td bgcolor="#FFCCFF"><font size="-1">&nbsp;</font> </td>
    </tr>
    <tr bordercolor="#000000"> 
    <!--% <td><font size="-1" color="#CC0066"><%=(((rs_data = rs.getObject("PROJECTCODE"))==null || rs.wasNull())?"":rs_data)%> </font></td> %-->
      <td><font size="-1" color="#CC0066">實際產出 </font></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%
	       String strPrjCD = rs.getString("PROJECTCODE");
	       String strShpYM = YearFr+MonthFr;
		   
	        Statement state=con.createStatement();
  
           String sqlMES = "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereMES = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpYM+"'  "+
                                     "and p.MPROJ = '"+strPrjCD+"'   ";
           sqlMES = sqlMES + sWhereMES;
  
           ResultSet rsMESOut=state.executeQuery(sqlMES);
  
           if (rsMESOut.next())
		   {out.println(rsMESOut.getInt("COUNT"));}
		   rsMESOut.close();
		   state.close();
	%>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%	         
		    try
			  {
	           String strPrjCDM1 = rs.getString("PROJECTCODE");
	           String strShpYMM1 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES1=con.createStatement();
				
				ResultSet rsM1=stateMES1.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                           "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='1' ");
                if (rsM1.next())
				{  fwDatFr = rsM1.getString("FWDATFR");
				    fwDatTo = rsM1.getString("FWDATTO");}
				 rsM1.close();
				 
				 fwDatFr = strShpYMM1 + fwDatFr;
				 fwDatTo = strShpYMM1 + fwDatTo;        
  
           String sqlM1= "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereM1 = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,8) between '"+fwDatFr+"'  and '"+fwDatTo+"' "+
                                     "and p.MPROJ = '"+strPrjCDM1+"'   ";
           sqlM1 = sqlM1+ sWhereM1;
  
           ResultSet rsMESOut1=stateMES1.executeQuery(sqlM1);
  
           if (rsMESOut1.next())
		   {out.println(rsMESOut1.getInt("COUNT"));}
		   rsMESOut1.close();
		   stateMES1.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 		   
	  %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%	         
		    try
			  {
	           String strPrjCDM2 = rs.getString("PROJECTCODE");
	           String strShpYMM2 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES2=con.createStatement();
				
				ResultSet rsM2=stateMES2.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                  "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='2' ");
                if (rsM2.next())
				{  fwDatFr = rsM2.getString("FWDATFR");
				    fwDatTo = rsM2.getString("FWDATTO");}
				 rsM2.close();
				 
				 fwDatFr = strShpYMM2 + fwDatFr;
				 fwDatTo = strShpYMM2 + fwDatTo;        
  
           String sqlM2= "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereM2 = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,8) between '"+fwDatFr+"'  and '"+fwDatTo+"' "+
                                     "and p.MPROJ = '"+strPrjCDM2+"'   ";
           sqlM2 = sqlM2+ sWhereM2;
  
           ResultSet rsMESOut2=stateMES2.executeQuery(sqlM2);
  
           if (rsMESOut2.next())
		   {out.println(rsMESOut2.getInt("COUNT"));}
		   rsMESOut2.close();
		   stateMES2.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 		   
	  %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%	         
		    try
			  {
	           String strPrjCDM3 = rs.getString("PROJECTCODE");
	           String strShpYMM3 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES3=con.createStatement();
				
				ResultSet rsM3=stateMES3.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                  "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='3' ");
                if (rsM3.next())
				{  fwDatFr = rsM3.getString("FWDATFR");
				    fwDatTo = rsM3.getString("FWDATTO");}
				 rsM3.close();
				 
				 fwDatFr = strShpYMM3 + fwDatFr;
				 fwDatTo = strShpYMM3 + fwDatTo;        
  
           String sqlM3= "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereM3 = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,8) between '"+fwDatFr+"'  and '"+fwDatTo+"' "+
                                     "and p.MPROJ = '"+strPrjCDM3+"'   ";
           sqlM3 = sqlM3+ sWhereM3;
  
           ResultSet rsMESOut3=stateMES3.executeQuery(sqlM3);
  
           if (rsMESOut3.next())
		   {out.println(rsMESOut3.getInt("COUNT"));}
		   rsMESOut3.close();
		   stateMES3.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 		   
	  %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%	         
		    try
			  {
	           String strPrjCDM4 = rs.getString("PROJECTCODE");
	           String strShpYMM4 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES4=con.createStatement();
				
				ResultSet rsM4=stateMES4.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                  "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='4' ");
                if (rsM4.next())
				{  fwDatFr = rsM4.getString("FWDATFR");
				    fwDatTo = rsM4.getString("FWDATTO");}
				 rsM4.close();
				 
				 fwDatFr = strShpYMM4 + fwDatFr;
				 fwDatTo = strShpYMM4 + fwDatTo;        
  
           String sqlM4= "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereM4 = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,8) between '"+fwDatFr+"'  and '"+fwDatTo+"' "+
                                     "and p.MPROJ = '"+strPrjCDM4+"'   ";
           sqlM4 = sqlM4+ sWhereM4;
  
           ResultSet rsMESOut4=stateMES4.executeQuery(sqlM4);
  
           if (rsMESOut4.next())
		   {out.println(rsMESOut4.getInt("COUNT"));}
		   rsMESOut4.close();
		   stateMES4.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 		   
	  %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="-1"> 
          <%	         
		    try
			  {
	           String strPrjCDM5 = rs.getString("PROJECTCODE");
	           String strShpYMM5 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES5=con.createStatement();
				
				ResultSet rsM5=stateMES5.executeQuery("select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m where m.PROJECTCODE = f.FWPRJCD and f.FWCOMP =  '"+compNo+"'  and f.FWREG = '"+regionNo+"'  and f.FWCOUN =  '"+locale+"'  " +
				                                                                  "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                                                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and  f.FWWEEK='5' ");
                if (rsM5.next())
				{  fwDatFr = rsM5.getString("FWDATFR");
				    fwDatTo = rsM5.getString("FWDATTO");}
				 rsM5.close();
				 
				 fwDatFr = strShpYMM5 + fwDatFr;
				 fwDatTo = strShpYMM5 + fwDatTo;        
  
           String sqlM5= "select count(*) as COUNT from MES_WIP_TRACKING m, PRODMODEL p ";
           String sWhereM5 = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,8) between '"+fwDatFr+"'  and '"+fwDatTo+"' "+
                                     "and p.MPROJ = '"+strPrjCDM5+"'   ";
           sqlM5 = sqlM5+ sWhereM5;
  
           ResultSet rsMESOut5=stateMES5.executeQuery(sqlM5);
  
           if (rsMESOut5.next())
		   {out.println(rsMESOut5.getInt("COUNT"));}
		   rsMESOut5.close();
		   stateMES5.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 		   
	  %>
          </font></div></td>
      <td bgcolor="#CCFFFF"><font size="-1">&nbsp;</font> </td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td><font size="-1">-</font></td>
      <td bgcolor="#FFFFCC"><font size="-1">-</font></td>
      <td bgcolor="#FFCCFF"><font size="-1">&nbsp;</font> </td>
    </tr>
    <%
       rs1__index++;
       rs_hasData = rs.next();
     }
	 rsFW.close(); 
	 rs.close();	 
	 statement.close();
   } //end of try
   catch (Exception e)
   {
       out.println("Exception:"+e.getMessage());
   } 
  
 %>
  </table>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveFirst%>">第一頁</A></strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_movePrev%>">上一頁</A></strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveNext%>">下一頁</A></strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#FF0000"><strong><A HREF="<%=MM_moveLast%>">最後一頁</A></strong></font></pre>
      </div></td>
  </tr>
</table>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
<%
//rs.close();
%>
