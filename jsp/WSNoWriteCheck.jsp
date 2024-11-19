<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%@include file="/jsp/include/AuthenticationPage.jsp"%>
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
<FORM ACTION="WSNoWriteCheck.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> <font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
    </font> 
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="+2" face="Arial">未開票明細表</font></strong> 
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
   
    <p><A HREF="../WinsMainMenu.jsp">HOME</A> 
      <% 
     
 
      String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  String DATE2=request.getParameter("DATE2");
	  String sDateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  int nYear=dateBean.getYear()-1911;	  
	  String sYear=String.valueOf(nYear);	  
	   String sDate=sYear+dateBean.getMonthString()+dateBean.getDayString() ; 
	   //out.println(sDate); 
	  String WSUserID=(String)session.getAttribute("USERNAME");  
	  String sqlGlobal = "";
	  int sumAmt=0; 
	  if (TYPE==null || TYPE== "" || TYPE.equals("")) 
		    { TYPE="3"; }
	   if (DATE==null || DATE== "" || DATE.equals("")) 
		    { DATE=sDateBegin; }
	   if (DATE2==null || DATE2== "" || DATE2.equals("")) 
	        {DATE2=dateBean.getYearMonthDay(); }
			//out.println(TYPE+DATE+DATE2); 
		   
	   
	   DecimalFormat df=new DecimalFormat(",000"); 
	   
     //if (TYPE==null || TYPE.equals("")) {  TYPE= "未兌現";}
    
	 
  %>
    </p>
    <table width="100%" border="1">
      <tr bgcolor="#0F87FF"> 
        <td width="28%"><font color="#FFFF00" face="Arial Black"><strong>Type:</strong></font><font size="2">&nbsp; 
          </font> <font color="#FF0066" face="Arial Black">           
		  <select name="TYPE">		   
            <option value="1" <% if (TYPE!=null && (TYPE=="1" || TYPE.equals("1")) ) { out.println("SELECTED"); } %>>未兌現</option>
            <option value="2" <% if (TYPE!=null && (TYPE=="2" || TYPE.equals("2")) ) { out.println("SELECTED"); } %>>未開票</option>
            <option value="3" <% if (TYPE!=null && (TYPE=="3" || TYPE.equals("3")) ) { out.println("SELECTED"); } %>>全部</option>
          </select>
          </font></td>
        <td width="54%"><font color="#FFFF00"><strong>BeginDate： 
          <input name="DATE" type="text" size="10" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		    { out.println("value="+sDateBegin); }
		   else  
		   { out.println("value="+DATE); }																																							       		
		%>			
		>
          </strong></font> <font color="#FF0066" face="Arial Black">&nbsp;</font><font color="#FFFF00"><strong>EndDate：</strong></font> 
          <font color="#FF0066" face="Arial Black"> 
          <input name="DATE2" type="text" size="10" 
		<% if (DATE2==null || DATE2== "" || DATE2.equals("")) 
		    { out.println("value="+dateBean.getYearMonthDay()); }
		   else  
		   { out.println("value="+DATE2); }																																							       		
		%>			
		>
          </font></td>
        <td width="9%"><div align="center"><font size="2" color="#000099"> 
            <input name="button" type="button" onClick='setSubmit("../jsp/WSNoWriteCheck.jsp")'  value="Query" >
            </font></div></td>
        <td width="9%" bgcolor="#FFFFFF">
<div align="center"><font color="#FFFF00"> 
            <% 
   
    if ((TYPE != null) && !TYPE.equals("--"))
	{out.println(" <font size='2'  ><A HREF='/wins/report/"+WSUserID+"_Query.xls'> Excel View</A></font>");}	
