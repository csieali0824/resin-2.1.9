<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<!--=============以下區段為安全認證機制==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%-->
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
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
  function setSubmit(URL)
 {  
  document.MYFORM.action=URL;
  document.MYFORM.submit();
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
<div align="right">
  <%
       String MonthDay="";
	   String HH24="";
	   String DateString="";
	        int DateHour=0;
			int DateMinute=0;
	   
      DateString = dateBean.getYearMonthDay();
	  DateHour = dateBean.getHour();
	  DateMinute = dateBean.getMinute();
	  	   
       Statement stmentUT=con.createStatement();
	   String sSqlUT = "select max(substr(mcarton_no,9,8)) as MONTHDAY,max(to_char(in_station_time,'HH24')) as Hour24 from MES_WIP_TRACKING where  group_name='AC_PACKING' and pallet_full_flag='Y'  and to_char(in_station_time,'YYYYMMDD') <= '"+DateString+"' ";            
	   ResultSet rsUT=stmentUT.executeQuery(sSqlUT);
	   if (rsUT.next())
	  { MonthDay = rsUT.getString("MONTHDAY");
	     HH24 =  rsUT.getString("Hour24");
		 if (DateHour>17) { HH24 = "17";}		 		
	  }
	 // out.println(MonthDay);
	   String dateMonStr = MonthDay.substring(4, 6);   // 改抓系統資料更新時間
	   String dateDayStr = MonthDay.substring(6, 8);       // 由MES 系統
	  // out.println(dateMonStr);
	  //   out.println(dateDayStr);
      stmentUT.close();
	  rsUT.close();
	 //out.println(sSqlUT);
	 //out.println(DateHour);
	 //out.println(DateMinute);

       int dateIntYear=dateBean.getYear();
	   int dateIntMonth=dateBean.getMonth();
	   int dateIntDay=dateBean.getDay();
	   String dateYearStr = Integer.toString(dateIntYear);
	   //String dateMonStr = Integer.toString(dateIntMonth);
	   //String dateDayStr = Integer.toString(dateIntDay);

%>
  <strong><em>資料最後更新:<%=dateMonStr%>月<%=dateDayStr%>日<%=HH24%>時</em></strong> </div>
<div align="center"></div>
<FORM ACTION="../jsp/WSProductionStatus.jsp" METHOD="post" NAME="MYFORM" >
<table width="100%" border="0">
  <tr>
    <td colspan="2"><div align="center"><strong><font color="#0000FF" size="+1" face="Arial">Taipei 
        DBTEL Industry Co.,Ltd.</font></strong></div></td>
  </tr>
  <tr>
    <!--%<td width="26%">&nbsp; </td> %-->
	<td width="74%"><div align="center"><strong><font color="#0000FF" size="+2" face="Arial">Production status 
      of
 <%     
      String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
	   String compNo=request.getParameter("COMPNO");
       String regionNo=request.getParameter("REGION");
       String locale=request.getParameter("LOCALE");
       String YearFr=request.getParameter("YEARFR");
       String MonthFr=request.getParameter("MONTHFR"); 
       String model=request.getParameter("MODEL"); 
	   String meng = "";
       String month_s = "";
	   String meng_s = "";	 
	   
	   String  preMeng = "";
       String  preMonth_s = "";
       String  preMeng_s = "";	   
	   
	   String sWhere = "";
	        int rowCnt = 0;
   
       String monthPre = "";
	   // 宣告加總變數區 //
	       int sumPlan = 0;
		   int sumPreOH = 0;
		   int sumFinish = 0;
		   int sumFmQty = 0;
		   int sumShipped = 0;
		   int sumBalance = 0;
		   int sumOnAC = 0;
		   int sumCurrOH = 0;
		   
	   
       int monPre = 0;  
	         
	   if (MonthFr==null)
	  {}
	  else
	  {  
	     int CurMon = Integer.parseInt(MonthFr);   // 2004/02/12修改 為系統月份
		 //int CurMon =  dateIntMonth;
	     // 取前一個月 //	  
      
	     if (CurMon == 1)
	     { monPre = 12; }
	     else { monPre = CurMon - 1;}
	     // 若前月<= 9月,則字串取得 補零
	     if (monPre<=9){monthPre = '0'+ Integer.toString(monPre);}
	     else {monthPre = Integer.toString(monPre);}
	  
	     Statement stateP=con.createStatement();
	    String sqlP = "select MENG, MONTH_S, MENG_S from WSADMIN.WSMONTH_CODE where  MMON_AR =  '"+monthPre+"'  ";
	    ResultSet rsP=stateP.executeQuery(sqlP);
	    if (rsP.next())
	   {
	       preMeng= rsP.getString("MENG");
	       preMonth_s= rsP.getString("MONTH_S");
	       preMeng_s =rsP.getString("MENG_S");
	    }
	    stateP.close();
	    rsP.close();
	  
	     try
        {   
	       Statement stateM=con.createStatement();
	       String sqlM = "select MENG, MONTH_S, MENG_S from WSADMIN.WSMONTH_CODE where  MMON_AR =  '"+MonthFr+"'  ";
		   ResultSet rsM=stateM.executeQuery(sqlM);
		   if (rsM.next())
		   {
		     meng = rsM.getString("MENG");
		     month_s = rsM.getString("MONTH_S");
			 meng_s = rsM.getString("MENG_S");
		     out.println(rsM.getString("MENG"));
		   }
		   else
		   {}
		   rsM.close();
		   stateM.close();
		 } //end of try
         catch (Exception e)
        {
          out.println("Exception:"+e.getMessage());		  
        }  
	  } 
	%>
   </font></strong></div></td>	
  </tr>
</table>
<%
   int rs1__numRows = 20;      //每一頁的顯示筆數
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
%>
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>
  &nbsp;
<%     
    /*String compNo=request.getParameter("COMPNO");
    String regionNo=request.getParameter("REGION");
    String locale=request.getParameter("LOCALE");
    String YearFr=request.getParameter("YEARFR");
    String MonthFr=request.getParameter("MONTHFR"); 
    String model=request.getParameter("MODEL");    */
  
  //String nonMonthData = "No";
  //out.println(regionNo);
  //out.println(locale);
  String fmPrjCode = "";
       int rowSpanCnt = 0;
	   int rowSpan = 0;
	   int finishQty = 0;     // 宣告 Finish 產出數初值  //
	   int balanceQty = 0;  // 宣告 Balance 初值  //
	   
  String mItem = null;                       // 宣告 其它機種 初值  //
  String mItemGet = "";                    // 宣告 其它機種組合 初值  //
       int mItemGetLength = 0;          // 宣告 其它機種 字串長度 初值  //
	   
   
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
		  monNext2 = 1;	}
		else
		{ monNext =1;
		  monNext2 = 2;}
	  }        

       try
      {   
        Statement statH=con.createStatement();
  
        String sqlH = "select count(*) as COUNT from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m ";
        String sWhereH = "where m.PROJECTCODE = f.FMPRJCD " + 
		                             "and f.FMVER = (select max(FMVER) from PSALES_FORE_MONTH) "+     // 2003/12/08
                                     "and f.FMCOMP =  '"+compNo+"'  " + 
                                     "and to_char(lpad(f.FMREG,2,0))= '"+regionNo+"'  "+
                                     "and to_char(f.FMCOUN) =  '"+locale+"'  " +
                                     "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  "+
									 "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件)
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
                                           "and f.FWCOMP =  '"+compNo+"'  " + 
                                           "and to_char(f.FWREG) = '"+regionNo+"'  "+
                                           "and to_char(f.FWCOUN) =  '"+locale+"'  " +
                                           "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+MonthFr+"'  "+
										   "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);
            sqlWE = sqlWE + sWhereWE;
  
           ResultSet rsWE=statH.executeQuery(sqlWE);
	       if (rsWE.next())  
	      { 
	        int wefExist =0;
		    wefExist = rsWE.getInt("COUNT");
		    if (wefExist>=1)  // 月存在,週存在,則顯示可維護下月週預估表
		    {// out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?COMPNO="+compNo+"&&REGION="+regionNo+"&&LOCALE="+locale+"&&YEARFR="+YearFr+"&&MONTHFR="+monNext+"'>EDIT ("+monNext+"月份) WEEK FORECAST</A>");
			}
		    else      // 月存在,週不存在,則顯示僅可維護本月週預估表
	        {//out.println("<A HREF='../jsp/WSForeMaintenceEdit.jsp?COMPNO="+compNo+"&&REGION="+regionNo+"&&LOCALE="+locale+"&&YEARFR="+YearFr+"&&MONTHFR="+MonthFr+"'>EDIT ("+MonthFr+"月份) WEEK FORECAST</A>");
			}     
	      }
	      rsWE.close();  	  
	      }
	      else  // else for cntFlag >= 1 , 月即已不存在,更不用看週,呼叫 JavaScript 警示 !!!
	     {out.println("<input name='NONMONTH' type='hidden' value='0' >");}
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
      <td width="39%" bordercolor="#FFFFFF"> 
        <p><font color="#000000" face="Arial Black"><strong>Company Code</strong></font> 
         <% 
		 String COMPNO="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereComp = "";
		  
		  sSql = "select trim(MCCOMP) as MCCOMP,  trim(MCCOMP) || '('||MCDESC||')' from WSADMIN.WSMULTI_COMP ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhereComp = "where MCCOMP IS NOT NULL and MCACCT ='Y' order by MCCOMP";		 
		  sSql = sSql+sWhereComp;
		  
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
      <td width="26%"><font color="#000000" face="Arial Black"><strong>Region</strong></font> 
        <!--% 
		 String REGION="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereRegion = "";
		  
		  sSql = "select substr(CONTINENT,2,1) as REGION,  CONTINENT|| '('||CONTINENT_NAME||')' from WSADMIN.WSCONTINENT ";		  
		  sWhereRegion = "where CONTINENT IS NOT  NULL ";		 
		  sSql = sSql+sWhereRegion;
		  
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
       %--> 
	    <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereRegion = "";
		  
		  sSql = "select Unique CONTINENT as x , CONTINENT || '('||REGION ||')' from WSREGION, WSCONTINENT where REGION = CONT_ENG_NAME";		  
		  sWhereRegion = " order by x";		 
		  sSql = sSql+sWhereRegion;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSProductionStatus.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->ALL");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 	   
                        
            if (s1.equals(regionNo)) 
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
	   </td>
      <td width="27%"> <font color="#000000" face="Arial Black"><strong>Country</strong></font> 
        <!--% 
		 String COUNTRY="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereCountry = "";
		  
		  sSql = "select LOCALE,  LOCALE|| '(' || LOCALE_NAME||')' from WSADMIN.WSLOCALE ";		  
		  sWhereCountry = "where LOCALE IS NOT  NULL and LOCALE in('886','60','61','62','63','65', '66','91') ";		 
		  sSql = sSql+sWhereCountry;
		  
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
       %--> 
	   <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereCountry  = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  		  
		  sWhereCountry  = " where x.LOCALE=y.LOCALE  ";
		  if (regionNo==null || regionNo.equals("") || regionNo.equals("--") || regionNo.equals("ALL"))
		  {  sWhereCountry = sWhereCountry + "and CONTINENTID ! = 'ALL' "; }
		  else { sWhereCountry = sWhereCountry + "and CONTINENTID='"+regionNo+"' ";}
		  String sOrderCountry = "order by LOCALE_ENG_NAME";
		     		              
		  sSql = sSql+sWhereCountry+sOrderCountry;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  		 
	      comboBoxAllBean.setFieldName("COUNTRY");	   
          out.println(comboBoxAllBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	 </td>
      <td width="8%" >&nbsp; </td>
  </tr>
    <tr bgcolor="#CCFFFF"> 
      <td><font color="#000000" face="Arial Black"><strong>Year</strong></font> 
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
      <td> <font color="#000000" face="Arial Black"><strong>Month</strong></font> 
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
      <td><font color="#000000" face="Arial Black"><strong>Model</strong></font>
	   <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereModel = "";
		  
		  sSql = "select SALESCODE as MODEL,  SALESCODE || '('||BRAND||')' from WSADMIN.PIMASTER ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhereModel = "where PROJECTCODE IS NOT NULL ";		 
		  sSql = sSql+sWhereModel;
		  
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
      <td colspan="4" bgcolor="#CC3366"><div align="center"><font color="#FFFFFF" size="+1" face="Arial Black"><strong>TPE 
          C/O</strong></font></div></td>
      <td colspan="7" > <div align="center"> <font face="新細明體"><font size="+1"><strong>F/G</strong></font></font></div></tr>
    <tr bordercolor="#000000" > 
      <td width="11%" bgcolor="#CCCCFF"><div align="center"><font size="2" face="新細明體"><strong><font face="Courier New">MODEL</font></strong></font><font size="2" face="Courier New"><strong><br>
          (MKT)</strong></font></div></td>
      <td width="6%" bgcolor="#CCCCFF"><div align="center"><font size="2" face="新細明體"><strong><font face="Courier New">MODEL</font></strong></font><font size="2" face="Courier New"><strong><br>
          (Project)</strong></font></div></td>
      <td width="7%" bgcolor="#CCCCFF"><div align="center"><font size="2" face="Courier New"><strong>Color</strong></font></div></td>
	  <td width="7%" bgcolor="#CCCCFF"><div align="center"><font size="2" face="Courier New"><strong>Country</strong></font></div></td>
      <td width="9%" bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>Sales Forecast Q'ty</strong></font></div></td>
      <td width="8%" nowrap bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong><% out.println(preMeng_s);%>O/H<BR> <%out.println(preMonth_s); %>存量</strong></font></div></td>
	  <td width="8%" nowrap bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>Finished產出量</strong></font></div></td>
      <td width="8%" nowrap bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>Shipped出貨量</strong></font></div></td>
      <td width="9%" bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>Balance</strong></font></div></td>
      <td width="10%" nowrap bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>On 
          AC 待入庫數</strong></font></div></td>
      <td width="14%" bgcolor="#FFFFCC"><div align="center"><font size="2" face="新細明體"><strong>On 
          Hand<br>
          庫存數( <%=dateIntMonth%>月)</strong></font></div></td>
    </tr>
    <% // ***  Main Loop  Start   ***//
       //ResultSet RpRepair = StatementRpRepair.executeQuery(); 
  
        Statement statement=con.createStatement();   
		
		try
		{
		 
               //String sql = "select m.SALESCODE , m.PROJECTCODE, p.MCOLOR, p.MITEM, f.FMQTY, f.FMCOUN from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
			   String sql = "select DISTINCT m.SALESCODE , m.PROJECTCODE, f.FMQTY, f.FMCOUN from WSADMIN.PSALES_FORE_MONTH f , WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
		 /* String sWhere = "where m.PROJECTCODE = f.FMPRJCD and m.PROJECTCODE =  p.MPROJ and f.FMCOMP =  '"+compNo+"' and to_char(f.FMREG)= '"+regionNo+"'  "+
		                           " and to_char(f.FMCOUN) =  '"+locale+"'  and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  "+
								   "and m.SALESCODE =  '"+model+"' ";  // 加入 Model (SALESCODE為條件);   */ // 未區分 ALL 全選功能 //
								   
		          sWhere = "where m.PROJECTCODE = f.FMPRJCD(+) and m.PROJECTCODE =  p.MPROJ  and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  "+
		                          "and to_number(f.FMVER) = (select max(to_number(q.FMVER)) from PSALES_FORE_MONTH q where q.FMPRJCD = f.FMPRJCD) ";     // 2003/12/08
		
		if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		else { sWhere = sWhere + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		if (compNo==null || compNo.equals("--")) {   sWhere = sWhere + "and f.FMCOMP !=  'ALL'  "; }
		else { sWhere = sWhere + "and f.FMCOMP =  '"+compNo+"'  "; }
        if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(f.FMREG) != 'ALL'  "; }
		else { sWhere = sWhere +  "and to_char(lpad(f.FMREG,2,0))= '"+regionNo+"'  "; }
		if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }
		
		String sOrder = "order by m.PROJECTCODE ";
				
		sql = sql + sWhere + sOrder;
		//sql = "select m.SALESCODE , m.PROJECTCODE, p.MCOLOR, p.MITEM, f.FMQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p where m.PROJECTCODE = f.FMPRJCD and m.PROJECTCODE = p.MPROJ and f.FMYEAR = 'null' and f.FMMONTH= 'null' and to_char(f.FMCOUN) != 'ALL' and f.FMCOMP != 'ALL' and to_char(f.FMREG) != 'ALL' and m.SALESCODE != 'ALL' ";	          		
		
		String tmpSalesCde = null;   		
		
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

  // if we walked off the end of the recordset, set MM_rsCount and MM_size
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
		  fmPrjCode = rs.getString("PROJECTCODE");
		  if (	rs.getString("SALESCODE") != tmpSalesCde )
		  {
		   sumPlan = sumPlan + rs.getInt("FMQTY"); }  
		   tmpSalesCde = rs.getString("SALESCODE");  // Forecast計劃數量的加總 //
		  /*
		  if (	rs.getString("SALESCODE") != tmpSalesCde )	  
		  {		 
		    Statement stateA=con.createStatement();   
		    String sqlA = "select count(*) as COUNT from WSADMIN.PRODMODEL m, WSADMIN.PIMASTER p  where p.PROJECTCODE = m.MPROJ and p.SALESCODE = '"+rs.getString("SALESCODE")+"' and m.MPROJ = '"+fmPrjCode+"'  ";                         
		   //out.println(sqlA);
		    ResultSet rsA=stateA.executeQuery(sqlA);
		     if (rsA.next())
		    { rowSpanCnt = rsA.getInt(1); }
		     else { rowSpanCnt = 1; }
		     rsA.close();
		     stateA.close();  
		   }
		   else {rowSpanCnt = 1;}
		   */		   
		   rowSpanCnt = 1; 
       %>
    <tr bordercolor="#000000"> 	   
	  <td height="28" rowspan="<%=rowSpanCnt%>"> 
        <div align="center"><font color="#000000" size="2" face="Arial Black"> <!--%=(((rs_data = rs.getObject("SALESCODE"))==null || rs.wasNull())?"":rs_data)%--> <%=rs.getString("SALESCODE") %></font></div></td>
      <td ><div align="center"><font color="#000000" size="2" face="Arial"><strong><!--%=(((rs_data = rs.getObject("PROJECTCODE"))==null || rs.wasNull())?"":rs_data)%--><%=rs.getString("PROJECTCODE") %></strong></font></div></td>
      <td><div align="center"><font color="#000000" size="2">
	      <table height="100%" width="100%">
		    <%
			     Statement stateItemColor=con.createStatement();   
			     //String prjColor = rs.getString("MCOLOR");
				 //String prjCode = 
				 try
		        {   /*
				     String sqlColor = "select c.COLORDESC from PRODMODEL p, PICOLOR_MASTER c where p.MCOLOR=c.COLORCODE and p.MPROJ = '"+rs.getString("PROJECTCODE")+"' "+
				                          "and p.MCOLOR = '"+rs.getString("MCOLOR")+"'  and p.MITEM =  '"+rs.getString("MITEM")+"'  ";
			      	 ResultSet rsColor=stateColor.executeQuery(sqlColor);
		             if (rsColor.next())
			        {out.println(rsColor.getString("COLORDESC"));}
			    	else
			     	{}
					rsColor.close();
					stateColor.close(); */
					String sqlItemColor = "select p.MITEM, p.MCOLOR, c.COLORDESC from PRODMODEL p, PiCOLOR_MASTER c ";
					String whereItemColor = "where p.MCOLOR = c.COLORCODE and p.MPROJ = '"+rs.getString("PROJECTCODE")+"' ";
					sqlItemColor = sqlItemColor + whereItemColor;
					//out.println(sqlItemColor);
					ResultSet rsItemColor=stateItemColor.executeQuery(sqlItemColor);					
					while (rsItemColor.next())
					{
				 
			    %>
			  <tr bgcolor="#CCFFCC">		   
              <td><div align="center"><font size="2"><%=rsItemColor.getString("COLORDESC")%></font></div></td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();	   
                  }	    // End of While loop   
	              rsItemColor.close();
	              stateItemColor.close();
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
              %>  
	      </table>         
       </font></div></td>
	  <td><div align="center"><font color="#000000" size="2">
	   <%
			     Statement stateCountry=con.createStatement();   
			     //String prjColor = rs.getString("MCOLOR");
				 //String prjCode = 
				 try
		        {   
				     String sqlCountry = "select LOCALE_ENG_NAME from WSADMIN.WSLOCALE  where LOCALE= '"+rs.getString("FMCOUN")+"' ";
			      	 ResultSet rsCountry=stateCountry.executeQuery(sqlCountry);
		             if (rsCountry.next())
			        {out.println(rsCountry.getString("LOCALE_ENG_NAME"));}
			    	else
			     	{}
					rsCountry.close();	
					
					String sqlRowSpan =  "select count(m.PROJECTCODE) as ROWSPAN from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p " + sWhere + " and m.PROJECTCODE= '"+rs.getString("PROJECTCODE")+"' " ;
					ResultSet rsRowSpan=stateCountry.executeQuery(sqlRowSpan);
					if (rsRowSpan.next())
					{
					   rowSpan = rsRowSpan.getInt("ROWSPAN");
					   rowCnt = rowCnt + 1;
					}
					else
					{ rowSpan = 1;}
					rsRowSpan.close();
					stateCountry.close();
				 } //end of try
                  catch (Exception e)
                 {
                    out.println("Exception:"+e.getMessage());
                 } 
			%></font></div>
	   </td>
	   <!--% 
	        if (rs.getString("SALESCODE") == tmpSalesCde )
			{}
			else
			{out.println("<td rowspan="+rowSpan+"><div align='right'><font color='#000000' size='2'>"+rs.getInt("FMQTY")+"</font></div></td>");}			
			tmpSalesCde = rs.getString("SALESCODE");
			//out.println(tmpSalesCde);
	   %-->	  
      <td rowspan="<%=1%>"><div align="center"><font color="#000000" size="2">
	        <% 
			      out.println(rs.getInt("FMQTY"));
				  sumFmQty = sumFmQty + rs.getInt("FMQTY");
			%>
		</font></div></td>
	  <td><div align="right"><font color="#000000" size="2"> 
	      <table height="100%" width="100%">
	      <%
		       int preOnHand = 0;
		       try
		      {  		  
		        Statement stateItem0=con.createStatement();
			    String sqlItem0 = "select MITEM from PRODMODEL where MPROJ = '"+rs.getString("PROJECTCODE")+"' ";
			    ResultSet rsItem0=stateItem0.executeQuery(sqlItem0);
			   while (rsItem0.next()) 
			   { 				
		            Statement statePreOn=con.createStatement();   
				
				    String sqlPreOn = "select DISTINCT (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from WSADMIN.ILI_HISTORY l, PRODMODEL p ";
					String sWherePreOn = "where trim(l.LPROD) = p.MITEM and p.MITEM = '"+rsItem0.getString("MITEM")+"'  and substr(to_char(l.IN_DATE),5,2)='"+monthPre+"' "+
					                                    "and l.IN_TIME = (select max(h.IN_TIME) from WSADMIN.ILI_HISTORY h where l.SERIALCOLUMN = h.SERIALCOLUMN) ";
					sqlPreOn= sqlPreOn+ sWherePreOn;
					//out.println(sqlPreOn);
					ResultSet rsPreOn=statePreOn.executeQuery(sqlPreOn);					
					while (rsPreOn.next())
					{
				       preOnHand = rsPreOn.getInt("BALANCE");
				/*		
		         try
		         {   
                   String sqlPreOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from WSADMIN.ILI_HISTORY l ";
		           String sWherePreOn = "where trim(l.LPROD) = '"+rs.getString("MITEM")+"'  and substr(to_char(l.IN_DATE),5,2)='"+monthPre+"' ";
		           sqlPreOn= sqlPreOn+ sWherePreOn;		
		
                  //out.println(sqlOn);
                  ResultSet rsPreOn=statePreOn.executeQuery(sqlPreOn);
			      if (rsPreOn.next())
				  {
				    out.println(rsPreOn.getInt("BALANCE"));
				    sumPreOH = sumPreOH + rsPreOn.getInt("BALANCE");  // 加總前月庫存量
				  }
			      else
			      {out.println("&nbsp;");}
				  rsPreOn.close();
			      statePreOn.close();
				} //end of try
                catch (Exception e)
               {
                 out.println("Exception:"+e.getMessage());
               } 		  
			   */
	      %>
		  <tr bgcolor="#CCFFCC">		   
              <td><div align="center"><font size="2">
			      <%
				       out.println(preOnHand);
					   sumPreOH = sumPreOH + rsPreOn.getInt("BALANCE");  // 加總前月庫存量
				  %></font></div>
			  </td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();	   
                    }	    // End of While inner loop   
	                 rsPreOn.close();
	                 statePreOn.close();
					 preOnHand = 0;
				   }  // end of while outer loop
				   rsItem0.close();
				   stateItem0.close();
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
             %>    
		</table>
	  </font></div></td>
      <td rowspan="<%=rowSpanCnt%>"> <div align="right"><font color="#000000" size="2">
	      <table height="100%" width="100%">
          <%
	       String strPrjCD = rs.getString("PROJECTCODE");
	       String strShpYM = YearFr+MonthFr;
		   
	        Statement state=con.createStatement();
			try
			{
			 String sqlMES = "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
			 String sWhereMES = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpYM+"'  "+
                                     "and p.MPROJ = '"+strPrjCD+"'  and m.MODEL_NAME= p.MITEM  ";
			 sqlMES = sqlMES + sWhereMES;
			 ResultSet rsMESOut=state.executeQuery(sqlMES);
			 while (rsMESOut.next())
			 {
			/*
  
           String sqlMES = "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
           String sWhereMES = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpYM+"'  "+
                                     "and p.MPROJ = '"+strPrjCD+"'  and m.MODEL_NAME= '"+rs.getString("MITEM")+"'  ";
           sqlMES = sqlMES + sWhereMES;
  
           ResultSet rsMESOut=state.executeQuery(sqlMES);
  
           if (rsMESOut.next())
		   { 
		      finishQty = rsMESOut.getInt("COUNT");   // 得 Finish Q'ty
			  if (finishQty != 0){out.println(rsMESOut.getInt("COUNT"));}
			  else {out.println("&nbsp;");}
			  
			  sumFinish = sumFinish + finishQty;  // 對出貨量的加總  //
		      
		   }
		   rsMESOut.close();
		   state.close();
		   //out.println(sqlMES);
		   */
	    %>
	    <tr bgcolor="#CCFFCC">		   
           <td><div align="center"><font size="2">
		       <%
			        out.println(rsMESOut.getInt("COUNT"));
					sumFinish = sumFinish + finishQty;  // 對出貨量的加總  //
			     %>
			  </font></div></td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();	   
                  }	    // End of While loop   
	              rsMESOut.close();
	              state.close();
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
              %>  
	  </table>
     </font></div></td>
      <td><div align="right"><font color="#000000" size="2">
	      <table height="100%" width="100%"> 
          <%
		      //String strMItem="";
			 try
			{
		      Statement stateItem=con.createStatement();
			  String sqlItem = "select MITEM from PRODMODEL where MPROJ = '"+rs.getString("PROJECTCODE")+"' ";
			  ResultSet rsItem=stateItem.executeQuery(sqlItem);
			  while (rsItem.next()) 
			  { //strMItem = rsItem.getString("MITEM");  			  
		     
		      Statement stateActTTL=bpcscon.createStatement();
			  String strPrjCDActTTL = rs.getString("PROJECTCODE");
	          String strShpYMActTTLFr = YearFr+MonthFr+"01";
			  String strShpYMActTTLTo = YearFr+MonthFr+"31";
			  String sqlActTTL = "select sum(abs(TQTY)) as SUMActTTL from ITH m ";
			  String sWhereActTTL= "where  trim(m.TTYPE)= 'B'  and  m.TTDTE between '"+strShpYMActTTLFr+"' and '"+strShpYMActTTLTo+"' "+
                                                     "and trim(m.TPROD) =  '"+rsItem.getString("MITEM")+"' and m.TWHS='52' ";
               sqlActTTL= sqlActTTL + sWhereActTTL;
			   ResultSet rsActTTL=stateActTTL.executeQuery(sqlActTTL);
			   while (rsActTTL.next())
			   {
			  
			  /*
		      try
			  {
	           String strPrjCDActTTL = rs.getString("PROJECTCODE");
	           String strShpYMActTTLFr = YearFr+MonthFr+"01";
			   String strShpYMActTTLTo = YearFr+MonthFr+"31";		  		  
		   
	            //Statement stateActTTL=con.createStatement();   //2003/12/26改為即時抓BPCS
				
				 
                //String sqlActTTL = "select sum(abs(TQTY)) as SUMActTTL from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";   //2003/12/26改為即時抓BPCS				
                //String sWhereActTTL= "where trim(m.TPROD) = p.MITEM and trim(m.TTYPE)= 'B'  and  substr(m.TTDTE,1,6) = '"+strShpYMActTTL+"'  "+
                //                                     "and p.MPROJ = '"+strPrjCDActTTL+"' and trim(m.TPROD) =  '"+rs.getString("MITEM")+"'  ";
				String sqlActTTL = "select sum(abs(TQTY)) as SUMActTTL from ITH m ";
				String sWhereActTTL= "where  trim(m.TTYPE)= 'B'  and  m.TTDTE between '"+strShpYMActTTLFr+"' and '"+strShpYMActTTLTo+"' "+
                                                     "and trim(m.TPROD) =  '"+rs.getString("MITEM")+"' and m.TWHS='52' ";
                 sqlActTTL= sqlActTTL + sWhereActTTL;
				 
				// out.println(sqlActTTL);  
                ResultSet rsActTTL=stateActTTL.executeQuery(sqlActTTL);
  
                if (rsActTTL.next())
				{
				   if (rsActTTL.getInt("SUMActTTL") != 0){out.println(rsActTTL.getInt("SUMActTTL"));}
				   else {out.println("&nbsp;");}
				  sumShipped = sumShipped + rsActTTL.getInt("SUMActTTL");  // 對機種出貨量的加總  //
				}
				rsActTTL.close();
				stateActTTL.close();	       
			 } //end of try
              catch (Exception e)
            {
              out.println("Exception:"+e.getMessage());
            } 
			*/
            %>
		   <tr bgcolor="#CCFFCC">		   
           <td><div align="center"><font size="2">
		        <%
				     out.println(rsActTTL.getInt("SUMActTTL"));
					 sumShipped = sumShipped + rsActTTL.getInt("SUMActTTL");  // 對機種出貨量的加總  //
				%></font></div>
			  </td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();	   
                   }	    // End of While loop  inner
	                rsActTTL.close();
	                stateActTTL.close();
				  }   // End of While outer
				  rsItem.close();
				  stateItem.close();
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
              %>  
		</table>
       </font></div></td>
      <td rowspan="<%=rowSpanCnt%>"><div align="center"><font color="#000000" size="2"> 
          <% //Balance Plan Qty - Finish Qty//	    
			
			balanceQty = (rs.getInt("FMQTY") - finishQty)*1;
			
			sumBalance = sumBalance +  balanceQty;
			
			out.println(balanceQty);
			/*   // 
        
            Statement stateILI=con.createStatement();   		
		    try
		   {   
             String sqlILI = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from WSADMIN.ILI l ";
		     String sWhereILI = "where trim(l.LPROD) = '"+rs.getString("MITEM")+"' ";
		     sqlILI = sqlILI+ sWhereILI;		
		
            //out.println(sqlFW1);
            ResultSet rsILI=stateILI.executeQuery(sqlILI);
			if (rsILI.next())
			{out.println(rsILI.getInt("BALANCE"));}
			else
			{out.println("N/A");}
			rsILI.close();
			stateILI.close();						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          }  
		  */ //
		 %>
          </font></div></td>
      <td><div align="right"><font color="#000000" size="2"> 
	     <table height="100%" width="100%"> 
          <% //AC - R Qty ( MES AC Output -  ITH type R Qty)
		    try
		   {   
		    Statement stateItem2=con.createStatement();   
			String sqlItem2 = "select MITEM from PRODMODEL where MPROJ = '"+rs.getString("PROJECTCODE")+"' ";
			ResultSet rsItem2=stateItem2.executeQuery(sqlItem2);
			while (rsItem2.next()) 
			{ //strMItem = rsItem.getString("MITEM");  
        
		      Statement stateBpcs=bpcscon.createStatement();   // 2003/12/26 抓Bpcs 即時資料
              Statement stateACR=con.createStatement();  
			   int thRQty = 0;
			   int acQty = 0;
			   int thTref = 0;
			  String moNo = "";
			  String thTProd = "";
    		  int acrQTY = 0;	 
			  String strDateFr = YearFr+ MonthFr + "01";
			  String strDateTo = YearFr+ MonthFr + "31";
			  String sqlR = "select  sum(h.TQTY) as RQTY,  trim(h.TPROD) as TPROD from ITH h ";  // <--不看工單
		      String sWhereR = "where trim(h.TTYPE) = 'R' and h.TTDTE between '"+strDateFr+"' and '"+strDateTo+"' and trim(h.TPROD) = '"+rsItem2.getString("MITEM")+"' and h.TWHS='52' ";			 
			  String sOrderR = "group by h.TPROD order by TPROD ";// <--不看工單
		      sqlR = sqlR+ sWhereR+sOrderR;			 
	          ResultSet rsR=stateBpcs.executeQuery(sqlR);
			  if (rsR.next())
			 { 
			   thRQty=rsR.getInt("RQTY");			 
			   thTProd=rsR.getString("TPROD");
			 }
			  String sqlAC = "select count(IMEI) as ACQTY from MES_WIP_TRACKING m where substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),1,4) = '"+YearFr+"'  "+
			                         "and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),5,2) = '"+MonthFr+"'  and m.GROUP_NAME = 'AC_PACKING' "+							
									 "and m.MODEL_NAME= '"+rsItem2.getString("MITEM")+"' "; // <--不看工單					
		     ResultSet rsAC=stateACR.executeQuery(sqlAC);
			 if (rsAC.next())
			 {acQty = rsAC.getInt("ACQTY");}	  
			  acrQTY =  acQty - thRQty;
			  rsAC.close();
			  rsR.close();
			  stateBpcs.close();
			  stateACR.close();
			  
			/* 		
		    try
		   {   
                 int thRQty = 0;
				 int acQty = 0;
				 int thTref = 0;
			 String moNo = "";
			 String thTProd = "";
			     int acrQTY = 0;	 
				 
			 String strDateFr = YearFr+ MonthFr + "01";
			 String strDateTo = YearFr+ MonthFr + "31";
		   
           
			 String sqlR = "select  sum(h.TQTY) as RQTY,  trim(h.TPROD) as TPROD from ITH h ";  // <--不看工單
		     String sWhereR = "where trim(h.TTYPE) = 'R' and h.TTDTE between '"+strDateFr+"' and '"+strDateTo+"' and trim(h.TPROD) = '"+rs.getString("MITEM")+"' and h.TWHS='52' ";			 
			 String sOrderR = "group by h.TPROD order by TPROD ";// <--不看工單
		     sqlR = sqlR+ sWhereR+sOrderR;
			 //out.println(sqlR);
	        ResultSet rsR=stateBpcs.executeQuery(sqlR);
			while (rsR.next())
			{ 
			  thRQty=rsR.getInt("RQTY");
			  //thTref=rsR.getInt("TREF");  // 看工單
			  thTProd=rsR.getString("TPROD");	  
			}		
			 
			 String sqlAC = "select count(IMEI) as ACQTY from MES_WIP_TRACKING m where substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),1,4) = '"+YearFr+"'  "+
			                         "and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),5,2) = '"+MonthFr+"'  and m.GROUP_NAME = 'AC_PACKING' "+
							//		 "and m.ERP_MO = '"+thTref+"'  and m.MODEL_NAME= '"+thTProd+"' "; // 看工單
									 "and m.MODEL_NAME= '"+thTProd+"' "; // <--不看工單
			// out.println(sqlAC);		
		     ResultSet rsAC=stateACR.executeQuery(sqlAC);
			 if (rsAC.next())
			 {acQty = rsAC.getInt("ACQTY");}
			 
			 acrQTY =  acQty - thRQty;
			 //out.println(acQty);
			 //out.println(thRQty);
			 out.println(acrQTY);
			 sumOnAC = sumOnAC +  acrQTY;  // 對機種OnAC待入庫的加總 //			 
			 
            rsAC.close();
			rsR.close();
			stateBpcs.close();
			stateACR.close();			
						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		  */
		    %>
			<tr bgcolor="#CCFFCC">		   
           <td><div align="center"><font size="2">
		        <%
				      out.println(acrQTY);
					  sumOnAC = sumOnAC +  acrQTY;  // 對機種OnAC待入庫的加總 //
				%></font></div>
				</td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();	   
                   }	    // End of While loop  
	              
				   rsItem2.close();			      
				   stateItem2.close();				  
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
              %>  
		 </table>
        </font></div></td>
      <td><div align="right"><font color="#000000" size="2"> 
	    <table height="100%" width="100%"> 
          <% //On-Hand Qty(LOPB + LADJU + LRCT - LISSU) 
		  
		    int  onHandQty = 0;
			
			try
			{
		  
		    Statement stateItem3=con.createStatement();
			String sqlItem3 = "select MITEM from PRODMODEL where MPROJ = '"+rs.getString("PROJECTCODE")+"' ";
			ResultSet rsItem3=stateItem3.executeQuery(sqlItem3);
			while (rsItem3.next()) 
			{ //strMItem = rsItem.getString("MITEM");  
        
            //Statement stateOn=con.createStatement();   //2003/12/26改為即時抓BPCS
			Statement stateOn=bpcscon.createStatement(); 
			String sqlOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from ILI l ";
		    String sWhereOn = "where trim(l.LPROD) = '"+rsItem3.getString("MITEM")+"' ";
		     sqlOn= sqlOn+ sWhereOn;		
		
            //out.println(sqlOn);
            ResultSet rsOn=stateOn.executeQuery(sqlOn);
			if (rsOn.next()) 
			{
			  onHandQty = rsOn.getInt("BALANCE");
			  //sumCurrOH = sumCurrOH +  onHandQty;			  
			}
			else
			{}
			rsOn.close();
			stateOn.close();
			/* 		
		    try
		   {   
             //String sqlOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from WSADMIN.ILI l  ";//2003/12/26改為即時抓BPCS
			 String sqlOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from ILI l ";
		     String sWhereOn = "where trim(l.LPROD) = '"+rs.getString("MITEM")+"' ";
		     sqlOn= sqlOn+ sWhereOn;		
		
            //out.println(sqlOn);
            ResultSet rsOn=stateOn.executeQuery(sqlOn);
			if (rsOn.next())
			{
			  out.println(rsOn.getInt("BALANCE"));
			  sumCurrOH = sumCurrOH +  rsOn.getInt("BALANCE");
			}
			else
			{out.println("&nbsp;");}
			rsOn.close();
			stateOn.close();						
		   } //end of try
           catch (Exception e)
          {
             out.println("Exception:"+e.getMessage());
          } 
		  */
		 %>
		 <tr bgcolor="#CCFFCC">		   
           <td><div align="center"><strong><font size="2">
		        <%
				     out.println(onHandQty);
					 sumCurrOH = sumCurrOH +  onHandQty;
				%></font></strong></div>
				</td>          
             </tr>
			   <%                
                   //rs_hasData = rs.next();
				   onHandQty = 0;	                  
				 }   // End of While outer
				  rsItem3.close();
				  stateItem3.close();
				  
                 } //end of try
                 catch (Exception e)
                {
                  out.println("Exception:"+e.getMessage());
                 }   
              %>  
	  </table>	 
      </font></div></td>
    </tr>    
    <%
       rs1__index++;	   
       rs_hasData = rs.next();	   
     }
	 //tmpSalesCde = rs.getString("SALESCODE");
	 rs.close();
	 statement.close();
   } //end of try
   catch (Exception e)
   {
       out.println("Exception:"+e.getMessage());
   }   
 %>
 <tr bordercolor="#000000"> 
    <td colspan="4"><div align="center"><font color="#990033" size="2"> <strong>其他機種(領樣) 
          </strong></font></div></td>            
    <td> <div align="right"><font color="#1B0378" size="2">&nbsp; </font></div></td>
	<td>&nbsp;</td>
    <td><div align="center"><font color="#000000" size="2">&nbsp; 
     <%
	       //String strPrjCD = rs.getString("PROJECTCODE");
	  if (rs1__index>= 1)
	  {	   
	    //	if ( compNo==null || compNo.equals("--") || regionNo==null || regionNo.equals("--") || locale==null || locale.equals("--") )  
		//{out.println("N/A");}
		//else
		//{
		 try
		{  	   
	       String strShpOth = YearFr+MonthFr;
		   
		   //String mItem = null;
           //String mItemGet = "";
           //     int mItemGetLength = 0;
		   
	        Statement stateShpOth=con.createStatement();
			
			String sqlOth = "select m.PROJECTCODE, p.MITEM from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
		    String sWhereOth = "where m.PROJECTCODE = f.FMPRJCD and m.PROJECTCODE =  p.MPROJ "+
			                               "and to_number(f.FMVER) = (select max(to_number(FMVER)) from PSALES_FORE_MONTH) "+     // 2003/12/08
			                     //  "and f.FMCOMP =  '"+compNo+"' and to_char(f.FMREG)= '"+regionNo+"'  "+
		                         //  " and to_char(f.FMCOUN) =  '"+locale+"'  "+
								           "and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  ";
								   
			 if (locale==null || locale.equals("--")) {   sWhereOth = sWhereOth + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereOth = sWhereOth + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		     if (compNo==null || compNo.equals("--")) {   sWhereOth = sWhereOth + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereOth = sWhereOth + "and f.FMCOMP =  '"+compNo+"'  "; }
             if (regionNo==null || regionNo.equals("--")) { sWhereOth = sWhereOth + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereOth = sWhereOth +  "and to_char(lpad(f.FMREG,2,0)) = '"+regionNo+"'  "; }
		     if (model==null || model.equals("--")) { sWhereOth = sWhereOth +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereOth = sWhereOth +  "and m.SALESCODE =  '"+model+"' "; }					   
			
		     sqlOth = sqlOth + sWhereOth;
			 //out.println(sqlOth);
			 ResultSet rsOth=stateShpOth.executeQuery(sqlOth);			 
			while (rsOth.next())
           { 
                  mItem = rsOth.getString("MITEM");
	              mItemGet = mItemGet+"'"+mItem+"'"+",";
           }
			
			if (mItemGet==null || mItemGet.equals(""))
			{ mItemGet = ""; }
			else
			{
              mItemGetLength = mItemGet.length()-1;
              mItemGet = mItemGet.substring(0,mItemGetLength);
			}
			
			//out.println(mItemGet);
			
			if (mItemGet==null || mItemGet.equals("")){mItemGet = "'ALL'";}			
  
           String sqlShpOth = "select count(*) as COUNT from WSADMIN.MES_WIP_TRACKING m, WSADMIN.PRODMODEL p ";
           String sWhereShpOth = "where m.MODEL_NAME = p.MITEM  and  substr(m.MCARTON_NO,9,6)='"+strShpOth+"'  "+
                                                 "and m.MODEL_NAME not in("+mItemGet+") and m.GROUP_NAME = 'AC_PACKING' "+
									             "and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),1,4) = '"+YearFr+"' and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),5,2) = '"+MonthFr+"' ";
           sqlShpOth = sqlShpOth + sWhereShpOth;
           //out.println(sqlShpOth);
           ResultSet rsShpOth=stateShpOth.executeQuery(sqlShpOth);
           
           if (rsShpOth.next())
		   {
		     out.println(rsShpOth.getInt("COUNT"));
		     sumFinish = sumFinish +  rsShpOth.getInt("COUNT");  // 再加其它機種的出貨量 //
		   }
		   rsOth.close();
		   rsShpOth.close();
		   stateShpOth.close();
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
	  // }   // end of (compNo==null)
	  }  //end of if (rs1__index>= 1)
	   else
	  {out.println("N/A");}
    %>
      </font></div></td>
    <td> <div align="center"><font color="#000000" size="2"> 
    <%	
	  if (rs1__index>= 1)
	  { 
	    // if ( compNo==null || compNo.equals("--") || regionNo==null || regionNo.equals("--") || locale==null || locale.equals("--") )  
		//{out.println("N/A");}
		//else
		//{        
		   try
		   {  	   
	          //String strShpSQty = YearFr+MonthFr;
			  String strShpSQtyFr = YearFr+MonthFr+"01";
			  String strShpSQtyTo = YearFr+MonthFr+"31";
			  
			  //Statement stateShpS=con.createStatement();
			  Statement stateShpS=bpcscon.createStatement();
		   
		    /*  String mItemS = null;
              String mItemGetS = "";
                   int mItemGetLengthS = 0;
		   
	          
			
		      String sqlS = "select m.PROJECTCODE, p.MITEM from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
		      String sWhereS = "where m.PROJECTCODE = f.FMPRJCD and m.PROJECTCODE =  p.MPROJ and f.FMCOMP =  '"+compNo+"' and to_char(f.FMREG)= '"+regionNo+"'  "+
		                                  " and to_char(f.FMCOUN) =  '"+locale+"'  and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  order by p.MITEM ";
		       sqlS = sqlS + sWhereS;
		       ResultSet rsS=stateShpS.executeQuery(sqlS);
			 
		       while (rsS.next())
              { 
                  mItemS = rsS.getString("MITEM");
	              mItemGetS = mItemGetS+"'"+mItemS+"'"+",";
               }
               mItemGetLengthS = mItemGetS.length()-1;
               mItemGetS = mItemGetS.substring(0,mItemGetLengthS);
			   
			 */    // 以全域變數取代 mItem,mItemGet,mItemGetLength //
		   
	          //String sqlSQty = "select sum(abs(TQTY)) as SUMSQTY from WSADMIN.ITH m, WSADMIN.PRODMODEL p ";    //2003/12/26改為即時抓BPCS
              //String sWhereSQty= "where trim(m.TPROD) = p.MITEM and trim(m.TTYPE)= 'B'  and  substr(m.TTDTE,1,6) = '"+strShpSQty+"'  "+
              //                                       "and trim(m.TPROD) not in("+mItemGet+") "+
			  //           							   "and substr(m.TTDTE,1,4) = '"+YearFr+"' and substr(m.TTDTE,5,2) = '"+MonthFr+"' ";   //2003/12/26改為即時抓BPCS
													 
			  String sqlSQty = "select sum(abs(TQTY)) as SUMSQTY from ITH m ";
              String sWhereSQty= "where trim(m.TTYPE) in('S','SR')  and  m.TTDTE between '"+strShpSQtyFr+"' and '"+strShpSQtyTo+"'  "+
                                                     "and trim(m.TPROD) not in("+mItemGet+") and m.TWHS='52' ";
													 //"and substr(m.TTDTE,1,4) = '"+YearFr+"' and substr(m.TTDTE,5,2) = '"+MonthFr+"' ";
              sqlSQty= sqlSQty + sWhereSQty;
			  //out.println(sqlSQty);
  
              ResultSet rsSQty=stateShpS.executeQuery(sqlSQty);		
  
                if (rsSQty.next())
				{
				  out.println(rsSQty.getInt("SUMSQTY"));
				  sumShipped = sumShipped + rsSQty.getInt("SUMSQTY");  // 再對其它機種出貨量的加總  //
				}
				//rsS.close();
				rsSQty.close();
				stateShpS.close();	    
		 } //end of try
         catch (Exception e)
        {
           out.println("Exception:"+e.getMessage());
        } 
	 // }// end of if ( compNo == null )		   
	 } // end of if (rs1__index>= 1)
	  else
	 {out.println("N/A");}
   %>
       </font></div></td>
     <td> <div align="right"><font color="#1B0378" size="2">&nbsp; </font></div></td>
     <td> <div align="center"><font color="#000000" size="2"> 
      <%
	   if (rs1__index>= 1)
	   { 
	    //if ( compNo==null || compNo.equals("--") || regionNo==null || regionNo.equals("--") || locale==null || locale.equals("--") )  
		//{out.println("N/A");}
		 //else
		 //{     
		    try
		   {  	   
	          String strShpSQtyOth = YearFr+MonthFr;
			  
			  String strShpSQtyOthFr = YearFr+MonthFr+"01";
			  String strShpSQtyOthTo = YearFr+MonthFr+"31";
			  
			  Statement stateBpcsOth=con.createStatement();
			  Statement stateShpSOth=con.createStatement();
		     /*
		      String mItemSOth = null;
              String mItemGetSOth = "";
                   int mItemGetLengthSOth = 0;
		   
	          
			
		      String sqlSOth = "select m.PROJECTCODE, p.MITEM from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
		      String sWhereSOth = "where m.PROJECTCODE = f.FMPRJCD and m.PROJECTCODE =  p.MPROJ and f.FMCOMP =  '"+compNo+"' and to_char(f.FMREG)= '"+regionNo+"'  "+
		                                  " and to_char(f.FMCOUN) =  '"+locale+"'  and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  order by p.MITEM ";
		       sqlSOth = sqlSOth + sWhereSOth;
		       ResultSet rsSOth=stateShpSOth.executeQuery(sqlSOth);
			 
		       while (rsSOth.next())
              { 
                  mItemSOth = rsSOth.getString("MITEM");
	              mItemGetSOth = mItemGetSOth+"'"+mItemSOth+"'"+",";
               }
               mItemGetLengthSOth = mItemGetSOth.length()-1;
               mItemGetSOth = mItemGetSOth.substring(0,mItemGetLengthSOth);
			   
			   */       // 以全域變數取代 mItem,mItemGet,mItemGetLength //
			   // //
			    int thRQtyOth = 0;
				 int acQtyOth = 0;
				 int thTrefOth = 0;
			 String moNoOth = "";
			 String thTProdOth = "";
			     int acrQTYOth = 0;	 
		     // 先抓非機種下的 ITH 數量
            /*     //改抓Bpcs即時資料
			 String sqlROth = "select  sum(h.TQTY) as RQTY, trim(h.TPROD) as TPROD from WSADMIN.ITH h ";   // <--依工單
		     String sWhereROth = "where trim(h.TTYPE) = 'R' and trim(h.TPROD) not in("+mItemGet+") "+
			                                   "and substr(h.TTDTE,1,4) = '"+YearFr+"' and substr(h.TTDTE,5,2) = '"+MonthFr+"' ";		
			 String sOrderROth = "group by h.TPROD order by TPROD ";// <--依工單
			*/     // 2003/12/26   改抓Bpcs即時資料
			 
			 String sqlROth = "select  sum(h.TQTY) as RQTY, trim(h.TPROD) as TPROD from ITH h ";   // <--依工單
		     String sWhereROth = "where trim(h.TTYPE) = 'R' and trim(h.TPROD) not in("+mItemGet+") "+
			                                   "and h.TTDTE between '"+strShpSQtyOthFr+"' and '"+strShpSQtyOthTo+"' and h.TWHS='52'  ";		
			 String sOrderROth = "group by h.TPROD order by TPROD ";// <--依工單		 
			 
		     sqlROth = sqlROth+ sWhereROth+sOrderROth;
			 
	        ResultSet rsROth=stateBpcsOth.executeQuery(sqlROth);
			if (rsROth.next())
			{ 
			  thRQtyOth=rsROth.getInt("RQTY");
			  //thTrefOth=rsROth.getInt("TREF");   // 不依工單
			  thTProdOth=rsROth.getString("TPROD");	  }		
			 
			 String sqlACOth = "select count(IMEI) as ACQTY from MES_WIP_TRACKING m "+
			                               "where  m.GROUP_NAME = 'AC_PACKING'  and m.MODEL_NAME not in("+mItemGet+") "+
									 //	   "and m.ERP_MO = '"+thTrefOth+"' "+			        // 不依工單                      
											"and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),1,4) = '"+YearFr+"' and substr(to_char(m.IN_STATION_TIME,'YYYYMMDD'),5,2) = '"+MonthFr+"' ";		
		     ResultSet rsACOth=stateShpSOth.executeQuery(sqlACOth);
			 if (rsACOth.next())
			 {acQtyOth = rsACOth.getInt("ACQTY");}
			 
			 acrQTYOth =  acQtyOth - thRQtyOth;
			 
			 out.println(acrQTYOth);
			  sumOnAC = sumOnAC +  acrQTYOth;  // 對其他機種OnAC待入庫的加總 //
			   
			// rsSOth.close();
			 rsROth.close();
			 rsACOth.close();
			 stateBpcsOth.close();
			 stateShpSOth.close();   
			   
			} // end of try
			 catch (Exception e)
           {
              out.println("Exception: "+e.getMessage());
           } 
		 // }// end of if ( compNo == null )		   
	     } // end of if (rs1__index>= 1)
	     else
	    {out.println("N/A");} 
		%>
        </font></div></td>
      <td>
	     <div align="center"><font size="2">
		   <% //On-Hand Qty(LOPB + LADJU + LRCT - LISSU) 
		     if (rs1__index>= 1)
	        { 
        
             //Statement stateOn=con.createStatement();   //2003/12/26改為即時抓BPCS
			 Statement stateOn=bpcscon.createStatement();   		
		     try
		    {   
               //String sqlOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from WSADMIN.ILI l  ";//2003/12/26改為即時抓BPCS
			   String sqlOn = "select (l.LOPB + l.LADJU + l.LRCT - l.LISSU) as BALANCE from ILI l ";
		       String sWhereOn = "where trim(l.LPROD) not in("+mItemGet+") and l.LWHS='52'  ";
		       sqlOn= sqlOn+ sWhereOn;		
		
              //out.println(sqlOn);
              ResultSet rsOn=stateOn.executeQuery(sqlOn);
			  if (rsOn.next())
			  {
			   out.println(rsOn.getInt("BALANCE"));
			   sumCurrOH = sumCurrOH +  rsOn.getInt("BALANCE");
			  }
			  else
			 {out.println("&nbsp;");}
			  rsOn.close();
			  stateOn.close();						
		     } //end of try
             catch (Exception e)
            {
              out.println("Exception:"+e.getMessage());
            } 
		 } // end of if (rs1__index>= 1)
	     else
	    {out.println("N/A");} 
		 %>
	     </font></div>
	  </td>
    </tr>
	<tr>
	  <td><div align="center"><font face="Arial Black" color="#000099"><%=dateMonStr%>月<%=dateDayStr%>日</font></div></td>
	  <td>&nbsp;</td>
	  <td colspan="2"><div align="center"><strong><font face="Courier New">SUBTOTAL</font></strong></div></td>
	  <td ><div align="center"><strong><font color="#000000" size="2">
	  <% out.println(sumFmQty);%>
	      <!--%
		       Statement stateSumPlan=con.createStatement();   		
		    try
		   {   
             String sqlSumPlan = "select sum(f.FMQTY)  as SUMPLANQTY from WSADMIN.PSALES_FORE_MONTH f, WSADMIN.PIMASTER m ";
			 String sWhereSumPlan = "where m.PROJECTCODE = f.FMPRJCD  and f.FMYEAR = '"+YearFr+"'  and f.FMMONTH=  '"+MonthFr+"'  "+
		                                             "and to_number(FMVER) = (select max(to_number(FMVER)) from PSALES_FORE_MONTH) ";     // 2003/12/08
		
		     if (locale==null || locale.equals("--")) { sWhereSumPlan  = sWhereSumPlan  + "and to_char(f.FMCOUN) !=  'ALL'  "; }
		     else { sWhereSumPlan  = sWhereSumPlan  + "and to_char(f.FMCOUN) =  '"+locale+"'  ";}
		     if (compNo==null || compNo.equals("--")) {   sWhereSumPlan  = sWhereSumPlan  + "and f.FMCOMP !=  'ALL'  "; }
		     else { sWhereSumPlan  = sWhereSumPlan  + "and f.FMCOMP =  '"+compNo+"'  "; }
             if (regionNo==null || regionNo.equals("--")) { sWhereSumPlan  = sWhereSumPlan  + "and to_char(f.FMREG) != 'ALL'  "; }
		     else { sWhereSumPlan  = sWhereSumPlan  +  "and to_char(f.FMREG)= '"+regionNo+"'  "; }
		     if (model==null || model.equals("--")) { sWhereSumPlan  = sWhereSumPlan  +  "and m.SALESCODE !=  'ALL' "; }
		     else { sWhereSumPlan = sWhereSumPlan  +  "and m.SALESCODE =  '"+model+"' "; }
			
		     sqlSumPlan = sqlSumPlan + sWhereSumPlan;
		
             out.println(sqlSumPlan);
             ResultSet rsSumPlan=stateSumPlan.executeQuery(sqlSumPlan);
			 if (rsSumPlan.next())
			 {
			   out.println(rsSumPlan.getInt("SUMPLANQTY"));
			 }
			 rsSumPlan.close();
			 stateSumPlan.close();
		   } // end of try
			catch (Exception e)
           {
              out.println("Exception: "+e.getMessage());
           }  
			 
		  %-->
		  </font></strong></div>
	  </td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumPreOH%></font></strong></div></td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumFinish%></font></strong></div></td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumShipped%></font></strong></div></td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumBalance%></font></strong></div></td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumOnAC%></font></strong></div></td>
	  <td><div align="center"><strong><font color="#000000" size="2"><%=sumCurrOH%></font></strong></div></td>
	</tr>
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
<!--%
<table width="75%" border="0">
  <tr>
    <td><font color="#CC0066">P.S</font></td>
    <td><font color="#CC0066" size="-1">Plan Q'ty = Monthly Sales Forecast</font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><font color="#CC0066" size="-1">Finished = MES AC Line packing station finish out</font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><font color="#CC0066" size="-1">Shipped = BPCS CO shipped Q'ty(type=B)</font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><font color="#CC0066" size="-1">Balance = Plan Q'ty - Finished Q'ty</font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><font color="#CC0066" size="-1">On AC WIP = MES Finish - BPCS S.O Receipt(Type R) </font></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><font color="#CC0066" size="-1">On Hand = BPCS Warehouse Inventory</font></td>
  </tr>
</table>
%-->

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
<%
//rs.close();
%>
