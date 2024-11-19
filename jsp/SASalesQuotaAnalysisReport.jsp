<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="QueryAllBean,ComboBoxAllBean,DateBean,ArrayComboBoxBean,MiscellaneousBean,java.text.DecimalFormat" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSTestPoolPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function wsRegionReportByModel(yearfr,monthfr,region)
{    
  subWin=window.open("WSForecastRegionRpt.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&REGION="+region,"subwin","width=800,height=650,scrollbars=yes,menubar=no");  
}
function wsCountryReportByModel(yearfr,monthfr,region,locale)
{   
  subWin=window.open("WSForecastCountryRpt.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&REGION="+region+"&LOCALE="+locale,"subwin","width=800,height=650,scrollbars=yes,menubar=no");  
}
function wsColorReportByModel(yearfr,monthfr,region,locale)
{   
  subWin=window.open("WSForecastColorRpt.jsp?YEARFR="+yearfr+"&MONTHFR="+monthfr+"&REGION="+region+"&LOCALE="+locale,"subwin","width=800,height=650,scrollbars=yes,menubar=no");  
}

function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="queryAllBean" scope="application" class="QueryAllBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="adjDateBean" scope="page" class="DateBean"/>
<jsp:useBean id="miscellaneousBean" scope="page" class="MiscellaneousBean"/>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Monthly Forecast Inquiry</title>
</head>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<body>
<FORM ACTION="../jsp/sasalesquotaanalysisreport.jsp" METHOD="post" NAME="MYFORM">
<font color="#54A7A7" size="+2" face="Arial Black"><strong><em>DBTEL</em></strong></font>
<strong><font color="#000000" size="+2">業務員地區銷售業績達成率報表</font></strong>
<%
   int rs1__numRows = 60;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
   float      fUsdAmt1=0,fUsdAmt2=0,fUsdAmt3=0,fUsdAmt4=0,fUsdAmt5=0,fUsdAmt6=0,fUsdAmt7=0,fUsdAmt8=0,fUsdAmt9=0,fUsdAmt10=0,fUsdAmt11=0,fUsdAmt12=0;
   double  dNtdAmt=0,dAmt=0;
   double  dUsdRate1=0,dUsdRate2=0,dUsdRate3=0,dUsdRate4=0,dUsdRate5=0,dUsdRate6=0;
   double  dUsdRate7=0,dUsdRate8=0,dUsdRate9=0,dUsdRate10=0,dUsdRate11=0,dUsdRate12=0;
   DecimalFormat df=new DecimalFormat(",000"); //做為輸出數字時有,的輸出物件
   double aRate[][]=new double[12][2];
   /*
   String Quota[]={"--","--","--","--","--","--","--","--","--","--","--","--"};
   float fQuota[] ={0,0,0,0,0,0,0,0,0,0,0,0};
   double aRate[][]=new double[12][2];
   float aOrder[] ={0,0,0,0,0,0,0,0,0,0,0,0};
   float aORate[]={0,0,0,0,0,0,0,0,0,0,0,0};
   String aORateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
   float aShip[] ={0,0,0,0,0,0,0,0,0,0,0,0};
   float aSRate[]={0,0,0,0,0,0,0,0,0,0,0,0};
   String aSRateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
   float aAR[] ={0,0,0,0,0,0,0,0,0,0,0,0};
   float aARRate[]={0,0,0,0,0,0,0,0,0,0,0,0};
   String aARRateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
   */
%>

  <A HREF="/wins/WinsMainMenu.jsp">回首頁</A>   
