<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>Shipping IPO Invoice System-Invoice Information Inquiry</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<style type="text/css">
<!--
.style1 {
	color: #CC0000;
	font-weight: bold;
}
-->
</style>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial black"><em>DBTEL</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>Shipping IPO Invoice System Inquiry</strong></font>
<FORM ACTION="../jsp/SHIPOInvoiceInquiry.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 200;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   //boolean getDataFlag = false;
 %>
<A HREF="../WinsMainMenu.jsp">HOME</A>
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     //String regionNo=request.getParameter("REGION");
     String vndInvNo=request.getParameter("VNDINVNO");
     String invoiceNo=request.getParameter("INVOICENO");
     String vendor=request.getParameter("VENDOR");
     String shipWay=request.getParameter("SHIPWAY");
     String poNo=request.getParameter("PONO");
     String paymentTerm=request.getParameter("PAYMENTTERM");

     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
     String DayFr=request.getParameter("DAYFR");
     if ( YearFr==null ) { YearFr=dateBean.getYearString(); }
     if ( MonthFr==null ) { MonthFr=dateBean.getMonthString(); }
     if ( DayFr==null ) { DayFr=dateBean.getDayString(); }
     String dateStringBegin=YearFr+MonthFr+DayFr;
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");
     String DayTo=request.getParameter("DAYTO");
     if ( YearTo==null ) { YearTo=dateBean.getYearString(); }
     if ( MonthTo==null ) { MonthTo=dateBean.getMonthString(); }
     if ( DayTo==null ) { DayTo=dateBean.getDayString(); }
     String dateStringEnd=YearTo+MonthTo+DayTo; 
     
     //String UserID=""; 
     String webID=""; 
     //String getRSTRUE = "0";
     String sqlGlobal = "";

     
     if (poNo==null || poNo.equals("")) { poNo= ""; }
     if (invoiceNo==null || invoiceNo.equals("") ) { invoiceNo= ""; }
     if (vndInvNo==null || vndInvNo.equals("") ) { vndInvNo= ""; }

     if (dateStringBegin ==null || dateStringBegin =="nullnullnull" ) { dateStringBegin = dateBean.getYearMonthDay(); }
     if (dateStringEnd ==null || dateStringEnd == "nullnullnull") { dateStringEnd = dateBean.getYearMonthDay(); }
