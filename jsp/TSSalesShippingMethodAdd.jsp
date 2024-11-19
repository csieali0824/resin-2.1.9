<!-- 20151119 Peggy,add TSC_PROD_FAMILY column-->
<!-- 20160130 Peggy,add No Wafer Lead Time column-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="QryAllChkBoxEditBean,ComboBoxBean,ArrayComboBoxBean,DateBean,Array2DimensionInputBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="shipTypecomboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="qryAllChkBoxEditBean" scope="session" class="QryAllChkBoxEditBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="arrayIQCDocumentInputBean" scope="session" class="Array2DimensionInputBean"/> 
<jsp:useBean id="arrayIQCSearchBean" scope="session" class="Array2DimensionInputBean"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
window.onbeforeunload = bunload; 
function bunload()  
{  
	if (event.clientY < 0)  
    {  
		if (document.MYFORMD.STATUS.value=="NEW")
		{
			window.opener.MYFORM.submit();
		}
		else
		{	
			window.opener.document.getElementById("alpha").style.width="0";
			window.opener.document.getElementById("alpha").style.height="0";
		}
		window.close();				
    }  
} 
function setCancel()
{
	if (document.MYFORMD.STATUS.value=="NEW")
	{
		window.opener.MYFORM.submit();
	}
	else
	{
		window.opener.document.getElementById("alpha").style.width="0";
		window.opener.document.getElementById("alpha").style.height="0";
	}
	self.close();
}
function setSubmit(URL)
{ 
	if (document.MYFORMD.SALES_REGION.value=="" || document.MYFORMD.SALES_REGION.value=="--")
	{
		alert("請選擇業務區!!");
		document.MYFORMD.SALES_REGION.focus();
		return false;
	}
	if (document.MYFORMD.TSC_FAMILY.value=="" || document.MYFORMD.TSC_FAMILY.value=="--")
	{
		alert("請選擇TSC Family!!");
		document.MYFORMD.TSC_FAMILY.focus();
		return false;
	}	
	if (document.MYFORMD.TSC_PACKAGE.value=="" || document.MYFORMD.TSC_PACKAGE.value=="--")
	{
		alert("請選擇TSC Package!!");
		document.MYFORMD.TSC_PACKAGE.focus();
		return false;
	}
	if ((document.MYFORMD.AIR_FROM.value=="" || document.MYFORMD.AIR_FROM.value==null) && (document.MYFORMD.AIR_TO.value=="" || document.MYFORMD.AIR_TO.value==null) && (document.MYFORMD.SEA_FROM.value=="" || document.MYFORMD.SEA_FROM.value==null) && (document.MYFORMD.SEA_TO.value=="" || document.MYFORMD.SEA_TO.value==null))
	{
		alert("請輸入出貨方式天數!!");
		return false;
	}
	if (document.MYFORMD.AIR_TO.value !="999" && document.MYFORMD.SEA_TO.value !="999") 
	{
		alert("出貨方式其中一個結束天數必須=999!!");
		return false;
	}	
	if (document.MYFORMD.AIR_FROM.value !="0" && document.MYFORMD.SEA_FROM.value !="0") 
	{
		alert("出貨方式其中一個起始天數必須=0!!");
		return false;
	}	
	if ((document.MYFORMD.AIR_FROM.value =="0" && document.MYFORMD.AIR_TO.value =="0") || (document.MYFORMD.SEA_FROM.value =="0" && document.MYFORMD.SEA_TO.value =="0")) 
	{
		alert("出貨方式起訖天數不可同時為0!!");
		return false;
	}		
	if (document.MYFORMD.AIR_TO.value !="" && document.MYFORMD.AIR_TO.value !="999" && document.MYFORMD.SEA_FROM.value !="") 
	{
		if (eval(document.MYFORMD.AIR_TO.value) + 1 != eval(document.MYFORMD.SEA_FROM.value))
		{
			alert("海運起始天數必須=空運結束天數+1!!");
			return false;
		}
	}		
	
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL+"&SALES_REGION="+document.MYFORMD.SALES_REGION.value+"&TSC_FAMILY="+document.MYFORMD.TSC_FAMILY.value+"&TSC_PACKAGE="+document.MYFORMD.TSC_PACKAGE.value+"&ITEM_DESC="+document.MYFORMD.ITEM_DESC.value;
 	document.MYFORMD.submit();
}
function setClear()
{
	document.MYFORMD.TSC_FAMILY.value="";
	document.MYFORMD.TSC_PACKAGE.value="";
	document.MYFORMD.ITEM_DESC.value="";
	document.MYFORMD.AIR_FROM.value="";
	document.MYFORMD.AIR_TO.value="";
	document.MYFORMD.SEA_FROM.value="";
	document.MYFORMD.SEA_TO.value="";
}
function region_change()
{
	if (document.MYFORMD.STATUS.value =="UPD")
	{
		return false;
	}
	else
	{
	 	document.MYFORMD.submit();	
	}
}
</script>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 12px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 12px } 
  TD        { font-family: Tahoma,Georgia;font-size: 12px ;word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 12px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  .board    { background-color: #D6DBE7}
  .text     { font-family: Tahoma,Georgia;  font-size: 12px }
</STYLE>
<title>Lead Time Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSSalesShippingMethodAdd.jsp" METHOD="POST"> 
<%
String ID = request.getParameter("ID");
if (ID == null) ID="";
String STATUS = request.getParameter("STATUS");
if (STATUS == null) STATUS = "";
String SALES_REGION = request.getParameter("SALES_REGION");
if (SALES_REGION==null) SALES_REGION="";
String TSC_FAMILY = request.getParameter("TSC_FAMILY");
if (TSC_FAMILY==null) TSC_FAMILY="";
String TSC_PACKAGE = request.getParameter("TSC_PACKAGE");
if (TSC_PACKAGE==null) TSC_PACKAGE="";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null ||ITEM_DESC.equals("null")) ITEM_DESC="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String ORIG_SALES_REGION = request.getParameter("ORIG_SALES_REGION");
if (ORIG_SALES_REGION==null) ORIG_SALES_REGION="";
String ORIG_TSC_FAMILY = request.getParameter("ORIG_TSC_FAMILY");
if (ORIG_TSC_FAMILY==null) ORIG_TSC_FAMILY="";
String ORIG_TSC_PACKAGE = request.getParameter("ORIG_TSC_PACKAGE");
if (ORIG_TSC_PACKAGE==null) ORIG_TSC_PACKAGE="";
String ORIG_ITEM_DESC = request.getParameter("ORIG_ITEM_DESC");
if (ORIG_ITEM_DESC==null) ORIG_ITEM_DESC="";
String ORIG_AIR_FROM = request.getParameter("ORIG_AIR_FROM");
if (ORIG_AIR_FROM ==null) ORIG_AIR_FROM ="";
String ORIG_SEA_FROM = request.getParameter("ORIG_SEA_FROM");
if (ORIG_SEA_FROM ==null) ORIG_SEA_FROM ="";
String AIR = request.getParameter("AIR");
if (AIR==null) AIR="";
String AIR_FROM = request.getParameter("AIR_FROM");
if (AIR_FROM==null) AIR_FROM="";
String AIR_TO = request.getParameter("AIR_TO");
if (AIR_TO==null) AIR_TO="";
String SEA = request.getParameter("SEA");
if (SEA==null) SEA="";
String SEA_FROM = request.getParameter("SEA_FROM");
if (SEA_FROM==null) SEA_FROM="";
String SEA_TO = request.getParameter("SEA_TO");
if (SEA_TO==null) SEA_TO="";
if (AIR.equals(""))
{
	if (SALES_REGION.equals("001"))
	{
		AIR="AIR(C)";
	}
	else if (SALES_REGION.equals("008"))
	{
		AIR="AIR(UC)";
	}
}
if (SEA.equals(""))
{
	if (SALES_REGION.equals("001"))
	{
		SEA="SEA(C)";
	}
	else if (SALES_REGION.equals("008"))
	{
		SEA="SEA(UC)";
	}
}
String sql ="",strExist="",strNoFound="";
int row_cnt=0;

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();

try
{  
	if (STATUS.equals("UPD"))
	{
		if (ACODE.equals(""))
		{
			sql = " SELECT a.tsc_package, a.tsc_family, a.freight, a.sdays, a.edays,"+
                  " a.sales_area_no, a.tsc_product_name"+
                  " FROM oraddman.tsce_air_sea_freight_rule a"+
				  " where SALES_AREA_NO=? "+
				  " and TSC_FAMILY=? "+
				  " and TSC_PACKAGE=? "+
				  " and nvl(tsc_product_name,'xxx') =nvl(?,'xxx')"+
				  " order by a.freight";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,SALES_REGION);
			statement.setString(2,TSC_FAMILY);
			statement.setString(3,TSC_PACKAGE);
			statement.setString(4,ITEM_DESC);
			ResultSet rs=statement.executeQuery();
			while (rs.next())
			{
				SALES_REGION=rs.getString("sales_area_no");
				ORIG_SALES_REGION=SALES_REGION;
				TSC_FAMILY=rs.getString("TSC_FAMILY");
				ORIG_TSC_FAMILY=TSC_FAMILY;
				TSC_PACKAGE=rs.getString("TSC_PACKAGE");
				ORIG_TSC_PACKAGE=TSC_PACKAGE;
				ITEM_DESC=rs.getString("tsc_product_name");
				if (ITEM_DESC==null) ITEM_DESC="";
				ORIG_ITEM_DESC=ITEM_DESC;
				if (rs.getString("freight").equals(AIR))
				{
					AIR_FROM=rs.getString("sdays");
					AIR_TO=rs.getString("edays"); 
					ORIG_AIR_FROM=AIR_FROM;
				}
				else if (rs.getString("freight").equals(SEA))
				{
					SEA_FROM=rs.getString("sdays");
					SEA_TO=rs.getString("edays"); 				
					ORIG_SEA_FROM=SEA_FROM;
				}
				row_cnt++;
			}
			rs.close();
			statement.close();

			if (row_cnt==0)
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("查無資料,請重新確認,謝謝!");
					setCancel();
				</script>
			<%				
			}
		}
		else if (ACODE.equals("SAVE"))
		{
			strExist="";
			if (!ORIG_SALES_REGION.equals(SALES_REGION) || !ORIG_TSC_FAMILY.equals(TSC_FAMILY) || !ORIG_TSC_PACKAGE.equals(TSC_PACKAGE) || !ORIG_ITEM_DESC.equals(ITEM_DESC))
			{
				sql = " SELECT 1 FROM oraddman.tsce_air_sea_freight_rule a "+
					  " where SALES_AREA_NO=? and TSC_FAMILY=? and TSC_PACKAGE=? and nvl(tsc_product_name,'xxx') =nvl(?,'xxx')";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,SALES_REGION);
				statement.setString(2,TSC_FAMILY);
				statement.setString(3,TSC_PACKAGE);
				statement.setString(4,ITEM_DESC);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{	
					strExist="Y";
				}	
				rs.close();
				statement.close();
			}
		}
	}
	
	if (ACODE.equals("SAVE") && !ITEM_DESC.equals("") && !ORIG_ITEM_DESC.equals(ITEM_DESC))
	{
		sql = " select distinct 1 from inv.mtl_system_items_b where description =?";
		PreparedStatement statement = con.prepareStatement(sql);
		statement.setString(1,ITEM_DESC);
		ResultSet rs=statement.executeQuery();
		if (!rs.next())
		{	
			strNoFound="Y";
		}	
		rs.close();
		statement.close();
	}
