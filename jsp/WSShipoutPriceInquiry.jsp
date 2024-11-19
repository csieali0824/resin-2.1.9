<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ArrayComboBoxBean,ComboBoxBean,DateBean,java.text.DecimalFormat" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSDbglobalPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
 rstart();
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
function rstart2(){
	showimage.style.visibility = '';
	blockDiv.style.display = '';
	init();
	slide();
	location.href='WSShipoutPriceCalculation.jsp';
}
</script>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="thisDateBean" scope="session" class="DateBean"/> <!--用來抓出目前為幾月-->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Monthly SHip-out Price Inquery</title>
</head>
<body>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<FORM ACTION="WSShipoutPriceInquery.jsp" METHOD="post" NAME="MYFORM" onSubmit="rstart()">
<%   
String vYear=request.getParameter("VYEAR");
if (vYear==null) vYear=dateBean.getYearString();
String vMonth=request.getParameter("VMONTH");
if (vMonth==null) vMonth=dateBean.getMonthString();
dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1); 
String model=request.getParameter("MODEL");
String region=request.getParameter("REGION");
String country=request.getParameter("COUNTRY");  
String selCurr=request.getParameter("SELCURR");  //選用之?別  
String curr="";  //PRICE PLAN之幣別計算基準都以BASE COUNTRY之幣別為準
String ymh1="",ymh2="",ymh3="",ymh4="",ymh5="",ymh6="",ymh7="",ymh8="",ymh9="",ymh10="",ymh11="",ymh12="";
String ymArray[]=new String[12];
DecimalFormat df=new DecimalFormat(",000");
try
{
  //取得base country幣別
  Statement currStmt=con.createStatement(); 
  ResultSet currRs=currStmt.executeQuery("select CURR from PSALES_COUNTRY_FACTOR where COUNTRY=(select unique BASECOUNTRY from PSALES_COUNTRY_FACTOR)");
  if (currRs.next()) curr=currRs.getString("CURR");
  if (selCurr==null || selCurr.equals("--")) //若沒有指定選用幣別則以base country之幣別為預設值
  {
    selCurr=curr;
  }
  currRs.close();
  currStmt.close();
}
catch (Exception e)
{
 out.println("Exception:"+e.getMessage());
}
%>
<table width="100%" border="0">
    <tr bgcolor="#D0FFFF">
      <td width="12%" bordercolor="#FFFFFF"><font color="#333399" face="Arial Black"><strong>Year</strong></font>
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
        <font color="#330099" face="Arial Black"><strong></strong></font><font color="#330099" size="2" face="Arial Black">&nbsp;</font> </td> 
      <td width="12%" height="23" bordercolor="#FFFFFF"> 
        <p><font color="#330099" size="2" face="Arial Black"></font><font color="#330099" face="Arial Black"><strong>Month</strong></font>
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
      </td>
      <td width="17%"><font color="#333399" size="2" face="Arial Black"><strong>Region: 
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
		  
		  out.println("<select NAME='REGION' onChange='setSubmit("+'"'+"../jsp/WSShipoutPriceInquery.jsp"+'"'+")'>");
          out.println("<OPTION VALUE=-->--");     
          while (rs.next())
          {            
           String s1=(String)rs.getString(1); 
           String s2=(String)rs.getString(2); 
                        
            if (s1.equals(region)) 
           {
              out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2);                                     
            } else {
              out.println("<OPTION VALUE='"+s1+"'>"+s2);
            }        
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
</strong></font>        
      </td>
      <td width="26%"><font size="2"><font color="#333399" face="Arial Black"><strong>Country:
        <% 		 		 		 
	     try
         {   
		  String sSql = "";
		  String sWhere = "";
		  
		  sSql = "select x.LOCALE, LOCALE_ENG_NAME from WSREGION x,WSLOCALE y";		  
		  sWhere = " where REGION='"+region+"' and x.LOCALE=y.LOCALE  order by LOCALE_ENG_NAME";		              
		  sSql = sSql+sWhere;
		  
		  //out.println(sSqlRCenter);		      
          Statement statement=con.createStatement();
          ResultSet rs=statement.executeQuery(sSql);
          comboBoxBean.setRs(rs);		  		 
		  if (country!=null) comboBoxBean.setSelection(country);
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
      </strong></font></font></td>
      <td width="24%">
        <font color="#330099" face="Arial Black"><strong>Model</strong></font><font size="2">
        <%	    	     		 		 
	     try
         {		 
		  String sSqlC = "";
		  String sWhereC = "";		  
		  		             		 
		  sSqlC = "select trim(INTER_MODEL) as x,trim(INTER_MODEL) from PSALES_PROD_CENTER ";		  
		  sWhereC= "where INTER_MODEL IS NOT NULL order by x";	
		  sSqlC = sSqlC+sWhereC;		  
		  		      
          Statement statementC=con.createStatement();
          ResultSet rsC=statementC.executeQuery(sSqlC);
          comboBoxBean.setRs(rsC);
		  if ( model!=null && !model.equals("--"))  comboBoxBean.setSelection(model);		  		  		  
	      comboBoxBean.setFieldName("MODEL");	   
          out.println(comboBoxBean.getRsString());
		 
          rsC.close();      
		  statementC.close();		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }			
	   %>
        </font></td>
      <td width="9%"><font color="#333399" face="Arial Black"><strong>Currency</strong></font>
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
		  comboBoxBean.setSelection(selCurr); 		  	
	      comboBoxBean.setFieldName("SELCURR");	   
          out.println(comboBoxBean.getRsString());		  
          rs.close();    
		  statement.close();  		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());		  
         }
       %></td>
      <td width="9%"><font size="2"> <font color="#333399" face="Arial Black"><strong>	   </strong></font>
        <INPUT TYPE="submit"  value="Inquery"><BR>
	 <% 
	    if (UserRoles.indexOf("admin")>=0)
	   {
   	      out.println("<input name='button' type=button onclick='rstart2()' value='計算出廠價'> ");
	   }  
	 %>				
	  </font></td>     
  </tr>
