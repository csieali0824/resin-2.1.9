<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,ForecastInputBean,ForePriCostInputBean,RsCountBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<jsp:useBean id="forecastInputBean" scope="session" class="ForecastInputBean"/>
<jsp:useBean id="forePriCostInputBean" scope="session" class="ForePriCostInputBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<%  
  forecastInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作
  forePriCostInputBean.setArray2DString(null);//將此bean值清空以為不同case可以重新運作  
  String vYear=request.getParameter("VYEAR");
  String vMonth=request.getParameter("VMONTH");  
%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL1,URL2)
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
 
  if (document.MYFORM.TYPE.value=="003") //如果為SOURCING旳FORECAST則用其他處理
  { 
   document.MYFORM.action=URL1;
  } else {
   document.MYFORM.action=URL2;
  } 
 document.MYFORM.submit();
}

function showCountry(gg)
{   
   var i=0,j=0,t=0;
   var regionObj;
   regionObj = document.MYFORM.REGION;        
   
   for (t=0;t<gg;t++)  //清空所有選項
   {
     if (document.MYFORM.COUNTRY.options[0].value!=null)
	 {         
       document.MYFORM.COUNTRY.options[0] =null;		
	 }  	   
   }    
   
   if (regionObj.value=="--")
   {                  
     document.MYFORM.COUNTRY.options[0] = new Option("--","--");
   } else {            
      for (i=0;i<RegionName.length;i++)
      {  
         if (RegionName[i]==regionObj.value)
	     { 
	        for (j=0;j<CounCode[i].length;j++)
		    {			   			  
	          document.MYFORM.COUNTRY.options[j] = new Option(CounName[i][j],""+CounCode[i][j]);
            }
	     } 
      }	
   } //end of if  =>regionObj.value=="--"  
}
</script>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Sales Weekly Forecast Entry Form</title>
</head>
<body>
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Commitment &amp; Forecast  Entry (Common)</strong></font>
<FORM ACTION="WSForecastInput.jsp" METHOD="post" NAME="MYFORM">
<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A>
  
<%   
   String comp=request.getParameter("COMP");
   String type=request.getParameter("TYPE");
  String regionNo=request.getParameter("REGION");
  String country=request.getParameter("COUNTRY"); 
  
  Statement countryStmt=con.createStatement();
  ResultSet countryRs=null;	 
  String regionArray[]=null;
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="23%" bordercolor="#FFFFFF"><font color="#330099" face="Arial Black"><strong>Bussiness
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
		  statement.close();		 
        
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>  
	</td> 
      <td width="20%" height="23" bordercolor="#FFFFFF"> 
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
      <td width="22%"><font color="#333399" face="Arial Black"><strong>Region</strong></font> 
	  <BR>
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select Unique REGION from WSREGION";		  
		  sWhere = " order by REGION";		 
		  sSql = sSql+sWhere;		  
		  		      
          Statement statement=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
          ResultSet rs=statement.executeQuery(sSql);		  
		  rsCountBean.setRs(rs); //取得其line detail總筆數
		  regionArray=new String[rsCountBean.getRsCount()]; //宣告為符合其總筆數大小之陣列
         %>
          <script language="JavaScript" type="text/JavaScript">
		    CounName=new Array();
		    CounCode=new Array();
			RegionName=new Array();
		  </script>
         <%		 		  		  
		  int rsi=0; 
          while (rs.next())
          {     
		   int cci=0;//代表共有多少筆屬於該區域的國家       
           String s1=(String)rs.getString(1);            
		   regionArray[rsi]=s1;
		   %>
             <script language="JavaScript" type="text/JavaScript">
			  RegionName[<%=rsi%>]="<%=s1%>";
		      CounName[<%=rsi%>]=new Array();			    
		      CounCode[<%=rsi%>]=new Array();
		     </script>
           <%   		   		   		   		  			
			 countryRs=countryStmt.executeQuery("select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y where REGION='"+s1+"' and x.LOCALE=y.LOCALE  order by LOCALE_ENG_NAME");  
		     while (countryRs.next())
		     {
		       String cn1=(String)countryRs.getString(1);//國別代碼 	 
			   String cn2=(String)countryRs.getString(2); //國家名稱
			   %>
               <script language="JavaScript" type="text/JavaScript">			    
		        CounName[<%=rsi%>][<%=cci%>]="<%=cn2%>";			    
		        CounCode[<%=rsi%>][<%=cci%>]="<%=cn1%>";
		       </script>
               <%			 			 
			   cci++;
		     }	 
		     countryRs.close();
		     rsi++;
           } //end of while
		   rs.close();    
		   statement.close();
		   countryStmt.close();  
		   
		   arrayComboBoxBean.setArrayString(regionArray); 
		   arrayComboBoxBean.setSelection(regionNo);    
		   arrayComboBoxBean.setOnChangeJS("showCountry(document.MYFORM.COUNTRY.length)");
	       arrayComboBoxBean.setFieldName("REGION");
	       out.println(arrayComboBoxBean.getArrayString());		  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>  
      </td>
      <td colspan="2"> <font color="#333399" face="Arial Black"><strong>Country</strong></font>
	  <BR> 
        <% 		 		 		 
	     try
         {   
		     out.println("<select NAME='COUNTRY'>");
             out.println("<OPTION VALUE='--'>--");  		 
		     out.println("</select>");		  
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %> 
	 </td>  
	  <td width="8%" colspan="2"><input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/WSForecastInput.jsp","../jsp/WSForeSalesInput.jsp")'>
</td> 
	</tr>	
	<tr>
	    <td colspan="6"><div align="right"><strong><font color="#FF0000">SET THE FORECAST DATE-&gt;</font></strong><font color="#333399" face="Arial Black"><strong>Year</strong></font>
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
      </div></td>
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
