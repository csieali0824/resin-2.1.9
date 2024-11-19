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
function setSubmit(URL)
{ 
	var chkflag=false;
	var chk_len =0,chkcnt=0;
	if (document.MYFORM.PROD_TYPE_NAME.value=="")
	{
		alert("請輸入產品類別名稱!!");
		document.MYFORM.PROD_TYPE_NAME.focus();
		return false;
	}
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
		}
		else
		{
			chkflag = document.MYFORM.chk[i].checked; 
		}
		if (chkflag==true)
		{
			chkcnt++;
		}
	}
	if (chkcnt ==0)
	{
		alert("Please choose package item!");
		return false;
	}	
				
	document.MYFORM.btnSubmit.disabled =true;
	document.MYFORM.btnCancel.disabled =true;
	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setCheck(irow)
{
	var chkflag ="";
	if (document.MYFORM.chk.length != undefined)
	{
		chkflag = document.MYFORM.chk[irow].checked; 
	}
	else
	{
		chkflag = document.MYFORM.chk.checked; 
	}
	if (chkflag == true)
	{
		document.getElementById("tdd_"+irow).style.backgroundColor ="#D8E2E9";
	}
	else
	{
		document.getElementById("tdd_"+irow).style.backgroundColor ="#FFFFFF";
	}
}
function setSubmit1()
{   
	document.MYFORM.action="../jsp/TSA01WIPProdTypeQuery.jsp";
	document.MYFORM.submit();
}
function setSubmit2(URL)
{   
	if (confirm("您確定要離開回到上頁功能嗎?")==true) 
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
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
<title>A01 Prod Type Maintain</title>
</head>
<body>
<FORM NAME="MYFORM" ACTION="../jsp/TSA01WIPProdTypeModify.jsp" METHOD="POST"> 
<%
String STATUS = request.getParameter("STATUS");
if (STATUS==null) STATUS="";
String PROD_TYPE_NAME= request.getParameter("PROD_TYPE_NAME");
if (PROD_TYPE_NAME==null) PROD_TYPE_NAME="";
String PROD_TYPE_NO = request.getParameter("PROD_TYPE_NO");
if (PROD_TYPE_NO==null) PROD_TYPE_NO="";
String ACODE = request.getParameter("ACODE");
if (ACODE==null) ACODE="";
String sql ="";
int chk_row=8,row=0;
String v_no="";

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
			sql = "select DISTINCT PROD_TYPE_NAME from oraddman.tsa01_prod_type a "+
                  " where a.prod_type_no =?";
			//out.println(sql);
			PreparedStatement statement = con.prepareStatement(sql);
			statement.setString(1,PROD_TYPE_NO);
			ResultSet rs=statement.executeQuery();
			if (rs.next())
			{
				PROD_TYPE_NAME=rs.getString("PROD_TYPE_NAME");
			}
			else
			{
			%>
				<script language="JavaScript" type="text/JavaScript">
					alert("查無資料,請重新確認,謝謝!");
					setSubmit1();
				</script>
			<%				
			}
			rs.close();
			statement.close();
		}
	}
	
	if (ACODE.equals("SAVE"))
	{
		try
		{
			if (STATUS.equals("UPD"))
			{	
				sql= " delete oraddman.tsa01_prod_type"+
				     " where prod_type_no= ?";
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,PROD_TYPE_NO);
				st1.executeQuery();
				st1.close();
			}
			String chk[]= request.getParameterValues("chk");	
			if (chk.length <=0)
			{
				throw new Exception("未勾選package資料!!");
			}
			for(int i=0; i< chk.length ;i++)
			{
				if (i==0)
				{
					if (!STATUS.equals("UPD"))
					{				
						sql = " select lpad(nvl(max(substr(prod_type_no,-3)),0)+1,3,'0') from oraddman.tsa01_prod_type a ";
						//out.println(sql);
						PreparedStatement statement = con.prepareStatement(sql);
						ResultSet rs=statement.executeQuery();
						if (rs.next())
						{
							v_no= "A"+rs.getString(1);
						}
						rs.close();
						statement.close();
					}
					else
					{
						v_no=PROD_TYPE_NO;
					}
				}
				
				sql = " insert into oraddman.tsa01_prod_type"+
					  "(prod_type_no"+
					  ",prod_type_name"+
					  ",tsc_package"+
					  ",created_by"+
					  ",creation_date"+
					  ")"+
					  " values ("+
					  " ?"+
					  ",?"+
					  ",?"+
					  ",?"+
					  ",sysdate"+
					  ")";
				//out.println(sql);
				PreparedStatement st1 = con.prepareStatement(sql);
				st1.setString(1,v_no);	
				st1.setString(2,PROD_TYPE_NAME);
				st1.setString(3,chk[i]);
				st1.setString(4,UserName); 
				st1.executeQuery();
				st1.close();
			}
			con.commit();
		}
		catch(Exception e)
		{
			con.rollback();
			ACODE="";
			out.println("<div align='center' style='color:#ff0000'>交易失敗:"+e.getMessage()+"</div>");
		}
	}

