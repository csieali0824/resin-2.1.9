<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.lang.Math.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System-Sales Forecast Price Segment Inquiry and Maintenance</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function wsCountryReportByModel(regionGet,countryGet,modelGet,yearGet,monthGet)
{   
  //subWin=window.open("JamCodeOrderbyModelList.jsp?MODEL="+pp+"&DATEBEGIN="+datebegin+"&DATEEND="+dateend+"&REPCENTERNO="+rpcenter,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
  subWin=window.open("WSLaborRateVATMaintEdit.jsp?REGION="+regionGet+"&COUNTRY="+countryGet+"&INTERMODEL="+modelGet+"&YEARTO="+yearGet+"&MONTHTO="+monthGet);  
}
</script>
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
}
-->
</style>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<body>
<font color="#009999" face="Times New Roman" size="+3"><strong>DBTEL</strong></font>
<font color="#000000" face="Times New Roman" size="+2"><strong>Price Plan Inquiry(W/O VAT)</strong></font>
<FORM ACTION="../jsp/WSPricePlanReport.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
<A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     String WSUserID=(String)session.getAttribute("USERNAME");        
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY");   
     String brand=request.getParameter("BRAND"); 
     String interModel=request.getParameter("INTERMODEL");         
     String segment=request.getParameter("SEGMENT");
     String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
     String YearFr=request.getParameter("YEARFR"); 
     String MonthFr=request.getParameter("MONTHFR");
     String dateStringBegin = YearFr+MonthFr;         
     String YearTo=request.getParameter("YEARTO"); 
     String MonthTo=request.getParameter("MONTHTO");
     String dateStringEnd = YearTo+MonthTo;
	 
     //String postChk = request.getParameter("POSTCHK");
     //String model = request.getParameter("MODEL");
     //String sModel = request.getParameter("SMODEL");       
     //String custOrder = request.getParameter("CORDER");
     
     //String UserID=""; 
     String webID=""; 
     //String getRSTRUE = "0";
     String sqlGlobal = "";

     float vatBase = 1;
     
     //float countryFactor = 0;

    if (interModel==null || interModel.equals("")) { interModel= ""; }
    
    try
    { 
     String sqlU = "select VAT from PSALES_COUNTRY_FACTOR where BASECOUNTRY = '86' and COUNTRY = '86' ";	
	 Statement stateU=con.createStatement();
	 ResultSet rsU=stateU.executeQuery(sqlU);
	 if (rsU.next())
	 { 
	  vatBase = 1+rsU.getFloat("VAT"); 
	 }
	 rsU.close();
	 stateU.close();
    } //end of try
    catch (Exception e)
    {
     out.println("Exception:"+e.getMessage());
    } 
  %>
<% 
    if (country==null || country.equals("--")){}   
    else if ((country != null) && !country.equals("--"))
	{out.println(" <A HREF='/wins/report/"+WSUserID+"ForecastPlan_Query.xls'>Price Plan Excel View</A>");}	
 %>
