<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean,ArrayComboBoxBean"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>維修系統維修案件資料彙總表</title>
<script language="JavaScript" type="text/JavaScript">
function jamCodeOrderByModel(pp,datebegin,dateend,rpcenter)
{   
  //subWin=window.open("JamCodeOrderbyModelList.jsp?MODEL="+pp+"&DATEBEGIN="+datebegin+"&DATEEND="+dateend+"&REPCENTERNO="+rpcenter,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
  subWin=window.open("JamCodeOrderbyModelPie.jsp?MODEL="+pp+"&DATEBEGIN="+datebegin+"&DATEEND="+dateend+"&REPCENTERNO="+rpcenter,"subwin","width=800,height=600,scrollbars=yes,menubar=no");  
}
flag = false;
function pullDownMenu()
{
 //pdMENU.style.left = event.x;
 //pdMENU.style.top = event.y;
 if (flag) pdMENU.style.visibility = "hidden";
 else      pdMENU.style.visibility = "visible";
 flag = !flag;
 //document.onclick = pullDownMenu;
}
</script>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
</head>
<body>
<FORM ACTION="RepRecordCountInquiry.jsp" METHOD="post">
<%

    String YearFr=request.getParameter("YEARFR");
    String MonthFr=request.getParameter("MONTHFR");
	String DayFr=request.getParameter("DAYFR");
    String dateStringBegin=YearFr+MonthFr+DayFr;
    String YearTo=request.getParameter("YEARTO");
    String MonthTo=request.getParameter("MONTHTO");
    String DayTo=request.getParameter("DAYTO");
    String dateStringEnd=YearTo+MonthTo+DayTo; 
	
	String Model1TP=request.getParameter("MODEL1TP");
	String Model2TP=request.getParameter("MODEL2TP");
	String Model3TP=request.getParameter("MODEL3TP");
	
	String Model1TC=request.getParameter("MODEL1TC");
	String Model2TC=request.getParameter("MODEL2TC");
	String Model3TC=request.getParameter("MODEL3TC");
	
	String Model1KS=request.getParameter("MODEL1KS");
	String Model2KS=request.getParameter("MODEL2KS");
	String Model3KS=request.getParameter("MODEL3KS");
	
	String Model1SUB=request.getParameter("MODEL1SUB");
	String Model2SUB=request.getParameter("MODEL2SUB");
	String Model3SUB=request.getParameter("MODEL3SUB");
	
	if (YearFr==null){dateStringBegin=dateBean.getYearMonthDay();}
	if (YearTo==null){dateStringEnd=dateBean.getYearMonthDay();}
	
	if (Model1TP==null){Model1TP="N/A";}
	if (Model2TP==null){Model2TP="N/A";}
	if (Model3TP==null){Model3TP="N/A";}
	if (Model1TC==null){Model1TC="N/A";}
	if (Model2TC==null){Model2TC="N/A";}
	if (Model3TC==null){Model3TC="N/A";}
	if (Model1KS==null){Model1KS="N/A";}
	if (Model2KS==null){Model2KS="N/A";}
	if (Model3KS==null){Model3KS="N/A";}
	if (Model1SUB==null){Model1SUB="N/A";}
	if (Model2SUB==null){Model2SUB="N/A";}
	if (Model3SUB==null){Model3SUB="N/A";}
	
