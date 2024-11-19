<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="DateBean,java.text.DecimalFormat,CodeUtil"%>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnCQPoolPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean2" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>QcIssueTracking</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="../jsp/PISQcIssueQuery.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> 
    <p><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> </font> 
      <% 
	  String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
      String year="",month=""; 	  
     String Model=request.getParameter("MODELNO"); 
	 String type=request.getParameter("TYPE"); 
	  String sqlGlobal = "";
	 
			//out.println(TYPE+DATE+DATE2); 
		   
	   
	   DecimalFormat df=new DecimalFormat(",000"); 
	   
     //if (TYPE==null || TYPE.equals("")) {  TYPE= "未兌現";}
    
	 
  %>
      <%
   int rs1__numRows = 30;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   String stitle=" "; 
   if(type==null || (type!=null && !type.equals("REPAIR")) )
   { stitle=" TOP 3 Defect "; }
   else
   { stitle="故障症狀明細表"; }
   //
   //boolean getDataFlag = false;
 %>
 <font color="#54A7A7" size="+2" face="Arial Black"><strong>DBTEL</strong></font>
 <font color="#FF9900"><strong>
 <% 
out.println(Model); 
%>
 </strong></font> <font color="#0066FF"><strong><%out.println(stitle);%></strong></font> 
    <table    border="1" cellpadding="0" cellspacing="0">
      <tr bgcolor="#0072A8"> 
        <td width="7%"  rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">Model</font></strong></div></td>
        <td width="10%"  rowspan="2" nowrap><div align="center"><strong><font color="#FFFFFF" size="2">登錄日期</font></strong></div></td>
        <td width="10%"  rowspan="2" nowrap><div align="center"><strong><font color="#FFFFFF" size="2">導入日期</font></strong></div></td>
        <td width="11%"  rowspan="2" nowrap bgcolor="#0072A8"> <div align="center"><strong><font color="#FFFFFF" size="2">問題敘述</font></strong></div></td>
        <td width="7%"  rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">類別</font></strong></div></td>
        <td width="12%"  rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">不良原因分析</font></strong></div></td>
        <td width="8%" rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">負責人</font></strong></div></td>
        <td height="15" colspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2"> 
            改善對策</font></strong></div></td>
        <td width="9%"  rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">到期日</font></strong></div></td>
        <td width="6%" rowspan="2" nowrap> <div align="center"><strong><font color="#FFFFFF" size="2">狀態</font></strong></div></td>
      </tr>
      <tr bgcolor="#0072A8"> 
        <td width="15%"  nowrap><div align="center"><strong><font color="#FFFFFF" size="2">長期</font></strong></div></td>
        <td width="15%"  nowrap><div align="center"><strong><font color="#FFFFFF" size="2">短期</font></strong></div></td>
      </tr>
      <%      
	     try
            {  
			
            
			
              Statement statementTC=conCQ.createStatement();      // Link To POS SQL DB             
              //String sqlTC =  "SELECT  PRIORITY,FYEAR,FMONTH	, FWEEK,GDATE,AREA,MODELNO,PROBDESC,CELLSOFT,SYSTEM,DEFECTANALY,PIC,IMPPLAN,DUEDATE,STATUS,CREATEUSER"+""+
			                          //" FROM qcissuelist  ORDER BY fyear,fmonth desc,priority asc";
			  String sWhereTC=""; 
              String sqlTC =  "select ID,SUBMIT_DATE,IMPLEMENT_DATE,MODEL_NAME,SOURCE_TYPE,ISSUE_TYPE,ISSUE_DESCRIPTION,CAUSE_ANALYSIS,PIC,SHORT_TERM_CA,LONG_TERM_CA,DUE_DATE,STATUS "+""+
			                          " FROM CQPITMS.V_DETAIL_PROBLEM_LIST ";
			 //out.println(repair); 
              if( type==null || (type!=null  &&  !type.equals("REPAIR")) )
			  { sWhereTC = " Where MODEL_NAME= '"+Model+"'  AND SOURCE_NO=33554484  AND  TRIM(STATUS) IN ('In-Work','Under-Verify','Close')";			}  			 			
			  else 
			  { sWhereTC = " Where MODEL_NAME= '"+Model+"'  AND SOURCE_NO!=33554484 AND  TRIM(STATUS) IN ('In-Work','Under-Verify','Close') ";			}  			
			
 			
			  String sOrderTC = "Order by IMPLEMENT_DATE desc";			             	  			              
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
	        colorStr = "#D9F2FF";
	     }	  
         
	     else
         {
	        colorStr = "#CCFFFF";
         }
        %>
      <tr bgcolor="<%=colorStr%>"> 
        <td height="20"><div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("MODEL_NAME")!=null ) { out.println(rsTC.getString("MODEL_NAME")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font></div></td>
        <td><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("SUBMIT_DATE")!=null ) { out.println(rsTC.getString("SUBMIT_DATE")); } 
                      else { out.println("&nbsp;"); }
                  %>
          </font></td>
        <td><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("IMPLEMENT_DATE")!=null ) { out.println(rsTC.getString("IMPLEMENT_DATE")); } 
                      else { out.println("&nbsp;"); }
                  %>
          </font></td>
        <td><font size="2" color="#000099"> 
          <% 		         
					String desc="";
					DataInputStream input=new DataInputStream( rsTC.getBinaryStream("ISSUE_DESCRIPTION"));					
					
		             //input=new DataInputStream( rsTC.getBinaryStream("ISSUE_DESCRIPTION"));					
                    try 
					 {
					desc=input.readLine();
					desc =CodeUtil.big5ToUnicode(desc); 					
					out.println(desc);
					 } 	 catch(Exception e)  {					 
					     out.print("&nbsp;");
					 }
					
                  %>
          </font></td>
        <td><div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("ISSUE_TYPE")!=null ) { out.println(rsTC.getString("ISSUE_TYPE")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font></div></td>
        <td><font size="2" color="#000099"> 
          <% 		  
		    /*
                      if (rsTC.getString("CAUSE_ANALYSIS")!=null ) { out.println(rsTC.getString("CAUSE_ANALYSIS")); } 
                     else { out.println("&nbsp;"); }
		   */			
					String analysis="";
					 input=new DataInputStream( rsTC.getBinaryStream("CAUSE_ANALYSIS"));															 																				
					 try 
					 {
					    analysis=input.readLine();
						analysis =CodeUtil.big5ToUnicode(analysis);
					    out.print(analysis);
					 } 	 catch(Exception e)  {					 
					     out.print("&nbsp;");
					 }
					
				  
				  %>
          </font></td>
        <td><font size="2" color="#000099"> 
          <% 
	String pic="";
	 try 
					 {
		  input=new DataInputStream( rsTC.getBinaryStream("PIC"));					
		  pic=input.readLine();
		  pic=CodeUtil.big5ToUnicode(pic); 				
			 out.println(pic);
			  } 	 catch(Exception e)  {					 
					     out.print("&nbsp;");
					 }
		  /*
                      if (rsTC.getString("PIC")!=null ) { out.println(rsTC.getString("PIC")); } 
                      else { out.println("&nbsp;"); }
		*/			  
                  %>
          </font></td>
        <td ><font size="2" color="#000099"> 
          <% 
   /*
                     if (rsTC.getString("SHORT_TERM_CA")!=null ) { out.println(rsTC.getString("SHORT_TERM_CA")); } 
                    else { out.println("&nbsp;"); }
	*/				
	                String stermca="";
					 input=new DataInputStream( rsTC.getBinaryStream("SHORT_TERM_CA"));					
					
                    try 
					 {
					stermca=input.readLine();
					stermca =CodeUtil.big5ToUnicode(stermca); 					
					out.println(stermca);
					 } 	 catch(Exception e)  {					 
					     out.print("&nbsp;");
					 }
	
                  %>
          </font></td>
        <td ><font size="2" color="#000099"> 
          <% 
		  /*
                      if (rsTC.getString("LONG_TERM_CA")!=null ) { out.println(rsTC.getString("LONG_TERM_CA")); } 
                      else { out.println("&nbsp;"); }				  
					  
		*/			  
                String ltermca="";
				input=new DataInputStream( rsTC.getBinaryStream("LONG_TERM_CA"));					
					
                    try 
					 {
					ltermca=input.readLine();
					ltermca =CodeUtil.big5ToUnicode(ltermca); 					
					out.println(ltermca);
					 } 	 catch(Exception e)  {					 
					     out.print("&nbsp;");
					 }		
                  %>
          </font></td>
        <td><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("DUE_DATE")!=null ) { out.println(rsTC.getString("DUE_DATE").substring(0,4)+"/"+rsTC.getString("DUE_DATE").substring(5,7)+"/"+rsTC.getString("DUE_DATE").substring(8,10)); } 
                      else { out.println("&nbsp;"); }
                  %>
          </font></td>
        <td><div align="left"></div>
          <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("STATUS")!=null ) { out.println(rsTC.getString("STATUS")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font></div></td>
      </tr>
      <%    
	           rs1__index++;	   
               rs_hasDataTC = rsTC.next();	   
              
			 }//end of while  
	 
	          rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
    </table>    
<input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">  
  </div>
 <table  height="2%" border="0" dwcopytype="CopyTableRow">
      <tr align="center" bordercolor="#000000" > 
        <td width="24%" bgcolor="#FFFFFF"> <div align="center"> 
            <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveFirst%>">First</A></strong></font></pre>
          </div></td>
        <td width="24%"> <div align="center"> 
            <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_movePrev%>">Previous</A></strong></font></pre>
          </div></td>
        <td width="24%"> <div align="center"> 
            <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveNext%>">Next</A></strong></font></pre>
          </div></td>
        <td width="28%"> <div align="center"> 
            <pre><font color="#FF0000" face="Arial"><strong><A HREF="<%=MM_moveLast%>">Last</A></strong></font></pre>
          </div></td>
      </tr>
  </table>   
</FORM>   
   
<p><font size="2" color="#000099"> </font> </p>
</body>
  <!--=============以下區段為處理完成==========-->
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnCQPage.jsp"%>
<!--=================================-->
</html>
