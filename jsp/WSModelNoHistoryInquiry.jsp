<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QryAllChkBoxEditBean,ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>

<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System-產品編碼系統查詢</title>
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
  flag=confirm("Confirm  post to BPCS ? ");  
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
function mrModelNoHistory(pp)
{    
  subWin=window.open("WSModelNoHistoryInquiry.jsp?MODELNO="+pp);  
}
</script>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font></font></font><font color="#000000" size="+2" face="Times New Roman"><strong>產品編碼系統資料歷程查詢</strong></font>
<FORM ACTION="../jsp/WSMRModelEncodeHistory.jsp" METHOD="post" NAME="MYFORM">
<%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
 %>
<A HREF="../WinsMainMenu.jsp">首頁</A> &nbsp;&nbsp;<A HREF="../jsp/WSModelEncodingSub.jsp">產品編碼管理作業</A>  
<% 
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     
     String [] addItems=request.getParameterValues("ADDITEMS");
     //String regionNo=request.getParameter("REGION");
     String prodCls=request.getParameter("PRODCLS");
     //String personNo=request.getParameter("PERSONNO");
     //String reasonCode=request.getParameter("REASONCODE");

     //String itemNo=request.getParameter("ITEMNO");
     String PMUser=request.getParameter("PMUSER");
     String modelNo=request.getParameter("MODELNO");

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
     //if (itemNo==null) { itemNo= ""; }
     if (PMUser==null) { PMUser= ""; }
     if (modelNo==null) { modelNo= ""; }

     if (DayFr==null || DayTo==null) 
     { 
        dateStringBegin=dateBean.getYearMonthDay();
        dateStringEnd=dateBean.getYearMonthDay();        
     }     
