<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="DateBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Monthly Forecast Inquiry Country Report</title>
</head>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM ACTION="../jsp/WSForecastColorRpt.jsp" METHOD="post" NAME="MYFORM">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#000000" size="+2" face="Arial Black"><strong>DBTEL</strong></font></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
  Forecast <font color="#990066">Color</font> Report</font> 
  <%
   int rs1__numRows = 24;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
%>
  <%     
  String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
  //String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
   String locale=request.getParameter("LOCALE");
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR"); 
  String model=request.getParameter("MODEL"); 
  String color=request.getParameter("COLOR");
  String yearMonthString[][]=new String[12][2]; //做為存入year及month陣列 
  if (YearFr==null || YearFr.equals(""))
  {YearFr=dateBean.getYearString();}
  if (MonthFr==null || MonthFr.equals(""))
  {MonthFr=dateBean.getMonthString();}
 
  int numRow = 0;
  
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
 
  String fmPrjCode = "";
  
  int monCurr = 0;
  int monNext =  0;
  int monNext2 = 0;
  
 if ( (MonthFr== null) || MonthFr.equals(""))
  {
  } else  {
      monCurr = Integer.parseInt(MonthFr);   // 若選擇的月份小於等於10月
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
	
	if ( YearFr != null || !YearFr.equals("--") ) 
	{
	   if ( MonthFr!= null || !MonthFr.equals("")) 
	   {
	     adjDateBean.setDate(Integer.parseInt(YearFr),Integer.parseInt(MonthFr),1);
	   } else {
	     adjDateBean.setDate(Integer.parseInt(YearFr),dateBean.getMonth(),1);
	   }
	} else {
	   if ( MonthFr!= null || !MonthFr.equals("")) 
	   {
	     adjDateBean.setDate(dateBean.getYear(),Integer.parseInt(MonthFr),1);
	   } else {
	      adjDateBean.setDate(dateBean.getYear(),dateBean.getMonth(),1); 
	   }
	} //end of YearFr about to Set WorkingBean if		
%>
  <table width="100%" border="0">
    <tr bgcolor="#D0FFFF"> 
      <td width="26%" height="23" bordercolor="#FFFFFF"> <p><font color="#CC3366" face="Arial Black"><strong>Type</strong></font> 
          <font color="#CC3366"> 
          <% 
		 String TYPE="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";		
		  sSql = "select TYPE, TYPE_DESC_GBL from WSADMIN.WSTYPE_CODE ";
		  sWhere = "where LOCALE in('886') ";
		  		 
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(type);
	      comboBoxAllBean.setFieldName("TYPE");	   
          out.println(comboBoxAllBean.getRsString());		 
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
          </font></td>
      <td width="24%"><font color="#CC3366" face="Arial Black"><strong>Region</strong></font> 
        <font color="#CC3366"> 
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
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(regionNo);
	      comboBoxAllBean.setFieldName("REGION");	   
          out.println(comboBoxAllBean.getRsString());		 
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
		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select LOCALE,  LOCALE_NAME||'('||LOCALE_ENG_NAME||')' from WSLOCALE ";		  
		  sWhere = "where LOCALE IS NOT  NULL ";
		                  
		  sSql = sSql+sWhere;		  
		 	      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);			   
		  comboBoxAllBean.setSelection(locale);
	      comboBoxAllBean.setFieldName("LOCALE");	   
          out.println(comboBoxAllBean.getRsString());		  
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
      <td width="39%"><font color="#CC3366" face="Arial Black"> <strong>Model</strong></font> 
        <font color="#CC3366"> 
        <% 
		 String MODEL="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  //sSql = "select trim(PROJECTCODE) as MODEL,  PROJECTCODE|| '('||SALESCODE ||')' from PIMASTER ";		 
		  //sWhere = "where PROJECTCODE IS NOT NULL order by MODEL";		              	 
		  sSql = "select trim(PROJECTCODE) as MODEL,trim(PROJECTCODE)||'('||trim(SALESCODE)||')' from PIMASTER ";		  
		  sWhere= " order by MODEL";
		  sSql = sSql+sWhere;
		  
		  //out.println(sSql);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxAllBean.setRs(rs);		  
		  comboBoxAllBean.setSelection(model);
	      comboBoxAllBean.setFieldName("MODEL");	   
          out.println(comboBoxAllBean.getRsString());		 
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
        </font></td>
      <td width="11%"><font color="#CC3366"> 
        <input name="submit1" type="submit" value="Inquiry">
        </font></td>
    </tr>
  </table>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">
    <tr> 
      <td width="5%" bgcolor="#FFFFCC" nowrap><font size="2">Model </font></td>
      <td width="5%" bgcolor="#FFFFCC" nowrap><font size="2"> Type</font></td>  
      <td bgcolor="#FFFFCC">Color</td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% 
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[0][0] = adjDateBean.getYearString();yearMonthString[0][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[1][0] = adjDateBean.getYearString();yearMonthString[1][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[2][0] = adjDateBean.getYearString();yearMonthString[2][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[3][0] = adjDateBean.getYearString();yearMonthString[3][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[4][0] = adjDateBean.getYearString();yearMonthString[4][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[5][0] = adjDateBean.getYearString();yearMonthString[5][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[6][0] = adjDateBean.getYearString();yearMonthString[6][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[7][0] = adjDateBean.getYearString();yearMonthString[7][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[8][0] = adjDateBean.getYearString();yearMonthString[8][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[9][0] = adjDateBean.getYearString();yearMonthString[9][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[10][0] = adjDateBean.getYearString();yearMonthString[10][1]= adjDateBean.getMonthString();%>
      </font></div></td>
      <td colspan="1" bgcolor="#FFFFCC"><div align="center"><font size="2">
          <% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[11][0] = adjDateBean.getYearString();yearMonthString[11][1]= adjDateBean.getMonthString();%>
      </font></div></td>
    </tr>
    <% //  *** Main Loop  Start   *** //    	   	   
           Statement statement=con.createStatement();   		
		   try
		   {                                      			  
			String sql = "select  DISTINCT w.FMREG, w.FMCOUN , w.FMTYPE, w.FMPRJCD,FMCOLOR from WSADMIN.PSALES_FORE_MONTH w  ";
			String swhere = "where w.FMQTY>0 and FMVER in (select max(FMVER) from PSALES_FORE_MONTH where FMYEAR||FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[11][0]+yearMonthString[11][1]+"' and FMREG=w.FMREG and FMCOUN=w.FMCOUN and FMTYPE=w.FMTYPE and FMPRJCD=w.FMPRJCD and FMCOLOR=w.FMCOLOR) and FMYEAR||FMMONTH between '"+yearMonthString[0][0]+yearMonthString[0][1]+"' and '"+yearMonthString[11][0]+yearMonthString[11][1]+"' ";                          			  									   			
			String sWhere = "and w.FMPRJCD IS NOT NULL and w.FMTYPE is not null ";    			
								  
		    if (locale==null || locale.equals("--")) {   sWhere = sWhere + "and to_char(w.FMCOUN) !=  'ALL'  "; }
		    else { sWhere = sWhere + "and to_char(w.FMCOUN) =  '"+locale+"'  ";}		 
		    if (type!=null && !type.equals("--")) 
		      { sWhere = sWhere + "and w.FMTYPE =  '"+type+"'  "; }
            if (regionNo==null || regionNo.equals("--")) { sWhere = sWhere + "and to_char(w.FMREG) != 'ALL'  "; }
	        else { sWhere = sWhere +  "and to_char(w.FMREG)= '"+regionNo+"'  "; }
		    if (model==null || model.equals("--")) { sWhere = sWhere +  "and w.FMPRJCD !=  'ALL' "; }
		    else { sWhere = sWhere +  "and w.FMPRJCD =  '"+model+"' "; }
		  
		    String sOrder = "ORDER BY w.FMPRJCD ";
			
			sql = sql + swhere + sWhere+sOrder;							  		   				
            
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
		  //fmPrjCode = rs.getString("PROJECTCODE");
   %>
    <tr> 
      <td nowrap> <font size="2"> 
        <%
	      out.println(rs.getString("FMPRJCD"));		   			
	   %>
        </font> </td>
      <td><font size="2">
        <%
	      try
         {   
		  String sSqlE = "";
		  String sWhereE = "";		 
		  sSqlE = "select  TYPE_DESC_GBL as TYPENAME from WSADMIN.WSTYPE_CODE ";		  
		  sWhereE = "where TYPE = '"+rs.getString("FMTYPE")+"' ";
		  		 
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
        </font> </td>
      <td><font size="2">
        <%
	      try
         {   
		  String sSqlE = "";
		  String sWhereE = "";		 
		  sSqlE = "select  COLORDESC from PICOLOR_MASTER ";		  
		  sWhereE = "where COLORCODE = '"+rs.getString("FMCOLOR")+"' ";
		  		 
		  sSqlE = sSqlE+sWhereE;		  
		  //out.println(sSql);		      
          Statement stateE=con.createStatement();
          ResultSet rsE=stateE.executeQuery(sSqlE);          
		  if (rsE.next())
		  { out.println(rsE.getString("COLORDESC"));}
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
      </font></td>
      <td><font size="2">
        <%		   		      		       		 
		       String sqlV1= "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[0][0]+"' and FMMONTH ='"+yearMonthString[0][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[0][0]+"' and FMMONTH ='"+yearMonthString[0][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			  			   			   
		       Statement stateV1=con.createStatement();
		       ResultSet rsV1=stateV1.executeQuery(sqlV1);
		     if (rsV1.next())
		       { 
			     if (rsV1.getString("SUMQTY")!=null) {out.println(rsV1.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV1.close();
		       stateV1.close();		
		%>
      </font> </td>
      <td><font size="2">
        <%				      		 
		       String sqlV2= "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[1][0]+"' and FMMONTH ='"+yearMonthString[1][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[1][0]+"' and FMMONTH ='"+yearMonthString[1][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   			  			   
		       Statement stateV2=con.createStatement();
		       ResultSet rsV2=stateV2.executeQuery(sqlV2);
		     if (rsV2.next())
		       { 
			     if (rsV2.getString("SUMQTY")!=null) {out.println(rsV2.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV2.close();
		       stateV2.close();
		%>
      </font> </td>
      <td><font size="2">
        <%		    		       		 
		       String sqlV3=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[2][0]+"' and FMMONTH ='"+yearMonthString[2][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[2][0]+"' and FMMONTH ='"+yearMonthString[2][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";				  			      
		       Statement stateV3=con.createStatement();
		       ResultSet rsV3=stateV3.executeQuery(sqlV3);
		      if (rsV3.next())
		       { 
			     if (rsV3.getString("SUMQTY")!=null) {out.println(rsV3.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV3.close();
		       stateV3.close();
		%>
      </font> </td>
      <td><font size="2">
        <%				       		 
		       String sqlV4=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[3][0]+"' and FMMONTH ='"+yearMonthString[3][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[3][0]+"' and FMMONTH ='"+yearMonthString[3][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   		   
		       Statement stateV4=con.createStatement();
		       ResultSet rsV4=stateV4.executeQuery(sqlV4);
		      if (rsV4.next())
		       { 
			     if (rsV4.getString("SUMQTY")!=null) {out.println(rsV4.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV4.close();
		       stateV4.close();		
		%>
      </font> </td>
      <td><font size="2">
        <%		       			 
		       String sqlV5=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[4][0]+"' and FMMONTH ='"+yearMonthString[4][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[4][0]+"' and FMMONTH ='"+yearMonthString[4][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   		   
		       Statement stateV5=con.createStatement();
		       ResultSet rsV5=stateV5.executeQuery(sqlV5);
		      if (rsV5.next())
		       { 
			     if (rsV5.getString("SUMQTY")!=null) {out.println(rsV5.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV5.close();
		       stateV5.close();	
		%>
      </font> </td>
      <td><font size="2">
        <%				       			 
		       String sqlV6=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[5][0]+"' and FMMONTH ='"+yearMonthString[5][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[5][0]+"' and FMMONTH ='"+yearMonthString[5][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			  		   
		       Statement stateV6=con.createStatement();
		       ResultSet rsV6=stateV6.executeQuery(sqlV6);
		     if (rsV6.next())
		       { 
			     if (rsV6.getString("SUMQTY")!=null) {out.println(rsV6.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV6.close();
		       stateV6.close();
		%>
      </font> </td>
      <td><font size="2">
        <%		  		       			 
		       String sqlV7=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[6][0]+"' and FMMONTH ='"+yearMonthString[6][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[6][0]+"' and FMMONTH ='"+yearMonthString[6][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   	   
		       Statement stateV7=con.createStatement();
		       ResultSet rsV7=stateV7.executeQuery(sqlV7);
		      if (rsV7.next())
		       { 
			     if (rsV7.getString("SUMQTY")!=null) {out.println(rsV7.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV7.close();
		       stateV1.close();
		%>
      </font> </td>
      <td><font size="2">
        <%		       			 
		       String sqlV8=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[7][0]+"' and FMMONTH ='"+yearMonthString[7][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[7][0]+"' and FMMONTH ='"+yearMonthString[7][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";				  			   	   
		       Statement stateV8=con.createStatement();
		       ResultSet rsV8=stateV8.executeQuery(sqlV8);
		      if (rsV8.next())
		       { 
			     if (rsV8.getString("SUMQTY")!=null) {out.println(rsV8.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV8.close();
		       stateV8.close();
		%>
      </font> </td>
      <td><font size="2">
        <%		 		        
		       String sqlV9=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[8][0]+"' and FMMONTH ='"+yearMonthString[8][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[8][0]+"' and FMMONTH ='"+yearMonthString[8][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";				  			   	   
		       Statement stateV9=con.createStatement();
		       ResultSet rsV9=stateV9.executeQuery(sqlV9);
		       if (rsV9.next())
		       { 
			     if (rsV9.getString("SUMQTY")!=null) {out.println(rsV9.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV9.close();
		       stateV9.close();
		%>
      </font> </td>
      <td><font size="2">
        <%		  		    			 
		       String sqlV10=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[9][0]+"' and FMMONTH ='"+yearMonthString[9][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[9][0]+"' and FMMONTH ='"+yearMonthString[9][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";		  			     
		       Statement stateV10=con.createStatement();
		       ResultSet rsV10=stateV10.executeQuery(sqlV10);
		       if (rsV10.next())
		       { 
			     if (rsV10.getString("SUMQTY")!=null) {out.println(rsV10.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV10.close();
		       stateV10.close();	
		%>
      </font> </td>
      <td><font size="2">
        <%		   		       		 
		       String sqlV11=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[10][0]+"' and FMMONTH ='"+yearMonthString[10][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[10][0]+"' and FMMONTH ='"+yearMonthString[10][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   		   
		       Statement stateV11=con.createStatement();
		       ResultSet rsV11=stateV11.executeQuery(sqlV11);
		      if (rsV11.next())
		       { 
			     if (rsV11.getString("SUMQTY")!=null) {out.println(rsV11.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV11.close();
		       stateV11.close();	
		%>
      </font> </td>
      <td><font size="2">
        <%		  		        
		       String sqlV12=  "select sum(FMQTY) as SUMQTY from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[11][0]+"' and FMMONTH ='"+yearMonthString[11][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMVER||FMCOLOR in (select max(FMVER)||FMCOLOR from PSALES_FORE_MONTH where FMYEAR='"+yearMonthString[11][0]+"' and FMMONTH ='"+yearMonthString[11][1]+"' and FMPRJCD = '"+rs.getString("FMPRJCD")+"' and FMCOUN='"+rs.getString("FMCOUN")+"' and FMCOLOR='"+rs.getString("FMCOLOR")+"' group by FMCOLOR)";			  			   		   
		       Statement stateV12=con.createStatement();
		       ResultSet rsV12=stateV12.executeQuery(sqlV12);
		       if (rsV12.next())
		       { 
			     if (rsV12.getString("SUMQTY")!=null) {out.println(rsV12.getString("SUMQTY"));}
				    else {out.println("---");}			     
			   } else  {out.println("---");}
			   rsV12.close();
		       stateV12.close();	
		%>
      </font> </td>
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
%>
  </table> 
-----MONTHLY FORECAST -------------------------------------------------------------<font color="#0000FF"><strong>(Unit/K
pcs)</strong></font>------------------   
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
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</html>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