%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<input type="hidden" name="ORIG_SALES_REGION" value="<%=ORIG_SALES_REGION%>">
<input type="hidden" name="ORIG_TSC_PACKAGE" value="<%=ORIG_TSC_PACKAGE%>">
<input type="hidden" name="ORIG_TSC_FAMILY" value="<%=ORIG_TSC_FAMILY%>">
<input type="hidden" name="ORIG_ITEM_DESC" value="<%=ORIG_ITEM_DESC%>">
<input type="hidden" name="ORIG_AIR_FROM" value="<%=ORIG_AIR_FROM%>">
<input type="hidden" name="ORIG_SEA_FROM" value="<%=ORIG_SEA_FROM%>">
<table align="center" width="80%">
	<tr>
		<td align="center">
			<strong><font style="font-family:細明體;font-size:20px;color:#006666">業務區出貨方式</font><font style="font-size:20px;color:#006666">維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="1" cellspacing="1" bordercolorlight="#999999" bordercolordark="#99CC99" bordercolor="#cccccc">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>業務區：</td>
					<td nowrap>
					<%
					try
					{
						sql = " select distinct ta.sales_area_no,ta.sales_area_no || ta.sales_area_name sales_name "+
                              " from oraddman.tssales_area ta,oraddman.tsrecperson tp,oraddman.wsuser ws"+
                              " where tp.username=ws.username"+
                              " and tp.tssaleareano=ta.sales_area_no";
						if (UserRoles.indexOf("admin")<0)
						{				  
							sql += " and ws.username='"+UserName+"'";
						}	
						if (STATUS.equals("UPD"))
						{
							sql += " and ta.sales_area_no='"+SALES_REGION+"'";
						}
						sql += " order by ta.sales_area_no";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(SALES_REGION);
						comboBoxBean.setFieldName("SALES_REGION");	
						comboBoxBean.setFontName("Tahoma,Georgia");  
						comboBoxBean.setOnChangeJS("region_change()") ;
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Family：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Family' AND DISABLE_DATE IS NULL ";
						if (STATUS.equals("UPD"))
						{
							sql += " and SEGMENT1='"+TSC_FAMILY+"'";
						}
						sql += "order by SEGMENT1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_FAMILY);
						comboBoxBean.setFieldName("TSC_FAMILY");	
						comboBoxBean.setFontName("Tahoma,Georgia");  
						comboBoxBean.setOnChangeJS("");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>						
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Package：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='Package' AND DISABLE_DATE IS NULL ";
						if (STATUS.equals("UPD"))
						{
							sql += " and SEGMENT1='"+TSC_PACKAGE+"'";
						}
						sql += "order by SEGMENT1";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSC_PACKAGE);
						comboBoxBean.setFieldName("TSC_PACKAGE");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						comboBoxBean.setOnChangeJS("");
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();     	 		
					}
					catch(Exception e)
					{
						out.println("<font color='red'>error</font>");
					}
					%>					
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>型號：</td>
					<td nowrap><input type="text" name="ITEM_DESC" value="<%=ITEM_DESC%>" style="font-family: Tahoma,Georgia; font-size:12px" size="20" <%=(STATUS.equals("UPD")?" readonly":"")%>)></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Shipping Method ：</td>
					<td nowrap><input type="text" name="AIR" value="<%=AIR%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" readonly>
					&nbsp;&nbsp;&nbsp;Day From:<input type="text" name="AIR_FROM" value="<%=AIR_FROM%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">			
					To:<input type="text" name="AIR_TO" value="<%=AIR_TO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">			
					<BR>
					<input type="text" name="SEA" value="<%=SEA%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" readonly>
					&nbsp;&nbsp;&nbsp;Day From:<input type="text" name="SEA_FROM" value="<%=SEA_FROM%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">			
					To:<input type="text" name="SEA_TO" value="<%=SEA_TO%>" style="font-family: Tahoma,Georgia; font-size:12px" size="10" onKeyPress="return (event.keyCode>=48 && event.keyCode <=57)">								
					</td>
				</tr>	
			</table>
		</td>
	</tr>
	<tr>
		<td>註:起訖天數欄位值若為空白,表示刪除該筆運輸方式設定</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSSalesShippingMethodAdd.jsp?ACODE=SAVE&STATUS=<%=STATUS%>")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick='setCancel()' value="關閉視窗" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		try
		{
			if (strExist.equals("Y"))
			{
				throw new Exception("資料已存在,請重新確認,謝謝!");	
			}
			//if (strNoFound.equals("Y"))
			//{
			//	throw new Exception("查無型號:"+ITEM_DESC+",請重新確認,謝謝!");	
			//}
			
			if (STATUS.equals("UPD"))
			{
				if (!AIR_FROM.equals(""))
				{
					if (ORIG_AIR_FROM.equals(""))
					{
						sql = " insert into oraddman.tsce_air_sea_freight_rule "+
							  " (tsc_package"+
							  ", tsc_family"+
							  ", freight"+
							  ", sdays"+
							  ", edays"+
							  ", creation_date"+
							  ", sales_area_no"+
							  ", tsc_product_name"+
							  ", tsc_prod_family"+
							  ", created_by"+
							  ", last_update_date"+
							  ", last_updated_by"+
							  " )"+
							  " values( "+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",SYSDATE"+
							  ",?"+
							  ",?"+
							  ",NULL"+
							  ",?"+
							  ",SYSDATE"+
							  ",?"+
							  " )";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,TSC_PACKAGE);	
						st1.setString(2,TSC_FAMILY);
						st1.setString(3,AIR); 
						st1.setString(4,AIR_FROM); 
						st1.setString(5,AIR_TO);
						st1.setString(6,SALES_REGION);  
						st1.setString(7,ITEM_DESC);  
						st1.setString(8,UserName);  
						st1.setString(9,UserName); 
						st1.executeQuery();
						st1.close();
					
					}
					else
					{
						sql= " update oraddman.tsce_air_sea_freight_rule"+
							 " SET SDAYS=?"+
							 ",EDAYS=?"+
							 ",LAST_UPDATED_BY=?"+
							 ",LAST_UPDATE_DATE=sysdate"+
							 " where TSC_PACKAGE=?"+
							 " AND TSC_FAMILY=?"+
							 " AND SALES_AREA_NO= ?"+
							 " AND NVL(TSC_PRODUCT_NAME,'XX')=NVL(?,'XX')"+
							 " AND FREIGHT=?";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,AIR_FROM); 
						st1.setString(2,AIR_TO);
						st1.setString(3,UserName);
						st1.setString(4,TSC_PACKAGE);
						st1.setString(5,TSC_FAMILY);
						st1.setString(6,SALES_REGION);	
						st1.setString(7,ITEM_DESC);
						st1.setString(8,AIR);
						st1.executeQuery();
						st1.close();
					}
				}
				else
				{
					sql = " delete oraddman.tsce_air_sea_freight_rule"+
						 " where TSC_PACKAGE=?"+
						 " AND TSC_FAMILY=?"+
						 " AND FREIGHT=?"+
						 " AND SALES_AREA_NO= ?"+
						 " AND NVL(TSC_PRODUCT_NAME,'XX')=NVL(?,'XX')";		
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,TSC_PACKAGE);
					st1.setString(2,TSC_FAMILY);
					st1.setString(3,AIR);					
					st1.setString(4,SALES_REGION);	
					st1.setString(5,ITEM_DESC);
					st1.executeQuery();
					st1.close();
				}
				
				if (!SEA_FROM.equals(""))
				{
					if (ORIG_SEA_FROM.equals(""))
					{	
						sql = " insert into oraddman.tsce_air_sea_freight_rule "+
							  " (tsc_package"+
							  ", tsc_family"+
							  ", freight"+
							  ", sdays"+
							  ", edays"+
							  ", creation_date"+
							  ", sales_area_no"+
							  ", tsc_product_name"+
							  ", tsc_prod_family"+
							  ", created_by"+
							  ", last_update_date"+
							  ", last_updated_by"+
							  " )"+
							  " values( "+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",?"+
							  ",SYSDATE"+
							  ",?"+
							  ",?"+
							  ",NULL"+
							  ",?"+
							  ",SYSDATE"+
							  ",?"+
							  " )";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,TSC_PACKAGE);	
						st1.setString(2,TSC_FAMILY);
						st1.setString(3,SEA); 
						st1.setString(4,SEA_FROM); 
						st1.setString(5,SEA_TO);
						st1.setString(6,SALES_REGION);  
						st1.setString(7,ITEM_DESC);  
						st1.setString(8,UserName);  
						st1.setString(9,UserName); 
						st1.executeQuery();
						st1.close();
					}
					else
					{		
						sql= " update oraddman.tsce_air_sea_freight_rule"+
							 " set SDAYS=?"+
							 ",EDAYS=?"+
							 ",LAST_UPDATED_BY=?"+
							 ",LAST_UPDATE_DATE=sysdate"+
							 " where TSC_PACKAGE=?"+
							 " AND TSC_FAMILY=?"+
							 " AND SALES_AREA_NO= ?"+
							 " AND NVL(TSC_PRODUCT_NAME,'XX')=NVL(?,'XX')"+
							 " AND FREIGHT=?";
						//out.println(sql);
						PreparedStatement st1 = con.prepareStatement(sql);
						st1.setString(1,SEA_FROM); 
						st1.setString(2,SEA_TO);
						st1.setString(3,UserName);
						st1.setString(4,TSC_PACKAGE);
						st1.setString(5,TSC_FAMILY);
						st1.setString(6,SALES_REGION);	
						st1.setString(7,ITEM_DESC);
						st1.setString(8,SEA);
						st1.executeQuery();
						st1.close();
					}
				}
				else
				{
					sql = " delete oraddman.tsce_air_sea_freight_rule"+
						 " where TSC_PACKAGE=?"+
						 " AND TSC_FAMILY=?"+
						 " AND FREIGHT=?"+
						 " AND SALES_AREA_NO= ?"+
						 " AND NVL(TSC_PRODUCT_NAME,'XX')=NVL(?,'XX')";		
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,TSC_PACKAGE);
					st1.setString(2,TSC_FAMILY);
					st1.setString(3,SEA);
					st1.setString(4,SALES_REGION);	
					st1.setString(5,ITEM_DESC);
					st1.executeQuery();
					st1.close();
						 			
				}
				con.commit();	  		
				
			%>
				<script language = "JavaScript">
					alert('修改成功!');  
					window.opener.MYFORM.submit();
					setCancel();
				</script>
			<%				
			}
			else
			{
				if (!AIR_FROM.equals(""))
				{			
					sql = " insert into oraddman.tsce_air_sea_freight_rule "+
						  " (tsc_package"+
						  ", tsc_family"+
						  ", freight"+
						  ", sdays"+
						  ", edays"+
						  ", creation_date"+
						  ", sales_area_no"+
						  ", tsc_product_name"+
						  ", tsc_prod_family"+
						  ", created_by"+
						  ", last_update_date"+
						  ", last_updated_by"+
						  " )"+
						  " values( "+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",SYSDATE"+
						  ",?"+
						  ",?"+
						  ",NULL"+
						  ",?"+
						  ",SYSDATE"+
						  ",?"+
						  " )";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,TSC_PACKAGE);	
					st1.setString(2,TSC_FAMILY);
					st1.setString(3,AIR); 
					st1.setString(4,AIR_FROM); 
					st1.setString(5,AIR_TO);
					st1.setString(6,SALES_REGION);  
					st1.setString(7,ITEM_DESC);  
					st1.setString(8,UserName);  
					st1.setString(9,UserName); 
					st1.executeQuery();
					st1.close();
				}
				
				if (!SEA_FROM.equals(""))
				{	
					sql = " insert into oraddman.tsce_air_sea_freight_rule "+
						  " (tsc_package"+
						  ", tsc_family"+
						  ", freight"+
						  ", sdays"+
						  ", edays"+
						  ", creation_date"+
						  ", sales_area_no"+
						  ", tsc_product_name"+
						  ", tsc_prod_family"+
						  ", created_by"+
						  ", last_update_date"+
						  ", last_updated_by"+
						  " )"+
						  " values( "+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",SYSDATE"+
						  ",?"+
						  ",?"+
						  ",NULL"+
						  ",?"+
						  ",SYSDATE"+
						  ",?"+
						  " )";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,TSC_PACKAGE);	
					st1.setString(2,TSC_FAMILY);
					st1.setString(3,SEA); 
					st1.setString(4,SEA_FROM); 
					st1.setString(5,SEA_TO);
					st1.setString(6,SALES_REGION);  
					st1.setString(7,ITEM_DESC);  
					st1.setString(8,UserName);  
					st1.setString(9,UserName); 
					st1.executeQuery();
					st1.close();
				}
				con.commit();			
								
				out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
		%>
				<script language="javascript">
					setClear();
				</script>
		<%
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div align='center' style='color:#ff0000'>交易異常:"+e.getMessage()+"</div>");
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>Exception1:"+e.getMessage()+"</DIV>");
}
%>
</FORM>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
