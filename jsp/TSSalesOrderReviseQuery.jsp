<!-- 20160325 Peggy,add customer po條件-->
<!-- 20160330 Peggy,add role-Sales_M-->
<!-- 20160729 Peggy,異動欄位(除ssd,qty外)合併同一欄以說明方式呈現-->
<!-- 20170426 Peggy,新增resend次數及resend source request no-->
<!-- 20180809 Peggy,sql performance issue-->
<!-- 20180917 Peggy,新增package欄位-->
<!-- 20240226 Marvie : Excess Status-->
<%@ page contentType="text/html;charset=utf-8"  language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean,ComboBoxAllBean"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>Sales Order Revise for Query</title>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	if (document.MYFORM.SDATE.value=="" ||document.MYFORM.SDATE.value==null)
	{
		alert("Please input then request start date!");
		document.MYFORM.SDATE.focus();
		return false;
	}
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
	if (document.MYFORM.SDATE.value=="" ||document.MYFORM.SDATE.value==null)
	{
		alert("Please input then request start date!");
		document.MYFORM.SDATE.focus();
		return false;
	}
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function checkall()
{
	if (document.MYFORM.chk.length != undefined)
	{
		for (var i =0 ; i < document.MYFORM.chk.length ;i++)
		{
			if (document.MYFORM.chk[i].disabled==false)
			{
				document.MYFORM.chk[i].checked= document.MYFORM.chkall.checked;
				setCheck((i+1));
			}
		}
	}
	else
	{
		if (document.MYFORM.chk.disabled==false)
		{
			document.MYFORM.chk.checked = document.MYFORM.chkall.checked;
			setCheck(1);
		}
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow-1].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr"+irow).style.backgroundColor ="#D8E2E9";
	}
	else
	{
		document.getElementById("tr"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit(URL)
{
	var iLen=0;
	var chkvalue = false;
	var chkcnt =0;	
	var lineid="";
	var chvalue="";
	if (document.MYFORM.chk.length != undefined)
	{
		iLen = document.MYFORM.chk.length;
	}
	else
	{
		iLen = 1;
	}
	for (var i=1; i<= iLen ; i++)
	{
		if (iLen==1)
		{
			chkvalue =document.MYFORM.chk.checked;
			lineid = document.MYFORM.chk.value;
		}
		else
		{
			chkvalue = document.MYFORM.chk[i-1].checked;
			lineid = document.MYFORM.chk[i-1].value;
		}
		if (chkvalue==true) chkcnt ++;
	}
	if (chkcnt <=0)
	{
		alert("Please select to revise order data!");
		return false;
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;
	document.MYFORM.btnExport.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function showRemarks(so_header_id)
{
	subWin=window.open("../jsp/subwindow/TSSalesOrderRemarks.jsp?ID="+so_header_id,"subwin","width=440,height=250,scrollbars=yes,menubar=no");  
}
</script>
<STYLE TYPE='text/css'> 
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<%
String sql = "",request_no="",so_line_id="",temp_id="";
String TEMP_ID=request.getParameter("TEMP_ID");
if (TEMP_ID ==null) TEMP_ID="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale,")<0)
{
	PLANTCODE=userProdCenterNo;
}
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null) SDATE="";
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String PC_SDATE=request.getParameter("PC_SDATE");
if (PC_SDATE==null)
{
	if ((UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale,")<0)
	{			
		dateBean.setAdjDate(-1);
		PC_SDATE=dateBean.getYearMonthDay();
		dateBean.setAdjDate(1);
	}
	else
	{
		PC_SDATE="";
	}
}
String PC_EDATE=request.getParameter("PC_EDATE");
if (PC_EDATE==null) PC_EDATE="";
String PULL_SDATE=request.getParameter("PULL_SDATE");
if (PULL_SDATE==null) PULL_SDATE="";
String PULL_EDATE=request.getParameter("PULL_EDATE");
if (PULL_EDATE==null) PULL_EDATE="";
String STATUS=request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String MONO=request.getParameter("MONO");
if (MONO==null) MONO="";
String queryCount = request.getParameter("queryCount");
if (queryCount==null) queryCount="0";
queryCount = ""+(Integer.parseInt(queryCount)+1);
String CREATEDBY=request.getParameter("CREATEDBY");
if (CREATEDBY==null)
{
	CREATEDBY="";
	if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0  && UserRoles.indexOf("Sales_M")<0  && UserRoles.indexOf("SalesOrderReviseQuey")<0)
	{
		CREATEDBY="";
		if (queryCount.equals("1")) 
		{
			sql = " select count(1)  from tsc_om_salesorderrevise_req_v a"+
				  " where CREATED_BY=?";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,UserName);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				if (rs.getInt(1)>0)
				{
					CREATEDBY=UserName;
				}	
			}
			rs.close();
			statement.close();	
		}
	}
}
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String RESULT = request.getParameter("RESULT");
if (RESULT==null) RESULT="";
String SALES_RESULT = request.getParameter("SALES_RESULT");
if(SALES_RESULT==null) SALES_RESULT="";
String CUSTPO=request.getParameter("CUSTPO");  //add by Peggy 20160325
if (CUSTPO==null) CUSTPO="";
if (SDATE==null || SDATE.equals("")) 
{
	if (MONO.equals("") && REQUESTNO.equals("") && CUSTPO.equals("") && ITEMDESC.equals(""))
	{
		if ((UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0) || (UserRoles.indexOf("Sale,")>=0  && UserRoles.indexOf("Sales_M")<0))
		{
			dateBean.setAdjDate(-5);
			SDATE=dateBean.getYearMonthDay();
			dateBean.setAdjDate(5);
		}
	}
}
String REVISE_SDATE=request.getParameter("REVISE_SDATE");
if (REVISE_SDATE==null) REVISE_SDATE="";
String REVISE_EDATE=request.getParameter("REVISE_EDATE");
if (REVISE_EDATE==null) REVISE_EDATE="";
String chkma=request.getParameter("chkma");  //add by Peggy 20190117
if (chkma==null) chkma="N";
String strBackColor="",id="";
int rowcnt=0;

