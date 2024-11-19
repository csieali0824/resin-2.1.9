<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,RsBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============??????????==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp/"%>
<%@ include file="/jsp/include/ConnectionPOSPoolPage.jsp/"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="rsBean" scope="session" class="RsBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>POS System Sales Daily Audit Inquiry</title>
</head>
<body>
<div align="center"><img src="../image/Dbtel%20picture.gif"></div>
<FORM ACTION="../jsp/WSPOSSalesInquiry.jsp" METHOD="post" NAME="MYFORM">  
 <%
   int rs1__numRows = 25;
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
  //String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE"); 
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");
  String dateStringBegin=YearFr+MonthFr+DayFr;
  String YearTo=request.getParameter("YEARTO");
  String MonthTo=request.getParameter("MONTHTO");
  String DayTo=request.getParameter("DAYTO");
  String dateStringEnd=YearTo+MonthTo+DayTo; 
  
  //String model=request.getParameter("MODEL"); 
  //String color=request.getParameter("COLOR"); 
  
  String StoreNo="";
  String storeNo =request.getParameter("STORE_NO"); 
  //String imei =request.getParameter("IMEI"); 
 
 //if ( storeNo == null )  { storeNo = "001"; }
 
  int numRow = 0;
  
   
    String sql = "select ACTCENTERNO, ACTLOCALE from WSSHIPPER where USERNAME='"+UserName+"' ";	
	Statement stateShip=con.createStatement();
	ResultSet rsShip=stateShip.executeQuery(sql);
	if (rsShip.next())
	{ 
	   StoreNo = rsShip.getString("ACTCENTERNO"); 
	   locale = rsShip.getString("ACTLOCALE"); 
	}
	else
	{
	   out.println("You have no authority !!");
	   out.println(UserName);
	}
	rsShip.close();
	stateShip.close();
  
