<!--20171024 Peggy,新增remarks欄位-->
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
	if (document.MYFORMD.LABEL_GROUP_NAME.value=="")
	{
		alert("請輸入標籤群組名稱!!");
		document.MYFORMD.LABEL_GROUP_NAME.focus();
		return false;
	}
	var LABEL_GROUP = "";
	var radioLength = document.MYFORMD.LABEL_GROUP.length;
	for(var i = 0; i < radioLength; i++) 
	{
		if ( document.MYFORMD.LABEL_GROUP[i].checked)
		{
			LABEL_GROUP = document.MYFORMD.LABEL_GROUP[i].value;
		}
	}	
	if (LABEL_GROUP=="")
	{
		alert("請輸入標籤名稱!!");
		document.MYFORMD.LABEL_GROUP.focus();
		return false;		
	}
	if (document.MYFORMD.EFFECTIVE_FROM.value !="" &&  document.MYFORMD.EFFECTIVE_TO.value!="" && eval(document.MYFORMD.EFFECTIVE_TO.value)<eval(document.MYFORMD.EFFECTIVE_FROM.value))
	{
		alert("啟用迄日必須大於等於啟用起日!!");
		document.MYFORMD.EFFECTIVE_TO.focus();
		return false;
	}			
	document.MYFORMD.btnSubmit.disabled =true;
	document.MYFORMD.btnCancel.disabled =true;
	document.MYFORMD.action=URL+"&LABEL_GROUP="+LABEL_GROUP;
 	document.MYFORMD.submit();
}
function setClear()
{
	document.MYFORMD.LABEL_GROUP_NAME.value="";
	document.MYFORMD.LABEL_GROUP_DESC.value="";
	document.MYFORMD.REMARKS.value="";
	document.MYFORMD.EFFECTIVE_FROM.value="";
	document.MYFORMD.EFFECTIVE_TO.value="";
	document.MYFORMD.LABEL_FORM_CODE.value="";
	document.MYFORMD.LABEL_FORM_VERSION.value="";	
	document.MYFORM.LABEL_WHERE_CONDITION.value="";
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
<title>TS Label Group Maintain</title>
</head>
<body>
<FORM NAME="MYFORMD" ACTION="../jsp/TSLabelGroupAdd.jsp" METHOD="POST"> 
<%
String LABEL_GROUP_CODE = request.getParameter("LABEL_GROUP_CODE");
if (LABEL_GROUP_CODE==null) LABEL_GROUP_CODE="";
String LABEL_GROUP_NAME = request.getParameter("LABEL_GROUP_NAME");
if (LABEL_GROUP_NAME==null) LABEL_GROUP_NAME="";
String LABEL_GROUP_DESC = request.getParameter("LABEL_GROUP_DESC");
if (LABEL_GROUP_DESC==null) LABEL_GROUP_DESC="";
String MODULE_CODE = request.getParameter("MODULE_CODE");
if (MODULE_CODE==null) MODULE_CODE="";
String EFFECTIVE_FROM = request.getParameter("EFFECTIVE_FROM");
if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
String EFFECTIVE_TO = request.getParameter("EFFECTIVE_TO");
if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
String LABEL_GROUP = request.getParameter("LABEL_GROUP");
if (LABEL_GROUP==null) LABEL_GROUP="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String REMARKS = request.getParameter("REMARKS"); //add by Peggy 20171024
if (REMARKS==null) REMARKS="";
String LABEL_FORM_CODE = request.getParameter("LABEL_FORM_CODE");
if (LABEL_FORM_CODE==null) LABEL_FORM_CODE="";
String LABEL_FORM_VERSION = request.getParameter("LABEL_FORM_VERSION");
if (LABEL_FORM_VERSION==null) LABEL_FORM_VERSION="";
String CUST_SHIPPING_MARKS = request.getParameter("CUST_SHIPPING_MARKS");
if (CUST_SHIPPING_MARKS==null) CUST_SHIPPING_MARKS="";
String TSC_PARTNO = request.getParameter("TSC_PARTNO");
if (TSC_PARTNO==null) TSC_PARTNO="";
String ERP_FUNC = request.getParameter("ERP_FUNC");
if (ERP_FUNC==null) ERP_FUNC="";
String OTHERS_RULE = request.getParameter("OTHERS_RULE");
if (OTHERS_RULE==null) OTHERS_RULE="";
String LABEL_WHERE_CONDITION=request.getParameter("LABEL_WHERE_CONDITION");
if (LABEL_WHERE_CONDITION==null) LABEL_WHERE_CONDITION="";

String sql ="",strExist="",strNoFound="";

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
			sql = " select distinct a.label_group_code,a.label_group_name, a.label_group_desc,a.label_group,"+
                  " to_char(a.effective_from_date,'yyyymmdd') effective_from_date, to_char(a.effective_to_date,'yyyymmdd') effective_to_date,a.remarks"+
				  " ,a.label_form_code, a.label_form_version"+
				  " ,a.label_where_condition"+  //add by Peggy 20240627
                  " from oraddman.ts_label_groups a "+
                  " where a.label_group_code=?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,LABEL_GROUP_CODE);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				LABEL_GROUP_NAME =rs.getString("LABEL_GROUP_NAME");
				LABEL_GROUP_DESC =rs.getString("LABEL_GROUP_DESC");
				LABEL_GROUP =rs.getString("LABEL_GROUP");
				//MODULE_CODE=rs.getString("module_code");
				EFFECTIVE_FROM=rs.getString("EFFECTIVE_FROM_DATE");
				if (EFFECTIVE_FROM==null) EFFECTIVE_FROM="";
				EFFECTIVE_TO=rs.getString("EFFECTIVE_TO_DATE");
				if (EFFECTIVE_TO==null) EFFECTIVE_TO="";
				REMARKS = rs.getString("REMARKS");
				if (REMARKS==null) REMARKS="";
				LABEL_FORM_CODE =rs.getString("LABEL_FORM_CODE");
				if (LABEL_FORM_CODE==null) LABEL_FORM_CODE="";
				LABEL_FORM_VERSION =rs.getString("LABEL_FORM_VERSION");
				if (LABEL_FORM_VERSION==null) LABEL_FORM_VERSION="";
				LABEL_WHERE_CONDITION=rs.getString("label_where_condition");
				if (LABEL_WHERE_CONDITION==null) LABEL_WHERE_CONDITION="";
				
 				/*sql = " SELECT a.cond_item , listagg(a.cond_rule,chr(13)) within group (order by  a.cond_item) cond_rule"+
                      " FROM oraddman.ts_label_group_conditions a"+
                      " WHERE a.label_group_code=?"+
                      " group by a.cond_item ";
				PreparedStatement statement1 = con.prepareStatement(sql);
				statement1.setString(1,LABEL_GROUP_CODE);
				ResultSet rs1=statement1.executeQuery();
				while (rs1.next())
				{
					 if (rs1.getString(1).equals("SHIPPING_MARKS"))
					 {
					 	CUST_SHIPPING_MARKS = rs1.getString(2);
					 }
					 else if (rs1.getString(1).equals("TSC_PARTNO"))
					 {	
					 	TSC_PARTNO = rs1.getString(2);
					 }
					 else if (rs1.getString(1).equals("ERP_FUNC"))
					 {	
					 	ERP_FUNC = rs1.getString(2);
					 }
					 else if (rs1.getString(1).equals("OTHERS"))
					 {	
					 	OTHERS_RULE = rs1.getString(2);
					 }
				}
				rs1.close();	
				statement1.close();		
				*/		  
				
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("查無資料,請重新確認,謝謝!");
					setCancel();
				</script>
			<%				
			}
			rs.close();
			statement.close();
		}
	}

