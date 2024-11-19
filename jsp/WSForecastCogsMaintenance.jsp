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
<title>WINS System-Forecast Cogs Inquiry and Maintenance</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="../jsp/WSForecastCogsMaintenance.jsp" METHOD="post" NAME="MYFORM">
<font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Forecast Cogs Maintenance </strong></font>
<%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
<BR>
  <A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back 
  to submenu</A> &nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSExwPriCogsEntry.jsp">Ship-Out 
  Price & COGs Entry </A> 
  <% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     //String regionNo=request.getParameter("REGION");
     String comp=request.getParameter("COMP");
     String type=request.getParameter("TYPE");
     String region=request.getParameter("REGION");
     String country=request.getParameter("COUNTRY"); 
	 String model=request.getParameter("MODEL");                    
   
     String sqlGlobal = "";       	 
  %>
  <table width="100%" border="0">
    <tr> 
      <td width="39%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>Business 
        Unit: </strong></font><font size="2">
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique MCCOMP as x ,MCCOMP||'('||MCDESC||')' from WSMULTI_COMP where MCACCT='Y' ";		  
		  sWhereC= "order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (comp!=null && !comp.equals("--")) comboBoxBean.setSelection(comp);		  		  		  
	      comboBoxBean.setFieldName("COMP");	   
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
      <td width="33%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>Forecast 
        Type: </strong></font><font size="2">
        <%	    	     		 		 
	     try
         { 	   		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		 	             		 
		  sSqlC = "select Unique TYPE as x,TYPE||'('||TYPE_DESC_GBL||')'  from WSTYPE_CODE ";		  
		  sWhereC= "order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if (type!=null && !type.equals("--")) comboBoxBean.setSelection(type);		  		  		  
	      comboBoxBean.setFieldName("TYPE");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font> </td>
      <td width="28%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>REGION 
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
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSForecastCogsMaintenance.jsp"+'"'+")'>");
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
        </strong></font> </td>
    </tr>
    <tr> 
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
          out.println("<select NAME='COUNTRY' onChange='setSubmit("+'"'+"../jsp/WSForecastCogsMaintenance.jsp"+'"'+")'>");
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
      <td bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>MODEL:</strong></font><font size="2">
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
		  if (model!=null && !model.equals("--")) comboBoxBean.setSelection(model);		  		  		  
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
      <td width="28%" bgcolor="#006699"><input name="button" type="button" onClick='setSubmit("../jsp/WSForecastCogsMaintenance.jsp")'  value="Query" ></td>
    </tr>
  </table>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#006666"> 
      <td width="4%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LINK</strong></font></td>
      <td width="6%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>REGION</strong></font></td>
      <td width="15%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>COUNTRY</strong></font></td>
      <td width="12%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>CURRENCY</strong></font></td>
      <td width="11%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>MODEL</strong></font></td>
      <td width="10%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>COGS</strong></font></td>
      <td width="5%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>YEAR</strong></font></td>
      <td width="7%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>MONTH</strong></font></td>
      <td width="16%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>CREATEUSER</strong></font></td>
      <td width="16%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>VERSION</strong></font></td>
    </tr>
    <%  
            try
            {  
              
              Statement statementTC=con.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "select FCCOMP,FCREG,FCCOUN,FCCURR,FCPRJCD,FCCOGS,FCYEAR,FCMONTH,FCTYPE,FCLUSER,FCMVER "+
			                  " from psales_fore_cogs";
			  String sWhereTC = " where FCMVER=(select max(FCMVER) from psales_fore_cogs) and FCPRJCD IS NOT NULL ";
			
			  if (comp == null || comp.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and FCCOMP ='"+comp+"'  "; }
              if (type == null || type.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and FCTYPE = '"+type+"'  "; }
			  if (region == null || region.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and FCREG ='"+region+"'  "; }                      			             
              if (country == null || country.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and FCCOUN = '"+country+"'  "; }	  
              if (model == null || model.equals("--")) { sWhereTC = sWhereTC ; }
			  else { sWhereTC = sWhereTC + "and FCPRJCD = '"+model+"'  "; } 			 
			  
			  String sOrderTC = "order by FCPRJCD,FCYEAR,FCMONTH ";
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  			  
		  // 

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

          // ¢FFFFFD[?J?A-? - !L!| /		
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
         
        %>
    <%
         
          if ((rs1__index % 2) == 0)
         {
	        colorStr = "#FFCCFF";
	     }
	     else
         {
	        colorStr = "#FFFFFF";
         }
        %>
    <tr bgcolor="<%=colorStr%>"> 
      <td><a href="../jsp/WSForecastCogsEdit.jsp?FCCOMP=<%=rsTC.getString("FCCOMP")%>&FCTYPE=<%=rsTC.getString("FCTYPE")%>&FCREG=<%=rsTC.getString("FCREG")%>&FCCOUN=<%=rsTC.getString("FCCOUN")%>&FCCURR=<%=rsTC.getString("FCCURR")%>&FCPRJCD=<%=rsTC.getString("FCPRJCD")%>&FCYEAR=<%=rsTC.getString("FCYEAR")%>&FCMONTH=<%=rsTC.getString("FCMONTH")%>&FCMVER=<%=rsTC.getString("FCMVER")%>"> 
        <div align="center"><img src="../image/docicon.gif" width="14" height="19" border="0"></div></a></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("FCREG")!=null ) { out.println(rsTC.getString("FCREG")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%
                   //if (codeClass==null || codeClass=="2" || codeClass.equals("2"))
                   
                   //  if (rsTC.getString("FCCOUN")!=null) { out.println(rsTC.getString("FCCOUN")); } 
                  //   else { out.println("&nbsp;"); }
                    try
                   {
                     String  sSqlL = "select LOCALE_NAME from WSLOCALE ";		  
		             String sWhereL = " where LOCALE='"+rsTC.getString("FCCOUN")+"'  ";		              
		             sSqlL = sSqlL+sWhereL;
                     Statement statement=con.createStatement();
                     ResultSet rs=statement.executeQuery(sSqlL);
                     if (rs.next()) {  out.println(rs.getString("LOCALE_NAME")); }
                     else {  out.println("&nbsp;"); }
                     rs.close();
                     statement.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }	
                     //=rsTC.getString("TXQTY") 
                 %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getString("FCCURR") !=null) { out.println(rsTC.getString("FCCURR")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getString("FCPRJCD") !=null && rsTC.getString("FCPRJCD") != " " ) { out.println(rsTC.getString("FCPRJCD")); } 
                      else { out.println("&nbsp;"); }
                     
                 %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getInt("FCCOGS") > 0) { out.println(rsTC.getInt("FCCOGS")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getString("FCYEAR") !=null) { out.println(rsTC.getString("FCYEAR")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
      <td><font size="2" color="#CC3366"> 
        <%

                      if (rsTC.getString("FCMONTH") !=null) { out.println(rsTC.getString("FCMONTH")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
      <td nowrap><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getString("FCLUSER") !=null) { out.println(rsTC.getString("FCLUSER")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
      <td nowrap><font size="2" color="#CC3366"> 
        <%
                      if (rsTC.getString("FCMVER") !=null) { out.println(rsTC.getString("FCMVER")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %>
        </font></td>
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
  <BR>
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
<!--=============¢FFFFDH?U¢FFFFXI?q?¢FFFFXAAcn3s¢FFFGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
