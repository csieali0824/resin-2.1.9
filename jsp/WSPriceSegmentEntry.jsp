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
  String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");     
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL1)
{  
   if (document.MYFORM.TYPE.value=="--" || document.MYFORM.TYPE.value==null)
  { 
   alert("Please Check the TYPE!!It should not be null or blanked");   
   return(false);
  } 

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
<title>Sales Forecast Price Segment Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong>   Price Segment Entry </strong></font>
<FORM ACTION="WSPriceSegmentInput.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>        
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="21%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" face="Arial Black"><strong>Type</strong></font> 
		<BR>
          <% 		
	     try
         {   
		  String sSql = "";		 
		  sSql = "select TYPE , TYPE|| '('|| TYPE_DESC_GBL||')' from WSADMIN.WSTYPE_CODE "; 		  		 		 		  
		
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(type);
	      comboBoxBean.setFieldName("TYPE");	   
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
      <td colspan="2"> <font color="#333399" face="Arial Black"><strong>Region</strong></font>
	  <BR> 
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
		  if (regionNo!=null) comboBoxBean.setSelection(regionNo);
	      comboBoxBean.setFieldName("REGION");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>	 </td>   
	<td width="43%" colspan="2"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSPriceSegmentInput.jsp")'>
</td> 
	</tr>	
	<tr>
	    <td colspan="6"><div align="right"></div></td>
	</tr>
    <tr bgcolor="#FFFFFF"> 	   
       <td colspan="6"><div align="right"></div></td>	 
    </tr>
</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