%>
<input type="hidden" name="STATUS" value="<%=STATUS%>">
<table align="center" width="80%">
	<tr>
		<td align="center">
			<strong><font style="font-family:細明體;font-size:20px;color:#006666">標籤群組</font><font style="font-size:20px;color:#006666">維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">群組名稱</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_GROUP_NAME" value="<%=LABEL_GROUP_NAME%>" size="50" style="font-family: Tahoma,Georgia;"><input type="hidden" name="LABEL_GROUP_CODE" value="<%=LABEL_GROUP_CODE%>"></td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">群組說明</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_GROUP_DESC" value="<%=LABEL_GROUP_DESC%>" size="50" style="font-family: Tahoma,Georgia;"></td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">文件代碼</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_FORM_CODE" value="<%=LABEL_FORM_CODE%>" size="50" style="font-family: Tahoma,Georgia;"></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">文件版次</span>：</td>
					<td nowrap><INPUT TYPE="TEXT" name="LABEL_FORM_VERSION" value="<%=LABEL_FORM_VERSION%>" size="50" style="font-family: Tahoma,Georgia;"></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">備註</span>：</td>
					<td nowrap><textarea name="REMARKS" cols="80" rows="4" style="font-family: Tahoma,Georgia;"><%=REMARKS%></textarea></td>
				</tr>				
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">業務模組</span>：</td>
					<td nowrap>
					<%
					try
					{
						sql = " SELECT a.module_code,a.module_name,decode(b.label_group_code,null,'N','Y') exist_flag "+
						      " FROM oraddman.ts_label_modules a ,(select * from oraddman.ts_label_group_assignments where label_group_code='"+LABEL_GROUP_CODE+"') b "+
                              " where trunc(sysdate) between decode(a.effective_from_date,null,to_date('20010101','yyyymmdd'),trunc(a.effective_from_date)) and  decode(a.effective_to_date,null,to_date('20990101','yyyymmdd'),trunc(a.effective_to_date)) "+
                              " AND a.module_code = b.module_code(+)"+
                              " order by a.module_code";
						Statement statement=con.createStatement();
						ResultSet rs=statement.executeQuery(sql);
						//comboBoxBean.setRs(rs);
						//comboBoxBean.setSelection(MODULE_CODE);
						//comboBoxBean.setFieldName("MODULE_CODE");	
						//comboBoxBean.setFontName("Tahoma,Georgia");   
						//out.println(comboBoxBean.getRsString());
						while (rs.next())
						{
							out.println("<input type='checkbox' name='chk' value='"+rs.getString("module_code")+"' "+ (rs.getString("exist_flag").equals("Y")?"checked":"")+">"+rs.getString("module_name")+"");
						}
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
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">標籤群組</span>：</td>
					<td nowrap>
				    <input type="radio" name="LABEL_GROUP" value="TSC" <%=(LABEL_GROUP.equals("TSC")?"CHECKED":"")%>>TSC
				    &nbsp;&nbsp;&nbsp;&nbsp;
				    <input type="radio" name="LABEL_GROUP" value="CUST" <%=(LABEL_GROUP.equals("CUST")?"CHECKED":"")%>>CUSTOMER
					</td>
				</tr>
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">啟用起訖日</span>：</td>
					<td nowrap><input type="text" name="EFFECTIVE_FROM" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_FROM%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.EFFECTIVE_FROM);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					~<input type="text" name="EFFECTIVE_TO" style="font-family: Tahoma,Georgia;" value="<%=EFFECTIVE_TO%>" onKeypress="return event.keyCode >= 48 && event.keyCode <=57" size="12"><A href='javascript:void(0)' onclick='gfPop.fPopCalendar(document.MYFORMD.EFFECTIVE_TO);return false;'><img name='popcal' border='0' src='../image/calbtn.gif'></A>
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">Condition</span>：</td>
					<td nowrap>
					<textarea cols="80" rows="4" name="LABEL_WHERE_CONDITION" style="text-align:left;font-family:Arial" tabindex="20"><%=LABEL_WHERE_CONDITION%></textarea>
					</td>
				</tr>				
				<!--<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">客戶嘜頭</span>：</td>
					<td nowrap>
					<textarea cols="50" rows="4" name="CUST_SHIPPING_MARKS" style="text-align:left;font-family:Arial" tabindex="20"><%=CUST_SHIPPING_MARKS%></textarea>
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">品名</span>：</td>
					<td nowrap>
					<textarea cols="50" rows="4" name="TSC_PARTNO" style="text-align:left;font-family:Arial" tabindex="20"><%=TSC_PARTNO%></textarea>
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">ERP Function</span>：</td>
					<td nowrap>
					<textarea cols="50" rows="3" name="ERP_FUNC" style="text-align:left;font-family:Arial" tabindex="21"><%=ERP_FUNC%></textarea>
					</td>
				</tr>	
				<tr>
					<td width="35%" height="25" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">其他</span>：</td>
					<td nowrap>
					<textarea cols="50" rows="4" name="OTHERS_RULE" style="text-align:left;font-family:Arial" tabindex="22"><%=OTHERS_RULE%></textarea>
					</td>
				</tr>-->	
				
			</table>
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0">
  				<tr align=center>
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSLabelGroupAdd.jsp?STATUS=<%=STATUS%>&ACODE=SAVE")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
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
			if (STATUS.equals("UPD"))
			{
				sql = " select 1 from oraddman.ts_label_groups a "+
						  " where UPPER(a.label_group_name)=UPPER(?) and label_group_code <>?"+
						  " and label_form_code=?"+
						  " and label_form_version=?";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,LABEL_GROUP_NAME);
				statement.setString(2,LABEL_GROUP_CODE);
				statement.setString(3,LABEL_FORM_CODE);
				statement.setString(4,LABEL_FORM_VERSION);				
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{	
					throw new Exception("群組名稱已存在,不可重覆!");
				}
				else
				{			
					sql= " update oraddman.ts_label_groups  "+
						 " set  LABEL_GROUP_NAME=?"+
						 ",LABEL_GROUP_DESC=?"+
						 ",LABEL_GROUP=?"+
						 ",EFFECTIVE_FROM_DATE=to_date(?,'yyyymmdd')"+
						 ",EFFECTIVE_TO_DATE=to_date(?,'yyyymmdd')"+
						 ",LAST_UPDATED_BY=?"+
						 ",LAST_UPDATE_DATE=sysdate"+
						 ",REMARKS=?"+
						 ",LABEL_FORM_CODE=?"+
						 ",LABEL_FORM_VERSION=?"+
						 ",LABEL_WHERE_CONDITION=?"+
						 " where LABEL_GROUP_CODE=?";
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,LABEL_GROUP_NAME);
					st1.setString(2,LABEL_GROUP_DESC);
					st1.setString(3,LABEL_GROUP);
					st1.setString(4,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
					st1.setString(5,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
					st1.setString(6,UserName);
					st1.setString(7,REMARKS);  //add by Peggy 20171024
					st1.setString(8,LABEL_FORM_CODE);
					st1.setString(9,LABEL_FORM_VERSION);
					st1.setString(10,LABEL_WHERE_CONDITION);
					st1.setString(11,LABEL_GROUP_CODE);
					st1.executeQuery();
					st1.close();
				
					sql= " update oraddman.ts_label_group_assignments  "+
						 " set isactive_flag=?"+
						 ",LAST_UPDATED_BY=?"+
						 ",LAST_UPDATE_DATE=sysdate"+
						 " where LABEL_GROUP_CODE = ?";
					st1 = con.prepareStatement(sql);
					st1.setString(1,"N");
					st1.setString(2,UserName);
					st1.setString(3,LABEL_GROUP_CODE);
					st1.executeQuery();
					st1.close();				
				
					String chk[]= request.getParameterValues("chk");	
					if (chk.length >0)
					{
						for (int i=0; i< chk.length ;i++)
						{
							MODULE_CODE = chk[i];
				
							sql = " select 1 from oraddman.ts_label_group_assignments a "+
									  " where a.label_group_code=? and a.module_code=?";
							//out.println(sql);
							PreparedStatement statement1 = con.prepareStatement(sql);
							statement1.setString(1,LABEL_GROUP_CODE);
							statement1.setString(2,MODULE_CODE);
							ResultSet rs1=statement1.executeQuery();
							if (!rs1.next())
							{	
								sql= " insert into oraddman.ts_label_group_assignments  "+
									 " (label_group_code"+
									 ", module_code"+
									 ", isactive_flag"+
									 ", creation_date"+
									 ", created_by"+
									 ", last_update_date"+
									 ", last_updated_by) "+
									 " values(?"+
									 ",?"+
									 ",?"+
									 ",sysdate"+
									 ",?"+
									 ",sysdate"+
									 ",?)";
								st1 = con.prepareStatement(sql);
								st1.setString(1,LABEL_GROUP_CODE);
								st1.setString(2,MODULE_CODE); 
								st1.setString(3,"Y");
								st1.setString(4,UserName);
								st1.setString(5,UserName);
								st1.executeQuery();
								st1.close();						
							}
							else
							{			
								sql= " update oraddman.ts_label_group_assignments  "+
									 " set isactive_flag=?"+
									 ",LAST_UPDATED_BY=?"+
									 ",LAST_UPDATE_DATE=sysdate"+
									 " where LABEL_GROUP_CODE = ?"+
									 " and MODULE_CODE=?";
								st1 = con.prepareStatement(sql);
								st1.setString(1,"Y");
								st1.setString(2,UserName);
								st1.setString(3,LABEL_GROUP_CODE);
								st1.setString(4,MODULE_CODE); 
								st1.executeQuery();
								st1.close();
							}
							rs1.close();
							statement1.close();
						}
					}
					
					/*//add by Peggy 20211102
					sql= " delete oraddman.ts_label_group_conditions "+
						 " where LABEL_GROUP_CODE=?";
					st1 = con.prepareStatement(sql);
					st1.setString(1,LABEL_GROUP_CODE);
					st1.executeQuery();
					st1.close();	
					
					if (!CUST_SHIPPING_MARKS.equals(""))
					{
						String [] sArray = CUST_SHIPPING_MARKS.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"SHIPPING_MARKS");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}		
					}	

					if (!TSC_PARTNO.equals(""))
					{
						String [] sArray = TSC_PARTNO.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"TSC_PARTNO");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}	
					}			
						
					if (!ERP_FUNC.equals(""))
					{
						String [] sArray = ERP_FUNC.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"ERP_FUNC");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}	
					}			
						
					if (!OTHERS_RULE.equals(""))
					{
						sql = " insert into oraddman.ts_label_group_conditions"+
						      "(label_group_code"+
                              ",cond_item"+
							  ",cond_rule"+
							  ",last_update_date"+
							  ",last_updated_by"+
							  ")"+
							  " values"+
							  "("+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",sysdate"+
							  ",?"+
							  ")";
						st1 = con.prepareStatement(sql);
						st1.setString(1,LABEL_GROUP_CODE);	
						st1.setString(2,"OTHERS");	
						st1.setString(3,OTHERS_RULE);
						st1.setString(4,UserName);
						st1.executeQuery();
						st1.close();							  
					}									
					*/	

					con.commit();			
				%>
					<script language = "JavaScript">
						alert('修改成功!');
						window.opener.MYFORM.submit();
						setCancel();
					</script>
				<%		
				}		
				rs.close();
				statement.close();
			}
			else
			{
				sql = " select 1 from oraddman.ts_label_groups a "+
						  " where UPPER(a.label_group_name)=UPPER(?)"+
						  " and label_form_code=?"+
						  " and label_form_version=?";
				//out.println(sql);
				PreparedStatement statement = con.prepareStatement(sql);
				statement.setString(1,LABEL_GROUP_NAME);
				statement.setString(2,LABEL_FORM_CODE);
				statement.setString(3,LABEL_FORM_VERSION);
				ResultSet rs=statement.executeQuery();
				if (rs.next())
				{	
					throw new Exception("群組名稱已存在,不可重覆!");
				}
				else
				{	
					sql = " select 'G'||lpad(nvl(max(replace(LABEL_GROUP_CODE,'G','')),0)+1,3,'0') from oraddman.ts_label_groups a";
					//out.println(sql);
					PreparedStatement statement1 = con.prepareStatement(sql);
					ResultSet rs1=statement1.executeQuery();
					if (rs1.next())
					{
						LABEL_GROUP_CODE = rs1.getString(1);
					}
					rs1.close();
					statement1.close();	
									
					sql = " insert into oraddman.ts_label_groups "+
						  " (label_group_code"+
						  ",label_group_name"+
						  ",label_group_desc"+
						  ",label_group"+
                          ",effective_from_date"+
						  ",effective_to_date"+
						  ",creation_date"+
                          ",created_by"+
						  ",last_update_date"+
						  ",last_updated_by"+
						  ",remarks"+
						  ",label_form_code"+
						  ",label_form_version"+
						  ",label_where_condition)"+
						  " values ("+
						  " ?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",to_date(?,'yyyymmdd')"+
						  ",to_date(?,'yyyymmdd')"+
						  ",sysdate"+
						  ",?"+
						  ",sysdate"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?"+
						  ",?)";
					//out.println(sql);
					PreparedStatement st1 = con.prepareStatement(sql);
					st1.setString(1,LABEL_GROUP_CODE);	
					st1.setString(2,LABEL_GROUP_NAME);	
					st1.setString(3,LABEL_GROUP_DESC);
					st1.setString(4,LABEL_GROUP);
					st1.setString(5,(EFFECTIVE_FROM.equals("")?"":EFFECTIVE_FROM));
					st1.setString(6,(EFFECTIVE_TO.equals("")?"":EFFECTIVE_TO));
					st1.setString(7,UserName); 
					st1.setString(8,UserName); 
					st1.setString(9,REMARKS); 
					st1.setString(10,LABEL_FORM_CODE); 
					st1.setString(11,LABEL_FORM_VERSION); 
					st1.setString(12,LABEL_WHERE_CONDITION); 
					st1.executeQuery();
					st1.close();
					
					String chk[]= request.getParameterValues("chk");	
					if (chk.length >0)
					{
						for (int i=0; i< chk.length ;i++)
						{
							MODULE_CODE = chk[i];
				
							sql= " insert into oraddman.ts_label_group_assignments  "+
								 " (label_group_code"+
								 ", module_code"+
								 ", isactive_flag"+
								 ", creation_date"+
								 ", created_by"+
								 ", last_update_date"+
								 ", last_updated_by) "+
								 " values(?"+
								 ",?"+
								 ",?"+
								 ",sysdate"+
								 ",?"+
								 ",sysdate"+
								 ",?)";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);
							st1.setString(2,MODULE_CODE); 
							st1.setString(3,"Y");
							st1.setString(4,UserName);
							st1.setString(5,UserName);
							st1.executeQuery();
							st1.close();
						}
					}	
					
					/*if (!CUST_SHIPPING_MARKS.equals(""))
					{
						String [] sArray = CUST_SHIPPING_MARKS.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"SHIPPING_MARKS");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}	
					}
					
					if (!TSC_PARTNO.equals(""))
					{
						String [] sArray = TSC_PARTNO.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"TSC_PARTNO");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}	
					}	
					
					if (!ERP_FUNC.equals(""))
					{
						String [] sArray = ERP_FUNC.split("\n");
						for (int x =0 ; x < sArray.length ; x++)
						{
							sql = " insert into oraddman.ts_label_group_conditions"+
								  "(label_group_code"+
								  ",cond_item"+
								  ",cond_rule"+
								  ",last_update_date"+
								  ",last_updated_by"+
								  ")"+
								  " values"+
								  "("+
								  " ?"+
								  ",?"+
								  ",?"+
								  ",sysdate"+
								  ",?"+
								  ")";
							st1 = con.prepareStatement(sql);
							st1.setString(1,LABEL_GROUP_CODE);	
							st1.setString(2,"ERP_FUNC");	
							st1.setString(3,sArray[x].trim().toUpperCase());
							st1.setString(4,UserName);
							st1.executeQuery();
							st1.close();							  
						}	
					}						
					
					if (!OTHERS_RULE.equals(""))
					{
						sql = " insert into oraddman.ts_label_group_conditions"+
						      "(label_group_code"+
                              ",cond_item"+
							  ",cond_rule"+
							  ",last_update_date"+
							  ",last_updated_by"+
							  ")"+
							  " values"+
							  "("+
							  " ?"+
							  ",?"+
							  ",?"+
							  ",sysdate"+
							  ",?"+
							  ")";
						st1 = con.prepareStatement(sql);
						st1.setString(1,LABEL_GROUP_CODE);	
						st1.setString(2,"OTHERS");	
						st1.setString(3,OTHERS_RULE);
						st1.setString(4,UserName);
						st1.executeQuery();
						st1.close();							  
					}						
					*/
					
					con.commit();					
	
					out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
			%>
					<script language="javascript">
						setClear();
					</script>
			<%
				}
				rs.close();
				statement.close();
			}
		}
		catch(Exception e)
		{
			con.rollback();
			out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
		}
	}
}
catch(Exception e)
{
	out.println("<div align='center' style='color:#ff0000'>Exception1:"+e.getMessage()+"</DIV>");
}
%>
</FORM>
<iframe width=124 height=153 name="gToday:supermini:agenda.js" id="gToday:supermini:agenda.js" src="../calendar/ipopeng.htm" scrolling="no" frameborder="0" style="visibility:hidden; z-index:65535; position:absolute; top:0px;"></iframe>
</body>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</html>
