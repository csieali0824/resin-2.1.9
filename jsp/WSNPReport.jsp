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
<FORM ACTION="WSNPReport.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> <font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
    </font> 
    <table width="100%" border="0">
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="3" face="Arial">Taipei 
            DBTEL Industry Co.,Ltd. </font></strong></div></td>
      </tr>
      <tr>
        <td><div align="center"><strong><font color="#0000FF" size="+1" face="Arial">每月應付票據總帳和明細帳差異表</font></strong> 
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
     
 
     
	  String Month=request.getParameter("Month");
	  String YEAR=request.getParameter("YEAR");
	  String sDateBegin=""; 
	  String sDateEnd=""; 
	  String sqlGlobal = "";
	  int sumAmt=0; 
	 
	   if (YEAR==null || YEAR== "" || YEAR.equals("")) 
	        {YEAR=dateBean.getYearString(); }
	   if (Month==null || Month== "" || Month.equals("")) 
	        {Month=dateBean.getMonthString(); }
			//out.println(TYPE+DATE+DATE2); 
		
		int nMonth=Integer.parseInt(Month);
		//out.println(nMonth)	; 
		
	    float Darm=0; 
		float Carm=0;    		
		float Damt=0; 
		float Camt=0;    
		float  DRamt=0; 
		float  CRamt=0; 
		String vnd=""; 
		String event=""; 
		String pjno=""; 
		String njno=""; 
		String jno=""; 
		String jno2=""; 
		float SumCarm=0; 
		int MarrayIdx=0;
		int arrayIdx=0;
		int amharrayIdx=0; 
		int n=1;
		int trnn=0; 
		int MIN=0; 
		int linenum=0; 
		float Rate=0; 
		
	   
	   DecimalFormat df=new DecimalFormat(",000"); 
	   
     //if (TYPE==null || TYPE.equals("")) {  TYPE= "未兌現";}
    
	 
  %>   
    <table width="100%" border="1">
      <tr bgcolor="#0F87FF"> 
        <td><font color="#FFFF00"><strong>YEAR： 
          <input name="YEAR" type="text" size="10" 
		<% if (YEAR==null || YEAR== "" || YEAR.equals("")) 
		    { out.println("value="+dateBean.getYearString()); }
		   else  
		   { out.println("value="+YEAR); }																																							       		
		%>			
		>
          </strong></font> <font color="#FF0066" face="Arial Black">&nbsp;</font><font color="#FFFF00"><strong>MONTH： 
          <input name="Month" type="text" size="10" 
		<% if (Month==null || Month== "" || Month.equals("")) 
		    { out.println("value="+dateBean.getMonthString()); }
		   else  
		   { out.println("value="+Month); }																																							       		
		%>			
		>
          </strong></font> <font color="#FF0066" face="Arial Black">&nbsp;</font></td>
        <td> <div align="center"><font size="2" color="#000099"> 
            <input name="button" type="button" onClick='setSubmit("../jsp/WSNPReport.jsp")'  value="Query" >
            </font></div>
          <div align="center"><font color="#FFFF00"> </font></div></td>
      </tr>
    </table>
    <table width="100%" border="1">
      <tr> 
        <td colspan="7" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">分類帳</font></strong></font></div></td>
        <td colspan="2" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">明細帳</font></strong></font></div></td>
        <td colspan="2" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">差額</font></strong></font></div></td>
      </tr>
      <tr> 
        <td width="10%"  bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong>日期</strong></font></div></td>
        <td width="10%"  bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2">&nbsp;</font><font color="#FFFFFF" size="2"><strong>廠商</strong></font><font size="2"><strong></strong></font></div></td>
        <td width="10%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">EVENT</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">傳票號碼</font></strong></font></div></td>
        <td width="8%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">借方</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">貸方</font></strong></font></div></td>
        <td width="7%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">人工異動</font></strong></font></div></td>
        <td width="10%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">借方</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"> <div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">貸方</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">借方</font></strong></font></div></td>
        <td width="9%" bgcolor="#3300FF"><div align="center"><font color="#FFFFFF" size="2"><strong><font face="新細明體">貸方</font></strong></font></div></td>
      </tr>
      <%      
	     try
            {  if(nMonth<10)
		          {Month="0"+Month; }
               sDateBegin=YEAR+Month+"01"; 
		       sDateEnd=YEAR+Month+"31"; 
               Statement statementTC=bpcscon.createStatement();     
              
             
               String sqlTC = " SELECT c.crsg02,g.svldes,c.crsg05,h.hhjdat,h.hhtrno,l.lhjnln,l.lhldes,l.lhdram,l.lhcram,l.lhuser,l.lhjnen,h.hhldgr,h.hhbook,h.hhyear,h.hhperd,h.hhjnen,l.lhtrnn,h.hhcurr,h.hhrate"+" "+
			                           "FROM gsv g,gcr c,glh l,ghh h"+" ";
			    String sWhereTC = "WHERE (c.crsg02=g.svsgvl AND g.svsgmn='ACCT' AND g.svid='SV')" +" "+
			                           "AND (c.crian=l.lhian) AND (l.lhldgr=h.hhldgr AND l.lhbook=h.hhbook AND l.lhyear=h.hhyear AND l.lhperd=h.hhperd AND l.lhjnen=h.hhjnen)" +" "+
							            " AND h.hhyear="+YEAR+" and h.hhperd="+Month+"  AND (crsg02 BETWEEN '214100' AND '214100' )  ";
			 
			   String sOrderTC = " ORDER BY c.crsg02,h.hhjdat,h.hhtrno,l.lhjnln";			  	  			 
            			   sqlTC= sqlTC + sWhereTC+sOrderTC ;
			  
			  sqlGlobal = sqlTC;
              
			  //out.println(sqlTC);
              ResultSet rsTC=statementTC.executeQuery(sqlTC);	 
          
		      
			  		  
			  while (rsTC.next()) 
		     {			   
			    //out.println(pjno); 
			    //out.println(njno); 								
				
			    njno=rsTC.getString("hhjnen");  
				
				 if(!pjno.equals("") && !pjno.equals(njno))
			    {n=1; 
				 SumCarm=0; 
				 CRamt=0; }
											
				//out.println(pjno); 
			    
        %>
      <tr bordercolor="#0000FF" bgcolor="#FFFFFF"> 
        <td width="10%" height="23"> 
          <div align="center"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("hhjdat")!=null ) { out.println(rsTC.getString("hhjdat")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> </font></div></td>
        <td width="10%"><div align="center"><font size="2" color="#000099">&nbsp; 
            </font><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("crsg05")!=null ) { out.println(rsTC.getString("crsg05")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">&nbsp; 
            </font></div></td>
        <td> <div align="center"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("hhtrno")!=null ) { out.println(rsTC.getString("hhtrno")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> </font></div></td>
        <td> <div align="center"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("hhjnen")!=null ) { out.println(rsTC.getString("hhjnen")); } 
                      else { out.println("&nbsp;"); }
                  %>
            </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("lhdram")!=null ) 
					   {if (rsTC.getFloat("lhdram")>1000 || rsTC.getFloat("lhdram")<-1000)
					      {out.println(df.format(rsTC.getFloat("lhdram"))); }
						 else
						  {out.println(rsTC.getFloat("lhdram")); }
						  } 
                      else { out.println("&nbsp;"); }
                  %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <% 
                      if (rsTC.getString("lhcram")!=null ) 
					  { if (rsTC.getFloat("lhcram")>1000 || rsTC.getFloat("lhcram")<-1000)
					      {out.println(df.format(rsTC.getFloat("lhcram"))); }
						 else
						  {out.println(rsTC.getFloat("lhcram")); }} 
                      else { out.println("&nbsp;"); }
                  %>
            </font></div></td>
        <td><div align="center"><strong><font size="3" color="#FF0000"> 
            <%     trnn=rsTC.getInt("lhtrnn"); 
                      if (trnn==0)
				      { out.println("ˇ"); }
                      else { out.println("&nbsp;"); }
                  %>
            </font></strong></div></td>
        <%    
		         Darm= 0; 
			     Carm= 0; 
			     Darm= rsTC.getFloat("lhdram"); 
			     Carm= rsTC.getFloat("lhcram"); 
				 jno=rsTC.getString("hhjnen"); 							
				 jno2=jno.substring(0,2); 							
				 if(jno2.equals("EP") && trnn==0)			
				 {trnn=1; }
				 		
			     String  sqlTC2= "SELECT x.xrhvnd,x.xrhref,x.xrhsub,x.xrinvc,x.xrinv,xrgnn1 FROM gxr x" +" ";		  
		         String  sWhereTC2 = "WHERE x.xrldgr='"+rsTC.getString("hhldgr") +"'AND x.xrbook='"+rsTC.getString("hhbook")+"'AND x.xryear="+rsTC.getString("hhyear")+" AND x.xrperd="+rsTC.getString("hhperd")+" AND x.xrtrnn="+trnn+" AND x.xrjnen='"+rsTC.getString("hhjnen")+"' "; 					                 				              
							  /*  if( Carm!= 0 ) 
							   {sWhereTC2=sWhereTC2+"and x.xrhvnd='"+rsTC.getString("crsg05")+"'"; }            */   
		             sqlTC2 = sqlTC2+sWhereTC2;
					//out.println(sqlTC2);
					   Statement statementTC2=bpcscon.createStatement(); 
					   ResultSet rsTC2=statementTC2.executeQuery(sqlTC2);
					 
						
						//out.println(n); 
						
					   while (rsTC2.next())                     
		                  { 
						   
				%>
        <%             			  
                    try
                   {  
				       String  sSqlL=""; 
				       String sWhereL=""; 
					   //out.println(Darm); 
					   //out.println(Carm); 
					  
				      if((Darm>0 || Darm<0)  )
					  {
					   	Statement minStatement=bpcscon.createStatement();				 
				        ResultSet minRs=minStatement.executeQuery("select min(BLLNUM)-1 as min from gbl where blseq= '"+rsTC2.getString("xrgnn1") +"' and blpgm='"+rsTC2.getString("xrinv") +"'   and BLUS02='214100' ");
                         if (minRs.next())
				            {
				              MIN=minRs.getInt("min"); 	
							  linenum=rsTC.getInt("lhjnln") +MIN; 
							  //out.println(linenum); 						
				            }  				             
				            minRs.close();				 			 
				            minStatement.close();
                       sSqlL = "select  BLDRAT,BLLNUM from gbl  ";		  
		               //sWhereL = "where blseq=SEQNO and BLUS05=PAYTOFROM  and blseq= '"+rsTC2.getString("xrgnn1") +"' and blpgm='"+rsTC2.getString("xrinv") +"'  and BLUS05='"+rsTC.getString("crsg05") +"' and BLUS02='214100' ";					                 
					   sWhereL = "where  blseq= '"+rsTC2.getString("xrgnn1") +"' and blpgm='"+rsTC2.getString("xrinv") +"' and BLLNUM="+linenum+" and (BLUS02='214100' ) order by BLLNUM";					                 

					  }          
					   else if (Carm>0 || Carm<0 )
					  {    Statement McountStatement=bpcscon.createStatement();
					        String McutSql="Select count(*) FROM gcr c,glh l,ghh h WHERE  c.crian=l.lhian and  l.lhldgr=h.hhldgr AND l.lhbook=h.hhbook AND l.lhyear=h.hhyear AND l.lhperd=h.hhperd AND l.lhjnen=h.hhjnen AND  h.hhyear="+YEAR+" and h.hhperd="+Month+"  and (c.crsg02 BETWEEN '214100' AND '214100' ) and c.crsg05= '"+rsTC.getString("crsg05")+"' and h.hhtrno='"+rsTC.getString("hhtrno")+"'"; 				 
							ResultSet McountRs=McountStatement.executeQuery(McutSql);
							//out.println(McutSql); 

				             if (McountRs.next())
				            {
				              MarrayIdx=McountRs.getInt(1);
							  //out.println(MarrayIdx); 
				             }  				            														 
						
				            McountRs.close();				 			 
				            McountStatement.close();  
							
					        Statement amhcountStatement=bpcscon.createStatement();
					        String amhcutSql="Select count(*) FROM amh WHERE  amhvnd= "+rsTC2.getString("xrhvnd")+" and amhref="+rsTC2.getString("xrhref")+" and  AMHTDA="+rsTC.getString("hhjdat")+" "; 				 
							ResultSet amhcountRs=amhcountStatement.executeQuery(amhcutSql);
							//out.println(amhcutSql); 

				             if (amhcountRs.next())
				            {
				              amharrayIdx=amhcountRs.getInt(1);
							  //out.println(MarrayIdx); 
				             }  				            														 
						
				            amhcountRs.close();				 			 
				            amhcountStatement.close();  
					       
							sSqlL = "select abhpam  from amh " +" ";                                            		  
		                    sWhereL = "WHERE  amhvnd= "+rsTC2.getString("xrhvnd")+" and amhref="+rsTC2.getString("xrhref")+" "+
											  "and amhsub= "+rsTC2.getString("xrhsub")+" and AMHTDA BETWEEN  "+sDateBegin+"  AND  "+sDateEnd+"  "; 
											  
						}
							
		             sSqlL = sSqlL+sWhereL;
				 	//out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { Damt=0; 
					    Camt=0; 
						//out.println(Carm); 
					    if(Darm>0 || Darm<0)
					    {  					    
							 Rate=rsTC.getFloat("hhrate");				 
						 	Damt = docrs.getFloat("BLDRAT")*Rate; 	
						 }
						else if (Carm!=0)
					    { 						  
						  Camt = docrs.getFloat("abhpam"); }
							 if(MarrayIdx!=amharrayIdx )
						    {SumCarm=SumCarm+Carm; 
							  //out.println(SumCarm); 
							  } 
							  else
							  {SumCarm=Carm; }				
					 }
                     else
					 {Damt=0; 
					 Camt=0; }
                     docrs.close();
                     docstatement.close();     
					 
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }	
                     
                 %>
        <td> <div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
            </font><font size="2" color="#000099"> 
            <% 
                      if(Damt>0 || Damt<0)	
					      {out.println(df.format(Damt));}	
						  else 	
					      {out.println("&nbsp;");}
                  %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <%    //out.println(MarrayIdx ); 
			         //out.println(n); 
					 //out.println(amharrayIdx ); 
						  
                      if((Camt>0 || Camt<0) )
					    {
						  if(MarrayIdx!=amharrayIdx && n==MarrayIdx )	
					      {out.println(df.format(Camt));}
						  else if (MarrayIdx==amharrayIdx)
						  {out.println(df.format(Camt));}							 						 
						  }
					  else 	
					      {out.println("&nbsp;");}
                  %>
            </font></div></td>
        <td> <div align="right"><font size="2" color="#000099"> 
            <% 
                      if(Damt>0  || Damt<0 )	
					      {
						    DRamt=Darm-Damt; 
							if(DRamt>1000 || DRamt<-1000)							
							{out.println(df.format(DRamt));}
							else
							 {  if(DRamt==0 ||(DRamt<1 && DRamt>-1))
							     {out.println(0);}
							    else
							     {out.println(DRamt);}
							 }
							 }	
					 else 	
					      {out.println("&nbsp;");}
                  %>
            </font></div></td>
        <td><div align="right"><font size="2" color="#000099">&nbsp; 
            <%      if((Camt>0 || Camt<0  ) )	
					    {
						  if(MarrayIdx!=amharrayIdx && n==MarrayIdx)
						     {  CRamt=SumCarm-Camt; 
							     if(CRamt>1000 || CRamt<-1000)								 
								  {out.println(df.format(CRamt));}
								 else
								 { if(CRamt==0 || (CRamt<1 && CRamt>-1))
							       {out.println(0);}
							         else
							        {out.println(CRamt);}
							    }
								}	
						     else if(MarrayIdx==amharrayIdx)	
					         {  CRamt=SumCarm-Camt; 
							     if(CRamt>1000 || CRamt<-1000)								 
								  {out.println(df.format(CRamt));}
								  else
								  {out.println(CRamt);}
							  }						 
						 }
				  	else 	
					      {out.println("&nbsp;");}
                  %>
            </font></div></td>
      </tr>
      <%     n=n+1     ; 
	            //SumCarm=0; 
	            }//end of while	  			  
	             
	                rsTC2.close();
	               statementTC2.close();  
				   
				   pjno=njno; 
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
    
	
    <p>
<input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
    </p>
  </div>
  <p>
   
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
