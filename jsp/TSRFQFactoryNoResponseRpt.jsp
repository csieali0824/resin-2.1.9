<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{    
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit2(URL)
{    
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setExcel(URL)
{    
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function subWindowCustInfoFind(custNo,custName)
{ 
	if (event.keyCode==13)
   	{    
    	subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
   	}	
}
function setCustInfoFind(custNo,custName)
{      
    subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custNo+"&NAME="+custName,"subwin");  
}
function DateChange()
{
	document.MYFORM.YEARFR.value="--";
	document.MYFORM.MONTHFR.value="--";
	document.MYFORM.DAYFR.value="--";
	document.MYFORM.YEARTO.value="--";
	document.MYFORM.MONTHTO.value="--";
	document.MYFORM.DAYTO.value="--";
	if (document.MYFORM.DATETYPE.value !="")
	{
		var sdate=document.MYFORM.DATETYPE.value.substr(0,document.MYFORM.DATETYPE.value.indexOf("~"));
		var edate=document.MYFORM.DATETYPE.value.substr(document.MYFORM.DATETYPE.value.indexOf("~")+1);
		if (sdate!="")
		{
			document.MYFORM.YEARFR.value=sdate.substring(0,4);
			document.MYFORM.MONTHFR.value=sdate.substring(4,2);
			document.MYFORM.DAYFR.value=sdate.substring(6,2);
		}
		if (edate!="")
		{
			document.MYFORM.YEARTO.value=edate.substr(0,4);
			document.MYFORM.MONTHTO.value=edate.substr(4,2);
			document.MYFORM.DAYTO.value=edate.substr(6,2);
		}
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #000000; text-decoration: underline }
  A:visited { color: #000080; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

  .head0    { background-color: #999999 } 

  .head     { background-image: url(images_zh_TW/blue.gif) }
  .neck     { background-color: #CCCCCC }
  .odd      { background-color: #e3e3e3 }
  .even     { background-color: #f7f7f7}
  .board    { background-color: #D6DBE7}
  
  .nav         { text-decoration: underline; color:#000000 }
  .nav:link    { text-decoration: underline; color:#000000 }
  .nav:visited { text-decoration: underline; color:#000000 }
  .nav:active  { text-decoration: underline; color:#FF0000 }
  .nav:hover   { text-decoration: none; color:#FF0000 }
  .topic         { text-decoration: none }
  .topic:link    { text-decoration: none; color:#000000 }
  .topic:visited { text-decoration: none; color:#000080 }
  .topic:active  { text-decoration: none; color:#FF0000 }
  .topic:hover   { text-decoration: underline; color:#FF0000 }
  .ilink         { text-decoration: underline; color:#0000FF }
  .ilink:link    { text-decoration: underline; color:#0000FF }
  .ilink:visited { text-decoration: underline; color:#004080 }
  .ilink:active  { text-decoration: underline; color:#FF0000 }
  .ilink:hover   { text-decoration: underline; color:#FF0000 }
  .mod         { text-decoration: none; color:#000000 }
  .mod:link    { text-decoration: none; color:#000000 }
  .mod:visited { text-decoration: none; color:#000080 }
  .mod:active  { text-decoration: none; color:#FF0000 }
  .mod:hover   { text-decoration: underline; color:#FF0000 }  
  .thd         { text-decoration: none; color:#808080 }
  .thd:link    { text-decoration: underline; color:#808080 }
  .thd:visited { text-decoration: underline; color:#808080 }
  .thd:active  { text-decoration: underline; color:#FF0000 }
  .thd:hover   { text-decoration: underline; color:#FF0000 }
  .curpage     { text-decoration: none; color:#FFFFFF; font-family: Tahoma; font-size: 9px }
  .page         { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:link    { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:visited { text-decoration: none; color:#003063; font-family: Tahoma; font-size: 9px }
  .page:active  { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .page:hover   { text-decoration: none; color:#FF0000; font-family: Tahoma; font-size: 9px }
  .subject  { font-family: Tahoma,Georgia; font-size: 12px }
  .text     { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  .codeStyle {	padding-right: 0.5em; margin-top: 1em; padding-left: 0.5em;  font-size: 9pt; margin-bottom: 1em; padding-bottom: 0.5em; margin-left: 0pt; padding-top: 0.5em; font-family: Courier New; background-color: #000000; color:#ffffff ; }
  .smalltext   { font-family: Tahoma,Georgia; color: #000000; font-size:11px }
  .verysmalltext  { font-family: Tahoma,Georgia; color: #000000; font-size:4px }
  .member   { font-family:Tahoma,Georgia; color:#003063; font-size:9px }
  .btnStyle  { background-color: #5D7790; border-width:2; 
             border-color: #E9E9E9; color: #FFFFFF; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .selStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; cursor: hand; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .inpStyle  { background-color: #FFFFFF; border-bottom: black 1px solid; 
             border-left: black 1px solid; border-right: black 1px solid; 
             border-top: black 1px solid; color: #000000; 
             font-family: Tahoma,Georgia; font-size: 12px }
  .titleStyle 
             {
              COLOR: #ffffff; FONT-FAMILY: Tahoma,Georgia;
              padding: 2px;   margin: 1px; text-align: center;}
  .style1 {color: #003399}	
  select {font-family: Tahoma,Georgia}
		  
             
</STYLE>
<title>Oracle Add On System Information Query</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=================================-->
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=================================-->
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String sSql = "",sWhere="";
String colorStr = "";
String YearFr=request.getParameter("YEARFR");
if (YearFr==null) YearFr="--";
String MonthFr=request.getParameter("MONTHFR");
if (MonthFr==null) MonthFr="--";
String DayFr=request.getParameter("DAYFR");
if (DayFr==null) DayFr="--";
String YearTo=request.getParameter("YEARTO");
if (YearTo==null) YearTo=dateBean.getYearString();
String MonthTo=request.getParameter("MONTHTO");
if (MonthTo==null) MonthTo=dateBean.getMonthString();
String DayTo=request.getParameter("DAYTO");
if (DayTo==null) DayTo=dateBean.getDayString();
String prodManufactory=request.getParameter("PRODMANUFACTORY");
String status=request.getParameter("STATUS");
String createdBy = request.getParameter("CREATOR");
if (createdBy==null)
{
	if (!UserRoles.equals("admin") && UserRoles.indexOf("PMD_Approver")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0)  createdBy=UserName;
	else createdBy="";
}
String salesAreaNo = request.getParameter("SALESAREANO");
if (salesAreaNo==null) salesAreaNo="";
int idx=0;
%>
<% /* 建立本頁面資料庫連線  */ %>
<meta http-equiv="Content-Type" content="text/html; charset=big5"></head>
<body topmargin="0" bottommargin="0">  
<FORM ACTION="../jsp/TSRFQFactResponseMOCreateRpt.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Arial"><font size="+3" face="Arial Black"><font color="#3366FF" size="+2" face="Arial"><font size="+3" face="Arial Black"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="Arial Black">TSC</font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><jsp:getProperty name="rPH" property="pgFactoryDeDate"/><jsp:getProperty name="rPH" property="pgNoResponse"/><jsp:getProperty name="rPH" property="pgDetailRpt"/></strong></font>
<div align="right"><%@ include file="/jsp/include/TSHomeHyperLinkPage.jsp"%> </div>
<table cellSpacing='1' bordercolordark='#D8DEA9'  cellPadding='1' width='100%' align='center' borderColorLight='#ffffff' border='1' bordercolor="#CCCCCC">     	 	 
	<tr>
		<td width="10%" colspan="1" nowrap><font color="#006666" ><strong><jsp:getProperty name="rPH" property="pgSalesArea"/></strong></font></td> 
		<td width="40%">
		<%		 
		try
		{   
			Statement statement=con.createStatement();
			String sql = " select distinct SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA "+
			             " where SALES_AREA_NO > 0 ";
			if (!UserRoles.equals("admin") && UserRoles.indexOf("PMD_Approver")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0) 
			{ 
				sql += " and exists (select 1 from oraddman.tsrecperson where tssaleareano=SALES_AREA_NO and USERNAME='"+UserName+"')";	
			}					 
			sql += " order by SALES_AREA_NO ";
			ResultSet rs =statement.executeQuery(sql);		           
			comboBoxAllBean.setRs(rs);
			if (salesAreaNo!=null)
			{ 
				comboBoxAllBean.setSelection(salesAreaNo); 
			}
			comboBoxAllBean.setFieldName("SALESAREANO");	   
			out.println(comboBoxAllBean.getRsString());
			rs.close();   
			statement.close(); 
		}
		catch (Exception e)
		{
			out.println("Exception:"+e.getMessage());
		}		   
		%>		
		</td>
	    <td width="10%" colspan="1" nowrap><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgProdFactory"/> </strong></font></td> 
		<td width="15%"><div align="left"><font color="#006666"><strong> </strong></font>
		<%
		try
        { 
	    	Statement stateGetP=con.createStatement();
			String sqlGetP = " select MANUFACTORY_NO, MANUFACTORY_NAME as PRODMANUFACTORY  from ORADDMAN.TSPROD_MANUFACTORY "+
			                 " where MANUFACTORY_NO > 0 ";
			if (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) 
			{ 
				sqlGetP += " and exists (select 1 from oraddman.tsprod_person where PROD_FACNO=MANUFACTORY_NO and nvl(PACTIVE,'N')='Y' and USERNAME='"+UserName+"')";	
			}								 
			sqlGetP += " order by MANUFACTORY_NO "; 		  
            ResultSet rsGetP=stateGetP.executeQuery(sqlGetP);
			comboBoxAllBean.setRs(rsGetP);
		    comboBoxAllBean.setSelection(prodManufactory);
	        comboBoxAllBean.setFieldName("PRODMANUFACTORY");					     
            out.println(comboBoxAllBean.getRsString());				
			stateGetP.close();		  		  
	        rsGetP.close();
        } 
        catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>
		</div></td> 			
		<td width="10%"><div align="left"><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgRepStatus"/></strong></font></div></td>
		<td width="15%">   
		<%
		try
        { 
	    	Statement stateGetP=con.createStatement();
			String sqlGetP = " select UNIQUE STATUSID, STATUSNAME||'-'||STATUSDESC as STATUS  from ORADDMAN.TSWFSTATUS a, ORADDMAN.TSWORKFLOW b  "+
							 " where a.STATUSID = b.FROMSTATUSID and b.FORMID = 'TS' and a.STATUSID  in ('003','004') order by a.STATUSID "; 		  
            ResultSet rsGetP=stateGetP.executeQuery(sqlGetP);
			comboBoxAllBean.setRs(rsGetP);
		   	comboBoxAllBean.setSelection(status);
	        comboBoxAllBean.setFieldName("STATUS");					     
            out.println(comboBoxAllBean.getRsString());				
					           
			stateGetP.close();		  		  
		    rsGetP.close();
	    } 
        catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>	   
		</td>   
	</tr>	  
	<tr>	    
		<td nowrap><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgCreateFormDate"/></strong></font></td>
		<td><select NAME="DATETYPE" onChange="DateChange();">
			<OPTION VALUE="" selected="selected">--</OPTION>
		<%						
			String sql = " SELECT 'Over One Day' date_type,'~'||to_char(trunc(sysdate)-1,'yyyymmdd') DATE_RANGE from dual"+
					     " UNION ALL"+
					     " SELECT 'Over Two Days' date_type,'~'||to_char(trunc(sysdate)-2,'yyyymmdd') DATE_RANGE from dual";
			Statement statement88=con.createStatement();
			ResultSet rs88=statement88.executeQuery(sql);
			while (rs88.next()) 
			{
		%>
			<OPTION VALUE="<%=rs88.getString("date_range")%>"><%=rs88.getString("date_type")%></OPTION>
		<%
			}
			rs88.close();
			statement88.close();					
		%>
			</select>
			<jsp:getProperty name="rPH" property="pgDateFr"/>
        <%
			try
			{     
				int  j =0; 
				String a[]= new String[Integer.parseInt(dateBean.getYearString())-2010+1];
				for (int i = 2010; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
				{
					a[j++] = ""+i; 
				}
				arrayComboBoxBean.setArrayString(a);
				arrayComboBoxBean.setSelection((YearFr==null?dateBean.getYearString():YearFr));
				arrayComboBoxBean.setFieldName("YEARFR");	   
				out.println(arrayComboBoxBean.getArrayString());		      		 
			}
			catch (Exception e)
			{
				out.println("Exception:"+e.getMessage());
			}		 
		  	
	     	try
         	{       
          		String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          		arrayComboBoxBean.setArrayString(b);
				arrayComboBoxBean.setSelection((MonthFr==null?dateBean.getMonthString():MonthFr));
	      		arrayComboBoxBean.setFieldName("MONTHFR");	   
          		out.println(arrayComboBoxBean.getArrayString());		      		 
         	} 
         	catch (Exception e)
         	{
          		out.println("Exception:"+e.getMessage());
         	}

	     	try
         	{       
          		String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          		arrayComboBoxBean.setArrayString(c);
				arrayComboBoxBean.setSelection((DayFr==null?dateBean.getDayString():DayFr));
	      		arrayComboBoxBean.setFieldName("DAYFR");	   
          		out.println(arrayComboBoxBean.getArrayString());		      		 
         	}
         	catch (Exception e)
         	{
          		out.println("Exception:"+e.getMessage());
         	}
       		%>
       		<font color="#006666"><strong><jsp:getProperty name="rPH" property="pgDateTo"/></strong></font>
        	<%
			try
			{       
				int  j =0; 
				String a[]= new String[Integer.parseInt(dateBean.getYearString())-2010+1];
				for (int i = 2010; i <= Integer.parseInt(dateBean.getYearString()) ; i++)
				{
					a[j++] = ""+i; 
				}
				arrayComboBoxBean.setArrayString(a);
				arrayComboBoxBean.setSelection((YearTo==null?dateBean.getYearString():YearTo));
				arrayComboBoxBean.setFieldName("YEARTO");	
				out.println(arrayComboBoxBean.getArrayString());		      		 
			} //end of try
			catch (Exception e)
			{
				out.println("Exception:"+e.getMessage());
			}		 
		  	
	     	try
         	{       
          		String b[]={"01","02","03","04","05","06","07","08","09","10","11","12"};
          		arrayComboBoxBean.setArrayString(b);
				arrayComboBoxBean.setSelection((MonthTo==null?dateBean.getMonthString():MonthTo));
	      		arrayComboBoxBean.setFieldName("MONTHTO");	   
          		out.println(arrayComboBoxBean.getArrayString());		      		 
         	}
         	catch (Exception e)
         	{
          		out.println("Exception:"+e.getMessage());
         	}

	     	try
         	{       
          		String c[]={"01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31"};
          		arrayComboBoxBean.setArrayString(c);
				arrayComboBoxBean.setSelection((DayTo==null?dateBean.getDayString():DayTo));
	      		arrayComboBoxBean.setFieldName("DAYTO");	
          		out.println(arrayComboBoxBean.getArrayString());		      		 
         	} //end of try
         	catch (Exception e)
         	{
          		out.println("Exception:"+e.getMessage());
         	}
       		%>
    	</td>
		<td><font color="#006666"><strong><jsp:getProperty name="rPH" property="pgCreateFormUser"/></strong></font></td>
		<td><input type="text" name="CREATOR" value="<%=createdBy%>" style="font-family:ARIAL;" size="20"></td>
		<td colspan="2" align="center">
		   	<INPUT TYPE="button" align="middle"  value='<jsp:getProperty name="rPH" property="pgQuery"/>' onClick='setSubmit("../jsp/TSRFQFactoryNoResponseRpt.jsp")' > 			 
			&nbsp;&nbsp;&nbsp;&nbsp;
		   	<INPUT TYPE="button" align="middle"  value='Excel' onClick='setExcel("../jsp/TSRFQFactoryNoResponseExcel.jsp")' > 			 
		</td>
   	</tr>
</table>  
<%
try
{
	sSql =" select DISTINCT c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+
		  " b.ALCHNAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  " c.CREATED_BY, c.SALESPERSON, c.REQREASON, count(DISTINCT d.line_no) as MAXLINE, f.SDRQCOUNT, "+
          " TO_CHAR(TO_DATE(c.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS') as CREATION_DATE "+
		  " ,row_number() over (order by c.DNDOCNO desc) row_cnt"+
          " ,sum(count(DISTINCT d.line_no)) over (order by c.DNDOCNO desc) line_cnt"+		  
		  "  from ORADDMAN.TSSALES_AREA b, ORADDMAN.TSDELIVERY_NOTICE c, "+
		  "       ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e, "+
		  " 	  (select d1.DNDOCNO, sum(decode(d1.SDRQ_EXCEED,'Y',1,0)) as SDRQCOUNT "+ //計算四日過期Line的筆數
          "          from ORADDMAN.TSDELIVERY_NOTICE_DETAIL d1 "+
          "         group by d1.DNDOCNO ) f, ORADDMAN.TSDELIVERY_DETAIL_HISTORY g "+
   		  " where c.DNDOCNO = d.DNDOCNO "+
		  " and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+
		  " and b.LOCALE='886' "+
		  " and b.SALES_AREA_NO=c.TSAREANO "+
		  " and d.DNDOCNO = g.DNDOCNO(+) and d.LINE_NO = g.LINE_NO(+) "+
		  " and d.LSTATUSID in ('003','004')"+
          " and f.DNDOCNO = d.DNDOCNO ";
	if (!UserRoles.equals("admin")  && UserRoles.indexOf("PMD_Approver")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0) 
	{ 
		sSql += " and exists (select 1 from oraddman.tsrecperson x where x.tssaleareano=c.TSAREANO and x.USERNAME='"+UserName+"')";	
	}		
	if (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) 
	{ 
		sSql += " and exists (select 1 from oraddman.tsprod_person x where x.PROD_FACNO=d.ASSIGN_MANUFACT and nvl(x.PACTIVE,'N')='Y' and x.USERNAME='"+UserName+"')";	
	}		  
	sSql +=" ?01"+
		  " group by c.DNDOCNO,c.PROD_FACTORY,c.CUSTOMER, c.TSCUSTOMERID, "+         
		  " b.ALCHNAME, TO_CHAR(TO_DATE(c.REQUIRE_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
		  " TO_CHAR(TO_DATE(c.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD HH24:MI:SS'), "+
	      " c.CREATED_BY, c.SALESPERSON, c.REQREASON ,f.SDRQCOUNT"+    
   	      " order by c.DNDOCNO";	  
			 
   	if (prodManufactory!=null && !prodManufactory.equals("--") && !prodManufactory.equals("")) 
	{
		sWhere+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
	}
  
   	if (status!=null && !status.equals("--"))  
	{
		sWhere+=" and d.LSTATUSID ='"+status+"'"; 
	}
   
   	//add by Peggy 20120413
	if (salesAreaNo != null && !salesAreaNo.equals("--") && !salesAreaNo.equals(""))
	{
		sWhere+=" and c.TSAREANO ='" +salesAreaNo+"'";  
	}
		
	if (createdBy!=null && !createdBy.equals("")) 
	{ 
		sWhere+=" and exists (select 1 from  oraddman.WSUSER x where UPPER(x.USERNAME)='"+createdBy.toUpperCase()+"' and x.WEBID=d.created_by)"; 
	}
	
	if ((YearFr !=null && !YearFr.equals("--")) || (MonthFr !=null && !MonthFr.equals("--")) || (DayFr !=null && !DayFr.equals("--")))
	{
		sWhere+=" and substr(c.CREATION_DATE,0,8)>="+ (!YearFr.equals("--")?YearFr:"0000")+(!MonthFr.equals("--")?MonthFr:"00")+(!DayFr.equals("--")?DayFr:"00");
	}
	if ((YearTo != null && !YearTo.equals("--")) || (MonthTo !=null && !MonthTo.equals("--")) || (DayTo!=null && !DayTo.equals("--")))
	{
		sWhere+=" and substr(c.CREATION_DATE,0,8)<="+ (!YearTo.equals("--")?YearTo:dateBean.getYearString())+(!MonthTo.equals("--")?MonthTo:dateBean.getMonthString())+(!DayTo.equals("--")?DayTo:dateBean.getDayString());
	}

	sSql = sSql.replace("?01",sWhere);
	Statement statementTC=con.createStatement(); 
	ResultSet rsTC=statementTC.executeQuery(sSql);
	while (rsTC.next()) 
	{
		if (idx==0)
		{
		%>
    	<div><font color="#006666"><jsp:getProperty name="rPH" property="pgQDocNo"/><jsp:getProperty name="rPH" property="pgMRItemQty"/></font> 
	 	<font color='#000066' face="Arial"><strong><%=rsTC.getInt("ROW_CNT")%></strong></font>
	 	&nbsp;&nbsp;<font color="#006666"><jsp:getProperty name="rPH" property="pgGTotal"/><jsp:getProperty name="rPH" property="pgItemQty"/></font>
	 	<font color='#000066' face="Arial"><strong><%=rsTC.getInt("line_cnt")%></strong></font></div>	
		<table width="100%" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#FFFFFF" bordercolor="#D8DEA9">
			<tr bgcolor="#D8DEA9"> 
				<td width="2%" height="22" nowrap><div align="center"><font color="#000000">&nbsp;</font></div></td> 
				<td width="2%" height="22" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgSalesArea"/></font></div></td>               	  
				<td width="9%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgQDocNo"/></font></div></td>
				<td width="5%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgSalesMan"/></font></div></td>
				<td width="20%" nowrap><div align="center"><font color="#006666"><jsp:getProperty name="rPH" property="pgDetail"/></font></div></td>                   	  
			</tr>		
		<%
		}
		
		if ((idx % 2) == 0)
		{
	    	colorStr = "FFFFCC";
	    }
	    else
		{
	    	colorStr = "#D8DEA9";
		}

%>	
	<tr bgcolor="<%=colorStr%>"> 
   		<td bgcolor="#D8DEA9" width="2%" nowrap><div align="center"><font size="2" color="#006666"><a name='#<%=rsTC.getString("DNDOCNO")%>'><%out.println(idx+1);%></a></font></div></td>
	 	<td nowrap><font color="#006666"><%=rsTC.getString("ALCHNAME")%></font></td>     	             
	  	<td width="9%" nowrap><div align="center"><font size="2" color="#006666"><%=rsTC.getString("DNDOCNO")%></font></div></td>
	  	<td width="5%" nowrap><div align="center"><font color="#006666"><%=rsTC.getString("SALESPERSON")%></font></div></td> 
      	<td width="48%" nowrap><font size="2" color="#006666">
<% 
		String subColStr = "";	
		if ((idx % 2) == 0)
		{ 
			subColStr = "D8DEA9"; 
		}
	    else
		{ 
			subColStr = "FFFFCC"; 
		}			    
		out.println("<table cellSpacing='0' bordercolordark='#99CC99' cellPadding='1' width='100%' align='center' borderColorLight='#FFFFFF' border='0'>");			 
		out.print("<tr>");
		out.println("<td colspan=12>"); 							   
		out.println("<font color='#006666'>");
		%><jsp:getProperty name="rPH" property="pgCustomerName"/><%
		out.println(" :<font color='#CC3366'> "+rsTC.getString("CUSTOMER")+"</font>&nbsp;&nbsp;&nbsp;<BR>");
		%><jsp:getProperty name="rPH" property="pgTotal"/><%
		out.println("<font color='#CC3366'>"+rsTC.getString("MAXLINE")+"</font>");
		%><jsp:getProperty name="rPH" property="pgItemQty"/><jsp:getProperty name="rPH" property="pgFactoryDeDate"/><jsp:getProperty name="rPH" property="pgNoResponse"/><%
		out.println("</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"); 
		out.println("<font color='#006666'>");
		%><jsp:getProperty name="rPH" property="pgCreateFormUser"/><%
		String sqlCrUser = "select upper(USERNAME) from ORADDMAN.WSUSER where WEBID = '"+rsTC.getString("CREATED_BY")+"' "; // 取開單人員							   
		Statement stateCrUser=con.createStatement();
		ResultSet rsCrUser=stateCrUser.executeQuery(sqlCrUser);
		if (rsCrUser.next())
		{ 
			out.println(" : <font color='#CC3366'>"+rsCrUser.getString(1)+"</font>");// 取大寫名稱
		}
		rsCrUser.close();
		stateCrUser.close();				           
		out.println("</font>");  
		out.println("<font color='#006666'>");
		%>&nbsp;&nbsp;<jsp:getProperty name="rPH" property="pgCreateFormDate"/><%
		out.println(" : <font color='#CC3366'>"+rsTC.getString("CREATION_DATE")+"</font>");
		out.println("</font></td>"); 
		out.println("</tr>");
		int iRow = 0; 	
							   
		String sqlM = " select DISTINCT d.LINE_NO,d.LSTATUS,d.ITEM_DESCRIPTION, d.QUANTITY,d.UOM, "+
					  " TO_CHAR(TO_DATE(d.REQUEST_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD'),"+
					  " d.PCCFMDATE,d.FTACPDATE, d.PCACPDATE, d.SASCODATE, d.ORDERNO,"+
					  " e.MANUFACTORY_NAME,d.REMARK, "+
					  " ROUND((to_date('"+dateBean.getYearMonthDay()+dateBean.getHourMinuteSecond()+"','YYYYMMDDHH24MISS') - to_date(d.CREATION_DATE,'YYYYMMDDHH24MISS')) * 24,2) as ACCWORK_DATE "+  		
					  " from ORADDMAN.TSSALES_AREA b, "+
					  " ORADDMAN.TSDELIVERY_NOTICE_DETAIL d, ORADDMAN.TSPROD_MANUFACTORY e "+
					  " where (d.DNDOCNO = '"+rsTC.getString("DNDOCNO")+"' ) "+
					  " and d.ASSIGN_MANUFACT = e.MANUFACTORY_NO(+) "+										      
					  " and substr(d.DNDOCNO,3,3)=b.SALES_AREA_NO and b.LOCALE='886' "+
					  " and d.LSTATUSID in ('003','004')";
		if (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) 
		{ 
			sqlM += " and exists (select 1 from oraddman.tsprod_person x where x.PROD_FACNO=d.ASSIGN_MANUFACT and nvl(x.PACTIVE,'N')='Y' and x.USERNAME='"+UserName+"')";	
		}							
		if (prodManufactory != null && !prodManufactory.equals("--") &&  !prodManufactory.equals("")) 
		{
			sqlM+=" and d.ASSIGN_MANUFACT ='"+prodManufactory+"'"; 
		}
		if (status !=null && !status.equals("--")) 
		{ 
			sqlM+=" and d.LSTATUSID ='"+status+"'"; 
		}
		sqlM += "order by d.LINE_NO";					   			
		//sqlDtl = sqlM; // 把給Excel明細sql傳予sqlDtl 變數
		//out.println(sqlM);
		Statement stateM=con.createStatement();
		ResultSet rsM=stateM.executeQuery(sqlM); 							  
		while (rsM.next())
		{ 
			if (iRow==0 ) // 若第一筆資料才列印標頭列 //
			{ 
				out.println("<tr align='center' bgcolor='#CC6633'><td width='1%' nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgProdFactory"/><%								
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgFactoryResponse"/><jsp:getProperty name="rPH" property="pgDay"/><%								
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgAnItem"/><%								
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgTSCAlias"/><jsp:getProperty name="rPH" property="pgOrderedItem"/><jsp:getProperty name="rPH" property="pgDesc"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgUOM"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgQty"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgRequestDate"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");								
				%><jsp:getProperty name="rPH" property="pgPCAssignDate"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgFTArrangeDate"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgRepStatus"/><%
				out.println("</font></td><td nowrap><font size='1' color='#FFFFFF'>");
				%><jsp:getProperty name="rPH" property="pgAccWorkHours"/><%								
				out.println("</font></td></tr>");
			}
			out.println("<tr bgcolor="+subColStr+">");
			out.println("<td nowrap><font size='-2' color='#006666'>"+rsM.getString("MANUFACTORY_NAME")+"</font></td>");
			// 取工廠交期回覆時間_起
			String sqlC = " select TO_CHAR(TO_DATE(a.CDATETIME,'YYYYMMDDHH24MISS'),'YYYY/MM/DD')  "+                                             
						  " from ORADDMAN.TSDELIVERY_DETAIL_HISTORY a "+                                            
						  " where a.DNDOCNO='"+rsTC.getString("DNDOCNO")+"' and to_char(a.LINE_NO) = '"+rsM.getString("LINE_NO")+"' "+
						  " and a.ORISTATUSID = '003' and a.ACTIONID = '008' "; // 取狀態是判定且動作給交期確認(CONFIRM)
			Statement stateC=con.createStatement();
			//out.println(sqlC);
			ResultSet rsC=stateC.executeQuery(sqlC); 
			if (rsC.next())
			{
				out.println("<td align='center' width='1%' nowrap><font size=-2 color='#CC6633'>"+rsC.getString(1)+"</font></td>");							    
			} 
			else 
			{
				out.println("<td align='center' width='1%' nowrap><font size=-2 color='#CC6633'>N/A</font></td>");	
			}								
			rsC.close();
			stateC.close();
							
			out.println("<td width='1%' nowrap><font size='-2' color='#006666'><div align='center'>"+rsM.getString("LINE_NO")+"</div></font></td>");								
			out.println("<td nowrap><font size='-2' color='#CC6633'>"+rsM.getString("ITEM_DESCRIPTION")+"</font></td>");
			out.println("<td nowrap align='center'><font size='-2' color='#006666'>"+rsM.getString("UOM")+"</font></td>");
			out.println("<td nowrap align='right'><font size='-2' color='#006666'>"+rsM.getString("QUANTITY")+"</font></td>");
			out.println("<td nowrap align='center'><font size='-2' color='#006666'>"+rsM.getString(6)+"</font></td>");								
			out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
			if (rsM.getString("PCCFMDATE")==null || rsM.getString("PCCFMDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("PCCFMDATE").substring(0,4)+"/"+rsM.getString("PCCFMDATE").substring(4,6)+"/"+rsM.getString("PCCFMDATE").substring(6,8)); 
			out.println("</font></td>");
			out.println("<td nowrap align='center'><font size='-2' color='#006666'>");
			if (rsM.getString("FTACPDATE")==null || rsM.getString("FTACPDATE").equals("N/A")) out.println("N/A"); else out.println(rsM.getString("FTACPDATE").substring(0,4)+"/"+rsM.getString("FTACPDATE").substring(4,6)+"/"+rsM.getString("FTACPDATE").substring(6,8)); 
			out.println("</font></td>");
			out.println("<td nowrap align='center'><font size='-2' color='#006666'>"+rsM.getString("LSTATUS")+"</font></td>");								
			out.println("<td nowrap><font size='-2' color='#006666'>");
			if (rsM.getString("ACCWORK_DATE")==null || rsM.getString("ACCWORK_DATE").equals("N/A")) out.println("N/A"); else out.println("<div align='right'>"+rsM.getString("ACCWORK_DATE")+"</div>"); 
			out.println("</font></td>");							
			out.println("</tr>"); 
			iRow++;
		}
		rsM.close();
		stateM.close();
		out.println("</table>");   
		idx++;
	}
	if (idx==0)
	{
		out.println("<div style='color:#ff0000'>No Data Found!!</div>");
	}  
	%>
	</font></td> 	  	                
	</tr>
</table>
<%
}
catch(Exception e)
{
	out.println("<div style='color:#ff0000'>Exception1:"+e.getMessage()+"</div>");
}
%>
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