%>
<INPUT TYPE="hidden" name="STATUS" value="<%=STATUS%>">
<table align="center" width="100%">
	<tr>
		<td align="center">
			<strong><font style="font-size:20px;color:#006666">A01產品類別維護</font></strong>		</td>
	</tr>
	<tr>
		<td align="right">&nbsp;</td>
	</tr>
	<tr>
		<td>
			<table width="100%"  align="CENTER" border="1" cellpadding="0" cellspacing="0" bordercolorlight="#999999" bordercolordark="#99CC99">
				<tr>
					<td width="10%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">產品類別名稱</span></td>
					<td nowrap><INPUT TYPE="TEXT" name="PROD_TYPE_NAME" value="<%=PROD_TYPE_NAME%>" size="30" style="font-family: Tahoma,Georgia;"><INPUT TYPE="hidden" name="PROD_TYPE_NO" value="<%=PROD_TYPE_NO%>"></td>
				</tr>
				<tr>
					<td width="10%" height="30" bgcolor="#C9E2D0" nowrap><span style="font-size:12px;color:#006666">TSC Package</span></td>
					<td nowrap>
					<%
						sql = " SELECT  A.SEGMENT1,COUNT(B.PROD_TYPE_NO) NO_CNT "+
						      ",NVL((SELECT DISTINCT 'Y' FROM oraddman.tsa01_prod_type x where x.prod_type_NO='"+PROD_TYPE_NO+"' AND x.TSC_PACKAGE=A.SEGMENT1),'N') CHK_FLAG"+
						      " FROM MTL_CATEGORIES_V  A"+
							  " ,(SELECT * FROM oraddman.tsa01_prod_type WHERE 1=1";
						if (STATUS.equals("UPD")) sql += " AND PROD_TYPE_NO <>'"+PROD_TYPE_NO+"'";
						sql+= " ) B"+
                              " WHERE A.STRUCTURE_NAME='Package'"+
							  " AND A.DISABLE_DATE IS NULL "+
                              " AND A.segment1=B.TSC_PACKAGE(+) "+
                              " GROUP BY A.SEGMENT1 "+
							  " union all"+
							  " SELECT TSC_PACKAGE AS SEGMENT1,0 NO_CNT,'Y' AS CHK_FLAG"+
							  " FROM oraddman.tsa01_prod_type x "+
							  " where x.prod_type_NO='"+PROD_TYPE_NO+"'"+
							  " AND NOT EXISTS (SELECT 1 FROM MTL_CATEGORIES_V Y WHERE Y.SEGMENT1 =X.TSC_PACKAGE)"+
							  " ORDER BY 1";
						PreparedStatement statement = con.prepareStatement(sql);
						ResultSet rs=statement.executeQuery();
						row=0;
						while (rs.next())
						{
							if (row==0)
							{
							%>
							<table>
							<%
							}
							if (((row+1) % chk_row)==1)
							{
							%>
							<tr>
							<%
							}
							%>
							<td id="tdd_<%=row%>" width="<%=Math.ceil(100/chk_row)%>%" <%=(rs.getString("chk_flag").equals("Y")?" style='background-color:#D8E2E9;'":" style='background-color:#ffffff;'")%>><input type="checkbox" name="chk" value="<%=rs.getString("SEGMENT1")%>" style="font-family: Tahoma,Georgia; color: #000000; font-size: 12px" onClick="setCheck(<%=row%>)" <%=(rs.getInt("no_cnt")>0?" disabled":"")%> <%=(rs.getString("chk_flag").equals("Y")?" checked":"")%>><font <%=(rs.getInt("no_cnt")>0?" style='color:#cccccc'":"color:#000000'")%>><%=rs.getString("SEGMENT1")%></font></td>
							<%
							if (((row+1) % chk_row)==0)
							{
							%>
							</tr>
							<%
							}
							row++;
						}
						if (row>0)
						{
						%>
							</table>
						<%
						}
						rs.close();
						statement.close();
						
					%>
					</td>
				</tr>	
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
    				<td width="16%"> <input type="button"  name="btnSubmit" onClick='setSubmit("../jsp/TSA01WIPProdTypeModify.jsp?STATUS=<%=STATUS%>&ACODE=SAVE")' value="存檔" style="font-family:'Tahoma,Georgia';font-size:12px">&nbsp;&nbsp;&nbsp;
     								<input type="button" name="btnCancel" onClick="setSubmit2('../jsp/TSA01WIPProdTypeQuery.jsp')" value="回上頁" style="font-family:'Tahoma,Georgia';font-size:12px">
					</td>    
  				</tr>
			</table>
		</td>
	</tr>
</table>
<%
	if (ACODE.equals("SAVE"))
	{
		if (STATUS.equals("UPD"))
		{
		%>
			<script language = "JavaScript">
				alert('修改成功!');
				setSubmit1();
			</script>
		<%				
		}
		else 
		{
			out.println("<div align='center' style='color:#0000ff'>新增成功!!</div>");
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