/*
     String sqlU = "select WEBID from RPUSER where USERID = '"+userID+"' ";	
	 Statement stateU=con.createStatement();
	 ResultSet rsU=stateU.executeQuery(sqlU);
	 if (rsU.next())
	 { 
	  webID = rsU.getString("WEBID"); 
	 }
     //out.println("webID="+webID);
     //out.println("UserID="+userID);
	 rsU.close();
	 stateU.close();
*/
  %>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr bgcolor="#99CCFF">    
    <td width="32%" bordercolor="#FFFFFF" nowrap><span class="style1"><font face="Arial">Vendor No :</font></span>
      <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhereCenter = "";
		  
		  //sSql = "select DISTINCT CODE_LEVEL as x , CODE_LEVEL || '('||CODE_CLASS ||')' from RPFAULT_DEFINE ";
          sSql = "select VENDOR as x , VENDOR || '('||trim(VNDNAM) ||')' from AVM ";     		  
		  //sWhereCenter = "where FAULT_NO > '0' order by x";	
          sWhereCenter = "where VENDOR between 85000 and 89999 order by x";	     	 
		  sSql = sSql+sWhereCenter;		  
		  		      
          Statement statement=ifxdbexpcon.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='VENDOR' onChange='setSubmit("+'"'+"../jsp/SHIPOInvoiceInquiry.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->ALL");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 	   
                        
            if (s1.equals(vendor)) 
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
    <td width="36%" bordercolor="#FFFFFF" nowrap><font color="#CC0000" face="Arial"><strong>Ship Way : </strong></font>
      <%
         String SHIPWAY="";
         try
         {   
		  String sSql = "";
		  String sWherePerson  = "";
		  
		  sSql = "select DISTINCT SHIPPED_PER as x, SHIPPED_PER from IPOINV_H ";		  		  
		  sWherePerson  = " where HID='HO' ";
		  if (vendor==null || vendor.equals("") || vendor.equals("--") || vendor.equals("ALL"))
		  {  sWherePerson = sWherePerson + "and VENDOR != 0 "; }
		  else { sWherePerson = sWherePerson + "and VENDOR="+vendor+" ";}
		  String sOrderPerson = "order by x ";
		     		              
		  sSql = sSql+sWherePerson+sOrderPerson;
		  
		  //out.println(sSql);
          Statement statement=ifxdbexpcon.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          out.println("<select NAME='SHIPWAY' onChange='setSubmit("+'"'+"../jsp/SHIPOInvoiceInquiry.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
             String s1=(String)rs.getString(1); 
             String s2=(String)rs.getString(2); 
                        
             if (s1.equals(shipWay)) 
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
        %>    </td>
    <td width="32%" bordercolor="#FFFFFF" nowrap><font face="Arial" color="#CC0000"><strong>Payment Term :</strong></font>
      <% 
           
           try
           {   
		    String sSql = "";
		    String sWhere = "";

		   // sSql = "select DISTINCT PAYMENT_TERM , PAYMENT_TERM from INVH ";	
            sSql = "select DISTINCT PAYMENT_TERM, PAYMENT_TERM from IPOINV_H ";		    	   
		    sWhere = "where HID='HO' and trim(PAYMENT_TERM) != '' ";
            if (vendor==null || vendor.equals("") || vendor.equals("--") || vendor.equals("ALL"))
		    {  sWhere = sWhere + "and VENDOR != 0 "; }
		    else { sWhere = sWhere + "and VENDOR="+vendor+" ";}	
            if (shipWay==null || shipWay.equals("") || shipWay.equals("--") || shipWay.equals("ALL")) {  sWhere = sWhere + "and SHIPPED_PER != '0' "; }
            else { sWhere = sWhere + "and SHIPPED_PER='"+shipWay+"' ";}	 
		    sSql = sSql+sWhere;
            //out.println(sSql);		  
		  		      
            Statement statementWS=ifxdbexpcon.createStatement();
            ResultSet rs=statementWS.executeQuery(sSql);
		  
		    out.println("<select NAME='PAYMENTTERM' onChange='setSubmit("+'"'+"../jsp/SHIPOInvoiceInquiry.jsp"+'"'+")'>");
            out.println("<OPTION VALUE=-->--");     
            while (rs.next())
            {            
             String s1=(String)rs.getString(1); 
             String s2=(String)rs.getString(2); 
                        
            if (s1.equals(paymentTerm)) 
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
		    statementWS.close();  		 
           } //end of try

         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         } 
           
      %>    </td>
  </tr>  
  <tr bgcolor="#99CCFF">
    <td bordercolor="#FFFFFF" width="32%"> <font color="#CC0000" face="Arial"><strong>PO No :
            <input name="PONO" type="text" value="<%=poNo%>" size="20" maxlength="15">
    </strong></font> 
    </td>  
    <td bordercolor="#FFFFFF" width="36%"> 
       <font color="#CC0000" face="Arial"><strong>Invoice No. :
            <input name="INVOICENO" type="text" value="<%=invoiceNo%>" size="15" maxlength="15">
       </strong></font>    </td>
    <td bordercolor="#FFFFFF" width="32%">
       <font color="#CC0000" face="Arial"><strong>Vnd.Inv No. :
            <input name="VNDINVNO" type="text" value="<%=vndInvNo%>" size="20" maxlength="15">
       </strong></font>    </td>
  </tr>
  <tr bgcolor="#99CCFF">
    <td valign="top" bordercolor="#CCCCCC" colspan="2"> 
	  <font color="#CC0000" face="Arial"><strong>Inv. Date Fr.</strong></font>
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
        <font color="#CC3366" face="Arial">&nbsp;</font>
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
         <font color="#CC3366" face="Arial">&nbsp;</font>
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
         <font color="#CC0000" face="Arial"><strong> ~<font color="#CC0000" face="Arial"><strong>Inv. Date To</strong></font></strong></font>  
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
        <font color="#CC3366" face="Arial">&nbsp;</font>
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
        <font color="#CC3366" face="Arial">&nbsp;</font>
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
       <td>
         <input name="submit1" type="submit" value="QUERY" onClick='return setSubmit("../jsp/SHIPOInvoiceInquiry.jsp")'>
         <input name="submit2" type="submit"  value="REFRESH" onClick='return setSubmit("../jsp/SHIPOInvoiceInquiry.jsp?ITEMNO=&SHIPWAY=null&VENDOR=null&SYMPTOMCODE=")'>   
       </td>
  </tr>
</table>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
        <tr bgcolor="#FF9933"> 
		  <td width="2%"  height="19" nowrap><font color="#CC0000" size="2">&nbsp;</font></td>
          <td width="9%"  height="19" nowrap><font color="#CC0000" size="2">&nbsp;</font></td>    
          <td width="14%"  height="19" nowrap><font color="#CC0000" size="2">INVOICE NO.</font></td>
          <td width="5%"  height="19" nowrap><font color="#CC0000" size="2">INV LINE</font></td>     
          <td width="5%" nowrap><font color="#CC0000" size="2">VENDOR</font></td>
		  <td width="10%"  nowrap><font color="#CC0000" size="2">VND. INVOICE NO</font></td>		
          <td width="7%" nowrap><font color="#CC0000" size="2">PRINT TIMES</font></td>		   
		  <td width="6%" nowrap><font color="#CC0000" size="2">PO NO.</font></td>
          <td width="5%" nowrap><font color="#CC0000" size="2">PO LINE</font></td>
          <td width="7%" nowrap><font color="#CC0000" size="2">PO UPRICE</font></td>
          <td width="6%" nowrap><font color="#CC0000" size="2">QTY</font></td>
          <td width="14%" nowrap><font color="#CC0000" size="2">ITEM NO.</font></td>
          <td width="10%" nowrap><font color="#CC0000" size="2">INV. DATE</font></td>	   	     		  
        </tr> 
          <%  
            try
            {  
              
              Statement statementTC=ifxdbexpcon.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "select b.INVD, b.ILINE, b.VENDOR, b.VNDINV_NO, b.PORD, b.PLINE, b.PO_ECST, b.QTY, b.IPRODNO, a.INVDATE, a.SHIPPED_PER, a.INVH_PRT   "+
			                  "from IPOINV_H a, IPOINV_D b ";
			  String sWhereTC = "where a.HID= 'HO' and b.DID='DO' and a.INVH=b.INVD and a.VNDINV_NO=b.VNDINV_NO and a.VENDOR = b.VENDOR ";
				
			  if (vendor == null || vendor.equals("--")) { sWhereTC = sWhereTC + "and b.VENDOR != 0  "; }
			  else { sWhereTC = sWhereTC + "and b.VENDOR ="+vendor+"  "; }
              if (shipWay == null || shipWay.equals("--")) { sWhereTC = sWhereTC + "and a.SHIPPED_PER != '0'  "; }
			  else { sWhereTC = sWhereTC + "and a.SHIPPED_PER ='"+shipWay+"'  "; }
              if (paymentTerm == null || paymentTerm.equals("--")) { sWhereTC = sWhereTC + "and a.PAYMENT_TERM != '0'  "; }
			  else { sWhereTC = sWhereTC + "and a.PAYMENT_TERM ='"+paymentTerm+"'  "; }             			             
              if (vndInvNo == null || vndInvNo.equals("")) { sWhereTC = sWhereTC + "and b.VNDINV_NO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and b.VNDINV_NO like '%"+vndInvNo+"%'  "; }
              if (invoiceNo == null || invoiceNo.equals("")) { sWhereTC = sWhereTC + "and b.INVD != '0'  "; }
			  else { sWhereTC = sWhereTC + "and b.INVD like '%"+invoiceNo+"%'  "; }
              if (poNo == null || poNo.equals("")) { sWhereTC = sWhereTC + "and b.PORD != 0  "; }
			  else { sWhereTC = sWhereTC + "and b.PORD ="+poNo+"  "; }
 
			  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and a.INVDATE >="+""+dateStringBegin+" ";
              if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and a.INVDATE between "+""+dateStringBegin+""+" and "+""+dateStringEnd+" ";
			  
			  String sOrderTC = "order by b.INVD, b.ILINE, a.INVDATE ";
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);
		
		      boolean rs_isEmptyTC = !rsTC.next();
              boolean rs_hasDataTC = !rs_isEmptyTC;
              Object rs_dataTC;  
			  
		  // ¢FD[?J?A-?-¢FX???????o??A_
		 
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

          // ¢FD[?J?A-? - !L!| /		
			  String invNoGet = "";
			  while ((rs_hasDataTC)&&(rs1__numRows-- != 0)) 
		     {		 
		         //getDataFlag = true;
		         // fmPrjCode = rs.getString("PROJECTCODE");
                 String invLine = "";
                 
        %>
        <tr bgcolor="#FFCC66">
           <%  
		           String sSql = "select count(ILINE) from IPOINV_D where INVD = '"+rsTC.getString("INVD")+"' ";
                   //out.println(sSql);		  
		  		   Statement stateInvLine=ifxdbexpcon.createStatement();
                   ResultSet rsInvLine=stateInvLine.executeQuery(sSql);
		           if (rsInvLine.next()) invLine = rsInvLine.getString(1);
				   else invLine = "1";
				   rsInvLine.close();
				   stateInvLine.close();  
				
		       if (invNoGet!=rsTC.getString("INVD") && !invNoGet.equals(rsTC.getString("INVD")) )
               {  
			       
           %>   
		   <td rowspan="<%=invLine%>"><a href="../jsp/SHIPOInvoicePrtReset.jsp?INVOICENO=<%=rsTC.getString("INVD")%>">
		      <div align="center"><img src="../image/add.gif" width="14" height="15" border="0"></div></a></td>
           <td height="20" rowspan="<%=invLine%>">
             <INPUT TYPE="button"  value="Save To Excel" onClick='setSubmit("../jsp/SHIPOGenerateInvoiceExcel.jsp?INVOICENO=<%=rsTC.getString("INVD")%>")'>
           </td>       
           <% } %> 
           <%  if (invNoGet!=rsTC.getString("INVD") && !invNoGet.equals(rsTC.getString("INVD")) )
               {  
           %>  
          <td height="20" rowspan="<%=invLine%>"><font size="2" color="#000099">           
                 <% 
                      if (rsTC.getString("INVD")!=null ) { out.println(rsTC.getString("INVD")); } 
                      else { out.println("&nbsp;"); }
                  %></font>            
          </td>	
          <% } %>	 
          <td><font size="2" color="#CC3366" face="Arial"><strong>
                  <%
                      //if (codeClass==null || codeClass=="2" || codeClass.equals("2"))
                      
                       if (rsTC.getString("ILINE")!=null) { out.println(rsTC.getString("ILINE")); } 
                       else { out.println("&nbsp;");  }
                      //=rsTC.getString("TXTYPE") 
                  %></strong></font></td>
		  <td><font size="2" color="#CC3366" face="Arial">
                 <%
                    //if (codeClass==null || codeClass=="2" || codeClass.equals("2"))
                    
                     if (rsTC.getString("VENDOR")!=null) { out.println(rsTC.getString("VENDOR")); } 
                     else { out.println("&nbsp;"); }
                    
                     //=rsTC.getString("TXDATE") 
                 %></font></td>		           
		  <td><font size="2" color="#CC3366">
                 <%
                   
                     if (rsTC.getString("VNDINV_NO")!=null) { out.println(rsTC.getString("VNDINV_NO")); } 
                     else { out.println("&nbsp;"); }
                   
                 %></font></td>
          <td><font size="2" color="#CC3366">
                 <%
                   
                     if (rsTC.getString("INVH_PRT")!=null) { out.println(rsTC.getString("INVH_PRT")); } 
                     else { out.println("&nbsp;"); }
                   
                 %></font></td>
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("PORD") !=null) { out.println(rsTC.getString("PORD")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>		
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("PLINE") !=null) { out.println(rsTC.getString("PLINE")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>	
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("PO_ECST") !=null) { out.println(rsTC.getString("PO_ECST")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("QTY") !=null) { out.println(rsTC.getString("QTY")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>
          <td><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("IPRODNO") !=null) { out.println(rsTC.getString("IPRODNO")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>
           <%  if (invNoGet!=rsTC.getString("INVD") && !invNoGet.equals(rsTC.getString("INVD")) )
               {  
           %>     
           <td rowspan="<%=invLine%>"><font size="2" color="#CC3366">
                 <%
                      if (rsTC.getString("INVDATE") !=null) { out.println(rsTC.getString("INVDATE")); } 
                      else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXRPCENTERNO") 
                 %></font></td>
           <% } %>     
       </tr>
		<%
               invNoGet = rsTC.getString("INVD"); 

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
  <table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
      <tr bgcolor="#FF9933">
         <td width="35%" nowrap><font color="#CC0000" face="Arial">COUNT RECORD = 
           <%
              Statement stateTR=ifxdbexpcon.createStatement(); 
              String sqlTR =  "select count(b.INVD) "+
			                  "from IPOINV_H a, IPOINV_D b ";
			  String sWhereTR = "where a.HID= 'HO' and b.DID='DO' and a.INVH=b.INVD and a.VNDINV_NO=b.VNDINV_NO and a.VENDOR = b.VENDOR ";
				
			  if (vendor == null || vendor.equals("--")) { sWhereTR = sWhereTR + "and b.VENDOR != 0  "; }
			  else { sWhereTR = sWhereTR + "and b.VENDOR ="+vendor+"  "; }
              if (shipWay == null || shipWay.equals("--")) { sWhereTR = sWhereTR + "and a.SHIPPED_PER != '0'  "; }
			  else { sWhereTR = sWhereTR + "and a.SHIPPED_PER ='"+shipWay+"'  "; }
              if (paymentTerm == null || paymentTerm.equals("--")) { sWhereTR = sWhereTR + "and a.PAYMENT_TERM != '0'  "; }
			  else { sWhereTR = sWhereTR + "and a.PAYMENT_TERM ='"+paymentTerm+"'  "; }             			             
              if (vndInvNo == null || vndInvNo.equals("")) { sWhereTR = sWhereTR + "and b.VNDINV_NO != '0'  "; }
			  else { sWhereTR = sWhereTR + "and b.VNDINV_NO like '%"+vndInvNo+"%'  "; }
              if (invoiceNo == null || invoiceNo.equals("")) { sWhereTR = sWhereTR + "and b.INVD != '0'  "; }
			  else { sWhereTR = sWhereTR + "and b.INVD like '%"+invoiceNo+"%'  "; }
              if (poNo == null || poNo.equals("")) { sWhereTR = sWhereTR + "and b.PORD != 0  "; }
			  else { sWhereTR = sWhereTR + "and b.PORD ="+poNo+"  "; }
 
			  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTR=sWhereTR+" and a.INVDATE >="+""+dateStringBegin+" ";
              if (DayFr!="--" && DayTo!="--") sWhereTR=sWhereTR+" and a.INVDATE between "+""+dateStringBegin+""+" and "+""+dateStringEnd+" ";
			  
			  //String sOrderTC = "order by a.INVDATE ";
             
			  sqlTR = sqlTR + sWhereTR ;
			  
			  //sqlGlobal = sqlTQ;
              //out.println(sqlTQ);
              ResultSet rsTR=stateTR.executeQuery(sqlTR); 
              if (rsTR.next()) { out.println(rsTR.getInt(1)); }
              rsTR.close();
              stateTR.close();          
           %> </font>  
         </td>
         <td width="30%">
           <font color="#CC0000" face="Arial">TOTAL Q'TY = 
           <% 
              Statement statementTQ=ifxdbexpcon.createStatement();      // Link To POS SQL DB
             

              String sqlTQ =  "select sum(b.QTY), sum(b.QTY*b.PO_ECST) "+
			                  "from IPOINV_H a, IPOINV_D b ";
			  String sWhereTQ = "where a.HID= 'HO' and b.DID='DO' and a.INVH=b.INVD and a.VNDINV_NO=b.VNDINV_NO and a.VENDOR = b.VENDOR ";
				
			  if (vendor == null || vendor.equals("--")) { sWhereTQ = sWhereTQ + "and b.VENDOR != 0  "; }
			  else { sWhereTQ = sWhereTQ + "and b.VENDOR ="+vendor+"  "; }
              if (shipWay == null || shipWay.equals("--")) { sWhereTQ = sWhereTQ + "and a.SHIPPED_PER != '0'  "; }
			  else { sWhereTQ = sWhereTQ + "and a.SHIPPED_PER ='"+shipWay+"'  "; }
              if (paymentTerm == null || paymentTerm.equals("--")) { sWhereTQ = sWhereTQ + "and a.PAYMENT_TERM != '0'  "; }
			  else { sWhereTQ = sWhereTQ + "and a.PAYMENT_TERM ='"+paymentTerm+"'  "; }             			             
              if (vndInvNo == null || vndInvNo.equals("")) { sWhereTQ = sWhereTQ + "and b.VNDINV_NO != '0'  "; }
			  else { sWhereTQ = sWhereTQ + "and b.VNDINV_NO like '%"+vndInvNo+"%'  "; }
              if (invoiceNo == null || invoiceNo.equals("")) { sWhereTQ = sWhereTQ + "and b.INVD != '0'  "; }
			  else { sWhereTQ = sWhereTQ + "and b.INVD like '%"+invoiceNo+"%'  "; }
              if (poNo == null || poNo.equals("")) { sWhereTQ = sWhereTQ + "and b.PORD != 0  "; }
			  else { sWhereTQ = sWhereTQ + "and b.PORD ="+poNo+"  "; }
 
			  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTQ=sWhereTQ+" and a.INVDATE >="+""+dateStringBegin+" ";
              if (DayFr!="--" && DayTo!="--") sWhereTQ=sWhereTQ+" and a.INVDATE between "+""+dateStringBegin+""+" and "+""+dateStringEnd+" ";
			  
			  //String sOrderTC = "order by a.INVDATE ";
             
			  sqlTQ = sqlTQ + sWhereTQ ;
			  
			  //sqlGlobal = sqlTQ;
              //out.println(sqlTQ);
              ResultSet rsTQ=statementTQ.executeQuery(sqlTQ); 
              if (rsTQ.next()) { out.println(rsTQ.getInt(1)); 
                   
           %></font>
         </td>
         <td width="35%">
           <font color="#CC0000" face="Arial">TOTAL AMOUNT = 
           <% 
               out.println(rsTQ.getInt(2));
              }    
              rsTQ.close();
              statementTQ.close();   
           %></font>
         </td>
     </tr>
  </table>
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
<!--=============¢DH?U¢XI?q?¢XAAcn3s£g2|A==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<!--=================================-->
</html>