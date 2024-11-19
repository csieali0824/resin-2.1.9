<%@ page contentType="text/html;charset=utf-8" pageEncoding="big5" language="java"%>
<%@ page import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 10x }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 10x } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 10px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 10px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Confirm for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="FactoryCFMBean" scope="session" class="Array2DimensionInputBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
</head>
<script language="JavaScript" type="text/JavaScript">
function setQuery(URL)
{
	document.MYFORM.action=URL;
	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0,orig_so_qty=0;
	var id="",radflag="",i_res="",so_line_id="";
	if (document.MYFORM.chk.length != undefined)
	{
		chk_len = document.MYFORM.chk.length;
	}
	else
	{
		chk_len = 1;
	}

	for (var i =0 ; i < chk_len ;i++)
	{
		if (chk_len==1)
		{
			chkflag = document.MYFORM.chk.checked; 
			id = document.MYFORM.chk.value;		
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
			id = document.MYFORM.chk[i].value;		
		}
		if (chkflag==true)
		{
			radflag="N";
			
			for(var j = 0; j < document.MYFORM.elements["rdo_"+id].length; j++) 
			{
				if (document.MYFORM.elements["rdo_"+id][j].checked)
				{
					if (j==0)
					{ 
						i_res="A";
					}
					else 
					{
						i_res="R"
					}
					if ((document.MYFORM.elements["SALES_HEAD_APPROVE_DATE_"+id].value==null || document.MYFORM.elements["SALES_HEAD_APPROVE_DATE_"+id].value=="") && (document.MYFORM.elements["pcremark_"+id].value==null || document.MYFORM.elements["pcremark_"+id].value=="")) 
					{
						alert("Line"+(i+1)+": Please fill to confirm a reason on yellow area!!");
						document.MYFORM.elements["pcremark_"+id].value.focus();
						return false;
					}
					radflag="Y";
				}
			}
			if (radflag=="N")
			{
				alert("Line"+(i+1)+": Please choose a result!!");
				return false;
			}
			chkcnt ++;
		}
	}
	if (chkcnt ==0)
	{
		alert("Please select process data!");
		return false;
	}
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	document.MYFORM.submit1.disabled=true;
	document.MYFORM.btnQuery.disabled=true;	
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
}

function setRadioPress(Lineno,objValue,id)
{
	if (objValue=="A")
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#C4F8A5";
		document.getElementById("tdb_"+id).style.backgroundColor ="#C4F8A5";
		document.MYFORM.elements["pcremark_"+id].style.backgroundColor ="#C4F8A5";
	}
	else
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#FEA398";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FEA398";
		document.MYFORM.elements["pcremark_"+id].style.backgroundColor ="#FEA398";
	}
	if (document.MYFORM.chk.length != undefined)
	{
		if (document.MYFORM.chk[Lineno-1].checked==false)
		{
			document.MYFORM.chk[Lineno-1].checked=true;
			setChkboxPress(Lineno,id);
		}
	}
	else
	{
		if (document.MYFORM.chk.checked==false)
		{
			document.MYFORM.chk.checked=true;
			setChkboxPress(Lineno,id);
		}
	}	
}

function setChkboxPress(Lineno,id)
{
	var checkvalue=false;
	if (document.MYFORM.chk.length != undefined)
	{
		checkvalue =document.MYFORM.chk[Lineno-1].checked;
	}
	else
	{
		checkvalue =document.MYFORM.chk.checked;
	}
	if (checkvalue==false)
	{
		for(var i = 0; i < document.MYFORM.elements["rdo_"+id].length; i++) 
		{
			document.MYFORM.elements["rdo_"+id][i].checked=false;
		}
		document.MYFORM.elements["pcremark_"+id].value="";
		document.getElementById("tda_"+id).style.backgroundColor ="#FFFFFF";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FFFFFF";	
		document.MYFORM.elements["pcremark_"+id].style.backgroundColor ="#FFFFFF";
	}
}
// 檢查閏年,判斷日期輸入合法性
function isLeapYear(year) 
{ 
	if((year%4==0&&year%100!=0)||(year%400==0)) 
 	{ 
 		return true; 
 	}  
 	return false; 
} 

