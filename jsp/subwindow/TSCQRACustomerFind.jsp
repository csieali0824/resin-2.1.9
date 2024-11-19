<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ include file="/jsp/include/PageHeaderSwitch.jsp"%>
<%@ page import="SalesDRQPageHeaderBean" %>
<jsp:useBean id="rPH" scope="application" class="SalesDRQPageHeaderBean"/>
<%@ include file="/jsp/include/ProgressStatusBarStart.jsp"%>
<%
String TERRITORY=request.getParameter("TERRITORY");
if (TERRITORY==null) TERRITORY="";
String MARKETGROUP=request.getParameter("MARKETGROUP");
if (MARKETGROUP==null)  MARKETGROUP="";
String CUSTOMER=request.getParameter("CUSTOMER");
if (CUSTOMER==null) CUSTOMER=""; 
String CUSTLIST = request.getParameter("CUSTLIST");
if (CUSTLIST==null) CUSTLIST="";
String QNO=request.getParameter("QNO");
if (QNO==null) QNO="";
String sql = "";
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<title>Page for choose Customer List</title>
</head>
<script language="JavaScript" type="text/JavaScript">
function setSubmit()
{    
 	document.SUBFORM.submit();
}
function chkall()
{
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		for (var i =0 ; i < document.SUBFORM.CHKBOX.length ;i++)
		{
			document.SUBFORM.CHKBOX[i].checked= document.SUBFORM.CHKBOXALL.checked;
			setCheck((i+1));
		}
	}
	else
	{
		document.SUBFORM.CHKBOX.checked = document.SUBFORM.CHKBOXALL.checked;
		setCheck(1);
	}
}
function setCheck(irow)
{
	var chkflag ="";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkflag = document.SUBFORM.CHKBOX[(irow-1)].checked; 
	}
	else
	{
		chkflag = document.SUBFORM.CHKBOX.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tr_"+irow).style.backgroundColor = document.SUBFORM.STRBGCOLOR.value;
	}
	else
	{
		document.getElementById("tr_"+irow).style.backgroundColor ="#FFFFFF";
	}
}

