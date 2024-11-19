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
<html>
<head>
<title>PC Order Revise for Query</title>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
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
function setRemarkAll(objValue)
{
	var chk_len =0,chkcnt=0;
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
			id = document.MYFORM.chk.value;		
		}
		else
		{
			id = document.MYFORM.chk[i].value;		
		}
		if (document.MYFORM.elements["rdo_"+id][1].checked)
		{	
			document.MYFORM.elements["salesremark_"+id].value=document.MYFORM.salesremarkall.value;
		}	
	}	
}

function setRadioAll(objValue)
{
	var chk_len =0,chkcnt=0;
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
			id = document.MYFORM.chk.value;		
		}
		else
		{
			id = document.MYFORM.chk[i].value;		
		}
		if (objValue=="A")
		{
			if (document.MYFORM.elements["rdo_"+id][0].checked)
			{
				document.MYFORM.elements["rdo_"+id][0].checked=false;
				document.MYFORM.elements["salesremark_"+id].value="";
				document.MYFORM.elements["rdoall"][0].checked=false;				
				if (chk_len==1)
				{
					document.MYFORM.chk.checked=false;;		
				}
				else
				{
					document.MYFORM.chk[i].checked=false;		
				}				
				setChkboxPress(i+1,id);				
			}
			else
			{
				document.MYFORM.elements["rdo_"+id][0].checked=true;
				document.MYFORM.elements["salesremark_"+id].value="";
				setRadioPress(i+1,objValue,id);	
			}
		}
		else
		{
			if (document.MYFORM.elements["rdo_"+id][1].checked)
			{
				document.MYFORM.elements["rdo_"+id][1].checked=false;
				document.MYFORM.elements["salesremark_"+id].value="";
				document.MYFORM.elements["rdoall"][1].checked=false;
				document.MYFORM.salesremarkall.value="";	
				if (chk_len==1)
				{
					document.MYFORM.chk.checked=false;;		
				}
				else
				{
					document.MYFORM.chk[i].checked=false;		
				}				
				setChkboxPress(i+1,id);			
			}
			else
			{
				document.MYFORM.elements["rdo_"+id][1].checked=true;
				document.MYFORM.elements["salesremark_"+id].value=document.MYFORM.salesremarkall.value;
				setRadioPress(i+1,objValue,id);	
			}
		}
		
	}	
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	var id="",radflag="",r_year="",r_month="",r_day="",i_res="",so_line_id="";
	var i_year = "",i_month= "",i_day ="";
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
					if (j==1 && document.MYFORM.elements["REQTYPE_"+id].value=="Early Ship" && (document.MYFORM.elements["salesremark_"+id].value==null || document.MYFORM.elements["salesremark_"+id].value=="")) 
					{
						alert("Line"+(i+1)+": Please enter your reason for reject!!");
						document.MYFORM.elements["salesremark_"+id].focus();
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
			if (i_res=="A" && document.MYFORM.elements["sales_ssd_"+id].value!="")
			{
				if (document.MYFORM.elements["REQTYPE_"+id].value=="Early Ship")
				{
					//if (document.MYFORM.elements["source_ssd_"+id].value.substring(0,4)=="2099")
					//{
						if (eval(document.MYFORM.elements["sales_ssd_"+id].value) > eval(document.MYFORM.elements["ssd_"+id].value))
						{
							alert("Line"+(i+1)+":The new SSD must be later than the PC SSD!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;						
						}
						else if (eval(document.MYFORM.elements["ssd_"+id].value) > eval(document.MYFORM.elements["source_ssd_"+id].value))
						{
							alert("Line"+(i+1)+":The new SSD must be earlier than the source SSD!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;						
						}
						else if (eval(document.MYFORM.elements["max_new_ssd_"+id].value) < eval(document.MYFORM.elements["ssd_"+id].value)) //modify by Peggy 20221124
						{
							alert("Line"+(i+1)+":The SSD can not later than "+document.MYFORM.elements["max_new_ssd_"+id].value+" !!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;			
						}	
											
					//}
					//else
					//{
						//if (document.MYFORM.elements["sales_ssd_"+id].value !=document.MYFORM.elements["ssd_"+id].value)
						//{
						//	alert("Line"+(i+1)+":The SSD can not modify!!");
						//	document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						//	return false;			
						//}						
					//}	
				}
				else
				{
					if (eval(document.MYFORM.elements["sales_ssd_"+id].value) > eval(document.MYFORM.elements["ssd_"+id].value))
					{
						alert("Line"+(i+1)+":The new SSD cannot be smaller than the PC SSD!!");
						document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						return false;						
					}
				}
				if (document.MYFORM.elements["ssd_"+id].value.length!=8)
				{
					if (eval(document.MYFORM.elements["qty_"+id].value)>0)
					{
						alert("Line"+(i+1)+":Date format error(invalid format:YYYYMMDD)!!");
						document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						return false;		
					}	
				}
				else
				{
					i_year = document.MYFORM.elements["ssd_"+id].value.substr(0,4);
					i_month= document.MYFORM.elements["ssd_"+id].value.substr(4,2);
					i_day  = document.MYFORM.elements["ssd_"+id].value.substr(6,2);
					if (i_month <1 || i_month >12)
					{
						alert("Line"+(i+1)+":Month format error(invalid format:YYYYMMDD)!!");
						document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						return false;			
					}	
					else if ((i_month ==1 || i_month==3 || i_month == 5 || i_month ==7 || i_month==8 || i_month==10 || i_month ==12)	 && i_day > 31)
					{
						alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
						document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						return false;			
					} 
					else if ((i_month == 4 || i_month==6 || i_month == 9 || i_month ==11)	 && i_day > 30)
					{
						alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
						document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
						return false;			
					} 
					else if (i_month == 2)
					{
						if ((isLeapYear(i_year) && i_day > 29) || (!isLeapYear(i_year) && i_day > 28))
						{
							alert("Line"+(i+1)+":Days format error(invalid format:YYYYMMDD)!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;	
						}		
					}
					//if (eval(document.MYFORM.elements["qty_"+id].value)>0 && eval(document.MYFORM.elements["ssd_"+id].value) < eval(document.MYFORM.SYSDATE.value) && eval(document.MYFORM.elements["ssd_"+id].value)!=eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) 
					//{
					//	alert("Line"+(i+1)+":The schedule ship date must greater than today!!");
					//	document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
					//	return false;	
					//}
				}
			}
			//add by Peggy 20220107
			if (i_res=="A" && document.MYFORM.elements["remark_"+id].value.toUpperCase().indexOf("SEA")>=0)
			{
				if (document.MYFORM.elements["shipmethod_"+id].value.toUpperCase().indexOf("SEA")<0)
				{
					alert("Line"+(i+1)+":Please change shipping method to SEA!!");
					document.MYFORM.elements["shipmethod_"+id].style.backgroundColor="#FFCCCC";  
					return false;					
				}
			}	
					
			so_line_id = document.MYFORM.elements["so_line_id_"+id].value;
			if (chk_len !=1)
			{
				for (var j=0 ; j < chk_len ;j++)
				{
					if ( j!=i && document.MYFORM.elements["so_line_id_"+document.MYFORM.chk[j].value].value==so_line_id)
					{
						if (document.MYFORM.chk[j].checked==false)
						{
							alert("Line"+(j+1)+": Please choose a answer!");
							return false;							
						}
						else
						{
							for(var k = 0; k < document.MYFORM.elements["rdo_"+document.MYFORM.chk[j].value].length; k++) 
							{
								if (document.MYFORM.elements["rdo_"+document.MYFORM.chk[j].value][k].checked)
								{
									if (k==0)
									{ 
										if (i_res!="A")
										{
											alert("Line"+(j+1)+":An order result must be the same!!");
											return false;
										}
									}
									else 
									{
										if (i_res!="R")
										{
											alert("Line"+(j+1)+":An order result must be the same!!");
											return false;
										}
									}
								}
							}
						}
					}
				}
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
	document.MYFORM.btnExport.disabled=true;	
	document.MYFORM.btnImport.disabled=true;
	document.MYFORM.action=URL;	
	document.MYFORM.submit();
}

function setRadioPress(Lineno,objValue,id)
{
	if (objValue=="A")
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#C4F8A5";
		document.getElementById("tdb_"+id).style.backgroundColor ="#C4F8A5";
		document.MYFORM.elements["salesremark_"+id].style.backgroundColor ="#C4F8A5";
		document.MYFORM.elements["btnship_"+id].disabled=false;
		if (document.MYFORM.elements["REQTYPE_"+id].value !="Early Ship")
		{
			document.MYFORM.elements["chkhold_"+id].disabled=false;
			document.MYFORM.elements["chkhold_"+id].checked=false;
		}
		else
		{
			//add by Peggy 20221121
			if (eval(document.MYFORM.elements["totw_"+id].value)>0)
			{
				document.getElementById("div_"+id).style.visibility ="visible";
			}
			else
			{
				document.getElementById("div_"+id).style.visibility ="hidden";
			}
			document.MYFORM.elements["chkhold_"+id].disabled=true;
			document.MYFORM.elements["chkhold_"+id].checked=false;
		}
		//mark by Peggy 20221124
		//if (document.MYFORM.elements["REQTYPE_"+id].value !="Early Ship" || document.MYFORM.elements["source_ssd_"+id].value.substr(0,4)!="2099")
		//{		
			//document.MYFORM.elements["ssd_"+id].readOnly=true;
			//document.MYFORM.elements["ssd_"+id].value=document.MYFORM.elements["sales_ssd_"+id].value;
		//}
	}
	else
	{
		document.getElementById("tda_"+id).style.backgroundColor ="#CCCCCC";
		document.getElementById("tdb_"+id).style.backgroundColor ="#CCCCCC";
		document.MYFORM.elements["salesremark_"+id].style.backgroundColor ="#CCCCCC";
		document.MYFORM.elements["chkhold_"+id].disabled=true;
		document.MYFORM.elements["chkhold_"+id].checked=false;
		document.MYFORM.elements["btnship_"+id].disabled=true;
		document.getElementById("div_"+id).style.visibility ="hidden";     //add by Peggy 20221121
		document.MYFORM.elements["tsc_odr_nochange_"+id].checked=false;   //add by Peggy 20221121
		
		if (document.MYFORM.elements["REQTYPE_"+id].value=="Overdue" || document.MYFORM.elements["REQTYPE_"+id].value=="Early Warning")
		{
			document.MYFORM.elements["ssd_"+id].readOnly=false;
		}
		else
		{
			document.MYFORM.elements["ssd_"+id].readOnly=true;
			document.MYFORM.elements["ssd_"+id].value=document.MYFORM.elements["sales_ssd_"+id].value;
		}
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
		document.MYFORM.elements["salesremark_"+id].value="";
		document.getElementById("tda_"+id).style.backgroundColor ="#FFFFFF";
		document.getElementById("tdb_"+id).style.backgroundColor ="#FFFFFF";	
		document.MYFORM.elements["salesremark_"+id].style.backgroundColor ="#FFFFFF";
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

function subWindowShipMethodFind(primaryFlag,vidx)
{	    
	subWin=window.open("../jsp/subwindow/TSDRQShippingMethodFind.jsp?sType=D15002_"+vidx,"subwin","width=640,height=480,scrollbars=yes,menubar=no");  
} 

function setGroup()
{
	document.MYFORM.submit();
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
String sql = "",show_flag="",id="",swhere="";
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null) salesGroup="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String ACTIONTYPE="AWAITING_CONFIRM";
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="Q";
String CUSTOMER=request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER="";
String REQUEST_DATE = request.getParameter("REQUEST_DATE"); 
if (REQUEST_DATE==null || REQUEST_DATE.equals("--")) REQUEST_DATE="";
String so_qty="",so_ssd="";
String REQ_TYPE =request.getParameter("REQ_TYPE");
if (REQ_TYPE==null) REQ_TYPE="";
String ITEM_DESC=request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String CUST_ITEM=request.getParameter("CUST_ITEM");
if (CUST_ITEM==null) CUST_ITEM="";
String REQ_TYPE_P =request.getParameter("REQ_TYPE_P");
if (REQ_TYPE_P==null) REQ_TYPE_P="";
String REQ_TYPE_O =request.getParameter("REQ_TYPE_O");
if (REQ_TYPE_O==null) REQ_TYPE_O="";
String REQ_TYPE_E =request.getParameter("REQ_TYPE_E");
if (REQ_TYPE_E==null) REQ_TYPE_E="";
String MO_LIST=request.getParameter("MO_LIST");
if (MO_LIST==null) MO_LIST="";
String CUST_LIST=request.getParameter("CUST_LIST");
if (CUST_LIST==null) CUST_LIST="";
String BID =request.getParameter("BID");
if (BID==null) BID="";
String strarray[]=new String [7];
int rowcnt=0;

//if (salesGroup.indexOf("TSCH")>=0)
//{
//	PreparedStatement statement1 = con.prepareStatement("select listagg(nvl(b.CUSTOMER_SNAME,b.CUSTOMER_NAME),'\n') within group (order by nvl(b.CUSTOMER_SNAME,b.CUSTOMER_NAME))  customer_name from tsc_om_order_privilege a,tsc_customer_all_v b where a.RFQ_USERNAME=? and a.customer_id=b.customer_id and sysdate between trunc(a.START_DATE_ACTIVE) and nvl(a.END_DATE_ACTIVE,to_date('20990101','yyyymmdd')) ");
//	statement1.setString(1,UserName);
//	ResultSet rs1=statement1.executeQuery();
//	if (rs1.next())
//	{
//		CUST_LIST=rs1.getString(1);
//	}
//	rs1.close();
//	statement1.close();
//}

%>
<body> 
<FORM ACTION="../jsp/TSPCOrderReviseConfirm.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Confirm Order Revise</div>
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
<TABLE width="100%" border="1" bgcolor="#CFDAC9" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr>
		<td width="6%" align="right">Sales Group：</td>
		<td width="8%">
		<%
		try
		{   
			sql = "select distinct SALES_GROUP, SALES_GROUP from oraddman.tsc_om_salesorderrevise_pc a where a.STATUS='"+ACTIONTYPE+"'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";	
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(salesGroup);
			comboBoxBean.setFieldName("SALESGROUP");	
			comboBoxBean.setOnChangeJS("setGroup()");     
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
		<td width="7%" align="right">Plant Code：</td>
		<td width="8%">
		<%
		try
		{   
			sql = "select distinct PLANT_CODE, ALENGNAME from oraddman.tsc_om_salesorderrevise_pc a,oraddman.tsprod_manufactory b where a.plant_code=b.MANUFACTORY_NO";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";
			//out.println(sql);
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
		<td width="6%" style="font-size:11px" align="right" rowspan="3">Request Type：</td>
		<td width="8%" rowspan="3">
		<!--<select NAME="REQ_TYPE" style="font-family: Tahoma,Georgia;font-size:11px" onChange="setReqType(this.value)">
		<OPTION VALUE="--" <%=(REQ_TYPE.equals("") || REQ_TYPE.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="Early Ship" <%=(REQ_TYPE.equals("Early Ship")?" selected ":"")%>>Early Ship
        <OPTION VALUE="Overdue" <%=(REQ_TYPE.equals("Overdue")?" selected ":"")%>>Overdue
        <OPTION VALUE="Early Warning" <%=(REQ_TYPE.equals("Early Warning")?" selected ":"")%>>Early Warning
		</select>-->
		<input type="checkbox" name="REQ_TYPE_P" value="Early Ship" <%=!REQ_TYPE_P.equals("")?"checked":""%>>Early Ship <BR>
		<input type="checkbox" name="REQ_TYPE_O" value="Overdue" <%=!REQ_TYPE_O.equals("")?"checked":""%>>Overdue<BR>
		<input type="checkbox" name="REQ_TYPE_E" value="Early Warning" <%=!REQ_TYPE_E.equals("")?"checked":""%>>Early Warning		
		</td>	
		<td width="5%"align="right" rowspan="3">Item Desc：</td>
		<td width="12%" rowspan="3"><textarea cols="25" rows="4" name="ITEM_DESC"  style="font-family: Tahoma,Georgia;font-size:11px"><%=ITEM_DESC%></textarea></td>	
		<td width="5%"align="right" rowspan="3">ERP MO#：</td>
		<td width="12%" rowspan="3"><textarea cols="25" rows="4" name="MO_LIST"  style="font-family: Tahoma,Georgia;font-size:11px"><%=MO_LIST%></textarea>
		</td>
		</tr>
		<tr>
		<td width="7%"align="right">Customer：</td>
		<td width="7%">
		<%
		try
		{   
			/*sql = " select distinct SOURCE_ITEM_DESC ,SOURCE_ITEM_DESC from oraddman.tsc_om_salesorderrevise_pc a"+
			      " where a.STATUS='"+ACTIONTYPE+"'";
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";
			*/
			sql = " select  DISTINCT  '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
                  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer "+
                  ",'('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
                  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer1"+				  
                  " from oraddman.tsc_om_salesorderrevise_pc a"+
                  ",ont.oe_order_lines_all d"+
                  ",tsc_customer_all_v ar"+
                  ",hz_cust_accounts end_cust"+
                  " where d.org_id in (41,325,906)"+
                  " and a.so_line_id = d.line_id(+)"+
                  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
                  " and d.end_customer_id = end_cust.cust_account_id(+)"+
                  " AND NVL(a.ASCRIPTION_BY,'XX') NOT IN ('Sales') "+
                  " AND a.status='"+ACTIONTYPE+"'";
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
				if (salesGroup.equals("TSCH-HK"))
				{
					sql += " and (d.sold_to_org_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))) "+
                           " or end_cust.cust_account_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))))";
				}				
			}				  
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";				  
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CUST_LIST);
			comboBoxBean.setFieldName("CUST_LIST");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception1:"+e.getMessage()); 
		} 	
		%>
		</td>
		<td width="7%"align="right">Request Date：</td>
		<td width="7%">
		<%
		try
		{   
			sql = " select distinct to_char(a.creation_date,'yyyymmdd') creation_date ,to_char(a.creation_date,'yyyymmdd') from oraddman.tsc_om_salesorderrevise_pc a"+
			      " where a.STATUS='"+ACTIONTYPE+"'";
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
			}				  
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(REQUEST_DATE);
			comboBoxBean.setFieldName("REQUEST_DATE");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception2:"+e.getMessage()); 
		} 	
		%>
		</td>	
		</tr>
		<tr>
		<td width="7%"align="right">Cust Item：</td>
		<td width="7%">
		<%
		try
		{
			sql = " select distinct SOURCE_CUST_ITEM_NAME ,SOURCE_CUST_ITEM_NAME from oraddman.tsc_om_salesorderrevise_pc a"+
			      " where a.STATUS='"+ACTIONTYPE+"'";
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
			}				  
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(CUST_ITEM);
			comboBoxBean.setFieldName("CUST_ITEM");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 	
		%>
		</td>	
		<td width="7%"align="right">Request No：</td>
		<td width="7%">
		<%
		try
		{   
			sql = " select distinct REQUEST_NO ,REQUEST_NO from oraddman.tsc_om_salesorderrevise_pc a"+
			      " where a.STATUS='"+ACTIONTYPE+"'";
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				sql += " and a.SALES_GROUP='"+salesGroup+"'";
			}				  
			if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0) || (UserRoles.indexOf("Sale")>=0 && UserRoles.indexOf("Sales_M")<0))
			{
				sql += " and a.sales_group in (SELECT distinct d.group_name "+
 			           " FROM oraddman.tsrecperson a, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
                       " where a.TSSALEAREANO=b.SALES_AREA_NO "+
				       " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
                       " and c.master_group_id=d.master_group_id"+
                       " and d.group_name=e.SALES_GROUP"+
				       " and b.SALES_AREA_NO!='020'"+
				       " and a.USERNAME ='"+UserName+"'"+
				       " union all"+
			           " select distinct ALNAME from oraddman.tsrecperson a, oraddman.tssales_area b where a.TSSALEAREANO=b.SALES_AREA_NO and  b.SALES_AREA_NO='020'"+
                        " and a.USERNAME ='"+UserName+"')";
			}
			sql += " order by 1";
			//out.println(sql);
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			comboBoxBean.setSelection(REQUESTNO);
			comboBoxBean.setFieldName("REQUESTNO");	   
			comboBoxBean.setOnChangeJS("");     
			out.println(comboBoxBean.getRsString());				   
			rs2.close();   
			st2.close();    	 
		} 
		catch (Exception e) 
		{ 
			out.println("Exception4:"+e.getMessage()); 
		} 	
		%>
		</td>
	</tr>
</TABLE>
<br>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSPCOrderReviseConfirm.jsp?ATYPE=Q')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSPCOrderReviseConfirmExcel.jsp?STATUS=<%=ACTIONTYPE%>&UserName=<%=UserName%>&UserRoles=<%=UserRoles%>&userProdCenterNo=<%=userProdCenterNo%>')">&nbsp;&nbsp; 
    	<input type="button" name="btnImport" value="Import From Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload('../jsp/TSPCOrderReviseConfirmUpload.jsp?FACT=<%=PLANTCODE%>')">
		</DIV>
        <HR>
<%
try
{
	if (!ATYPE.equals(""))
	{
		swhere="";
		sql = " select a.request_no"+
			  ", a.request_type"+
			  ", '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			  " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end as customer"+
			  ", a.seq_id"+
			  ", a.sales_group"+
			  ", a.so_no"+
			  ", a.line_no"+
			  ", a.so_header_id"+
			  ", a.so_line_id"+
			  ", a.source_customer_id"+
			  ", a.source_ship_from_org_id"+
			  ", a.source_item_id"+
			  ", a.source_item_desc"+
			  ", a.source_cust_item_id"+
			  ", a.source_cust_item_name"+
			  ", a.source_customer_po"+
			  ", a.source_shipping_method"+
			  ", a.source_so_qty"+
			  ", to_char(a.source_ssd,'yyyymmdd') source_ssd"+
			  ", to_char(a.source_request_date,'yyyymmdd') source_request_date"+
			  ", a.tsc_prod_group"+
			  ", a.packing_instructions"+
			  ", a.plant_code"+
			  ", a.inventory_item_id"+
			  ", a.item_name"+
			  ", a.item_desc"+
			  ", a.shipping_method"+
			  ", a.so_qty"+
			  ", to_char(a.schedule_ship_date,'yyyymmdd') schedule_ship_date"+
			  ", to_char(a.schedule_ship_date_tw,'yyyymmdd') schedule_ship_date_tw"+
			  ", a.reason_desc"+
			  ", a.remarks"+
			  ", a.change_reason"+
			  ", a.change_comments"+
			  ", a.status"+
			  ", a.created_by"+
			  ", to_char(a.creation_date,'yyyymmdd hh24:mi') creation_date"+
			  ", a.sales_confirmed_by"+
			  ", to_char(a.sales_confirmed_date,'yyyymmdd hh24:mi') sales_confirmed_date"+
			  ", a.last_updated_by"+
			  ", to_char(a.last_update_date,'yyyymmdd hh24:mi') last_update_date"+
			  ", a.hold_code"+
			  ", a.hold_reason"+
			  ", a.new_so_no"+
			  ", a.new_line_no"+
			  ", b.MANUFACTORY_NAME"+
			  ",nvl(a.to_tw_days,0) to_tw_days"+ 
			  ",to_char(d.schedule_ship_date,'yyyymmdd') erp_ssd"+ 
			  ",tsc_inv_category(a.SOURCE_ITEM_ID,43,23) tsc_package"+ 
			  ",decode(a.NEW_SO_NO ,null,'',a.NEW_SO_NO) || decode( a.NEW_LINE_NO,null,'', '/'||a.NEW_LINE_NO) as new_order"+
			  ",row_number() over (partition by a.request_type,a.request_no,a.so_line_id order by a.seq_id, nvl(a.SCHEDULE_SHIP_DATE,a.SOURCE_SSD)) line_seq"+
			  ",count(1) over (partition by a.request_type,a.request_no,a.so_line_id) line_cnt"+
			  ",to_char(a.source_ssd_tw,'yyyymmdd') source_ssd_tw"+
			  ",to_number(to_char(a.source_ssd_tw,'yyyymmdd'))-to_number(to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd')) change_ssd"+
			  ",a.SALES_CONFIRMED_QTY"+
			  ",to_char(a.SALES_CONFIRMED_SSD,'yyyymmdd') SALES_CONFIRMED_SSD"+
			  ",a.SALES_CONFIRMED_REMARKS"+
			  ",a.SALES_CONFIRMED_RESULT"+
			  ",case when to_number(to_char(a.source_ssd_tw,'yyyymmdd'))-to_number(to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd'))=0 then to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd') else "+
			  //"  case when nvl(a.schedule_ship_date_tw,a.source_ssd_tw)+28>a.source_ssd_tw then to_char(a.source_ssd_tw,'yyyymmdd') else to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw)+28,'yyyymmdd') end end as max_new_ssd"+
			  "  case when nvl(a.schedule_ship_date_tw,a.source_ssd_tw)<a.source_ssd_tw then to_char(a.source_ssd_tw,'yyyymmdd') else to_char(nvl(a.schedule_ship_date_tw,a.source_ssd_tw),'yyyymmdd') end end as max_new_ssd"+ //取消28天限制,PULL IN只要早於原交期即可 BY PEGGY 20230616
			  ",d.attribute20"+ //add by Peggy 20221229
			  //",tsc_om_check_shipping_advise(a.so_header_id,a.so_line_id) shipping_advise_flag"+//add by Peggy 20231002
			  ",case when a.plant_code!='002' then tsc_om_check_shipping_advise(a.so_header_id,a.so_line_id) else 'FALSE' end  shipping_advise_flag"+//add by Peggy 20231002
			  //",TSC_OM_CHECK_WMS_LOCK(a.so_line_id,'LOCK') wms_flag"+ //add by Peggy 20231026
			  ",case when a.plant_code='002' then TSC_OM_CHECK_WMS_LOCK(a.so_line_id,'LOCK') else 'F' end wms_flag"+
			  ",d.ordered_quantity erp_order_qty" + //add by Peggy 20240430
			  ",to_char(d.request_date,'yyyymmdd') erp_crd"+ //add by Peggy 20240430
			  " from oraddman.tsc_om_salesorderrevise_pc a"+
			  ",oraddman.tsprod_manufactory b"+
			  ",ont.oe_order_headers_all c"+
			  ",ont.oe_order_lines_all d"+
			  ",tsc_customer_all_v ar"+
			  ",hz_cust_accounts end_cust"+ 
			  " where d.org_id in (41,325,906)";
		if (ATYPE.equals("UPD"))
		{
			swhere += " AND a.BATCH_ID="+BID+"";
		}
		else
		{
			if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
			{
				swhere += " and a.PLANT_CODE='"+PLANTCODE+"'";
			}
		
			if (!salesGroup.equals("--") && !salesGroup.equals(""))
			{
				swhere += " and a.SALES_GROUP='"+salesGroup+"'";
				if (salesGroup.equals("TSCH-HK"))
				{
					swhere += " and (d.sold_to_org_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))) "+
                           " or end_cust.cust_account_id in (select  distinct CUSTOMER_ID from tsc_om_order_privilege x where x.RFQ_USERNAME='"+UserName+"' and sysdate between trunc(x.START_DATE_ACTIVE) and nvl(x.END_DATE_ACTIVE,to_date('20990101','yyyymmdd'))))";
				}				
			}
			else if ((UserRoles.indexOf("admin")<0 && UserRoles.indexOf("MPC_User")<0 && UserRoles.indexOf("MPC_003")<0 && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0) || (UserRoles.indexOf("Sale")>=0  && UserRoles.indexOf("Sales_M")<0 && UserName.indexOf("CYTSOU")<0 && UserName.indexOf("JUDY_CHO")<0 && UserName.indexOf("PERRY.JUAN")<0))
			{
				swhere += " and (exists (SELECT 1  FROM oraddman.tsrecperson x, oraddman.tssales_area b,tsc_om_group_master c,tsc_om_group d,oraddman.tsc_om_salesorderrevise_pc e"+
					   " where x.TSSALEAREANO=b.SALES_AREA_NO "+
					   " and ','||b.GROUP_ID||',' like '%,'||d.group_id ||',%'"+
					   " and c.master_group_id=d.master_group_id"+
					   " and d.group_name=e.SALES_GROUP"+
					   " and x.USERNAME ='"+UserName+"'"+
					   " and d.group_name=a.sales_group"+
					   " and b.SALES_AREA_NO!='020')"+
					   " or exists (select 1 from oraddman.tsrecperson x where (x.USERNAME='"+UserName+"' or 'CYTSOU'='"+UserName+"')"+
					   " and case when x.TSSALEAREANO='020' then 'SAMPLE' ELSE '' END=a.sales_group))";	
			}
			swhere +=" and a.status='"+ACTIONTYPE+"'";
			if (!CUSTOMER.equals("--") && !CUSTOMER.equals(""))
			{
				swhere += " and AR.ACCOUNT_NUMBER='"+CUSTOMER+"'";
			}	
			if (!REQUESTNO.equals("") && !REQUESTNO.equals("--"))
			{
				swhere += " and a.REQUEST_NO='"+ REQUESTNO+"'";
			}
			if (!REQUEST_DATE.equals("") && !REQUEST_DATE.equals("--"))
			{
				swhere += " and a.CREATION_DATE BETWEEN TO_DATE('"+ REQUEST_DATE+"','yyyymmdd') and TO_DATE('"+ REQUEST_DATE+"','yyyymmdd')+0.99999";
			}	
			//if (!REQ_TYPE.equals("") && !REQ_TYPE.equals("--"))
			//{
			//	sql += " and a.REQUEST_TYPE='"+REQ_TYPE+"'";
			//}				
			if (!REQ_TYPE_P.equals("") || !REQ_TYPE_O.equals("") || !REQ_TYPE_E.equals(""))
			{
				swhere += " and a.REQUEST_TYPE IN ('"+REQ_TYPE_P+"','"+REQ_TYPE_O+"','"+REQ_TYPE_E+"')";
			}
			if (!ITEM_DESC.equals(""))
			{
				//swhere += " and a.SOURCE_ITEM_DESC='"+ITEM_DESC+"'";
				String [] sArray = ITEM_DESC.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						swhere += " and (a.SOURCE_ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						swhere += " or a.SOURCE_ITEM_DESC like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) swhere += ")";
				}				
			}
			if (!CUST_ITEM.equals("") && !CUST_ITEM.equals("--"))
			{
				swhere += " and a.SOURCE_CUST_ITEM_NAME='"+CUST_ITEM+"'";
			}
			if (!CUST_LIST.equals("") && !CUST_LIST.equals("--"))
			{
				/*String [] sArray = CUST_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						swhere += " and (UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then upper(substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1)) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					else
					{
						swhere += " or UPPER((case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then upper(substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1)) else a.SOURCE_CUSTOMER_PO end "+
							   " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end )) like '%"+sArray[x].trim().toUpperCase()+"%'";
					}
					if (x==sArray.length -1) swhere += ")";
				}*/
				swhere += " and '('||ar.account_number||')'|| case when a.sales_group='TSCH-HK' or a.source_customer_id IN (15540) then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')',-1)-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+
			             " else nvl(ar.customer_sname,ar.customer_name) end ||case when a.source_customer_id IN (14980) then  nvl2(end_cust.account_name ,'('||end_cust.account_name ||')','') else '' end = '"+ CUST_LIST+"'";
			}		
			if (!MO_LIST.equals(""))
			{
				String [] sArray = MO_LIST.split("\n");
				for (int x =0 ; x < sArray.length ; x++)
				{
					if (x==0)
					{
						swhere += " and a.SO_NO in ('"+sArray[x].trim().toUpperCase()+"'";
					}
					else
					{
						swhere += " ,'"+sArray[x].trim().toUpperCase()+"'";
					}
					if (x==sArray.length -1) swhere += ")";
				}
			}		
		}
		swhere +=" and a.so_header_id=c.header_id(+)"+  
			  " and a.so_line_id=d.line_id(+)"+
			  " and a.plant_code =b.manufactory_no(+)"+
			  " and a.SOURCE_CUSTOMER_ID=ar.customer_id(+)"+
			  " and d.end_customer_id = end_cust.cust_account_id(+)"+ 
			  " AND NVL(a.ASCRIPTION_BY,'XX') NOT IN ('Sales')"+  //因為改單不異動,所以sales hold不顯示 add by Peggy 20221219
			  " order by 2,5,3,12,1,6,to_number(7),13,9,4";
		//out.println(sql);
		//out.println(swhere);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql+swhere);
		while (rs.next()) 
		{ 	
			if (rowcnt==0)
			{
			%>
	<DIV style="font-family:arial;font-size:12px">Qty Uom:PCE</DIV>
	<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
		<tr style="background-color:#E9F8F2;color:#000000">
			<td rowspan="2" width="2%" align="center">Seq No</td>
			<td colspan="12" width="39%" align="center">Order Original Detail</td>
			<td width="22%" style="background-color:#D3793D;color:#FFFFFF" colspan="6" align="center">SalesConfirm Detail </td>
			<td width="44%" style="background-color:#006699;color:#ffffff" colspan="7" align="center">PC Revise Detail</td>
		</tr>
		<tr style="background-color:#E9F8F2;color:#000000">
			<td width="4%" align="center">Sales Area </td>
			<td width="7%" align="center">Customer</td>
			<td width="6%" align="center">MO#</td>
			<td width="2%" align="center">Line#</td>	
			<td width="7%" align="center">Item Desc </td>	
			<td width="7%" align="center">Cust Item </td>	
			<td width="7%" align="center">Cust PO </td>	
			<td width="4%" align="center">Qty </td>	
			<td width="4%" align="center">CRD</td>	
			<td width="4%" align="center">SSD</td>	
			<td width="4%" align="center">Shipping Method</td>	
			<td width="3%" align="center">ERP Hold</td>	
			<td width="5%" align="center" style="background-color:#D3793D;color:#FFFFFF">Sales CFM Qty</td>
			<td width="5%" align="center" style="background-color:#D3793D;color:#FFFFFF">Slaes CFM SSD</td>
			<td width="4%" align="center" style="background-color:#D3793D;color:#FFFFFF">Shipping Method</td>
			<td width="4%" align="center" style="background-color:#D3793D;color:#FFFFFF">Hold</td>
			<td width="7%" align="left" style="background-color:#D3793D;color:#FFFFFF" colspan="2">Sales CFM Result
			<br>
			<input type="radio" name="rdoall" value="A" onClick="setRadioAll('A')">Accept
			<br>
			<input type="radio" name="rdoall" value="R" onClick="setRadioAll('R')">Reject
			<input type="text" name="salesremarkall" value="" style="background-color:#D3793D;color:#FFFFFF;border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:12px;" onChange="setRemarkAll()" size="8">
			</td>
			<td width="5%" style="background-color:#006699;color:#ffffff" align="center">Request No</td>
			<td width="7%" style="background-color:#006699;color:#ffffff" align="center">Plant Code </td>
			<td width="4%" style="background-color:#006699;color:#ffffff" center>Request type</td>
			<td width="4%" style="background-color:#006699;color:#ffffff" center>Order Qty</td>
			<td width="4%" style="background-color:#006699;color:#ffffff" center>TW SSD pull in/out</td>
			<td width="4%" style="background-color:#006699;color:#ffffff" center>SSD pull in/out</td>
			<td width="11%" style="background-color:#006699;color:#ffffff" center>Remarks</td>
		</tr>
			<%
			}
			
			rowcnt++;
			id =rs.getString("seq_id");
			%>
		<tr style="font-size:10px">
			<td><%=rowcnt%></td>
			<% 
			if (rs.getInt("line_seq")==1)
			{
			%>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SALES_GROUP")%></td>
			<td align="left" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("customer")%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SO_NO")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("line_no")%></td>
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_ITEM_DESC")%></td>
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUST_ITEM_NAME")%></td>
			<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("SOURCE_CUSTOMER_PO")%></td>
			<td rowspan="<%=rs.getString("line_cnt")%>"><input type="text" name="orig_qty_<%=id%>" value="<%=rs.getString("SOURCE_SO_QTY")%>" style="border-bottom:none;border-left:none;border-right:none;border-top:none;font-family: Tahoma,Georgia; font-size:10px;text-align:right" size="5" readonly>
			<%=(!rs.getString("erp_order_qty").equals(rs.getString("SOURCE_SO_QTY"))?"<br><font color='#ff0000'>ERP QTY:"+rs.getString("erp_order_qty")+"</font>":"")%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_REQUEST_DATE")==null?"&nbsp;":rs.getString("SOURCE_REQUEST_DATE"))%>
			<%=(rs.getString("erp_crd") !=null && !rs.getString("erp_crd").equals(rs.getString("SOURCE_REQUEST_DATE"))?"<br><font color='#ff0000'>ERP CRD:"+rs.getString("erp_crd")+"</font>":"")%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_SSD_TW")==null?"&nbsp;":rs.getString("SOURCE_SSD_TW"))%>
			<%=(rs.getString("erp_crd") !=null && !rs.getString("erp_ssd").equals(rs.getString("SOURCE_SSD_TW"))?"<br><font color='#ff0000'>ERP SSD:"+rs.getString("erp_ssd")+"</font>":"")%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("SOURCE_SHIPPING_METHOD")==null?"&nbsp;":rs.getString("SOURCE_SHIPPING_METHOD"))%></td>
			<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("attribute20")==null?"&nbsp;":rs.getString("attribute20"))%></td>
			<%
			}
			%>
			<td align="center"><input type="text" name="qty_<%=id%>" value="<%=(ATYPE.equals("UPD")?rs.getString("SALES_CONFIRMED_QTY"):rs.getString("SO_QTY"))%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:10px;text-align:right;" size="6" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" readonly><input type="hidden" name="sales_qty_<%=id%>" value="<%=(rs.getString("so_qty")==null?"":rs.getString("so_qty"))%>"></td>
			<td align="center"><input type="text" name="ssd_<%=id%>" value="<%=(ATYPE.equals("UPD")?rs.getString("SALES_CONFIRMED_SSD"):rs.getString("SCHEDULE_SHIP_DATE_TW"))%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:10px;text-align:right;<%=(rs.getInt("change_ssd")==0?"color:#000000;":(rs.getInt("change_ssd")>0?"color:#0000ff;":"color:#ff0000;"))%>" size="7" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" <%=(rs.getString("SOURCE_SSD").length()==8 && (((rs.getString("SOURCE_SSD").substring(0,4).equals("2099") || !rs.getString("PLANT_CODE").equals("006")) && rs.getString("request_type").equals("Early Ship")) || rs.getString("request_type").equals("Early Warning") || rs.getString("request_type").equals("Overdue"))?"":" readonly")%>>
							   <input type="hidden" name="sales_ssd_<%=id%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE_TW")==null?"":rs.getString("SCHEDULE_SHIP_DATE_TW"))%>">
							   <input type="hidden" name="factory_ssd_<%=id%>" value="<%=(rs.getString("SCHEDULE_SHIP_DATE")==null?"":rs.getString("SCHEDULE_SHIP_DATE"))%>">
							   <input type="hidden" name="source_ssd_<%=id%>" value="<%=(rs.getString("SOURCE_SSD_TW")==null?"":rs.getString("SOURCE_SSD_TW"))%>">
							   <input type="hidden" name="max_new_ssd_<%=id%>" value="<%=rs.getString("MAX_NEW_SSD")%>">
			</td>
			<td align="center"><input type="text" name="shipmethod_<%=id%>" value="<%=(rs.getString("SHIPPING_METHOD")==null?"":rs.getString("SHIPPING_METHOD"))%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:10px;" size="3" readonly><INPUT TYPE="button" name="btnship_<%=id%>" value="." onClick="subWindowShipMethodFind(this.form.shipmethod_<%=id%>.value,<%=id%>)" <%=(rs.getString("SALES_CONFIRMED_RESULT")!=null && rs.getString("SALES_CONFIRMED_RESULT").equals("A")?"":"disabled")%>></td>
			<td align="center"><input type="checkbox" name="chkhold_<%=id%>" value="Y" <%=(ATYPE.equals("UPD") && rs.getString("HOLD_CODE")!=null && rs.getString("HOLD_CODE").equals("Y")?"checked":"")%> <%=(ATYPE.equals("UPD")?"":"disabled")%>></td>
			<td width="10" id="tda_<%=id%>" align="center" <%=(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>>
			<% 
			if (rs.getString("shipping_advise_flag").equals("TRUE") || rs.getString("wms_flag").equals("T"))
			{
				out.println("&nbsp;");
			}
			else
			{
			%>
			<input type="checkbox" name="chk" value="<%=id%>" onClick="setChkboxPress('<%=rowcnt%>','<%=id%>')" <%=(ATYPE.equals("UPD")?" checked":"")%>>
			<%
			}
			%>
			<input type="hidden" name="totw_<%=id%>" value="<%=rs.getInt("TO_TW_DAYS")%>"></td>
			<td width="70" id="tdb_<%=id%>" <%=(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>>
			<% 
			if (rs.getString("shipping_advise_flag").equals("TRUE") || rs.getString("wms_flag").equals("T"))
			{
	
				out.println("<font color='red'>已排出貨通知,無法改單</font>");
			}
			else
			{
			%>		
			<input type="radio" name="rdo_<%=id%>" value="A" onClick="setRadioPress('<%=rowcnt%>','A','<%=id%>')" <%=(ATYPE.equals("UPD") &&rs.getString("SALES_CONFIRMED_RESULT").equals("A")?" checked":"")%>>
			Accept<BR>
				<div id="div_<%=id%>" style="visibility:hidden"><input type="checkbox" name="tsc_odr_nochange_<%=id%>" value="Y">台半交期不變</div>
				<input type="radio" name="rdo_<%=id%>" value="R" onClick="setRadioPress('<%=rowcnt%>','R','<%=id%>')" <%=(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("R")?" checked":"")%>>
				Reject
				<input type="text" name="salesremark_<%=id%>" value="<%=(ATYPE.equals("UPD")?(rs.getString("SALES_CONFIRMED_REMARKS")==null?"":rs.getString("SALES_CONFIRMED_REMARKS")):"")%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:12px;<%=(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("A")?"background-color:#C4F8A5;":(ATYPE.equals("UPD") && rs.getString("SALES_CONFIRMED_RESULT").equals("R")?"background-color:#FEA398;":""))%>" size="8">
			<%
			}
			%>			
			</td>
			<td align="center"><%=rs.getString("request_no")%></td>
			<td align="center"><%=rs.getString("MANUFACTORY_NAME")%></td>
			<td align="center" style="background-color:<%=rs.getString("request_type").equals("Overdue")?"#FF9999":(rs.getString("request_type").equals("Early Ship")?"#66FF99":"#FFFF33")%>"><%=rs.getString("request_type")%><input type="hidden" name="REQTYPE_<%=id%>" value="<%=rs.getString("request_type")%>"><input type="hidden" name="REQUESTNO_<%=id%>" value="<%=rs.getString("request_no")%>"></td>
			<td align="right"><%=(rs.getString("so_qty")==null?"&nbsp;":rs.getString("so_qty"))%><input type="hidden" name="so_line_id_<%=id%>" value="<%=rs.getString("so_line_id")%>"></td>
			<td align="center"><%=(rs.getString("schedule_ship_date_tw")==null?"&nbsp;":rs.getString("schedule_ship_date_tw"))%></td>
			<td align="center"><%=(rs.getString("schedule_ship_date")==null?"&nbsp;":rs.getString("schedule_ship_date"))%></td>
			<td><%=(rs.getString("reason_desc")==null?"&nbsp;":rs.getString("reason_desc"))+(rs.getString("reason_desc")!=null&&rs.getString("remarks")!=null?",":"")+(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%><input type="hidden" name="remark_<%=id%>" value="<%=(rs.getString("reason_desc")==null?"":rs.getString("reason_desc"))+(rs.getString("reason_desc")!=null&&rs.getString("remarks")!=null?",":"")+(rs.getString("remarks")==null?"":rs.getString("remarks"))%>"></td>
		</tr>	
		<%
		}
		rs.close();
		statement.close();
	}
	
	if (rowcnt >0) 
	{
%>
</table>
<hr>
<table border="0" width="100%" bgcolor="#DAF0FC">
	<tr>
		<td align="center"><input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSPCOrderReviseProcess.jsp?ACODE=CONFIRMED")'></td>
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
	out.println("<div align='center' style='font-size:12px;color:#ff0000'>Exception5:"+e.getMessage()+"</div>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>
