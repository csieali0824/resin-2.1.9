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
function setSubmit(URL)
{ 
	if (document.MYFORM.SALESAREANO.value==null || document.MYFORM.SALESAREANO.value=="")
	{
		alert("Please choose Sales Region!!");
		document.MYFORM.SALESAREANO.focus();
		return false;
	}
	if (document.MYFORM.CustName.value==null || document.MYFORM.CustName.value=="")
	{
		alert("Please enter Customer Name!!");
		document.MYFORM.CustName.focus();
		return false;
	}
	if (document.MYFORM.EdiAddrCode.value==null || document.MYFORM.EdiAddrCode.value=="")
	{
		alert("Please enter EDI Address Code!!");
		document.MYFORM.EdiAddrCode.focus();
		return false;
	}
	if (document.MYFORM.EdiCustCode.value==null || document.MYFORM.EdiCustCode.value=="")
	{
		alert("Please enter EDI Customer Code!!");
		document.MYFORM.EdiCustCode.focus();
		return false;
	}	
	if (document.MYFORM.ErpCustNo.value==null || document.MYFORM.ErpCustNo.value=="")
	{
		alert("Please enter ERP Customer Number!!");
		document.MYFORM.ErpCustNo.focus();
		return false;
	}	
	if (document.MYFORM.Level1.value==null || document.MYFORM.Level1value=="" || document.MYFORM.Level1.value=="--")
	{
		alert("Please enter Level1 of ftp server route!!");
		document.MYFORM.Level1.focus();
		return false;
	}
	document.MYFORM.save1.disabled=true;
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
	if (confirm("Are you sure to exit this form?"))
	{
		location.href=URL;
	}
}
</script>
<STYLE TYPE='text/css'>  
  BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TEXT      { font-family: Tahoma,Georgia; font-size: 12px } 
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 12px ;table-layout:fixed; word-break :break-all}
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  .style1   { font-family: Tahoma,Georgia: font-size:12px}
</STYLE>
<title>TSCC EDI客戶基本資料維護</title>
</head>
<body>
<br>
<FORM NAME="MYFORM" ACTION="../jsp/TSCCEDICustomerModify.jsp" METHOD="POST"> 
<div id="showimage" style="position:absolute; visibility:hidden; z-index:65535; top: 260px; left: 500px; width: 370px; height: 50px;"> 
  <br>
  <table width="350" height="50" border="1" align="center" cellpadding="5" cellspacing="0" bordercolorlight="#CCFFCC" bordercolordark="#336600">
    <tr>
    <td height="70" bgcolor="#CCCC99"  align="center"><font color="#003399" face="Tahoma,Georgia" size="+2">Transaction is processing,please wait.....</font> <BR>
      <DIV ID="blockDiv" STYLE="visibility:hidden;position:absolute; width:5px; height:5px; clip:rect(0px 5px 5px 0px); background-color:#567886; layer-background-color:#567886; display=''; left: 50px;"></div>
	</td>
  </tr>
