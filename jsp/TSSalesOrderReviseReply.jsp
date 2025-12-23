<!-- 20151130 Peggy,requeste date查詢條件-->
<!-- 20181016 Peggy,新增package欄位-->
<%@ page contentType="text/html; charset=utf-8"  language="java" %>
<%@ page import="java.sql.*,java.net.*,java.io.*,java.text.*,java.lang.*,java.util.*"%>
<html>
<head>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11x }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11x } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  TD        { font-family: Tahoma,Georgia; table-layout:fixed;}  
  TABLE     { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
</STYLE>
<title>Sales Order Confirm for Revise</title>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<%@ page import="DateBean,ComboBoxBean"%>
<%@ page import="Array2DimensionInputBean" %>
	<%@ page import="com.mysql.jdbc.StringUtils" %>
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

function setExcel(URL)
{
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit(URL)
{
	var chkflag=false;
	var chk_len =0,chkcnt=0,orig_so_qty=0;
	var id="",radflag="",r_year="",r_month="",r_day="",i_res="",so_line_id="";
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
			//orig_so_qty=document.MYFORM.elements["orig_qty_"+id].value; //add by Peggy 20211130
			
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
					if (j==1)
					{
						if (eval(document.MYFORM.elements["sales_ssd_"+id].value)>eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) //push out
						{					
							if (document.MYFORM.elements["PC_CONFIRM_REASON_"+id].value==null || document.MYFORM.elements["PC_CONFIRM_REASON_"+id].value=="" || document.MYFORM.elements["PC_CONFIRM_REASON_"+id].value=="--")
							{
							
									document.MYFORM.elements["PC_CONFIRM_REASON_"+id].focus();
									alert("Line"+(i+1)+": Please enter your reason for reject!!");
									return false;
							}
						
							if (document.MYFORM.elements["PC_CONFIRM_REASON_"+id].value=="4" && (document.MYFORM.elements["pcremark_"+id].value==null || document.MYFORM.elements["pcremark_"+id].value=="")) 
							{
								document.MYFORM.elements["pcremark_"+id].focus();
								alert("Line"+(i+1)+": Please enter detailed reasons!!");
								return false;
							}	
						}
						else
						{
							if (document.MYFORM.elements["pcremark_"+id].value==null || document.MYFORM.elements["pcremark_"+id].value=="")
							{
								document.MYFORM.elements["pcremark_"+id].focus();
								alert("Line"+(i+1)+": Please enter detailed reasons!!");
								return false;							
							}
						}											
					}

					radflag="Y";
				}
			}
			if (radflag=="N")
			{
				alert("Line"+(i+1)+": Please choose a result!!");
				return false;
			}
			if (i_res=="A")
			{
				if (document.MYFORM.elements["sales_ssd_"+id].value!="")
				{					
					//if (document.MYFORM.elements["so_"+id].value.substr(0,4) != "1121" && eval(document.MYFORM.elements["source_qty_"+id].value)!=eval(document.MYFORM.elements["qty_"+id].value) && eval(document.MYFORM.elements["qty_"+id].value)<1000 && eval(document.MYFORM.elements["qty_"+id].value)>0)
					//{
					//	alert("Line"+(i+1)+":Qty error!!");
					//	document.MYFORM.elements["qty_"+id].style.backgroundColor="#FFCCCC";  
					//	return false;			
					//}
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
						if (eval(document.MYFORM.elements["qty_"+id].value)>0 && eval(document.MYFORM.elements["ssd_"+id].value) < eval(document.MYFORM.SYSDATE.value) && eval(document.MYFORM.elements["ssd_"+id].value)!=eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) 
						{
							alert("Line"+(i+1)+":The schedule ship date must greater than today!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;	
						}
					}
					
					if (document.MYFORM.PLANTCODE.value=="005" || document.MYFORM.PLANTCODE.value=="008")
					{
						if (document.MYFORM.elements["pcremark_"+id].value!=null && document.MYFORM.elements["pcremark_"+id].value!="" && document.MYFORM.elements["pcremark_"+id].value.indexOf("持")>=0 && document.MYFORM.elements["pcremark_"+id].value.length==2)
						{
							alert("Line"+(i+1)+":維持原交期者,請判Rej!!");
							document.MYFORM.elements["pcremark_"+id].style.backgroundColor="#FFCCCC";  
							return false;	
						}
					}
					
					//pull in/push out檢查,add by Peggy 20211130
					if (eval(document.MYFORM.elements["sales_ssd_"+id].value)>eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) //push out
					{
						if (eval(document.MYFORM.elements["ssd_"+id].value)<eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) //pull in
						{
							alert("Line"+(i+1)+":業務要push out交期,若無法Push out,請判Rej!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;						
						}
					}
					//pull in/push out檢查,add by Peggy 20211130
					if (eval(document.MYFORM.elements["sales_ssd_"+id].value)<eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) //pull in
					{
						if (eval(document.MYFORM.elements["ssd_"+id].value)>eval(document.MYFORM.elements["orig_so_ssd_"+id].value)) //push out
						{
							alert("Line"+(i+1)+":業務要pull in 交期,若無法pull in,請判Rej!!");
							document.MYFORM.elements["ssd_"+id].style.backgroundColor="#FFCCCC";  
							return false;						
						}
					}
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
String PLANTCODE=request.getParameter("PLANTCODE");
if (PLANTCODE==null || PLANTCODE.equals("--")) PLANTCODE="";
if (UserRoles.indexOf("admin")<0)
{
	PLANTCODE=userProdCenterNo;
}
String salesGroup=request.getParameter("SALESGROUP");
if (salesGroup==null) salesGroup="";
String MONO=request.getParameter("MONO");
if (MONO==null) MONO="";
String ITEMDESC= request.getParameter("ITEMDESC");
if (ITEMDESC==null) ITEMDESC="";
String CUST = request.getParameter("CUST");
if (CUST==null) CUST="";
String REQUESTNO = request.getParameter("REQUESTNO");
if (REQUESTNO==null) REQUESTNO="";
String ACTIONTYPE="AWAITING_CONFIRM";
String ACTIONTYPE1="AWAITING_APPROVE"; //add by Peggy 20230519
String ATYPE = request.getParameter("ATYPE");
if (ATYPE==null) ATYPE="";
String ORGCODE = request.getParameter("ORGCODE");
if (ORGCODE==null || ORGCODE.equals("--")) ORGCODE="";
String REQUEST_DATE = request.getParameter("REQUEST_DATE");  //add by Peggy 20151130
if (REQUEST_DATE==null || REQUEST_DATE.equals("--")) REQUEST_DATE="";
String BID=request.getParameter("BID");
if (BID==null) BID="0";
String TOTW1 = request.getParameter("TOTW1");
if (TOTW1==null) TOTW1="";
String so_qty="",so_ssd="",pc_remarks="",pc_result="";
String strarray[]=new String [7];
int rowcnt=0, show_maxcnt=250,chkline=0;
%>
<body> 
<FORM ACTION="../jsp/TSSalesOrderReviseReply.jsp" METHOD="post" NAME="MYFORM">
<div style="font-family:Tahoma,Georgia;font-weight:bold;font-size:20px">Sales Order Confirm for Revise</div>
<div align="right"><A HREF="/oradds/ORADDSMainMenu.jsp" style="font-size:12px"><jsp:getProperty name="rPH" property="pgHome"/></A></div>
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
		<td width="5%" align="right">Plant Code:</td>
		<td width="5%">
		<%
		try
		{   
			sql = "select distinct PLANT_CODE, ALENGNAME from oraddman.tsc_om_salesorderrevise_req a,oraddman.tsprod_manufactory b where  a.plant_code=b.MANUFACTORY_NO";
			if (UserRoles.indexOf("admin")<0)
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
			if (UserRoles.indexOf("admin")<0)
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
		<td width="4%" align="right">ORG:</td>
		<td width="4%">
		<%
		try
    	{   
			Statement statement1=con.createStatement();
			sql = "select 'TSC' as vcode,'TSC' as vname from dual union all select 'SG' as vcode,'SG' as vname from dual ";
	    	ResultSet rs1=statement1.executeQuery(sql);
			out.println("<select NAME='ORGCODE' style='font-family:Tahoma,Georgia;font-size:11px'>");
			out.println("<OPTION VALUE=--"+ (ORGCODE.equals("") || ORGCODE.equals("--") ?" selected ":"")+">--");     
			while (rs1.next())
			{            
           		out.println("<OPTION VALUE='"+rs1.getString(1)+"'"+ (ORGCODE.equals(rs1.getString(1))?" selected ":"") +">"+rs1.getString(2));
			} 
			out.println("</select>"); 
			statement1.close();		  		  
			rs1.close();        	 
		} 
    	catch (Exception e) 
		{ 
			out.println("Exception3:"+e.getMessage()); 
		} 				
		%>
		</td>
		<td width="6%" align="right">Sales Group:</td>
		<td width="6%">
		<%
		try
		{   
			sql = "select distinct SALES_GROUP, SALES_GROUP from oraddman.tsc_om_salesorderrevise_req a,oraddman.tsprod_manufactory b where a.STATUS IN ('"+ACTIONTYPE+"','"+ACTIONTYPE1+"') and a.plant_code=b.MANUFACTORY_NO";
			if (!PLANTCODE.equals("") && !PLANTCODE.equals("--"))
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
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
		<td width="5%" align="right">Customer:</td>
		<td width="9%" colspan="3">
		<%
		try
		{   
			//sql = " select distinct NVL(c.CUSTOMER_NAME_PHONETIC,c.CUSTOMER_NAME),NVL(c.CUSTOMER_NAME_PHONETIC,c.CUSTOMER_NAME) "+
			sql = " select distinct customer,customer from (select case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  else nvl(c.CUSTOMER_SNAME,c.customer_name) end as customer "+
			      " from oraddman.tsc_om_salesorderrevise_req a,ont.oe_order_headers_all b,tsc_customer_all_v  c"+ //--ar_customers c"+
			      " where a.STATUS IN ('"+ACTIONTYPE+"','"+ACTIONTYPE1+"') and a.so_no=b.order_number and b.sold_to_org_id=c.customer_id";
			if (!PLANTCODE.equals("") && !PLANTCODE.equals("--"))
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
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
	</tr>
	<tr>
		<td width="6%" align="right">Item Desc:</td>
		<td width="10%">
		<%
		try
		{   
			sql = " select distinct c.description,c.description from oraddman.tsc_om_salesorderrevise_req a,ont.oe_order_lines_all b,inv.mtl_system_items_b c"+
			      " where a.STATUS IN ('"+ACTIONTYPE+"','"+ACTIONTYPE1+"') and a.so_line_id=b.line_id and b.inventory_item_id=c.inventory_item_id and b.ship_from_org_id=c.organization_id ";
			if (!PLANTCODE.equals("") && !PLANTCODE.equals("--"))
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
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
		<td width="3%" align="right">MO#:</td>
		<td width="6%"><input type="text" name="MONO" value="<%=MONO%>" style="font-family:Tahoma,Georgia;font-size:11px" size="10"></td>
		<td width="6%"align="right">Request No:</td>
		<td width="6%"><input type="text" name="REQUESTNO" value="<%=REQUESTNO%>" style="font-family:Tahoma,Georgia;font-size:11px" size="14"></td>		
		<td width="6%"align="right">Request Date:</td>
		<td width="6%">
		<%
		try
		{   
			sql = " select distinct to_char(a.creation_date,'yyyymmdd') creation_date ,to_char(a.creation_date,'yyyymmdd') from oraddman.tsc_om_salesorderrevise_req a,ont.oe_order_lines_all b "+
			      " where a.STATUS IN ('"+ACTIONTYPE+"','"+ACTIONTYPE1+"')"+
				  " and a.so_header_id=b.header_id"+
                  " and a.so_line_id=b.line_id";
			if (!PLANTCODE.equals("") && !PLANTCODE.equals("--"))
			{
				sql += " and a.PLANT_CODE='"+userProdCenterNo+"'";
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
			out.println("Exception:"+e.getMessage()); 
		} 	
		%>
		</td>	
		<td width="4%">TO TW:</font></td>
		<td width="3%">
		<select NAME="TOTW1" style="font-family: Tahoma,Georgia;font-size:11px" >
		<OPTION VALUE="--" <%=(TOTW1.equals("") || TOTW1.equals("--") ?" selected ":"")%>>
        <OPTION VALUE="N" <%=(TOTW1.equals("N")?" selected ":"")%>>否
        <OPTION VALUE="Y" <%=(TOTW1.equals("Y")?" selected ":"")%>>是
		</select>
		</td>			
	</tr>
</TABLE>
<P>
  <DIV align="CENTER"><input type="button" name="btnQuery" value="Query"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setQuery('../jsp/TSSalesOrderReviseReply.jsp')">&nbsp;&nbsp;
		<input type="button" name="btnExport" value="Export to Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setExcel('../jsp/TSSalesOrderReviseExcel.jsp?RTYPE=<%=ACTIONTYPE%>&STATUS=<%=ACTIONTYPE%>')">&nbsp;&nbsp; 
    	<input type="button" name="btnImport" value="Import From Excel"  style="font-family:Tahoma,Georgia;font-size:12px" onClick="setUpload('../jsp/TSSalesOrderRevisePCUpload.jsp?FACT=<%=PLANTCODE%>')">
		</DIV>
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
		  //",b.ALENGNAME"+
		  ",(SELECT ALENGNAME FROM oraddman.tsprod_manufactory b WHERE a.plant_code =b.manufactory_no) ALENGNAME "+ 
		  ",a.REQUEST_NO"+
		  ",a.remarks"+
		  ",a.SOURCE_SO_QTY orig_so_qty"+
		  //",f.description orig_item_desc"+
          ",(select f.description  from inv.mtl_system_items_b f where  a.SOURCE_ITEM_ID=f.inventory_item_id  and a.SOURCE_SHIP_FROM_ORG_ID=f.organization_id) orig_item_desc"+
		  ",APPS.TSCC_GET_FLOW_CODE(a.inventory_item_id)as flow_code"+
		  ",to_char(CASE WHEN a.packing_instructions IN ('Y','T') AND (SUBSTR(a.so_no,1,4) IN ('1131','1141','1121') OR (SUBSTR(a.so_no,1,4) IN ('1214') and nvl(a.TO_TW_DAYS,0)<>0)) and instr(NVL(a.remarks,' '),'NEW MO')=0 THEN TO_DATE(TSC_GET_YEW_TOTW_ORDER_INFO(a.so_line_id,'TSC','SSD',NULL),'YYYYMMDD')"+ //modify by Peggy 20201102 delta 1214 totw
		  //"  ELSE a.source_ssd END ,'yyyymmdd') AS  orig_schedule_ship_date"+
		  "  ELSE a.source_ssd-nvl(a.TO_TW_DAYS,0) END ,'yyyymmdd') AS  orig_schedule_ship_date"+ //回T依工廠SSD為準,MODIFY BY PEGGY 20220511
		  //",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end  "+
		  //" else nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) ||case when a.source_customer_id=14980 then nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') else '' end end as orig_customer"+
		  ",case when a.sales_group='TSCH-HK' then case when instr(a.SOURCE_CUSTOMER_PO,'(')>0  then substr(a.SOURCE_CUSTOMER_PO,instr(a.SOURCE_CUSTOMER_PO,'(')+1,instr(a.SOURCE_CUSTOMER_PO,')')-instr(a.SOURCE_CUSTOMER_PO,'(')-1) else a.SOURCE_CUSTOMER_PO end "+ 
          //" else (SELECT nvl(e.CUSTOMER_NAME_PHONETIC,e.customer_name) from ar_customers e where a.SOURCE_CUSTOMER_ID=e.customer_id) ||case when a.source_customer_id=14980 then (select  nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') from hz_cust_accounts end_cust where d.end_customer_id = end_cust.cust_account_id) else '' end end as orig_customer"+
		  " else (SELECT nvl(e.CUSTOMER_SNAME,e.customer_name) from tsc_customer_all_v e where a.SOURCE_CUSTOMER_ID=e.customer_id) ||case when a.source_customer_id=14980 then (select  nvl2(end_cust.account_name,'('||end_cust.account_name ||')','') from hz_cust_accounts end_cust where d.end_customer_id = end_cust.cust_account_id) else '' end end as orig_customer"+
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
          ",case when send_from_temp_id is null or a.plant_code='002' then 0 else (row_number() over(partition by send_from_temp_id,send_from_seq_id order by temp_id)) +"+
          " (select count(1) from oraddman.tsc_om_salesorderrevise_req_bk x where x.send_from_temp_id=a.send_from_temp_id and x.send_from_seq_id=a.send_from_seq_id) end resend_times"+//add by Peggy 20210730
		  ",case when a.send_from_temp_id is null or a.plant_code='002' then null else (select listagg(to_char(x.creation_date,'yyyymmdd'),'/') within group (order by x.creation_date desc ) dd from tsc_om_salesorderrevise_req_v x where x.temp_id<a.temp_id and a.send_from_temp_id ||'-'||a.send_from_seq_id in (x.send_from_temp_id ||'-'||x.send_from_seq_id,x.temp_id ||'-'||x.seq_id) ) end as send_date"+ //add by Peggy 20210730
		  ",case when a.send_from_temp_id is null or a.plant_code='002' then null else (select listagg(x.pc_remarks,'/') within group (order by x.creation_date desc ) dd from tsc_om_salesorderrevise_req_v x where x.temp_id<a.temp_id and x.pc_confirmed_result='R' AND a.send_from_temp_id ||'-'||a.send_from_seq_id in (x.send_from_temp_id ||'-'||x.send_from_seq_id,x.temp_id ||'-'||x.seq_id) ) end rej_reason"+  //add by Peggy 20210730
		  ",to_char(a.source_request_date,'yyyymmdd') source_crd "+ //add by Peggy 20211111
		  ",supplier_number"+   //add by Peggy 20220428
		  ",a.cancel_move_flag"+ //add by Peggy 20230508
		  ",a.status"+ //add by Peggy 20230519
		  " from oraddman.tsc_om_salesorderrevise_req a"+
		  //",oraddman.tsprod_manufactory b"+
		  //",ar_customers e"+
		  //",inv.mtl_system_items_b f"+
		  ",ont.oe_order_lines_all d"+		
		  //",hz_cust_accounts end_cust"+	  
		  " where a.status IN ('"+ACTIONTYPE+"','"+ACTIONTYPE1+"')"+
		  //" and a.SOURCE_CUSTOMER_ID=e.customer_id"+
		  //" and a.SOURCE_ITEM_ID=f.inventory_item_id"+
		  //" and a.SOURCE_SHIP_FROM_ORG_ID=f.organization_id"+
		  " and a.so_header_id=d.header_id"+
		  " and a.so_line_id=d.line_id";			  
		  //" AND d.end_customer_id = end_cust.cust_account_id(+)"+ //add by Peggy 20200520
		  //" and a.plant_code =b.manufactory_no(+)";
	if (!PLANTCODE.equals("--") && !PLANTCODE.equals(""))
	{
		sql += " and a.PLANT_CODE='"+PLANTCODE+"'";
	}
	if (ORGCODE.equals("SG"))
	{
		sql += " and a.packing_instructions='T'";
	}
	else if (ORGCODE.equals("TSC"))		
	{
		sql += " and a.packing_instructions<>'T'";
	}
	if (ATYPE.equals("UPD"))
	{
		sql += " and EXISTS (SELECT 1 FROM oraddman.tsc_om_salesorderrevise_req x where x.TEMP_ID||'.'||x.SEQ_ID in (";
		String fact_cfm[][]=FactoryCFMBean.getArray2DContent();
		if (fact_cfm!=null)
		{	
			for (int k=0 ; k < fact_cfm.length ; k++)
			{
				if (fact_cfm[k][0]!=null && !fact_cfm[k][0].equals(""))  //add by Peggy 20160701
				{
					sql += "'"+fact_cfm[k][0]+"',"; 
				}
			}
		} 
		sql += "'0.0') and x.temp_id=a.temp_id and x.so_line_id=a.so_line_id)";
	}
	else
	{
		FactoryCFMBean.setArray2DString(null); 
		if (!salesGroup.equals("") && !salesGroup.equals("--"))
		{
			sql += " and a.SALES_GROUP='"+salesGroup+"'";
		}
		if (!MONO.equals(""))
		{
			sql += " and a.SO_NO LIKE '"+MONO+"%'";
		}
		if (!REQUESTNO.equals(""))
		{
			sql += " and a.REQUEST_NO='"+ REQUESTNO+"'";
		}
		if (!REQUEST_DATE.equals("") && !REQUEST_DATE.equals("--"))
		{
			sql += " and a.CREATION_DATE BETWEEN TO_DATE('"+ REQUEST_DATE+"','yyyymmdd') and TO_DATE('"+ REQUEST_DATE+"','yyyymmdd')+0.99999";
		}			
		if (TOTW1 != null && !TOTW1.equals("--") && !TOTW1.equals(""))
		{
			if (TOTW1.equals("Y"))
			{
				sql += " and a.TO_TW_DAYS>0";
			}
			else
			{
				sql += " and a.TO_TW_DAYS=0";
			}
		}		
	}
	sql += " order by a.SALES_GROUP,a.SO_NO||'-'||a.LINE_NO,a.seq_id";
	//out.println(sql);
	Statement statement=con.createStatement(); 
	ResultSet rs=statement.executeQuery(sql);
	while (rs.next()) 
	{ 	
		if (!CUST.equals("") && !CUST.equals("--") && !rs.getString("orig_customer").equals(CUST.toUpperCase())) continue;
		if (!ITEMDESC.equals("") && !ITEMDESC.equals("--") && !rs.getString("orig_item_desc").equals(ITEMDESC)) continue;
	
		if (rowcnt==0)
		{
		%>
<DIV style="font-family:arial;font-size:12px">Qty Uom:PCE</DIV>
<table align="center" width="100%" border="1" bordercolorlight="#333366" bordercolordark="#ffffff" cellPadding="1" cellspacing="0">
	<tr style="background-color:#51874E;color:#FFFFFF;">
		<td rowspan="2" width="30" align="center">Seq No</td>
		<td rowspan="2" width="70" align="center">Request No</td>
		<td rowspan="2" width="50" align="center">Plant Code </td>
		<td colspan="9" width="600" align="center">Order Original Detail </td>
		<td width="200" style="background-color:#66CCCC;color:#000000" colspan="4" align="center">Factory Confirm Detail </td>
		<td width="500" style="background-color:#D1E0D3;color:#000000" colspan="12" align="center">Sales Revise Detail </td>
	</tr>
	<tr style="background-color:#D1E0D3;color:#000000">
		<td width="60" style="background-color:#51874E;color:#FFFFFF;" align="center">Sales Area </td>
		<td width="80" style="background-color:#51874E;color:#FFFFFF;" align="center">Customer</td>
		<td width="80" style="background-color:#51874E;color:#FFFFFF;" align="center">MO#</td>
		<td width="30" style="background-color:#51874E;color:#FFFFFF;" align="center">Line#</td>	
		<td width="150" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Item Desc </td>
		<td width="30" style="background-color:#51874E;color:#FFFFFF;" align="center">Flow Code</td>
		<td width="90" style="background-color:#51874E;color:#FFFFFF;" align="center">TSC Package </td>
		<td width="50" style="background-color:#51874E;color:#FFFFFF;" align="center">Original Qty </td>	
		<td width="60" style="background-color:#51874E;color:#FFFFFF;" align="center">Original SSD </td>	
		<td width="60" align="center" style="background-color:#66CCCC;color:#000000">Factory CFM Qty</td>
		<td width="60" align="center" style="background-color:#66CCCC;color:#000000">Factory CFM SSD </td>
		<td width="80" align="center" style="background-color:#66CCCC;color:#000000" colspan="2">Factory CFM Result</td>
		<td width="70">Remarks</td>
		<td width="50" align="center">Sales Qty</td>	
		<td width="50" align="center">Sales SSD pull in/out</td>
		<td width="50" align="center">CRD</td>	
		<td width="40" align="center">Order Type</td>	
		<td width="40">Customer</td>
		<td width="40">Ship To</td>
		<td width="40">Item Desc</td>
		<td width="40">Cust P/N</td>
		<td width="40">Cust PO</td>
		<td width="40">Shipping Method</td>
		<td width="40">Supplier Number</td>
	</tr>
		<%
		}
		
		rowcnt++;
		id =rs.getString("temp_id")+"."+rs.getString("seq_id");
		so_qty=rs.getString("so_qty");
		so_ssd=rs.getString("schedule_ship_date");
		if (so_ssd==null) so_ssd=rs.getString("orig_schedule_ship_date");
		pc_remarks="";pc_result="";
		if (ATYPE.equals("UPD"))
		{
			String fact_cfm[][]=FactoryCFMBean.getArray2DContent();
			if (fact_cfm!=null)
			{	
				for (int k=0 ; k < fact_cfm.length ; k++)
				{
					if (fact_cfm[k][0].equals(id))
					{
						so_qty=fact_cfm[k][1];
						so_ssd=fact_cfm[k][2];
						pc_result=(fact_cfm[k][3].toUpperCase().equals("OK")?"A":(fact_cfm[k][3].toUpperCase().startsWith("REJ")?"R":""));			
						pc_remarks=fact_cfm[k][4];
						break;
					}
				}
			}	
		}
		else
		{
			pc_remarks = (rs.getString("rej_reason")==null?"":(rs.getString("rej_reason").indexOf("/")>0?rs.getString("rej_reason").substring(0,rs.getString("rej_reason").indexOf("/")):rs.getString("rej_reason")));
			if (pc_remarks.indexOf("持")>0 && pc_remarks.length()==2)
			{
				pc_remarks = "維持";
			}
		}
		%>
	<tr style="font-size:10px">
		<td><%=rowcnt%></td>
		<% 
		if (!rs.getString("so_line_id").equals(so_line_id))
		{
			so_line_id=rs.getString("so_line_id");
		%>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("request_no")%><%=rs.getInt("resend_times")==0?"":"<br><font color='#0000ff'>Resend:"+rs.getString("resend_times")+"<br>("+(rs.getString("send_date").length()>9?rs.getString("send_date").substring(0,17):rs.getString("send_date"))+")</font>"%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("ALENGNAME")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("sales_group")%></td>
		<td align="left" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("orig_customer")%></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("so_no")%><%=(rs.getInt("TO_TW_DAYS")==0?"":"<br><font color='#ff0000'><回T></font>")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("line_no")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>" onMouseOver='this.T_ABOVE=false;this.T_WIDTH=100;this.T_OPACITY=80;return escape("<%=rs.getString("created_by")%>")'><%=rs.getString("orig_item_desc")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=StringUtils.isNullOrEmpty(rs.getString("flow_code"))? "" : rs.getString("flow_code")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><%=rs.getString("tsc_package")%></td>
		<td rowspan="<%=rs.getString("line_cnt")%>"><input type="text" name="orig_qty_<%=so_line_id%>" value="<%=rs.getString("orig_so_qty")%>" style="border-bottom:none;border-left:none;border-right:none;border-top:none;font-family: Tahoma,Georgia; font-size:10px;text-align:right" size="5" readonly></td>
		<td align="center" rowspan="<%=rs.getString("line_cnt")%>"><%=(rs.getString("orig_schedule_ship_date")==null?"&nbsp;":rs.getString("orig_schedule_ship_date"))%></td>
		<%
		}
		%>
		<td><input type="text" name="qty_<%=id%>" value="<%=(so_qty==null?"":so_qty)%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:10px;text-align:right;<%=(rs.getInt("change_qty")==0?"color:#000000;":(rs.getInt("change_qty")>0?"color:#0000ff;":"color:#ff0000;"))%>" size="5" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" title="<%=(rs.getInt("change_qty")==0?"":(rs.getInt("change_qty")>0?"數量增加":"數量減少"))%>"><input type="hidden" name="sales_qty_<%=id%>" value="<%=(rs.getString("so_qty")==null?"":rs.getString("so_qty"))%>"><input type="hidden" name="source_qty_<%=id%>" value="<%=(rs.getString("orig_so_qty")==null?"":rs.getString("orig_so_qty"))%>"><input type="hidden" name="so_<%=id%>" value="<%=rs.getString("so_no")%>">
		</td>
		<td><input type="text" name="ssd_<%=id%>" value="<%=(so_ssd==null?"":so_ssd)%>" style="font-weight:bold;font-family: Tahoma,Georgia; font-size:10px;text-align:right;<%=(rs.getInt("change_ssd")==0?"color:#000000;":(rs.getInt("change_ssd")>0?"color:#0000ff;":"color:#ff0000;"))%>" size="7" onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)" title="<%=(rs.getInt("change_ssd")==0?"":(rs.getInt("change_ssd")>0?"交期提前":"交期延後"))%>"><input type="hidden" name="sales_ssd_<%=id%>" value="<%=(rs.getString("schedule_ship_date")==null?"":rs.getString("schedule_ship_date"))%>"></td>
		<td width="10" id="tda_<%=id%>" align="center" <%=(pc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(pc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>>
		<% if (rs.getString("STATUS").equals(ACTIONTYPE))
		{
			chkline++;
		%>
		<input type="checkbox" name="chk" value="<%=id%>" onClick="setChkboxPress('<%=chkline%>','<%=id%>')" <%=(ATYPE.equals("UPD")?" checked":"")%>>
		<%
		}
		else
		{
			out.println("&nbsp;");
		}
		%>
		</td>
		<td width="70" id="tdb_<%=id%>" <%=(pc_result.equals("A")?"style="+'"'+"background-color:#C4F8A5;"+'"':(pc_result.equals("R")?"style="+'"'+"background-color:#FEA398;"+'"':""))%>>
		<% if (rs.getString("STATUS").equals(ACTIONTYPE))
		{
		%>		
		<input type="radio" name="rdo_<%=id%>" value="A" onClick="setRadioPress('<%=chkline%>','A','<%=id%>')" <%=(pc_result.equals("A")?" checked":"")%>>
		Accept<BR>
		    <input type="radio" name="rdo_<%=id%>" value="R" onClick="setRadioPress('<%=chkline%>','R','<%=id%>')" <%=(pc_result.equals("R")?" checked":"")%>  <%=(rs.getString("cancel_move_flag").equals("1")?" style='visibility:hidden' disabled":" style='visibility:visible'")%>>
		     <%=(rs.getString("cancel_move_flag").equals("1")?"":"Reject")%>
		<%
		try
		{   
			sql = "SELECT  a.a_seq, a.a_value  FROM oraddman.tsc_rfq_setup a  WHERE A_CODE='PC_ORDER_CONFIRM_REASON'  ORDER BY A.A_SEQ";
			Statement st2=con.createStatement();
			ResultSet rs2=st2.executeQuery(sql);
			comboBoxBean.setRs(rs2);
			comboBoxBean.setFontSize(11);
			comboBoxBean.setFontName("Tahoma,Georgia");
			//comboBoxBean.setSelection((request.getParameter("PC_CONFIRM_REASON_"+id)==null?"":request.getParameter("PC_CONFIRM_REASON_"+id)));
			comboBoxBean.setSelection(request.getParameter("PC_CONFIRM_REASON_"+id)==null?"":(ATYPE.equals("UPD")&&PLANTCODE.equals("002")&&pc_result.equals("R")?"4":request.getParameter("PC_CONFIRM_REASON_"+id)));
			comboBoxBean.setFieldName("PC_CONFIRM_REASON_"+id);	
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
		    <input type="text" name="pcremark_<%=id%>" value="<%=pc_remarks%>" style="border-bottom:ridge;border-top:none;border-right:none;border-left:none;font-family:Tahoma,Georgia;font-size:12px;<%=(pc_result.equals("A")?"background-color:#C4F8A5;":(pc_result.equals("R")?"background-color:#FEA398;":""))%>" size="8">
		<%
		}
		else
		{
			out.println("<font color='#0000ff'>Awaiting Sales Head Confirm</font>");
			
		}
		%>			
		</td>
		<td><%=(rs.getString("remarks")==null?"&nbsp;":rs.getString("remarks"))%></td>
		<td align="right"><%=(rs.getString("so_qty")==null?"&nbsp;":rs.getString("so_qty"))%></td>
		<td align="center"><%=(rs.getString("schedule_ship_date")==null?"&nbsp;":rs.getString("schedule_ship_date"))%><input type="hidden" name="orig_so_ssd_<%=id%>" value="<%=(rs.getString("orig_schedule_ship_date")==null?"":rs.getString("orig_schedule_ship_date"))%>"></td>
		<td align="center"><%=(rs.getString("request_date")==null || (rs.getString("request_date")!=null && rs.getString("request_date").equals(rs.getString("source_crd")))?"&nbsp;":(rs.getString("plant_code").equals("006")?rs.getString("source_crd")+"<br>":"")+rs.getString("request_date"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("order_type")==null?"&nbsp;":rs.getString("order_type"))%><input type="hidden" name="so_line_id_<%=id%>" value="<%=so_line_id%>"></td>
		<td style="color:#0000FF;"><%=(rs.getString("customer_name")==null?"&nbsp;":rs.getString("customer_name"))%></td>
		<td style="color:#0000FF;" valign="top"><%=(rs.getString("ship_to")==null?"&nbsp;":rs.getString("ship_to"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("item_desc")==null?"&nbsp;":rs.getString("item_desc"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("cust_item_name")==null?"&nbsp;":rs.getString("cust_item_name"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("customer_po")==null?"&nbsp;":rs.getString("customer_po"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("shipping_method")==null?"&nbsp;":rs.getString("shipping_method"))%></td>
		<td style="color:#0000FF;"><%=(rs.getString("supplier_number")==null?"&nbsp;":rs.getString("supplier_number"))%></td>
	</tr>	
	<%
		//if (!ATYPE.equals("UPD") && rowcnt >= show_maxcnt) break;
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
		<td align="center"><input type="button" name="submit1" value="Submit" style="font-size:11px;font-family: Tahoma,Georgia;" onClick='setSubmit("../jsp/TSSalesOrderReviseProcess.jsp?ACODE=CONFIRMED")'></td>
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
<input name="batchid" type="hidden" value="<%=BID%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
<script language="JavaScript" type="text/javascript" src="../wz_tooltip.js" ></script>
</body>
</html>