<table width="100%" border="0">
    <tr>
      <td width="22%" bgcolor="#006699"><font color="#FF0066" face="Times New Roman" size="+1"><strong>REGION</strong></font><strong>        
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
          /*
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(brand);
	      comboBoxBean.setFieldName("REGION");	   
          out.println(comboBoxBean.getRsString());		
		 */
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSPricePlanReport.jsp"+'"'+")'>");
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
      </strong></font></td>
      <td width="25%" bgcolor="#006699"><font color="#FF0066" face="Times New Roman" size="+1"><strong>COUNTRY</strong></font><strong>        
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
         /* 
          comboBoxBean.setRs(rs);		  		 
		  if (country!=null) comboBoxBean.setSelection(country);
	      comboBoxBean.setFieldName("COUNTRY");	   
          out.println(comboBoxBean.getRsString());	
         */	
          
          out.println("<select NAME='COUNTRY' onChange='setSubmit("+'"'+"../jsp/WSPricePlanReport.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
            if (s1.equals(country)) 
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
      </strong></font> </td>
      <td width="20%" bgcolor="#006699"><font color="#FF0066" face="Times New Roman" size="+1"><strong>BRAND</strong></font>	  
	   <% 		
	     try
         {   
		  String sSql = "";		 
		  sSql = "select BRAND,BRAND from PIBRAND "; 		  		 		 		  
		
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(brand);
	      comboBoxBean.setFieldName("BRAND");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
      </td> 
      <td width="33%" bgcolor="#006699"><font color="#FF0066" face="Times New Roman" size="+1"><strong>INTERNAL MODEL</strong></font>	  
	  <input name="INTERMODEL" type="text" value="<%=interModel%>" size="15" maxlength="15">
      </td>   
    </tr>
    <tr>
      <td bgcolor="#006699" colspan="3">
        <font color="#FF0066" face="Times New Roman" size="+1"><strong>PLAN DATE FR.</strong></font>
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
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
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
         <font color="#FF0066" face="Times New Roman" size="+1"><strong> ~<font color="#FF0066" face="Times New Roman" size="+1"><strong>PLAN DATE
         TO</strong></font></strong></font>  
         <%
		  String CurrYearTo = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearTo==null)
		  {
		    CurrYearTo=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYearTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearTo);
		  }
	      arrayComboBoxBean.setFieldName("YEARTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> 
      </td>   
      <td bgcolor="#006699" colspan="1">
      <INPUT TYPE="button"  value="Query" onClick='setSubmit("../jsp/WSPricePlanReport.jsp")' >             
      </td> 
      
    </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr bgcolor="#006666">
    <%  
            try
            {  
              
              Statement statementTC=con.createStatement();      // Link To POS SQL DB
             
              /* String sqlTC =  "select DISTINCT BRAND, SEGMENT, SGMNT_FR, SGMNT_TO, FPYEAR, FPMONTH, SREGION, SCOUNTRY "+
			                  "from PSALES_FORE_EXWPRICE, PSALES_PRICE_SGMNT, PSALES_PROD_CENTER ";  */  // 3a!AA¢FDu!!Oa Price Segment |U¢FXI?! //
              String sqlTC =  "select DISTINCT BRAND, SEGMENT, SGMNT_FR, SGMNT_TO, FPYEAR, FPMONTH, SREGION, SCOUNTRY "+
			                  "from PSALES_FORE_PRICE, PSALES_PRICE_SGMNT, PSALES_PROD_CENTER ";
              //String sWhere = "where FPREG=SREGION and FPCOUN=SCOUNTRY and trim(SG_BRAND)=trim(BRAND) "+  // -poaChina ¢FFD~ao?I?¢FFG?A Brand
              String sWhere = "where  "+
              //   "and INTER_MODEL = FPPRJCD and FPPRI between SGMNT_FR and SGMNT_TO ";   //  Price Segment dont 
                               "INTER_MODEL = FPPRJCD and ISACTIVE='Y' "; 
			  String sWhereTC = " ";
			  
              if (region == null || region.equals("--")) { sWhereTC = sWhereTC + "and SREGION = '0'  "; }
			  else { sWhereTC = sWhereTC + "and SREGION ='"+region+"'  "; }  
			  //else { sWhereTC = sWhereTC + "and SREGION ='CHINA'  "; } //一律採用China的 Price Segment 為基準                       			             
              if (country == null || country.equals("--")) { sWhereTC = sWhereTC + "and SCOUNTRY = '0'  "; }
			  else { sWhereTC = sWhereTC + "and SCOUNTRY = '"+country+"'  "; }
			  //else { sWhereTC = sWhereTC + "and SCOUNTRY = '86'  "; }  //一律採用China的 Price Segment 為基準
			  if (brand == null || brand.equals("--")) { sWhereTC = sWhereTC + "and trim(BRAND) != '0'  "; }
			  else { sWhereTC = sWhereTC + "and trim(BRAND) ='"+brand+"'  "; }			
              if (interModel == null || interModel.equals("")) { sWhereTC = sWhereTC + "and INTER_MODEL != '0'  "; }
			  else { sWhereTC = sWhereTC + "and INTER_MODEL = '"+interModel+"'  "; }

              //if (segment == null || segment.equals("--")) { sWhereTC = sWhereTC + "and SEGMENT != '0'  "; }
			  //else { sWhereTC = sWhereTC + "and SEGMENT = '"+segment+"'  "; }
                  
			 if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and FPYEAR || FPMONTH >="+"'"+dateStringBegin+"' ";
             if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and FPYEAR || FPMONTH between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			  //String sOrderTC = "order by FPYEAR, FPMONTH, FPPRI ";
              String sOrderTC = "order by FPYEAR, FPMONTH, BRAND, SEGMENT ";
             
			  sqlTC = sqlTC + sWhere + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // ¢FFFFFFFFFFFFD[?J?A-?-¢FFFFFFFFFFFFX???????o??A_
		 
           // *** Recordset Stats, Move To Record, and Go To Record: declare stats variables

          int rs_first = 1;
          int rs_last  = 1;
          int rs_total = -1;


          if (rs_isEmptyTC) 
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

            ResultSet MM_rs = rsTC;
            int       MM_rsCount = rs_total;
            int       MM_size = rs_numRows;
           String    MM_uniqueCol = "";
           MM_paramName = "";
           int       MM_offset = 0;
           boolean   MM_atTotal = false;
           boolean   MM_paramIsDefined = (MM_paramName.length() != 0 && request.getParameter(MM_paramName) != null);
           //out.println("rs_total="+rs_total);
		   //out.println("rs_numRows="+rs_numRows);
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
       for (i=0; rs_hasDataTC && (i < MM_offset || MM_offset == -1); i++) 
	   {
         rs_hasDataTC = MM_rs.next();
       }
       if (!rs_hasDataTC) MM_offset = i;  // set MM_offset to the last possible record
      }

      // *** Move To Record: if we dont know the record count, check the display range

      if (MM_rsCount == -1) {

      // walk to the end of the display range for this page
      int i;
      for (i=MM_offset; rs_hasDataTC && (MM_size < 0 || i < MM_offset + MM_size); i++) {
      rs_hasDataTC = MM_rs.next();
     }

      // if we walked off the end of the recordset, set MM?|u?????o???_rsCount and MM_size
      if (!rs_hasDataTC) {
      MM_rsCount = i;
      if (MM_size < 0 || MM_size > MM_rsCount) MM_size = MM_rsCount;
    }

        // if we walked off the end, set the offset based on page size
       if (!rs_hasDataTC && !MM_paramIsDefined) {
       if (MM_offset > MM_rsCount - MM_size || MM_offset == -1) { //check if past end or last
       if (MM_rsCount % MM_size != 0)  //last page has less records than MM_size
       MM_offset = MM_rsCount - MM_rsCount % MM_size;
       else
       MM_offset = MM_rsCount - MM_size;
      }
    }

     // reset the cursor to the beginning
     rsTC.close();
     //rs = Statement.executeQuery(s);
     rsTC=statementTC.executeQuery(sqlTC);
     rs_hasDataTC = rsTC.next();
    MM_rs = rsTC;

         // move the cursor to the selected record
        for (i=0; rs_hasDataTC && i < MM_offset; i++) {
        rs_hasDataTC = MM_rs.next();
       }
    }
   //out.println("MM_size Step0="+MM_size);
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
         // *** Go To Record and Move To Record: create???????o??A strings for maintaining URL and Form parameters

       String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
       String[] MM_removeList = { "index", MM_paramName };
        //out.println("MM_size Step1="+MM_size); /////
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


           // *** Move To Record: set the string???????o??As for the first, last, next, and previous links

          //String MM_moveFirst,MM_moveLast,MM_moveNext,MM_movePrev;
         {
           String MM_keepMove = MM_keepBoth;  // keep both Form and URL parameters for moves
           String MM_moveParam = "index=";
           //out.println("MM_size Step2="+MM_size);
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

          // ¢FFFFFFFFFFFFD[?J?A-? - !L!| /		
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
                 // Update recntly non-zero Price to fpPrice //
                   Statement stateRP=con.createStatement();
                   String sqlRP = "select max(FPPRI) as MAXFPPRI, INTER_MODEL from PSALES_FORE_PRICE a, PIBRAND b, PSALES_PROD_CENTER c "+
                                  "where  b.BRAND = c.BRAND and trim(INTER_MODEL) = trim(FPPRJCD) and b.BRAND='"+rsTC.getString("BRAND")+"'"+
                                  "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) "+
                                  "group by INTER_MODEL";   
                   ResultSet rsRP=stateRP.executeQuery(sqlRP);		  
                   while (rsRP.next())
                   {
                     //maxFpPri = rsRP
                     String sSqlUpd="update PSALES_FORE_PRICE set FPRPRICE=? "+
	                                "where FPPRJCD='"+rsRP.getString("INTER_MODEL")+"' ";   
                     //out.println(sSqlUpd);  
                     PreparedStatement seqstmtUpd=con.prepareStatement(sSqlUpd);   
	                 seqstmtUpd.setFloat(1,rsRP.getFloat("MAXFPPRI"));                     
	                 seqstmtUpd.executeUpdate();      
                     seqstmtUpd.close();         
              
                   }  // End of While //
                   rsRP.close();
                   stateRP.close();  
                        
         
        %>
    <td width="12%"  height="19" bgcolor="#6699FF" rowspan="1"  nowrap><font color="#FF0066" size="2"><strong>
      <div align="center">PRICE<br>SEGMENT<BR>(含稅)</div>
    </strong></font></td>
    <td width="88%"  height="19" bgcolor="#6699FF" rowspan="1"  nowrap>
      <table height="100%" width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr>
          <td rowspan="2" width="9%"><font color="#FF0066" size="2"><strong>
            <div align="center">內部<br>型號</div>
          </strong></font></td>
          <td rowspan="2" width="8%"><font color="#FF0066" size="2"><strong>
            <div align="center">內部<br>型號</div>
          </strong></font></td>
          <td rowspan="2" width="7%"><font color="#FF0066" size="2"><strong>
            <div align="center">LAUNCH<br>TIME</div>
          </strong></font></td>
          <td bgcolor="#6699FF" nowrap colspan="12"><div align="center">
              <%out.println("<font color='#FFCC33' size='2'><strong><div align='center'>"+"("+rsTC.getString("BRAND")+")"+rsTC.getString("FPYEAR")+"/"+rsTC.getString("FPMONTH")+"</div></strong></font>");%>
          </div></td>
        </tr>
        <tr>
          <td width="7%"><font color="#FF0066" size="2"><strong><div align="center">銷貨成本</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">銷售量</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">最低<br>零售價</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">零售總額</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">出廠價</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">出廠總額</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">銷貨毛利</div></strong></font></td>
          <td width="6%"><font color="#FF0066" size="2"><strong><div align="center">毛利率</div></strong></font></td>
          <td width="9%"><font color="#FF0066" size="2"><strong><div align="center">CHANNEL 每台利潤</div></strong></font></td>
          <td width="9%"><font color="#FF0066" size="2"><strong><div align="center">CHANNEL 總利潤</div></strong></font></td>
          <td width="9%"><font color="#FF0066" size="2"><strong><div align="center">CHANNEL 利潤率</div></strong></font></td>          
        </tr>
    </table></td>
  </tr>
      <% 
         if ((rs1__index % 2) == 0)
         {
	        colorStr = "#FFFFFF";
	     }
	     else
         {
	        colorStr = "#FFFFFF";
         }
       %>
  <tr bgcolor="<%=colorStr%>">
    <td height="20"><font size="2" color="#000099"><strong>
      <div align="center">
        <% 
            if (rsTC.getString("SEGMENT")!=null ) 
            {
             //out.println(rsTC.getString("SEGMENT")+"<BR>"); 
             out.println(rsTC.getString("SGMNT_FR")+"-"+rsTC.getString("SGMNT_TO"));
            } 
            else { out.println("&nbsp;"); }
      %>
      </div>
    </strong></font></td>
    <td><font size="2" color="#CC3366">
      <table height="100%" width="100%" border="1" cellspacing="0" cellpadding="0">
        <%
               float fpPrice = 0;
               float fwQty = 0;  
               float fpExwPrice = 0;
               float totFpPrice = 0;
               float totFpExwPrice = 0; 
               float cogs=0;
               float sellingProfits=0; 
               float GrossMarginRate=0;    
               float chnlProfit = 0;                 
               float totchnlProfit = 0;
               float chnlPRate = 0;

               float shipPriceCal = 0; 
               float shipPriceGet = 0;   
               float fpPriceGet = 0;
               float vatGet = 1;

			    Statement stateIM=con.createStatement();   			     
				try
		        {  
                   //float maxFpPri = 0;
                     
				  /*
                    String sqlIM = "select DISTINCT INTER_MODEL, EXT_MODEL, LAUNCH_DATE, FPEXWPRI, FPYEAR, FPMONTH, BRAND "+
                                   "from PSALES_FORE_EXWPRICE a, PSALES_PROD_CENTER c ";
                    String whereIM = "where "+   // ?¢FFG?A Brand //
                                    "trim(INTER_MODEL) = trim(FPPRJCD) and (FPEXWPRI+1 between '"+rsTC.getString("SGMNT_FR")+"' and '"+rsTC.getString("SGMNT_TO")+"') "+  // ?uRa¢FFXI?! ?¢FFG¢FFXI?A ?
                                    "and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' "+
                                    "and BRAND='"+rsTC.getString("BRAND")+"' "+
                                    "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) ";               
                  */  
                    String sqlIM = "select DISTINCT INTER_MODEL, EXT_MODEL, LAUNCH_DATE, FPPRI, FPRPRICE, FPYEAR, FPMONTH, b.BRAND, b.BRAND_ADJ "+
                                   "from PSALES_FORE_PRICE a, PIBRAND b, PSALES_PROD_CENTER c ";
                    String whereIM = "where  FPRPRICE != 0 "+
                                     "and b.BRAND = c.BRAND "+   // ?¢FFG?A Brand //
                                     "and trim(INTER_MODEL) = trim(FPPRJCD) and (FPRPRICE+1 between '"+rsTC.getString("SGMNT_FR")+"' and '"+rsTC.getString("SGMNT_TO")+"') "+  // ?uRa¢FFXI?! ?¢FFG¢FFXI?A ?
                                     "and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' "+
                                     "and b.BRAND='"+rsTC.getString("BRAND")+"' "+
                                     "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) "; 
                                                       

                     if (interModel == null || interModel.equals("")) { whereIM = whereIM + "and INTER_MODEL != '0'  "; }
			         else {whereIM = whereIM + "and INTER_MODEL = '"+interModel+"'  "; }

					sqlIM = sqlIM + whereIM;
                       
					//out.println(sqlIM);
					ResultSet rsIM=stateIM.executeQuery(sqlIM);					
					while (rsIM.next())
					{
				     
                     //shipPriceCal = rsIM.getFloat("FPPRI");     
                     Statement stateEXWPrice=con.createStatement();
                     String sqlEXWPrice = "select FPEXWPRI,VAT from PSALES_FORE_EXWPRICE a, PSALES_COUNTRY_FACTOR b where FPYEAR = '"+rsIM.getString("FPYEAR")+"' and FPMONTH='"+rsIM.getString("FPMONTH")+"' "+
                                          "and FPREG='"+region+"' and to_char(FPCOUN)='"+country+"' and (FPEXWPRI+1 between '"+rsTC.getString("SGMNT_FR")+"' and '"+rsTC.getString("SGMNT_TO")+"') "+
                                          "and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                          "and FPCOUN= BASECOUNTRY and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                          "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and c.FPPRJCD=a.FPPRJCD) ";
                                          
                     //out.println(sqlEXWPrice); 
                     ResultSet rsEXWPrice=stateEXWPrice.executeQuery(sqlEXWPrice);
                     if (rsEXWPrice.next()) 
                     {  
                         shipPriceGet = rsEXWPrice.getFloat("FPEXWPRI"); 
                         vatGet = 1+rsEXWPrice.getFloat("VAT"); 
                     }
                     else { shipPriceGet = 0; } 

                     //shipPriceCal = (rsIM.getFloat("FPPRI")/vatBase)*rsIM.getFloat("BRAND_ADJ");  //改取最近不為零之零售價 //
                     shipPriceCal = (rsIM.getFloat("FPRPRICE")/vatBase)*rsIM.getFloat("BRAND_ADJ");
                    /*             
                     if (shipPriceCal !=0 && shipPriceGet!=0)
                     { fpPriceGet = Math.min(shipPriceCal,shipPriceGet); }   // !Lu?GaI!Mu?p¢FDB1s¢FXa?u?¢FG?¢FX1saI   
                     else if (shipPriceCal==0 && shipPriceGet !=0) { fpPriceGet = shipPriceGet; }
                     else if (shipPriceCal!=0 && shipPriceCal ==0) { fpPriceGet = shipPriceCal; }  
                     else { fpPriceGet = 0;  }
                   */
                             
                     if (shipPriceGet>=shipPriceCal && shipPriceCal != 0) { fpPriceGet = shipPriceCal; }  // !Lu?GaI!Mu?p¢FDB1s¢FXa?u?¢FG?¢FX1saI
                     else if (shipPriceGet>=shipPriceCal && shipPriceCal == 0) { fpPriceGet = shipPriceGet; } 
                     else if (shipPriceGet<=shipPriceCal && shipPriceGet != 0) { fpPriceGet = shipPriceGet; }
                     else if (shipPriceGet<=shipPriceCal && shipPriceGet == 0) { fpPriceGet = shipPriceCal; }  
                   
                     //out.println("shipPriceCal="+shipPriceCal);
                     //out.println("shipPriceGet="+shipPriceGet);
                     //out.println("fpPriceGet="+fpPriceGet);
			    %>
        <tr bgcolor="#FFFFFF" >    
          <td width="9%" rowspan="1"><div align="left"><font size="2">
              <%out.println(rsIM.getString("INTER_MODEL"));%>
          </font></div></td>
          <td width="8%" rowspan="1"><div align="left"><font size="2">
              <%out.println(rsIM.getString("EXT_MODEL"));%>
          </font></div></td>
          <td width="7%" rowspan="1"><div align="left"><font size="2">
              <%
                String launchDate = rsIM.getString("LAUNCH_DATE");
                       launchDate = launchDate.substring(0,2)+"/"+ launchDate.substring(2,6);
                out.println(launchDate);            
              %>
          </font></div></td>
          <td width="7%"><div align="right"><font size="2" color="#CC3366">
            <%   /*
                     try
                     {
                         String sqlFactor = "select EXW_ADJ from PSALES_COUNTRY_FACTOR a where  REGION='"+rsTC.getString("SREGION")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"'  ";			  
			            //sqlV1 = sqlV1 + sWhereTC;
			            //out.println(sqlV1);
		              Statement stateFactor=con.createStatement();
		              ResultSet rsFactor=stateFactor.executeQuery(sqlFactor);
                       if (rsFactor.next())
		              {
                         countryFactor = rsFactor.getFloat("EXW_ADJ");
                      } 
                       rsFactor.close();
		               stateFactor.close();	        
                     } //end of try
                     catch (Exception e)
                     {
                      out.println("Exception:"+e.getMessage());		  
                     }	 
               */ 
                     try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              //  String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+  // -poa?D!PC¢FFDH China?¢FFX¢FFDD
                      String sqlV1 = "select FCCOGS, LL_BASECOUN,  LL_COUN_ADJ, EX_RATE  from PSALES_FORE_COGS a, PSALES_COUNTRY_FACTOR b where FCCOUN= BASECOUNTRY and FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {
                       int cogsInt = 0;
                       //cogs=(rsV1.getFloat("FCCOGS")- rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ")*rsV1.getFloat("EX_RATE")); 
                       cogs=(rsV1.getFloat("FCCOGS")-rsV1.getFloat("LL_BASECOUN"))+(rsV1.getFloat("LL_COUN_ADJ"));    
                       cogsInt = Math.round(cogs);                       
                       out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+cogsInt);
                      }
			          else
			          {
                       cogs = 0;
                       out.println("---");
                      }
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                     try
                     {
                      String V1 = "";
			          /*  // For Weekly Quantity
		              String sqlV1 = "select sum(FWQTY) as SUMFWQTY from PSALES_FORE_WEEK a  where FWYEAR='"+rsTC.getString("FPYEAR")+"' and FWMONTH='"+rsTC.getString("FPMONTH")+"' and FWREG='"+rsTC.getString("SREGION")+"' and FWCOUN='"+rsTC.getString("SCOUNTRY")+"' and FWPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FWWVER = (select max(FWWVER) from PSALES_FORE_WEEK b where b.FWYEAR=a.FWYEAR "+
                                     "and b.FWMONTH=a.FWMONTH and b.FWREG=a.FWREG and b.FWCOUN=a.FWCOUN and b.FWPRJCD=a.FWPRJCD) ";
                      */  // For Weekly Quantity
                      String sqlV1 = "select FMQTY as SUMFWQTY from PSALES_FORE_MONTH a  where FMYEAR='"+rsTC.getString("FPYEAR")+"' and FMMONTH='"+rsTC.getString("FPMONTH")+"' and FMREG='"+rsTC.getString("SREGION")+"' and FMCOUN='"+rsTC.getString("SCOUNTRY")+"' and FMPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FMVER = (select max(FMVER) from PSALES_FORE_MONTH b where b.FMYEAR=a.FMYEAR "+
                                                    "and b.FMMONTH=a.FMMONTH and b.FMREG=a.FMREG and b.FMCOUN=a.FMCOUN and b.FMPRJCD=a.FMPRJCD and b.FMTYPE IS NOT NULL) "+
                                     "and FMTYPE IS NOT NULL";				  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {
                       if (rsV1.getString("SUMFWQTY")!=null && !rsV1.getString("SUMFWQTY").equals(""))          
                       {
                       fwQty =  rsV1.getFloat("SUMFWQTY");  
                       out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("SUMFWQTY"));              
                       }
                       else
			           {
                       fwQty = 0;
                       out.println("---");
                       }        
                      }
			          else
			          {
                       fwQty = 0;
                       out.println("---");
                      }
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
          <%
                     try
                     {
                      String V1 = "";
                      int fpPriceInt = 0;  
			          //String sqlV1 = "select FPEXWPRI, EXW_ADJ, GM_INDEX  from PSALES_FORE_EXWPRICE a, PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c where FPCOUN= BASECOUNTRY and FPPRJCD= c.INT_MODEL and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' and b.COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                      //               "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) ";				              		  
			          //String sqlV1 = "select FPPRI, EXW_ADJ, GM_INDEX, VAT  from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c where FPCOUN= BASECOUNTRY and FPPRJCD= c.INT_MODEL and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' and b.COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                      //               "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) ";			
                      // 先抓各國零售價,若無,則抓中國 min(輸入出廠價,計算後出廠價) 再依 (min(輸入出廠價,計算後出廠價)*各國出廠價調整因子)/(1-各國毛利指數)得之
                      String sqlV1 = "select max(FPPRI) as FPPRI, EXW_ADJ, GM_INDEX, VAT  from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c where FPCOUN= b.COUNTRY and trim(FPPRJCD)= trim(c.INT_MODEL) and b.COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE d where d.FPYEAR=a.FPYEAR and d.FPMONTH=a.FPMONTH and d.FPREG=a.FPREG and d.FPCOUN=a.FPCOUN and d.FPPRJCD=a.FPPRJCD) "+
                                     "group by EXW_ADJ, GM_INDEX, VAT";			
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {
                        
                        fpPrice =  (rsV1.getFloat("FPPRI"))/(1+rsV1.getFloat("VAT"));
                        //fpPrice =  rsV1.getFloat("FPPRI")/vatBase;         
                        //out.println(" Get fpPrice="+fpPrice);  
                        fpPriceInt = Math.round(fpPrice);
                        /*
                        String fpPriceStr = Float.toString(fpPrice);            
                        int fpPricePoint = fpPriceStr.indexOf('.');
                        //out.println("step6"); 
                        if (fpPricePoint>=0)
                        {         
                         fpPriceStr = fpPriceStr.substring(0,fpPricePoint);
                        }            
                        fpPriceInt = Integer.parseInt(fpPriceStr);                
                        */       
                        out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpPriceInt);     
                      }
			          else
			          {
                        String sqlV2 = "select EXW_ADJ, GM_INDEX, VAT  from PSALES_COUNTRY_FACTOR b, PSALES_AGENT_GMIDX c "+
                                       "where trim(c.INT_MODEL)='"+rsIM.getString("INTER_MODEL")+"' and b.COUNTRY='"+rsTC.getString("SCOUNTRY")+"' ";
                        Statement stateV2=con.createStatement();
		                ResultSet rsV2=stateV2.executeQuery(sqlV2);                 
                        if (rsV2.next())
		                { 
                         fpPrice =  (fpPriceGet*rsV2.getFloat("EXW_ADJ"))/(1-rsV2.getFloat("GM_INDEX"));  
                         //fpPrice = (Math.round(fpPriceGet)*Math.round(rsV2.getFloat("EXW_ADJ")))/( Math.round(1-rsV2.getFloat("GM_INDEX")) );            
                        }  
                        else 
                        { 
                         fpPrice = 0; 
                        }
                        fpPriceInt = Math.round(fpPrice); 
                        //fpPriceInt = (Math.round(fpPriceGet)*Math.round(rsV2.getFloat("EXW_ADJ")))/( Math.round(1-rsV2.getFloat("GM_INDEX")) ) 
                        out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpPriceInt); 
                        //out.println("---");      
                        rsV2.close();
		                stateV2.close();	                        
                       /*
                       fpPrice =  (fpPriceGet*rsV1.getFloat("EXW_ADJ"))/(1-rsV1.getFloat("GM_INDEX"));
                       String fpPriceStr = Float.toString(fpPrice);            
                       int fpPricePoint = fpPriceStr.indexOf('.');
                        //out.println("step6"); 
                       if (fpPricePoint>=0)
                       {         
                        fpPriceStr = fpPriceStr.substring(0,fpPricePoint);
                       }            
                       fpPriceInt = Integer.parseInt(fpPriceStr);
                       out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpPriceInt);   
                       */                    
                       
                      }
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 
                 %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                 int totFpPriceInt = 0;
                     totFpPrice=fpPrice*fwQty;
                 totFpPriceInt = Math.round(fpPrice)*Math.round(fwQty);     
            /*     
                     String totFpPriceStr =  Float.toString(totFpPrice);    
                 int totFpPricePoint = totFpPriceStr.indexOf('.');  // ????? //
                 // out.println("sellProfitsPoin"+sellProfitsPoint);
                 totFpPriceStr = totFpPriceStr.substring(0,totFpPricePoint); 
            */  
                 out.println(totFpPriceInt);
                    /*
                     try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                  */
                 %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                  /*   try
                     {
                         String sqlFactor = "select EXW_ADJ from PSALES_COUNTRY_FACTOR a where  REGION='"+rsTC.getString("SREGION")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"'  ";			  
			            //sqlV1 = sqlV1 + sWhereTC;
			            //out.println(sqlV1);
		              Statement stateFactor=con.createStatement();
		              ResultSet rsFactor=stateFactor.executeQuery(sqlFactor);
                       if (rsFactor.next())
		              {
                         countryFactor = rsFactor.getFloat("EXW_ADJ");
                      } 
                       rsFactor.close();
		               stateFactor.close();	        
                     } //end of try
                     catch (Exception e)
                     {
                      out.println("Exception:"+e.getMessage());		  
                     }	
                 */
                     try
                     {
                      String V1 = "";
			          //String sqlV1 = "select FPEXWPRI, EXW_ADJ  from PSALES_FORE_EXWPRICE a, PSALES_COUNTRY_FACTOR b where FPCOUN= BASECOUNTRY and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                      //               "and FPMVER = (select max(FPMVER) from PSALES_FORE_EXWPRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and c.FPPRJCD=a.FPPRJCD) ";			  
                      String sqlV1 = "select FPPRI, EXW_ADJ  from PSALES_FORE_PRICE a, PSALES_COUNTRY_FACTOR b where FPCOUN= BASECOUNTRY and FPYEAR='"+rsTC.getString("FPYEAR")+"' and FPMONTH='"+rsTC.getString("FPMONTH")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"' and FPPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FPMVER = (select max(FPMVER) from PSALES_FORE_PRICE c where c.FPYEAR=a.FPYEAR and c.FPMONTH=a.FPMONTH and c.FPREG=a.FPREG and c.FPCOUN=a.FPCOUN and c.FPPRJCD=a.FPPRJCD) ";			  
                               
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
                            int fpExwPriceInt = 0;
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {
                        //fpExwPrice = rsV1.getFloat("FPEXWPRI")*rsV1.getFloat("EXW_ADJ");
                        fpExwPrice = fpPriceGet*rsV1.getFloat("EXW_ADJ");
                        fpExwPriceInt = Math.round(fpExwPrice);   
                        out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+fpExwPriceInt);      
                      }
			          else
			          {
                       fpExwPrice = 0; 
                       out.println("---");
                      }
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                int totFpExwPriceInt = 0; 
                totFpExwPrice=fpExwPrice*fwQty; 
                totFpExwPriceInt=Math.round(fpExwPrice)*Math.round(fwQty);
               /*             
                String totFpExwPriceStr =  Float.toString(totFpExwPrice);     
                 int totFpExwPricePoint =totFpExwPriceStr.indexOf('.');  // ????? //
                //out.println("sellProfitsPoin"+sellProfitsPoint);
                 totFpExwPriceStr = totFpExwPriceStr.substring(0,totFpExwPricePoint); 
               */  
                 out.println(totFpExwPriceInt);
                /*      try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
               */
            %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                  //out.println(totFpExwPrice-(fwQty*cogs)); 
                int sellingProfitsInt = 0; 
                  sellingProfits=totFpExwPrice-(fwQty*cogs);
                sellingProfitsInt = Math.round(fpExwPrice)*Math.round(fwQty)-(Math.round(fwQty)*Math.round(cogs)); 
				//out.println("Math.round(totFpExwPrice)="+Math.round(totFpExwPrice));
				//out.println("Math.round(fwQty)*Math.round(cogs)="+Math.round(fwQty)*Math.round(cogs));            
               /*
                String  sellProfitsStr =  Float.toString(sellingProfits);     
                 int sellProfitsPoint = sellProfitsStr.indexOf('.');  // ????? //
                // out.println("sellProfitsPoin"+sellProfitsPoint);
                 sellProfitsStr = sellProfitsStr.substring(0,sellProfitsPoint);
               */
                if (sellingProfits>=0)
                {    
                 out.println(sellingProfitsInt);
                }
                else { out.println("---"); }                   
                  /* try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                    */
              %>
          </font></div></td>
          <td width="6%"><div align="right"><font size="2" color="#CC3366">
            <%
                String GrossMRStr = "";
                   int GMRLength = 0;
                  // int GrossMRInt = 0;
                 if (fpExwPrice>=0 && sellingProfits>=0 )
                 {
                  //out.println ("totFpExwPrice="+totFpExwPrice);
                  //out.println ("sellingProfits="+sellingProfits);  
                  GrossMarginRate=(sellingProfits/totFpExwPrice)*100;
                  //GrossMRInt = Math.round(GrossMarginRate);   
                  //out.println("step0");      
                  GrossMRStr=Float.toString(GrossMarginRate);
                  //out.println("step0");      
                  GMRLength = GrossMRStr.length();
                  if (GMRLength>=4)
                  {
                   GrossMRStr=GrossMRStr.substring(0,4); 
                  }
                  else { GrossMRStr=GrossMRStr.substring(0,3);  } 
 
                  if (GrossMarginRate==0 || GrossMRStr=="NaN" || GrossMRStr.equals("NaN") )
                  { out.println("---"); }        
                  else { out.println(GrossMRStr+"%"); }
                  
                 }
                 else { out.println("---"); } 
                   /*      try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                */
              %>
          </font></div></td>
          <td width="9%"><div align="right"><font size="2" color="#CC3366">
            <%
              
                    float vat = 0;
                
                     try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select VAT from PSALES_COUNTRY_FACTOR where REGION='"+rsTC.getString("SREGION")+"' and COUNTRY='"+rsTC.getString("SCOUNTRY")+"'  ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {
                        //out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));
                        int chnlProfitInt = 0;         
                        vat = 1+rsV1.getFloat("VAT");
                       if (vat !=0)
                       {    
                         chnlProfit=(fpPrice-fpExwPrice);  // ?uRa?@?s?¢FG!!Ot¢Gg| //
                         chnlProfitInt = Math.round(fpPrice)-Math.round(fpExwPrice);  
                         //chnlProfit=(fpPrice/vat-fpExwPrice);
                        /*
                         String chnlProfitStr=Float.toString(chnlProfit);  
                         int chlProfitPoint=chnlProfitStr.indexOf('.');   // ????? //
                         chnlProfitStr =  chnlProfitStr.substring(0, chlProfitPoint);  // ??????? //  
                        */    
                         if (fpPrice<0) { out.println("---"); }     
                         else { out.println(chnlProfitInt); }  
                         
                       }
                       else
                       {
                         out.println("---");  
                       }        
                      }
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
               
              %>
          </font></div></td>
          <td width="9%"><div align="right"><font size="2" color="#CC3366">
            <%        // out.println("step0");  
                       int totchnlProfitInt = 0;     
                       totchnlProfit = chnlProfit * fwQty;
                       totchnlProfitInt = (Math.round(fpPrice)-Math.round(fpExwPrice))*Math.round(fwQty);
                       /*
                         String totchnlProfitStr=Float.toString(totchnlProfit);  
                         int totchnlProfitPoint=totchnlProfitStr.indexOf('.');   // ????? //
                         totchnlProfitStr =  totchnlProfitStr.substring(0, totchnlProfitPoint);  // ??????? // 
                       */
                         out.println(totchnlProfitInt);  
                     /*    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select FCCOGS from PSALES_FORE_COGS a where FCYEAR='"+rsTC.getString("FPYEAR")+"' and FCMONTH='"+rsTC.getString("FPMONTH")+"' and FCREG='"+rsTC.getString("SREGION")+"' and FCCOUN='"+rsTC.getString("SCOUNTRY")+"' and FCPRJCD='"+rsIM.getString("INTER_MODEL")+"' "+
                                     "and FCMVER = (select max(FCMVER) from  PSALES_FORE_COGS b where b.FCYEAR=a.FCYEAR and b.FCMONTH=a.FCMONTH and b.FCREG=a.FCREG and b.FCCOUN=a.FCCOUN and b.FCPRJCD=a.FCPRJCD ) ";			  
			          //sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println("<font color='#000066'><strong><div align='center'></div></strong></font>"+rsV1.getString("FCCOGS"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                  */
              %>
          </font></div></td>
          <td width="9%"><div align="right"><font size="2" color="#CC3366">
            <%
                     try
                     {
                   
                // int chnlPRateInt = 0;
                 String chnlPRateStr = "";
                 int chnlPRateLength = 0;
                 if (vat!=0 && fpPrice !=0 )
                 {
                  //out.println("Step1");
                  //out.println("fpPrice="+fpPrice+"vat="+vat+"fpExwPrice="+fpExwPrice); 
                  //chnlPRate=((fpPrice/vat)-fpExwPrice)/(fpPrice)*100;
                  chnlPRate=((fpPrice)-fpExwPrice)/(fpPrice)*100;
                  //out.println("Step2");
                  //out.println("((fpPrice/vat)-fpExwPrice)/(fpPrice)*100="+chnlPRate);
                 // chnlPRateInt = Math.round(chnlPRate);
                  //out.println("Step3");
                  chnlPRateStr=Float.toString(chnlPRate); 
                  //out.println("chnlPRateStr="+chnlPRateStr);  
                  chnlPRateLength = chnlPRateStr.length();
                  if (chnlPRateLength>=4)
                  {
                   //out.println("Step4");    
                   chnlPRateStr=chnlPRateStr.substring(0,4); //out.println("Step5"); 
                  }
                  else
                  { //out.println("Step6");
                    chnlPRateStr=chnlPRateStr.substring(0,chnlPRateLength);
                    //out.println("Step7");  
                  }  
                  out.println(chnlPRateStr+"%");
                 }
                 else { out.println("---"); } 
     
                 chnlPRateStr = "";           

                    /*
                       //out.println("fpPrice="+fpPrice+"vat="+vat+"fpExwPrice="+fpExwPrice);
                       chnlPRate=((fpPrice/vat)-fpExwPrice)/(fpPrice)*100;
                       String chnlPRateStr=Float.toString(chnlPRate);  
                       //out.println("chnlPRateStr="+chnlPRateStr);
                       if (chnlPRate >=0 ) 
                       { 
                        int chnlPRatePoint=chnlPRateStr.indexOf('.');   // ????? //
                        chnlPRateStr =  chnlPRateStr.substring(0, chnlPRatePoint);      
                        out.println(chnlPRateStr+"%");
                       }
                       else  
                       { 
                        out.println("--");  
                       }   
                  */           
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                
                 %>
          </font></div></td>          
        </tr>
        <%                
                   //rs_hasData = rs.next();	
                   stateEXWPrice.close();
                   rsEXWPrice.close();
                 }	    // End of While loop   
	              rsIM.close();
	              stateIM.close();
                 } //end of try
                 catch (Exception e)
                 {
                  out.println("Exception:"+e.getMessage());
                 }   
               %>
      </table>
    </font></td>
  </tr>
  <tr>
   <td colspan="2">&nbsp;</td>
  </tr>
  <%
               rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
             }
	        //tmpSalesCde = rs.getString("SALESCODE");
            //  stateBPCS.close();     // ??BPCS??? //
	          rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>  
 </table>
