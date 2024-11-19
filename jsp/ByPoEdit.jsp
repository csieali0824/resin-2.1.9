<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,RsBean,ComboBoxBean" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean" %>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnBPCSDbexpPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDshoesPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>ByLCShow.jsp</title>
</head>
<jsp:useBean id="rsBean" scope="application" class="RsBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>

<body>
<strong><font color="#0080C0" size="5">LC對應PO報表</font></strong> 
<%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   
   String colorStr = "";
   //
   boolean getDataFlag = false;
%>

<%
  String personNo=request.getParameter("PERSONNO");
  String regionNo=request.getParameter("REGION");
  String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
  //String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  //String regionNo=request.getParameter("REGION");
  String locale_=request.getParameter("LOCALE"); 
  
  
  //String model=request.getParameter("MODEL"); 
  //String color=request.getParameter("COLOR"); 
  
  //String CenterNo="";
  //String agentName =request.getParameter("AGENTNAME"); 
  //String imei =request.getParameter("IMEI"); 
  String WSUserID=(String)session.getAttribute("USERNAME");
  
  String topicType=request.getParameter("TOPICTYPE");
  String topicName=request.getParameter("TOPICNAME");
  //String centerNo=request.getParameter("CENTERNO");  
  String centerNo=request.getParameter("REPCENTERNO");  
  String userid=request.getParameter("USERID");  
  String continent=request.getParameter("CONTINENT");  
  //String locale=request.getParameter("LOCALE");  
  String lcno=request.getParameter("PLCNO");

   
  int numRow = 0;  
%>

  <table width="100%">
    <tr bgcolor="#D0FFFF"> 
      <td width="29%" valign="top" bordercolor="#CCCCCC" bgcolor="#CCEEFF"> <A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
        <font color="#CC3366" face="Arial Black"><strong> </strong></font><font color="#CC3366" face="Arial Black">&nbsp;</font> 
        <font color="#CC3366" face="Arial Black">&nbsp;</font> </td>
    </tr>
  </table>
  

  
  
  <table width="100%" border="1" cellspacing="1" cellpadding="0">
  <tr bgcolor="#CCFFFF"> 
      <td width="13%"><font size="2"><strong>PO</strong></font></td>
      <td width="7%"><font size="2"><strong>LINE</strong></font></td>
      <td width="11%" nowrap><font size="2"><strong>ITEM NO</strong></font></td>
      <td width="10%"><font size="2"><strong>Q'TY</strong></font></td>
      <td width="9%" ><font size="2"><strong>PRICE</strong></font></td>
	  <td width="12%"><font size="2"><strong>CURRENCY</strong></font></td>
	  <td width="8%"><font size="2"><strong>USAGE</strong></font></td>
	  <td width="10%"><font size="2"><strong>STAT</strong></font></td>
	  <td width="8%"><font size="2"><strong>USER</strong></font></td>
	  <td width="12%"><font size="2"><strong>DATE</strong></font></td>
  </tr>
  <% //  *** Main Loop  Start   *** //
       //ResultSet RpRepair = StatementRpRepair.executeQuery(); 	   
	          
            Statement statement=ifxshoescon.createStatement();   		
		    try
		   { 
			//String sql = "select DISTINCT m.DESIGNHOUSE, m.SYSTEMMODE, w.FWREG, w.FWCOUN , w.FWTYPE, w.FWPRJCD, w.FWCOLOR from WSADMIN.PSALES_FORE_WEEK w, WSADMIN.PIMASTER m  ";
			//String sql = "select * from RpPROGRAMMER Order By MODEL";
			//String sql = "select t.TOPICID,  p.TTYPENAME,  t.TOPICNAME,  t.ASKERNAME, t.POSTDATE, t.REPLYCOUNT from RPTECH_TOPIC t, RPTOPIC_TYPE p ";
			/////////////////////////////////////////////////////
		

			
             String sql="select LPORD,LPLINE,LPPROD,LPQORD,LPECST,LPOCUR,LCUSAMT,LPSTAT,LPOENUS,LPOENDT from POLC,HLCM ";
             String sWhere = "where   LCNO='"+lcno+"'and PLCNO=LCNO";
			
		/////////////////////////////////////////////////////////////////////////////////////////////////
  
			
			//if (lcno==null || lcno.equals("")) 
			//{   sWhere = sWhere + "and LCNO !=  'ALL'  "; }
		    //else { sWhere = sWhere + "and LCNO  like '"+lcno+"%'  "; }
			
						  
			sql = sql + sWhere;
		
            //out.println(sql);

//////////////////////////////////////////////////////////////////////////////////////////////			
            ResultSet rs=statement.executeQuery(sql);
		
		    boolean rs_isEmpty = !rs.next();
            boolean rs_hasData = !rs_isEmpty;
            Object rs_data;
		 
		    // 加入分頁-起
		 
           // *** Recordset Stats, Move To Record, and Go To ?Record: declare stats variables

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

          //use index parameter if defined, otherwise use offset para?meter
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

      // *** Move To Record: if we dont know the record count,? check the display range

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

             // if t?he page has a repeated region, remove 'offset' from the maintained parameters
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
  <%
      rs1__index++;
      if ((rs1__index % 2) == 0){
	  colorStr = "DDFFFF";
	  }
	  else{
	  colorStr = "FEFFFF"; }
   %>
  <tr bgcolor="<%=colorStr%>"> 
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPORD")%></strong></font></td>
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPLINE")%></strong></font></td>
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPPROD")%></strong></font></td>
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPQORD")%></strong></font></td>
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPECST")%></strong></font></td>
    <td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPOCUR")%></strong></font></td>
	<td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LCUSAMT")%></strong></font></td>
	<td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPSTAT")%></strong></font></td>
	<td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPOENUS")%></strong></font></td>
	<td nowrap><font color="#993366" size="2"><strong><%=rs.getString("LPOENDT")%></strong></font></td>
  </tr>
  <tr> 
    <td colspan="10" bgcolor="#CCFFFF"> 
      <div align="center"> 
        <% if (rs_isEmpty) { out.println("rs_isEmpty"+rs_isEmpty);%>
        <font color="#CC0066" size="2"><strong>目前資料庫查無符合查詢條件的資料</strong></font> 
        <% } /* end RpRepair_isEmpty */ %>
      </div></td>
  </tr>
  <%
       //rs1__index++;	   	    // 為顯示不同底色資料列 2004/01/08 //
       rs_hasData = rs.next();	   
     }  // End of while for main loop
	 //tmpSalesCde = rs.getString("SALESCODE");
	 rs.close();
	 statement.close();
   } //end of try
   catch (Exception e)
   {
       out.println("Exception:"+e.getMessage());
   }   
 %>
  <tr> 
    <td colspan="10"><div align="left"></div></td>
  </tr>
</table>


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
  
  
  
  
  
  

</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSDbexpPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDshoesPage.jsp"%>
<!--=================================-->
</html>
