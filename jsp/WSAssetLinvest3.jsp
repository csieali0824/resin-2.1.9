<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat,ComboBoxBean"%>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSNetPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTechPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDistPoolPage.jsp"%>
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
<FORM ACTION="WSAssetLinvest3.jsp" METHOD="post" NAME="MYFORM">
  <div align="left">
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center">
            <p><strong><font color="#0000FF" size="+2" face="Arial">稽核表(資產和長期投資科目超過一佰萬)</font></strong>
<%
   int rs1__numRows = 20000;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //String colorStr = "";
   //
   //boolean getDataFlag = false;
 %>
            </p>
            </div></td>
      </tr>
    </table>
    
    <% 
     
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
       String comp=request.getParameter("COMP");   
	   
	   String sqlTC =""; 
	  String sqlGlobal = "";
	  dateBean.setAdjMonth(-1);
	  String DateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  String DateEnd=dateBean.getYearString()+dateBean.getMonthString()+"31";
	  
	  
	  
  %>
  </div>
  <table width="100%" height="45" border="1" cellpadding="0" cellspacing="0">
    <tr bgcolor="#FFFFFF"> 
      <td height="43" colspan="7" bordercolor="#000000"><font color="#330099" face="Arial Black"><strong>Bussiness 
        Unit:</strong></font> 
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select trim(MCCOMP),MCDESC from WSMULTI_COMP";		  
		  sWhere = " where mcstat=1 and mccomp between '01' and '18' order by MCCOMP";		 
		  sSql = sSql+sWhere;		  		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);		 		 
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(comp);
	      comboBoxBean.setFieldName("COMP");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      
		  statement.close();		         
         		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> <font color="#FF0066" face="Arial Black"><strong> 
        </strong></font> <input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSAssetLinvest3.jsp")'> 
      </td>
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
			   
			   out.println(comp)	 ; 
			  if(comp.equals("01" ) || comp.equals("03" ) || comp.equals("04" ) || comp.equals("08" ) ||comp==null)
			   { sqlTC =  "SELECT J.JXSG01,j.jxsg02 as acct,g.svldes as acctname,j.jbamt as beginamt,j.jxdram,j.jxcram,j.jeamt   "+" "+
                                 "FROM jou j,gsv g" ; 								 
                 String sWhereTC="    WHERE (j.jxsg02 = g.svsgvl AND g.svsgmn = 'ACCT' AND g.svid='SV')  "+" "+
                                               "AND (j.jxdram>=1000000 OR j.jxcram>=1000000)"+" "+
                                               "AND (j.jxyear = "+dateBean.getYear()+ "AND j.jxperd = "+dateBean.getMonth()+" )" +" "+
                                               "AND(( j.jxsg02 between 144100 and 145110) "+"  "+
                                               " OR(j.jxsg02 between 150100 and 159201 )) AND J.JXSG02[4]!=2  ";                                                 
                                               if (comp==null && comp.equals("--"))
											      {comp="01"; }
		                                 	   if (comp!=null && !comp.equals("--"))
		                                	   { sWhereTC = sWhereTC + "AND (j.jxsg01 ="+comp+") ";}
											 
			                                    String sOrderTC = "order by j.jxsg02";
												  sqlTC = sqlTC + sWhereTC + sOrderTC;
												  sqlGlobal = sqlTC;
					                              out.println(sqlTC); 
			   	                                     		     
			          }
			       else
			         { sqlTC =  "SELECT c.crsg01,c.crsg02 as acct,g.svldes as acctname,j.JXBAMT as beginamt,j.jxdram,j.jxcram,j.jxeamt   "+" "+
                                   "FROM jou2 j,gcr c,gsv g" ; 								 
                     String sWhereTC="   WHERE (j.jxldgr=c.crldgr AND j.jxian=c.crian AND c.crid='CR') "+" "+
                                               "AND (c.crsg02 = g.svsgvl AND g.svsgmn = 'ACCT01' AND g.svid='SV')"+" "+
											   "AND (j.jxdram>=1000000 OR j.jxcram>=1000000)"+"  "+
											   "AND (j.jxyear = "+dateBean.getYear()+ "AND j.jxperd = "+dateBean.getMonth()+" )" +" "+
                                               "AND(( c.crsg02 between 144100 and 145110) "+"  "+
                                               " OR(c.crsg02 between 150100 and 159201 AND c.crSG02[4]!=2)) ";                                                 
                                               if (comp==null && comp.equals("--"))
											      {comp="01" ; }
		                                 	   if (comp!=null && !comp.equals("--"))
		                                	   { sWhereTC = sWhereTC + "AND (c.crsg01 ="+comp+") ";}
											    String sOrderTC = "order by c.crsg02";
											   sqlTC = sqlTC + sWhereTC + sOrderTC;
											   sqlGlobal = sqlTC;
					                           out.println(sqlTC); 			                                   
		     			          }
							Statement statementTC=null;     
    						ResultSet rsTC=null;		       
							out.println(comp)	 ;        
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
						  else 
			              {statementTC=ifxdbgroupcon.createStatement(); 
						   rsTC=statementTC.executeQuery(sqlTC);  			 }
                          		  
			               while (rsTC.next()) 
		                     {		 	        		     		  
                      
					     
                 %>
   
  </table>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">
    <tr bgcolor="#006666"> 
      <td width="21%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"><strong>會計科目</strong></font></td>
      <td width="79%"  height="19" bgcolor="#6699FF" nowrap><font color="#FFFFFF" size="2"> 
        <div align="center"><strong>內容明細</strong></div>
        </font></td>
    </tr>
       <tr > 
         
      <td bordercolor="#FFFFCC" bgcolor="#FFFFCC"> <strong><font size="2" color="#000099"> 
        <% 
                     
					     out.println(rsTC.getString("acct")+rsTC.getString("acctname")); 
					     Bamt=rsTC.getInt("beginamt");                       
          %>
        </font></strong> </td>
      <td height="15"><font size="2"> 
        <table border="1" width="100%" height="100%" cellpadding="0" cellspacing="0">
          <tr bgcolor="#FFFFFE" > 
            <td width="14%"  height="5" nowrap><font color="#000000" size="2"><strong>日期</strong></font></td>
            <td width="10%"  height="5" nowrap><font color="#000000" size="2"><strong>傳票號 
              </strong></font></td>
            <td width="9%"  height="5" nowrap><font color="#000000" size="2"><strong>事件號</strong></font></td>
            <td width="36%"  height="5" nowrap><font color="#000000" size="2"><strong>摘要</strong></font></td>
            <td width="10%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>借方</strong></font></div></td>
            <td width="10%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>貸方</strong></font></div></td>
            <td width="11%"  height="5" nowrap><div align="right"><font color="#000000" size="2"><strong>餘額</strong></font></div></td>
          </tr>
          <%
                    			     
				    try
		            {  
                      String  sSqlL=""; 
				      String sWhereL=""; 
					   if(comp.equals("01" ) || comp.equals("03" ) || comp.equals("04" ) || comp.equals("08" ) ||comp==null)
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
					                  "AND (l.lhldgr=c.crldgr AND l.lhian=c.crian AND c.crid='CR') AND (c.crsg02=s.svsgvl AND s.svsgmn='ACCT' AND s.svid='SV') AND (j.jxldgr=c.crldgr AND j.jxian=c.crian )"+" "+
									  "AND (h.hhjdat  between " +DateBegin+ "AND  "+DateEnd+")  AND (j.jxyear = "+dateBean.getYear()+ " AND j.jxperd = "+dateBean.getMonth()+ " ) AND (J.JXDRAM>1000000 OR J.JXCRAM>1000000) "+" "+
									  "AND  c.crsg02="+rsTC.getString("acct")+"" ;    		              
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
						   else if (comp=="08" || comp.equals("08" ))
			              {docstatement=ifxdistcon.createStatement(); 
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
					    Camt=docrs.getInt("Camt");
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
                </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"><%=Date%>                
                </font></div></td>
            <td width="10%" rowspan="1"><div align="left"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Jno%>
                </font><font size="2"> </font></div></td>
            <td width="9%" rowspan="1"><div align="left"><font size="2"></font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Eno%>
                </font><font size="2"> </font></div></td>
            <td width="36%" rowspan="1"><div align="left"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=Des%>
                </font><font size="2"> </font></div></td>
            <td width="10%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%= Damt%>
                </font><font size="2"> </font></div></td>
            <td width="10%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%= Camt%>
                </font><font size="2"> </font></div></td>
            <td width="11%" rowspan="1"><div align="right"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=	Ramt%>
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
<%@include file="/jsp/include/ReleaseConnBPCSDbgroupPage.jsp"%>

<!--=================================-->
</html>
