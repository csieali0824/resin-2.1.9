<!-- 20150119 by Peggy,顯示Comment欄位-->
<!-- 20180530 by Peggy,1.show follow up email date-->
<!--                   2.show follow up reply date-->
<!--                   3.hide comment column-->
<!--                   4.add follow up export to excel function-->
<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*,java.io.*,jxl.*,jxl.write.*,jxl.format.*" %> 
<%@ page import="ComboBoxAllBean,DateBean,WorkingDateBean,ArrayComboBoxBean"%>
<script language="JavaScript" type="text/JavaScript">
function setSubmit(URL)
{  
	subWin=window.open(URL,"subwin","scrollbars=yes,menubar=yes,fullscreen=yes");
}
function setSubmit1(URL)
{    
	if (confirm("您確認要取消資料?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();
	}
}

function sendSubmit(URL)
{ 
	document.MYFORM.action=URL;
	document.MYFORM.submit(); 
}

function setSubmit2(URL)  //清除畫面條件,重新查詢!
{  
	document.MYFORM.MARKETTYPE.value =""; 
 	document.MYFORM.CLASSID.value =""; 
 	document.MYFORM.WONO.value ="";
 	document.MYFORM.INVITEM.value ="";
 	document.MYFORM.ITEMDESC.value ="";
 	document.MYFORM.WAFERLOT.value ="";
 	document.MYFORM.MONTHFR.value ="";
 	document.MYFORM.DAYFR.value ="";
 	document.MYFORM.MONTHTO.value ="";
 	document.MYFORM.DAYTO.value ="";
 	document.MYFORM.action=URL;
 	document.MYFORM.submit();
}

function setSubmit3(URL)  //清除畫面條件,重新查詢!
{  
	if (confirm("您確定要發送mail給Sales嗎?"))
	{
		subWin=window.open(URL,"subwin","width=840,height=150,scrollbars=yes,menubar=no");
	}
}
function custCommentQuery(id)
{    
	subWin=window.open("TSCMailCustomerComment.jsp?id="+id,"subwin","width=440,height=250,scrollbars=no,menubar=no,location=no");  
}

function setUpdate(URL)  
{  
	if (confirm("您確定要調整欄位顯示設定嗎?"))
	{
		document.MYFORM.action=URL;
		document.MYFORM.submit();	
	}
}
</script>
<html>
<head>
<STYLE TYPE='text/css'>  
BODY      { font-family: Tahoma,Georgia; color: #000000; font-size: 11px }
  P         { font-family: Tahoma,Georgia; color: #000000; font-size: 11px } 
  TD        { font-family: Tahoma,Georgia; color: #000000; font-size: 11px ;table-layout:fixed; word-break :break-all}  
  TEXTAREA  { font-family: Tahoma,Georgia; font-size: 11px }
  A         { text-decoration: underline }
  A:link    { color: #003399; text-decoration: underline }
  A:visited { color: #990066; text-decoration: underline }
  A:active  { color: #FF0000; text-decoration: underline }
  A:hover   { color: #FF0000; text-decoration: underline }
  .hotnews  {
              border-style: solid;
              border-width: 1px;
              border-color: #b0b0b0;
              padding-top: 2px;
              padding-bottom: 2px;
            }

}
</STYLE>
<title>Oracle Add On System Information Query</title>
<%@ include file="/jsp/include/AuthenticationPage.jsp"%>
<%@ include file="/jsp/include/ConnectionPoolPage.jsp"%>
<%@ page import="ComboBoxBean,DateBean,ArrayComboBoxBean,Array2DimensionInputBean" %>
<jsp:useBean id="comboBoxBean" scope="page" class="ComboBoxBean"/>
<!--jsp:useBean id="poolBean" scope="application" class="PoolBean"/-->
<jsp:useBean id="comboBoxAllBean" scope="page" class="ComboBoxAllBean"/>
<jsp:useBean id="arrayComboBoxBean" scope="page" class="ArrayComboBoxBean"/>
<jsp:useBean id="dateBean" scope="page" class="DateBean"/>
<jsp:useBean id="workingDateBean" scope="page" class="WorkingDateBean"/>
<%
String strYear = request.getParameter("SYEAR");
if (strYear == null) strYear ="";
String terrorty=request.getParameter("TERRORITY");
if (terrorty == null) terrorty = "";
String region=request.getParameter("REGION");
if (region == null) region ="";
String company=request.getParameter("COMPANY");
if (company == null) company ="";
String rdogp = request.getParameter("RDOGP");
if (rdogp == null) rdogp = "ALL";
String FirBtnStatus = "",PreBtnStatus = "",NxtBtnStatus = "",LstBtnStatus = "";
String QPage = request.getParameter("QPage");
if (QPage == null) QPage ="1";
int NowPage = Integer.parseInt(QPage);
int PageSize = 50,LastPage =0;
long dataCnt =0;
String strcomment ="";
String actcode=request.getParameter("ActionCode");
if (actcode==null) actcode="";
String row_id=request.getParameter("ID");
if (row_id==null) row_id="";
String ATYPE = request.getParameter("ATYPE");  //add by Peggy 20180531
if (ATYPE==null) ATYPE="";
String strQ1="",strQ2="",strQ3="",strQ4="",strQ5="",strQ6="",strQ7="",strQ8="",strQ9="",strQ10="";	

%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></head>
<body topmargin="0" bottommargin="0">    
<FORM ACTION="../jsp/TSCMailCollectQuestReport.jsp" METHOD="post" NAME="MYFORM">
<!--%/20040109/將Excel Veiw 夾在檔頭%-->
<font color="#003366" size="+2" face="Tahoma,Georgia"><font size="+3" face="Tahoma,Georgia"><font color="#3366FF" size="+2" face="Tahoma,Georgia"><font size="+3" face="Tahoma,Georgia"><font face="Courier, MS Sans Serif"><font color="#003366" size="+2" face="arial"><em>TSC</em></font></font></font></font><font face="Courier, MS Sans Serif"></font></font></font><font color="#006666" size="+2" face="Times New Roman"> 
<strong><a>客戶滿意度調查回函統計</a></strong></font>
<BR>
  <A href="/oradds/ORADDSMainMenu.jsp">回首頁</A><!--%/20040109/將Excel Veiw 夾在檔頭%-->
<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
	<tr>
		<td width="10%" bgcolor="#CCFFCC" style="color:#006666;font-family:Tahoma,Georgia" nowrap>YEAR</td>
		<td width="40%">
<%
	if (actcode.equals("cancel"))
	{
		String sql =" update oraddman.cust_mail " +
				" set ACTIVE_FLAG='N'"+
				" ,BATCH_MAILED=replace(BATCH_MAILED,'Y','N')"+
				" where rowid='"+row_id+"'";
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.executeUpdate();
		st1.close();	
	}
	
	//add by Pegy 20180531
	if (ATYPE.equals("Y"))
	{
		String sql =" update oraddman.cust_quest_define " +
				" set AUDIT_HIDE_FLAG=CASE WHEN NVL(AUDIT_HIDE_FLAG,'N') ='Y' THEN 'N' ELSE 'Y' END"+
				" where QUEST_CODE LIKE 'Q%' AND QUESTION_TYPE='COMMENT'";
		PreparedStatement st1 = con.prepareStatement(sql);
		st1.executeUpdate();
		st1.close();	
	}

	try
	{  
		Statement statement=con.createStatement();
		String sql = " select distinct YEAR||BIANNUAL_CODE syear,YEAR||BIANNUAL_CODE  FROM oraddman.cust_mail a where a.active_flag='Y' and YEAR is not null and BIANNUAL_CODE is not null order by YEAR||BIANNUAL_CODE desc  ";								  
		//out.println(sql);
        ResultSet rs=statement.executeQuery(sql);
		comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(strYear);
	   	comboBoxBean.setFieldName("SYEAR");	   
	   	out.println(comboBoxBean.getRsString());
	   	rs.close();   
		statement.close();
	}
    catch (Exception e) 
	{ 
		out.println("Exception1:"+e.getMessage()); 
	}	   
%>
		<INPUT TYPE="radio" NAME="RDOGP" value="ALL" <%=(rdogp.equals("ALL")?"checked":"")%>>All
		<INPUT TYPE="radio" NAME="RDOGP" value="YES" <%=(rdogp.equals("YES")?"checked":"")%>>Replied
		<INPUT TYPE="radio" NAME="RDOGP" value="NO"  <%=(rdogp.equals("NO")?"checked":"")%>>Not Reply
    	</td>  
	
	  	<td width="10%" bgcolor="#CCFFCC" style="color:#006666;font-family:Tahoma,Georgia" nowrap>TERRITORY</td> 
		<td width="40%">
<%		 
	try
	{  
		Statement statement=con.createStatement();
		String sql = " select DISTINCT a.TERRORITY, a.TERRORITY TER_GROUP from ORADDMAN.CUST_MAIL a, TSC_OM_GROUP b "+
			         " where a.TERRORITY = b.GROUP_NAME(+) and a.ACTIVE_FLAG ='Y' and a.YEAR>='2012'";							  
        ResultSet rs=statement.executeQuery(sql);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(terrorty);
	   	comboBoxBean.setFieldName("TERRORITY");	   
	   	out.println(comboBoxBean.getRsString());
	   	rs.close();   
	   	statement.close();
	}
    catch (Exception e) 
	{ 
		out.println("Exception2:"+e.getMessage()); 
	}	   
%>
	   </td>
	 </TR>
	 <TR>
		<td width="8%" bgcolor="#CCFFCC" style="color:#006666;font-family:Tahoma,Georgia" nowrap>REGION</td>   
		<td width="10%">   
<%
	try
    {  
		//-----取國別  
		Statement stateRegn=con.createStatement();
	   	String sql = " select DISTINCT REGION, REGION from ORADDMAN.CUST_MAIL where ACTIVE_FLAG='Y' and REGION is not null and YEAR>='2012' ";
	   	ResultSet rs=stateRegn.executeQuery(sql);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(region);
	   	comboBoxBean.setFieldName("REGION");	   
	   	out.println(comboBoxBean.getRsString());
	   	rs.close();   
	   	stateRegn.close();  
	}
    catch (Exception e) 
	{ 
		out.println("Exception3:"+e.getMessage()); 
	} 
%>		   
		</td>    
	   	<td width="8%" bgcolor="#CCFFCC" style="color:#006666;font-family:Tahoma,Georgia" nowrap>COMPANY</td>
	   	<td width="40%">
<%
	try
    {  
		//-----取公司別  
	   	Statement stateComp=con.createStatement();
	   	String sql = " select DISTINCT COMPANY, COMPANY from ORADDMAN.CUST_MAIL where ACTIVE_FLAG='Y' and COMPANY is not null and YEAR>='2012'";
	   	ResultSet rs=stateComp.executeQuery(sql);
	   	comboBoxBean.setRs(rs);
	   	comboBoxBean.setSelection(company);
	   	comboBoxBean.setFieldName("COMPANY");	   
	   	out.println(comboBoxBean.getRsString());
	   	rs.close();   
	   	stateComp.close();  
	}
    catch (Exception e) 
	{ 
		out.println("Exception4:"+e.getMessage()); 
	} 
%>
		</td>
	</tr>
	<tr>
		<td colspan="4" align="center">
		    <INPUT TYPE="button" align="middle" value='查詢'  onClick='sendSubmit("../jsp/TSCMailCollectQuestReport.jsp")' style="font-size:11px;font-family:Tahoma,Georgia;">&nbsp;&nbsp;&nbsp; 				
			<INPUT TYPE="button" align="middle" value='EXCEL' style="font-size:11px;font-family:Tahoma,Georgia" onClick='sendSubmit("../jsp/TSCMailCollectQuestExcelReport.jsp")'> &nbsp;&nbsp;&nbsp; 
			<INPUT TYPE="button" align="middle" value='FOLLOW UP TO EXCEL' style="font-size:11px;font-family:Tahoma,Georgia" onClick='sendSubmit("../jsp/TSCMailCollectQuestFollowupExcelReport.jsp")' > 
		</td>
   	</tr>
</table>
<%
try
{   
	String sSql =  " select b.* ,decode(b.cnt ,0, '' ,round(b.tot / b.cnt ,2)) avg "+
	        " from (select * from (select a.*,row_number() over (order by a.SYEAR desc,a.TERRORITY,a.COMPANY,to_number(a.id)) rowno "+
	        " from (select b.rowid row_id, b.YEAR || b.BIANNUAL_CODE SYEAR,b.id customer_id, a.ID, b.NAME, b.DEPARTMENT, b.TITLE, b.COMPANY, b.EMAIL, b.TELEPHONE, b.FAX,b.SALES_EMAIL,b.SALES_MANAGER_EMAIL,b.HQ_SALES_EMAIL,b.TERRORITY, "+
			" a.Q1, a.Q2, a.Q3, a.Q4, a.Q5, a.Q6, a.Q7, a.Q8, a.Q9, a.Q10, replace(a.COMMENTS,chr(10),'') COMMENTS,"+
			" TO_CHAR(TO_DATE(a.CREATION_DATE,'YYYYMMDDHH24MISS'),'YYYY/MM/DD') CREATION_DATE, "+
			" a.orig_rowid,row_number() over (PARTITION BY a.YEAR||a.BIANNUAL_CODE, b.id ORDER BY NVL(a.CREATION_DATE,b.CREATION_DATE) desc) row_num,"+
			" (NVL(a.Q1,0)+NVL(a.Q2,0)+NVL(a.Q3,0)+NVL(a.Q4,0)+NVL(a.Q5,0)+NVL(a.Q6,0)+NVL(a.Q7,0)+NVL(a.Q8,0)+NVL(a.Q9,0)+NVL(a.Q10,0)) tot,"+
			" (NVL2(a.Q1,1,0)+NVL2(a.Q2,1,0)+NVL2(a.Q3,1,0)+NVL2(a.Q4,1,0)+NVL2(a.Q5,1,0)+NVL2(a.Q6,1,0)+NVL2(a.Q7,1,0)+NVL2(a.Q8,1,0)+NVL2(a.Q9,1,0)+NVL2(a.Q10,1,0)) cnt"+
			" ,TO_CHAR(a.FOLLOWUP_EMAIL_DATE,'yyyymmdd') FOLLOWUP_EMAIL_DATE ,TO_CHAR(a.FOLLOWUP_REPLY_DATE,'yyyymmdd') FOLLOWUP_REPLY_DATE,TO_CHAR(a.FOLLOWUP_CLOSED_DATE,'yyyymmdd') FOLLOWUP_CLOSED_DATE"+ //add by Peggy 20180530
			" ,(SELECT  NVL(AUDIT_HIDE_FLAG,'N')  FROM oraddman.cust_quest_define k where k.QUEST_CODE LIKE 'Q%' AND k.QUESTION_TYPE='COMMENT') AUDIT_HIDE_FLAG"+  //add by Peggy 20180531
			" from ORADDMAN.CUST_MAIL b "+
			",ORADDMAN.CUST_COLLECT_QUESTIONNAIRE a "+
			" where  b.rowid= a.orig_rowid(+) "+
			" and b.id is not null "+
			" and b.YEAR is not null "+
			" and b.BIANNUAL_CODE is not null"+
			" and b.ACTIVE_FLAG='Y'";
	if (rdogp.equals("NO"))
	{
      	sSql  +=" AND a.q1 is null  AND a.q2 is null  AND a.q3 is null AND a.q4 is null AND a.q5 is null AND a.q6 is null AND a.q7 is null AND a.q8 is null AND a.q9 is null AND a.q10 is null ";
	}
	if (strYear!=null && !strYear.equals("--") && !strYear.equals("")) sSql += " and b.YEAR||b.BIANNUAL_CODE ='"+strYear+"'"; 	
	if (terrorty!=null && !terrorty.equals("--") && !terrorty.equals("")) sSql +=" and b.TERRORITY ='"+terrorty+"'"; 
	if (region!=null && !region.equals("--") && !region.equals("")) sSql +=" and b.REGION ='"+region+"'"; 
	if (company!=null && !company.equals("--") && !company.equals(""))  sSql +=" and b.COMPANY ='"+company+"' ";
	sSql += ") a where a.row_num=1) b  where 1=1 ";
	if (rdogp.equals("YES"))
	{
		sSql += " and (Q1 is not null or Q2 is not null or Q3 is not null or Q4 is not null or Q5 is not null or Q6 is not null"+
			    " or Q7 is not null or Q8 is not null or Q9 is not null or Q10 is not null)";
	}
	sSql += " ) b ";
	//統計筆數
	//out.println(sSql);
	String sqlt = " select count(1) rowcnt from ("+sSql+") ss";
	Statement statement1=con.createStatement(); 
	ResultSet rs1 =statement1.executeQuery(sqlt);
	while (rs1.next())
	{
		//總筆數
		dataCnt = Long.parseLong(rs1.getString("rowcnt"));
		//最後頁數
		LastPage = (int)Math.ceil((float)dataCnt / (float)PageSize);
	}
	rs1.close();
	statement1.close();
	
	//select資料
	sSql +=" where rowno >= (("+NowPage+"-1)*"+PageSize+")+1 and rowno <= ("+NowPage+"*"+PageSize+")  order by rowno";
	//out.println(sSql);
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery(sSql);
	int rowcnt =0;
	while(rs.next())
	{
		if (rowcnt ==0)
		{
%>
<table WIDTH="1300" border="0">
	<tr>
		<td>
			<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>
				<tr>
					<td width="20%" style="font-size:12px;font-family:細明體;color=#CC0066"><img border="0" src="images/updateicon_enabled.gif" height="18" title="顯示資料" onClick="setUpdate('../jsp/TSCMailCollectQuestReport.jsp?ATYPE=Y')"><%="查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁"%></td>
					<%
					if (LastPage==1)
					{
						FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
					}
					else if (NowPage == 1)
					{
						FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
					}
					else if (NowPage == LastPage)
					{
						FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
					}				
					else
					{
						FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
					}
					%>
					<td width="10%">&nbsp;</td>
					<td width="20%" align="center"><input type=button name="FPage" id="FPage" value="<<" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=1')" <%= FirBtnStatus%> title="First Page" style="font-size:11px;font-family:Tahoma,Georgia;">
					&nbsp;
						<input type=button name="PPage" id="PPage" value="<" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=NowPage-1%>')" <%=PreBtnStatus%> title="Previous Page" style="font-size:11px;font-family:Tahoma,Georgia;">
					&nbsp;&nbsp;
					<font face="細明體" color="#CC0066" size="2">第<%=NowPage%>頁</font>&nbsp;&nbsp;
					<input type=button name="NPage" id="NPage" value=">" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=NowPage+1%>')" <%=NxtBtnStatus%> title="Next Page" style="font-size:11px;font-family:Tahoma,Georgia;">
					&nbsp;
					<input type=button name="LPage" id="LPage" value=">>" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=LastPage%>')" <%=LstBtnStatus%> title="Last Page" style="font-size:11px;font-family:Tahoma,Georgia;">
					</td>
					<td width="20%">&nbsp;</td>
					<td width="20%">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
	<TR>
		<TD>
			<table cellspacing="0" bordercolordark="#999966" cellpadding="1" width="100%" align="center" bordercolorlight="#ffffff" border="1">
    			<tr bgcolor="#CCFFCC"> 
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>&nbsp;</td> 
				  <%
				  if (UserRoles.equals("admin") || UserRoles.indexOf("CSQ")>=0)
				  {
				  %>
				  <td width="20"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>&nbsp;</td>               
				  <%
				  }
				  %>
				  <td width="55"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>&nbsp;</td>   
				  <% if (1==1){%>
				  <td width="55"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>&nbsp;</td>               
				  <td width="65"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Followup<br>Close Date</td>               
				  <%}%>
				  <td width="50"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>YEAR</td>               
				  <td width="50"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>TERRITORY</td>          
				  <td width="160" align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>COMPANY</td>
				  <td width="100"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>NAME</td> 	  
				  <td width="140" align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>EMAIL</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q1</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q2</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q3</td>	
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q4</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q5</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q6</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q7</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q8</td>	
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q9</td>
				  <td width="30"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Q10</td>
				  <td width="40"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>AVG</td>  	 
				  <%
				  if (rs.getString("AUDIT_HIDE_FLAG").equals("N"))
				  {
				  %> 	  
				  <td width="130"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Comment</td>
				  <%
				  }
				  %>
				  <td width="130" align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Sales Email</td>
				  <td width="130" align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>Sales Supervisor Email</td>
				<%
					if (rdogp.equals("NO"))
					{
				%>
				  <td width="130"  align="center" style="color:#006666;font-family:Tahoma,Georgia" nowrap>HQ Contact Sales Email</td>	
				<%	
					}
					else
					{
				%>  
				</tr>
			<%
					}
		}
			strcomment = rs.getString("comments");
			if (strcomment==null) strcomment= "No Comment!!";
			strcomment = strcomment.replace("'","\\'");
			%>

				<tr> 
				  <td bgcolor="#CCFFCC" align="center" style="color:#006666;font-family:Tahoma,Georgia"><a name='#<%=rs.getString("ID")%>'><%=(NowPage-1)*PageSize+rowcnt+1%></a></td>
				  				  <%
				  if (UserRoles.equals("admin") || UserRoles.indexOf("CSQ")>=0)
				  {
				  %>
				  <td align="center" style="font-family:Tahoma,Georgia;color:#000033"><input type="button" name="<%=rs.getString("SYEAR")+"_"+rs.getString("ID")%>" value="取消" onClick='setSubmit1("../jsp/TSCMailCollectQuestReport.jsp?ActionCode=cancel&ID=<%=rs.getString("ROW_ID")%>")' style="font-size:11px;font-family:Tahoma,Georgia;"></td>
				  <%
				  }
				  %>
				  <td align="center" style="font-family:Tahoma,Georgia;color:#000033">
				  <%
				  if (rs.getString("ID")!=null)
				  {
				  %>
				  <img name='popcal' border='0' src='../image/smail.png' onClick='setSubmit3("../jsp/TscMailQuestTraceability.jsp?ID=<%=rs.getString("ID")%>&SYEAR=<%=rs.getString("SYEAR")%>")'>
				  <%=(rs.getString("FOLLOWUP_EMAIL_DATE")==null?"":"<br>"+rs.getString("FOLLOWUP_EMAIL_DATE"))%>
				  <%
				  }
				  else
				  {
				  	out.println("&nbsp;");
				  }
				  %>
				  </td>
				  <%
				  if (1==1)
				  {
				  %>
				  <td align="center" style="font-family:Tahoma,Georgia;color:#000033">
				  <%
				  if (rs.getString("ID")!=null)
				  {
				  %>
				  <img name='popcal' border='0' src='../image/open.gif' onClick='setSubmit("../jsp/TscMailQuestTraceabilityReply.jsp?id=<%=rs.getString("customer_id")+rs.getString("row_id")%>")'>
				  <%=(rs.getString("FOLLOWUP_REPLY_DATE")==null?"":"<br>"+rs.getString("FOLLOWUP_REPLY_DATE"))%>
				  <%
				  }
				  else
				  {
				  	out.println("&nbsp;");
				  }
				  %>
				  </td>		
				  <td align="center" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("FOLLOWUP_CLOSED_DATE")==null?"&nbsp;":rs.getString("FOLLOWUP_CLOSED_DATE"))%></td>	  
				  <%}%>
				  <td align="center" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("SYEAR")==null ||rs.getString("SYEAR").equals("null")?"&nbsp;":rs.getString("SYEAR"))%></td>
				  <!--<td align="left" style="font-family:Tahoma,Georgia;color:#000033"><a href='javaScript:custCommentQuery("<%=rs.getString("ID")%>")' onMouseOver="this.T_ABOVE=false;this.T_WIDTH=180;this.T_OPACITY=80;return escape('<%=strcomment%>')"><%=rs.getString("CUSTOMER_ID")%></a></td>-->
				  <!--<td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=rs.getString("CUSTOMER_ID")%></td>-->
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("TERRORITY")==null ||rs.getString("TERRORITY").equals("null")?"&nbsp;":rs.getString("TERRORITY"))%></td>
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("COMPANY")==null ||rs.getString("COMPANY").equals("null")?"&nbsp;":rs.getString("COMPANY"))%></td>
				  <!--<td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("DEPARTMENT")==null ||rs.getString("DEPARTMENT").equals("null")?" ":rs.getString("DEPARTMENT"))%></td>-->
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=rs.getString("NAME")%></td>	  
				  <!--<td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("TITLE")==null || rs.getString("TITLE").equals("null") || rs.getString("TITLE").equals("")?"&nbsp;":rs.getString("TITLE"))%></td>-->
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("EMAIL")==null || rs.getString("EMAIL").equals("null") || rs.getString("EMAIL").equals("")?"&nbsp;":rs.getString("EMAIL"))%></td>	  
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q1")!=null && rs.getInt("Q1")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q1")==null?"&nbsp;":rs.getString("Q1"))%></td>
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q2")!=null && rs.getInt("Q2")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q2")==null?"&nbsp;":rs.getString("Q2"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q3")!=null && rs.getInt("Q3")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q3")==null?"&nbsp;":rs.getString("Q3"))%></td>
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q4")!=null && rs.getInt("Q4")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q4")==null?"&nbsp;":rs.getString("Q4"))%></td>  
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q5")!=null && rs.getInt("Q5")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q5")==null?"&nbsp;":rs.getString("Q5"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q6")!=null && rs.getInt("Q6")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q6")==null?"&nbsp;":rs.getString("Q6"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q7")!=null && rs.getInt("Q7")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q7")==null?"&nbsp;":rs.getString("Q7"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q8")!=null && rs.getInt("Q8")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q8")==null?"&nbsp;":rs.getString("Q8"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q9")!=null && rs.getInt("Q9")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q9")==null?"&nbsp;":rs.getString("Q9"))%></td> 
				  <td align="center" style="font-family:Tahoma,Georgia;<%=(rs.getString("Q10")!=null && rs.getInt("Q10")<3?"font-weight:bold;color:#ff0000":"color:#000033")%>"><%=(rs.getString("Q10")==null?"&nbsp;":rs.getString("Q10"))%></td> 
				  <td align="center" style="font-weight:bold;font-family:Tahoma,Georgia;<%=(rs.getString("AVG")!=null && rs.getFloat("AVG")<3?"color:#ff0000":"color:#3300CC")%>"><%=(rs.getString("AVG")==null?"&nbsp;":rs.getString("AVG"))%></td>
				  <%
				  if (rs.getString("AUDIT_HIDE_FLAG").equals("N"))
				  {
				  %> 				  
				  <td style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("comments")==null?"&nbsp;":rs.getString("comments"))%></td>
				  <%
				  }
				  %>
				  <!--<td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("TELEPHONE")==null || rs.getString("TELEPHONE").equals("null") || rs.getString("TELEPHONE").equals("")?"&nbsp;":rs.getString("TELEPHONE"))%></td>-->
				  <!--<td nowrap align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("FAX")==null||rs.getString("FAX").equals("null")?"&nbsp;":rs.getString("FAX"))%></td>-->
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("SALES_EMAIL")==null?"&nbsp;":rs.getString("SALES_EMAIL"))%></td>
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("SALES_MANAGER_EMAIL")==null?"&nbsp;":rs.getString("SALES_MANAGER_EMAIL"))%></td> 
			<%
				if (rdogp.equals("NO"))
				{
			%>
				  <td align="left" style="font-family:Tahoma,Georgia;color:#000033"><%=(rs.getString("HQ_SALES_EMAIL")==null?"&nbsp;":rs.getString("HQ_SALES_EMAIL"))%></td>
			<%
				}
				else
				{
			%>
				</tr>	
			<%
				}
		rowcnt++;
	}
	rs.close();
	st.close();