%>
            </font></div></td>
      </tr>
    </table>
    <table width="100%" border="1">
      <tr> 
        <td colspan="2" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>廠商</strong></font><font size="2"><strong></strong></font></div></td>
        <td width="5%" bgcolor="#3300FF"> <div align="center"><font size="2"><strong><font color="#FFFFFF">帳號</font></strong></font><font color="#FFFFFF" size="2"><strong></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">EVENT</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">傳票號碼</font></strong></font></div></td>
        <td width="5%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">幣別</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">幣別金額</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">匯率</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">台幣金額</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">付款日期</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">開票日</font></strong></font></div></td>
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
               sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           "xpay.tda as tda,"+
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+" "+
			                  "FROM amh,xpay,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = "WHERE amh.amhcpc = xpay.jno AND  amh.amhvnd = xpay.vnd AND  amh.amhpam = xpay.sdamt AND" +" "+
			                                 "amh.amhcpc = ghh.hhjnen AND  amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							             	" ghh.hhjnen = vt2.vouno ";
				 if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+"AND "+dateBean.getYearMonthDay()+")"+									 
								                        	 " AND  xpay.tda> " +sDate
										 
				    ; }
			     else 
				    {int nDATE2 = Integer.parseInt(DATE2);
					
					 nDATE2=nDATE2 -19110000; 
					 //out.println(nDATE2); 

					  sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"+
										  "  AND  xpay.tda> " +nDATE2
				     ; }
			  }
			  else if(TYPE.equals("2"))
			  {
               sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                            " ' 'as tda, " +			                          
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+
			                   " FROM amh,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = " WHERE amh.amhcpc = ghh.hhjnen AND  amh.amhtda = ghh.hhjdat AND" +" "+
			                         "amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							         " ghh.hhjnen = vt2.vouno AND  amh.amhsts = 'A' ";
				  if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+" AND "+dateBean.getYearMonthDay()+")"									 
								                        											 
				    ; }
			     else  
				    { sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"
					;  }
			  }			  
			   else
			  {
			    sqlTC =  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           "xpay.tda as tda,"+
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+" "+
			                  "FROM amh,xpay,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC = "WHERE amh.amhcpc = xpay.jno AND  amh.amhvnd = xpay.vnd AND  amh.amhpam = xpay.sdamt AND" +" "+
			                                 "amh.amhcpc = ghh.hhjnen AND  amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							             	" ghh.hhjnen = vt2.vouno ";
				    if (DATE==null || DATE== "" || DATE.equals("")  )  
			      	  { sWhereTC = sWhereTC + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+"AND "+dateBean.getYearMonthDay()+")"+									 
								                        	 " AND  xpay.tda> " +sDate
				    	; }
				  else 
				    {int nDATE2 = Integer.parseInt(DATE2);
					
					 nDATE2=nDATE2 -19110000; 
					 //out.println(nDATE2); 

					  sWhereTC = sWhereTC + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"+
										  "  AND  xpay.tda> " +nDATE2
				     ; }
			     sqlTC2=  "SELECT amh.amhvnd, amh.amhbnk, amh.amhcur, amh.amhtda, amh.amhpam, amh.abhpam, amh.amcnfc,"+
			                           " 0  as tda, " +			                          
									   "ghh.hhjdat, ghh.hhtrno,"+
									   "avm.vndnam,"+
									   "vt2.refno"+
			                   " FROM amh,ghh ,avm ,OUTER vt2"+" ";
			    sWhereTC2 = " WHERE amh.amhcpc = ghh.hhjnen AND  amh.amhtda = ghh.hhjdat AND" +" "+
			                         "amh.amhvnd = avm.vendor AND  ghh.hhjdat = vt2.voudate AND" +" "+
							         " ghh.hhjnen = vt2.vouno AND  amh.amhsts = 'A' ";
				  if (DATE==null || DATE== "" || DATE.equals("")  )  
				  { sWhereTC2 = sWhereTC2 + "AND (amh.amhtda BETWEEN"+sDateBegin+ " AND " +dateBean.getYearMonthDay()+") "+
				                                             " AND (ghh.hhjdat BETWEEN "+sDateBegin+" AND "+dateBean.getYearMonthDay()+")"									 
				   ; }	
			 	else  
				    { sWhereTC2 = sWhereTC2 + "AND (amh.amhtda between " +DATE+" and " +DATE2 +") "+
				                         " AND (ghh.hhjdat between " +DATE+" and " +DATE2+")"
					;  }
				   						 
			  }
			  
			  
			  
			  String sOrderTC = " Order by 10 ASC";			  	  			 
             if(TYPE.equals("3"))	
			   {sqlTC = sqlTC = sqlTC + sWhereTC+"  UNION  " +  sqlTC2+ sWhereTC2 +sOrderTC ;}
			  else
			   {sqlTC = sqlTC = sqlTC + sWhereTC+sOrderTC ;}
			  
			  sqlGlobal = sqlTC;
              
			  out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);	 
          
		  		  
			  while (rsTC.next()) 
		     {		 
		        
			    
        %>
      <tr bordercolor="#0000FF" bgcolor="#FFFFFF"> 
        <td width="5%"> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("amhvnd")!=null ) { out.println(rsTC.getString("amhvnd")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td width="22%"><font size="2" color="#000099"> 
          <% 
                      if (rsTC.getString("vndnam")!=null ) { out.println(rsTC.getString("vndnam")); } 
                      else { out.println("&nbsp;"); }
          %>
          </font></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("amhbnk")!=null ) { out.println(rsTC.getString("amhbnk")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("hhtrno")!=null ) { out.println(rsTC.getString("hhtrno")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("refno")!=null ) { out.println(rsTC.getString("refno")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("amhcur")!=null ) { out.println(rsTC.getString("amhcur")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%   if (rsTC.getString("amhpam")!=null) { out.println(df.format(rsTC.getInt("amhpam"))); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("amcnfc")!=null ) { out.println(rsTC.getString("amcnfc")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("abhpam")!=null ) { out.println(df.format(rsTC.getInt("abhpam"))); } 
                      else { out.println("&nbsp;"); }
					  sumAmt=sumAmt+rsTC.getInt("abhpam");
					  
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("amhtda")!=null ) { out.println(rsTC.getString("amhtda")); } 
                      else { out.println("&nbsp;"); }
          %>
            </font></div></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("tda")!=null ) { out.println(rsTC.getString("tda")); } 
                      else { out.println("&nbsp;"); }
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
      <tr bordercolor="#0000FF"> 
        <td colspan="7" bgcolor="#3300FF">&nbsp;</td>
        <td bgcolor="#3300FF"> <div align="right"><font size="2" color="#FFFF00"><strong>合計</strong></font></div></td>
        <td bgcolor="#3300FF"> <div align="right"><font size="2" color="#FFFF66"> 
            <% 
                      if (sumAmt!=0) { out.println(df.format(sumAmt)); } 
                      else { out.println("&nbsp;"); }
					  //sumAmt=sumAmt+rsTC.getInt("abhpam");
					  
          %>
            </font></div></td>
        <td colspan="2" bgcolor="#0000FF"> <div align="center"> <font color="#FFFF00"> 
            </font> </div></td>
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
