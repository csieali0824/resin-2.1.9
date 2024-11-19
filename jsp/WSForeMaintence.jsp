<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
   function macthMonthCheck()
  { 
     monDataFactor = eval(document.MYFORM.NONMONTH.value);
     if (monDataFactor=="0" )
     { 
      alert("不存在所選取月份出貨預估數值!/f請再確認!");   
      //return(false);
     } 	 
	 //document.MYFORM.submit();    
  }
  function checkCompNull()
  {
    getCompCh = document.MYFORM.COMPNO.value;
	if (getCompCh==null || getCompCh=="ALL")
	{ alert("請選擇地區別作查詢");}
  }
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Weekly Sales Forecast Maintain</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><strong><font size="+2" face="Times New Roman, Times, serif">DBTEL</font></strong></font></font></font><font color="#04049D" size="+2" face="Arial"> 
GSM Delivery Plan Inquiry</font><BR>
<!--FORM ACTION="../jsp/WSForeMaintence.jsp" METHOD="post" NAME="MYFORM" onSubmit='return submitCheck()'-->
<FORM ACTION="../jsp/WSForeMaintence.jsp" METHOD="post" NAME="MYFORM" >
<%
   int rs1__numRows = 15;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
%>
<A HREF="/wins/jsp/WinsMainMenu.jsp">HOME</A>
  &nbsp;