%>
	</table></TD></TR>
<%	
	if (rowcnt >=25)
	{
%>
	<tr>
		<td>
			<table cellspacing='0' bordercolordark='#FFFFFF'  cellpadding='0' width='100%' align='left' bordercolorlight='#ffffff' border='0'>
				<tr>
					<td width="20%" style="font-size:12px;font-family:細明體;color=#CC0066"><%="查詢結果共"+ dataCnt +"筆資料，每頁顯示"+PageSize+"筆/共"+LastPage+"頁"%></td>
					<%
					if (LastPage==1)
					{
						FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
					}
					else if (NowPage == 1)
					{
						FirBtnStatus = "disabled";PreBtnStatus = "disabled";NxtBtnStatus = "";LstBtnStatus = "";
					}
					else if (NowPage == LastPage)
					{
						FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "disabled";LstBtnStatus = "disabled";
					}				
					else
					{
						FirBtnStatus = "";PreBtnStatus = "";NxtBtnStatus = "";LstBtnStatus = "";
					}
					%>
					<td width="20%">&nbsp;</td>
					<td width="20%" align="center"><input type=button name="FPage" id="FPage" value="<<" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=1')" <%= FirBtnStatus%> title="First Page">
					&nbsp;
						<input type=button name="PPage" id="PPage" value="<" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=NowPage-1%>')" <%=PreBtnStatus%> title="Previous Page">
					&nbsp;&nbsp;
					<font face="細明體" color="#CC0066" size="2">第<%=NowPage%>頁</font>&nbsp;&nbsp;
					<input type=button name="NPage" id="NPage" value=">" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=NowPage+1%>')" <%=NxtBtnStatus%> title="Next Page">
					&nbsp;
					<input type=button name="LPage" id="LPage" value=">>" onClick="sendSubmit('../jsp/TSCMailCollectQuestReport.jsp?QPage=<%=LastPage%>')" <%=LstBtnStatus%> title="Last Page">
					</td>
					<td width="20%">&nbsp;</td>
					<td width="20%">&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%
	}
}
catch (Exception e)
{
	out.println("Exception6:"+e.getMessage());
}
%>
</table>
</FORM>
<script language="JavaScript" type="text/javascript" src="wz_tooltip.js" ></script>
<BR>
<!--=============以下區段為釋放連結池==========-->
<%@ include file="/jsp/include/ReleaseConnPage.jsp"%>
<!--=================================-->
</body>
</html>