<%         
  String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
  String compNo=request.getParameter("COMPNO");
  String dept=request.getParameter("DEPT");
  String salesNo=request.getParameter("SALESNO");
  String locale=request.getParameter("LOCALE");
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");   
  String model=request.getParameter("MODEL");   
  String yearMonthString[][]=new String[12][2]; //做為存入year及month陣列  
  
  if (YearFr==null || YearFr.equals("") || YearFr.equals("--") )
  {YearFr=dateBean.getYearString();}

  if (MonthFr==null || MonthFr.equals("") || MonthFr.equals("--") )
  {MonthFr=dateBean.getMonthString();}
  
  int numRow = 0;
  
  String dateYearCurr = dateBean.getYearString();
  String dateMonCurr = dateBean.getMonthString();
  String yearCH = "";
  String monCH = "";
  int yearNext = 0;
  if (YearFr != null && MonthFr != null)
  {yearCH = YearFr ;
    monCH = MonthFr; }  
   
  int yearMonCurr =  Integer.parseInt(dateYearCurr +  dateMonCurr); 
  int yearMonCH = Integer.parseInt(yearCH +  monCH);  
 
  String fmPrjCode = "";
  
  int monCurr = 0;
  int monNext =  0;
  int monNext2 = 0;
  
  if ( (MonthFr== null) || MonthFr.equals(""))
  {
  } else {
      monCurr = Integer.parseInt(MonthFr);   // 若選擇的月份小於等於10月
	  if (monCurr <= 10)
	  {
	    monNext = Integer.parseInt(MonthFr) + 1;
        monNext2 = Integer.parseInt(MonthFr) + 2; 
	  } else {
	     if (monCurr == 11)
		  { monNext =12;
		     monNext2 = 1;
	      } else{ 
		    monNext =1;
		    monNext2 =2;
          }      
	  }  
  }
	
	if ( YearFr != null || !YearFr.equals("--") ) 
	{
	   if ( MonthFr!= null || !MonthFr.equals("")) 
	   {
	     adjDateBean.setDate(Integer.parseInt(YearFr),Integer.parseInt(MonthFr),1);
	   } else {
	     adjDateBean.setDate(Integer.parseInt(YearFr),dateBean.getMonth(),1);
	   }
	} else {
	   if ( MonthFr!= null || !MonthFr.equals("")) 
	   {
	     adjDateBean.setDate(dateBean.getYear(),Integer.parseInt(MonthFr),1);
	   } else {
	      adjDateBean.setDate(dateBean.getYear(),dateBean.getMonth(),1); 
	   }
	} //end of YearFr about to Set WorkingBean if		
	
 %>
  <table width="100%" border="0">
    <!--DWLayoutTable-->
    <tr bgcolor="#D0FFFF"> 
      <td width="349" height="23" valign="top" bordercolor="#FFFFFF"> <p><font color="#330099" face="Arial Black"><strong>業務員組織</strong></font> 
      <% 
		 
		 Statement statement=ifxTestCon.createStatement();
          ResultSet rs=null;
		  
		 String DEPT="";		 		 
	     try
         {   
		      String sSql = "";
		      String sWhere = "";
		      sSql ="select distinct  trim(a.BUSI)||trim(a.DEPT) as DEPT,trim(a.BUSI)||trim(a.DEPT)||' ('||d.SVLDES||')'  from ac3 a,gsvbu b,gsvdept d ";
		      sWhere ="where a.BUSI !='' and a.DEPT !='' and a.BUSI=b.SVSGVL and a.DEPT=d.SVSGVL "+
		                     "and a.BUSI IN('0','1') and a.DEPT IN('09','13')";		 
		      sSql = sSql+sWhere;		  
		  		      
		      rs=statement.executeQuery(sSql);
		  
		      out.println("<select NAME='DEPT' onChange='setSubmit("+'"'+"../jsp/sasalesquotaanalysisreport.jsp"+'"'+")'>");
		      out.println("<OPTION VALUE=-->ALL");     
		      while (rs.next())
		        {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(dept)) 
  		          {
                     out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                  } else {
                     out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		        } //end of while
		      out.println("</select>"); 	  		  		  
		      rs.close();        	 
         } //end of try		 
         catch (Exception e) { out.println("Exception:"+e.getMessage()); }
       %>
      </td>
      <td width="258" valign="top"><font color="#333399" face="Arial Black"><strong>業務員</strong></font> 
      <% 
		 String SALESNO="";		 		 
	     try
           {   
		     String sSql = "";
		     String sWhere = "";		  

			 sSql ="select SSAL as SALESNO,SSAL||' ('||SNAME||')'  from SSM ";
			 sWhere ="where SMFAXN !='' and SID = 'SM' and trim(SZIP)='"+dept+"'  and SZIP !='' ";
		     sSql = sSql+sWhere;
		     //out.println(sSql);		      
             rs=statement.executeQuery(sSql);
		  
		     out.println("<select NAME='SALESNO' >");
		     out.println("<OPTION VALUE=-->ALL");     
		     while (rs.next())
		       {            
		          String s1=(String)rs.getString(1); 
		          String s2=(String)rs.getString(2); 
                        
		          if (s1.equals(salesNo)) 
		           {
                      out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
		           } else {
                      out.println("<OPTION VALUE='"+s1+"'>"+s2);
                  }        
		       } //end of while
		     out.println("</select>"); 	  		  		  
       
             rs.close();        	 
           } //end of try
	     catch (Exception e) {out.println("Exception:"+e.getMessage());	}
      %> 
	  </td>
      <td width="132" valign="top"><font color="#333399" face="Arial Black">單位/幣別<br>
      <font color="#CC3366">K</font> / <font color="#CC3366">USD</font></font></td>
      </tr>
    <tr bgcolor="#D0FFFF"> 
      <td height="23" valign="top"><font color="#333399" face="Arial Black"><strong>年</strong></font> 
        <%
		     String CurrYear = null;	     		 
	         try
              {       
                 String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
                 arrayComboBoxBean.setArrayString(a);
                 if (YearFr==null)
                  {
                    CurrYear=dateBean.getYearString();
                    out.println(CurrYear);
                    arrayComboBoxBean.setSelection(CurrYear);
                  }  else {
                    arrayComboBoxBean.setSelection(YearFr);
                 }
                 arrayComboBoxBean.setFieldName("YEARFR");	   
                 out.println(arrayComboBoxBean.getArrayString());		      		 
              } //end of try
	         catch (Exception e) {out.println("Exception:"+e.getMessage());}
      %> </td>
      <td valign="top"> <font color="#330099" face="Arial Black"><strong>月</strong></font> 
        <%
		     String CurrMonth = null;	     		 
	         try
              {       
                 String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
                 arrayComboBoxBean.setArrayString(b);
                 if (MonthFr==null)
                  {
                     CurrMonth=dateBean.getMonthString();
                     out.println(CurrMonth);
                     arrayComboBoxBean.setSelection(CurrMonth);
                  } else 	{
		             arrayComboBoxBean.setSelection(MonthFr);
		         }
                 arrayComboBoxBean.setFieldName("MONTHFR");	   
                 out.println(arrayComboBoxBean.getArrayString());		      		 
              } //end of try
	         catch (Exception e) {out.println("Exception:"+e.getMessage());}
       %> 
	  </td>
      <td valign="top"><input name="submit1" type="submit" value="查詢"></td>
    </tr>
  </table>