function setUpload(URL)
{
	document.getElementById("alpha").style.width=window.screen.width;
	document.getElementById("alpha").style.height=document.body.scrollHeight+"px";
	subWin=window.open(URL,"subwin","left=100,width=900,height=500,scrollbars=yes,menubar=no");  
}
</script>
<%
String sql = "",so_line_id="",show_flag="",id="";
String ACTIONTYPE="AWAITING_APPROVE";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null || salesGroup.equals("--")) salesGroup="";
String MONO=request.getParameter("MONO");
if (MONO==null || MONO.equals("--")) MONO="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null || ITEMDESC.equals("--")) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null || CUST.equals("--")) CUST="";
String CUSTPO=request.getParameter("CUSTPO");
if (CUSTPO==null || CUSTPO.equals("--")) CUSTPO="";
String ACODE=request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String so_qty="",so_ssd="",pc_remarks="",pc_result="",temp_id="";
String strarray[]=new String [7];
int rowcnt=0;
%>
<body> 
<FORM ACTION="../jsp/TSSalesOrderReviseSalesApprove.jsp" METHOD="post" NAME="MYFORM">
<%
if (ACODE.equals("S"))
{
	String chk[]= request.getParameterValues("chk");
	if (chk.length <=0)
	{
		throw new Exception("No Data Found!!");
	}
	else
	{
		try
		{
			for(int i=0; i< chk.length ;i++)
			{
				if (temp_id.equals(""))
				{
					temp_id=chk[i].substring(0,chk[i].indexOf("-"));
				}			
				sql =" update oraddman.tsc_om_salesorderrevise_wkfw a"+
					 " set SALES_HEAD_APPROVE_DATE=case when REGION_SALES_HEAD_PERSON=? then sysdate else SALES_HEAD_APPROVE_DATE end "+	
					 " ,SALES_HEAD_APPROVE_RESULT=case when REGION_SALES_HEAD_PERSON=? then ? else SALES_HEAD_APPROVE_RESULT end "+	
					 " ,SALES_HEAD_APPROVE_MEMO=case when REGION_SALES_HEAD_PERSON=? then ? else SALES_HEAD_APPROVE_MEMO end "+	
					 " ,HQ_SALES_HEAD_APPROVE_DATE=case when HQ_SALES_HEAD_PERSON=? then sysdate else HQ_SALES_HEAD_APPROVE_DATE end "+	
					 " ,HQ_SALES_HEAD_APPROVE_RESULT=case when HQ_SALES_HEAD_PERSON=? then ? else HQ_SALES_HEAD_APPROVE_RESULT end "+	
					 " ,HQ_SALES_HEAD_APPROVE_MEMO=case when HQ_SALES_HEAD_PERSON=? then ? else HQ_SALES_HEAD_APPROVE_MEMO end "+	
					 " where exists (select 1 from oraddman.tsc_om_salesorderrevise_req x where x.temp_id||'-'||x.so_line_id=? and x.temp_id=a.temp_id and x.seq_id=a.seq_id)";
				//out.println(sql);
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,UserName);
				pstmtDt.setString(2,UserName);
				pstmtDt.setString(3,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(4,UserName);			
				pstmtDt.setString(5,request.getParameter("pcremark_"+chk[i]));
				pstmtDt.setString(6,UserName);
				pstmtDt.setString(7,UserName);
				pstmtDt.setString(8,request.getParameter("rdo_"+chk[i]));
				pstmtDt.setString(9,UserName);			
				pstmtDt.setString(10,request.getParameter("pcremark_"+chk[i]));
				pstmtDt.setString(11,chk[i]);
				pstmtDt.executeQuery();
				pstmtDt.close();	
				//out.println(chk[i]);
				
				if (request.getParameter("rdo_"+chk[i]).equals("R"))
				{
					sql = " update oraddman.tsc_om_salesorderrevise_req a"+
						  "	set status=?"+
						  " ,PC_CONFIRMED_RESULT=?"+
						  " ,PC_SO_QTY=null"+
						  " ,PC_SCHEDULE_SHIP_DATE=null"+
						  " ,PC_REMARKS=?"+
						  " ,PC_CONFIRM_ID=apps.tsc_order_revise_pc_id_s.nextval"+
						  " ,PC_CONFIRMED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
						  " ,PC_CONFIRMED_DATE=SYSDATE"+
						  " ,LAST_UPDATED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
						  " ,LAST_UPDATE_DATE=SYSDATE"+
						  "	where a.temp_id||'-'||a.so_line_id=?"+
						  " and exists (select 1 from oraddman.tsc_om_salesorderrevise_wkfw x where (x.SALES_HEAD_APPROVE_DATE is not null or x.HQ_SALES_HEAD_APPROVE_DATE is not null) and x.temp_id=a.temp_id and x.seq_id=a.seq_id)";
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,"CONFIRMED");
					pstmtDt.setString(2,request.getParameter("rdo_"+chk[i]));
					pstmtDt.setString(3,request.getParameter("pcremark_"+chk[i]));
					pstmtDt.setString(4,"002");
					pstmtDt.setString(5,"AMANDA");
					pstmtDt.setString(6,"005");
					pstmtDt.setString(7,"AGGIE");
					pstmtDt.setString(8,"008");
					pstmtDt.setString(9,"PRDPC");
					pstmtDt.setString(10,"006");
					pstmtDt.setString(11,"ESTHER");
					pstmtDt.setString(12,"010");
					pstmtDt.setString(13,"MAY");
					pstmtDt.setString(14,"011");
					pstmtDt.setString(15,"AGGIE_P");
					pstmtDt.setString(16,"");				
					pstmtDt.setString(17,"002");
					pstmtDt.setString(18,"AMANDA");
					pstmtDt.setString(19,"005");
					pstmtDt.setString(20,"AGGIE");
					pstmtDt.setString(21,"008");
					pstmtDt.setString(22,"PRDPC");
					pstmtDt.setString(23,"006");
					pstmtDt.setString(24,"ESTHER");
					pstmtDt.setString(25,"010");
					pstmtDt.setString(26,"MAY");
					pstmtDt.setString(27,"011");
					pstmtDt.setString(28,"AGGIE_P");	
					pstmtDt.setString(29,"");								
					pstmtDt.setString(30,chk[i]);
					pstmtDt.executeQuery();
					pstmtDt.close();	
				
				}
				else
				{	  			
					sql = " update oraddman.tsc_om_salesorderrevise_req a"+
						  "	set status=?"+
						  " ,PC_CONFIRMED_RESULT=?"+
						  " ,PC_SO_QTY=NVL(SO_QTY,SOURCE_SO_QTY)"+
						  " ,PC_SCHEDULE_SHIP_DATE=NVL(SCHEDULE_SHIP_DATE,SOURCE_SSD)"+
						  " ,PC_REMARKS=?"+
						  " ,PC_CONFIRM_ID=apps.tsc_order_revise_pc_id_s.nextval"+
						  " ,PC_CONFIRMED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
						  " ,PC_CONFIRMED_DATE=SYSDATE"+
						  " ,LAST_UPDATED_BY=CASE PLANT_CODE WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? WHEN ? THEN ? ELSE ? END"+
						  " ,LAST_UPDATE_DATE=SYSDATE"+
						  "	where a.temp_id||'-'||a.so_line_id=?"+
						  " and exists (select 1 from oraddman.tsc_om_salesorderrevise_wkfw x where x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is not null and x.temp_id=a.temp_id and x.seq_id=a.seq_id)";
					pstmtDt=con.prepareStatement(sql);  
					pstmtDt.setString(1,"CONFIRMED");
					pstmtDt.setString(2,request.getParameter("rdo_"+chk[i]));
					pstmtDt.setString(3,"Approved by "+UserName);
					pstmtDt.setString(4,"002");
					pstmtDt.setString(5,"AMANDA");
					pstmtDt.setString(6,"005");
					pstmtDt.setString(7,"AGGIE");
					pstmtDt.setString(8,"008");
					pstmtDt.setString(9,"PRDPC");
					pstmtDt.setString(10,"006");
					pstmtDt.setString(11,"ESTHER");
					pstmtDt.setString(12,"010");
					pstmtDt.setString(13,"MAY");
					pstmtDt.setString(14,"011");
					pstmtDt.setString(15,"AGGIE_P");
					pstmtDt.setString(16,"");				
					pstmtDt.setString(17,"002");
					pstmtDt.setString(18,"AMANDA");
					pstmtDt.setString(19,"005");
					pstmtDt.setString(20,"AGGIE");
					pstmtDt.setString(21,"008");
					pstmtDt.setString(22,"PRDPC");
					pstmtDt.setString(23,"006");
					pstmtDt.setString(24,"ESTHER");
					pstmtDt.setString(25,"010");
					pstmtDt.setString(26,"MAY");
					pstmtDt.setString(27,"011");
					pstmtDt.setString(28,"AGGIE_P");	
					pstmtDt.setString(29,"");								
					pstmtDt.setString(30,chk[i]);
					pstmtDt.executeQuery();
					pstmtDt.close();	
				}	
				con.commit();	
			}
		}
		catch(Exception e)
		{
			con.rollback();
	%>
			<script language="JavaScript" type="text/JavaScript">
				alert("An error occurred, the transaction failed, please contact the system administrator!");
			</script>
	<%				
		}		  
	}
}
%>
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Order  Revise for Approve </div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px">Home</A>&nbsp;&nbsp;&nbsp;&nbsp;<a href="Logout.jsp" style="font-size:12px">logout</a></div>
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
<TABLE width="100%" border='1' bordercolorlight='#426193' bordercolordark='#ffffff' cellPadding='1' cellspacing='0' bgcolor="#DAF0FC">
	<tr>
		<td width="6%" align="right">Sales Group：</td>
		<td width="6%">
		<%
		try
		{   
			sql = "select distinct SALES_GROUP, SALES_GROUP from oraddman.tsc_om_salesorderrevise_req a where a.STATUS='"+ACTIONTYPE+"'";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}			
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
		<td width="5%" align="right">Plant Code：</td>
		<td width="5%">
		<%
		try
		{   
			sql = "select distinct PLANT_CODE, ALENGNAME from oraddman.tsc_om_salesorderrevise_req a,oraddman.tsprod_manufactory b where a.STATUS='"+ACTIONTYPE+"' and a.plant_code=b.MANUFACTORY_NO";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}	
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(PLANTCODE);
			comboBoxBean.setFieldName("PLANTCODE");	
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
		<td width="5%" align="right">Customer：</td>
		<td width="9%" colspan="3">
		<%
		try
		{   
			sql = " select orig_customer,orig_customer "+
			      " from (select distinct case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+ 
		           "      else (SELECT nvl(e.CUSTOMER_SNAME,e.customer_name) from tsc_customer_all_v e where a.SOURCE_CUSTOMER_ID=e.customer_id) ||case when a.source_customer_id=14980 then (select  nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') from hz_cust_accounts end_cust where d.end_customer_id = end_cust.cust_account_id) else '' end end as orig_customer"+
				   "      from oraddman.tsc_om_salesorderrevise_req a,ont.oe_order_lines_all d where a.status='"+ACTIONTYPE+"' and a.so_header_id=d.header_id and a.so_line_id=d.line_id";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}				   
			sql += ") x order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CUST);
			comboBoxBean.setFieldName("CUST");	   
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
		<td width="6%" align="right">Item Desc：</td> 
		<td width="10%">
		<%
		try
		{   
			sql = " select distinct c.description,c.description from oraddman.tsc_om_salesorderrevise_req a,ont.oe_order_lines_all b,inv.mtl_system_items_b c"+
			      " where a.STATUS='"+ACTIONTYPE+"' and a.so_line_id=b.line_id and b.inventory_item_id=c.inventory_item_id and b.ship_from_org_id=c.organization_id ";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(ITEMDESC);
			comboBoxBean.setFieldName("ITEMDESC");	   
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
		<td width="3%" align="right">MO#：</td> 
		<td width="6%">
		<%
		try
		{   
			sql = " select distinct a.SO_NO,a.SO_NO from oraddman.tsc_om_salesorderrevise_req a where a.STATUS='"+ACTIONTYPE+"'";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(MONO);
			comboBoxBean.setFieldName("MONO");	   
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
		<td width="6%"align="right">Cust PO：</td>
		<td width="6%">
		<%
		try
		{   
			sql = " select distinct a.SOURCE_CUSTOMER_PO,a.SOURCE_CUSTOMER_PO from oraddman.tsc_om_salesorderrevise_req a where a.STATUS='"+ACTIONTYPE+"'";
			if (UserRoles.indexOf("admin")<0)
			{
					sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is not null and x.HQ_SALES_HEAD_APPROVE_DATE is null)))";	
			}
			sql += " order by 1";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CUSTPO);
			comboBoxBean.setFieldName("CUSTPO");	   
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
</TABLE>
<P>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSSalesOrderReviseSalesApprove.jsp')"></DIV>
        <HR>