</table>
<font color="#54A7A7" face="Times New Roman" size="5"><STRONG>DBTEL</font><font color="#000000" size="5" face="Times New Roman"> <strong>Ship-out
 Price Inquery</strong></font>
 <font color="#000000" size="+2" face="Times New Roman"><strong> </strong></font> &nbsp; &nbsp; &nbsp; &nbsp;<A HREF="../WinsMainMenu.jsp">HOME</A>&nbsp;&nbsp;&nbsp;&nbsp;<A HREF="../jsp/WSForecastMenu.jsp">Back
to submenu</A>
<%  
out.println("<BR><font color='#330099' face='Times New Roman' size='4'><strong>This Month is :"+thisDateBean.getYearString()+"/"+thisDateBean.getMonthString()+"&nbsp;&nbsp;&nbsp;&nbsp;Currency:"+curr+"</strong></font>");
try 
{  
  dateBean.setDate(Integer.parseInt(vYear),Integer.parseInt(vMonth),1);//將日期調回初始值
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}  
%>
<BR>
<table width="100%" border="1" cellspacing="0" cellpadding="0">
  <tr>      
      <td width="6%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Int. Model</font></strong></td>
	  <td width="6%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Ext. Model</font></strong></td>
	  <td width="10%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Country</font></strong></td>
	  <td width="8%" bgcolor="#FFFFCC"><strong><font face="Times New Roman">Region</font></strong></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font face="Times New Roman">
          <%
		ymh1=dateBean.getYearString()+"/"+dateBean.getMonthString();
		ymArray[0]=dateBean.getYearString()+dateBean.getMonthString();
		out.println(ymh1);
		%>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font face="Times New Roman">
	    <%dateBean.setAdjMonth(1);
	  ymh2=dateBean.getYearString()+"/"+dateBean.getMonthString();
	  ymArray[1]=dateBean.getYearString()+dateBean.getMonthString();
	  out.println(ymh2);
	  %>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh3=dateBean.getYearString()+"/"+dateBean.getMonthString();
		ymArray[2]=dateBean.getYearString()+dateBean.getMonthString();
	    out.println(ymh3);
	  %>
      </font></strong></div></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh4=dateBean.getYearString()+"/"+dateBean.getMonthString();
		ymArray[3]=dateBean.getYearString()+dateBean.getMonthString();
	  out.println(ymh4);
	  %>
      </font></strong></div></td> 
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		ymh5=dateBean.getYearString()+"/"+dateBean.getMonthString();
		ymArray[4]=dateBean.getYearString()+dateBean.getMonthString();
	    out.println(ymh5);
	  %>
      </font></strong></div></td> 
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
          <%dateBean.setAdjMonth(1);
		 ymh6=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[5]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh6);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh7=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[6]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh7);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font   face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh8=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[7]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh8);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh9=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[8]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh9);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh10=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[9]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh10);
	 %>
      </font></strong></div></td>
	  <td width="6%" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh11=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[10]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh11);
	 %>
      </font></strong></div></td>
	  <td width="6%" colspan="1" bgcolor="#FFFFCC"><div align="center"><strong><font  face="Times New Roman">
	      <%dateBean.setAdjMonth(1);
		 ymh12=dateBean.getYearString()+"/"+dateBean.getMonthString();
		 ymArray[11]=dateBean.getYearString()+dateBean.getMonthString();
         out.println(ymh12);
	 %>
      </font></strong></div></td>	  
    </tr>	