/*if (salesGroup.equals("") && UserRoles.indexOf("admin")<0)
{
	//sql = " SELECT g.master_group_name"+
	//	  " FROM oraddman.wsuser a,fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f,tsc_om_group_master g"+
	//	  " WHERE a.username = ?"+
	//	  " AND a.erp_user_id=b.user_id"+
	//	  " and b.employee_id = c.person_id"+
	//	  " AND c.employee_number = d.salesrep_number"+
    //     " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
	//	  " and e.group_id=f.group_id"+
	//	  " and f.master_group_id=g.master_group_id";
	sql = " SELECT DISTINCT TOG.group_name "+
	      " FROM TSC_OM_GROUP_SALESREP togs,TSC_OM_GROUP tog  WHERE  togs.GROUP_ID=tog.GROUP_ID"+
          " AND (tog.END_DATE IS NULL OR tog.END_DATE > TRUNC(SYSDATE))"+
          " AND EXISTS (SELECT 1 FROM oraddman.tsrecperson a,oraddman.tssales_area B WHERE A.USERNAME =? AND A.TSSALEAREANO=B.SALES_AREA_NO "+
          " AND ','||B.GROUP_ID||',' LIKE '%,'||tog.GROUP_ID||',%')";	
	PreparedStatement statement1 = con.prepareStatement(sql);
	statement1.setString(1,UserName);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{
		salesGroup=rs1.getString("group_name");
	}
	rs1.close();
	statement1.close();
}*/
%>
<body> 
<FORM ACTION="../jsp/TSSalesOrderReviseQuery.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Order Revise for Query</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:11px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" size="+2">Transaction Processing, Please wait a moment.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#E2EBBE">
	<tr>
		<td width="9%" align="right">Sales Group：</td>
		<td width="9%">
		<%
		try
		{   
			/*sql = "select MASTER_GROUP_NAME, MASTER_GROUP_NAME from tsc_om_group_master a where ORG_ID in (41,325) ";
			if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0)
			{
				sql += " and a.MASTER_GROUP_NAME='"+salesGroup+"'";
			}
			sql += " order by 1";*/
			//sql = " SELECT distinct f.group_name,f.group_name"+
            //      " FROM fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f,tsc_om_group_master g"+
    		//	  " WHERE b.employee_id = c.person_id"+
            //     " AND c.employee_number = d.salesrep_number"+
            //      " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
            //      " and e.group_id=f.group_id"+
			//	  " and f.master_group_id=g.master_group_id"+
			//	  " and exists (select 1 from oraddman.tsc_om_salesorderrevise_req k,oraddman.wsuser j "+
			//	  "             where k.created_by = j.username "+
			//	  "             and j.erp_user_id=b.user_id";
			//if (UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0) sql += " and j.username ='"+UserName+"'";
			//sql += " )"+
			//       " UNION ALL "+
            //       " select 'SAMPLE','SAMPLE' from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' AND x.TSSALEAREANO='020'"+
            //       " order by 1";
			//sql = "select distinct SALES_GROUP, SALES_GROUP from oraddman.tsc_om_salesorderrevise_req a where 1=1";
			sql = " SELECT distinct d.group_name,d.group_name "+
			      " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_req_v e"+
                  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
                  //" and b.MASTER_GROUP_ID=c.master_group_id"+
				  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                  " and c.master_group_id=d.master_group_id"+
                  " and d.group_name=e.SALES_GROUP"+
				  " and b.SALES_AREA_NO<>'020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserRoles.indexOf("SalesOrderReviseQuey")<0) || (UserRoles.indexOf("Sale,")>=0 && UserRoles.indexOf("Sales_M")<0)) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " union all"+
			       " select distinct ALNAME,ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserRoles.indexOf("SalesOrderReviseQuey")<0) || (UserRoles.indexOf("Sale,")>=0 && UserRoles.indexOf("Sales_M")<0)) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFieldName("SALESGROUP");	
			comboBoxBean.setOnChangeJS("");
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 
		%>	
		</td>
		
		<td width="7%" align="right">Customer：</td>
		<td width="14%"><input type="text" name="CUST" value="<%=CUST%>" style="font-family:Tahoma,Georgia;font-size:11px" size="30"></td>
		<td width="7%" align="right">MO#：</td> 
		<td width="11%"><input type="text" name="MONO" value="<%=MONO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td width="7%"align="right">Request No：</td>
		<td width="14%"><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>		
		<td width="7%"align="right">Created By：</td>
		<td width="14%">		
		<%
		try
		{   
			sql = "SELECT DISTINCT CREATED_BY,CREATED_BY CREATED_BY1 FROM tsc_om_salesorderrevise_req_v a where 1=1 ";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserRoles.indexOf("SalesOrderReviseQuey")<0) || ( UserRoles.indexOf("Sale,")>=0  && UserRoles.indexOf("Sales_M")<0))
			{
				//sql += " and (exists ( SELECT 1 FROM oraddman.wsuser x,fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f"+
    			//       "                WHERE x.username ='"+UserName+"'"+
                //       "                AND x.erp_user_id=b.user_id"+
                //       "                and b.employee_id = c.person_id"+
                //       " AND c.employee_number = d.salesrep_number"+
                //       " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
                //       " and e.group_id=f.group_id"+
				//	   " and f.group_name=a.sales_group)"+
				sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_req_v e"+
                       " where x.TSSALEAREANO=b.SALES_AREA_NO "+
                       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
                       " and x.USERNAME ='"+UserName+"'"+
					   " and d.group_name=a.sales_group"+
                       " and b.SALES_AREA_NO<>'020')"+
					   " or exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"'"+
					   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";
			}
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CREATEDBY);
			comboBoxBean.setFieldName("CREATEDBY");	 
			comboBoxBean.setOnChangeJS("");
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>	
		</td>
	</tr>
	<tr>
		<td align="right">Plant Code：</td>
		<td>
		<%
		try
		{   
			sql = "select distinct PLANT_CODE,  MANUFACTORY_NAME from tsc_om_salesorderrevise_req_v a,oraddman.tsprod_manufactory b where a.plant_code=b.MANUFACTORY_NO";
			if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale,")<0)
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(PLANTCODE);
			comboBoxBean.setFieldName("PLANTCODE");	 
			if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_User")>=0 || UserRoles.indexOf("MPC_003")>=0) && UserRoles.indexOf("Sale,")<0)
			{			
				comboBoxBean.setOnChangeJS("this.value="+'"'+userProdCenterNo+'"');  
			}
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>
		</td>
		<td align="right">Request Date：</td>
		<td><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">Item Desc：</td> 
		<td><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" style="font-family:Tahoma,Georgia;font-size:11px" size="22"></td>
		<td align="right">Status：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT STATUS,STATUS STATUS1 FROM tsc_om_salesorderrevise_req_v";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(STATUS);
			comboBoxBean.setFieldName("STATUS");	
			comboBoxBean.setOnChangeJS("");   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
		<td align="right">PC Result：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT PC_CONFIRMED_RESULT,DECODE(PC_CONFIRMED_RESULT,'A','Accept','Reject') FROM tsc_om_salesorderrevise_req_v WHERE STATUS <>'AWAITING_CONFIRM' AND PC_CONFIRMED_RESULT IS NOT NULL ORDER BY PC_CONFIRMED_RESULT";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(RESULT);
			comboBoxBean.setFieldName("RESULT");
			comboBoxBean.setOnChangeJS("");	   
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
	</tr>
	<tr>
		<td align="right">Sales Confirm Result：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT DECODE(SALES_CONFIRMED_RESULT,'1','Revise Order','2','Hold Order','0','No Revise','4','No Revise',SALES_CONFIRMED_RESULT),DECODE(SALES_CONFIRMED_RESULT,'1','Revise Order','2','Hold Order','0','No Revise','4','No Revise',SALES_CONFIRMED_RESULT) FROM tsc_om_salesorderrevise_req_v WHERE SALES_CONFIRMED_RESULT is not null ORDER BY 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(SALES_RESULT);
			comboBoxBean.setFieldName("SALES_RESULT");	 
			comboBoxBean.setOnChangeJS("");  
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>
		<td align="right">PC Replied Date：</td>
		<td><input type="TEXT" NAME="PC_SDATE" value="<%=PC_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.PC_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="PC_EDATE" value="<%=PC_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.PC_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">Customer PO：</td> 
		<td><input type="text" name="CUSTPO" value="<%=CUSTPO%>" style="font-family:Tahoma,Georgia;font-size:11px" size="22"></td>
		<td align="right">SSD pull in/out：</td>
		<td><input type="TEXT" NAME="PULL_SDATE" value="<%=PULL_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.PULL_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="PULL_EDATE" value="<%=PULL_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.PULL_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">Sales Revise Date：</td>
		<td><input type="TEXT" NAME="REVISE_SDATE" value="<%=REVISE_SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REVISE_SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="REVISE_EDATE" value="<%=REVISE_EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.REVISE_EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSSalesOrderReviseQuery.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSSalesOrderReviseExcel.jsp?RTYPE=QUERY')">
		<%
		if (UserName.toUpperCase().equals("JUNE")||UserName.toUpperCase().equals("AMY")||UserName.toUpperCase().equals("PEGGY_CHEN"))
		{
		%>
		&nbsp;&nbsp;
		<input type="button" name="btnOverview" value="Overview Report"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSSalesOrderReviseOverviewExcel.jsp')">
		<%
		}
		%>
		</td>
	</tr>
</TABLE>
<%
if (UserRoles.indexOf("admin")>=0 || UserName.toUpperCase().equals("MABEL"))
{
%>
<input type="checkbox" name="chkma" value="Y" <%=((UserName.toUpperCase().equals("MABEL")||chkma.equals("Y"))?"checked":"")%>>Shown order the latest schedule ship date and order pull in last record
<%
}
%>
<hr>
<%
try
{
	sql = " select a.request_no"+
	      ",a.sales_group"+
	      ",a.so_no"+
		  ",a.line_no"+
		  ",a.so_header_id"+
		  ",a.so_line_id"+
		  ",a.order_type"+
		  ",a.customer_number"+
		  ",a.customer_name"+
		  ",a.ship_to_org_id"+
		  ",a.tsc_prod_group"+
		  ",a.inventory_item_id"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",a.cust_item_id"+
		  ",a.cust_item_name"+
		  ",a.customer_po"+
		  ",a.shipping_method"+
		  ",a.so_qty"+
		  ",to_char(a.request_date,'yyyymmdd') request_date"+
		  //",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+  
		  ",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+    //add by Peggy 20191004
		  ",to_char(a.schedule_ship_date_tw,'yyyymmdd') schedule_ship_date_tw"+    //add by Peggy 20191004
		  ",to_char(a.pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date"+
		  ",case when nvl(a.to_tw_days,0)=0 then null else to_char(a.pc_schedule_ship_date+nvl(a.to_tw_days,0),'yyyymmdd') end pc_schedule_ship_date_tw"+ //add by Peggy 20191104
		  ",a.packing_instructions"+
		  ",a.plant_code"+
		  ",a.change_reason"+
		  ",a.change_comments"+
		  ",a.created_by"+
		  ",to_char(a.creation_date,'yyyymmdd hh24:mi') creation_date"+
		  ",a.pc_confirmed_by"+
          ",to_char(a.pc_confirmed_date,'yyyymmdd hh24:mi') pc_confirmed_date"+
          ",a.last_updated_by"+
          ",to_char(a.last_update_date,'yyyymmdd hh24:mi') last_update_date"+
		  ",a.status"+
		  ",a.temp_id"+
		  ",a.seq_id"+
		  ",a.ship_to"+
		  ",a.pc_remarks"+
		  ",a.remarks"+
		  ",a.pc_confirmed_result"+
		  ",a.pc_so_qty"+
		  ",TSC_Get_SO_Revise_Excess(a.temp_id, a.seq_id, 1) excess_status"+  // 20240226 Marvie Add : Excess Status
		  ",b.ALENGNAME"+
		  ",NVL(a.SOURCE_SO_QTY,d.ordered_quantity) orig_so_qty"+
		  ",a.SOURCE_ITEM_DESC orig_item_desc"+
		  //",to_char(a.SOURCE_SSD,'yyyymmdd') orig_schedule_ship_date"+
		  //",to_char(a.SOURCE_SSD-case when nvl(d.ATTRIBUTE19,'xx')='1' then 0 else NVL(f.TRANSPORTATION_DAYS,0) end,'yyyymmdd')  orig_schedule_ship_date"+
          //",to_char(CASE WHEN a.plant_code IN ('002') AND SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') THEN TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD')"+
		  ",to_char(CASE WHEN a.PACKING_INSTRUCTIONS in ('Y','T')  AND SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') THEN NVL(a.SOURCE_YEW_SSD,TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD'))"+
		  ////"  (SELECT schedule_ship_date FROM ont.oe_order_headers_all yew_h,ont.oe_order_lines_all yew_l"+
          ////"   WHERE yew_h.header_id=yew_l.header_id "+
          ////"   AND yew_h.org_id=325 "+
          ////"   AND yew_h.order_number=c.order_number"+
          ////"   AND yew_l.line_number||'.'||yew_l.shipment_number=d.line_number||'.'||d.shipment_number) "+
          "  ELSE a.source_ssd - CASE WHEN NVL (d.attribute19, 'xx') = '1' THEN 0 ELSE NVL (a.to_tw_days, 0) END END ,'yyyymmdd') AS  orig_schedule_ship_date"+
		  ", to_char(a.source_ssd,'yyyymmdd') AS  orig_schedule_ship_date_tw"+
		  ////",nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) orig_customer"+
		  ////",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end as orig_customer"+
		  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  "+
		  " else NVL (cust.account_name,nvl( DECODE (party.party_type,'ORGANIZATION', party.organization_name_phonetic, NULL), SUBSTRB (party.party_name, 1, 50))) ||case when a.source_customer_id=14980 then nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') else '' end end as orig_customer"+
		  ",count(a.SO_LINE_ID) over (partition by request_no,SO_HEADER_ID,SO_LINE_ID) line_cnt"+
		  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
		  ",a.ship_to_location_id"+
		  ",a.SOURCE_CUSTOMER_PO"+
		  ",a.deliver_to_location_id"+
		  ",a.DELIVER_TO_ORG_ID"+
		  ",a.DELIVER_TO"+
		  ",a.bill_to_location_id"+
		  ",a.BILL_TO_ORG_ID"+
		  ",a.BILL_TO"+
		  ",a.SOURCE_BILL_TO_ORG_ID"+		
		  ",a.SOURCE_BILL_TO_LOCATION_ID"+
		  ",a.SOURCE_SHIP_TO_LOCATION_ID"+
		  ",a.SOURCE_DELIVER_TO_LOCATION_ID"+
		  ",a.FOB_POINT_CODE"+
		  ",a.SOURCE_FOB_POINT_CODE"+
		  ",a.FOB"+
		  ",decode(a.SALES_CONFIRMED_RESULT,'1','Revise Order','2','Hold Order','0','No Revise','4','No Revise',a.SALES_CONFIRMED_RESULT) SALES_CONFIRMED_RESULT"+
		  ",replace(replace(tsc_order_revise_pkg.GET_REVISE_DESC(a.temp_id,a.seq_id,'SALES'),chr(13),''),chr(10),'<br>') others_field_revise_desc"+
          ",case when send_from_temp_id is null then null else row_number() over(partition by send_from_temp_id,send_from_seq_id order by temp_id) end resend_times"+//add by Peggy 20170426
          ",(select distinct request_no from tsc_om_salesorderrevise_req_v x where x.temp_id=a.send_from_temp_id) resend_from_request_no"+//add by Peggy 20170426
		  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ //add by Peggy 20180917
          ",rank() over (partition by d.header_id,d.line_id order by a.request_no desc) odr_revise_seq"+  //add by Peggy 20190117
          ",to_char(d.schedule_ship_date,'yyyymmdd') erp_ssd"+  //add by Peggy 20190117
		  ",nvl(a.to_tw_days,0) to_tw_days"+ //add by Peggy 20200325
		  ",to_char(d.schedule_ship_date,'yyyy/mm/dd') erp_ssd"+ //add by Peggy 20210401
		  ",a.pc_confirmed_reason"+ //add by Peggy 20230907
		  " from tsc_om_salesorderrevise_req_v a"+
		  ",oraddman.tsprod_manufactory b"+
		  ",ont.oe_order_headers_all c"+
		  ",ont.oe_order_lines_all d"+
		  //",ar_customers e"+
		  ",hz_cust_accounts cust"+ //modify by Peggy 20180809
          ",hz_parties party"+		  
		  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS f"+  //modif by Peggy 20200911
		  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS g"+  //modif by Peggy 20200911
		  ",hz_cust_accounts end_cust"+ //modify by Peggy 20200520
		  " where a.so_header_id=c.header_id(+)"+  //modify by Peggy 20180809
		  " and a.so_line_id=d.line_id(+)"+
		  //" and d.header_id(+)=c.header_id"+
		  //" and c.sold_to_org_id=e.customer_id"+
          " AND c.sold_to_org_id = cust.cust_account_id"+   //modify by Peggy 20180809
		  " AND d.end_customer_id = end_cust.cust_account_id(+)"+ //add by Peggy 20200520
          " AND a.source_customer_id = cust.cust_account_id"+
          " AND cust.party_id = party.party_id"+		  
          //" AND A.PLANT_CODE=f.PLANT_CODE(+)"+
          //" AND NVL(A.ORDER_TYPE,SUBSTR(A.SO_NO,1,4))=f.ORDER_NUM(+)"+
          //" AND A.PLANT_CODE=g.PLANT_CODE(+)"+
          //" AND SUBSTR(A.SO_NO,1,4)=g.ORDER_NUM(+)"+
		  " and a.plant_code =b.manufactory_no(+)";
	if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
	{
		sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
	}		  
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		sql += " and a.SALES_GROUP='"+salesGroup+"'";
	}
	else if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserRoles.indexOf("SalesOrderReviseQuey")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JENNY_LIAO")<0) || (UserRoles.indexOf("Sale,")>=0  && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0 && UserName.indexOf("JUNE")<0 ))
	{
		//sql += " and (exists (SELECT 1 FROM oraddman.wsuser x,fnd_user y, per_all_people_f z, jtf_rs_salesreps js,tsc_om_group_salesrep tos,tsc_om_group tog"+
    	//		       "                WHERE x.username ='"+UserName+"'"+
        //               "                AND x.erp_user_id=y.user_id"+
        //               "                and y.employee_id = z.person_id"+
        //               " AND z.employee_number = js.salesrep_number"+
        //               " AND nvl2(tos.salesrep_id,js.salesrep_id,y.user_id) = nvl(tos.salesrep_id,tos.user_id)"+
        //               " and tos.group_id=tog.group_id"+
		//			   " and tog.group_name=a.sales_group)"+
		sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,tsc_om_salesorderrevise_req_v e"+
			   " where x.TSSALEAREANO=b.SALES_AREA_NO "+
			   " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
			   " and c.master_group_id=d.master_group_id"+
			   " and d.group_name=e.SALES_GROUP"+
			   " and x.USERNAME ='"+UserName+"'"+
			   " and d.group_name=a.sales_group"+
			   " and b.SALES_AREA_NO<>'020')"+
			   " or exists (select 1 from oraddman.tsrecperson x where (x.USERNAME='"+UserName+"' or 'CYTSOU'='"+UserName+"')"+
			   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";	
	}
	if (!CUST.equals(""))
	{
		//sql += " and e.CUSTOMER_NAME like '%"+CUST+"%'";
		//sql += " and upper(case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end) like '%"+CUST.toUpperCase()+"%'";
		sql += " and upper(case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else   NVL (cust.account_name,NVL ( DECODE (party.party_type,'ORGANIZATION', party.organization_name_phonetic, NULL), SUBSTRB (party.party_name, 1, 50))) end) like '%"+CUST.toUpperCase()+"%'";
	}
	if (!ITEMDESC.equals(""))
	{
		sql += " and a.SOURCE_ITEM_DESC like '"+ITEMDESC+"%'";
	}	
	if (!CREATEDBY.equals("") && !CREATEDBY.equals("--"))
	{
		sql += " and a.CREATED_BY ='"+CREATEDBY+"'";
	}
	if (!MONO.equals(""))
	{
		sql += " and c.ORDER_NUMBER LIKE '"+MONO+"%'";
	}
	if (!STATUS.equals("") && !STATUS.equals("--"))
	{
		sql += " and a.STATUS = '"+STATUS+"'";
	}	
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!PC_SDATE.equals("") || !PC_EDATE.equals(""))
	{
		sql += " and a.PC_CONFIRMED_DATE  BETWEEN TO_DATE('"+(PC_SDATE.equals("")?"20150101":PC_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (PC_EDATE.equals("")?dateBean.getYearMonthDay():PC_EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!TEMP_ID.equals(""))
	{
		sql += " and a.TEMP_ID ='"+ TEMP_ID+"'";
	}
	if (!REQUESTNO.equals(""))
	{
		sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
	}
	if (!RESULT.equals("") && !RESULT.equals("--"))
	{
		sql += " and a.PC_CONFIRMED_RESULT = '"+RESULT+"'";
	}	
	if (!SALES_RESULT.equals("") && !SALES_RESULT.equals("--"))
	{
		if (SALES_RESULT.equals("No Revise"))
		{
			sql += " and a.SALES_CONFIRMED_RESULT in (0,4)";
		}
		else if (SALES_RESULT.equals("Hold Order"))
		{
			sql += " and a.SALES_CONFIRMED_RESULT in (2)";
		}
		else if (SALES_RESULT.equals("Revise Order"))
		{
			sql += " and a.SALES_CONFIRMED_RESULT in (1)";
		}
	}
	if (!CUSTPO.equals(""))  //add by Peggy 20160325
	{
		sql += " and (a.CUSTOMER_PO LIKE '"+CUSTPO+"%' or a.SOURCE_CUSTOMER_PO LIKE '"+CUSTPO+"%')";
	}
	if (!PULL_SDATE.equals("") || !PULL_EDATE.equals(""))
	{
		//sql += " and a.schedule_ship_date  BETWEEN TO_DATE('"+(PULL_SDATE.equals("")?"20150101":PULL_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (PULL_EDATE.equals("")?"TO_CHAR(SYSDATE+365,'yyyymmdd')":PULL_EDATE)+"','yyyymmdd')+0.99999";
		sql += " and a.schedule_ship_date  BETWEEN TO_DATE('"+(PULL_SDATE.equals("")?"20150101":PULL_SDATE)+"','yyyymmdd') AND TO_DATE("+ (PULL_EDATE.equals("")?"TO_CHAR(SYSDATE+365,'yyyymmdd')":"'"+PULL_EDATE+"'")+",'yyyymmdd')+0.99999";
	}	
	if (!REVISE_SDATE.equals("") || !REVISE_EDATE.equals(""))
	{
		//sql += " and a.schedule_ship_date  BETWEEN TO_DATE('"+(PULL_SDATE.equals("")?"20150101":PULL_SDATE)+"','yyyymmdd') AND TO_DATE('"+ (PULL_EDATE.equals("")?"TO_CHAR(SYSDATE+365,'yyyymmdd')":PULL_EDATE)+"','yyyymmdd')+0.99999";
		sql += " and (a.STATUS = 'CLOSED' and a.last_update_date  BETWEEN TO_DATE('"+(REVISE_SDATE.equals("")?"20150101":REVISE_SDATE)+"','yyyymmdd') AND TO_DATE("+ (REVISE_EDATE.equals("")?"TO_CHAR(SYSDATE,'yyyymmdd')":"'"+REVISE_EDATE+"'")+",'yyyymmdd')+0.99999)";
	}	
	if (UserName.equals("DANNY_LIN")) //add by Peggy 20210603
	{
		sql += " and tsc_inv_category(a.SOURCE_ITEM_ID,43,1100000003) in ('PRD','PRD-Subcon')";
	}
	sql += "  order by a.SALES_GROUP,a.request_no,CASE WHEN PC_REMARKS ='PC調整' THEN (SELECT SEQ_ID FROM tsc_om_salesorderrevise_req_v  X where x.temp_id=a.temp_id and x.so_line_id=a.so_line_id and x.seq_id<>a.seq_id and rownum=1) ELSE  (SELECT MIN(SEQ_ID) FROM tsc_om_salesorderrevise_req_v  X where x.temp_id=a.temp_id and x.so_line_id=a.so_line_id) END,a.seq_id,a.SO_NO||'-'||a.LINE_NO";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 
		if (chkma.equals("Y")) 
		{
			if (rs.getInt("ODR_REVISE_SEQ")!=1) continue;
		}	
		if (rowcnt==0)
		{
		%>
<table align="center" width="2350" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#E9F8F2;color:#000000">
		<td rowspan="2" width="80" align="center">Request No </td>
		<td rowspan="2" width="60" align="center">Sales Group</td>
		<td rowspan="2" width="100" align="center">Customer</td>
		<td rowspan="2" width="80" align="center">MO#</td>
		<td rowspan="2" width="30" align="center">Line#</td>	
		<td rowspan="2" width="90" align="center">Original Item Desc </td>	
		<td rowspan="2" width="90" align="center">TSC Package </td>	
		<td rowspan="2" width="90" align="center">Original Cust PO</td>	
		<td rowspan="2" width="50" align="center">Original Qty </td>	
		<td rowspan="2" width="60" align="center">Original TW SSD </td>	
		<td rowspan="2" width="60" align="center">Original SSD </td>	
		<td style="background-color:#006699;color:#ffffff" colspan="5" align="center">Order Revise Detail </td>
		<td style="background-color:#FF6600;color:#ffffff" colspan="7" align="center">PC Replied Detail </td>
		<td rowspan="2" width="60" align="center">Sales Confirm Result </td>
		<td rowspan="2" width="120" align="center">Change Reason</td>
		<td rowspan="2" width="70" align="center">Change Comments</td>
		<td rowspan="2" width="100" align="center">New MO#/Line#</td>	
		<td rowspan="2" width="80">Created by </td>
		<td rowspan="2" width="60">Creation Date </td>
		<td rowspan="2" width="70">Replied by </td>
		<td rowspan="2" width="60">Replied Date </td>
		<td rowspan="2" width="80">Last Updated by </td>
		<td rowspan="2" width="60">Last Update Date</td>
		<td rowspan="2" width="100" align="center">Status</td>	
		<td rowspan="2" width="20" align="center">Resend Times</td>	
		<td rowspan="2" width="80" align="center">Resend From Request</td>	
		<%
		if (chkma.equals("Y"))
		{
		%>
		<td rowspan="2" width="50" align="center">ERP MO SSD</td>	
		<%
		}
		%>
	</tr>
	<tr style="background-color:#006699;color:#ffffff">
		<!--<td width="40" align="center">Order<br>Type</td>-->
		<!--<td width="80" >Customer</td>-->
		<!--<td width="50">Ship To</td>-->
		<!--<td width="50">Bill To</td>-->
		<!--<td width="50">Deliver To</td>-->
		<!--<td width="100">Item Desc</td>-->
		<!--<td width="100">Cust P/N</td>-->
		<!--<td width="100">Cust PO</td>-->
		<!--<td width="60">Shipping<br>Method</td>-->
		<td width="50">Order Qty</td>
		<td width="60">TW SSD pull in/out</td>
		<td width="60">SSD pull in/out</td>
		<td width="100">Others field revise description</td>
		<!--<td width="50">Request Date</td>-->
		<!--<td width="60">FOB</td>-->
		<td width="60" align="center">Sales Remark </td>
		<td width="60" align="center" style="background-color:#FF6600;color:#ffffff">Plant Code </td>
		<td width="50" style="background-color:#FF6600;color:#ffffff">PC QTY </td>
		<td width="60" style="background-color:#FF6600;color:#ffffff">PC SSD </td>
		<td width="50" style="background-color:#FF6600;color:#ffffff">PC TW SSD</td>
		<td width="50" align="center" style="background-color:#FF6600;color:#ffffff">PC Result </td>			
		<td width="60" align="center" style="background-color:#FF6600;color:#ffffff">PC Remarks</td>
		<td width="500" align="center" style="background-color:#FF6600;color:#ffffff">Excess Status</td>
	</tr>
		<%
		}
		rowcnt++;
		id=rs.getString("temp_id")+"."+rs.getString("seq_id");
		%>
	<tr id="tr<%=rowcnt%>">
		<%
		if (!rs.getString("temp_id").equals(temp_id) || !rs.getString("so_line_id").equals(so_line_id))
		{
			temp_id = rs.getString("temp_id");
			so_line_id=rs.getString("so_line_id");
		
		%>		
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("request_no")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SALES_GROUP")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_customer")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>" onClick="showRemarks(<%=rs.getString("so_header_id")%>)"><%=rs.getString("SO_NO")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("LINE_NO")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_item_desc")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("tsc_package")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
		<td align="right" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_so_qty")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("orig_schedule_ship_date_tw")==null?"&nbsp;":rs.getString("orig_schedule_ship_date_tw"))%>
		<%
		//add by Peggy 20210401
		if ((UserRoles.indexOf("Sale,")>=0 || UserRoles.indexOf("admin")>=0) && (rs.getString("status").equals("AWAITING_CONFIRM")||rs.getString("status").equals("CONFIRMED")) && !rs.getString("orig_schedule_ship_date_tw").equals(rs.getString("erp_ssd")))
		{
			out.println("<br><font color='#ff0000'>ERP SSD:"+rs.getString("erp_ssd")+"</font>");
		}
		%>		</td>	
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%></td>
		<%
		}
		%>
		<!--<td><%=(rs.getString("ORDER_TYPE")==null?"&nbsp;":rs.getString("ORDER_TYPE"))%></td>-->
		<!--<td><%=(rs.getString("CUSTOMER_NUMBER")==null?"&nbsp;":"("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("SHIP_TO_location_ID")==null?"&nbsp;":"("+rs.getString("SHIP_TO_location_ID")+")"+rs.getString("ship_to"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("bill_TO_location_ID")==null?"&nbsp;":"("+rs.getString("bill_TO_location_ID")+")"+rs.getString("bill_to"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("deliver_TO_location_ID")==null?"&nbsp;":"("+rs.getString("deliver_TO_location_ID")+")"+rs.getString("deliver_to"))%></td>-->
		<!--<td><%=(rs.getString("item_desc")==null?"&nbsp;":rs.getString("item_desc"))%></td>-->
		<!--<td><%=(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))%></td>-->
		<!--<td><%=(rs.getString("CUSTOMER_PO")==null?"&nbsp;":rs.getString("CUSTOMER_PO"))%></td>-->
		<!--<td><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></td>-->
		<td align="right"><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE_TW")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE_TW"))%></td>
		<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%></td>
		<td <%=(rs.getString("item_name")!=null?"onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+rs.getString("item_name")+'"'+")'":"")%>><%=(rs.getString("others_field_revise_desc")==null?"&nbsp;":rs.getString("others_field_revise_desc"))%></td>
		<!--<td><%=(rs.getString("REQUEST_DATE")==null?"&nbsp;":rs.getString("REQUEST_DATE"))%></td>-->
		<!--<td><%=(rs.getString("FOB")==null?"&nbsp;":rs.getString("FOB"))%></td>-->
		<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
		<td align="center"><%=rs.getString("ALENGNAME")%></td>
		<td align="right"><%=(rs.getString("PC_SO_QTY")==null?"&nbsp;":rs.getString("PC_SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("PC_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("PC_SCHEDULE_SHIP_DATE"))%></td>
		<td align="center"><%=(rs.getString("PC_SCHEDULE_SHIP_DATE_TW")==null?"&nbsp;":rs.getString("PC_SCHEDULE_SHIP_DATE_TW"))%></td>
		<td align="center" <%=(rs.getString("pc_confirmed_result")==null?"":(rs.getString("pc_confirmed_result").equals("A")?" style='background-color:#C4F8A5'":" style='background-color:#F9DAFC'"))%>><%=(rs.getString("pc_confirmed_result")==null?"&nbsp;":(rs.getString("pc_confirmed_result").equals("A")?"Accept":"Reject"))%></td>
		<td><%=(rs.getString("pc_confirmed_reason")==null?"":rs.getString("pc_confirmed_reason"))+(rs.getString("pc_remarks")==null?"":(rs.getString("pc_confirmed_reason")!=null?",":"")+rs.getString("pc_remarks"))%></td>
		<td><%=(rs.getString("excess_status")==null?"":rs.getString("excess_status"))%></td>
		<td align="center" <%=(rs.getString("SALES_CONFIRMED_RESULT")==null?"":(rs.getString("SALES_CONFIRMED_RESULT").equals("Revise Order")?" style='background-color:#C4F8A5'":(rs.getString("SALES_CONFIRMED_RESULT").equals("Hold Order")?" style='background-color:#F9DAFC'":" style='background-color:#FFFF00'")))%>><%=(rs.getString("SALES_CONFIRMED_RESULT")==null?"&nbsp;":rs.getString("SALES_CONFIRMED_RESULT"))%></td>
		<td><%=(rs.getString("CHANGE_REASON")==null?"&nbsp;":rs.getString("CHANGE_REASON"))%></td>
		<td><%=(rs.getString("CHANGE_COMMENTS")==null?"&nbsp;":rs.getString("CHANGE_COMMENTS"))%></td>
		<td><%=(rs.getString("new_order")==null?"&nbsp;":rs.getString("new_order"))%></td>
		<td><%=rs.getString("CREATED_BY")%></td>
		<td align="center"><%=rs.getString("CREATION_DATE")%></td>
		<td><%=(rs.getString("PC_CONFIRMED_BY")==null?"&nbsp;":rs.getString("PC_CONFIRMED_BY"))%></td>
		<td align="center"><%=(rs.getString("PC_CONFIRMED_DATE")==null?"&nbsp;":rs.getString("PC_CONFIRMED_DATE"))%></td>
		<td><%=(rs.getString("LAST_UPDATED_BY")==null?"&nbsp;":rs.getString("LAST_UPDATED_BY"))%></td>
		<td align="center"><%=(rs.getString("LAST_UPDATE_DATE")==null?"&nbsp;":rs.getString("LAST_UPDATE_DATE"))%></td>
		<td><%=rs.getString("status")%></td>
		<td align="right"><%=(rs.getString("RESEND_TIMES")==null?"&nbsp;":rs.getString("RESEND_TIMES"))%></td>
		<td><%=(rs.getString("RESEND_FROM_REQUEST_NO")==null?"&nbsp;":rs.getString("RESEND_FROM_REQUEST_NO"))%></td>
		<%
		if (chkma.equals("Y"))
		{
		%>
		<td><%=(rs.getString("erp_ssd")==null?"&nbsp;":rs.getString("erp_ssd"))%></td>
		<%
		}
		%>		
	</tr>
		<%
	}
	rs.close();
	statement.close();

	if (rowcnt <=0) 
	{
		out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
	}
	else
	{
	%>
  </table>
	<%
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception:"+e.getMessage()+"</font></div>");
}
%>
<input type="hidden" name="queryCount" value="<%=queryCount%>">
<input type="hidden" name="TEMP_ID" VALUE="<%=TEMP_ID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