</tr>
</table>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>">
<div align="left"></div>
<% // ¢FFD[?JExcel 
     int modLength = 0;
	 String modPlus = "";
     if (brand == null || brand.equals("--"))
	 {}
	 else
	 {
	    modLength = brand.length();
		//out.println("modLength="+modLength);
	    modPlus =  brand.substring(modLength-1,modLength);
	   // out.println("modPlus="+modPlus);
	 }
    
    if ((YearFr==null && MonthFr==null ))
	{	   
	 out.println("<img src='WSForecastPlanQuery2Excel.jsp?YEARFR="+YearFr+"&YEARTO="+YearTo+"&MONTHFR="+MonthFr+"&MONTHTO="+MonthTo+"&BRAND="+brand+"&REGION="+region+"&COUNTRY="+country+"&INTERMODEL="+interModel+"&USERNAME="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;");	      
	 /*
      if (modPlus.equals("+"))
	  {	  
	    model = model.substring(0,modLength-1)+"PLUS";
		out.println("<img src='WSForecastQuery2Excel.jsp?YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&TYPE="+type+"&MODEL="+model+"&REGION="+regionNo+"&LOCALE="+locale+"&USERID="+WSUserID+"'>&nbsp;&nbsp;");	     
      }
	  else
	  {	        	
		out.println("<img src='WSForecastQuery2Excel.jsp?YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&TYPE="+type+"&MODEL="+model+"&REGION="+regionNo+"&LOCALE="+locale+"&USERID="+WSUserID+"'>&nbsp;&nbsp;");	  		
	  }	  
    */
	}
	else
	{	 
     out.println("<img src='WSForecastPlanQuery2Excel.jsp?YEARFR="+YearFr+"&YEARTO="+YearTo+"&MONTHFR="+MonthFr+"&MONTHTO="+MonthTo+"&BRAND="+brand+"&REGION="+region+"&COUNTRY="+country+"&INTERMODEL="+interModel+"&USERNAME="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;");	          
     /*  
	   if (modPlus.equals("+"))
	  {
	    model = model.substring(0,modLength-1)+"PLUS";		
		out.println("<img src='WSForecastQuery2Excel.jsp?YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&TYPE="+type+"&MODEL="+model+"&REGION="+regionNo+"&LOCALE="+locale+"&USERID="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;"); 		
	  }
	  else
	  {	    
		out.println("<img src='WSForecastQuery2Excel.jsp?YEARFR="+YearFr+"&MONTHFR="+MonthFr+"&TYPE="+type+"&MODEL="+model+"&REGION="+regionNo+"&LOCALE="+locale+"&USERID="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;");	  
	  }
      */
	} 
%>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveFirst%>">First</A></strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_movePrev%>">Previous</A></strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveNext%>">Next</A></strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveLast%>">Last</A></strong></font></pre>
      </div></td>
  </tr>  
</table>
</body>
<!--=============¢FFFFFFFFFFFDH?U¢FFFFFFFFFFFXI?q?¢FFFFFFFFFFFXAAcn3s¢FFFFFFFFFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
