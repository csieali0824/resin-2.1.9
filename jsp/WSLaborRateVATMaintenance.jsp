<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
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
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Sales Forecast Labor Load(Rate/VAT) Data Inquiry</strong></font>
<FORM ACTION="../jsp/WSPriceSegmentMaintHView.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
<A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;<A HREF="../jsp/WSLaborRateVATEntry.jsp">SALES FORECAST LABOR/RATE/VAT INPUT</A>
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY");   
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

     
     //if (interModel==null || interModel.equals("")) { interModel= ""; }
    

     //String sqlU = "select WEBID from RPUSER where USERID = '"+userID+"' ";	
	 //Statement stateU=con.createStatement();
	 //ResultSet rsU=stateU.executeQuery(sqlU);
	 //if (rsU.next())
	 //{ 
	 // webID = rsU.getString("WEBID"); 
	 //}
     //out.println("webID="+webID);
     //out.println("UserID="+userID);
	 //rsU.close();
	 //stateU.close();
  %>
<table width="100%" border="0">
    <tr>
      <td width="34%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>REGION  
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
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSLaborRateVATMaintenance.jsp"+'"'+")'>");
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
      <td bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>COUNTRY
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
          out.println("<select NAME='COUNTRY' onChange='setSubmit("+'"'+"../jsp/WSLaborRateVATMaintenance.jsp"+'"'+")'>");
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
      </strong></font>
      </td>   
      <td width="31%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>INTERNAL MODEL
        <%
          try
            {   
		      String sSql = "";
		      String sWhere = "";
		  
		       sSql = "select DISTINCT INTER_MODEL as x , INTER_MODEL from PSALES_PROD_CENTER ";		  
		       sWhere = "where (BRAND in('DBTEL','Dbtel') or BRAND in(select DISTINCT BRAND from PSALES_PROD_CENTER)) order by x";		 
		       sSql = sSql+sWhere;		  
		  		      
               Statement stateB=con.createStatement();
               ResultSet rsB=stateB.executeQuery(sSql);
		      /* comboBoxBean.setRs(rsB);
               comboBoxBean.setSelection(brand);		  		  		  
	           comboBoxBean.setFieldName("BRAND");	   
               out.println(comboBoxBean.getRsString()); */
		      out.println("<select NAME='INTERMODEL' onChange='setSubmit("+'"'+"../jsp/WSLaborRateVATMaintenance.jsp"+'"'+")'>");
              out.println("<OPTION VALUE=-->--");     
              while (rsB.next())
              {            
               String s1=(String)rsB.getString(1); 
               String s2=(String)rsB.getString(2); 
                        
                  if (s1.equals(interModel)) 
                 {
                   out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                 } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
                }        
             } //end of while
             out.println("</select>"); 	
          
          rsB.close();    
		  stateB.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         } 
        %>  
      </strong></font>
      <INPUT TYPE="button"  value="Query" onClick='setSubmit("../jsp/WSLaborRateVATMaintenance.jsp")' ></td>    
    </tr>
    <tr>
      <td bgcolor="#006699" colspan="3">
        <font color="#FF0066" face="Arial Black"><strong>DATE FR.</strong></font>
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
         <font color="#FF0066" face="Arial Black"><strong> ~<font color="#FF0066" face="Arial Black"><strong>DATE TO</strong></font></strong></font>  
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
    </tr>
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#006666"> 
		  <td width="13%"  height="19" bgcolor="#6699FF" nowrap><font color="#FF0066" size="2"><strong>REGION</strong></font></td>
          <td width="10%"  height="19" bgcolor="#6699FF" nowrap><font color="#FF0066" size="2"><strong>COUNTRY</strong></font></td>          	  
		  <td width="6%" bgcolor="#6699FF" nowrap><font color="#FF0066" size="2"><strong>INTERNAL MODEL</strong></font></td>            
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
           <%
             ymh1=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh1);
           %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
           <% dateBean.setAdjMonth(1);
             ymh2=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh2);
           %></div></font></strong></font>
          </td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center"> 
           <% dateBean.setAdjMonth(1);
             ymh3=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh3);
           %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh4=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh4);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
           <% dateBean.setAdjMonth(1);
             ymh5=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh5);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh6=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh6);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh7=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh7);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh8=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh8);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh9=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh9);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh10=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh10);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh11=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh11);
            %></div></font></strong></font></td>
          <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LBL/RATE<BR><font color="#FF0000"><div align="center">
            <% dateBean.setAdjMonth(1);
             ymh12=dateBean.getYearString()+"/"+dateBean.getMonthString();
		     out.println(ymh12);
            %></div></font></strong></font></td>   		  
        </tr> 
          <%  
            try
            {  
              
              Statement statementTC=con.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "select DISTINCT REGION,COUNTRY,INT_MODEL "+
			                          "from PSALES_LBLRATE_VAT ";
              String sWhere = "where REGION IS NOT NULL "; 
			  String sWhereTC = " ";
			  
              if (region == null || region.equals("--")) { sWhereTC = sWhereTC + "and REGION != '0'  "; }
			  else { sWhereTC = sWhereTC + "and REGION ='"+region+"'  "; }                      			             
              if (country == null || country.equals("--")) { sWhereTC = sWhereTC + "and COUNTRY != '0'  "; }
			  else { sWhereTC = sWhereTC + "and COUNTRY = '"+country+"'  "; }
			  if (interModel == null || interModel.equals("--")) { sWhereTC = sWhereTC + "and INT_MODEL != '0'  "; }
			  else { sWhereTC = sWhereTC + "and INT_MODEL ='"+interModel+"'  "; }			
              //if (segment == null || segment.equals("--")) { sWhereTC = sWhereTC + "and SEGMENT != '0'  "; }
			  //else { sWhereTC = sWhereTC + "and SEGMENT = '"+segment+"'  "; }
                  
			 if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and SYEAR || SMONTH >="+"'"+dateStringBegin+"' ";
             if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and SYEAR || SMONTH between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			  String sOrderTC = "order by COUNTRY,INT_MODEL ";
             
			  sqlTC = sqlTC + sWhere + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // ¢FFFFFFD[?J?A-?-¢FFFFFFX???????o??A_
		 
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

          // ¢FFFFFFD[?J?A-? - !L!| /		
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
         
        %>
        <%
         
          if ((rs1__index % 2) == 0)
         {
	        colorStr = "#CCCCFF";
	     }
	     else
         {
	        colorStr = "#CCFFFF";
         }
        %>
        <tr bgcolor="<%=colorStr%>">
          <td height="20"><font size="2" color="#000099">
                 <% 
                      if (rsTC.getString("REGION")!=null ) { out.println(rsTC.getString("REGION")); } 
                      else { out.println("&nbsp;"); }
                  %></font></td>		           	           
		  <td><font size="2" color="#CC3366">
                 <%
                   //if (codeClass==null || codeClass=="2" || codeClass.equals("2"))
                   
                     if (rsTC.getString("COUNTRY")!=null) { out.println(rsTC.getString("COUNTRY")); } 
                     else { out.println("&nbsp;"); }
                  
                     //=rsTC.getString("TXQTY") 
                 %></font></td>
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("INT_MODEL") !=null) { out.println(rsTC.getString("INT_MODEL")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>	          
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh1.substring(0,4)%>","<%=ymh1.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh1.substring(0,4)+"' and SMONTH='"+ymh1.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          //out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>	
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh2.substring(0,4)%>","<%=ymh2.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh2.substring(0,4)+"' and SMONTH='"+ymh2.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh3.substring(0,4)%>","<%=ymh3.substring(5,7)%>")' >
                 <%
                     try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh3.substring(0,4)+"' and SMONTH='"+ymh3.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	       
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh4.substring(0,4)%>","<%=ymh4.substring(5,7)%>")' >
                 <%
                   try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh4.substring(0,4)+"' and SMONTH='"+ymh4.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh5.substring(0,4)%>","<%=ymh5.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh5.substring(0,4)+"' and SMONTH='"+ymh5.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh6.substring(0,4)%>","<%=ymh6.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh6.substring(0,4)+"' and SMONTH='"+ymh6.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh7.substring(0,4)%>","<%=ymh7.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh7.substring(0,4)+"' and SMONTH='"+ymh7.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh8.substring(0,4)%>","<%=ymh8.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh8.substring(0,4)+"' and SMONTH='"+ymh8.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh9.substring(0,4)%>","<%=ymh9.substring(5,7)%>")' >
                 <%
                   try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh9.substring(0,4)+"' and SMONTH='"+ymh9.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh10.substring(0,4)%>","<%=ymh10.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh10.substring(0,4)+"' and SMONTH='"+ymh10.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh11.substring(0,4)%>","<%=ymh11.substring(5,7)%>")' >
                 <%
                    try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh11.substring(0,4)+"' and SMONTH='"+ymh11.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>
          <td><font size="2" color="#CC3366"><a href='javaScript:wsCountryReportByModel("<%=rsTC.getString("REGION")%>","<%=rsTC.getString("COUNTRY")%>","<%=rsTC.getString("INT_MODEL")%>","<%=ymh12.substring(0,4)%>","<%=ymh12.substring(5,7)%>")' >
                 <%
                   try
                     {
                      String V1 = "";
			          //int week1 = Integer.parseInt(workingDateBean.getWorkingWeek());
		              String sqlV1 = "select LBL_LOAD, EXRATE from PSALES_LBLRATE_VAT where SYEAR='"+ymh12.substring(0,4)+"' and SMONTH='"+ymh12.substring(5,7)+"' and REGION='"+rsTC.getString("REGION")+"' and COUNTRY='"+rsTC.getString("COUNTRY")+"' and INT_MODEL='"+rsTC.getString("INT_MODEL")+"' ";			  
			          sqlV1 = sqlV1 + sWhereTC;
			          ///out.println(sqlV1);
		              Statement stateV1=con.createStatement();
		              ResultSet rsV1=stateV1.executeQuery(sqlV1);
		              if (rsV1.next())
		              {out.println(rsV1.getString("LBL_LOAD")+"<font color='#000066'><strong><div align='center'><BR></div></strong></font>"+rsV1.getString("EXRATE"));}
			          else
			          {out.println("---");}
			          rsV1.close();
		              stateV1.close();	
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());		  
                    }	
                 %></a></font></td>    
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
  </table><BR>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>"> <BR>
<div align="left"></div>
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
<!--=============¢FFFFFDH?U¢FFFFFXI?q?¢FFFFFXAAcn3s¢FFFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