</table>
</div>
<div id='alpha' class='hidden' style='width:0%;height:0;position:absolute;top:0;left:0;background:#000;filter:alpha(opacity=30);-moz-opacity:0.3;z-index:0;'></div>
<%
	String edi_cust_seq= request.getParameter("edi_cust_seq");
	if (edi_cust_seq==null) edi_cust_seq="";
	String ACTIONTYPE =request.getParameter("ACTIONTYPE");
	if (ACTIONTYPE==null) ACTIONTYPE="";
	String ACTIONCODE =request.getParameter("ACTIONCODE");
	if (ACTIONCODE==null) ACTIONCODE="";
	String SALESAREANO= request.getParameter("SALESAREANO");
	if (SALESAREANO==null) SALESAREANO="";
	String CustName= request.getParameter("CustName");
	if (CustName==null) CustName="";
	String EdiAddrCode = request.getParameter("EdiAddrCode");
	if (EdiAddrCode==null) EdiAddrCode="";
	String EdiAddrDesc = request.getParameter("EdiAddrDesc");
	if (EdiAddrDesc==null) EdiAddrDesc="";
	String EdiCustCode = request.getParameter("EdiCustCode");
	if (EdiCustCode==null) EdiCustCode="";
	String ErpCustNo = request.getParameter("ErpCustNo");
	if (ErpCustNo==null) ErpCustNo="";
	String ErpCustName = request.getParameter("ErpCustName");
	if (ErpCustName==null) ErpCustName="";
	String Level1 = request.getParameter("Level1");
	if (Level1==null) Level1="";
	String Level2 = request.getParameter("Level2");
	if (Level2==null) Level2="";
	String Level3 = request.getParameter("Level3");
	if (Level3==null) Level3="";
	String Level21 = request.getParameter("Level21");
	if (Level21==null) Level21="";
	String Level31 = request.getParameter("Level31");
	if (Level31==null) Level31="";
	String InactiveDate = request.getParameter("InactiveDate");
	if (InactiveDate==null) InactiveDate="";
	String sql="";
	boolean iFound = true;
	if (ACTIONTYPE.equals("MODIFY") && ACTIONCODE.equals(""))
	{
		try
		{
			sql = " select a.edi_cust_seq, a.sales_region, a.cust_name, a.edi_address_code,"+
                  " a.edi_address_desc, a.edi_cust_code, a.erp_cust_number,"+
                  //" REGEXP_SUBSTR(a.ftp_server_route, '[^\\]+', 1, 1) level1,"+
				  //" REGEXP_SUBSTR(a.ftp_server_route, '[^\\]+', 1, 2) level2,"+
				  " a.ftp_server_route,a.delfor_folder_name,a.desadv_folder_name,a.created_by, a.creation_date,"+
                  " a.last_updated_by, a.last_update_date,"+
				  " to_char(a.inactive_date,'yyyymmdd') inactive_date ,b.customer_name,a.delfor_backup_folder_name,a.desadv_backup_folder_name "+
				  " from edi.tscc_edi_customers a,ar_customers b"+
                  " where a.erp_cust_number=b.customer_number(+)"+
				  " and a.edi_cust_seq="+edi_cust_seq+"";
			//out.println(sql);
			Statement statement=con.createStatement();
			ResultSet rs=statement.executeQuery(sql);  
			if (rs.next())
			{
				SALESAREANO=rs.getString("sales_region");
                CustName=rs.getString("cust_name");
                EdiAddrCode=rs.getString("edi_address_code");
                EdiAddrDesc=rs.getString("edi_address_desc");
                EdiCustCode=rs.getString("edi_cust_code");
                ErpCustNo=rs.getString("erp_cust_number");
                ErpCustName=rs.getString("customer_name");
                Level1=rs.getString("ftp_server_route");
				Level2=rs.getString("delfor_folder_name");
				Level3=rs.getString("desadv_folder_name");
				Level21=rs.getString("delfor_backup_folder_name");
				Level31=rs.getString("desadv_backup_folder_name");
				InactiveDate=rs.getString("inactive_date");
				if (InactiveDate==null) InactiveDate="";
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
			alert("Data not found,Please check!");
			document.MYFORM.action='../jsp/TSCCEDICustomerQuery.jsp';
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
				sql = " select 1 from tscc_edi_customers a where a.ERP_CUST_NUMBER='"+ErpCustNo+"' ";
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
					alert("This ERP Customer duplicate!!");
				</script>
				<%
				}
				else
				{
					sql = "insert into tscc_edi_customers"+
					      "(edi_cust_seq"+
					      ",sales_region"+
						  ",cust_name"+
						  ",edi_address_code"+
						  ",edi_address_desc"+
						  ",edi_cust_code"+
						  ",erp_cust_number"+
						  ",ftp_server_route"+
						  ",delfor_folder_name"+
						  ",desadv_folder_name"+
						  ",delfor_backup_folder_name"+
						  ",desadv_backup_folder_name"+
						  ",created_by"+
						  ",creation_date"+
						  ",last_updated_by"+
						  ",last_update_date"+
						  ",inactive_date)"+
						  " values"+
						  "((select nvl(max(edi_cust_seq),0)+1 from tscc_edi_customers) "+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",sysdate"+
						  ",to_date(?,'yyyymmdd'))";
					PreparedStatement pstmt=con.prepareStatement(sql);
					pstmt.setString(1,SALESAREANO);
					pstmt.setString(2,CustName);
					pstmt.setString(3,EdiAddrCode);
					pstmt.setString(4,EdiAddrDesc);
					pstmt.setString(5,EdiCustCode);
					pstmt.setString(6,ErpCustNo);
					pstmt.setString(7,Level1);
					pstmt.setString(8,Level2);
					pstmt.setString(9,Level3);
					pstmt.setString(10,Level21);
					pstmt.setString(11,Level31);
					pstmt.setString(12,UserName);
					pstmt.setString(13,UserName);
					pstmt.setString(14,InactiveDate);
					pstmt.executeQuery();
					con.commit();
						
					out.println("<script language = 'JavaScript'>");
					out.println("alert('Insert Successfully!');");
					out.println("</script>");
					
					SALESAREANO="";CustName="";EdiAddrCode="";EdiAddrDesc="";EdiCustCode="";ErpCustNo="";ErpCustName="";Level1="";Level2="";Level21="";Level3="";Level31="";InactiveDate="";
				}				
			}
			else if (ACTIONTYPE.equals("MODIFY"))
			{
				sql = " update tscc_edi_customers"+
					  " set sales_region=?"+
						  ",cust_name=?"+
						  ",edi_address_code=?"+
						  ",edi_address_desc=?"+
						  ",edi_cust_code=?"+
						  ",erp_cust_number=?"+
						  ",ftp_server_route=?"+
						  ",last_updated_by=?"+
						  ",last_update_date=sysdate"+
						  ",inactive_date=to_date(?,'yyyymmdd')"+
						  ",delfor_folder_name=?"+
						  ",desadv_folder_name=?"+
						  ",delfor_backup_folder_name=?"+
						  ",desadv_backup_folder_name=?"+
					      " where edi_cust_seq=?";
				//out.println(sql);
				//out.println(SALESAREANO);
				//out.println(CustName);
				//out.println(EdiAddrCode);
				//out.println(EdiAddrDesc);
				//out.println(EdiCustCode);
				//out.println(ErpCustNo);
				//out.println(Level1+"\\"+Level2);
				//out.println(InactiveDate);
				//out.println(edi_cust_seq);
				PreparedStatement pstmt=con.prepareStatement(sql);
				pstmt.setString(1,SALESAREANO);
				pstmt.setString(2,CustName);
				pstmt.setString(3,EdiAddrCode);
				pstmt.setString(4,EdiAddrDesc);
				pstmt.setString(5,EdiCustCode);
				pstmt.setString(6,ErpCustNo);
				pstmt.setString(7,Level1+"\\"+Level2);
				pstmt.setString(8,UserName);
				pstmt.setString(9,InactiveDate);
				pstmt.setString(10,Level2);
				pstmt.setString(11,Level3);
				pstmt.setString(12,Level21);
				pstmt.setString(13,Level31);
				pstmt.setString(14,edi_cust_seq);
				pstmt.executeQuery();
				con.commit();

				out.println("<script language = 'JavaScript'>");
				out.println("alert('Update Successfully!');");
				out.println("document.MYFORM.action='../jsp/TSCCEDICustomerQuery.jsp'");
				out.println("document.MYFORM.submit();");
				out.println("</script>");
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println(e.getMessage());
			out.println("<script language='javascript' type='text/JavaScript'>alert('Action fail,Please contact to system maintenance team!');</script>");
		}		
	}
