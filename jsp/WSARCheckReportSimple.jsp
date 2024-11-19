<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean,java.text.DecimalFormat"%>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
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
<FORM ACTION="WSARCheckReportSimple.jsp" METHOD="post" NAME="MYFORM">
  <div align="left"> 
    <table width="100%" border="0">
      <tr> 
        <td width="10%" height="35"><strong><font color="#0000FF" size="+2" face="Arial"><a href="../WinsMainMenu.jsp"><font size="1"> 
          HOME</font></a><a href="../WinsMainMenu.jsp"><font size="1"> 
          <% 
     
     String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
     //String regionNo=request.getParameter("REGION");
      String TYPE=request.getParameter("TYPE"); 
	  String DATE=request.getParameter("DATE");
	  
	  String sqlGlobal = "";
	  
	   long  sumLQORD=0; 
	   long sumLAMT=0 ;  
	   long sumLQORD2=0; 
	   long  sumLAMT2=0 ;
	   long sumLQORD3=0; 
	   long sumLAMT3=0 ;
	   long sumILQTY=0; 
	   long sumIAMT=0; 
	   long sumRAMT=0; 
	   long sumUNQTY=0; 
	   long sumUNAMT=0;
	   long sumAMTMIN=0;  
	   
	   long subsumLQORD=0 ; 
	   long subsumLAMT=0 ;  
	   long subsumILQTY=0; 
	   long subsumIAMT=0; 
	   long subsumRAMT=0; 
	   long subsumUNQTY=0; 
	   long subsumUNAMT=0;
	   long subsumAMTMIN=0;     
	   DecimalFormat df=new DecimalFormat(",000");
	          
 	   
	   String rCustTmp = "";		
	   String rCust = "";    
	  
	   //String sDateBegin ="";
	   String sDateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	   
	   //out.println(sDateBegin);
	 
  %>
          </font></a></font></strong></td>
        <td width="90%"><div align="center"><strong><font color="#0000FF" size="+2" face="Arial">監檢日報表(簡表)</font></strong> 
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
  </div>
  <table width="100%" border="0">
    <tr> 
      <td width="32%" bgcolor="#006699"><font color="#FFFF00" face="Arial Black"><strong>CustomerType:</strong></font><font size="2">&nbsp; 
        </font> <font color="#FF0066" face="Arial Black"> 
        <select name="TYPE">
          <option value="1" <% if (TYPE!=null && (TYPE=="1" || TYPE.equals("1")) ) { out.println("SELECTED"); } %>>內銷</option>
          <option value="3"<% if (TYPE!=null && (TYPE=="3" || TYPE.equals("3")) ) { out.println("SELECTED"); } %>>外銷</option>
          <option value="4" <% if (TYPE!=null && (TYPE=="4" || TYPE.equals("4")) ) { out.println("SELECTED"); } %>>ALL</option>
        </select>
        </font> </td>
      <td width="41%" bgcolor="#006699"><font color="#FFFF00"><strong>收款日結止日：</strong></font> 
        <input name="DATE" type="text" 
		<% if (DATE==null || DATE== "" || DATE.equals("")) 
		     { out.println("value="+dateBean.getYearMonthDay()); }
		      else  
		     { out.println("value="+DATE); }
			 
		     if (DATE==null || DATE== "" || DATE.equals("")) 																																							       		
	         { DATE = dateBean.getYearMonthDay(); }
		      sDateBegin=DATE.substring(0,4)+DATE.substring(4,6)+"01";
		%>		
		
		> <font color="#FF0066" face="Arial Black">&nbsp;</font></td>
      <td width="27%" bgcolor="#006699"><input name="button" type="button" onClick='setSubmit("../jsp/WSARCheckReportSimple.jsp")'  value="Query" >
        <font size="2" color="#000099">&nbsp;</font></td>
    </tr>
  </table>
  <table width="100%" border="1" cellspacing="0" cellpadding="0">
    <tr bgcolor="#006666"> 
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><strong><font color="#FFFFFF" size="2">號碼</font></strong></div></td>
      <td width="5%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">日期</font></strong></font></div></td>
      <td width="5%" bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">數量</font></strong></font></div></td>
      <td width="6%"bordercolor="#000000" bgcolor="#6699FF"> <div align="center"><font color="#FFFFFF"><strong><font size="2" face="新細明體">金額</font></strong></font></div></td>
    </tr>
	
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">訂單</font></div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">當日新增</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%   int LQORD =0; 		       
		          long LAMT = 0; 

                    try
                   {
				    int nn=0; 
					while (nn<2)
					{
					String  sSqlL=""; 
					String sWhereL=""; 					 
					
					if(nn==0)
					{
                     sSqlL = "SELECT SUM(lqord) lqord,SUM(lqord*lnet*hcnvfc) lamt from ecl l,ech h";		  
		             sWhereL = " WHERE (l.lord=h.hord) AND lqord>=0 ";		              
		            if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + "AND (h.hctyp ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (h.hctyp ='11') " ;}			      
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (h.hctyp ='12') ";  }			      
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (h.hctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND  h.hctyp IN ('11','13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (l.lodte = '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (l.lodte ='"+DATE+"') ";}
			        }
					if(nn==1)    
					{ 
					sSqlL = "SELECT COUNT(lord) lqord,SUM(lchrg*hcnvfc) lamt from ecs l,ech h";		  
		            sWhereL = " WHERE (l.lord=h.hord) ";		              
		            if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + " AND h.hctyp IN ('11','13')"; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (h.hctyp ='11') " ;}			    
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (h.hctyp ='12') ";  }			        
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (h.hctyp ='13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (l.lrdte = '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (l.lrdte ='"+DATE+"') ";}
			        } 
			  
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 					      
					   					  			   
					   LQORD = docrs.getInt("lqord"); 
					   LAMT=docrs.getLong("lamt");				   
					   
					  sumLQORD=sumLQORD+LQORD;
					  sumLAMT=sumLAMT+LAMT; 
					 }
                     else 
					  { 
					     
					   out.println("&nbsp;"); 
					 }
					 
                     docrs.close();
                     docstatement.close();
					  nn++; 
					    					  					 
					 } //end of while 
					 //String sumLQORDS=new Long(Long.parseLong(sumLQORDS)); 
                     //String sumLQORDs=String.valueof (int sumLQORD); 
					 if(sumLQORD>=1000 || sumLQORD<=-1000)
					 {out.println(df.format(sumLQORD)); }
					 else
					 {out.println(sumLQORD);}					
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }	
                     
                 %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (sumLAMT!=0)
		     { 
			   out.println(df.format(sumLAMT)); 
			   //out.println(sumLAMT); 		   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">訂單</font></div></td>
      <td><div align="center"> 
          <p><font size="3" face="Arial, Helvetica, sans-serif">當月累計</font></p>
        </div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%  long LQORD2 = 0;  
	             long LAMT2 = 0;      
				 
                    try
                   {			  
				    int nn2=0; 
					while (nn2<2)
					{
					String  sSqlL=""; 
					String sWhereL=""; 					 
					
					if(nn2==0)
					{
                       sSqlL = "SELECT SUM(lqord) lqord2,SUM(lqord*lnet*hcnvfc) lamt2 from ecl l,ech h";		  
		               sWhereL = " WHERE (l.lord=h.hord) AND lqord>=0 ";		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + " AND (h.hctyp ='11')"; }
			        else  if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (h.hctyp ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (h.hctyp ='12') ";  }			      
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (h.hctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4")  ) { sWhereL = sWhereL + " AND h.hctyp IN ('11','13')"; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (l.lodte BETWEEN '"+sDateBegin+"' AND '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (l.lodte BETWEEN '"+sDateBegin+"' AND '"+DATE+"') ";}
			         } 
					 if(nn2==1)    
					{ 
					sSqlL = "SELECT COUNT(lord) lqord2,SUM(lchrg*hcnvfc) lamt2 from ecs l,ech h";		  
		            sWhereL = " WHERE (l.lord=h.hord)   ";		              
		            if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + " AND (h.hctyp ='11')"; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (h.hctyp ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (h.hctyp ='12') ";  }			      
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (h.hctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4")  ) { sWhereL = sWhereL + " AND h.hctyp IN ('11','13')"; }
					
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (l.lrdte BETWEEN '"+sDateBegin+"' AND '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (l.lrdte BETWEEN '"+sDateBegin+"' AND '"+DATE+"') ";}
					} 
					 sSqlL = sSqlL+sWhereL;
					 
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
					 
                     if (docrs.next()) 
					 { 
					   //out.println(docrs.getInt("lqord2"));
					   LQORD2=docrs.getInt("lqord2"); 
					   LAMT2 = docrs.getLong("lamt2"); 
					   sumLQORD2=sumLQORD2+LQORD2; 
					   sumLAMT2=sumLAMT2+LAMT2; 
					 }
                     else {  out.println("&nbsp;"); }
                     docrs.close();
                     docstatement.close(); 
					 nn2++; 
					 }//end of while
					 if(sumLQORD2>=1000 || sumLQORD2<=-1000)
					 {out.println(df.format(sumLQORD2)); }
					 else
					 {out.println(sumLQORD2); }

					 //out.println(sumLQORD2);    
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }	
                     
                 %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          <% if (sumLAMT2!=0)
		     { 
			   //out.println(sumLAMT2); 
			   out.println(df.format(sumLAMT2)); 
			   //sumLAMT=sumLAMT+LAMT;			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">累計</font></div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">未出貨餘額</font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%    
		        long QTY=0;
				long TQTY=0;
				long AMT=0;
				long TAMT=0;
				
                   try
                   {
                     String  sSqlL = "SELECT SUM(lqord) lqord,SUM(lqord*lnet*hcnvfc) amt FROM ech,ecl";
		             String sWhereL = " WHERE  hord=lord AND lqord>=0 AND lid='CL'  AND  lqord-lqshp > 0 ";
					 		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + "AND (hctyp ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (hctyp ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (hctyp ='12') ";  }			        
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (hctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND hctyp IN ('11','13')  " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (lodte<= '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (lodte<= '"+DATE+"') ";}
			              
			  
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 
					   QTY= docrs.getInt("lqord");
					   AMT = docrs.getLong("amt"); 
					  // out.println(QTY);
					 //  out.println(AMT);
					 }
                     //else {  out.println("&nbsp;"); }
                     docrs.close();
                     docstatement.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }
				   //倒推已出貨
				     try
                   {
                     String  sSqlS= "SELECT SUM(tqty) tqty,SUM(tqty*lnet*hcnvfc) tamt FROM ith,ecl,ech";
		             String sWhereS= " WHERE tref=lord AND thlin=lline AND hord=lord AND ttype='B' ";
					 		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereS = sWhereS + " AND (hctyp ='11')"; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereS = sWhereS + "AND (hctyp ='11') " ;}			        
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereS = sWhereS + "AND (hctyp ='12') ";  }			        
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereS = sWhereS + "AND (hctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereS = sWhereS + "AND hctyp IN ('11','13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereS= sWhereS + "AND (lodte <= '"+dateBean.getYearMonthDay()+"' AND ttdte >'"+dateBean.getYearMonthDay()+"' ) " ; }
			        else  { sWhereS = sWhereS+ "AND (lodte<= '"+DATE+"'  AND  ttdte >'"+DATE+"' ) ";}
			              
			  
					 sSqlS = sSqlS+sWhereS;
					 //out.println(sSqlS);
                     Statement docstatementS=bpcscon.createStatement();
                     ResultSet docrsS=docstatementS.executeQuery(sSqlS);
                     if (docrsS.next()) 
					 { 
					   TQTY= docrsS.getInt("tqty");
					   TAMT= docrsS.getLong("tamt"); 
					 }
					    QTY=QTY-TQTY; 
						AMT=AMT-TAMT; 
					   //out.println(QTY);
					   if(QTY>=1000 || QTY<=-1000)
					   {out.println(df.format(QTY)); }
					   else
					   {out.println(QTY); }
                     //else {  out.println("&nbsp;"); }
                     docrsS.close();
                     docstatementS.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }		
            
                 %>
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% if (AMT!=0)
		     { 
			   out.println(df.format(AMT)); 
			   //out.println(AMT); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">出貨</font></div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">當日新增</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%  
	             long ILAMT =0;            
				 
				 			  
                   try
                   {
                     String  sSqlL= "SELECT SUM(ilqty) ilqty,SUM((ilrev+ilta01)*sicnfc) ilamt FROM sih h,sil l ";		  
		             String sWhereL = " WHERE  h.siord=l.ilord AND h.ihodyr=l.ilodyr AND h.ihodpx=l.ilodpx AND h.siinvn=l.ilinvn AND l.ilqty >= 0 ";	
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + "AND (h.sictyp ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (h.sictyp ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (h.sictyp ='12') ";  }			        
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (h.sictyp ='13') "; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND h.sictyp IN ('11','13') "; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (l.ildate = '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (l.ildate ='"+DATE+"') ";}
			              
					 sSqlL = sSqlL+ sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 			  
					   //out.println(docrs.getInt("ilqty"));
					   if(docrs.getInt("ilqty")>=1000 ||docrs.getInt("ilqty")<=-1000)
					   {out.println(df.format(docrs.getInt("ilqty"))); }
					   else
					   {out.println(docrs.getInt("ilqty")); }
					   ILAMT = docrs.getLong("ilamt"); 
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
          <% if (ILAMT!=0)
		     { 
			   out.println(df.format(ILAMT)); 
			   //out.println(ILAMT); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center">出貨</div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">當月累計</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%    
	              long ILAMT2 = 0;    
				         			  
                   try
                   {
                     String  sSqlL = "SELECT SUM(ilqty) ilqty2,SUM((ilrev+ilta01)*sicnfc) ilamt2 FROM sih,sil ";		  
		             String sWhereL = " WHERE siord=ilord AND ihodyr=ilodyr AND ihodpx=ilodpx AND siinvn=ilinvn  AND ilqty>=0 ";
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + " AND (sictyp ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (sictyp ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (sictyp ='12') ";  }			    
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (sictyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND sictyp IN ('11','13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (ildate BETWEEN '"+sDateBegin+"' AND '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (ildate BETWEEN '"+sDateBegin+"' AND '"+DATE+"') ";}
			              
			  
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 {  
					   //out.println(docrs.getInt("ilqty2"));
					   if(docrs.getInt("ilqty2")>=1000 || docrs.getInt("ilqty2")<=-1000)
					   {out.println(df.format(docrs.getInt("ilqty2"))); }
					   else
					   {out.println(docrs.getInt("ilqty2")); }
					   ILAMT2= docrs.getLong("ilamt2"); 
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
          <% if (ILAMT2!=0)
		     { 
			   out.println(df.format(ILAMT2)); 
			  // out.println(ILAMT2); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center">收款</div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">當日新增</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%  
	             long RAMT=0;            
				 			  
                   try
                   {
                     String  sSqlL= "SELECT SUM(ramt) * -1 ramt FROM rar r ";		  
		             String sWhereL = " WHERE  rrid IN ('RC','RP') ";	
					
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + "AND (r.rctyp  ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (r.rctyp  ='11') " ;}			       
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (r.rctyp  ='12') ";  }			     
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (r.rctyp  ='13') " ; }
				    else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND r.rctyp  IN ('11','13')  " ; }
			   
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (r.rdate = '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (r.rdate ='"+DATE+"') ";}	              
			  
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 
					   out.println(0);
					   RAMT = docrs.getLong("ramt"); 
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
          <% if (RAMT !=0)
		     { 
			   out.println(df.format(RAMT)); 
			   //out.println(RAMT); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center">收款</div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">當月累計</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%  
	              long RAMT2 = 0;       
				      			  
                   try
                   {
                     String  sSqlL = "SELECT SUM(ramt) * -1 ramt2 FROM rar r";		  
		             String sWhereL = " WHERE r.rrid IN('RP','RC') ";		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + "AND (r.rctyp ='11') "; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (r.rctyp ='11') " ;}			        
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (r.rctyp  ='12') ";  }			        
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (r.rctyp  ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + "AND r.rctyp IN ('11','13')" ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (r.rdate BETWEEN '"+sDateBegin+"' AND '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (r.rdate BETWEEN '"+sDateBegin+"' AND '"+DATE+"') ";}
			              
			  
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 
					   out.println(0);
					   RAMT2 = docrs.getLong("ramt2"); 
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
      <td> <div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% if (RAMT2 !=0)
		     { 
			   out.println(df.format(RAMT2)); 
			   //out.println(RAMT2); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font> </div></td>
    </tr>
    <tr bgcolor="#FFFFFF"> 
      <td><div align="center">累計</div></td>
      <td><div align="center"><font size="3" face="Arial, Helvetica, sans-serif">應收帳款餘額</font></div></td>
      <td><div align="right"><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
          <%    
		        long  RCAMT=0;
				long RCORG=0;
				
                   try
                   {
                     String  sSqlL = "SELECT SUM(RCAMT) rcamt FROM rar r ";
		             String sWhereL = " WHERE  r.rrid IN('RI','RP') AND r.rseq = 0 AND r.rrem !=0 ";
					 		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereL = sWhereL + " AND (r.rctyp ='11')"; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereL = sWhereL + "AND (r.rctyp ='11') " ;}			      
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereL = sWhereL + "AND (r.rctyp ='12') ";  }			       
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereL = sWhereL + "AND (r.rctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereL = sWhereL + " AND r.rctyp IN ('11','13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereL= sWhereL + "AND (r.rdate<= '"+dateBean.getYearMonthDay()+"') " ; }
			        else  { sWhereL = sWhereL+ "AND (r.rdate<= '"+DATE+"') ";}
			              
					 sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { 
					   RCAMT= docrs.getLong("rcamt"); 
					 }
					   out.println(0);
                     docrs.close();
                     docstatement.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }
				   //倒推已結A/R
				     try
                   {
                     String  sSqlS= "SELECT SUM(r1.rcorg) rcorg FROM rar r1,rar r2 ";
		             String sWhereS= " WHERE (r1.arodyr=r2.arodyr AND r1.arodpx=r2.arodpx AND r1.rinvc=r2.rinvc) ";
					 sWhereS= sWhereS + " AND (r1.rrid IN ('RP','RC') AND r1.rseq>=1)  AND (r2.rrid IN ('RI','RP') AND r2.rseq=0) ";
					 		              
		             if (TYPE==null || TYPE== "" || TYPE.equals("")  )  { sWhereS = sWhereS + " AND (r1.rctyp ='11')"; }
			        else if (TYPE=="1" || TYPE.equals("1") ) { sWhereS = sWhereS + "AND (r1.rctyp ='11') " ;}			     
			        //else if (TYPE=="2" || TYPE.equals("2") ) { sWhereS = sWhereS + "AND (r1.rctyp ='12') ";  }			       
			        else if (TYPE=="3" || TYPE.equals("3") ) { sWhereS = sWhereS + "AND (r1.rctyp ='13') " ; }
					else if (TYPE=="4" || TYPE.equals("4") ) { sWhereS = sWhereS + "AND r1.rctyp IN ('11','13') " ; }
			   
			        if (DATE==null || DATE== "" || DATE.equals("")  )  { sWhereS= sWhereS + "AND (r2.rdate <= '"+dateBean.getYearMonthDay()+"' AND r1.rdate>'"+dateBean.getYearMonthDay()+"' ) " ; }
			        else  { sWhereS = sWhereS+ "AND (r2.rdate<= '"+DATE+"'  AND  r1.rdate >'"+DATE+"' ) ";}
			              	  
					 sSqlS = sSqlS+sWhereS;
					 //out.println(sSqlS);
                     Statement docstatementS=bpcscon.createStatement();
                     ResultSet docrsS=docstatementS.executeQuery(sSqlS);
                     if (docrsS.next()) 
					 { 
					   RCORG= docrsS.getLong("rcorg");
					 }
					   RCAMT=RCAMT-RCORG; 
					  // out.println(RCAMT);
					  // out.println(RCORG);
					   //out.println(0);
                     //else {  out.println("&nbsp;"); }
                     docrsS.close();
                     docstatementS.close();     
                   } //end of try
                    catch (Exception e)
                   {
                     out.println("Exception:"+e.getMessage());		  
                   }		
              
                 %>
          </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
          </font></div></td>
      <td><div align="right"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif">
          <% if (RCAMT !=0)
		     { 
			   out.println(df.format(RCAMT)); 
			   //out.println(RCAMT); 			   
			 }
	         else {out.println(0); } 
		   %>
          </font></div></td>
    </tr>
   
  </table>
      <input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
	</FORM>
    
    <p>&nbsp; </p>
  </body>

<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
<!--=================================-->
</html>
