<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="DateBean,java.text.DecimalFormat,ComboBoxBean"%>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSNetPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTechPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSMicroPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSAresPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbintPoolPage.jsp"%>
<%@include file="/jsp/include/ConnBPCSDbgroupPoolPage.jsp"%>

<!--=============以下區段為處理開始==========-->
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
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
<FORM ACTION="WSAssetComp2.jsp" METHOD="post" NAME="MYFORM">
  <div align="left">
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center">
            <p><strong><font color="#0000FF" size="+2" face="Arial">稽核表(固定資產和長期投資科目超過一佰萬)</font></strong> 
              <%
   int rs1__numRows = 20000;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;  
 %>
            </p>
            </div></td>
      </tr>
    </table>
    
    <% 
     	    DecimalFormat df=new DecimalFormat(",000"); 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
       //String comp=request.getParameter("COMP");   
	   String account=""; 
	   String sqlTC =""; 
	  String sqlGlobal = "";
	  dateBean.setAdjMonth(-1);
	  String DateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  String DateEnd=dateBean.getYearString()+dateBean.getMonthString()+"31";
	  
	
	  
  %>
  <% try
         {   
		  String sSql = "";
		  String sWhere = "";		  
		  
		  sSql = "select trim(MCCOMP),MCDESC from WSMULTI_COMP";		
		  //sWhere = " where (trim(mccomp) in ('01' , '28'))  order by MCCOMP";
  
		  sWhere = " where ((trim(mccomp) between '01' and '04' ) or (trim(mccomp) between '05' and '13' ) or (trim(mccomp) between '16' and '17' )"+""+
		                   " or (trim(mccomp) between '23' and '28' ) or (trim(mccomp) between '41' and '43' )  or (trim(mccomp) between '52' and '55' ) or trim(mccomp) in ('21') )"+ "order by MCCOMP";
		  sSql = sSql+sWhere;		 
		  Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  while (rs.next())
          {  String comp=rs.getString(1); 
		      
		  %>
  </div>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">
    <%  /*StringBuffer stbuff = new StringBuffer();
          stbuff.append("<table>")	
          stbuff.append("</table>")
          String s = "";        
        BufferedReader htmlbr = new BufferedReader(new StringReader(stbuff.toString()));
        PrintWriter outpw = new PrintWriter(new BufferedWriter(new FileWriter("C:\\Linda111.html")));
        int lineCount = 1;
        while((s = htmlbr.readLine()) != null )
        outpw.println(s);
        outpw.close();*/
		%>
    <tr bgcolor="#FFFFA8"> 
      <td width="134"  height="19" nowrap bordercolor="#CCCCCC"> <div align="left"><font size="3"><strong><font color="#0000FF">公司別</font></strong> 
          </font></div></td>
      <td nowrap bordercolor="#FFFFA8" bgcolor="#FFFFA8"> <strong><font color="#000000" size="3"> 
        <%       
						   out.println(comp); out.println(rs.getString(2)); 					                       
          %>
        </font></strong></td>
      <td nowrap bordercolor="#FFFFA8" bgcolor="#FFFFA8">&nbsp;</td>
      <td colspan="3" nowrap bordercolor="#FFFFA8" bgcolor="#FFFFA8">&nbsp;</td>
      <td nowrap bordercolor="#FFFFA8">&nbsp;</td>
    </tr>
    <%      
	     try
            { 
               int Bamt=0; 
			   int Damt=0; 
			   int Camt=0; 
			   int Ramt=0; 
			   String Date=""; 
			   String Jno=""; 
			   String Eno=""; 
			   String Des=""; 

			  //out.println(comp)	 ; 
			  if(comp.equals("01") || comp.equals("03") || comp.equals("04") || comp.equals("08") || comp.equals("23") || comp==null)
			   { sqlTC =  "SELECT J.JXSG01,j.jxsg02 as acct,g.svldes as acctname,j.jbamt as beginamt,j.jxdram as tdamt,j.jxcram as tcamt,j.jeamt as eamt   "+" "+
                                 "FROM jou j,gsv g" ; 								 
                 String sWhereTC="    WHERE (j.jxsg02 = g.svsgvl AND g.svsgmn = 'ACCT' AND g.svid='SV')  "+" "+
                                               "AND (j.jxdram>=1000000 OR j.jxcram>=1000000)"+" "+
                                               "AND (j.jxyear = "+dateBean.getYear()+ "AND j.jxperd = "+dateBean.getMonth()+" )" +" "+
                                               "AND(( j.jxsg02 between 140000 and 149999) "+"  "+
                                               " OR(j.jxsg02 between 150000 and 159999 )) AND J.JXSG02[4]!=2  ";                                                 
                                               if (comp==null && comp.equals("--"))
											      {comp="01"; }
		                                 	   if (comp!=null && !comp.equals("--"))
		                                	   { sWhereTC = sWhereTC + "AND (j.jxsg01 ="+comp+") ";}
											 
			                                    String sOrderTC = "order by j.jxsg02";
												  sqlTC = sqlTC + sWhereTC + sOrderTC;
												  sqlGlobal = sqlTC;
					                              //out.println(sqlTC); 
			   	                                     		     
			          }
			       else
			         { sqlTC =  "SELECT c.crsg01,c.crsg02 as acct,g.svldes as acctname,j.JXBAMT as beginamt,j.jxdram as tdamt,j.jxcram as tcamt,j.jxeamt  as eamt "+" "+
                                   "FROM jou2 j,gcr c,gsv g" ; 								 
                     String sWhereTC="   WHERE (j.jxldgr=c.crldgr AND j.jxian=c.crian AND c.crid='CR') "+" "+
                                               "AND (c.crsg02 = g.svsgvl  AND g.svid='SV')"+" "+
											   "AND (j.jxdram>=1000000 OR j.jxcram>=1000000)"+"  "+
											   "AND (j.jxyear = "+dateBean.getYear()+ "AND j.jxperd = "+dateBean.getMonth()+" )" +" "+
                                               "AND(( c.crsg02 between 140000 and 149999) "+"  "+
                                               " OR(c.crsg02 between 150000 and 159999 AND c.crSG02[4]!=2)) ";                                                 
                                               if (comp==null && comp.equals("--"))
											      {comp="01" ; }
		                                 	   if (comp!=null && !comp.equals("--"))
		                                	   { sWhereTC = sWhereTC + "AND (c.crsg01 ="+comp+") ";}
											    String sOrderTC = "order by c.crsg02";
											   sqlTC = sqlTC + sWhereTC + sOrderTC;
											   sqlGlobal = sqlTC;
					                           //out.println(sqlTC); 			                                   
		     			          }
							Statement statementTC=null;     
    						ResultSet rsTC=null;		       
							//out.println(comp)	 ;        
					       if (comp=="01" || comp.equals("01" ))
			              {statementTC=bpcscon.createStatement(); 
						    rsTC=statementTC.executeQuery(sqlTC);  			 }
						   else if (comp=="03" || comp.equals("03" ))
			              {statementTC=ifxnetcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						   else if (comp=="04"|| comp.equals("04" ))
			              {statementTC=ifxtechcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						   else if (comp=="08" || comp.equals("08" ))
			              {statementTC=ifxdistcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						   else if (comp=="23" || comp.equals("23" ))
			              {statementTC=ifxmicrocon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						  else if (comp=="28" || comp.equals("28" ))
			              {statementTC=ifxarescon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						   else if (comp=="54" || comp.equals("54" ))
			              {statementTC=ifxdbintcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
						  else 
			              {statementTC=ifxdbgroupcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
                          		  
			               while (rsTC.next()) 
		                     {		 	        		     		  
           
					     
                 %>
    <tr bgcolor="#FDC6FF"> 
      <td  height="19" nowrap bordercolor="#CCCCCC" bgcolor="#FFDFFF"> <div align="left"><font color="#0000FF" size="3"><strong>會計科目 
          </strong></font></div></td>
      <td  height="19" colspan="3" nowrap bordercolor="#FFDFFF" bgcolor="#FFDFFF"><font color="#FF3300" size="3"> 
        <% 
                         account=rsTC.getString("acct"); 
					     out.println(rsTC.getString("acct")+rsTC.getString("acctname")); 
					     Bamt=rsTC.getInt("beginamt");                       
          %>
        </font> <div align="right"><strong><font color="#0000FF" size="2"> </font></strong></div></td>
      <td  height="19" nowrap bordercolor="#FFDFFF" bgcolor="#FFDFFF">&nbsp;</td>
      <td  height="19" nowrap bordercolor="#FFDFFF" bgcolor="#FFDFFF">&nbsp;</td>
      <td  height="19" nowrap bordercolor="#FFDFFF" bgcolor="#FFDFFF">&nbsp;</td>
    </tr>
    <tr > 
      <td height="15" colspan="7"><font size="2"> 
        <table border="1" width="100%" height="100%" cellpadding="0" cellspacing="0">
          <tr bgcolor="#FFFFFE" > 
            <td width="14%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>日期</strong></font></div></td>
            <td width="10%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>傳票號 
                </strong></font></div></td>
            <td width="9%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>事件號</strong></font></div></td>
            <td width="36%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>摘要</strong></font></div></td>
            <td width="10%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>借方</strong></font></div></td>
            <td width="10%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>貸方</strong></font></div></td>
            <td width="11%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>餘額</strong></font></div></td>
          </tr>
          <%
                    			     
				    try
		            {  
                      String  sSqlL=""; 
				      String sWhereL=""; 
					   if(comp.equals("01" ) || comp.equals("03" ) || comp.equals("04" ) || comp.equals("08" ) || comp.equals("23" ) ||comp==null)
                     {  sSqlL = "SELECT h.hhjdat as date,l.lhjnen as jnen,h.hhtrno as trno,l.lhldes as des,l.lhdram as damt,l.lhcram as camt FROM glh l,ghh h,gcr c,gsv s,jou j  ";		  
		              sWhereL = "WHERE (l.lhldgr=h.hhldgr AND l.lhbook=h.hhbook AND l.lhyear=h.hhyear AND l.lhperd=h.hhperd AND l.lhjnen=h.hhjnen AND l.lhid='LH' AND h.hhid='HH') "+" "+
					                  "AND (l.lhldgr=c.crldgr AND l.lhian=c.crian AND c.crid='CR') AND (c.crsg02=s.svsgvl AND s.svsgmn='ACCT' AND s.svid='SV') "+" "+
									  "AND (h.hhjdat  between " +DateBegin+ "AND  "+DateEnd+")  AND (j.jxyear = "+dateBean.getYear()+ " AND j.jxperd = "+dateBean.getMonth()+ " ) AND (J.JXDRAM>1000000 OR J.JXCRAM>1000000)"+" "+
									  "AND j.jxsg02=c.crsg02  AND c.crsg02="+"'"+rsTC.getString("acct")+" ' ";    		              
		              sSqlL = sSqlL+sWhereL;
					  }
					  else 					 
                     {  sSqlL = "SELECT h.hhjdat as date,l.lhjnen as jnen,h.hhtrno as trno,l.lhldes as des,l.lhdram as damt,l.lhcram as camt FROM glh l,ghh h,gcr c,gsv s,jou2 j ";		  
		              sWhereL = "WHERE (l.lhldgr=h.hhldgr AND l.lhbook=h.hhbook AND l.lhyear=h.hhyear AND l.lhperd=h.hhperd AND l.lhjnen=h.hhjnen AND l.lhid='LH' AND h.hhid='HH') "+" "+
					                  "AND (l.lhldgr=c.crldgr AND l.lhian=c.crian AND c.crid='CR') AND (c.crsg02=s.svsgvl  AND s.svid='SV') AND (j.jxldgr=c.crldgr AND j.jxian=c.crian )"+" "+
									  "AND (h.hhjdat  between " +DateBegin+ "AND  "+DateEnd+")  AND (j.jxyear = "+dateBean.getYear()+ " AND j.jxperd = "+dateBean.getMonth()+ " ) AND (J.JXDRAM>1000000 OR J.JXCRAM>1000000) "+" "+
									  "AND  c.crsg02='"+rsTC.getString("acct")+"'" ;    		              
		              sSqlL = sSqlL+sWhereL;
					  }
					  Statement docstatement=null;     
                      ResultSet docrs=null;
					  //out.println(sSqlL);
					   if (comp=="01" || comp.equals("01" ))
			              {docstatement=bpcscon.createStatement();
                            docrs=docstatement.executeQuery(sSqlL);  			 }
						  else if (comp=="03" || comp.equals("03"))
			              {docstatement=ifxnetcon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }
						   else if (comp=="04"|| comp.equals("04" ))
			              {docstatement=ifxtechcon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }
						   else if (comp=="23" || comp.equals("23" ))
			              {docstatement=ifxmicrocon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }
						    else if (comp=="28" || comp.equals("28" ))
			              {docstatement=ifxarescon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }
						    else if (comp=="54" || comp.equals("54" ))
			              {docstatement=ifxdbintcon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }
						   else 
			              {docstatement=ifxdbgroupcon.createStatement(); 
						   docrs=docstatement.executeQuery(sSqlL);  			 }              
					 int n=0; 	          
                     while (docrs.next()) 
					 { //out.println(n); 					   					  
					    Date=docrs.getString("date");
						//out.println(Date);
					    Jno=docrs.getString("jnen"); 
					    Eno=docrs.getString("trno"); 
					    Des=docrs.getString("des");
					    Damt=docrs.getInt("damt");
					    Camt=docrs.getInt("camt");
					   if (Damt!=0)
					   { if (n==0)
					      { Ramt=Bamt+Damt; }
						  else
						   {Ramt=Ramt+Damt; }
					  } 
					   else if (Camt!=0)					  
					    { if (n==0)
					      { Ramt=Bamt-Camt; }
						  else
						   {Ramt=Ramt-Camt; }
						}
						//out.println(Ramt);                      
                 %>
          <tr bgcolor="#FFFFFF" > 
            <td width="14%" height="25" rowspan="1" nowrap> <div align="left"><font size="2"> 
                </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"><%=Date%> </font></div></td>
            <td width="10%" rowspan="1"><div align="left"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Jno%> </font><font size="2"> </font></div></td>
            <td width="9%" rowspan="1"><div align="left"><font size="2"></font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Eno%> </font><font size="2"> </font></div></td>
            <td width="36%" rowspan="1"><div align="left"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Des%> </font><font size="2"> </font></div></td>
            <td width="10%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <% 
			//out.println(Damt); 
			if (Damt>1000 || Damt>-1000)
		     {	  
			   out.println(df.format(Damt));	   		    
			 }
			else
	        {  out.println(Damt);}
			 if(Damt==0)
			 {  out.println(0);}
		   %>
                </font><font size="2"> </font></div></td>
            <td width="10%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <% 
			
			   if(Camt>1000 || Camt<-1000)
			   
			   {out.println(df.format(Camt));}		   
			   else 
			    if(Camt==0)	
				{out.println(0); }		   		   
				else
			    {out.println(Camt); }		   		    
				 		    
			
		   %>
                </font><font size="2"> </font></div></td>
            <td width="11%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <% 
			 
			   //out.println(ILQTY); 
			   if(Ramt>1000 || Ramt<-1000)			   
			     {out.println(df.format(Ramt));}		   		    
			   else 
			     {out.println(Ramt); }
			  if(Ramt==0)
			      {out.println(0); }
			 
		   %>
                </font><font size="2"> </font></div></td>
          </tr>
          <%        n++;                 
                      }  // End of subWhile
                     
                      docrs.close();
                      docstatement.close();       
                    } //end of try
                    catch (Exception e)
                    {
                     out.println("Exception:"+e.getMessage());
                    }   
                %>
        </table>
        </font></td>
    </tr>
    <tr bgcolor="#CCFFFF"> 
      <td  height="19" nowrap bordercolor="#CCFFFF" bgcolor="#CCFFFF"> <div align="right"><font color="#FF0000"></font></div>
        <div align="right"><font color="#FF0000"></font></div></td>
      <td width="97"  height="19" nowrap bordercolor="#CCFFFF" bgcolor="#CCFFFF">&nbsp;</td>
      <td width="85"  height="19" nowrap bordercolor="#CCFFFF" bgcolor="#CCFFFF">&nbsp;</td>
      <td width="345"  height="19" nowrap bordercolor="#CCFFFF" bgcolor="#CCFFFF"> 
        <div align="right"><font color="#FF0000"><strong>合計</strong></font></div></td>
      <td width="98" nowrap> <div align="right"><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
		
			   if(rsTC.getInt("tdamt")>1000 || rsTC.getInt("tdamt")<-1000)			   
			     {out.println(df.format(rsTC.getInt("tdamt")));}		   		 
			   else 
			    {out.println(rsTC.getInt("tdamt")); }
				
			 
		   %>
          </font><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td width="95" nowrap> <div align="right"><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
			
			   if(rsTC.getInt("tcamt")>1000 || rsTC.getInt("tcamt")<-1000)
			   {out.println(df.format(rsTC.getInt("tcamt")));}
			   else 
			    {out.println(rsTC.getInt("tcamt")); }		    
				
			
		   %>
          </font><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td width="107" nowrap> <div align="right"><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% 
			
			   if(rsTC.getInt("eamt")>1000 || rsTC.getInt("eamt")<-1000)
			    {out.println(df.format(rsTC.getInt("eamt")));}		   
			   else 			   
			     {out.println(rsTC.getInt("eamt")); }		    
			
		   %>
          </font><font color="#FF3300" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
    </tr>
    <%
              rs1__index++;		 
			
	         }//endwhile
               rsTC.close();
	          statementTC.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
    <%
	         }//endwhile
               rs.close();
	          statement.close();
         } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   
      %>
  </table>
  
  <p>
      <input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
    </p>
	</FORM>
    
    <p>&nbsp; </p>
  </body>
<!--=============以下區段為處理完成==========-->

<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSNetPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTechPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDistPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSMicroPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSAresPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbintPage.jsp"%>
<%@include file="/jsp/include/ReleaseConnBPCSDbgroupPage.jsp"%>

<!--=================================-->
</html>
