<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.io.*" %>
<!--=============To get the Authentication==========-->
<%//@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%//@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="DateBean,RsCountBean" %>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="rsCountBean" scope="application" class="RsCountBean"/>
<!--=============??????????==========-->
<%//@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/ConnBPCSPoolPage.jsp"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{
  flag=confirm("Are you sure you want to update?"); 
  if (flag==0)
  {
    return(false);
  } else {
    document.MYFORM.action=URL;
    document.MYFORM.submit();
  }  
}
</script>
<html>
<head>
<title>每月新增客戶資料表 </title>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body>
<%
 Statement statement=bpcscon.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_UPDATABLE);
 ResultSet rs=null;
%>
<FORM NAME="MYFORM" ACTION="BpcsNewCustomerQueryNoAuth.jsp" METHOD="post">
  <%
int type_Count=0,customer_Count=0; //to count the number of country and model
int maxrow=0;
String customerCode="",typeCode="";
String new_Customer_Array[][]=null;
String customer_Count_Array[][]=null;

//String a[][]={{"YES","NO"},{"Y","N"}};	//first Dimension means the selection Name,and second Dimension means the selection value
//arrayComboBoxBean.setArrayString2D();  
//arrayComboBoxBean.setNoNull("Y");     		    	  
	  dateBean.setAdjMonth(-1);
	  String DateBegin=dateBean.getYearString()+dateBean.getMonthString()+"01"; 
	  String DateEnd=dateBean.getYearString()+dateBean.getMonthString()+"31";
try
{   
  String sSql = "",sWhere = "",sOrder="";
  
 // sSql = "select unique LOCALE_ENG_NAME,COUNTRY,MODELNO,LAUNCH from AFSMDLTOCOUNTRY,RPLOCALE_T";		  
 // sWhere = " where COUNTRY=LOCALE";
                    //sSql = "Select CTYPE,CCUST,CNME, trim(CAD1)||trim(CAD2)||trim(CAD3) as address,CTXID,CPHON,CSAL,CTERM,CCON,CPHON "+" "+
                          // " from rcm" ; 
 sSql = "Select CTYPE,CTDESC,CCUST,CNME, trim(CAD1)||trim(CAD2)||trim(CAD3) as address,CTXID,CPHON,CSAL,SNAME,CTERM,TMDESC,CCON,CPHON "+" "+
        " From rcm,rct,ssm,rtm" ; 								 		  
 sWhere  = " WHERE  CTYPE=CTCSTP and CCURR=CTCURR AND CTID='CT' "+" "+
           " AND CSAL=SSAL "+" "+
		   " AND CTERM=TMTERM and TMID='TM'  "+" "+
           " AND (CFRDA between " +DateBegin+ "AND  "+DateEnd+" ) "; 
  	
  //if (country!=null && !country.equals("--") ) sWhere=sWhere+" and COUNTRY='"+country+"'";	
  sOrder=" order by CTYPE";                 		 
  
  sSql = sSql+sWhere+sOrder;		  
  //out.println(sSql); 
  rs=statement.executeQuery(sSql);
  rsCountBean.setRs(rs); 
  maxrow=rsCountBean.getRsCount();  
  //out.println(maxrow); 
  
  if (maxrow>0)
  {
     new_Customer_Array=new String[maxrow][13];
	 int ac=0;
	 while (rs.next())
     {
       if (!typeCode.equals(rs.getString("CTYPE"))) 
  	   {
	     type_Count++;
		  //out.println(type_Count); 
	   }  
	   
	   typeCode=rs.getString("CTYPE");	  
	   new_Customer_Array[ac][0]=typeCode;
	   new_Customer_Array[ac][1]=rs.getString("CTDESC");
	   new_Customer_Array[ac][2]=rs.getString("CCUST");
	   new_Customer_Array[ac][3]=rs.getString("CNME");
	   new_Customer_Array[ac][4]=rs.getString("address");
	   new_Customer_Array[ac][5]=rs.getString("CTXID");
	   new_Customer_Array[ac][6]=rs.getString("CPHON");
	   new_Customer_Array[ac][7]=rs.getString("CSAL");
	   new_Customer_Array[ac][8]=rs.getString("SNAME");
	   new_Customer_Array[ac][9]=rs.getString("CTERM");
	   new_Customer_Array[ac][10]=rs.getString("TMDESC");
	   new_Customer_Array[ac][11]=rs.getString("CCON");
	   new_Customer_Array[ac][12]=rs.getString("CPHON");
	   ac++;
     }  //end of rs while
	 rs.close();
	 //out.println(type_Count); 
	 typeCode=new_Customer_Array[0][0];
	 //countryName=new_Customer_Array[0][1];	 
	 customer_Count_Array=new String[type_Count][13];
	 
	 int cc=0;
	 for (int i=0;i<new_Customer_Array.length;i++)
	 { //out.println(new_Customer_Array[i][1]); 
	   if (typeCode.equals(new_Customer_Array[i][0])) 
  	   { 

		   if (!customerCode.equals(new_Customer_Array[i][2])) 
		   {			
			 customer_Count++;
		   }
		  // out.println(customer_Count);
		   customerCode=new_Customer_Array[i][2];
	   } else {
	     customer_Count_Array[cc][0]=typeCode;
		 //customer_Count_Array[cc][1]=countryName;
	     customer_Count_Array[cc][2]=String.valueOf(customer_Count);
		 customerCode="";		 
         customer_Count=1;
		 cc++;
	   }	   	   	   
	   typeCode=new_Customer_Array[i][0];
	   //countryName=new_Customer_Array[i][1];
	 }// end of new_Customer_Array for 	
	 customer_Count_Array[cc][0]=typeCode;
	 //customer_Count_Array[cc][1]=countryName;
	 customer_Count_Array[cc][2]=String.valueOf(customer_Count);
  }  //end of maxrow if    		 		 
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());		  
}
%>
  <strong><font color="#006699" size="+1" face="Arial, Helvetica, sans-serif">每月新增客戶資料表</font></strong> 
  <%