/* for no authortication
     String sqlU = "select WEBID from WSUSER where WEBID = '"+userID+"' ";	
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
<table width="80%" border="1" cellspacing="0" cellpadding="0">
        <tr bgcolor="#CCFFCC">                    
		  <td width="4%"  height="19" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>項次</strong></font></td>             
          <td width="7%"  height="19" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>單號狀態</strong></font></td>
          <td width="7%" bgcolor="#CCFFCC"  nowrap><font color="#0000CC" size="2"><strong>修改人員</strong></font></td>
          <td width="7%" bgcolor="#CCFFCC"  nowrap><font color="#0000CC" size="2"><strong>修改日期</strong></font></td> 
          <td width="7%" bgcolor="#CCFFCC"  nowrap><font color="#0000CC" size="2"><strong>修改時間</strong></font></td>    
		  <td width="7%" bgcolor="#CCFFCC"  nowrap><font color="#0000CC" size="2"><strong>申請日期</strong></font></td>		  		         
		  <td width="7%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>申請人員</strong></font></td>		  
		  <td width="7%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>外部型號</strong></font></td>
		  <td width="10%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>專案啟動日期</strong></font></td>
          <td width="10%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>專案截止日期</strong></font></td>    
          <td width="7%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>研發單位</strong></font></td>          
          <td width="11%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>版本</strong></font></td>
          <td width="9%" bgcolor="#CCFFCC" nowrap><font color="#0000CC" size="2"><strong>備註</strong></font></td>       
        </tr> 
          <%  
            try
            {  
              
              Statement statementTC=con.createStatement();      // Link To POS SQL DB
             
             
              String sqlTC =  "select PID, APPNO, MODELNO, PRODCLS, APPLY_DATE, APPLY_USER, SALESCODE, PJTTNON_DATE,PJTTNOFF_DATE, RDESIGN_DPT, "+                              
			                  "MVERSION, REMARK, ENUSER, UPDATEUSER, UPDATEDATE, UPDATETIME  "+
			                  "from MRMODEL_HIST ";
			  String sWhereTC = "where PID IN('MO','MZ') ";
                                //"and TTYPE in('S') and TTDTE >= 20040524 ";     // ?????????
	/*
			  if (centerNo == null || centerNo.equals("--")) { sWhereTC = sWhereTC + " "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else 
              { 
                Statement userRepStat=con.createStatement();
                ResultSet userRepRs=userRepStat.executeQuery("SELECT BLWHS FROM RPCENTER_T WHERE trim(REPCENTERNO)='"+centerNo+"'");
                String blWhs="";//依所選的維修中心代碼抓其隸屬倉庫別
	            if (userRepRs.next() )
	            {
	                   blWhs=userRepRs.getString("BLWHS");	  	                    
	            }	 	  
	            userRepRs.close();
	            userRepStat.close();     
                sWhereTC = sWhereTC + "and b.TWHS ='"+blWhs+"'  "; 
              }
                          
			  if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and b.TTDTE >="+""+dateStringBegin+" ";
              if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and b.TTDTE between "+""+dateStringBegin+""+" and "+""+dateStringEnd+" ";
	*/		
   /* 
              if (prodCls == null || prodCls.equals("--")) { sWhereTC = sWhereTC + " "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and PRODCLS ='"+prodCls+"'  "; }
              if (modelNo == null || modelNo.equals("")) { sWhereTC = sWhereTC + " "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and MODELNO ='"+modelNo+"'  "; }
              if (PMUser == null || PMUser.equals("")) { sWhereTC = sWhereTC + " "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and APPLY_USER ='"+PMUser+"'  "; }          
              if ((!(DayFr=="--")&&(DayFr=="00")) && DayTo=="--") sWhereTC=sWhereTC+" and APPLY_DATE >="+""+dateStringBegin+" ";
              if (DayFr!="--" && DayTo!="--") sWhereTC=sWhereTC+" and APPLY_DATE between "+""+dateStringBegin+""+" and "+""+dateStringEnd+" ";
              
   */	      
              if (modelNo == null || modelNo.equals("")) { sWhereTC = sWhereTC + " "; } // {sWhereTC = sWhereTC + "and b.TXRPCENTERNO != '0'  "; }
			  else { sWhereTC = sWhereTC + "and MODELNO ='"+modelNo+"'  "; }
			  String sOrderTC = "order by MVERSION ";
             
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
		  <td bgcolor="#CCFFCC">
		      <div align="center"><font size="-1" color="#FFFFFF">
                <% 
                 int rowNo = rs1__index+1;
                 out.println("<font color='#0000CC' size='2'><div align='center'><strong>"+rowNo+"</strong></div></font>"); 
                %>
              </font></div></td>             
          <td height="20"><font size="2" color="#000099">                      
                 <% 
                      if (rsTC.getString("PID")!=null ) { out.println(rsTC.getString("PID")); } 
                      else { out.println("&nbsp;"); }
                 %></font></td>		 
          <td><font size="2" color="#000000">                
                 <%
                       if (rsTC.getString("UPDATEUSER")!=null) { out.println(rsTC.getString("UPDATEUSER")); } 
                       else { out.println("&nbsp;"); }
                       //=rsTC.getString("TCOM") 
                 %></font></td>
          <td><font size="2" color="#000000">
                  <%
                       if (rsTC.getString("UPDATEDATE")!=null) { out.println(rsTC.getString("UPDATEDATE")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXTYPE") 
                  %></font></td>
           <td><font size="2" color="#000000">
                  <%
                       if (rsTC.getString("UPDATETIME")!=null) { out.println(rsTC.getString("UPDATETIME")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXTYPE") 
                  %></font></td>
		  <td><font size="2" color="#000000">
                 <%
                     if (rsTC.getString("APPLY_DATE") !=null) { out.println(rsTC.getString("APPLY_DATE") ); } 
                     else { out.println("&nbsp;"); }
                     //=rsTC.getString("TXDATE") 
                 %></font></td>
		  <td><font size="2" color="#000000">
                <%
                      if (rsTC.getString("APPLY_USER") !=null) { out.println(rsTC.getString("APPLY_USER") ); } 
                      else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXUSER") 
                 %></font></td>		  
		  <td><font size="2" color="#000000">
                <%
                     if (rsTC.getString("SALESCODE")!=null) { out.println(rsTC.getString("SALESCODE")); } 
                     else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXWHSE") 
                %></font></td>
		  <td><font size="2" color="#000000">
                 <%
                       if (rsTC.getString("PJTTNON_DATE") !=null && !rsTC.getString("PJTTNON_DATE").equals(" ")  ) { out.println(rsTC.getString("PJTTNON_DATE")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXLOC") 
                 %></font></td>
          <td><font size="2" color="#000000">
                 <%
                       if (rsTC.getString("PJTTNOFF_DATE") !=null && !rsTC.getString("PJTTNOFF_DATE").equals(" ")  ) { out.println(rsTC.getString("PJTTNOFF_DATE")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXLOC") 
                 %></font></td> 
          <td><font size="2" color="#000000">
                 <%
                       if (rsTC.getString("RDESIGN_DPT") !=null && !rsTC.getString("RDESIGN_DPT").equals(" ")  ) { out.println(rsTC.getString("RDESIGN_DPT")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXLOC") 
                 %></font></td>              
          <td><font size="2" color="#000000">
                 <%
                       if (rsTC.getString("MVERSION")!=null) { out.println(rsTC.getString("MVERSION")); } 
                       else { out.println("&nbsp;"); }
                       //=rsTC.getString("TXTIME")
                    //out.println(rpTxComNo); 
                 %></font></td>
          <td><font size="2" color="#000000">
                 <%
                       if (rsTC.getString("REMARK") !=null && !rsTC.getString("REMARK").equals(" ")  ) { out.println(rsTC.getString("REMARK")); } 
                       else { out.println("&nbsp;"); }
                      //=rsTC.getString("TXLOC") 
                 %></font></td>    
       </tr>
		<%
               rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
             }
	        //tmpSalesCde = rs.getString("SALESCODE");
            //  stateBPCS.close();     // ??BPCS??? //
          /*
              qryAllChkBoxEditBean.setPageURL("../jsp/RPItemConsumePost2BPCSEdit.jsp");
              qryAllChkBoxEditBean.setSearchKey("TCOM");
              qryAllChkBoxEditBean.setFieldName("CHKFLAG");
              qryAllChkBoxEditBean.setRowColor1("B0E0E6");
              qryAllChkBoxEditBean.setRowColor2("ADD8E6");
              qryAllChkBoxEditBean.setRs(rsTC);   
              //qryAllChkBoxEditBean.setScrollRowNumber(25); 
              //out.println(qryAllChkBoxEditBean.getRsString());   
           */  
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
<!--=============¢FDH?U¢FXI?q?¢FXAAcn3s¢Gg2|A==========-->

<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
