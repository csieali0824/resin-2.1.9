<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,ForePriCostInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%  
  forePriCostInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作     
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL1)
{ 
   if (document.MYFORM.REGION.value=="--" || document.MYFORM.REGION.value==null)
  { 
   alert("Please Check the REGION!!It should not be null or blanked");   
   return(false);
  }     
 
 document.MYFORM.action=URL1; 
 document.MYFORM.submit();
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Forecast Country Factor Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>   Country Factor Entry </strong></font>
<FORM ACTION="WSCountryFactorInput.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>        
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="22%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>Base
            Country:</strong></font>
   	<BR>
  	 <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select unique x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where x.LOCALE=y.LOCALE order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 		  
	      comboBoxBean.setFieldName("BASECOUNTRY");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> </td> 
      <td width="18%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#333399" face="Arial Black"><strong>Brand</strong></font> <BR>
          <% 		
	     try
         {   
		  String sSql = "";		 
		  sSql = "select BRAND,BRAND from PIBRAND "; 		  		 		 		  
		
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		  
	      comboBoxBean.setFieldName("BRAND");	   
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
      <td width="27%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select Unique REGION as x , REGION from WSREGION";		  
		  sWhere = " order by x";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 		  
	      comboBoxBean.setFieldName("REGION");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> </td>  
	  <td width="24%"><font color="#333399" face="Arial Black"><strong>Currency</strong></font> <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select unique MCCURR as a, MCCURR from WSMULTI_COMP";		  
		  sWhere = " order by a";		              
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  	 
	      comboBoxBean.setFieldName("CURR");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
	  <td width="9%" colspan="2"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSCountryFactorInput.jsp")'>
</td> 
	</tr>	
	<tr>
	    <td colspan="7"><div align="right"></div></td>
	</tr>
    <tr bgcolor="#FFFFFF"> 	   
       <td colspan="7"><div align="right"></div></td>	 
    </tr>
</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
