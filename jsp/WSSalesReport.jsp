<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%//@include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="dateBean2" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>WSNoWriteCheck</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
</head>
<body>
<FORM ACTION="../jsp/WSSalesReport.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> <font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
    </font> 
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td height="25">
<div align="center"><strong><font color="#0000FF" size="+1" face="Arial">銷項明細表</font></strong> 
            <%
   int rs1__numRows = 20000;
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
      <%  String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  String DATE2=request.getParameter("DATE2");
	  String sDateBegin=dateBean.getYearString()+dateBean.getMonthString(); 
	  int nYear=dateBean.getYear()-1911;	  
	  String sYear=String.valueOf(nYear);	  
	   String sDate=sYear+dateBean.getMonthString() ; 
	   //out.println(sDate); 
	  String WSUserID=(String)session.getAttribute("USERNAME");  
	  String sqlGlobal = "";
	  long sumsubAmt=0; 
	  long sumAmt=0; 
	  long sumTotal=0; 
	  long sumTax=0; 
	  long minAmt=0; 
	  long summinAmt=0; 
	  long sordamt=0; 
	  long invamt=0; 
	  String jno=""; 
	
	  if (TYPE==null || TYPE== "" || TYPE.equals("")) 
		    { TYPE="1"; }
	   if (DATE==null || DATE== "" || DATE.equals("")) 
		    { DATE=sDateBegin; }
	   if (DATE2==null || DATE2== "" || DATE2.equals("")) 
	        {DATE2=dateBean.getYearString()+dateBean.getMonthString();  }
			//out.println(TYPE+DATE+DATE2); 
	   
	   DecimalFormat df=new DecimalFormat(",000.00"); 
	   
     //if (TYPE==null || TYPE.equals("")) {  TYPE= "未兌現";}
    	 
  %>      
    <table width="100%" border="1">
      <tr bgcolor="#0F87FF"> 
        <td width="28%" height="25"><font color="#FFFF00" face="Arial Black"><strong>Type:</strong></font><font size="2">&nbsp; 
          </font> <font color="#FF0066" face="Arial Black"> 
          <select name="TYPE">
            <option value="1" <% if (TYPE!=null && (TYPE=="1" || TYPE.equals("1")) ) { out.println("SELECTED"); } %>>外銷</option>
            <option value="2" <% if (TYPE!=null && (TYPE=="2" || TYPE.equals("2")) ) { out.println("SELECTED"); } %>>內銷</option>
            <option value="3" <% if (TYPE!=null && (TYPE=="3" || TYPE.equals("3")) ) { out.println("SELECTED"); } %>>全部</option>
          </select>
          </font></td>
        <td width="54%"><font color="#FFFF00"><strong>申報年月 起： 
          <input name="DATE" type="text" size="10" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		    { out.println("value="+sDateBegin); }
		   else  
		   { out.println("value="+DATE); }																																							       		
		%>			
		>
          </strong></font> <font color="#FF0066" face="Arial Black">&nbsp;</font><font color="#FFFF00"><strong>訖：</strong></font> 
          <font color="#FF0066" face="Arial Black"> 
          <input name="DATE2" type="text" size="10" 
		<% if (DATE2==null || DATE2== "" || DATE2.equals("")) 
		    { out.println("value="+dateBean.getYearMonthDay()); }
		   else  
		   { out.println("value="+DATE2); }																																							       		
		%>			
		>
          </font></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <input name="button" type="button" onClick='setSubmit("../jsp/WSSalesReport.jsp")'  value="Query" >
            </font><font color="#FFFF00">
            <% 
   
  //  if ((TYPE != null) && !TYPE.equals("--"))
	//{out.println(" <font size='2'  ><A HREF='/wins/report/"+WSUserID+"_Query.xls'> Excel View</A></font>");}	