%>
  <strong><font size="+2"><jsp:getProperty name="rPH" property="pgSalesDRQ"/><jsp:getProperty name="rPH" property="pgRepAreaSummaryReport"/>(<font color="#FF0000"><%=dateStringBegin%></font><jsp:getProperty name="rPH" property="pgTo"/><font color="#FF0000"><%=dateStringEnd%></font>) </font></strong> <BR>
  <BR><A HREF="/oradds/ORADDSMainMenu.jsp"><jsp:getProperty name="rPH" property="pgHome"/></A>  
  <%
    String sSql = "";
    String sSqlCNT = "";
    String sWhere = "";
    String sWhereGP = "";	
    
	
	float fRecordCountTP = 0.0F;
	  int fRepairedTP = 0;
	String RecordCountTP=request.getParameter("RECORDCOUNTTP");
	String RepairedTP=request.getParameter("REPAIREDTP");
	String InRepairingTP=request.getParameter("INREPAIRINGTP");
	//String RepairRateTP=request.getParameter("REPAIRRATETP");
	 float RepairRateTP=0.0F;
	String sRPRateTP="";
	   int idxRpTP=0;
	String WarInTP=request.getParameter("WARINTP");
	String WarOutTP=request.getParameter("WAROUTTP");
	String GenRepTP=request.getParameter("GENREPTP");
	String DoaTP=request.getParameter("DOATP");
	String DapTP=request.getParameter("DAPTP");	
	
	 float fRecordCountTC = 0.0F;
	   int fRepairedTC = 0;
	String RecordCountTC=request.getParameter("RECORDCOUNTTC");
	String RepairedTC=request.getParameter("REPAIREDTC");
	String InRepairingTC=request.getParameter("INREPAIRINGTC");
	//String RepairRateTC=request.getParameter("REPAIRRATETC");
	 float  RepairRateTC=0.0F;
	 String sRPRateTC="";
	   int idxRpTC=0;
	String WarInTC=request.getParameter("WARINTC");
	String WarOutTC=request.getParameter("WAROUTTC");
	String GenRepTC=request.getParameter("GENREPTC");
	String DoaTC=request.getParameter("DOATC");
	String DapTC=request.getParameter("DAPTC");
	
		
	 float fRecordCountKS = 0.0F;
	   int fRepairedKS = 0;
	String RecordCountKS=request.getParameter("RECORDCOUNTKS");
	String RepairedKS=request.getParameter("REPAIREDKS");
	String InRepairingKS=request.getParameter("INREPAIRINGKS");
	//String RepairRateKS=request.getParameter("REPAIRRATEKS");
	 float RepairRateKS=0.0F;
	 String sRPRateKS="";
	   int idxRpKS=0;
	String WarInKS=request.getParameter("WARINKS");
	String WarOutKS=request.getParameter("WAROUTKS");
	String GenRepKS=request.getParameter("GENREPKS");
	String DoaKS=request.getParameter("DOAKS");
	String DapKS=request.getParameter("DAPKS");
	
	
	 float fRecordCountSUB = 0.0F;
	   int fRepairedSUB = 0;
	String RecordCountSUB=request.getParameter("RECORDCOUNTSUB");
	String RepairedSUB=request.getParameter("REPAIREDSUB");
	String InRepairingSUB=request.getParameter("INREPAIRINGSUB");
	//String RepairRateSUB=request.getParameter("REPAIRRATESUB");
	 float RepairRateSUB=0.0F;
	 String sRPRateSUB="";
	   int idxRpSUB=0;
	String WarInSUB=request.getParameter("WARINSUB");
	String WarOutSUB=request.getParameter("WAROUTSUB");
	String GenRepSUB=request.getParameter("GENREPSUB");
	String DoaSUB=request.getParameter("DOASUB");
	String DapSUB=request.getParameter("DAPSUB");
	
	
	 float RepairRateAVR = 0.0F;
	 String sRPRateAVR="";
	   int idxRpAVR=0;
	
  %>
  
  <table width="100%">
    <tr> 
      <td width="518" height="26" valign="top" bordercolor="#CCCCCC" bgcolor="#CCEEFF">
	  <font face="arial"><jsp:getProperty name="rPH" property="pgDateFr"/></font> 
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
       <font face="arial"><jsp:getProperty name="rPH" property="pgDateTo"/></font>
        <%
		  String CurrYearTo = null;	     		 
	     try
         {       
          String a[]={"2002","2003","2004","2005","2006","2007","2008","2009","2010"};
          arrayComboBoxBean.setArrayString(a);
		  if (YearTo==null)
		  {
		    CurrYearTo=dateBean.getYearString();
		    arrayComboBoxBean.setSelection(CurrYearTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(YearTo);
		  }
	      arrayComboBoxBean.setFieldName("YEARTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
       <%
		  String CurrMonthTo = null;	     		 
	     try
         {       
          String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          arrayComboBoxBean.setArrayString(b);
		  if (MonthTo==null)
		  {
		    CurrMonthTo=dateBean.getMonthString();
		    arrayComboBoxBean.setSelection(CurrMonthTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(MonthTo);
		  }
	      arrayComboBoxBean.setFieldName("MONTHTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>
	   <%
		  String CurrDayTo = null;	     		 
	     try
         {       
          String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          arrayComboBoxBean.setArrayString(c);
		  if (DayTo==null)
		  {
		    CurrDayTo=dateBean.getDayString();
		    arrayComboBoxBean.setSelection(CurrDayTo);
		  } 
		  else 
		  {
		    arrayComboBoxBean.setSelection(DayTo);
		  }
	      arrayComboBoxBean.setFieldName("DAYTO");	   
          out.println(arrayComboBoxBean.getArrayString());		      		 
         } //end of try
         catch (Exception e)
         {
          out.println("Exception:"+e.getMessage());
         }
       %>              
      <td width="217" bgcolor="#CCEEFF" align="left"> <input name="Query" type="button" value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSSDRQInformationQuery.jsp")'> 
	  <%
	    
		if (dateStringBegin.equals(null)){dateStringBegin=dateBean.getYearMonthDay();}
	    if (dateStringEnd.equals(null)){dateStringEnd=dateBean.getYearMonthDay();}
		
	    try
          { //###### 北區售服部 #######//
		    //##### 案件數量(003) 
            String sSqlTP = "select count(REPNO) as RECORDCOUNTTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
            Statement stment=con.createStatement();
            ResultSet rsRCTP=stment.executeQuery(sSqlTP);
            if (rsRCTP.next())
            {  RecordCountTP = rsRCTP.getString("RECORDCOUNTTP");
			   fRecordCountTP = rsRCTP.getInt("RECORDCOUNTTP");} 
            rsRCTP.close();
			//out.println(sSqlTP);
			//####  已維修(003)-Repairing、Restore、Shipped
			   sSqlTP = "select count(REPNO) as REPAIREDTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID in('005','006','012') ";            
            ResultSet rsRPEDTP=stment.executeQuery(sSqlTP);
            if (rsRPEDTP.next())
            {  
			   RepairedTP = rsRPEDTP.getString("REPAIREDTP");
			   fRepairedTP = rsRPEDTP.getInt("REPAIREDTP");
			}   
            rsRPEDTP.close();
			
			RepairRateTP = (float)(fRepairedTP/fRecordCountTP)*100;
			// 取小數1位
			sRPRateTP = Float.toString(RepairRateTP);
			idxRpTP = sRPRateTP.indexOf('.');
			sRPRateTP = sRPRateTP.substring(0,idxRpTP+1)+sRPRateTP.substring(idxRpTP+1,idxRpTP+2);
			
			//out.println(sSqlTP);
			//### 維修處理中(003) - Others;
			   sSqlTP = "select count(REPNO) as INREPAIRINGTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID not in('005','006','012')";            
            ResultSet rsRPINGTP=stment.executeQuery(sSqlTP);
            if (rsRPINGTP.next())
            {  InRepairingTP = rsRPINGTP.getString("INREPAIRINGTP");}            
	        //out.println(sSqlTP);
            rsRPINGTP.close();
			//###  保內(003) - VALID;
			   sSqlTP = "select count(REPNO) as WARINTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE in('VALID') ";            
            ResultSet rsWARINTP=stment.executeQuery(sSqlTP);
            if (rsWARINTP.next())
            {  WarInTP = rsWARINTP.getString("WARINTP");}
            rsWARINTP.close();
			//out.println(sSqlTP);
			//###  保外(003) - INVALID;
			   sSqlTP = "select count(REPNO) as WAROUTTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE not in('VALID') ";            
            ResultSet rsWAROUTTP=stment.executeQuery(sSqlTP);
            if (rsWAROUTTP.next())
            {  WarOutTP = rsWAROUTTP.getString("WAROUTTP");} 
            rsWAROUTTP.close();
			//out.println(sSqlTP);
			//### 一般維修(003) - svrtypeno=001
			   sSqlTP = "select count(REPNO) as GENREPTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('001') ";            
            ResultSet rsGENREPTP=stment.executeQuery(sSqlTP);
            if (rsGENREPTP.next())
            {  GenRepTP = rsGENREPTP.getString("GENREPTP");}  
            rsGENREPTP.close();
			//out.println(sSqlTP);
			//### DOA(003) - svrtypeno=002
			   sSqlTP = "select count(REPNO) as DOATP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('002') ";            
            ResultSet rsDOATP=stment.executeQuery(sSqlTP);
            if (rsDOATP.next())
            {  DoaTP = rsDOATP.getString("DOATP");} 
            rsDOATP.close();
			//out.println(sSqlTP);
			//### DAP(003) - svrtypeno=003
			   sSqlTP = "select count(REPNO) as DAPTP from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('003') ";            
            ResultSet rsDAPTP=stment.executeQuery(sSqlTP);
            if (rsDAPTP.next())
            {  DapTP = rsDOATP.getString("DAPTP");} 
            rsDAPTP.close();
			//out.println(sSqlTP);
			//### By Model Permutation
			   int modelPermutationTP=0;
			   sSqlTP = "select count(ITEMNO) as COUNT, trim(ITEMNO) as ITEMNO from RPREPAIR where REPCENTERNO='003' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' group by ITEMNO order by COUNT desc,ITEMNO ";
			ResultSet rsMODELTP=stment.executeQuery(sSqlTP);
           // if (rsMODELTP.next())
           // {   
			  while (rsMODELTP.next())
			  {
			    modelPermutationTP++;		   
			    if (modelPermutationTP==1)
			    {Model1TP = rsMODELTP.getString("ITEMNO");}
			    else if (modelPermutationTP==2)
				{Model2TP = rsMODELTP.getString("ITEMNO");}
				else if (modelPermutationTP==3)
				{Model3TP = rsMODELTP.getString("ITEMNO");}
			    else {break;}
				//rsMODELTP.next();
			  }		   
			//}        
            
			//out.println(sSqlTP);
			//###### 中區售服部 #######//
		    //##### 案件數量(004) 
            String sSqlTC = "select count(REPNO) as RECORDCOUNTTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
            //Statement stment=con.createStatement();
            ResultSet rsRCTC=stment.executeQuery(sSqlTC);
            if (rsRCTC.next())
            {  
			  RecordCountTC = rsRCTC.getString("RECORDCOUNTTC");
			  fRecordCountTC = rsRCTC.getInt("RECORDCOUNTTC");
			}
            rsRCTC.close();
			//out.println(sSqlTC);
			//####  已維修(004)-Repairing、Restore、Shipped
			   sSqlTC = "select count(REPNO) as REPAIREDTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID in('005','006','012')";            
            ResultSet rsRPEDTC=stment.executeQuery(sSqlTC);
            if (rsRPEDTC.next())
            {  
			  RepairedTC = rsRPEDTC.getString("REPAIREDTC");
			  fRepairedTC = rsRPEDTC.getInt("REPAIREDTC");
			} 
            rsRPEDTC.close();
			
			RepairRateTC = (float)(fRepairedTC/fRecordCountTC)*100;
			// 取小數1位
			sRPRateTC = Float.toString(RepairRateTC);
			idxRpTC = sRPRateTC.indexOf('.');
			sRPRateTC = sRPRateTC.substring(0,idxRpTC+1)+sRPRateTC.substring(idxRpTC+1,idxRpTC+2);
			
			//out.println(sSqlTC);
			//### 維修處理中(004) - Others;
			   sSqlTC = "select count(REPNO) as INREPAIRINGTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID not in('005','006','012')";            
            ResultSet rsRPINGTC=stment.executeQuery(sSqlTC);
            if (rsRPINGTC.next())
            {  InRepairingTC = rsRPINGTP.getString("INREPAIRINGTC");}	        
            rsRPINGTC.close();
			//out.println(sSqlTC);
			//###  保內(004) - VALID;
			   sSqlTC = "select count(REPNO) as WARINTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE in('VALID') ";            
            ResultSet rsWARINTC=stment.executeQuery(sSqlTC);
            if (rsWARINTC.next())
            {  WarInTC = rsWARINTC.getString("WARINTC");}            
            rsWARINTC.close();
			//out.println(sSqlTC);
			//###  保外(004) - INVALID;
			   sSqlTC = "select count(REPNO) as WAROUTTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE not in('VALID') ";            
            ResultSet rsWAROUTTC=stment.executeQuery(sSqlTC);
            if (rsWAROUTTC.next())
            {  WarOutTC = rsWAROUTTC.getString("WAROUTTC");}           
            rsWAROUTTC.close();
			//out.println(sSqlTC);
			//### 一般維修(004) - svrtypeno=001
			   sSqlTC = "select count(REPNO) as GENREPTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('001') ";            
            ResultSet rsGENREPTC=stment.executeQuery(sSqlTC);
            if (rsGENREPTC.next())
            {  GenRepTC = rsGENREPTC.getString("GENREPTC");} 	        
            rsGENREPTC.close();
			//out.println(sSqlTC);
			//### DOA(004) - svrtypeno=002
			   sSqlTC = "select count(REPNO) as DOATC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('002') ";            
            ResultSet rsDOATC=stment.executeQuery(sSqlTC);
            if (rsDOATC.next())
            {  DoaTC = rsDOATP.getString("DOATC");}            
	        rsDOATC.close();
			//out.println(sSqlTC);
			//### DAP(004) - svrtypeno=003
			   sSqlTC = "select count(REPNO) as DAPTC from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('003') ";            
            ResultSet rsDAPTC=stment.executeQuery(sSqlTC);
            if (rsDAPTC.next())
            {  DapTC = rsDOATP.getString("DAPTC");}            
	        rsDAPTC.close();
			//out.println(sSqlTC);
			//### By Model Permutation
			   int modelPermutationTC=0;
			   sSqlTC = "select count(ITEMNO) as COUNT, trim(ITEMNO) as ITEMNO from RPREPAIR where REPCENTERNO='004' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' group by ITEMNO order by COUNT desc,ITEMNO ";
			ResultSet rsMODELTC=stment.executeQuery(sSqlTC);
            while(rsMODELTC.next())
			{
			    modelPermutationTC=modelPermutationTC+1;		   
			    if (modelPermutationTC==1)
			    {Model1TC = rsMODELTC.getString("ITEMNO");}
			    else if (modelPermutationTC==2)
				{Model2TC = rsMODELTC.getString("ITEMNO");}
				else if (modelPermutationTC==3)
				{Model3TC = rsMODELTC.getString("ITEMNO");}
				else {break;}
			}			   
			       
            
			//out.println(sSqlTC);
			//###### 南區售服部 #######//
		    //##### 案件數量(005) 
            String sSqlKS = "select count(REPNO) as RECORDCOUNTKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
            //Statement stment=con.createStatement();
            ResultSet rsRCKS=stment.executeQuery(sSqlKS);
            if (rsRCKS.next())
            {  
			   RecordCountKS = rsRCKS.getString("RECORDCOUNTKS");
			   fRecordCountKS = rsRCKS.getInt("RECORDCOUNTKS");
			}
            rsRCKS.close();
			
			//####  已維修(005)-Repairing、Restore、Shipped
			   sSqlKS = "select count(REPNO) as REPAIREDKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID in('005','006','012')";            
            ResultSet rsRPEDKS=stment.executeQuery(sSqlKS);
            if (rsRPEDKS.next())
            {  
			  RepairedKS = rsRPEDKS.getString("REPAIREDKS");
			  fRepairedKS = rsRPEDKS.getInt("REPAIREDKS");
			} 
            rsRPEDKS.close();
			
			RepairRateKS = (float)(fRepairedKS/fRecordCountKS)*100;
			// 取小數1位
			sRPRateKS = Float.toString(RepairRateKS);
			idxRpKS = sRPRateKS.indexOf('.');
			sRPRateKS = sRPRateKS.substring(0,idxRpKS+1)+sRPRateKS.substring(idxRpKS+1,idxRpKS+2);
			
			//### 維修處理中(005) - Others;
			   sSqlKS = "select count(REPNO) as INREPAIRINGKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID not in('005','006','012')";            
            ResultSet rsRPINGKS=stment.executeQuery(sSqlKS);
            if (rsRPINGKS.next())
            {  InRepairingKS = rsRPINGKS.getString("INREPAIRINGKS");}	        
            rsRPINGKS.close();
			
			//###  保內(005) - VALID;
			   sSqlKS = "select count(REPNO) as WARINKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE in('VALID') ";            
            ResultSet rsWARINKS=stment.executeQuery(sSqlKS);
            if (rsWARINKS.next())
            {  WarInKS = rsWARINKS.getString("WARINKS");}            
            rsWARINKS.close();
			
			//###  保外(005) - INVALID;
			   sSqlKS = "select count(REPNO) as WAROUTKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE not in('VALID') ";            
            ResultSet rsWAROUTKS=stment.executeQuery(sSqlKS);
            if (rsWAROUTKS.next())
            {  WarOutKS = rsWAROUTKS.getString("WAROUTKS");}           
            rsWAROUTKS.close();
			
			//### 一般維修(005) - svrtypeno=001
			   sSqlKS = "select count(REPNO) as GENREPKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('001') ";            
            ResultSet rsGENREPKS=stment.executeQuery(sSqlKS);
            if (rsGENREPKS.next())
            {  GenRepKS = rsGENREPKS.getString("GENREPKS");} 	        
            rsGENREPKS.close();
			
			//### DOA(005) - svrtypeno=002
			   sSqlKS = "select count(REPNO) as DOAKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('002') ";            
            ResultSet rsDOAKS=stment.executeQuery(sSqlKS);
            if (rsDOAKS.next())
            {  DoaKS = rsDOAKS.getString("DOAKS");}            
	        rsDOAKS.close();
			
			//### DAP(005) - svrtypeno=003
			   sSqlKS = "select count(REPNO) as DAPKS from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('003') ";            
            ResultSet rsDAPKS=stment.executeQuery(sSqlKS);
            if (rsDAPKS.next())
            {  DapKS = rsDOAKS.getString("DAPKS");}            
	        rsDAPKS.close();
			
			//### By Model PermutationKS
			   int modelPermutationKS=0;
			   sSqlKS = "select count(ITEMNO) as COUNT, trim(ITEMNO) as ITEMNO from RPREPAIR where REPCENTERNO='005' and substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' group by ITEMNO order by COUNT desc,ITEMNO ";
			ResultSet rsMODELKS=stment.executeQuery(sSqlKS);
           // if (rsMODELKS.next())
           // {   
			  while(rsMODELKS.next())
			  {
			    modelPermutationKS=modelPermutationKS+1;		   
			    if (modelPermutationKS==1)
			    {Model1KS = rsMODELKS.getString("ITEMNO");}
			    else if (modelPermutationKS==2)
				{Model2KS = rsMODELKS.getString("ITEMNO");}
				else if (modelPermutationKS==3)
				{Model3KS = rsMODELKS.getString("ITEMNO");}
				else {break;}
			  }			   
			//}        
            //rsMODELKS.next();
			
			//###### 小計各維修售服部 #######//
		    //##### 案件數量(003+004+005) 
            String sSqlSUB = "select count(REPNO) as RECORDCOUNTSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' ";
            //Statement stment=con.createStatement();
            ResultSet rsRCSUB=stment.executeQuery(sSqlSUB);
            if (rsRCSUB.next())
            {  
			  RecordCountSUB = rsRCSUB.getString("RECORDCOUNTSUB");
			  fRecordCountSUB = rsRCSUB.getInt("RECORDCOUNTSUB");
			}
            rsRCSUB.close();
			
			//####  已維修(005)-Repairing、Restore、Shipped
			   sSqlSUB = "select count(REPNO) as REPAIREDSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID in('005','006','012')";            
            ResultSet rsRPEDSUB=stment.executeQuery(sSqlSUB);
            if (rsRPEDSUB.next())
            {  
			  RepairedSUB = rsRPEDSUB.getString("REPAIREDSUB");
			  fRepairedSUB = rsRPEDSUB.getInt("REPAIREDSUB");
			} 
            rsRPEDSUB.close();
			
			RepairRateSUB = (float)(fRepairedSUB/fRecordCountSUB)*100;
			// 取小數1位
			sRPRateSUB = Float.toString(RepairRateSUB);
			idxRpSUB = sRPRateSUB.indexOf('.');
			sRPRateSUB = sRPRateSUB.substring(0,idxRpSUB+1)+sRPRateSUB.substring(idxRpSUB+1,idxRpSUB+2);
			
			//### 維修處理中(005) - Others;
			   sSqlSUB = "select count(REPNO) as INREPAIRINGSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and STATUSID not in('005','006','012')";            
            ResultSet rsRPINGSUB=stment.executeQuery(sSqlSUB);
            if (rsRPINGSUB.next())
            {  InRepairingSUB = rsRPINGSUB.getString("INREPAIRINGSUB");}	        
            rsRPINGSUB.close();
			
			//###  保內(005) - VALID;
			   sSqlSUB = "select count(REPNO) as WARINSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE in('VALID') ";            
            ResultSet rsWARINSUB=stment.executeQuery(sSqlSUB);
            if (rsWARINSUB.next())
            {  WarInSUB = rsWARINSUB.getString("WARINSUB");}            
            rsWARINSUB.close();
			
			//###  保外(005) - INVALID;
			   sSqlSUB = "select count(REPNO) as WAROUTSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and WARRTYPE not in('VALID') ";            
            ResultSet rsWAROUTSUB=stment.executeQuery(sSqlSUB);
            if (rsWAROUTSUB.next())
            {  WarOutSUB = rsWAROUTSUB.getString("WAROUTSUB");}           
            rsWAROUTSUB.close();
			
			//### 一般維修(005) - svrtypeno=001
			   sSqlSUB = "select count(REPNO) as GENREPSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('001') ";            
            ResultSet rsGENREPSUB=stment.executeQuery(sSqlSUB);
            if (rsGENREPSUB.next())
            {  GenRepSUB = rsGENREPSUB.getString("GENREPSUB");} 	        
            rsGENREPSUB.close();
			
			//### DOA(005) - svrtypeno=002
			   sSqlSUB = "select count(REPNO) as DOASUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('002') ";            
            ResultSet rsDOASUB=stment.executeQuery(sSqlSUB);
            if (rsDOASUB.next())
            {  DoaSUB = rsDOASUB.getString("DOASUB");}            
	        rsDOASUB.close();
			
			//### DAP - svrtypeno=003
			   sSqlSUB = "select count(REPNO) as DAPSUB from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' and SVRTYPENO in('003') ";            
            ResultSet rsDAPSUB=stment.executeQuery(sSqlSUB);
            if (rsDAPSUB.next())
            {  DapSUB = rsDOAKS.getString("DAPSUB");}            
	        rsDAPSUB.close();
			
			//### By Model PermutationSUB
			   int modelPermutationSUB=0;
			   sSqlSUB = "select count(ITEMNO) as COUNT, trim(ITEMNO) as ITEMNO from RPREPAIR where substr(REPNO,6,8) between "+"'"+dateStringBegin+"'"+" and "+"'"+dateStringEnd+"' group by ITEMNO order by COUNT desc,ITEMNO ";
			ResultSet rsMODELSUB=stment.executeQuery(sSqlSUB);
            //if (rsMODELSUB.next())
            //{  
			  while (rsMODELSUB.next())
			  { 
			    modelPermutationSUB=modelPermutationSUB+1;		   
			    if (modelPermutationSUB==1)
			    {Model1SUB = rsMODELSUB.getString("ITEMNO");}
			    else if (modelPermutationSUB==2)
				{Model2SUB = rsMODELSUB.getString("ITEMNO");}
				else if (modelPermutationSUB==3)
				{Model3SUB = rsMODELSUB.getString("ITEMNO");}
				else {break;}
			  }
				
			//	rsMODELSUB.next();			   
			//}  
			
			RepairRateAVR = (RepairRateTP + RepairRateTC + RepairRateKS)/3;
			
			//取小數1位
			sRPRateAVR = Float.toString(RepairRateAVR);
			idxRpAVR = sRPRateAVR.indexOf('.');
			sRPRateAVR = sRPRateAVR.substring(0,idxRpAVR+1)+sRPRateAVR.substring(idxRpAVR+1,idxRpAVR+2);
			
			rsMODELTP.close();
			rsMODELTC.close();
			rsMODELKS.close();     
            rsMODELSUB.close();
			stment.close();		  
	      }   
      catch (Exception e)
      {
       out.println("Exception:"+e.getMessage());   
      }     
	 %>
      </td>
    </tr>
  </table>
  <table width="100%" border="1" bordercolor="#000000">
    <tr> 
      <td width="11%" height="53" bordercolor="#000000" bgcolor="#FFFFFF"><font size="-1"><strong><jsp:getProperty name="rPH" property="pgSalesArea"/></strong></font></td>
      <td width="7%"><div align="center"><strong><font size="-1"><jsp:getProperty name="rPH" property="pgLogQty"/></font></strong></div></td>
      <td colspan="2" bgcolor="#F1FFEC"> 
        <div align="center"><strong><font size="-1">維修處理狀態</font></strong></div></td>
      <td colspan="1" bgcolor="#FFF4FF"> 
        <div align="center"><strong><font size="-1">完修率</font></strong></div></td>
      <td colspan="2" bgcolor="#E8FFFF"> 
        <div align="center"><strong><font size="-1">保固類型</font></strong></div></td>
      <td colspan="3" bgcolor="#CCEEFF"> 
        <div align="center"><strong><font size="-1">維修服務類型</font></strong></div></td>
      <td colspan="3"><div align="center"><strong><font size="-1">登錄機型排名</font></strong></div></td>
    </tr>
    <tr> 
      <td height="22" colspan="2"><div align="center"><strong>&nbsp;<font size="-1"><jsp:getProperty name="rPH" property="pgItemContent"/></font></strong></div></td>
      <td width="6%" bgcolor="#F1FFEC">
<div align="center"><strong><font size="-1">已維修</font></strong></div></td>
      <td width="10%" bgcolor="#F1FFEC">
<div align="center"><strong><font size="-1">維修處理中</font></strong></div></td>

      <td width="10%" bgcolor="#FFF4FF">
<div align="center"><strong><font color="#FF0000">%</font></strong></div></td>
      <td width="7%" bgcolor="#E8FFFF">
<div align="center"><strong><font size="-1">保內</font></strong></div></td>
      <td width="5%" bgcolor="#E8FFFF">
<div align="center"><strong><font size="-1">保外</font></strong></div></td>
      <td width="9%" bgcolor="#CCEEFF"> 
        <div align="center"><strong><font size="-1">一般送修</font></strong></div></td>
      <td width="6%" bgcolor="#CCEEFF"> 
        <div align="center"><strong><font size="-1">DOA</font></strong></div></td>
      <td width="5%" bgcolor="#CCEEFF"> 
        <div align="center"><strong><font size="-1">DAP</font></strong></div></td>
      <td width="8%"><div align="center"><strong><font size="-1">1</font></strong></div></td>
      <td width="8%"><div align="center"><strong><font size="-1">2</font></strong></div></td>
      <td width="8%"><div align="center"><strong><font size="-1">3</font></strong></div></td>
    </tr>
    <tr> 
      <td width="11%" height="34" bordercolor="#000000"><font size="-1">北區售服部</font></td>
      <td width="7%"><font size="-1"><div align="center"> 
          <input type="hidden" name="RECORDCOUNTTP" size="5" value="<%=RecordCountTP%>" align="right"><%=RecordCountTP%>
        </div></font></td>
      <td width="6%" bgcolor="#F1FFEC"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="REPAIREDTP" size="5" value="<%=RepairedTP%>" align="right"><%=RepairedTP%>
        </div></font></td>
      <td width="10%" bgcolor="#F1FFEC"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="INREPAIRINGTP" size="5" value="<%=InRepairingTP%>" align="right"><%=InRepairingTP%>
        </div></font></td>
      <td width="10%" bgcolor="#FFF4FF"><font size="-1">
<div align="center"> 
          <input type="hidden" name="REPAIRRATETP" size="10" value="<%=RepairRateTP%><%='%'%>" align="right"><%=sRPRateTP%><%='%'%>		  
        </div></td>
      <td width="7%" bgcolor="#E8FFFF"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="WARINTP" size="5" value="<%=WarInTP%>" align="right"><%=WarInTP%>
        </div></font></td>
      <td width="5%" bgcolor="#E8FFFF"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="WAROUTTP" size="5" value="<%=WarOutTP%>" align="right"><%=WarOutTP%>
        </div></font></td>
      <td width="9%" bgcolor="#CCEEFF"><font size="-1"> 
        <div align="center"> 
          <input type="hidden" name="GENREPTP" size="5" value="<%=GenRepTP%>" align="right"><%=GenRepTP%>
        </div></font></td>
      <td width="6%" bgcolor="#CCEEFF"><font size="-1"> 
        <div align="center"> 
          <input type="hidden" name="DOATP" size="5" value="<%=DoaTP%>" align="right"><%=DoaTP%>
        </div></font></td>
      <td width="5%" bgcolor="#CCEEFF"><font size="-1"> 
        <div align="center"> 
          <input type="hidden" name="DAPTP" size="5" value="<%=DapTP%>" align="right">
          <%=DapTP%>
        </div></td>
     <!--%  <td width="8%"><input type="hidden" name="MODEL1TP" size="10" value="<%=Model1TP%>" align="right"><div style="position:absolute;"><A HREF='javaScript:pullDownMenu()'><%=Model1TP%></A></div>
	    <div id="pdMENU" style="position:absolute;visibility:hidden"><A HREF='javaScript:jamCodeOrderByModel("<%=Model2TP%>","<%=dateStringBegin%>","<%=dateStringEnd%>")'><%=Model2TP%></A></div>
	  </td>  onMouseOver='window["myTable1"].style.display="block"' onMouseOut='window["myTable1"].style.display="none"'%-->	  
	  <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL1TP" size="10" value="<%=Model1TP%>" align="right"><A HREF='javaScript:jamCodeOrderByModel("<%=Model1TP%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="003"%>")' onMouseOver='window["myTable1"].style.display="block"' onMouseOut='window["myTable1"].style.display="none"'><%=Model1TP%></A>
	    <br>
	    <table border='0' id='myTable1' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	             </div></font></td>
      <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL2TP" size="10" value="<%=Model2TP%>" align="right"><A HREF='javaScript:jamCodeOrderByModel("<%=Model2TP%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="003"%>")' onMouseOver='window["myTable2"].style.display="block"' onMouseOut='window["myTable2"].style.display="none"'><%=Model2TP%></A>
	    <br>
	    <table border='0' id='myTable2' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	              </div></font></td>
      <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL3TP" size="10" value="<%=Model3TP%>" align="right"><A HREF='javaScript:jamCodeOrderByModel("<%=Model3TP%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="003"%>")' onMouseOver='window["myTable3"].style.display="block"' onMouseOut='window["myTable3"].style.display="none"'><%=Model3TP%></A>
	    <br>
	    <table border='0' id='myTable3' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	              </div></font></td>
    </tr>
    <tr> 
      <td width="11%" height="25" bordercolor="#000000"><font size="-1">中區售服部</font></td>
      <td width="7%"><div align="center"> 
      <font size="-1"><input type="hidden" name="RECORDCOUNTTC" size="5" value="<%=RecordCountTC%>" align="right"><%=RecordCountTC%>
      </font></div></td>
      <td width="6%" bgcolor="#F1FFEC">
<div align="center"> 
      <font size="-1">
<input type="hidden" name="REPAIREDTC" size="5" value="<%=RepairedTC%>" align="right"><%=RepairedTC%>
      </font></div></td>
      <td width="10%" bgcolor="#F1FFEC">
<div align="center"> 
      <font size="-1">
<input type="hidden" name="INREPAIRINGTC" size="5" value="<%=InRepairingTC%>" align="right"><%=InRepairingTC%>
      </font></div></td>
      <td width="10%" bgcolor="#FFF4FF">
<div align="center"> 
      <font size="-1">
<input type="hidden" name="REPAIRRATETC" size="10" value="<%=RepairRateTC%><%='%'%>" align="right"><%=sRPRateTC%><%='%'%>
      </font></div></td>
      <td width="7%" bgcolor="#E8FFFF">
<div align="center"> 
      <font size="-1">
<input type="hidden" name="WARINTC" size="5" value="<%=WarInTC%>" align="right"><%=WarInTC%>
      </font></div></td>
      <td width="5%" bgcolor="#E8FFFF">
<div align="center"> 
      <font size="-1">
<input type="hidden" name="WAROUTTC" size="5" value="<%=WarOutTC%>" align="right"><%=WarOutTC%>
      </font></div></td>
      <td width="9%" bgcolor="#CCEEFF"> 
        <div align="center"> <font size="-1"> 
          <input type="hidden" name="GENREPTC" size="5" value="<%=GenRepTC%>" align="right"><%=GenRepTC%>
      </font></div></td>
      <td width="6%" bgcolor="#CCEEFF"> 
        <div align="center"> 
      <font size="-1">
<input type="hidden" name="DOATC" size="5" value="<%=DoaTC%>" align="right"><%=DoaTC%>
      </font></div></td>
      <td width="5%" bgcolor="#CCEEFF"> 
        <div align="center"> 
      <font size="-1">
<input type="hidden" name="DAPTC" size="5" value="<%=DapTC%>" align="right">
          <%=DapTC%>
      </font></div></td>
      <td width="8%"><div align="center"> 
      <font size="-1"><input type="hidden" name="MODEL1TC" size="10" value="<%=Model1TC%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model1TC%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="004"%>")' onMouseOver='window["myTable4"].style.display="block"' onMouseOut='window["myTable4"].style.display="none"'><%=Model1TC%></A>
	     <br>
	    <table border='0' id='myTable4' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	  </font></div></td>
      <td width="8%"><div align="center"> 
      <font size="-1"><input type="hidden" name="MODEL2TC" size="10" value="<%=Model2TC%>" align="left">
	      <A HREF='javaScript:jamCodeOrderByModel("<%=Model2TC%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="004"%>")' onMouseOver='window["myTable5"].style.display="block"' onMouseOut='window["myTable5"].style.display="none"'><%=Model2TC%></A>
	     <br>
	    <table border='0' id='myTable5' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	  </font></div></td>
      <td width="8%"><div align="center"> 
      <font size="-1"><input type="hidden" name="MODEL3TC" size="10" value="<%=Model3TC%>" align="left">
	   <A HREF='javaScript:jamCodeOrderByModel("<%=Model3TC%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="004"%>")' onMouseOver='window["myTable6"].style.display="block"' onMouseOut='window["myTable6"].style.display="none"'><%=Model3TC%></A> 
	  <!--% 	               
	    out.println("<A HREF='javaScript:jamCodeOrderByModel("+Model3TC+","+dateStringBegin+","+dateStringEnd+")"+" onMouseOver="+"window["+"myTable6"+"].style.display="+"block"+" onMouseOut="+"window["+"myTable6"+"].style.display="+"none"+">"+Model3TC+"</A>");
	  %-->
	     <br>
	    <table border='0' id='myTable6' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	  </font></div></td>
    </tr>
    <tr> 
      <td width="11%" height="27" bordercolor="#000000"><font size="-1">南區售服部</font></td>
      <td width="7%"><font size="-1"><div align="center"> 
          <input type="hidden" name="RECORDCOUNTKS" size="5" value="<%=RecordCountKS%>" align="right"><%=RecordCountKS%>
        </div></font></td>
      <td width="6%" bgcolor="#F1FFEC"><font size="-1">
<div align="center"> 
          <input type="hidden" name="REPAIREDKS" size="5" value="<%=RepairedKS%>" align="right"><%=RepairedKS%> </div>
        </font></td>
      <td width="10%" bgcolor="#F1FFEC"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="INREPAIRINGKS" size="5" value="<%=InRepairingKS%>" align="right"><%=InRepairingKS%>
        </div></font></td>
      <td width="10%" bgcolor="#FFF4FF"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="REPAIRRATEKS" size="10" value="<%=RepairRateKS%><%='%'%>" align="right"><%=sRPRateKS%><%='%'%>
        </div></font></td>
      <td width="7%" bgcolor="#E8FFFF"><font size="-1">
        <div align="center"> 
          <input type="hidden" name="WARINKS" size="5" value="<%=WarInKS%>" align="right"><%=WarInKS%>
        </div></font></td>
      <td width="5%" bgcolor="#E8FFFF"><font size="-1">
<div align="center"> 
          <input type="hidden" name="WAROUTKS" size="5" value="<%=WarOutKS%>" align="right">
          <%=WarOutKS%>
        </div></font></td>
      <td width="9%" bgcolor="#CCEEFF"><font size="-1">
<div align="center"> 
          <input type="hidden" name="GENREPKS" size="5" value="<%=GenRepKS%>" align="right"><%=GenRepKS%> </div>
        </font></td>
      <td width="6%" bgcolor="#CCEEFF"><font size="-1">
<div align="center"> 
          <input type="hidden" name="DOAKS" size="5" value="<%=DoaKS%>" align="right"><%=DoaKS%> </div>
        </font></td>
      <td width="5%" bgcolor="#CCEEFF"><font size="-1">
<div align="center"> 
          <input type="hidden" name="DAPKS" size="5" value="<%=DapKS%>" align="right">
          <%=DapKS%>
        </div></font></td>
      <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL1KS" size="10" value="<%=Model1KS%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model1KS%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="005"%>")' onMouseOver='window["myTable7"].style.display="block"' onMouseOut='window["myTable7"].style.display="none"'><%=Model1KS%></A>
	     <br>
	    <table border='0' id='myTable7' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	                 </div></font></td>
      <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL2KS" size="10" value="<%=Model2KS%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model2KS%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="005"%>")' onMouseOver='window["myTable8"].style.display="block"' onMouseOut='window["myTable8"].style.display="none"'><%=Model2KS%></A>
	     <br>
	    <table border='0' id='myTable8' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	                 </div></font></td>
      <td width="8%"><font size="-1"><div align="center">
	      <input type="hidden" name="MODEL3KS" size="10" value="<%=Model3KS%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model3KS%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%="005"%>")' onMouseOver='window["myTable9"].style.display="block"' onMouseOut='window["myTable9"].style.display="none"'><%=Model3KS%></A>
	     <br>
	    <table border='0' id='myTable9' bgcolor="#FFFFCC" style='display:none'><tr><td><font size="-2" color="#FF0000">故障原因</font></td></tr></table>
	                 </div></font></td>
    </tr>
    <tr> 
      <td width="11%" height="38" bordercolor="#000000"><div align="right"><font size="-1"><strong>小計</strong></font></div></td>
      <td width="7%"><div align="center"><font color="#FF0000" size="-1"><strong>
          <input type="hidden" name="RECORDCOUNTSUB" size="5" value="<%=RecordCountSUB%>" align="right"><%=RecordCountSUB%>
          </strong></font></div></td>
      <td width="6%" bgcolor="#F1FFEC"><font size="-1"> 
        <div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="REPAIREDSUB" size="5" value="<%=RepairedSUB%>" align="right"><%=RepairedSUB%>
        </strong> </font></div></td>
      <td width="10%" bgcolor="#F1FFEC"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="INREPAIRINGSUB" size="5" value="<%=InRepairingSUB%>" align="right"><%=InRepairingSUB%>
        </strong> </font></div></td>
      <td width="10%" bgcolor="#FFF4FF"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="REPAIRRATESUB" size="10" value="<%=RepairRateSUB%><%='%'%>" align="right"><%=sRPRateSUB%><%='%'%>
        </strong></font></div></td>
      <td width="7%" bgcolor="#E8FFFF"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="WARINSUB" size="5" value="<%=WarInSUB%>" align="right"><%=WarInSUB%>
        </strong></font></div></td>
      <td width="5%" bgcolor="#E8FFFF"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="WAROUTSUB" size="5" value="<%=WarOutSUB%>" align="right"><%=WarOutSUB%>
        </strong></font></div></td>
      <td width="9%" bgcolor="#CCEEFF"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="GENREPSUB" size="5" value="<%=GenRepSUB%>" align="right"><%=GenRepSUB%>
        </strong></font></div></td>
      <td width="6%" bgcolor="#CCEEFF"><font size="-1"> 
        <div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="DOASUB" size="5" value="<%=DoaSUB%>" align="right"><%=DoaSUB%>
        </strong></font></div></td>
      <td width="5%" bgcolor="#CCEEFF"><font size="-1">
<div align="center"><font color="#FF0000"><strong> 
          <input type="hidden" name="DAPSUB" size="5" value="<%=DapSUB%>" align="right"><%=DapSUB%>
        </strong></font></div></td>
      <td width="8%" bgcolor="#FFF0D0">
<div align="center"><font color="#FF0000" size="-1"><strong>
<input type="hidden" name="MODEL1SUB" size="10" value="<%=Model1SUB%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model1SUB%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%=""%>")'><%=Model1SUB%></A></strong></font></div></td>
      <td width="8%" bgcolor="#FFF0D0">
<div align="center"><font color="#FF0000" size="-1"><strong>
<input type="hidden" name="MODEL2SUB" size="10" value="<%=Model2SUB%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model2SUB%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%=""%>")'><%=Model2SUB%></A></strong></font></div></td>
      <td width="8%" bgcolor="#FFF0D0">
<div align="center"><font color="#FF0000" size="-1"><strong><input type="hidden" name="MODEL3SUB" size="10" value="<%=Model3SUB%>" align="left"><A HREF='javaScript:jamCodeOrderByModel("<%=Model3SUB%>","<%=dateStringBegin%>","<%=dateStringEnd%>","<%=""%>")'><%=Model3SUB%></A></strong></font></div></td>
    </tr>
    <tr> 
      <td width="11%" height="38" bordercolor="#000000"><font size="-1">
        <div align="right"><strong>總計</strong></div>
        </font></td>
      <td width="7%" colspan="1"><font size="-1"><div align="center"><font color="#990066"><strong> 
          <input type="hidden" name="RECORDCOUNTSUB" size="5" value="<%=Integer.parseInt(RecordCountSUB)%>" align="right"><%=Integer.parseInt(RecordCountSUB)%>
          </strong></font></div></td>
      <td colspan="2" bgcolor="#F1FFEC"><font size="-1">
<div align="center"><font color="#990066"><strong> 
          <input type="hidden" name="REPAIREDSUB" size="10" value="<%=Integer.parseInt(RepairedSUB)+Integer.parseInt(InRepairingSUB)%>" align="right"><%=Integer.parseInt(RepairedSUB)+Integer.parseInt(InRepairingSUB)%>
        </strong></font></div></td>
      <td width="10%" bgcolor="#FFF4FF"> <font size="-1">
<div align="center"><font color="#990066"><strong> 
          <input type="hidden" name="REPAIRRATESUB" size="10" value="<%=RepairRateAVR%><%='%'%>" align="right"><%=sRPRateAVR%><%='%'%>
        </strong></font></div></td>
      <td colspan="2" bgcolor="#E8FFFF"><font size="-1">
<div align="center"><font color="#990066"><strong> 
          <input type="hidden" name="WARINSUB" size="10" value="<%=Integer.parseInt(WarInSUB)+Integer.parseInt(WarOutSUB)%>" align="right"><%=Integer.parseInt(WarInSUB)+Integer.parseInt(WarOutSUB)%>
        </strong></font></div></td>
      <td colspan="3" bgcolor="#CCEEFF"><font size="-1">
<div align="center"><font color="#990066"><strong> 
          <input type="hidden" name="GENREPSUB" size="15" value="<%=Integer.parseInt(GenRepSUB)+Integer.parseInt(DoaSUB)+Integer.parseInt(DapSUB)%>" align="right"><%=Integer.parseInt(GenRepSUB)+Integer.parseInt(DoaSUB)+Integer.parseInt(DapSUB)%>
        </strong></font></div></td>
      <td colspan="3"bgcolor="#FFF0D0">&nbsp;</td>
	  
    </tr>
  </table>
  <BR>
  <center>
  <img src="../jsp/RepItemChartN.jsp?DATEBEGIN=<%=dateStringBegin%>&&DATEEND=<%=dateStringEnd%>">&nbsp;&nbsp;
  <img src="../jsp/RepItemChartM.jsp?DATEBEGIN=<%=dateStringBegin%>&&DATEEND=<%=dateStringEnd%>">&nbsp;&nbsp;
  <img src="../jsp/RepItemChartS.jsp?DATEBEGIN=<%=dateStringBegin%>&&DATEEND=<%=dateStringEnd%>"><br>
  <!--img src="http://192.168.4.3/eis/chart.jsp"><br-->
  </br>
  </center>
</FORM>
</body>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
