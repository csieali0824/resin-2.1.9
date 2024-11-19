<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<%@ page import="ComboBoxBean" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<html>
<head>
<title>Country Factor Edit Form</title>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<body>
<%
String country=request.getParameter("COUNTRY");
String countryName="";
String baseCountry="",region="",brand="",exw_adj="",vat="",ll_basecoun="",ll_coun_adj="",ex_rate="",curr="";
      try
      {       	
	   Statement docstatement=con.createStatement();
       ResultSet docrs=docstatement.executeQuery("select * from PSALES_COUNTRY_FACTOR WHERE COUNTRY='"+country+"'");
       docrs.next();
	   baseCountry=docrs.getString("BASECOUNTRY");
	   region=docrs.getString("REGION");	   
	   brand=docrs.getString("BRAND");
	   exw_adj=docrs.getString("EXW_ADJ");
	   vat=docrs.getString("VAT");
	   ll_basecoun=docrs.getString("LL_BASECOUN");
	   ll_coun_adj=docrs.getString("LL_COUN_ADJ");
	   ex_rate=docrs.getString("EX_RATE");
	   curr=docrs.getString("CURR");
	   
        docrs.close();           
	    docrs=docstatement.executeQuery("select LOCALE_NAME from WSLOCALE WHERE LOCALE='"+country+"'");
	    docrs.next();     	   
		countryName=docrs.getString("LOCALE_NAME");
		docrs.close();
		docstatement.close();
       } //end of try
       catch (Exception e)
       {
        out.println("Exception:"+e.getMessage());
       }
%>
<FORM ACTION="../jsp/WSCountryFactorUpdate.jsp?COUNTRY=<%=country%>" METHOD="post">
<font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#54A7A7" size="+2" face="Arial Black">DBTEL</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#000000" size="+2" face="Times New Roman"> 
<strong> Sales Forecast Country Factors</strong></font><BR>
<%=countryName%> 
&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="/wins/WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back to submenu</A> 
<BR>
  <table width="88%" border="1">
    <tr> 
      <td width="29%">REGION:
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
		  comboBoxBean.setSelection(region);   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %>         
      <td width="31%">BRAND:
      <% 		
	     try
         {   
		  String sSql = "";		 
		  sSql = "select BRAND,BRAND from PIBRAND "; 		  		 		 		  
		
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		  
	      comboBoxBean.setFieldName("BRAND");	
		  comboBoxBean.setSelection(brand);   
          out.println(comboBoxBean.getRsString());		 
          rs.close();      
		  statement.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td width="40%">BASE COUNTRY:        
      <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where x.LOCALE=y.LOCALE order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 		  
	      comboBoxBean.setFieldName("BASECOUNTRY");	
		  comboBoxBean.setSelection(baseCountry);	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
    </tr>
    <tr>
      <td>S/O Price . Adjust: 
        <INPUT TYPE="text" NAME="EXW_ADJ" VALUE="<%=exw_adj%>" size="10"></td>
      <td>L&amp;L China:
      <INPUT TYPE="text" NAME="LL_BASECOUN" VALUE="<%=ll_basecoun%>" size="10"></td>
      <td>L&amp;L  Adjust:
      <INPUT TYPE="text" NAME="LL_COUN_ADJ" VALUE="<%=ll_coun_adj%>" size="10"></td>
    </tr>
    <tr> 
      <td>VAT(%): 
        <INPUT TYPE="text" NAME="VAT" VALUE="<%=(int)(Float.parseFloat(vat)*100)%>" SIZE=10></td>
      <td>Ex. Rate:
      <INPUT TYPE="text" NAME="EX_RATE" VALUE="<%=ex_rate%>" size=16></td>
      <td>Currency: 
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
		  comboBoxBean.setSelection(curr);	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
    </tr>
  </table>  
    <INPUT TYPE="submit" NAME="submit" value="SAVE">	 
  <BR>
  <BR>----------------ALL COUNTRY FACTORS------------------------------------------
  <%  
  try
  {   
   Statement statement=con.createStatement();
   ResultSet rs=statement.executeQuery("select COUNTRY,LOCALE_NAME,REGION,EXW_ADJ,VAT,EX_RATE from PSALES_COUNTRY_FACTOR,WSLOCALE where COUNTRY=LOCALE and COUNTRY!='"+country+"' ORDER BY REGION,COUNTRY");        
      
   out.println("<TABLE>");
   out.println("<TR BGCOLOR=BLACK><TH>&nbsp;</TH><TH><FONT COLOR=WHITE>COUNTRY</FONT></TH><TH><FONT COLOR=WHITE>REGION</FONT></TH><TH><FONT COLOR=WHITE>S/O Price Adj</FONT></TH><TH><FONT COLOR=WHITE>VAT(%)</FONT></TH><TH><FONT COLOR=WHITE>EX. RATE</FONT></TH></TR>");
   String bgcolor="B0E0E6";
   
   while (rs.next())
   {
    if (bgcolor.equals("B0E0E6"))
	{
	 out.println("<TR BGCOLOR=B0E0E6>");
	 bgcolor="ADD8E6";	 
	} else {
	 out.println("<TR BGCOLOR=ADD8E6>");
	 bgcolor="B0E0E6";
	}	    
	 out.println("<TD><A HREF='../jsp/WSCountryFactorEdit.jsp?COUNTRY="+(String)rs.getString(1)+"'><img src='../image/docicon.gif'></A></TD>"); 
     String s=(String)rs.getString(2);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");
	 s=(String)rs.getString(3);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");	 
	 int kf=(int)(rs.getFloat(4)*100);	 
	 kf=kf-100;	 
	 if (kf==0)
	 {
      out.println("<TD><FONT SIZE=2>--</TD>"); //SHIP-OUT PRICE ADJ
	 } else {
	   if (kf>0) out.println("<TD><FONT SIZE=2>+"+(float)(kf*0.01)+"</TD>"); else out.println("<TD BGCOLOR=RED><FONT SIZE=2>"+(float)(kf*0.01)+"</TD>");
	 }
	 float fs=rs.getFloat(5);
     out.println("<TD><FONT SIZE=2>"+(int)(fs*100)+"</TD>"); //VAT
	 s=(String)rs.getString(6);
     out.println("<TD><FONT SIZE=2>"+s+"</TD>");
      
     out.println("</TR>");
    } //end of while
   
   out.println("</TABLE>");
   
   rs.close();
   statement.close();                         
  } //end of try
  catch (Exception e)
  {
   out.println("Exception:"+e.getMessage());
  }
 %>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
