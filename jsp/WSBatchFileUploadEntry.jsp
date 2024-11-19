<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<%@ page import="ComboBoxBean,ArrayComboBoxBean,ForePriCostInputBean,DateBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ page import="com.jspsmart.upload.*" %>
<jsp:useBean id="mySmartUpload" scope="page" class="com.jspsmart.upload.SmartUpload" /> 
<%
mySmartUpload.initialize(pageContext); 

String vYear=request.getParameter("VYEAR"); 
String vMonth=request.getParameter("VMONTH");  
String comp=request.getParameter("COMP");   
String type=request.getParameter("TYPE");
String curr=request.getParameter("CURR");  
String tempCurr="";
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
   if (document.MYFORM.COMP.value=="--" || document.MYFORM.COMP.value==null)
  { 
   alert("Please Check the BUSINESS UNIT!!It should not be null or blanked");   
   return(false);
  } 

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

 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<html>
<head>
<title>Batch Files Upload Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Batch Files Upload Entry</strong></font>
<FORM  ACTION="../jsp/WSBatchFileUploadEntry2.jsp" METHOD="post" NAME="MYFORM" ENCTYPE="multipart/form-data">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>

<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="19%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>Bussiness
            Unit:</strong></font>
			<BR>
			<% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select trim(MCCOMP),MCDESC from WSMULTI_COMP";		  
		  sWhere = " where MCACCT='Y' order by MCCOMP";		 
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);		 
		 
          comboBoxBean.setRs(rs);		  
		  comboBoxBean.setSelection(comp);
	      comboBoxBean.setFieldName("COMP");	   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      
		  
		  if (comp!=null && !comp.equals("--"))
		  {
		   rs=statement.executeQuery("SELECT MCCURR FROM WSMULTI_COMP where MCCOMP='"+comp+"'");
		   if (rs.next()) tempCurr=rs.getString("MCCURR");
		  }
		  
		  rs.close();
		  statement.close();		                    		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>
			  
	</td> 
      <td width="16%" height="23" bordercolor="#FFFFFF"> 
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
      <td width="13%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> 
	  <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select Unique REGION as x , REGION from WSREGION";		  
		  sWhere = " order by x";		 
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSBatchFileUploadEntry2.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2);                              
           out.println("<OPTION VALUE='"+s1+"'>"+s2);                   
          } //end of while
           out.println("</select>"); 	  		  		  
        
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>  
      </td>
      <td width="21%"><font color="#333399" face="Arial Black"><strong>Country</strong></font> <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where x.LOCALE=y.LOCALE  order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 		  
	      comboBoxBean.setFieldName("COUNTRY");	   
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
      <td colspan="2"><font color="#333399" face="Arial Black"><strong>Currency</strong></font>
	  <BR>
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
		  comboBoxBean.setSelection(tempCurr); 		  	
	      comboBoxBean.setFieldName("CURR");	   
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
	  <td width="17%" colspan="4">&nbsp;
</td> 
	</tr>	
	<tr>
	    <td colspan="9">
		<div><strong><font color="#FF0000">SET THE BEGIN DATE-&gt;</font></strong><font color="#333399" face="Arial Black"><strong>Year</strong></font>
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
	</tr>
</table>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
