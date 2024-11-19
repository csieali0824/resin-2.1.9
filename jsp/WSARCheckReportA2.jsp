<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
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
<FORM ACTION="WSARCheckReportA2.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> <font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
    </font> 
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="+2" face="Arial">監檢日報表(銀貨兩訖)</font></strong> 
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
    <A HREF="../WinsMainMenu.jsp">HOME</A> 
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
	   
	   String rCustTmp = "";		
	   String rCust = "";    
	   DecimalFormat df=new DecimalFormat(",000"); 
	   

    
	 
  %>
  </div>
  <table width="100%" border="0">
    <tr> 
      <td width="34%" height="35" bgcolor="#006699"><font color="#FFFF00" face="Arial Black"><strong>CustomerType:</strong></font><font size="2">&nbsp; 
        </font> <font color="#FF0066" face="Arial Black"> 
        <select name="TYPE">          
          <option value="1" <% if (TYPE!=null && (TYPE=="1" || TYPE.equals("1")) ) { out.println("SELECTED"); } %>>內銷</option>          
          <option value="3"<% if (TYPE!=null && (TYPE=="3" || TYPE.equals("3")) ) { out.println("SELECTED"); } %>>外銷</option>
          <option value="4"<% if (TYPE!=null && (TYPE=="4" || TYPE.equals("4")) ) { out.println("SELECTED"); } %>>ALL</option>
        </select>
        </font> </td>
      <td width="41%" bgcolor="#006699"><font color="#FFFF00"><strong>收款日結止日：</strong></font> 
        <input name="DATE" type="text" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		    { out.println("value="+dateBean.getYearMonthDay()); }
		   else  
		   { out.println("value="+DATE); }																																							       		
		%>			
		> <font color="#FF0066" face="Arial Black">&nbsp;</font></td>
      <td width="25%" bgcolor="#006699"><input name="button" type="button" onClick='setSubmit("../jsp/WSARCheckReportA2.jsp")'  value="Query" > 
        <font size="2" color="#000099">&nbsp;</font></td>
    </tr>
  </table>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#006666"> 
      <td colspan="2" bordercolor="#000000" bgcolor="#99CCFF"> <div align="center"><strong><font size="2" face="新細明體">客戶</font></strong></div></td>
      <td colspan="4" bordercolor="#000000" bgcolor="#99CCFF"> <div align="center"><strong><font size="2" face="新細明體">訂單</font></strong></div></td>
      <td colspan="3" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">出貨</font></strong></td>
      <td colspan="2" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">收款</font></strong></td>
      <td colspan="2" align=center bordercolor="#000000" bgcolor="#99CCFF"><strong><font size="2" face="新細明體">未出貨</font></strong></td>
      <td width="8%" rowspan="2" bgcolor="#99CCFF"> <div align="center"><font size="2"><strong>到款金額減出貨金額</strong></font></div></td>
      <td width="15%" rowspan="2" bgcolor="#99CCFF"> 
        <div align="center"><strong><font size="2">備註</font></strong></div></td>
    </tr>
    <tr bgcolor="#006666"> 
      <td width="3%" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong><font size="2">代號</font></strong></font></td>
      <td width="16%" bgcolor="#6699FF"> 
        <div align="center"><font color="#FFFFFF" size="2"><strong><font size="2">名稱</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><strong><font color="#FFFFFF" size="2">號碼</font></strong></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="5%" bordercolor="#000000" bgcolor="#6699FF"> <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="6%"bordercolor="#000000" bgcolor="#6699FF"> <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF" > <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="8%"bordercolor="#000000" bgcolor="#6699FF"> <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="6%"bordercolor="#000000" bgcolor="#6699FF"> 
        <div align="right"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
    </tr>
    <%      
	     try
            {  
             
              Statement statementTC=bpcscon.createStatement();      // Link To POS SQL DB
             

              String sqlTC =  "SELECT DISTINCT r1.arodyr,r1.arodpx,r1.rinvc,r1.rcust,r2.arsord,cnme"+" "+
			                  "FROM rar r1,rar r2, rcm"+" ";
			  String sWhereTC = "WHERE (r1.arodyr=r2.arodyr AND r1.arodpx=r2.arodpx AND r1.rinvc=r2.rinvc AND r1.rseq=r2.rnxt AND r1.rcust=ccust)" +" "+
			                    "AND (r1.rrid IN ('RP','RC') AND r1.rseq>=1 )" +" "+
								"AND (r2.rrid='RI' AND r2.rrem=0 ) ";
			  
			  
			  if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereTC = sWhereTC + "AND (r2.RCTYP ='11') "; }
			  else if (TYPE=="1" || TYPE.equals("1") ) { sWhereTC = sWhereTC + "AND (r2.RCTYP ='11') " ;}			
			  //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereTC = sWhereTC + "AND (r2.RCTYP ='12') ";  }			 
			  else if (TYPE=="3" || TYPE.equals("3") ) { sWhereTC = sWhereTC + "AND (r2.RCTYP ='13') " ; }
			  else if (TYPE=="4" || TYPE.equals("4") ) { sWhereTC = sWhereTC + "AND r2.RCTYP IN ('11','13') " ; }
			  
			  if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereTC = sWhereTC + "AND (r1.rdate ='"+dateBean.getYearMonthDay()+"') " ; }
			  else  { sWhereTC = sWhereTC + "AND (r1.rdate ='"+DATE+"') ";}
			  			  
			  String sOrderTC = "order by r1.rcust,r2.arsord,r1.arodyr,r1.arodpx,r1.rinvc";
			  	  
			  //if (ORDERBY==null || ORDERBY== "" || ORDERBY.equals("") || ORDERBY.equals("3")  )  { sOrderTC = sOrderTC + " "; }
			  //else if (ORDERBY=="1" || ORDERBY.equals("1") ) { sOrderTC = sOrderTC +"ORDER BY r.RCUST ";}
			  //if (ORDERBY==null || ORDERBY== "" || ORDERBY.equals("") || ORDERBY.equals("3")  )  { sOrderTC = sOrderTC + " "; }
			  //else if (ORDERBY=="2" || ORDERBY.equals("2") ) { sOrderTC = sOrderTC +"ORDER BY r.rddte";}	  
             	  
			  
             
			  sqlTC = sqlTC + sWhereTC + sOrderTC;
			  
			  sqlGlobal = sqlTC;
              
			  //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);	 

         
		  		  
			  while (rsTC.next()) 
		     {		 
		         //getDataFlag = true;			  		   
			   
		       rCust = rsTC.getString("rcust");	  		   					  		  
               if (rs1__index!=0 && (!rCustTmp.equals("") && !rCustTmp.equals(rCust)))			   		   		       		     
		       { 		 			 				 
				 //out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumILQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumIAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumRAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN+"</div></font></td><td>&nbsp;</td></tr>"); 				
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
      <td> <div align="left"><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("rcust")!=null ) { out.println(rsTC.getString("rcust")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font></div></td>
      <td><div align="left"><font color="#990033" size="1" face="Arial, Helvetica, sans-serif"> 
          </font><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("cnme")!=null ) { out.println(rsTC.getString("cnme")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font><font color="#990033" size="1" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td><div align="center"><font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("arsord") %></font></div></td>
      <td><div align="center"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%      long  LQORD = 0;  
	              long  LAMT = 0;            			  
                    try
                   {
                     String  sSqlL = "Select lodte as lodte, SUM(lqord) as lqord,SUM(lqord*lnet) as lamt ,hcurr from ecl l,ech h ";		  
		             String sWhereL = "WHERE (l.lord=h.hord) AND l.lord='"+rsTC.getString("arsord")+"' AND h.hord='"+rsTC.getString("arsord")+"'"+" GROUP BY l.lodte,h.hcurr "+" "+
					                  "UNION "+" "+
									  "Select lrdte as lodte, count(lord) as lqord,SUM(lchrg) as lamt ,hcurr from ecs l,ech h "+" "+
									  "WHERE (l.lord=h.hord) AND l.lord='"+rsTC.getString("arsord")+"' AND h.hord='"+rsTC.getString("arsord")+"'"+" GROUP BY l.lrdte,h.hcurr ";    		              
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
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <%		    
		    if (LQORD!=0)
		     { 
			   if(LQORD<1000 || LQORD>-1000)
			    {out.println(LQORD); }
			   else	
			    {out.println(df.format(LQORD)); }
			   sumLQORD = sumLQORD + LQORD;}			   
			   			   
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (LAMT!=0)
		     { 
			   //out.println(LAMT); 
			   if(LAMT<1000 || LAMT>-1000)
			  { out.println(LAMT); }
			  else
			  { out.println(df.format(LAMT)); }
			   sumLAMT=sumLAMT+LAMT;			   
			 }
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td><div align="center"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%
                 long  ILQTY = 0;  
				 long  IAMT = 0;  
				  
                    try
                   {
                     String  sSqlL = "select ildate,SUM(ilqty) as ilqty,SUM(ilrev+ilta01) as iamt from sil";		  
		             String sWhereL = " WHERE ilord='"+rsTC.getString("arsord")+"' AND ilodyr='"+rsTC.getString("arodyr")+"' AND ilodpx='"+rsTC.getString("arodpx")+"' AND ilinvn='"+rsTC.getString("rinvc")+"'"+" GROUP BY ildate";		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 {  
					   out.println(docrs.getString("ildate"));
					   ILQTY = docrs.getLong ("ilqty"); 
					   IAMT = docrs.getLong ("iamt"); 
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
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (ILQTY!=0)
		     { 
			   //out.println(ILQTY); 
			   if(ILQTY>=1000  || ILQTY<=-1000)
			   {out.println(df.format(ILQTY)); }
			   else 
			   {out.println(ILQTY);}
			   sumILQTY = sumILQTY + ILQTY; 
			   sumUNQTY = sumLQORD -sumILQTY ; 		    
				
			 }
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td> <div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (IAMT!=0)
		     { 
			   if(IAMT<1000 || IAMT>-1000)
			  { out.println(IAMT); }
			   else 
			  { out.println(df.format(IAMT)); }
			   sumIAMT = sumIAMT + IAMT;
			   sumUNAMT= sumLAMT-sumIAMT; 
			 }
	         else {out.println("&nbsp;"); } 
		   %>
          </font></div></td>
      <td> <div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%
                  
				 long  RAMT=0; 
				 String RRESN = "";  
				 String RREF = "";
				 int rSeq=0; 
				 int n=0; 
				 String rDate = "";
				 int arrayIdx=0;
				 Statement amtStatement=bpcscon.createStatement();				 
				 ResultSet amtRs=amtStatement.executeQuery("Select count(*) from rar WHERE arodyr='"+rsTC.getString("arodyr")+"' AND arodpx='"+rsTC.getString("arodpx")+"' AND rinvc='"+rsTC.getString("rinvc")+"'  AND rrid IN ('RP','RC','RD') ");
				 if (amtRs.next())
				 {
				   arrayIdx=amtRs.getInt(1);
				 }  
				 long  amtArray[]=new long [arrayIdx];
				 amtRs.close();				 			 
				 amtStatement.close();				 
				 				  
                    try
                   { 
				     Statement docstatement=bpcscon.createStatement();				     		 
                     String  sSqlL = "SELECT ramt,rdate,rseq,rref,rresn from rar ";  
		             String sWhereL = "WHERE arodyr='"+rsTC.getString("arodyr")+"' AND arodpx='"+rsTC.getString("arodpx")+"' AND rinvc='"+rsTC.getString("rinvc")+"'  AND rrid IN ('RP','RC','RD')";		              
		             sSqlL = sSqlL+sWhereL;                     
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
					 				 
				   
				   while (docrs.next())                   
				     {		 					 					 
					 amtArray[n] = docrs.getLong ("ramt"); 
					 RRESN = docrs.getString("rresn"); 
					 RREF = docrs.getString("rref"); 
					 rSeq = docrs.getInt("rseq"); 
					 rDate = docrs.getString("rdate"); 
					 if (rDate==null || rDate=="" ||rDate.equals(""))
					     {out.println("&nbsp;");} 					 
					 else{out.println(docrs.getString("rdate"));} 
			         n++;			
	                 } //end of docrs while
					 n=0;					 		 	   
	                 docstatement.close();
                     docrs.close(); 	   
                     } //end of try
                     catch (Exception e)
                  {
                   out.println("Exception:"+e.getMessage());
                  }	   	
                     
                 %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font size="2" color="#000099"></font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if(!rCustTmp.equals("") && !rCustTmp.equals(rCust))
		       {subsumRAMT=0;}
			    //subsumAMTMIN=0; } 
		     for (int cc=0;cc<amtArray.length;cc++)
		     { 
			    //if(amtArray[cc]>0){out.println(amtArray[cc]+"<br>");} 
				//else {out.println(0);} 
			   if(amtArray[cc]>1000 || amtArray[cc]<-1000)
			   {out.println(df.format(amtArray[cc])+"<br>"); }
			   else
			   {out.println(amtArray[cc]+"<br>"); }
			   RAMT=amtArray[cc]; 
			   sumRAMT = sumRAMT + amtArray[cc];
			   subsumRAMT = subsumRAMT +amtArray[cc] ; 			   			    
			  }
			  //subsumAMTMIN=subsumRAMT+sumIAMT; 
	          sumAMTMIN = sumRAMT +sumIAMT ; 
		   %>
          </font></div></td>
      <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF"> 
          <% 
	         out.println("&nbsp;"); 
		   %>
          </font></font></div></td>
      <td><div align="right"><font size="2" face="Arial, Helvetica, sans-serif"><font color="#0000FF"> 
          <% 
		   out.println("&nbsp;");
		   %>
          </font></font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		   out.println("&nbsp;");
		   %>
          </font></div></td>
      <td><div align="center"> <font color="#000000" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC.getString("arodyr") %> <%=rsTC.getString("arodpx") %> <%=rsTC.getString("rinvc") %> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		   int CKSTS = 0; 
		   
		    try
		   {  
		     RREF = RREF.trim();  
			 RRESN = RRESN.trim();   	
	         Statement docstatement=bpcscon.createStatement();
			 //String sql = "SELECT cksts  FROM xrar WHERE trim(ckno)='"+RREF+"'";  // Update by Kerwin
			 String sql = "SELECT cksts  FROM xrar WHERE ckno='"+RREF+"'";
             ResultSet docrs=docstatement.executeQuery(sql);	 
	         //out.println("sql="+sql);out.println("STEP0");
              while (docrs.next())
               {	 
		       //out.println("STEP0.1");
		        CKSTS = docrs.getInt("cksts");   			    
	            } //end of docrs while		 	   
	            docstatement.close();
                docrs.close(); 	   
           } //end of try    
		    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }
		   %>
          <% if (RRESN!=null &&( RRESN=="SALRE" || RRESN.equals("SALRE")))
		        { 
			     out.println("銷退"); 
			    }
	            else if ((RRESN!=null &&( RRESN!="SALRE"||!RRESN.equals("SALRE"))) && (RREF=="" || RREF.equals("") ) )
			    {
			    out.println("&nbsp;"); //out.println("STEP1");
			    } 
			    else if ((RRESN!=null &&( RRESN!="SALRE"||!RRESN.equals("SALRE"))) && (CKSTS==1 ))
			    {
			    out.println("未兌現"); 
			    }  
			    else if ((RRESN!=null &&( RRESN!="SALRE"||!RRESN.equals("SALRE")))&& (CKSTS==2 ))
			    {
			    out.println("已兌現"); 
			    }  
			    else 
			    {
			    out.println(RREF); 
			    }  
		   %>
          </font></div></td>
    </tr>
    <%         /*if(rCustTmp.equals(rCust)) {
			   		subsumLQORD=subsumLQORD+ LQORD; 
			   }
			   else{
			   		 subsumLQORD=0; 
			   }*/
			    if(!rCustTmp.equals(rCust)) {
			   		 subsumLQORD = 0;
					 subsumLQORD=LQORD; 
					 subsumLAMT=0;
					 subsumLAMT=LAMT;
					 subsumILQTY=0; 
					 subsumILQTY = ILQTY; 
					 subsumIAMT=0;
					 subsumIAMT=IAMT;
					 subsumUNQTY=0; 
					 subsumUNAMT=0; 
					 subsumAMTMIN=0; 
					 subsumRAMT =0;
					 subsumRAMT =RAMT;
			         		
			   }
			   else{
					 subsumLQORD=subsumLQORD+ LQORD; 
					 subsumLAMT=subsumLAMT+LAMT;
					 subsumILQTY = subsumILQTY + ILQTY; 
					 subsumIAMT=subsumIAMT+IAMT;
					 subsumUNQTY = subsumLQORD -subsumILQTY ; 					 
					 subsumUNAMT = subsumLAMT -subsumIAMT ; 					 
					 subsumRAMT = subsumRAMT + RAMT;
			         subsumAMTMIN = subsumRAMT +subsumIAMT ; 
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
			   rCustTmp=rCust; 
			  /*if(!rsTC)
			    { 		 			 				 
				 out.println("<tr bgcolor='#FFCCFF'><td colspan='4'>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLQORD+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumLAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumILQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumIAMT+"</div></font></td><td>&nbsp;</td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumRAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNQTY+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumUNAMT+"</div></font></td><td><font size='2' color='#000099' face='Arial'><div align='right'>"+subsumAMTMIN+"</div></font></td><td>&nbsp;</td></tr>"); 				
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
