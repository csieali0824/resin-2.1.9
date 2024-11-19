<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<!--%@ include file="/jsp/include/AuthenticationPage.jsp"%>--
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/ConnectionPoolPage.jsp"%-->
<%@ include file="/jsp/include/ConnTestPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<!--%@ include file="/jsp/include/PageHeaderSwitch.jsp"%-->
<!--%@ page import="RepairPageHeaderBean" %-->
<jsp:useBean id="rPH" scope="application" class="RepairPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>(I6)Invoice Create for Hongkong</title>
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
function check(field) 
{
 if (checkflag == "false") {
 for (i = 0; i < field.length; i++) {
 field[i].checked = true;}
 checkflag = "true";
 return "Cancel Selected"; }
 else {
 for (i = 0; i < field.length; i++) {
 field[i].checked = false; }
 checkflag = "false";
 return "Select All"; }
}
function setSubmit(URL)
{   
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
}

function setSubmit2(URL)
{    
  flag=confirm("Confirm post Choice line to BPCS ? ");  
  if (flag) 
  {   
    document.MYFORM.action=URL;
    document.MYFORM.submit(); 
  }
  else
  { 
    return(false);
  } 
}

function rpIssueItemReport(pp)
{    
  subWin=window.open("RPIssueAppReportPrint.jsp?RPTXCOM="+pp);  
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">TSC(TW)</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Invoice Summary Program(HK)</strong></font>
<FORM ACTION="../jsp/RPItemConsumeBatchPost2BPCS.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 200;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
 %>
<A HREF="http://intranet.ts.com.tw">回首頁</A> 
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     
     String [] addItems=request.getParameterValues("ADDITEMS");
     //String regionNo=request.getParameter("REGION");
     String centerNo=request.getParameter("CENTERNO");
     String personNo=request.getParameter("PERSONNO");
     String reasonCode=request.getParameter("REASONCODE");

     String tCom=request.getParameter("TCOM");
     String repNo=request.getParameter("REPNO");

     String postChk = request.getParameter("POSTCHK");
     //String model = request.getParameter("MODEL");
     //String sModel = request.getParameter("SMODEL");       
     //String custOrder = request.getParameter("CORDER");
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
     String DayFr=request.getParameter("DAYFR");
     String dateStringBegin=YearFr+MonthFr+DayFr;
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");
     String DayTo=request.getParameter("DAYTO");
     String dateStringEnd=YearTo+MonthTo+DayTo;
     //String UserID=""; 
     String webID=""; 
     String getRSTRUE = "0";
     String sqlGlobal = "";

     if (postChk==null) { postChk = "1"; }
     if (tCom==null) { tCom= ""; }
     if (repNo==null) { repNo= ""; }
     if (DayFr==null) { dateStringBegin = dateBean.getYearMonthDay(); }  

     
  %>
<table width="100%" border="0">
  <tr bgcolor="#339999">    
    <td width="33%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>Invoice_No.</strong></font>
        <input name="INVOICENO" type="text" value="<%=invoiceNo%>" size="20" maxlength="15">
    </td>
    <td width="35%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>Shipping Method</strong></font>
	    <select size="1" name="SHIP_METHOD">
            <option value="SEA(C)">SEA(C)</option>
            <option value="AIR(C)">AIR(C)</option>
        </select>        
    </td>
    <td width="32%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>Origin of Country</strong></font>
       <select size="1" name="ORIGINAL">
          <option value="TW(736)">TW(736)</option>
          <option value="CN(720)">CN(720)</option>
       </select>
    </td>
  </tr>
  <tr bgcolor="#339999">
    <td width="33%" bordercolor="#FFFFFF" nowrap><font color="#FFFF00"><strong>Invoice Date</strong></font>
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
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
    </td>    
    <td width="32%" bordercolor="#FFFFFF" nowrap colspan="2">
    <font color="#FFFF00"><strong><input name="submit1" type="submit" value='Reset' onClick='return setSubmit("../jsp/RPItemConsumePost2BPCS.jsp")'> 
    </strong></font> 
	</td>
  </tr>  
</table>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#FFFFCC">
          <td width="6%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>&nbsp;</strong></font></td>     
          <td width="7%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>&nbsp;</strong></font></td>        
		  <td width="19%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>Name</strong></font></td>                        
          <td width="34%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>Customer Name</strong></font></td>          
		  <td width="34%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>Invoice Date</strong></font></td>	      
        </tr> 
          <%  
            try
            {                  

              Statement statementTC=conTst.createStatement();      // Link To Oracle DB
             

            //  String sqlTC =  "select DISTINCT b.TCOM, b.TXLOCALE, b.TXTYPE, b.TXDATE, abs(b.TXQTY) as TXQTY, b.TXRPCENTERNO, b.TXUSER, b.TXWHSE, b.TXLOC, "+
              String sqlTC =  "select DISTINCT NAME, di.CUSTOMER_NAME, trunc(di.INITIAL_PICKUP_DATE) INITIAL_PICKUP_DATE,di.CURRENCY_CODE "+                              
			                  //  "b.TORDER, b.TTICKETNO, b.TXTIME, b.TXRESCODE, b.TXADNOTE, b.TXDATE||lpad(to_char(b.TXTIME),6,0) "+
			                  "from APPS.DAPHNE_INVOICE di  ";
			  String sWhereTC = "where NAME IS NOT NULL  ";     // ?????????
				
			  if (centerNo == null || centerNo.equals("--")) { sWhereTC = sWhereTC + "and b.TXRPCENTERNO = '--' "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and b.TXRPCENTERNO ='"+centerNo+"'  "; }
              if (personNo == null || personNo.equals("--")) { sWhereTC = sWhereTC + "and b.TXPERSONLOC != '0'  "; }
			  else { sWhereTC = sWhereTC + "and b.TXPERSONLOC ='"+personNo+"'  "; }              
              if (reasonCode == null || reasonCode.equals("--")) { sWhereTC = sWhereTC + "and 'S'||substr(b.TXRESCODE,1,3) != '0'  "; }
			  else { sWhereTC = sWhereTC + "and 'S'|| substr(b.TXRESCODE,1,3) ='"+reasonCode+"'  "; }      			             
              //if (tCom == null || tCom.equals("")) { sWhereTC = sWhereTC + "and b.TCOM != '0' and trim(b.TCOM) not in("+ithDesc+")   "; }
			  //else { sWhereTC = sWhereTC + "and b.TCOM ='"+tCom+"' and trim(b.TCOM) not in("+ithDesc+") "; }
              if (tCom == null || tCom.equals("")) { sWhereTC = sWhereTC + "and b.TCOM != '0' "; }
			  else { sWhereTC = sWhereTC + "and b.TCOM ='"+tCom+"' "; }
              if (repNo == null || repNo.equals("")) { sWhereTC = sWhereTC + "and b.TORDER != '0'  "; }
			  else { sWhereTC = sWhereTC + "and b.TORDER ='"+repNo+"'  "; }
 
			  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and to_char(b.TXDATE) >="+"'"+dateStringBegin+"' ";
              if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and to_char(b.TXDATE) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			  String sOrderTC = "group by b.TXLOCALE, b.TXTYPE, b.TXDATE, b.TXRPCENTERNO, b.TXUSER, b.TXWHSE, b.TXLOC, b.TXPERSONLOC||b.TXDATE,  b.TXREASON, b.TXADNOTE, b.TXRESCODE "+
                                "order by b.TXRPCENTERNO, b.TXDATE DESC ";
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // ¢FFD[?J?A-?-¢FFX???????o??A_
		 
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

          // ¢FFD[?J?A-? - !L!| /		
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
         
        %>
        <tr bgcolor="#FFFFFF">
          <td height="20" bgcolor="#003399"><font size="2" color="#FFFFFF"><div align="center"><strong>
          <% out.println(rs1__index+1);%>
          </strong></div></font></td>       
          <td height="20"><font size="2" color="#000000">
          <input type="checkbox" name="CHKFLAG" value="<%=rsTC.getString("TXPERSONLOC")%>"><input type="hidden" name="TTDATE" value="<%=rsTC.getString("TXDATE")%>">
          </font> </td>        
		  <td><font color="#FF0000" size="2">
                <%
                    if (rsTC.getInt(1)>0) { out.println(rsTC.getInt(1)); } 
                    else { out.println("&nbsp;"); } 
                %></font>
          </td>          	 
          <td><font size="2" color="#000000">
                  <%
                       if (rsTC.getString("TXTYPE")!=null) { out.println(rsTC.getString("TXTYPE")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXTYPE") 
                  %></font></td>            
		  <td><font size="2" color="#000000">
                 <%
                     if (rsTC.getString("TXDATE") !=null) { out.println(rsTC.getString("TXDATE") ); } 
                     else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXDATE") 
                 %></font></td>		
		 </tr>             
		<%
               rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
             }
	        //tmpSalesCde = rs.getString("SALESCODE");
            //  stateBPCS.close();     // ??BPCS??? //
              qryAllChkBoxEditBean.setPageURL("../jsp/RPItemRepPersonBatchPost2BPCS.jsp");
              qryAllChkBoxEditBean.setSearchKey("TXPERSONLOC");
              qryAllChkBoxEditBean.setFieldName("CHKFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
              //qryAllChkBoxEditBean.setScrollRowNumber(25); 
              //out.println(qryAllChkBoxEditBean.getRsString());     
	          rsTC.close();
	          statementTC.close();
          } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %> 
    <tr>
      <td colspan="13">總共<%out.println("<font color='#FF0000'><strong>"+Integer.toString(rs1__index)+"</strong></font>");%>準備產生發票</td>    
    </tr>     
  </table><BR>
<input name="SQLGLOBAL" type="hidden" value="<%=sqlGlobal%>"> <BR>
<div align="left"><input name="submit2" type="submit" value="Submit" onClick='return setSubmit2("../jsp/RPItemRepPersonBatchPost2BPCSCommit.jsp")'></div>
 <%  
   
 %>
</FORM>
<table width="100%" border="0">
  <tr align="center" bordercolor="#000000" > 
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveFirst%>">第一頁</A></strong></font></pre>
      </div></td>
    <td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_movePrev%>">前一頁</A></strong></font></pre>
      </div></td>
	<td width="24%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveNext%>">下一頁</A></strong></font></pre>
      </div></td>
    <td width="28%"> 
      <div align="center">
        <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveLast%>">最後頁</A></strong></font></pre>
      </div></td>
  </tr>  
</table>
</body>
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSTelPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>