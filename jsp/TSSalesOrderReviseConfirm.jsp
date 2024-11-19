<!-- 20180917 Peggy,新增package欄位-->
<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java" %>
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
<%@ page import="SalesDRQPageHeaderBean,ComboBoxBean,DateBean" %>
<html>
<head>
<title>Sales Order Revise for Confirm</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxBean1" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxBean2" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="comboBoxBean3" scope="page" class="ComboBoxBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setExcel(URL)
{
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
	var chvalue="",so_line_id="";
	if (document.MYFORM.ACODE.value=="" || document.MYFORM.ACODE.value=="--")
	{
		alert("Please choose action code!");
		return false;		
	}
	if (document.MYFORM.ACODE.value=="HOLD")
	{
		for (var i =0 ; i <document.MYFORM.HOLD_CODE.length ;i++)
		{
			if (document.MYFORM.HOLD_CODE[i].checked) chkcnt++;
		}
		if (chkcnt <=0)
		{
			alert("Please choose a hold code!");
			return false;
		}		
		if (document.MYFORM.HOLD_REASON.value=="")
		{
			alert("Please enter a hold reason!");
			return false;		
		}		
	}
	chkcnt=0;	
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
		if (chkvalue==true)
		{
			if (document.MYFORM.elements["status_"+lineid].value=="R" && document.MYFORM.ACODE.value=="REVISE")
			{
				alert("Can not revise a rejected order!!");
				return false;
			}
			
			so_line_id = document.MYFORM.elements["so_line_id_"+lineid].value;
			if (iLen !=1)
			{
				for (var j=1 ; j <= iLen ;j++)
				{
					if ( j!=i && document.MYFORM.chk[j-1].checked==false)
					{
						if (document.MYFORM.elements["so_line_id_"+document.MYFORM.chk[j-1].value].value==so_line_id)
						{
							alert("Same order must be together select!");
							return false;							
						}
					}
				}
			} 			
			chkcnt ++;
		}
	}
	if (chkcnt <=0)
	{
		alert("Please select to revise order data!");
		return false;
	}
	
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";	
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;
	document.MYFORM.btnExport.disabled=true;
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}
function setOPTValue()
{
	if (document.MYFORM.ACODE.value=="HOLD")
	{
		document.getElementById("span2").style.visibility ="hidden";
		document.getElementById("span1").style.visibility ="visible";
		document.MYFORM.HOLD_REASON.value="";
		for (var i =0 ; i <document.MYFORM.HOLD_CODE.length ;i++)
		{
			document.MYFORM.HOLD_CODE[i].checked=false;
		}
		document.MYFORM.ACODE.style.backgroundColor="#F9DAFC";
	}
	else if (document.MYFORM.ACODE.value=="CLOSED")
	{
		document.getElementById("span2").style.visibility ="visible";
		document.getElementById("span1").style.visibility ="hidden";
		document.MYFORM.HOLD_REASON.value="";
		for (var i =0 ; i <document.MYFORM.HOLD_CODE.length ;i++)
		{
			document.MYFORM.HOLD_CODE[i].checked=false;
		}
		document.MYFORM.ACODE.style.backgroundColor="#ffffff";
	}
	else
	{
		document.getElementById("span1").style.visibility ="hidden";
		document.getElementById("span2").style.visibility ="visible";
		document.MYFORM.HOLD_REASON.value="";
		for (var i =0 ; i <document.MYFORM.HOLD_CODE.length ;i++)
		{
			document.MYFORM.HOLD_CODE[i].checked=false;
		}		
		document.MYFORM.ACODE.style.backgroundColor="#C4F8A5";
	}
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
String sql = "",request_no="",so_line_id="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String SDATE=request.getParameter("SDATE");
if (SDATE==null)
{
	dateBean.setAdjDate(-30);
	SDATE=dateBean.getYearMonthDay();
	dateBean.setAdjDate(30);
}
String EDATE=request.getParameter("EDATE");
if (EDATE==null) EDATE="";
String MONO=request.getParameter("MONO");
if (MONO==null) MONO="";
String queryCount = request.getParameter("queryCount");
if (queryCount==null) queryCount="0";
queryCount = ""+(Integer.parseInt(queryCount)+1);
String CREATEDBY=request.getParameter("CREATEDBY");
if (CREATEDBY==null || CREATEDBY.equals("--"))
{
	CREATEDBY="";
	if (UserRoles.indexOf("admin")<0)
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
	}}
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String RESULT = request.getParameter("RESULT");
if (RESULT==null || RESULT.equals("--")) RESULT="";
String strBackColor="",id="",tsch_user="";
int rowcnt=0;
%>
</head>
<body>
<FORM ACTION="../jsp/TSSalesOrderReviseConfirm.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Order Revise for Confirm</div>
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
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#E4F0F1">
	<tr>
		<td width="8%" align="right">Sales Group：</td>
		<td width="12%">
		<%
		try
		{   
			//sql = "select MASTER_GROUP_NAME, MASTER_GROUP_NAME from tsc_om_group_master a where ORG_ID in (41,325) ";
			//if (UserRoles.indexOf("admin")<0)
			//{
			//	sql += " and a.MASTER_GROUP_NAME='"+salesGroup+"'";
			//}
			//sql += " order by 1";
			//sql = " SELECT distinct f.group_name,f.group_name"+
            //      " FROM oraddman.wsuser a,fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f"+
    		//	  " WHERE a.erp_user_id=b.user_id"+
            //     " and b.employee_id = c.person_id"+
            //      " AND c.employee_number = d.salesrep_number"+
            //      " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
            //      " and e.group_id=f.group_id";
			//if ( UserRoles.indexOf("admin")<0)
			//{
			//	sql += " and a.username ='"+UserName+"'";
			//}
			//sql += " UNION ALL "+
            //       " select 'SAMPLE','SAMPLE' from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' AND x.TSSALEAREANO='020'"+
            //       " order by 1";
			//sql = "select distinct SALES_GROUP, SALES_GROUP from oraddman.tsc_om_salesorderrevise_req a where 1=1";
			//if (UserRoles.indexOf("admin")<0) sql += " and a.created_by ='"+UserName+"'";
			sql = " SELECT distinct d.group_name,d.group_name "+
			      " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_req e"+
                  " where a.TSSALEAREANO=b.SALES_AREA_NO "+
                  //" and b.MASTER_GROUP_ID=c.master_group_id"+
                  //" and c.master_group_id=d.master_group_id"+
				  " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                  " and c.master_group_id=d.master_group_id"+				  
                  " and d.group_name=e.SALES_GROUP"+
				  " and b.SALES_AREA_NO<>'020'";
			if (UserRoles.indexOf("admin")<0) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " union all"+
			       " select distinct ALNAME,ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and b.SALES_AREA_NO='020'";
			if (UserRoles.indexOf("admin")<0) sql += " and a.USERNAME ='"+UserName+"'";
			sql += " order by 1";			
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setFieldName("SALESGROUP");	   
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
		<td width="8%" align="right">Plant Code：</td>
		<td width="12%">
		<%
		try
		{   
			sql = "select distinct PLANT_CODE, ALENGNAME from oraddman.tsc_om_salesorderrevise_req a,oraddman.tsprod_manufactory b where  a.plant_code=b.MANUFACTORY_NO order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean3.setRs(rs2);
			comboBoxBean3.setSelection(PLANTCODE);
			comboBoxBean3.setFontSize(11);
			comboBoxBean3.setFontName("Tahoma,Georgia");
			comboBoxBean3.setFieldName("PLANTCODE");	
			if (UserRoles.indexOf("admin")<0 && (UserRoles.indexOf("MPC_003")>=0 || UserRoles.indexOf("MPC_User")>=0))
			{
				comboBoxBean3.setOnChangeJS("this.value="+'"'+userProdCenterNo+'"');  
			}			   
			out.println(comboBoxBean3.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		}		
		%>
		</td>
		<td width="8%" align="right">Customer：</td>
		<td width="12%"><input type="text" name="CUST" value="<%=CUST%>" style="font-family:Tahoma,Georgia;font-size:11px" size="30"></td>
		<td width="8%" align="right">Item Desc：</td> 
		<td width="12%"><input type="text" name="ITEMDESC" value="<%=ITEMDESC%>" style="font-family:Tahoma,Georgia;font-size:11px" size="22"></td>
		<td width="8%"align="right">Request No：</td>
		<td width="12%"><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>		
		
	</tr>
	<tr>
		<td align="right">Created By：</td>
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT CREATED_BY,CREATED_BY CREATED_BY1 FROM tsc_om_salesorderrevise_req_v a";
			if (UserRoles.indexOf("admin")<0)
			{
				sql += " where (exists ( SELECT 1 FROM oraddman.wsuser x,fnd_user b, per_all_people_f c, jtf_rs_salesreps d,tsc_om_group_salesrep e,tsc_om_group f"+
    			       "                WHERE x.username ='"+UserName+"'"+
                       "                AND x.erp_user_id=b.user_id"+
                       "                and b.employee_id = c.person_id"+
                       //" AND c.employee_number = d.salesrep_number(+)"+
					   " AND (c.employee_number = d.salesrep_number or b.user_name=d.salesrep_number)"+ //add by Peggy 20230417
                       " AND nvl2(e.salesrep_id,d.salesrep_id,b.user_id) = nvl(e.salesrep_id,e.user_id)"+
                       " and e.group_id=f.group_id"+
					   " and f.group_name=a.sales_group)"+
					   " or exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"'"+
					   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";
			}
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean2.setRs(rs2);
			comboBoxBean2.setSelection(CREATEDBY);
			comboBoxBean2.setFontSize(11);
			comboBoxBean2.setFontName("Tahoma,Georgia");
			comboBoxBean2.setFieldName("CREATEDBY");	   
			out.println(comboBoxBean2.getRsString());				   
			rs2.close();   
			st2.close();     	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>	
		</td>
		<td align="right">MO#：</td> 
		<td><input type="text" name="MONO" value="<%=MONO%>" style="font-family:Tahoma,Georgia;font-size:11px"></td>
		<td align="right">Creation Date：</td>
		<td colspan="3"><input type="TEXT" NAME="SDATE" value="<%=SDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.SDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		<input type="TEXT" NAME="EDATE" value="<%=EDATE%>" style="font-size:11px;font-family: Tahoma,Georgia;" size="8" onKeyPress="return event.keyCode >= 48 && event.keyCode <=57">						
		<A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.EDATE);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A>
		</td>
		<td align="right">PC Replied：</td> 
		<td>		
		<%
		try
		{   
			sql = "SELECT DISTINCT PC_CONFIRMED_RESULT,DECODE(PC_CONFIRMED_RESULT,'A','Accept','Reject') FROM oraddman.tsc_om_salesorderrevise_req WHERE STATUS <>'AWAITING_CONFIRM' AND PC_CONFIRMED_RESULT IS NOT NULL ORDER BY PC_CONFIRMED_RESULT";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean1.setRs(rs2);
			comboBoxBean1.setSelection(RESULT);
			comboBoxBean1.setFieldName("RESULT");	   
			comboBoxBean1.setFontSize(11);
			comboBoxBean1.setFontName("Tahoma,Georgia");
			out.println(comboBoxBean1.getRsString());				   
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
	  <td colspan="10" align="center"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSSalesOrderReviseConfirm.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSSalesOrderReviseExcel.jsp?RTYPE=CONFIRMED&STATUS=CONFIRMED')"></td>
	</tr>
</TABLE>
<hr>
<%
try
{
	PreparedStatement statement1 = con.prepareStatement("select count(1) from tsc_om_order_privilege where RFQ_USERNAME=?");
	statement1.setString(1,UserName);
	ResultSet rs1=statement1.executeQuery();
	if (rs1.next())
	{
		tsch_user=(rs1.getInt(1)>0 ?"Y":"N");;
	}
	rs1.close();
	statement1.close();
	
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
		  ",nvl(a.so_qty,a.source_so_qty) so_qty"+
		  ",to_char(a.request_date,'yyyymmdd') request_date"+
		  //",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
		  //",to_char(a.pc_schedule_ship_date,'yyyymmdd') pc_schedule_ship_date"+
		  ",to_char(a.schedule_ship_date+nvl(a.to_tw_days,0),'yyyymmdd') schedule_ship_date"+        //add by Peggy 20191003
		  ",to_char(a.pc_schedule_ship_date+nvl(a.to_tw_days,0),'yyyymmdd') pc_schedule_ship_date"+  //add by Peggy 20191003
		  ",a.packing_instructions"+
		  ",a.plant_code"+
		  ",a.change_reason"+
		  ",a.change_comments"+
		  ",a.created_by"+
		  ",to_char(a.creation_date,'yyyymmdd') creation_date"+
		  ",a.pc_confirmed_by"+
          ",to_char(a.pc_confirmed_date,'yyyymmdd') pc_confirmed_date"+
          ",a.last_updated_by"+
          ",to_char(a.last_update_date,'yyyymmdd') last_update_date"+
		  ",a.status"+
		  ",a.temp_id"+
		  ",a.seq_id"+
		  ",a.ship_to"+
		  ",a.pc_remarks"+
		  ",a.remarks"+
		  ",a.pc_confirmed_result"+
		  ",a.pc_so_qty"+
		  ",b.ALENGNAME"+
		  ",a.SOURCE_SO_QTY orig_so_qty"+
		  ",a.SOURCE_ITEM_DESC orig_item_desc"+
		  ", to_char(a.source_ssd,'yyyymmdd') AS  orig_schedule_ship_date"+
		  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
		  //" else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as orig_customer"+ 
		  //" else '('||e.customer_number||')'|| nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as orig_customer"+  //modify by Peggy 20220810
		  " else '('||e.ACCOUNT_NUMBER||')'|| nvl(e.CUSTOMER_SNAME,e.customer_name) end ||case when a.source_customer_id=14980 then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as orig_customer"+  //modify by Peggy 20220810
		  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
		  ",a.ship_to_location_id"+
		  ",a.SOURCE_CUSTOMER_PO"+
		  ",a.deliver_to_location_id"+
		  ",a.DELIVER_TO_ORG_ID"+
		  ",a.DELIVER_TO"+		
		  ",a.BILL_TO_LOCATION_ID"+
		  ",a.BILL_TO_ORG_ID"+
		  ",a.BILL_TO"+
		  ",a.SOURCE_BILL_TO_ORG_ID"+		
		  ",a.SOURCE_BILL_TO_LOCATION_ID"+
		  ",a.SOURCE_SHIP_TO_LOCATION_ID"+
		  ",a.SOURCE_DELIVER_TO_LOCATION_ID"+
		  ",a.FOB_POINT_CODE"+
		  ",a.SOURCE_FOB_POINT_CODE"+
		  ",a.FOB"+
		  ",replace(replace(tsc_order_revise_pkg.GET_REVISE_DESC(a.temp_id,a.seq_id,'SALES'),chr(13),''),chr(10),'<br>') others_field_revise_desc"+
		  ",tsc_inv_category(d.inventory_item_id,43,23) tsc_package"+ //add by Peggy 20180917
		  ",nvl(to_char(d.schedule_ship_date,'yyyymmdd'),'not found') erp_ssd"+ //add by Peggy 20200922
		  ",(select count(1) from tsc.tsc_shipping_advise_pc_sg tsap where tsap.so_no=a.so_no and tsap.so_line_number=a.line_no) sg_advise_cnt"+ //add by Peggy 20210621
		  ",nvl((select distinct case when x.flow_status_code IN ('SHIPPED','PICKED','CLOSED','PRE-BILLING_ACCEPTANCE') then 'CLOSED' ELSE 'AWAITING_SHIPPING' END from tsc.tsc_shipping_advise_pc_sg tsap,ont.oe_order_lines_all x  where tsap.so_no=a.so_no and tsap.so_line_number=a.line_no and tsap.so_line_id=x.line_id),d.flow_status_code) flow_status_code  "+ //add by Peggy 20220127
		  ",case when a.supplier_number is not null and TSC_LABEL_PKG.CHECK_CUST_SUPPLIER_NUMBER (a.SO_LINE_ID)<>'NA' then 'Y' else 'N' end print_flag"+ //add by Peggy 20220428
		  ",to_char(a.SOURCE_REQUEST_DATE,'yyyymmdd') ORIG_CRD"+ //add by Peggy 20220810
		  ",(SELECT MEANING FROM FND_LOOKUP_VALUES WHERE LOOKUP_TYPE='SHIP_METHOD' AND LANGUAGE='US' AND LOOKUP_CODE=A.SOURCE_SHIPPING_METHOD) AS ORIG_SHIPPING_METHOD"+  //add by Peggy 20220810
		  ",a.pc_confirmed_reason"+ //add by Peggy 20230907
		  ",tsc_om_check_shipping_advise(a.so_header_id,a.so_line_id) shipping_advise_flag"+//add by Peggy 20231026
		  ",TSC_OM_CHECK_WMS_LOCK(a.so_line_id,'LOCK') wms_flag"+ //add by Peggy 20231026
  	      " from oraddman.tsc_om_salesorderrevise_req a"+
		  ",oraddman.tsprod_manufactory b"+
		  //",ar_customers e"+
		  ",tsc_customer_all_v e"+ //modify by Peggy 20221111
		  ",ont.oe_order_lines_all d"+		  
		  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS c"+
		  //",ORADDMAN.TSC_CHINA_TO_TAIWAN_DAYS g"+  //modify by Peggy 20200911
		  ",hz_cust_accounts end_cust"+ //modify by Peggy 20200520
		  " where a.source_customer_id=e.customer_id"+
		  " and a.plant_code =b.manufactory_no(+)"+
          " and a.STATUS='CONFIRMED'"+
		  " and a.so_header_id=d.header_id"+
		  " and a.so_line_id=d.line_id"+		  
		  " AND d.end_customer_id = end_cust.cust_account_id(+)"+ //add by Peggy 20200520
          //" AND A.PLANT_CODE=c.PLANT_CODE(+)"+
          //" AND NVL(A.ORDER_TYPE,SUBSTR(A.SO_NO,1,4))=c.ORDER_NUM(+)"+
          //" AND A.PLANT_CODE=g.PLANT_CODE(+)"+
          //" AND NVL(A.ORDER_TYPE,SUBSTR(A.SO_NO,1,4))=g.ORDER_NUM(+)"+
		  " and a.GROUP_ID is null";
	if (!salesGroup.equals("--") && !salesGroup.equals(""))
	{
		sql += " and a.SALES_GROUP='"+salesGroup+"'";
	}
	else if (UserRoles.indexOf("admin")<0)
	{
		//sql += " and (exists ( SELECT 1 FROM oraddman.wsuser x,fnd_user y, per_all_people_f z, jtf_rs_salesreps js,tsc_om_group_salesrep tos,tsc_om_group tog"+
    	//		       "                WHERE x.username ='"+UserName+"'"+
        //               "                AND x.erp_user_id=y.user_id"+
        //               "                and y.employee_id = z.person_id"+
        //               " AND z.employee_number = js.salesrep_number"+
        //               " AND nvl2(tos.salesrep_id,js.salesrep_id,y.user_id) = nvl(tos.salesrep_id,tos.user_id)"+
        //               " and tos.group_id=tog.group_id"+
		//			   " and tog.group_name=a.sales_group)"+
		sql += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_req e"+
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
	if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
	{
		sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
	}	
	if (!UserRoles.equals("admin") && tsch_user.equals("Y"))  //add by Peggy 20160712
	{
		//sql += " AND EXISTS (SELECT 1 FROM TSC_OM_ORDER_PRIVILEGE X,AR_CUSTOMERS Y,HZ_CUST_ACCOUNTS Z WHERE X.RFQ_USERNAME='"+UserName+"' AND X.CUSTOMER_ID=Y.CUSTOMER_ID AND Y.CUSTOMER_ID= Z.CUST_ACCOUNT_ID AND NVL(Z.ACCOUNT_NAME, Y.CUSTOMER_NAME) = case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) end)";
	}		
	if (!CUST.equals(""))
	{
		//sql += " and nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) like '%"+CUST+"%'";
		sql += " and case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(e.CUSTOMER_SNAME,e.customer_name) end like '%"+CUST+"%'";
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
		sql += " and a.so_no LIKE '"+MONO+"%'";
	}
	if (!SDATE.equals("") || !EDATE.equals(""))
	{
		sql += " and a.CREATION_DATE  BETWEEN TO_DATE('"+(SDATE.equals("")?"20150101":SDATE)+"','yyyymmdd') AND TO_DATE('"+ (EDATE.equals("")?dateBean.getYearMonthDay():EDATE)+"','yyyymmdd')+0.99999";
	}	
	if (!REQUESTNO.equals(""))
	{
		sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
	}
	if (!RESULT.equals("") && !RESULT.equals("--"))
	{
		sql += " and a.PC_CONFIRMED_RESULT = '"+RESULT+"'";
	}		
	sql += " order by a.SALES_GROUP,a.request_no,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (rowcnt==0)
		{
		%>
<table align="center" width="2000" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#9ADADA;color:#000000">
		<td rowspan="2" width="20"><input type="checkbox" name="chkall" onClick="checkall()"></td>	
		<td rowspan="2" width="40" align="center">PC Result</td>	
		<td rowspan="2" width="100" align="center">PC Remarks</td>	
		<td rowspan="2" width="70" align="center">Request No</td>
		<td rowspan="2" width="150" align="center">Customer</td>
		<td rowspan="2" width="80" align="center">MO#</td>
		<td rowspan="2" width="30" align="center">Line#</td>	
		<td rowspan="2" width="90" align="center">Original Item Desc</td>	
		<td rowspan="2" width="90" align="center">TSC Package</td>	
		<td rowspan="2" width="90" align="center">Original Cust PO</td>	
		<td rowspan="2" width="50" align="center">Original Qty</td>	
		<td rowspan="2" width="60" align="center">Original SSD</td>	
	<%
		if (rs.getString("sales_group").equals("TSCE"))
		{
	%>
		<td rowspan="2" width="60" align="center">Original CRD</td>	
		<td rowspan="2" width="60" align="center">Original Shipping Method</td>	
	<%
		}
	%>
		<td style="background-color:#006699;color:#ffffff" colspan="5" align="center">Order Revise Detail </td>
		<td rowspan="2" width="100" align="center">Sales Remark</td>
		<td rowspan="2" width="50">Status</td>
		<td rowspan="2" width="60">Created by </td>
		<td rowspan="2" width="60">Creation Date </td>
		<td rowspan="2" width="60">Replied by </td>
		<td rowspan="2" width="60">Replied Date </td>
		<td rowspan="2" width="60" align="center">Sales Area </td>
		<td rowspan="2" width="60" align="center">Plant Code </td>
	</tr>
	<tr style="background-color:#006699;color:#ffffff">
		<td width="50">Order Qty</td>
		<td width="50">PC  Qty </td>
		<td width="60">SSD pull in/out</td>
		<td width="60">PC SSD </td>
		<td width="160">Others field revise description</td>
		<!--<td width="40" align="center">Order<br>Type</td>-->
		<!--<td width="80" >Customer</td>-->
		<!--<td width="50">Ship To</td>-->
		<!--<td width="50">Bill To</td>-->
		<!--<td width="50">Deliver To</td>-->
		<!--<td width="70">Item Desc</td>-->
		<!--<td width="70">Cust P/N</td>-->
		<!--<td width="60">Cust PO</td>-->
		<!--<td width="60">Shipping<br>Method</td>-->
		<!--<td width="50">Request Date</td>-->
		<!--<td width="60">FOB</td>-->
	</tr>
		<%
		}
		rowcnt++;
		id=rs.getString("temp_id")+"."+rs.getString("seq_id");
		%>
	<tr id="tr<%=rowcnt%>">
		<td align="center">
		<input type="checkbox" name="chk" value="<%=id%>" onClick="setCheck(<%=(rowcnt)%>)" <%=(rs.getString("pc_confirmed_result")==null || (rs.getString("pc_confirmed_result").equals("A") && ((rs.getInt("sg_advise_cnt")>0 || rs.getString("shipping_advise_flag").equals("TRUE") || rs.getString("wms_flag").equals("T")) && !rs.getString("flow_status_code").equals("CLOSED")) || (rs.getString("pc_confirmed_result").equals("A") && rs.getString("print_flag").equals("Y")))?" disabled":"")%>>
		</td>
		<td align="center" <%=(rs.getString("pc_confirmed_result").equals("A")?" style='background-color:#C4F8A5'":" style='background-color:#F9DAFC'")%>><%=(rs.getString("pc_confirmed_result")==null?"&nbsp;":(rs.getString("pc_confirmed_result").equals("A")?"Accept":"Reject"))%><input type="hidden" name="status_<%=id%>" value="<%=rs.getString("pc_confirmed_result")%>"></td>
		<td><%=(rs.getString("pc_confirmed_reason")==null?"":rs.getString("pc_confirmed_reason"))+(rs.getString("pc_remarks")==null?"":(rs.getString("pc_confirmed_reason")!=null?",":"")+rs.getString("pc_remarks"))%></td>
		<%
		if (!rs.getString("so_line_id").equals(so_line_id))
		{
			so_line_id=rs.getString("so_line_id");
		
		%>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("request_no")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_customer")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SO_NO")%><%=((rs.getInt("sg_advise_cnt")>0 || rs.getString("shipping_advise_flag").equals("TRUE") || rs.getString("wms_flag").equals("T"))?"<br><font color='#ff0000'>工廠已排出貨</font>":"")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("LINE_NO")%><%=(rs.getString("print_flag").equals("Y")?"<font color='red'>標籤已打印</font>":"")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_item_desc")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("tsc_package")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("source_customer_po")%></td>
		<td align="right" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_so_qty")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_schedule_ship_date")%><%=(!rs.getString("erp_ssd").equals(rs.getString("orig_schedule_ship_date"))?"<br><font color='#ff0000'>ERP SSD:"+rs.getString("erp_ssd")+"</font>":"")%></td>
		<%
			if (rs.getString("sales_group").equals("TSCE"))
			{
		%>
			<td align="right" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_crd")%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_shipping_method")%></td>
		<%
			}
		%>		
		<%
		}
		%>
		<td align="right" <%=(rs.getString("SO_QTY")!=null && rs.getString("orig_so_qty") != null && !rs.getString("orig_so_qty").equals(rs.getString("SO_QTY"))?" style='color:#ff0000'":"")%>><%=(rs.getString("SO_QTY")==null?"&nbsp;":rs.getString("SO_QTY"))%><input type="hidden" name="so_line_id_<%=id%>" value="<%=so_line_id%>"></td>
		<td align="right" <%=(rs.getString("PC_SO_QTY")!=null && (!rs.getString("SO_QTY").equals(rs.getString("PC_SO_QTY")) ||!rs.getString("orig_SO_QTY").equals(rs.getString("PC_SO_QTY"))) ?" style='color:#ff0000'":"")%>><%=(rs.getString("PC_SO_QTY")==null?"&nbsp;":rs.getString("PC_SO_QTY"))%></td>
		<td align="center"><%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("SCHEDULE_SHIP_DATE"))%></td>
		<td align="center"<%=(rs.getString("PC_SCHEDULE_SHIP_DATE")!=null && rs.getString("SCHEDULE_SHIP_DATE") != null && !rs.getString("SCHEDULE_SHIP_DATE").equals(rs.getString("PC_SCHEDULE_SHIP_DATE"))?" style='color:#ff0000'":"")%>><%=(rs.getString("PC_SCHEDULE_SHIP_DATE")==null?"&nbsp;":rs.getString("PC_SCHEDULE_SHIP_DATE"))%></td>
		<!--<td><%=(rs.getString("others_field_revise_desc")==null?"&nbsp;":rs.getString("others_field_revise_desc"))%></td>-->
		<td <%=(rs.getString("item_name")!=null?"onMouseOver='this.T_ABOVE=false;this.T_WIDTH=250;this.T_OPACITY=80;return escape("+'"'+rs.getString("item_name")+'"'+")'":"")%>><%=(rs.getString("others_field_revise_desc")==null?"&nbsp;":rs.getString("others_field_revise_desc"))%></td>
		<!--<td><%=(rs.getString("ORDER_TYPE")==null?"&nbsp;":rs.getString("ORDER_TYPE"))%></td>-->
		<!--<td><%=(rs.getString("CUSTOMER_NUMBER")==null?"&nbsp;":"("+rs.getString("CUSTOMER_NUMBER")+")"+rs.getString("CUSTOMER_NAME"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("SHIP_TO_location_ID")==null?"&nbsp;":"("+rs.getString("SHIP_TO_location_ID")+")"+rs.getString("ship_to"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("bill_TO_location_ID")==null?"&nbsp;":"("+rs.getString("bill_TO_location_ID")+")"+rs.getString("bill_to"))%></td>-->
		<!--<td valign="top"><%=(rs.getString("deliver_TO_location_ID")==null?"&nbsp;":"("+rs.getString("deliver_TO_location_ID")+")"+rs.getString("deliver_to"))%></td>-->
		<!--<td><%=(rs.getString("item_desc")==null?"&nbsp;":rs.getString("item_desc"))%></td>-->
		<!--<td><%=(rs.getString("CUST_ITEM_NAME")==null?"&nbsp;":rs.getString("CUST_ITEM_NAME"))%></td>-->
		<!--<td><%=(rs.getString("CUSTOMER_PO")==null?"&nbsp;":rs.getString("CUSTOMER_PO"))%></td>-->
		<!--<td><%=(rs.getString("SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SHIPPING_METHOD"))%></td>-->
		<!--<td><%=(rs.getString("REQUEST_DATE")==null?"&nbsp;":rs.getString("REQUEST_DATE"))%></td>-->
		<!--<td><%=(rs.getString("FOB")==null?"&nbsp;":rs.getString("FOB"))%></td>-->
		<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
		<td><%=rs.getString("STATUS")%></td>
		<td><%=rs.getString("CREATED_BY")%></td>
		<td align="center"><%=rs.getString("CREATION_DATE")%></td>
		<td><%=(rs.getString("PC_CONFIRMED_BY")==null?"&nbsp;":rs.getString("PC_CONFIRMED_BY"))%></td>
		<td align="center"><%=(rs.getString("PC_CONFIRMED_DATE")==null?"&nbsp;":rs.getString("PC_CONFIRMED_DATE"))%></td>
		<td align="center"><%=rs.getString("SALES_GROUP")%></td>
		<td align="center"><%=rs.getString("ALENGNAME")%></td>
	</tr>
		<%
	}
	rs.close();
	statement.close();

	if (rowcnt >0) 
	{
	%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#E4F0F1">
	<tr>
		<td>
		  <p><font style="font-family:Tahoma,Georgia;font-size:12px">
	      <jsp:getProperty name="rPH" property="pgAction"/>
	      =></font>
		        <select name="ACODE"  style="font-family:Tahoma,Georgia;font-size:12px" onChange="setOPTValue()">			
		              <option value="--">--
                  <option value="REVISE"><font style="color:#0000CC">Revise Order</font>
                      <option value="HOLD"><font style="color:#FF0000">Hold Order</font>
                          <option value="CLOSED">Closed
            </select>
	        <input type="button" name="submit1" value="Submit" style="font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSSalesOrderReviseProcess.jsp")'>
		        <span id="span1" style="visibility:hidden">
	            <%
		try
		{    
			sql = " SELECT lookup_code,meaning  FROM fnd_lookup_values"+
                  " WHERE lookup_type = ?"+
                  " AND language = ?"+
                  " AND enabled_flag = ?"+
                  " AND LOOKUP_CODE IN (?,?)";
			statement1 = con.prepareStatement(sql);
			statement1.setString(1,"YES_NO_HOLD");
			statement1.setString(2,"US");
			statement1.setString(3,"Y");
			statement1.setString(4,"YC");
			statement1.setString(5,"YP");
			rs1=statement1.executeQuery();
			while (rs1.next())
			{
			%>
		          <input type="radio" name="HOLD_CODE" value="<%=rs1.getString("lookup_code")%>">
		          <font style="font-size:12px;font-family:Tahoma,Georgia"><%=rs1.getString("meaning")%>&nbsp;&nbsp;</font>
	                <%				
			}
			rs1.close();
			statement1.close();		
		} //end of try
		catch (Exception e)
		{
			out.println("Exception2:"+e.getMessage());
		}			
		%>
  &nbsp;&nbsp;<font style="font-family:Tahoma,Georgia;font-size:12px">Hold Reason：</font>
  <input type="text"  name="HOLD_REASON"  value="" SIZE="40" style="font-family:Tahoma,Georgia">
            </span>  <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span id="span2" style="visibility:hidden"><input type="checkbox" name="chkpull" value="Y">
            <font style="font-family:Tahoma,Georgia;font-size:12px">Order request to resend</font></span></td>
	</tr>
</table>
<hr>
	<%
	}
	else
	{
		out.println("<div style='color:#ff0000;font-size:13px' align='center'>No Data Found!!</div>");
	}
}
catch(Exception e)
{
	out.println("<div align='center'><font color='red'>Exception"+e.getMessage()+"</font></div>");
}
%>
<input type="hidden" name="queryCount" value="<%=queryCount%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>