<%
try
{
	sql = " select a.temp_id"+
	      ",a.seq_id"+
		  ",a.sales_group"+
		  ",a.so_no"+
		  ",nvl(a.line_no,'') line_no"+
		  ",a.so_header_id"+
		  ",a.so_line_id"+
		  ",nvl(a.order_type,'') order_type "+
		  ",a.customer_number"+
		  ",a.customer_name"+
		  ",a.ship_to_org_id"+
		  ",a.ship_to"+
		  ",a.inventory_item_id"+
		  ",a.item_name"+
		  ",a.item_desc"+
		  ",a.cust_item_id"+
		  ",a.cust_item_name"+
		  ",a.customer_po"+
		  ",a.shipping_method"+
		  ",NVL(a.so_qty,a.SOURCE_SO_QTY) so_qty"+
		  ",to_char(a.request_date,'yyyymmdd') request_date "+
		  ",to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
		  ",a.packing_instructions"+
		  ",a.plant_code"+
		  ",a.change_reason"+
		  ",a.change_comments"+
		  ",a.created_by"+
		  ",a.creation_date"+
		  ",(SELECT ALENGNAME FROM oraddman.tsprod_manufactory b WHERE a.plant_code =b.manufactory_no) ALENGNAME "+ 
		  ",a.REQUEST_NO"+
		  ",a.remarks"+
		  ",a.SOURCE_SO_QTY orig_so_qty"+
          ",f.description orig_item_desc"+
		  ",to_char(CASE WHEN a.packing_instructions IN ('Y','T') AND (SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') OR (SUBSTR(a.so_no,1,4) IN ('1214') and nvl(a.TO_TW_DAYS,0)<>0)) THEN TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD')"+ 
		  "  ELSE a.source_ssd-nvl(a.TO_TW_DAYS,0) END ,'yyyymmdd') AS  orig_schedule_ship_date"+ 
		  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+ 
		  " else (SELECT nvl(e.CUSTOMER_SNAME,e.customer_name) from tsc_customer_all_v e where a.SOURCE_CUSTOMER_ID=e.customer_id) ||case when a.source_customer_id=14980 then (select  nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') from hz_cust_accounts end_cust where d.end_customer_id = end_cust.cust_account_id) else '' end end as orig_customer"+
		  ",row_number() over (partition by so_header_id,so_line_id order by a.seq_id) line_seq"+
		  ",count(a.SO_LINE_ID) over (partition by SO_HEADER_ID,SO_LINE_ID) line_cnt"+
          ",sum(case when a.so_qty is null then 0 else 1 end ) over (partition by a.plant_code) so_qty_cnt"+
          ",sum(case when a.schedule_ship_date is null then 0 else 1 end ) over (partition by a.plant_code) schedule_ship_date_cnt"+  
          ",sum(case when a.order_type is null then 0 else 1 end ) over (partition by a.plant_code) order_type_cnt"+
          ",sum(case when a.customer_number is null then 0 else 1 end ) over (partition by a.plant_code) customer_number_cnt"+
          ",sum(case when a.ship_to_org_id is null then 0 else 1 end ) over (partition by a.plant_code) ship_to_org_id_cnt"+
          ",sum(case when a.item_name is null then 0 else 1 end ) over (partition by a.plant_code) item_name_cnt"+
          ",sum(case when a.cust_item_id is null then 0 else 1 end ) over (partition by a.plant_code) cust_item_id_cnt"+
          ",sum(case when a.customer_po is null then 0 else 1 end ) over (partition by a.plant_code) customer_po_cnt"+
          ",sum(case when a.shipping_method is null then 0 else 1 end ) over (partition by a.plant_code) shipping_method_cnt"+
          ",case when sum(case when a.so_qty is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.schedule_ship_date is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.order_type is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.customer_number is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.ship_to_org_id is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.item_name is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.cust_item_id is null then 0 else 1 end ) over (partition by a.plant_code) >0 then 1 else 0 end+"+
          " case when sum(case when a.customer_po is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end+"+
          " case when sum(case when a.shipping_method is null then 0 else 1 end ) over (partition by a.plant_code)  >0 then 1 else 0 end as show_column_cnt"+
		  ",tsc_inv_category(d.inventory_item_id,43,23) tsc_package"+  //add by Peggy 20181016
          ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id) - a.source_so_qty  change_qty"+
          ",to_number(to_char(a.source_ssd,'yyyymmdd'))-to_number(to_char(case when a.schedule_ship_date is null then a.source_ssd else case when nvl(a.TO_TW_DAYS,0)<>0 then a.SCHEDULE_SHIP_DATE_TW else a.schedule_ship_date end end,'yyyymmdd')) change_ssd"+
          ",sum (case when a.so_qty is null then a.source_so_qty else a.so_qty end) over (partition by  so_header_id, so_line_id)  change_new_qty"+
		  ",nvl(a.TO_TW_DAYS,0) TO_TW_DAYS"+
		  ",a.TSC_PROD_GROUP"+
		  ",to_char(a.source_request_date,'yyyymmdd') source_crd "+ 
		  ",supplier_number"+   
		  ",a.cancel_move_flag"+ 
		  ",a.SOURCE_CUSTOMER_PO"+
		  ",a.SOURCE_CUST_ITEM_NAME"+
		  ",g.region_sales_head_person"+
          ",to_char(g.sales_head_approve_date,'yyyy-mm-dd hh24:mi') sales_head_approve_date"+
		  ",g.sales_head_approve_result"+
		  ",g.sales_head_approve_memo"+
		  ",NVL(a.so_qty,a.SOURCE_SO_QTY) * nvl(a.selling_price,a.source_selling_price) so_amt"+
		  ",ROUND(NVL(a.so_qty,a.SOURCE_SO_QTY) * nvl(a.selling_price,a.source_selling_price)* nvl((SELECT CONVERSION_RATE FROM GL_DAILY_RATES_V WHERE USER_CONVERSION_TYPE='TSC-Export' AND TO_CURRENCY='TWD' AND CONVERSION_DATE =TRUNC(SYSDATE) AND FROM_CURRENCY=e.transactional_curr_code),1),0) TWD_AMT"+
		  ",e.transactional_curr_code curr_code"+
		  " from oraddman.tsc_om_salesorderrevise_req a"+
		  ",ont.oe_order_lines_all d"+	
		  ",ont.oe_order_headers_all e"+	
		  ",inv.mtl_system_items_b f "+
		  ",oraddman.tsc_om_salesorderrevise_wkfw g"+
		  " where a.status='"+ACTIONTYPE+"'"+
		  " and a.so_header_id=d.header_id"+
		  " and a.so_line_id=d.line_id"+
		  " and d.header_id=e.header_id"+
		  " and a.SOURCE_ITEM_ID=f.inventory_item_id"+
		  " and a.temp_id=g.temp_id"+
		  " and a.seq_id=g.seq_id"+
		  " and a.SOURCE_SHIP_FROM_ORG_ID=f.organization_id";
	if (UserRoles.indexOf("admin")<0)
	{
			sql +=" and exists (select 1 from oraddman.TSC_OM_SALESORDERREVISE_WKFW	x where x.temp_id=a.temp_id and x.seq_id=a.seq_id and ((x.REGION_SALES_HEAD_PERSON='"+UserName+"' and x.SALES_HEAD_APPROVE_DATE is null and x.HQ_SALES_HEAD_APPROVE_DATE is null) or (x.HQ_SALES_HEAD_PERSON='"+UserName+"' and x.HQ_SALES_HEAD_APPROVE_DATE is null and x.SALES_HEAD_APPROVE_DATE is not null)))";	
	}  
	if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
	{
		sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
	}
	if (!salesGroup.equals("") && !salesGroup.equals("--"))
	{
		sql += " and a.SALES_GROUP='"+salesGroup+"'";
	}
	if (!ITEMDESC.equals(""))
	{
		sql += " and f.description ='"+ITEMDESC+"'";
	}	
	if (!MONO.equals(""))
	{
		sql += " and a.SO_NO ='"+MONO+"'";
	}
	if (!CUSTPO.equals(""))
	{
		sql += " and a.SOURCE_CUSTOMER_PO ='"+CUSTPO+"'";
	}	
	sql += " order by a.SALES_GROUP,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (!CUST.equals("") && !rs.getString("orig_customer").equals(CUST)) continue;
	
		if (rowcnt==0)
		{
		%>
<DIV style="font-family:arial;font-size:12px">Qty Uom:PCE</DIV>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="font-size:10px;background-color:#51874E;color:#FFFFFF;">
		<td rowspan="2" width="2%" align="center">Seq No</td>
		<td rowspan="2" width="5%" align="center">Request No</td>
		<td rowspan="2" width="3%" align="center">Plant Code </td>
		<td colspan="12" align="center">Order Original Detail </td>
			<%
			if (rs.getString("sales_head_approve_date")!=null)
			{
			%>
			<td width="12%" style="background-color:#D1E0D3;color:#000000" colspan="3" align="center">Revise Detail </td>
			<td width="10%" style="background-color:#66CCFF;color:#000000" colspan="3" align="center">Region Sales Confirm Result </td>
			<td width="12%" style="background-color:#66CCCC;color:#000000" colspan="2" align="center">Confirm Result </td>
			<%
			}
			else
			{
			%>
			<td width="16%" style="background-color:#D1E0D3;color:#000000" colspan="3" align="center">Revise Detail </td>
			<td width="18%" style="background-color:#66CCCC;color:#000000" colspan="2" align="center">Confirm Result </td>
			<%
			}
			%>		
	</tr>
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">Sales Area </td>
		<td width="9%" style="background-color:#51874E;color:#FFFFFF;" align="center">Customer</td>
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">MO#</td>
		<td width="2%" style="background-color:#51874E;color:#FFFFFF;" align="center">Line#</td>	
		<td width="5%" style="background-color:#51874E;color:#FFFFFF;" align="center">Cust PO</td>
		<td width="8%" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Item Desc </td>	
		<!--<td width="8%" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Cust Item </td>-->			
		<td width="4%" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Package </td>	
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Qty </td>	
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">Original CRD </td>		
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">Original SSD </td>
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">Amount</td>
		<td width="3%" style="background-color:#51874E;color:#FFFFFF;" align="center">Currency</td>						
			<%
			if (rs.getString("sales_head_approve_date")!=null)
			{
			%>	
			<td width="3%" align="center">Sales Qty</td>	
			<td width="4%" align="center">Sales SSD pull in/out</td>
			<td width="5%">Remarks</td>	
			<td width="3%" align="center" style="background-color:#66CCFF;color:#000000">Sales</td>	
			<td width="3%" align="center" style="background-color:#66CCFF;color:#000000">Confirm Date</td>
			<td width="4%" align="center" style="background-color:#66CCFF;color:#000000">Result</td>					
			<td width="2%" align="center" style="background-color:#66CCCC;color:#000000">&nbsp;</td>
			<td width="10%" align="center" style="background-color:#66CCCC;color:#000000">Reuslt</td>		
			<%
			}
			else
			{
			%>			
			<td width="4%" align="center">Sales Qty</td>	
			<td width="5%" align="center">Sales SSD pull in/out</td>
			<td width="7%">Remarks</td>			
			<td width="2%" align="center" style="background-color:#66CCCC;color:#000000">&nbsp;</td>
			<td width="15%" align="center" style="background-color:#66CCCC;color:#000000">Reuslt</td>
			<%
			}
		%>			

	</tr>
		<%
		}
		
		rowcnt++;
		id =rs.getString("temp_id")+"-"+rs.getString("so_line_id");
		so_qty=rs.getString("so_qty");
		so_ssd=rs.getString("schedule_ship_date");
		if (so_ssd==null) so_ssd=rs.getString("orig_schedule_ship_date");
		%>
	<tr style="font-size:9px">
		<td><%=rowcnt%></td>
		<% 
		if (rs.getInt("line_seq")==1)
		{
		%>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("request_no")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("ALENGNAME")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("sales_group")%></td>
		<td align="left" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_customer")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("so_no")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("line_no")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=100;this.T_OPACITY=80;return escape("<%=rs.getString("created_by")%>")'><%=rs.getString("orig_item_desc")%></td>
		<!--<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUST_ITEM_NAME")%></td>-->	
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("tsc_package")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><input type="text" name="orig_qty_<%=rs.getString("so_line_id")%>" value="<%=rs.getString("orig_so_qty")%>" style="border-bottom:none;border-left:none;border-right:none;border-top:none;font-family: Tahoma,Georgia; font-size:10px;text-align:right" size="5" readonly></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_CRD")==null?"&nbsp;":rs.getString("SOURCE_CRD"))%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%><input type="hidden" name="SALES_HEAD_APPROVE_DATE_<%=id%>" value="<%=(rs.getString("SALES_HEAD_APPROVE_DATE")==null?"":rs.getString("SALES_HEAD_APPROVE_DATE"))%>"></td>
		<% 
			if (rs.getString("sales_head_approve_date")==null)
			{
			%>				
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>" style="color:#0033FF"><%=(rs.getString("so_amt")==null?"&nbsp;":rs.getString("so_amt"))%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>" style="color:#0033FF"><%=(rs.getString("curr_code")==null?"&nbsp;":rs.getString("curr_code"))%></td>
			<%
			}
			else
			{
			%>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>" style="color:#0033FF"><%=(rs.getString("twd_amt")==null?"&nbsp;":rs.getString("twd_amt"))%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>" style="color:#0033FF">TWD</td>
			<%
			}
		}
		%>		
		<td><input type="text" name="qty_<%=id%>" value="<%=(so_qty==null?"":so_qty)%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:9px;text-align:right;<%=(rs.getInt("change_qty")==0?"color:#000000;":(rs.getInt("change_qty")>0?"color:#0000ff;":"color:#ff0000;"))%>" size="4" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" title="<%=(rs.getInt("change_qty")==0?"":(rs.getInt("change_qty")>0?"increase then quantity":"reduced the quantity "))%>" readonly><input type="hidden" name="sales_qty_<%=id%>" value="<%=(rs.getString("so_qty")==null?"":rs.getString("so_qty"))%>"><input type="hidden" name="source_qty_<%=id%>" value="<%=(rs.getString("orig_so_qty")==null?"":rs.getString("orig_so_qty"))%>"><input type="hidden" name="so_<%=id%>" value="<%=rs.getString("so_no")%>">
		</td>
		<td><input type="text" name="ssd_<%=id%>" value="<%=(so_ssd==null?"":so_ssd)%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:9px;text-align:right;<%=(rs.getInt("change_ssd")==0?"color:#000000;":(rs.getInt("change_ssd")>0?"color:#0000ff;":"color:#ff0000;"))%>" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" title="<%=(rs.getInt("change_ssd")==0?"":(rs.getInt("change_ssd")>0?"Pull in":"Push out"))%>" readonly><input type="hidden" name="sales_ssd_<%=id%>" value="<%=(rs.getString("schedule_ship_date")==null?"":rs.getString("schedule_ship_date"))%>"></td>
		<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>	
		<% 
		if (rs.getString("sales_head_approve_date")!=null)
		{
		%>	
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("REGION_SALES_HEAD_PERSON")%></td>		
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SALES_HEAD_APPROVE_DATE")%></td>	
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("sales_head_approve_result").equals("A")?"<font color='#0000ff'>Approved</font>":"Reject")+"<br>"+(rs.getString("SALES_HEAD_APPROVE_MEMO")==null?"&nbsp;":rs.getString("SALES_HEAD_APPROVE_MEMO"))%></td>							
		<%
		}
		if (rs.getInt("line_seq")==1)
		{
		%>			
			<td rowspan="<%=rs.getString("line_cnt")%>" id="tda_<%=id%>" align="center" <%=(pc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(pc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>><input type="checkbox" name="chk" value="<%=id%>" onClick="setChkboxPress('<%=rowcnt%>','<%=id%>')"></td>
			<td rowspan="<%=rs.getString("line_cnt")%>" id="tdb_<%=id%>" <%=(pc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(pc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>><input type="radio" name="rdo_<%=id%>" value="A" onClick="setRadioPress('<%=rowcnt%>','A','<%=id%>')" <%=(pc_result.equals("A")?" checked":"")%>>
			Accept &nbsp;
		    	<input type="radio" name="rdo_<%=id%>" value="R" onClick="setRadioPress('<%=rowcnt%>','R','<%=id%>')" <%=(pc_result.equals("R")?" checked":"")%>  style="visibility:visible"> 
		     Reject &nbsp;
		    	<input type="text" name="pcremark_<%=id%>" value="<%=pc_remarks%>" style="background-color:#FFFF99;border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:11px;<%=(pc_result.equals("A")?"background-color:#C4F8A5;":(pc_result.equals("R")?"background-color:#FEA398;":""))%>" size="18">
		<%
		}
		%>		
		</td>
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
<table border="0" width="100%" bgcolor="#DAF0FC">
	<tr>
		<td width="85%"></td>
		<td align="center"><input type="button" name="submit1" value="Submit" style="color:#0033FF;font-weight:bold;font-size:14px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSSalesOrderReviseSalesApprove.jsp?ACODE=S")'>
		</td>
	</tr>
</table>
<hr>
	<%
	}
	else
	{
		out.println("<div style='color:#0000ff;font-size:16px' align='center'>No Data Found!!</div>");
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='font-size:12px;color:#ff0000'>Exception:"+e.getMessage()+"</div>");
}
%>
<input name="SYSDATE" type="hidden" value="<%=dateBean.getYearMonthDay()%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