int arrayIdx=0;
try 
{
  if (maxrow>0)
  {
%> 
  <table width="975" border="1" cellspacing="0">
    <tr bgcolor="#CCCCCC"> 
      <td width="74" bgcolor="#FFFFCC"><strong>Type</strong></td>
      <td width="157" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>客戶 
        </strong></font></td>
      <td width="223" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>地址</strong></font></td>
      <td width="79" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>統編</strong></font></td>
      <td width="78" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>電話</strong></font></td>
      <td width="79" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>業務員</strong></font></td>
      <td width="76" height="25" nowrap bgcolor="#FFFFCC"><font size="2"><strong>Term</strong></font></td>
      <td width="80" nowrap bgcolor="#FFFFCC"><font size="2"><strong>聯絡人</strong></font></td>
      <td width="91" nowrap bgcolor="#FFFFCC"><font size="2"><strong>聯絡人電話</strong></font></td>
    </tr>
    <%
	  for (int i=0;i<customer_Count_Array.length;i++)
	  {	     
	%>
    <tr> 
      <td rowspan=<%=customer_Count_Array[i][2]%>><font  color="#FF0000" size="2"><%=customer_Count_Array[i][0]%></font><font size="2"><%=new_Customer_Array[arrayIdx][1]%></font></td>
      <td><font  color="#FF0000" size="2"><%=new_Customer_Array[arrayIdx][2]%></font><font size="2"><%=new_Customer_Array[arrayIdx][3]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][4]%></font></td>
      <td><font size="2"> 
        <%
	  if(new_Customer_Array[arrayIdx][5].equals(null) || new_Customer_Array[arrayIdx][5].equals("") )
	  {out.println("--");}
	  else 
	  { out.println(new_Customer_Array[arrayIdx][5]); }
	  %>
        </font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][6]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][7]%><%=new_Customer_Array[arrayIdx][8]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][9]%><%=new_Customer_Array[arrayIdx][10]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][11]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][12]%></font></td>
    </tr>
    <%
		arrayIdx++;
		for (int j=1;j<Integer.parseInt(customer_Count_Array[i][2]);j++)
		{		  
	  %>
    <tr> 
      <td><font  color="#FF0000" size="2"><%=new_Customer_Array[arrayIdx][2]%></font><font size="2"><%=new_Customer_Array[arrayIdx][3]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][4]%></font></td>
      <td><font size="2"> 
        <%
	  if(new_Customer_Array[arrayIdx][5]!=null || !new_Customer_Array[arrayIdx][5].equals(null))
	  {out.println(new_Customer_Array[arrayIdx][5]) ;}
	  else 
	  { out.println("--"); }
	  %>
        </font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][6]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][7]%><%=new_Customer_Array[arrayIdx][8]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][9]%><%=new_Customer_Array[arrayIdx][10]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][11]%></font></td>
      <td><font size="2"><%=new_Customer_Array[arrayIdx][12]%></font></td>
    </tr>
    <%
		 arrayIdx++;
		} //end of arrayIdx for
	  } //end of country_Count_Array for
   } else {
      out.println("There is no record found!!");	  
   } //end of maxrow>0 if	  
} //end of try
catch (Exception e)
{
  out.println("Exception:"+e.getMessage());		  
}  

%>
  </table>
<%
 statement.close();
%>
</FORM>
<!--=============??????????==========-->
<%//@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ReleaseConnBPCSPage.jsp"%>
</body>
</html>