%>
<table width="60%"A align="center">
	<tr>
		<td align="center"><font style="font-size:22px;color:#2F5AC1"><strong>EDI Customer Info <%=(ACTIONTYPE.equals("NEW")?"Add New":"Edit")%></strong></font></td>
	</tr>
	<tr>
		<td align="right"><A HREF="TSCCEDICustomerQuery.jsp">To Previous Page</A></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="1" cellpadding="1" cellspacing="0" bordercolor="#99CC66" bordercolorlight="#999999" bordercolordark="#99CC66">
				<tr>
 					<td bgcolor="#D8DEA9" width="30%">Sales Region:</td>
					<td>
					<%		 
					try
					{  
						Statement statement=con.createStatement();
						sql = "SELECT distinct GROUP_NAME ,GROUP_NAME FROM TSC_OM_GROUP d WHERE GROUP_NAME LIKE 'TSCC%' AND (END_DATE IS NULL OR END_DATE > TRUNC(SYSDATE)) order by 1";
						ResultSet rs=statement.executeQuery(sql);	
						out.println("<select NAME='SALESAREANO' class='style1'>");				  			  
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
					</td>
				</tr>
				<tr>
					<td bgcolor="#D8DEA9">Customer Name:</td>
					<td><input type="text" name="CustName" value="<%=CustName%>" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">EDI Address Code:</td>
					<td><input type="text" name="EdiAddrCode" value="<%=EdiAddrCode%>" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>					
					<td bgcolor="#D8DEA9">EDI Address Desc:</td>
					<td><input type="text" name="EdiAddrDesc" value="<%=EdiAddrDesc%>" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">EDI Customer Code:</td>
					<td><input type="text" name="EdiCustCode" value="<%=EdiCustCode%>" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
					<td bgcolor="#D8DEA9">ERP Customer Number:</td>
					<td><input type="text" name="ErpCustNo" value="<%=ErpCustNo%>" size="5" style="font-family: Tahoma,Georgia"><input type="text" name="ErpCustName" value="<%=ErpCustName%>" style="font-family: Tahoma,Georgia" size="40"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">FTP Server Route:</td>
					<td><input type="text" name="Level1" value="<%=Level1%>" size="35" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">DELFOR Folder:</td>
					<td><input type="text" name="Level2" value="<%=Level2%>" size="20" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">DESADV Folder:</td>
					<td><input type="text" name="Level3" value="<%=Level3%>" size="20" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">Backup DELFOR Folder:</td>
					<td><input type="text" name="Level21" value="<%=Level21%>" size="20" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">Backup DESADV Folder:</td>
					<td><input type="text" name="Level31" value="<%=Level31%>" size="20" style="font-family: Tahoma,Georgia"></td>
				</tr>
				<tr>
 					<td bgcolor="#D8DEA9">Inactive Date:</td>
					<td><input type="text" name="InactiveDate" value="<%=InactiveDate%>" onKeyDown="return (event.keyCode==8 || event.keyCode==46);"  size="10" style="font-family: Tahoma,Georgia"><A href="javascript:void(0)" onClick="gfPop.fPopCalendar(document.MYFORM.InactiveDate);return false;"><img name="popcal" border="0" src="../image/calbtn.gif"></A></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td align="center"><input type="button" name="save1" value="Save" onClick="setSubmit('../jsp/TSCCEDICustomerModify.jsp?ACTIONCODE=SAVE&edi_cust_seq=<%=edi_cust_seq%>')" style="font-family: Tahoma,Georgia">&nbsp;&nbsp;&nbsp;&nbsp;<input type="button" name="abort" value="Exit" onClick='setClose("../jsp/TSCCEDICustomerQuery.jsp")' style="font-family: Tahoma,Georgia"></td>
	</tr>
</table>
<input type="hidden" name="ACTIONCODE" value="<%=ACTIONCODE%>">
<input type="hidden" name="ACTIONTYPE" value="<%=ACTIONTYPE%>">
<input type="hidden" name="edi_cust_seq" value="<%=edi_cust_seq%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