<%     
String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
  String compNo=request.getParameter("COMPNO");
  String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE");
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR"); 
  String model=request.getParameter("MODEL"); 
  
   int numRow = 0;
  
  /* if ( regionNo != null )
  { regionNo = regionNo.substring(1,1);}
  out.println(regionNo); */
  
  int dateYearCurr = dateBean.getYear();
  int dateMonCurr = dateBean.getMonth();
  int yearCH = 0;
  int monCH = 0;
  int yearNext = 0;
  if (YearFr != null && MonthFr != null)
  {yearCH = Integer.parseInt(YearFr);
    monCH = Integer.parseInt(MonthFr); }
  
  
   
  int yearMonCurr =  dateYearCurr  * 100 +  dateMonCurr;
  int yearMonCH = yearCH * 100 +  monCH;
  
  
  //String nonMonthData = "No";
  //out.println(regionNo);
  //out.println(locale);
  String fmPrjCode = "";
  
  String monthPre = "";

  int monPre = 0;  
  
  int monCurr = 0;
  int monNext =  0;
  int monNext2 = 0;
  
  if ( (compNo== null || regionNo==null || locale==null) )
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
		  monNext2 = 1;
		}
		else
		{ monNext =1;
		  monNext2 = 2;
		}
	  } 
	  
	   int CurMon = Integer.parseInt(MonthFr);
	     // 取前一個月 //	  
      
	     if (CurMon == 1)
	     { monPre = 12; }
	     else { monPre = CurMon - 1;}
	     // 若前月<= 9月,則字串取得 補零
	     if (monPre<=9){monthPre = '0'+ Integer.toString(monPre);}
	     else {monthPre = Integer.toString(monPre);}
	         
       try
      {   
        Statement statH=con.createStatement();
  
        String sqlH = "select count(*) as COUNT from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m ";
        String sWhereH = "where m.PROJECTCODE = f.FMPRJCD " + 
                                    // "and f.FMCOMP =  '"+compNo+"'  " + 
                                   //  "and to_char(f.FMREG) = '"+regionNo+"'  "+
                                   //  "and to_char(f.FMCOUN) =  '"+locale+"'  " +
                                     "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  ";
									// "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
									 
		 if (locale==null || locale.equals("--")) {   sWhereH = sWhereH + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		 else { sWhereH = sWhereH + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		 if (compNo==null || compNo.equals("--")) {   sWhereH = sWhereH + "and f.FMCOMP !=  'ALL'  "; }
		 else { sWhereH = sWhereH + "and f.FMCOMP =  '"+compNo+"'  "; }
         if (regionNo==null || regionNo.equals("--")) { sWhereH = sWhereH + "and to_char(f.FMREG) != 'ALL'  "; }
		 else { sWhereH = sWhereH +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
		 if (model==null || model.equals("--")) { sWhereH = sWhereH +  "and m.SALESCODE !=  'ALL' "; }
		else { sWhereH = sWhereH +  "and m.SALESCODE =  '"+model+"' "; }
		 
         sqlH = sqlH + sWhereH;
  
         ResultSet rsH=statH.executeQuery(sqlH);
  
         if (rsH.next())
        {
           int cntFlag =0;
	       cntFlag = rsH.getInt("COUNT");
	      if (cntFlag>= 1)
	     {
	        // 再判斷週預估出貨表存在否
	        String sqlWE = "select count(*) as COUNT from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
            String sWhereWE = "where m.PROJECTCODE = f.FWPRJCD " + 
                         //                  "and f.FWCOMP =  '"+compNo+"'  " + 
                         //                  "and to_char(f.FWREG) = '"+regionNo+"'  "+
                         //                  "and to_char(f.FWCOUN) =  '"+locale+"'  " +
                                           "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  ";
										   // "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
										   
			if (locale==null || locale.equals("--")) {   sWhereWE = sWhereWE + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		    else { sWhereWE = sWhereWE + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereWE = sWhereWE + "and f.FWCOMP !=  'ALL'  "; }
		    else { sWhereWE = sWhereWE + "and f.FWCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereWE = sWhereWE + "and to_char(f.FWREG) != 'ALL'  "; }
		    else { sWhereWE = sWhereWE +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhereWE = sWhereWE +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhereWE = sWhereWE +  "and m.SALESCODE =  '"+model+"' "; }							   
										   
            sqlWE = sqlWE + sWhereWE;
			
			//out.println(sqlWE);
  
           ResultSet rsWE=statH.executeQuery(sqlWE);
	       if (rsWE.next())  
	      { 
	        int wefExist =0;
		    wefExist = rsWE.getInt("COUNT");
			
			if ( locale.equals("--") || regionNo.equals("--") || compNo.equals("--") )
			{}
			else
			{			
		      if ( wefExist>=1 )  // 月存在,週存在,則顯示可維護下月週預估表
		      { 
			      String monNextENG="";
				  String sqlM = "select MENG from WSADMIN.WSMONTH_CODE where  MMON_AR =  '"+monNext+"'  ";
		          ResultSet rsM=statH.executeQuery(sqlM);
		          if (rsM.next())
		         {monNextENG=rsM.getString("MENG");} 
				  rsM.close();			    
				  out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?COMPNO="+compNo+"&&REGION="+regionNo+"&&LOCALE="+locale+"&&YEARFR="+YearFr+"&&MONTHFR="+monNext+"&&MODEL="+model+"'>EDIT ("+monNextENG+") WEEKLY FORECAST</A>");
			  }
		      else  if ( wefExist<1 )    // 月存在,週不存在,則顯示僅可維護本月週預估表
	          {   
			      String MonthFrENG="";
				  String sqlC = "select MENG from WSADMIN.WSMONTH_CODE where  MMON_AR =  '"+MonthFr+"'  ";
		          ResultSet rsC=statH.executeQuery(sqlC);
		          if (rsC.next())
		         {MonthFrENG=rsC.getString("MENG");} 
				  rsC.close();
			      out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?COMPNO="+compNo+"&&REGION="+regionNo+"&&LOCALE="+locale+"&&YEARFR="+YearFr+"&&MONTHFR="+MonthFr+"&&MODEL="+model+"'>EDIT ("+MonthFrENG+") WEEKLY FORECAST</A>");
			  }         	      
			}
	      }
	      rsWE.close();  	  
	      }
	      else  // else for cntFlag >= 1 , 月即已不存在,更不用看週,呼叫 JavaScript 警示 !!!
	     {out.println("<input name='NONMONTH' type='hidden' value='0' >");
		   out.println("<font color='#FF0000'>"+"There is no EIS_SALES_FORECAST data in System, Please inform sales department !!!"+"</fonr>");
		 }
	      //nonMonthData = "Yes";}
         //out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?"+compNo+"&&"+regionNo+"&&"+locale+"&&"+YearFr+"&&"+MonthFr+"&&'>EDIT WEEK FORECAST</A>");
          }  // for rsH if
          else
          {}//out.println("<input name='NONMONTH' type='text' value='0' >");}
          //nonMonthData = "Yes";}
          rsH.close();
          statH.close();  
         } //end of try
         catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());		  
        }
    }   // End of else for if(MonthFr== null)
%>
  
  <table width="100%" border="0" bordercolor="#CCFFFF" >
    <tr bgcolor="#CCFFFF" > 
      <td width="35%" height="24" bordercolor="#FFFFFF">
        <p><font color="#330099" face="Arial Black">Company Cod</font><font face="Arial Black"><font color="#330099">e</font></font> 
          <% 
		 String COMPNO="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select trim(MCCOMP) as MCCOMP,  trim(MCCOMP) || '('||MCDESC||')' from WSADMIN.WSMULTI_COMP ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhere = "where MCCOMP IS NOT NULL and trim(MCCOMP) in('01','08','28','45')";		 
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
      <td width="20%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> 
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
	      <!--%
		     String CurrRegion = null;	     		 
	        try
           {       
             String a[]={"01(亞洲)","02(大洋洲)","03(美洲)","04(非洲)","05(歐洲)"};
             arrayComboBoxBean.setArrayString(a);
		     if (regionNo==null)
		     {
		       CurrRegion="01(亞洲)";//dateBean.getYearString();
		       arrayComboBoxBean.setSelection(CurrRegion);
		     } 
		     else 
		     {
			   if (regionNo=="1"){regionNo =  "01(亞洲)";}
			   else if (regionNo=="2"){regionNo =  "02(大洋洲)";}
			   else if (regionNo=="3"){regionNo =  "03(美洲)";}
			   else if (regionNo=="4"){regionNo =  "04(非洲)";}
			   else if (regionNo=="5"){regionNo =  "05(歐洲)";}
		       arrayComboBoxBean.setSelection(regionNo);
		     }
	         arrayComboBoxBean.setFieldName("REGION");	   
             out.println(arrayComboBoxBean.getArrayString());		      		 
            } //end of try
            catch (Exception e)
            {
             out.println("Exception:"+e.getMessage());
            }
         %-->
	   </td>
      <td width="30%" colspan="2"> <font color="#333399" face="Arial Black"><strong>Country</strong></font> 
        <% 
		 String COUNTRY="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select LOCALE,  LOCALE|| '(' || LOCALE_NAME||')' from WSADMIN.WSLOCALE ";		  
		  sWhere = "where LOCALE IS NOT  NULL and LOCALE in('886','60','61','62','63','65', '66','91') ";		 
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
    <tr bgcolor="#CCFFFF"> 
      <td height="23"><font color="#333399" face="Arial Black"><strong>Year</strong></font> 
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
      <td><font color="#330099" face="Arial Black" ><strong>Model</strong></font> 
        <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select SALESCODE as MODEL,  SALESCODE || '('||BRAND||')' from WSADMIN.PIMASTER ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhere = "where PROJECTCODE IS NOT NULL ";		 
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
     <td><input name="Search"  type="submit" value="Query"  onClick="checkCompNull()"></td>	 
  </tr>
</table>

  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bordercolor="#000000"> 
      <td width="10%" rowspan="2"><font size="2">機型 </font></td>
      <td colspan="2"  rowspan="2"> <div align="center"> <font color="#FF0000" size="2"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monthPre);}
	  %>
          </font><font size="2"> 月份 <br>
          預收訂單(P/O)</font></div>
      <td colspan="6" bgcolor="#CCFFFF"> <div align="center"> <font color="#FF0000" size="2"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monCurr);}
    %>
          </font><font size="2"> 月份每週出貨狀況</font></div></td>
      <%// 加入%>
      <td colspan="6" bgcolor="#FFFFCC"><div align="center"><strong><font color="#FF0000" size="-1"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monNext);
		    if (monCH==12)
			{ yearNext = yearCH + 1; }
			else { yearNext = yearCH; }
		  }
         %>
          </font></strong><font size="-1">月份每週預估出貨量</font></div></td>
      <%// 加入%>
      <td width="10%"  bgcolor="#FFCCFF" > <div align="center"> <font color="#FF0000" size="2"> 
          <%
	      if ( (MonthFr== null) || MonthFr.equals(""))
		  {out.println();}
		  else
		  {out.println(monNext2);}
    %>
          </font><font size="2"> 月預估出貨量</font></div></td>
    </tr>
    <tr bordercolor="#000000" > 
      <td width="4%" bgcolor="#CC0066"><font color="#FFFFFF" size="2"><strong>Week1</strong></font></td>
      <td width="5%" bgcolor="#CC0066"><font color="#FFFFFF" size="2"><strong>Week2</strong></font></td>
      <td width="5%" bgcolor="#CC0066"><font color="#FFFFFF" size="2"><strong>Week3</strong></font></td>
      <td width="6%" bgcolor="#CC0066"><font color="#FFFFFF" size="2"><strong>Week4</strong></font></td>
      <td width="6%" bgcolor="#CC0066"><font color="#FFFFFF" size="2"><strong>Week5</strong></font></td>
      <td width="7%" bgcolor="#CCFFFF"><div align="right"><font size="2"><strong>Sub. TTL</strong></font></div></td>
      <%//加入%>
      <td width="6%" bgcolor="#CC0066"> <div align="center"><font color="#FFFFFF" size="-1"><strong>Week1</strong></font><font size="-1"></font><font size="-1"><br>
          <!--%起 
          <input type="text" name="W1Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W1To" maxlength="2" size="2"> %-->
          <!--%
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
		%-->
          </font></div></td>
      <td width="5%" bgcolor="#CC0066"><div align="center"><font color="#FFFFFF" size="-1"><strong>Week2</strong></font><font size="-1"></font><font size="-1"><br>
          <!--%   起 
          <input type="text" name="W2Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W2To" maxlength="2" size="2"> 
	   %-->
          <!--%
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
		%-->
          </font></div></td>
      <td width="5%" bgcolor="#CC0066"><div align="center"><font color="#FFFFFF" size="-1"><strong>Week3</strong></font><font size="-1"> 
          <br>
          <!--% 起 
          <input type="text" name="W3Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W3To" maxlength="2" size="2"> 
		 %-->
          <!--%
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
		%-->
          </font></div></td>
      <td width="5%" bgcolor="#CC0066"><div align="center"><font color="#FFFFFF" size="-1"><strong>Week4</strong></font><font size="-1"> 
          <!--% 起 
          <input type="text" name="W4Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W4To" maxlength="2" size="2"> %-->
          <!--%
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
		%-->
          </font></div></td>
      <td width="6%" bgcolor="#CC0066"><div align="center"><font color="#FFFFFF" size="-1"><strong>Week5</strong></font><strong><font size="-1"> 
          </font></strong><font size="-1"><br>
          <!--% 起 
          <input type="text" name="W5Fr" maxlength="2" size="2">
          迄 
          <input type="text" name="W5To" maxlength="2" size="2"> %-->
          <!--%
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
		%-->
          </font></div></td>
      <td width="7%" bgcolor="#FFFFCC"><div align="right"><font size="-1"><strong>Sub. TTL</strong></font></div></td>
      <% //加入%>
      <td width="10%" bgcolor="#FFCCFF" ><div align="right"><font size="2"><strong>Forecast</strong></font></div></td>
    </tr>
    <% //  *** Main Loop  Start   *** //
       //ResultSet RpRepair = StatementRpRepair.executeQuery(); 
	   
	   if ( yearMonCH >= yearMonCurr )    // 大於目前的年月才Show 資料//
	   {
         //out.println(yearMonCH);
		 //out.println(yearMonCurr);
        Statement statement=con.createStatement();   
		
		try
		{
   
         String sql = "select 'DBTEL'|| m.SALESCODE as SALESCODE, m.PROJECTCODE,f.FMQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m ";
		 /*String sWhere = "where m.PROJECTCODE = f.FMPRJCD and f.FMCOMP =  '"+compNo+"' and to_char(f.FMREG)= '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                          "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  ";  */
								  
		 String sWhere = "where m.PROJECTCODE = f.FMPRJCD and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  ";
								  
		  if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		 else { sWhere = sWhere + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		 if (compNo==null || compNo.equals("--")) {   sWhere = sWhere + "and f.FMCOMP !=  'ALL'  "; }
		 else { sWhere = sWhere + "and f.FMCOMP =  '"+compNo+"'  "; }
         if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(f.FMREG) != 'ALL'  "; }
		 else { sWhere = sWhere +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
		 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		 else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
		  						  
		 sql = sql + sWhere;		
		
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

  // if we walked off the end of the recordset, set MM?佃?????o???_rsCount and MM_size
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
		  numRow = numRow + 1; // 計算取得列數
		  fmPrjCode = rs.getString("PROJECTCODE");
       %>
    <tr bordercolor="#000000"> 
      <td rowspan="3"><font size="2" color="#1B0378" ><%=(((rs_data = rs.getObject("SALESCODE"))==null || rs.wasNull())?"":rs_data) +"<BR><BR>"+(((rs_data = rs.getObject("PROJECTCODE"))==null || rs.wasNull())?"":rs_data)%></font></td>
      <td width="6%" height="23"  nowrap><font size="2" color="#1B0378">預估產出</font></td>
      <td width="7%"> <div align="right"><font color="#1B0378" size="2">
	     <!--%=(((rs_data = rs.getObject("FMQTY"))==null || rs.wasNull())?"":rs_data)%-->
		 <%
		   try
		   {
	         Statement statePre=con.createStatement();   
			 
			 String yearPre = "";
			      int yearPreInt = 0;
			 
			 // 處理前一年月問題 //			
			 if (monCurr == 1)
			{
			  yearPreInt = yearCH-1;
			  YearFr = Integer.toString(yearPreInt);
		    }
		    // 處理前一年月問題 //
		    String strShpYM = YearFr+monthPre; 
		 
             String sqlPre = "select f.FMQTY from PSALES_FORE_MONTH f, PIMASTER m ";
		     String sWherePre= "where m.PROJECTCODE = f.FMPRJCD " +
			                           "and m.PROJECTCODE =  '"+rs.getString("PROJECTCODE")+"' "+  // 加入 Model (PROJECTCODE為條件);
		                               "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+monthPre+"'  ";
		     
			 if (compNo==null || compNo.equals("--")) {  sWherePre = sWherePre + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWherePre = sWherePre + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWherePre = sWherePre + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWherePre =sWherePre+ "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWherePre = sWherePre + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWherePre = sWherePre +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWherePre = sWherePre +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWherePre = sWherePre +  "and m.SALESCODE =  '"+model+"' "; }
					 
		     sqlPre = sqlPre + sWherePre;		
		
             //out.println(sqlPre );
             ResultSet rsPre=statePre.executeQuery(sqlPre);
	         //if (rsF.next())
		     if (rsPre.next())
		    {out.println(rsPre.getInt("FMQTY"));}
			else
			{out.println("N/A");}
		     rsPre.close();
		     statePre.close();
		 } //end of try
         catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());
        } 
	    %>
	  </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <% //Week 1 Forecast  
        
            Statement stateFW1=con.createStatement();   
		
		    try
		   {   
             String sqlFW1 = "select w.FWQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW1 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			   //                       "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD= '"+fmPrjCode+"'  and w.FWWEEK = '1' ";
	        if (locale==null || locale.equals("--")) {   sWhereFW1 = sWhereFW1 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		    else { sWhereFW1 = sWhereFW1 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereFW1 = sWhereFW1 + "and f.FMCOMP !=  'ALL'  "; }
		    else { sWhereFW1 = sWhereFW1 + "and f.FMCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereFW1 = sWhereFW1 + "and to_char(f.FMREG) != 'ALL'  "; }
		    else { sWhereFW1 = sWhereFW1 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
			 
		     sqlFW1 = sqlFW1+ sWhereFW1;		
		
            //out.println(sqlFW1);
            ResultSet rsFW1=stateFW1.executeQuery(sqlFW1);
			if (rsFW1.next())
			{out.println(rsFW1.getInt("FWQTY"));}
			// 不存在 Week_Forecast 內有定義
			else
			{out.println("N/A");}
			// End of else
			rsFW1.close();
			stateFW1.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <% //Week 2 Forecast  
        
            Statement stateFW2=con.createStatement();   
		
		    try
		   {   
             String sqlFW2 = "select w.FWQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PSALES_FORE_WEEK w, PIMASTER m ";
		     String sWhereFW2 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			    //                       "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD= '"+fmPrjCode+"'  and w.FWWEEK = '2' ";
									   
			if (locale==null || locale.equals("--")) {   sWhereFW2 = sWhereFW2 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		    else { sWhereFW2 = sWhereFW2 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereFW2 = sWhereFW2 + "and f.FMCOMP !=  'ALL'  "; }
		    else { sWhereFW2 = sWhereFW2 + "and f.FMCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereFW2 = sWhereFW2 + "and to_char(f.FMREG) != 'ALL'  "; }
		    else { sWhereFW2 = sWhereFW2 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
									   
		     sqlFW2 = sqlFW2+ sWhereFW2;		
		
            //out.println(sqlFW1);
            ResultSet rsFW2=stateFW2.executeQuery(sqlFW2);
			if (rsFW2.next())
			{out.println(rsFW2.getInt("FWQTY"));}
			else
			{out.println("N/A");}
			rsFW2.close();
			stateFW2.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="2"> 
          <% //Week 3 Forecast  
        
            Statement stateFW3=con.createStatement();   
		
		    try
		   {   
             String sqlFW3 = "select w.FWQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m ";
		     String sWhereFW3 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			       //                    "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD= '"+fmPrjCode+"'  and w.FWWEEK = '3' ";
			 
			if (locale==null || locale.equals("--")) {   sWhereFW3 = sWhereFW3 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		    else { sWhereFW3 = sWhereFW3 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereFW3 = sWhereFW3 + "and f.FMCOMP !=  'ALL'  "; }
		    else { sWhereFW3 = sWhereFW3 + "and f.FMCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereFW3 = sWhereFW3 + "and to_char(f.FMREG) != 'ALL'  "; }
		    else { sWhereFW3 = sWhereFW3 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }						   
		  
		     sqlFW3 = sqlFW3+ sWhereFW3;		
		
            //out.println(sqlFW1);
            ResultSet rsFW3=stateFW3.executeQuery(sqlFW3);
			if (rsFW3.next())
			{out.println(rsFW3.getInt("FWQTY"));}
			else
			{out.println("N/A");}
			rsFW3.close();
			stateFW3.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="2"> 
          <% //Week 4 Forecast  
        
            Statement stateFW4=con.createStatement();   
		
		    try
		   {   
             String sqlFW4 = "select w.FWQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m ";
		     String sWhereFW4 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			 //                          "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD= '"+fmPrjCode+"'  and w.FWWEEK = '4' ";
									   
			if (locale==null || locale.equals("--")) {   sWhereFW4 = sWhereFW4 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		    else { sWhereFW4 = sWhereFW4 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereFW4 = sWhereFW4 + "and f.FMCOMP !=  'ALL'  "; }
		    else { sWhereFW4 = sWhereFW4 + "and f.FMCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereFW4 = sWhereFW4 + "and to_char(f.FMREG) != 'ALL'  "; }
		    else { sWhereFW4 = sWhereFW4 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
									   
		     sqlFW4 = sqlFW4+ sWhereFW4;		
		
            //out.println(sqlFW1);
            ResultSet rsFW4=stateFW4.executeQuery(sqlFW4);
			if (rsFW4.next())
			{out.println(rsFW4.getInt("FWQTY"));}
			else
			{out.println("N/A");}
			rsFW4.close();
			stateFW4.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td><div align="right"><font color="#1B0378" size="2"> 
          <% //Week 5 Forecast  
        
            Statement stateFW5=con.createStatement();   
		
		    try
		   {   
             String sqlFW5 = "select w.FWQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m ";
		     String sWhereFW5 = "where m.PROJECTCODE = f.FMPRJCD and w.FWPRJCD = f.FMPRJCD  "+
			                           "and w.FWCOMP = f.FMCOMP and w.FWREG= f.FMREG and w.FWCOUN = f.FMCOUN  "+
                                       "and w.FWYEAR = f.FMYEAR and w.FWMONTH = f.FMMONTH  "+
			    //                       "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                               "and f.FMYEAR = '"+YearFr+"' and f.FMMONTH=  '"+MonthFr+"'  and w.FWPRJCD= '"+fmPrjCode+"' and w.FWWEEK = '5' ";
									   
			if (locale==null || locale.equals("--")) {   sWhereFW5 = sWhereFW5 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		    else { sWhereFW5 = sWhereFW5 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		    if (compNo==null || compNo.equals("--")) {   sWhereFW5 = sWhereFW5 + "and f.FMCOMP !=  'ALL'  "; }
		    else { sWhereFW5 = sWhereFW5 + "and f.FMCOMP =  '"+compNo+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhereFW5 = sWhereFW5 + "and to_char(f.FMREG) != 'ALL'  "; }
		    else { sWhereFW5 = sWhereFW5 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
									   
		     sqlFW5 = sqlFW5+ sWhereFW5;		
		
            //out.println(sqlFW1);
            ResultSet rsFW5=stateFW5.executeQuery(sqlFW5);
			if (rsFW5.next())
			{out.println(rsFW5.getInt("FWQTY"));}
			else
			{out.println("N/A");}
			rsFW5.close();
			stateFW5.close();
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		 %>
          </font></div></td>
      <td bgcolor="#CCFFFF"><div align="right"><font color="#1B0378" size="2"><%=(((rs_data = rs.getObject("FMQTY"))==null || rs.wasNull())?"":rs_data)%></font></div></td>
      <% //%>
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
			                 //          "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
							//		   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH)=  "+monNext+"  and w.FWPRJCD =  '"+fmPrjCode+"'  and w.FWWEEK = '1'  ";
									   
			 if (compNo==null || compNo.equals("--")) {  sWhereFNW1 = sWhereFNW1 + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereFNW1 = sWhereFNW1 + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereFNW1 = sWhereFNW1 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereFNW1 =sWhereFNW1 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereFNW1 = sWhereFNW1 + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereFNW1 = sWhereFNW1 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereFNW1 = sWhereFNW1 +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereFNW1 = sWhereFNW1 +  "and m.SALESCODE =  '"+model+"' "; }						   
									   
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
			          //               "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
					 //				   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH)=  "+monNext+" and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '2' ";
									   
			 if (compNo==null || compNo.equals("--")) {  sWhereFNW2 = sWhereFNW2 + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereFNW2 = sWhereFNW2 + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereFNW2 = sWhereFNW2 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereFNW2 =sWhereFNW2 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereFNW2 = sWhereFNW2 + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereFNW2 = sWhereFNW2 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereFNW2 = sWhereFNW2 +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereFNW2 = sWhereFNW2 +  "and m.SALESCODE =  '"+model+"' "; }						   
									   
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
			      //                     "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
				//					   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH)=  "+monNext+"  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '3' ";
									   
			 if (compNo==null || compNo.equals("--")) {  sWhereFNW3 = sWhereFNW3 + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereFNW3 = sWhereFNW3 + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereFNW3 = sWhereFNW3 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereFNW3 =sWhereFNW3 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereFNW3 = sWhereFNW3 + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereFNW3 = sWhereFNW3 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereFNW3 = sWhereFNW3 +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereFNW3 = sWhereFNW3 +  "and m.SALESCODE =  '"+model+"' "; }						   
									   
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
	   </font></div>
	  </td>
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
			   //                        "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  "+
				//					   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH)=  "+monNext+"  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '4' ";
									   
			 if (compNo==null || compNo.equals("--")) {  sWhereFNW4 = sWhereFNW4 + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereFNW4 = sWhereFNW4 + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereFNW4 = sWhereFNW4 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereFNW4 =sWhereFNW4 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereFNW4 = sWhereFNW4 + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereFNW4 = sWhereFNW4 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereFNW4 = sWhereFNW4 +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereFNW4 = sWhereFNW4 +  "and m.SALESCODE =  '"+model+"' "; }				   
									   
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
			      //                     "and f.FMCOMP =  '"+compNo+"'  and f.FMREG = '"+regionNo+"'  and f.FMCOUN =  '"+locale+"'  " +
				//					   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH) =  "+monNext+"  and w.FWPRJCD = '"+fmPrjCode+"'  and w.FWWEEK = '5' ";
									   
			 if (compNo==null || compNo.equals("--")) {  sWhereFNW5 = sWhereFNW5 + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereFNW5 = sWhereFNW5 + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereFNW5 = sWhereFNW5 + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereFNW5 =sWhereFNW5 + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereFNW5 = sWhereFNW5 + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereFNW5 = sWhereFNW5 +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereFNW5 = sWhereFNW5 +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereFNW5 = sWhereFNW5 +  "and m.SALESCODE =  '"+model+"' "; } 						   
									   
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
		     String sWhereNTTL= "where m.PROJECTCODE = f.FMPRJCD " +
			                           "and m.PROJECTCODE =  '"+rs.getString("PROJECTCODE")+"' "+  // 加入 Model (PROJECTCODE為條件);
		                               "and f.FMYEAR = '"+yearNext+"' and to_number(f.FMMONTH)=  "+monNext+"  ";
		     
			 if (compNo==null || compNo.equals("--")) {  sWhereNTTL = sWhereNTTL + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereNTTL = sWhereNTTL + "and f.FMCOMP =  '"+compNo+"'  "; }					   
			 if (locale==null || locale.equals("--")) {   sWhereNTTL = sWhereNTTL + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereNTTL =sWhereNTTL + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}						   
		     if (regionNo==null || regionNo.equals("--")) { sWhereNTTL = sWhereNTTL + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereNTTL = sWhereNTTL +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
			 if (model==null || model.equals("--")) { sWhereNTTL = sWhereNTTL +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereNTTL = sWhereNTTL +  "and m.SALESCODE =  '"+model+"' "; }
					 
		     sqlNTTL = sqlNTTL + sWhereNTTL;		
		
             //out.println(sqlNTTL );
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
      <% // %>
      <td bgcolor="#FFCCFF" > <div align="right"><font color="#1B0378" size="2"> 
          <%
	     Statement stateFore=con.createStatement();   
		 
         String sqlF = "select f.FMQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m ";
		 String sWhereF= "where m.PROJECTCODE = f.FMPRJCD  " +
		    //                       "and f.FMCOMP =  '"+compNo+"'  and to_char(f.FMREG) = '"+regionNo+"'  and to_char(f.FMCOUN) =  '"+locale+"'  " +
		                           "and f.FMYEAR = '"+yearNext+"'  and to_number(f.FMMONTH)=  "+monNext2+"  ";
								   
		 if (locale==null || locale.equals("--")) {   sWhereF = sWhereF + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		 else { sWhereF = sWhereF + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		 if (compNo==null || compNo.equals("--")) {   sWhereF = sWhereF + "and f.FMCOMP !=  'ALL'  "; }
		 else { sWhereF = sWhereF + "and f.FMCOMP =  '"+compNo+"'  "; }
         if (regionNo==null || regionNo.equals("--")) { sWhereF = sWhereF + "and to_char(f.FMREG) != 'ALL'  "; }
		 else { sWhereF = sWhereF +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
		 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		 else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }						   
								   
		 sqlF = sqlF + sWhereF;		
		
        //out.println(sql);
         ResultSet rsF=stateFore.executeQuery(sqlF);
	     if (rsF.next())
		 {out.println(rsF.getInt("FMQTY"));}
		 else
		 {out.println("N/A");}
		 rsF.close();
		 stateFore.close();
	%>
          </font></div></td>
    </tr>
    <tr bordercolor="#000000" > 
      <td nowrap><font size="2" color="#1B0378">實際產出</font> </td>
      <td><div align="right"><font color="#1B0378" size="2"> 
	   <%
	       String strPrjCD = rs.getString("PROJECTCODE");
	       //String strShpYM = YearFr+MonthFr; monthPre
		        int yearPreInt = 0;
		   String yearPre = "";
		   
		   // 處理前一年月問題 //			
			if (monCurr == 1)
			{
			  yearPreInt = yearCH-1;
			  YearFr = Integer.toString(yearPreInt);
		    }
		   // 處理前一年月問題 //
		    String strShpYM = YearFr+monthPre; 
		   
	        Statement state=con.createStatement();
  
           String sqlMES = "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
           String sWhereMES = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpYM+"'  "+
                                     "and p.MPROJ = '"+strPrjCD+"'   ";
           sqlMES = sqlMES + sWhereMES;
  
           ResultSet rsMESOut=state.executeQuery(sqlMES);
  
           if (rsMESOut.next())
		   {out.println(rsMESOut.getInt("COUNT"));}
		   rsMESOut.close();
		   state.close();
	%>
	</font></div>
	 </td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <!--%
		      try
			  {
	           String strPrjCDW1 = rs.getString("PROJECTCODE");
	           String strShpYMW1 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH=con.createStatement();
				
				String sqlITH1 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH1 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='1' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH1 = sWhereITH1 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH1 = sWhereITH1 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH1 = sWhereITH1 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		        else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH1 = sqlITH1 + sWhereITH1;
				
				ResultSet rsW1=stateITH.executeQuery(sqlITH1);
                if (rsW1.next())
				{  fwDatFr = rsW1.getString("FWDATFR");
				    fwDatTo = rsW1.getString("FWDATTO");}
				 rsW1.close();
				 
				 fwDatFr = strShpYMW1 + fwDatFr;
				 fwDatTo = strShpYMW1 + fwDatTo;
  
                String sqlITH = "select sum(abs(TQTY)) as SUMW1 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereITH= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B' and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW1+"'  ";
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
        %-->
		<%	         
		    try
			  {
	           String strPrjCDM1 = rs.getString("PROJECTCODE");
	           String strShpYMM1 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES1=con.createStatement();
				String sqlMES1 = "select FWDATFR, FWDATTO from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
				String sWhereMES1="where m.PROJECTCODE = f.FWPRJCD "+
				  //                             "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='1' ";
												 
		         if (locale==null || locale.equals("--")) {   sWhereMES1 = sWhereMES1 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		         else { sWhereMES1 = sWhereMES1 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		         if (compNo==null || compNo.equals("--")) {   sWhereMES1 = sWhereMES1 + "and f.FWCOMP !=  'ALL'  "; }
		         else { sWhereMES1 = sWhereMES1 + "and f.FWCOMP =  '"+compNo+"'  "; }
                 if (regionNo==null || regionNo.equals("--")) { sWhereMES1 = sWhereMES1 + "and to_char(f.FWREG) != 'ALL'  "; }
		         else { sWhereMES1 = sWhereMES1 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		         else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
				 
				 sqlMES1 = sqlMES1 + sWhereMES1;				 
				
				ResultSet rsM1=stateMES1.executeQuery(sqlMES1);
                if (rsM1.next())
				{  fwDatFr = rsM1.getString("FWDATFR");
				    fwDatTo = rsM1.getString("FWDATTO");}
				 rsM1.close();
				 
				 fwDatFr = strShpYMM1 + fwDatFr;
				 fwDatTo = strShpYMM1 + fwDatTo;        
  
           String sqlM1= "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
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
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <%	         
		    try
			  {
	           String strPrjCDM2 = rs.getString("PROJECTCODE");
	           String strShpYMM2 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES2=con.createStatement();
				
				String sqlMES2 = "select FWDATFR, FWDATTO from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
				String sWhereMES2="where m.PROJECTCODE = f.FWPRJCD "+
				  //                             "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='2' ";
												 
		         if (locale==null || locale.equals("--")) {   sWhereMES2 = sWhereMES2 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		         else { sWhereMES2 = sWhereMES2 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		         if (compNo==null || compNo.equals("--")) {   sWhereMES2 = sWhereMES2 + "and f.FWCOMP !=  'ALL'  "; }
		         else { sWhereMES2 = sWhereMES2 + "and f.FWCOMP =  '"+compNo+"'  "; }
                 if (regionNo==null || regionNo.equals("--")) { sWhereMES2 = sWhereMES2 + "and to_char(f.FWREG) != 'ALL'  "; }
		         else { sWhereMES2 = sWhereMES2 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
	             else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
				 
				 sqlMES2 = sqlMES2 + sWhereMES2;
				
				ResultSet rsM2=stateMES2.executeQuery(sqlMES2);
                if (rsM2.next())
				{  fwDatFr = rsM2.getString("FWDATFR");
				    fwDatTo = rsM2.getString("FWDATTO");}
				 rsM2.close();
				 
				 fwDatFr = strShpYMM2 + fwDatFr;
				 fwDatTo = strShpYMM2 + fwDatTo;        
  
           String sqlM2= "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
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
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <%	         
		    try
			  {
	           String strPrjCDM3 = rs.getString("PROJECTCODE");
	           String strShpYMM3 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES3=con.createStatement();
				
				String sqlMES3 = "select FWDATFR, FWDATTO from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
				String sWhereMES3="where m.PROJECTCODE = f.FWPRJCD "+
				  //                             "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='3' ";
												 
		         if (locale==null || locale.equals("--")) {   sWhereMES3 = sWhereMES3 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		         else { sWhereMES3 = sWhereMES3 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		         if (compNo==null || compNo.equals("--")) {   sWhereMES3 = sWhereMES3 + "and f.FWCOMP !=  'ALL'  "; }
		         else { sWhereMES3 = sWhereMES3 + "and f.FWCOMP =  '"+compNo+"'  "; }
                 if (regionNo==null || regionNo.equals("--")) { sWhereMES3 = sWhereMES3 + "and to_char(f.FWREG) != 'ALL'  "; }
		         else { sWhereMES3 = sWhereMES3 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		         else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
				 
				 sqlMES3 = sqlMES3 + sWhereMES3;
				
				ResultSet rsM3=stateMES3.executeQuery(sqlMES3);
                if (rsM3.next())
				{  fwDatFr = rsM3.getString("FWDATFR");
				    fwDatTo = rsM3.getString("FWDATTO");}
				 rsM3.close();
				 
				 fwDatFr = strShpYMM3 + fwDatFr;
				 fwDatTo = strShpYMM3 + fwDatTo;        
  
           String sqlM3= "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
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
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <%	         
		    try
			  {
	           String strPrjCDM4 = rs.getString("PROJECTCODE");
	           String strShpYMM4 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES4=con.createStatement();
				
				String sqlMES4 = "select FWDATFR, FWDATTO from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
				String sWhereMES4="where m.PROJECTCODE = f.FWPRJCD "+
				  //                             "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='4' ";
												 
		         if (locale==null || locale.equals("--")) {   sWhereMES4 = sWhereMES4 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		         else { sWhereMES4 = sWhereMES4 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		         if (compNo==null || compNo.equals("--")) {   sWhereMES4 = sWhereMES4 + "and f.FWCOMP !=  'ALL'  "; }
		         else { sWhereMES4 = sWhereMES4 + "and f.FWCOMP =  '"+compNo+"'  "; }
                 if (regionNo==null || regionNo.equals("--")) { sWhereMES4 = sWhereMES4 + "and to_char(f.FWREG) != 'ALL'  "; }
		         else { sWhereMES4 = sWhereMES4 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		         else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
				 
				 sqlMES4 = sqlMES4 + sWhereMES4;
				
				ResultSet rsM4=stateMES4.executeQuery(sqlMES4);
                if (rsM4.next())
				{  fwDatFr = rsM4.getString("FWDATFR");
				    fwDatTo = rsM4.getString("FWDATTO");}
				 rsM4.close();
				 
				 fwDatFr = strShpYMM4 + fwDatFr;
				 fwDatTo = strShpYMM4 + fwDatTo;        
  
           String sqlM4= "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
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
      <td> <div align="right"><font color="#1B0378" size="2"> 
           <%	         
		    try
			  {
	           String strPrjCDM5 = rs.getString("PROJECTCODE");
	           String strShpYMM5 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateMES5=con.createStatement();
				
				String sqlMES5 = "select FWDATFR, FWDATTO from WSADMIN.PSALES_FORE_WEEK f, WSADMIN.PIMASTER m ";
				String sWhereMES5="where m.PROJECTCODE = f.FWPRJCD "+
				  //                             "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                         "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='5' ";
												 
		         if (locale==null || locale.equals("--")) {   sWhereMES5 = sWhereMES5 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		         else { sWhereMES5 = sWhereMES5 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		         if (compNo==null || compNo.equals("--")) {   sWhereMES5 = sWhereMES5 + "and f.FWCOMP !=  'ALL'  "; }
		         else { sWhereMES5 = sWhereMES5 + "and f.FWCOMP =  '"+compNo+"'  "; }
                 if (regionNo==null || regionNo.equals("--")) { sWhereMES5 = sWhereMES5 + "and to_char(f.FWREG) != 'ALL'  "; }
		         else { sWhereMES5 = sWhereMES5 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				 if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		         else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
				 
				 sqlMES5 = sqlMES5 + sWhereMES5;
				
				ResultSet rsM5=stateMES5.executeQuery(sqlMES5);
                if (rsM5.next())
				{  fwDatFr = rsM5.getString("FWDATFR");
				    fwDatTo = rsM5.getString("FWDATTO");}
				 rsM5.close();
				 
				 fwDatFr = strShpYMM5 + fwDatFr;
				 fwDatTo = strShpYMM5 + fwDatTo;        
  
           String sqlM5= "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
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
      <td bgcolor="#CCFFFF"><div align="right"><font color="#1B0378" size="2"> 
          &nbsp;
          </font></div></td>
	   <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td bgcolor="#FFFFCC"><font size="-1">&nbsp;</font></td>
      <td bgcolor="#FFCCFF" ><font size="-1">&nbsp;</font> </td>      
    </tr>
    <tr bordercolor="#000000"> 
      <!--% <td ><font size="2" color="#1B0378">(<%=(((rs_data = rs.getObject("PROJECTCODE"))==null || rs.wasNull())?"":rs_data)%>)</font></td> %-->
      <td height="20" nowrap><font size="2" color="#1B0378">實際出貨</font></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
          <!--%
	       String strPrjCD = rs.getString("PROJECTCODE");
	       String strShpYM = YearFr+MonthFr;
		   
	        Statement state=con.createStatement();
  
           String sqlMES = "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
           String sWhereMES = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpYM+"'  "+
                                     "and p.MPROJ = '"+strPrjCD+"'   ";
           sqlMES = sqlMES + sWhereMES;
  
           ResultSet rsMESOut=state.executeQuery(sqlMES);
  
           if (rsMESOut.next())
		   {out.println(rsMESOut.getInt("COUNT"));}
		   rsMESOut.close();
		   state.close();
	%-->&nbsp;
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
	      <%
		      try
			  {
	           String strPrjCDW1 = rs.getString("PROJECTCODE");
	           String strShpYMW1 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH=con.createStatement();
				
				String sqlITH1 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH1 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='1' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH1 = sWhereITH1 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH1 = sWhereITH1 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH1 = sWhereITH1 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH1 = sWhereITH1 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		        else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH1 = sqlITH1 + sWhereITH1;
				
				ResultSet rsW1=stateITH.executeQuery(sqlITH1);
                if (rsW1.next())
				{  fwDatFr = rsW1.getString("FWDATFR");
				    fwDatTo = rsW1.getString("FWDATTO");}
				 rsW1.close();
				 
				 fwDatFr = strShpYMW1 + fwDatFr;
				 fwDatTo = strShpYMW1 + fwDatTo;
  
                String sqlITH = "select sum(abs(TQTY)) as SUMW1 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereITH= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B' and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW1+"'  ";
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
      <td> <div align="right"><font color="#1B0378" size="2"> 
	      <%
		      try
			  {
	           String strPrjCDW2 = rs.getString("PROJECTCODE");
	           String strShpYMW2 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH2=con.createStatement();
				
				String sqlITH2 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH2 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='2' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH2 = sWhereITH2 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH2 = sWhereITH2 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH2 = sWhereITH2 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH2 = sWhereITH2 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH2 = sWhereITH2 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH2 = sWhereITH2 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		        else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH2 = sqlITH2 + sWhereITH2;
				
				ResultSet rsW2=stateITH2.executeQuery(sqlITH2);
                if (rsW2.next())
				{  fwDatFr = rsW2.getString("FWDATFR");
				    fwDatTo = rsW2.getString("FWDATTO");}
				 rsW2.close();
				 
				 fwDatFr = strShpYMW2 + fwDatFr;
				 fwDatTo = strShpYMW2 + fwDatTo;
  
                String sqlIT2 = "select sum(abs(TQTY)) as SUMW2 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereIT2= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B' and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW2+"'  ";
                 sqlIT2 = sqlIT2 + sWhereIT2;
  
                ResultSet rsIT2=stateITH2.executeQuery(sqlIT2);
  
                if (rsIT2.next())
				{out.println(rsIT2.getInt("SUMW2"));}
				rsIT2.close();
				stateITH2.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
	  
          
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
	      <%
		      try
			  {
	           String strPrjCDW3 = rs.getString("PROJECTCODE");
	           String strShpYMW3 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH3=con.createStatement();
				
				String sqlITH3 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH3 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='3' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH3 = sWhereITH3 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH3 = sWhereITH3 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH3 = sWhereITH3 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH3 = sWhereITH3 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH3 = sWhereITH3 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH3 = sWhereITH3 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		        else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH3 = sqlITH3 + sWhereITH3;
				
				ResultSet rsW3=stateITH3.executeQuery(sqlITH3);
                if (rsW3.next())
				{  fwDatFr = rsW3.getString("FWDATFR");
				    fwDatTo = rsW3.getString("FWDATTO");}
				 rsW3.close();
				 
				 fwDatFr = strShpYMW3 + fwDatFr;
				 fwDatTo = strShpYMW3 + fwDatTo;
  
                String sqlIT3 = "select sum(abs(TQTY)) as SUMW3 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereIT3= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B'  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW3+"'  ";
                 sqlIT3 = sqlIT3 + sWhereIT3;
  
                ResultSet rsIT3=stateITH3.executeQuery(sqlIT3);
  
                if (rsIT3.next())
				{out.println(rsIT3.getInt("SUMW3"));}
				rsIT3.close();
				stateITH3.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>
	  
          
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
	       <%
		      try
			  {
	           String strPrjCDW4 = rs.getString("PROJECTCODE");
	           String strShpYMW4 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH4=con.createStatement();
				
				String sqlITH4 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH4 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='4' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH4 = sWhereITH4 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH4 = sWhereITH4 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH4 = sWhereITH4 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH4 = sWhereITH4 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH4 = sWhereITH4 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH4 = sWhereITH4 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
	        	else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH4 = sqlITH4 + sWhereITH4;
				
				ResultSet rsW4=stateITH4.executeQuery(sqlITH4);
                if (rsW4.next())
				{  fwDatFr = rsW4.getString("FWDATFR");
				    fwDatTo = rsW4.getString("FWDATTO");}
				 rsW4.close();
				 
				 fwDatFr = strShpYMW4 + fwDatFr;
				 fwDatTo = strShpYMW4 + fwDatTo;
  
                String sqlIT4 = "select sum(abs(TQTY)) as SUMW4 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereIT4= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B'  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW4+"'  ";
                 sqlIT4 = sqlIT4 + sWhereIT4;
  
                ResultSet rsIT4=stateITH4.executeQuery(sqlIT4);
  
                if (rsIT4.next())
				{out.println(rsIT4.getInt("SUMW4"));}
				rsIT4.close();
				stateITH4.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>  
         
          </font></div></td>
      <td> <div align="right"><font color="#1B0378" size="2"> 
	       <%
		      try
			  {
	           String strPrjCDW5 = rs.getString("PROJECTCODE");
	           String strShpYMW5 = YearFr+MonthFr;
			   
			   String fwDatFr = "";
			   String fwDatTo = "";
		   
	            Statement stateITH5=con.createStatement();
				
				String sqlITH5 = "select FWDATFR, FWDATTO from PSALES_FORE_WEEK f, PIMASTER m ";
				String sWhereITH5 = "where m.PROJECTCODE = f.FWPRJCD "+
				          //                        "and f.FWCOMP =  '"+compNo+"'  and to_char(f.FWREG) = '"+regionNo+"'  and to_char(f.FWCOUN) =  '"+locale+"'  " +
		                                          "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  and f.FWPRJCD= '"+fmPrjCode+"'  and  f.FWWEEK='5' ";
												  
				if (locale==null || locale.equals("--")) {   sWhereITH5 = sWhereITH5 + "and to_char(f.FWCOUN) !=  'ALL'  "; }
		        else { sWhereITH5 = sWhereITH5 + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
		        if (compNo==null || compNo.equals("--")) {   sWhereITH5 = sWhereITH5 + "and f.FWCOMP !=  'ALL'  "; }
		        else { sWhereITH5 = sWhereITH5 + "and f.FWCOMP =  '"+compNo+"'  "; }
                if (regionNo==null || regionNo.equals("--")) { sWhereITH5 = sWhereITH5 + "and to_char(f.FWREG) != 'ALL'  "; }
		        else { sWhereITH5 = sWhereITH5 +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
				if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		        else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
										   
			    sqlITH5 = sqlITH5 + sWhereITH5;
				
				ResultSet rsW5=stateITH5.executeQuery(sqlITH5);
                if (rsW5.next())
				{  fwDatFr = rsW5.getString("FWDATFR");
				    fwDatTo = rsW5.getString("FWDATTO");}
				 rsW5.close();
				 
				 fwDatFr = strShpYMW5 + fwDatFr;
				 fwDatTo = strShpYMW5 + fwDatTo;
  
                String sqlIT5 = "select sum(abs(TQTY)) as SUMW5 from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereIT5= "where trim(m.tprod) = p.MITEM  and m.TTYPE= 'B'  and  m.TTDTE between '"+fwDatFr+"'  and '"+fwDatTo+"'  "+
                                                 "and p.MPROJ = '"+strPrjCDW5+"'  ";
                 sqlIT5 = sqlIT5 + sWhereIT5;
  
                ResultSet rsIT5=stateITH5.executeQuery(sqlIT5);
  
                if (rsIT5.next())
				{out.println(rsIT5.getInt("SUMW5"));}
				rsIT5.close();
				stateITH5.close();	       
			 } //end of try
          catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
        %>      
         
          </font></div></td>
      <td bgcolor="#CCFFFF"><div align="right"><font color="#1B0378" size="2"> 
	      <%
		      try
			  {
	           String strPrjCDActTTL = rs.getString("PROJECTCODE");
	           String strShpYMActTTL = YearFr+MonthFr;		  		  
		   
	            Statement stateActTTL=con.createStatement();
				 
                String sqlActTTL = "select sum(abs(TQTY)) as SUMActTTL from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";
                String sWhereActTTL= "where trim(m.tprod) = p.MITEM and m.TTYPE= 'B' and  substr(m.TTDTE,1,6) = '"+strShpYMActTTL+"'  "+
                                                     "and p.MPROJ = '"+strPrjCDActTTL+"'  ";
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
	  <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td><font size="-1">&nbsp;</font></td>
      <td bgcolor="#FFFFCC"><font size="-1">&nbsp;</font></td>
      <td bgcolor="#FFCCFF" ><font size="2">&nbsp;</font> </td>
    </tr>
    <%
       rs1__index++;
       rs_hasData = rs.next();
     }
	 rs.close();
	 statement.close();
   } //end of try
   catch (Exception e)
   {
       out.println("Exception:"+e.getMessage());
   } 
 }   // End of if ( 選取年月 >= 目前年月) //
%>
  </table>
  <font size="-1">
  <!--% 
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
	    %-->
  </font>
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
