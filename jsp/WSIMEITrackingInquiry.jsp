<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,RsBean" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
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
<title>Customer Activity IMEI Tracking Inquiry</title>
</head>
<body>
<FORM ACTION="../jsp/WSIMEITrackingInquiry.jsp" METHOD="post" NAME="MYFORM">
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
  
  String CenterNo=request.getParameter("CENTERNO"); 
  String agentName =request.getParameter("AGENTNAME"); 
  String imei =request.getParameter("IMEI"); 
  String unitNo =request.getParameter("UNITNO");  

  if ( imei ==null || imei.equals("") ) { imei = ""; }
  if ( unitNo ==null || unitNo.equals("") ) { unitNo = ""; }
  
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
  
    String sql = "select ACTCENTERNO, ACTLOCALE from WSSHIPPER where USERNAME='"+UserName+"' ";	
	Statement stateShip=con.createStatement();
	ResultSet rsShip=stateShip.executeQuery(sql);
	if (rsShip.next())
	{ 
	   CenterNo = rsShip.getString("ACTCENTERNO"); 
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
  <table width="100%" border="0">
    <tr bgcolor="#D0FFFF"> 
      <td width="27%" height="23" bordercolor="#FFFFFF"> <p><font color="#CC3366" face="Arial Black"><strong>CENTER NO</strong></font> 
          <font color="#CC3366"> 
          <% 
		    try
           {   
		     String sSql = "";
   		     String sWhere = "";		  
		   
		     sSql = "select CENTERNO as x, CENTERNO||'('||ALNAME||')'  from wsshp_center where centerno = '"+CenterNo+"' ";		  
		     sWhere = " order by x";
		     sSql = sSql+sWhere; 
		  		      
            //Statement statement=ifxtelcon.createStatement();
		     Statement statement=con.createStatement();
             ResultSet rs=statement.executeQuery(sSql);
		  
		     out.println("<select NAME='CENTERNO' onChange='setSubmit("+'"'+"../jsp/WSIMEITrackingInquiry.jsp"+'"'+")'>");
             out.println("<OPTION VALUE=-->--");     
             while (rs.next())
             {            
              String s1=(String)rs.getString(1); 
              String s2=(String)rs.getString(2); 
                        
              if (s1.equals(CenterNo)) 
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
      <td width="40%"><font color="#CC3366" face="Arial Black"><strong>AGENT NAME</strong></font> 
        <font color="#CC3366"> 
        <% 
		 String AGENTNAME="";		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		 
		  sSql = "select AGENTNAME,AGENTNAME from WSCUST_AGENT a,  WSSHP_CENTER b ";		
		  sWhere = "where substr(a.AGENTNO,1,3)=TRIM(b.CENTERNO) and substr(a.AGENTNO,1,3) = '"+CenterNo+"' and AGENTNAME IS NOT NULL";		
		  //sWhere = "where substr(a.AGENTNO,1,3)='003' and substr(a.AGENTNO,1,3) = '"+CenterNo+"' ";		 
		  //sSql = "select substr(CONTINENT,2,1) as REGION, CONTINENT|| '('||CONTINENT_NAME||')' from WSADMIN.WSCONTINENT ";
		  //sWhere = "where CONTINENT IS NOT NULL ";
		  sSql = sSql+sWhere;		  
		  //out.println(sSql);		        
          Statement statement=con.createStatement();		  
          ResultSet rs=statement.executeQuery(sSql);		
          
          out.println("<select NAME='AGENTNAME' onChange='setSubmit("+'"'+"../jsp/WSIMEITrackingInquiry.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
              String s1=(String)rs.getString(1); 
              String s2=(String)rs.getString(2); 
                        
              if (s1.equals(agentName)) 
              {
                out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
              }   
			  else 
			  {
                out.println("<OPTION VALUE='"+s1+"'>"+s2);
              }        
        } //end of while
        out.println("</select>"); 	
       
      //    comboBoxAllBean.setRs(rs);			    
		//  comboBoxAllBean.setSelection(agentName);		    
		//  comboBoxAllBean.setFieldName("AGENTNAME");		  
       //   out.println(comboBoxAllBean.getRsString());		  
		//  if (rs.next())
		//  {		   
			//agentName= rs.getString("AGENTNAME");		    
		//  }
          rs.close();    
		  statement.close();  		
		  //out.println("agentName"+agentName);		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
        </font>
	  </td>
       <td width="33%">
         <font color="#CC3366" face="Arial Black"><strong>UNIT NO.</strong></font> 
         <input name="UNITNO" type="text"  size="25" maxlength="10" value="<%=unitNo%>">
       </td>
    </tr>
  </table>    
<table width="100%">
     <tr bgcolor="#D0FFFF"> 	
      <td width="67%" valign="top" bordercolor="#CCCCCC" bgcolor="#CCEEFF"> 
	  <font color="#CC3366" face="Arial Black"><strong>DATE FR.</strong></font>
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
         <font color="#CC3366" face="Arial Black"><strong> ~<font color="#CC3366" face="Arial Black"><strong>DATE TO</strong></font></strong></font>  
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
	   <td width="23%" bgcolor="#D0FFFF">
	      <font color="#CC3366" face="Arial Black"><strong>IMEI</strong></font></strong></font>  
		  <input name="IMEI" type="text" size="15" maxlength="15" value="<%=imei%>">
	   </td>     	     
	   <td width="10%" bgcolor="#D0FFFF">
	      <input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSIMEITrackingInquiry.jsp")'>
	   </td>
	</tr>
  </table>
  <BR>
	  <%
	     //out.println("agentName="+agentName);
		 if ( agentName!=null && !agentName.equals("--")  )
	     //if ( agentName!=null || !agentName.equals("") )
		 {
		    try
            {               
              Statement statementH=con.createStatement();  
  
              String sqlH =  "select  to_number(substr(a.AGENTNO,5,3)) as IN_QTY, a.AGENTNAME, a.AGENTTEL, a.AGENTFAX, a.AGENTADDR, "+
			                                     "a.AGENT_UNITNO, a.CONTACTMAN "+
			                          "from WSCUST_AGENT a, IMEI_TRACKING b ";
			  String sWhereH = "where a.AGENTNAME=b.CUST_NAME and a.AGENTNAME !='0'  ";				                    
			   if (agentName == null || agentName.equals("--")) { sWhereH = sWhereH + "and a.AGENTNAME != '0'  "; }
			   else { sWhereH = sWhereH + "and a.AGENTNAME ='"+agentName+"'  "; }
			   if (imei == null || imei.equals("")) { sWhereH = sWhereH + "  "; }
			   else { sWhereH = sWhereH + "and b.IMEI = '"+imei+"' "; }
               if (unitNo == null || unitNo.equals("")) { sWhereH = sWhereH + "  "; }
			   else { sWhereH = sWhereH + "and b.UNIT_NO = '"+unitNo+"' "; }
			   sqlH = sqlH + sWhereH ;
			            
              ResultSet rsH=statementH.executeQuery(sqlH);
			  if (rsH.next())
			  {
	            out.println("<table width='100%'><tr><td width='30%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>AGENT<input name='AGENTNAME' type='text' value="+rsH.getString("AGENTNAME")+" size='25' maxlength='50'></font></td>");
		        out.println(" <td width='20%' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>TEL<input name='TEL' type='text' value="+rsH.getString("AGENTTEL")+" size='15' maxlength='20'  readonly=''></font></td>");
		        out.println(" <td width='20%' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>FAX<input name='FAX' type='text' value="+rsH.getString("AGENTFAX")+" size='15' maxlength='20' readonly=''></font></td>");
		        out.println("<td width='15%' bgcolor='#CC3333' nowrap><font color='#FFFFFF' face='Arial Black'>UNIT NO.<input name='UNITNO' type='text' value="+rsH.getString("AGENT_UNITNO")+" size='10' maxlength='10' readonly=''></font></td>");
		        out.println("<td width='5%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>CONTACT<input name='CONTACT' type='text' value="+rsH.getString("CONTACTMAN")+" size='15' maxlength='20' readonly=''></td></font></tr>");
		        out.println("<tr><td colspan='4' bgcolor='#CC3333'  ><font color='#FFFFFF' face='Arial Black'>AGENT ADDRESS<input name='AGADDRESS' type='text' value="+rsH.getString("AGENTADDR")+" size='70' maxlength='80' readonly=''></font></td>");
		        out.println("<td width='5%' bgcolor='#CC3333' ><font color='#FFFFFF' face='Arial Black'>INPUT QTY.<input name='INPUTQTY' type='text' value="+rsH.getString("IN_QTY")+" size='10' maxlength='10' readonly=''></font></td> </tr></table> ");
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
		  <td width="4%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>LINK</strong></font></td>
          <td width="14%"  height="19" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>IMEI </strong></font></td>
          <td width="7%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>ITEM NO.</strong></font></td>
		  <td width="11%" bgcolor="#000099"  nowrap><font color="#FFFFFF" size="2"><strong>PROJECT CODE</strong></font></td>
		  <td width="9%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>SALES CODE</strong></font></td>
		  <td width="14%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>PACKING TIME</strong></font></td>
		  <td width="18%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>CARTON NO.</strong></font></td>		  
		  <td width="8%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>IN USER</strong></font></td>
		  <td width="15%" bgcolor="#000099" nowrap><font color="#FFFFFF" size="2"><strong>IN DATETIME</strong></font></td>
        </tr>
		 <%  
             try
            {               
              Statement statementTC=con.createStatement();  
              String sqlTC = "";
              String sWhereTC="";
              int imeiLength =  imei.length();
              if ( imeiLength==15 && (agentName==null || agentName.equals("--")) )
             {
               sqlTC =  "select b.IMEI, c.MODEL_NAME, c.IN_STATION_TIME, c.MCARTON_NO, b.CUST_NO, b.CUST_NAME, " +
                             "b.CONTACT_TEL, b.CONTACT_FAX, b.CUST_ADDRESS, b.UNIT_NO, b.CONTACT_NAME, b.IN_USER, to_date(b.IN_DATETIME,'YYYY/MM/DD hh24miss') as IN_DATETIME "+     
                             "from IMEI_TRACKING b, MES_WIP_TRACKING c  ";                             
               sWhereTC = "where  b.IMEI = c.IMEI ";
             }
             else
            {   
               sqlTC =  "select b.IMEI, c.MODEL_NAME, c.IN_STATION_TIME, c.MCARTON_NO, b.CUST_NO, b.CUST_NAME, b.CONTACT_TEL, b.CONTACT_FAX, b.CUST_ADDRESS, "+
			                                     "b.UNIT_NO, b.CONTACT_NAME, b.IN_USER, to_date(b.IN_DATETIME,'YYYY/MM/DD hh24miss') as IN_DATETIME "+
			                          "from WSCUST_AGENT a, IMEI_TRACKING b, MES_WIP_TRACKING c ";
               sWhereTC = "where a.AGENTNAME=b.CUST_NAME and b.IMEI = c.IMEI  ";
               if (agentName == null || agentName.equals("--")) { sWhereTC = sWhereTC + "  "; }
			   else { sWhereTC = sWhereTC + "and a.AGENTNAME ='"+agentName+"'  "; }
            }     			  
			  // "and SVRTYPENO in('001') ";
              //String sOrder = "group by c.JAMDESC, c.JAMCODE order by COUNT desc ";
			  //if (agentName==null || agentName.equals("")) {  }
			  
			   if (imei == null || imei.equals("")) { sWhereTC = sWhereTC + "  "; }
			   else { sWhereTC = sWhereTC + "and b.IMEI = '"+imei+"' "; }			
               if (unitNo == null || unitNo.equals("")) { sWhereTC = sWhereTC + "  "; }
			   else { sWhereTC = sWhereTC + "and b.UNIT_NO = '"+unitNo+"' "; }			 
			   if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and substr(to_char(IN_DATETIME),1,8) >="+"'"+dateStringBegin+"' ";
               if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and substr(to_char(IN_DATETIME),1,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			  String sOrderTC = "order by b.CUST_NAME, b.IN_DATETIME ";
   
              //sql = sql + sWhere + sWhereRep + sOrder;  // 不加sWhereRep 因依使用者點選維修區傳入 //
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  //String sqlCNT = "select count(DISTINCT a.ITEMNO) from RPREPAIR a, RPMODEL_ITEM_T b  "; 
			  //out.println(sqlTC);  
			  			  
              //sqlCNT = sqlCNT + sWhere;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // 加入分頁-起
		 
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

      // if we walked off the end of the recordset, set MM?佃?????o???_rsCount and MM_size
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
         // *** Go To Record and Move To Record: create strings for maintaining URL and Form parameters

       String MM_keepBoth,MM_keepURL="",MM_keepForm="",MM_keepNone="";
       String[] MM_removeList = { "index", MM_paramName };
       // out.println("MM_size Step1="+MM_size); /////
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
          // out.println("MM_size Step2="+MM_size);
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
			  
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
				
         
        %>
        <tr bgcolor="#FFFFCC">
		  <td <% if (rsTC.getString("CUST_NAME")==null || rsTC.getString("CUST_NAME").equals("") ) { out.println("bgcolor='#FF0000' "); } %>><a href="../jsp/WSIMEITrackingDetailPage.jsp?IMEI=<%=rsTC.getString("IMEI")%>&AGENTNAME=<%=agentName%>"><div align="center"><img src="../image/docicon.gif" width="14" height="15" border="0"></div></a></td>
          <td height="20"><font size="2" color="#000099"><%=rsTC.getString("IMEI") %></font></td>		 
          <td><font size="2" color="#CC3366"><%=rsTC.getString("MODEL_NAME") %></font></td>
		  <td>
		         <font size="2" color="#000099">
		           <%
				       try
                      { 
				        String salesCode = "";
				        Statement statementP=con.createStatement();  
				        String sqlP = "select MPROJ, SALESCODE from PRODMODEL, PIMASTER ";
						String sWhereP = "where MPROJ=PROJECTCODE and MITEM='"+rsTC.getString("MODEL_NAME")+"' ";
						sqlP = sqlP + sWhereP;
						ResultSet rsP=statementP.executeQuery(sqlP);
						 if (rsP.next()) 
						 { out.println(rsP.getString("MPROJ")); 
						    salesCode = rsP.getString("SALESCODE");}
						 else { out.println("&nbsp;"); }
				      //=rsTC.getString("MPROJ") 
				   %>
				 </font>
		  </td>		 
          <td>
		         <font size="2" color="#CC3366">
				   <%
				      if(salesCode==null || salesCode.equals("")) { out.println("&nbsp;"); }
					  else { out.println(salesCode); }
					   rsP.close();
					   statementP.close();
					 } //end of try
                     catch (Exception e)
                    {
                      out.println("Exception:"+e.getMessage());
                    }   				  
				   %>
				 </font>
		  </td>
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("IN_STATION_TIME") %></font></td>
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("MCARTON_NO") %></font></td>		  
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("IN_USER") %></font></td>
		  <td><font size="2" color="#CC3366"><%=rsTC.getString("IN_DATETIME") %></font></td>
        </tr>
		<%
               rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
             }
	        //tmpSalesCde = rs.getString("SALESCODE");
	          rsTC.close();
	          statementTC.close();
          } //end of try
          catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %> 
     <tr bgcolor="#000099">
        <td colspan="9"> <font color="#FFFFFF"><strong>QUERY COUNT Q'TY:</strong></font> :<font color="#FF0000"><strong>
       <% 
                 Statement stateCNT=con.createStatement();  
  
                String sqlCNT =  "select count(b.IMEI) "+
			                          "from WSCUST_AGENT a, IMEI_TRACKING b, MES_WIP_TRACKING c ";
			    String sWhereCNT = "where a.AGENTNAME=b.CUST_NAME and b.IMEI = c.IMEI and a.AGENTNAME !='0'  ";
				                    
              
			    if (agentName == null || agentName.equals("--")) { sWhereCNT = sWhereCNT + "and a.AGENTNAME != '0'  "; }
			    else { sWhereCNT = sWhereCNT + "and a.AGENTNAME ='"+agentName+"'  "; }
			    if (imei == null || imei.equals("")) { sWhereCNT = sWhereCNT + "  "; }
			    else { sWhereCNT = sWhereCNT + "and b.IMEI = '"+imei+"' "; }			
                 if (unitNo == null || unitNo.equals("")) { sWhereCNT = sWhereCNT + "   "; }
			    else { sWhereCNT = sWhereCNT + "and b.UNIT_NO = '"+unitNo+"' "; }			 
			    if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereCNT=sWhereCNT+" and substr(to_char(IN_DATETIME),1,8) >="+"'"+dateStringBegin+"' ";
                if (DayFr!="--" && DayTo!="--") sWhereCNT=sWhereCNT+" and substr(to_char(IN_DATETIME),1,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
			  
			    sqlCNT = sqlCNT + sWhereCNT ;
			  
			    //out.println(sqlCNT);
                ResultSet rsCNT=stateCNT.executeQuery(sqlCNT);
                if (rsCNT.next()) { out.println(rsCNT.getString(1)) ; }
                rsCNT.close();
                stateCNT.close();
           %>  
           </strong></font>
       </td>
     </tr>     
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
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
