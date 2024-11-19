<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,ForePriCostInputBean,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbtelPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%  
  forePriCostInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作  
  String vYear=request.getParameter("VYEAR");
  String vMonth=request.getParameter("VMONTH");  
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
   if (document.MYFORM.DEPT.value=="--" || document.MYFORM.DEPT.value==null)
  { 
   alert("Please Check the Sales Organization!!It should not be null or blank");   
   return(false);
  } 

//   if (document.MYFORM.TYPE.value=="--" || document.MYFORM.TYPE.value==null)
//  { 
//   alert("Please Check the TYPE!!It should not be null or blanked");   
//   return(false);
//  } 

//   if (document.MYFORM.REGION.value=="--" || document.MYFORM.REGION.value==null)
//  { 
//   alert("Please Check the REGION!!It should not be null or blanked");   
//   return(false);
//  }  

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Forecast Quota Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black"><em>DBTEL</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> 業務員年度銷售業績額度輸入</strong></font>
<FORM ACTION="SASalesQuotaForecastInput.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">回首頁</A>
  
<%   
  String comp=request.getParameter("COMP");
  if (comp == null) { comp = "01" ;}
  String curr=request.getParameter("CURR"); 
  String tempCurr="";
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="30%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>業務員組織:</strong></font>			
	 <% 		
	     		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql ="select distinct  trim(a.BUSI)||trim(a.DEPT) as DEPT,trim(a.BUSI)||trim(a.DEPT)||' ('||d.SVLDES||')'  from ac3 a,gsvbu b,gsvdept d ";
		  sWhere ="where a.BUSI !='' and a.DEPT !='' and a.BUSI=b.SVSGVL and a.DEPT=d.SVSGVL "+
		                 "and a.BUSI IN('0','1') and a.DEPT IN('09','13')";		 
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=ifxDbtelcon.createStatement();
          ResultSet rs=statement.executeQuery(sSql);		 
		 
          comboBoxBean.setRs(rs);		  
//		  comboBoxBean.setSelection(comp);
	      comboBoxBean.setFieldName("DEPT");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
		 
       %>			  
	</td> 
	<td colspan="5">
		<div align="right"><strong><font color="#FF0000">設定業績額度年月-&gt;</font></strong><font color="#333399" face="Arial Black"><strong>Year</strong></font>
       <%    	      		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (vYear==null)
		  {		    
		    arrayComboBoxBean.setSelection(dateBean.getYearString());
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vYear);
		  }
	      arrayComboBoxBean.setFieldName("VYEAR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
      %>
            <font color="#330099" face="Arial Black"><strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Month</strong></font>
        <%		       		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (vMonth==null)
		  {		    
		    arrayComboBoxBean.setSelection(dateBean.getMonthString());			
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(vMonth);
		  }
	      arrayComboBoxBean.setFieldName("VMONTH");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %> 
      </div>
	 </td>
	  <td width="17%" colspan="4">
	 <% 
	    if (UserRoles.indexOf("admin")>=0 || UserRoles.indexOf("fp_editor")>=0)
	   {
//   	      out.println("<input name='submit1' type='submit' value='額度輸入' onClick='return setSubmit("+'"'+"../jsp/WSForecastPriceInput.jsp"+'"'+")'> ");
   	      out.println("<input name='submit1' type='submit' value='額度輸入' onClick='return setSubmit("+'"'+"../jsp/SASalesQuotaForecastInput.jsp"+'"'+")'> ");
	   }  
	 %> 
	  
</td> 
	</tr>	
	
    <tr bgcolor="#FFFFFF"> 	   
       <td colspan="9"><div align="right"></div></td>	 
    </tr>
</table>
   <input name="COMP" type="HIDDEN" value=<%=comp%>>	
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbtelPage.jsp"%>
<!--=================================-->
</html>