function sendToMainWindow()
{
	var chkleng =0;
	var chked = false;
	var strchkvlaue = "";
	var choosevalue = "";
	if (document.SUBFORM.CHKBOX.length != undefined)
	{
		chkleng = document.SUBFORM.CHKBOX.length;
	}
	else
	{
		chkleng = 1;
	}
	for (var i = 0 ; i < chkleng ; i++)
	{
		if ( chkleng == 1)
		{
			chked = document.SUBFORM.CHKBOX.checked;
			strchkvlaue = document.SUBFORM.CHKBOX.value;
		}
		else
		{
			chked = document.SUBFORM.CHKBOX[i].checked; 
			strchkvlaue = document.SUBFORM.CHKBOX[i].value;
		}
		if (chked)
		{
			if (choosevalue.length >0) choosevalue +="\n";
			//choosevalue += "("+document.getElementById("div_"+(i+1)+"_1").innerHTML+") "+document.getElementById("div_"+(i+1)+"_2").innerHTML;
			choosevalue += document.getElementById("div_"+(i+1)+"_2").innerHTML;
		}
	}
	if (window.opener.document.MYFORM.elements["CUSTOMER"].value !=null && window.opener.document.MYFORM.elements["CUSTOMER"].value!="")
	{
		choosevalue =window.opener.document.MYFORM.elements["CUSTOMER"].value+"\n"+choosevalue;
	}
	window.opener.document.MYFORM.elements["CUSTOMER"].value = choosevalue;
	this.window.close();
}
</script>
<body >  
<FORM METHOD="post" ACTION="TSCQRACustomerFind.jsp" NAME="SUBFORM">
<table>
	<tr>
		<td>
			<table>
				<tr>
					<td style="font-family:arial;font-size:12px">Customer Name:</td>
					<td><input type="text" name="CUSTOMER" style="font-family:arial" value="<%=CUSTOMER%>"></td>
					<td><input type="submit" name="submit" value="Query" style="font-family:arial"></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<%     
				CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S',?)}");
				cs1.setString(1,"41");  // 取業務員隸屬ParOrgID
				cs1.execute();
				cs1.close();	
				
				Statement statement=con.createStatement();
				String trBgColor="#D9D540";
				try
				{ 
					sql = " select distinct a.customer_number,nvl(a.CUSTOMER_NAME_PHONETIC,customer_name) CUSTOMER_SHORT_NAME,a.customer_name,a.attribute2 market_group,tog.GROUP_NAME territory"+
					      " from ar_customers a ,APPS.HZ_CUST_ACCT_SITES_ALL hasa ,HZ_CUST_SITE_USES_ALL hcsu ,TSC_OM_GROUP tog "+
					      " where a.customer_id=hasa.CUST_ACCOUNT_ID and hasa.CUST_ACCT_SITE_ID = hcsu.CUST_ACCT_SITE_ID  "+
						  " and  hasa.ORG_ID = hcsu.ORG_ID and TO_NUMBER(hcsu.ATTRIBUTE1) = tog.GROUP_ID";
					if (!TERRITORY.equals(""))
					{
						sql += " and tog.GROUP_NAME in ("+"'"+TERRITORY.replace(";","','")+"'"+")";
					}
					if (!MARKETGROUP.equals(""))
					{
						sql += " and a.attribute2 in ("+"'"+MARKETGROUP.replace(";","','")+"'"+")";
					}
					if (!QNO.equals(""))
					{
						sql += " and exists (select 1 from oraddman.tsqra_pcn_item_detail x where x.pcn_number in ("+"'"+QNO.replace(";","','")+"'"+")"+
						       " and x.CUST_short_NUMBER = nvl(a.CUSTOMER_NAME_PHONETIC,customer_name))";
					}
					if (!CUSTOMER.equals(""))
					{
						 sql += " and upper(nvl(a.CUSTOMER_NAME_PHONETIC,a.customer_name)) like '"+ CUSTOMER.toUpperCase()+"%'";
					}
					sql += " order by upper(nvl(a.CUSTOMER_NAME_PHONETIC,a.customer_name)),tog.GROUP_NAME,a.attribute2,a.customer_number";
					//out.println(sql);
					ResultSet rs=statement.executeQuery(sql);
					ResultSetMetaData md=rs.getMetaData();
					int colCount=md.getColumnCount();
					String colLabel[]=new String[colCount+1]; 
					out.println("<TABLE border='1'  cellPadding='1'  cellSpacing='0' borderColorLight='#CCCCCC' bordercolordark='#5C7671'>");      
					out.println("<TR><TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'><input type='checkbox' name='CHKBOXALL' onClick='chkall();'></TH>");        
					for (int i=1;i<=colCount;i++) 
					{
						colLabel[i]=md.getColumnLabel(i);
						out.println("<TH BGCOLOR=BLACK style='font-size:12px;font-family:arial;color=#ffffff'>"+colLabel[i].toUpperCase()+"</TH>");
					} 
					out.println("</TR>");
					String strListValue = "",strchk="",strbgColor="";
					int vline=0;
					String [] chooseList  = CUSTLIST.split(";");
					while (rs.next())
					{
						strbgColor = "#FFFFFF"; 
						strchk = "";
						vline++;
						for (int i = 0 ; i < chooseList.length ; i++)
						{
							if (chooseList[i].equals(rs.getString(1)))
							{
								strchk="checked";
								strbgColor=trBgColor;
								break;
							}
						}
						out.println("<TR id='tr_"+vline+"' BGCOLOR='"+strbgColor+"'>");
						out.println("<TD><input type='checkbox' name='CHKBOX' value='"+vline+"' "+strchk+"  onclick=setCheck('"+vline+"');></TD>");
						for (int i=1;i<=colCount;i++) // 不顯示第一欄資料, 故 for 由 2開始
						{
							strListValue=rs.getString(i);
							out.println("<TD style='font-size:12px;font-family:arial'><div id='div_"+vline+"_"+i+"'>"+ strListValue+"</div></TD>");
						} 
						out.println("</TR>");	
					}
					out.println("</TABLE>");	
					rs.close();       
				}
				catch (Exception e)
				{
					out.println("Exception1:"+e.getMessage());
				}
				statement.close();
			%>
		</td>
	</tr>
	<tr>
	<td align='center'><input type="button" name="btn1" value="Confirm" onClick="sendToMainWindow()" style="font-family:arial"></td>
	</tr>
</table>
<INPUT TYPE="hidden" NAME="TERRITORY" value="<%=TERRITORY%>" >
<INPUT TYPE="hidden" NAME="MARKETGROUP" value="<%=MARKETGROUP%>">
<INPUT TYPE="hidden" NAME="QNO" value="<%=QNO%>">
<input type="hidden" name="STRBGCOLOR" value="<%=trBgColor%>">
</FORM>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<%@ include file="/jsp/include/ProgressStatusBarStop.jsp"%>
</body>
</html>
