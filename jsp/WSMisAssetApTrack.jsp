<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,java.text.DecimalFormat,ComboBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->

<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>


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
<FORM ACTION="WSMisAssetApTrack.jsp" METHOD="post" NAME="MYFORM">
  <div align="left">
    <table width="100%" border="0">
      <tr> 
        <td><div align="center"> 
            <p><strong><font color="#0000FF" size="+2" face="Arial">資訊設備付款狀態明細表</font></strong> 
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
     	    DecimalFormat df=new DecimalFormat(",000"); 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";  
       
	   
	  
	  String sqlGlobal = "";
	   dateBean.setAdjMonth(-1);
	  String DateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  //out.println(DateBegin); 
	  String DateEnd=dateBean.getYearString()+dateBean.getMonthString()+"31";
	  String invdate=""; 
	  String invamt=""; 
	
	  
  %>
  <%      
	     try
            {    Statement statementTC=bpcscon.createStatement();    
                 String sqlTC =  "select Distinct t.TVEND as vend,v.VNDNAM as vdname"+" "+
                                          "from ith t,avm v" ; 								 
                 String sWhereTC=" where t.TTYPE='U1'  and t.THADVN!='' and t.tvend=v.vendor "+" "+
                                               "and t.THADVN not in(select l.AMLINV from aml l,amh h where  l.AMLVND=h.AMHVND AND l.AMLSRC=h.AMHSRC"+" "+
                                               "AND l.AMLREF=h.AMHREF AND l.AMLSUB=h.AMHSUB and h.AMHSTS='R' and h.AMHTDA<="+DateBegin+") " +" ";                                                 
                                            
			                                    String sOrderTC = " Order by 1";
												 sqlTC = sqlTC + sWhereTC + sOrderTC;
												 sqlGlobal = sqlTC;
			                                     //out.println(sqlTC);
                                                ResultSet rsTC=statementTC.executeQuery(sqlTC);	         		     
			      
			               while (rsTC.next()) 
		                     {		 	        		     		  
           
					     
                 %>
  </div>
  <table width="100%" border="1" cellpadding="0" cellspacing="0">    
    <tr bgcolor="#FDC6FF"> 
      <td width="527"  height="19" colspan="3" nowrap bordercolor="#FFDFFF" bgcolor="#CCFFFF"><font color="#FF3300" size="3">&nbsp;</font><font color="#0000FF" size="3"><strong>廠商</strong></font><font color="#FF3300" size="3"> 
        <% 
                     
					     out.println(rsTC.getString("vend")+rsTC.getString("vdname")); 					                     
          %>
        </font> 
        <div align="right"><strong><font color="#0000FF" size="2"> </font></strong></div></td>
    </tr>
    <tr > 
      <td height="15" colspan="3"><font size="2"> 
        <table border="1" width="100%" height="100%" cellpadding="0" cellspacing="0">
          <tr bgcolor="#FFFFFE" > 
            <td width="20%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>發票號碼</strong></font></div></td>
            <td width="20%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>訂單號碼</strong></font></div></td>
            <td width="20%" nowrap><div align="center"> 
                <p><font color="#000000" size="2"><strong>發票日期</strong></font><font size="2"> 
                  </font></p>
              </div></td>
            <td width="20%" nowrap><div align="center"><font color="#000000" size="2"><strong>發票金額</strong></font><font size="2"> 
                </font></div></td>
            <td width="7%" nowrap> <div align="center"><font color="#000000" size="2"><strong>已立帳</strong></font></div></td>
            <td width="7%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>未開票</strong></font></div></td>
            <td width="6%"  height="5" nowrap><div align="center"><font color="#000000" size="2"><strong>已開票 
                </strong></font></div></td>
          </tr>
          <%      
	     try
            {    String Status=""; 
			      
                 String sqlTC2 =  "select Distinct t.TVEND as vend,v.VNDNAM as vdname,t.THADVN as inv,t.tref as pono"+" "+
                                          "from ith t,avm v" ; 								 
                 String sWhereTC2=" where t.TTYPE='U1'  and t.THADVN!='' and t.tvend='"+rsTC.getString("vend")+"'  and t.tvend=v.vendor "+" "+
                                               "and t.THADVN not in(select l.AMLINV from aml l,amh h where  l.AMLVND=h.AMHVND AND l.AMLSRC=h.AMHSRC"+" "+
                                               "AND l.AMLREF=h.AMHREF AND l.AMLSUB=h.AMHSUB and h.AMHSTS='R' and h.AMHTDA<="+DateBegin+") " +" ";                                                 
                                            
			                                    String sOrderTC2 = " Order by 1";
												 sqlTC2 = sqlTC2 + sWhereTC2 + sOrderTC2;
												 //sqlGlobal = sqlTC;
			                                     //out.println(sqlTC2);
												 Statement statementTC2=bpcscon.createStatement();    
                                                ResultSet rsTC2=statementTC2.executeQuery(sqlTC2);	         		     
			      
			               while (rsTC2.next()) 
		                     {		 	        		     		  
           
					     
                 %>
          <tr bgcolor="#FFFFFF" > 
            <td width="20%" height="20" rowspan="1" nowrap> 
              <div align="center"><font size="2"> 
                </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"><%=rsTC2.getString("inv")%> </font></div></td>
            <td width="20%" rowspan="1"><div align="center"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%=rsTC2.getString("pono")%> </font><font size="2"> </font></div></td>
            <td width="20%" rowspan="1"> <div align="center"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%
				 try
                   {
                     String  sSqlL = "select AINVDT,APCINA from aph  ";		  
		             String sWhereL = "WHERE  APINV='"+rsTC2.getString("inv")+"'  and APMOVE='Y' " ;    		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { invdate=docrs.getString("AINVDT"); 
					    invamt=docrs.getString("APCINA"); 					  
					   //out.println("ˇ");					  
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
				<%
			    if(invdate!=""||!invdate.equals(""))
				{out.println(invdate);}
				else
				{out.println("&nbsp;"); }				
				
			%>
                </font></div></td>
            <td width="20%" rowspan="1"><div align="center"><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                <%
			   if(invamt!=""||!invamt.equals(""))
				{out.println(invamt);}
				else
				{out.println("&nbsp;"); }			
			%>
                </font></div></td>
            <td width="6%" rowspan="1"><div align="center"><font size="2"></font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                </font><font color="#CC3366" size="4" face="Arial, Helvetica, sans-serif">
                <%
			   if(invamt!=""||!invamt.equals(""))
				{out.println("ˇ");}
				else
				{out.println("&nbsp;"); }			
			%>
                </font><font color="#CC3366" size="3" face="Arial, Helvetica, sans-serif"> 
                </font></div></td>
            <td width="6%" rowspan="1"><div align="center"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                </font><font color="#CC3366" size="4" face="Arial, Helvetica, sans-serif"> 
                <%                 			  
                    try
                   {
                     String  sSqlL = "select  h.AMHSTS  as status from aml l,amh h ";		  
		             String sWhereL = "where l.AMLINV='"+rsTC2.getString("inv")+"' AND l.AMLVND=h.AMHVND AND l.AMLSRC=h.AMHSRC " +" "+
					                              "AND l.AMLREF=h.AMHREF AND l.AMLSUB=h.AMHSUB ;";    		              
		             sSqlL = sSqlL+sWhereL;
					 //out.println(sSqlL);
                     Statement docstatement=bpcscon.createStatement();
                     ResultSet docrs=docstatement.executeQuery(sSqlL);
                     if (docrs.next()) 
					 { Status=	docrs.getString("status"); 					    
					   out.println("ˇ"); 					  
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
                </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                </font><font size="2"> </font></div></td>
            <td width="6%" rowspan="1"><div align="center"><font size="2"> </font><font color="#0000FF" size="2" face="Arial, Helvetica, sans-serif"> 
                </font><font color="#CC3366" size="2" face="Arial, Helvetica, sans-serif"> 
                </font><font color="#0000FF" size="4" face="Arial, Helvetica, sans-serif"> 
                <%   //out.println(Status+"----1"); 
				        if (Status=="R" || Status.equals("R"))				  
					       {  out.println("ˇ");}
                        else 
						   {  out.println("&nbsp;"); }
					   //out.println(Status+"----2"); 
				 %>
                </font><font size="2"> </font></div></td>
          </tr>
          <% 
		       invdate=""; 
			   invamt="";   
		       Status=""; 
		     }//endwhile
               rsTC2.close();
	          statementTC2.close();
          } //end of try
         catch (Exception e)
         {
           out.println("Exception:"+e.getMessage());
         }   %>
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
       <input name="SQLGLOBAL222" type="hidden" value="<%=sqlGlobal%>">
  <font color="#FF0000" size="2">PS：發票號碼為SEARCH KEY 若輸入錯誤或會計INVOICE ENTRY不是輸入發票號碼時，無法正確顯示目前處理狀態.. 
  </font>
</FORM>
    
    <p>&nbsp; </p>
  </body>
<!--=============以下區段為處理完成==========-->

<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>


<!--=================================-->
</html>
