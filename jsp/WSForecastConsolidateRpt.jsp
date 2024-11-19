<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean,RsBean,WorkingDateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function wsRegionReportByModel(yearfr,monthfr,type,region)
{   
  //subWin=window.open("JamCodeOrderbyModelList.jsp?MODEL="+pp+"&DATEBEGIN="+datebegin+"&DATEEND="+dateend+"&REPCENTERNO="+rpcenter,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
  subWin=window.open("WSForecastRegionRpt.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&TYPE="+type+"&REGION="+region,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
function wsCountryReportByModel(yearfr,monthfr,type,region,locale)
{   
  //subWin=window.open("JamCodeOrderbyModelList.jsp?MODEL="+pp+"&DATEBEGIN="+datebegin+"&DATEEND="+dateend+"&REPCENTERNO="+rpcenter,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
  subWin=window.open("WSForecastCountryRpt.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&TYPE="+type+"&REGION="+region+"&LOCALE="+locale,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsBean" scope="page" class="RsBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Weekly Forecast Inquiry</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#000000" size="+2" face="Arial Black"><strong>DBTEL</strong></font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
Forecast Consolidate Report</font> 
<FORM ACTION="../jsp/WSForecastConsolidateRpt.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 15;
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
  //String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE");
  //String YearFr=request.getParameter("YEARFR");
  //String MonthFr=request.getParameter("MONTHFR"); 
  String YearFr=Integer.toString(dateBean.getYear());
  String MonthFr=Integer.toString(dateBean.getMonth());
  String model=request.getParameter("MODEL"); 
  String color=request.getParameter("COLOR"); 
  
 // if (model=="5688 " || model.equals("5688 "))
 // {model="5688+";}
 
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
  
  //String [] prjArrWkQty = "";
  //int numRow = 0;
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
 /*   
  try
  { 

  Statement statH=con.createStatement();
  // COUNT 為此月份條件下的機型筆數
  String sqlH = "select count(*) as COUNT, FWPRJCD  from PSALES_FORE_WEEK f, PIMASTER m, PRODMODEL p ";
  String sWhereH = "where m.PROJECTCODE = f.FWPRJCD and f.FWPRJCD = p.MPROJ " + 
               //                "and f.FWTYPE =  '"+type+"'  " + 
              //                 "and f.FWREG = "+regionNo+"  "+
              //                 "and f.FWCOUN =  "+locale+"  " +
			 //			   "and m.SALESCODE =  '"+model+"' "+  // 加入 Model (SALESCODE為條件);
                               "and f.FWYEAR = '"+YearFr+"'  and f.FWMONTH=  '"+monNext+"'  ";

   if (locale==null || locale.equals("--")) {   sWhereH = sWhereH+ "and to_char(f.FWCOUN) !=  'ALL'  "; }
   else { sWhereH = sWhereH + "and to_char(f.FWCOUN) =  '"+locale+"'  ";}
   if (type==null || type.equals("--")) {   sWhereH = sWhereH + "and f.FWTYPE !=  'ALL'  "; }
   else { sWhereH = sWhereH + "and f.FWTYPE =  '"+type+"'  "; }
   if (regionNo==null || regionNo.equals("--")) { sWhereH = sWhereH + "and to_char(f.FWREG) != 'ALL'  "; }
   else { sWhereH = sWhereH +  "and to_char(f.FWREG)= '"+regionNo+"'  "; }
   if (model==null || model.equals("--")) { sWhereH = sWhereH +  "and f.FWPRJCD !=  'ALL' "; }
   else { sWhereH = sWhereH +  "and f.FWPRJCD =  '"+model+"' "; }

  String sGroupH = "group by FWPRJCD order by FWPRJCD ";
  sqlH = sqlH + sWhereH + sGroupH;
  out.println(sqlH);
 
  ResultSet rsH=statH.executeQuery(sqlH);
  
  if (rsH.next())
 {
    int cntFlag =0;
	
	cntFlag = rsH.getInt("COUNT");
	if (cntFlag>= 1)
	{  
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
 } //end of try
 catch (Exception e)
 {
   out.println("Exception:"+e.getMessage());		  
 }
 */ 
%>
  <table width="100%" border="0">
    <tr bgcolor="#D0FFFF"> 
      <td width="35%" height="23" bordercolor="#FFFFFF"> <p><font color="#CC3366" face="Arial Black"><strong>Type</strong></font> 
          <font color="#CC3366"> 
          <% 
		 String TYPE="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  // 2003/12/28 改為抓 Type 區分Forecast 類型
		  //sSql = "select trim(MCCOMP) as MCCOMP,  trim(MCCOMP) || '('||MCDESC||')' from WSMULTI_COMP ";		 
		  //sWhere = "where MCCOMP IS NOT NULL and trim(MCCOMP) in('01','08','28','45') ";
		 // 2003/12/28 改為抓 Type  區分Forecast 類型
		  sSql = "select TYPE, TYPE|| '('|| TYPE_DESC_GBL||')' from WSADMIN.WSTYPE_CODE ";
		  sWhere = "where LOCALE in('886') ";
		  		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(type);
	      comboBoxAllBean.setFieldName("TYPE");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rs.next())
		  {		   
            type= rs.getString("TYPE");
		  }
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
          </font></td>
      <td width="30%"><font color="#CC3366" face="Arial Black"><strong>Region</strong></font> 
        <font color="#CC3366"> 
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
        </font></td>
      <td colspan="2"> <font color="#CC3366" face="Arial Black"><strong>Country</strong></font> 
        <font color="#CC3366"> 
        <% 
		 String COUNTRY="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select LOCALE,  LOCALE|| '(' || LOCALE_NAME||')' from WSLOCALE ";		  
		  sWhere = "where LOCALE IS NOT  NULL and LOCALE in('886','60','61','62','63','65', '66','91') ";
		                  //"and LOCALE='"+locale+"'  ";
		                 // "and CONTINENTID='"+regionNo+"'  ";		 
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
        </font></td>
    </tr>
    <tr bgcolor="#D0FFFF"> 
      <td><font color="#CC3366" face="Arial Black"><strong>Year</strong></font> 
        <font color="#CC3366"> 
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
        </font></td>
      <td> <font color="#CC3366" face="Arial Black"><strong>Month</strong></font> 
        <font color="#CC3366"> 
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
       %>
        </font></td>
      <td width="25%"><font color="#CC3366" face="Arial Black"> <strong>Model</strong></font> 
        <font color="#CC3366"> 
        <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select PROJECTCODE as MODEL,  PROJECTCODE|| '('||SALESCODE ||')' from WSADMIN.PIMASTER ";
		  //sWhereRCenter = "where REPCENTERNO = lpad(to_char(REPCENTERNOR),3,'0') ";
		  sWhere = "where PROJECTCODE IS NOT NULL ";
		                 // " and SALESCODE = '"+model+"' ";		 
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
        </font></td>
      <td width="10%"><font color="#CC3366"> 
        <input name="submit1" type="submit" value="Inquiry">
        </font></td>
    </tr>
  </table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="9%" bgcolor="#FFFFCC"><font size="2">Region</font></td>
	  <td width="9%" bgcolor="#FFFFCC"><font size="2">Country</font></td>
	  <td width="9%" bgcolor="#FFFFCC"><font size="2">Type</font></td>
      <td width="9%" bgcolor="#FFFFCC"><font size="2">Model</font></td>	  
	  <td width="9%" bgcolor="#FFFFCC"><font size="2">Qty</font></td>
	  <td width="9%" bgcolor="#FFFFCC"><font size="2">Working Week</font></td>
	  <td width="9%" bgcolor="#FFFFCC"><font size="2">Version</font></td>
	   <td width="9%" bgcolor="#FFFFCC"><font size="2">Person ID</font></td>                
  </tr>
      <% //  *** Main Loop  Start   *** //
       //ResultSet RpRepair = StatementRpRepair.executeQuery(); 
	   
	       if ( yearMonCH >= yearMonCurr )    // 大於目前的年月才Show 資料//
	      {        
            Statement statement=con.createStatement();   		
		    try
		   {   
		           // 2003/12/28 修改只Join PIMASTER及PRODMODEL於維護時
              //String sql = "select  w.FWREG, w.FWCOUN , w.FWTYPE, m.PROJECTCODE, p.MCOLOR, w.FWQTY, w.FWORKWEEK, w.FWWVER, w.FWLUSER from WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
              String sql = "select  w.FWREG, w.FWCOUN , w.FWTYPE, m.PROJECTCODE, w.FWQTY, w.FWORKWEEK, w.FWWVER, w.FWLUSER from WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
        
			 /* String swhere = "where m.PROJECTCODE =w.FWPRJCD and m.PROJECTCODE= p.MPROJ and p.MCOUNTRY=w.FWCOUN  "+
			                           "and w.FWCOLOR = p.MCOLOR ";			  
									   
			  String sWhere = "and w.FWCOLOR IS NOT NULL "; */

             String swhere = "where m.PROJECTCODE =w.FWPRJCD and m.PROJECTCODE= p.MPROJ and p.MCOUNTRY=to_char(w.FWCOUN)  ";			  
									   
			 String sWhere = "and p.MCOLOR IS NOT NULL ";                             
								  
		      //String sWhere = "and w.FWYEAR = '"+YearFr+"'  and w.FWMONTH=  '"+MonthFr+"'  ";
								  
		    if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(w.FWCOUN) !=  'ALL'  "; }
		    else { sWhere = sWhere + "and to_char(w.FWCOUN) =  '"+locale+"'  ";}
		    if (type==null || type.equals("--")) {   sWhere = sWhere + "and w.FWTYPE !=  'ALL'  "; }
		    else { sWhere = sWhere + "and w.FWTYPE =  '"+type+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(w.FWREG) != 'ALL'  "; }
	        else { sWhere = sWhere +  "and to_char(w.FWREG)= '"+regionNo+"'  "; }
		    if (model==null || model.equals("--")) { sWhere = sWhere +  "and w.FWPRJCD !=  'ALL' "; }
		    else { sWhere = sWhere +  "and w.FWPRJCD =  '"+model+"' "; }
			
			String sOrder = "ORDER BY m.PROJECTCODE,w.FWORKWEEK, w.FWWVER ";
			
			sql = sql + swhere + sWhere+sOrder;			
			  
			// 2003/12/28 修改只Join PIMASTER及PRODMODEL於維護時
			/*
			String sql = "select m.PROJECTCODE, p.MCOUNTRY ,p.MCOLOR, p.MITEM from WSADMIN.PIMASTER m, WSADMIN.PRODMODEL p ";
			String swhere = "where m.PROJECTCODE= p.MPROJ  ";
			String sWhere = "and p.MMDATE >= 0 ";
			
			if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and p.MCOUNTRY !=  'ALL'  "; }
		    else { sWhere = sWhere + "and p.MCOUNTRY =  '"+locale+"'  ";}
			if (model==null || model.equals("--")) { sWhere = sWhere +  "and m.SALESCODE !=  'ALL' "; }
		    else { sWhere = sWhere +  "and m.SALESCODE =  '"+model+"' "; }			
			
			*/              						  
		    		
		
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


          if (rs_isEmpty) 
		  {
            rs_total = rs_first = rs_last = 0;
          }

             //set the number of rows displayed on this page
            if (rs_numRows == 0) 
			{
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
       for (i=0; rs_hasData && (i < MM_offset || MM_offset == -1); i++) 
	   {
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
		  //getDataFlag = true;
		  numRow = numRow + 1; // 計算取得列數
		  fmPrjCode = rs.getString("PROJECTCODE");
   %>
  <tr>   
    <td bgcolor="">
     <font size="2">	   
	   <a href='javaScript:wsRegionReportByModel("<%=YearFr%>","<%=MonthFr%>","<%=type%>","<%=regionNo%>")' >
	      <%
	         try
           {   
		    String sSqlR = "";
		    String sWhereR = "";
		    String regionGet = rs.getString("FWREG");
		    if (Integer.parseInt(regionGet)<=9)
		    {regionGet = "0"+regionGet;}
		  
		    sSqlR = "select CONTINENT|| '('||CONTINENT_NAME||')' as REGIONNAME from WSADMIN.WSCONTINENT ";		  
		    sWhereR = "where CONTINENT =  '"+regionGet+"' ";		 
		    sSqlR = sSqlR+sWhereR;		  
		    //out.println(sSql);		      
            Statement stateR=con.createStatement();
            ResultSet rsR= stateR.executeQuery(sSqlR);            
		    if (rsR.next())
		   {		   
             out.println(rsR.getString("REGIONNAME"));		   
		   }
            rsR.close();    
		    stateR.close();  		 
          } //end of try
           catch (Exception e)
          {
           out.println("Exception:"+e.getMessage());		  
          }	      
	     %>
	   </a>   
	 </font>
	</td> 
	 <td>
     <font size="2">
	  <a href='javaScript:wsCountryReportByModel("<%=YearFr%>","<%=MonthFr%>","<%=type%>","<%=regionNo%>","<%=locale%>")' >
	   <%      		 		 
	     try
         {   
		  String sSqlL = "";
		  String sWhereL = "";	  
		  sSqlL = "select LOCALE|| '(' || LOCALE_NAME||')' as LOCALENAME from WSLOCALE ";		  
		  sWhereL = "where LOCALE = '"+rs.getString("FWCOUN")+"' ";		                 
		  sSqlL = sSqlL+sWhereL;		  
		  //out.println(sSqlRCenter);		      
          Statement stateL=con.createStatement();
          ResultSet rsL=stateL.executeQuery(sSqlL);          
		  if (rsL.next())
		  {		   
           out.println(rsL.getString("LOCALENAME"));
		  }
          rsL.close();    
		  stateL.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }    
	   %>
	   </a>
	 </font>
	</td>
	<td>
     <font size="2">
	   <%
	      try
         {   
		  String sSqlE = "";
		  String sWhereE = "";		 
		  sSqlE = "select TYPE|| '('|| TYPE_DESC_GBL||')' as TYPENAME from WSADMIN.WSTYPE_CODE ";
		  sWhereE = "where LOCALE = '"+rs.getString("FWCOUN")+"' and TYPE = '"+rs.getString("FWTYPE")+"' ";
		  		 
		  sSqlE = sSqlE+sWhereE;		  
		  //out.println(sSql);		      
          Statement stateE=con.createStatement();
          ResultSet rsE=stateE.executeQuery(sSqlE);          
		  if (rsE.next())
		  { out.println(rsE.getString("TYPENAME"));}
		  else
		  { out.println("&nbsp;");}
          rsE.close();      
		  stateE.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }	      
	   %>
	 </font>
	</td>    
    <td>
     <font size="2">
	   <%=rs.getString("PROJECTCODE")%>
	   <!--%
	     String MODEL="";		 		 
	     try
         {   
		  String sSqlC = "";
		  String sWhereC = "";
		  
		  sSqlC = "select PROJECTCODE as MODEL,  PROJECTCODE || '('||SALESCODE||')' from WSADMIN.PIMASTER ";		  
		  sWhereC= "where PROJECTCODE IS NOT NULL ";		             		 
		  sSqlC = sSqlC+sWhereC;
		  
		  //out.println(sSqlC);		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxAllBean.setRs(rsC);		  
		  comboBoxAllBean.setSelection(model);
	      comboBoxAllBean.setFieldName("MODEL");	   
          out.println(comboBoxAllBean.getRsString());
		  if (rsC.next())
		  {		   
          model= rsC.getString("MODEL");
		  }
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %-->
	  </font>
	 </td>
    
	 <td>
        <font size="2" color="#000066" ><strong>
	      <%=rs.getString("FWQTY")%>
	    </strong></font>
	 </td>
	 <td>
        <font size="2">
	      <%=rs.getString("FWORKWEEK")%>
	    </font>
	 </td>
	 <td>
        <font size="2">
	      <%=rs.getString("FWWVER")%>
	    </font>
	 </td>
	 <td>
        <font size="2">
	      <%
		      if(rs.getString("FWLUSER")==null)
			  {out.println("&nbsp;");}
			  else
			  {out.println(rs.getString("FWLUSER"));}
		  %>
	    </font>
	 </td>     
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
</html>