%>  
    <font size="+2" face="Times New Roman, Times, serif"><strong>POS Daily Sales Information </strong></font> 
    <table width="100%" border="0">
    <tr bgcolor="#D0FFFF"> 
      <td width="44%" height="23" bordercolor="#FFFFFF"> <p><font color="#CC3366" face="Arial Black"><strong>STORE 
          NO</strong></font> <font color="#CC3366"> 
          <% 
		    try
           {   
		     String sSql = "";
   		     String sWhere = "";		  
		     String sOrder = "";

		     //sSql = "select STORE_NO as x, STORE_NO||'('||STOR_GNAME||')'  from POS_HSTORE where MOD_ID = 'Y' ";		// Link WINSDB
             sSql = "select STORE_NO , STORE_NO+'('+STOR_GNAME+')'  from HSTORE ";		     // LINK to POS SQL DB
		     sWhere = "where MOD_ID != 'Y' ";
             if (storeNo == null || storeNo.equals("--")) { sWhere = sWhere + ""; }
             else { sWhere = sWhere + "and STORE_NO='"+storeNo+"' "; } 
             sOrder = "order by STORE_NO ";
		     sSql = sSql+sWhere+sOrder; 	 		      
             //out.println(sSql);
		     //Statement statement=con.createStatement();   // // Link WINSDB
             Statement statement=mssqlcon.createStatement(); // LINK to POS SQL DB

             ResultSet rs=statement.executeQuery(sSql);
		  
		     out.println("<select NAME='STORE_NO' onChange='setSubmit("+'"'+"../jsp/WSPOSSalesInquiry.jsp"+'"'+")'>");
             out.println("<OPTION VALUE=-->--");     
             while (rs.next())
             {            
              String s1=(String)rs.getString(1); 
              String s2=(String)rs.getString(2); 
                        
              if (s1.equals(storeNo)) 
              {
                out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
              }   
			  else 
			  {
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
          </font></td>
      <td width="56%"><font color="#CC3366" face="Arial Black"><strong></strong></font> 
        <font color="#CC3366">         
        </font>
	  </td>
    </tr>
  </table>    
<table width="100%">
     <tr bgcolor="#D0FFFF"> 	
      <td width="70%" valign="top" bordercolor="#CCCCCC" bgcolor="#CCEEFF"> <font color="#CC3366" face="Arial Black"><strong>SALE 
        DATE FR.</strong></font> 
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
        <font color="#CC3366" face="Arial Black"><strong> ~<font color="#CC3366" face="Arial Black"><strong>SALE 
        DATE TO</strong></font></strong></font> 
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
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> 
	   </td>	        	     
	   <td width="20%" bgcolor="#D0FFFF">
	      <input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSPOSSalesInquiry.jsp")'>
	   </td>
	</tr>
  </table>
  <BR>
	  <%
	     //out.println("agentName="+agentName);
		 if ( storeNo!=null && !storeNo.equals("--"))
	     //if ( agentName!=null || !agentName.equals("") )
		 {
		    try
            {               
              //Statement statementH=con.createStatement();    // LINK to WINSDB
              Statement statementH=mssqlcon.createStatement();        // Link to POS SQL DB
             							  
			  //String sqlH =  "select  STORE_NO, STOR_NAME, STOR_GNAME, TEL, FAX, ADDRESS_1, "+
			  //                                   "UNIFORM_NO, STOR_EMP_CODE "+
			  //                        "from POS_HSTORE ";                                              // LINK to WINSDB
               String sqlH =  "select  STORE_NO, STOR_NAME, STOR_GNAME, TEL, FAX, ADDRESS_1, "+
			                                     "UNIFORM_NO, STOR_EMP_CODE "+
			                          "from HSTORE ";                                      // Link to POS SQL DB
			  String sWhereH = "where MOD_ID !='Y'  ";				                    
			   if (storeNo == null || storeNo.equals("--")) { sWhereH = sWhereH + "and STORE_NO != '0'  "; }
			   else { sWhereH = sWhereH + "and STORE_NO ='"+storeNo+"'  "; }			  
			   sqlH = sqlH + sWhereH ;
			  		             
              ResultSet rsH=statementH.executeQuery(sqlH);
			  if (rsH.next())
			  {
	            out.println("<table width='100%'><tr><td width='30%' bgcolor='#000099' ><font color='#FFFFFF' face='Arial Black'>STORE NO<input name='STORENO' type='text' value="+rsH.getString("STORE_NO")+" size='25' maxlength='50'></font></td>");
				out.println("<td width='30%' bgcolor='#000099' colspan='2'><font color='#FFFFFF' face='Arial Black'>STORE NAME<input name='STORNAME' type='text' value="+rsH.getString("STOR_NAME")+" size='25' maxlength='50'></font></td>");
				out.println("<td width='30%' bgcolor='#000099' ><font color='#FFFFFF' face='Arial Black'>GNAME<input name='STORGNAME' type='text' value="+rsH.getString("STOR_GNAME")+" size='25' maxlength='50'></font></td></tr>");
		        out.println("<tr><td width='20%' bgcolor='#000099'  ><font color='#FFFFFF' face='Arial Black'>TEL<input name='TEL' type='text' value="+rsH.getString("TEL")+" size='15' maxlength='20'  readonly=''></font></td>");
		        out.println("<td width='20%' bgcolor='#000099'  ><font color='#FFFFFF' face='Arial Black'>FAX<input name='FAX' type='text' value="+rsH.getString("FAX")+" size='15' maxlength='20' readonly=''></font></td>");
		        out.println("<td width='15%' bgcolor='#000099' nowrap><font color='#FFFFFF' face='Arial Black'>UNIT NO.<input name='UNITNO' type='text' value="+rsH.getString("UNIFORM_NO")+" size='10' maxlength='10' readonly=''></font></td>");
		        out.println("<td width='5%' bgcolor='#000099' ><font color='#FFFFFF' face='Arial Black'>CONTACT<input name='CONTACT' type='text' value="+rsH.getString("STOR_EMP_CODE")+" size='15' maxlength='20' readonly=''></td></font></tr>");
		        out.println("<tr><td colspan='4' bgcolor='#000099'  ><font color='#FFFFFF' face='Arial Black'>AGENT ADDRESS<input name='ADDRESS1' type='text' value="+rsH.getString("ADDRESS_1")+" size='70' maxlength='80' readonly=''></font></td></tr></table>");		        
			  }
			  rsH.close();
			  statementH.close();
		  } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   				
	    } // end of if
      %>	   
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#FFFFCC">          
		  <td width="3%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>LINK</strong></font></td>
          <td width="8%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>SALE DATE </strong></font></td>
          <td width="6%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>ITEM NO.</strong></font></td>
		  <td width="10%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>BPCS ITEM NO</strong></font></td>		  
		  <td width="5%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>QTY</strong></font></td>
          <td width="8%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>PRICE</strong></font></td>
		  <td width="10%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>AMOUNT</strong></font></td>		  
		  <td width="7%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>COST</strong></font></td>
		  <td width="8%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>DISCOUNT</strong></font></td>
          <td width="8%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>BPCS LIST PRICE</strong></font></td>
          <td width="9%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>REF. BPCS CO</strong></font></td>
          <td width="8%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>BPCS LINE</strong></font></td>
          <td width="12%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>BPCS PRICE</strong></font></td>
        </tr>
		 <%  
             try
            {               
               
            
               //Statement statementTC=con.createStatement();     // Link To WINSDB
               Statement statementTC=mssqlcon.createStatement();      // Link To POS SQL DB
              
			  //String sqlTC =  "select  b.SAL_DATE, b.ITEM_CODE, b.BPCS_ITEMNO, b.DEPT_NO, b.SAL_QTY, b.SAL_AMT, b.SAL_COST, b.SAL_DISC_AMT, "+
			  //                         "a.STORE_NO, STOR_NAME, STOR_GNAME, TEL, FAX, ADDRESS_1, UNIFORM_NO, STOR_EMP_CODE "+
			  //                         "from POS_HSTORE a, POS_HPROD_SAL b ";

              String sqlTC =  "select  b.SAL_DATE, b.ITEM_CODE, c.BARCODE1, b.DEPT_NO, b.SAL_QTY, b.SAL_AMT, b.SAL_COST, b.SAL_DISC_AMT, "+
			                           "a.STORE_NO, STOR_NAME, STOR_GNAME, TEL, FAX, ADDRESS_1, UNIFORM_NO, STOR_EMP_CODE "+
			                           "from HSTORE a, HPROD_SAL b, HBARCODE c ";
			  String sWhereTC = "where a.STORE_NO=b.STORE_NO and b.ITEM_CODE=c.ITEM_CODE and a.MOD_ID !='Y'  ";
				
			   if (storeNo == null || storeNo.equals("--")) { sWhereTC = sWhereTC + "and a.STORE_NO != '0'  "; }
			   else { sWhereTC = sWhereTC + "and a.STORE_NO ='"+storeNo+"'  "; }			   			 
			   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and b.SAL_DATE >="+"'"+dateStringBegin+"' ";
               if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and b.SAL_DATE between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			  String sOrderTC = "order by a.STORE_NO, b.SAL_DATE ";
   
              //sql = sql + sWhere + sWhereRep + sOrder;  // ?£¥[sWhereRep |]‥I‥I¥IaIAI?iou-×°I?C?J //
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  //String sqlCNT = "select count(DISTINCT a.ITEMNO) from RPREPAIR a, RPMODEL_ITEM_T b  "; 
			  //out.println(sql);  
			  			  
              //sqlCNT = sqlCNT + sWhere;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // ¥[?J?A-?-°???????o??A_
		 
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

          // ¥[?J?A-? - ‥’ /		
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
         
        %>
        <tr bgcolor="#FFFFCC">
		  <td><a href="../jsp/WSPOSSalesCODetailPage.jsp?BPCSITEMNO=<%=rsTC.getString("BARCODE1")%>&SALQTY=<%=rsTC.getString("SAL_QTY")%>&SALDATE=<%=rsTC.getString("SAL_DATE")%>"><div align="center"><img src="../image/docicon.gif" width="14" height="15" border="0"></div></a></td>
          <td height="20"><font size="2" color="#000099"><%=rsTC.getString("SAL_DATE") %></font></td>		 
          <td><font size="2" color="#CC3366"><%=rsTC.getString("ITEM_CODE") %></font></td>
		  <td><font size="2" color="#000099"><%= rsTC.getString("BARCODE1")%></font></td>		           
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("SAL_QTY") %></font></td>
          <td><font size="2" color="#CC3366"><%=(rsTC.getInt("SAL_AMT")/rsTC.getInt("SAL_QTY")) %></font></td>
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("SAL_AMT") %></font></td>		  
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("SAL_COST") %></font></td>
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("SAL_DISC_AMT") %></font></td>
          <td><font size="2" color="#000099">
                <%
                   Statement stateBPCS=ifxdistcon.createStatement();  // ??BPCS??? //
                    try
                   {
                     String sqlBPCSItem =    "select ILIST from IIM where IPROD ='"+rsTC.getString("BARCODE1")+"' ";
                     ResultSet rsBPCSItem=stateBPCS.executeQuery(sqlBPCSItem); 
                      if (rsBPCSItem.next())
                      { out.println(rsBPCSItem.getString("ILIST")); }
                      else
                     { out.println("&nbsp;");  }
                     rsBPCSItem.close();                    
                   } //end of try
                   catch (Exception e)
                  {
                    out.println("Exception:"+e.getMessage());
                  }   
                %>
                 </font>
          </td>
          <td><font size="2" color="#000099">
             <%
               String lineGet = "0";
               try
               {
                 String sqlBPCSCO = "select DISTINCT LORD, LLINE, LNET, CLENUS, HEDTE||CHENTM  as ENTRDT from ECL, ECH, ITH  ";
                 String sWhereBPCS = "where HID='CZ' and LID='ZL' and HORD=LORD and LORD=TREF and LWHS=TWHS and TTYPE='B' and LWHS='90' and TLOCT='N001' "+
                                                    "and LPROD='"+rsTC.getString("BARCODE1")+"' and  LQORD='"+rsTC.getString("SAL_QTY")+"' "+
                                                    "and ( LRDTE='"+rsTC.getString("SAL_DATE")+"' ) and TTDTE= '"+rsTC.getString("SAL_DATE")+"' ";
                 if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereBPCS=sWhereBPCS+" and LRDTE >="+"'"+dateStringBegin+"' ";
                 if (DayFr!="--" && DayTo!="--") sWhereBPCS=sWhereBPCS+" and LRDTE between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
                  
                 String sOrderBPCSCO = "order by ENTRDT desc ";

                 sqlBPCSCO = sqlBPCSCO + sWhereBPCS + sOrderBPCSCO;
                 //out.println(sqlBPCSCO);
                 ResultSet rsBPCSCO=stateBPCS.executeQuery(sqlBPCSCO);
                 if (rsBPCSCO.next())
                 {  
                    out.println(rsBPCSCO.getString("LORD")); 
                    lineGet = "1";
                 }
                  else {  out.println("&nbsp;");  }
          //       rsBPCSCO.close();
          //       stateBPCS.close();  // ??BPCS??? //
         //     } //end of try
         //     catch (Exception e)
         //    {
         //      out.println("Exception:"+e.getMessage());
         //    }   
          %></font></td>
         <td><font size="2" color="#000099">
                <%
                     if (lineGet=="1")
                    {
                      out.println(rsBPCSCO.getString("LLINE"));  
                    }
                    else {  out.println("&nbsp;"); }  
                %>
               </font>
         </td>
         <td><font size="2" color="#000099">
                <%
                     if (lineGet=="1")
                    {
                      out.println(rsBPCSCO.getString("LNET"));  
                    }
                    else {  out.println("&nbsp;"); }  
                    
                     rsBPCSCO.close();
                     stateBPCS.close();  // ??BPCS??? //
                   } //end of try
                   catch (Exception e)
                  {
                    out.println("Exception:"+e.getMessage());
                  }   
                %>
                </font>
         </td>
          
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
<!--=============??????????==========-->
<%@ include file="/jsp/include/ReleaseConnPOSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<!--=================================-->
</html>