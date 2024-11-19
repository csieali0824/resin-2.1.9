<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSARMaintenance</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="WSARMaintenance.jsp" METHOD="post" NAME="MYFORM">
  <font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font><font color="#000000" size="+2" face="Times New Roman"> 
  <strong>AR Overdue Maintenance </strong></font> 
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
  <A HREF="../WinsMainMenu.jsp">HOME</A> 
  <% 
     
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     //String regionNo=request.getParameter("REGION");
     String ORDERBY=request.getParameter("ORDERBY");
	 String STATUS=request.getParameter("STATUS");
	 String LoginID="T"+userID;
	 //out.println(userID);     
	 //out.println(LoginID); 
     String sqlGlobal = "";

    
	 
  %>
  <table width="100%" border="0">
    <tr> 
      <td width="39%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>排序</strong></font><font size="2">&nbsp; 
        </font> <font color="#FF0066" face="Arial Black"> 
        <select name="ORDERBY">
          <option value="3"></option>
          <option value="1">客戶代碼</option>
          <option value="2">到期日</option>
        </select>
        &nbsp;</font> </td>
      <td width="33%" bgcolor="#006699"><font color="#FF0066" face="Arial Black"><strong>查詢狀態</strong></font><font size="2">&nbsp;</font><font color="#FF0066" face="Arial Black"> 
        <select name="STATUS">
          <option value="3"></option>
          <option value="1">已處理</option>
          <option value="2">未處理</option>
        </select>
        </font> <font color="#FF0066" face="Arial Black">&nbsp; 
        </font></td>
      <td width="28%" bgcolor="#006699"><input name="button" type="button" onClick='setSubmit("../jsp/WSARMaintenance.jsp")'  value="Query" >
        <font size="2" color="#000099">&nbsp; </font></td>
    </tr>
  </table>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#006666"> 
      <td width="3%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>LINK</strong></font></td>
      <td width="5%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">客戶代碼</font></td>
      <td width="25%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">客戶名稱</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">Doc#</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">處理狀態</font></td>
      <td width="25%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">狀態說明</font></td>
      <td width="6%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">預計收款日</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">立帳日</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">發票日</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">到期日</font></td>
      <td width="2%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">幣別</font></td>
      <td width="5%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">原幣金額</font></td>
      <td width="2%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">匯率</font></td>
      <td width="5%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">台幣金額</font></td>
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">業務員</font></td>
      <td width="43%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2">序號</font></td>
    </tr>
    <%      
	     try
            {  
             
              Statement statementTC=bpcscon.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "Select r.RCUST,c.CNME,o.RINVC,o.DUNCODE,o.DUNDESP,o.RECDATE,r.RIDTE,r.RIDTE,r.RDDTE,r.RCURR,r.RREM,r.RCNVFC,r.RCAMT,m.SSAL,o.SERIAL "+
			                  " FROM overduear o,rar r,rcm c,ssm m";
			  String sWhereTC = " WHERE o.SERIAL=r.SERIALCOLUMN and  r.rcust=c.ccust  and  c.csal=m.ssal and r.rrem!=0 and o.PRINT!='N' and SMFAXN='"+LoginID+"'  ";
			  
			  
			  if (STATUS==null || STATUS== "" || STATUS.equals("") || STATUS.equals("3") )  { sWhereTC = sWhereTC + " "; }
			  else if (STATUS=="1" || STATUS.equals("1") ) { sWhereTC = sWhereTC + "AND (REPLYDATE is not null OR REPLYDATE!='') " ; }
			  if (STATUS==null || STATUS== "" || STATUS.equals("") || STATUS.equals("3")) { sWhereTC = sWhereTC + " " ; }
			  else if (STATUS=="2" || STATUS.equals("2")){ sWhereTC = sWhereTC + "AND (REPLYDATE is null OR REPLYDATE='') " ; }			  
			  			  
			  String sOrderTC = "";
			  if (ORDERBY==null || ORDERBY== "" || ORDERBY.equals("") || ORDERBY.equals("3")  )  { sOrderTC = sOrderTC + " "; }
			  else if (ORDERBY=="1" || ORDERBY.equals("1") ) { sOrderTC = sOrderTC +"ORDER BY r.RCUST ";}
			  if (ORDERBY==null || ORDERBY== "" || ORDERBY.equals("") || ORDERBY.equals("3")  )  { sOrderTC = sOrderTC + " "; }
			  else if (ORDERBY=="2" || ORDERBY.equals("2") ) { sOrderTC = sOrderTC +"ORDER BY r.rddte";}	  
             	  
			  
             
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
      <td><a href="WSAREdit.jsp?RCUST=<%=rsTC.getString("RCUST")%>&CNME=<%=rsTC.getString("CNME")%>&DUNCODE=<%=rsTC.getString("DUNCODE")%>&DUNDESP=<%=rsTC.getString("DUNDESP")%>&RECDATE=<%=rsTC.getString("RECDATE")%>&RIDTE=<%=rsTC.getString("RIDTE")%>&RDDTE=<%=rsTC.getString("RDDTE")%>&RCURR=<%=rsTC.getString("RCURR")%>&RREM=<%=rsTC.getString("RREM")%>&RCNVFC=<%=rsTC.getString("RCNVFC")%>&RCAMT=<%=rsTC.getString("RCAMT")%>&SSAL=<%=rsTC.getString("SSAL")%>&SERIAL=<%=rsTC.getString("SERIAL")%>"> 
        <div align="center"><img src="../image/docicon.gif" width="14" height="19" border="0"></div>
        </a></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RCUST")!=null ) { out.println(rsTC.getString("RCUST")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("CNME")!=null ) { out.println(rsTC.getString("CNME")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RINVC")!=null ) { out.println(rsTC.getString("RINVC")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("DUNCODE")!=null ) { out.println(rsTC.getString("DUNCODE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("DUNDESP")!=null ) { out.println(rsTC.getString("DUNDESP")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RECDATE")!=null ) { out.println(rsTC.getString("RECDATE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RIDTE")!=null ) { out.println(rsTC.getString("RIDTE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RIDTE")!=null ) { out.println(rsTC.getString("RIDTE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RDDTE")!=null ) { out.println(rsTC.getString("RDDTE")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RCURR")!=null ) { out.println(rsTC.getString("RCURR")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RREM")!=null ) { out.println(rsTC.getString("RREM")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RCNVFC")!=null ) { out.println(rsTC.getString("RCNVFC")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("RCAMT")!=null ) { out.println(rsTC.getString("RCAMT")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099"> 
        <% 
                      if (rsTC.getString("SSAL")!=null ) { out.println(rsTC.getString("SSAL")); } 
                      else { out.println("&nbsp;"); }
                  %>
        </font></td>
      <td><font size="2" color="#000099">
        <% 
                      if (rsTC.getString("SERIAL")!=null ) { out.println(rsTC.getString("SERIAL")); } 
                      else { out.println("&nbsp;"); }
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
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