%>
            </font><font size="2" color="#000099"> </font></div>
          <div align="center"><font color="#FFFF00"> </font></div></td>
      </tr>
    </table>
    <table width="100%"  border="1"  bordercolor="#0000FF"  >
      <tr> 
        <td bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>申報年月</strong></font></div></td>
        <td bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>發票類別</strong></font></div></td>
        <td width="12%" bgcolor="#3300FF"> <div align="center"><font size="2"><strong><font color="#FFFFFF">稞稅別</font></strong></font></div></td>
        <td bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">連續編號</font></strong></font></div></td>
        <td bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>傳票日期</strong></font></div></td>
        <td bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>傳票號碼</strong></font></div></td>
        <td colspan="2" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>客戶名稱</strong></font></div></td>
        <td bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>客戶統編</strong></font></div></td>
      </tr>
      <tr> 
        <td height="15" colspan="3" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>品 
            名</strong></font></div></td>
        <td width="11%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>數量</strong></font></div></td>
        <td width="11%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>單價</strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>金額</strong></font></div></td>
        <td width="11%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>稅額</strong></font></div></td>
        <td width="11%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>總額</strong></font></div></td>
        <td width="13%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong>差額</strong></font></div></td>
      </tr>
      <%      
	     try
            {  
             
              Statement statementTC=bpcscon.createStatement();     
              String sqlTC=""; 
		      String sWhereTC=""; 
			  String sqlTC2=""; 
		      String sWhereTC2=""; 
              if(TYPE.equals("1"))
			  {
               sqlTC =  "SELECT DISTINCT  m.customer_name,m.taxid_no,m.gl_note,m.gl_date,m.seq_no,m.invoice_amt,m.invoice_tax,"+" "+
			                  "m.invoice_type,m.invoice_total,m.tax_yymm,m.valid_cd,m.dpfx"+" "+			                 
			                  "FROM invoice_mst m"+" ";
				    sWhereTC = " where (m.rprf NOT IN ('700','250','230','200','210')  and  m.dpfx not in('70','25','23','20') )   " ;
				
				 if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (m.seq_no[1,6] BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "   ; }
			     else 
				    { sWhereTC = sWhereTC + "AND (m.seq_no[1,6] between " +DATE+" and " +DATE2 +") "  ; }
			  }
			  else if(TYPE.equals("2"))
			  {
               sqlTC =  "SELECT DISTINCT  m.customer_name,m.taxid_no,m.gl_note,m.gl_date,m.seq_no,m.invoice_amt,m.invoice_tax,"+" "+
			                  "m.invoice_type,m.invoice_total,m.tax_yymm,m.valid_cd,m.dpfx"+" "+			                 
			                  "FROM invoice_mst m"+" ";
			    
			     sWhereTC = " where (m.rprf  in ('700','250','230','200','210')  or m.dpfx  in('70','25','23','20')) " ;
				
			   
				   if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (m.seq_no[1,6] BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "   ; }
			     else 
				    { sWhereTC = sWhereTC + "AND (m.seq_no[1,6] between " +DATE+" and " +DATE2 +") "  ; }
			  }			  
			   else
			  {
			    sqlTC =  "SELECT DISTINCT  m.customer_name,m.taxid_no,m.gl_note,m.gl_date,m.seq_no,m.invoice_amt,m.invoice_tax,"+" "+
			                  " m.invoice_type,m.invoice_total,m.tax_yymm,m.valid_cd,m.dpfx"+" "+			                 
			                  "FROM invoice_mst m"+" ";
			    sWhereTC = "  "  ;
				   if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + " (m.seq_no[1,6] BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "   ; }
			     else 
				    { sWhereTC = sWhereTC + " (m.seq_no[1,6] between " +DATE+" and " +DATE2 +") "  ; }
				     			    		   						 
			  }
			  
			  String sOrderTC = "Order by  m.gl_date ,m.gl_note ,m.seq_no  asc";
			   sqlTC = sqlTC + sWhereTC+sOrderTC ;
			   sqlGlobal = sqlTC;
              
			  //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);	 
          		  
			  while (rsTC.next()) 
		     {		 
		       
			    
        %>
      <tr bgcolor="#FFFFFF"> 
        <td width="13%"> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("tax_yymm")!=null ) { out.println(rsTC.getString("tax_yymm")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td width="9%"> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("invoice_type")!=null || rsTC.getString("invoice_type")!=""  ) 
					   { out.println(rsTC.getString("invoice_type")); } 
                      else 
					   { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td height="16"> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("valid_cd")!=null ) { out.println(rsTC.getString("valid_cd")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("seq_no")!=null ) { out.println(rsTC.getString("seq_no")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td><div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("gl_date")!=null ) { out.println(rsTC.getString("gl_date")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td><div align="center"><font size="2" color="#000099"> 
            <%     jno=rsTC.getString("gl_note"); 
			           //out.println("123") 		      ; 
                      if (jno==null  || jno==""  || jno.equals("")) 
					   { out.println("&nbsp;");}
                      else 					
					  { out.println(rsTC.getString("gl_note")); } 
          %>
            </font></div></td>
        <td colspan="2"><div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("customer_name")!=null ) { out.println(rsTC.getString("customer_name")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td><div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("taxid_no")!=null ) { out.println(rsTC.getString("taxid_no")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
      </tr>
      <tr bgcolor="#FFFFFF"> 
        <td height="16" colspan="3"><font color="#CC3366" size="2" > 
          <%		 //int ordqty=0; 
				     //int ordamt =0; 
					 //int unitprice=0; 
			    	 int rSeq=0; 
			    	 int n=0; 				  
				     int arrayIdx=0;					
				    Statement amtStatement=bpcscon.createStatement();				 
				    ResultSet amtRs=amtStatement.executeQuery("Select count(*) from invoice_dtl WHERE seq_no="+rsTC.getString("seq_no")+"");
			    	 if (amtRs.next())
			    	 {
			    	   arrayIdx=amtRs.getInt(1);
			    	 }  
			    	 long  qtyArray[]=new long [arrayIdx];
					 long  priceArray[]=new long [arrayIdx];
					 long  amtArray[]=new long [arrayIdx];
			    	 amtRs.close();				 			 
				     amtStatement.close();				 				 				  
                     try
                    { 
				     Statement docstatement=bpcscon.createStatement();				     		 
                      String  sSqlL = "SELECT  d.ord_qty, d.unit_price, d.ord_amt, d.item_desc"+" "+
			                                 "FROM  invoice_dtl d"+" ";		  
		             String sWhereL = "WHERE seq_no="+rsTC.getString("seq_no")+"  ";
		             sSqlL = sSqlL+sWhereL;                     
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
				   while (docrs.next())                   
				     {		 					 					 
					 qtyArray[n] = docrs.getLong("ord_qty"); 
					 priceArray[n] = docrs.getLong("unit_price"); 
					 amtArray[n] = docrs.getLong("ord_amt"); 
					 //ordqty=docrs.getLong("ord_qty"); 
					 out.println(docrs.getString("item_desc")+"<br>"); 					 					
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
          </font></td>
        <td><div align="right"><font color="#0000FF" size="2" > 
            <% 
		     for (int cc=0;cc<qtyArray.length;cc++)
		     { 
			   if(qtyArray[cc]>=1000 || qtyArray[cc]<=-1000)
			    {out.println(df.format(qtyArray[cc])+"<br>"); }
			   else
			    {out.println(qtyArray[cc]+"<br>"); }
			   
			 			   			    
			  }
			  //subsumAMTMIN=subsumRAMT+sumIAMT; 
	         
		   %>
            </font></div></td>
        <td><div align="right"><font color="#0000FF" size="2" > 
            <% 
		     for (int cc=0;cc<priceArray.length;cc++)
		     { 
			   if(priceArray[cc]>=1000 || priceArray[cc]<=-1000)
			  	    {out.println(df.format(priceArray[cc])+"<br>"); }
			   else
			     {out.println(priceArray[cc]+"<br>"); }
			 			   			    
			  }
			  //subsumAMTMIN=subsumRAMT+sumIAMT; 
	         
		   %>
            </font></div></td>
        <td><div align="right"><font color="#0000FF" size="2" > 
            <% 
		     for (int cc=0;cc<amtArray.length;cc++)
		     { 
			   if(amtArray[cc]>=1000 || amtArray[cc]<=-1000)
			    {out.println(df.format(amtArray[cc])+"<br>"); }
			   else
			    {out.println(amtArray[cc]+"<br>"); }
							 			   			    
			  }
			  //subsumAMTMIN=subsumRAMT+sumIAMT; 
	         
		   %>
            </font></div></td>
        <td colspan="3">&nbsp;</td>
      </tr>
      <tr bgcolor="#CCFFFF"> 
        <td colspan="5"> <div align="right"><font color="#FFFF00" size="2" face="Arial, Helvetica, sans-serif"> 
            </font> </div>
          <div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"><strong>小計</strong> 
            </font></div></td>
        <td> <div align="right"><font size="2" color="#FF0000"> </font> <font color="#FF0000" size="2" > 
            <%
                 long  QTY = 0;  
				 long  PRICE = 0;  
				 
				  
                    try
                   {
                     String  sSqlL = "SELECT  sum(d.ord_qty) qty, sum(d.unit_price) price, sum(d.ord_amt) amt"+" "+
			                                 "FROM  invoice_dtl d"+" ";		  
		             String sWhereL = "WHERE seq_no="+rsTC.getString("seq_no")+" Group by seq_no";		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 {  if(docrs.getLong("amt")>=1000||docrs.getLong("amt")<=-1000)
					     { out.println(df.format(docrs.getLong("amt")));}
						 else
						 { out.println(docrs.getLong("amt")); }
						 sordamt=docrs.getLong("amt"); 
					   //PRICE = docrs.getLong ("price"); 
					     sumAmt = sumAmt+docrs.getLong ("amt"); 
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
        <td> <div align="right"><font size="2" color="#FF0000"> 
            <%
			 if (rsTC.getString("invoice_tax")!=null ) 
			 { if(rsTC.getInt("invoice_tax")>=1000 || rsTC.getInt("invoice_tax")<=-1000)
			   {out.println(df.format(rsTC.getInt("invoice_tax"))); }
			   else
			   {out.println(rsTC.getInt("invoice_tax")); }
			    sumTax=sumTax+rsTC.getLong("invoice_tax"); 
             } 
			 else { out.println("&nbsp;"); } 
			%>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#FF0000"> 
            <% 
                      if (rsTC.getString("invoice_total")!=null ) 
					  { 
					    if(rsTC.getInt("invoice_total")>=1000 || rsTC.getInt("invoice_total")<=-1000)
						{out.println(df.format(rsTC.getInt("invoice_total"))); }
						else
						{out.println(rsTC.getInt("invoice_total")); }
						 invamt=rsTC.getLong("invoice_total"); 
						 minAmt=sordamt-invamt; 
						 summinAmt= summinAmt+ minAmt; 
						 sumTotal=sumTotal+rsTC.getInt("invoice_total"); 
						 
					  } 
                      else { out.println("&nbsp;"); }
             %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#FF0000"> 
            <%
			  if(minAmt>=1000 || minAmt<=-1000)
			  {out.println(df.format(minAmt));}
			  else
			  {out.println(minAmt);}
			  %>
            </font></div></td>
      </tr>
      <%     }//end of while	     
	 
	          rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
      <tr> 
        <td colspan="5" bordercolor="#0000FF" bgcolor="#3300FF"><div align="right"><font color="#FFFF00" size="2"><strong>總計</strong></font></div></td>
        <td bordercolor="#0000FF" bgcolor="#3300FF"> <div align="right"> <font color="#FF0000" size="2" > 
            </font><font size="2" color="#FFFF00"> 
            <%
			  if(sumAmt>=1000 || sumAmt<=-1000)
			  {out.println(df.format(sumAmt));}
			  else
			  {out.println(sumAmt);}
			  %>
            </font></div></td>
        <td bordercolor="#0000FF" bgcolor="#3300FF"> <div align="right"><font size="2" color="#FFFF00"> 
            <%
			  if(sumTax>=1000 || sumTax<=-1000)
			  {out.println(df.format(sumTax));}
			  else
			  {out.println(sumTax);}
			  %>
            </font></div></td>
        <td bordercolor="#0000FF" bgcolor="#3300FF"> <div align="right"><font size="2" color="#FFFF00"> 
            <%
			  if(sumTotal>=1000 || sumTotal<=-1000)
			  {out.println(df.format(sumTotal));}
			  else
			  {out.println(sumTotal);}
			  %>
            </font></div></td>
        <td bordercolor="#0000FF" bgcolor="#3300FF"> <div align="right"><font size="2" color="#FFFF00"> 
            <%
			  if(summinAmt>=1000 || summinAmt<=-1000)
			  {out.println(df.format(summinAmt));}
			  else
			  {out.println(summinAmt);}
			  %>
            </font><font size="2" color="#FFFF66"> </font></div></td>
      </tr>
    </table>
    
	
    <p>
<input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
    </p>
  </div>
  <p>
    <% //Export Excel 
       
   if (TYPE==null )
	{	   
	 out.println("<img src='WSNoWriteCheckExcel.jsp?TYPE="+TYPE+"&DATE="+DATE+"&DATE2="+DATE2+"&USERNAME="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;");	      
	}
	else
	{	 
    out.println("<img src='WSNoWriteCheckExcel.jsp?TYPE="+TYPE+"&DATE="+DATE+"&DATE2="+DATE2+"&USERNAME="+WSUserID+"' height='0' width='0'>&nbsp;&nbsp;");	      
	} 
%>
  </p>  
</FORM>   
    
<p><font size="2" color="#000099"> </font> </p>
  </body>
  <!--=============以下區段為處理完成==========-->
  <%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
