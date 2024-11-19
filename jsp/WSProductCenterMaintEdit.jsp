<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,ComboBoxBean,DateBean,ArrayComboBoxBean,ArrayListCheckBoxBean"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get Connection from different DB==========-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="arrayListCheckBoxBean" scope="session" class="ArrayListCheckBoxBean"/>
<title>WINS System - Sales Forecast Product Data Edit Page</title>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<style type="text/css">
<!--
.style2 {color: #000099}
-->
</style>
<head>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>WINS System Sales Forecast Product Data Edit Page</strong></font>
<% //out.println("step0");    %>
<FORM ACTION="../jsp/WSProductCenterMaintenance.jsp" METHOD="post" NAME="MYFORM">
<% 
     //String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev=""; 
     //out.println("step1"); 
     String sqlGlobal=""; 
    
     //String locale=request.getParameter("LOCALE");
     String brand=request.getParameter("BRAND");
     String designHouse=request.getParameter("DESIGNHOUSE");
     String platForm=request.getParameter("PLATFORM");
     String interModel=request.getParameter("INTERMODEL");
     String launchDate=request.getParameter("LAUNCHDATE");
     //out.println("step2");
     String YearFr=request.getParameter("YEARFR");
     String MonthFr=request.getParameter("MONTHFR");
	 String dateStringBegin=YearFr+MonthFr;
     //out.println("step3");
     String YearTo=request.getParameter("YEARTO");
     String MonthTo=request.getParameter("MONTHTO");
	 String dateStringEnd=YearTo+MonthTo;   
     //out.println("step4");  
    // out.println("step5 : sqlGlobal="+sqlGlobal);    
    
%>
 <table width="100%" border="0">
    <tr bgcolor="#000066">
     <%  //out.println("step6 : sqlGlobal="+sqlGlobal);    
     try
     {  
      Statement statement=con.createStatement(); 
      sqlGlobal =  "select INTER_MODEL,EXT_MODEL,BRAND,DESIGNHOUSE,PLATFORM,LAUNCH_DATE,PROD_DESC,CREATE_DATE,CREATE_USER "+
			       "from PSALES_PROD_CENTER ";
      String sWhereTC = "where INTER_MODEL IS NOT NULL ";

      if (brand == null || brand.equals("--")) { sWhereTC = sWhereTC + "and BRAND != '0'  "; }
	  else { sWhereTC = sWhereTC + "and BRAND ='"+brand+"'  "; }			  
	  if (designHouse == null || designHouse.equals("--")) { sWhereTC = sWhereTC + "and DESIGNHOUSE != '0'  "; }
	  else { sWhereTC = sWhereTC + "and DESIGNHOUSE ='"+designHouse+"'  "; }                      			             
      if (platForm == null || platForm.equals("--")) { sWhereTC = sWhereTC + "and PLATFORM != '0'  "; }
	  else { sWhereTC = sWhereTC + "and PLATFORM = '"+platForm+"'  "; }
      if (interModel == null || interModel.equals("")) { sWhereTC = sWhereTC + "and INTER_MODEL != '0'  "; }
	  else { sWhereTC = sWhereTC + "and INTER_MODEL = '"+interModel+"'  "; }
      if (launchDate != null && !launchDate.equals("") ) {  sWhereTC = sWhereTC + "and LAUNCH_DATE='"+launchDate+"' "; } 
     // if ((!(MonthFr=="--")&&(MonthFr=="00")) && MonthTo=="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) >="+"'"+dateStringBegin+"' ";
     // if (MonthFr!="--" && MonthTo!="--") sWhereTC=sWhereTC+" and substr(LAUNCH_DATE,3,4)||substr(LAUNCH_DATE,1,2) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";

      //sWhereTC = sWhereTC + "and b.TXDATE = '"+txDate+"' and b.TTICKETNO ='"+tTicketNo+"' and b.TOLINE ='"+toLine+"' and b.TXTIME='"+txTime+"' and b.TCOM='"+tCom+"' "; 
      sqlGlobal = sqlGlobal + sWhereTC;
      //out.println("step7 : sqlGlobal="+sqlGlobal);
      ResultSet rs=statement.executeQuery(sqlGlobal);
      if (rs.next())
      {
     %>
     <td width="23%" bordercolor="#FFFFFF" bgcolor="#000099" nowrap><font color="#FFFFFF" face="Arial"><strong>INTERNAL MODEL : </strong></font><font color="#FF3366" face="Arial"><strong><%=rs.getString("INTER_MODEL")%></strong></font> </td>     
    </tr>    
    <tr bgcolor="#6699FF"> 
 </table>  
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
   <tr>
     <td>&nbsp;</td>    
   </tr>
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>EXTERNAL MODEL : </strong></font> </td>
    <td> <input name="EXTERMODEL" type="text" value="<%=rs.getString("EXT_MODEL")%>" size="100%" maxlength="15"> </td>
  </tr>  
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>BRAND :</strong></font> </td>
    <td> 
         <% 
             try
            {   
		      String sSql = "";
		      String sWhere = "";
		  
		       sSql = "select DISTINCT BRAND as x , BRAND from PSALES_PROD_CENTER ";		  
		       sWhere = "where (BRAND in('DBTEL','Dbtel') or BRAND in(select DISTINCT BRAND from PSALES_PROD_CENTER)) order by x";		 
		       sSql = sSql+sWhere;		  
		  		      
               Statement stateB=con.createStatement();
               ResultSet rsB=stateB.executeQuery(sSql);
		       comboBoxBean.setRs(rsB);
               comboBoxBean.setSelection(brand);		  		  		  
	           comboBoxBean.setFieldName("BRAND");	   
               out.println(comboBoxBean.getRsString());
		       /*out.println("<select NAME='BRAND' onChange='setSubmit("+'"'+"../jsp/WSProductCenterMaintEdit.jsp"+'"'+")'>");
               out.println("<OPTION VALUE=-->--");     
              while (rsB.next())
              {            
               String s1=(String)rsB.getString(1); 
               String s2=(String)rsB.getString(2); 
                        
                  if (s1.equals(brand)) 
                 {
                   out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
                 } else {
                  out.println("<OPTION VALUE='"+s1+"'>"+s2);
                }        
             } //end of while
             out.println("</select>"); 	
          */
          rsB.close();    
		  stateB.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         } 
         %> 
	</td>
  </tr> 
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>DESIGN HOUSE :  </strong></font> </td>
    <td> 
      <%
         try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select DISTINCT DESIGNHOUSE as x , DESIGNHOUSE from PSALES_PROD_CENTER ";		  
		  sWhere = "where (DESIGNHOUSE IN('DBTEL','ARES') or DESIGNHOUSE in(select DISTINCT b.DESIGNHOUSE from PSALES_PROD_CENTER b))  order by x";		
          //if (designHouse !=null && !designHouse.equals(""))	{ sWhere = sWhere + "and DESIGNHOUSE ='"+designHouse+"' ";  }   
		  sSql = sSql+sWhere;		  
		  		      
          Statement stateD=con.createStatement();
          ResultSet rsD=stateD.executeQuery(sSql);
		  comboBoxBean.setRs(rsD);
          comboBoxBean.setSelection(designHouse);		  		  		  
	      comboBoxBean.setFieldName("DESIGNHOUSE");	   
          out.println(comboBoxBean.getRsString());
		 /*
          out.println("<select NAME='DESIGNHOUSE' onChange='setSubmit("+'"'+"../jsp/WSProductCenterMaintEdit.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rsD.next())
          {            
           String s1=(String)rsD.getString(1); 
           String s2=(String)rsD.getString(2); 
                        
            if (s1.equals(designHouse)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
           } //end of while
           out.println("</select>"); 	
        */  
          rsD.close();    
		  stateD.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
        %>        
        
    </td>
  </tr>    
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>PLATFORM : </strong></font> </td>
    <td> 
        <%
         try
         {   
		  String sSql = "";
		  String sWhere = "";
		  String sOrder = "order by x";
		  sSql = "select PLATFORM as x, PLATFORM from PRPROD_PLATFORM ";		  
		  sWhere = "where PLATFORM IS NOT NULL ";	
          //if (platForm !=null && !platForm.equals(""))	{ sWhere = sWhere + "and PLATFORM ='"+platForm+"' ";  } 
                   
		  sSql = sSql+sWhere+sOrder;		  
		  		      
          Statement stateP=con.createStatement();
          ResultSet rsP=stateP.executeQuery(sSql);
		  comboBoxBean.setRs(rsP);
          comboBoxBean.setSelection(platForm);		  		  		  
	      comboBoxBean.setFieldName("PLATFORM");	   
          out.println(comboBoxBean.getRsString());
     /*     
		  out.println("<select NAME='PLATFORM' onChange='setSubmit("+'"'+"../jsp/WSProductCenterMaintEdit.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rsP.next())
          {            
           String s1=(String)rsP.getString(1); 
           String s2=(String)rsP.getString(2); 
                        
            if (s1.equals(platForm)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
           } //end of while
           out.println("</select>"); 	  		  		  
      */  
          rsP.close();    
		  stateP.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
        %>
    </td>
  </tr>  
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>LUANCH DATE : </strong></font> </td>
    <td> <input name="LAUNCHDATE" type="text" value="<%=rs.getString("LAUNCH_DATE")%>" size="100%" maxlength="50"> </td>
  </tr>
  <tr>
    <td width="24%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" bgcolor="#FFFFCC"><font face="Arial"><strong>DESCRIPTION : </strong></font> </td>
    <td> <input name="PRODDESC" type="text" value="<%=rs.getString("PROD_DESC")%>" size="100%" maxlength="50"> </td>
  </tr>    
 </table>
 <table width="100%" border="1" cellpadding="1" cellspacing="1">
  <tr> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. USER : </font><font face="Arial"><%=rs.getString("CREATE_USER")%></strong></font>    </td>
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. DATE : </font><font face="Arial"><%=dateBean.getYearMonthDay()%></strong></font>    </td> 
    <td width="33%" nowrap bordercolor="#FFFFFF" bordercolordark="#000000" class="style2"><font face="Arial Black">LAST MAINT. TIME : </font><font face="Arial"><%=dateBean.getHourMinuteSecond()%></strong></font>    </td> 
  </tr>   
 </table> 
 <input name="INTERMODEL" type="hidden" value="<%=interModel%>"> 
 
 <input name="submit1" type="submit" value="UPDATE" onClick='return setSubmit("../jsp/WSProdCenterMaintEditCommit.jsp?INTERMODEL=<%=interModel%>")'> 
 <input name="submit2" type="submit" value="ABORT" onClick='return setSubmit("../jsp/WSProductCenterMaintenance.jsp?INTERMODEL=<%=interModel%>")'>
 <%
       rs.close();
       statement.close();
      }
     } //end of try
     catch (Exception e)
     {
      out.println("Exception:"+e.getMessage());		  
     }
  %>
</FORM>
</body>
<!--=============¢FFDH?U¢FFXI?q?¢FFXAAcn3s¢FGg2|A==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
