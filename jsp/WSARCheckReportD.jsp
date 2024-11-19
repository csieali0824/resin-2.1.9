<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為處理開始==========-->
 <%//@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============To get Connection from different DB==========-->

<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSARCheckReport</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="WSARCheckReportD2.jsp" METHOD="post" NAME="MYFORM">
  <div align="left">
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="+2" face="Arial">監檢日報表(催貨催款)</font></strong> 
            <%
   int rs1__numRows = 2000;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
          </div></td>
      </tr>
    </table>
    
    <% 
     
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     //String regionNo=request.getParameter("REGION");
      String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  
	  String sqlGlobal = "";
	   	   
	   long  sumLQORD=0 ;
	   String sumLQORD_str="";  
	   long  sumLAMT=0 ;  
	   String sumLAMT_str=""; 
	   long  sumILQTY=0; 
	   String sumILQTY_str=""; 
	   long  sumIAMT=0; 
	   String sumIAMT_str=""; 
	   long  sumRAMT=0; 
	   String sumRAMT_str=""; 
	   long  sumUNQTY=0; 
	   String sumUNQTY_str=""; 
	   long  sumUNAMT=0;
	   String sumUNAMT_str=""; 
	   long  sumAMTMIN=0;  
	   String sumAMTMIN_str=""; 
	   
	   long  subsumLQORD=0 ; 
	   String subsumLQORD_str="";
	   long  subsumLAMT=0 ;  
	   String subsumLAMT_str="";
	   long  subsumILQTY=0; 
	   String subsumILQTY_str=""; 
	   long  subsumIAMT=0; 
	   String subsumIAMT_str=""; 
	   long  subsumRAMT=0; 
	   String subsumRAMT_str=""; 
	   long  subsumUNQTY=0; 
	   String subsumUNQTY_str=""; 
	   long  subsumUNAMT=0;
	   String subsumUNAMT_str=""; 
	   long  subsumAMTMIN=0;     
	   String subsumAMTMIN_str=""; 
	   
	    String lcustTmp = "";		
	   String lcust = "";    
	   DecimalFormat df=new DecimalFormat(",000"); 
	   

	   
	   
	  
    
	 
  %>
  </div>
  <table width="100%" border="0">
    <tr> 
      <td width="39%" bgcolor="#006699"><font color="#FFFF00" face="Arial Black"><strong>CustomerType:</strong></font><font size="2">&nbsp; 
        </font> <font color="#FF0066" face="Arial Black"> 
        <select name="TYPE">          
          <option value="1" <% if (TYPE!=null && (TYPE=="1" || TYPE.equals("1")) ) { out.println("SELECTED"); } %>>內銷</option>         
          <option value="3"<% if (TYPE!=null && (TYPE=="3" || TYPE.equals("3")) ) { out.println("SELECTED"); } %>>外銷</option>
          <option value="4"<% if (TYPE!=null && (TYPE=="4" || TYPE.equals("4")) ) { out.println("SELECTED"); } %>>ALL</option>
        </select>
        </font> </td>
      <td width="33%" bgcolor="#006699"><font color="#FFFF00"><strong>收款日結止日：</strong></font> 
        <input name="DATE" type="text" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		    { out.println("value="+dateBean.getYearMonthDay()); }
		   else  
		   { out.println("value="+DATE); }																																							       		
		%>			
		> <font color="#FF0066" face="Arial Black">&nbsp; </font></td>
      <td width="28%" bgcolor="#006699"><input name="button" type="button" onClick='setSubmit("../jsp/WSARCheckReportD.jsp")'  value="Query" > 
        <font size="2" color="#000099">&nbsp; </font></td>
    </tr>
  </table>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#006666"> 
      <td colspan="2" bordercolor="#000000" bgcolor="#99CCFF"> <div align="center"><strong><font size="2" face="新細明體">客戶</font></strong></div></td>
      <td colspan="4" bordercolor="#000000" bgcolor="#99CCFF"> <div align="center"><strong><font size="2" face="新細明體">訂單</font></strong></div></td>
      <td colspan="3" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">出貨</font></strong></td>
      <td colspan="2" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">收款</font></strong></td>
      <td colspan="2" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">未出貨</font></strong></td>
      <td width="8%" rowspan="2" bgcolor="#99CCFF"> 
        <div align="center"><strong><font size="2">到款金額減出貨金額</font></strong></div></td>
      <td width="18%" rowspan="2" nowrap bgcolor="#99CCFF"> 
        <div align="center"><strong><font size="2">備註</font></strong></div></td>
    </tr>
    <tr bgcolor="#006666"> 
      <td width="2%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong><font size="2">代號</font></strong></font></td>
      <td width="18%" bgcolor="#6699FF"> 
        <div align="center"><font color="#FFFFFF" size="2"><strong><font size="2">名稱</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="center"><strong><font color="#FFFFFF" size="2">號碼</font></strong></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="4%" nowrap bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="8%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="4%" nowrap bgcolor="#6699FF" nowrapbordercolor="#000000"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="7%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="7%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="4%" nowrap bgcolor="#6699FF" nowrapbordercolor="#000000"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="8%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
    </tr>
    <%      
	     try
            {  
             
              Statement statementTC=bpcscon.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "SELECT DISTINCT 0,'',0,lcust, lord, cnme "+" "+
			                  " From ecl,rcm"+" "; 
			  String sWhereTC = "WHERE lcust=ccust" +" "; 
			  String sWhereTC1= "AND( (lid='CL' AND lqshp=0"  +" "; 
			  String sWhereTC2=	"lqshp=(SELECT sum(tqty*-1) FROM ith "  +" "; 								
			  String sWhereTC3 ="WHERE ttype='B' AND tref=lord AND thlin=lline  " ; 							
			  
			  
			  if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereTC = sWhereTC + "AND (ctype ='11') "; }
			  else if (TYPE=="1" || TYPE.equals("1") ) { sWhereTC = sWhereTC + "AND (ctype ='11') " ;}			  
			 // else if (TYPE=="2" || TYPE.equals("2") ) { sWhereTC = sWhereTC + "AND (ctype ='12') ";  }			  
			  else if (TYPE=="3" || TYPE.equals("3") ) { sWhereTC = sWhereTC + "AND (ctype ='13') " ; }
			  else if (TYPE=="4" || TYPE.equals("4") ) { sWhereTC = sWhereTC + " AND ctype IN('11','13') " ;}
			  
			  
			  if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereTC1 = sWhereTC1 + "AND lodte <='"+dateBean.getYearMonthDay()+"') OR (lodte ='"+dateBean.getYearMonthDay()+"' AND " ; }
			  else  { sWhereTC1 = sWhereTC1 + "AND lodte <='"+DATE+"') OR (lodte='"+DATE+"' AND ";}
			  
			  if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereTC3 = sWhereTC3 + "AND ttdte>'"+dateBean.getYearMonthDay()+"'))) " ; }
			  else  { sWhereTC3 = sWhereTC3 + "AND ttdte>'"+DATE+"')))";}
			  			  
			  String sOrderTC = "ORDER BY 4,5";
			  	  
			
			  
             
			  sqlTC = sqlTC + sWhereTC+ sWhereTC1+ sWhereTC2+ sWhereTC3 + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              
			  //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);		      
			    
		      
          // ¢FFFFFD[?J?A-? - !L!| /
		  		  
			  while (rsTC.next())
		     {		 
		         //getDataFlag = true;			  		   
			   
		       lcust = rsTC.getString("lcust");	  		   					  		  
               if (rs1__index!=0 && (!lcustTmp.equals("") && !lcustTmp.equals(lcust)))			   		   		       		     
		        { 		 			 				 
				 //out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>&nbsp;</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>&nbsp;</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>&nbsp;</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN+"</div></font></td><td>&nbsp;</td></tr>"); 				
				 out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumILQTY_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumIAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumRAMT_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN_str+"</div></font></td><td>&nbsp;</td></tr>"); 
		        } 
			    
        %>
    <%
         
          /*if ((rs1__index % 2) == 0)
         {
	        colorStr = "#FFCCFF";
	     }
	     else
         {
	        colorStr = "#FFFFFF";
         }*/
		 		 
        %>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="left"><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("lcust")!=null ) { out.println(rsTC.getString("lcust")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font></div></td>
      <td><div align="left"><font size="2" color="#000099"> </font><font color="#990033" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font size="2" color="#000099">
          <% 
                      if (rsTC.getString("cnme")!=null ) { out.println(rsTC.getString("cnme")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font><font color="#990033" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font size="2" color="#000099">&nbsp; </font><font color="#990033" size="2" face="Arial, Helvetica, sans-serif">&nbsp; 
          </font></div></td>
      <td><div align="center"><font size="2" color="#000099"> </font><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("lord") %></font></div></td>
      <td><div align="center"><font size="2" color="#000099"> </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%      int LQORD = 0;  
	              int LAMT = 0;            			  
                    try
                   {
                     String  sSqlL = "Select lodte as lodte, SUM(lqord) as lqord,SUM(lqord*lnet) as lamt ,hcurr from ecl l,ech h";		  
		             String sWhereL = " WHERE (l.lord=h.hord) AND l.lord='"+rsTC.getString("lord")+"' AND h.hord='"+rsTC.getString("lord")+"'"+" GROUP BY l.lodte,h.hcurr "+" "+
					                  "UNION "+" "+
									  "Select lrdte as lodte, count(lord) as lqord,SUM(lchrg) as lamt ,hcurr from ecs l,ech h "+" "+
									  "WHERE (l.lord=h.hord) AND l.lord='"+rsTC.getString("lord")+"' AND h.hord='"+rsTC.getString("lord")+"'"+" GROUP BY l.lrdte,h.hcurr "; 		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 
					  
					   out.println(docrs.getString("lodte"));
					   LQORD = docrs.getInt("lqord"); 
					   LAMT = docrs.getInt("lamt"); 
					 }
                     else {  out.println("&nbsp;"); }
                     docrs.close();
                     docstatement.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }	
                     
                 %>
          </font></div></td>
      <td><div align="right"><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <%		    
		    if (LQORD!=0)
		     { 
			   if(LQORD>=1000 || LQORD<=-1000)
			   {out.println(df.format(LQORD)); }
			   else
			   {out.println(LQORD); }
			   sumLQORD = sumLQORD + LQORD;
			   sumUNQTY = sumLQORD; }			   
			   			   
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td><div align="right"><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (LAMT!=0)
		     { 
			  if(LAMT>=1000 || LAMT<=-1000)
			   {out.println(df.format(LAMT)); }
			  else
			   {out.println(LAMT); }
			   sumLAMT=sumLAMT+LAMT;
			   sumUNAMT= sumLAMT; 			   
			 }
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td><div align="center"><font size="2" color="#000099"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		   out.println("&nbsp;");
		   %>
          </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		   out.println("&nbsp;");
		   %>
          </font><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td> <div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% 
		   out.println("&nbsp;");
		   %>
          </font><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td> <div align="center"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% 
		   out.println("&nbsp;");
		   %>
          </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% 
		   out.println("&nbsp;");
		   %>
          </font><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td><div align="right"><font size="2" color="#000099">&nbsp; </font><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF"> 
          <% 
	         out.println("&nbsp;"); 
		   %>
          </font></font></div></td>
      <td><div align="right"><font size="2" color="#000099">&nbsp; </font><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF"> 
          </font><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF"> 
          </font><font size="2" face="Arial, Helvetica, sans-serif"><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF">
          <% 
		   out.println("&nbsp;");
		   %>
          </font></font></font><font color="#0000FF"> </font></font><font color="#0000FF"> 
          </font></font></div></td>
      <td><div align="right"><font size="2" color="#000099">&nbsp; </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		   out.println("&nbsp;");
		   %>
          </font></div></td>
      <td><div align="center"><font size="2" color="#000099">&nbsp; </font> <font color="#000000" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
    </tr>
    <%         /*if(lcustTmp.equals(lcust)) {
			   		subsumLQORD=subsumLQORD+ LQORD; 
			   }
			   else{
			   		 subsumLQORD=0; 
			   }*/
			   if(!lcustTmp.equals(lcust)) {
			   		 subsumLQORD = 0;
					 subsumLQORD=LQORD; 
					 subsumLAMT=0;
					 subsumLAMT=LAMT;
					 //subsumILQTY=0; 
					 subsumUNQTY=0;
					 subsumUNQTY=LQORD; 
					 subsumUNAMT=0; 
					 subsumUNAMT=LAMT; 
					 
					 
					 //subsumILQTY = ILQTY; 
					 //subsumIAMT=0;
					 //subsumIAMT=IAMT;
					 //subsumRAMT =0;
					 //subsumRAMT =RAMT;
			         		
			   }
			   else{
					 subsumLQORD=subsumLQORD+ LQORD; 
					 subsumLAMT=subsumLAMT+LAMT;
					 //subsumILQTY = subsumILQTY + ILQTY; 
					 //subsumIAMT=subsumIAMT+IAMT;
					 
					 subsumUNQTY = subsumLQORD   ; 
					 subsumUNAMT = subsumLAMT ; 					 
					 //subsumRAMT = subsumRAMT + RAMT;
			         //subsumAMTMIN = subsumRAMT +subsumIAMT ; 
			   } 	   
			   
			     subsumLQORD_str=String.valueOf(subsumLQORD);
			   if (subsumLQORD_str.length()>3)		
	            {subsumLQORD_str=df.format(subsumLQORD);}
			   subsumLAMT_str=String.valueOf(subsumLAMT);
			   if (subsumLAMT_str.length()>3)		
	            {subsumLAMT_str=df.format(subsumLAMT);}
				subsumILQTY_str=String.valueOf(subsumILQTY);
			   if (subsumILQTY_str.length()>3)		
	            {subsumILQTY_str=df.format(subsumILQTY);}
				subsumIAMT_str=String.valueOf(subsumIAMT);
			   if (subsumIAMT_str.length()>3)		
	            {subsumIAMT_str=df.format(subsumIAMT);}
				subsumUNQTY_str=String.valueOf(subsumUNQTY);
			   if (subsumUNQTY_str.length()>3)		
	            {subsumUNQTY_str=df.format(subsumUNQTY);}
				subsumUNAMT_str=String.valueOf(subsumUNAMT);			   
			   if (subsumUNAMT_str.length()>3)		
	            {subsumUNAMT_str=df.format(subsumUNAMT);}
				subsumRAMT_str=String.valueOf(subsumRAMT);
			   if (subsumRAMT_str.length()>3)		
	            {subsumRAMT_str=df.format(subsumRAMT);}
			   subsumAMTMIN_str=String.valueOf(subsumAMTMIN);
			   if (subsumAMTMIN_str.length()>3)		
	            {subsumAMTMIN_str=df.format(subsumAMTMIN);}
			   
			   	            
			   rs1__index++;		 		  			   	  			   		   			                        		  			  
			   lcustTmp=lcust; 
			  /*if(!rsTC)
			    { 		 			 				 
				 out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumILQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumIAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumRAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY+"</div></font></td><t????? ??
???o?d><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN+"</div></font></td><td>&nbsp;</td></tr>"); 				
				 out.println("<tr bgcolor='#6699FF'><td colspan='4'><font size='3' color='#FFFF00' face='Arial'><strong><div align='right'>TOTAL</div></strong></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumLQORD+"</strong></div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumLAMT+"</strong></div></font></td><td>&nbsp;</td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumILQTY+"</strong></div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumIAMT+"</strong></div></font></td><td>&nbsp;</td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumRAMT+"</strong></div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumUNQTY+"</strong></div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumUNAMT+"</strong></div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'><strong>"+sumAMTMIN+"</strong></div></font></td><td>&nbsp;</td></tr>"); 
		        }  */
			  
	} //end while
	           sumLQORD_str=String.valueOf(sumLQORD);
			   if (sumLQORD_str.length()>3)		
	            {sumLQORD_str=df.format(sumLQORD);}
			   sumLAMT_str=String.valueOf(sumLAMT);
			   if (sumLAMT_str.length()>3)		
	            {sumLAMT_str=df.format(sumLAMT);}
				sumILQTY_str=String.valueOf(sumILQTY);
			   if (sumILQTY_str.length()>3)		
	            {sumILQTY_str=df.format(sumILQTY);}
				sumIAMT_str=String.valueOf(sumIAMT);
			   if (sumIAMT_str.length()>3)		
	            {sumIAMT_str=df.format(sumIAMT);}
				sumUNQTY_str=String.valueOf(sumUNQTY);
			   if (sumUNQTY_str.length()>3)		
	            {sumUNQTY_str=df.format(sumUNQTY);}
				sumUNAMT_str=String.valueOf(sumUNAMT);			   
			   if (sumUNAMT_str.length()>3)		
	            {sumUNAMT_str=df.format(sumUNAMT);}
				sumRAMT_str=String.valueOf(sumRAMT);
			   if (sumRAMT_str.length()>3)		
	            {sumRAMT_str=df.format(sumRAMT);}
			   sumAMTMIN_str=String.valueOf(sumAMTMIN);
			   if (sumAMTMIN_str.length()>3)		
	            {sumAMTMIN_str=df.format(sumAMTMIN);}
			   
	out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumILQTY_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumIAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumRAMT_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT_str+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN_str+"</div></font></td><td>&nbsp;</td></tr>"); 					
	out.println("<tr bgcolor='#6699FF'><td colspan='4'><font size='3' color='#FFFF00' face='Arial'><strong><div align='right'>TOTAL</div></strong></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumLQORD_str+"</div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumLAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumILQTY_str+"</div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumIAMT_str+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumRAMT_str+"</div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumUNQTY_str+"</div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumUNAMT_str+"</div></font></td><td><font size='2' color='#FFFF00' face='Arial'><div align='right'>"+sumAMTMIN_str+"</div></font></td><td>&nbsp;</td></tr>"); 			
			  // out.println(rCustTmp);
			   			   
			   			              	  		  	            	     
	          rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
  </table>
  <div align="left">
    <p>
      <input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
    </p>
	</FORM>   
    <p>&nbsp; </p>
  </body>
  <!--=============以下區段為處理完成==========-->
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