<table width="100%" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#FFFFFF">
  <tr>
      <td width="5%" bgcolor="#33CC99" nowrap><font size="2" color="#FFFFFF"><strong>業務員</strong></font></td>	        	  
	  <!--%<td width="5%" bgcolor="#FFFFCC" nowrap><font size="2"><input name="COLOR" type="checkbox" value="" checked>Color</font></td>%-->
	  <td width="5%" bgcolor="#33CC99"  nowrap><font size="2" color="#FFFFFF"><strong>項目</strong></font></td>
      <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(-11);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[0][0] = adjDateBean.getYearString();yearMonthString[0][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[1][0] = adjDateBean.getYearString();yearMonthString[1][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[2][0] = adjDateBean.getYearString();yearMonthString[2][1]= adjDateBean.getMonthString();%></font></div></td>
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[3][0] = adjDateBean.getYearString();yearMonthString[3][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[4][0] = adjDateBean.getYearString();yearMonthString[4][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[5][0] = adjDateBean.getYearString();yearMonthString[5][1]= adjDateBean.getMonthString();%></font></div></td>  
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[6][0] = adjDateBean.getYearString();yearMonthString[6][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[7][0] = adjDateBean.getYearString();yearMonthString[7][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[8][0] = adjDateBean.getYearString();yearMonthString[8][1]= adjDateBean.getMonthString();%></font></div></td>
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[9][0] = adjDateBean.getYearString();yearMonthString[9][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#FFFFCC" width="3%"><div align="center"><font size="2"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[10][0] = adjDateBean.getYearString();yearMonthString[10][1]= adjDateBean.getMonthString();%></font></div></td> 
	  <td colspan="1" bgcolor="#CC3366"width="3%"><div align="center"><font size="2"  color="#FFFFFF"><% adjDateBean.setAdjMonth(1);
	                                                                                                                                                  out.println(adjDateBean.getYearString()+"/"+adjDateBean.getMonthString());
																																					  yearMonthString[11][0] = adjDateBean.getYearString();yearMonthString[11][1]= adjDateBean.getMonthString();%></font></div></td>																																		  
  </tr>
      <%
 	  	   try 
			{
               int i=0;
			    String sSqlCountCurr="select Count(*) as COUNT from gcm where CCMID='CM' ";
				PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlCountCurr);
				ResultSet rsCountCurr=pt.executeQuery();
				if (rsCountCurr.next())
				 {
				    i=rsCountCurr.getInt("COUNT");
				 }
				rsCountCurr.close();
	 			pt.close();
 
 				String aCurr[]=new String [i];        
			    String sSqlCurr="select CURCDE as CURR from gcm where CCMID='CM' ";
				pt=ifxDbtelcon.prepareStatement(sSqlCurr);
				ResultSet rsCurr=pt.executeQuery();
				if (rsCurr.next())
				 {
				   for (int j=0;j<aCurr.length;j++)
				    {
				       if  (rsCurr.next())
				          {
				            aCurr[j]=rsCurr.getString("CURR");
							out.println(aCurr[j]+"  ");
				          }
				    }//end of for
				 } // end of if
				rsCurr.close();
	 			pt.close();
/*
                float aAllRate[][]=[12][i];
				for (j=0;j < aAllRate.length;j++)
				  {
				    
				  }
                String sSqlAllCurr="select CURCDE from gcm where CCMID='CM' ";
				PreparedStatement pt=con.preparedStatement(sSqlAllRate);
				ResultSet rsAllCurr=pt.executeQuery();
				if (rsAllCurr.next())
				 {
				    aAllCurr[i]
				 }
				//將幣別年月之匯率塞到二維陣列
			    for (ll=0;ll<aCurrFr.length;ll++)
				 {
			        for (kk=0;kk<aRate.length;kk++)
					 {
				        String sSqlRate = "select c.CCNVFC from gcc c where c.GCCID='CC'  and c.CCRTYP='CUSTOM'  "+
				                                   "and c.CCNVDT between "+yearMonthString[kk][0]+yearMonthString[kk][1]+"01 and "+yearMonthString[kk][0]+yearMonthString[kk][1]+"10  "+
							    				   "and c.CCFRCR='"+aCurrFr[ll]+"'and c.CCTOCR='"+aCurrTo[ll]+"' "+
												   "and c.serialcolumn = (select Max(cc.serialcolumn) from gcc cc where c.serialcolumn=cc.serialcolumn and  cc.CCFRCR='"+aCurrFr[ll]+"' and cc.CCTOCR='"+aCurrTo[ll]+"' "+
												   "and cc.CCNVDT between "+yearMonthString[kk][0]+yearMonthString[kk][1]+"01 and "+yearMonthString[kk][0]+yearMonthString[kk][1]+"10  )"+
												   "group by CCNVDT,CCNVFC ";				
				        PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlRate);
						//out.println(sSqlRate);						  
				        ResultSet rsRate=pt.executeQuery();
				        if (rsRate.next())
				         {
						    aRate[kk][ll] =rsRate.getDouble("CCNVFC");
						   out.println(aRate[kk][ll]);
                         } else {
						   aRate[kk][ll] =0;
						   out.println(aRate[kk][ll]);
						}
						rsRate.close();
						pt.close();
						*/
			}//end of try
	       catch (Exception e) {out.println("Exception:"+e.getMessage());}
	  %>
	  <%
	  	   try 
			{
                int ll=0,kk=0;
                String aCurrFr[]={"USD","NTD"};
                String aCurrTo[]={"NTD","USD"};
				//將幣別年月之匯率塞到二維陣列
			    for (ll=0;ll<aCurrFr.length;ll++)
				 {
			        for (kk=0;kk<aRate.length;kk++)
					 {
				        String sSqlRate = "select c.CCNVFC from gcc c where c.GCCID='CC'  and c.CCRTYP='CUSTOM'  "+
				                                   "and c.CCNVDT between "+yearMonthString[kk][0]+yearMonthString[kk][1]+"01 and "+yearMonthString[kk][0]+yearMonthString[kk][1]+"10  "+
							    				   "and c.CCFRCR='"+aCurrFr[ll]+"'and c.CCTOCR='"+aCurrTo[ll]+"' "+
												   "and c.serialcolumn = (select Max(cc.serialcolumn) from gcc cc where c.serialcolumn=cc.serialcolumn and  cc.CCFRCR='"+aCurrFr[ll]+"' and cc.CCTOCR='"+aCurrTo[ll]+"' "+
												   "and cc.CCNVDT between "+yearMonthString[kk][0]+yearMonthString[kk][1]+"01 and "+yearMonthString[kk][0]+yearMonthString[kk][1]+"10  )"+
												   "group by CCNVDT,CCNVFC ";				
				        PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlRate);
						//out.println(sSqlRate);						  
				        ResultSet rsRate=pt.executeQuery();
				        if (rsRate.next())
				         {
						    aRate[kk][ll] =rsRate.getDouble("CCNVFC");
						   out.println(aRate[kk][ll]);
                         } else {
						   aRate[kk][ll] =0;
						   out.println(aRate[kk][ll]);
						}
						rsRate.close();
						pt.close();
					 }//end of for jj
				 }//end of for ii
			}//end of try
	       catch (Exception e) {out.println("Exception:"+e.getMessage());}
	   %>
	      
      <% //  *** Main Loop  Start   *** //      	              		
		try
		 { 
		   	Statement state=ifxTestCon.createStatement();
			String sSqlSales="select SSAL as SALESNO,SMFAXN[2,7] as SALESID,SNAME AS SNAME  from ssm ";
			String sWhereSales="where SID='SM' and SMFAXN !='' and SZIP != '' ";
				              
			if (dept==null || dept.equals("--")) {   sWhereSales = sWhereSales + "and SZIP !=  'ALL'  "; }
			else { sWhereSales =sWhereSales + "and SZIP=  '"+dept+"'  ";}		 		  
			if ( salesNo==null || salesNo.equals("--")) { sWhereSales = sWhereSales + "and SSAL != 0  ";}
			else { sWhereSales= sWhereSales +  "and SSAL= '"+salesNo+"'  "; }
			String sOrder = "ORDER BY SSAL";
		 
			sSqlSales =sSqlSales+ sWhereSales+sOrder;							  		   		
            ResultSet  rsssm=state.executeQuery(sSqlSales);
		    while (rsssm.next())
			  {
   %>
  <tr>
      <td nowrap rowspan="4"><font size="2" color="#000066"><strong>
        <% 
		     out.println(rsssm.getString("SALESNO"));
			 out.println("<br>");
		     out.println(rsssm.getString("SNAME"));
		%>
        </strong></font> </td>
	<td width="3%">
	     <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	      <tr>
            <td ><font color="#FF0000" size="2">額度</font> <font size="2" color="#FF0000">&nbsp;</font>
            </td>
		  </tr>
	    </table>
	</td> 
    <td width="3%">
	  <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	      <tr> 
            <td><font size="2" color="#FF0000">
			<%
			          String Quota[]={"--","--","--","--","--","--","--","--","--","--","--","--"};
			          float fQuota[] ={0,0,0,0,0,0,0,0,0,0,0,0};
			        //  double aRate[][]=new double[12][2];
			          String sSqlQuota ="select q1.FPYEAR||q1.FPMONTH as FDATE,q1.FSQUOTA as QUOTA from PSALES_HIRECHY_SQUOTA q1 "+
						   		                   "where q1.FPYEAR||q1.FPMONTH between "+yearMonthString[0][0]+yearMonthString[0][1]+" and "+yearMonthString[11][0]+yearMonthString[11][1]+""+
										       	   "and q1.FSALES='"+rsssm.getString("SALESID")+"' "+
												   "and q1.FPMVER = (select q2.FPMVER from  PSALES_HIRECHY_SQUOTA q2 where q1.FSALES=q2.FSALES "+
												   "and  q1.FPYEAR||q1.FPMONTH =q2.FPYEAR||q2.FPMONTH ) ";
			          //out.println(sSqlQuota+"<br>");						  
			          PreparedStatement ptcon=con.prepareStatement(sSqlQuota);						  
			          ResultSet rsQuota=ptcon.executeQuery();
			          if (rsQuota.next())
  			          {
					      for (int i=0;i < Quota.length;i++)
				           {
						      String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	                          if (yearmonthStr.equals(rsQuota.getString("FDATE")))
		                       {
		                           if (rsQuota.getString("QUOTA").equals("0") )
		                            {
		                              Quota[i]=rsQuota.getString("QUOTA");		   
		                            } else {
		                               if (rsQuota.getString("QUOTA").length()<3)
			                            {
			                               Quota[i]=rsQuota.getString("QUOTA");	
			                            } else {
		                                   Quota[i]=df.format(Integer.parseInt(rsQuota.getString("QUOTA")));	
			                            }
		                            }
		                       }
	                          if (!rsQuota.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop
				           }  // end of yearMonthSring for loop
  			          } //enf of subRs.next if
			          rsQuota.close(); 
			%> 
			<%=Quota[0]%>
			</font>
			</td>
          </tr>
	    </table>
	</td>
    <td width="3%">
	     <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	      <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[1]%></font> </td>
          </tr>
	    </table>
	</td>
    <td width="3%">
	      <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	      <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[2]%></font> </td>
          </tr>
		  </table>
	</td>
    <td width="3%">
	    <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	     <tr>
            <td><font size="2" color="#FF0000"><%=Quota[3]%></font> </td>
          </tr>
	    </table>
	</td>
    <td width="3%">
	    <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	     <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[4]%></font> </td>
          </tr>
	    </table>
	</td>
    <td width="3%">
	    <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	     <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[5]%></font> </td>
          </tr>
		</table>
	</td>
    <td width="3%">
	  <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[6]%></font> </td>
          </tr>
		</table>
	</td>
    <td width="3%">
	   <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[7]%></font> </td>
          </tr>
		</table>
	</td>
    <td width="3%">
	 <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[8]%></font> </td>
          </tr>
	 </table>
	</td>
    <td width="3%">
	  <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[9]%></font> </td>
          </tr>
	    </table>
	</td>
    <td width="3%">
	   <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[10]%></font> </td>
          </tr>
	   </table>
	</td>
	<td width="3%">
	 <table border="0" bgcolor="#CCFFFF" width="100%" height="100%">
	    <tr>
            <td><font size="2" color="#FF0000"> <%=Quota[11]%></font> </td>
        </tr>
	 </table> 
	</td>
	</tr>
	<td width="3%">
	     <table border="0" width="100%" height="100%">
		           <tr><td><font size="2">訂單金額</font></td></tr>
		            <tr><td><font size="2"><strong>達成率</strong></font></td></tr>
		 </table>
	</td> 
    <td width="3%">
	<table border="0" width="100%" height="100%">
		<tr>
            <td><font size="2"> 
			  <%
			       float aOrder[] ={0,0,0,0,0,0,0,0,0,0,0,0};
			       float aORate[]={0,0,0,0,0,0,0,0,0,0,0,0};
			       String aORateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
				/*   
			       String sSqlOrder="select h.HCURR as CURR,h.HEDTE as HDATE,h.HDTOT as AMT from ech h,rcm r "+
								               "where h.HCUST=r.CCUST and h.HEDTE between "+yearMonthString[0][0]+yearMonthString[0][1]+"01 "+
										       "and "+yearMonthString[11][0]+yearMonthString[11][1]+"31 and r.CSAL="+rsssm.getInt("SALESNO")+" order by 1,2";
			       PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlOrder);
                   ResultSet rsOrder=pt.executeQuery();
				   if (rsOrder.next())
				    {
					   for (int i=0;i < aOrder.length;i++)
				           {
						      String yearmonthStr=yearMonthString[i][0]+yearMonthString[i][1];
	                          if (yearmonthStr.equals(rsQuota.getString("FDATE")))
		                       {
							      if (rsOrder.getString("hedte").substring(0,6).equals(ym [i]) )
		                           if (rsQuota.getString("QUOTA").equals("0") )
		                            {
		                              Quota[i]=rsQuota.getString("QUOTA");		   
		                            } else {
		                               if (rsQuota.getString("QUOTA").length()<3)
			                            {
			                               Quota[i]=rsQuota.getString("QUOTA");	
			                            } else {
		                                   Quota[i]=df.format(Integer.parseInt(rsQuota.getString("QUOTA")));	
			                            }
		                            }
		                       }
	                          if (!rsQuota.next())  break; //若下一筆已沒有資料或已到結果集結束則離開loop

					}
				   
				   
				   */
				   
			       for (int i=0;i < aOrder.length;i++)
					 {   
					  String sSqlOrder="select h.HCURR as CURR,sum(h.HDTOT) as AMT from ech h,rcm r,gcc c "+
								                  "where h.HCUST=r.CCUST and h.HEDTE between "+yearMonthString[i][0]+yearMonthString[i][1]+"01 "+
										       	  "and "+yearMonthString[i][0]+yearMonthString[i][1]+"31 and r.CSAL="+rsssm.getInt("SALESNO")+" "+
											      "and c.GCCID='CC' and c.CCRTYP='CUSTOM' and h.HCURR=c.CCFRCR and c.CCTOCR='NTD' "+
											      "and c.CCNVDT between "+yearMonthString[i][0]+""+yearMonthString[i][1]+"01 and "+yearMonthString[i][0]+""+yearMonthString[i][1]+"10  "+
											      "group by h.HCURR,c.CCNVFC";
					  //out.println(sSqlOrder+"<br>");						  
					  PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlOrder);						  
					  ResultSet rsOrder=pt.executeQuery();
					  if (rsOrder.next())
					   {
					      while (rsOrder.next())
						     {
							    dAmt = 0;
						        if (rsOrder.getString("CURR")=="NTD") 
						        {
							       dAmt = 1 *  rsOrder.getFloat("AMT");
							    } else { 
								   dAmt =  rsOrder.getFloat("RATE") *  rsOrder.getFloat("AMT");
							    } //end of if
								
								out.println("dAmt"+dAmt);
							    aOrder[i]=aOrder[i] +  (float) dAmt ;
							 	out.println("i ="+i+"<br>"+aOrder[i]);
						     }//end of while
					      aOrder[i] = Math.round(aOrder[i]  / aRate[i][0] /1000);
					  } else {
					      aOrder[i]=0;
					  }
					  rsOrder.close();
					  pt.close();
					  //out.println("i="+i+"<br>");
					  //out.println((int) aOrder[i]);
					  //out.println("aRate[i][0]="+aRate[i][0]+"<br>");
					 }//end of for i
						  
			  %>
			  <%=(int) aOrder[0]%>
              </font> </td>
          </tr>
		  <tr>
            <td><font size="2"> 
              <%  	 		     
			           for (int i=0;i < aORate.length;i++)
					     {   
			              if (fQuota[i]>0)
			               {
                             aORate[i]= (aOrder[i] / fQuota[i])*100;
                             miscellaneousBean.setRoundDigit(2);
                             aORateStr[i] = miscellaneousBean.getFloatRoundStr(aORate[i]);
						   } else { }
			             // out.println(aORateStr[i] +"%");   
					    }
              %>
			  <%=aORateStr[0] +"%"%>
              </font></td>
          </tr>
		 </table>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aOrder[1]%></font> </td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aORateStr[1] +"%"%></font> </td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		   <tr>
            <td><font size="2"> <%=(int) aOrder[2]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aORateStr[2] +"%"%></font></td>
          </tr>
		 </table>
		 </font>	
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aOrder[3]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aORateStr[3] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"><%=(int) aOrder[4]%></font> </td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aORateStr[4] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           
          <tr> 
            <td><font size="2"><%=(int) aOrder[5]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aORateStr[5] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aOrder[6]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aORateStr[6] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"><%=(int) aOrder[7]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aORateStr[7] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		    <tr>
            <td><font size="2"> <%=(int) aOrder[8]%></font></td>
          </tr>
		    <tr>
            <td><font size="2"> <%=aORateStr[8] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aOrder[9]%></font></td>
          </tr>
		   <tr>
            <td><font size="2"> <%=aORateStr[9] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		    <tr>
            <td><font size="2"> <%=(int) aOrder[10]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aORateStr[10] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	<td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		  <tr>
            <td><font size="2"> <%=(int) aOrder[11]%></font></td>
          </tr>
		   <tr>
            <td><font size="2"> <%=aORateStr[11] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	</tr>
	<tr>
	<td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr><td><font size="2">出貨金額</font></td></tr>
		            <tr><td><font size="2"><strong>達成率</strong></font></td></tr>
		 </table>
	</td> 
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> 
              <%
			       float aShip[] ={0,0,0,0,0,0,0,0,0,0,0,0};
			       float aSRate[]={0,0,0,0,0,0,0,0,0,0,0,0};
			       String aSRateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
			       for (int i=0;i < aShip.length;i++)
					 {   
					  String sSqlShip="select h.SICURR as CURR,c.CCNVFC as RATE,sum(h.SITOT) as AMT from  sih h,rcm r,gcc c "+
								             "where h.SICUST=r.CCUST and h.SIINVD between "+yearMonthString[i][0]+""+yearMonthString[i][1]+"01 "+
											 "and "+yearMonthString[i][0]+""+yearMonthString[i][1]+"31 and r.CSAL="+rsssm.getInt("SALESNO")+" "+
											 "and c.GCCID='CC' and c.CCRTYP='CUSTOM' and h.SICURR=c.CCFRCR and c.CCTOCR='NTD' "+
											 "and c.CCNVDT between "+yearMonthString[i][0]+""+yearMonthString[i][1]+"01 and "+yearMonthString[i][0]+""+yearMonthString[i][1]+"10  "+
											 "group by h.SICURR,c.CCNVFC";
					  PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlShip);
					  //out.println(sSqlShip);						  
					  ResultSet rsShip=pt.executeQuery();
					  if (rsShip.next())
				       {
					      while (rsShip.next())
						     {
							    dAmt = 0;
						        if (rsShip.getString("CURR")=="NTD") 
						        {
							       dAmt = 1 *  rsShip.getFloat("AMT");
							    } else { 
								   dAmt =  rsShip.getFloat("RATE") *  rsShip.getFloat("AMT");
							    } //end of if
							    aShip[i]=aShip[i] +  (float) dAmt ;
								//out.println("i ="+i+"<br>"+aShip[i]);
						     }//end of while
					      aShip[i] = Math.round(aShip[i]  / aRate[i][0] /1000);
				       } // end of if
					   else {aShip[i]=0;}
					  rsShip.close();
					  pt.close();
					  //out.println((int) aShip[i]);
					 }//end of for i
						  
			  %>
              <%=(int) aShip[0]%> </font></td>
          </tr>
          <tr>
            <td><font size="2"> 
              <%  	 		     
			           for (int i=0;i < aSRate.length;i++)
					     {   
			              if (fQuota[i]>0)
			               {
                             aSRate[i]= (aShip[i] / fQuota[i])*100;
                             miscellaneousBean.setRoundDigit(2);
                             aSRateStr[i] = miscellaneousBean.getFloatRoundStr(aSRate[i]);
						   } else { }
			              //out.println(aSRateStr[i]  +"%");   
					    }
              %>
              <%=aSRateStr[0] +"%" %>
              </font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		    <tr>
            <td><font size="2"> <%=(int) aShip[1]%></font></td>
          </tr>
		   <tr>
            <td><font size="2"> <%=aSRateStr[1] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[2]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[2] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[3]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aSRateStr[3] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[4]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[4] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[5]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[5] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	    <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[6]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[6] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[7]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[7] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[8]%></font></td>
          </tr>
		            <tr>
            <td><font size="2"> <%=aSRateStr[8] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[9]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aSRateStr[9] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	<td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aShip[10]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aSRateStr[10] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	<td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		   <tr>
            <td><font size="2"> <%=(int) aShip[11]%></font></td>
          </tr>
	      <tr>
            <td><font size="2"> <%=aSRateStr[11] +"%" %></font></td>
          </tr>
		 </table>
		 </font>
	</td>
  </tr>
  <tr>
	<td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		           <tr><td><font size="2">收款金額</font></td></tr>
		            <tr><td><font size="2"><strong>達成率</strong></font></td></tr>
		 </table></font>
	</td> 
    <td width="3%"><font size="2">	  
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> 
              <%
			       float aAR[] ={0,0,0,0,0,0,0,0,0,0,0,0};
			       float aARRate[]={0,0,0,0,0,0,0,0,0,0,0,0};
			       String aARRateStr[]={"0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00","0.00"};
			       for (int i=0;i < aAR.length;i++)
					 {   
					  String sSqlAR="select a.RCURR as CURR,c.CCNVFC as RATE,sum(a.RAMT)*-1 as AMT from  rar a,rcm r,gcc c "+
								             "where a.RRID in('RP','RC') and a.RCUST=r.CCUST and a.RDATE between "+yearMonthString[i][0]+""+yearMonthString[i][1]+"01 "+
											 "and "+yearMonthString[i][0]+""+yearMonthString[i][1]+"31 and r.CSAL="+rsssm.getInt("SALESNO")+" "+
											 "and c.GCCID='CC' and c.CCRTYP='CUSTOM' and a.RCURR=c.CCFRCR and c.CCTOCR='NTD' "+
											 "and c.CCNVDT between "+yearMonthString[i][0]+""+yearMonthString[i][1]+"01 and "+yearMonthString[i][0]+""+yearMonthString[i][1]+"10  "+
											 "group by a.RCURR,c.CCNVFC";
					  PreparedStatement pt=ifxDbtelcon.prepareStatement(sSqlAR);						  
					  ResultSet rsAR=pt.executeQuery();
					  if (rsAR.next())
				       {
					      while (rsAR.next())
						     {
							    dAmt = 0;
						        if (rsAR.getString("CURR")=="NTD") 
						        {
							       dAmt = 1 *  rsAR.getFloat("AMT");
							    } else { 
								   dAmt =  rsAR.getFloat("RATE") *  rsAR.getFloat("AMT");
							    } //end of if
							    aAR[i]=aAR[i] +  (float) dAmt ;
								//out.println("i ="+i+"<br>"+aOrder[i]);
						     }//end of while
					      aAR[i] = Math.round(aAR[i]  / aRate[i][0] /1000);
				       } // end of if
					   else {aAR[i]=0;}
					  rsAR.close();
					  pt.close();
					  //out.println((int) aAR[i]);
					 }//end of for i
						  
			  %>
              <%=(int) aAR[0]%> </font></td>
          <tr>
            <td><font size="2"> 
              <%  	 		     
			           for (int i=0;i < aARRate.length;i++)
					     {   
			              if (fQuota[i]>0)
			               {
                             aARRate[i]= (aAR[i] / fQuota[i])*100;
                             miscellaneousBean.setRoundDigit(2);
                             aARRateStr[i] = miscellaneousBean.getFloatRoundStr(aARRate[i]);
						   } else { }
			              //out.println(aARRateStr[i]  +"%");   
					    }
              %>
              <%=aARRateStr[0] +"%"%> </font></td>
          </tr>
		 </table>
		 </font>
	</td>		
    <td width="3%"><font size="2">	     
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aAR[1]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[1] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>		
    <td width="3%"><font size="2">	   
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aAR[2]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[2] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>		
    <td width="3%"><font size="2">	    
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aAR[3]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[3] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>		
    <td width="3%"><font size="2">	     
	     <table border="0" width="100%" height="100%">
		           <tr>
            <td><font size="2"> <%=(int) aAR[4]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[4] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		  <tr>
            <td><font size="2"> <%=(int) aAR[5]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[5] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		   <tr>
            <td><font size="2"> <%=(int) aAR[6]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[6] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		  <tr>
            <td><font size="2"> <%=(int) aAR[7]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[7] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
    <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		 <tr>
            <td><font size="2"> <%=(int) aAR[8]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[8] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	 <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		 <tr>
            <td><font size="2"> <%=(int) aAR[9]%></font></td>
          </tr>
            <td><font size="2"> <%=aARRateStr[9] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	 <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		  <tr>
            <td><font size="2"> <%=(int) aAR[10]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[10] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
	 <td width="3%"><font size="2">
	     <table border="0" width="100%" height="100%">
		   <tr>
            <td><font size="2"> <%=(int) aAR[11]%></font></td>
          </tr>
		  <tr>
            <td><font size="2"> <%=aARRateStr[11] +"%"%></font></td>
          </tr>
		 </table>
		 </font>
	</td>
  </tr>
   <%
     }
	 rsssm.close();
	 state.close();
   } //end of try
   catch (Exception e)
   {
       ifxTestPoolBean.releaseConnection(ifxTestCon); 
	   ifxDbtelPoolBean.releaseConnection(ifxDbtelcon); 
	   poolBean.releaseConnection(con); 
       out.println("Exception:"+e.getMessage());
   } 
%>
</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSTestPage.jsp"%>
</html>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
