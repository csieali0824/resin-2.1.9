<%@ page contentType="text/html;charset=utf-8" pageEncoding="GBK" language="java" %>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="jxl.*"%>
<%@ page import="WorkingDateBean"%>
<%@ page import="java.lang.Math.*"%>
<%@ page import="java.text.*"%>
<%@ page import="java.io.*,DateBean"%>
<%@ page errorPage="ExceptionHandler.jsp"%>
<%@ page import="DateBean,ArrayCheckBoxBean,Array2DimensionInputBean" %>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<html>
<head>
<title>TSCC K3 SYSTEM INFO SETUP</title>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayRFQDocumentInputBean" scope="session" class="Array2DimensionInputBean"/>
</head>
<script language="JavaScript" type="text/JavaScript">
function setChoose(strvalue)
{
	document.MYFORM.action="../jsp/TSSalesOrderBaseDataSetupK3.jsp?TKIND="+strvalue;
	document.MYFORM.submit(); 
}
function setAdd(URL)
{    
	var w_width=1400;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x+',scrollbars=yes,menubar=no';
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);	
}
function setDelete(URL)
{  
	if (confirm("您確定要刪除此筆資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}
function setUpdate(URL)
{
	var w_width=1400;
	var w_height=400;
    var x=(screen.width-w_width)/2;
    var y=(screen.height-w_height-200)/2;
    var ww='width='+w_width+',height='+w_height+',top='+y+',left='+x+',scrollbars=yes,menubar=no';
	document.getElementById("alpha").style.width=document.body.clientWidth;
	document.getElementById("alpha").style.height=document.body.clientHeight;
	subWin=window.open(URL,"subwin",ww);
}

</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline; font-size: 12px  }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
</head>
<body>
<%

String oneDArray[] = null;
String strKind=request.getParameter("TKIND");
if (strKind==null) strKind="ERP";
String sql="";
int icnt=0;
CallableStatement cs1 = con.prepareCall("{call mo_global.set_policy_context('S', ?)}");
cs1.setString(1,"325");
cs1.execute();
//out.println("Procedure : Execute Success !!! ");
cs1.close();
/*
try
{
	sql = "select '('||SALES_AREA_NO||')'||SALES_AREA_NAME from oraddman.tssales_area a where SALES_AREA_NO =?";
	if (UserRoles!="admin" && !UserRoles.equals("admin")) 
	{ 	 
		sql += " and exists (select 1 from oraddman.tsrecperson x where x.USERNAME='"+UserName+"' and x.tssaleareano=a.SALES_AREA_NO)";
	}
	PreparedStatement statex = con.prepareStatement(sql);
	statex.setString(1,SalesAreaNo);
	ResultSet rsx=statex.executeQuery();
	if (!rsx.next()) 
	{ 	
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("您沒有該區域使用權限,無法使用此功能,謝謝!");
			location.href="../ORAddsMainMenu.jsp";
			//closeWindow();
		</script>
		<%	
	}
	else
	{
		SalesArea = rsx.getString(1);
	}
	rsx.close();
	statex.close();
}
catch(Exception e)
{
	out.println(e.getMessage());
}
*/
%>
<FORM ACTION="../jsp/TSSalesOrderBaseDataSetupK3.jsp" METHOD="post" NAME="MYFORM">
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 300px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料正在處理中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<table width="100%" align="center" border="0">
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
			<table width="100%" cellspacing="0" cellpadding="0" bordercolordark="#009933">
				<tr>
					<td height="50" align="center">
						<font color="#003399" size="+2"><strong>TSCC K3 System Info Setup</strong></font></td>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
			<table align="center" width="100%" cellspacing="0" cellpadding="1" bordercolordark="#990000" border="1" bordercolorlight="#33CC66">
				<tr style="color:#336600">
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("DEPT")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'"  <%=(strKind.toUpperCase().equals("DEPT")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('DEPT')"><div id="div1" style="font-weight:bold;font-size:13px;">Department</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("SALES")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("SALES")?"style='background-color:#CCFF99'":"style='background-colorr:#FFFFFF'")%> onClick="setChoose('SALES')"><div id="div2" style="font-weight:bold;font-size:13px;">Sales</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("CUST")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("CUST")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('CUST')"><div id="div3" style="font-weight:bold;font-size:13px;" >Customer</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("ERP")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("ERP")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('ERP')"><div id="div4" style="font-weight:bold;font-size:13px;" >Link ERP Customer</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("SUPPLIER")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("SUPPLIER")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('SUPPLIER')"><div id="div5" style="font-weight:bold;font-size:13px;" >Supplier</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("CURR")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("CURR")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('CURR')"><div id="div6" style="font-weight:bold;font-size:13px;" >Currency</div></TD>
					<TD height="50" width="10%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='<%=(strKind.toUpperCase().equals("ADDR")?"#CCFF99":"#FFFFFF")%>';style.color='#000000';this.style.fontWeight='normal'" <%=(strKind.toUpperCase().equals("ADDR")?"style='background-color:#CCFF99'":"style='background-color:#FFFFFF'")%> onClick="setChoose('ADDR')"><div id="div7" style="font-weight:bold;font-size:13px;" >Link ERP Ship to Location</div></TD>
					<TD height="50" width="20%" align="center" onMouseOver="this.style.Color='#91819A';this.style.backgroundColor='#CCFF99';this.style.fontWeight='normal'" onMouseOut="style.backgroundColor='#FFFFFF';style.color='#000000';this.style.fontWeight='normal'" title="Go to home page!"><A HREF="../ORAddsMainMenu.jsp" style="font-weight:bold;font-size:13px;color:#336600">Go To Home Page</A></TD>
				</tr>
			</table>
		</td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
		<%
		if (strKind.toUpperCase().equals("DEPT"))
		{
			sql = "SELECT DEPT_CODE,DEPT_NAME FROM ORADDMAN.TSCC_K3_DEPT ORDER BY DEPT_CODE";	
			oneDArray=new String[]{"Dept No","Dept Name"};
		}
		else if (strKind.toUpperCase().equals("SALES"))
		{
			sql = "SELECT SALES_CODE,SALES_NAME FROM ORADDMAN.TSCC_K3_SALES ORDER BY SALES_CODE";	
			oneDArray=new String[]{"Sales Code","Sales Name"};
		}
		else if (strKind.toUpperCase().equals("CUST"))
		{
			sql = " SELECT A.CUST_CODE,A.CUST_NAME,A.DEPT_CODE,C.DEPT_NAME,B.SALES_CODE,B.SALES_NAME "+
			      " FROM ORADDMAN.TSCC_K3_CUST A,ORADDMAN.TSCC_K3_SALES B,ORADDMAN.TSCC_K3_DEPT C"+
			      " WHERE A.DEPT_CODE=C.DEPT_CODE(+)"+
				  " AND A.SALES_CODE=B.SALES_CODE(+)"+
			      " ORDER BY A.CUST_CODE";	
			oneDArray=new String[]{"Customer Code","Customer Name","Dept Code","Dept Name","Sales Code","Sales Name"};
		}
		else if (strKind.toUpperCase().equals("SUPPLIER"))
		{
			sql = "SELECT SUPPLIER_CODE,SUPPLIER_NAME,ERP_ORDER_CODE,ERP_VENDOR_CODE FROM ORADDMAN.TSCC_K3_SUPPLIER ORDER BY SUPPLIER_CODE";	
			oneDArray=new String[]{"Supplier Code","Supplier Name","ERP Order Number","ERP Vendor Code"};
		}
		else if (strKind.toUpperCase().equals("CURR"))
		{
			sql = "SELECT CURRENCY_CODE,TAX_RATE,ERP_ORDER_CODE FROM ORADDMAN.TSCC_K3_CURR ORDER BY CURRENCY_CODE";	
			oneDArray=new String[]{"Currency Code","Tax Rate","ERP Order Number"};
		}
		else if (strKind.toUpperCase().equals("ADDR"))  //add by Peggy 20190625
		{
			sql = "SELECT tkale.addr_code,ac.customer_number,ac.customer_name,tkale.erp_ship_to_location_id, loc.address1 ,tkale.cust_eng_short_name,case when tkale.ACTIVE_FLAG ='A' THEN 'Active' else 'Inactive' end as active_flag"+
                  " FROM hz_cust_acct_sites acct_site,"+
                  " hz_party_sites party_site,"+
                  " hz_locations loc,"+
                  " hz_cust_site_uses_all site,"+
                  " ar_customers ac,"+
                  " oraddman.tscc_k3_addr_link_erp tkale"+
                  " WHERE site.cust_acct_site_id = acct_site.cust_acct_site_id"+
                  " AND acct_site.party_site_id = party_site.party_site_id"+
                  " AND party_site.location_id = loc.location_id"+
                  //" AND acct_site.status = 'A'"+
                  " AND acct_site.cust_account_id =ac.customer_id"+
                  //" AND site.status = 'A'"+
                  " AND to_char(site.location)=to_char(tkale.erp_ship_to_location_id)"+
				  " order by case when instr(tkale.addr_code,'-')>0 then substr(tkale.addr_code,1,instr(tkale.addr_code,'-')-1) else tkale.addr_code end,"+
                  " case when instr(tkale.addr_code,'-')>0 then  to_number(substr(tkale.addr_code,instr(tkale.addr_code,'-')+1)) else 0 end";
			oneDArray=new String[]{"K3 Addr Code","ERP Customer Number","ERP Customer Name","ERP Ship to Location","ERP Ship to Address","Cust Eng Short Name","Active Flag"};
		}		
		else
		{
			sql = " SELECT A.ERP_CUST_NUMBER"+
		          ",E.CUSTOMER_NAME"+
				  ",B.CUST_CODE"+
				  ",B.CUST_NAME"+
				  ",A.CUST_ENG_SHORT_NAME"+
				  ",D.DEPT_CODE"+
				  ",D.DEPT_NAME"+
				  ",C.SALES_CODE"+
				  ",C.SALES_NAME"+
				  ",case when A.ACTIVE_FLAG ='A' THEN 'Active' else 'Inactive' end as active_flag "+
			      " FROM ORADDMAN.TSCC_K3_CUST_LINK_ERP A"+
				  ",ORADDMAN.TSCC_K3_CUST B"+
				  ",ORADDMAN.TSCC_K3_SALES C"+
				  ",ORADDMAN.TSCC_K3_DEPT D"+
				  ",AR_CUSTOMERS E"+
			      " WHERE A.CUST_CODE=B.CUST_CODE(+)"+
				  " AND B.DEPT_CODE=D.DEPT_CODE(+)"+
				  " AND B.SALES_CODE=C.SALES_CODE(+)"+
				  " AND A.ERP_CUST_NUMBER=E.CUSTOMER_NUMBER(+)";
			oneDArray=new String[]{"ERP Customer Number","ERP Customer Name","Customer Code","Customer Name","Cust Eng Short Name","Dept Code","Dept Name","Sales Code","Sales Name","Active Flag"};
		}
		%>
		</td>		
		<td width="5%">&nbsp;</td>
	</tr>		
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%"><INPUT TYPE="button" align="middle"  value='Add New'  style="font-family:ARIAL" onClick='setAdd("../jsp/TSSalesOrderBaseDataModifyK3.jsp?TKIND=<%=strKind%>&STATUS=NEW")' <%=((UserName.equals("CASEY") || UserName.equals("SUNNY_LU") || UserName.equals("PEGGY_CHEN")|| UserName.equals("MARS.WANG"))?"":"disabled")%>></td>
		<td width="5%">&nbsp;</td>
	</tr>
	<tr>
		<td width="5%">&nbsp;</td>
		<td width="90%">
		<%
			System.out.println(sql);
		Statement statement=con.createStatement(); 
		ResultSet rs=statement.executeQuery(sql);	
		ResultSetMetaData md=rs.getMetaData();
		while (rs.next()) 
		{
			if (icnt==0)
			{
			%>
			<table align="center" width="100%" cellspacing="1" cellpadding="1" bordercolordark="#ffffff" border="1" bordercolorlight="#999933">
				<tr style="background-color:#CCFF99;color:#336600">
			<%
				for (int i =0 ; i < oneDArray.length ; i ++)
				{
					if (i==0){%><td width="3%" align="center">No</td><td width="3%">&nbsp;</td><%}
				%>
					<td><%=oneDArray[i]%></td>
				<%
				} 
			%>
				</tr>
			<%
			}
			
			for (int j =1 ; j <= md.getColumnCount() ; j++)
			{
				if (strKind.toUpperCase().equals("ERP")) 
				{
					if (j==1){%><tr><td align="center"><%=(icnt+1)%></td><td align="center"><%=((UserName.equals("CASEY") || UserName.equals("SUNNY_LU") || UserName.equals("PEGGY_CHEN")|| UserName.equals("MARS.WANG"))?"<img border='0' src='images/updateicon_enabled.gif' height='18' title='modify' onClick='setUpdate("+'"'+"../jsp/TSSalesOrderBaseDataModifyK3.jsp?TKIND="+strKind+"&STATUS=UPD&CODE="+rs.getString(j)+"&CODE1="+rs.getString(3)+'"'+")'>":"")%></td><%}
				}
				else
				{
					if (j==1){%><tr><td align="center"><%=(icnt+1)%></td><td align="center"><%=((UserName.equals("CASEY") || UserName.equals("SUNNY_LU") || UserName.equals("PEGGY_CHEN")|| UserName.equals("MARS.WANG"))?"<img border='0' src='images/updateicon_enabled.gif' height='18' title='modify' onClick='setUpdate("+'"'+"../jsp/TSSalesOrderBaseDataModifyK3.jsp?TKIND="+strKind+"&STATUS=UPD&CODE="+rs.getString(j)+'"'+")'>":"")%></td><%}
				}					
			%>
				
				<td><%=(rs.getString(j)==null?"&nbsp;":rs.getString(j))%></td>
			<%
				if (j==md.getColumnCount()){%></tr><%}
			}
			icnt++;	
		}
		rs.close();
		statement.close();			
		
		if (icnt>0)
		{
		%>
			</table>
		<%
		}
		%>
		</td>		
		<td width="5%">&nbsp;</td>
	</tr>		
</table>
</form>
<!--=============以下區段為釋放連結池==========-->  
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
</body>
</html>
