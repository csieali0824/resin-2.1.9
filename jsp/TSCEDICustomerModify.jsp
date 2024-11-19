<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" %>
<%@ page import="DateBean"%>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
var checkflag = "false";
document.onclick=function(e)
{
	var t=!e?self.event.srcElement.name:e.target.name;
	if (t!="popcal") 
		gfPop.fHideCal();

}
function subWindowShipToFind(siteUseCode,customerID,salesAreaNo)
{   
	if (salesAreaNo == null || salesAreaNo =="")
	{
		alert("請先選擇業務地區別!");
		return false;
	}

	if (customerID == null || customerID =="")
	{
		alert("請先選擇客戶!");
		return false;
	}
		
	subWin=window.open("../jsp/subwindow/TSDRQSiteUseInfoFind.jsp?SITEUSECODE="+siteUseCode+"&CUSTOMERID="+customerID+"&SALESAREANO="+salesAreaNo+"&FUNC=D9001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function setCustInfoFind(custID,custName,chAreaNo)
{      
	if (chAreaNo== null || chAreaNo =="" || chAreaNo =="--")
	{
		alert("請先選擇業務地區別!");
		return false;
	}
	subWin=window.open("../jsp/subwindow/TSDRQCustomerInfoFind.jsp?CUSTOMERNO="+custID+"&NAME="+custName+"&ORGID=41&SAREANO="+chAreaNo+"&FuncName=D9001","subwin","width=640,height=480,scrollbars=yes,menubar=no");  
}
function setSubmit(URL)
{ 
	if (document.MYFORM.CUSTOMERNO.value==null || document.MYFORM.CUSTOMERNO.value=="")
	{
		alert("請選擇客戶!!");
		document.MYFORM.CUSTOMERNO.focus();
		return false;
	}
	if (document.MYFORM.CUSTOMERNAME.value==null || document.MYFORM.CUSTOMERNAME.value=="")
	{
		alert("請選擇客戶!!");
		document.MYFORM.CUSTOMERNAME.focus();
		return false;
	}
	if (document.MYFORM.SCUSTOMER.value==null || document.MYFORM.SCUSTOMER.value=="")
	{
		alert("請選擇客戶簡稱!!");
		document.MYFORM.SCUSTOMER.focus();
		return false;
	}
	if (document.MYFORM.EDIID.value==null || document.MYFORM.EDIID.value=="")
	{
		alert("請輸入EDI客戶識別碼!!");
		document.MYFORM.EDIID.focus();
		return false;
	}	
	if (document.MYFORM.SUPPLIERID.value==null || document.MYFORM.SUPPLIERID.value=="")
	{
		alert("請輸入台半的供應商代碼!!");
		document.MYFORM.SUPPLIERID.focus();
		return false;
	}	
	if (document.MYFORM.SALESAREANO.value==null || document.MYFORM.SALESAREANO.value=="" || document.MYFORM.SALESAREANO.value=="--")
	{
		alert("請輸入RFQ業務區域!!");
		document.MYFORM.SALESAREANO.focus();
		return false;
	}
	if (document.MYFORM.SALESCONTACT.value==null || document.MYFORM.SALESCONTACT.value=="" || document.MYFORM.SALESCONTACT.value=="--")
	{
		alert("請輸入業務窗口!!");
		document.MYFORM.SALESCONTACT.focus();
		return false;
	}			
	document.MYFORM.save.disabled=true;
	document.MYFORM.abort.disabled=true;
	document.getElementById("alpha").style.width=document.body.clientWidth+"px";
	document.getElementById("alpha").style.height=document.body.clientHeight+"px";
	document.getElementById("showimage").style.visibility = '';
	document.getElementById("blockDiv").style.display = '';
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setSubmit1(URL)
{ 
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}
function setClose(URL)
{
	if (confirm("您確定要離開嗎?"))
	{
		location.href=URL;
	}
}
</script>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   { font-family: Tahoma,Georgia: font-size:12px}
</STYLE>
<title>EDI客戶基本資料維護</title>
</head>
<body>
<br>
<FORM NAME="MYFORM" ACTION="../jsp/TSCEDICustomerModify.jsp" METHOD="POST"> 
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="標楷體" size="+2">資料儲存中,請稍候.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<%
	String ACTIONTYPE =request.getParameter("ACTIONTYPE");
	if (ACTIONTYPE==null) ACTIONTYPE="";
	String ACTIONCODE =request.getParameter("ACTIONCODE");
	if (ACTIONCODE==null) ACTIONCODE="";
	String CUSTOMERNO= request.getParameter("CUSTOMERNO");
	if (CUSTOMERNO==null) CUSTOMERNO="";
	String CUSTOMERID= request.getParameter("CUSTOMERID");
	if (CUSTOMERID==null)
	{
		CUSTOMERID="";
		if (ACTIONTYPE.equals("")) ACTIONTYPE="NEW";
	}
	else
	{
		if (ACTIONTYPE.equals("")) ACTIONTYPE="MODIFY";
	}
	String CUSTOMERNAME = request.getParameter("CUSTOMERNAME");
	if (CUSTOMERNAME==null) CUSTOMERNAME="";
	String SCUSTOMER = request.getParameter("SCUSTOMER");
	if (SCUSTOMER==null) SCUSTOMER="";
	String EDIID = request.getParameter("EDIID");
	if (EDIID==null) EDIID="";
	String SUPPLIERID = request.getParameter("SUPPLIERID");
	if (SUPPLIERID==null) SUPPLIERID="";
	String SALESAREANO = request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String SALESCONTACT = request.getParameter("SALESCONTACT");
	if (SALESCONTACT==null) SALESCONTACT="";
	String REGION = request.getParameter("REGION");
	if (REGION==null) REGION="";
	String INACTIVEDATE = request.getParameter("INACTIVEDATE");
	if (INACTIVEDATE==null) INACTIVEDATE="";
	String UPDATEDBY = request.getParameter("UPDATEDBY");
	if (UPDATEDBY==null) UPDATEDBY = UserName;
	String UPDATEDATE = request.getParameter("UPDATEDATE");
	if (UPDATEDATE==null) UPDATEDATE =dateBean.getYearMonthDay();
	String SHIPTOID = request.getParameter("SHIPTOID");
	if (SHIPTOID==null) SHIPTOID="";
	String SHIPTO = request.getParameter("SHIPTO");
	if (SHIPTO==null) SHIPTO="";
	String sql="";
	boolean iFound = true;
	if (ACTIONTYPE.equals("MODIFY") && ACTIONCODE.equals(""))
	{
		try
		{
			sql = " select a.customer_id,c.customer_number,a.customer_name, a.cust_shortname, to_char(a.inactive_date,'yyyymmdd') inactive_date,"+
                  " a.edi_cust_acct, a.sales_contact, a.sales_area_no,"+
                  " a.ship_to_site_id, a.region1, a.customer_id, a.cust_tscno,"+
                  " a.last_updated_by, a.last_update_date ,b.address1 from tsc_edi_customer a"+
			      ",(SELECT b.CUST_ACCOUNT_ID, a.site_use_id,d.address1 FROM hz_cust_site_uses_all a,HZ_CUST_ACCT_SITES_ALL b,hz_party_sites c,hz_locations d"+
                  " where  a.cust_acct_site_id = b.cust_acct_site_id AND b.party_site_id = c.party_site_id AND c.location_id =d.location_id AND a.site_use_code='SHIP_TO' and a.STATUS='A') b,ar_customers c"+
				  " where a.CUSTOMER_ID='"+CUSTOMERID+"' and a.customer_id = b.CUST_ACCOUNT_ID and a.SHIP_TO_SITE_ID=b.site_use_id and a.customer_id=c.customer_id";
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);  
			if (rs.next())
			{
				CUSTOMERNO = rs.getString("CUSTOMER_NUMBER");
				if (CUSTOMERNO==null) CUSTOMERNO="";
				CUSTOMERNAME = rs.getString("CUSTOMER_NAME");
				if (CUSTOMERNAME==null) CUSTOMERNAME="";
				SCUSTOMER = rs.getString("CUST_SHORTNAME");
				if (SCUSTOMER==null) SCUSTOMER="";
				EDIID = rs.getString("EDI_CUST_ACCT");
				if (EDIID==null) EDIID="";
				SUPPLIERID = rs.getString("CUST_TSCNO");
				if (SUPPLIERID==null) SUPPLIERID="";
				SALESAREANO = rs.getString("SALES_AREA_NO");
				if (SALESAREANO==null) SALESAREANO="";
				SALESCONTACT = rs.getString("SALES_CONTACT");
				if (SALESCONTACT==null) SALESCONTACT="";
				REGION = rs.getString("REGION1");
				if (REGION==null) REGION="";
				INACTIVEDATE = rs.getString("INACTIVE_DATE");
				if (INACTIVEDATE==null) INACTIVEDATE="";
				SHIPTOID = rs.getString("SHIP_TO_SITE_ID");
				if (SHIPTOID==null) SHIPTOID="";
				SHIPTO = rs.getString("ADDRESS1");
				if (SHIPTO==null) SHIPTO="";
			}
			else
			{
				iFound =false;
			}
			rs.close();
			statement.close();		
		}
		catch(Exception e)
		{
			out.println("Exception1:"+e.getMessage());
		}
		if (!iFound)
		{
		%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料!!請重新確認,謝謝!");
			document.MYFORM.action='../jsp/TSCEDICustomerQuery.jsp';
			document.MYFORM.submit();
		</script>
		<%
		}
	}
	else if (ACTIONCODE.equals("SAVE"))
	{
		try
		{
			if (ACTIONTYPE.equals("NEW"))
			{
				sql = " select 1 from tsc_edi_customer a where a.CUSTOMER_ID='"+CUSTOMERID+"' ";
				Statement statement=con.createStatement();
				ResultSet rs=statement.executeQuery(sql);  
				if (rs.next())
				{
					iFound = true;		
				}
				else
				{
					iFound = false;
				}
				statement.close();
				rs.close();
				
				if (iFound)
				{
				%>
				<script language="JavaScript" type="text/JavaScript">
					alert("此客戶已存在,不允許重新新增!!");
				</script>
				<%
				}
				else
				{
					sql = " insert into tsc_edi_customer(customer_name, customer_id,cust_shortname, inactive_date,edi_cust_acct, sales_contact, sales_area_no,ship_to_site_id,region1,cust_tscno,last_updated_by, last_update_date)"+
						  " values(?,?,?,to_date(?,'yyyymmdd'),?,?,?,?,?,?,?,sysdate)";
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,CUSTOMERNAME);
					pstmt.setString(2,CUSTOMERID);
					pstmt.setString(3,SCUSTOMER);
					pstmt.setString(4,INACTIVEDATE);
					pstmt.setString(5,EDIID);
					pstmt.setString(6,SALESCONTACT);
					pstmt.setString(7,SALESAREANO);
					pstmt.setString(8,SHIPTOID);
					pstmt.setString(9,REGION);
					pstmt.setString(10,SUPPLIERID);
					pstmt.setString(11,UPDATEDBY);
					pstmt.executeQuery();
					con.commit();
						
					out.println("<script language = 'JavaScript'>");
					out.println("alert('資料新增成功!');");
					out.println("</script>");
					
					CUSTOMERNO="";
					CUSTOMERID="";
					CUSTOMERNAME="";
					SCUSTOMER="";
					EDIID="";
					SUPPLIERID="";
					SALESAREANO="";
					SALESCONTACT="";
					REGION="";
					INACTIVEDATE="";
					SHIPTOID="";
					SHIPTO="";
				}				
			}
			else if (ACTIONTYPE.equals("MODIFY"))
			{
				sql = " update tsc_edi_customer"+
					  " set cust_shortname=?"+
					  ",inactive_date=to_date(?,'yyyymmdd')"+
					  ",edi_cust_acct=?"+
					  ",sales_contact=?"+
					  ",sales_area_no=?"+
					  ",ship_to_site_id=?"+
					  ",region1=?"+
					  ",cust_tscno=?"+
					  ",last_updated_by=?"+
					  ",last_update_date=sysdate"+
					  " where CUSTOMER_ID=?";
				//out.println(sql);
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,SCUSTOMER);
				pstmt.setString(2,INACTIVEDATE);
				pstmt.setString(3,EDIID);
				pstmt.setString(4,SALESCONTACT);
				pstmt.setString(5,SALESAREANO);
				pstmt.setString(6,SHIPTOID);
				pstmt.setString(7,REGION);
				pstmt.setString(8,SUPPLIERID);
				pstmt.setString(9,UPDATEDBY);
				pstmt.setString(10,CUSTOMERID);
				pstmt.executeQuery();
				con.commit();

				out.println("<script language = 'JavaScript'>");
				out.println("alert('資料更新成功!');");
				out.println("document.MYFORM.action='../jsp/TSCEDICustomerQuery.jsp'");
				out.println("document.MYFORM.submit();");
				out.println("</script>");
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println(e.getMessage());
			out.println("<script language='javascript' type='text/JavaScript'>alert('資料儲存失敗,請速洽系統管理人員,謝謝!');</script>");
		}		
	}
%>
<table width="70%"A align="center">
	<tr>
		<td align="center"><font style="font-size:22px;color:#2F5AC1"><strong>EDI客戶資料<%=(ACTIONTYPE.equals("NEW")?"新增":"修改")%></strong></font></td>
	</tr>
	<tr>
		<td align="right"><A HREF="TSCEDICustomerQuery.jsp">回上頁</A></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#99CC66" bordercolorlight="#999999" bordercolordark="#99CC66">
				<tr>
 					<td bgcolor="#D8DEA9">RFQ業務區:</td>
					<td>
					<%		 
					try
					{  
						Statement statement=con.createStatement();
						sql = "select SALES_AREA_NO,SALES_AREA_NO||'('||SALES_AREA_NAME||')' from ORADDMAN.TSSALES_AREA  where SALES_AREA_NO > 0  Order by 1";
						ResultSet rs=statement.executeQuery(sql);	
						out.println("<select NAME='SALESAREANO' class='style1' tabindex='1' onChange='setSubmit1("+'"'+"../jsp/TSCEDICustomerModify.jsp?ACTIONCODE=REFRESH"+'"'+")'>");				  			  
						out.println("<OPTION VALUE=-->--");     
						while (rs.next())
						{            
							String s1=(String)rs.getString(1); 
							String s2=(String)rs.getString(2); 
							if (s1.equals(SALESAREANO)) 
							{		   					   
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
							} 
							else 
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}        
						 } 
						 out.println("</select>"); 
						 rs.close();   
						 statement.close(); 
					} 
					catch (Exception e)
					{
						out.println("Exception2:"+e.getMessage());
					}
			 
					%>
					<td bgcolor="#D8DEA9">業務窗口:</td>
					<td>
					<%
					try
					{  
						Statement statement=con.createStatement();
						sql = "select b.username,b.username FROM oraddman.tsrecperson a,oraddman.wsuser b where TSSALEAREANO='"+SALESAREANO+"' and a.username = b.username  and b.lockflag='N' order by 1";
						ResultSet rs=statement.executeQuery(sql);	
						out.println("<select NAME='SALESCONTACT' class='style1'>");				  			  
						out.println("<OPTION VALUE=-->--");     
						while (rs.next())
						{            
							String s1=(String)rs.getString(1); 
							String s2=(String)rs.getString(2); 
							if (s1.equals(SALESCONTACT)) 
							{		   					   
								out.println("<OPTION VALUE='"+s1+"' SELECTED>"+s2); 					                                
							} 
							else 
							{
								out.println("<OPTION VALUE='"+s1+"'>"+s2);
							}        
						 } 
						 out.println("</select>"); 
						 rs.close();   
						 statement.close(); 
					} 
					catch (Exception e)
					{
						out.println("Exception3:"+e.getMessage());
					}
					%>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">客戶名稱:</td>
					<td><input class="style1" type="button" name="btncust" value=".." <%=(ACTIONTYPE.equals("NEW")?"":"disabled")%> onClick="setCustInfoFind(this.form.CUSTOMERNO.value,this.form.CUSTOMERNAME.value,this.form.SALESAREANO.value)"><input class="style1" type="text" name="CUSTOMERNO" value="<%=CUSTOMERNO%>" size="5"><input class="style1" type="text" name="CUSTOMERNAME" value="<%=CUSTOMERNAME%>" size="40"><input class="style1" type="hidden" name="CUSTOMERID" value="<%=CUSTOMERID%>" size="5"></td>
					<td bgcolor="#D8DEA9">客戶簡稱:</td>
					<td><input class="style1" type="text" name="SCUSTOMER" value="<%=SCUSTOMER%>"  size="20"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">EDI識別碼:</td>
					<td><input class="style1" type="text" name="EDIID" value="<%=EDIID%>"></td>
					<td bgcolor="#D8DEA9">供應商代碼(台半):</td>
					<td><input class="style1" type="text" name="SUPPLIERID" value="<%=SUPPLIERID%>"  size="20"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">出貨地址:</td>
					<td colspan="3"><input class="style1" type="button" name="btnshipto" value=".." onClick="subWindowShipToFind('SHIP_TO',this.form.CUSTOMERID.value,this.form.SALESAREANO.value)"><input type="text" class="style1" name="SHIPTOID" value="<%=SHIPTOID%>" size="5" onKeyDown="return (event.keyCode!=8);" readonly><input type="text" class="style1" name="SHIPTO" value="<%=SHIPTO%>" size="80" onKeyDown="return (event.keyCode!=8);" readonly></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">地區別:</td>
					<td><input class="style1" type="text" name="REGION"  value="<%=REGION%>"></td>
					<td  bgcolor="#D8DEA9">停用日期:</td>
					<td><input class="style1" type="text" name="INACTIVEDATE" value="<%=INACTIVEDATE%>" onKeyDown="return (event.keyCode==8 || event.keyCode==46);"  size="20"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORM.INACTIVEDATE);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">異動人員:</td>
					<td><input class="style1" type="text" name="UPDATEDBY" value="<%=UPDATEDBY%>" onKeyDown="return (event.keyCode!=8);" readonly></td>
					<td bgcolor="#D8DEA9">異動日期:</td>
					<td><input class="style1" type="text" name="UPDATEDATE" value="<%=UPDATEDATE%>" onKeyDown="return (event.keyCode!=8);"  size="20" readonly></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center"><input type="button" name="save" value="儲存" onClick="setSubmit('../jsp/TSCEDICustomerModify.jsp?ACTIONCODE=SAVE')">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="abort" value="離開" onClick='setClose("../jsp/TSCEDICustomerQuery.jsp")'></td>
	</tr>
</table>
<input type="hidden" name="ACTIONCODE" value="<%=ACTIONCODE%>">
<input type="hidden" name="ACTIONTYPE" value="<%=ACTIONTYPE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
