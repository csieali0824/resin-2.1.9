<!--20170704 Peggy,新增reel_qty欄位-->
<!--20180620 Peggy,add TSC_PARTNO欄位-->
<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*,java.text.*,java.lang.*" %>
<!--=============以下區段為安全認證機制==========-->
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<!--=============以下區段為取得連結池==========-->
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean"%>
<!--=================================-->
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=big5" />
<script language="JavaScript" type="text/JavaScript">
function setCancel()
{
	self.close();
}
function setSubmit(URL)
{ 
	if (document.MYFORMD.TSCPROD.value==""||document.MYFORMD.TSCPROD.value=="--")
	{
		document.MYFORMD.TSCPROD.focus();
		alert("請輸入PROD GROUP!!");
		return false;
	}
	if (document.MYFORMD.INNERQTY.value!="" && isNaN(document.MYFORMD.INNERQTY.value))
	{
		document.MYFORMD.INNERQTY.focus();
		alert("Inner Qty 必須是數字型態!!");
		return false;
	}	
	if (isNaN(document.MYFORMD.CARTONQTY.value))
	{
		document.MYFORMD.CARTONQTY.focus();
		alert("Carton Qty 必須是數字型態!!");
		return false;
	}
	if (document.MYFORMD.CARTONSIZE.value=="")
	{
		document.MYFORMD.CARTONSIZE.focus();
		alert("請輸入Carton Size!!");
		return false;
	}	
	if (document.MYFORMD.GW.value!="" && isNaN(document.MYFORMD.GW.value))
	{
		document.MYFORMD.GW.focus();
		alert("Gross Weight 必須是數字型態!!");
		return false;
	}
	if (document.MYFORMD.NW.value!="" && isNaN(document.MYFORMD.NW.value))
	{
		document.MYFORMD.NW.focus();
		alert("Net Weight 必須是數字型態!!");
		return false;
	}		
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL;
 	document.MYFORMD.submit();
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
<title>產品材積資料維護</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSCIlanShippingBoxSetup.jsp" METHOD="POST"> 
<%
String ACTIONMODE= request.getParameter("ACTIONMODE");
if (ACTIONMODE==null) ACTIONMODE="ADD";
String TSCPROD=request.getParameter("TSCPROD");
if (TSCPROD==null) TSCPROD="";
String PACKAGE= request.getParameter("PACKAGE");
if (PACKAGE==null) PACKAGE="";
String PACKING =request.getParameter("PACKING");
if (PACKING==null) PACKING="";
String ORIG_PROD_GROUP = request.getParameter("ORIG_PROD_GROUP");
if (ORIG_PROD_GROUP==null) ORIG_PROD_GROUP="";
String ORIG_PACKAGE= request.getParameter("ORIG_PACKAGE");
if (ORIG_PACKAGE==null) ORIG_PACKAGE="";
String ORIG_PACKING =request.getParameter("ORIG_PACKING");
if (ORIG_PACKING==null) ORIG_PACKING="";
String ACODE = request.getParameter("ACODE");
if (ACODE == null) ACODE="";
String INNERQTY = request.getParameter("INNERQTY");
if (INNERQTY==null) INNERQTY="";
String CARTONQTY = request.getParameter("CARTONQTY");
if (CARTONQTY==null) CARTONQTY="";
String CARTONSIZE = request.getParameter("CARTONSIZE");
if (CARTONSIZE==null) CARTONSIZE="";
String GW = request.getParameter("GW");
if (GW==null) GW="0";
String NW = request.getParameter("NW");
if (NW==null) NW="0";
String ITEM_DESC = request.getParameter("ITEM_DESC");
if (ITEM_DESC==null) ITEM_DESC="";
String ATTRIBUTE1 = request.getParameter("ATTRIBUTE1");
if (ATTRIBUTE1==null) ATTRIBUTE1="";
String INT_TYPE = request.getParameter("INT_TYPE");
if (INT_TYPE==null) INT_TYPE="TSC";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String ID= request.getParameter("ID");
if (ID==null) ID="";
String REELQTY = request.getParameter("REELQTY");
if (REELQTY==null) REELQTY="";
String sql ="",UPDCODE="MODIFY",def_flag="";

String sql1="alter SESSION set NLS_LANGUAGE = 'AMERICAN' ";     
PreparedStatement pstmt1=con.prepareStatement(sql1);
pstmt1.executeUpdate(); 
pstmt1.close();
	
if (ACTIONMODE.equals(UPDCODE) && ACODE.equals(""))
{  
	sql = " select a.tsc_prod_group, a.tsc_package, a.packing_code, a.def_flag,"+
              " a.inner_qty, a.carton_qty, a.carton_size, a.carton_no, a.gw,"+
              " a.nw, a.creation_date, a.creation_by, a.attribute1, a.attribute2,"+
              " a.attribute3, a.int_type,  a.status,"+
              " a.last_updated_by, to_char(a.last_update_date,'yyyy-mm-dd hh24:mi') last_update_date,"+
			  " a.reel_qty,a.TSC_PARTNO"+
			  " from tsc_item_packing_master a"+
			  " where A.ROWID=?";
	//out.println(sql);
	PreparedStatement statement = con.prepareStatement(sql);
	statement.setString(1,ID);
	ResultSet rs=statement.executeQuery();
	if (rs.next())
	{
		INT_TYPE = rs.getString("INT_TYPE");
		TSCPROD = rs.getString("tsc_prod_group");
		PACKAGE = rs.getString("tsc_package");
		PACKING = rs.getString("packing_code");
		INNERQTY =rs.getString("INNER_QTY");
		if (INNERQTY==null) INNERQTY="";
		CARTONQTY=rs.getString("CARTON_QTY");
		if (CARTONQTY==null) CARTONQTY="";
		CARTONSIZE=rs.getString("CARTON_SIZE");
		if (CARTONSIZE==null) CARTONSIZE="";
		NW=rs.getString("NW");
		if (NW==null) NW="0";
		GW=rs.getString("GW");
		if (GW==null) GW="0";
		ITEM_DESC=rs.getString("TSC_PARTNO");
		if (ITEM_DESC==null) ITEM_DESC="";
		ATTRIBUTE1=rs.getString("ATTRIBUTE1");
		if (ATTRIBUTE1==null) ATTRIBUTE1="";
		STATUS=rs.getString("STATUS");
		REELQTY =rs.getString("REEL_QTY");
		if (REELQTY==null) REELQTY="";
		ORIG_PROD_GROUP=TSCPROD;
		ORIG_PACKAGE = PACKAGE;
		ORIG_PACKING = PACKING;
	}
	else
	{
	%>
		<script language="JavaScript" type="text/JavaScript">
			alert("查無資料,請重新確認,謝謝!");
			this.window.close();
		</script>
	<%				
	}
	rs.close();
	statement.close();
}
%>
<input type="hidden" name="ID" value="<%=ID%>">
<table align="center" width="70%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">產品材積資料<%=(ACTIONMODE.equals("MODIFY")?"維護":"新增")%></font></strong>
		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Prod Group：</td>
					<td nowrap>	
					<%
					try
					{
						sql = " SELECT DISTINCT SEGMENT1  fieldvalue,SEGMENT1 FROM MTL_CATEGORIES_V  WHERE STRUCTURE_NAME='TSC_PROD_GROUP' AND DISABLE_DATE IS NULL order by SEGMENT1 ";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						comboBoxBean.setRs(rs);
						comboBoxBean.setSelection(TSCPROD);
						comboBoxBean.setFieldName("TSCPROD");	
						comboBoxBean.setFontName("Tahoma,Georgia");   
						out.println(comboBoxBean.getRsString());
						rs.close();   
						statement.close();  
					}
					catch(Exception e){out.println(sql+"error!!");}
					%>
					<input type="hidden" name="ORIG_PROD_GROUP" value="<%=ORIG_PROD_GROUP%>"><input type="hidden" name="INT_TYPE" value="<%=INT_TYPE%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>TSC Package：</td>
					<td nowrap><input type="text" name="PACKAGE" style="font-family: Tahoma,Georgia;font-size:12px"  value="<%=PACKAGE%>"><input type="hidden" name="ORIG_PACKAGE" value="<%=ORIG_PACKAGE%>"><div id="div1" style="font-weight:BOLD;color:#FF0000"></div></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Packing Code：</td>
					<td nowrap><input type="text" name="PACKING" style="font-family: Tahoma,Georgia;font-size:12px"  value="<%=PACKING%>"><input type="hidden" name="ORIG_PACKING" value="<%=ORIG_PACKING%>"><div id="div2" style="font-weight:BOLD;color:#FF0000"></div></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Reel Qty(PCS)：</td>
					<td nowrap><input type="text" name="REELQTY" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=REELQTY%>"  onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Inner Qty(PCS)：</td>
					<td nowrap><input type="text" name="INNERQTY" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=INNERQTY%>"  onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Carton Qty(PCS)：</td>
					<td nowrap><input type="text" name="CARTONQTY" style="text-align:right;font-family: Tahoma,Georgia;font-size:12px"  value="<%=CARTONQTY%>"  onKeyPress="return (event.keyCode >= 48 && event.keyCode <=57)"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Carton Size：</td>
					<td nowrap><input type="text" name="CARTONSIZE" style="text-align:left;font-family: Tahoma,Georgia;font-size:12px" value="<%=CARTONSIZE%>"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Net Weight：</td>
					<td nowrap><input type="TEXT" name="NW"  style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(NW))%>" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>Gross Weight：</td>
					<td nowrap><input type="TEXT" name="GW"  style="text-align:right;font-family: Tahoma,Georgia;font-size:12px" value="<%=(new DecimalFormat("######0.####")).format(Float.parseFloat(GW))%>" onKeypress="return ((event.keyCode >= 48 && event.keyCode <=57) || event.keyCode == 46)"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>品名：</td>
					<td nowrap><input type="TEXT" name="ITEM_DESC" style="font-family: Tahoma,Georgia;font-size:12px" value="<%=ITEM_DESC%>"><div id="div3" style="font-weight:BOLD;color:#FF0000"></div></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>備註：</td>
					<td nowrap><input type="TEXT" name="ATTRIBUTE1" style="font-family: Tahoma,Georgia;font-size:12px" value="<%=ATTRIBUTE1%>"><div id="div3" style="font-weight:BOLD;color:#FF0000"></div></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap>狀態：</td>
					<td nowrap>		
					<select NAME="STATUS" style="Tahoma,Georgia; font-size: 12px ">
					<OPTION VALUE="Y" <%if (STATUS.equals("Y") || STATUS.equals("")) out.println("selected");%>>啟用</OPTION>
					<OPTION VALUE="N" <%if (STATUS.equals("N")) out.println("selected");%>>停用</OPTION>
					</select></td>
				</tr>																								
			</table>
		</td>
	</tr>
	<tr>
		<td><div id="div5" style="font-weight:BOLD;color:#FF0000"></div></td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input name="btnSubmit" type=button onClick='setSubmit("../jsp/TSCIlanShippingBoxSetup.jsp?ACODE=SAVE&ID=<%=java.net.URLEncoder.encode(ID)%>")' value="Submit" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input name="btnCancel" type=button onClick='setCancel()' value="Cancel" style="font-family:'Tahoma,Georgia';font-size:12px">
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
		int err_cnt =0;
		if (ACTIONMODE.equals(UPDCODE))
		{  	
			//檢查品名是否存在
			if (!ITEM_DESC.equals(""))
			{
				sql = " select 1 from inv.mtl_system_items_b a where description=?";
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,ITEM_DESC);
				ResultSet rs=statement.executeQuery();
				if (!rs.next())
				{
					err_cnt ++;
				%>
					<script language="javascript">
						document.getElementById("div3").innerHTML ="Item not found!!";
						document.MYFORMD.btnSubmit.disabled =false;
						document.MYFORMD.btnCancel.disabled =false;
					</script>		
				<%			
				}
				rs.close();
				statement.close();
			}
			if (err_cnt ==0)
			{	
				sql = " update apps.tsc_item_packing_master a"+
					  " set STATUS=?"+
					  ",INNER_QTY=?"+
					  ",CARTON_QTY=?"+
					  ",CARTON_SIZE=?"+
					  ",GW=?"+
					  ",NW=?"+
					  ",ATTRIBUTE1=?"+
					  ",LAST_UPDATED_BY=?"+
					  ",LAST_UPDATE_DATE=sysdate"+
					  ",TSC_PACKAGE=?"+
					  ",PACKING_CODE=?"+
					  ",REEL_QTY=?"+
					  ",TSC_PARTNO=?"+
					  " where ROWID=?";
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,STATUS);
				pstmtDt.setString(2,INNERQTY);
				pstmtDt.setString(3,CARTONQTY);
				pstmtDt.setString(4,CARTONSIZE);
				pstmtDt.setString(5,GW);
				pstmtDt.setString(6,NW);
				pstmtDt.setString(7,ATTRIBUTE1);
				pstmtDt.setString(8,UserName);
				pstmtDt.setString(9,PACKAGE);
				pstmtDt.setString(10,PACKING);
				pstmtDt.setString(11,REELQTY);
				pstmtDt.setString(12,ITEM_DESC);
				pstmtDt.setString(13,ID);
				pstmtDt.executeUpdate();
				pstmtDt.close();
				out.println("<script language = 'JavaScript'>");
				out.println("alert('修改成功!')");
				out.println("this.window.close();");
				out.println("window.opener.document.MYFORM.submit();");
				out.println("</script>");
			}
		}
		else
		{
			//檢查package是否存在
			sql = " SELECT 1 FROM MTL_CATEGORIES_V "+
                  " WHERE STRUCTURE_NAME='Package'"+
                  " AND DISABLE_DATE IS NULL "+
				  " and SEGMENT1=?";
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,PACKAGE);
			ResultSet rs=statement.executeQuery();		
			if (!rs.next())
			{
				err_cnt ++;
			%>
				<script language="javascript">
					document.getElementById("div1").innerHTML ="TSC Package not found!!";
					document.MYFORMD.btnSubmit.disabled =false;
					document.MYFORMD.btnCancel.disabled =false;
				</script>		
			<%			
			}
			rs.close();
			statement.close();
			
			//檢查packing是否存在								 
			sql = " select 1 from (select case when (tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')='PMD' and substr(x.segment1,4,1)='G') then substr(x.segment1,9,2)||'G' when  ( tsc_om_category (x.inventory_item_id, x.organization_id, 'TSC_PROD_GROUP')<>'PMD' and substr(x.segment1,11,1)='1' ) then substr(x.segment1,9,2)||'G' else substr(x.segment1,9,2) end as tsc_package_code"+
                  " from inv.mtl_system_items_b x where x.organization_id=49 and length(x.segment1)>20 and x.segment1 not like 'OSP-%' and x.segment1 not like 'PK%' and x.segment1 not like 'SOP-%' and x.segment1 not like 'Opening%' and x.INVENTORY_ITEM_STATUS_CODE <> 'Inactive' and upper(x.description) NOT LIKE '%FAIRCHILD%' ) a"+
                  " where a.tsc_package_code=?";
			statement = con.prepareStatement(sql);
			statement.setString(1,PACKING);
			rs=statement.executeQuery();
			if (!rs.next())
			{
				err_cnt ++;
			%>
				<script language="javascript">
					document.getElementById("div2").innerHTML ="Packing Code not found!!";
					document.MYFORMD.btnSubmit.disabled =false;
					document.MYFORMD.btnCancel.disabled =false;
				</script>		
			<%			
			}
			rs.close();
			statement.close();
			
			//檢查品名是否存在
			if (!ITEM_DESC.equals(""))
			{
				sql = " select 1 from inv.mtl_system_items_b a where description=?";
				//out.println(sql);
				statement = con.prepareStatement(sql);
				statement.setString(1,ITEM_DESC);
				rs=statement.executeQuery();
				if (!rs.next())
				{
					err_cnt ++;
				%>
					<script language="javascript">
						document.getElementById("div3").innerHTML ="Item not found!!";
						document.MYFORMD.btnSubmit.disabled =false;
						document.MYFORMD.btnCancel.disabled =false;
					</script>		
				<%			
				}
				rs.close();
				statement.close();
			}			
			
			//檢查資料是否重覆
			sql = " select 1 from tsc_item_packing_master a"+
			      " where a.INT_TYPE=?"+
			      " and a.tsc_prod_group=?"+
			      " and a.tsc_package=?"+
			      " and a.packing_code=?"+
				  " and a.CARTON_QTY=?"+
				  " and a.org_id=?"+
				  " and nvl(a.ATTRIBUTE1,'012345')=nvl(?,'012345')";//add by Peggy 20140912
			statement = con.prepareStatement(sql);
			statement.setString(1,INT_TYPE);
			statement.setString(2,TSCPROD);
			statement.setString(3,PACKAGE);
			statement.setString(4,PACKING);
			statement.setString(5,CARTONQTY);
			statement.setString(6,"49");
			statement.setString(7,ITEM_DESC);
			rs=statement.executeQuery();
			if (rs.next())
			{
				err_cnt ++;
			%>
				<script language="javascript">
					document.getElementById("div5").innerHTML ="資料已存在，不允許重覆新增，請確認!!";
					document.MYFORMD.btnSubmit.disabled =false;
					document.MYFORMD.btnCancel.disabled =false;
				</script>		
			<%
			}
			rs.close();
			statement.close();

			if (err_cnt ==0)
			{
				//檢查TSC_PROD_GROUP+PACKAGE+PACKING CODE+ORGANIZATION ID是否已存在
				sql = " select 1 from tsc_item_packing_master a"+
					  " where a.INT_TYPE=?"+
					  " and a.tsc_prod_group=?"+
					  " and a.tsc_package=?"+
					  " and a.packing_code=?"+
					  " and a.org_id=?"+
					  " and nvl(a.ATTRIBUTE1,'012345')=nvl(?,'012345')";//add by Peggy 20140912
				statement = con.prepareStatement(sql);
				statement.setString(1,INT_TYPE);
				statement.setString(2,TSCPROD);
				statement.setString(3,PACKAGE);
				statement.setString(4,PACKING);
				statement.setString(5,"49");
				statement.setString(6,ITEM_DESC);
				rs=statement.executeQuery();
				if (rs.next())
				{
					def_flag="N";
				}	
				else
				{
					def_flag="Y";
				}
				rs.close();
				statement.close();					
				
				sql = " insert into apps.tsc_item_packing_master"+
					  "(tsc_prod_group,"+       //1
					  " tsc_package,"+          //2
					  " packing_code,"+         //3
					  " def_flag,"+             //4
					  " inner_qty,"+            //5
					  " carton_qty,"+           //6
					  " carton_size,"+          //7
					  " carton_no,"+            //8
					  " gw,"+                   //9
					  " nw,"+                   //10
					  " creation_date,"+        //11
					  " creation_by,"+          //12
					  " attribute1,"+           //13
					  " attribute2,"+           //14
					  " attribute3,"+           //15
					  " int_type,"+             //16
					  " vendor_id,"+            //17
					  " status,"+               //18
					  " last_updated_by,"+      //19
					  " last_update_date,"+     //20
					  " org_id,"+               //21
					  " reel_qty,"+             //22
					  " TSC_PARTNO)"+           //23
					  " values"+
					  " (?"+                    //1
					  " ,?"+                    //2
					  " ,?"+                    //3
					  " ,?"+                    //4
					  " ,?"+                    //5
					  " ,?"+                    //6
					  " ,?"+                    //7
					  " ,?"+                    //8
					  " ,?"+                    //9
					  " ,?"+                    //10
					  " ,SYSDATE"+              //11
					  " ,?"+                    //12
					  " ,?"+                    //13
					  " ,?"+                    //14
					  " ,?"+                    //15
					  " ,?"+                    //16
					  " ,?"+                    //17
					  " ,?"+                    //18
					  " ,?"+                    //19
					  " ,SYSDATE"+              //20
					  " ,?"+                    //21
					  " ,?"+                    //22
					  " ,?)";                   //23
				PreparedStatement pstmtDt=con.prepareStatement(sql);  
				pstmtDt.setString(1,TSCPROD);
				pstmtDt.setString(2,PACKAGE);
				pstmtDt.setString(3,PACKING);
				pstmtDt.setString(4,def_flag);
				pstmtDt.setString(5,INNERQTY);
				pstmtDt.setString(6,CARTONQTY);
				pstmtDt.setString(7,CARTONSIZE);
				pstmtDt.setString(8,"");
				pstmtDt.setString(9,GW);
				pstmtDt.setString(10,NW);
				pstmtDt.setString(11,UserName);
				pstmtDt.setString(12,ATTRIBUTE1);
				pstmtDt.setString(13,"");
				pstmtDt.setString(14,"");
				pstmtDt.setString(15,INT_TYPE);
				pstmtDt.setString(16,"");
				pstmtDt.setString(17,STATUS);
				pstmtDt.setString(18,UserName);
				pstmtDt.setString(19,"49");
				pstmtDt.setString(20,REELQTY);
				pstmtDt.setString(21,ITEM_DESC);
				pstmtDt.executeUpdate();
				pstmtDt.close();
				out.println("<script language = 'JavaScript'>");
				out.println("alert('新增成功!')");
				out.println("this.window.close();");
				out.println("window.opener.document.MYFORM.submit();");
				out.println("</script>");
			}
		}
	}
	catch(Exception e)
	{
		out.println("<div><font color='red'>動作失敗:"+e.getMessage()+",請洽系統管理人員!!</font></div>");
	}
}
%>
<input type="hidden" name="ACTIONMODE" value="<%=ACTIONMODE%>">
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<%@ include file="/jsp/include/MProcessStatusBarStop.jsp"%>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
