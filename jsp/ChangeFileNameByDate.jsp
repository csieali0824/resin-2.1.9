<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,ArrayComboBoxBean,RsBean" %>
<!--=============To get the Authentication==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============??????????==========-->

<!--=================================-->
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
 document.MYFORM.action=URL;
 document.MYFORM.submit();
}
</script>
<jsp:useBean id="rsBean" scope="session" class="RsBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<html>
<head>
<title>MicroJet Employee Daily On-off Data Transfer</title>
</head>
<body>
<div align="center"><img src="../image/Microjet_logo.gif"></div><BR>
<font size="+2" face="Times New Roman, Times, serif"><strong><em><font color="#66CC99" size="+2" face="Arial black">DBTEL</font></em>總公司研能人員出勤資料手動結轉</strong></font>
<FORM ACTION="../jsp/ChangeFileName.jsp" METHOD="post" NAME="MYFORM">  
 <%
   int rs1__numRows = 25;
   int rs1__index = 0;
   int rs_numRows = 0;
   rs_numRows += rs1__numRows;
   //
   boolean getDataFlag = false;
 %>
    
  &nbsp;
    <%     
  String MM_moveFirst="",MM_moveLast="",MM_moveNext="",MM_movePrev="";
  //String compNo=request.getParameter("COMPNO");
  String type=request.getParameter("TYPE");
  //String regionNo=request.getParameter("REGION");
  String locale=request.getParameter("LOCALE"); 
  String YearFr=request.getParameter("YEARFR");
  String MonthFr=request.getParameter("MONTHFR");
  String DayFr=request.getParameter("DAYFR");
  String dateStringBegin=YearFr+MonthFr+DayFr;


  
  String StoreNo="";
  String storeNo =request.getParameter("STORE_NO"); 
  //String imei =request.getParameter("IMEI"); 
 
 //if ( storeNo == null )  { storeNo = "001"; }
 
  int numRow = 0;
  /*
   
    String sql = "select ACTCENTERNO, ACTLOCALE from WSSHIPPER where USERNAME='"+UserName+"' ";	
	Statement stateShip=con.createStatement();
	ResultSet rsShip=stateShip.executeQuery(sql);
	if (rsShip.next())
	{ 
	   StoreNo = rsShip.getString("ACTCENTERNO"); 
	   locale = rsShip.getString("ACTLOCALE"); 
	}
	else
	{
	   out.println("You have no authority !!");
	   out.println(UserName);
	}
	rsShip.close();
	stateShip.close();
  */
%>      
	<BR>  
	<A HREF="/wins/WinsMainMenu.jsp">回首頁</A> 
    <table width="40%">
     <tr bgcolor="#D0FFFF"> 	
      <td width="78%" valign="top" bordercolor="#CCCCCC" bgcolor="#CCEEFF"> <font color="#CC3366" face="Arial Black"><strong>出勤日期</strong></font> 
        <%
		  String CurrYear = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearFr==null)
		  {
		    CurrYear=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYear);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearFr);
		  }
	      arrayComboBoxBean.setFieldName("YEARFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
        <font color="#CC3366" face="Arial Black">&nbsp;</font>
        <%
		  String CurrMonth = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthFr==null)
		  {
		    CurrMonth=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonth);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthFr);
		  }
	      arrayComboBoxBean.setFieldName("MONTHFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
         <font color="#CC3366" face="Arial Black">&nbsp;</font>
         <%
		  String CurrDay = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayFr==null)
		  {
		    CurrDay=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDay);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayFr);
		  }
	      arrayComboBoxBean.setFieldName("DAYFR");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>        
	   </td>	        	     
	   <td width="22%" bgcolor="#D0FFFF">
	      <input name="submit1" type="submit" value="Enter" onClick='return setSubmit("../jsp/ChangeFileName.jsp")'>
	   </td>
	</tr>
  </table> 
</FORM>
</body>
<!--=============??????????==========-->

<!--=================================-->
</html>