<%	
String interModel="";
String ex_rate="0";
try 
{ 
  String  countrySql="",countryWhere="",countryOrder;  
  Statement countryStmt=con.createStatement();
  countrySql="select count (*) from PSALES_COUNTRY_FACTOR,WSLOCALE";
  countryWhere=" where COUNTRY=LOCALE";
  if (region!=null && !region.equals("--")) countryWhere=countryWhere+" and REGION='"+region+"'";
  if (country!=null && !country.equals("--")) countryWhere=countryWhere+" and COUNTRY='"+country+"'"; 
  countrySql=countrySql+countryWhere; 
  ResultSet countryRs=countryStmt.executeQuery(countrySql); 
  int arrayIdx=0;
  if (countryRs.next()) 
  {
   arrayIdx=countryRs.getInt(1);      
  }   
  String countryArray[][]=new String[arrayIdx][3]; 
  String countryArrayString="''";
  countryRs.close();
  countrySql="select LOCALE_NAME,REGION,COUNTRY from PSALES_COUNTRY_FACTOR,WSLOCALE";
  countryWhere=" where COUNTRY=LOCALE";
  if (region!=null && !region.equals("--")) countryWhere=countryWhere+" and REGION='"+region+"'";
  if (country!=null && !country.equals("--")) countryWhere=countryWhere+" and COUNTRY='"+country+"'";  
  countryOrder=" order by REGION,COUNTRY";
  countrySql=countrySql+countryWhere+countryOrder; 
  countryRs=countryStmt.executeQuery(countrySql); 
  int countryCount=0;  
  while (countryRs.next())
  {    
    countryArray[countryCount][0]=countryRs.getString("COUNTRY");
	countryArrayString=countryArrayString+",'"+countryRs.getString("COUNTRY")+"'";
	countryArray[countryCount][1]=countryRs.getString("LOCALE_NAME");
	countryArray[countryCount][2]=countryRs.getString("REGION");	
	countryCount++;
  }  
  countryRs.close();
  countryStmt.close();
  
  //$$$$$$$$$$$$$$$$$$$$4取得基準國CURRENCY及選用之CURRENCY之匯率$$$$$$$$$$$$$   
  if (curr.equals(selCurr))
  {
    ex_rate="1"; //若選用幣別與base country之幣別同,則匯率為1
  } else {	
    Statement exStmt=ifxdbglobalcon.createStatement();     
    ResultSet exRs=exStmt.executeQuery("select CCNVFC,CCNVDT FROM GCC where CCFRCR='"+curr+"' and CCTOCR='"+selCurr+"' order by CCNVDT DESC");  
      if (exRs.next()) 
	  { 
   	    ex_rate=exRs.getString("CCNVFC"); //各選用幣別對basecountry幣別之匯率	
	  }
	 
    exRs.close();  
    exStmt.close(); 
  }	
  //$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$   
  
  String sSql = "",subSql="";
  String sWhere = "",subWhere="";
  String sOrder = "",subOrder="";   
  int exw_price=0; //EXW PRICE
  String brand="";
		  
  sSql = "select trim(INTER_MODEL) as INTERMODEL,EXT_MODEL,x.BRAND from PSALES_PROD_CENTER x,PIBRAND y";
  sWhere = " where x.BRAND=y.BRAND";
  if (model!=null && !model.equals("--")) sWhere = sWhere+" and trim(INTER_MODEL)='"+model+"'";	  
  sOrder = " order by x.BRAND,INTERMODEL";		 
  sSql = sSql+sWhere+sOrder;		
 		  		      
  Statement statement=con.createStatement();  
  ResultSet rs=statement.executeQuery(sSql); 
  Statement subStmt=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);	  
  ResultSet subRs=null;  
  
  while (rs.next())
  {         
   out.println("<TR>"); 
   interModel=rs.getString("INTERMODEL");
   brand=rs.getString("BRAND");  
   if (brand.equals("DBTEL")) 
   {
    out.println("<TD><font face='Times New Roman'>"+interModel+"</font></TD>"); 
    out.println("<TD><font face='Times New Roman'>"+rs.getString("EXT_MODEL")+"</font></TD>");   
   } else {
    out.println("<TD BGCOLOR=FFE4E1><font face='Times New Roman'>"+interModel+"</font></TD>"); 
    out.println("<TD BGCOLOR=FFE4E1><font face='Times New Roman'>"+rs.getString("EXT_MODEL")+"</font></TD>"); 
   }   
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	  	 	   
	  out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][1]+"</FONT></TD></TR>");	  	  		  
	} //end of countryArray for	
	out.println("</TABLE></TD>");
	
   out.println("<TD><TABLE border=0>");
   for (int cac=0;cac<countryArray.length;cac++)
	{	  	 	   
	  out.println("<TR><TD><FONT face='Times New Roman'>"+countryArray[cac][2]+"</FONT></TD></TR>");	  	  		  
	} //end of countryArray for	
	out.println("</TABLE></TD>");	
	          	  
   subSql="select max(SPMVER),SPYEAR,SPMONTH,SPREG,SPCOUN,SPPRI from PSALES_SHIPOUT_PRICE a"; 	 	 	
   subWhere=" where spmver = (select max(spmver) from PSALES_SHIPOUT_PRICE b where a.spprjcd=b.spprjcd and a.spyear=b.spyear and a.spmonth=b.spmonth and a.spreg=b.spreg and a.spcoun=b.spcoun )  and SPCURR='"+curr+"' and SPCOUN in ("+countryArrayString+") and SPPRJCD='"+interModel+"' and SPYEAR||'/'||SPMONTH between '"+ymh1+"' and '"+ymh12+"' group by SPREG,SPCOUN,SPPRI,SPYEAR,SPMONTH order by SPYEAR,SPMONTH,SPREG,SPCOUN"; 
   subSql=subSql+subWhere;
   subRs=subStmt.executeQuery(subSql); 
   String isEOF="N";  
   if (subRs.next()) 
   {   
     for (int ymc=0;ymc<ymArray.length;ymc++) 
	 {
       if (isEOF.equals("N") && ymArray[ymc].equals(subRs.getString("SPYEAR")+subRs.getString("SPMONTH")))    
	   {
	     out.println("<TD><TABLE border=0>");  
         for (int cac=0;cac<countryArray.length;cac++)
         {	     	   
	        if (isEOF.equals("N") && countryArray[cac][0].equals(subRs.getString("SPCOUN")))
	        {	   
	          exw_price=Math.round(subRs.getInt("SPPRI")*Float.parseFloat(ex_rate));  	      	   	   
	          if (subRs.next())
			  {
			  } else {			  
			   isEOF="Y"; //to determine if EOF			  
			  } 
	        } else {			 
	            exw_price=0;			  	          
	        }	 			 	 	   	 
	        if (exw_price>0)
	        {
			  String exw_price_str="";
			  if (exw_price<1000)
			  {
			     exw_price_str=String.valueOf(exw_price);
			  } else {
			    exw_price_str=df.format(exw_price);
			  }			
	          out.println("<TR><TD align='right'><FONT face='Times New Roman'>"+exw_price_str+"</FONT></TD></TR>");	     
	        } else {  
	          out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
	        } 
	     } //end of countryArray for					 		
	     out.println("</TABLE></TD>");
	  } else {
	    out.println("<TD><TABLE border=0>"); 
        for (int cac=0;cac<countryArray.length;cac++)
        {
	      out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
  	    }
	    out.println("</TABLE></TD>");
	  }
	  //END of  ymh1 if  
	} //end of  ymArray for	
  } else {
    for (int ymc=0;ymc<ymArray.length;ymc++)
	{
      out.println("<TD><TABLE border=0>"); 
      for (int cac=0;cac<countryArray.length;cac++)
      {
	    out.println("<TR><TD><FONT face='Times New Roman'>--</FONT></TD></TR>");
  	  }
	  out.println("</TABLE></TD>");
	}  
  }  //end of subRs if	
  subRs.close();
  			  
    out.println("</TR>"); //main table end	
  } //end of rs.next While     
  rs.close();   
  subStmt.close();
  statement.close();
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());
}   
%>  
</TABLE> 
<BR>	
</FORM>   
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSDbglobalPage.jsp"%>
</html>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>